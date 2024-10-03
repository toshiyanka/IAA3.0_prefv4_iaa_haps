//-----------------------------------------------------------------------------------------------------
//
// INTEL CONFIDENTIAL
//
// Copyright 2015 Intel Corporation All Rights Reserved.
//
// The source code contained or described herein and all documents related to the source code
// ("Material") are owned by Intel Corporation or its suppliers or licensors. Title to the Material
// remains with Intel Corporation or its suppliers and licensors. The Material contains trade
// secrets and proprietary and confidential information of Intel or its suppliers and licensors.
// The Material is protected by worldwide copyright and trade secret laws and treaty provisions.
// No part of the Material may be used, copied, reproduced, modified, published, uploaded, posted,
// transmitted, distributed, or disclosed in any way without Intel's prior express written permission.
//
// No license under any patent, copyright, trade secret or other intellectual property right is
// granted to or conferred upon you by disclosure or delivery of the Materials, either expressly, by
// implication, inducement, estoppel or otherwise. Any license under such intellectual property rights
// must be express and approved by Intel in writing.
//
//-----------------------------------------------------------------------------------------------------

`ifndef HQM_IOSF_SB_CHECKER__SV 
`define HQM_IOSF_SB_CHECKER__SV 

//------------------------------------------------------------------------------
// File        : hqm_iosf_sb_checker.sv
// Author      : Neeraj Shete
//
// Description : This class is derived form ovm_component and it intends to
//               cover the checks not present in SVC.
//               - Check observed PCIe ERRMSG count matches expected at EOT.
//               - Check requester ID is legal limits for requests from HQM.
//               - Check SAI  field of every pkt received from HQM.
//               - Check SRCID/DESTID field of every pkt received from HQM.
//               - Check payload length in CplD pkt does not cross MPS.
//------------------------------------------------------------------------------

import IosfPkg::*;
import sla_pkg::*;
import iosfsbm_cm::*;
import iosfsbm_cm::*;
import iosfsbm_seq::*;
import iosfsbm_fbrc::*;
import iosfsbm_agent::*;

`include "hqm_sif_defines.sv"

class hqm_iosf_sb_checker extends ovm_component;

   ovm_analysis_imp #(iosf_sb_txn_t, hqm_iosf_sb_checker) hqm_iosf_sb_txn_imp;

  `ovm_component_utils(hqm_iosf_sb_checker)

  // ---------------------------------------------------------------
  // -- Globals
  // ---------------------------------------------------------------
  sla_ral_env	                 ral;                      // -- Used to get register values 
  protected    bit [7:0]         func_base;                // -- Pf_func # -> varied by plusarg
  protected    bit               hqm_is_reg_ep_arg;        // -- If '1' -> EP mode, otherwise RCIEP mode
  protected    bit [7:0]         ep_bus_number[*];         // -- Store bus/dev # for each function
  protected    bit [25:0]        sent_cfg_txnid_q[$];      // -- Store cfg txnid sent to EP 
  protected    bit [25:0]        sent_mem_txnid_q[$];      // -- Store mem txnid sent to EP
  protected    bit               ten_bit_tag_en;           // -- Value of strap driven to HQM
  protected    bit		         hqm_pcie_rc_vip_present;  // -- Place holder
  protected    bit               skip_chk = $test$plusargs("HQM_PCIE_B2B_SINGLE_ERR_SKIP_CHK");
  protected    bit               bypass_bus_num_check = $test$plusargs("HQM_SB_BYPASS_BUS_NUM_CHECK");

  // ---------------------------------------------------------------
  // -- Event pool
  // ---------------------------------------------------------------

  ovm_event_pool glbl_pool;
  ovm_event      exp_ep_fatal_msg[`MAX_NO_OF_VFS+1];
  ovm_event      exp_ep_nfatal_msg[`MAX_NO_OF_VFS+1];
  ovm_event      exp_ep_corr_msg[`MAX_NO_OF_VFS+1];
  ovm_event      obs_ep_fatal_msg[`MAX_NO_OF_VFS+1];
  ovm_event      obs_ep_nfatal_msg[`MAX_NO_OF_VFS+1];
  ovm_event      obs_ep_corr_msg[`MAX_NO_OF_VFS+1];

  ovm_event      hqm_prim_rst_assert;
  ovm_event      hqm_side_rst_assert;
  ovm_event      hqm_prim_pok_assert;
  ovm_event      hqm_side_pok_assert;
  ovm_event      hqm_prim_pok_deassert;
  ovm_event      hqm_side_pok_deassert;
  ovm_event      hqm_ip_force_pok_msg;
  ovm_event      hqm_waive_pok_check;
  ovm_event      hqm_re_enable_pok_check;

  // ---------------------------------------------------------------
  // -- To hold the number of expected fatal, nfatal, corr msgs 
  // ---------------------------------------------------------------
  int            exp_ep_fatal_msg_count[`MAX_NO_OF_VFS+1];
  int            exp_ep_nfatal_msg_count[`MAX_NO_OF_VFS+1];
  int            exp_ep_corr_msg_count[`MAX_NO_OF_VFS+1];

  // ---------------------------------------------------------------
  // -- To hold the number of observed fatal, nfatal, corr msgs 
  // ---------------------------------------------------------------
  int            obs_ep_fatal_msg_count[`MAX_NO_OF_VFS+1];
  int            obs_ep_nfatal_msg_count[`MAX_NO_OF_VFS+1];
  int            obs_ep_corr_msg_count[`MAX_NO_OF_VFS+1];

  // ---------------------------------------------------------------
  // -- To expect atleast one observed fatal, nfatal, corr msgs 
  // ---------------------------------------------------------------
  bit            exp_atleast_one_fatal_msg_count[`MAX_NO_OF_VFS+1];
  bit            exp_atleast_one_nfatal_msg_count[`MAX_NO_OF_VFS+1];
  bit            exp_atleast_one_corr_msg_count[`MAX_NO_OF_VFS+1];

  // ---------------------------------------------------------------
  // -- Disable check options
  // ---------------------------------------------------------------
  protected bit     hqm_mrd_cpl_id_chk     ; 
  protected bit     dis_err_msg_check      ;
  protected bit     hqm_op_fuse_pull_msg=0 ;
  protected bit     hqm_fuse_pull_err   =1 ;

  // ---------------------------------------------------------------
  // -- Strap values driven to HQM
  // ---------------------------------------------------------------
  protected bit [7:0]     hqm_cmpl_sai_strap      ;
  protected bit [7:0]     hqm_tx_sai_strap        ;
  logic [15:0] strap_hqm_err_sb_dstid;
  logic [7:0]  strap_hqm_err_sb_sai;
  logic [7:0]  strap_hqm_tx_sai;
  logic [7:0]  strap_hqm_cmpl_sai;            // -- SAI for completions
  logic [7:0]  strap_hqm_resetprep_ack_sai;   // -- SAI for ResetPrepAck message
  bit          legal_resetprep_msg_sai;       // -- Legal SAI value on Previous Sideband ResetPrep message
  logic [7:0]  strap_hqm_resetprep_sai_0;     // -- Legal SAI values for Sideband ResetPrep message
  logic [7:0]  strap_hqm_resetprep_sai_1;     // -- Legal SAI values for Sideband ResetPrep message
  bit          legal_force_pok_msg_sai;       // -- Legal SAI value on Previous Sideband ForcePwrGatePOK message
  logic [7:0]  strap_hqm_force_pok_sai_0;     // -- Legal SAI values for Sideband ForcePwrGatePOK message
  logic [7:0]  strap_hqm_force_pok_sai_1;     // -- Legal SAI values for Sideband ForcePwrGatePOK message
  logic [15:0] strap_hqm_do_serr_dstid;
  logic [2:0]  strap_hqm_do_serr_tag;
  logic        strap_hqm_do_serr_sairs_valid;
  logic [7:0]  strap_hqm_do_serr_sai;
  logic [0:0]  strap_hqm_do_serr_rs;
  
  logic [15:0] strap_hqm_gpsb_srcid;
  logic        strap_hqm_16b_portids; 

  logic [15:0] strap_hqm_fp_cfg_dstid;
  logic [15:0] strap_hqm_fp_cfg_ready_dstid;
  logic [15:0] strap_hqm_fp_cfg_sai;
  logic [15:0] strap_hqm_fp_cfg_sai_cmpl;
  logic [2:0]  strap_hqm_fp_cfg_tag;         

  // ---------------------------------------------------------------
  // -- Methods within hqm_iosf_sb_checker
  // ---------------------------------------------------------------
  extern    function                  new( string name = "hqm_iosf_sb_checker", ovm_component parent = null);
  extern    virtual    function void  build();
  extern    virtual    task           run();
  extern    virtual    function void  report();

  extern               function void  get_plusarg_values();
  extern               function void  connect ();
  extern               function sla_ral_data_t get_reg_value(string reg_name, string file_name, bit ro = 1'b_0);
  extern               task           exp_fatal_msg_loop();
  extern               task           exp_nfatal_msg_loop() ;
  extern               task           exp_corr_msg_loop();
  extern               task           track_ep_fatal_msg(int func_num);
  extern               task           track_ep_nfatal_msg(int func_num);
  extern               task           track_ep_corr_msg(int func_num);
  extern               function       chk_ep_fatal_count();
  extern               function       chk_ep_nfatal_count();
  extern               function       chk_ep_corr_count();
  extern               function       chk_sai(iosf_sb_txn_t mon_txn);
// -- review: check other fields of the header for all requests originating from HQM e.g., (EH, Expanded Header ID, Root Space, PullerID, FuseHeaderID)  --//
// -- review: Tag in IP_ready message should be reserved and should be 0. 
// -- review: For completion please check first and last DWORD byte enable. 
// -- review: checker and monitors are reset sensitive i.e. the checker should clear all the flags, queues, states etc. 
  extern               function       chk_eh(iosf_sb_txn_t txn); 
  extern               function       chk_pkt_from_ep(iosf_sb_txn_t pkt);
  extern               function       chk_fuse_pull_cmpl(iosfsbm_cm::xaction txn);
  extern               function       chk_sai_resetprep(iosfsbm_cm::xaction txn);
  extern               task           force_pok_chk();
  extern               function       chk_sai_force_pok(iosfsbm_cm::xaction txn);
  extern               function       chk_err_msg_pkt(iosfsbm_cm::xaction mon_txn);
  extern               function       chk_ipready_pkt(iosfsbm_cm::xaction mon_txn);
  extern               function bit   is_reqid_legal(iosfsbm_cm::xaction mon_txn);
  extern               function       chk_ep_fatal_msg_count();
  extern               function       chk_ep_nfatal_msg_count();
  extern               function       chk_ep_corr_msg_count();
  extern               function       chk_cpl_pkt(iosf_sb_txn_t pkt);
  extern               function       chk_cpld_length(iosfsbm_cm::xaction mon_txn);
  extern               function int   get_mps_dw(bit [2:0] mps);
  extern               function longint get_strap_val(string plusarg_name, longint default_val);
  extern               function       chk_sai_val(int exp_sai, iosfsbm_cm::xaction txn);
  extern               function       chk_srcid_dstid(iosf_sb_txn_t mon_txn);
  extern               function       chk_id_val(int exp_id, int obs_id, iosfsbm_cm::xaction txn);
  extern               function int   get_bus_num_per_func(int func_num);
  extern               function void  write(iosf_sb_txn_t ep_pkt);

endclass : hqm_iosf_sb_checker

  // ---------------------------------------------------------------
  // new - constructor
  // ---------------------------------------------------------------
  function hqm_iosf_sb_checker::new (string name = "hqm_iosf_sb_checker", ovm_component parent = null);
    super.new(name, parent);

    get_plusarg_values();       // includes setting exp_ep_<type>_msg_count[<func>]

    glbl_pool        = ovm_event_pool::get_global_pool();

    // -- Create/get handles to nfatal err msg detected triggering -- // 
    for(int i=0; i<(`MAX_NO_OF_VFS+1); i++) begin
      obs_ep_nfatal_msg[i]       = glbl_pool.get($psprintf("obs_ep_nfatal_msg_%0d",i));
      exp_ep_nfatal_msg[i]       = glbl_pool.get($psprintf("exp_ep_nfatal_msg_%0d",i));
      obs_ep_nfatal_msg_count[i] = 0;
      exp_atleast_one_nfatal_msg_count[i] = 0;
    end

    // -- Create/get handles to fatal err msg detected triggering -- // 
    for(int i=0; i<(`MAX_NO_OF_VFS+1); i++) begin
      obs_ep_fatal_msg[i]       = glbl_pool.get($psprintf("obs_ep_fatal_msg_%0d",i));
      exp_ep_fatal_msg[i]       = glbl_pool.get($psprintf("exp_ep_fatal_msg_%0d",i));
      obs_ep_fatal_msg_count[i] = 0;
      exp_atleast_one_fatal_msg_count[i]  = 0;
    end

    // -- Create/get handles to corr err msg detected triggering -- // 
    for(int i=0; i<(`MAX_NO_OF_VFS+1); i++) begin
      obs_ep_corr_msg[i]       = glbl_pool.get($psprintf("obs_ep_corr_msg_%0d",i));
      exp_ep_corr_msg[i]       = glbl_pool.get($psprintf("exp_ep_corr_msg_%0d",i));
      obs_ep_corr_msg_count[i] = 0;
      exp_atleast_one_corr_msg_count[i]   = 0;
    end

    // -- Events to check that an illegal SAI in force_pok msg doesn't cause HQM to deassert pok(s).
    hqm_prim_rst_assert   = glbl_pool.get("hqm_prim_rst_assert");
    hqm_side_rst_assert   = glbl_pool.get("hqm_side_rst_assert");
    hqm_prim_pok_assert   = glbl_pool.get("hqm_prim_pok_assert");
    hqm_side_pok_assert   = glbl_pool.get("hqm_side_pok_assert");
    hqm_prim_pok_deassert = glbl_pool.get("hqm_prim_pok_deassert");
    hqm_side_pok_deassert = glbl_pool.get("hqm_side_pok_deassert");
    hqm_ip_force_pok_msg  = glbl_pool.get("hqm_ip_force_pok_msg");
    hqm_waive_pok_check   = glbl_pool.get("hqm_waive_pok_check");
    hqm_re_enable_pok_check = glbl_pool.get("hqm_re_enable_pok_check");

	ral = sla_ral_env::get_ptr();

    legal_resetprep_msg_sai = 1'b_0;

  endfunction : new

  // -----------------------------------------------------------------------------
  // -- Builds components used 
  // -----------------------------------------------------------------------------

  function void hqm_iosf_sb_checker::build();
    super.build(); hqm_iosf_sb_txn_imp = new("hqm_iosf_sb_txn_imp", this);
  endfunction : build

  // -----------------------------------------------------------------------------
  // -- Receive plusarg driven values  
  // -----------------------------------------------------------------------------

  function void hqm_iosf_sb_checker::get_plusarg_values();
    int       exp_msg_cnt;

    ten_bit_tag_en = ~($test$plusargs("HQM_TEN_BIT_TAG_DISABLE"));

    if(!$value$plusargs("hqm_is_reg_ep=%d",hqm_is_reg_ep_arg)) hqm_is_reg_ep_arg = 'h_0;

    if(hqm_is_reg_ep_arg) begin func_base = 8'h_00; end // -- EP    mode PF func number 
    else                  begin func_base = 8'h_00; end // -- RCIEP mode PF func number 

    hqm_pcie_rc_vip_present = $test$plusargs("HQM_PCIE_RC_VIP_PRESENT");

    if($value$plusargs("HQM_PF_EXP_FATAL_MSG_CNT=%d",exp_msg_cnt)) begin
      exp_ep_fatal_msg_count[0] = exp_msg_cnt;
    end else begin
      exp_ep_fatal_msg_count[0] = 0;
    end

    if($value$plusargs("HQM_PF_EXP_NFATAL_MSG_CNT=%d",exp_msg_cnt)) begin
      exp_ep_nfatal_msg_count[0] = exp_msg_cnt;
    end else begin
      exp_ep_nfatal_msg_count[0] = 0;
    end

    if($value$plusargs("HQM_PF_EXP_CORR_MSG_CNT=%d",exp_msg_cnt)) begin
      exp_ep_corr_msg_count[0] = exp_msg_cnt;
    end else begin
      exp_ep_corr_msg_count[0] = 0;
    end

    for (int i = 0 ; i < `MAX_NO_OF_VFS ; i++) begin
      if($value$plusargs({$psprintf("HQM_VF_%0d_EXP_FATAL_MSG_CNT",i),"=%d"},exp_msg_cnt)) begin
        exp_ep_fatal_msg_count[i+1] = exp_msg_cnt;
      end else begin
        exp_ep_fatal_msg_count[i+1] = 0;
      end

      if($value$plusargs({$psprintf("HQM_VF_%0d_EXP_NFATAL_MSG_CNT",i),"=%d"},exp_msg_cnt)) begin
        exp_ep_nfatal_msg_count[i+1] = exp_msg_cnt;
      end else begin
        exp_ep_nfatal_msg_count[i+1] = 0;
      end

      if($value$plusargs({$psprintf("HQM_VF_%0d_EXP_CORR_MSG_CNT",i),"=%d"},exp_msg_cnt)) begin
        exp_ep_corr_msg_count[i+1] = exp_msg_cnt;
      end else begin
        exp_ep_corr_msg_count[i+1] = 0;
      end
    end

    hqm_mrd_cpl_id_chk      = ~$test$plusargs("HQM_MRD_CPL_ID_CHK_DIS");

    dis_err_msg_check       = $test$plusargs("HQM_DIS_ERR_MSG_CHECK");

    if(!$value$plusargs("HQM_STRAP_CMPL_SAI=%d",hqm_cmpl_sai_strap)) hqm_cmpl_sai_strap = `HQM_STRAP_CMPL_SAI;

    if(!$value$plusargs("HQM_STRAP_TX_SAI=%d",hqm_tx_sai_strap))     hqm_tx_sai_strap   = `HQM_STRAP_TX_SAI;

     strap_hqm_err_sb_sai = get_strap_val("HQM_STRAP_ERR_SB_SAI", `HQM_STRAP_ERR_SB_SAI);

     strap_hqm_tx_sai = get_strap_val("HQM_STRAP_TX_SAI", `HQM_STRAP_TX_SAI);

     strap_hqm_cmpl_sai = get_strap_val("HQM_STRAP_CMPL_SAI", `HQM_STRAP_CMPL_SAI);
           
     strap_hqm_resetprep_ack_sai = get_strap_val("HQM_STRAP_RESETPREP_ACK_SAI", `HQM_STRAP_RESETPREP_ACK_SAI);
  
     strap_hqm_resetprep_sai_0 = get_strap_val("HQM_STRAP_RESETPREP_SAI_0", `HQM_STRAP_RESETPREP_SAI_0);

     strap_hqm_resetprep_sai_1 = get_strap_val("HQM_STRAP_RESETPREP_SAI_1", `HQM_STRAP_RESETPREP_SAI_1);
    
     strap_hqm_force_pok_sai_0 = get_strap_val("HQM_STRAP_FORCE_POK_SAI_0", `HQM_STRAP_FORCE_POK_SAI_0);
    
     strap_hqm_force_pok_sai_1 = get_strap_val("HQM_STRAP_FORCE_POK_SAI_1", `HQM_STRAP_FORCE_POK_SAI_1);


     strap_hqm_do_serr_tag = get_strap_val("HQM_STRAP_DO_SERR_TAG", `HQM_STRAP_DO_SERR_TAG);

     strap_hqm_do_serr_sairs_valid = get_strap_val("HQM_STRAP_DO_SERR_SAIRS_VALID", `HQM_STRAP_DO_SERR_SAIRS_VALID);

     strap_hqm_do_serr_sai = get_strap_val("HQM_STRAP_DO_SERR_SAI", `HQM_STRAP_DO_SERR_SAI);

     strap_hqm_do_serr_rs = get_strap_val("HQM_STRAP_DO_SERR_RS", `HQM_STRAP_DO_SERR_RS);

     strap_hqm_fp_cfg_sai = get_strap_val("HQM_STRAP_FP_CFG_SAI", `HQM_STRAP_FP_CFG_SAI);

     strap_hqm_fp_cfg_sai_cmpl = get_strap_val("HQM_STRAP_FP_CFG_SAI_CMPL", `HQM_STRAP_FP_CFG_SAI_CMPL);

     strap_hqm_fp_cfg_tag = get_strap_val("HQM_STRAP_FP_CFG_TAG", `HQM_STRAP_FP_CFG_TAG);

     get_config_int("strap_hqm_gpsb_srcid", strap_hqm_gpsb_srcid);

     get_config_int("strap_hqm_fp_cfg_dstid", strap_hqm_fp_cfg_dstid);

     get_config_int("strap_hqm_err_sb_dstid", strap_hqm_err_sb_dstid);

     get_config_int("strap_hqm_fp_cfg_ready_dstid", strap_hqm_fp_cfg_ready_dstid);

     get_config_int("strap_hqm_do_serr_dstid", strap_hqm_do_serr_dstid);

     get_config_int("strap_hqm_16b_portids", strap_hqm_16b_portids);

  endfunction : get_plusarg_values

  // -----------------------------------------------------------------------------
  // -- Connect components
  // -----------------------------------------------------------------------------

  function void hqm_iosf_sb_checker::connect ();

    // ---------------------------------------- //
    // -- get handles to each register files -- //
    // ---------------------------------------- //

  endfunction : connect


  // -----------------------------------------------------------------------------
  // -- Run phase, spawns tasks to track expected err_msg, track force_pok chk
  // -----------------------------------------------------------------------------

  task hqm_iosf_sb_checker::run();
    `ovm_info("hqm_iosf_sb_checker", $sformatf("Entered run phase of hqm_iosf_sb_checker "), OVM_LOW)
	fork
	  exp_fatal_msg_loop();
	  exp_nfatal_msg_loop();
	  exp_corr_msg_loop();
	  force_pok_chk();
	join_none
  endtask : run

  // -----------------------------------------------------------------------------
  // -- Tracks force_pok msg related events
  // -----------------------------------------------------------------------------

  task hqm_iosf_sb_checker::force_pok_chk();
         forever begin 
              int side_rst_event = 15000000;
              int side_pok_event = 15000000;
              int prim_rst_event = 15000000;
              int prim_pok_event = 15000000;
              bit side_rst_recd  = 0;
              bit side_pok_recd  = 0;
              bit prim_rst_recd  = 0;
              bit prim_pok_recd  = 0;
              int clk_ticks      = 0;
              string pok_log     = $psprintf("side_rst_event(0x%0x), side_pok_event(0x%0x), prim_rst_event(0x%0x), prim_pok_event(0x%0x), side_rst_recd(0x%0x), side_pok_recd(0x%0x), prim_rst_recd(0x%0x), prim_pok_recd(0x%0x), clk_ticks(0x%0x)",side_rst_event, side_pok_event, prim_rst_event, prim_pok_event, side_rst_recd, side_pok_recd, prim_rst_recd, prim_pok_recd, clk_ticks);

              hqm_ip_force_pok_msg.wait_trigger(); 
              `ovm_info(get_full_name(), $psprintf("Received hqm_ip_force_pok event; starting force_pok_chk with %s", pok_log), OVM_LOW)
              fork  
                 begin  hqm_side_pok_deassert.wait_trigger(); side_pok_event=clk_ticks; side_pok_recd=1; end
                 begin  hqm_prim_pok_deassert.wait_trigger(); prim_pok_event=clk_ticks; prim_pok_recd=1; end
              join_none

              fork 
                 begin  hqm_prim_rst_assert.wait_trigger();   prim_rst_event=clk_ticks; prim_rst_recd=1; end
                 begin  hqm_side_rst_assert.wait_trigger();   side_rst_event=clk_ticks; side_rst_recd=1; end
                 begin  repeat(15000000) begin @(sla_tb_env::sys_clk_r); clk_ticks++; end                end
              join_any

              if (side_rst_recd==0) begin
                  fork 
                     begin  hqm_side_rst_assert.wait_trigger();   side_rst_event=clk_ticks; side_rst_recd=1; end
                     begin  repeat(15000000) begin @(sla_tb_env::sys_clk_r); clk_ticks++; end                end
                  join_any
              end

              @(sla_tb_env::sys_clk_r);

              disable fork;

              pok_log = $psprintf("side_rst_event(0x%0x), side_pok_event(0x%0x), prim_rst_event(0x%0x), prim_pok_event(0x%0x), side_rst_recd(0x%0x), side_pok_recd(0x%0x), prim_rst_recd(0x%0x), prim_pok_recd(0x%0x), clk_ticks(0x%0x)",side_rst_event, side_pok_event, prim_rst_event, prim_pok_event, side_rst_recd, side_pok_recd, prim_rst_recd, prim_pok_recd, clk_ticks);

              if (side_rst_recd == 0) begin
                  `ovm_error(get_full_name(), $psprintf("Timed out waiting for side_rst with %s", pok_log)) end
              else begin
                  `ovm_info(get_full_name(), $psprintf("Starting legal_force_pok_msg_sai(0x%0x) check with %s", legal_force_pok_msg_sai, pok_log), OVM_LOW)
    
                  if(legal_force_pok_msg_sai) begin
                       if((side_rst_event >= side_pok_event) && (prim_rst_event >= prim_pok_event)) begin
                             `ovm_info(get_full_name(), $psprintf("legal_force_pok_msg_sai check PASSED with %s", pok_log), OVM_LOW)
                       end else begin
                             `ovm_error(get_full_name(), $psprintf("legal_force_pok_msg_sai check FAILED with %s", pok_log))
                       end 
                  end else begin
                       if((side_rst_event <= side_pok_event) && (prim_rst_event <= prim_pok_event)) begin
                             `ovm_info(get_full_name(), $psprintf("Illegal_force_pok_msg_sai check PASSED with %s", pok_log), OVM_LOW)
                       end else begin
                             `ovm_error(get_full_name(), $psprintf("Illegal_force_pok_msg_sai check FAILED with %s", pok_log))
                       end
                  end
              end
         end 
  endtask: force_pok_chk

  // -----------------------------------------------------------------------------
  // -- Checks cmpl received for fuse pull requests
  // -----------------------------------------------------------------------------

  function hqm_iosf_sb_checker::chk_fuse_pull_cmpl(iosfsbm_cm::xaction txn);
      `ovm_info(get_full_name(), $psprintf("Received fuse_pull_cmpl; starting chk_fuse_pull_cmpl with"), OVM_LOW)
       hqm_fuse_pull_err = 1'b_1; hqm_op_fuse_pull_msg=1'b_0;
      if(txn.ext_headers.size() <= 3) begin
         `ovm_error(get_full_name(), $psprintf("No SAI value present for fuse_pull_cmpl sb pkt %s", txn.sprint_header()))
      end else begin
            `ovm_info(get_full_name(), $psprintf("Received SAI(0x%0x) in fuse_pull_cmpl msg sent to HQM with legal value: (0x%0x)",({txn.ext_headers[2],txn.ext_headers[1]}), strap_hqm_fp_cfg_sai_cmpl), OVM_LOW)

            if(({txn.ext_headers[2],txn.ext_headers[1]}) == strap_hqm_fp_cfg_sai_cmpl) begin
                hqm_fuse_pull_err = 1'b_0;
            end else begin
                hqm_fuse_pull_err = 1'b_1;
            end
      end

      `ovm_info(get_full_name(), $psprintf("fuse_pull_cmpl: Fuse Complete Msg size (Header=2DW, Data Stream size=2DW for correct response) in DW = %0d, fuse_pull_cmpl sb pkt %s",  txn.msg_size_dw, txn.sprint_header()), OVM_LOW)
      hqm_fuse_pull_err = (strap_hqm_16b_portids) ? ((txn.msg_size_dw != 5) ? 1 : hqm_fuse_pull_err) : ((txn.msg_size_dw != 4) ? 1 : hqm_fuse_pull_err);
      `ovm_info(get_full_name(), $psprintf("strap_hqm_16b_portids %0d, hqm_fuse_pull_err %0d, msg_size_dw %0d",  strap_hqm_16b_portids, hqm_fuse_pull_err, txn.msg_size_dw), OVM_LOW)
  endfunction : chk_fuse_pull_cmpl

  // -----------------------------------------------------------------------------
  // -- Tracks expected fatal msg
  // -----------------------------------------------------------------------------

  task hqm_iosf_sb_checker::exp_fatal_msg_loop();
       foreach(exp_ep_fatal_msg[i]) begin
         automatic int k = i;

         fork begin track_ep_fatal_msg(k); end join_none
       end
  endtask: exp_fatal_msg_loop

  // -----------------------------------------------------------------------------
  // -- Tracks expected non fatal msg
  // -----------------------------------------------------------------------------

  task hqm_iosf_sb_checker::exp_nfatal_msg_loop();
       foreach(exp_ep_nfatal_msg[i]) begin
         automatic int k = i;

         fork begin track_ep_nfatal_msg(k); end join_none
       end
  endtask: exp_nfatal_msg_loop

  // -----------------------------------------------------------------------------
  // -- Tracks expected corr msg
  // -----------------------------------------------------------------------------

  task hqm_iosf_sb_checker::exp_corr_msg_loop();
       foreach(exp_ep_corr_msg[i]) begin
         automatic int k = i;

         fork begin track_ep_corr_msg(k); end join_none
       end
  endtask: exp_corr_msg_loop

  // -----------------------------------------------------------------------------
  // -- Tracks expected fatal msg
  // -----------------------------------------------------------------------------

  task hqm_iosf_sb_checker::track_ep_fatal_msg(int func_num);
       forever begin exp_ep_fatal_msg[func_num].wait_trigger(); exp_ep_fatal_msg_count[func_num]++; exp_atleast_one_fatal_msg_count[func_num]=skip_chk; end
  endtask: track_ep_fatal_msg

  // -----------------------------------------------------------------------------
  // -- Tracks expected non fatal msg
  // -----------------------------------------------------------------------------

  task hqm_iosf_sb_checker::track_ep_nfatal_msg(int func_num);
       forever begin exp_ep_nfatal_msg[func_num].wait_trigger(); exp_ep_nfatal_msg_count[func_num]++; exp_atleast_one_nfatal_msg_count[func_num]=skip_chk; end
  endtask: track_ep_nfatal_msg

  // -----------------------------------------------------------------------------
  // -- Tracks expected corr msg
  // -----------------------------------------------------------------------------

  task hqm_iosf_sb_checker::track_ep_corr_msg(int func_num);
       forever begin exp_ep_corr_msg[func_num].wait_trigger(); exp_ep_corr_msg_count[func_num]++; exp_atleast_one_corr_msg_count[func_num]=skip_chk; end
  endtask: track_ep_corr_msg

  // -----------------------------------------------------------------------------
  // -- Get register value from RAL mirror
  // -----------------------------------------------------------------------------

 function sla_ral_data_t hqm_iosf_sb_checker::get_reg_value(string reg_name, string file_name, bit ro = 1'b_0);
   sla_ral_reg my_reg ;
   my_reg   = ral.find_reg_by_file_name(reg_name, file_name);
   if(my_reg != null) begin if(ro || $isunknown(my_reg.get_actual())) return my_reg.get_reset_val(); else return my_reg.get_actual(); end
   else               `ovm_error(get_full_name(), $psprintf("Null reg handle received for %s.%s", file_name, reg_name))
 endfunction: get_reg_value

 // -----------------------------------------------------------------------------
 // -- Check EH Id is 0 when EH = 0/DO_SERR_SAIRS_VALID strap is set to 0 
 // -----------------------------------------------------------------------------
  function hqm_iosf_sb_checker::chk_eh(iosf_sb_txn_t txn); 
    if(strap_hqm_do_serr_sairs_valid == 0) begin
      if(txn.opcode == OP_DOSERR) begin 
        if(txn.sb_txn.EH == 0) begin 
          if(txn.sb_txn.ext_headers[0][6:0] != 0)
            `ovm_error(get_full_name(), $psprintf("Extended Header Id is supposed to be 0 when EH = 0. Received Extended Header Id = 0x%0x", txn.sb_txn.ext_headers[0][6:0]))
          else  
            `ovm_info(get_full_name(), $psprintf("Received Extended Header Id is 0 as expected"), OVM_LOW)
        end
      end else if(txn.sb_txn.EH == 0) begin 
        `ovm_error(get_full_name(), $psprintf("Extended Header is supposed to be 0x1. Received Extended Header = 0x%0x", txn.sb_txn.EH))
      end  
    end else begin
      if(txn.sb_txn.EH == 0) begin 
        `ovm_error(get_full_name(), $psprintf("Extended Header is supposed to be 0x1. Received Extended Header = 0x%0x", txn.sb_txn.EH))
      end  
    end
  endfunction  

  // -----------------------------------------------------------------------------
  // -- Sends txn received from decoder for checks
  // -----------------------------------------------------------------------------

  function hqm_iosf_sb_checker::chk_pkt_from_ep(iosf_sb_txn_t pkt);

    `ovm_info(get_full_name(), $psprintf("SB_CHECK::chk_pkt_from_ep received %0s SB message from HQM and check", pkt.opcode.name()), OVM_LOW)
    // -- Below types received from HQM -- // 
    if(pkt.opcode inside { OP_FUSEMSG, OP_IPREADY,   OP_CPL,  OP_CPLD,  OP_RESETPREPACK,  OP_PCIEERRMSG, OP_DOSERR } ) begin
          // -- Common checks -- //
          chk_sai(pkt);                  // -- Check SAI  on outbound txn    -- //
          chk_eh(pkt);                   // -- Check EH related info         -- //  
          chk_srcid_dstid(pkt);          // -- SRCID and DSTID of txn        -- //
          // -- Sample CplId for checks  -- // 
	      if(pkt.opcode inside {OP_CPL      ,  OP_CPLD                        } ) chk_cpl_pkt(pkt);
          if(pkt.opcode ==  OP_PCIEERRMSG                                       ) chk_err_msg_pkt(pkt.sb_txn); 
          if(pkt.opcode ==  OP_FUSEMSG                                          ) hqm_op_fuse_pull_msg = 1'b_1; 
          if(pkt.opcode ==  OP_IPREADY                                          ) chk_ipready_pkt(pkt.sb_txn); 

          if(pkt.opcode ==  OP_RESETPREPACK                                     ) begin
              string rpacklog = $psprintf("Received ResetPrepAck msg from HQM with legal_resetprep_msg_sai(0x%0x)",legal_resetprep_msg_sai);
              if(legal_resetprep_msg_sai) begin `ovm_info(get_full_name(), $psprintf("%s", rpacklog), OVM_LOW) end
              else                        begin `ovm_error(get_full_name(), $psprintf("%s", rpacklog))         end        
          end 
    end
    else if(pkt.opcode == IP_RESETPREP)  begin chk_sai_resetprep(pkt.sb_txn); end
    else if(pkt.opcode == IP_PWRGATEPOK) begin chk_sai_force_pok(pkt.sb_txn); end
    else if(pkt.opcode == IP_CPLD      ) begin if(hqm_op_fuse_pull_msg) chk_fuse_pull_cmpl(pkt.sb_txn); end
    else if(pkt.opcode == IP_CPL      ) begin if(hqm_op_fuse_pull_msg) hqm_fuse_pull_err=0; end //Completion with no data is a valid response to the pull request.  Expectation should be IP_READY with tag=0 and reset values.
  endfunction : chk_pkt_from_ep

  // -----------------------------------------------------------------------------
  // -- Check SAI val on force_pok sent to DUT
  // -----------------------------------------------------------------------------

  function hqm_iosf_sb_checker::chk_sai_force_pok(iosfsbm_cm::xaction txn);

      hqm_ip_force_pok_msg.trigger();
      if(txn.ext_headers.size() <= 3) begin
         `ovm_error(get_full_name(), $psprintf("No SAI value present for force_pok sb pkt %s", txn.sprint_header()))
      end else begin
            `ovm_info(get_full_name(), $psprintf("Received SAI(0x%0x) in force_pok msg sent to HQM with legal values: (0x%0x) & (0x%0x)",({txn.ext_headers[2],txn.ext_headers[1]}), strap_hqm_force_pok_sai_0,strap_hqm_force_pok_sai_1), OVM_LOW)

            if(({txn.ext_headers[2],txn.ext_headers[1]}) inside {strap_hqm_force_pok_sai_0, strap_hqm_force_pok_sai_1} ) begin
                legal_force_pok_msg_sai = 1'b_1; hqm_re_enable_pok_check.trigger();
            end else begin
                legal_force_pok_msg_sai = 1'b_0; hqm_waive_pok_check.trigger();
            end
      end

  endfunction : chk_sai_force_pok

  // -----------------------------------------------------------------------------
  // -- Check SAI val on resetprep sent to DUT
  // -----------------------------------------------------------------------------

  function hqm_iosf_sb_checker::chk_sai_resetprep(iosfsbm_cm::xaction txn);

      if(txn.ext_headers.size() <= 3) begin
         `ovm_error(get_full_name(), $psprintf("No SAI value present for sb pkt %s", txn.sprint_header()))
      end else begin
            `ovm_info(get_full_name(), $psprintf("Received SAI(0x%0x) in resetprep msg sent to HQM with legal values: (0x%0x) & (0x%0x)",({txn.ext_headers[2],txn.ext_headers[1]}), strap_hqm_resetprep_sai_0,strap_hqm_resetprep_sai_1), OVM_LOW)

            if(({txn.ext_headers[2],txn.ext_headers[1]}) inside {strap_hqm_resetprep_sai_0, strap_hqm_resetprep_sai_1} ) begin
                legal_resetprep_msg_sai = 1'b_1;
            end else begin
                legal_resetprep_msg_sai = 1'b_0;
            end
      end

  endfunction : chk_sai_resetprep

  // -----------------------------------------------------------------------------
  // -- Check SAI val for outbound txns from DUT
  // -----------------------------------------------------------------------------

  function hqm_iosf_sb_checker::chk_sai_val(int exp_sai, iosfsbm_cm::xaction txn);
    if(txn.ext_headers.size() <= 3)        
         `ovm_error(get_full_name(), $psprintf("No SAI value present for sb pkt %s", txn.sprint_header()))
    else if({txn.ext_headers[2],txn.ext_headers[1]} != exp_sai) 
         `ovm_error(get_full_name(), $psprintf("SAI value check FAILED: obs(0x%0x), exp(0x%0x) for txn %s", {txn.ext_headers[2],txn.ext_headers[1]}, exp_sai, txn.sprint_header()))
    else
         `ovm_info(get_full_name(), $psprintf("SAI value check PASSED: obs(0x%0x), exp(0x%0x) for txn %s", {txn.ext_headers[2],txn.ext_headers[1]}, exp_sai, txn.sprint_header()), OVM_LOW)
  endfunction : chk_sai_val

  function hqm_iosf_sb_checker::chk_sai(iosf_sb_txn_t mon_txn);
   // review: -- Check that SAI for IPREADY and FUSEMSG are same --//
    case(mon_txn.opcode)
     OP_FUSEMSG      : chk_sai_val(strap_hqm_fp_cfg_sai, mon_txn.sb_txn);
     OP_IPREADY      : chk_sai_val(strap_hqm_fp_cfg_sai, mon_txn.sb_txn); // -- As per HQM Subsystem HAS, IP_READY msg sai should be fuse puller msg sai.
     OP_CPL          : chk_sai_val(strap_hqm_cmpl_sai,   mon_txn.sb_txn); // -- review: get expect value from spec.
     OP_CPLD         : chk_sai_val(strap_hqm_cmpl_sai,   mon_txn.sb_txn); // -- review: get expect value from spec.
     OP_RESETPREPACK : chk_sai_val(strap_hqm_resetprep_ack_sai, mon_txn.sb_txn);
     OP_PCIEERRMSG   : chk_sai_val(strap_hqm_err_sb_sai,  mon_txn.sb_txn);
     OP_DOSERR       : begin 
                          string tlog = $psprintf("SAIRS HDR present with strap_hqm_do_serr_sairs_valid (0x%0x) for sb pkt: ", strap_hqm_do_serr_sairs_valid);
                          if(strap_hqm_do_serr_sairs_valid == 0) begin
                               if (mon_txn.sb_txn.ext_headers.size() > 3) begin    
                                   `ovm_error(get_full_name(), $psprintf("%s %s", tlog, mon_txn.sb_txn.sprint_header()))
                               end else begin
                                   `ovm_info(get_full_name(), $psprintf("No %s %s",tlog, mon_txn.sb_txn.sprint_header()), OVM_LOW)
                               end
                          end else begin
                               chk_sai_val(strap_hqm_do_serr_sai, mon_txn.sb_txn);
                          end
                       end
    endcase
    
  endfunction : chk_sai

  // -----------------------------------------------------------------------------
  // -- Check ID val SRCID/DSTID for outbound txns from DUT
  // -----------------------------------------------------------------------------

  function hqm_iosf_sb_checker::chk_id_val(int exp_id, int obs_id, iosfsbm_cm::xaction txn);
    string log = $sformatf("exp_id(0x%0x), obs_id(0x%0x)", exp_id, obs_id);
    if(exp_id != obs_id) `ovm_error(get_full_name(), $psprintf("SRC/DEST ID chk FAILED as %s for txn %s", log, txn.sprint_header())) 
    else                 `ovm_info(get_full_name(),  $psprintf("SRC/DEST ID chk PASSED as %s for txn %s", log, txn.sprint_header()), OVM_LOW) 
  endfunction : chk_id_val

  // -----------------------------------------------------------------------------
  // -- Check SRCID/DSTID for outbound txns from DUT
  // -----------------------------------------------------------------------------

  function hqm_iosf_sb_checker::chk_srcid_dstid(iosf_sb_txn_t mon_txn);
// -- review: Include SRCID and DESTID chks for each of opcode below.
    case(mon_txn.opcode)
     OP_FUSEMSG      : begin
                         if (strap_hqm_16b_portids) begin 
                            chk_id_val(strap_hqm_gpsb_srcid, {mon_txn.sb_txn.src_pid,mon_txn.sb_txn.local_src_pid}, mon_txn.sb_txn); 
                            chk_id_val(strap_hqm_fp_cfg_dstid, {mon_txn.sb_txn.dest_pid,mon_txn.sb_txn.local_dest_pid}, mon_txn.sb_txn);
                         end
                         else begin 
                            chk_id_val(strap_hqm_gpsb_srcid[7:0], mon_txn.sb_txn.src_pid, mon_txn.sb_txn); 
                            chk_id_val(strap_hqm_fp_cfg_dstid[7:0], mon_txn.sb_txn.dest_pid, mon_txn.sb_txn);
                         end 
                       end
     OP_IPREADY      : begin 
                         if (strap_hqm_16b_portids) begin 
                            chk_id_val(strap_hqm_gpsb_srcid, {mon_txn.sb_txn.src_pid,mon_txn.sb_txn.local_src_pid}, mon_txn.sb_txn); 
                            chk_id_val(strap_hqm_fp_cfg_ready_dstid, {mon_txn.sb_txn.dest_pid,mon_txn.sb_txn.local_dest_pid}, mon_txn.sb_txn); 
                         end
                         else begin 
                            chk_id_val(strap_hqm_gpsb_srcid[7:0], mon_txn.sb_txn.src_pid, mon_txn.sb_txn); 
                            chk_id_val(strap_hqm_fp_cfg_ready_dstid[7:0], mon_txn.sb_txn.dest_pid, mon_txn.sb_txn); 
                         end 
                       end
     OP_CPL          : ;// -- Check present within IOSF_Sideband_Message_VC_USER_GUIDE (SVC), section 12.3, VR.SBC.0099  & VR.SBC.0100;
     OP_CPLD         : ;// -- Check present within IOSF_Sideband_Message_VC_USER_GUIDE (SVC), section 12.3, VR.SBC.0099  & VR.SBC.0100;
     OP_RESETPREPACK : begin 
                         if (strap_hqm_16b_portids) begin 
                            chk_id_val(strap_hqm_gpsb_srcid, {mon_txn.sb_txn.src_pid,mon_txn.sb_txn.local_src_pid}, mon_txn.sb_txn);
                         end
                         else begin 
                            chk_id_val(strap_hqm_gpsb_srcid[7:0], mon_txn.sb_txn.src_pid, mon_txn.sb_txn);
                         end 
                       end 
     OP_PCIEERRMSG   : begin 
                         if (strap_hqm_16b_portids) begin 
                            chk_id_val(strap_hqm_gpsb_srcid, {mon_txn.sb_txn.src_pid,mon_txn.sb_txn.local_src_pid}, mon_txn.sb_txn); 
                            chk_id_val(strap_hqm_err_sb_dstid,  {mon_txn.sb_txn.dest_pid,mon_txn.sb_txn.local_dest_pid}, mon_txn.sb_txn); 
                         end
                         else begin 
                            chk_id_val(strap_hqm_gpsb_srcid[7:0], mon_txn.sb_txn.src_pid, mon_txn.sb_txn); 
                            chk_id_val(strap_hqm_err_sb_dstid[7:0],  mon_txn.sb_txn.dest_pid, mon_txn.sb_txn); 
                         end 
                       end
     OP_DOSERR       : begin 
                         if (strap_hqm_16b_portids) begin 
                            chk_id_val(strap_hqm_gpsb_srcid, {mon_txn.sb_txn.src_pid,mon_txn.sb_txn.local_src_pid},   mon_txn.sb_txn); 
                            chk_id_val(strap_hqm_do_serr_dstid, {mon_txn.sb_txn.dest_pid,mon_txn.sb_txn.local_dest_pid},   mon_txn.sb_txn); 
                         end
                         else begin 
                            chk_id_val(strap_hqm_gpsb_srcid[7:0], mon_txn.sb_txn.src_pid,   mon_txn.sb_txn); 
                            chk_id_val(strap_hqm_do_serr_dstid[7:0], mon_txn.sb_txn.dest_pid,   mon_txn.sb_txn); 
                         end 
                       end
    endcase
    
  endfunction : chk_srcid_dstid

  // -----------------------------------------------------------------------------
  // -- Check cpl packet
  // -----------------------------------------------------------------------------

  function hqm_iosf_sb_checker::chk_cpl_pkt(iosf_sb_txn_t pkt);
    case(pkt.opcode) 
      OP_CPLD: chk_cpld_length(pkt.sb_txn); 
    endcase
  endfunction : chk_cpl_pkt

  // ---------------------------------------------------- //
  // -- Check that length field doesn't exceed MPS set -- //
  // ---------------------------------------------------- //
  function hqm_iosf_sb_checker::chk_cpld_length(iosfsbm_cm::xaction mon_txn);
    sla_ral_data_t ral_data = get_reg_value("pcie_cap_device_control", "hqm_pf_cfg_i");
    if(mon_txn.msg_size_dw > (get_mps_dw(ral_data[7:5])) ) begin
      `ovm_error(get_full_name(), $sformatf("Received CplD pkt with length > MPS (0x%0x): %s", get_mps_dw(ral_data[7:5]), mon_txn.convert2string()))
    end
  endfunction : chk_cpld_length
 
  // -----------------------------------------------------------------------------
  // -- Returns MPS in DW
  // -----------------------------------------------------------------------------
 
  function int hqm_iosf_sb_checker::get_mps_dw(bit [2:0] mps);
    get_mps_dw = 'h_0;
    case(mps) 
      3'b_000: get_mps_dw =  128/4; 
      3'b_001: get_mps_dw =  256/4; 
      3'b_010: get_mps_dw =  512/4; 
      3'b_011: get_mps_dw = 1024/4; 
      3'b_100: get_mps_dw = 2048/4; 
      3'b_101: get_mps_dw = 4096/4; 
      default: begin get_mps_dw = 4096/4; `ovm_warning(get_full_name(), "Unsupported MSP programmed to DUT !!"); end
    endcase
  endfunction

  // -----------------------------------------------------------------------------
  // -- Check IP_READY pkt
  // -----------------------------------------------------------------------------

  function hqm_iosf_sb_checker::chk_ipready_pkt(iosfsbm_cm::xaction mon_txn);
      string log = $psprintf("IP_READY Received with tag(0x%0x) && hqm_fuse_pull_err(0x%0x)", mon_txn.tag, hqm_fuse_pull_err);
      if(mon_txn.tag != hqm_fuse_pull_err) begin `ovm_error(get_full_name(), $psprintf("Fuse pull chk FAILED as %s",log))         end
      else                                 begin `ovm_info(get_full_name(), $psprintf("Fuse pull chk PASSED as %s",log), OVM_LOW) end
  endfunction: chk_ipready_pkt

  // -----------------------------------------------------------------------------
  // -- Check ERR_MSG pkt
  // -----------------------------------------------------------------------------

  function hqm_iosf_sb_checker::chk_err_msg_pkt(iosfsbm_cm::xaction mon_txn);
    iosfsbm_cm::msgd_xaction msgd;
    if (!$cast(msgd, mon_txn)) begin
        `ovm_fatal(get_full_name(), $psprintf("casting in chk_err_msg_pkt failed"))
    end 
    //if(is_reqid_legal(mon_txn) || ( mon_txn.msg[8] < (`MAX_NO_OF_VFS+1) ) ) begin     // -- check reqId received from ep is within legal values -- //
    if(is_reqid_legal(msgd) || ( msgd.data[0] < (`MAX_NO_OF_VFS+1) ) ) begin     // -- check reqId received from ep is within legal values -- //
      case(msgd.data[2])         // -- Err msg code
        8'h_31 : begin obs_ep_nfatal_msg[msgd.data[0] - func_base].trigger();  obs_ep_nfatal_msg_count[msgd.data[0] - func_base]++; end 
        8'h_33 : begin obs_ep_fatal_msg[msgd.data[0] - func_base].trigger() ;  obs_ep_fatal_msg_count[msgd.data[0] - func_base]++ ; end   
        8'h_30 : begin obs_ep_corr_msg[msgd.data[0] - func_base].trigger()  ;  obs_ep_corr_msg_count[msgd.data[0] - func_base]++  ; end  
        default: `ovm_error(get_full_name(), $psprintf("Received unsupported ERR_MSG code (0x%0x) from HQM", msgd.data[2]))
      endcase
    end
    else begin
      `ovm_error(get_full_name(), $psprintf("Received illegal reqId from HQM with: is_reqid_legal(0x%0x) for func number (0x%0x)",is_reqid_legal(msgd),msgd.data[0]))
    end
  endfunction: chk_err_msg_pkt

  // -----------------------------------------------------------------------------
  // -- Checks if reqid of ERR_MSG is legal
  // -----------------------------------------------------------------------------

  function bit hqm_iosf_sb_checker::is_reqid_legal(iosfsbm_cm::xaction mon_txn);
    bit            illegal;
    string         tlog = "out of allowed ";
    string         log  = "";
    sla_ral_data_t ral_data;
    bit  [7:0]     allowed_func_num[$];
    bit  [7:0]     func_num;
   
    iosfsbm_cm::msgd_xaction msgd;
    if (!$cast(msgd, mon_txn)) begin
        `ovm_fatal(get_full_name(), $psprintf("casting in is_reqid_legal failed"))
    end 
    func_num = msgd.data[0];
    allowed_func_num.delete();

    allowed_func_num.push_back(func_base); // -- PF always an allowed function -- //

    foreach(allowed_func_num[i]) tlog = $psprintf("%s (0x%0x) ", tlog, allowed_func_num[i]);

    // -- Check function number value -- //
       illegal = 1;
       foreach(allowed_func_num[i]) if(allowed_func_num[i] == func_num[7:0]) begin illegal = 1'b_0; break; end
       if(illegal) `ovm_error(get_full_name(), $psprintf("Illegal Function number (0x%0x) received from EP %s",func_num,log))
       else        `ovm_info( get_full_name(), $psprintf("  Legal Function number (0x%0x) received from EP %s",func_num,log), OVM_LOW)

    // -- Check bus number value -- //
    if(illegal == 0) begin
         if((msgd.data[1] != get_bus_num_per_func(func_num-func_base)) && (~bypass_bus_num_check)) //msgd.data[9]
               `ovm_error(get_full_name(), $psprintf("Illegal bus number (0x%0x) received from EP for func (0x%0x); expected->(0x%0x) ",msgd.data[1],func_num,get_bus_num_per_func(func_num)))
         else  `ovm_info(get_full_name(),  $psprintf("  Legal bus number (0x%0x) received from EP for func (0x%0x); expected->(0x%0x) ",msgd.data[1],func_num,get_bus_num_per_func(func_num)), OVM_LOW)
    end

    is_reqid_legal = ~illegal;

  endfunction: is_reqid_legal

  // -----------------------------------------------------------------------------
  // -- Get bus number associated with a function
  // -----------------------------------------------------------------------------

 function int hqm_iosf_sb_checker::get_bus_num_per_func(int func_num);
   sla_ral_reg my_reg ;
   get_bus_num_per_func = 0; // -- default 

   if(func_num==0) my_reg   = ral.find_reg_by_file_name("device_command", $psprintf("hqm_pf_cfg_i"));

   if(my_reg != null) begin get_bus_num_per_func = my_reg.get_bus_num(); end
   else               `ovm_error(get_full_name(), $psprintf("Null reg handle received for device_command register for func (0x%0x)", func_num))

 endfunction: get_bus_num_per_func

  // -----------------------------------------------------------------------------
  // -- Receive txns from decoder
  // -----------------------------------------------------------------------------
  function void hqm_iosf_sb_checker::write(iosf_sb_txn_t ep_pkt);
    if (ep_pkt.sb_txn != null) chk_pkt_from_ep(ep_pkt);
    else                       `ovm_error(get_full_name(), $psprintf("Received null (0x%0x) iosfsbm_cm::xaction in analysis imp write", (ep_pkt.sb_txn==null)))
  endfunction : write

  // -----------------------------------------------------------------------------
  // -- Returns strap value given plusarg name
  // -----------------------------------------------------------------------------

  function longint hqm_iosf_sb_checker::get_strap_val(string plusarg_name, longint default_val);
    string val_string = "";
    if(!$value$plusargs({$sformatf("%s",plusarg_name),"=%s"}, val_string)) begin
       get_strap_val = default_val; // -- Assign default value of strap, if no plusarg provided -- //
    end
    else if (lvm_common_pkg::token_to_longint(val_string,get_strap_val) == 0) begin
      `ovm_error(get_full_name(),$psprintf("+%s=%s not a valid integer value",plusarg_name,val_string))
      get_strap_val = default_val; // -- Assign default value of strap, if invalid plusarg usage -- //
    end

    // -- Finally print the resolved strap value -- //
    `ovm_info(get_full_name(), $psprintf("Resolved strap (%s) with value (0x%0x) ", plusarg_name, get_strap_val), OVM_LOW);

  endfunction

  // -----------------------------------------------------------------------------
  // -- Reports EOT checks 
  // -----------------------------------------------------------------------------

  function void hqm_iosf_sb_checker::report();
    `ovm_info("hqm_iosf_sb_checker", $sformatf("Entered report phase of hqm_iosf_sb_checker "), OVM_LOW)
    if (dis_err_msg_check==0) begin
      chk_ep_fatal_msg_count(); 
      chk_ep_nfatal_msg_count(); 
      chk_ep_corr_msg_count();
    end
  endfunction : report

  // -----------------------------------------------------------------------------
  // -- Check fatal msg count at EOT
  // -----------------------------------------------------------------------------

  function hqm_iosf_sb_checker::chk_ep_fatal_msg_count();
    foreach(exp_ep_fatal_msg_count[i]) begin 
       string log = $psprintf("exp #(0x%0x), obs #(0x%0x) & atleast one (0x%0x)",exp_ep_fatal_msg_count[i],obs_ep_fatal_msg_count[i],exp_atleast_one_fatal_msg_count[i]);
       if(exp_atleast_one_fatal_msg_count[i] && obs_ep_fatal_msg_count[i]>0) 
          `ovm_info(get_full_name(),$psprintf("EOT: Atleast one Fatal ERR_MSG func #(0x%0x) count chk PASSES: %s",i,log),OVM_LOW)
       else if(exp_ep_fatal_msg_count[i]==obs_ep_fatal_msg_count[i]) 
          `ovm_info(get_full_name(),$psprintf("EOT: Fatal ERR_MSG func #(0x%0x) count chk PASSES: %s",i,log),OVM_LOW)
       else
          `ovm_error(get_full_name(),$psprintf("EOT: Fatal ERR_MSG func #(0x%0x) count chk FAILED: %s",i,log))
    end
  endfunction:chk_ep_fatal_msg_count

  // -----------------------------------------------------------------------------
  // -- Check non fatal msg count at EOT
  // -----------------------------------------------------------------------------

  function hqm_iosf_sb_checker::chk_ep_nfatal_msg_count();
    //--HQMV25 -- foreach(exp_ep_nfatal_msg_count[i]) begin 
    for(int i=0; i<1; i++) begin 
       string log = $psprintf("exp #(0x%0x), obs #(0x%0x) & atleast one (0x%0x)",exp_ep_nfatal_msg_count[i],obs_ep_nfatal_msg_count[i],exp_atleast_one_nfatal_msg_count[i]);
       if(exp_atleast_one_nfatal_msg_count[i] && obs_ep_nfatal_msg_count[i]>0) 
          `ovm_info(get_full_name(),$psprintf("EOT: Atleast one Non-Fatal ERR_MSG func #(0x%0x) count chk PASSES: %s",i,log),OVM_LOW)
       else if(exp_ep_nfatal_msg_count[i]==obs_ep_nfatal_msg_count[i])
          `ovm_info(get_full_name(),$psprintf("EOT: Non-fatal ERR_MSG func #(0x%0x) count chk PASSES: %s",i,log),OVM_LOW)
       else
          `ovm_error(get_full_name(),$psprintf("EOT: Non-fatal ERR_MSG func #(0x%0x) count chk FAILED: %s",i,log))
    end
  endfunction:chk_ep_nfatal_msg_count

  // -----------------------------------------------------------------------------
  // -- Check corr msg count at EOT
  // -----------------------------------------------------------------------------

  function hqm_iosf_sb_checker::chk_ep_corr_msg_count();
    foreach(exp_ep_corr_msg_count[i]) begin 
       string log = $psprintf("exp #(0x%0x), obs #(0x%0x) & atleast one (0x%0x)",exp_ep_corr_msg_count[i],obs_ep_corr_msg_count[i],exp_atleast_one_corr_msg_count[i]);
       if(exp_atleast_one_corr_msg_count[i] && obs_ep_corr_msg_count[i]>0) 
          `ovm_info(get_full_name(),$psprintf("EOT: Atleast one Correctable ERR_MSG func #(0x%0x) count chk PASSES: %s",i,log),OVM_LOW)
       else if(exp_ep_corr_msg_count[i]==obs_ep_corr_msg_count[i])
          `ovm_info(get_full_name(),$psprintf("EOT: Correctable ERR_MSG func #(0x%0x) count chk PASSES: %s",i,log),OVM_LOW)
       else
          `ovm_error(get_full_name(),$psprintf("EOT: Correctable ERR_MSG func #(0x%0x) count chk FAILED: %s",i,log))
    end
  endfunction:chk_ep_corr_msg_count


`endif
