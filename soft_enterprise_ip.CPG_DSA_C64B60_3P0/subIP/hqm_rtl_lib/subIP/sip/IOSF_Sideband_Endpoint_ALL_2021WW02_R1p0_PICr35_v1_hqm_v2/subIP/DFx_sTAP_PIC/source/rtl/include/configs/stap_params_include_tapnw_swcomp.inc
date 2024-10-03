//------------------------------------------------------------------------------
//  INTEL CONFIDENTIAL
//
//  Copyright 2020 Intel Corporation All Rights Reserved.
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
//  Collateral Description:
//  dteg-stap
//
//  Source organization:
//  DTEG Engineering Group (DTEG)
//
//  Support Information:
//  HSD: https://hsdes.intel.com/appstore/article/#/dft_services.bugeco/create
//
//  Revision:
//  DTEG_sTAP_2020WW05_RTL1P0_PIC6_V1
//
//  Module <sTAP> :  < put your functional description here in plain text >
//
//------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------
// NOTE: Log history is at end of file.
//----------------------------------------------------------------------------------------
//
//    FILENAME    : stap_params_include.inc
//    DESIGNER    : Rakesh Kandula
//    PROJECT     : sTAP
//    PURPOSE     : sTAP RTL Parameters
//    DESCRIPTION :
//       This is a RTL parameter file. Please refer IG for more details.
//----------------------------------------------------------------------------------------
//    PARAMETERS  :
//
//    STAP_SIZE_OF_EACH_INSTRUCTION
//       This parameter specifies the width of instruction register in STAP.
//
//    STAP_SWCOMP_ACTIVE
//       This parameter specifies whether SWCOMP is active in STAP or not.
//
//    STAP_SWCOMP_NUM_OF_COMPARE_BITS
//       This parameter specifies the number of compare bits present in the SWCOMP compare window
//
//    STAP_ENABLE_TDO_POS_EDGE
//       There is one exception to this rule for a re-time TAP. A re-time TAP
//       may output TDO to be clocked on the rising edge of TCK. This can only
//       be applied at a Region DFx Unit or a Cluster DFx Unit’s level of hierarchy. 
//       If this parameter is high TDO is flopped on the rising edge of TCK
//       else if this parameter is LOW TDO is flopped on the falling edge of TCK.
//
//    STAP_ENABLE_BSCAN
//       This parameter enables the Bounday scan operation in sTAP. Unlike CLTAP, this
//       feature is optional in sTAP
//
//    STAP_NUMBER_OF_MANDATORY_REGISTERS
//       This parameter specifies the number of mandatory registers in STAP.
//       This is not a user definable parameter and its value is fixed to either 2 or 12,
//       as BYPASS, IDCODE are the real mandatory registers, but Boundary Scan Registers
//       also get added if BSCAN is enabled in STAP. All other registers are optional.
//
//    STAP_SECURE_GREEN
//       Opcdes that are visible to all customers. Like SLVIDCODE, BYPASS, BSCAN.
//
//    STAP_SECURE_ORANGE
//       Opcdes that are visible to selected customers.
//
//    STAP_SECURE_RED
//       Opcdes that are visible only to Intel.
//
//    STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK
//       This parameter specifies the number of TAPs that could be present
//       in a TAP NETWORK. This includes the number of STAPs that become part of
//       TAP NETWORK on a STAP
//       This parameter specifies the width of register atap_secsel and tapc_select
//
//    STAP_DFX_SECURE_POLICY_SELECTREG
//       This parameter determines the policy settings of TAPs on Network.
//
//    STAP_ENABLE_TAPC_REMOVE
//       This is a 1-bit DR opcode that will enable the TAP TDI input to pass-thru
//       this TAP to the TAP.7 network. It will gate the internal TDI and TMS signals
//       to the FSM/logic block to logic 1. It will not even add the
//       one clock delay like BYPASS.
//
//    STAP_NUMBER_OF_WTAPS_IN_NETWORK
//       This parameter specifies the number of WTAPs that could be present in a
//       WTAP NETWORK on a STAP
//       This parameter specifies the width of register atap_wtapnw_selectwir.
//
//    STAP_WTAP_NETWORK_ONE_FOR_SERIES_ZERO_FOR_PARALLEL
//       This parameter will help us to identify whether the WTAPs on
//       a WTAP NETWORK are connected serially or parallely. Also this helps in
//       generation of necessary control signals for serial or parallel
//       stitching of WTAPs in the WTAP NETWORK
//
//    STAP_ENABLE_WTAP_CTRL_POS_EDGE
//       This parameter specifies when WTAP is enabled then to use the control
//       signals like stap_fsm_capture_dr and stap_fsm_shift_dr on positive edge clk
//       if this parameter is one or negative edge clk if paramater is zero.
//
//    STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS
//       This parameter specifies the number of User-Defined Remote TEST DATA
//       Registers that the sTAP needs to generate address decode and controls for.
//
//    STAP_ENABLE_RTDR_PROG_RST
//       This parameter specifies the programmable reset option for RTDRs. If the
//       value of this parameter is set to one, then the TAPC_RTDRRSTSEL  &
//       TAPC_TDRRSTEN registers comes into existance. The user has to program
//       which register has the programmable reset option by writing 1 to the
//       corresponding bit position for each of the RTDRs in TAPC_RTDRRSTSEL
//       register. Which programmable reset is applicable would be decided by the
//       value programmed on TAPC_TDRRSTEN register.
//
//    STAP_RTDR_IS_BUSSED
//       This parameter specifies whether the User-Defined Remote TEST DATA Registers
//       related pins are bussed or not.
//
//    STAP_NUMBER_OF_TEST_DATA_REGISTERS
//       This parameter specifies the number of User-Defined Optional TEST DATA
//       Registers that are present in the STAP
//
//    STAP_ENABLE_ITDR_PROG_RST
//       This parameter specifies the programmable reset option for ITDRs. If the
//       value of this parameter is set to one, then the TAPC_ITDRRSTSEL  &
//       TAPC_TDRRSTEN registers comes into existance. The user has to program
//       which register has the programmable reset option by writing 1 to the
//       corresponding bit position for each of the iTDRs in TAPC_ITDRRSTSEL
//       register. Which programmable reset is applicable would be decided by the
//       value programmed on TAPC_TDRRSTEN register.
//
//    STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS
//       This parameter specifies the combined total widths of all the User-Defined Optional
//       TEST DATA Registers that are present in the STAP
//
//    STAP_NUMBER_OF_TOTAL_REGISTERS
//       This is local parameter used to calculate the total number of register
//       that could be present in STAP
//
//    STAP_INSTRUCTION_FOR_DATA_REGISTERS
//       This parameter provides the instruction opcode for all the registers
//       (mandatory + optional) that are present in the STAP
//
//    STAP_NUMBER_OF_BITS_FOR_SLICE
//       This parameter is used as a reference to generate and identify widths of
//       all the register in STAP. This is not a user definable parameter and its
//       value is fixed at 16.
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
//    STAP_DFX_NUM_OF_FEATURES_TO_SECURE
//       The minimum number of features to secure is one Although, theoretically
//       it can be any number of features but it is likely to be in an single digits
//
//    STAP_DFX_SECURE_WIDTH
//       This parameter is fixed at 4 for the 14nm chassis generation (Chassis Gen3)
//
//    STAP_DFX_EARLYBOOT_FEATURE_ENABLE
//       This parameter sets the hard coded value for the early debug window for this 
//       agent/IP-block. For most IP-blocks this will be VISA green only. However, 
//       there are in the suspend (SUS) well IPs that require full access.
//       Most IPs:
//       DFX_EARLYBOOT_FEATURE_ENABLE[1:0] = VISA_GREEN
//       DFX_EARLYBOOT_FEATURE_ENABLE[DFX_NUM_OF_FEATURES_TO_SECURE+1 : 2] = 
//       {[DFX_NUM_OF_FEATURES_TO_SECURE:2]}{1'b0}}
//
//    STAP_DFX_SECURE_POLICY_MATRIX
//       This parameter determines the lookup table necessary to assign the
//       appropriate policy with the DFx feature(s) including VISA access
//
//    STAP_WTAPCTRL_RESET_VALUE
//       This parameter sets the default value for the STAP_WTAP_CTL register. It is based on the number of WTAPs. 
//       This value is only pratical for one WTAP controlled by a sTAP.
//    
//    STAP_SUPPRESS_UPDATE_CAPTURE
//       This parameter suppresses the Update DR and Capture DR. 
//
//----------------------------------------------------------------------------------------

parameter STAP_SIZE_OF_EACH_INSTRUCTION = 16,
parameter STAP_SWCOMP_ACTIVE = 1,
parameter STAP_SWCOMP_NUM_OF_COMPARE_BITS = 10,
parameter STAP_ENABLE_TDO_POS_EDGE = 0,
parameter STAP_WTAPCTRL_RESET_VALUE = 0,
parameter STAP_SUPPRESS_UPDATE_CAPTURE = 0,

parameter STAP_ENABLE_BSCAN = 1,
parameter STAP_NUMBER_OF_MANDATORY_REGISTERS = 12,

parameter STAP_SECURE_GREEN  = 2'b00,
parameter STAP_SECURE_ORANGE = 2'b01,
parameter STAP_SECURE_RED    = 2'b10,

parameter STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK = 4,
parameter [((2 * ((STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK == 0) ? 1 : STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK)) - 1) : 0] STAP_DFX_SECURE_POLICY_SELECTREG = {
STAP_SECURE_ORANGE, //Network Security for TAP3
STAP_SECURE_ORANGE, //Network Security for TAP2
STAP_SECURE_RED,    //Network Security for TAP1
STAP_SECURE_RED     //Network Security for TAP0
},
parameter STAP_ENABLE_TAPC_REMOVE = 1,

parameter STAP_NUMBER_OF_WTAPS_IN_NETWORK = 0,
parameter STAP_WTAP_NETWORK_ONE_FOR_SERIES_ZERO_FOR_PARALLEL = 0,
parameter STAP_ENABLE_WTAP_CTRL_POS_EDGE = 0,

parameter STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS = 0,
parameter STAP_ENABLE_RTDR_PROG_RST = 0,
parameter STAP_RTDR_IS_BUSSED = 0,

parameter STAP_NUMBER_OF_TEST_DATA_REGISTERS = 2,
parameter STAP_ENABLE_ITDR_PROG_RST = 0,
parameter STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS = 2049,

parameter STAP_NUMBER_OF_TOTAL_REGISTERS = 19,

parameter [(((STAP_SIZE_OF_EACH_INSTRUCTION + 2) * STAP_NUMBER_OF_TOTAL_REGISTERS) - 1):0] STAP_INSTRUCTION_FOR_DATA_REGISTERS = {
{16'h6B, STAP_SECURE_RED},    //Opcode for iTDR1
{16'h34, STAP_SECURE_RED},    //Opcode for iTDR0
{16'h21, STAP_SECURE_GREEN},  //Opcode for SWCOMP_STAT
{16'h20, STAP_SECURE_GREEN},  //Opcode for SWCOMP_CTRL
{16'h14, STAP_SECURE_GREEN},  //Opcode for TAPC_REMOVE
{16'h10, STAP_SECURE_ORANGE}, //Opcode for TAPC_SEC_SEL
{16'h0D, STAP_SECURE_GREEN},  //Opcode for EXTEST_TOGGLE
{16'h07, STAP_SECURE_GREEN},  //Opcode for RUNBIST
{16'h06, STAP_SECURE_GREEN},  //Opcode for INTEST
{16'h04, STAP_SECURE_GREEN},  //Opcode for CLAMP
{16'h03, STAP_SECURE_GREEN},  //Opcode for PRELOAD
{16'h11, STAP_SECURE_GREEN},  //Opcode for TAPC_SELECT
{16'h0F, STAP_SECURE_GREEN},  //Opcode for EXTEXT_TRAIN
{16'h0E, STAP_SECURE_GREEN},  //Opcode for EXTEXT_PULSE
{16'h0C, STAP_SECURE_GREEN},  //Opcode for SLVIDCODE
{16'h09, STAP_SECURE_GREEN},  //Opcode for EXTEXT
{16'h08, STAP_SECURE_GREEN},  //Opcode for HIGHZ
{16'h01, STAP_SECURE_GREEN},  //Opcode for SAMPLE/PRELOAD
{{STAP_SIZE_OF_EACH_INSTRUCTION{1'b1}}, STAP_SECURE_GREEN}  //Opcode for BYPASS
},
parameter STAP_NUMBER_OF_BITS_FOR_SLICE = 16,
parameter [((STAP_NUMBER_OF_BITS_FOR_SLICE * ((STAP_NUMBER_OF_TEST_DATA_REGISTERS == 0) ? 1 : STAP_NUMBER_OF_TEST_DATA_REGISTERS)) - 1):0] STAP_SIZE_OF_EACH_TEST_DATA_REGISTER = {
16'd2048, //Width of iTDR 1
16'd1  //Width of iTDR 0
},
parameter [((STAP_NUMBER_OF_BITS_FOR_SLICE * ((STAP_NUMBER_OF_TEST_DATA_REGISTERS == 0) ? 1 : STAP_NUMBER_OF_TEST_DATA_REGISTERS)) - 1):0] STAP_MSB_VALUES_OF_TEST_DATA_REGISTERS = {
16'd2048, //MSB Value of iTDR 1
16'd0  //MSB Value of iTDR 0
},
parameter [((STAP_NUMBER_OF_BITS_FOR_SLICE * ((STAP_NUMBER_OF_TEST_DATA_REGISTERS == 0) ? 1 : STAP_NUMBER_OF_TEST_DATA_REGISTERS)) - 1):0] STAP_LSB_VALUES_OF_TEST_DATA_REGISTERS = {
16'd1, //LSB Value of iTDR 1
16'd0  //LSB Value of iTDR 0
},
parameter [(((STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS == 0) ? 1 : STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS) - 1):0] STAP_RESET_VALUES_OF_TEST_DATA_REGISTERS = {
2048'h0, //Reset Value of iTDR 1
1'h0  //Reset Value of iTDR 0
},

parameter STAP_DFX_EARLYBOOT_FEATURE_ENABLE = {3'b001,2'b11},
// size of the SECURE_POLICY_MATRIX : [(((STAP_DFX_NUM_OF_FEATURES_TO_SECURE + 2) * (2 ** STAP_DFX_SECURE_WIDTH)) - 1):0]
parameter [(((3+2)*(2**4))-1):0] STAP_DFX_SECURE_POLICY_MATRIX = 
{
// 3 dfx features + 2 visa controls
{3'b001,2'b11},  //  => Policy_15 (Part Disabled)
{3'b010,2'b11},  //  => Policy_14 (User8 Unlocked
{3'b010,2'b11},  //  => Policy_13 (User7 Unlocked)
{3'b010,2'b11},  //  => Policy_12 (User6 Unlocked)
{3'b010,2'b11},  //  => Policy_11 (User5 Unlocked)
{3'b010,2'b11},  //  => Policy_10 (User4 Unlocked)
{3'b100,2'b11},  //  => Policy_9  (FuSa Unlocked)
{3'b010,2'b11},  //  => Policy_8  (DRAM Debug Unlocked)
{3'b100,2'b11},  //  => Policy_7  (InfraRed Unlocked)
{3'b100,2'b11},  //  => Policy_6  (enDebug Unlocked)
{3'b010,2'b11},  //  => Policy_5  (OEM Unlocked)
{3'b100,2'b11},  //  => Policy_4  (Intel Unlocked)
{3'b001,2'b11},  //  => Policy_3  (Delayed Auth Locked)
{3'b100,2'b11},  //  => Policy_2  (Security Unlocked)
{3'b001,2'b11},  //  => Policy_1  (Functionality Locked)
{3'b001,2'b11}   //  => Policy_0  (Security Locked)
}
