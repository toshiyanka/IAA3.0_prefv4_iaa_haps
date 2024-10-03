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
// random arbiter
//
// Random number determines external starting index used by RR arbiter
//
//------------------------------------------------------------------------------------------------------------------------------------------------
//000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011111111111111111111111111111111111111111111111
//000000011111111112222222222333333333344444444445555555555666666666677777777778888888888999999999900000000001111111111222222222233333333334444444
//345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456
//------------------------------------------------------------------------------------------------------------------------------------------------

module hqm_AW_rand_arb_wupdate
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
, input logic update
, output logic [( 1 ) -1 : 0] winner_v
, output logic [( NUM_REQSB2 ) -1 : 0] winner
) ;

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
logic [( 8 ) -1 : 0] random_pnc ;
logic random_update ;
logic [( NUM_REQSB2 ) -1 : 0] index ;

hqm_AW_random08_wupdate # (
  .SEED ( SEED )
) i_hqm_AW_random08 (
  .clk ( clk )
, .rst_n ( rst_n )
, .update ( random_update )
, .random ( random_pnc )
) ;

assign index = random_pnc [( NUM_REQSB2 ) -1 : 0]  ;

hqm_AW_rr_arb_windex # (
    .NUM_REQS                                           ( NUM_REQS )
  ) i_hqm_AW_rr_arb_windex (
    .clk                                                ( clk )
  , .rst_n                                              ( rst_n )
  , .reqs                                               ( reqs )
  , .index_f                                            ( index )
  , .winner_v                                           ( winner_v )
  , .winner                                             ( winner )
) ;

assign random_update = winner_v & update ; 

endmodule
