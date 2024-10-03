//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//
//  -- Intel Proprietary
//  -- Copyright (C) 2015 Intel Corporation
//  -- All Rights Reserved
//
//  INTEL CONFIDENTIAL
//
//  Copyright 2009-2020 Intel Corporation All Rights Reserved.
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
//------------------------------------------------------------------------------
//
//  Collateral Description:
//  IOSF - Sideband Channel IP
//
//  Source organization:
//  SEG / SIP / IOSF IP Engineering
//
//  Support Information:
//  WEB: http://moss.amr.ith.intel.com/sites/SoftIP/Shared%20Documents/Forms/AllItems.aspx
//  HSD: https://vthsd.fm.intel.com/hsd/seg_softip/default.aspx
//
//  Revision:
//  2020WW22_PICr33
//
//  Module <sTAP> :  < put your functional description here in plain text >
//
//------------------------------------------------------------------------------

//----------------------------------------------------------------------
// Intel Proprietary -- Copyright 2009 Intel -- All rights reserved
//----------------------------------------------------------------------
// NOTE: Log history is at end of file.
//----------------------------------------------------------------------
//
//    FILENAME    : stap.sv
//    DESIGNER    : Sunjiv Sachan
//    PROJECT     : sTAP
//    
//    
//    PURPOSE     : sTAP Top Level
//    DESCRIPTION :
//       This is top module and integrates all the required modules.
//----------------------------------------------------------------------
//    LOCAL PARAMETERS:
//
//    HIGH
//       This is 1 bit one value
//
//    LOW
//       This is 1 bit zero value
//
//    STAP_WIDTH_OF_SLVIDCODE
//       This defines width of SLVIDCODE. This is used to create pins at top level.
//
//    STAP_WIDTH_OF_VERCODE
//       This is the width of ftap_vercode pins. These are strap values from SoC.
//
//    STAP_MINIMUM_SIZEOF_INSTRUCTION
//       This minumum size of instruction supported in our design.
//
//    STAP_ADDRESS_OF_CLAMP
//       This is address of optional Clamp register. It is used in two different
//       modules and hence declared in top module.
//
//    STAP_WIDTH_OF_TAPC_VISAOVR
//       This is width of Visa select override register. This value defaults to
//       one if STAP_SIZE_OF_TAPC_VISAOVR is zero.
//
//    STAP_WIDTH_OF_TAPC_REMOVE
//       This is width of remove register. This value defaults to
//       one if STAP_SIZE_OF_TAPC_REMOVE is zero.
//
//    STAP_NUMBER_OF_TAPS
//       This specifes number of taps in 0.7 network. This value defaults to one
//       if STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK is zero.
//
//    STAP_NUMBER_OF_WTAPS
//       This specifes number of wtaps in wtap network. This value defaults to one
//       if STAP_NUMBER_OF_WTAPS_IN_NETWORK is zero or wtap network connection is
//       series.
//
//    STAP_NUMBER_OF_TAPS_MULTIPLY_BY_2
//       This specifies width of select and select_ovr registers.
//
//    STAP_WTAP_COMMON_LOGIC
//       This is to generated common signals when wtap is connected directly or
//       wtapnw is enabled
//----------------------------------------------------------------------
// *********************************************************************
// Defines
// *********************************************************************
`include "stap_defines_include.inc"

module stap 
   #(
   `include "stap_params_include.inc"

   parameter HIGH                                         = 1'b1,
   parameter LOW                                          = 1'b0,
   parameter STAP_WIDTH_OF_SLVIDCODE                      = 32,
   parameter STAP_WIDTH_OF_VERCODE                        = 4,
   parameter STAP_MINIMUM_SIZEOF_INSTRUCTION              = 8,
   //parameter STAP_CONNECT_WTAP_DIRECTLY                   = 0,
   parameter STAP_ADDRESS_OF_CLAMP                        = (STAP_SIZE_OF_EACH_INSTRUCTION == 8) ? 8'h04 :
                                                               {{(STAP_SIZE_OF_EACH_INSTRUCTION -
                                                               STAP_MINIMUM_SIZEOF_INSTRUCTION + 4){LOW}}, 4'h4},
   parameter STAP_WIDTH_OF_TAPC_VISAOVR                   = (STAP_ENABLE_TAPC_VISAOVR == 0) ? 1 :
                                                             STAP_SIZE_OF_TAPC_VISAOVR,
   parameter STAP_WIDTH_OF_TAPC_REMOVE                    = (STAP_SIZE_OF_TAPC_REMOVE == 0) ? 1 :
                                                             STAP_SIZE_OF_TAPC_REMOVE,
   parameter STAP_NUMBER_OF_TAPS                          = (STAP_ENABLE_TAP_NETWORK  == 0) ? 1 : (STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK == 0) ? 1 :
                                                             STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK,
   parameter STAP_NUMBER_OF_WTAPS                         = (STAP_ENABLE_WTAP_NETWORK == 0) ? 1 : (STAP_NUMBER_OF_WTAPS_IN_NETWORK == 0) ? 1 :
                                                            (STAP_WTAP_NETWORK_ONE_FOR_SERIES_ZERO_FOR_PARALLEL == 1) ? 1 :
                                                             STAP_NUMBER_OF_WTAPS_IN_NETWORK,
   parameter STAP_NUMBER_OF_TAPS_MULTIPLY_BY_2            = STAP_NUMBER_OF_TAPS * 2,
   parameter STAP_WTAP_COMMON_LOGIC                       = (STAP_ENABLE_TAP_NETWORK    == 1) ? 1 :
                                                            (STAP_ENABLE_WTAP_NETWORK   == 1) ? 1 : 0,
   parameter STAP_COUNT_OF_TAPC_VISAOVR_REGISTERS         = STAP_ENABLE_TAPC_VISAOVR,
   parameter STAP_WIDTH_OF_TAPC_VISAOVR_ADDRESS           = (STAP_ENABLE_TAPC_VISAOVR == 1) ? 10 : 0,
   parameter STAP_WIDTH_OF_TAPC_VISAOVR_DATA              = (STAP_ENABLE_TAPC_VISAOVR == 0) ? 1 :
                                                            (STAP_WIDTH_OF_TAPC_VISAOVR - STAP_WIDTH_OF_TAPC_VISAOVR_ADDRESS),
   parameter STAP_NUMBER_OF_TAPC_VISAOVR_REGISTERS        = (STAP_ENABLE_TAPC_VISAOVR == 0) ? 1 :
                                                             STAP_DEPTH_OF_TAPC_VISAOVR_REGISTERS,
   parameter STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS_NZ = (STAP_ENABLE_REMOTE_TEST_DATA_REGISTERS == 0) ? 1 : 
                                                            STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS
   )
   (
   // // -----------------------------------------------------------------
   // // Primary JTAG ports
   // // -----------------------------------------------------------------
   // ftap_tck,           // Primary TAP port clock source from PAD originating
   //                     // from an agent or misc IO (HardIP).
   // ftap_tms,           // Primary TAP port mode select from PAD originating
   //                     // from an agent or misc IO (HardIP).
   // ftap_trst_b,        // Primary TAP port reset from PAD originating from an
   //                     // agent or misc IO (HardIP).
   // ftap_tdi,           // Primary TAP port data source from PAD originating
   //                     // from an agent or misc IO (HardIP).
   // ftap_vercode,       // The version code (ftap_vercode[3:0]) originates from
   //                     // the centralized metal strap block elsewhere in the
   //                     // component (but assumed to be in the fabric).
   // ftap_slvidcode,     // Slave TAP strap value. Default value to load on
   //                     // capture (strap base).
   //                     // Internally LSB will be connected to 1.
   // atap_tdo,           // Primary TAP port dataout to PAD (agent or misc
   //                     // IO (HardIP))
   // atap_tdoen,         // Primary TAP port dataout enable to agent or misc
   //                     // IO (HardIP)
   // powergoodrst_b,     // When asserted ('0')  all sticky flops are in reset.
   //                     // When de-asserted the trst_b decides when all flops
   //                     // are out of reset.
   // atap_vercode, // Version code fanout to TAP Network
   // // -----------------------------------------------------------------
   // // Parallel ports of optional data registers
   // // -----------------------------------------------------------------
   // tdr_data_out, // Concatenated dataout for all the optional
   //               // test data registers.
   // tdr_data_in,  // Concatenated datain for all the optional
   //               // test data registers.
   // tapc_visaovr, // Select signal for VISA mux. This could be
   //               // for either Unit, Central or Final mux
   // // -----------------------------------------------------------------
   // // DFX Secure signals
   // // -----------------------------------------------------------------
   // dfxsecurestrap_feature, // This strap is required by all agents. If there are
   //                         // no customer visible lanes on the VISA for this
   //                         // agent then the straps are grounded.
   //                         // The minimum values allowed are the following:
   //                         // NumOfFeatureToSecure = 1
   //                         // DfxSecureWidth = 2
   // ftap_dfxsecure,         // This signal bus is distributed through the TAP network
   //                         // (fabric) to all agents to allow levels of
   //                         // accessibility to specific debug and validation features.
   //                         // It may also be used to unlock/lock TAP opcodes.
   //                         // 0x0: All DFx features within the agent are disabled.
   //                         // 01b: Assigned to VISA and OMAR customer DFV feature
   //                         // enable. This value may be re-purposed for other
   //                         // DFx features but it is required to also enable the VISA
   //                         // and OMAR features.
   //                         // Others: These codes are agent and system architecture
   //                         // dependent and not defined within this specification.
   //                         // 111..11b: All DFx features are available for access.
   //                         // The ftap_dfxsecure[DfxSecureWidth-1:2] is implementation
   //                         // specific codes.
   // atap_dfxsecure,         // ftap_dfxsecure goes out as this signal. No other logic
   //                         // involved. This signal bus is available as an
   //                         // output from a security or fuse block is an agent on the
   //                         // IOSF fabric to source the security
   //                         // information which is distributed throughout the fabric
   //                         // (specifically the TAP network).
   // dfxsecure_all_en,       // This output gets asserted when ftap_dfxsecure is equal to {N{1'b1}}
   // dfxsecure_all_dis,      // This output gets asserted when ftap_dfxsecure is equal to {N{1'b0}}
   // dfxsecure_feature_en,   // This output gets asserted when ftap_dfxsecure is equal
                              // to dfxsecurestrap_feature or when ftap_dfxsecure is equal to {N{1'b1}}
   // vodfv_all_dis,          // This output gets asserted when dfxsecure_all_dis is asserted
   // vodfv_customer_dis,     // This output gets asserted when dfxsecure_all_dis is asserted or
   //                         // when dfxsecure_all_en is deasserted and dfxsecure_feature_en[0]
                              // (VISA) is asserted
   // // -----------------------------------------------------------------
   // // Control signals to Slave TAPNetwork
   // // -----------------------------------------------------------------
   // sftapnw_ftap_secsel,   // This signal controls which TAP on the network
   //                 // will be connected to the secondary TAP port.
   // sftapnw_ftap_enabletdo, // Based on the mode in which the selected TAP is
   //                 // configured, this signal enables the TDO.
   // sftapnw_ftap_enabletap, // This signal is used to exclude, decouple, shadow
   //                 // or allow normal scan operations with other
   //                 // TAPs in the fabric or within an agent.
   // // -----------------------------------------------------------------
   // // Primary JTAG ports to Slave TAPNetwork
   // // -----------------------------------------------------------------
   // sntapnw_ftap_tck,   // TAP Network TCK clock source originating from the
   //              // primary TAP port.
   // sntapnw_ftap_tms,   // TAP Network mode select originating from the primary
   //              // TAP port.
   // sntapnw_ftap_trst_b, // TAP Network TRST_b source  originating from the
   //              // primary TAP port.
   // sntapnw_ftap_tdi,   // Serial data TDI going into the TAP Network originating
   //              // from the STAP.
   // sntapnw_atap_tdo,   // Serial Data TDO coming from TAP Network or this TAP.
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
   //                // secondary TAP port.
   // sntapnw_ftap_tms2,    // TAP Network TMS clock source originating from the
   //                // secondary TAP port.
   // sntapnw_ftap_trst2_b,  // TAP Network TRST_b clock source originating from
   //                // the secondary TAP port.
   // sntapnw_ftap_tdi2,    // Serial data TDI going into the TAP Network
   //                // originating from the secondary TAP port.
   // sntapnw_atap_tdo2,    // Serial Data TDO coming from TAP Network originating
   //                // from the secondary TAP port.
   // sntapnw_atap_tdo2_en, // Secondary TAP port dataout enable coming from the
   //                // TAPNW to this TAP.
   // // -----------------------------------------------------------------
   // // Control and data signals connected to single WTAP directly to TAP
   // // -----------------------------------------------------------------
   // stap_selectwir, // TAP controller FSM outputs from STAP to access
   //                 // IR & DR's within the WTAP.
   // stap_wso,       // Data input from a single WTAP connected directly
   // stap_wsi,       // Data output to a single WTAP connected directly
   // // -----------------------------------------------------------------
   // // Control Signals common to WTAP/WTAP Network
   // // -----------------------------------------------------------------
   // sn_fwtap_wrck,      // Clock to the WTAP or WTAP Network.
   // sn_fwtap_wrst_b,    // Reset to the WTAP or WTAP Network.
   // sn_fwtap_capturewr, // TAP controller FSM outputs from STAP to capture
   //                 // the values of IR & DR's within the WTAP.
   // sn_fwtap_shiftwr,   // TAP controller FSM outputs from STAP to shift the
   //                 // values of IR & DR's within the WTAP.
   // sn_fwtap_updatewr,  // TAP controller FSM outputs from STAP to update
   //                 // IR & DR's within the WTAP.
   // sn_fwtap_rti,       // TAP controller FSM output to WTAP.
   // // -----------------------------------------------------------------
   // // Control Signals only to WTAP Network
   // // -----------------------------------------------------------------
   // sn_fwtap_selectwir, // TAP controller FSM outputs to control
   //                        // the WTAP Network.
   // sn_awtap_wso,       // Data input from WTAP Network
   // sn_fwtap_wsi,       // Data output to WTAP Network
   // // -----------------------------------------------------------------
   // // Boundary Scan Signals
   // // -----------------------------------------------------------------
   // // Control Signals from fsm
   // // -----------------------------------------------------------------
   // stap_fbscan_tck,       // fabric boundary scan test clock
   // stap_fbscan_tdo,       // fabric boundary scan test data output
   // stap_fbscan_capturedr, // fabric boundary scan capture-dr signal
   // stap_fbscan_shiftdr,   // fabric boundary scan shift-dr signal
   // stap_fbscan_updatedr,  // fabric boundary scan update-dr signal
   // // -----------------------------------------------------------------
   // // Instructions
   // // -----------------------------------------------------------------
   // stap_fbscan_runbist_en,        // runbist select signal
   // stap_fbscan_highz,      // fabric boundary scan highz select
   // stap_fbscan_extogen,    // when active indicates that the Slave fbscan
   //                    // EXTEST_TOGGLE is enabled and will be active
   //                    // if stap_fbscan_chainen = 1'b1
   // stap_fbscan_chainen,    // fabric boundary scan select. When asserted
   //                    // select the boundary scan select signals.
   // stap_fbscan_mode,       // when stap_fbscan_chainen=1, this signal indicates
   //                    // that Slave TAP is performing the following
   //                    // on the Slave TAP
   //                    // 1'b0 --- SAMPLE/PRELOAD is active
   //                    // 1'b1 --- EXTEST is active
   // stap_fbscan_extogsig_b, // Provide the toggling signal source when Slave
   //                    // TAP enables EXTEST_TOGGLE
   // // -----------------------------------------------------------------
   // // 1149.6 AC mode
   // // -----------------------------------------------------------------
   // stap_fbscan_d6init,        // Boundary-scan 1149.6 test receiver initialization
   // stap_fbscan_d6actestsig_b, // Combined ac test waveform, to bscan cells for
   //                       // pins supporting extest_toggle and Dot6.
   // stap_fbscan_d6select       // Boundary-scan 1149.6 AC mode, Asserted during
   //                       // EXTEST_TRAIN / PULSE
   // // -----------------------------------------------------------------
   // // Router  for TAP network
   // // -----------------------------------------------------------------
   // atap_subtapactv,
   // // -----------------------------------------------------------------
   // // Remote Test data register
   // // -----------------------------------------------------------------
   // rtdr_tap_ip_clk_i,      // Clock on which remote test data register is running. Needed in TAP for synchronization
   // rtdr_tap_tdo,           // Serial Output of remote data register coming back to TAP.  
   // tap_rtdr_tdi,           // Serial input to remote test data register from TAP. 
   // tap_rtdr_capture,       // Capture dr will be high, when the specific Instruction is selected
   // tap_rtdr_shift,         // Shift dr will be high, when the specific Instruction is selected
   // tap_rtdr_update,        // Update dr will be high, when the specific Instruction is selected
   // tap_rtdr_powergoodrst_b // To clear the Remote test data register. Note this is single bit, all remote data register need to connect this.
   // tap_rtdr_irdec          // To indicate the instructions register value of specific Remote TDR
   // tap_rtdr_selectir       // Just like how sn_fwtap_selectwir in WTAPNW is used, similar is the intention for RTDR.
   // tap_rtdr_tck            // Output pass thru tap clock for RTDR on TCK domain. 
   // tap_rtdr_rti            // FSM RUTI state is selected
   // -----------------------------------------------------------------
   // Primary JTAG ports
   // -----------------------------------------------------------------
   input  logic                                   ftap_tck,
   input  logic                                   ftap_tms,
   input  logic                                   ftap_trst_b,
   input  logic                                   ftap_tdi,
   input  logic [(STAP_WIDTH_OF_VERCODE - 1):0]   ftap_vercode,
   input  logic [(STAP_WIDTH_OF_SLVIDCODE - 1):0] ftap_slvidcode,
   output logic                                   atap_tdo,
   output logic                                   atap_tdoen,
//   input  logic                                   powergood_rst_b,
//kbbhagwa hsd2904751 reverting back due to valley and avoton contradiction
   input  logic                                   powergoodrst_b, 
   output logic [(STAP_WIDTH_OF_VERCODE - 1):0]   atap_vercode,
   // -----------------------------------------------------------------
   // Parallel ports of optional data registers
   // -----------------------------------------------------------------
   output logic [(STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS - 1):0] tdr_data_out,
   input  logic [(STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS - 1):0] tdr_data_in,
   output logic [(STAP_NUMBER_OF_TAPC_VISAOVR_REGISTERS - 1):0]
                [(STAP_WIDTH_OF_TAPC_VISAOVR_DATA - 1):0]         tapc_visaovr,
   // -----------------------------------------------------------------
   // DFX Secure signals
   // -----------------------------------------------------------------
   input  logic [(STAP_NUMBER_OF_DFX_FEATURES_TO_SECURE - 1):0]
                [(STAP_DFX_SECURE_WIDTH - 1):0]                 dfxsecurestrap_feature,
   input  logic [(STAP_DFX_SECURE_WIDTH - 1):0]                 ftap_dfxsecure,
   output logic [(STAP_DFX_SECURE_WIDTH - 1):0]                 atap_dfxsecure,
   output logic                                                 dfxsecure_all_en,
   output logic                                                 dfxsecure_all_dis,
   output logic [(STAP_NUMBER_OF_DFX_FEATURES_TO_SECURE - 1):0] dfxsecure_feature_en,
   output logic                                                 vodfv_all_dis,
   output logic                                                 vodfv_customer_dis,
   // -----------------------------------------------------------------
   // Control signals to Slave TAPNetwork
   // -----------------------------------------------------------------
   output logic [(STAP_NUMBER_OF_TAPS - 1):0] sftapnw_ftap_secsel,
   output logic [(STAP_NUMBER_OF_TAPS - 1):0] sftapnw_ftap_enabletdo,
   output logic [(STAP_NUMBER_OF_TAPS - 1):0] sftapnw_ftap_enabletap,
   // -----------------------------------------------------------------
   // Primary JTAG ports to Slave TAPNetwork
   // -----------------------------------------------------------------
   output logic                               sntapnw_ftap_tck,
   output logic                               sntapnw_ftap_tms,
   output logic                               sntapnw_ftap_trst_b,
   output logic                               sntapnw_ftap_tdi,
   input  logic                               sntapnw_atap_tdo,
   input  logic [(STAP_NUMBER_OF_TAPS - 1):0] sntapnw_atap_tdo_en,
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
   // Secondary JTAG ports to Slave TAPNetwork
   // -----------------------------------------------------------------
   output logic                               sntapnw_ftap_tck2,
   output logic                               sntapnw_ftap_tms2,
   output logic                               sntapnw_ftap_trst2_b,
   output logic                               sntapnw_ftap_tdi2,
   input  logic                               sntapnw_atap_tdo2,
   input  logic [(STAP_NUMBER_OF_TAPS - 1):0] sntapnw_atap_tdo2_en,
   // -----------------------------------------------------------------
   // Control and data signals connected to single WTAP directly to TAP
   // -----------------------------------------------------------------
   //output logic stap_selectwir,
   //input  logic stap_wso,
   //output logic stap_wsi,
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
   output logic                                sn_fwtap_selectwir,
   input  logic [(STAP_NUMBER_OF_WTAPS - 1):0] sn_awtap_wso,
   output logic [(STAP_NUMBER_OF_WTAPS - 1):0] sn_fwtap_wsi,
   // -----------------------------------------------------------------
   // Boundary Scan Signals
   // -----------------------------------------------------------------
   // Control Signals from fsm
   // -----------------------------------------------------------------
   output logic stap_fbscan_tck,
   input  logic stap_fbscan_tdo,
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
   output logic stap_fbscan_chainen,
   output logic stap_fbscan_mode,
   output logic stap_fbscan_extogsig_b,
   // -----------------------------------------------------------------
   // 1149.6 AC mode
   // -----------------------------------------------------------------
   output logic stap_fbscan_d6init,
   output logic stap_fbscan_d6actestsig_b,
   output logic stap_fbscan_d6select,
   // -----------------------------------------------------------------
   // Sub Tap Control logic
   // -----------------------------------------------------------------
   input  logic [(STAP_NUMBER_OF_TAPS - 1):0] stapnw_atap_subtapactvi,
   output logic atap_subtapactv,
   // -----------------------------------------------------------------
   // Remote Test data register
   // -----------------------------------------------------------------
   input  logic [(STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS_NZ - 1):0] rtdr_tap_ip_clk_i,
   input  logic [(STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS_NZ - 1):0] rtdr_tap_tdo,
   output logic [(STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS_NZ - 1):0] tap_rtdr_tdi,
   output logic [(STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS_NZ - 1):0] tap_rtdr_capture,
   output logic [(STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS_NZ - 1):0] tap_rtdr_shift,
   output logic [(STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS_NZ - 1):0] tap_rtdr_update,
   output logic [(STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS_NZ - 1):0] tap_rtdr_irdec,
   output logic                                                        tap_rtdr_powergoodrst_b,
   output logic                                                        tap_rtdr_selectir,
   output logic                                                        tap_rtdr_tck,//kbbhagwa collage tool compliance 
   output logic                                                        tap_rtdr_rti
   );

   // *********************************************************************
   // Internal Signals
   // *********************************************************************
   logic                                                         stap_fsm_capture_dr_nxt; //kbbhagwa cdc fix
   logic                                                         stap_fsm_update_dr_nxt;

   logic    stap_selectwir_neg; //kbbhagwa posedge negedge signal merge
   logic    stap_fsm_shift_ir_neg; //kbbhagwa posedge negedge signal merge




   logic                                                         stap_fsm_tlrs;
   logic                                                         stap_fsm_rti;
   logic                                                         stap_fsm_e1dr;
   logic                                                         stap_fsm_e2dr;
   logic                                                         stap_fsm_capture_ir;
   logic                                                         stap_fsm_shift_ir;
   logic                                                         stap_fsm_update_ir;
   logic                                                         stap_fsm_capture_dr;
   logic                                                         stap_fsm_shift_dr;
   logic                                                         stap_fsm_update_dr;
   logic [(STAP_SIZE_OF_EACH_INSTRUCTION - 1):0]                 stap_irreg_ireg;
   logic [(STAP_SIZE_OF_EACH_INSTRUCTION - 1):0]                 stap_irreg_ireg_nxt; //kbbhagwa cdc fix
   logic                                                         stap_irreg_serial_out;
   logic [(STAP_NUMBER_OF_TOTAL_REGISTERS - 1):0]                stap_drreg_drout;
   logic [(STAP_NUMBER_OF_TOTAL_REGISTERS - 1):0]                stap_irdecoder_drselect;
   logic                                                         stap_and_all_bits_irreg;
   logic                                                         stap_or_all_bits_irreg;
   logic [((STAP_NUMBER_OF_TAPS * 2) - 1):0]                     tapc_select;
   logic [(STAP_NUMBER_OF_WTAPS - 1):0]                          tapc_wtap_sel;
   logic                                                         tapc_remove;
   logic                                                         stap_mux_tdo;
   logic                                                         pre_tdo;
   logic                                                         stap_wtapnw_tdo;
   logic                                                         powergoodrst_trst_b;
   logic                                                         stap_tdomux_tdoen;
   logic [(STAP_SIZE_OF_EACH_INSTRUCTION - 1):0]                 stap_irreg_shift_reg;
   logic                                                         linr_hier_tapnw_tdo;
   logic                                                         tapnw_tdo_NC;
   logic                                                         stap_selectwir;
   logic [(STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS_NZ - 1):0]  rtdr_tap_ip_clk_i_NC;
   logic                                                         atap_subtapactv_tapnw;
   //logic                                                         stap_fsm_shift_dr_neg;
//kbbhagwa collage tool compliance
   //assign tap_rtdr_tck = ftap_tck;
   sipstap_ctech_clkbf i_sipstap_ctech_clkbf_rtdr (.o_clk(tap_rtdr_tck), .in_clk(ftap_tck));

   // *********************************************************************
   // FSM instantiation
   // *********************************************************************
   stap_fsm #(
              .FSM_STAP_ENABLE_TAP_NETWORK                 (STAP_ENABLE_TAP_NETWORK),
              .FSM_STAP_WTAP_COMMON_LOGIC                  (STAP_WTAP_COMMON_LOGIC),
              .FSM_STAP_ENABLE_REMOTE_TEST_DATA_REGISTERS  (STAP_ENABLE_REMOTE_TEST_DATA_REGISTERS)
             )  
   i_stap_fsm (
               .ftap_tms               (ftap_tms),
               .ftap_tck               (ftap_tck),
               .powergoodrst_trst_b    (powergoodrst_trst_b),
               .tapc_remove            (tapc_remove),
               .stap_fsm_tlrs          (stap_fsm_tlrs),
               .stap_fsm_rti           (stap_fsm_rti),
               .stap_fsm_e1dr          (stap_fsm_e1dr),
               .stap_fsm_e2dr          (stap_fsm_e2dr),
               .stap_selectwir         (stap_selectwir),
               .stap_selectwir_neg     (stap_selectwir_neg), //kbbhagwa posedge negedge signal merge
               .sn_fwtap_capturewr     (sn_fwtap_capturewr),
               .sn_fwtap_shiftwr       (sn_fwtap_shiftwr),
               .sn_fwtap_updatewr      (sn_fwtap_updatewr),
               .sn_fwtap_rti           (sn_fwtap_rti),
               .sn_fwtap_wrst_b        (sn_fwtap_wrst_b),
               .stap_fsm_capture_ir    (stap_fsm_capture_ir),
               .stap_fsm_shift_ir      (stap_fsm_shift_ir),
               .stap_fsm_shift_ir_neg  (stap_fsm_shift_ir_neg), //kbbhagwa
               .stap_fsm_update_ir     (stap_fsm_update_ir),
               .stap_fsm_capture_dr    (stap_fsm_capture_dr),
               .stap_fsm_capture_dr_nxt(stap_fsm_capture_dr_nxt), //kbbhagwa cdc fix
               .stap_fsm_shift_dr      (stap_fsm_shift_dr),
               //.stap_fsm_shift_dr_neg  (stap_fsm_shift_dr_neg), //kbbhagwa hsd2904953 posneg rtdr
               .stap_fsm_update_dr_nxt (stap_fsm_update_dr_nxt), //kbbhagwa cdc fix
               .stap_fsm_update_dr     (stap_fsm_update_dr)
              );

   // *********************************************************************
   // Instruction Reg instantiation
   // *********************************************************************
   stap_irreg #(
                .IRREG_STAP_SIZE_OF_EACH_INSTRUCTION       (STAP_SIZE_OF_EACH_INSTRUCTION),
                .IRREG_STAP_INSTRUCTION_FOR_DATA_REGISTERS (STAP_INSTRUCTION_FOR_DATA_REGISTERS),
                .IRREG_STAP_MINIMUM_SIZEOF_INSTRUCTION     (STAP_MINIMUM_SIZEOF_INSTRUCTION)
               )
   i_stap_irreg (
                 .stap_fsm_tlrs         (stap_fsm_tlrs),
                 .stap_fsm_capture_ir   (stap_fsm_capture_ir),
                 .stap_fsm_shift_ir     (stap_fsm_shift_ir),
                 .stap_fsm_update_ir    (stap_fsm_update_ir),
                 .ftap_tdi              (ftap_tdi),
                 .ftap_tck              (ftap_tck),
                 .powergoodrst_trst_b   (powergoodrst_trst_b),
                 .stap_irreg_ireg       (stap_irreg_ireg),
                 .stap_irreg_ireg_nxt   (stap_irreg_ireg_nxt), //kbbhagwa cdc fix
                 .stap_irreg_serial_out (stap_irreg_serial_out),
                 .stap_irreg_shift_reg  (stap_irreg_shift_reg)
                );

   // *********************************************************************
   // IR decoder instantiation
   // *********************************************************************
   stap_irdecoder #(
                    .IRDECODER_STAP_SIZE_OF_EACH_INSTRUCTION       (STAP_SIZE_OF_EACH_INSTRUCTION),
                    .IRDECODER_STAP_NUMBER_OF_TOTAL_REGISTERS      (STAP_NUMBER_OF_TOTAL_REGISTERS),
                    .IRDECODER_STAP_INSTRUCTION_FOR_DATA_REGISTERS (STAP_INSTRUCTION_FOR_DATA_REGISTERS),
                    .IRDECODER_STAP_ADDRESS_OF_CLAMP               (STAP_ADDRESS_OF_CLAMP),
                    .IRDECODER_STAP_MINIMUM_SIZEOF_INSTRUCTION     (STAP_MINIMUM_SIZEOF_INSTRUCTION),
                    .IRDECODER_STAP_ENABLE_BSCAN                   (STAP_ENABLE_BSCAN)
                   )
   i_stap_irdecoder (
                     .powergoodrst_trst_b     (powergoodrst_trst_b),
                     .stap_irreg_ireg         (stap_irreg_ireg),
                     .stap_irreg_ireg_nxt     (stap_irreg_ireg_nxt), // kbbhagwa cdc fix
                     .ftap_tck                (ftap_tck), //kbbhagwa cdc fix
                     .stap_irdecoder_drselect (stap_irdecoder_drselect),
                     .stap_and_all_bits_irreg (stap_and_all_bits_irreg),
                     .stap_or_all_bits_irreg  (stap_or_all_bits_irreg)
                    );

   // *********************************************************************
   // Data Register Implementation
   // *********************************************************************
   stap_drreg #(
                .DRREG_STAP_ENABLE_VERCODE                            (STAP_ENABLE_VERCODE),
                .DRREG_STAP_ENABLE_TEST_DATA_REGISTERS                (STAP_ENABLE_TEST_DATA_REGISTERS),
                .DRREG_STAP_ENABLE_TAPC_VISAOVR                       (STAP_ENABLE_TAPC_VISAOVR),
                .DRREG_STAP_ENABLE_TAPC_REMOVE                        (STAP_ENABLE_TAPC_REMOVE),
                .DRREG_STAP_WIDTH_OF_SLVIDCODE                        (STAP_WIDTH_OF_SLVIDCODE),
                .DRREG_STAP_WIDTH_OF_VERCODE                          (STAP_WIDTH_OF_VERCODE),
                .DRREG_STAP_NUMBER_OF_TOTAL_REGISTERS                 (STAP_NUMBER_OF_TOTAL_REGISTERS),
                .DRREG_STAP_NUMBER_OF_MANDATORY_REGISTERS             (STAP_NUMBER_OF_MANDATORY_REGISTERS),
                .DRREG_STAP_NUMBER_OF_BITS_FOR_SLICE                  (STAP_NUMBER_OF_BITS_FOR_SLICE),
                .DRREG_STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS        (STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS),
                .DRREG_STAP_SIZE_OF_EACH_TEST_DATA_REGISTER           (STAP_SIZE_OF_EACH_TEST_DATA_REGISTER),
                .DRREG_STAP_LSB_VALUES_OF_TEST_DATA_REGISTERS         (STAP_LSB_VALUES_OF_TEST_DATA_REGISTERS),
                .DRREG_STAP_MSB_VALUES_OF_TEST_DATA_REGISTERS         (STAP_MSB_VALUES_OF_TEST_DATA_REGISTERS),
                .DRREG_STAP_RESET_VALUES_OF_TEST_DATA_REGISTERS       (STAP_RESET_VALUES_OF_TEST_DATA_REGISTERS),
                .DRREG_STAP_BIT_ONE_FOR_TDRDATAIN_ZERO_FOR_TDRDATAOUT (STAP_BIT_ONE_FOR_TDRDATAIN_ZERO_FOR_TDRDATAOUT),
                .DRREG_STAP_NUMBER_OF_TAP_NETWORK_REGISTERS           (STAP_NUMBER_OF_TAP_NETWORK_REGISTERS),
                .DRREG_STAP_NUMBER_OF_TAPS                            (STAP_NUMBER_OF_TAPS),
                .DRREG_STAP_NUMBER_OF_WTAPS                           (STAP_NUMBER_OF_WTAPS),
                .DRREG_STAP_WIDTH_OF_TAPC_VISAOVR                     (STAP_WIDTH_OF_TAPC_VISAOVR),
                .DRREG_STAP_WIDTH_OF_TAPC_REMOVE                      (STAP_WIDTH_OF_TAPC_REMOVE),
                .DRREG_STAP_NUMBER_OF_WTAP_NETWORK_REGISTERS          (STAP_NUMBER_OF_WTAP_NETWORK_REGISTERS),
                .DRREG_STAP_ENABLE_TAPC_SEC_SEL                       (STAP_ENABLE_TAPC_SEC_SEL),
                .DRREG_STAP_ENABLE_WTAP_NETWORK                       (STAP_ENABLE_WTAP_NETWORK),
                .DRREG_STAP_ENABLE_TAP_NETWORK                        (STAP_ENABLE_TAP_NETWORK),
                .DRREG_STAP_COUNT_OF_TAPC_VISAOVR_REGISTERS           (STAP_COUNT_OF_TAPC_VISAOVR_REGISTERS),
                .DRREG_STAP_NUMBER_OF_TAPC_REMOVE_REGISTERS           (STAP_NUMBER_OF_TAPC_REMOVE_REGISTERS),
                .DRREG_STAP_NUMBER_OF_PRELOAD_REGISTERS               (STAP_NUMBER_OF_PRELOAD_REGISTERS),
                .DRREG_STAP_NUMBER_OF_CLAMP_REGISTERS                 (STAP_NUMBER_OF_CLAMP_REGISTERS),
                //.DRREG_STAP_NUMBER_OF_USERCODE_REGISTERS            (STAP_NUMBER_OF_USERCODE_REGISTERS),
                .DRREG_STAP_NUMBER_OF_INTEST_REGISTERS                (STAP_NUMBER_OF_INTEST_REGISTERS),
                .DRREG_STAP_NUMBER_OF_RUNBIST_REGISTERS               (STAP_NUMBER_OF_RUNBIST_REGISTERS),
                .DRREG_STAP_NUMBER_OF_EXTEST_TOGGLE_REGISTERS         (STAP_NUMBER_OF_EXTEST_TOGGLE_REGISTERS),
                .DRREG_STAP_NUMBER_OF_TAPS_MULTIPLY_BY_2              (STAP_NUMBER_OF_TAPS_MULTIPLY_BY_2),
                .DRREG_STAP_ENABLE_BSCAN                              (STAP_ENABLE_BSCAN),
                .DRREG_STAP_NUMBER_OF_TAP_SELECT_REGISTERS            (STAP_NUMBER_OF_TAP_SELECT_REGISTERS),
                .DRREG_STAP_WIDTH_OF_TAPC_VISAOVR_ADDRESS             (STAP_WIDTH_OF_TAPC_VISAOVR_ADDRESS),
                .DRREG_STAP_WIDTH_OF_TAPC_VISAOVR_DATA                (STAP_WIDTH_OF_TAPC_VISAOVR_DATA),
                .DRREG_STAP_NUMBER_OF_TAPC_VISAOVR_REGISTERS          (STAP_NUMBER_OF_TAPC_VISAOVR_REGISTERS),
                .DRREG_STAP_NUMBER_OF_TEST_DATA_REGISTERS             (STAP_NUMBER_OF_TEST_DATA_REGISTERS),
                .DRREG_STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS_NZ   (STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS_NZ),
                .DRREG_STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS      (STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS),
                .DRREG_STAP_ENABLE_REMOTE_TEST_DATA_REGISTERS         (STAP_ENABLE_REMOTE_TEST_DATA_REGISTERS),
                .DRREG_STAP_ENABLE_SYNCHRONIZER_FOR_REMOTE_TDR        (STAP_ENABLE_SYNCHRONIZER_FOR_REMOTE_TDR)
               )
   i_stap_drreg (
                 .stap_fsm_tlrs           (stap_fsm_tlrs),
                 .ftap_tdi                (ftap_tdi),
                 .ftap_tck                (ftap_tck),
//                 .powergoodrst_b        (powergood_rst_b), 
                 .powergoodrst_b          (powergoodrst_b), 
//kbbhagwa hsd2904751 reverting back
//https://vthsd.intel.com/hsd/seg_softip/default.aspx#bug/default.aspx?bug_id=2904751
                 .powergoodrst_trst_b     (powergoodrst_trst_b),
                 .stap_fsm_capture_dr     (stap_fsm_capture_dr),
                 .stap_fsm_capture_dr_nxt (stap_fsm_capture_dr_nxt), //kbbhagwa cdc fix
                 .stap_fsm_shift_dr       (stap_fsm_shift_dr),
                 //.stap_fsm_shift_dr_neg   (stap_fsm_shift_dr_neg),//kbbhagwa hsd2904953 posneg rtdr
                 .stap_fsm_update_dr      (stap_fsm_update_dr),
                 .stap_fsm_update_dr_nxt  (stap_fsm_update_dr_nxt), //kbbhagwa cdc fix
                 .stap_selectwir          (stap_selectwir),
                 .ftap_vercode            (ftap_vercode),
                 .ftap_slvidcode          (ftap_slvidcode),
                 .stap_irdecoder_drselect (stap_irdecoder_drselect),
                 .tdr_data_in             (tdr_data_in),
                 .tdr_data_out            (tdr_data_out),
                 .sftapnw_ftap_secsel     (sftapnw_ftap_secsel),
                 .tapc_select             (tapc_select),
                 .tapc_wtap_sel           (tapc_wtap_sel),
                 .tapc_visaovr            (tapc_visaovr),
                 .tapc_remove             (tapc_remove),
                 .stap_drreg_drout        (stap_drreg_drout),
                 .stap_and_all_bits_irreg (stap_and_all_bits_irreg),
                 .stap_or_all_bits_irreg  (stap_or_all_bits_irreg),
                 .rtdr_tap_ip_clk_i       (rtdr_tap_ip_clk_i),
                 .rtdr_tap_tdo            (rtdr_tap_tdo),
                 .tap_rtdr_tdi            (tap_rtdr_tdi),
                 .tap_rtdr_capture        (tap_rtdr_capture),
                 .tap_rtdr_shift          (tap_rtdr_shift),
                 .tap_rtdr_update         (tap_rtdr_update),
                 .tap_rtdr_irdec          (tap_rtdr_irdec),
                 .tap_rtdr_powergoodrst_b (tap_rtdr_powergoodrst_b),
                 .tap_rtdr_rti            (tap_rtdr_rti),
                 .tap_rtdr_selectir       (tap_rtdr_selectir),
                 .stap_fsm_rti            (stap_fsm_rti)
                );

   // *********************************************************************
   // TDO mux implementation
   // *********************************************************************
   stap_tdomux #(
                 .TDOMUX_STAP_NUMBER_OF_TOTAL_REGISTERS (STAP_NUMBER_OF_TOTAL_REGISTERS)
                )
   i_stap_tdomux (
                  .stap_drreg_drout        (stap_drreg_drout),
                  .stap_fsm_shift_dr       (stap_fsm_shift_dr),
                  .stap_fsm_shift_ir       (stap_fsm_shift_ir),
                  .stap_irdecoder_drselect (stap_irdecoder_drselect),
                  .stap_irreg_serial_out   (stap_irreg_serial_out),
                  .stap_fsm_tlrs           (stap_fsm_tlrs),
                  .ftap_tck                (ftap_tck),
                  .powergoodrst_trst_b     (powergoodrst_trst_b),
                  .stap_mux_tdo            (stap_mux_tdo),
                  .stap_tdomux_tdoen       (stap_tdomux_tdoen)
                 );

   // *********************************************************************
   // TAP network implementation
   // *********************************************************************
   generate
      if (STAP_ENABLE_TAP_NETWORK == 1)
      begin:generate_stap_tapnw
         stap_tapnw #(
                      .TAPNW_STAP_NUMBER_OF_TAPS        (STAP_NUMBER_OF_TAPS),
                      .TAPNW_STAP_NUMBER_OF_WTAPS       (STAP_NUMBER_OF_WTAPS)
                     )
         i_stap_tapnw (
                       //.stap_selectwir           (stap_selectwir),
                       .stap_selectwir_neg       (stap_selectwir_neg), //kbbhagwa posedge negedge signal merge
                       .tapc_select              (tapc_select),
                       .sftapnw_ftap_enabletdo   (sftapnw_ftap_enabletdo),
                       .sftapnw_ftap_enabletap   (sftapnw_ftap_enabletap),
                       .stapnw_atap_subtapactvi  (stapnw_atap_subtapactvi),
                       .atap_subtapactv_tapnw    (atap_subtapactv_tapnw)
                      );
      end
      else
      begin:generate_stap_tapnw
         assign sftapnw_ftap_enabletdo[0]  = LOW;
         assign sftapnw_ftap_enabletap[0]  = LOW;
         assign atap_subtapactv_tapnw      = LOW;
         logic  stapnw_subtapactvi_NC;
         assign stapnw_subtapactvi_NC = stapnw_atap_subtapactvi;
      end
   endgenerate

   // *********************************************************************
   // WTAP network implementation
   // *********************************************************************
   generate
      if (STAP_ENABLE_WTAP_NETWORK == 1)
      begin:generate_stap_wtapnw
         stap_wtapnw #(
                       .WTAPNW_STAP_NUMBER_OF_TAPS               (STAP_NUMBER_OF_TAPS),
                       .WTAPNW_STAP_NUMBER_OF_WTAPS              (STAP_NUMBER_OF_WTAPS),
                       .WTAPNW_STAP_NUMBER_OF_TAPS_MULTIPLY_BY_2 (STAP_NUMBER_OF_TAPS_MULTIPLY_BY_2)
                      )
         i_stap_wtapnw (
                        .stap_mux_tdo              (stap_mux_tdo),
                        .stap_selectwir            (stap_selectwir),
                        .sn_awtap_wso              (sn_awtap_wso),
                        .tapc_wtap_sel             (tapc_wtap_sel),
                        .tapc_select               (tapc_select),
                        .sn_fwtap_selectwir        (sn_fwtap_selectwir),
                        .sn_fwtap_wsi              (sn_fwtap_wsi),
                        .stap_wtapnw_tdo           (stap_wtapnw_tdo),
                        .atap_subtapactv_tapnw     (atap_subtapactv_tapnw),
                        .atap_subtapactv           (atap_subtapactv)
                       );
      end
      else
      begin
         assign sn_fwtap_wsi[0]       = HIGH;
         assign sn_fwtap_selectwir    = LOW;
         assign stap_wtapnw_tdo       = HIGH;
         assign atap_subtapactv       = atap_subtapactv_tapnw;
      end
   endgenerate

   // *********************************************************************
   // Linear network vs Hierarchical Network. Loopback of network side tdi/tdo for Linear.
   // *********************************************************************

   generate
      if (STAP_ENABLE_LINEAR_NETWORK == 1)
      begin:generate_loopback_tapnwtdi
         assign linr_hier_tapnw_tdo      = sntapnw_ftap_tdi;
         assign tapnw_tdo_NC             = sntapnw_atap_tdo;
      end
      else
      begin
         assign linr_hier_tapnw_tdo      = sntapnw_atap_tdo;
      end
   endgenerate
   // *********************************************************************
   // Glue logic implementation
   // *********************************************************************
   stap_glue #(
               .GLUE_STAP_ENABLE_TAP_NETWORK       (STAP_ENABLE_TAP_NETWORK),
               .GLUE_STAP_ENABLE_WTAP_NETWORK      (STAP_ENABLE_WTAP_NETWORK),
               .GLUE_STAP_WIDTH_OF_VERCODE         (STAP_WIDTH_OF_VERCODE),
               .GLUE_STAP_NUMBER_OF_TAPS           (STAP_NUMBER_OF_TAPS),
               .GLUE_STAP_NUMBER_OF_WTAPS          (STAP_NUMBER_OF_WTAPS),
               .GLUE_STAP_SIZE_OF_EACH_INSTRUCTION (STAP_SIZE_OF_EACH_INSTRUCTION),
               .GLUE_STAP_WTAP_COMMON_LOGIC        (STAP_WTAP_COMMON_LOGIC),
               .GLUE_STAP_ENABLE_TAPC_REMOVE       (STAP_ENABLE_TAPC_REMOVE),
               .GLUE_STAP_ENABLE_LINEAR_NETWORK    (STAP_ENABLE_LINEAR_NETWORK)
              )
   i_stap_glue (
                .ftap_tck                   (ftap_tck),
                .ftap_tms                   (ftap_tms),
                .ftap_trst_b                (ftap_trst_b),
//              .powergoodrst_b             (powergood_rst_b), //kbbhagwa hsd2904751 reverting back
                .powergoodrst_b             (powergoodrst_b),
                .ftap_tdi                   (ftap_tdi),
                .ftap_vercode               (ftap_vercode),
                .stap_tdomux_tdoen          (stap_tdomux_tdoen),
                .sntapnw_atap_tdo_en        (sntapnw_atap_tdo_en),
                .atap_vercode               (atap_vercode),
                .pre_tdo                    (pre_tdo),
                .powergoodrst_trst_b        (powergoodrst_trst_b),
                .atap_tdoen                 (atap_tdoen),
                .sntapnw_ftap_tck           (sntapnw_ftap_tck),
                .sntapnw_ftap_tms           (sntapnw_ftap_tms),
                .sntapnw_ftap_trst_b        (sntapnw_ftap_trst_b),
                .sntapnw_ftap_tdi           (sntapnw_ftap_tdi),
                //.sntapnw_atap_tdo         (sntapnw_atap_tdo),
                .sntapnw_atap_tdo           (linr_hier_tapnw_tdo),
                .ftapsslv_tck               (ftapsslv_tck),
                .ftapsslv_tms               (ftapsslv_tms),
                .ftapsslv_trst_b            (ftapsslv_trst_b),
                .ftapsslv_tdi               (ftapsslv_tdi),
                .atapsslv_tdo               (atapsslv_tdo),
                .atapsslv_tdoen             (atapsslv_tdoen),
                .sntapnw_ftap_tck2          (sntapnw_ftap_tck2),
                .sntapnw_ftap_tms2          (sntapnw_ftap_tms2),
                .sntapnw_ftap_trst2_b       (sntapnw_ftap_trst2_b),
                .sntapnw_ftap_tdi2          (sntapnw_ftap_tdi2),
                .sntapnw_atap_tdo2          (sntapnw_atap_tdo2),
                .sntapnw_atap_tdo2_en       (sntapnw_atap_tdo2_en),
                //.stap_wso                 (stap_wso),
                //.stap_wsi                 (stap_wsi),
                .sn_fwtap_wrck              (sn_fwtap_wrck),
                .stap_mux_tdo               (stap_mux_tdo),
                .tapc_select                (tapc_select),
                .tapc_wtap_sel              (tapc_wtap_sel),
                .tapc_remove                (tapc_remove),
                .stap_wtapnw_tdo            (stap_wtapnw_tdo)
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
                      //.BSCAN_STAP_NUMBER_OF_USERCODE_REGISTERS    (STAP_NUMBER_OF_USERCODE_REGISTERS),
                      .BSCAN_STAP_NUMBER_OF_INTEST_REGISTERS        (STAP_NUMBER_OF_INTEST_REGISTERS),
                      .BSCAN_STAP_NUMBER_OF_RUNBIST_REGISTERS       (STAP_NUMBER_OF_RUNBIST_REGISTERS),
                      .BSCAN_STAP_NUMBER_OF_EXTEST_TOGGLE_REGISTERS (STAP_NUMBER_OF_EXTEST_TOGGLE_REGISTERS)
                     )
         i_stap_bscan (
                       .ftap_tck                  (ftap_tck),
                       .powergoodrst_trst_b       (powergoodrst_trst_b),
                       .stap_fsm_tlrs             (stap_fsm_tlrs),
                       .stap_fsm_rti              (stap_fsm_rti),
                       .stap_fsm_e1dr             (stap_fsm_e1dr),
                       .stap_fsm_e2dr             (stap_fsm_e2dr),
                       .atap_tdo                  (atap_tdo),
                       .pre_tdo                   (pre_tdo),
                       .stap_fbscan_tck           (stap_fbscan_tck),
                       .stap_fbscan_tdo           (stap_fbscan_tdo),
                       .stap_fbscan_capturedr     (stap_fbscan_capturedr),
                       .stap_fbscan_shiftdr       (stap_fbscan_shiftdr),
                       .stap_fbscan_updatedr      (stap_fbscan_updatedr),
                       .stap_fbscan_updatedr_clk  (stap_fbscan_updatedr_clk),
                       .stap_fbscan_runbist_en    (stap_fbscan_runbist_en),
                       .stap_fbscan_highz         (stap_fbscan_highz),
                       .stap_fbscan_extogen       (stap_fbscan_extogen),
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
      begin
         assign atap_tdo             = pre_tdo;
         assign stap_fbscan_tck           = LOW;
         assign stap_fbscan_capturedr     = LOW;
         assign stap_fbscan_shiftdr       = LOW;
         assign stap_fbscan_updatedr      = LOW;
         assign stap_fbscan_updatedr_clk  = LOW;
         assign stap_fbscan_runbist_en    = LOW;
         assign stap_fbscan_highz         = LOW;
         assign stap_fbscan_extogen       = LOW;
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
   stap_dfxsecure #(
                    .DFXSECURE_STAP_NUMBER_OF_DFX_FEATURES_TO_SECURE (STAP_NUMBER_OF_DFX_FEATURES_TO_SECURE),
                    .DFXSECURE_STAP_DFX_SECURE_WIDTH                 (STAP_DFX_SECURE_WIDTH)
                   )
   i_stap_dfxsecure (
                     .dfxsecurestrap_feature (dfxsecurestrap_feature),
                     .ftap_dfxsecure         (ftap_dfxsecure),
                     .atap_dfxsecure         (atap_dfxsecure),
                     .dfxsecure_all_en       (dfxsecure_all_en),
                     .dfxsecure_all_dis      (dfxsecure_all_dis),
                     .dfxsecure_feature_en   (dfxsecure_feature_en),
                     .vodfv_all_dis          (vodfv_all_dis),
                     .vodfv_customer_dis     (vodfv_customer_dis)
                    );


   // *********************************************************************
   // Logic to be removed in next release
   // *********************************************************************
   // FIXME
   assign rtdr_tap_ip_clk_i_NC     = rtdr_tap_ip_clk_i;


   // Assertions and coverage
// Assertions and coverage
// kbbhagwa  `include "stap_include.sv"
//https://vthsd.intel.com/hsd/seg_softip/ar/default.aspx?ar_id=240053
`ifndef DFX_FPV_ENABLE
   // synopsys translate_off
`endif

   // Assertions and coverage
   `include "stap_include.sv"

`ifndef DFX_FPV_ENABLE
   // synopsys translate_on
`endif

   
endmodule
