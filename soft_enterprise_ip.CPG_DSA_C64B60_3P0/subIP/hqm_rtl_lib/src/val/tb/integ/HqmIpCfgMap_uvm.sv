
// -----------------------------------------------------------------------------
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
// -----------------------------------------------------------------------------
// File   : HqmIpCfgMap.sv
// Author : 
//
// Description :
//
// -----------------------------------------------------------------------------
`ifndef __HqmIpCfgMap__
`define __HqmIpCfgMap__


class HqmIpCfgMap extends HqmIpCfg;
  `uvm_object_utils(HqmIpCfgMap)

  hqm_base_intf   hqm_base_intf_cfg;
  hqm_iosf_intf   hqm_iosf_intf_cfg;
  hqm_fuse_intf   hqm_fuse_intf_cfg;
  hqm_ats_intf    hqm_ats_intf_cfg;

  //---
  function new(string name = "HqmIpCfgMap");
    super.new(name);
  endfunction: new

  //---
  ////--function set_derived_class_properties(CreateSlaTbEnvConfigParams create_slu_tb_env_config_params);  
  function void program_cfg(); 
    init();       
    program_hqm_base_cfg();
    program_hqm_fuse_cfg();
    program_hqm_iosf_cfg(); 
    program_hqm_ats_cfg(); 
  endfunction     
    
  //---
  virtual function void init();   

  endfunction: init
  
  //--- program_hqm_base_cfg
  function void program_hqm_base_cfg();  

     inst_suffix = hqm_base_intf_cfg.get_inst_suffix_val();
     inst_id	 = hqm_base_intf_cfg.get_instid_val();
     rootbus	 = hqm_base_intf_cfg.get_rootbus_val();
     secbus	 = hqm_base_intf_cfg.get_secbus_val();
     subordbus   = hqm_base_intf_cfg.get_subordbus_val();
     has_busnum_ctrl      = hqm_base_intf_cfg.get_busnumctrl_val();
     has_ralbdf_ctrl      = hqm_base_intf_cfg.get_ralbdfctrl_val();
     has_raloverride_ctrl = hqm_base_intf_cfg.get_raloverridectrl_val();

     hqm_bdf              = hqm_base_intf_cfg.get_bdf_val();

     access_type          = hqm_base_intf_cfg.get_register_access_type();

     //--addrmap
     {mem_map_obj.func_pf_low_base, mem_map_obj.func_pf_hi_base} = hqm_base_intf_cfg.get_hqm_addrmap_func_pf_val();
     {mem_map_obj.func_vf_low_base, mem_map_obj.func_vf_hi_base} = hqm_base_intf_cfg.get_hqm_addrmap_func_vf_val();
     {mem_map_obj.csr_pf_base, mem_map_obj.csr_pf_limit}         = hqm_base_intf_cfg.get_hqm_addrmap_csr_pf_val();
     {mem_map_obj.dram_addr_lo, mem_map_obj.dram_addr_hi}        = hqm_base_intf_cfg.get_hqm_addrmap_dram_val();
      
    `uvm_info("HqmIpCfgMap", $sformatf("HqmIpCfgMap%0s::hqm_base_intf_cfg get func_pf_hi_base=0x%0x func_pf_low_base=0x%0x", inst_suffix, mem_map_obj.func_pf_hi_base, mem_map_obj.func_pf_low_base), UVM_NONE)
    `uvm_info("HqmIpCfgMap", $sformatf("HqmIpCfgMap%0s::hqm_base_intf_cfg get func_vf_hi_base=0x%0x func_vf_low_base=0x%0x", inst_suffix, mem_map_obj.func_vf_hi_base, mem_map_obj.func_vf_low_base), UVM_NONE)
    `uvm_info("HqmIpCfgMap", $sformatf("HqmIpCfgMap%0s::hqm_base_intf_cfg get csr_pf_limit=0x%0x csr_pf_base=0x%0x", inst_suffix, mem_map_obj.csr_pf_limit, mem_map_obj.csr_pf_base), UVM_NONE)
    `uvm_info("HqmIpCfgMap", $sformatf("HqmIpCfgMap%0s::hqm_base_intf_cfg get dram_addr_hi=0x%0x dram_addr_lo=0x%0x", inst_suffix, mem_map_obj.dram_addr_hi, mem_map_obj.dram_addr_lo), UVM_NONE)
    `uvm_info("HqmIpCfgMap", $sformatf("HqmIpCfgMap%0s::hqm_base_intf_cfg get hqm_bdf=0x%0x ", inst_suffix, hqm_bdf), UVM_NONE)
  endfunction:program_hqm_base_cfg
  
  //--- program_hqm_fuse_cfg
  function void program_hqm_fuse_cfg();  
     hqm_fuse_cfg_t fuse_cfg_t;
 
     fuse_cfg_t = hqm_fuse_intf_cfg.get_hqm_fuse_cfg();

     hqm_fuse_no_bypass    = 1;
     hqm_fuse_group        = fuse_cfg_t.hqm_fuse_group;

  endfunction:program_hqm_fuse_cfg
  
  //---
  function void program_hqm_iosf_cfg();
    hqm_iosf_pvc_cfg_t  hqm_iosf_pvc_cfg;

    bit outoforder_compl;
    bit ten_bit_tag_en ;
    bit auto_tag_gen_dis ;

    hqm_iosf_pvc_cfg    = hqm_iosf_intf_cfg.get_hqm_iosf_pvc_cfg();
    outoforder_compl    = hqm_iosf_pvc_cfg.outoforder_compl;
    ten_bit_tag_en      = hqm_iosf_pvc_cfg.ten_bit_tag_en;
    auto_tag_gen_dis    = hqm_iosf_pvc_cfg.auto_tag_gen_dis;

    `uvm_info("HqmIpCfgMap", $sformatf("HqmIpCfgMap::hqm_iosf_intf_cfg.intfName is %s",  hqm_iosf_pvc_cfg.intfName), UVM_LOW)
    `uvm_info("HqmIpCfgMap", $sformatf("HqmIpCfgMap::hqm_iosf_intf_cfg.outoforder_compl is %0d",  outoforder_compl), UVM_LOW)
    `uvm_info("HqmIpCfgMap", $sformatf("HqmIpCfgMap::hqm_iosf_intf_cfg.ten_bit_tag_en is %0d",  ten_bit_tag_en), UVM_LOW)
    `uvm_info("HqmIpCfgMap", $sformatf("HqmIpCfgMap::hqm_iosf_intf_cfg.auto_tag_gen_dis is %0d",  auto_tag_gen_dis), UVM_LOW)

     //------------------------------------------------------
       iosf_pagt_upnode_cfg = IosfAgtCfg::type_id::create("iosf_pagt_upnode_cfg");
       iosf_pagt_upnode_cfg.intfName = hqm_iosf_pvc_cfg.intfName;

       iosf_pagt_upnode_cfg.Max_Payload_Size = Iosf::SIZE_64_BYTES;
       iosf_pagt_upnode_cfg.iosfRevision = Iosf::REV110;
       iosf_pagt_upnode_cfg.setParityRequired(1);
       iosf_pagt_upnode_cfg.MMAX_ADDR = 63;
       iosf_pagt_upnode_cfg.TMAX_ADDR = 63;
       iosf_pagt_upnode_cfg.MD_WIDTH = 255;
       iosf_pagt_upnode_cfg.TD_WIDTH = 255;
       iosf_pagt_upnode_cfg.MDP_WIDTH = 0;
       iosf_pagt_upnode_cfg.TDP_WIDTH = 0;
       iosf_pagt_upnode_cfg.AGENT_WIDTH = 0;
       iosf_pagt_upnode_cfg.SRC_ID_WIDTH = 13;
       iosf_pagt_upnode_cfg.DEST_ID_WIDTH = 13;
       iosf_pagt_upnode_cfg.MAX_DATA_LEN = 9;
       iosf_pagt_upnode_cfg.SAI_WIDTH = 7;
       iosf_pagt_upnode_cfg.RS_WIDTH = 0;
    
       iosf_pagt_upnode_cfg.outOfOrderCompletions = outoforder_compl;

       iosf_pagt_upnode_cfg.initializeDefault();
       iosf_pagt_upnode_cfg.outOfOrderCompletions = outoforder_compl;
       
       if(auto_tag_gen_dis) begin
         `uvm_info(get_full_name(), $psprintf("Avoiding automatic tag generation from PVC since auto_tag_gen_dis (0x%0x)", auto_tag_gen_dis), UVM_LOW)
       end else begin
          if (ten_bit_tag_en) begin
            iosf_pagt_upnode_cfg.tagBits = 10;
          end else begin
            iosf_pagt_upnode_cfg.tagBits = 8;
          end 
       end 

       iosf_pagt_upnode_cfg.setParityRequired(1);

       iosf_pagt_upnode_cfg.setTxnCredits(.channel(0), 
                                          .npcmd(`HQM_PRI_NPCMD_CREDIT), 
                                          .npdata(`HQM_PRI_NPDATA_CREDIT), 
                                          .pcmd(`HQM_PRI_PCMD_CREDIT), 
                                          .pdata(`HQM_PRI_PDATA_CREDIT), 
                                          .cplcmd(`HQM_PRI_CPLCMD_CREDIT), 
                                          .cpldata(`HQM_PRI_CPLDATA_CREDIT));

       iosf_pagt_dut_cfg = IosfAgtCfg::type_id::create("iosf_pagt_dut_cfg");
       iosf_pagt_dut_cfg.iosfRevision = Iosf::REV110;
       iosf_pagt_dut_cfg.intfName = hqm_iosf_pvc_cfg.intfName;

       iosf_pagt_dut_cfg.Max_Payload_Size = Iosf::SIZE_512_BYTES;
       iosf_pagt_dut_cfg.Max_Read_Request_Size = Iosf::SIZE_512_BYTES;
       iosf_pagt_dut_cfg.MMAX_ADDR = 63;
       iosf_pagt_dut_cfg.TMAX_ADDR = 63;
       iosf_pagt_dut_cfg.MD_WIDTH = 255;
       iosf_pagt_dut_cfg.TD_WIDTH = 255;
       iosf_pagt_dut_cfg.MDP_WIDTH = 0;
       iosf_pagt_dut_cfg.TDP_WIDTH = 0;
       iosf_pagt_dut_cfg.AGENT_WIDTH = 0;
       iosf_pagt_dut_cfg.SRC_ID_WIDTH = 13;
       iosf_pagt_dut_cfg.DEST_ID_WIDTH = 13;
       iosf_pagt_dut_cfg.MAX_DATA_LEN = 9;
       iosf_pagt_dut_cfg.SAI_WIDTH = 7;
       iosf_pagt_dut_cfg.RS_WIDTH = 0;
       
       iosf_pagt_dut_cfg.outOfOrderCompletions = outoforder_compl;

       iosf_pagt_dut_cfg.initializeDefault();

       iosf_pagt_dut_cfg.outOfOrderCompletions = outoforder_compl;

       if(auto_tag_gen_dis) begin
         `uvm_info(get_full_name(), $psprintf("Avoiding automatic tag generation from PVC since auto_tag_gen_dis (0x%0x)", auto_tag_gen_dis), UVM_LOW)
       end else begin
          if (ten_bit_tag_en) begin
            iosf_pagt_dut_cfg.tagBits = 10;
          end else begin
            iosf_pagt_dut_cfg.tagBits = 8;
          end 
       end 

       iosf_pagt_dut_cfg.setParityRequired(1);

       if ($test$plusargs("HQM_PRIM_CLK_1_GHZ")) begin
         iosf_pagt_dut_cfg.pGntParallelDelay[0]    = 3 * 1.000ns;        // can be overwritten in HqmIntegEnv.sv
         iosf_pagt_dut_cfg.npGntParallelDelay[0]   = 3 * 1.000ns;        // can be overwritten in HqmIntegEnv.sv
         iosf_pagt_dut_cfg.cGntParallelDelay[0]    = 3 * 1.000ns;        // can be overwritten in HqmIntegEnv.sv
       end else begin
         iosf_pagt_dut_cfg.pGntParallelDelay[0]    = 3 * 1.250ns;        // can be overwritten in HqmIntegEnv.sv
         iosf_pagt_dut_cfg.npGntParallelDelay[0]   = 3 * 1.250ns;        // can be overwritten in HqmIntegEnv.sv
         iosf_pagt_dut_cfg.cGntParallelDelay[0]    = 3 * 1.250ns;        // can be overwritten in HqmIntegEnv.sv
       end 

       iosf_pagt_dut_cfg.RequesterTenBitTagEn = ten_bit_tag_en;
       iosf_pagt_dut_cfg.CompleterTenBitTagEn = ten_bit_tag_en;

       iosf_pagt_upnode_cfg.RequesterTenBitTagEn = ten_bit_tag_en;
       iosf_pagt_upnode_cfg.CompleterTenBitTagEn = ten_bit_tag_en;

       `uvm_info(get_full_name(), $psprintf("iosf_pvc_cfg tenBitTagEn set to (0x%0x)", ten_bit_tag_en), UVM_LOW);
       `uvm_info(get_full_name(), $psprintf("iosf_pvc_cfg outOfOrderCompletions set to (0x%0x)", iosf_pagt_dut_cfg.outOfOrderCompletions), UVM_LOW);

       // IOSF primary agent config object construction
       iosf_pvc_cfg = IosfFabCfg::type_id::create("iosf_pvc_cfg");
       iosf_pvc_cfg.nodes = 2;
       iosf_pvc_cfg.upNode = 0;
       iosf_pvc_cfg.decode = Iosf::SRCDECODE;
       iosf_pvc_cfg.iosfUpNodeAgtCfg = iosf_pagt_upnode_cfg;
       iosf_pvc_cfg.iosfAgtCfg[0] = iosf_pagt_upnode_cfg;
       iosf_pvc_cfg.iosfAgtCfg[1] = iosf_pagt_dut_cfg;

  endfunction:program_hqm_iosf_cfg


  //--- program_hqm_ats_cfg
  function void program_hqm_ats_cfg();  
     //--AY_HQMV30_ATS_TBA  
 
     //--AY_HQMV30_ATS_TBA  ats_cfg_t = hqm_ats_intf_cfg.get_hqm_ats_cfg();


     bit [15:0] device_bdf = hqm_bdf; //--this.getReqId(0); // get the HQM bdf

     atsCfg = HqmAtsCfgObj::type_id::create("atsCfg");

     atsCfg.set_disable_tb_report_severity_settings(hqm_ats_intf_cfg.get_disable_tb_report_severity());

     atsCfg.is_bus_iCXL = hqm_ats_intf_cfg.get_interface_bus();
     atsCfg.is_active   = hqm_ats_intf_cfg.get_active();
     atsCfg.agent_name  = hqm_ats_intf_cfg.get_agent_name(); //"iosf_pvc";
     atsCfg.iommu_bdf   = hqm_ats_intf_cfg.get_iommubdf();   //'hCAFE;   // IOMMU BDF
    `uvm_info("HqmIpCfgMap", $sformatf("HqmIpCfgMap%0s::program_hqm_ats_cfg get agent_name=%0s is_bus_iCXL=%0d is_active=%0d iommu_bdf=0x%0x device_bdf=0x%0x", inst_suffix, atsCfg.agent_name, atsCfg.is_bus_iCXL, atsCfg.is_active, atsCfg.iommu_bdf, device_bdf), UVM_NONE)


     atsCfg.ENV_FILENAME       = {atsCfg.ENV_FILENAME, inst_suffix}; 
     atsCfg.IOMMU_FILENAME     = {atsCfg.IOMMU_FILENAME, inst_suffix};

     atsCfg.disable_tracker    = hqm_ats_intf_cfg.get_dis_tracker();
     atsCfg.TRACKER_FILENAME   = {atsCfg.TRACKER_FILENAME, inst_suffix};

     atsCfg.disable_checker    = hqm_ats_intf_cfg.get_dis_checker();
     atsCfg.disable_legal_ats_check = hqm_ats_intf_cfg.get_dis_ats_check();
     atsCfg.CHECKER_FILENAME   ={atsCfg.CHECKER_FILENAME, inst_suffix}; 


     // tell IOMMU about IOSF Bus widths
     atsCfg.set_iosfpif_params("m", iosf_pagt_dut_cfg.MD_WIDTH); 
     atsCfg.set_iosfpif_params("t", iosf_pagt_dut_cfg.TD_WIDTH); 

     // Push Device BDF and ATS CSRs
     //atsCfg.push_device_ats_csr(device_bdf, ats_flag, pasid_flag, prs_flag);
     atsCfg.push_device_ats_csr(device_bdf, 1, 1, 0);

     atsCfg.disable_ats_inv_check = hqm_ats_intf_cfg.get_dis_invats_check(); 
     atsCfg.disable_cg_sampling = 1;

     atsCfg.setPRSDelay = 0;
    `uvm_info("HqmIpCfgMap", $sformatf("HqmIpCfgMap%0s::program_hqm_ats_cfg get device_bdf=0x%0x iosf_pagt_dut_cfg.MD_WIDTH=%0d", inst_suffix, device_bdf, iosf_pagt_dut_cfg.MD_WIDTH), UVM_NONE)
  endfunction:program_hqm_ats_cfg


  //---
  function void pre_randomize();
    super.pre_randomize();
  endfunction: pre_randomize

  //---
  function void post_randomize();
    // set the config object here 
    sim_type = "RTL"; 

    super.post_randomize();

    //==============================
    // push down
    //==============================
    //---anyan_TDB get_features_from_config_db(hqm_agent_cfg_obj);
  endfunction : post_randomize 

endclass: HqmIpCfgMap

`endif
