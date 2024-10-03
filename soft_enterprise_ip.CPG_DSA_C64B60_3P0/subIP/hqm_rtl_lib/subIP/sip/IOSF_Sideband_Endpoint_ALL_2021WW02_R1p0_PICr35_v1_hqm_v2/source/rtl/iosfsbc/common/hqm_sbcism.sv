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
//  Module sbcism : Clock gating ISM
//
//------------------------------------------------------------------------------


// lintra push -60026, -60020, -68001, -60024b, -60024a, -70036_simple

module hqm_sbcism #(
   parameter ISMISIP  = 0,
   parameter ISM_ASSERT_EN = 0,
   parameter SKIP_ACTIVEREQ = 0,
   parameter CG_DELAY = 0,
   parameter CG_DELAY_STRAP_EN = 0
) (
   input logic        int_pok,
   input logic        port_disable,
   input logic        clk,             // Clock
   input logic        rst_b,           // Reset (active low)
   input logic        force_creditreq, 
   input logic        idle,            // Idle limit reached for initiating clk gating
   input logic        ip_wake,         // lintra s-0527, s-70036 "a wake event occured."
   input logic        init_done,
   input logic        nak_idlereq,     // lintra s-0527, s-70036
   input logic        side_ism_lock_b, // SBC-PCN-002 - Sideband ISM Lock
   input logic        side_clk_valid,
   input logic [3:0]  cg_delay_width_strap, // lintra s-0527 "only when CG_DELAY is enabled"
   output logic       cg_en,           // SBC-PCN-004 - Clock gate enable for PCG
   output logic       cg_en_visa,      // Replicate the cg_en flop for KBP VISA PCR HSD 1204977900
   input  logic       parity_err,

   input logic  [2:0] ism_in,          // adjacent Clock Gating ISM state
   output logic [2:0] ism_out,         // local Clock Gating ISM state

   output logic       credit_reinit,   // indication to reinitialize credit counters.

   output logic       ip_ism_active,   
   output logic       ip_ism_activereq,
   output logic       ip_ism_idle,
   output logic       ip_ism_idlereq,
   output logic       ip_ism_creditreq,
   output logic       ip_ism_creditinit,
   output logic       ip_ism_creditdone,
   output logic       fabric_ism_active,   
   output logic       fabric_ism_activereq,
   output logic       fabric_ism_idle,
   output logic       fabric_ism_idlenak,
   output logic       fabric_ism_creditreq,
   output logic       fabric_ism_creditack,
   output logic       fabric_ism_creditinit
);

`include "hqm_sbcglobal_params.vm"
`include "hqm_sbcfunc.vm"
 
// CG_EN PCR


localparam CG_CNTR_EN = ((CG_DELAY_STRAP_EN != 0) || (CG_DELAY != 0)) ? 1 : 0;
localparam CG_EN_CNTR_WIDTH = CG_DELAY_STRAP_EN ? 3 : sbc_logb2(CG_DELAY);

logic[CG_EN_CNTR_WIDTH:0] cg_delay_width_int;
logic[CG_EN_CNTR_WIDTH:0] cg_en_cntr;
logic cg_cntr_rdy;
logic cg_cntr_loaded;

always_comb cg_delay_width_int = |CG_DELAY_STRAP_EN ? cg_delay_width_strap : CG_DELAY;
always_comb cg_cntr_rdy = (cg_en_cntr == '0); 
  //==============================================================================
  // Clock gating ISM
  //==============================================================================
  
    generate
        if (ISMISIP == 1) begin : gen_agent_ism
            always_ff @(posedge clk or negedge rst_b) begin
            if (~rst_b) begin // lintra s-70023
                ism_out       <= ISM_AGENT_IDLE;
                credit_reinit <= 1'b1;
                cg_en         <= 1'b0; // SBC-PCN-004 - Clock gate enable for the PCG to turn on the receivers clock.
                cg_en_visa    <= 1'b0; // Replicate the cg_en flop for KBP VISA PCR HSD 1204977900
                cg_en_cntr    <= '0;
                cg_cntr_loaded<= 1'b0;
            end
            else begin
                casez (ism_out) // lintra s-60129
                    ISM_AGENT_IDLE: begin
                            if (|CG_CNTR_EN) begin
               // cntr_loaded takes 1 clock to be set, so the cntr shouldnt be loaded with delay-1, it should be loaded with delay itself
               // when rtr+pgcb, the clock is not available until after ism is already in idle and ready to move to creditreq (or any other state)
               // gating that with "loaded" signal will fix the issue
                                if (cg_cntr_loaded == 1'b0) begin
                                    cg_en_cntr <= cg_delay_width_int;
                                    cg_cntr_loaded <= 1'b1;
                                end
                            end
                            else begin
                                cg_cntr_loaded <= 1'b1;
                                cg_en_cntr <= '0;
                            end
                            if (port_disable) begin
                                ism_out <= ISM_AGENT_IDLE;
                            end else if( int_pok &&                   // Connected port is powered down
                                side_ism_lock_b &&                    // SBC-PCN-002 - ISM should not update if the lock is active
                                ( (ism_in == ISM_FABRIC_CREDITREQ) || // External request for credit reinitialization
                                  force_creditreq ||                  // JTAG forced credit request do this when ready
                                  ( credit_reinit &&                  // Internal request for credit reinitialization
                                    side_clk_valid ) ) ) begin        // Cannot do this until the clock is ready for everyone
                                if ( (|CG_CNTR_EN) && (cg_en_cntr != '0) && cg_cntr_loaded)
                                    cg_en_cntr <= cg_en_cntr -1'b1;
                                if (cg_cntr_rdy && cg_cntr_loaded)// CG Delay PCR 
                                    ism_out <= ISM_AGENT_CREDITREQ;
// SBC-PCN-004 - Clock gate enable for the PCG to turn on receivers clock. - START
// if( ism_in == ISM_FABRIC_IDLE ) begin
                                cg_en      <= 1'b1;
                                cg_en_visa <= 1'b1; // Replicate the cg_en flop for KBP VISA PCR HSD 1204977900
// end
// SBC-PCN-004 - Clock gate enable for the PCG to turn on receivers clock. - FINISH
                            end else if( int_pok &&                            // Connected port is powered down
                                         ~credit_reinit &&                     // No credit reinitialization requested
                                         side_ism_lock_b &&                    // SBC-PCN-002 - ISM should not update if the lock is active
                                         ( (ism_in == ISM_FABRIC_ACTIVEREQ) || // External Active request
                                            ( ip_wake &&                        // Internal request for activity
                                             (ism_in == ISM_FABRIC_IDLE) &&    // External ISM is IDLE
                                               side_clk_valid ) ) ) begin        // Wait for the clock to be valid
                                if ( (|CG_CNTR_EN) && (cg_en_cntr != '0) && cg_cntr_loaded)
                                    cg_en_cntr <= cg_en_cntr -1'b1;
                                if (cg_cntr_rdy && cg_cntr_loaded) begin  // CG Delay PCR
                                    if ( |SKIP_ACTIVEREQ &&                 // SKIP the ACTIVE REQUEST stage
                                        (ism_in == ISM_FABRIC_ACTIVEREQ) ) // External Fabric is already requesting ACTIVE
                                        ism_out <= ISM_AGENT_ACTIVE;
                                    else
                                        ism_out <= ISM_AGENT_ACTIVEREQ;
                                end
// SBC-PCN-004 - Clock gate enable for the PCG to turn on receivers clock. - START
// if( ism_in == ISM_FABRIC_IDLE ) begin
                                cg_en      <= 1'b1; 
                                cg_en_visa <= 1'b1; // Replicate the cg_en flop for KBP VISA PCR HSD 1204977900
// end
// SBC-PCN-004 - Clock gate enable for the PCG to turn on receivers clock. - FINISH
                            end else
                                ism_out <= ISM_AGENT_IDLE;
                        end //case ISM_AGENT_IDLE
                    ISM_AGENT_ACTIVEREQ:
// SBC-PCN-001 - Fabric agent ports should go back to IDLE in the event that
// POK is de-asserted on, router to router connections - START
                            if( !int_pok ) begin // Connected port is powered down
                                ism_out    <= ISM_AGENT_IDLE;
                                if ( (|CG_CNTR_EN) && (cg_delay_width_int != '0) )
                                    cg_en_cntr <= cg_delay_width_int - 1'b1;
                                cg_en      <= 1'b0; // SBC-PCN-004 - Disable clock gate enable when returning to IDLE.
                                cg_en_visa <= 1'b0; // Replicate the cg_en flop for KBP VISA PCR HSD 1204977900
                            end else if (ism_in == ISM_FABRIC_ACTIVEREQ) // External request/acknowledge of ACTIVE REQ
// SBC-PCN-001 - Fabric agent ports should go back to IDLE in the event that
// POK is de-asserted on, router to router connections - FINISH
                                ism_out <= ISM_AGENT_ACTIVE;
                            else if (ism_in == ISM_FABRIC_CREDITREQ) // External request for CREDIT REQ
                                ism_out <= ISM_AGENT_CREDITREQ;
                            else
                                ism_out <= ISM_AGENT_ACTIVEREQ;

                    ISM_AGENT_ACTIVE:
                            if (parity_err)
                                ism_out <= ISM_AGENT_ACTIVE;       // Upon parity error, park the agent ISM in ACTIVE 
                            else if( idle &&                          // self is idle
                                    (ism_in == ISM_FABRIC_ACTIVE) && // External ISM is ACTIVE
                                      side_clk_valid )                 // The clock is valid
                                ism_out <= ISM_AGENT_IDLEREQ;
                            else
                                ism_out <= ISM_AGENT_ACTIVE;

                    ISM_AGENT_IDLEREQ:
                            if (ism_in == ISM_FABRIC_IDLE) begin    // External ISM is IDLE
                                ism_out    <= ISM_AGENT_IDLE;
                                if ( (|CG_CNTR_EN) && (cg_delay_width_int != '0) )
                                    cg_en_cntr <= cg_delay_width_int - 1'b1;                                
                                cg_en      <= 1'b0; // SBC-PCN-004 - Disable clock gate enable when returning to IDLE
                                cg_en_visa <= 1'b0; // Replicate the cg_en flop for KBP VISA PCR HSD 1204977900
                            end else if (ism_in == ISM_FABRIC_IDLENAK) // External ISM is Naking the IDLE REQ
                                ism_out <= ISM_AGENT_ACTIVE;
                            else
                                ism_out <= ISM_AGENT_IDLEREQ;

                    ISM_AGENT_CREDITREQ:
// SBC-PCN-001 - Fabric agent ports should go back to IDLE in the event that
// POK is de-asserted on, router to router connections - START
                            if( !int_pok ) begin // Connected port is powered down
                                ism_out    <= ISM_AGENT_IDLE;
                                if ( (|CG_CNTR_EN) && (cg_delay_width_int != '0) )
                                    cg_en_cntr <= cg_delay_width_int - 1'b1;
                                cg_en      <= 1'b0; // SBC-PCN-004 - Disable clock gate enable when returning to IDLE
                                cg_en_visa <= 1'b0; // Replicate the cg_en flop for KBP VISA PCR HSD 1204977900
                            end else if (ism_in == ISM_FABRIC_CREDITACK) begin // External ISM is ACK to the CREDITREQ
// SBC-PCN-001 - Fabric agent ports should go back to IDLE in the event that
// POK is de-asserted on, router to router connections - FINISH
                                ism_out <= ISM_AGENT_CREDITINIT;
                                credit_reinit <= 1'b1;
                            end else 
                                ism_out <= ISM_AGENT_CREDITREQ;

                    ISM_AGENT_CREDITINIT: begin
                            credit_reinit <= 1'b0;
                            if ( init_done &&                         // Credit init is done
                                (ism_in == ISM_FABRIC_CREDITINIT) && // External ISM is CREDITINIT
                                side_clk_valid )                     // The clock is valid
                                ism_out <= ISM_AGENT_CREDITDONE;
                            else 
                                ism_out <= ISM_AGENT_CREDITINIT;
                            end

                    ISM_AGENT_CREDITDONE:
                            if (ism_in == ISM_FABRIC_IDLE) begin // External ISM is IDLE
                                ism_out    <= ISM_AGENT_IDLE;
                                if ( (|CG_CNTR_EN) && (cg_delay_width_int != '0) )
                                    cg_en_cntr <= cg_delay_width_int - 1'b1;                                
                                cg_en      <= 1'b0; // SBC-PCN-004 - Disable clock gate enable when returning to IDLE
                                cg_en_visa <= 1'b0; // Replicate the cg_en flop for KBP VISA PCR HSD 1204977900
                            end else 
                                ism_out <= ISM_AGENT_CREDITDONE;

                    default: ism_out <= ism_out; // this should never happen!
                endcase
            end // else: !if(~rst_b)
        end // always_ff @ (posedge clk or negedge rst_b)
    end // block: gen_agent_ism
    else begin : gen_fabric_ism
        always_ff @(posedge clk or negedge rst_b) begin
            if (~rst_b) begin // lintra s-70023
                ism_out       <= ISM_FABRIC_IDLE;
                credit_reinit <= 1'b1;
                cg_en         <= 1'b0; // SBC-PCN-004 - Clock Gate enable for PCG
                cg_en_visa    <= 1'b0; // Replicate the cg_en flop for KBP VISA PCR HSD 1204977900
                cg_en_cntr    <= '0;
                cg_cntr_loaded<= '0;
            end else  begin
                //=============================================================================
                // The Fabric ISM
                //=============================================================================
                casez (ism_out) // lintra s-60129
                    ISM_FABRIC_IDLE: begin
                            if (|CG_CNTR_EN) begin
               // cntr_loaded takes 1 clock to be set, so the cntr shouldnt be loaded with delay-1, it should be loaded with delay itself
                                if (cg_cntr_loaded == 1'b0) begin
                                    cg_en_cntr <= cg_delay_width_int;
                                    cg_cntr_loaded <= 1'b1;
                                end
                            end
                            else begin
                                cg_cntr_loaded <= 1'b1;
                                cg_en_cntr <= '0;
                            end 
                            if (port_disable) begin
                                ism_out <= ISM_FABRIC_IDLE;
                            end else if ( int_pok &&                        // Connected Port is Powered Up
                                side_ism_lock_b &&                          // SBC-PCN-002 - Cannot leave idle when the side_ism_lock is enabled
                                ( force_creditreq ||                        // JTAG force of credit request
                                    ( credit_reinit &&                        // Internal event to request credits
                                      side_clk_valid ) ||                     // Side clock is valid
                                       (ism_in == ISM_AGENT_CREDITREQ) ) ) begin // External ISM Credit Request
                                if ( (|CG_CNTR_EN) && (cg_en_cntr != '0) && cg_cntr_loaded)
                                    cg_en_cntr <= cg_en_cntr -1'b1;                                       
                                if (cg_cntr_rdy && cg_cntr_loaded)
                                    ism_out <= ISM_FABRIC_CREDITREQ;
// SBC-PCN-004 - Clock gate enable for the PCG to turn on receivers clock. - START
                      // if( ism_in == ISM_AGENT_IDLE ) begin
                                cg_en      <= 1'b1;
                                cg_en_visa <= 1'b1; // Replicate the cg_en flop for KBP VISA PCR HSD 1204977900
                      // end
// SBC-PCN-004 - Clock gate enable for the PCG to turn on receivers clock. - FINISH
                            end else if ( int_pok &&                            // Connected Port is Powered Up
                                          !credit_reinit &&  // HSD #1205891276, "RTL and IOSF spec mismatch on SB ISM transition from IDLE to ACTIVE_REQ"
                                          side_ism_lock_b &&                    // SBC-PCN-002 - Cannot leave idle when the side_ism_lock is enabled
                                          ( ( !idle &&                          // Port has something to send
                                              (ism_in == ISM_AGENT_IDLE) &&     // Agent is IDLE
                                                side_clk_valid ) ||               // Side clock is valid
                                                (ism_in == ISM_AGENT_ACTIVEREQ) ) ) begin // External ISM is requesting ACTIVITY
                                if ( (|CG_CNTR_EN) && (cg_en_cntr != '0) && cg_cntr_loaded)
                                    cg_en_cntr <= cg_en_cntr -1'b1;                                                
                                if (cg_cntr_rdy && cg_cntr_loaded)
                                    ism_out <= ISM_FABRIC_ACTIVEREQ;
// SBC-PCN-004 - Clock gate enable for the PCG to turn on receivers clock. - START
                      // if( ism_in == ISM_AGENT_IDLE ) begin
                                cg_en      <= 1'b1;
                                cg_en_visa <= 1'b1; // Replicate the cg_en flop for KBP VISA PCR HSD 1204977900
                      // end
// SBC-PCN-004 - Clock gate enable for the PCG to turn on receivers clock. - FINISH
                            end else
                                ism_out <= ISM_FABRIC_IDLE;
                        end // case ISM_FABRIC_IDLE
                    ISM_FABRIC_ACTIVEREQ: 
// SBC-PCN-001 - ECN 290 - ACTIVEREQ to IDLE when int_pok de-asserted. - START
                            if( !int_pok ) begin // Connected Port is Powered Down
                                ism_out    <= ISM_FABRIC_IDLE;
                                if ( (|CG_CNTR_EN) && (cg_delay_width_int != '0) )
                                    cg_en_cntr <= cg_delay_width_int - 1'b1;                                
                                cg_en      <= 1'b0; // SBC-PCN-004 - Disable the clock gate enable when returning to IDLE
                                cg_en_visa <= 1'b0; // Replicate the cg_en flop for KBP VISA PCR HSD 1204977900
                            end else if (ism_in == ISM_AGENT_ACTIVE) // External ISM is ACTIVE
// SBC-PCN-001 - ECN 290 - ACTIVEREQ to IDLE when int_pok de-asserted. - FINISH
                                ism_out <= ISM_FABRIC_ACTIVE;
                            else if (ism_in == ISM_AGENT_CREDITREQ) // External ISM is CREDITREQ
                                ism_out <= ISM_FABRIC_CREDITREQ;
                            else
                                ism_out <= ISM_FABRIC_ACTIVEREQ;
                  
                    ISM_FABRIC_ACTIVE:
                            if (parity_err)
                                ism_out <= ISM_FABRIC_IDLENAK;       // Upon parity error, park the fabric ISM in IDLENAK
                            else if (ism_in == ISM_AGENT_IDLEREQ) begin
                                if( nak_idlereq ) // NAK the Agents IDLE REQ
                                    ism_out <= ISM_FABRIC_IDLENAK;
                                else begin
                                    ism_out    <= ISM_FABRIC_IDLE;
                                    if ( (|CG_CNTR_EN) && (cg_delay_width_int != '0) )
                                        cg_en_cntr <= cg_delay_width_int - 1'b1;                                    
                                    cg_en      <= 1'b0; // SBC-PCN-004 - Disable the clock gate enable when returning to IDLE
                                    cg_en_visa <= 1'b0; // Replicate the cg_en flop for KBP VISA PCR HSD 1204977900
                                end
                            end else
                                ism_out <= ISM_FABRIC_ACTIVE;
                  
                    ISM_FABRIC_IDLENAK:
                            if (parity_err)
                                ism_out <= ISM_FABRIC_IDLENAK;     // Upon parity error, park the fabric ISM in IDLENAK
                            else if( ism_in == ISM_AGENT_ACTIVE ) // External ISM is ACTIVE
                                ism_out <= ISM_FABRIC_ACTIVE;
                            else
                                ism_out <= ISM_FABRIC_IDLENAK;
                  
                    ISM_FABRIC_CREDITREQ:
// SBC-PCN-001 - ECN 290 - CREDITREQ to IDLE when int_pok de-asserted. - START
                            if( !int_pok ) begin // Connected port is powered down
                                ism_out    <= ISM_FABRIC_IDLE;
                                if ( (|CG_CNTR_EN) && (cg_delay_width_int != '0) )
                                    cg_en_cntr <= cg_delay_width_int - 1'b1;                                
                                cg_en      <= 1'b0; // SBC-PCN-004 - Disable the clock gate enable when returning to IDLE
                                cg_en_visa <= 1'b0; // Replicate the cg_en flop for KBP VISA PCR HSD 1204977900
                            end else
// SBC-PCN-001 - ECN 290 - CREDITREQ to IDLE when int_pok de-asserted. - FINISH
                            if (ism_in == ISM_AGENT_CREDITREQ) begin// External ISM is CREDITREQ
                                ism_out  <= ISM_FABRIC_CREDITACK;
                                credit_reinit <= 1'b1;
                            end  else
                                ism_out <= ISM_FABRIC_CREDITREQ;
                  
                    ISM_FABRIC_CREDITACK: begin
                                credit_reinit <= 1'b0;
                                if (ism_in == ISM_AGENT_CREDITINIT)
                                    ism_out    <= ISM_FABRIC_CREDITINIT;
                                else
                                    ism_out    <= ISM_FABRIC_CREDITACK;
                                end 
                    ISM_FABRIC_CREDITINIT:
                                if ((ism_in == ISM_AGENT_CREDITDONE) & init_done) begin
                                    ism_out    <= ISM_FABRIC_IDLE;
                                    if ( (|CG_CNTR_EN) && (cg_delay_width_int != '0) )
                                       cg_en_cntr <= cg_delay_width_int - 1'b1;
                                    cg_en      <= 1'b0; // SBC-PCN-004 - Disable the clock gate enable when returning to IDLE
                                    cg_en_visa <= 1'b0; // Replicate the cg_en flop for KBP VISA PCR HSD 1204977900
                                end else
                                    ism_out    <= ISM_FABRIC_CREDITINIT;

                    default: ism_out <= ism_out; // this should never happen!
                endcase
            end // else: !if(~rst_b)
        end // always_ff @ (posedge clk or negedge rst_b)
    end // block: gen_fabric_ism
    endgenerate
  
//=============================================================================
//   IP ISM Logic
//=============================================================================
always_comb ip_ism_active     = |ISMISIP ? (ism_out == ISM_AGENT_ACTIVE) : (ism_in == ISM_AGENT_ACTIVE);
always_comb ip_ism_activereq  = (ism_out == ISM_AGENT_ACTIVEREQ) & (ISMISIP == 1);
always_comb ip_ism_idle       = (ism_out == ISM_AGENT_IDLE) & (ISMISIP == 1);
always_comb ip_ism_idlereq    = (ism_out == ISM_AGENT_IDLEREQ) & (ISMISIP == 1);
always_comb ip_ism_creditreq  = (ism_out == ISM_AGENT_CREDITREQ) & (ISMISIP == 1);
always_comb ip_ism_creditinit = (ism_out == ISM_AGENT_CREDITINIT) & (ISMISIP == 1);
always_comb ip_ism_creditdone = (ism_out == ISM_AGENT_CREDITDONE) & (ISMISIP == 1);

//=============================================================================
//   Fabric ISM Logic
//=============================================================================
always_comb fabric_ism_active     = (ism_out == ISM_FABRIC_ACTIVE) & (ISMISIP == 0);
always_comb fabric_ism_activereq  = (ism_out == ISM_FABRIC_ACTIVEREQ) & (ISMISIP == 0);
always_comb fabric_ism_idle       = (ism_out == ISM_FABRIC_IDLE) & (ISMISIP == 0);
always_comb fabric_ism_idlenak    = (ism_out == ISM_FABRIC_IDLENAK) & (ISMISIP == 0);
always_comb fabric_ism_creditreq  = (ism_out == ISM_FABRIC_CREDITREQ) & (ISMISIP == 0);
always_comb fabric_ism_creditack  = (ism_out == ISM_FABRIC_CREDITACK) & (ISMISIP == 0);
always_comb fabric_ism_creditinit = (ism_out == ISM_FABRIC_CREDITINIT) & (ISMISIP == 0);

// SV ASSERTIONS
`ifndef INTEL_SVA_OFF
`ifndef IOSF_SB_ASSERT_OFF
   `ifdef INTEL_SIMONLY
   //`ifdef INTEL_INST_ON // SynTranlateOff
  // coverage off

  logic [2:0] prev_agent_ism_state, prev_fabric_ism_state, agent_ism_state, fabric_ism_state;
  logic prev_int_pok, prev_int_pok_f;

  always @(posedge clk or negedge rst_b)
    begin
      if (ISMISIP)
        begin
          if (~rst_b)
            begin
              prev_fabric_ism_state <= ISM_FABRIC_IDLE;
              fabric_ism_state      <= ISM_FABRIC_IDLE;
              prev_int_pok_f        <= 1'b1;
              prev_int_pok          <= 1'b1;
            end
          else
            begin
              prev_fabric_ism_state <= fabric_ism_state;
              fabric_ism_state <= ism_in;
              prev_int_pok_f   <= int_pok;
              prev_int_pok      <= prev_int_pok_f;
            end
        end
      else
        begin
          if (~rst_b)
            begin
              prev_agent_ism_state <= ISM_AGENT_IDLE;
              agent_ism_state <= ISM_AGENT_IDLE;
            end
          else
            begin
              prev_agent_ism_state <= agent_ism_state;
              agent_ism_state <= ism_in;
            end
        end // else: !if(ISMISIP)
    end // always @ (ism_in)

  always @(posedge clk or negedge rst_b)
    begin
      if (ISMISIP)
        begin
          if (~rst_b)
            begin
              prev_agent_ism_state <= ISM_AGENT_IDLE;
              agent_ism_state <= ISM_AGENT_IDLE;
            end
          else
            begin
              prev_agent_ism_state <= agent_ism_state;
              agent_ism_state <= ism_out;
            end
        end
      else
        begin
          if (~rst_b)
            begin
              prev_fabric_ism_state <= ISM_FABRIC_IDLE;
              fabric_ism_state <= ISM_FABRIC_IDLE;
              prev_int_pok_f <=  1'b1;
              prev_int_pok <=  1'b1;
            end
          else
            begin
              prev_fabric_ism_state <= fabric_ism_state;
              fabric_ism_state <= ism_out;
              prev_int_pok_f <= int_pok;
              prev_int_pok <= prev_int_pok_f;
            end
        end
    end // always @ (ism_out)

  always @(agent_ism_state)
    begin
      if ( (rst_b === 1'b1) && (ISM_ASSERT_EN == 1) )
        case ( agent_ism_state )
          ISM_AGENT_IDLE:
            // Transition to IDLE valid when...
            // Agent was CREDITDONE and fabric is IDLE
            // Agent was IDLEREQ and fabric is IDLE
            // when POK is low
            // Agent was previously undefined
            // Agent is in reset
            agent_idle_trans: assert(
                    ( prev_agent_ism_state == ISM_AGENT_CREDITDONE && fabric_ism_state == ISM_FABRIC_IDLE ) || 
                    ( prev_agent_ism_state == ISM_AGENT_IDLEREQ    && fabric_ism_state == ISM_FABRIC_IDLE ) ||
                    ~prev_int_pok ||
                    ~rst_b   ||
                    prev_agent_ism_state === 3'bxxx ) else
              $display("%0t: %m: ERROR: Invalid agent ISM transition. %b -> %b while Fabric ISM is %b", $time, prev_agent_ism_state , agent_ism_state , fabric_ism_state );
          ISM_AGENT_CREDITREQ:
            agent_creditreq_trans: assert( (prev_agent_ism_state == ISM_AGENT_IDLE) ||
                    (prev_agent_ism_state == ISM_AGENT_ACTIVEREQ) ) else
              $display("%0t: %m: ERROR: Invalid agent ISM transition. %b -> %b", $time, prev_agent_ism_state , agent_ism_state);
          ISM_AGENT_CREDITINIT:
            agent_creditinit_trans: assert( (prev_agent_ism_state == ISM_AGENT_CREDITREQ) && (fabric_ism_state == ISM_FABRIC_CREDITACK) ) else
              $display("%0t: %m: ERROR: Invalid agent ISM transition. %b -> %b while Fabric ISM is %b", $time, prev_agent_ism_state , agent_ism_state , fabric_ism_state );
          ISM_AGENT_CREDITDONE:
            agent_creditdone_trans: assert( prev_agent_ism_state == ISM_AGENT_CREDITINIT ) else
              $display("%0t: %m: ERROR: Invalid agent ISM transition. %b -> %b", $time, prev_agent_ism_state , agent_ism_state);
          ISM_AGENT_ACTIVEREQ:
            agent_activereq_trans: assert( prev_agent_ism_state == ISM_AGENT_IDLE ) else
              $display("%0t: %m: ERROR: Invalid agent ISM transition. %b -> %b", $time, prev_agent_ism_state , agent_ism_state);
          ISM_AGENT_ACTIVE:
// SBC-PCN-001 - ECN 202 - The Fabric ISM will be checking this behavior and will not know that the agent has SKIP_ACTIVEREQ
//                         parameter is turned on. This is causing erronious assertions to be fired on the fabric side.
            agent_active_trans: assert(            (prev_agent_ism_state == ISM_AGENT_ACTIVEREQ && fabric_ism_state == ISM_FABRIC_ACTIVEREQ)  || 
(((ISMISIP==1 && SKIP_ACTIVEREQ) || ISMISIP==0) && (prev_agent_ism_state == ISM_AGENT_IDLE      && fabric_ism_state == ISM_FABRIC_ACTIVEREQ)) ||
                                                   (prev_agent_ism_state == ISM_AGENT_IDLEREQ   && fabric_ism_state == ISM_FABRIC_IDLENAK  )) else
              $display("%0t: %m: ERROR: Invalid agent ISM transition. %b -> %b while Fabric ISM is %b", $time, prev_agent_ism_state , agent_ism_state , fabric_ism_state );
          ISM_AGENT_IDLEREQ:
            agent_idlereq_trans: assert( prev_agent_ism_state == ISM_AGENT_ACTIVE ) else
              $display("%0t: %m: ERROR: Invalid agent ISM transition. %b -> %b", $time, prev_agent_ism_state , agent_ism_state);
          default:
            invalid_agent_ism_state: assert (1 == 0) else
              $display("%0t: %m: ERROR: Invalid agent ISM state %b", $time, agent_ism_state);
        endcase 
    end

  always @(fabric_ism_state)
    begin
      if ( (rst_b === 1'b1) && (ISM_ASSERT_EN == 1) )
        case ( fabric_ism_state )
          ISM_FABRIC_IDLE:
            // Transition to IDLE valid when...
            // Fabric was previously ACTIVE
            // Fabric was previously CREDITINIT and the Agent is CREDITDONE
            // Fabric was previously undefined
            // Fabric is in reset
            // Transition from ACTIVEREQ and CREDITREQ are only okay when either:
            //    POK is low
            //    Local ISM is agent
            fabric_idle_trans: assert(
               !rst_b   ||
               ( prev_fabric_ism_state === ISM_FABRIC_ACTIVE                                                 ) || 
               ( prev_fabric_ism_state === ISM_FABRIC_CREDITINIT && agent_ism_state === ISM_AGENT_CREDITDONE ) ||
               ( ( ( prev_fabric_ism_state === ISM_FABRIC_ACTIVEREQ ) ||
                   ( prev_fabric_ism_state === ISM_FABRIC_CREDITREQ ) ) &&
                 ( ( !prev_int_pok || ( ISMISIP === 1 ) ) ) ) ||
               ( prev_fabric_ism_state === 3'bxxx ) ) else
              $display("%0t: %m: ERROR: Invalid fabric ISM transition. %b -> %b", $time, prev_fabric_ism_state, fabric_ism_state );
          ISM_FABRIC_CREDITREQ:
            fabric_creditreq_trans: assert(  prev_fabric_ism_state ==  ISM_FABRIC_IDLE  ||   // self-initiated or agent-initiated re-init arc
                                            (prev_fabric_ism_state ==  ISM_FABRIC_ACTIVEREQ && agent_ism_state == ISM_AGENT_CREDITREQ)
                  ) else
              $display("%0t: %m: ERROR: Invalid fabric ISM transition. %b -> %b", $time, prev_fabric_ism_state, fabric_ism_state );
          ISM_FABRIC_CREDITACK:
            fabric_creditack_trans: assert( (prev_fabric_ism_state == ISM_FABRIC_CREDITREQ && agent_ism_state == ISM_AGENT_CREDITREQ) ) else
              $display("%0t: %m: ERROR: Invalid fabric ISM transition. %b -> %b", $time, prev_fabric_ism_state, fabric_ism_state );
          ISM_FABRIC_CREDITINIT:
            fabric_creditinit_trans: assert( (prev_fabric_ism_state == ISM_FABRIC_CREDITACK) && (agent_ism_state == ISM_AGENT_CREDITINIT) ) else
              $display("%0t: %m: ERROR: Invalid fabric ISM transition. %b -> %b", $time, prev_fabric_ism_state, fabric_ism_state );
          ISM_FABRIC_ACTIVEREQ:
            fabric_activereq_trans: assert( prev_fabric_ism_state == ISM_FABRIC_IDLE ) else
              $display("%0t: %m: ERROR: Invalid fabric ISM transition. %b -> %b", $time, prev_fabric_ism_state, fabric_ism_state );
          ISM_FABRIC_ACTIVE:
            fabric_active_trans: assert( (prev_fabric_ism_state == ISM_FABRIC_ACTIVEREQ && agent_ism_state == ISM_AGENT_ACTIVE) || 
                    (prev_fabric_ism_state == ISM_FABRIC_IDLENAK   && agent_ism_state == ISM_AGENT_ACTIVE) ) else
              $display("%0t: %m: ERROR: Invalid fabric ISM transition. %b -> %b", $time, prev_fabric_ism_state, fabric_ism_state );
          ISM_FABRIC_IDLENAK:
            if (parity_err == 0 && ISMISIP == 0) begin // check for fabric ism only when no parity error and when ism is in fabric
                fabric_idlenak_trans: assert( prev_fabric_ism_state == ISM_FABRIC_ACTIVE && agent_ism_state == ISM_AGENT_IDLEREQ ) else
                $display("%0t: %m: ERROR: Invalid fabric ISM transition. %b -> %b", $time, prev_fabric_ism_state, fabric_ism_state );
            end
          default:
            invalid_fabric_ism_state: assert (1 == 0) else
              $display("%0t: %m: ERROR: Invalid fabric ISM state %b", $time, fabric_ism_state);
        endcase 
      end

     /*
      * ism_out should not exit IDLE while port_disable is asserted and being hold.
      */
      property port_disable_ism_idle;
        @( posedge clk ) disable iff((rst_b === 1'b0) /*|| (ISM_ASSERT_EN == 0)*/)
         ((port_disable == 1'b1) && (ism_out == 3'h0)) |-> ((ism_out == 3'h0) throughout (port_disable == 1'b1));
      endproperty: port_disable_ism_idle

      assert property( port_disable_ism_idle ) else begin
         $display( "%0t: %m: ERROR: ISM exits IDLE (to %b) while port_disable is holding HIGH.", $time, ism_out);
      end

  // coverage on
   `endif // SynTranlateOn
`endif
`endif  
// lintra pop
  
endmodule
