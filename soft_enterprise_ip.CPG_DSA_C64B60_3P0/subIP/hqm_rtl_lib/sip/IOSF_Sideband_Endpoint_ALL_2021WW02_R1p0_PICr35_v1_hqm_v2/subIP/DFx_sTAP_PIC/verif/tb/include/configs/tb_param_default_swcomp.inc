//----------------------------------------------------------------------
// Intel Proprietary -- Copyright 2019 Intel -- All rights reserved
//----------------------------------------------------------------------
// NOTE: Log history is at end of file.
//----------------------------------------------------------------------
//
//    FILENAME    : tb_param.inc
//    DESIGNER    : Sudheer V Bandana
//    PROJECT     : sTAP
//    PURPOSE     : sTAP TB Parameters
//    REVISION    : 2016WW28_RTL1P0_V1
//    DESCRIPTION :
//      This is a TB parameter file. Please refer IG for more details.
//    PARAMETERS  :
//    CLOCK_PERIOD                         : To Configure the Clock Period
//    SIZE_OF_IR_REG_STAP                  : Size of the Instruction REGISTER
//    STAP_NUMBER_OF_SLAVE_TAPS_IN_NETWORK : Number of Slave Tap present in the TAP Network
//    STAP_NUMBER_OF_WTAPS_IN_NETWORK      : Number of WTAP present in the TAP Network
//    STAP_NUMBER_OF_TAPS                  : Number of Taps present in the TAP Network
//    NO_OF_RW_REG                         : Number of registers in the TAP
//                                           This includes: TAP Network registers,
//                                           Optional Register
//                                           It does NOT include : Mandatory Register
//    TOTAL_DATA_REGISTER_WIDTH            : Sum of the register width of al the register
//                                           except Mandatory Register
//    BYPASS_TRANS_WIDTH                   : This the number of transaction that user wants
//                                           to carry out in Bypass state.
//    RO_REGISTER_WIDTH                    : Width of Register which do not have parallel Data in
//    RW_REG_ADDR                          : This defines the address for all the RW registers
//    RW_REG_WIDTH                         : This defines the width for all the RW registers
//    TB_DATA_REGISTER_RESET_VALUES        : This defines the Reset value of all the RW registers
//    TB_LOAD_PIN_OR_NOT_LOOPBACK          : This parameter is a per-bit value used to specify whether
//                                           the each bit of the iTDR captures a fixed value (from tdr_data_in bus)
//                                           or the recirculated value coming from the corresponding bit
//                                           of tdr_data_out bus
//----------------------------------------------------------------------

//----------------------------------------------------------------------
//--------------------FIXED PARAMETER DO NOT CHANGE---------------------
//----------------------------------------------------------------------
//If there are Multiple TAP in the ENV the value is 1
//(e.g WTAP or TAP NW ENV) Else 0 (STAP ENV)
parameter MULTIPLE_TAP         = 0;
parameter NO_OF_SLAVE_TAP      = 1;
parameter IDCODE_WIDTH         = 32;
//----------------------------------------------------------------------
//--------------------------USER AREA-----------------------------------
//----------------------------------------------------------------------
parameter CLOCK_PERIOD                         = 10000;
parameter LENGTH_OF_BSCAN_CHAIN                = 3;
parameter SIZE_OF_IR_REG_STAP                  = 8;
parameter STAP_EN_TAP_NETWORK                  = 0;
parameter STAP_NUM_OF_TAPS_IN_TAP_NETWORK      = 0;
parameter NUM_OF_DFX_FEATURES_TO_SECURE        = 3;
parameter DFX_SECURE_WIDTH                     = 4;
parameter STAP_SWCOMP_ACTIVE                   = 1;
parameter STAP_SWCOMP_NUM_OF_COMPARE_BITS      = 10;
parameter STAP_SUPPRESS_UPDATE_CAPTURE          = 0;
parameter STAP_NO_OF_TAPS_IN_TAP_NETWORK       = 1;
parameter STAP_WIDTH_OF_SEC_SEL_REG_IN_STAP    = 0;
parameter STAP_EN_WTAP_NETWORK                 = 0;
parameter STAP_NUMBER_OF_WTAPS_IN_WTAP_NETWORK = 0;
parameter STAP_WTAP_NETWORK_SERIES_OR_PARALLEL = 0;
parameter STAP_NO_OF_WTAPS_IN_WTAP_NETWORK     = 1;
parameter STAP_NUM_OF_WTAPS_IN_WTAP_NETWORK    = 0;
parameter NO_OF_RW_REG                         = 2;
parameter TOTAL_DATA_REGISTER_WIDTH            = 121;
parameter BYPASS_TRANS_WIDTH                   = 3;
parameter RO_REGISTER_WIDTH                    = 86;
parameter TB_STAP_SECURE_GREEN                 = 2'b00;
parameter TB_STAP_SECURE_ORANGE                = 2'b01;
parameter TB_STAP_SECURE_RED                   = 2'b10;
parameter STAP_NUM_OF_ITDRS                    = 0;
parameter STAP_WTAPCTRL_RESET_VALUE            = 0;

parameter [(SIZE_OF_IR_REG_STAP*NO_OF_RW_REG)-1:0] RW_REG_ADDR = {
8'h21, //Opcode Address for SWCOMP_STAT
8'h20 //Opcode Address for SWCOMP_CTRL
};
parameter [(2*NO_OF_RW_REG)-1:0] RW_REG_COLOR = {
TB_STAP_SECURE_GREEN,  //Opcode Color for SWCOMP_STAT
TB_STAP_SECURE_GREEN  //Opcode Color for SWCOMP_CTRL
};
parameter [(16*NO_OF_SLAVE_TAP)-1:0]CON_NO_OF_DR_REG_STAP = {
16'd2
};
parameter [(16*NO_OF_RW_REG)-1:0] RW_REG_WIDTH = {
16'd43,
16'd43
};
parameter [(TOTAL_DATA_REGISTER_WIDTH - 1):0] TB_DATA_REGISTER_RESET_VALUES = {
43'd0,
43'd0
};
parameter [TOTAL_DATA_REGISTER_WIDTH - 1:0] TB_LOAD_PIN_OR_NOT_LOOPBACK = {
43'd0,
43'd0
};
parameter NO_PARALLEL_OUT_BIT_WIDTH = 86;
//----------------------------------------------------------------------
//--------------------FIXED PARAMETER DO NOT CHANGE---------------------
//----------------------------------------------------------------------
parameter SIZE_OF_IR_REG = (NO_OF_SLAVE_TAP * SIZE_OF_IR_REG_STAP);
//----------------------------------------------------------------------------------------
//--------------------REMOTE TDR PARAMS---------------------------------
parameter TB_REMOTE_TDR_ENABLE     = 0;
parameter TB_NO_OF_REMOTE_TDR      = 0;
parameter TB_NO_OF_REMOTE_TDR_NZ   = 1;
parameter TB_RTDR_IS_BUSSED_NZ     = 1;

parameter TB_SIZE_OF_REMOTE_TDR    = 0;
parameter TB_DISABLE_MISC_DRIVE    = 0;

// DfxSecurePlugin abbreviated to DSP
`ifndef STAP_DSP_TB_PARAMS_DECL
`define STAP_DSP_TB_PARAMS_DECL \
    parameter \
    TB_DFX_NUM_OF_FEATURES_TO_SECURE    = 3,\
    TB_DFX_SECURE_WIDTH                 = 4,\
    TB_DFX_USE_SB_OVR                   = 0,\
    TB_CLK_PERIOD                       = 10ns
`endif

`ifndef STAP_DSP_TB_PARAMS_INST
`define STAP_DSP_TB_PARAMS_INST \
    .TB_DFX_NUM_OF_FEATURES_TO_SECURE (TB_DFX_NUM_OF_FEATURES_TO_SECURE),\
    .TB_DFX_SECURE_WIDTH              (TB_DFX_SECURE_WIDTH),\
    .TB_DFX_USE_SB_OVR                (TB_DFX_USE_SB_OVR),\
    .TB_CLK_PERIOD                    (TB_CLK_PERIOD)
`endif

`ifndef SOC_JTAG_IF_PARAMS_INST
 `define SOC_PRI_JTAG_IF_PARAMS_INST   .CLOCK_PERIOD (10000), .PWRGOOD_SRC (0), .CLK_SRC (0)
`endif
