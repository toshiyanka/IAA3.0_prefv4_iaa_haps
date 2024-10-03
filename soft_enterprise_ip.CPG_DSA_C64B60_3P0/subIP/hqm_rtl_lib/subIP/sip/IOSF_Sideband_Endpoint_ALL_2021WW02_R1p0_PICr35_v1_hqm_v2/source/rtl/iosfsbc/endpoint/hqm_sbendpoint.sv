//
//------------------------------------------------------------------------------
//
//  -- Intel Proprietary
//  -- Copyright (C) 2015 Intel Corporation
//  -- All Rights Reserved
//
//  INTEL CONFIDENTIAL
//
//  Copyright 2009-2021 Intel Corporation All Rights Reserved.
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
//  2021WW02_PICr35
//
//  Module sbendpoint : The top-level for the sideband interface endpoint
//
//------------------------------------------------------------------------------

// lintra push -60020, -60088, -80018, -80028, -80095, -80099, -68001, -68000, -60022, -60024b, 70607, -70036_simple

module hqm_sbendpoint #(
	parameter CLAIM_DELAY				  = 0, //adding delay
  //  parameter NUM_REPEATER_FLOPS  = 5, 		    
    parameter MAXPLDBIT                   = 7, // Maximum payload bit, should be 7, 15 or 31
    parameter MATCHED_INTERNAL_WIDTH      = 0, // Payload width equals MAXPLDBIT (7, 15 or 31) or only 31 when MAXPLDBITON is 1 and 0 respetively
    parameter NPQUEUEDEPTH                = 4, // Ingress queue depth, NP
    parameter PCQUEUEDEPTH                = 4, // Ingress queue depth, PC
    parameter CUP2PUT1CYC                 = 0, // deprecated.  setting ignored
    parameter LATCHQUEUES                 = 0, // 0 = flop-based queues, 1 = latch-based queues
    parameter RELATIVE_PLACEMENT_EN       = 0, // RP methodology for efficient placement in RAMS    
    parameter MAXPCTRGT                   = 0, // Maximum posted/completion target agent number
    parameter MAXNPTRGT                   = 0, // Maximum non-posted        target agent number
    parameter MAXPCMSTR                   = 0, // Maximum posted/completion master agent number
    parameter MAXNPMSTR                   = 0, // Maximum non-posted        master agent number
    parameter ASYNCENDPT                  = 0, // Asynchronous endpoint=1, 0 otherwise
    parameter ASYNCIQDEPTH                = 2, // Asynchronous ingress FIFO queue depth
    parameter ASYNCEQDEPTH                = 2, // Asynchronous egress FIFO queue depth
    parameter TARGETREG                   = 1, // Target Register Access Agent 1=Enable/0=Disable
    parameter MASTERREG                   = 1, // Master Register Access Agent 1=Enable/0=Disable
    parameter MAXTRGTADDR                 = 31, // Maximum target register access address bit
    parameter MAXTRGTDATA                 = 63, // Maximum target register access data bit
    parameter MAXMSTRADDR                 = 31, // Maximum master register access address bit
    parameter MAXMSTRDATA                 = 63, // Maximum master register access data bit
    parameter VALONLYMODEL                = 0, // deprecated.  setting ignored.
    parameter DUMMY_CLKBUF                = 0, // set to 1 to insert a dummy clkbuf, needed for
    // some CPU scan flows.
    parameter RX_EXT_HEADER_SUPPORT       = 0, // indicate whether agent supports receiving extended headers
    parameter NUM_RX_EXT_HEADERS          = 0, // number of headers agent supports receiving.
    parameter [NUM_RX_EXT_HEADERS:0][6:0] RX_EXT_HEADER_IDS = 0, // header IDs the agent supports.  any others are discarded.
    parameter TX_EXT_HEADER_SUPPORT       = 0,
    parameter NUM_TX_EXT_HEADERS          = 0,
    parameter DISABLE_COMPLETION_FENCING  = 0,
    // following are VISA insertion parameters, used for inserting VISA on the endpoint itself.
    // this is not the intended flow for end-users, but is present for VISA verify flow on endpoint collateral.
    // intended flow for end-users is to take provided signal list and integrate with overall signal list for
    // the design for inserting VISA at the top design level.
    parameter SBE_VISA_ID_PARAM           = 11,
    parameter NUMBER_OF_BITS_PER_LANE     = 8,
    parameter NUMBER_OF_VISAMUX_MODULES   = 1,
    parameter NUMBER_OF_OUTPUT_LANES      = (NUMBER_OF_VISAMUX_MODULES == 1)? 2 : NUMBER_OF_VISAMUX_MODULES,
    parameter SKIP_ACTIVEREQ              = 1, // set to 1 to skip ACTIVE_REQ, per IOSF 1.0
    parameter PIPEISMS                    = 0, // set to 1 to pipeline fabric ism inputs
    parameter PIPEINPS                    = 0, // set to 1 to pipeline all put-cup-eom-payload inputs
    parameter USYNC_ENABLE                = 0, // set to 1 to enable deterministic clock crossing
// PCR 12042104 - Unique Extended Headers SAIRS Parameter - START
   parameter UNIQUE_EXT_HEADERS           = 0,  // set to 1 to make the register agent modules use the new extended header
   parameter SAIWIDTH                     = 15, // SAI field width - MAX=15
   parameter RSWIDTH                      = 3,  // RS field width - MAX=3
// PCR 12042104 - Unique Extended Headers SAIRS Parameter - FINISH
   parameter AGENT_USYNC_DELAY            = 1,
   parameter SIDE_USYNC_DELAY             = 1,
// SBC-PCN-007 - Insert completion counter parameters - START
   parameter EXPECTED_COMPLETIONS_COUNTER = 0, // set to 1 if expected completion counters are needed
   parameter ISM_COMPLETION_FENCING       = 0, // set to 1 if the ISM should stay ACTIVE with exp completions
// SBC-PCN-007 - Insert completion counter parameters - FINISH
   parameter SIDE_CLKREQ_HYST_CNT         = 15, // sets the clock request modules hysteresis counter
   parameter CLKREQDEFAULT                = 0,  // clkreq reset/default value to be 0/1
   parameter SB_PARITY_REQUIRED           = 0,  // configures the Endpoint to support parity handling
   parameter DO_SERR_MASTER               = 0,  // controls generation of the DO_SERR message during parity error
   parameter GLOBAL_EP                    = 0,  // EP is in global mode supporting heirarchical headers
   parameter GLOBAL_EP_IS_STRAP           = 0,
   parameter BULKRDWR                     = 0,  // Save-Restore or Buld Read/Write
   parameter BULK_PERF                    = 0   // Bulk Read Write for performance (no bubble when streaming register messages)


) (
   // Clock/Reset Signals
   side_clk,
   gated_side_clk,
   side_rst_b,

   agent_clk,    // AGENT clock/reset, only used
   //                             agent_rst_b,  // for asynch endpoint

   usyncselect,
   side_usync,
   agent_usync,

   // Clock gating ISM Signals (endpoint)
   agent_clkreq,
   agent_idle,
   side_ism_fabric,
   side_ism_agent,
   side_clkreq,
   side_clkack,
   side_ism_lock_b,  // SBC-PCN-002 - New ISM Lock for Power gating flows

   // Clock gating ISM Signals (agent block)
   sbe_clkreq,
   sbe_idle,
   sbe_clk_valid,

   // Egress port interface to the IOSF Sideband Channel
   mpccup,        //
   mnpcup,        //
   mpcput,        //
   mnpput,        //
   meom,          //
   mpayload,      //
   mparity,       //

   // Ingress port interface to the IOSF Sideband Channel
   tpccup,        //
   tnpcup,        //
   tpcput,        //
   tnpput,        //
   teom,          //
   tpayload,      //
   tparity,       //

   // Target interface to the agent block
   tmsg_pcfree,   //
   tmsg_npfree,   //
   tmsg_npclaim,  //
   tmsg_pcput,    //
   tmsg_npput,    //
   tmsg_pcmsgip,  //
   tmsg_npmsgip,  //
   tmsg_pceom,    //
   tmsg_npeom,    //
   tmsg_pcpayload,//
   tmsg_nppayload,//
   tmsg_pccmpl,   //
   tmsg_npvalid,
   tmsg_pcvalid,
   tmsg_pcparity,
   tmsg_npparity,

   // Parity Message interface
    do_serr_hier_dstid_strap,
    do_serr_hier_srcid_strap,
    do_serr_srcid_strap,
    do_serr_dstid_strap,
    do_serr_tag_strap,
    global_ep_strap,
    do_serr_sairs_valid,
    do_serr_sai,
    do_serr_rs,
    ext_parity_err_detected,
    sbe_parity_err_out,
    fdfx_sbparity_def,

// PCR 12042104 - Unique Extended Headers SAIRS Inputs - START
   ur_csairs_valid,   // lintra s-70036 s-0527 "Indicates when the sairs inputs are valid and should be used"
   ur_csai,           // lintra s-70036 s-0527 "SAI value for extended headers"
   ur_crs,            // lintra s-70036 s-0527 "RS value for extended headers"
   ur_rx_sairs_valid, // lintra s-70036 s-0527 "Indicates when the sairs inputs are valid and should be used"
   ur_rx_sai,         // lintra s-70036 s-0527 "SAI value for extended headers"
   ur_rx_rs,          // lintra s-70036 s-0527 "RS value for extended headers"
// PCR 12042104 - Unique Extended Headers SAIRS Inputs - FINISH

// SBC-PCN-007 - Insert completion counter outputs - START
   sbe_comp_exp,
// SBC-PCN-007 - Insert completion counter outputs - FINISH

   // Master interface to the agent block
   mmsg_pcirdy,   //
   mmsg_npirdy,   //
   mmsg_pceom,    //
   mmsg_npeom,    //
   mmsg_pcpayload,//
   mmsg_nppayload,//
   mmsg_pcparity,//
   mmsg_npparity,//
   mmsg_pctrdy,   //
   mmsg_nptrdy,   //
   mmsg_pcmsgip,  //
   mmsg_npmsgip,  //
   mmsg_pcsel,    //
   mmsg_npsel,    //

   // Target Register Access Interface
   // From the agent block:
   treg_trdy,     // Ready to complete
   // register access msg
   treg_cerr,     // Completion error
   treg_rdata,    // Read data
   // From the endpoint
   treg_irdy,     // Endpoint ready
   treg_np,       // 1=non-posted/0=posted
   treg_dest,     // Destination Port ID
   treg_source,   // Source Port ID
   treg_opcode,   // Reg access opcode
   treg_addrlen,  // Address length
   treg_bar,      // Selected BAR
   treg_tag,      // Transaction tag
   treg_be,       // Byte enables
   treg_fid,      // Function ID
   treg_addr,     // Address
   treg_wdata,    // Write data
   treg_eh,       //   state of 'eh' bit in standard header
   treg_ext_header, // received extended headers
   treg_eh_discard, // indicates unsupported header discarded
// PCR 12042104 - Unique Extended Headers SAIRS Inputs - START
   treg_csairs_valid,   // Indicates when the sairs inputs are valid and should be used
   treg_csai,           // SAI value for extended headers
   treg_crs,            // RS value for extended headers
   treg_rx_sairs_valid, // Indicates when the sairs inputs are valid and should be used
   treg_rx_sai,         // SAI value for extended headers
   treg_rx_rs,          // RS value for extended headers
// PCR 12042104 - Unique Extended Headers SAIRS Inputs - FINISH
// Hier Bridge PCR
   treg_hier_destid,
   treg_hier_srcid,

   // Master Register Access Interface
   // From the agent block:
   mreg_irdy,     // Reg access msg ready
   mreg_npwrite,  // Np=1 / posted=0 write
   mreg_dest,     // Destination Port ID
   mreg_source,   // Source Port ID
   mreg_opcode,   // Reg Access Opcode
   mreg_addrlen,  // Address length
   mreg_bar,      // Selected BAR
   mreg_tag,      // Transaction tag
   mreg_be,       // Byte enables
   mreg_fid,      // Function ID
   mreg_addr,     // Address
   mreg_wdata,    // Write data
   // From the endpoint:
   mreg_trdy,     // Target (endpnt) ready
   mreg_pmsgip,   // Message in-progress posted
   mreg_nmsgip,   // Message in-progress non-posted
// PCR 12042104 - Unique Extended Headers SAIRS Inputs - START
   mreg_sairs_valid, // Indicates when the sairs inputs are valid and should be used
   mreg_sai,         // SAI value for extended headers
   mreg_rs,          // RS value for extended headers
// PCR 12042104 - Unique Extended Headers SAIRS Inputs - FINISH
   mreg_hier_destid,
   mreg_hier_srcid,

   // extended header inputs.
   tx_ext_headers,

   // Config register Inputs
   cgctrl_idlecnt,   // Config
   cgctrl_clkgaten,  // registers
   cgctrl_clkgatedef,

   // DFx
   visa_all_disable,
   visa_customer_disable,
   avisa_data_out,
   avisa_clk_out,
   visa_ser_cfg_in,
   sbe_visa_bypass_cr_out, // HSD 1407277880
   sbe_visa_serial_rd_out, // HSD 1407277854

   visa_port_tier1_sb,      // VISA debug candidates
   visa_fifo_tier1_sb,     // high priority
   visa_fifo_tier1_ag,
   visa_agent_tier1_ag,
   visa_reg_tier1_ag,


   visa_port_tier2_sb,       // VISA debug candidates
   visa_fifo_tier2_sb,     // low priority
   visa_fifo_tier2_ag,
   visa_agent_tier2_ag,
   visa_reg_tier2_ag,

   jta_clkgate_ovrd, // JTAG overrides
   jta_force_clkreq, //
   jta_force_idle,   //
   jta_force_notidle,//
   jta_force_creditreq,
   fscan_latchopen,     //
   fscan_latchclosed_b, //
   fscan_clkungate,      // scan mode clock gate override
   fscan_clkungate_syn,
   fscan_rstbypen,
   fscan_byprst_b,
   fscan_mode,
   fscan_shiften,

   fdfx_rst_b            // New reset for VISA ULM

   );

`include "hqm_sbcglobal_params.vm"
`include "hqm_sbcstruct_local.vm"

  localparam TBE_WIDTH      = MAXTRGTDATA == 31 ? 3         : 7;
  localparam MBE_WIDTH      = MAXMSTRDATA == 31 ? 3         : 7;
  localparam TADR_WIDTH     = MAXTRGTADDR < 15  ? 15        : MAXTRGTADDR > 47 ? 47 : MAXTRGTADDR;
  localparam MADR_WIDTH     = MAXMSTRADDR < 15  ? 15        : MAXMSTRADDR > 47 ? 47 : MAXMSTRADDR;
  localparam INTERNALPLDBIT = (MATCHED_INTERNAL_WIDTH == 1)  ? MAXPLDBIT : 31; // Maximum payload bit, should be 7, 15 or 31

  input  logic                           side_clk;
  output logic                           gated_side_clk;
  input  logic                           side_rst_b;

  input  logic                           agent_clk;    // AGENT clock/reset; only used
//  input  logic                           agent_rst_b;  // for asynch endpoint

  input  logic                           usyncselect;
  input  logic                           side_usync;
  input  logic                           agent_usync;

  // Clock gating ISM Signals (endpoint)
  input  logic                           agent_clkreq;
  input  logic                           agent_idle;
  input  logic                     [2:0] side_ism_fabric;
  output logic                     [2:0] side_ism_agent;
  output logic                           side_clkreq;
  input  logic                           side_clkack;
  input  logic                           side_ism_lock_b; // SBC-PCN-002 - Sideband ISM Lock signal

  // Clock gating ISM Signals (agent block)
  output logic                           sbe_clkreq;
  output logic                           sbe_idle;
  output logic                           sbe_clk_valid;

  // Egress port interface to the IOSF Sideband Channel
  input  logic                           mpccup;        //
  input  logic                           mnpcup;        //
  output logic                           mpcput;        //
  output logic                           mnpput;        //
  output logic                           meom;          //
  output logic    [MAXPLDBIT:0]          mpayload;      //
  output logic                           mparity;       // lintra s-2058, s-70044

  // Ingress port interface to the IOSF Sideband Channel
  output logic                           tpccup;        //
  output logic                           tnpcup;        //
  input  logic                           tpcput;        //
  input  logic                           tnpput;        //
  input  logic                           teom;          //
  input  logic    [MAXPLDBIT:0]          tpayload;      //
  input  logic                           tparity;       // lintra s-70036, s-0527

  // Target interface to the agent block
  input  logic             [MAXPCTRGT:0] tmsg_pcfree;   //
  input  logic             [MAXNPTRGT:0] tmsg_npfree;   //
  input  logic             [MAXNPTRGT:0] tmsg_npclaim;  //
  output logic                           tmsg_pcput;    //
  output logic                           tmsg_npput;    //
  output logic                           tmsg_pcmsgip;  //
  output logic                           tmsg_npmsgip;  //
  output logic                           tmsg_pceom;    //
  output logic                           tmsg_npeom;    //
  output logic        [INTERNALPLDBIT:0] tmsg_pcpayload;//
  output logic        [INTERNALPLDBIT:0] tmsg_nppayload;//
  output logic                           tmsg_pccmpl;   //
  output logic                           tmsg_npvalid;
  output logic                           tmsg_pcvalid;
  output logic                           tmsg_pcparity;
  output logic                           tmsg_npparity;
   // Parity Message interface
  input  logic      [7:0]                do_serr_hier_dstid_strap;
  input  logic      [7:0]                do_serr_hier_srcid_strap;
  input  logic      [7:0]                do_serr_srcid_strap;
  input  logic      [7:0]                do_serr_dstid_strap;
  input  logic      [2:0]                do_serr_tag_strap;
  input  logic                           global_ep_strap;
  input  logic                           do_serr_sairs_valid;
  input  logic              [SAIWIDTH:0] do_serr_sai;
  input  logic              [ RSWIDTH:0] do_serr_rs;
  output logic                           sbe_parity_err_out;
  input  logic                           ext_parity_err_detected;  // lintra s-70036, s-0527
  input  logic                           fdfx_sbparity_def;

// PCR 12042104 - Unique Extended Headers SAIRS Inputs - START
  input  logic                           ur_csairs_valid;   // lintra s-70036 s-0527 "Indicates when the sairs inputs are valid and should be used"
  input  logic              [SAIWIDTH:0] ur_csai;           // lintra s-70036 s-0527 "SAI value for extended headers"
  input  logic              [ RSWIDTH:0] ur_crs;            // lintra s-70036 s-0527 "RS value for extended headers"
  output logic                           ur_rx_sairs_valid; // lintra s-70036 s-0527 "Indicates when the sairs inputs are valid and should be used"
  output logic              [SAIWIDTH:0] ur_rx_sai;         // lintra s-70036 s-0527 "SAI value for extended headers"
  output logic              [ RSWIDTH:0] ur_rx_rs;          // lintra s-70036 s-0527 "RS value for extended headers"
// PCR 12042104 - Unique Extended Headers SAIRS Inputs - FINISH

// SBC-PCN-007 - Insert completion counter outputs - START
  output logic                           sbe_comp_exp;
// SBC-PCN-007 - Insert completion counter outputs - FINISH

  // Master interface to the agent block
  input  logic             [MAXPCMSTR:0] mmsg_pcirdy;   //
  input  logic             [MAXNPMSTR:0] mmsg_npirdy;   //
  input  logic             [MAXPCMSTR:0] mmsg_pceom;    //
  input  logic             [MAXNPMSTR:0] mmsg_npeom;    //
  input  logic       [(INTERNALPLDBIT+1)*MAXPCMSTR+INTERNALPLDBIT:0] mmsg_pcpayload;//
  input  logic       [(INTERNALPLDBIT+1)*MAXNPMSTR+INTERNALPLDBIT:0] mmsg_nppayload;//
  input  logic             [MAXPCMSTR:0] mmsg_pcparity;    //
  input  logic             [MAXNPMSTR:0] mmsg_npparity;    //
  output logic                           mmsg_pctrdy;   //
  output logic                           mmsg_nptrdy;   //
  output logic                           mmsg_pcmsgip;  //
  output logic                           mmsg_npmsgip;  //
  output logic             [MAXPCMSTR:0] mmsg_pcsel;    //
  output logic             [MAXNPMSTR:0] mmsg_npsel;    //

  // Target Register Access Interface
                                                        // From the agent block:
  input  logic                           treg_trdy;     // lintra s-0527, s-70036 "Ready to complete"
                                                        // register access msg
  input  logic                           treg_cerr;     // lintra s-0527, s-70036 "Completion error"
  input  logic [MAXTRGTDATA:0]           treg_rdata;    // lintra s-0527, s-70036 "Read data"
                                                        // From the endpoint
  output logic                           treg_irdy;     // Endpoint ready
  output logic                           treg_np;       // 1=non-posted/0=posted
  output logic                     [7:0] treg_dest;     // Destination Port ID
  output logic                     [7:0] treg_source;   // Source Port ID
  output logic                     [7:0] treg_opcode;   // Reg access opcode
  output logic                           treg_addrlen;  // Address length
  output logic                     [2:0] treg_bar;      // Selected BAR
  output logic                     [2:0] treg_tag;      // Transaction tag
  output logic [TBE_WIDTH:0]             treg_be;       // Byte enables
  output logic                     [7:0] treg_fid;      // Function ID
  output logic [TADR_WIDTH:0]            treg_addr;     // Address
  output logic [MAXTRGTDATA:0]           treg_wdata;    // Write data
  output logic                           treg_eh;       //   state of 'eh' bit in standard header
  output logic [NUM_RX_EXT_HEADERS:0][31:0] treg_ext_header; // received extended headers
  output logic                           treg_eh_discard; // indicates unsupported header discarded
// PCR 12042104 - Unique Extended Headers SAIRS Inputs - START
  input  logic                           treg_csairs_valid;   // lintra s-0527, s-70036 "Indicates when the sairs inputs are valid and should be used"
  input  logic [SAIWIDTH:0]              treg_csai;           // lintra s-0527, s-70036 "SAI value for extended headers"
  input  logic [RSWIDTH:0]               treg_crs;            // lintra s-0527, s-70036 "RS value for extended headers"
  output logic                           treg_rx_sairs_valid; // lintra s-0527, s-70036 "Indicates when the sairs inputs are valid and should be used"
  output logic [SAIWIDTH:0]              treg_rx_sai;         // lintra s-0527, s-70036 "SAI value for extended headers"
  output logic [RSWIDTH:0]               treg_rx_rs;          // lintra s-0527, s-70036 "RS value for extended headers"
// PCR 12042104 - Unique Extended Headers SAIRS Inputs - FINISH
// Hier Bridge PCR
  output logic [7:0]                     treg_hier_destid;
  output logic [7:0]                     treg_hier_srcid;

  // Master Register Access Interface
                                                        // From the agent block:
  input  logic                           mreg_irdy;     // lintra s-0527, s-70036 Reg access msg ready
  input  logic                           mreg_npwrite;  // lintra s-0527, s-70036 Np=1 / posted=0 write
  input  logic                     [7:0] mreg_dest;     // lintra s-0527, s-70036 Destination Port ID
  input  logic                     [7:0] mreg_source;   // lintra s-0527, s-70036 Source Port ID
  input  logic                     [7:0] mreg_opcode;   // lintra s-0527, s-70036 Reg Access Opcode
  input  logic                           mreg_addrlen;  // lintra s-0527, s-70036 Address length
  input  logic                     [2:0] mreg_bar;      // lintra s-0527, s-70036 Selected BAR
  input  logic                     [2:0] mreg_tag;      // lintra s-0527, s-70036 Transaction tag
  input  logic [MBE_WIDTH:0]             mreg_be;       // lintra s-0527, s-70036 Byte enables
  input  logic                     [7:0] mreg_fid;      // lintra s-0527, s-70036 Function ID
  input  logic [MADR_WIDTH:0]            mreg_addr;     // lintra s-0527, s-70036 Address
  input  logic [MAXMSTRDATA:0]           mreg_wdata;    // lintra s-0527, s-70036 Write data
                                                        // From the endpoint:
  output logic                           mreg_trdy;     // Target (endpnt) ready
  output logic                           mreg_pmsgip;   // Message in-progress
  output logic                           mreg_nmsgip;   // indicators
                                                        // non-posted message
// PCR 12042104 - Unique Extended Headers SAIRS Inputs - START
  input  logic                           mreg_sairs_valid; // lintra s-0527, s-70036 "Indicates when the sairs inputs are valid and should be used"
  input  logic [SAIWIDTH:0]              mreg_sai;         // lintra s-0527, s-70036 "SAI value for extended headers"
  input  logic [RSWIDTH:0]               mreg_rs;          // lintra s-0527, s-70036 "RS value for extended headers"
// PCR 12042104 - Unique Extended Headers SAIRS Inputs - FINISH

  input                           [7:0]  mreg_hier_destid; // lintra s-0527, s-70036 "hier hdr src/dest used in global ep only"
  input                           [7:0]  mreg_hier_srcid; // lintra s-0527, s-70036 "hier hdr src/dest used in global ep only"
  
  // extended header inputs.
  input  logic [NUM_TX_EXT_HEADERS:0][31:0] tx_ext_headers;

  // Config register Inputs
  input  logic                     [7:0] cgctrl_idlecnt;   // Config
  input  logic                           cgctrl_clkgaten;  // registers
  input  logic                           cgctrl_clkgatedef;

  // DFx
  input logic                                                                visa_all_disable;      // lintra s-0527, s-70036 "Used when ULM is inserted into endpoint"
  input logic                                                                visa_customer_disable; // lintra s-0527, s-70036 "Used when ULM is inserted into endpoint"
  output logic [(NUMBER_OF_OUTPUT_LANES-1):0][(NUMBER_OF_BITS_PER_LANE-1):0] avisa_data_out;        // lintra s-2058, s-70044 "Used when ULM is inserted into endpoint"
  output logic [(NUMBER_OF_OUTPUT_LANES-1):0]                                avisa_clk_out;         // lintra s-2058, s-70044 "Used when ULM is inserted into endpoint"
  input logic [2:0]                                                          visa_ser_cfg_in;       // lintra s-0527, s-70036 "Used when ULM is inserted into endpoint"

  // HSD  1407277880 
  output logic  [(NUMBER_OF_OUTPUT_LANES-1):0]  sbe_visa_bypass_cr_out;   // lintra s-2058
  output logic                                  sbe_visa_serial_rd_out;   // lintra s-2058  
  
  output visa_port_tier1                 visa_port_tier1_sb;      // VISA debug candidates
  output visa_epfifo_tier1_sb            visa_fifo_tier1_sb;     // high priority
  output visa_epfifo_tier1_ag            visa_fifo_tier1_ag;
  output visa_agent_tier1                visa_agent_tier1_ag;
  output visa_reg_tier1                  visa_reg_tier1_ag;

  output visa_port_tier2                 visa_port_tier2_sb;       // VISA debug candidates
  output visa_epfifo_tier2_sb            visa_fifo_tier2_sb;     // low priority
  output visa_epfifo_tier2_ag            visa_fifo_tier2_ag;
  output visa_agent_tier2                visa_agent_tier2_ag;
  output visa_reg_tier2                  visa_reg_tier2_ag;

  input  logic                           jta_clkgate_ovrd; // JTAG overrides
  input  logic                           jta_force_clkreq; //
  input  logic                           jta_force_idle;   //
  input  logic                           jta_force_notidle;//
  input  logic                           jta_force_creditreq;
  input  logic                           fscan_latchopen;     //
  input  logic                           fscan_latchclosed_b; //
  input  logic                           fscan_clkungate;      // scan mode clock gate override
  input  logic                           fscan_clkungate_syn;
  input  logic                           fscan_rstbypen;
  input  logic                           fscan_byprst_b;
  input  logic                           fscan_shiften;
  input  logic                           fscan_mode;
  input  logic                           fdfx_rst_b; // lintra s-0527, s-70036 "Used by VISA ULM when inserted"


localparam AGDBGMAXBIT   = ASYNCENDPT ? 95 : 63;

localparam EXTMAXPLDBIT  = MAXPLDBIT;
localparam RATAENABLE    = ((BULKRDWR==1) | (TARGETREG==1));
localparam TREGOVERRIDE  = (TARGETREG==1) & (BULKRDWR==0) ?  1 : 0; // if both treg and bulk are enabled, tie treg to 0
localparam BASEMAXPCTRGT = MAXPCTRGT + (RATAENABLE==1 ? 1 : 0);
localparam BASEMAXNPTRGT = MAXNPTRGT + (RATAENABLE==1 ? 1 : 0);
localparam BASEMAXPCMSTR = MAXPCMSTR + (RATAENABLE==1 ? 1 : 0)
                                     + (MASTERREG==1 ? 1 : 0);
localparam BASEMAXNPMSTR = MAXNPMSTR + (MASTERREG==1 ? 1 : 0);
localparam BASEMAXPCMSTRMIN1 = (RATAENABLE==1) & (MASTERREG==1)
                               ? BASEMAXPCMSTR-1 : BASEMAXPCMSTR;

// Target interface to the agent block
logic       [BASEMAXPCTRGT:0] sbi_sbe_tmsg_pcfree;
logic       [BASEMAXNPTRGT:0] sbi_sbe_tmsg_npfree;
logic       [BASEMAXNPTRGT:0] sbi_sbe_tmsg_npclaim;

  // somewhat convoluted free / claim logic.
  // had to switch to a generate statement based on
  // parameters in order to convert original assign statements
  // to always_comb to make VCS happy.
  // generate statements needed to accomodate variable bus sizes
  // (modelsim doesn't allow always_comb to assign part of bus
  // and have output ports drive the rest)
  logic                       tmsg_pcfree_trgtreg;
  logic                       tmsg_npfree_trgtreg;
  logic                       tmsg_npclaim_trgtreg;

  // parity err detected from treg widget to tmsg
logic                       treg_tmsg_parity_err_det;
logic                       all_ext_parity_err_det;
generate
    if (SB_PARITY_REQUIRED) begin: gen_ext_par_err
        always_comb all_ext_parity_err_det = (treg_tmsg_parity_err_det | ext_parity_err_detected) & ~fdfx_sbparity_def; end
    else begin : gen_no_ext_par_err
        always_comb all_ext_parity_err_det = '0; end
endgenerate

  generate
    if ( RATAENABLE == 1 )
      begin : gen_treg_blk0
        always_comb sbi_sbe_tmsg_pcfree  = { tmsg_pcfree_trgtreg, tmsg_pcfree };
        always_comb sbi_sbe_tmsg_npfree  = { tmsg_npfree_trgtreg, tmsg_npfree };
        always_comb sbi_sbe_tmsg_npclaim = { tmsg_npclaim_trgtreg, tmsg_npclaim };
      end
    else
      begin : gen_ntreg_blk0
        always_comb sbi_sbe_tmsg_pcfree  = { tmsg_pcfree  };
        always_comb sbi_sbe_tmsg_npfree  = { tmsg_npfree  };
        always_comb sbi_sbe_tmsg_npclaim = { tmsg_npclaim };
      end
  endgenerate

  // Master interface to the agent block
  logic [BASEMAXPCMSTR:0]       sbi_sbe_mmsg_pcirdy;
  logic [BASEMAXNPMSTR:0]       sbi_sbe_mmsg_npirdy;
  logic [BASEMAXPCMSTR:0]       sbi_sbe_mmsg_pceom;
  logic [BASEMAXNPMSTR:0]       sbi_sbe_mmsg_npeom;
  logic [(INTERNALPLDBIT+1)*BASEMAXPCMSTR+INTERNALPLDBIT:0] sbi_sbe_mmsg_pcpayload;
  logic [(INTERNALPLDBIT+1)*BASEMAXNPMSTR+INTERNALPLDBIT:0] sbi_sbe_mmsg_nppayload;
  logic [BASEMAXPCMSTR:0]       sbi_sbe_mmsg_pcparity;
  logic [BASEMAXNPMSTR:0]       sbi_sbe_mmsg_npparity;

  logic                         mmsg_pcirdy_mstrreg, mmsg_pceom_mstrreg, mmsg_pcparity_mstrreg, // lintra s-0531
                                mmsg_npirdy_mstrreg, mmsg_npeom_mstrreg, mmsg_npparity_mstrreg; // lintra s-0531

  logic [INTERNALPLDBIT:0]      mmsg_pcpayload_mstrreg, mmsg_nppayload_mstrreg; // lintra s-0531
  logic                         mmsg_pcirdy_trgtreg, mmsg_pceom_trgtreg, mmsg_pcparity_trgtreg;
  logic [INTERNALPLDBIT:0]      mmsg_pcpayload_trgtreg;

  generate
    if ( (RATAENABLE == 1) && (MASTERREG == 1) )
      begin : gen_treg1_mreg1_blk
        always_comb sbi_sbe_mmsg_pcirdy    = { mmsg_pcirdy_mstrreg, mmsg_pcirdy_trgtreg, mmsg_pcirdy };
        always_comb sbi_sbe_mmsg_pceom     = { mmsg_pceom_mstrreg, mmsg_pceom_trgtreg, mmsg_pceom };
        always_comb sbi_sbe_mmsg_pcpayload = { mmsg_pcpayload_mstrreg, mmsg_pcpayload_trgtreg, mmsg_pcpayload };
        always_comb sbi_sbe_mmsg_pcparity  = { mmsg_pcparity_mstrreg, mmsg_pcparity_trgtreg, mmsg_pcparity};
        always_comb sbi_sbe_mmsg_npirdy    = { mmsg_npirdy_mstrreg, mmsg_npirdy };
        always_comb sbi_sbe_mmsg_npeom     = { mmsg_npeom_mstrreg, mmsg_npeom};
        always_comb sbi_sbe_mmsg_npparity  = { mmsg_npparity_mstrreg, mmsg_npparity};
        always_comb sbi_sbe_mmsg_nppayload = { mmsg_nppayload_mstrreg, mmsg_nppayload};
      end
    else if ( (RATAENABLE == 1) && (MASTERREG == 0) )
      begin : gen_treg1_mreg0_blk
        always_comb sbi_sbe_mmsg_pcirdy    = { mmsg_pcirdy_trgtreg, mmsg_pcirdy };
        always_comb sbi_sbe_mmsg_pceom     = { mmsg_pceom_trgtreg, mmsg_pceom };
        always_comb sbi_sbe_mmsg_pcpayload = { mmsg_pcpayload_trgtreg, mmsg_pcpayload };
        always_comb sbi_sbe_mmsg_pcparity  = { mmsg_pcparity_trgtreg, mmsg_pcparity};
        always_comb sbi_sbe_mmsg_npirdy    = { mmsg_npirdy };
        always_comb sbi_sbe_mmsg_npeom     = { mmsg_npeom};
        always_comb sbi_sbe_mmsg_npparity  = { mmsg_npparity};
        always_comb sbi_sbe_mmsg_nppayload = { mmsg_nppayload};
      end
    else if ( (RATAENABLE == 0) && (MASTERREG == 1) )
      begin : gen_treg0_mreg1_blk
        always_comb sbi_sbe_mmsg_pcirdy    = { mmsg_pcirdy_mstrreg, mmsg_pcirdy };
        always_comb sbi_sbe_mmsg_pceom     = { mmsg_pceom_mstrreg, mmsg_pceom };
        always_comb sbi_sbe_mmsg_pcpayload = { mmsg_pcpayload_mstrreg, mmsg_pcpayload };
        always_comb sbi_sbe_mmsg_pcparity  = { mmsg_pcparity_mstrreg, mmsg_pcparity};
        always_comb sbi_sbe_mmsg_npirdy    = { mmsg_npirdy_mstrreg, mmsg_npirdy };
        always_comb sbi_sbe_mmsg_npeom     = { mmsg_npeom_mstrreg, mmsg_npeom};
        always_comb sbi_sbe_mmsg_nppayload = { mmsg_nppayload_mstrreg, mmsg_nppayload};
        always_comb sbi_sbe_mmsg_npparity  = { mmsg_npparity_mstrreg, mmsg_npparity};

      end
    else
      begin : gen_treg0_mreg0_blk
        always_comb sbi_sbe_mmsg_pcirdy[      MAXPCMSTR   :0] = mmsg_pcirdy;
        always_comb sbi_sbe_mmsg_pceom[       MAXPCMSTR   :0] = mmsg_pceom;
        always_comb sbi_sbe_mmsg_pcpayload[(INTERNALPLDBIT+1)*MAXPCMSTR+INTERNALPLDBIT:0] = mmsg_pcpayload;
        always_comb sbi_sbe_mmsg_pcparity[    MAXPCMSTR   :0] = mmsg_pcparity;
        always_comb sbi_sbe_mmsg_npirdy[      MAXNPMSTR   :0] = mmsg_npirdy;
        always_comb sbi_sbe_mmsg_npeom[       MAXNPMSTR   :0] = mmsg_npeom;
        always_comb sbi_sbe_mmsg_nppayload[(INTERNALPLDBIT+1)*MAXNPMSTR+INTERNALPLDBIT:0] = mmsg_nppayload;
        always_comb sbi_sbe_mmsg_npparity[    MAXNPMSTR   :0] = mmsg_npparity;
      end
  endgenerate

logic       [BASEMAXPCMSTR:0] sbe_sbi_mmsg_pcsel;
logic       [BASEMAXNPMSTR:0] sbe_sbi_mmsg_npsel;

always_comb mmsg_pcsel = sbe_sbi_mmsg_pcsel[MAXPCMSTR:0];
always_comb mmsg_npsel = sbe_sbi_mmsg_npsel[MAXNPMSTR:0];

// Clock gating ISM signals
logic idle_trgtreg;
logic idle_mstrreg;
logic sbi_sbe_idle;


// asynchronous reset synchronization
logic agent_rst_b_sync;     // lintra s-0531  "Used for asynchronous endpoints"
logic agent_rst_b_sync_pre; // lintra s-0531  "Used for asynchronous endpoints"
logic agent_side_clk;       // lintra s-70036 "Used for asynchronous endpoints"
logic agent_side_rst_b;
logic sbe_sbi_clk_valid;

// added scan bypass mux to improve atpg
logic side_rst_b1;

//always_comb side_rst_b1  =  fscan_rstbypen ? fscan_byprst_b : side_rst_b;

 hqm_sbc_ctech_scan_mux scanbypass_mux ( 
         .d ( side_rst_b           ),
         .si( fscan_byprst_b       ),
         .se( fscan_rstbypen       ),
         .o ( side_rst_b1          )
         );

generate
   if ( |ASYNCENDPT ) begin : gen_async_rst_blk
      hqm_sbc_doublesync agent_rst_sync (
         .d     ( 1'b1                 ), // lintra s-80018
         .clr_b ( side_rst_b1          ),
         .clk   ( agent_clk            ),
         .q     ( agent_rst_b_sync_pre )
      );

      hqm_sbc_ctech_scan_mux i_sbc_ctech_scan_mux_clkreq_async_scanned ( // lintra s-80018
         .d ( agent_rst_b_sync_pre ),
         .si( fscan_byprst_b       ),
         .se( fscan_rstbypen       ),
         .o ( agent_rst_b_sync     )
      );

      always_comb agent_side_clk   = agent_clk;
      always_comb agent_side_rst_b = agent_rst_b_sync;
   end else begin : gen_sync_rst_blk
      always_comb agent_side_clk   = gated_side_clk;
      always_comb agent_side_rst_b = side_rst_b1;
   end
endgenerate

  always_comb sbi_sbe_idle = idle_mstrreg & agent_idle;

  always_comb sbe_clk_valid = sbe_sbi_clk_valid;

  logic  agent_clkreq_int;
  logic  sbe_clkreq_int;

  // removed trgtreg from idle equation, but adding to clkreq equation to ensure
  // clock is still active to clear the transaction.

  always_comb agent_clkreq_int = agent_clkreq | ~idle_trgtreg;
  always_comb sbe_clkreq       = sbe_clkreq_int | ~idle_trgtreg;

//------------------------------------------------------------------------------
//
// sbebase: Base Endpoint
//
//------------------------------------------------------------------------------
hqm_sbebase #( // lintra s-80017
  .MAXPLDBIT                   ( EXTMAXPLDBIT                       ),
  .INTERNALPLDBIT              ( INTERNALPLDBIT                     ),
  .NPQUEUEDEPTH                ( NPQUEUEDEPTH                       ),
  .PCQUEUEDEPTH                ( PCQUEUEDEPTH                       ),
  .CUP2PUT1CYC                 ( 0                                  ),
  .LATCHQUEUES                 ( LATCHQUEUES                        ),
  .MAXPCTRGT                   ( BASEMAXPCTRGT                      ),
  .MAXNPTRGT                   ( BASEMAXNPTRGT                      ),
  .MAXPCMSTR                   ( BASEMAXPCMSTR                      ),
  .MAXNPMSTR                   ( BASEMAXNPMSTR                      ),
  .ASYNCENDPT                  ( ASYNCENDPT                         ),
  .ASYNCIQDEPTH                ( ASYNCIQDEPTH                       ),
  .ASYNCEQDEPTH                ( ASYNCEQDEPTH                       ),
  .VALONLYMODEL                ( 0                                  ),
  .DUMMY_CLKBUF                ( DUMMY_CLKBUF                       ),
  .RX_EXT_HEADER_SUPPORT       ( RX_EXT_HEADER_SUPPORT              ),
  .TX_EXT_HEADER_SUPPORT       ( TX_EXT_HEADER_SUPPORT              ),
  .NUM_TX_EXT_HEADERS          ( NUM_TX_EXT_HEADERS                 ),
  .RST_PRESYNC                 ( ASYNCENDPT                         ),
  .DISABLE_COMPLETION_FENCING  ( DISABLE_COMPLETION_FENCING         ),
  .SKIP_ACTIVEREQ              ( SKIP_ACTIVEREQ                     ),
  .PIPEISMS                    ( PIPEISMS                           ),
  .PIPEINPS                    ( PIPEINPS                           ),
  .USYNC_ENABLE                ( USYNC_ENABLE                       ),
  .AGENT_USYNC_DELAY           ( AGENT_USYNC_DELAY                  ),
  .SIDE_USYNC_DELAY            ( SIDE_USYNC_DELAY                   ),
// PCR 12042104 - Unique Extended Headers SAIRS Parameter - START
  .UNIQUE_EXT_HEADERS          ( UNIQUE_EXT_HEADERS                 ),
  .RSWIDTH                     ( RSWIDTH                            ),
  .SAIWIDTH                    ( SAIWIDTH                           ),
// PCR 12042104 - Unique Extended Headers SAIRS Parameter - FINISH
// SBC-PCN-007 - Adding in expected completions counter to wrapper - START
  .EXPECTED_COMPLETIONS_COUNTER( EXPECTED_COMPLETIONS_COUNTER       ),
  .ISM_COMPLETION_FENCING      ( ISM_COMPLETION_FENCING             ),
// SBC-PCN-007 - Adding in expected completions counter to wrapper - FINISH
  .SIDE_CLKREQ_HYST_CNT        ( SIDE_CLKREQ_HYST_CNT               ),
  .CLKREQDEFAULT               ( CLKREQDEFAULT                      ),
//  .NUM_REPEATER_FLOPS (NUM_REPEATER_FLOPS),
  .CLAIM_DELAY				   ( CLAIM_DELAY     					),
  .SB_PARITY_REQUIRED          ( SB_PARITY_REQUIRED                 ),
  .DO_SERR_MASTER              ( DO_SERR_MASTER                     ),
  .GLOBAL_EP                   ( GLOBAL_EP                          ),
  .GLOBAL_EP_IS_STRAP          ( GLOBAL_EP_IS_STRAP                 ),
  .RELATIVE_PLACEMENT_EN       ( RELATIVE_PLACEMENT_EN              )
) sbebase (
  .side_clk                ( side_clk                               ),
  .gated_side_clk          ( gated_side_clk                         ),
  .side_rst_b              ( side_rst_b1                            ),
  .agent_clk               ( agent_clk                              ),
  .agent_side_rst_b_sync   ( agent_side_rst_b                       ),
  .usyncselect             ( usyncselect                            ),
  .side_usync              ( side_usync                             ),
  .agent_usync             ( agent_usync                            ),
  .sbi_sbe_clkreq          ( agent_clkreq_int                       ),
  .sbi_sbe_idle            ( sbi_sbe_idle                           ),
  .side_ism_fabric         ( side_ism_fabric                        ),
  .side_ism_agent          ( side_ism_agent                         ),
  .side_ism_lock_b         ( side_ism_lock_b                        ), // SBC-PCN-002 - Lock the sideband ISM for power gating
  .side_clkreq             ( side_clkreq                            ),
  .side_clkack             ( side_clkack                            ),
  .sbe_sbi_clkreq          ( sbe_clkreq_int                         ),
  .sbe_sbi_idle            ( sbe_idle                               ),
  .sbe_sbi_clk_valid       ( sbe_sbi_clk_valid                      ),
  .mpccup                  ( mpccup                                 ),
  .mnpcup                  ( mnpcup                                 ),
  .mpcput                  ( mpcput                                 ),
  .mnpput                  ( mnpput                                 ),
  .meom                    ( meom                                   ),
  .mpayload                ( mpayload                               ),
  .mparity                 ( mparity                                ),
  .tpccup                  ( tpccup                                 ),
  .tnpcup                  ( tnpcup                                 ),
  .tpcput                  ( tpcput                                 ),
  .tnpput                  ( tnpput                                 ),
  .teom                    ( teom                                   ),
  .tpayload                ( tpayload                               ),
  .tparity                 ( tparity                                ),
  .do_serr_hier_dstid_strap( do_serr_hier_dstid_strap               ),
  .do_serr_hier_srcid_strap( do_serr_hier_srcid_strap               ),
  .do_serr_srcid_strap     ( do_serr_srcid_strap                    ),
  .do_serr_dstid_strap     ( do_serr_dstid_strap                    ),
  .do_serr_tag_strap       ( do_serr_tag_strap                      ),
  .global_ep_strap         ( global_ep_strap                        ),
  .do_serr_sairs_valid     ( do_serr_sairs_valid                    ),
  .do_serr_sai             ( do_serr_sai                            ),
  .do_serr_rs              ( do_serr_rs                             ),
  .sbe_sbi_parity_err_out  ( sbe_parity_err_out                     ),
  .ext_parity_err_detected ( all_ext_parity_err_det                 ),
  .fdfx_sbparity_def    ( fdfx_sbparity_def                   ),
  .sbi_sbe_tmsg_pcfree     ( sbi_sbe_tmsg_pcfree                    ),
  .sbi_sbe_tmsg_npfree     ( sbi_sbe_tmsg_npfree                    ),
  .sbi_sbe_tmsg_npclaim    ( sbi_sbe_tmsg_npclaim                   ),
  .sbe_sbi_tmsg_pcput      ( tmsg_pcput                             ),
  .sbe_sbi_tmsg_npput      ( tmsg_npput                             ),
  .sbe_sbi_tmsg_pcmsgip    ( tmsg_pcmsgip                           ),
  .sbe_sbi_tmsg_npmsgip    ( tmsg_npmsgip                           ),
  .sbe_sbi_tmsg_pceom      ( tmsg_pceom                             ),
  .sbe_sbi_tmsg_npeom      ( tmsg_npeom                             ),
  .sbe_sbi_tmsg_pcpayload  ( tmsg_pcpayload                         ),
  .sbe_sbi_tmsg_nppayload  ( tmsg_nppayload                         ),
  .sbe_sbi_tmsg_pccmpl     ( tmsg_pccmpl                            ),
// PCR 12042104 - Unique Extended Headers SAIRS Inputs - START
  .ur_csairs_valid         ( ur_csairs_valid                        ), // lintra s-70036 s-0527 "Indicates when the sairs inputs are valid and should be used"
  .ur_csai                 ( ur_csai                                ), // lintra s-70036 s-0527 "SAI value for extended headers"
  .ur_crs                  ( ur_crs                                 ), // lintra s-70036 s-0527 "RS value for extended headers"
  .ur_rx_sairs_valid       ( ur_rx_sairs_valid                      ), // lintra s-70036 s-0527 "Indicates when the sairs inputs are valid and should be used"
  .ur_rx_sai               ( ur_rx_sai                              ), // lintra s-70036 s-0527 "SAI value for extended headers"
  .ur_rx_rs                ( ur_rx_rs                               ), // lintra s-70036 s-0527 "RS value for extended headers"
// PCR 12042104 - Unique Extended Headers SAIRS Inputs - FINISH
// SBC-PCN-007 - Insert completion counter outputs - START
  .sbe_sbi_comp_exp        ( sbe_comp_exp                           ),
// SBC-PCN-007 - Insert completion counter outputs - FINISH
  .sbi_sbe_mmsg_pcirdy     ( sbi_sbe_mmsg_pcirdy                    ),
  .sbi_sbe_mmsg_npirdy     ( sbi_sbe_mmsg_npirdy                    ),
  .sbi_sbe_mmsg_pceom      ( sbi_sbe_mmsg_pceom                     ),
  .sbi_sbe_mmsg_npeom      ( sbi_sbe_mmsg_npeom                     ),
  .sbi_sbe_mmsg_pcpayload  ( sbi_sbe_mmsg_pcpayload                 ),
  .sbi_sbe_mmsg_nppayload  ( sbi_sbe_mmsg_nppayload                 ),
  .sbi_sbe_mmsg_pcparity   ( sbi_sbe_mmsg_pcparity                  ),
  .sbi_sbe_mmsg_npparity   ( sbi_sbe_mmsg_npparity                  ),
  .sbe_sbi_mmsg_pctrdy     ( mmsg_pctrdy                            ),
  .sbe_sbi_mmsg_nptrdy     ( mmsg_nptrdy                            ),
  .sbe_sbi_mmsg_pcmsgip    ( mmsg_pcmsgip                           ),
  .sbe_sbi_mmsg_npmsgip    ( mmsg_npmsgip                           ),
  .sbe_sbi_mmsg_pcsel      ( sbe_sbi_mmsg_pcsel                     ),
  .sbe_sbi_mmsg_npsel      ( sbe_sbi_mmsg_npsel                     ),
  .sbe_sbi_tmsg_pcvalid    ( tmsg_pcvalid                           ),
  .sbe_sbi_tmsg_npvalid    ( tmsg_npvalid                           ),
  .sbe_sbi_tmsg_pcparity   ( tmsg_pcparity                          ),
  .sbe_sbi_tmsg_npparity   ( tmsg_npparity                          ),
  .cgctrl_idlecnt          ( cgctrl_idlecnt                         ),
  .cgctrl_clkgaten         ( cgctrl_clkgaten                        ),
  .cgctrl_clkgatedef       ( cgctrl_clkgatedef                      ),

  .visa_all_disable        ( 1'b0                                   ),
  .visa_customer_disable   ( 1'b0                                   ),
  .avisa_data_out          (                                        ), // lintra s-0214 "Visa ULM used in sbendpoint"
  .avisa_clk_out           (                                        ), // lintra s-0214 "Visa ULM used in sbendpoint"
  .visa_ser_cfg_in         ( 3'b0                                   ),
  .sbe_visa_bypass_cr_out  (                  ), // lintra s-0214 s-2223 s-0396
  .sbe_visa_serial_rd_out  (                  ), // lintra s-0214 s-2223 s-0396

  .visa_port_tier1_sb      ( visa_port_tier1_sb                     ),       // VISA debug candidates
  .visa_fifo_tier1_sb      ( visa_fifo_tier1_sb                     ),// high priority
  .visa_fifo_tier1_ag      ( visa_fifo_tier1_ag                     ),
  .visa_agent_tier1_ag     ( visa_agent_tier1_ag                    ),

  .visa_port_tier2_sb      ( visa_port_tier2_sb                     ),       // VISA debug candidates
  .visa_fifo_tier2_sb      ( visa_fifo_tier2_sb                     ),     // low priority
  .visa_fifo_tier2_ag      ( visa_fifo_tier2_ag                     ),
  .visa_agent_tier2_ag     ( visa_agent_tier2_ag                    ),

  .jta_clkgate_ovrd        ( jta_clkgate_ovrd                       ),
  .jta_force_clkreq        ( jta_force_clkreq                       ),
  .jta_force_idle          ( jta_force_idle                         ),
  .jta_force_notidle       ( jta_force_notidle                      ),
  .jta_force_creditreq     ( jta_force_creditreq                    ),
  .fscan_latchopen         ( fscan_latchopen                        ),
  .fscan_latchclosed_b     ( fscan_latchclosed_b                    ),
  .fscan_clkungate         ( fscan_clkungate                        ),
  .fscan_rstbypen          ( fscan_rstbypen                         ), // For some reasono the scan mux was cutoff from sbebase
  .fscan_byprst_b          ( fscan_byprst_b                         ), // For some reasono the scan mux was cutoff from sbebase
  .fscan_mode              ( fscan_mode                             ),
  .fscan_shiften           ( fscan_shiften                          ),
  .fscan_clkungate_syn     ( fscan_clkungate_syn                    ),
  .tx_ext_headers          ( tx_ext_headers                         )
);


//------------------------------------------------------------------------------
//
// sbetrgtreg: Target Register Access Interface Block
//
//------------------------------------------------------------------------------
logic [15:0] dbg_trgt;

generate
    if (RATAENABLE==1) begin: gen_rata
	    logic [INTERNALPLDBIT:0]        tmsg_hdr_pcpayload;
		logic							tmsg_hdr_pcput;
		logic							tmsg_hdr_pcmsgip;
		logic							tmsg_hdr_pceom;
		logic							tmsg_hdr_pcparity;
		logic [INTERNALPLDBIT:0]		tmsg_hdr_nppayload;
		logic							tmsg_hdr_npput;
		logic							tmsg_hdr_npmsgip;
		logic							tmsg_hdr_npeom;
		logic							tmsg_hdr_npparity;
		logic [INTERNALPLDBIT:0]		tmsg_lcl_pcpayload;
		logic							tmsg_lcl_pcput;
		logic							tmsg_lcl_pcmsgip;
		logic							tmsg_lcl_pceom;
		logic							tmsg_lcl_pcparity;
		logic [INTERNALPLDBIT:0]		tmsg_lcl_nppayload;
		logic							tmsg_lcl_npput;
		logic							tmsg_lcl_npmsgip;
		logic							tmsg_lcl_npeom;
		logic							tmsg_lcl_npparity;
	    logic                           mmsg_pctrdy_trgtreg;
	    logic                           mmsg_lcl_pcirdy_trgtreg;
	    logic                           mmsg_lcl_pceom_trgtreg;
	    logic [INTERNALPLDBIT:0]        mmsg_lcl_pcpayload_trgtreg;
	    logic                           mmsg_lcl_pcparity_trgtreg;
	    logic [7:0]                     np_hier_destid_trgtreg;
	    logic [7:0]                     np_hier_srcid_trgtreg;
        
        if (TREGOVERRIDE ==1) begin: gen_treg
            hqm_sbetrgtreg #( // lintra s-80018
            .INTERNALPLDBIT        ( INTERNALPLDBIT        ),
            .SB_PARITY_REQUIRED    ( SB_PARITY_REQUIRED    ),
            .MAXTRGTADDR           ( MAXTRGTADDR           ),
            .MAXTRGTDATA           ( MAXTRGTDATA           ),
            .RX_EXT_HEADER_SUPPORT ( RX_EXT_HEADER_SUPPORT ),
            .NUM_RX_EXT_HEADERS    ( NUM_RX_EXT_HEADERS    ),
            .RX_EXT_HEADER_IDS     ( RX_EXT_HEADER_IDS     ),
            .NUM_TX_EXT_HEADERS    ( NUM_TX_EXT_HEADERS    ),
            .TX_EXT_HEADER_SUPPORT ( TX_EXT_HEADER_SUPPORT ),
// PCR 12042104 - Unique Extended Headers SAIRS Parameter - START
            .UNIQUE_EXT_HEADERS    ( UNIQUE_EXT_HEADERS    ),
            .RSWIDTH               ( RSWIDTH               ),
            .SAIWIDTH              ( SAIWIDTH              ),
// PCR 12042104 - Unique Extended Headers SAIRS Parameter - FINISH
// Hier Bridge PCR
            .GLOBAL_EP_IS_STRAP   ( GLOBAL_EP_IS_STRAP      ),
            .GLOBAL_EP            ( GLOBAL_EP               )
            ) sbetrgtreg (
            .side_clk       ( agent_side_clk                                   ),
		    .side_rst_b     ( agent_side_rst_b                                 ),
		    .idle_trgtreg   ( idle_trgtreg                                     ),
		    .sbe_sbi_idle   ( sbe_idle                                         ),
		    .cfg_parityckdef( fdfx_sbparity_def                                ),
		    .ext_parity_err_detected  ( all_ext_parity_err_det                 ),
		    .treg_tmsg_parity_err_det ( treg_tmsg_parity_err_det               ),
		    .global_ep_strap( global_ep_strap                                  ),
		    .tmsg_pcput     ( tmsg_lcl_pcput                                   ),
		    .tmsg_npput     ( tmsg_lcl_npput                                   ),
		    .tmsg_pcmsgip   ( tmsg_lcl_pcmsgip                                 ),
		    .tmsg_npmsgip   ( tmsg_lcl_npmsgip                                 ),
		    .tmsg_pceom     ( tmsg_lcl_pceom                                   ),
		    .tmsg_npeom     ( tmsg_lcl_npeom                                   ),
		    .tmsg_pcpayload ( tmsg_lcl_pcpayload                               ),
		    .tmsg_nppayload ( tmsg_lcl_nppayload                               ),
		    .tmsg_pcparity  ( tmsg_lcl_pcparity                                ),
		    .tmsg_npparity  ( tmsg_lcl_npparity                                ),
		    .tmsg_pcfree    ( tmsg_pcfree_trgtreg                              ),
		    .tmsg_npfree    ( tmsg_npfree_trgtreg                              ),
		    .tmsg_npclaim   ( tmsg_npclaim_trgtreg                             ),
		    .mmsg_pcsel     ( sbe_sbi_mmsg_pcsel[  BASEMAXPCMSTRMIN1]          ),
		    .mmsg_pctrdy    ( mmsg_pctrdy_trgtreg                              ),
			.mmsg_pcirdy    ( mmsg_lcl_pcirdy_trgtreg                          ),
			.mmsg_pceom     ( mmsg_lcl_pceom_trgtreg                           ),
			.mmsg_pcpayload ( mmsg_lcl_pcpayload_trgtreg                       ),
			.mmsg_pcparity  ( mmsg_lcl_pcparity_trgtreg                        ),
			.treg_trdy      ( treg_trdy                                        ),
			.treg_cerr      ( treg_cerr                                        ),
			.treg_rdata     ( treg_rdata                                       ),
			.treg_irdy      ( treg_irdy                                        ),
			.treg_np        ( treg_np                                          ),
			.treg_dest      ( treg_dest                                        ),
			.treg_source    ( treg_source                                      ),
			.treg_opcode    ( treg_opcode                                      ),
			.treg_addrlen   ( treg_addrlen                                     ),
			.treg_bar       ( treg_bar                                         ),
			.treg_tag       ( treg_tag                                         ),
			.treg_be        ( treg_be                                          ),
			.treg_fid       ( treg_fid                                         ),
			.treg_addr      ( treg_addr                                        ),
			.treg_wdata     ( treg_wdata                                       ),
			.treg_eh        ( treg_eh                                          ),
			.treg_ext_header( treg_ext_header                                  ),
			.treg_eh_discard( treg_eh_discard                                  ),
			// PCR 12042104 - Unique Extended Headers SAIRS Inputs - START
			.treg_csairs_valid  ( treg_csairs_valid                              ),
			.treg_csai          ( treg_csai                                      ),
			.treg_crs           ( treg_crs                                       ),
			.treg_rx_sairs_valid( treg_rx_sairs_valid                            ),
			.treg_rx_sai        ( treg_rx_sai                                    ),
			.treg_rx_rs         ( treg_rx_rs                                     ),
			// PCR 12042104 - Unique Extended Headers SAIRS Inputs - FINISH
			.tx_ext_headers ( tx_ext_headers                                   ),
			// Hier Header PCR
			.tmsg_hdr_pcpayload  ( tmsg_hdr_pcpayload                            ),
			.tmsg_hdr_pcput      ( tmsg_hdr_pcput                                ),
			.tmsg_hdr_pcmsgip    ( tmsg_hdr_pcmsgip                              ),
			.tmsg_hdr_pceom      ( tmsg_hdr_pceom                                ),
			.tmsg_hdr_pcparity   ( tmsg_hdr_pcparity                             ),
			.tmsg_hdr_nppayload  ( tmsg_hdr_nppayload                            ),
			.tmsg_hdr_npput      ( tmsg_hdr_npput                                ),
			.tmsg_hdr_npmsgip    ( tmsg_hdr_npmsgip                              ),
			.tmsg_hdr_npeom      ( tmsg_hdr_npeom                                ),
			.tmsg_hdr_npparity   ( tmsg_hdr_npparity                             ),
			.treg_hier_destid    ( treg_hier_destid                              ),
			.treg_hier_srcid     ( treg_hier_srcid                               ),
			.np_hier_destid      ( np_hier_destid_trgtreg                        ),
			.np_hier_srcid       ( np_hier_srcid_trgtreg                         ),
			.dbgbus         ( dbg_trgt                                         )
            );

        end // treg
        else if (BULKRDWR == 1) begin : gen_bulk_widget
            hqm_sbebulkrdwrwrapper #( // lintra s-80018
            .INTERNALPLDBIT        ( INTERNALPLDBIT        ),
            .SB_PARITY_REQUIRED    ( SB_PARITY_REQUIRED    ),
            .MAXTRGTADDR           ( MAXTRGTADDR           ),
            .MAXTRGTDATA           ( MAXTRGTDATA           ),
            .RX_EXT_HEADER_SUPPORT ( RX_EXT_HEADER_SUPPORT ),
            .NUM_RX_EXT_HEADERS    ( NUM_RX_EXT_HEADERS    ),
            .RX_EXT_HEADER_IDS     ( RX_EXT_HEADER_IDS     ),
            .NUM_TX_EXT_HEADERS    ( NUM_TX_EXT_HEADERS    ),
            .TX_EXT_HEADER_SUPPORT ( TX_EXT_HEADER_SUPPORT ),
// PCR 12042104 - Unique Extended Headers SAIRS Parameter - START
            .UNIQUE_EXT_HEADERS    ( UNIQUE_EXT_HEADERS    ),
            .RSWIDTH               ( RSWIDTH               ),
            .SAIWIDTH              ( SAIWIDTH              ),
// PCR 12042104 - Unique Extended Headers SAIRS Parameter - FINISH
// Hier Bridge PCR
            .GLOBAL_EP_IS_STRAP   (GLOBAL_EP_IS_STRAP       ),  
            .GLOBAL_EP            ( GLOBAL_EP               ),
            .BULK_PERF            ( BULK_PERF               )
            ) sbebulkrdwrwrapper (
		    .side_clk       ( agent_side_clk                                   ),
			.side_rst_b     ( agent_side_rst_b                                 ),
			.idle_trgtreg   ( idle_trgtreg                                     ),
			.cfg_parityckdef( fdfx_sbparity_def                                ),
			.ext_parity_err_detected    ( all_ext_parity_err_det               ),
			.treg_tmsg_parity_err_det   ( treg_tmsg_parity_err_det             ),
  // new for bulk to terminate bulk completions and mask bulk irdy's            
            .parity_err_from_base       ( sbe_parity_err_out                   ),
			.global_ep_strap( global_ep_strap                                  ),
			.tmsg_pcput     ( tmsg_lcl_pcput                                   ),
			.tmsg_npput     ( tmsg_lcl_npput                                   ),
			.tmsg_pcmsgip   ( tmsg_lcl_pcmsgip                                 ),
			.tmsg_npmsgip   ( tmsg_lcl_npmsgip                                 ),
			.tmsg_pceom     ( tmsg_lcl_pceom                                   ),
			.tmsg_npeom     ( tmsg_lcl_npeom                                   ),
			.tmsg_pcpayload ( tmsg_lcl_pcpayload                               ),
			.tmsg_nppayload ( tmsg_lcl_nppayload                               ),
			.tmsg_pcparity  ( tmsg_lcl_pcparity                                ),
			.tmsg_npparity  ( tmsg_lcl_npparity                                ),
			.tmsg_pcfree    ( tmsg_pcfree_trgtreg                              ),
			.tmsg_npfree    ( tmsg_npfree_trgtreg                              ),
			.tmsg_npclaim   ( tmsg_npclaim_trgtreg                             ),
			.mmsg_pcsel     ( sbe_sbi_mmsg_pcsel[  BASEMAXPCMSTRMIN1]          ),
			.mmsg_pctrdy    ( mmsg_pctrdy_trgtreg                              ),
			.mmsg_pcirdy    ( mmsg_lcl_pcirdy_trgtreg                          ),
			.mmsg_pceom     ( mmsg_lcl_pceom_trgtreg                           ),
			.mmsg_pcpayload ( mmsg_lcl_pcpayload_trgtreg                       ),
			.mmsg_pcparity  ( mmsg_lcl_pcparity_trgtreg                        ),
			.treg_trdy      ( treg_trdy                                        ),
			.treg_cerr      ( treg_cerr                                        ),
			.treg_rdata     ( treg_rdata                                       ),
			.treg_irdy      ( treg_irdy                                        ),
			.treg_np        ( treg_np                                          ),
			.treg_dest      ( treg_dest                                        ),
			.treg_source    ( treg_source                                      ),
			.treg_opcode    ( treg_opcode                                      ),
			.treg_addrlen   ( treg_addrlen                                     ),
			.treg_bar       ( treg_bar                                         ),
			.treg_tag       ( treg_tag                                         ),
			.treg_be        ( treg_be                                          ),
			.treg_fid       ( treg_fid                                         ),
			.treg_addr      ( treg_addr                                        ),
			.treg_wdata     ( treg_wdata                                       ),
			.treg_eh        ( treg_eh                                          ),
			.treg_ext_header( treg_ext_header                                  ),
			.treg_eh_discard( treg_eh_discard                                  ),
			// PCR 12042104 - Unique Extended Headers SAIRS Inputs - START
			.treg_csairs_valid  ( treg_csairs_valid                              ),
			.treg_csai          ( treg_csai                                      ),
			.treg_crs           ( treg_crs                                       ),
			.treg_rx_sairs_valid( treg_rx_sairs_valid                            ),
			.treg_rx_sai        ( treg_rx_sai                                    ),
			.treg_rx_rs         ( treg_rx_rs                                     ),
			// PCR 12042104 - Unique Extended Headers SAIRS Inputs - FINISH
			.tx_ext_headers      ( tx_ext_headers                                ),
			// Hier Header PCR
			.tmsg_hdr_pcpayload  ( tmsg_hdr_pcpayload                            ),
			.tmsg_hdr_pcput      ( tmsg_hdr_pcput                                ),
			.tmsg_hdr_pcmsgip    ( tmsg_hdr_pcmsgip                              ),
			.tmsg_hdr_pceom      ( tmsg_hdr_pceom                                ),
			.tmsg_hdr_pcparity   ( tmsg_hdr_pcparity                             ),
			.tmsg_hdr_nppayload  ( tmsg_hdr_nppayload                            ),
			.tmsg_hdr_npput      ( tmsg_hdr_npput                                ),
			.tmsg_hdr_npmsgip    ( tmsg_hdr_npmsgip                              ),
			.tmsg_hdr_npeom      ( tmsg_hdr_npeom                                ),
			.tmsg_hdr_npparity   ( tmsg_hdr_npparity                             ),
			.treg_hier_destid    ( treg_hier_destid                              ),
			.treg_hier_srcid     ( treg_hier_srcid                               ),
			.np_hier_destid      ( np_hier_destid_trgtreg                        ),
			.np_hier_srcid       ( np_hier_srcid_trgtreg                         ),
			.dbgbus              ( dbg_trgt                                      )
            );
        end // bulkrdwr

        if (GLOBAL_EP_IS_STRAP==1) begin: gen_treg_hdr_strap
		    logic [INTERNALPLDBIT:0]        tmsg_hdr_pcpayload_int;
			logic                           tmsg_hdr_pcput_int;
			logic                           tmsg_hdr_pcmsgip_int;
			logic                           tmsg_hdr_pceom_int;
			logic                           tmsg_hdr_pcparity_int;
			logic [INTERNALPLDBIT:0]        tmsg_hdr_nppayload_int;
			logic                           tmsg_hdr_npput_int;
			logic                           tmsg_hdr_npmsgip_int;
			logic                           tmsg_hdr_npeom_int;
			logic                           tmsg_hdr_npparity_int; 
			logic [INTERNALPLDBIT:0]        tmsg_lcl_pcpayload_int;
			logic                           tmsg_lcl_pcput_int;
			logic                           tmsg_lcl_pcmsgip_int; 
			logic                           tmsg_lcl_pceom_int;
			logic                           tmsg_lcl_pcparity_int;
			logic [INTERNALPLDBIT:0]        tmsg_lcl_nppayload_int;    
			logic                           tmsg_lcl_npput_int;        
			logic                           tmsg_lcl_npmsgip_int;     
			logic                           tmsg_lcl_npeom_int;       
			logic                           tmsg_lcl_npparity_int; 
			logic                           mmsg_pcirdy_trgtreg_int;
			logic                           mmsg_pctrdy_trgtreg_int;
			logic                           mmsg_pceom_trgtreg_int;
			logic [INTERNALPLDBIT:0]        mmsg_pcpayload_trgtreg_int;
			logic                           mmsg_pcparity_trgtreg_int; 
////////////////////////////////////////////////////////
// Hier Bridge PCR to add/remove hierarchical headers //
////////////////////////////////////////////////////////
	        
            hqm_sbetregsplitter # (
	            .INTERNALPLDBIT (   INTERNALPLDBIT  )
	        ) sbetregsplitter (
			    .side_clk       ( agent_side_clk                ),
			    .side_rst_b     ( agent_side_rst_b              ),
			    .tmsg_pcput     ( tmsg_pcput                    ),
			    .tmsg_npput     ( tmsg_npput                    ),
			    .tmsg_pcmsgip   ( tmsg_pcmsgip                  ),
			    .tmsg_npmsgip   ( tmsg_npmsgip                  ),
			    .tmsg_pceom     ( tmsg_pceom                    ),
			    .tmsg_npeom     ( tmsg_npeom                    ),
			    .tmsg_pcpayload ( tmsg_pcpayload                ),
			    .tmsg_nppayload ( tmsg_nppayload                ),
			    .tmsg_pcparity  ( tmsg_pcparity                 ),
			    .tmsg_npparity  ( tmsg_npparity                 ),
			// HIER HEADER specific output            
			    .tmsg_hdr_pcpayload ( tmsg_hdr_pcpayload_int    ),
			    .tmsg_hdr_pcput     ( tmsg_hdr_pcput_int        ),
			    .tmsg_hdr_pcmsgip   ( tmsg_hdr_pcmsgip_int      ),
			    .tmsg_hdr_pceom     ( tmsg_hdr_pceom_int        ),
			    .tmsg_hdr_pcparity  ( tmsg_hdr_pcparity_int     ),
			    .tmsg_hdr_nppayload ( tmsg_hdr_nppayload_int    ),
			    .tmsg_hdr_npput     ( tmsg_hdr_npput_int        ),
		        .tmsg_hdr_npmsgip   ( tmsg_hdr_npmsgip_int      ),
		        .tmsg_hdr_npeom     ( tmsg_hdr_npeom_int        ),
		        .tmsg_hdr_npparity  ( tmsg_hdr_npparity_int     ),
		// Non header "Local LCL" outputs
		        .tmsg_lcl_pcpayload ( tmsg_lcl_pcpayload_int    ),
		        .tmsg_lcl_pcput     ( tmsg_lcl_pcput_int        ),
		        .tmsg_lcl_pcmsgip   ( tmsg_lcl_pcmsgip_int      ),
		        .tmsg_lcl_pceom     ( tmsg_lcl_pceom_int        ),
		        .tmsg_lcl_pcparity  ( tmsg_lcl_pcparity_int     ),
		        .tmsg_lcl_nppayload ( tmsg_lcl_nppayload_int    ),
		        .tmsg_lcl_npput     ( tmsg_lcl_npput_int        ),
		        .tmsg_lcl_npmsgip   ( tmsg_lcl_npmsgip_int      ),
		        .tmsg_lcl_npeom     ( tmsg_lcl_npeom_int        ),
		        .tmsg_lcl_npparity  ( tmsg_lcl_npparity_int     )
            );

	        hqm_sbehierinsert # (
	            .INTERNALPLDBIT (   INTERNALPLDBIT  )
	        ) sbehierinsert_treg  (
			    .side_clk       ( agent_side_clk                ),
			    .side_rst_b     ( agent_side_rst_b              ),
			// TREG completions input
			    .in_pcsel       ( sbe_sbi_mmsg_pcsel[  BASEMAXPCMSTRMIN1]                ),
			    .in_pctrdy      ( mmsg_pctrdy                   ),
			    .in_pcirdy      ( mmsg_lcl_pcirdy_trgtreg       ),
			    .in_pceom       ( mmsg_lcl_pceom_trgtreg        ),
			    .in_pcpayload   ( mmsg_lcl_pcpayload_trgtreg    ),
			    .in_pcparity    ( mmsg_lcl_pcparity_trgtreg     ),
			// HIER HDR inputs : Note the swap in connections of src/dest
			    .in_hier_dest   ( np_hier_srcid_trgtreg         ),
			    .in_hier_src    ( np_hier_destid_trgtreg        ),            
			// TREG completion output  (after hdr addition)
			    .out_pcirdy     ( mmsg_pcirdy_trgtreg_int       ),
			    .out_pctrdy     ( mmsg_pctrdy_trgtreg_int       ),
			    .out_pceom      ( mmsg_pceom_trgtreg_int        ),
			    .out_pcpayload  ( mmsg_pcpayload_trgtreg_int    ),
			    .out_pcparity   ( mmsg_pcparity_trgtreg_int     )
	        );
	        
			always_comb begin
			    tmsg_hdr_pcpayload = global_ep_strap ? tmsg_hdr_pcpayload_int   : '0;
			    tmsg_hdr_pcput     = global_ep_strap ? tmsg_hdr_pcput_int       : '0;
			    tmsg_hdr_pcmsgip   = global_ep_strap ? tmsg_hdr_pcmsgip_int     : '0;
			    tmsg_hdr_pceom     = global_ep_strap ? tmsg_hdr_pceom_int	    : '0;
			    tmsg_hdr_pcparity  = global_ep_strap ? tmsg_hdr_pcparity_int	: '0;
			    tmsg_hdr_nppayload = global_ep_strap ? tmsg_hdr_nppayload_int	: '0;
			    tmsg_hdr_npput     = global_ep_strap ? tmsg_hdr_npput_int	    : '0;
			    tmsg_hdr_npmsgip   = global_ep_strap ? tmsg_hdr_npmsgip_int	    : '0;
			    tmsg_hdr_npeom     = global_ep_strap ? tmsg_hdr_npeom_int	    : '0;
			    tmsg_hdr_npparity  = global_ep_strap ? tmsg_hdr_npparity_int	: '0;
			    // Non header "Local LCL" outputs
			    tmsg_lcl_pcpayload = global_ep_strap ? tmsg_lcl_pcpayload_int  : tmsg_pcpayload;
			    tmsg_lcl_pcput     = global_ep_strap ? tmsg_lcl_pcput_int      : tmsg_pcput;
			    tmsg_lcl_pcmsgip   = global_ep_strap ? tmsg_lcl_pcmsgip_int    : tmsg_pcmsgip;
			    tmsg_lcl_pceom     = global_ep_strap ? tmsg_lcl_pceom_int      : tmsg_pceom;
			    tmsg_lcl_pcparity  = global_ep_strap ? tmsg_lcl_pcparity_int   : tmsg_pcparity;
			    tmsg_lcl_nppayload = global_ep_strap ? tmsg_lcl_nppayload_int  : tmsg_nppayload;
		        tmsg_lcl_npput     = global_ep_strap ? tmsg_lcl_npput_int      : tmsg_npput;
		        tmsg_lcl_npmsgip   = global_ep_strap ? tmsg_lcl_npmsgip_int    : tmsg_npmsgip;
		        tmsg_lcl_npeom     = global_ep_strap ? tmsg_lcl_npeom_int      : tmsg_npeom;
		        tmsg_lcl_npparity  = global_ep_strap ? tmsg_lcl_npparity_int   : tmsg_npparity;
		        mmsg_pcirdy_trgtreg     = global_ep_strap ? mmsg_pcirdy_trgtreg_int    : mmsg_lcl_pcirdy_trgtreg;
		        mmsg_pceom_trgtreg      = global_ep_strap ? mmsg_pceom_trgtreg_int     : mmsg_lcl_pceom_trgtreg;
		        mmsg_pcpayload_trgtreg  = global_ep_strap ? mmsg_pcpayload_trgtreg_int : mmsg_lcl_pcpayload_trgtreg;
		        mmsg_pcparity_trgtreg   = global_ep_strap ? mmsg_pcparity_trgtreg_int  : mmsg_lcl_pcparity_trgtreg;
		        mmsg_pctrdy_trgtreg     = global_ep_strap ? mmsg_pctrdy_trgtreg_int    : mmsg_pctrdy;
            end
        end //end strap
        else begin : gen_treg_hdr_nostrap//nostrap
            if (GLOBAL_EP==1) begin : gen_hier_param
                hqm_sbetregsplitter # (
	                .INTERNALPLDBIT (   INTERNALPLDBIT  )
	            ) sbetregsplitter (
	                .side_clk       ( agent_side_clk                ),
		            .side_rst_b     ( agent_side_rst_b              ),
		            .tmsg_pcput     ( tmsg_pcput                    ),
		            .tmsg_npput     ( tmsg_npput                    ),
				    .tmsg_pcmsgip   ( tmsg_pcmsgip                  ),
				    .tmsg_npmsgip   ( tmsg_npmsgip                  ),
				    .tmsg_pceom     ( tmsg_pceom                    ),
				    .tmsg_npeom     ( tmsg_npeom                    ),
				    .tmsg_pcpayload ( tmsg_pcpayload                ),
				    .tmsg_nppayload ( tmsg_nppayload                ),
				    .tmsg_pcparity  ( tmsg_pcparity                 ),
				    .tmsg_npparity  ( tmsg_npparity                 ),
				    // HIER HEADER specific output            
				    .tmsg_hdr_pcpayload ( tmsg_hdr_pcpayload        ),
				    .tmsg_hdr_pcput     ( tmsg_hdr_pcput            ),
				    .tmsg_hdr_pcmsgip   ( tmsg_hdr_pcmsgip          ),
				    .tmsg_hdr_pceom     ( tmsg_hdr_pceom            ),
				    .tmsg_hdr_pcparity  ( tmsg_hdr_pcparity         ),
				    .tmsg_hdr_nppayload ( tmsg_hdr_nppayload        ),
				    .tmsg_hdr_npput     ( tmsg_hdr_npput            ),
				    .tmsg_hdr_npmsgip   ( tmsg_hdr_npmsgip          ),
				    .tmsg_hdr_npeom     ( tmsg_hdr_npeom            ),
				    .tmsg_hdr_npparity  ( tmsg_hdr_npparity         ),
				    // Non header "Local LCL" outputs
				    .tmsg_lcl_pcpayload ( tmsg_lcl_pcpayload        ),
				    .tmsg_lcl_pcput     ( tmsg_lcl_pcput            ),
				    .tmsg_lcl_pcmsgip   ( tmsg_lcl_pcmsgip          ),
				    .tmsg_lcl_pceom     ( tmsg_lcl_pceom            ),
				    .tmsg_lcl_pcparity  ( tmsg_lcl_pcparity         ),
				    .tmsg_lcl_nppayload ( tmsg_lcl_nppayload        ),
				    .tmsg_lcl_npput     ( tmsg_lcl_npput            ),
				    .tmsg_lcl_npmsgip   ( tmsg_lcl_npmsgip          ),
				    .tmsg_lcl_npeom     ( tmsg_lcl_npeom            ),
				    .tmsg_lcl_npparity  ( tmsg_lcl_npparity         )
	            );

                hqm_sbehierinsert # (
                    .INTERNALPLDBIT (   INTERNALPLDBIT  )
                ) sbehierinsert_treg  (
		            .side_clk       ( agent_side_clk                ),
		            .side_rst_b     ( agent_side_rst_b              ),
		   // TREG completions input
		            .in_pcsel       ( sbe_sbi_mmsg_pcsel[  BASEMAXPCMSTRMIN1]                ),
			        .in_pctrdy      ( mmsg_pctrdy                   ),
			        .in_pcirdy      ( mmsg_lcl_pcirdy_trgtreg       ),
			        .in_pceom       ( mmsg_lcl_pceom_trgtreg        ),
			        .in_pcpayload   ( mmsg_lcl_pcpayload_trgtreg    ),
			        .in_pcparity    ( mmsg_lcl_pcparity_trgtreg     ),
			   // HIER HDR inputs : Note the swap in connections of src/dest
			        .in_hier_dest   ( np_hier_srcid_trgtreg         ),
			        .in_hier_src    ( np_hier_destid_trgtreg        ),            
			   // TREG completion output  (after hdr addition)
			        .out_pcirdy     ( mmsg_pcirdy_trgtreg           ),
			        .out_pctrdy     ( mmsg_pctrdy_trgtreg           ),
			        .out_pceom      ( mmsg_pceom_trgtreg            ),
			        .out_pcpayload  ( mmsg_pcpayload_trgtreg        ),
			        .out_pcparity   ( mmsg_pcparity_trgtreg         )
                );
            end // hier param
            else begin : gen_noglblhdr
                always_comb begin
                    tmsg_hdr_pcpayload  = '0;
		            tmsg_hdr_pcput      = '0;
		            tmsg_hdr_pcmsgip    = '0;
		            tmsg_hdr_pceom      = '0;
		            tmsg_hdr_pcparity   = '0;
		            tmsg_hdr_nppayload  = '0;
		            tmsg_hdr_npput      = '0;
		            tmsg_hdr_npmsgip    = '0;
		            tmsg_hdr_npeom      = '0;
		            tmsg_hdr_npparity   = '0;
		   		    tmsg_lcl_pcpayload      = tmsg_pcpayload;
		   		    tmsg_lcl_pcput          = tmsg_pcput;
		   		    tmsg_lcl_pcmsgip        = tmsg_pcmsgip;
		   		    tmsg_lcl_pceom          = tmsg_pceom;
		   		    tmsg_lcl_pcparity       = tmsg_pcparity;
		   		    tmsg_lcl_nppayload      = tmsg_nppayload;
		    	    tmsg_lcl_npput          = tmsg_npput;
		    	    tmsg_lcl_npmsgip        = tmsg_npmsgip;
		    	    tmsg_lcl_npeom          = tmsg_npeom;
		    	    tmsg_lcl_npparity       = tmsg_npparity;
		            mmsg_pcirdy_trgtreg     = mmsg_lcl_pcirdy_trgtreg;
		            mmsg_pceom_trgtreg      = mmsg_lcl_pceom_trgtreg;
		            mmsg_pcpayload_trgtreg  = mmsg_lcl_pcpayload_trgtreg;
		            mmsg_pcparity_trgtreg   = mmsg_lcl_pcparity_trgtreg;
		            mmsg_pctrdy_trgtreg     = mmsg_pctrdy;
                end
            end //else noglblhdr
        end// gen_nostrap
    end else begin : gen_norata
        always_comb begin
            treg_irdy            = '0;
            treg_np              = '0;
            treg_addrlen         = '0;
            treg_dest            = '0;
            treg_source          = '0;
            treg_opcode          = '0;
            treg_bar             = '0;
            treg_tag             = '0;
            treg_be              = '0;
            treg_fid             = '0;
            treg_addr            = '0;
            treg_wdata           = '0;
            idle_trgtreg         = '1;
            dbg_trgt             = '0;
            treg_ext_header      = '0;
            treg_eh_discard      = '0;
            treg_eh              = '0;
            treg_rx_sairs_valid  = '0;
            treg_rx_sai          = '0;
            treg_rx_rs           = '0;
            tmsg_pcfree_trgtreg  = '1;
            tmsg_npfree_trgtreg  = '1;
            tmsg_npclaim_trgtreg = '0;
            mmsg_pceom_trgtreg     = '0;
            mmsg_pcirdy_trgtreg    = '0;
            mmsg_pcpayload_trgtreg = '0;
            mmsg_pcparity_trgtreg  = '0;
            treg_tmsg_parity_err_det  = '0;
          end 
    end // else for gen_ntreg
endgenerate

//------------------------------------------------------------------------------
//
// sbemstrreg: Master Register Access Interface Block
//
//------------------------------------------------------------------------------
logic [15:0] dbg_mstr;

generate
  if (MASTERREG==1) begin : gen_mreg

    hqm_sbemstrreg #( // lintra s-80018
                  .INTERNALPLDBIT        ( INTERNALPLDBIT        ),
                  .SB_PARITY_REQUIRED    ( SB_PARITY_REQUIRED    ),
                  .MAXMSTRADDR           ( MAXMSTRADDR           ),
                  .MAXMSTRDATA           ( MAXMSTRDATA           ),
                  .TX_EXT_HEADER_SUPPORT ( TX_EXT_HEADER_SUPPORT ),
                  .NUM_TX_EXT_HEADERS    ( NUM_TX_EXT_HEADERS    ),
// PCR 12042104 - Unique Extended Headers SAIRS Parameter - START
                  .UNIQUE_EXT_HEADERS    ( UNIQUE_EXT_HEADERS    ),
                  .RSWIDTH               ( RSWIDTH               ),
                  .SAIWIDTH              ( SAIWIDTH              ),
                  .GLOBAL_EP_IS_STRAP    ( GLOBAL_EP_IS_STRAP    ),
                  .GLOBAL_EP             ( GLOBAL_EP             )
// PCR 12042104 - Unique Extended Headers SAIRS Parameter - FINISH
    ) sbemstrreg(
      .side_clk       ( agent_side_clk                                   ),
      .side_rst_b     ( agent_side_rst_b                                 ),
      .idle_mstrreg   ( idle_mstrreg                                     ),
      .global_ep_strap( global_ep_strap                                  ),
      .mmsg_pctrdy    ( mmsg_pctrdy                                      ),
      .mmsg_nptrdy    ( mmsg_nptrdy                                      ),
      .mmsg_npmsgip   ( mmsg_npmsgip                                     ),
      .mmsg_pcsel     ( sbe_sbi_mmsg_pcsel[       BASEMAXPCMSTR]         ),
      .mmsg_npsel     ( sbe_sbi_mmsg_npsel[       BASEMAXNPMSTR]         ),
      .mmsg_pcirdy    ( mmsg_pcirdy_mstrreg                              ),
      .mmsg_npirdy    ( mmsg_npirdy_mstrreg                              ),
      .mmsg_pceom     ( mmsg_pceom_mstrreg                               ),
      .mmsg_npeom     ( mmsg_npeom_mstrreg                               ),
      .mmsg_pcparity  ( mmsg_pcparity_mstrreg                            ),
      .mmsg_npparity  ( mmsg_npparity_mstrreg                            ),
      .mmsg_pcpayload ( mmsg_pcpayload_mstrreg                           ),
      .mmsg_nppayload ( mmsg_nppayload_mstrreg                           ),
      .mreg_irdy      ( mreg_irdy                                        ),
      .mreg_npwrite   ( mreg_npwrite                                     ),
      .mreg_dest      ( mreg_dest                                        ),
      .mreg_source    ( mreg_source                                      ),
      .mreg_opcode    ( mreg_opcode                                      ),
      .mreg_addrlen   ( mreg_addrlen                                     ),
      .mreg_bar       ( mreg_bar                                         ),
      .mreg_tag       ( mreg_tag                                         ),
      .mreg_be        ( mreg_be                                          ),
      .mreg_fid       ( mreg_fid                                         ),
      .mreg_addr      ( mreg_addr                                        ),
      .mreg_wdata     ( mreg_wdata                                       ),
      .mreg_trdy      ( mreg_trdy                                        ),
      .mreg_pmsgip    ( mreg_pmsgip                                      ),
      .mreg_nmsgip    ( mreg_nmsgip                                      ),
// PCR 12042104 - Unique Extended Headers SAIRS Inputs - START
      .mreg_sairs_valid ( mreg_sairs_valid                               ),
      .mreg_sai         ( mreg_sai                                       ),
      .mreg_rs          ( mreg_rs                                        ),
// PCR 12042104 - Unique Extended Headers SAIRS Inputs - FINISH
	// PCR 12042104 - Unique Extended Headers SAIRS Inputs - FINISH
	  .mreg_hier_destid   ( mreg_hier_destid                              ),
	  .mreg_hier_srcid    ( mreg_hier_srcid                               ),
      .dbgbus         ( dbg_mstr                                         ),
      .tx_ext_headers ( tx_ext_headers                                   )
    );
   end
  else
    begin : gen_nmreg
      always_comb
        begin
          mreg_trdy    = '0;
          mreg_pmsgip  = '0;
          mreg_nmsgip  = '0;
          idle_mstrreg = '1;
          dbg_mstr     = '0;
        end
    end

endgenerate

  always_comb
    begin
      visa_reg_tier1_ag = { dbg_mstr[13:7], // mreg_np, _trdy, _npirdy, _pcirdy,
                                            // _npeom, _pceom, _nmsgip
                            dbg_mstr[3],    // _pmsgip
                            dbg_trgt[15:8]  // cirdy, ctregcerr, ctregxfr[1:0],
                                            // nignore | pignore, np, n/pstate.irdy
                                            // nstate.err | pstate.err

                          };
      visa_reg_tier2_ag = { dbg_mstr[15],   // qword
                            dbg_mstr[14],   // write
                            dbg_mstr[6:4],  // ncount
                            dbg_mstr[2:0],  // pcount
                            dbg_trgt[7:0]   // n/pstate.count
                          };

    end // always_comb
`ifndef INTEL_SVA_OFF
`ifndef IOSF_SB_ASSERT_OFF
 `ifdef INTEL_SIMONLY 
 //`ifdef INTEL_INST_ON // SynTranlateOff
//coverage off

generate
    if (USYNC_ENABLE==1) begin : gen_usync_delay_assertion

    side_usync_delay_violation:
    assert property (@ (posedge agent_side_rst_b)
                    (SIDE_USYNC_DELAY >= 1))
        else
            $display ("%0t: %m: ERROR: SIDE_USYNC_DELAY cannot be less than 1", $time);
    agent_usync_delay_violation:
    assert property (@ (posedge agent_side_rst_b) 
                    (AGENT_USYNC_DELAY >= 1))
        else
            $display ("%0t: %m: ERROR: AGENT_USYNC_DELAY cannot be less than 1", $time);
    end
endgenerate

//coverage on
 `endif // SynTranlateOn
`endif
`endif

endmodule

// lintra pop
