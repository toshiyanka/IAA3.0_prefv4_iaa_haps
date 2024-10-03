//----------------------------------------------------------------------
// Intel Proprietary -- Copyright 2009 Intel -- All rights reserved
//----------------------------------------------------------------------
// NOTE: Log history is at end of file.
//----------------------------------------------------------------------
//
//    FILENAME    : stap_params_include.inc
//    DESIGNER    : Sunjiv Sachan
//    PROJECT     : sTAP
//    
//    
//    PURPOSE     : sTAP Parameters
//    DESCRIPTION :
//       This is a parameter file. Please refer MAS for more details.
//----------------------------------------------------------------------
//    PARAMETERS  :
//
//    STAP_NUMBER_OF_MANDATORY_REGISTERS
//       This parameter represents all the mandatory registers that are present in
//       STAP. Refer to Table 3-2 on page 33 of latest HAS
//
//    STAP_NUMBER_OF_BITS_FOR_SLICE
//       This is local parameter used for our internal computation (as 16 bit field
//       representation is used in compound parameters)
//
//    STAP_SIZE_OF_EACH_INSTRUCTION
//       This specifies the Size of the IR
//
//    STAP_ENABLE_VERCODE
//       The value of 1 will enable the inclusion of vercode as the 4 MSBs of the idcode,
//       else all the 32 bits will be inputted from idcode
//
//    STAP_ENABLE_PRELOAD
//       This will enable the PRELOAD register
//
//    STAP_NUMBER_OF_PRELOAD_REGISTERS
//       This parameter will specify the number of PRELOAD
//       Registers that exist in STAP (Usually its value is 1).
//
//    STAP_ENABLE_CLAMP
//       This will enable the CLAMP register
//
//    STAP_NUMBER_OF_CLAMP_REGISTERS
//       This parameter will specify the number of CLAMP Registers that exist in
//       STAP (Usually its value is 1).
//
//    STAP_ENABLE_USERCODE
//       This will enable the USERCODE register
//
//    STAP_NUMBER_OF_USERCODE_REGISTERS
//       This parameter will specify the number of
//       USERCODE Registers that exist in STAP (Usually its value is 1).
//
//    STAP_ENABLE_INTEST
//       This will enable the INTEST register
//
//    STAP_NUMBER_OF_INTEST_REGISTERS
//       This parameter will specify the number of INTEST Registers that
//       exist in STAP (Usually its value is 1).
//
//    STAP_ENABLE_RUNBIST
//       This will enable the RUNBIST register
//
//    STAP_NUMBER_OF_RUNBIST_REGISTERS = 0
//       This parameter will specify the number of RUNBIST Registers that
//       exist in STAP (Usually its value is 1).
//
//    STAP_ENABLE_EXTEST_TOGGLE
//       This will enable the EXTEST_TOGGLE register
//
//    STAP_NUMBER_OF_EXTEST_TOGGLE_REGISTERS
//       This parameter will specify the number of EXTEST_TOGGLE Registers
//       that exist in STAP (Usually its value is 1).
//
//    STAP_ENABLE_TAP_NETWORK
//       This parameter will enable the inclusion of TAPNETWORK logic in the STAP design
//
//    STAP_ENABLE_TAPC_SEC_SEL
//       This parameter will enable the inclusion of optional SECONDARY SELECT
//       register for TAPNETWORK logic in STAP design
//
//    STAP_NUMBER_OF_TAP_NETWORK_REGISTERS
//       This parameter should get the same value as that of STAP_ENABLE_TAPC_SEC_SEL parameter
//
//    STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK
//       This parameter specifies the number of TAPs that could be present
//       in a TAPNETWORK. This includes the number of STAPs and numbers of
//       WTAPs that become part of TAPNETWORK (This doesn't include the WTAPs
//       of a separate WTAP network that could sit) on a STAP
//
//    STAP_ENABLE_LINEAR_NETWORK
//       A value of 1 on this parameter enable the generation of logic that
//       is required to directly connect a single WTAP to the STAP
//
//    STAP_ENABLE_WTAP_NETWORK
//       A value of 1 on this parameter enable the generation of logic that is
//       required to directly connect a WTAPNETWORK to the STAP
//
//    STAP_NUMBER_OF_WTAP_NETWORK_REGISTERS
//       This parameter should get the same value as that of STAP_ENABLE_WTAP_NETWORK parameter
//
//    STAP_NUMBER_OF_WTAPS_IN_NETWORK
//       This parameter specifies the number of WTAPs that could be present in a
//       WTAPNETWORK (This doesn't include the WTAPs that are going to be part of
//       TAPNETWORK that could sit) on a STAP
//
//    STAP_WTAP_NETWORK_ONE_FOR_SERIES_ZERO_FOR_PARALLEL
//       This parameter will help us to identify whether the WTAPs on
//       a WTAPNETWORK are connected serially or parallely. Also this helps in
//       generation of necessary control signals for serial or parallel
//       stitching of WTAPs in the WTAPNETWORK
//
//    STAP_ENABLE_TAPC_VISAOVR
//       This parameter enables the inclusion of VISA_SELECT_OVERRIDE Register
//       in STAP. The value of this parameter is fixed at 1 as VISA_SELECT_OVERRIDE
//       register is always present in STAP, it is not a mandatory register though.
//
//    STAP_NUMBER_OF_TAPC_VISAOVR_REGISTERS
//       This parameter specifies the number of VISA_SELECT_OVERRIDE Register
//       that are present in STAP
//
//    STAP_SIZE_OF_TAPC_VISAOVR
//       This parameter specifies the width of that VISA_SELECT_OVERRIDE Register
//
//    STAP_ENABLE_TEST_DATA_REGISTERS
//       This parameter enables the inclusion of User-Defined Optional TEST DATA
//       Registers in the STAP
//
//    STAP_NUMBER_OF_TEST_DATA_REGISTERS
//       This parameter specifies the number of User-Defined Optional TEST DATA
//       Registers that are present in the STAP
//
//    STAP_SIZE_OF_TOTAL_TEST_DATA_REGISTERS
//       This parameter specifies the combined total widths of all the User-Defined Optional
//       TEST DATA Registers that are present in the STAP
//
//    STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS
//       This is local parameter used for lint error removal
//
//    STAP_NUMBER_OF_OPTIONAL_TEST_DATA_REGISTERS
//       This is local parameter used for lint error removal
//
//    STAP_NUMBER_OF_TOTAL_REGISTERS
//       This is local parameter used to calculate the total number of register
//       that could be present in STAP
//
//    STAP_INSTRUCTION_FOR_DATA_REGISTERS
//       This parameter provides the instruction opcode for all the registers
//       (mandatory + optional) that are present in the STAP
//
//    STAP_SIZE_OF_EACH_TEST_DATA_REGISTER
//       This parameter provides the width of each User-Defined Optional
//       TEST DATA Registers
//
//    STAP_MSB_VALUES_OF_TEST_DATA_REGISTERS
//       This parameter provides the MSB bit position for each of the User-Defined
//       Optional TEST DATA Registers
//
//    STAP_LSB_VALUES_OF_TEST_DATA_REGISTERS
//       This parameter provides the LSB bit position for each of the User-Defined
//       Optional TEST DATA Registers
//
//    STAP_RESET_VALUES_OF_TEST_DATA_REGISTERS
//       This parameter provides the RESET values for each of the User-Defined
//       Optional TEST DATA Registers
//
//    STAP_BIT_ZERO_FOR_READ_ONLY_ONE_FOR_READ_WRITE
//       This parameter provides the PIN or LOOPBACK values for each of the
//       User-Defined Optional TEST DATA Registers
//----------------------------------------------------------------------------------------
parameter STAP_ENABLE_BSCAN = 1,
parameter STAP_NUMBER_OF_MANDATORY_REGISTERS = (STAP_ENABLE_BSCAN == 1) ? 8 : 3,
parameter STAP_NUMBER_OF_BITS_FOR_SLICE = 16,
parameter STAP_SIZE_OF_EACH_INSTRUCTION = 16,
parameter STAP_ENABLE_VERCODE = 1,
parameter STAP_NUMBER_OF_DFX_FEATURES_TO_SECURE = 3,
parameter STAP_DFX_SECURE_WIDTH = 3,
parameter STAP_ENABLE_PRELOAD = 1,
parameter STAP_NUMBER_OF_PRELOAD_REGISTERS = (STAP_ENABLE_BSCAN == 0) ? 0 : (STAP_ENABLE_PRELOAD == 1) ? 1 : 0,
parameter STAP_ENABLE_CLAMP = 1,
parameter STAP_NUMBER_OF_CLAMP_REGISTERS = (STAP_ENABLE_BSCAN == 0) ? 0 : (STAP_ENABLE_CLAMP == 1) ? 1 : 0,
//parameter STAP_ENABLE_USERCODE = 1,
//parameter STAP_NUMBER_OF_USERCODE_REGISTERS = (STAP_ENABLE_BSCAN == 0) ? 0 : (STAP_ENABLE_USERCODE == 1) ? 1 : 0,
parameter STAP_ENABLE_INTEST = 1,
parameter STAP_NUMBER_OF_INTEST_REGISTERS = (STAP_ENABLE_BSCAN == 0) ? 0 : (STAP_ENABLE_INTEST == 1) ? 1 : 0,
parameter STAP_ENABLE_RUNBIST = 1,
parameter STAP_NUMBER_OF_RUNBIST_REGISTERS = (STAP_ENABLE_BSCAN == 0) ? 0 : (STAP_ENABLE_RUNBIST == 1) ? 1 : 0,
parameter STAP_ENABLE_EXTEST_TOGGLE = 1,
parameter STAP_NUMBER_OF_EXTEST_TOGGLE_REGISTERS = (STAP_ENABLE_BSCAN == 0) ? 0 : (STAP_ENABLE_EXTEST_TOGGLE == 1) ? 1 : 0,
parameter STAP_ENABLE_TAP_NETWORK = 0,
parameter STAP_NUMBER_OF_TAP_SELECT_REGISTERS = (STAP_ENABLE_TAP_NETWORK == 1) ? 1 : 0,
parameter STAP_ENABLE_TAPC_SEC_SEL = 0,
parameter STAP_NUMBER_OF_TAP_NETWORK_REGISTERS = (STAP_ENABLE_TAPC_SEC_SEL == 1) ? 1 : 0,
parameter STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK = 0,
parameter STAP_ENABLE_LINEAR_NETWORK = 0,
parameter STAP_ENABLE_WTAP_NETWORK = 1,
parameter STAP_NUMBER_OF_WTAP_NETWORK_REGISTERS = (STAP_ENABLE_WTAP_NETWORK == 1) ? 1 : 0,
parameter STAP_NUMBER_OF_WTAPS_IN_NETWORK =  1,
parameter STAP_WTAP_NETWORK_ONE_FOR_SERIES_ZERO_FOR_PARALLEL = 0,
parameter STAP_ENABLE_TAPC_VISAOVR = 1,
parameter STAP_DEPTH_OF_TAPC_VISAOVR_REGISTERS = 1,
parameter STAP_SIZE_OF_TAPC_VISAOVR = 42,
parameter STAP_ENABLE_TAPC_REMOVE = 1,
parameter STAP_NUMBER_OF_TAPC_REMOVE_REGISTERS = (STAP_ENABLE_TAPC_REMOVE == 1) ? 1 : 0,
parameter STAP_SIZE_OF_TAPC_REMOVE = 1,
parameter STAP_ENABLE_REMOTE_TEST_DATA_REGISTERS =0,
parameter STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS = 0,
parameter STAP_ENABLE_SYNCHRONIZER_FOR_REMOTE_TDR = 0,
parameter STAP_ENABLE_TEST_DATA_REGISTERS =  1,
parameter STAP_NUMBER_OF_TEST_DATA_REGISTERS = 2,
parameter STAP_SIZE_OF_TOTAL_TEST_DATA_REGISTERS =  299,
parameter STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS = STAP_SIZE_OF_TOTAL_TEST_DATA_REGISTERS == 0 ? 1 : STAP_SIZE_OF_TOTAL_TEST_DATA_REGISTERS,
parameter STAP_NUMBER_OF_OPTIONAL_TEST_DATA_REGISTERS = STAP_NUMBER_OF_TEST_DATA_REGISTERS == 0 ? 1 : STAP_NUMBER_OF_TEST_DATA_REGISTERS,
parameter STAP_NUMBER_OF_TOTAL_REGISTERS =
   STAP_NUMBER_OF_MANDATORY_REGISTERS         +
   STAP_NUMBER_OF_PRELOAD_REGISTERS           +
   STAP_NUMBER_OF_CLAMP_REGISTERS             +
   //STAP_NUMBER_OF_USERCODE_REGISTERS          +
   STAP_NUMBER_OF_INTEST_REGISTERS            +
   STAP_NUMBER_OF_RUNBIST_REGISTERS           +
   STAP_NUMBER_OF_EXTEST_TOGGLE_REGISTERS     +
   STAP_NUMBER_OF_TAP_SELECT_REGISTERS        +
   STAP_NUMBER_OF_TAP_NETWORK_REGISTERS       +
   STAP_NUMBER_OF_WTAP_NETWORK_REGISTERS      +
   STAP_ENABLE_TAPC_VISAOVR                   +
   STAP_NUMBER_OF_TAPC_REMOVE_REGISTERS       +
   STAP_NUMBER_OF_TEST_DATA_REGISTERS         +
   STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS,
parameter [((STAP_SIZE_OF_EACH_INSTRUCTION * STAP_NUMBER_OF_TOTAL_REGISTERS) - 1):0] STAP_INSTRUCTION_FOR_DATA_REGISTERS = {
16'h6B,
16'h34,
16'h14,
16'h15,
16'h13,
16'h0D,
16'h07,
16'h06,
16'h04,
16'h03,
16'h0F,
16'h0E,
16'h0C,
16'h09,
16'h08,
16'h01,
{STAP_SIZE_OF_EACH_INSTRUCTION{1'b0}},
{STAP_SIZE_OF_EACH_INSTRUCTION{1'b1}}
},
parameter [((STAP_NUMBER_OF_BITS_FOR_SLICE * STAP_NUMBER_OF_OPTIONAL_TEST_DATA_REGISTERS) - 1):0] STAP_SIZE_OF_EACH_TEST_DATA_REGISTER = {
16'd199,
16'd100
},
parameter [((STAP_NUMBER_OF_BITS_FOR_SLICE * STAP_NUMBER_OF_OPTIONAL_TEST_DATA_REGISTERS) - 1):0] STAP_MSB_VALUES_OF_TEST_DATA_REGISTERS = {
16'd298,
16'd99
},
parameter [((STAP_NUMBER_OF_BITS_FOR_SLICE * STAP_NUMBER_OF_OPTIONAL_TEST_DATA_REGISTERS) - 1):0] STAP_LSB_VALUES_OF_TEST_DATA_REGISTERS = {
16'd100,
16'd0
},
parameter [(STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS - 1):0] STAP_RESET_VALUES_OF_TEST_DATA_REGISTERS = {
199'h0,
100'h0
},
parameter [(STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS - 1):0] STAP_BIT_ONE_FOR_TDRDATAIN_ZERO_FOR_TDRDATAOUT = {
199'h0,
100'h0
},
