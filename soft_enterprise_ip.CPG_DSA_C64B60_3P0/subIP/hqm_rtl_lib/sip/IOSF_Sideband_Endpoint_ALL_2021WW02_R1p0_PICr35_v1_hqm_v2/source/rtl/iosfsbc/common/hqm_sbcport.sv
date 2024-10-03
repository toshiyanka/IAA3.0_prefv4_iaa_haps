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
//  Module sbcport : Used by all sideband AGENT components: endpoint and 
//                   synch/async routers.  It contains an ingress port,
//                   egress port and a clock gating ISM (fabric or agent).
//
//------------------------------------------------------------------------------


// lintra push -60020, -60026, -60088, -80018, -68001, -60024b, -60024a, -70036_simple

module hqm_sbcport
#(parameter EXTMAXPLDBIT  =  7, // Sideband Interface Payload Width
            INGMAXPLDBIT  = 31, // Ingress Internal Datapath Payload Width
            EGRMAXPLDBIT  = 31, // Egress Internal Datapath Payload Width
            CUP2PUT1CYC   =  1, // cup to put latency is 1 cycle (s/b 1 or 0)
            NPQUEUEDEPTH  =  3, // Sideband Interface Ingress Queue Depth, NP
            PCQUEUEDEPTH  =  3, // Sideband Interface Ingress Queue Depth, PC
            ISM_IS_AGENT_STRAP =  0, // Swap fabric and agent ISM states. 1= AGENT, 0 = FABRIC
            SBCISMISAGENT =  1, // Clocking gating ISM mode (1=AGENT / 0=Fabric)
            SYNCROUTER    =  0, // Sync router mode=1 / 0=endpoint/async router
            LATCHQUEUES   =  0, // Latch based queues=1 / 0=flop based queues,
            RELATIVE_PLACEMENT_EN = 0, // RP methodology for efficient placement in RAMS
            SKIP_ACTIVEREQ=  0, // set to 1 to skip ACTIVE_REQ, per IOSF 1.0 
            PIPEISMS      =  0, // set to 1 to pipeline fabric ism inputs
            PIPEINPS      =  0, // set to 1 to pipeline all put-cup-eom-payload inputs
            ENDPOINTONLY  =  0, // set to 1 to Endpoint only
            STAP_FOR_MISR =  0, // Integrate MISR logic
            STAP_FOR_DFD  =  0, // Integrate DFx sTAP logic
            STAP_FOR_DFD_DSYNC  =  1, // Instantiate doublesync synchronizers btwn side_clk and ftap_tck
            STAP_TDR_WIDTH    = 38, //width of TDR bus
            STAP_TDR_WIDTH_DFX = 91, //width of TDR DFX bus
            RTR_SB_PARITY_REQUIRED = 0, // Parity for the whole router overall
            SB_PARITY_REQUIRED = 0,  // configures the Endpoint to support parity handling
// SBC-PCN-007 - Insert completion counter parameters - START
            EXPECTED_COMPLETIONS_COUNTER = 0, // set to 1 if expected completion counters are needed
            ISM_COMPLETION_FENCING       = 0, // set to 1 if the ISM should stay ACTIVE with exp completions
// SBC-PCN-007 - Insert completion counter parameters - FINISH
            GNR_HIER_FABRIC              = 0, // GNR Hierarchical Fabric
            GNR_GLOBAL_SEGMENT           = 0,
            GNR_HIER_BRIDGE_EN           = 0,
            GNR_16BIT_EP                 = 0,
            GNR_8BIT_EP                  = 0,
            GNR_RTR_SEGMENT_ID           = 8'd200,
            HIER_BRIDGE                  = 0, // set to 1 to instantiate hierachical bridge logic
            HIER_BRIDGE_PID              = 8'd0, // PortID associated with the transparent bridge
            HIER_BRIDGE_STRAP            = 0, // Enable hier bridge select strap
            MIN_GLOBAL_PID               = 8'd254, // Min global PID for transparent bridge configs
            LOCAL2GLOBAL                 = 0, // set to 1 when the port is on global side of a local2global crossing
            SRCID_CK_EN                  = 0, // Enable SAI tunneling
            GLOBAL_RTR                   = 0, // set to 1 for global routers
            GLOBAL_EP                    = 0,  // EP in HIER mode            
            GLOBAL_EP_IS_STRAP           = 0,  // EP in HIER mode            
            EOM_PERF_OPT                 = 0,
            USE_PORT_DISABLE             = 0, // Expose a top-level port_disable input
            CG_DELAY                     = 0,
            CG_DELAY_STRAP_EN            = 0

)(

  // Clock/Reset Signals
  input  logic                  side_clk, 
  input  logic                  gated_side_clk, 
  input  logic                  side_rst_b,
                          
  //----------------------------------------------------------------------------
  //
  // ISM Signals
  //
  //----------------------------------------------------------------------------

  // ISM interface: endpoint/async router to sync router
  input  logic            [2:0] side_ism_in,   // Clock Gating ISM state input
  output logic            [2:0] side_ism_out,  // Clock Gating ISM state output
  input  logic                  side_ism_lock_b, // SBC-PCN-002 - Sideband ISM Lock for power gating flows
  input  logic                  side_clk_valid,// indicates clock is valid for ISM
  
  input  logic                  int_pok,       // power good
  input  logic                  port_disable,  // lintra s-0527, s-70036

  input logic                   agent_clkena,     // lintra s-0527, s-70036
  input logic                   cfg_clkgatedef,   // lintra s-0527, s-70036
  input logic                   jta_clkgate_ovrd, // lintra s-0527, s-70036
  // Fabric-Agent Port swap PCR
  input logic                   ism_is_agent_sel,

  
  // PMU Activity signals
  input  logic                  agent_idle,
  input  logic                  async_ififo_idle,
  input  logic                  idle_count, // lintra s-0527 "idle count input from base endpoint only"
  output logic                  idle_egress,
  output logic                  idle_comp,  // lintra s-70036 // SBC-PCN-001 - Completion message handler for cleaning the egress
  output logic                  port_idle,
  output logic                  ism_idle,
  output logic                  maxidlecnt, // lintra s-70036
  output logic                  ism_in_notidle, // lintra s-70036 //fabric ism in non idle flopped output
  output logic                  credit_reinit,
  output logic                  cg_inprogress,

  output logic                  port_pwrgt, // lintra s-70036 SBC-PCN-001 - ECN 290 - Port power gate ready
  output logic                  cg_en, // lintra s-70036 // SBC-PCN-004 - Partition Clock Gating Override

// SBC-PCN-007 - Insert completion counter outputs - START
   output logic                  ism_comp_exp,
// SBC-PCN-007 - Insert completion counter outputs - FINISH

  //----------------------------------------------------------------------------
  //
  // Ingress Signals
  //
  //----------------------------------------------------------------------------

  // Sideband Interface Signals
  input  logic                  global_ep_strap,
  input  logic [3:0]            cg_delay_width_strap,
  output logic                  tpccup,      
  output logic                  tnpcup,      
  input  logic                  tpcput,     
  input  logic                  tnpput,     
  input  logic                  teom,     
  input  logic [EXTMAXPLDBIT:0] tpayload,     
  input  logic                  tparity,     

  // Posted/Completion Ingress Queue Signals
  input  logic                  pctrdy,        // The posted ingress queue
  output logic                  pcirdy,        // interface to the decoder and
  output logic [INGMAXPLDBIT:0] pcdata,        // target services and master
  output logic                  pceom,         
  output logic                  pcparity,
  output logic                  pcdstvld,      // lintra s-70036 Posted dest port ID is valid
                                               
  // Non-posted Ingress Queue Signals          
  input  logic                  nptrdy,        // The non-posted ingress queue
  output logic                  npirdy,        // interface to the decoder and
  output logic                  npfence,       // target services 
  output logic [INGMAXPLDBIT:0] npdata,        
  output logic                  npeom,
  output logic                  npparity,
  output logic                  npdstvld,      // lintra s-70036 Non-posted dest port ID valid

  //----------------------------------------------------------------------------
  //
  // Egress Signals
  //
  //----------------------------------------------------------------------------

  // Sideband Interface Signals
  input  logic                  mpccup,     
  input  logic                  mnpcup,     
  output logic                  mpcput,      
  output logic                  mnpput,      
  output logic                  meom,      
  output logic [EXTMAXPLDBIT:0] mpayload,      
  output logic                  mparity,      

  // Egress Arbiter/Datapath Signals
  output logic                  enpstall, // lintra s-70036
  output logic                  epctrdy,
  output logic                  enptrdy,
  input  logic                  epcirdy,
  input  logic                  enpirdy,
  input  logic                  eom,
  input  logic                  parity,
  input  logic [EGRMAXPLDBIT:0] data,

  // parity handling
  input  logic                  ext_parity_err_detected, // lintra s-0527
  output logic                  parity_err_out,
  output logic                  srcidck_err_out,

  // STAP_FOR_MISR
  input  logic                  tdr_mbp_enable,
  input  logic                  tdr_ftap_tck,
  input  logic [STAP_TDR_WIDTH-1:0] tdr_sbr_data, // lintra s-70036
  output logic [STAP_TDR_WIDTH-1:0] sbr_tdr_data, 
  input  logic [STAP_TDR_WIDTH_DFX-1:0] tdr_sbr_data_dfx, // lintra s-70036, s-0527
  output logic [STAP_TDR_WIDTH_DFX-1:0] sbr_tdr_data_dfx, 

  // SAI tunneling SrcID check
  input  logic [255:0]          srcid_portlist,

  //----------------------------------------------------------------------------
  //
  // DFx Signals
  //
  //----------------------------------------------------------------------------
  input  logic     [7:0] cfg_idlecnt,            // Config
  input  logic           cfg_clkgaten,           // Config
  input  logic           cfg_parityckdef,        // lintra s-0527, s-70036
  input  logic           cfg_srcidckdef,         // lintra s-0527, s-70036
  input  logic           cfg_hierbridgeen,       // lintra s-0527, s-70036 Used only for some ports on MI configs
  input  logic     [7:0] cfg_hierbridgepid,      // lintra s-0527, s-70036 Used only for some ports on MI configs
  input  logic           force_idle,             //
  input  logic           force_notidle,          //
  input  logic           force_creditreq,
  input  logic           dt_latchopen,
  input  logic           dt_latchclosed_b,
  input  logic           fscan_clkungate, // lintra s-0527, s-70036 Used only for strappable port type
  input  logic           fscan_clkungate_misr, // lintra s-0527, s-70036 Used only when MISR is enabled
  input  logic           fscan_clkungate_syn,  // lintra s-0527, s-70036 Used only when MISR is enabled
  input  logic           fscan_byprst_b,       // lintra s-0527, s-70036 Used only when MISR is enabled
  input  logic           fscan_rstbypen,       // lintra s-0527, s-70036 Used only when MISR is enabled
  input  logic           fscan_shiften,        // lintra s-0527, s-70036 Used only when MISR is enabled
  output logic    [37:0] dbgbus
);

`include "hqm_sbcglobal_params.vm"

  localparam             NP                  = 1;
  localparam             PC                  = 0;
  localparam             PIPEALL             = ( (|PIPEISMS) || (|PIPEINPS) );

  logic                         idle_ingress;
  logic                         idle_egress_full; // HSD 4258336 - Created a full variant of the idle_egress signal
  logic                         idle;
  logic                         port_idle_full;   // HSD 4258336 - Created a full variant of the port_idle signal
  logic                         count_idle;
  logic                         credit_init;
  logic                         credit_init_done;
  logic                         ism_active;
  logic                         fabric_ism_active;
  logic                         fabric_ism_idlenaq;
  logic                         fabric_ism_creditreq; // lintra s-70036
  logic                         fabric_ism_creditinit; // SBC-PCN-001 - ECN 290 - Egress for copying the watermark count from the current count.
  logic                         agent_ism_creditreq; // lintra s-70036
  logic                         agent_ism_active;
  logic [5:0]                   gcgu_dbgbus; // lintra s-70036, s-70045
  logic [23:0]                  ingress_dbgbus;
  logic [5:0]                   egress_dbgbus;
  logic [2:0]                   in_side_ism;
  logic                         in_mpccup;
  logic                         in_mnpcup;
  logic                         in_tpcput;
  logic                         in_tnpput;
  logic                         in_teom;
  logic [EXTMAXPLDBIT:0]        in_tpayload;
  logic                         in_tparity;
  logic                         pwrgt_egress;     // SBC-PCN-001 - ECN 290 - Egress power gate readiness signal
  logic                         pwrgt_ingress;    // SBC-PCN-001 - ECN 290 - Ingress power gate readiness signal
  logic                         pwrgt_comp;       // SBC-PCN-001 - Completion message handler for cleaning the egress
  logic                         egress_enpstall;  // SBC-PCN-001 - Completion message handler for cleaning the egress
  logic                         egress_epctrdy;   // SBC-PCN-001 - Completion message handler for cleaning the egress
  logic                         egress_enptrdy;   // SBC-PCN-001 - Completion message handler for cleaning the egress
  logic                         egress_epcirdy;   // SBC-PCN-001 - Completion message handler for cleaning the egress
  logic                         egress_enpirdy;   // SBC-PCN-001 - Completion message handler for cleaning the egress
  logic                         ingress_pcirdy;   // SBC-PCN-001 - Completion message handler for cleaning the egress
  logic                         ingress_pcdstvld; // SBC-PCN-001 - Completion message handler for cleaning the egress
  logic                         ingress_pceom;    // SBC-PCN-001 - Completion message handler for cleaning the egress
  logic                         ingress_pcparity; // SBC-PCN-001 - Completion message handler for cleaning the egress
  logic [INGMAXPLDBIT:0]        ingress_pcdata;   // SBC-PCN-001 - Completion message handler for cleaning the egress
  logic                         ingress_pctrdy;   // SBC-PCN-001 - Completion message handler for cleaning the egress

// SBC-PCN-007 - Expected completions counter logic - START
   logic                         ingress_np_detect;
   logic                         egress_comp_detect;
// SBC-PCN-007 - Expected completions counter logic - FINISH
  
//  wire                          credit_reinit;

   logic parity_err_out_pre;
   logic parity_err_from_ingress; // lintra s-70036 used only in parity case
   logic parity_err_to_ingress;
   logic parity_err_in;

   logic idle_comp_cgreq;
   always_comb idle_comp = port_idle;

// SBC-PCN-001 - int_pok removed, should not claim idle falsely. Added
// completion module to idle to prevent clock gating.
  always_comb port_idle      = idle_ingress & idle_egress & idle_comp_cgreq;
// HSD 4258336 - Create new version of port idle to avoid turning on agent
//               clock, but hold on the side clock - START
// SBC-PCN-001 - int_pok removed, should not claim idle falsely.
  always_comb port_idle_full = idle_ingress & idle_egress_full;

  logic force_idle_ff, force_notidle_ff, force_creditreq_ff;
  logic nd_tpcput, nd_tnpput, nd_mpccup, nd_mnpcup;
  logic [2:0] nd_ism_in;

  logic ism_is_agent; // lintra s-70036 strappable ism 

  always_comb ism_is_agent =  ((|ISM_IS_AGENT_STRAP ==1) ? ism_is_agent_sel : ((|SBCISMISAGENT ==1)? 1'b1 : 1'b0));

  logic port_disable_ff;
  generate
     if (USE_PORT_DISABLE==1) begin : gen_pdis_dblsync
        hqm_sbc_doublesync_set i_sbc_doublesync_port_disbale ( 
           .d     ( port_disable    ),
           .set_b ( side_rst_b      ),
           .clk   ( side_clk        ),
           .q     ( port_disable_ff )
        );
     end else begin : gen_pdis_def
        always_comb port_disable_ff = 1'b0;
     end
  endgenerate
 
  generate
    if ( ENDPOINTONLY )
       begin : gen_ep_force_blk
          always_comb begin
             force_idle_ff = force_idle;
             force_notidle_ff = force_notidle;
             force_creditreq_ff = force_creditreq;
          end
       end
    else
       begin : gen_rtr_force_blk
          always_ff @(posedge side_clk or negedge side_rst_b)
            if (~side_rst_b) begin
               force_idle_ff <= 1'b0;
               force_notidle_ff <= 1'b0;
               force_creditreq_ff <= 1'b0;
            end else begin
               force_idle_ff <= force_idle;
               force_notidle_ff <= force_notidle;
               force_creditreq_ff <= force_creditreq;
            end
       end
  endgenerate

always_comb begin
    nd_tpcput = in_tpcput;
    nd_tnpput = in_tnpput;
    nd_mpccup = in_mpccup;
    nd_mnpcup = in_mnpcup;
    nd_ism_in = in_side_ism;
end

  always_comb idle       = ((port_idle_full & agent_idle & async_ififo_idle) | force_idle_ff) & ~force_notidle_ff;
// SBC-PCN-007 - Added expected completions counter to the count_idle logic. - START
  always_comb begin
      if( ENDPOINTONLY ) begin
         count_idle = ~force_notidle_ff &
                      ( force_idle_ff |
                        ( port_idle_full &
                          idle_count &
                          ( ( ISM_COMPLETION_FENCING == 0 ) |
                            ~ism_comp_exp ) ) );
      end else begin
         // count_idle has the same equation as idle, with the exception of the async_ififo_idle term.
         // This decoupling of idle and count_idle was required, in order to address ISMPM_061 compmon
         // issues, on agent ports with async fifos 
         count_idle = ((port_idle_full & agent_idle) | force_idle_ff) & ~force_notidle_ff;
      end
  end
// SBC-PCN-007 - Added expected completions counter to the count_idle logic. - FINISH
// HSD 4258336 - Create new version of port idle to avoid turning on agent
//               clock, but hold on the side clock - FINISH

// SBC-PCN-001 - ECN 290 - Generate a single bit to represent a port ready to
//                         power gate based on:
//                         1. ISM is IDLE
//                         2. Fabric Port credits have been returned
//                         3. Agent Port credits have been sent
//                         4. Router completions are finished returning
  always_comb port_pwrgt = pwrgt_egress & pwrgt_ingress & pwrgt_comp & ism_idle & agent_idle;

  always_comb dbgbus = {srcidck_err_out, parity_err_out_pre, int_pok, gcgu_dbgbus[4:0], egress_dbgbus, ingress_dbgbus};
  
  // ism is active so long as clock gating not in progress and certain
  // ism states are in effect.
  // the cg_inprogress qualifier required since once gcgu has decided to
  // go idle (asserting req_leave_active), it must complete, which effectively
  // means the port is no longer active.

generate
    if (ISM_IS_AGENT_STRAP == 0) begin: gen_leg_inp
        if ( |SBCISMISAGENT ) begin : gen_agent_inp_blk2
            always_comb ism_active = agent_ism_active & ~cg_inprogress;
        end
        else begin : gen_fabric_inp_blk2
            always_comb ism_active = agent_ism_active | (~cg_inprogress &
                                                   (fabric_ism_active | fabric_ism_idlenaq));
        end
    end
    else begin : gen_strap_inp
        logic ism_active_agt, ism_active_fab;
        always_comb ism_active_agt = agent_ism_active & ~cg_inprogress;
        always_comb ism_active_fab = agent_ism_active | (~cg_inprogress &
                                                   (fabric_ism_active | fabric_ism_idlenaq));
        always_comb ism_active = ism_is_agent_sel ? ism_active_agt : ism_active_fab;
    end
endgenerate
    // adding agent_ism_active to above equation for fabric ISM allows one cycle of
    // latency to be removed in routers for fabric initiated exit from idle.

//------------------------------------------------------------------------------
//
// Parity handling
//
//------------------------------------------------------------------------------
logic parity_err_out_to_ingress;
logic parity_err_out_dfx;
generate
    if ( SB_PARITY_REQUIRED )
     begin : gen_parity_required_blk

        logic parity_err_out_d;

        always_comb parity_err_out_d = (in_tnpput | in_tpcput) ? (^{in_tpayload,in_teom,in_tparity} & ~cfg_parityckdef ): 1'b0;
        always_comb parity_err_out_to_ingress = (parity_err_out_d | parity_err_out_pre);
        always_comb parity_err_out = (parity_err_out_to_ingress | parity_err_from_ingress);

// parity_err_out_pre is only used in clock gating sbcgcgu. For all internal uses, parity_err_out should be used since only 
// parity_err_out corresponds/correlates to the payload.

        always_ff @(posedge gated_side_clk or negedge side_rst_b)
          if (~side_rst_b) 
              parity_err_out_pre <= '0;
          else if (parity_err_out_d ==1'b1)
              parity_err_out_pre <= 1'b1;

        // always_comb mparity = (mpcput | mnpput) ? ^{mpayload,meom} : 1'b0;

        always_ff @(posedge gated_side_clk or negedge side_rst_b)
          if (~side_rst_b) 
              parity_err_out_dfx <= 1'b0;
          else
              parity_err_out_dfx <= parity_err_out;

     end
    else
     begin : gen_parity_not_required_blk
      always_comb parity_err_out_pre = 1'b0;
      always_comb parity_err_out = 1'b0;
      always_comb parity_err_out_dfx = 1'b0;
      always_comb parity_err_out_to_ingress = 1'b0;
      // always_comb mparity = 1'b0;
     end
  endgenerate

generate
    if (ENDPOINTONLY) begin : gen_par_ing_ep
//cannot flop this because it ll create a bubble in the ingress fencecntr and block the last np (before erroneous pc) to go out        
        always_comb parity_err_to_ingress = parity_err_out_to_ingress | ext_parity_err_detected;
    end
    else begin: gen_par_in_rtr
        always_comb parity_err_to_ingress = parity_err_out_to_ingress; end
endgenerate

always_comb parity_err_in = SB_PARITY_REQUIRED ? parity_err_to_ingress : '0;


//------------------------------------------------------------------------------
//
// PipeLine fabic ISM inputs
//
//------------------------------------------------------------------------------

  generate
  // pipeinps/pipeism alignment
    if (PIPEALL==1)
      begin  : gen_pism_blk
        // Pipeline to Fabric ISM inputs
        logic [2:0]    side_ism_in_ff;
        
        always_ff @(posedge side_clk or negedge side_rst_b)
          if (~side_rst_b) 
            begin
              side_ism_in_ff <= '0;
            end 
          else 
            begin
              side_ism_in_ff <= side_ism_in;  
            end
        always_comb in_side_ism = side_ism_in_ff;
      end 
    else 
      begin : gen_ndpsm_blk
        always_comb in_side_ism = side_ism_in;     
      end 
  endgenerate

// SBC-PCN-002 - Sideband ISM should not leave nor indicate it has left idle until the lock is released
  always_comb ism_in_notidle = (in_side_ism  != ISM_FABRIC_IDLE) &&
                               ((side_ism_out != ISM_AGENT_IDLE) || (side_ism_lock_b));

//------------------------------------------------------------------------------
//
// PipeLine all put/cup/eom/payload inputs
//
//------------------------------------------------------------------------------
 
  generate
  // pipeinps/pipeisms alignment
    if (PIPEALL==1)
      begin : gen_pinp_blk
        // Pipeline to Fabric ISM inputs
        logic                   mpccup_ff, mnpcup_ff;
        logic                   tpcput_ff, tnpput_ff;
        logic                   teom_ff;
        logic [EXTMAXPLDBIT:0]  tpayload_ff;
        logic                   tparity_ff;
        
        always_ff @(posedge gated_side_clk or negedge side_rst_b)
          if (~side_rst_b) 
            begin
                mpccup_ff   <= '0;
                mnpcup_ff   <= '0;
                tpcput_ff   <= '0;
                tnpput_ff   <= '0;
                teom_ff     <= '0;
                tpayload_ff <= '0;
                tparity_ff  <= '0;
            end 
          else 
            begin
                mpccup_ff   <= mpccup;
                mnpcup_ff   <= mnpcup;
                tpcput_ff   <= tpcput;
                tnpput_ff   <= tnpput;
                if (|in_side_ism) begin
                    teom_ff     <= teom;
                    tpayload_ff <= tpayload;
                    tparity_ff  <= tparity;
                end
            end
        always_comb  in_mpccup   = mpccup_ff;
        always_comb  in_mnpcup   = mnpcup_ff;
        always_comb  in_tpcput   = tpcput_ff;
        always_comb  in_tnpput   = tnpput_ff;
        always_comb  in_teom     = teom_ff;
        always_comb  in_tpayload = tpayload_ff;
        always_comb  in_tparity  = tparity_ff;
      end 
    else 
      begin : gen_ndpinp_blk
        always_comb  in_mpccup   = mpccup;
        always_comb  in_mnpcup   = mnpcup;
        always_comb  in_tpcput   = tpcput;
        always_comb  in_tnpput   = tnpput;
        always_comb  in_teom     = teom;     
        always_comb  in_tpayload = tpayload;     
        always_comb  in_tparity  = tparity;
      end 
  endgenerate

  
//------------------------------------------------------------------------------
//
// Clock Gating ISM
//
//------------------------------------------------------------------------------
generate 
   if (ISM_IS_AGENT_STRAP == 0) begin : gen_legacy_ism
      hqm_sbcgcgu #(
        .ISMISIP               ( SBCISMISAGENT      ),
        .SKIP_ACTIVEREQ        ( SKIP_ACTIVEREQ     ),
        .ENDPOINTONLY          ( ENDPOINTONLY       ),
        .EOM_PERF_OPT          ( EOM_PERF_OPT       ),
        .CG_DELAY              ( CG_DELAY           ),
        .CG_DELAY_STRAP_EN     ( CG_DELAY_STRAP_EN  ) 
      ) sbcgcgu (                             
        .clk                   ( side_clk              ),
        .rst_b                 ( side_rst_b            ),
        .side_clk_valid        ( side_clk_valid        ),                                     
        .force_creditreq       ( force_creditreq_ff    ),                                      
        .cfg_idlecnt           ( cfg_idlecnt           ),
        .cfg_clkgaten          ( cfg_clkgaten          ),
        .ism_in                ( in_side_ism           ),
        .cg_delay_width_strap  ( cg_delay_width_strap  ),
        .cg_en                 ( cg_en                 ), // SBC-PCN-004 - Clock Gate override for the PCG.
        .side_ism_lock_b       ( side_ism_lock_b       ), // SBC-PCN-002 - Sideband ISM lock for power gating flows
        .nd_ism_in             ( nd_ism_in             ),
        .ism_out               ( side_ism_out          ),
        .maxidlecnt            ( maxidlecnt            ),
        .ip_idle               ( idle                  ),
        .count_idle            ( count_idle            ),
        .cg_inprogress         ( cg_inprogress         ),
        .ism_idle              ( ism_idle              ),
        .credit_init_done      ( credit_init_done      ), //asserted for one clock
        .credit_init           ( credit_init           ),
        .credit_reinit         ( credit_reinit         ),
        .agnt_credit_init_done (                       ), // lintra s-0214
        .int_pok               ( int_pok               ),
        .port_disable          ( port_disable_ff       ),
        .parity_err            ( parity_err_in         ),
        .epcirdy               ( egress_epcirdy        ),
        .enpirdy               ( egress_enpirdy        ),
        .dbgbus                ( gcgu_dbgbus           ),
        .ip_ism_active         ( agent_ism_active      ),   
        .ip_ism_activereq      (                       ), // lintra s-0214
        .ip_ism_idle           (                       ), // lintra s-0214
        .ip_ism_idlereq        (                       ), // lintra s-0214
        .ip_ism_creditreq      ( agent_ism_creditreq   ),
        .ip_ism_creditinit     (                       ), // lintra s-0214
        .ip_ism_creditdone     (                       ), // lintra s-0214
        .fabric_ism_active     ( fabric_ism_active     ),
        .fabric_ism_activereq  (                       ), // lintra s-0214
        .fabric_ism_idle       (                       ), // lintra s-0214
        .fabric_ism_idlenak    ( fabric_ism_idlenaq    ),
        .fabric_ism_creditreq  ( fabric_ism_creditreq  ),
        .fabric_ism_creditack  (                       ), // lintra s-0214
        .fabric_ism_creditinit ( fabric_ism_creditinit ) // SBC-PCN-001 - ECN 290 - Credit initialization state will mark when incrementing the credit watermark
      );
   end else begin : gen_strap_ism

      logic       cg_en_agent,                 cg_en_fabric;
      logic [2:0] side_ism_out_agent,          side_ism_out_fabric;
      logic       maxidlecnt_agent,            maxidlecnt_fabric;
      logic       cg_inprogress_agent,         cg_inprogress_fabric;
      logic       ism_idle_agent,              ism_idle_fabric;
      logic       credit_init_agent,           credit_init_fabric;
      logic       credit_reinit_agent,         credit_reinit_fabric;
      logic [5:0] gcgu_dbgbus_agent,           gcgu_dbgbus_fabric;
      logic       agent_ism_active_agent,      agent_ism_active_fabric;
      logic       agent_ism_creditreq_agent,   agent_ism_creditreq_fabric;
      logic       fabric_ism_active_agent,     fabric_ism_active_fabric;
      logic       fabric_ism_idlenaq_agent,    fabric_ism_idlenaq_fabric;
      logic       fabric_ism_creditreq_agent,  fabric_ism_creditreq_fabric;
      logic       fabric_ism_creditinit_agent, fabric_ism_creditinit_fabric;
      logic       side_clk_agent,              side_clk_fabric;

      always_comb cg_en                 = ism_is_agent_sel ? cg_en_agent                 : cg_en_fabric;
      always_comb side_ism_out          = ism_is_agent_sel ? side_ism_out_agent          : side_ism_out_fabric;
      always_comb maxidlecnt            = ism_is_agent_sel ? maxidlecnt_agent            : maxidlecnt_fabric;
      always_comb cg_inprogress         = ism_is_agent_sel ? cg_inprogress_agent         : cg_inprogress_fabric;
      always_comb ism_idle              = ism_is_agent_sel ? ism_idle_agent              : ism_idle_fabric;
      always_comb credit_init           = ism_is_agent_sel ? credit_init_agent           : credit_init_fabric;
      always_comb credit_reinit         = ism_is_agent_sel ? credit_reinit_agent         : credit_reinit_fabric;
      always_comb gcgu_dbgbus           = ism_is_agent_sel ? gcgu_dbgbus_agent           : gcgu_dbgbus_fabric;
      always_comb agent_ism_active      = ism_is_agent_sel ? agent_ism_active_agent      : agent_ism_active_fabric;
      always_comb agent_ism_creditreq   = ism_is_agent_sel ? agent_ism_creditreq_agent   : agent_ism_creditreq_fabric;
      always_comb fabric_ism_active     = ism_is_agent_sel ? fabric_ism_active_agent     : fabric_ism_active_fabric;
      always_comb fabric_ism_idlenaq    = ism_is_agent_sel ? fabric_ism_idlenaq_agent    : fabric_ism_idlenaq_fabric;
      always_comb fabric_ism_creditreq  = ism_is_agent_sel ? fabric_ism_creditreq_agent  : fabric_ism_creditreq_fabric;
      always_comb fabric_ism_creditinit = ism_is_agent_sel ? fabric_ism_creditinit_agent : fabric_ism_creditinit_fabric;

      hqm_sbc_clock_gate i_sbc_clock_gate_side_clk_agent (
         .en   ( ism_is_agent_sel ),
         .te   ( fscan_clkungate  ),   
         .clk  ( side_clk         ),   
         .enclk( side_clk_agent   )    
      );

      hqm_sbc_clock_gate i_sbc_clock_gate_side_clk_fabric (
         .en   ( ~ism_is_agent_sel ),
         .te   ( fscan_clkungate  ),   
         .clk  ( side_clk         ),   
         .enclk( side_clk_fabric  )    
      );

      hqm_sbcgcgu #(
        .ISMISIP               ( 1                  ),
        .SKIP_ACTIVEREQ        ( 1                  ),
        .ENDPOINTONLY          ( ENDPOINTONLY       ),
        .EOM_PERF_OPT          ( EOM_PERF_OPT       ),
        .CG_DELAY              ( CG_DELAY           ),
        .CG_DELAY_STRAP_EN     ( CG_DELAY_STRAP_EN  )         
      ) sbcgcgu_agent (                             
        .clk                   ( side_clk_agent        ),
        .rst_b                 ( side_rst_b            ),
        .side_clk_valid        ( side_clk_valid        ),                                     
        .force_creditreq       ( force_creditreq_ff    ),                                      
        .cfg_idlecnt           ( cfg_idlecnt           ),
        .cfg_clkgaten          ( cfg_clkgaten          ),
        .ism_in                ( in_side_ism           ),
        .cg_delay_width_strap  ( cg_delay_width_strap  ),
        .cg_en                 ( cg_en_agent           ), // SBC-PCN-004 - Clock Gate override for the PCG.
        .side_ism_lock_b       ( side_ism_lock_b       ), // SBC-PCN-002 - Sideband ISM lock for power gating flows
        .nd_ism_in             ( nd_ism_in             ),
        .ism_out               ( side_ism_out_agent    ),
        .maxidlecnt            ( maxidlecnt_agent      ),
        .ip_idle               ( idle                  ),
        .count_idle            ( count_idle            ),
        .cg_inprogress         ( cg_inprogress_agent   ),
        .ism_idle              ( ism_idle_agent        ),
        .credit_init_done      ( credit_init_done      ), //asserted for one clock
        .credit_init           ( credit_init_agent     ),
        .credit_reinit         ( credit_reinit_agent   ),
        .agnt_credit_init_done (                       ), // lintra s-0214
        .int_pok               ( int_pok               ),
        .port_disable          ( port_disable_ff       ),
        .parity_err            ( parity_err_in         ),
        .epcirdy               ( egress_epcirdy        ),
        .enpirdy               ( egress_enpirdy        ),
        .dbgbus                ( gcgu_dbgbus_agent     ),
        .ip_ism_active         ( agent_ism_active_agent      ),   
        .ip_ism_activereq      (                             ), // lintra s-0214
        .ip_ism_idle           (                             ), // lintra s-0214
        .ip_ism_idlereq        (                             ), // lintra s-0214
        .ip_ism_creditreq      ( agent_ism_creditreq_agent   ),
        .ip_ism_creditinit     (                             ), // lintra s-0214
        .ip_ism_creditdone     (                             ), // lintra s-0214
        .fabric_ism_active     ( fabric_ism_active_agent     ),
        .fabric_ism_activereq  (                             ), // lintra s-0214
        .fabric_ism_idle       (                             ), // lintra s-0214
        .fabric_ism_idlenak    ( fabric_ism_idlenaq_agent    ),
        .fabric_ism_creditreq  ( fabric_ism_creditreq_agent  ),
        .fabric_ism_creditack  (                             ), // lintra s-0214
        .fabric_ism_creditinit ( fabric_ism_creditinit_agent ) // SBC-PCN-001 - ECN 290 - Credit initialization state will mark when incrementing the credit watermark
      );

      hqm_sbcgcgu #(
        .ISMISIP               ( 0                  ),
        .SKIP_ACTIVEREQ        ( 0                  ),
        .ENDPOINTONLY          ( ENDPOINTONLY       ),
        .EOM_PERF_OPT          ( EOM_PERF_OPT       ),
        .CG_DELAY              ( CG_DELAY           ),
        .CG_DELAY_STRAP_EN     ( CG_DELAY_STRAP_EN  )         
      ) sbcgcgu_fabric (                             
        .clk                   ( side_clk_fabric       ),
        .rst_b                 ( side_rst_b            ),
        .side_clk_valid        ( side_clk_valid        ),                                     
        .force_creditreq       ( force_creditreq_ff    ),                                      
        .cfg_idlecnt           ( cfg_idlecnt           ),
        .cfg_clkgaten          ( cfg_clkgaten          ),
        .ism_in                ( in_side_ism           ),
        .cg_delay_width_strap  ( cg_delay_width_strap  ),
        .cg_en                 ( cg_en_fabric          ), // SBC-PCN-004 - Clock Gate override for the PCG.
        .side_ism_lock_b       ( side_ism_lock_b       ), // SBC-PCN-002 - Sideband ISM lock for power gating flows
        .nd_ism_in             ( nd_ism_in             ),
        .ism_out               ( side_ism_out_fabric   ),
        .maxidlecnt            ( maxidlecnt_fabric     ),
        .ip_idle               ( idle                  ),
        .count_idle            ( count_idle            ),
        .cg_inprogress         ( cg_inprogress_fabric  ),
        .ism_idle              ( ism_idle_fabric       ),
        .credit_init_done      ( credit_init_done      ), //asserted for one clock
        .credit_init           ( credit_init_fabric    ),
        .credit_reinit         ( credit_reinit_fabric  ),
        .agnt_credit_init_done (                       ), // lintra s-0214
        .int_pok               ( int_pok               ),
        .port_disable          ( port_disable_ff       ),
        .parity_err            ( parity_err_in         ),
        .epcirdy               ( egress_epcirdy        ),
        .enpirdy               ( egress_enpirdy        ),
        .dbgbus                ( gcgu_dbgbus_fabric    ),
        .ip_ism_active         ( agent_ism_active_fabric      ),   
        .ip_ism_activereq      (                              ), // lintra s-0214
        .ip_ism_idle           (                              ), // lintra s-0214
        .ip_ism_idlereq        (                              ), // lintra s-0214
        .ip_ism_creditreq      ( agent_ism_creditreq_fabric   ),
        .ip_ism_creditinit     (                              ), // lintra s-0214
        .ip_ism_creditdone     (                              ), // lintra s-0214
        .fabric_ism_active     ( fabric_ism_active_fabric     ),
        .fabric_ism_activereq  (                              ), // lintra s-0214
        .fabric_ism_idle       (                              ), // lintra s-0214
        .fabric_ism_idlenak    ( fabric_ism_idlenaq_fabric    ),
        .fabric_ism_creditreq  ( fabric_ism_creditreq_fabric  ),
        .fabric_ism_creditack  (                              ), // lintra s-0214
        .fabric_ism_creditinit ( fabric_ism_creditinit_fabric ) // SBC-PCN-001 - ECN 290 - Credit initialization state will mark when incrementing the credit watermark
      );
   end
endgenerate

//------------------------------------------------------------------------------
//
// Ingress Port    
//
//------------------------------------------------------------------------------

hqm_sbcingress #(
  .NPQUEUEDEPTH                ( NPQUEUEDEPTH                 ),
  .PCQUEUEDEPTH                ( PCQUEUEDEPTH                 ),
  .EXTMAXPLDBIT                ( EXTMAXPLDBIT                 ),
  .INTMAXPLDBIT                ( INGMAXPLDBIT                 ),
  .LATCHQUEUES                 ( LATCHQUEUES                  ),
  .RELATIVE_PLACEMENT_EN       ( RELATIVE_PLACEMENT_EN        ),
  .ISM_IS_AGENT_STRAP          ( ISM_IS_AGENT_STRAP           ),
  .ISMISAGENT                  ( SBCISMISAGENT                ), // SBC-PCN-001 - ECN 290 - Power Gating for agent ingress ports
  .ENDPOINTONLY                ( ENDPOINTONLY                 ),
  .RTR_SB_PARITY_REQUIRED      ( RTR_SB_PARITY_REQUIRED       ),
  .SB_PARITY_REQUIRED          ( SB_PARITY_REQUIRED           ),
  .EXPECTED_COMPLETIONS_COUNTER( EXPECTED_COMPLETIONS_COUNTER ), // SBC-PCN-007 - Expected completions counter enable
  .STAP_FOR_MISR               ( STAP_FOR_MISR                ), // Integrate the MISR logic
  .STAP_FOR_DFD                ( STAP_FOR_DFD                 ), // Integrate the MISR logic
  .STAP_TDR_WIDTH              ( 38                           ), // Integrate the MISR logic
  .GNR_HIER_FABRIC             ( GNR_HIER_FABRIC              ),
  .GNR_GLOBAL_SEGMENT          ( GNR_GLOBAL_SEGMENT           ),
  .GNR_HIER_BRIDGE_EN          ( GNR_HIER_BRIDGE_EN           ),
  .GNR_16BIT_EP                ( GNR_16BIT_EP                 ),
  .GNR_8BIT_EP                 ( GNR_8BIT_EP                  ),
  .GNR_RTR_SEGMENT_ID          ( GNR_RTR_SEGMENT_ID           ),
  .HIER_BRIDGE                 ( HIER_BRIDGE                  ),
  .HIER_BRIDGE_STRAP           ( HIER_BRIDGE_STRAP            ),
  .GLOBAL_RTR                  ( GLOBAL_RTR                   ),
  .LOCAL2GLOBAL                ( LOCAL2GLOBAL                 ),
  .SRCID_CK_EN                 ( SRCID_CK_EN                  )
) sbcingress (                          
  .side_clk         ( gated_side_clk    ),
  .ungated_side_clk ( side_clk          ),
  .side_rst_b       ( side_rst_b        ),
  .ism_is_agent_sel ( ism_is_agent_sel  ),
  .ism_active       ( ism_active        ),
  .pwrgt_ingress    ( pwrgt_ingress     ), // SBC-PCN-001 - ECN 290 - Ingress power gating rediness indicator
  .int_pok          ( int_pok           ), // Needed to ignore credits in the idle equation when powered down
  .idle_ingress     ( idle_ingress      ),
  .credit_init_done ( credit_init_done  ),
  .credit_init      ( credit_init       ),
  .credit_reinit    ( credit_reinit     ),
  .tpccup           ( tpccup            ),
  .tnpcup           ( tnpcup            ),
  .tpcput           ( in_tpcput         ),
  .tnpput           ( in_tnpput         ),
  .nd_tpcput        ( nd_tpcput         ),
  .nd_tnpput        ( nd_tnpput         ),
  .teom             ( in_teom           ),
  .tpayload         ( in_tpayload       ),
  .tparity          ( in_tparity        ),
  .pctrdy           ( ingress_pctrdy    ), // SBC-PCN-001 - Added alternate path into ingress interface for completions
  .pcirdy           ( ingress_pcirdy    ), // SBC-PCN-001 - Added alternate path into ingress interface for completions
  .pcdata           ( ingress_pcdata    ), // SBC-PCN-001 - Added alternate path into ingress interface for completions
  .pcparity         ( ingress_pcparity  ), // SBC-PCN-001 - Added alternate path into ingress interface for completions
  .pceom            ( ingress_pceom     ), // SBC-PCN-001 - Added alternate path into ingress interface for completions
  .pcdstvld         ( ingress_pcdstvld  ), // SBC-PCN-001 - Added alternate path into ingress interface for completions
  .ingress_np_detect( ingress_np_detect ), // SBC-PCN-007 - Detect when a non-posted message as ingressed the port
  .nptrdy           ( nptrdy            ),
  .npirdy           ( npirdy            ),
  .npfence          ( npfence           ),
  .npdata           ( npdata            ),
  .npparity         ( npparity          ),
  .npeom            ( npeom             ),
  .npdstvld         ( npdstvld          ),
  .cfg_parityckdef  ( cfg_parityckdef   ),
  .cfg_srcidckdef   ( cfg_srcidckdef    ),
  .srcid_portlist   ( srcid_portlist    ),
  .parity_err_in    ( parity_err_in     ),
  .parity_err_out   ( parity_err_from_ingress),
  .srcidck_err_out  ( srcidck_err_out   ),
  .tdr_mbp_enable   ( tdr_mbp_enable    ),
  .tdr_ftap_tck     ( tdr_ftap_tck      ),
  .tdr_sbr_data     ( tdr_sbr_data[37:0]),
  .sbr_tdr_data     ( sbr_tdr_data[37:0]),
  .fscan_clkungate  ( fscan_clkungate_misr ),
  .fscan_clkungate_syn ( fscan_clkungate_syn ),
  .fscan_byprst_b   ( fscan_byprst_b    ),
  .fscan_rstbypen   ( fscan_rstbypen    ),
  .fscan_shiften    ( fscan_shiften     ),
  .dt_latchopen     ( dt_latchopen      ),
  .dt_latchclosed_b ( dt_latchclosed_b  ),
  .cfg_hierbridgeen ( cfg_hierbridgeen  ),
  .dbgbus           ( ingress_dbgbus    )
);

// SBC-PCN-007 - Ingress Non-Posted expected completions counter - START
//-----------------------------------------------------------------------------
// Expected Completions Counter
//-----------------------------------------------------------------------------
// For every ingressing NP message into an Endpoint there is exactly one
// expected completion message to be egressed back. This code assumes that all
// egressing completion messages returned correspond to one of the from the
// agents. So there is no checking preformed to guarantee this is true.
//-----------------------------------------------------------------------------
generate
   if( |ENDPOINTONLY && |EXPECTED_COMPLETIONS_COUNTER ) begin: gen_exp_comp_counter
      logic [EXPCOMPCOUNTBIT:0] exp_comp_count;
      logic                     exp_comp_count_up;
      logic                     exp_comp_count_down;

      always_comb ism_comp_exp        =  (|exp_comp_count);
      always_comb exp_comp_count_up   = ~(&exp_comp_count) &  ingress_np_detect & ~egress_comp_detect;
      always_comb exp_comp_count_down =  (|exp_comp_count) & ~ingress_np_detect &  egress_comp_detect;

      always_ff @( posedge gated_side_clk or negedge side_rst_b ) begin
         if( !side_rst_b ) begin
            exp_comp_count <= 'd0;
         end else begin
            unique casez ( { exp_comp_count_up , exp_comp_count_down } )
               2'b10  : exp_comp_count <= exp_comp_count + 'd1;
               2'b01  : exp_comp_count <= exp_comp_count - 'd1;
               default: exp_comp_count <= exp_comp_count;
            endcase
         end
      end
// Assertions
   end else begin: gen_no_exp_comp_counter
      always_comb ism_comp_exp = 1'b0;
   end
endgenerate
// SBC-PCN-007 - Ingress Non-Posted expected completions counter - FINISH


// SBC-PCN-001 - Completion unit constructed to drain posted and send
// completion messages to non-posted messages to clean the queues. - START
//-----------------------------------------------------------------------------
// Completion Unit
//-----------------------------------------------------------------------------
// The completion unit is responsible for turning around all outstanding
// messages that would have otherwise been stranded in the egress FIFOs of an
// Asynchronous router port.
//-----------------------------------------------------------------------------
generate
   if( ENDPOINTONLY==0 ) begin: gen_sbccomp_inserted
      logic                  comp_enpstall;
      logic                  comp_epctrdy;
      logic                  comp_enptrdy;
      logic                  comp_epcirdy;
      logic                  comp_enpirdy;
      logic                  comp_pctrdy;
      logic                  comp_pcirdy;
      logic [INGMAXPLDBIT:0] comp_pcdata;
      logic                  comp_pceom;
      logic                  comp_pcparity;
      logic                  comp_pcdstvld;
      logic                  npidle_comp;
      logic                  pcidle_comp;

      hqm_sbccomp #(
         .INGMAXPLDBIT( INGMAXPLDBIT ),
         .EGRMAXPLDBIT( EGRMAXPLDBIT ),
         .GLOBAL_RTR( GLOBAL_RTR )
      ) i_sbccomp (
         .side_clk    ( gated_side_clk ),
         .side_rst_b  ( side_rst_b     ),
         .agent_idle  ( agent_idle     ), // Added for HSD #1404071127, "POK completion error"
         .pwrgt_comp  ( pwrgt_comp     ), // Should be combined with egress power gate
         .idle_comp   ( idle_comp_cgreq), // Should be combined with egress idle
         .npidle_comp ( npidle_comp    ),
         .pcidle_comp ( pcidle_comp    ),
         // Egress Arbiter Interface - Outputs
         .enpstall  ( comp_enpstall  ),
         .epctrdy   ( comp_epctrdy   ),
         .enptrdy   ( comp_enptrdy   ),
         // Egress Arbiter Interface - Inputs
         .epcirdy   ( comp_epcirdy   ),
         .enpirdy   ( comp_enpirdy   ),
         .data      ( data           ), // Safe to always see data
         .eom       ( eom            ), // Safe to always see eom
         // Ingress Arbiter Interface - Inputs
         .pctrdy    ( comp_pctrdy    ), // Safe for this module to always see trdy
         // Ingress Arbiter Interface - Outputs
         .pcirdy    ( comp_pcirdy    ),
         .pcdata    ( comp_pcdata    ),
         .pcparity  ( comp_pcparity  ),
         .pceom     ( comp_pceom     ),
         .pcdstvld  ( comp_pcdstvld  )
      );

      always_comb begin
         if( int_pok & npidle_comp ) begin // Power Good and not processing np msgs
            // Egress queue outputs
            enpstall = egress_enpstall;
            enptrdy  = egress_enptrdy;
            // Egress queue inputs
            egress_enpirdy = enpirdy;
            comp_enpirdy   = 1'b0;
         end else begin
            // Egress queue outputs
            enpstall = comp_enpstall;
            enptrdy  = comp_enptrdy;
            // Egress queue inputs
            egress_enpirdy = 1'b0;
            comp_enpirdy   = enpirdy;
         end

         if( int_pok & pcidle_comp ) begin // Power Good and not processing pc msgs
            // Egress queue outputs
            epctrdy  = egress_epctrdy;
            // Egress queue inputs
            egress_epcirdy = epcirdy;
            comp_epcirdy   = 1'b0;
         end else begin
            // Egress queue outputs
            epctrdy  = comp_epctrdy;
            // Egress queue inputs
            egress_epcirdy = 1'b0;
            comp_epcirdy   = epcirdy;
         end
            
         if( int_pok & npidle_comp ) begin // Power Good and not processing np msgs as a pc msg will be coming
            // Ingress queue outputs
            pcirdy   = ingress_pcirdy;
            pcdstvld = ingress_pcdstvld;
            pceom    = ingress_pceom;
            pcdata   = ingress_pcdata;
            pcparity = ingress_pcparity;
            // Ingress queue inputs (guard the ingress for pctrdy.)
            ingress_pctrdy = pctrdy;
            comp_pctrdy    = 1'b0;
         end else begin
            // Ingress queue outputs
            pcirdy   = comp_pcirdy;
            pcdstvld = comp_pcdstvld;
            pceom    = comp_pceom;
            pcdata   = comp_pcdata;
            pcparity = comp_pcparity;
            // Ingress queue inputs (guard the ingress for pctrdy.)
            ingress_pctrdy = 1'b0;
            comp_pctrdy    = pctrdy;
         end
      end
   end else begin: gen_sbccomp_bypassed
      always_comb begin
         // Completion module still has outputs to drive
         idle_comp_cgreq   = 1'b1;
         pwrgt_comp  = 1'b1;
         // Egress queue outputs
         enpstall = egress_enpstall;
         epctrdy  = egress_epctrdy;
         enptrdy  = egress_enptrdy;
         // Egress queue inputs (need to protect the egress from messing
         // with internal pointers. It may be okay but it is not woth the
         // trouble.)
         egress_epcirdy = epcirdy;
         egress_enpirdy = enpirdy;
         // Ingress queue outputs
         pcirdy   = ingress_pcirdy;
         pcdstvld = ingress_pcdstvld;
         pceom    = ingress_pceom;
         pcparity = ingress_pcparity;
         pcdata   = ingress_pcdata;
         // Ingress queue inputs (guard the ingress for pctrdy.)
         ingress_pctrdy = pctrdy;
      end
   end
endgenerate
// SBC-PSF-001 - Completion unit constructed to drain posted and send
// completion messages to non-posted messages to clean the queues. - FINISH

//------------------------------------------------------------------------------
//
// Egress Port    
//
//------------------------------------------------------------------------------

hqm_sbcegress #(
  .EXTMAXPLDBIT                ( EXTMAXPLDBIT                 ),
  .INTMAXPLDBIT                ( EGRMAXPLDBIT                 ),
  .CUP2PUT1CYC                 ( CUP2PUT1CYC                  ),
  .SYNCROUTER                  ( SYNCROUTER                   ),
  .ENDPOINTONLY                ( ENDPOINTONLY                 ),
  .SB_PARITY_REQUIRED          ( SB_PARITY_REQUIRED           ),
  .EXPECTED_COMPLETIONS_COUNTER( EXPECTED_COMPLETIONS_COUNTER ), // SBC-PCN-007 - Expected completions counter enable
  .GNR_HIER_FABRIC             ( GNR_HIER_FABRIC              ),
  .GNR_GLOBAL_SEGMENT          ( GNR_GLOBAL_SEGMENT           ),
  .GNR_HIER_BRIDGE_EN          ( GNR_HIER_BRIDGE_EN           ),
  .GNR_16BIT_EP                ( GNR_16BIT_EP                 ),
  .GNR_8BIT_EP                 ( GNR_8BIT_EP                  ),
  .GNR_RTR_SEGMENT_ID          ( GNR_RTR_SEGMENT_ID           ),
  .HIER_BRIDGE                 ( HIER_BRIDGE                  ), // HIER_HDR
  .HIER_BRIDGE_PID             ( HIER_BRIDGE_PID              ), // HIER_HDR
  .HIER_BRIDGE_STRAP           ( HIER_BRIDGE_STRAP            ),
  .MIN_GLOBAL_PID              ( MIN_GLOBAL_PID               ),
  .GLOBAL_EP                   ( GLOBAL_EP                    ),
  .GLOBAL_EP_IS_STRAP          ( GLOBAL_EP_IS_STRAP           )
) sbcegress (                          
  .side_clk             ( gated_side_clk        ),
  .side_rst_b           ( side_rst_b            ),
  .ism_active           ( ism_active            ),
  .credit_reinit        ( credit_reinit         ),
  .fabric_ism_creditinit( fabric_ism_creditinit ), // SBC-PCN-001 - ECN 290 - Detect when the fabric is in the CREDITINT state.
  .pwrgt_egress         ( pwrgt_egress          ), // SBC-PCN-001 - ECN 290 - Egress power gating rediness indicator
  .idle_egress          ( idle_egress           ),
  .idle_egress_full     ( idle_egress_full      ), // HSD 4258336 - Created a full varient of the idle_egress, this is the original one.
  .mpccup               ( in_mpccup             ),
  .mnpcup               ( in_mnpcup             ),
  .nd_mpccup            ( nd_mpccup             ),
  .nd_mnpcup            ( nd_mnpcup             ),
  .mpcput               ( mpcput                ),
  .mnpput               ( mnpput                ),
  .meom                 ( meom                  ),
  .mpayload             ( mpayload              ),
  .mparity              ( mparity               ),
  .enpstall             ( egress_enpstall       ), // SBC-PCN-001 - Update so that data can be flushed out of the egress queue
  .epctrdy              ( egress_epctrdy        ), // SBC-PCN-001 - Update so that data can be flushed out of the egress queue
  .enptrdy              ( egress_enptrdy        ), // SBC-PCN-001 - Update so that data can be flushed out of the egress queue
  .epcirdy              ( egress_epcirdy        ), // SBC-PCN-001 - Update so that data can be flushed out of the egress queue
  .enpirdy              ( egress_enpirdy        ), // SBC-PCN-001 - Update so that data can be flushed out of the egress queue
  .egress_comp_detect   ( egress_comp_detect    ), // SBC-PCN-007 - Detect when a completion message is being egressed out the port
  .datain               ( data                  ),
  .parityin             ( parity                ),
  .eomin                ( eom                   ),
  .cfg_parityckdef      ( cfg_parityckdef       ),
  .cfg_hierbridgeen     ( cfg_hierbridgeen      ),
  .cfg_hierbridgepid    ( cfg_hierbridgepid     ),
  .global_ep_strap      ( global_ep_strap       ),
  .dbgbus               ( egress_dbgbus         )
);


//DFx ENhancement Feature - START

  generate
    if (STAP_FOR_DFD==1) begin : gen_dfx_tap_inst

        logic [1:0][INGMAXPLDBIT:0]   tap_data;
        logic                         pcmsgip, npmsgip;
        logic [1:0]                   first_flit;  //indicator for first flit of a np message
        logic [1:0]                   header_valid;  //indicator for first flit of a pc message
        logic [1:0]                   last_header_flit;  //indicator for first flit of a pc message
        logic [1:0]                   header_ip;  //indicator for first flit of a pc message


        logic [1:0][7:0]              tap_src_id, tap_src_id_dsync; //
        logic [1:0][7:0]              tap_dst_id, tap_dst_id_dsync; //
        logic [1:0][7:0]              tap_src_hier_id, tap_src_hier_id_dsync;  // lintra s-0531 "Temp unused"
        logic [1:0][7:0]              tap_dst_hier_id, tap_dst_hier_id_dsync;  // lintra s-0531 "Temp unused"
        logic [1:0][7:0]              tap_opcode, tap_opcode_dsync; //
//        logic [1:0][7:0]              tap_tag, tap_tag_dsync;

        logic [1:0]                   tap_msg_ip, tap_msg_ip_dsync;
        logic [1:0]                   tap_cred_avail, tap_cred_avail_dsync;
        logic [1:0]                   tap_sai_src_ok, tap_sai_src_ok_dsync;

        logic [2:0]                   tap_fabric_ism, tap_fabric_ism_dsync;
        logic                         tap_par_detect, tap_par_detect_dsync;





        always_comb first_flit[PC]   = pcirdy & ~pcmsgip;
        always_comb first_flit[NP]   = npirdy & ~npmsgip; 



        always_comb header_valid[PC]   = (first_flit[PC] | header_ip[PC]) & pcirdy & pctrdy;
        always_comb header_valid[NP]   = (first_flit[NP] | header_ip[NP]) & npirdy & nptrdy;


        always_ff @(posedge side_clk or negedge side_rst_b)
          if (~side_rst_b) begin // lintra s-70023
            pcmsgip         <= '0;
            npmsgip         <= '0;
          end else begin
            if (nptrdy & npirdy) npmsgip   <= ~npeom;
            if (pctrdy & pcirdy) pcmsgip   <= ~pceom;
          end


        always_ff @(posedge side_clk or negedge side_rst_b)
          if (~side_rst_b) begin 
            header_ip[PC]         <= '0;
          end else begin
            if (first_flit[PC] & ~last_header_flit[PC]) begin
                header_ip[PC]   <= '1;     
            end
            else if (last_header_flit[PC] & pcirdy & pctrdy) begin
                header_ip[PC]   <= '0;  
            end
            
          end


        always_ff @(posedge side_clk or negedge side_rst_b)
          if (~side_rst_b) begin 
            header_ip[NP]         <= '0;
          end else begin
            if (first_flit[NP] & ~last_header_flit[NP]) begin
                header_ip[NP]   <= '1;     
            end
            else if (last_header_flit[NP] & npirdy & nptrdy) begin
                header_ip[NP]   <= '0;  
            end
            
          end


       always_comb tap_data[PC] = pcdata;
       always_comb tap_data[NP] = npdata;
       always_comb tap_msg_ip[PC] = pcmsgip;
       always_comb tap_msg_ip[NP] = npmsgip;
       always_comb tap_cred_avail[PC] = egress_dbgbus[3];
       always_comb tap_cred_avail[NP] = egress_dbgbus[2];
       always_comb tap_sai_src_ok[PC] = srcidck_err_out;
       always_comb tap_sai_src_ok[NP] = srcidck_err_out;


       always_comb tap_fabric_ism = side_ism_out;
       always_comb tap_par_detect = parity_err_out_dfx;

       genvar j, k;

       for (j=0; j<=1; j++) 
           begin : gen_dfx_tap

               always_comb tap_src_hier_id_dsync[j] = '0;
               always_comb tap_dst_hier_id_dsync[j] = '0;

               hqm_sbcheaderdecoder #(.INTERNALPLDBIT (INGMAXPLDBIT))
                  sbcheaderdecoder (
                  .side_clk           (side_clk),
                  .side_rst_b         (side_rst_b),
                  .header_valid       (header_valid[j]),
                  .data               (tap_data[j]),
                  .src_id             (tap_src_id[j]),
                  .dst_id             (tap_dst_id[j]),
                  .opcode             (tap_opcode[j]),
//                  .tag                (tap_tag[j]),
                  .tag                (),                   // lintra s-0214
                  .last_byte          (last_header_flit[j])
              );


              if (STAP_FOR_DFD_DSYNC==1) begin : gen_dfx_tap_dsync

                   for (k=0; k<8; k++) begin: gen_dfx_tap_8_o_dsync

                      hqm_sbc_doublesync i_sbc_doublesync_tap_srcid_o ( 
                         .d     ( tap_src_id[j][k]       ),
                         .clr_b ( side_rst_b            ), // TODO: what's the correct reset signal?
                         .clk   ( tdr_ftap_tck             ),
                         .q     ( tap_src_id_dsync[j][k] )
                      );

                      hqm_sbc_doublesync i_sbc_doublesync_tap_dstid_o ( 
                         .d     ( tap_dst_id[j][k]       ),
                         .clr_b ( side_rst_b            ), // TODO: what's the correct reset signal?
                         .clk   ( tdr_ftap_tck             ),
                         .q     ( tap_dst_id_dsync[j][k] )
                      );

                      hqm_sbc_doublesync i_sbc_doublesync_tap_opcode_o ( 
                         .d     ( tap_opcode[j][k]       ),
                         .clr_b ( side_rst_b            ), // TODO: what's the correct reset signal?
                         .clk   ( tdr_ftap_tck             ),
                         .q     ( tap_opcode_dsync[j][k] )
                      );

                      /*
                      sbc_doublesync i_sbc_doublesync_tap_tag_o ( 
                         .d     ( tap_tag[j][k]       ),
                         .clr_b ( side_rst_b            ), // TODO: what's the correct reset signal?
                         .clk   ( tdr_ftap_tck             ),
                         .q     ( tap_tag_dsync[j][k] )
                      );
                      */

                   end // block gen_dfx_tap_8_o_dsync

                   hqm_sbc_doublesync i_sbc_doublesync_tap_msgip_o ( 
                     .d     ( tap_msg_ip[j]       ),
                     .clr_b ( side_rst_b            ), // TODO: what's the correct reset signal?
                     .clk   ( tdr_ftap_tck             ),
                     .q     ( tap_msg_ip_dsync[j] )
                   );

                   hqm_sbc_doublesync i_sbc_doublesync_tap_credavail_o ( 
                     .d     ( tap_cred_avail[j]       ),
                     .clr_b ( side_rst_b            ), // TODO: what's the correct reset signal?
                     .clk   ( tdr_ftap_tck             ),
                     .q     ( tap_cred_avail_dsync[j] )
                   );

                   hqm_sbc_doublesync i_sbc_doublesync_tap_saisrcok_o ( 
                     .d     ( tap_sai_src_ok[j]       ),
                     .clr_b ( side_rst_b            ), // TODO: what's the correct reset signal?
                     .clk   ( tdr_ftap_tck             ),
                     .q     ( tap_sai_src_ok_dsync[j] )
                   );

              end // block gen_dfx_tap_dsync
              else begin : gen_dfx_tap_no_dsync

                   for (k=0; k<8; k++) begin: gen_dfx_tap_8_o_no_dsync

                      always_ff @(posedge tdr_ftap_tck or negedge side_rst_b)
                         if (~side_rst_b) // lintra s-70023
                            tap_src_id_dsync[j][k] <= '0;
                         else
                            tap_src_id_dsync[j][k] <= tap_src_id[j][k];

                      always_ff @(posedge tdr_ftap_tck or negedge side_rst_b)
                         if (~side_rst_b) // lintra s-70023
                            tap_dst_id_dsync[j][k] <= '0;
                         else
                            tap_dst_id_dsync[j][k] <= tap_dst_id[j][k];

                      always_ff @(posedge tdr_ftap_tck or negedge side_rst_b)
                         if (~side_rst_b) // lintra s-70023
                            tap_opcode_dsync[j][k] <= '0;
                         else
                            tap_opcode_dsync[j][k] <= tap_opcode[j][k];

                      /*
                      always_ff @(posedge tdr_ftap_tck or negedge side_rst_b)
                         if (~side_rst_b) // lintra s-70023
                            tap_tag_dsync[j][k] <= '0;
                         else
                            tap_tag_dsync[j][k] <= tap_tag[j][k];
                      */

                   end // block gen_dfx_tap_8_o_no_dsync

                   always_ff @(posedge tdr_ftap_tck or negedge side_rst_b)
                      if (~side_rst_b) // lintra s-70023
                         tap_msg_ip_dsync[j] <= '0;
                      else
                         tap_msg_ip_dsync[j] <= tap_msg_ip[j];

                   always_ff @(posedge tdr_ftap_tck or negedge side_rst_b)
                      if (~side_rst_b) // lintra s-70023
                         tap_cred_avail_dsync[j] <= '0;
                      else
                         tap_cred_avail_dsync[j] <= tap_cred_avail[j];

                   always_ff @(posedge tdr_ftap_tck or negedge side_rst_b)
                      if (~side_rst_b) // lintra s-70023
                         tap_sai_src_ok_dsync[j] <= '0;
                      else
                         tap_sai_src_ok_dsync[j] <= tap_sai_src_ok[j];

              end // block gen_dfx_tap_no_dsync

        end // block: gen_dfx_tap

              if (STAP_FOR_DFD_DSYNC==1) begin : gen_dfx_tap_dsync_b

                 for (k=0; k<3; k++) begin: gen_dfx_tap_3_o_dsync
                    hqm_sbc_doublesync i_sbc_doublesync_tap_ism_o ( 
                       .d     ( tap_fabric_ism[k]       ),
                       .clr_b ( side_rst_b            ), // TODO: what's the correct reset signal?
                       .clk   ( tdr_ftap_tck             ),
                       .q     ( tap_fabric_ism_dsync[k] )
                    );
                 end

                 hqm_sbc_doublesync i_sbc_doublesync_tap_pardetect_o ( 
                   .d     ( tap_par_detect       ),
                   .clr_b ( side_rst_b            ), // TODO: what's the correct reset signal?
                   .clk   ( tdr_ftap_tck             ),
                   .q     ( tap_par_detect_dsync )
                 );

              end // block gen_dfx_tap_dsync_b
              else begin : gen_dfx_tap_no_dsync_b

                 for (k=0; k<3; k++) begin: gen_dfx_tap_3_o_no_dsync
                   always_ff @(posedge tdr_ftap_tck or negedge side_rst_b)
                      if (~side_rst_b) // lintra s-70023
                         tap_fabric_ism_dsync[k] <= '0;
                      else
                         tap_fabric_ism_dsync[k] <= tap_fabric_ism[k];
                 end

                 always_ff @(posedge tdr_ftap_tck or negedge side_rst_b)
                    if (~side_rst_b) // lintra s-70023
                       tap_par_detect_dsync <= '0;
                    else
                       tap_par_detect_dsync <= tap_par_detect;

              end // block: gen_dfx_tap_no_dsync_b


        always_comb sbr_tdr_data_dfx[STAP_TDR_WIDTH_DFX-1:0] = {1'b0,tap_par_detect_dsync, tap_fabric_ism_dsync, tap_sai_src_ok_dsync[NP], tap_msg_ip_dsync[NP] , tap_cred_avail_dsync[NP], tap_opcode_dsync[NP], tap_dst_hier_id_dsync[NP], tap_src_hier_id_dsync[NP], tap_dst_id_dsync[NP], tap_src_id_dsync[NP], tap_sai_src_ok_dsync[PC], tap_msg_ip_dsync[PC] , tap_cred_avail_dsync[PC], tap_opcode_dsync[PC], tap_dst_hier_id_dsync[PC], tap_src_hier_id_dsync[PC], tap_dst_id_dsync[PC], tap_src_id_dsync[PC]};

    end // block gen_dfx_tap_inst
      else begin : gen_no_dfx_tap_inst
         always_comb sbr_tdr_data_dfx = {(STAP_TDR_WIDTH_DFX){1'b0}};
      end   
  endgenerate

//DFx ENhancement Feature - FINISH

// define this outside of global macro, HSD https://hsdes.intel.com/appstore/article/#/22011368758

 int ipc, inp, epc, enp;

//-----------------------------------------------------------------------------
//
// SV Assertions
//
//-----------------------------------------------------------------------------
`ifndef INTEL_SVA_OFF
`ifndef IOSF_SB_ASSERT_OFF
   `ifdef INTEL_SIMONLY
   //`ifdef INTEL_INST_ON // SynTranlateOff

  // Credit checks
  // coverage off
  //  int ipc, inp, epc, enp;
    always_ff @(posedge side_clk or negedge side_rst_b)
      if (~side_rst_b)
        begin
          ipc <= 0;
          inp <= 0;
          epc <= 0;
          enp <= 0;
        end 
      else if (credit_reinit)
        begin
          ipc <= 0;
          inp <= 0;
          epc <= 0;
          enp <= 0;
        end 
      else
        begin
          if (tpcput^tpccup)      ipc <= tpcput ? ipc-1 : ipc+1;
          if (tnpput^tnpcup)      inp <= tnpput ? inp-1 : inp+1;
          if (mpcput^mpccup)      epc <= mpcput ? epc-1 : epc+1;
          if (mnpput^mnpcup)      enp <= mnpput ? enp-1 : enp+1;
        end


    //
    // The following cover point detects the POK corner case 
    // that was the subject of HSD #1404071127, "POK completion error"
    //
       property pokb_and_enpirdy;
          @( posedge side_clk ) disable iff(!side_rst_b)
              ($fell(int_pok) && $rose(enpirdy));
       endproperty: pokb_and_enpirdy
       assert_pokb_and_enpirdy: cover property( pokb_and_enpirdy ); // else
           // $display( "%0t: %m: INFO POK CORNER CASE HIT: NP RECEIVED WHEN POK TRANSITIONS 1->0", $time );
  
        //clkgaten and clkgatedef assertion start jignasa
  
 //       cgctrl_clkgaten: //samassert
 //       assert property (@(posedge side_clk) disable iff (side_rst_b !== 1'b1)
 //           ($rose(!cfg_clkgaten)) |->  ( agent_clkena==0)) else
 //           $display("%0t: %m: ERROR: clk gate enable assertion check fail", $time);

        cgctrl_clkgatedef: //samassert
        assert property (@(posedge side_clk) disable iff (side_rst_b !== 1'b1)
            ($rose(cfg_clkgatedef) ) |-> ##[1:4](agent_clkena == 1) ) else
            $display("%0t: %m: ERROR: clk gate defeatures assertion check fail", $time);
   
 //       cgovr_clkgate_ovrd: //samassert
 //       assert property (@(posedge side_clk) disable iff (side_rst_b !== 1'b1)
 //           ($rose(jta_clkgate_ovrd) ) |->  (agent_clkena == 1) ) else
 //           $display("%0t: %m: ERROR: clk gate overide assertion check fail", $time); 

        //clkgaten and clkgatedef assertion end jignasa

        // parity assertion jignasa start

  //       cgctrl_parityckdef: // samassert jignasa 
  //       assert property (@(posedge side_clk) disable iff (side_rst_b !== 1'b1) 
  //          ($rose(parity_err_out)) |-> (cfg_parityckdef == 0) ) else
  //           $display("%0t: %m: ERROR: defeature parity check,error is detected\n", $time);

        // parity assertion jignasa end

         // all other assertion jignasa start

           // jtag_force_idle: //samassert //jignasa commented
    //assert property (@(posedge side_clk) disable iff (side_rst_b !== 1'b1)
      //  ($rose(force_idle_ff) && (ism_is_agent==1'b1) && (side_ism_out==ISM_AGENT_ACTIVE)) |-> ( (side_ism_out==ISM_AGENT_ACTIVE) ##20 (side_ism_out==ISM_AGENT_IDLE) )) else
      //  $display("%0t: %m: ERROR: Sideband Jtag force idle problem: Agent ISM Did not move to IDLE", $time);



 jtag_force_idle: //samassert 
     assert property (@(posedge side_clk) disable iff (side_rst_b !== 1'b1)
        ($rose(force_idle_ff) && (ism_is_agent==1'b1) && (side_ism_out==ISM_AGENT_ACTIVE)) |-> ((side_ism_out==ISM_AGENT_ACTIVE) ##[1:$] (side_ism_out==ISM_AGENT_IDLE) )) else
        $display("%0t: %m: ERROR: Sideband Jtag force idle problem: Agent ISM Did not move to IDLE", $time);


   //      jtag_crdreq_idle_agt: //samassert
   // assert property (@(posedge side_clk) disable iff (side_rst_b !== 1'b1)
   //     ($rose(force_creditreq_ff) && (ism_is_agent==1'b1) && (side_ism_out==ISM_AGENT_IDLE)) |-> ( (side_ism_out==ISM_AGENT_IDLE) ##1 (side_ism_out==ISM_AGENT_CREDITREQ) )) else
    //    $display("%0t: %m: ERROR: Sideband Jtag force clock req problem: Agent ISM Did not move to Clock Req", $time);
 
    //jtag_crdreq_idle_fab: //samassert
    //assert property (@(posedge side_clk) disable iff (side_rst_b !== 1'b1)
     //   ($rose(force_creditreq_ff) && (ism_is_agent==1'b0) && (side_ism_out==ISM_FABRIC_IDLE)) |-> ( (side_ism_out==ISM_FABRIC_IDLE) ##1 (side_ism_out==ISM_FABRIC_CREDITREQ) )) else
       // $display("%0t: %m: ERROR: Sideband Jtag force clock req problem: Fabric ISM Did not move to Clock Req", $time);

      //  jtag_notidle_idle_agt: //samassert
   // assert property (@(posedge side_clk) disable iff (side_rst_b !== 1'b1)
     //   ($rose(force_notidle_ff) && (ism_is_agent==1'b1) && (side_ism_out==ISM_AGENT_IDLEREQ)) |-> ( (side_ism_out==ISM_AGENT_IDLEREQ) ##1 (side_ism_out==ISM_AGENT_ACTIVE) )) else
       // $display("%0t: %m: ERROR: Sideband Jtag force clock req problem: Agent ISM Did not move to ACTIVE", $time);
 
   // jtag_notidle_idle_fab: //samassert
   // assert property (@(posedge side_clk) disable iff (side_rst_b !== 1'b1)
     //   ($rose(force_notidle_ff) && (ism_is_agent==1'b0) && (side_ism_out==ISM_FABRIC_IDLENAK) ) |-> ( (side_ism_out==ISM_FABRIC_IDLENAK) ##1 (side_ism_out==ISM_FABRIC_ACTIVE) )) else
       // $display("%0t: %m: ERROR: Sideband Jtag force clock req problem: Fabric ISM Did not move to ACTIVE", $time);
        
        // all other assertion jignasa end

    ing_pc_credit_idle: //samassert
    assert property (@(posedge side_clk) disable iff (side_rst_b !== 1'b1)
        ( (side_ism_out!=ISM_FABRIC_IDLE) ##1 (side_ism_out==ISM_FABRIC_IDLE) ) |->
        ( ( (ism_is_agent==1'b0) ) ? (ipc==PCQUEUEDEPTH) : 1'b1 ) ) else
        $display("%0t: %m: ERROR: Sideband credit problem: fabric did not return all pc credits before going idle", $time);

    ing_np_credit_idle: //samassert
    assert property (@(posedge side_clk) disable iff (side_rst_b !== 1'b1)
        ( (side_ism_out!=ISM_FABRIC_IDLE) ##1 (side_ism_out==ISM_FABRIC_IDLE) ) |->
        ( ( (ism_is_agent==1'b0) ) ? (inp==NPQUEUEDEPTH) : 1'b1 ) ) else
        $display("%0t: %m: ERROR: Sideband credit problem: fabric did not return all np credits before going idle", $time);

    ing_pc_credit_underflow: //samassert
    assert property (@(posedge side_clk) disable iff (side_rst_b !== 1'b1)
        tpcput |-> (ipc!=0) ) else
        $display("%0t: %m: ERROR: Sideband credit problem: too many tpcput assertions", $time);

    ing_pc_credit_overflow: //samassert
    assert property (@(posedge side_clk) disable iff (side_rst_b !== 1'b1)
        tpccup |-> (ipc!=PCQUEUEDEPTH) ) else
        $display("%0t: %m: ERROR: Sideband credit problem: too many tpccup assertions", $time);

    ing_np_credit_underflow: //samassert
    assert property (@(posedge side_clk) disable iff (side_rst_b !== 1'b1)
        tnpput |-> (inp!=0) ) else
        $display("%0t: %m: ERROR: Sideband credit problem: too many tnpput assertions", $time);

    ing_np_credit_overflow: //samassert
    assert property (@(posedge side_clk) disable iff (side_rst_b !== 1'b1)
        tnpcup |-> (inp!=NPQUEUEDEPTH) ) else
        $display("%0t: %m: ERROR: Sideband credit problem: too many tnpcup assertions", $time);

    egr_pc_credit_underflow: //samassert
    assert property (@(posedge side_clk) disable iff (side_rst_b !== 1'b1)
        mpcput |-> (epc!=0) ) else
        $display("%0t: %m: ERROR: Sideband credit problem: too many mpcput assertions", $time);

      // disabling this assertion, as it is not an error condition.
    egr_pc_credit_overflow: //samassert
    assert property (@(posedge side_clk) disable iff (1'b1)
        mpccup |-> (epc!=SBCMAXQUEUEDEPTH) ) else
`ifndef IOSF_SB_ASSERT_VERBOSE
      if ( 0 )
`endif
        $info("%0t: %m: WARNING: Sideband credit problem: too many mpccup assertions", $time);

    egr_np_credit_underflow: //samassert
    assert property (@(posedge side_clk) disable iff (side_rst_b !== 1'b1)
        mnpput |-> (enp!=0) ) else
        $display("%0t: %m: ERROR: Sideband credit problem: too many mnpput assertions", $time);

      // disabling this assertion, as it is not an error condition.
    egr_np_credit_overflow: //samassert
    assert property (@(posedge side_clk) disable iff (1'b1)
        mnpcup |-> (enp!=SBCMAXQUEUEDEPTH) ) else
`ifndef IOSF_SB_ASSERT_VERBOSE
      if ( 0 )
`endif
        $info("%0t: %m: WARNING: Sideband credit problem: too many mnpcup assertions", $time);
      
    // Ordering Check (Fencing Mechanism)
    np_fencing_mechanism: //samassert
    assert property (@(posedge side_clk) disable iff (side_rst_b !== 1'b1)
        (npirdy & nptrdy) |-> !npfence ) else
        $display("%0t: %m: ERROR: Sideband ingress queue fencing meschansim ignored", $time);

    // Check that both puts do not occur in the same cycle
    both_inmsg_puts_asserted: //samassert
    assert property (@(posedge side_clk) disable iff (side_rst_b !== 1'b1)
        ~(tpcput & tnpput) ) else
        $display("%0t: %m: ERROR: Sideband tpcput and tnpput are both asserted", $time);
    
    both_outmsg_puts_asserted: //samassert
    assert property (@(posedge side_clk) disable iff (side_rst_b !== 1'b1)
        ~(mpcput & mnpput) ) else
        $display("%0t: %m: ERROR: Sideband mpcput and mnpput are both asserted", $time);
    
    // Check that the put/cups are only asserted ACTIVE (or IDLE_NAK for fabric) state.
    tpcput_ism_not_active: //samassert
    assert property (@(posedge side_clk) disable iff (side_rst_b !== 1'b1)
        tpcput |-> (ism_is_agent==1'b0) ? (side_ism_in==ISM_AGENT_ACTIVE) :
                                      ((side_ism_in==ISM_FABRIC_ACTIVE) | 
                                       (side_ism_in==ISM_FABRIC_IDLENAK)) ) else
        $display("%0t: %m: ERROR: Sideband tpcput asserted while ISM not in ACTIVE state\n", $time);
    
    tnpput_ism_not_active: //samassert
    assert property (@(posedge side_clk) disable iff (side_rst_b !== 1'b1)
        tnpput |-> (ism_is_agent==1'b0) ? (side_ism_in==ISM_AGENT_ACTIVE) :
                                      ((side_ism_in==ISM_FABRIC_ACTIVE) | 
                                       (side_ism_in==ISM_FABRIC_IDLENAK)) ) else
        $display("%0t: %m: ERROR: Sideband tnpput asserted while ISM not in ACTIVE state\n", $time);
    
    mpccup_ism_not_active: //samassert
    assert property (@(posedge side_clk) disable iff (side_rst_b !== 1'b1)
        mpccup      |-> (ism_is_agent==1'b0) ? ((side_ism_in==ISM_AGENT_ACTIVE)     | 
                                            (side_ism_in==ISM_AGENT_CREDITINIT) |
                                            (side_ism_in==ISM_AGENT_CREDITDONE)  ) : 
                                           ((side_ism_in==ISM_FABRIC_ACTIVE)    |
                                            (side_ism_in==ISM_FABRIC_IDLENAK)   |
                                            (side_ism_in==ISM_FABRIC_CREDITINIT) ) ) else
        $display("%0t: %m: ERROR: Sideband mpccup asserted while ISM not in ACTIVE state\n", $time);
    
    mnpcup_ism_not_active: //samassert
    assert property (@(posedge side_clk) disable iff (side_rst_b !== 1'b1)
        mnpcup      |-> (ism_is_agent==1'b0) ? ((side_ism_in==ISM_AGENT_ACTIVE)     | 
                                            (side_ism_in==ISM_AGENT_CREDITINIT) |
                                            (side_ism_in==ISM_AGENT_CREDITDONE)  ) : 
                                           ((side_ism_in==ISM_FABRIC_ACTIVE)    |
                                            (side_ism_in==ISM_FABRIC_IDLENAK)   |
                                            (side_ism_in==ISM_FABRIC_CREDITINIT) ) ) else
        $display("%0t: %m: ERROR: Sideband mnpcup asserted while ISM not in ACTIVE state\n", $time);
    
    mpcput_ism_not_active: //samassert
    assert property (@(posedge side_clk) disable iff (side_rst_b !== 1'b1)
        mpcput |-> (ism_is_agent==1'b0) ? ((side_ism_out==ISM_FABRIC_ACTIVE)    | 
                                       (side_ism_out==ISM_FABRIC_IDLENAK) ) : 
                                      (side_ism_out==ISM_AGENT_ACTIVE) ) else
        $display("%0t: %m: ERROR: Sideband mpcput asserted while ISM not in ACTIVE state\n", $time);
    
    mnpput_ism_not_active: //samassert
    assert property (@(posedge side_clk) disable iff (side_rst_b !== 1'b1)
        mnpput |-> (ism_is_agent==1'b0) ? ((side_ism_out==ISM_FABRIC_ACTIVE)    | 
                                       (side_ism_out==ISM_FABRIC_IDLENAK) ) : 
                                      (side_ism_out==ISM_AGENT_ACTIVE) ) else
        $display("%0t: %m: ERROR: Sideband mnpput asserted while ISM not in ACTIVE state\n", $time);
    
    tpccup_ism_not_active: //samassert
    assert property (@(posedge side_clk) disable iff (side_rst_b !== 1'b1)
        tpccup      |-> (ism_is_agent==1'b0) ? ((side_ism_out==ISM_FABRIC_ACTIVE)    | 
                                            (side_ism_out==ISM_FABRIC_IDLENAK)   |
                                            (side_ism_out==ISM_FABRIC_CREDITINIT) ) : 
                                           ((side_ism_out==ISM_AGENT_ACTIVE)     |
                                            (side_ism_out==ISM_AGENT_CREDITINIT)  ) ) else
        $display("%0t: %m: ERROR: Sideband tpccup asserted while ISM not in ACTIVE state\n", $time);
    
    tnpcup_ism_not_active: //samassert
    assert property (@(posedge side_clk) disable iff (side_rst_b !== 1'b1)
        tnpcup      |-> (ism_is_agent==1'b0) ? ((side_ism_out==ISM_FABRIC_ACTIVE)    | 
                                            (side_ism_out==ISM_FABRIC_IDLENAK)   |
                                            (side_ism_out==ISM_FABRIC_CREDITINIT) ) : 
                                           ((side_ism_out==ISM_AGENT_ACTIVE)     |
                                            (side_ism_out==ISM_AGENT_CREDITINIT)  ) ) else
        $display("%0t: %m: ERROR: Sideband tnpcup asserted while ISM not in ACTIVE state\n", $time);

   parity_err_condition:
   assert property (@(posedge side_clk) disable iff ((side_rst_b !== 1'b1) || ENDPOINTONLY == 1)
       (cfg_parityckdef == 0 &&  parity_err_out == 1 ) |=> (((!$rose(pcirdy)) && (!$rose(npirdy)) && tpccup == 0 && tnpcup == 0) throughout (side_rst_b == 1'b1))) else
      $display("%0t: %m: ERROR: cup or put is seen while parity error is detected\n", $time);     
  // coverage on
   `endif // SynTranlateOn
`endif
`endif
      
endmodule

// lintra pop
