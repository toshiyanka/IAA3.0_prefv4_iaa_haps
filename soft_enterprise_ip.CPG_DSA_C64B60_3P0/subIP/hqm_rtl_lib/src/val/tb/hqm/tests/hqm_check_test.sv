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
//-- Test
//-----------------------------------------------------------------------------------------------------

`ifndef hqm_check_test__SV
`define hqm_check_test__SV

import hqm_saola_pkg::*;
import hqm_cfg_pkg::*;
import hqm_tb_cfg_pkg::*;

class hqm_check_test extends ovm_test;

  `ovm_component_utils(hqm_check_test)

  ovm_event event1 ;

  const string TESTNAME = "hqm_check_test";

  hqm_tb_env           i_hqm_tb_env;

//  hqm_tb_cfg            i_hqm_cfg;

  hqm_iosf_sb_cb        i_hqm_iosf_sb_cb;

  static hqm_check_test test1; 
 // static function hqm_check_test get_test;

 static function hqm_check_test get_test;
    return test1;
  endfunction 

 extern task run_time_until_idle (longint unsigned timeout = 1_000_000,
                                    int unsigned time_step = 20);
 

  function new(string name = "hqm_check_test", ovm_component parent = null);
    super.new(name,parent);
    test1 = this ;

   `ovm_info("HQM_CHECK_TEST", $psprintf("hqm_check_test::address_map_dut_view_pkg)"), OVM_LOW)
    set_type_override_by_type(address_map_dut_view_pkg::address_map_dut_view_builder::get_type(), hqm_address_map_builder::get_type());
  endfunction

  function void build();

    set_config_int("*", "count", 0);
    


    super.build();

    set_override();
    do_config();
    set_config();

    i_hqm_tb_env = hqm_tb_env::type_id::create("i_hqm_tb_env", this);

    i_hqm_iosf_sb_cb = hqm_iosf_sb_cb::type_id::create("i_hqm_iosf_sb_cb", this);

//Not sure why this is needed in the test, already set in ENV
/*    i_hqm_cfg = hqm_tb_cfg::type_id::create("i_hqm_cfg",this);
    i_hqm_cfg.set_ral_type("hqm_ral_env");

    $value$plusargs("HQM_RAL_ACCESS_PATH=%s",primary_id);
    i_hqm_cfg.set_ral_access_path(primary_id);
    `ovm_info("IOSF_RAL_FILE_SEQ",$psprintf("primary_id is set to %s",primary_id),OVM_LOW)

    i_hqm_cfg.set_tb_scope("hqm");
    i_hqm_cfg.set_hqm_core_module_prefix("hqm_tb_top.u_hqm.hqm_core");
    i_hqm_cfg.set_hqm_module_prefix("hqm_tb_top.u_hqm");
*/
  endfunction

  function void connect();
    super.connect();
    i_hqm_tb_env.iosf_svc.open_tracker_file();

    i_hqm_tb_env.iosf_svc.register_user_cb(i_hqm_iosf_sb_cb, '{'h45});

  endfunction

  virtual protected function void do_config();
  endfunction

  virtual protected function void set_config();
  endfunction

  virtual protected function void set_override();
  endfunction

  function void end_of_elaboration();
    ovm_top.print_topology();
  endfunction

  function void report();
    ovm_report_server report_server;

    report_server = get_report_server();

    if ((report_server.get_severity_count(OVM_FATAL) > 0) | (report_server.get_severity_count(OVM_ERROR) > 0)) begin
      `ovm_error("hqm_check_test", "Test Failed!");
    end else begin
      `ovm_info("hqm_check_test", "Test Passed!",OVM_LOW);
    end
  endfunction

 endclass

  /***************************************************************
 * run_time_until_idle finishes after all Agent and Fabric PVC
 * queues are empty, and all credits have been returned. If the 
 * queues are not empty then it continually runs another time 
 * increment and checks the queues again until the time value, 
 * when it issues an error message if the queues are still not 
 * empty.
 * @param timeout   - max time to wait in timescale units
 * @param time_step - amount of time run between each check
 ***************************************************************/
task hqm_check_test::run_time_until_idle (longint unsigned timeout  = 1_000_000, int unsigned time_step = 20);

  int unsigned step_ctr = 0;
   `ovm_info("hqm_check_test", "ashit entered",OVM_LOW);
//Fix if test still needed
/*
   while (!(i_hqm_tb_env.iosf_pvc.fabQIsEmpty ()) && 
          ((step_ctr*time_step) < timeout)) begin
      #time_step;
      step_ctr++;
   end 
*/
   if ((step_ctr*time_step) >= timeout) begin
      `ovm_error ("run_time_until_idle", 
                 $psprintf ("Error: time_step %0d * cnt %0d >= timeout %0d", 
                           time_step, step_ctr, timeout))
      
/*      if (!i_hqm_tb_env.iosf_pvc.fabQIsEmpty ()) 
       `ovm_error (TESTNAME, 
                 "ERROR: test ended while a Fabric PVC queue was not empty")
*/     `ovm_fatal ("run_time_until_idle", "TEST TIMED OUT!")
   end // if ((step_ctr*time_step) >= timeout)
   `ovm_info("hqm_check_test", "ashit exit",OVM_LOW);

endtask: run_time_until_idle


`endif
