//------------------------------------------------------------------------------
//  INTEL CONFIDENTIAL
//
//  Copyright 2019 Intel Corporation All Rights Reserved.
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
//  Collateral Description:
//  dteg-stap
//
//  Source organization:
//  DTEG Engineering Group (DTEG)
//
//  Support Information:
//  HSD: https://hsdes.intel.com/appstore/article/#/dft_services.bugeco/create
//
//  Revision:
//  DTEG_sTAP_2020WW05_RTL1P0_PIC6_V1
//
//  Module <module name> :  < put your functional description here in plain text >
//
//------------------------------------------------------------------------------

//----------------------------------------------------------------------
// Intel Proprietary -- Copyright 2019 Intel -- All rights reserved
//----------------------------------------------------------------------
// NOTE: Log history is at end of file.
//----------------------------------------------------------------------
//
//    FILENAME    : STapPkg.sv
//    DESIGNER    : Sudheer V Bandana
//    PROJECT     : sTAP
//
//    PURPOSE     : Package file for the ENV
//    DESCRIPTION : Includes all the file in the ENV
//----------------------------------------------------------------------

package STapPkg;

    import uvm_pkg::*;
    import ovm_pkg::*;
    import xvm_pkg::*;
    import sla_pkg::*;
    //import UPF::*;
    `include "ovm_macros.svh"
    `include "xvm_macros.svh"
    `include "sla_macros.svh"

`ifdef USE_CONVERGED_JTAGBFM
    import dfx_tap_env_pkg::*;
    import dfx_tap_seqlib_pkg::*;
    import DfxSecurePlugin_Pkg::*;
    
    `include "tb_param.inc"
    `include "STAP_DfxSecurePlugin_TbDefines.svh"

    `include "dfx_env.sv"

    `include "STapVifContainer.sv"

    `include "STapInMonSbrPkt.sv"
    `include "STapInputMonitor.sv"
    `include "STapOutMonSbrPkt.sv"
    `include "STapOutputMonitor.sv"

    `include "STapScoreBoard.sv"

    `include "STapSequences_Converged.sv"
    `include "STapEnv_Converged.sv"
    `include "STapReportComponent.sv"
`else
    import JtagBfmPkg::*;
    import DfxSecurePlugin_Pkg::*;

    `include "tb_param.inc"
    `include "STAP_DfxSecurePlugin_TbDefines.svh"

    `include "STapVifContainer.sv"

    `include "STapInMonSbrPkt.sv"
    `include "STapInputMonitor.sv"
    `include "STapOutMonSbrPkt.sv"
    `include "STapOutputMonitor.sv"

    `include "STapScoreBoard.sv"
    `include "STapCoverage.sv"

    `include "STapEnv.sv"
    `include "STapSequences.sv"
    `include "STapReportComponent.sv"
`endif

endpackage
