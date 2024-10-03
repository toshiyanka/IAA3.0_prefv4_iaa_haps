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
//  Module sbcinqueue : The ingress queues that are instantiated within the
//                      ingress block (sbcingress).  This block implements a
//                      basic queue and an accumulator output flop which
//                      changes the sideband payload width to the internal
//                      datapath width of the endpoint/router.
//
//------------------------------------------------------------------------------
// lintra push -60024b, -60024a, 


module hqm_sbccomp #(
   parameter INGMAXPLDBIT = 31,
   parameter EGRMAXPLDBIT = 31,
   parameter GLOBAL_RTR = 0
) (
   input logic side_clk,   // Sideband Clock
   input logic side_rst_b, // Sideband Reset
   input logic agent_idle, // Added for HSD #1404071127, "POK completion error"

   output logic pwrgt_comp,  // Power gate ready signal
   output logic idle_comp,   // Idle signal
   output logic npidle_comp, // NP Msg in progress
   output logic pcidle_comp, // PC Msg in progress

   // Interface to egress arbiter
   output logic enpstall,// Inform when to stall non-posted flits due to in-accessability to allow by p/c messages
   output logic epctrdy, // Inform when captured posted/completion flit
   output logic enptrdy, // Inform when captured non-posted flit
   input  logic epcirdy, // posted/completion flit ready from egress arbiter
   input  logic enpirdy, // non-posted flit ready from egress arbiter

   // Interface to the datapath
   input logic                  eom,  // End of current message reached
   input logic [EGRMAXPLDBIT:0] data, // lintra s-70036 // Current message flit

   // Interface to ingress arbiter
   input  logic                  pctrdy,   // posted/completion flit accepted
   output logic                  pcirdy,   // posted/completion flit ready
   output logic                  pcdstvld, // posted/completion byte 0 valid/marks the beginning of a message
   output logic                  pceom,    // posted/completion message done
   output logic                  pcparity, // posted/completion parity
   output logic [INGMAXPLDBIT:0] pcdata    // posted/completion flit data
);

// lintra push -60020, -60088, -68001, -60024b

`include "hqm_sbcglobal_params.vm"

localparam INGMAXBIT = (GLOBAL_RTR==0) ? ((INGMAXPLDBIT==31) ? 0 : ((INGMAXPLDBIT==15) ? 0 : 1))
                                       : ((INGMAXPLDBIT==31) ? 0 : ((INGMAXPLDBIT==15) ? 1 : 2));
localparam EGRMAXBIT = (GLOBAL_RTR==0) ? ((EGRMAXPLDBIT==31) ? 0 : ((EGRMAXPLDBIT==15) ? 0 : 1))
                                       : ((EGRMAXPLDBIT==31) ? 0 : ((EGRMAXPLDBIT==15) ? 1 : 2));
localparam STOPCNT   = 3'd7;

logic [        2:0] nptag;
logic [        7:0] npdst;
logic [        7:0] npdsth;  // lintra s-0531 used only when GLOBAL_RTR=1
logic [        7:0] npsrc;
logic [        7:0] npsrch;  // lintra s-0531 used only when GLOBAL_RTR=1
logic [       31:0] cmpmsg;
logic               nplast;
logic [EGRMAXBIT:0] npxfr;
logic [INGMAXBIT:0] cmpxfr;
logic               nphdr;
logic               npmsgip;
logic               pcmsgip;
logic               agent_idle_fb;
// Powergate ready when:
// 1. If not sending anything (pcirdy)
// 2. Not receiving anything (nphdr&enpirdy&epcirdy)
always_comb pwrgt_comp = ( !pcirdy & !npmsgip & !pcmsgip );

// IDLE Ready when:
// 1. No np msg in progress
// 2. No pc msg in progress
always_comb idle_comp   = ( npidle_comp & pcidle_comp );

// NP IDLE Ready when:
// 1. No np msg in progress
// 2. No completion message being sent
always_comb npidle_comp = ( !pcirdy & !npmsgip );

// PC IDLE Ready when no pc msg in progress
always_comb pcidle_comp = ( !pcmsgip );

// Last nonposted flit we care about for WORDS are on the second WORD.
// For BYTES is on the fourth BYTE. DWORDS are so large are always when a flit
// is received.
always_comb nplast = (&npxfr); 

// Always ready to receive PC messages since we plan to throw them away.
//always_comb epctrdy  = 1'b1;
always_comb epctrdy  = agent_idle_fb;

// Receive non-posted messages when not in the header because this is data
// payload flits and are not utilized by this module but the data must be
// cleaned out. Otherwise when in the header start capturing so long as the
// there are no completion messages in progress. This could be made more
// streamlined in the future but this serves our purposes and does not have
// a very big impact to the design.

// HSD #1404071127 BEGIN 
// "POK completion error"
// POK corner case when an NP message arrives at the same time as POK
// is de-asserted. This is fundamentally a clock-gating bug, with the
// data reaching the completion module before clk is restarted.
// Fix is to backpressure the arbiter, so so as to ensure that the clock
// is already re-started when data reaches sbccomp.
//
// always_comb enptrdy  = ( (nphdr & !pcirdy) | !nphdr );
   always_comb enptrdy  = ( (nphdr & !pcirdy) | !nphdr ) & agent_idle_fb;

   always_ff @( posedge side_clk or negedge side_rst_b )
      if( !side_rst_b ) // lintra s-70023
         agent_idle_fb <= 1'b0;
      else
         agent_idle_fb <= ~agent_idle;
// HSD #1404071127 END

// stalling is not necessary since the NP message is really the only thing
// that we care about. We could take the opportunity while sending the
// completion message to throw away PC messages but it is not worth the adding
// logic to the design.
//always_comb enpstall = ( nphdr & pcirdy );
always_comb enpstall = ( nphdr & pcirdy ) | (~agent_idle & ~agent_idle_fb);

// Completion message fully assembled as 32-bit message using data captured
// from the non-posted data stream.
always_comb cmpmsg   = { 5'b0_0010 , nptag , SBCOP_CMP , npdst , npsrc };

// Mark when the flit containing the destination is sent. (Start of Message)
always_comb pcdstvld = nphdr & (cmpxfr=='0) & pcirdy;

// Non-Posted message in progress, useful for detecting if the module is busy
always_ff @( posedge side_clk or negedge side_rst_b )
   if( !side_rst_b ) // lintra s-70023
      npmsgip <= 1'b0;
   else if( enpirdy & eom )
      npmsgip <= 1'b0;
   else if( enpirdy & !npmsgip )
      npmsgip <= 1'b1;

always_ff @( posedge side_clk or negedge side_rst_b )
   if( !side_rst_b ) // lintra s-70023
      pcmsgip <= 1'b0;
   else if( epcirdy & eom )
      pcmsgip <= 1'b0;
   else if( epcirdy & !pcmsgip )
      pcmsgip <= 1'b1;

// Analysis of non-posted messages header starts any time after a message has
// ended and a new one started.
always_ff @( posedge side_clk or negedge side_rst_b )
   if( !side_rst_b )
      nphdr <= 1'b1;
   else if( enpirdy & eom )
      nphdr <= 1'b1;
   else if( enpirdy & nplast )
      nphdr <= 1'b0;

// Non-posted message transfer position
// Start count when the header flit is sent for flits smaller than a DWORD.
// The arbiter will only assert irdy when trdy was asserted to it does not
// need to be factored in.
// For flits that are a DWORD there is only one flit to send to the transfer
// count is not necessary.
generate
   if ((EGRMAXPLDBIT == 31) & (GLOBAL_RTR == 0)) begin : gen_npxfr_pld31
      always_comb npxfr = '1;
   end else begin : gen_npxfr_pldx
      // The arbiter will only assert enpirdy when trdy is available.
      // The transfer is only valid when we are looking at a header
      always_ff @( posedge side_clk or negedge side_rst_b )
         if( !side_rst_b )
            npxfr <= '0;
         else if( enpirdy & nphdr ) // The arbitration logic will only assert irdy when trdy is available.
            npxfr <= npxfr + 'd1; // lintra s-0393, s-0396
   end
endgenerate

// Completion transfer position
// Start counting when the flit is confirmed sent for flits smaller than
// a DWORD.
// DWORD flits are always transfered after the first send so it isn't
// worth keeping track and we always assume cmpxfr to be zero.
generate
   if ((INGMAXPLDBIT == 31) & (GLOBAL_RTR == 0)) begin : gen_cmpxfr_pld31
      always_comb cmpxfr = '0;
   end else begin : gen_cmpxfr_pldx
      always_ff @( posedge side_clk or negedge side_rst_b )
         if( !side_rst_b )
            cmpxfr <= '0;
         else if( pcirdy & pctrdy )
            cmpxfr <= cmpxfr + 'd1; // lintra s-0393, s-0396
   end
endgenerate

// Posted/Completion source ready signal
// Send completion after message finished... alternately could send when the
// header completed and start sending the completion message immediately while
// still receiving data payloads.
always_ff @( posedge side_clk or negedge side_rst_b )
   if( !side_rst_b ) // lintra s-70023
      pcirdy <= 1'b0;
   else if( enpirdy & eom )
      pcirdy <= 1'b1;
   else if( pcirdy & pctrdy & pceom )
      pcirdy <= 1'b0;

// Sending PC data from the already built completion message cmpmsg.
// For DWORD flits the entire payload goes out.
// For WORD flits the completion tracker is used to break up the message into
// two WORDS.
// For BYTE flits the completion tracker is used to break up the message into
// four BYTES.
generate
   if ((INGMAXPLDBIT == 31) & (GLOBAL_RTR == 0)) begin : gen_cmpl_pld31
      always_comb begin
         pceom  = pcirdy;
         pcdata = cmpmsg;
      end
   end else if ((INGMAXPLDBIT == 15) & (GLOBAL_RTR == 0)) begin : gen_cmpl_pld15
      always_comb begin
         pceom  = cmpxfr[0];
         case( cmpxfr[0] )
         1'b0   : pcdata = cmpmsg[15: 0];
         1'b1   : pcdata = cmpmsg[31:16];
         default: pcdata = cmpmsg[15: 0];
         endcase
      end
   end else if ((INGMAXPLDBIT == 7) & (GLOBAL_RTR == 0)) begin : gen_cmpl_pld7
      always_comb begin
         pceom = &cmpxfr[1:0];
         case( cmpxfr[1:0] )
         2'b00  : pcdata = cmpmsg[ 7: 0];
         2'b01  : pcdata = cmpmsg[15: 8];
         2'b10  : pcdata = cmpmsg[23:16];
         2'b11  : pcdata = cmpmsg[31:24];
         default: pcdata = cmpmsg[ 7: 0];
         endcase
      end
   end
endgenerate

generate
   if ((INGMAXPLDBIT == 31) & (GLOBAL_RTR == 1)) begin : gen_cmpl_pld31_g
      always_comb begin
         pceom  = cmpxfr;
         if (cmpxfr == 0) pcdata = {16'h0000, npdsth, npsrch};
         else pcdata = cmpmsg;
      end
   end else if ((INGMAXPLDBIT == 15) & (GLOBAL_RTR == 1)) begin : gen_cmpl_pld15_g
      always_comb begin
         pceom  = &cmpxfr[1:0];
         case( cmpxfr[1:0] )
         2'b00  : pcdata = {npdsth, npsrch};
         2'b01  : pcdata = '0;
         2'b10  : pcdata = cmpmsg[15: 0];
         2'b11  : pcdata = cmpmsg[31:16];
         default: pcdata = cmpmsg[15: 0];
         endcase
      end
   end else if ((INGMAXPLDBIT == 7) & (GLOBAL_RTR == 1)) begin : gen_cmpl_pld7_g
      always_comb begin
         pceom = &cmpxfr[2:0];
         case( cmpxfr[2:0] )
         3'b000  : pcdata = npsrch;
         3'b001  : pcdata = npdsth;
         3'b010  : pcdata = '0;
         3'b011  : pcdata = '0;
         3'b100  : pcdata = cmpmsg[ 7: 0];
         3'b101  : pcdata = cmpmsg[15: 8];
         3'b110  : pcdata = cmpmsg[23:16];
         3'b111  : pcdata = cmpmsg[31:24];
         default: pcdata = cmpmsg[ 7: 0];
         endcase
      end
   end
endgenerate

always_comb pcparity = (pcirdy & pctrdy) ? ^{pcdata,pceom} : '0;



// Receiving from the non-posted stream the missing information for the
// completion message that needs to be sent. (npdst, npsrc and nptag)
// For DWORD flits the entire payload is captured and written to the
// appropriate registers
// For WORD flits the source and destination are taken on the first WORD and
// the second is the TAG.
// For BYTE flits the source is captured, second the destination and the
// fourth the tag is captured. The third flit is thrown away.
generate
   if ((EGRMAXPLDBIT == 31) & (GLOBAL_RTR == 0)) begin : gen_rsp_pld31
      // 32-Bit Data Message
      // +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+-----+
      // |31|30|29|28|27|26|25|24|23|22|21|20|19|18|17|16|15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|NPXFR|
      // +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+-----+
      // |EH|resrv|RSP  | TAG    |                OPCODE |                source |           destination |    0|
      // +--+-----+-----+--------+-----------------------+-----------------------+-----------------------+-----+
      always_ff @( posedge side_clk or negedge side_rst_b )
         if( !side_rst_b ) begin // lintra s-70023
            npdst <= '0;
            npsrc <= '0;
            nptag <= '0;
         end else if( enpirdy & nphdr ) begin
            npdst <= data[ 7: 0]; // old destination, new source
            npsrc <= data[15: 8]; // old source, new destination
            nptag <= data[26:24]; // old tag, new tag
         end
   end else if ((EGRMAXPLDBIT == 15) & (GLOBAL_RTR == 0)) begin : gen_rsp_pld15
      // 16-Bit Data Message
      // +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+-----+
      // |15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|NPXFR|
      // +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+-----+
      // |                source |           destination |    0|
      // +--+-----+-----+--------+-----------------------+-----+
      // |EH|resrv|RSP  | TAG    |                OPCODE |    1|
      // +--+-----+-----+--------+-----------------------+-----+
      always_ff @( posedge side_clk or negedge side_rst_b )
         if( !side_rst_b ) begin
            npdst <= '0;
            npsrc <= '0;
            nptag <= '0;
         end else if( enpirdy & nphdr ) begin
            if( !npxfr[0] ) begin // lintra s-60032
               npdst <= data[ 7:0];
               npsrc <= data[15:8];
            end else begin
               nptag <= data[10:8];
            end
         end
   end else if ((EGRMAXPLDBIT == 7) & (GLOBAL_RTR == 0)) begin : gen_rsp_pld7
      // 8-Bit Data Message
      // +--+--+--+--+--+--+--+--+-----+
      // | 7| 6| 5| 4| 3| 2| 1| 0|NPXFR|
      // +--+--+--+--+--+--+--+--+-----+
      // |           destination |    0|
      // +-----------------------+-----+
      // |                source |    1|
      // +-----------------------+-----+
      // |                OPCODE |    2|
      // +--+-----+-----+--------+-----+
      // |EH|resrv|RSP  | TAG    |    3|
      // +--+-----+-----+--------+-----+
      always_ff @( posedge side_clk or negedge side_rst_b )
         if( !side_rst_b ) begin
            npdst <= '0;
            npsrc <= '0;
            nptag <= '0;
         end else if( enpirdy & nphdr ) begin
            case( npxfr[1:0] )  // lintra s-2045
            2'b00 : npdst <= data[7:0];
            2'b01 : npsrc <= data[7:0];
            2'b11 : nptag <= data[2:0];
            endcase
         end
   end
endgenerate

generate
   if ((EGRMAXPLDBIT == 31) & (GLOBAL_RTR == 1)) begin : gen_rsp_pld31_g
      // 32-Bit Data Message
      // +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+-----+
      // |31|30|29|28|27|26|25|24|23|22|21|20|19|18|17|16|15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|NPXFR|
      // +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+-----+
      // |EH|resrv|RSP  | TAG    |                OPCODE |                source |           destination |    0|
      // +--+-----+-----+--------+-----------------------+-----------------------+-----------------------+-----+
      always_ff @( posedge side_clk or negedge side_rst_b )
         if( !side_rst_b ) begin // lintra s-70023
            npdst  <= '0;
            npsrc  <= '0;
            npdsth <= '0;
            npsrch <= '0;
            nptag  <= '0;
         end else if( enpirdy & nphdr & ~npxfr ) begin
            npdsth <= data[ 7: 0]; // old destination, new source
            npsrch <= data[15: 8]; // old source, new destination
         end else if( enpirdy & nphdr & npxfr ) begin
            npdst <= data[ 7: 0]; // old destination, new source
            npsrc <= data[15: 8]; // old source, new destination
            nptag <= data[26:24]; // old tag, new tag
         end
   end else if ((EGRMAXPLDBIT == 15) & (GLOBAL_RTR == 1)) begin : gen_rsp_pld15_g
      // 16-Bit Data Message
      // +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+-----+
      // |15|14|13|12|11|10| 9| 8| 7| 6| 5| 4| 3| 2| 1| 0|NPXFR|
      // +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+-----+
      // |                source |           destination |    0|
      // +--+-----+-----+--------+-----------------------+-----+
      // |EH|resrv|RSP  | TAG    |                OPCODE |    1|
      // +--+-----+-----+--------+-----------------------+-----+
      always_ff @( posedge side_clk or negedge side_rst_b )
         if( !side_rst_b ) begin
            npdst  <= '0;
            npsrc  <= '0;
            npdsth <= '0;
            npsrch <= '0;
            nptag  <= '0;
         end else if( enpirdy & nphdr ) begin
            case( npxfr[1:0] )
            2'b00 : begin
                       npdsth  <= data[7:0];
                       npsrch  <= data[15:8];
                    end
            2'b10 : begin
                       npdst   <= data[7:0];
                       npsrc   <= data[15:8];
                    end
            2'b11 : nptag   <= data[10:8];
            endcase
         end
   end else if ((EGRMAXPLDBIT == 7) & (GLOBAL_RTR == 1)) begin : gen_rsp_pld7_g
      // 8-Bit Data Message
      // +--+--+--+--+--+--+--+--+-----+
      // | 7| 6| 5| 4| 3| 2| 1| 0|NPXFR|
      // +--+--+--+--+--+--+--+--+-----+
      // |           destination |    0|
      // +-----------------------+-----+
      // |                source |    1|
      // +-----------------------+-----+
      // |                OPCODE |    2|
      // +--+-----+-----+--------+-----+
      // |EH|resrv|RSP  | TAG    |    3|
      // +--+-----+-----+--------+-----+
      always_ff @( posedge side_clk or negedge side_rst_b )
         if( !side_rst_b ) begin
            npdst  <= '0;
            npsrc  <= '0;
            npdsth <= '0;
            npsrch <= '0;
            nptag  <= '0;
         end else if( enpirdy & nphdr ) begin
            case( npxfr[2:0] )
            3'b000 : npdst  <= data[7:0];
            3'b001 : npsrc  <= data[7:0];
            3'b100 : npdsth <= data[7:0];
            3'b101 : npsrch <= data[7:0];
            3'b111 : nptag  <= data[2:0];
            endcase
         end
   end
endgenerate

//------------------------------------------------------------------------------
//
// SV Assertions 
//
//------------------------------------------------------------------------------
`ifndef INTEL_SVA_OFF
`ifndef IOSF_SB_ASSERT_OFF
    `ifdef INTEL_SIMONLY // SynTranlateOff
    //`ifdef INTEL_INST_ON // SynTranlateOff
   // coverage off
      comp_enprdy_check:
         assert property (@(posedge side_clk) disable iff (side_rst_b !== 1'b1) !enptrdy |-> !enpirdy ) else
         $display("%0t: %m: ERROR: ENPIRDY can only be asserted high when ENPTRDY is asserted high", $time ); 
   // coverage on   //
   // The following cover point ensures coverage of the assertion of
   // enpstall on async ports, upon the de-assertion of adgent_idle
   //
//      property enpstall_on_agt_idle;
//         @( posedge side_clk ) disable iff(!side_rst_b)
//            enpstall & (~agent_idle & ~agent_idle_fb) & (nphdr & pcirdy);
//      endproperty: enpstall_on_agt_idle
//      covprop_enpstall_on_agt_idle: cover property( enpstall_on_agt_idle ) $display("Error : Hit the cover property");  
//
    `endif // SynTranlateOn
`endif
`endif

endmodule

// lintra pop
