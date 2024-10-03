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
// File   : HqmMidIntegEnv.sv
// Author : Carl Angstadt
//
// Description :
//
// Mid IntegEnv for the HQM Agent
//------------------------------------------------------------------------------
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
import HqmAtsPkg::*;
import hqm_cfg_pkg::*;


class HqmMidIntegEnv extends HqmBaseIntegEnv;
  `uvm_component_utils(HqmMidIntegEnv)

  IosfFabricVc          iosf_pvc;   

  hqm_tb_cfg            i_hqm_tb_cfg;
  hqm_pp_cq_status      i_hqm_pp_cq_status;
  hqm_iosf_trans_status i_hqm_iosf_trans_status;
 
  hqm_tb_hcw_scoreboard i_hcw_scoreboard;
  hqm_iosf_prim_mon     i_hqm_iosf_prim_mon;
  hqm_iosf_prim_checker i_hqm_iosf_prim_checker;
  hqm_msix_int_mon      i_hqm_msix_int_mon;
  hqm_ims_int_mon       i_hqm_ims_int_mon;

  HqmAtsEnv             AtsEnv;//i_hqm_ats_env;

  
  function new(string name = "HqmMidIntegEnv", uvm_component parent = null);
    super.new(name, parent);
  endfunction: new
    
  //---------------------------------------------------
  //-- build      
  //---------------------------------------------------  
virtual function void build_phase(uvm_phase phase);  
    string access_path = "IOSFSB";
    bit [63:0] tbcnt_base,tbcnt_base_val;
    int do_backdoor_read;
    int do_backdoor_write;

      
    super.build_phase(phase);    
    
    `uvm_info(get_full_name(), $psprintf("HqmMidIntegEnv::build "), UVM_LOW)    
    
    //---------------------- 
    uvm_config_object::set(this, "iosf_pvc","iosfAgtCfg",hqmCfg.iosf_pagt_upnode_cfg);
    uvm_config_object::set(this, "iosf_pvc", "iosfFabCfg", hqmCfg.iosf_pvc_cfg);

    //-----------------------
    uvm_pkg::uvm_config_int::set(this, "*", "hqm_func_base_strap",0);
    uvm_pkg::uvm_config_int::set(this, "*", "hqm_pp_cq_gen_freq",800);

    if($test$plusargs("RAND_HQM_PP_CQ_TBCNT_BASE")) begin
      tbcnt_base[63:32] = $urandom_range(32'hfffffffe,32'h0);
      tbcnt_base[31:0]  = $urandom_range(32'hffffffff,32'h0);
    end else if($value$plusargs("HQM_PP_CQ_TBCNT_BASE=%x",tbcnt_base_val)) begin
      tbcnt_base = tbcnt_base_val;
    end else begin
      tbcnt_base = 0;
    end 
    `uvm_info(get_full_name(),$psprintf("HqmMidIntegEnv tbcnt_base=0x%0x", tbcnt_base), UVM_LOW)

    uvm_pkg::uvm_config_int::set(this, "*", "hqm_pp_cq_tbcnt_base",tbcnt_base);

    if($test$plusargs("HQM_SEQ_SCH_OUT_MODE")) begin
      uvm_pkg::uvm_config_int::set(this, "*", "hqm_seq_sch_out_mode",1);
    end 

    if($value$plusargs("HQM_PP_CQ_BACKDOOR_READ=%d",do_backdoor_read)) begin
      uvm_pkg::uvm_config_int::set(this, "*", "hqm_pp_cq_backdoor_read",do_backdoor_read);
    end 

    if($value$plusargs("HQM_PP_CQ_BACKDOOR_WRITE=%d",do_backdoor_write)) begin
      uvm_pkg::uvm_config_int::set(this, "*", "hqm_pp_cq_backdoor_write",do_backdoor_write);
    end 

     
    i_hqm_tb_cfg = hqm_tb_cfg::type_id::create("i_hqm_tb_cfg",this);    
    i_hqm_tb_cfg.set_inst_suffix(hqm_config_suffix);
    i_hqm_tb_cfg.set_tb_env_hier(hqm_ral_env_name);
    i_hqm_tb_cfg.set_ral_type("hqm_ral_env");

    access_path = hqmCfg.access_type;  
    `uvm_info(get_full_name(),$psprintf("HqmMidIntegEnv access_path is programmed by hqmCfg.access_type=%s", access_path), UVM_LOW)
    if ($value$plusargs("HQM_RAL_ACCESS_PATH=%s",access_path)) begin
      `uvm_info(get_full_name(),$psprintf("HqmMidIntegEnv access_path is overrided by +HQM_RAL_ACCESS_PATH=%s", access_path), UVM_LOW)
    end 
    i_hqm_tb_cfg.set_ral_access_path(access_path);

    i_hqm_tb_cfg.set_tb_scope("hqm");

     
    uvm_pkg::uvm_config_object::set(this, "*", {"i_hqm_cfg",hqm_config_suffix}, i_hqm_tb_cfg);
 
    i_hqm_pp_cq_status = hqm_pp_cq_status::type_id::create("i_hqm_pp_cq_status", this);

    uvm_pkg::uvm_config_object::set(this, "*", {"i_hqm_pp_cq_status",hqm_config_suffix}, i_hqm_pp_cq_status);

    i_hqm_iosf_trans_status = hqm_iosf_trans_status::type_id::create("i_hqm_iosf_trans_status", this);
    uvm_pkg::uvm_config_object::set(this, "*", {"i_hqm_iosf_trans_status",hqm_config_suffix}, i_hqm_iosf_trans_status);
     

    //----------------------        
    //-- AtsEnv //i_hqm_ats_env
    AtsEnv = HqmAtsEnv::type_id::create("AtsEnv",this); 

    uvm_config_object::set(this, "AtsEnv*", "AtsCfgObj", hqmCfg.atsCfg); //(inst_name, field_name, uvm_object value, clone)
    //--uvm_config_object::set(this, "AtsEnv*", {"AtsCfgObj",hqm_config_suffix}, hqmCfg.atsCfg); //(inst_name, field_name, uvm_object value, clone)

    uvm_config_object::set(this, "*", {"AtsEnv",hqm_config_suffix}, AtsEnv);
    AtsEnv.setDisableSetupReporting();


    //----------------------        
    // IOSF primary agent construction
    iosf_pvc = IosfFabricVc::type_id::create("iosf_pvc",this);
    iosf_pvc.iosfRevision = Iosf::REV110;
    uvm_config_object::set(this, "*", {"iosf_pvc_tlm",hqm_config_suffix}, iosf_pvc);
    uvm_config_object::set(this, "*", {"hqm_iosf_pvc_tlm",hqm_config_suffix}, iosf_pvc);
    
    //----------------------        
    i_hcw_scoreboard = hqm_tb_hcw_scoreboard::type_id::create("i_hcw_scoreboard", this);
    i_hcw_scoreboard.set_inst_suffix(hqm_config_suffix);

    uvm_config_object::set(this, "*i_hqm_cfg*", {"i_hcw_scoreboard",hqm_config_suffix}, i_hcw_scoreboard);
    uvm_config_object::set(this, "*i_hqm_iosf_prim_mon*", {"i_hcw_scoreboard",hqm_config_suffix}, i_hcw_scoreboard);
    uvm_pkg::uvm_config_object::set(this, "*", {"i_hcw_scoreboard",hqm_config_suffix}, i_hcw_scoreboard);
    
    i_hqm_iosf_prim_mon = hqm_iosf_prim_mon::type_id::create("i_hqm_iosf_prim_mon",this);   
    i_hqm_iosf_prim_mon.inst_suffix = hqm_config_suffix;
    uvm_pkg::uvm_config_object::set(this, "*", {"i_hqm_iosf_prim_mon",hqm_config_suffix}, i_hqm_iosf_prim_mon);
   `uvm_info(get_full_name(),$psprintf("HqmMidIntegEnv hqm_config_suffix=%s", hqm_config_suffix), UVM_LOW)


    // -- Build PCIe IOSF compliance checker -- //
    i_hqm_iosf_prim_checker = hqm_iosf_prim_checker::type_id::create("i_hqm_iosf_prim_checker", this);
    i_hqm_iosf_prim_checker.set_inst_suffix(hqm_config_suffix);
    i_hqm_iosf_prim_checker.ral_tb_env_hier = {"*",hqm_ral_env_name,"."};
    uvm_pkg::uvm_config_object::set(this, "*", {"i_hqm_iosf_prim_checker",hqm_config_suffix}, i_hqm_iosf_prim_checker);

    i_hqm_msix_int_mon  = hqm_msix_int_mon::type_id::create("i_hqm_msix_int_mon",this);
    i_hqm_msix_int_mon.set_inst_suffix(hqm_config_suffix);
    i_hqm_ims_int_mon   = hqm_ims_int_mon::type_id::create("i_hqm_ims_int_mon",this);
    i_hqm_ims_int_mon.set_inst_suffix(hqm_config_suffix);
  endfunction : build_phase
  
  //---------------------------------------------------
  //-- connect      
  //---------------------------------------------------  
  function void connect_phase(uvm_phase phase);
    int req_credits, p_credits, np_credits, cmpl_credits;
    int gnt_delay;
  
    super.connect_phase(phase);
    
    //----------------------      
    if (!$value$plusargs("hqm_iosf_prim_req_credits=%d",req_credits)) begin 
        req_credits = `HQM_FBRC_REQ_CREDIT;
    end 
    if (!$value$plusargs("HQM_IOSF_REQ_P_CREDITS=%d",p_credits)) begin
        p_credits = req_credits;
    end 
    if (!$value$plusargs("HQM_IOSF_REQ_NP_CREDITS=%d",np_credits)) begin
        np_credits = req_credits;
    end 
    if (!$value$plusargs("HQM_IOSF_REQ_CMPL_CREDITS=%d",cmpl_credits)) begin
        cmpl_credits = req_credits;
    end 


    iosf_pvc.setPReqCredit  (.endpoint(1), .channel(0), .credit(p_credits));
    iosf_pvc.setNpReqCredit (.endpoint(1), .channel(0), .credit(np_credits));
    iosf_pvc.setCReqCredit  (.endpoint(1), .channel(0), .credit(cmpl_credits));

    // -------------------------------------------------
    // connect AtsEnv IOMMU to anyone that needs it
    // -------------------------------------------------
    i_hqm_tb_cfg.set_hqm_bdf(hqmCfg.hqm_bdf);
    i_hqm_tb_cfg.iommu     = AtsEnv.get_iommu();              //  returns API providing access methods to/from IOMMU
    i_hqm_tb_cfg.iommu_api = AtsEnv.get_iommu_api();          //  returns API providing access methods to/from IOMMU
    if ( i_hqm_tb_cfg.iommu_api != null ) begin
        i_hqm_tb_cfg.iommu_api.set_ireq_watchdog_timeout(10); //hqmCfg.ats_inv_watchdog_timeout_us); //--AY_HQMV30_ATS_TBA
    end 

    AtsEnv.ats_analysis_env.hqm_analysis_checker.registerChassisResetEvent(hqmCfg.hqm_bdf, {"HQM_CHASSIS_RESET_E",hqm_config_suffix});
    AtsEnv.ats_analysis_env.hqm_analysis_checker.registerNonChassisResetEvent(hqmCfg.hqm_bdf, {"HQM_NONCHASSIS_RESET_E",hqm_config_suffix});
    AtsEnv.ats_analysis_env.hqm_analysis_checker.registerPrsReqEvent({"HQM_PRS_REQ_E",hqm_config_suffix});
    AtsEnv.ats_analysis_env.hqm_analysis_checker.registerPrgRspEvent({"HQM_PRG_RSP_E",hqm_config_suffix});
    AtsEnv.ats_analysis_env.hqm_analysis_checker.registerAtsReqEvent({"HQM_ATS_REQ_E",hqm_config_suffix});
    AtsEnv.ats_analysis_env.hqm_analysis_checker.registerAtsRspEvent({"HQM_ATS_CPL_E",hqm_config_suffix});
    AtsEnv.ats_analysis_env.hqm_analysis_checker.registerInvReqEvent({"HQM_INV_REQ_E",hqm_config_suffix});
    AtsEnv.ats_analysis_env.hqm_analysis_checker.registerInvRspEvent({"HQM_INV_RSP_E",hqm_config_suffix});
        
    // Connect the IOMMU Analysis Env to an external Monitor
    if (! hqmCfg.atsCfg.disable_tracker || ! hqmCfg.atsCfg.disable_checker) begin
        //--AY_HQMV30_ATS_TBA    primBus_export.connect(AtsEnv.ats_analysis_env.primBus_export);
        i_hqm_iosf_prim_mon.i_HqmAtsPort.connect(AtsEnv.ats_analysis_env.primBus_export);
    end 

    AtsEnv.setupReporting();


    //----------------------          
    // HCWs enqueued to IOSF primary interface
    i_hqm_iosf_prim_mon.i_hcw_enq_in_port.connect(i_hcw_scoreboard.in_item_port);
    
    // HCWs scheduled from IOSF primary interface
    i_hqm_iosf_prim_mon.i_hcw_sch_out_port.connect(i_hcw_scoreboard.out_item_port);
    
    i_hqm_tb_cfg.hcw_gen_port.connect(i_hcw_scoreboard.hcwgen_item_port);

    // -- Connect monitor output to checker -- //
    `ifdef IP_TYP_TE
    i_hqm_iosf_prim_mon.i_iosf_trans_type_port.connect(i_hqm_iosf_prim_checker.hqm_iosf_prim_txn_imp); 
    `endif

  endfunction : connect_phase


  ///////////////////////////////////////////////////////////////////////
  // end_of_elaboration
  ///////////////////////////////////////////////////////////////////////
  function void end_of_elaboration_phase(uvm_phase phase);

    super.end_of_elaboration_phase(phase); 
     
    i_hqm_tb_cfg.set_hqm_module_prefix(hqm_rtl_path);
    i_hqm_tb_cfg.set_hqm_core_module_prefix({hqm_rtl_path,".hqm_proc"});
    i_hqm_tb_cfg.set_ral_env(hqmSlaEnv.get_ral());
    hqmCfg.hqm_fuse_rtl_path = hqm_rtl_path;  

  endfunction : end_of_elaboration_phase
  
  ///////////////////////////////////////////////////////////////////////
  // start_of_simulation
  ///////////////////////////////////////////////////////////////////////
  function void start_of_simulation_phase(uvm_phase phase);
    bit success = 1;
    int gnt_dly_min = 1, gnt_dly_max = 10, clk_ack_dly_max = 10;
    int clk_ack_dly = 0, neg_edge_clk_ack_dly = 0;
    string log_str;
    Iosf::iosf_req_t reqtype = Iosf::REQTYPE_RSV;
    
    super.start_of_simulation_phase(phase);
    
    $value$plusargs("HQM_IOSF_GNT_DLY_MIN=%d",gnt_dly_min);
    $value$plusargs("HQM_IOSF_GNT_DLY_MAX=%d",gnt_dly_max);
    $value$plusargs("HQM_IOSF_CLK_ACK_DLY_MAX=%d",clk_ack_dly_max);
    $value$plusargs("HQM_IOSF_CLK_ACK_DLY=%d",clk_ack_dly);
    $value$plusargs("HQM_IOSF_NEG_EDGE_CLK_ACK_DLY=%d",neg_edge_clk_ack_dly);
    $value$plusargs("HQM_IOSF_GNT_REQ_TYPE=%d",reqtype); // 0:P,1:NP,2:CMPL,3:ALL
    log_str = $psprintf("gnt_dly_min = %d, gnt_dly_max = %d, clk_ack_dly = %d, clk_ack_dly_max = %d, negEdgeClkAckDelay = %d, reqtype = %d", gnt_dly_min, gnt_dly_max, clk_ack_dly, clk_ack_dly_max, neg_edge_clk_ack_dly, reqtype);
    
    
    iosf_pvc.iosfFabCfg.iosfAgtCfg[0].clkAckDelay        = clk_ack_dly; //in ns unit
    iosf_pvc.iosfFabCfg.iosfAgtCfg[0].negEdgeClkAckDelay = neg_edge_clk_ack_dly; //in ns unit
    iosf_pvc.iosfFabCfg.iosfAgtCfg[1].clkAckDelay        = clk_ack_dly; //in ns unit
    iosf_pvc.iosfFabCfg.iosfAgtCfg[1].negEdgeClkAckDelay = neg_edge_clk_ack_dly; //in ns unit
    
    // Set expected txn credits for Agent DUT  Fabric PVC compares these
    // values to the number actually received at the end of credit init
    success &= iosf_pvc.iosfFabCfg.iosfAgtCfg[0].setDutExpTxnCredits (.channel(0), 
                                                                      .npcmd(`HQM_PRI_NPCMD_CREDIT), 
                                                                      .npdata(`HQM_PRI_NPDATA_CREDIT), 
                                                                      .pcmd(`HQM_PRI_PCMD_CREDIT), 
                                                                      .pdata(`HQM_PRI_PDATA_CREDIT), 
                                                                      .cplcmd(`HQM_PRI_CPLCMD_CREDIT), 
                                                                      .cpldata(`HQM_PRI_CPLDATA_CREDIT));

    success &= iosf_pvc.iosfFabCfg.iosfAgtCfg[1].setDutExpTxnCredits (.channel(0), 
                                                                      .npcmd(`HQM_PRI_NPCMD_CREDIT), 
                                                                      .npdata(`HQM_PRI_NPDATA_CREDIT), 
                                                                      .pcmd(`HQM_PRI_PCMD_CREDIT), 
                                                                      .pdata(`HQM_PRI_PDATA_CREDIT), 
                                                                      .cplcmd(`HQM_PRI_CPLCMD_CREDIT), 
                                                                      .cpldata(`HQM_PRI_CPLDATA_CREDIT));

    success &= iosf_pvc.iosfFabCfg.iosfAgtCfg[0].setEnableCrdInitChk (1);
    success &= iosf_pvc.iosfFabCfg.iosfAgtCfg[1].setEnableCrdInitChk (1);
    if($test$plusargs("HQM_IOSF_SETGNTGAP")) begin
      `uvm_info(get_full_name(), $psprintf("Calling SetGntGap with values %s",log_str),UVM_LOW)  
      success = iosf_pvc.setGntGap(.port(1), .chid(0), .min(gnt_dly_min), .max(gnt_dly_max), .random(1), .value(1000), .reqType(reqtype)); 
    end   
    if($test$plusargs("HQM_IOSF_EN_ORDERINGRULES")) begin 
      `uvm_info(get_full_name(), $psprintf("Enabling ordering rules with values %s",log_str),UVM_LOW)  
      iosf_pvc.iosfFabCfg.iosfAgtCfg[0].agtOrderingRules = 1;
      iosf_pvc.iosfFabCfg.iosfAgtCfg[0].fabOrderingRules = 1;
      iosf_pvc.iosfFabCfg.iosfAgtCfg[1].fabOrderingRules = 1;
    end   
    if($test$plusargs("HQM_IOSF_EN_RAND_CLKACKDLY")) begin 
      `uvm_info(get_full_name(), $psprintf("Configuring clk ack dly with values %s",log_str),UVM_LOW)  
      iosf_pvc.iosfFabCfg.iosfAgtCfg[1].clkAckDelay = clk_ack_dly_max; //in ns unit
      iosf_pvc.iosfFabCfg.iosfAgtCfg[1].negEdgeClkAckDelay = 0;
      iosf_pvc.iosfFabCfg.iosfAgtCfg[1].randClkReqDelay = 1;
    end   
    if($test$plusargs("HQM_IOSF_EN_ASYNCGNT")) begin 
      `uvm_info(get_full_name(), $psprintf("Enabling AsyncGnt with values with values %s",log_str),UVM_LOW)  
      iosf_pvc.iosfFabCfg.iosfAgtCfg[1].asyncGnt = 1; 
    end   
  endfunction 
endclass: HqmMidIntegEnv
