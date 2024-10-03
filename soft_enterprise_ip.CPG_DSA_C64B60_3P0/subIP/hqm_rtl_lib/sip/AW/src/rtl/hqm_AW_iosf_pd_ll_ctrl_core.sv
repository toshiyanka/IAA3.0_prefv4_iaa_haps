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
//
//-----------------------------------------------------------------------------------------------------
module hqm_AW_iosf_pd_ll_ctrl_core
import hqm_AW_pkg::* ;
# (
  parameter DEPTH                                 = 64
, parameter DWIDTH                                = 256
, parameter CHANNELS                              = 4
//...............................................................................................................................................
, parameter DEPTHB2                               = ( AW_logb2 ( DEPTH - 1 ) + 1 )
, parameter CHANNELSB2                            = ( AW_logb2 ( CHANNELS - 1 ) + 1 )
) (
  input  logic                                    clk
, input  logic                                    rst_n

, output logic                                    mem_re
, output logic [ ( DEPTHB2 ) - 1 : 0 ]            mem_raddr
, output logic                                    mem_we
, output logic [ ( DEPTHB2 ) - 1 : 0 ]            mem_waddr
, output logic [ ( DWIDTH ) - 1 : 0 ]             mem_wdata

, output logic                                    error_memcol
, output logic                                    error_uf
, output logic                                    error_illpop
, output logic                                    error_of
, output logic                                    error_illpush
, output logic                                    error_flcol
, output logic                                    error_ptrparity

, output logic [ ( CHANNELS ) - 1 : 0 ]           empty
, output logic [ ( 8 ) - 1 : 0 ]                  status

, input  logic                                    push_v
, input  logic [ ( CHANNELSB2 ) - 1 : 0 ]         push_chid
, input  logic [ ( DWIDTH ) - 1 : 0 ]             push_hcw

, input  logic                                    pop_v
, input  logic [ ( CHANNELSB2 ) - 1 : 0 ]         pop_chid
) ;

logic [ ( CHANNELS ) - 1 : 0 ] v_nxt , v_f ;
logic [ ( CHANNELS * DEPTHB2 ) - 1 : 0 ] hptr_nxt , hptr_f , tptr_nxt , tptr_f ;
logic [ ( DEPTH * DEPTHB2 ) - 1 : 0 ] nxthptr_nxt , nxthptr_f ;
logic [ ( DEPTHB2 + 1 ) - 1 : 0 ] flst_cnt_nxt , flst_cnt_f ;
logic parity_nxt , parity_f ;
logic [ ( CHANNELS ) - 1 : 0 ] mod_hptr_parity , mod_tptr_parity ;
always_ff @ ( posedge clk or negedge rst_n ) begin : L01
  if ( rst_n == 1'd0 ) begin
    v_f <= '0 ;
    hptr_f <= '0 ;
    tptr_f <= '0 ;
    nxthptr_f <= '0 ;
    flst_cnt_f <= '0 ;
    parity_f <= '0 ;
  end else begin
    v_f <= v_nxt ;
    hptr_f <= hptr_nxt ;
    tptr_f <= tptr_nxt ;
    nxthptr_f <= nxthptr_nxt ;
    flst_cnt_f <= flst_cnt_nxt ;
    parity_f <= parity_nxt ;
  end 
end

logic freelist_pop ;
logic freelist_pop_id_v ;
logic [ ( DEPTHB2 ) - 1 : 0 ] freelist_pop_id ;
logic freelist_push ;
logic [ ( DEPTHB2 ) - 1 : 0 ] freelist_push_id ;
logic [ ( DEPTH ) - 1 : 0 ] freelist_id_vector ;
hqm_AW_id_freelist #(
  .NUM_IDS ( DEPTH )
) i_freelist (
  .clk ( clk )
, .rst_n ( rst_n )
, .pop ( freelist_pop )
, .pop_id_v ( freelist_pop_id_v )
, .pop_id ( freelist_pop_id )
, .push ( freelist_push )
, .push_id ( freelist_push_id )
, .id_vector ( freelist_id_vector )
) ;

always_comb begin : L0F
  empty = ~ ( v_f ) ;
  status = { 1'b0 , flst_cnt_f } ;

  mem_re = '0 ;
  mem_raddr = '0 ;
  mem_we = '0 ;
  mem_waddr = '0 ;
  mem_wdata = '0 ;

  v_nxt = v_f ;
  hptr_nxt = hptr_f ;
  tptr_nxt = tptr_f ;
  nxthptr_nxt = nxthptr_f ;
  flst_cnt_nxt = flst_cnt_f ;

  freelist_pop = '0 ;
  freelist_push = '0 ;
  freelist_push_id = '0 ;

  mod_hptr_parity = '0 ;
  mod_tptr_parity = '0 ;

  //////////////////////////////////////////////////
  if ( pop_v ) begin
   //decrement counter
   flst_cnt_nxt = flst_cnt_nxt - {{(DEPTHB2){1'b0}},1'b1} ;
   
   //update LL HP,TP, and NXTHP
   hptr_nxt [ ( pop_chid * DEPTHB2 ) +: DEPTHB2 ] = nxthptr_f [ ( hptr_f [ ( pop_chid * DEPTHB2 ) +: DEPTHB2 ] * DEPTHB2 ) +: DEPTHB2 ] ; mod_hptr_parity [ pop_chid ] = ( ( ^ hptr_f [ ( pop_chid * DEPTHB2 ) +: DEPTHB2 ] ) ^ ( ^ hptr_nxt [ ( pop_chid * DEPTHB2 ) +: DEPTHB2 ] ) ) ; 
   
   //set valid vector for channel
   if ( hptr_f [ ( pop_chid * DEPTHB2 ) +: DEPTHB2 ] == tptr_f [ ( pop_chid * DEPTHB2 ) +: DEPTHB2 ] ) begin 
     v_nxt [ pop_chid ] = 1'b0 ;
   end
   
   //update freelist
   freelist_push = 1'b1 ;
   freelist_push_id =  hptr_f [ ( pop_chid * DEPTHB2 ) +: DEPTHB2 ] ; 
   
   //memory commands
   mem_re = 1'b1 ;
   mem_raddr = hptr_f [ ( pop_chid * DEPTHB2 ) +: DEPTHB2 ] ; 
  end

  //////////////////////////////////////////////////
  if ( push_v ) begin 
   //increment counter
   flst_cnt_nxt = flst_cnt_nxt + {{(DEPTHB2){1'b0}},1'b1} ;

   //update LL HP,TP, and NXTHP
   if ( ~ v_nxt [ push_chid ] ) begin
     tptr_nxt [ ( push_chid * DEPTHB2 ) +: DEPTHB2 ] = freelist_pop_id ; mod_tptr_parity [ push_chid ] = ( ( ^ tptr_f [ ( push_chid * DEPTHB2 ) +: DEPTHB2 ] ) ^ ( ^ tptr_nxt [ ( push_chid * DEPTHB2 ) +: DEPTHB2 ] ) ) ; 
     hptr_nxt [ ( push_chid * DEPTHB2 ) +: DEPTHB2 ] = freelist_pop_id ; mod_hptr_parity [ push_chid ] = ( ( ^ hptr_f [ ( push_chid * DEPTHB2 ) +: DEPTHB2 ] ) ^ ( ^ hptr_nxt [ ( push_chid * DEPTHB2 ) +: DEPTHB2 ] ) ) ; 
     nxthptr_nxt [ ( freelist_pop_id * DEPTHB2 ) +: DEPTHB2 ] = freelist_pop_id ; 
   end 
   else begin
     tptr_nxt [ ( push_chid * DEPTHB2 ) +: DEPTHB2 ] = freelist_pop_id ; mod_tptr_parity [ push_chid ] = ( ( ^ tptr_f [ ( push_chid * DEPTHB2 ) +: DEPTHB2 ] ) ^ ( ^ tptr_nxt [ ( push_chid * DEPTHB2 ) +: DEPTHB2 ] ) ) ; 
     nxthptr_nxt [ ( tptr_f [ ( push_chid * DEPTHB2 ) +: DEPTHB2 ] * DEPTHB2 ) +: DEPTHB2 ] = freelist_pop_id ; 
   end

   //set valid vector for channel
   v_nxt [ push_chid ] = 1'b1 ;

   //update freelist
   freelist_pop = 1'b1 ;

   //memory commands
   mem_we = 1'b1 ;
   mem_waddr = freelist_pop_id ;
   mem_wdata = push_hcw ;
  end

  //////////////////////////////////////////////////
  // ERROR conditions
  parity_nxt      = ( parity_f ^ ( ^ { mod_hptr_parity , mod_tptr_parity } ) ) ;
  error_memcol    = ( mem_we & mem_re & ( mem_waddr == mem_raddr ) ) ;
  error_uf        = ( pop_v & ( flst_cnt_f == {{(DEPTHB2){1'b0}},1'b0} ) ) ;
  error_illpop    = ( pop_v & ~ v_f [ pop_chid ] ) ;
  error_of        = ( push_v & ( flst_cnt_f == DEPTH [ DEPTHB2 : 0 ] ) ) ;
  error_illpush   = ( push_v & ( ~ freelist_pop_id_v ) ) ;
  error_flcol     = ( freelist_push & ( freelist_id_vector [ freelist_push_id ] ) ) ;
  error_ptrparity = ( parity_f ^ ( ^ { hptr_f , tptr_f } ) ) ;
end

endmodule
