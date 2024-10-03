//-----------------------------------------------------------------------------------------------------
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
//-----------------------------------------------------------------------------------------------------
//
//-----------------------------------------------------------------------------------------------------
module hqm_chp_hazard_pool_cnt (
  input  logic                    clk
, input  logic                    rst_n

, input  logic                    ldb_push
, input  logic [ ( 6 ) -  1 : 0 ] ldb_push_pool
, input  logic                    ldb_pop

, input  logic                    dir_push
, input  logic [ ( 6 ) -  1 : 0 ] dir_push_pool
, input  logic                    dir_pop

, input  logic                    pp_push
, input  logic                    pp_push_type
, input  logic [ ( 6 ) -  1 : 0 ] pp_push_pool
, input  logic                    pp_pop

, input  logic                    rf_pool_credit_count_we_0
, input  logic [ ( 6 ) -1 : 0 ]   rf_pool_credit_count_waddr_0
, input  logic [ ( 16 ) -1 : 0 ]  rf_pool_credit_count_wdata_0

, input  logic                    rf_pool_credit_count_we_1
, input  logic [ ( 6 ) -1 : 0 ]   rf_pool_credit_count_waddr_1
, input  logic [ ( 18 ) -1 : 0 ]  rf_pool_credit_count_wdata_1

, output logic                    stall
);

logic [ ( 3 ) - 1 : 0 ] ldb_rp_nxt , ldb_rp_f ;
logic [ ( 3 ) - 1 : 0 ] ldb_wp_nxt , ldb_wp_f ;
logic [ ( 8 ) - 1 : 0 ] ldb_v_nxt , ldb_v_f ;
logic [ ( 8 ) - 1 : 0 ] ldb_stall_nxt , ldb_stall_f ;
logic [ ( 8 * 6 ) - 1 : 0 ] ldb_pool_nxt , ldb_pool_f ;

logic [ ( 3 ) - 1 : 0 ] dir_rp_nxt , dir_rp_f ;
logic [ ( 3 ) - 1 : 0 ] dir_wp_nxt , dir_wp_f ;
logic [ ( 8 ) - 1 : 0 ] dir_v_nxt , dir_v_f ;
logic [ ( 8 ) - 1 : 0 ] dir_stall_nxt , dir_stall_f ;
logic [ ( 8 * 6 ) - 1 : 0 ] dir_pool_nxt , dir_pool_f ;

logic [ ( 8 ) - 1 : 0 ] pp_type_nxt , pp_type_f ; 
logic [ ( 8 * 6 ) - 1 : 0 ] pp_pool_nxt , pp_pool_f ;
logic [ ( 3 ) - 1 : 0 ] pp_rp_nxt , pp_rp_f ;
logic [ ( 3 ) - 1 : 0 ] pp_wp_nxt , pp_wp_f ;
logic [ ( 8 ) - 1 : 0 ] pp_v_nxt , pp_v_f ; 

logic pp_ldb_valid ;
logic pp_dir_valid ;
logic [ ( 8 ) - 1 : 0 ] pp_ldb_stall ;
logic [ ( 8 ) - 1 : 0 ] pp_dir_stall ;

always_ff @( posedge clk or negedge rst_n ) begin
  if (~rst_n) begin
    ldb_rp_f <= '0 ;
    ldb_wp_f <= '0 ;
    ldb_v_f <= '0 ;
    ldb_stall_f <= '0 ;
    ldb_pool_f <= '0 ;
    dir_rp_f <= '0 ;
    dir_wp_f <= '0 ;
    dir_v_f <= '0 ;
    dir_stall_f <= '0 ;
    dir_pool_f <= '0 ;
    pp_type_f <= '0 ;
    pp_pool_f <= '0 ;
    pp_rp_f <= '0 ;
    pp_wp_f <= '0 ;
    pp_v_f <= '0 ;
  end
  else begin
    ldb_rp_f <= ldb_rp_nxt ;
    ldb_wp_f <= ldb_wp_nxt ;
    ldb_v_f <= ldb_v_nxt ;
    ldb_stall_f <= ldb_stall_nxt ;
    ldb_pool_f <= ldb_pool_nxt ;
    dir_rp_f <= dir_rp_nxt ;
    dir_wp_f <= dir_wp_nxt ;
    dir_v_f <= dir_v_nxt ;
    dir_stall_f <= dir_stall_nxt ;
    dir_pool_f <= dir_pool_nxt ;
    pp_type_f <= pp_type_nxt ;
    pp_pool_f <= pp_pool_nxt ;
    pp_rp_f <= pp_rp_nxt ;
    pp_wp_f <= pp_wp_nxt ;
    pp_v_f <= pp_v_nxt ;
  end
end

always_comb begin

  //--------------------------------------------------
  //FIFO to store pool active in LDB freelist return FIFO
  ldb_rp_nxt = ldb_rp_f ;
  ldb_wp_nxt = ldb_wp_f ;
  ldb_v_nxt = ldb_v_f ;
  ldb_stall_nxt = ldb_stall_f ;
  ldb_pool_nxt = ldb_pool_f ;

  if ( ldb_pop ) begin
    ldb_rp_nxt = ldb_rp_f + 3'd1 ;
    ldb_v_nxt [ ldb_rp_f ] = 1'b0 ;
  end
  if ( ldb_push ) begin
    ldb_wp_nxt = ldb_wp_f + 3'd1 ;
    ldb_v_nxt [ ldb_wp_f ] = 1'b1 ;
    ldb_stall_nxt [ ldb_wp_f ] = 1'b0 ;
    ldb_pool_nxt [ ( ldb_wp_f * 6 ) +: 6 ] = ldb_push_pool ;
  end 
  // when writing pool credit count RAM & # credits is less than max stored in freelist then mark the pool to stall so PP does not get ahead of freelist credit return
  if ( ( rf_pool_credit_count_we_0 ) 
     & ( rf_pool_credit_count_wdata_0 < 16'd8 )
     ) begin
    for ( int i = 0 ; i < 8 ; i = i + 1 ) begin
      if ( ( ldb_v_nxt [ i ] )
         & ( ldb_pool_nxt [ (i * 6 ) +: 6 ] == rf_pool_credit_count_waddr_0 )
         ) begin
        ldb_stall_nxt [ i ] = 1'b1 ;
      end
    end
  end

  //--------------------------------------------------
  // FIFO to store pool active in DIR freelist return FIFO
  dir_rp_nxt = dir_rp_f ;
  dir_wp_nxt = dir_wp_f ;
  dir_v_nxt = dir_v_f ; 
  dir_stall_nxt = dir_stall_f ; 
  dir_pool_nxt = dir_pool_f ;

  if ( dir_pop ) begin
    dir_rp_nxt = dir_rp_f + 3'd1 ;
    dir_v_nxt [ dir_rp_f ] = 1'b0 ;
  end
  if ( dir_push ) begin
    dir_wp_nxt = dir_wp_f + 3'd1 ;
    dir_v_nxt [ dir_wp_f ] = 1'b1 ;
    dir_stall_nxt [ dir_wp_f ] = 1'b0 ;
    dir_pool_nxt [ ( dir_wp_f * 6 ) +: 6 ] = dir_push_pool ;
  end
  // when writing pool credit count RAM & # credits is less than max stored in freelist then mark the pool to stall so PP does not get ahead of freelist credit return
  if ( ( rf_pool_credit_count_we_1 )
     & ( rf_pool_credit_count_wdata_1 < 16'd8 )
     ) begin
    for ( int i = 0 ; i < 8 ; i = i + 1 ) begin
      if ( ( dir_v_nxt [ i ] )
         & ( dir_pool_nxt [ ( i * 6 ) +: 6 ] == rf_pool_credit_count_waddr_1 )
         ) begin
        dir_stall_nxt [ i ] = 1'b1 ;
      end
    end
  end

  //--------------------------------------------------
  //FIFO to store pool (and type) active in PP push drain FIFO
  pp_type_nxt = pp_type_f ;
  pp_pool_nxt = pp_pool_f ;
  pp_rp_nxt = pp_rp_f ;
  pp_wp_nxt = pp_wp_f ;
  pp_v_nxt = pp_v_f ; 

  if ( pp_pop ) begin
    pp_rp_nxt = pp_rp_f + 3'd1 ;
    pp_v_nxt [ pp_rp_f ] = 1'b0 ;
  end
  if ( pp_push ) begin
    pp_wp_nxt = pp_wp_f + 3'd1 ;
    pp_v_nxt [ pp_wp_f ] = 1'b1 ;
    pp_type_nxt [ pp_wp_f ] = pp_push_type ;
    pp_pool_nxt [ ( pp_wp_f * 6 ) +: 6 ] = pp_push_pool ;
  end

  //--------------------------------------------------
  // Stall asserted when PP push drain FIFO head pointer pool is about to enter the hazard state 
  //   hazard exists when pool credit count is reduced to zero and a push pointer is issued to provide 
  //   the credits BEFORE and those credits are stuck in the freelist return FIFO and not returned 
  //   before the enqueue is seen
  stall = '0 ;
  pp_ldb_valid = '0 ;
  pp_dir_valid = '0 ;
  pp_ldb_stall = '0 ;
  pp_dir_stall = '0 ;
  
  // determine if PP drain FIFO head pool is LDB or DIR
  pp_ldb_valid = ( pp_v_f [ pp_rp_f ] & pp_type_f [ pp_rp_f ] ) ; 
  pp_dir_valid = ( pp_v_f [ pp_rp_f ] & ~ pp_type_f [ pp_rp_f ] ) ;
  
  // determine if PP drain FIFO head pool is marked to stall in LDB or DIR credit return FIFO
  for (int i = 0 ; i < 8 ; i = i + 1 ) begin
    pp_ldb_stall [ i ] = ( ldb_stall_f [ i ] & ( ldb_pool_f [ ( i * 6 ) +: 6 ] == pp_pool_f [ ( pp_rp_f * 6 ) +: 6 ] ) ) ;
  end 
  for (int i = 0 ; i < 8 ; i = i + 1 ) begin
    pp_dir_stall [ i ] = ( dir_stall_f [ i ] & ( dir_pool_f [ ( i * 6 ) +: 6 ] == pp_pool_f [ ( pp_rp_f * 6 ) +: 6 ] ) ) ;
  end
  
  stall = ( ( pp_ldb_valid & ( | pp_ldb_stall ) )
          | ( pp_dir_valid & ( | pp_dir_stall ) )
          ) ;

end

endmodule
