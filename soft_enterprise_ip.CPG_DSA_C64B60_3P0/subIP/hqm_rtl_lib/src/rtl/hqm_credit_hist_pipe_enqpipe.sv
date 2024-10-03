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
module hqm_credit_hist_pipe_enqpipe
  import hqm_AW_pkg::* , hqm_pkg::* , hqm_core_pkg::* ;
(
  input  logic                                    hqm_gated_clk
, input  logic                                    hqm_gated_rst_b



//cfg
, input  logic                                    enqpipe_flid_parity_error_inject
, input  logic                                    enqpipe_error_inject_h0
, input  logic                                    enqpipe_error_inject_l0
, input  logic                                    enqpipe_error_inject_h1
, input  logic                                    enqpipe_error_inject_l1

//errors
, output logic                                    enqpipe_err_frag_count_residue_error
, output logic                                    enqpipe_err_hist_list_data_error_sb
, output logic                                    enqpipe_err_hist_list_data_error_mb
, output logic                                    enqpipe_err_enq_to_rop_out_of_credit_drop
, output logic                                    enqpipe_err_enq_to_rop_excess_frag_drop
, output logic                                    enqpipe_err_enq_to_rop_freelist_uf_drop
, output logic                                    enqpipe_err_enq_to_lsp_cmp_error_drop
, output logic					  enqpipe_err_release_qtype_error_drop
, output logic [ 7 : 0 ]			  enqpipe_err_rid 

//counter
, output logic                                    hqm_chp_target_cfg_counter_chp_error_drop_inc

//smon
, output logic [ ( 1 * 1 ) - 1 : 0 ]              enqpipe_hqm_chp_target_cfg_chp_smon_smon_v
, output logic [ ( 1 * 32 ) - 1 : 0 ]             enqpipe_hqm_chp_target_cfg_chp_smon_smon_comp
, output logic [ ( 1 * 32 ) - 1 : 0 ]             enqpipe_hqm_chp_target_cfg_chp_smon_smon_val

//status
, output logic                                    enqpipe_pipe_idle
, output logic                                    enqpipe_unit_idle

//Interface to RMW
, output logic                                    rw_cmp_id_chk_enbl_mem_p0_v_nxt
, output aw_rwpipe_cmd_t                          rw_cmp_id_chk_enbl_mem_p0_rw_nxt
, output logic [ 5 : 0 ]                          rw_cmp_id_chk_enbl_mem_p0_addr_nxt
, input  logic [1:0]                              rw_cmp_id_chk_enbl_mem_p2_data_f

//Interface to multi FIFO
, output logic                                    enq_hist_list_cmd_v
, output aw_multi_fifo_cmd_t                      enq_hist_list_cmd
, output logic [ 5 : 0 ]                          enq_hist_list_fifo_num
, input  hist_list_mf_t                           enq_hist_list_pop_data
, input  logic                                    enq_hist_list_uf
, input  logic					  enq_hist_list_residue_error

, output logic                                    enq_hist_list_a_cmd_v
, output aw_multi_fifo_cmd_t                      enq_hist_list_a_cmd
, output logic [ 5 : 0 ]                          enq_hist_list_a_fifo_num

, input  logic [ HQM_NUM_LB_CQ - 1 : 0 ]          enqpipe_hqm_chp_target_cfg_hist_list_mode

, output logic                                    enq_freelist_pop_v
, input  chp_flid_t                               enq_freelist_pop_data
, input  logic                                    enq_freelist_pop_error
, input  logic                                    enq_freelist_error_mb
, input  logic                                    enq_freelist_uf

//Interface from arbiter/ingress
, input  logic                                    hcw_replay_pop
, input  chp_hcw_replay_data_t			  hcw_replay_data

, input  logic					  hcw_enq_pop
, input  chp_pp_info_t				  hcw_enq_info
, input  chp_pp_data_t				  hcw_enq_data

//Interface to arbiter
, output logic					  enq_to_rop_error_credit_dealloc
, output logic					  enq_to_rop_cmp_credit_dealloc
, output logic					  enq_to_lsp_cmp_error_credit_dealloc

//Interface to output drain FIFO

, output logic                                    fifo_chp_rop_hcw_push
, output chp_rop_hcw_t                            fifo_chp_rop_hcw_push_data

, output logic                                    fifo_chp_lsp_tok_push
, output chp_lsp_token_t                          fifo_chp_lsp_tok_push_data

, output logic                                    fifo_chp_lsp_ap_cmp_push
, output fifo_chp_lsp_ap_cmp_t                    fifo_chp_lsp_ap_cmp_push_data
, output logic                                    cmp_id_chk_enbl_parity_err

, output logic                                    enqpipe_flid_parity_error_inject_done_set
, output logic                                    enqpipe_error_inject_h0_done_set
, output logic                                    enqpipe_error_inject_l0_done_set
, output logic                                    enqpipe_error_inject_h1_done_set
, output logic                                    enqpipe_error_inject_l1_done_set

, output logic                                    hqm_chp_target_cfg_chp_frag_count_reg_load
, output logic [ ( 1 * 7 * 64 ) - 1 : 0]          hqm_chp_target_cfg_chp_frag_count_reg_nxt 
, input  logic [ ( 1 * 7 * 64 ) - 1 : 0]          hqm_chp_target_cfg_chp_frag_count_reg_f

) ;


enq_chp_state_t p0_enq_chp_state_nxt , p0_enq_chp_state_f ;
enq_chp_state_t p1_enq_chp_state_nxt , p1_enq_chp_state_f ;
enq_chp_state_t p2_enq_chp_state_nxt , p2_enq_chp_state_f ;
enq_chp_state_t p3_enq_chp_state_nxt , p3_enq_chp_state_f ;
enq_chp_state_t p4_enq_chp_state_nxt , p4_enq_chp_state_f ;
enq_chp_state_t p5_enq_chp_state_nxt , p5_enq_chp_state_f ;
enq_chp_state_t p6_enq_chp_state_nxt , p6_enq_chp_state_f ;  
enq_chp_state_t p7_enq_chp_state_nxt , p7_enq_chp_state_f ;  
enq_chp_state_t p8_enq_chp_state_nxt , p8_enq_chp_state_f ;  
enq_chp_state_t p9_enq_chp_state_nxt , p9_enq_chp_state_f ;  
enq_chp_state_t p10_enq_chp_state_nxt , p10_enq_chp_state_f ;  

logic p0_enq_chp_state_v_nxt , p0_enq_chp_state_v_f ;
logic p1_enq_chp_state_v_nxt , p1_enq_chp_state_v_f ;
logic p2_enq_chp_state_v_nxt , p2_enq_chp_state_v_f ;
logic p3_enq_chp_state_v_nxt , p3_enq_chp_state_v_f ;
logic p4_enq_chp_state_v_nxt , p4_enq_chp_state_v_f ;
logic p5_enq_chp_state_v_nxt , p5_enq_chp_state_v_f ;
logic p6_enq_chp_state_v_nxt , p6_enq_chp_state_v_f ;
logic p7_enq_chp_state_v_nxt , p7_enq_chp_state_v_f ;
logic p8_enq_chp_state_v_nxt , p8_enq_chp_state_v_f ;
logic p9_enq_chp_state_v_nxt , p9_enq_chp_state_v_f ;
logic p10_enq_chp_state_v_nxt , p10_enq_chp_state_v_f ;

logic								enq_freelist_pop_v_nxt , enq_freelist_pop_v_f ;

logic								enq_hist_list_a_cmd_v_nxt , enq_hist_list_a_cmd_v_f ;
logic								enq_hist_list_cmd_v_nxt , enq_hist_list_cmd_v_f ;
logic								enq_hist_list_cmd_pop_nxt , enq_hist_list_cmd_pop_f ;
aw_multi_fifo_cmd_t						enq_hist_list_cmd_nxt , enq_hist_list_cmd_f ;
logic [ 5 : 0 ]							enq_hist_list_fifo_num_nxt , enq_hist_list_fifo_num_f ;

logic								p5_hist_list_ecc_check ;
logic								p5_hist_list_ecc_enable ;
logic								p5_hist_list_ecc_correct ;
hist_list_mf_t							p5_hist_list_data_corrected ;
logic								p5_hist_list_data_error_sb ;
logic								p5_hist_list_data_error_mb ;
logic								p5_hist_list_hid_parity_odd ;
logic								p5_hist_list_hid_parity ;

logic 								enqpipe_err_enq_to_rop_error_drop ;
logic                                                           cmp_id_chk_enbl_parity_check_en;

assign p5_hist_list_ecc_check = p5_enq_chp_state_v_f & ( p5_enq_chp_state_f.to_rop_frag | p5_enq_chp_state_f.to_lsp_cmp ) &
                                ~ p5_enq_chp_state_f.hist_list_uf & ~ p5_enq_chp_state_f.hist_list_residue_error ;
assign p5_hist_list_ecc_enable = 1'd1 ;
assign p5_hist_list_ecc_correct = 1'd1 ;
assign p5_hist_list_data_corrected.ecc = '0 ;
assign p5_hist_list_hid_parity_odd = 1'd1 ;

assign hqm_chp_target_cfg_counter_chp_error_drop_inc = enqpipe_err_enq_to_rop_error_drop ;

logic [ 15 : 0 ] tokens_residue_gen_a ;
logic [ 1 : 0 ]	tokens_residue_gen_r ;

logic enq_frag_check_v ;
logic [ 5 : 0 ] enq_frag_check_pp ;
qtype_t enq_frag_check_hist_list_qtype ;
hcw_cmd_t enq_frag_check_hcw_cmd ;

logic enq_excess_frag_drop ;
logic drop_hcw_and_issue_completion_nc ;

logic [ ( HQM_NUM_LB_CQ ) - 1 : 0 ] enq_hist_list_fifo_re_sel_nxt ;
logic [ ( HQM_NUM_LB_CQ ) - 1 : 0 ] enq_hist_list_fifo_re_sel_f ;

hqm_AW_residue_gen #(
  .WIDTH					( $bits ( p0_enq_chp_state_f.tokens ) )
) i_tokens_residue_gen (
  .a						( tokens_residue_gen_a )
, .r						( tokens_residue_gen_r )
) ;

hqm_AW_ecc_check #(
  .DATA_WIDTH					( $bits ( p5_enq_chp_state_f.hist_list.qe_wt ) +
  						  $bits ( p5_enq_chp_state_f.hist_list.hid ) +
						  $bits ( p5_enq_chp_state_f.hist_list.cmp_id ) +
						  $bits ( p5_enq_chp_state_f.hist_list.hist_list_info.parity ) +
						  $bits ( p5_enq_chp_state_f.hist_list.hist_list_info.qtype ) +
						  $bits ( p5_enq_chp_state_f.hist_list.hist_list_info.qpri ) +
						  $bits ( p5_enq_chp_state_f.hist_list.hist_list_info.qid ) +
						  $bits ( p5_enq_chp_state_f.hist_list.hist_list_info.qidix_msb ) +
						  $bits ( p5_enq_chp_state_f.hist_list.hist_list_info.qidix ) +
						  $bits ( p5_enq_chp_state_f.hist_list.hist_list_info.reord_mode ) +
						  $bits ( p5_enq_chp_state_f.hist_list.hist_list_info.reord_slot ) +
						  $bits ( p5_enq_chp_state_f.hist_list.hist_list_info.sn_fid )
						)
, .ECC_WIDTH					( $bits ( p5_enq_chp_state_f.hist_list.ecc ) )
) i_p5_hist_list_ecc_check (
  .din_v					( p5_hist_list_ecc_check )
, .din						( { p5_enq_chp_state_f.hist_list.qe_wt
						  , p5_enq_chp_state_f.hist_list.hid
						  , p5_enq_chp_state_f.hist_list.cmp_id
						  , p5_enq_chp_state_f.hist_list.hist_list_info.parity
						  , p5_enq_chp_state_f.hist_list.hist_list_info.qtype
						  , p5_enq_chp_state_f.hist_list.hist_list_info.qpri
						  , p5_enq_chp_state_f.hist_list.hist_list_info.qid
						  , p5_enq_chp_state_f.hist_list.hist_list_info.qidix_msb
						  , p5_enq_chp_state_f.hist_list.hist_list_info.qidix
						  , p5_enq_chp_state_f.hist_list.hist_list_info.reord_mode
						  , p5_enq_chp_state_f.hist_list.hist_list_info.reord_slot
						  , p5_enq_chp_state_f.hist_list.hist_list_info.sn_fid
						  } )
, .ecc						( p5_enq_chp_state_f.hist_list.ecc )
, .enable					( p5_hist_list_ecc_enable )
, .correct				        ( p5_hist_list_ecc_correct )
, .dout						( { p5_hist_list_data_corrected.qe_wt
						  , p5_hist_list_data_corrected.hid
						  , p5_hist_list_data_corrected.cmp_id
						  , p5_hist_list_data_corrected.hist_list_info.parity
						  , p5_hist_list_data_corrected.hist_list_info.qtype
						  , p5_hist_list_data_corrected.hist_list_info.qpri
						  , p5_hist_list_data_corrected.hist_list_info.qid
						  , p5_hist_list_data_corrected.hist_list_info.qidix_msb
						  , p5_hist_list_data_corrected.hist_list_info.qidix
						  , p5_hist_list_data_corrected.hist_list_info.reord_mode
						  , p5_hist_list_data_corrected.hist_list_info.reord_slot
						  , p5_hist_list_data_corrected.hist_list_info.sn_fid
						  } )
, .error_sb					( p5_hist_list_data_error_sb )
, .error_mb					( p5_hist_list_data_error_mb )
) ;

hqm_AW_parity_gen #(
  .WIDTH					( $bits ( p5_hist_list_data_corrected.hid ) )
) i_p5_hist_list_hid_parity_gen (
  .d						( p5_hist_list_data_corrected.hid )
, .odd						( p5_hist_list_hid_parity_odd )
, .p						( p5_hist_list_hid_parity )
) ;

always_ff @ ( posedge hqm_gated_clk or negedge hqm_gated_rst_b ) begin
  if ( ~ hqm_gated_rst_b ) begin
    p0_enq_chp_state_v_f <= 1'd0 ;
    p1_enq_chp_state_v_f <= 1'd0 ;
    p2_enq_chp_state_v_f <= 1'd0 ;
    p3_enq_chp_state_v_f <= 1'd0 ;
    p4_enq_chp_state_v_f <= 1'd0 ;
    p5_enq_chp_state_v_f <= 1'd0 ;
    p6_enq_chp_state_v_f <= 1'd0 ;
    p7_enq_chp_state_v_f <= 1'd0 ;
    p8_enq_chp_state_v_f <= 1'd0 ;
    p9_enq_chp_state_v_f <= 1'd0 ;
    p10_enq_chp_state_v_f <= 1'd0 ;
    enq_freelist_pop_v_f <= 1'd0 ;
    enq_hist_list_a_cmd_v_f <= 1'd0 ;
    enq_hist_list_cmd_v_f <= 1'd0 ;
    enq_hist_list_fifo_re_sel_f <= { HQM_NUM_LB_CQ { 1'b0 } } ;
  end else begin
    p0_enq_chp_state_v_f <= p0_enq_chp_state_v_nxt ;
    p1_enq_chp_state_v_f <= p1_enq_chp_state_v_nxt ;
    p2_enq_chp_state_v_f <= p2_enq_chp_state_v_nxt ;
    p3_enq_chp_state_v_f <= p3_enq_chp_state_v_nxt ;
    p4_enq_chp_state_v_f <= p4_enq_chp_state_v_nxt ;
    p5_enq_chp_state_v_f <= p5_enq_chp_state_v_nxt ;
    p6_enq_chp_state_v_f <= p6_enq_chp_state_v_nxt ;
    p7_enq_chp_state_v_f <= p7_enq_chp_state_v_nxt ;
    p8_enq_chp_state_v_f <= p8_enq_chp_state_v_nxt ;
    p9_enq_chp_state_v_f <= p9_enq_chp_state_v_nxt ;
    p10_enq_chp_state_v_f <= p10_enq_chp_state_v_nxt ;
    enq_freelist_pop_v_f <= enq_freelist_pop_v_nxt ;
    enq_hist_list_a_cmd_v_f <= enq_hist_list_a_cmd_v_nxt ;
    enq_hist_list_cmd_v_f <= enq_hist_list_cmd_v_nxt ;
    enq_hist_list_fifo_re_sel_f <= enq_hist_list_fifo_re_sel_nxt ;
  end
end

always_ff @ ( posedge hqm_gated_clk ) begin
    p0_enq_chp_state_f <= p0_enq_chp_state_nxt ;
    p1_enq_chp_state_f <= p1_enq_chp_state_nxt ;
    p2_enq_chp_state_f <= p2_enq_chp_state_nxt ;
    p3_enq_chp_state_f <= p3_enq_chp_state_nxt ;
    p4_enq_chp_state_f <= p4_enq_chp_state_nxt ;
    p5_enq_chp_state_f <= p5_enq_chp_state_nxt ;
    p6_enq_chp_state_f <= p6_enq_chp_state_nxt ;
    p7_enq_chp_state_f <= p7_enq_chp_state_nxt ;
    p8_enq_chp_state_f <= p8_enq_chp_state_nxt ;
    p9_enq_chp_state_f <= p9_enq_chp_state_nxt ;
    p10_enq_chp_state_f <= p10_enq_chp_state_nxt ;
    enq_hist_list_cmd_f <= enq_hist_list_cmd_nxt ;
    enq_hist_list_cmd_pop_f <= enq_hist_list_cmd_pop_nxt ;
    enq_hist_list_fifo_num_f <= enq_hist_list_fifo_num_nxt ;
end


assign enqpipe_pipe_idle = ( ( ~p0_enq_chp_state_v_f )
              & ( ~p1_enq_chp_state_v_f )
              & ( ~p2_enq_chp_state_v_f )
              & ( ~p3_enq_chp_state_v_f )
              & ( ~p4_enq_chp_state_v_f )
              & ( ~p5_enq_chp_state_v_f )
              & ( ~p6_enq_chp_state_v_f )
              & ( ~p7_enq_chp_state_v_f )
              & ( ~p8_enq_chp_state_v_f )
              & ( ~p9_enq_chp_state_v_f )
              & ( ~p10_enq_chp_state_v_f )
              ) ;
assign enqpipe_unit_idle = ( ( enqpipe_pipe_idle )
                           ) ;


always_comb begin
  p0_enq_chp_state_v_nxt = hcw_replay_pop | hcw_enq_pop ;
  p0_enq_chp_state_nxt = p0_enq_chp_state_f ;
  p0_enq_chp_state_nxt.hist_list = '0 ;
  if ( p0_enq_chp_state_v_nxt ) begin
    p0_enq_chp_state_nxt.hcw_enq_user_parity_error_drop = 1'd0 ;
    p0_enq_chp_state_nxt.excess_frag_drop = 1'd0 ;
    p0_enq_chp_state_nxt.freelist_error_mb = 1'd0 ;
    p0_enq_chp_state_nxt.freelist_uf = 1'd0 ;
    p0_enq_chp_state_nxt.hist_list_residue_error = 1'd0 ;
    p0_enq_chp_state_nxt.hist_list_uf = 1'd0 ;
    p0_enq_chp_state_nxt.cmp_id_check = 1'd0 ;
    p0_enq_chp_state_nxt.cmp_id_error = 1'd0 ;
    p0_enq_chp_state_nxt.cmp_id = 4'd0 ;
    p0_enq_chp_state_nxt.tokens_residue = 2'd0 ;
    p0_enq_chp_state_nxt.tokens = 16'd0 ;
    p0_enq_chp_state_nxt.hid_parity = 1'd0 ;
    p0_enq_chp_state_nxt.to_rop_replay = 1'd0 ;
    p0_enq_chp_state_nxt.to_rop_nop = 1'd0 ; 
    p0_enq_chp_state_nxt.cial_arm = 1'd0 ;
    p0_enq_chp_state_nxt.to_lsp_release = 1'd0 ;
    p0_enq_chp_state_nxt.to_rop_enq = 1'd0 ; 
    p0_enq_chp_state_nxt.to_rop_frag = 1'd0 ; 
    p0_enq_chp_state_nxt.to_rop_cmp = 1'd0 ; 
    p0_enq_chp_state_nxt.to_lsp_tok = 1'd0 ; 
    p0_enq_chp_state_nxt.to_lsp_cmp = 1'd0 ; 
    p0_enq_chp_state_nxt.out_of_credit = 1'd0 ;
    p0_enq_chp_state_nxt.pp_parity = hcw_enq_info.pp_parity ;
    p0_enq_chp_state_nxt.pp = hcw_enq_info.pp ;
    p0_enq_chp_state_nxt.hcw_cmd = HQM_CMD_NOOP ;
    p0_enq_chp_state_nxt.hcw_cmd_parity = ^ { 1'd1, p0_enq_chp_state_nxt.hcw_cmd } ;
    p0_enq_chp_state_nxt.flid_parity = 1'b1 ;
    p0_enq_chp_state_nxt.flid = '0 ;

    // hcw_cmd decode
    // to_rop_nop : NOOP. this goes to rop unconditionally 
    // to_rop_enq : NEW,NEW_T,RENQ,RENQ_T,FRAG,FRAG_T. these go to rop if vas credit check is ok and there's no freelist error
    // to_rop_frag : FRAG,FRAG_T 
    // to_rop_cmp : COMP,COMP_T. these go to rop if hist_list qtype is ORDERED
    // to_lsp_cmp : COMP,COMP_T,RENQ,RENQ_T. these go to lsp for completion return
    // to_lsp_tok : BAT_T,COMP_T,RENQ_T,FRAG_T. these go to lsp for token return
    // cial_arm   : ARM. this goes to CIAL
    // to_lsp_release : RELEASE. this goes to lsp - depreciated in V3

    if ( hcw_enq_pop & hcw_enq_info.pp_is_ldb ) begin
      p0_enq_chp_state_nxt.hcw_src_id = LDB_PP_HCW ;
      p0_enq_chp_state_nxt.hcw_enq_user_parity_error_drop = hcw_enq_info.hcw_enq_user_parity_error_drop ;
      p0_enq_chp_state_nxt.out_of_credit = hcw_enq_info.out_of_credit ;
      p0_enq_chp_state_nxt.to_rop_nop = ( hcw_enq_info.hcw_cmd == HQM_CMD_NOOP ) ;
      p0_enq_chp_state_nxt.cial_arm = ( hcw_enq_info.hcw_cmd == HQM_CMD_ARM ) ;
      p0_enq_chp_state_nxt.to_lsp_release = 1'b0 ;
      p0_enq_chp_state_nxt.to_rop_enq = ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_NEW ) |
                                        ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_NEW_TOK_RET ) |
                                        ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_COMP ) |
                                        ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_COMP_TOK_RET ) |
                                        ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_FRAG ) |
                                        ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_FRAG_TOK_RET ) ;
      p0_enq_chp_state_nxt.to_rop_frag = ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_FRAG ) |
                                         ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_FRAG_TOK_RET ) ; 
      p0_enq_chp_state_nxt.to_rop_cmp = ( hcw_enq_info.hcw_cmd == HQM_CMD_COMP ) |
                                        ( hcw_enq_info.hcw_cmd == HQM_CMD_COMP_TOK_RET ) ;
      p0_enq_chp_state_nxt.to_lsp_tok = ( hcw_enq_info.hcw_cmd == HQM_CMD_BAT_TOK_RET ) |
                                        ( hcw_enq_info.hcw_cmd == HQM_CMD_COMP_TOK_RET ) |
                                        ( hcw_enq_info.hcw_cmd == HQM_CMD_A_COMP_TOK_RET ) |
                                        ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_NEW_TOK_RET ) |
                                        ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_COMP_TOK_RET ) |
                                        ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_FRAG_TOK_RET ) ;
      p0_enq_chp_state_nxt.to_lsp_cmp = ( hcw_enq_info.hcw_cmd == HQM_CMD_COMP ) |
                                        ( hcw_enq_info.hcw_cmd == HQM_CMD_COMP_TOK_RET ) |
                                        ( hcw_enq_info.hcw_cmd == HQM_CMD_A_COMP ) |
                                        ( hcw_enq_info.hcw_cmd == HQM_CMD_A_COMP_TOK_RET ) |
                                        ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_COMP ) |
                                        ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_COMP_TOK_RET ) ;
      p0_enq_chp_state_nxt.qe_is_ldb = hcw_enq_info.qe_is_ldb ;
      p0_enq_chp_state_nxt.no_dec = 1'b0 ; 				// deprecated in V3 along with RELEASE
      p0_enq_chp_state_nxt.cmp_id = hcw_enq_info.cmp_id ;
      p0_enq_chp_state_nxt.pp_parity = hcw_enq_info.pp_parity ;
      p0_enq_chp_state_nxt.pp = hcw_enq_info.pp ;
      p0_enq_chp_state_nxt.qid_parity = hcw_enq_info.qid_parity ;
      p0_enq_chp_state_nxt.qid = hcw_enq_info.qid ;
      p0_enq_chp_state_nxt.vas = { 3'h0 , hcw_enq_info.vas } ;
      p0_enq_chp_state_nxt.hcw_cmd_parity = hcw_enq_info.hcw_cmd_parity ;
      p0_enq_chp_state_nxt.hcw_cmd = hcw_enq_info.hcw_cmd ;
      p0_enq_chp_state_nxt.cq_hcw_ecc = hcw_enq_data.cq_hcw_ecc ;
      p0_enq_chp_state_nxt.cq_hcw = hcw_enq_data.cq_hcw ;
    end
    if ( hcw_enq_pop & ~ hcw_enq_info.pp_is_ldb ) begin
      p0_enq_chp_state_nxt.hcw_src_id = DIR_PP_HCW ;
      p0_enq_chp_state_nxt.hcw_enq_user_parity_error_drop = hcw_enq_info.hcw_enq_user_parity_error_drop ;
      p0_enq_chp_state_nxt.out_of_credit = hcw_enq_info.out_of_credit ;
      p0_enq_chp_state_nxt.to_rop_nop = ( hcw_enq_info.hcw_cmd == HQM_CMD_NOOP ) ;
      p0_enq_chp_state_nxt.cial_arm = ( hcw_enq_info.hcw_cmd == HQM_CMD_ARM ) ;
      p0_enq_chp_state_nxt.to_rop_enq = ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_NEW ) |
                                        ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_NEW_TOK_RET ) ;
      p0_enq_chp_state_nxt.to_lsp_tok = ( hcw_enq_info.hcw_cmd == HQM_CMD_BAT_TOK_RET ) |
                                        ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_NEW_TOK_RET ) ;
      p0_enq_chp_state_nxt.qe_is_ldb = hcw_enq_info.qe_is_ldb ;
      p0_enq_chp_state_nxt.no_dec = 1'b0 ; 				// deprecated in V3 along with RELEASE
      p0_enq_chp_state_nxt.cmp_id = hcw_enq_info.cmp_id ;
      p0_enq_chp_state_nxt.pp_parity = hcw_enq_info.pp_parity ;
      p0_enq_chp_state_nxt.pp = hcw_enq_info.pp ;
      p0_enq_chp_state_nxt.qid_parity = hcw_enq_info.qid_parity ;
      p0_enq_chp_state_nxt.qid = hcw_enq_info.qid ;
      p0_enq_chp_state_nxt.vas = { 3'h0 , hcw_enq_info.vas } ;
      p0_enq_chp_state_nxt.hcw_cmd_parity = hcw_enq_info.hcw_cmd_parity ;
      p0_enq_chp_state_nxt.hcw_cmd = hcw_enq_info.hcw_cmd ;
      p0_enq_chp_state_nxt.cq_hcw_ecc = hcw_enq_data.cq_hcw_ecc ;
      p0_enq_chp_state_nxt.cq_hcw = hcw_enq_data.cq_hcw ;
    end
    if ( hcw_replay_pop & hcw_replay_data.cq_is_ldb ) begin
      p0_enq_chp_state_nxt.hcw_src_id = LDB_REPLAY ;
      p0_enq_chp_state_nxt.to_rop_replay = 1'd1 ;
      p0_enq_chp_state_nxt.qid_parity = ^ { 1'd1 , hcw_replay_data.cq_hcw.msg_info.qid } ;
      p0_enq_chp_state_nxt.qid = { 1'd0, hcw_replay_data.cq_hcw.msg_info.qid } ;
      p0_enq_chp_state_nxt.cq_hcw_ecc = hcw_replay_data.cq_hcw_ecc ;
      p0_enq_chp_state_nxt.cq_hcw = hcw_replay_data.cq_hcw ;
      p0_enq_chp_state_nxt.flid_parity = hcw_replay_data.flid_parity ;
      p0_enq_chp_state_nxt.flid = hcw_replay_data.flid ;
    end
    if ( hcw_replay_pop & ~ hcw_replay_data.cq_is_ldb ) begin
      p0_enq_chp_state_nxt.hcw_src_id = DIR_REPLAY ;
      p0_enq_chp_state_nxt.to_rop_replay = 1'd1 ;
      p0_enq_chp_state_nxt.qid_parity = ^ { 1'd1 , hcw_replay_data.cq_hcw.msg_info.qid } ;
      p0_enq_chp_state_nxt.qid = { 1'd0 , hcw_replay_data.cq_hcw.msg_info.qid } ;
      p0_enq_chp_state_nxt.cq_hcw_ecc = hcw_replay_data.cq_hcw_ecc ;
      p0_enq_chp_state_nxt.cq_hcw = hcw_replay_data.cq_hcw ;
      p0_enq_chp_state_nxt.flid_parity = hcw_replay_data.flid_parity ;
      p0_enq_chp_state_nxt.flid = hcw_replay_data.flid ;
    end

    if ( p0_enq_chp_state_nxt.to_lsp_tok ) begin
      p0_enq_chp_state_nxt.tokens = 16'd0 ;
      if ( ( p0_enq_chp_state_nxt.hcw_cmd == HQM_CMD_BAT_TOK_RET ) | 
         ( p0_enq_chp_state_nxt.hcw_cmd == HQM_CMD_COMP_TOK_RET ) |
         ( p0_enq_chp_state_nxt.hcw_cmd == HQM_CMD_A_COMP_TOK_RET ) ) begin
        p0_enq_chp_state_nxt.tokens = { 6'd0 , p0_enq_chp_state_nxt.cq_hcw.lockid_dir_info_tokens [ 9 : 0 ] } ;
      end
    end
  end

  enqpipe_error_inject_h0_done_set = 1'd0 ;
  enqpipe_error_inject_l0_done_set = 1'd0 ;
  enqpipe_error_inject_h1_done_set = 1'd0 ;
  enqpipe_error_inject_l1_done_set = 1'd0 ;

  p1_enq_chp_state_v_nxt  = p0_enq_chp_state_v_f ;
  p1_enq_chp_state_nxt = p1_enq_chp_state_f ;
  p1_enq_chp_state_nxt.hist_list = '0 ;
  tokens_residue_gen_a = '0 ;
  if ( p0_enq_chp_state_f.to_lsp_tok ) begin
    tokens_residue_gen_a = p0_enq_chp_state_f.tokens + 16'd1 ;
  end
  if ( p0_enq_chp_state_v_f ) begin
    p1_enq_chp_state_nxt    = p0_enq_chp_state_f ;
    p1_enq_chp_state_nxt.tokens = tokens_residue_gen_a ;
    p1_enq_chp_state_nxt.tokens_residue = tokens_residue_gen_r ;
    if ( enqpipe_error_inject_h0 & p0_enq_chp_state_f.hcw_cmd [ 3 ] ) begin
      p1_enq_chp_state_nxt.cq_hcw.dsi_timestamp [ 0 ] = p1_enq_chp_state_nxt.cq_hcw.dsi_timestamp [ 0 ] ^ 1'b1 ;
      enqpipe_error_inject_h0_done_set = 1'b1 ;
    end
    if ( enqpipe_error_inject_l0 & p0_enq_chp_state_f.hcw_cmd [ 3 ] ) begin
      p1_enq_chp_state_nxt.cq_hcw.ptr[ 0 ] = p1_enq_chp_state_nxt.cq_hcw.ptr [ 0 ] ^ 1'b1 ;
      enqpipe_error_inject_l0_done_set = 1'b1 ;
    end
    if ( enqpipe_error_inject_h1 & p0_enq_chp_state_f.hcw_cmd [ 3 ] ) begin
      p1_enq_chp_state_nxt.cq_hcw.dsi_timestamp [ 1 ] = p1_enq_chp_state_nxt.cq_hcw.dsi_timestamp [ 1 ] ^ 1'b1 ;
      enqpipe_error_inject_h1_done_set = 1'b1 ;
    end
    if ( enqpipe_error_inject_l1 & p0_enq_chp_state_f.hcw_cmd [ 3 ] ) begin
      p1_enq_chp_state_nxt.cq_hcw.ptr[ 48 ] = p1_enq_chp_state_nxt.cq_hcw.ptr [ 48 ] ^ 1'b1 ;
      enqpipe_error_inject_l1_done_set = 1'b1 ;
    end
  end

  p2_enq_chp_state_v_nxt  = p1_enq_chp_state_v_f ;
  p2_enq_chp_state_nxt    = p1_enq_chp_state_v_f ? p1_enq_chp_state_f : p2_enq_chp_state_f ;
  p2_enq_chp_state_nxt.hist_list = '0 ;

  p3_enq_chp_state_v_nxt  = p2_enq_chp_state_v_f ;
  p3_enq_chp_state_nxt    = p2_enq_chp_state_v_f ? p2_enq_chp_state_f : p3_enq_chp_state_f ;
  p3_enq_chp_state_nxt.hist_list = '0 ;
  if ( p2_enq_chp_state_v_f & p2_enq_chp_state_f.to_lsp_cmp ) begin
    p3_enq_chp_state_nxt.cmp_id_check = rw_cmp_id_chk_enbl_mem_p2_data_f[0] ;
  end

  p4_enq_chp_state_v_nxt  = p3_enq_chp_state_v_f ;
  p4_enq_chp_state_nxt    = p3_enq_chp_state_v_f ? p3_enq_chp_state_f : p4_enq_chp_state_f ;
  p4_enq_chp_state_nxt.hist_list = '0 ;

  p5_enq_chp_state_v_nxt  = p4_enq_chp_state_v_f ;
  p5_enq_chp_state_nxt    = p4_enq_chp_state_v_f ? p4_enq_chp_state_f : p5_enq_chp_state_f ;
  p5_enq_chp_state_nxt.hist_list = '0 ;
  if ( p4_enq_chp_state_v_f & ( p4_enq_chp_state_f.to_rop_frag | p4_enq_chp_state_f.to_lsp_cmp ) ) begin
    p5_enq_chp_state_nxt.hist_list  = enq_hist_list_pop_data ;
    p5_enq_chp_state_nxt.hist_list_uf  = enq_hist_list_uf ;
    p5_enq_chp_state_nxt.hist_list_residue_error  = enq_hist_list_residue_error ;
  end

  p6_enq_chp_state_v_nxt  = p5_enq_chp_state_v_f ;
  p6_enq_chp_state_nxt    = p5_enq_chp_state_v_f ? p5_enq_chp_state_f : p6_enq_chp_state_f ;
  if ( p5_hist_list_ecc_check ) begin
    p6_enq_chp_state_nxt.hist_list  = p5_hist_list_data_corrected ;
    p6_enq_chp_state_nxt.hid_parity  = p5_hist_list_hid_parity ;
    p6_enq_chp_state_nxt.cmp_id_error = p5_enq_chp_state_f.cmp_id_check & ( p5_hist_list_data_corrected.cmp_id != p5_enq_chp_state_f.cmp_id ) ;
  end

  enq_frag_check_v = p6_enq_chp_state_v_nxt & p6_enq_chp_state_nxt.cq_hcw.pp_is_ldb &
                     ( p6_enq_chp_state_nxt.to_rop_frag | p6_enq_chp_state_nxt.to_lsp_cmp ) ;
  enq_frag_check_pp = p6_enq_chp_state_nxt.pp [ 5 : 0 ] ;
  enq_frag_check_hist_list_qtype = p6_enq_chp_state_nxt.hist_list.hist_list_info.qtype ;
  enq_frag_check_hcw_cmd = p6_enq_chp_state_nxt.hcw_cmd ;
  p6_enq_chp_state_nxt.excess_frag_drop = enq_excess_frag_drop ;

  enq_freelist_pop_v = enq_freelist_pop_v_f ;

  enq_freelist_pop_v_nxt = p6_enq_chp_state_v_nxt & p6_enq_chp_state_nxt.to_rop_enq & 
                           ~ p6_enq_chp_state_nxt.out_of_credit & ~ p6_enq_chp_state_nxt.excess_frag_drop ;

  p7_enq_chp_state_v_nxt  = p6_enq_chp_state_v_f ;
  p7_enq_chp_state_nxt    = p6_enq_chp_state_v_f ? p6_enq_chp_state_f : p7_enq_chp_state_f ;

  if (enq_freelist_pop_v ) begin
    p7_enq_chp_state_nxt.freelist_uf = enq_freelist_pop_error ;
  end

  p8_enq_chp_state_v_nxt  = p7_enq_chp_state_v_f ;
  p8_enq_chp_state_nxt    = p7_enq_chp_state_v_f ? p7_enq_chp_state_f : p8_enq_chp_state_f ;

  p9_enq_chp_state_v_nxt  = p8_enq_chp_state_v_f ;
  p9_enq_chp_state_nxt    = p8_enq_chp_state_v_f ? p8_enq_chp_state_f : p9_enq_chp_state_f ;

  p10_enq_chp_state_v_nxt  = p9_enq_chp_state_v_f ;
  p10_enq_chp_state_nxt    = p9_enq_chp_state_v_f ? p9_enq_chp_state_f : p10_enq_chp_state_f ;

  enqpipe_flid_parity_error_inject_done_set = 1'd0 ;

  if ( p9_enq_chp_state_v_f & p9_enq_chp_state_f.to_rop_enq & ~ p9_enq_chp_state_f.out_of_credit & ~ p9_enq_chp_state_f.freelist_uf ) begin
    p10_enq_chp_state_nxt.freelist_error_mb = enq_freelist_error_mb ;
    p10_enq_chp_state_nxt.freelist_uf = enq_freelist_uf ;
    p10_enq_chp_state_nxt.flid = { 1'd0 , enq_freelist_pop_data.flid } ;
    p10_enq_chp_state_nxt.flid_parity = enq_freelist_pop_data.flid_parity ;
    if ( enqpipe_flid_parity_error_inject ) begin
      p10_enq_chp_state_nxt.flid_parity = enq_freelist_pop_data.flid_parity ^ 1'b1 ;
      enqpipe_flid_parity_error_inject_done_set = 1'd1 ;
    end
  end

  // ----------------------------------------------------------------------------------------------------------------------------------------

  enq_hist_list_fifo_re_sel_nxt = enq_hist_list_fifo_re_sel_f ;
  enq_hist_list_cmd_v = 1'd0 ;
  enq_hist_list_a_cmd_v = 1'd0 ;

  if ( enqpipe_hqm_chp_target_cfg_hist_list_mode [ enq_hist_list_fifo_num_f ] ) begin
    if ( enq_hist_list_cmd_v_f ) begin
      if ( enq_hist_list_fifo_re_sel_f [ enq_hist_list_fifo_num_f ] ) begin
        enq_hist_list_a_cmd_v = 1'b1 ;
      end
      else begin
        enq_hist_list_cmd_v = 1'b1 ;
      end
      if ( enq_hist_list_cmd_pop_f ) begin
        enq_hist_list_fifo_re_sel_nxt [ enq_hist_list_fifo_num_f ] = ~ enq_hist_list_fifo_re_sel_f [ enq_hist_list_fifo_num_f ] ;
      end
    end
  end
  else begin
    enq_hist_list_a_cmd_v = enq_hist_list_a_cmd_v_f ;
    enq_hist_list_cmd_v = enq_hist_list_cmd_v_f ;
  end

  enq_hist_list_cmd = enq_hist_list_cmd_f ;
  enq_hist_list_fifo_num = enq_hist_list_fifo_num_f ;

  enq_hist_list_a_cmd = enq_hist_list_cmd_f ;
  enq_hist_list_a_fifo_num = enq_hist_list_fifo_num_f ;

  enq_hist_list_a_cmd_v_nxt = hcw_enq_pop & hcw_enq_info.pp_is_ldb &
                              ( ( hcw_enq_info.hcw_cmd == HQM_CMD_A_COMP ) |
                                ( hcw_enq_info.hcw_cmd == HQM_CMD_A_COMP_TOK_RET ) ) ;
  enq_hist_list_cmd_v_nxt = hcw_enq_pop & hcw_enq_info.pp_is_ldb &
                            ( ( hcw_enq_info.hcw_cmd == HQM_CMD_COMP ) |
                              ( hcw_enq_info.hcw_cmd == HQM_CMD_COMP_TOK_RET ) |
                              ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_COMP ) |
                              ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_COMP_TOK_RET ) |
                              ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_FRAG ) |
                              ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_FRAG_TOK_RET ) ) ;
  enq_hist_list_cmd_nxt =  ( ( hcw_enq_info.hcw_cmd == HQM_CMD_COMP )  |
                             ( hcw_enq_info.hcw_cmd == HQM_CMD_COMP_TOK_RET ) |
                             ( hcw_enq_info.hcw_cmd == HQM_CMD_A_COMP ) |
                             ( hcw_enq_info.hcw_cmd == HQM_CMD_A_COMP_TOK_RET ) |
                             ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_COMP ) |
                             ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_COMP_TOK_RET ) ) ? HQM_AW_MF_POP :
                           ( ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_FRAG ) |
                             ( hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_FRAG_TOK_RET ) ) ? HQM_AW_MF_READ :
                           HQM_AW_MF_NOOP ;

  enq_hist_list_cmd_pop_nxt =  ( enq_hist_list_cmd_nxt == HQM_AW_MF_POP ) ;

  enq_hist_list_fifo_num_nxt = hcw_enq_info.pp [ 5 : 0 ];

  // ----------------------------------------------------------------------------------------------------------------------------------------
  rw_cmp_id_chk_enbl_mem_p0_v_nxt = enq_hist_list_cmd_v_nxt | enq_hist_list_a_cmd_v_nxt ;
  rw_cmp_id_chk_enbl_mem_p0_rw_nxt = (enq_hist_list_cmd_v_nxt | enq_hist_list_a_cmd_v_nxt) ? HQM_AW_RWPIPE_READ : HQM_AW_RWPIPE_NOOP ;
  rw_cmp_id_chk_enbl_mem_p0_addr_nxt = hcw_enq_info.pp [ 5 : 0 ] ;

  // ----------------------------------------------------------------------------------------------------------------------------------------
  enqpipe_err_rid = { p10_enq_chp_state_f.cq_hcw.pp_is_ldb , p10_enq_chp_state_f.pp [ 6 : 0 ] } ;
  enqpipe_err_enq_to_rop_out_of_credit_drop = 1'd0 ;
  enqpipe_err_enq_to_rop_excess_frag_drop = 1'd0 ;
  enqpipe_err_enq_to_rop_freelist_uf_drop = 1'd0 ;
  enqpipe_err_enq_to_rop_error_drop = 1'd0 ;
  enq_to_rop_error_credit_dealloc = 1'd0 ;
  enq_to_rop_cmp_credit_dealloc = 1'd0 ;
  fifo_chp_rop_hcw_push = 1'd0 ;
  fifo_chp_rop_hcw_push_data.hcw_cmd = p10_enq_chp_state_f.hcw_cmd ;
  fifo_chp_rop_hcw_push_data.hcw_cmd_parity = p10_enq_chp_state_f.hcw_cmd_parity ;

  if ( p10_enq_chp_state_v_f ) begin
    // replay and NOOP cases
    if ( p10_enq_chp_state_f.to_rop_replay | p10_enq_chp_state_f.to_rop_nop ) begin
      // rop_pipe_credit_dealloc upon a fifo_chp_rop_hcw_pop
      fifo_chp_rop_hcw_push = 1'd1 ;
      enqpipe_err_enq_to_rop_error_drop = p10_enq_chp_state_f.to_rop_nop & p10_enq_chp_state_f.hcw_enq_user_parity_error_drop ;
    end
    // NEW,NEW_T,RENQ,RENQ_T,FRAG,FRAG_T cases
    if ( p10_enq_chp_state_f.to_rop_enq ) begin
      if ( p10_enq_chp_state_f.out_of_credit | 
           p10_enq_chp_state_f.excess_frag_drop | 
           p10_enq_chp_state_f.freelist_error_mb | 
           p10_enq_chp_state_f.freelist_uf ) begin
        // error case: don't do fifo_chp_rop_hcw_push and rop_pipe_credit_dealloc here
        enqpipe_err_enq_to_rop_out_of_credit_drop = p10_enq_chp_state_f.out_of_credit ;
        enqpipe_err_enq_to_rop_excess_frag_drop = p10_enq_chp_state_f.excess_frag_drop ;
        enqpipe_err_enq_to_rop_freelist_uf_drop = ~ p10_enq_chp_state_f.out_of_credit & p10_enq_chp_state_f.freelist_uf ;
        enqpipe_err_enq_to_rop_error_drop = 1'd1 ;
        if ( p10_enq_chp_state_f.to_lsp_cmp & 
             ~ p10_enq_chp_state_f.hist_list_uf & ~ p10_enq_chp_state_f.hist_list_residue_error & ~ p10_enq_chp_state_f.cmp_id_error &
             ( p10_enq_chp_state_f.hist_list.hist_list_info.qtype == ORDERED ) ) begin
          fifo_chp_rop_hcw_push = 1'd1 ;
          fifo_chp_rop_hcw_push_data.hcw_cmd.hcw_cmd_dec = HQM_CMD_COMP ;
          if ( p10_enq_chp_state_f.to_lsp_tok ) begin
            fifo_chp_rop_hcw_push_data.hcw_cmd.hcw_cmd_dec = HQM_CMD_COMP_TOK_RET ;
          end 
          fifo_chp_rop_hcw_push_data.hcw_cmd_parity = ^ { 1'b1 , fifo_chp_rop_hcw_push_data.hcw_cmd } ;
        end
        else begin
          enq_to_rop_error_credit_dealloc = 1'd1 ;
        end
      end
      else begin
        // normal case: rop_pipe_credit_dealloc upon a fifo_chp_rop_hcw_pop
        fifo_chp_rop_hcw_push = 1'd1 ;
	if ( p10_enq_chp_state_f.to_lsp_cmp & 
	     ( p10_enq_chp_state_f.hist_list_uf | p10_enq_chp_state_f.hist_list_residue_error | p10_enq_chp_state_f.cmp_id_error ) ) begin
	  fifo_chp_rop_hcw_push_data.hcw_cmd.hcw_cmd_dec = HQM_CMD_ENQ_NEW ;
	  if ( p10_enq_chp_state_f.to_lsp_tok ) begin
	    fifo_chp_rop_hcw_push_data.hcw_cmd.hcw_cmd_dec = HQM_CMD_ENQ_NEW_TOK_RET ;
	  end 
	  fifo_chp_rop_hcw_push_data.hcw_cmd_parity = ^ { 1'b1 , fifo_chp_rop_hcw_push_data.hcw_cmd } ;
        end
        if ( p10_enq_chp_state_f.to_rop_frag ) begin
          if ( p10_enq_chp_state_f.hist_list_uf | ( p10_enq_chp_state_f.hist_list.hist_list_info.qtype != ORDERED ) ) begin
	    fifo_chp_rop_hcw_push_data.hcw_cmd.hcw_cmd_dec = HQM_CMD_ENQ_NEW ;
	    if ( p10_enq_chp_state_f.to_lsp_tok ) begin
	      fifo_chp_rop_hcw_push_data.hcw_cmd.hcw_cmd_dec = HQM_CMD_ENQ_NEW_TOK_RET ;
	    end 
	    fifo_chp_rop_hcw_push_data.hcw_cmd_parity = ^ { 1'b1 , fifo_chp_rop_hcw_push_data.hcw_cmd } ;
          end
        end
      end
    end
    // COMP,COMP_T cases
    if ( p10_enq_chp_state_f.to_rop_cmp ) begin
      if ( ~ p10_enq_chp_state_f.hist_list_uf & ~ p10_enq_chp_state_f.hist_list_residue_error & ~ p10_enq_chp_state_f.cmp_id_error &
           ( p10_enq_chp_state_f.hist_list.hist_list_info.qtype == ORDERED ) ) begin
        // ORDERED completion case: send this to rop and rop_pipe_credit_dealloc upon a fifo_chp_rop_hcw_pop
        fifo_chp_rop_hcw_push = 1'd1 ;
      end
      else begin
        // UNO,ATOMIC completion case: this does not go to rop. rop_pipe_credit_dealloc here
        enq_to_rop_cmp_credit_dealloc = 1'd1 ;
      end
    end
  end

  fifo_chp_rop_hcw_push_data.pp_parity = p10_enq_chp_state_f.pp_parity ;
  fifo_chp_rop_hcw_push_data.parity = ^ { 1'd1
                                        , p10_enq_chp_state_f.no_dec
                                        } ;
  fifo_chp_rop_hcw_push_data.cq_hcw_no_dec = p10_enq_chp_state_f.no_dec ;
  fifo_chp_rop_hcw_push_data.cmd = p10_enq_chp_state_f.to_rop_replay ? CHP_ROP_ENQ_REPLAY_HCW : CHP_ROP_ENQ_NEW_HCW ;
  fifo_chp_rop_hcw_push_data.hist_list_info = p10_enq_chp_state_f.hist_list.hist_list_info ;
  fifo_chp_rop_hcw_push_data.flid_parity = (p10_enq_chp_state_v_f & p10_enq_chp_state_f.to_rop_replay) ? p10_enq_chp_state_f.flid_parity : 
                                           ((enqpipe_err_enq_to_rop_error_drop) ? p10_enq_chp_state_f.flid_parity :
                                           ((p10_enq_chp_state_v_f & p10_enq_chp_state_f.to_rop_enq) ? p10_enq_chp_state_f.flid_parity :
                                           1'd1 ));
  fifo_chp_rop_hcw_push_data.flid = (p10_enq_chp_state_v_f & p10_enq_chp_state_f.to_rop_replay) ? p10_enq_chp_state_f.flid :
                                    ((enqpipe_err_enq_to_rop_error_drop) ? p10_enq_chp_state_f.flid :
                                    ((p10_enq_chp_state_v_f & p10_enq_chp_state_f.to_rop_enq) ? p10_enq_chp_state_f.flid : 
                                    15'd0 ));
  fifo_chp_rop_hcw_push_data.cq_hcw_ecc = p10_enq_chp_state_f.cq_hcw_ecc ;
  fifo_chp_rop_hcw_push_data.cq_hcw = p10_enq_chp_state_f.cq_hcw ;

  // ----------------------------------------------------------------------------------------------------------------------------------------
  // Add cmd into parity so FIFO mem cmd bits are protected, subtract out before going into LSP since unused there
  fifo_chp_lsp_tok_push = p10_enq_chp_state_v_f & ( p10_enq_chp_state_f.to_lsp_tok | p10_enq_chp_state_f.cial_arm ) ;
  fifo_chp_lsp_tok_push_data.cmd = p10_enq_chp_state_f.hcw_cmd.hcw_cmd_dec ;
  fifo_chp_lsp_tok_push_data.cq = p10_enq_chp_state_f.pp ;
  fifo_chp_lsp_tok_push_data.is_ldb = ( p10_enq_chp_state_f.hcw_src_id == LDB_PP_HCW );
  fifo_chp_lsp_tok_push_data.parity = ^ { 1'b0
                                        , p10_enq_chp_state_f.hcw_cmd.hcw_cmd_dec
                                        , p10_enq_chp_state_f.pp_parity 
                                        , ( p10_enq_chp_state_f.hcw_src_id == LDB_PP_HCW ) } ;
  fifo_chp_lsp_tok_push_data.count = p10_enq_chp_state_f.tokens [ 12 : 0 ] ;
  fifo_chp_lsp_tok_push_data.count_residue = p10_enq_chp_state_f.tokens_residue ;

  // ----------------------------------------------------------------------------------------------------------------------------------------
  enqpipe_err_release_qtype_error_drop = 1'd0 ;
  enqpipe_err_enq_to_lsp_cmp_error_drop = 1'd0 ;
  enq_to_lsp_cmp_error_credit_dealloc = 1'd0 ;
  fifo_chp_lsp_ap_cmp_push = 1'd0 ;
  if ( p10_enq_chp_state_v_f ) begin
    if ( p10_enq_chp_state_f.to_lsp_release ) begin
      if ( p10_enq_chp_state_f.qe_is_ldb ) begin
        fifo_chp_lsp_ap_cmp_push = 1'd1 ;
      end
      else begin
        enqpipe_err_release_qtype_error_drop = 1'd1 ;
      end
    end
    if ( p10_enq_chp_state_f.to_lsp_cmp ) begin
      if ( p10_enq_chp_state_f.hist_list_uf ) begin
        // excess completion case
        enqpipe_err_enq_to_lsp_cmp_error_drop = 1'd1 ;
        enq_to_lsp_cmp_error_credit_dealloc = 1'd1 ;
      end
      else begin
        if ( p10_enq_chp_state_f.hist_list_residue_error ) begin
          enqpipe_err_enq_to_lsp_cmp_error_drop = 1'd1 ;
          enq_to_lsp_cmp_error_credit_dealloc = 1'd1 ;
        end
        else begin
          if ( p10_enq_chp_state_f.cmp_id_error ) begin
            enqpipe_err_enq_to_lsp_cmp_error_drop = 1'd1 ;
            enq_to_lsp_cmp_error_credit_dealloc = 1'd1 ;
          end
          else begin
            fifo_chp_lsp_ap_cmp_push = 1'd1 ;
          end
        end
      end
    end
  end

  fifo_chp_lsp_ap_cmp_push_data.qe_wt = p10_enq_chp_state_f.hist_list.qe_wt ;
  fifo_chp_lsp_ap_cmp_push_data.user = { 1'd0 , p10_enq_chp_state_f.no_dec } ;
  fifo_chp_lsp_ap_cmp_push_data.pp = p10_enq_chp_state_f.pp ;
  fifo_chp_lsp_ap_cmp_push_data.pp_parity = p10_enq_chp_state_f.pp_parity ;
  fifo_chp_lsp_ap_cmp_push_data.qid = { 1'b0 , p10_enq_chp_state_f.hist_list.hist_list_info.qid } ;
  fifo_chp_lsp_ap_cmp_push_data.qid_parity = ^ { 1'b1 , p10_enq_chp_state_f.hist_list.hist_list_info.qid } ;
  fifo_chp_lsp_ap_cmp_push_data.hist_list_info = p10_enq_chp_state_f.hist_list.hist_list_info ;
  fifo_chp_lsp_ap_cmp_push_data.hid = p10_enq_chp_state_f.hist_list.hid ;
  fifo_chp_lsp_ap_cmp_push_data.hid_parity = p10_enq_chp_state_f.hid_parity ;

  if ( p10_enq_chp_state_v_f & p10_enq_chp_state_f.to_lsp_release ) begin
    fifo_chp_lsp_ap_cmp_push_data.qe_wt = 2'd0 ;
    fifo_chp_lsp_ap_cmp_push_data.user = 2'd2 ;
    fifo_chp_lsp_ap_cmp_push_data.qid = p10_enq_chp_state_f.qid [ 6 : 0 ] ;
    fifo_chp_lsp_ap_cmp_push_data.qid_parity = p10_enq_chp_state_f.qid_parity ;
  end

  if ( p10_enq_chp_state_v_f & ( ( p10_enq_chp_state_f.hcw_cmd == HQM_CMD_A_COMP ) | ( p10_enq_chp_state_f.hcw_cmd == HQM_CMD_A_COMP_TOK_RET ) ) ) begin
    fifo_chp_lsp_ap_cmp_push_data.user = 2'd3 ;
  end

  enqpipe_hqm_chp_target_cfg_chp_smon_smon_v [ ( 0 * 1 ) +: 1 ]      = fifo_chp_lsp_ap_cmp_push |
                                                                       hcw_replay_pop |
                                                                       hcw_enq_pop |
                                                                       enq_to_rop_error_credit_dealloc |  
                                                                       enq_to_rop_cmp_credit_dealloc |
                                                                       fifo_chp_rop_hcw_push |
                                                                       fifo_chp_lsp_tok_push |
                                                                       fifo_chp_lsp_ap_cmp_push ;
  enqpipe_hqm_chp_target_cfg_chp_smon_smon_comp [ ( 0 * 32 ) +: 32 ] = { 16'd0 
                                                                       , 1'd0 							// 15
                                                                       , 1'd0							// 14
                                                                       , 1'd0							// 13
                                                                       , 1'd0							// 12
                                                                       , hcw_replay_pop						// 11
                                                                       , 1'b0           	 				// 10
                                                                       , hcw_enq_pop						//  9
                                                                       , 1'b0      	 					//  8
                                                                       , 1'b0							//  7
                                                                       , 1'b0							//  6
                                                                       , enq_to_rop_error_credit_dealloc			//  5
                                                                       , enq_to_rop_cmp_credit_dealloc				//  4
                                                                       , 1'b0							//  3
                                                                       , fifo_chp_rop_hcw_push					//  2
                                                                       , fifo_chp_lsp_tok_push					//  1
                                                                       , fifo_chp_lsp_ap_cmp_push				//  0
                                                                       } ;
  enqpipe_hqm_chp_target_cfg_chp_smon_smon_val [ ( 0 * 32 ) +: 32 ]  = 32'd1 ;

end

assign enqpipe_err_hist_list_data_error_sb = p5_hist_list_data_error_sb ;
assign enqpipe_err_hist_list_data_error_mb = p5_hist_list_data_error_mb ;

assign cmp_id_chk_enbl_parity_check_en = p2_enq_chp_state_v_f & p2_enq_chp_state_f.to_lsp_cmp;

hqm_AW_parity_check #(
         .WIDTH (1)
) i_cmp_id_chk_enbl_parity_check (
         .p( rw_cmp_id_chk_enbl_mem_p2_data_f[1] )
        ,.d( rw_cmp_id_chk_enbl_mem_p2_data_f[0] )
        ,.e( cmp_id_chk_enbl_parity_check_en )
        ,.odd( 1'b1 ) // odd
        ,.err( cmp_id_chk_enbl_parity_err )
);

hqm_credit_hist_pipe_ord_frag_check i_hqm_credit_hist_pipe_ord_frag_check (
  .v ( enq_frag_check_v )
, .qtype ( enq_frag_check_hist_list_qtype )
, .pp ( enq_frag_check_pp )
, .cmd ( enq_frag_check_hcw_cmd )
, .drop_hcw ( enq_excess_frag_drop )
, .drop_hcw_and_issue_completion ( drop_hcw_and_issue_completion_nc )
, .hqm_chp_target_cfg_chp_frag_count_reg_load ( hqm_chp_target_cfg_chp_frag_count_reg_load )
, .hqm_chp_target_cfg_chp_frag_count_reg_nxt ( hqm_chp_target_cfg_chp_frag_count_reg_nxt )
, .hqm_chp_target_cfg_chp_frag_count_reg_f ( hqm_chp_target_cfg_chp_frag_count_reg_f )
, .frag_count_res_err ( enqpipe_err_frag_count_residue_error )
) ;

endmodule
