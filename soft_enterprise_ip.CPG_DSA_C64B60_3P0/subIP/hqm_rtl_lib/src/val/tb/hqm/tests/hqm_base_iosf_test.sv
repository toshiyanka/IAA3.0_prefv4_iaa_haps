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

`ifndef hqm_base_iosf_test__SV
`define hqm_base_iosf_test__SV

import hqm_saola_pkg::*;
import hqm_cfg_pkg::*;
import hqm_tb_cfg_pkg::*;
import hcw_pkg::*;
import IosfPkg::*;

class hqm_base_iosf_test extends ovm_test;

  `ovm_component_utils(hqm_base_iosf_test)

  hqm_tb_env           i_hqm_tb_env;

  hqm_iosf_sb_cb        i_hqm_iosf_sb_cb;
  hqm_iosf_sb_posted_cb   i_hqm_iosf_sb_posted_cb;
  hqm_iosf_sb_PCIE_cb   i_hqm_iosf_sb_PCIE_cb;
  hqm_iosf_sb_RESET_PREP_cb   i_hqm_iosf_sb_RESET_PREP_cb;

  sla_ral_access_path_t         primary_id;



  function new(string name = "hqm_base_iosf_test", ovm_component parent = null);
    super.new(name,parent);
    primary_id = sla_iosf_pri_reg_lib_pkg::get_src_type();     

   `ovm_info("HQM_BASE_IOSF_TEST", $psprintf("hqm_base_iosf_test::address_map_dut_view_pkg)"), OVM_LOW)
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
    i_hqm_iosf_sb_posted_cb = hqm_iosf_sb_posted_cb::type_id::create("i_hqm_iosf_sb_posted_cb", this);
   i_hqm_iosf_sb_PCIE_cb = hqm_iosf_sb_PCIE_cb::type_id::create("i_hqm_iosf_sb_PCIE_cb", this);
   i_hqm_iosf_sb_RESET_PREP_cb = hqm_iosf_sb_RESET_PREP_cb::type_id::create("i_hqm_iosf_sb_RESET_PREP_cb", this);



  endfunction

  function void connect();

    super.connect();

    i_hqm_tb_env.iosf_svc.register_posted_cb(i_hqm_iosf_sb_posted_cb, '{'h80},'{iosfsbm_cm::SIMPLE});
    i_hqm_tb_env.iosf_svc.register_posted_cb(i_hqm_iosf_sb_PCIE_cb, '{'h49},'{iosfsbm_cm::MSGD});
    i_hqm_tb_env.iosf_svc.register_posted_cb(i_hqm_iosf_sb_RESET_PREP_cb, '{'h2b},'{iosfsbm_cm::MSGD});


    $value$plusargs("HQM_RAL_ACCESS_PATH=%s",primary_id);
    //Now set in IntegEnv
    //i_hqm_tb_env.i_hqm_cfg.set_ral_access_path(primary_id);
    `ovm_info("IOSF_RAL_FILE_SEQ",$psprintf("primary_id is set to %s",primary_id),OVM_LOW)

    i_hqm_tb_env.iosf_svc.open_tracker_file();

    i_hqm_tb_env.iosf_svc.register_user_cb(i_hqm_iosf_sb_cb, '{'h45});

//Now set in IntegEnv
/*     
    if($test$plusargs("DATA_PARITY_CHECK")) begin 
   i_hqm_tb_env.iosf_pagt_upnode_cfg.setAssertionDisable ("PRI_286");
   i_hqm_tb_env.iosf_pagt_dut_cfg.setAssertionDisable ("PRI_286");
   i_hqm_tb_env.iosf_pvc_cfg.iosfAgtCfg[0].setAssertionDisable ("PRI_286");
   i_hqm_tb_env.iosf_pvc_cfg.iosfAgtCfg[1].setAssertionDisable ("PRI_286");
   end

    if($test$plusargs("HQM_COMMAND_PARITY_CHECK")) begin 
   i_hqm_tb_env.iosf_pagt_upnode_cfg.setAssertionDisable ("PRI_075");
   i_hqm_tb_env.iosf_pagt_dut_cfg.setAssertionDisable ("PRI_075");
   i_hqm_tb_env.iosf_pvc_cfg.iosfAgtCfg[0].setAssertionDisable ("PRI_075");
   i_hqm_tb_env.iosf_pvc_cfg.iosfAgtCfg[1].setAssertionDisable ("PRI_075");
   end

   if($test$plusargs("CONFIG_LENGTH_CHECK")) begin 
   i_hqm_tb_env.iosf_pagt_upnode_cfg.setAssertionDisable ("PRI_025");
   i_hqm_tb_env.iosf_pagt_dut_cfg.setAssertionDisable ("PRI_025");
   i_hqm_tb_env.iosf_pvc_cfg.iosfAgtCfg[0].setAssertionDisable ("PRI_025");
   i_hqm_tb_env.iosf_pvc_cfg.iosfAgtCfg[1].setAssertionDisable ("PRI_025");
   end

   if($test$plusargs("BAD_IMPS_CHECK")) begin 
   i_hqm_tb_env.iosf_pagt_upnode_cfg.setAssertionDisable ("PRI_078");
   i_hqm_tb_env.iosf_pagt_dut_cfg.setAssertionDisable ("PRI_078");
   i_hqm_tb_env.iosf_pvc_cfg.iosfAgtCfg[0].setAssertionDisable ("PRI_078");
   i_hqm_tb_env.iosf_pvc_cfg.iosfAgtCfg[1].setAssertionDisable ("PRI_078");
   end

   if($test$plusargs("BAD_IMPS_CHECK1")) begin 
   i_hqm_tb_env.iosf_pagt_upnode_cfg.setAssertionDisable ("PRI_226");
   i_hqm_tb_env.iosf_pagt_dut_cfg.setAssertionDisable ("PRI_226");
   i_hqm_tb_env.iosf_pvc_cfg.iosfAgtCfg[0].setAssertionDisable ("PRI_226");
   i_hqm_tb_env.iosf_pvc_cfg.iosfAgtCfg[1].setAssertionDisable ("PRI_226");
   end

   if($test$plusargs("BAD_LBE_CHECK")) begin 
   i_hqm_tb_env.iosf_pagt_upnode_cfg.setAssertionDisable ("PRI_201");
   i_hqm_tb_env.iosf_pagt_dut_cfg.setAssertionDisable ("PRI_201");
   i_hqm_tb_env.iosf_pvc_cfg.iosfAgtCfg[0].setAssertionDisable ("PRI_201");
   i_hqm_tb_env.iosf_pvc_cfg.iosfAgtCfg[1].setAssertionDisable ("PRI_201");
   end

    if($test$plusargs("LOCK")) begin 
   i_hqm_tb_env.iosf_pagt_upnode_cfg.setAssertionDisable ("PRI_040");
   i_hqm_tb_env.iosf_pagt_dut_cfg.setAssertionDisable ("PRI_040");
   i_hqm_tb_env.iosf_pvc_cfg.iosfAgtCfg[0].setAssertionDisable ("PRI_040");
   i_hqm_tb_env.iosf_pvc_cfg.iosfAgtCfg[1].setAssertionDisable ("PRI_040");
   end

   
    if($test$plusargs("SPURIOUS_COMPLETION")) begin 
   i_hqm_tb_env.iosf_pagt_upnode_cfg.setAssertionDisable ("PRI_199");
   i_hqm_tb_env.iosf_pagt_dut_cfg.setAssertionDisable ("PRI_199");
   i_hqm_tb_env.iosf_pvc_cfg.iosfAgtCfg[0].setAssertionDisable ("PRI_199");
   i_hqm_tb_env.iosf_pvc_cfg.iosfAgtCfg[1].setAssertionDisable ("PRI_199");
   end

  if($test$plusargs("ATOMIC_ERROR")) begin 
   i_hqm_tb_env.iosf_pagt_upnode_cfg.setAssertionDisable ("PRI_141");
   i_hqm_tb_env.iosf_pagt_dut_cfg.setAssertionDisable ("PRI_141");
   i_hqm_tb_env.iosf_pvc_cfg.iosfAgtCfg[0].setAssertionDisable ("PRI_141");
   i_hqm_tb_env.iosf_pvc_cfg.iosfAgtCfg[1].setAssertionDisable ("PRI_141");
   end

    if($test$plusargs("MATCH_REQUEST_BC")) begin 
   i_hqm_tb_env.iosf_pagt_upnode_cfg.setAssertionDisable ("MatchRe-questBC");
   i_hqm_tb_env.iosf_pagt_dut_cfg.setAssertionDisable ("MatchRe-questBC");
   i_hqm_tb_env.iosf_pvc_cfg.iosfAgtCfg[0].setAssertionDisable ("MatchRe-questBC");
   i_hqm_tb_env.iosf_pvc_cfg.iosfAgtCfg[1].setAssertionDisable ("MatchRe-questBC");
   i_hqm_tb_env.iosf_pagt_upnode_cfg.setAssertionDisable ("MatchRequestBC");
   i_hqm_tb_env.iosf_pagt_dut_cfg.setAssertionDisable ("MatchRequestBC");
   i_hqm_tb_env.iosf_pvc_cfg.iosfAgtCfg[0].setAssertionDisable ("MatchRequestBC");
   i_hqm_tb_env.iosf_pvc_cfg.iosfAgtCfg[1].setAssertionDisable ("MatchRequestBC");
 end
*/
  endfunction

  virtual task run();
  endtask

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
      `ovm_error("hqm_base_iosf_test", "Test Failed!");
    end else begin
      `ovm_info("hqm_base_iosf_test", "Test Passed!",OVM_LOW);
    end
  endfunction
endclass
`endif
