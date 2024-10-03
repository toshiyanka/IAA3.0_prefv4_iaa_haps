//------------------------------------------------------------------------------------------------------------------------------------------------
//
// INTEL CONFIDENTIAL
//
// Copyright 2020 Intel Corporation All Rights Reserved.
//
// The source code contained or described herein and all documents related to the source code
// ( "Material" ) are owned by Intel Corporation or its suppliers or licensors. Title to the Material
// remains with Intel Corporation or its suppliers and licensors. The Material contains trade
// secrets and proprietary and confidential information of Intel or its suppliers and licensors.
// The Material is protected by worldwide copyright and trade secret laws and treaty provisions.
// No part of the Material may be used, copied, reproduced, modified, published, uploaded, posted,
// transmitted, distributed, or disclosed in any way without Intel's prior express written permission.
//
// No license under any patent, copyright, trade secret or other intellectual property right is
// granted to or conferred upon you by disclosure or delivery of the Materials, either expressly, by
// implication, inducement, estoppel or otherwise. Any license under such intellectual property rights
// must be express and approved by Intel in writing.
//
//------------------------------------------------------------------------------------------------------------------------------------------------
//
module hqm_credit_hist_pipe_freelist_select
  import hqm_AW_pkg::*;
#(
  parameter NUM_REQS = 8
, parameter CNT_WIDTH = 12
//................................................................................................................................................
, parameter NUM_REQSB2 = ( AW_logb2 ( NUM_REQS -1 ) + 1 )
) (
  input logic clk
, input logic rst_n
, input logic [( NUM_REQS * CNT_WIDTH) -1 : 0] reqs
, output logic [( 1 ) -1 : 0] winner_v
, output logic [( NUM_REQSB2 ) -1 : 0] winner
) ;

generate
  if ( ( NUM_REQS != 8 )
     | ~ ( ( CNT_WIDTH == 11 ) | ( CNT_WIDTH == 12 ) )				// 8K or 16K credits
     )  begin : invalid
    for ( genvar g0 = NUM_REQS ; g0 <= NUM_REQS ; g0 = g0 + 1 ) begin : NUM_REQS
    for ( genvar g1 = CNT_WIDTH ; g1 <= CNT_WIDTH ; g1 = g1 + 1 ) begin : CNT_WIDTH
      INVALID_PARAM_COMBINATION  i_bad ( .clk() );
    end
    end
  end
endgenerate

logic [ ( CNT_WIDTH ) - 1 : 0 ] reqs_01d ; logic [ ( NUM_REQSB2 ) - 1 : 0 ] reqs_01w ; logic reqs_01 ;
logic [ ( CNT_WIDTH ) - 1 : 0 ] reqs_23d ; logic [ ( NUM_REQSB2 ) - 1 : 0 ] reqs_23w ; logic reqs_23 ;
logic [ ( CNT_WIDTH ) - 1 : 0 ] reqs_45d ; logic [ ( NUM_REQSB2 ) - 1 : 0 ] reqs_45w ; logic reqs_45 ;
logic [ ( CNT_WIDTH ) - 1 : 0 ] reqs_67d ; logic [ ( NUM_REQSB2 ) - 1 : 0 ] reqs_67w ; logic reqs_67 ;
logic [ ( CNT_WIDTH ) - 1 : 0 ] reqs_0123d ; logic [ ( NUM_REQSB2 ) - 1 : 0 ] reqs_0123w ; logic reqs_0123 ;
logic [ ( CNT_WIDTH ) - 1 : 0 ] reqs_4567d ; logic [ ( NUM_REQSB2 ) - 1 : 0 ] reqs_4567w ; logic reqs_4567 ;
logic reqs_01234567 ;
logic winner_v_f , winner_v_nxt ;
logic [( NUM_REQSB2 ) -1 : 0] winner_f , winner_nxt ;
always_ff @( posedge clk or negedge rst_n ) begin: L001
  if ( ~ rst_n ) begin
    winner_v_f <= '0 ;
    winner_f <= '0 ;
  end else begin
    winner_v_f <= winner_v_nxt ;
    winner_f <= winner_nxt ;
  end
end

assign winner_v = winner_v_f ;
assign winner = winner_f ;

assign  winner_v_nxt = ( | reqs ) ;

assign reqs_01        = ( reqs [ ( 0 * CNT_WIDTH ) +: CNT_WIDTH ] >= reqs [ ( 1 * CNT_WIDTH ) +: CNT_WIDTH ] ) ;
assign reqs_01d       = reqs_01 ? reqs [ ( 0 * CNT_WIDTH ) +: CNT_WIDTH ] : reqs [ ( 1 * CNT_WIDTH ) +: CNT_WIDTH ] ;
assign reqs_01w       = reqs_01 ? 3'd0 : 3'd1 ;

assign reqs_23        = ( reqs [ ( 2 * CNT_WIDTH ) +: CNT_WIDTH ] >= reqs [ ( 3 * CNT_WIDTH ) +: CNT_WIDTH ] ) ;
assign reqs_23d       = reqs_23 ? reqs [ ( 2 * CNT_WIDTH ) +: CNT_WIDTH ] : reqs [ ( 3 * CNT_WIDTH ) +: CNT_WIDTH ] ;
assign reqs_23w       = reqs_23 ? 3'd2 : 3'd3 ;

assign reqs_45        = ( reqs [ ( 4 * CNT_WIDTH ) +: CNT_WIDTH ] >= reqs [ ( 5 * CNT_WIDTH ) +: CNT_WIDTH ] ) ;
assign reqs_45d       = reqs_45 ? reqs [ ( 4 * CNT_WIDTH ) +: CNT_WIDTH ] : reqs [ ( 5 * CNT_WIDTH ) +: CNT_WIDTH ] ;
assign reqs_45w       = reqs_45 ? 3'd4 : 3'd5 ;

assign reqs_67        = ( reqs [ ( 6 * CNT_WIDTH ) +: CNT_WIDTH ] >= reqs [ ( 7 * CNT_WIDTH ) +: CNT_WIDTH ] ) ;
assign reqs_67d       = reqs_67 ? reqs [ ( 6 * CNT_WIDTH ) +: CNT_WIDTH ] : reqs [ ( 7 * CNT_WIDTH ) +: CNT_WIDTH ] ;
assign reqs_67w       = reqs_67 ? 3'd6 : 3'd7 ;

assign reqs_0123      = ( reqs_01d >= reqs_23d ) ;
assign reqs_0123d     = reqs_0123 ? reqs_01d : reqs_23d ;
assign reqs_0123w     = reqs_0123 ? reqs_01w : reqs_23w ;

assign reqs_4567      = ( reqs_45d >= reqs_67d ) ;
assign reqs_4567d     = reqs_4567 ? reqs_45d : reqs_67d ;
assign reqs_4567w     = reqs_4567 ? reqs_45w : reqs_67w ;

assign reqs_01234567  = ( reqs_0123d >= reqs_4567d ) ;
assign winner_nxt     = reqs_01234567 ? reqs_0123w : reqs_4567w ;

endmodule
