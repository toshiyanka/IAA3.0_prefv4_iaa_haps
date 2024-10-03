//-----------------------------------------------------------------------------------------------------
//
// INTEL CONFIDENTIAL
//
// Copyright 2017 Intel Corporation All Rights Reserved.
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

`ifndef HQM_NON_STANDARD_WARM_RESET_SEQ__SV
`define HQM_NON_STANDARD_WARM_RESET_SEQ__SV

//-----------------------------------------------------------------------------------
// File        : hqm_non_standard_warm_reset_seq.sv
// Author      : Neeraj Shete
//
// Description : This sequence drives a non-standard warm reset to HQM.
//               Deviation from standard chassis warm reset flow is that prim_clk is 
//               off when prim_rst_b is deasserted.
//-----------------------------------------------------------------------------------

import hqm_tb_sequences_pkg::*;

class hqm_non_standard_warm_reset_seq extends sla_sequence_base;

  `ovm_object_utils(hqm_non_standard_warm_reset_seq)

    ovm_event_pool        global_pool;
    ovm_event             hqm_ip_ready;
    ovm_event             hqm_fuse_download_req;

  int num_straps_checked = 0;

  //----------------------------------------------
  //-- new()
  //----------------------------------------------  
  function new(string name = "hqm_non_standard_warm_reset_seq");
    super.new(name); 
    global_pool  = ovm_event_pool::get_global_pool();
    hqm_ip_ready = global_pool.get("hqm_ip_ready");
    hqm_fuse_download_req = global_pool.get("hqm_fuse_download_req");

  endfunction

  //----------------------------------------------
  //-- body()
  //----------------------------------------------  
  virtual task body();
    bit received_ip_ready = 1'b_0;
	`ovm_info(get_full_name(),$psprintf("Starting hqm_non_standard_warm_reset_seq"),OVM_LOW);

    poll_val("hqm_tb_top.u_hqm.prim_clkreq", 0, 9000000);
    wait_ns_clk(500);
    set_val("hqm_tb_top.force_prim_side_clkack_hqm", 1);
    wait_ns_clk(500);
    set_val("hqm_tb_top.u_hqm.prim_rst_b", 0);
    wait_ns_clk(500);
    set_val("hqm_tb_top.u_hqm.side_rst_b", 0);
    wait_ns_clk(500);
    set_val("hqm_tb_top.u_hqm.side_pwrgate_pmc_wake", 1);
    set_val("hqm_tb_top.u_hqm.prim_pwrgate_pmc_wake", 1);
    wait_ns_clk(500);
    set_val("hqm_tb_top.u_hqm.side_rst_b", 1);

    fork
      begin hqm_ip_ready.wait_trigger(); received_ip_ready = 1'b1; end
      begin wait_ns_clk(30000);                                    end
    join_any
    // -- if(~received_ip_ready) begin `ovm_error(get_full_name(), $sformatf("Timed out waiting for IP_READY!!! as received_ip_ready(0x%0x)",received_ip_ready)) end

    wait_ns_clk(7000);
    set_val("hqm_tb_top.u_hqm.prim_rst_b", 1);
    wait_ns_clk(300);
    set_val("hqm_tb_top.force_prim_side_clkack_hqm", 0);
    wait_ns_clk(1000);
    set_val("hqm_tb_top.u_hqm.side_pwrgate_pmc_wake", 1);
    set_val("hqm_tb_top.u_hqm.prim_pwrgate_pmc_wake", 1);
    wait_ns_clk(6000);

	`ovm_info(get_full_name(),$psprintf("Done with hqm_non_standard_warm_reset_seq"),OVM_LOW);
 
  endtask : body

  task set_val(string pin_name, bit sig_val);
    chandle             bit_handle;
    string              debug_msg="";
    string              hdr_str  ="";

    bit_handle = SLA_VPI_get_handle_by_name(pin_name,0);
    hqm_seq_put_value(bit_handle, sig_val);
    debug_msg = $psprintf("set_val (0x%0x)",sig_val);

    `ovm_info(get_full_name(), $sformatf("%s: %s", pin_name, debug_msg),OVM_LOW) 
  endtask

  task poll_val(string pin_name, bit exp_val, int clk_ticks = 1000);
    chandle             bit_handle;
    string              debug_msg = "", hdr_str = "";
    bit                 sig_val;

    @(sla_tb_env::sys_clk_r);

    for(int i = 0; i<clk_ticks; i++) begin

       @(sla_tb_env::sys_clk_r);
 
       bit_handle = SLA_VPI_get_handle_by_name(pin_name,0);
       hqm_seq_get_value(bit_handle, sig_val);
       debug_msg = $psprintf("value @clk_tick %0d is, obs_val (0x%0x) and exp_val(0x%0x)", i, sig_val, exp_val);
  
       `ovm_info(get_full_name(), $sformatf("%s %s", pin_name, debug_msg),OVM_DEBUG) 

       if(sig_val == exp_val) break;
   
    end

    if(sig_val==exp_val) `ovm_info(get_full_name(), $sformatf("Poll value for %s value check passed with %s", pin_name, debug_msg),OVM_LOW) 
    else                 `ovm_error(get_full_name(),$sformatf("Poll value for %s value check failed with %s", pin_name, debug_msg))

  endtask

  task wait_ns_clk(int ticks=10);
   repeat(ticks) begin @(sla_tb_env::sys_clk_r); end
  endtask

endclass : hqm_non_standard_warm_reset_seq

`endif
