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
//  File sbcasyncclkreq : 
//
//------------------------------------------------------------------------------

// lintra push -60020, -80028, -68001, -60024b, -60024a, -2096, -70036_simple
// 2191 : Case statement with an enum variable in a condition is not detected as full despite the fact that all enum values are checked
// lintra push -2191

module hqm_sbcasyncclkreq #(
   parameter HYST_CNT = 15,
   parameter CLKREQDEFAULT = 0,
   parameter DISABLE_WAKE_CHECK = 0

) (
   input logic clk,
   input logic rst_b,

   input logic fscan_rstbypen,
   input logic fscan_byprst_b,
   input logic fscan_clkungate, // HSD-ES 1014954027: Asynchronous logic needs to be more robust

   input logic wake,
   input logic idle,
   
   input logic parity_err, // lintra s-0527, s-70036_simple used only in assertion

   output logic clkreq,
   input  logic clkack,
   output logic clkvalid // lintra s-70036
);

`include "hqm_sbcfunc.vm"

localparam CLKGATE_CNT                  = 2;
localparam CLKGATE_CNT_WIDTH            = sbc_logb2( CLKGATE_CNT );
localparam HYST_CNT_WIDTH               = sbc_logb2( HYST_CNT );
localparam HYST_WIDTH                   = (CLKGATE_CNT_WIDTH > HYST_CNT_WIDTH) ? CLKGATE_CNT_WIDTH : HYST_CNT_WIDTH;
localparam [HYST_WIDTH:0] HYST_CNT_ONE  = 'd1;
localparam [HYST_WIDTH:0] HYST_CNT_ZERO = 'd0;

enum logic [2:0] {
   RESET_ST,    
// Reset state to prepare the clock request unit for out of reset conditions.
// Otherwise the clock request unit would have to assume that clkack is high
// out of reset which may not always be true.
   ACTIVE_ST,
// Stay in this state until the IP reports it is IDLE and clkack_sync is 1.
   HYST_ST,
// Hysteresis state can go active if the IDLE signal goes low.
   WAIT_ACK_ST,
   GATED_ST
} fsm;                                   // Local statemachine

logic                async_rst_b;        // Asynchronous reset and wake signal combined
logic                async_clkreq_rst_b; // Asynchronous reset through a scan mux
logic                clkack_sync;        // Asynchronous clkack synchronizer
logic                clkgated;           // gated signal for blocking off the clock request
logic                clkactive;          // active signal for synchronously deasserting clkreq
logic [HYST_WIDTH:0] cnt;                // Hysteresis counter
// HSD-ES 1014954027: Asynchronous logic needs to be more robust - START
logic                clkreq_en;          // clkreq enable signal, blocks the internal clock request for metastability hazard protection
logic                clkreq_int;         // internal version of the clkreq
logic                clken;              // active low version of the clkgated signal
logic                clk_gated;          // gated version of the clock
// HSD-ES 1014954027: Asynchronous logic needs to be more robust - FINISH
// CLKREQRST change for Spec update
logic 				 clkreq_old;
logic				 clkreq_new;
logic                wake_fsm_h2w; // esavin: When fsm moved from HYST_ST to WAIT_ACK_ST, if the wake signal was already HIGH, 
                                   //         async_clkreq_missed assertion needs to be disabled since it is not really a glitch.  

always_comb clkvalid = clkactive;

always_ff @( posedge clk or negedge rst_b )
   if( !rst_b ) begin
      fsm       <= RESET_ST;
      cnt       <= HYST_CNT_ZERO;
      clkgated  <= 1'b1;
      clkactive <= 1'b0;
// HSD-ES 1014954027: Asynchronous logic needs to be more robust - START
      clkreq_en <= 1'b1; // By default must be ready for the clkreq_en to be set.
// HSD-ES 1014954027: Asynchronous logic needs to be more robust - FINISH
      wake_fsm_h2w <= 1'b0;
   end else begin
      casez( fsm ) // lintra s-60129
         RESET_ST:
         // Reset state has an actively high clkreq but must wait for the
         // clkack_sync to go high before telling the IP that the clock
         // is valid. (clkvalid=1)
            if( clkack_sync ) begin
               fsm       <= ACTIVE_ST;
               clkactive <= 1'b1;
               clkgated  <= 1'b0;
            end

         ACTIVE_ST: // Actively requesting the clock
            if( idle & clkack_sync ) begin
               cnt <= HYST_CNT;
               fsm <= HYST_ST;
            end

         HYST_ST: // Waiting for hysteresis to count down
            if( !idle )
               fsm <= ACTIVE_ST;
            else if( cnt == HYST_CNT_ZERO ) begin
               fsm       <= WAIT_ACK_ST;
               clkactive <= 1'b0;
               clkreq_en <= 1'b0;
               wake_fsm_h2w <= 1'b1 & wake;
            end else
               cnt <= cnt - HYST_CNT_ONE;

         WAIT_ACK_ST: // Waiting for the clock ack to clear
            if( !clkack_sync ) begin
               fsm      <= GATED_ST;
               clkgated <= 1'b1;
               cnt      <= CLKGATE_CNT;
               wake_fsm_h2w <= 1'b0;
            end

         GATED_ST: // Clock is gated and waiting for the ack back
// HSD-ES 1014954027: Asynchronous logic needs to be more robust - START
            // clock request must remain pinned to zero until the counter
            // expires giving the all clear when the flop should have achieved
            // stability.
            if( cnt == HYST_CNT_ZERO ) begin  
               clkreq_en <= 1'b1; 

               if( clkack_sync ) begin
                  fsm       <= ACTIVE_ST;
                  clkactive <= 1'b1;
                  clkgated  <= 1'b0;
               end
            end else begin
               cnt <= cnt - HYST_CNT_ONE;
            end
// HSD-ES 1014954027: Asynchronous logic needs to be more robust - FINISH

         default: // SHOULD NEVER BE HERE
            fsm <= ACTIVE_ST;
      endcase
   end

// Clock Acknowledge synchronizer.
// Under no circumstance should the original be used directly as the
// original signal input is possibly asynchronous and an MCP.
hqm_sbc_doublesync i_sbc_doublesync_clkack ( // lintra s-80018
   .clk  ( clk         ),
   .clr_b( rst_b       ),
   .d    ( clkack      ),
   .q    ( clkack_sync )
);

// Asynchronously set the clock request only when the clock is already gated.
always_comb async_rst_b = (rst_b & ~( clkgated & wake ));

// Any asynchronous set/clr flag must be scan controllable,
// this also includes the clock request input to the clkreq
// flop.
hqm_sbc_ctech_scan_mux i_sbc_ctech_scan_mux ( // lintra s-80018
   .d ( async_rst_b        ),
   .si( fscan_byprst_b     ), 
   .se( fscan_rstbypen     ),
   .o ( async_clkreq_rst_b )
);

// HSD-ES 1014954027: Asynchronous logic needs to be more robust - START
//    Adding in a clock gate to prevent the internal clock request from toggling
//    after the hazard portion of the clkreq flop going metastable while
//    receiving the asynchronous set during a clocking operation of the flop.
//    This prevents the flop from infering a feedback loop mux during synthesis.
always_comb clken = ~clkgated;

hqm_sbc_clock_gate i_sbc_clock_gate_clk_gated ( // lintra s-80018 "Lintra struggles with automated uniquification"
   .en      ( clken           ),
   .te      ( fscan_clkungate ),
   .clk     ( clk             ),
   .enclk   ( clk_gated       )
);
// HSD-ES 1014954027: Asynchronous logic needs to be more robust - FINISH

// Clock request metasynchronous flop signal. This flop is used both
// synchronously and asynchronously.
// The flop is asynchronously set with the wake signal when there is no clock to
// request the clock. It is important that this signal remain asserted until the
// clock is received. Even if the clock is no longer being requested by the
// original clock domain. It is vital to maintain the clkreq/clkack handshake.
// The synchronous input idle will not deassert until the idle conditions are
// met plus a minimum count value. The prevents thrashing on the clock request
// during tightly bursty message operations where maintaining a consistant
// connection across the router network is vital to the health of the chip. It
// is important that the infered flop does not loopback on itself when the
// metastable condition does occur. That is why clkactive is read directly.
// However, the clock request must remain asserted until until this signal
// is activated, hence a gated version of the clock will prevent the clock
// from being recieved until the module is ready to move on.
// HSD-ES 1014954027: Asynchronous logic needs to be more robust - START
//    The original clock request is now internal.
//    This flop is clock gated while in the GATED STATE until a prescribed
//    count value has cleared to prevent glitching when an additional wake
//    condition comes in while the clkgated signal is transitioning from
//    0 to 1. This should create a MCP on the clock request and give
//    substantial amounts of time for the clock request to settle to 0 or 1
//    when the clock request is released by clkreq_en.


always_ff @( posedge clk_gated or negedge async_clkreq_rst_b )
   if( !async_clkreq_rst_b )
      clkreq_old <= 1'b1; // lintra s-70023 "asynchronous set of the clkreq will be driven by comb logic"
   else if (fsm != RESET_ST)
      clkreq_old <= clkactive;
// HSD-ES 1014954027: Asynchronous logic needs to be more robust - FINISH

generate 
	if (|CLKREQDEFAULT) begin : gen_clkrqrst
		always_comb clkreq_new = ~rst_b ? wake : clkreq_old;
    end
	else begin : gen_noclkrst
		always_comb clkreq_new = '0;
	end
endgenerate

always_comb clkreq_int = CLKREQDEFAULT ? clkreq_new : clkreq_old;

// Output clock request signal
// HSD-ES 1014954027: Asynchronous logic needs to be more robust - START
//    clkreq_en is used to block off the internal version of the clock request
//    which could be potentially metastable. This is creating the MCP before
//    the real clock request goes out to full chip. Logic on the output is
//    generally frownd upon but in this case it is safer than the alternatives.
//    The usage of the AND gate will prevent glitches from passing through
//    and both signals are relatively stable. Also, both signals will only
//    change at the same time when they are both one going. The properties
//    of an AND gate make this non-glitching.
always_comb clkreq = (clkreq_int & clkreq_en);
// HSD-ES 1014954027: Asynchronous logic needs to be more robust - FINISH

// lintra pop

//-----------------------------------------------------------------------------
// SVA
//-----------------------------------------------------------------------------
`ifndef INTEL_SVA_OFF
`ifndef IOSF_SB_ASSERT_OFF
 `ifdef INTEL_SIMONLY
 //`ifdef INTEL_INST_ON // SynTranlateOff
property async_clkreq_missed;
// If during the fsm state WAIT_ACK_ST the wake signal asserts and then
// deasserts fire an assertion error. This means that there was an
// asynchronous event that was missed which may lead to a deadlock.
   @( posedge clk ) disable iff(( fsm !== WAIT_ACK_ST) || (DISABLE_WAKE_CHECK) || parity_err || wake_fsm_h2w)
      (wake===1'b1) |=> (wake===1'b1);
endproperty: async_clkreq_missed

assert_async_clkreq_missed:
assert property( async_clkreq_missed ) else begin
   $display( "%0t: %m: ERROR: wake signal asserted then deasserted while in the fsm is in the WAIT_ACK_ST. Request event was missed.", $time );
end


//`ifdef TGLP_CLK_REQ

int pos_time, neg_time, posedge_clk ,negedge_clk, first_posedge_clk, first_negedge_clk, clk_period, clk_period_pos_certinity, clk_period_neg_certinity;

always @(posedge  clkreq)
pos_time <= $time;

always @(negedge clkreq)
neg_time <= $time;

always @ (posedge clk or negedge rst_b)
     if (rst_b == 0)
        first_posedge_clk <= 0;
     else if (first_posedge_clk == 0 ) begin
         posedge_clk <= $time;
         first_posedge_clk <= 1;
         end   

always @ (negedge clk or negedge rst_b)
     if (rst_b == 0) begin
        first_negedge_clk <= 0;
        end
     else if (first_negedge_clk == 0 ) begin
         negedge_clk <= $time; 
         first_negedge_clk <= 1;
         end
          
 always_comb 
  if (( posedge_clk - negedge_clk ) > 0) begin
      clk_period_pos_certinity = (2*( first_posedge_clk - first_negedge_clk) + 0.01);
     end
  else begin 
     clk_period_pos_certinity = (2*( first_negedge_clk - first_posedge_clk) + 0.01);
     end

always_comb 
  if (( posedge_clk - negedge_clk ) > 0) begin
      clk_period_neg_certinity = (2*( first_posedge_clk - first_negedge_clk) - 0.01);
  end
  else begin 
     clk_period_neg_certinity = (2*( first_negedge_clk - first_posedge_clk) - 0.01); 
  end
           
property clkreqglitchpos;
  realtime clkreq_change;
  @(clkreq)
  (1,  clkreq_change = $realtime) |=> (($realtime - clkreq_change) >= clk_period_pos_certinity);
endproperty

property clkreqglitchneg;
  realtime clkreq_change;
  @(clkreq)
  (1,  clkreq_change = $realtime) |=> (($realtime - clkreq_change) >= clk_period_neg_certinity);
endproperty

assert property (clkreqglitchpos) else begin
   $display ("%0t: %m: ERROR: There is glitch on clk req.", $time);
end 

assert property (clkreqglitchneg) else begin
   $display ("%0t: %m: ERROR: There is glitch on clk req.", $time);
end
     
 //`endif // tglp_clkreq 
`endif // SynTranlateOn
`endif
`endif
endmodule

