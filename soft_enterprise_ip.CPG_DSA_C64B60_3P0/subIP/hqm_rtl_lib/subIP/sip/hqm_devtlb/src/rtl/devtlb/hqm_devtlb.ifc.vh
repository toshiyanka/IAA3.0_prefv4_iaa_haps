//=======================================================================================================================
//
// devtlb.ifc.sv
//
// Contacts            : Hai Ming Khor
// Original Author(s)  : Devin Claxton & Camron Rust
// Original Date       : 8/2012
//
// -- Intel Proprietary
// -- Copyright (C) 2019 Intel Corporation
// -- All Rights Reserved
//
//=======================================================================================================================
//
// This file contains the declarations and explanations of all interace signals
//
//=======================================================================================================================

//=======================================================================================================================
//   This file is used to autogenerate the Excel Signal List. In order for the script to properly parse the file, please 
//   follow the following template: 
//   // Signal Category
//   input logic test; // Description that will be reported in Excel; Only one line, semicolumns will be trnslated 
//   into new lines
//
//   If you must comment out a signal, please push it down just above the new signal category, 
//   otherwise the commented line will be interpreted as the category of the signals below. 
//
//   __Correct__: 
//   // Category of signal test
//   input logic test; // Description for test
//-> //input logic commented_out; // Description for commented_out
//   // Next category 
//
//   __Incorrect__: 
//   // Category of signal test, will be overridden by the next line
//-> //input logic commented_out; // Description for commented_out
//   input logic test; // Description for test
//   // Next category 
//
//   Please contact andrea.pellegrini@intel.com for any questions, comments of suggestions. 
//=======================================================================================================================

//=======================================================================================================================
// General
//=======================================================================================================================
   input  logic                                                      clk;        // Unit Clock

   input  logic                                                      flreset;      // Reset the Unit
   input  logic                                                      full_reset; // Non Func Level reset.

//=======================================================================================================================
//SCAN Signal
//=======================================================================================================================
   input  logic                                                      fscan_mode;         // lintra s-0527, s-70036 "Used by synthesis tools"
   input  logic                                                      fscan_shiften;      // lintra s-0527, s-70036 "Used by synthesis tools"

   input  logic                                                      fscan_clkungate_syn;// lintra s-0527, s-70036 "Used by synthesis tools"
   input  logic                                                      fscan_clkgenctrl;   // lintra s-0527, s-70036 "not used in devtlb" 
   input  logic                                                      fscan_clkgenctrlen; // lintra s-0527, s-70036 "not used in devtlb"
   `HQM_DEVTLB_FSCAN_PORTDEC   
   input  logic                                                      fscan_ram_wrdis_b;  // lintra s-0527, s-70036 "not used in devtlb" 
   input  logic                                                      fscan_ram_rddis_b;  // lintra s-0527, s-70036 "not used in devtlb"
   input  logic                                                      fscan_ram_odis_b;   // lintra s-0527, s-70036 "not used in devtlb"
   input  logic                                                      fsta_afd_en;        // lintra s-0527, s-70036 "not used in devtlb"
   input  logic                                                      fsta_dfxact_afd;    // lintra s-0527, s-70036 "not used in devtlb"
   input    logic                                                    fdfx_earlyboot_exit;  // lintra s-0527, s-70036 "not used in devtlb"

//=======================================================================================================================
// Interface to external
//=======================================================================================================================
`HQM_DEVTLB_CUSTOM_RF_PORTDEC
`HQM_DEVTLB_CUSTOM_MISCRF_PORTDEC

//=======================================================================================================================
// global control
//=======================================================================================================================
   output logic                                                      xreqs_active;         // IOMMU is currently not performing any translation requests or sequencer flows 
   output logic                                                      tlb_reset_active; // high is tlb inv due to reset or implicit inval is in progress.
   output logic                                                      invreqs_active; // high is any inv req in invq.

   input  logic                                                      implicit_invalidation_valid;   // Triggers an invalidation of all IOMMU TLBs/PWCs.
   input  logic [DEVTLB_BDF_WIDTH-1:0]                               implicit_invalidation_bdf;
   input  logic                                                      implicit_invalidation_bdf_valid;
                                                                                          // Used by instantiations that place the TLBs
                                                                                          // outside of the IOMMU on a dedicated power
                                                                                          // plane to initialize the arrays when power is
                                                                                          // restored.

//=======================================================================================================================
// Host Interface (Upstream Request or downstream completion to/from Host interface, i.e IOSF)
//=======================================================================================================================
    //ATS REQ
   output logic [DEVTLB_ATSREQ_PORTNUM-1:0]                                                atsreq_valid;
   output logic [DEVTLB_ATSREQ_PORTNUM-1:0][$clog2(DEVTLB_MISSTRK_DEPTH)-1:0]              atsreq_id;
   output logic [DEVTLB_ATSREQ_PORTNUM-1:0][DEVTLB_MAX_LINEAR_ADDRESS_WIDTH-1:12]          atsreq_address;
   output logic [DEVTLB_ATSREQ_PORTNUM-1:0][DEVTLB_BDF_WIDTH-1:0]                          atsreq_bdf;
   output logic [DEVTLB_ATSREQ_PORTNUM-1:0]                                                atsreq_pasid_valid;
   output logic [DEVTLB_ATSREQ_PORTNUM-1:0]                                                atsreq_pasid_priv;
   output logic [DEVTLB_ATSREQ_PORTNUM-1:0][DEVTLB_PASID_WIDTH-1:0]                        atsreq_pasid;
   output logic [DEVTLB_ATSREQ_PORTNUM-1:0][2:0]                                           atsreq_tc;
   output logic [DEVTLB_ATSREQ_PORTNUM-1:0]                                                atsreq_nw;
   input  logic [DEVTLB_ATSREQ_PORTNUM-1:0]                                                atsreq_ack;

    //ATS RSP
   input  logic                                                      atsrsp_valid;
   input  logic [$clog2(DEVTLB_MISSTRK_DEPTH)-1:0]                   atsrsp_id;
   input  logic                                                      atsrsp_dperror;
   input  logic                                                      atsrsp_hdrerror;
   input  logic [63:0]                                               atsrsp_data;
   
//========================================================================================================================
   input  logic                                                      rx_msg_valid;
   input  logic                                                      rx_msg_opcode;
   input  logic                                                      rx_msg_pasid_valid;
   input  logic                                                      rx_msg_pasid_priv;
   input  logic [DEVTLB_PASID_WIDTH-1:0]                             rx_msg_pasid;
   input  logic [31:0]                                               rx_msg_dw2;
   input  logic [63:0]                                               rx_msg_data;
   input  logic                                                      rx_msg_dperror;
   input  logic [4:0]                                                rx_msg_invreq_itag;
   input  logic [15:0]                                               rx_msg_invreq_reqid;

   // TX message interface (invrsp, pagereq)
   output logic                                                      tx_msg_valid;
   input  logic                                                      tx_msg_ack;
   output logic                                                      tx_msg_opcode;
   output logic [DEVTLB_BDF_WIDTH-1:0]                               tx_msg_bdf;
   output logic                                                      tx_msg_pasid_valid;
   output logic                                                      tx_msg_pasid_priv;
   output logic [DEVTLB_PASID_WIDTH-1:0]                             tx_msg_pasid;
   output logic [31:0]                                               tx_msg_dw2;
   output logic [31:0]                                               tx_msg_dw3;
   output logic [2:0]                                                tx_msg_tc;

//========================================================================================================================
// Drain interface to/from hosting unit (due to TLB Invalidation Request)
//========================================================================================================================
   output logic                                                      drainreq_valid;  // request to drain ALL transaction in Q
   input  logic                                                      drainreq_ack;    // set when a drainreq is accepted.
   output logic [DEVTLB_PASID_WIDTH-1:0]                             drainreq_pasid;
   output logic                                                      drainreq_pasid_priv;
   output logic                                                      drainreq_pasid_valid;
   output logic                                                      drainreq_pasid_global;
   output logic [DEVTLB_BDF_WIDTH-1:0]                               drainreq_bdf;
   input  logic                                                      drainrsp_valid;  // set when a drain req is processed, i.e outstanding request are flushed or marked for translation retry. 
   input  logic [7:0]                                                drainrsp_tc;     // Traffic Class (bitwise) used by the hosting unit for all transaction.

//========================================================================================================================
// Primary interface to/from hosting unit
//========================================================================================================================
   input  logic [DEVTLB_XREQ_PORTNUM-1:0]                               xreq_valid;           // translation request is valid
   input  logic [DEVTLB_XREQ_PORTNUM-1:0][DEVTLB_REQ_ID_WIDTH-1:0]      xreq_id;              // Transaction ID width=log2(customer buffer size)
   input  logic [DEVTLB_XREQ_PORTNUM-1:0][DEVTLB_TLBID_WIDTH-1:0]       xreq_tlbid;           // TLBid
   input  logic [DEVTLB_XREQ_PORTNUM-1:0]                                          xreq_priority;        // request priority
   input  logic [DEVTLB_XREQ_PORTNUM-1:0][DEVTLB_MAX_LINEAR_ADDRESS_WIDTH-1:12]    xreq_address; // Address that needs to be translated.
   input  logic [DEVTLB_XREQ_PORTNUM-1:0][DEVTLB_BDF_WIDTH-1:0]                    xreq_bdf;
   input  logic [DEVTLB_XREQ_PORTNUM-1:0][DEVTLB_PASID_WIDTH-1:0]                  xreq_pasid;
   input  logic [DEVTLB_XREQ_PORTNUM-1:0]                                          xreq_pasid_priv;
   input  logic [DEVTLB_XREQ_PORTNUM-1:0]                                          xreq_pasid_valid;
   input  logic [DEVTLB_XREQ_PORTNUM-1:0]                                          xreq_prs;
   input  logic [DEVTLB_XREQ_PORTNUM-1:0][1:0]                          xreq_opcode;          // Customer intended use for translated address
   input  logic [DEVTLB_XREQ_PORTNUM-1:0][2:0]                          xreq_tc;              // Transaction's Traffic class 
     
   output logic [DEVTLB_XREQ_PORTNUM-1:0]                               xreq_lcrd_inc;        // Credit return for Low priority request
   output logic [DEVTLB_XREQ_PORTNUM-1:0]                               xreq_hcrd_inc;        // Credite return for high priority request

   output logic [DEVTLB_XREQ_PORTNUM-1:0]                               xrsp_valid;           // Translation Response valid
   output logic [DEVTLB_XREQ_PORTNUM-1:0][DEVTLB_REQ_ID_WIDTH-1:0]      xrsp_id;              // Transaction ID 
   output logic [DEVTLB_XREQ_PORTNUM-1:0][0:0]                          xrsp_result;          // Response status: 1=success (translated); 0=failure.
   output logic [DEVTLB_XREQ_PORTNUM-1:0][DEVTLB_MAX_HOST_ADDRESS_WIDTH-1:12] xrsp_address;            // Translated Address
//   output logic [DEVTLB_XREQ_PORTNUM-1:0]                               xrsp_u;               // 1 if the xrsp_address is not a valid translated address, and dma should use VA.
//   output logic [DEVTLB_XREQ_PORTNUM-1:0]                               xrsp_perm;               // 1 if the translated address covered the permission requested by xreq.
   output logic [DEVTLB_XREQ_PORTNUM-1:0]                               xrsp_nonsnooped ;               // 1 if the translated address should be accessed with non-snoop cycle.
   output logic [DEVTLB_XREQ_PORTNUM-1:0][1:0]                          xrsp_prs_code;
   output logic [DEVTLB_XREQ_PORTNUM-1:0]                               xrsp_dperror; // data parity error was seen as part of translation request
   output logic [DEVTLB_XREQ_PORTNUM-1:0]                               xrsp_hdrerror; // a header error was seen as part of ATS request (e.g. UR, CA, CTO, etc).  

//============================================================================================================
// Defeature interface
//============================================================================================================
   input  logic [31:0]                                               defeature_misc_dis;
   input  logic [31:0]                                               defeature_pwrdwn_ovrd_dis;   
   input  logic [31:0]                                               defeature_parity_injection;

//============================================================================================================
// Configuration
//============================================================================================================
   //TLB arbiter gran count configuration
   input  logic [DEVTLB_TLB_ARBGCNT_WIDTH-1:0]    scr_loxreq_gcnt; //TLB Arbiter Grant count, one based.
   input  logic [DEVTLB_TLB_ARBGCNT_WIDTH-1:0]    scr_hixreq_gcnt;
   input  logic [DEVTLB_TLB_ARBGCNT_WIDTH-1:0]    scr_pendq_gcnt;
   input  logic [DEVTLB_TLB_ARBGCNT_WIDTH-1:0]    scr_fill_gcnt;
   input  logic                                   scr_prs_continuous_retry;
   input  logic                                   scr_disable_prs;
   input  logic                                   scr_disable_2m;
   input  logic                                   scr_disable_1g;
   input  logic [31:0]                            scr_spare;

   output logic                                   PRSSTS_stopped;
   output logic                                   PRSSTS_uprgi;
   output logic                                   PRSSTS_rf;
//   output logic [31:0]                            PRSREQCAP_cap;
   input  logic [31:0]                            PRSREQALLOC_alloc;

//============================================================================================================
// Parity error interface 
//============================================================================================================
   output logic [DEVTLB_XREQ_PORTNUM-1:0][(5*DEVTLB_PARITY_WIDTH)-1:0]   tlb_tag_parity_err;  // Vector reporting TLB tag parity errors; 
                                                                                                                 // 4: IOTLB 250T TAG; 3: IOTLB 500G TAG; 2: IOTLB 1G TAG; 1: IOTLB 2M TAG; 0: IOTLB 4K TAG;  
   output logic [DEVTLB_XREQ_PORTNUM-1:0][(5*DEVTLB_PARITY_WIDTH)-1:0]   tlb_data_parity_err; // Vector reporting TLB tag parity errors; 
                                                                                                                 // 4: IOTLB 250T DATA; 3: IOTLB 500G DATA; 2: IOTLB 1G DATA; 1: IOTLB 2M DATA; 0: IOTLB 4K DATA; 
                                        
//===========================================================================================================
// Debug Signals from DEVTLB
//===========================================================================================================
   output logic [DEVTLB_NUM_DBGPORTS-1:0][7:0]       debugbus;

//===========================================================================================================
