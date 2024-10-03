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
// hqm_lsp_atm_enq_arb
//
// select from 4 enqueue FIFOs & try to avoid pipeline collisions.
// eqch of te FIFO should store unique qid to help reduce pipeline collisions
// The pipeline collision is caused by enq/sch/comp with a qid that matches the qid in a future pipeline stage that the enq/sch/comp needs to wait for the updated data
//
//  * no enqueue requestor can be masked for more than 4 clocks. After 4 clocks it is selected and the mask is ov
//  * whan a reqeustor is being masked, it will remain the high prioirty requestor until it is selected (at most 4 clocks)
//  * when the high prioirty requestor is being masked then the alternate arbiter can select an unmasked enqueue FIFO to remain work conserving
//
//------------------------------------------------------------------------------------------------------------------------------------------------
//000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011111111111111111111111111111111111111111111111
//000000011111111112222222222333333333344444444445555555555666666666677777777778888888888999999999900000000001111111111222222222233333333334444444
//345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456
//------------------------------------------------------------------------------------------------------------------------------------------------

module hqm_lsp_atm_enq_arb
  import hqm_AW_pkg::*;
#(
  parameter HQM_ATM_NUM_REQS = 4
//................................................................................................................................................
, parameter HQM_ATM_NUM_REQSB2 = ( AW_logb2 ( HQM_ATM_NUM_REQS - 1 ) + 1 )
) (
  input logic clk
, input logic rst_n
, input logic [ ( 3 ) - 1 : 0 ] cfg
, input logic [( HQM_ATM_NUM_REQS ) - 1 : 0 ] reqs
, input logic [( HQM_ATM_NUM_REQS ) - 1 : 0 ] mask
, input logic update
, output logic winner_v
, output logic [( HQM_ATM_NUM_REQSB2 ) - 1 : 0 ] winner
) ;

logic alt_winner_v ;
logic [( HQM_ATM_NUM_REQSB2 ) - 1 : 0 ] alt_winner ;
logic [( HQM_ATM_NUM_REQS ) - 1 : 0 ] alt_reqs ;
logic alt_update ;
hqm_AW_rr_arb # (
  .NUM_REQS ( HQM_ATM_NUM_REQS )
) i_hqm_AW_rr_arb_alt (
  .clk ( clk )
, .rst_n ( rst_n )
, .reqs ( alt_reqs )
, .update ( alt_update )
, .winner_v ( alt_winner_v ) 
, .winner ( alt_winner ) 
) ;

logic hp_winner_v ; 
logic [( HQM_ATM_NUM_REQSB2 ) - 1 : 0 ] hp_winner ;
logic [( HQM_ATM_NUM_REQS ) - 1 : 0 ] hp_reqs ;
logic hp_update ;
hqm_AW_rr_arb # (
  .NUM_REQS ( HQM_ATM_NUM_REQS ) 
) i_hqm_AW_rr_arb_hp (
  .clk ( clk )
, .rst_n ( rst_n )
, .reqs ( hp_reqs )
, .update ( hp_update )
, .winner_v ( hp_winner_v )
, .winner ( hp_winner ) 
) ;

logic [ ( 3 ) - 1 : 0 ] stall_nxt , stall_f ;
logic  stallmax_nxt , stallmax_f ;
always_ff @( posedge clk or negedge rst_n ) begin
  if (!rst_n ) begin
    stall_f <= '0 ;
    stallmax_f <= '0 ;
  end
  else begin
    stall_f <= stall_nxt ;
    stallmax_f <= stallmax_nxt ;
  end
end

always_comb begin
  winner_v = '0 ;
  winner = '0 ;

  stall_nxt = stall_f ;
  stallmax_nxt = stallmax_f ;

  hp_reqs = reqs ;
  hp_update = '0 ;
  alt_reqs = reqs & mask ;
  alt_update = '0 ;


    if ( alt_winner_v & hp_winner_v & mask [ hp_winner ]) begin
        stall_nxt = stall_f + 3'd1 ;
        if ( stall_f > cfg ) begin
          stallmax_nxt = 1'b1 ;
        end
    end


    // hp winner is being masked & there is an alternate choice available (if no alternate then select hp even when masking)
    if ( alt_winner_v ) begin
      //after a maximum stall amount then allow masked hp to win and overrride the mask 
      if ( stallmax_f ) begin
        stall_nxt = '0 ;
        stallmax_nxt = '0 ;
        winner_v = hp_winner_v ;
        winner = hp_winner ;
        hp_update = update ;
      end
      //the hp winner is being masked, if the alternate arb has a winner then select it
      else begin
          winner_v = alt_winner_v ;
          winner = alt_winner ;
          alt_update = update ;
      end
    end

    //hp winner is not masked and it is selected
    else begin
      stall_nxt = '0 ;
      stallmax_nxt = '0 ;
      winner_v = hp_winner_v ;
      winner = hp_winner ;
      hp_update = update ;
    end
  end


endmodule
