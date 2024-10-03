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
// weighted random arbiter, not work-conserving
//
// Configuration is broken into slots, each defined by cfg_range_min and cfg_range_max. There are NUM_REQS slots.
//
// The requestor will be selected when the random number is >= its cfg_range_min and less <= its cfg_range_max.
// Config ranges are assumed to be non-overlapping.  To unconfigure a req assign its max < min.
// Range values are all 16 bits.
//
// Ex.) configuration to select among 4 requestors, with upper 16 range of values out of all 2**16 possible values unconfigured:
//
//  cfg_range_max[15:0]  = 16'h3fff ;  cfg_range_min[15:0]  = 16'h0000 ;        // reqs[0] wins 16'h4000 / 17'h10000 times
//  cfg_range_max[31:16] = 16'h7fff ;  cfg_range_min[31:16] = 16'h4000 ;        // reqs[1] wins 16'h4000 / 17'h10000 times
//  cfg_range_max[47:32] = 16'h9fff ;  cfg_range_min[47:32] = 16'h8000 ;        // reqs[2] wins 16'h2000 / 17'h10000 times
//  cfg_range_max[63:48] = 16'hffef ;  cfg_range_min[63:48] = 16'ha000 ;        // reqs[3] wins 16'h5ff0 / 17'h10000 times
//------------------------------------------------------------------------------------------------------------------------------------------------
//000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011111111111111111111111111111111111111111111111
//000000011111111112222222222333333333344444444445555555555666666666677777777778888888888999999999900000000001111111111222222222233333333334444444
//345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456
//------------------------------------------------------------------------------------------------------------------------------------------------

module hqm_AW_wrandnwc_arb_wupdate
  import hqm_AW_pkg::*;
#(
  parameter NUM_REQS = 4
, parameter SEED = 1
, parameter INC = 0
//................................................................................................................................................
, parameter NUM_REQSB2 = ( AW_logb2 ( NUM_REQS -1 ) + 1 )
) (
  input logic clk
, input logic rst_n
, input logic [( NUM_REQS ) -1 : 0] reqs
, input logic [( NUM_REQS * 16 ) -1 : 0] cfg_range_min
, input logic [( NUM_REQS * 16 ) -1 : 0] cfg_range_max
, input logic update
, input logic use_mix 
, input logic test_mode                                 // For formal testing only
, input logic [( NUM_REQSB2 ) -1 : 0] test_mode_winner  // For formal testing only
, input logic test_mode_winner_cfg                      // For formal testing only
, output logic [( 1 ) -1 : 0] winner_v
, output logic [( 1 ) -1 : 0] winner_configured         // Random number was within a configured range
, output logic [( NUM_REQSB2 ) -1 : 0] winner
) ;

logic [NUM_REQSB2+16:0]         range_total ;

//---------------------------------------------------------------------------------------------------
//Check for invalid parameter configuration
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
logic [( 16 ) -1 : 0] random ;
logic random_update ;
hqm_AW_random16_wupdate # (
  .SEED ( SEED )
, .INC ( INC )
) i_hqm_AW_random16 (
  .clk ( clk )
, .rst_n ( rst_n )
, .update ( random_update )
, .use_mix ( use_mix )
, .random ( random )
) ;

//------------------------------------------------------------------------------------------------------------------------------------------------
//Functional Code

always_comb begin

  //..............................................................................................................................................
  //default output values
  winner = '0 ;
  winner_configured = '0 ;


  //..............................................................................................................................................
  // select req based on configured range
  range_total         = '0 ;

  if ( test_mode ) begin                // In hardware this will be tied to 0 so the enclosed logic will not be synthesized
    //---------------------------------------------------------------------------------------------------------------------
    winner = test_mode_winner ;
    for ( int i = 0 ; i < NUM_REQS ; i = i + 1 ) begin : L003
      if ( cfg_range_max [ ( i * 16 ) +: 16] >=  cfg_range_min [ ( i * 16 ) +: 16] )
        range_total     = range_total + ( { 3'h0 , cfg_range_max [ ( i * 16 ) +: 16] } - { 3'h0 , cfg_range_min [ ( i * 16 ) +: 16] } ) + 19'h1 ;
    end // for

    if ( range_total < { { NUM_REQSB2 { 1'b0 } } , 17'h10000 } )
      winner_configured = test_mode_winner_cfg ;
    else
      winner_configured = 1'b1 ;        // Entire range specified by configuration so not possible to select unconfigured
    //---------------------------------------------------------------------------------------------------------------------
  end
  else begin
    for ( int i = 0 ; i < NUM_REQS ; i = i + 1 ) begin : L000
      if ( ( random[( 16 ) -1 : 0] >= cfg_range_min [ ( i * 16 ) +: 16] )
         & ( random[( 16 ) -1 : 0] <= cfg_range_max [ ( i * 16 ) +: 16] )
         ) begin
        winner = i ;
        winner_configured = 1'b1 ;
      end
    end // for
  end
end
assign winner_v = reqs [ winner ] ;
assign random_update = winner_v & update ; 

`ifndef INTEL_SVA_OFF

logic cfg_overlap_err ;

always_comb begin
  cfg_overlap_err       = 1'b0 ;

  for ( int i = 0 ; i < NUM_REQS ; i = i + 1 ) begin : L001
    for ( int j = 0 ; j < NUM_REQS ; j = j + 1 ) begin : L002
      if ( ( ( ( cfg_range_min [ ( j * 16 ) +: 16] >= cfg_range_min [ ( i * 16 ) +: 16] ) &
               ( cfg_range_min [ ( j * 16 ) +: 16] <= cfg_range_max [ ( i * 16 ) +: 16] ) ) |
             ( ( cfg_range_max [ ( j * 16 ) +: 16] >= cfg_range_min [ ( i * 16 ) +: 16] ) &
               ( cfg_range_max [ ( j * 16 ) +: 16] <= cfg_range_max [ ( i * 16 ) +: 16] ) ) ) &
           ( i != j ) &
           (     cfg_range_max [ ( i * 16 ) +: 16] >= cfg_range_min [ ( i * 16 ) +: 16] ) &             // i is configured
           (     cfg_range_max [ ( j * 16 ) +: 16] >= cfg_range_min [ ( j * 16 ) +: 16] ) &             // j is configured
           ( | reqs )
          )
      cfg_overlap_err   = 1'b1 ;
    end // for j
  end // for i

end // always

    hqm_AW_wrandnwc_arb_wupdate_assert i_hqm_AW_wrandnwc_arb_wupdate_assert (.*) ;
`endif

endmodule

`ifndef INTEL_SVA_OFF

module hqm_AW_wrandnwc_arb_wupdate_assert import hqm_AW_pkg::*; (
          input logic clk
        , input logic rst_n
        , input logic cfg_overlap_err
);

`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_cfg_overlap_err 
                      , ( cfg_overlap_err )
                      , clk
                      , ~rst_n
                      , `HQM_SVA_ERR_MSG("assert_forbidden_cfg_overlap_err: ")
                        , SDG_SVA_SOC_SIM
                      ) 

endmodule // hqm_AW_wrandnwc_arb_wupdate_assert
`endif
