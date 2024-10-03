//----------------------------------------------------------------------
// Intel Proprietary -- Copyright 2009 Intel -- All rights reserved
//----------------------------------------------------------------------
// NOTE: Log history is at end of file.
//----------------------------------------------------------------------
//
//    FILENAME    : stap_params_include.inc
//    DESIGNER    : Sunjiv Sachan
//    PROJECT     : sTAP
//    PURPOSE     : sTAP Parameters
//    sTAP VERSION: 10ww44.1-v1.4.097
//    DESCRIPTION :
//       This is a parameter file. Please refer MAS for more details.
//----------------------------------------------------------------------
//    PARAMETERS  :
//
//    STAP3_NUMBER_OF_MANDATORY_REGISTERS
//       This parameter represents all the mandatory registers that are present in
//       STAP3_STAP. Refer to Table 3-2 on page 33 of latest HAS
//
//    STAP3_NUMBER_OF_BITS_FOR_SLICE
//       This is local parameter used for our internal computation (as 16 bit field
//       representation is used in compound parameters)
//
//    STAP3_SIZE_OF_EACH_INSTRUCTION
//       This specifies the Size of the IR
//
//    STAP3_ENABLE_VERCODE
//       The value of 1 will enable the inclusion of vercode as the 4 MSBs of the idcode,
//       else all the 32 bits will be inputted from idcode
//
//    STAP3_ENABLE_PRELOAD
//       This will enable the PRELOAD register
//
//    STAP3_NUMBER_OF_PRELOAD_REGISTERS
//       This parameter will specify the number of PRELOAD
//       Registers that exist in STAP3_STAP (Usually its value is 1).
//
//    STAP3_ENABLE_CLAMP
//       This will enable the CLAMP register
//
//    STAP3_NUMBER_OF_CLAMP_REGISTERS
//       This parameter will specify the number of CLAMP Registers that exist in
//       STAP3_STAP (Usually its value is 1).
//
//    STAP3_ENABLE_INTEST
//       This will enable the INTEST register
//
//    STAP3_NUMBER_OF_INTEST_REGISTERS
//       This parameter will specify the number of INTEST Registers that
//       exist in STAP3_STAP (Usually its value is 1).
//
//    STAP3_ENABLE_RUNBIST
//       This will enable the RUNBIST register
//
//    STAP3_NUMBER_OF_RUNBIST_REGISTERS = 0
//       This parameter will specify the number of RUNBIST Registers that
//       exist in STAP3_STAP (Usually its value is 1).
//
//    STAP3_ENABLE_EXTEST_TOGGLE
//       This will enable the EXTEST_TOGGLE register
//
//    STAP3_NUMBER_OF_EXTEST_TOGGLE_REGISTERS
//       This parameter will specify the number of EXTEST_TOGGLE Registers
//       that exist in STAP3_STAP (Usually its value is 1).
//
//    STAP3_ENABLE_TAP_NETWORK
//       This parameter will enable the inclusion of TAPNETWORK logic in the STAP3_STAP design
//
//    STAP3_ENABLE_TAPC_SEC_SEL
//       This parameter will enable the inclusion of optional SECONDARY SELECT
//       register for TAPNETWORK logic in STAP3_STAP design
//
//    STAP3_NUMBER_OF_TAP_NETWORK_REGISTERS
//       This parameter should get the same value as that of STAP3_ENABLE_TAPC_SEC_SEL parameter
//
//    STAP3_NUMBER_OF_TAPS_IN_TAP_NETWORK
//       This parameter specifies the number of TAPs that could be present
//       in a TAPNETWORK. This includes the number of STAP3_STAPs and numbers of
//       WTAPs that become part of TAPNETWORK (This doesn't include the WTAPs
//       of a separate WTAP network that could sit) on a STAP3_STAP
//
//    STAP3_ENABLE_WTAP_NETWORK
//       A value of 1 on this parameter enable the generation of logic that is
//       required to directly connect a WTAPNETWORK to the STAP3_STAP
//
//    STAP3_NUMBER_OF_WTAP_NETWORK_REGISTERS
//       This parameter should get the same value as that of STAP3_ENABLE_WTAP_NETWORK parameter
//
//    STAP3_NUMBER_OF_WTAPS_IN_NETWORK
//       This parameter specifies the number of WTAPs that could be present in a
//       WTAPNETWORK (This doesn't include the WTAPs that are going to be part of
//       TAPNETWORK that could sit) on a STAP3_STAP
//
//    STAP3_WTAP_NETWORK_ONE_FOR_SERIES_ZERO_FOR_PARALLEL
//       This parameter will help us to identify whether the WTAPs on
//       a WTAPNETWORK are connected serially or parallely. Also this helps in
//       generation of necessary control signals for serial or parallel
//       stitching of WTAPs in the WTAPNETWORK
//
//    STAP3_ENABLE_TAPC_VISAOVR
//       This parameter enables the inclusion of VISA_SELECT_OVERRIDE Register
//       in STAP3_STAP. The value of this parameter is fixed at 1 as VISA_SELECT_OVERRIDE
//       register is always present in STAP3_STAP, it is not a mandatory register though.
//
//    STAP3_NUMBER_OF_TAPC_VISAOVR_REGISTERS
//       This parameter specifies the number of VISA_SELECT_OVERRIDE Register
//       that are present in STAP3_STAP
//
//    STAP3_SIZE_OF_TAPC_VISAOVR
//       This parameter specifies the width of that VISA_SELECT_OVERRIDE Register
//
//    STAP3_ENABLE_TEST_DATA_REGISTERS
//       This parameter enables the inclusion of User-Defined Optional TEST DATA
//       Registers in the STAP3_STAP
//
//    STAP3_NUMBER_OF_TEST_DATA_REGISTERS
//       This parameter specifies the number of User-Defined Optional TEST DATA
//       Registers that are present in the STAP3_STAP
//
//    STAP3_SIZE_OF_TOTAL_TEST_DATA_REGISTERS
//       This parameter specifies the combined total widths of all the User-Defined Optional
//       TEST DATA Registers that are present in the STAP3_STAP
//
//    STAP3_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS
//       This is local parameter used for lint error removal
//
//    STAP3_NUMBER_OF_OPTIONAL_TEST_DATA_REGISTERS
//       This is local parameter used for lint error removal
//
//    STAP3_NUMBER_OF_TOTAL_REGISTERS
//       This is local parameter used to calculate the total number of register
//       that could be present in STAP3_STAP
//
//    STAP3_INSTRUCTION_FOR_DATA_REGISTERS
//       This parameter provides the instruction opcode for all the registers
//       (mandatory + optional) that are present in the STAP3_STAP
//
//    STAP3_SIZE_OF_EACH_TEST_DATA_REGISTER
//       This parameter provides the width of each User-Defined Optional
//       TEST DATA Registers
//
//    STAP3_MSB_VALUES_OF_TEST_DATA_REGISTERS
//       This parameter provides the MSB bit position for each of the User-Defined
//       Optional TEST DATA Registers
//
//    STAP3_LSB_VALUES_OF_TEST_DATA_REGISTERS
//       This parameter provides the LSB bit position for each of the User-Defined
//       Optional TEST DATA Registers
//
//    STAP3_RESET_VALUES_OF_TEST_DATA_REGISTERS
//       This parameter provides the RESET values for each of the User-Defined
//       Optional TEST DATA Registers
//
//    STAP3_BIT_ZERO_FOR_READ_ONLY_ONE_FOR_READ_WRITE
//       This parameter provides the PIN or LOOPBACK values for each of the
//       User-Defined Optional TEST DATA Registers
//----------------------------------------------------------------------------------------
parameter STAP3_NUMBER_OF_BITS_FOR_SLICE = 16;
parameter STAP3_SIZE_OF_EACH_INSTRUCTION = 8;
parameter STAP3_ENABLE_VERCODE = 0;

parameter STAP3_NUMBER_OF_DFX_FEATURES_TO_SECURE = 2;
parameter STAP3_DFX_SECURE_WIDTH = 2;

parameter STAP3_ENABLE_BSCAN = 0;
parameter STAP3_NUMBER_OF_MANDATORY_REGISTERS = (STAP3_ENABLE_BSCAN == 1) ? 8 : 3;
parameter STAP3_ENABLE_PRELOAD = 0;
parameter STAP3_NUMBER_OF_PRELOAD_REGISTERS = (STAP3_ENABLE_BSCAN == 0) ? 0 : (STAP3_ENABLE_PRELOAD == 1) ? 1 : 0;
parameter STAP3_ENABLE_CLAMP = 0;
parameter STAP3_NUMBER_OF_CLAMP_REGISTERS = (STAP3_ENABLE_BSCAN == 0) ? 0 : (STAP3_ENABLE_CLAMP == 1) ? 1 : 0;
parameter STAP3_ENABLE_INTEST = 0;
parameter STAP3_NUMBER_OF_INTEST_REGISTERS = (STAP3_ENABLE_BSCAN == 0) ? 0 : (STAP3_ENABLE_INTEST == 1) ? 1 : 0;
parameter STAP3_ENABLE_RUNBIST = 0;
parameter STAP3_NUMBER_OF_RUNBIST_REGISTERS = (STAP3_ENABLE_BSCAN == 0) ? 0 : (STAP3_ENABLE_RUNBIST == 1) ? 1 : 0;
parameter STAP3_ENABLE_EXTEST_TOGGLE = 0;
parameter STAP3_NUMBER_OF_EXTEST_TOGGLE_REGISTERS = (STAP3_ENABLE_BSCAN == 0) ? 0 : (STAP3_ENABLE_EXTEST_TOGGLE == 1) ? 1 : 0;

parameter STAP3_ENABLE_TAP_NETWORK = 0;
parameter STAP3_ENABLE_LINEAR_NETWORK = 0;
parameter STAP3_NUMBER_OF_TAP_SELECT_REGISTERS = (STAP3_ENABLE_TAP_NETWORK == 1) ? 1 : 0;
parameter STAP3_ENABLE_TAPC_SEC_SEL = 0;
parameter STAP3_NUMBER_OF_TAP_NETWORK_REGISTERS = (STAP3_ENABLE_TAPC_SEC_SEL == 1) ? 1 : 0;
parameter STAP3_NUMBER_OF_TAPS_IN_TAP_NETWORK = 0;

parameter STAP3_ENABLE_WTAP_NETWORK = 0;
parameter STAP3_NUMBER_OF_WTAP_NETWORK_REGISTERS = (STAP3_ENABLE_WTAP_NETWORK == 1) ? 1 : 0;
parameter STAP3_NUMBER_OF_WTAPS_IN_NETWORK =  0;
parameter STAP3_WTAP_NETWORK_ONE_FOR_SERIES_ZERO_FOR_PARALLEL = 0;

parameter STAP3_ENABLE_TAPC_VISAOVR = 0;
parameter STAP3_DEPTH_OF_TAPC_VISAOVR_REGISTERS = 0;
parameter STAP3_SIZE_OF_TAPC_VISAOVR = 0;

parameter STAP3_ENABLE_TAPC_REMOVE = 0;
parameter STAP3_NUMBER_OF_TAPC_REMOVE_REGISTERS = (STAP3_ENABLE_TAPC_REMOVE == 1) ? 1 : 0;
parameter STAP3_SIZE_OF_TAPC_REMOVE = 0;

parameter STAP3_ENABLE_REMOTE_TEST_DATA_REGISTERS = 0;
parameter STAP3_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS  = 0;
parameter STAP3_ENABLE_SYNCHRONIZER_FOR_REMOTE_TDR = 32'b0;

parameter STAP3_ENABLE_TEST_DATA_REGISTERS =  1;
parameter STAP3_NUMBER_OF_TEST_DATA_REGISTERS = 2;
parameter STAP3_SIZE_OF_TOTAL_TEST_DATA_REGISTERS =  64;
parameter STAP3_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS = STAP3_SIZE_OF_TOTAL_TEST_DATA_REGISTERS == 0 ? 1 : STAP3_SIZE_OF_TOTAL_TEST_DATA_REGISTERS;
parameter STAP3_NUMBER_OF_OPTIONAL_TEST_DATA_REGISTERS = STAP3_NUMBER_OF_TEST_DATA_REGISTERS == 0 ? 1 : STAP3_NUMBER_OF_TEST_DATA_REGISTERS;

parameter STAP3_NUMBER_OF_TOTAL_REGISTERS  =
   STAP3_NUMBER_OF_MANDATORY_REGISTERS     +
   STAP3_NUMBER_OF_PRELOAD_REGISTERS       +
   STAP3_NUMBER_OF_CLAMP_REGISTERS         +
   STAP3_NUMBER_OF_INTEST_REGISTERS        +
   STAP3_NUMBER_OF_RUNBIST_REGISTERS       +
   STAP3_NUMBER_OF_EXTEST_TOGGLE_REGISTERS +
   STAP3_NUMBER_OF_TAP_SELECT_REGISTERS    +
   STAP3_NUMBER_OF_TAP_NETWORK_REGISTERS   +
   STAP3_NUMBER_OF_WTAP_NETWORK_REGISTERS  +
   STAP3_ENABLE_TAPC_VISAOVR               +
   STAP3_NUMBER_OF_TAPC_REMOVE_REGISTERS   +
   STAP3_NUMBER_OF_TEST_DATA_REGISTERS     +
   STAP3_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS ;

parameter [((STAP3_SIZE_OF_EACH_INSTRUCTION * STAP3_NUMBER_OF_TOTAL_REGISTERS) - 1):0] STAP3_INSTRUCTION_FOR_DATA_REGISTERS = {
8'hA4,
8'h34,
8'h0C,
{STAP3_SIZE_OF_EACH_INSTRUCTION{1'b0}},
{STAP3_SIZE_OF_EACH_INSTRUCTION{1'b1}}
};
parameter [((STAP3_NUMBER_OF_BITS_FOR_SLICE * STAP3_NUMBER_OF_OPTIONAL_TEST_DATA_REGISTERS) - 1):0] STAP3_SIZE_OF_EACH_TEST_DATA_REGISTER = {
16'd32,
16'd32
};
parameter [((STAP3_NUMBER_OF_BITS_FOR_SLICE * STAP3_NUMBER_OF_OPTIONAL_TEST_DATA_REGISTERS) - 1):0] STAP3_MSB_VALUES_OF_TEST_DATA_REGISTERS = {
16'd63,
16'd31
};
parameter [((STAP3_NUMBER_OF_BITS_FOR_SLICE * STAP3_NUMBER_OF_OPTIONAL_TEST_DATA_REGISTERS) - 1):0] STAP3_LSB_VALUES_OF_TEST_DATA_REGISTERS = {
16'd32,
16'd0
};
parameter [(STAP3_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS - 1):0] STAP3_RESET_VALUES_OF_TEST_DATA_REGISTERS = {
32'h0,
32'h0
};
parameter [(STAP3_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS - 1):0] STAP3_BIT_ONE_FOR_TDRDATAIN_ZERO_FOR_TDRDATAOUT = {
32'h0,
32'h0
};
