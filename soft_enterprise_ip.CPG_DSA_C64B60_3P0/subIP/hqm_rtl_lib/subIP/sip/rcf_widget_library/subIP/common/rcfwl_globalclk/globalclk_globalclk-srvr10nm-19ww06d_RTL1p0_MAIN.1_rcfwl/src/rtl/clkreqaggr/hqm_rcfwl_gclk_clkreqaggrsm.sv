
///
///  INTEL CONFIDENTIAL
///
///  Copyright 2015 Intel Corporation All Rights Reserved.
///
///  The source code contained or described herein and all documents related
///  to the source code ("Material") are owned by Intel Corporation or its
///  suppliers or licensors. Title to the Material remains with Intel
///  Corporation or its suppliers and licensors. The Material contains trade
///  secrets and proprietary and confidential information of Intel or its
///  suppliers and licensors. The Material is protected by worldwide copyright
///  and trade secret laws and treaty provisions. No part of the Material may
///  be used, copied, reproduced, modified, published, uploaded, posted,
///  transmitted, distributed, or disclosed in any way without Intel's prior
///  express written permission.
///
///  No license under any patent, copyright, trade secret or other intellectual
///  property right is granted to or conferred upon you by disclosure or
///  delivery of the Materials, either expressly, by implication, inducement,
///  estoppel or otherwise. Any license under such intellectual property rights
///  must be express and approved by Intel in writing.
///
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
//
//      FILENAME        : clkreqaggrsm.sv
//      DESCRIPTION     : Main FSM for clkreq aggregator
//
//----------------------------------------------------------------------------//
//----------------------------- Revision History -----------------------------//
//
//      Date            Rev     Owner           Description
//      --------        ---     ------------    -------------------------------------
//      01/07/2015      0.00    Jesse Ong       Initial revision based on dyclkgate design
//
//----------------------------------------------------------------------------//
//      Assumptions     :
//
//
//      Glossary        :
//
//
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//

//`timescale 1ps/1ps


module hqm_rcfwl_gclk_clkreqaggrsm
#(
      parameter                                      CLKREQ_CNT = 2           // # of clock requests coming from downstream agents
)
(
      input  logic                                   rst_b,         		  // Active low reset, already sync'ed to iclk outside of this component
      input  logic                                   iclk,               	  // Input Clock
      input  logic                                   clkmack_sync,            // Synchronized upstream clock acknowledge
      input  logic [                 CLKREQ_CNT-1:0] iclkreq_sync,            // Synchronized downstream clock request
      input  logic                                   any_req_qual,            // Non-synchronized consolidated downstream clock request
      input  logic                                   consolidated_req_sync,   // Synchronized consolidated downstream clock request
      output logic                                   oclkmreq,                // Upstream clock request
      output logic [                 CLKREQ_CNT-1:0] oclkack,                 // Downstream clock acknowledges
      output logic [                            3:0] clkreqaggrsm_visa        // clkreqaggrsm VISA
);


//----------------------------------------------------------------------------//
//-------------------- Internal signals declaration --------------------------//
//----------------------------------------------------------------------------//
typedef enum logic [1:0] {
      AGGR_IDLE                                        = 2'b10,         // IDLE, no clock request
      AGGR_WACKR                                       = 2'b11,         // Waiting for assertion of upstream clock ack
      AGGR_ACT                                         = 2'b01,         // Requesting Clock, either one of the downstream blocks are requesting for clock   
      AGGR_WACKF                                       = 2'b00,         // Waiting for de-assertion of upstream clock ack
      AGGR_ERROR                                       = 'X             // Error (Should not reach this state)
} AggrState_t;
AggrState_t aggrsm_ns, aggrsm_ps;

logic                                                aggrsm_active_nxt, aggrsm_any_req_qual;
logic [                              CLKREQ_CNT-1:0] clkack_nxt;


//----------------------------------------------------------------------------//
//----------------------------------- Combi ----------------------------------//
//----------------------------------------------------------------------------//
always_comb begin
   aggrsm_ns = aggrsm_ps;
   case(aggrsm_ps)
       AGGR_IDLE  : if (consolidated_req_sync)              aggrsm_ns = AGGR_WACKR;
       AGGR_WACKR : if (clkmack_sync)                       aggrsm_ns = AGGR_ACT;
       AGGR_ACT   : if (!consolidated_req_sync)				aggrsm_ns = AGGR_WACKF;
       AGGR_WACKF : if (!clkmack_sync)                      aggrsm_ns = AGGR_IDLE;
       default  :                                           aggrsm_ns = AGGR_ERROR;
   endcase
end

assign aggrsm_active_nxt                              = (aggrsm_ns == AGGR_ACT);


//----------------------------------------------------------------------------//
//----------------------------------- Outputs --------------------------------//
//----------------------------------------------------------------------------//

always_ff @(posedge iclk, negedge rst_b) begin
   if (!rst_b) begin
       aggrsm_ps <= AGGR_IDLE;
   end
   else begin
       aggrsm_ps <= aggrsm_ns;
   end
end

hqm_rcfwl_gclk_ctech_and2_gen
u_any_clkreq_qual_and2_gen (
      .a(any_req_qual),
      .b(aggrsm_ps[1]),
      .y(aggrsm_any_req_qual)
);

hqm_rcfwl_gclk_ctech_or2_gen
u_oclkmack_or2_gen (
      .a(aggrsm_any_req_qual),
      .b(aggrsm_ps[0]),
      .y(oclkmreq)
);

genvar i;

generate
for (i=0; i<CLKREQ_CNT; i=i+1) begin : num_dn_clkack
hqm_rcfwl_gclk_ctech_and2_gen
u_clkack_nxt_and2_gen (
      .a(iclkreq_sync[i]),
      .b(aggrsm_active_nxt),
      .y(clkack_nxt[i])
);

always_ff @(posedge iclk, negedge rst_b) begin
   if (!rst_b) begin
       oclkack[i]                                    <= 1'b0;
   end
   else begin
       oclkack[i]                                    <= clkack_nxt[i];
   end
end
end  // End num_dn_clkack
endgenerate

// VISA signals
assign clkreqaggrsm_visa                              = {consolidated_req_sync, clkmack_sync, aggrsm_ps};

endmodule
