//------------------------------------------------------------------------------
//  INTEL CONFIDENTIAL
//
//  Copyright 2016 Intel Corporation All Rights Reserved.
//
//  The source code contained or described herein and all documents related
//  to the source code (Material) are owned by Intel Corporation or its
//  suppliers or licensors. Title to the Material remains with Intel
//  Corporation or its suppliers and licensors. The Material contains trade
//  secrets and proprietary and confidential information of Intel or its
//  suppliers and licensors. The Material is protected by worldwide copyright
//  and trade secret laws and treaty provisions. No part of the Material may
//  be used, copied, reproduced, modified, published, uploaded, posted,
//  transmitted, distributed, or disclosed in any way without Intel's prior
//  express written permission.
//
//  No license under any patent, copyright, trade secret or other intellectual
//  property right is granted to or conferred upon you by disclosure or
//  delivery of the Materials, either expressly, by implication, inducement,
//  estoppel or otherwise. Any license under such intellectual property rights
//  must be express and approved by Intel in writing.
//
//
//  Collateral Description:
//  %header_collateral%
//
//  Source organization:
//  %header_organization%
//
//  Support Information:
//  %header_support%
//
//  Revision:
//  %header_tag%
//
//  Module <module name> :  < put your functional description here in plain text >
//
//------------------------------------------------------------------------------

//----------------------------------------------------------------------
// Intel Proprietary -- Copyright 2016 Intel -- All rights reserved
//----------------------------------------------------------------------
// NOTE: Log history is at end of file.
//----------------------------------------------------------------------
//
//    FILENAME    : DfxSecurePlugin_Pkg.sv
//    CREATED BY  : Sudheer V Bandana
//    PROJECT     : DfxSecurePlugin
//    PURPOSE     : Package file for the ENV
//    DESCRIPTION : Includes all the files in the ENV
//----------------------------------------------------------------------

`ifndef INC_DfxSecurePlugin_Pkg
`define INC_DfxSecurePlugin_Pkg

//-------------------------------------------
// TB Environment Files and UVM header files
//-------------------------------------------
package DfxSecurePlugin_Pkg;

   import uvm_pkg::*;
   `ifdef DTEG_OVM_EN
      import ovm_pkg::*;
   `endif
   `ifdef DTEG_XVM_EN
      import xvm_pkg::*;
   `endif
   `include "uvm_macros.svh"
   `ifdef DTEG_OVM_EN
       `include "ovm_macros.svh"
   `endif
   `ifdef DTEG_XVM_EN
       `include "xvm_macros.svh"
   `endif
   `include "DfxSecurePlugin_TbDefines.svh"

   `include "DfxSecurePlugin_SeqDrvTxn.sv"
   `include "DfxSecurePlugin_Seqr.sv"

   `include "DfxSecurePlugin_VifContainer.sv"

   `include "DfxSecurePlugin_InpMonTxn.sv"
   `include "DfxSecurePlugin_InpMonitor.sv"
   `include "DfxSecurePlugin_OutMonTxn.sv"
   `include "DfxSecurePlugin_OutMonitor.sv"

   `include "DfxSecurePlugin_SeqLib.sv"
   `include "DfxSecurePlugin_Driver.sv"
   `include "DfxSecurePlugin_Agent.sv"

   `include "DfxSecurePlugin_Scoreboard.sv"
   `include "DfxSecurePlugin_Coverage.sv"

   `include "DfxSecurePlugin_Env.sv"

endpackage : DfxSecurePlugin_Pkg

`endif // INC_DfxSecurePlugin_Pkg
