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
// File   : hqm_sequences_pkg.sv
// Author : Mike Betker
//
// Description :
//
// Package contains all sequence files. New sequences will be added here.
//------------------------------------------------------------------------------



`ifndef HQM_SEQ_PKG
  `define HQM_SEQ_PKG

  package hqm_sequences_pkg;
   `include "vip_layering_macros.svh"

   `import_base(ovm_pkg::*)
   `include_base("ovm_macros.svh")

   `import_base(sla_pkg::*)
   `include_base("sla_macros.svh")

   
   `import_base(hcw_transaction_pkg::*)
   `import_mid(hcw_pkg::*)
   `import_base(hqm_cfg_seq_pkg::*)
   `import_base(hqm_integ_pkg::*)

`ifdef HQM_INCLUDE_NON_PORTABLE_SEQ

`endif

   endpackage
`endif //HQM_SEQ_PKG
