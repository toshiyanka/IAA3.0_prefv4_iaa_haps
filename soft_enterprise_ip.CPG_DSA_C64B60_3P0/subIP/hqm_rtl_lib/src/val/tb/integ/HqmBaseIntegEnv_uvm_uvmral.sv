//-----------------------------------------------------------------------------
// INTEL CONFIDENTIAL
// Copyright (2016) Intel Corporation All Rights Reserved. 
// The source code contained or described herein and all documents related to
// the source code ("Material") are owned by Intel Corporation or its suppliers
// or licensors. Title to the Material remains with Intel Corporation or its
// suppliers and licensors. The Material contains trade secrets and proprietary
// and confidential information of Intel or its suppliers and licensors. The
// Material is protected by worldwide copyright and trade secret laws and 
// treaty provisions. No part of the Material may be used, copied, reproduced,
// modified, published, uploaded, posted, transmitted, distributed, or disclosed
// in any way without Intel's prior express written permission.
//
// No license under any patent, copyright, trade secret or other intellectual 
// property right is granted to or conferred upon you by disclosure or delivery
// of the Materials, either expressly, by implication, inducement, estoppel or
// otherwise. Any license under such intellectual property rights must be 
// express and approved by Intel in writing.
//------------------------------------------------------------------------------
// File   : HqmBaseIntegEnv.sv
// Author : Carl Angstadt
//
// Description :
//
// Base IntegEnv for the HQM Agent
//------------------------------------------------------------------------------
`include "uvm_macros.svh"
`include "slu_macros.svh"

`ifdef XVM
   `include "ovm_macros.svh"
   `include "sla_macros.svh"
`endif


import hqm_tb_cfg_pkg::*;
import hcw_transaction_pkg::*;
import hcw_pkg::*;
import hqm_cfg_pkg::*;


`include "hqm_map_block.svh"


class HqmBaseIntegEnv extends slu_tb_env;
  `uvm_component_utils(HqmBaseIntegEnv)

  HqmIpCfg              hqmCfg;
  static string HqmIpCfgProgmmer  = "HqmIpCfgProg"; 


  hqm_map_block        hqm_ral_env;
  ////--08122022  hqm_sla_env           hqmSlaEnv;

  string 		hqm_rtl_path;
  string                hqm_ral_env_name;
  //--TMP_NOT_SUPPORTED  hqm_ral_backdoor      i_hqm_ral_backdoor;
  string                hqm_config_suffix;  
       
   
  function new(string name = "HqmBaseIntegEnv", uvm_component parent = null);
    super.new(name, parent);

  endfunction: new

  ///////////////////////////////////////////////////////////////////////
  // createCfg  
  ///////////////////////////////////////////////////////////////////////
  function HqmIpCfg createCfg(HqmIpCfg my_cfg = null, string name = "HqmIpCfg");
      createCfg = my_cfg;

      if(createCfg == null) begin 
         `uvm_info(get_full_name(), $psprintf("HqmBaseIntegEnv::createCfg was null creating new config object using programmer"), UVM_LOW)
          if(($cast(createCfg,uvm_coreservice_t::get().get_factory().create_object_by_name(HqmIpCfgProgmmer, name))==0) || (createCfg == null)) 
            `uvm_error(get_full_name(), "HqmBaseIntegEnv::createCfg could not create HqmIpCfg object");
      end 
      return createCfg;
  endfunction


  ///////////////////////////////////////////////////////////////////////
  // assignCfg  
  ///////////////////////////////////////////////////////////////////////
  virtual function void assignCfg(HqmIpCfg cfgobj = null);
        if(cfgobj != null) begin
            $cast(hqmCfg, cfgobj);
        end else begin
            cfgobj = createCfg();
            $cast(hqmCfg, cfgobj);
        end 
        `uvm_info(get_full_name(), $psprintf("HqmBaseIntegEnv::assignCfg hqmCfg"), UVM_LOW)
  endfunction

  ///////////////////////////////////////////////////////////////////////
  // Build
  ///////////////////////////////////////////////////////////////////////
virtual function void build_phase(uvm_phase phase); 

    `uvm_info(get_full_name(), $psprintf("HqmBaseIntegEnv::build "), UVM_LOW)

    hqm_ral_env_name = {"hqmSlaEnv_",hqmCfg.inst_suffix};
    ////--08122022    hqmSlaEnv = hqm_sla_env::type_id::create(hqm_ral_env_name, this);
    ////--08122022    hqmSlaEnv.set_level(SLA_SUB);
    if (hqmCfg.inst_suffix == "hqm") begin
      hqm_config_suffix = "";
    end else begin
      hqm_config_suffix = hqmCfg.inst_suffix;
    end 
    ////--08122022 //--TMP_NOT_SUPPORTED    i_hqm_ral_backdoor = hqm_ral_backdoor::type_id::create("i_hqm_ral_backdoor", this);

    super.build_phase(phase);    

    //-----------------------
    if (hqmCfg.inst_suffix == "hqm") begin
      uvm_pkg::uvm_config_object::set(this, "*", "hqm_mem_map_obj",  hqmCfg.mem_map_obj);
    end else begin
      uvm_pkg::uvm_config_object::set(this, "*", $psprintf("hqm_mem_map_obj%s",hqmCfg.inst_suffix),  hqmCfg.mem_map_obj);
      `uvm_info(get_full_name(), $psprintf("set_config_object hqm_mem_map_obj%s", hqmCfg.inst_suffix), UVM_NONE);
    end 

    //-----------------------
    uvm_config_string::get(this, "","HQM_RTL_TOP", hqm_rtl_path);
    uvm_report_cb::add(null, slu_ral_report_catcher::get()); // Set report catcher to demote incorrect UVM_WARNING
         
    //  ***** Building the UVM RAL model *****
    // Null check register model to ensure the SOC_env hasn't supplied a 'built' register model handle.
    // If register model handle is NULL, then this is IP level validation and hence conitnue instantiating and building the regmodel
    if(hqm_ral_env == null) begin
            // Step 1-A : Instantiating the register model
            hqm_ral_env = hqm_map_block::type_id::create("hqm_ral_env",this);
 
            // Step 1-B : Building all the registers and maps
            hqm_ral_env.build();                   // UVM RAL is an uvm_object. This build() function is NOT SAME as UVM build phase
 
            // Step 1-C : Defining the top level RTL path
            hqm_ral_env.set_hdl_path_root(hqm_rtl_path);  // Sets the top level HDL path -> string option needed
 
            // Step 1-D : Configuring the register model proeprties
            slu_ral_db::set_sai_check();            // Enable SAI checking - if not already set in extended regmodel
            slu_ral_db::set_random_legal_sai_gen(); // Enable random legal sai generation - if not already set in extended regmodel
             
            // Step 1-E : In case of multiple sequencers per reg map, assign Saola Virtual Frontdoor Sequencer
            //--HQMV30_O2U_RAL_TBD : doesn't compile  --  slu_ral_db::add_virtual_frontdoor(hqm_ral_env,this);  // Initialize the Saola UVM RAL virtual Sequencer, and adds it to all root maps under the regmodel
    end
         
    `uvm_info(get_full_name(), $psprintf("HqmBaseIntegEnv - build_phase::Testbench=%s, REGMODEL=%s, hqm_rtl_path=%s", this.get_full_name(), hqm_ral_env.get_full_name(), hqm_rtl_path), UVM_NONE)
    `uvm_info(get_full_name(), $psprintf("HqmBaseIntegEnv - build_phase::hqm_config_suffix=%0s hqm_ral_env_name=%0s - hqmCfg.inst_suffix=%0s", hqm_config_suffix, hqm_ral_env_name, hqmCfg.inst_suffix), UVM_NONE);

  endfunction : build_phase
   
  ///////////////////////////////////////////////////////////////////////
  // connect
  ///////////////////////////////////////////////////////////////////////   
  function void connect_phase(uvm_phase phase); 
    int gnt_delay;

    super.connect_phase(phase); 

    //----------------------
    // Step 2-A : Set the register model. This locks the regmodel, adds callbacks and stores the pointer to access it anywhere
    slu_ral_db::set_regmodel(hqm_ral_env);
    // Step 2-C : Reset the regmodel to apply all reset values into the regmodel mirrored values
    hqm_ral_env.reset();  


    //----------------------
    gnt_delay = 11;

    if ($value$plusargs("hqm_iosf_prim_gnt_delay=%d",gnt_delay)) begin
      if ($test$plusargs("HQM_PRIM_CLK_1_GHZ")) begin
        hqmCfg.iosf_pagt_dut_cfg.pGntParallelDelay[0]    = gnt_delay * 1.000ns;
        hqmCfg.iosf_pagt_dut_cfg.npGntParallelDelay[0]   = gnt_delay * 1.000ns;
        hqmCfg.iosf_pagt_dut_cfg.cGntParallelDelay[0]    = gnt_delay * 1.000ns;
      end else begin
        hqmCfg.iosf_pagt_dut_cfg.pGntParallelDelay[0]    = gnt_delay * 1.250ns;
        hqmCfg.iosf_pagt_dut_cfg.npGntParallelDelay[0]   = gnt_delay * 1.250ns;
        hqmCfg.iosf_pagt_dut_cfg.cGntParallelDelay[0]    = gnt_delay * 1.250ns;
      end 
    end 
  endfunction : connect_phase

  ///////////////////////////////////////////////////////////////////////
  // end_of_elaboration
  ///////////////////////////////////////////////////////////////////////
function void end_of_elaboration_phase(uvm_phase phase); 
    super.end_of_elaboration_phase(phase);
  
    uvm_config_string::get(this, "","HQM_RTL_TOP", hqm_rtl_path); 
    hqmCfg.hqm_fuse_rtl_path = hqm_rtl_path; 
  endfunction : end_of_elaboration_phase
  
  ///////////////////////////////////////////////////////////////////////
  // set_fuse_override_values
  ///////////////////////////////////////////////////////////////////////
  function void set_fuse_override_values();
    `uvm_info(get_name(), "Got handle to parent HQM AGENT ENV. Overriding fuses", UVM_LOW);
     set_fal(hqmCfg.hqm_fuses);
  endfunction

  ///////////////////////////////////////////////////////////////////////
  // set_fal
  ///////////////////////////////////////////////////////////////////////
  function void set_fal(hqm_fuse_ovrd_config i_fuse_ovrd_config);
    bit [255:0] fuse_cfg_val; // assumption is max fuse size for override is 256. If it is more than this, then need to increase this accordingly.
    bit [255:0] fuse_ovrd_val; // assumption is max fuse size for override is 256. If it is more than this, then need to increase this accordingly.
    bit val[];
    logic val_logic[];
    logic desired_val[];
    sla_fuse current_fuses[$];
    sla_fuse_group hqm_fuse_g;
    sla_fuse_env fal;

    fal = get_fuse_env();//slu_fuse_env::get_ptr();

    // Temp til fuse RDL updated
    hqm_fuse_g = fal.get_group_by_name(hqmCfg.hqm_fuse_group);
 
    hqm_fuse_g.set_fuse_id(8'h01);
    hqm_fuse_g.set_hdl_path(hqm_rtl_path);     
    fal.add_group(hqm_fuse_g);
     
    foreach(i_fuse_ovrd_config.Fuse_name[i])
      begin
          fal.fuses[i_fuse_ovrd_config.Fuse_name[i]].get_cfg_val(val);

          fuse_ovrd_val = 0;
          fuse_cfg_val = 0;
          fuse_ovrd_val = $psprintf("%x",i_fuse_ovrd_config.Fuse_ovrd_value[i_fuse_ovrd_config.Fuse_name[i]]);
          foreach (val[index])
            begin
              fuse_cfg_val[index] = val[index];
              val[index] = fuse_ovrd_val[index]; 
            end 

            fal.fuses[i_fuse_ovrd_config.Fuse_name[i]].set_cfg_val(val);

            `uvm_info(get_full_name(), $psprintf("fuse_ovrd FUSE OVERRIDE:HQM Agent_fuse_env Original value of fuse %s was 0x%0h, now is 0x%0h", i_fuse_ovrd_config.Fuse_name[i], fuse_cfg_val, i_fuse_ovrd_config.Fuse_ovrd_value[i_fuse_ovrd_config.Fuse_name[i]]), UVM_INFO)
      end 
  endfunction : set_fal

  ///////////////////////////////////////////////////////////////////////
  // update_ral_file_bus_values
  ///////////////////////////////////////////////////////////////////////
  function void update_ral_file_bus_values(int root_bus);

/*-----------08122022
    sla_ral_env        ral;
    sla_ral_file       rfile;     
    sla_ral_file       files[$];
    hqm_ral_env        hqm_ral;
    sla_ral_reg        reg_list[$]; 

    ral = get_ral();// sla_ral_env::get_ptr();
    rfile = ral.find_file({hqm_ral_env_name,".aqed_pipe"});
      
    $cast(hqm_ral,rfile.get_ral_env());

    hqm_ral.get_reg_files(files,hqm_ral);
    //--TMP_NOT_SUPPORTED  hqm_ral.set_backdoor_access(i_hqm_ral_backdoor);

    if(hqmCfg.has_busnum_ctrl==1) begin 
      `uvm_info(get_full_name(), $psprintf("update_ral_file_bus_values with hqmCfg.secbus=%0d ", hqmCfg.secbus), UVM_LOW)
      foreach(files[i]) begin
        //Update the bus number of CFG-space registers to the root_bus value assigned from config
        files[i].get_regs_by_space(reg_list,"CFG");
        foreach(reg_list[reg_name]) begin
          reg_list[reg_name].set_bus_num(root_bus);
        end 
      end 
    end else begin
      `uvm_info(get_full_name(), $psprintf("update_ral_file_bus_values skip set_bus_num with hqmCfg.has_busnum_ctrl=%0d has_ralbdf_ctrl=%0d has_raloverride_ctrl=%0d", hqmCfg.has_busnum_ctrl, hqmCfg.has_ralbdf_ctrl, hqmCfg.has_raloverride_ctrl), UVM_LOW)
    end 
08122022  --*/

  endfunction: update_ral_file_bus_values    

  ///////////////////////////////////////////////////////////////////////
  // start_of_simulation
  ///////////////////////////////////////////////////////////////////////
  function void start_of_simulation_phase(uvm_phase phase); 
    super.start_of_simulation_phase(phase);
    update_ral_file_bus_values(hqmCfg.secbus); 
  endfunction 
   
endclass: HqmBaseIntegEnv
