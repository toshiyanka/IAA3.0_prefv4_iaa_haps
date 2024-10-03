// -----------------------------------------------------------------------------
// INTEL CONFIDENTIAL
// Copyright (2017) (2017) Intel Corporation All Rights Reserved. 
// The source code contained or described herein and all documents related to
// the source code ("Material") are owned by Intel Corporation or its suppliers
// or licensors. Title to the Material remains with Intel Corporation or its
// suppliers and licensors. The Material contains trade secrets and proprietary
// and confidential information of Intel or its suppliers and licensors. The
// Material is protected by worldwide copyright and trade secret laws and 
// treaty provisions. No part of the Material may be used, copied, reproduced,
// modified, published, uploaded, posted, transmitted, distributed, or disclosed
// in any way without Intel's prior express written permission.
//
// No license under any patent, copyright, trade secret or other intellectual 
// property right is granted to or conferred upon you by disclosure or delivery
// of the Materials, either expressly, by implication, inducement, estoppel or
// otherwise. Any license under such intellectual property rights must be 
// express and approved by Intel in writing.
// -----------------------------------------------------------------------------
// File   : hqm_pasid_variation_seq.sv
//
// Description :
//
// -----------------------------------------------------------------------------
`ifndef HQM_PASID_VARIATION_SEQ__SV
`define HQM_PASID_VARIATION_SEQ__SV

class hqm_pasid_variation_seq extends hqm_sla_pcie_base_seq;
  `ovm_sequence_utils(hqm_pasid_variation_seq,sla_sequencer)


  function new(string name = "hqm_pasid_variation_seq");
    super.new(name);
  endfunction

  virtual task body();
     bit [31:0] write_data1;
     bit [31:0] write_data2;
     bit [22:0] pasid_prefix;
    
     pasid_prefix = $urandom(); 

     write_data1 =$urandom();
     write_data2 =$urandom();

     hqm_msix_mem_regs.MSG_DATA[0].write(status,write_data1[31:0],primary_id);
     hqm_system_csr_regs.LDB_CQ_PASID[0].write(status,{9'h0,write_data1[22:0]},primary_id);

     // set pasid_enable=0
     pf_cfg_regs.PASID_CONTROL.write(status,16'h0,primary_id);
     read_compare(pf_cfg_regs.PASID_CONTROL,16'h0,16'h0001,result);

     // Send MWr with PASID TLP prefix & expect transaction to be dropped
     send_wr(hqm_msix_mem_regs.MSG_DATA[0], .with_pasid(1), .d(write_data2[31:0]));
     read_compare(hqm_msix_mem_regs.MSG_DATA[0], write_data1[31:0],32'hffff_ffff,result);

     send_rd(hqm_msix_mem_regs.MSG_DATA[0], .with_pasid(1), .ur(1));
     read_compare(hqm_msix_mem_regs.MSG_DATA[0], write_data1[31:0],32'hffff_ffff,result);
     //send_tlp(get_tlp(ral.get_addr_val(primary_id, hqm_msix_mem_regs.MSG_DATA[0]), Iosf::MRd64), .compare(1), .comp_val(write_data1[31:0]));

     // set pasid_enable=1
     pf_cfg_regs.PASID_CONTROL.write(status,16'h1,primary_id);
     read_compare(pf_cfg_regs.PASID_CONTROL,16'h1,16'h0001,result);

     read_compare(hqm_msix_mem_regs.MSG_DATA[0], write_data1[31:0],32'hffff_ffff,result);
     //send_tlp(get_tlp(ral.get_addr_val(primary_id, hqm_msix_mem_regs.MSG_DATA[0]), Iosf::MRd64), .compare(1), .comp_val(write_data1[31:0]));

     pasid_prefix[22] = 1'b1;
     send_tlp(get_tlp(ral.get_addr_val(primary_id, hqm_msix_mem_regs.MSG_DATA[0]), Iosf::MRd64, .i_pasidtlp(pasid_prefix)), .compare(1), .comp_val(write_data1[31:0]));


  endtask
 
endclass

`endif 
