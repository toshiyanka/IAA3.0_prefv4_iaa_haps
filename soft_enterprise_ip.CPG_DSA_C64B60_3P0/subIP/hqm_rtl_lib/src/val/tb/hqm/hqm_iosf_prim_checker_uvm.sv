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

`ifndef HQM_IOSF_PRIM_CHECKER__SV 
`define HQM_IOSF_PRIM_CHECKER__SV 

//------------------------------------------------------------------------------
// File        : hqm_iosf_prim_checker.sv
// Author      : Neeraj Shete
//
// Description : This class is derived form uvm_component and it intends to
//               cover the below checks not present in PVC. 
//               - Check completer ID for every NP txn sent to HQM.
//               - Check requester ID is legal limits for requests from HQM.
//               - Check observed MSI  INT count matches expected at EOT.
//               - Check observed MSIX INT count matches expected at EOT.
//               - Check observed IMS  INT count matches expected at EOT.
//               - Check SAI  field of every pkt received from HQM.
//               - Check EIDO field of every pkt received from HQM.
//               - Check MWr64 pkt has upper 32 address bits non-zero.
//               - Check payload length in CplD pkt does not cross MPS.
//               - Check No Snoop field of every pkt received from HQM.
//               - Check Relaxed Ordering field of every pkt received from HQM.
//               - Check BCM field is '0' for every Cpl pkt received from HQM.
//               - Check ordering for every Cpl pkt received from HQM.
//               
//------------------------------------------------------------------------------

import uvm_pkg::*;
`include "uvm_macros.svh"
import IosfPkg::*;

`ifdef XVM
   import ovm_pkg::*;
   import xvm_pkg::*;
   `include "ovm_macros.svh"
   `include "sla_macros.svh"
`endif

import sla_pkg::*;

`include "hqm_iosf_defines.sv"

class hqm_iosf_prim_checker extends uvm_component;

   uvm_analysis_imp #(iosf_trans_type_st, hqm_iosf_prim_checker) hqm_iosf_prim_txn_imp;

  `uvm_component_utils(hqm_iosf_prim_checker)

  // ---------------------------------------------------------------
  // -- Globals
  // ---------------------------------------------------------------
  string                          inst_suffix = "";
  sla_ral_env	                 ral;                      // -- Used to get register values 
  string                         ral_tb_env_hier = "*";    // -- Useful with multiple ral instances
  protected    bit [7:0]         func_base;                // -- Pf_func # -> varied by plusarg
  protected    bit               hqm_is_reg_ep_arg;        // -- If '1' -> EP mode, otherwise RCIEP mode
  protected    bit [7:0]         ep_bus_num_q[*];          // -- Stores current bus/dev # for each function
  protected    bit [7:0]         ep_bus_num_next_q[*];     // -- Stores next possible bus/dev # for each function
  protected    bit [7:0]         ep_bus_num_prev_q[*];     // -- Stores previous bus/dev # for each function, Useful if CfgWr0 is URed.
  protected    bit [25:0]        cfg_txnid_q[$];           // -- Store cfg txnid sent to EP 
  protected    bit [25:0]        mem_txnid_q[$];           // -- Store mem txnid sent to EP
  protected    bit [25:0]        exp_cfg_cplid_q[$];       // -- Store expect cfg cplid 
  protected    bit [25:0]        exp_mem_cplid_q[$];       // -- Store expect mem cplid
  protected    bit [25:0]        np_req_outstanding_q[$];  // -- Store np req txnid sent to EP
  protected    bit [25:0]        cfgwr_txnid_q[$];         // -- Store cfgwr0 txnid sent to EP
  protected    bit               ten_bit_tag_en;           // -- Value of strap driven to HQM
  protected    bit		         hqm_pcie_rc_vip_present;  // -- Place holder
  protected    bit               func_flr[`MAX_NO_OF_VFS+1]; // -- If func_flr[n] == 1 -> FLR is in progress for func 'n'.
  protected    bit               hqm_skip_msi_misx_clear_check; // -- Disable msi/msix clear check
  protected    sla_ral_reg       reg_cache[string];
  protected    bit               bypass_cplid_check = 0;

  // ---------------------------------------------------------------
  // -- Event pool
  // ---------------------------------------------------------------

  uvm_event_pool glbl_pool;
  uvm_event      cpl_to_eot_ended;
  uvm_event      ep_msix[`HQM_NUM_MSIX_VECTOR];
  uvm_event      exp_ep_msix[`HQM_NUM_MSIX_VECTOR];
  uvm_event      ep_msi[`MAX_NO_OF_VFS];
  uvm_event      exp_ep_msi[`MAX_NO_OF_VFS];
  uvm_event      ep_ims[`HQM_NUM_IMS_VECTOR+`HQM_NUM_IMS_VECTOR_DIR];
  uvm_event      exp_ep_ims[`HQM_NUM_IMS_VECTOR+`HQM_NUM_IMS_VECTOR_DIR];

  uvm_event      ep_start_of_flr[`MAX_NO_OF_VFS+1];
  uvm_event      ep_end_of_flr[`MAX_NO_OF_VFS+1];

  // ---------------------------------------------------------------
  // -- To hold the number of expected MSI* interrupts 
  // ---------------------------------------------------------------
  int            exp_ep_msix_count[`HQM_NUM_MSIX_VECTOR];
  int            exp_ep_msi_count[`MAX_NO_OF_VFS];
  int            exp_ep_ims_count[`HQM_NUM_IMS_VECTOR+`HQM_NUM_IMS_VECTOR_DIR];

  // ---------------------------------------------------------------
  // -- To hold the number of observed MSI* interrupts 
  // ---------------------------------------------------------------
  int            obs_ep_msix_count[`HQM_NUM_MSIX_VECTOR];
  int            obs_ep_msi_count[`MAX_NO_OF_VFS];
  int            obs_ep_ims_count[`HQM_NUM_IMS_VECTOR+`HQM_NUM_IMS_VECTOR_DIR];

  // ---------------------------------------------------------------
  // -- Disable check options
  // ---------------------------------------------------------------
  protected bit     hqm_mrd_cpl_id_chk     ; 
  protected bit     hqm_eot_cplid_chk      ;

  // ---------------------------------------------------------------
  // -- Strap values driven to HQM
  // ---------------------------------------------------------------
  protected bit [7:0]     hqm_cmpl_sai_strap      ;
  protected bit [7:0]     hqm_tx_sai_strap        ;

  // ---------------------------------------------------------------
  // -- Methods within hqm_iosf_prim_checker
  // ---------------------------------------------------------------
  extern    function                  new( string name = "hqm_iosf_prim_checker", uvm_component parent = null);
  extern    virtual    function void  build_phase(uvm_phase phase);
  extern    virtual    task           run_phase (uvm_phase phase);
  extern    virtual    function void  report_phase(uvm_phase phase);

  extern               function void  set_inst_suffix(string new_inst_suffix);
  extern               function void  get_plusarg_values();
  extern               function void  connect_phase (uvm_phase phase);
  extern               function void  check_txnid_q();
  extern               function void  reset_txnid_q();
  extern               function void  set_bypass_cplid_check(bit val);
  extern               function void  reset_ep_bus_num_q();
  extern               function void  reset_func_flr_status();
  extern               function void  check_cplid(bit   [25:0] received_txnid , hqm_trans_type_e ip_req);
  extern               function bit   is_cfg_tag(IosfMonTxn mon_txn, bit   [2:0] cpl_stat);
  extern               function bit   is_memrd_tag(IosfMonTxn mon_txn, bit   [2:0] cpl_stat);
  extern               function       capture_txnid_cfgwr(IosfMonTxn mon_txn);
  extern               function       capture_txnid_memrd(IosfMonTxn mon_txn);
  extern               function void  capture_txnid_cfgrd(IosfMonTxn mon_txn);
  extern               function void  capture_txnid_cpld(IosfMonTxn mon_txn);
  extern               function void  capture_txnid_cpl(IosfMonTxn mon_txn);
  extern               function void  capture_np_req_txnid(IosfMonTxn mon_txn);
  extern               function void  chk_reqid_legal(IosfMonTxn mon_txn);
  extern               function sla_ral_data_t get_reg_value(string reg_name, string file_name, bit ro = 1'b_0);
  extern               task           exp_msi_loop();
  extern               task           exp_msix_loop() ;
  extern               task           exp_ims_loop();
  extern               task           track_ep_msi_vector(int vector);
  extern               task           track_ep_msix_vector(int vector);
  extern               task           track_ep_ims_vector(int vector);
  extern               task           track_flr_status();
  extern               task           track_start_of_flr(int func_no);
  extern               task           track_end_of_flr(int func_no);
  extern               function       chk_ep_msi_count();
  extern               function       chk_ep_msix_count();
  extern               function       chk_ep_ims_count();
  extern               function       chk_sai(iosf_trans_type_st pkt);
  extern               function       chk_req_attr_fields(IosfMonTxn iosfMonTxn_pkt);
  extern               function       chk_cpl_attr_fields(IosfMonTxn iosfMonTxn_pkt);
  extern               function       chk_pkt_from_ep(iosf_trans_type_st pkt);
  extern               function       chk_mwr_pkt(iosf_trans_type_st pkt);
  extern               function       chk_mwr64_pkt(IosfMonTxn iosfMonTxn_pkt);
  extern               function       chk_mwr_length(IosfMonTxn iosfMonTxn_pkt);
  extern               function       chk_msi_ims_pkt(IosfMonTxn iosfMonTxn_pkt);
  extern               function       chk_cpl_pkt(iosf_trans_type_st pkt);
  extern               function       chk_cpld_length(IosfMonTxn iosfMonTxn_pkt);
  extern               function       chk_cpld_status(IosfMonTxn mon_txn);
  extern               function       chk_cpl_order(IosfMonTxn iosfMonTxn_pkt);
  extern               function       chk_bcm_zero(IosfMonTxn iosfMonTxn_pkt);
  extern               function int   get_mps_dw(bit [2:0] mps);
  extern               function void  write(iosf_trans_type_st ep_pkt);

endclass : hqm_iosf_prim_checker

  // ---------------------------------------------------------------
  // new - constructor
  // ---------------------------------------------------------------
  function hqm_iosf_prim_checker::new (string name = "hqm_iosf_prim_checker", uvm_component parent = null);
    super.new(name, parent);

    get_plusarg_values();

	ral = sla_ral_env::get_ptr();

    func_base = `HQM_PF_FUNC_NUM;                     //  -- RCIEP/EP PF function number

    reset_txnid_q();

    reset_ep_bus_num_q();
   
    reset_func_flr_status();

  endfunction : new

  // -----------------------------------------------------------------------------
  // -- Builds components used 
  // -----------------------------------------------------------------------------

  function void hqm_iosf_prim_checker::build_phase(uvm_phase phase);
    super.build_phase(phase);

    glbl_pool        = uvm_event_pool::get_global_pool();
    cpl_to_eot_ended = glbl_pool.get("cpl_to_eot_ended");

    // -- Create/get handles to msi/msix_vector detected triggering -- // 
    for(int i=0; i<`HQM_NUM_MSIX_VECTOR; i++) begin
      ep_msix[i]     = glbl_pool.get($psprintf("hqm%s_ep_msix_%0d",inst_suffix,i));
      exp_ep_msix[i] = glbl_pool.get($psprintf("hqm%s_exp_ep_msix_%0d",inst_suffix,i));
      exp_ep_msix_count[i] = 0;
      obs_ep_msix_count[i] = 0;
      if($value$plusargs( { $psprintf("EXP_EP_MSIX%0d_CNT",i), "=%0d" }, exp_ep_msix_count[i])) begin
          uvm_report_info(get_full_name(), $psprintf("exp_ep_msix_count[%0d]=%0d", i, exp_ep_msix_count[i]), UVM_LOW);
      end 
    end 
    for(int i=0; i<`MAX_NO_OF_VFS; i++) begin
      ep_msi[i]     = glbl_pool.get($psprintf("hqm%s_ep_msi_%0d",inst_suffix,i));
      exp_ep_msi[i] = glbl_pool.get($psprintf("hqm%s_exp_ep_msi_%0d",inst_suffix,i));
      exp_ep_msi_count[i] = 0;
      obs_ep_msi_count[i] = 0;
      if($value$plusargs( { $psprintf("EXP_EP_MSI%0d_CNT",i), "=%0d" }, exp_ep_msi_count[i])) begin
          uvm_report_info(get_full_name(), $psprintf("exp_ep_msi_count[%0d]=%0d", i, exp_ep_msi_count[i]), UVM_LOW);
      end 
    end 
    // -- Create/get handles to ldb ims_vector detected triggering -- // 
    for(int i=0; i<(`HQM_NUM_IMS_VECTOR+`HQM_NUM_IMS_VECTOR_DIR); i++) begin
      ep_ims[i]     = glbl_pool.get($psprintf("hqm%s_ep_ims_%0d",inst_suffix,i));
      exp_ep_ims[i] = glbl_pool.get($psprintf("hqm%s_exp_ep_ims_%0d",inst_suffix,i));
      exp_ep_ims_count[i] = 0;
      obs_ep_ims_count[i] = 0;
    end 

    // -- Start/End of FLR events -- //
    foreach(ep_start_of_flr[i]) begin
      ep_start_of_flr[i] = glbl_pool.get($psprintf("ep_start_of_flr_func_%0d",i));
      ep_end_of_flr[i]   = glbl_pool.get($psprintf("ep_end_of_flr_func_%0d",i));
    end 

    hqm_iosf_prim_txn_imp = new("hqm_iosf_prim_txn_imp", this);
  endfunction : build_phase

  // -----------------------------------------------------------------------------
  // -- Set instance suffix
  // -----------------------------------------------------------------------------

  function void hqm_iosf_prim_checker::set_inst_suffix(string new_inst_suffix);
    inst_suffix = new_inst_suffix;
  endfunction

  // -----------------------------------------------------------------------------
  // -- Receive plusarg driven values  
  // -----------------------------------------------------------------------------


  function void hqm_iosf_prim_checker::get_plusarg_values();

    hqm_skip_msi_misx_clear_check = $test$plusargs("HQM_SKIP_MSI_MISX_CLEAR_CHECK");

    ten_bit_tag_en = ~($test$plusargs("HQM_TEN_BIT_TAG_DISABLE"));

    if(!$value$plusargs("hqm_is_reg_ep=%d",hqm_is_reg_ep_arg)) hqm_is_reg_ep_arg = '0;

    hqm_pcie_rc_vip_present = $test$plusargs("HQM_PCIE_RC_VIP_PRESENT");

    hqm_mrd_cpl_id_chk      = ~$test$plusargs("HQM_MRD_CPL_ID_CHK_DIS");

    hqm_eot_cplid_chk       = ~$test$plusargs("HQM_EOT_CPLID_CHK_DIS");

    hqm_cmpl_sai_strap = get_strap_val("HQM_STRAP_CMPL_SAI", `HQM_STRAP_CMPL_SAI);

    hqm_tx_sai_strap   = get_strap_val("HQM_STRAP_TX_SAI", `HQM_STRAP_TX_SAI);

  endfunction : get_plusarg_values

  // -----------------------------------------------------------------------------
  // -- Connect components
  // -----------------------------------------------------------------------------

  function void hqm_iosf_prim_checker::connect_phase (uvm_phase phase);

    // ---------------------------------------- //
    // -- get handles to each register files -- //
    // ---------------------------------------- //

  endfunction : connect_phase

  // -----------------------------------------------------------------------------
  // -- Bypass UR cplid check
  // -----------------------------------------------------------------------------

  function void hqm_iosf_prim_checker::set_bypass_cplid_check(bit val);
      `uvm_info(get_full_name(), $psprintf("Setting bypass_cplid_check to (%0d); Previously was -> (%0d)", val, bypass_cplid_check), UVM_LOW);
      bypass_cplid_check = val;
  endfunction : set_bypass_cplid_check

  // -----------------------------------------------------------------------------
  // -- Reset sent NP txnid Qs
  // -----------------------------------------------------------------------------

  function void hqm_iosf_prim_checker::reset_txnid_q();
    exp_cfg_cplid_q.delete();
    exp_mem_cplid_q.delete();
    np_req_outstanding_q.delete();
    cfgwr_txnid_q.delete();
  endfunction : reset_txnid_q

  // -----------------------------------------------------------------------------
  // -- Reset FLR in progress status per function 
  // -----------------------------------------------------------------------------

  function void hqm_iosf_prim_checker::reset_func_flr_status();
    foreach(func_flr[i]) begin func_flr[i] = 1'b_0; end 
  endfunction : reset_func_flr_status

  // -----------------------------------------------------------------------------
  // -- Reset EP bus number per function 
  // -----------------------------------------------------------------------------

  function void hqm_iosf_prim_checker::reset_ep_bus_num_q();
    for(int i=0; i<255; i++) begin
      ep_bus_num_q[i]=0;
      ep_bus_num_next_q[i]=0;
      ep_bus_num_prev_q[i]=0;
    end 
  endfunction : reset_ep_bus_num_q


  // -----------------------------------------------------------------------------
  // -- Run phase, spawns tasks to track expected MSIX/MSI/IMS INT
  // -----------------------------------------------------------------------------

  task hqm_iosf_prim_checker::run_phase (uvm_phase phase);
    `ifdef IP_TYP_TE
    `uvm_info("hqm_iosf_prim_checker", $sformatf("Entered run phase of hqm_iosf_prim_checker "), UVM_LOW)
	fork
	  exp_msi_loop();
	  exp_msix_loop();
	  exp_ims_loop();
	  track_flr_status();
	join_none

    `else 
    `uvm_info("hqm_iosf_prim_checker", $sformatf("Bypass run phase of hqm_iosf_prim_checker "), UVM_LOW)
    `endif
  endtask

  // -----------------------------------------------------------------------------
  // -- Tracks FLR status per function
  // -----------------------------------------------------------------------------

  task hqm_iosf_prim_checker::track_flr_status();
       foreach(func_flr[i]) begin automatic int k = i; fork begin track_start_of_flr(k); end join_none end 
       foreach(func_flr[i]) begin automatic int k = i; fork begin track_end_of_flr(k);   end join_none end 
  endtask: track_flr_status

  // -----------------------------------------------------------------------------
  // -- Tracks start of flr
  // -----------------------------------------------------------------------------

  task hqm_iosf_prim_checker::track_start_of_flr(int func_no);
       forever begin 
          ep_start_of_flr[func_no].wait_trigger(); 
          if(func_flr[func_no]) `uvm_error(get_full_name(), $psprintf("FLR status of func (0x%0x) is (0x%0x) and recieved start_of_flr trigger",func_no,func_flr[func_no]))
          func_flr[func_no]=1; 
          `uvm_info(get_full_name(), $psprintf("Set FLR status of func (0x%0x) as (0x%0x)",func_no,func_flr[func_no]), UVM_LOW)
       end 
  endtask: track_start_of_flr

  // -----------------------------------------------------------------------------
  // -- Tracks end of flr
  // -----------------------------------------------------------------------------

  task hqm_iosf_prim_checker::track_end_of_flr(int func_no);
       forever begin 
          ep_end_of_flr[func_no].wait_trigger(); 
          if(!func_flr[func_no]) `uvm_error(get_full_name(), $psprintf("FLR status of func (0x%0x) is (0x%0x) and recieved end_of_flr trigger",func_no,func_flr[func_no]))
          func_flr[func_no]=0; 
          `uvm_info(get_full_name(), $psprintf("Set FLR status of func (0x%0x) as (0x%0x)",func_no,func_flr[func_no]), UVM_LOW)
       end 
  endtask: track_end_of_flr

  // -----------------------------------------------------------------------------
  // -- Tracks expected MSI INT
  // -----------------------------------------------------------------------------

  task hqm_iosf_prim_checker::exp_msi_loop();
       foreach(exp_ep_msi[i]) begin automatic int k = i; fork begin track_ep_msi_vector(k); end join_none end 
  endtask: exp_msi_loop

  // -----------------------------------------------------------------------------
  // -- Tracks expected MSIX INT
  // -----------------------------------------------------------------------------

  task hqm_iosf_prim_checker::exp_msix_loop();
       foreach(exp_ep_msix[i]) begin automatic int k = i; fork begin track_ep_msix_vector(k); end join_none end 
  endtask: exp_msix_loop

  // -----------------------------------------------------------------------------
  // -- Tracks expected IMS INT
  // -----------------------------------------------------------------------------

  task hqm_iosf_prim_checker::exp_ims_loop();
       foreach(exp_ep_ims[i]) begin automatic int k = i; fork begin track_ep_ims_vector(k); end join_none end 
  endtask: exp_ims_loop

  // -----------------------------------------------------------------------------
  // -- Tracks expected MSI INT
  // -----------------------------------------------------------------------------

  task hqm_iosf_prim_checker::track_ep_msi_vector(int vector);
       forever begin exp_ep_msi[vector].wait_trigger(); exp_ep_msi_count[vector]++; end 
  endtask: track_ep_msi_vector

  // -----------------------------------------------------------------------------
  // -- Tracks expected MSIX INT
  // -----------------------------------------------------------------------------

  task hqm_iosf_prim_checker::track_ep_msix_vector(int vector);
       forever begin
         exp_ep_msix[vector].wait_trigger();
         exp_ep_msix_count[vector]++;
       end 
  endtask: track_ep_msix_vector

  // -----------------------------------------------------------------------------
  // -- Tracks expected IMS INT
  // -----------------------------------------------------------------------------

  task hqm_iosf_prim_checker::track_ep_ims_vector(int vector);
       forever begin exp_ep_ims[vector].wait_trigger(); exp_ep_ims_count[vector]++; end 
  endtask: track_ep_ims_vector

  // -----------------------------------------------------------------------------
  // -- Capture NP req txnid sent to HQM
  // -----------------------------------------------------------------------------

  function void hqm_iosf_prim_checker::capture_np_req_txnid(IosfMonTxn mon_txn);
   bit  [25:0] txnid;   
   txnid = {mon_txn.req_id,mon_txn.tag[9:0]};
   np_req_outstanding_q.push_back(txnid);
   `uvm_info(get_full_name(),$psprintf("Pushed txnid (0x%0x) to np_req_outstanding_q : size -> (0x%0x)",txnid, np_req_outstanding_q.size()),UVM_MEDIUM)
  endfunction : capture_np_req_txnid

  // -----------------------------------------------------------------------------
  // -- Generate expected CplId for CfgWr0 txn
  // -----------------------------------------------------------------------------

  function hqm_iosf_prim_checker::capture_txnid_cfgwr(IosfMonTxn mon_txn);
   bit  [25:0] txnid;   
   ep_bus_num_next_q[mon_txn.address[23:16]]=mon_txn.address[31:24];   
   txnid = {mon_txn.address[31:16],mon_txn.tag[9:0]};
   if(mon_txn.cmd == Iosf::CfgWr0) cfgwr_txnid_q.push_back({mon_txn.req_id,mon_txn.tag[9:0]});
   `uvm_info(get_full_name(),$psprintf("Pushed txnid (0x%0x) to cfgwr_txnid_q : size -> (0x%0x)",txnid, cfgwr_txnid_q.size()),UVM_MEDIUM)
   cfg_txnid_q.push_back({mon_txn.req_id,mon_txn.tag[9:0]});
   exp_cfg_cplid_q.push_back(txnid);
   `uvm_info(get_full_name(),$psprintf("Pushed cplid (0x%0x) in exp_cfg_cplid_q for cfgwr built from address(0x%0x) and tag(0x%0x)",txnid,mon_txn.address,mon_txn.tag),UVM_MEDIUM)
  endfunction : capture_txnid_cfgwr

  // -----------------------------------------------------------------------------
  // -- Generate expected CplId for MRd32/64 txn
  // -----------------------------------------------------------------------------

  function hqm_iosf_prim_checker::capture_txnid_memrd(IosfMonTxn mon_txn);
   sla_ral_reg my_reg; 
   sla_ral_data_t csr_bar_u, func_bar_u;
   sla_ral_data_t csr_bar_l, func_bar_l;
   bit   [63:0]   csr_bar  , func_bar  ;
   bit   [25:0]   txnid;
   bit   [7:0]    memrd_func_number;

   csr_bar_u   = get_reg_value("csr_bar_u"           , "hqm_pf_cfg_i") ; 
   csr_bar_l   = get_reg_value("csr_bar_l"           , "hqm_pf_cfg_i") ; 
   func_bar_u  = get_reg_value("func_bar_u"          , "hqm_pf_cfg_i") ; 
   func_bar_l  = get_reg_value("func_bar_l"          , "hqm_pf_cfg_i") ; 

   // -- Ignoring lower 4 bits for BAR regs (RO for Mem space BARs) -- //
   csr_bar_l[3:0] = 4'h_0; func_bar_l[3:0] = 4'h_0;

   csr_bar   = {csr_bar_u[31:0],csr_bar_l[31:0]};
   func_bar  = {func_bar_u[31:0],func_bar_l[31:0]};

   if(  (mon_txn.address[63:0]>=csr_bar   && (mon_txn.address[63:0]<=(csr_bar+`HQM_PF_CSR_BAR_SIZE)))  // -- BAR size -> 4GB  -> 31:0 are '0's
     || (mon_txn.address[63:0]>=func_bar  && (mon_txn.address[63:0]<=(func_bar+`HQM_PF_FUNC_BAR_SIZE))) // -- BAR size -> 64MB -> 25:0 are '0's
     ) begin
     memrd_func_number = func_base;
   end else begin memrd_func_number = func_base; end // -- Non-existing MRd space -- // 

   txnid={ep_bus_num_q[memrd_func_number],memrd_func_number,mon_txn.tag[9:0]};
   mem_txnid_q.push_back({mon_txn.req_id,mon_txn.tag[9:0]});
   exp_mem_cplid_q.push_back(txnid);
   `uvm_info(get_full_name(),$psprintf("Pushed cplid (0x%0x) in exp_mem_cplid_q for memrd; built from ep_bus_num_q(0x%0x),memrd_func_number(0x%0x),mon_txn.address(0x%0x),mon_txn.tag(0x%0x),csr_bar(0x%0x),func_bar(0x%0x)",txnid,ep_bus_num_q[memrd_func_number],memrd_func_number,mon_txn.address,mon_txn.tag,csr_bar,func_bar),UVM_MEDIUM)
  endfunction : capture_txnid_memrd

  // -----------------------------------------------------------------------------
  // -- Generate expected CplId for CfgRd0 txn
  // -----------------------------------------------------------------------------

  function void hqm_iosf_prim_checker::capture_txnid_cfgrd(IosfMonTxn mon_txn);
   bit  [25:0] txnid;
   txnid={ep_bus_num_q[mon_txn.address[23:16]],mon_txn.address[23:16],mon_txn.tag[9:0]};   
   cfg_txnid_q.push_back({mon_txn.req_id,mon_txn.tag[9:0]});
   exp_cfg_cplid_q.push_back(txnid);
   `uvm_info(get_full_name(),$psprintf("Pushed cplid (0x%0x) in exp_cfg_cplid_q for cfgrd built from address(0x%0x) and tag(0x%0x)",txnid,mon_txn.address,mon_txn.tag),UVM_MEDIUM)
  endfunction : capture_txnid_cfgrd

  // -----------------------------------------------------------------------------
  // -- Receive CplId for CplD txn and send for checks
  // -----------------------------------------------------------------------------

  function void hqm_iosf_prim_checker::capture_txnid_cpld(IosfMonTxn mon_txn);
    // // --------- bit  [25:0] txnid = {mon_txn.address[31:16],mon_txn.tag[9:0]};
    // // --------- // -- Check whether tag exists within NP txn Q sent to HQM -- //
    // // --------- if(is_cfg_tag(mon_txn.tag,mon_txn.first_be[2:0]) || is_memrd_tag(mon_txn.tag,mon_txn.first_be[2:0])) begin 
    // // ---------   `uvm_info(get_full_name(),$psprintf("Checking txnid (0x%0x) in exp_cfg_cplid_q for cpld built from address(0x%0x) and tag(0x%0x)",txnid,mon_txn.address,mon_txn.tag),UVM_MEDIUM)
    // // ---------   if(mon_txn.first_be[2:0]==`HQM_SUCC_CPL) begin check_cplid(txnid); end // -- If SC received check for Bus# and Func# match         -- // 
    // // ---------   else begin                                                             // -- If UR received check for Bus# match; as Func# is RSVD -- //
    // // ---------        if(ep_bus_num_q[txnid[17:10]]==txnid[25:18]) `uvm_info(get_full_name(),$psprintf("Bus num chk PASSES: UR txnid (0x%0x) and ep_bus_num_q(0x%0x)",txnid,ep_bus_num_q[txnid[17:10]]),UVM_MEDIUM)
    // // ---------        else                           `uvm_error(get_full_name(),$psprintf("Bus num chk FAILED: UR txnid (0x%0x) and ep_bus_num_q(0x%0x)",txnid,ep_bus_num_q[txnid[17:10]]))
    // // ---------   end 
    // // --------- end 
  endfunction : capture_txnid_cpld

  // -----------------------------------------------------------------------------
  // -- Receive CplId for Cpl txn and send for checks
  // -----------------------------------------------------------------------------

  function void hqm_iosf_prim_checker::capture_txnid_cpl(IosfMonTxn mon_txn);
    bit  [25:0] txnid = {mon_txn.address[31:16],mon_txn.tag[9:0]};
    // -- Check whether tag exists within NP txn Q sent to HQM -- //
    if(is_cfg_tag(mon_txn,mon_txn.first_be[2:0])) begin : cfg_np_req_cpl
      `uvm_info(get_full_name(),$psprintf("Checking txnid (0x%0x) in exp_cfg_cplid_q for cpl built from address(0x%0x) and tag(0x%0x)",txnid,mon_txn.address,mon_txn.tag),UVM_MEDIUM)
      if(mon_txn.first_be[2:0]==`HQM_SUCC_CPL) begin // -- If SC received check for Bus# and Func# match         -- //
           int idx_q[$];
           idx_q = cfgwr_txnid_q.find_index with (item == {mon_txn.req_id,mon_txn.tag});
             `uvm_info(get_full_name(),$psprintf("Finding txnid (0x%0x) cfgwr_txnid_q found idx_q.size() ", {mon_txn.req_id,mon_txn.tag}, idx_q.size()),UVM_DEBUG)
           if(idx_q.size() > 0) begin
           // ------------------------------------------------------------------------ //
           // -- Updating the ep_bus_num_prev_q with last sampled in last CfgWr0 pkt.
           // -- Since, SUCC_CPL received.
           // ------------------------------------------------------------------------ //
           ep_bus_num_q[txnid[17:10]]      = ep_bus_num_next_q[txnid[17:10]];    
           ep_bus_num_prev_q[txnid[17:10]] = ep_bus_num_q[txnid[17:10]];    
             `uvm_info(get_full_name(),$psprintf("Updated Bus num (0x%0x) for function (0x%0x)",ep_bus_num_q[txnid[17:10]], txnid[17:10]),UVM_MEDIUM)
           end 
           check_cplid(txnid, PCIE_CFG_RD0); 
      end 
      else begin                                     // -- If UR received check for Bus# match; as Func# is RSVD -- //
           // ------------------------------------------------------------------------ //
           // -- It is recommended that B-D be updated for SC cpl only. So, assigning
           // -- previous bus number as the current bus number and not the one sampled
           // -- in last CfgWr0 pkt.
           // ------------------------------------------------------------------------ //
           ep_bus_num_q[txnid[17:10]] = ep_bus_num_prev_q[txnid[17:10]];    
           // ------------------------------------------------------------------------ //

           if(ep_bus_num_q[txnid[17:10]]==txnid[25:18] || bypass_cplid_check) `uvm_info(get_full_name(),$psprintf("Bus num chk PASSES: UR txnid (0x%0x) and ep_bus_num_q(0x%0x)",txnid,ep_bus_num_q[txnid[17:10]]),UVM_MEDIUM)
           else                           `uvm_error(get_full_name(),$psprintf("Bus num chk FAILED: UR txnid (0x%0x) and ep_bus_num_q(0x%0x)",txnid,ep_bus_num_q[txnid[17:10]]))

           //--anyan_08112021 added to check EP bit in Cpl 
           if(!($test$plusargs("DISABLE_CPL_EP_CHECK"))) begin
              if(mon_txn.error_present) 
                 `uvm_warning(get_full_name(),$psprintf("Cpl.error_present chk FAILED: error_present=1 - txnid (0x%0x) and ep_bus_num_q(0x%0x)",txnid,ep_bus_num_q[txnid[17:10]]))

                 //--08182021: anyan_tmp: remember to change to uvm_error in HQMV26 
                 //`uvm_error(get_full_name(),$psprintf("Cpl.error_present chk FAILED: error_present=1 - txnid (0x%0x) and ep_bus_num_q(0x%0x)",txnid,ep_bus_num_q[txnid[17:10]]))
              else
                 `uvm_info(get_full_name(),$psprintf("Cpl.error_present chk PASSES: error_present=0 - txnid (0x%0x) and ep_bus_num_q(0x%0x)",txnid,ep_bus_num_q[txnid[17:10]]),UVM_MEDIUM)
           end 
      end 
    end : cfg_np_req_cpl
    else if(is_memrd_tag(mon_txn,mon_txn.first_be[2:0])) begin : mrd_np_req_cpl
      `uvm_info(get_full_name(),$psprintf("Checking txnid (0x%0x) in exp_mem_cplid_q for cpl built from address(0x%0x) and tag(0x%0x)",txnid,mon_txn.address,mon_txn.tag),UVM_MEDIUM)
      if(mon_txn.first_be[2:0]==`HQM_SUCC_CPL) begin // -- If SC received check for Bus# and Func# match         -- //
           check_cplid(txnid, CSR_READ); 
      end 
      else begin                                     // -- If UR received check for Bus# match; as Func# is RSVD -- //
           if(ep_bus_num_q[txnid[17:10]]==txnid[25:18] || bypass_cplid_check) `uvm_info(get_full_name(),$psprintf("Bus num chk PASSES: UR txnid (0x%0x) and ep_bus_num_q(0x%0x)",txnid,ep_bus_num_q[txnid[17:10]]),UVM_MEDIUM)
           else                           `uvm_error(get_full_name(),$psprintf("Bus num chk FAILED: UR txnid (0x%0x) and ep_bus_num_q(0x%0x)",txnid,ep_bus_num_q[txnid[17:10]]))
      end 
    end : mrd_np_req_cpl

    else begin : other_np_req_cpl
      // -- if(mon_txn.first_be[2:0]==3'h_1) begin
         `uvm_info(get_full_name(),$psprintf("Check CplId(0x%0x) for UR Txn (since cpl received for pkt other than CfgRd0/CfgWr0/MRd) sent to EP with mon_txn: address(0x%0x); tag(0x%0x)",txnid,mon_txn.address,mon_txn.tag),UVM_MEDIUM)
           if(ep_bus_num_q[txnid[17:10]]==txnid[25:18] || bypass_cplid_check) `uvm_info(get_full_name(),$psprintf("Bus num chk PASSES: UR txnid (0x%0x) and ep_bus_num_q(0x%0x)",txnid,ep_bus_num_q[txnid[17:10]]),UVM_MEDIUM)
           else                           `uvm_error(get_full_name(),$psprintf("Bus num chk FAILED: UR txnid (0x%0x) and ep_bus_num_q(0x%0x)",txnid,ep_bus_num_q[txnid[17:10]]))
      // -- end 
      // -- else  begin `uvm_error(get_full_name(),$psprintf("Did not find matching tag(0x%0x) for Cpl Pkt received, in exp_cfg_cplid_q/exp_mem_cplid_q with cpl_status (0x%0x)",mon_txn.tag,mon_txn.first_be[2:0])) 
      // -- end 
    end : other_np_req_cpl

  endfunction : capture_txnid_cpl

  // -----------------------------------------------------------------------------
  // -- Check received CplId for sent NP txns
  // -----------------------------------------------------------------------------

  function void hqm_iosf_prim_checker::check_cplid(bit   [25:0] received_txnid, hqm_trans_type_e ip_req);
    bit found_txnid=0;
    if(ip_req != CSR_READ) begin : cfg_rd_req
          foreach(exp_cfg_cplid_q[i]) begin
             if((exp_cfg_cplid_q[i] & {ten_bit_tag_en, ten_bit_tag_en, 8'h_ff}) == received_txnid[9:0]) begin // -- Check tag value match (based on 10bit tag en) -- //
               string log = "";
               exp_cfg_cplid_q[i][25:18] = ep_bus_num_q[exp_cfg_cplid_q[i][17:10]];
               log = $psprintf("for received cplid: Bus#(0x%0x) Func#(0x%0x), expected cplid: Bus#(0x%0x) Func#(0x%0x) from exp_cfg_cplid_q[%0d] for Tag(0x%0x)", received_txnid[25:18], received_txnid[17:10], exp_cfg_cplid_q[i][25:18], exp_cfg_cplid_q[i][17:10], i, received_txnid[9:0]);
               if(exp_cfg_cplid_q[i]==received_txnid || bypass_cplid_check) begin
                 `uvm_info(get_full_name(),$psprintf("Cfg Pkt CplId chk PASSED at idx(0x%0x) %s",i,log),UVM_MEDIUM)
               end else begin
                 `uvm_error(get_full_name(),$psprintf("Cfg Pkt CplId chk FAILED at idx(0x%0x) %s",i,log))
               end 
               exp_cfg_cplid_q.delete(i);
               `uvm_info(get_full_name(),$psprintf("Found matching txnid at idx(0x%0x) in exp_cfg_cplid_q for received_txnid(0x%0x)",i,received_txnid),UVM_DEBUG)
               found_txnid = 1'b1; break;
             end 
          end 
    end  : cfg_rd_req
    else begin : non_cfg_rd_req 
          foreach(exp_mem_cplid_q[i]) begin
             if((exp_mem_cplid_q[i] & {ten_bit_tag_en, ten_bit_tag_en, 8'h_ff}) == received_txnid[9:0]) begin
                 string log = "";
                 exp_mem_cplid_q[i][25:18] = ep_bus_num_q[exp_mem_cplid_q[i][17:10]];
                 log = $psprintf("for received cplid: Bus#(0x%0x) Func#(0x%0x), expected cplid: Bus#(0x%0x) Func#(0x%0x) from exp_mem_cplid_q[%0d] for Tag(0x%0x)", received_txnid[25:18], received_txnid[17:10], exp_mem_cplid_q[i][25:18], exp_mem_cplid_q[i][17:10], i, received_txnid[9:0]);
                 if(exp_mem_cplid_q[i]==received_txnid || bypass_cplid_check) 
                      `uvm_info(get_full_name(),$psprintf("MemRd CplId chk PASSED: %s",log),UVM_MEDIUM)
                 else begin
                      `uvm_error(get_full_name(),$psprintf("MemRd CplId chk FAILED: %s",log))
                 end 
               exp_mem_cplid_q.delete(i);
               `uvm_info(get_full_name(),$psprintf("Found matching txnid at idx(0x%0x) in exp_mem_cplid_q for received_txnid(0x%0x)",i,received_txnid),UVM_DEBUG)
               found_txnid = 1'b1; break;
             end 
          end 
    end : non_cfg_rd_req
    if(found_txnid==1'b_0) `uvm_error(get_full_name(),$psprintf("Did not find matching CplId in exp_cfg_cplid_q/exp_mem_cplid_q for received_txnid(0x%0x)",received_txnid))
  endfunction : check_cplid

  // -----------------------------------------------------------------------------
  // -- Check if tag received is for CfgRd0/Wr0 pkt
  // -----------------------------------------------------------------------------

  function bit hqm_iosf_prim_checker::is_cfg_tag(IosfMonTxn mon_txn, bit   [2:0] cpl_stat);
    int idx_q[$];
    idx_q = cfg_txnid_q.find_index with (item == {mon_txn.req_id, mon_txn.tag});
    is_cfg_tag = 1'b0;

    foreach(exp_cfg_cplid_q[i]) begin
       if( ((exp_cfg_cplid_q[i] & {ten_bit_tag_en, ten_bit_tag_en, 8'h_ff})==mon_txn.tag) && (idx_q.size() > 0) ) begin // -- Check tag value match (based on 10bit tag en) -- //
          `uvm_info(get_full_name(),$psprintf("Found matching tag(0x%0x) at idx(0x%0x) in exp_cfg_cplid_q",mon_txn.tag,i),UVM_DEBUG)
          is_cfg_tag = 1'b1; 
          if(cpl_stat!=3'h_0)  begin 
             `uvm_info(get_full_name(),$psprintf("Deleted tag(0x%0x) at idx(0x%0x) from exp_cfg_cplid_q since cpl_stat(0x%0x)",mon_txn.tag,i,cpl_stat),UVM_DEBUG) 
             exp_cfg_cplid_q.delete(i); 
          end 
          return is_cfg_tag;
       end 
    end 
    if(is_cfg_tag==1'b_0)`uvm_info(get_full_name(),$psprintf("Did not find matching tag(0x%0x) exp_cfg_cplid_q",mon_txn.tag),UVM_DEBUG)
  endfunction : is_cfg_tag

  // -----------------------------------------------------------------------------
  // -- Check if tag received is for MRd32/64 pkt
  // -----------------------------------------------------------------------------

  function bit hqm_iosf_prim_checker::is_memrd_tag(IosfMonTxn mon_txn, bit   [2:0] cpl_stat);
    int idx_q[$];
    idx_q = mem_txnid_q.find_index with (item == {mon_txn.req_id, mon_txn.tag});
    is_memrd_tag = 1'b0;

    foreach(exp_mem_cplid_q[i]) begin
       if( ((exp_mem_cplid_q[i] & {ten_bit_tag_en, ten_bit_tag_en, 8'h_ff})==mon_txn.tag) && (idx_q.size() > 0) ) begin
          `uvm_info(get_full_name(),$psprintf("Found matching tag(0x%0x) at idx(0x%0x) in exp_mem_cplid_q",mon_txn.tag,i),UVM_DEBUG)
          is_memrd_tag = 1'b1;  
          if(cpl_stat!=3'b_000) begin 
               `uvm_info(get_full_name(),$psprintf("Deleted tag(0x%0x) at idx(0x%0x) from exp_mem_cplid_q since cpl_stat(0x%0x)",mon_txn.tag,i,cpl_stat),UVM_DEBUG) 
               exp_mem_cplid_q.delete(i); 
          end 
         return is_memrd_tag;
       end 
    end 

    if(is_memrd_tag==1'b_0) `uvm_info(get_full_name(),$psprintf("Did not find matching tag(0x%0x) exp_mem_cplid_q",mon_txn.tag),UVM_DEBUG)
  endfunction : is_memrd_tag

  // -----------------------------------------------------------------------------
  // -- Get register value from RAL mirror
  // -----------------------------------------------------------------------------

 function sla_ral_data_t hqm_iosf_prim_checker::get_reg_value(string reg_name, string file_name, bit ro = 1'b_0);
   sla_ral_reg my_reg ;

   if (reg_cache.exists({file_name,".",reg_name})) begin
     my_reg = reg_cache[{file_name,".",reg_name}];
   end else begin
     my_reg   = ral.find_reg_by_file_name(reg_name, {ral_tb_env_hier, file_name});
     reg_cache[{file_name,".",reg_name}] = my_reg;
   end 
   if(my_reg != null) begin if(ro || $isunknown(my_reg.get_actual())) return my_reg.get_reset_val(); else return my_reg.get_actual(); end 
   else               `uvm_error(get_full_name(), $psprintf("Null reg handle received for %s.%s", file_name, reg_name))
 endfunction: get_reg_value

  // -----------------------------------------------------------------------------
  // -- Check if reqid of OP txn from DUT is legal
  // -----------------------------------------------------------------------------

  function void hqm_iosf_prim_checker::chk_reqid_legal(IosfMonTxn mon_txn);
    bit            illegal, func_bme;
    string         tlog = "out of allowed ";
    string         log  = "";
    sla_ral_data_t ral_data;
    bit  [7:0]     allowed_func_num[$];
   
    allowed_func_num.delete();

    ral_data     = get_reg_value("device_command", "hqm_pf_cfg_i");
    func_bme  = ral_data[2];

    allowed_func_num.push_back(func_base); // -- PF always an allowed function -- //

    foreach(allowed_func_num[i]) tlog = $psprintf("%s (0x%0x) ", tlog, allowed_func_num[i]);

       illegal = 1;
       foreach(allowed_func_num[i]) if (   allowed_func_num[i] == mon_txn.req_id[7:0] 
                                        && ep_bus_num_q[mon_txn.req_id[7:0]] == mon_txn.req_id[15:8]
                                        && (func_bme | func_flr[0]) // -- Relaxing BME check in case of FLR to func/PF
                                       ) begin illegal = 1'b_0; break; end 
       if(illegal) `uvm_error(get_full_name(), $psprintf("Illegal B-F (0x%0x) received from EP %s and func BME bit is (0x%0x)",mon_txn.req_id,log,func_bme[mon_txn.req_id[7:0]]))
       else        `uvm_info( get_full_name(), $psprintf("  Legal B-F (0x%0x) received from EP %s and func BME bit is (0x%0x)",mon_txn.req_id,log,func_bme[mon_txn.req_id[7:0]]), UVM_MEDIUM)

  endfunction: chk_reqid_legal

  // -----------------------------------------------------------------------------
  // -- Check SAI value on outbound txn
  // -----------------------------------------------------------------------------

  function hqm_iosf_prim_checker::chk_sai(iosf_trans_type_st pkt);
    string log = $psprintf("with pkt.monTxn.sai (0x%0x) and hqm_cmpl_sai_strap (0x%0x)", pkt.monTxn.sai, hqm_cmpl_sai_strap);
    case( { (pkt.trans_type inside {HCW_SCH, CQ_INT, COMP_CQ_INT, MSI_INT, MSIX_INT, IMS_INT, IMS_POLL_MODE_WR}), (pkt.trans_type inside {HQM_GEN_CPL, HQM_GEN_CPLD}) } )
      2'b_01: begin
                if(hqm_cmpl_sai_strap == pkt.monTxn.sai) `uvm_info(get_full_name(), $psprintf("CMPL SAI check PASSED %s", log), UVM_MEDIUM)
                else                                         `uvm_error(get_full_name(),$psprintf("CMPL SAI check FAILED %s", log))
              end 
      2'b_10: begin
                log = $psprintf("with pkt.monTxn.sai (0x%0x) and hqm_tx_sai_strap (0x%0x)", pkt.monTxn.sai, hqm_tx_sai_strap);
                if(hqm_tx_sai_strap == pkt.monTxn.sai) `uvm_info(get_full_name(), $psprintf("MWR SAI check PASSED %s", log), UVM_MEDIUM)
                else                                   `uvm_error(get_full_name(),$psprintf("MWR SAI check FAILED %s", log))
              end 
      default: `uvm_error(get_full_name(), $psprintf("Unexpected pkt type received. skipped SAI chk"))
    endcase
  endfunction : chk_sai

  // -----------------------------------------------------------------------------
  // -- Check EIDO value on outbound req txn
  // -----------------------------------------------------------------------------

  function hqm_iosf_prim_checker::chk_req_attr_fields(IosfMonTxn iosfMonTxn_pkt);
    string         log = "";
    bit            eido, ens, ero;
    sla_ral_data_t ral_data;
    ral_data = get_reg_value( "pcie_cap_device_control_2", "hqm_pf_cfg_i"); eido = ral_data[8];
    ral_data = get_reg_value( "pcie_cap_device_control",   "hqm_pf_cfg_i"); ens  = ral_data[11]; ero = ral_data[4];
  
    log = $psprintf("with pcie_cap_device_control_2.eido (0x%0x) and iosfMonTxn_pkt.reqIdo (0x%0x)",eido,iosfMonTxn_pkt.reqIdo);
     
    if(eido == 0 && iosfMonTxn_pkt.reqIdo != 0)  begin
       `uvm_error(get_full_name(),$psprintf("EIDO check FAILED %s", log))
    end else  begin
       `uvm_info(get_full_name(),$psprintf("EIDO check PASSED %s", log), UVM_MEDIUM)
    end 

    log = $psprintf("with pcie_cap_device_control.ens (0x%0x) and iosfMonTxn_pkt.reqNs (0x%0x)",ens,iosfMonTxn_pkt.reqNs);
     
    if(ens == 0 && iosfMonTxn_pkt.reqNs != 0)  begin
       `uvm_error(get_full_name(),$psprintf("ENS check FAILED %s", log))
    end else  begin
       `uvm_info(get_full_name(),$psprintf("ENS check PASSED %s", log), UVM_MEDIUM)
    end 

    log = $psprintf("with pcie_cap_device_control.ero (0x%0x) and iosfMonTxn_pkt.reqRo (0x%0x)",ero,iosfMonTxn_pkt.reqRo);
     
    if(ero == 0 && iosfMonTxn_pkt.reqRo != 0)  begin
       `uvm_error(get_full_name(),$psprintf("ERO check FAILED %s", log))
    end else  begin
       `uvm_info(get_full_name(),$psprintf("ERO check PASSED %s", log), UVM_MEDIUM)
    end 

  endfunction : chk_req_attr_fields

  // -----------------------------------------------------------------------------
  // -- Check IDO value on outbound cpl txn
  // -----------------------------------------------------------------------------

  function hqm_iosf_prim_checker::chk_cpl_attr_fields(IosfMonTxn iosfMonTxn_pkt);
    string         log = "";
    bit            ecido;
    sla_ral_data_t ral_data;
    ral_data = get_reg_value( "pcie_cap_device_control_2", "hqm_pf_cfg_i"); ecido = ral_data[9];
  
    log = $psprintf("with pcie_cap_device_control_2.ecido (0x%0x) and iosfMonTxn_pkt.reqIdo (0x%0x)",ecido,iosfMonTxn_pkt.reqIdo);
     
    if(ecido == 0 && iosfMonTxn_pkt.reqIdo != 0)  begin
       `uvm_error(get_full_name(),$psprintf("Cpl IDO check FAILED %s", log))
    end else  begin
       `uvm_info(get_full_name(),$psprintf("Cpl IDO check PASSED %s", log), UVM_MEDIUM)
    end 

  endfunction : chk_cpl_attr_fields

  // -----------------------------------------------------------------------------
  // -- Receive packets from decoder and do corresponding checks 
  // -----------------------------------------------------------------------------

  function hqm_iosf_prim_checker::chk_pkt_from_ep(iosf_trans_type_st pkt);

    // -- Below types received from HQM -- // 
    if(pkt.trans_type inside {HCW_SCH, CQ_INT, COMP_CQ_INT, MSI_INT, MSIX_INT, HQM_GEN_CPL, HQM_GEN_CPLD, IMS_INT, IMS_POLL_MODE_WR} ) begin

      // -- Common checks -- //
      chk_sai(pkt);                         // -- Check SAI  on outbound txn    -- //

      // -- If MWr pkt received, do additional checks -- //
	  if(pkt.trans_type inside {MSI_INT, MSIX_INT, CQ_INT, COMP_CQ_INT, HCW_SCH, IMS_INT, IMS_POLL_MODE_WR} ) begin 
             chk_mwr_pkt(pkt);
             chk_req_attr_fields(pkt.monTxn);      // -- Check EIDO, NS, RO TLP fields -- //
      end 

      // -- Sample CplId for checks  -- // 
	  if(pkt.trans_type inside {HQM_GEN_CPL      ,  HQM_GEN_CPLD                        } ) begin
             chk_cpl_pkt(pkt);
             chk_cpl_attr_fields(pkt.monTxn);      // -- Check IDO TLP field -- //
      end 
    end 
    
    if(pkt.trans_type == CSR_READ )     capture_txnid_memrd(pkt.monTxn);
    if(pkt.trans_type == PCIE_CFG_RD0 ) capture_txnid_cfgrd(pkt.monTxn);
    if(pkt.trans_type == PCIE_CFG_WR0 ) capture_txnid_cfgwr(pkt.monTxn);
    if(pkt.trans_type inside {PCIE_CFG_WR0, CSR_READ, PCIE_CFG_RD0, UNKWN_TRANS_TO_HQM, PCIE_CFG_WR0_DATA} ) begin 
       if(pkt.monTxn.reqType == Iosf::NONPOSTED) capture_np_req_txnid(pkt.monTxn);  // -- Sample NP req txnid only -- //
    end 

  endfunction : chk_pkt_from_ep

  // -----------------------------------------------------------------------------
  // -- MWr pkt checks 
  // -----------------------------------------------------------------------------

  function hqm_iosf_prim_checker::chk_mwr_pkt(iosf_trans_type_st pkt);
    chk_reqid_legal(pkt.monTxn);     // -- check reqId received from ep is within legal values    -- //
    chk_mwr_length(pkt.monTxn);      // -- check that MWr generated has payload <= MPS programmed -- //
    chk_mwr64_pkt(pkt.monTxn)  ;     // -- check upper bits are non-zero for mwr64 pkts           -- //
    if(pkt.trans_type inside {MSI_INT, MSIX_INT, IMS_INT, CQ_INT, COMP_CQ_INT}) begin
       chk_msi_ims_pkt(pkt.monTxn);     // -- check for updating observed MSI/IMS/MSIX count -- //
    end 
  endfunction : chk_mwr_pkt

  // ------------------------------------------------------------------------------------------------ //
  // -- Check that MWr generated has payload <= MPS programmed                                     -- //
  // ------------------------------------------------------------------------------------------------ //
  function hqm_iosf_prim_checker::chk_mwr_length(IosfMonTxn iosfMonTxn_pkt);
    sla_ral_data_t ral_data = get_reg_value("pcie_cap_device_control", "hqm_pf_cfg_i");
    if(iosfMonTxn_pkt.length > (get_mps_dw(ral_data[7:5])) ) begin
      `uvm_error(get_full_name(), $sformatf("Received MWr pkt with length > MPS (0x%0x): %s", get_mps_dw(ral_data[7:5]), iosfMonTxn_pkt.convert2string()))
    end 
  endfunction : chk_mwr_length

  // ------------------------------------------------------------------------------------------------ //
  // -- Check that the upper bits are 0s for MWr64 pkt, ensuring MWr32 is used for those addresses -- //
  // ------------------------------------------------------------------------------------------------ //
  function hqm_iosf_prim_checker::chk_mwr64_pkt(IosfMonTxn iosfMonTxn_pkt);
    if(iosfMonTxn_pkt.cmd == Iosf::MWr64 && iosfMonTxn_pkt.address[63:32] == 'h_0) begin
      `uvm_error(get_name,$sformatf("Received MWr64 pkt with upper DW address bits '0': %s", iosfMonTxn_pkt.convert2string()))
    end 
  endfunction : chk_mwr64_pkt

  // -----------------------------------------------------------------------------
  // -- Cpl/CplD pkt checks
  // -----------------------------------------------------------------------------

  function hqm_iosf_prim_checker::chk_cpl_pkt(iosf_trans_type_st pkt);
    // ------------------------------------ //
    // -- Common checks for all Cpl pkts -- //
    // ------------------------------------ //
    chk_bcm_zero(pkt.monTxn);
    chk_cpl_order(pkt.monTxn);

    case(pkt.trans_type) 
      HQM_GEN_CPL : capture_txnid_cpl(pkt.monTxn); 
      HQM_GEN_CPLD: begin capture_txnid_cpl(pkt.monTxn); chk_cpld_length(pkt.monTxn); chk_cpld_status(pkt.monTxn); end 
    endcase
  endfunction : chk_cpl_pkt

  // ---------------------------------------------------------------------------- //
  // -- Check completion are received in order based on tag      
  // ---------------------------------------------------------------------------- //
  function hqm_iosf_prim_checker::chk_cpl_order(IosfMonTxn iosfMonTxn_pkt);
    int tag_idx[$];
    tag_idx = np_req_outstanding_q.find_index with (item == {iosfMonTxn_pkt.req_id, iosfMonTxn_pkt.tag});
    if(tag_idx.size() > 0) begin : tag_idx_found
       /* if({iosfMonTxn_pkt.address[15:8],iosfMonTxn_pkt.last_be[3:0]} <= 'h_4) begin
         `uvm_info(get_full_name(), $sformatf("Skipping cpl_order check since ByteCount in completion is (0x%0x),i.e., ByteCount <= 4",{iosfMonTxn_pkt.address[15:8],iosfMonTxn_pkt.last_be[3:0]}), UVM_MEDIUM);
       end else */ if(tag_idx[0] == 0) begin
         `uvm_info(get_name,$sformatf("Received completion in order for Cpl pkt : %s", iosfMonTxn_pkt.convert2string()), UVM_MEDIUM)
       end else begin
           int loc_idx ;
           for(loc_idx=0; loc_idx<tag_idx[0]; loc_idx++) begin
               if(np_req_outstanding_q[loc_idx] == np_req_outstanding_q[tag_idx[0]]) begin
                  break;
               end 
           end 
           `uvm_info(get_name,$sformatf("loc_idx (0x%0x), tag_idx[0] (0x%0x)", loc_idx, tag_idx[0]), UVM_DEBUG)
           if(loc_idx==tag_idx[0]) begin
               `uvm_info(get_name,$sformatf("Received completion early due to diff reqID by (0x%0x) # of packets. Cpl pkt : %s", tag_idx[0], iosfMonTxn_pkt.convert2string()), UVM_MEDIUM)
           end else begin
               `uvm_error(get_name,$sformatf("Received completion early (out of order) by (0x%0x) # of packets. Cpl pkt : %s", tag_idx[0], iosfMonTxn_pkt.convert2string()))
           end 
       end 
       // ---------------------------------
       // -- Delete compared idx
       // ---------------------------------
       np_req_outstanding_q.delete(tag_idx[0]);
    end : tag_idx_found
    else begin : tag_idx_not_found
         if(~bypass_cplid_check) `uvm_error(get_name,$sformatf("Did not find tag (0x%0x) within outstanding NP req Q. Cpl pkt : %s", iosfMonTxn_pkt.tag, iosfMonTxn_pkt.convert2string()))
    end : tag_idx_not_found
  endfunction : chk_cpl_order

  // ---------------------------------------------------------------------------- //
  // -- Check that the BCM field 'first_be[3]' is set to '0' by IOSF endpoints -- //
  // ---------------------------------------------------------------------------- //
  function hqm_iosf_prim_checker::chk_bcm_zero(IosfMonTxn iosfMonTxn_pkt);
    if(iosfMonTxn_pkt.first_be[3]) begin
      `uvm_error(get_name,$sformatf("BCM in completion cannot be set by IOSF endpoints. Found BCM set in txn : %s", iosfMonTxn_pkt.convert2string()))
    end else begin
      `uvm_info(get_name,$sformatf("BCM in completion check PASSED. Found BCM '0' in Cpl from HQM."), UVM_MEDIUM)
    end 
  endfunction : chk_bcm_zero

  // ---------------------------------------------------- //
  // -- Check that Cpl status is SC for CplD packet    -- //
  // ---------------------------------------------------- //
  function hqm_iosf_prim_checker::chk_cpld_status(IosfMonTxn mon_txn);
    if(mon_txn.first_be[2:0]!=`HQM_SUCC_CPL) begin
      `uvm_error(get_full_name(), $sformatf("Received CplD pkt with Cpl status NOT equal to SC: %s", mon_txn.convert2string()))
    end else
      `uvm_info(get_full_name(), $sformatf("Received CplD pkt with Cpl status equal to SC: %s", mon_txn.convert2string()), UVM_MEDIUM)
  endfunction : chk_cpld_status

  // ---------------------------------------------------- //
  // -- Check that length field doesn't exceed MPS set -- //
  // ---------------------------------------------------- //
  function hqm_iosf_prim_checker::chk_cpld_length(IosfMonTxn iosfMonTxn_pkt);
    sla_ral_data_t ral_data = get_reg_value("pcie_cap_device_control", "hqm_pf_cfg_i");
    if(iosfMonTxn_pkt.length > (get_mps_dw(ral_data[7:5])) ) begin
      `uvm_error(get_full_name(), $sformatf("Received CplD pkt with length > MPS (0x%0x): %s", get_mps_dw(ral_data[7:5]), iosfMonTxn_pkt.convert2string()))
    end 
  endfunction : chk_cpld_length
  
  // -----------------------------------------------------------------------------
  // -- Returns MPS in DW
  // -----------------------------------------------------------------------------

  function int hqm_iosf_prim_checker::get_mps_dw(bit [2:0] mps);
    get_mps_dw = 'h_0;
    case(mps) 
      3'b_000: get_mps_dw =  128/4; 
      3'b_001: get_mps_dw =  256/4; 
      3'b_010: get_mps_dw =  512/4; 
      3'b_011: get_mps_dw = 1024/4; 
      3'b_100: get_mps_dw = 2048/4; 
      3'b_101: get_mps_dw = 4096/4; 
      default: begin get_mps_dw = 4096/4; `uvm_warning(get_full_name(), "Unsupported MPS programmed to DUT !!") end 
    endcase
  endfunction

  // -----------------------------------------------------------------------------
  // -- MSI/MSIX/IMS INT pkt checks
  // -----------------------------------------------------------------------------

  function hqm_iosf_prim_checker::chk_msi_ims_pkt(IosfMonTxn iosfMonTxn_pkt);
    sla_ral_data_t    ral_data;
	bit	[63:0]		  msix_address;
	bit	[31:0]		  msix_data;
    bit               msix_en;
    bit               msi_en_l;

    // ----------------------------------------------------- //
    // ----------------- MSIX PKT check -------------------- //
    // ----------------------------------------------------- //

    for(int i=0; i<`HQM_NUM_MSIX_VECTOR; i++) begin
       ral_data = get_reg_value($psprintf("msg_addr_u[%0d]",i), "hqm_msix_mem");
       
       msix_address[63:32] = ral_data;

       ral_data = get_reg_value($psprintf("msg_addr_l[%0d]",i), "hqm_msix_mem");
       
       msix_address[31:0] = ral_data;

       ral_data = get_reg_value($psprintf("msg_data[%0d]",i), "hqm_msix_mem");
       
       msix_data[31:0] = ral_data;

       ral_data     = get_reg_value("msix_cap_control", "hqm_pf_cfg_i");
       msix_en = ral_data[15];

       if({iosfMonTxn_pkt.data[3],iosfMonTxn_pkt.data[2],iosfMonTxn_pkt.data[1],iosfMonTxn_pkt.data[0]}==msix_data)  begin
	  `uvm_info(get_name,$sformatf("Received MSIX interrupt vector (0x%0x) -> Data match observed (0x%0x), Expected (0x%0x)",i,{iosfMonTxn_pkt.data[3],iosfMonTxn_pkt.data[2],iosfMonTxn_pkt.data[1],iosfMonTxn_pkt.data[0]},msix_data),UVM_MEDIUM)

	   if(iosfMonTxn_pkt.address==msix_address)  begin
	       `uvm_info(get_name,$sformatf("Received MSIX interrupt vector (0x%0x)-> Address match observed (0x%0x), Expected (0x%0x)",i,iosfMonTxn_pkt.address,msix_address),UVM_MEDIUM)
                if ((msix_en==0) && (!hqm_skip_msi_misx_clear_check)) begin
                    `uvm_error(get_full_name(), $psprintf("Illegal MSIX observed when MSIX Enable=%0x",msix_en))
                end 

                if (msix_en==1 && iosfMonTxn_pkt.req_id[7:0]==func_base)
			        `uvm_info(get_name,$sformatf("Legal MSIX observed for func_no=0x%0x when MSI Enable=0x%0x",(func_base), msix_en),UVM_MEDIUM)
                else
			        `uvm_error(get_name,$sformatf("Illegal MSIX observed due to func_no -> exp(0x%0x) and obs(0x%0x) mismatch OR MSI Enable=0x%0x",(func_base), iosfMonTxn_pkt.req_id[7:0], msix_en))

                ep_msix[i].trigger(); obs_ep_msix_count[i]++;
                `uvm_info(get_full_name(),$psprintf("Triggered event, MSIX received for vector #(0x%0x), obs_ep_msix_count[%0d]=%0d",i, i, obs_ep_msix_count[i]),UVM_MEDIUM)

                  if(iosfMonTxn_pkt.addrTrSvc == 'h_0) `uvm_info(get_name,$sformatf("AT for MSI pkt is 0"),UVM_MEDIUM)
                  else                                 `uvm_error(get_name,$sformatf("AT for MSI pkt is not 0"))
                  if(iosfMonTxn_pkt.non_snoop == 'h_0)  `uvm_info(get_name, $sformatf("No snoop for MSI pkt is 0"),UVM_MEDIUM)
                  else                                 `uvm_error(get_name,$sformatf("No snoop for MSI pkt is not 0"))
                  if(iosfMonTxn_pkt.relaxed_ordering == 'h_0)  `uvm_info(get_name, $sformatf("Relaxed ordering for MSI pkt is 0"),UVM_MEDIUM)
                  else                                 `uvm_error(get_name,$sformatf("Relaxed ordering for MSI pkt is not 0"))
                  if(iosfMonTxn_pkt.pasidtlp[22] == 'h_0) `uvm_info(get_name,$sformatf("PASID TLP for MSI pkt is 0"),UVM_MEDIUM)
                  else                                 `uvm_error(get_name,$sformatf("PASID TLP for MSI pkt is not 0"))

	   end 
	end 
    end 
    // ----------------------------------------------------- //

    // ----------------------------------------------------- //
    // ----------------- IMS PKT check --------------------- //
    // ----------------------------------------------------- //
    for(int i=0; i< (`HQM_NUM_IMS_VECTOR + `HQM_NUM_IMS_VECTOR_DIR) ; i++) begin
       sla_ral_data_t ims_address='h_0, ims_data='h_0, ims_msg_en='h_0, ims_mult_msg_en='h_0, ims_mask='h_0, ims_observed='h_0, ims_mask_low_bits = 'h_0;

       ral_data = get_reg_value($psprintf("AI_ADDR_L[%0d]",i), "hqm_system_csr");
       
       ims_address[31:00] = ral_data[31:0]      ;  // -- Lower 32 bits User specific/programmable -- //

       ral_data = get_reg_value($psprintf("AI_ADDR_U[%0d]",i), "hqm_system_csr");
       
       ims_address[63:32] = ral_data[31:0]      ;  // -- Upper 32 bits User specific/programmable -- //

       ral_data = get_reg_value($psprintf("AI_DATA[%0d]",i), "hqm_system_csr");
       
       ims_data[31:0] = ral_data; // -- IMS INT data -- //

       if({iosfMonTxn_pkt.data[3],iosfMonTxn_pkt.data[2],iosfMonTxn_pkt.data[1],iosfMonTxn_pkt.data[0]}==ims_data)  begin
	  `uvm_info(get_name,$sformatf("Received IMS interrupt vector (0x%0x) -> Data match observed (0x%0x), Expected (0x%0x)",i,{iosfMonTxn_pkt.data[3],iosfMonTxn_pkt.data[2],iosfMonTxn_pkt.data[1],iosfMonTxn_pkt.data[0]},ims_data),UVM_MEDIUM)

	  if(iosfMonTxn_pkt.address==ims_address)  begin
	       `uvm_info(get_name,$sformatf("Received IMS interrupt vector (0x%0x)-> Address match observed (0x%0x), Expected (0x%0x)",i,iosfMonTxn_pkt.address,ims_address),UVM_MEDIUM)
                ep_ims[i].trigger(); obs_ep_ims_count[i]++;

                if (iosfMonTxn_pkt.req_id[7:0]==func_base)
			        `uvm_info(get_name,$sformatf("IMS func_no check PASSED with exp(0x%0x), obs(0x%0x)",(func_base), iosfMonTxn_pkt.req_id[7:0]),UVM_MEDIUM)
                else
			        `uvm_error(get_name,$sformatf("IMS func_no check FAILED with exp(0x%0x), obs(0x%0x)",(func_base), iosfMonTxn_pkt.req_id[7:0]))

                `uvm_info(get_full_name(),$psprintf("Triggered event, IMS received for vector #(0x%0x)",i),UVM_MEDIUM)


                  if(iosfMonTxn_pkt.addrTrSvc == 'h_0) `uvm_info(get_name,$sformatf("AT for IMS pkt is 0"),UVM_MEDIUM)
                  else                                 `uvm_error(get_name,$sformatf("AT for IMS pkt is not 0"))
                  if(iosfMonTxn_pkt.non_snoop == 'h_0)  `uvm_info(get_name, $sformatf("No snoop for IMS pkt is 0"),UVM_MEDIUM)
                  else                                 `uvm_error(get_name,$sformatf("No snoop for IMS pkt is not 0"))
                  if(iosfMonTxn_pkt.relaxed_ordering == 'h_0)  `uvm_info(get_name, $sformatf("Relaxed ordering for IMS pkt is 0"),UVM_MEDIUM)
                  else                                 `uvm_error(get_name,$sformatf("Relaxed ordering for IMS pkt is not 0"))
                  if(iosfMonTxn_pkt.pasidtlp[22] == 'h_0) `uvm_info(get_name,$sformatf("PASID TLP for IMS pkt is 0"),UVM_MEDIUM)
                  else                                 `uvm_error(get_name,$sformatf("PASID TLP for IMS pkt is not 0"))

	  end 
       end 
    end //--for
    // ----------------------------------------------------- //

  endfunction: chk_msi_ims_pkt

  // -----------------------------------------------------------------------------
  // -- 
  // -----------------------------------------------------------------------------

  function void hqm_iosf_prim_checker::write(iosf_trans_type_st ep_pkt);
    if (ep_pkt.monTxn != null) chk_pkt_from_ep(ep_pkt);
    else                       `uvm_error(get_full_name(), $psprintf("Received null (0x%0x) IosfMonTxn in analysis imp write", (ep_pkt.monTxn==null)))
  endfunction : write

  // -----------------------------------------------------------------------------
  // -- Reports EOT checks 
  // -----------------------------------------------------------------------------

  function void hqm_iosf_prim_checker::report_phase(uvm_phase phase);
  
    `ifdef IP_TYP_TE
    `uvm_info("hqm_iosf_prim_checker", $sformatf("Entered report phase of hqm_iosf_prim_checker "), UVM_LOW)

      if(hqm_eot_cplid_chk) check_txnid_q();
 
      chk_ep_msi_count(); chk_ep_msix_count(); chk_ep_ims_count(); 
    `else 
    `uvm_info("hqm_iosf_prim_checker", $sformatf("Bypass report phase of hqm_iosf_prim_checker "), UVM_LOW)
    `endif



  endfunction : report_phase

  // -----------------------------------------------------------------------------
  // -- Ensure all sent NP txnid are received at EOT
  // -----------------------------------------------------------------------------

  function void hqm_iosf_prim_checker::check_txnid_q();
    if(exp_cfg_cplid_q.size()==0 && exp_mem_cplid_q.size()==0) begin
	  `uvm_info( get_full_name(),$psprintf("CplId check PASSED. All txnid(s) received in cpl pkts"),UVM_LOW)
    end else begin
      if(exp_cfg_cplid_q.size()!=0) begin
	    string txnid_str = "Missing txnid(s) that were sent and not received:\n";
	    foreach(exp_cfg_cplid_q[i]) begin txnid_str = $psprintf("%s exp_cfg_cplid_q[%0d] = (0x%0x)\n",txnid_str,i,exp_cfg_cplid_q[i]); end 
	    `uvm_error(get_full_name(),$psprintf("Cfg Pkt CplId check FAILED: %s",txnid_str))
      end 
      if(exp_mem_cplid_q.size()!=0) begin
	    string txnid_str = "Missing txnid(s) that were sent and not received:\n";
	    foreach(exp_mem_cplid_q[i]) begin txnid_str = $psprintf("%s exp_mem_cplid_q[%0d] = (0x%0x)\n",txnid_str,i,exp_mem_cplid_q[i]); end 
	    `uvm_error(get_full_name(),$psprintf("MemRd Pkt CplId check FAILED: %s",txnid_str))
      end 
    end 
  endfunction : check_txnid_q

  // -----------------------------------------------------------------------------
  // -- Check MSI INT count at EOT exp vs obs
  // -----------------------------------------------------------------------------

  function hqm_iosf_prim_checker::chk_ep_msi_count();
    if ( !($test$plusargs("DISABLE_MSI_COUNT_CHECK")) ) begin
        foreach(exp_ep_msi_count[i]) begin 
            string log = $psprintf("exp #(0x%0x), obs #(0x%0x)",exp_ep_msi_count[i],obs_ep_msi_count[i]);
            if(exp_ep_msi_count[i]==obs_ep_msi_count[i]) 
               `uvm_info(get_full_name(),$psprintf("EOT: MSI VF(0x%0x) count chk PASSES: %s",i,log),UVM_LOW)
            else
          `uvm_error(get_full_name(),$psprintf("EOT: MSI VF(0x%0x) count chk FAILED: %s",i,log))
        end 
    end else begin
       if ( ($test$plusargs("EXP_MSIX_ALARM_CHECK")) &&  obs_ep_msi_count[0]==0 ) begin
        `uvm_error(get_full_name(), $psprintf("EXP_MSIX_ALARM_CHECK plusarg provided; Expecting MSIX 0 Alarm occurred, while obs_ep_msi_count[0]=0"));
       end else begin
        `uvm_info(get_full_name(), $psprintf("DISABLE_MSI_COUNT_CHECK plusarg provided; disabling MSI count check"), UVM_LOW);
       end 
    end 
  endfunction:chk_ep_msi_count

  // -----------------------------------------------------------------------------
  // -- Check MSIX INT count at EOT exp vs obs
  // -----------------------------------------------------------------------------

  function hqm_iosf_prim_checker::chk_ep_msix_count();
    if ( !($test$plusargs("DISABLE_MSIX_COUNT_CHECK")) ) begin
       foreach(exp_ep_msix_count[i]) begin 
           string log = $psprintf("exp #(0x%0x), obs #(0x%0x)",exp_ep_msix_count[i],obs_ep_msix_count[i]);
           if(exp_ep_msix_count[i]==obs_ep_msix_count[i])
              `uvm_info(get_full_name(),$psprintf("EOT: MSIX vector#(0x%0x) count chk PASSES: %s",i,log),UVM_LOW)
           else
              `uvm_error(get_full_name(),$psprintf("EOT: MSIX vector#(0x%0x) count chk FAILED: %s",i,log))
       end 
    end else begin
        `uvm_info(get_full_name(), $psprintf("DISABLE_MSIX_COUNT_CHECK plusarg provided; disabling MSIX count check"), UVM_LOW);
    end 
  endfunction:chk_ep_msix_count

  // -----------------------------------------------------------------------------
  // -- Check IMS INT count at EOT exp vs obs
  // -----------------------------------------------------------------------------

  function hqm_iosf_prim_checker::chk_ep_ims_count();
    foreach(exp_ep_ims_count[i]) begin 
       string log = $psprintf("exp #(0x%0x), obs #(0x%0x)",exp_ep_ims_count[i],obs_ep_ims_count[i]);
       if(exp_ep_ims_count[i]==obs_ep_ims_count[i])
          `uvm_info(get_full_name(),$psprintf("EOT:LDB IMS vector#(0x%0x) count chk PASSES: %s",i,log),UVM_LOW)
       else
          `uvm_error(get_full_name(),$psprintf("EOT:LDB IMS vector#(0x%0x) count chk FAILED: %s",i,log))
    end 
  endfunction:chk_ep_ims_count

  function longint get_strap_val(string plusarg_name, longint default_val);
    string val_string = "";
    if(!$value$plusargs({$sformatf("%s",plusarg_name),"=%s"}, val_string)) begin
       get_strap_val = default_val; // -- Assign default value of strap, if no plusarg provided -- //
    end 
    else if (lvm_common_pkg::token_to_longint(val_string,get_strap_val) == 0) begin
      `uvm_error(get_full_name(),$psprintf("+%s=%s not a valid integer value",plusarg_name,val_string))
      get_strap_val = default_val; // -- Assign default value of strap, if no plusarg provided -- //
    end 

    // -- Finally print the resolved strap value -- //
    `uvm_info(get_full_name(), $psprintf("Resolved strap (%s) with value (0x%0x) ", plusarg_name, get_strap_val), UVM_LOW);

  endfunction


`endif
