//-----------------------------------------------------------------------------------------------------
//
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
// hqm_qed_pipe
//
//
// Interface requirement
//
//
//-----------------------------------------------------------------------------------------------------

module hqm_qed_pipe_rw
import hqm_AW_pkg::* , hqm_pkg::* , hqm_core_pkg::* ;
# (
    parameter FIFO_QED_CHP_SCH_DEPTH = 8
  , parameter FIFO_DQED_CHP_SCH_DEPTH = 8
  , parameter FIFO_QED_CHP_SCH_WIDTH = 177
  , parameter FIFO_DQED_CHP_SCH_WIDTH = 174
  //..................................................
  , parameter FIFO_QED_CHP_SCH_DEPTHB2 = ( AW_logb2 ( FIFO_QED_CHP_SCH_DEPTH + 1 ) )
  , parameter FIFO_QED_CHP_SCH_DEPTHB2P1 = FIFO_QED_CHP_SCH_DEPTHB2 + 1
  , parameter FIFO_DQED_CHP_SCH_DEPTHB2 = ( AW_logb2 ( FIFO_DQED_CHP_SCH_DEPTH + 1 ) )
  , parameter FIFO_DQED_CHP_SCH_DEPTHB2P1 = FIFO_DQED_CHP_SCH_DEPTHB2 + 1
  , parameter PTR_WIDTH = 14
  , parameter QED_DEPTHB2 = 11
  , parameter QED_WIDTH = 139
  , parameter HCW_WIDTH =123

) (
    input logic                                             hqm_gated_clk
  , input logic                                             hqm_gated_rst_b
  , input logic                                             rst_prep

//CFG interface
  , input  logic cfg_req_idlepipe
  , input  logic [ ( FIFO_QED_CHP_SCH_DEPTHB2P1 ) - 1 : 0 ] cfg_fifo_qed_chp_sch_crd_hwm

  , output logic error
  , output logic pipe_idle
  , output logic idle
  , output logic [ ( 18 ) - 1 : 0 ] debug

  , output logic counter_inc_1rdy_1sel
  , output logic counter_inc_2rdy_1sel
  , output logic counter_inc_2rdy_2sel
  , output logic counter_inc_3rdy_1sel
  , output logic counter_inc_3rdy_2sel

//ram access interface
  , output logic func_qed_chp_sch_data_re
  , output logic [ ( FIFO_QED_CHP_SCH_DEPTHB2 ) - 1 : 0 ] func_qed_chp_sch_data_raddr
  , output logic [ ( FIFO_QED_CHP_SCH_DEPTHB2 ) - 1 : 0 ] func_qed_chp_sch_data_waddr
  , output logic func_qed_chp_sch_data_we
  , output logic [ ( FIFO_QED_CHP_SCH_WIDTH ) - 1 : 0 ] func_qed_chp_sch_data_wdata
  , input  logic [ ( FIFO_QED_CHP_SCH_WIDTH ) - 1 : 0 ] func_qed_chp_sch_data_rdata

  , output logic func_qed_0_re
  , output logic [ ( QED_DEPTHB2 ) - 1 : 0 ] func_qed_0_addr
  , output logic func_qed_0_we
  , output logic [ ( QED_WIDTH ) - 1 : 0 ] func_qed_0_wdata
  , input  logic [ ( QED_WIDTH ) - 1 : 0 ] func_qed_0_rdata

  , output logic func_qed_1_re
  , output logic [ ( QED_DEPTHB2 ) - 1 : 0 ] func_qed_1_addr
  , output logic func_qed_1_we
  , output logic [ ( QED_WIDTH ) - 1 : 0 ] func_qed_1_wdata
  , input  logic [ ( QED_WIDTH ) - 1 : 0 ] func_qed_1_rdata

  , output logic func_qed_2_re
  , output logic [ ( QED_DEPTHB2 ) - 1 : 0 ] func_qed_2_addr
  , output logic func_qed_2_we
  , output logic [ ( QED_WIDTH ) - 1 : 0 ] func_qed_2_wdata
  , input  logic [ ( QED_WIDTH ) - 1 : 0 ] func_qed_2_rdata

  , output logic func_qed_3_re
  , output logic [ ( QED_DEPTHB2 ) - 1 : 0 ] func_qed_3_addr
  , output logic func_qed_3_we
  , output logic [ ( QED_WIDTH ) - 1 : 0 ] func_qed_3_wdata
  , input  logic [ ( QED_WIDTH ) - 1 : 0 ] func_qed_3_rdata

  , output logic func_qed_4_re
  , output logic [ ( QED_DEPTHB2 ) - 1 : 0 ] func_qed_4_addr
  , output logic func_qed_4_we
  , output logic [ ( QED_WIDTH ) - 1 : 0 ] func_qed_4_wdata
  , input  logic [ ( QED_WIDTH ) - 1 : 0 ] func_qed_4_rdata

  , output logic func_qed_5_re
  , output logic [ ( QED_DEPTHB2 ) - 1 : 0 ] func_qed_5_addr
  , output logic func_qed_5_we
  , output logic [ ( QED_WIDTH ) - 1 : 0 ] func_qed_5_wdata
  , input  logic [ ( QED_WIDTH ) - 1 : 0 ] func_qed_5_rdata

  , output logic func_qed_6_re
  , output logic [ ( QED_DEPTHB2 ) - 1 : 0 ] func_qed_6_addr
  , output logic func_qed_6_we
  , output logic [ ( QED_WIDTH ) - 1 : 0 ] func_qed_6_wdata
  , input  logic [ ( QED_WIDTH ) - 1 : 0 ] func_qed_6_rdata

  , output logic func_qed_7_re
  , output logic [ ( QED_DEPTHB2 ) - 1 : 0 ] func_qed_7_addr
  , output logic func_qed_7_we
  , output logic [ ( QED_WIDTH ) - 1 : 0 ] func_qed_7_wdata
  , input  logic [ ( QED_WIDTH ) - 1 : 0 ] func_qed_7_rdata

// input interface
  , output logic rx_sync_rop_qed_dqed_enq_ready
  , input  logic rx_sync_rop_qed_dqed_enq_valid
  , input  rop_qed_dqed_enq_t rx_sync_rop_qed_dqed_enq_data

  , output logic rx_sync_nalb_qed_ready
  , input  logic rx_sync_nalb_qed_valid
  , input  nalb_qed_t rx_sync_nalb_qed_data

  , output logic rx_sync_dp_dqed_ready
  , input  logic rx_sync_dp_dqed_valid
  , input  dp_dqed_t rx_sync_dp_dqed_data

// output interface
  , output logic                        qed_chp_sch_v
  , input  logic                        qed_chp_sch_ready
  , output qed_chp_sch_t                qed_chp_sch_data

  , output logic                        qed_aqed_enq_v
  , input  logic                        qed_aqed_enq_ready
  , output qed_aqed_enq_t               qed_aqed_enq_data


, output  logic                  qed_lsp_deq_v
, output  qed_lsp_deq_t          qed_lsp_deq_data



) ;


//--------------------------------------------------
logic tx_sync_qed_chp_sch_idle ;
logic tx_sync_qed_aqed_enq_idle ;
logic [ ( FIFO_QED_CHP_SCH_DEPTHB2P1 ) - 1 : 0 ] fifo_qed_chp_sch_crd_size ;
qed_chp_sch_t fifo_qed_chp_sch_fifo_push_data ;
qed_chp_sch_t fifo_qed_chp_sch_fifo_pop_data ;
aw_fifo_status_t fifo_qed_chp_sch_fifo_status ;
logic fifo_qed_chp_sch_fifo_empty ;
logic fifo_qed_chp_sch_fifo_full_nc ;
logic fifo_qed_chp_sch_fifo_afull_nc ;
logic fifo_qed_chp_sch_fifo_pop ;
logic fifo_qed_chp_sch_fifo_push ;
logic fifo_qed_chp_sch_crd_alloc ;
logic fifo_qed_chp_sch_crd_dealloc ;
logic fifo_qed_chp_sch_crd_empty_nc ;
logic fifo_qed_chp_sch_crd_full_nc ;
logic fifo_qed_chp_sch_crd_error ;
logic fifo_qed_chp_sch_crd_afull ;
logic tx_sync_qed_aqed_enq_ready ;
logic tx_sync_qed_aqed_enq_valid ;
qed_aqed_enq_t tx_sync_qed_aqed_enq_data ;
logic tx_sync_qed_chp_sch_ready ;
logic tx_sync_qed_chp_sch_valid ;
qed_chp_sch_t tx_sync_qed_chp_sch_data ;
logic wire_qed_chp_sch_v ;
logic wire_qed_chp_sch_ready ;
qed_chp_sch_t wire_qed_chp_sch_data ;
localparam P_ARB_SCH_QED = 0 ;
localparam P_ARB_SCH_DQED = 1 ;
typedef enum logic [(1)-1:0] {
  ARB_SCH_QED='h0,
  ARB_SCH_DQED='h1
} enum_sch_reqs_t;
typedef struct packed {
  enum_sch_reqs_t reqs;
} sch_reqs_t;
logic [ ( 2 ) - 1 : 0 ] arb_sch_reqs ;
logic arb_sch_update ;
logic arb_sch_winner_v ;
sch_reqs_t arb_sch_winner ;
localparam P_ARB_JOB_ENQ = 0 ;
localparam P_ARB_JOB_SCH = 1 ;
typedef enum logic [(1)-1:0] {
  ARB_JOB_ENQ='h0,
  ARB_JOB_SCH='h1
} enum_job_reqs_t;
typedef struct packed {
  enum_job_reqs_t reqs;
} job_reqs_t;
logic [ ( 2 ) - 1 : 0 ] arb_job_reqs ;
logic arb_job_update ;
logic arb_job_winner_v ;
job_reqs_t arb_job_winner ;
logic collide_enq_qsch ;
logic collide_enq_dsch ;
logic take_enq0 ;
logic take_enq1 ;
logic take_enq2 ;
logic take_enq ;
logic take_qsch0 ;
logic take_qsch1 ;
logic take_qsch2 ;
logic take_qsch ;
logic take_dsch0 ;
logic take_dsch1 ;
logic take_dsch2 ;
logic take_dsch ;
logic [ ( 7 ) - 1 : 0 ] tx_sync_qed_chp_sch_status_pnc ;
logic [ ( 7 ) - 1 : 0 ] tx_sync_qed_aqed_enq_status_pnc ;

//--------------------------------------------------
typedef struct packed {
  logic [ ( PTR_WIDTH ) - 1 : 0 ] p0_enq_msg_flid ;
  logic [ ( QED_WIDTH ) - 1 : 0 ] p0_enq_data ;
  nalb_qed_t                      p0_sch_msg ;
  enum_sch_reqs_t                 p0_sch_class ;
  nalb_qed_t                      p1_sch_msg ;
  enum_sch_reqs_t                 p1_sch_class ;
  nalb_qed_t                      p2_sch_msg ;
  enum_sch_reqs_t                 p2_sch_class ;
  logic [ ( QED_WIDTH ) - 1 : 0 ] p2_sch_data ;
} state_struct_t ;
logic p0_enq_v_f , p0_enq_v_nxt ;
logic p0_sch_v_f , p0_sch_v_nxt ;
logic p1_sch_v_f , p1_sch_v_nxt ;
logic p2_sch_v_f , p2_sch_v_nxt ;
state_struct_t state_f , state_nxt ;
always_ff @ ( posedge hqm_gated_clk or negedge hqm_gated_rst_b ) begin
  if ( ~ hqm_gated_rst_b ) begin
    p0_enq_v_f <= '0 ;
    p0_sch_v_f <= '0 ;
    p1_sch_v_f <= '0 ;
    p2_sch_v_f <= '0 ;
  end else begin
    p0_enq_v_f <= p0_enq_v_nxt ;
    p0_sch_v_f <= p0_sch_v_nxt ;
    p1_sch_v_f <= p1_sch_v_nxt ;
    p2_sch_v_f <= p2_sch_v_nxt ;
  end
end
always_ff @ ( posedge hqm_gated_clk ) begin
    state_f <= state_nxt ;
end

//--------------------------------------------------
hqm_AW_fifo_control # (
    .DEPTH                              ( FIFO_QED_CHP_SCH_DEPTH )
  , .DWIDTH                             ( $bits ( fifo_qed_chp_sch_fifo_push_data ) )
) i_fifo_qed_chp_sch_fifo (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_b )
  , .cfg_high_wm                        ( cfg_fifo_qed_chp_sch_crd_hwm )
  , .fifo_status                        ( fifo_qed_chp_sch_fifo_status )
  , .fifo_full                          ( fifo_qed_chp_sch_fifo_full_nc )
  , .fifo_afull                         ( fifo_qed_chp_sch_fifo_afull_nc )
  , .fifo_empty                         ( fifo_qed_chp_sch_fifo_empty )
  , .push                               ( fifo_qed_chp_sch_fifo_push )
  , .push_data                          ( fifo_qed_chp_sch_fifo_push_data )
  , .pop                                ( fifo_qed_chp_sch_fifo_pop )
  , .pop_data                           ( fifo_qed_chp_sch_fifo_pop_data )
  , .mem_we                             ( func_qed_chp_sch_data_we )
  , .mem_waddr                          ( func_qed_chp_sch_data_waddr )
  , .mem_wdata                          ( func_qed_chp_sch_data_wdata )
  , .mem_re                             ( func_qed_chp_sch_data_re )
  , .mem_raddr                          ( func_qed_chp_sch_data_raddr )
  , .mem_rdata                          ( func_qed_chp_sch_data_rdata )
) ;

hqm_AW_control_credits #(
    .DEPTH                              ( FIFO_QED_CHP_SCH_DEPTH )
,   .EARLY_AFULL ( 1 )
) i_fifo_qed_chp_sch_crd (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_b )
  , .alloc                              ( fifo_qed_chp_sch_crd_alloc )
  , .dealloc                            ( fifo_qed_chp_sch_crd_dealloc )
  , .empty                              ( fifo_qed_chp_sch_crd_empty_nc )
  , .full                               ( fifo_qed_chp_sch_crd_full_nc )
  , .size                               ( fifo_qed_chp_sch_crd_size )
  , .error                              ( fifo_qed_chp_sch_crd_error )
  , .hwm                                ( cfg_fifo_qed_chp_sch_crd_hwm )
  , .afull                              ( fifo_qed_chp_sch_crd_afull )
) ;


hqm_AW_tx_sync # (
    .WIDTH                              ( $bits ( tx_sync_qed_chp_sch_data ) )
) i_tx_sync_qed_chp_sch (
    .hqm_gated_clk                      ( hqm_gated_clk )
  , .hqm_gated_rst_n                    ( hqm_gated_rst_b )
  , .status                             ( tx_sync_qed_chp_sch_status_pnc )
  , .idle                               ( tx_sync_qed_chp_sch_idle )
  , .rst_prep                           ( rst_prep )
  , .in_valid                           ( tx_sync_qed_chp_sch_valid )
  , .in_ready                           ( tx_sync_qed_chp_sch_ready )
  , .in_data                            ( tx_sync_qed_chp_sch_data )
  , .out_valid                          ( wire_qed_chp_sch_v )
  , .out_ready                          ( wire_qed_chp_sch_ready )
  , .out_data                           ( wire_qed_chp_sch_data )
) ;

hqm_AW_tx_sync # (
    .WIDTH                              ( $bits ( tx_sync_qed_aqed_enq_data ) )
) i_tx_sync_qed_aqed_enq (
    .hqm_gated_clk                      ( hqm_gated_clk )
  , .hqm_gated_rst_n                    ( hqm_gated_rst_b )
  , .status                             ( tx_sync_qed_aqed_enq_status_pnc )
  , .idle                               ( tx_sync_qed_aqed_enq_idle )
  , .rst_prep                           ( rst_prep )
  , .in_valid                           ( tx_sync_qed_aqed_enq_valid )
  , .in_ready                           ( tx_sync_qed_aqed_enq_ready )
  , .in_data                            ( tx_sync_qed_aqed_enq_data )
  , .out_valid                          ( qed_aqed_enq_v )
  , .out_ready                          ( qed_aqed_enq_ready )
  , .out_data                           ( qed_aqed_enq_data )
) ;

hqm_AW_rr_arb # (
    .NUM_REQS ( 2 )
) i_arb_sch (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_b )
  , .reqs                               ( arb_sch_reqs )
  , .update                             ( arb_sch_update )
  , .winner_v                           ( arb_sch_winner_v )
  , .winner                             ( arb_sch_winner )
) ;

hqm_AW_rr_arb # (
    .NUM_REQS ( 2 )
) i_arb_job (
    .clk                                ( hqm_gated_clk )
  , .rst_n                              ( hqm_gated_rst_b )
  , .reqs                               ( arb_job_reqs )
  , .update                             ( arb_job_update )
  , .winner_v                           ( arb_job_winner_v )
  , .winner                             ( arb_job_winner )
) ;

assign arb_sch_update = ( take_qsch0 | take_qsch1
                        | take_dsch0 | take_dsch1
                        ) ;
assign arb_job_update = ( take_enq0
                        | take_qsch0
                        | take_dsch0
                        ) ;

always_comb begin

  ////////////////////////////////////////////////////////////////////////////////////////////////////

  //..................................................
  p0_enq_v_nxt                   = '0 ;
  p0_sch_v_nxt                   = '0 ;
  state_nxt                      = state_f ;

  rx_sync_rop_qed_dqed_enq_ready = '0 ;
  rx_sync_nalb_qed_ready         = '0 ;
  rx_sync_dp_dqed_ready          = '0 ;
  fifo_qed_chp_sch_crd_alloc     = '0 ;

  // load RR arbiters
  arb_sch_reqs [ P_ARB_SCH_QED ]         = ~cfg_req_idlepipe & rx_sync_nalb_qed_valid & ~ fifo_qed_chp_sch_crd_afull ;
  arb_sch_reqs [ P_ARB_SCH_DQED ]        = ~cfg_req_idlepipe & rx_sync_dp_dqed_valid & ~ fifo_qed_chp_sch_crd_afull ;

  arb_job_reqs [ P_ARB_JOB_ENQ ]         = rx_sync_rop_qed_dqed_enq_valid ;
  arb_job_reqs [ P_ARB_JOB_SCH ]         = arb_sch_winner_v ;

  collide_enq_qsch                       = ( arb_job_reqs [ P_ARB_JOB_ENQ ]
                                           & arb_sch_reqs [ P_ARB_SCH_QED ]
                                           & ( rx_sync_rop_qed_dqed_enq_data.flid [ 13 : 11 ] == rx_sync_nalb_qed_data.flid [ 13 : 11 ] )
                                           ) ;
  collide_enq_dsch                       = ( arb_job_reqs [ P_ARB_JOB_ENQ ]
                                           & arb_sch_reqs [ P_ARB_SCH_DQED ]
                                           & ( rx_sync_rop_qed_dqed_enq_data.flid [ 13 : 11 ] == rx_sync_dp_dqed_data.flid [ 13 : 11 ] )
                                           ) ;

  take_enq0 = ( arb_job_winner_v & ( arb_job_winner == ARB_JOB_ENQ ) ) ;
  take_enq1 = ( arb_job_winner_v & ( arb_job_winner == ARB_JOB_SCH ) & ( arb_sch_winner == ARB_SCH_QED ) & arb_job_reqs [ ARB_JOB_ENQ ] & ~ collide_enq_qsch ) ;
  take_enq2 = ( arb_job_winner_v & ( arb_job_winner == ARB_JOB_SCH ) & ( arb_sch_winner == ARB_SCH_DQED ) & arb_job_reqs [ ARB_JOB_ENQ ] & ~ collide_enq_dsch ) ;
  take_enq  = take_enq0 | take_enq1 | take_enq2 ;

  take_qsch0 = ( arb_job_winner_v & ( arb_job_winner == ARB_JOB_SCH ) & ( arb_sch_winner == ARB_SCH_QED ) ) ;
  take_qsch1 = ( arb_job_winner_v & ( arb_job_winner == ARB_JOB_ENQ ) & arb_sch_winner_v & ( arb_sch_winner == ARB_SCH_QED ) & ~ collide_enq_qsch ) ;
  take_qsch2 = ( arb_job_winner_v & ( arb_job_winner == ARB_JOB_ENQ ) & arb_sch_winner_v & ( arb_sch_winner == ARB_SCH_DQED ) & collide_enq_dsch & arb_sch_reqs [ ARB_SCH_QED ] & ~ collide_enq_qsch ) ;
  take_qsch  = take_qsch0 | take_qsch1 | take_qsch2 ;

  take_dsch0 = ( arb_job_winner_v & ( arb_job_winner == ARB_JOB_SCH ) & ( arb_sch_winner == ARB_SCH_DQED ) ) ;
  take_dsch1 = ( arb_job_winner_v & ( arb_job_winner == ARB_JOB_ENQ ) & arb_sch_winner_v & ( arb_sch_winner == ARB_SCH_DQED ) & ~ collide_enq_dsch ) ;
  take_dsch2 = ( arb_job_winner_v & ( arb_job_winner == ARB_JOB_ENQ ) & arb_sch_winner_v & ( arb_sch_winner == ARB_SCH_QED ) & collide_enq_qsch & arb_sch_reqs [ ARB_SCH_DQED ] & ~ collide_enq_dsch ) ;
  take_dsch  = take_dsch0 | take_dsch1 | take_dsch2 ;

  state_nxt.p0_enq_msg_flid = '0 ;
  state_nxt.p0_enq_data = '0 ;
  state_nxt.p0_sch_msg = '0 ;
  state_nxt.p0_sch_class = ARB_SCH_DQED ;
  if ( take_enq ) begin
        rx_sync_rop_qed_dqed_enq_ready  = 1'b1 ;
        p0_enq_v_nxt                    = ~ ( ( rx_sync_rop_qed_dqed_enq_data.cmd == ROP_QED_DQED_ENQ_DIR_NOOP ) | ( rx_sync_rop_qed_dqed_enq_data.cmd == ROP_QED_DQED_ENQ_LB_NOOP ) ) ;
        state_nxt.p0_enq_msg_flid       = rx_sync_rop_qed_dqed_enq_data.flid [ 13 : 0 ] ;
        state_nxt.p0_enq_data           = { rx_sync_rop_qed_dqed_enq_data.cq_hcw_ecc , rx_sync_rop_qed_dqed_enq_data.cq_hcw } ;
  end

  if ( take_qsch ) begin
        rx_sync_nalb_qed_ready          = 1'b1 ;
        p0_sch_v_nxt                    = ~ ( ( rx_sync_nalb_qed_data.cmd == NALB_QED_ILL0 ) ) ;
        fifo_qed_chp_sch_crd_alloc      = p0_sch_v_nxt ;
        state_nxt.p0_sch_msg            = rx_sync_nalb_qed_data ;
        state_nxt.p0_sch_class          = ARB_SCH_QED ;
  end

  if ( take_dsch ) begin
        rx_sync_dp_dqed_ready           = 1'b1 ;
        p0_sch_v_nxt                    = ~ ( ( rx_sync_dp_dqed_data.cmd == DP_DQED_ILL0 ) | ( rx_sync_dp_dqed_data.cmd == DP_DQED_ILL3 ) ) ;
        fifo_qed_chp_sch_crd_alloc     = p0_sch_v_nxt ;
        state_nxt.p0_sch_msg            = rx_sync_dp_dqed_data ;
        state_nxt.p0_sch_class          = ARB_SCH_DQED ;
  end

  //..................................................
  p1_sch_v_nxt                          = p0_sch_v_f ;
  state_nxt.p1_sch_msg     = state_f.p0_sch_msg ;
  state_nxt.p1_sch_class   = state_f.p0_sch_class ;

  func_qed_0_we            = ( p0_enq_v_f & ( state_f.p0_enq_msg_flid [ 13 : 11 ] == 3'd0 ) ) ;
  func_qed_0_re            = ( p0_sch_v_f & ( state_f.p0_sch_msg.flid [ 13 : 11 ] == 3'd0 ) ) ;
  func_qed_0_addr          = ( func_qed_0_we ? state_f.p0_enq_msg_flid [ 10 : 0 ] : state_f.p0_sch_msg.flid [ 10 : 0 ] ) ;
  func_qed_0_wdata         = ( state_f.p0_enq_data ) ;

  func_qed_1_we            = ( p0_enq_v_f & ( state_f.p0_enq_msg_flid [ 13 : 11 ] == 3'd1 ) ) ;
  func_qed_1_re            = ( p0_sch_v_f & ( state_f.p0_sch_msg.flid [ 13 : 11 ] == 3'd1 ) ) ;
  func_qed_1_addr          = ( func_qed_1_we ? state_f.p0_enq_msg_flid [ 10 : 0 ] : state_f.p0_sch_msg.flid [ 10 : 0 ] ) ;
  func_qed_1_wdata         = ( state_f.p0_enq_data ) ;

  func_qed_2_we            = ( p0_enq_v_f & ( state_f.p0_enq_msg_flid [ 13 : 11 ] == 3'd2 ) ) ;
  func_qed_2_re            = ( p0_sch_v_f & ( state_f.p0_sch_msg.flid [ 13 : 11 ] == 3'd2 ) ) ;
  func_qed_2_addr          = ( func_qed_2_we ? state_f.p0_enq_msg_flid [ 10 : 0 ] : state_f.p0_sch_msg.flid [ 10 : 0 ] ) ;
  func_qed_2_wdata         = ( state_f.p0_enq_data ) ;

  func_qed_3_we            = ( p0_enq_v_f & ( state_f.p0_enq_msg_flid [ 13 : 11 ] == 3'd3 ) ) ;
  func_qed_3_re            = ( p0_sch_v_f & ( state_f.p0_sch_msg.flid [ 13 : 11 ] == 3'd3 ) ) ;
  func_qed_3_addr          = ( func_qed_3_we ? state_f.p0_enq_msg_flid [ 10 : 0 ] : state_f.p0_sch_msg.flid [ 10 : 0 ] ) ;
  func_qed_3_wdata         = ( state_f.p0_enq_data ) ;

  func_qed_4_we            = ( p0_enq_v_f & ( state_f.p0_enq_msg_flid [ 13 : 11 ] == 3'd4 ) ) ;
  func_qed_4_re            = ( p0_sch_v_f & ( state_f.p0_sch_msg.flid [ 13 : 11 ] == 3'd4 ) ) ;
  func_qed_4_addr          = ( func_qed_4_we ? state_f.p0_enq_msg_flid [ 10 : 0 ] : state_f.p0_sch_msg.flid [ 10 : 0 ] ) ;
  func_qed_4_wdata         = ( state_f.p0_enq_data ) ;

  func_qed_5_we            = ( p0_enq_v_f & ( state_f.p0_enq_msg_flid [ 13 : 11 ] == 3'd5 ) ) ;
  func_qed_5_re            = ( p0_sch_v_f & ( state_f.p0_sch_msg.flid [ 13 : 11 ] == 3'd5 ) ) ;
  func_qed_5_addr          = ( func_qed_5_we ? state_f.p0_enq_msg_flid [ 10 : 0 ] : state_f.p0_sch_msg.flid [ 10 : 0 ] ) ;
  func_qed_5_wdata         = ( state_f.p0_enq_data ) ;

  func_qed_6_we            = ( p0_enq_v_f & ( state_f.p0_enq_msg_flid [ 13 : 11 ] == 3'd6 ) ) ;
  func_qed_6_re            = ( p0_sch_v_f & ( state_f.p0_sch_msg.flid [ 13 : 11 ] == 3'd6 ) ) ;
  func_qed_6_addr          = ( func_qed_6_we ? state_f.p0_enq_msg_flid [ 10 : 0 ] : state_f.p0_sch_msg.flid [ 10 : 0 ] ) ;
  func_qed_6_wdata         = ( state_f.p0_enq_data ) ;

  func_qed_7_we            = ( p0_enq_v_f & ( state_f.p0_enq_msg_flid [ 13 : 11 ] == 3'd7 ) ) ;
  func_qed_7_re            = ( p0_sch_v_f & ( state_f.p0_sch_msg.flid [ 13 : 11 ] == 3'd7 ) ) ;
  func_qed_7_addr          = ( func_qed_7_we ? state_f.p0_enq_msg_flid [ 10 : 0 ] : state_f.p0_sch_msg.flid [ 10 : 0 ] ) ;
  func_qed_7_wdata         = ( state_f.p0_enq_data ) ;

  //..................................................
  //
  p2_sch_v_nxt             = p1_sch_v_f ;
  state_nxt.p2_sch_msg     = state_f.p1_sch_msg ;
  state_nxt.p2_sch_class   = state_f.p1_sch_class ;
  state_nxt.p2_sch_data    = '0 ;

  if ( p1_sch_v_f & ( state_f.p1_sch_msg.flid [ 13 : 11 ] == 3'd0 ) ) begin state_nxt.p2_sch_data = func_qed_0_rdata ; end
  if ( p1_sch_v_f & ( state_f.p1_sch_msg.flid [ 13 : 11 ] == 3'd1 ) ) begin state_nxt.p2_sch_data = func_qed_1_rdata ; end
  if ( p1_sch_v_f & ( state_f.p1_sch_msg.flid [ 13 : 11 ] == 3'd2 ) ) begin state_nxt.p2_sch_data = func_qed_2_rdata ; end
  if ( p1_sch_v_f & ( state_f.p1_sch_msg.flid [ 13 : 11 ] == 3'd3 ) ) begin state_nxt.p2_sch_data = func_qed_3_rdata ; end
  if ( p1_sch_v_f & ( state_f.p1_sch_msg.flid [ 13 : 11 ] == 3'd4 ) ) begin state_nxt.p2_sch_data = func_qed_4_rdata ; end
  if ( p1_sch_v_f & ( state_f.p1_sch_msg.flid [ 13 : 11 ] == 3'd5 ) ) begin state_nxt.p2_sch_data = func_qed_5_rdata ; end
  if ( p1_sch_v_f & ( state_f.p1_sch_msg.flid [ 13 : 11 ] == 3'd6 ) ) begin state_nxt.p2_sch_data = func_qed_6_rdata ; end
  if ( p1_sch_v_f & ( state_f.p1_sch_msg.flid [ 13 : 11 ] == 3'd7 ) ) begin state_nxt.p2_sch_data = func_qed_7_rdata ; end

  //..................................................
  //
  qed_lsp_deq_v                    = '0 ;
  fifo_qed_chp_sch_fifo_push       = '0 ;
  fifo_qed_chp_sch_fifo_push_data  = '0 ;

  if ( p2_sch_v_f & ( state_f.p2_sch_class == ARB_SCH_QED ) ) begin
    fifo_qed_chp_sch_fifo_push                         = 1'b1 ;
    if ( state_f.p2_sch_msg.cmd == NALB_QED_READ ) begin
      fifo_qed_chp_sch_fifo_push_data.cmd              = QED_CHP_SCH_REPLAY ;
    end
    if ( state_f.p2_sch_msg.cmd == NALB_QED_POP ) begin
      qed_lsp_deq_v                                    = 1'b1 ;
      fifo_qed_chp_sch_fifo_push_data.cmd              = QED_CHP_SCH_SCHED ;
    end
    if ( state_f.p2_sch_msg.cmd == NALB_QED_TRANSFER ) begin
      fifo_qed_chp_sch_fifo_push_data.cmd              = QED_CHP_SCH_TRANSFER ;
    end
    fifo_qed_chp_sch_fifo_push_data.cq                 = state_f.p2_sch_msg.cq ;
    fifo_qed_chp_sch_fifo_push_data.qidix              = state_f.p2_sch_msg.qidix ;
    fifo_qed_chp_sch_fifo_push_data.parity             = state_f.p2_sch_msg.parity ;
    fifo_qed_chp_sch_fifo_push_data.flid               = state_f.p2_sch_msg.flid ;
    fifo_qed_chp_sch_fifo_push_data.flid_parity        = state_f.p2_sch_msg.flid_parity ;
    fifo_qed_chp_sch_fifo_push_data.cq_hcw             = state_f.p2_sch_data [ ( HCW_WIDTH ) - 1 : 0 ] ;
    fifo_qed_chp_sch_fifo_push_data.cq_hcw_ecc         = state_f.p2_sch_data [ ( QED_WIDTH ) - 1 : HCW_WIDTH ] ;
    fifo_qed_chp_sch_fifo_push_data.hqm_core_flags     = state_f.p2_sch_msg.hqm_core_flags ;
  end

  if ( p2_sch_v_f & ( state_f.p2_sch_class == ARB_SCH_DQED ) ) begin
    fifo_qed_chp_sch_fifo_push                        = 1'b1 ;
    if ( state_f.p2_sch_msg.cmd == NALB_QED_READ ) begin
      fifo_qed_chp_sch_fifo_push_data.cmd             = QED_CHP_SCH_REPLAY ;
    end
    if ( state_f.p2_sch_msg.cmd == NALB_QED_POP ) begin
      fifo_qed_chp_sch_fifo_push_data.cmd             = QED_CHP_SCH_SCHED ;
    end
    fifo_qed_chp_sch_fifo_push_data.cq                = state_f.p2_sch_msg.cq ;
    fifo_qed_chp_sch_fifo_push_data.parity            = state_f.p2_sch_msg.parity ;
    fifo_qed_chp_sch_fifo_push_data.flid              = state_f.p2_sch_msg.flid ;
    fifo_qed_chp_sch_fifo_push_data.flid_parity       = state_f.p2_sch_msg.flid_parity ;
    fifo_qed_chp_sch_fifo_push_data.cq_hcw            = state_f.p2_sch_data [ ( HCW_WIDTH ) - 1 : 0 ] ;
    fifo_qed_chp_sch_fifo_push_data.cq_hcw_ecc        = state_f.p2_sch_data [ ( QED_WIDTH ) - 1 : HCW_WIDTH ] ;
    fifo_qed_chp_sch_fifo_push_data.hqm_core_flags    = state_f.p2_sch_msg.hqm_core_flags ;
  end

  //send dequeue to LSP
  qed_lsp_deq_data.cq     = fifo_qed_chp_sch_fifo_push_data.cq [ 5: 0 ] ;
  qed_lsp_deq_data.qe_wt  = fifo_qed_chp_sch_fifo_push_data.cq_hcw.qe_wt ;
  qed_lsp_deq_data.parity =  ^ { 1'b1 , qed_lsp_deq_data.cq , qed_lsp_deq_data.qe_wt } ;

  //..................................................
  // DRAIN output to TX FIFOS
  fifo_qed_chp_sch_fifo_pop = '0 ;
  fifo_qed_chp_sch_crd_dealloc = '0 ;

  tx_sync_qed_chp_sch_valid = '0 ;
  tx_sync_qed_chp_sch_data = '0 ;
  wire_qed_chp_sch_ready = '0 ;
  qed_chp_sch_v = '0 ;
  qed_chp_sch_data = '0 ;

  tx_sync_qed_aqed_enq_valid = '0 ;
  tx_sync_qed_aqed_enq_data = '0 ;

  //output drain FIFO drives TX modules to CHP (qed )
  if ( ( ~ fifo_qed_chp_sch_fifo_empty ) & tx_sync_qed_chp_sch_ready ) begin
    tx_sync_qed_chp_sch_valid                     = 1'b1 ;
    tx_sync_qed_chp_sch_data                      = fifo_qed_chp_sch_fifo_pop_data ;

    fifo_qed_chp_sch_fifo_pop                     = 1'b1 ;
    fifo_qed_chp_sch_crd_dealloc                  = 1'b1 ;
  end

  //drive to CHP before sending QED_CHP_SCH_TRANSFER with correct order
  if ( wire_qed_chp_sch_v ) begin
        qed_chp_sch_data                          = wire_qed_chp_sch_data ;

    if ( wire_qed_chp_sch_data.cmd == QED_CHP_SCH_TRANSFER ) begin
      if ( tx_sync_qed_aqed_enq_ready) begin
        qed_chp_sch_v                             = 1'b1 ;
        wire_qed_chp_sch_ready                    = qed_chp_sch_ready ;

        tx_sync_qed_aqed_enq_valid                = qed_chp_sch_ready ;
        tx_sync_qed_aqed_enq_data.cq_hcw          = wire_qed_chp_sch_data.cq_hcw ;
        tx_sync_qed_aqed_enq_data.cq_hcw_ecc      = wire_qed_chp_sch_data.cq_hcw_ecc ;
      end
    end
    else begin
        qed_chp_sch_v                             = 1'b1 ;
        wire_qed_chp_sch_ready                    = qed_chp_sch_ready ;
    end
  end

end

assign debug = {
                 4'b0
               , fifo_qed_chp_sch_crd_afull
               //
               , tx_sync_qed_chp_sch_status_pnc [ 1 : 0 ]
               , tx_sync_qed_aqed_enq_status_pnc [ 1 : 0 ]
               , 2'd0
               , fifo_qed_chp_sch_fifo_empty
               , 1'b0
               , 1'b0
               , fifo_qed_chp_sch_crd_size
               } ;
assign pipe_idle  = ( ( ~ ( p0_enq_v_f | p0_sch_v_f | p1_sch_v_f | p2_sch_v_f ) )
                    ) ;
assign idle       = ( pipe_idle
                    & tx_sync_qed_chp_sch_idle
                    & tx_sync_qed_aqed_enq_idle
                    & fifo_qed_chp_sch_fifo_empty
                    ) ;
assign error = ( fifo_qed_chp_sch_fifo_status.overflow
               | fifo_qed_chp_sch_fifo_status.underflow
               | fifo_qed_chp_sch_crd_error
               | ( take_qsch & take_dsch )
               | ( func_qed_0_we & func_qed_0_re )
               | ( func_qed_1_we & func_qed_1_re )
               | ( func_qed_2_we & func_qed_2_re )
               | ( func_qed_3_we & func_qed_3_re )
               | ( func_qed_4_we & func_qed_4_re )
               | ( func_qed_5_we & func_qed_5_re )
               | ( func_qed_6_we & func_qed_6_re )
               | ( func_qed_7_we & func_qed_7_re )
               ) ;

logic counter_inc_1rdy ;
logic counter_inc_2rdy ;
logic counter_inc_3rdy ;
logic counter_inc_1sel ;
logic counter_inc_2sel ;
assign counter_inc_1rdy = ( ( ~ rx_sync_rop_qed_dqed_enq_valid & ~ rx_sync_nalb_qed_valid & rx_sync_dp_dqed_valid ) | ( ~ rx_sync_rop_qed_dqed_enq_valid & rx_sync_nalb_qed_valid & ~ rx_sync_dp_dqed_valid ) | ( rx_sync_rop_qed_dqed_enq_valid & ~ rx_sync_nalb_qed_valid & ~ rx_sync_dp_dqed_valid ) ) ;
assign counter_inc_2rdy = ( ( ~ rx_sync_rop_qed_dqed_enq_valid & rx_sync_nalb_qed_valid & rx_sync_dp_dqed_valid ) | ( rx_sync_rop_qed_dqed_enq_valid & rx_sync_nalb_qed_valid & ~ rx_sync_dp_dqed_valid ) | ( rx_sync_rop_qed_dqed_enq_valid & ~ rx_sync_nalb_qed_valid & rx_sync_dp_dqed_valid ) ) ;
assign counter_inc_3rdy = ( ( rx_sync_nalb_qed_valid & rx_sync_dp_dqed_valid & rx_sync_rop_qed_dqed_enq_valid ) ) ;
assign counter_inc_1sel = ( ( ~ take_qsch & ~ take_dsch & take_enq )  | ( ~ take_qsch & take_dsch & ~ take_enq ) | ( take_qsch & ~ take_dsch & ~ take_enq ) ) ;
assign counter_inc_2sel = ( ( ~ take_qsch & take_dsch & take_enq )  | ( take_qsch & ~ take_dsch & take_enq ) ) ;
assign counter_inc_1rdy_1sel = counter_inc_1rdy & counter_inc_1sel ;
assign counter_inc_2rdy_1sel = counter_inc_2rdy & counter_inc_1sel ;
assign counter_inc_2rdy_2sel = counter_inc_2rdy & counter_inc_2sel ;
assign counter_inc_3rdy_1sel = counter_inc_3rdy & counter_inc_1sel ;
assign counter_inc_3rdy_2sel = counter_inc_3rdy & counter_inc_2sel ;

endmodule // hqm_qed_pipe_core
