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
//    FILENAME    : DfxSecurePlugin_TbDefines.sv
//    CREATED BY  : Sudheer V Bandana
//    PROJECT     : DfxSecurePlugin
//    PURPOSE     : Package file for the ENV
//    DESCRIPTION : Includes all the files in the ENV
//----------------------------------------------------------------------

`ifndef INC_DfxSecurePlugin_TbDefines
`define INC_DfxSecurePlugin_TbDefines

// DfxSecurePlugin abbreviated to DSP
`ifndef DSP_TB_PARAMS_DECL
`define DSP_TB_PARAMS_DECL \
    parameter \
    TB_DFX_NUM_OF_FEATURES_TO_SECURE    = 1,\
    TB_DFX_SECURE_WIDTH                 = 4,\
    TB_DFX_USE_SB_OVR                   = 0,\
    TB_CLK_PERIOD                       = 10ns
`endif

`ifndef DSP_TB_PARAMS_INST
`define DSP_TB_PARAMS_INST \
    .TB_DFX_NUM_OF_FEATURES_TO_SECURE (TB_DFX_NUM_OF_FEATURES_TO_SECURE),\
    .TB_DFX_SECURE_WIDTH              (TB_DFX_SECURE_WIDTH),\
    .TB_DFX_USE_SB_OVR                (TB_DFX_USE_SB_OVR),\
    .TB_CLK_PERIOD                    (TB_CLK_PERIOD)
`endif

`endif // INC_DfxSecurePlugin_TbDefines
