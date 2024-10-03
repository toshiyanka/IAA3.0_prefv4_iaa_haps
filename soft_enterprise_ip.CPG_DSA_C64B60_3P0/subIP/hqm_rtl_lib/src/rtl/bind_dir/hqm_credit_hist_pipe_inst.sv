`ifdef INTEL_INST_ON

module hqm_credit_hist_pipe_inst import hqm_AW_pkg::*, hqm_pkg::*, hqm_core_pkg::*; ();

`ifdef INTEL_INST_ON

  logic [ 31 : 0 ] chp_ingress_flid_ret_rx_sync_stall_count_nxt , chp_ingress_flid_ret_rx_sync_stall_count_f ;

  logic [ 31 : 0 ] chp_cfg_req_up_read_count_nxt , chp_cfg_req_up_read_count_f ;
  logic [ 31 : 0 ] chp_cfg_req_up_write_count_nxt , chp_cfg_req_up_write_count_f ;
  logic [ 31 : 0 ] chp_cfg_req_up_chp_read_count_nxt , chp_cfg_req_up_chp_read_count_f ;
  logic [ 31 : 0 ] chp_cfg_req_up_chp_write_count_nxt , chp_cfg_req_up_chp_write_count_f ;
  logic [ 31 : 0 ] chp_cfg_req_down_read_count_nxt , chp_cfg_req_down_read_count_f ;
  logic [ 31 : 0 ] chp_cfg_req_down_write_count_nxt , chp_cfg_req_down_write_count_f ;
  logic [ 31 : 0 ] chp_cfg_rsp_down_count_nxt , chp_cfg_rsp_down_count_f ;
  logic [ 31 : 0 ] chp_cfg_rsp_down_err_count_nxt , chp_cfg_rsp_down_err_count_f ;
  logic [ 31 : 0 ] unit_cfg_req_write_count_nxt , unit_cfg_req_write_count_f ;
  logic [ 31 : 0 ] unit_cfg_req_read_count_nxt , unit_cfg_req_read_count_f ;

  logic [ 31 : 0 ] hcw_enq_w_req_v_count_nxt , hcw_enq_w_req_v_count_f ;
  logic [ 31 : 0 ] hcw_enq_w_req_qtype_error_count_nxt , hcw_enq_w_req_qtype_error_count_f ;
//logic [ 31 : 0 ] hcw_enq_w_req_ppid_error_count_nxt , hcw_enq_w_req_ppid_error_count_f ;
  logic [ 31 : 0 ] hcw_enq_w_req_stall_count_nxt , hcw_enq_w_req_stall_count_f ;

  logic [ 31 : 0 ] qed_chp_sch_v_count_nxt , qed_chp_sch_v_count_f ;
  logic [ 31 : 0 ] qed_chp_sch_flush_count_nxt , qed_chp_sch_flush_count_f ;
  logic [ 31 : 0 ] qed_chp_sch_stall_count_nxt , qed_chp_sch_stall_count_f ;

  logic [ 31 : 0 ] dqed_chp_sch_v_count_nxt , dqed_chp_sch_v_count_f ;
  logic [ 31 : 0 ] dqed_chp_sch_flush_count_nxt , dqed_chp_sch_flush_count_f ;
  logic [ 31 : 0 ] dqed_chp_sch_stall_count_nxt , dqed_chp_sch_stall_count_f ;

  logic [ 31 : 0 ] aqed_chp_sch_v_count_nxt , aqed_chp_sch_v_count_f ;
  logic [ 31 : 0 ] aqed_chp_sch_flush_count_nxt , aqed_chp_sch_flush_count_f ;
  logic [ 31 : 0 ] aqed_chp_sch_stall_count_nxt , aqed_chp_sch_stall_count_f ;

  logic [ 31 : 0 ] chp_rop_hcw_v_count_nxt , chp_rop_hcw_v_count_f ;
  logic [ 31 : 0 ] chp_rop_hcw_replay_count_nxt , chp_rop_hcw_replay_count_f ;
  logic [ 31 : 0 ] chp_rop_hcw_enq_count_nxt , chp_rop_hcw_enq_count_f ;
  logic [ 31 : 0 ] chp_rop_hcw_enq_comp_count_nxt , chp_rop_hcw_enq_comp_count_f ;
  logic [ 31 : 0 ] chp_rop_hcw_comp_count_nxt , chp_rop_hcw_comp_count_f ;
  logic [ 31 : 0 ] chp_rop_hcw_noop_count_nxt , chp_rop_hcw_noop_count_f ;
  logic [ 31 : 0 ] chp_rop_hcw_stall_count_nxt , chp_rop_hcw_stall_count_f ;

  logic [ 31 : 0 ] chp_lsp_token_v_count_nxt , chp_lsp_token_v_count_f ;
  logic [ 31 : 0 ] chp_lsp_token_count_nxt , chp_lsp_token_count_f ;
  logic [ 31 : 0 ] chp_lsp_token_v_dir_count_nxt , chp_lsp_token_v_dir_count_f ;
  logic [ 31 : 0 ] chp_lsp_token_dir_count_nxt , chp_lsp_token_dir_count_f ;
  logic [ 31 : 0 ] chp_lsp_token_v_ldb_count_nxt , chp_lsp_token_v_ldb_count_f ;
  logic [ 31 : 0 ] chp_lsp_token_ldb_count_nxt , chp_lsp_token_ldb_count_f ;
  logic [ 31 : 0 ] chp_lsp_token_stall_count_nxt , chp_lsp_token_stall_count_f ;
  logic [ 31 : 0 ] chp_lsp_token_dir_cq_count_nxt [ 95 : 0 ] ;
  logic [ 31 : 0 ] chp_lsp_token_dir_cq_count_f [ 95 : 0 ] ;
  logic [ 31 : 0 ] chp_lsp_token_ldb_cq_count_nxt [ 63 : 0 ] ;
  logic [ 31 : 0 ] chp_lsp_token_ldb_cq_count_f [ 63 : 0 ] ;

  logic [ 31 : 0 ] chp_lsp_cmp_v_count_nxt , chp_lsp_cmp_v_count_f ;
  logic [ 31 : 0 ] chp_lsp_cmp_stall_count_nxt , chp_lsp_cmp_stall_count_f ;
  logic [ 31 : 0 ] chp_lsp_cmp_ldb_cq_count_nxt [ 63 : 0 ] ;
  logic [ 31 : 0 ] chp_lsp_cmp_ldb_cq_count_f [ 63 : 0 ] ;
  logic [ 31 : 0 ] chp_lsp_cmp_release_ldb_cq_count_nxt [ 63 : 0 ] ;
  logic [ 31 : 0 ] chp_lsp_cmp_release_ldb_cq_count_f [ 63 : 0 ] ;

  logic [ 31 : 0 ] hcw_sched_w_req_v_count_nxt , hcw_sched_w_req_v_count_f ;
  logic [ 31 : 0 ] hcw_sched_w_req_stall_count_nxt , hcw_sched_w_req_stall_count_f ;

  logic [ 31 : 0 ] hcw_enq_w_req_hcw_cmd_count_nxt [ 15 : 0 ] ;
  logic [ 31 : 0 ] hcw_enq_w_req_hcw_cmd_count_f [ 15 : 0 ] ;
  hcw_cmd_dec_t hcw_enq_w_req_hcw_cmd ;

  logic [ 31 : 0 ] qed_chp_sch_cq_count_nxt [ 63 : 0 ] ;
  logic [ 31 : 0 ] qed_chp_sch_cq_count_f [ 63 : 0 ] ;
  logic [ 31 : 0 ] qed_chp_count_nxt [ 3 : 0 ] ;
  logic [ 31 : 0 ] qed_chp_count_f [ 3 : 0 ] ;

  logic [ 31 : 0 ] dqed_chp_sch_cq_count_nxt [ 95 : 0 ] ;
  logic [ 31 : 0 ] dqed_chp_sch_cq_count_f [ 95 : 0 ] ;
  logic [ 31 : 0 ] dqed_chp_count_nxt [ 3 : 0 ] ;
  logic [ 31 : 0 ] dqed_chp_count_f [ 3 : 0 ] ;

  logic [ 31 : 0 ] aqed_chp_sch_cq_count_nxt [ 63 : 0 ] ;
  logic [ 31 : 0 ] aqed_chp_sch_cq_count_f [ 63 : 0 ] ;

  logic [ 31 : 0 ] hcw_sched_w_req_dir_cq_count_nxt [ 95 : 0 ] ;
  logic [ 31 : 0 ] hcw_sched_w_req_dir_cq_count_f [ 95 : 0 ] ;
  logic [ 31 : 0 ] hcw_sched_w_req_ldb_cq_count_nxt [ 63 : 0 ] ;
  logic [ 31 : 0 ] hcw_sched_w_req_ldb_cq_count_f [ 63 : 0 ] ;

  logic [ 31 : 0 ] chp_rop_pipe_credit_afull_count_nxt , chp_rop_pipe_credit_afull_count_f ;
  logic [ 31 : 0 ] chp_lsp_tok_pipe_credit_afull_count_nxt , chp_lsp_tok_pipe_credit_afull_count_f ;
  logic [ 31 : 0 ] chp_lsp_ap_cmp_pipe_credit_afull_count_nxt , chp_lsp_ap_cmp_pipe_credit_afull_count_f ;
  logic [ 31 : 0 ] chp_outbound_hcw_pipe_credit_afull_count_nxt , chp_outbound_hcw_pipe_credit_afull_count_f ;

  logic rf_dir_cq_wptr_re_f ;
  logic [ ( 7 ) - 1 : 0 ] rf_dir_cq_wptr_raddr_f ;
  logic rf_dir_cq_depth_re_f ;
  logic [ ( 7 ) - 1 : 0 ] rf_dir_cq_depth_raddr_f ;
  logic rf_dir_cq_token_depth_select_re_f ;
  logic [ ( 7 ) - 1 : 0 ] rf_dir_cq_token_depth_select_raddr_f ;

  logic rf_ldb_cq_wptr_re_f ;
  logic [ ( 6 ) - 1 : 0 ] rf_ldb_cq_wptr_raddr_f ;
  logic rf_ldb_cq_depth_re_f ;
  logic [ ( 6 ) - 1 : 0 ] rf_ldb_cq_depth_raddr_f ;
  logic rf_ldb_cq_token_depth_select_re_f ;
  logic [ ( 6 ) - 1 : 0 ] rf_ldb_cq_token_depth_select_raddr_f ;
  logic rf_ord_qid_sn_map_re_f ;
  logic [ ( 5 ) - 1 : 0 ] rf_ord_qid_sn_map_raddr_f ;
  logic rf_ord_qid_sn_re_f ;
  logic [ ( 5 ) - 1 : 0 ] rf_ord_qid_sn_raddr_f ;

  logic rf_hist_list_minmax_re_f ;
  logic [ ( 5 ) - 1 : 0 ] rf_hist_list_minmax_addr_f ;
  logic rf_hist_list_ptr_re_f ;
  logic [ ( 5 ) - 1 : 0 ] rf_hist_list_ptr_raddr_f ;

  logic rf_hist_list_a_minmax_re_f ;
  logic [ ( 5 ) - 1 : 0 ] rf_hist_list_a_minmax_addr_f ;
  logic rf_hist_list_a_ptr_re_f ;
  logic [ ( 5 ) - 1 : 0 ] rf_hist_list_a_ptr_raddr_f ;

  logic rf_dir_cq_intr_thresh_re_f ;
  logic [ ( 7 ) - 1 : 0 ] rf_dir_cq_intr_thresh_raddr_f ;
  logic rf_ldb_cq_intr_thresh_re_f ;
  logic [ ( 6 ) - 1 : 0 ] rf_ldb_cq_intr_thresh_raddr_f ;

  logic sr_freelist_0_re_f ;
  logic [ ( 13 ) - 1 :  0] sr_freelist_0_addr_f ;
  logic sr_freelist_1_re_f ;
  logic [ ( 13 ) - 1 :  0] sr_freelist_1_addr_f ;
  logic sr_freelist_2_re_f ;
  logic [ ( 13 ) - 1 :  0] sr_freelist_2_addr_f ;
  logic sr_freelist_3_re_f ;
  logic [ ( 13 ) - 1 :  0] sr_freelist_3_addr_f ;
  logic sr_freelist_4_re_f ;
  logic [ ( 13 ) - 1 :  0] sr_freelist_4_addr_f ;
  logic sr_freelist_5_re_f ;
  logic [ ( 13 ) - 1 :  0] sr_freelist_5_addr_f ;
  logic sr_freelist_6_re_f ;
  logic [ ( 13 ) - 1 :  0] sr_freelist_6_addr_f ;
  logic sr_freelist_7_re_f ;
  logic [ ( 13 ) - 1 :  0] sr_freelist_7_addr_f ;

  logic sr_hist_list_re_f ;
  logic [ ( 13 ) - 1 :  0] sr_hist_list_addr_f ;

  logic sr_hist_list_a_re_f ;
  logic [ ( 13 ) - 1 :  0] sr_hist_list_a_addr_f ;

  logic [ 31 : 0 ] hist_list_of_count_nxt , hist_list_of_count_f ;
  logic [ 31 : 0 ] hist_list_uf_count_nxt , hist_list_uf_count_f ;
  logic [ 31 : 0 ] hist_list_a_of_count_nxt , hist_list_a_of_count_f ;
  logic [ 31 : 0 ] hist_list_a_uf_count_nxt , hist_list_a_uf_count_f ;
  logic [ 31 : 0 ] freelist_of_count_nxt , freelist_of_count_f ;

  logic [ 31 : 0 ] ing_err_hcw_enq_invalid_hcw_cmd_count_nxt , ing_err_hcw_enq_invalid_hcw_cmd_count_f ;
  logic [ 31 : 0 ] ing_err_hcw_enq_user_parity_error_count_nxt , ing_err_hcw_enq_user_parity_error_count_f ;
  logic [ 31 : 0 ] ing_err_hcw_enq_data_parity_error_count_nxt , ing_err_hcw_enq_data_parity_error_count_f ;
  logic [ 31 : 0 ] ing_err_enq_vas_credit_count_residue_error_count_nxt , ing_err_enq_vas_credit_count_residue_error_count_f ;
  logic [ 31 : 0 ] ing_err_sch_vas_credit_count_residue_err_count_nxt , ing_err_sch_vas_credit_count_residue_err_count_f ;

  logic [ 31 : 0 ] enqpipe_err_hist_list_data_error_sb_count_nxt , enqpipe_err_hist_list_data_error_sb_count_f ;
  logic [ 31 : 0 ] enqpipe_err_hist_list_data_error_mb_count_nxt , enqpipe_err_hist_list_data_error_mb_count_f ;
  logic [ 31 : 0 ] enqpipe_err_freelist_data_error_sb_count_nxt , enqpipe_err_freelist_data_error_sb_count_f ;
  logic [ 31 : 0 ] enqpipe_err_freelist_data_error_mb_count_nxt , enqpipe_err_freelist_data_error_mb_count_f ;
  logic [ 31 : 0 ] enqpipe_err_freelist_uf_count_nxt , enqpipe_err_freelist_uf_count_f ;
  logic [ 31 : 0 ] enqpipe_err_vas_out_of_credit_count_nxt , enqpipe_err_vas_out_of_credit_count_f ;
  logic [ 31 : 0 ] enqpipe_err_excess_frag_count_nxt , enqpipe_err_excess_frag_count_f ;
  logic [ 31 : 0 ] enqpipe_err_enq_to_rop_error_drop_count_nxt , enqpipe_err_enq_to_rop_error_drop_count_f ;
  logic [ 31 : 0 ] enqpipe_err_hist_list_uf_count_nxt , enqpipe_err_hist_list_uf_count_f ;
  logic [ 31 : 0 ] enqpipe_err_hist_list_residue_error_count_nxt , enqpipe_err_hist_list_residue_error_count_f ;
  logic [ 31 : 0 ] enqpipe_err_enq_to_lsp_cmp_error_drop_count_nxt , enqpipe_err_enq_to_lsp_cmp_error_drop_count_f ;
  logic [ 31 : 0 ] enqpipe_err_release_qtype_error_drop_count_nxt , enqpipe_err_release_qtype_error_drop_count_f ;

  logic [ 31 : 0 ] schpipe_err_pipeline_parity_err_count_nxt , schpipe_err_pipeline_parity_err_count_f ;
  logic [ 31 : 0 ] schpipe_err_ldb_cq_hcw_h_ecc_sb_err_count_nxt , schpipe_err_ldb_cq_hcw_h_ecc_sb_err_count_f ;
  logic [ 31 : 0 ] schpipe_err_ldb_cq_hcw_h_ecc_mb_err_count_nxt , schpipe_err_ldb_cq_hcw_h_ecc_mb_err_count_f ;

  logic [ 31 : 0 ] egress_err_pipe_credit_error_count_nxt , egress_err_pipe_credit_error_count_f ;
  logic [ 31 : 0 ] egress_err_parity_ldb_cq_token_depth_select_count_nxt , egress_err_parity_ldb_cq_token_depth_select_count_f ;
  logic [ 31 : 0 ] egress_err_parity_dir_cq_token_depth_select_count_nxt , egress_err_parity_dir_cq_token_depth_select_count_f ;
  logic [ 31 : 0 ] egress_err_parity_ldb_cq_intr_thresh_count_nxt , egress_err_parity_ldb_cq_intr_thresh_count_f ;
  logic [ 31 : 0 ] egress_err_parity_dir_cq_intr_thresh_count_nxt , egress_err_parity_dir_cq_intr_thresh_count_f ;
  logic [ 31 : 0 ] egress_err_residue_ldb_cq_wptr_count_nxt , egress_err_residue_ldb_cq_wptr_count_f ;
  logic [ 31 : 0 ] egress_err_residue_dir_cq_wptr_count_nxt , egress_err_residue_dir_cq_wptr_count_f ;
  logic [ 31 : 0 ] egress_err_residue_ldb_cq_depth_count_nxt , egress_err_residue_ldb_cq_depth_count_f ;
  logic [ 31 : 0 ] egress_err_residue_dir_cq_depth_count_nxt , egress_err_residue_dir_cq_depth_count_f ;
  logic [ 31 : 0 ] egress_err_hcw_ecc_sb_count_nxt , egress_err_hcw_ecc_sb_count_f ;
  logic [ 31 : 0 ] egress_err_hcw_ecc_mb_count_nxt , egress_err_hcw_ecc_mb_count_f ;
  logic [ 31 : 0 ] egress_err_dir_cq_depth_underflow_count_nxt , egress_err_dir_cq_depth_underflow_count_f ;
  logic [ 31 : 0 ] egress_err_ldb_cq_depth_underflow_count_nxt , egress_err_ldb_cq_depth_underflow_count_f ;
  logic [ 31 : 0 ] egress_err_dir_cq_depth_overflow_count_nxt , egress_err_dir_cq_depth_overflow_count_f ;
  logic [ 31 : 0 ] egress_err_ldb_cq_depth_overflow_count_nxt , egress_err_ldb_cq_depth_overflow_count_f ;

  logic [ 31 : 0 ] dir_cq_interrupt_w_req_count_nxt [ 95 : 0 ] ;
  logic [ 31 : 0 ] dir_cq_interrupt_w_req_count_f [ 95 : 0 ] ;
  logic [ 31 : 0 ] ldb_cq_interrupt_w_req_count_nxt [ 63 : 0 ] ;
  logic [ 31 : 0 ] ldb_cq_interrupt_w_req_count_f [ 63 : 0 ] ;
  logic [ 31 : 0 ] dir_cq_cwdi_interrupt_w_req_count_nxt [ 95 : 0 ] ;
  logic [ 31 : 0 ] dir_cq_cwdi_interrupt_w_req_count_f [ 95 : 0 ] ;
  logic [ 31 : 0 ] ldb_cq_cwdi_interrupt_w_req_count_nxt [ 63 : 0 ] ;
  logic [ 31 : 0 ] ldb_cq_cwdi_interrupt_w_req_count_f [ 63 : 0 ] ;

  logic [ 31 : 0 ] int_inf_v_count_nxt , int_inf_v_count_f ;
  logic [ 31 : 0 ] int_cor_v_count_nxt , int_cor_v_count_f ;
  logic [ 31 : 0 ] int_unc_v_count_nxt , int_unc_v_count_f ;

  logic [ 31 : 0 ] chp_alarm_up_count_nxt , chp_alarm_up_count_f ;
  logic [ 31 : 0 ] chp_alarm_down_count_nxt , chp_alarm_down_count_f ;
  logic [ 31 : 0 ] chp_alarm_up_unit_count_nxt [ 15 : 0 ] ;
  logic [ 31 : 0 ] chp_alarm_up_unit_count_f [ 15 : 0 ] ;

  logic [ 31 : 0 ] fifo_chp_rop_hcw_of_count_nxt , fifo_chp_rop_hcw_of_count_f ;
  logic [ 31 : 0 ] fifo_chp_rop_hcw_uf_count_nxt , fifo_chp_rop_hcw_uf_count_f ;
  logic [ 31 : 0 ] fifo_chp_lsp_tok_of_count_nxt , fifo_chp_lsp_tok_of_count_f ;
  logic [ 31 : 0 ] fifo_chp_lsp_tok_uf_count_nxt , fifo_chp_lsp_tok_uf_count_f ;
  logic [ 31 : 0 ] fifo_chp_lsp_ap_cmp_of_count_nxt , fifo_chp_lsp_ap_cmp_of_count_f ;
  logic [ 31 : 0 ] fifo_chp_lsp_ap_cmp_uf_count_nxt , fifo_chp_lsp_ap_cmp_uf_count_f ;
  logic [ 31 : 0 ] fifo_outbound_hcw_of_count_nxt , fifo_outbound_hcw_of_count_f ;
  logic [ 31 : 0 ] fifo_outbound_hcw_uf_count_nxt , fifo_outbound_hcw_uf_count_f ;
  logic [ 31 : 0 ] fifo_qed_to_cq_of_count_nxt , fifo_qed_to_cq_of_count_f ;
  logic [ 31 : 0 ] fifo_qed_to_cq_uf_count_nxt , fifo_qed_to_cq_uf_count_f ;
  logic [ 31 : 0 ] hist_list_residue_error_cfg_count_nxt , hist_list_residue_error_cfg_count_f ;
  logic [ 31 : 0 ] cfg_rx_fifo_status_underflow_count_nxt , cfg_rx_fifo_status_underflow_count_f ;
  logic [ 31 : 0 ] cfg_rx_fifo_status_overflow_count_nxt , cfg_rx_fifo_status_overflow_count_f ;
  logic [ 31 : 0 ] fifo_chp_sys_tx_fifo_mem_of_count_nxt , fifo_chp_sys_tx_fifo_mem_of_count_f ;
  logic [ 31 : 0 ] fifo_chp_sys_tx_fifo_mem_uf_count_nxt , fifo_chp_sys_tx_fifo_mem_uf_count_f ;
  logic [ 31 : 0 ] ing_err_qed_chp_sch_rx_sync_out_cmd_error_count_nxt , ing_err_qed_chp_sch_rx_sync_out_cmd_error_count_f ;

  logic [ ( 16 * 1024 ) - 1 : 0 ] freelist_busy_nxt ;
  logic [ ( 16 * 1024 ) - 1 : 0 ] freelist_busy_f ;
  logic [ ( 15 - 1 ) : 0 ] freelist_busy_count ;

  logic hcw_sched_w_req_parity_err ;
  logic [ 31 : 0 ] hcw_sched_w_req_parity_err_count_nxt , hcw_sched_w_req_parity_err_count_f ;

  logic chp_lsp_cmp_data_parity_err ;
  logic [ 31 : 0 ] chp_lsp_cmp_data_parity_err_count_nxt , chp_lsp_cmp_data_parity_err_count_f ;

  logic [ 31 : 0 ] hcw_enq_w_req_running_clk_count_nxt;
  logic [ 31 : 0 ] hcw_enq_w_req_running_clk_count_f;
  logic [ 31 : 0 ] hcw_enq_w_req_clk_count_nxt;
  logic [ 31 : 0 ] hcw_enq_w_req_clk_count_f;

  logic [ 31 : 0 ] hcw_enq_w_req_enqueue_count_nxt , hcw_enq_w_req_enqueue_count_f ;
  logic [ 31 : 0 ] hcw_enq_w_req_enqueue_running_clk_count_nxt;
  logic [ 31 : 0 ] hcw_enq_w_req_enqueue_running_clk_count_f;
  logic [ 31 : 0 ] hcw_enq_w_req_enqueue_clk_count_nxt;
  logic [ 31 : 0 ] hcw_enq_w_req_enqueue_clk_count_f;

  logic [ 31 : 0 ] chp_rop_hcw_running_clk_count_nxt;
  logic [ 31 : 0 ] chp_rop_hcw_running_clk_count_f;
  logic [ 31 : 0 ] chp_rop_hcw_clk_count_nxt;
  logic [ 31 : 0 ] chp_rop_hcw_clk_count_f;

  logic [ 31 : 0 ] dqed_chp_sch_running_clk_count_nxt;
  logic [ 31 : 0 ] dqed_chp_sch_running_clk_count_f;
  logic [ 31 : 0 ] dqed_chp_sch_clk_count_nxt;
  logic [ 31 : 0 ] dqed_chp_sch_clk_count_f;

  logic [ 31 : 0 ] qed_chp_sch_running_clk_count_nxt;
  logic [ 31 : 0 ] qed_chp_sch_running_clk_count_f;
  logic [ 31 : 0 ] qed_chp_sch_clk_count_nxt;
  logic [ 31 : 0 ] qed_chp_sch_clk_count_f;

  logic [ 31 : 0 ] aqed_chp_sch_running_clk_count_nxt;
  logic [ 31 : 0 ] aqed_chp_sch_running_clk_count_f;
  logic [ 31 : 0 ] aqed_chp_sch_clk_count_nxt;
  logic [ 31 : 0 ] aqed_chp_sch_clk_count_f;

  logic [ 31 : 0 ] hcw_sched_w_req_running_clk_count_nxt;
  logic [ 31 : 0 ] hcw_sched_w_req_running_clk_count_f;
  logic [ 31 : 0 ] hcw_sched_w_req_clk_count_nxt;
  logic [ 31 : 0 ] hcw_sched_w_req_clk_count_f;

  logic [ 31 : 0 ] err_hw_class_01_sticky_f ;
  logic [ 31 : 0 ] err_hw_class_02_sticky_f ;

  logic freelist_push_v;
  chp_flid_t freelist_push_data;

  logic      freelist_pop_v;
  chp_flid_t freelist_pop_data;
  logic      freelist_pop_v_0f;
  logic      freelist_pop_v_1f;
  logic      freelist_pop_v_2f;

  assign freelist_pop_v = hqm_credit_hist_pipe_core.freelist_pop_v;
  assign freelist_push_v = hqm_credit_hist_pipe_core.freelist_push_v;
  assign freelist_push_data = hqm_credit_hist_pipe_core.freelist_push_data;
  assign freelist_pop_data = hqm_credit_hist_pipe_core.freelist_pop_data;

  always_comb begin

    chp_ingress_flid_ret_rx_sync_stall_count_nxt = chp_ingress_flid_ret_rx_sync_stall_count_f ;
    if ( hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_ingress.qed_chp_sch_flid_ret_rx_sync_in_valid & 
         ~ hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_ingress.qed_chp_sch_flid_ret_rx_sync_in_ready ) begin
      chp_ingress_flid_ret_rx_sync_stall_count_nxt = chp_ingress_flid_ret_rx_sync_stall_count_f + 1'd1 ;
    end

    chp_cfg_req_up_read_count_nxt = chp_cfg_req_up_read_count_f ;
    if ( hqm_credit_hist_pipe_core.chp_cfg_req_up_read ) begin
      chp_cfg_req_up_read_count_nxt = chp_cfg_req_up_read_count_f + 1'd1 ;
    end

    chp_cfg_req_up_write_count_nxt = chp_cfg_req_up_write_count_f ;
    if ( hqm_credit_hist_pipe_core.chp_cfg_req_up_write ) begin
      chp_cfg_req_up_write_count_nxt = chp_cfg_req_up_write_count_f + 1'd1 ;
    end

    chp_cfg_req_up_chp_read_count_nxt = chp_cfg_req_up_chp_read_count_f ;
    if ( hqm_credit_hist_pipe_core.chp_cfg_req_up_read ) begin
      chp_cfg_req_up_chp_read_count_nxt = chp_cfg_req_up_chp_read_count_f + ( hqm_credit_hist_pipe_core.chp_cfg_req_up.addr.node == HQM_CHP_CFG_NODE_ID ) ;
    end

    chp_cfg_req_up_chp_write_count_nxt = chp_cfg_req_up_chp_write_count_f ;
    if ( hqm_credit_hist_pipe_core.chp_cfg_req_up_write ) begin
      chp_cfg_req_up_chp_write_count_nxt = chp_cfg_req_up_chp_write_count_f + ( hqm_credit_hist_pipe_core.chp_cfg_req_up.addr.node == HQM_CHP_CFG_NODE_ID ) ;
    end

    chp_cfg_req_down_read_count_nxt = chp_cfg_req_down_read_count_f ;
    if ( hqm_credit_hist_pipe_core.chp_cfg_req_down_read ) begin
      chp_cfg_req_down_read_count_nxt = chp_cfg_req_down_read_count_f + 1'd1 ;
    end

    chp_cfg_req_down_write_count_nxt = chp_cfg_req_down_write_count_f ;
    if ( hqm_credit_hist_pipe_core.chp_cfg_req_down_write ) begin
      chp_cfg_req_down_write_count_nxt = chp_cfg_req_down_write_count_f + 1'd1 ;
    end

    chp_cfg_rsp_down_count_nxt = chp_cfg_rsp_down_count_f ;
    if ( hqm_credit_hist_pipe_core.chp_cfg_rsp_down_ack & ( hqm_credit_hist_pipe_core.chp_cfg_rsp_down.uid == HQM_CHP_CFG_NODE_ID )  ) begin
      chp_cfg_rsp_down_count_nxt = chp_cfg_rsp_down_count_f + 1'd1 ;
    end

    chp_cfg_rsp_down_err_count_nxt = chp_cfg_rsp_down_err_count_f ;
    if ( hqm_credit_hist_pipe_core.chp_cfg_rsp_down_ack & ( hqm_credit_hist_pipe_core.chp_cfg_rsp_down.uid == HQM_CHP_CFG_NODE_ID )  ) begin
      chp_cfg_rsp_down_err_count_nxt = chp_cfg_rsp_down_err_count_f + hqm_credit_hist_pipe_core.chp_cfg_rsp_down.err ;
    end

    unit_cfg_req_write_count_nxt = unit_cfg_req_write_count_f ;
    if ( | hqm_credit_hist_pipe_core.unit_cfg_req_write ) begin
      unit_cfg_req_write_count_nxt = unit_cfg_req_write_count_f + 1'd1 ;
    end

    unit_cfg_req_read_count_nxt = unit_cfg_req_read_count_f ;
    if ( | hqm_credit_hist_pipe_core.unit_cfg_req_read ) begin
      unit_cfg_req_read_count_nxt = unit_cfg_req_read_count_f + 1'd1 ;
    end
  end

  always_comb begin
    hcw_enq_w_req_v_count_nxt = hcw_enq_w_req_v_count_f ;
    if ( hqm_credit_hist_pipe_core.hcw_enq_w_req_valid & hqm_credit_hist_pipe_core.hcw_enq_w_req_ready ) begin
      hcw_enq_w_req_v_count_nxt = hcw_enq_w_req_v_count_f + 1'd1 ;
    end

    hcw_enq_w_req_qtype_error_count_nxt = hcw_enq_w_req_qtype_error_count_f ;
    if ( hqm_credit_hist_pipe_core.hcw_enq_w_req_valid & hqm_credit_hist_pipe_core.hcw_enq_w_req_ready ) begin
      hcw_enq_w_req_qtype_error_count_nxt = hcw_enq_w_req_qtype_error_count_f +
                                            ( hqm_credit_hist_pipe_core.hcw_enq_w_req.user.qe_is_ldb ? hqm_credit_hist_pipe_core.hcw_enq_w_req.data.msg_info.qtype == DIRECT :
                                              hqm_credit_hist_pipe_core.hcw_enq_w_req.data.msg_info.qtype != DIRECT) ;
    end

    hcw_enq_w_req_stall_count_nxt = hcw_enq_w_req_stall_count_f ;
    if ( hqm_credit_hist_pipe_core.hcw_enq_w_req_valid & ~ hqm_credit_hist_pipe_core.hcw_enq_w_req_ready ) begin
      hcw_enq_w_req_stall_count_nxt = hcw_enq_w_req_stall_count_f + 1'd1 ;
    end

    qed_chp_sch_v_count_nxt = qed_chp_sch_v_count_f ;
    if ( hqm_credit_hist_pipe_core.qed_chp_sch_v & hqm_credit_hist_pipe_core.qed_chp_sch_ready & hqm_credit_hist_pipe_core.qed_chp_sch_data.hqm_core_flags.cq_is_ldb) begin
      qed_chp_sch_v_count_nxt = qed_chp_sch_v_count_f + (hqm_credit_hist_pipe_core.qed_chp_sch_data.cmd==QED_CHP_SCH_SCHED) ;
    end

    qed_chp_sch_flush_count_nxt = qed_chp_sch_flush_count_f ;
    if ( hqm_credit_hist_pipe_core.qed_chp_sch_v & hqm_credit_hist_pipe_core.qed_chp_sch_ready & hqm_credit_hist_pipe_core.qed_chp_sch_data.hqm_core_flags.cq_is_ldb) begin
      qed_chp_sch_flush_count_nxt = qed_chp_sch_flush_count_f + hqm_credit_hist_pipe_core.qed_chp_sch_data.hqm_core_flags.ignore_cq_depth ;
    end

    qed_chp_sch_stall_count_nxt = qed_chp_sch_stall_count_f ;
    if ( hqm_credit_hist_pipe_core.qed_chp_sch_v & ~ hqm_credit_hist_pipe_core.qed_chp_sch_ready & hqm_credit_hist_pipe_core.qed_chp_sch_data.hqm_core_flags.cq_is_ldb) begin
      qed_chp_sch_stall_count_nxt = qed_chp_sch_stall_count_f + 1'd1 ;
    end

    dqed_chp_sch_v_count_nxt = dqed_chp_sch_v_count_f ;
    if ( hqm_credit_hist_pipe_core.qed_chp_sch_v & hqm_credit_hist_pipe_core.qed_chp_sch_ready & ~hqm_credit_hist_pipe_core.qed_chp_sch_data.hqm_core_flags.cq_is_ldb) begin
      dqed_chp_sch_v_count_nxt = dqed_chp_sch_v_count_f + (hqm_credit_hist_pipe_core.qed_chp_sch_data.cmd==QED_CHP_SCH_SCHED) ;
    end

    dqed_chp_sch_flush_count_nxt = dqed_chp_sch_flush_count_f ;
    if ( hqm_credit_hist_pipe_core.qed_chp_sch_v & hqm_credit_hist_pipe_core.qed_chp_sch_ready & ~hqm_credit_hist_pipe_core.qed_chp_sch_data.hqm_core_flags.cq_is_ldb) begin
      dqed_chp_sch_flush_count_nxt = dqed_chp_sch_flush_count_f + hqm_credit_hist_pipe_core.qed_chp_sch_data.hqm_core_flags.ignore_cq_depth ;
    end

    dqed_chp_sch_stall_count_nxt = dqed_chp_sch_stall_count_f ;
    if ( hqm_credit_hist_pipe_core.qed_chp_sch_v & ~ hqm_credit_hist_pipe_core.qed_chp_sch_ready & ~hqm_credit_hist_pipe_core.qed_chp_sch_data.hqm_core_flags.cq_is_ldb) begin
      dqed_chp_sch_stall_count_nxt = dqed_chp_sch_stall_count_f + 1'd1 ;
    end

    aqed_chp_sch_v_count_nxt = aqed_chp_sch_v_count_f ;
    if ( hqm_credit_hist_pipe_core.aqed_chp_sch_v & hqm_credit_hist_pipe_core.aqed_chp_sch_ready ) begin
      aqed_chp_sch_v_count_nxt = aqed_chp_sch_v_count_f + 1'd1 ;
    end

    aqed_chp_sch_flush_count_nxt = aqed_chp_sch_flush_count_f ;
    if ( hqm_credit_hist_pipe_core.aqed_chp_sch_v & hqm_credit_hist_pipe_core.aqed_chp_sch_ready ) begin
      aqed_chp_sch_flush_count_nxt = aqed_chp_sch_flush_count_f + hqm_credit_hist_pipe_core.aqed_chp_sch_data.hqm_core_flags.ignore_cq_depth ;
    end

    aqed_chp_sch_stall_count_nxt = aqed_chp_sch_stall_count_f ;
    if ( hqm_credit_hist_pipe_core.aqed_chp_sch_v & ~ hqm_credit_hist_pipe_core.aqed_chp_sch_ready ) begin
      aqed_chp_sch_stall_count_nxt = aqed_chp_sch_stall_count_f + 1'd1 ;
    end

    chp_rop_hcw_v_count_nxt = chp_rop_hcw_v_count_f ;
    if ( hqm_credit_hist_pipe_core.chp_rop_hcw_v & hqm_credit_hist_pipe_core.chp_rop_hcw_ready ) begin
      chp_rop_hcw_v_count_nxt = chp_rop_hcw_v_count_f + 1'd1 ;
    end

    chp_rop_hcw_replay_count_nxt = chp_rop_hcw_replay_count_f ;
    if ( hqm_credit_hist_pipe_core.chp_rop_hcw_v & hqm_credit_hist_pipe_core.chp_rop_hcw_ready ) begin
      if ( hqm_credit_hist_pipe_core.chp_rop_hcw_data.cmd == CHP_ROP_ENQ_REPLAY_HCW ) begin
        chp_rop_hcw_replay_count_nxt = chp_rop_hcw_replay_count_f + 1'd1 ;
      end
    end

    chp_rop_hcw_enq_count_nxt = chp_rop_hcw_enq_count_f ;
    if ( hqm_credit_hist_pipe_core.chp_rop_hcw_v & hqm_credit_hist_pipe_core.chp_rop_hcw_ready ) begin
      if ( ( hqm_credit_hist_pipe_core.chp_rop_hcw_data.cmd == CHP_ROP_ENQ_NEW_HCW ) & 
           ( ( hqm_credit_hist_pipe_core.chp_rop_hcw_data.hcw_cmd.hcw_cmd_dec == HQM_CMD_ENQ_NEW ) |
             ( hqm_credit_hist_pipe_core.chp_rop_hcw_data.hcw_cmd.hcw_cmd_dec == HQM_CMD_ENQ_NEW_TOK_RET ) |
             ( hqm_credit_hist_pipe_core.chp_rop_hcw_data.hcw_cmd.hcw_cmd_dec == HQM_CMD_ENQ_FRAG ) |
             ( hqm_credit_hist_pipe_core.chp_rop_hcw_data.hcw_cmd.hcw_cmd_dec == HQM_CMD_ENQ_FRAG_TOK_RET ) ) ) begin
        chp_rop_hcw_enq_count_nxt = chp_rop_hcw_enq_count_f + 1'd1 ;
      end
    end

    chp_rop_hcw_enq_comp_count_nxt = chp_rop_hcw_enq_comp_count_f ;
    if ( hqm_credit_hist_pipe_core.chp_rop_hcw_v & hqm_credit_hist_pipe_core.chp_rop_hcw_ready ) begin
      if ( ( hqm_credit_hist_pipe_core.chp_rop_hcw_data.cmd == CHP_ROP_ENQ_NEW_HCW ) & 
           ( ( hqm_credit_hist_pipe_core.chp_rop_hcw_data.hcw_cmd.hcw_cmd_dec == HQM_CMD_ENQ_COMP ) |
             ( hqm_credit_hist_pipe_core.chp_rop_hcw_data.hcw_cmd.hcw_cmd_dec == HQM_CMD_ENQ_COMP_TOK_RET ) ) ) begin
        chp_rop_hcw_enq_comp_count_nxt = chp_rop_hcw_enq_comp_count_f + 1'd1 ;
      end
    end

    chp_rop_hcw_comp_count_nxt = chp_rop_hcw_comp_count_f ;
    if ( hqm_credit_hist_pipe_core.chp_rop_hcw_v & hqm_credit_hist_pipe_core.chp_rop_hcw_ready ) begin
      if ( ( hqm_credit_hist_pipe_core.chp_rop_hcw_data.cmd == CHP_ROP_ENQ_NEW_HCW ) & 
           ( ( hqm_credit_hist_pipe_core.chp_rop_hcw_data.hcw_cmd.hcw_cmd_dec == HQM_CMD_COMP ) |
             ( hqm_credit_hist_pipe_core.chp_rop_hcw_data.hcw_cmd.hcw_cmd_dec == HQM_CMD_COMP_TOK_RET ) ) ) begin
        chp_rop_hcw_comp_count_nxt = chp_rop_hcw_comp_count_f + 1'd1 ;
      end
    end

    chp_rop_hcw_noop_count_nxt = chp_rop_hcw_noop_count_f ;
    if ( hqm_credit_hist_pipe_core.chp_rop_hcw_v & hqm_credit_hist_pipe_core.chp_rop_hcw_ready ) begin
      if ( ( hqm_credit_hist_pipe_core.chp_rop_hcw_data.cmd == CHP_ROP_ENQ_NEW_HCW ) & 
           ( hqm_credit_hist_pipe_core.chp_rop_hcw_data.hcw_cmd.hcw_cmd_dec == HQM_CMD_NOOP ) ) begin
        chp_rop_hcw_noop_count_nxt = chp_rop_hcw_noop_count_f + 1'd1 ;
      end
    end

    chp_rop_hcw_stall_count_nxt = chp_rop_hcw_stall_count_f ;
    if ( hqm_credit_hist_pipe_core.chp_rop_hcw_v & ~ hqm_credit_hist_pipe_core.chp_rop_hcw_ready ) begin
      chp_rop_hcw_stall_count_nxt = chp_rop_hcw_stall_count_f + 1'd1 ;
    end

    chp_lsp_token_v_count_nxt = chp_lsp_token_v_count_f ;
    if ( hqm_credit_hist_pipe_core.chp_lsp_token_v & hqm_credit_hist_pipe_core.chp_lsp_token_ready ) begin
      chp_lsp_token_v_count_nxt = chp_lsp_token_v_count_f + 1'd1 ;
    end

    chp_lsp_token_count_nxt = chp_lsp_token_count_f ;
    if ( hqm_credit_hist_pipe_core.chp_lsp_token_v & hqm_credit_hist_pipe_core.chp_lsp_token_ready ) begin
      chp_lsp_token_count_nxt = chp_lsp_token_count_f + ( hqm_credit_hist_pipe_core.chp_lsp_token_data.count ) ;
    end

    chp_lsp_token_v_dir_count_nxt = chp_lsp_token_v_dir_count_f ;
    if ( hqm_credit_hist_pipe_core.chp_lsp_token_v & hqm_credit_hist_pipe_core.chp_lsp_token_ready ) begin
      chp_lsp_token_v_dir_count_nxt = chp_lsp_token_v_dir_count_f + ( hqm_credit_hist_pipe_core.chp_lsp_token_data.is_ldb == 1'd0 ) ;
    end

    chp_lsp_token_dir_count_nxt = chp_lsp_token_dir_count_f ;
    if ( hqm_credit_hist_pipe_core.chp_lsp_token_v & hqm_credit_hist_pipe_core.chp_lsp_token_ready & ~ hqm_credit_hist_pipe_core.chp_lsp_token_data.is_ldb ) begin
      chp_lsp_token_dir_count_nxt = chp_lsp_token_dir_count_f + ( hqm_credit_hist_pipe_core.chp_lsp_token_data.count ) ;
    end

    chp_lsp_token_v_ldb_count_nxt = chp_lsp_token_v_ldb_count_f ;
    if ( hqm_credit_hist_pipe_core.chp_lsp_token_v & hqm_credit_hist_pipe_core.chp_lsp_token_ready ) begin
      chp_lsp_token_v_ldb_count_nxt = chp_lsp_token_v_ldb_count_f + ( hqm_credit_hist_pipe_core.chp_lsp_token_data.is_ldb == 1'd1 ) ;
    end

    chp_lsp_token_ldb_count_nxt = chp_lsp_token_ldb_count_f ;
    if ( hqm_credit_hist_pipe_core.chp_lsp_token_v & hqm_credit_hist_pipe_core.chp_lsp_token_ready & hqm_credit_hist_pipe_core.chp_lsp_token_data.is_ldb ) begin
      chp_lsp_token_ldb_count_nxt = chp_lsp_token_ldb_count_f + ( hqm_credit_hist_pipe_core.chp_lsp_token_data.count ) ;
    end

    chp_lsp_token_stall_count_nxt = chp_lsp_token_stall_count_f ;
    if ( hqm_credit_hist_pipe_core.chp_lsp_token_v & ~ hqm_credit_hist_pipe_core.chp_lsp_token_ready ) begin
      chp_lsp_token_stall_count_nxt = chp_lsp_token_stall_count_f + 1'd1 ;
    end

    chp_lsp_cmp_v_count_nxt = chp_lsp_cmp_v_count_f ;
    if ( hqm_credit_hist_pipe_core.chp_lsp_cmp_v & hqm_credit_hist_pipe_core.chp_lsp_cmp_ready ) begin
      chp_lsp_cmp_v_count_nxt = chp_lsp_cmp_v_count_f + 1'd1 ;
    end

    chp_lsp_cmp_stall_count_nxt = chp_lsp_cmp_stall_count_f ;
    if ( hqm_credit_hist_pipe_core.chp_lsp_cmp_v & ~ hqm_credit_hist_pipe_core.chp_lsp_cmp_ready ) begin
      chp_lsp_cmp_stall_count_nxt = chp_lsp_cmp_stall_count_f + 1'd1 ;
    end

    hcw_sched_w_req_v_count_nxt = hcw_sched_w_req_v_count_f ;
    if ( hqm_credit_hist_pipe_core.hcw_sched_w_req_valid & hqm_credit_hist_pipe_core.hcw_sched_w_req_ready ) begin
      hcw_sched_w_req_v_count_nxt = hcw_sched_w_req_v_count_f + 1'd1 ;
    end

    hcw_sched_w_req_stall_count_nxt = hcw_sched_w_req_stall_count_f ;
    if ( hqm_credit_hist_pipe_core.hcw_sched_w_req_valid & ~ hqm_credit_hist_pipe_core.hcw_sched_w_req_ready ) begin
      hcw_sched_w_req_stall_count_nxt = hcw_sched_w_req_stall_count_f + 1'd1 ;
    end

    chp_rop_pipe_credit_afull_count_nxt = chp_rop_pipe_credit_afull_count_f ;
    if ( hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_arbiter.chp_rop_pipe_credit_afull &
         ( ( hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_arbiter.hcw_enq_valid &
             ~ hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_arbiter.hcw_enq_info.pp_is_ldb &
             ( ( hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_arbiter.hcw_enq_info.hcw_cmd == HQM_CMD_NOOP ) |
               ( hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_arbiter.hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_NEW ) |
               ( hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_arbiter.hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_NEW_TOK_RET ) ) ) |
           ( hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_arbiter.hcw_enq_valid &
             hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_arbiter.hcw_enq_info.pp_is_ldb &
             ( ( hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_arbiter.hcw_enq_info.hcw_cmd == HQM_CMD_NOOP ) |
               ( hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_arbiter.hcw_enq_info.hcw_cmd == HQM_CMD_COMP ) |
               ( hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_arbiter.hcw_enq_info.hcw_cmd == HQM_CMD_COMP_TOK_RET ) |
               ( hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_arbiter.hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_NEW ) |
               ( hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_arbiter.hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_FRAG ) |
               ( hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_arbiter.hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_NEW_TOK_RET ) | 
               ( hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_arbiter.hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_FRAG_TOK_RET ) | 
               ( hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_arbiter.hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_COMP ) | 
               ( hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_arbiter.hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_COMP_TOK_RET ) ) ) ) 
       ) begin
      chp_rop_pipe_credit_afull_count_nxt = chp_rop_pipe_credit_afull_count_f + 1'd1;
    end

    chp_lsp_tok_pipe_credit_afull_count_nxt = chp_lsp_tok_pipe_credit_afull_count_f ;
    if ( hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_arbiter.chp_lsp_tok_pipe_credit_afull &
         ( ( hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_arbiter.hcw_enq_valid &
             ~ hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_arbiter.hcw_enq_info.pp_is_ldb &
             ( ( hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_arbiter.hcw_enq_info.hcw_cmd == HQM_CMD_BAT_TOK_RET ) |
               ( hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_arbiter.hcw_enq_info.hcw_cmd == HQM_CMD_ARM ) |
               ( hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_arbiter.hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_NEW_TOK_RET ) ) ) |
           ( hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_arbiter.hcw_enq_valid &
             hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_arbiter.hcw_enq_info.pp_is_ldb &
             ( ( hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_arbiter.hcw_enq_info.hcw_cmd == HQM_CMD_BAT_TOK_RET ) |
               ( hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_arbiter.hcw_enq_info.hcw_cmd == HQM_CMD_COMP_TOK_RET ) |
               ( hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_arbiter.hcw_enq_info.hcw_cmd == HQM_CMD_ARM ) |
               ( hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_arbiter.hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_NEW_TOK_RET ) |
               ( hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_arbiter.hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_FRAG_TOK_RET ) |
               ( hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_arbiter.hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_COMP_TOK_RET ) ) ) )
      ) begin
      chp_lsp_tok_pipe_credit_afull_count_nxt = chp_lsp_tok_pipe_credit_afull_count_f + 1'd1;
    end

    chp_lsp_ap_cmp_pipe_credit_afull_count_nxt = chp_lsp_ap_cmp_pipe_credit_afull_count_f ;
    if ( hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_arbiter.chp_lsp_ap_cmp_pipe_credit_afull &
         ( ( hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_arbiter.hcw_enq_valid &
             hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_arbiter.hcw_enq_info.pp_is_ldb &
             ( ( hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_arbiter.hcw_enq_info.hcw_cmd == HQM_CMD_COMP ) |
               ( hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_arbiter.hcw_enq_info.hcw_cmd == HQM_CMD_COMP_TOK_RET ) |
               ( hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_arbiter.hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_COMP ) |
               ( hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_arbiter.hcw_enq_info.hcw_cmd == HQM_CMD_ENQ_COMP_TOK_RET ) ) ) |
           ( hqm_credit_hist_pipe_core.qed_sch_valid & hqm_credit_hist_pipe_core.qed_sch_data.qed_chp_sch_data.hqm_core_flags.ignore_cq_depth ) | 
           ( hqm_credit_hist_pipe_core.aqed_sch_valid & hqm_credit_hist_pipe_core.aqed_sch_data.hqm_core_flags.ignore_cq_depth ) ) 
      ) begin
      chp_lsp_ap_cmp_pipe_credit_afull_count_nxt = chp_lsp_ap_cmp_pipe_credit_afull_count_f + 1'd1;
    end

    chp_outbound_hcw_pipe_credit_afull_count_nxt = chp_outbound_hcw_pipe_credit_afull_count_f ;
    if ( hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_arbiter.chp_outbound_hcw_pipe_credit_afull &
         ( ( hqm_credit_hist_pipe_core.qed_sch_valid & ~ hqm_credit_hist_pipe_core.qed_sch_data.qed_chp_sch_data.hqm_core_flags.ignore_cq_depth ) | 
           ( hqm_credit_hist_pipe_core.aqed_sch_valid & ~ hqm_credit_hist_pipe_core.aqed_sch_data.hqm_core_flags.ignore_cq_depth ) ) 
       ) begin
      chp_outbound_hcw_pipe_credit_afull_count_nxt = chp_outbound_hcw_pipe_credit_afull_count_f + 1'd1;
    end

    hist_list_of_count_nxt = hist_list_of_count_f ;
    if ( hqm_credit_hist_pipe_core.hist_list_of ) begin
      hist_list_of_count_nxt = hist_list_of_count_f + 1'd1 ;
    end

    hist_list_uf_count_nxt = hist_list_uf_count_f ;
    if ( hqm_credit_hist_pipe_core.hist_list_uf ) begin
      hist_list_uf_count_nxt = hist_list_uf_count_f + 1'd1 ;
    end

    hist_list_a_of_count_nxt = hist_list_a_of_count_f ;
    if ( hqm_credit_hist_pipe_core.hist_list_a_of ) begin
      hist_list_a_of_count_nxt = hist_list_a_of_count_f + 1'd1 ;
    end

    hist_list_a_uf_count_nxt = hist_list_a_uf_count_f ;
    if ( hqm_credit_hist_pipe_core.hist_list_a_uf ) begin
      hist_list_a_uf_count_nxt = hist_list_a_uf_count_f + 1'd1 ;
    end

    freelist_of_count_nxt = freelist_of_count_f ;
    if ( hqm_credit_hist_pipe_core.freelist_of ) begin
      freelist_of_count_nxt = freelist_of_count_f + 1'd1 ;
    end

    ing_err_hcw_enq_invalid_hcw_cmd_count_nxt = ing_err_hcw_enq_invalid_hcw_cmd_count_f ;
    if ( hqm_credit_hist_pipe_core.ing_err_hcw_enq_invalid_hcw_cmd ) begin
      ing_err_hcw_enq_invalid_hcw_cmd_count_nxt = ing_err_hcw_enq_invalid_hcw_cmd_count_f + 1'd1 ;
    end

    ing_err_hcw_enq_user_parity_error_count_nxt = ing_err_hcw_enq_user_parity_error_count_f ;
    if ( hqm_credit_hist_pipe_core.ing_err_hcw_enq_user_parity_error ) begin
      ing_err_hcw_enq_user_parity_error_count_nxt = ing_err_hcw_enq_user_parity_error_count_f + 1'd1 ;
    end

    ing_err_hcw_enq_data_parity_error_count_nxt = ing_err_hcw_enq_data_parity_error_count_f ;
    if ( hqm_credit_hist_pipe_core.ing_err_hcw_enq_data_parity_error ) begin
      ing_err_hcw_enq_data_parity_error_count_nxt = ing_err_hcw_enq_data_parity_error_count_f + 1'd1 ;
    end

    ing_err_enq_vas_credit_count_residue_error_count_nxt = ing_err_enq_vas_credit_count_residue_error_count_f ;
    if ( hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_ingress.ing_err_enq_vas_credit_count_residue_error ) begin
      ing_err_enq_vas_credit_count_residue_error_count_nxt = ing_err_enq_vas_credit_count_residue_error_count_f + 1'd1 ;

    ing_err_sch_vas_credit_count_residue_err_count_nxt = ing_err_sch_vas_credit_count_residue_err_count_f ;
    if ( hqm_credit_hist_pipe_core.ing_err_sch_vas_credit_count_residue_error ) begin
      ing_err_sch_vas_credit_count_residue_err_count_nxt = ing_err_sch_vas_credit_count_residue_err_count_f + 1'd1 ;
    end

    schpipe_err_pipeline_parity_err_count_nxt = schpipe_err_pipeline_parity_err_count_f ;
    end

    enqpipe_err_hist_list_data_error_sb_count_nxt = enqpipe_err_hist_list_data_error_sb_count_f ;
    if ( hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_enqpipe.enqpipe_err_hist_list_data_error_sb ) begin
      enqpipe_err_hist_list_data_error_sb_count_nxt = enqpipe_err_hist_list_data_error_sb_count_f + 1'd1 ;
    end

    enqpipe_err_hist_list_data_error_mb_count_nxt = enqpipe_err_hist_list_data_error_mb_count_f ;
    if ( hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_enqpipe.enqpipe_err_hist_list_data_error_mb ) begin
      enqpipe_err_hist_list_data_error_mb_count_nxt = enqpipe_err_hist_list_data_error_mb_count_f + 1'd1 ;
    end

    enqpipe_err_freelist_data_error_sb_count_nxt = enqpipe_err_freelist_data_error_sb_count_f ;
    if ( hqm_credit_hist_pipe_core.freelist_eccerr_sb ) begin
      enqpipe_err_freelist_data_error_sb_count_nxt = enqpipe_err_freelist_data_error_sb_count_f + 1'd1 ;
    end

    enqpipe_err_freelist_data_error_mb_count_nxt = enqpipe_err_freelist_data_error_mb_count_f ;
    if ( hqm_credit_hist_pipe_core.enq_freelist_error_mb ) begin
      enqpipe_err_freelist_data_error_mb_count_nxt = enqpipe_err_freelist_data_error_mb_count_f + 1'd1 ;
    end

    enqpipe_err_freelist_uf_count_nxt = enqpipe_err_freelist_uf_count_f ;
    if ( hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_enqpipe.enqpipe_err_enq_to_rop_error_drop ) begin
      enqpipe_err_freelist_uf_count_nxt = enqpipe_err_freelist_uf_count_f + 
                                          hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_enqpipe.p10_enq_chp_state_f.freelist_uf ;
    end

    enqpipe_err_enq_to_rop_error_drop_count_nxt = enqpipe_err_enq_to_rop_error_drop_count_f ;
    if ( hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_enqpipe.enqpipe_err_enq_to_rop_error_drop ) begin
      enqpipe_err_enq_to_rop_error_drop_count_nxt = enqpipe_err_enq_to_rop_error_drop_count_f + 1'd1 ;
    end

    enqpipe_err_vas_out_of_credit_count_nxt = enqpipe_err_vas_out_of_credit_count_f ;
    if ( hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_enqpipe.enqpipe_err_enq_to_rop_error_drop ) begin
      enqpipe_err_vas_out_of_credit_count_nxt = enqpipe_err_vas_out_of_credit_count_f + 
                                                hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_enqpipe.p10_enq_chp_state_f.out_of_credit ;
    end

    enqpipe_err_excess_frag_count_nxt = enqpipe_err_excess_frag_count_f ;
    if ( hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_enqpipe.enqpipe_err_enq_to_rop_error_drop ) begin
      enqpipe_err_excess_frag_count_nxt = enqpipe_err_excess_frag_count_f + 
                                          hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_enqpipe.p10_enq_chp_state_f.excess_frag_drop ;
    end

    enqpipe_err_hist_list_uf_count_nxt = enqpipe_err_hist_list_uf_count_f ;
    if ( hqm_credit_hist_pipe_core.enqpipe_err_enq_to_lsp_cmp_error_drop ) begin
      enqpipe_err_hist_list_uf_count_nxt = enqpipe_err_hist_list_uf_count_f +
                                           hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_enqpipe.p10_enq_chp_state_f.hist_list_uf ;
    end

    enqpipe_err_hist_list_residue_error_count_nxt = enqpipe_err_hist_list_residue_error_count_f ;
    if ( hqm_credit_hist_pipe_core.enqpipe_err_enq_to_lsp_cmp_error_drop ) begin
      enqpipe_err_hist_list_residue_error_count_nxt = enqpipe_err_hist_list_residue_error_count_f +
                                                      hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_enqpipe.p10_enq_chp_state_f.hist_list_residue_error ;
    end

    enqpipe_err_enq_to_lsp_cmp_error_drop_count_nxt = enqpipe_err_enq_to_lsp_cmp_error_drop_count_f ;
    if ( hqm_credit_hist_pipe_core.enqpipe_err_enq_to_lsp_cmp_error_drop ) begin
      enqpipe_err_enq_to_lsp_cmp_error_drop_count_nxt = enqpipe_err_enq_to_lsp_cmp_error_drop_count_f + 1'd1 ;
    end

    enqpipe_err_release_qtype_error_drop_count_nxt = enqpipe_err_release_qtype_error_drop_count_f ;
    if ( hqm_credit_hist_pipe_core.enqpipe_err_release_qtype_error_drop ) begin
      enqpipe_err_release_qtype_error_drop_count_nxt = enqpipe_err_release_qtype_error_drop_count_f + 1'd1 ;
    end

    if ( hqm_credit_hist_pipe_core.schpipe_err_pipeline_parity_err ) begin
      schpipe_err_pipeline_parity_err_count_nxt = schpipe_err_pipeline_parity_err_count_f + 1'd1 ;
    end

    if ( hqm_credit_hist_pipe_core.schpipe_err_ldb_cq_hcw_h_ecc_sb ) begin
      schpipe_err_ldb_cq_hcw_h_ecc_sb_err_count_nxt = schpipe_err_ldb_cq_hcw_h_ecc_sb_err_count_f + 1'd1 ;
    end

    if ( hqm_credit_hist_pipe_core.schpipe_err_ldb_cq_hcw_h_ecc_mb ) begin
      schpipe_err_ldb_cq_hcw_h_ecc_mb_err_count_nxt = schpipe_err_ldb_cq_hcw_h_ecc_mb_err_count_f + 1'd1 ;
    end

    egress_err_pipe_credit_error_count_nxt = egress_err_pipe_credit_error_count_f ;
    if ( hqm_credit_hist_pipe_core.egress_err_pipe_credit_error ) begin
      egress_err_pipe_credit_error_count_nxt = egress_err_pipe_credit_error_count_f + 1'd1 ;
    end

    egress_err_parity_ldb_cq_token_depth_select_count_nxt = egress_err_parity_ldb_cq_token_depth_select_count_f ;
    if ( hqm_credit_hist_pipe_core.egress_err_parity_ldb_cq_token_depth_select ) begin
      egress_err_parity_ldb_cq_token_depth_select_count_nxt = egress_err_parity_ldb_cq_token_depth_select_count_f + 1'd1 ;
    end

    egress_err_parity_dir_cq_token_depth_select_count_nxt = egress_err_parity_dir_cq_token_depth_select_count_f ;
    if ( hqm_credit_hist_pipe_core.egress_err_parity_dir_cq_token_depth_select ) begin
      egress_err_parity_dir_cq_token_depth_select_count_nxt = egress_err_parity_dir_cq_token_depth_select_count_f + 1'd1 ;
    end

    egress_err_parity_ldb_cq_intr_thresh_count_nxt = egress_err_parity_ldb_cq_intr_thresh_count_f ;
    if ( hqm_credit_hist_pipe_core.egress_err_parity_ldb_cq_intr_thresh ) begin
      egress_err_parity_ldb_cq_intr_thresh_count_nxt = egress_err_parity_ldb_cq_intr_thresh_count_f + 1'd1 ;
    end

    egress_err_parity_dir_cq_intr_thresh_count_nxt = egress_err_parity_dir_cq_intr_thresh_count_f ;
    if ( hqm_credit_hist_pipe_core.egress_err_parity_dir_cq_intr_thresh ) begin
      egress_err_parity_dir_cq_intr_thresh_count_nxt = egress_err_parity_dir_cq_intr_thresh_count_f + 1'd1 ;
    end

    egress_err_residue_ldb_cq_wptr_count_nxt = egress_err_residue_ldb_cq_wptr_count_f ;
    if ( hqm_credit_hist_pipe_core.egress_err_residue_ldb_cq_wptr ) begin
      egress_err_residue_ldb_cq_wptr_count_nxt = egress_err_residue_ldb_cq_wptr_count_f + 1'd1 ;
    end

    egress_err_residue_dir_cq_wptr_count_nxt = egress_err_residue_dir_cq_wptr_count_f ;
    if ( hqm_credit_hist_pipe_core.egress_err_residue_dir_cq_wptr ) begin
      egress_err_residue_dir_cq_wptr_count_nxt = egress_err_residue_dir_cq_wptr_count_f + 1'd1 ;
    end

    egress_err_residue_ldb_cq_depth_count_nxt = egress_err_residue_ldb_cq_depth_count_f ;
    if ( hqm_credit_hist_pipe_core.egress_err_residue_ldb_cq_depth ) begin
      egress_err_residue_ldb_cq_depth_count_nxt = egress_err_residue_ldb_cq_depth_count_f + 1'd1 ;
    end

    egress_err_residue_dir_cq_depth_count_nxt = egress_err_residue_dir_cq_depth_count_f ;
    if ( hqm_credit_hist_pipe_core.egress_err_residue_dir_cq_depth ) begin
      egress_err_residue_dir_cq_depth_count_nxt = egress_err_residue_dir_cq_depth_count_f + 1'd1 ;
    end

    egress_err_hcw_ecc_sb_count_nxt = egress_err_hcw_ecc_sb_count_f ;
    if ( hqm_credit_hist_pipe_core.egress_err_hcw_ecc_sb ) begin
      egress_err_hcw_ecc_sb_count_nxt = egress_err_hcw_ecc_sb_count_f + 1'd1 ;
    end

    egress_err_hcw_ecc_mb_count_nxt = egress_err_hcw_ecc_mb_count_f ;
    if ( hqm_credit_hist_pipe_core.egress_err_hcw_ecc_mb ) begin
      egress_err_hcw_ecc_mb_count_nxt = egress_err_hcw_ecc_mb_count_f + 1'd1 ;
    end

    egress_err_dir_cq_depth_underflow_count_nxt = egress_err_dir_cq_depth_underflow_count_f ;
    if ( hqm_credit_hist_pipe_core.egress_err_dir_cq_depth_underflow ) begin
      egress_err_dir_cq_depth_underflow_count_nxt = egress_err_dir_cq_depth_underflow_count_f + 1'd1 ;
    end

    egress_err_ldb_cq_depth_underflow_count_nxt = egress_err_ldb_cq_depth_underflow_count_f ;
    if ( hqm_credit_hist_pipe_core.egress_err_ldb_cq_depth_underflow ) begin
      egress_err_ldb_cq_depth_underflow_count_nxt = egress_err_ldb_cq_depth_underflow_count_f + 1'd1 ;
    end

    egress_err_dir_cq_depth_overflow_count_nxt = egress_err_dir_cq_depth_overflow_count_f ;
    if ( hqm_credit_hist_pipe_core.egress_err_dir_cq_depth_overflow ) begin
      egress_err_dir_cq_depth_overflow_count_nxt = egress_err_dir_cq_depth_overflow_count_f + 1'd1 ;
    end

    egress_err_ldb_cq_depth_overflow_count_nxt = egress_err_ldb_cq_depth_overflow_count_f ;
    if ( hqm_credit_hist_pipe_core.egress_err_ldb_cq_depth_overflow ) begin
      egress_err_ldb_cq_depth_overflow_count_nxt = egress_err_ldb_cq_depth_overflow_count_f + 1'd1 ;
    end

    int_inf_v_count_nxt = int_inf_v_count_f ;
    if ( hqm_credit_hist_pipe_core.int_inf_v ) begin
      int_inf_v_count_nxt = int_inf_v_count_f  + 1'd1 ;
    end

    int_cor_v_count_nxt = int_cor_v_count_f ;
    if ( hqm_credit_hist_pipe_core.int_cor_v ) begin
      int_cor_v_count_nxt = int_cor_v_count_f  + 1'd1 ;
    end

    int_unc_v_count_nxt = int_unc_v_count_f ;
    if ( hqm_credit_hist_pipe_core.int_unc_v ) begin
      int_unc_v_count_nxt = int_unc_v_count_f  + 1'd1 ;
    end

    chp_alarm_up_count_nxt = chp_alarm_up_count_f ;
    if ( hqm_credit_hist_pipe_core.chp_alarm_up_v & hqm_credit_hist_pipe_core.chp_alarm_up_ready ) begin
      chp_alarm_up_count_nxt = chp_alarm_up_count_f + 1'd1 ;
    end

    chp_alarm_down_count_nxt = chp_alarm_down_count_f ;
    if ( hqm_credit_hist_pipe_core.chp_alarm_down_v & hqm_credit_hist_pipe_core.chp_alarm_down_ready ) begin
      chp_alarm_down_count_nxt = chp_alarm_down_count_f + 1'd1 ;
    end

    fifo_chp_rop_hcw_of_count_nxt = fifo_chp_rop_hcw_of_count_f ;
    if ( hqm_credit_hist_pipe_core.fifo_chp_rop_hcw_of ) begin
      fifo_chp_rop_hcw_of_count_nxt = fifo_chp_rop_hcw_of_count_f + 1'd1 ;
    end

    fifo_chp_rop_hcw_uf_count_nxt = fifo_chp_rop_hcw_uf_count_f ;
    if ( hqm_credit_hist_pipe_core.fifo_chp_rop_hcw_uf ) begin
      fifo_chp_rop_hcw_uf_count_nxt = fifo_chp_rop_hcw_uf_count_f + 1'd1 ;
    end

    fifo_chp_lsp_tok_of_count_nxt = fifo_chp_lsp_tok_of_count_f ;
    if ( hqm_credit_hist_pipe_core.fifo_chp_lsp_tok_of ) begin
      fifo_chp_lsp_tok_of_count_nxt = fifo_chp_lsp_tok_of_count_f + 1'd1 ;
    end

    fifo_chp_lsp_tok_uf_count_nxt = fifo_chp_lsp_tok_uf_count_f ;
    if ( hqm_credit_hist_pipe_core.fifo_chp_lsp_tok_uf ) begin
      fifo_chp_lsp_tok_uf_count_nxt = fifo_chp_lsp_tok_uf_count_f + 1'd1 ;
    end

    fifo_chp_lsp_ap_cmp_of_count_nxt = fifo_chp_lsp_ap_cmp_of_count_f ;
    if ( hqm_credit_hist_pipe_core.fifo_chp_lsp_ap_cmp_of ) begin
      fifo_chp_lsp_ap_cmp_of_count_nxt = fifo_chp_lsp_ap_cmp_of_count_f + 1'd1 ;
    end

    fifo_chp_lsp_ap_cmp_uf_count_nxt = fifo_chp_lsp_ap_cmp_uf_count_f ;
    if ( hqm_credit_hist_pipe_core.fifo_chp_lsp_ap_cmp_uf ) begin
      fifo_chp_lsp_ap_cmp_uf_count_nxt = fifo_chp_lsp_ap_cmp_uf_count_f + 1'd1 ;
    end

    fifo_outbound_hcw_of_count_nxt = fifo_outbound_hcw_of_count_f ;
    if ( hqm_credit_hist_pipe_core.fifo_outbound_hcw_of ) begin
      fifo_outbound_hcw_of_count_nxt = fifo_outbound_hcw_of_count_f + 1'd1 ;
    end

    fifo_outbound_hcw_uf_count_nxt = fifo_outbound_hcw_uf_count_f ;
    if ( hqm_credit_hist_pipe_core.fifo_outbound_hcw_uf ) begin
      fifo_outbound_hcw_uf_count_nxt = fifo_outbound_hcw_uf_count_f + 1'd1 ;
    end

    fifo_qed_to_cq_of_count_nxt = fifo_qed_to_cq_of_count_f ;
    if ( hqm_credit_hist_pipe_core.fifo_qed_to_cq_of ) begin
      fifo_qed_to_cq_of_count_nxt = fifo_qed_to_cq_of_count_f + 1'd1 ;
    end

    fifo_qed_to_cq_uf_count_nxt = fifo_qed_to_cq_uf_count_f ;
    if ( hqm_credit_hist_pipe_core.fifo_qed_to_cq_uf ) begin
      fifo_qed_to_cq_uf_count_nxt = fifo_qed_to_cq_uf_count_f + 1'd1 ;
    end

    hist_list_residue_error_cfg_count_nxt = hist_list_residue_error_cfg_count_f ;
    if ( hqm_credit_hist_pipe_core.hist_list_residue_error_cfg ) begin
      hist_list_residue_error_cfg_count_nxt = hist_list_residue_error_cfg_count_f + 1'd1 ;
    end

    cfg_rx_fifo_status_underflow_count_nxt = cfg_rx_fifo_status_underflow_count_f ;
    if ( hqm_credit_hist_pipe_core.cfg_rx_fifo_status_underflow ) begin
      cfg_rx_fifo_status_underflow_count_nxt = cfg_rx_fifo_status_underflow_count_f + 1'd1 ;
    end

    cfg_rx_fifo_status_overflow_count_nxt = cfg_rx_fifo_status_overflow_count_f ;
    if ( hqm_credit_hist_pipe_core.cfg_rx_fifo_status_overflow ) begin
      cfg_rx_fifo_status_overflow_count_nxt = cfg_rx_fifo_status_overflow_count_f + 1'd1 ;
    end

    fifo_chp_sys_tx_fifo_mem_of_count_nxt = fifo_chp_sys_tx_fifo_mem_of_count_f ;
    if ( hqm_credit_hist_pipe_core.fifo_chp_sys_tx_fifo_mem_of ) begin
      fifo_chp_sys_tx_fifo_mem_of_count_nxt = fifo_chp_sys_tx_fifo_mem_of_count_f + 1'd1 ;
    end

    fifo_chp_sys_tx_fifo_mem_uf_count_nxt = fifo_chp_sys_tx_fifo_mem_uf_count_f ;
    if ( hqm_credit_hist_pipe_core.fifo_chp_sys_tx_fifo_mem_uf ) begin
      fifo_chp_sys_tx_fifo_mem_uf_count_nxt = fifo_chp_sys_tx_fifo_mem_uf_count_f + 1'd1 ;
    end

    ing_err_qed_chp_sch_rx_sync_out_cmd_error_count_nxt = ing_err_qed_chp_sch_rx_sync_out_cmd_error_count_f ;
    if ( hqm_credit_hist_pipe_core.ing_err_qed_chp_sch_rx_sync_out_cmd_error ) begin
      ing_err_qed_chp_sch_rx_sync_out_cmd_error_count_nxt = ing_err_qed_chp_sch_rx_sync_out_cmd_error_count_f + 1'd1 ;
    end

    freelist_busy_nxt = freelist_busy_f ;
    if ( hqm_credit_hist_pipe_core.chp_rop_hcw_v & hqm_credit_hist_pipe_core.chp_rop_hcw_ready & 
         ( hqm_credit_hist_pipe_core.chp_rop_hcw_data.cmd == CHP_ROP_ENQ_NEW_HCW ) &
         ( ( hqm_credit_hist_pipe_core.chp_rop_hcw_data.hcw_cmd.hcw_cmd_dec == HQM_CMD_ENQ_NEW ) | 
           ( hqm_credit_hist_pipe_core.chp_rop_hcw_data.hcw_cmd.hcw_cmd_dec == HQM_CMD_ENQ_NEW_TOK_RET ) | 
           ( hqm_credit_hist_pipe_core.chp_rop_hcw_data.hcw_cmd.hcw_cmd_dec == HQM_CMD_ENQ_COMP ) | 
           ( hqm_credit_hist_pipe_core.chp_rop_hcw_data.hcw_cmd.hcw_cmd_dec == HQM_CMD_ENQ_COMP_TOK_RET ) | 
           ( hqm_credit_hist_pipe_core.chp_rop_hcw_data.hcw_cmd.hcw_cmd_dec == HQM_CMD_ENQ_FRAG ) | 
           ( hqm_credit_hist_pipe_core.chp_rop_hcw_data.hcw_cmd.hcw_cmd_dec == HQM_CMD_ENQ_FRAG_TOK_RET ) ) ) begin 
      freelist_busy_nxt[ hqm_credit_hist_pipe_core.chp_rop_hcw_data.flid ] = 1'd1 ;
    end
    if ( hqm_credit_hist_pipe_core.qed_chp_sch_v & hqm_credit_hist_pipe_core.qed_chp_sch_ready &
         ( hqm_credit_hist_pipe_core.qed_chp_sch_data.cmd == QED_CHP_SCH_SCHED ) ) begin
      freelist_busy_nxt[ hqm_credit_hist_pipe_core.qed_chp_sch_data.flid ] = 1'd0 ;
    end
    if ( hqm_credit_hist_pipe_core.qed_chp_sch_v & hqm_credit_hist_pipe_core.qed_chp_sch_ready &
         ( hqm_credit_hist_pipe_core.qed_chp_sch_data.cmd == QED_CHP_SCH_TRANSFER ) ) begin
      freelist_busy_nxt[ hqm_credit_hist_pipe_core.qed_chp_sch_data.flid ] = 1'd0 ;
    end

    hcw_sched_w_req_parity_err_count_nxt = hcw_sched_w_req_parity_err_count_f ;
    if ( hcw_sched_w_req_parity_err ) begin
      hcw_sched_w_req_parity_err_count_nxt = hcw_sched_w_req_parity_err_count_f + 1'd1 ;
    end

    chp_lsp_cmp_data_parity_err_count_nxt = chp_lsp_cmp_data_parity_err_count_f ;
    if ( chp_lsp_cmp_data_parity_err ) begin
      chp_lsp_cmp_data_parity_err_count_nxt = chp_lsp_cmp_data_parity_err_count_f + 1'd1 ;
    end

    hcw_enq_w_req_running_clk_count_nxt = hcw_enq_w_req_running_clk_count_f;
    if ( hcw_enq_w_req_running_clk_count_f == 32'h0 ) begin
      if ( hqm_credit_hist_pipe_core.hcw_enq_w_req_valid ) begin
        hcw_enq_w_req_running_clk_count_nxt = hcw_enq_w_req_running_clk_count_f + 1'b1;
      end
    end
    else begin
      hcw_enq_w_req_running_clk_count_nxt = hcw_enq_w_req_running_clk_count_f + 1'b1;
    end

    hcw_enq_w_req_clk_count_nxt = hcw_enq_w_req_clk_count_f;
    if ( hqm_credit_hist_pipe_core.hcw_enq_w_req_valid & hqm_credit_hist_pipe_core.hcw_enq_w_req_ready ) begin
       hcw_enq_w_req_clk_count_nxt = hcw_enq_w_req_running_clk_count_nxt;
    end

    hcw_enq_w_req_enqueue_count_nxt = hcw_enq_w_req_enqueue_count_f ;
    if ( hqm_credit_hist_pipe_core.hcw_enq_w_req_valid & hqm_credit_hist_pipe_core.hcw_enq_w_req_ready ) begin
      hcw_enq_w_req_enqueue_count_nxt = hcw_enq_w_req_enqueue_count_f +
                                        ( hqm_credit_hist_pipe_core.hcw_enq_w_req.data.cmd.hcw_cmd_dec == HQM_CMD_ENQ_NEW ) + 
                                        ( hqm_credit_hist_pipe_core.hcw_enq_w_req.data.cmd.hcw_cmd_dec == HQM_CMD_ENQ_NEW_TOK_RET ) + 
                                        ( hqm_credit_hist_pipe_core.hcw_enq_w_req.data.cmd.hcw_cmd_dec == HQM_CMD_ENQ_COMP ) + 
                                        ( hqm_credit_hist_pipe_core.hcw_enq_w_req.data.cmd.hcw_cmd_dec == HQM_CMD_ENQ_COMP_TOK_RET ) + 
                                        ( hqm_credit_hist_pipe_core.hcw_enq_w_req.data.cmd.hcw_cmd_dec == HQM_CMD_ENQ_FRAG ) + 
                                        ( hqm_credit_hist_pipe_core.hcw_enq_w_req.data.cmd.hcw_cmd_dec == HQM_CMD_ENQ_FRAG_TOK_RET ) ;
    end

    hcw_enq_w_req_enqueue_running_clk_count_nxt = hcw_enq_w_req_enqueue_running_clk_count_f;
    if ( hcw_enq_w_req_enqueue_running_clk_count_f == 32'h0 ) begin
      if ( hqm_credit_hist_pipe_core.hcw_enq_w_req_valid ) begin
        hcw_enq_w_req_enqueue_running_clk_count_nxt = hcw_enq_w_req_enqueue_running_clk_count_f +
                                                      ( hqm_credit_hist_pipe_core.hcw_enq_w_req.data.cmd.hcw_cmd_dec == HQM_CMD_ENQ_NEW ) + 
                                                      ( hqm_credit_hist_pipe_core.hcw_enq_w_req.data.cmd.hcw_cmd_dec == HQM_CMD_ENQ_NEW_TOK_RET ) + 
                                                      ( hqm_credit_hist_pipe_core.hcw_enq_w_req.data.cmd.hcw_cmd_dec == HQM_CMD_ENQ_COMP ) + 
                                                      ( hqm_credit_hist_pipe_core.hcw_enq_w_req.data.cmd.hcw_cmd_dec == HQM_CMD_ENQ_COMP_TOK_RET ) + 
                                                      ( hqm_credit_hist_pipe_core.hcw_enq_w_req.data.cmd.hcw_cmd_dec == HQM_CMD_ENQ_FRAG ) + 
                                                      ( hqm_credit_hist_pipe_core.hcw_enq_w_req.data.cmd.hcw_cmd_dec == HQM_CMD_ENQ_FRAG_TOK_RET ) ;
      end
    end
    else begin
      hcw_enq_w_req_enqueue_running_clk_count_nxt = hcw_enq_w_req_enqueue_running_clk_count_f + 1'b1;
    end

    hcw_enq_w_req_enqueue_clk_count_nxt = hcw_enq_w_req_enqueue_clk_count_f;
    if ( hqm_credit_hist_pipe_core.hcw_enq_w_req_valid & hqm_credit_hist_pipe_core.hcw_enq_w_req_ready &
         ( ( hqm_credit_hist_pipe_core.hcw_enq_w_req.data.cmd.hcw_cmd_dec == HQM_CMD_ENQ_NEW ) | 
           ( hqm_credit_hist_pipe_core.hcw_enq_w_req.data.cmd.hcw_cmd_dec == HQM_CMD_ENQ_NEW_TOK_RET ) | 
           ( hqm_credit_hist_pipe_core.hcw_enq_w_req.data.cmd.hcw_cmd_dec == HQM_CMD_ENQ_COMP ) | 
           ( hqm_credit_hist_pipe_core.hcw_enq_w_req.data.cmd.hcw_cmd_dec == HQM_CMD_ENQ_COMP_TOK_RET ) | 
           ( hqm_credit_hist_pipe_core.hcw_enq_w_req.data.cmd.hcw_cmd_dec == HQM_CMD_ENQ_FRAG ) | 
           ( hqm_credit_hist_pipe_core.hcw_enq_w_req.data.cmd.hcw_cmd_dec == HQM_CMD_ENQ_FRAG_TOK_RET ) )
       ) begin
       hcw_enq_w_req_enqueue_clk_count_nxt = hcw_enq_w_req_enqueue_running_clk_count_nxt;
    end

    chp_rop_hcw_running_clk_count_nxt = chp_rop_hcw_running_clk_count_f;
    if ( chp_rop_hcw_running_clk_count_f == 32'h0 ) begin
      if ( hqm_credit_hist_pipe_core.chp_rop_hcw_v ) begin
        chp_rop_hcw_running_clk_count_nxt = chp_rop_hcw_running_clk_count_f + 1'b1;
      end
    end
    else begin
      chp_rop_hcw_running_clk_count_nxt = chp_rop_hcw_running_clk_count_f + 1'b1;
    end

    chp_rop_hcw_clk_count_nxt = chp_rop_hcw_clk_count_f;
    if ( hqm_credit_hist_pipe_core.chp_rop_hcw_v & hqm_credit_hist_pipe_core.chp_rop_hcw_ready ) begin
       chp_rop_hcw_clk_count_nxt = chp_rop_hcw_running_clk_count_nxt;
    end

    dqed_chp_sch_running_clk_count_nxt = dqed_chp_sch_running_clk_count_f;
    if ( dqed_chp_sch_running_clk_count_f == 32'h0 ) begin
      if ( hqm_credit_hist_pipe_core.qed_chp_sch_v & ( hqm_credit_hist_pipe_core.qed_chp_sch_data.cmd==QED_CHP_SCH_SCHED ) & ~ hqm_credit_hist_pipe_core.qed_chp_sch_data.hqm_core_flags.cq_is_ldb ) begin
        dqed_chp_sch_running_clk_count_nxt = dqed_chp_sch_running_clk_count_f + 1'b1;
      end
    end
    else begin
      dqed_chp_sch_running_clk_count_nxt = dqed_chp_sch_running_clk_count_f + 1'b1;
    end

    dqed_chp_sch_clk_count_nxt = dqed_chp_sch_clk_count_f;
    if ( hqm_credit_hist_pipe_core.qed_chp_sch_v & hqm_credit_hist_pipe_core.qed_chp_sch_ready & ( hqm_credit_hist_pipe_core.qed_chp_sch_data.cmd==QED_CHP_SCH_SCHED ) & ~ hqm_credit_hist_pipe_core.qed_chp_sch_data.hqm_core_flags.cq_is_ldb ) begin
       dqed_chp_sch_clk_count_nxt = dqed_chp_sch_running_clk_count_nxt;
    end

    qed_chp_sch_running_clk_count_nxt = qed_chp_sch_running_clk_count_f;
    if ( qed_chp_sch_running_clk_count_f == 32'h0 ) begin
      if ( hqm_credit_hist_pipe_core.qed_chp_sch_v & ( hqm_credit_hist_pipe_core.qed_chp_sch_data.cmd==QED_CHP_SCH_SCHED ) & hqm_credit_hist_pipe_core.qed_chp_sch_data.hqm_core_flags.cq_is_ldb ) begin
        qed_chp_sch_running_clk_count_nxt = qed_chp_sch_running_clk_count_f + 1'b1;
      end
    end
    else begin
      qed_chp_sch_running_clk_count_nxt = qed_chp_sch_running_clk_count_f + 1'b1;
    end

    qed_chp_sch_clk_count_nxt = qed_chp_sch_clk_count_f;
    if ( hqm_credit_hist_pipe_core.qed_chp_sch_v & hqm_credit_hist_pipe_core.qed_chp_sch_ready & ( hqm_credit_hist_pipe_core.qed_chp_sch_data.cmd==QED_CHP_SCH_SCHED ) & hqm_credit_hist_pipe_core.qed_chp_sch_data.hqm_core_flags.cq_is_ldb ) begin
       qed_chp_sch_clk_count_nxt = qed_chp_sch_running_clk_count_nxt;
    end

    aqed_chp_sch_running_clk_count_nxt = aqed_chp_sch_running_clk_count_f;
    if ( aqed_chp_sch_running_clk_count_f == 32'h0 ) begin
      if ( hqm_credit_hist_pipe_core.aqed_chp_sch_v ) begin
        aqed_chp_sch_running_clk_count_nxt = aqed_chp_sch_running_clk_count_f + 1'b1;
      end
    end
    else begin
      aqed_chp_sch_running_clk_count_nxt = aqed_chp_sch_running_clk_count_f + 1'b1;
    end

    aqed_chp_sch_clk_count_nxt = aqed_chp_sch_clk_count_f;
    if ( hqm_credit_hist_pipe_core.aqed_chp_sch_v & hqm_credit_hist_pipe_core.aqed_chp_sch_ready ) begin
       aqed_chp_sch_clk_count_nxt = aqed_chp_sch_running_clk_count_nxt;
    end

    hcw_sched_w_req_running_clk_count_nxt = hcw_sched_w_req_running_clk_count_f;
    if ( hcw_sched_w_req_running_clk_count_f == 32'h0 ) begin
      if ( hqm_credit_hist_pipe_core.hcw_sched_w_req_valid ) begin
        hcw_sched_w_req_running_clk_count_nxt = hcw_sched_w_req_running_clk_count_f + 1'b1;
      end
    end
    else begin
      hcw_sched_w_req_running_clk_count_nxt = hcw_sched_w_req_running_clk_count_f + 1'b1;
    end

    hcw_sched_w_req_clk_count_nxt = hcw_sched_w_req_clk_count_f;
    if ( hqm_credit_hist_pipe_core.hcw_sched_w_req_valid & hqm_credit_hist_pipe_core.hcw_sched_w_req_ready ) begin
       hcw_sched_w_req_clk_count_nxt = hcw_sched_w_req_running_clk_count_nxt;
    end

  end

  always_ff @( posedge hqm_credit_hist_pipe_core.hqm_inp_gated_clk or negedge hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp ) begin
    if ( ~ hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp ) begin
      chp_ingress_flid_ret_rx_sync_stall_count_f <= 32'd0 ;
      chp_cfg_req_up_read_count_f <= 32'd0 ;
      chp_cfg_req_up_write_count_f <= 32'd0 ;
      chp_cfg_req_up_chp_read_count_f <= 32'd0 ;
      chp_cfg_req_up_chp_write_count_f <= 32'd0 ;
      chp_cfg_req_down_read_count_f <= 32'd0 ;
      chp_cfg_req_down_write_count_f <= 32'd0 ;
      chp_cfg_rsp_down_count_f <= 32'd0 ;
      chp_cfg_rsp_down_err_count_f <= 32'd0 ;
      hcw_enq_w_req_v_count_f <= 32'd0 ;
      hcw_enq_w_req_qtype_error_count_f <= 32'd0 ;
      hcw_enq_w_req_stall_count_f <= 32'd0 ;
      qed_chp_sch_v_count_f <= 32'd0 ;
      qed_chp_sch_flush_count_f <= 32'd0 ;
      qed_chp_sch_stall_count_f <= 32'd0 ;
      dqed_chp_sch_v_count_f <= 32'd0 ;
      dqed_chp_sch_flush_count_f <= 32'd0 ;
      dqed_chp_sch_stall_count_f <= 32'd0 ;
      aqed_chp_sch_v_count_f <= 32'd0 ;
      aqed_chp_sch_flush_count_f <= 32'd0 ;
      aqed_chp_sch_stall_count_f <= 32'd0 ;
      chp_rop_hcw_v_count_f <= 32'd0 ;
      chp_rop_hcw_replay_count_f <= 32'd0 ;
      chp_rop_hcw_enq_count_f <= 32'd0 ;
      chp_rop_hcw_enq_comp_count_f <= 32'd0 ;
      chp_rop_hcw_comp_count_f <= 32'd0 ;
      chp_rop_hcw_noop_count_f <= 32'd0 ;
      chp_rop_hcw_stall_count_f <= 32'd0 ;
      chp_lsp_token_v_count_f <= 32'd0 ;
      chp_lsp_token_count_f <= 32'd0 ;
      chp_lsp_token_v_dir_count_f <= 32'd0 ;
      chp_lsp_token_dir_count_f <= 32'd0 ;
      chp_lsp_token_v_ldb_count_f <= 32'd0 ;
      chp_lsp_token_ldb_count_f <= 32'd0 ;
      chp_lsp_token_stall_count_f <= 32'd0 ;
      chp_lsp_cmp_v_count_f <= 32'd0 ;
      chp_lsp_cmp_stall_count_f <= 32'd0 ;
      hcw_sched_w_req_v_count_f <= 32'd0 ;
      hcw_sched_w_req_stall_count_f <= 32'd0 ;
      chp_rop_pipe_credit_afull_count_f <= 32'd0 ;
      chp_lsp_tok_pipe_credit_afull_count_f <= 32'd0 ;
      chp_lsp_ap_cmp_pipe_credit_afull_count_f <= 32'd0 ;
      chp_outbound_hcw_pipe_credit_afull_count_f <= 32'd0 ;
      chp_alarm_up_count_f <= 32'd0 ;
      chp_alarm_down_count_f <= 32'd0 ;
      hcw_enq_w_req_running_clk_count_f <= 32'd0 ;
      hcw_enq_w_req_clk_count_f <= 32'd0 ;
      hcw_enq_w_req_enqueue_count_f <= 32'd0 ;
      hcw_enq_w_req_enqueue_running_clk_count_f <= 32'd0 ;
      hcw_enq_w_req_enqueue_clk_count_f <= 32'd0 ;
      freelist_busy_f <= 'd0 ;
      freelist_pop_v_0f <= '0;
      freelist_pop_v_1f <= '0;
      freelist_pop_v_2f <= '0;
    end
    else begin
      chp_ingress_flid_ret_rx_sync_stall_count_f <= chp_ingress_flid_ret_rx_sync_stall_count_nxt ;
      chp_cfg_req_up_read_count_f <= chp_cfg_req_up_read_count_nxt ;
      chp_cfg_req_up_write_count_f <= chp_cfg_req_up_write_count_nxt ;
      chp_cfg_req_up_chp_read_count_f <= chp_cfg_req_up_chp_read_count_nxt ;
      chp_cfg_req_up_chp_write_count_f <= chp_cfg_req_up_chp_write_count_nxt ;
      chp_cfg_req_down_read_count_f <= chp_cfg_req_down_read_count_nxt ;
      chp_cfg_req_down_write_count_f <= chp_cfg_req_down_write_count_nxt ;
      chp_cfg_rsp_down_count_f <= chp_cfg_rsp_down_count_nxt ;
      chp_cfg_rsp_down_err_count_f <= chp_cfg_rsp_down_err_count_nxt ;
      hcw_enq_w_req_v_count_f <= hcw_enq_w_req_v_count_nxt ;
      hcw_enq_w_req_qtype_error_count_f <= hcw_enq_w_req_qtype_error_count_nxt ;
      hcw_enq_w_req_stall_count_f <= hcw_enq_w_req_stall_count_nxt ;
      qed_chp_sch_v_count_f <= qed_chp_sch_v_count_nxt ;
      qed_chp_sch_flush_count_f <= qed_chp_sch_flush_count_nxt ;
      qed_chp_sch_stall_count_f <= qed_chp_sch_stall_count_nxt ;
      dqed_chp_sch_v_count_f <= dqed_chp_sch_v_count_nxt ;
      dqed_chp_sch_flush_count_f <= dqed_chp_sch_flush_count_nxt ;
      dqed_chp_sch_stall_count_f <= dqed_chp_sch_stall_count_nxt ;
      aqed_chp_sch_v_count_f <= aqed_chp_sch_v_count_nxt ;
      aqed_chp_sch_flush_count_f <= aqed_chp_sch_flush_count_nxt ;
      aqed_chp_sch_stall_count_f <= aqed_chp_sch_stall_count_nxt ;
      chp_rop_hcw_v_count_f <= chp_rop_hcw_v_count_nxt ;
      chp_rop_hcw_replay_count_f <= chp_rop_hcw_replay_count_nxt ;
      chp_rop_hcw_enq_count_f <= chp_rop_hcw_enq_count_nxt ;
      chp_rop_hcw_enq_comp_count_f <= chp_rop_hcw_enq_comp_count_nxt ;
      chp_rop_hcw_comp_count_f <= chp_rop_hcw_comp_count_nxt ;
      chp_rop_hcw_noop_count_f <= chp_rop_hcw_noop_count_nxt ;
      chp_rop_hcw_stall_count_f <= chp_rop_hcw_stall_count_nxt ;
      chp_lsp_token_v_count_f <= chp_lsp_token_v_count_nxt ;
      chp_lsp_token_count_f <= chp_lsp_token_count_nxt ;
      chp_lsp_token_v_dir_count_f <= chp_lsp_token_v_dir_count_nxt ;
      chp_lsp_token_dir_count_f <= chp_lsp_token_dir_count_nxt ;
      chp_lsp_token_v_ldb_count_f <= chp_lsp_token_v_ldb_count_nxt ;
      chp_lsp_token_ldb_count_f <= chp_lsp_token_ldb_count_nxt ;
      chp_lsp_token_stall_count_f <= chp_lsp_token_stall_count_nxt ;
      chp_lsp_cmp_v_count_f <= chp_lsp_cmp_v_count_nxt ;
      chp_lsp_cmp_stall_count_f <= chp_lsp_cmp_stall_count_nxt ;
      hcw_sched_w_req_v_count_f <= hcw_sched_w_req_v_count_nxt ;
      hcw_sched_w_req_stall_count_f <= hcw_sched_w_req_stall_count_nxt ;
      chp_rop_pipe_credit_afull_count_f <= chp_rop_pipe_credit_afull_count_nxt ;
      chp_lsp_tok_pipe_credit_afull_count_f <= chp_lsp_tok_pipe_credit_afull_count_nxt ;
      chp_lsp_ap_cmp_pipe_credit_afull_count_f <= chp_lsp_ap_cmp_pipe_credit_afull_count_nxt ;
      chp_outbound_hcw_pipe_credit_afull_count_f <= chp_outbound_hcw_pipe_credit_afull_count_nxt ;
      chp_alarm_up_count_f <= chp_alarm_up_count_nxt ;
      chp_alarm_down_count_f <= chp_alarm_down_count_nxt ;
      hcw_enq_w_req_running_clk_count_f <= hcw_enq_w_req_running_clk_count_nxt ;
      hcw_enq_w_req_clk_count_f <= hcw_enq_w_req_clk_count_nxt ;
      hcw_enq_w_req_enqueue_count_f <= hcw_enq_w_req_enqueue_count_nxt ;
      hcw_enq_w_req_enqueue_running_clk_count_f <= hcw_enq_w_req_enqueue_running_clk_count_nxt ;
      hcw_enq_w_req_enqueue_clk_count_f <= hcw_enq_w_req_enqueue_clk_count_nxt ;
      freelist_busy_f <= freelist_busy_nxt ;
      freelist_pop_v_0f <= freelist_pop_v;
      freelist_pop_v_1f <= freelist_pop_v_0f;
      freelist_pop_v_2f <= freelist_pop_v_1f;
    end
  end

  always_ff @( posedge hqm_credit_hist_pipe_core.hqm_gated_clk or negedge hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp ) begin
    if ( ~ hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp ) begin
      unit_cfg_req_write_count_f <= 32'd0 ;
      unit_cfg_req_read_count_f <= 32'd0 ;
      hist_list_of_count_f <= 32'd0 ;
      hist_list_uf_count_f <= 32'd0 ;
      hist_list_a_of_count_f <= 32'd0 ;
      hist_list_a_uf_count_f <= 32'd0 ;
      freelist_of_count_f <= 32'd0 ;
      ing_err_hcw_enq_invalid_hcw_cmd_count_f <= 32'd0 ;
      ing_err_hcw_enq_user_parity_error_count_f <= 32'd0 ;
      ing_err_hcw_enq_data_parity_error_count_f <= 32'd0 ;
      ing_err_enq_vas_credit_count_residue_error_count_f <= 32'd0 ;
      ing_err_sch_vas_credit_count_residue_err_count_f <= 32'd0 ;
      enqpipe_err_hist_list_data_error_sb_count_f <= 32'd0 ;
      enqpipe_err_hist_list_data_error_mb_count_f <= 32'd0 ;
      enqpipe_err_freelist_data_error_sb_count_f <= 32'd0 ;
      enqpipe_err_freelist_data_error_mb_count_f <= 32'd0 ;
      enqpipe_err_freelist_uf_count_f <= 32'd0 ;
      enqpipe_err_vas_out_of_credit_count_f <= 32'd0 ;
      enqpipe_err_excess_frag_count_f <= 32'd0 ;
      enqpipe_err_enq_to_rop_error_drop_count_f <= 32'd0 ;
      enqpipe_err_hist_list_uf_count_f <= 32'd0 ;
      enqpipe_err_hist_list_residue_error_count_f <= 32'd0 ;
      enqpipe_err_enq_to_lsp_cmp_error_drop_count_f <= 32'd0 ;
      enqpipe_err_release_qtype_error_drop_count_f <= 32'd0 ;
      schpipe_err_pipeline_parity_err_count_f <= 32'd0 ;
      schpipe_err_ldb_cq_hcw_h_ecc_sb_err_count_f <= 32'd0 ;
      schpipe_err_ldb_cq_hcw_h_ecc_mb_err_count_f <= 32'd0 ;
      egress_err_pipe_credit_error_count_f <= 32'd0 ;
      egress_err_parity_dir_cq_token_depth_select_count_f <= 32'd0 ;
      egress_err_parity_ldb_cq_token_depth_select_count_f <= 32'd0 ;
      egress_err_parity_dir_cq_intr_thresh_count_f <= 32'd0 ;
      egress_err_parity_ldb_cq_intr_thresh_count_f <= 32'd0 ;
      egress_err_residue_dir_cq_wptr_count_f <= 32'd0 ;
      egress_err_residue_ldb_cq_wptr_count_f <= 32'd0 ;
      egress_err_residue_dir_cq_depth_count_f <= 32'd0 ;
      egress_err_residue_ldb_cq_depth_count_f <= 32'd0 ;
      egress_err_hcw_ecc_sb_count_f <= 32'd0 ;
      egress_err_hcw_ecc_mb_count_f <= 32'd0 ;
      egress_err_dir_cq_depth_underflow_count_f <= 32'd0 ;
      egress_err_ldb_cq_depth_underflow_count_f <= 32'd0 ;
      egress_err_dir_cq_depth_overflow_count_f <= 32'd0 ;
      egress_err_ldb_cq_depth_overflow_count_f <= 32'd0 ;
      int_inf_v_count_f <= 32'd0 ;
      int_cor_v_count_f <= 32'd0 ;
      int_unc_v_count_f <= 32'd0 ;
      fifo_chp_rop_hcw_of_count_f <= 32'd0 ; 
      fifo_chp_rop_hcw_uf_count_f <= 32'd0 ; 
      fifo_chp_lsp_tok_of_count_f <= 32'd0 ; 
      fifo_chp_lsp_tok_uf_count_f <= 32'd0 ; 
      fifo_chp_lsp_ap_cmp_of_count_f <= 32'd0 ; 
      fifo_chp_lsp_ap_cmp_uf_count_f <= 32'd0 ; 
      fifo_outbound_hcw_of_count_f <= 32'd0 ; 
      fifo_outbound_hcw_uf_count_f <= 32'd0 ; 
      fifo_qed_to_cq_of_count_f <= 32'd0 ; 
      fifo_qed_to_cq_uf_count_f <= 32'd0 ; 
      hist_list_residue_error_cfg_count_f <= 32'd0 ; 
      cfg_rx_fifo_status_underflow_count_f <= 32'd0 ;
      cfg_rx_fifo_status_overflow_count_f <= 32'd0 ;
      fifo_chp_sys_tx_fifo_mem_of_count_f <= 32'd0 ;
      fifo_chp_sys_tx_fifo_mem_uf_count_f <= 32'd0 ;
      ing_err_qed_chp_sch_rx_sync_out_cmd_error_count_f <= 32'd0 ;
      hcw_sched_w_req_parity_err_count_f <= 32'd0 ;
      chp_lsp_cmp_data_parity_err_count_f <= 32'd0 ;
      chp_rop_hcw_running_clk_count_f <= 32'd0 ;
      chp_rop_hcw_clk_count_f <= 32'd0 ;
      dqed_chp_sch_running_clk_count_f <= 32'd0 ;
      dqed_chp_sch_clk_count_f <= 32'd0 ;
      qed_chp_sch_running_clk_count_f <= 32'd0 ;
      qed_chp_sch_clk_count_f <= 32'd0 ;
      aqed_chp_sch_running_clk_count_f <= 32'd0 ;
      aqed_chp_sch_clk_count_f <= 32'd0 ;
      hcw_sched_w_req_running_clk_count_f <= 32'd0 ;
      hcw_sched_w_req_clk_count_f <= 32'd0 ;
      err_hw_class_01_sticky_f <= 32'd0 ;
      err_hw_class_02_sticky_f <= 32'd0 ;
    end
    else begin
      unit_cfg_req_write_count_f <= unit_cfg_req_write_count_nxt ;
      unit_cfg_req_read_count_f <= unit_cfg_req_read_count_nxt ;
      hist_list_of_count_f <= hist_list_of_count_nxt ;
      hist_list_uf_count_f <= hist_list_uf_count_nxt ;
      hist_list_a_of_count_f <= hist_list_a_of_count_nxt ;
      hist_list_a_uf_count_f <= hist_list_a_uf_count_nxt ;
      freelist_of_count_f <= freelist_of_count_nxt ;
      ing_err_hcw_enq_invalid_hcw_cmd_count_f <= ing_err_hcw_enq_invalid_hcw_cmd_count_nxt ;
      ing_err_hcw_enq_user_parity_error_count_f <= ing_err_hcw_enq_user_parity_error_count_nxt ;
      ing_err_hcw_enq_data_parity_error_count_f <= ing_err_hcw_enq_data_parity_error_count_nxt ;
      ing_err_enq_vas_credit_count_residue_error_count_f <= ing_err_enq_vas_credit_count_residue_error_count_nxt ;
      ing_err_sch_vas_credit_count_residue_err_count_f <= ing_err_sch_vas_credit_count_residue_err_count_nxt ;
      enqpipe_err_hist_list_data_error_sb_count_f <= enqpipe_err_hist_list_data_error_sb_count_nxt ;
      enqpipe_err_hist_list_data_error_mb_count_f <= enqpipe_err_hist_list_data_error_mb_count_nxt ;
      enqpipe_err_freelist_data_error_sb_count_f <= enqpipe_err_freelist_data_error_sb_count_nxt ;
      enqpipe_err_freelist_data_error_mb_count_f <= enqpipe_err_freelist_data_error_mb_count_nxt ;
      enqpipe_err_freelist_uf_count_f <= enqpipe_err_freelist_uf_count_nxt ;
      enqpipe_err_enq_to_rop_error_drop_count_f <= enqpipe_err_enq_to_rop_error_drop_count_nxt ;
      enqpipe_err_vas_out_of_credit_count_f <= enqpipe_err_vas_out_of_credit_count_nxt ;
      enqpipe_err_excess_frag_count_f <= enqpipe_err_excess_frag_count_nxt ;
      enqpipe_err_hist_list_uf_count_f <= enqpipe_err_hist_list_uf_count_nxt ;
      enqpipe_err_hist_list_residue_error_count_f <= enqpipe_err_hist_list_residue_error_count_nxt ;
      enqpipe_err_enq_to_lsp_cmp_error_drop_count_f <= enqpipe_err_enq_to_lsp_cmp_error_drop_count_nxt ;
      enqpipe_err_release_qtype_error_drop_count_f <= enqpipe_err_release_qtype_error_drop_count_nxt ;
      schpipe_err_pipeline_parity_err_count_f <= schpipe_err_pipeline_parity_err_count_nxt ;
      schpipe_err_ldb_cq_hcw_h_ecc_sb_err_count_f <= schpipe_err_ldb_cq_hcw_h_ecc_sb_err_count_nxt ;
      schpipe_err_ldb_cq_hcw_h_ecc_mb_err_count_f <= schpipe_err_ldb_cq_hcw_h_ecc_mb_err_count_nxt ;
      egress_err_pipe_credit_error_count_f <= egress_err_pipe_credit_error_count_nxt ;
      egress_err_parity_dir_cq_token_depth_select_count_f <= egress_err_parity_dir_cq_token_depth_select_count_nxt ;
      egress_err_parity_ldb_cq_token_depth_select_count_f <= egress_err_parity_ldb_cq_token_depth_select_count_nxt ;
      egress_err_parity_dir_cq_intr_thresh_count_f <= egress_err_parity_dir_cq_intr_thresh_count_nxt ;
      egress_err_parity_ldb_cq_intr_thresh_count_f <= egress_err_parity_ldb_cq_intr_thresh_count_nxt ;
      egress_err_residue_dir_cq_wptr_count_f <= egress_err_residue_dir_cq_wptr_count_nxt ;
      egress_err_residue_ldb_cq_wptr_count_f <= egress_err_residue_ldb_cq_wptr_count_nxt ;
      egress_err_residue_dir_cq_depth_count_f <= egress_err_residue_dir_cq_depth_count_nxt ;
      egress_err_hcw_ecc_sb_count_f <= egress_err_hcw_ecc_sb_count_nxt ;
      egress_err_hcw_ecc_mb_count_f <= egress_err_hcw_ecc_mb_count_nxt ;
      egress_err_residue_ldb_cq_depth_count_f <= egress_err_residue_ldb_cq_depth_count_nxt ;
      egress_err_dir_cq_depth_underflow_count_f <= egress_err_dir_cq_depth_underflow_count_nxt ;
      egress_err_ldb_cq_depth_underflow_count_f <= egress_err_ldb_cq_depth_underflow_count_nxt ;
      egress_err_dir_cq_depth_overflow_count_f <= egress_err_dir_cq_depth_overflow_count_nxt ;
      egress_err_ldb_cq_depth_overflow_count_f <= egress_err_ldb_cq_depth_overflow_count_nxt ;
      int_inf_v_count_f <= int_inf_v_count_nxt ;
      int_cor_v_count_f <= int_cor_v_count_nxt ;
      int_unc_v_count_f <= int_unc_v_count_nxt ;
      fifo_chp_rop_hcw_of_count_f <= fifo_chp_rop_hcw_of_count_nxt ;
      fifo_chp_rop_hcw_uf_count_f <= fifo_chp_rop_hcw_uf_count_nxt ;
      fifo_chp_lsp_tok_of_count_f <= fifo_chp_lsp_tok_of_count_nxt ;
      fifo_chp_lsp_tok_uf_count_f <= fifo_chp_lsp_tok_uf_count_nxt ;
      fifo_chp_lsp_ap_cmp_of_count_f <= fifo_chp_lsp_ap_cmp_of_count_nxt ;
      fifo_chp_lsp_ap_cmp_uf_count_f <= fifo_chp_lsp_ap_cmp_uf_count_nxt ;
      fifo_outbound_hcw_of_count_f <= fifo_outbound_hcw_of_count_nxt ;
      fifo_outbound_hcw_uf_count_f <= fifo_outbound_hcw_uf_count_nxt ;
      fifo_qed_to_cq_of_count_f <= fifo_qed_to_cq_of_count_nxt ;
      fifo_qed_to_cq_uf_count_f <= fifo_qed_to_cq_uf_count_nxt ;
      hist_list_residue_error_cfg_count_f <= hist_list_residue_error_cfg_count_nxt ;
      cfg_rx_fifo_status_underflow_count_f <= cfg_rx_fifo_status_underflow_count_nxt ;
      cfg_rx_fifo_status_overflow_count_f <= cfg_rx_fifo_status_overflow_count_nxt ;
      fifo_chp_sys_tx_fifo_mem_of_count_f <= fifo_chp_sys_tx_fifo_mem_of_count_nxt ;
      fifo_chp_sys_tx_fifo_mem_uf_count_f <= fifo_chp_sys_tx_fifo_mem_uf_count_nxt ;
      ing_err_qed_chp_sch_rx_sync_out_cmd_error_count_f <= ing_err_qed_chp_sch_rx_sync_out_cmd_error_count_nxt ;
      hcw_sched_w_req_parity_err_count_f <= hcw_sched_w_req_parity_err_count_nxt ;
      chp_lsp_cmp_data_parity_err_count_f <= chp_lsp_cmp_data_parity_err_count_nxt ;
      chp_rop_hcw_running_clk_count_f <= chp_rop_hcw_running_clk_count_nxt ;
      chp_rop_hcw_clk_count_f <= chp_rop_hcw_clk_count_nxt ;
      dqed_chp_sch_running_clk_count_f <= dqed_chp_sch_running_clk_count_nxt ;
      dqed_chp_sch_clk_count_f <= dqed_chp_sch_clk_count_nxt ;
      qed_chp_sch_running_clk_count_f <= qed_chp_sch_running_clk_count_nxt ;
      qed_chp_sch_clk_count_f <= qed_chp_sch_clk_count_nxt ;
      aqed_chp_sch_running_clk_count_f <= aqed_chp_sch_running_clk_count_nxt ;
      aqed_chp_sch_clk_count_f <= aqed_chp_sch_clk_count_nxt ;
      hcw_sched_w_req_running_clk_count_f <= hcw_sched_w_req_running_clk_count_nxt ;
      hcw_sched_w_req_clk_count_f <= hcw_sched_w_req_clk_count_nxt ;
      err_hw_class_01_sticky_f <= hqm_credit_hist_pipe_core.err_hw_class_01_f | err_hw_class_01_sticky_f ;
      err_hw_class_02_sticky_f <= hqm_credit_hist_pipe_core.err_hw_class_02_f | err_hw_class_02_sticky_f ;
    end
  end

  generate
    for ( genvar gi = 0 ; gi < 16 ; gi++ ) begin
      always_comb begin
        hcw_enq_w_req_hcw_cmd_count_nxt [ gi ] = hcw_enq_w_req_hcw_cmd_count_f [ gi ] ;
        if ( hqm_credit_hist_pipe_core.hcw_enq_w_req_valid & hqm_credit_hist_pipe_core.hcw_enq_w_req_ready & ( hqm_credit_hist_pipe_core.hcw_enq_w_req.data.cmd == gi ) ) begin
          hcw_enq_w_req_hcw_cmd_count_nxt [ gi ] = hcw_enq_w_req_hcw_cmd_count_f [ gi ] + 1'b1;
        end
      end
      always_ff @( posedge hqm_credit_hist_pipe_core.hqm_inp_gated_clk or negedge hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp ) begin
        if ( ~ hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp ) begin
          hcw_enq_w_req_hcw_cmd_count_f [ gi ] <= 32'h0 ;
        end
        else begin
          hcw_enq_w_req_hcw_cmd_count_f [ gi ] <= hcw_enq_w_req_hcw_cmd_count_nxt [ gi ] ;
        end
      end
    end

    for (genvar gi = 0 ; gi < 4 ; gi++ ) begin
      always_comb begin
        qed_chp_count_nxt [ gi ] = qed_chp_count_f [ gi ] ;
        dqed_chp_count_nxt [ gi ] = dqed_chp_count_f [ gi ] ;
        if ( hqm_credit_hist_pipe_core.qed_chp_sch_v & hqm_credit_hist_pipe_core.qed_chp_sch_ready &  ( hqm_credit_hist_pipe_core.qed_chp_sch_data.cmd == gi ) ) begin
          if ( hqm_credit_hist_pipe_core.qed_chp_sch_data.hqm_core_flags.cq_is_ldb ) begin
            qed_chp_count_nxt[gi] = qed_chp_count_f[gi] + 1'd1;
          end
          else begin
            dqed_chp_count_nxt[gi] = dqed_chp_count_f[gi] + 1'd1;
          end
        end
      end
      always_ff @( posedge hqm_credit_hist_pipe_core.hqm_inp_gated_clk or negedge hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp ) begin
        if ( ~ hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp ) begin
          qed_chp_count_f [ gi ] <= 32'h0;
          dqed_chp_count_f [ gi ] <= 32'h0;
        end
        else begin
          qed_chp_count_f [ gi ] <= qed_chp_count_nxt [ gi ] ;
          dqed_chp_count_f [ gi ] <= dqed_chp_count_nxt [ gi ] ;
        end
      end
    end

    for ( genvar gi = 0 ; gi < 64 ; gi++ ) begin
      always_comb begin
        qed_chp_sch_cq_count_nxt [ gi ] = qed_chp_sch_cq_count_f [ gi ] ;
        if ( hqm_credit_hist_pipe_core.qed_chp_sch_v & hqm_credit_hist_pipe_core.qed_chp_sch_ready & ( hqm_credit_hist_pipe_core.qed_chp_sch_data.cq == gi ) ) begin
          if ( hqm_credit_hist_pipe_core.qed_chp_sch_data.hqm_core_flags.cq_is_ldb & ( hqm_credit_hist_pipe_core.qed_chp_sch_data.cmd == QED_CHP_SCH_SCHED ) ) begin
            qed_chp_sch_cq_count_nxt [ gi ] = qed_chp_sch_cq_count_f [ gi ] + 1'd1;
          end
        end
      end
      always_ff @(posedge hqm_credit_hist_pipe_core.hqm_inp_gated_clk or negedge hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp ) begin
        if ( ~ hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp ) begin
          qed_chp_sch_cq_count_f [ gi ] <= 32'h0 ;
        end
        else begin
          qed_chp_sch_cq_count_f [ gi ] <= qed_chp_sch_cq_count_nxt [ gi ] ;
        end
      end
    end
    for ( genvar gi = 0 ; gi < 96 ; gi++ ) begin
      always_comb begin
        dqed_chp_sch_cq_count_nxt [ gi ] = dqed_chp_sch_cq_count_f [ gi ] ;
        if ( hqm_credit_hist_pipe_core.qed_chp_sch_v & hqm_credit_hist_pipe_core.qed_chp_sch_ready & ( hqm_credit_hist_pipe_core.qed_chp_sch_data.cq == gi ) ) begin
          if ( ~hqm_credit_hist_pipe_core.qed_chp_sch_data.hqm_core_flags.cq_is_ldb & ( hqm_credit_hist_pipe_core.qed_chp_sch_data.cmd == QED_CHP_SCH_SCHED ) ) begin
            dqed_chp_sch_cq_count_nxt [ gi ] = dqed_chp_sch_cq_count_f [ gi ] + 1'd1;
          end
        end
      end
      always_ff @(posedge hqm_credit_hist_pipe_core.hqm_inp_gated_clk or negedge hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp ) begin
        if ( ~ hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp ) begin
          dqed_chp_sch_cq_count_f [ gi ] <= 32'h0 ;
        end
        else begin
          dqed_chp_sch_cq_count_f [ gi ] <= dqed_chp_sch_cq_count_nxt [ gi ] ;
        end
      end
    end

    for ( genvar gi = 0 ; gi < 64 ; gi++ ) begin
      always_comb begin
        aqed_chp_sch_cq_count_nxt [ gi ] = aqed_chp_sch_cq_count_f [ gi ] ;
        if ( hqm_credit_hist_pipe_core.aqed_chp_sch_v & hqm_credit_hist_pipe_core.aqed_chp_sch_ready & ( hqm_credit_hist_pipe_core.aqed_chp_sch_data.cq == gi ) ) begin
          aqed_chp_sch_cq_count_nxt [ gi ] = aqed_chp_sch_cq_count_f [ gi ] + 1'b1;
        end
      end
      always_ff @(posedge hqm_credit_hist_pipe_core.hqm_inp_gated_clk or negedge hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp ) begin
        if ( ~ hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp ) begin
          aqed_chp_sch_cq_count_f [ gi ] <= 32'h0 ;
        end
        else begin
          aqed_chp_sch_cq_count_f [ gi ] <= aqed_chp_sch_cq_count_nxt [ gi ] ;
        end
      end
    end

    for ( genvar gi = 0 ; gi < 64 ; gi++ ) begin
      always_comb begin
        hcw_sched_w_req_ldb_cq_count_nxt [ gi ] = hcw_sched_w_req_ldb_cq_count_f [ gi ] ;
        if ( hqm_credit_hist_pipe_core.hcw_sched_w_req_valid & hqm_credit_hist_pipe_core.hcw_sched_w_req_ready & ( hqm_credit_hist_pipe_core.hcw_sched_w_req.user.cq == gi ) ) begin
          hcw_sched_w_req_ldb_cq_count_nxt [ gi ] = hcw_sched_w_req_ldb_cq_count_f [ gi ] + ( hqm_credit_hist_pipe_core.hcw_sched_w_req.user.hqm_core_flags.cq_is_ldb == 1'd1 ) ;
        end
      end
      always_ff @(posedge hqm_credit_hist_pipe_core.hqm_inp_gated_clk or negedge hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp ) begin
        if ( ~ hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp ) begin
          hcw_sched_w_req_ldb_cq_count_f [ gi ] <= 32'h0 ;
        end
        else begin
          hcw_sched_w_req_ldb_cq_count_f [ gi ] <= hcw_sched_w_req_ldb_cq_count_nxt [ gi ] ;
        end
      end
    end

    for ( genvar gi = 0 ; gi < 96 ; gi++ ) begin
      always_comb begin
        hcw_sched_w_req_dir_cq_count_nxt [ gi ] = hcw_sched_w_req_dir_cq_count_f [ gi ] ;
        if ( hqm_credit_hist_pipe_core.hcw_sched_w_req_valid & hqm_credit_hist_pipe_core.hcw_sched_w_req_ready & ( hqm_credit_hist_pipe_core.hcw_sched_w_req.user.cq == gi ) ) begin
          hcw_sched_w_req_dir_cq_count_nxt [ gi ] = hcw_sched_w_req_dir_cq_count_f [ gi ] + ( hqm_credit_hist_pipe_core.hcw_sched_w_req.user.hqm_core_flags.cq_is_ldb == 1'd0 ) ;
        end
      end
      always_ff @(posedge hqm_credit_hist_pipe_core.hqm_inp_gated_clk or negedge hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp ) begin
        if ( ~ hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp ) begin
          hcw_sched_w_req_dir_cq_count_f [ gi ] <= 32'h0 ;
        end
        else begin
          hcw_sched_w_req_dir_cq_count_f [ gi ] <= hcw_sched_w_req_dir_cq_count_nxt [ gi ] ;
        end
      end
    end

    for ( genvar gi = 0 ; gi < 64 ; gi++ ) begin
      always_comb begin
        ldb_cq_interrupt_w_req_count_nxt [ gi ] = ldb_cq_interrupt_w_req_count_f [ gi ] ;
        if ( hqm_credit_hist_pipe_core.interrupt_w_req_valid & hqm_credit_hist_pipe_core.interrupt_w_req_ready & hqm_credit_hist_pipe_core.interrupt_w_req.is_ldb & ( hqm_credit_hist_pipe_core.interrupt_w_req.cq_occ_cq == gi ) ) begin
          ldb_cq_interrupt_w_req_count_nxt [ gi ] = ldb_cq_interrupt_w_req_count_f [ gi ] + 1'd1 ;
        end
        ldb_cq_cwdi_interrupt_w_req_count_nxt [ gi ] = ldb_cq_cwdi_interrupt_w_req_count_f [ gi ] ;
      end
      always_ff @(posedge hqm_credit_hist_pipe_core.hqm_inp_gated_clk or negedge hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp ) begin
        if ( ~ hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp ) begin
          ldb_cq_interrupt_w_req_count_f [ gi ] <= 32'd0 ;
          ldb_cq_cwdi_interrupt_w_req_count_f [ gi ] <= 32'd0 ;
        end
        else begin
          ldb_cq_interrupt_w_req_count_f [ gi ] <= ldb_cq_interrupt_w_req_count_nxt [ gi ] ;
          ldb_cq_cwdi_interrupt_w_req_count_f [ gi ] <= ldb_cq_cwdi_interrupt_w_req_count_nxt [ gi ] ;
        end
      end
    end

    for ( genvar gi = 0 ; gi < 96 ; gi++ ) begin
      always_comb begin
        dir_cq_interrupt_w_req_count_nxt [ gi ] = dir_cq_interrupt_w_req_count_f [ gi ] ;
        if ( hqm_credit_hist_pipe_core.interrupt_w_req_valid & hqm_credit_hist_pipe_core.interrupt_w_req_ready & ~ hqm_credit_hist_pipe_core.interrupt_w_req.is_ldb & ( hqm_credit_hist_pipe_core.interrupt_w_req.cq_occ_cq == gi ) ) begin
          dir_cq_interrupt_w_req_count_nxt [ gi ] = dir_cq_interrupt_w_req_count_f [ gi ] + 1'd1 ;
        end
        dir_cq_cwdi_interrupt_w_req_count_nxt [ gi ] = dir_cq_cwdi_interrupt_w_req_count_f [ gi ] ;
      end
      always_ff @(posedge hqm_credit_hist_pipe_core.hqm_inp_gated_clk or negedge hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp ) begin
        if ( ~ hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp ) begin
          dir_cq_interrupt_w_req_count_f [ gi ] <= 32'd0 ;
          dir_cq_cwdi_interrupt_w_req_count_f [ gi ] <= 32'd0 ;
        end
        else begin
          dir_cq_interrupt_w_req_count_f [ gi ] <= dir_cq_interrupt_w_req_count_nxt [ gi ] ;
          dir_cq_cwdi_interrupt_w_req_count_f [ gi ] <= dir_cq_cwdi_interrupt_w_req_count_nxt [ gi ] ;
        end
      end
    end

    for ( genvar gi = 0 ; gi < 64 ; gi++ ) begin
      always_comb begin
        chp_lsp_token_ldb_cq_count_nxt [ gi ] = chp_lsp_token_ldb_cq_count_f [ gi ] ;
        if ( hqm_credit_hist_pipe_core.chp_lsp_token_v & hqm_credit_hist_pipe_core.chp_lsp_token_ready &
             hqm_credit_hist_pipe_core.chp_lsp_token_data.is_ldb & ( hqm_credit_hist_pipe_core.chp_lsp_token_data.cq == gi ) ) begin
          chp_lsp_token_ldb_cq_count_nxt [ gi ] = chp_lsp_token_ldb_cq_count_f [ gi ] + hqm_credit_hist_pipe_core.chp_lsp_token_data.count ;
        end
      end
      always_ff @(posedge hqm_credit_hist_pipe_core.hqm_gated_clk or negedge hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp ) begin
        if ( ~ hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp ) begin
          chp_lsp_token_ldb_cq_count_f [ gi ] <= 32'h0 ;
        end
        else begin
          chp_lsp_token_ldb_cq_count_f [ gi ] <= chp_lsp_token_ldb_cq_count_nxt [ gi ] ;
        end
      end
    end

    for ( genvar gi = 0 ; gi < 96 ; gi++ ) begin
      always_comb begin
        chp_lsp_token_dir_cq_count_nxt [ gi ] = chp_lsp_token_dir_cq_count_f [ gi ] ;
        if ( hqm_credit_hist_pipe_core.chp_lsp_token_v & hqm_credit_hist_pipe_core.chp_lsp_token_ready &
             ~ hqm_credit_hist_pipe_core.chp_lsp_token_data.is_ldb & ( hqm_credit_hist_pipe_core.chp_lsp_token_data.cq == gi ) ) begin
          chp_lsp_token_dir_cq_count_nxt [ gi ] = chp_lsp_token_dir_cq_count_f [ gi ] + hqm_credit_hist_pipe_core.chp_lsp_token_data.count ;
        end
      end
      always_ff @(posedge hqm_credit_hist_pipe_core.hqm_gated_clk or negedge hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp ) begin
        if ( ~ hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp ) begin
          chp_lsp_token_dir_cq_count_f [ gi ] <= 32'h0 ;
        end
        else begin
          chp_lsp_token_dir_cq_count_f [ gi ] <= chp_lsp_token_dir_cq_count_nxt [ gi ] ;
        end
      end
    end

    for ( genvar gi = 0 ; gi < 64 ; gi++ ) begin
      always_comb begin
        chp_lsp_cmp_ldb_cq_count_nxt [ gi ] = chp_lsp_cmp_ldb_cq_count_f [ gi ] ;
        if ( hqm_credit_hist_pipe_core.chp_lsp_cmp_v & hqm_credit_hist_pipe_core.chp_lsp_cmp_ready &
             ~ hqm_credit_hist_pipe_core.chp_lsp_cmp_data.user[ 1 ] &
             ( hqm_credit_hist_pipe_core.chp_lsp_cmp_data.pp == gi ) ) begin
          chp_lsp_cmp_ldb_cq_count_nxt [ gi ] = chp_lsp_cmp_ldb_cq_count_f [ gi ] + 1'd1 ;
        end
        chp_lsp_cmp_release_ldb_cq_count_nxt [ gi ] = chp_lsp_cmp_release_ldb_cq_count_f [ gi ] ;
        if ( hqm_credit_hist_pipe_core.chp_lsp_cmp_v & hqm_credit_hist_pipe_core.chp_lsp_cmp_ready &
             hqm_credit_hist_pipe_core.chp_lsp_cmp_data.user[ 1 ] &
             ( hqm_credit_hist_pipe_core.chp_lsp_cmp_data.pp == gi ) ) begin
          chp_lsp_cmp_release_ldb_cq_count_nxt [ gi ] = chp_lsp_cmp_release_ldb_cq_count_f [ gi ] + 1'd1 ;
        end
      end
      always_ff @(posedge hqm_credit_hist_pipe_core.hqm_gated_clk or negedge hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp ) begin
        if ( ~ hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp ) begin
          chp_lsp_cmp_ldb_cq_count_f [ gi ] <= 32'h0 ;
          chp_lsp_cmp_release_ldb_cq_count_f [ gi ] <= 32'h0 ;
        end
        else begin
          chp_lsp_cmp_ldb_cq_count_f [ gi ] <= chp_lsp_cmp_ldb_cq_count_nxt [ gi ] ;
          chp_lsp_cmp_release_ldb_cq_count_f [ gi ] <= chp_lsp_cmp_release_ldb_cq_count_nxt [ gi ] ;
        end
      end
    end

    for ( genvar gi = 0 ; gi < 16 ; gi++ ) begin
      always_comb begin
        chp_alarm_up_unit_count_nxt [ gi ] = chp_alarm_up_unit_count_f [ gi ] ;
        if ( hqm_credit_hist_pipe_core.chp_alarm_up_v & hqm_credit_hist_pipe_core.chp_alarm_up_ready &
             ( hqm_credit_hist_pipe_core.chp_alarm_up_data.unit == gi ) ) begin
          chp_alarm_up_unit_count_nxt [ gi ] = chp_alarm_up_unit_count_f [ gi ] + 1'd1 ;
        end
      end
      always_ff @(posedge hqm_credit_hist_pipe_core.hqm_gated_clk or negedge hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp ) begin
        if ( ~ hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp ) begin
          chp_alarm_up_unit_count_f [ gi ] <= 32'd0 ;
        end
        else begin
          chp_alarm_up_unit_count_f [ gi ] <= chp_alarm_up_unit_count_nxt [ gi ] ;
        end
      end
    end

  endgenerate 


  always_ff @( posedge hqm_credit_hist_pipe_core.hqm_inp_gated_clk ) begin
    if ($test$plusargs("HQM_DEBUG_LOW") | $test$plusargs("HQM_DEBUG_MED") | $test$plusargs("HQM_DEBUG_HIGH")) begin

      if ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp & hqm_credit_hist_pipe_core.reset_pf_done_f & freelist_push_v) begin
        $display("@%0tps [CHP_DEBUG] hqm_chp_freelist: push flid:0x%h par:%0d bank:0x%h bflid:0x%h"
                 , $time
                 , freelist_push_data.flid
                 , freelist_push_data.flid_parity
                 , freelist_push_data.flid[13:11]
                 , freelist_push_data.flid[10:0]
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp & hqm_credit_hist_pipe_core.reset_pf_done_f & freelist_pop_v_2f) begin
        $display("@%0tps [CHP_DEBUG] hqm_chp_freelist: pop flid:0x%h par:%0d bank:0x%h bflid:0x%h"
                 , $time
                 , freelist_pop_data.flid
                 , freelist_pop_data.flid_parity
                 , freelist_pop_data.flid[13:11]
                 , freelist_pop_data.flid[10:0]
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp & hqm_credit_hist_pipe_core.unit_cfg_req_write [ HQM_CHP_TARGET_CFG_CHP_PALB_CONTROL ] ) begin
        $display("@%0tps [CHP_DEBUG] unit_cfg_req_write[%0d]: CFG_CHP_PALB_CONTROL 0x%h(enable:%d period:0x%h)"
                 , $time
                 , HQM_CHP_TARGET_CFG_CHP_PALB_CONTROL
                 , hqm_credit_hist_pipe_core.unit_cfg_req.wdata
                 , hqm_credit_hist_pipe_core.unit_cfg_req.wdata[31]
                 , hqm_credit_hist_pipe_core.unit_cfg_req.wdata[3:0]
                 );
      end
      if ( hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp & hqm_credit_hist_pipe_core.unit_cfg_req_write [ HQM_CHP_TARGET_CFG_LDB_CQ_ON_OFF_THRESHOLD ] ) begin
        $display("@%0tps [CHP_DEBUG] unit_cfg_req_write[%0d]: CFG_LDB_CQ_ON_OFF_THRESHOLD[%0d] 0x%h(off_thrsh:0x%h on_thrsh:0x%h)"
                 , $time
                 , HQM_CHP_TARGET_CFG_LDB_CQ_ON_OFF_THRESHOLD
                 , hqm_credit_hist_pipe_core.unit_cfg_req.addr.offset
                 , hqm_credit_hist_pipe_core.unit_cfg_req.wdata
                 , hqm_credit_hist_pipe_core.unit_cfg_req.wdata[30:16]
                 , hqm_credit_hist_pipe_core.unit_cfg_req.wdata[14:0]
                 );
      end
      if ( hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp & hqm_credit_hist_pipe_core.unit_cfg_req_write [ HQM_CHP_TARGET_CFG_PATCH_CONTROL ] ) begin
        $display("@%0tps [CHP_DEBUG] unit_cfg_req_write[%0d]: CFG_PATCH_CONTROL 0x%h"
                 , $time
                 , HQM_CHP_TARGET_CFG_PATCH_CONTROL
                 , hqm_credit_hist_pipe_core.unit_cfg_req.wdata
                 );
      end
      if ( hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp & hqm_credit_hist_pipe_core.unit_cfg_req_write [ HQM_CHP_TARGET_CFG_CONTROL_GENERAL_00 ] ) begin
        $display("@%0tps [CHP_DEBUG] unit_cfg_req_write[%0d]: CFG_CONTROL_GENERAL_00 0x%h"
                 , $time
                 , HQM_CHP_TARGET_CFG_CONTROL_GENERAL_00
                 , hqm_credit_hist_pipe_core.unit_cfg_req.wdata
                 );
      end
      if ( hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp & hqm_credit_hist_pipe_core.unit_cfg_req_write [ HQM_CHP_TARGET_CFG_CONTROL_GENERAL_01 ] ) begin
        $display("@%0tps [CHP_DEBUG] unit_cfg_req_write[%0d]: CFG_CONTROL_GENERAL_01 0x%h"
                 , $time
                 , HQM_CHP_TARGET_CFG_CONTROL_GENERAL_01
                 , hqm_credit_hist_pipe_core.unit_cfg_req.wdata
                 );
      end
      if ( hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp & hqm_credit_hist_pipe_core.unit_cfg_req_write [ HQM_CHP_TARGET_CFG_CONTROL_GENERAL_02 ] ) begin
        $display("@%0tps [CHP_DEBUG] unit_cfg_req_write[%0d]: CFG_CONTROL_GENERAL_02 0x%h"
                 , $time
                 , HQM_CHP_TARGET_CFG_CONTROL_GENERAL_02
                 , hqm_credit_hist_pipe_core.unit_cfg_req.wdata
                 );
      end
      if ( hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp & hqm_credit_hist_pipe_core.unit_cfg_req_write [ HQM_CHP_TARGET_CFG_HW_AGITATE_SELECT ] ) begin
        $display("@%0tps [CHP_DEBUG] unit_cfg_req_write[%0d]: CFG_HW_AGITATE_SELECT 0x%h"
                 , $time
                 , HQM_CHP_TARGET_CFG_HW_AGITATE_SELECT
                 , hqm_credit_hist_pipe_core.unit_cfg_req.wdata
                 );
      end
      if ( hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp & hqm_credit_hist_pipe_core.unit_cfg_req_write [ HQM_CHP_TARGET_CFG_HW_AGITATE_CONTROL ] ) begin
        $display("@%0tps [CHP_DEBUG] unit_cfg_req_write[%0d]: CFG_HW_AGITATE_CONTROL 0x%h"
                 , $time
                 , HQM_CHP_TARGET_CFG_HW_AGITATE_CONTROL
                 , hqm_credit_hist_pipe_core.unit_cfg_req.wdata
                 );
      end
      if ( hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp & hqm_credit_hist_pipe_core.unit_cfg_req_write [ HQM_CHP_TARGET_CFG_VAS_CREDIT_COUNT ] ) begin
        $display("@%0tps [CHP_DEBUG] unit_cfg_req_write[%0d]: VAS_CREDIT_COUNT[%0d] 0x%h"
                 , $time
                 , HQM_CHP_TARGET_CFG_VAS_CREDIT_COUNT
                 , hqm_credit_hist_pipe_core.unit_cfg_req.addr.offset
                 , hqm_credit_hist_pipe_core.unit_cfg_req.wdata
                 );
      end
      if ( hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp & hqm_credit_hist_pipe_core.unit_cfg_req_write [ HQM_CHP_TARGET_CFG_CMP_SN_CHK_ENBL ] ) begin
        $display("@%0tps [CHP_DEBUG] unit_cfg_req_write[%0d]: CFG_CMP_SN_CHK_ENBL[%0d] 0x%h"
                 , $time
                 , HQM_CHP_TARGET_CFG_CMP_SN_CHK_ENBL 
                 , hqm_credit_hist_pipe_core.unit_cfg_req.addr.offset
                 , hqm_credit_hist_pipe_core.unit_cfg_req.wdata
                 );
      end
      if ( hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp & hqm_credit_hist_pipe_core.unit_cfg_req_write [ HQM_CHP_TARGET_CFG_DIR_CQ_TOKEN_DEPTH_SELECT ] ) begin
        $display("@%0tps [CHP_DEBUG] unit_cfg_req_write[%0d]: CFG_DIR_CQ_TOKEN_DEPTH_SELECT[%0d] 0x%h"
                 , $time
                 , HQM_CHP_TARGET_CFG_DIR_CQ_TOKEN_DEPTH_SELECT 
                 , hqm_credit_hist_pipe_core.unit_cfg_req.addr.offset
                 , hqm_credit_hist_pipe_core.unit_cfg_req.wdata
                 );
      end
      if ( hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp & hqm_credit_hist_pipe_core.unit_cfg_req_write [ HQM_CHP_TARGET_CFG_DIR_CQ_DEPTH ] ) begin
        $display("@%0tps [CHP_DEBUG] unit_cfg_req_write[%0d]: CFG_DIR_CQ_DEPTH[%0d] 0x%h"
                 , $time
                 , HQM_CHP_TARGET_CFG_DIR_CQ_DEPTH 
                 , hqm_credit_hist_pipe_core.unit_cfg_req.addr.offset
                 , hqm_credit_hist_pipe_core.unit_cfg_req.wdata
                 );
      end
      if ( hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp & hqm_credit_hist_pipe_core.unit_cfg_req_write [ HQM_CHP_TARGET_CFG_DIR_CQ_WPTR ] ) begin
        $display("@%0tps [CHP_DEBUG] unit_cfg_req_write[%0d]: CFG_DIR_CQ_WPTR[%0d] 0x%h"
                 , $time
                 , HQM_CHP_TARGET_CFG_DIR_CQ_WPTR 
                 , hqm_credit_hist_pipe_core.unit_cfg_req.addr.offset
                 , hqm_credit_hist_pipe_core.unit_cfg_req.wdata
                 );
      end
      if ( hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp & hqm_credit_hist_pipe_core.unit_cfg_req_write [ HQM_CHP_TARGET_CFG_LDB_CQ_TOKEN_DEPTH_SELECT ] ) begin
        $display("@%0tps [CHP_DEBUG] unit_cfg_req_write[%0d]: CFG_LDB_CQ_TOKEN_DEPTH_SELECT[%0d] 0x%h"
                 , $time
                 , HQM_CHP_TARGET_CFG_LDB_CQ_TOKEN_DEPTH_SELECT 
                 , hqm_credit_hist_pipe_core.unit_cfg_req.addr.offset
                 , hqm_credit_hist_pipe_core.unit_cfg_req.wdata
                 );
      end
      if ( hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp & hqm_credit_hist_pipe_core.unit_cfg_req_write [ HQM_CHP_TARGET_CFG_LDB_CQ_DEPTH ] ) begin
        $display("@%0tps [CHP_DEBUG] unit_cfg_req_write[%0d]: CFG_LDB_CQ_DEPTH[%0d] 0x%h"
                 , $time
                 , HQM_CHP_TARGET_CFG_LDB_CQ_DEPTH 
                 , hqm_credit_hist_pipe_core.unit_cfg_req.addr.offset
                 , hqm_credit_hist_pipe_core.unit_cfg_req.wdata
                 );
      end
      if ( hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp & hqm_credit_hist_pipe_core.unit_cfg_req_write [ HQM_CHP_TARGET_CFG_LDB_CQ_WPTR ] ) begin
        $display("@%0tps [CHP_DEBUG] unit_cfg_req_write[%0d]: CFG_LDB_CQ_WPTR[%0d] 0x%h"
                 , $time
                 , HQM_CHP_TARGET_CFG_LDB_CQ_WPTR 
                 , hqm_credit_hist_pipe_core.unit_cfg_req.addr.offset
                 , hqm_credit_hist_pipe_core.unit_cfg_req.wdata
                 );
      end
      if ( hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp & hqm_credit_hist_pipe_core.unit_cfg_req_write [ HQM_CHP_TARGET_CFG_HIST_LIST_PUSH_PTR ] ) begin
        $display("@%0tps [CHP_DEBUG] unit_cfg_req_write[%0d]: CFG_HIST_LIST_PUSH_PTR[%0d] 0x%h"
                 , $time
                 , HQM_CHP_TARGET_CFG_HIST_LIST_PUSH_PTR 
                 , hqm_credit_hist_pipe_core.unit_cfg_req.addr.offset
                 , hqm_credit_hist_pipe_core.unit_cfg_req.wdata
                 );
      end
      if ( hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp & hqm_credit_hist_pipe_core.unit_cfg_req_write [ HQM_CHP_TARGET_CFG_HIST_LIST_POP_PTR ] ) begin
        $display("@%0tps [CHP_DEBUG] unit_cfg_req_write[%0d]: CFG_HIST_LIST_POP_PTR[%0d] 0x%h"
                 , $time
                 , HQM_CHP_TARGET_CFG_HIST_LIST_POP_PTR 
                 , hqm_credit_hist_pipe_core.unit_cfg_req.addr.offset
                 , hqm_credit_hist_pipe_core.unit_cfg_req.wdata
                 );
      end
      if ( hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp & hqm_credit_hist_pipe_core.unit_cfg_req_write [ HQM_CHP_TARGET_CFG_HIST_LIST_LIMIT ] ) begin
        $display("@%0tps [CHP_DEBUG] unit_cfg_req_write[%0d]: CFG_HIST_LIST_LIMIT[%0d] 0x%h"
                 , $time
                 , HQM_CHP_TARGET_CFG_HIST_LIST_LIMIT 
                 , hqm_credit_hist_pipe_core.unit_cfg_req.addr.offset
                 , hqm_credit_hist_pipe_core.unit_cfg_req.wdata
                 );
      end
      if ( hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp & hqm_credit_hist_pipe_core.unit_cfg_req_write [ HQM_CHP_TARGET_CFG_HIST_LIST_BASE ] ) begin
        $display("@%0tps [CHP_DEBUG] unit_cfg_req_write[%0d]: CFG_HIST_LIST_BASE[%0d] 0x%h"
                 , $time
                 , HQM_CHP_TARGET_CFG_HIST_LIST_BASE 
                 , hqm_credit_hist_pipe_core.unit_cfg_req.addr.offset
                 , hqm_credit_hist_pipe_core.unit_cfg_req.wdata
                 );
      end
      if ( hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp & hqm_credit_hist_pipe_core.unit_cfg_req_write [ HQM_CHP_TARGET_CFG_HIST_LIST_A_PUSH_PTR ] ) begin
        $display("@%0tps [CHP_DEBUG] unit_cfg_req_write[%0d]: CFG_HIST_LIST_A_PUSH_PTR[%0d] 0x%h"
                 , $time
                 , HQM_CHP_TARGET_CFG_HIST_LIST_A_PUSH_PTR 
                 , hqm_credit_hist_pipe_core.unit_cfg_req.addr.offset
                 , hqm_credit_hist_pipe_core.unit_cfg_req.wdata
                 );
      end
      if ( hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp & hqm_credit_hist_pipe_core.unit_cfg_req_write [ HQM_CHP_TARGET_CFG_HIST_LIST_A_POP_PTR ] ) begin
        $display("@%0tps [CHP_DEBUG] unit_cfg_req_write[%0d]: CFG_HIST_LIST_A_POP_PTR[%0d] 0x%h"
                 , $time
                 , HQM_CHP_TARGET_CFG_HIST_LIST_A_POP_PTR 
                 , hqm_credit_hist_pipe_core.unit_cfg_req.addr.offset
                 , hqm_credit_hist_pipe_core.unit_cfg_req.wdata
                 );
      end
      if ( hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp & hqm_credit_hist_pipe_core.unit_cfg_req_write [ HQM_CHP_TARGET_CFG_HIST_LIST_A_LIMIT ] ) begin
        $display("@%0tps [CHP_DEBUG] unit_cfg_req_write[%0d]: CFG_HIST_LIST_A_LIMIT[%0d] 0x%h"
                 , $time
                 , HQM_CHP_TARGET_CFG_HIST_LIST_A_LIMIT 
                 , hqm_credit_hist_pipe_core.unit_cfg_req.addr.offset
                 , hqm_credit_hist_pipe_core.unit_cfg_req.wdata
                 );
      end
      if ( hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp & hqm_credit_hist_pipe_core.unit_cfg_req_write [ HQM_CHP_TARGET_CFG_HIST_LIST_A_BASE ] ) begin
        $display("@%0tps [CHP_DEBUG] unit_cfg_req_write[%0d]: CFG_HIST_LIST_A_BASE[%0d] 0x%h"
                 , $time
                 , HQM_CHP_TARGET_CFG_HIST_LIST_A_BASE 
                 , hqm_credit_hist_pipe_core.unit_cfg_req.addr.offset
                 , hqm_credit_hist_pipe_core.unit_cfg_req.wdata
                 );
      end
      if ( hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp & hqm_credit_hist_pipe_core.unit_cfg_req_write [ HQM_CHP_TARGET_CFG_DIR_CQ_INT_ENB ] ) begin
        $display("@%0tps [CHP_DEBUG] unit_cfg_req_write[%0d]: CFG_DIR_CQ_INT_ENB[%0d] 0x%h"
                 , $time
                 , HQM_CHP_TARGET_CFG_DIR_CQ_INT_ENB 
                 , hqm_credit_hist_pipe_core.unit_cfg_req.addr.offset
                 , hqm_credit_hist_pipe_core.unit_cfg_req.wdata
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp & hqm_credit_hist_pipe_core.unit_cfg_req_write [ HQM_CHP_TARGET_CFG_DIR_CQ_INT_DEPTH_THRSH ] ) begin
        $display("@%0tps [CHP_DEBUG] unit_cfg_req_write[%0d]: CFG_DIR_CQ_INT_DEPTH_THRSH[%0d] 0x%h"
                 , $time
                 , HQM_CHP_TARGET_CFG_DIR_CQ_INT_DEPTH_THRSH
                 , hqm_credit_hist_pipe_core.unit_cfg_req.addr.offset
                 , hqm_credit_hist_pipe_core.unit_cfg_req.wdata
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp & hqm_credit_hist_pipe_core.unit_cfg_req_write [ HQM_CHP_TARGET_CFG_DIR_CQ_TIMER_THRESHOLD ] ) begin
        $display("@%0tps [CHP_DEBUG] unit_cfg_req_write[%0d]: CFG_DIR_CQ_TIMER_THRSESHOLD[%0d] 0x%h"
                 , $time
                 , HQM_CHP_TARGET_CFG_DIR_CQ_TIMER_THRESHOLD
                 , hqm_credit_hist_pipe_core.unit_cfg_req.addr.offset
                 , hqm_credit_hist_pipe_core.unit_cfg_req.wdata
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp & hqm_credit_hist_pipe_core.unit_cfg_req_write [ HQM_CHP_TARGET_CFG_DIR_CQ_TIMER_CTL ] ) begin
        $display("@%0tps [CHP_DEBUG] unit_cfg_req_write[%0d]: CFG_DIR_CQ_TIMER_CTL[%0d] 0x%h (enb: %0d sample_interval: %0d)"
                 , $time
                 , HQM_CHP_TARGET_CFG_DIR_CQ_TIMER_CTL
                 , hqm_credit_hist_pipe_core.unit_cfg_req.addr.offset
                 , hqm_credit_hist_pipe_core.unit_cfg_req.wdata
                 , hqm_credit_hist_pipe_core.unit_cfg_req.wdata[8]
                 , hqm_credit_hist_pipe_core.unit_cfg_req.wdata[7:0]
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp & hqm_credit_hist_pipe_core.unit_cfg_req_write [ HQM_CHP_TARGET_CFG_LDB_CQ_INT_ENB ] ) begin
        $display("@%0tps [CHP_DEBUG] unit_cfg_req_write[%0d]: CFG_LDB_CQ_INT_ENB[%0d] 0x%h"
                 , $time
                 , HQM_CHP_TARGET_CFG_LDB_CQ_INT_ENB 
                 , hqm_credit_hist_pipe_core.unit_cfg_req.addr.offset
                 , hqm_credit_hist_pipe_core.unit_cfg_req.wdata
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp & hqm_credit_hist_pipe_core.unit_cfg_req_write [ HQM_CHP_TARGET_CFG_LDB_CQ_INT_DEPTH_THRSH ] ) begin
        $display("@%0tps [CHP_DEBUG] unit_cfg_req_write[%0d]: CFG_DIR_CQ_INT_DEPTH_THRSH[%0d] 0x%h"
                 , $time
                 , HQM_CHP_TARGET_CFG_LDB_CQ_INT_DEPTH_THRSH
                 , hqm_credit_hist_pipe_core.unit_cfg_req.addr.offset
                 , hqm_credit_hist_pipe_core.unit_cfg_req.wdata
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp & hqm_credit_hist_pipe_core.unit_cfg_req_write [ HQM_CHP_TARGET_CFG_LDB_CQ_TIMER_THRESHOLD ] ) begin
        $display("@%0tps [CHP_DEBUG] unit_cfg_req_write[%0d]: CFG_LDB_CQ_TIMER_THRSESHOLD[%0d] 0x%h"
                 , $time
                 , HQM_CHP_TARGET_CFG_LDB_CQ_TIMER_THRESHOLD
                 , hqm_credit_hist_pipe_core.unit_cfg_req.addr.offset
                 , hqm_credit_hist_pipe_core.unit_cfg_req.wdata
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp & hqm_credit_hist_pipe_core.unit_cfg_req_write [ HQM_CHP_TARGET_CFG_LDB_CQ_TIMER_CTL ] ) begin
        $display("@%0tps [CHP_DEBUG] unit_cfg_req_write[%0d]: CFG_LDB_CQ_TIMER_CTL[%0d] 0x%h (enb: %0d sample_interval: %0d)"
                 , $time
                 , HQM_CHP_TARGET_CFG_LDB_CQ_TIMER_CTL
                 , hqm_credit_hist_pipe_core.unit_cfg_req.addr.offset
                 , hqm_credit_hist_pipe_core.unit_cfg_req.wdata
                 , hqm_credit_hist_pipe_core.unit_cfg_req.wdata[8]
                 , hqm_credit_hist_pipe_core.unit_cfg_req.wdata[7:0]
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp & hqm_credit_hist_pipe_core.unit_cfg_req_write [ HQM_CHP_TARGET_CFG_DIR_WD_DISABLE0 ] ) begin
        $display("@%0tps [CHP_DEBUG] unit_cfg_req_write[%0d]: CFG_DIR_WD_DISABLE0 0x%h"
                 , $time
                 , HQM_CHP_TARGET_CFG_DIR_WD_DISABLE0
                 , hqm_credit_hist_pipe_core.unit_cfg_req.wdata
                 );
      end

// START comment out this code section for NUM_DIR_CQ 32
/* */
      if ( hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp & hqm_credit_hist_pipe_core.unit_cfg_req_write [ HQM_CHP_TARGET_CFG_DIR_WD_DISABLE1 ] ) begin
        $display("@%0tps [CHP_DEBUG] unit_cfg_req_write[%0d]: CFG_DIR_WD_DISABLE1 0x%h"
                 , $time
                 , HQM_CHP_TARGET_CFG_DIR_WD_DISABLE1
                 , hqm_credit_hist_pipe_core.unit_cfg_req.wdata
                 );
      end
/* */
// END comment out this code section for NUM_DIR_CQ 32

// START comment out this code section for NUM_DIR_CQ 32 or 64
/*
      if ( hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp & hqm_credit_hist_pipe_core.unit_cfg_req_write [ HQM_CHP_TARGET_CFG_DIR_WD_DISABLE2 ] ) begin
        $display("@%0tps [CHP_DEBUG] unit_cfg_req_write[%0d]: CFG_DIR_WD_DISABLE2 0x%h"
                 , $time
                 , HQM_CHP_TARGET_CFG_DIR_WD_DISABLE2
                 , hqm_credit_hist_pipe_core.unit_cfg_req.wdata
                 );
      end
*/
// END comment out this code section for NUM_DIR_CQ 32

      if ( hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp & hqm_credit_hist_pipe_core.unit_cfg_req_write [ HQM_CHP_TARGET_CFG_DIR_WD_ENB_INTERVAL ] ) begin
        $display("@%0tps [CHP_DEBUG] unit_cfg_req_write[%0d]: CFG_DIR_WD_ENB_INTERVAL 0x%h"
                 , $time
                 , HQM_CHP_TARGET_CFG_DIR_WD_ENB_INTERVAL
                 , hqm_credit_hist_pipe_core.unit_cfg_req.wdata
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp & hqm_credit_hist_pipe_core.unit_cfg_req_write [ HQM_CHP_TARGET_CFG_DIR_WD_THRESHOLD ] ) begin
        $display("@%0tps [CHP_DEBUG] unit_cfg_req_write[%0d]: CFG_DIR_WD_THRESHOLD 0x%h"
                 , $time
                 , HQM_CHP_TARGET_CFG_DIR_WD_THRESHOLD
                 , hqm_credit_hist_pipe_core.unit_cfg_req.wdata
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp & hqm_credit_hist_pipe_core.unit_cfg_req_write [ HQM_CHP_TARGET_CFG_DIR_CQ_WD_ENB ] ) begin
        $display("@%0tps [CHP_DEBUG] unit_cfg_req_write[%0d]: CFG_DIR_CQ_WD_ENB[%0d] 0x%h"
                 , $time
                 , HQM_CHP_TARGET_CFG_DIR_CQ_WD_ENB
                 , hqm_credit_hist_pipe_core.unit_cfg_req.addr.offset
                 , hqm_credit_hist_pipe_core.unit_cfg_req.wdata
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp & hqm_credit_hist_pipe_core.unit_cfg_req_write [ HQM_CHP_TARGET_CFG_LDB_WD_DISABLE0 ] ) begin
        $display("@%0tps [CHP_DEBUG] unit_cfg_req_write[%0d]: CFG_LDB_WD_DISABLE0 0x%h"
                 , $time
                 , HQM_CHP_TARGET_CFG_LDB_WD_DISABLE0
                 , hqm_credit_hist_pipe_core.unit_cfg_req.wdata
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp & hqm_credit_hist_pipe_core.unit_cfg_req_write [ HQM_CHP_TARGET_CFG_LDB_WD_DISABLE1 ] ) begin
        $display("@%0tps [CHP_DEBUG] unit_cfg_req_write[%0d]: CFG_LDB_WD_DISABLE1 0x%h"
                 , $time
                 , HQM_CHP_TARGET_CFG_LDB_WD_DISABLE1
                 , hqm_credit_hist_pipe_core.unit_cfg_req.wdata
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp & hqm_credit_hist_pipe_core.unit_cfg_req_write [ HQM_CHP_TARGET_CFG_LDB_WD_ENB_INTERVAL ] ) begin
        $display("@%0tps [CHP_DEBUG] unit_cfg_req_write[%0d]: CFG_LDB_WD_ENB_INTERVAL 0x%h"
                 , $time
                 , HQM_CHP_TARGET_CFG_LDB_WD_ENB_INTERVAL
                 , hqm_credit_hist_pipe_core.unit_cfg_req.wdata
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp & hqm_credit_hist_pipe_core.unit_cfg_req_write [ HQM_CHP_TARGET_CFG_LDB_WD_THRESHOLD ] ) begin
        $display("@%0tps [CHP_DEBUG] unit_cfg_req_write[%0d]: CFG_LDB_WD_THRESHOLD 0x%h"
                 , $time
                 , HQM_CHP_TARGET_CFG_LDB_WD_THRESHOLD
                 , hqm_credit_hist_pipe_core.unit_cfg_req.wdata
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp & hqm_credit_hist_pipe_core.unit_cfg_req_write [ HQM_CHP_TARGET_CFG_LDB_CQ_WD_ENB ] ) begin
        $display("@%0tps [CHP_DEBUG] unit_cfg_req_write[%0d]: CFG_LDB_CQ_WD_ENB[%0d] 0x%h"
                 , $time
                 , HQM_CHP_TARGET_CFG_LDB_CQ_WD_ENB
                 , hqm_credit_hist_pipe_core.unit_cfg_req.addr.offset
                 , hqm_credit_hist_pipe_core.unit_cfg_req.wdata
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp & hqm_credit_hist_pipe_core.unit_cfg_req_write [ HQM_CHP_TARGET_CFG_LDB_CQ2VAS ] ) begin
        $display("@%0tps [CHP_DEBUG] unit_cfg_req_write[%0d]: CFG_LDB_CQ2VAS[%0d] 0x%h"
                 , $time
                 , HQM_CHP_TARGET_CFG_LDB_CQ2VAS 
                 , hqm_credit_hist_pipe_core.unit_cfg_req.addr.offset
                 , hqm_credit_hist_pipe_core.unit_cfg_req.wdata
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp & hqm_credit_hist_pipe_core.unit_cfg_req_write [ HQM_CHP_TARGET_CFG_DIR_CQ2VAS ] ) begin
        $display("@%0tps [CHP_DEBUG] unit_cfg_req_write[%0d]: CFG_DIR_CQ2VAS[%0d] 0x%h"
                 , $time
                 , HQM_CHP_TARGET_CFG_DIR_CQ2VAS 
                 , hqm_credit_hist_pipe_core.unit_cfg_req.addr.offset
                 , hqm_credit_hist_pipe_core.unit_cfg_req.wdata
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp & hqm_credit_hist_pipe_core.unit_cfg_req_write [ HQM_CHP_TARGET_CFG_ORD_QID_SN_MAP ] ) begin
        $display("@%0tps [CHP_DEBUG] unit_cfg_req_write[%0d]: CFG_ORD_QID_SN_MAP[%0d] 0x%h"
                 , $time
                 , HQM_CHP_TARGET_CFG_ORD_QID_SN_MAP 
                 , hqm_credit_hist_pipe_core.unit_cfg_req.addr.offset
                 , hqm_credit_hist_pipe_core.unit_cfg_req.wdata
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp & hqm_credit_hist_pipe_core.chp_cfg_rsp_down_ack & ( hqm_credit_hist_pipe_core.chp_cfg_rsp_down.uid == CHP_UNIT ) ) begin
        if ( ( hqm_credit_hist_pipe_core.chp_cfg_req_up.addr.node == CHP_NODE ) & ( hqm_credit_hist_pipe_core.chp_cfg_req_up.addr.target == HQM_CHP_CFG_UNIT_TGT_MAP [ ( HQM_CHP_TARGET_CFG_LDB_WDTO_0 * 16 ) +: 16 ] ) ) begin
          $display("@%0tps [CHP_DEBUG] chp_cfg_rsp_down: CFG_LDB_WDTO_0 0x%h"
                   , $time
                   , hqm_credit_hist_pipe_core.chp_cfg_rsp_down.rdata
                   );
        end

        if ( ( hqm_credit_hist_pipe_core.chp_cfg_req_up.addr.node == CHP_NODE ) & ( hqm_credit_hist_pipe_core.chp_cfg_req_up.addr.target == HQM_CHP_CFG_UNIT_TGT_MAP [ ( HQM_CHP_TARGET_CFG_LDB_WDTO_1 * 16 ) +: 16 ] ) ) begin
          $display("@%0tps [CHP_DEBUG] chp_cfg_rsp_down: CFG_LDB_WDTO_1 0x%h"
                   , $time
                   , hqm_credit_hist_pipe_core.chp_cfg_rsp_down.rdata
                   );
        end

        if ( ( hqm_credit_hist_pipe_core.chp_cfg_req_up.addr.node == CHP_NODE ) & ( hqm_credit_hist_pipe_core.chp_cfg_req_up.addr.target == HQM_CHP_CFG_UNIT_TGT_MAP [ ( HQM_CHP_TARGET_CFG_DIR_WDTO_0 * 16 ) +: 16 ] ) ) begin
          $display("@%0tps [CHP_DEBUG] chp_cfg_rsp_down: CFG_DIR_WDTO_0 0x%h"
                   , $time
                   , hqm_credit_hist_pipe_core.chp_cfg_rsp_down.rdata
                   );
        end

// START comment out this code section for NUM_DIR_CQ 32
/* */
        if ( ( hqm_credit_hist_pipe_core.chp_cfg_req_up.addr.node == CHP_NODE ) & ( hqm_credit_hist_pipe_core.chp_cfg_req_up.addr.target == HQM_CHP_CFG_UNIT_TGT_MAP [ ( HQM_CHP_TARGET_CFG_DIR_WDTO_1 * 16 ) +: 16 ] ) ) begin
          $display("@%0tps [CHP_DEBUG] chp_cfg_rsp_down: CFG_DIR_WDTO_1 0x%h"
                   , $time
                   , hqm_credit_hist_pipe_core.chp_cfg_rsp_down.rdata
                   );
        end
/* */
// END comment out this code section for NUM_DIR_CQ 32

// START comment out this code section for NUM_DIR_CQ 32 or 64
/*
        if ( ( hqm_credit_hist_pipe_core.chp_cfg_req_up.addr.node == CHP_NODE ) & ( hqm_credit_hist_pipe_core.chp_cfg_req_up.addr.target == HQM_CHP_CFG_UNIT_TGT_MAP [ ( HQM_CHP_TARGET_CFG_DIR_WDTO_2 * 16 ) +: 16 ] ) ) begin
          $display("@%0tps [CHP_DEBUG] chp_cfg_rsp_down: CFG_DIR_WDTO_2 0x%h"
                   , $time
                   , hqm_credit_hist_pipe_core.chp_cfg_rsp_down.rdata
                   );
        end
*/
// END comment out this code section for NUM_DIR_CQ 32 or 64

        if ( ( hqm_credit_hist_pipe_core.chp_cfg_req_up.addr.node == CHP_NODE ) & ( hqm_credit_hist_pipe_core.chp_cfg_req_up.addr.target == HQM_CHP_CFG_UNIT_TGT_MAP [ ( HQM_CHP_TARGET_CFG_LDB_CQ_INTR_ARMED0 * 16 ) +: 16 ] ) ) begin
          $display("@%0tps [CHP_DEBUG] chp_cfg_rsp_down: CFG_LDB_CQ_INTR_ARMED0 0x%h"
                   , $time
                   , hqm_credit_hist_pipe_core.chp_cfg_rsp_down.rdata
                   );
        end

        if ( ( hqm_credit_hist_pipe_core.chp_cfg_req_up.addr.node == CHP_NODE ) & ( hqm_credit_hist_pipe_core.chp_cfg_req_up.addr.target == HQM_CHP_CFG_UNIT_TGT_MAP [ ( HQM_CHP_TARGET_CFG_LDB_CQ_INTR_ARMED1 * 16 ) +: 16 ] ) ) begin
          $display("@%0tps [CHP_DEBUG] chp_cfg_rsp_down: CFG_LDB_CQ_INTR_ARMED1 0x%h"
                   , $time
                   , hqm_credit_hist_pipe_core.chp_cfg_rsp_down.rdata
                   );
        end

        if ( ( hqm_credit_hist_pipe_core.chp_cfg_req_up.addr.node == CHP_NODE ) & ( hqm_credit_hist_pipe_core.chp_cfg_req_up.addr.target == HQM_CHP_CFG_UNIT_TGT_MAP [ ( HQM_CHP_TARGET_CFG_DIR_CQ_INTR_ARMED0 * 16 ) +: 16 ] ) ) begin
          $display("@%0tps [CHP_DEBUG] chp_cfg_rsp_down: CFG_DIR_CQ_INTR_ARMED0 0x%h"
                   , $time
                   , hqm_credit_hist_pipe_core.chp_cfg_rsp_down.rdata
                   );
        end

// START comment out this code section for NUM_DIR_CQ 32
/* */
        if ( ( hqm_credit_hist_pipe_core.chp_cfg_req_up.addr.node == CHP_NODE ) & ( hqm_credit_hist_pipe_core.chp_cfg_req_up.addr.target == HQM_CHP_CFG_UNIT_TGT_MAP [ ( HQM_CHP_TARGET_CFG_DIR_CQ_INTR_ARMED1 * 16 ) +: 16 ] ) ) begin
          $display("@%0tps [CHP_DEBUG] chp_cfg_rsp_down: CFG_DIR_CQ_INTR_ARMED1 0x%h"
                   , $time
                   , hqm_credit_hist_pipe_core.chp_cfg_rsp_down.rdata
                   );
        end
/* */
// END comment out this code section for NUM_DIR_CQ 32

// START comment out this code section for NUM_DIR_CQ 32 or 64
/*
        if ( ( hqm_credit_hist_pipe_core.chp_cfg_req_up.addr.node == CHP_NODE ) & ( hqm_credit_hist_pipe_core.chp_cfg_req_up.addr.target == HQM_CHP_CFG_UNIT_TGT_MAP [ ( HQM_CHP_TARGET_CFG_DIR_CQ_INTR_ARMED2 * 16 ) +: 16 ] ) ) begin
          $display("@%0tps [CHP_DEBUG] chp_cfg_rsp_down: CFG_DIR_CQ_INTR_ARMED2 0x%h"
                   , $time
                   , hqm_credit_hist_pipe_core.chp_cfg_rsp_down.rdata
                   );
        end
*/
// END comment out this code section for NUM_DIR_CQ 32 or 64
      end

      if ( hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp & 
           hqm_credit_hist_pipe_core.interrupt_w_req_valid & hqm_credit_hist_pipe_core.interrupt_w_req_ready ) begin
        $display("@%0tps [CHP_DEBUG] interrupt_w_req: parity:%d is_ldb:%d cq_occ_cq:0x%h\n"
                 , $time
                 , hqm_credit_hist_pipe_core.interrupt_w_req.parity
                 , hqm_credit_hist_pipe_core.interrupt_w_req.is_ldb
                 , hqm_credit_hist_pipe_core.interrupt_w_req.cq_occ_cq
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp & 
           hqm_credit_hist_pipe_core.cwdi_interrupt_w_req_valid & hqm_credit_hist_pipe_core.cwdi_interrupt_w_req_ready ) begin
        $display("@%0tps [CHP_DEBUG] cwdi_interrupt_w_req: ldb_wdto:0x%h_%h dir_wdto:0x%h_%h\n"
                 , $time
                 , hqm_credit_hist_pipe_core.ldb_wdto_f_nc[63:32]
                 , hqm_credit_hist_pipe_core.ldb_wdto_f_nc[31:0]
                 , hqm_credit_hist_pipe_core.dir_wdto_f_nc[63:32]
                 , hqm_credit_hist_pipe_core.dir_wdto_f_nc[31:0]
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp & 
           hqm_credit_hist_pipe_core.hcw_enq_w_req_valid & hqm_credit_hist_pipe_core.hcw_enq_w_req_ready ) begin
        $display("@%0tps [CHP_DEBUG] hcw_enq_w_req: user(par:%d ao_v:%d vas:0x%h pp_is_ldb:%d pp:0x%h qe_is_ldb:%d qid:0x%h insert_ts:%d hcw_par:%h) data:0x%h_%h(hcw_cmd:%s, qtype:%s)"
                 , $time
                 , hqm_credit_hist_pipe_core.hcw_enq_w_req.user.parity
                 , hqm_credit_hist_pipe_core.hcw_enq_w_req.user.ao_v
                 , hqm_credit_hist_pipe_core.hcw_enq_w_req.user.vas
                 , hqm_credit_hist_pipe_core.hcw_enq_w_req.user.pp_is_ldb
                 , hqm_credit_hist_pipe_core.hcw_enq_w_req.user.pp
                 , hqm_credit_hist_pipe_core.hcw_enq_w_req.user.qe_is_ldb
                 , hqm_credit_hist_pipe_core.hcw_enq_w_req.user.qid
                 , hqm_credit_hist_pipe_core.hcw_enq_w_req.user.insert_timestamp
                 , hqm_credit_hist_pipe_core.hcw_enq_w_req.user.hcw_parity
                 , hqm_credit_hist_pipe_core.hcw_enq_w_req.data [ 127 : 64 ]
                 , hqm_credit_hist_pipe_core.hcw_enq_w_req.data[ 63 : 0 ]
                 , hqm_credit_hist_pipe_core.hcw_enq_w_req.data.cmd.hcw_cmd_dec.name
                 , hqm_credit_hist_pipe_core.hcw_enq_w_req.data.msg_info.qtype.name
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp & 
           hqm_credit_hist_pipe_core.qed_chp_sch_v & hqm_credit_hist_pipe_core.qed_chp_sch_ready ) begin
        $display("@%0tps [CHP_DEBUG] qed_chp_sch: cmd:%s par:%d cq:0x%h qidix:0x%h flid_par:%d flid:0x%h flags:0x%h(cq_is_ldb:%d ignore_cq_depth:%d) cq_hcw_ecc:0x%h cq_hcw:0x%h_%h"
                 , $time
                 , hqm_credit_hist_pipe_core.qed_chp_sch_data.cmd.name
                 , hqm_credit_hist_pipe_core.qed_chp_sch_data.parity
                 , hqm_credit_hist_pipe_core.qed_chp_sch_data.cq
                 , hqm_credit_hist_pipe_core.qed_chp_sch_data.qidix
                 , hqm_credit_hist_pipe_core.qed_chp_sch_data.flid_parity
                 , hqm_credit_hist_pipe_core.qed_chp_sch_data.flid
                 , hqm_credit_hist_pipe_core.qed_chp_sch_data.hqm_core_flags
                 , hqm_credit_hist_pipe_core.qed_chp_sch_data.hqm_core_flags.cq_is_ldb
                 , hqm_credit_hist_pipe_core.qed_chp_sch_data.hqm_core_flags.ignore_cq_depth
                 , hqm_credit_hist_pipe_core.qed_chp_sch_data.cq_hcw_ecc
                 , hqm_credit_hist_pipe_core.qed_chp_sch_data.cq_hcw [ 122 : 64 ]
                 , hqm_credit_hist_pipe_core.qed_chp_sch_data.cq_hcw [ 63 : 0 ]
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp & 
           hqm_credit_hist_pipe_core.aqed_chp_sch_v & hqm_credit_hist_pipe_core.aqed_chp_sch_ready ) begin
        $display("@%0tps [CHP_DEBUG] aqed_chp_sch: par:%d cq:0x%h qid:0x%h qidix:0x%h fid_par:%d fid:0x%h flags:0x%h(cq_is_ldb:%d ignore_cq_depth:%d) cq_hcw_ecc:0x%h cq_hcw:0x%h_%h"
                 , $time
                 , hqm_credit_hist_pipe_core.aqed_chp_sch_data.parity
                 , hqm_credit_hist_pipe_core.aqed_chp_sch_data.cq
                 , hqm_credit_hist_pipe_core.aqed_chp_sch_data.qid
                 , hqm_credit_hist_pipe_core.aqed_chp_sch_data.qidix
                 , hqm_credit_hist_pipe_core.aqed_chp_sch_data.fid_parity
                 , hqm_credit_hist_pipe_core.aqed_chp_sch_data.fid
                 , hqm_credit_hist_pipe_core.aqed_chp_sch_data.hqm_core_flags
                 , hqm_credit_hist_pipe_core.aqed_chp_sch_data.hqm_core_flags.cq_is_ldb
                 , hqm_credit_hist_pipe_core.aqed_chp_sch_data.hqm_core_flags.ignore_cq_depth
                 , hqm_credit_hist_pipe_core.aqed_chp_sch_data.cq_hcw_ecc
                 , hqm_credit_hist_pipe_core.aqed_chp_sch_data.cq_hcw [122 : 64 ]
                 , hqm_credit_hist_pipe_core.aqed_chp_sch_data.cq_hcw [ 63 : 0 ]
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp & 
           hqm_credit_hist_pipe_core.chp_rop_hcw_v & hqm_credit_hist_pipe_core.chp_rop_hcw_ready & ( hqm_credit_hist_pipe_core.chp_rop_hcw_data.cmd == CHP_ROP_ENQ_NEW_HCW ) ) begin
        $display("@%0tps [CHP_DEBUG] chp_rop_hcw: cmd:%s hcw_cmd:%s flid_par:%d flid:0x%h cq_hcw_ecc:0x%h cq_hcw:0x%h_%h(qtype:%s) hist_list_info:0x%h(qtype:%s qpri:0x%h qid:0x%h qidix:0x%h mode:0x%h slot:0x%h sn:0x%h)"
                 , $time
                 , hqm_credit_hist_pipe_core.chp_rop_hcw_data.cmd.name
                 , hqm_credit_hist_pipe_core.chp_rop_hcw_data.hcw_cmd.hcw_cmd_dec.name
                 , hqm_credit_hist_pipe_core.chp_rop_hcw_data.flid_parity
                 , hqm_credit_hist_pipe_core.chp_rop_hcw_data.flid
                 , hqm_credit_hist_pipe_core.chp_rop_hcw_data.cq_hcw_ecc
                 , hqm_credit_hist_pipe_core.chp_rop_hcw_data.cq_hcw [122 : 64 ]
                 , hqm_credit_hist_pipe_core.chp_rop_hcw_data.cq_hcw [ 63 : 0 ]
                 , hqm_credit_hist_pipe_core.chp_rop_hcw_data.cq_hcw.msg_info.qtype.name
                 , hqm_credit_hist_pipe_core.chp_rop_hcw_data.hist_list_info
                 , hqm_credit_hist_pipe_core.chp_rop_hcw_data.hist_list_info.qtype.name
                 , hqm_credit_hist_pipe_core.chp_rop_hcw_data.hist_list_info.qpri
                 , hqm_credit_hist_pipe_core.chp_rop_hcw_data.hist_list_info.qid
                 , hqm_credit_hist_pipe_core.chp_rop_hcw_data.hist_list_info.qidix
                 , hqm_credit_hist_pipe_core.chp_rop_hcw_data.hist_list_info.reord_mode
                 , hqm_credit_hist_pipe_core.chp_rop_hcw_data.hist_list_info.reord_slot
                 , hqm_credit_hist_pipe_core.chp_rop_hcw_data.hist_list_info.sn_fid
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp & 
           hqm_credit_hist_pipe_core.chp_rop_hcw_v & hqm_credit_hist_pipe_core.chp_rop_hcw_ready & ( hqm_credit_hist_pipe_core.chp_rop_hcw_data.cmd == CHP_ROP_ENQ_REPLAY_HCW ) ) begin
        $display("@%0tps [CHP_DEBUG] chp_rop_hcw: cmd:%s cq_hcw_ecc:0x%h cq_hcw:0x%h_%h(qtype:%s)"
                 , $time
                 , hqm_credit_hist_pipe_core.chp_rop_hcw_data.cmd.name
                 , hqm_credit_hist_pipe_core.chp_rop_hcw_data.cq_hcw_ecc
                 , hqm_credit_hist_pipe_core.chp_rop_hcw_data.cq_hcw [122 : 64 ]
                 , hqm_credit_hist_pipe_core.chp_rop_hcw_data.cq_hcw [ 63 : 0 ]
                 , hqm_credit_hist_pipe_core.chp_rop_hcw_data.cq_hcw.msg_info.qtype.name
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp & 
           hqm_credit_hist_pipe_core.chp_lsp_token_v & hqm_credit_hist_pipe_core.chp_lsp_token_ready ) begin
        $display("@%0tps [CHP_DEBUG] chp_lsp_token: par:%d cq_is_ldb:%d cq:0x%h count_res:%d count:0x%h(d%0d)"
                 , $time
                 , hqm_credit_hist_pipe_core.chp_lsp_token_data.parity
                 , hqm_credit_hist_pipe_core.chp_lsp_token_data.is_ldb
                 , hqm_credit_hist_pipe_core.chp_lsp_token_data.cq
                 , hqm_credit_hist_pipe_core.chp_lsp_token_data.count_residue
                 , hqm_credit_hist_pipe_core.chp_lsp_token_data.count
                 , hqm_credit_hist_pipe_core.chp_lsp_token_data.count
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp & 
           hqm_credit_hist_pipe_core.chp_lsp_cmp_v & hqm_credit_hist_pipe_core.chp_lsp_cmp_ready ) begin
        $display("@%0tps [CHP_DEBUG] chp_lsp_cmp: user:%d par:%d pp:0x%h qid:0x%h hid_par:%d hid:0x%h hist_list_info:0x%h(par:%d qtype:%s qid:0x%h qidix:0x%h qpri:0x%h mode:%d slot:%d sn:0x%h )"
                 , $time
                 , hqm_credit_hist_pipe_core.chp_lsp_cmp_data.user
                 , hqm_credit_hist_pipe_core.chp_lsp_cmp_data.parity
                 , hqm_credit_hist_pipe_core.chp_lsp_cmp_data.pp
                 , hqm_credit_hist_pipe_core.chp_lsp_cmp_data.qid
                 , hqm_credit_hist_pipe_core.chp_lsp_cmp_data.hid_parity
                 , hqm_credit_hist_pipe_core.chp_lsp_cmp_data.hid
                 , hqm_credit_hist_pipe_core.chp_lsp_cmp_data.hist_list_info
                 , hqm_credit_hist_pipe_core.chp_lsp_cmp_data.hist_list_info.parity
                 , hqm_credit_hist_pipe_core.chp_lsp_cmp_data.hist_list_info.qtype.name
                 , hqm_credit_hist_pipe_core.chp_lsp_cmp_data.hist_list_info.qid
                 , hqm_credit_hist_pipe_core.chp_lsp_cmp_data.hist_list_info.qidix
                 , hqm_credit_hist_pipe_core.chp_lsp_cmp_data.hist_list_info.qpri
                 , hqm_credit_hist_pipe_core.chp_lsp_cmp_data.hist_list_info.reord_mode
                 , hqm_credit_hist_pipe_core.chp_lsp_cmp_data.hist_list_info.reord_slot
                 , hqm_credit_hist_pipe_core.chp_lsp_cmp_data.hist_list_info.sn_fid
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_inp_gated_rst_b_chp & 
           hqm_credit_hist_pipe_core.hcw_sched_w_req_valid & hqm_credit_hist_pipe_core.hcw_sched_w_req_ready ) begin
        $display("@%0tps [CHP_DEBUG] hcw_sched_w_req: cq:0x%h cq_wptr:0x%h flags:0x%h(par:%d cq_is_ldb:%d qdepth:0x%h wb_opt:%d pad_ok:%d) hcw_par:%d data:0x%h_%h(err:%d gen:%d ts:%d qtype:%s qid:0x%h )"
                 , $time
                 , hqm_credit_hist_pipe_core.hcw_sched_w_req.user.cq
                 , hqm_credit_hist_pipe_core.hcw_sched_w_req.user.cq_wptr
                 , hqm_credit_hist_pipe_core.hcw_sched_w_req.user.hqm_core_flags
                 , hqm_credit_hist_pipe_core.hcw_sched_w_req.user.hqm_core_flags.parity
                 , hqm_credit_hist_pipe_core.hcw_sched_w_req.user.hqm_core_flags.cq_is_ldb
                 , hqm_credit_hist_pipe_core.hcw_sched_w_req.user.hqm_core_flags.congestion_management
                 , hqm_credit_hist_pipe_core.hcw_sched_w_req.user.hqm_core_flags.write_buffer_optimization
                 , hqm_credit_hist_pipe_core.hcw_sched_w_req.user.hqm_core_flags.pad_ok
                 , hqm_credit_hist_pipe_core.hcw_sched_w_req.user.hcw_parity
                 , hqm_credit_hist_pipe_core.hcw_sched_w_req.data [ 127 : 64 ]
                 , hqm_credit_hist_pipe_core.hcw_sched_w_req.data[ 63 : 0 ]
                 , hqm_credit_hist_pipe_core.hcw_sched_w_req.data.flags.hcw_error
                 , hqm_credit_hist_pipe_core.hcw_sched_w_req.data.flags.cq_gen
                 , hqm_credit_hist_pipe_core.hcw_sched_w_req.data.debug.ts_flag
                 , hqm_credit_hist_pipe_core.hcw_sched_w_req.data.msg_info.qtype.name
                 , hqm_credit_hist_pipe_core.hcw_sched_w_req.data.msg_info.qid
                 );
      end

    end // if ($test$plusargs("HQM_DEBUG_LOW") | $test$plusargs("HQM_DEBUG_MED") | $test$plusargs("HQM_DEBUG_HIGH")) begin
  end // always_ff

  always_ff @( posedge hqm_credit_hist_pipe_core.hqm_gated_clk or negedge hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp ) begin
    if ( ~ hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp ) begin
      rf_dir_cq_wptr_re_f <= 1'b0 ;
      rf_dir_cq_depth_re_f <= 1'b0 ;
      rf_dir_cq_token_depth_select_re_f <= 1'b0 ;
      rf_ldb_cq_wptr_re_f <= 1'b0 ;
      rf_ldb_cq_depth_re_f <= 1'b0 ;
      rf_ldb_cq_token_depth_select_re_f <= 1'b0 ;
      rf_ord_qid_sn_map_re_f <= 1'b0 ;
      rf_ord_qid_sn_re_f <= 1'b0 ;
      rf_hist_list_minmax_re_f <= 1'b0 ;
      rf_hist_list_ptr_re_f <= 1'b0 ;
      rf_hist_list_a_minmax_re_f <= 1'b0 ;
      rf_hist_list_a_ptr_re_f <= 1'b0 ;
      rf_dir_cq_intr_thresh_re_f <= 1'b0 ;
      rf_ldb_cq_intr_thresh_re_f <= 1'b0 ;
      sr_freelist_0_re_f <= 1'b0 ;
      sr_freelist_1_re_f <= 1'b0 ;
      sr_freelist_2_re_f <= 1'b0 ;
      sr_freelist_3_re_f <= 1'b0 ;
      sr_freelist_4_re_f <= 1'b0 ;
      sr_freelist_5_re_f <= 1'b0 ;
      sr_freelist_6_re_f <= 1'b0 ;
      sr_freelist_7_re_f <= 1'b0 ;
      sr_hist_list_re_f <= 1'b0 ;
      sr_hist_list_a_re_f <= 1'b0 ;
    end
    else begin
      rf_dir_cq_wptr_re_f <= hqm_credit_hist_pipe_core.rf_dir_cq_wptr_re ;
      rf_dir_cq_depth_re_f <= hqm_credit_hist_pipe_core.rf_dir_cq_depth_re ;
      rf_dir_cq_token_depth_select_re_f <= hqm_credit_hist_pipe_core.rf_dir_cq_token_depth_select_re ;
      rf_ldb_cq_wptr_re_f <= hqm_credit_hist_pipe_core.rf_ldb_cq_wptr_re ;
      rf_ldb_cq_depth_re_f <= hqm_credit_hist_pipe_core.rf_ldb_cq_depth_re ;
      rf_ldb_cq_token_depth_select_re_f <= hqm_credit_hist_pipe_core.rf_ldb_cq_token_depth_select_re ;
      rf_ord_qid_sn_map_re_f <= hqm_credit_hist_pipe_core.rf_ord_qid_sn_map_re ;
      rf_ord_qid_sn_re_f <= hqm_credit_hist_pipe_core.rf_ord_qid_sn_re ;
      rf_hist_list_minmax_re_f <= hqm_credit_hist_pipe_core.rf_hist_list_minmax_re ;
      rf_hist_list_ptr_re_f <= hqm_credit_hist_pipe_core.rf_hist_list_ptr_re ;
      rf_hist_list_a_minmax_re_f <= hqm_credit_hist_pipe_core.rf_hist_list_a_minmax_re ;
      rf_hist_list_a_ptr_re_f <= hqm_credit_hist_pipe_core.rf_hist_list_a_ptr_re ;
      rf_dir_cq_intr_thresh_re_f <= hqm_credit_hist_pipe_core.rf_dir_cq_intr_thresh_re ;
      rf_ldb_cq_intr_thresh_re_f <= hqm_credit_hist_pipe_core.rf_ldb_cq_intr_thresh_re ;
      sr_freelist_0_re_f <= hqm_credit_hist_pipe_core.sr_freelist_0_re ;
      sr_freelist_1_re_f <= hqm_credit_hist_pipe_core.sr_freelist_1_re ;
      sr_freelist_2_re_f <= hqm_credit_hist_pipe_core.sr_freelist_2_re ;
      sr_freelist_3_re_f <= hqm_credit_hist_pipe_core.sr_freelist_3_re ;
      sr_freelist_4_re_f <= hqm_credit_hist_pipe_core.sr_freelist_4_re ;
      sr_freelist_5_re_f <= hqm_credit_hist_pipe_core.sr_freelist_5_re ;
      sr_freelist_6_re_f <= hqm_credit_hist_pipe_core.sr_freelist_6_re ;
      sr_freelist_7_re_f <= hqm_credit_hist_pipe_core.sr_freelist_7_re ;
      sr_hist_list_re_f <= hqm_credit_hist_pipe_core.sr_hist_list_re ;
      sr_hist_list_a_re_f <= hqm_credit_hist_pipe_core.sr_hist_list_a_re ;
    end
  end

  always_ff @( posedge hqm_credit_hist_pipe_core.hqm_gated_clk ) begin
    if ($test$plusargs("HQM_DEBUG_LOW") | $test$plusargs("HQM_DEBUG_MED") | $test$plusargs("HQM_DEBUG_HIGH")) begin
      rf_dir_cq_wptr_raddr_f <= hqm_credit_hist_pipe_core.rf_dir_cq_wptr_raddr ;
      rf_dir_cq_depth_raddr_f <= hqm_credit_hist_pipe_core.rf_dir_cq_depth_raddr ;
      rf_dir_cq_token_depth_select_raddr_f <= hqm_credit_hist_pipe_core.rf_dir_cq_token_depth_select_raddr ;

      rf_ldb_cq_wptr_raddr_f <= hqm_credit_hist_pipe_core.rf_ldb_cq_wptr_raddr ;
      rf_ldb_cq_depth_raddr_f <= hqm_credit_hist_pipe_core.rf_ldb_cq_depth_raddr ;
      rf_ldb_cq_token_depth_select_raddr_f <= hqm_credit_hist_pipe_core.rf_ldb_cq_token_depth_select_raddr ;

      rf_ord_qid_sn_map_raddr_f <= hqm_credit_hist_pipe_core.rf_ord_qid_sn_map_raddr ;
      rf_ord_qid_sn_raddr_f <= hqm_credit_hist_pipe_core.rf_ord_qid_sn_raddr ;

      rf_hist_list_minmax_addr_f <= hqm_credit_hist_pipe_core.rf_hist_list_minmax_raddr ;
      rf_hist_list_ptr_raddr_f <= hqm_credit_hist_pipe_core.rf_hist_list_ptr_raddr ;
      rf_hist_list_a_minmax_addr_f <= hqm_credit_hist_pipe_core.rf_hist_list_a_minmax_raddr ;
      rf_hist_list_a_ptr_raddr_f <= hqm_credit_hist_pipe_core.rf_hist_list_a_ptr_raddr ;

      rf_dir_cq_intr_thresh_raddr_f <= hqm_credit_hist_pipe_core.rf_dir_cq_intr_thresh_raddr ;
      rf_ldb_cq_intr_thresh_raddr_f <= hqm_credit_hist_pipe_core.rf_ldb_cq_intr_thresh_raddr ;

      sr_freelist_0_addr_f <= hqm_credit_hist_pipe_core.sr_freelist_0_addr ;
      sr_freelist_1_addr_f <= hqm_credit_hist_pipe_core.sr_freelist_1_addr ;
      sr_freelist_2_addr_f <= hqm_credit_hist_pipe_core.sr_freelist_2_addr ;
      sr_freelist_3_addr_f <= hqm_credit_hist_pipe_core.sr_freelist_3_addr ;
      sr_freelist_4_addr_f <= hqm_credit_hist_pipe_core.sr_freelist_4_addr ;
      sr_freelist_5_addr_f <= hqm_credit_hist_pipe_core.sr_freelist_5_addr ;
      sr_freelist_6_addr_f <= hqm_credit_hist_pipe_core.sr_freelist_6_addr ;
      sr_freelist_7_addr_f <= hqm_credit_hist_pipe_core.sr_freelist_7_addr ;
      sr_hist_list_addr_f <= hqm_credit_hist_pipe_core.sr_hist_list_addr ;
      sr_hist_list_a_addr_f <= hqm_credit_hist_pipe_core.sr_hist_list_a_addr ;

      if ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp & 
           ( hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_ingress.hcw_enq_valid |
             hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_ingress.qed_sch_valid |
             hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_ingress.aqed_sch_valid |
             hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_ingress.hcw_replay_valid ) ) begin
        $display("@%0tps [CHP_DEBUG] ingress: hcw_enq v:%d pop:%d qed_sch v:%d pop:%d aqed_sch v:%d pop:%d hcw_replay v:%d pop:%d"
                 , $time
                 , hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_ingress.hcw_enq_valid
                 , hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_ingress.hcw_enq_pop
                 , hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_ingress.qed_sch_valid
                 , hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_ingress.qed_sch_pop
                 , hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_ingress.aqed_sch_valid
                 , hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_ingress.aqed_sch_pop
                 , hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_ingress.hcw_replay_valid
                 , hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_ingress.hcw_replay_pop
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp & hqm_credit_hist_pipe_core.reset_pf_done_f & hqm_credit_hist_pipe_core.rf_dir_cq_wptr_we ) begin
        $display("@%0tps [CHP_DEBUG] rfw_top: dir_cq_wptr_we addr:0x%h data:0x%h(res:%d wp:%0d) "
                 , $time
                 , hqm_credit_hist_pipe_core.rf_dir_cq_wptr_waddr
                 , hqm_credit_hist_pipe_core.rf_dir_cq_wptr_wdata
                 , hqm_credit_hist_pipe_core.rf_dir_cq_wptr_wdata_struct.residue
                 , hqm_credit_hist_pipe_core.rf_dir_cq_wptr_wdata_struct.wp
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp & hqm_credit_hist_pipe_core.reset_pf_done_f & rf_dir_cq_wptr_re_f ) begin
        $display("@%0tps [CHP_DEBUG] rfw_top: dir_cq_wptr_re addr:0x%h data:0x%h(res:%d wp:%0d)"
                 , $time
                 , rf_dir_cq_wptr_raddr_f
                 , hqm_credit_hist_pipe_core.rf_dir_cq_wptr_rdata
                 , hqm_credit_hist_pipe_core.rf_dir_cq_wptr_rdata_struct.residue
                 , hqm_credit_hist_pipe_core.rf_dir_cq_wptr_rdata_struct.wp
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp & hqm_credit_hist_pipe_core.reset_pf_done_f & hqm_credit_hist_pipe_core.rf_dir_cq_depth_we ) begin
        $display("@%0tps [CHP_DEBUG] rfw_top: dir_cq_depth_we addr:0x%h data:0x%h(res:%d depth:%0d) "
                 , $time
                 , hqm_credit_hist_pipe_core.rf_dir_cq_depth_waddr
                 , hqm_credit_hist_pipe_core.rf_dir_cq_depth_wdata
                 , hqm_credit_hist_pipe_core.rf_dir_cq_depth_wdata_struct.residue
                 , hqm_credit_hist_pipe_core.rf_dir_cq_depth_wdata_struct.depth
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp & hqm_credit_hist_pipe_core.reset_pf_done_f & rf_dir_cq_depth_re_f ) begin
        $display("@%0tps [CHP_DEBUG] rfw_top: dir_cq_depth_re addr:0x%h data:0x%h(res:%d depth:%0d)"
                 , $time
                 , rf_dir_cq_depth_raddr_f
                 , hqm_credit_hist_pipe_core.rf_dir_cq_depth_rdata
                 , hqm_credit_hist_pipe_core.rf_dir_cq_depth_rdata_struct.residue
                 , hqm_credit_hist_pipe_core.rf_dir_cq_depth_rdata_struct.depth
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp & hqm_credit_hist_pipe_core.reset_pf_done_f & hqm_credit_hist_pipe_core.rf_dir_cq_token_depth_select_we ) begin
        $display("@%0tps [CHP_DEBUG] rfw_top: dir_cq_token_depth_select_we addr:0x%h data:0x%h(par:%d depth_select:%0d) "
                 , $time
                 , hqm_credit_hist_pipe_core.rf_dir_cq_token_depth_select_waddr
                 , hqm_credit_hist_pipe_core.rf_dir_cq_token_depth_select_wdata
                 , hqm_credit_hist_pipe_core.rf_dir_cq_token_depth_select_wdata_struct.parity
                 , hqm_credit_hist_pipe_core.rf_dir_cq_token_depth_select_wdata_struct.depth_select
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp & hqm_credit_hist_pipe_core.reset_pf_done_f & rf_dir_cq_token_depth_select_re_f ) begin
        $display("@%0tps [CHP_DEBUG] rfw_top: dir_cq_token_depth_select_re addr:0x%h data:0x%h(par:%d depth_select:%0d)"
                 , $time
                 , rf_dir_cq_token_depth_select_raddr_f
                 , hqm_credit_hist_pipe_core.rf_dir_cq_token_depth_select_rdata
                 , hqm_credit_hist_pipe_core.rf_dir_cq_token_depth_select_rdata_struct.parity
                 , hqm_credit_hist_pipe_core.rf_dir_cq_token_depth_select_rdata_struct.depth_select
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp & hqm_credit_hist_pipe_core.reset_pf_done_f & hqm_credit_hist_pipe_core.rf_ldb_cq_wptr_we ) begin
        $display("@%0tps [CHP_DEBUG] rfw_top: ldb_cq_wptr_we addr:0x%h data:0x%h(res:%d wp:%0d) "
                 , $time
                 , hqm_credit_hist_pipe_core.rf_ldb_cq_wptr_waddr
                 , hqm_credit_hist_pipe_core.rf_ldb_cq_wptr_wdata
                 , hqm_credit_hist_pipe_core.rf_ldb_cq_wptr_wdata_struct.residue
                 , hqm_credit_hist_pipe_core.rf_ldb_cq_wptr_wdata_struct.wp
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp & hqm_credit_hist_pipe_core.reset_pf_done_f & rf_ldb_cq_wptr_re_f ) begin
        $display("@%0tps [CHP_DEBUG] rfw_top: ldb_cq_wptr_re addr:0x%h data:0x%h(res:%d wp:%0d)"
                 , $time
                 , rf_ldb_cq_wptr_raddr_f
                 , hqm_credit_hist_pipe_core.rf_ldb_cq_wptr_rdata
                 , hqm_credit_hist_pipe_core.rf_ldb_cq_wptr_rdata_struct.residue
                 , hqm_credit_hist_pipe_core.rf_ldb_cq_wptr_rdata_struct.wp
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp & hqm_credit_hist_pipe_core.reset_pf_done_f & hqm_credit_hist_pipe_core.rf_ldb_cq_depth_we ) begin
        $display("@%0tps [CHP_DEBUG] rfw_top: ldb_cq_depth_we addr:0x%h data:0x%h(res:%d depth:%0d) "
                 , $time
                 , hqm_credit_hist_pipe_core.rf_ldb_cq_depth_waddr
                 , hqm_credit_hist_pipe_core.rf_ldb_cq_depth_wdata
                 , hqm_credit_hist_pipe_core.rf_ldb_cq_depth_wdata_struct.residue
                 , hqm_credit_hist_pipe_core.rf_ldb_cq_depth_wdata_struct.depth
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp & hqm_credit_hist_pipe_core.reset_pf_done_f & rf_ldb_cq_depth_re_f ) begin
        $display("@%0tps [CHP_DEBUG] rfw_top: ldb_cq_depth_re addr:0x%h data:0x%h(res:%d depth:%0d)"
                 , $time
                 , rf_ldb_cq_depth_raddr_f
                 , hqm_credit_hist_pipe_core.rf_ldb_cq_depth_rdata
                 , hqm_credit_hist_pipe_core.rf_ldb_cq_depth_rdata_struct.residue
                 , hqm_credit_hist_pipe_core.rf_ldb_cq_depth_rdata_struct.depth
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp & hqm_credit_hist_pipe_core.reset_pf_done_f & hqm_credit_hist_pipe_core.rf_ldb_cq_token_depth_select_we ) begin
        $display("@%0tps [CHP_DEBUG] rfw_top: ldb_cq_token_depth_select_we addr:0x%h data:0x%h(par:%d depth_select:%0d) "
                 , $time
                 , hqm_credit_hist_pipe_core.rf_ldb_cq_token_depth_select_waddr
                 , hqm_credit_hist_pipe_core.rf_ldb_cq_token_depth_select_wdata
                 , hqm_credit_hist_pipe_core.rf_ldb_cq_token_depth_select_wdata_struct.parity
                 , hqm_credit_hist_pipe_core.rf_ldb_cq_token_depth_select_wdata_struct.depth_select
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp & hqm_credit_hist_pipe_core.reset_pf_done_f & rf_ldb_cq_token_depth_select_re_f ) begin
        $display("@%0tps [CHP_DEBUG] rfw_top: ldb_cq_token_depth_select_re addr:0x%h data:0x%h(par:%d depth_select:%0d)"
                 , $time
                 , rf_ldb_cq_token_depth_select_raddr_f
                 , hqm_credit_hist_pipe_core.rf_ldb_cq_token_depth_select_rdata
                 , hqm_credit_hist_pipe_core.rf_ldb_cq_token_depth_select_rdata_struct.parity
                 , hqm_credit_hist_pipe_core.rf_ldb_cq_token_depth_select_rdata_struct.depth_select
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp & hqm_credit_hist_pipe_core.reset_pf_done_f & hqm_credit_hist_pipe_core.rf_ord_qid_sn_map_we ) begin
        $display("@%0tps [CHP_DEBUG] rfw_top: ord_qid_sn_map_we addr:0x%h data:0x%h(par:0x%h group:0x%h slot:0x%h mode:0x%h)"
                 , $time
                 , hqm_credit_hist_pipe_core.rf_ord_qid_sn_map_waddr
                 , hqm_credit_hist_pipe_core.rf_ord_qid_sn_map_wdata
                 , hqm_credit_hist_pipe_core.rf_ord_qid_sn_map_wdata_struct.parity
                 , hqm_credit_hist_pipe_core.rf_ord_qid_sn_map_wdata_struct.map.group
                 , hqm_credit_hist_pipe_core.rf_ord_qid_sn_map_wdata_struct.map.slot
                 , hqm_credit_hist_pipe_core.rf_ord_qid_sn_map_wdata_struct.map.mode
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp & hqm_credit_hist_pipe_core.reset_pf_done_f & rf_ord_qid_sn_map_re_f ) begin
        $display("@%0tps [CHP_DEBUG] rfw_top: ord_qid_sn_map_re addr:0x%h data:0x%h(par:0x%h group:0x%h slot:0x%h mode:0x%h)"
                 , $time
                 , rf_ord_qid_sn_map_raddr_f
                 , hqm_credit_hist_pipe_core.rf_ord_qid_sn_map_rdata
                 , hqm_credit_hist_pipe_core.rf_ord_qid_sn_map_rdata_struct.parity
                 , hqm_credit_hist_pipe_core.rf_ord_qid_sn_map_rdata_struct.map.group
                 , hqm_credit_hist_pipe_core.rf_ord_qid_sn_map_rdata_struct.map.slot
                 , hqm_credit_hist_pipe_core.rf_ord_qid_sn_map_rdata_struct.map.mode
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp & hqm_credit_hist_pipe_core.reset_pf_done_f & hqm_credit_hist_pipe_core.rf_ord_qid_sn_we ) begin
        $display("@%0tps [CHP_DEBUG] rfw_top: ord_qid_sn_we addr:0x%h data:0x%h(res:0x%h sn:0x%h)"
                 , $time
                 , hqm_credit_hist_pipe_core.rf_ord_qid_sn_waddr
                 , hqm_credit_hist_pipe_core.rf_ord_qid_sn_wdata
                 , hqm_credit_hist_pipe_core.rf_ord_qid_sn_wdata_struct.residue
                 , hqm_credit_hist_pipe_core.rf_ord_qid_sn_wdata_struct.sn
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp & hqm_credit_hist_pipe_core.reset_pf_done_f & rf_ord_qid_sn_re_f ) begin
        $display("@%0tps [CHP_DEBUG] rfw_top: ord_qid_sn_re addr:0x%h data:0x%h(res:0x%h sn:0x%h)"
                 , $time
                 , rf_ord_qid_sn_raddr_f
                 , hqm_credit_hist_pipe_core.rf_ord_qid_sn_rdata
                 , hqm_credit_hist_pipe_core.rf_ord_qid_sn_rdata_struct.residue
                 , hqm_credit_hist_pipe_core.rf_ord_qid_sn_rdata_struct.sn
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp & hqm_credit_hist_pipe_core.reset_pf_done_f & hqm_credit_hist_pipe_core.rf_hist_list_minmax_we ) begin
        $display("@%0tps [CHP_DEBUG] rfw_top: hist_list_minmax_we addr:0x%h data:0x%h(max_addr_res:0x%h max_addr:0x%h min_addr_res:0x%h min_addr:0x%h)"
                 , $time
                 , hqm_credit_hist_pipe_core.rf_hist_list_minmax_waddr
                 , hqm_credit_hist_pipe_core.rf_hist_list_minmax_wdata
                 , hqm_credit_hist_pipe_core.rf_hist_list_minmax_wdata_struct.max_addr_residue
                 , hqm_credit_hist_pipe_core.rf_hist_list_minmax_wdata_struct.max_addr
                 , hqm_credit_hist_pipe_core.rf_hist_list_minmax_wdata_struct.min_addr_residue
                 , hqm_credit_hist_pipe_core.rf_hist_list_minmax_wdata_struct.min_addr
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp & hqm_credit_hist_pipe_core.reset_pf_done_f & rf_hist_list_minmax_re_f ) begin
        $display("@%0tps [CHP_DEBUG] rfw_top: hist_list_minmax_re addr:0x%h data:0x%h(max_addr_res:0x%h max_addr:0x%h min_addr_res:0x%h min_addr:0x%h)"
                 , $time
                 , rf_hist_list_minmax_addr_f
                 , hqm_credit_hist_pipe_core.rf_hist_list_minmax_rdata
                 , hqm_credit_hist_pipe_core.rf_hist_list_minmax_rdata_struct.max_addr_residue
                 , hqm_credit_hist_pipe_core.rf_hist_list_minmax_rdata_struct.max_addr
                 , hqm_credit_hist_pipe_core.rf_hist_list_minmax_rdata_struct.min_addr_residue
                 , hqm_credit_hist_pipe_core.rf_hist_list_minmax_rdata_struct.min_addr
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp & hqm_credit_hist_pipe_core.reset_pf_done_f & hqm_credit_hist_pipe_core.rf_hist_list_ptr_we ) begin
        $display("@%0tps [CHP_DEBUG] rfw_top: hist_list_ptr_we addr:0x%h data:0x%h(pop_ptr res:0x%h gen:%d ptr:0x%h push_ptr res:0x%h gen:%h ptr:0x%h)"
                 , $time
                 , hqm_credit_hist_pipe_core.rf_hist_list_ptr_waddr
                 , hqm_credit_hist_pipe_core.rf_hist_list_ptr_wdata
                 , hqm_credit_hist_pipe_core.rf_hist_list_ptr_wdata_struct.pop_ptr_residue
                 , hqm_credit_hist_pipe_core.rf_hist_list_ptr_wdata_struct.pop_ptr_gen
                 , hqm_credit_hist_pipe_core.rf_hist_list_ptr_wdata_struct.pop_ptr
                 , hqm_credit_hist_pipe_core.rf_hist_list_ptr_wdata_struct.push_ptr_residue
                 , hqm_credit_hist_pipe_core.rf_hist_list_ptr_wdata_struct.push_ptr_gen
                 , hqm_credit_hist_pipe_core.rf_hist_list_ptr_wdata_struct.push_ptr
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp & hqm_credit_hist_pipe_core.reset_pf_done_f & rf_hist_list_ptr_re_f ) begin
        $display("@%0tps [CHP_DEBUG] rfw_top: hist_list_ptr_re addr:0x%h data:0x%h(pop_ptr res:0x%h gen:%d ptr:0x%h push_ptr res:0x%h gen:%h ptr:0x%h)"
                 , $time
                 , rf_hist_list_ptr_raddr_f
                 , hqm_credit_hist_pipe_core.rf_hist_list_ptr_rdata
                 , hqm_credit_hist_pipe_core.rf_hist_list_ptr_rdata_struct.pop_ptr_residue
                 , hqm_credit_hist_pipe_core.rf_hist_list_ptr_rdata_struct.pop_ptr_gen
                 , hqm_credit_hist_pipe_core.rf_hist_list_ptr_rdata_struct.pop_ptr
                 , hqm_credit_hist_pipe_core.rf_hist_list_ptr_rdata_struct.push_ptr_residue
                 , hqm_credit_hist_pipe_core.rf_hist_list_ptr_rdata_struct.push_ptr_gen
                 , hqm_credit_hist_pipe_core.rf_hist_list_ptr_rdata_struct.push_ptr
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp & hqm_credit_hist_pipe_core.reset_pf_done_f & hqm_credit_hist_pipe_core.rf_hist_list_a_minmax_we ) begin
        $display("@%0tps [CHP_DEBUG] rfw_top: hist_list_a_minmax_we addr:0x%h data:0x%h(max_addr_res:0x%h max_addr:0x%h min_addr_res:0x%h min_addr:0x%h)"
                 , $time
                 , hqm_credit_hist_pipe_core.rf_hist_list_a_minmax_waddr
                 , hqm_credit_hist_pipe_core.rf_hist_list_a_minmax_wdata
                 , hqm_credit_hist_pipe_core.rf_hist_list_a_minmax_wdata_struct.max_addr_residue
                 , hqm_credit_hist_pipe_core.rf_hist_list_a_minmax_wdata_struct.max_addr
                 , hqm_credit_hist_pipe_core.rf_hist_list_a_minmax_wdata_struct.min_addr_residue
                 , hqm_credit_hist_pipe_core.rf_hist_list_a_minmax_wdata_struct.min_addr
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp & hqm_credit_hist_pipe_core.reset_pf_done_f & rf_hist_list_a_minmax_re_f ) begin
        $display("@%0tps [CHP_DEBUG] rfw_top: hist_list_a_minmax_re addr:0x%h data:0x%h(max_addr_res:0x%h max_addr:0x%h min_addr_res:0x%h min_addr:0x%h)"
                 , $time
                 , rf_hist_list_a_minmax_addr_f
                 , hqm_credit_hist_pipe_core.rf_hist_list_a_minmax_rdata
                 , hqm_credit_hist_pipe_core.rf_hist_list_a_minmax_rdata_struct.max_addr_residue
                 , hqm_credit_hist_pipe_core.rf_hist_list_a_minmax_rdata_struct.max_addr
                 , hqm_credit_hist_pipe_core.rf_hist_list_a_minmax_rdata_struct.min_addr_residue
                 , hqm_credit_hist_pipe_core.rf_hist_list_a_minmax_rdata_struct.min_addr
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp & hqm_credit_hist_pipe_core.reset_pf_done_f & hqm_credit_hist_pipe_core.rf_hist_list_a_ptr_we ) begin
        $display("@%0tps [CHP_DEBUG] rfw_top: hist_list_a_ptr_we addr:0x%h data:0x%h(pop_ptr res:0x%h gen:%d ptr:0x%h push_ptr res:0x%h gen:%h ptr:0x%h)"
                 , $time
                 , hqm_credit_hist_pipe_core.rf_hist_list_a_ptr_waddr
                 , hqm_credit_hist_pipe_core.rf_hist_list_a_ptr_wdata
                 , hqm_credit_hist_pipe_core.rf_hist_list_a_ptr_wdata_struct.pop_ptr_residue
                 , hqm_credit_hist_pipe_core.rf_hist_list_a_ptr_wdata_struct.pop_ptr_gen
                 , hqm_credit_hist_pipe_core.rf_hist_list_a_ptr_wdata_struct.pop_ptr
                 , hqm_credit_hist_pipe_core.rf_hist_list_a_ptr_wdata_struct.push_ptr_residue
                 , hqm_credit_hist_pipe_core.rf_hist_list_a_ptr_wdata_struct.push_ptr_gen
                 , hqm_credit_hist_pipe_core.rf_hist_list_a_ptr_wdata_struct.push_ptr
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp & hqm_credit_hist_pipe_core.reset_pf_done_f & rf_hist_list_a_ptr_re_f ) begin
        $display("@%0tps [CHP_DEBUG] rfw_top: hist_list_a_ptr_re addr:0x%h data:0x%h(pop_ptr res:0x%h gen:%d ptr:0x%h push_ptr res:0x%h gen:%h ptr:0x%h)"
                 , $time
                 , rf_hist_list_a_ptr_raddr_f
                 , hqm_credit_hist_pipe_core.rf_hist_list_a_ptr_rdata
                 , hqm_credit_hist_pipe_core.rf_hist_list_a_ptr_rdata_struct.pop_ptr_residue
                 , hqm_credit_hist_pipe_core.rf_hist_list_a_ptr_rdata_struct.pop_ptr_gen
                 , hqm_credit_hist_pipe_core.rf_hist_list_a_ptr_rdata_struct.pop_ptr
                 , hqm_credit_hist_pipe_core.rf_hist_list_a_ptr_rdata_struct.push_ptr_residue
                 , hqm_credit_hist_pipe_core.rf_hist_list_a_ptr_rdata_struct.push_ptr_gen
                 , hqm_credit_hist_pipe_core.rf_hist_list_a_ptr_rdata_struct.push_ptr
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp & hqm_credit_hist_pipe_core.reset_pf_done_f & hqm_credit_hist_pipe_core.rf_dir_cq_intr_thresh_we ) begin
        $display("@%0tps [CHP_DEBUG] rfw_top: dir_cq_intr_thresh_we addr:0x%h data:0x%h(par:0x%h thresh:0x%h)"
                 , $time
                 , hqm_credit_hist_pipe_core.rf_dir_cq_intr_thresh_waddr
                 , hqm_credit_hist_pipe_core.rf_dir_cq_intr_thresh_wdata
                 , hqm_credit_hist_pipe_core.rf_dir_cq_intr_thresh_wdata_struct.parity
                 , hqm_credit_hist_pipe_core.rf_dir_cq_intr_thresh_wdata_struct.threshold
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp & hqm_credit_hist_pipe_core.reset_pf_done_f & rf_dir_cq_intr_thresh_re_f ) begin
        $display("@%0tps [CHP_DEBUG] rfw_top: dir_cq_intr_thresh_re addr:0x%h data:0x%h(par:0x%h thresh:0x%h)"
                 , $time
                 , rf_dir_cq_intr_thresh_raddr_f
                 , hqm_credit_hist_pipe_core.rf_dir_cq_intr_thresh_rdata
                 , hqm_credit_hist_pipe_core.rf_dir_cq_intr_thresh_rdata_struct.parity
                 , hqm_credit_hist_pipe_core.rf_dir_cq_intr_thresh_rdata_struct.threshold
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp & hqm_credit_hist_pipe_core.reset_pf_done_f & hqm_credit_hist_pipe_core.rf_ldb_cq_intr_thresh_we ) begin
        $display("@%0tps [CHP_DEBUG] rfw_top: ldb_cq_intr_thresh_we addr:0x%h data:0x%h(par:0x%h thresh:0x%h)"
                 , $time
                 , hqm_credit_hist_pipe_core.rf_ldb_cq_intr_thresh_waddr
                 , hqm_credit_hist_pipe_core.rf_ldb_cq_intr_thresh_wdata
                 , hqm_credit_hist_pipe_core.rf_ldb_cq_intr_thresh_wdata_struct.parity
                 , hqm_credit_hist_pipe_core.rf_ldb_cq_intr_thresh_wdata_struct.threshold
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp & hqm_credit_hist_pipe_core.reset_pf_done_f & rf_ldb_cq_intr_thresh_re_f ) begin
        $display("@%0tps [CHP_DEBUG] rfw_top: ldb_cq_intr_thresh_re addr:0x%h data:0x%h(par:0x%h thresh:0x%h)"
                 , $time
                 , rf_ldb_cq_intr_thresh_raddr_f
                 , hqm_credit_hist_pipe_core.rf_ldb_cq_intr_thresh_rdata
                 , hqm_credit_hist_pipe_core.rf_ldb_cq_intr_thresh_rdata_struct.parity
                 , hqm_credit_hist_pipe_core.rf_ldb_cq_intr_thresh_rdata_struct.threshold
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp & hqm_credit_hist_pipe_core.reset_pf_done_f & sr_freelist_0_re_f ) begin
        $display("@%0tps [CHP_DEBUG] srw_top: sr_freelist_0_re addr:0x%h data:0x%h(ecc:%h flid:0x%h)"
                 , $time
                 , sr_freelist_0_addr_f
                 , hqm_credit_hist_pipe_core.sr_freelist_0_rdata
                 , hqm_credit_hist_pipe_core.sr_freelist_0_rdata_struct.flid_ecc
                 , hqm_credit_hist_pipe_core.sr_freelist_0_rdata_struct.flid
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp & hqm_credit_hist_pipe_core.reset_pf_done_f & hqm_credit_hist_pipe_core.sr_freelist_0_we ) begin
        $display("@%0tps [CHP_DEBUG] srw_top: sr_freelist_0_we addr:0x%h data:0x%h(ecc:%h flid:0x%h)"
                 , $time
                 , hqm_credit_hist_pipe_core.sr_freelist_0_addr
                 , hqm_credit_hist_pipe_core.sr_freelist_0_wdata
                 , hqm_credit_hist_pipe_core.sr_freelist_0_wdata_struct.flid_ecc
                 , hqm_credit_hist_pipe_core.sr_freelist_0_wdata_struct.flid
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp & hqm_credit_hist_pipe_core.reset_pf_done_f & sr_freelist_1_re_f ) begin
        $display("@%0tps [CHP_DEBUG] srw_top: sr_freelist_1_re addr:0x%h data:0x%h(ecc:%h flid:0x%h)"
                 , $time
                 , sr_freelist_1_addr_f
                 , hqm_credit_hist_pipe_core.sr_freelist_1_rdata
                 , hqm_credit_hist_pipe_core.sr_freelist_1_rdata_struct.flid_ecc
                 , hqm_credit_hist_pipe_core.sr_freelist_1_rdata_struct.flid
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp & hqm_credit_hist_pipe_core.reset_pf_done_f & hqm_credit_hist_pipe_core.sr_freelist_1_we ) begin
        $display("@%0tps [CHP_DEBUG] srw_top: sr_freelist_1_we addr:0x%h data:0x%h(ecc:%h flid:0x%h)"
                 , $time
                 , hqm_credit_hist_pipe_core.sr_freelist_1_addr
                 , hqm_credit_hist_pipe_core.sr_freelist_1_wdata
                 , hqm_credit_hist_pipe_core.sr_freelist_1_wdata_struct.flid_ecc
                 , hqm_credit_hist_pipe_core.sr_freelist_1_wdata_struct.flid
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp & hqm_credit_hist_pipe_core.reset_pf_done_f & sr_freelist_2_re_f ) begin
        $display("@%0tps [CHP_DEBUG] srw_top: sr_freelist_2_re addr:0x%h data:0x%h(ecc:%h flid:0x%h)"
                 , $time
                 , sr_freelist_2_addr_f
                 , hqm_credit_hist_pipe_core.sr_freelist_2_rdata
                 , hqm_credit_hist_pipe_core.sr_freelist_2_rdata_struct.flid_ecc
                 , hqm_credit_hist_pipe_core.sr_freelist_2_rdata_struct.flid
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp & hqm_credit_hist_pipe_core.reset_pf_done_f & hqm_credit_hist_pipe_core.sr_freelist_2_we ) begin
        $display("@%0tps [CHP_DEBUG] srw_top: sr_freelist_2_we addr:0x%h data:0x%h(ecc:%h flid:0x%h)"
                 , $time
                 , hqm_credit_hist_pipe_core.sr_freelist_2_addr
                 , hqm_credit_hist_pipe_core.sr_freelist_2_wdata
                 , hqm_credit_hist_pipe_core.sr_freelist_2_wdata_struct.flid_ecc
                 , hqm_credit_hist_pipe_core.sr_freelist_2_wdata_struct.flid
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp & hqm_credit_hist_pipe_core.reset_pf_done_f & sr_freelist_3_re_f ) begin
        $display("@%0tps [CHP_DEBUG] srw_top: sr_freelist_3_re addr:0x%h data:0x%h(ecc:%h flid:0x%h)"
                 , $time
                 , sr_freelist_3_addr_f
                 , hqm_credit_hist_pipe_core.sr_freelist_3_rdata
                 , hqm_credit_hist_pipe_core.sr_freelist_3_rdata_struct.flid_ecc
                 , hqm_credit_hist_pipe_core.sr_freelist_3_rdata_struct.flid
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp & hqm_credit_hist_pipe_core.reset_pf_done_f & hqm_credit_hist_pipe_core.sr_freelist_3_we ) begin
        $display("@%0tps [CHP_DEBUG] srw_top: sr_freelist_3_we addr:0x%h data:0x%h(ecc:%h flid:0x%h)"
                 , $time
                 , hqm_credit_hist_pipe_core.sr_freelist_3_addr
                 , hqm_credit_hist_pipe_core.sr_freelist_3_wdata
                 , hqm_credit_hist_pipe_core.sr_freelist_3_wdata_struct.flid_ecc
                 , hqm_credit_hist_pipe_core.sr_freelist_3_wdata_struct.flid
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp & hqm_credit_hist_pipe_core.reset_pf_done_f & sr_freelist_4_re_f ) begin
        $display("@%0tps [CHP_DEBUG] srw_top: sr_freelist_4_re addr:0x%h data:0x%h(ecc:%h flid:0x%h)"
                 , $time
                 , sr_freelist_4_addr_f
                 , hqm_credit_hist_pipe_core.sr_freelist_4_rdata
                 , hqm_credit_hist_pipe_core.sr_freelist_4_rdata_struct.flid_ecc
                 , hqm_credit_hist_pipe_core.sr_freelist_4_rdata_struct.flid
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp & hqm_credit_hist_pipe_core.reset_pf_done_f & hqm_credit_hist_pipe_core.sr_freelist_4_we ) begin
        $display("@%0tps [CHP_DEBUG] srw_top: sr_freelist_4_we addr:0x%h data:0x%h(ecc:%h flid:0x%h)"
                 , $time
                 , hqm_credit_hist_pipe_core.sr_freelist_4_addr
                 , hqm_credit_hist_pipe_core.sr_freelist_4_wdata
                 , hqm_credit_hist_pipe_core.sr_freelist_4_wdata_struct.flid_ecc
                 , hqm_credit_hist_pipe_core.sr_freelist_4_wdata_struct.flid
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp & hqm_credit_hist_pipe_core.reset_pf_done_f & sr_freelist_5_re_f ) begin
        $display("@%0tps [CHP_DEBUG] srw_top: sr_freelist_5_re addr:0x%h data:0x%h(ecc:%h flid:0x%h)"
                 , $time
                 , sr_freelist_5_addr_f
                 , hqm_credit_hist_pipe_core.sr_freelist_5_rdata
                 , hqm_credit_hist_pipe_core.sr_freelist_5_rdata_struct.flid_ecc
                 , hqm_credit_hist_pipe_core.sr_freelist_5_rdata_struct.flid
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp & hqm_credit_hist_pipe_core.reset_pf_done_f & hqm_credit_hist_pipe_core.sr_freelist_5_we ) begin
        $display("@%0tps [CHP_DEBUG] srw_top: sr_freelist_5_we addr:0x%h data:0x%h(ecc:%h flid:0x%h)"
                 , $time
                 , hqm_credit_hist_pipe_core.sr_freelist_5_addr
                 , hqm_credit_hist_pipe_core.sr_freelist_5_wdata
                 , hqm_credit_hist_pipe_core.sr_freelist_5_wdata_struct.flid_ecc
                 , hqm_credit_hist_pipe_core.sr_freelist_5_wdata_struct.flid
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp & hqm_credit_hist_pipe_core.reset_pf_done_f & sr_freelist_6_re_f ) begin
        $display("@%0tps [CHP_DEBUG] srw_top: sr_freelist_6_re addr:0x%h data:0x%h(ecc:%h flid:0x%h)"
                 , $time
                 , sr_freelist_6_addr_f
                 , hqm_credit_hist_pipe_core.sr_freelist_6_rdata
                 , hqm_credit_hist_pipe_core.sr_freelist_6_rdata_struct.flid_ecc
                 , hqm_credit_hist_pipe_core.sr_freelist_6_rdata_struct.flid
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp & hqm_credit_hist_pipe_core.reset_pf_done_f & hqm_credit_hist_pipe_core.sr_freelist_6_we ) begin
        $display("@%0tps [CHP_DEBUG] srw_top: sr_freelist_6_we addr:0x%h data:0x%h(ecc:%h flid:0x%h)"
                 , $time
                 , hqm_credit_hist_pipe_core.sr_freelist_6_addr
                 , hqm_credit_hist_pipe_core.sr_freelist_6_wdata
                 , hqm_credit_hist_pipe_core.sr_freelist_6_wdata_struct.flid_ecc
                 , hqm_credit_hist_pipe_core.sr_freelist_6_wdata_struct.flid
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp & hqm_credit_hist_pipe_core.reset_pf_done_f & sr_freelist_7_re_f ) begin
        $display("@%0tps [CHP_DEBUG] srw_top: sr_freelist_7_re addr:0x%h data:0x%h(ecc:%h flid:0x%h)"
                 , $time
                 , sr_freelist_7_addr_f
                 , hqm_credit_hist_pipe_core.sr_freelist_7_rdata
                 , hqm_credit_hist_pipe_core.sr_freelist_7_rdata_struct.flid_ecc
                 , hqm_credit_hist_pipe_core.sr_freelist_7_rdata_struct.flid
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp & hqm_credit_hist_pipe_core.reset_pf_done_f & hqm_credit_hist_pipe_core.sr_freelist_7_we ) begin
        $display("@%0tps [CHP_DEBUG] srw_top: sr_freelist_7_we addr:0x%h data:0x%h(ecc:%h flid:0x%h)"
                 , $time
                 , hqm_credit_hist_pipe_core.sr_freelist_7_addr
                 , hqm_credit_hist_pipe_core.sr_freelist_7_wdata
                 , hqm_credit_hist_pipe_core.sr_freelist_7_wdata_struct.flid_ecc
                 , hqm_credit_hist_pipe_core.sr_freelist_7_wdata_struct.flid
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp & hqm_credit_hist_pipe_core.reset_pf_done_f & sr_hist_list_re_f ) begin
        $display("@%0tps [CHP_DEBUG] srw_top: sr_hist_list_re cq:0x%h max:0x%h min:0x%h addr:0x%h data:0x%h( ecc:0x%h hid:0x%h cmp_id:0x%h hist_list_info par:%0d qtype:%s qpri:0x%h qid:0x%h qidix:0x%h mode:0x%h slot:0x%h sn:0x%h )"
                 , $time
                 , hqm_credit_hist_pipe_core.i_mf_hist_list.i_mf.p3_bounds_pipe_addr_f_nc
                 , hqm_credit_hist_pipe_core.i_mf_hist_list.i_mf.p3_bounds_pipe_max_addr_nc.ba.bounds
                 , hqm_credit_hist_pipe_core.i_mf_hist_list.i_mf.p3_bounds_pipe_min_addr_nc.ba.bounds
                 , sr_hist_list_addr_f
                 , hqm_credit_hist_pipe_core.sr_hist_list_rdata
                 , hqm_credit_hist_pipe_core.sr_hist_list_rdata_struct.ecc
                 , hqm_credit_hist_pipe_core.sr_hist_list_rdata_struct.hid
                 , hqm_credit_hist_pipe_core.sr_hist_list_rdata_struct.cmp_id
                 , hqm_credit_hist_pipe_core.sr_hist_list_rdata_struct.hist_list_info.parity
                 , hqm_credit_hist_pipe_core.sr_hist_list_rdata_struct.hist_list_info.qtype.name
                 , hqm_credit_hist_pipe_core.sr_hist_list_rdata_struct.hist_list_info.qpri
                 , hqm_credit_hist_pipe_core.sr_hist_list_rdata_struct.hist_list_info.qid
                 , hqm_credit_hist_pipe_core.sr_hist_list_rdata_struct.hist_list_info.qidix
                 , hqm_credit_hist_pipe_core.sr_hist_list_rdata_struct.hist_list_info.reord_mode
                 , hqm_credit_hist_pipe_core.sr_hist_list_rdata_struct.hist_list_info.reord_slot
                 , hqm_credit_hist_pipe_core.sr_hist_list_rdata_struct.hist_list_info.sn_fid
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp & hqm_credit_hist_pipe_core.reset_pf_done_f & hqm_credit_hist_pipe_core.sr_hist_list_we ) begin
        $display("@%0tps [CHP_DEBUG] srw_top: sr_hist_list_we cq:0x%h max:0x%h min:0x%h addr:0x%h data:0x%h( ecc:0x%h hid:0x%h cmp_id:0x%h hist_list_info par:%0d qtype:%s qpri:0x%h qid:0x%h qidix:0x%h mode:0x%h slot:0x%h sn:0x%h )"
                 , $time
                 , hqm_credit_hist_pipe_core.i_mf_hist_list.i_mf.p2_bounds_pipe_f.addr
                 , hqm_credit_hist_pipe_core.i_mf_hist_list.i_mf.p2_bounds_pipe_f.max_addr.ba.bounds
                 , hqm_credit_hist_pipe_core.i_mf_hist_list.i_mf.p2_bounds_pipe_f.min_addr.ba.bounds
                 , hqm_credit_hist_pipe_core.sr_hist_list_addr
                 , hqm_credit_hist_pipe_core.sr_hist_list_wdata
                 , hqm_credit_hist_pipe_core.sr_hist_list_wdata_struct.ecc
                 , hqm_credit_hist_pipe_core.sr_hist_list_wdata_struct.hid
                 , hqm_credit_hist_pipe_core.sr_hist_list_wdata_struct.cmp_id
                 , hqm_credit_hist_pipe_core.sr_hist_list_wdata_struct.hist_list_info.parity
                 , hqm_credit_hist_pipe_core.sr_hist_list_wdata_struct.hist_list_info.qtype.name
                 , hqm_credit_hist_pipe_core.sr_hist_list_wdata_struct.hist_list_info.qpri
                 , hqm_credit_hist_pipe_core.sr_hist_list_wdata_struct.hist_list_info.qid
                 , hqm_credit_hist_pipe_core.sr_hist_list_wdata_struct.hist_list_info.qidix
                 , hqm_credit_hist_pipe_core.sr_hist_list_wdata_struct.hist_list_info.reord_mode
                 , hqm_credit_hist_pipe_core.sr_hist_list_wdata_struct.hist_list_info.reord_slot
                 , hqm_credit_hist_pipe_core.sr_hist_list_wdata_struct.hist_list_info.sn_fid
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp & hqm_credit_hist_pipe_core.reset_pf_done_f & sr_hist_list_a_re_f ) begin
        $display("@%0tps [CHP_DEBUG] srw_top: sr_hist_list_a_re cq:0x%h max:0x%h min:0x%h addr:0x%h data:0x%h( ecc:0x%h hid:0x%h cmp_id:0x%h hist_list_info par:%0d qtype:%s qpri:0x%h qid:0x%h qidix:0x%h mode:0x%h slot:0x%h sn:0x%h )"
                 , $time
                 , hqm_credit_hist_pipe_core.i_mf_hist_list_a.i_mf.p3_bounds_pipe_addr_f_nc
                 , hqm_credit_hist_pipe_core.i_mf_hist_list_a.i_mf.p3_bounds_pipe_max_addr_nc.ba.bounds
                 , hqm_credit_hist_pipe_core.i_mf_hist_list_a.i_mf.p3_bounds_pipe_min_addr_nc.ba.bounds
                 , sr_hist_list_a_addr_f
                 , hqm_credit_hist_pipe_core.sr_hist_list_a_rdata
                 , hqm_credit_hist_pipe_core.sr_hist_list_a_rdata_struct.ecc
                 , hqm_credit_hist_pipe_core.sr_hist_list_a_rdata_struct.hid
                 , hqm_credit_hist_pipe_core.sr_hist_list_a_rdata_struct.cmp_id
                 , hqm_credit_hist_pipe_core.sr_hist_list_a_rdata_struct.hist_list_info.parity
                 , hqm_credit_hist_pipe_core.sr_hist_list_a_rdata_struct.hist_list_info.qtype.name
                 , hqm_credit_hist_pipe_core.sr_hist_list_a_rdata_struct.hist_list_info.qpri
                 , hqm_credit_hist_pipe_core.sr_hist_list_a_rdata_struct.hist_list_info.qid
                 , hqm_credit_hist_pipe_core.sr_hist_list_a_rdata_struct.hist_list_info.qidix
                 , hqm_credit_hist_pipe_core.sr_hist_list_a_rdata_struct.hist_list_info.reord_mode
                 , hqm_credit_hist_pipe_core.sr_hist_list_a_rdata_struct.hist_list_info.reord_slot
                 , hqm_credit_hist_pipe_core.sr_hist_list_a_rdata_struct.hist_list_info.sn_fid
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp & hqm_credit_hist_pipe_core.reset_pf_done_f & hqm_credit_hist_pipe_core.sr_hist_list_a_we ) begin
        $display("@%0tps [CHP_DEBUG] srw_top: sr_hist_list_a_we cq:0x%h max:0x%h min:0x%h addr:0x%h data:0x%h( ecc:0x%h hid:0x%h cmp_id:0x%h hist_list_info par:%0d qtype:%s qpri:0x%h qid:0x%h qidix:0x%h mode:0x%h slot:0x%h sn:0x%h )"
                 , $time
                 , hqm_credit_hist_pipe_core.i_mf_hist_list_a.i_mf.p2_bounds_pipe_f.addr
                 , hqm_credit_hist_pipe_core.i_mf_hist_list_a.i_mf.p2_bounds_pipe_f.max_addr.ba.bounds
                 , hqm_credit_hist_pipe_core.i_mf_hist_list_a.i_mf.p2_bounds_pipe_f.min_addr.ba.bounds
                 , hqm_credit_hist_pipe_core.sr_hist_list_a_addr
                 , hqm_credit_hist_pipe_core.sr_hist_list_a_wdata
                 , hqm_credit_hist_pipe_core.sr_hist_list_a_wdata_struct.ecc
                 , hqm_credit_hist_pipe_core.sr_hist_list_a_wdata_struct.hid
                 , hqm_credit_hist_pipe_core.sr_hist_list_a_wdata_struct.cmp_id
                 , hqm_credit_hist_pipe_core.sr_hist_list_a_wdata_struct.hist_list_info.parity
                 , hqm_credit_hist_pipe_core.sr_hist_list_a_wdata_struct.hist_list_info.qtype.name
                 , hqm_credit_hist_pipe_core.sr_hist_list_a_wdata_struct.hist_list_info.qpri
                 , hqm_credit_hist_pipe_core.sr_hist_list_a_wdata_struct.hist_list_info.qid
                 , hqm_credit_hist_pipe_core.sr_hist_list_a_wdata_struct.hist_list_info.qidix
                 , hqm_credit_hist_pipe_core.sr_hist_list_a_wdata_struct.hist_list_info.reord_mode
                 , hqm_credit_hist_pipe_core.sr_hist_list_a_wdata_struct.hist_list_info.reord_slot
                 , hqm_credit_hist_pipe_core.sr_hist_list_a_wdata_struct.hist_list_info.sn_fid
                 );
      end

      if ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp & hqm_credit_hist_pipe_core.hcw_enq_w_req_valid & hqm_credit_hist_pipe_core.hcw_enq_w_req_ready ) begin
        if ( hqm_credit_hist_pipe_core.hcw_enq_w_req.user.qe_is_ldb ? 
             ( hqm_credit_hist_pipe_core.hcw_enq_w_req.data.msg_info.qtype == DIRECT ) : 
             ( hqm_credit_hist_pipe_core.hcw_enq_w_req.data.msg_info.qtype != DIRECT ) ) begin
          $display("@%0tps [CHP_ERROR] hcw_enq_w_req: qe_is_ldb(%0d) != hcw.msg_info.qtype(%0s) %s"
                   , $time
                   , hqm_credit_hist_pipe_core.hcw_enq_w_req.user.qe_is_ldb
                   , hqm_credit_hist_pipe_core.hcw_enq_w_req.data.msg_info.qtype.name
                   , hqm_credit_hist_pipe_core.hcw_enq_w_req.data.cmd.hcw_cmd_dec.name
                   );
        end
      end

      if ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp & hqm_credit_hist_pipe_core.chp_rop_hcw_v & hqm_credit_hist_pipe_core.chp_rop_hcw_ready  &
           ( hqm_credit_hist_pipe_core.chp_rop_hcw_data.cmd == CHP_ROP_ENQ_NEW_HCW ) &
           ( ( hqm_credit_hist_pipe_core.chp_rop_hcw_data.hcw_cmd.hcw_cmd_dec == HQM_CMD_ENQ_NEW ) | 
             ( hqm_credit_hist_pipe_core.chp_rop_hcw_data.hcw_cmd.hcw_cmd_dec == HQM_CMD_ENQ_NEW_TOK_RET ) | 
             ( hqm_credit_hist_pipe_core.chp_rop_hcw_data.hcw_cmd.hcw_cmd_dec == HQM_CMD_ENQ_COMP ) | 
             ( hqm_credit_hist_pipe_core.chp_rop_hcw_data.hcw_cmd.hcw_cmd_dec == HQM_CMD_ENQ_COMP_TOK_RET ) | 
             ( hqm_credit_hist_pipe_core.chp_rop_hcw_data.hcw_cmd.hcw_cmd_dec == HQM_CMD_ENQ_FRAG ) | 
             ( hqm_credit_hist_pipe_core.chp_rop_hcw_data.hcw_cmd.hcw_cmd_dec == HQM_CMD_ENQ_FRAG_TOK_RET ) ) ) begin 
        if ( freelist_busy_f[ hqm_credit_hist_pipe_core.chp_rop_hcw_data.flid ] ) begin
          $display("@%0tps [CHP_ERROR] chp_rop_hcw:  sending an already active flid %0d"
                   , $time
                   , hqm_credit_hist_pipe_core.chp_rop_hcw_data.flid
                   );
        end
      end

      if ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp & hqm_credit_hist_pipe_core.qed_chp_sch_v & hqm_credit_hist_pipe_core.qed_chp_sch_ready &
           ( hqm_credit_hist_pipe_core.qed_chp_sch_data.cmd == QED_CHP_SCH_SCHED ) ) begin
        if ( ~ freelist_busy_f[ hqm_credit_hist_pipe_core.qed_chp_sch_data.flid ] ) begin
          $display("@%0tps [CHP_ERROR] qed_chp_sch_data:  receiving an already in-active flid %0d"
                   , $time
                   , hqm_credit_hist_pipe_core.qed_chp_sch_data.flid
                   );
        end 
      end

      if ( hqm_credit_hist_pipe_core.hqm_gated_rst_b_chp & hqm_credit_hist_pipe_core.qed_chp_sch_v & hqm_credit_hist_pipe_core.qed_chp_sch_ready &
           ( hqm_credit_hist_pipe_core.qed_chp_sch_data.cmd == QED_CHP_SCH_TRANSFER ) ) begin
        if ( ~ freelist_busy_f[ hqm_credit_hist_pipe_core.qed_chp_sch_data.flid ] ) begin
          $display("@%0tps [CHP_ERROR] qed_chp_sch_data:  receiving an already in-active flid %0d"
                   , $time
                   , hqm_credit_hist_pipe_core.qed_chp_sch_data.flid
                   );
        end
      end

    end // if ($test$plusargs("HQM_DEBUG_LOW") | $test$plusargs("HQM_DEBUG_MED") | $test$plusargs("HQM_DEBUG_HIGH")) begin

  end // always_ff

  initial begin
    $display("@%0tps [CHP_DEBUG] hqm_credit_hist_pipe initial block ...",$time);
  end // begin

  final begin
    integer i, j;
    $display("@%0tps [CHP_DEBUG] hqm_credit_hist_pipe final block ...",$time);

    if ( hqm_credit_hist_pipe_core.hcw_enq_w_req_valid & ~ hqm_credit_hist_pipe_core.hcw_enq_w_req_ready ) begin
      $display("@%0tps [CHP_INFO] hcw_enq_w_req_v PENDING"
              , $time
              );
    end

    if ( hqm_credit_hist_pipe_core.qed_chp_sch_v & ~ hqm_credit_hist_pipe_core.qed_chp_sch_ready ) begin
      $display("@%0tps [CHP_INFO] qed_chp_sch_v PENDING"
              , $time
              );
    end

    if ( hqm_credit_hist_pipe_core.aqed_chp_sch_v & ~ hqm_credit_hist_pipe_core.aqed_chp_sch_ready ) begin
      $display("@%0tps [CHP_INFO] aqed_chp_sch_v PENDING"
              , $time
              );
    end

    if ( hqm_credit_hist_pipe_core.chp_rop_hcw_v & ~ hqm_credit_hist_pipe_core.chp_rop_hcw_ready ) begin
      $display("@%0tps [CHP_INFO] chp_rop_hcw_v PENDING"
              , $time
              );
    end

    if ( hqm_credit_hist_pipe_core.chp_lsp_token_v & ~ hqm_credit_hist_pipe_core.chp_lsp_token_ready ) begin
      $display("@%0tps [CHP_INFO] chp_lsp_token_v PENDING"
              , $time
              );
    end

    if ( hqm_credit_hist_pipe_core.chp_lsp_cmp_v & ~ hqm_credit_hist_pipe_core.chp_lsp_cmp_ready ) begin
      $display("@%0tps [CHP_INFO] chp_lsp_cmp_v PENDING"
              , $time
              );
    end

    if ( hqm_credit_hist_pipe_core.hcw_sched_w_req_valid & ~ hqm_credit_hist_pipe_core.hcw_sched_w_req_ready ) begin
      $display("@%0tps [CHP_INFO] hcw_sched_w_req_valid PENDING"
              , $time
              );
    end

    if ( hqm_credit_hist_pipe_core.chp_alarm_up_v & ~ hqm_credit_hist_pipe_core.chp_alarm_up_ready ) begin
      $display("@%0tps [CHP_INFO] chp_alarm_up_v PENDING"
              , $time
              );
    end

    if ( hqm_credit_hist_pipe_core.chp_alarm_down_v & ~ hqm_credit_hist_pipe_core.chp_alarm_down_ready ) begin
      $display("@%0tps [CHP_INFO] chp_alarm_down_v PENDING"
              , $time
              );
    end

    if ( hqm_credit_hist_pipe_core.interrupt_w_req_valid & ~ hqm_credit_hist_pipe_core.interrupt_w_req_ready ) begin
      $display("@%0tps [CHP_INFO] interrupt_w_req PENDING"
              , $time
              );
    end

    if ( hqm_credit_hist_pipe_core.cwdi_interrupt_w_req_valid & ~ hqm_credit_hist_pipe_core.cwdi_interrupt_w_req_ready ) begin
      $display("@%0tps [CHP_INFO] cwdi_interrupt_w_req PENDING"
              , $time
              );
    end

    $display("@%0tps [CHP_INFO] hqm_par_reset_done                                                     :#%0d"
            , $time
            , hqm_credit_hist_pipe_core.hqm_proc_reset_done
            );

    $display("@%0tps [CHP_INFO] chp_unit_idle                                                          :#%0d"
            , $time
            , hqm_credit_hist_pipe_core.chp_unit_idle       
            );

    $display("@%0tps [CHP_INFO] chp_unit_pipeidle                                                      :#%0d"
            , $time
            , hqm_credit_hist_pipe_core.chp_unit_pipeidle       
            );

    $display("@%0tps [CHP_INFO] chp_reset_done                                                         :#%0d"
            , $time
            , hqm_credit_hist_pipe_core.chp_reset_done          
            );

    $display("@%0tps [CHP_INFO] cfg_unit_idle_reg_f                                                    :#%0d ( timeout:%0d err:%0d wait:%0d active:%0d busy:%0d done:%0d ready:%0d unit_idle:%0d pipe_ile:%0d )"
            , $time
            , hqm_credit_hist_pipe_core.cfg_unit_idle_reg_f     
            , hqm_credit_hist_pipe_core.cfg_unit_idle_reg_f.cfg_timeout
            , hqm_credit_hist_pipe_core.cfg_unit_idle_reg_f.cfg_err
            , hqm_credit_hist_pipe_core.cfg_unit_idle_reg_f.cfg_wait
            , hqm_credit_hist_pipe_core.cfg_unit_idle_reg_f.cfg_active
            , hqm_credit_hist_pipe_core.cfg_unit_idle_reg_f.cfg_busy
            , hqm_credit_hist_pipe_core.cfg_unit_idle_reg_f.cfg_done
            , hqm_credit_hist_pipe_core.cfg_unit_idle_reg_f.cfg_ready
            , hqm_credit_hist_pipe_core.cfg_unit_idle_reg_f.unit_idle
            , hqm_credit_hist_pipe_core.cfg_unit_idle_reg_f.pipe_idle
            );

    $display("@%0tps [CHP_INFO] qed_to_cq_pipe_credit_status                                           :  %8h ( hwm: %0d size:%0d empty:%d full:%d afull:%d er_or:%d )"
            , $time
            , hqm_credit_hist_pipe_core.qed_to_cq_pipe_credit_status
            , hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_ingress.cfg_qed_to_cq_pipe_credit_hwm
            , hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_ingress.qed_to_cq_pipe_credit_size
            , hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_ingress.qed_to_cq_pipe_credit_empty
            , hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_ingress.qed_to_cq_pipe_credit_full
            , hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_ingress.qed_to_cq_pipe_credit_afull
            , hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_ingress.qed_to_cq_pipe_credit_error
            );

    $display("@%0tps [CHP_INFO] chp_rop_pipe_credit_status                                             : %8h ( hwm:%0d size:%0d empty:%d full:%d afull:%d er_or:%d )"
            , $time
            , hqm_credit_hist_pipe_core.chp_rop_pipe_credit_status
            , hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_arbiter.cfg_chp_rop_pipe_credit_hwm
            , hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_arbiter.chp_rop_pipe_credit_size
            , hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_arbiter.chp_rop_pipe_credit_empty
            , hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_arbiter.chp_rop_pipe_credit_full
            , hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_arbiter.chp_rop_pipe_credit_afull
            , hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_arbiter.chp_rop_pipe_credit_error
            );

    $display("@%0tps [CHP_INFO] chp_lsp_tok_pipe_credit_status                                         : %8h ( hwm:%0d size:%0d empty:%d full:%d afull:%d er_or:%d )"
            , $time
            , hqm_credit_hist_pipe_core.chp_lsp_tok_pipe_credit_status
            , hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_arbiter.cfg_chp_lsp_tok_pipe_credit_hwm
            , hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_arbiter.chp_lsp_tok_pipe_credit_size
            , hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_arbiter.chp_lsp_tok_pipe_credit_empty
            , hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_arbiter.chp_lsp_tok_pipe_credit_full
            , hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_arbiter.chp_lsp_tok_pipe_credit_afull
            , hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_arbiter.chp_lsp_tok_pipe_credit_error
            );

    $display("@%0tps [CHP_INFO] chp_lsp_ap_cmp_pipe_credit_status                                      : %8h ( hwm:%0d size:%0d empty:%d full:%d afull:%d er_or:%d )"
            , $time
            , hqm_credit_hist_pipe_core.chp_lsp_ap_cmp_pipe_credit_status
            , hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_arbiter.cfg_chp_lsp_ap_cmp_pipe_credit_hwm
            , hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_arbiter.chp_lsp_ap_cmp_pipe_credit_size
            , hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_arbiter.chp_lsp_ap_cmp_pipe_credit_empty
            , hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_arbiter.chp_lsp_ap_cmp_pipe_credit_full
            , hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_arbiter.chp_lsp_ap_cmp_pipe_credit_afull
            , hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_arbiter.chp_lsp_ap_cmp_pipe_credit_error
            );

    $display("@%0tps [CHP_INFO] chp_outbound_hcw_pipe_credit_status                                    : %8h ( hwm:%0d size:%0d empty:%d full:%d afull:%d er_or:%d )"
            , $time
            , hqm_credit_hist_pipe_core.chp_outbound_hcw_pipe_credit_status
            , hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_arbiter.cfg_chp_outbound_hcw_pipe_credit_hwm
            , hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_arbiter.chp_outbound_hcw_pipe_credit_size
            , hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_arbiter.chp_outbound_hcw_pipe_credit_empty
            , hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_arbiter.chp_outbound_hcw_pipe_credit_full
            , hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_arbiter.chp_outbound_hcw_pipe_credit_afull
            , hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_arbiter.chp_outbound_hcw_pipe_credit_error
            );

    $display("@%0tps [CHP_INFO] egress_credit_status                                                   :  %8h ( hwm: %0d size:%0d empty:%d full:%d afull:%d er_or:%d )"
            , $time
            , { hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_egress.egress_credit_size
              , hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_egress.egress_credit_empty
              , hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_egress.egress_credit_full
              , hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_egress.egress_credit_afull
              , hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_egress.egress_credit_error
              }
            , hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_egress.cfg_egress_pipecredits
            , hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_egress.egress_credit_size
            , hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_egress.egress_credit_empty
            , hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_egress.egress_credit_full
            , hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_egress.egress_credit_afull
            , hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_egress.egress_credit_error
            );

    if ( chp_alarm_up_count_f > 0 ) begin
      $display("@%0tps [CHP_INFO] SIM COUNTER chp_alarm_up_count                                         :#%08d ( SYS:#%0d AQE:#%0d AP:#%0d CHP:#%0d DP:#%0d QED:#%0d NALB:#%0d ROP:#%0d LSP:#%0d MSTR:#%0d ) <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
              , $time
              , chp_alarm_up_count_f          
              , chp_alarm_up_unit_count_f [ 1 ] 
              , chp_alarm_up_unit_count_f [ 2 ] 
              , chp_alarm_up_unit_count_f [ 3 ] 
              , chp_alarm_up_unit_count_f [ 4 ] 
              , chp_alarm_up_unit_count_f [ 5 ] 
              , chp_alarm_up_unit_count_f [ 6 ] 
              , chp_alarm_up_unit_count_f [ 7 ] 
              , chp_alarm_up_unit_count_f [ 8 ] 
              , chp_alarm_up_unit_count_f [ 9 ] 
              , chp_alarm_up_unit_count_f [ 10 ] 
              );
    end

    if ( chp_alarm_down_count_f > 0 ) begin
      $display("@%0tps [CHP_INFO] SIM COUNTER chp_alarm_down_count                                       :#%08d <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
              , $time
              , chp_alarm_down_count_f          
              );
    end

    if ( int_inf_v_count_f > 0 ) begin
      $display("@%0tps [CHP_INFO] SIM COUNTER int_inf_v_count                                            :#%08d <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
              , $time
              , int_inf_v_count_f          
              );
      if ( err_hw_class_01_sticky_f [ 0 ] ) begin
        $display("@%0tps [CHP_INFO]             err_hw_class_01 [ 0 ] egress_err_pipe_credit_error <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
                , $time
                );
      end
      if ( err_hw_class_01_sticky_f [ 1 ] ) begin
        $display("@%0tps [CHP_INFO]             err_hw_class_01 [ 1 ] egress_err_parity_ldb_cq_token_depth_select <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
                , $time
                );
      end
      if ( err_hw_class_01_sticky_f [ 2 ] ) begin
        $display("@%0tps [CHP_INFO]             err_hw_class_01 [ 2 ] egress_err_parity_dir_cq_token_depth_select <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
                , $time
                );
      end
      if ( err_hw_class_01_sticky_f [ 3 ] ) begin
        $display("@%0tps [CHP_INFO]             err_hw_class_01 [ 3 ] egress_err_parity_ldb_cq_intr_thresh <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
                , $time
                );
      end
      if ( err_hw_class_01_sticky_f [ 4 ] ) begin
        $display("@%0tps [CHP_INFO]             err_hw_class_01 [ 4 ] egress_err_parity_dir_cq_intr_thresh <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
                , $time
                );
      end
      if ( err_hw_class_01_sticky_f [ 5 ] ) begin
        $display("@%0tps [CHP_INFO]             err_hw_class_01 [ 5 ] egress_err_residue_ldb_cq_wptr <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
                , $time
                );
      end
      if ( err_hw_class_01_sticky_f [ 6 ] ) begin
        $display("@%0tps [CHP_INFO]             err_hw_class_01 [ 6 ] egress_err_residue_dir_cq_wptr <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
                , $time
                );
      end
      if ( err_hw_class_01_sticky_f [ 7 ] ) begin
        $display("@%0tps [CHP_INFO]             err_hw_class_01 [ 7 ] egress_err_residue_ldb_cq_depth <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
                , $time
                );
      end
      if ( err_hw_class_01_sticky_f [ 8 ] ) begin
        $display("@%0tps [CHP_INFO]             err_hw_class_01 [ 8 ] egress_err_residue_dir_cq_depth <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
                , $time
                );
      end
      if ( err_hw_class_01_sticky_f [ 9 ] ) begin
        $display("@%0tps [CHP_INFO]             err_hw_class_01 [ 9 ] arb_err_chp_pipe_credit_error <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
                , $time
                );
      end
      if ( err_hw_class_01_sticky_f [ 10 ] ) begin
        $display("@%0tps [CHP_INFO]             err_hw_class_01 [ 10 ] arb_err_illegal_cmd_error <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
                , $time
                );
      end
      if ( err_hw_class_01_sticky_f [ 11 ] ) begin
        $display("@%0tps [CHP_INFO]             err_hw_class_01 [ 11 ] ing_err_hcw_enq_user_parity_error <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
                , $time
                );
      end
      if ( err_hw_class_01_sticky_f [ 12 ] ) begin
        $display("@%0tps [CHP_INFO]             err_hw_class_01 [ 12 ] ing_err_hcw_enq_data_parity_error <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
                , $time
                );
      end

      if ( err_hw_class_01_sticky_f [ 13 ] ) begin
        $display("@%0tps [CHP_INFO]             err_hw_class_01 [ 13 ] enqpipe_err_enq_to_rop_freelist_uf_error <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
                , $time
                );
      end
      if ( err_hw_class_01_sticky_f [ 14 ] ) begin
        $display("@%0tps [CHP_INFO]             err_hw_class_01 [ 14 ] qed_to_cq_pipe_credit_error <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
                , $time
                );
      end
      if ( err_hw_class_01_sticky_f [ 15 ] ) begin
        $display("@%0tps [CHP_INFO]             err_hw_class_01 [ 15 ] ing_err_qed_chp_sch_flid_ret_flid_parity_error <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
                , $time
                );
      end
      if ( err_hw_class_01_sticky_f [ 16 ] ) begin
        $display("@%0tps [CHP_INFO]             err_hw_class_01 [ 16 ] ing_err_qed_chp_sch_cq_parity_error/ing_err_aqed_chp_sch_cq_parity_error <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
                , $time
                );
      end
      if ( err_hw_class_01_sticky_f [ 17 ] ) begin
        $display("@%0tps [CHP_INFO]             err_hw_class_01 [ 17 ] ing_err_qed_chp_sch_vas_parity_error/ing_err_aqed_chp_sch_vas_parity_error <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
                , $time
                );
      end
      if ( err_hw_class_01_sticky_f [ 18 ] ) begin
        $display("@%0tps [CHP_INFO]             err_hw_class_01 [ 18 ] ing_err_enq_vas_credit_count_residue_err <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
                , $time
                );
      end
      if ( err_hw_class_01_sticky_f [ 19 ] ) begin
        $display("@%0tps [CHP_INFO]             err_hw_class_01 [ 19 ] ing_err_sch_vas_credit_count_residue_err <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
                , $time
                );
      end
      if ( err_hw_class_01_sticky_f [ 20 ] ) begin
        $display("@%0tps [CHP_INFO]             err_hw_class_01 [ 20 ] schpipe_err_pipeline_parity_err <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
                , $time
                );
      end
      if ( err_hw_class_01_sticky_f [ 22 ] ) begin
        $display("@%0tps [CHP_INFO]             err_hw_class_01 [ 22 ] sharepipe_error <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
                , $time
                );
      end
      if ( err_hw_class_01_sticky_f [ 23 ] ) begin
        $display("@%0tps [CHP_INFO]             err_hw_class_01 [ 23 ] ram_access_error <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
                , $time
                );
      end
      if ( err_hw_class_01_sticky_f [ 24 ] ) begin
        $display("@%0tps [CHP_INFO]             err_hw_class_01 [ 24 ] hist_list_of <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
                , $time
                );
      end
      if ( err_hw_class_01_sticky_f [ 25 ] ) begin
        $display("@%0tps [CHP_INFO]             err_hw_class_01 [ 25 ] freelist_of <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
                , $time
                );
      end
      if ( err_hw_class_01_sticky_f [ 26 ] ) begin
        $display("@%0tps [CHP_INFO]             err_hw_class_01 [ 26 ] freelist_pop_error <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
                , $time
                );
      end
      if ( err_hw_class_01_sticky_f [ 27 ] ) begin
        $display("@%0tps [CHP_INFO]             err_hw_class_01 [ 27 ] fifo_chp_rop_hcw_of <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
                , $time
                );
      end
      if ( err_hw_class_02_sticky_f [ 0 ] ) begin
        $display("@%0tps [CHP_INFO]             err_hw_class_02 [ 0 ] fifo_chp_rop_hcw_uf <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
                , $time
                );
      end
      if ( err_hw_class_02_sticky_f [ 1 ] ) begin
        $display("@%0tps [CHP_INFO]             err_hw_class_02 [ 1 ] fifo_chp_lsp_tok_of <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
                , $time
                );
      end
      if ( err_hw_class_02_sticky_f [ 2 ] ) begin
        $display("@%0tps [CHP_INFO]             err_hw_class_02 [ 2 ] fifo_chp_lsp_tok_uf <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
                , $time
                );
      end
      if ( err_hw_class_02_sticky_f [ 3 ] ) begin
        $display("@%0tps [CHP_INFO]             err_hw_class_02 [ 3 ] fifo_chp_lsp_ap_cmp_of <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
                , $time
                );
      end
      if ( err_hw_class_02_sticky_f [ 4 ] ) begin
        $display("@%0tps [CHP_INFO]             err_hw_class_02 [ 4 ] fifo_chp_lsp_ap_cmp_uf <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
                , $time
                );
      end
      if ( err_hw_class_02_sticky_f [ 5 ] ) begin
        $display("@%0tps [CHP_INFO]             err_hw_class_02 [ 5 ] fifo_outbound_hcw_of <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
                , $time
                );
      end
      if ( err_hw_class_02_sticky_f [ 6 ] ) begin
        $display("@%0tps [CHP_INFO]             err_hw_class_02 [ 6 ] fifo_outbound_hcw_uf <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
                , $time
                );
      end
      if ( err_hw_class_02_sticky_f [ 7 ] ) begin
        $display("@%0tps [CHP_INFO]             err_hw_class_02 [ 7 ] fifo_qed_to_cq_of <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
                , $time
                );
      end
      if ( err_hw_class_02_sticky_f [ 8 ] ) begin
        $display("@%0tps [CHP_INFO]             err_hw_class_02 [ 8 ] fifo_qed_to_cq_uf <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
                , $time
                );
      end
      if ( err_hw_class_02_sticky_f [ 9 ] ) begin
        $display("@%0tps [CHP_INFO]             err_hw_class_02 [ 9 ] hist_list_residue_error_cfg <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
                , $time
                );
      end
      if ( err_hw_class_02_sticky_f [ 10 ] ) begin
        $display("@%0tps [CHP_INFO]             err_hw_class_02 [ 10 ] cfg_rx_fifo_status_underflow <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
                , $time
                );
      end
      if ( err_hw_class_02_sticky_f [ 11 ] ) begin
        $display("@%0tps [CHP_INFO]             err_hw_class_02 [ 11 ] cfg_rx_fifo_status_overflow <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
                , $time
                );
      end
      if ( err_hw_class_02_sticky_f [ 12 ] ) begin
        $display("@%0tps [CHP_INFO]             err_hw_class_02 [ 12 ] fifo_chp_sys_tx_fifo_mem_of <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
                , $time
                );
      end
      if ( err_hw_class_02_sticky_f [ 13 ] ) begin
        $display("@%0tps [CHP_INFO]             err_hw_class_02 [ 13 ] fifo_chp_sys_tx_fifo_mem_uf <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
                , $time
                );
      end
      if ( err_hw_class_02_sticky_f [ 15 ] ) begin
        $display("@%0tps [CHP_INFO]             err_hw_class_02 [ 15 ] ing_err_qed_chp_sch_rx_sync_out_cmd_error <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
                , $time
                );
      end
    end

    if ( int_cor_v_count_f > 0 ) begin
      $display("@%0tps [CHP_INFO] SIM COUNTER int_cor_v_count                                            :#%08d <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
              , $time
              , int_cor_v_count_f          
              );
    end

    if ( int_unc_v_count_f > 0 ) begin
      $display("@%0tps [CHP_INFO] SIM COUNTER int_unc_v_count                                            :#%08d <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
              , $time
              , int_unc_v_count_f          
              );
    end

    for ( int i = 0 ; i < 64 ; i++ ) begin
      if ( ldb_cq_interrupt_w_req_count_f [ i ] > 0 ) begin
        $display("@%0tps [CHP_INFO] SIM COUNTER ldb_cq_interrupt_w_req_count                               :#%08d ( cq %0d )"
                , $time
                , ldb_cq_interrupt_w_req_count_f [ i ]          
                , i
                );
      end
      if ( ldb_cq_cwdi_interrupt_w_req_count_f [ i ] > 0 ) begin
        $display("@%0tps [CHP_INFO] SIM COUNTER ldb_cq_cwdi_interrupt_w_req_count                          :#%08d ( cq %0d )"
                , $time
                , ldb_cq_cwdi_interrupt_w_req_count_f [ i ]          
                , i
                );
      end
    end

    for ( int i = 0 ; i < 96 ; i++ ) begin
      if ( dir_cq_interrupt_w_req_count_f [ i ] > 0 ) begin
        $display("@%0tps [CHP_INFO] SIM COUNTER dir_cq_interrupt_w_req_count                               :#%08d ( cq %0d )"
                , $time
                , dir_cq_interrupt_w_req_count_f [ i ]          
                , i
                );
      end
      if ( dir_cq_cwdi_interrupt_w_req_count_f [ i ] > 0 ) begin
        $display("@%0tps [CHP_INFO] SIM COUNTER dir_cq_cwdi_interrupt_w_req_count                          :#%08d ( cq %0d )"
                , $time
                , dir_cq_cwdi_interrupt_w_req_count_f [ i ]          
                , i
                );
      end
    end

    if ( fifo_chp_rop_hcw_of_count_f > 0 ) begin
      $display("@%0tps [CHP_INFO] SIM COUNTER fifo_chp_rop_hcw_of_count                                  :#%08d <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
              , $time
              , fifo_chp_rop_hcw_of_count_f          
              );
    end

    if ( fifo_chp_rop_hcw_uf_count_f > 0 ) begin
      $display("@%0tps [CHP_INFO] SIM COUNTER fifo_chp_rop_hcw_uf_count                                  :#%08d <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
              , $time
              , fifo_chp_rop_hcw_uf_count_f          
              );
    end

    if ( fifo_chp_lsp_tok_of_count_f > 0 ) begin
      $display("@%0tps [CHP_INFO] SIM COUNTER fifo_chp_lsp_tok_of_count                                  :#%08d <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
              , $time
              , fifo_chp_lsp_tok_of_count_f          
              );
    end

    if ( fifo_chp_lsp_tok_uf_count_f > 0 ) begin
      $display("@%0tps [CHP_INFO] SIM COUNTER fifo_chp_lsp_tok_uf_count                                  :#%08d <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
              , $time
              , fifo_chp_lsp_tok_uf_count_f          
              );
    end

    if ( fifo_chp_lsp_ap_cmp_of_count_f > 0 ) begin
      $display("@%0tps [CHP_INFO] SIM COUNTER fifo_chp_lsp_ap_cmp_of_count                               :#%08d <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
              , $time
              , fifo_chp_lsp_ap_cmp_of_count_f          
              );
    end

    if ( fifo_chp_lsp_ap_cmp_uf_count_f > 0 ) begin
      $display("@%0tps [CHP_INFO] SIM COUNTER fifo_chp_lsp_ap_cmp_uf_count                               :#%08d <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
              , $time
              , fifo_chp_lsp_ap_cmp_uf_count_f          
              );
    end

    if ( fifo_outbound_hcw_of_count_f > 0 ) begin
      $display("@%0tps [CHP_INFO] SIM COUNTER fifo_outbound_hcw_of_count                                 :#%08d <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
              , $time
              , fifo_outbound_hcw_of_count_f          
              );
    end

    if ( fifo_outbound_hcw_uf_count_f > 0 ) begin
      $display("@%0tps [CHP_INFO] SIM COUNTER fifo_outbound_hcw_uf_count                                 :#%08d <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
              , $time
              , fifo_outbound_hcw_uf_count_f          
              );
    end

    if ( fifo_qed_to_cq_of_count_f > 0 ) begin
      $display("@%0tps [CHP_INFO] SIM COUNTER fifo_qed_to_cq_of_count                                    :#%08d <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
              , $time
              , fifo_qed_to_cq_of_count_f          
              );
    end

    if ( fifo_qed_to_cq_uf_count_f > 0 ) begin
      $display("@%0tps [CHP_INFO] SIM COUNTER fifo_qed_to_cq_uf_count                                    :#%08d <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
              , $time
              , fifo_qed_to_cq_uf_count_f          
              );
    end

    if ( hist_list_residue_error_cfg_count_f > 0 ) begin
      $display("@%0tps [CHP_INFO] SIM COUNTER hist_list_residue_error_cfg_count                          :#%08d <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
              , $time
              , hist_list_residue_error_cfg_count_f          
              );
    end

    if ( cfg_rx_fifo_status_underflow_count_f > 0 ) begin
      $display("@%0tps [CHP_INFO] SIM COUNTER cfg_rx_fifo_status_underflow_count                         :#%08d <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
              , $time
              , cfg_rx_fifo_status_underflow_count_f          
              );
    end

    if ( cfg_rx_fifo_status_overflow_count_f > 0 ) begin
      $display("@%0tps [CHP_INFO] SIM COUNTER cfg_rx_fifo_status_overflow_count                          :#%08d <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
              , $time
              , cfg_rx_fifo_status_overflow_count_f          
              );
    end

    if ( fifo_chp_sys_tx_fifo_mem_of_count_f > 0 ) begin
      $display("@%0tps [CHP_INFO] SIM COUNTER fifo_chp_sys_tx_fifo_mem_of_count                          :#%08d <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
              , $time
              , fifo_chp_sys_tx_fifo_mem_of_count_f          
              );
    end

    if ( fifo_chp_sys_tx_fifo_mem_uf_count_f > 0 ) begin
      $display("@%0tps [CHP_INFO] SIM COUNTER fifo_chp_sys_tx_fifo_mem_uf_count                          :#%08d <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
              , $time
              , fifo_chp_sys_tx_fifo_mem_uf_count_f          
              );
    end

    if ( ing_err_qed_chp_sch_rx_sync_out_cmd_error_count_f > 0 ) begin
      $display("@%0tps [CHP_INFO] SIM COUNTER ing_err_qed_chp_sch_rx_sync_out_cmd_error_count            :#%08d <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
              , $time
              , ing_err_qed_chp_sch_rx_sync_out_cmd_error_count_f          
              );
    end

    if ( chp_cfg_req_up_read_count_f > 0 ) begin
      $display("@%0tps [CHP_INFO] SIM COUNTER chp_cfg_req_up_read_count                                  :#%08d ( chp:#%0d )"
              , $time
              , chp_cfg_req_up_read_count_f
              , chp_cfg_req_up_chp_read_count_f
              );
    end

    if ( chp_cfg_req_up_write_count_f > 0 ) begin
      $display("@%0tps [CHP_INFO] SIM COUNTER chp_cfg_req_up_write_count                                 :#%08d ( chp:#%0d )"
              , $time
              , chp_cfg_req_up_write_count_f
              , chp_cfg_req_up_chp_write_count_f
              );
    end

    if ( chp_cfg_req_down_read_count_f > 0 ) begin
      $display("@%0tps [CHP_INFO] SIM COUNTER chp_cfg_req_down_read_count                                :#%08d"
              , $time
              , chp_cfg_req_down_read_count_f
              );
    end

    if ( chp_cfg_req_down_write_count_f > 0 ) begin
      $display("@%0tps [CHP_INFO] SIM COUNTER chp_cfg_req_down_write_count                               :#%08d"
              , $time
              , chp_cfg_req_down_write_count_f
              );
    end

    if ( chp_cfg_rsp_down_count_f > 0 ) begin
      $display("@%0tps [CHP_INFO] SIM COUNTER chp_cfg_rsp_down_count                                     :#%08d ( err:#%0d )"
              , $time
              , chp_cfg_rsp_down_count_f
              , chp_cfg_rsp_down_err_count_f
              );
    end

    if ( unit_cfg_req_write_count_f > 0 ) begin
      $display("@%0tps [CHP_INFO] SIM COUNTER unit_cfg_req_write_count                                   :#%08d"
              , $time
              , unit_cfg_req_write_count_f
              );
    end

    if ( unit_cfg_req_read_count_f > 0 ) begin
      $display("@%0tps [CHP_INFO] SIM COUNTER unit_cfg_req_read_count                                    :#%08d"
              , $time
              , unit_cfg_req_read_count_f
              );
    end

    if ( hcw_enq_w_req_qtype_error_count_f > 0 ) begin
      $display("@%0tps [CHP_INFO] SIM COUNTER hcw_enq_w_req_qtype_error_count                            :#%08d <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
              , $time
              , hcw_enq_w_req_qtype_error_count_f
              );
    end

    if ( hist_list_of_count_f > 0 ) begin
      $display("@%0tps [CHP_INFO] SIM COUNTER hist_list_of_count                                         :#%08d <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
              , $time
              , hist_list_of_count_f          
              );
    end

    if ( hist_list_uf_count_f > 0 ) begin
      $display("@%0tps [CHP_INFO] SIM COUNTER hist_list_uf_count                                         :#%08d <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
              , $time
              , hist_list_uf_count_f          
              );
    end

    if ( hist_list_a_of_count_f > 0 ) begin
      $display("@%0tps [CHP_INFO] SIM COUNTER hist_list_a_of_count                                       :#%08d <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
              , $time
              , hist_list_a_of_count_f          
              );
    end

    if ( hist_list_a_uf_count_f > 0 ) begin
      $display("@%0tps [CHP_INFO] SIM COUNTER hist_list_a_uf_count                                       :#%08d <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
              , $time
              , hist_list_a_uf_count_f          
              );
    end

    if ( freelist_of_count_f > 0 ) begin
      $display("@%0tps [CHP_INFO] SIM COUNTER freelist_of_count                                          :#%08d <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
              , $time
              , freelist_of_count_f          
              );
    end

    if ( ing_err_hcw_enq_invalid_hcw_cmd_count_f > 0 ) begin
      $display("@%0tps [CHP_INFO] SIM COUNTER ing_err_hcw_enq_invalid_hcw_cmd_count                      :#%08d <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
              , $time
              , ing_err_hcw_enq_invalid_hcw_cmd_count_f
              );
    end

    if ( ing_err_hcw_enq_user_parity_error_count_f > 0 ) begin
      $display("@%0tps [CHP_INFO] SIM COUNTER ing_err_hcw_enq_user_parity_error_count                    :#%08d <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
              , $time
              , ing_err_hcw_enq_user_parity_error_count_f
              );
    end

    if ( ing_err_hcw_enq_data_parity_error_count_f > 0 ) begin
      $display("@%0tps [CHP_INFO] SIM COUNTER ing_err_hcw_enq_data_parity_error_count                    :#%08d <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
              , $time
              , ing_err_hcw_enq_data_parity_error_count_f
              );
    end

    if ( ing_err_enq_vas_credit_count_residue_error_count_f > 0 ) begin
      $display("@%0tps [CHP_INFO] SIM COUNTER ing_err_enq_vas_credit_count_residue_error_count           :#%08d <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
              , $time
              , ing_err_enq_vas_credit_count_residue_error_count_f
              );
    end

    if ( enqpipe_err_hist_list_data_error_sb_count_f > 0 ) begin
      $display("@%0tps [CHP_INFO] SIM COUNTER enqpipe_err_hist_list_data_error_sb_count                  :#%08d <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
              , $time
              , enqpipe_err_hist_list_data_error_sb_count_f
              );
    end

    if ( enqpipe_err_freelist_data_error_sb_count_f > 0 ) begin
      $display("@%0tps [CHP_INFO] SIM COUNTER enqpipe_err_freelist_data_error_sb_count                   :#%08d <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
              , $time
              , enqpipe_err_freelist_data_error_sb_count_f
              );
    end

    if ( enqpipe_err_enq_to_rop_error_drop_count_f > 0 ) begin
      $display("@%0tps [CHP_INFO] SIM COUNTER enqpipe_err_enq_to_rop_error_drop_count                    :#%08d ( vas_out_of_crd:%0d excess_frag:%0d freelist uf:%0d mb:%0d ) <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
              , $time
              , enqpipe_err_enq_to_rop_error_drop_count_f
              , enqpipe_err_vas_out_of_credit_count_f
              , enqpipe_err_excess_frag_count_f
              , enqpipe_err_freelist_uf_count_f
              , enqpipe_err_freelist_data_error_mb_count_f
              );
    end

    if ( enqpipe_err_enq_to_lsp_cmp_error_drop_count_f > 0 ) begin
      $display("@%0tps [CHP_INFO] SIM COUNTER enqpipe_err_enq_to_lsp_cmp_error_drop_count                :#%08d ( hist_list uf:%0d res:%0d ) <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
              , $time
              , enqpipe_err_enq_to_lsp_cmp_error_drop_count_f
              , enqpipe_err_hist_list_uf_count_f
              , enqpipe_err_hist_list_residue_error_count_f
              );
    end

    if ( enqpipe_err_release_qtype_error_drop_count_f > 0 ) begin
      $display("@%0tps [CHP_INFO] SIM COUNTER enqpipe_err_release_qtype_error_drop_count                 :#%08d <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
              , $time
              , enqpipe_err_release_qtype_error_drop_count_f
              );
    end

    if ( ing_err_sch_vas_credit_count_residue_err_count_f > 0 ) begin
      $display("@%0tps [CHP_INFO] SIM COUNTER ing_err_sch_vas_credit_count_residue_err_count             :#%08d <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
              , $time
              , ing_err_sch_vas_credit_count_residue_err_count_f
              );
    end

    if ( egress_err_pipe_credit_error_count_f > 0 ) begin
      $display("@%0tps [CHP_INFO] SIM COUNTER egress_err_pipe_credit_error_count                         :#%08d <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
              , $time
              , egress_err_pipe_credit_error_count_f
              );
    end

    if ( egress_err_parity_ldb_cq_token_depth_select_count_f > 0 ) begin
      $display("@%0tps [CHP_INFO] SIM COUNTER egress_err_parity_ldb_cq_token_depth_select_count          :#%08d <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
              , $time
              , egress_err_parity_ldb_cq_token_depth_select_count_f
              );
    end

    if ( egress_err_parity_dir_cq_token_depth_select_count_f > 0 ) begin
      $display("@%0tps [CHP_INFO] SIM COUNTER egress_err_parity_dir_cq_token_depth_select_count          :#%08d <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
              , $time
              , egress_err_parity_dir_cq_token_depth_select_count_f
              );
    end

    if ( egress_err_parity_ldb_cq_intr_thresh_count_f > 0 ) begin
      $display("@%0tps [CHP_INFO] SIM COUNTER egress_err_parity_ldb_cq_intr_thresh_count                 :#%08d <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
              , $time
              , egress_err_parity_ldb_cq_intr_thresh_count_f
              );
    end

    if ( egress_err_parity_dir_cq_intr_thresh_count_f > 0 ) begin
      $display("@%0tps [CHP_INFO] SIM COUNTER egress_err_parity_dir_cq_intr_thresh_count                 :#%08d <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
              , $time
              , egress_err_parity_dir_cq_intr_thresh_count_f
              );
    end

    if ( egress_err_residue_ldb_cq_wptr_count_f > 0 ) begin
      $display("@%0tps [CHP_INFO] SIM COUNTER egress_err_residue_ldb_cq_wptr_count                       :#%08d <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
              , $time
              , egress_err_residue_ldb_cq_wptr_count_f
              );
    end

    if ( egress_err_residue_dir_cq_wptr_count_f > 0 ) begin
      $display("@%0tps [CHP_INFO] SIM COUNTER egress_err_residue_dir_cq_wptr_count                       :#%08d <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
              , $time
              , egress_err_residue_dir_cq_wptr_count_f
              );
    end

    if ( egress_err_residue_ldb_cq_depth_count_f > 0 ) begin
      $display("@%0tps [CHP_INFO] SIM COUNTER egress_err_residue_ldb_cq_depth_count                      :#%08d <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
              , $time
              , egress_err_residue_ldb_cq_depth_count_f
              );
    end

    if ( egress_err_residue_dir_cq_depth_count_f > 0 ) begin
      $display("@%0tps [CHP_INFO] SIM COUNTER egress_err_residue_dir_cq_depth_count                      :#%08d <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
              , $time
              , egress_err_residue_dir_cq_depth_count_f
              );
    end

    if ( egress_err_hcw_ecc_sb_count_f > 0 ) begin
      $display("@%0tps [CHP_INFO] SIM COUNTER egress_err_hcw_ecc_sb                                      :#%08d <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
              , $time
              , egress_err_hcw_ecc_sb_count_f
              );
    end

    if ( egress_err_hcw_ecc_mb_count_f > 0 ) begin
      $display("@%0tps [CHP_INFO] SIM COUNTER egress_err_hcw_ecc_mb                                      :#%08d <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
              , $time
              , egress_err_hcw_ecc_mb_count_f
              );
    end

    if ( egress_err_dir_cq_depth_underflow_count_f > 0 ) begin
      $display("@%0tps [CHP_INFO] SIM COUNTER egress_err_dir_cq_depth_underflow_count                    :#%08d <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
              , $time
              , egress_err_dir_cq_depth_underflow_count_f
              );
    end

    if ( schpipe_err_pipeline_parity_err_count_f > 0 ) begin
      $display("@%0tps [CHP_INFO] SIM COUNTER schpipe_err_pipeline_parity_err_count                      :#%08d <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
              , $time
              , schpipe_err_pipeline_parity_err_count_f
              );
    end

    if ( schpipe_err_ldb_cq_hcw_h_ecc_sb_err_count_f > 0 ) begin
      $display("@%0tps [CHP_INFO] SIM COUNTER schpipe_err_ldb_cq_hcw_h_ecc_sb_err_count                  :#%08d <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
              , $time
              , schpipe_err_ldb_cq_hcw_h_ecc_sb_err_count_f
              );
    end

    if ( schpipe_err_ldb_cq_hcw_h_ecc_mb_err_count_f > 0 ) begin
      $display("@%0tps [CHP_INFO] SIM COUNTER schpipe_err_ldb_cq_hcw_h_ecc_mb_err_count                  :#%08d <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
              , $time
              , schpipe_err_ldb_cq_hcw_h_ecc_mb_err_count_f
              );
    end

    if ( egress_err_ldb_cq_depth_underflow_count_f > 0 ) begin
      $display("@%0tps [CHP_INFO] SIM COUNTER egress_err_ldb_cq_depth_underflow_count                    :#%08d <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
              , $time
              , egress_err_ldb_cq_depth_underflow_count_f
              );
    end

    if ( egress_err_dir_cq_depth_overflow_count_f > 0 ) begin
      $display("@%0tps [CHP_INFO] SIM COUNTER egress_err_dir_cq_depth_overflow_count                     :#%08d <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
 
              , $time
              , egress_err_dir_cq_depth_overflow_count_f
              );
    end

    if ( egress_err_ldb_cq_depth_overflow_count_f > 0 ) begin
      $display("@%0tps [CHP_INFO] SIM COUNTER egress_err_ldb_cq_depth_overflow_count                     :#%08d <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
              , $time
              , egress_err_ldb_cq_depth_overflow_count_f
              );
    end

    if ( hcw_sched_w_req_parity_err_count_f > 0 ) begin
      $display("@%0tps [CHP_INFO] SIM COUNTER hcw_sched_w_req_parity_err_count                           :#%08d <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
              , $time
              , hcw_sched_w_req_parity_err_count_f
              );
    end

    if ( chp_lsp_cmp_data_parity_err_count_f > 0 ) begin
      $display("@%0tps [CHP_INFO] SIM COUNTER chp_lsp_cmp_data_parity_err_count                          :#%08d <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
              , $time
              , chp_lsp_cmp_data_parity_err_count_f
              );
    end

    $display("@%0tps [CHP_INFO] SIM COUNTER hcw_enq_w_req_v_count                                      :#%08d ( ~ready:#%0d )"
            , $time
            , hcw_enq_w_req_v_count_f
            , hcw_enq_w_req_stall_count_f
            );

    $display("@%0tps [CHP_INFO] SIM COUNTER qed_chp_sch_v_count                                        :#%08d ( ~ready:#%0d sched:#%0d replay:#%0d atq2atm:#%0d ignore_cq_depth:#%0d )"
            , $time
            , qed_chp_sch_v_count_f
            , qed_chp_sch_stall_count_f
            , qed_chp_count_f [ 1 ]
            , qed_chp_count_f [ 2 ]
            , qed_chp_count_f [ 3 ]
            , qed_chp_sch_flush_count_f
            );

    $display("@%0tps [CHP_INFO] SIM COUNTER dqed_chp_sch_v_count                                       :#%08d ( ~ready:#%0d sched:#%0d replay:#%0d ignore_cq_depth:#%0d )"
            , $time
            , dqed_chp_sch_v_count_f
            , dqed_chp_sch_stall_count_f
            , dqed_chp_count_f [ 1 ]
            , dqed_chp_count_f [ 2 ]
            , dqed_chp_sch_flush_count_f
            );

    $display("@%0tps [CHP_INFO] SIM COUNTER aqed_chp_sch_v_count                                       :#%08d ( ~ready:#%0d ignore_cq_depth:#%0d )"
            , $time
            , aqed_chp_sch_v_count_f
            , aqed_chp_sch_stall_count_f
            , aqed_chp_sch_flush_count_f
            );

    $display("@%0tps [CHP_INFO] SIM COUNTER chp_rop_hcw_v_count                                        :#%08d ( ~ready:#%0d enq:#%0d enq_comp:#%0d comp:#%0d noop:#%0d replay:#%0d )"
            , $time
            , chp_rop_hcw_v_count_f
            , chp_rop_hcw_stall_count_f
            , chp_rop_hcw_enq_count_f
            , chp_rop_hcw_enq_comp_count_f
            , chp_rop_hcw_comp_count_f
            , chp_rop_hcw_noop_count_f
            , chp_rop_hcw_replay_count_f
            );

    $display("@%0tps [CHP_INFO] SIM COUNTER chp_lsp_token_v_count                                      :#%08d ( ~ready:#%0d count:#%0d dir v:#%0d count:#%0d ldb v:#%0d count:#%0d )"
            , $time
            , chp_lsp_token_v_count_f
            , chp_lsp_token_stall_count_f
            , chp_lsp_token_count_f
            , chp_lsp_token_v_dir_count_f
            , chp_lsp_token_dir_count_f
            , chp_lsp_token_v_ldb_count_f
            , chp_lsp_token_ldb_count_f
            );

    $display("@%0tps [CHP_INFO] SIM COUNTER chp_lsp_cmp_v_count                                        :#%08d ( ~ready:#%0d )"
            , $time
            , chp_lsp_cmp_v_count_f   
            , chp_lsp_cmp_stall_count_f   
            );

    $display("@%0tps [CHP_INFO] SIM COUNTER hcw_sched_w_req_v_count                                    :#%08d ( ~ready:#%0d )"
            , $time
            , hcw_sched_w_req_v_count_f
            , hcw_sched_w_req_stall_count_f
            );

    for ( int i = 0 ; i < 16 ; i++ ) begin
      if ( hcw_enq_w_req_hcw_cmd_count_f [ i ] > 0 ) begin
        hcw_enq_w_req_hcw_cmd = hcw_cmd_dec_t' ( i ) ;
        $display("@%0tps [CHP_INFO] SIM COUNTER hcw_enq_w_req_hcw_cmd_count                                :#%08d ( hcw_cmd:%0d %s )"
                , $time
                , hcw_enq_w_req_hcw_cmd_count_f[i]
                , i
                , hcw_enq_w_req_hcw_cmd.name
                );
      end
    end

    for ( int i = 0 ; i < 64 ; i++ ) begin
      if ( qed_chp_sch_cq_count_f [ i ] > 0 ) begin
        $display("@%0tps [CHP_INFO] SIM COUNTER qed_chp_sch_cq_count                                       :#%08d ( cq %0d )"
                , $time
                , qed_chp_sch_cq_count_f[i]
                , i
                );
      end
    end

    for ( int i = 0 ; i < 96 ; i++ ) begin
      if ( dqed_chp_sch_cq_count_f [ i ] > 0 ) begin
        $display("@%0tps [CHP_INFO] SIM COUNTER dqed_chp_sch_cq_count                                      :#%08d ( cq %0d )"
                , $time
                , dqed_chp_sch_cq_count_f[i]
                , i
                );
      end
    end

    for ( int i = 0 ; i < 64 ; i++ ) begin
      if ( aqed_chp_sch_cq_count_f [ i ] > 0 ) begin
        $display("@%0tps [CHP_INFO] SIM COUNTER aqed_chp_sch_cq_count                                      :#%08d ( cq %0d )"
                , $time
                , aqed_chp_sch_cq_count_f[i]
                , i
                );
      end
    end

    for ( int i = 0 ; i < 64 ; i++ ) begin
      if ( hcw_sched_w_req_ldb_cq_count_f [ i ] > 0 ) begin
        if ( ( chp_lsp_token_ldb_cq_count_f [ i ] == hcw_sched_w_req_ldb_cq_count_f [ i ] ) &
             ( chp_lsp_cmp_ldb_cq_count_f [ i ] == hcw_sched_w_req_ldb_cq_count_f [ i ] ) ) begin
          $display("@%0tps [CHP_INFO] SIM COUNTER hcw_sched_w_req_ldb_cq_count                               :#%08d ( cq %0d ) tok:#%0d cmp:#%0d release:#%0d"
                  , $time
                  , hcw_sched_w_req_ldb_cq_count_f[i]
                  , i
                  , chp_lsp_token_ldb_cq_count_f[i]
                  , chp_lsp_cmp_ldb_cq_count_f[i]
                  , chp_lsp_cmp_release_ldb_cq_count_f[i]
                  );
        end
        else begin
          $display("@%0tps [CHP_INFO] SIM COUNTER hcw_sched_w_req_ldb_cq_count                               :#%08d ( cq %0d ) tok:#%0d cmp:#%0d release:#%0d <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
                  , $time
                  , hcw_sched_w_req_ldb_cq_count_f[i]
                  , i
                  , chp_lsp_token_ldb_cq_count_f[i]
                  , chp_lsp_cmp_ldb_cq_count_f[i]
                  , chp_lsp_cmp_release_ldb_cq_count_f[i]
                  );
        end
      end
    end

    for ( int i = 0 ; i < 96 ; i++ ) begin
      if ( hcw_sched_w_req_dir_cq_count_f [ i ] > 0 ) begin
        if ( chp_lsp_token_dir_cq_count_f [ i ] == hcw_sched_w_req_dir_cq_count_f [ i ] ) begin
          $display("@%0tps [CHP_INFO] SIM COUNTER hcw_sched_w_req_dir_cq_count                               :#%08d ( cq %0d ) tok:#%0d"
                  , $time
                  , hcw_sched_w_req_dir_cq_count_f[i]
                  , i
                  , chp_lsp_token_dir_cq_count_f[i]
                  );
        end
        else begin
          $display("@%0tps [CHP_INFO] SIM COUNTER hcw_sched_w_req_dir_cq_count                               :#%08d ( cq %0d ) tok:#%0d <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
                  , $time
                  , hcw_sched_w_req_dir_cq_count_f[i]
                  , i
                  , chp_lsp_token_dir_cq_count_f[i]
                  );
        end
      end
    end

    freelist_busy_count = 0;

    foreach (freelist_busy_f[i]) begin
      if (freelist_busy_f[i]) begin
        freelist_busy_count++;
      end
    end

    if ( freelist_busy_count > 0 ) begin
      $display("@%0tps [CHP_INFO] freelist_busy_f is not 0 ( %0d active entries ) <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
              , $time
              , freelist_busy_count
              );
    end

    if ( chp_rop_pipe_credit_afull_count_f > 0 ) begin
      $display("@%0tps [CHP_INFO] SIM COUNTER chp_rop_pipe_credit_afull                                  :#%08d"
              , $time
              , chp_rop_pipe_credit_afull_count_f
              );
    end

    if ( chp_lsp_tok_pipe_credit_afull_count_f > 0 ) begin
      $display("@%0tps [CHP_INFO] SIM COUNTER chp_lsp_tok_pipe_credit_afull                              :#%08d"
              , $time
              , chp_lsp_tok_pipe_credit_afull_count_f
              );
    end

    if ( chp_lsp_ap_cmp_pipe_credit_afull_count_f > 0 ) begin
      $display("@%0tps [CHP_INFO] SIM COUNTER chp_lsp_ap_cmp_pipe_credit_afull                           :#%08d"
              , $time
              , chp_lsp_ap_cmp_pipe_credit_afull_count_f
              );
    end

    if ( chp_outbound_hcw_pipe_credit_afull_count_f > 0 ) begin
      $display("@%0tps [CHP_INFO] SIM COUNTER chp_outbound_hcw_pipe_credit_afull                         :#%08d"
              , $time
              , chp_outbound_hcw_pipe_credit_afull_count_f
              );
    end

    if ( hcw_enq_w_req_v_count_f > 0 ) begin
       $display("@%0tps [CHP_INFO]   PERF STAT hcw_enq_w_req_clk_count :#%0d hcw_enq_w_req_v_count :#%0d average rate 1 hcw every %.2f clk"
               , $time
               , hcw_enq_w_req_clk_count_f
               , hcw_enq_w_req_v_count_f
               , ( hcw_enq_w_req_clk_count_f * 1.0 ) / ( hcw_enq_w_req_v_count_f * 1.0 )
               );
    end

    if ( hcw_enq_w_req_enqueue_count_f > 0 ) begin
       $display("@%0tps [CHP_INFO]   PERF STAT hcw_enq_w_req_enqueue_clk_count :#%0d hcw_enq_w_req_enqueue_count :#%0d average rate 1 hcw every %.2f clk"
               , $time
               , hcw_enq_w_req_enqueue_clk_count_f
               , hcw_enq_w_req_enqueue_count_f
               , ( hcw_enq_w_req_enqueue_clk_count_f * 1.0 ) / ( hcw_enq_w_req_enqueue_count_f * 1.0 )
               );
    end

    if ( chp_rop_hcw_v_count_f > 0 ) begin
       $display("@%0tps [CHP_INFO]   PERF STAT chp_rop_hcw_clk_count :#%0d chp_rop_hcw_v_count :#%0d average rate 1 hcw every %.2f clk"
               , $time
               , chp_rop_hcw_clk_count_f
               , chp_rop_hcw_v_count_f
               , ( chp_rop_hcw_clk_count_f * 1.0 ) / ( chp_rop_hcw_v_count_f * 1.0 )
               );
    end

    if ( dqed_chp_sch_v_count_f > 0 ) begin
       $display("@%0tps [CHP_INFO]   PERF STAT dqed_chp_sch_clk_count:#%0d dqed_chp_sch_v_count:#%0d average rate 1 hcw every %.2f clk"
               , $time
               , dqed_chp_sch_clk_count_f
               , dqed_chp_sch_v_count_f
               , ( dqed_chp_sch_clk_count_f * 1.0 ) / ( dqed_chp_sch_v_count_f * 1.0 )
               );
    end

    if ( qed_chp_sch_v_count_f > 0 ) begin
       $display("@%0tps [CHP_INFO]   PERF STAT qed_chp_sch_clk_count :#%0d qed_chp_sch_v_count :#%0d average rate 1 hcw every %.2f clk"
               , $time
               , qed_chp_sch_clk_count_f
               , qed_chp_sch_v_count_f
               , ( qed_chp_sch_clk_count_f * 1.0 ) / ( qed_chp_sch_v_count_f * 1.0 )
               );
    end

    if ( aqed_chp_sch_v_count_f > 0 ) begin
       $display("@%0tps [CHP_INFO]   PERF STAT aqed_chp_sch_clk_count :#%0d aqed_chp_sch_v_count :#%0d average rate 1 hcw every %.2f clk"
               , $time
               , aqed_chp_sch_clk_count_f
               , aqed_chp_sch_v_count_f
               , ( aqed_chp_sch_clk_count_f * 1.0 ) / ( aqed_chp_sch_v_count_f * 1.0 )
               );
    end

    if ( hcw_sched_w_req_v_count_f > 0 ) begin
       $display("@%0tps [CHP_INFO]   PERF STAT hcw_sched_w_req_clk_count :#%0d hcw_sched_w_req_v_count :#%0d average rate 1 hcw every %.2f clk"
               , $time
               , hcw_sched_w_req_clk_count_f
               , hcw_sched_w_req_v_count_f
               , ( hcw_sched_w_req_clk_count_f * 1.0 ) / ( hcw_sched_w_req_v_count_f * 1.0 )
               );
    end

    if ( chp_ingress_flid_ret_rx_sync_stall_count_f > 0 ) begin
      $display("@%0tps [CHP_INFO] SIM COUNTER chp_ingress_flid_ret_rx_sync_stall                         :#%08d <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
              , $time
              , chp_ingress_flid_ret_rx_sync_stall_count_f
              );
    end

  end // final
`endif

task eot_check ( output bit pf );
  pf = 1'b0 ; //pass



//Unit state checks
if ( hqm_credit_hist_pipe_core.hqm_chp_target_cfg_unit_idle_reg_f[0] != 1'b1 ) begin
pf = 1'b1;
$display( "@%0tps [CHP_ERROR] \
,%-30s \
"
,$time
," hqm_credit_hist_pipe_core.hqm_chp_target_cfg_unit_idle_reg_f.pipe_idle is not set "
);
end

if ( hqm_credit_hist_pipe_core.hqm_chp_target_cfg_unit_idle_reg_f[1] != 1'b1 ) begin
pf = 1'b1;
$display( "@%0tps [CHP_ERROR] \
,%-30s \
"
,$time
," hqm_credit_hist_pipe_core.hqm_chp_target_cfg_unit_idle_reg_f.unit_idle is not set "
);
end


//Unit Port checks - captured in MASTER
if ( hqm_credit_hist_pipe_core.chp_alarm_down_v != 1'b0 ) begin
pf = 1'b1;
$display( "@%0tps [CHP_ERROR] \
,%-30s \
"
,$time
," chp_alarm_down_v is not clear "
);
end

if ( hqm_credit_hist_pipe_core.chp_unit_idle != 1'b1 ) begin
pf = 1'b1;
$display( "@%0tps [CHP_ERROR] \
,%-30s \
"
,$time
," hqm_credit_hist_pipe_core.chp_unit_idle is not set "
);
end
if ( hqm_credit_hist_pipe_core.chp_unit_pipeidle != 1'b1 ) begin
pf = 1'b1;
$display( "@%0tps [CHP_ERROR] \
,%-30s \
"
,$time
," hqm_credit_hist_pipe_core.chp_unit_pipeidle is not set "
);
end

if ( hqm_credit_hist_pipe_core.chp_reset_done != 1'b1 ) begin
pf = 1'b1;
$display( "@%0tps [CHP_ERROR] \
,%-30s \
"
,$time
," hqm_credit_hist_pipe_core.chp_reset_done is not set "
);
end


  //-------------------------------------------------------------------------------------------------
  // Unit model EOT checks

  if ( ~ hqm_credit_hist_pipe_core.cfg_unit_idle_reg_f.pipe_idle ) begin 
    pf = 1'b1; 
    $display("@%0tps [CHP_ERROR] EOT cfg_unit_idle_reg_f.pipe_idle is not 0"
            , $time
            ) ;
  end

  if ( ~ hqm_credit_hist_pipe_core.cfg_unit_idle_reg_f.unit_idle ) begin 
    pf = 1'b1; 
    $display("@%0tps [CHP_ERROR] EOT cfg_unit_idle_reg_f.unit_idle is not 0"
            , $time
            ) ;
  end

  if ( ( ~ hqm_credit_hist_pipe_core.hcw_enq_w_req_ready ) & ( hqm_credit_hist_pipe_core.hcw_enq_w_req_valid ) ) begin
    pf = 1'b1;
    $display("@%0tps [CHP_ERROR] EOT hcw_enq_w_req_ready is deasserted while hcw_enq_w_req_valid is 1(interface stalled)"
            , $time
            ) ;
  end

  if ( ( ~ hqm_credit_hist_pipe_core.qed_chp_sch_ready ) & ( hqm_credit_hist_pipe_core.qed_chp_sch_v ) ) begin
    pf = 1'b1;
    $display("@%0tps [CHP_ERROR] EOT qed_chp_sch_ready is deasserted while qed_chp_sch_v is 1(interface stalled)"
            , $time
            ) ;
  end

  if ( ( ~ hqm_credit_hist_pipe_core.aqed_chp_sch_ready ) & ( hqm_credit_hist_pipe_core.aqed_chp_sch_v ) ) begin
    pf = 1'b1;
    $display("@%0tps [CHP_ERROR] EOT aqed_chp_sch_ready is deasserted while aqed_chp_sch_v is 1(interface stalled)"
            , $time
            ) ;
  end

  if ( ( ~ hqm_credit_hist_pipe_core.chp_rop_hcw_ready ) & ( hqm_credit_hist_pipe_core.chp_rop_hcw_v ) ) begin
    pf = 1'b1;
    $display("@%0tps [CHP_ERROR] EOT chp_rop_hcw_ready is deasserted while chp_rop_hcw_v is 1(interface stalled)"
            , $time
            ) ;
  end

  if ( ( ~ hqm_credit_hist_pipe_core.chp_lsp_token_ready ) & ( hqm_credit_hist_pipe_core.chp_lsp_token_v ) ) begin
    pf = 1'b1;
    $display("@%0tps [CHP_ERROR] EOT chp_lsp_token_ready is deasserted while chp_lsp_token_v is 1(interface stalled)"
            , $time
            ) ;
  end

  if ( ( ~ hqm_credit_hist_pipe_core.chp_lsp_cmp_ready ) & ( hqm_credit_hist_pipe_core.chp_lsp_cmp_v ) ) begin
    pf = 1'b1;
    $display("@%0tps [CHP_ERROR] EOT chp_lsp_cmp_ready is deasserted while chp_lsp_cmp_v is 1(interface stalled)"
            , $time
            ) ;
  end

  if ( ( ~ hqm_credit_hist_pipe_core.hcw_sched_w_req_ready ) & ( hqm_credit_hist_pipe_core.hcw_sched_w_req_valid ) ) begin
    pf = 1'b1;
    $display("@%0tps [CHP_ERROR] EOT hcw_sched_w_req_ready is deasserted while hcw_sched_w_req_valid is 1(interface stalled)"
            , $time
            ) ;
  end

  if ( $test$plusargs("HQM_CHP_FLID_PARITY_ERROR_INJECTION_TEST") ) begin
  end
  else begin
    if ( ~ hqm_credit_hist_pipe_core.freelist_full ) begin
      pf = 1'b1;
      $display("@%0tps [CHP_ERROR] EOT freelist_full is deasserted"
              , $time
              ) ;
    end
  end

endtask : eot_check

hqm_AW_parity_check #(
   .WIDTH                                                       ( $bits ( hqm_credit_hist_pipe_core.hcw_sched_w_req.user.hqm_core_flags ) + 
                                                                  $bits ( hqm_credit_hist_pipe_core.hcw_sched_w_req.user.cq) + 
                                                                  $bits ( hqm_credit_hist_pipe_core.hcw_sched_w_req.user.cq_wptr) - 1 )
) i_AW_parity_check_hcw_sched_w_req (
   .p                                                           ( hqm_credit_hist_pipe_core.hcw_sched_w_req.user.hqm_core_flags.parity )
 , .d                                                           ( { hqm_credit_hist_pipe_core.hcw_sched_w_req.user.hqm_core_flags [ 6 : 0 ] 
                                                                  , hqm_credit_hist_pipe_core.hcw_sched_w_req.user.cq
                                                                  , hqm_credit_hist_pipe_core.hcw_sched_w_req.user.cq_wptr
                                                                  } )
 , .e                                                           ( hqm_credit_hist_pipe_core.hcw_sched_w_req_valid )
 , .odd                                                         ( 1'b1 )
 , .err                                                         ( hcw_sched_w_req_parity_err )
) ;

hqm_AW_parity_check #(
   .WIDTH                                                       ( $bits ( hqm_credit_hist_pipe_core.chp_lsp_cmp_data.qe_wt ) + 
                                                                  $bits ( hqm_credit_hist_pipe_core.chp_lsp_cmp_data.pp ) + 
                                                                  $bits ( hqm_credit_hist_pipe_core.chp_lsp_cmp_data.qid) ) 
) i_AW_parity_check_chp_lsp_cmp_data (
   .p                                                           ( hqm_credit_hist_pipe_core.chp_lsp_cmp_data.parity )
 , .d                                                           ( { hqm_credit_hist_pipe_core.chp_lsp_cmp_data.qe_wt
                                                                  , hqm_credit_hist_pipe_core.chp_lsp_cmp_data.pp 
                                                                  , hqm_credit_hist_pipe_core.chp_lsp_cmp_data.qid
                                                                  } )
 , .e                                                           ( hqm_credit_hist_pipe_core.chp_lsp_cmp_v )
 , .odd                                                         ( 1'b1 )
 , .err                                                         ( chp_lsp_cmp_data_parity_err )
) ;

endmodule

bind hqm_credit_hist_pipe_core hqm_credit_hist_pipe_inst i_hqm_credit_hist_pipe_inst();

`endif
