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

import hqm_tb_cfg_pkg::*;
import hcw_transaction_pkg::*;
import hcw_pkg::*;
import hqm_cfg_pkg::*;

`include "sla_macros.svh"

typedef class hqm_ral_env;
   

class HqmBaseIntegEnv extends sla_tb_env;
  `ovm_component_utils(HqmBaseIntegEnv)

  HqmIpCfg              hqmCfg;
  static string HqmIpCfgProgmmer  = "HqmIpCfgProg"; 


  hqm_sla_env           hqmSlaEnv;
  string 		hqm_rtl_path;
  string                hqm_ral_env_name;
  hqm_ral_backdoor      i_hqm_ral_backdoor;
  string                hqm_config_suffix;  
       
   
  function new(string name = "HqmBaseIntegEnv", ovm_component parent = null);
    super.new(name, parent);

  endfunction: new

  ///////////////////////////////////////////////////////////////////////
  // createCfg  
  ///////////////////////////////////////////////////////////////////////
  function HqmIpCfg createCfg(HqmIpCfg my_cfg = null, string name = "HqmIpCfg");
      createCfg = my_cfg;

      if(createCfg == null) begin 
         `ovm_info(get_full_name(), $psprintf("HqmBaseIntegEnv::createCfg was null creating new config object using programmer"), OVM_LOW)
          if(($cast(createCfg, factory.create_object(HqmIpCfgProgmmer, name))==0) || (createCfg == null)) 
            `ovm_error(get_full_name(), "HqmBaseIntegEnv::createCfg could not create HqmIpCfg object");
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
        `ovm_info(get_full_name(), $psprintf("HqmBaseIntegEnv::assignCfg hqmCfg"), OVM_LOW)
  endfunction

  ///////////////////////////////////////////////////////////////////////
  // Build
  ///////////////////////////////////////////////////////////////////////
  virtual function void build();

    `ovm_info(get_full_name(), $psprintf("HqmBaseIntegEnv::build "), OVM_LOW)

    hqm_ral_env_name = {"hqmSlaEnv_",hqmCfg.inst_suffix};
    hqmSlaEnv = hqm_sla_env::type_id::create(hqm_ral_env_name, this);
    hqmSlaEnv.set_level(SLA_SUB);
    if (hqmCfg.inst_suffix == "hqm") begin
      hqm_config_suffix = "";
    end else begin
      hqm_config_suffix = hqmCfg.inst_suffix;
    end

    i_hqm_ral_backdoor = hqm_ral_backdoor::type_id::create("i_hqm_ral_backdoor", this);
    `ovm_info(get_name(), $psprintf("Instantiating HQM RAL hqm_config_suffix=%0s hqm_ral_env_name=%0s - hqmCfg.inst_suffix=%0s", hqm_config_suffix, hqm_ral_env_name, hqmCfg.inst_suffix), OVM_NONE);

    super.build();    

    //-----------------------
    if (hqmCfg.inst_suffix == "hqm") begin
      ovm_pkg::set_config_object("*", "hqm_mem_map_obj",  hqmCfg.mem_map_obj, 0);
    end else begin
      ovm_pkg::set_config_object("*", $psprintf("hqm_mem_map_obj%s",hqmCfg.inst_suffix),  hqmCfg.mem_map_obj, 0);
      `ovm_info(get_name(), $psprintf("set_config_object hqm_mem_map_obj%s", hqmCfg.inst_suffix), OVM_NONE);
    end
  endfunction: build
   
  ///////////////////////////////////////////////////////////////////////
  // connect
  ///////////////////////////////////////////////////////////////////////   
  function void connect(); 
    int gnt_delay;

    super.connect(); 

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
  endfunction : connect

  ///////////////////////////////////////////////////////////////////////
  // end_of_elaboration
  ///////////////////////////////////////////////////////////////////////
  function void end_of_elaboration();
    super.end_of_elaboration();
  
    get_config_string("HQM_RTL_TOP", hqm_rtl_path); 
    hqmCfg.hqm_fuse_rtl_path = hqm_rtl_path; 
  endfunction : end_of_elaboration
  
  ///////////////////////////////////////////////////////////////////////
  // set_fuse_override_values
  ///////////////////////////////////////////////////////////////////////
  function void set_fuse_override_values();
    `ovm_info(get_name(), "Got handle to parent HQM AGENT ENV. Overriding fuses", OVM_LOW);
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

    fal = get_fuse_env();//sla_fuse_env::get_ptr();

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

            `ovm_info(get_full_name(), $psprintf("fuse_ovrd FUSE OVERRIDE:HQM Agent_fuse_env Original value of fuse %s was 0x%0h, now is 0x%0h", i_fuse_ovrd_config.Fuse_name[i], fuse_cfg_val, i_fuse_ovrd_config.Fuse_ovrd_value[i_fuse_ovrd_config.Fuse_name[i]]), OVM_INFO)
      end
  endfunction : set_fal

  ///////////////////////////////////////////////////////////////////////
  // update_ral_file_bus_values
  ///////////////////////////////////////////////////////////////////////
  function void update_ral_file_bus_values(int root_bus);
    sla_ral_env        ral;
    sla_ral_file       rfile;     
    sla_ral_file       files[$];
    hqm_ral_env        hqm_ral;
    sla_ral_reg        reg_list[$]; 

    ral = get_ral();// sla_ral_env::get_ptr();
    rfile = ral.find_file({hqm_ral_env_name,".aqed_pipe"});
      
    $cast(hqm_ral,rfile.get_ral_env());

    hqm_ral.get_reg_files(files,hqm_ral);
    hqm_ral.set_backdoor_access(i_hqm_ral_backdoor);

    if(hqmCfg.has_busnum_ctrl==1) begin 
      `ovm_info(get_full_name(), $psprintf("update_ral_file_bus_values with hqmCfg.secbus=%0d ", hqmCfg.secbus), OVM_LOW)
      foreach(files[i]) begin
        //Update the bus number of CFG-space registers to the root_bus value assigned from config
        files[i].get_regs_by_space(reg_list,"CFG");
        foreach(reg_list[reg_name]) begin
          reg_list[reg_name].set_bus_num(root_bus);
        end
      end
    end else begin
      `ovm_info(get_full_name(), $psprintf("update_ral_file_bus_values skip set_bus_num with hqmCfg.has_busnum_ctrl=%0d has_ralbdf_ctrl=%0d has_raloverride_ctrl=%0d", hqmCfg.has_busnum_ctrl, hqmCfg.has_ralbdf_ctrl, hqmCfg.has_raloverride_ctrl), OVM_LOW)
    end
  endfunction: update_ral_file_bus_values    

  ///////////////////////////////////////////////////////////////////////
  // start_of_simulation
  ///////////////////////////////////////////////////////////////////////
  function void start_of_simulation(); 
    super.start_of_simulation();
    update_ral_file_bus_values(hqmCfg.secbus); 
  endfunction 
   
endclass: HqmBaseIntegEnv
