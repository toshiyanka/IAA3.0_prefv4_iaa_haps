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

//----------------------------------------------------------------------
// Intel Proprietary -- Copyright 2020 Intel -- All rights reserved
//----------------------------------------------------------------------
// NOTE: Log history is at end of file.
//----------------------------------------------------------------------
//
//    FILENAME    : stap.sv
//    DESIGNER    : B.S.Adithya
//    PROJECT     : sTAP
//
//    PURPOSE     : sTAP Top Level 
//    DESCRIPTION :
//     
//       This is top module and integrates all the required modules.
//----------------------------------------------------------------------
// *********************************************************************
// Defines
// *********************************************************************
`include "stap_defines_include.inc"

module stap
   #(
   // Parameters
   `include "stap_params_include.inc"
   )
   (
   // // -----------------------------------------------------------------
   // // Primary JTAG ports
   // // -----------------------------------------------------------------
   // ftap_tck,        // Primary TAP port clock source from PAD originating
   //                  // from an agent or misc IO (HardIP).
   // ftap_tms,        // Primary TAP port mode select from PAD originating
   //                  // from an agent or misc IO (HardIP).
   // ftap_trst_b,     // Primary TAP port reset from PAD originating from an
   //                  // agent or misc IO (HardIP).
   // ftap_tdi,        // Primary TAP port data source from PAD originating
   //                  // from an agent or misc IO (HardIP).
   // ftap_slvidcode,  // Slave TAP strap value. Default value to load on
   //                  // capture (strap base).
   //                  // Internally LSB will be connected to 1.
   // atap_tdo,        // Primary TAP port dataout to PAD (agent or misc
   //                  // IO (HardIP))
   // atap_tdoen,      // Primary TAP port dataout enable to agent or misc
   //                  // IO (HardIP)
   // fdfx_powergood,  // When asserted ('0') all sticky flops are in reset.
   //                  // When de-asserted the trst_b decides when all flops
   //                  // are out of reset.
   // // -----------------------------------------------------------------
   // // Parallel ports of optional data registers
   // // -----------------------------------------------------------------
   // tdr_data_out, // Concatenated dataout for all the optional
   //               // test data registers.
   // tdr_data_in,  // Concatenated datain for all the optional
   //               // test data registers.
   // // -----------------------------------------------------------------
   // // DFX Secure signals
   // // -----------------------------------------------------------------
   // fdfx_secure_policy,   // This bus is a binary encoded value of the
   //                       // security policy that is the current state of
   //                       // the SoC.  The parameter value is constant for
   //                       // a given SoC generation and aligned with a process
   //                       // node. All IP-blocks must have the same width.
   //                       // For 14nm chassis: DFXSECURE_WIDTH = 4.
   // fdfx_earlyboot_exit   // This signal indicates when the early boot debug window is closed.
   //                       // 0: Debug capabilities are available during this phase of the boot flow
   //                       // 1: DFx security policy must be used
   // fdfx_policy_update    //This signal is the latch enable to capture the policy value to prevent glitches.
   //                       // 0: Latch values
   //                       // 1: Update to new policy value
   // // -----------------------------------------------------------------
   // // Control signals to Slave TAPNetwork
   // // -----------------------------------------------------------------
   // sftapnw_ftap_secsel,    // This signal controls which TAP on the network
   //                         // will be connected to the secondary TAP port.
   // sftapnw_ftap_enabletdo, // Based on the mode in which the selected TAP is
   //                         // configured, this signal enables the TDO.
   // sftapnw_ftap_enabletap, // This signal is used to exclude, decouple, shadow
   //                         // or allow normal scan operations with other
   //                         // TAPs in the fabric or within an agent.
   // // -----------------------------------------------------------------
   // // Primary JTAG ports to Slave TAPNetwork
   // // -----------------------------------------------------------------
   // sntapnw_ftap_tck,    // TAP Network TCK clock source originating from the
   //                      // primary TAP port.
   // sntapnw_ftap_tms,    // TAP Network mode select originating from the primary
   //                      // TAP port.
   // sntapnw_ftap_trst_b, // TAP Network TRST_b source  originating from the
   //                      // primary TAP port.
   // sntapnw_ftap_tdi,    // Serial data TDI going into the TAP Network originating
   //                      // from the STAP.
   // sntapnw_atap_tdo,    // Serial Data TDO coming from TAP Network or this TAP.
   // sntapnw_atap_tdo_en  // Serial Data TDOEN coming from TAP Network or this TAP.
   // // -----------------------------------------------------------------
   // // Secondary JTAG ports
   // // -----------------------------------------------------------------
   // ftapsslv_tck,    // Secondary TAP port clock source from PAD
   //                  // originating from an agent or misc IO (HardIP).
   // ftapsslv_tms,    // Secondary TAP port mode select from PAD originating
   //                  // from an agent or misc IO (HardIP).
   // ftapsslv_trst_b, // Secondary TAP port reset from PAD originating from
   //                  // an agent or misc IO (HardIP).
   // ftapsslv_tdi,    // Secondary TAP port data source from PAD originating
   //                  // from an agent or misc IO (HardIP).
   // atapsslv_tdo,    // Secondary TAP port dataout to PAD (agent or misc
   //                  // IO (HardIP))
   // atapsslv_tdoen,  // Secondary TAP port dataout enable to agent or misc
   //                  // IO (HardIP) wiring from sntapnw_atap_tdo2_en
   // // -----------------------------------------------------------------
   // // Secondary JTAG ports to Slave TAPNetwork
   // // -----------------------------------------------------------------
   // sntapnw_ftap_tck2,    // TAP Network TCK clock source originating from the
   //                       // secondary TAP port.
   // sntapnw_ftap_tms2,    // TAP Network TMS clock source originating from the
   //                       // secondary TAP port.
   // sntapnw_ftap_trst2_b, // TAP Network TRST_b clock source originating from
   //                       // the secondary TAP port.
   // sntapnw_ftap_tdi2,    // Serial data TDI going into the TAP Network
   //                       // originating from the secondary TAP port.
   // sntapnw_atap_tdo2,    // Serial Data TDO coming from TAP Network originating
   //                       // from the secondary TAP port.
   // sntapnw_atap_tdo2_en, // Secondary TAP port dataout enable coming from the
   //                       // TAPNW to this TAP.
   // // -----------------------------------------------------------------
   // // Control Signals common to WTAP/WTAP Network
   // // -----------------------------------------------------------------
   // sn_fwtap_wrck,      // Clock to the WTAP or WTAP Network.
   // sn_fwtap_wrst_b,    // Reset to the WTAP or WTAP Network.
   // sn_fwtap_capturewr, // CAIR or CADR TAP controller FSM outputs from
   //                     // STAP to capture data register values of IR & DR's
   //                     // within the WTAP or WTAP Network.
   // sn_fwtap_shiftwr,   // SHIR or SHDR TAP controller FSM outputs from
   //                     // STAP to shift the data register values of
   //                     // IR & DR's within the WTAP or WTAP Network.
   // sn_fwtap_updatewr,  // UPIR or UPDR TAP controller FSM outputs from
   //                     // STAP to update the data register values of
   //                     // IR & DR's within the WTAP or WTAP Network.
   // sn_fwtap_rti,       // TAP controller FSM output to WTAP.
   // // -----------------------------------------------------------------
   // // Control Signals only to WTAP Network
   // // -----------------------------------------------------------------
   // sn_fwtap_selectwir, // TAP controller FSM outputs to control
   //                     // the WTAP Network.
   // sn_awtap_wso,       // Data input from WTAP Network
   // sn_fwtap_wsi,       // Data output to WTAP Network
   // // -----------------------------------------------------------------
   // // Boundary Scan Signals
   // // -----------------------------------------------------------------
   // // Control Signals from fsm
   // // -----------------------------------------------------------------
   // stap_fbscan_tck,          // fabric boundary scan test clock
   // stap_abscan_tdo,          // fabric boundary scan test data output
   // stap_fbscan_capturedr,    // fabric boundary scan capture-dr signal
   // stap_fbscan_shiftdr,      // fabric boundary scan shift-dr signal
   // stap_fbscan_updatedr,     // fabric boundary scan update-dr signal
   // stap_fbscan_updatedr_clk, // Fabric boundary scan negedge update-dr signal
   // // -----------------------------------------------------------------
   // // Instructions
   // // -----------------------------------------------------------------
   // stap_fbscan_runbist_en, // runbist select signal, When RUNBIST IR is
   //                         // choosen, this signal goes high.
   // stap_fbscan_highz,      // fabric boundary scan highz select
   // stap_fbscan_extogen,    // when active indicates that the Slave fbscan
   //                         // EXTEST_TOGGLE is enabled and will be active
   //                         // if stap_fbscan_chainen = 1'b1
   // stap_fbscan_intest_mode // This signal enables an INTEST boundary-scan test
   //                         // mode. This is rarely used but available to SoCs.
   // stap_fbscan_chainen,    // fabric boundary scan select. When asserted
   //                         // select the boundary scan select signals.
   // stap_fbscan_mode,       // when stap_fbscan_chainen=1, this signal indicates
   //                         // that Slave TAP is performing the following
   //                         // on the Slave TAP
   //                         // 1'b0 --- SAMPLE/PRELOAD is active
   //                         // 1'b1 --- EXTEST is active
   // stap_fbscan_extogsig_b, // Provide the toggling signal source when Slave
   //                         // TAP enables EXTEST_TOGGLE
   // // -----------------------------------------------------------------
   // // 1149.6 AC mode
   // // -----------------------------------------------------------------
   // stap_fbscan_d6init,        // Boundary-scan 1149.6 test receiver initialization
   // stap_fbscan_d6actestsig_b, // Combined ac test waveform, to bscan cells for
   //                            // pins supporting extest_toggle and Dot6.
   // stap_fbscan_d6select       // Boundary-scan 1149.6 AC mode, Asserted during
   //                            // EXTEST_TRAIN / PULSE
   // // -----------------------------------------------------------------
   // // Remote Test data register
   // // -----------------------------------------------------------------
   // rtdr_tap_tdo,            // Serial Output from each remote TDRs coming back to TAP.
   // tap_rtdr_tdi,            // Serial input to remote test data register from TAP.
   //                          // If STAP_RTDR_IS_BUSSED=1, tdi & IRDecoder.
   //                          // If STAP_RTDR_IS_BUSSED=0, tdi.
   // tap_rtdr_capture,        // Capture dr will be high, when the specific Instruction is selected
   //                          // If STAP_RTDR_IS_BUSSED=1, CaptureDR & IRDecoder.
   //                          // If STAP_RTDR_IS_BUSSED=0, CaptureDR.
   // tap_rtdr_shift,          // Shift dr will be high, when the specific Instruction is selected
   //                          // If STAP_RTDR_IS_BUSSED=1, ShiftDR & IRDecoder.
   //                          // If STAP_RTDR_IS_BUSSED=0, ShiftDR.
   // tap_rtdr_update,         // Update dr will be high, when the specific Instruction is selected
   //                          // If STAP_RTDR_IS_BUSSED=1, UpdateDR & IRDecoder.
   //                          // If STAP_RTDR_IS_BUSSED=0, UpdateDR.
   // tap_rtdr_powergood       // To clear the Remote test data register. Note this is single bit,
   //                          // all remote data register need to connect this.
   // tap_rtdr_irdec           // To indicate the instructions register value of specific Remote TDR
   //                          // One-hot decoded value for each IR coresspoding to Remote TDR.
   // tap_rtdr_selectir        // Intended for RTDR which Selects the IR path, Just like how
   //                          // sn_fwtap_selectwir in WTAPNW is used.
   // tap_rtdr_tck             // sTAP clock going to RTDR IP clock domain
   // tap_rtdr_rti             // FSM RUTI state info to the Remote TDR.
   // tap_rtdr_prog_rst_b      // Programmable reset RTDR for either async ftap_trst_b
   //                          // or soft reset with 5 TMS or SWCLR.
   // // -----------------------------------------------------------------
   // // Primary JTAG ports
   // // -----------------------------------------------------------------
   input  logic        ftap_tck,
   input  logic        ftap_tms,
   input  logic        ftap_trst_b,
   input  logic        ftap_tdi,
   input  logic [31:0] ftap_slvidcode,
   output logic        atap_tdo,
   output logic        atap_tdoen,
   input  logic        fdfx_powergood,
  // input  logic        ftap_rtdr_tck_scan, //TCK for scan
  // output  logic       tap_rtdr_tck_scan, //TCK for scan to go to RTDRs
   // -----------------------------------------------------------------
   // Parallel ports of optional data registers
   // -----------------------------------------------------------------
   output logic [(((STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS == 0) ? 1 : STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS) - 1):0] tdr_data_out,
   input  logic [(((STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS == 0) ? 1 : STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS) - 1):0] tdr_data_in,
   // -----------------------------------------------------------------
   // DFX Secure signals
   // -----------------------------------------------------------------
   input  logic [3:0] fdfx_secure_policy,
   input  logic       fdfx_earlyboot_exit,
   input  logic       fdfx_policy_update,
   // -----------------------------------------------------------------
   // Control signals to 0.7 TAPNetwork
   // -----------------------------------------------------------------
   output logic [(((STAP_ENABLE_TDO_POS_EDGE == 1) ? 1 : (STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK == 0) ? 1 : STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK) - 1):0] sftapnw_ftap_secsel,
   output logic [(((STAP_ENABLE_TDO_POS_EDGE == 1) ? 1 : (STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK == 0) ? 1 : STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK) - 1):0] sftapnw_ftap_enabletdo,
   output logic [(((STAP_ENABLE_TDO_POS_EDGE == 1) ? 1 : (STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK == 0) ? 1 : STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK) - 1):0] sftapnw_ftap_enabletap,
   // -----------------------------------------------------------------
   // Primary JTAG ports to 0.7 TAPNetwork
   // -----------------------------------------------------------------
   output logic                                                 sntapnw_ftap_tck,
   output logic                                                 sntapnw_ftap_tms,
   output logic                                                 sntapnw_ftap_trst_b,
   output logic                                                 sntapnw_ftap_tdi,
   input  logic                                                 sntapnw_atap_tdo,
   input  logic [(((STAP_ENABLE_TDO_POS_EDGE == 1) ? 1 : (STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK == 0) ? 1 : STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK) - 1):0] sntapnw_atap_tdo_en,
   // -----------------------------------------------------------------
   // Secondary JTAG ports
   // -----------------------------------------------------------------
   input  logic ftapsslv_tck,
   input  logic ftapsslv_tms,
   input  logic ftapsslv_trst_b,
   input  logic ftapsslv_tdi,
   output logic atapsslv_tdo,
   output logic atapsslv_tdoen,
   // -----------------------------------------------------------------
   // Secondary JTAG ports to 0.7 TAPNetwork
   // -----------------------------------------------------------------
   output logic                                                 sntapnw_ftap_tck2,
   output logic                                                 sntapnw_ftap_tms2,
   output logic                                                 sntapnw_ftap_trst2_b,
   output logic                                                 sntapnw_ftap_tdi2,
   input  logic                                                 sntapnw_atap_tdo2,
   input  logic [(((STAP_ENABLE_TDO_POS_EDGE == 1) ? 1 : (STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK == 0) ? 1 : STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK) - 1):0] sntapnw_atap_tdo2_en,
   // -----------------------------------------------------------------
   // Control Signals common to WTAP/WTAP Network
   // -----------------------------------------------------------------
   output logic sn_fwtap_wrck,
   output logic sn_fwtap_wrst_b,
   output logic sn_fwtap_capturewr,
   output logic sn_fwtap_shiftwr,
   output logic sn_fwtap_updatewr,
   output logic sn_fwtap_rti,
   // -----------------------------------------------------------------
   // Control Signals only to WTAP Network
   // -----------------------------------------------------------------
   output logic                                              sn_fwtap_selectwir,
   input  logic [(((STAP_ENABLE_TDO_POS_EDGE == 1) ? 1 : (STAP_NUMBER_OF_WTAPS_IN_NETWORK == 0) ? 1 : (STAP_WTAP_NETWORK_ONE_FOR_SERIES_ZERO_FOR_PARALLEL == 1) ? 1 : STAP_NUMBER_OF_WTAPS_IN_NETWORK)- 1):0] sn_awtap_wso,
   output logic [(((STAP_ENABLE_TDO_POS_EDGE == 1) ? 1 : (STAP_NUMBER_OF_WTAPS_IN_NETWORK == 0) ? 1 : (STAP_WTAP_NETWORK_ONE_FOR_SERIES_ZERO_FOR_PARALLEL == 1) ? 1 : STAP_NUMBER_OF_WTAPS_IN_NETWORK) - 1):0] sn_fwtap_wsi,
   // -----------------------------------------------------------------
   // Boundary Scan Signals
   // -----------------------------------------------------------------
   // Control Signals from fsm
   // -----------------------------------------------------------------
   output logic stap_fbscan_tck,
   input  logic stap_abscan_tdo,
   output logic stap_fbscan_capturedr,
   output logic stap_fbscan_shiftdr,
   output logic stap_fbscan_updatedr,
   output logic stap_fbscan_updatedr_clk,
   // -----------------------------------------------------------------
   // Instructions
   // -----------------------------------------------------------------
   output logic stap_fbscan_runbist_en,
   output logic stap_fbscan_highz,
   output logic stap_fbscan_extogen,
   output logic stap_fbscan_intest_mode,
   output logic stap_fbscan_chainen,
   output logic stap_fbscan_mode,
   output logic stap_fbscan_extogsig_b,
   //-----------------------------------------------------------------
   // FSM TLRS signal brought to top : HSD 1604283648
   //-----------------------------------------------------------------
   output logic stap_fsm_tlrs,
   // -----------------------------------------------------------------
   input  logic ftap_pwrdomain_rst_b,
   // -----------------------------------------------------------------
   // 1149.6 AC mode
   // -----------------------------------------------------------------
   output logic stap_fbscan_d6init,
   output logic stap_fbscan_d6actestsig_b,
   output logic stap_fbscan_d6select,
   // -----------------------------------------------------------------
   // Remote Test data register
   // -----------------------------------------------------------------
   input  logic [(((STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS == 0) ? 1 :
                    STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS) - 1) : 0]  rtdr_tap_tdo,
   output logic [(((STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS == 0) ? 1 :
                    STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS) - 1) : 0]  tap_rtdr_irdec,
   output logic [(((STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS == 0) ? 1 :
                    STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS) - 1) : 0]  tap_rtdr_prog_rst_b,
   output logic [(((STAP_RTDR_IS_BUSSED == 0) ? 1 :
                  ((STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS == 0) ? 1 :
                    STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS)) - 1) : 0] tap_rtdr_tdi,
   output logic [(((STAP_RTDR_IS_BUSSED == 0) ? 1 :
                  ((STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS == 0) ? 1 :
                    STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS)) - 1) : 0] tap_rtdr_capture,
   output logic [(((STAP_RTDR_IS_BUSSED == 0) ? 1 :
                  ((STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS == 0) ? 1 :
                    STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS)) - 1) : 0] tap_rtdr_shift,
   output logic [(((STAP_RTDR_IS_BUSSED == 0) ? 1 :
                  ((STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS == 0) ? 1 :
                    STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS)) - 1) : 0] tap_rtdr_update,
   output logic                                                           tap_rtdr_tck,
   output logic                                                           tap_rtdr_powergood,
   output logic                                                           tap_rtdr_selectir,
   output logic                                                           tap_rtdr_rti,

   // -----------------------------------------------------------------
   // Isolation Enable Signal
   // -----------------------------------------------------------------/
   input logic                                                           stap_isol_en_b  
   );
// -----------------------------------------------------------------
// Local Parameters
// -----------------------------------------------------------------
`include "STAP_dsp_localparam_values_include.vh"
   localparam HIGH                                   = 1'b1;
   localparam LOW                                    = 1'b0;
   localparam STAP_MINIMUM_SIZEOF_INSTRUCTION        = 8;
   localparam STAP_ADDRESS_OF_CLAMP                  = (STAP_SIZE_OF_EACH_INSTRUCTION == 8) ? 8'h04 :
                                                        {{(STAP_SIZE_OF_EACH_INSTRUCTION -
                                                        STAP_MINIMUM_SIZEOF_INSTRUCTION + 4){LOW}}, 4'h4};
   localparam STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK_NZ  = (STAP_ENABLE_TDO_POS_EDGE == 1) ? 1 :
                                                       (STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK == 0) ? 1 :
                                                        STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK;
   localparam STAP_NUMBER_OF_TAPS_MULTIPLY_BY_2      = STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK_NZ * 2;
   localparam STAP_NUMBER_OF_WTAPS_IN_NETWORK_NZ     = (STAP_ENABLE_TDO_POS_EDGE == 1) ? 1 :
                                                       (STAP_NUMBER_OF_WTAPS_IN_NETWORK == 0) ? 1 :
                                                       (STAP_WTAP_NETWORK_ONE_FOR_SERIES_ZERO_FOR_PARALLEL == 1) ? 1 :
                                                        STAP_NUMBER_OF_WTAPS_IN_NETWORK;
   localparam STAP_ENABLE_TAP_NETWORK                = (STAP_ENABLE_TDO_POS_EDGE == 1) ? 0 :
                                                       (STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK == 0) ? 0 : 1;
   localparam STAP_ENABLE_WTAP_NETWORK               = (STAP_ENABLE_TDO_POS_EDGE == 1) ? 0 :
                                                       (STAP_NUMBER_OF_WTAPS_IN_NETWORK == 0) ? 0 : 1;
   localparam STAP_WTAP_COMMON_LOGIC                 = (STAP_ENABLE_TAP_NETWORK == 1) ? 1 :
                                                        (STAP_ENABLE_WTAP_NETWORK == 1) ? 1 : 0;
   localparam STAP_NUMBER_OF_PRELOAD_REGISTERS       = STAP_ENABLE_BSCAN;
   localparam STAP_NUMBER_OF_CLAMP_REGISTERS         = STAP_ENABLE_BSCAN;
   localparam STAP_NUMBER_OF_INTEST_REGISTERS        = STAP_ENABLE_BSCAN;
   localparam STAP_NUMBER_OF_RUNBIST_REGISTERS       = STAP_ENABLE_BSCAN;
   localparam STAP_NUMBER_OF_EXTEST_TOGGLE_REGISTERS = STAP_ENABLE_BSCAN;
   localparam STAP_ENABLE_TEST_DATA_REGISTERS        = (STAP_NUMBER_OF_TEST_DATA_REGISTERS == 0) ? 0 : 1;
   localparam STAP_WIDTH_OF_TAPC_REMOVE              = (STAP_ENABLE_TAPC_REMOVE == 0) ? 1 : STAP_ENABLE_TAPC_REMOVE;
   localparam STAP_ENABLE_TAPC_SEC_SEL               = (STAP_ENABLE_TDO_POS_EDGE == 1) ? 0 :
                                                       (STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK == 0) ? 0 : 1;
   localparam STAP_NUMBER_OF_TAP_NETWORK_REGISTERS   = (STAP_ENABLE_TAPC_SEC_SEL == 1) ? 1 : 0;
   localparam STAP_NUMBER_OF_TAP_SELECT_REGISTERS    = (STAP_ENABLE_TDO_POS_EDGE == 1) ? 0 :
                                                       (STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK == 0) ? 0 : 1;
   localparam STAP_NUMBER_OF_WTAP_NETWORK_REGISTERS  = (STAP_ENABLE_TDO_POS_EDGE == 1) ? 0 :
                                                       (STAP_NUMBER_OF_WTAPS_IN_NETWORK == 0) ? 0 : 1;
   localparam STAP_ENABLE_REMOTE_TEST_DATA_REGISTERS = (STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS == 0) ? 0 : 1;
   localparam STAP_WIDTH_OF_SLVIDCODE                = 32;
   localparam STAP_DSP_GROUND_4BITS                  = {(STAP_DFX_SECURE_WIDTH){LOW}};
   localparam STAP_DSP_GROUND_5BITS                  = {(STAP_DFX_NUM_OF_FEATURES_TO_SECURE+2){LOW}};

   localparam STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS_NZ = (STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS == 0) ? 1 :
                                                              STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS;

   localparam STAP_RTDR_IS_BUSSED_NZ                       = (STAP_RTDR_IS_BUSSED == 0) ? 1 :
                                                             ((STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS == 0) ? 1 :
                                                               STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS);
   localparam STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS_NZ   = (STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS == 0) ? 1 : STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS;

   // *********************************************************************
   // Internal Signals
   // *********************************************************************
   logic stap_selectwir_neg;    //kbbhagwa posedge negedge signal merge
   logic stap_fsm_shift_ir_neg; //kbbhagwa posedge negedge signal merge

   logic                                              tdo_dr;
   logic                                              swcomp_stap_post_tdo;
   logic                                              swcompctrl_tdo;
   logic                                              swcompstat_tdo;
   logic                                              stap_fsm_rti;
   logic                                              stap_fsm_e1dr;
   logic                                              stap_fsm_e2dr;
   logic                                              stap_fsm_capture_ir;
   logic                                              stap_fsm_shift_ir;
   logic                                              stap_fsm_update_ir;
   logic                                              stap_fsm_capture_dr;
   logic                                              stap_fsm_shift_dr;
   logic                                              stap_fsm_update_dr;
   logic [(STAP_SIZE_OF_EACH_INSTRUCTION - 1):0]      stap_irreg_ireg;
   logic [(STAP_SIZE_OF_EACH_INSTRUCTION - 1):0]      stap_irreg_ireg_nxt; //kbbhagwa cdc fix
   logic                                              stap_irreg_serial_out;
   logic [(STAP_NUMBER_OF_TOTAL_REGISTERS - 1):0]     stap_drreg_tdo;
   logic [(STAP_NUMBER_OF_TOTAL_REGISTERS - 1):0]     stap_irdecoder_drselect;
   logic                                              stap_and_all_bits_irreg;
   logic [(STAP_NUMBER_OF_TAPS_MULTIPLY_BY_2 - 1):0]  tapc_select;
   logic [(STAP_NUMBER_OF_WTAPS_IN_NETWORK_NZ - 1):0] tapc_wtap_sel;
   logic                                              tapc_remove;
   logic                                              stap_mux_tdo;
   logic                                              pre_tdo;
   logic                                              stap_wtapnw_tdo;
   logic                                              powergood_rst_trst_b;
   logic                                              stap_tdomux_tdoen;
   logic [(STAP_SIZE_OF_EACH_INSTRUCTION - 1):0]      stap_irreg_shift_reg;
   logic                                              stap_selectwir;
   logic                                              visa_all_dis;
   logic                                              visa_customer_dis;
   logic [(STAP_DFX_NUM_OF_FEATURES_TO_SECURE - 1):0] dfxsecure_feature_en;
   logic                                              tap_swcomp_active ;
   logic [1:0]                                        suppress_update_capture_reg;

   // *********************************************************************
   // Clock Buf Ctech Cell Instantiation
   // *********************************************************************
   stap_ctech_lib_clk_buf i_stap_ctech_lib_clk_buf_rtdr           (.clkout(tap_rtdr_tck), .clk(ftap_tck));
   //stap_ctech_lib_clk_buf i_stap_ctech_lib_clk_buf_rtdr_scan    (.clkout(tap_rtdr_tck_scan), .clk(ftap_rtdr_tck_scan));

   // *********************************************************************
   // FSM instantiation
   // *********************************************************************
   stap_fsm #(
              .FSM_STAP_ENABLE_TAP_NETWORK                (STAP_ENABLE_TAP_NETWORK),
              .FSM_STAP_WTAP_COMMON_LOGIC                 (STAP_WTAP_COMMON_LOGIC),
              .FSM_STAP_ENABLE_WTAP_CTRL_POS_EDGE         (STAP_ENABLE_WTAP_CTRL_POS_EDGE),
			  .FSM_STAP_SUPPRESS_UPDATE_CAPTURE           (STAP_SUPPRESS_UPDATE_CAPTURE),
              .FSM_STAP_SIZE_OF_EACH_INSTRUCTION          (STAP_SIZE_OF_EACH_INSTRUCTION),
              .FSM_STAP_ENABLE_REMOTE_TEST_DATA_REGISTERS (STAP_ENABLE_REMOTE_TEST_DATA_REGISTERS)
             )
   i_stap_fsm (
               .ftap_tms                (ftap_tms),
               .ftap_tck                (ftap_tck),
               .powergood_rst_trst_b    (powergood_rst_trst_b),
			   .suppress_update_capture_reg (suppress_update_capture_reg),
                .stap_irreg_ireg       (stap_irreg_ireg),
               .tapc_remove             (tapc_remove),
               .stap_fsm_tlrs           (stap_fsm_tlrs),
               .stap_fsm_rti            (stap_fsm_rti),
               .stap_fsm_e1dr           (stap_fsm_e1dr),
               .stap_fsm_e2dr           (stap_fsm_e2dr),
               .stap_selectwir          (stap_selectwir),
               .stap_selectwir_neg      (stap_selectwir_neg), //kbbhagwa posedge negedge signal merge
               .sn_fwtap_capturewr      (sn_fwtap_capturewr),
               .sn_fwtap_shiftwr        (sn_fwtap_shiftwr),
               .sn_fwtap_updatewr       (sn_fwtap_updatewr),
               .sn_fwtap_rti            (sn_fwtap_rti),
               .sn_fwtap_wrst_b         (sn_fwtap_wrst_b),
               .stap_fsm_capture_ir     (stap_fsm_capture_ir),
               .stap_fsm_shift_ir       (stap_fsm_shift_ir),
               .stap_fsm_shift_ir_neg   (stap_fsm_shift_ir_neg), //kbbhagwa
               .stap_fsm_update_ir      (stap_fsm_update_ir),
               .stap_fsm_capture_dr     (stap_fsm_capture_dr),
               .stap_fsm_shift_dr       (stap_fsm_shift_dr),
               .stap_fsm_update_dr      (stap_fsm_update_dr)
              );

   // *********************************************************************
   // Instruction Reg instantiation
   // *********************************************************************
   stap_irreg #(
                .IRREG_STAP_SIZE_OF_EACH_INSTRUCTION   (STAP_SIZE_OF_EACH_INSTRUCTION),
                .IRREG_STAP_MINIMUM_SIZEOF_INSTRUCTION (STAP_MINIMUM_SIZEOF_INSTRUCTION)
               )
   i_stap_irreg (
                 .stap_fsm_tlrs         (stap_fsm_tlrs),
                 .stap_fsm_capture_ir   (stap_fsm_capture_ir),
                 .stap_fsm_shift_ir     (stap_fsm_shift_ir),
                 .stap_fsm_update_ir    (stap_fsm_update_ir),
                 .ftap_tdi              (ftap_tdi),
                 .ftap_tck              (ftap_tck),
                 .powergood_rst_trst_b  (powergood_rst_trst_b),
                 .stap_irreg_ireg       (stap_irreg_ireg),
                 .stap_irreg_ireg_nxt   (stap_irreg_ireg_nxt), //kbbhagwa cdc fix
                 .stap_irreg_serial_out (stap_irreg_serial_out),
                 .stap_irreg_shift_reg  (stap_irreg_shift_reg)
                );

   // *********************************************************************
   // IR decoder instantiation
   // *********************************************************************
   stap_irdecoder #(
                    .IRDECODER_STAP_SWCOMP_ACTIVE                  (STAP_SWCOMP_ACTIVE),
                    .IRDECODER_STAP_SIZE_OF_EACH_INSTRUCTION       (STAP_SIZE_OF_EACH_INSTRUCTION),
                    .IRDECODER_STAP_NUMBER_OF_TOTAL_REGISTERS      (STAP_NUMBER_OF_TOTAL_REGISTERS),
                    .IRDECODER_STAP_INSTRUCTION_FOR_DATA_REGISTERS (STAP_INSTRUCTION_FOR_DATA_REGISTERS),
                    .IRDECODER_STAP_ADDRESS_OF_CLAMP               (STAP_ADDRESS_OF_CLAMP),
                    .IRDECODER_STAP_MINIMUM_SIZEOF_INSTRUCTION     (STAP_MINIMUM_SIZEOF_INSTRUCTION),
                    .IRDECODER_STAP_ENABLE_BSCAN                   (STAP_ENABLE_BSCAN),
                    .IRDECODER_STAP_SECURE_GREEN                   (STAP_SECURE_GREEN),
                    .IRDECODER_STAP_SECURE_ORANGE                  (STAP_SECURE_ORANGE),
                    .IRDECODER_STAP_SECURE_RED                     (STAP_SECURE_RED)
                   )
   i_stap_irdecoder (
                     .powergood_rst_trst_b    (powergood_rst_trst_b),
                     .stap_irreg_ireg         (stap_irreg_ireg),
                     .stap_irreg_ireg_nxt     (stap_irreg_ireg_nxt), //kbbhagwa cdc fix
                     .ftap_tck                (ftap_tck), //kbbhagwa cdc fix
                     .stap_irdecoder_drselect (stap_irdecoder_drselect),
                     .stap_and_all_bits_irreg (stap_and_all_bits_irreg),
                     .tap_swcomp_active       (tap_swcomp_active),
                     .stap_isol_en_b          (stap_isol_en_b),
                     .feature_green_en        (dfxsecure_feature_en[0]),
                     .feature_orange_en       (dfxsecure_feature_en[1]),
                     .feature_red_en          (dfxsecure_feature_en[2])

                    );

   // *********************************************************************
   // Data Register Implementation
   // *********************************************************************
   stap_drreg #(
                .DRREG_STAP_SWCOMP_ACTIVE                             (STAP_SWCOMP_ACTIVE),
				.DRREG_STAP_SUPPRESS_UPDATE_CAPTURE                    (STAP_SUPPRESS_UPDATE_CAPTURE),
                .DRREG_STAP_DFX_SECURE_POLICY_SELECTREG               (STAP_DFX_SECURE_POLICY_SELECTREG),
				.DRREG_STAP_WTAPCTRL_RESET_VALUE                      (STAP_WTAPCTRL_RESET_VALUE),
                .DRREG_STAP_ENABLE_TEST_DATA_REGISTERS                (STAP_ENABLE_TEST_DATA_REGISTERS),
                .DRREG_STAP_ENABLE_TAPC_REMOVE                        (STAP_ENABLE_TAPC_REMOVE),
                .DRREG_STAP_WIDTH_OF_SLVIDCODE                        (STAP_WIDTH_OF_SLVIDCODE),
                .DRREG_STAP_NUMBER_OF_TOTAL_REGISTERS                 (STAP_NUMBER_OF_TOTAL_REGISTERS),
                .DRREG_STAP_NUMBER_OF_MANDATORY_REGISTERS             (STAP_NUMBER_OF_MANDATORY_REGISTERS),
                .DRREG_STAP_NUMBER_OF_BITS_FOR_SLICE                  (STAP_NUMBER_OF_BITS_FOR_SLICE),
                .DRREG_STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS        (STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS_NZ),
                .DRREG_STAP_SIZE_OF_EACH_TEST_DATA_REGISTER           (STAP_SIZE_OF_EACH_TEST_DATA_REGISTER),
                .DRREG_STAP_LSB_VALUES_OF_TEST_DATA_REGISTERS         (STAP_LSB_VALUES_OF_TEST_DATA_REGISTERS),
                .DRREG_STAP_MSB_VALUES_OF_TEST_DATA_REGISTERS         (STAP_MSB_VALUES_OF_TEST_DATA_REGISTERS),
                .DRREG_STAP_RESET_VALUES_OF_TEST_DATA_REGISTERS       (STAP_RESET_VALUES_OF_TEST_DATA_REGISTERS),
                .DRREG_STAP_NUMBER_OF_TAP_NETWORK_REGISTERS           (STAP_NUMBER_OF_TAP_NETWORK_REGISTERS),
                .DRREG_STAP_NUMBER_OF_TAPS                            (STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK_NZ),
                .DRREG_STAP_NUMBER_OF_WTAPS                           (STAP_NUMBER_OF_WTAPS_IN_NETWORK_NZ),
                .DRREG_STAP_WIDTH_OF_TAPC_REMOVE                      (STAP_WIDTH_OF_TAPC_REMOVE),
                .DRREG_STAP_NUMBER_OF_WTAP_NETWORK_REGISTERS          (STAP_NUMBER_OF_WTAP_NETWORK_REGISTERS),
                .DRREG_STAP_ENABLE_TAPC_SEC_SEL                       (STAP_ENABLE_TAPC_SEC_SEL),
                .DRREG_STAP_ENABLE_WTAP_NETWORK                       (STAP_ENABLE_WTAP_NETWORK),
                .DRREG_STAP_ENABLE_TAP_NETWORK                        (STAP_ENABLE_TAP_NETWORK),
                .DRREG_STAP_NUMBER_OF_TAPC_REMOVE_REGISTERS           (STAP_ENABLE_TAPC_REMOVE),
                .DRREG_STAP_NUMBER_OF_PRELOAD_REGISTERS               (STAP_NUMBER_OF_PRELOAD_REGISTERS),
                .DRREG_STAP_NUMBER_OF_CLAMP_REGISTERS                 (STAP_NUMBER_OF_CLAMP_REGISTERS),
                .DRREG_STAP_NUMBER_OF_INTEST_REGISTERS                (STAP_NUMBER_OF_INTEST_REGISTERS),
                .DRREG_STAP_NUMBER_OF_RUNBIST_REGISTERS               (STAP_NUMBER_OF_RUNBIST_REGISTERS),
                .DRREG_STAP_NUMBER_OF_EXTEST_TOGGLE_REGISTERS         (STAP_NUMBER_OF_EXTEST_TOGGLE_REGISTERS),
                .DRREG_STAP_NUMBER_OF_TAPS_MULTIPLY_BY_2              (STAP_NUMBER_OF_TAPS_MULTIPLY_BY_2),
                .DRREG_STAP_ENABLE_BSCAN                              (STAP_ENABLE_BSCAN),
                .DRREG_STAP_NUMBER_OF_TAP_SELECT_REGISTERS            (STAP_NUMBER_OF_TAP_SELECT_REGISTERS),
                .DRREG_STAP_NUMBER_OF_TEST_DATA_REGISTERS             (STAP_NUMBER_OF_TEST_DATA_REGISTERS),
                .DRREG_STAP_ENABLE_ITDR_PROG_RST                      (STAP_ENABLE_ITDR_PROG_RST),
                .DRREG_STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS_NZ   (STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS_NZ),
                .DRREG_STAP_RTDR_IS_BUSSED_NZ                         (STAP_RTDR_IS_BUSSED_NZ),
                .DRREG_STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS      (STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS),
                .DRREG_STAP_ENABLE_RTDR_PROG_RST                      (STAP_ENABLE_RTDR_PROG_RST),
                .DRREG_STAP_ENABLE_REMOTE_TEST_DATA_REGISTERS         (STAP_ENABLE_REMOTE_TEST_DATA_REGISTERS),
                .DRREG_STAP_SECURE_GREEN                              (STAP_SECURE_GREEN),
                .DRREG_STAP_SECURE_ORANGE                             (STAP_SECURE_ORANGE),
                .DRREG_STAP_SECURE_RED                                (STAP_SECURE_RED)
               )
   i_stap_drreg (
                 .stap_fsm_tlrs            (stap_fsm_tlrs),
                 .ftap_tdi                 (ftap_tdi),
                 .ftap_tck                 (ftap_tck),
                 .ftap_trst_b              (ftap_trst_b),
                 .fdfx_powergood           (fdfx_powergood),
                 .powergood_rst_trst_b     (powergood_rst_trst_b),
                 .stap_fsm_capture_dr      (stap_fsm_capture_dr),
                 .stap_fsm_shift_dr        (stap_fsm_shift_dr),
                 .stap_fsm_update_dr       (stap_fsm_update_dr),
                 .stap_selectwir           (stap_selectwir),
                 .ftap_slvidcode           (ftap_slvidcode),
                 .stap_irdecoder_drselect  (stap_irdecoder_drselect),
                 .tdr_data_in              (tdr_data_in),
                 .tdr_data_out             (tdr_data_out),
                 .sftapnw_ftap_secsel      (sftapnw_ftap_secsel),
                 .tapc_select              (tapc_select),
                 .feature_green_en         (dfxsecure_feature_en[0]),
                 .feature_orange_en        (dfxsecure_feature_en[1]),
                 .feature_red_en           (dfxsecure_feature_en[2]),
                 .tapc_wtap_sel            (tapc_wtap_sel),
                 .tapc_remove              (tapc_remove),
                 .stap_drreg_tdo           (stap_drreg_tdo),
                 .swcompctrl_tdo           (swcompctrl_tdo),
                 .swcompstat_tdo           (swcompstat_tdo),
                 .stap_and_all_bits_irreg  (stap_and_all_bits_irreg),
                 .rtdr_tap_tdo             (rtdr_tap_tdo),
                 .tap_rtdr_tdi             (tap_rtdr_tdi),
                 .tap_rtdr_capture         (tap_rtdr_capture),
                 .tap_rtdr_shift           (tap_rtdr_shift),
                 .tap_rtdr_update          (tap_rtdr_update),
                 .tap_rtdr_irdec           (tap_rtdr_irdec),
                 .tap_rtdr_powergood       (tap_rtdr_powergood),
                 .tap_rtdr_selectir        (tap_rtdr_selectir),
                 .tap_rtdr_rti             (tap_rtdr_rti),
                 .tap_rtdr_prog_rst_b      (tap_rtdr_prog_rst_b),
				 .suppress_update_capture_reg (suppress_update_capture_reg),
                 .stap_fsm_rti             (stap_fsm_rti)
                );

   // *********************************************************************
   // TDO mux implementation
   // *********************************************************************
   stap_tdomux #(
                 .TDOMUX_STAP_NUMBER_OF_TOTAL_REGISTERS (STAP_NUMBER_OF_TOTAL_REGISTERS),
                 .STAP_ENABLE_TDO_POS_EDGE (STAP_ENABLE_TDO_POS_EDGE)
                )
   i_stap_tdomux (
                  .stap_drreg_tdo          (stap_drreg_tdo),
                  .stap_fsm_shift_dr       (stap_fsm_shift_dr),
                  .stap_fsm_shift_ir       (stap_fsm_shift_ir),
                  .stap_irdecoder_drselect (stap_irdecoder_drselect),
                  .stap_irreg_serial_out   (stap_irreg_serial_out),
                  .stap_fsm_tlrs           (stap_fsm_tlrs),
                  .ftap_tck                (ftap_tck),
                  .powergood_rst_trst_b    (powergood_rst_trst_b),
                  .swcomp_stap_post_tdo    (swcomp_stap_post_tdo),
                  .tap_swcomp_active       (tap_swcomp_active),
                  .stap_mux_tdo            (stap_mux_tdo),
                  .tdo_dr                  (tdo_dr),
                  .stap_tdomux_tdoen       (stap_tdomux_tdoen)
                 );

   // *********************************************************************
   // TAP network implementation
   // *********************************************************************
   generate
      if (STAP_ENABLE_TAP_NETWORK == 1)
      begin:generate_stap_tapnw
         stap_tapnw #(
                      .TAPNW_STAP_NUMBER_OF_TAPS  (STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK_NZ),
                      .TAPNW_STAP_NUMBER_OF_WTAPS (STAP_NUMBER_OF_WTAPS_IN_NETWORK_NZ)
                     )
         i_stap_tapnw (
                       .stap_selectwir_neg     (stap_selectwir_neg), //kbbhagwa posedge negedge signal merge
                       .tapc_select            (tapc_select),
                       .sftapnw_ftap_enabletdo (sftapnw_ftap_enabletdo),
                       .sftapnw_ftap_enabletap (sftapnw_ftap_enabletap)
                      );
      end
      else
      begin:generate_stap_tapnw
         assign sftapnw_ftap_enabletdo[0] = LOW;
         assign sftapnw_ftap_enabletap[0] = LOW;
      end
   endgenerate

   // *********************************************************************
   // WTAP network implementation
   // *********************************************************************
   generate
      if (STAP_ENABLE_WTAP_NETWORK == 1)
      begin:generate_stap_wtapnw
         stap_wtapnw #(
                       .WTAPNW_STAP_NUMBER_OF_TAPS               (STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK_NZ),
                       .WTAPNW_STAP_NUMBER_OF_WTAPS              (STAP_NUMBER_OF_WTAPS_IN_NETWORK_NZ),
                       .WTAPNW_STAP_NUMBER_OF_TAPS_MULTIPLY_BY_2 (STAP_NUMBER_OF_TAPS_MULTIPLY_BY_2)
                      )
         i_stap_wtapnw (
                        .stap_mux_tdo       (stap_mux_tdo),
                        .stap_selectwir     (stap_selectwir),
                        .sn_awtap_wso       (sn_awtap_wso),
                        .tapc_wtap_sel      (tapc_wtap_sel),
                        .tapc_select        (tapc_select),
                        .sn_fwtap_selectwir (sn_fwtap_selectwir),
                        .sn_fwtap_wsi       (sn_fwtap_wsi),
                        .stap_wtapnw_tdo    (stap_wtapnw_tdo)
                       );
      end
      else
      begin:generate_stap_wtapnw
         assign sn_fwtap_wsi[0]    = HIGH;
         assign sn_fwtap_selectwir = LOW;
         assign stap_wtapnw_tdo    = HIGH;
      end
   endgenerate

   // *********************************************************************
   // Glue logic implementation
   // *********************************************************************
   stap_glue #(
               .GLUE_STAP_ENABLE_TAP_NETWORK       (STAP_ENABLE_TAP_NETWORK),
               .GLUE_STAP_ENABLE_WTAP_NETWORK      (STAP_ENABLE_WTAP_NETWORK),
               .GLUE_STAP_NUMBER_OF_TAPS           (STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK_NZ),
               .GLUE_STAP_NUMBER_OF_WTAPS          (STAP_NUMBER_OF_WTAPS_IN_NETWORK_NZ),
               .GLUE_STAP_SIZE_OF_EACH_INSTRUCTION (STAP_SIZE_OF_EACH_INSTRUCTION),
               .GLUE_STAP_WTAP_COMMON_LOGIC        (STAP_WTAP_COMMON_LOGIC),
               .GLUE_STAP_ENABLE_TAPC_REMOVE       (STAP_ENABLE_TAPC_REMOVE)
              )
   i_stap_glue (
                .ftap_tck             (ftap_tck),
                .ftap_tms             (ftap_tms),
                .ftap_trst_b          (ftap_trst_b),
                .fdfx_powergood       (fdfx_powergood),
                .ftap_tdi             (ftap_tdi),
                .stap_tdomux_tdoen    (stap_tdomux_tdoen),
                .sntapnw_atap_tdo_en  (sntapnw_atap_tdo_en),
                .pre_tdo              (pre_tdo),
                .powergood_rst_trst_b (powergood_rst_trst_b),
                .atap_tdoen           (atap_tdoen),
                .sntapnw_ftap_tck     (sntapnw_ftap_tck),
                .sntapnw_ftap_tms     (sntapnw_ftap_tms),
                .sntapnw_ftap_trst_b  (sntapnw_ftap_trst_b),
                .sntapnw_ftap_tdi     (sntapnw_ftap_tdi),
                .sntapnw_atap_tdo     (sntapnw_atap_tdo),
                .ftapsslv_tck         (ftapsslv_tck),
                .ftapsslv_tms         (ftapsslv_tms),
                .ftapsslv_trst_b      (ftapsslv_trst_b),
                .ftapsslv_tdi         (ftapsslv_tdi),
                .atapsslv_tdo         (atapsslv_tdo),
                .atapsslv_tdoen       (atapsslv_tdoen),
                .sntapnw_ftap_tck2    (sntapnw_ftap_tck2),
                .sntapnw_ftap_tms2    (sntapnw_ftap_tms2),
                .sntapnw_ftap_trst2_b (sntapnw_ftap_trst2_b),
                .sntapnw_ftap_tdi2    (sntapnw_ftap_tdi2),
                .sntapnw_atap_tdo2    (sntapnw_atap_tdo2),
                .sntapnw_atap_tdo2_en (sntapnw_atap_tdo2_en),
                .sn_fwtap_wrck        (sn_fwtap_wrck),
                .stap_mux_tdo         (stap_mux_tdo),
                .tapc_select          (tapc_select),
                .tapc_wtap_sel        (tapc_wtap_sel),
                .tapc_remove          (tapc_remove),
                .stap_wtapnw_tdo      (stap_wtapnw_tdo)
               );

   // *********************************************************************
   // Boundary Scan implementation
   // *********************************************************************
   generate
      if (STAP_ENABLE_BSCAN == 1)
      begin:generate_stap_bscan
         stap_bscan #(
                      .BSCAN_STAP_SIZE_OF_EACH_INSTRUCTION          (STAP_SIZE_OF_EACH_INSTRUCTION),
                      .BSCAN_STAP_MINIMUM_SIZEOF_INSTRUCTION        (STAP_MINIMUM_SIZEOF_INSTRUCTION),
                      .BSCAN_STAP_ADDRESS_OF_CLAMP                  (STAP_ADDRESS_OF_CLAMP),
                      .BSCAN_STAP_NUMBER_OF_PRELOAD_REGISTERS       (STAP_NUMBER_OF_PRELOAD_REGISTERS),
                      .BSCAN_STAP_NUMBER_OF_CLAMP_REGISTERS         (STAP_NUMBER_OF_CLAMP_REGISTERS),
                      .BSCAN_STAP_NUMBER_OF_INTEST_REGISTERS        (STAP_NUMBER_OF_INTEST_REGISTERS),
                      .BSCAN_STAP_NUMBER_OF_RUNBIST_REGISTERS       (STAP_NUMBER_OF_RUNBIST_REGISTERS),
                      .BSCAN_STAP_NUMBER_OF_EXTEST_TOGGLE_REGISTERS (STAP_NUMBER_OF_EXTEST_TOGGLE_REGISTERS)
                     )
         i_stap_bscan (
                       .ftap_tck                  (ftap_tck),
                       .powergood_rst_trst_b      (powergood_rst_trst_b),
                       .stap_fsm_tlrs             (stap_fsm_tlrs),
                       .stap_fsm_rti              (stap_fsm_rti),
                       .stap_fsm_e1dr             (stap_fsm_e1dr),
                       .stap_fsm_e2dr             (stap_fsm_e2dr),
                       .atap_tdo                  (atap_tdo),
                       .pre_tdo                   (pre_tdo),
                       .stap_fbscan_tck           (stap_fbscan_tck),
                       .stap_abscan_tdo           (stap_abscan_tdo),
                       .stap_fbscan_capturedr     (stap_fbscan_capturedr),
                       .stap_fbscan_shiftdr       (stap_fbscan_shiftdr),
                       .stap_fbscan_updatedr      (stap_fbscan_updatedr),
                       .stap_fbscan_updatedr_clk  (stap_fbscan_updatedr_clk),
                       .stap_fbscan_runbist_en    (stap_fbscan_runbist_en),
                       .stap_fbscan_highz         (stap_fbscan_highz),
                       .stap_fbscan_extogen       (stap_fbscan_extogen),
                       .stap_fbscan_intest_mode   (stap_fbscan_intest_mode),
                       .stap_fbscan_chainen       (stap_fbscan_chainen),
                       .stap_fbscan_mode          (stap_fbscan_mode),
                       .stap_fbscan_extogsig_b    (stap_fbscan_extogsig_b),
                       .stap_fbscan_d6init        (stap_fbscan_d6init),
                       .stap_fbscan_d6actestsig_b (stap_fbscan_d6actestsig_b),
                       .stap_fbscan_d6select      (stap_fbscan_d6select),
                       .stap_fsm_capture_dr       (stap_fsm_capture_dr),
                       .stap_fsm_shift_dr         (stap_fsm_shift_dr),
                       .stap_fsm_update_dr        (stap_fsm_update_dr),
                       .stap_irreg_ireg           (stap_irreg_ireg),
                       .stap_fsm_update_ir        (stap_fsm_update_ir),
                       .stap_irreg_shift_reg      (stap_irreg_shift_reg),
                       .stap_fsm_shift_ir_neg     (stap_fsm_shift_ir_neg) //kbbhagwa posedge negedge signal merge
                      );
      end
      else
      begin:generate_stap_bscan
         assign atap_tdo                  = pre_tdo;
         assign stap_fbscan_tck           = LOW;
         assign stap_fbscan_capturedr     = LOW;
         assign stap_fbscan_shiftdr       = LOW;
         assign stap_fbscan_updatedr      = LOW;
         assign stap_fbscan_updatedr_clk  = LOW;
         assign stap_fbscan_runbist_en    = LOW;
         assign stap_fbscan_highz         = LOW;
         assign stap_fbscan_extogen       = LOW;
         assign stap_fbscan_intest_mode   = LOW;
         assign stap_fbscan_chainen       = LOW;
         assign stap_fbscan_mode          = LOW;
         assign stap_fbscan_extogsig_b    = HIGH;
         assign stap_fbscan_d6init        = LOW;
         assign stap_fbscan_d6actestsig_b = HIGH;
         assign stap_fbscan_d6select      = LOW;
      end
   endgenerate

   // *********************************************************************
   // DFx Secure implementation
   // *********************************************************************
   stap_dfxsecure_plugin #(
                           `include "STAP_dsp_param_overide_include.vh"
                          )
   i_stap_dfxsecure_plugin (
                            .fdfx_powergood       (fdfx_powergood),
                            .fdfx_secure_policy   (fdfx_secure_policy),
                            .fdfx_earlyboot_exit  (fdfx_earlyboot_exit),
                            .fdfx_policy_update   (fdfx_policy_update),
                            .dfxsecure_feature_en (dfxsecure_feature_en),
                            .visa_all_dis         (visa_all_dis),
                            .visa_customer_dis    (visa_customer_dis),
                            .sb_policy_ovr_value  (STAP_DSP_GROUND_5BITS),
                            .oem_secure_policy    (STAP_DSP_GROUND_4BITS)
                           );

   generate
    if (STAP_SWCOMP_ACTIVE == 1)
     begin:generate_stap_swcomp_rtdr  //PCR 1604263740 for SWCOMP Integration
         stap_swcomp_rtdr #(
                            .STAP_SWCOMP_NUM_OF_COMPARE_BITS (STAP_SWCOMP_NUM_OF_COMPARE_BITS)
                           )
         i_stap_swcomp_rtdr (
                       
                            //Inputs to SWCOMP
                            .ftap_tdi               (ftap_tdi), 
                            .ftap_tck               (ftap_tck),
                            .fdfx_powergood         (fdfx_powergood & ftap_pwrdomain_rst_b),
                            .powergood_rst_trst_b   (powergood_rst_trst_b & ftap_pwrdomain_rst_b),
                            .tap_swcomp_active      (tap_swcomp_active),
                            .stap_fsm_tlrs          (stap_fsm_tlrs),
                            .stap_fsm_capture_dr    (stap_fsm_capture_dr),
                            .stap_fsm_shift_dr      (stap_fsm_shift_dr),
                            .stap_fsm_update_dr     (stap_fsm_update_dr),
                            .stap_fsm_e2dr          (stap_fsm_e2dr),
                            .stap_swcomp_pre_tdo    (tdo_dr),

                            //Outputs from SWCOMP
                            .swcomp_stap_post_tdo   (swcomp_stap_post_tdo),
                            .swcompstat_tdo         (swcompstat_tdo),
                            .swcompctrl_tdo         (swcompctrl_tdo)
                 
                           );
    end
    else
    begin:generate_stap_swcomp_rtdr
       assign swcomp_stap_post_tdo = LOW;
       assign swcompstat_tdo = LOW;
       assign swcompctrl_tdo = LOW;
    end
    endgenerate

   // Assertions and coverage
   // collage-pragma translate_off
`ifndef INTEL_SVA_OFF
`ifndef STAP_SVA_OFF
`ifdef INTEL_SIMONLY
      `include "stap_include.sv"
   `endif
   `endif
   `endif
   // collage-pragma translate_on
endmodule
