//----------------------------------------------------------------------------------------
// Intel Proprietary -- Copyright 2019 Intel -- All rights reserved
//----------------------------------------------------------------------------------------
// NOTE: Log history is at end of file
//----------------------------------------------------------------------------------------
//
//    FILENAME    : MIN_STAP_params_includeinc
//    DESIGNER    : Sudheer V Bandana
//    PROJECT     : sTAP
//    PURPOSE     : sTAP RTL Parameters
//    VERSION     : MIN_STAP_2016WW15_R15
//    DESCRIPTION :
//       This is a RTL parameter file Please refer IG for more details
//----------------------------------------------------------------------------------------
//    PARAMETERS  :
//
//    MIN_STAP_SIZE_OF_EACH_INSTRUCTION
//       This parameter specifies the width of instruction register in STAP
//
//    MIN_STAP_ENABLE_BSCAN
//       This parameter enables the Bounday scan operation in sTAP Unlike CLTAP, this
//       feature is optional in sTAP
//
//    MIN_STAP_NUMBER_OF_MANDATORY_REGISTERS
//       This parameter specifies the number of mandatory registers in STAP
//       This is not a user definable parameter and its value is fixed to either 2 or 12;
//       as BYPASS, IDCODE are the real mandatory registers, but Boundary Scan Registers
//       also get added if BSCAN is enabled in STAP All other registers are optional
//
//    MIN_STAP_SECURE_GREEN
//       Opcdes that are visible to all customers Like SLVIDCODE, BYPASS, BSCAN
//
//    MIN_STAP_SECURE_ORANGE
//       Opcdes that are visible to selected customers
//
//    MIN_STAP_SECURE_RED
//       Opcdes that are visible only to Intel
//
//    MIN_STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK
//       This parameter specifies the number of TAPs that could be present
//       in a TAP NETWORK This includes the number of STAPs that become part of
//       TAP NETWORK on a STAP
//       This parameter specifies the width of register atap_secsel and tapc_select
//
//    MIN_STAP_DFX_SECURE_POLICY_SELECTREG
//       This parameter determines the policy settings of TAPs on Network
//
//    MIN_STAP_ENABLE_TAPC_REMOVE
//       This is a 1-bit DR opcode that will enable the TAP TDI input to pass-thru
//       this TAP to the TAP7 network It will gate the internal TDI and TMS signals
//       to the FSM/logic block to logic 1 It will not even add the
//       one clock delay like BYPASS
//
//    MIN_STAP_NUMBER_OF_WTAPS_IN_NETWORK
//       This parameter specifies the number of WTAPs that could be present in a
//       WTAP NETWORK on a STAP
//       This parameter specifies the width of register atap_wtapnw_selectwir
//
//    MIN_STAP_WTAP_NETWORK_ONE_FOR_SERIES_ZERO_FOR_PARALLEL
//       This parameter will help us to identify whether the WTAPs on
//       a WTAP NETWORK are connected serially or parallely Also this helps in
//       generation of necessary control signals for serial or parallel
//       stitching of WTAPs in the WTAP NETWORK
//
//    MIN_STAP_ENABLE_WTAP_CTRL_POS_EDGE
//       This parameter specifies when WTAP is enabled then to use the control
//       signals like MIN_STAP_fsm_capture_dr and MIN_STAP_fsm_shift_dr on positive edge clk
//       if this parameter is one or negative edge clk if paramater is zero
//
//    MIN_STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS
//       This parameter specifies the number of User-Defined Remote TEST DATA
//       Registers that the sTAP needs to generate address decode and controls for
//
//    MIN_STAP_ENABLE_RTDR_PROG_RST
//       This parameter specifies the programmable reset option for RTDRs If the
//       value of this parameter is set to one, the programmable reset option is
//       enabled & which programmable reset is applicable would be decided by the
//       value programmed on TAPC_RTDRRSTEN register
//
//    MIN_STAP_RTDR_IS_BUSSED
//       This parameter specifies whether the User-Defined Remote TEST DATA Registers
//       related pins are bussed or not
//
//    MIN_STAP_NUMBER_OF_TEST_DATA_REGISTERS
//       This parameter specifies the number of User-Defined Optional TEST DATA
//       Registers that are present in the STAP
//
//    MIN_STAP_ENABLE_ITDR_PROG_RST
//       This parameter specifies the programmable reset option for iTDRs If the
//       value of this parameter is set to one, the programmable reset option is
//       enabled & which programmable reset is applicable would be decided by the
//       value programmed on TAPC_ITDRRSTEN register
//
//    MIN_STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS
//       This parameter specifies the combined total widths of all the User-Defined Optional
//       TEST DATA Registers that are present in the STAP
//
//    MIN_STAP_NUMBER_OF_TOTAL_REGISTERS
//       This is local parameter used to calculate the total number of register
//       that could be present in STAP
//
//    MIN_STAP_INSTRUCTION_FOR_DATA_REGISTERS
//       This parameter provides the instruction opcode for all the registers
//       (mandatory + optional) that are present in the STAP
//
//    MIN_STAP_NUMBER_OF_BITS_FOR_SLICE
//       This parameter is used as a reference to generate and identify widths of
//       all the register in STAP This is not a user definable parameter and its
//       value is fixed at 16
//
//    MIN_STAP_SIZE_OF_EACH_TEST_DATA_REGISTER
//       This parameter provides the width of each User-Defined Optional
//       TEST DATA Registers
//
//    MIN_STAP_MSB_VALUES_OF_TEST_DATA_REGISTERS
//       This parameter provides the MSB bit position for each of the User-Defined
//       Optional TEST DATA Registers
//
//    MIN_STAP_LSB_VALUES_OF_TEST_DATA_REGISTERS
//       This parameter provides the LSB bit position for each of the User-Defined
//       Optional TEST DATA Registers
//
//    MIN_STAP_RESET_VALUES_OF_TEST_DATA_REGISTERS
//       This parameter provides the RESET values for each of the User-Defined
//       Optional TEST DATA Registers
//----------------------------------------------------------------------------------------

parameter MIN_STAP_SIZE_OF_EACH_INSTRUCTION = 8;

parameter MIN_STAP_ENABLE_BSCAN = 0;
parameter MIN_STAP_NUMBER_OF_MANDATORY_REGISTERS = 2;

parameter MIN_STAP_SECURE_GREEN  = 2'b00;
parameter MIN_STAP_SECURE_ORANGE = 2'b01;
parameter MIN_STAP_SECURE_RED    = 2'b10;

parameter MIN_STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK = 0;
parameter [((2 * ((MIN_STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK == 0) ? 1 : MIN_STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK)) - 1) : 0] MIN_STAP_DFX_SECURE_POLICY_SELECTREG = {
MIN_STAP_SECURE_GREEN  //Network Security for TAP0
};
parameter MIN_STAP_ENABLE_TAPC_REMOVE = 0;

parameter MIN_STAP_NUMBER_OF_WTAPS_IN_NETWORK = 0;
parameter MIN_STAP_WTAP_NETWORK_ONE_FOR_SERIES_ZERO_FOR_PARALLEL = 0;
parameter MIN_STAP_ENABLE_WTAP_CTRL_POS_EDGE = 0;

parameter MIN_STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS = 0;
parameter MIN_STAP_ENABLE_RTDR_PROG_RST = 0;
parameter MIN_STAP_RTDR_IS_BUSSED = 0;

parameter MIN_STAP_NUMBER_OF_TEST_DATA_REGISTERS = 0;
parameter MIN_STAP_ENABLE_ITDR_PROG_RST = 0;
parameter MIN_STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS = 0;

parameter MIN_STAP_NUMBER_OF_TOTAL_REGISTERS = 2;

parameter [(((MIN_STAP_SIZE_OF_EACH_INSTRUCTION + 2) * MIN_STAP_NUMBER_OF_TOTAL_REGISTERS) - 1):0] MIN_STAP_INSTRUCTION_FOR_DATA_REGISTERS = {
{8'h0C, MIN_STAP_SECURE_GREEN},	 //Opcode for SLVIDCODE
{{MIN_STAP_SIZE_OF_EACH_INSTRUCTION{1'b1}}, MIN_STAP_SECURE_GREEN}  //Opcode for BYPASS
};
parameter MIN_STAP_NUMBER_OF_BITS_FOR_SLICE = 16;
parameter [((MIN_STAP_NUMBER_OF_BITS_FOR_SLICE * ((MIN_STAP_NUMBER_OF_TEST_DATA_REGISTERS == 0) ? 1 : MIN_STAP_NUMBER_OF_TEST_DATA_REGISTERS)) - 1):0] MIN_STAP_SIZE_OF_EACH_TEST_DATA_REGISTER = {
16'd0
};
parameter [((MIN_STAP_NUMBER_OF_BITS_FOR_SLICE * ((MIN_STAP_NUMBER_OF_TEST_DATA_REGISTERS == 0) ? 1 : MIN_STAP_NUMBER_OF_TEST_DATA_REGISTERS)) - 1):0] MIN_STAP_MSB_VALUES_OF_TEST_DATA_REGISTERS = {
16'd0
};
parameter [((MIN_STAP_NUMBER_OF_BITS_FOR_SLICE * ((MIN_STAP_NUMBER_OF_TEST_DATA_REGISTERS == 0) ? 1 : MIN_STAP_NUMBER_OF_TEST_DATA_REGISTERS)) - 1):0] MIN_STAP_LSB_VALUES_OF_TEST_DATA_REGISTERS = {
16'd0
};
parameter [(((MIN_STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS == 0) ? 1 : MIN_STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS) - 1):0] MIN_STAP_RESET_VALUES_OF_TEST_DATA_REGISTERS = {
1'b0
};
