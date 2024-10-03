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
// hqm_lsp_atm_enq_reg
//
//------------------------------------------------------------------------------------------------------------------------------------------------
//000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011111111111111111111111111111111111111111111111
//000000011111111112222222222333333333344444444445555555555666666666677777777778888888888999999999900000000001111111111222222222233333333334444444
//345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456
//------------------------------------------------------------------------------------------------------------------------------------------------

module hqm_lsp_atm_enq_reg (

  input logic clk
, input logic rst_n

, input logic push
, input logic [ ( 6 ) -1 : 0 ] push_cq
, input logic [ ( 7 ) -1 : 0 ] push_qid
, input logic [ ( 3 ) -1 : 0 ] push_qidix
, input logic  push_parity
, input logic [ ( 3 ) -1 : 0 ] push_qpri
, input logic [ ( 2 ) -1 : 0 ] push_bin
, input logic [ ( 12 ) -1 : 0 ] push_fid
, input logic  push_fid_parity

, input logic pop
, output logic [ ( 6 ) -1 : 0 ] pop_cq
, output logic [ ( 7 ) -1 : 0 ] pop_qid
, output logic [ ( 3 ) -1 : 0 ] pop_qidix
, output logic  pop_parity
, output logic [ ( 3 ) -1 : 0 ] pop_qpri
, output logic [ ( 2 ) -1 : 0 ] pop_bin
, output logic [ ( 12 ) -1 : 0 ] pop_fid
, output logic  pop_fid_parity

, output logic pop_v 
, output logic hold_v 

, input logic byp
, input logic [ ( 12 ) -1 : 0 ] byp_fid
, input logic [ ( 6 ) -1 : 0 ] byp_cq
, input logic [ ( 3 ) -1 : 0 ] byp_qidix

) ;

logic data_v_f , data_v_nxt ;
logic [ ( 6 ) -1 : 0 ] data_cq_f , data_cq_nxt ;
logic [ ( 7 ) -1 : 0 ] data_qid_f , data_qid_nxt ;
logic [ ( 3 ) -1 : 0 ] data_qidix_f , data_qidix_nxt ;
logic  data_parity_f , data_parity_nxt ;
logic [ ( 3 ) -1 : 0 ] data_qpri_f , data_qpri_nxt ;
logic [ ( 2 ) -1 : 0 ] data_bin_f , data_bin_nxt ;
logic [ ( 12 ) -1 : 0 ] data_fid_f , data_fid_nxt ;
logic  data_fid_parity_f , data_fid_parity_nxt ;

always_ff @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    data_v_f <= '0 ;

    data_cq_f <= '0 ;
    data_qid_f <= '0 ;
    data_qidix_f <= '0 ;
    data_parity_f <= '0 ;
    data_qpri_f <= '0 ;
    data_bin_f <= '0 ;
    data_fid_f <= '0 ;
    data_fid_parity_f <= '0 ;
  end
  else begin
    data_v_f <= data_v_nxt ;

    data_cq_f <= data_cq_nxt ; 
    data_qid_f <= data_qid_nxt ;
    data_qidix_f <= data_qidix_nxt ; 
    data_parity_f <= data_parity_nxt ;
    data_qpri_f <= data_qpri_nxt ;
    data_bin_f <= data_bin_nxt ;
    data_fid_f <= data_fid_nxt ;
    data_fid_parity_f <= data_fid_parity_nxt ;
  end
end

always_comb begin
  //drive default outputs 
  pop_v = data_v_f ;
  hold_v = data_v_f & ~pop ; 
  pop_cq = data_cq_f ;
  pop_qid = data_qid_f ;
  pop_qidix = data_qidix_f ;
  pop_parity = data_parity_f ;
  pop_qpri = data_qpri_f ;
  pop_bin = data_bin_f ;
  pop_fid = data_fid_f ;
  pop_fid_parity = data_fid_parity_f ;

  //drive default register input
  data_v_nxt = data_v_f ;
  data_cq_nxt = data_cq_f ;
  data_qid_nxt = data_qid_f ;
  data_qidix_nxt = data_qidix_f ;
  data_parity_nxt = data_parity_f ;
  data_qpri_nxt = data_qpri_f ;
  data_bin_nxt = data_bin_f ;
  data_fid_nxt = data_fid_f ;
  data_fid_parity_nxt = data_fid_parity_f ;

  if ( ( pop == 1'b1 )
     ) begin
    data_v_nxt = 1'b0 ;
  end


  //capture input request
  if ( ( push == 1'b1 )
     ) begin
    data_v_nxt = 1'b1 ;
    data_cq_nxt = push_cq ;
    data_qid_nxt = push_qid ;
    data_qidix_nxt = push_qidix ;
    data_parity_nxt = push_parity ;
    data_qpri_nxt = push_qpri ;
    data_bin_nxt = push_bin ;
    data_fid_nxt = push_fid ;
    data_fid_parity_nxt = push_fid_parity ;
  end

  //bypass input overides output & regster when fid matches 
  if ( ( byp == 1'b1 )
     & ( byp_fid == data_fid_f )
     ) begin 
    pop_cq = byp_cq ;
    pop_qidix = byp_qidix ;
  end
  if ( ( byp == 1'b1 )
     & ( byp_fid == data_fid_nxt )
     ) begin
    data_cq_nxt = byp_cq ;
    data_qidix_nxt = byp_qidix ;
  end

end

endmodule
