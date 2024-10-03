//----------------------------------------------------------------------
// Intel Proprietary -- Copyright 2019 Intel -- All rights reserved
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
    TB_DFX_USE_SB_OVR                   = 1,\
    time TB_CLK_PERIOD                       = 10ns
`endif

`ifndef DSP_TB_PARAMS_INST
`define DSP_TB_PARAMS_INST \
    .TB_DFX_NUM_OF_FEATURES_TO_SECURE (TB_DFX_NUM_OF_FEATURES_TO_SECURE),\
    .TB_DFX_SECURE_WIDTH              (TB_DFX_SECURE_WIDTH),\
    .TB_DFX_USE_SB_OVR                (TB_DFX_USE_SB_OVR),\
    .TB_CLK_PERIOD                    (TB_CLK_PERIOD)
`endif

`endif // INC_DfxSecurePlugin_TbDefines
