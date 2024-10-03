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

`ifndef HQM_TLP_RSVD_TGL_TEST__SV
`define HQM_TLP_RSVD_TGL_TEST__SV

`include "hqm_pcie_base_test.sv"
import hqm_tb_cfg_sequences_pkg::*;

class hqm_tlp_rsvd_tgl_test extends hqm_pcie_base_test;

  `ovm_component_utils(hqm_tlp_rsvd_tgl_test)
  hqm_sb_pcie_cb   i_hqm_sb_pcie_cb;
  function new(string name = "hqm_tlp_rsvd_tgl_test", ovm_component parent = null);
    super.new(name,parent);
  endfunction

  function void build();

    super.build();

    set_override();
    do_config();
    set_config();
    i_hqm_sb_pcie_cb = hqm_sb_pcie_cb::type_id::create("i_hqm_sb_pcie_cb", this);

  endfunction

  function void connect();
    super.connect();
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","CONFIG_PHASE","hqm_tb_hcw_cfg_seq");
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","USER_DATA_PHASE","hqm_tlp_rsvd_tgl_seq");
    i_hqm_tb_env.iosf_svc.register_posted_cb(i_hqm_sb_pcie_cb, '{'h49, 'h80, 'h84},'{iosfsbm_cm::MSGD, iosfsbm_cm::MSGD, iosfsbm_cm::MSGD});

      i_hqm_tb_env.hqm_agent_env_handle.hqmCfg.iosf_pagt_upnode_cfg.setAssertionDisable ("PRI_027");
      i_hqm_tb_env.hqm_agent_env_handle.hqmCfg.iosf_pagt_dut_cfg.setAssertionDisable ("PRI_027");
      i_hqm_tb_env.hqm_agent_env_handle.hqmCfg.iosf_pvc_cfg.iosfAgtCfg[0].setAssertionDisable ("PRI_027");
      i_hqm_tb_env.hqm_agent_env_handle.hqmCfg.iosf_pvc_cfg.iosfAgtCfg[1].setAssertionDisable ("PRI_027");

      i_hqm_tb_env.hqm_agent_env_handle.hqmCfg.iosf_pagt_upnode_cfg.setAssertionDisable ("PRI_037");
      i_hqm_tb_env.hqm_agent_env_handle.hqmCfg.iosf_pagt_dut_cfg.setAssertionDisable ("PRI_037");
      i_hqm_tb_env.hqm_agent_env_handle.hqmCfg.iosf_pvc_cfg.iosfAgtCfg[0].setAssertionDisable ("PRI_037");
      i_hqm_tb_env.hqm_agent_env_handle.hqmCfg.iosf_pvc_cfg.iosfAgtCfg[1].setAssertionDisable ("PRI_037");

      i_hqm_tb_env.hqm_agent_env_handle.hqmCfg.iosf_pagt_upnode_cfg.setAssertionDisable ("PRI_174");
      i_hqm_tb_env.hqm_agent_env_handle.hqmCfg.iosf_pagt_dut_cfg.setAssertionDisable ("PRI_174");
      i_hqm_tb_env.hqm_agent_env_handle.hqmCfg.iosf_pvc_cfg.iosfAgtCfg[0].setAssertionDisable ("PRI_174");
      i_hqm_tb_env.hqm_agent_env_handle.hqmCfg.iosf_pvc_cfg.iosfAgtCfg[1].setAssertionDisable ("PRI_174");

      i_hqm_tb_env.hqm_agent_env_handle.hqmCfg.iosf_pagt_upnode_cfg.setAssertionDisable ("PRI_106");
      i_hqm_tb_env.hqm_agent_env_handle.hqmCfg.iosf_pagt_dut_cfg.setAssertionDisable ("PRI_106");
      i_hqm_tb_env.hqm_agent_env_handle.hqmCfg.iosf_pvc_cfg.iosfAgtCfg[0].setAssertionDisable ("PRI_106");
      i_hqm_tb_env.hqm_agent_env_handle.hqmCfg.iosf_pvc_cfg.iosfAgtCfg[1].setAssertionDisable ("PRI_106");

      i_hqm_tb_env.hqm_agent_env_handle.hqmCfg.iosf_pagt_upnode_cfg.setAssertionDisable ("PRI_026");
      i_hqm_tb_env.hqm_agent_env_handle.hqmCfg.iosf_pagt_dut_cfg.setAssertionDisable ("PRI_026");
      i_hqm_tb_env.hqm_agent_env_handle.hqmCfg.iosf_pvc_cfg.iosfAgtCfg[0].setAssertionDisable ("PRI_026");
      i_hqm_tb_env.hqm_agent_env_handle.hqmCfg.iosf_pvc_cfg.iosfAgtCfg[1].setAssertionDisable ("PRI_026");

      i_hqm_tb_env.hqm_agent_env_handle.hqmCfg.iosf_pagt_upnode_cfg.setAssertionDisable ("PRI_026");
      i_hqm_tb_env.hqm_agent_env_handle.hqmCfg.iosf_pagt_dut_cfg.setAssertionDisable ("PRI_026");
      i_hqm_tb_env.hqm_agent_env_handle.hqmCfg.iosf_pvc_cfg.iosfAgtCfg[0].setAssertionDisable ("PRI_026");
      i_hqm_tb_env.hqm_agent_env_handle.hqmCfg.iosf_pvc_cfg.iosfAgtCfg[1].setAssertionDisable ("PRI_026");

      i_hqm_tb_env.hqm_agent_env_handle.hqmCfg.iosf_pagt_upnode_cfg.setAssertionDisable ("PRI_SOMENUM");
      i_hqm_tb_env.hqm_agent_env_handle.hqmCfg.iosf_pagt_dut_cfg.setAssertionDisable ("PRI_SOMENUM");
      i_hqm_tb_env.hqm_agent_env_handle.hqmCfg.iosf_pvc_cfg.iosfAgtCfg[0].setAssertionDisable ("PRI_SOMENUM");
      i_hqm_tb_env.hqm_agent_env_handle.hqmCfg.iosf_pvc_cfg.iosfAgtCfg[1].setAssertionDisable ("PRI_SOMENUM");

      i_hqm_tb_env.hqm_agent_env_handle.hqmCfg.iosf_pagt_upnode_cfg.setAssertionDisable ("PRI_026");
      i_hqm_tb_env.hqm_agent_env_handle.hqmCfg.iosf_pagt_dut_cfg.setAssertionDisable ("PRI_026");
      i_hqm_tb_env.hqm_agent_env_handle.hqmCfg.iosf_pvc_cfg.iosfAgtCfg[0].setAssertionDisable ("PRI_026");
      i_hqm_tb_env.hqm_agent_env_handle.hqmCfg.iosf_pvc_cfg.iosfAgtCfg[1].setAssertionDisable ("PRI_026");

      i_hqm_tb_env.hqm_agent_env_handle.hqmCfg.iosf_pagt_upnode_cfg.setAssertionDisable ("PRI_168");
      i_hqm_tb_env.hqm_agent_env_handle.hqmCfg.iosf_pagt_dut_cfg.setAssertionDisable ("PRI_168");
      i_hqm_tb_env.hqm_agent_env_handle.hqmCfg.iosf_pvc_cfg.iosfAgtCfg[0].setAssertionDisable ("PRI_168");
      i_hqm_tb_env.hqm_agent_env_handle.hqmCfg.iosf_pvc_cfg.iosfAgtCfg[1].setAssertionDisable ("PRI_168");


  endfunction

  virtual protected function void do_config();
  endfunction

  virtual protected function void set_config();
  endfunction

  virtual protected function void set_override();
  endfunction
 
   virtual task run();
    `ovm_info(get_type_name(), "Entered body of hqm_tlp_rsvd_tgl_test run phase", OVM_MEDIUM);
  endtask: run

endclass
`endif
