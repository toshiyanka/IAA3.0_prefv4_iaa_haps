//-----------------------------------------------------------------------------
// INTEL CONFIDENTIAL
// Copyright (2013) (2013) Intel Corporation All Rights Reserved. 
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
//------------------------------------------------------------------------------
// File   : hcw_sequences_pkg.sv
//
// Description :
//
// Package contains all sequence files. New sequences will be added here.
//------------------------------------------------------------------------------



`ifndef HCW_SEQ_PKG
`define HCW_SEQ_PKG
package hcw_sequences_pkg;
  `include "vip_layering_macros.svh"


  `import_base(uvm_pkg::*)
  `include_base("uvm_macros.svh")
  `import_base(sla_pkg::*)
  `include_base("sla_macros.svh")

  `import_base(sla_pkg::*)
  `include_base("slu_macros.svh")

`ifdef XVM
  `import_base(ovm_pkg::*)
  `import_base(xvm_pkg::*)
  `include_base("ovm_macros.svh")
  `include_base("sla_macros.svh")
`endif

   
  `import_mid(hcw_transaction_pkg::*)
  `import_mid(hcw_pkg::*)
  `import_mid(hqm_cfg_pkg::*)

   // Test sequences `import_mid
`ifndef HQM_IP_TB_OVM
  `include_mid("hqm_hcw_enq_seq_uvm.sv")
  `include_mid("hqm_pp_cq_base_seq_uvm.sv") 
  `include_mid("hqm_pp_cq_hqmproc_seq_uvm.sv")
`else
  `include_mid("hqm_hcw_enq_seq.sv")       // Enqueue HCW(s) using protocol sequence
  `include_mid("hqm_pp_cq_base_seq.sv")    // PP/CQ sequence : specify number of HCWs and various other generation controls
  `include_mid("hqm_pp_cq_hqmproc_seq.sv")  // PP/CQ sequence : extend from hqm_pp_cq_base_seq to support hqm_proc specific tests
`endif

endpackage
`endif //HCW_SEQ_PKG
