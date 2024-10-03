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
//
//
//-----------------------------------------------------------------------------------------------------
module hqm_credit_hist_pipe_egress
  import hqm_AW_pkg::* , hqm_pkg::* , hqm_core_pkg::* ;
# (
  parameter LDB_NUM_CQ                            = 64
, parameter LDB_DEPTH_CQ                          = 1024
, parameter DIR_NUM_CQ                            = 64
, parameter DIR_DEPTH_CQ                          = 4096

, parameter ID_WIDTH                              = 6
, parameter ADDR_WIDTH                            = 14
, parameter DATA_WIDTH                            = 128
, parameter AWUSER_WIDTH                          = 8 + 13 + 8
, parameter WUSER_WIDTH                           = 31
, parameter AW_DATA_WIDTH                         = ID_WIDTH + ADDR_WIDTH + AWUSER_WIDTH
, parameter W_DATA_WIDTH                          = ID_WIDTH + DATA_WIDTH + WUSER_WIDTH
) (
  input  logic                                    hqm_gated_clk
, input  logic                                    hqm_gated_rst_b
, input  logic                                    hqm_flr_prep

, input  logic [ ( 16 ) - 1 : 0 ]                 master_chp_timestamp

, input  logic                                    cfg_req_idlepipe
, input  logic                                    cfg_pad_first_write_ldb
, input  logic                                    cfg_pad_first_write_dir
, input  logic                                    cfg_pad_write_ldb
, input  logic                                    cfg_pad_write_dir
, input  logic                                    cfg_64bytes_qe_dir_cq_mode
, input  logic                                    cfg_64bytes_qe_ldb_cq_mode

//cfg
, input  logic                                    egress_wbo_error_inject_3
, input  logic                                    egress_wbo_error_inject_2
, input  logic                                    egress_wbo_error_inject_1
, input  logic                                    egress_wbo_error_inject_0
, input  logic                                    egress_error_inject_h0
, input  logic                                    egress_error_inject_l0
, input  logic                                    egress_error_inject_h1
, input  logic                                    egress_error_inject_l1

, input  logic [ ( 4 ) - 1 : 0 ]                  cfg_egress_pipecredits
, input  logic [ ( 3 ) - 1 : 0 ]                  cfg_egress_lsp_token_pipecredits

//errors
, output logic                                    egress_err_parity_ldb_cq_token_depth_select
, output logic                                    egress_err_parity_dir_cq_token_depth_select
, output logic                                    egress_err_parity_ldb_cq_intr_thresh
, output logic                                    egress_err_parity_dir_cq_intr_thresh
, output logic                                    egress_err_residue_ldb_cq_wptr
, output logic                                    egress_err_residue_dir_cq_wptr
, output logic                                    egress_err_residue_ldb_cq_depth
, output logic                                    egress_err_residue_dir_cq_depth
, output logic [ ( 8 ) - 1 : 0 ]                  egress_err_ldb_rid
, output logic [ ( 8 ) - 1 : 0 ]                  egress_err_dir_rid
, output logic                                    egress_err_hcw_ecc_sb
, output logic                                    egress_err_hcw_ecc_mb
, output logic                                    egress_err_ldb_cq_depth_underflow
, output logic                                    egress_err_ldb_cq_depth_overflow
, output logic                                    egress_err_dir_cq_depth_underflow
, output logic                                    egress_err_dir_cq_depth_overflow

//counter

//smon
, output logic [ ( 3 * 1 ) - 1 : 0 ]              egress_hqm_chp_target_cfg_chp_smon_smon_v
, output logic [ ( 3 * 32 ) - 1 : 0 ]             egress_hqm_chp_target_cfg_chp_smon_smon_comp
, output logic [ ( 3 * 32 ) - 1 : 0 ]             egress_hqm_chp_target_cfg_chp_smon_smon_val

//status
, output logic [ ( 8 ) - 1 : 0 ]                  egress_credit_status
, output logic [ ( 7 ) - 1 : 0 ]                  egress_lsp_token_credit_status
, output logic [ ( 7 ) - 1 : 0 ]                  egress_tx_sync_status
, output logic                                    egress_pipe_idle
, output logic                                    egress_unit_idle

//idle, clock control

// top level RFW/SRW , FIFO, RMW, MFIFO
, output logic                                    rw_ldb_cq_wptr_p0_v_nxt
, output aw_rmwpipe_cmd_t                         rw_ldb_cq_wptr_p0_rmw_nxt
, output logic [ ( 6 ) - 1 : 0 ]                  rw_ldb_cq_wptr_p0_addr_nxt
, input  logic [ ( 13 ) - 1 : 0 ]                 rw_ldb_cq_wptr_p2_data_f
, output logic                                    rw_ldb_cq_wptr_p3_bypsel_nxt
, output logic [ ( 13 ) - 1 : 0 ]                 rw_ldb_cq_wptr_p3_bypdata_nxt
, output logic                                    rw_ldb_cq_token_depth_select_p0_v_nxt
, output aw_rwpipe_cmd_t                          rw_ldb_cq_token_depth_select_p0_rw_nxt
, output logic [ ( 6 ) - 1 : 0 ]                  rw_ldb_cq_token_depth_select_p0_addr_nxt
, input  logic [ ( 6 ) - 1 : 0 ]                  rw_ldb_cq_token_depth_select_p2_data_f
, output logic                                    rw_ldb_cq_intr_thresh_p0_v_nxt
, output aw_rwpipe_cmd_t                          rw_ldb_cq_intr_thresh_p0_rw_nxt
, output logic [ ( 6 ) - 1 : 0 ]                  rw_ldb_cq_intr_thresh_p0_addr_nxt
, input  logic [ ( 13 ) - 1 : 0 ]                 rw_ldb_cq_intr_thresh_p2_data_f
, output logic                                    rw_ldb_cq_depth_p0_v_nxt
, output aw_rmwpipe_cmd_t                         rw_ldb_cq_depth_p0_rmw_nxt
, output logic [ ( 6 ) - 1 : 0 ]                  rw_ldb_cq_depth_p0_addr_nxt
, input  logic [ ( 13 ) - 1 : 0 ]                 rw_ldb_cq_depth_p2_data_f
, output logic                                    rw_ldb_cq_depth_p3_bypsel_nxt
, output logic [ ( 13 ) - 1 : 0 ]                 rw_ldb_cq_depth_p3_bypdata_nxt
, output logic                                    rw_dir_cq_wptr_p0_v_nxt
, output aw_rmwpipe_cmd_t                         rw_dir_cq_wptr_p0_rmw_nxt
, output logic [ ( HQM_NUM_DIR_CQB2 ) - 1 : 0 ]   rw_dir_cq_wptr_p0_addr_nxt
, input  logic [ ( 13 ) - 1 : 0 ]                 rw_dir_cq_wptr_p2_data_f
, output logic                                    rw_dir_cq_wptr_p3_bypsel_nxt
, output logic [ ( 13 ) - 1 : 0 ]                 rw_dir_cq_wptr_p3_bypdata_nxt
, output logic                                    rw_dir_cq_token_depth_select_p0_v_nxt
, output aw_rwpipe_cmd_t                          rw_dir_cq_token_depth_select_p0_rw_nxt
, output logic [ ( HQM_NUM_DIR_CQB2 ) - 1 : 0 ]   rw_dir_cq_token_depth_select_p0_addr_nxt
, input  logic [ ( 6 ) - 1 : 0 ]                  rw_dir_cq_token_depth_select_p2_data_f
, output logic                                    rw_dir_cq_intr_thresh_p0_v_nxt
, output aw_rwpipe_cmd_t                          rw_dir_cq_intr_thresh_p0_rw_nxt
, output logic [ ( HQM_NUM_DIR_CQB2 ) - 1 : 0 ]   rw_dir_cq_intr_thresh_p0_addr_nxt
, input  logic [ ( 15 ) - 1 : 0 ]                 rw_dir_cq_intr_thresh_p2_data_f
, output logic                                    rw_dir_cq_depth_p0_v_nxt
, output aw_rmwpipe_cmd_t                         rw_dir_cq_depth_p0_rmw_nxt
, output logic [ ( HQM_NUM_DIR_CQB2 ) - 1 : 0 ]   rw_dir_cq_depth_p0_addr_nxt
, input  logic [ ( 13 ) - 1 : 0 ]                 rw_dir_cq_depth_p2_data_f
, output logic                                    rw_dir_cq_depth_p3_bypsel_nxt
, output logic [ ( 13 ) - 1 : 0 ]                 rw_dir_cq_depth_p3_bypdata_nxt
, output logic                                    fifo_chp_sys_tx_fifo_mem_push
, output logic                                    fifo_chp_sys_tx_fifo_mem_pop
, input  logic                                    fifo_chp_sys_tx_fifo_mem_pop_data_v
, output fifo_chp_sys_tx_fifo_mem_data_t          fifo_chp_sys_tx_fifo_mem_push_data
, input  fifo_chp_sys_tx_fifo_mem_data_t          fifo_chp_sys_tx_fifo_mem_pop_data

// Functional Interface

//Interface SCH/DEQUEUE PIPE
, input  logic                                    fifo_outbound_hcw_pop_data_v
, output logic                                    fifo_outbound_hcw_pop
, input  outbound_hcw_fifo_t                      fifo_outbound_hcw_pop_data

// Interface ENQUEUE PIPE
, input  logic                                    fifo_chp_lsp_tok_pop_data_v
, output logic                                    fifo_chp_lsp_tok_pop
, input  chp_lsp_token_t                          fifo_chp_lsp_tok_pop_data

// HCW Scheudle out AXI interface
, output hcw_sched_w_req_t                        hcw_sched_w_req
, output logic                                    hcw_sched_w_req_valid
, input  logic                                    hcw_sched_w_req_ready

// Interface to CIAL / WD
, output cq_int_info_t                            sch_ldb_excep
, output cq_int_info_t                            enq_ldb_excep
, output cq_int_info_t                            sch_dir_excep
, output cq_int_info_t                            enq_dir_excep

//
, output logic					  chp_lsp_token_qb_in_valid
, output chp_lsp_token_t			  chp_lsp_token_qb_in_data
, input logic					  egress_lsp_token_credit_dealloc

, output logic                                    hqm_chp_partial_outbound_hcw_fifo_parity_err
 
, output logic                                    egress_wbo_error_inject_3_done_set
, output logic                                    egress_wbo_error_inject_2_done_set
, output logic                                    egress_wbo_error_inject_1_done_set
, output logic                                    egress_wbo_error_inject_0_done_set
, output logic                                    egress_error_inject_h0_done_set
, output logic                                    egress_error_inject_l0_done_set
, output logic                                    egress_error_inject_h1_done_set
, output logic                                    egress_error_inject_l1_done_set

) ;

localparam POP_CQ_ECC_H_DWIDTH = 59 ;
localparam POP_CQ_ECC_L_DWIDTH = 64 ;
localparam POP_CQ_ECC_EWIDTH = 8 ;

localparam RR_ARB_SCH = 0 ;
localparam RR_ARB_ENQ = 1 ;
logic [ ( 2 ) - 1 : 0 ] rr_reqs ;
logic rr_update ;
logic rr_winner_v ;
logic rr_winner ;

typedef struct packed {
  logic                                      pop_cq_v ;
  logic                                      pop_cq_error ;
  logic                                      pop_cq_is_ldb ;
  logic [ ( 7 ) - 1 : 0 ]                    pop_cq_cq ;
  hqm_pkg::cq_hcw_t	                     pop_cq_hcw ;
  logic [ ( 16 ) - 1 : 0 ]                   pop_cq_hcw_ecc ;
  hqm_pkg::hcw_sched_aw_req_awuser_t         awuser;
  logic [ ( 4 ) - 1 : 0 ]                    pop_cq_cmp_id;
  logic                                      pop_cq_qe_wt_parity ;

  logic                                      push_cq_v ;
  logic                                      push_cq_is_ldb ;
  logic [ ( 7 ) - 1 : 0 ]                    push_cq_cq ;
  hqm_pkg::hcw_cmd_dec_t                     push_cq_cmd ;
  logic [ ( 13 ) - 1 : 0 ]                   push_cq_tokens ;
  logic                                      push_cq_parity ;
  logic [ ( 2 ) - 1 : 0 ]                    push_cq_tokens_residue ;

} hqm_chp_egress_pipedata_hcw_t ;

hqm_chp_egress_pipedata_hcw_t p0_pipedata_f , p0_pipedata_nxt , p1_pipedata_f , p1_pipedata_nxt , p2_pipedata_f , p2_pipedata_nxt ;
logic p2_pipedata_push_cq_parity ;
hqm_pkg::outbound_hcw_t p2_reformat_pop_cq_hcw_nxt , p2_reformat_pop_cq_hcw_f , p2_final_pop_cq_hcw ;
logic p0_pipev_f , p0_pipev_nxt , p1_pipev_f , p1_pipev_nxt , p2_pipev_f , p2_pipev_nxt ;
cq_int_info_t sch_ldb_excep_f , sch_ldb_excep_nxt ;
cq_int_info_t sch_dir_excep_f , sch_dir_excep_nxt ;
cq_int_info_t enq_ldb_excep_f , enq_ldb_excep_nxt ;
cq_int_info_t enq_dir_excep_f , enq_dir_excep_nxt ;
logic p1_error_f , p1_error_nxt ;
logic pop_cq_ecc_check_l_din_v ;
logic pop_cq_ecc_check_l_enable ;
logic pop_cq_ecc_check_l_correct ;
logic pop_cq_ecc_check_l_error_sb ;
logic pop_cq_ecc_check_l_error_mb ;
logic [ ( POP_CQ_ECC_L_DWIDTH ) - 1 : 0 ] pop_cq_ecc_check_l_din ;
logic [ ( POP_CQ_ECC_L_DWIDTH ) - 1 : 0 ] pop_cq_ecc_check_l_dout ;
logic [ ( POP_CQ_ECC_EWIDTH ) - 1 : 0 ] pop_cq_ecc_check_l_ecc ;
logic pop_cq_ecc_check_h_din_v ;
logic pop_cq_ecc_check_h_enable ;
logic pop_cq_ecc_check_h_correct ;
logic pop_cq_ecc_check_h_error_sb ;
logic pop_cq_ecc_check_h_error_mb ;
logic [ ( POP_CQ_ECC_H_DWIDTH ) - 1 : 0 ] pop_cq_ecc_check_h_din ;
logic [ ( POP_CQ_ECC_H_DWIDTH ) - 1 : 0 ] pop_cq_ecc_check_h_dout ;
logic [ ( POP_CQ_ECC_EWIDTH ) - 1 : 0 ] pop_cq_ecc_check_h_ecc ;
logic [ ( 64 ) - 1 : 0 ] par_gen_l_d ;
logic [ ( 64 ) - 1 : 0 ] par_gen_h_d ;
logic par_gen_l_p ;
logic par_gen_h_p ;
logic egress_credit_alloc ;
logic egress_credit_dealloc ;
logic egress_credit_empty ;
logic egress_credit_full ;
logic [ ( 4 ) - 1 : 0 ] egress_credit_size ;
logic egress_credit_error ;
logic egress_credit_afull ;
logic egress_credit_afull_and_not_dealloc ;
logic lsp_token_credit_alloc ;
logic lsp_token_credit_empty ;
logic lsp_token_credit_full ;
logic [ ( 3 ) - 1 : 0 ] lsp_token_credit_size ;
logic lsp_token_credit_error ;
logic lsp_token_credit_afull ;
logic take_push_v ;
logic take_pop_v ;
logic take_ldb_v ;
logic [ ( 7 ) - 1 : 0 ] take_ldb_cq ;
logic take_dir_v ;
logic [ ( 7 ) - 1 : 0 ] take_dir_cq ;
logic [ ( 11 ) - 1 : 0 ] rw_ldb_cq_wptr_p2_data_f_p1 ;
logic [ ( 11 ) - 1 : 0 ] rw_ldb_cq_depth_p2_data_f_p1 ;
logic [ ( 11 ) - 1 : 0 ] rw_ldb_cq_depth_p2_data_f_m ;
logic [ ( 11 ) - 1 : 0 ] rw_dir_cq_wptr_p2_data_f_p1 ;
logic [ ( 11 ) - 1 : 0 ] rw_dir_cq_depth_p2_data_f_p1 ;
logic [ ( 11 ) - 1 : 0 ] rw_dir_cq_depth_p2_data_f_m ;
logic [ ( 11 ) - 1 : 0 ] dir_cq_token_depth_select_mask ;
logic [ ( 11 ) - 1 : 0 ] dir_cq_wptr_mask ;
logic [ ( 11 ) - 1 : 0 ] ldb_cq_token_depth_select_mask ;
logic [ ( 11 ) - 1 : 0 ] ldb_cq_wptr_mask ;
logic ldb_cq_depth_full ;
logic dir_cq_depth_full ;
logic ldb_cq_gen ;
logic ldb_cq_wp_wrap ;
logic dir_cq_gen ;
logic dir_cq_wp_wrap ;
logic [ ( 16 ) - 1 : 0 ] timestamp_delta ;
logic [ ( 16 ) - 1 : 0 ] timestamp_addsub0_a ;
logic [ ( 16 ) - 1 : 0 ] timestamp_addsub0_b ;
logic [ ( 16 ) - 1 : 0 ] timestamp_addsub0_sum ;
logic timestamp_addsum0_co ;
logic [ ( 17 ) - 1 : 0 ] timestamp_addsub1_a ;
logic [ ( 17 ) - 1 : 0 ] timestamp_addsub1_b ;
logic [ ( 17 ) - 1 : 0 ] timestamp_addsub1_sum ;
logic timestamp_addsum1_co_nc ;
logic check_ldb ;
logic check_dir ;
logic err_parity_ldb_cq_token_depth_select ;
logic err_parity_dir_cq_token_depth_select ;
logic err_parity_ldb_cq_intr_thresh ;
logic err_parity_dir_cq_intr_thresh ;
logic err_residue_ldb_cq_wptr ;
logic err_residue_dir_cq_wptr ;
logic err_residue_ldb_cq_depth ;
logic err_residue_dir_cq_depth ;
logic [ ( 2 ) - 1 : 0 ] ldb_cq_wptr_res_pre , ldb_cq_wptr_res_p1 ;
logic [ ( 2 ) - 1 : 0 ] dir_cq_wptr_res_pre , dir_cq_wptr_res_p1 ;
//logic [ ( 2 ) - 1 : 0 ] cq_depth_res_tokens ;
logic [ ( 2 ) - 1 : 0 ] ldb_cq_depth_res_p1 ;
logic [ ( 2 ) - 1 : 0 ] ldb_cq_depth_res_m ;
logic [ ( 2 ) - 1 : 0 ] dir_cq_depth_res_p1 ;
logic [ ( 2 ) - 1 : 0 ] dir_cq_depth_res_m ;
logic tx_sync_idle ;
logic tx_core_valid ;
logic tx_core_ready ;
logic fifo_chp_sys_tx_fifo_mem_push_data_cial_parity ;

hcw_sched_w_req_t tx_core_data ;

logic pad_ok ;

assign egress_credit_afull_and_not_dealloc = egress_credit_afull & ~ egress_credit_dealloc ;

always_ff @ ( posedge hqm_gated_clk or negedge hqm_gated_rst_b ) begin
  if ( ! hqm_gated_rst_b ) begin
    p0_pipev_f                       <= '0 ;
    p1_pipev_f                       <= '0 ;
    p2_pipev_f                       <= '0 ;
    sch_ldb_excep_f                  <= '0 ;
    sch_dir_excep_f                  <= '0 ;
    enq_ldb_excep_f                  <= '0 ;
    enq_dir_excep_f                  <= '0 ;
    p1_error_f                       <= '0 ;
  end
  else begin
    p0_pipev_f                       <= p0_pipev_nxt ;
    p1_pipev_f                       <= p1_pipev_nxt ;
    p2_pipev_f                       <= p2_pipev_nxt ;
    sch_ldb_excep_f                  <= sch_ldb_excep_nxt ;
    sch_dir_excep_f                  <= sch_dir_excep_nxt ;
    enq_ldb_excep_f                  <= enq_ldb_excep_nxt ;
    enq_dir_excep_f                  <= enq_dir_excep_nxt ;
    p1_error_f                       <= p1_error_nxt ;
  end
end

always_ff @ ( posedge hqm_gated_clk ) begin
    p0_pipedata_f                    <= p0_pipedata_nxt ;
    p1_pipedata_f                    <= p1_pipedata_nxt ;
    p2_pipedata_f                    <= p2_pipedata_nxt ;
    p2_reformat_pop_cq_hcw_f         <= p2_reformat_pop_cq_hcw_nxt ; // this holds the HCW after translating from hqm_pkg::cq_hcw_t ==>> hqm_pkg::outbound_hcw_t format
end


hqm_AW_tx_nobuf_sync # (
  .WIDTH                              ( $bits ( tx_core_data ) )
) i_hcw_sched_w_req_tx_sync (
  .hqm_gated_clk                      ( hqm_gated_clk )
, .hqm_gated_rst_n                    ( hqm_gated_rst_b )
, .status                             ( egress_tx_sync_status )
, .idle                               ( tx_sync_idle )
, .rst_prep                           ( hqm_flr_prep )
, .in_ready                           ( tx_core_ready )
, .in_valid                           ( tx_core_valid )
, .in_data                            ( tx_core_data )
, .out_ready                          ( hcw_sched_w_req_ready )
, .out_valid                          ( hcw_sched_w_req_valid )
, .out_data                           ( hcw_sched_w_req )
) ;

hqm_AW_rr_arb #(
  .NUM_REQS                           ( 2 )
) i_rr_arb (
  .clk                                ( hqm_gated_clk )
, .rst_n                              ( hqm_gated_rst_b )
, .reqs                               ( rr_reqs )
, .update                             ( rr_update )
, .winner_v                           ( rr_winner_v )
, .winner                             ( rr_winner )
) ;

hqm_AW_control_credits # (
   .DEPTH                             ( 8 )
 , .NUM_A                             ( 1 )
 , .NUM_D                             ( 1 )
) i_hqm_AW_control_credits_egress (
   .clk                               ( hqm_gated_clk )
 , .rst_n                             ( hqm_gated_rst_b )
 , .alloc                             ( egress_credit_alloc )
 , .dealloc                           ( egress_credit_dealloc )
 , .empty                             ( egress_credit_empty )
 , .full                              ( egress_credit_full )
 , .size                              ( egress_credit_size )
 , .error                             ( egress_credit_error )
 , .hwm                               ( cfg_egress_pipecredits )
 , .afull                             ( egress_credit_afull )
) ;

hqm_AW_control_credits # (
   .DEPTH                             ( 4 )
 , .NUM_A                             ( 1 )
 , .NUM_D                             ( 1 )
) i_hqm_AW_control_credits_lsp_token (
   .clk                               ( hqm_gated_clk )
 , .rst_n                             ( hqm_gated_rst_b )
 , .alloc                             ( lsp_token_credit_alloc )
 , .dealloc                           ( egress_lsp_token_credit_dealloc )
 , .empty                             ( lsp_token_credit_empty )
 , .full                              ( lsp_token_credit_full )
 , .size                              ( lsp_token_credit_size )
 , .error                             ( lsp_token_credit_error )
 , .hwm                               ( cfg_egress_lsp_token_pipecredits )
 , .afull                             ( lsp_token_credit_afull )
) ;

hqm_AW_ecc_check # (
   .DATA_WIDTH                        ( POP_CQ_ECC_L_DWIDTH )
 , .ECC_WIDTH                         ( POP_CQ_ECC_EWIDTH )
) i_hqm_AW_pop_cq_ecc_check_l (
   .din_v                             ( pop_cq_ecc_check_l_din_v )
 , .din                               ( pop_cq_ecc_check_l_din )
 , .ecc                               ( pop_cq_ecc_check_l_ecc )
 , .enable                            ( pop_cq_ecc_check_l_enable )
 , .correct                           ( pop_cq_ecc_check_l_correct )
 , .dout                              ( pop_cq_ecc_check_l_dout )
 , .error_sb                          ( pop_cq_ecc_check_l_error_sb )
 , .error_mb                          ( pop_cq_ecc_check_l_error_mb )
) ;

hqm_AW_ecc_check # (
   .DATA_WIDTH                        ( POP_CQ_ECC_H_DWIDTH )
 , .ECC_WIDTH                         ( POP_CQ_ECC_EWIDTH )
) i_hqm_AW_pop_cq_ecc_check_h (
   .din_v                             ( pop_cq_ecc_check_h_din_v )
 , .din                               ( pop_cq_ecc_check_h_din )
 , .ecc                               ( pop_cq_ecc_check_h_ecc )
 , .enable                            ( pop_cq_ecc_check_h_enable )
 , .correct                           ( pop_cq_ecc_check_h_correct )
 , .dout                              ( pop_cq_ecc_check_h_dout )
 , .error_sb                          ( pop_cq_ecc_check_h_error_sb )
 , .error_mb                          ( pop_cq_ecc_check_h_error_mb )
) ;

hqm_AW_parity_gen # (
   .WIDTH                             ( 64 )
) i_hqm_AW_par_gen_l (
   .d                                 ( par_gen_l_d )
 , .odd                               ( 1'b1 )
 , .p                                 ( par_gen_l_p )
) ;

hqm_AW_parity_gen # (
   .WIDTH                             ( 64 )
) i_hqm_AW_par_gen_h (
   .d                                 ( par_gen_h_d )
 , .odd                               ( 1'b1 )
 , .p                                 ( par_gen_h_p )
) ;

hqm_AW_parity_check #(
   .WIDTH                             ( 4 )
) i_parity_check_ldb_cq_token_depth_select (
   .p                                 ( rw_ldb_cq_token_depth_select_p2_data_f [ 4 ] )
 , .d                                 ( rw_ldb_cq_token_depth_select_p2_data_f [ 3 : 0 ] )
 , .e                                 ( check_ldb )
 , .odd                               ( 1'b1 )
 , .err                               ( err_parity_ldb_cq_token_depth_select )
) ;

hqm_AW_parity_check #(
   .WIDTH                             ( 4 )
) i_parity_check_dir_cq_token_depth_select (
   .p                                 ( rw_dir_cq_token_depth_select_p2_data_f [ 4 ] )
 , .d                                 ( rw_dir_cq_token_depth_select_p2_data_f [ 3 : 0 ] )
 , .e                                 ( check_dir )
 , .odd                               ( 1'b1 )
 , .err                               ( err_parity_dir_cq_token_depth_select )
) ;

hqm_AW_parity_check #(
   .WIDTH                             ( 12 )
) i_parity_check_ldb_cq_intr_thresh (
   .p                                 ( rw_ldb_cq_intr_thresh_p2_data_f [ 12 ] )
 , .d                                 ( rw_ldb_cq_intr_thresh_p2_data_f [ 11 : 0 ] )
 , .e                                 ( check_ldb )
 , .odd                               ( 1'b1 )
 , .err                               ( err_parity_ldb_cq_intr_thresh )
) ;

hqm_AW_parity_check #(
   .WIDTH                             ( 14 )
) i_parity_check_dir_cq_intr_thresh (
   .p                                 ( rw_dir_cq_intr_thresh_p2_data_f [ 14 ] )
 , .d                                 ( rw_dir_cq_intr_thresh_p2_data_f [ 13 : 0 ] )
 , .e                                 ( check_dir )
 , .odd                               ( 1'b1 )
 , .err                               ( err_parity_dir_cq_intr_thresh )
) ;

hqm_AW_residue_check #(
   .WIDTH                             ( 11 )
) i_residue_check_ldb_cq_wptr (
   .r                                 ( rw_ldb_cq_wptr_p2_data_f [ 12 : 11 ] )
 , .d                                 ( rw_ldb_cq_wptr_p2_data_f [ 10 : 0 ] )
 , .e                                 ( check_ldb )
 , .err                               ( err_residue_ldb_cq_wptr )
) ;

hqm_AW_residue_check #(
   .WIDTH                             ( 11 )
) i_residue_check_dir_cq_wptr (
   .r                                 ( rw_dir_cq_wptr_p2_data_f [ 12 : 11 ] )
 , .d                                 ( rw_dir_cq_wptr_p2_data_f [ 10 : 0 ] )
 , .e                                 ( check_dir )
 , .err                               ( err_residue_dir_cq_wptr )
) ;

hqm_AW_residue_check #(
   .WIDTH                             ( 11 )
) i_residue_check_ldb_cq_depth (
   .r                                 ( rw_ldb_cq_depth_p2_data_f [ 12 : 11 ] )
 , .d                                 ( rw_ldb_cq_depth_p2_data_f [ 10 : 0 ] )
 , .e                                 ( check_ldb )
 , .err                               ( err_residue_ldb_cq_depth )
) ;

hqm_AW_residue_check #(
   .WIDTH                             ( 11 )
) i_residue_check_dir_cq_depth (
   .r                                 ( rw_dir_cq_depth_p2_data_f [ 12 : 11 ] )
 , .d                                 ( rw_dir_cq_depth_p2_data_f [ 10 : 0 ] )
 , .e                                 ( check_dir )
 , .err                               ( err_residue_dir_cq_depth )
) ;

hqm_AW_residue_add i_residue_inc_ldb_cq_wptr (
   .a                                 ( 2'b01 )
 , .b                                 ( rw_ldb_cq_wptr_p2_data_f [ 12 : 11 ] )
 , .r                                 ( ldb_cq_wptr_res_pre )
) ;
assign ldb_cq_wptr_res_p1 = ldb_cq_wp_wrap ? 2'd0 : ldb_cq_wptr_res_pre ;

hqm_AW_residue_add i_residue_inc_dir_cq_wptr (
   .a                                 ( 2'b01 )
 , .b                                 ( rw_dir_cq_wptr_p2_data_f [ 12 : 11 ] )
 , .r                                 ( dir_cq_wptr_res_pre )
) ;
assign dir_cq_wptr_res_p1 = dir_cq_wp_wrap ? 2'd0 : dir_cq_wptr_res_pre ;

/*
hqm_AW_residue_gen #(
   .WIDTH                             ( 13 )
) i_residue_gen_cq_depth (
   .a                                 ( p2_pipedata_f.push_cq_tokens )
 , .r                                 ( cq_depth_res_tokens )
);
*/

hqm_AW_residue_add i_residue_inc_ldb_cq_depth (
   .a                                 ( 2'b01 )
 , .b                                 ( rw_ldb_cq_depth_p2_data_f [ 12 : 11 ] )
 , .r                                 ( ldb_cq_depth_res_p1 )
);

hqm_AW_residue_sub i_residue_sub_ldb_cq_depth (
// .a                                 ( cq_depth_res_tokens )
   .a                                 ( p2_pipedata_f.push_cq_tokens_residue )
 , .b                                 ( rw_ldb_cq_depth_p2_data_f [ 12 : 11 ] )
 , .r                                 ( ldb_cq_depth_res_m )
);

hqm_AW_residue_add i_residue_inc_dir_cq_depth (
   .a                                 ( 2'b01 )
 , .b                                 ( rw_dir_cq_depth_p2_data_f [ 12 : 11 ] )
 , .r                                 ( dir_cq_depth_res_p1 )
);

hqm_AW_residue_sub i_residue_sub_dir_cq_depth (
// .a                                 ( cq_depth_res_tokens )
   .a                                 ( p2_pipedata_f.push_cq_tokens_residue )
 , .b                                 ( rw_dir_cq_depth_p2_data_f [ 12 : 11 ] )
 , .r                                 ( dir_cq_depth_res_m )
);
assign check_ldb = p2_pipev_f & ( ( p2_pipedata_f.pop_cq_v & p2_pipedata_f.pop_cq_is_ldb ) | ( p2_pipedata_f.push_cq_v & p2_pipedata_f.push_cq_is_ldb ) ) ;
assign check_dir = p2_pipev_f & ( ( p2_pipedata_f.pop_cq_v & ~ p2_pipedata_f.pop_cq_is_ldb ) | ( p2_pipedata_f.push_cq_v & ~ p2_pipedata_f.push_cq_is_ldb ) ) ;

////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////
//generate next timestamp
hqm_AW_addsub #(
   .WIDTH                             ( 16 )
) i_addsub0 (
   .a                                 ( timestamp_addsub0_a )
 , .b                                 ( timestamp_addsub0_b )
 , .ci                                ( 1'b0 )
 , .add_sub                           ( 1'b1 )
 , .sum                               ( timestamp_addsub0_sum )
 , .co                                ( timestamp_addsum0_co )
) ;

hqm_AW_addsub #(
   .WIDTH                             ( 17 )
) i_addsub1 (
   .a                                 ( timestamp_addsub1_a )
 , .b                                 ( timestamp_addsub1_b )
 , .ci                                ( 1'b0 )
 , .add_sub                           ( 1'b1 )
 , .sum                               ( timestamp_addsub1_sum )
 , .co                                ( timestamp_addsum1_co_nc )
) ;
assign timestamp_addsub0_a = master_chp_timestamp ;
assign timestamp_addsub0_b = p1_pipedata_f.pop_cq_hcw.dsi_timestamp ;
assign timestamp_addsub1_a = { 1'b0 , timestamp_addsub0_sum } ;
assign timestamp_addsub1_b = 17'h10000 ;
assign timestamp_delta = timestamp_addsum0_co ? timestamp_addsub1_sum [ 15 : 0 ] : timestamp_addsub0_sum ;
////////////////////////////////////////////////////////////////////////////////////////////////////

assign egress_hqm_chp_target_cfg_chp_smon_smon_v [ ( 0 * 1 ) +: 1 ]      = ( p2_pipev_f & p2_pipedata_f.pop_cq_v ) ;
assign egress_hqm_chp_target_cfg_chp_smon_smon_comp [ ( 0 * 32 ) +: 32 ] = { 31'd0 , p2_pipedata_f.pop_cq_is_ldb } ;
assign egress_hqm_chp_target_cfg_chp_smon_smon_val [ ( 0 * 32 ) +: 32 ]  = 32'd1 ;

assign egress_hqm_chp_target_cfg_chp_smon_smon_v [ ( 1 * 1 ) +: 1 ]      = ( p2_pipev_f & p2_pipedata_f.push_cq_v ) ;
assign egress_hqm_chp_target_cfg_chp_smon_smon_comp [ ( 1 * 32 ) +: 32 ] = { 31'd0 , p2_pipedata_f.push_cq_is_ldb } ;
assign egress_hqm_chp_target_cfg_chp_smon_smon_val [ ( 1 * 32 ) +: 32 ]  = 32'd1 ;

assign egress_hqm_chp_target_cfg_chp_smon_smon_v [ ( 2 * 1 ) +: 1 ]      = ( p2_pipev_f ) ;
assign egress_hqm_chp_target_cfg_chp_smon_smon_comp [ ( 2 * 32 ) +: 32 ] = { 14'd0 , p2_pipedata_f.push_cq_cq , p2_pipedata_f.push_cq_is_ldb , p2_pipedata_f.push_cq_v , p2_pipedata_f.pop_cq_cq , p2_pipedata_f.pop_cq_is_ldb , p2_pipedata_f.pop_cq_v } ;
assign egress_hqm_chp_target_cfg_chp_smon_smon_val [ ( 2 * 32 ) +: 32 ]  = 32'd1 ;

always_comb begin

  sch_ldb_excep = sch_ldb_excep_f ;
  sch_dir_excep = sch_dir_excep_f ;
  enq_ldb_excep = enq_ldb_excep_f ;
  enq_dir_excep = enq_dir_excep_f ;

  fifo_outbound_hcw_pop = 1'b1 ;

  p0_pipev_nxt = '0 ;
  p1_pipev_nxt = p0_pipev_f ;
  p2_pipev_nxt = p1_pipev_f ;
  p0_pipedata_nxt = p0_pipedata_f ;
  p1_pipedata_nxt = p0_pipev_f ? p0_pipedata_f : p1_pipedata_f ;
  p2_pipedata_nxt = p1_pipev_f ? p1_pipedata_f : p2_pipedata_f ;
  p2_reformat_pop_cq_hcw_nxt = p2_reformat_pop_cq_hcw_f ;
  sch_ldb_excep_nxt = sch_ldb_excep_f ;
  sch_dir_excep_nxt = sch_dir_excep_f ;
  enq_ldb_excep_nxt = enq_ldb_excep_f ;
  enq_dir_excep_nxt = enq_dir_excep_f ;
  sch_ldb_excep_nxt.hcw_v = '0 ;
  sch_dir_excep_nxt.hcw_v = '0 ;
  enq_ldb_excep_nxt.hcw_v = '0 ;
  enq_dir_excep_nxt.hcw_v = '0 ;

  tx_core_valid = '0 ;
  tx_core_data = '0 ;

  rw_ldb_cq_wptr_p0_v_nxt = '0 ;
  rw_ldb_cq_wptr_p0_rmw_nxt = HQM_AW_RMWPIPE_NOOP ;
  rw_ldb_cq_wptr_p0_addr_nxt = '0 ;
  rw_ldb_cq_wptr_p3_bypsel_nxt = '0 ;
  rw_ldb_cq_wptr_p3_bypdata_nxt = '0 ;
  rw_ldb_cq_token_depth_select_p0_v_nxt = '0 ;
  rw_ldb_cq_token_depth_select_p0_rw_nxt = HQM_AW_RWPIPE_NOOP ;
  rw_ldb_cq_token_depth_select_p0_addr_nxt = '0 ;
  rw_ldb_cq_intr_thresh_p0_v_nxt = '0 ;
  rw_ldb_cq_intr_thresh_p0_rw_nxt = HQM_AW_RWPIPE_NOOP ;
  rw_ldb_cq_intr_thresh_p0_addr_nxt = '0 ;
  rw_ldb_cq_depth_p0_v_nxt = '0 ;
  rw_ldb_cq_depth_p0_rmw_nxt = HQM_AW_RMWPIPE_NOOP ;
  rw_ldb_cq_depth_p0_addr_nxt = '0 ;
  rw_ldb_cq_depth_p3_bypsel_nxt = '0 ;
  rw_ldb_cq_depth_p3_bypdata_nxt = rw_ldb_cq_depth_p2_data_f ;
  rw_dir_cq_wptr_p0_v_nxt = '0 ;
  rw_dir_cq_wptr_p0_rmw_nxt = HQM_AW_RMWPIPE_NOOP ;
  rw_dir_cq_wptr_p0_addr_nxt = '0 ;
  rw_dir_cq_wptr_p3_bypsel_nxt = '0 ;
  rw_dir_cq_wptr_p3_bypdata_nxt = '0 ;
  rw_dir_cq_token_depth_select_p0_v_nxt = '0 ;
  rw_dir_cq_token_depth_select_p0_rw_nxt = HQM_AW_RWPIPE_NOOP ;
  rw_dir_cq_token_depth_select_p0_addr_nxt = '0 ;
  rw_dir_cq_intr_thresh_p0_v_nxt = '0 ;
  rw_dir_cq_intr_thresh_p0_rw_nxt = HQM_AW_RWPIPE_NOOP ;
  rw_dir_cq_intr_thresh_p0_addr_nxt = '0 ;
  rw_dir_cq_depth_p0_v_nxt = '0 ;
  rw_dir_cq_depth_p0_rmw_nxt = HQM_AW_RMWPIPE_NOOP ;
  rw_dir_cq_depth_p0_addr_nxt = '0 ;
  rw_dir_cq_depth_p3_bypsel_nxt = '0 ;
  rw_dir_cq_depth_p3_bypdata_nxt = rw_dir_cq_depth_p2_data_f ;

  take_push_v = '0 ;
  take_pop_v = '0 ;
  take_ldb_v = '0 ;
  take_ldb_cq = '0 ;
  take_dir_v = '0 ;
  take_dir_cq = '0 ;
  egress_credit_alloc = '0 ;
  egress_credit_dealloc = '0 ;
  lsp_token_credit_alloc = '0 ;
  pop_cq_ecc_check_l_din_v = p0_pipev_f ;
  pop_cq_ecc_check_l_din = p0_pipedata_f.pop_cq_hcw [ 63 : 0 ] ;
  pop_cq_ecc_check_l_ecc = p0_pipedata_f.pop_cq_hcw_ecc [ 7 : 0 ] ;
  pop_cq_ecc_check_l_enable = '0 ;
  pop_cq_ecc_check_l_correct = 1'b1 ;
  pop_cq_ecc_check_h_din_v = p0_pipev_f ;
  pop_cq_ecc_check_h_din = p0_pipedata_f.pop_cq_hcw [ 122 : 64 ] ;
  pop_cq_ecc_check_h_ecc = p0_pipedata_f.pop_cq_hcw_ecc [ 15 : 8 ] ;
  pop_cq_ecc_check_h_enable = '0 ;
  pop_cq_ecc_check_h_correct = 1'b1 ;
  par_gen_l_d = '0 ;
  par_gen_h_d = '0 ;
  rr_update = '0 ;
  //====================================================================================================

  //..................................................
  // input arbitration
  rr_reqs [ RR_ARB_ENQ ]                     = fifo_chp_lsp_tok_pop_data_v
                                               & ~ ( ( fifo_chp_lsp_tok_pop_data.cmd == HQM_CMD_ARM ) ? egress_credit_afull_and_not_dealloc : lsp_token_credit_afull ) 
                                               & ~ cfg_req_idlepipe ;
  rr_reqs [ RR_ARB_SCH ]                     = fifo_outbound_hcw_pop_data_v
                                               & ~ ( cfg_req_idlepipe | egress_credit_afull_and_not_dealloc ) ;

  //  when there is a is_ldb collsion between schedule/pop and enqueue/push use RR arbiter to select
  //  but when no collsion issue both operations simultaneously
  //    * both schedule/pop and enqueue/push must hold on CFG/VASreset pipe idling
  //    * schedule/pop needs output drain FIFO credits to issue, hole this on credit_afull
  if ( rr_reqs [ RR_ARB_ENQ ] & rr_reqs [ RR_ARB_SCH ] ) begin
    if ( ( fifo_outbound_hcw_pop_data.cq_is_ldb == fifo_chp_lsp_tok_pop_data.is_ldb ) |
         ( fifo_chp_lsp_tok_pop_data.cmd == HQM_CMD_ARM ) ) begin
      rr_update                              = rr_winner_v ;
      take_push_v                            = rr_winner_v & ( rr_winner == RR_ARB_ENQ ) ;
      take_pop_v                             = rr_winner_v & ( rr_winner == RR_ARB_SCH ) ;
    end
    else begin
      take_push_v                            = rr_winner_v ; 
      take_pop_v                             = rr_winner_v ;
    end
  end
  else begin
    rr_update                                = rr_winner_v ;
    take_push_v                              = rr_winner_v & ( rr_winner == RR_ARB_ENQ ) ;
    take_pop_v                               = rr_winner_v & ( rr_winner == RR_ARB_SCH ) ;
  end
  fifo_outbound_hcw_pop                      = take_pop_v ;
  fifo_chp_lsp_tok_pop                       = take_push_v ;

  //..................................................
  // P0 Drive pipeline & issue RMW commands
  p0_pipev_nxt                               = take_push_v | take_pop_v ;
  if ( p0_pipev_nxt ) begin  p0_pipedata_nxt = '0 ; end
  if ( take_pop_v ) begin
    egress_credit_alloc                      = 1'b1 ;

    p0_pipedata_nxt.pop_cq_v                 = 1'b1 ;
    p0_pipedata_nxt.pop_cq_error             = fifo_outbound_hcw_pop_data.error ;
    p0_pipedata_nxt.pop_cq_is_ldb            = fifo_outbound_hcw_pop_data.cq_is_ldb ;
    p0_pipedata_nxt.pop_cq_cq                = fifo_outbound_hcw_pop_data.cq[6:0] ;
    p0_pipedata_nxt.pop_cq_cmp_id            = fifo_outbound_hcw_pop_data.cmp_id ;
    p0_pipedata_nxt.pop_cq_hcw               = fifo_outbound_hcw_pop_data.hcw ;
    p0_pipedata_nxt.pop_cq_hcw_ecc           = fifo_outbound_hcw_pop_data.hcw_ecc ;
    p0_pipedata_nxt.awuser.hqm_core_flags    = fifo_outbound_hcw_pop_data.flags ;
    p0_pipedata_nxt.awuser.hqm_core_flags.pad_ok = 1'd0 ;
    p0_pipedata_nxt.awuser.cq                = { 1'b0 , fifo_outbound_hcw_pop_data.cq[6:0] } ;
    p0_pipedata_nxt.awuser.cq_wptr           = '0 ; //load in P2

    if ( fifo_outbound_hcw_pop_data.cq_is_ldb ) begin
      take_ldb_v                             = 1'b1 ;
      take_ldb_cq                            = fifo_outbound_hcw_pop_data.cq[6:0] ;
    end
    else begin
      take_dir_v                             = 1'b1 ;
      take_dir_cq                            = fifo_outbound_hcw_pop_data.cq[6:0] ;
    end
  end
  p0_pipedata_nxt.pop_cq_qe_wt_parity        = '0 ;

  if ( take_push_v ) begin
    p0_pipedata_nxt.push_cq_v                = 1'b1 ;
    p0_pipedata_nxt.push_cq_is_ldb           = fifo_chp_lsp_tok_pop_data.is_ldb ;
    p0_pipedata_nxt.push_cq_cq               = fifo_chp_lsp_tok_pop_data.cq [ 6 : 0 ] ;
    p0_pipedata_nxt.push_cq_cmd              = fifo_chp_lsp_tok_pop_data.cmd ;
    p0_pipedata_nxt.push_cq_tokens           = fifo_chp_lsp_tok_pop_data.count ;
    p0_pipedata_nxt.push_cq_parity           = fifo_chp_lsp_tok_pop_data.parity ;
    p0_pipedata_nxt.push_cq_tokens_residue   = fifo_chp_lsp_tok_pop_data.count_residue ;

    if ( fifo_chp_lsp_tok_pop_data.cmd == HQM_CMD_ARM ) begin
      egress_credit_alloc                    = 1'b1 ;
    end

    if ( ( fifo_chp_lsp_tok_pop_data.cmd == HQM_CMD_BAT_TOK_RET )
         | ( fifo_chp_lsp_tok_pop_data.cmd == HQM_CMD_COMP_TOK_RET )
         | ( fifo_chp_lsp_tok_pop_data.cmd == HQM_CMD_A_COMP_TOK_RET )
         | ( fifo_chp_lsp_tok_pop_data.cmd == HQM_CMD_ENQ_NEW_TOK_RET )
         | ( fifo_chp_lsp_tok_pop_data.cmd == HQM_CMD_ENQ_COMP_TOK_RET )
         | ( fifo_chp_lsp_tok_pop_data.cmd == HQM_CMD_ENQ_FRAG_TOK_RET ) ) begin
      lsp_token_credit_alloc = 1'b1 ;
    end

    if ( fifo_chp_lsp_tok_pop_data.is_ldb ) begin
      take_ldb_v                             = 1'b1 ;
      take_ldb_cq                            = fifo_chp_lsp_tok_pop_data.cq [ 6 : 0 ] ;
    end
    else begin
      take_dir_v                             = 1'b1 ;
      take_dir_cq                            = fifo_chp_lsp_tok_pop_data.cq [ 6 : 0 ] ;
    end
  end

  if ( take_ldb_v ) begin
    rw_ldb_cq_wptr_p0_v_nxt                  = 1'b1 ;
    rw_ldb_cq_wptr_p0_rmw_nxt                = HQM_AW_RMWPIPE_RMW ;
    rw_ldb_cq_wptr_p0_addr_nxt               = take_ldb_cq [ 5 : 0 ];
    rw_ldb_cq_token_depth_select_p0_v_nxt    = 1'b1 ;
    rw_ldb_cq_token_depth_select_p0_rw_nxt   = HQM_AW_RWPIPE_READ ;
    rw_ldb_cq_token_depth_select_p0_addr_nxt = take_ldb_cq [ 5 : 0 ];
    rw_ldb_cq_intr_thresh_p0_v_nxt           = 1'b1 ;
    rw_ldb_cq_intr_thresh_p0_rw_nxt          = HQM_AW_RWPIPE_READ ;
    rw_ldb_cq_intr_thresh_p0_addr_nxt        = take_ldb_cq [ 5 : 0 ];
    rw_ldb_cq_depth_p0_v_nxt                 = 1'b1 ;
    rw_ldb_cq_depth_p0_rmw_nxt               = HQM_AW_RMWPIPE_RMW ;
    rw_ldb_cq_depth_p0_addr_nxt              = take_ldb_cq [ 5 : 0 ];
  end
  if ( take_dir_v ) begin
    rw_dir_cq_wptr_p0_v_nxt                  = 1'b1 ;
    rw_dir_cq_wptr_p0_rmw_nxt                = HQM_AW_RMWPIPE_RMW ;
    rw_dir_cq_wptr_p0_addr_nxt               = take_dir_cq [ HQM_NUM_DIR_CQB2 - 1 : 0 ];
    rw_dir_cq_token_depth_select_p0_v_nxt    = 1'b1 ;
    rw_dir_cq_token_depth_select_p0_rw_nxt   = HQM_AW_RWPIPE_READ ;
    rw_dir_cq_token_depth_select_p0_addr_nxt = take_dir_cq [ HQM_NUM_DIR_CQB2 - 1 : 0 ];
    rw_dir_cq_intr_thresh_p0_v_nxt           = 1'b1 ;
    rw_dir_cq_intr_thresh_p0_rw_nxt          = HQM_AW_RWPIPE_READ ;
    rw_dir_cq_intr_thresh_p0_addr_nxt        = take_dir_cq [ HQM_NUM_DIR_CQB2 - 1 : 0 ];
    rw_dir_cq_depth_p0_v_nxt                 = 1'b1 ;
    rw_dir_cq_depth_p0_rmw_nxt               = HQM_AW_RMWPIPE_RMW ;
    rw_dir_cq_depth_p0_addr_nxt              = take_dir_cq [ HQM_NUM_DIR_CQB2 - 1 : 0 ];
  end

  //====================================================================================================

  //..................................................
  // * check & correct dequeue/pop HCW ecc
  pop_cq_ecc_check_l_enable                  = p0_pipedata_f.pop_cq_v ;
  pop_cq_ecc_check_h_enable                  = p0_pipedata_f.pop_cq_v ;
  p1_pipedata_nxt.pop_cq_hcw                 = { pop_cq_ecc_check_h_dout , pop_cq_ecc_check_l_dout } ;
  p1_pipedata_nxt.pop_cq_qe_wt_parity        = ^ { 1'd1 , p1_pipedata_nxt.pop_cq_hcw.qe_wt } ; 

  //====================================================================================================

  //..................................................
  // * translate from internal cq_hcw_t format to output outbound_hcw_t format
  // * insert timestamp
  // * force must_be_zero fields to zero
  if ( p1_pipev_f & p1_pipedata_f.pop_cq_v  ) begin

    //convert from internal strucutre to outbound HCW strucutre
    p2_reformat_pop_cq_hcw_nxt.flags.hqmrsvd         = '0 ;
    p2_reformat_pop_cq_hcw_nxt.flags.hcw_error       = ( p1_pipedata_f.pop_cq_hcw.msg_info.hcw_data_parity_error
                                                       | p1_error_f                 //assert on ECC error detected
                                                       | p1_pipedata_f.pop_cq_error //assert on Hist list overflow
                                                       ) ;
    p2_reformat_pop_cq_hcw_nxt.flags.isz             = '0 ;
    p2_reformat_pop_cq_hcw_nxt.flags.qid_depth       = p1_pipedata_f.awuser.hqm_core_flags.congestion_management ;
    p2_reformat_pop_cq_hcw_nxt.flags.cq_gen          = 1'b0 ; //set on next clock when wptr is available

    p2_reformat_pop_cq_hcw_nxt.debug.cmp_id          = p1_pipedata_f.pop_cq_cmp_id ;
    p2_reformat_pop_cq_hcw_nxt.debug.debug           = '0 ;
    p2_reformat_pop_cq_hcw_nxt.debug.qe_wt           = p1_pipedata_f.pop_cq_hcw.qe_wt ;
    p2_reformat_pop_cq_hcw_nxt.debug.ts_flag         = p1_pipedata_f.pop_cq_hcw.ts_flag ;

    p2_reformat_pop_cq_hcw_nxt.lockid_dir_info_tokens = p1_pipedata_f.pop_cq_hcw.lockid_dir_info_tokens;

    p2_reformat_pop_cq_hcw_nxt.msg_info.msgtype      = p1_pipedata_f.pop_cq_hcw.msg_info.msgtype ;
    p2_reformat_pop_cq_hcw_nxt.msg_info.qpri         = p1_pipedata_f.pop_cq_hcw.msg_info.qpri ;
    p2_reformat_pop_cq_hcw_nxt.msg_info.qtype        = p1_pipedata_f.pop_cq_hcw.msg_info.qtype ;
    p2_reformat_pop_cq_hcw_nxt.msg_info.isz_0        = '0 ;
    p2_reformat_pop_cq_hcw_nxt.msg_info.qid	     = p1_pipedata_f.pop_cq_hcw.msg_info.qid ;
    if ( p1_pipedata_f.pop_cq_hcw.msg_info.qtype == DIRECT ) begin
      if ( p1_pipedata_f.pop_cq_hcw.pp_is_ldb ) begin
        p2_reformat_pop_cq_hcw_nxt.msg_info.qtype      = ATOMIC ;
      end
      p2_reformat_pop_cq_hcw_nxt.msg_info.qid	     = p1_pipedata_f.pop_cq_hcw.ppid ;
    end

    if ( p1_pipedata_f.pop_cq_hcw.msg_info.qtype == ATOMIC ) begin
      if ( p1_pipedata_f.pop_cq_hcw.ao_v ) begin
        p2_reformat_pop_cq_hcw_nxt.msg_info.qtype      = DIRECT ;
      end
    end

    if ( p1_pipedata_f.pop_cq_hcw.ts_flag ) begin
      p2_reformat_pop_cq_hcw_nxt.dsi_timestamp       = timestamp_delta ;
    end
    else begin
      p2_reformat_pop_cq_hcw_nxt.dsi_timestamp       = p1_pipedata_f.pop_cq_hcw.dsi_timestamp ;
    end

    p2_reformat_pop_cq_hcw_nxt.ptr                   = p1_pipedata_f.pop_cq_hcw.ptr ;

  end

  //====================================================================================================

  case ( rw_ldb_cq_token_depth_select_p2_data_f [ 3 : 0 ] )
      4'h0 : begin
        ldb_cq_depth_full                    = rw_ldb_cq_depth_p2_data_f [ 10 : 0 ] == 11'h004 ; 
        ldb_cq_token_depth_select_mask       = 11'h007 ;
        ldb_cq_wptr_mask                     = 11'h003 ;
        ldb_cq_gen                           = ~ rw_ldb_cq_wptr_p2_data_f [ 2 ] ;
        ldb_cq_wp_wrap                       = rw_ldb_cq_wptr_p2_data_f [ 10 : 0 ] == 11'h007 ;
      end
      4'h1 : begin
        ldb_cq_depth_full                    = rw_ldb_cq_depth_p2_data_f [ 10 : 0 ] == 11'h008 ; 
        ldb_cq_token_depth_select_mask       = 11'h00f ;
        ldb_cq_wptr_mask                     = 11'h007 ;
        ldb_cq_gen                           = ~ rw_ldb_cq_wptr_p2_data_f [ 3 ] ;
        ldb_cq_wp_wrap                       = rw_ldb_cq_wptr_p2_data_f [ 10 : 0 ] == 11'h00f ;
      end
      4'h2 : begin
        ldb_cq_depth_full                    = rw_ldb_cq_depth_p2_data_f [ 10 : 0 ] == 11'h010 ; 
        ldb_cq_token_depth_select_mask       = 11'h01f ;
        ldb_cq_wptr_mask                     = 11'h00f ;
        ldb_cq_gen                           = ~ rw_ldb_cq_wptr_p2_data_f [ 4 ] ;
        ldb_cq_wp_wrap                       = rw_ldb_cq_wptr_p2_data_f [ 10 : 0 ] == 11'h01f ;
      end
      4'h3 : begin
        ldb_cq_depth_full                    = rw_ldb_cq_depth_p2_data_f [ 10 : 0 ] == 11'h020 ; 
        ldb_cq_token_depth_select_mask       = 11'h03f ;
        ldb_cq_wptr_mask                     = 11'h01f ;
        ldb_cq_gen                           = ~ rw_ldb_cq_wptr_p2_data_f [ 5 ] ;
        ldb_cq_wp_wrap                       = rw_ldb_cq_wptr_p2_data_f [ 10 : 0 ] == 11'h03f ;
      end
      4'h4 : begin
        ldb_cq_depth_full                    = rw_ldb_cq_depth_p2_data_f [ 10 : 0 ] == 11'h040 ; 
        ldb_cq_token_depth_select_mask       = 11'h07f ;
        ldb_cq_wptr_mask                     = 11'h03f ;
        ldb_cq_gen                           = ~ rw_ldb_cq_wptr_p2_data_f [ 6 ] ;
        ldb_cq_wp_wrap                       = rw_ldb_cq_wptr_p2_data_f [ 10 : 0 ] == 11'h07f ;
      end
      4'h5 : begin
        ldb_cq_depth_full                    = rw_ldb_cq_depth_p2_data_f [ 10 : 0 ] == 11'h080 ; 
        ldb_cq_token_depth_select_mask       = 11'h0ff ;
        ldb_cq_wptr_mask                     = 11'h07f ;
        ldb_cq_gen                           = ~ rw_ldb_cq_wptr_p2_data_f [ 7 ] ;
        ldb_cq_wp_wrap                       = rw_ldb_cq_wptr_p2_data_f [ 10 : 0 ] == 11'h0ff ;
      end
      4'h6 : begin
        ldb_cq_depth_full                    = rw_ldb_cq_depth_p2_data_f [ 10 : 0 ] == 11'h100 ; 
        ldb_cq_token_depth_select_mask       = 11'h1ff ;
        ldb_cq_wptr_mask                     = 11'h0ff ;
        ldb_cq_gen                           = ~ rw_ldb_cq_wptr_p2_data_f [ 8 ] ;
        ldb_cq_wp_wrap                       = rw_ldb_cq_wptr_p2_data_f [ 10 : 0 ] == 11'h1ff ;
      end
      4'h7 : begin
        ldb_cq_depth_full                    = rw_ldb_cq_depth_p2_data_f [ 10 : 0 ] == 11'h200 ; 
        ldb_cq_token_depth_select_mask       = 11'h3ff ;
        ldb_cq_wptr_mask                     = 11'h1ff ;
        ldb_cq_gen                           = ~ rw_ldb_cq_wptr_p2_data_f [ 9 ] ;
        ldb_cq_wp_wrap                       = rw_ldb_cq_wptr_p2_data_f [ 10 : 0 ] == 11'h3ff ;
      end
      4'h8 : begin
        ldb_cq_depth_full                    = rw_ldb_cq_depth_p2_data_f [ 10 : 0 ] == 11'h400 ; 
        ldb_cq_token_depth_select_mask       = 11'h7ff ;
        ldb_cq_wptr_mask                     = 11'h3ff ;
        ldb_cq_gen                           = ~ rw_ldb_cq_wptr_p2_data_f [ 10 ] ;
        ldb_cq_wp_wrap                       = rw_ldb_cq_wptr_p2_data_f [ 10 : 0 ] == 11'h7ff ;
      end
      default : begin
        ldb_cq_depth_full                    = 1'd1 ; 
        ldb_cq_token_depth_select_mask       = 11'h7ff ;
        ldb_cq_wptr_mask                     = 11'h3ff ;
        ldb_cq_gen                           = ~ rw_ldb_cq_wptr_p2_data_f [ 10 ] ;
        ldb_cq_wp_wrap                       = rw_ldb_cq_wptr_p2_data_f [ 10 : 0 ] == 11'h7ff ;
      end
  endcase
  case ( rw_dir_cq_token_depth_select_p2_data_f [ 3 : 0 ] )
      4'h0 : begin
        dir_cq_depth_full                    = rw_dir_cq_depth_p2_data_f [ 10 : 0 ] == 11'h004 ; 
        dir_cq_token_depth_select_mask       = 11'h007 ;
        dir_cq_wptr_mask                     = 11'h003 ;
        dir_cq_gen                           = ~ rw_dir_cq_wptr_p2_data_f [ 2 ] ;
        dir_cq_wp_wrap                       = rw_dir_cq_wptr_p2_data_f [ 10 : 0 ] == 11'h007 ;
      end
      4'h1 : begin
        dir_cq_depth_full                    = rw_dir_cq_depth_p2_data_f [ 10 : 0 ] == 11'h008 ; 
        dir_cq_token_depth_select_mask       = 11'h00f ;
        dir_cq_wptr_mask                     = 11'h007 ;
        dir_cq_gen                           = ~ rw_dir_cq_wptr_p2_data_f [ 3 ] ;
        dir_cq_wp_wrap                       = rw_dir_cq_wptr_p2_data_f [ 10 : 0 ] == 11'h00f ;
      end
      4'h2 : begin
        dir_cq_depth_full                    = rw_dir_cq_depth_p2_data_f [ 10 : 0 ] == 11'h010 ; 
        dir_cq_token_depth_select_mask       = 11'h01f ;
        dir_cq_wptr_mask                     = 11'h00f ;
        dir_cq_gen                           = ~ rw_dir_cq_wptr_p2_data_f [ 4 ] ;
        dir_cq_wp_wrap                       = rw_dir_cq_wptr_p2_data_f [ 10 : 0 ] == 11'h01f ;
      end
      4'h3 : begin
        dir_cq_depth_full                    = rw_dir_cq_depth_p2_data_f [ 10 : 0 ] == 11'h020 ; 
        dir_cq_token_depth_select_mask       = 11'h03f ;
        dir_cq_wptr_mask                     = 11'h01f ;
        dir_cq_gen                           = ~ rw_dir_cq_wptr_p2_data_f [ 5 ] ;
        dir_cq_wp_wrap                       = rw_dir_cq_wptr_p2_data_f [ 10 : 0 ] == 11'h03f ;
      end
      4'h4 : begin
        dir_cq_depth_full                    = rw_dir_cq_depth_p2_data_f [ 10 : 0 ] == 11'h040 ; 
        dir_cq_token_depth_select_mask       = 11'h07f ;
        dir_cq_wptr_mask                     = 11'h03f ;
        dir_cq_gen                           = ~ rw_dir_cq_wptr_p2_data_f [ 6 ] ;
        dir_cq_wp_wrap                       = rw_dir_cq_wptr_p2_data_f [ 10 : 0 ] == 11'h07f ;
      end
      4'h5 : begin
        dir_cq_depth_full                    = rw_dir_cq_depth_p2_data_f [ 10 : 0 ] == 11'h080 ; 
        dir_cq_token_depth_select_mask       = 11'h0ff ;
        dir_cq_wptr_mask                     = 11'h07f ;
        dir_cq_gen                           = ~ rw_dir_cq_wptr_p2_data_f [ 7 ] ;
        dir_cq_wp_wrap                       = rw_dir_cq_wptr_p2_data_f [ 10 : 0 ] == 11'h0ff ;
      end
      4'h6 : begin
        dir_cq_depth_full                    = rw_dir_cq_depth_p2_data_f [ 10 : 0 ] == 11'h100 ; 
        dir_cq_token_depth_select_mask       = 11'h1ff ;
        dir_cq_wptr_mask                     = 11'h0ff ;
        dir_cq_gen                           = ~ rw_dir_cq_wptr_p2_data_f [ 8 ] ;
        dir_cq_wp_wrap                       = rw_dir_cq_wptr_p2_data_f [ 10 : 0 ] == 11'h1ff ;
      end
      4'h7 : begin
        dir_cq_depth_full                    = rw_dir_cq_depth_p2_data_f [ 10 : 0 ] == 11'h200 ; 
        dir_cq_token_depth_select_mask       = 11'h3ff ;
        dir_cq_wptr_mask                     = 11'h1ff ;
        dir_cq_gen                           = ~ rw_dir_cq_wptr_p2_data_f [ 9 ] ;
        dir_cq_wp_wrap                       = rw_dir_cq_wptr_p2_data_f [ 10 : 0 ] == 11'h3ff ;
      end
      4'h8 : begin
        dir_cq_depth_full                    = rw_dir_cq_depth_p2_data_f [ 10 : 0 ] == 11'h400 ; 
        dir_cq_token_depth_select_mask       = 11'h7ff ;
        dir_cq_wptr_mask                     = 11'h3ff ;
        dir_cq_gen                           = ~ rw_dir_cq_wptr_p2_data_f [ 10 ] ;
        dir_cq_wp_wrap                       = rw_dir_cq_wptr_p2_data_f [ 10 : 0 ] == 11'h7ff ;
      end
      default : begin
        dir_cq_depth_full                    = 1'd1 ; 
        dir_cq_token_depth_select_mask       = 11'h7ff ;
        dir_cq_wptr_mask                     = 11'h3ff ;
        dir_cq_gen                           = ~ rw_dir_cq_wptr_p2_data_f [ 10 ] ;
        dir_cq_wp_wrap                       = rw_dir_cq_wptr_p2_data_f [ 10 : 0 ] == 11'h7ff ;
      end
  endcase

  //..................................................
  //calculate wptr & depth next values
  rw_ldb_cq_wptr_p2_data_f_p1                = ( ( rw_ldb_cq_wptr_p2_data_f [ 10 : 0 ] + { { 10 { 1'b0 } } , 1'b1 } ) & ldb_cq_token_depth_select_mask ) ;
  rw_ldb_cq_depth_p2_data_f_p1               = ( rw_ldb_cq_depth_p2_data_f [ 10 : 0 ] + { { 10 { 1'b0 } } , 1'b1 } ) ;
  rw_ldb_cq_depth_p2_data_f_m                = ( rw_ldb_cq_depth_p2_data_f [ 10 : 0 ] - p2_pipedata_f.push_cq_tokens [ 10 : 0 ] ) ;


  rw_dir_cq_wptr_p2_data_f_p1                = ( ( rw_dir_cq_wptr_p2_data_f [ 10 : 0 ] + { { 10 { 1'b0 } } , 1'b1 } ) & dir_cq_token_depth_select_mask ) ;
  rw_dir_cq_depth_p2_data_f_p1               = ( rw_dir_cq_depth_p2_data_f [ 10 : 0 ] + { { 10 { 1'b0 } } , 1'b1 } ) ;
  rw_dir_cq_depth_p2_data_f_m                = ( rw_dir_cq_depth_p2_data_f [ 10 : 0 ] - p2_pipedata_f.push_cq_tokens [ 10 : 0 ] ) ;

  //..................................................
  //detect cq_depth error conditions & saturate the cq_depth  count
  egress_err_ldb_cq_depth_underflow = p2_pipev_f & p2_pipedata_f.push_cq_v & p2_pipedata_f.push_cq_is_ldb & ( rw_ldb_cq_depth_p2_data_f [ 10 : 0 ] < p2_pipedata_f.push_cq_tokens [ 10 : 0 ] ) ;
  egress_err_ldb_cq_depth_overflow = p2_pipev_f & p2_pipedata_f.pop_cq_v & p2_pipedata_f.pop_cq_is_ldb & ldb_cq_depth_full ;

  egress_err_dir_cq_depth_underflow = p2_pipev_f & p2_pipedata_f.push_cq_v & ~ p2_pipedata_f.push_cq_is_ldb & ( rw_dir_cq_depth_p2_data_f [ 10 : 0 ] < p2_pipedata_f.push_cq_tokens [ 10 : 0 ] );
  egress_err_dir_cq_depth_overflow = p2_pipev_f & p2_pipedata_f.pop_cq_v & ~ p2_pipedata_f.pop_cq_is_ldb & dir_cq_depth_full ;

  p2_pipedata_push_cq_parity        = ^ { p2_pipedata_f.push_cq_parity          // Subtract out the cmd bits not used in LSP
                                        , p2_pipedata_f.push_cq_cmd } ;

  chp_lsp_token_qb_in_valid = 1'b0 ;
  chp_lsp_token_qb_in_data.cmd = HQM_CMD_NOOP ;         // 0
  chp_lsp_token_qb_in_data.cq = { 1'd0, p2_pipedata_f.push_cq_cq } ;
  chp_lsp_token_qb_in_data.is_ldb = p2_pipedata_f.push_cq_is_ldb ;
  chp_lsp_token_qb_in_data.parity = p2_pipedata_push_cq_parity ;                // Adjusted parity
  chp_lsp_token_qb_in_data.count = p2_pipedata_f.push_cq_is_ldb ? ( egress_err_ldb_cq_depth_underflow ? { 2'd0 , rw_ldb_cq_depth_p2_data_f [ 10 : 0 ] } : p2_pipedata_f.push_cq_tokens ) :
                                   ( egress_err_dir_cq_depth_underflow ? { 2'd0 , rw_dir_cq_depth_p2_data_f [ 10 : 0 ] } : p2_pipedata_f.push_cq_tokens ) ; 
  chp_lsp_token_qb_in_data.count_residue = p2_pipedata_f.push_cq_is_ldb ? ( egress_err_ldb_cq_depth_underflow ? rw_ldb_cq_depth_p2_data_f [ 12 : 11 ] : p2_pipedata_f.push_cq_tokens_residue ) :
                                           ( egress_err_dir_cq_depth_underflow ? rw_dir_cq_depth_p2_data_f [ 12 : 11 ] : p2_pipedata_f.push_cq_tokens_residue ) ; 
  //..................................................
  // update counts

  if ( p2_pipev_f ) begin

    //processing schedule/pop - increase wptr &
    if ( p2_pipedata_f.pop_cq_v ) begin
      if ( p2_pipedata_f.pop_cq_is_ldb ) begin
        rw_ldb_cq_wptr_p3_bypsel_nxt         = 1'b1 ;
        rw_ldb_cq_wptr_p3_bypdata_nxt        = { ldb_cq_wptr_res_p1 , rw_ldb_cq_wptr_p2_data_f_p1 } ;
        rw_ldb_cq_depth_p3_bypsel_nxt        = 1'b1 ;
        rw_ldb_cq_depth_p3_bypdata_nxt       = egress_err_ldb_cq_depth_overflow ? rw_ldb_cq_depth_p2_data_f : { ldb_cq_depth_res_p1 , rw_ldb_cq_depth_p2_data_f_p1 } ;
      end
      else begin
        rw_dir_cq_wptr_p3_bypsel_nxt         = 1'b1 ;
        rw_dir_cq_wptr_p3_bypdata_nxt        = { dir_cq_wptr_res_p1 , rw_dir_cq_wptr_p2_data_f_p1 } ;
        rw_dir_cq_depth_p3_bypsel_nxt        = 1'b1 ;
        rw_dir_cq_depth_p3_bypdata_nxt       = egress_err_dir_cq_depth_overflow ? rw_dir_cq_depth_p2_data_f : { dir_cq_depth_res_p1 , rw_dir_cq_depth_p2_data_f_p1 } ;
      end
    end

    //processing enqueue/push
    if ( ( p2_pipedata_f.push_cq_v )
       & ( ( p2_pipedata_f.push_cq_cmd == HQM_CMD_BAT_TOK_RET )
         | ( p2_pipedata_f.push_cq_cmd == HQM_CMD_COMP_TOK_RET )
         | ( p2_pipedata_f.push_cq_cmd == HQM_CMD_A_COMP_TOK_RET )
         | ( p2_pipedata_f.push_cq_cmd == HQM_CMD_ENQ_NEW_TOK_RET )
         | ( p2_pipedata_f.push_cq_cmd == HQM_CMD_ENQ_COMP_TOK_RET )
         | ( p2_pipedata_f.push_cq_cmd == HQM_CMD_ENQ_FRAG_TOK_RET )
         )
       ) begin
      if ( p2_pipedata_f.push_cq_is_ldb ) begin
        rw_ldb_cq_depth_p3_bypsel_nxt        = 1'b1 ;
        rw_ldb_cq_depth_p3_bypdata_nxt       = egress_err_ldb_cq_depth_underflow ? '0 : { ldb_cq_depth_res_m , rw_ldb_cq_depth_p2_data_f_m } ;
      end
      else begin
        rw_dir_cq_depth_p3_bypsel_nxt        = 1'b1 ;
        rw_dir_cq_depth_p3_bypdata_nxt       = egress_err_dir_cq_depth_underflow ? '0 : { dir_cq_depth_res_m , rw_dir_cq_depth_p2_data_f_m } ;
      end
      chp_lsp_token_qb_in_valid = 1'b1 ;
    end
  end

  //..................................................
  // insert generation bit & generate parity to send to system
  // Issue to system & CIAL/WD through drain FIFO fifo_chp_sys_tx_fifo

  // generate p2_final_pop_cq_hcw, add generation to flags & generate parity ver final HCW for system correction code
  p2_final_pop_cq_hcw                                              = p2_reformat_pop_cq_hcw_f ;
  if ( p2_pipedata_f.pop_cq_is_ldb ) begin
    p2_final_pop_cq_hcw.flags.cq_gen                               = ldb_cq_gen ;
  end
  else begin
    p2_final_pop_cq_hcw.flags.cq_gen                               = dir_cq_gen ;
  end
  par_gen_l_d                                                      = p2_final_pop_cq_hcw [ 63 : 0 ] ;
  par_gen_h_d                                                      = p2_final_pop_cq_hcw [ 127 : 64 ] ;

  // only push pop/schedule to drain FIFO to send to system
  fifo_chp_sys_tx_fifo_mem_push                                  = p2_pipev_f & p2_pipedata_f.pop_cq_v ;
  fifo_chp_sys_tx_fifo_mem_push_data                               = '0 ;

  // TO SYSTEM portion of chp_sys_tx_fifo: HCW & user field
  fifo_chp_sys_tx_fifo_mem_push_data.tx_data.user.hqm_core_flags = p2_pipedata_f.awuser.hqm_core_flags ;
  fifo_chp_sys_tx_fifo_mem_push_data.tx_data.user.hqm_core_flags.pad_ok = pad_ok ;
  fifo_chp_sys_tx_fifo_mem_push_data.tx_data.user.cq             = p2_pipedata_f.awuser.cq ;
  if ( p2_pipedata_f.pop_cq_is_ldb ) begin
    fifo_chp_sys_tx_fifo_mem_push_data.tx_data.user.cq_wptr      = { 2'd0 , ( rw_ldb_cq_wptr_p2_data_f [ 10 : 0 ] & ldb_cq_wptr_mask ) } ;
    if ( cfg_64bytes_qe_ldb_cq_mode ) begin
      fifo_chp_sys_tx_fifo_mem_push_data.tx_data.user.cq_wptr    = {        ( rw_ldb_cq_wptr_p2_data_f [ 10 : 0 ] & ldb_cq_wptr_mask ) , 2'd0 } ;
      fifo_chp_sys_tx_fifo_mem_push_data.tx_data.user.hqm_core_flags.pad_ok = 1'd1 ;
      fifo_chp_sys_tx_fifo_mem_push_data.tx_data.user.hqm_core_flags.parity = ^ { 1'b1 
                                                                                , ^ { 1'b1
                                                                                    , p2_pipedata_f.awuser.hqm_core_flags.write_buffer_optimization
                                                                                    }
                                                                                , p2_pipedata_f.awuser.hqm_core_flags.parity
                                                                                } ;
      fifo_chp_sys_tx_fifo_mem_push_data.tx_data.user.hqm_core_flags.write_buffer_optimization = 2'd0 ;
    end
  end
  else begin
    fifo_chp_sys_tx_fifo_mem_push_data.tx_data.user.cq_wptr      = { 2'd0 , ( rw_dir_cq_wptr_p2_data_f [ 10 : 0 ] & dir_cq_wptr_mask ) } ;
    if ( cfg_64bytes_qe_dir_cq_mode ) begin
      fifo_chp_sys_tx_fifo_mem_push_data.tx_data.user.cq_wptr    = {        ( rw_dir_cq_wptr_p2_data_f [ 10 : 0 ] & dir_cq_wptr_mask ) , 2'd0 } ;
      fifo_chp_sys_tx_fifo_mem_push_data.tx_data.user.hqm_core_flags.pad_ok = 1'd1 ;
      fifo_chp_sys_tx_fifo_mem_push_data.tx_data.user.hqm_core_flags.parity = ^ { 1'b1 
                                                                                , ^ { 1'b1
                                                                                    , p2_pipedata_f.awuser.hqm_core_flags.write_buffer_optimization
                                                                                    }
                                                                                , p2_pipedata_f.awuser.hqm_core_flags.parity
                                                                                } ;
      fifo_chp_sys_tx_fifo_mem_push_data.tx_data.user.hqm_core_flags.write_buffer_optimization = 2'd0 ;
    end
  end


 fifo_chp_sys_tx_fifo_mem_push_data.tx_data.user.hqm_core_flags.parity = ^ { ( ~ egress_error_inject_h1 & ~ egress_error_inject_l1 )
                                                                            , ^ { 1'b1
                                                                                , fifo_chp_sys_tx_fifo_mem_push_data.tx_data.user.hqm_core_flags.pad_ok
                                                                                , fifo_chp_sys_tx_fifo_mem_push_data.tx_data.user.cq
                                                                                , fifo_chp_sys_tx_fifo_mem_push_data.tx_data.user.cq_wptr
                                                                                }
                                                                            , fifo_chp_sys_tx_fifo_mem_push_data.tx_data.user.hqm_core_flags.parity 
                                                                            } ;


  egress_error_inject_h0_done_set = fifo_chp_sys_tx_fifo_mem_push & egress_error_inject_h0 ;
  egress_error_inject_l0_done_set = fifo_chp_sys_tx_fifo_mem_push & egress_error_inject_l0 ;
  egress_error_inject_h1_done_set = fifo_chp_sys_tx_fifo_mem_push & egress_error_inject_h1 ;
  egress_error_inject_l1_done_set = fifo_chp_sys_tx_fifo_mem_push & egress_error_inject_l1 ;
  
  fifo_chp_sys_tx_fifo_mem_push_data.tx_data.user.hcw_parity     = { ( par_gen_h_p ^ egress_error_inject_h0 ) , ( par_gen_l_p ^ egress_error_inject_l0 ) } ;
  fifo_chp_sys_tx_fifo_mem_push_data.tx_data.data                = p2_final_pop_cq_hcw ;

  //TO CIAL/WD portion of chp_sys_tx_fifo:: threshold , current depth, cq
  fifo_chp_sys_tx_fifo_mem_push_data.cial_data.hcw_v             = p2_pipedata_f.pop_cq_v ;
  fifo_chp_sys_tx_fifo_mem_push_data.cial_data.is_ldb            = p2_pipedata_f.pop_cq_is_ldb ;
  fifo_chp_sys_tx_fifo_mem_push_data.cial_data.cq                = { fifo_chp_sys_tx_fifo_mem_push_data_cial_parity , p2_pipedata_f.pop_cq_cq } ;
  fifo_chp_sys_tx_fifo_mem_push_data.cial_data.cmd               = HQM_CMD_NOOP ;
  if ( p2_pipedata_f.pop_cq_is_ldb ) begin
    fifo_chp_sys_tx_fifo_mem_push_data.cial_data.threshold       = { 2'd0 , rw_ldb_cq_intr_thresh_p2_data_f [ 11 : 0 ] } ;
    fifo_chp_sys_tx_fifo_mem_push_data.cial_data.depth           = { 2'd0 , rw_ldb_cq_depth_p3_bypdata_nxt [ 10 : 0 ] } ;
  end
  else begin
    fifo_chp_sys_tx_fifo_mem_push_data.cial_data.threshold       = { 2'd0 , rw_dir_cq_intr_thresh_p2_data_f [ 11 : 0 ] } ;
    fifo_chp_sys_tx_fifo_mem_push_data.cial_data.depth           = { 2'd0 , rw_dir_cq_depth_p3_bypdata_nxt [ 10 : 0 ] } ;
  end

  if ( p2_pipev_f & p2_pipedata_f.push_cq_v & ( p2_pipedata_f.push_cq_cmd == HQM_CMD_ARM ) ) begin
    fifo_chp_sys_tx_fifo_mem_push                                = 1'b1 ;
    fifo_chp_sys_tx_fifo_mem_push_data.cial_data.hcw_v           = 1'b1 ;
    fifo_chp_sys_tx_fifo_mem_push_data.cial_data.is_ldb          = p2_pipedata_f.push_cq_is_ldb ;
    fifo_chp_sys_tx_fifo_mem_push_data.cial_data.cq              = { fifo_chp_sys_tx_fifo_mem_push_data_cial_parity , p2_pipedata_f.push_cq_cq } ;
    fifo_chp_sys_tx_fifo_mem_push_data.cial_data.cmd             = HQM_CMD_ARM ;
  end

  //..................................................
  //drive pop/schedule from drain FIFO to system TX interface (use tx_nobuf since chp_sys_tx_fifo has output wreg)
  //  when system accepts the HCW then
  //    pop drain FIFO
  //    issue command to cial/wd control
  //    return drain FIFO credit
  fifo_chp_sys_tx_fifo_mem_pop               = '0 ;
  tx_core_valid                              = fifo_chp_sys_tx_fifo_mem_pop_data_v & 
                                               ~ ( fifo_chp_sys_tx_fifo_mem_pop_data.cial_data.hcw_v & ( fifo_chp_sys_tx_fifo_mem_pop_data.cial_data.cmd == HQM_CMD_ARM ) ) ;
  tx_core_data.user                          = fifo_chp_sys_tx_fifo_mem_pop_data.tx_data.user ;
  tx_core_data.data                          = fifo_chp_sys_tx_fifo_mem_pop_data.tx_data.data ;

  egress_wbo_error_inject_0_done_set = 1'b0 ;

  if ( tx_core_valid & tx_core_ready & ~ tx_core_data.user.hqm_core_flags.cq_is_ldb & egress_wbo_error_inject_0 ) begin
    if ( ( tx_core_data.user.hqm_core_flags.write_buffer_optimization == 2'd0 ) & ( tx_core_data.user.cq_wptr [ 1 : 0 ] == 2'd0 ) ) begin
      tx_core_data.user.hqm_core_flags.write_buffer_optimization = 2'd3 ;
      egress_wbo_error_inject_0_done_set = 1'b1 ;
    end
  end

  egress_wbo_error_inject_1_done_set = 1'b0 ;

  if ( tx_core_valid & tx_core_ready & ~ tx_core_data.user.hqm_core_flags.cq_is_ldb & egress_wbo_error_inject_1 ) begin
    if ( ( tx_core_data.user.hqm_core_flags.write_buffer_optimization == 2'd1 ) & ( tx_core_data.user.cq_wptr [ 1 : 0 ] <= 2'd1 ) ) begin
      tx_core_data.user.hqm_core_flags.write_buffer_optimization = 2'd2 ;
      egress_wbo_error_inject_1_done_set = 1'b1 ;
    end
  end

  egress_wbo_error_inject_2_done_set = 1'b0 ;

  if ( tx_core_valid & tx_core_ready & ~ tx_core_data.user.hqm_core_flags.cq_is_ldb & egress_wbo_error_inject_2 ) begin
    if ( tx_core_data.user.hqm_core_flags.write_buffer_optimization == 2'd2 ) begin
      tx_core_data.user.hqm_core_flags.write_buffer_optimization = 2'd1 ;
      egress_wbo_error_inject_2_done_set = 1'b1 ;
    end
  end

  egress_wbo_error_inject_3_done_set = 1'b0 ;

  if ( tx_core_valid & tx_core_ready & ~ tx_core_data.user.hqm_core_flags.cq_is_ldb & egress_wbo_error_inject_3 ) begin
    if ( tx_core_data.user.hqm_core_flags.write_buffer_optimization == 2'd3 ) begin
      tx_core_data.user.hqm_core_flags.write_buffer_optimization = 2'd0 ;
      egress_wbo_error_inject_3_done_set = 1'b1 ;
    end
  end

  if ( tx_core_valid & tx_core_ready ) begin
    egress_credit_dealloc                    = 1'b1 ;
    fifo_chp_sys_tx_fifo_mem_pop             = 1'b1 ;
  end

  if ( fifo_chp_sys_tx_fifo_mem_pop_data_v & 
       fifo_chp_sys_tx_fifo_mem_pop_data.cial_data.hcw_v & ( fifo_chp_sys_tx_fifo_mem_pop_data.cial_data.cmd == HQM_CMD_ARM ) ) begin
    egress_credit_dealloc                    = 1'b1 ;
    fifo_chp_sys_tx_fifo_mem_pop             = 1'b1 ;
  end

  if ( fifo_chp_sys_tx_fifo_mem_pop ) begin
    if ( fifo_chp_sys_tx_fifo_mem_pop_data.cial_data.is_ldb ) begin
      sch_ldb_excep_nxt.hcw_v                = 1'b1 ;
      sch_ldb_excep_nxt.is_ldb               = fifo_chp_sys_tx_fifo_mem_pop_data.cial_data.is_ldb ;
      sch_ldb_excep_nxt.cq                   = fifo_chp_sys_tx_fifo_mem_pop_data.cial_data.cq ;
      sch_ldb_excep_nxt.cmd                  = fifo_chp_sys_tx_fifo_mem_pop_data.cial_data.cmd ;
      sch_ldb_excep_nxt.threshold            = fifo_chp_sys_tx_fifo_mem_pop_data.cial_data.threshold ;
      sch_ldb_excep_nxt.depth                = fifo_chp_sys_tx_fifo_mem_pop_data.cial_data.depth ;
    end
    else begin
      sch_dir_excep_nxt.hcw_v                = 1'b1 ;
      sch_dir_excep_nxt.is_ldb               = fifo_chp_sys_tx_fifo_mem_pop_data.cial_data.is_ldb ;
      sch_dir_excep_nxt.cq                   = fifo_chp_sys_tx_fifo_mem_pop_data.cial_data.cq ;
      sch_dir_excep_nxt.cmd                  = fifo_chp_sys_tx_fifo_mem_pop_data.cial_data.cmd ;
      sch_dir_excep_nxt.threshold            = fifo_chp_sys_tx_fifo_mem_pop_data.cial_data.threshold ;
      sch_dir_excep_nxt.depth                = fifo_chp_sys_tx_fifo_mem_pop_data.cial_data.depth ;
    end
  end

  //..................................................
  // issue push/enqueue to CIAL & WD
  //  CIAL & WD modules have 2 interfaces for updates , one for enqueue & one for schedule , this logic directs the commands
  if ( p2_pipev_f ) begin
    //for push/enqueue send to CIAL/WD immediately since this interface cannot be BP & CIAL/WD accumualtes into its bit vector
    if ( p2_pipedata_f.push_cq_v 
         & ( ( p2_pipedata_f.push_cq_cmd == HQM_CMD_BAT_TOK_RET )
           | ( p2_pipedata_f.push_cq_cmd == HQM_CMD_COMP_TOK_RET )
           | ( p2_pipedata_f.push_cq_cmd == HQM_CMD_A_COMP_TOK_RET )
           | ( p2_pipedata_f.push_cq_cmd == HQM_CMD_ENQ_NEW_TOK_RET )
           | ( p2_pipedata_f.push_cq_cmd == HQM_CMD_ENQ_COMP_TOK_RET )
           | ( p2_pipedata_f.push_cq_cmd == HQM_CMD_ENQ_FRAG_TOK_RET )
           ) ) begin
      if ( p2_pipedata_f.push_cq_is_ldb ) begin
        enq_ldb_excep_nxt.hcw_v              = 1'b1 ;
        enq_ldb_excep_nxt.is_ldb             = p2_pipedata_f.push_cq_is_ldb ;
        enq_ldb_excep_nxt.cq                 = { 1'b0 , p2_pipedata_f.push_cq_cq } ;
        enq_ldb_excep_nxt.cmd                = p2_pipedata_f.push_cq_cmd ;
        enq_ldb_excep_nxt.threshold          = { 2'd0 , rw_ldb_cq_intr_thresh_p2_data_f [ 11 : 0 ] } ;
        enq_ldb_excep_nxt.depth              = { 2'd0 , rw_ldb_cq_depth_p3_bypdata_nxt [ 10 : 0 ] } ;
      end
      else begin
        enq_dir_excep_nxt.hcw_v              = 1'b1 ;
        enq_dir_excep_nxt.is_ldb             = p2_pipedata_f.push_cq_is_ldb ;
        enq_dir_excep_nxt.cq                 = { 1'b0 , p2_pipedata_f.push_cq_cq } ;
        enq_dir_excep_nxt.cmd                = p2_pipedata_f.push_cq_cmd ;
        enq_dir_excep_nxt.threshold          = { 2'd0 , rw_dir_cq_intr_thresh_p2_data_f [ 11 : 0 ] } ;
        enq_dir_excep_nxt.depth              = { 2'd0 , rw_dir_cq_depth_p3_bypdata_nxt [ 10 : 0 ] } ;
      end
    end
  end

  //====================================================================================================
  //..................................................
  //Errors
  egress_err_parity_ldb_cq_token_depth_select = ( err_parity_ldb_cq_token_depth_select ) ;
  egress_err_parity_dir_cq_token_depth_select = ( err_parity_dir_cq_token_depth_select ) ;
  egress_err_parity_ldb_cq_intr_thresh       = ( err_parity_ldb_cq_intr_thresh ) ;
  egress_err_parity_dir_cq_intr_thresh       = ( err_parity_dir_cq_intr_thresh ) ;
  egress_err_residue_ldb_cq_wptr             = ( err_residue_ldb_cq_wptr ) ;
  egress_err_residue_dir_cq_wptr             = ( err_residue_dir_cq_wptr ) ;
  egress_err_residue_ldb_cq_depth            = ( err_residue_ldb_cq_depth ) ;
  egress_err_residue_dir_cq_depth            = ( err_residue_dir_cq_depth ) ;

  egress_err_ldb_rid                         = egress_err_ldb_cq_depth_underflow ? { 1'b0 , p2_pipedata_f.push_cq_cq } : { 1'b0 , p2_pipedata_f.pop_cq_cq } ;
  egress_err_dir_rid                         = egress_err_dir_cq_depth_underflow ? { 1'b0 , p2_pipedata_f.push_cq_cq } : { 1'b0 , p2_pipedata_f.pop_cq_cq } ;

  egress_err_hcw_ecc_sb                      = ( pop_cq_ecc_check_l_error_sb | pop_cq_ecc_check_h_error_sb ) ;
  egress_err_hcw_ecc_mb                      = ( pop_cq_ecc_check_l_error_mb | pop_cq_ecc_check_h_error_mb ) ;

  //..................................................
  egress_pipe_idle  = ( ( ~ p0_pipev_f )
                      & ( ~ p1_pipev_f )
                      & ( ~ p2_pipev_f )
                      ) ;
  egress_unit_idle  = ( ( egress_pipe_idle )
                      & ( tx_sync_idle )
                      & ( egress_credit_empty & lsp_token_credit_empty )
                      ) ;

  // on MB error included since this is used in the HCW flags.hcw_error
  p1_error_nxt = ( pop_cq_ecc_check_l_error_mb | pop_cq_ecc_check_h_error_mb ) ; 

  egress_credit_status = { egress_credit_size , egress_credit_empty , egress_credit_full , egress_credit_afull , egress_credit_error } ;
  egress_lsp_token_credit_status = { lsp_token_credit_size , lsp_token_credit_empty , lsp_token_credit_full , lsp_token_credit_afull , lsp_token_credit_error } ;
end

//https://hsdes.intel.com/appstore/article/#/1407239306
// bit 6 of cq field used to carry parity
// V25 change:
// To support 96 dir cq in V25, bit 6 of cq field can't no longer be used to carry the parity.
// in V25, the pad_ok field of the hqm_core_flags is used to carry the parity instead.
hqm_AW_parity_check #(
         .WIDTH ($bits(fifo_outbound_hcw_pop_data.cq[6:0]) +
                 $bits(fifo_outbound_hcw_pop_data.cq_is_ldb) +
                 $bits(fifo_outbound_hcw_pop_data.error) +
                 $bits(fifo_outbound_hcw_pop_data.cmp_id))
) i_hqm_chp_partial_outbound_hcw_fifo_parity_check (
         .p( fifo_outbound_hcw_pop_data.flags.pad_ok )
        ,.d( {fifo_outbound_hcw_pop_data.cq[6:0],fifo_outbound_hcw_pop_data.cq_is_ldb,fifo_outbound_hcw_pop_data.error,fifo_outbound_hcw_pop_data.cmp_id} )
        ,.e( fifo_outbound_hcw_pop_data_v)
        ,.odd( 1'b1 ) // odd
        ,.err( hqm_chp_partial_outbound_hcw_fifo_parity_err)
);

//https://hsdes.intel.com/appstore/article/#/1407239306
// use bit 7 of cq to send over parity to cial
hqm_AW_parity_gen #(
      .WIDTH( $bits(fifo_chp_sys_tx_fifo_mem_push_data.cial_data)-1 ) // entire struct minus the cq[0] bit which is used fo rparity
) i_fifo_chp_sys_tx_fifo_mem_push_data_cial_parity_gen (
        .d     ( {
                    fifo_chp_sys_tx_fifo_mem_push_data.cial_data.hcw_v
                   ,fifo_chp_sys_tx_fifo_mem_push_data.cial_data.is_ldb
                   ,fifo_chp_sys_tx_fifo_mem_push_data.cial_data.threshold
                   ,fifo_chp_sys_tx_fifo_mem_push_data.cial_data.cq[6:0]
                   ,fifo_chp_sys_tx_fifo_mem_push_data.cial_data.depth
                   ,fifo_chp_sys_tx_fifo_mem_push_data.cial_data.cmd
                  })
       ,.odd   ( 1'b1 ) // odd
       ,.p     ( fifo_chp_sys_tx_fifo_mem_push_data_cial_parity )
);

hqm_chp_sys_wb_pad_flag i_hqm_chp_sys_wb_pad_flag (
    .cfg_pad_first_write_ldb ( cfg_pad_first_write_ldb )
  , .cfg_pad_first_write_dir ( cfg_pad_first_write_dir ) 
  , .cfg_pad_write_ldb ( cfg_pad_write_ldb )
  , .cfg_pad_write_dir ( cfg_pad_write_dir ) 
  , .is_ldb ( p2_pipedata_f.pop_cq_is_ldb )
  , .ldb_cq_wptr ( rw_ldb_cq_wptr_p2_data_f [ 1 : 0 ] )
  , .dir_cq_wptr ( rw_dir_cq_wptr_p2_data_f [ 1 : 0 ] )
  , .ldb_cq_token_depth_select ( rw_ldb_cq_token_depth_select_p2_data_f [ 3 : 0 ] )
  , .dir_cq_token_depth_select ( rw_dir_cq_token_depth_select_p2_data_f [ 3 : 0 ] )
  , .ldb_cq_depth ( rw_ldb_cq_depth_p2_data_f [ 10 : 0 ] )
  , .dir_cq_depth ( { 2'b00, rw_dir_cq_depth_p2_data_f [ 10 : 0 ] } )
  , .pad_ok ( pad_ok )
);

endmodule
