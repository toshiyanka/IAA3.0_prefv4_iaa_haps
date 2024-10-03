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
// hqm_AW_rrwrand_arb.sv
//  Implement a 2 stage arbiter. The first stage is round robin, and the second stage is weighted random. Input provides a decoded
//  requestor array with a bit for every requestor at every prioity. Configuration provides a weight and priority for each of the
//  parameterized priorities. The output selects a winner, winning prioirty and the winner reqeustor of the prioirty.
//
// cfg_weight : configuration state to proivde a weight for each NUM_PRI prioirty.
// reqs : specify reqeustor array, each prioirty has a full set of requestors
//   Ex.) NUM_REQS=2 & NUM_PRI=8 then bits [7:0] are 8 prioirty bits of requestor[0] and [15:8] are 8 prioirty bits of requestor[1]
//
// winner_v : a qrbitration selection has been made
// winner_pri : winning prioirty
// winner : winning reqeustor
//
//------------------------------------------------------------------------------------------------------------------------------------------------
//000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011111111111111111111111111111111111111111111111
//000000011111111112222222222333333333344444444445555555555666666666677777777778888888888999999999900000000001111111111222222222233333333334444444
//345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456
//------------------------------------------------------------------------------------------------------------------------------------------------
module hqm_AW_rrwrand_arb_windex

import hqm_AW_pkg::* ;
# (
    parameter NUM_REQS                                  = 8
  , parameter NUM_PRI                                   = 8
  , parameter SEED                                      = 1
  //...............................................................................................................................................
  , parameter NUM_REQSB2                                = ( AW_logb2 ( NUM_REQS - 1 ) + 1 )
  , parameter NUM_PRIB2                                 = ( AW_logb2 ( NUM_PRI - 1 ) + 1 )
  ) (
    input  logic                                        clk
  , input  logic                                        rst_n
  , input  logic [ ( NUM_PRI * 8 ) - 1 : 0 ]            cfg_weight_last
  , input  logic [ ( NUM_PRI * NUM_REQSB2 ) -1 : 0]     index_f
  , input  logic [ ( NUM_PRI * NUM_REQS ) - 1 : 0 ]     reqs
  , output logic [ ( 1 ) - 1 : 0 ]                      winner_v
  , output logic [ ( NUM_PRIB2 ) - 1 : 0 ]              winner_pri
  , output logic [ ( NUM_REQSB2 ) - 1 : 0 ]             winner
  , output logic                                        winner_boosted
) ;

//------------------------------------------------------------------------------------------------------------------------------------------------
//Instances & Registers
genvar GEN0 ;
logic [ ( NUM_PRI * 1 ) - 1 : 0 ] rr_winner_v ;
logic [ ( NUM_PRI * NUM_REQSB2 ) - 1 : 0 ] rr_winner ;
logic [ ( 1 ) - 1 : 0 ] rand_winner_v ;
logic [ ( NUM_PRIB2 ) - 1 : 0 ] rand_winner ;

generate
for ( GEN0 = 0 ; GEN0 < NUM_PRI ; GEN0 = GEN0 + 1 ) begin: L00
  hqm_AW_rr_arb_windex # (
      .NUM_REQS                                         ( NUM_REQS )
    ) i_hqm_AW_rr_arb_windex (
      .clk                                              ( clk )
    , .rst_n                                            ( rst_n )
    , .reqs                                             ( reqs [ ( GEN0 * NUM_REQS ) +: NUM_REQS ] )
    , .index_f                                          ( index_f [ ( GEN0 * NUM_REQSB2 ) +: NUM_REQSB2 ] )
    , .winner_v                                         ( rr_winner_v [ GEN0 ] )
    , .winner                                           ( rr_winner [ ( GEN0 * NUM_REQSB2 ) +: NUM_REQSB2 ] )
  ) ;
end
endgenerate

hqm_AW_wrand_arb_wupdate # (
    .NUM_REQS                                           ( NUM_PRI )
  , .SEED                                               ( SEED )
  ) i_hqm_AW_wrand_arb (
    .clk                                                ( clk )
  , .rst_n                                              ( rst_n )
  , .cfg_weight                                         ( cfg_weight_last )
  , .reqs                                               ( rr_winner_v )
  , .update                                           ( rand_winner_v )
  , .winner_v                                           ( rand_winner_v )
  , .winner                                             ( rand_winner )
  , .winner_boosted                                   ( winner_boosted )
) ;

//------------------------------------------------------------------------------------------------------------------------------------------------
always_comb
begin
  //..............................................................................................................................................
  //output values
  winner_v                                              = rand_winner_v ;
  winner_pri                                            = rand_winner ;
  winner                                                = rr_winner [ ( winner_pri * NUM_REQSB2 ) +: NUM_REQSB2 ] ; 

end

endmodule
