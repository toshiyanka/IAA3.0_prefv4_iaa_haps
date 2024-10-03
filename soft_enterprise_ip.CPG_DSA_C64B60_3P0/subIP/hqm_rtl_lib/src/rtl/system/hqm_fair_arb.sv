// ------------------------------------------------------------------- 
// --                      Intel Proprietary 
// --              Copyright 2020 Intel Corporation 
// --                    All Rights Reserved 
// ------------------------------------------------------------------- 
// ------------------------------------------------------------------- 
// --                      Intel Proprietary 
// --              Copyright 2020 Intel Corporation 
// --                    All Rights Reserved 
// ------------------------------------------------------------------- 
// $Id: hqm_fair_arb.sv,v 1.4 2012/07/16 12:34:33 jkenny Published $
// $Source: /p/coletocreek/repository/coletocreek/source/rtl/ppc/library/src/fair_arb.sv,v $
// NOTE: Log history is at end of file
//----------------------------------------------------------------------
// Date Created : 12/11/2008
// Author       : pfleming
// Project      : Cave Creek
//----------------------------------------------------------------------
//  Description: This is a generic implementation of a fair arbiter.
//  The arbiter begins with req[LSB] having the highest priority and
//  req[MSB] having the lowest priority. When multiple request lines
//  are asserted simultaneously the highest priority request is granted.
//  Once any request is granted that request then becomes the lowest
//  priority request.
//----------------------------------------------------------------------
//Instance Example
/*
hqm_fair_arb #(4,2) i_fair_arb(
.clk(p_clk),
.rst(sh_ep_rst_np),
.req(req[3:0]),
.gnt(gnt[3:0])
);
*/

module hqm_fair_arb #(

     parameter LINES     = 8
    ,parameter LOG2LINES = 3
) (
     input   logic                       clk     // Clock
    ,input   logic                       rst     // Active low asynchronous assert reset
    ,input   logic [LINES-1:0]           req     // request Lines
    ,output  logic [LINES-1:0]           gnt     // Grant Lines  
);

logic                           winner_v;
logic   [LOG2LINES-1:0]         winner;

hqm_AW_rr_arbiter #(.NUM_REQS(LINES)) i_rr_arb (

     .clk           (clk)
    ,.rst_n         (rst)

    ,.mode          (2'd2)
    ,.update        (winner_v)

    ,.reqs          (req)

    ,.winner_v      (winner_v)
    ,.winner        (winner)
);

generate

 if (LINES == 1) begin: g_1

  assign gnt = winner_v;

 end else begin: g_ge2

  logic [(1<<LOG2LINES)-1:0] winner_dec;

  hqm_AW_bindec #(.WIDTH(LOG2LINES)) i_bindec (

     .a             (winner)
    ,.enable        (winner_v)
    ,.dec           (winner_dec)
  );

  assign gnt = winner_dec[LINES-1:0];

  if (LINES < (1<<LOG2LINES)) begin: g_unused
   hqm_AW_unused_bits #(.WIDTH((1<<LOG2LINES)-LINES)) i_unused (.a(winner_dec[(1<<LOG2LINES)-1:LINES]));
  end

 end

endgenerate

endmodule

