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
//  Module sbcgcgu : Clock gating unit
//
//  Functional description:
//       Top Level of the Generic Clock Gating Unit
//       ISMISIP:  0 = Fabric ISM; 1 = Agent ISM
//
//----------------------------------------------------------------------------

// lintra push -80099, -60026, -80018, -60020, -68001, -60024b, -60024a, -70036_simple

module hqm_sbcgcgu #(
                 parameter ISMISIP  = 0,
                 parameter SKIP_ACTIVEREQ = 0,
                 parameter ENDPOINTONLY = 0,
                 parameter EOM_PERF_OPT = 0,
                 parameter CG_DELAY = 0,
                 parameter CG_DELAY_STRAP_EN = 0
                 )
  (
   //-------------------------------------------------------------------------
   // Global signals
   //-------------------------------------------------------------------------
   input  logic  clk,
   input  logic  rst_b,
   
   input  logic  force_creditreq, // forces ISM into credit req from IDLE
   //-------------------------------------------------------------------------
   // Cfg Registers
   //-------------------------------------------------------------------------
   input  logic       cfg_clkgaten,//enable clock gating
   input  logic [7:0] cfg_idlecnt, // lintra s-70036 idle timer value, not used when strappable port type is enabled
   
   //-------------------------------------------------------------------------
   // IOSF Interface
   //-------------------------------------------------------------------------
   input  logic       side_clk_valid,
   input  logic [2:0] ism_in,     
   input  logic [2:0] nd_ism_in,  // lintra s-0527, s-70036 "Non-floped ism inputs to be used for idle count"
   output logic [2:0] ism_out,
   output logic       maxidlecnt, //asserted when the idle counter matches the csr_idle limit
   //-------------------------------------------------------------------------
   // Clock Gating Control 
   //-------------------------------------------------------------------------
   input  logic  ip_idle,         // when asserted the clock can be gated
   input  logic  count_idle,      // idle signal for idle counter
   //For the Fabric ISM this signal indicates
   //that the port has no more transactions to
   //send to the agent.
   output logic  cg_inprogress,   //prim fab clk gating indicator to stall txns
   output logic  ism_idle,        //used by the sideband end point to generate
   //clkreq to an adjacent clk gating domain 
   //when not idle; For agent ISM generated
   //clock reqs to the IOSF interface use the
   //out_clkreq signal
   output logic  cg_en, // SBC-PCN-004 - Clock gate override for PCG.
   input logic [3:0] cg_delay_width_strap,
   
   //-------------------------------------------------------------------------
   // Credit Initialization
   //-------------------------------------------------------------------------
   input  logic    credit_init_done,//asserted for one clock cycle when credit
   //initialization is complete
   output logic    credit_init,     //asserted when credit initialization can begin;
   //deasserted during reset and just after reset
   output logic    agnt_credit_init_done, //asserted for one clock cycle when
   //the agent ISM moves into the credit_done
   //state (Fabric ISM only signal)
   output logic    credit_reinit,   // indicates transition into credit reinit arcs;
   // this is used as a synchronous reset for the
   // credit counters.
   // (cannot use credit_init signal as it stays asserted
       //  for too long and is not asserted at correct time
       //  with regard to the spec)
   
   //-------------------------------------------------------------------------
   // Misc
   //-------------------------------------------------------------------------
   input  logic       int_pok,
   input  logic       port_disable,
   input  logic       parity_err,
   output logic [5:0] dbgbus,
   input logic        side_ism_lock_b, // SBC-PCN-002 - Sideband ISM lock for power gating flows
   input  logic       epcirdy,         // lintra s-0527, s-70036 "Used only when EOM_PERF_OPT is set"
   input  logic       enpirdy,         // lintra s-0527, s-70036 "Used only when EOM_PERF_OPT is set"
   
   //-------------------------------------------------------------------------
   // state signals that can be used at higher levels
   //-------------------------------------------------------------------------
   output logic  ip_ism_active,   
   output logic  ip_ism_activereq,  // lintra s-70036
   output logic  ip_ism_idle,
   output logic  ip_ism_idlereq,    // lintra s-70036
   output logic  ip_ism_creditreq,
   output logic  ip_ism_creditinit, // lintra s-70036
   output logic  ip_ism_creditdone, // lintra s-70036
   output logic  fabric_ism_active,   
   output logic  fabric_ism_activereq,
   output logic  fabric_ism_idle,
   output logic  fabric_ism_idlenak,
   output logic  fabric_ism_creditreq,
   output logic  fabric_ism_creditack, // lintra s-70036
   output logic  fabric_ism_creditinit
   
   );

`include "hqm_sbcglobal_params.vm"

  //=============================================================================
  // Declarations
  //=============================================================================
  localparam MAXBIT = (ISMISIP==0) ? 0 : 7; //reduce idlecnt register to 1 bit in
  //fabric ism mode to save gates
  
  logic            idle;       //Asserted when ip_idle has been asserted for the csr_idle count
  logic [MAXBIT:0] idlecnt;    //idle counter to determine when to begin clock gating
  //logic            rst_suppress; //suppresses cg_inprogress and ip_wake assertions
  //after reset; also forces the state machines to
  //move from IDLE to ACTIVE
  logic            ip_wake;
  logic            nak_idlereq;
  logic            init_done;
  //logic            fab_credit_done;
  
  logic [1:0]      curr_state;
  logic            cg_en_visa;

  //=============================================================================
  // ISM          
  //=============================================================================

  hqm_sbcism #(
           .ISMISIP             ( ISMISIP           ),
           .SKIP_ACTIVEREQ      ( SKIP_ACTIVEREQ    ),
           .CG_DELAY            ( CG_DELAY          ),
           .CG_DELAY_STRAP_EN   ( CG_DELAY_STRAP_EN )
           )
  sbcism0
    (
     .int_pok              (int_pok),
     .port_disable         (port_disable),
     .clk                  (clk),
     .rst_b                (rst_b),
     .force_creditreq      (force_creditreq),
     .idle                 (idle),
     .ip_wake              (ip_wake),
     .init_done            (init_done),
     .credit_reinit        (credit_reinit),
     .nak_idlereq          (nak_idlereq),
     .cg_delay_width_strap (cg_delay_width_strap),
     .cg_en                (cg_en), // SBC-PCN-004 - Clock gate override for PCG
     .cg_en_visa           (cg_en_visa), // SBC-PCN-004 - Clock gate override for PCG
     .parity_err           (parity_err),
     .ism_in               (ism_in),
     .ism_out              (ism_out),
     .side_clk_valid       (side_clk_valid),
     .side_ism_lock_b      (side_ism_lock_b), // SBC-PCN-002 - Sideband ISM lock bit
     .ip_ism_active        (ip_ism_active),
     .ip_ism_activereq     (ip_ism_activereq),
     .ip_ism_idle          (ip_ism_idle),
     .ip_ism_idlereq       (ip_ism_idlereq),
     .ip_ism_creditreq     (ip_ism_creditreq),
     .ip_ism_creditinit    (ip_ism_creditinit),
     .ip_ism_creditdone    (ip_ism_creditdone),
     .fabric_ism_active    (fabric_ism_active),
     .fabric_ism_activereq (fabric_ism_activereq),
     .fabric_ism_idle      (fabric_ism_idle),
     .fabric_ism_idlenak   (fabric_ism_idlenak),
     .fabric_ism_creditreq (fabric_ism_creditreq),
     .fabric_ism_creditack (fabric_ism_creditack),
     .fabric_ism_creditinit(fabric_ism_creditinit)
     );

// HSD:1403929860 - Add flops to Visa inputs
logic visa_ip_idle;
generate
    if (ENDPOINTONLY==1) begin : gen_add_flops_to_visa
        always_ff @(posedge clk or negedge rst_b) begin
            if (~rst_b)
                visa_ip_idle <= 1'b0;
            else
                visa_ip_idle <= ip_idle;
            end // always
        end // if endpoint
    else begin : gen_no_flops_for_router// if router
        always_comb visa_ip_idle = ip_idle;
        end
endgenerate

always_comb dbgbus = { maxidlecnt, cg_en_visa, visa_ip_idle, ism_out };  

  
  //==============================================================================
  // Credit Init State Machine
  //==============================================================================
  
  //moves the ism from the credit_init state
  //always_comb init_done = (ISMISIP == 0) ? fab_credit_done : credit_init_done;
  //always_comb fab_credit_done = credit_init_done | (curr_state == `CI_SM_DONE);
  
  always_comb init_done = credit_init_done | (curr_state == CI_SM_DONE);
  
  generate
    if ( ISMISIP == 1 )
      begin : gen_agent_ism_blk
        always_ff @(posedge clk or negedge rst_b)
          begin
            if (~rst_b) // lintra s-70023
              begin
              credit_init <= 1'b0;
                agnt_credit_init_done <= 1'b0;
                curr_state <= CI_SM_IDLE;
              end
            else
              begin
                //====================================
                // The Agent ISM
                //====================================
                agnt_credit_init_done <= 1'b0;

                    casez (curr_state) // lintra s-60129
                      CI_SM_IDLE : if (ip_ism_creditreq & (ism_in == ISM_FABRIC_CREDITACK))
                        begin
                          curr_state <= CI_SM_HOLD;
                          credit_init <= 1'b1;
                        end
                      else 
                        begin
                          curr_state <= CI_SM_IDLE;
                          credit_init <= 1'b0;
                        end
                      
                      CI_SM_HOLD  : 
                        if (credit_init_done)
                          begin
                            curr_state <= CI_SM_DONE;
                            credit_init <= 1'b0;
                          end
                        else
                          begin
                            curr_state <= CI_SM_HOLD;
                            credit_init <= 1'b1;
                          end
                      
                      CI_SM_DONE  : 
                        begin
                          credit_init <= 1'b0;
                          if (ism_in == ISM_FABRIC_IDLE)
                            curr_state <= CI_SM_IDLE;
                          else
                            curr_state <= CI_SM_DONE;
                        end
                      default :
                        begin
                          curr_state  <= CI_SM_IDLE;
                          credit_init <= 1'b0;
                        end  
                    endcase
              end // else: !if(~rst_b)
          end // always_ff @
      end // if ( ISMISIP == 1 )
    else
      begin : gen_fabric_ism_blk
        always_ff @(posedge clk or negedge rst_b)
          begin
            if (~rst_b) // lintra s-70023
              begin
                credit_init <= 1'b0;
                agnt_credit_init_done <= 1'b0;
                curr_state <= CI_SM_IDLE;
              end
            else
              //=============================================================================
              // The Fabric ISM
              //=============================================================================
              begin
                casez (curr_state) // lintra s-60129
                  CI_SM_IDLE : 
                    begin
                      agnt_credit_init_done <= 1'b0;
                      if(ism_in == ISM_AGENT_CREDITINIT)
// SBC-PCN-002 - Should not start negotiating credits unless the fabric is out of idle or without a lock. - START
                      //if( (ism_in == ISM_AGENT_CREDITINIT) && (!fabric_ism_idle & side_ism_lock_b) )
// SBC-PCN-002 - Should not start negotiating credits unless the fabric is out of idle or without a lock. - FINISH
                        begin
                          curr_state <= CI_SM_HOLD;
                          credit_init <= 1'b1;
                        end
                      else 
                        begin
                          curr_state <= CI_SM_IDLE;
                          credit_init <= 1'b0;
                        end
                    end
                  
                  CI_SM_HOLD  : 
                    begin
                      if (credit_init_done &
                          (ism_in == ISM_AGENT_CREDITDONE)
                          )
                        begin
                          agnt_credit_init_done <= 1'b1;
                          credit_init <= 1'b0;
                          curr_state <= CI_SM_IDLE;
                        end
                      else if (credit_init_done)
                        begin
                          agnt_credit_init_done <= 1'b0;
                          credit_init <= 1'b0;
                          curr_state <= CI_SM_DONE;
                        end
                      else
                        begin
                          agnt_credit_init_done <= 1'b0;
                          credit_init <= 1'b1;
                          curr_state <= CI_SM_HOLD;
                        end
                    end
                  
                  CI_SM_DONE  : 
                    begin
                      credit_init <= 1'b0;
                      if (ism_in == ISM_AGENT_CREDITDONE)
                        begin
                          curr_state <= CI_SM_IDLE;
                          agnt_credit_init_done <= 1'b1;
                        end
                      else
                        begin
                          curr_state <= CI_SM_DONE;
                          agnt_credit_init_done <= 1'b0;
                        end
                    end // case: CI_SM_DONE
                  default:
                    begin
                      curr_state  <= CI_SM_IDLE;
                      credit_init <= 1'b0;
                      agnt_credit_init_done <= 1'b0;
                    end  
                endcase
              end
          end // always_ff @
      end // else: !if( ISMISIP == 1 )
  endgenerate
  
  
//=============================================================================
// IP interface 
//=============================================================================

//--------------------------------
// clock gate inprogress signal
//--------------------------------

generate
   if( |ISMISIP ) begin : gen_agent_inp_blk
      //logic [2:0]      ism_in_ff;
      //
      //always_ff @(posedge clk or negedge rst_b)
      //   if(~rst_b)
      //      ism_in_ff <= ISM_FABRIC_IDLE;
      //   else
      //      ism_in_ff <= ism_in;

      // Power gating strategy update, if the target is POK from out of reset
      // to infinity, need to be sure the clocks turn on for agent_idle to
      // let the port reject messages.
      always_comb cg_inprogress = (ip_ism_idle & ip_idle & int_pok) | // If powered up, let the ism control local clock gating
                                  (ip_idle & !int_pok);     // If powered down, let agent_idle control local clock gating, Needed for message rejection.
   end else begin : gen_fabric_inp_blk
      logic [2:0]      ism_in_ff;

      always_ff @(posedge clk or negedge rst_b)
         if(~rst_b) // lintra s-70023
            ism_in_ff <= ISM_AGENT_CREDITREQ;
         else
            ism_in_ff <= ism_in;

      // Power gating strategy update, if the target is POK from out of reset
      // to infinity, need to be sure the clocks turn on for agent_idle to
      // let the port reject messages.
      always_comb cg_inprogress = ((ism_in_ff == ISM_AGENT_IDLEREQ) & ip_idle)            | 
                                  (ip_idle & !int_pok)                                    | // If powered down, let agent_idle control of local clock gating, Needed for message rejection.
                                  ((ism_in_ff == ISM_AGENT_IDLE) & int_pok & ip_idle)     | // HSD 1404407147 POK bug: ((ism_in_ff == ISM_AGENT_IDLE) & int_pok) | // If powered up, let the agent ISM control local clock gating.
                                  (ism_in_ff == ISM_AGENT_ACTIVEREQ)                      |
                                  fabric_ism_activereq                                    |
                                  ((ism_in_ff == ISM_AGENT_CREDITDONE) & fabric_ism_idle) |
                                  ((curr_state == CI_SM_DONE) & agnt_credit_init_done );
      end
  endgenerate

  //------------------------------------------------------------------------------
  // After a reset event, clocks are enabled and clock gating should be suspended
  // until credit initialization is complete and both ISMs are in the active state
  //------------------------------------------------------------------------------
/*
  //Code not used anymore
  always_ff @(posedge clk or negedge rst_b)
    if (~rst_b)
      rst_suppress <= 1'b1;
    else
      rst_suppress <= (ISMISIP == 0) ? 
                      (~fabric_ism_active & rst_suppress) : 
                      (ism_in != ISM_FABRIC_ACTIVE) & rst_suppress;
*/

  //=============================================================
  // Idle Counter for Agent ISM movement from ACTIVE to IDLEREQ
  //=============================================================
  // to the ISM to indicate that the idle limit has been reached
  
generate //HSD: 1507055022
  if (EOM_PERF_OPT) begin : gen_idle_eom_perf_opt
     always_comb idle    = count_idle & maxidlecnt & cfg_clkgaten & ~epcirdy & ~enpirdy;
  end else begin : gen_idle_eom_perf_opt_bp
     always_comb idle    = count_idle & maxidlecnt & cfg_clkgaten;
  end
endgenerate

  always_comb maxidlecnt = (idlecnt >= cfg_idlecnt[MAXBIT:0]) & cfg_clkgaten; // Fix for HSD BUG 4547271

  //----------------------------------------------------------------
  // idle counter enabled when the Agent ism is in the ACTIVE state
  // and the count_idle signal is asserted.
  //----------------------------------------------------------------
  always_ff @(posedge clk or negedge rst_b)
    if (~rst_b) // lintra s-70023
      idlecnt <= '0;
    else if (ISMISIP==0)
      idlecnt[0] <= (ISMISIP==0) &
                     fabric_ism_active & (ism_in == ISM_AGENT_IDLEREQ);
    else if (~count_idle | ~ip_ism_active | ~(nd_ism_in == ISM_FABRIC_ACTIVE) | ~cfg_clkgaten) begin // Fix for HSD BUG 4547271
       if( idlecnt != 0 ) begin // Should prevent the register from being flopped all the time
          idlecnt <= '0;
       end
    end else if (~maxidlecnt) begin
      idlecnt <= idlecnt + 1'b1;  // lintra s-2056
    end
  
  //================================================================
  // Wake Events for Agent ISM to move from IDLE
  //================================================================
generate
    if (ENDPOINTONLY==1) begin : gen_wake_ep
        always_comb ip_wake =  ~ip_idle;
    end
    else begin : gen_wake_rtr
        always_comb ip_wake =  ~count_idle;// | rst_suppress;
    end
endgenerate
  
generate
   if ( ~|ISMISIP ) begin : gen_fabric_icnt_blk

      // HSD#1303911355 ---START---
         // The fabric side ISM should IDLE_NAK if put or cup within less than 15 cc
         // from the most recent posedge of ip_idle.
         // The incorrect implementation had nak_idlereq indicated if "~ip_idle",
         // missing a race condition when ip_idle happens to become logic-1 at about
         // the same time as the agent-side ISM transitions to IDLE_REQ.
         // The fix was to replace the "~ip_idle" term in the equation for nak_idlereq
         // with "~&ip_idle_cnt | ~ip_idle".
         logic [3:0] ip_idle_cnt;
   
         always_ff @(posedge clk or negedge rst_b) begin
            if (~rst_b) // lintra s-70023
               ip_idle_cnt <= 4'hf;
            else if (~ip_idle)
               ip_idle_cnt <= 4'h0;
            else if (~&ip_idle_cnt)
               ip_idle_cnt <= ip_idle_cnt + 1'b1; // lintra s-2056
         end
      // HSD#1303911355 ---END---

      if (EOM_PERF_OPT) begin : gen_nak_idlereq_eom_perf_opt
         always_comb nak_idlereq = fabric_ism_active &
                                   (ism_in == ISM_AGENT_IDLEREQ) &
                                   (~&ip_idle_cnt | ~ip_idle | epcirdy | enpirdy); // ~ip_idle;  Fix for HSD#1303911355
      end else begin : gen_nak_idlereq_eom_perf_opt_bp
         always_comb nak_idlereq = fabric_ism_active &
                                   (ism_in == ISM_AGENT_IDLEREQ) &
                                   (~&ip_idle_cnt | ~ip_idle); // ~ip_idle;  Fix for HSD#1303911355
      end
        
      // SBC-PCN-001 - Removed int_pok, should not falsely report the ISM as idle,
      //               Should however block the credit_reinit from holding the port out of idle.
      always_comb ism_idle    = ( (~credit_reinit | !int_pok) & fabric_ism_idle & (ism_in== ISM_AGENT_IDLE) );
   end else begin : gen_agent_icnt_blk
      always_comb nak_idlereq = '0;

      // SBC-PCN-001 - Removed int_pok, should not falsely report the ISM as idle,
      //               Should however block the credit_reinit from holding the port out of idle.
      always_comb ism_idle    = ( ip_ism_idle & (~credit_reinit | !int_pok) & (ism_in == ISM_FABRIC_IDLE) );
   end
endgenerate
  
  
endmodule //sbcgcgu

// lintra pop
