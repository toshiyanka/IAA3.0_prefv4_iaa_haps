//----------------------------------------------------------------------
// Intel Proprietary -- Copyright 2009 Intel -- All rights reserved
//----------------------------------------------------------------------
// NOTE: Log history is at end of file.
//----------------------------------------------------------------------
//
//    FILENAME    : mtap_params_include.inc
//    DESIGNER    : Bulusu, Shivaprashant 
//    PROJECT     : CLTAP
//    PURPOSE     : MTAP Parameters
//    VERSION     :
//    DESCRIPTION :
//       This is a parameter file. Please refer to MAS for more details.
//----------------------------------------------------------------------
//    PARAMETERS  :
//----------------------------------------------------------------------
//    MTAP_ENABLE_VERCODE
//       This specifies ftap_vercode pins to be used with SLVIDCODE. If VERCODE is set to 1 four msb bits are used from ftap_vercode strap input pins. Possible values for this paramters are 0 or 1.
//
//    MTAP_ENABLE_WTAP_NETWORK
//       This parameter should be set if WTAP_NETWORK is present along with CLTAP. Possible values for this paramters are 0 or 1.
//
//    MTAP_ENABLE_TAP_NETWORK
//       This parameter should be set if SLAVE_TAP_NETWORK is present along with CLTAP. Possible values for this paramters are 0 or 1.
//
//    MTAP_ENABLE_TEST_DATA_REGISTERS
//       This parameter will enable the addition or deletion of the user-defined optional TEST DATA registers in CLTAP. If the
//       value of this parameter is set to 1 then the user-defined optional TEST DATA registers are present in the CLTAP and the
//       values of NUMBER_OF_OPTIONAL_REGISTERS & TOTAL_WIDTH_OF_OPTIONAL_REGISTERS parameters should be set to proper
//       values, else it will be absent in CLTAP and the values of NUMBER_OF_OPTIONAL_REGISTERS &
//       TOTAL_WIDTH_OF_OPTIONAL_REGISTERS parameters should be set to 0.
//
//    MTAP_ENABLE_CLTAPC_VISAOVR
//       This parameter will enable the addition or deletion of the optional VISA SELECT register in WTAP. If the value of this
//       parameter is set to 1 then the optional VISA SELECT register is present in the CLTAP and the values of
//       MTAP_NUMBER_OF_CLTAPC_VISAOVR_REGISTERS & MTAP_WIDTH_OF_VISA_SEL_OVERRIDE_REGISTER parameters should be set to proper values,
//       else it will be absent in CLTAP and the values of MTAP_NUMBER_OF_CLTAPC_VISAOVR_REGISTERS & MTAP_WIDTH_OF_VISA_SEL_OVERRIDE_REGISTER
//       parameters should be set to 0. Possible values for this paramters are 0 or 1.
//    MTAP_NUMBER_OF_MANDATORY_REGISTERS
//       This parameter specifies the number of mandatory registers in CLTAP. This is not a user definable parameter
//       and its value is fixed to 2, as BYPASS and SLVIDCODE are the only mandatory registers in CLTAP. All other registers are optional.
//
//    MTAP_NUMBER_OF_BITS_FOR_SLICE
//       This parameter is used as a reference to generate and identify widths of all the register in CLTAP. This is not a
//       user definable parameter and its value is fixed at 16.
//
//    MTAP_SIZE_OF_EACH_INSTRUCTION
//       This parameter specifies the width of instruction register in CLTAP. 
//
//    MTAP_NUMBER_OF_TAP_NETWORK_REGISTERS
//       This parameter is used to calculate the total number of registers. This is not user configurable parameter.
//
//    MTAP_NUMBER_OF_WTAP_NETWORK_REGISTERS
//       This parameter is used to calculate the total number of registers. This is not user configurable parameter.
//
//    MTAP_NUMBER_OF_CLTAPC_VISAOVR_REGISTERS
//       This parameter is used to calculate the total number of registers. This is not user configurable parameter.
//
//    MTAP_NUMBER_OF_TAPS_IN_TAP_NETWORK
//       This parameter specifies the width of register atap_secsel, tapc_select and tapc_select_ovr.
//
//    MTAP_NUMBER_OF_WTAPS_IN_NETWORK
//       This specifies numbers of WTAPs in network. This parameter specifies the width of register atap_wtapnw_selectwir.
//
//    MTAP_NUMBER_OF_TEST_DATA_REGISTERS
//       This specifies the number of test data registers in CLTAP. This parameter is used to calculate the total number of registers.
//
//    MTAP_NUMBER_OF_OPTIONAL_TEST_DATA_REGISTERS
//       This specifies number of optional data registers in CLTAP.
//
//    MTAP_SIZE_OF_VISA_SEL_OVERRIDE
//       This specifies the width of VISA_SEL_OVERRIDE register.
//
//    MTAP_SIZE_OF_TOTAL_TEST_DATA_REGISTERS
//       This specifies the width of total test data resgisters.
//
//    MTAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS
//       This specifies the width of total test data resgisters. This is not user configurable parameter.
//
//    MTAP_NUMBER_OF_TOTAL_REGISTERS
//       This specifies the total number of registers in CLTAP. This is addition of NUMBER_OF_VISA_SEL_OVERRIDE_REGISTERS, NUMBER_OF_OPTIONAL_DATA_REGISTERS, NUMBER_OF_WTAP_NETWORK_REGISTERS, NUMBER_OF_SLAVE_TAP_NETWORK_REGISTERS and NUMBER_OF_MANDATORY_REGISTERS. This is not user configurable parameter.
//
//    MTAP_SIZE_OF_EACH_TEST_DATA_REGISTER
//       This specifies width of each optional test data registers. Sum of all the width should be equal to TOTAL_DATA_REGISTER_SIZE.
//
//    MTAP_INSTRUCTION_FOR_DATA_REGISTERS
//       This specifies the addresses (instructions) for each of the regiters in CLTAP.
//
//    MTAP_MSB_VALUES_OF_TEST_DATA_REGISTERS
//       This specifies the MSB value of each optional test data register in CLTAP. Bit widths are equal to MTAP_NUMBER_OF_BITS_FOR_SLICE.
//
//    MTAP_LSB_VALUES_OF_TEST_DATA_REGISTERS
//       This specifies the LSB value of each optional test data register in CLTAP. Bit widths are equal to MTAP_NUMBER_OF_BITS_FOR_SLICE.
//
//    MTAP_RESET_VALUES_OF_TEST_DATA_REGISTERS
//       This specifies the reset values of each optional test data register in CLTAP. Bit widths equal to the width of each test data register.
//
//    MTAP_BIT_ONE_FOR_TDRDATAIN_ZERO_FOR_TDRDATAOUT
//       This specifies each bit as readonly or read/write. Bit widths equal to the width of each test data register.
//----------------------------------------------------------------------------------------


parameter MTAP_NUMBER_OF_MANDATORY_REGISTERS=10,

parameter MTAP_NUMBER_OF_BITS_FOR_SLICE=16,

parameter MTAP_SIZE_OF_EACH_INSTRUCTION=16,

parameter MTAP_ENABLE_VERCODE=1,

parameter MTAP_NUMBER_OF_DFX_FEATURES_TO_SECURE=5,

parameter MTAP_DFX_SECURE_WIDTH=5,


parameter MTAP_ENABLE_PRELOAD=1,
parameter MTAP_NUMBER_OF_PRELOAD_REGISTERS=(MTAP_ENABLE_PRELOAD==1)?1:0,

parameter MTAP_ENABLE_CLAMP=1,
parameter MTAP_NUMBER_OF_CLAMP_REGISTERS=(MTAP_ENABLE_CLAMP==1)?1:0,

parameter MTAP_ENABLE_USERCODE=1,
parameter MTAP_NUMBER_OF_USERCODE_REGISTERS=(MTAP_ENABLE_USERCODE==1)?1:0,

parameter MTAP_ENABLE_INTEST=1,
parameter MTAP_NUMBER_OF_INTEST_REGISTERS=(MTAP_ENABLE_INTEST==1)?1:0,

parameter MTAP_ENABLE_RUNBIST=1,
parameter MTAP_NUMBER_OF_RUNBIST_REGISTERS=(MTAP_ENABLE_RUNBIST==1)?1:0,

parameter MTAP_ENABLE_EXTEST_TOGGLE=1,
parameter MTAP_NUMBER_OF_EXTEST_TOGGLE_REGISTERS=(MTAP_ENABLE_EXTEST_TOGGLE==1)?1:0,

parameter MTAP_ENABLE_TAP_NETWORK=1,
parameter MTAP_ENABLE_LINEAR_NETWORK=0,
parameter MTAP_NUMBER_OF_TAPS_IN_TAP_NETWORK=4,
parameter MTAP_ENABLE_CLTAPC_SEC_SEL=1,
parameter MTAP_NUMBER_OF_TAP_NETWORK_REGISTERS=(MTAP_ENABLE_CLTAPC_SEC_SEL==1)?1:0,

parameter MTAP_ENABLE_WTAP_NETWORK=1,
parameter MTAP_NUMBER_OF_WTAPS_IN_NETWORK=3,
parameter MTAP_WTAP_NETWORK_ONE_FOR_SERIES_ZERO_FOR_PARALLEL=0,
parameter MTAP_NUMBER_OF_WTAP_NETWORK_REGISTERS=(MTAP_ENABLE_WTAP_NETWORK==1)?1:0,

parameter MTAP_ENABLE_CLTAPC_VISAOVR=1,
parameter MTAP_DEPTH_OF_CLTAPC_VISAOVR_REGISTERS=4,
parameter MTAP_SIZE_OF_CLTAPC_VISAOVR=42,

parameter MTAP_ENABLE_CLTAPC_REMOVE=1,
parameter MTAP_SIZE_OF_CLTAPC_REMOVE=1,
parameter MTAP_NUMBER_OF_CLTAPC_REMOVE_REGISTERS=(MTAP_ENABLE_CLTAPC_REMOVE==1)?1:0,

parameter MTAP_ENABLE_REMOTE_TEST_DATA_REGISTERS=1,
parameter MTAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS=3,
parameter MTAP_ENABLE_SYNCHRONIZER_FOR_REMOTE_TDR=3'b101,

parameter MTAP_ENABLE_TEST_DATA_REGISTERS=1,
parameter MTAP_NUMBER_OF_TEST_DATA_REGISTERS=2,
parameter MTAP_SIZE_OF_TOTAL_TEST_DATA_REGISTERS=64,
parameter MTAP_NUMBER_OF_OPTIONAL_TEST_DATA_REGISTERS=(MTAP_NUMBER_OF_TEST_DATA_REGISTERS==0)?1:MTAP_NUMBER_OF_TEST_DATA_REGISTERS,
parameter MTAP_NUMBER_OF_TOTAL_REGISTERS=
	MTAP_NUMBER_OF_TEST_DATA_REGISTERS+
	MTAP_NUMBER_OF_MANDATORY_REGISTERS+
	MTAP_NUMBER_OF_PRELOAD_REGISTERS+
	MTAP_NUMBER_OF_CLAMP_REGISTERS+
	MTAP_NUMBER_OF_USERCODE_REGISTERS+
	MTAP_NUMBER_OF_INTEST_REGISTERS+
	MTAP_NUMBER_OF_RUNBIST_REGISTERS+
	MTAP_NUMBER_OF_EXTEST_TOGGLE_REGISTERS+
	MTAP_NUMBER_OF_TAP_NETWORK_REGISTERS+
	MTAP_NUMBER_OF_WTAP_NETWORK_REGISTERS+
	MTAP_ENABLE_CLTAPC_VISAOVR+
	MTAP_NUMBER_OF_CLTAPC_REMOVE_REGISTERS+
	MTAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS,
	
parameter MTAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS=(MTAP_SIZE_OF_TOTAL_TEST_DATA_REGISTERS==0)?1:MTAP_SIZE_OF_TOTAL_TEST_DATA_REGISTERS,


parameter [((MTAP_SIZE_OF_EACH_INSTRUCTION * MTAP_NUMBER_OF_TOTAL_REGISTERS) - 1):0] MTAP_INSTRUCTION_FOR_DATA_REGISTERS = {
16'h56,
16'h46,
16'h36,
16'h6B,
16'h34,
16'h14,
16'h15,
16'h13,
16'h10,
16'h0D,
16'h07,
16'h06,
16'h05,
16'h04,
16'h03,
16'h12,
16'h11,
16'h0F,
16'h0E,
16'h09,
16'h08,
16'h02,
16'h01,
{MTAP_SIZE_OF_EACH_INSTRUCTION{1'b0}},
{MTAP_SIZE_OF_EACH_INSTRUCTION{1'b1}}
},
parameter [((MTAP_NUMBER_OF_BITS_FOR_SLICE * MTAP_NUMBER_OF_OPTIONAL_TEST_DATA_REGISTERS) - 1):0] MTAP_SIZE_OF_EACH_TEST_DATA_REGISTER = {
16'd32,
16'd32
},
parameter [((MTAP_NUMBER_OF_BITS_FOR_SLICE * MTAP_NUMBER_OF_OPTIONAL_TEST_DATA_REGISTERS) - 1):0] MTAP_MSB_VALUES_OF_TEST_DATA_REGISTERS = {
16'd63,
16'd31
},
parameter [((MTAP_NUMBER_OF_BITS_FOR_SLICE * MTAP_NUMBER_OF_OPTIONAL_TEST_DATA_REGISTERS) - 1):0] MTAP_LSB_VALUES_OF_TEST_DATA_REGISTERS = {
16'd32,
16'd0
},
parameter [(MTAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS - 1):0] MTAP_RESET_VALUES_OF_TEST_DATA_REGISTERS = {
32'h99AA5566,
32'hAA556699
},
parameter [(MTAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS - 1):0] MTAP_BIT_ONE_FOR_TDRDATAIN_ZERO_FOR_TDRDATAOUT = {
32'h0,
32'hFFFF
},
