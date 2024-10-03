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
// oldest (largest delta timestamp) wins. TIME paramter specifies the WIDTH of each req req_time timestamp (ex. NUM_REQS=2 & TIME=2 4 bit wide req_time)
// same timestamp tiebreak can be paramtertized to use either:
//   TYPE = 0 : (DEFAULT) same timestamp tiebreak uses strict selection with req[0] as higest prioirty
//   TYPE = 1 : same timestamp tiebreak uses round robin selection
//
//------------------------------------------------------------------------------------------------------------------------------------------------
module hqm_AW_oldest_arb
 import hqm_AW_pkg::*;
#(
 parameter NUM_REQS = 8
, parameter TIME = 16 
, parameter TYPE = 0 
//................................................................................................................................................
, parameter NUM_REQSB2 = ( AW_logb2 ( NUM_REQS - 1 ) + 1 )
) (
  input logic clk
, input logic rst_n
, input logic [ ( NUM_REQS ) - 1 : 0] reqs
, input logic [ ( NUM_REQS * TIME ) - 1 : 0] reqs_time
, input logic update
, output logic winner_v
, output logic [ ( NUM_REQSB2 ) - 1 : 0] winner
) ;

logic  [ ( NUM_REQS ) - 1 : 0] alt_reqs ;
logic alt_winner_v ;
logic [ ( NUM_REQSB2 ) - 1 : 0] alt_winner ;
generate
if ( TYPE == 0 ) begin : strict
  hqm_AW_strict_arb #(
   .NUM_REQS ( NUM_REQS )
  ) i_hqm_AW_strict_arb (
   . reqs ( alt_reqs )
  , . winner_v ( alt_winner_v )
  , . winner ( alt_winner )
  );
end
if ( TYPE == 1 ) begin : rr
  hqm_AW_rr_arb #(
   .NUM_REQS ( NUM_REQS )
  ) i_hqm_AW_rr_arb (
   .clk ( clk )
  , .rst_n ( rst_n )
  , .update ( update )
  , .reqs ( alt_reqs )
  , .winner_v ( alt_winner_v )
  , .winner ( alt_winner )
  );
end
endgenerate 

logic  [ ( NUM_REQS ) - 1 : 0] mask ;
always_comb begin:L01
  mask = '1 ;
  for ( int i = 0 ; i < NUM_REQS ; i = i + 1 ) begin
    for ( int j = 0 ; j < NUM_REQS ; j = j + 1 ) begin
      if ( i == j ) begin
        continue ;
      end
      else begin
        if ( reqs [ i ] 
           & reqs [ j ]
           & ( reqs_time [ ( i * TIME ) +: TIME ] < reqs_time [ ( j * TIME ) +: TIME ] ) 
           ) begin
          mask [ i ] = 1'b0 ;
        end
      end
    end
  end
  alt_reqs = reqs & mask ;
  winner_v = alt_winner_v ;
  winner = alt_winner ;
end


endmodule
