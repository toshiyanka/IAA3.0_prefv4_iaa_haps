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
//  Module sbcingress : The ingress port for all of the sideband channel RTL
//                      collateral.  This block instantiates 2 sbcinqueue
//                      blocks which are the ingress queues for both traffic
//                      classes (posted/completion and non-posted).
//                      It also includes a simple fencing mechanism to ensure
//                      that non-posted messages do not pass posted/completion
//                      messages.
//
//------------------------------------------------------------------------------

// lintra push -60020, -80028, -68001, -60024b, -60024a, -70036_simple

module hqm_sbcingress
#(
  parameter NPQUEUEDEPTH                 =  3,
  parameter PCQUEUEDEPTH                 =  3,
  parameter EXTMAXPLDBIT                 =  7,
  parameter INTMAXPLDBIT                 = 31,
  parameter LATCHQUEUES                  =  0,
  parameter RELATIVE_PLACEMENT_EN        =  0, // RP methodology for efficient placement in RAMS  
  parameter ISM_IS_AGENT_STRAP           =  0, // strappable ism PCR
  parameter ISMISAGENT                   =  1, // SBC-PCN-001 - ECN 290 - Power Gating for agent ingress ports
  parameter ENDPOINTONLY                 =  0,
  parameter EXPECTED_COMPLETIONS_COUNTER =  0, // SBC-PCN-007 - Expected completion counter components installed when 1
  parameter RTR_SB_PARITY_REQUIRED       =  0, // needed to know if parity needs to generated for a router with mixed parity enabled ports
  parameter SB_PARITY_REQUIRED           =  0, // configure parity checks
  parameter STAP_FOR_MISR                =  0, // PCR-1201583099 - Add MISR support to SBR; components installed when 1
  parameter STAP_FOR_DFD                 =  0, //DFx Enhancements - components installed when 1
  parameter STAP_TDR_WIDTH               =  38, //width of STAP TDR bus
  parameter GNR_HIER_FABRIC              =  0,
  parameter GNR_GLOBAL_SEGMENT           =  0,
  parameter GNR_HIER_BRIDGE_EN           =  0,
  parameter GNR_16BIT_EP                 =  0,
  parameter GNR_8BIT_EP                  =  0,
  parameter GNR_RTR_SEGMENT_ID           = 8'd200,
  parameter HIER_BRIDGE                  =  0,
  parameter HIER_BRIDGE_STRAP            =  0, // Enable hier bridge select strap
  parameter GLOBAL_RTR                   =  0, // set to 1 for global routers
  parameter LOCAL2GLOBAL                 =  0, // set to 1 when the port is on global side of a local2global crossing
  parameter SRCID_CK_EN                  =  0  // Enable hier bridge select strap
)(
  input  logic                  side_clk,          // Clocks and reset signals
  input  logic                  ungated_side_clk,  // lintra s-0527, s-70036 "Clocks and reset signals"
  input  logic                  side_rst_b,
  input  logic                  ism_is_agent_sel,  // lintra s-0527, s-70036
  input  logic                  ism_active,
  output logic                  idle_ingress,
  input  logic                  credit_init,
  output logic                  credit_init_done,
  input  logic                  credit_reinit,
  output logic                  pwrgt_ingress,     // SBC-PCN-001 - ECN 290 - Ingress port advertises when ready to power gate.
  input  logic                  int_pok,           // Needed by the inqueue to know when to ignore credit conditions for idle
  output logic                  ingress_np_detect, // SBC-PCN-007 - Ingress port detected an NP message
  
  output logic                  tpccup,            // The sideband channel interface
  output logic                  tnpcup,
  input  logic                  tpcput,
  input  logic                  tnpput,
  input  logic                  nd_tpcput,         // Sideband Channel Interface - flopped version if PIPEINPS =1
  input  logic                  nd_tnpput,         // Sideband Channel Interface - flopped version if PIPEINPS =1
  input  logic                  teom,
  input  logic                  tparity,
  input  logic [EXTMAXPLDBIT:0] tpayload,

  input  logic                  pctrdy,            // The posted ingress queue
  output logic                  pcirdy,            // interface to the decoder and
  output logic [INTMAXPLDBIT:0] pcdata,            // target services and master
  output logic                  pceom,
  output logic                  pcparity,
  output logic                  pcdstvld,          // Posted dest port ID is valid

  input  logic                  nptrdy,            // The non-posted ingress queue
  output logic                  npirdy,            // interface to the decoder and
  output logic                  npfence,           // target services 
  output logic [INTMAXPLDBIT:0] npdata,
  output logic                  npeom,
  output logic                  npparity,
  output logic                  npdstvld,          // Non-posted dest port ID valid

  input  logic                  parity_err_in,
  output logic                  parity_err_out,
  output logic                  srcidck_err_out,
  input  logic                  cfg_parityckdef,   // parity defeature
  input  logic                  cfg_hierbridgeen,  // lintra s-0527, s-70036 Used only for some ports on MI configs
  input  logic                  cfg_srcidckdef,    // lintra s-0527, s-70036 Used only for some ports when SAI tunneling is enabled
  input  logic [255:0]          srcid_portlist,

  input  logic                  tdr_mbp_enable,    // lintra s-0527, s-70036 "Global MISR enable"
  input  logic                  tdr_ftap_tck,      // lintra s-0527, s-70036 "STAP clock"
  input  logic [STAP_TDR_WIDTH-1:0]           tdr_sbr_data,      // lintra s-0527, s-70036 "From STAP"
  output logic [STAP_TDR_WIDTH-1:0]           sbr_tdr_data,      // To STAP

  input  logic                  fscan_clkungate,      // lintra s-0527, s-70036 Used only when MISR is enabled
  input  logic                  fscan_clkungate_syn,  // lintra s-0527, s-70036 Used only when MISR is enabled
  input  logic                  fscan_byprst_b,       // lintra s-0527, s-70036 Used only when MISR is enabled
  input  logic                  fscan_rstbypen,       // lintra s-0527, s-70036 Used only when MISR is enabled
  input  logic                  fscan_shiften,        // lintra s-0527, s-70036 Used only when MISR is enabled

  input  logic                  dt_latchopen,
  input  logic                  dt_latchclosed_b,
  output logic           [23:0] dbgbus
 );

`include "hqm_sbcglobal_params.vm"
`include "hqm_sbcfunc.vm"

localparam             NP                  = 1;
localparam             PC                  = 0;
localparam [1:0][31:0] QUEUEDEPTH          = {NPQUEUEDEPTH, PCQUEUEDEPTH};
localparam      [31:0] PCQUEUEDEPTHBOUNDED = sbc_bound_value( PCQUEUEDEPTH, 1, SBCMAXQUEUEDEPTH );
localparam             FENCECNTRWIDTH      = (PCQUEUEDEPTHBOUNDED <= 7) ? 2 : sbc_indexed_value(PCQUEUEDEPTH);
localparam             DFX_ACCUM_SIZE      = 16;
localparam             MISR_CLR_OFFSET     = 16;
localparam             MISR_ENABLE_OFFSET  = 17;
localparam             MISR_FUNC_OV_OFFSET = 18;
localparam             TDR_SIZE            = 19;
localparam             TDR_PC_CTRL_MAX     = (TDR_SIZE*2)-1;
localparam             TDR_PC_CTRL_MIN     = DFX_ACCUM_SIZE+TDR_SIZE;
localparam             DFX_DIN_SIZE        = (INTMAXPLDBIT==7) ? 16 : INTMAXPLDBIT+1;
localparam             DFX_DIN_PAD_SIZE    = 8;

localparam HIER_BRIDGE_GEN = HIER_BRIDGE_STRAP==1 ? 1 : HIER_BRIDGE;

logic [1:0]                 idle_inqueue;
logic [1:0]                 outmsg_cup;
logic [1:0]                 parity_err_f;
logic [1:0]                 parity_err_nppc;
logic [1:0]                 srcidck_err_nppc;
logic [1:0]                 parity_err_hold; // lintra s-70036 "only PC bit is used for fencing NP"
logic [1:0]                 inmsg_put;
logic [1:0]                 nd_inmsg_put;
logic [1:0]                 msgip;
logic [1:0]                 trdy;
logic [1:0]                 irdy;
logic [1:0]                 dstvld;
logic [1:0]                 eom;
logic [1:0]                 parity_out;
logic [1:0][INTMAXPLDBIT:0] data;
logic [1:0]                 crdinitfc_done;
logic [1:0]                 raw_put;

logic                    crdinit_done;
logic                    crdinit_done_ff;

logic [FENCECNTRWIDTH:0] fencecntr;       // The non-posted fencing counter
logic [FENCECNTRWIDTH:0] pccntr;          // The number of posted messages in the posted
logic [FENCECNTRWIDTH:0] nxtpccntr;       // ingress queue.
logic                    pcplus1;         // Increment/decrement signals for the posted
logic                    pcminus1;        // message counter
logic                    pcmsgip;         // Posted/completion message in progress as viewed
                                          // at the input to the pc ingress queue
logic                    npmsgiphh;       // lintra s-70036 "used only in HIER HDR mode"
                                          // Non-posted message in progress as viewed
                                          // at the input to the np ingress queue
logic                    npmsgip;         // Non-posted message in progress as viewed
                                          // at the output of the np ingress queue
logic                    in_eom;
logic                    in_parity;
logic   [EXTMAXPLDBIT:0] in_payload;
logic         [1:0][7:0] dbg;

logic [1:0] func_valid_visa;

  // The ingress block is idle when both ingress queues are idle and there are
  // no messages in-progress
  always_comb idle_ingress = (&idle_inqueue) & ~pcmsgip & ~npmsgip;

// SBC-PCN-007 - Detect ingressing NP messages. - START
// Ingress NP Detect only detects when a non-posted messages first flit has been
// egressed from the ingress queue. This should avoid timing issues using pre-
// queue signals as input signals in the IOSF interface are not flopped.
generate
   if( |EXPECTED_COMPLETIONS_COUNTER ) begin: gen_ingress_np_detect
      always_comb ingress_np_detect = npirdy & nptrdy & ~npmsgip;
   end else begin: gen_no_ingress_np_detect
      always_comb ingress_np_detect = 1'b0;
   end
endgenerate
// SBC-PCN-007 - Detect ingressing NP messages. - FINISH

// Simple fencing logic to ensure that the non-posted messages do not pass
// posted messages and completions.
// The fence counter blocks the non-posted top-of-queue when the counter is
// non-zero.  The counter is loaded with the current number of posted messages
// in-progress in the posted queue when a new non-posted message reaches the
// top of the non-posted queue.  The fence counter then has to be decremented
// to zero before the non-posted message is allowed to proceed.
// The actually fencing of the npirdy occurs outside of the ingress port.  In
// the endpoint it occurs in the target (sbetrgt).  In the sync router, it
// occurs in the arbiter (sbcarbiter).  

// Nov11_2015: vnandaku added parity err to remove the fence on np, when
// there was a parity error on pc. this is needed to send out the np that came into EP
// on tpayload before the parity error (both input parity error and output from inqueu(parity_err_hold)
// parity_err_hold is driven to 0 for rtr anyway

//parity_err_in causes ordering issues where NP passes through posted and completion)
//always_comb npfence   = |fencecntr & ~(parity_err_hold[PC] | parity_err_in);

always_comb npfence   = |fencecntr;

// The posted message in-progress counter is incremented when the first byte
// of a message enters the posted queue and decremented when the last byte
// of a message leaves the posted queue.  If the maximum depth of the queues
// are 3 entries, then at most 4 posted messages could be in-progress in the 
// posted ingress queue.  This assumes that the sideband channel width is
// 4 bytes, so each queue entry contains a 4 byte simple message and the 4 byte
// output flop (accumulator) also contains a 4 byte simple message.  So, the
// fencing counters only need 3 bits to express a maximum count of 4.
always_comb pcplus1   = tpcput & ~pcmsgip & ~parity_err_in;
always_comb pcminus1  = pctrdy & pcirdy & pceom;

always_comb nxtpccntr = (pcplus1==pcminus1) ? pccntr : pcplus1 ? (pccntr + 1) : (pccntr - 1); // lintra s-2033

  
// Ingress flops: 8 total flops, 3 bit posted counter, 3 bit fencing counter
//                and 1 bit posted message in-progress.  One flop is
//                needed to determine when a new posted message enters the
//                posted ingress queue.  Another flop needed to calculated
//                when credit init is complete.
  always_ff @(posedge side_clk or negedge side_rst_b)
    if (~side_rst_b) begin // lintra s-70023
      pccntr          <= '0;
      fencecntr       <= '0;
      pcmsgip         <= '0;
      npmsgiphh       <= '0;
      npmsgip         <= '0;
      crdinit_done_ff <= '0;
    end else begin
      if (tpcput)          pcmsgip   <= ~teom;     
      if (tnpput)          npmsgiphh <= ~teom;     
      if (nptrdy & npirdy) npmsgip   <= ~npeom;
      
      pccntr <= nxtpccntr;

      // The fencing counter is loaded with the next value for the posted counter
      // when the current non-posted message finished and continues to load until
      // the start of the next non-posted message is ready.
      if ((~npirdy & ~npmsgip & ~npdstvld) | (nptrdy & npirdy & npeom))
        fencecntr <= nxtpccntr;
      
      // The counter is then decremented to zero, which then allows the next
      // non-posted message to ready (presented to the decoder)
      else if (npfence & pcminus1)
        fencecntr <= fencecntr - 1;
      // reset fencecntr when there is a parity err_in and there are no pending pc messages in flight)
      else if (parity_err_in & ~pcirdy)
        fencecntr <= '0;
      
      // create one cycle strobe for credit init fsm
      crdinit_done_ff <= crdinit_done;
    end

// SBC-PCN-001 - ECN 290 - Agent ports should indicate when all credits have been advertised to the
//                         fabric port. - START
generate
    if (|ISM_IS_AGENT_STRAP == 0) begin: gen_leg_pwrgt
        if( ISMISAGENT == 0 ) begin : gen_fabric_pwrgte // Fabric Port Logic
            always_comb pwrgt_ingress = 1'b1; // Always ready to power gate for fabric
        end else begin : gen_agent_pwrgte
            always_comb pwrgt_ingress = (&idle_inqueue);
        end
    end
    else begin : gen_strap_pwrgt
        logic pwrgt_ingress_agt, pwrgt_ingress_fab;
        always_comb pwrgt_ingress_agt = (&idle_inqueue);
        always_comb pwrgt_ingress_fab = 1'b1;
        always_comb pwrgt_ingress = ism_is_agent_sel ? pwrgt_ingress_agt : pwrgt_ingress_fab;
    end
endgenerate
// SBC-PCN-001 - ECN 290 - Agent ports should indicate when all credits have been advertised to the
//                         fabric port. - FINISH

always_comb tpccup           = outmsg_cup[PC];
always_comb tnpcup           = outmsg_cup[NP];
always_comb inmsg_put[NP]    = parity_err_in ? 1'b0 : tnpput;    
always_comb nd_inmsg_put[NP] = parity_err_in ? 1'b0 : nd_tnpput;
always_comb raw_put[NP]      = tnpput;
always_comb raw_put[PC]      = tpcput;
always_comb trdy[PC]         = pctrdy;
always_comb trdy[NP]         = nptrdy;
always_comb pcdstvld         = dstvld[PC];
always_comb pceom            = eom[PC];
always_comb pcdata           = data[PC];
always_comb pcparity         = parity_out[PC];
always_comb npirdy           = irdy[NP];
always_comb npdstvld         = dstvld[NP];
always_comb npeom            = eom[NP];
always_comb npdata           = data[NP];
always_comb npparity         = parity_out[NP];

   generate
      if ((HIER_BRIDGE_GEN == 1) || (GNR_HIER_FABRIC == 1) || (SRCID_CK_EN == 1)) begin : gen_hierb
         always_comb msgip[PC] = pcmsgip;
         always_comb msgip[NP] = npmsgiphh;
      end else begin : gen_hierb_bp
         always_comb msgip[PC] = 1'b0;
         always_comb msgip[NP] = 1'b0;
      end
   endgenerate

generate
    if (ENDPOINTONLY) begin : gen_forep
        always_comb begin
            inmsg_put[PC]   = parity_err_in ? 1'b0 : tpcput;
            nd_inmsg_put[PC]= parity_err_in ? 1'b0 : nd_tpcput;
            pcirdy          = parity_err_hold[PC] ? 1'b0 : irdy[PC];
        end
    end // EP
    else begin : gen_forrtr
        always_comb begin
            inmsg_put[PC]    = parity_err_in ? 1'b0 : tpcput;
            nd_inmsg_put[PC] = parity_err_in ? 1'b0 : nd_tpcput;
            pcirdy           = irdy[PC];
        end
    end
endgenerate

always_comb crdinit_done     = &crdinitfc_done;
always_comb credit_init_done = crdinit_done & ~crdinit_done_ff;

  generate
    if (LATCHQUEUES==1) 
      begin : gen_latch_queue2
        
        // Flop before the latched based ingress queues
        logic                   teom_ff;
        logic                   tparity_ff;
        logic [EXTMAXPLDBIT:0]  tpayload_ff;
        
        always_ff @(posedge side_clk or negedge side_rst_b)
          if (~side_rst_b)
            begin
              teom_ff     <= '0;
              tpayload_ff <= '0;
              tparity_ff  <= '0;
            end 
          else if (|inmsg_put)
            begin
              teom_ff     <= teom;
              tpayload_ff <= tpayload;
              tparity_ff  <= tparity;
            end

        always_comb in_eom     = teom_ff;
        always_comb in_payload = tpayload_ff;
        always_comb in_parity  = tparity_ff;
      end 
    else 
      begin : gen_flop_queue2
        always_comb in_eom     = teom;
        always_comb in_payload = tpayload;
        always_comb in_parity  = tparity;
      end 
  endgenerate

//-----------------------------------------------------------------------------
//
// Posted/Completion and Non-posted Ingress Queue Instantiation
// Posted/Completion = vector element 0
// Non-posted        = vector element 1
//   Internal widths are eom and payload[31:0]  (4 Bytes)
//   External widths can vary:
//      1 Byte  : eom and payload[ 7:0]
//      2 Bytes : eom and payload[15:0]
//      4 Bytes : eom and payload[31:0]
//   Ingress Queue Depth should be set to 3 to enable streaming, any more
//   would be wasted area.  Setting this to less that 3 would occur when
//   area is more important than bandwidth (performance).
//
//-----------------------------------------------------------------------------
  genvar i;
  generate
    for (i=0; i<=1; i++) //lintra s-60118
      begin: gen_queue
        hqm_sbcinqueue #( // lintra s-80018
                      .QUEUEDEPTH         (QUEUEDEPTH[i]     ),
                      .EXTMAXPLDBIT       (EXTMAXPLDBIT      ),
                      .INTMAXPLDBIT       (INTMAXPLDBIT      ),
                      .PCORNP             (i                 ),
                      .ENDPOINTONLY       (ENDPOINTONLY      ),
                      .RTR_SB_PARITY_REQUIRED (RTR_SB_PARITY_REQUIRED),
                      .SB_PARITY_REQUIRED (SB_PARITY_REQUIRED),
                      .LATCHQUEUES        (LATCHQUEUES       ),
                      .RELATIVE_PLACEMENT_EN ( RELATIVE_PLACEMENT_EN),
                      .GNR_HIER_FABRIC    ( GNR_HIER_FABRIC    ),
                      .GNR_GLOBAL_SEGMENT ( GNR_GLOBAL_SEGMENT ),
                      .GNR_HIER_BRIDGE_EN ( GNR_HIER_BRIDGE_EN ),
                      .GNR_16BIT_EP       ( GNR_16BIT_EP       ),
                      .GNR_8BIT_EP        ( GNR_8BIT_EP        ),
                      .GNR_RTR_SEGMENT_ID ( GNR_RTR_SEGMENT_ID ),
                      .HIER_BRIDGE        (HIER_BRIDGE       ),
                      .HIER_BRIDGE_STRAP  (HIER_BRIDGE_STRAP ),
                      .GLOBAL_RTR         (GLOBAL_RTR        ),
                      .LOCAL2GLOBAL       (LOCAL2GLOBAL      ),
                      .SRCID_CK_EN        (SRCID_CK_EN       ))
        sbcinqueue (
                    .side_clk           (side_clk          ), // Clocks and reset signals
                    .side_rst_b         (side_rst_b        ),
                    .ism_active         (ism_active        ),
                    .idle_inqueue       (idle_inqueue[i]   ),
                    .credit_reinit      (credit_reinit     ),				     
                    .crdinit            (credit_init       ),
                    .crdinitfc_done     (crdinitfc_done[i] ),
                    .int_pok            (int_pok           ), // Needed for ignoring credits for idle conditions
                    
                    .top_inmsg_put      (inmsg_put[i]      ), // Sideband channel interface
                    .nd_inmsg_put       (nd_inmsg_put[i]   ), // Sideband channel interface
                    .raw_put            (raw_put[i]        ), // put not masked by parity error
                    .msgip              (msgip[i]          ),
                    .teom               (in_eom            ),
                    .tpayload           (in_payload        ),
                    .tparity            (in_parity         ),
                    .outmsg_cup         (outmsg_cup[i]     ),
                    
                    .trdy               (trdy[i]           ), // Interface to blocks within the
                    .irdy               (irdy[i]           ), // endpoint: decoder, fencing logic,
                    .dstvld             (dstvld[i]         ), // target services and master
                    .eom                (eom[i]            ), // completions.  The dstvalid output
                    .parity_out         (parity_out[i]     ), // completions.  The dstvalid output
                    .data               (data[i]           ), // is not used in the endpoint, but it
                    // is used in the router. 

                    .cfg_parityckdef    ( cfg_parityckdef  ),
                    .cfg_srcidckdef     ( cfg_srcidckdef   ),
                    .srcid_portlist     ( srcid_portlist   ),
                    .cfg_hierbridgeen   ( cfg_hierbridgeen ),
                    .parity_err_in      ( parity_err_in    ),
                    .parity_err_out     ( parity_err_nppc[i]),
                    .srcidck_err_out    ( srcidck_err_nppc[i]),
                    .dt_latchopen       ( dt_latchopen     ),
                    .dt_latchclosed_b   ( dt_latchclosed_b ),
                    .dbgbus             ( dbg[i]           )
                    );
      always_ff @ (posedge side_clk or negedge  side_rst_b) begin
            if (~side_rst_b)
                parity_err_f[i] <= '0;
            else begin
                if (parity_err_nppc[i] == 1'b1)
                    parity_err_f[i] <= 1'b1;
            end
       end
      end // block: gen_queue
endgenerate

generate
    if (ENDPOINTONLY) begin: gen_hld_ep
        always_comb parity_err_hold[PC] = parity_err_nppc[PC] | parity_err_f[PC];
        always_comb parity_err_hold[NP] = parity_err_nppc[NP] | parity_err_f[NP]; end
    else begin : gen_hld_rtr
        always_comb parity_err_hold = '0; end
endgenerate

always_comb parity_err_out = |(parity_err_nppc);
always_comb srcidck_err_out = |srcidck_err_nppc;

  genvar j, k;
  generate
    if (STAP_FOR_MISR==1) begin : gen_misr_inst

       logic [1:0] misr_clr, misr_clr_b, misr_clr_dsync, scan_misr_clr_b;
       logic [1:0] misr_enable, misr_enable_dsync;
       logic [1:0] misr_func_ov, misr_func_ov_dsync;
       logic [1:0] func_valid_visa_o;
       logic [1:0] misr_dvalid;
       logic [1:0][DFX_DIN_SIZE-1:0] misr_accum_i;
       logic [1:0][DFX_ACCUM_SIZE-1:0] misr_accum_o;
       logic [1:0][DFX_ACCUM_SIZE-1:0] misr_accum_o_dsync;
// HSD: 1409699193 for pipelining Dfx_accum inputs       
       logic [1:0][DFX_DIN_SIZE-1:0] misr_accum_i_f;
       logic [1:0] misr_dvalid_f;
       logic [1:0] pre_comp_enable;
       logic [1:0] delayed_clr, delayed_clr_pulse, accum_clear_b;



       always_comb misr_clr    [NP] = tdr_sbr_data[MISR_CLR_OFFSET];
       always_comb misr_enable [NP] = tdr_sbr_data[MISR_ENABLE_OFFSET];
       always_comb misr_func_ov[NP] = tdr_sbr_data[MISR_FUNC_OV_OFFSET];
       always_comb sbr_tdr_data[DFX_ACCUM_SIZE-1:0] = misr_accum_o_dsync[NP];
       always_comb sbr_tdr_data[TDR_SIZE-1:DFX_ACCUM_SIZE] = tdr_sbr_data[TDR_SIZE-1:DFX_ACCUM_SIZE];
       always_comb func_valid_visa[0] = func_valid_visa_o[NP];

       always_comb misr_clr    [PC] = tdr_sbr_data[MISR_CLR_OFFSET+TDR_SIZE];
       always_comb misr_enable [PC] = tdr_sbr_data[MISR_ENABLE_OFFSET+TDR_SIZE];
       always_comb misr_func_ov[PC] = tdr_sbr_data[MISR_FUNC_OV_OFFSET+TDR_SIZE];
       always_comb sbr_tdr_data[DFX_ACCUM_SIZE+TDR_SIZE-1:0+TDR_SIZE] = misr_accum_o_dsync[PC];
       always_comb sbr_tdr_data[TDR_PC_CTRL_MAX:TDR_PC_CTRL_MIN] = tdr_sbr_data[TDR_PC_CTRL_MAX:TDR_PC_CTRL_MIN];
       always_comb func_valid_visa[1] = func_valid_visa_o[PC];

       if (INTMAXPLDBIT==7) // lintra s-60088
          begin : gen_misr_din_ext
             always_comb misr_accum_i[NP] = {{DFX_DIN_PAD_SIZE{1'b0}},data[NP]};
             always_comb misr_accum_i[PC] = {{DFX_DIN_PAD_SIZE{1'b0}},data[PC]};
          end
       else
          begin : gen_misr_din
             always_comb misr_accum_i[NP] = data[NP];
             always_comb misr_accum_i[PC] = data[PC];
          end

       for (j=0; j<=1; j++) //lintra s-60118
           begin : gen_dfxaccum

                hqm_sbc_doublesync i_sbc_doublesync_misr_clr ( // lintra s-68018, s-80018
                   .d     ( misr_clr[j]       ),
                   .clr_b ( side_rst_b        ),
                   .clk   ( ungated_side_clk  ),
                   .q     ( misr_clr_dsync[j] )
                );
 
                hqm_sbc_doublesync i_sbc_doublesync_misr_enable ( // lintra s-68018, s-80018
                   .d     ( misr_enable[j]       ),
                   .clr_b ( side_rst_b           ),
                   .clk   ( ungated_side_clk     ),
                   .q     ( misr_enable_dsync[j] )
                );
 
                hqm_sbc_doublesync i_sbc_doublesync_misr_func_ov ( // lintra s-68018, s-80018
                   .d     ( misr_func_ov[j]       ),
                   .clr_b ( side_rst_b            ),
                   .clk   ( ungated_side_clk      ),
                   .q     ( misr_func_ov_dsync[j] )
                );

                always_comb misr_dvalid[j] = trdy[j] & irdy[j];

// HSD 1409699193 for adding pipeline stage to dfx inputs
                always_ff @(posedge side_clk or negedge side_rst_b) begin
				    if (!side_rst_b)
				        delayed_clr[j] <= '0;
				    else
				        delayed_clr[j] <=  misr_clr_dsync[j];
				end
				
				always_comb begin
				    delayed_clr_pulse[j]= misr_clr_dsync[j] & ~delayed_clr[j];
				    accum_clear_b[j]    = ~delayed_clr_pulse[j];
				    pre_comp_enable[j]  = (tdr_mbp_enable | misr_enable_dsync[j]) & misr_dvalid[j];
				end
				      
				always_ff @(posedge side_clk or negedge side_rst_b) begin
				    if      (!side_rst_b)           misr_accum_i_f[j]  <= '0;
				    else if (!accum_clear_b[j])     misr_accum_i_f[j]  <= '0;
				    else if (pre_comp_enable[j])    misr_accum_i_f[j]  <= misr_accum_i[j] ;
			    end

				always_ff @(posedge side_clk or negedge side_rst_b) begin 
				    if      (!side_rst_b)           misr_dvalid_f[j]  <= '0;
				    else if (!accum_clear_b[j])     misr_dvalid_f[j]  <= '0;
				    else                            misr_dvalid_f[j]  <= misr_dvalid[j] ;
				end

// end changes for adding pipelining dfx inputs

                dfx_obs_inst #( // lintra s-80018
                              .DFX_OBS_INST_INPUT_DATA_SIZE (DFX_DIN_SIZE          ),
                              .DFX_OBS_INST_MISR_ACCUM_SIZE (DFX_ACCUM_SIZE        ))
                i_sbcdfxaccum (
                              .dfx_obs_inst_clk                 (side_clk              ),
                              .dfx_obs_inst_reset_b             (side_rst_b            ),
                              .dfx_obs_inst_clr                 (misr_clr_dsync[j]     ),
                              .dfx_obs_inst_enable              (misr_enable_dsync[j]  ),
                              .dfx_obs_inst_mbp_enable          (tdr_mbp_enable        ),
                              .dfx_obs_inst_valid               (misr_dvalid_f[j]        ),
                              .dfx_obs_inst_func_ov             (misr_func_ov_dsync[j] ),
                              .dfx_obs_inst_sig_type            ('0),
                              .dfx_obs_inst_fscan_clkungate     (fscan_clkungate),
                              .dfx_obs_inst_fscan_clkungate_syn (fscan_clkungate_syn),
                              .dfx_obs_inst_fscan_byprst_b      (fscan_byprst_b),
                              .dfx_obs_inst_fscan_rstbypen      (fscan_rstbypen),
                              .dfx_obs_inst_fscan_shiften       (fscan_shiften),
                              .dfx_obs_inst_misr_accum_frz      ('0),
                              .dfx_obs_inst_misr_accum_rst      ('0),
                              .dfx_obs_inst_instr_dbg_mode      ('0),
                              .dfx_obs_inst_dbg_valid_count     ('0),
                              .dfx_obs_inst_dbg_cycle_count     ('0),
                              .dfx_obs_inst_incr_value          ('0),
                              .dfx_obs_inst_event_count         (   ), // lintra s-0214
                              .dfx_obs_inst_data                (misr_accum_i_f[j]       ),
                              .dfx_obs_inst_func_valid_visa     (func_valid_visa_o[j]  ),
                              .dfx_obs_inst_misr_accum_o        (misr_accum_o[j]       )
                            );


                always_comb misr_clr_b[j] = ~misr_clr[j];

                hqm_sbc_ctech_scan_mux i_sbc_ctech_scan_mux ( // lintra s-80018
                   .d ( misr_clr_b[j]      ),
                   .si( fscan_byprst_b     ), 
                   .se( fscan_rstbypen     ),
                   .o ( scan_misr_clr_b[j] )
                );

                for (k=0; k<DFX_ACCUM_SIZE; k++) //lintra s-60118
                   begin: gen_accum_o_dsync
                     hqm_sbc_doublesync i_sbc_doublesync_misr_o ( // lintra s-68018, s-80018
                        .d     ( misr_accum_o[j][k]       ),
                        .clr_b ( scan_misr_clr_b[j]       ),
                        .clk   ( tdr_ftap_tck             ),
                        .q     ( misr_accum_o_dsync[j][k] )
                     );
                   end

           end // block: gen_dfxaccum

    end
    else begin : gen_no_dfxaccum
       always_comb sbr_tdr_data = {(TDR_PC_CTRL_MAX+1){1'b0}};
//       always_comb sbr_tdr_data[TDR_PC_CTRL_MAX:0] = {(TDR_PC_CTRL_MAX+1){1'b0}};
       always_comb func_valid_visa = '0;
    end   
  endgenerate




// Debug signals
  always_comb dbgbus = { func_valid_visa,
                         pcmsgip,
                         npmsgip,
                         |outmsg_cup,
                         fencecntr[2:0], // lintra s-60088 "Will never fall below 2"
                         dbg
                         };
  
endmodule

// lintra pop
