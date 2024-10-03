module hqm_lsp_pipe_register_pfcsr
import hqm_AW_pkg::* , hqm_pkg::* , hqm_core_pkg::* ;
(
  input logic hqm_gated_clk
, input logic hqm_gated_rst_n
, input logic rst_prep 
, input logic [ ( HQM_LSP_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] cfg_req_write 
, input logic [ ( HQM_LSP_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] cfg_req_read 
, input cfg_req_t cfg_req 
, output logic cfg_rsp_ack 
, output logic cfg_rsp_err 
, output logic [ ( 32 ) - 1 : 0 ] cfg_rsp_rdata 
, input  logic [ ( HQM_NUM_DIR_CQ ) - 1 : 0 ] pfcsr_shadow_nxt
, output logic [ ( HQM_NUM_DIR_CQ ) - 1 : 0 ] pfcsr_shadow_f
, input logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_aqed_tot_enqueue_count_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_aqed_tot_enqueue_count_reg_f
, input logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_aqed_tot_enqueue_limit_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_aqed_tot_enqueue_limit_reg_f
, input logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_arb_weight_atm_nalb_qid_0_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_arb_weight_atm_nalb_qid_0_reg_f
, input logic hqm_lsp_target_cfg_arb_weight_atm_nalb_qid_0_reg_v
, input logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_arb_weight_atm_nalb_qid_1_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_arb_weight_atm_nalb_qid_1_reg_f
, input logic hqm_lsp_target_cfg_arb_weight_atm_nalb_qid_1_reg_v
, input logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_arb_weight_ldb_issue_0_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_arb_weight_ldb_issue_0_reg_f
, input logic hqm_lsp_target_cfg_arb_weight_ldb_issue_0_reg_v
, input logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_arb_weight_ldb_qid_0_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_arb_weight_ldb_qid_0_reg_f
, input logic hqm_lsp_target_cfg_arb_weight_ldb_qid_0_reg_v
, input logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_arb_weight_ldb_qid_1_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_arb_weight_ldb_qid_1_reg_f
, input logic hqm_lsp_target_cfg_arb_weight_ldb_qid_1_reg_v
, input logic hqm_lsp_target_cfg_cnt_win_cos0_en
, input logic hqm_lsp_target_cfg_cnt_win_cos0_clr
, input logic hqm_lsp_target_cfg_cnt_win_cos0_clrv
, input logic hqm_lsp_target_cfg_cnt_win_cos0_inc
, output logic [ ( 64 ) - 1 : 0] hqm_lsp_target_cfg_cnt_win_cos0_count
, input logic hqm_lsp_target_cfg_cnt_win_cos1_en
, input logic hqm_lsp_target_cfg_cnt_win_cos1_clr
, input logic hqm_lsp_target_cfg_cnt_win_cos1_clrv
, input logic hqm_lsp_target_cfg_cnt_win_cos1_inc
, output logic [ ( 64 ) - 1 : 0] hqm_lsp_target_cfg_cnt_win_cos1_count
, input logic hqm_lsp_target_cfg_cnt_win_cos2_en
, input logic hqm_lsp_target_cfg_cnt_win_cos2_clr
, input logic hqm_lsp_target_cfg_cnt_win_cos2_clrv
, input logic hqm_lsp_target_cfg_cnt_win_cos2_inc
, output logic [ ( 64 ) - 1 : 0] hqm_lsp_target_cfg_cnt_win_cos2_count
, input logic hqm_lsp_target_cfg_cnt_win_cos3_en
, input logic hqm_lsp_target_cfg_cnt_win_cos3_clr
, input logic hqm_lsp_target_cfg_cnt_win_cos3_clrv
, input logic hqm_lsp_target_cfg_cnt_win_cos3_inc
, output logic [ ( 64 ) - 1 : 0] hqm_lsp_target_cfg_cnt_win_cos3_count
, input logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_control_general_0_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_control_general_0_reg_f
, input logic hqm_lsp_target_cfg_control_general_0_reg_v
, input logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_control_general_1_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_control_general_1_reg_f
, input logic hqm_lsp_target_cfg_control_general_1_reg_v
, input logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_control_pipeline_credits_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_control_pipeline_credits_reg_f
, input logic hqm_lsp_target_cfg_control_pipeline_credits_reg_v
, input logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_control_sched_slot_count_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_control_sched_slot_count_reg_f
, input logic hqm_lsp_target_cfg_control_sched_slot_count_reg_v
, input logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_cos_ctrl_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_cos_ctrl_reg_f
, input logic hqm_lsp_target_cfg_cos_ctrl_reg_v
, input logic hqm_lsp_target_cfg_cq_dir_disable_reg_load
, input logic [ ( 1 * 1 * 64 ) - 1 : 0] hqm_lsp_target_cfg_cq_dir_disable_reg_nxt
, output logic [ ( 1 * 1 * 64 ) - 1 : 0] hqm_lsp_target_cfg_cq_dir_disable_reg_f
, input logic hqm_lsp_target_cfg_cq_ldb_disable_reg_load
, input logic [ ( 1 * 2 * 64 ) - 1 : 0] hqm_lsp_target_cfg_cq_ldb_disable_reg_nxt
, output logic [ ( 1 * 2 * 64 ) - 1 : 0] hqm_lsp_target_cfg_cq_ldb_disable_reg_f
, input logic hqm_lsp_target_cfg_cq_ldb_sched_slot_count_0_en
, input logic hqm_lsp_target_cfg_cq_ldb_sched_slot_count_0_clr
, input logic hqm_lsp_target_cfg_cq_ldb_sched_slot_count_0_clrv
, input logic hqm_lsp_target_cfg_cq_ldb_sched_slot_count_0_inc
, output logic [ ( 64 ) - 1 : 0] hqm_lsp_target_cfg_cq_ldb_sched_slot_count_0_count
, input logic hqm_lsp_target_cfg_cq_ldb_sched_slot_count_1_en
, input logic hqm_lsp_target_cfg_cq_ldb_sched_slot_count_1_clr
, input logic hqm_lsp_target_cfg_cq_ldb_sched_slot_count_1_clrv
, input logic hqm_lsp_target_cfg_cq_ldb_sched_slot_count_1_inc
, output logic [ ( 64 ) - 1 : 0] hqm_lsp_target_cfg_cq_ldb_sched_slot_count_1_count
, input logic hqm_lsp_target_cfg_cq_ldb_sched_slot_count_2_en
, input logic hqm_lsp_target_cfg_cq_ldb_sched_slot_count_2_clr
, input logic hqm_lsp_target_cfg_cq_ldb_sched_slot_count_2_clrv
, input logic hqm_lsp_target_cfg_cq_ldb_sched_slot_count_2_inc
, output logic [ ( 64 ) - 1 : 0] hqm_lsp_target_cfg_cq_ldb_sched_slot_count_2_count
, input logic hqm_lsp_target_cfg_cq_ldb_sched_slot_count_3_en
, input logic hqm_lsp_target_cfg_cq_ldb_sched_slot_count_3_clr
, input logic hqm_lsp_target_cfg_cq_ldb_sched_slot_count_3_clrv
, input logic hqm_lsp_target_cfg_cq_ldb_sched_slot_count_3_inc
, output logic [ ( 64 ) - 1 : 0] hqm_lsp_target_cfg_cq_ldb_sched_slot_count_3_count
, input logic hqm_lsp_target_cfg_cq_ldb_sched_slot_count_4_en
, input logic hqm_lsp_target_cfg_cq_ldb_sched_slot_count_4_clr
, input logic hqm_lsp_target_cfg_cq_ldb_sched_slot_count_4_clrv
, input logic hqm_lsp_target_cfg_cq_ldb_sched_slot_count_4_inc
, output logic [ ( 64 ) - 1 : 0] hqm_lsp_target_cfg_cq_ldb_sched_slot_count_4_count
, input logic hqm_lsp_target_cfg_cq_ldb_sched_slot_count_5_en
, input logic hqm_lsp_target_cfg_cq_ldb_sched_slot_count_5_clr
, input logic hqm_lsp_target_cfg_cq_ldb_sched_slot_count_5_clrv
, input logic hqm_lsp_target_cfg_cq_ldb_sched_slot_count_5_inc
, output logic [ ( 64 ) - 1 : 0] hqm_lsp_target_cfg_cq_ldb_sched_slot_count_5_count
, input logic hqm_lsp_target_cfg_cq_ldb_sched_slot_count_6_en
, input logic hqm_lsp_target_cfg_cq_ldb_sched_slot_count_6_clr
, input logic hqm_lsp_target_cfg_cq_ldb_sched_slot_count_6_clrv
, input logic hqm_lsp_target_cfg_cq_ldb_sched_slot_count_6_inc
, output logic [ ( 64 ) - 1 : 0] hqm_lsp_target_cfg_cq_ldb_sched_slot_count_6_count
, input logic hqm_lsp_target_cfg_cq_ldb_sched_slot_count_7_en
, input logic hqm_lsp_target_cfg_cq_ldb_sched_slot_count_7_clr
, input logic hqm_lsp_target_cfg_cq_ldb_sched_slot_count_7_clrv
, input logic hqm_lsp_target_cfg_cq_ldb_sched_slot_count_7_inc
, output logic [ ( 64 ) - 1 : 0] hqm_lsp_target_cfg_cq_ldb_sched_slot_count_7_count
, input logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_cq_ldb_tot_inflight_count_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_cq_ldb_tot_inflight_count_reg_f
, input logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_cq_ldb_tot_inflight_limit_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_cq_ldb_tot_inflight_limit_reg_f
, input logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_credit_cnt_cos0_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_credit_cnt_cos0_reg_f
, input logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_credit_cnt_cos1_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_credit_cnt_cos1_reg_f
, input logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_credit_cnt_cos2_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_credit_cnt_cos2_reg_f
, input logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_credit_cnt_cos3_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_credit_cnt_cos3_reg_f
, input logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_credit_sat_cos0_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_credit_sat_cos0_reg_f
, input logic hqm_lsp_target_cfg_credit_sat_cos0_reg_v
, input logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_credit_sat_cos1_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_credit_sat_cos1_reg_f
, input logic hqm_lsp_target_cfg_credit_sat_cos1_reg_v
, input logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_credit_sat_cos2_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_credit_sat_cos2_reg_f
, input logic hqm_lsp_target_cfg_credit_sat_cos2_reg_v
, input logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_credit_sat_cos3_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_credit_sat_cos3_reg_f
, input logic hqm_lsp_target_cfg_credit_sat_cos3_reg_v
, input logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_diagnostic_aw_status_status
, input logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_diagnostic_status_0_status
, input logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_error_inject_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_error_inject_reg_f
, input logic hqm_lsp_target_cfg_error_inject_reg_v
, input logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_fid_inflight_count_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_fid_inflight_count_reg_f
, input logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_fid_inflight_limit_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_fid_inflight_limit_reg_f
, input logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_hw_agitate_control_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_hw_agitate_control_reg_f
, input logic hqm_lsp_target_cfg_hw_agitate_control_reg_v
, input logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_hw_agitate_select_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_hw_agitate_select_reg_f
, input logic hqm_lsp_target_cfg_hw_agitate_select_reg_v
, input logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_interface_status_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_interface_status_reg_f
, input logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_ldb_sched_control_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_ldb_sched_control_reg_f
, input logic hqm_lsp_target_cfg_ldb_sched_perf_0_en
, input logic hqm_lsp_target_cfg_ldb_sched_perf_0_clr
, input logic hqm_lsp_target_cfg_ldb_sched_perf_0_clrv
, input logic hqm_lsp_target_cfg_ldb_sched_perf_0_inc
, output logic [ ( 64 ) - 1 : 0] hqm_lsp_target_cfg_ldb_sched_perf_0_count
, input logic hqm_lsp_target_cfg_ldb_sched_perf_1_en
, input logic hqm_lsp_target_cfg_ldb_sched_perf_1_clr
, input logic hqm_lsp_target_cfg_ldb_sched_perf_1_clrv
, input logic hqm_lsp_target_cfg_ldb_sched_perf_1_inc
, output logic [ ( 64 ) - 1 : 0] hqm_lsp_target_cfg_ldb_sched_perf_1_count
, input logic hqm_lsp_target_cfg_ldb_sched_perf_2_en
, input logic hqm_lsp_target_cfg_ldb_sched_perf_2_clr
, input logic hqm_lsp_target_cfg_ldb_sched_perf_2_clrv
, input logic hqm_lsp_target_cfg_ldb_sched_perf_2_inc
, output logic [ ( 64 ) - 1 : 0] hqm_lsp_target_cfg_ldb_sched_perf_2_count
, input logic hqm_lsp_target_cfg_ldb_sched_perf_3_en
, input logic hqm_lsp_target_cfg_ldb_sched_perf_3_clr
, input logic hqm_lsp_target_cfg_ldb_sched_perf_3_clrv
, input logic hqm_lsp_target_cfg_ldb_sched_perf_3_inc
, output logic [ ( 64 ) - 1 : 0] hqm_lsp_target_cfg_ldb_sched_perf_3_count
, input logic hqm_lsp_target_cfg_ldb_sched_perf_4_en
, input logic hqm_lsp_target_cfg_ldb_sched_perf_4_clr
, input logic hqm_lsp_target_cfg_ldb_sched_perf_4_clrv
, input logic hqm_lsp_target_cfg_ldb_sched_perf_4_inc
, output logic [ ( 64 ) - 1 : 0] hqm_lsp_target_cfg_ldb_sched_perf_4_count
, input logic hqm_lsp_target_cfg_ldb_sched_perf_5_en
, input logic hqm_lsp_target_cfg_ldb_sched_perf_5_clr
, input logic hqm_lsp_target_cfg_ldb_sched_perf_5_clrv
, input logic hqm_lsp_target_cfg_ldb_sched_perf_5_inc
, output logic [ ( 64 ) - 1 : 0] hqm_lsp_target_cfg_ldb_sched_perf_5_count
, input logic hqm_lsp_target_cfg_ldb_sched_perf_6_en
, input logic hqm_lsp_target_cfg_ldb_sched_perf_6_clr
, input logic hqm_lsp_target_cfg_ldb_sched_perf_6_clrv
, input logic hqm_lsp_target_cfg_ldb_sched_perf_6_inc
, output logic [ ( 64 ) - 1 : 0] hqm_lsp_target_cfg_ldb_sched_perf_6_count
, input logic hqm_lsp_target_cfg_ldb_sched_perf_7_en
, input logic hqm_lsp_target_cfg_ldb_sched_perf_7_clr
, input logic hqm_lsp_target_cfg_ldb_sched_perf_7_clrv
, input logic hqm_lsp_target_cfg_ldb_sched_perf_7_inc
, output logic [ ( 64 ) - 1 : 0] hqm_lsp_target_cfg_ldb_sched_perf_7_count
, input logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_ldb_sched_perf_control_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_ldb_sched_perf_control_reg_f
, input logic hqm_lsp_target_cfg_ldb_sched_perf_control_reg_v
, input logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_lsp_csr_control_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_lsp_csr_control_reg_f
, input logic hqm_lsp_target_cfg_lsp_csr_control_reg_v
, input logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_lsp_perf_dir_sch_count_h_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_lsp_perf_dir_sch_count_h_reg_f
, input logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_lsp_perf_dir_sch_count_l_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_lsp_perf_dir_sch_count_l_reg_f
, input logic hqm_lsp_target_cfg_lsp_perf_ldb_sch_count_en
, input logic hqm_lsp_target_cfg_lsp_perf_ldb_sch_count_clr
, input logic hqm_lsp_target_cfg_lsp_perf_ldb_sch_count_clrv
, input logic hqm_lsp_target_cfg_lsp_perf_ldb_sch_count_inc
, output logic [ ( 64 ) - 1 : 0] hqm_lsp_target_cfg_lsp_perf_ldb_sch_count_count
, input logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_patch_control_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_patch_control_reg_f
, input logic hqm_lsp_target_cfg_patch_control_reg_v
, input logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_pipe_health_hold_00_status
, input logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_pipe_health_hold_01_status
, input logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_pipe_health_valid_00_status
, input logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_pipe_health_valid_01_status
, input logic hqm_lsp_target_cfg_rdy_cos0_en
, input logic hqm_lsp_target_cfg_rdy_cos0_clr
, input logic hqm_lsp_target_cfg_rdy_cos0_clrv
, input logic hqm_lsp_target_cfg_rdy_cos0_inc
, output logic [ ( 64 ) - 1 : 0] hqm_lsp_target_cfg_rdy_cos0_count
, input logic hqm_lsp_target_cfg_rdy_cos1_en
, input logic hqm_lsp_target_cfg_rdy_cos1_clr
, input logic hqm_lsp_target_cfg_rdy_cos1_clrv
, input logic hqm_lsp_target_cfg_rdy_cos1_inc
, output logic [ ( 64 ) - 1 : 0] hqm_lsp_target_cfg_rdy_cos1_count
, input logic hqm_lsp_target_cfg_rdy_cos2_en
, input logic hqm_lsp_target_cfg_rdy_cos2_clr
, input logic hqm_lsp_target_cfg_rdy_cos2_clrv
, input logic hqm_lsp_target_cfg_rdy_cos2_inc
, output logic [ ( 64 ) - 1 : 0] hqm_lsp_target_cfg_rdy_cos2_count
, input logic hqm_lsp_target_cfg_rdy_cos3_en
, input logic hqm_lsp_target_cfg_rdy_cos3_clr
, input logic hqm_lsp_target_cfg_rdy_cos3_clrv
, input logic hqm_lsp_target_cfg_rdy_cos3_inc
, output logic [ ( 64 ) - 1 : 0] hqm_lsp_target_cfg_rdy_cos3_count
, input logic hqm_lsp_target_cfg_rnd_loss_cos0_en
, input logic hqm_lsp_target_cfg_rnd_loss_cos0_clr
, input logic hqm_lsp_target_cfg_rnd_loss_cos0_clrv
, input logic hqm_lsp_target_cfg_rnd_loss_cos0_inc
, output logic [ ( 64 ) - 1 : 0] hqm_lsp_target_cfg_rnd_loss_cos0_count
, input logic hqm_lsp_target_cfg_rnd_loss_cos1_en
, input logic hqm_lsp_target_cfg_rnd_loss_cos1_clr
, input logic hqm_lsp_target_cfg_rnd_loss_cos1_clrv
, input logic hqm_lsp_target_cfg_rnd_loss_cos1_inc
, output logic [ ( 64 ) - 1 : 0] hqm_lsp_target_cfg_rnd_loss_cos1_count
, input logic hqm_lsp_target_cfg_rnd_loss_cos2_en
, input logic hqm_lsp_target_cfg_rnd_loss_cos2_clr
, input logic hqm_lsp_target_cfg_rnd_loss_cos2_clrv
, input logic hqm_lsp_target_cfg_rnd_loss_cos2_inc
, output logic [ ( 64 ) - 1 : 0] hqm_lsp_target_cfg_rnd_loss_cos2_count
, input logic hqm_lsp_target_cfg_rnd_loss_cos3_en
, input logic hqm_lsp_target_cfg_rnd_loss_cos3_clr
, input logic hqm_lsp_target_cfg_rnd_loss_cos3_clrv
, input logic hqm_lsp_target_cfg_rnd_loss_cos3_inc
, output logic [ ( 64 ) - 1 : 0] hqm_lsp_target_cfg_rnd_loss_cos3_count
, input logic hqm_lsp_target_cfg_schd_cos0_en
, input logic hqm_lsp_target_cfg_schd_cos0_clr
, input logic hqm_lsp_target_cfg_schd_cos0_clrv
, input logic hqm_lsp_target_cfg_schd_cos0_inc
, output logic [ ( 64 ) - 1 : 0] hqm_lsp_target_cfg_schd_cos0_count
, input logic hqm_lsp_target_cfg_schd_cos1_en
, input logic hqm_lsp_target_cfg_schd_cos1_clr
, input logic hqm_lsp_target_cfg_schd_cos1_clrv
, input logic hqm_lsp_target_cfg_schd_cos1_inc
, output logic [ ( 64 ) - 1 : 0] hqm_lsp_target_cfg_schd_cos1_count
, input logic hqm_lsp_target_cfg_schd_cos2_en
, input logic hqm_lsp_target_cfg_schd_cos2_clr
, input logic hqm_lsp_target_cfg_schd_cos2_clrv
, input logic hqm_lsp_target_cfg_schd_cos2_inc
, output logic [ ( 64 ) - 1 : 0] hqm_lsp_target_cfg_schd_cos2_count
, input logic hqm_lsp_target_cfg_schd_cos3_en
, input logic hqm_lsp_target_cfg_schd_cos3_clr
, input logic hqm_lsp_target_cfg_schd_cos3_clrv
, input logic hqm_lsp_target_cfg_schd_cos3_inc
, output logic [ ( 64 ) - 1 : 0] hqm_lsp_target_cfg_schd_cos3_count
, input logic hqm_lsp_target_cfg_sch_rdy_en
, input logic hqm_lsp_target_cfg_sch_rdy_clr
, input logic hqm_lsp_target_cfg_sch_rdy_clrv
, input logic hqm_lsp_target_cfg_sch_rdy_inc
, output logic [ ( 64 ) - 1 : 0] hqm_lsp_target_cfg_sch_rdy_count
, input logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_shdw_ctrl_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_shdw_ctrl_reg_f
, input logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_shdw_range_cos0_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_shdw_range_cos0_reg_f
, input logic hqm_lsp_target_cfg_shdw_range_cos0_reg_v
, input logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_shdw_range_cos1_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_shdw_range_cos1_reg_f
, input logic hqm_lsp_target_cfg_shdw_range_cos1_reg_v
, input logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_shdw_range_cos2_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_shdw_range_cos2_reg_f
, input logic hqm_lsp_target_cfg_shdw_range_cos2_reg_v
, input logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_shdw_range_cos3_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_shdw_range_cos3_reg_f
, input logic hqm_lsp_target_cfg_shdw_range_cos3_reg_v
, input logic hqm_lsp_target_cfg_smon0_disable_smon
, input logic [ 24 - 1 : 0 ] hqm_lsp_target_cfg_smon0_smon_v
, input logic [ ( 24 * 32 ) - 1 : 0 ] hqm_lsp_target_cfg_smon0_smon_comp
, input logic [ ( 24 * 32 ) - 1 : 0 ] hqm_lsp_target_cfg_smon0_smon_val
, output logic hqm_lsp_target_cfg_smon0_smon_enabled
, output logic hqm_lsp_target_cfg_smon0_smon_interrupt
, input logic hqm_lsp_target_cfg_syndrome_hw_capture_v
, input logic [ ( 31 ) - 1 : 0] hqm_lsp_target_cfg_syndrome_hw_capture_data
, output logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_syndrome_hw_syndrome_data
, input logic hqm_lsp_target_cfg_syndrome_sw_capture_v
, input logic [ ( 31 ) - 1 : 0] hqm_lsp_target_cfg_syndrome_sw_capture_data
, output logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_syndrome_sw_syndrome_data
, input logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_unit_idle_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_unit_idle_reg_f
, input logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_unit_timeout_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_unit_timeout_reg_f
, input logic [ ( 32 ) - 1 : 0] hqm_lsp_target_cfg_unit_version_status
);

logic [ ( HQM_NUM_DIR_CQ ) - 1 : 0 ] pfcsr_shadow_reg_f ;
always_ff @ ( posedge hqm_gated_clk or negedge hqm_gated_rst_n ) begin
  if ( ~ hqm_gated_rst_n ) begin
    pfcsr_shadow_reg_f <= '0 ;
  end else begin
    pfcsr_shadow_reg_f <= pfcsr_shadow_nxt ;
  end
end
assign pfcsr_shadow_f = pfcsr_shadow_reg_f ;

logic [ ( HQM_LSP_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] mux_cfg_req_write ;
logic [ ( HQM_LSP_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] mux_cfg_req_read ;
cfg_req_t mux_cfg_req ;
logic [ ( HQM_LSP_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] mux_cfg_rsp_ack_pnc ;
logic [ ( HQM_LSP_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] mux_cfg_rsp_err_pnc ;
logic [ ( HQM_LSP_CFG_UNIT_NUM_TGTS * 32 ) - 1 : 0 ] mux_cfg_rsp_rdata_pnc ;
always_comb begin
  mux_cfg_req_write = cfg_req_write ;
  mux_cfg_req_read = cfg_req_read ;
  mux_cfg_req = cfg_req ;
end
hqm_AW_cfg_rsp #(
    .NUM_TGTS ( 128 )
) i_hqm_AW_cfg_rsp_0 (
    .clk ( hqm_gated_clk )
  , .rst_n ( hqm_gated_rst_n )
  , .in_cfg_rsp_ack ( {
                        mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_AQED_TOT_ENQUEUE_COUNT ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_AQED_TOT_ENQUEUE_LIMIT ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_ARB_WEIGHT_ATM_NALB_QID_0 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_ARB_WEIGHT_ATM_NALB_QID_1 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_ARB_WEIGHT_LDB_ISSUE_0 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_ARB_WEIGHT_LDB_QID_0 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_ARB_WEIGHT_LDB_QID_1 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CNT_WIN_COS0_H ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CNT_WIN_COS0_L ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CNT_WIN_COS1_H ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CNT_WIN_COS1_L ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CNT_WIN_COS2_H ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CNT_WIN_COS2_L ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CNT_WIN_COS3_H ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CNT_WIN_COS3_L ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CONTROL_GENERAL_0 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CONTROL_GENERAL_1 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CONTROL_PIPELINE_CREDITS ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CONTROL_SCHED_SLOT_COUNT ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_COS_CTRL ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CQ_DIR_DISABLE ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_DISABLE ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_0_H ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_0_L ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_1_H ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_1_L ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_2_H ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_2_L ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_3_H ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_3_L ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_4_H ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_4_L ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_5_H ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_5_L ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_6_H ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_6_L ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_7_H ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_7_L ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_TOT_INFLIGHT_COUNT ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_TOT_INFLIGHT_LIMIT ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CREDIT_CNT_COS0 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CREDIT_CNT_COS1 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CREDIT_CNT_COS2 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CREDIT_CNT_COS3 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CREDIT_SAT_COS0 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CREDIT_SAT_COS1 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CREDIT_SAT_COS2 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CREDIT_SAT_COS3 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_DIAGNOSTIC_AW_STATUS ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_DIAGNOSTIC_STATUS_0 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_ERROR_INJECT ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_FID_INFLIGHT_COUNT ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_FID_INFLIGHT_LIMIT ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_HW_AGITATE_CONTROL ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_HW_AGITATE_SELECT ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_INTERFACE_STATUS ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_CONTROL ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_0_H ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_0_L ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_1_H ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_1_L ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_2_H ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_2_L ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_3_H ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_3_L ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_4_H ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_4_L ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_5_H ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_5_L ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_6_H ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_6_L ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_7_H ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_7_L ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_CONTROL ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_LSP_CSR_CONTROL ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_LSP_PERF_DIR_SCH_COUNT_H ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_LSP_PERF_DIR_SCH_COUNT_L ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_LSP_PERF_LDB_SCH_COUNT_H ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_LSP_PERF_LDB_SCH_COUNT_L ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_PATCH_CONTROL ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_PIPE_HEALTH_HOLD_00 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_PIPE_HEALTH_HOLD_01 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_PIPE_HEALTH_VALID_00 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_PIPE_HEALTH_VALID_01 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_RDY_COS0_H ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_RDY_COS0_L ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_RDY_COS1_H ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_RDY_COS1_L ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_RDY_COS2_H ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_RDY_COS2_L ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_RDY_COS3_H ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_RDY_COS3_L ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_RND_LOSS_COS0_H ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_RND_LOSS_COS0_L ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_RND_LOSS_COS1_H ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_RND_LOSS_COS1_L ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_RND_LOSS_COS2_H ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_RND_LOSS_COS2_L ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_RND_LOSS_COS3_H ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_RND_LOSS_COS3_L ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_SCHD_COS0_H ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_SCHD_COS0_L ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_SCHD_COS1_H ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_SCHD_COS1_L ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_SCHD_COS2_H ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_SCHD_COS2_L ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_SCHD_COS3_H ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_SCHD_COS3_L ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_SCH_RDY_H ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_SCH_RDY_L ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_SHDW_CTRL ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_SHDW_RANGE_COS0 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_SHDW_RANGE_COS1 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_SHDW_RANGE_COS2 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_SHDW_RANGE_COS3 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_SMON0_ACTIVITYCOUNTER0 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_SMON0_ACTIVITYCOUNTER1 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_SMON0_COMPARE0 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_SMON0_COMPARE1 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_SMON0_CONFIGURATION0 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_SMON0_CONFIGURATION1 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_SMON0_MAXIMUM_TIMER ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_SMON0_TIMER ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_SYNDROME_HW ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_SYNDROME_SW ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_UNIT_IDLE ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_UNIT_TIMEOUT ]
                      , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_UNIT_VERSION ]
                      } )
  , .in_cfg_rsp_err ( {
                        mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_AQED_TOT_ENQUEUE_COUNT ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_AQED_TOT_ENQUEUE_LIMIT ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_ARB_WEIGHT_ATM_NALB_QID_0 ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_ARB_WEIGHT_ATM_NALB_QID_1 ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_ARB_WEIGHT_LDB_ISSUE_0 ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_ARB_WEIGHT_LDB_QID_0 ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_ARB_WEIGHT_LDB_QID_1 ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CNT_WIN_COS0_H ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CNT_WIN_COS0_L ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CNT_WIN_COS1_H ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CNT_WIN_COS1_L ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CNT_WIN_COS2_H ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CNT_WIN_COS2_L ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CNT_WIN_COS3_H ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CNT_WIN_COS3_L ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CONTROL_GENERAL_0 ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CONTROL_GENERAL_1 ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CONTROL_PIPELINE_CREDITS ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CONTROL_SCHED_SLOT_COUNT ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_COS_CTRL ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CQ_DIR_DISABLE ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_DISABLE ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_0_H ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_0_L ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_1_H ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_1_L ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_2_H ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_2_L ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_3_H ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_3_L ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_4_H ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_4_L ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_5_H ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_5_L ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_6_H ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_6_L ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_7_H ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_7_L ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_TOT_INFLIGHT_COUNT ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_TOT_INFLIGHT_LIMIT ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CREDIT_CNT_COS0 ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CREDIT_CNT_COS1 ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CREDIT_CNT_COS2 ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CREDIT_CNT_COS3 ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CREDIT_SAT_COS0 ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CREDIT_SAT_COS1 ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CREDIT_SAT_COS2 ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CREDIT_SAT_COS3 ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_DIAGNOSTIC_AW_STATUS ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_DIAGNOSTIC_STATUS_0 ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_ERROR_INJECT ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_FID_INFLIGHT_COUNT ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_FID_INFLIGHT_LIMIT ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_HW_AGITATE_CONTROL ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_HW_AGITATE_SELECT ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_INTERFACE_STATUS ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_CONTROL ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_0_H ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_0_L ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_1_H ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_1_L ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_2_H ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_2_L ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_3_H ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_3_L ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_4_H ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_4_L ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_5_H ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_5_L ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_6_H ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_6_L ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_7_H ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_7_L ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_CONTROL ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_LSP_CSR_CONTROL ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_LSP_PERF_DIR_SCH_COUNT_H ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_LSP_PERF_DIR_SCH_COUNT_L ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_LSP_PERF_LDB_SCH_COUNT_H ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_LSP_PERF_LDB_SCH_COUNT_L ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_PATCH_CONTROL ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_PIPE_HEALTH_HOLD_00 ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_PIPE_HEALTH_HOLD_01 ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_PIPE_HEALTH_VALID_00 ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_PIPE_HEALTH_VALID_01 ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_RDY_COS0_H ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_RDY_COS0_L ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_RDY_COS1_H ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_RDY_COS1_L ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_RDY_COS2_H ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_RDY_COS2_L ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_RDY_COS3_H ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_RDY_COS3_L ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_RND_LOSS_COS0_H ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_RND_LOSS_COS0_L ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_RND_LOSS_COS1_H ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_RND_LOSS_COS1_L ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_RND_LOSS_COS2_H ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_RND_LOSS_COS2_L ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_RND_LOSS_COS3_H ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_RND_LOSS_COS3_L ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_SCHD_COS0_H ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_SCHD_COS0_L ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_SCHD_COS1_H ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_SCHD_COS1_L ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_SCHD_COS2_H ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_SCHD_COS2_L ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_SCHD_COS3_H ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_SCHD_COS3_L ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_SCH_RDY_H ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_SCH_RDY_L ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_SHDW_CTRL ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_SHDW_RANGE_COS0 ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_SHDW_RANGE_COS1 ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_SHDW_RANGE_COS2 ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_SHDW_RANGE_COS3 ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_SMON0_ACTIVITYCOUNTER0 ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_SMON0_ACTIVITYCOUNTER1 ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_SMON0_COMPARE0 ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_SMON0_COMPARE1 ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_SMON0_CONFIGURATION0 ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_SMON0_CONFIGURATION1 ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_SMON0_MAXIMUM_TIMER ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_SMON0_TIMER ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_SYNDROME_HW ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_SYNDROME_SW ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_UNIT_IDLE ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_UNIT_TIMEOUT ]
                      , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_UNIT_VERSION ]
                      } )
  , .in_cfg_rsp_rdata ( {
                        mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_AQED_TOT_ENQUEUE_COUNT * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_AQED_TOT_ENQUEUE_LIMIT * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_ARB_WEIGHT_ATM_NALB_QID_0 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_ARB_WEIGHT_ATM_NALB_QID_1 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_ARB_WEIGHT_LDB_ISSUE_0 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_ARB_WEIGHT_LDB_QID_0 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_ARB_WEIGHT_LDB_QID_1 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_CNT_WIN_COS0_H * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_CNT_WIN_COS0_L * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_CNT_WIN_COS1_H * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_CNT_WIN_COS1_L * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_CNT_WIN_COS2_H * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_CNT_WIN_COS2_L * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_CNT_WIN_COS3_H * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_CNT_WIN_COS3_L * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_CONTROL_GENERAL_0 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_CONTROL_GENERAL_1 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_CONTROL_PIPELINE_CREDITS * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_CONTROL_SCHED_SLOT_COUNT * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_COS_CTRL * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_CQ_DIR_DISABLE * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_CQ_LDB_DISABLE * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_0_H * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_0_L * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_1_H * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_1_L * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_2_H * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_2_L * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_3_H * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_3_L * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_4_H * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_4_L * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_5_H * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_5_L * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_6_H * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_6_L * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_7_H * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_7_L * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_CQ_LDB_TOT_INFLIGHT_COUNT * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_CQ_LDB_TOT_INFLIGHT_LIMIT * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_CREDIT_CNT_COS0 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_CREDIT_CNT_COS1 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_CREDIT_CNT_COS2 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_CREDIT_CNT_COS3 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_CREDIT_SAT_COS0 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_CREDIT_SAT_COS1 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_CREDIT_SAT_COS2 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_CREDIT_SAT_COS3 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_DIAGNOSTIC_AW_STATUS * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_DIAGNOSTIC_STATUS_0 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_ERROR_INJECT * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_FID_INFLIGHT_COUNT * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_FID_INFLIGHT_LIMIT * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_HW_AGITATE_CONTROL * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_HW_AGITATE_SELECT * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_INTERFACE_STATUS * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_LDB_SCHED_CONTROL * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_0_H * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_0_L * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_1_H * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_1_L * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_2_H * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_2_L * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_3_H * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_3_L * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_4_H * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_4_L * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_5_H * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_5_L * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_6_H * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_6_L * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_7_H * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_7_L * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_CONTROL * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_LSP_CSR_CONTROL * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_LSP_PERF_DIR_SCH_COUNT_H * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_LSP_PERF_DIR_SCH_COUNT_L * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_LSP_PERF_LDB_SCH_COUNT_H * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_LSP_PERF_LDB_SCH_COUNT_L * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_PATCH_CONTROL * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_PIPE_HEALTH_HOLD_00 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_PIPE_HEALTH_HOLD_01 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_PIPE_HEALTH_VALID_00 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_PIPE_HEALTH_VALID_01 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_RDY_COS0_H * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_RDY_COS0_L * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_RDY_COS1_H * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_RDY_COS1_L * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_RDY_COS2_H * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_RDY_COS2_L * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_RDY_COS3_H * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_RDY_COS3_L * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_RND_LOSS_COS0_H * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_RND_LOSS_COS0_L * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_RND_LOSS_COS1_H * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_RND_LOSS_COS1_L * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_RND_LOSS_COS2_H * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_RND_LOSS_COS2_L * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_RND_LOSS_COS3_H * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_RND_LOSS_COS3_L * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_SCHD_COS0_H * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_SCHD_COS0_L * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_SCHD_COS1_H * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_SCHD_COS1_L * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_SCHD_COS2_H * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_SCHD_COS2_L * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_SCHD_COS3_H * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_SCHD_COS3_L * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_SCH_RDY_H * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_SCH_RDY_L * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_SHDW_CTRL * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_SHDW_RANGE_COS0 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_SHDW_RANGE_COS1 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_SHDW_RANGE_COS2 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_SHDW_RANGE_COS3 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_SMON0_ACTIVITYCOUNTER0 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_SMON0_ACTIVITYCOUNTER1 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_SMON0_COMPARE0 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_SMON0_COMPARE1 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_SMON0_CONFIGURATION0 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_SMON0_CONFIGURATION1 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_SMON0_MAXIMUM_TIMER * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_SMON0_TIMER * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_SYNDROME_HW * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_SYNDROME_SW * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_UNIT_IDLE * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_UNIT_TIMEOUT * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_LSP_TARGET_CFG_UNIT_VERSION * 32 ) +: 32 ]
                      } )
   , .out_cfg_rsp_ack ( cfg_rsp_ack )
   , .out_cfg_rsp_err ( cfg_rsp_err )
   , .out_cfg_rsp_rdata ( cfg_rsp_rdata )
) ;
hqm_AW_register_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h00000000 )
) i_hqm_lsp_target_cfg_aqed_tot_enqueue_count (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_lsp_target_cfg_aqed_tot_enqueue_count_reg_nxt )
        , .reg_f                ( hqm_lsp_target_cfg_aqed_tot_enqueue_count_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_LSP_TARGET_CFG_AQED_TOT_ENQUEUE_COUNT ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_LSP_TARGET_CFG_AQED_TOT_ENQUEUE_COUNT ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_AQED_TOT_ENQUEUE_COUNT ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_AQED_TOT_ENQUEUE_COUNT ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_AQED_TOT_ENQUEUE_COUNT * 32 +: 32 ] )
) ;
hqm_AW_register_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( HQM_LSP_AQED_TOT_ENQ_LIMIT_DEFAULT )
) i_hqm_lsp_target_cfg_aqed_tot_enqueue_limit (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_lsp_target_cfg_aqed_tot_enqueue_limit_reg_nxt )
        , .reg_f                ( hqm_lsp_target_cfg_aqed_tot_enqueue_limit_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_LSP_TARGET_CFG_AQED_TOT_ENQUEUE_LIMIT ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_LSP_TARGET_CFG_AQED_TOT_ENQUEUE_LIMIT ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_AQED_TOT_ENQUEUE_LIMIT ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_AQED_TOT_ENQUEUE_LIMIT ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_AQED_TOT_ENQUEUE_LIMIT * 32 +: 32 ] )
) ;
hqm_AW_register_enable_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( { HQM_LSP_ATM_NALB_WEIGHT_REQ3 ,HQM_LSP_ATM_NALB_WEIGHT_REQ2, HQM_LSP_ATM_NALB_WEIGHT_REQ1, HQM_LSP_ATM_NALB_WEIGHT_REQ0 } )
) i_hqm_lsp_target_cfg_arb_weight_atm_nalb_qid_0 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_lsp_target_cfg_arb_weight_atm_nalb_qid_0_reg_nxt )
        , .reg_f                ( hqm_lsp_target_cfg_arb_weight_atm_nalb_qid_0_reg_f )
        , .reg_v                ( hqm_lsp_target_cfg_arb_weight_atm_nalb_qid_0_reg_v )
        , .cfg_write            ( mux_cfg_req_write [ HQM_LSP_TARGET_CFG_ARB_WEIGHT_ATM_NALB_QID_0 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_LSP_TARGET_CFG_ARB_WEIGHT_ATM_NALB_QID_0 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_ARB_WEIGHT_ATM_NALB_QID_0 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_ARB_WEIGHT_ATM_NALB_QID_0 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_ARB_WEIGHT_ATM_NALB_QID_0 * 32 +: 32 ] )
) ;
hqm_AW_register_enable_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( { HQM_LSP_ATM_NALB_WEIGHT_REQ7 ,HQM_LSP_ATM_NALB_WEIGHT_REQ6, HQM_LSP_ATM_NALB_WEIGHT_REQ5, HQM_LSP_ATM_NALB_WEIGHT_REQ4 } )
) i_hqm_lsp_target_cfg_arb_weight_atm_nalb_qid_1 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_lsp_target_cfg_arb_weight_atm_nalb_qid_1_reg_nxt )
        , .reg_f                ( hqm_lsp_target_cfg_arb_weight_atm_nalb_qid_1_reg_f )
        , .reg_v                ( hqm_lsp_target_cfg_arb_weight_atm_nalb_qid_1_reg_v )
        , .cfg_write            ( mux_cfg_req_write [ HQM_LSP_TARGET_CFG_ARB_WEIGHT_ATM_NALB_QID_1 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_LSP_TARGET_CFG_ARB_WEIGHT_ATM_NALB_QID_1 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_ARB_WEIGHT_ATM_NALB_QID_1 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_ARB_WEIGHT_ATM_NALB_QID_1 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_ARB_WEIGHT_ATM_NALB_QID_1 * 32 +: 32 ] )
) ;
hqm_AW_register_enable_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( { HQM_LSP_LB_QID_CMP_INPUT_ARB_WEIGHT_REQ1, HQM_LSP_LB_QID_CMP_INPUT_ARB_WEIGHT_REQ0,HQM_LSP_LB_CQ_CMP_INPUT_ARB_WEIGHT_REQ1, HQM_LSP_LB_CQ_CMP_INPUT_ARB_WEIGHT_REQ0 } )
) i_hqm_lsp_target_cfg_arb_weight_ldb_issue_0 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_lsp_target_cfg_arb_weight_ldb_issue_0_reg_nxt )
        , .reg_f                ( hqm_lsp_target_cfg_arb_weight_ldb_issue_0_reg_f )
        , .reg_v                ( hqm_lsp_target_cfg_arb_weight_ldb_issue_0_reg_v )
        , .cfg_write            ( mux_cfg_req_write [ HQM_LSP_TARGET_CFG_ARB_WEIGHT_LDB_ISSUE_0 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_LSP_TARGET_CFG_ARB_WEIGHT_LDB_ISSUE_0 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_ARB_WEIGHT_LDB_ISSUE_0 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_ARB_WEIGHT_LDB_ISSUE_0 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_ARB_WEIGHT_LDB_ISSUE_0 * 32 +: 32 ] )
) ;
hqm_AW_register_enable_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( { HQM_LSP_LDB_WEIGHT_REQ3, HQM_LSP_LDB_WEIGHT_REQ2, HQM_LSP_LDB_WEIGHT_REQ1 , HQM_LSP_LDB_WEIGHT_REQ0 } )
) i_hqm_lsp_target_cfg_arb_weight_ldb_qid_0 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_lsp_target_cfg_arb_weight_ldb_qid_0_reg_nxt )
        , .reg_f                ( hqm_lsp_target_cfg_arb_weight_ldb_qid_0_reg_f )
        , .reg_v                ( hqm_lsp_target_cfg_arb_weight_ldb_qid_0_reg_v )
        , .cfg_write            ( mux_cfg_req_write [ HQM_LSP_TARGET_CFG_ARB_WEIGHT_LDB_QID_0 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_LSP_TARGET_CFG_ARB_WEIGHT_LDB_QID_0 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_ARB_WEIGHT_LDB_QID_0 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_ARB_WEIGHT_LDB_QID_0 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_ARB_WEIGHT_LDB_QID_0 * 32 +: 32 ] )
) ;
hqm_AW_register_enable_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( { HQM_LSP_LDB_WEIGHT_REQ7, HQM_LSP_LDB_WEIGHT_REQ6, HQM_LSP_LDB_WEIGHT_REQ5 , HQM_LSP_LDB_WEIGHT_REQ4 } )
) i_hqm_lsp_target_cfg_arb_weight_ldb_qid_1 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_lsp_target_cfg_arb_weight_ldb_qid_1_reg_nxt )
        , .reg_f                ( hqm_lsp_target_cfg_arb_weight_ldb_qid_1_reg_f )
        , .reg_v                ( hqm_lsp_target_cfg_arb_weight_ldb_qid_1_reg_v )
        , .cfg_write            ( mux_cfg_req_write [ HQM_LSP_TARGET_CFG_ARB_WEIGHT_LDB_QID_1 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_LSP_TARGET_CFG_ARB_WEIGHT_LDB_QID_1 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_ARB_WEIGHT_LDB_QID_1 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_ARB_WEIGHT_LDB_QID_1 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_ARB_WEIGHT_LDB_QID_1 * 32 +: 32 ] )
) ;
hqm_AW_inc_64b_wtcfg i_hqm_lsp_target_cfg_cnt_win_cos0 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .cfg_write            ( { mux_cfg_req_write [ HQM_LSP_TARGET_CFG_CNT_WIN_COS0_H ] , mux_cfg_req_write [ HQM_LSP_TARGET_CFG_CNT_WIN_COS0_L ] } )
        , .cfg_read             ( { mux_cfg_req_read [ HQM_LSP_TARGET_CFG_CNT_WIN_COS0_H ] , mux_cfg_req_read [ HQM_LSP_TARGET_CFG_CNT_WIN_COS0_L ] } )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( { mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CNT_WIN_COS0_H ] , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CNT_WIN_COS0_L ] } )
        , .cfg_err              ( { mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CNT_WIN_COS0_H ] , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CNT_WIN_COS0_L ] } )
        , .cfg_rdata            ( { mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_CNT_WIN_COS0_H * 32 +: 32 ] , mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_CNT_WIN_COS0_L * 32 +: 32 ] } )
        , .en                   ( hqm_lsp_target_cfg_cnt_win_cos0_en )
        , .clr                  ( hqm_lsp_target_cfg_cnt_win_cos0_clr )
        , .clrv                 ( hqm_lsp_target_cfg_cnt_win_cos0_clrv )
        , .inc                  ( hqm_lsp_target_cfg_cnt_win_cos0_inc )
        , .count                ( hqm_lsp_target_cfg_cnt_win_cos0_count )
) ;
hqm_AW_inc_64b_wtcfg i_hqm_lsp_target_cfg_cnt_win_cos1 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .cfg_write            ( { mux_cfg_req_write [ HQM_LSP_TARGET_CFG_CNT_WIN_COS1_H ] , mux_cfg_req_write [ HQM_LSP_TARGET_CFG_CNT_WIN_COS1_L ] } )
        , .cfg_read             ( { mux_cfg_req_read [ HQM_LSP_TARGET_CFG_CNT_WIN_COS1_H ] , mux_cfg_req_read [ HQM_LSP_TARGET_CFG_CNT_WIN_COS1_L ] } )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( { mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CNT_WIN_COS1_H ] , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CNT_WIN_COS1_L ] } )
        , .cfg_err              ( { mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CNT_WIN_COS1_H ] , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CNT_WIN_COS1_L ] } )
        , .cfg_rdata            ( { mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_CNT_WIN_COS1_H * 32 +: 32 ] , mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_CNT_WIN_COS1_L * 32 +: 32 ] } )
        , .en                   ( hqm_lsp_target_cfg_cnt_win_cos1_en )
        , .clr                  ( hqm_lsp_target_cfg_cnt_win_cos1_clr )
        , .clrv                 ( hqm_lsp_target_cfg_cnt_win_cos1_clrv )
        , .inc                  ( hqm_lsp_target_cfg_cnt_win_cos1_inc )
        , .count                ( hqm_lsp_target_cfg_cnt_win_cos1_count )
) ;
hqm_AW_inc_64b_wtcfg i_hqm_lsp_target_cfg_cnt_win_cos2 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .cfg_write            ( { mux_cfg_req_write [ HQM_LSP_TARGET_CFG_CNT_WIN_COS2_H ] , mux_cfg_req_write [ HQM_LSP_TARGET_CFG_CNT_WIN_COS2_L ] } )
        , .cfg_read             ( { mux_cfg_req_read [ HQM_LSP_TARGET_CFG_CNT_WIN_COS2_H ] , mux_cfg_req_read [ HQM_LSP_TARGET_CFG_CNT_WIN_COS2_L ] } )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( { mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CNT_WIN_COS2_H ] , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CNT_WIN_COS2_L ] } )
        , .cfg_err              ( { mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CNT_WIN_COS2_H ] , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CNT_WIN_COS2_L ] } )
        , .cfg_rdata            ( { mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_CNT_WIN_COS2_H * 32 +: 32 ] , mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_CNT_WIN_COS2_L * 32 +: 32 ] } )
        , .en                   ( hqm_lsp_target_cfg_cnt_win_cos2_en )
        , .clr                  ( hqm_lsp_target_cfg_cnt_win_cos2_clr )
        , .clrv                 ( hqm_lsp_target_cfg_cnt_win_cos2_clrv )
        , .inc                  ( hqm_lsp_target_cfg_cnt_win_cos2_inc )
        , .count                ( hqm_lsp_target_cfg_cnt_win_cos2_count )
) ;
hqm_AW_inc_64b_wtcfg i_hqm_lsp_target_cfg_cnt_win_cos3 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .cfg_write            ( { mux_cfg_req_write [ HQM_LSP_TARGET_CFG_CNT_WIN_COS3_H ] , mux_cfg_req_write [ HQM_LSP_TARGET_CFG_CNT_WIN_COS3_L ] } )
        , .cfg_read             ( { mux_cfg_req_read [ HQM_LSP_TARGET_CFG_CNT_WIN_COS3_H ] , mux_cfg_req_read [ HQM_LSP_TARGET_CFG_CNT_WIN_COS3_L ] } )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( { mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CNT_WIN_COS3_H ] , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CNT_WIN_COS3_L ] } )
        , .cfg_err              ( { mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CNT_WIN_COS3_H ] , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CNT_WIN_COS3_L ] } )
        , .cfg_rdata            ( { mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_CNT_WIN_COS3_H * 32 +: 32 ] , mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_CNT_WIN_COS3_L * 32 +: 32 ] } )
        , .en                   ( hqm_lsp_target_cfg_cnt_win_cos3_en )
        , .clr                  ( hqm_lsp_target_cfg_cnt_win_cos3_clr )
        , .clrv                 ( hqm_lsp_target_cfg_cnt_win_cos3_clrv )
        , .inc                  ( hqm_lsp_target_cfg_cnt_win_cos3_inc )
        , .count                ( hqm_lsp_target_cfg_cnt_win_cos3_count )
) ;
hqm_AW_register_enable_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( HQM_LSP_CFG_CONTROL_GENERAL_0_DEFAULT )
) i_hqm_lsp_target_cfg_control_general_0 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_lsp_target_cfg_control_general_0_reg_nxt )
        , .reg_f                ( hqm_lsp_target_cfg_control_general_0_reg_f )
        , .reg_v                ( hqm_lsp_target_cfg_control_general_0_reg_v )
        , .cfg_write            ( mux_cfg_req_write [ HQM_LSP_TARGET_CFG_CONTROL_GENERAL_0 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_LSP_TARGET_CFG_CONTROL_GENERAL_0 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CONTROL_GENERAL_0 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CONTROL_GENERAL_0 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_CONTROL_GENERAL_0 * 32 +: 32 ] )
) ;
hqm_AW_register_enable_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( HQM_LSP_CFG_CONTROL_GENERAL_1_DEFAULT )
) i_hqm_lsp_target_cfg_control_general_1 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_lsp_target_cfg_control_general_1_reg_nxt )
        , .reg_f                ( hqm_lsp_target_cfg_control_general_1_reg_f )
        , .reg_v                ( hqm_lsp_target_cfg_control_general_1_reg_v )
        , .cfg_write            ( mux_cfg_req_write [ HQM_LSP_TARGET_CFG_CONTROL_GENERAL_1 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_LSP_TARGET_CFG_CONTROL_GENERAL_1 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CONTROL_GENERAL_1 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CONTROL_GENERAL_1 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_CONTROL_GENERAL_1 * 32 +: 32 ] )
) ;
hqm_AW_register_enable_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( { HQM_LSP_AQED_DEQ_PIPE_CREDITS , HQM_LSP_QED_DEQ_PIPE_CREDITS , HQM_LSP_ATM_PIPE_CREDITS, HQM_LSP_NALB_PIPE_CREDITS } )
) i_hqm_lsp_target_cfg_control_pipeline_credits (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_lsp_target_cfg_control_pipeline_credits_reg_nxt )
        , .reg_f                ( hqm_lsp_target_cfg_control_pipeline_credits_reg_f )
        , .reg_v                ( hqm_lsp_target_cfg_control_pipeline_credits_reg_v )
        , .cfg_write            ( mux_cfg_req_write [ HQM_LSP_TARGET_CFG_CONTROL_PIPELINE_CREDITS ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_LSP_TARGET_CFG_CONTROL_PIPELINE_CREDITS ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CONTROL_PIPELINE_CREDITS ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CONTROL_PIPELINE_CREDITS ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_CONTROL_PIPELINE_CREDITS * 32 +: 32 ] )
) ;
hqm_AW_register_enable_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( HQM_LSP_CFG_CONTROL_SCHED_SLOT_COUNT_DEFAULT )
) i_hqm_lsp_target_cfg_control_sched_slot_count (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_lsp_target_cfg_control_sched_slot_count_reg_nxt )
        , .reg_f                ( hqm_lsp_target_cfg_control_sched_slot_count_reg_f )
        , .reg_v                ( hqm_lsp_target_cfg_control_sched_slot_count_reg_v )
        , .cfg_write            ( mux_cfg_req_write [ HQM_LSP_TARGET_CFG_CONTROL_SCHED_SLOT_COUNT ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_LSP_TARGET_CFG_CONTROL_SCHED_SLOT_COUNT ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CONTROL_SCHED_SLOT_COUNT ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CONTROL_SCHED_SLOT_COUNT ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_CONTROL_SCHED_SLOT_COUNT * 32 +: 32 ] )
) ;
hqm_AW_register_enable_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( HQM_LSP_CFG_COS_CTRL_DEFAULT )
) i_hqm_lsp_target_cfg_cos_ctrl (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_lsp_target_cfg_cos_ctrl_reg_nxt )
        , .reg_f                ( hqm_lsp_target_cfg_cos_ctrl_reg_f )
        , .reg_v                ( hqm_lsp_target_cfg_cos_ctrl_reg_v )
        , .cfg_write            ( mux_cfg_req_write [ HQM_LSP_TARGET_CFG_COS_CTRL ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_LSP_TARGET_CFG_COS_CTRL ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_COS_CTRL ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_COS_CTRL ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_COS_CTRL * 32 +: 32 ] )
) ;
hqm_AW_registerram_wtcfg #(
          .WIDTH                ( 1 )
        , .DEPTH                ( 64 )
        , .DEFAULT              ( { HQM_NUM_DIR_CQ { 1'b1 } } )
        , .COPY                 ( 1 )
        , .CFG_READ_MASK        ( 1 )
) i_hqm_lsp_target_cfg_cq_dir_disable (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_load             ( hqm_lsp_target_cfg_cq_dir_disable_reg_load )
        , .reg_nxt              ( hqm_lsp_target_cfg_cq_dir_disable_reg_nxt )
        , .reg_f                ( hqm_lsp_target_cfg_cq_dir_disable_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_LSP_TARGET_CFG_CQ_DIR_DISABLE ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_LSP_TARGET_CFG_CQ_DIR_DISABLE ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CQ_DIR_DISABLE ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CQ_DIR_DISABLE ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_CQ_DIR_DISABLE * 32 +: 32 ] )
) ;
hqm_AW_registerram_wtcfg #(
          .WIDTH                ( 2 )
        , .DEPTH                ( 64 )
        , .DEFAULT              ( { HQM_NUM_LB_CQ { 2'b01 } } )
        , .COPY                 ( 1 )
        , .CFG_READ_MASK        ( 3 )
) i_hqm_lsp_target_cfg_cq_ldb_disable (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_load             ( hqm_lsp_target_cfg_cq_ldb_disable_reg_load )
        , .reg_nxt              ( hqm_lsp_target_cfg_cq_ldb_disable_reg_nxt )
        , .reg_f                ( hqm_lsp_target_cfg_cq_ldb_disable_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_LSP_TARGET_CFG_CQ_LDB_DISABLE ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_LSP_TARGET_CFG_CQ_LDB_DISABLE ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_DISABLE ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_DISABLE ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_DISABLE * 32 +: 32 ] )
) ;
hqm_AW_inc_64b_wtcfg i_hqm_lsp_target_cfg_cq_ldb_sched_slot_count_0 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .cfg_write            ( { mux_cfg_req_write [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_0_H ] , mux_cfg_req_write [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_0_L ] } )
        , .cfg_read             ( { mux_cfg_req_read [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_0_H ] , mux_cfg_req_read [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_0_L ] } )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( { mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_0_H ] , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_0_L ] } )
        , .cfg_err              ( { mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_0_H ] , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_0_L ] } )
        , .cfg_rdata            ( { mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_0_H * 32 +: 32 ] , mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_0_L * 32 +: 32 ] } )
        , .en                   ( hqm_lsp_target_cfg_cq_ldb_sched_slot_count_0_en )
        , .clr                  ( hqm_lsp_target_cfg_cq_ldb_sched_slot_count_0_clr )
        , .clrv                 ( hqm_lsp_target_cfg_cq_ldb_sched_slot_count_0_clrv )
        , .inc                  ( hqm_lsp_target_cfg_cq_ldb_sched_slot_count_0_inc )
        , .count                ( hqm_lsp_target_cfg_cq_ldb_sched_slot_count_0_count )
) ;
hqm_AW_inc_64b_wtcfg i_hqm_lsp_target_cfg_cq_ldb_sched_slot_count_1 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .cfg_write            ( { mux_cfg_req_write [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_1_H ] , mux_cfg_req_write [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_1_L ] } )
        , .cfg_read             ( { mux_cfg_req_read [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_1_H ] , mux_cfg_req_read [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_1_L ] } )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( { mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_1_H ] , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_1_L ] } )
        , .cfg_err              ( { mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_1_H ] , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_1_L ] } )
        , .cfg_rdata            ( { mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_1_H * 32 +: 32 ] , mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_1_L * 32 +: 32 ] } )
        , .en                   ( hqm_lsp_target_cfg_cq_ldb_sched_slot_count_1_en )
        , .clr                  ( hqm_lsp_target_cfg_cq_ldb_sched_slot_count_1_clr )
        , .clrv                 ( hqm_lsp_target_cfg_cq_ldb_sched_slot_count_1_clrv )
        , .inc                  ( hqm_lsp_target_cfg_cq_ldb_sched_slot_count_1_inc )
        , .count                ( hqm_lsp_target_cfg_cq_ldb_sched_slot_count_1_count )
) ;
hqm_AW_inc_64b_wtcfg i_hqm_lsp_target_cfg_cq_ldb_sched_slot_count_2 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .cfg_write            ( { mux_cfg_req_write [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_2_H ] , mux_cfg_req_write [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_2_L ] } )
        , .cfg_read             ( { mux_cfg_req_read [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_2_H ] , mux_cfg_req_read [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_2_L ] } )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( { mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_2_H ] , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_2_L ] } )
        , .cfg_err              ( { mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_2_H ] , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_2_L ] } )
        , .cfg_rdata            ( { mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_2_H * 32 +: 32 ] , mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_2_L * 32 +: 32 ] } )
        , .en                   ( hqm_lsp_target_cfg_cq_ldb_sched_slot_count_2_en )
        , .clr                  ( hqm_lsp_target_cfg_cq_ldb_sched_slot_count_2_clr )
        , .clrv                 ( hqm_lsp_target_cfg_cq_ldb_sched_slot_count_2_clrv )
        , .inc                  ( hqm_lsp_target_cfg_cq_ldb_sched_slot_count_2_inc )
        , .count                ( hqm_lsp_target_cfg_cq_ldb_sched_slot_count_2_count )
) ;
hqm_AW_inc_64b_wtcfg i_hqm_lsp_target_cfg_cq_ldb_sched_slot_count_3 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .cfg_write            ( { mux_cfg_req_write [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_3_H ] , mux_cfg_req_write [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_3_L ] } )
        , .cfg_read             ( { mux_cfg_req_read [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_3_H ] , mux_cfg_req_read [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_3_L ] } )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( { mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_3_H ] , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_3_L ] } )
        , .cfg_err              ( { mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_3_H ] , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_3_L ] } )
        , .cfg_rdata            ( { mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_3_H * 32 +: 32 ] , mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_3_L * 32 +: 32 ] } )
        , .en                   ( hqm_lsp_target_cfg_cq_ldb_sched_slot_count_3_en )
        , .clr                  ( hqm_lsp_target_cfg_cq_ldb_sched_slot_count_3_clr )
        , .clrv                 ( hqm_lsp_target_cfg_cq_ldb_sched_slot_count_3_clrv )
        , .inc                  ( hqm_lsp_target_cfg_cq_ldb_sched_slot_count_3_inc )
        , .count                ( hqm_lsp_target_cfg_cq_ldb_sched_slot_count_3_count )
) ;
hqm_AW_inc_64b_wtcfg i_hqm_lsp_target_cfg_cq_ldb_sched_slot_count_4 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .cfg_write            ( { mux_cfg_req_write [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_4_H ] , mux_cfg_req_write [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_4_L ] } )
        , .cfg_read             ( { mux_cfg_req_read [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_4_H ] , mux_cfg_req_read [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_4_L ] } )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( { mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_4_H ] , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_4_L ] } )
        , .cfg_err              ( { mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_4_H ] , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_4_L ] } )
        , .cfg_rdata            ( { mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_4_H * 32 +: 32 ] , mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_4_L * 32 +: 32 ] } )
        , .en                   ( hqm_lsp_target_cfg_cq_ldb_sched_slot_count_4_en )
        , .clr                  ( hqm_lsp_target_cfg_cq_ldb_sched_slot_count_4_clr )
        , .clrv                 ( hqm_lsp_target_cfg_cq_ldb_sched_slot_count_4_clrv )
        , .inc                  ( hqm_lsp_target_cfg_cq_ldb_sched_slot_count_4_inc )
        , .count                ( hqm_lsp_target_cfg_cq_ldb_sched_slot_count_4_count )
) ;
hqm_AW_inc_64b_wtcfg i_hqm_lsp_target_cfg_cq_ldb_sched_slot_count_5 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .cfg_write            ( { mux_cfg_req_write [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_5_H ] , mux_cfg_req_write [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_5_L ] } )
        , .cfg_read             ( { mux_cfg_req_read [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_5_H ] , mux_cfg_req_read [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_5_L ] } )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( { mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_5_H ] , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_5_L ] } )
        , .cfg_err              ( { mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_5_H ] , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_5_L ] } )
        , .cfg_rdata            ( { mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_5_H * 32 +: 32 ] , mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_5_L * 32 +: 32 ] } )
        , .en                   ( hqm_lsp_target_cfg_cq_ldb_sched_slot_count_5_en )
        , .clr                  ( hqm_lsp_target_cfg_cq_ldb_sched_slot_count_5_clr )
        , .clrv                 ( hqm_lsp_target_cfg_cq_ldb_sched_slot_count_5_clrv )
        , .inc                  ( hqm_lsp_target_cfg_cq_ldb_sched_slot_count_5_inc )
        , .count                ( hqm_lsp_target_cfg_cq_ldb_sched_slot_count_5_count )
) ;
hqm_AW_inc_64b_wtcfg i_hqm_lsp_target_cfg_cq_ldb_sched_slot_count_6 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .cfg_write            ( { mux_cfg_req_write [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_6_H ] , mux_cfg_req_write [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_6_L ] } )
        , .cfg_read             ( { mux_cfg_req_read [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_6_H ] , mux_cfg_req_read [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_6_L ] } )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( { mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_6_H ] , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_6_L ] } )
        , .cfg_err              ( { mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_6_H ] , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_6_L ] } )
        , .cfg_rdata            ( { mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_6_H * 32 +: 32 ] , mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_6_L * 32 +: 32 ] } )
        , .en                   ( hqm_lsp_target_cfg_cq_ldb_sched_slot_count_6_en )
        , .clr                  ( hqm_lsp_target_cfg_cq_ldb_sched_slot_count_6_clr )
        , .clrv                 ( hqm_lsp_target_cfg_cq_ldb_sched_slot_count_6_clrv )
        , .inc                  ( hqm_lsp_target_cfg_cq_ldb_sched_slot_count_6_inc )
        , .count                ( hqm_lsp_target_cfg_cq_ldb_sched_slot_count_6_count )
) ;
hqm_AW_inc_64b_wtcfg i_hqm_lsp_target_cfg_cq_ldb_sched_slot_count_7 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .cfg_write            ( { mux_cfg_req_write [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_7_H ] , mux_cfg_req_write [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_7_L ] } )
        , .cfg_read             ( { mux_cfg_req_read [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_7_H ] , mux_cfg_req_read [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_7_L ] } )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( { mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_7_H ] , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_7_L ] } )
        , .cfg_err              ( { mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_7_H ] , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_7_L ] } )
        , .cfg_rdata            ( { mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_7_H * 32 +: 32 ] , mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_SCHED_SLOT_COUNT_7_L * 32 +: 32 ] } )
        , .en                   ( hqm_lsp_target_cfg_cq_ldb_sched_slot_count_7_en )
        , .clr                  ( hqm_lsp_target_cfg_cq_ldb_sched_slot_count_7_clr )
        , .clrv                 ( hqm_lsp_target_cfg_cq_ldb_sched_slot_count_7_clrv )
        , .inc                  ( hqm_lsp_target_cfg_cq_ldb_sched_slot_count_7_inc )
        , .count                ( hqm_lsp_target_cfg_cq_ldb_sched_slot_count_7_count )
) ;
hqm_AW_register_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h00000000 )
) i_hqm_lsp_target_cfg_cq_ldb_tot_inflight_count (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_lsp_target_cfg_cq_ldb_tot_inflight_count_reg_nxt )
        , .reg_f                ( hqm_lsp_target_cfg_cq_ldb_tot_inflight_count_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_LSP_TARGET_CFG_CQ_LDB_TOT_INFLIGHT_COUNT ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_LSP_TARGET_CFG_CQ_LDB_TOT_INFLIGHT_COUNT ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_TOT_INFLIGHT_COUNT ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_TOT_INFLIGHT_COUNT ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_TOT_INFLIGHT_COUNT * 32 +: 32 ] )
) ;
hqm_AW_register_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( HQM_LSP_LDB_TOT_INFLIGHT_LIMIT_DEFAULT )
) i_hqm_lsp_target_cfg_cq_ldb_tot_inflight_limit (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_lsp_target_cfg_cq_ldb_tot_inflight_limit_reg_nxt )
        , .reg_f                ( hqm_lsp_target_cfg_cq_ldb_tot_inflight_limit_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_LSP_TARGET_CFG_CQ_LDB_TOT_INFLIGHT_LIMIT ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_LSP_TARGET_CFG_CQ_LDB_TOT_INFLIGHT_LIMIT ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_TOT_INFLIGHT_LIMIT ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_TOT_INFLIGHT_LIMIT ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_CQ_LDB_TOT_INFLIGHT_LIMIT * 32 +: 32 ] )
) ;
hqm_AW_register_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h00000000 )
) i_hqm_lsp_target_cfg_credit_cnt_cos0 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_lsp_target_cfg_credit_cnt_cos0_reg_nxt )
        , .reg_f                ( hqm_lsp_target_cfg_credit_cnt_cos0_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_LSP_TARGET_CFG_CREDIT_CNT_COS0 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_LSP_TARGET_CFG_CREDIT_CNT_COS0 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CREDIT_CNT_COS0 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CREDIT_CNT_COS0 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_CREDIT_CNT_COS0 * 32 +: 32 ] )
) ;
hqm_AW_register_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h00000000 )
) i_hqm_lsp_target_cfg_credit_cnt_cos1 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_lsp_target_cfg_credit_cnt_cos1_reg_nxt )
        , .reg_f                ( hqm_lsp_target_cfg_credit_cnt_cos1_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_LSP_TARGET_CFG_CREDIT_CNT_COS1 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_LSP_TARGET_CFG_CREDIT_CNT_COS1 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CREDIT_CNT_COS1 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CREDIT_CNT_COS1 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_CREDIT_CNT_COS1 * 32 +: 32 ] )
) ;
hqm_AW_register_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h00000000 )
) i_hqm_lsp_target_cfg_credit_cnt_cos2 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_lsp_target_cfg_credit_cnt_cos2_reg_nxt )
        , .reg_f                ( hqm_lsp_target_cfg_credit_cnt_cos2_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_LSP_TARGET_CFG_CREDIT_CNT_COS2 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_LSP_TARGET_CFG_CREDIT_CNT_COS2 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CREDIT_CNT_COS2 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CREDIT_CNT_COS2 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_CREDIT_CNT_COS2 * 32 +: 32 ] )
) ;
hqm_AW_register_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h00000000 )
) i_hqm_lsp_target_cfg_credit_cnt_cos3 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_lsp_target_cfg_credit_cnt_cos3_reg_nxt )
        , .reg_f                ( hqm_lsp_target_cfg_credit_cnt_cos3_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_LSP_TARGET_CFG_CREDIT_CNT_COS3 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_LSP_TARGET_CFG_CREDIT_CNT_COS3 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CREDIT_CNT_COS3 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CREDIT_CNT_COS3 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_CREDIT_CNT_COS3 * 32 +: 32 ] )
) ;
hqm_AW_register_enable_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( { 16'h0 , HQM_LSP_CFG_CREDIT_SAT_COS0_DEFAULT } )
) i_hqm_lsp_target_cfg_credit_sat_cos0 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_lsp_target_cfg_credit_sat_cos0_reg_nxt )
        , .reg_f                ( hqm_lsp_target_cfg_credit_sat_cos0_reg_f )
        , .reg_v                ( hqm_lsp_target_cfg_credit_sat_cos0_reg_v )
        , .cfg_write            ( mux_cfg_req_write [ HQM_LSP_TARGET_CFG_CREDIT_SAT_COS0 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_LSP_TARGET_CFG_CREDIT_SAT_COS0 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CREDIT_SAT_COS0 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CREDIT_SAT_COS0 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_CREDIT_SAT_COS0 * 32 +: 32 ] )
) ;
hqm_AW_register_enable_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( { 16'h0 , HQM_LSP_CFG_CREDIT_SAT_COS1_DEFAULT } )
) i_hqm_lsp_target_cfg_credit_sat_cos1 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_lsp_target_cfg_credit_sat_cos1_reg_nxt )
        , .reg_f                ( hqm_lsp_target_cfg_credit_sat_cos1_reg_f )
        , .reg_v                ( hqm_lsp_target_cfg_credit_sat_cos1_reg_v )
        , .cfg_write            ( mux_cfg_req_write [ HQM_LSP_TARGET_CFG_CREDIT_SAT_COS1 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_LSP_TARGET_CFG_CREDIT_SAT_COS1 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CREDIT_SAT_COS1 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CREDIT_SAT_COS1 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_CREDIT_SAT_COS1 * 32 +: 32 ] )
) ;
hqm_AW_register_enable_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( { 16'h0 , HQM_LSP_CFG_CREDIT_SAT_COS2_DEFAULT } )
) i_hqm_lsp_target_cfg_credit_sat_cos2 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_lsp_target_cfg_credit_sat_cos2_reg_nxt )
        , .reg_f                ( hqm_lsp_target_cfg_credit_sat_cos2_reg_f )
        , .reg_v                ( hqm_lsp_target_cfg_credit_sat_cos2_reg_v )
        , .cfg_write            ( mux_cfg_req_write [ HQM_LSP_TARGET_CFG_CREDIT_SAT_COS2 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_LSP_TARGET_CFG_CREDIT_SAT_COS2 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CREDIT_SAT_COS2 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CREDIT_SAT_COS2 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_CREDIT_SAT_COS2 * 32 +: 32 ] )
) ;
hqm_AW_register_enable_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( { 16'h0 , HQM_LSP_CFG_CREDIT_SAT_COS3_DEFAULT } )
) i_hqm_lsp_target_cfg_credit_sat_cos3 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_lsp_target_cfg_credit_sat_cos3_reg_nxt )
        , .reg_f                ( hqm_lsp_target_cfg_credit_sat_cos3_reg_f )
        , .reg_v                ( hqm_lsp_target_cfg_credit_sat_cos3_reg_v )
        , .cfg_write            ( mux_cfg_req_write [ HQM_LSP_TARGET_CFG_CREDIT_SAT_COS3 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_LSP_TARGET_CFG_CREDIT_SAT_COS3 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_CREDIT_SAT_COS3 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_CREDIT_SAT_COS3 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_CREDIT_SAT_COS3 * 32 +: 32 ] )
) ;
hqm_AW_status_wtcfg i_hqm_lsp_target_cfg_diagnostic_aw_status (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .status               ( hqm_lsp_target_cfg_diagnostic_aw_status_status )
        , .cfg_write            ( mux_cfg_req_write [ HQM_LSP_TARGET_CFG_DIAGNOSTIC_AW_STATUS ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_LSP_TARGET_CFG_DIAGNOSTIC_AW_STATUS ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_DIAGNOSTIC_AW_STATUS ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_DIAGNOSTIC_AW_STATUS ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_DIAGNOSTIC_AW_STATUS * 32 +: 32 ] )
) ;
hqm_AW_status_wtcfg i_hqm_lsp_target_cfg_diagnostic_status_0 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .status               ( hqm_lsp_target_cfg_diagnostic_status_0_status )
        , .cfg_write            ( mux_cfg_req_write [ HQM_LSP_TARGET_CFG_DIAGNOSTIC_STATUS_0 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_LSP_TARGET_CFG_DIAGNOSTIC_STATUS_0 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_DIAGNOSTIC_STATUS_0 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_DIAGNOSTIC_STATUS_0 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_DIAGNOSTIC_STATUS_0 * 32 +: 32 ] )
) ;
hqm_AW_register_enable_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h00000000 )
) i_hqm_lsp_target_cfg_error_inject (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_lsp_target_cfg_error_inject_reg_nxt )
        , .reg_f                ( hqm_lsp_target_cfg_error_inject_reg_f )
        , .reg_v                ( hqm_lsp_target_cfg_error_inject_reg_v )
        , .cfg_write            ( mux_cfg_req_write [ HQM_LSP_TARGET_CFG_ERROR_INJECT ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_LSP_TARGET_CFG_ERROR_INJECT ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_ERROR_INJECT ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_ERROR_INJECT ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_ERROR_INJECT * 32 +: 32 ] )
) ;
hqm_AW_register_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h00000000 )
) i_hqm_lsp_target_cfg_fid_inflight_count (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_lsp_target_cfg_fid_inflight_count_reg_nxt )
        , .reg_f                ( hqm_lsp_target_cfg_fid_inflight_count_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_LSP_TARGET_CFG_FID_INFLIGHT_COUNT ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_LSP_TARGET_CFG_FID_INFLIGHT_COUNT ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_FID_INFLIGHT_COUNT ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_FID_INFLIGHT_COUNT ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_FID_INFLIGHT_COUNT * 32 +: 32 ] )
) ;
hqm_AW_register_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( HQM_LSP_ATQ_FID_INFLIGHT_LIMIT_DEFAULT )
) i_hqm_lsp_target_cfg_fid_inflight_limit (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_lsp_target_cfg_fid_inflight_limit_reg_nxt )
        , .reg_f                ( hqm_lsp_target_cfg_fid_inflight_limit_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_LSP_TARGET_CFG_FID_INFLIGHT_LIMIT ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_LSP_TARGET_CFG_FID_INFLIGHT_LIMIT ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_FID_INFLIGHT_LIMIT ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_FID_INFLIGHT_LIMIT ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_FID_INFLIGHT_LIMIT * 32 +: 32 ] )
) ;
hqm_AW_register_enable_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h00000000 )
) i_hqm_lsp_target_cfg_hw_agitate_control (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_lsp_target_cfg_hw_agitate_control_reg_nxt )
        , .reg_f                ( hqm_lsp_target_cfg_hw_agitate_control_reg_f )
        , .reg_v                ( hqm_lsp_target_cfg_hw_agitate_control_reg_v )
        , .cfg_write            ( mux_cfg_req_write [ HQM_LSP_TARGET_CFG_HW_AGITATE_CONTROL ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_LSP_TARGET_CFG_HW_AGITATE_CONTROL ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_HW_AGITATE_CONTROL ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_HW_AGITATE_CONTROL ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_HW_AGITATE_CONTROL * 32 +: 32 ] )
) ;
hqm_AW_register_enable_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h00000000 )
) i_hqm_lsp_target_cfg_hw_agitate_select (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_lsp_target_cfg_hw_agitate_select_reg_nxt )
        , .reg_f                ( hqm_lsp_target_cfg_hw_agitate_select_reg_f )
        , .reg_v                ( hqm_lsp_target_cfg_hw_agitate_select_reg_v )
        , .cfg_write            ( mux_cfg_req_write [ HQM_LSP_TARGET_CFG_HW_AGITATE_SELECT ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_LSP_TARGET_CFG_HW_AGITATE_SELECT ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_HW_AGITATE_SELECT ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_HW_AGITATE_SELECT ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_HW_AGITATE_SELECT * 32 +: 32 ] )
) ;
hqm_AW_register_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              (  )
) i_hqm_lsp_target_cfg_interface_status (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_lsp_target_cfg_interface_status_reg_nxt )
        , .reg_f                ( hqm_lsp_target_cfg_interface_status_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_LSP_TARGET_CFG_INTERFACE_STATUS ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_LSP_TARGET_CFG_INTERFACE_STATUS ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_INTERFACE_STATUS ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_INTERFACE_STATUS ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_INTERFACE_STATUS * 32 +: 32 ] )
) ;
hqm_AW_register_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( HQM_LSP_CFG_LDB_SCHED_CONTROL_DEFAULT )
) i_hqm_lsp_target_cfg_ldb_sched_control (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_lsp_target_cfg_ldb_sched_control_reg_nxt )
        , .reg_f                ( hqm_lsp_target_cfg_ldb_sched_control_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_LSP_TARGET_CFG_LDB_SCHED_CONTROL ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_LSP_TARGET_CFG_LDB_SCHED_CONTROL ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_CONTROL ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_CONTROL ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_CONTROL * 32 +: 32 ] )
) ;
hqm_AW_inc_64b_wtcfg i_hqm_lsp_target_cfg_ldb_sched_perf_0 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .cfg_write            ( { mux_cfg_req_write [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_0_H ] , mux_cfg_req_write [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_0_L ] } )
        , .cfg_read             ( { mux_cfg_req_read [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_0_H ] , mux_cfg_req_read [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_0_L ] } )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( { mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_0_H ] , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_0_L ] } )
        , .cfg_err              ( { mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_0_H ] , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_0_L ] } )
        , .cfg_rdata            ( { mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_0_H * 32 +: 32 ] , mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_0_L * 32 +: 32 ] } )
        , .en                   ( hqm_lsp_target_cfg_ldb_sched_perf_0_en )
        , .clr                  ( hqm_lsp_target_cfg_ldb_sched_perf_0_clr )
        , .clrv                 ( hqm_lsp_target_cfg_ldb_sched_perf_0_clrv )
        , .inc                  ( hqm_lsp_target_cfg_ldb_sched_perf_0_inc )
        , .count                ( hqm_lsp_target_cfg_ldb_sched_perf_0_count )
) ;
hqm_AW_inc_64b_wtcfg i_hqm_lsp_target_cfg_ldb_sched_perf_1 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .cfg_write            ( { mux_cfg_req_write [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_1_H ] , mux_cfg_req_write [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_1_L ] } )
        , .cfg_read             ( { mux_cfg_req_read [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_1_H ] , mux_cfg_req_read [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_1_L ] } )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( { mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_1_H ] , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_1_L ] } )
        , .cfg_err              ( { mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_1_H ] , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_1_L ] } )
        , .cfg_rdata            ( { mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_1_H * 32 +: 32 ] , mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_1_L * 32 +: 32 ] } )
        , .en                   ( hqm_lsp_target_cfg_ldb_sched_perf_1_en )
        , .clr                  ( hqm_lsp_target_cfg_ldb_sched_perf_1_clr )
        , .clrv                 ( hqm_lsp_target_cfg_ldb_sched_perf_1_clrv )
        , .inc                  ( hqm_lsp_target_cfg_ldb_sched_perf_1_inc )
        , .count                ( hqm_lsp_target_cfg_ldb_sched_perf_1_count )
) ;
hqm_AW_inc_64b_wtcfg i_hqm_lsp_target_cfg_ldb_sched_perf_2 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .cfg_write            ( { mux_cfg_req_write [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_2_H ] , mux_cfg_req_write [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_2_L ] } )
        , .cfg_read             ( { mux_cfg_req_read [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_2_H ] , mux_cfg_req_read [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_2_L ] } )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( { mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_2_H ] , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_2_L ] } )
        , .cfg_err              ( { mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_2_H ] , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_2_L ] } )
        , .cfg_rdata            ( { mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_2_H * 32 +: 32 ] , mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_2_L * 32 +: 32 ] } )
        , .en                   ( hqm_lsp_target_cfg_ldb_sched_perf_2_en )
        , .clr                  ( hqm_lsp_target_cfg_ldb_sched_perf_2_clr )
        , .clrv                 ( hqm_lsp_target_cfg_ldb_sched_perf_2_clrv )
        , .inc                  ( hqm_lsp_target_cfg_ldb_sched_perf_2_inc )
        , .count                ( hqm_lsp_target_cfg_ldb_sched_perf_2_count )
) ;
hqm_AW_inc_64b_wtcfg i_hqm_lsp_target_cfg_ldb_sched_perf_3 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .cfg_write            ( { mux_cfg_req_write [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_3_H ] , mux_cfg_req_write [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_3_L ] } )
        , .cfg_read             ( { mux_cfg_req_read [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_3_H ] , mux_cfg_req_read [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_3_L ] } )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( { mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_3_H ] , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_3_L ] } )
        , .cfg_err              ( { mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_3_H ] , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_3_L ] } )
        , .cfg_rdata            ( { mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_3_H * 32 +: 32 ] , mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_3_L * 32 +: 32 ] } )
        , .en                   ( hqm_lsp_target_cfg_ldb_sched_perf_3_en )
        , .clr                  ( hqm_lsp_target_cfg_ldb_sched_perf_3_clr )
        , .clrv                 ( hqm_lsp_target_cfg_ldb_sched_perf_3_clrv )
        , .inc                  ( hqm_lsp_target_cfg_ldb_sched_perf_3_inc )
        , .count                ( hqm_lsp_target_cfg_ldb_sched_perf_3_count )
) ;
hqm_AW_inc_64b_wtcfg i_hqm_lsp_target_cfg_ldb_sched_perf_4 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .cfg_write            ( { mux_cfg_req_write [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_4_H ] , mux_cfg_req_write [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_4_L ] } )
        , .cfg_read             ( { mux_cfg_req_read [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_4_H ] , mux_cfg_req_read [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_4_L ] } )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( { mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_4_H ] , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_4_L ] } )
        , .cfg_err              ( { mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_4_H ] , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_4_L ] } )
        , .cfg_rdata            ( { mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_4_H * 32 +: 32 ] , mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_4_L * 32 +: 32 ] } )
        , .en                   ( hqm_lsp_target_cfg_ldb_sched_perf_4_en )
        , .clr                  ( hqm_lsp_target_cfg_ldb_sched_perf_4_clr )
        , .clrv                 ( hqm_lsp_target_cfg_ldb_sched_perf_4_clrv )
        , .inc                  ( hqm_lsp_target_cfg_ldb_sched_perf_4_inc )
        , .count                ( hqm_lsp_target_cfg_ldb_sched_perf_4_count )
) ;
hqm_AW_inc_64b_wtcfg i_hqm_lsp_target_cfg_ldb_sched_perf_5 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .cfg_write            ( { mux_cfg_req_write [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_5_H ] , mux_cfg_req_write [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_5_L ] } )
        , .cfg_read             ( { mux_cfg_req_read [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_5_H ] , mux_cfg_req_read [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_5_L ] } )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( { mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_5_H ] , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_5_L ] } )
        , .cfg_err              ( { mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_5_H ] , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_5_L ] } )
        , .cfg_rdata            ( { mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_5_H * 32 +: 32 ] , mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_5_L * 32 +: 32 ] } )
        , .en                   ( hqm_lsp_target_cfg_ldb_sched_perf_5_en )
        , .clr                  ( hqm_lsp_target_cfg_ldb_sched_perf_5_clr )
        , .clrv                 ( hqm_lsp_target_cfg_ldb_sched_perf_5_clrv )
        , .inc                  ( hqm_lsp_target_cfg_ldb_sched_perf_5_inc )
        , .count                ( hqm_lsp_target_cfg_ldb_sched_perf_5_count )
) ;
hqm_AW_inc_64b_wtcfg i_hqm_lsp_target_cfg_ldb_sched_perf_6 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .cfg_write            ( { mux_cfg_req_write [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_6_H ] , mux_cfg_req_write [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_6_L ] } )
        , .cfg_read             ( { mux_cfg_req_read [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_6_H ] , mux_cfg_req_read [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_6_L ] } )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( { mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_6_H ] , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_6_L ] } )
        , .cfg_err              ( { mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_6_H ] , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_6_L ] } )
        , .cfg_rdata            ( { mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_6_H * 32 +: 32 ] , mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_6_L * 32 +: 32 ] } )
        , .en                   ( hqm_lsp_target_cfg_ldb_sched_perf_6_en )
        , .clr                  ( hqm_lsp_target_cfg_ldb_sched_perf_6_clr )
        , .clrv                 ( hqm_lsp_target_cfg_ldb_sched_perf_6_clrv )
        , .inc                  ( hqm_lsp_target_cfg_ldb_sched_perf_6_inc )
        , .count                ( hqm_lsp_target_cfg_ldb_sched_perf_6_count )
) ;
hqm_AW_inc_64b_wtcfg i_hqm_lsp_target_cfg_ldb_sched_perf_7 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .cfg_write            ( { mux_cfg_req_write [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_7_H ] , mux_cfg_req_write [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_7_L ] } )
        , .cfg_read             ( { mux_cfg_req_read [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_7_H ] , mux_cfg_req_read [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_7_L ] } )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( { mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_7_H ] , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_7_L ] } )
        , .cfg_err              ( { mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_7_H ] , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_7_L ] } )
        , .cfg_rdata            ( { mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_7_H * 32 +: 32 ] , mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_7_L * 32 +: 32 ] } )
        , .en                   ( hqm_lsp_target_cfg_ldb_sched_perf_7_en )
        , .clr                  ( hqm_lsp_target_cfg_ldb_sched_perf_7_clr )
        , .clrv                 ( hqm_lsp_target_cfg_ldb_sched_perf_7_clrv )
        , .inc                  ( hqm_lsp_target_cfg_ldb_sched_perf_7_inc )
        , .count                ( hqm_lsp_target_cfg_ldb_sched_perf_7_count )
) ;
hqm_AW_register_enable_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( HQM_LSP_CFG_LDB_SCHED_PERF_CONTROL_DEFAULT )
) i_hqm_lsp_target_cfg_ldb_sched_perf_control (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_lsp_target_cfg_ldb_sched_perf_control_reg_nxt )
        , .reg_f                ( hqm_lsp_target_cfg_ldb_sched_perf_control_reg_f )
        , .reg_v                ( hqm_lsp_target_cfg_ldb_sched_perf_control_reg_v )
        , .cfg_write            ( mux_cfg_req_write [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_CONTROL ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_CONTROL ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_CONTROL ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_CONTROL ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_LDB_SCHED_PERF_CONTROL * 32 +: 32 ] )
) ;
hqm_AW_register_enable_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( HQM_LSP_CFG_LSP_CSR_CONTROL_DEFAULT )
) i_hqm_lsp_target_cfg_lsp_csr_control (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_lsp_target_cfg_lsp_csr_control_reg_nxt )
        , .reg_f                ( hqm_lsp_target_cfg_lsp_csr_control_reg_f )
        , .reg_v                ( hqm_lsp_target_cfg_lsp_csr_control_reg_v )
        , .cfg_write            ( mux_cfg_req_write [ HQM_LSP_TARGET_CFG_LSP_CSR_CONTROL ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_LSP_TARGET_CFG_LSP_CSR_CONTROL ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_LSP_CSR_CONTROL ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_LSP_CSR_CONTROL ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_LSP_CSR_CONTROL * 32 +: 32 ] )
) ;
hqm_AW_register_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              (  )
) i_hqm_lsp_target_cfg_lsp_perf_dir_sch_count_h (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_lsp_target_cfg_lsp_perf_dir_sch_count_h_reg_nxt )
        , .reg_f                ( hqm_lsp_target_cfg_lsp_perf_dir_sch_count_h_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_LSP_TARGET_CFG_LSP_PERF_DIR_SCH_COUNT_H ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_LSP_TARGET_CFG_LSP_PERF_DIR_SCH_COUNT_H ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_LSP_PERF_DIR_SCH_COUNT_H ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_LSP_PERF_DIR_SCH_COUNT_H ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_LSP_PERF_DIR_SCH_COUNT_H * 32 +: 32 ] )
) ;
hqm_AW_register_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              (  )
) i_hqm_lsp_target_cfg_lsp_perf_dir_sch_count_l (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_lsp_target_cfg_lsp_perf_dir_sch_count_l_reg_nxt )
        , .reg_f                ( hqm_lsp_target_cfg_lsp_perf_dir_sch_count_l_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_LSP_TARGET_CFG_LSP_PERF_DIR_SCH_COUNT_L ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_LSP_TARGET_CFG_LSP_PERF_DIR_SCH_COUNT_L ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_LSP_PERF_DIR_SCH_COUNT_L ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_LSP_PERF_DIR_SCH_COUNT_L ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_LSP_PERF_DIR_SCH_COUNT_L * 32 +: 32 ] )
) ;
hqm_AW_inc_64b_wtcfg i_hqm_lsp_target_cfg_lsp_perf_ldb_sch_count (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .cfg_write            ( { mux_cfg_req_write [ HQM_LSP_TARGET_CFG_LSP_PERF_LDB_SCH_COUNT_H ] , mux_cfg_req_write [ HQM_LSP_TARGET_CFG_LSP_PERF_LDB_SCH_COUNT_L ] } )
        , .cfg_read             ( { mux_cfg_req_read [ HQM_LSP_TARGET_CFG_LSP_PERF_LDB_SCH_COUNT_H ] , mux_cfg_req_read [ HQM_LSP_TARGET_CFG_LSP_PERF_LDB_SCH_COUNT_L ] } )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( { mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_LSP_PERF_LDB_SCH_COUNT_H ] , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_LSP_PERF_LDB_SCH_COUNT_L ] } )
        , .cfg_err              ( { mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_LSP_PERF_LDB_SCH_COUNT_H ] , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_LSP_PERF_LDB_SCH_COUNT_L ] } )
        , .cfg_rdata            ( { mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_LSP_PERF_LDB_SCH_COUNT_H * 32 +: 32 ] , mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_LSP_PERF_LDB_SCH_COUNT_L * 32 +: 32 ] } )
        , .en                   ( hqm_lsp_target_cfg_lsp_perf_ldb_sch_count_en )
        , .clr                  ( hqm_lsp_target_cfg_lsp_perf_ldb_sch_count_clr )
        , .clrv                 ( hqm_lsp_target_cfg_lsp_perf_ldb_sch_count_clrv )
        , .inc                  ( hqm_lsp_target_cfg_lsp_perf_ldb_sch_count_inc )
        , .count                ( hqm_lsp_target_cfg_lsp_perf_ldb_sch_count_count )
) ;
hqm_AW_register_enable_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h00000740 )
) i_hqm_lsp_target_cfg_patch_control (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_lsp_target_cfg_patch_control_reg_nxt )
        , .reg_f                ( hqm_lsp_target_cfg_patch_control_reg_f )
        , .reg_v                ( hqm_lsp_target_cfg_patch_control_reg_v )
        , .cfg_write            ( mux_cfg_req_write [ HQM_LSP_TARGET_CFG_PATCH_CONTROL ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_LSP_TARGET_CFG_PATCH_CONTROL ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_PATCH_CONTROL ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_PATCH_CONTROL ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_PATCH_CONTROL * 32 +: 32 ] )
) ;
hqm_AW_status_wtcfg i_hqm_lsp_target_cfg_pipe_health_hold_00 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .status               ( hqm_lsp_target_cfg_pipe_health_hold_00_status )
        , .cfg_write            ( mux_cfg_req_write [ HQM_LSP_TARGET_CFG_PIPE_HEALTH_HOLD_00 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_LSP_TARGET_CFG_PIPE_HEALTH_HOLD_00 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_PIPE_HEALTH_HOLD_00 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_PIPE_HEALTH_HOLD_00 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_PIPE_HEALTH_HOLD_00 * 32 +: 32 ] )
) ;
hqm_AW_status_wtcfg i_hqm_lsp_target_cfg_pipe_health_hold_01 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .status               ( hqm_lsp_target_cfg_pipe_health_hold_01_status )
        , .cfg_write            ( mux_cfg_req_write [ HQM_LSP_TARGET_CFG_PIPE_HEALTH_HOLD_01 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_LSP_TARGET_CFG_PIPE_HEALTH_HOLD_01 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_PIPE_HEALTH_HOLD_01 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_PIPE_HEALTH_HOLD_01 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_PIPE_HEALTH_HOLD_01 * 32 +: 32 ] )
) ;
hqm_AW_status_wtcfg i_hqm_lsp_target_cfg_pipe_health_valid_00 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .status               ( hqm_lsp_target_cfg_pipe_health_valid_00_status )
        , .cfg_write            ( mux_cfg_req_write [ HQM_LSP_TARGET_CFG_PIPE_HEALTH_VALID_00 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_LSP_TARGET_CFG_PIPE_HEALTH_VALID_00 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_PIPE_HEALTH_VALID_00 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_PIPE_HEALTH_VALID_00 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_PIPE_HEALTH_VALID_00 * 32 +: 32 ] )
) ;
hqm_AW_status_wtcfg i_hqm_lsp_target_cfg_pipe_health_valid_01 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .status               ( hqm_lsp_target_cfg_pipe_health_valid_01_status )
        , .cfg_write            ( mux_cfg_req_write [ HQM_LSP_TARGET_CFG_PIPE_HEALTH_VALID_01 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_LSP_TARGET_CFG_PIPE_HEALTH_VALID_01 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_PIPE_HEALTH_VALID_01 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_PIPE_HEALTH_VALID_01 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_PIPE_HEALTH_VALID_01 * 32 +: 32 ] )
) ;
hqm_AW_inc_64b_wtcfg i_hqm_lsp_target_cfg_rdy_cos0 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .cfg_write            ( { mux_cfg_req_write [ HQM_LSP_TARGET_CFG_RDY_COS0_H ] , mux_cfg_req_write [ HQM_LSP_TARGET_CFG_RDY_COS0_L ] } )
        , .cfg_read             ( { mux_cfg_req_read [ HQM_LSP_TARGET_CFG_RDY_COS0_H ] , mux_cfg_req_read [ HQM_LSP_TARGET_CFG_RDY_COS0_L ] } )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( { mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_RDY_COS0_H ] , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_RDY_COS0_L ] } )
        , .cfg_err              ( { mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_RDY_COS0_H ] , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_RDY_COS0_L ] } )
        , .cfg_rdata            ( { mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_RDY_COS0_H * 32 +: 32 ] , mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_RDY_COS0_L * 32 +: 32 ] } )
        , .en                   ( hqm_lsp_target_cfg_rdy_cos0_en )
        , .clr                  ( hqm_lsp_target_cfg_rdy_cos0_clr )
        , .clrv                 ( hqm_lsp_target_cfg_rdy_cos0_clrv )
        , .inc                  ( hqm_lsp_target_cfg_rdy_cos0_inc )
        , .count                ( hqm_lsp_target_cfg_rdy_cos0_count )
) ;
hqm_AW_inc_64b_wtcfg i_hqm_lsp_target_cfg_rdy_cos1 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .cfg_write            ( { mux_cfg_req_write [ HQM_LSP_TARGET_CFG_RDY_COS1_H ] , mux_cfg_req_write [ HQM_LSP_TARGET_CFG_RDY_COS1_L ] } )
        , .cfg_read             ( { mux_cfg_req_read [ HQM_LSP_TARGET_CFG_RDY_COS1_H ] , mux_cfg_req_read [ HQM_LSP_TARGET_CFG_RDY_COS1_L ] } )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( { mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_RDY_COS1_H ] , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_RDY_COS1_L ] } )
        , .cfg_err              ( { mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_RDY_COS1_H ] , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_RDY_COS1_L ] } )
        , .cfg_rdata            ( { mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_RDY_COS1_H * 32 +: 32 ] , mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_RDY_COS1_L * 32 +: 32 ] } )
        , .en                   ( hqm_lsp_target_cfg_rdy_cos1_en )
        , .clr                  ( hqm_lsp_target_cfg_rdy_cos1_clr )
        , .clrv                 ( hqm_lsp_target_cfg_rdy_cos1_clrv )
        , .inc                  ( hqm_lsp_target_cfg_rdy_cos1_inc )
        , .count                ( hqm_lsp_target_cfg_rdy_cos1_count )
) ;
hqm_AW_inc_64b_wtcfg i_hqm_lsp_target_cfg_rdy_cos2 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .cfg_write            ( { mux_cfg_req_write [ HQM_LSP_TARGET_CFG_RDY_COS2_H ] , mux_cfg_req_write [ HQM_LSP_TARGET_CFG_RDY_COS2_L ] } )
        , .cfg_read             ( { mux_cfg_req_read [ HQM_LSP_TARGET_CFG_RDY_COS2_H ] , mux_cfg_req_read [ HQM_LSP_TARGET_CFG_RDY_COS2_L ] } )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( { mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_RDY_COS2_H ] , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_RDY_COS2_L ] } )
        , .cfg_err              ( { mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_RDY_COS2_H ] , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_RDY_COS2_L ] } )
        , .cfg_rdata            ( { mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_RDY_COS2_H * 32 +: 32 ] , mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_RDY_COS2_L * 32 +: 32 ] } )
        , .en                   ( hqm_lsp_target_cfg_rdy_cos2_en )
        , .clr                  ( hqm_lsp_target_cfg_rdy_cos2_clr )
        , .clrv                 ( hqm_lsp_target_cfg_rdy_cos2_clrv )
        , .inc                  ( hqm_lsp_target_cfg_rdy_cos2_inc )
        , .count                ( hqm_lsp_target_cfg_rdy_cos2_count )
) ;
hqm_AW_inc_64b_wtcfg i_hqm_lsp_target_cfg_rdy_cos3 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .cfg_write            ( { mux_cfg_req_write [ HQM_LSP_TARGET_CFG_RDY_COS3_H ] , mux_cfg_req_write [ HQM_LSP_TARGET_CFG_RDY_COS3_L ] } )
        , .cfg_read             ( { mux_cfg_req_read [ HQM_LSP_TARGET_CFG_RDY_COS3_H ] , mux_cfg_req_read [ HQM_LSP_TARGET_CFG_RDY_COS3_L ] } )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( { mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_RDY_COS3_H ] , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_RDY_COS3_L ] } )
        , .cfg_err              ( { mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_RDY_COS3_H ] , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_RDY_COS3_L ] } )
        , .cfg_rdata            ( { mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_RDY_COS3_H * 32 +: 32 ] , mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_RDY_COS3_L * 32 +: 32 ] } )
        , .en                   ( hqm_lsp_target_cfg_rdy_cos3_en )
        , .clr                  ( hqm_lsp_target_cfg_rdy_cos3_clr )
        , .clrv                 ( hqm_lsp_target_cfg_rdy_cos3_clrv )
        , .inc                  ( hqm_lsp_target_cfg_rdy_cos3_inc )
        , .count                ( hqm_lsp_target_cfg_rdy_cos3_count )
) ;
hqm_AW_inc_64b_wtcfg i_hqm_lsp_target_cfg_rnd_loss_cos0 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .cfg_write            ( { mux_cfg_req_write [ HQM_LSP_TARGET_CFG_RND_LOSS_COS0_H ] , mux_cfg_req_write [ HQM_LSP_TARGET_CFG_RND_LOSS_COS0_L ] } )
        , .cfg_read             ( { mux_cfg_req_read [ HQM_LSP_TARGET_CFG_RND_LOSS_COS0_H ] , mux_cfg_req_read [ HQM_LSP_TARGET_CFG_RND_LOSS_COS0_L ] } )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( { mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_RND_LOSS_COS0_H ] , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_RND_LOSS_COS0_L ] } )
        , .cfg_err              ( { mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_RND_LOSS_COS0_H ] , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_RND_LOSS_COS0_L ] } )
        , .cfg_rdata            ( { mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_RND_LOSS_COS0_H * 32 +: 32 ] , mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_RND_LOSS_COS0_L * 32 +: 32 ] } )
        , .en                   ( hqm_lsp_target_cfg_rnd_loss_cos0_en )
        , .clr                  ( hqm_lsp_target_cfg_rnd_loss_cos0_clr )
        , .clrv                 ( hqm_lsp_target_cfg_rnd_loss_cos0_clrv )
        , .inc                  ( hqm_lsp_target_cfg_rnd_loss_cos0_inc )
        , .count                ( hqm_lsp_target_cfg_rnd_loss_cos0_count )
) ;
hqm_AW_inc_64b_wtcfg i_hqm_lsp_target_cfg_rnd_loss_cos1 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .cfg_write            ( { mux_cfg_req_write [ HQM_LSP_TARGET_CFG_RND_LOSS_COS1_H ] , mux_cfg_req_write [ HQM_LSP_TARGET_CFG_RND_LOSS_COS1_L ] } )
        , .cfg_read             ( { mux_cfg_req_read [ HQM_LSP_TARGET_CFG_RND_LOSS_COS1_H ] , mux_cfg_req_read [ HQM_LSP_TARGET_CFG_RND_LOSS_COS1_L ] } )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( { mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_RND_LOSS_COS1_H ] , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_RND_LOSS_COS1_L ] } )
        , .cfg_err              ( { mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_RND_LOSS_COS1_H ] , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_RND_LOSS_COS1_L ] } )
        , .cfg_rdata            ( { mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_RND_LOSS_COS1_H * 32 +: 32 ] , mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_RND_LOSS_COS1_L * 32 +: 32 ] } )
        , .en                   ( hqm_lsp_target_cfg_rnd_loss_cos1_en )
        , .clr                  ( hqm_lsp_target_cfg_rnd_loss_cos1_clr )
        , .clrv                 ( hqm_lsp_target_cfg_rnd_loss_cos1_clrv )
        , .inc                  ( hqm_lsp_target_cfg_rnd_loss_cos1_inc )
        , .count                ( hqm_lsp_target_cfg_rnd_loss_cos1_count )
) ;
hqm_AW_inc_64b_wtcfg i_hqm_lsp_target_cfg_rnd_loss_cos2 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .cfg_write            ( { mux_cfg_req_write [ HQM_LSP_TARGET_CFG_RND_LOSS_COS2_H ] , mux_cfg_req_write [ HQM_LSP_TARGET_CFG_RND_LOSS_COS2_L ] } )
        , .cfg_read             ( { mux_cfg_req_read [ HQM_LSP_TARGET_CFG_RND_LOSS_COS2_H ] , mux_cfg_req_read [ HQM_LSP_TARGET_CFG_RND_LOSS_COS2_L ] } )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( { mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_RND_LOSS_COS2_H ] , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_RND_LOSS_COS2_L ] } )
        , .cfg_err              ( { mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_RND_LOSS_COS2_H ] , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_RND_LOSS_COS2_L ] } )
        , .cfg_rdata            ( { mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_RND_LOSS_COS2_H * 32 +: 32 ] , mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_RND_LOSS_COS2_L * 32 +: 32 ] } )
        , .en                   ( hqm_lsp_target_cfg_rnd_loss_cos2_en )
        , .clr                  ( hqm_lsp_target_cfg_rnd_loss_cos2_clr )
        , .clrv                 ( hqm_lsp_target_cfg_rnd_loss_cos2_clrv )
        , .inc                  ( hqm_lsp_target_cfg_rnd_loss_cos2_inc )
        , .count                ( hqm_lsp_target_cfg_rnd_loss_cos2_count )
) ;
hqm_AW_inc_64b_wtcfg i_hqm_lsp_target_cfg_rnd_loss_cos3 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .cfg_write            ( { mux_cfg_req_write [ HQM_LSP_TARGET_CFG_RND_LOSS_COS3_H ] , mux_cfg_req_write [ HQM_LSP_TARGET_CFG_RND_LOSS_COS3_L ] } )
        , .cfg_read             ( { mux_cfg_req_read [ HQM_LSP_TARGET_CFG_RND_LOSS_COS3_H ] , mux_cfg_req_read [ HQM_LSP_TARGET_CFG_RND_LOSS_COS3_L ] } )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( { mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_RND_LOSS_COS3_H ] , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_RND_LOSS_COS3_L ] } )
        , .cfg_err              ( { mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_RND_LOSS_COS3_H ] , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_RND_LOSS_COS3_L ] } )
        , .cfg_rdata            ( { mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_RND_LOSS_COS3_H * 32 +: 32 ] , mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_RND_LOSS_COS3_L * 32 +: 32 ] } )
        , .en                   ( hqm_lsp_target_cfg_rnd_loss_cos3_en )
        , .clr                  ( hqm_lsp_target_cfg_rnd_loss_cos3_clr )
        , .clrv                 ( hqm_lsp_target_cfg_rnd_loss_cos3_clrv )
        , .inc                  ( hqm_lsp_target_cfg_rnd_loss_cos3_inc )
        , .count                ( hqm_lsp_target_cfg_rnd_loss_cos3_count )
) ;
hqm_AW_inc_64b_wtcfg i_hqm_lsp_target_cfg_schd_cos0 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .cfg_write            ( { mux_cfg_req_write [ HQM_LSP_TARGET_CFG_SCHD_COS0_H ] , mux_cfg_req_write [ HQM_LSP_TARGET_CFG_SCHD_COS0_L ] } )
        , .cfg_read             ( { mux_cfg_req_read [ HQM_LSP_TARGET_CFG_SCHD_COS0_H ] , mux_cfg_req_read [ HQM_LSP_TARGET_CFG_SCHD_COS0_L ] } )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( { mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_SCHD_COS0_H ] , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_SCHD_COS0_L ] } )
        , .cfg_err              ( { mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_SCHD_COS0_H ] , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_SCHD_COS0_L ] } )
        , .cfg_rdata            ( { mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_SCHD_COS0_H * 32 +: 32 ] , mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_SCHD_COS0_L * 32 +: 32 ] } )
        , .en                   ( hqm_lsp_target_cfg_schd_cos0_en )
        , .clr                  ( hqm_lsp_target_cfg_schd_cos0_clr )
        , .clrv                 ( hqm_lsp_target_cfg_schd_cos0_clrv )
        , .inc                  ( hqm_lsp_target_cfg_schd_cos0_inc )
        , .count                ( hqm_lsp_target_cfg_schd_cos0_count )
) ;
hqm_AW_inc_64b_wtcfg i_hqm_lsp_target_cfg_schd_cos1 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .cfg_write            ( { mux_cfg_req_write [ HQM_LSP_TARGET_CFG_SCHD_COS1_H ] , mux_cfg_req_write [ HQM_LSP_TARGET_CFG_SCHD_COS1_L ] } )
        , .cfg_read             ( { mux_cfg_req_read [ HQM_LSP_TARGET_CFG_SCHD_COS1_H ] , mux_cfg_req_read [ HQM_LSP_TARGET_CFG_SCHD_COS1_L ] } )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( { mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_SCHD_COS1_H ] , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_SCHD_COS1_L ] } )
        , .cfg_err              ( { mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_SCHD_COS1_H ] , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_SCHD_COS1_L ] } )
        , .cfg_rdata            ( { mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_SCHD_COS1_H * 32 +: 32 ] , mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_SCHD_COS1_L * 32 +: 32 ] } )
        , .en                   ( hqm_lsp_target_cfg_schd_cos1_en )
        , .clr                  ( hqm_lsp_target_cfg_schd_cos1_clr )
        , .clrv                 ( hqm_lsp_target_cfg_schd_cos1_clrv )
        , .inc                  ( hqm_lsp_target_cfg_schd_cos1_inc )
        , .count                ( hqm_lsp_target_cfg_schd_cos1_count )
) ;
hqm_AW_inc_64b_wtcfg i_hqm_lsp_target_cfg_schd_cos2 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .cfg_write            ( { mux_cfg_req_write [ HQM_LSP_TARGET_CFG_SCHD_COS2_H ] , mux_cfg_req_write [ HQM_LSP_TARGET_CFG_SCHD_COS2_L ] } )
        , .cfg_read             ( { mux_cfg_req_read [ HQM_LSP_TARGET_CFG_SCHD_COS2_H ] , mux_cfg_req_read [ HQM_LSP_TARGET_CFG_SCHD_COS2_L ] } )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( { mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_SCHD_COS2_H ] , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_SCHD_COS2_L ] } )
        , .cfg_err              ( { mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_SCHD_COS2_H ] , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_SCHD_COS2_L ] } )
        , .cfg_rdata            ( { mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_SCHD_COS2_H * 32 +: 32 ] , mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_SCHD_COS2_L * 32 +: 32 ] } )
        , .en                   ( hqm_lsp_target_cfg_schd_cos2_en )
        , .clr                  ( hqm_lsp_target_cfg_schd_cos2_clr )
        , .clrv                 ( hqm_lsp_target_cfg_schd_cos2_clrv )
        , .inc                  ( hqm_lsp_target_cfg_schd_cos2_inc )
        , .count                ( hqm_lsp_target_cfg_schd_cos2_count )
) ;
hqm_AW_inc_64b_wtcfg i_hqm_lsp_target_cfg_schd_cos3 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .cfg_write            ( { mux_cfg_req_write [ HQM_LSP_TARGET_CFG_SCHD_COS3_H ] , mux_cfg_req_write [ HQM_LSP_TARGET_CFG_SCHD_COS3_L ] } )
        , .cfg_read             ( { mux_cfg_req_read [ HQM_LSP_TARGET_CFG_SCHD_COS3_H ] , mux_cfg_req_read [ HQM_LSP_TARGET_CFG_SCHD_COS3_L ] } )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( { mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_SCHD_COS3_H ] , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_SCHD_COS3_L ] } )
        , .cfg_err              ( { mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_SCHD_COS3_H ] , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_SCHD_COS3_L ] } )
        , .cfg_rdata            ( { mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_SCHD_COS3_H * 32 +: 32 ] , mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_SCHD_COS3_L * 32 +: 32 ] } )
        , .en                   ( hqm_lsp_target_cfg_schd_cos3_en )
        , .clr                  ( hqm_lsp_target_cfg_schd_cos3_clr )
        , .clrv                 ( hqm_lsp_target_cfg_schd_cos3_clrv )
        , .inc                  ( hqm_lsp_target_cfg_schd_cos3_inc )
        , .count                ( hqm_lsp_target_cfg_schd_cos3_count )
) ;
hqm_AW_inc_64b_wtcfg i_hqm_lsp_target_cfg_sch_rdy (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .cfg_write            ( { mux_cfg_req_write [ HQM_LSP_TARGET_CFG_SCH_RDY_H ] , mux_cfg_req_write [ HQM_LSP_TARGET_CFG_SCH_RDY_L ] } )
        , .cfg_read             ( { mux_cfg_req_read [ HQM_LSP_TARGET_CFG_SCH_RDY_H ] , mux_cfg_req_read [ HQM_LSP_TARGET_CFG_SCH_RDY_L ] } )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( { mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_SCH_RDY_H ] , mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_SCH_RDY_L ] } )
        , .cfg_err              ( { mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_SCH_RDY_H ] , mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_SCH_RDY_L ] } )
        , .cfg_rdata            ( { mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_SCH_RDY_H * 32 +: 32 ] , mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_SCH_RDY_L * 32 +: 32 ] } )
        , .en                   ( hqm_lsp_target_cfg_sch_rdy_en )
        , .clr                  ( hqm_lsp_target_cfg_sch_rdy_clr )
        , .clrv                 ( hqm_lsp_target_cfg_sch_rdy_clrv )
        , .inc                  ( hqm_lsp_target_cfg_sch_rdy_inc )
        , .count                ( hqm_lsp_target_cfg_sch_rdy_count )
) ;
hqm_AW_register_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( HQM_LSP_CFG_SHDW_CTRL_DEFAULT )
) i_hqm_lsp_target_cfg_shdw_ctrl (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_lsp_target_cfg_shdw_ctrl_reg_nxt )
        , .reg_f                ( hqm_lsp_target_cfg_shdw_ctrl_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_LSP_TARGET_CFG_SHDW_CTRL ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_LSP_TARGET_CFG_SHDW_CTRL ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_SHDW_CTRL ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_SHDW_CTRL ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_SHDW_CTRL * 32 +: 32 ] )
) ;
hqm_AW_register_enable_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( { 23'h0 , HQM_LSP_CFG_RANGE_COS0_DEFAULT } )
) i_hqm_lsp_target_cfg_shdw_range_cos0 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_lsp_target_cfg_shdw_range_cos0_reg_nxt )
        , .reg_f                ( hqm_lsp_target_cfg_shdw_range_cos0_reg_f )
        , .reg_v                ( hqm_lsp_target_cfg_shdw_range_cos0_reg_v )
        , .cfg_write            ( mux_cfg_req_write [ HQM_LSP_TARGET_CFG_SHDW_RANGE_COS0 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_LSP_TARGET_CFG_SHDW_RANGE_COS0 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_SHDW_RANGE_COS0 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_SHDW_RANGE_COS0 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_SHDW_RANGE_COS0 * 32 +: 32 ] )
) ;
hqm_AW_register_enable_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( { 23'h0 , HQM_LSP_CFG_RANGE_COS1_DEFAULT } )
) i_hqm_lsp_target_cfg_shdw_range_cos1 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_lsp_target_cfg_shdw_range_cos1_reg_nxt )
        , .reg_f                ( hqm_lsp_target_cfg_shdw_range_cos1_reg_f )
        , .reg_v                ( hqm_lsp_target_cfg_shdw_range_cos1_reg_v )
        , .cfg_write            ( mux_cfg_req_write [ HQM_LSP_TARGET_CFG_SHDW_RANGE_COS1 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_LSP_TARGET_CFG_SHDW_RANGE_COS1 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_SHDW_RANGE_COS1 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_SHDW_RANGE_COS1 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_SHDW_RANGE_COS1 * 32 +: 32 ] )
) ;
hqm_AW_register_enable_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( { 23'h0 , HQM_LSP_CFG_RANGE_COS2_DEFAULT } )
) i_hqm_lsp_target_cfg_shdw_range_cos2 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_lsp_target_cfg_shdw_range_cos2_reg_nxt )
        , .reg_f                ( hqm_lsp_target_cfg_shdw_range_cos2_reg_f )
        , .reg_v                ( hqm_lsp_target_cfg_shdw_range_cos2_reg_v )
        , .cfg_write            ( mux_cfg_req_write [ HQM_LSP_TARGET_CFG_SHDW_RANGE_COS2 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_LSP_TARGET_CFG_SHDW_RANGE_COS2 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_SHDW_RANGE_COS2 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_SHDW_RANGE_COS2 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_SHDW_RANGE_COS2 * 32 +: 32 ] )
) ;
hqm_AW_register_enable_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( { 23'h0 , HQM_LSP_CFG_RANGE_COS3_DEFAULT } )
) i_hqm_lsp_target_cfg_shdw_range_cos3 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_lsp_target_cfg_shdw_range_cos3_reg_nxt )
        , .reg_f                ( hqm_lsp_target_cfg_shdw_range_cos3_reg_f )
        , .reg_v                ( hqm_lsp_target_cfg_shdw_range_cos3_reg_v )
        , .cfg_write            ( mux_cfg_req_write [ HQM_LSP_TARGET_CFG_SHDW_RANGE_COS3 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_LSP_TARGET_CFG_SHDW_RANGE_COS3 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_SHDW_RANGE_COS3 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_SHDW_RANGE_COS3 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_SHDW_RANGE_COS3 * 32 +: 32 ] )
) ;
hqm_AW_smon_wtcfg #( 
          .WIDTH                       ( 24 ) 
) i_hqm_lsp_target_cfg_smon0 ( 
          .clk                         ( hqm_gated_clk )
        , .rst_n                       ( hqm_gated_rst_n )
        , .cfg_write                   ( { mux_cfg_req_write[ HQM_LSP_TARGET_CFG_SMON0_MAXIMUM_TIMER ]
                                          , mux_cfg_req_write[HQM_LSP_TARGET_CFG_SMON0_TIMER ]
                                          , mux_cfg_req_write[ HQM_LSP_TARGET_CFG_SMON0_ACTIVITYCOUNTER1 ]
                                          , mux_cfg_req_write[ HQM_LSP_TARGET_CFG_SMON0_ACTIVITYCOUNTER0 ]
                                          , mux_cfg_req_write[ HQM_LSP_TARGET_CFG_SMON0_COMPARE1 ]
                                          , mux_cfg_req_write[ HQM_LSP_TARGET_CFG_SMON0_COMPARE0 ]
                                          , mux_cfg_req_write[ HQM_LSP_TARGET_CFG_SMON0_CONFIGURATION1 ]
                                          , mux_cfg_req_write[ HQM_LSP_TARGET_CFG_SMON0_CONFIGURATION0 ]
                                          }
                                        )
        , .cfg_read                    ( { mux_cfg_req_read[ HQM_LSP_TARGET_CFG_SMON0_MAXIMUM_TIMER ]
                                          , mux_cfg_req_read[ HQM_LSP_TARGET_CFG_SMON0_TIMER ]
                                          , mux_cfg_req_read[ HQM_LSP_TARGET_CFG_SMON0_ACTIVITYCOUNTER1 ]
                                          , mux_cfg_req_read[ HQM_LSP_TARGET_CFG_SMON0_ACTIVITYCOUNTER0 ]
                                          , mux_cfg_req_read[ HQM_LSP_TARGET_CFG_SMON0_COMPARE1 ]
                                          , mux_cfg_req_read[ HQM_LSP_TARGET_CFG_SMON0_COMPARE0 ]
                                          , mux_cfg_req_read[ HQM_LSP_TARGET_CFG_SMON0_CONFIGURATION1 ]
                                          , mux_cfg_req_read[ HQM_LSP_TARGET_CFG_SMON0_CONFIGURATION0 ]
                                          }
                                        )
        , .cfg_req                     ( mux_cfg_req )
        , .cfg_ack                     ( mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_SMON0_CONFIGURATION0 * 1 +: 1 ] )
        , .cfg_err                     ( mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_SMON0_CONFIGURATION0 * 1 +: 1 ] )
        , .cfg_rdata                   ( mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_SMON0_CONFIGURATION0 * 32 +: 32 ] )
        , .disable_smon                ( hqm_lsp_target_cfg_smon0_disable_smon )
        , .in_mon_v                    ( hqm_lsp_target_cfg_smon0_smon_v )
        , .in_mon_comp                 ( hqm_lsp_target_cfg_smon0_smon_comp )
        , .in_mon_val                  ( hqm_lsp_target_cfg_smon0_smon_val )
        , .out_smon_interrupt          ( hqm_lsp_target_cfg_smon0_smon_interrupt )
        , .out_smon_enabled            ( hqm_lsp_target_cfg_smon0_smon_enabled )
) ;
assign mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_SMON0_CONFIGURATION1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_SMON0_CONFIGURATION1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_SMON0_CONFIGURATION1 * 32 +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_SMON0_COMPARE0 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_SMON0_COMPARE0 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_SMON0_COMPARE0 * 32 +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_SMON0_COMPARE1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_SMON0_COMPARE1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_SMON0_COMPARE1 * 32 +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_SMON0_ACTIVITYCOUNTER0 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_SMON0_ACTIVITYCOUNTER0 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_SMON0_ACTIVITYCOUNTER0 * 32 +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_SMON0_ACTIVITYCOUNTER1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_SMON0_ACTIVITYCOUNTER1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_SMON0_ACTIVITYCOUNTER1 * 32 +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_SMON0_TIMER ] = '0 ;
assign mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_SMON0_TIMER ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_SMON0_TIMER * 32 +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_SMON0_MAXIMUM_TIMER ] = '0 ;
assign mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_SMON0_MAXIMUM_TIMER ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_SMON0_MAXIMUM_TIMER * 32 +: 32 ] = '0 ;
hqm_AW_syndrome_wtcfg i_hqm_lsp_target_cfg_syndrome_hw (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .cfg_write            ( mux_cfg_req_write [ HQM_LSP_TARGET_CFG_SYNDROME_HW ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_LSP_TARGET_CFG_SYNDROME_HW ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_SYNDROME_HW ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_SYNDROME_HW ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_SYNDROME_HW * 32 +: 32 ] )
        , .capture_v            ( hqm_lsp_target_cfg_syndrome_hw_capture_v )
        , .capture_data         ( hqm_lsp_target_cfg_syndrome_hw_capture_data )
        , .syndrome_data        ( hqm_lsp_target_cfg_syndrome_hw_syndrome_data )
) ;
hqm_AW_syndrome_wtcfg i_hqm_lsp_target_cfg_syndrome_sw (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .cfg_write            ( mux_cfg_req_write [ HQM_LSP_TARGET_CFG_SYNDROME_SW ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_LSP_TARGET_CFG_SYNDROME_SW ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_SYNDROME_SW ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_SYNDROME_SW ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_SYNDROME_SW * 32 +: 32 ] )
        , .capture_v            ( hqm_lsp_target_cfg_syndrome_sw_capture_v )
        , .capture_data         ( hqm_lsp_target_cfg_syndrome_sw_capture_data )
        , .syndrome_data        ( hqm_lsp_target_cfg_syndrome_sw_syndrome_data )
) ;
hqm_AW_register_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h00000003 )
) i_hqm_lsp_target_cfg_unit_idle (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_lsp_target_cfg_unit_idle_reg_nxt )
        , .reg_f                ( hqm_lsp_target_cfg_unit_idle_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_LSP_TARGET_CFG_UNIT_IDLE ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_LSP_TARGET_CFG_UNIT_IDLE ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_UNIT_IDLE ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_UNIT_IDLE ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_UNIT_IDLE * 32 +: 32 ] )
) ;
hqm_AW_register_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( HQM_UNIT_TIMEOUT_DEFAULT )
) i_hqm_lsp_target_cfg_unit_timeout (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_lsp_target_cfg_unit_timeout_reg_nxt )
        , .reg_f                ( hqm_lsp_target_cfg_unit_timeout_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_LSP_TARGET_CFG_UNIT_TIMEOUT ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_LSP_TARGET_CFG_UNIT_TIMEOUT ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_UNIT_TIMEOUT ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_UNIT_TIMEOUT ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_UNIT_TIMEOUT * 32 +: 32 ] )
) ;
hqm_AW_status_wtcfg i_hqm_lsp_target_cfg_unit_version (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .status               ( hqm_lsp_target_cfg_unit_version_status )
        , .cfg_write            ( mux_cfg_req_write [ HQM_LSP_TARGET_CFG_UNIT_VERSION ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_LSP_TARGET_CFG_UNIT_VERSION ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_LSP_TARGET_CFG_UNIT_VERSION ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_LSP_TARGET_CFG_UNIT_VERSION ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_LSP_TARGET_CFG_UNIT_VERSION * 32 +: 32 ] )
) ;
assign mux_cfg_rsp_ack_pnc [ (HQM_LSP_TARGET_CFG_ATM_QID_DPTH_THRSH * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_LSP_TARGET_CFG_ATM_QID_DPTH_THRSH * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_LSP_TARGET_CFG_ATM_QID_DPTH_THRSH * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_LSP_TARGET_CFG_CQ2PRIOV * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_LSP_TARGET_CFG_CQ2PRIOV * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_LSP_TARGET_CFG_CQ2PRIOV * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_LSP_TARGET_CFG_CQ2QID0 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_LSP_TARGET_CFG_CQ2QID0 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_LSP_TARGET_CFG_CQ2QID0 * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_LSP_TARGET_CFG_CQ2QID1 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_LSP_TARGET_CFG_CQ2QID1 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_LSP_TARGET_CFG_CQ2QID1 * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_LSP_TARGET_CFG_CQ_DIR_TOKEN_COUNT * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_LSP_TARGET_CFG_CQ_DIR_TOKEN_COUNT * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_LSP_TARGET_CFG_CQ_DIR_TOKEN_COUNT * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_LSP_TARGET_CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_LSP_TARGET_CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_LSP_TARGET_CFG_CQ_DIR_TOKEN_DEPTH_SELECT_DSI * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_LSP_TARGET_CFG_CQ_DIR_TOT_SCH_CNTH * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_LSP_TARGET_CFG_CQ_DIR_TOT_SCH_CNTH * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_LSP_TARGET_CFG_CQ_DIR_TOT_SCH_CNTH * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_LSP_TARGET_CFG_CQ_DIR_TOT_SCH_CNTL * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_LSP_TARGET_CFG_CQ_DIR_TOT_SCH_CNTL * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_LSP_TARGET_CFG_CQ_DIR_TOT_SCH_CNTL * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_LSP_TARGET_CFG_CQ_LDB_INFLIGHT_COUNT * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_LSP_TARGET_CFG_CQ_LDB_INFLIGHT_COUNT * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_LSP_TARGET_CFG_CQ_LDB_INFLIGHT_COUNT * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_LSP_TARGET_CFG_CQ_LDB_INFLIGHT_LIMIT * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_LSP_TARGET_CFG_CQ_LDB_INFLIGHT_LIMIT * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_LSP_TARGET_CFG_CQ_LDB_INFLIGHT_LIMIT * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_LSP_TARGET_CFG_CQ_LDB_INFLIGHT_THRESHOLD * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_LSP_TARGET_CFG_CQ_LDB_INFLIGHT_THRESHOLD * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_LSP_TARGET_CFG_CQ_LDB_INFLIGHT_THRESHOLD * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_LSP_TARGET_CFG_CQ_LDB_TOKEN_COUNT * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_LSP_TARGET_CFG_CQ_LDB_TOKEN_COUNT * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_LSP_TARGET_CFG_CQ_LDB_TOKEN_COUNT * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_LSP_TARGET_CFG_CQ_LDB_TOKEN_DEPTH_SELECT * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_LSP_TARGET_CFG_CQ_LDB_TOKEN_DEPTH_SELECT * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_LSP_TARGET_CFG_CQ_LDB_TOKEN_DEPTH_SELECT * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_LSP_TARGET_CFG_CQ_LDB_TOT_SCH_CNTH * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_LSP_TARGET_CFG_CQ_LDB_TOT_SCH_CNTH * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_LSP_TARGET_CFG_CQ_LDB_TOT_SCH_CNTH * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_LSP_TARGET_CFG_CQ_LDB_TOT_SCH_CNTL * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_LSP_TARGET_CFG_CQ_LDB_TOT_SCH_CNTL * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_LSP_TARGET_CFG_CQ_LDB_TOT_SCH_CNTL * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_LSP_TARGET_CFG_CQ_LDB_WU_COUNT * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_LSP_TARGET_CFG_CQ_LDB_WU_COUNT * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_LSP_TARGET_CFG_CQ_LDB_WU_COUNT * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_LSP_TARGET_CFG_CQ_LDB_WU_LIMIT * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_LSP_TARGET_CFG_CQ_LDB_WU_LIMIT * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_LSP_TARGET_CFG_CQ_LDB_WU_LIMIT * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_LSP_TARGET_CFG_DIR_QID_DPTH_THRSH * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_LSP_TARGET_CFG_DIR_QID_DPTH_THRSH * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_LSP_TARGET_CFG_DIR_QID_DPTH_THRSH * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_LSP_TARGET_CFG_NALB_QID_DPTH_THRSH * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_LSP_TARGET_CFG_NALB_QID_DPTH_THRSH * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_LSP_TARGET_CFG_NALB_QID_DPTH_THRSH * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_LSP_TARGET_CFG_QID_AQED_ACTIVE_COUNT * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_LSP_TARGET_CFG_QID_AQED_ACTIVE_COUNT * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_LSP_TARGET_CFG_QID_AQED_ACTIVE_COUNT * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_LSP_TARGET_CFG_QID_AQED_ACTIVE_LIMIT * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_LSP_TARGET_CFG_QID_AQED_ACTIVE_LIMIT * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_LSP_TARGET_CFG_QID_AQED_ACTIVE_LIMIT * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_LSP_TARGET_CFG_QID_ATM_ACTIVE * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_LSP_TARGET_CFG_QID_ATM_ACTIVE * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_LSP_TARGET_CFG_QID_ATM_ACTIVE * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_LSP_TARGET_CFG_QID_ATM_TOT_ENQ_CNTH * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_LSP_TARGET_CFG_QID_ATM_TOT_ENQ_CNTH * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_LSP_TARGET_CFG_QID_ATM_TOT_ENQ_CNTH * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_LSP_TARGET_CFG_QID_ATM_TOT_ENQ_CNTL * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_LSP_TARGET_CFG_QID_ATM_TOT_ENQ_CNTL * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_LSP_TARGET_CFG_QID_ATM_TOT_ENQ_CNTL * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_LSP_TARGET_CFG_QID_ATQ_ENQUEUE_COUNT * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_LSP_TARGET_CFG_QID_ATQ_ENQUEUE_COUNT * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_LSP_TARGET_CFG_QID_ATQ_ENQUEUE_COUNT * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_LSP_TARGET_CFG_QID_DIR_ENQUEUE_COUNT * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_LSP_TARGET_CFG_QID_DIR_ENQUEUE_COUNT * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_LSP_TARGET_CFG_QID_DIR_ENQUEUE_COUNT * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_LSP_TARGET_CFG_QID_DIR_MAX_DEPTH * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_LSP_TARGET_CFG_QID_DIR_MAX_DEPTH * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_LSP_TARGET_CFG_QID_DIR_MAX_DEPTH * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_LSP_TARGET_CFG_QID_DIR_REPLAY_COUNT * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_LSP_TARGET_CFG_QID_DIR_REPLAY_COUNT * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_LSP_TARGET_CFG_QID_DIR_REPLAY_COUNT * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_LSP_TARGET_CFG_QID_DIR_TOT_ENQ_CNTH * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_LSP_TARGET_CFG_QID_DIR_TOT_ENQ_CNTH * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_LSP_TARGET_CFG_QID_DIR_TOT_ENQ_CNTH * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_LSP_TARGET_CFG_QID_DIR_TOT_ENQ_CNTL * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_LSP_TARGET_CFG_QID_DIR_TOT_ENQ_CNTL * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_LSP_TARGET_CFG_QID_DIR_TOT_ENQ_CNTL * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_ENQUEUE_COUNT * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_ENQUEUE_COUNT * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_ENQUEUE_COUNT * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_INFLIGHT_COUNT * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_INFLIGHT_COUNT * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_INFLIGHT_COUNT * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_INFLIGHT_LIMIT * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_INFLIGHT_LIMIT * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_INFLIGHT_LIMIT * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_00 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_00 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_00 * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_01 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_01 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_01 * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_02 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_02 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_02 * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_03 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_03 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_03 * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_04 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_04 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_04 * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_05 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_05 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_05 * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_06 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_06 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_06 * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_07 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_07 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_07 * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_08 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_08 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_08 * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_09 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_09 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_09 * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_10 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_10 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_10 * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_11 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_11 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_11 * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_12 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_12 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_12 * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_13 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_13 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_13 * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_14 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_14 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_14 * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_15 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_15 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX2_15 * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_00 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_00 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_00 * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_01 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_01 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_01 * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_02 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_02 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_02 * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_03 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_03 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_03 * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_04 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_04 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_04 * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_05 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_05 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_05 * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_06 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_06 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_06 * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_07 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_07 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_07 * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_08 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_08 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_08 * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_09 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_09 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_09 * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_10 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_10 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_10 * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_11 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_11 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_11 * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_12 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_12 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_12 * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_13 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_13 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_13 * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_14 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_14 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_14 * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_15 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_15 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_QID2CQIDIX_15 * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_REPLAY_COUNT * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_REPLAY_COUNT * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_LSP_TARGET_CFG_QID_LDB_REPLAY_COUNT * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_LSP_TARGET_CFG_QID_NALDB_MAX_DEPTH * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_LSP_TARGET_CFG_QID_NALDB_MAX_DEPTH * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_LSP_TARGET_CFG_QID_NALDB_MAX_DEPTH * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_LSP_TARGET_CFG_QID_NALDB_TOT_ENQ_CNTH * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_LSP_TARGET_CFG_QID_NALDB_TOT_ENQ_CNTH * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_LSP_TARGET_CFG_QID_NALDB_TOT_ENQ_CNTH * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_LSP_TARGET_CFG_QID_NALDB_TOT_ENQ_CNTL * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_LSP_TARGET_CFG_QID_NALDB_TOT_ENQ_CNTL * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_LSP_TARGET_CFG_QID_NALDB_TOT_ENQ_CNTL * 32 ) +: 32 ] = '0 ;
endmodule
