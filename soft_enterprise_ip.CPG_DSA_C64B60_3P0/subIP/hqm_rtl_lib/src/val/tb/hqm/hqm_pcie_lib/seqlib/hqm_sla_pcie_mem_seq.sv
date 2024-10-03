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

`ifndef HQM_SLA_PCIE_MEM_SEQ__SV
`define HQM_SLA_PCIE_MEM_SEQ__SV

//------------------------------------------------------------------------------
// File        : hqm_sla_pcie_mem_seq.sv
// Author      : Neeraj Shete
//
// Description : This sequence issues MWr/MRd accesses to HQM.
//               - Issues MWr with non-reset val to register within each BAR.
//               - Issues MRd to read back the value written.
//               - If 'HQM_PCIE_MEM_ACCESS_ERR', check MWr & MRd behaviour with 
//                 PF.MEM set to 0 & 1.
//------------------------------------------------------------------------------

class hqm_sla_pcie_mem_seq extends hqm_sla_pcie_base_seq;

  `ovm_sequence_utils(hqm_sla_pcie_mem_seq,sla_sequencer)
  sla_ral_reg csr_bar_reg;
  sla_ral_reg func_pf_bar_reg;
  bit inject_error;

  function new(string name = "hqm_sla_pcie_mem_seq");
    super.new(name);
    inject_error = $test$plusargs("HQM_PCIE_MEM_ACCESS_ERR");
  endfunction

  virtual task body();
    csr_bar_reg = hqm_system_csr_regs.INGRESS_ALARM_ENABLE;
    func_pf_bar_reg = hqm_msix_mem_regs.MSG_DATA[0];

    // ----------------------------------------------------------------- //
    // -- Send writes to registers within each BAR with non-reset val -- //
    // ----------------------------------------------------------------- //
    wr_inv_rst_val(csr_bar_reg);
    wr_inv_rst_val(func_pf_bar_reg);
    // ----------------------------------------------------------------- //

    // ----------------------------------------------------------------- //
    // -- Send reads to compare the value written                   
    // ----------------------------------------------------------------- //
    read_compare_rw(csr_bar_reg    , ~csr_bar_reg.get_reset_val());
    read_compare_rw(func_pf_bar_reg, ~func_pf_bar_reg.get_reset_val());
    // ----------------------------------------------------------------- //

    // ------------------------------------------------------------------------------- //
    // -- Send back to back MWr pkts with diff wr_val followed by MRd to same location                    
    // -- check that last written value is read back                   
    // ------------------------------------------------------------------------------- //
    begin
        int mwr_val; bit rslt;
        for(int i=0; i<100; i++)  begin  mwr_val = i; send_wr(hqm_msix_mem_regs.MSG_DATA[1], mwr_val); end 
        read_compare(hqm_msix_mem_regs.MSG_DATA[1], mwr_val, .result(rslt));
    end 
    // ------------------------------------------------------------------------------- //

    if(inject_error) inject_err();

  endtask

  task inject_err();  
      // ----------------------------------------------------------------- //
      // -- Disable MSE for PF                 
      // ----------------------------------------------------------------- //
      pf_cfg_regs.DEVICE_COMMAND.write_fields(status,{"MEM"},{1'b_0},primary_id,this,.sai(legal_sai));
  
      // ----------------------------------------------------------------- //
      // -- Send writes to registers within each BAR with reset val -- //
      // ----------------------------------------------------------------- //
      send_wr(csr_bar_reg,     csr_bar_reg.get_reset_val()    );
      send_wr(func_pf_bar_reg, func_pf_bar_reg.get_reset_val());
      // ----------------------------------------------------------------- //
  
      // ----------------------------------------------------------------- //
      // -- Send reads to compare the value written                     -- //
      // ----------------------------------------------------------------- //
      send_rd(csr_bar_reg    , .ur(1));
      send_rd(func_pf_bar_reg, .ur(1));
      // ----------------------------------------------------------------- //
  
      // ----------------------------------------------------------------- //
      // -- Enable MSE for PF                 
      // ----------------------------------------------------------------- //
      pf_cfg_regs.DEVICE_COMMAND.write_fields(status,{"MEM"},{1'b_1},primary_id,this,.sai(legal_sai));
  
      // ----------------------------------------------------------------- //
      // -- Send reads to compare the value written                   
      // ----------------------------------------------------------------- //
      read_compare_rw(csr_bar_reg    , ~csr_bar_reg.get_reset_val());
      read_compare_rw(func_pf_bar_reg, ~func_pf_bar_reg.get_reset_val());
      // ----------------------------------------------------------------- //
  
      // ----------------------------------------------------------------- //
      // -- Send writes to registers within each BAR with reset val -- //
      // ----------------------------------------------------------------- //
      send_wr(csr_bar_reg,     csr_bar_reg.get_reset_val()    );
      send_wr(func_pf_bar_reg, func_pf_bar_reg.get_reset_val());
      // ----------------------------------------------------------------- //
  
      // ----------------------------------------------------------------- //
      // -- Send reads to compare the value written                     -- //
      // ----------------------------------------------------------------- //
      read_compare_rw(csr_bar_reg    , csr_bar_reg.get_reset_val());
      read_compare_rw(func_pf_bar_reg, func_pf_bar_reg.get_reset_val());
      // ----------------------------------------------------------------- //
  
      // ----------------------------------------------------------------- //
      // -- Send reads to compare the value written                   
      // ----------------------------------------------------------------- //
      read_compare_rw(csr_bar_reg    , csr_bar_reg.get_reset_val());
      read_compare_rw(func_pf_bar_reg, func_pf_bar_reg.get_reset_val());
      // ----------------------------------------------------------------- //
  
      // ----------------------------------------------------------------- //
      // -- Send writes to registers within each BAR with non-reset val -- //
      // ----------------------------------------------------------------- //
      wr_inv_rst_val(csr_bar_reg);
      wr_inv_rst_val(func_pf_bar_reg);
      // ----------------------------------------------------------------- //
  
      // ----------------------------------------------------------------- //
      // -- Send reads to compare the value written                   
      // ----------------------------------------------------------------- //
      read_compare_rw(csr_bar_reg    , ~csr_bar_reg.get_reset_val());
      read_compare_rw(func_pf_bar_reg, ~func_pf_bar_reg.get_reset_val());
      // ----------------------------------------------------------------- //
  
      // ----------------------------------------------------------------- //
      // -- Send writes to registers within each BAR with reset val     -- //
      // ----------------------------------------------------------------- //
      send_wr(csr_bar_reg,     csr_bar_reg.get_reset_val()    );
      send_wr(func_pf_bar_reg, func_pf_bar_reg.get_reset_val());
      // ----------------------------------------------------------------- //
  
      // ----------------------------------------------------------------- //
      // -- Send reads to compare the value written                   
      // ----------------------------------------------------------------- //
      read_compare_rw(csr_bar_reg    , csr_bar_reg.get_reset_val());
      read_compare_rw(func_pf_bar_reg, func_pf_bar_reg.get_reset_val());
      // ----------------------------------------------------------------- //

  endtask

endclass

`endif
