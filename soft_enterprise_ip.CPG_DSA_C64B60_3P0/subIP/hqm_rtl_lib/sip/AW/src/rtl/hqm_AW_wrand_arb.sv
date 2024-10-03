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
// weighted random arbiter
//
// configuration is broken into slots. There are NUM_REQS slots and 
//   slot[0] is highest priority requestor and 
//
// * per requestor cfg_weight assigns the weight to the slot. THe requestor will be slected when it is valid and the random number
//    selects it as the highest prioity based on the weight. weight is always 8bit. if requestor is not valid then will perform a strict arb
//
// Ex.) configuration to select among 4 requestors:
//
//  cfg_weight[7:0]     = 127; //          reqs[0] wins arb 128/256 times
//
//  cfg_weight[15:8]    = 254; //          reqs[1] wins arb 127/256 times
//
//  cfg_weight[23:16]   = 255; //          reqs[2] wins arb 1/256 times
//
//  cfg_weight[31:24]   = 0;   //          reqs[3] never wins through weight arbitration. Can be selected only when
//                                         requestor 2, 0, or 1 are not valid
//
// NOTE: to make 8 req uniform random distribution: ,.cfg_weight( { 8'hff,8'hdf,8'hbf,8'h9f,8'h7f,8'h5f,8'h3f,8'h1f } )
//
//------------------------------------------------------------------------------------------------------------------------------------------------
//000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011111111111111111111111111111111111111111111111
//000000011111111112222222222333333333344444444445555555555666666666677777777778888888888999999999900000000001111111111222222222233333333334444444
//345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456
//------------------------------------------------------------------------------------------------------------------------------------------------

module hqm_AW_wrand_arb
  import hqm_AW_pkg::*;
#(
  parameter NUM_REQS = 8
, parameter SEED = 1
//................................................................................................................................................
, parameter NUM_REQSB2 = ( AW_logb2 ( NUM_REQS -1 ) + 1 )
) (
  input logic clk
, input logic rst_n
, input logic [( NUM_REQS ) -1 : 0] reqs
, input logic [( NUM_REQS * 8 ) -1 : 0] cfg_weight
, output logic winner_v
, output logic [( NUM_REQSB2 ) -1 : 0] winner
) ;

//---------------------------------------------------------------------------------------------------
//Check for invalid paramter configation
genvar GEN0 ;
generate
  if ( ~( NUM_REQS < 2049 ) ) begin : invalid_check
    for ( GEN0 = NUM_REQS ; GEN0 <= NUM_REQS ; GEN0 = GEN0+1 ) begin : invalid_NUM_REQS
      INVALID_PARAM_COMBINATION i_invalid ( .invalid ( ) ) ;
    end
  end
endgenerate

//------------------------------------------------------------------------------------------------------------------------------------------------
//Instances & Registers
logic [( 8 ) -1 : 0] random ;
hqm_AW_random08 # (
  .SEED ( SEED )
) i_hqm_AW_random08 (
  .clk ( clk )
, .rst_n ( rst_n )
, .random ( random )
) ;

logic strict_winner_v ;
logic [( NUM_REQSB2 ) -1 : 0] strict_winner ;
hqm_AW_strict_arb # (
  .NUM_REQS ( NUM_REQS )
) i_hqm_AW_strict_arb (
  .reqs ( reqs )
, .winner_v ( strict_winner_v ) 
, .winner ( strict_winner ) 
) ;


logic [( NUM_REQSB2 ) -1 : 0] rand_sel_nxt , rand_sel_f ;
always_ff @(posedge clk or negedge rst_n) begin:L060
  if (!rst_n) begin
    rand_sel_f <= '0 ;
  end
  else begin
    rand_sel_f <= rand_sel_nxt ;
  end
end
always_comb begin
  rand_sel_nxt = '0 ;
  for ( int i = 0 ; i < NUM_REQS ; i = i + 1 ) begin : L000
    if ( i == 0) begin 
      if ( ( cfg_weight[ ( i * 8 ) +: 8] > 8'd0 )
         & ( random[( 8 ) -1 : 0] <= cfg_weight[ ( i * 8 ) +: 8] )
         ) begin
        rand_sel_nxt = i;
      end
    end
    else begin
      if ( ( cfg_weight[ ( i * 8 ) +: 8] > 8'd0 )
         & ( random[( 8 ) -1 : 0] > cfg_weight[ ( ( i - 1 ) * 8 ) +: 8] )
         & ( random[( 8 ) -1 : 0] <= cfg_weight[ ( i * 8 ) +: 8] )
         ) begin
        rand_sel_nxt = i ;
      end
    end
  end
end

always_comb begin
  winner_v = 1'd0 ;
  winner = '0 ;

  if ( strict_winner_v ) begin
    winner_v = 1'b1 ;
  end

  if ( reqs[rand_sel_f] ) begin
    winner = rand_sel_f ;
  end
  else if ( strict_winner_v ) begin
    winner = strict_winner ;
  end

end

endmodule
