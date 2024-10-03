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

`ifndef HQM_SLA_PCIE_CFG_RD_BEFORE_WR_SEQ__SV
`define HQM_SLA_PCIE_CFG_RD_BEFORE_WR_SEQ__SV

//------------------------------------------------------------------------------
// File        : hqm_sla_pcie_cfg_rd_before_wr_seq.sv
// Author      : Neeraj Shete
//
// Description : This sequence -> Issues CfgRd0 to VENDOR_ID of PF followed by 
//               -> CfgWr0 to DEV_COMMAND register of PF with val 0x4.
//------------------------------------------------------------------------------


class hqm_sla_pcie_cfg_rd_before_wr_seq extends hqm_sla_pcie_base_seq;
  `ovm_sequence_utils(hqm_sla_pcie_cfg_rd_before_wr_seq,sla_sequencer)
  
  function new(string name = "hqm_sla_pcie_cfg_rd_before_wr_seq");
    super.new(name);
  endfunction

  virtual task body();
    bit rslt;
    read_compare(pf_cfg_regs.VENDOR_ID,32'h_8086,.mask(32'h_0000_ffff),.result(rslt));
	pf_cfg_regs.DEVICE_COMMAND.write(status,32'h_06,primary_id,this,.sai(legal_sai));
  endtask

endclass

`endif
