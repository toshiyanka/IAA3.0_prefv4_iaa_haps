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

`ifndef HQM_BASE_TEST__SV
`define HQM_BASE_TEST__SV

import hqm_saola_pkg::*;
import hqm_cfg_pkg::*;
import hqm_tb_cfg_pkg::*;
import hcw_pkg::*;
import IosfPkg::*;
import iosfsbm_cm::*;
import iosfsbm_seq::*;
import hqm_reset_pkg::*;
import hqm_reset_sequences_pkg::*;


class hqm_base_test extends ovm_test;

  `ovm_component_utils(hqm_base_test)

  string user_data_phase_seq = "hqm_boot_sequence";
  hqm_tb_env              i_hqm_tb_env;

  sla_ral_env             ral;

  hqm_iosf_sb_cb          i_hqm_iosf_sb_cb;

  
  hqm_iosf_sb_posted_cb   i_hqm_iosf_sb_posted_cb;
   
  //--AY_HQMV30_ATS hqm_iosf_mrd_cb         i_hqm_iosf_mrd_cb;
  sla_ral_access_path_t   primary_id;
  int                     pfvf_space_access;
   
  function new(string name = "hqm_base_test", ovm_component parent = null);
    super.new(name,parent);
    primary_id = sla_iosf_pri_reg_lib_pkg::get_src_type();  

   `ovm_info("HQM_BASE_TEST", $psprintf("hqm_base_test::address_map_dut_view_pkg)"), OVM_LOW)
    set_type_override_by_type(address_map_dut_view_pkg::address_map_dut_view_builder::get_type(), hqm_address_map_builder::get_type());
  endfunction

  function void build();
    set_config_int("*", "count", 0);

    super.build();

   `ovm_info("HQM_BASE_TEST", $psprintf("hqm_base_test::build)"), OVM_LOW)
    set_override();
    do_config();
    set_config();

    i_hqm_tb_env       = hqm_tb_env::type_id::create("i_hqm_tb_env", this);
    i_hqm_tb_env.add_test_phase( "EXTRA_DATA_PHASE", "DATA_PHASE", "AFTER"); // -- After DATA_PHASE -- //

    i_hqm_iosf_sb_cb = hqm_iosf_sb_cb::type_id::create("i_hqm_iosf_sb_cb", this);
    i_hqm_iosf_sb_posted_cb = hqm_iosf_sb_posted_cb::type_id::create("i_hqm_iosf_sb_posted_cb", this);

    //--AY_HQMV30_ATS i_hqm_iosf_mrd_cb   = new();

  endfunction

  function void connect();

    super.connect();

    $value$plusargs({"HQM_PFVF_SPACE_ACCESS","=%d"}, this.pfvf_space_access); //anyan: added to support pfvf space tests
    $value$plusargs("HQM_RAL_ACCESS_PATH=%s",primary_id);
    i_hqm_tb_env.hqm_agent_env_handle.i_hqm_tb_cfg.set_ral_access_path(primary_id);
    `ovm_info("IOSF_RAL_FILE_SEQ",$psprintf("primary_id is set to %s, pfvf_space_access %0d",primary_id, pfvf_space_access),OVM_LOW)

    if ($test$plusargs("HQM_RAL_SET_VARIANT_CHECK")) begin
      $cast(ral, sla_ral_env::get_ptr());

      if (ral == null) begin
        ovm_report_fatal(get_full_name(), "Unable to get RAL handle");
      end    

      ral.set_variant_check(1);
    end

    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env", "POWER_GOOD_PHASE", "hqm_power_up_sequence");

    if (!$value$plusargs("HQM_HARD_RESET_PHASE_SEQ=%s",user_data_phase_seq)) begin
        user_data_phase_seq = "hqm_boot_sequence";
    end
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env", "HARD_RESET_PHASE", user_data_phase_seq);

if($test$plusargs("HQM_SURVIVABILITY_MODE")) begin
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env", "WARM_RESET_PHASE", "hqm_survivability_patch_seq");
end

`ifdef IP_TYP_TE
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env", "RANDOM_DATA_PHASE", "hqm_random_data_phase_seq");

    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env", "EXTRA_DATA_PHASE", "hqm_extra_data_phase_seq");
`endif //`ifdef IP_TYP_TE

if(!$test$plusargs("HQM_NO_PCIE_CONFIG_PHASE")) begin
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env", "PCIE_CONFIG_PHASE", "hqm_sla_pcie_init_seq");
end
    
`ifdef IP_TYP_TE
if(!$test$plusargs("HQM_NO_POST_CONFIG_PHASE")) begin
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env", "POST_CONFIG_PHASE", "hqm_post_config_phase_seq");
end

if(!$test$plusargs("HQM_NO_PRE_FLUSH_PHASE")) begin
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env", "PRE_FLUSH_PHASE", "hqm_pre_flush_phase_seq");
end

if(!$test$plusargs("HQM_PCIE_SKIP_EOT_SEQ")) begin // required for v-retention test
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env", "PCIE_FLUSH_PHASE", "hqm_sla_pcie_eot_sequence");
end
`endif //`ifdef IP_TYP_TE

if(!$test$plusargs("HQM_RTDR_SKIP_EOT_SEQ")) begin // RTDR test
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","FLUSH_PHASE","hqm_eot_check_seq");
end

    i_hqm_tb_env.iosf_svc.open_tracker_file();

    i_hqm_tb_env.iosf_svc.register_user_cb(i_hqm_iosf_sb_cb, '{'h45}); // -- FUSE_PULL msg -- //

    i_hqm_tb_env.iosf_svc.register_posted_cb(i_hqm_iosf_sb_posted_cb, '{'h80,'hd0,'h2b},'{iosfsbm_cm::SIMPLE,iosfsbm_cm::SIMPLE,iosfsbm_cm::SIMPLE}); // -- INTA, IP_READY, ResetPrepAck msgs -- //

    //--AY_HQMV30_ATS i_hqm_tb_env.hqm_agent_env_handle.iosf_pvc.registerCallBack(i_hqm_iosf_mrd_cb, '{Iosf::MRd64,Iosf::MRd32});
 
    i_hqm_tb_env.set_phase_timeout("FLUSH_PHASE", 3000000);

    if(pfvf_space_access==1) begin 
      i_hqm_tb_env.set_max_run_clocks(0);
    end else begin
      i_hqm_tb_env.set_max_run_clocks(3000000);
    end

  endfunction

  virtual task run();

     int destall_fab_crd_init;

      if ($test$plusargs("HQM_IOSF_PRIM_STALL_FAB_CRD_INIT")) begin
          `ovm_info(get_full_name(), $psprintf("HQM_IOSF_PRIM_STALL_FAB_CRD_INIT plusargs provided; setting stallFabCrdInit to 1"), OVM_MEDIUM);
          i_hqm_tb_env.hqm_agent_env_handle.iosf_pvc.iosfFabCfg.iosfAgtCfg[1].stallFabCrdInit = 1;
          destall_fab_crd_init = $urandom_range(10, 20000);
          #(1ns * destall_fab_crd_init);
          `ovm_info(get_full_name(), $psprintf("HQM_IOSF_PRIM_STALL_FAB_CRD_INIT plusargs provided; setting stallFabCrdInit to 0 (destall_fab_crd_init=%0d)", destall_fab_crd_init), OVM_MEDIUM);
          i_hqm_tb_env.hqm_agent_env_handle.iosf_pvc.iosfFabCfg.iosfAgtCfg[1].stallFabCrdInit = 0;
      end

  endtask

  virtual protected function void do_config();
  endfunction

  virtual protected function void set_config();
  endfunction

  virtual protected function void set_override();
  endfunction


  function void end_of_elaboration();
    if (ovm_report_enabled(OVM_HIGH,OVM_INFO,"hqm_base_test")) begin
      ovm_top.print_topology();
    end
  endfunction

  function void report();
    ovm_report_server report_server;

    report_server = get_report_server();

    if ((report_server.get_severity_count(OVM_FATAL) > 0) | (report_server.get_severity_count(OVM_ERROR) > 0)) begin
      `ovm_error("hqm_base_test", "Test Failed!");
    end else begin
      `ovm_info("hqm_base_test", "Test Passed!",OVM_LOW);
    end
  endfunction
endclass
`endif
