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
module hqm_AW_iosf_pd_ll_ctrl
import hqm_AW_pkg::* ;
# (
  parameter DEPTH                                 = 64
, parameter DWIDTH                                = 256
, parameter CHANNELS                              = 4
//...............................................................................................................................................
, parameter DEPTHB2                               = ( AW_logb2 ( DEPTH - 1 ) + 1 )
, parameter CHANNELSB2                            = ( AW_logb2 ( CHANNELS - 1 ) + 1 )
, parameter DEPTHB2P1                             = DEPTHB2 + 1
, parameter PARITY                                = 8
, parameter DWIDTH_PARITY                         = DWIDTH + PARITY
) (
  input  logic                                    clk
, input  logic                                    rst_n

, output logic                                    mem_re
, output logic [ ( DEPTHB2 ) - 1 : 0 ]            mem_raddr
, input  logic [ ( DWIDTH ) - 1 : 0 ]             mem_rdata
, output logic                                    mem_we
, output logic [ ( DEPTHB2 ) - 1 : 0 ]            mem_waddr
, output logic [ ( DWIDTH ) - 1 : 0 ]             mem_wdata

, input  logic [ ( DEPTHB2P1 ) - 1 : 0 ]          cfg_high_wm
, output logic                                    error_db_ch0
, output logic                                    error_db_ch1
, output logic                                    error_db_ch2
, output logic                                    error_db_ch3
, output logic                                    error_memcol
, output logic                                    error_uf
, output logic                                    error_illpop
, output logic                                    error_of
, output logic                                    error_illpush
, output logic                                    error_flcol
, output logic                                    error_ptrparity
, output logic                                    error_dbcol

, output logic [ ( CHANNELS ) - 1 : 0 ]           empty
, output logic                                    afull
, output logic [ ( 32 ) - 1 : 0 ]                 status

, input  logic                                    push_v
, input  logic [ ( CHANNELSB2 ) - 1 : 0 ]         push_chid
, input  logic [ ( DWIDTH ) - 1 : 0 ]             push_hcw

, input  logic                                    pop_v
, input  logic [ ( CHANNELSB2 ) - 1 : 0 ]         pop_chid
, output logic [ ( DWIDTH ) - 1 : 0 ]             pop_hcw
, output logic                                    pop_hcw_parity
) ;

logic [ ( CHANNELS ) - 1 : 0 ] core_empty ;
logic [ ( 8 ) - 1 : 0 ] core_status ;
logic core_push_v ;
logic [ ( CHANNELSB2 ) - 1 : 0 ] core_push_chid ;
logic [ ( DWIDTH ) - 1 : 0 ] core_push_hcw ;
logic core_pop_v ;
logic [ ( CHANNELSB2 ) - 1 : 0 ] core_pop_chid ;
hqm_AW_iosf_pd_ll_ctrl_core #(
  .DEPTH ( DEPTH )
, .DWIDTH ( DWIDTH )
, .CHANNELS ( CHANNELS )
) i_core (
  .clk ( clk )
, .rst_n ( rst_n )
, .mem_re ( mem_re )
, .mem_raddr ( mem_raddr )
, .mem_we ( mem_we )
, .mem_waddr ( mem_waddr )
, .mem_wdata ( mem_wdata )
, .error_memcol ( error_memcol )
, .error_uf ( error_uf )
, .error_illpop ( error_illpop )
, .error_of ( error_of )
, .error_illpush ( error_illpush )
, .error_flcol ( error_flcol )
, .error_ptrparity ( error_ptrparity )
, .empty ( core_empty )
, .status ( core_status )
, .push_v ( core_push_v )
, .push_chid ( core_push_chid )
, .push_hcw ( core_push_hcw )
, .pop_v ( core_pop_v )
, .pop_chid ( core_pop_chid )
) ;

logic [ 1 : 0 ] db_ch0_status ;
logic db_ch0_in_push ;
logic [ ( DWIDTH_PARITY ) - 1 : 0 ] db_ch0_in_data ;
logic db_ch0_in_push_2 ;
logic [ ( DWIDTH_PARITY ) - 1 : 0 ] db_ch0_in_data_2 ;
logic db_ch0_out_pop ;
logic [ ( DWIDTH_PARITY ) - 1 : 0 ] db_ch0_out_data ;
hqm_AW_iosf_pd_ll_ctrl_core_db #(
 .DWIDTH ( DWIDTH_PARITY )
) i_db_ch0 (
  .clk       ( clk )
, .rst_n     ( rst_n )
, .status    ( db_ch0_status )
, .in_push   ( db_ch0_in_push )
, .in_data   ( db_ch0_in_data )
, .in_push_2   ( db_ch0_in_push_2 )
, .in_data_2   ( db_ch0_in_data_2 )
, .out_pop   ( db_ch0_out_pop )
, .out_data  ( db_ch0_out_data )
, .db_error  ( error_db_ch0 )
);

logic [ 1 : 0 ] db_ch1_status ;
logic db_ch1_in_push ;
logic [ ( DWIDTH_PARITY ) - 1 : 0 ] db_ch1_in_data ;
logic db_ch1_in_push_2 ;
logic [ ( DWIDTH_PARITY ) - 1 : 0 ] db_ch1_in_data_2 ;
logic db_ch1_out_pop ;
logic [ ( DWIDTH_PARITY ) - 1 : 0 ] db_ch1_out_data ;
hqm_AW_iosf_pd_ll_ctrl_core_db #(
 .DWIDTH ( DWIDTH_PARITY )
) i_db_ch1 (
  .clk       ( clk )
, .rst_n     ( rst_n )
, .status    ( db_ch1_status )
, .in_push   ( db_ch1_in_push )
, .in_data   ( db_ch1_in_data )
, .in_push_2   ( db_ch1_in_push_2 )
, .in_data_2   ( db_ch1_in_data_2 )
, .out_pop   ( db_ch1_out_pop )
, .out_data  ( db_ch1_out_data )
, .db_error  ( error_db_ch1 )
);

logic [ 1 : 0 ] db_ch2_status ;
logic db_ch2_in_push ;
logic [ ( DWIDTH_PARITY ) - 1 : 0 ] db_ch2_in_data ;
logic db_ch2_in_push_2 ;
logic [ ( DWIDTH_PARITY ) - 1 : 0 ] db_ch2_in_data_2 ;
logic db_ch2_out_pop ;
logic [ ( DWIDTH_PARITY ) - 1 : 0 ] db_ch2_out_data ;
hqm_AW_iosf_pd_ll_ctrl_core_db #(
 .DWIDTH ( DWIDTH_PARITY )
) i_db_ch2 (
  .clk       ( clk )
, .rst_n     ( rst_n )
, .status    ( db_ch2_status )
, .in_push   ( db_ch2_in_push )
, .in_data   ( db_ch2_in_data )
, .in_push_2   ( db_ch2_in_push_2 )
, .in_data_2   ( db_ch2_in_data_2 )
, .out_pop   ( db_ch2_out_pop )
, .out_data  ( db_ch2_out_data )
, .db_error  ( error_db_ch2 )
);

logic [ 1 : 0 ] db_ch3_status ;
logic db_ch3_in_push ;
logic [ ( DWIDTH_PARITY ) - 1 : 0 ] db_ch3_in_data ;
logic db_ch3_in_push_2 ;
logic [ ( DWIDTH_PARITY ) - 1 : 0 ] db_ch3_in_data_2 ;
logic db_ch3_out_pop ;
logic [ ( DWIDTH_PARITY ) - 1 : 0 ] db_ch3_out_data ;
hqm_AW_iosf_pd_ll_ctrl_core_db #(
 .DWIDTH ( DWIDTH_PARITY )
) i_db_ch3 (
  .clk       ( clk )
, .rst_n     ( rst_n )
, .status    ( db_ch3_status )
, .in_push   ( db_ch3_in_push )
, .in_data   ( db_ch3_in_data )
, .in_push_2   ( db_ch3_in_push_2 )
, .in_data_2   ( db_ch3_in_data_2 )
, .out_pop   ( db_ch3_out_pop )
, .out_data  ( db_ch3_out_data )
, .db_error  ( error_db_ch3 )
);

logic [ ( PARITY ) - 1 : 0 ] mem_rdata_parity ;
hqm_AW_iosf_pd_ll_ctrl_core_par #(
  .DWIDTH ( DWIDTH )
, .PARITY ( PARITY )
) i_parity_mem_rdaya (
  .d ( mem_rdata )
, .odd ( 1'b0 )
, .p ( mem_rdata_parity )
) ;

logic [ ( PARITY ) - 1 : 0 ] push_hcw_parity ;
hqm_AW_iosf_pd_ll_ctrl_core_par #(
  .DWIDTH ( DWIDTH )
, .PARITY ( PARITY )
) i_parity_push_hcw (
  .d ( push_hcw )
, .odd ( 1'b0 )
, .p ( push_hcw_parity )
) ;

//compress 8b of internal HCW parity into single parity output
logic [ ( DWIDTH_PARITY ) - 1 : 0 ] wire_pop_hcw ;
logic wire_pop_hcw_parity ;
hqm_AW_parity_gen # (
 .WIDTH ( PARITY )
) i_par_pop_hcw (
  .d ( wire_pop_hcw [ ( DWIDTH_PARITY ) - 1 : ( DWIDTH ) ] )
, .odd ( 1'b0 )
, .p ( wire_pop_hcw_parity )
) ;
assign pop_hcw        = wire_pop_hcw [ ( DWIDTH ) - 1 : 0 ] ;
assign pop_hcw_parity = wire_pop_hcw_parity ;

//control signals & registers
logic push_collide ;
logic core_pop_v_f ;
logic [ ( CHANNELSB2 ) - 1 : 0 ] core_pop_chid_f ;
logic [ ( DEPTHB2P1 ) - 1 : 0 ] cnt_nxt , cnt_f ;
logic [ ( 4 * ( DEPTHB2P1 ) ) - 1 : 0 ] core_cnt_nxt , core_cnt_f ;
logic [ ( DEPTHB2P1 ) - 1 : 0 ] push_core_cnt ;
logic push_core_cnt_gt0 ;
logic [ ( DEPTHB2P1 ) - 1 : 0 ] pop_core_cnt ;
logic pop_core_cnt_gt0 ;
logic [ ( 4 * ( DEPTHB2P1 ) ) - 1 : 0 ] ch_cnt_nxt , ch_cnt_f ;
logic [ ( DEPTHB2P1 ) - 1 : 0 ] push_ch_cnt ;
logic push_ch_cnt_eq2 ;
logic push_ch_cnt_gt2 ;
logic push_to_core ;
logic [ ( DEPTHB2P1 ) - 1 : 0 ] pop_ch_cnt ;
logic pop_from_core ;
always_ff @ ( posedge clk or negedge rst_n ) begin : L01
  if ( rst_n == 1'd0 ) begin
    core_pop_v_f <= '0 ;
    core_pop_chid_f <= '0 ;
    core_cnt_f <= '0 ;
    ch_cnt_f <= '0 ;
    cnt_f <= '0 ;
  end else begin
    core_pop_v_f <= core_pop_v ;
    core_pop_chid_f <= core_pop_chid ;
    core_cnt_f <= core_cnt_nxt ;
    ch_cnt_f <= ch_cnt_nxt ;
    cnt_f <= cnt_nxt ;
  end
end

// drive top level ports
logic error ;
assign error = error_db_ch0 | error_db_ch1 | error_db_ch2 | error_db_ch3 | error_memcol | error_uf | error_illpop | error_of | error_illpush | error_flcol | error_ptrparity | error_dbcol ; 
assign empty = { ~ ( | db_ch3_status ) , ~ ( | db_ch2_status ) , ~ ( | db_ch1_status ) , ~ ( | db_ch0_status ) } ;
assign afull = ( cnt_f >= cfg_high_wm ) ;
assign status = { 12'd0 , core_empty , core_status , db_ch3_status , db_ch2_status , db_ch1_status , db_ch0_status } ;

always_comb begin
  wire_pop_hcw = '0 ;

  //LL CORE control
  core_pop_v = '0 ;
  core_pop_chid = pop_chid ;
  core_push_v = '0 ;
  core_push_chid = push_chid ;
  core_push_hcw = push_hcw ;

  //DB initialize
  db_ch0_in_push = '0 ;
  db_ch0_in_data = '0 ;
  db_ch0_in_push_2 = '0 ;
  db_ch0_in_data_2 = '0 ;
  db_ch0_out_pop = '0 ;

  db_ch1_in_push = '0 ;
  db_ch1_in_data = '0 ;
  db_ch1_in_push_2 = '0 ;
  db_ch1_in_data_2 = '0 ;
  db_ch1_out_pop = '0 ;

  db_ch2_in_push = '0 ;
  db_ch2_in_data = '0 ;
  db_ch2_in_push_2 = '0 ;
  db_ch2_in_data_2 = '0 ;
  db_ch2_out_pop = '0 ;

  db_ch3_in_push = '0 ;
  db_ch3_in_data = '0 ;
  db_ch3_in_push_2 = '0 ;
  db_ch3_in_data_2 = '0 ;
  db_ch3_out_pop = '0 ;

  //COUNTERS - per channel count : needed for CORE LL dequeue since the command is flopped cannot use LL empty state or cause underflow.
  //         - overall count :  Need cnt_f in order to BP push interface, cannot use CORE LL since it is delayed or cause overflow
  cnt_nxt = cnt_f ;
  ch_cnt_nxt = ch_cnt_f ;
  core_cnt_nxt = core_cnt_f ;
  if ( push_v ) begin
    cnt_nxt = cnt_nxt + {{(DEPTHB2P1-1){1'b0}},1'b1} ;
    ch_cnt_nxt [ ( push_chid * DEPTHB2P1 ) +: DEPTHB2P1 ] = ch_cnt_nxt [ ( push_chid * DEPTHB2P1 ) +: DEPTHB2P1 ] + {{(DEPTHB2P1-1){1'b0}},1'b1} ;  
  end
  if ( pop_v ) begin
    cnt_nxt = cnt_nxt - {{(DEPTHB2P1-1){1'b0}},1'b1} ;
    ch_cnt_nxt [ ( pop_chid * DEPTHB2P1 ) +: DEPTHB2P1 ] = ch_cnt_nxt [ ( pop_chid * DEPTHB2P1 ) +: DEPTHB2P1 ] - {{(DEPTHB2P1-1){1'b0}},1'b1} ;  
  end




  // create signal to control where to push  & pop and when to access CORE LL
  push_core_cnt     = core_cnt_f [ ( push_chid * DEPTHB2P1 ) +: DEPTHB2P1 ] ;  
  push_core_cnt_gt0 = ( push_core_cnt > {{(DEPTHB2P1-2){1'b0}},2'd0} ) ;
  push_ch_cnt       = ch_cnt_f [ ( push_chid * DEPTHB2P1 ) +: DEPTHB2P1 ] ;  
  push_ch_cnt_eq2   = ( push_ch_cnt == {{(DEPTHB2P1-2){1'b0}},2'd2} ) ;
  push_ch_cnt_gt2   = ( push_ch_cnt > {{(DEPTHB2P1-2){1'b0}},2'd2} ) ;
  push_to_core      = ( ( push_ch_cnt_eq2 & ~ ( pop_v & ( push_chid == pop_chid ) ) )
                      | ( push_ch_cnt_gt2 )
                      | ( push_core_cnt_gt0 )
                      )  ;
  push_collide      = ( core_pop_v_f & push_v & ( core_pop_chid_f == push_chid ) ) ;

  pop_core_cnt      = core_cnt_f [ ( pop_chid * DEPTHB2P1 ) +: DEPTHB2P1 ] ;  
  pop_core_cnt_gt0  = ( pop_core_cnt > {{(DEPTHB2P1-2){1'b0}},2'd0} ) ;
  pop_ch_cnt        = ch_cnt_f [ ( pop_chid * DEPTHB2P1 ) +: DEPTHB2P1 ] ;  
  pop_from_core     = ( pop_core_cnt_gt0 
                      ) ;

  //PROCESS PUSH & POP commands into DB & issue CORE commands as needed
  // * push into output buffer until it is populated
  if ( push_v & ( push_chid == 2'd0 ) & ( ~ push_to_core ) & ( ~ push_collide ) ) begin db_ch0_in_push = 1'b1 ; db_ch0_in_data = {push_hcw_parity, push_hcw} ; end
  if ( push_v & ( push_chid == 2'd1 ) & ( ~ push_to_core ) & ( ~ push_collide ) ) begin db_ch1_in_push = 1'b1 ; db_ch1_in_data = {push_hcw_parity, push_hcw} ; end
  if ( push_v & ( push_chid == 2'd2 ) & ( ~ push_to_core ) & ( ~ push_collide ) ) begin db_ch2_in_push = 1'b1 ; db_ch2_in_data = {push_hcw_parity, push_hcw} ; end
  if ( push_v & ( push_chid == 2'd3 ) & ( ~ push_to_core ) & ( ~ push_collide ) ) begin db_ch3_in_push = 1'b1 ; db_ch3_in_data = {push_hcw_parity, push_hcw} ; end

  if ( push_v & ( push_chid == 2'd0 ) & ( ~ push_to_core ) & (   push_collide ) ) begin db_ch0_in_push_2 = 1'b1 ; db_ch0_in_data_2 = {push_hcw_parity, push_hcw} ; end
  if ( push_v & ( push_chid == 2'd1 ) & ( ~ push_to_core ) & (   push_collide ) ) begin db_ch1_in_push_2 = 1'b1 ; db_ch1_in_data_2 = {push_hcw_parity, push_hcw} ; end
  if ( push_v & ( push_chid == 2'd2 ) & ( ~ push_to_core ) & (   push_collide ) ) begin db_ch2_in_push_2 = 1'b1 ; db_ch2_in_data_2 = {push_hcw_parity, push_hcw} ; end
  if ( push_v & ( push_chid == 2'd3 ) & ( ~ push_to_core ) & (   push_collide ) ) begin db_ch3_in_push_2 = 1'b1 ; db_ch3_in_data_2 = {push_hcw_parity, push_hcw} ; end

  // * push to LL core when output buffer is full & maintain FIFO order
  if ( push_v & ( push_chid == 2'd0 ) & ( push_to_core )   ) begin core_push_v = 1'b1 ; end
  if ( push_v & ( push_chid == 2'd1 ) & ( push_to_core )   ) begin core_push_v = 1'b1 ; end
  if ( push_v & ( push_chid == 2'd2 ) & ( push_to_core )   ) begin core_push_v = 1'b1 ; end
  if ( push_v & ( push_chid == 2'd3 ) & ( push_to_core )   ) begin core_push_v = 1'b1 ; end



  // * pop from output buffer and pop from LL core to fill when it is not empty
  if ( pop_v  & ( pop_chid  == 2'd0 )                      ) begin wire_pop_hcw = db_ch0_out_data ; db_ch0_out_pop = 1'b1 ; core_pop_v = pop_from_core ; end
  if ( pop_v  & ( pop_chid  == 2'd1 )                      ) begin wire_pop_hcw = db_ch1_out_data ; db_ch1_out_pop = 1'b1 ; core_pop_v = pop_from_core ; end
  if ( pop_v  & ( pop_chid  == 2'd2 )                      ) begin wire_pop_hcw = db_ch2_out_data ; db_ch2_out_pop = 1'b1 ; core_pop_v = pop_from_core ; end
  if ( pop_v  & ( pop_chid  == 2'd3 )                      ) begin wire_pop_hcw = db_ch3_out_data ; db_ch3_out_pop = 1'b1 ; core_pop_v = pop_from_core ; end

  // * when LL core pop is available from RAM push it into output buffer
  if ( core_pop_v_f & ( core_pop_chid_f == 2'd0 )          ) begin db_ch0_in_push = 1'b1 ; db_ch0_in_data = {mem_rdata_parity, mem_rdata} ; end
  if ( core_pop_v_f & ( core_pop_chid_f == 2'd1 )          ) begin db_ch1_in_push = 1'b1 ; db_ch1_in_data = {mem_rdata_parity, mem_rdata} ; end
  if ( core_pop_v_f & ( core_pop_chid_f == 2'd2 )          ) begin db_ch2_in_push = 1'b1 ; db_ch2_in_data = {mem_rdata_parity, mem_rdata} ; end
  if ( core_pop_v_f & ( core_pop_chid_f == 2'd3 )          ) begin db_ch3_in_push = 1'b1 ; db_ch3_in_data = {mem_rdata_parity, mem_rdata} ; end


 //core per channel count
  if ( core_push_v & ( core_push_chid == 2'd0 )   ) begin core_cnt_nxt [ ( 0 * DEPTHB2P1 ) +: DEPTHB2P1 ] = core_cnt_nxt [ ( 0 * DEPTHB2P1 ) +: DEPTHB2P1 ] + {{(DEPTHB2P1-1){1'b0}},1'b1} ; end
  if ( core_push_v & ( core_push_chid == 2'd1 )   ) begin core_cnt_nxt [ ( 1 * DEPTHB2P1 ) +: DEPTHB2P1 ] = core_cnt_nxt [ ( 1 * DEPTHB2P1 ) +: DEPTHB2P1 ] + {{(DEPTHB2P1-1){1'b0}},1'b1} ; end
  if ( core_push_v & ( core_push_chid == 2'd2 )   ) begin core_cnt_nxt [ ( 2 * DEPTHB2P1 ) +: DEPTHB2P1 ] = core_cnt_nxt [ ( 2 * DEPTHB2P1 ) +: DEPTHB2P1 ] + {{(DEPTHB2P1-1){1'b0}},1'b1} ; end
  if ( core_push_v & ( core_push_chid == 2'd3 )   ) begin core_cnt_nxt [ ( 3 * DEPTHB2P1 ) +: DEPTHB2P1 ] = core_cnt_nxt [ ( 3 * DEPTHB2P1 ) +: DEPTHB2P1 ] + {{(DEPTHB2P1-1){1'b0}},1'b1} ; end

  if ( core_pop_v & ( core_pop_chid == 2'd0 )     ) begin core_cnt_nxt [ ( 0 * DEPTHB2P1 ) +: DEPTHB2P1 ] = core_cnt_nxt [ ( 0 * DEPTHB2P1 ) +: DEPTHB2P1 ] - {{(DEPTHB2P1-1){1'b0}},1'b1} ; end
  if ( core_pop_v & ( core_pop_chid == 2'd1 )     ) begin core_cnt_nxt [ ( 1 * DEPTHB2P1 ) +: DEPTHB2P1 ] = core_cnt_nxt [ ( 1 * DEPTHB2P1 ) +: DEPTHB2P1 ] - {{(DEPTHB2P1-1){1'b0}},1'b1} ; end
  if ( core_pop_v & ( core_pop_chid == 2'd2 )     ) begin core_cnt_nxt [ ( 2 * DEPTHB2P1 ) +: DEPTHB2P1 ] = core_cnt_nxt [ ( 2 * DEPTHB2P1 ) +: DEPTHB2P1 ] - {{(DEPTHB2P1-1){1'b0}},1'b1} ; end
  if ( core_pop_v & ( core_pop_chid == 2'd3 )     ) begin core_cnt_nxt [ ( 3 * DEPTHB2P1 ) +: DEPTHB2P1 ] = core_cnt_nxt [ ( 3 * DEPTHB2P1 ) +: DEPTHB2P1 ] - {{(DEPTHB2P1-1){1'b0}},1'b1} ; end


  // error
  error_dbcol = '0 ;
end


//--------------------------------------------------------------------------------------------
// Assertions
`ifndef INTEL_SVA_OFF
  check_error: assert property (@(posedge clk) disable iff (rst_n !== 1'b1)
  !( error )) else begin
   $display ("\nERROR: %t: %m: hqm_AW_lifo_control_core.sv error detected ) !!!\n",$time);
   if (!$test$plusargs("AW_CONTINUE_ON_ERROR")) $stop;
  end
`endif

//--------------------------------------------------------------------------------------------
// Coverage
`ifdef HQM_COVER_ON
 covergroup hqm_AW_iosf_pd_ll_ctrl_CG @(posedge clk);
    COVER_0000: coverpoint  ( push_v & ( push_chid == 2'd0 ) ) {}
    COVER_0001: coverpoint  ( push_v & ( push_chid == 2'd1 ) ) {}
    COVER_0002: coverpoint  ( push_v & ( push_chid == 2'd2 ) ) {}
    COVER_0003: coverpoint  ( push_v & ( push_chid == 2'd3 ) ) {}
    COVER_0004: coverpoint  ( pop_v & ( pop_chid == 2'd0 ) ) {}
    COVER_0005: coverpoint  ( pop_v & ( pop_chid == 2'd1 ) ) {}
    COVER_0006: coverpoint  ( pop_v & ( pop_chid == 2'd2 ) ) {}
    COVER_0007: coverpoint  ( pop_v & ( pop_chid == 2'd3 ) ) {}
    COVER_0008: coverpoint  ( push_v & pop_v ) {}
    COVER_0009: coverpoint  ( core_pop_v_f & push_v & ~ push_to_core ) {}
    COVER_0010: coverpoint  ( push_v & pop_v & ( push_chid == pop_chid ) ) {}
    COVER_0011: coverpoint  ( push_v & pop_v & ( push_chid == pop_chid ) & ( push_ch_cnt == 3'd1 ) ) {}
    COVER_0012: coverpoint  ( push_v & pop_v & ( push_chid == pop_chid ) & ( push_ch_cnt == 3'd2 ) ) {}
    COVER_0013: coverpoint  ( push_v & pop_v & ( push_chid == pop_chid ) & ( push_ch_cnt == 3'd3 ) ) {}
    COVER_0014: coverpoint  ( push_v & pop_v & ( push_chid == pop_chid ) & ( push_ch_cnt == 3'd4 ) ) {}
    COVER_0015: coverpoint  ( push_v & pop_v & ( push_chid == pop_chid ) & ( push_ch_cnt == 3'd5 ) ) {}
    COVER_0016: coverpoint  ( push_v & pop_v & ( push_chid == pop_chid ) & ( push_ch_cnt == 3'd6 ) ) {}
    COVER_0017: coverpoint  ( push_v & pop_v & ( push_chid == pop_chid ) & ( push_ch_cnt == 3'd7 ) ) {}
    COVER_0018: coverpoint  ( push_v & pop_v & ( push_chid == pop_chid ) & ( push_core_cnt == 3'd0 ) ) {}
    COVER_0019: coverpoint  ( push_v & pop_v & ( push_chid == pop_chid ) & ( push_core_cnt == 3'd1 ) ) {}
    COVER_0020: coverpoint  ( push_v & pop_v & ( push_chid == pop_chid ) & ( push_core_cnt == 3'd2 ) ) {}
    COVER_0021: coverpoint  ( push_v & pop_v & ( push_chid == pop_chid ) & ( push_core_cnt == 3'd3 ) ) {}
    COVER_0022: coverpoint  ( push_v & pop_v & ( push_chid == pop_chid ) & ( push_core_cnt == 3'd4 ) ) {}
    COVER_0023: coverpoint  ( push_v & pop_v & ( push_chid == pop_chid ) & ( push_core_cnt == 3'd5 ) ) {}
    COVER_0024: coverpoint  ( push_v & pop_v & ( push_chid == pop_chid ) & ( push_core_cnt == 3'd6 ) ) {}
    COVER_0025: coverpoint  ( push_v & pop_v & ( push_chid == pop_chid ) & ( push_core_cnt == 3'd7 ) ) {}
    COVER_0026: coverpoint  ( push_collide ) {}
 endgroup
hqm_AW_iosf_pd_ll_ctrl_CG hqm_AW_iosf_pd_ll_ctrl_CG_inst = new();
`endif



endmodule
