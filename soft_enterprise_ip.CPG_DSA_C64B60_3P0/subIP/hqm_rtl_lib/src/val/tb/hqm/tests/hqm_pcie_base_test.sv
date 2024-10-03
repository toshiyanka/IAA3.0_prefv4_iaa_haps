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

`ifndef HQM_PCIE_BASE_TEST__SV
`define HQM_PCIE_BASE_TEST__SV

`include "hqm_base_test.sv";

import hqm_tb_cfg_sequences_pkg::*;
import pcie_seqlib_pkg::*;

class hqm_pcie_base_test extends hqm_base_test;

  `ovm_component_utils(hqm_pcie_base_test)

  function new(string name = "hqm_pcie_base_test", ovm_component parent = null);
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
    i_hqm_tb_env.skip_test_phase("FLUSH_PHASE");
  endfunction

  virtual protected function void do_config();
  endfunction

  virtual protected function void set_config();
	// -- Denali Fix integer status;
    // -- Denali Fix ovm_top.set_config_int("*", "recording_detail" , OVM_FULL);
	// -- Denali Fix status = denaliPcieInit();
	// -- Denali Fix assert (status != -1) begin	end
	// -- Denali Fix else begin
	// -- Denali Fix   `ovm_fatal("hqm_pcie_base_test"," DENALI DDV initialization failed. Cannot continue ...\n");
	// -- Denali Fix end
  endfunction

  virtual protected function void set_override();
  endfunction

endclass
`endif
