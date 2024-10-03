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

`ifndef HQM_PCIE_FLR_WITH_TXNS__SV
`define HQM_PCIE_FLR_WITH_TXNS__SV

`include "hqm_pcie_base_test.sv"
import hqm_tb_cfg_sequences_pkg::*;

class hqm_pcie_flr_with_txns extends hqm_pcie_base_test;

  `ovm_component_utils(hqm_pcie_flr_with_txns)

  function new(string name = "hqm_pcie_flr_with_txns", ovm_component parent = null);
    super.new(name,parent);
  endfunction

  function void build();

    super.build();

    set_override();
    do_config();
    set_config();

  endfunction

  function void connect();
    super.connect();
    i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","CONFIG_PHASE","hqm_pcie_flr_with_txns_seq");
    if(!$test$plusargs("SKIP_HCW_CFG_SEQ")) 
        i_hqm_tb_env.set_test_phase_type("i_hqm_tb_env","USER_DATA_PHASE","hqm_tb_hcw_cfg_seq");

    // as the RTL behavior is indeterministic for Txns sent in FLR, skipping PCIe EOT checks
    i_hqm_tb_env.skip_test_phase("PCIE_FLUSH_PHASE");

    // --  -- //
    i_hqm_tb_env.hqm_agent_env_handle.hqmCfg.iosf_pagt_upnode_cfg.setAssertionDisable ("PRI_198");
    i_hqm_tb_env.hqm_agent_env_handle.hqmCfg.iosf_pagt_dut_cfg.setAssertionDisable ("PRI_198");
    i_hqm_tb_env.hqm_agent_env_handle.hqmCfg.iosf_pvc_cfg.iosfAgtCfg[0].setAssertionDisable ("PRI_198");
    i_hqm_tb_env.hqm_agent_env_handle.hqmCfg.iosf_pvc_cfg.iosfAgtCfg[1].setAssertionDisable ("PRI_198");

    // -- Sending unexpected completions to HQM. So masking errors from PVC -- //
    i_hqm_tb_env.hqm_agent_env_handle.hqmCfg.iosf_pagt_upnode_cfg.setAssertionDisable ("PRI_199");
    i_hqm_tb_env.hqm_agent_env_handle.hqmCfg.iosf_pagt_dut_cfg.setAssertionDisable ("PRI_199");
    i_hqm_tb_env.hqm_agent_env_handle.hqmCfg.iosf_pvc_cfg.iosfAgtCfg[0].setAssertionDisable ("PRI_199");
    i_hqm_tb_env.hqm_agent_env_handle.hqmCfg.iosf_pvc_cfg.iosfAgtCfg[1].setAssertionDisable ("PRI_199");

  endfunction

  virtual protected function void do_config();
  endfunction

  virtual protected function void set_config();
  endfunction

  virtual protected function void set_override();
  endfunction
 
   virtual task run();
    `ovm_info(get_type_name(), "Entered body of hqm_pcie_flr_with_txns run phase", OVM_MEDIUM);
  endtask: run

   virtual function void check();
       int resp_q_size;
       int check_resp_q;
       $value$plusargs("CHECK_RESP_Q=%0d", check_resp_q);
       if (check_resp_q) begin
           `ifdef HQM_IOSF_2019_BFM
              resp_q_size = i_hqm_tb_env.hqm_agent_env_handle.iosf_pvc.iosfAgtTlm.iosfAgtSlvTlm.expTgtTxnQ.q.size();
              if (i_hqm_tb_env.hqm_agent_env_handle.iosf_pvc.iosfAgtTlm.iosfAgtSlvTlm.expTgtTxnQ.q.size() != 1)
                 ovm_report_warning(get_full_name(), $psprintf("Expected to have one entry in this queue as Request was to be dropped by HQM in FLR: q_size = %d", resp_q_size));
              else
                 `ovm_info(get_type_name(), $sformatf("Didn't get the completion as expected; pending queue size=%0d ", resp_q_size), OVM_LOW);
 
              i_hqm_tb_env.hqm_agent_env_handle.iosf_pvc.iosfAgtTlm.iosfAgtSlvTlm.expTgtTxnQ.q.delete();
              resp_q_size = i_hqm_tb_env.hqm_agent_env_handle.iosf_pvc.iosfAgtTlm.iosfAgtSlvTlm.expTgtTxnQ.q.size();

           `else
              resp_q_size = i_hqm_tb_env.hqm_agent_env_handle.iosf_pvc.iosfAgtTlm.iosfAgtTgtTlm.expTgtTxnQ.q.size();
              if (i_hqm_tb_env.hqm_agent_env_handle.iosf_pvc.iosfAgtTlm.iosfAgtTgtTlm.expTgtTxnQ.q.size() != 1)
                  ovm_report_warning(get_full_name(), $psprintf("Expected to have one entry in this queue as Request was to be dropped by HQM in FLR: q_size = %d", resp_q_size));
              else
                 `ovm_info(get_type_name(), $sformatf("Didn't get the completion as expected; pending queue size=%0d ", resp_q_size), OVM_LOW);

              i_hqm_tb_env.hqm_agent_env_handle.iosf_pvc.iosfAgtTlm.iosfAgtTgtTlm.expTgtTxnQ.q.delete();
              resp_q_size = i_hqm_tb_env.hqm_agent_env_handle.iosf_pvc.iosfAgtTlm.iosfAgtTgtTlm.expTgtTxnQ.q.size();
           `endif

       end 
   endfunction:check 

endclass
`endif
