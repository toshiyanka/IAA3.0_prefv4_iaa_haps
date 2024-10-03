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
//  Module sbebase : The top-level for the sideband interface base endpoint
//                   This block contains no internal master/target agents, only
//                   the master/target interface to the AGENT block. It allows for
//                   a parameterized number of external master/target agents for
//                   both traffic classes (posted/completion and non-posted).
//                   This block does contain an unclaimed non-posted message
//                   target which generates completions for all target
//                   non-posted messages that are not claimed by the AGENT-block.
//------------------------------------------------------------------------------


// lintra push -60020, -60088, -80018, -80028, -80099, -68001, -68000, -60022, -60024b, -70607, -2050, 70036, -70036_simple

module hqm_sbebase #(
    parameter CLAIM_DELAY				  = 0, //adding repeater
  //  parameter NUM_REPEATER_FLOPS  = 5,		 
    parameter MAXPLDBIT                   = 7, // Maximum payload bit, should be 7, 15 or 31
    parameter INTERNALPLDBIT              = 31, // Maximum payload bit, should be 7, 15 or 31
    parameter NPQUEUEDEPTH                = 4, // Ingress queue depth, NP
    parameter PCQUEUEDEPTH                = 4, // Ingress queue depth, PC
    parameter CUP2PUT1CYC                 = 1, // Deprecated.  Value ignored
    parameter LATCHQUEUES                 = 0, // 0 = flop-based queues, 1 = latch-based queues
    parameter RELATIVE_PLACEMENT_EN       = 0, // RP methodology for efficient placement in RAMS     
    parameter MAXPCTRGT                   = 0, // Maximum posted/completion target agent number
    parameter MAXNPTRGT                   = 0, // Maximum non-posted        target agent number
    parameter MAXPCMSTR                   = 0, // Maximum posted/completion master agent number
    parameter MAXNPMSTR                   = 0, // Maximum non-posted        master agent number
    parameter ASYNCENDPT                  = 0, // Asynchronous endpoint=1, 0 otherwise
    parameter ASYNCIQDEPTH                = 2, // Asynchronous ingress FIFO queue depth
    parameter ASYNCEQDEPTH                = 2, // Asynchronous egress FIFO queue depth
    parameter VALONLYMODEL                = 0, // Deprecated.  Value ignored.
    parameter RX_EXT_HEADER_SUPPORT       = 0, // indicate whether agent supports receiving extended headers
    parameter DUMMY_CLKBUF                = 0,  // set to 1 to insert a dummy clock buffer (required for some CPU scan flows)
    parameter TX_EXT_HEADER_SUPPORT       = 0,
    parameter NUM_TX_EXT_HEADERS          = 0,
    parameter DISABLE_COMPLETION_FENCING  = 0,
    parameter RST_PRESYNC                 = 0,   // Indicates the async clock reset input was already syncd.
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
    parameter AGENT_USYNC_DELAY           = 1,
    parameter SIDE_USYNC_DELAY            = 1,
// PCR 12042104 - Unique Extended Headers SAIRS Parameter - START
   parameter UNIQUE_EXT_HEADERS           = 0,  // set to 1 to make the register agent modules use the new extended header
   parameter SAIWIDTH                     = 15, // SAI field width - MAX=15
   parameter RSWIDTH                      = 3,  // RS field width - MAX=3
// PCR 12042104 - Unique Extended Headers SAIRS Parameter - FINISH
// SBC-PCN-007 - Insert completion counter parameters - START
   parameter EXPECTED_COMPLETIONS_COUNTER = 0, // set to 1 if expected completion counters are needed
   parameter ISM_COMPLETION_FENCING       = 0, // set to 1 if the ISM should stay ACTIVE with exp completions
// SBC-PCN-007 - Insert completion counter parameters - FINISH
   parameter SIDE_CLKREQ_HYST_CNT         = 15, // sets the clock request modules hysteresis counter
   parameter CLKREQDEFAULT                = 0,  // clkreq reset/default value to be 0/1
   parameter SB_PARITY_REQUIRED           = 0,  // configures the Base Endpoint to support parity handling
   parameter DO_SERR_MASTER               = 0,  // controls generation of the DO_SERR message during parity error
   parameter GLOBAL_EP                    = 0,   // Hierarchical header insertion PCR 
   parameter GLOBAL_EP_IS_STRAP           = 0  
) (
      // Clock/Reset Signals
      side_clk,
      gated_side_clk,
      side_rst_b,

      agent_clk,         // AGENT clock, only used
      // for asynch endpoint
      agent_side_rst_b_sync,  // pre-synchronized agent reset
      // ONLY USED for sbendpoint

      usyncselect,
      side_usync,
      agent_usync,

      // Clock gating ISM Signals (endpoint)
      sbi_sbe_clkreq,
      sbi_sbe_idle,
      side_ism_fabric,
      side_ism_agent,
      side_clkreq,
      side_clkack,
      side_ism_lock_b, // SBC-PCN-002 - Sideband ISM lock for power gating flows

      // Clock gating ISM Signals (AGENT block)
      sbe_sbi_clkreq,
      sbe_sbi_idle,
      sbe_sbi_clk_valid,

      // Egress port interface to the IOSF Sideband Channel
      mpccup,
      mnpcup,
      mpcput,
      mnpput,
      meom,
      mpayload,       // lintra s-80095
      mparity,

      // Ingress port interface to the IOSF Sideband Channel
      tpccup,
      tnpcup,
      tpcput,
      tnpput,
      teom,
      tpayload,     // lintra s-80095
      tparity,
      
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
      sbe_sbi_parity_err_out,
      ext_parity_err_detected,
      fdfx_sbparity_def,
      
      // Target interface to the AGENT block
      sbi_sbe_tmsg_pcfree,    //
      sbi_sbe_tmsg_npfree,    //
      sbi_sbe_tmsg_npclaim,   //
      sbe_sbi_tmsg_pcput,     //
      sbe_sbi_tmsg_npput,     //
      sbe_sbi_tmsg_pcmsgip,   //
      sbe_sbi_tmsg_npmsgip,   //
      sbe_sbi_tmsg_pceom,     //
      sbe_sbi_tmsg_npeom,     //
      sbe_sbi_tmsg_pcpayload, //
      sbe_sbi_tmsg_nppayload, //
      sbe_sbi_tmsg_pccmpl,    //
      sbe_sbi_tmsg_pcvalid,
      sbe_sbi_tmsg_npvalid,
      sbe_sbi_tmsg_pcparity,
      sbe_sbi_tmsg_npparity,
// PCR 12042104 - Unique Extended Headers SAIRS Inputs - START
      ur_csairs_valid,   // lintra s-70036 s-0527 "Indicates when the sairs inputs are valid and should be used"
      ur_csai,           // lintra s-70036 s-0527 "SAI value for extended headers"
      ur_crs,            // lintra s-70036 s-0527 "RS value for extended headers"
      ur_rx_sairs_valid, // lintra s-70036 s-0527 "Indicates when the sairs inputs are valid and should be used"
      ur_rx_sai,         // lintra s-70036 s-0527 "SAI value for extended headers"
      ur_rx_rs,          // lintra s-70036 s-0527 "RS value for extended headers"
// PCR 12042104 - Unique Extended Headers SAIRS Inputs - FINISH

// SBC-PCN-007 - Insert completion counter outputs - START
      sbe_sbi_comp_exp,
// SBC-PCN-007 - Insert completion counter outputs - FINISH

      // Master interface to the AGENT block
      sbi_sbe_mmsg_pcirdy,    //
      sbi_sbe_mmsg_npirdy,    //
      sbi_sbe_mmsg_pceom,     //
      sbi_sbe_mmsg_npeom,     //
      sbi_sbe_mmsg_pcpayload, //
      sbi_sbe_mmsg_nppayload, //
      sbi_sbe_mmsg_pcparity,  //
      sbi_sbe_mmsg_npparity,  //
      sbe_sbi_mmsg_pctrdy,    //
      sbe_sbi_mmsg_nptrdy,    //
      sbe_sbi_mmsg_pcmsgip,   //
      sbe_sbi_mmsg_npmsgip,   //
      sbe_sbi_mmsg_pcsel,     //
      sbe_sbi_mmsg_npsel,     //

      // Config register Inputs
      cgctrl_idlecnt,         // Config
      cgctrl_clkgaten,        // registers
      cgctrl_clkgatedef,

      // DFx
      visa_all_disable,
      visa_customer_disable,
      avisa_data_out,
      avisa_clk_out,
      visa_ser_cfg_in,
      sbe_visa_bypass_cr_out,
      sbe_visa_serial_rd_out,

      visa_port_tier1_sb,       // VISA debug candidates
      visa_fifo_tier1_sb,     // high priority
      visa_fifo_tier1_ag,
      visa_agent_tier1_ag,

      visa_port_tier2_sb,       // VISA debug candidates
      visa_fifo_tier2_sb,     // low priority
      visa_fifo_tier2_ag,
      visa_agent_tier2_ag,

      jta_clkgate_ovrd,       // JTAG overrides
      jta_force_clkreq,       //
      jta_force_idle,         //
      jta_force_notidle,      //
      jta_force_creditreq,    //
      fscan_latchopen,        // Latch based
      fscan_latchclosed_b,    // queue testing
      fscan_clkungate,        // clock gate override
      fscan_clkungate_syn,
      fscan_rstbypen,
      fscan_byprst_b,
      fscan_mode,
      fscan_shiften,

      tx_ext_headers
);

`include "hqm_sbcglobal_params.vm"
`include "hqm_sbcstruct_local.vm"

  input  logic                        side_clk;
  output logic                        gated_side_clk;
  input  logic                        side_rst_b;

  input  logic                        agent_clk;              // lintra s-0527, s-70036 "AGENT clock; only used for async endpoints"
  input  logic                        agent_side_rst_b_sync;  // lintra s-0527, s-70036 "pre-synchronized agent reset; only used for async endpoints"
                                                              // ONLY USED for sbendpoint

  input  logic                        usyncselect; // lintra s-0527, s-70036 "Only used when USYNC enabled."
  input  logic                        side_usync;  // lintra s-0527, s-70036 "Only used when USYNC enabled."
  input  logic                        agent_usync; // lintra s-0527, s-70036 "Only used when USYNC enabled."


  // Clock gating ISM Signals (endpoint)
  input  logic                        sbi_sbe_clkreq;
  input  logic                        sbi_sbe_idle;
  input  logic                  [2:0] side_ism_fabric;
  output logic                  [2:0] side_ism_agent;
  input  logic                        side_ism_lock_b; // SBC-PCN-002 - Sideband ISM Lock for power gating flows
  output logic                        side_clkreq;
  input  logic                        side_clkack;

  // Clock gating ISM Signals (AGENT block)
  output logic                        sbe_sbi_clkreq;
  output logic                        sbe_sbi_idle;
  output logic                        sbe_sbi_clk_valid;

  // Egress port interface to the IOSF Sideband Channel
  input  logic                        mpccup;
  input  logic                        mnpcup;
  output logic                        mpcput;
  output logic                        mnpput;
  output logic                        meom;
  output logic [MAXPLDBIT:0]          mpayload;       // lintra s-80095
  output logic                        mparity;

  // Ingress port interface to the IOSF Sideband Channel
  output logic                        tpccup;
  output logic                        tnpcup;
  input  logic                        tpcput;
  input  logic                        tnpput;
  input  logic                        teom;
  input  logic [MAXPLDBIT:0]          tpayload;     // lintra s-80095
  input  logic                        tparity;

  // Parity Message interface
  input  logic                 [7:0]  do_serr_hier_dstid_strap; // lintra s-70036 s-0527 "used only for parity cfgs"
  input  logic                 [7:0]  do_serr_hier_srcid_strap; // lintra s-70036 s-0527 "used only for parity cfgs"
  input  logic                 [7:0]  do_serr_srcid_strap; // lintra s-70036 s-0527 "used only for parity cfgs"
  input  logic                 [7:0]  do_serr_dstid_strap; // lintra s-70036 s-0527 "used only for parity cfgs"
  input  logic                 [2:0]  do_serr_tag_strap;   // lintra s-70036 s-0527 "used only for parity cfgs"
  input  logic                        global_ep_strap;
  input  logic                        do_serr_sairs_valid; // lintra s-70036 s-0527 "used only for parity cfgs"
  input  logic          [SAIWIDTH:0]  do_serr_sai;         // lintra s-70036 s-0527 "used only for parity cfgs" 
  input  logic          [ RSWIDTH:0]  do_serr_rs;          // lintra s-70036 s-0527 "used only for parity cfgs"
  output logic                        sbe_sbi_parity_err_out;
  input  logic                        ext_parity_err_detected;  // lintra s-70036 s-0527 "used only for parity cfgs"
  input  logic                        fdfx_sbparity_def;
  
  // Target interface to the AGENT block
  input  logic          [MAXPCTRGT:0] sbi_sbe_tmsg_pcfree;    //
  input  logic          [MAXNPTRGT:0] sbi_sbe_tmsg_npfree;    //
  input  logic          [MAXNPTRGT:0] sbi_sbe_tmsg_npclaim;   //
  output logic                        sbe_sbi_tmsg_pcput;     //
  output logic                        sbe_sbi_tmsg_npput;     //
  output logic                        sbe_sbi_tmsg_pcmsgip;   //
  output logic                        sbe_sbi_tmsg_npmsgip;   //
  output logic                        sbe_sbi_tmsg_pceom;     //
  output logic                        sbe_sbi_tmsg_npeom;     //
  output logic     [INTERNALPLDBIT:0] sbe_sbi_tmsg_pcpayload; //
  output logic     [INTERNALPLDBIT:0] sbe_sbi_tmsg_nppayload; //
  output logic                        sbe_sbi_tmsg_pccmpl;    //
  output logic                        sbe_sbi_tmsg_pcvalid;
  output logic                        sbe_sbi_tmsg_npvalid;
  output logic                        sbe_sbi_tmsg_pcparity;
  output logic                        sbe_sbi_tmsg_npparity;
// PCR 12042104 - Unique Extended Headers SAIRS Inputs - START
  input  logic                        ur_csairs_valid;   // lintra s-70036 s-0527 "Indicates when the sairs inputs are valid and should be used"
  input  logic           [SAIWIDTH:0] ur_csai;           // lintra s-70036 s-0527 "SAI value for extended headers"
  input  logic           [ RSWIDTH:0] ur_crs;            // lintra s-70036 s-0527 "RS value for extended headers"
  output logic                        ur_rx_sairs_valid; // lintra s-70036 s-0527 "Indicates when the sairs inputs are valid and should be used"
  output logic           [SAIWIDTH:0] ur_rx_sai;         // lintra s-70036 s-0527 "SAI value for extended headers"
  output logic           [ RSWIDTH:0] ur_rx_rs;          // lintra s-70036 s-0527 "RS value for extended headers"
// PCR 12042104 - Unique Extended Headers SAIRS Inputs - FINISH

// SBC-PCN-007 - Insert completion counter outputs - START
  output logic                        sbe_sbi_comp_exp;
// SBC-PCN-007 - Insert completion counter outputs - FINISH

  // Master interface to the AGENT block
  input  logic          [MAXPCMSTR:0] sbi_sbe_mmsg_pcirdy;    //
  input  logic          [MAXNPMSTR:0] sbi_sbe_mmsg_npirdy;    //
  input  logic          [MAXPCMSTR:0] sbi_sbe_mmsg_pceom;     //
  input  logic          [MAXNPMSTR:0] sbi_sbe_mmsg_npeom;     //
  input  logic    [(INTERNALPLDBIT+1)*MAXPCMSTR+INTERNALPLDBIT:0] sbi_sbe_mmsg_pcpayload; //
  input  logic    [(INTERNALPLDBIT+1)*MAXNPMSTR+INTERNALPLDBIT:0] sbi_sbe_mmsg_nppayload; //
  input  logic          [MAXPCMSTR:0] sbi_sbe_mmsg_pcparity;  // lintra s-0527 s-70036 "parity pins will be connected when parity propation is implemented"
  input  logic          [MAXNPMSTR:0] sbi_sbe_mmsg_npparity;  // lintra s-0527 s-70036
  output logic                        sbe_sbi_mmsg_pctrdy;    //
  output logic                        sbe_sbi_mmsg_nptrdy;    //
  output logic                        sbe_sbi_mmsg_pcmsgip;   //
  output logic                        sbe_sbi_mmsg_npmsgip;   //
  output logic          [MAXPCMSTR:0] sbe_sbi_mmsg_pcsel;     //
  output logic          [MAXNPMSTR:0] sbe_sbi_mmsg_npsel;     //

  // Config register Inputs
  input  logic                  [7:0] cgctrl_idlecnt;         // Config
  input  logic                        cgctrl_clkgaten;        // registers
  input  logic                        cgctrl_clkgatedef;

  // DFx
  input logic                                                                visa_all_disable;      // lintra s-0527, s-70036 "Only used when ULM is inside the endpoint"
  input logic                                                                visa_customer_disable; // lintra s-0527, s-70036 "Only used when ULM is inside the endpoint"
  output logic [(NUMBER_OF_OUTPUT_LANES-1):0][(NUMBER_OF_BITS_PER_LANE-1):0] avisa_data_out;        // lintra s-2058, s-70044 "Only used when ULM is inside the endpoint"
  output logic [(NUMBER_OF_OUTPUT_LANES-1):0]                                avisa_clk_out;         // lintra s-2058, s-70044 "Only used when ULM is inside the endpoint"
  input logic [2:0]                                                          visa_ser_cfg_in;       // lintra s-0527, s-70036 "Only used when ULM is inside the endpoint"

  output logic [(NUMBER_OF_OUTPUT_LANES-1):0]  sbe_visa_bypass_cr_out;  // lintra s-2058
  output logic                                sbe_visa_serial_rd_out; // lintra s-2058

  output visa_port_tier1              visa_port_tier1_sb;       // VISA debug candidates
  output visa_epfifo_tier1_sb         visa_fifo_tier1_sb;     // high priority
  output visa_epfifo_tier1_ag         visa_fifo_tier1_ag;
  output visa_agent_tier1             visa_agent_tier1_ag;

  output visa_port_tier2              visa_port_tier2_sb;       // VISA debug candidates
  output visa_epfifo_tier2_sb         visa_fifo_tier2_sb;     // low priority
  output visa_epfifo_tier2_ag         visa_fifo_tier2_ag;
  output visa_agent_tier2             visa_agent_tier2_ag;

  input  logic                        jta_clkgate_ovrd;       // JTAG overrides
  input  logic                        jta_force_clkreq;       //
  input  logic                        jta_force_idle;         //
  input  logic                        jta_force_notidle;      //
  input  logic                        jta_force_creditreq;    //
  input  logic                        fscan_mode;             // lintra s-0527, s-70036 "Used by synthesis tools"
  input  logic                        fscan_latchopen;        // Latch based
  input  logic                        fscan_latchclosed_b;    // queue testing
  input  logic                        fscan_clkungate;        // clock gate override
  input  logic                        fscan_clkungate_syn;    // lintra s-0527, s-70036 "Used by synthesis tools"
  input  logic                        fscan_rstbypen;         // Bypass all resets
  input  logic                        fscan_byprst_b;         // Bypass all resets
  input  logic                        fscan_shiften;          // lintra s-0527, s-70036 "Used by synthesis tools"

  input logic [NUM_TX_EXT_HEADERS:0][31:0] tx_ext_headers;


  localparam EXTMAXPLDBIT  = MAXPLDBIT;
  localparam INTMAXPCMSTR  = MAXPCMSTR + 1;
  localparam SBCISMISAGENT = 1;

// Egress Port Interface Signals
logic        sb_enpstall;
logic        sb_epctrdy;
logic        sb_enptrdy;
logic        sb_epcirdy;
logic        sb_enpirdy;
logic        sb_eom;
logic        sb_parity;
logic [INTERNALPLDBIT:0] sb_data;

logic        agent_enpstall;
logic        agent_epctrdy;
logic        agent_enptrdy;
logic        agent_epcirdy;
logic        agent_enpirdy;
logic        agent_eom;
logic        agent_parity;
logic [INTERNALPLDBIT:0] agent_data;

// Ingress Port Interface Signals
logic        sb_pctrdy;
logic        sb_pcirdy;
logic        sb_pceom;
logic        sb_pcparity;
logic [INTERNALPLDBIT:0] sb_pcdata;
logic        sb_nptrdy;
logic        sb_npirdy;
logic        sb_npfence;
logic        sb_npeom;
logic        sb_npparity;
logic [INTERNALPLDBIT:0] sb_npdata;

logic        agent_pctrdy;
logic        agent_pcirdy;
logic        agent_pceom;
logic        agent_pcparity;
logic [INTERNALPLDBIT:0] agent_pcdata;
logic        agent_nptrdy;
logic        agent_npirdy;
logic        agent_npfence;
logic        agent_npeom;
logic        agent_npparity;
logic [INTERNALPLDBIT:0] agent_npdata;

// target/master completion fence
logic        cfence;
logic [7:0]  npdest_mstr, hier_dest_tmsg;
logic [7:0]  npsrc_mstr, hier_src_tmsg;
logic [2:0]  nptag_mstr;

// ISM Interface Signals
logic        idle_mstr;
logic        idle_trgt;
logic        cg_inprogress;
//logic        ism_idle;
logic        agent_agent_idle;
logic        sb_agent_idle;
logic        agent_port_idle;
logic        sb_port_idle;
logic        agent_fifo_idle;
logic        sb_fifo_idle;
logic        side_clk_valid;
logic        side_clk_int;

// SBEMSTR Interface Signals
logic [INTMAXPCMSTR+DO_SERR_MASTER:0]       mmsg_pcsel;
logic [INTMAXPCMSTR:0]       mmsg_pcirdy;
logic [INTMAXPCMSTR:0]       mmsg_pceom;
logic [INTMAXPCMSTR:0]       mmsg_pcparity;
logic [INTMAXPCMSTR:0][INTERNALPLDBIT:0] mmsg_pcpayload;

// SBEMSTR + Parity Interface Signals
logic [INTMAXPCMSTR+DO_SERR_MASTER:0]       mmsg_comb_pcirdy;
logic [MAXNPMSTR:0]          mmsg_comb_npirdy;
logic [MAXNPMSTR:0]          mmsg_comb_npparity;
logic [INTMAXPCMSTR+DO_SERR_MASTER:0]       mmsg_comb_pceom;
logic [INTMAXPCMSTR+DO_SERR_MASTER:0]       mmsg_comb_pcparity;
logic [MAXNPMSTR:0]          mmsg_comb_npeom;
logic [INTMAXPCMSTR+DO_SERR_MASTER:0][INTERNALPLDBIT:0]                mmsg_comb_pcpayload;
logic [(INTERNALPLDBIT+1)*MAXNPMSTR+INTERNALPLDBIT:0]   mmsg_comb_nppayload;

logic                        ism_in_notidle;
logic                        idle_count;
logic                        idle_count_msgip;
logic                        agent_fifo_idleff;
logic                        pcmsgipb, npmsgipb;
logic                        maxidlecnt;             // lintra s-70036

logic                        side_clkreq_wake;
logic                        side_clkreq_sync_wake;
logic                        side_clkreq_async_wake;
logic                        side_clkreq_async_wake_sync; // lintra s-80009
logic                        side_clkreq_idle;
logic                        side_clkreq_idle_async;
logic                        ingress_port_idle_ff;
logic                        egress_port_idle_ff;

logic                        usyncselect_int;

logic [7:0] cfg_idlecnt;
logic       cfg_clkgaten;
logic       cfg_clkgatedef;
logic       agent_rst_b_sync;   // lintra s-70036 "Only used when ASYNCENDPT=1"
logic       sbi_sbe_clkreq_ff2; // lintra s-70036 "Only used when ASYNCENDPT=1"

logic       ext_parity_err_detected_sync;
logic       ififo_err_out_sync; // lintra s-70036 "only used for parity+async"
logic       parity_err_out;
logic       sbe_sbi_parity_err_out_side;

//Added for DFX_SYNC
logic jta_clkgate_ovrd_sync, jta_force_idle_sync, jta_force_notidle_sync, jta_force_creditreq_sync;

   // Universal Sync'er Select
   assign usyncselect_int = usyncselect && |USYNC_ENABLE;

// Setup the sideband clocks wake/idle conditions
// WAKE INPUTS: The WAKE inputs will forcefully turn on the clock request if
// the clock request module is in the GATED state and HYSTERESIS counter is
// cleared. These signals are all OR'd together, this way if any one signal is
// already high all other inputs would be free to change as they please.
// All the inputs from the endpoint will be present for at least one full clock
// cycle. Any inputs from the parent block will be required to provide their
// inputs with no one going glitches. While the clock request signal is active
// the input terms will be ignored within the clocking unit.
// These are the WAKE terms considered for the endpoints side_clk domain:
// 1. side_ism_fabric - This is a 3-bit gray-coded FSM coming from the ingress
//    ISM from every port reguardless of clock domain. When it transitions out
//    of IDLE the three input OR gate should not display one-going glitches as
//    the input will always have a single bit remain high between non-idle
//    transitions. These transitions will also occur on the same clock domain
//    as the endpoint, except originates from the routing fabric. The ISM
//    should not be gated with combinational logic between the two interfaces
//    or glitches can occure if not handled appropriately.
// 2. sbi_sbe_clkreq - This is the clock request/wake signal from the parent
//    IP. This signal SHOULD come from a flop and MUST be free of one-going
//    glitches. If combinatorial logic is used, it should be done using an
//    OR gate to prevent one-going glitches. This signal SHOULD be held high
//    before mastering messages and MUST be held high for at least one clock
//    cycle. It is PREFERED that the signal is held high until the signal
//    sbe_sbi_clkvalid is asserted to guarantee that the clock request has
//    been acknowledged the the fail safe wake gate has been enabled in the
//    clocking unit. In the endpoint wrapper the target register module
//    will be OR'd with this term. This should be clear of one-going glitches.
// 3. egress_port_idle_ff - This signal is the input side of the egress
//    asynchronous fifo. This signal will indicate that something has been
//    inserted into the asynchronous FIFO and/or the agent_idle signal has
//    been asserted by the agent. This signal will remain high so long
//    as the agent holds sbi_sbe_idle low or there is data present in the
//    FIFO. This signal comes directly off of a flop in the agent_clk domain.
// 4. jta_force_clkreq - This signal is the JTAG override to force the clock
//    request to go to active. With this signal alone, the clock can be
//    initially requested, but without an idle component the clock request
//    will eventually drop then be requested again after the clock acknowledge
//    has dropped.
// IDLE INPUTS: The Idle Inputs are used to maintain the clock request module
// in the active state. After these idle terms all go high the clock request
// module with go through HYSTERESIS to confirm that no more transactions are
// coming. This will create a hazard resistance and is really meant to
// prevent banging the clkreq on and off for no reason. Ideally, these idle
// signals should pair up with a synchronous version of the WAKE terms 1:1.
// They should be present no shorter than the WAKE version and should come
// from the side_clk domain only. The fully asynchronous terms sbi_sbe_clkreq
// and jta_force_clkreq required to be used by the synchronous logic that
// don't come from any other sources.
// These are the IDLE terms considered per port:
// 1. side_ism_fabric - The local ISM being non-zero will guarantee both
//    sides of the ISM have transitioned to IDLE before the clock starts to be
//    gated. This signal is fully on the side_clk domain
// 2. side_ism_agent - The remote ISM being non-zero will guarantee both
//    sides of the ISM have transitioned to IDLE before the clock starts to be
//    gated. This signal is fully on the side_clk domain
// 3. sb_agent_idle - This signal is always be a function of the parent
//    IPs sbi_sbe_idle signal and the master message interface module idle
//    indicator. If an asynchronous endpoint is indicated, then this signal
//    will get combined with the FIFO is not empty and synchronized to the
//    side_clk domain.
// 4. ingress_port_idle_ff - clean version of the ingress async fifos empty
//    and port not idle indicators from the sbcport. This signal is fully
//    on the side_clk domain. This signal is a function of the port_idle
//    indicator.
//    NOTE: Since this signal is a constant when the endpoint is in
//          synchronous mode, this signal can be ignored when ASYNCENDPT = 0;
// 5. sb_port_idle - This signal is an indication from the port when it is
//    not idle and requires the clock to actively produce activity.
//    NOTE: Since this signal is already factored into ingress_port_idle_ff
//          when the endpoint is in asynchronous mode, this signal can be
//          ignored when ASYNCENDPT = 1;
// 6. idle_trgt - This signal is an indication from the target message
//    interface that it is currently processing a message, it will keep the
//    clocks running due to detection that there is more data to come or that
//    a non-posted message that was unclaimed may be returning back to the
//    fabric. In either case, it is not worth losing the clock, even if
//    the fabric and agent ISMs have agreed to go IDLE.
//    NOTE: This signal is only in the side_clk domain when the endpoint
//          is in synchronous mode, this signal can be ignored when
//          ASYNCENDPT = 1;
//    NOTE: If this signal is desired for the return for asynchronous
//          endpoint modes, it will need to be synchronized. It was decided
//          not to pull in this logic since it may not actually save any
//          cycles and the master message interface or the two asynchronous
//          FIFOs will cover the return path anyway.
   always_comb side_clkreq_sync_wake = (
                  |(side_ism_fabric) // WAKE 1
               );

// Wake terms from asynchronous sources. Will not be flopped as the sources are
// not deterministic. These terms should be coming off a flop or are sudo
// synchronous such as the signal jta_force_clkreq. Technically the signal
// egress_port_idle_ff is not necessary for the sustain term but is left in as
// it doesn't cause any harm.
   always_comb side_clkreq_async_wake = (
                  (|ASYNCENDPT ? sbi_sbe_clkreq : 1'b0) | // WAKE 2
                  ~egress_port_idle_ff                  | // WAKE 3
                  jta_force_clkreq                        // WAKE 4
               );

   always_comb side_clkreq_wake = side_clkreq_sync_wake  | // Wake terms that are already synchronous to the side_clk
                                  side_clkreq_async_wake | // Wake terms that are asynchronous to the side_clk
                                  (|ASYNCENDPT ? 1'b0 : sbi_sbe_clkreq) | // Fixes CDC to not use more than one synchronizer on sbi_sbe_clkreq
                                  (|DO_SERR_MASTER ? mmsg_comb_pcirdy[INTMAXPCMSTR+DO_SERR_MASTER]: 1'b0); // request to wake fabric ism when there is a error message from do_serr to be sent out

   hqm_sbc_doublesync
   i_sbc_doublesync_wake (
      .clk  ( side_clk                    ),
      .clr_b( side_rst_b                  ),
      .d    ( side_clkreq_async_wake      ),
      .q    ( side_clkreq_async_wake_sync )
   );

   always_comb side_clkreq_idle = (
                  ~side_clkreq_async_wake_sync               & // Roll back in the async wake terms.
                  (|ASYNCENDPT ? 1'b1 : ~sbi_sbe_clkreq_ff2) & // If sync endpoint, do not resync sbi_sbe_clkreq
                  ~(|{side_ism_fabric,side_ism_agent})       & // IDLE 1 & 2
                  sb_agent_idle                              & // IDLE 3
                  side_clkreq_idle_async                       // (A)sync Idle Terms
               );

   generate
      if( |ASYNCENDPT ) begin : gen_side_clkreq_async
         always_comb side_clkreq_idle_async = ingress_port_idle_ff; // IDLE 4
      end else begin : gen_side_clkreq_sync
         always_comb side_clkreq_idle_async = sb_port_idle & // IDLE 5
                                              idle_trgt    ; // IDLE 6
      end
   endgenerate

   hqm_sbcasyncclkreq #(
      .HYST_CNT( SIDE_CLKREQ_HYST_CNT ),
      .CLKREQDEFAULT ( CLKREQDEFAULT )
   ) i_sbcasyncclkreq_side_clk (
      .clk  ( side_clk   ),
      .rst_b( side_rst_b ),

      .fscan_rstbypen ( fscan_rstbypen  ),
      .fscan_byprst_b ( fscan_byprst_b  ),
      .fscan_clkungate( fscan_clkungate ),

      .parity_err ('0), // used only in RTR case
      .wake( side_clkreq_wake ),
      .idle( side_clkreq_idle ),

      .clkreq  ( side_clkreq    ),
      .clkack  ( side_clkack    ),
      .clkvalid( side_clk_valid )
   );

   always_comb begin
      agent_agent_idle  = sbi_sbe_idle & idle_mstr & ~sbe_sbi_parity_err_out;// & idle_trgt;
      sbe_sbi_idle      = agent_port_idle & idle_mstr & idle_trgt & agent_fifo_idleff & ~sbe_sbi_parity_err_out_side;
// ext_parity_err is used to send out do_serr message and needs agent clock. Hence it is used to request agent clk      
      sbe_sbi_clkreq    = ~sb_port_idle | ~sb_fifo_idle | ext_parity_err_detected | sbe_sbi_parity_err_out_side; //asynchronous
      sbe_sbi_clk_valid = side_clk_valid | ism_in_notidle;
   end

//------------------------------------------------------------------------------
//
// DFX
//
//------------------------------------------------------------------------------

  // rearrange debug outputs to tiers for easier lane assignment.

  logic [37:0]                 visa_port_dbgbus;       // VISA debug candidates
  logic [31:0]                 visa_fifo_dbgbus_sb;
  logic [31:0]                 visa_fifo_dbgbus_ag;
  logic [31:0]                 visa_agnt_dbgbus;

  always_comb
    begin
      visa_port_tier1_sb    = {
                               visa_port_dbgbus[37:34], // parity_err_out, int_pok, cg_en
                               visa_port_dbgbus[23:22], // func_valid_visa
                               visa_port_dbgbus[33], // ip_idle
                               visa_port_dbgbus[29], // |pcxfr
                               visa_port_dbgbus[28], // |npxfr
                               visa_port_dbgbus[27], // |pccredits
                               visa_port_dbgbus[26], // |npcredits
                               visa_port_dbgbus[21], // pcmsgip
                               visa_port_dbgbus[20], // npmsgip
                               visa_port_dbgbus[19], // |outmsg_cup
                               visa_port_dbgbus[15:12], // NP qcnt
                               visa_port_dbgbus[7:4] // PC qcnt
                              };
      visa_port_tier2_sb   = {
                               visa_port_dbgbus[32:30], // ism_out
                               visa_port_dbgbus[25],    // mpcput
                               visa_port_dbgbus[24],    // mnpput
                               visa_port_dbgbus[18:16], // fencecntr
                               visa_port_dbgbus[11:8],  // np cupholdcnt + cupsendcnt
                               visa_port_dbgbus[3:0]    // pc cupholdcnt + cupsendcnt
                             };

      visa_fifo_tier1_sb =  { visa_fifo_dbgbus_sb[7:0],    // ing gray pointers
                              visa_fifo_dbgbus_sb[31:30],  // egr enp/epcirdy
                              visa_fifo_dbgbus_sb[21:16]}; // egr gray pointers

      visa_fifo_tier2_sb = {visa_fifo_dbgbus_sb[15:8],   // ing np gray pointers
                              visa_fifo_dbgbus_sb[29:22]}; // egr np ctrl, gray pointers

      visa_fifo_tier1_ag = { visa_fifo_dbgbus_ag[15:14], // ing enp/pcirdy
                               visa_fifo_dbgbus_ag[5:0],   // ing read control
                               visa_fifo_dbgbus_ag[23:16]};// egr write control

      visa_fifo_tier2_ag = { visa_fifo_dbgbus_ag[13:6],  // ing np ctrl, gray pointers
                               visa_fifo_dbgbus_ag[31:24]};// egr np ctrl

      visa_agent_tier1_ag  = { visa_agnt_dbgbus[29:24], // target
                               // nphdrdrp, pchdrdrp, npfsm, npmsgip, pcmsgip
                               5'b0,
                               visa_agnt_dbgbus[12:8]   // master
                               // cfence, cmsgip, np, npmsgip, pcmsgip
                             };
      visa_agent_tier2_ag   = { 8'b0, visa_agnt_dbgbus[7:0] };     // master
      // npsel / pcsel
    end

  generate
    if (ASYNCENDPT==1)
      begin : gen_async_blk0
        always_comb sbi_sbe_clkreq_ff2    = sbi_sbe_clkreq;
      end
    else
      begin : gen_sync_blk0
        hqm_sbc_doublesync i_sync_sbisbeclkreq (
                                        .d     ( sbi_sbe_clkreq    ),
                                        .clr_b ( side_rst_b        ),
                                        .clk   ( side_clk_int      ),
                                        .q     ( sbi_sbe_clkreq_ff2)
                                        );
     end
  endgenerate

// HSD: 1507055022
generate
genvar i;
        for (i=0; i <= 3; i++) begin : syncidlcnt1
            hqm_sbc_doublesync i_sync_idlecnt1 (
                                          .d     ( cgctrl_idlecnt[i] ),
                                          .clr_b ( side_rst_b        ),
                                          .clk   ( gated_side_clk    ),
                                          .q     ( cfg_idlecnt[i] )
                                          );
        end
        for (i=5; i <= 7; i++) begin: syncidlcnt2
        hqm_sbc_doublesync i_sync_idlecnt2 (
                                          .d     ( cgctrl_idlecnt[i]),
                                          .clr_b ( side_rst_b        ),
                                          .clk   ( gated_side_clk    ),
                                          .q     ( cfg_idlecnt[i] )
                                          );
        end
endgenerate

// HSD:1406999398 ISM moves from active if idlecnt is reset to 0 and clock is gated. So preprogram it to 16 during reset
        hqm_sbc_doublesync_set i_sync_idlecnt3 (
                                          .d     ( cgctrl_idlecnt[4]),
                                          .set_b ( side_rst_b        ),
                                          .clk   ( gated_side_clk    ),
                                          .q     ( cfg_idlecnt[4] )
                                          );

        hqm_sbc_doublesync i_sync_clkgaten (
                                      .d     ( cgctrl_clkgaten   ),
                                      .clr_b ( side_rst_b        ),
                                      .clk   ( side_clk_int      ),
                                      .q     ( cfg_clkgaten      )
                                      );

        hqm_sbc_doublesync i_sync_clkgatedef (
                                        .d     ( cgctrl_clkgatedef ),
                                        .clr_b ( side_rst_b        ),
                                        .clk   ( side_clk_int      ),
                                        .q     ( cfg_clkgatedef    )
                                        );

        hqm_sbc_doublesync i_sync_jta_clkgate_ovrd (
                                      .d     ( jta_clkgate_ovrd  ),
                                      .clr_b ( side_rst_b        ),
                                      .clk   ( side_clk_int      ),
                                      .q     ( jta_clkgate_ovrd_sync )
                                      );

        hqm_sbc_doublesync i_sync_jta_force_idle (
                                      .d     ( jta_force_idle    ),
                                      .clr_b ( side_rst_b        ),
                                      .clk   ( side_clk_int      ),
                                      .q     ( jta_force_idle_sync  )
                                      );
        hqm_sbc_doublesync i_sync_jta_force_notidle (
                                      .d     ( jta_force_notidle    ),
                                      .clr_b ( side_rst_b        ),
                                      .clk   ( side_clk_int      ),
                                      .q     ( jta_force_notidle_sync)
                                      );
        hqm_sbc_doublesync i_sync_jta_force_creditreq (
                                      .d     ( jta_force_creditreq  ),
                                      .clr_b ( side_rst_b        ),
                                      .clk   ( side_clk_int      ),
                                      .q     ( jta_force_creditreq_sync)
                                      );
// unsync'd version of external parity err needed to trigger do_serr (to send message immediately) and sbetrgt (to stop puts)
// sync'd (for async ep) external parity err is used to trigger interal errors
logic ext_parity_err_det;
generate
    if ((|SB_PARITY_REQUIRED==1) && (|ASYNCENDPT==1)) begin : gen_ext_par_async
        logic ext_parity_err_det_pre;
        always_comb ext_parity_err_det_pre = ext_parity_err_detected & ~fdfx_sbparity_def;

        always_ff @(posedge agent_clk or negedge agent_rst_b_sync)
            if (~agent_rst_b_sync)  ext_parity_err_det  <= '0;
            else                    ext_parity_err_det  <= ext_parity_err_det_pre;

        hqm_sbc_doublesync i_sync_ext_parity_err_detected (
                                      .d     ( ext_parity_err_det           ),
                                      .clr_b ( side_rst_b        ),
                                      .clk   ( side_clk_int      ),
                                      .q     ( ext_parity_err_detected_sync )
                                      );
    end
    else if ((|SB_PARITY_REQUIRED==1) && (~|ASYNCENDPT==1)) begin : gen_ext_par_sync
        always_comb ext_parity_err_det = ext_parity_err_detected & ~fdfx_sbparity_def;
        always_comb ext_parity_err_detected_sync = ext_parity_err_det;
    end
    else begin : gen_no_ext_par
        always_comb ext_parity_err_det = '0;
        always_comb ext_parity_err_detected_sync = '0;
    end
endgenerate


  // take the pre-synchronized agent rest from sbendpoint if present,
  // otherwise synchronize side_rst_b to agent clock domain

  generate
    if ( |ASYNCENDPT && ~|RST_PRESYNC )
      begin : gen_async_blk1

        logic agent_rst_b_sync_pre;

        hqm_sbc_doublesync sync_rstb (
                              .d     ( 1'b1                  ),
                              .clr_b ( side_rst_b            ),
                              .clk   ( agent_clk             ),
                              .q     ( agent_rst_b_sync_pre  )
                              );

// Scan Muxes are no longer infered, using scan mux cell that was used in router. - START
        hqm_sbc_ctech_scan_mux i_sbc_ctech_scan_mux_agent_rst_b_sync ( // lintra s-80018
           .d ( agent_rst_b_sync_pre ),
           .si( fscan_byprst_b       ),
           .se( fscan_rstbypen       ),
           .o ( agent_rst_b_sync     )
        );
// Scan Muxes are no longer infered, using scan mux cell that was used in router. - FINISH

      end
    else
     begin : gen_sync_blk1
      always_comb agent_rst_b_sync = agent_side_rst_b_sync;
     end
  endgenerate

  //------------------------------------------------------------------------------
  //
  // Dummy clock buffer, needed for some CPU scan flows
  //
  //------------------------------------------------------------------------------

  generate
    if ( |DUMMY_CLKBUF )
     begin : gen_dclk_buf
      hqm_sbc_clock_buf clkbuf ( .i(side_clk), .o(side_clk_int) );
     end
    else
     begin : gen_ndclk_buf
      always_comb side_clk_int = side_clk;
     end
  endgenerate


  //------------------------------------------------------------------------------
  //
  // Side clock gating
  //
  //------------------------------------------------------------------------------
  logic  clken;
  logic  clkgate_en;
  logic  sb_eagent_idle;

  always_comb
    clkgate_en = ~jta_clkgate_ovrd_sync &
                 (cfg_clkgatedef | ~cfg_clkgaten | ~cg_inprogress | ~sb_fifo_idle | ~sb_eagent_idle | usyncselect_int | sbe_sbi_parity_err_out_side |
                 (|ASYNCENDPT ? 1'b0 : (~idle_mstr | ~idle_trgt | sbi_sbe_clkreq_ff2)));
  // clock must be present to clear target/master transactions in non clock crossing eps, regardless
  // of the ISM state.

  always_ff @(posedge side_clk_int or negedge side_rst_b)
    if (~side_rst_b) clken <= '1;
    else             clken <= clkgate_en;

  hqm_sbc_clock_gate clkgate  (
                       .en    ( clken           ),
                       .te    ( fscan_clkungate ),
                       .clk   ( side_clk        ),
                       .enclk ( gated_side_clk  )
                       );

  logic  agent_side_clk;
  logic  agent_side_rst_b;
  always_comb
    begin
      agent_side_clk   = ASYNCENDPT==1 ? agent_clk        : gated_side_clk;
      agent_side_rst_b = ASYNCENDPT==1 ? agent_rst_b_sync : side_rst_b;
    end


//------------------------------------------------------------------------------
//
// Master Interface
//
//------------------------------------------------------------------------------

  logic mmsg_pcirdy_tmsg, mmsg_pceom_tmsg, mmsg_pcparity_tmsg;
  logic [INTERNALPLDBIT:0] mmsg_pcpayload_tmsg;


  always_comb
    begin
      // trdy signals are driven directly from the egress port to the master interface
      sbe_sbi_mmsg_pctrdy         = agent_epctrdy;
      sbe_sbi_mmsg_nptrdy         = agent_enptrdy;

      // assign the lower external pcsel signals to the master interface
      sbe_sbi_mmsg_pcsel          = mmsg_pcsel[MAXPCMSTR:0];

      // assign the master interface signal into the internal arrays
      mmsg_pcirdy                 = { mmsg_pcirdy_tmsg, sbi_sbe_mmsg_pcirdy };
      mmsg_pceom                  = { mmsg_pceom_tmsg, sbi_sbe_mmsg_pceom };
      mmsg_pcpayload              = { mmsg_pcpayload_tmsg, sbi_sbe_mmsg_pcpayload };
      mmsg_pcparity               = { mmsg_pcparity_tmsg, sbi_sbe_mmsg_pcparity };

    end

  always_comb idle_count_msgip = idle_count & pcmsgipb & npmsgipb;


//------------------------------------------------------------------------------
//
// Target Interface
//
//------------------------------------------------------------------------------

  always_comb
    begin
      // The message flits are driven directly from the ingress port to the target
      // interface.  Also the non-posted message in-progress signal comes from the
      // ingress port.  The posted/completion message in-progress signal is generated
      // in the target interface block (sbetrgt)
      sbe_sbi_tmsg_pceom     = agent_pceom;
      sbe_sbi_tmsg_npeom     = agent_npeom;
    end

//------------------------------------------------------------------------------
//
// sbcport: Clock Gating ISM, Ingress Port and Egress Port
//
//------------------------------------------------------------------------------
hqm_sbcport #(
  .EXTMAXPLDBIT           ( EXTMAXPLDBIT                  ),
  .INGMAXPLDBIT           ( INTERNALPLDBIT                ),
  .EGRMAXPLDBIT           ( INTERNALPLDBIT                ),
  .CUP2PUT1CYC            (  1                            ),
  .NPQUEUEDEPTH           ( NPQUEUEDEPTH                  ),
  .PCQUEUEDEPTH           ( PCQUEUEDEPTH                  ),
  .ISM_IS_AGENT_STRAP     ( 0                             ),
  .SBCISMISAGENT          ( SBCISMISAGENT                 ),
  .SYNCROUTER             (  0                            ),
  .LATCHQUEUES            ( LATCHQUEUES                   ),
  .RELATIVE_PLACEMENT_EN  ( RELATIVE_PLACEMENT_EN         ),
  .SKIP_ACTIVEREQ         ( SKIP_ACTIVEREQ                ),
  .PIPEISMS               ( PIPEISMS                      ),
  .PIPEINPS               ( PIPEINPS                      ),
  .ENDPOINTONLY           ( 1                             ),
  .SB_PARITY_REQUIRED     ( SB_PARITY_REQUIRED            ),
  .RTR_SB_PARITY_REQUIRED ( SB_PARITY_REQUIRED            ),
  .STAP_FOR_MISR          ( 0                             ),
// SBC-PCN-007 - Adding in expected completions counter to base endpoint - START
  .EXPECTED_COMPLETIONS_COUNTER( EXPECTED_COMPLETIONS_COUNTER      ),
  .ISM_COMPLETION_FENCING ( ISM_COMPLETION_FENCING        ),
  .GLOBAL_EP              ( GLOBAL_EP                     ),
  .GLOBAL_EP_IS_STRAP     ( GLOBAL_EP_IS_STRAP            )
// SBC-PCN-007 - Adding in expected completions counter to base endpoint - FINISH
) sbcport (
  .side_clk               ( side_clk_int                  ),
  .gated_side_clk         ( gated_side_clk                ),
  .side_rst_b             ( side_rst_b                    ),

  .side_clk_valid         ( side_clk_valid                ),
  .side_ism_in            ( side_ism_fabric               ),
  .side_ism_out           ( side_ism_agent                ),
  .side_ism_lock_b        ( side_ism_lock_b               ), // SBC-PCN-002 - Sideband ISM Lock for power gating flows
// SBC-PCN-004 - Inserted clock gate enable for PCG - START
  .cg_en                  (                               ), // lintra s-0214
  .cg_delay_width_strap   ( '0                            ),
// SBC-PCN-004 - Inserted clock gate enable for PCG - FINISH
  .int_pok                ( 1'b1                          ),
  .port_disable           ( 1'b0                          ),
  .async_ififo_idle       ( 1'b1                          ),
  .agent_idle             ( sb_agent_idle                 ),
  .idle_count             ( idle_count_msgip              ),
  .port_idle              ( sb_port_idle                  ),
  .maxidlecnt             ( maxidlecnt                    ),
  //.ism_idle               ( ism_idle                      ),
  .ism_idle               (                               ), // lintra s-0214
  .idle_egress            (                               ), // lintra s-0214
// SBC-PCN-001 - Inserted new signals for driving power gating information - START
  .idle_comp              (                               ), // lintra s-0214
  .port_pwrgt             (                               ), // lintra s-0214
// SBC-PCN-001 - Inserted new signals for driving power gating information - FINISH
// SBC-PCN-007 - Insert completion counter outputs - START
  .ism_comp_exp           ( sbe_sbi_comp_exp              ),
// SBC-PCN-007 - Insert completion counter outputs - FINISH
  .cg_inprogress          ( cg_inprogress                 ),
  .global_ep_strap        ( global_ep_strap               ),
  .tpccup                 ( tpccup                        ),
  .tnpcup                 ( tnpcup                        ),
  .tpcput                 ( tpcput                        ),
  .tnpput                 ( tnpput                        ),
  .teom                   ( teom                          ),
  .tpayload               ( tpayload                      ),
  .tparity                ( tparity                       ),
  .pctrdy                 ( sb_pctrdy                     ),
  .pcirdy                 ( sb_pcirdy                     ),
  .pcdata                 ( sb_pcdata                     ),
  .pceom                  ( sb_pceom                      ),
  .pcparity               ( sb_pcparity                   ),
  .pcdstvld               (                               ), // lintra s-0214
  .nptrdy                 ( sb_nptrdy                     ),
  .npirdy                 ( sb_npirdy                     ),
  .npfence                ( sb_npfence                    ),
  .npdata                 ( sb_npdata                     ),
  .npeom                  ( sb_npeom                      ),
  .npparity               ( sb_npparity                   ),
  .npdstvld               (                               ), // lintra s-0214

  .mpccup                 ( mpccup                        ),
  .mnpcup                 ( mnpcup                        ),
  .mpcput                 ( mpcput                        ),
  .mnpput                 ( mnpput                        ),
  .meom                   ( meom                          ),
  .mpayload               ( mpayload                      ),
  .mparity                ( mparity                       ),
  .enpstall               ( sb_enpstall                   ),
  .epctrdy                ( sb_epctrdy                    ),
  .enptrdy                ( sb_enptrdy                    ),
  .epcirdy                ( sb_epcirdy                    ),
  .enpirdy                ( sb_enpirdy                    ),
  .data                   ( sb_data                       ),
  .parity                 ( sb_parity                     ),
  .eom                    ( sb_eom                        ),
  .ext_parity_err_detected( ext_parity_err_detected_sync  ),
  .parity_err_out         ( parity_err_out                ),
  .srcidck_err_out        (                               ), // lintra s-0214, s-60024a
  .cfg_idlecnt            ( cfg_idlecnt                   ),
  .cfg_clkgaten           ( cfg_clkgaten                  ),
  .cfg_hierbridgeen       ( 1'b0                          ), // lintra s-0214, s-60024a
  .cfg_hierbridgepid      ( 8'h00                         ), // lintra s-0214, s-60024a
  .cfg_srcidckdef         ( 1'b1                          ), // lintra s-0214, s-60024a
  .cfg_parityckdef        ( fdfx_sbparity_def             ),
  .force_idle             ( jta_force_idle_sync           ),
  .force_notidle          ( jta_force_notidle_sync        ),
  .force_creditreq        ( jta_force_creditreq_sync      ),
  .dt_latchopen           ( fscan_latchopen               ),
  .dt_latchclosed_b       ( fscan_latchclosed_b           ),
  .tdr_mbp_enable         ( 1'b0                          ), 
  .tdr_ftap_tck           ( 1'b0                          ), 
  .tdr_sbr_data           ( {38{1'b0}}                    ), 
  .sbr_tdr_data           (                               ), // lintra s-0214
  .tdr_sbr_data_dfx       ( {91{1'b0}}                    ), 
  .sbr_tdr_data_dfx       (                               ), // lintra s-0214
  .srcid_portlist         ( {256{1'b0}}                   ),
  .fscan_clkungate        ( fscan_clkungate               ), // lintra s-0214, s-60024a
  .fscan_clkungate_misr   ( 1'b0                          ),
  .fscan_clkungate_syn    ( 1'b0                          ),
  .fscan_byprst_b         ( 1'b0                          ),
  .fscan_rstbypen         ( 1'b0                          ),
  .fscan_shiften          ( 1'b0                          ),
  .dbgbus                 ( visa_port_dbgbus[37:0]        ),
  .credit_reinit          (                               ), // lintra s-0214
  .ism_in_notidle         ( ism_in_notidle                ),
  .ism_is_agent_sel       ( 1'b0                          ),
  .agent_clkena           ( 1'b0                          ),
  .cfg_clkgatedef         ( 1'b0                          ),
  .jta_clkgate_ovrd       ( 1'b0                          )
);

//------------------------------------------------------------------------------
//
// Asynchronous FIFO (optional, only instantiated for an asynchronous endpoint)
//
//------------------------------------------------------------------------------

generate
  if (ASYNCENDPT==1)
    begin : gen_async_blk2

      //------------------------------------------------------------------------------
      //
      // Agent clock gating
      //
      //------------------------------------------------------------------------------
      logic agent_clken;
      logic gated_agent_clk;
      logic jta_clkgate_ovrd_sync_agent;

      hqm_sbc_doublesync i_sync_jta_clkgate_ovrd_agent (
                    .d     ( jta_clkgate_ovrd_sync  ),
                    .clr_b ( agent_side_rst_b       ),
                    .clk   ( agent_clk      ),
                    .q     ( jta_clkgate_ovrd_sync_agent )
                   );

      // HSDES 1202934316 - Clock gating of the agent_clk was a bit too
      //  agressive. Added sbi_sbe_idle to allow agents that want to wake the
      //  ISM eairly to not get the synchronization flops clock gated.
      //  NOTE: It may be possible to remove agent_fifo_idle as the agent
      //        updates the FIFO the irdy signals would be sufficient plus
      //        egress_port_idle_ff contains agent_fifo_idle already but
      //        flopped.
      assign agent_clken = ~jta_clkgate_ovrd_sync_agent &
                           |{mmsg_comb_pcirdy, sbi_sbe_mmsg_npirdy, ~agent_fifo_idle, ~egress_port_idle_ff, ~sbi_sbe_idle, ~agent_port_idle, usyncselect_int,ext_parity_err_detected};

      hqm_sbc_clock_gate agent_clkgate  (
                           .en    ( agent_clken     ),
                           .te    ( fscan_clkungate ),
                           .clk   ( agent_clk       ),
                           .enclk ( gated_agent_clk )
                           );


      logic ingress_enpstall;
      logic ififo_parity_err_out;

      always_comb
        ingress_enpstall = cfence | (~&sbi_sbe_tmsg_npfree);

      hqm_sbcasyncfifo #(
                     .ASYNCQDEPTH    ( ASYNCIQDEPTH                  ),
                     .SB_PARITY_REQUIRED ( 0                         ),
                     .MAXPLDBIT      ( INTERNALPLDBIT                ),
                     .INGSYNCROUTER  (  0                            ),
                     .EGRSYNCROUTER  (  0                            ),
                     .LATCHQUEUES    ( LATCHQUEUES                   ),
                     .RELATIVE_PLACEMENT_EN ( RELATIVE_PLACEMENT_EN  ),
                     .USYNC_ENABLE   ( USYNC_ENABLE                  ),
                     .USYNC_ING_DELAY( SIDE_USYNC_DELAY              ),
                     .USYNC_EGR_DELAY( AGENT_USYNC_DELAY             )
                     ) sbcasyncingress (
      .ing_side_clk           ( gated_side_clk                ),
      .ing_side_rst_b         ( side_rst_b                    ),
      .cfg_parityckdef        ( fdfx_sbparity_def             ),
      .usync_ing              ( side_usync                    ),
      .port_idle              ( sb_port_idle                  ),
      .pcirdy                 ( sb_pcirdy                     ),
      .npirdy                 ( sb_npirdy                     ),
      .npfence                ( sb_npfence                    ),
      .pceom                  ( sb_pceom                      ),
      .pcparity               ( sb_pcparity                   ),
      .pcdata                 ( sb_pcdata                     ),
      .npeom                  ( sb_npeom                      ),
      .npparity               ( sb_npparity                   ),
      .npdata                 ( sb_npdata                     ),
      .pctrdy                 ( sb_pctrdy                     ),
      .nptrdy                 ( sb_nptrdy                     ),
      .npstall                (                               ), // lintra s-0214
      .fifo_idle              ( sb_fifo_idle                  ),
      .egress_req_pending     (                               ), // lintra s-0214
      .port_idle_ff           ( ingress_port_idle_ff          ), // lintra s-0214
      .egr_side_clk           ( agent_clk                     ),
      .gated_egr_side_clk     ( gated_agent_clk               ),
      .egr_side_rst_b         ( agent_side_rst_b              ),
      .usync_egr              ( agent_usync                   ),
      .enpstall               ( ingress_enpstall              ),
      .epctrdy                ( agent_pctrdy                  ),
      .enptrdy                ( agent_nptrdy                  ),
      .epcirdy                ( agent_pcirdy                  ),
      .enpirdy                ( agent_npirdy                  ),
      .eom                    ( agent_npeom                   ),
      .parity                 ( agent_npparity                ),
      .data                   ( agent_npdata                  ),
      .opceom                 ( agent_pceom                   ),
      .opcdata                ( agent_pcdata                  ),
      .opcparity              ( agent_pcparity                ),
      .parity_err_out         ( ififo_parity_err_out          ),
      .agent_idle             ( agent_port_idle               ),
      .idle_count             (                               ), // lintra s-0214
      .dt_latchopen           ( fscan_latchopen               ),
      .dt_latchclosed_b       ( fscan_latchclosed_b           ),
      .dbgbus_in              ( visa_fifo_dbgbus_sb[15:0]     ),
      .dbgbus_out             ( visa_fifo_dbgbus_ag[15:0]     ),
      .usyncselect            ( usyncselect_int               )
    );

      hqm_sbcasyncfifo #(
                     .ASYNCQDEPTH    ( ASYNCEQDEPTH                  ),
                     .SB_PARITY_REQUIRED    ( 0                      ),
                     .MAXPLDBIT      ( INTERNALPLDBIT                ),
                     .INGSYNCROUTER  (  0                            ),
                     .EGRSYNCROUTER  (  0                            ),
                     .LATCHQUEUES    ( LATCHQUEUES                   ),
                     .RELATIVE_PLACEMENT_EN ( RELATIVE_PLACEMENT_EN  ),
                     .USYNC_ENABLE   ( USYNC_ENABLE                  ),
                     .USYNC_ING_DELAY( AGENT_USYNC_DELAY             ),
                     .USYNC_EGR_DELAY( SIDE_USYNC_DELAY              )
                     ) sbcasyncegress (
      .ing_side_clk           ( gated_agent_clk               ),
      .ing_side_rst_b         ( agent_side_rst_b              ),
      .cfg_parityckdef        ( '0                            ),
      .usync_ing              ( agent_usync                   ),
      .port_idle              ( agent_agent_idle              ),
      .pcirdy                 ( agent_epcirdy                 ),
      .npirdy                 ( agent_enpirdy                 ),
      .npfence                ( agent_npfence                 ),
      .pceom                  ( agent_eom                     ),
      .pcparity               ( agent_parity                  ),
      .pcdata                 ( agent_data                    ),
      .npeom                  ( agent_eom                     ),
      .npparity               ( agent_parity                  ),
      .npdata                 ( agent_data                    ),
      .pctrdy                 ( agent_epctrdy                 ),
      .nptrdy                 ( agent_enptrdy                 ),
      .npstall                ( agent_enpstall                ),
      .fifo_idle              ( agent_fifo_idle               ),
      .egress_req_pending     (                               ), // lintra s-0214
      .port_idle_ff           ( egress_port_idle_ff           ),
      .egr_side_clk           ( side_clk_int                  ),
      .gated_egr_side_clk     ( gated_side_clk                ),
      .egr_side_rst_b         ( side_rst_b                    ),
      .usync_egr              ( side_usync                    ),
      .enpstall               ( sb_enpstall                   ),
      .epctrdy                ( sb_epctrdy                    ),
      .enptrdy                ( sb_enptrdy                    ),
      .epcirdy                ( sb_epcirdy                    ),
      .enpirdy                ( sb_enpirdy                    ),
      .eom                    ( sb_eom                        ),
      .data                   ( sb_data                       ),
      .parity                 ( sb_parity                     ),
      .opceom                 (                               ), // lintra s-0214
      .opcdata                (                               ), // lintra s-0214
      .opcparity              (                               ), // lintra s-0214
      .parity_err_out         (                               ), // lintra s-0214 used only on ififo
      .agent_idle             ( sb_eagent_idle                ),
      .idle_count             ( idle_count                    ),
      .dt_latchopen           ( fscan_latchopen               ),
      .dt_latchclosed_b       ( fscan_latchclosed_b           ),
      .dbgbus_in              ( visa_fifo_dbgbus_ag[31:16]    ),
      .dbgbus_out             ( visa_fifo_dbgbus_sb[31:16]    ),
      .usyncselect            ( usyncselect_int               )
                                             );

      always_comb
        begin
          agent_npfence = '0;
          sb_agent_idle = sb_eagent_idle;// & sb_fifo_idle;
        end

       logic     agent_fifo_idle_ff;

       always_ff @(posedge agent_clk or negedge agent_side_rst_b)
          if (~agent_side_rst_b) // lintra s-70023
            begin
              agent_fifo_idle_ff <= '0;
            end
          else
            begin
              agent_fifo_idle_ff <= agent_fifo_idle;
            end
        always_comb agent_fifo_idleff = agent_fifo_idle & agent_fifo_idle_ff;

// ing_async fifo's output is on agent clock. sync it to be on side clock to or it with final parity error out
        hqm_sbc_doublesync i_sync_fifo_err_out (
                                      .d     ( ififo_parity_err_out ),
                                      .clr_b ( side_rst_b           ),
                                      .clk   ( gated_side_clk       ),
                                      .q     ( ififo_err_out_sync   )
                                      );
    end

  else

    begin : gen_sync_blk2

      always_comb
        begin
          ingress_port_idle_ff = '1;
          egress_port_idle_ff  = '1;
          sb_eagent_idle       = '1;
          sb_fifo_idle         = '1;
          agent_fifo_idleff    = '1;
          idle_count           = '1;
          sb_agent_idle        = agent_agent_idle;
// just having idle_to_ep causes last Ur completion to be stuck in tmsg when there is a parity err
// originally it was maxidlecnt and it was added to prevent put exactly when ism moves from active to idlereq
// check maxidlecnt only only there is no parity error
          sb_enpirdy           = agent_enpirdy & (side_ism_agent == ISM_AGENT_ACTIVE) & ~(maxidlecnt & ~sbe_sbi_parity_err_out_side);
          sb_epcirdy           = agent_epcirdy & (side_ism_agent == ISM_AGENT_ACTIVE) & ~(maxidlecnt & ~sbe_sbi_parity_err_out_side);
          sb_eom               = agent_eom;
          sb_data              = agent_data;
          sb_parity            = agent_parity;

          agent_fifo_idle = '1;
          agent_port_idle = sb_port_idle;
          agent_enpstall  = sb_enpstall;
          agent_epctrdy   = sb_epctrdy;
          agent_enptrdy   = sb_enptrdy;

          sb_pctrdy       = agent_pctrdy;
          sb_nptrdy       = agent_nptrdy;

          agent_pcirdy    = sb_pcirdy;
          agent_pceom     = sb_pceom;
          agent_pcparity  = sb_pcparity;
          agent_pcdata    = sb_pcdata;
          agent_npirdy    = sb_npirdy;
          agent_npfence   = sb_npfence;
          agent_npeom     = sb_npeom;
          agent_npparity  = sb_npparity;
          agent_npdata    = sb_npdata;

          ififo_err_out_sync = '0;

          visa_fifo_dbgbus_sb = '0;
          visa_fifo_dbgbus_ag = '0;
        end

      end
endgenerate

//////////////////////////////////////////////////////////
// Message in progress generation for idle count equations
///////////////////////////////////////////////////////////

generate
  if (ASYNCENDPT==1)
    begin : gen_async_mip_blk
        always_ff @(posedge gated_side_clk or negedge side_rst_b)
            if (~side_rst_b)
              begin
                pcmsgipb  <= '1;
                npmsgipb  <= '1;
              end
            else
             begin
             if (sb_epcirdy)
              begin
                 pcmsgipb <= sb_eom;
              end
             if (sb_enpirdy)
              begin
                 npmsgipb <= sb_eom;
              end
            end
    end

  else

    begin : gen_sync_mip_blk
        logic     pcmsgipb_ff;
        logic     npmsgipb_ff;

        // Message in progress generation for idle count equations
        always_ff @(posedge gated_side_clk or negedge side_rst_b)
            if (~side_rst_b)
              begin
                pcmsgipb_ff  <= '1;
              end
            else
             if (mpcput)
               begin
                pcmsgipb_ff <= meom;
              end
        always_comb pcmsgipb = pcmsgipb_ff | (meom & mpcput);

         always_ff @(posedge gated_side_clk or negedge side_rst_b)
            if (~side_rst_b)
              begin
                npmsgipb_ff  <= '1;
              end
            else
             if (mnpput)
               begin
                npmsgipb_ff <= meom;
              end
         always_comb npmsgipb = npmsgipb_ff | (meom & mnpput);

    end
endgenerate

//------------------------------------------------------------------------------
//
// Target Interface Block (sbetrgt)
//
//------------------------------------------------------------------------------
logic mmsg_lcl_pcirdy_tmsg, mmsg_lcl_pceom_tmsg, mmsg_lcl_pcparity_tmsg, agent_epctrdy_tmsg;
logic [INTERNALPLDBIT:0]    mmsg_lcl_pcpayload_tmsg;

  hqm_sbetrgt #(
            .INTERNALPLDBIT         ( INTERNALPLDBIT                ),
            .MAXPCTRGT              ( MAXPCTRGT                     ),
            .MAXNPTRGT              ( MAXNPTRGT                     ),
            .RX_EXT_HEADER_SUPPORT  ( RX_EXT_HEADER_SUPPORT         ),
            .TX_EXT_HEADER_SUPPORT  ( TX_EXT_HEADER_SUPPORT         ),
            .NUM_TX_EXT_HEADERS     ( NUM_TX_EXT_HEADERS            ),
// PCR 12042104 - Unique Extended Headers SAIRS Parameter - START
            .UNIQUE_EXT_HEADERS     ( UNIQUE_EXT_HEADERS            ),
            .RSWIDTH                ( RSWIDTH                       ),
	  //  .NUM_REPEATER_FLOPS      (NUM_REPEATER_FLOPS),
            .SAIWIDTH               ( SAIWIDTH                      ),
			.CLAIM_DELAY			( CLAIM_DELAY					),
            .SB_PARITY_REQUIRED     ( SB_PARITY_REQUIRED            ),
            .GLOBAL_EP              ( GLOBAL_EP                     ),
            .GLOBAL_EP_IS_STRAP     ( GLOBAL_EP_IS_STRAP            )
// PCR 12042104 - Unique Extended Headers SAIRS Parameter - FINISH
            ) sbetrgt(
  .side_clk               ( agent_side_clk                ),
  .side_rst_b             ( agent_side_rst_b              ),
  .idle_trgt              ( idle_trgt                     ),

  .sbe_sbi_tmsg_npeom     ( sbe_sbi_tmsg_npeom            ), // lintra s-70036 s-0527 "NP EOM passed into target block"
  .sbe_sbi_tmsg_npmsgip   ( sbe_sbi_tmsg_npmsgip          ),
  .sbe_sbi_tmsg_nppayload ( sbe_sbi_tmsg_nppayload        ),
  .sbe_sbi_tmsg_npparity  ( sbe_sbi_tmsg_npparity         ),
  .sbe_sbi_tmsg_npput     ( sbe_sbi_tmsg_npput            ),
  .sbe_sbi_tmsg_npvalid   ( sbe_sbi_tmsg_npvalid          ),
  .sbi_sbe_tmsg_npfree    ( sbi_sbe_tmsg_npfree           ),
  .sbi_sbe_tmsg_npclaim   ( sbi_sbe_tmsg_npclaim          ),

  .sbe_sbi_tmsg_pccmpl    ( sbe_sbi_tmsg_pccmpl           ),
  .sbe_sbi_tmsg_pceom     ( sbe_sbi_tmsg_pceom            ), // lintra s-70036 s-0527 "PC EOM passed into target block"
  .sbe_sbi_tmsg_pcmsgip   ( sbe_sbi_tmsg_pcmsgip          ),
  .sbe_sbi_tmsg_pcpayload ( sbe_sbi_tmsg_pcpayload        ),
  .sbe_sbi_tmsg_pcparity  ( sbe_sbi_tmsg_pcparity         ),
  .sbe_sbi_tmsg_pcput     ( sbe_sbi_tmsg_pcput            ),
  .sbe_sbi_tmsg_pcvalid   ( sbe_sbi_tmsg_pcvalid          ),
  .sbi_sbe_tmsg_pcfree    ( sbi_sbe_tmsg_pcfree           ),
  .all_ext_parity_err_det ( ext_parity_err_det            ),

  .cfence                 ( cfence                        ),

  .npdata                 ( agent_npdata                  ),
  .npeom                  ( agent_npeom                   ),
  .npparity               ( agent_npparity                ),
  .npfence                ( agent_npfence                 ),
  .npirdy                 ( agent_npirdy                  ),
  .nptrdy                 ( agent_nptrdy                  ),

  .pcdata                 ( agent_pcdata                  ),
  .pcparity               ( agent_pcparity                ),
  .pceom                  ( agent_pceom                   ),
  .pcirdy                 ( agent_pcirdy                  ),
  .pctrdy                 ( agent_pctrdy                  ),

  .mmsg_pcsel             ( mmsg_pcsel[INTMAXPCMSTR]      ),
  .mmsg_pctrdy            ( agent_epctrdy_tmsg            ),
  .mmsg_pcirdy            ( mmsg_lcl_pcirdy_tmsg          ),
  .mmsg_pceom             ( mmsg_lcl_pceom_tmsg           ),
  .mmsg_pcparity          ( mmsg_lcl_pcparity_tmsg        ),
  .mmsg_pcpayload         ( mmsg_lcl_pcpayload_tmsg       ),
  .npdest_mstr            ( npdest_mstr                   ),
  .npsrc_mstr             ( npsrc_mstr                    ),
  .nptag_mstr             ( nptag_mstr                    ),
  .global_ep_strap        ( global_ep_strap               ),
  .hier_dest_tmsg         ( hier_dest_tmsg                ),
  .hier_src_tmsg          ( hier_src_tmsg                 ),
  .tx_ext_headers         ( tx_ext_headers                ),
// PCR 12042104 - Unique Extended Headers SAIRS Inputs - START
  .ur_csairs_valid        ( ur_csairs_valid               ), // lintra s-70036 s-0527 "Indicates when the sairs inputs are valid and should be used"
  .ur_csai                ( ur_csai                       ), // lintra s-70036 s-0527 "SAI value for extended headers"
  .ur_crs                 ( ur_crs                        ), // lintra s-70036 s-0527 "RS value for extended headers"
  .ur_rx_sairs_valid      ( ur_rx_sairs_valid             ), // lintra s-70036 s-0527 "Indicates when the sairs inputs are valid and should be used"
  .ur_rx_sai              ( ur_rx_sai                     ), // lintra s-70036 s-0527 "SAI value for extended headers"
  .ur_rx_rs               ( ur_rx_rs                      ), // lintra s-70036 s-0527 "RS value for extended headers"
// PCR 12042104 - Unique Extended Headers SAIRS Inputs - FINISH
  .dbgbus                 ( visa_agnt_dbgbus[31:24]       )
);

////////////////////////////////////////////////////////////////
// Hier Bridge PCR to add hierarchical headers on completions //
////////////////////////////////////////////////////////////////
generate
    if (GLOBAL_EP_IS_STRAP==1) begin : gen_hier_strap
        logic                       mmsg_pcirdy_tmsg_pre;
        logic                       agent_epctrdy_tmsg_pre;
        logic                       mmsg_pceom_tmsg_pre;
        logic [INTERNALPLDBIT:0]    mmsg_pcpayload_tmsg_pre;
        logic                       mmsg_pcparity_tmsg_pre;
        hqm_sbehierinsert # (
            .INTERNALPLDBIT (   INTERNALPLDBIT              )
        ) sbehierinsert_tmsg  (
            .side_clk       ( agent_side_clk                ),
            .side_rst_b     ( agent_side_rst_b              ),
// TMSG completions input
            .in_pcsel       ( mmsg_pcsel[INTMAXPCMSTR]      ),
            .in_pctrdy      ( agent_epctrdy                 ),
            .in_pcirdy      ( mmsg_lcl_pcirdy_tmsg          ),
            .in_pceom       ( mmsg_lcl_pceom_tmsg           ),
            .in_pcpayload   ( mmsg_lcl_pcpayload_tmsg       ),
            .in_pcparity    ( mmsg_lcl_pcparity_tmsg        ),
// HIER inputs  : Note the swap in connections of src/dest
            .in_hier_dest   ( hier_src_tmsg                 ),
            .in_hier_src    ( hier_dest_tmsg                ),
// TMSG completion output  (after hdr addition)  
            .out_pcirdy     ( mmsg_pcirdy_tmsg_pre          ),
            .out_pctrdy     ( agent_epctrdy_tmsg_pre        ),
            .out_pceom      ( mmsg_pceom_tmsg_pre           ),
            .out_pcpayload  ( mmsg_pcpayload_tmsg_pre       ),
            .out_pcparity   ( mmsg_pcparity_tmsg_pre        )
           
        );
        always_comb begin
            mmsg_pcirdy_tmsg    = global_ep_strap ? mmsg_pcirdy_tmsg_pre    : mmsg_lcl_pcirdy_tmsg;
            mmsg_pceom_tmsg     = global_ep_strap ? mmsg_pceom_tmsg_pre     : mmsg_lcl_pceom_tmsg;
            mmsg_pcpayload_tmsg = global_ep_strap ? mmsg_pcpayload_tmsg_pre : mmsg_lcl_pcpayload_tmsg;
            mmsg_pcparity_tmsg  = global_ep_strap ? mmsg_pcparity_tmsg_pre  : mmsg_lcl_pcparity_tmsg;
            agent_epctrdy_tmsg  = global_ep_strap ? agent_epctrdy_tmsg_pre  : agent_epctrdy;
        end
    end
    else begin : gen_hier_nonstrap
        if (GLOBAL_EP == 1) begin: gen_hier_tmsg
            hqm_sbehierinsert # (
                .INTERNALPLDBIT (   INTERNALPLDBIT              )
            ) sbehierinsert_tmsg  (
                .side_clk       ( agent_side_clk                ),
                .side_rst_b     ( agent_side_rst_b              ),
// TMSG completions input
                .in_pcsel       ( mmsg_pcsel[INTMAXPCMSTR]      ),
                .in_pctrdy      ( agent_epctrdy                 ),
                .in_pcirdy      ( mmsg_lcl_pcirdy_tmsg          ),
                .in_pceom       ( mmsg_lcl_pceom_tmsg           ),
                .in_pcpayload   ( mmsg_lcl_pcpayload_tmsg       ),
                .in_pcparity    ( mmsg_lcl_pcparity_tmsg        ),
// HIER inputs  : Note the swap in connections of src/dest
                .in_hier_dest   ( hier_src_tmsg                 ),
                .in_hier_src    ( hier_dest_tmsg                ),
// TMSG completion output  (after hdr addition)
                .out_pcirdy     ( mmsg_pcirdy_tmsg              ),
                .out_pctrdy     ( agent_epctrdy_tmsg            ),
                .out_pceom      ( mmsg_pceom_tmsg               ),
                .out_pcpayload  ( mmsg_pcpayload_tmsg           ),
                .out_pcparity   ( mmsg_pcparity_tmsg            )
            );
        end
        else begin: gen_nohier_tmsg
            always_comb begin
                mmsg_pcirdy_tmsg    = mmsg_lcl_pcirdy_tmsg;
                mmsg_pceom_tmsg     = mmsg_lcl_pceom_tmsg;
                mmsg_pcpayload_tmsg = mmsg_lcl_pcpayload_tmsg;
                mmsg_pcparity_tmsg  = mmsg_lcl_pcparity_tmsg;
                agent_epctrdy_tmsg  = agent_epctrdy;
            end
        end
    end
endgenerate   

//------------------------------------------------------------------------------
//
// DO_SERR message Interface Block (sbedoserrmstr)
//
//------------------------------------------------------------------------------
generate
    if (SB_PARITY_REQUIRED) begin: gen_par_err_out
        logic parity_err_out_pre;
        always_comb parity_err_out_pre = (parity_err_out | ext_parity_err_detected_sync | ififo_err_out_sync) & ~fdfx_sbparity_def;
        always_ff @(posedge side_clk or negedge side_rst_b)
          if (~side_rst_b) 
              sbe_sbi_parity_err_out_side <= '0;
          else if (parity_err_out_pre ==1'b1)
              sbe_sbi_parity_err_out_side <= 1'b1;
   // cannot use unflopped version, because its an xor of combo logic, it ll be glitchy. Use flopped output to be sent out of EP
   // in async mode, double sync the final output to agent clock
        if (|ASYNCENDPT ==1) begin: gen_par_out_async
            hqm_sbc_doublesync i_parity_err_out_sync (
                .d     ( sbe_sbi_parity_err_out_side),
                .clr_b ( agent_side_rst_b   ),
                .clk   ( agent_side_clk     ),
                .q     ( sbe_sbi_parity_err_out)
            );
        end
        else begin : gen_par_out_sync
            always_comb sbe_sbi_parity_err_out = sbe_sbi_parity_err_out_side;
        end       
    end
        
    else begin : gen_no_par_err_out
        always_comb sbe_sbi_parity_err_out_side = '0; 
        always_comb sbe_sbi_parity_err_out = '0; 
    end
endgenerate

//when endpoint is in sync mode and parity is enabled, customer can tie
//agent_clk to 0 is supporing by following generate block. HSD 1607975673

logic agent_clk_mux; //lintra 70036

generate
    if (ASYNCENDPT ==1) begin: gen_agent_clk_async
        always_comb agent_clk_mux = agent_clk;
    end
    else begin : gen_agent_clk_sync
        always_comb agent_clk_mux = side_clk;
    end
endgenerate


generate
    if ((DO_SERR_MASTER ==1) && (SB_PARITY_REQUIRED == 1)) begin : gen_doserrmstr
	    logic                   mmsg_pcirdy_doserrmstr, mmsg_lcl_pcirdy_doserrmstr;
        logic                   mmsg_pceom_doserrmstr, mmsg_lcl_pceom_doserrmstr;
        logic                   mmsg_pcparity_doserrmstr, mmsg_lcl_pcparity_doserrmstr;
        logic[INTERNALPLDBIT:0] mmsg_pcpayload_doserrmstr, mmsg_lcl_pcpayload_doserrmstr;
        logic                   doserr;
        logic                   parity_err_out_sync;
        logic                   agent_epctrdy_doserrmstr;
// in async mode, double sync the final output to agent clock
        if (|ASYNCENDPT ==1) begin: gen_do_async
            hqm_sbc_doublesync i_parity_err_sync (
                .d     ( sbe_sbi_parity_err_out_side),
                .clr_b ( agent_side_rst_b   ),
                .clk   ( agent_side_clk     ),
                .q     ( parity_err_out_sync)
            );
        end
        else begin : gen_do_sync
            always_comb parity_err_out_sync = sbe_sbi_parity_err_out_side;
        end
    
        always_comb  doserr = parity_err_out_sync;

        hqm_sbedoserrmstr #(
	        .INTERNALPLDBIT         (   INTERNALPLDBIT          ),
            .TX_EXT_HEADER_SUPPORT  (   TX_EXT_HEADER_SUPPORT   ),
	        .SAIWIDTH               (   SAIWIDTH                ),
	        .RSWIDTH                (   RSWIDTH                 )
        ) sbedoserrmstr(
// the clocks in doserr should be similar to the one in trgtreg (syncmode = gated side clk, asyncmode = ungated agent clk, for asserting irdy).
// flag inside do_serr will have to use ungated agent_clk! - else it wont assert irdy (which is used to enable gated_agent_clk (used in asyncfifo in asyncmode)
    
// external_parity_err is used to request agent_clk if its not available.
// do_serr_irdy is also used to wake the fabric (side_clkreq_wake)

	        .ungated_agent_clk      (   agent_clk_mux                   ),
	        .agent_side_clk         (   agent_side_clk                  ),
		    .side_rst_b             (   agent_side_rst_b                ),
		    .do_serr_srcid_strap    (   do_serr_srcid_strap             ),
		    .do_serr_dstid_strap    (   do_serr_dstid_strap             ),
		    .do_serr_tag_strap      (   do_serr_tag_strap               ),
		    .do_serr_sairs_valid    (   do_serr_sairs_valid             ),
		    .do_serr_sai            (   do_serr_sai   		            ),
		    .do_serr_rs             (   do_serr_rs   		            ),
		    .mmsg_pctrdy            (   agent_epctrdy_doserrmstr        ),     
		    .mmsg_pcsel             (   mmsg_pcsel[INTMAXPCMSTR+DO_SERR_MASTER]),
		    .send_do_serr           (   doserr                          ),
            .mmsg_pcirdy            (   mmsg_lcl_pcirdy_doserrmstr      ),
            .mmsg_pceom             (   mmsg_lcl_pceom_doserrmstr       ),
	        .mmsg_pcpayload         (   mmsg_lcl_pcpayload_doserrmstr   ),
            .mmsg_pcparity          (   mmsg_lcl_pcparity_doserrmstr    )
	    );
        
        if (GLOBAL_EP_IS_STRAP == 1) begin : gen_hier_strap
            logic mmsg_pcirdy_doserrmstr_int, mmsg_pceom_doserrmstr_int, mmsg_pcparity_doserrmstr_int, agent_epctrdy_doserrmstr_int;
            logic [INTERNALPLDBIT:0] mmsg_pcpayload_doserrmstr_int;
            hqm_sbehierinsert # (
                .INTERNALPLDBIT (   INTERNALPLDBIT  )
            ) sbehierinsert_doserr(
                .side_clk       ( agent_side_clk                        ),
                .side_rst_b     ( agent_side_rst_b                      ),
// DO_SERR completions input
                .in_pcsel       ( mmsg_pcsel[INTMAXPCMSTR+DO_SERR_MASTER]),
                .in_pctrdy      ( agent_epctrdy                         ),
                .in_pcirdy      ( mmsg_lcl_pcirdy_doserrmstr            ),
                .in_pceom       ( mmsg_lcl_pceom_doserrmstr             ),
                .in_pcpayload   ( mmsg_lcl_pcpayload_doserrmstr         ),
                .in_pcparity    ( mmsg_lcl_pcparity_doserrmstr          ),
// HIER_HDR : Note that no swap for error message
                .in_hier_dest   ( do_serr_hier_dstid_strap              ),
                .in_hier_src    ( do_serr_hier_srcid_strap              ),
// DO_SERR completion output  (after hdr addition)
                .out_pcirdy     ( mmsg_pcirdy_doserrmstr_int            ),
                .out_pctrdy     ( agent_epctrdy_doserrmstr_int          ),
                .out_pceom      ( mmsg_pceom_doserrmstr_int             ),
                .out_pcpayload  ( mmsg_pcpayload_doserrmstr_int         ),
                .out_pcparity   ( mmsg_pcparity_doserrmstr_int          )
            );
            always_comb begin
                mmsg_pcirdy_doserrmstr      = global_ep_strap ? mmsg_pcirdy_doserrmstr_int    : mmsg_lcl_pcirdy_doserrmstr;
                mmsg_pceom_doserrmstr       = global_ep_strap ? mmsg_pceom_doserrmstr_int     : mmsg_lcl_pceom_doserrmstr;
                mmsg_pcpayload_doserrmstr   = global_ep_strap ? mmsg_pcpayload_doserrmstr_int : mmsg_lcl_pcpayload_doserrmstr;
                mmsg_pcparity_doserrmstr    = global_ep_strap ? mmsg_pcparity_doserrmstr_int  : mmsg_lcl_pcparity_doserrmstr;
                agent_epctrdy_doserrmstr    = global_ep_strap ? agent_epctrdy_doserrmstr_int  : agent_epctrdy;
            end
        end
        else begin : gen_hier_param
            if (GLOBAL_EP==1) begin : gen_hier_doserr
                hqm_sbehierinsert # (
                    .INTERNALPLDBIT (   INTERNALPLDBIT  )
                ) sbehierinsert_doserr(
                    .side_clk       ( agent_side_clk                        ),
                    .side_rst_b     ( agent_side_rst_b                      ),
// DO_SERR completions input
                    .in_pcsel       ( mmsg_pcsel[INTMAXPCMSTR+DO_SERR_MASTER]),
                    .in_pctrdy      ( agent_epctrdy                         ),
                    .in_pcirdy      ( mmsg_lcl_pcirdy_doserrmstr            ),
                    .in_pceom       ( mmsg_lcl_pceom_doserrmstr             ),
                    .in_pcpayload   ( mmsg_lcl_pcpayload_doserrmstr         ),
                    .in_pcparity    ( mmsg_lcl_pcparity_doserrmstr          ),
// HIER_HDR : Note that no swap for error message
                    .in_hier_dest   ( do_serr_hier_dstid_strap              ),
                    .in_hier_src    ( do_serr_hier_srcid_strap              ),
// DO_SERR completion output  (after hdr addition)
                    .out_pcirdy     ( mmsg_pcirdy_doserrmstr                ),
                    .out_pctrdy     ( agent_epctrdy_doserrmstr              ),
                    .out_pceom      ( mmsg_pceom_doserrmstr                 ),
                    .out_pcpayload  ( mmsg_pcpayload_doserrmstr             ),
                    .out_pcparity   ( mmsg_pcparity_doserrmstr              )
                );            
                end
            else begin: gen_nohier_doserr
                always_comb begin
                    mmsg_pcirdy_doserrmstr      = mmsg_lcl_pcirdy_doserrmstr;
                    mmsg_pceom_doserrmstr       = mmsg_lcl_pceom_doserrmstr;
                    mmsg_pcpayload_doserrmstr   = mmsg_lcl_pcpayload_doserrmstr;
                    mmsg_pcparity_doserrmstr    = mmsg_lcl_pcparity_doserrmstr;
                    agent_epctrdy_doserrmstr    = agent_epctrdy;
                end                
            end
        end //gen_hier_param
        always_comb begin
            mmsg_comb_pcirdy      =   {mmsg_pcirdy_doserrmstr,mmsg_pcirdy};
            mmsg_comb_npirdy      =   sbi_sbe_mmsg_npirdy;
            mmsg_comb_pceom       =   {mmsg_pceom_doserrmstr, mmsg_pceom};
            mmsg_comb_npeom       =   sbi_sbe_mmsg_npeom;
            mmsg_comb_pcparity    =   {mmsg_pcparity_doserrmstr, mmsg_pcparity};
            mmsg_comb_npparity    =   sbi_sbe_mmsg_npparity;
            mmsg_comb_pcpayload   =   {mmsg_pcpayload_doserrmstr, mmsg_pcpayload};
            mmsg_comb_nppayload   =   sbi_sbe_mmsg_nppayload;
        end
    end //end if generate
    else begin : gen_ndoserrmstr
        always_comb begin
            mmsg_comb_pcirdy      =   mmsg_pcirdy;
            mmsg_comb_npirdy      =   sbi_sbe_mmsg_npirdy;
            mmsg_comb_pceom       =   mmsg_pceom;
            mmsg_comb_npeom       =   sbi_sbe_mmsg_npeom;
            mmsg_comb_pcparity    =   mmsg_pcparity;
            mmsg_comb_npparity    =   sbi_sbe_mmsg_npparity;
            mmsg_comb_pcpayload   =   mmsg_pcpayload;
            mmsg_comb_nppayload   =   sbi_sbe_mmsg_nppayload;
        end 
    end //end else generate
endgenerate

//------------------------------------------------------------------------------
//
// Master Interface Block (sbemstr)
//
//------------------------------------------------------------------------------

hqm_sbemstr #(
  .INTERNALPLDBIT             ( INTERNALPLDBIT             ),
  .SB_PARITY_REQUIRED         ( SB_PARITY_REQUIRED         ),
  .MAXPCMSTR                  ( INTMAXPCMSTR+DO_SERR_MASTER),
  .MAXNPMSTR                  ( MAXNPMSTR                  ),
  .DISABLE_COMPLETION_FENCING ( DISABLE_COMPLETION_FENCING ),
  .GLOBAL_EP                  ( GLOBAL_EP                  ),
  .GLOBAL_EP_IS_STRAP         ( GLOBAL_EP_IS_STRAP         )
) sbemstr(
  .side_clk               ( agent_side_clk                ),
  .side_rst_b             ( agent_side_rst_b              ),
  .global_ep_strap        ( global_ep_strap               ),
  .idle_mstr              ( idle_mstr                     ),
  .sbi_sbe_mmsg_pcirdy    ( mmsg_comb_pcirdy            ),
  .sbi_sbe_mmsg_npirdy    ( mmsg_comb_npirdy            ),
  .sbi_sbe_mmsg_pceom     ( mmsg_comb_pceom             ),
  .sbi_sbe_mmsg_npeom     ( mmsg_comb_npeom             ),
  .sbi_sbe_mmsg_pcparity  ( mmsg_comb_pcparity          ),
  .sbi_sbe_mmsg_npparity  ( mmsg_comb_npparity          ),
  .sbi_sbe_mmsg_pcpayload ( mmsg_comb_pcpayload         ),
  .sbi_sbe_mmsg_nppayload ( mmsg_comb_nppayload         ),
  .sbe_sbi_mmsg_pcmsgip   ( sbe_sbi_mmsg_pcmsgip          ),
  .sbe_sbi_mmsg_npmsgip   ( sbe_sbi_mmsg_npmsgip          ),
  .sbe_sbi_mmsg_pcsel     (         mmsg_pcsel     		  ),
  .sbe_sbi_mmsg_npsel     ( sbe_sbi_mmsg_npsel            ),
  .sbe_sbi_tmsg_npput     ( sbe_sbi_tmsg_npput            ),
  .sbe_sbi_tmsg_npeom     ( sbe_sbi_tmsg_npeom            ),
  .sbe_sbi_tmsg_npmsgip   ( sbe_sbi_tmsg_npmsgip          ),
  .cfence                 ( cfence                        ),
  .npdest_mstr            ( npdest_mstr                   ),
  .npsrc_mstr             ( npsrc_mstr                    ),
  .nptag_mstr             ( nptag_mstr                    ),
  .enpstall               ( agent_enpstall                ),
  .epctrdy                ( agent_epctrdy                 ),
  .enptrdy                ( agent_enptrdy                 ),
  .epcirdy                ( agent_epcirdy                 ),
  .enpirdy                ( agent_enpirdy                 ),
  .eom                    ( agent_eom                     ),
  .parity                 ( agent_parity                  ),
  .data                   ( agent_data                    ),
  .dbgbus                 ( visa_agnt_dbgbus[23:0]        )
);
    

`ifndef INTEL_SVA_OFF
`ifndef IOSF_SB_ASSERT_OFF

// coverage off
// `ifdef INTEL_INST_ON // SynTranlateOff
 `ifdef INTEL_SIMONLY 

  generate
    genvar k;
    for (k=0; k <= INTMAXPCMSTR; k++)
      begin
         pc_handshake:
         assert property ( @(posedge agent_side_clk) disable iff (agent_side_rst_b !== 1'b1)
            ((mmsg_pcirdy[k] === 1) ##1 (mmsg_pcirdy[k] === 0)) |-> ($past(agent_epctrdy) & $past(mmsg_pcsel[k]) )  )
         else
            $display("%0t: %m: ERROR: irdy/trdy handshake violation: agent deasserted sbi_sbe_mmsg_pcirdy[%d] before endpoint asserted agent_epctrdy and sbi_sbe_mmsg_pcsel[%d].", $time, k, k);

         pc_data:
         assert property ( @(posedge agent_side_clk) disable iff (agent_side_rst_b !== 1'b1)
            ~$stable(mmsg_pcpayload[k]) |-> ( $rose(mmsg_pcirdy[k]) | ~mmsg_pcirdy[k] | ($past(agent_epctrdy) & $past(mmsg_pcsel[k])) ) )
         else
            $display("%0t: %m: ERROR: irdy/trdy handshake violation: agent changed sbi_sbe_mmsg_pcpayload[%d] after asserting sbi_sbe_mmsg_pcirdy[%d] but before endpoint asserted agent_epctrdy and sbe_sbi_mmsg_pcsel[%d].", $time, k, k, k);
      end
  endgenerate

  generate
    genvar j;
    for (j=0; j <= MAXNPMSTR; j++)
      begin
         np_handshake:
         assert property ( @(posedge agent_side_clk) disable iff (agent_side_rst_b !== 1'b1)
            ((sbi_sbe_mmsg_npirdy[j] === 1) ##1 (sbi_sbe_mmsg_npirdy[j] === 0)) |-> ( $past(agent_enptrdy) & $past(sbe_sbi_mmsg_npsel[j]) )  )
         else
            $display("%0t: %m: ERROR: irdy/trdy handshake violation: agent deasserted sbi_sbe_mmsg_npirdy[%d] before endpoint asserted agent_enptrdy and sbe_sbi_mmsg_npsel[%d].", $time, j, j);

         np_data:
         assert property ( @(posedge agent_side_clk) disable iff (agent_side_rst_b !== 1'b1)
            ~$stable(sbi_sbe_mmsg_nppayload[j*(INTERNALPLDBIT+1)+INTERNALPLDBIT:j*(INTERNALPLDBIT+1)]) |-> ( $rose(sbi_sbe_mmsg_npirdy[j]) | ~sbi_sbe_mmsg_npirdy[j] | ($past(agent_enptrdy) & $past(sbe_sbi_mmsg_npsel[j]) ) ) )
         else
            $display("%0t: %m: ERROR: irdy/trdy handshake violation: agent changed sbi_sbe_mmsg_nppayload[%d] after asserting sbi_sbe_mmsg_npirdy[j] but before endpoint asserted agent_enptrdy and sbe_sbi_mmsg_npsel[%d].", $time, j, j, j);

      end
  endgenerate

  pcvalid_violation:
  assert property ( @(posedge agent_side_clk) disable iff (agent_side_rst_b !== 1'b1)
                    $stable(sbe_sbi_tmsg_pcvalid) & sbe_sbi_tmsg_pcvalid |-> $stable(sbe_sbi_tmsg_pcpayload) | $past(sbe_sbi_tmsg_pcput) )
    else
      $display ("%0t: %m: ERROR: sbe_sbi_tmsg_pcpayload changed while sbe_sbi_tmsg_pcvalid was asserted.", $time);

  npvalid_violation:
  assert property ( @(posedge agent_side_clk) disable iff (agent_side_rst_b !== 1'b1)
                    $stable(sbe_sbi_tmsg_npvalid) & sbe_sbi_tmsg_npvalid |-> $stable(sbe_sbi_tmsg_nppayload) | $past(sbe_sbi_tmsg_npput) )
    else
      $display ("%0t: %m: ERROR: sbe_sbi_tmsg_nppayload changed while sbe_sbi_tmsg_npvalid was asserted.", $time);

generate
    if (CLAIM_DELAY >= 1) begin: gen_repeater_fencing_violation
  repeater_fencing_violation: 
  assert property ( @(posedge agent_side_rst_b)
            (DISABLE_COMPLETION_FENCING == 0))
    else  
     $error ("NP Completion Fencing must be enabled when repeaters are enabled (claim delay is non zero)");
    end
endgenerate

generate
    if (SB_PARITY_REQUIRED == 1) begin: gen_parity_assertions
    ext_parity_err_violation:
    assert property ( @(posedge agent_side_clk) disable iff (agent_side_rst_b !== 1'b1)
        (ext_parity_err_detected==1'b1) |=> $stable (ext_parity_err_detected==1'b1) )
    else
        $error ("External parity error input to EP cannot reset, once its set. Only way to reset is by resetting the EP");
// HSD: 1407947861        
//    fdfx_sbparity_def_violation:
//    assert property ( @(posedge agent_side_clk) disable iff (agent_side_rst_b !== 1'b1)
//    (sbe_sbi_parity_err_out == 1'b1) |=> $stable (fdfx_sbparity_def) )
//    else
//        $error ("DFX parity defeature input should not toggle after parity err out is sent out.");
    end
endgenerate

    cfg_idlecnt_violation:
    assert property ( @ (posedge agent_side_rst_b)
        (cgctrl_idlecnt != '0) )
    else
        $error ("CGCTRL_IDLECNT cannot be set to 0. Refer Integration guide on usage");

//    rx_ext_hdr_violation:
//    assert property ( @ (posedge agent_side_rst_b)
//        (RX_EXT_HEADER != '0 )
//    else
//        $error ("Agents must be able to handle extended headers since endpoint doesnt drop headers from fabric .Refer Integration guide on usage");

    exp_compl_cntr_violation:
    assert property ( @ (posedge agent_side_rst_b)
        ((ISM_COMPLETION_FENCING == 1) |-> (EXPECTED_COMPLETIONS_COUNTER == 1)) )
    else
        $error ("EXPECTED_COMPLETIONS_COUNTER should be same as ISM_COMPLETION_FENCING. Refer Integration guide on usage");

    hyst_cnt_violation:
    assert property ( @ (posedge agent_side_rst_b)
        (SIDE_CLKREQ_HYST_CNT != '0) )
    else
        $error ("SIDE_CLKREQ_HYST_CNT cannot be 0. Refer Integration guide on usage");

    global_ep_violation:
    assert property ( @ (posedge agent_side_rst_b)
        ((GLOBAL_EP_IS_STRAP == 1) |-> (GLOBAL_EP == 0)) or ((GLOBAL_EP == 1) |-> (GLOBAL_EP_IS_STRAP == 0)) )
    else
        $error ("GLOBAL EP can be set either through strap or through parameter. Not both");

     //assertion added for HSD 14012006477
    generate 
    genvar l;    
    for (l=0; l <= MAXNPMSTR; l++)
        begin
    mmsg_npclkreq_violation:  
    assert property ( @(posedge agent_side_clk) disable iff (agent_side_rst_b !== 1'b1)
        ((sbi_sbe_clkreq == 1) |-> ## [1:$]  (sbi_sbe_mmsg_npirdy[l] === 1) ) )  
    else
        $error ("sbi_sbe_clkreq should be held high before mastering  np messages and MUST be held high for at least one clock cycle");
        end
    endgenerate
    
    generate
    genvar m;
    for (m=0; m <= MAXPCMSTR; m++)
        begin
    mmsg_pcclkreq_violation:  
    assert property ( @(posedge agent_side_clk) disable iff (agent_side_rst_b !== 1'b1)
        ((sbi_sbe_clkreq == 1) |-> ## [1:$]  (sbi_sbe_mmsg_pcirdy[m] === 1) ) )  
    else
        $error ("sbi_sbe_clkreq should be held high before mastering  pc messages and MUST be held high for at least one clock cycle");
        end
    endgenerate

// coverage on
 `endif // SynTranlateOn

`endif
`endif

endmodule

// lintra pop
