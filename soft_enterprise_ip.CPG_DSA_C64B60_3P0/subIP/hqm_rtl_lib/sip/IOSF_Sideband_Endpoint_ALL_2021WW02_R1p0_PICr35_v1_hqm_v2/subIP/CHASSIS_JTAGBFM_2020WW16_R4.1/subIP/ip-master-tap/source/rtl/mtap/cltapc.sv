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
//  Module <mTAP> :  < put your functional description here in plain text >
//
//------------------------------------------------------------------------------

//----------------------------------------------------------------------
// Intel Proprietary -- Copyright 2009 Intel -- All rights reserved
//----------------------------------------------------------------------
// NOTE: Log history is at end of file.
//----------------------------------------------------------------------
//
//    FILENAME    : cltapc.sv
//    DESIGNER    : Sunjiv Sachan
//    PROJECT     : CLTAPC
//    
//    
//    PURPOSE     : CLTAPC Top Level
//    DESCRIPTION :
//       This is top module and integrates all the required modules.
//    BUGS/ISSUES/ECN FIXES:
//       HSD2901763 - 03MAY2010
//       TDO Enable is not generated when mtap is removed (CLTAPC REMOVE = 1)
//       Added new port cntapnw_atap_tdo_en. Implemented logic select tdoen between 
//       local fsm and tapnw tdoen.
//----------------------------------------------------------------------
//    LOCAL PARAMETERS:
//
//    HIGH
//       This is 1 bit one value
//
//    LOW
//       This is 1 bit zero value
//
//    MTAP_WIDTH_OF_IDCODE
//       This defines width of IDCODE. This is used to create pins at top level.
//
//    MTAP_WIDTH_OF_VERCODE
//       This is the width of ftap_vercode pins. These are strap values from SoC.
//
//    MTAP_MINIMUM_SIZEOF_INSTRUCTION
//       This minumum size of instruction supported in our design.
//
//    MTAP_ADDRESS_OF_CLAMP
//       This is address of optional Clamp register. It is used in two different
//       modules and hence declared in top module.
//
//    MTAP_WIDTH_OF_CLTAPC_VISAOVR
//       This is width of Visa select override register. This value defaults to
//       one if MTAP_SIZE_OF_CLTAPC_VISAOVR is zero.
//
//    MTAP_WIDTH_OF_CLTAPC_REMOVE
//       This is width of remove register. This value defaults to
//       one if MTAP_SIZE_OF_CLTAPC_REMOVE is zero.
//
//    MTAP_NUMBER_OF_TAPS
//       This specifes number of taps in 0.7 network. This value defaults to one
//       if MTAP_NUMBER_OF_TAPS_IN_TAP_NETWORK is zero.
//
//    MTAP_NUMBER_OF_WTAPS
//       This specifes number of wtaps in wtap network. This value defaults to one
//       if MTAP_NUMBER_OF_WTAPS_IN_NETWORK is zero or wtap network connection is
//       series.
//
//    MTAP_NUMBER_OF_TAPS_MULTIPLY_BY_2
//       This specifies width of select and select_ovr registers.
//
//    MTAP_WTAP_COMMON_LOGIC
//       This is to generated common signals when wtap is connected directly or
//       wtapnw is enabled
//----------------------------------------------------------------------
// *********************************************************************
// Defines
// *********************************************************************
`include "mtap_defines_include.inc"

module cltapc #(
              // *********************************************************************
              // Parameters and local params
              // *********************************************************************
              `include "mtap_params_include.inc"

              parameter MTAP_WIDTH_OF_VERCODE                        = 4,
              parameter MTAP_WIDTH_OF_IDCODE                         = 32,
              parameter HIGH                                         = 1'b1,
              parameter LOW                                          = 1'b0,
              parameter MTAP_MINIMUM_SIZEOF_INSTRUCTION              = 8,
              parameter MTAP_ADDRESS_OF_CLAMP                        = (MTAP_SIZE_OF_EACH_INSTRUCTION == 8) ? 8'h04 :
                 {{(MTAP_SIZE_OF_EACH_INSTRUCTION - MTAP_MINIMUM_SIZEOF_INSTRUCTION + 4){LOW}}, 4'h4},
              parameter MTAP_WIDTH_OF_CLTAPC_VISAOVR                 = (MTAP_ENABLE_CLTAPC_VISAOVR == 0) ? 1 :
                                                                        MTAP_SIZE_OF_CLTAPC_VISAOVR,
              parameter MTAP_WIDTH_OF_CLTAPC_REMOVE                  = (MTAP_SIZE_OF_CLTAPC_REMOVE == 0) ? 1 :
                                                                        MTAP_SIZE_OF_CLTAPC_REMOVE,
              parameter MTAP_NUMBER_OF_TAPS                          = (MTAP_ENABLE_TAP_NETWORK    == 0) ? 1 : (MTAP_NUMBER_OF_TAPS_IN_TAP_NETWORK == 0) ? 1 :
                                                                        MTAP_NUMBER_OF_TAPS_IN_TAP_NETWORK,
              parameter MTAP_NUMBER_OF_WTAPS                         = (MTAP_ENABLE_WTAP_NETWORK   == 0) ? 1 : (MTAP_NUMBER_OF_WTAPS_IN_NETWORK == 0) ? 1 :
                                                                       (MTAP_WTAP_NETWORK_ONE_FOR_SERIES_ZERO_FOR_PARALLEL == 1) ? 1 :
                                                                        MTAP_NUMBER_OF_WTAPS_IN_NETWORK,
              parameter MTAP_NUMBER_OF_TAPS_MULTIPLY_BY_2            = MTAP_NUMBER_OF_TAPS * 2,
              parameter MTAP_WTAP_COMMON_LOGIC                       = (MTAP_ENABLE_TAP_NETWORK    == 1) ? 1 :
                                                                       (MTAP_ENABLE_WTAP_NETWORK   == 1) ? 1 : 0,
              parameter MTAP_COUNT_OF_CLTAPC_VISAOVR_REGISTERS       = MTAP_ENABLE_CLTAPC_VISAOVR,
              parameter MTAP_WIDTH_OF_CLTAPC_VISAOVR_ADDRESS         = (MTAP_ENABLE_CLTAPC_VISAOVR == 1) ? 10 : 0,
              parameter MTAP_WIDTH_OF_CLTAPC_VISAOVR_DATA            = (MTAP_ENABLE_CLTAPC_VISAOVR == 0) ? 1 :
                                                                       (MTAP_WIDTH_OF_CLTAPC_VISAOVR -
                                                                        MTAP_WIDTH_OF_CLTAPC_VISAOVR_ADDRESS),
              parameter MTAP_NUMBER_OF_CLTAPC_VISAOVR_REGISTERS      = (MTAP_ENABLE_CLTAPC_VISAOVR == 0) ? 1 :
                                                                        MTAP_DEPTH_OF_CLTAPC_VISAOVR_REGISTERS,
              parameter MTAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS_NZ = (MTAP_ENABLE_REMOTE_TEST_DATA_REGISTERS == 0) ? 1 : 
                                                                        MTAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS
             )
             (
              // // -----------------------------------------------------------------
              // // Primary JTAG ports
              // // -----------------------------------------------------------------
              // atappris_tck,       // Primary TAP port clock source from PAD originating
              //                     // from an agent or misc IO (HardIP).
              // atappris_tms,       // Primary TAP port mode select from PAD originating
              //                     // from an agent or misc IO (HardIP).
              // atappris_trst_b,    // Primary TAP port reset from PAD originating from an
              //                     // agent or misc IO (HardIP).
              // atappris_tdi,       // Primary TAP port data source from PAD originating
              //                     // from an agent or misc IO (HardIP).
              // ftap_vercode,            // The version code (ftap_vercode[3:0]) originates from
              //                     // the centralized metal strap block elsewhere in the
              //                     // component (but assumed to be in the fabric).
              // ftap_idcode,             // Master Tap strap value. Default value to load on
              //                     // capture (strap base).
              //                     // Internally LSB will be connected to 1.
              // ftappris_tdo,       // Primary TAP port dataout to PAD (agent or misc
              //                     // IO (HardIP))
              // ftappris_tdoen,     // Primary TAP port dataout enable to agent or misc
              //                     // IO (HardIP)
              // powergoodrst_b,     // When asserted ('0') all sticky flops are in reset.
              //                     // When de-asserted the trst_b decides when all flops
              //                     // are out of reset.
              // atap_vercode, // Version code fanout to TAP network
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
              // // DFX secure signals
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
              //                         // 0x0: All DFx features within the agent are either
              //                         // disabled or usable.
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
              // dfxsecure_feature_en,   // This output gets asserted when ftap_dfxsecure is equal to dfxsecurestrap_feature
              //                         // or when ftap_dfxsecure is equal to {N{1'b1}}
              // vodfv_all_dis,          // This output gets asserted when dfxsecure_all_dis is asserted
              // vodfv_customer_dis,     // This output gets asserted when dfxsecure_all_dis is asserted or
              //                         // when dfxsecure_all_en is deasserted and dfxsecure_feature_en[0] (VISA) is asserted
              // // -----------------------------------------------------------------
              // // Control signals to Slave TAPNetwork
              // // -----------------------------------------------------------------
              // cftapnw_ftap_secsel,   // This signal controls which TAP on the network
              //                   // will be connected to the secondary TAP port.
              // cftapnw_ftap_enabletdo, // Based on the mode in which the selected TAP is
              //                   // configured, this signal enables the TDO.
              // cftapnw_ftap_enabletap, // This signal is used to exclude, decouple, shadow
              //                   // or allow normal scan operations with other
              //                   // TAPs in the fabric or within an agent.
              // // -----------------------------------------------------------------
              // // Primary JTAG ports to Slave TAPNetwork
              // // -----------------------------------------------------------------
              // cntapnw_ftap_tck,   // Tap Network TCK clock source originating from the
              //              // primary TAP port.
              // cntapnw_ftap_tms,   // Tap Network mode select originating from the primary
              //              // TAP port.
              // cntapnw_ftap_trst_b, // Tap Network TRST_b source  originating from the
              //              // primary TAP port.
              // cntapnw_ftap_tdi,   // Serial data TDI going into the Tap Network originating
              //              // from the MTAP.
              // cntapnw_atap_tdo,   // Serial Data TDO coming from Tap Network or this TAP.
              // // -----------------------------------------------------------------
              // // Secondary JTAG ports
              // // -----------------------------------------------------------------
              // atapsecs_tck,  // Secondary TAP port clock source from PAD
              //                 // originating from an agent or misc IO (HardIP).
              // atapsecs_tms,  // Secondary TAP port mode select from PAD originating
              //                 // from an agent or misc IO (HardIP).
              // atapsecs_trst_b,        // Secondary TAP port reset from PAD originating from
              //                 // an agent or misc IO (HardIP).
              // atapsecs_tdi,  // Secondary TAP port data source from PAD originating
              //                 // from an agent or misc IO (HardIP).
              // ftapsecs_tdo,  // Secondary TAP port dataout to PAD (agent or misc
              //                 // IO (HardIP))
              // ftapsecs_tdoen, // Secondary TAP port dataout enable to agent or misc
              //                 // IO (HardIP) wiring from cntapnw_atap_tdo2_en
              // // -----------------------------------------------------------------
              // // Secondary JTAG ports to Slave TAPNetwork
              // // -----------------------------------------------------------------
              // cntapnw_ftap_tck2,    // Tap Network TCK clock source originating from the
              //                // secondary TAP port.
              // cntapnw_ftap_tms2,    // Tap Network TMS clock source originating from the
              //                // secondary TAP port.
              // cntapnw_ftap_trst2_b,  // Tap Network TRST_b clock source originating from
              //                // the secondary TAP port.
              // cntapnw_ftap_tdi2,    // Serial data TDI going into the Tap Network
              //                // originating from the secondary TAP port.
              // cntapnw_atap_tdo2,    // Serial Data TDO coming from Tap Network originating
              //                // from the secondary TAP port.
              // cntapnw_atap_tdo2_en, // Secondary TAP port dataout enable coming from the
              //                // TAPNW to this TAP.
              // // -----------------------------------------------------------------
              // // Control and data signals connected to single WTAP directly to TAP
              // // -----------------------------------------------------------------
              // mtap_selectwir, //TAP controller FSM outputs from Slave TAP to access
              //                 //IR & DR's within the WTAP.
              // mtap_wso,       //Data input from a single WTAP connected directly
              // mtap_wsi,       //Data output to a single WTAP connected directly
              // // -----------------------------------------------------------------
              // // Control Signals  common to WTAP/WTAP Network
              // // -----------------------------------------------------------------
              // cn_fwtap_wrck,      // Clock to the WTAP or WTAP Network.
              // cn_fwtap_wrst_b,    // Reset to the WTAP or WTAP Network.
              // cn_fwtap_capturewr, // TAP controller FSM outputs from Slave TAP to capture
              //                 // the values of IR & DR's within the WTAP.
              // cn_fwtap_shiftwr,   // TAP controller FSM outputs from Slave TAP to shift the
              //                 // values of IR & DR's within the WTAP.
              // cn_fwtap_updatewr,  // TAP controller FSM outputs from Slave TAP to update
              //                 // IR & DR's within the WTAP.
              // cn_fwtap_rti,       // TAP controller FSM output to WTAP.
              // // -----------------------------------------------------------------
              // // Control Signals only to WTAP Network
              // // -----------------------------------------------------------------
              // cn_fwtap_selectwir, // TAP controller FSM outputs to control
              //                        // the WTAP Network.
              // cn_awtap_wso,       // Data input from WTAP Network
              // cn_fwtap_wsi,       // Data output to WTAP Network
              // // -----------------------------------------------------------------
              // // Boundary Scan Signals
              // // -----------------------------------------------------------------
              // // Control Signals from fsm
              // // -----------------------------------------------------------------
              // fbscan_tck,       // fabric boundary scan test clock
              // fbscan_tdo,       // fabric boundary scan test data output
              // fbscan_capturedr, // fabric boundary scan capture-dr signal
              // fbscan_shiftdr,   // fabric boundary scan shift-dr signal
              // fbscan_updatedr,  // fabric boundary scan update-dr signal
              // // -----------------------------------------------------------------
              // // Instructions
              // // -----------------------------------------------------------------
              // fbscan_runbist_en,        // runbist select signal
              // fbscan_highz,      // fabric boundary scan highz select
              // fbscan_extogen,    // when active indicates that the master fbscan
              //                    // EXTEST_TOGGLE is enabled and will be active
              //                    // if fbscan_chainen = 1'b1
              // fbscan_chainen,    // fabric boundary scan select. When asserted
              //                    // select the boundary scan select signals.
              // fbscan_mode,       // when fbscan_chainen=1, this signal indicates
              //                    // that master tap is performing the following
              //                    // on the slave tap
              //                    //  1'b0 --- SAMPLE/PRELOAD is active
              //                    //  1'b1 --- EXTEST is active
              // fbscan_extogsig_b, // Provide the toggling signal source when master
              //                    // TAP enables EXTEST_TOGGLE
              // // -----------------------------------------------------------------
              // // 1149.6 AC mode
              // // -----------------------------------------------------------------
              // fbscan_d6init,        // Boundary-scan 1149.6 test receiver initialization
              // fbscan_d6actestsig_b, // Combined ac test waveform, to bscan cells for
              //                       // pins supporting extest_toggle and Dot6.
              // fbscan_d6select       // Boundary-scan 1149.6 AC mode, Asserted during
              //                       // EXTEST_TRAIN / PULSE
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
              // tap_rtdr_selectir       // Just like how sn_fwtap_selectwir in WTAPNW is used, similar is the intention for RTDR.
              // tap_rtdr_tck            // Output pass thru tap clock for RTDR on TCK domain. 
              // tap_rtdr_irdec          // To indicate the instructions register value of specific Remote TDR
              // tap_rtdr_rti            // FSM RUTI state is selected
              // *********************************************************************
              // Primary JTAG ports
              // *********************************************************************
              input  logic                                 atappris_tck,
              input  logic                                 atappris_tms,
              input  logic                                 atappris_trst_b,
              input  logic                                 atappris_tdi,
              input  logic [(MTAP_WIDTH_OF_VERCODE - 1):0] ftap_vercode,
              input  logic [(MTAP_WIDTH_OF_IDCODE - 1):0]  ftap_idcode,
              output logic                                 ftappris_tdo,
              output logic                                 ftappris_tdoen,
//              input  logic                                 powergood_rst_b,
              input  logic                                 powergoodrst_b,
              //kbbhagwa hsd2904751 , revertingb back for valley view
              //https://vthsd.intel.com/hsd/seg_softip/default.aspx#bug/default.aspx?bug_id=2904751
              output logic [(MTAP_WIDTH_OF_VERCODE - 1):0] atap_vercode,
              // *********************************************************************
              // Parallel ports of optional data registers
              // *********************************************************************
              output logic [(MTAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS - 1):0] tdr_data_out,
              input  logic [(MTAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS - 1):0] tdr_data_in,
              output logic [(MTAP_NUMBER_OF_CLTAPC_VISAOVR_REGISTERS - 1):0]
                           [(MTAP_WIDTH_OF_CLTAPC_VISAOVR_DATA - 1):0]       tapc_visaovr,
              // *********************************************************************
              // Lock signals
              // *********************************************************************
              input  logic [(MTAP_NUMBER_OF_DFX_FEATURES_TO_SECURE - 1):0]
                           [(MTAP_DFX_SECURE_WIDTH - 1):0]                 dfxsecurestrap_feature,
              input  logic [(MTAP_DFX_SECURE_WIDTH - 1):0]                 ftap_dfxsecure,
              output logic [(MTAP_DFX_SECURE_WIDTH - 1):0]                 atap_dfxsecure,
              output logic                                                 dfxsecure_all_en,
              output logic                                                 dfxsecure_all_dis,
              output logic [(MTAP_NUMBER_OF_DFX_FEATURES_TO_SECURE - 1):0] dfxsecure_feature_en,
              output logic                                                 vodfv_all_dis,
              output logic                                                 vodfv_customer_dis,
              // *********************************************************************
              // Control signals to 0.7 TAPNetwork
              // *********************************************************************
              output logic [(MTAP_NUMBER_OF_TAPS - 1):0] cftapnw_ftap_secsel,
              output logic [(MTAP_NUMBER_OF_TAPS - 1):0] cftapnw_ftap_enabletdo,
              output logic [(MTAP_NUMBER_OF_TAPS - 1):0] cftapnw_ftap_enabletap,
              // *********************************************************************
              // Primary JTAG ports to 0.7 TAPNetwork
              // *********************************************************************
              output logic                               cntapnw_ftap_tck,
              output logic                               cntapnw_ftap_tms,
              output logic                               cntapnw_ftap_trst_b,
              output logic                               cntapnw_ftap_tdi,
              input  logic                               cntapnw_atap_tdo,
              input  logic [(MTAP_NUMBER_OF_TAPS - 1):0] cntapnw_atap_tdo_en,
              // *********************************************************************
              // Secondary JTAG ports
              // *********************************************************************
              input  logic atapsecs_tck,
              input  logic atapsecs_tms,
              input  logic atapsecs_trst_b,
              input  logic atapsecs_tdi,
              output logic ftapsecs_tdo,
              output logic ftapsecs_tdoen,
              // *********************************************************************
              // Secondary JTAG ports to 0.7 TAPNetwork
              // *********************************************************************
              output logic                               cntapnw_ftap_tck2,
              output logic                               cntapnw_ftap_tms2,
              output logic                               cntapnw_ftap_trst2_b,
              output logic                               cntapnw_ftap_tdi2,
              input  logic                               cntapnw_atap_tdo2,
              input  logic [(MTAP_NUMBER_OF_TAPS - 1):0] cntapnw_atap_tdo2_en,
              // *********************************************************************
              // Control Signals only to WTAP
              // *********************************************************************
              // output logic mtap_selectwir,
              // input  logic mtap_wso,
              // output logic mtap_wsi,
              // *********************************************************************
              // Control Signals  common to WTAP/WTAP Network
              // *********************************************************************
              output logic cn_fwtap_wrck,
              output logic cn_fwtap_wrst_b,
              output logic cn_fwtap_capturewr,
              output logic cn_fwtap_shiftwr,
              output logic cn_fwtap_updatewr,
              output logic cn_fwtap_rti,
              // *********************************************************************
              // Control Signals only to WTAP Network
              // *********************************************************************
              output logic                                cn_fwtap_selectwir,
              input  logic [(MTAP_NUMBER_OF_WTAPS - 1):0] cn_awtap_wso,
              output logic [(MTAP_NUMBER_OF_WTAPS - 1):0] cn_fwtap_wsi,
              // *********************************************************************
              // Boundary Scan Signals
              // *********************************************************************
              // Control Signals from fsm
              // ---------------------------------------------------------------------
              output logic fbscan_tck,
              input  logic fbscan_tdo,
              output logic fbscan_capturedr,
              output logic fbscan_shiftdr,
              output logic fbscan_updatedr,
              output logic fbscan_updatedr_clk,
              // ---------------------------------------------------------------------
              // Instructions
              // ---------------------------------------------------------------------
              output logic fbscan_runbist_en,
              output logic fbscan_highz,
              output logic fbscan_extogen,
              output logic fbscan_chainen,
              output logic fbscan_mode,
              output logic fbscan_extogsig_b,
              // ---------------------------------------------------------------------
              // 1149.6 AC mode
              // ---------------------------------------------------------------------
              output logic fbscan_d6init,
              output logic fbscan_d6actestsig_b,
              output logic fbscan_d6select,
              // -----------------------------------------------------------------
              // Router  for TAP network
              // -----------------------------------------------------------------
              input  logic [(MTAP_NUMBER_OF_TAPS - 1):0] ctapnw_atap_subtapactvi,  // For all hierarchical subnetworks, tie this to LOW
                                                  // For Linear network topology, connect this to tapnw_subtapactive pin of the TAPNW
              // -----------------------------------------------------------------
              // Remote Test data register
              // -----------------------------------------------------------------
              input  logic [(MTAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS_NZ - 1):0] rtdr_tap_ip_clk_i,
              input  logic [(MTAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS_NZ - 1):0] rtdr_tap_tdo,
              output logic [(MTAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS_NZ - 1):0] tap_rtdr_tdi,
              output logic [(MTAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS_NZ - 1):0] tap_rtdr_capture,
              output logic [(MTAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS_NZ - 1):0] tap_rtdr_shift,
              output logic [(MTAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS_NZ - 1):0] tap_rtdr_update,
              output logic [(MTAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS_NZ - 1):0] tap_rtdr_irdec,
              output logic                                                        tap_rtdr_powergoodrst_b,
              output logic                                                        tap_rtdr_selectir,
              output logic                                                        tap_rtdr_tck, //kbbhagwa : for collage purpose,
              output logic                                                        tap_rtdr_rti
            );

   // *********************************************************************
   // Internal Signals
   // *********************************************************************
   logic                                                         mtap_fsm_capture_dr_nxt; //kbbhagwa cdc fix
   logic                                                         mtap_fsm_update_dr_nxt; //kbbhagwa cdc fix

   logic    mtap_fsm_shift_ir_neg;//kbbhagwa posedge negedge signal merge
   logic    mtap_selectwir_neg;//kbbhagwa posedge negedge signal merge




   logic                                                         mtap_fsm_tlrs;
   logic                                                         mtap_fsm_rti;
   logic                                                         mtap_fsm_e1dr;
   logic                                                         mtap_fsm_e2dr;
   logic                                                         mtap_fsm_capture_ir;
   logic                                                         mtap_fsm_shift_ir;
   logic                                                         mtap_fsm_update_ir;
   logic                                                         mtap_fsm_capture_dr;
   logic                                                         mtap_fsm_shift_dr;
   logic                                                         mtap_fsm_update_dr;
   logic [(MTAP_SIZE_OF_EACH_INSTRUCTION - 1):0]                 mtap_irreg_ireg;
   logic [(MTAP_SIZE_OF_EACH_INSTRUCTION - 1):0]                 mtap_irreg_ireg_nxt; //kbbhagwa cdc fix
   logic                                                         mtap_irreg_serial_out;
   logic [(MTAP_NUMBER_OF_TOTAL_REGISTERS - 1):0]                mtap_drreg_drout;
   logic [(MTAP_NUMBER_OF_TOTAL_REGISTERS - 1):0]                mtap_irdecoder_drselect;
   logic                                                         mtap_and_all_bits_irreg;
   logic                                                         mtap_or_all_bits_irreg;
   logic [((MTAP_NUMBER_OF_TAPS * 2) - 1):0]                     cltapc_select;
   logic [((MTAP_NUMBER_OF_TAPS * 2) - 1):0]                     cltapc_select_ovr;
   logic [(MTAP_NUMBER_OF_WTAPS - 1):0]                          cltapc_wtap_sel;
   logic                                                         cltapc_remove;
   logic                                                         mtap_mux_tdo;
   logic                                                         pre_tdo;
   logic                                                         mtap_wtapnw_tdo;
   logic                                                         powergoodrst_trst_b;
   logic                                                         mtap_tdomux_tdoen;
   logic [(MTAP_SIZE_OF_EACH_INSTRUCTION - 1):0]                 mtap_irreg_shift_reg;
   logic                                                         linr_hier_tapnw_tdo;
   logic                                                         tapnw_tdo_NC;
   logic                                                         mtap_selectwir;
   logic [(MTAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS_NZ - 1):0]  rtdr_tap_ip_clk_i_NC;
   logic [((MTAP_NUMBER_OF_TAPS ) - 1):0]                        ctapnw_subtapactvi_NC;

   //assign tap_rtdr_tck = atappris_tck; //kbbhagwa, for collage
   sipcltapc_ctech_clkbf i_sipcltapc_ctech_clkbf_rtdr (.o_clk(tap_rtdr_tck), .in_clk(atappris_tck));

   // *********************************************************************
   // FSM instantiation
   // *********************************************************************
   mtap_fsm #(
              .FSM_MTAP_ENABLE_TAP_NETWORK                 (MTAP_ENABLE_TAP_NETWORK),
              .FSM_MTAP_WTAP_COMMON_LOGIC                  (MTAP_WTAP_COMMON_LOGIC),
              .FSM_MTAP_ENABLE_REMOTE_TEST_DATA_REGISTERS  (MTAP_ENABLE_REMOTE_TEST_DATA_REGISTERS)
             )
   i_mtap_fsm (
               .atappris_tms            (atappris_tms),
               .atappris_tck            (atappris_tck),
               .powergoodrst_trst_b     (powergoodrst_trst_b),
               .cltapc_remove           (cltapc_remove),
               .mtap_fsm_tlrs           (mtap_fsm_tlrs),
               .mtap_fsm_rti            (mtap_fsm_rti),
               .mtap_fsm_e1dr           (mtap_fsm_e1dr),
               .mtap_fsm_e2dr           (mtap_fsm_e2dr),
               .mtap_selectwir          (mtap_selectwir),
               .mtap_selectwir_neg      (mtap_selectwir_neg),//kbbhagwa posedge negedge signal merge
               .cn_fwtap_capturewr      (cn_fwtap_capturewr),
               .cn_fwtap_shiftwr        (cn_fwtap_shiftwr),
               .cn_fwtap_updatewr       (cn_fwtap_updatewr),
               .cn_fwtap_rti            (cn_fwtap_rti),
               .cn_fwtap_wrst_b         (cn_fwtap_wrst_b),
               .mtap_fsm_capture_ir     (mtap_fsm_capture_ir),
               .mtap_fsm_shift_ir       (mtap_fsm_shift_ir),
               .mtap_fsm_shift_ir_neg   (mtap_fsm_shift_ir_neg),//kbbhagwa posedge negedge signal merge
               .mtap_fsm_update_ir      (mtap_fsm_update_ir),
               .mtap_fsm_capture_dr     (mtap_fsm_capture_dr),
               .mtap_fsm_capture_dr_nxt (mtap_fsm_capture_dr_nxt), //kbbhagwa cdc fix
               .mtap_fsm_shift_dr       (mtap_fsm_shift_dr),
               //.mtap_fsm_shift_dr_neg   (mtap_fsm_shift_dr_neg), //kbbhagwa hsd2904953
               .mtap_fsm_update_dr      (mtap_fsm_update_dr),
               .mtap_fsm_update_dr_nxt  (mtap_fsm_update_dr_nxt) //kbbhagwa cdc fix

              );

   // *********************************************************************
   // Instruction Reg instantiation
   // *********************************************************************
   mtap_irreg #(
                .IRREG_MTAP_SIZE_OF_EACH_INSTRUCTION       (MTAP_SIZE_OF_EACH_INSTRUCTION),
                .IRREG_MTAP_INSTRUCTION_FOR_DATA_REGISTERS (MTAP_INSTRUCTION_FOR_DATA_REGISTERS),
                .IRREG_MTAP_MINIMUM_SIZEOF_INSTRUCTION     (MTAP_MINIMUM_SIZEOF_INSTRUCTION)
               )
   i_mtap_irreg (
                 .mtap_fsm_tlrs         (mtap_fsm_tlrs),
                 .mtap_fsm_capture_ir   (mtap_fsm_capture_ir),
                 .mtap_fsm_shift_ir     (mtap_fsm_shift_ir),
                 .mtap_fsm_update_ir    (mtap_fsm_update_ir),
                 .atappris_tdi          (atappris_tdi),
                 .atappris_tck          (atappris_tck),
                 .powergoodrst_trst_b   (powergoodrst_trst_b),
                 .mtap_irreg_ireg       (mtap_irreg_ireg),
                 .mtap_irreg_ireg_nxt   (mtap_irreg_ireg_nxt), //kbbhagwa cdc fix
                 .mtap_irreg_serial_out (mtap_irreg_serial_out),
                 .mtap_irreg_shift_reg  (mtap_irreg_shift_reg)
                );

   // *********************************************************************
   // IR decoder instantiation
   // *********************************************************************
   mtap_irdecoder #(
                    .IRDECODER_MTAP_SIZE_OF_EACH_INSTRUCTION       (MTAP_SIZE_OF_EACH_INSTRUCTION),
                    .IRDECODER_MTAP_NUMBER_OF_TOTAL_REGISTERS      (MTAP_NUMBER_OF_TOTAL_REGISTERS),
                    .IRDECODER_MTAP_INSTRUCTION_FOR_DATA_REGISTERS (MTAP_INSTRUCTION_FOR_DATA_REGISTERS),
                    .IRDECODER_MTAP_ADDRESS_OF_CLAMP               (MTAP_ADDRESS_OF_CLAMP),
                    .IRDECODER_MTAP_MINIMUM_SIZEOF_INSTRUCTION     (MTAP_MINIMUM_SIZEOF_INSTRUCTION)
                   )
   i_mtap_irdecoder (
                     .powergoodrst_trst_b     (powergoodrst_trst_b),
                     .atappris_tck            (atappris_tck), //kbbhagwa cdc fix
                     .mtap_irreg_ireg_nxt     (mtap_irreg_ireg_nxt), //kbbhagwa cdc fix
                     .mtap_irreg_ireg         (mtap_irreg_ireg),
                     .mtap_irdecoder_drselect (mtap_irdecoder_drselect),
                     .mtap_and_all_bits_irreg (mtap_and_all_bits_irreg),
                     .mtap_or_all_bits_irreg  (mtap_or_all_bits_irreg)
                    );

   // *********************************************************************
   // Data Register Implementation
   // *********************************************************************
   mtap_drreg #(
                .DRREG_MTAP_ENABLE_VERCODE                            (MTAP_ENABLE_VERCODE),
                .DRREG_MTAP_ENABLE_TEST_DATA_REGISTERS                (MTAP_ENABLE_TEST_DATA_REGISTERS),
                .DRREG_MTAP_ENABLE_CLTAPC_VISAOVR                     (MTAP_ENABLE_CLTAPC_VISAOVR),
                .DRREG_MTAP_ENABLE_CLTAPC_REMOVE                      (MTAP_ENABLE_CLTAPC_REMOVE),
                .DRREG_MTAP_WIDTH_OF_IDCODE                           (MTAP_WIDTH_OF_IDCODE),
                .DRREG_MTAP_WIDTH_OF_VERCODE                          (MTAP_WIDTH_OF_VERCODE),
                .DRREG_MTAP_NUMBER_OF_TOTAL_REGISTERS                 (MTAP_NUMBER_OF_TOTAL_REGISTERS),
                .DRREG_MTAP_NUMBER_OF_MANDATORY_REGISTERS             (MTAP_NUMBER_OF_MANDATORY_REGISTERS),
                .DRREG_MTAP_NUMBER_OF_BITS_FOR_SLICE                  (MTAP_NUMBER_OF_BITS_FOR_SLICE),
                .DRREG_MTAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS        (MTAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS),
                .DRREG_MTAP_SIZE_OF_EACH_TEST_DATA_REGISTER           (MTAP_SIZE_OF_EACH_TEST_DATA_REGISTER),
                .DRREG_MTAP_LSB_VALUES_OF_TEST_DATA_REGISTERS         (MTAP_LSB_VALUES_OF_TEST_DATA_REGISTERS),
                .DRREG_MTAP_MSB_VALUES_OF_TEST_DATA_REGISTERS         (MTAP_MSB_VALUES_OF_TEST_DATA_REGISTERS),
                .DRREG_MTAP_RESET_VALUES_OF_TEST_DATA_REGISTERS       (MTAP_RESET_VALUES_OF_TEST_DATA_REGISTERS),
                .DRREG_MTAP_BIT_ONE_FOR_TDRDATAIN_ZERO_FOR_TDRDATAOUT (MTAP_BIT_ONE_FOR_TDRDATAIN_ZERO_FOR_TDRDATAOUT),
                .DRREG_MTAP_NUMBER_OF_TAP_NETWORK_REGISTERS           (MTAP_NUMBER_OF_TAP_NETWORK_REGISTERS),
                .DRREG_MTAP_NUMBER_OF_TAPS                            (MTAP_NUMBER_OF_TAPS),
                .DRREG_MTAP_NUMBER_OF_WTAPS                           (MTAP_NUMBER_OF_WTAPS),
                .DRREG_MTAP_WIDTH_OF_CLTAPC_VISAOVR                   (MTAP_WIDTH_OF_CLTAPC_VISAOVR),
                .DRREG_MTAP_WIDTH_OF_CLTAPC_REMOVE                    (MTAP_WIDTH_OF_CLTAPC_REMOVE),
                .DRREG_MTAP_NUMBER_OF_WTAP_NETWORK_REGISTERS          (MTAP_NUMBER_OF_WTAP_NETWORK_REGISTERS),
                .DRREG_MTAP_ENABLE_CLTAPC_SEC_SEL                     (MTAP_ENABLE_CLTAPC_SEC_SEL),
                .DRREG_MTAP_ENABLE_WTAP_NETWORK                       (MTAP_ENABLE_WTAP_NETWORK),
                .DRREG_MTAP_ENABLE_TAP_NETWORK                        (MTAP_ENABLE_TAP_NETWORK),
                .DRREG_MTAP_COUNT_OF_CLTAPC_VISAOVR_REGISTERS         (MTAP_COUNT_OF_CLTAPC_VISAOVR_REGISTERS),
                .DRREG_MTAP_NUMBER_OF_CLTAPC_REMOVE_REGISTERS         (MTAP_NUMBER_OF_CLTAPC_REMOVE_REGISTERS),
                .DRREG_MTAP_NUMBER_OF_PRELOAD_REGISTERS               (MTAP_NUMBER_OF_PRELOAD_REGISTERS),
                .DRREG_MTAP_NUMBER_OF_CLAMP_REGISTERS                 (MTAP_NUMBER_OF_CLAMP_REGISTERS),
                .DRREG_MTAP_NUMBER_OF_USERCODE_REGISTERS              (MTAP_NUMBER_OF_USERCODE_REGISTERS),
                .DRREG_MTAP_NUMBER_OF_INTEST_REGISTERS                (MTAP_NUMBER_OF_INTEST_REGISTERS),
                .DRREG_MTAP_NUMBER_OF_RUNBIST_REGISTERS               (MTAP_NUMBER_OF_RUNBIST_REGISTERS),
                .DRREG_MTAP_NUMBER_OF_EXTEST_TOGGLE_REGISTERS         (MTAP_NUMBER_OF_EXTEST_TOGGLE_REGISTERS),
                .DRREG_MTAP_NUMBER_OF_TAPS_MULTIPLY_BY_2              (MTAP_NUMBER_OF_TAPS_MULTIPLY_BY_2),
                .DRREG_MTAP_WIDTH_OF_CLTAPC_VISAOVR_ADDRESS           (MTAP_WIDTH_OF_CLTAPC_VISAOVR_ADDRESS),
                .DRREG_MTAP_WIDTH_OF_CLTAPC_VISAOVR_DATA              (MTAP_WIDTH_OF_CLTAPC_VISAOVR_DATA),
                .DRREG_MTAP_NUMBER_OF_CLTAPC_VISAOVR_REGISTERS        (MTAP_NUMBER_OF_CLTAPC_VISAOVR_REGISTERS),
                .DRREG_MTAP_NUMBER_OF_TEST_DATA_REGISTERS             (MTAP_NUMBER_OF_TEST_DATA_REGISTERS),
                .DRREG_MTAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS_NZ   (MTAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS_NZ),
                .DRREG_MTAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS      (MTAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS),
                .DRREG_MTAP_ENABLE_REMOTE_TEST_DATA_REGISTERS         (MTAP_ENABLE_REMOTE_TEST_DATA_REGISTERS),
                .DRREG_MTAP_ENABLE_SYNCHRONIZER_FOR_REMOTE_TDR        (MTAP_ENABLE_SYNCHRONIZER_FOR_REMOTE_TDR)
 
               )
   i_mtap_drreg (
                 .mtap_fsm_tlrs           (mtap_fsm_tlrs),
                 .atappris_tdi            (atappris_tdi),
                 .atappris_tck            (atappris_tck),
                 .powergoodrst_b          (powergoodrst_b), 
                 .powergoodrst_trst_b     (powergoodrst_trst_b),
                 .mtap_fsm_capture_dr_nxt (mtap_fsm_capture_dr_nxt), //kbbhagwa cdc fix
                 .mtap_fsm_capture_dr     (mtap_fsm_capture_dr),
                 .mtap_fsm_shift_dr       (mtap_fsm_shift_dr),
                 //.mtap_fsm_shift_dr_neg   (mtap_fsm_shift_dr_neg), //kbbhagwa hsd2904953
                 .mtap_fsm_update_dr_nxt  (mtap_fsm_update_dr_nxt), //kbbhagwa cdc fix
                 .mtap_fsm_update_dr      (mtap_fsm_update_dr),
                 .mtap_selectwir          (mtap_selectwir),
                 .ftap_vercode            (ftap_vercode),
                 .ftap_idcode             (ftap_idcode),
                 .mtap_irdecoder_drselect (mtap_irdecoder_drselect),
                 .tdr_data_in             (tdr_data_in),
                 .tdr_data_out            (tdr_data_out),
                 .cftapnw_ftap_secsel     (cftapnw_ftap_secsel),
                 .cltapc_select           (cltapc_select),
                 .cltapc_select_ovr       (cltapc_select_ovr),
                 .cltapc_wtap_sel         (cltapc_wtap_sel),
                 .cltapc_visaovr          (tapc_visaovr),
                 .cltapc_remove           (cltapc_remove),
                 .mtap_drreg_drout        (mtap_drreg_drout),
                 .mtap_and_all_bits_irreg (mtap_and_all_bits_irreg),
                 .mtap_or_all_bits_irreg  (mtap_or_all_bits_irreg),
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
                 .mtap_fsm_rti            (mtap_fsm_rti)
                );

   // *********************************************************************
   // TDO mux implementation
   // *********************************************************************
   mtap_tdomux #(
                 .TDOMUX_MTAP_NUMBER_OF_TOTAL_REGISTERS (MTAP_NUMBER_OF_TOTAL_REGISTERS)
                )
   i_mtap_tdomux (
                  .mtap_drreg_drout        (mtap_drreg_drout),
                  .mtap_fsm_shift_dr       (mtap_fsm_shift_dr),
                  .mtap_fsm_shift_ir       (mtap_fsm_shift_ir),
                  .mtap_irdecoder_drselect (mtap_irdecoder_drselect),
                  .mtap_irreg_serial_out   (mtap_irreg_serial_out),
                  .mtap_fsm_tlrs           (mtap_fsm_tlrs),
                  .atappris_tck            (atappris_tck),
                  .powergoodrst_trst_b     (powergoodrst_trst_b),
                  .mtap_mux_tdo            (mtap_mux_tdo),
                  .mtap_tdomux_tdoen       (mtap_tdomux_tdoen)
                 );

   // *********************************************************************
   // TAP network implementation
   // *********************************************************************
   generate
      if (MTAP_ENABLE_TAP_NETWORK == 1)
      begin
         mtap_tapnw #(
                      .TAPNW_MTAP_NUMBER_OF_TAPS        (MTAP_NUMBER_OF_TAPS)
                     )
         i_mtap_tapnw (
                       //.mtap_selectwir          (mtap_selectwir),
                       .mtap_selectwir_neg          (mtap_selectwir_neg), //kbbhagwa posedge negedge signal merge
                       .cltapc_select           (cltapc_select),
                       .cltapc_select_ovr       (cltapc_select_ovr),
                       .cftapnw_ftap_enabletdo  (cftapnw_ftap_enabletdo),
                       .cftapnw_ftap_enabletap  (cftapnw_ftap_enabletap)
                      );
      end
      else
      begin
         assign cftapnw_ftap_enabletdo = LOW;
         assign cftapnw_ftap_enabletap = LOW;
      end
   endgenerate

   // *********************************************************************
   // WTAP network implementation
   // *********************************************************************
   generate
      if (MTAP_ENABLE_WTAP_NETWORK == 1)
      begin
         mtap_wtapnw #(
                       .WTAPNW_MTAP_NUMBER_OF_TAPS               (MTAP_NUMBER_OF_TAPS),
                       .WTAPNW_MTAP_NUMBER_OF_WTAPS              (MTAP_NUMBER_OF_WTAPS),
                       .WTAPNW_MTAP_NUMBER_OF_TAPS_MULTIPLY_BY_2 (MTAP_NUMBER_OF_TAPS_MULTIPLY_BY_2)
                      )
         i_mtap_wtapnw (
                        .mtap_mux_tdo              (mtap_mux_tdo),
                        .mtap_selectwir            (mtap_selectwir),
                        .cn_awtap_wso              (cn_awtap_wso),
                        .cltapc_wtap_sel           (cltapc_wtap_sel),
                        .cltapc_select             (cltapc_select),
                        .cltapc_select_ovr         (cltapc_select_ovr),
                        .cn_fwtap_selectwir        (cn_fwtap_selectwir),
                        .cn_fwtap_wsi              (cn_fwtap_wsi),
                        .mtap_wtapnw_tdo           (mtap_wtapnw_tdo)
                       );
      end
      else
      begin
         assign cn_fwtap_wsi[0]       = HIGH;
         assign cn_fwtap_selectwir    = LOW;
         assign mtap_wtapnw_tdo       = HIGH;
      end
   endgenerate

   // *********************************************************************
   // linear network vs Hierarchical Network
   // *********************************************************************
   // Master TAp can never be in Linear Network configuration in Current Architecture.
   // This code is kept for future use, if this becomes a possibility

   //generate
   //   if (MTAP_ENABLE_LINEAR_NETWORK == 1)
   //   begin:generate_loopback_tapnwtdi
   //      assign linr_hier_tapnw_tdo      = cntapnw_ftap_tdi;
   //      assign tapnw_tdo_NC             = cntapnw_atap_tdo;
   //   end
   //   else
   //   begin
   //      assign linr_hier_tapnw_tdo      = cntapnw_atap_tdo;
   //   end
   //endgenerate
   assign linr_hier_tapnw_tdo      = cntapnw_atap_tdo;
   assign ctapnw_subtapactvi_NC    = ctapnw_atap_subtapactvi;

   // *********************************************************************
   // Glue logic implementation
   // *********************************************************************
   mtap_glue #(
               .GLUE_MTAP_ENABLE_TAP_NETWORK       (MTAP_ENABLE_TAP_NETWORK),
               .GLUE_MTAP_ENABLE_WTAP_NETWORK      (MTAP_ENABLE_WTAP_NETWORK),
               .GLUE_MTAP_WIDTH_OF_VERCODE         (MTAP_WIDTH_OF_VERCODE),
               .GLUE_MTAP_NUMBER_OF_TAPS           (MTAP_NUMBER_OF_TAPS),
               .GLUE_MTAP_NUMBER_OF_WTAPS          (MTAP_NUMBER_OF_WTAPS),
               .GLUE_MTAP_SIZE_OF_EACH_INSTRUCTION (MTAP_SIZE_OF_EACH_INSTRUCTION),
               .GLUE_MTAP_WTAP_COMMON_LOGIC        (MTAP_WTAP_COMMON_LOGIC),
               .GLUE_MTAP_ENABLE_CLTAPC_REMOVE     (MTAP_ENABLE_CLTAPC_REMOVE),
               .GLUE_MTAP_ENABLE_LINEAR_NETWORK    (MTAP_ENABLE_LINEAR_NETWORK)
              )
   i_mtap_glue (
                .atappris_tck             (atappris_tck),
                .atappris_tms             (atappris_tms),
                .atappris_trst_b          (atappris_trst_b),
                .powergoodrst_b           (powergoodrst_b),
                .atappris_tdi             (atappris_tdi),
                .ftap_vercode             (ftap_vercode),
                .mtap_tdomux_tdoen        (mtap_tdomux_tdoen),
                .cntapnw_atap_tdo_en      (cntapnw_atap_tdo_en),
                .atap_vercode             (atap_vercode),
                .pre_tdo                  (pre_tdo),
                .powergoodrst_trst_b      (powergoodrst_trst_b),
                .ftappris_tdoen           (ftappris_tdoen),
                .cntapnw_ftap_tck         (cntapnw_ftap_tck),
                .cntapnw_ftap_tms         (cntapnw_ftap_tms),
                .cntapnw_ftap_trst_b      (cntapnw_ftap_trst_b),
                .cntapnw_ftap_tdi         (cntapnw_ftap_tdi),
                //.cntapnw_atap_tdo       (cntapnw_atap_tdo),
                .cntapnw_atap_tdo         (linr_hier_tapnw_tdo),
                .atapsecs_tck             (atapsecs_tck),
                .atapsecs_tms             (atapsecs_tms),
                .atapsecs_trst_b          (atapsecs_trst_b),
                .atapsecs_tdi             (atapsecs_tdi),
                .ftapsecs_tdo             (ftapsecs_tdo),
                .ftapsecs_tdoen           (ftapsecs_tdoen),
                .cntapnw_ftap_tck2        (cntapnw_ftap_tck2),
                .cntapnw_ftap_tms2        (cntapnw_ftap_tms2),
                .cntapnw_ftap_trst2_b     (cntapnw_ftap_trst2_b),
                .cntapnw_ftap_tdi2        (cntapnw_ftap_tdi2),
                .cntapnw_atap_tdo2        (cntapnw_atap_tdo2),
                .cntapnw_atap_tdo2_en     (cntapnw_atap_tdo2_en),
                //.mtap_wso               (mtap_wso),
                //.mtap_wsi               (mtap_wsi),
                .cn_fwtap_wrck            (cn_fwtap_wrck),
                .mtap_mux_tdo             (mtap_mux_tdo),
                .cltapc_select            (cltapc_select),
                .cltapc_select_ovr        (cltapc_select_ovr),
                .cltapc_wtap_sel          (cltapc_wtap_sel),
                .cltapc_remove            (cltapc_remove),
                .mtap_wtapnw_tdo          (mtap_wtapnw_tdo)
               );

   // *********************************************************************
   // Boundary Scan implementation
   // *********************************************************************
   mtap_bscan #(
                .BSCAN_MTAP_SIZE_OF_EACH_INSTRUCTION          (MTAP_SIZE_OF_EACH_INSTRUCTION),
                .BSCAN_MTAP_MINIMUM_SIZEOF_INSTRUCTION        (MTAP_MINIMUM_SIZEOF_INSTRUCTION),
                .BSCAN_MTAP_ADDRESS_OF_CLAMP                  (MTAP_ADDRESS_OF_CLAMP),
                .BSCAN_MTAP_NUMBER_OF_PRELOAD_REGISTERS       (MTAP_NUMBER_OF_PRELOAD_REGISTERS),
                .BSCAN_MTAP_NUMBER_OF_CLAMP_REGISTERS         (MTAP_NUMBER_OF_CLAMP_REGISTERS),
                .BSCAN_MTAP_NUMBER_OF_USERCODE_REGISTERS      (MTAP_NUMBER_OF_USERCODE_REGISTERS),
                .BSCAN_MTAP_NUMBER_OF_INTEST_REGISTERS        (MTAP_NUMBER_OF_INTEST_REGISTERS),
                .BSCAN_MTAP_NUMBER_OF_RUNBIST_REGISTERS       (MTAP_NUMBER_OF_RUNBIST_REGISTERS),
                .BSCAN_MTAP_NUMBER_OF_EXTEST_TOGGLE_REGISTERS (MTAP_NUMBER_OF_EXTEST_TOGGLE_REGISTERS)
               )
   i_mtap_bscan (
                 .atappris_tck         (atappris_tck),
                 .powergoodrst_trst_b  (powergoodrst_trst_b),
                 .mtap_fsm_tlrs        (mtap_fsm_tlrs),
                 .mtap_fsm_rti         (mtap_fsm_rti),
                 .mtap_fsm_e1dr        (mtap_fsm_e1dr),
                 .mtap_fsm_e2dr        (mtap_fsm_e2dr),
                 .ftappris_tdo         (ftappris_tdo),
                 .pre_tdo              (pre_tdo),
                 .fbscan_tck           (fbscan_tck),
                 .fbscan_tdo           (fbscan_tdo),
                 .fbscan_capturedr     (fbscan_capturedr),
                 .fbscan_shiftdr       (fbscan_shiftdr),
                 .fbscan_updatedr      (fbscan_updatedr),
                 .fbscan_updatedr_clk  (fbscan_updatedr_clk),
                 .fbscan_runbist_en    (fbscan_runbist_en),
                 .fbscan_highz         (fbscan_highz),
                 .fbscan_extogen       (fbscan_extogen),
                 .fbscan_chainen       (fbscan_chainen),
                 .fbscan_mode          (fbscan_mode),
                 .fbscan_extogsig_b    (fbscan_extogsig_b),
                 .fbscan_d6init        (fbscan_d6init),
                 .fbscan_d6actestsig_b (fbscan_d6actestsig_b),
                 .fbscan_d6select      (fbscan_d6select),
                 .mtap_fsm_capture_dr  (mtap_fsm_capture_dr),
                 .mtap_fsm_shift_dr    (mtap_fsm_shift_dr),
                 .mtap_fsm_update_dr   (mtap_fsm_update_dr),
                 .mtap_irreg_ireg      (mtap_irreg_ireg),
                 .mtap_fsm_shift_ir_neg(mtap_fsm_shift_ir_neg), //kbbhagwa posedge negedge signal merge
                 .mtap_fsm_update_ir   (mtap_fsm_update_ir),
                 .mtap_irreg_shift_reg (mtap_irreg_shift_reg)
                 //.mtap_fsm_shift_ir    (mtap_fsm_shift_ir)
                );

   // *********************************************************************
   // DFx Secure implementation
   // *********************************************************************
   mtap_dfxsecure #(
                    .DFXSECURE_MTAP_NUMBER_OF_DFX_FEATURES_TO_SECURE (MTAP_NUMBER_OF_DFX_FEATURES_TO_SECURE),
                    .DFXSECURE_MTAP_DFX_SECURE_WIDTH                 (MTAP_DFX_SECURE_WIDTH)
                   )
   i_mtap_dfxsecure (
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
//kbbhagwa   `include "mtap_include.sv"
//https://vthsd.intel.com/hsd/seg_softip/ar/def ault.aspx?ar_id=240053
`ifndef DFX_FPV_ENABLE
   // synopsys translate_off
`endif

   // Assertions and coverage
   `include "mtap_include.sv"

`ifndef DFX_FPV_ENABLE
   // synopsys translate_on
`endif




endmodule
