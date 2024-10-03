//-----------------------------------------------------------------------------------------------------
// INTEL CONFIDENTIAL
//
// Copyright 2020 Intel Corporation All Rights Reserved.
//
// The source code contained or described herein and all documents related to the source code
// ("Material") are owned by Intel Corporation or its suppliers or licensors. Title to the Material
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
//-----------------------------------------------------------------------------------------------------
//  dedicated arbiter for CHP hqm_credit_hist_pipe_arbiter issue arbiter.
//    reqs[0] must be connected to sch_ldb_arb winner_v
//    reqs[1] must be connected to enq_dir_arb winner_v
//    reqs[2] must be connected to sch_dir_arb winner_v
//    reqs[3] must be connected to enq_ldb_arb winner_v
// input port winner_dual indicates that both reqs from a set
//    { sch_ldb_arb & enq_dir_arb } or { sch_dir_arb & enq_ldb_arb }
// are taken and high prioirty index should advance to the loser set when update is also asserted.
//-----------------------------------------------------------------------------------------------------
module hqm_credit_hist_pipe_issue_arb (
   input  logic                  hqm_gated_clk
 , input  logic                  hqm_gated_rst_b
 , input  logic [ ( 4 ) - 1 : 0] reqs
 , input  logic                  update
 , output logic                  winner_v
 , output logic [ ( 2 ) - 1 : 0] winner
 , input  logic                  winner_dual
) ;

logic [ ( 2 ) - 1 : 0] index_f , index_nxt ;
always_ff @ ( posedge hqm_gated_clk or negedge hqm_gated_rst_b ) begin
  if ( ~ hqm_gated_rst_b ) begin
    index_f <= '0 ;
  end
  else begin
    index_f <= index_nxt ;
  end
end // always

always_comb begin
  case ( { ( winner_v & update ) , winner_dual , winner } )
     4'b1_0_00
   , 4'b1_0_01
   , 4'b1_0_10
   , 4'b1_0_11 : index_nxt = winner + 2'd1 ;

     4'b1_1_00
   , 4'b1_1_01 : index_nxt = 2'b10 ;

     4'b1_1_10
   , 4'b1_1_11 : index_nxt = 2'b00 ;
 
    default   : index_nxt = index_f;
  endcase
end

hqm_AW_rr_arb_windex # (
   .NUM_REQS             ( 4 )
) i_atq_nfull_arb (
   .clk                  ( hqm_gated_clk )
 , .rst_n                ( hqm_gated_rst_b )
 , .reqs                 ( reqs )
 , .index_f              ( index_f )
 , .winner_v             ( winner_v )
 , .winner               ( winner )
) ;

endmodule
