//----------------------------------------------------------------------------------------
// Intel Proprietary -- Copyright 2019 Intel -- All rights reserved
//----------------------------------------------------------------------------------------
// NOTE: Log history is at end of file.
//----------------------------------------------------------------------------------------
//
//    FILENAME    : MAX_sTAP_soc_param_values.inc
//    DESIGNER    : Sudheer V Bandana
//    PROJECT     : sTAP
//    PURPOSE     : sTAP RTL Parameters
//    VERSION     : sTAP_2016WW15_R1.5
//    DESCRIPTION :
//       This is a RTL parameter file. Please refer IG for more details.
//----------------------------------------------------------------------------------------
//    PARAMETERS  :
//
//    MAX_STAP_SIZE_OF_EACH_INSTRUCTION
//       This parameter specifies the width of instruction register in MAX_STAP.
//
//    MAX_STAP_ENABLE_BSCAN
//       This parameter enables the Bounday scan operation in sTAP. Unlike CLTAP, this
//       feature is optional in sTAP
//
//    MAX_STAP_NUMBER_OF_MANDATORY_REGISTERS
//       This parameter specifies the number of mandatory registers in MAX_STAP.
//       This is not a user definable parameter and its value is fixed to either 2 or 12,
//       as BYPASS, IDCODE are the real mandatory registers, but Boundary Scan Registers
//       also get added if BSCAN is enabled in MAX_STAP. All other registers are optional.
//
//    MAX_STAP_SECURE_GREEN
//       Opcdes that are visible to all customers. Like SLVIDCODE, BYPASS, BSCAN.   
//
//    MAX_STAP_SECURE_ORANGE
//       Opcdes that are visible to selected customers.    
//
//    MAX_STAP_SECURE_RED
//       Opcdes that are visible only to Intel.   
//
//    MAX_STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK
//       This parameter specifies the number of TAPs that could be present
//       in a TAP NETWORK. This includes the number of MAX_STAPs that become part of
//       TAP NETWORK on a MAX_STAP
//       This parameter specifies the width of register atap_secsel and tapc_select
//
//    MAX_STAP_DFX_SECURE_POLICY_SELECTREG
//       This parameter determines the policy settings of TAPs on Network.
//
//    MAX_STAP_ENABLE_TAPC_REMOVE
//       This is a 1-bit DR opcode that will enable the TAP TDI input to pass-thru
//       this TAP to the TAP.7 network. It will gate the internal TDI and TMS signals
//       to the FSM/logic block to logic 1. It will not even add the
//       one clock delay like BYPASS.
//
//    MAX_STAP_NUMBER_OF_WTAPS_IN_NETWORK
//       This parameter specifies the number of WTAPs that could be present in a
//       WTAP NETWORK on a MAX_STAP
//       This parameter specifies the width of register atap_wtapnw_selectwir.
//
//    MAX_STAP_WTAP_NETWORK_ONE_FOR_SERIES_ZERO_FOR_PARALLEL
//       This parameter will help us to identify whether the WTAPs on
//       a WTAP NETWORK are connected serially or parallely. Also this helps in
//       generation of necessary control signals for serial or parallel
//       stitching of WTAPs in the WTAP NETWORK
//
//    MAX_STAP_ENABLE_WTAP_CTRL_POS_EDGE
//       This parameter specifies when WTAP is enabled then to use the control
//       signals like stap_fsm_capture_dr and stap_fsm_shift_dr on positive edge clk
//       if this parameter is one or negative edge clk if paramater is zero.
//
//    MAX_STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS
//       This parameter specifies the number of User-Defined Remote TEST DATA
//       Registers that the sTAP needs to generate address decode and controls for.
//
//    MAX_STAP_RTDR_IS_BUSSED
//       This parameter specifies whether the User-Defined Remote TEST DATA Registers
//       related pins are bussed or not.
//
//    MAX_STAP_NUMBER_OF_TEST_DATA_REGISTERS
//       This parameter specifies the number of User-Defined Optional TEST DATA
//       Registers that are present in the MAX_STAP
//
//    MAX_STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS
//       This parameter specifies the combined total widths of all the User-Defined Optional
//       TEST DATA Registers that are present in the MAX_STAP
//
//    MAX_STAP_NUMBER_OF_TOTAL_REGISTERS
//       This is local parameter used to calculate the total number of register
//       that could be present in MAX_STAP
//
//    MAX_STAP_INSTRUCTION_FOR_DATA_REGISTERS
//       This parameter provides the instruction opcode for all the registers
//       (mandatory + optional) that are present in the MAX_STAP
//
//    MAX_STAP_NUMBER_OF_BITS_FOR_SLICE
//       This parameter is used as a reference to generate and identify widths of
//       all the register in MAX_STAP. This is not a user definable parameter and its
//       value is fixed at 16.
//
//    MAX_STAP_SIZE_OF_EACH_TEST_DATA_REGISTER
//       This parameter provides the width of each User-Defined Optional
//       TEST DATA Registers
//
//    MAX_STAP_MSB_VALUES_OF_TEST_DATA_REGISTERS
//       This parameter provides the MSB bit position for each of the User-Defined
//       Optional TEST DATA Registers
//
//    MAX_STAP_LSB_VALUES_OF_TEST_DATA_REGISTERS
//       This parameter provides the LSB bit position for each of the User-Defined
//       Optional TEST DATA Registers
//
//    MAX_STAP_RESET_VALUES_OF_TEST_DATA_REGISTERS
//       This parameter provides the RESET values for each of the User-Defined
//       Optional TEST DATA Registers
//
//    MAX_STAP_BIT_ONE_FOR_TDRDATAIN_ZERO_FOR_TDRDATAOUT
//       This parameter is a per-bit value used to specify whether the each bit of the
//       TDR captures a fixed value (from tdr_data_in bus) or the recirculated value
//       coming from the corresponding bit of tdr_data_out bus
//----------------------------------------------------------------------------------------

parameter MAX_STAP_SIZE_OF_EACH_INSTRUCTION = 16;

parameter MAX_STAP_ENABLE_BSCAN = 1;
parameter MAX_STAP_NUMBER_OF_MANDATORY_REGISTERS = 12;

parameter MAX_STAP_SECURE_GREEN  = 2'b00;
parameter MAX_STAP_SECURE_ORANGE = 2'b01;
parameter MAX_STAP_SECURE_RED    = 2'b10;

parameter MAX_STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK = 4;
parameter [((2 * ((MAX_STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK == 0) ? 1 : MAX_STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK)) - 1) : 0] MAX_STAP_DFX_SECURE_POLICY_SELECTREG = {
MAX_STAP_SECURE_ORANGE, //Network Security for TAP3
MAX_STAP_SECURE_ORANGE, //Network Security for TAP2
MAX_STAP_SECURE_RED,    //Network Security for TAP1
MAX_STAP_SECURE_RED     //Network Security for TAP0
};
parameter MAX_STAP_ENABLE_TAPC_REMOVE = 1;

parameter MAX_STAP_NUMBER_OF_WTAPS_IN_NETWORK = 3;
parameter MAX_STAP_WTAP_NETWORK_ONE_FOR_SERIES_ZERO_FOR_PARALLEL = 0;
parameter MAX_STAP_ENABLE_WTAP_CTRL_POS_EDGE = 0;

parameter MAX_STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS = 3;
parameter MAX_STAP_RTDR_IS_BUSSED = 0;

parameter MAX_STAP_NUMBER_OF_TEST_DATA_REGISTERS = 2;
parameter MAX_STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS = 64;

parameter MAX_STAP_NUMBER_OF_TOTAL_REGISTERS = 21;

parameter [(((MAX_STAP_SIZE_OF_EACH_INSTRUCTION + 2) * MAX_STAP_NUMBER_OF_TOTAL_REGISTERS) - 1):0] MAX_STAP_INSTRUCTION_FOR_DATA_REGISTERS = {
{16'h56, MAX_STAP_SECURE_RED},    //Opcode for RTDR2
{16'h46, MAX_STAP_SECURE_RED},    //Opcode for RTDR1
{16'h36, MAX_STAP_SECURE_RED},    //Opcode for RTDR0
{16'h6B, MAX_STAP_SECURE_RED},    //Opcode for TDR1
{16'h34, MAX_STAP_SECURE_RED},    //Opcode for TDR0
{16'h14, MAX_STAP_SECURE_ORANGE}, //Opcode for TAPC_REMOVE
{16'h13, MAX_STAP_SECURE_ORANGE}, //Opcode for WTAP
{16'h10, MAX_STAP_SECURE_ORANGE}, //Opcode for SEC SEL
{16'h0D, MAX_STAP_SECURE_GREEN},  //Opcode for EXTEST TOGGLE
{16'h07, MAX_STAP_SECURE_GREEN},  //Opcode for RUNBIST
{16'h06, MAX_STAP_SECURE_GREEN},  //Opcode for INTEST
{16'h04, MAX_STAP_SECURE_GREEN},  //Opcode for CLAMP
{16'h03, MAX_STAP_SECURE_GREEN},  //Opcode for PRELOAD
{16'h11, MAX_STAP_SECURE_GREEN},  //Opcode for TAPC_SELECT
{16'h0F, MAX_STAP_SECURE_GREEN},  //Opcode for EXTEXT_TRAIN
{16'h0E, MAX_STAP_SECURE_GREEN},  //Opcode for EXTEXT_PULSE
{16'h0C, MAX_STAP_SECURE_GREEN},  //Opcode for SLVIDCODE
{16'h09, MAX_STAP_SECURE_GREEN},  //Opcode for EXTEXT
{16'h08, MAX_STAP_SECURE_GREEN},  //Opcode for HIGHZ
{16'h01, MAX_STAP_SECURE_GREEN},  //Opcode for SAMPLE/PRELOAD
{{MAX_STAP_SIZE_OF_EACH_INSTRUCTION{1'b1}}, MAX_STAP_SECURE_GREEN}  //Opcode for BYPASS
};
parameter MAX_STAP_NUMBER_OF_BITS_FOR_SLICE = 16;
parameter [((MAX_STAP_NUMBER_OF_BITS_FOR_SLICE * ((MAX_STAP_NUMBER_OF_TEST_DATA_REGISTERS == 0) ? 1 : MAX_STAP_NUMBER_OF_TEST_DATA_REGISTERS)) - 1):0] MAX_STAP_SIZE_OF_EACH_TEST_DATA_REGISTER = {
16'd32, //Width of TDR 1
16'd32  //Width of TDR 0
};
parameter [((MAX_STAP_NUMBER_OF_BITS_FOR_SLICE * ((MAX_STAP_NUMBER_OF_TEST_DATA_REGISTERS == 0) ? 1 : MAX_STAP_NUMBER_OF_TEST_DATA_REGISTERS)) - 1):0] MAX_STAP_MSB_VALUES_OF_TEST_DATA_REGISTERS = {
16'd63, //MSB Value of TDR 1
16'd31  //MSB Value of TDR 0
};
parameter [((MAX_STAP_NUMBER_OF_BITS_FOR_SLICE * ((MAX_STAP_NUMBER_OF_TEST_DATA_REGISTERS == 0) ? 1 : MAX_STAP_NUMBER_OF_TEST_DATA_REGISTERS)) - 1):0] MAX_STAP_LSB_VALUES_OF_TEST_DATA_REGISTERS = {
16'd32, //LSB Value of TDR 1
16'd0  //LSB Value of TDR 0
};
parameter [(((MAX_STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS == 0) ? 1 : MAX_STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS) - 1):0] MAX_STAP_RESET_VALUES_OF_TEST_DATA_REGISTERS = {
32'h99AA_5566, //Reset Value of TDR 1
32'hAA55_6699  //Reset Value of TDR 0
};
parameter [(((MAX_STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS == 0) ? 1 : MAX_STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS) - 1):0] MAX_STAP_BIT_ONE_FOR_TDRDATAIN_ZERO_FOR_TDRDATAOUT = {
32'h0000_0000, //Corresponding bit is RO when its value is 1 else RW - during CaptureDR of TDR 1
32'h0000_FFFF  //Corresponding bit is RO when its value is 1 else RW - during CaptureDR of TDR 0
};
