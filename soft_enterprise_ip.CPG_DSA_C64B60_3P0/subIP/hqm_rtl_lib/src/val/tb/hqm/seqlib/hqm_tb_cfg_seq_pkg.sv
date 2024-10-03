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
// File   : hqm_tb_cfg_seq_pkg.sv
// Author : Mike Betker
//
// Description :
//
// Package contains all sequence files. New sequences will be added here.
//------------------------------------------------------------------------------



`ifndef HQM_TB_CFG_SEQ_PKG
`define HQM_TB_CFG_SEQ_PKG
   package hqm_tb_cfg_seq_pkg;
      import ovm_pkg::*;
      `include "ovm_macros.svh"
      import sla_pkg::*;
      `include "sla_macros.svh"
   
      import IosfPkg::*;
    //import hqm_rndcfg_pkg::*;    
    import hqm_saola_pkg::*;
   `import_base(hcw_transaction_pkg::*)
   `import_mid(hcw_pkg::*)
   `import_base(hqm_cfg_seq_pkg::*)
   `import_base(hqm_integ_pkg::*)

   `import_mid(pcie_seqlib_pkg::*)
   `import_mid(hqm_tb_sequences_pkg::*)
   `import_base(hqm_reset_sequences_pkg::*)

`ifdef HQM_INCLUDE_NON_PORTABLE_SEQ
      `include_typ("hqm_tb_cfg_seq.sv")
`endif

   endpackage
`endif //HQM_TB_CFG_SEQ_PKG
