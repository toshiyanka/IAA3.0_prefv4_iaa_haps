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
//    STAP2_NUMBER_OF_MANDATORY_REGISTERS
//       This parameter represents all the mandatory registers that are present in
//       STAP2_STAP. Refer to Table 3-2 on page 33 of latest HAS
//
//    STAP2_NUMBER_OF_BITS_FOR_SLICE
//       This is local parameter used for our internal computation (as 16 bit field
//       representation is used in compound parameters)
//
//    STAP2_SIZE_OF_EACH_INSTRUCTION
//       This specifies the Size of the IR
//
//    STAP2_ENABLE_VERCODE
//       The value of 1 will enable the inclusion of vercode as the 4 MSBs of the idcode,
//       else all the 32 bits will be inputted from idcode
//
//    STAP2_ENABLE_PRELOAD
//       This will enable the PRELOAD register
//
//    STAP2_NUMBER_OF_PRELOAD_REGISTERS
//       This parameter will specify the number of PRELOAD
//       Registers that exist in STAP2_STAP (Usually its value is 1).
//
//    STAP2_ENABLE_CLAMP
//       This will enable the CLAMP register
//
//    STAP2_NUMBER_OF_CLAMP_REGISTERS
//       This parameter will specify the number of CLAMP Registers that exist in
//       STAP2_STAP (Usually its value is 1).
//
//    STAP2_ENABLE_INTEST
//       This will enable the INTEST register
//
//    STAP2_NUMBER_OF_INTEST_REGISTERS
//       This parameter will specify the number of INTEST Registers that
//       exist in STAP2_STAP (Usually its value is 1).
//
//    STAP2_ENABLE_RUNBIST
//       This will enable the RUNBIST register
//
//    STAP2_NUMBER_OF_RUNBIST_REGISTERS = 0
//       This parameter will specify the number of RUNBIST Registers that
//       exist in STAP2_STAP (Usually its value is 1).
//
//    STAP2_ENABLE_EXTEST_TOGGLE
//       This will enable the EXTEST_TOGGLE register
//
//    STAP2_NUMBER_OF_EXTEST_TOGGLE_REGISTERS
//       This parameter will specify the number of EXTEST_TOGGLE Registers
//       that exist in STAP2_STAP (Usually its value is 1).
//
//    STAP2_ENABLE_TAP_NETWORK
//       This parameter will enable the inclusion of TAPNETWORK logic in the STAP2_STAP design
//
//    STAP2_ENABLE_TAPC_SEC_SEL
//       This parameter will enable the inclusion of optional SECONDARY SELECT
//       register for TAPNETWORK logic in STAP2_STAP design
//
//    STAP2_NUMBER_OF_TAP_NETWORK_REGISTERS
//       This parameter should get the same value as that of STAP2_ENABLE_TAPC_SEC_SEL parameter
//
//    STAP2_NUMBER_OF_TAPS_IN_TAP_NETWORK
//       This parameter specifies the number of TAPs that could be present
//       in a TAPNETWORK. This includes the number of STAP2_STAPs and numbers of
//       WTAPs that become part of TAPNETWORK (This doesn't include the WTAPs
//       of a separate WTAP network that could sit) on a STAP2_STAP
//
//    STAP2_ENABLE_WTAP_NETWORK
//       A value of 1 on this parameter enable the generation of logic that is
//       required to directly connect a WTAPNETWORK to the STAP2_STAP
//
//    STAP2_NUMBER_OF_WTAP_NETWORK_REGISTERS
//       This parameter should get the same value as that of STAP2_ENABLE_WTAP_NETWORK parameter
//
//    STAP2_NUMBER_OF_WTAPS_IN_NETWORK
//       This parameter specifies the number of WTAPs that could be present in a
//       WTAPNETWORK (This doesn't include the WTAPs that are going to be part of
//       TAPNETWORK that could sit) on a STAP2_STAP
//
//    STAP2_WTAP_NETWORK_ONE_FOR_SERIES_ZERO_FOR_PARALLEL
//       This parameter will help us to identify whether the WTAPs on
//       a WTAPNETWORK are connected serially or parallely. Also this helps in
//       generation of necessary control signals for serial or parallel
//       stitching of WTAPs in the WTAPNETWORK
//
//    STAP2_ENABLE_TAPC_VISAOVR
//       This parameter enables the inclusion of VISA_SELECT_OVERRIDE Register
//       in STAP2_STAP. The value of this parameter is fixed at 1 as VISA_SELECT_OVERRIDE
//       register is always present in STAP2_STAP, it is not a mandatory register though.
//
//    STAP2_NUMBER_OF_TAPC_VISAOVR_REGISTERS
//       This parameter specifies the number of VISA_SELECT_OVERRIDE Register
//       that are present in STAP2_STAP
//
//    STAP2_SIZE_OF_TAPC_VISAOVR
//       This parameter specifies the width of that VISA_SELECT_OVERRIDE Register
//
//    STAP2_ENABLE_TEST_DATA_REGISTERS
//       This parameter enables the inclusion of User-Defined Optional TEST DATA
//       Registers in the STAP2_STAP
//
//    STAP2_NUMBER_OF_TEST_DATA_REGISTERS
//       This parameter specifies the number of User-Defined Optional TEST DATA
//       Registers that are present in the STAP2_STAP
//
//    STAP2_SIZE_OF_TOTAL_TEST_DATA_REGISTERS
//       This parameter specifies the combined total widths of all the User-Defined Optional
//       TEST DATA Registers that are present in the STAP2_STAP
//
//    STAP2_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS
//       This is local parameter used for lint error removal
//
//    STAP2_NUMBER_OF_OPTIONAL_TEST_DATA_REGISTERS
//       This is local parameter used for lint error removal
//
//    STAP2_NUMBER_OF_TOTAL_REGISTERS
//       This is local parameter used to calculate the total number of register
//       that could be present in STAP2_STAP
//
//    STAP2_INSTRUCTION_FOR_DATA_REGISTERS
//       This parameter provides the instruction opcode for all the registers
//       (mandatory + optional) that are present in the STAP2_STAP
//
//    STAP2_SIZE_OF_EACH_TEST_DATA_REGISTER
//       This parameter provides the width of each User-Defined Optional
//       TEST DATA Registers
//
//    STAP2_MSB_VALUES_OF_TEST_DATA_REGISTERS
//       This parameter provides the MSB bit position for each of the User-Defined
//       Optional TEST DATA Registers
//
//    STAP2_LSB_VALUES_OF_TEST_DATA_REGISTERS
//       This parameter provides the LSB bit position for each of the User-Defined
//       Optional TEST DATA Registers
//
//    STAP2_RESET_VALUES_OF_TEST_DATA_REGISTERS
//       This parameter provides the RESET values for each of the User-Defined
//       Optional TEST DATA Registers
//
//    STAP2_BIT_ZERO_FOR_READ_ONLY_ONE_FOR_READ_WRITE
//       This parameter provides the PIN or LOOPBACK values for each of the
//       User-Defined Optional TEST DATA Registers
//----------------------------------------------------------------------------------------
parameter STAP2_NUMBER_OF_BITS_FOR_SLICE = 16;
parameter STAP2_SIZE_OF_EACH_INSTRUCTION = 8;
parameter STAP2_ENABLE_VERCODE = 0;

parameter STAP2_NUMBER_OF_DFX_FEATURES_TO_SECURE = 2;
parameter STAP2_DFX_SECURE_WIDTH = 2;

parameter STAP2_ENABLE_BSCAN = 0;
parameter STAP2_NUMBER_OF_MANDATORY_REGISTERS = (STAP2_ENABLE_BSCAN == 1) ? 8 : 3;
parameter STAP2_ENABLE_PRELOAD = 0;
parameter STAP2_NUMBER_OF_PRELOAD_REGISTERS = (STAP2_ENABLE_BSCAN == 0) ? 0 : (STAP2_ENABLE_PRELOAD == 1) ? 1 : 0;
parameter STAP2_ENABLE_CLAMP = 0;
parameter STAP2_NUMBER_OF_CLAMP_REGISTERS = (STAP2_ENABLE_BSCAN == 0) ? 0 : (STAP2_ENABLE_CLAMP == 1) ? 1 : 0;
parameter STAP2_ENABLE_INTEST = 0;
parameter STAP2_NUMBER_OF_INTEST_REGISTERS = (STAP2_ENABLE_BSCAN == 0) ? 0 : (STAP2_ENABLE_INTEST == 1) ? 1 : 0;
parameter STAP2_ENABLE_RUNBIST = 0;
parameter STAP2_NUMBER_OF_RUNBIST_REGISTERS = (STAP2_ENABLE_BSCAN == 0) ? 0 : (STAP2_ENABLE_RUNBIST == 1) ? 1 : 0;
parameter STAP2_ENABLE_EXTEST_TOGGLE = 0;
parameter STAP2_NUMBER_OF_EXTEST_TOGGLE_REGISTERS = (STAP2_ENABLE_BSCAN == 0) ? 0 : (STAP2_ENABLE_EXTEST_TOGGLE == 1) ? 1 : 0;

parameter STAP2_ENABLE_TAP_NETWORK = 1;
parameter STAP2_ENABLE_LINEAR_NETWORK = 0;
parameter STAP2_NUMBER_OF_TAP_SELECT_REGISTERS = (STAP2_ENABLE_TAP_NETWORK == 1) ? 1 : 0;
parameter STAP2_ENABLE_TAPC_SEC_SEL = 1;
parameter STAP2_NUMBER_OF_TAP_NETWORK_REGISTERS = (STAP2_ENABLE_TAPC_SEC_SEL == 1) ? 1 : 0;
parameter STAP2_NUMBER_OF_TAPS_IN_TAP_NETWORK = 4;

parameter STAP2_ENABLE_WTAP_NETWORK = 0;
parameter STAP2_NUMBER_OF_WTAP_NETWORK_REGISTERS = (STAP2_ENABLE_WTAP_NETWORK == 1) ? 1 : 0;
parameter STAP2_NUMBER_OF_WTAPS_IN_NETWORK =  0;
parameter STAP2_WTAP_NETWORK_ONE_FOR_SERIES_ZERO_FOR_PARALLEL = 0;

parameter STAP2_ENABLE_TAPC_VISAOVR = 0;
parameter STAP2_DEPTH_OF_TAPC_VISAOVR_REGISTERS = 0;
parameter STAP2_SIZE_OF_TAPC_VISAOVR = 0;

parameter STAP2_ENABLE_TAPC_REMOVE = 0;
parameter STAP2_NUMBER_OF_TAPC_REMOVE_REGISTERS = (STAP2_ENABLE_TAPC_REMOVE == 1) ? 1 : 0;
parameter STAP2_SIZE_OF_TAPC_REMOVE = 0;

parameter STAP2_ENABLE_REMOTE_TEST_DATA_REGISTERS = 0;
parameter STAP2_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS  = 0;
parameter STAP2_ENABLE_SYNCHRONIZER_FOR_REMOTE_TDR = 32'b0;

parameter STAP2_ENABLE_TEST_DATA_REGISTERS =  1;
parameter STAP2_NUMBER_OF_TEST_DATA_REGISTERS = 2;
parameter STAP2_SIZE_OF_TOTAL_TEST_DATA_REGISTERS =  64;
parameter STAP2_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS = STAP2_SIZE_OF_TOTAL_TEST_DATA_REGISTERS == 0 ? 1 : STAP2_SIZE_OF_TOTAL_TEST_DATA_REGISTERS;
parameter STAP2_NUMBER_OF_OPTIONAL_TEST_DATA_REGISTERS = STAP2_NUMBER_OF_TEST_DATA_REGISTERS == 0 ? 1 : STAP2_NUMBER_OF_TEST_DATA_REGISTERS;

parameter STAP2_NUMBER_OF_TOTAL_REGISTERS  =
   STAP2_NUMBER_OF_MANDATORY_REGISTERS     +
   STAP2_NUMBER_OF_PRELOAD_REGISTERS       +
   STAP2_NUMBER_OF_CLAMP_REGISTERS         +
   STAP2_NUMBER_OF_INTEST_REGISTERS        +
   STAP2_NUMBER_OF_RUNBIST_REGISTERS       +
   STAP2_NUMBER_OF_EXTEST_TOGGLE_REGISTERS +
   STAP2_NUMBER_OF_TAP_SELECT_REGISTERS    +
   STAP2_NUMBER_OF_TAP_NETWORK_REGISTERS   +
   STAP2_NUMBER_OF_WTAP_NETWORK_REGISTERS  +
   STAP2_ENABLE_TAPC_VISAOVR               +
   STAP2_NUMBER_OF_TAPC_REMOVE_REGISTERS   +
   STAP2_NUMBER_OF_TEST_DATA_REGISTERS     +
   STAP2_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS ;

parameter [((STAP2_SIZE_OF_EACH_INSTRUCTION * STAP2_NUMBER_OF_TOTAL_REGISTERS) - 1):0] STAP2_INSTRUCTION_FOR_DATA_REGISTERS = {
8'hA3,
8'h34,
8'h10,
8'h11,
8'h0C,
{STAP2_SIZE_OF_EACH_INSTRUCTION{1'b0}},
{STAP2_SIZE_OF_EACH_INSTRUCTION{1'b1}}
};
parameter [((STAP2_NUMBER_OF_BITS_FOR_SLICE * STAP2_NUMBER_OF_OPTIONAL_TEST_DATA_REGISTERS) - 1):0] STAP2_SIZE_OF_EACH_TEST_DATA_REGISTER = {
16'd32,
16'd32
};
parameter [((STAP2_NUMBER_OF_BITS_FOR_SLICE * STAP2_NUMBER_OF_OPTIONAL_TEST_DATA_REGISTERS) - 1):0] STAP2_MSB_VALUES_OF_TEST_DATA_REGISTERS = {
16'd63,
16'd31
};
parameter [((STAP2_NUMBER_OF_BITS_FOR_SLICE * STAP2_NUMBER_OF_OPTIONAL_TEST_DATA_REGISTERS) - 1):0] STAP2_LSB_VALUES_OF_TEST_DATA_REGISTERS = {
16'd32,
16'd0
};
parameter [(STAP2_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS - 1):0] STAP2_RESET_VALUES_OF_TEST_DATA_REGISTERS = {
32'h0,
32'h0
};
parameter [(STAP2_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS - 1):0] STAP2_BIT_ONE_FOR_TDRDATAIN_ZERO_FOR_TDRDATAOUT = {
32'h0,
32'h0
};
