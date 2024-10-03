//----------------------------------------------------------------------
// Intel Proprietary -- Copyright 2020 Intel -- All rights reserved
//----------------------------------------------------------------------
// NOTE: Log history is at end of file.
//----------------------------------------------------------------------
//
//    FILENAME    : MTAP0_params_include.inc
//    DESIGNER    : Rakesh Kandula
//    PROJECT     : CLTAP
//    PURPOSE     : MTAP Parameters
//    DESCRIPTION :
//       This is a parameter file. Please refer to MAS for more details.
//----------------------------------------------------------------------
//    PARAMETERS  :
//----------------------------------------------------------------------
//    MTAP0_ENABLE_VERCODE
//       This specifies ftap_vercode pins to be used with SLVIDCODE. If VERCODE is set to 1 four msb bits are used from ftap_vercode strap input pins. Possible values for this paramters are 0 or 1.
//
//    MTAP0_ENABLE_WTAP_NETWORK
//       This parameter should be set if WTAP_NETWORK is present along with CLTAP. Possible values for this paramters are 0 or 1.
//
//    MTAP0_ENABLE_TAP_NETWORK
//       This parameter should be set if SLAVE_TAP_NETWORK is present along with CLTAP. Possible values for this paramters are 0 or 1.
//
//    MTAP0_ENABLE_TEST_DATA_REGISTERS
//       This parameter will enable the addition or deletion of the user-defined optional TEST DATA registers in CLTAP. If the
//       value of this parameter is set to 1 then the user-defined optional TEST DATA registers are present in the CLTAP and the
//       values of NUMBER_OF_OPTIONAL_REGISTERS & TOTAL_WIDTH_OF_OPTIONAL_REGISTERS parameters should be set to proper
//       values, else it will be absent in CLTAP and the values of NUMBER_OF_OPTIONAL_REGISTERS &
//       TOTAL_WIDTH_OF_OPTIONAL_REGISTERS parameters should be set to 0.
//
//    MTAP0_ENABLE_CLTAPC_VISAOVR
//       This parameter will enable the addition or deletion of the optional VISA SELECT register in WTAP. If the value of this
//       parameter is set to 1 then the optional VISA SELECT register is present in the CLTAP and the values of
//       MTAP0_NUMBER_OF_CLTAPC_VISAOVR_REGISTERS & MTAP0_WIDTH_OF_VISA_SEL_OVERRIDE_REGISTER parameters should be set to proper values,
//       else it will be absent in CLTAP and the values of MTAP0_NUMBER_OF_CLTAPC_VISAOVR_REGISTERS & MTAP0_WIDTH_OF_VISA_SEL_OVERRIDE_REGISTER
//       parameters should be set to 0. Possible values for this paramters are 0 or 1.

//    MTAP0_NUMBER_OF_MANDATORY_REGISTERS
//       This parameter specifies the number of mandatory registers in CLTAP. This is not a user definable parameter
//       and its value is fixed to 2, as BYPASS and SLVIDCODE are the only mandatory registers in CLTAP. All other registers are optional.
//
//    MTAP0_NUMBER_OF_BITS_FOR_SLICE
//       This parameter is used as a reference to generate and identify widths of all the register in CLTAP. This is not a
//       user definable parameter and its value is fixed at 16.
//
//    MTAP0_SIZE_OF_EACH_INSTRUCTION
//       This parameter specifies the width of instruction register in CLTAP. 
//
//    MTAP0_NUMBER_OF_TAP_NETWORK_REGISTERS
//       This parameter is used to calculate the total number of registers. This is not user configurable parameter.
//
//    MTAP0_NUMBER_OF_WTAP_NETWORK_REGISTERS
//       This parameter is used to calculate the total number of registers. This is not user configurable parameter.
//
//    MTAP0_NUMBER_OF_CLTAPC_VISAOVR_REGISTERS
//       This parameter is used to calculate the total number of registers. This is not user configurable parameter.
//
//    MTAP0_NUMBER_OF_TAPS_IN_TAP_NETWORK
//       This parameter specifies the width of register atap_secsel, tapc_select and tapc_select_ovr.
//
//    MTAP0_NUMBER_OF_WTAPS_IN_NETWORK
//       This specifies numbers of WTAPs in network. This parameter specifies the width of register atap_wtapnw_selectwir.
//
//    MTAP0_NUMBER_OF_TEST_DATA_REGISTERS
//       This specifies the number of test data registers in CLTAP. This parameter is used to calculate the total number of registers.
//
//    MTAP0_NUMBER_OF_OPTIONAL_TEST_DATA_REGISTERS
//       This specifies number of optional data registers in CLTAP.
//
//    MTAP0_SIZE_OF_VISA_SEL_OVERRIDE
//       This specifies the width of VISA_SEL_OVERRIDE register.
//
//    MTAP0_SIZE_OF_TOTAL_TEST_DATA_REGISTERS
//       This specifies the width of total test data resgisters.
//
//    MTAP0_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS
//       This specifies the width of total test data resgisters. This is not user configurable parameter.
//
//    MTAP0_NUMBER_OF_TOTAL_REGISTERS
//       This specifies the total number of registers in CLTAP. This is addition of NUMBER_OF_VISA_SEL_OVERRIDE_REGISTERS, NUMBER_OF_OPTIONAL_DATA_REGISTERS, NUMBER_OF_WTAP_NETWORK_REGISTERS, NUMBER_OF_SLAVE_TAP_NETWORK_REGISTERS and NUMBER_OF_MANDATORY_REGISTERS. This is not user configurable parameter.
//
//    MTAP0_SIZE_OF_EACH_TEST_DATA_REGISTER
//       This specifies width of each optional test data registers. Sum of all the width should be equal to TOTAL_DATA_REGISTER_SIZE.
//
//    MTAP0_INSTRUCTION_FOR_DATA_REGISTERS
//       This specifies the addresses (instructions) for each of the regiters in CLTAP.
//
//    MTAP0_MSB_VALUES_OF_TEST_DATA_REGISTERS
//       This specifies the MSB value of each optional test data register in CLTAP. Bit widths are equal to MTAP0_NUMBER_OF_BITS_FOR_SLICE.
//
//    MTAP0_LSB_VALUES_OF_TEST_DATA_REGISTERS
//       This specifies the LSB value of each optional test data register in CLTAP. Bit widths are equal to MTAP0_NUMBER_OF_BITS_FOR_SLICE.
//
//    MTAP0_RESET_VALUES_OF_TEST_DATA_REGISTERS
//       This specifies the reset values of each optional test data register in CLTAP. Bit widths equal to the width of each test data register.
//
//    MTAP0_BIT_ONE_FOR_TDRDATAIN_ZERO_FOR_TDRDATAOUT
//       This specifies each bit as readonly or read/write. Bit widths equal to the width of each test data register.
//----------------------------------------------------------------------------------------
parameter MTAP0_NUMBER_OF_MANDATORY_REGISTERS = 10;
parameter MTAP0_NUMBER_OF_BITS_FOR_SLICE = 16;
parameter MTAP0_SIZE_OF_EACH_INSTRUCTION = 8;
parameter MTAP0_ENABLE_VERCODE = 0;

parameter MTAP0_NUMBER_OF_DFX_FEATURES_TO_SECURE = 2;
parameter MTAP0_DFX_SECURE_WIDTH = 2;

parameter MTAP0_ENABLE_PRELOAD = 0;
parameter MTAP0_NUMBER_OF_PRELOAD_REGISTERS = (MTAP0_ENABLE_PRELOAD == 1) ? 1 : 0;
parameter MTAP0_ENABLE_CLAMP = 0;
parameter MTAP0_NUMBER_OF_CLAMP_REGISTERS = (MTAP0_ENABLE_CLAMP == 1) ? 1 : 0;
parameter MTAP0_ENABLE_USERCODE = 0;
parameter MTAP0_NUMBER_OF_USERCODE_REGISTERS = (MTAP0_ENABLE_USERCODE == 1) ? 1 : 0;
parameter MTAP0_ENABLE_INTEST = 0;
parameter MTAP0_NUMBER_OF_INTEST_REGISTERS = (MTAP0_ENABLE_INTEST == 1) ? 1 : 0;
parameter MTAP0_ENABLE_RUNBIST = 0;
parameter MTAP0_NUMBER_OF_RUNBIST_REGISTERS = (MTAP0_ENABLE_RUNBIST == 1) ? 1 : 0;
parameter MTAP0_ENABLE_EXTEST_TOGGLE = 0;
parameter MTAP0_NUMBER_OF_EXTEST_TOGGLE_REGISTERS = (MTAP0_ENABLE_EXTEST_TOGGLE == 1) ? 1 : 0;

parameter MTAP0_ENABLE_TAP_NETWORK = 1;
parameter MTAP0_ENABLE_LINEAR_NETWORK = 0;
parameter MTAP0_ENABLE_CLTAPC_SEC_SEL = 1;
parameter MTAP0_NUMBER_OF_TAP_NETWORK_REGISTERS = (MTAP0_ENABLE_CLTAPC_SEC_SEL == 1) ? 1 : 0;
parameter MTAP0_NUMBER_OF_TAPS_IN_TAP_NETWORK = 6;

parameter MTAP0_ENABLE_WTAP_NETWORK = 0;
parameter MTAP0_NUMBER_OF_WTAP_NETWORK_REGISTERS = (MTAP0_ENABLE_WTAP_NETWORK == 1) ? 1 : 0;
parameter MTAP0_NUMBER_OF_WTAPS_IN_NETWORK = 0;
parameter MTAP0_WTAP_NETWORK_ONE_FOR_SERIES_ZERO_FOR_PARALLEL = 0;

parameter MTAP0_ENABLE_CLTAPC_VISAOVR = 0;
parameter MTAP0_DEPTH_OF_CLTAPC_VISAOVR_REGISTERS = 0;
parameter MTAP0_SIZE_OF_CLTAPC_VISAOVR = 0;

parameter MTAP0_ENABLE_CLTAPC_REMOVE = 1;
parameter MTAP0_NUMBER_OF_CLTAPC_REMOVE_REGISTERS = (MTAP0_ENABLE_CLTAPC_REMOVE == 1) ? 1 : 0;
parameter MTAP0_SIZE_OF_CLTAPC_REMOVE = 1;

parameter MTAP0_ENABLE_REMOTE_TEST_DATA_REGISTERS = 0;
parameter MTAP0_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS  = 0;
parameter MTAP0_ENABLE_SYNCHRONIZER_FOR_REMOTE_TDR = 32'b0;

parameter MTAP0_ENABLE_TEST_DATA_REGISTERS = 1;
parameter MTAP0_NUMBER_OF_TEST_DATA_REGISTERS = 2;
parameter MTAP0_SIZE_OF_TOTAL_TEST_DATA_REGISTERS = 64;
parameter MTAP0_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS = MTAP0_SIZE_OF_TOTAL_TEST_DATA_REGISTERS == 0 ? 1 : MTAP0_SIZE_OF_TOTAL_TEST_DATA_REGISTERS;
parameter MTAP0_NUMBER_OF_OPTIONAL_TEST_DATA_REGISTERS = MTAP0_NUMBER_OF_TEST_DATA_REGISTERS == 0 ? 1 : MTAP0_NUMBER_OF_TEST_DATA_REGISTERS;

parameter MTAP0_NUMBER_OF_TOTAL_REGISTERS  =
   MTAP0_NUMBER_OF_MANDATORY_REGISTERS     +
   MTAP0_NUMBER_OF_PRELOAD_REGISTERS       +
   MTAP0_NUMBER_OF_CLAMP_REGISTERS         +
   MTAP0_NUMBER_OF_USERCODE_REGISTERS      +
   MTAP0_NUMBER_OF_INTEST_REGISTERS        +
   MTAP0_NUMBER_OF_RUNBIST_REGISTERS       +
   MTAP0_NUMBER_OF_EXTEST_TOGGLE_REGISTERS +
   MTAP0_NUMBER_OF_TAP_NETWORK_REGISTERS   +
   MTAP0_NUMBER_OF_WTAP_NETWORK_REGISTERS  +
   MTAP0_ENABLE_CLTAPC_VISAOVR             +
   MTAP0_NUMBER_OF_CLTAPC_REMOVE_REGISTERS +
   MTAP0_NUMBER_OF_TEST_DATA_REGISTERS     +
   MTAP0_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS ;

parameter [((MTAP0_SIZE_OF_EACH_INSTRUCTION * MTAP0_NUMBER_OF_TOTAL_REGISTERS) - 1):0] MTAP0_INSTRUCTION_FOR_DATA_REGISTERS = {
8'hA0,
8'h34,
8'h14,
8'h10,
8'h12,
8'h11,
8'h0F,
8'h0E,
8'h09,
8'h08,
8'h02,
8'h01,
{MTAP0_SIZE_OF_EACH_INSTRUCTION{1'b0}},
{MTAP0_SIZE_OF_EACH_INSTRUCTION{1'b1}}
};
parameter [((MTAP0_NUMBER_OF_BITS_FOR_SLICE * MTAP0_NUMBER_OF_OPTIONAL_TEST_DATA_REGISTERS) - 1):0] MTAP0_SIZE_OF_EACH_TEST_DATA_REGISTER = {
16'd32,
16'd32
};
parameter [((MTAP0_NUMBER_OF_BITS_FOR_SLICE * MTAP0_NUMBER_OF_OPTIONAL_TEST_DATA_REGISTERS) - 1):0] MTAP0_MSB_VALUES_OF_TEST_DATA_REGISTERS = {
16'd63,
16'd31
};
parameter [((MTAP0_NUMBER_OF_BITS_FOR_SLICE * MTAP0_NUMBER_OF_OPTIONAL_TEST_DATA_REGISTERS) - 1):0] MTAP0_LSB_VALUES_OF_TEST_DATA_REGISTERS = {
16'd32,
16'd0
};
parameter [(MTAP0_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS - 1):0] MTAP0_RESET_VALUES_OF_TEST_DATA_REGISTERS = {
32'h0,
32'h0
};
parameter [(MTAP0_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS - 1):0] MTAP0_BIT_ONE_FOR_TDRDATAIN_ZERO_FOR_TDRDATAOUT = {
32'h0,
32'h0
};
