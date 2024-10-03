module hqm_credit_hist_pipe_register_pfcsr
import hqm_AW_pkg::* , hqm_pkg::* , hqm_core_pkg::* ;
(
  input logic hqm_gated_clk
, input logic hqm_gated_rst_n
, input logic rst_prep 
, input logic [ ( HQM_CHP_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] cfg_req_write 
, input logic [ ( HQM_CHP_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] cfg_req_read 
, input cfg_req_t cfg_req 
, output logic cfg_rsp_ack 
, output logic cfg_rsp_err 
, output logic [ ( 32 ) - 1 : 0 ] cfg_rsp_rdata 
, input logic hqm_chp_target_cfg_chp_cnt_atm_qe_sch_en
, input logic hqm_chp_target_cfg_chp_cnt_atm_qe_sch_clr
, input logic hqm_chp_target_cfg_chp_cnt_atm_qe_sch_clrv
, input logic hqm_chp_target_cfg_chp_cnt_atm_qe_sch_inc
, output logic [ ( 64 ) - 1 : 0] hqm_chp_target_cfg_chp_cnt_atm_qe_sch_count
, input logic hqm_chp_target_cfg_chp_cnt_atq_to_atm_en
, input logic hqm_chp_target_cfg_chp_cnt_atq_to_atm_clr
, input logic hqm_chp_target_cfg_chp_cnt_atq_to_atm_clrv
, input logic hqm_chp_target_cfg_chp_cnt_atq_to_atm_inc
, output logic [ ( 64 ) - 1 : 0] hqm_chp_target_cfg_chp_cnt_atq_to_atm_count
, input logic hqm_chp_target_cfg_chp_cnt_dir_hcw_enq_en
, input logic hqm_chp_target_cfg_chp_cnt_dir_hcw_enq_clr
, input logic hqm_chp_target_cfg_chp_cnt_dir_hcw_enq_clrv
, input logic hqm_chp_target_cfg_chp_cnt_dir_hcw_enq_inc
, output logic [ ( 64 ) - 1 : 0] hqm_chp_target_cfg_chp_cnt_dir_hcw_enq_count
, input logic hqm_chp_target_cfg_chp_cnt_dir_qe_sch_en
, input logic hqm_chp_target_cfg_chp_cnt_dir_qe_sch_clr
, input logic hqm_chp_target_cfg_chp_cnt_dir_qe_sch_clrv
, input logic hqm_chp_target_cfg_chp_cnt_dir_qe_sch_inc
, output logic [ ( 64 ) - 1 : 0] hqm_chp_target_cfg_chp_cnt_dir_qe_sch_count
, input logic hqm_chp_target_cfg_chp_cnt_frag_replayed_en
, input logic hqm_chp_target_cfg_chp_cnt_frag_replayed_clr
, input logic hqm_chp_target_cfg_chp_cnt_frag_replayed_clrv
, input logic hqm_chp_target_cfg_chp_cnt_frag_replayed_inc
, output logic [ ( 64 ) - 1 : 0] hqm_chp_target_cfg_chp_cnt_frag_replayed_count
, input logic hqm_chp_target_cfg_chp_cnt_ldb_hcw_enq_en
, input logic hqm_chp_target_cfg_chp_cnt_ldb_hcw_enq_clr
, input logic hqm_chp_target_cfg_chp_cnt_ldb_hcw_enq_clrv
, input logic hqm_chp_target_cfg_chp_cnt_ldb_hcw_enq_inc
, output logic [ ( 64 ) - 1 : 0] hqm_chp_target_cfg_chp_cnt_ldb_hcw_enq_count
, input logic hqm_chp_target_cfg_chp_cnt_ldb_qe_sch_en
, input logic hqm_chp_target_cfg_chp_cnt_ldb_qe_sch_clr
, input logic hqm_chp_target_cfg_chp_cnt_ldb_qe_sch_clrv
, input logic hqm_chp_target_cfg_chp_cnt_ldb_qe_sch_inc
, output logic [ ( 64 ) - 1 : 0] hqm_chp_target_cfg_chp_cnt_ldb_qe_sch_count
, input logic hqm_chp_target_cfg_chp_correctible_count_en
, input logic hqm_chp_target_cfg_chp_correctible_count_clr
, input logic hqm_chp_target_cfg_chp_correctible_count_clrv
, input logic hqm_chp_target_cfg_chp_correctible_count_inc
, output logic [ ( 64 ) - 1 : 0] hqm_chp_target_cfg_chp_correctible_count_count
, input logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_chp_csr_control_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_chp_csr_control_reg_f
, input logic hqm_chp_target_cfg_chp_csr_control_reg_v
, input logic hqm_chp_target_cfg_chp_frag_count_reg_load
, input logic [ ( 1 * 7 * 64 ) - 1 : 0] hqm_chp_target_cfg_chp_frag_count_reg_nxt
, output logic [ ( 1 * 7 * 64 ) - 1 : 0] hqm_chp_target_cfg_chp_frag_count_reg_f
, input logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_chp_palb_control_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_chp_palb_control_reg_f
, input logic hqm_chp_target_cfg_chp_palb_control_reg_v
, input logic hqm_chp_target_cfg_chp_smon_disable_smon
, input logic [ 16 - 1 : 0 ] hqm_chp_target_cfg_chp_smon_smon_v
, input logic [ ( 16 * 32 ) - 1 : 0 ] hqm_chp_target_cfg_chp_smon_smon_comp
, input logic [ ( 16 * 32 ) - 1 : 0 ] hqm_chp_target_cfg_chp_smon_smon_val
, output logic hqm_chp_target_cfg_chp_smon_smon_enabled
, output logic hqm_chp_target_cfg_chp_smon_smon_interrupt
, input logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_control_diagnostic_00_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_control_diagnostic_00_reg_f
, input logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_control_diagnostic_01_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_control_diagnostic_01_reg_f
, input logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_control_diagnostic_02_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_control_diagnostic_02_reg_f
, input logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_control_general_00_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_control_general_00_reg_f
, input logic hqm_chp_target_cfg_control_general_00_reg_v
, input logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_control_general_01_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_control_general_01_reg_f
, input logic hqm_chp_target_cfg_control_general_01_reg_v
, input logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_control_general_02_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_control_general_02_reg_f
, input logic hqm_chp_target_cfg_control_general_02_reg_v
, input logic hqm_chp_target_cfg_counter_chp_error_drop_en
, input logic hqm_chp_target_cfg_counter_chp_error_drop_clr
, input logic hqm_chp_target_cfg_counter_chp_error_drop_clrv
, input logic hqm_chp_target_cfg_counter_chp_error_drop_inc
, output logic [ ( 64 ) - 1 : 0] hqm_chp_target_cfg_counter_chp_error_drop_count
, input logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_db_fifo_status_0_status
, input logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_db_fifo_status_1_status
, input logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_db_fifo_status_2_status
, input logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_db_fifo_status_3_status
, input logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_diagnostic_aw_status_0_status
, input logic hqm_chp_target_cfg_dir_cq2vas_reg_load
, input logic [ ( 1 * 6 * 64 ) - 1 : 0] hqm_chp_target_cfg_dir_cq2vas_reg_nxt
, output logic [ ( 1 * 6 * 64 ) - 1 : 0] hqm_chp_target_cfg_dir_cq2vas_reg_f
, input logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_dir_cq_intr_armed0_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_dir_cq_intr_armed0_reg_f
, input logic hqm_chp_target_cfg_dir_cq_intr_armed0_reg_v
, input logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_dir_cq_intr_armed1_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_dir_cq_intr_armed1_reg_f
, input logic hqm_chp_target_cfg_dir_cq_intr_armed1_reg_v
, input logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_dir_cq_intr_expired0_status
, input logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_dir_cq_intr_expired1_status
, input logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_dir_cq_intr_irq0_status
, input logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_dir_cq_intr_irq1_status
, input logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_dir_cq_intr_run_timer0_status
, input logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_dir_cq_intr_run_timer1_status
, input logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_dir_cq_intr_urgent0_status
, input logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_dir_cq_intr_urgent1_status
, input logic hqm_chp_target_cfg_dir_cq_int_enb_reg_load
, input logic [ ( 1 * 2 * 64 ) - 1 : 0] hqm_chp_target_cfg_dir_cq_int_enb_reg_nxt
, output logic [ ( 1 * 2 * 64 ) - 1 : 0] hqm_chp_target_cfg_dir_cq_int_enb_reg_f
, input logic hqm_chp_target_cfg_dir_cq_int_mask_reg_load
, input logic [ ( 1 * 1 * 64 ) - 1 : 0] hqm_chp_target_cfg_dir_cq_int_mask_reg_nxt
, output logic [ ( 1 * 1 * 64 ) - 1 : 0] hqm_chp_target_cfg_dir_cq_int_mask_reg_f
, input logic hqm_chp_target_cfg_dir_cq_irq_pending_reg_load
, input logic [ ( 1 * 1 * 64 ) - 1 : 0] hqm_chp_target_cfg_dir_cq_irq_pending_reg_nxt
, output logic [ ( 1 * 1 * 64 ) - 1 : 0] hqm_chp_target_cfg_dir_cq_irq_pending_reg_f
, input logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_dir_cq_timer_ctl_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_dir_cq_timer_ctl_reg_f
, input logic hqm_chp_target_cfg_dir_cq_timer_ctl_reg_v
, input logic hqm_chp_target_cfg_dir_cq_wd_enb_reg_load
, input logic [ ( 1 * 1 * 64 ) - 1 : 0] hqm_chp_target_cfg_dir_cq_wd_enb_reg_nxt
, output logic [ ( 1 * 1 * 64 ) - 1 : 0] hqm_chp_target_cfg_dir_cq_wd_enb_reg_f
, input logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_dir_wdrt_0_status
, input logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_dir_wdrt_1_status
, input logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_dir_wdto_0_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_dir_wdto_0_reg_f
, input logic hqm_chp_target_cfg_dir_wdto_0_reg_load
, input logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_dir_wdto_1_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_dir_wdto_1_reg_f
, input logic hqm_chp_target_cfg_dir_wdto_1_reg_load
, input logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_dir_wd_disable0_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_dir_wd_disable0_reg_f
, input logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_dir_wd_disable1_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_dir_wd_disable1_reg_f
, input logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_dir_wd_enb_interval_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_dir_wd_enb_interval_reg_f
, input logic hqm_chp_target_cfg_dir_wd_enb_interval_reg_v
, input logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_dir_wd_irq0_status
, input logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_dir_wd_irq1_status
, input logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_dir_wd_threshold_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_dir_wd_threshold_reg_f
, input logic hqm_chp_target_cfg_dir_wd_threshold_reg_v
, input logic hqm_chp_target_cfg_hist_list_mode_reg_load
, input logic [ ( 1 * 1 * 64 ) - 1 : 0] hqm_chp_target_cfg_hist_list_mode_reg_nxt
, output logic [ ( 1 * 1 * 64 ) - 1 : 0] hqm_chp_target_cfg_hist_list_mode_reg_f
, input logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_hw_agitate_control_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_hw_agitate_control_reg_f
, input logic hqm_chp_target_cfg_hw_agitate_control_reg_v
, input logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_hw_agitate_select_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_hw_agitate_select_reg_f
, input logic hqm_chp_target_cfg_hw_agitate_select_reg_v
, input logic hqm_chp_target_cfg_ldb_cq2vas_reg_load
, input logic [ ( 1 * 6 * 64 ) - 1 : 0] hqm_chp_target_cfg_ldb_cq2vas_reg_nxt
, output logic [ ( 1 * 6 * 64 ) - 1 : 0] hqm_chp_target_cfg_ldb_cq2vas_reg_f
, input logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_ldb_cq_intr_armed0_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_ldb_cq_intr_armed0_reg_f
, input logic hqm_chp_target_cfg_ldb_cq_intr_armed0_reg_v
, input logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_ldb_cq_intr_armed1_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_ldb_cq_intr_armed1_reg_f
, input logic hqm_chp_target_cfg_ldb_cq_intr_armed1_reg_v
, input logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_ldb_cq_intr_expired0_status
, input logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_ldb_cq_intr_expired1_status
, input logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_ldb_cq_intr_irq0_status
, input logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_ldb_cq_intr_irq1_status
, input logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_ldb_cq_intr_run_timer0_status
, input logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_ldb_cq_intr_run_timer1_status
, input logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_ldb_cq_intr_urgent0_status
, input logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_ldb_cq_intr_urgent1_status
, input logic hqm_chp_target_cfg_ldb_cq_int_enb_reg_load
, input logic [ ( 1 * 2 * 64 ) - 1 : 0] hqm_chp_target_cfg_ldb_cq_int_enb_reg_nxt
, output logic [ ( 1 * 2 * 64 ) - 1 : 0] hqm_chp_target_cfg_ldb_cq_int_enb_reg_f
, input logic hqm_chp_target_cfg_ldb_cq_int_mask_reg_load
, input logic [ ( 1 * 1 * 64 ) - 1 : 0] hqm_chp_target_cfg_ldb_cq_int_mask_reg_nxt
, output logic [ ( 1 * 1 * 64 ) - 1 : 0] hqm_chp_target_cfg_ldb_cq_int_mask_reg_f
, input logic hqm_chp_target_cfg_ldb_cq_irq_pending_reg_load
, input logic [ ( 1 * 1 * 64 ) - 1 : 0] hqm_chp_target_cfg_ldb_cq_irq_pending_reg_nxt
, output logic [ ( 1 * 1 * 64 ) - 1 : 0] hqm_chp_target_cfg_ldb_cq_irq_pending_reg_f
, input logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_ldb_cq_timer_ctl_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_ldb_cq_timer_ctl_reg_f
, input logic hqm_chp_target_cfg_ldb_cq_timer_ctl_reg_v
, input logic hqm_chp_target_cfg_ldb_cq_wd_enb_reg_load
, input logic [ ( 1 * 1 * 64 ) - 1 : 0] hqm_chp_target_cfg_ldb_cq_wd_enb_reg_nxt
, output logic [ ( 1 * 1 * 64 ) - 1 : 0] hqm_chp_target_cfg_ldb_cq_wd_enb_reg_f
, input logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_ldb_wdrt_0_status
, input logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_ldb_wdrt_1_status
, input logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_ldb_wdto_0_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_ldb_wdto_0_reg_f
, input logic hqm_chp_target_cfg_ldb_wdto_0_reg_load
, input logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_ldb_wdto_1_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_ldb_wdto_1_reg_f
, input logic hqm_chp_target_cfg_ldb_wdto_1_reg_load
, input logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_ldb_wd_disable0_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_ldb_wd_disable0_reg_f
, input logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_ldb_wd_disable1_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_ldb_wd_disable1_reg_f
, input logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_ldb_wd_enb_interval_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_ldb_wd_enb_interval_reg_f
, input logic hqm_chp_target_cfg_ldb_wd_enb_interval_reg_v
, input logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_ldb_wd_irq0_status
, input logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_ldb_wd_irq1_status
, input logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_ldb_wd_threshold_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_ldb_wd_threshold_reg_f
, input logic hqm_chp_target_cfg_ldb_wd_threshold_reg_v
, input logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_patch_control_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_patch_control_reg_f
, input logic hqm_chp_target_cfg_patch_control_reg_v
, input logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_pipe_health_hold_status
, input logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_pipe_health_valid_status
, input logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_retn_zero_status
, input logic hqm_chp_target_cfg_syndrome_00_capture_v
, input logic [ ( 31 ) - 1 : 0] hqm_chp_target_cfg_syndrome_00_capture_data
, output logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_syndrome_00_syndrome_data
, input logic hqm_chp_target_cfg_syndrome_01_capture_v
, input logic [ ( 31 ) - 1 : 0] hqm_chp_target_cfg_syndrome_01_capture_data
, output logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_syndrome_01_syndrome_data
, input logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_unit_idle_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_unit_idle_reg_f
, input logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_unit_timeout_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_unit_timeout_reg_f
, input logic [ ( 32 ) - 1 : 0] hqm_chp_target_cfg_unit_version_status
, input logic hqm_chp_target_cfg_vas_credit_count_reg_load
, input logic [ ( 1 * 17 * 32 ) - 1 : 0] hqm_chp_target_cfg_vas_credit_count_reg_nxt
, output logic [ ( 1 * 17 * 32 ) - 1 : 0] hqm_chp_target_cfg_vas_credit_count_reg_f
);
logic [ ( HQM_CHP_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] mux_cfg_req_write ;
logic [ ( HQM_CHP_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] mux_cfg_req_read ;
cfg_req_t mux_cfg_req ;
logic [ ( HQM_CHP_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] mux_cfg_rsp_ack_pnc ;
logic [ ( HQM_CHP_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] mux_cfg_rsp_err_pnc ;
logic [ ( HQM_CHP_CFG_UNIT_NUM_TGTS * 32 ) - 1 : 0 ] mux_cfg_rsp_rdata_pnc ;
always_comb begin
  mux_cfg_req_write = cfg_req_write ;
  mux_cfg_req_read = cfg_req_read ;
  mux_cfg_req = cfg_req ;
end
hqm_AW_cfg_rsp #(
    .NUM_TGTS ( 105 )
) i_hqm_AW_cfg_rsp_0 (
    .clk ( hqm_gated_clk )
  , .rst_n ( hqm_gated_rst_n )
  , .in_cfg_rsp_ack ( {
                        mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_CHP_CNT_ATM_QE_SCH_H ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_CHP_CNT_ATM_QE_SCH_L ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_CHP_CNT_ATQ_TO_ATM_H ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_CHP_CNT_ATQ_TO_ATM_L ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_CHP_CNT_DIR_HCW_ENQ_H ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_CHP_CNT_DIR_HCW_ENQ_L ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_CHP_CNT_DIR_QE_SCH_H ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_CHP_CNT_DIR_QE_SCH_L ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_CHP_CNT_FRAG_REPLAYED_H ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_CHP_CNT_FRAG_REPLAYED_L ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_CHP_CNT_LDB_HCW_ENQ_H ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_CHP_CNT_LDB_HCW_ENQ_L ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_CHP_CNT_LDB_QE_SCH_H ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_CHP_CNT_LDB_QE_SCH_L ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_CHP_CORRECTIBLE_COUNT_H ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_CHP_CORRECTIBLE_COUNT_L ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_CHP_CSR_CONTROL ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_CHP_FRAG_COUNT ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_CHP_PALB_CONTROL ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_CHP_SMON_ACTIVITYCOUNTER0 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_CHP_SMON_ACTIVITYCOUNTER1 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_CHP_SMON_COMPARE0 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_CHP_SMON_COMPARE1 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_CHP_SMON_CONFIGURATION0 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_CHP_SMON_CONFIGURATION1 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_CHP_SMON_MAXIMUM_TIMER ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_CHP_SMON_TIMER ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_CONTROL_DIAGNOSTIC_00 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_CONTROL_DIAGNOSTIC_01 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_CONTROL_DIAGNOSTIC_02 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_CONTROL_GENERAL_00 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_CONTROL_GENERAL_01 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_CONTROL_GENERAL_02 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_COUNTER_CHP_ERROR_DROP_H ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_COUNTER_CHP_ERROR_DROP_L ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_DB_FIFO_STATUS_0 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_DB_FIFO_STATUS_1 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_DB_FIFO_STATUS_2 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_DB_FIFO_STATUS_3 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_DIAGNOSTIC_AW_STATUS_0 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ2VAS ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ_INTR_ARMED0 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ_INTR_ARMED1 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ_INTR_EXPIRED0 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ_INTR_EXPIRED1 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ_INTR_IRQ0 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ_INTR_IRQ1 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ_INTR_RUN_TIMER0 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ_INTR_RUN_TIMER1 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ_INTR_URGENT0 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ_INTR_URGENT1 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ_INT_ENB ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ_INT_MASK ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ_IRQ_PENDING ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ_TIMER_CTL ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ_WD_ENB ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_DIR_WDRT_0 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_DIR_WDRT_1 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_DIR_WDTO_0 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_DIR_WDTO_1 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_DIR_WD_DISABLE0 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_DIR_WD_DISABLE1 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_DIR_WD_ENB_INTERVAL ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_DIR_WD_IRQ0 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_DIR_WD_IRQ1 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_DIR_WD_THRESHOLD ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_HIST_LIST_MODE ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_HW_AGITATE_CONTROL ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_HW_AGITATE_SELECT ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ2VAS ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ_INTR_ARMED0 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ_INTR_ARMED1 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ_INTR_EXPIRED0 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ_INTR_EXPIRED1 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ_INTR_IRQ0 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ_INTR_IRQ1 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ_INTR_RUN_TIMER0 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ_INTR_RUN_TIMER1 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ_INTR_URGENT0 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ_INTR_URGENT1 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ_INT_ENB ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ_INT_MASK ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ_IRQ_PENDING ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ_TIMER_CTL ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ_WD_ENB ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_LDB_WDRT_0 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_LDB_WDRT_1 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_LDB_WDTO_0 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_LDB_WDTO_1 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_LDB_WD_DISABLE0 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_LDB_WD_DISABLE1 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_LDB_WD_ENB_INTERVAL ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_LDB_WD_IRQ0 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_LDB_WD_IRQ1 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_LDB_WD_THRESHOLD ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_PATCH_CONTROL ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_PIPE_HEALTH_HOLD ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_PIPE_HEALTH_VALID ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_RETN_ZERO ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_SYNDROME_00 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_SYNDROME_01 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_UNIT_IDLE ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_UNIT_TIMEOUT ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_UNIT_VERSION ]
                      , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_VAS_CREDIT_COUNT ]
                      } )
  , .in_cfg_rsp_err ( {
                        mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_CHP_CNT_ATM_QE_SCH_H ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_CHP_CNT_ATM_QE_SCH_L ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_CHP_CNT_ATQ_TO_ATM_H ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_CHP_CNT_ATQ_TO_ATM_L ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_CHP_CNT_DIR_HCW_ENQ_H ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_CHP_CNT_DIR_HCW_ENQ_L ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_CHP_CNT_DIR_QE_SCH_H ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_CHP_CNT_DIR_QE_SCH_L ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_CHP_CNT_FRAG_REPLAYED_H ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_CHP_CNT_FRAG_REPLAYED_L ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_CHP_CNT_LDB_HCW_ENQ_H ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_CHP_CNT_LDB_HCW_ENQ_L ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_CHP_CNT_LDB_QE_SCH_H ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_CHP_CNT_LDB_QE_SCH_L ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_CHP_CORRECTIBLE_COUNT_H ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_CHP_CORRECTIBLE_COUNT_L ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_CHP_CSR_CONTROL ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_CHP_FRAG_COUNT ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_CHP_PALB_CONTROL ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_CHP_SMON_ACTIVITYCOUNTER0 ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_CHP_SMON_ACTIVITYCOUNTER1 ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_CHP_SMON_COMPARE0 ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_CHP_SMON_COMPARE1 ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_CHP_SMON_CONFIGURATION0 ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_CHP_SMON_CONFIGURATION1 ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_CHP_SMON_MAXIMUM_TIMER ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_CHP_SMON_TIMER ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_CONTROL_DIAGNOSTIC_00 ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_CONTROL_DIAGNOSTIC_01 ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_CONTROL_DIAGNOSTIC_02 ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_CONTROL_GENERAL_00 ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_CONTROL_GENERAL_01 ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_CONTROL_GENERAL_02 ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_COUNTER_CHP_ERROR_DROP_H ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_COUNTER_CHP_ERROR_DROP_L ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_DB_FIFO_STATUS_0 ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_DB_FIFO_STATUS_1 ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_DB_FIFO_STATUS_2 ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_DB_FIFO_STATUS_3 ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_DIAGNOSTIC_AW_STATUS_0 ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ2VAS ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ_INTR_ARMED0 ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ_INTR_ARMED1 ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ_INTR_EXPIRED0 ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ_INTR_EXPIRED1 ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ_INTR_IRQ0 ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ_INTR_IRQ1 ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ_INTR_RUN_TIMER0 ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ_INTR_RUN_TIMER1 ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ_INTR_URGENT0 ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ_INTR_URGENT1 ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ_INT_ENB ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ_INT_MASK ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ_IRQ_PENDING ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ_TIMER_CTL ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ_WD_ENB ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_DIR_WDRT_0 ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_DIR_WDRT_1 ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_DIR_WDTO_0 ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_DIR_WDTO_1 ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_DIR_WD_DISABLE0 ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_DIR_WD_DISABLE1 ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_DIR_WD_ENB_INTERVAL ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_DIR_WD_IRQ0 ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_DIR_WD_IRQ1 ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_DIR_WD_THRESHOLD ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_HIST_LIST_MODE ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_HW_AGITATE_CONTROL ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_HW_AGITATE_SELECT ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ2VAS ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ_INTR_ARMED0 ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ_INTR_ARMED1 ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ_INTR_EXPIRED0 ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ_INTR_EXPIRED1 ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ_INTR_IRQ0 ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ_INTR_IRQ1 ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ_INTR_RUN_TIMER0 ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ_INTR_RUN_TIMER1 ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ_INTR_URGENT0 ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ_INTR_URGENT1 ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ_INT_ENB ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ_INT_MASK ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ_IRQ_PENDING ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ_TIMER_CTL ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ_WD_ENB ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_LDB_WDRT_0 ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_LDB_WDRT_1 ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_LDB_WDTO_0 ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_LDB_WDTO_1 ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_LDB_WD_DISABLE0 ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_LDB_WD_DISABLE1 ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_LDB_WD_ENB_INTERVAL ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_LDB_WD_IRQ0 ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_LDB_WD_IRQ1 ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_LDB_WD_THRESHOLD ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_PATCH_CONTROL ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_PIPE_HEALTH_HOLD ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_PIPE_HEALTH_VALID ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_RETN_ZERO ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_SYNDROME_00 ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_SYNDROME_01 ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_UNIT_IDLE ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_UNIT_TIMEOUT ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_UNIT_VERSION ]
                      , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_VAS_CREDIT_COUNT ]
                      } )
  , .in_cfg_rsp_rdata ( {
                        mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_CHP_CNT_ATM_QE_SCH_H * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_CHP_CNT_ATM_QE_SCH_L * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_CHP_CNT_ATQ_TO_ATM_H * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_CHP_CNT_ATQ_TO_ATM_L * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_CHP_CNT_DIR_HCW_ENQ_H * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_CHP_CNT_DIR_HCW_ENQ_L * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_CHP_CNT_DIR_QE_SCH_H * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_CHP_CNT_DIR_QE_SCH_L * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_CHP_CNT_FRAG_REPLAYED_H * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_CHP_CNT_FRAG_REPLAYED_L * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_CHP_CNT_LDB_HCW_ENQ_H * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_CHP_CNT_LDB_HCW_ENQ_L * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_CHP_CNT_LDB_QE_SCH_H * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_CHP_CNT_LDB_QE_SCH_L * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_CHP_CORRECTIBLE_COUNT_H * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_CHP_CORRECTIBLE_COUNT_L * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_CHP_CSR_CONTROL * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_CHP_FRAG_COUNT * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_CHP_PALB_CONTROL * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_CHP_SMON_ACTIVITYCOUNTER0 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_CHP_SMON_ACTIVITYCOUNTER1 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_CHP_SMON_COMPARE0 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_CHP_SMON_COMPARE1 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_CHP_SMON_CONFIGURATION0 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_CHP_SMON_CONFIGURATION1 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_CHP_SMON_MAXIMUM_TIMER * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_CHP_SMON_TIMER * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_CONTROL_DIAGNOSTIC_00 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_CONTROL_DIAGNOSTIC_01 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_CONTROL_DIAGNOSTIC_02 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_CONTROL_GENERAL_00 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_CONTROL_GENERAL_01 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_CONTROL_GENERAL_02 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_COUNTER_CHP_ERROR_DROP_H * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_COUNTER_CHP_ERROR_DROP_L * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_DB_FIFO_STATUS_0 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_DB_FIFO_STATUS_1 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_DB_FIFO_STATUS_2 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_DB_FIFO_STATUS_3 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_DIAGNOSTIC_AW_STATUS_0 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_DIR_CQ2VAS * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_DIR_CQ_INTR_ARMED0 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_DIR_CQ_INTR_ARMED1 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_DIR_CQ_INTR_EXPIRED0 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_DIR_CQ_INTR_EXPIRED1 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_DIR_CQ_INTR_IRQ0 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_DIR_CQ_INTR_IRQ1 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_DIR_CQ_INTR_RUN_TIMER0 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_DIR_CQ_INTR_RUN_TIMER1 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_DIR_CQ_INTR_URGENT0 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_DIR_CQ_INTR_URGENT1 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_DIR_CQ_INT_ENB * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_DIR_CQ_INT_MASK * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_DIR_CQ_IRQ_PENDING * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_DIR_CQ_TIMER_CTL * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_DIR_CQ_WD_ENB * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_DIR_WDRT_0 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_DIR_WDRT_1 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_DIR_WDTO_0 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_DIR_WDTO_1 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_DIR_WD_DISABLE0 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_DIR_WD_DISABLE1 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_DIR_WD_ENB_INTERVAL * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_DIR_WD_IRQ0 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_DIR_WD_IRQ1 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_DIR_WD_THRESHOLD * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_HIST_LIST_MODE * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_HW_AGITATE_CONTROL * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_HW_AGITATE_SELECT * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_LDB_CQ2VAS * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_LDB_CQ_INTR_ARMED0 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_LDB_CQ_INTR_ARMED1 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_LDB_CQ_INTR_EXPIRED0 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_LDB_CQ_INTR_EXPIRED1 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_LDB_CQ_INTR_IRQ0 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_LDB_CQ_INTR_IRQ1 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_LDB_CQ_INTR_RUN_TIMER0 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_LDB_CQ_INTR_RUN_TIMER1 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_LDB_CQ_INTR_URGENT0 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_LDB_CQ_INTR_URGENT1 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_LDB_CQ_INT_ENB * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_LDB_CQ_INT_MASK * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_LDB_CQ_IRQ_PENDING * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_LDB_CQ_TIMER_CTL * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_LDB_CQ_WD_ENB * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_LDB_WDRT_0 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_LDB_WDRT_1 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_LDB_WDTO_0 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_LDB_WDTO_1 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_LDB_WD_DISABLE0 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_LDB_WD_DISABLE1 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_LDB_WD_ENB_INTERVAL * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_LDB_WD_IRQ0 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_LDB_WD_IRQ1 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_LDB_WD_THRESHOLD * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_PATCH_CONTROL * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_PIPE_HEALTH_HOLD * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_PIPE_HEALTH_VALID * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_RETN_ZERO * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_SYNDROME_00 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_SYNDROME_01 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_UNIT_IDLE * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_UNIT_TIMEOUT * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_UNIT_VERSION * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_CHP_TARGET_CFG_VAS_CREDIT_COUNT * 32 ) +: 32 ]
                      } )
   , .out_cfg_rsp_ack ( cfg_rsp_ack )
   , .out_cfg_rsp_err ( cfg_rsp_err )
   , .out_cfg_rsp_rdata ( cfg_rsp_rdata )
) ;
hqm_AW_inc_64b_wtcfg i_hqm_chp_target_cfg_chp_cnt_atm_qe_sch (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .cfg_write            ( { mux_cfg_req_write [ HQM_CHP_TARGET_CFG_CHP_CNT_ATM_QE_SCH_H ] , mux_cfg_req_write [ HQM_CHP_TARGET_CFG_CHP_CNT_ATM_QE_SCH_L ] } )
        , .cfg_read             ( { mux_cfg_req_read [ HQM_CHP_TARGET_CFG_CHP_CNT_ATM_QE_SCH_H ] , mux_cfg_req_read [ HQM_CHP_TARGET_CFG_CHP_CNT_ATM_QE_SCH_L ] } )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( { mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_CHP_CNT_ATM_QE_SCH_H ] , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_CHP_CNT_ATM_QE_SCH_L ] } )
        , .cfg_err              ( { mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_CHP_CNT_ATM_QE_SCH_H ] , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_CHP_CNT_ATM_QE_SCH_L ] } )
        , .cfg_rdata            ( { mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_CHP_CNT_ATM_QE_SCH_H * 32 +: 32 ] , mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_CHP_CNT_ATM_QE_SCH_L * 32 +: 32 ] } )
        , .en                   ( hqm_chp_target_cfg_chp_cnt_atm_qe_sch_en )
        , .clr                  ( hqm_chp_target_cfg_chp_cnt_atm_qe_sch_clr )
        , .clrv                 ( hqm_chp_target_cfg_chp_cnt_atm_qe_sch_clrv )
        , .inc                  ( hqm_chp_target_cfg_chp_cnt_atm_qe_sch_inc )
        , .count                ( hqm_chp_target_cfg_chp_cnt_atm_qe_sch_count )
) ;
hqm_AW_inc_64b_wtcfg i_hqm_chp_target_cfg_chp_cnt_atq_to_atm (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .cfg_write            ( { mux_cfg_req_write [ HQM_CHP_TARGET_CFG_CHP_CNT_ATQ_TO_ATM_H ] , mux_cfg_req_write [ HQM_CHP_TARGET_CFG_CHP_CNT_ATQ_TO_ATM_L ] } )
        , .cfg_read             ( { mux_cfg_req_read [ HQM_CHP_TARGET_CFG_CHP_CNT_ATQ_TO_ATM_H ] , mux_cfg_req_read [ HQM_CHP_TARGET_CFG_CHP_CNT_ATQ_TO_ATM_L ] } )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( { mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_CHP_CNT_ATQ_TO_ATM_H ] , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_CHP_CNT_ATQ_TO_ATM_L ] } )
        , .cfg_err              ( { mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_CHP_CNT_ATQ_TO_ATM_H ] , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_CHP_CNT_ATQ_TO_ATM_L ] } )
        , .cfg_rdata            ( { mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_CHP_CNT_ATQ_TO_ATM_H * 32 +: 32 ] , mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_CHP_CNT_ATQ_TO_ATM_L * 32 +: 32 ] } )
        , .en                   ( hqm_chp_target_cfg_chp_cnt_atq_to_atm_en )
        , .clr                  ( hqm_chp_target_cfg_chp_cnt_atq_to_atm_clr )
        , .clrv                 ( hqm_chp_target_cfg_chp_cnt_atq_to_atm_clrv )
        , .inc                  ( hqm_chp_target_cfg_chp_cnt_atq_to_atm_inc )
        , .count                ( hqm_chp_target_cfg_chp_cnt_atq_to_atm_count )
) ;
hqm_AW_inc_64b_wtcfg i_hqm_chp_target_cfg_chp_cnt_dir_hcw_enq (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .cfg_write            ( { mux_cfg_req_write [ HQM_CHP_TARGET_CFG_CHP_CNT_DIR_HCW_ENQ_H ] , mux_cfg_req_write [ HQM_CHP_TARGET_CFG_CHP_CNT_DIR_HCW_ENQ_L ] } )
        , .cfg_read             ( { mux_cfg_req_read [ HQM_CHP_TARGET_CFG_CHP_CNT_DIR_HCW_ENQ_H ] , mux_cfg_req_read [ HQM_CHP_TARGET_CFG_CHP_CNT_DIR_HCW_ENQ_L ] } )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( { mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_CHP_CNT_DIR_HCW_ENQ_H ] , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_CHP_CNT_DIR_HCW_ENQ_L ] } )
        , .cfg_err              ( { mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_CHP_CNT_DIR_HCW_ENQ_H ] , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_CHP_CNT_DIR_HCW_ENQ_L ] } )
        , .cfg_rdata            ( { mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_CHP_CNT_DIR_HCW_ENQ_H * 32 +: 32 ] , mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_CHP_CNT_DIR_HCW_ENQ_L * 32 +: 32 ] } )
        , .en                   ( hqm_chp_target_cfg_chp_cnt_dir_hcw_enq_en )
        , .clr                  ( hqm_chp_target_cfg_chp_cnt_dir_hcw_enq_clr )
        , .clrv                 ( hqm_chp_target_cfg_chp_cnt_dir_hcw_enq_clrv )
        , .inc                  ( hqm_chp_target_cfg_chp_cnt_dir_hcw_enq_inc )
        , .count                ( hqm_chp_target_cfg_chp_cnt_dir_hcw_enq_count )
) ;
hqm_AW_inc_64b_wtcfg i_hqm_chp_target_cfg_chp_cnt_dir_qe_sch (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .cfg_write            ( { mux_cfg_req_write [ HQM_CHP_TARGET_CFG_CHP_CNT_DIR_QE_SCH_H ] , mux_cfg_req_write [ HQM_CHP_TARGET_CFG_CHP_CNT_DIR_QE_SCH_L ] } )
        , .cfg_read             ( { mux_cfg_req_read [ HQM_CHP_TARGET_CFG_CHP_CNT_DIR_QE_SCH_H ] , mux_cfg_req_read [ HQM_CHP_TARGET_CFG_CHP_CNT_DIR_QE_SCH_L ] } )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( { mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_CHP_CNT_DIR_QE_SCH_H ] , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_CHP_CNT_DIR_QE_SCH_L ] } )
        , .cfg_err              ( { mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_CHP_CNT_DIR_QE_SCH_H ] , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_CHP_CNT_DIR_QE_SCH_L ] } )
        , .cfg_rdata            ( { mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_CHP_CNT_DIR_QE_SCH_H * 32 +: 32 ] , mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_CHP_CNT_DIR_QE_SCH_L * 32 +: 32 ] } )
        , .en                   ( hqm_chp_target_cfg_chp_cnt_dir_qe_sch_en )
        , .clr                  ( hqm_chp_target_cfg_chp_cnt_dir_qe_sch_clr )
        , .clrv                 ( hqm_chp_target_cfg_chp_cnt_dir_qe_sch_clrv )
        , .inc                  ( hqm_chp_target_cfg_chp_cnt_dir_qe_sch_inc )
        , .count                ( hqm_chp_target_cfg_chp_cnt_dir_qe_sch_count )
) ;
hqm_AW_inc_64b_wtcfg i_hqm_chp_target_cfg_chp_cnt_frag_replayed (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .cfg_write            ( { mux_cfg_req_write [ HQM_CHP_TARGET_CFG_CHP_CNT_FRAG_REPLAYED_H ] , mux_cfg_req_write [ HQM_CHP_TARGET_CFG_CHP_CNT_FRAG_REPLAYED_L ] } )
        , .cfg_read             ( { mux_cfg_req_read [ HQM_CHP_TARGET_CFG_CHP_CNT_FRAG_REPLAYED_H ] , mux_cfg_req_read [ HQM_CHP_TARGET_CFG_CHP_CNT_FRAG_REPLAYED_L ] } )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( { mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_CHP_CNT_FRAG_REPLAYED_H ] , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_CHP_CNT_FRAG_REPLAYED_L ] } )
        , .cfg_err              ( { mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_CHP_CNT_FRAG_REPLAYED_H ] , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_CHP_CNT_FRAG_REPLAYED_L ] } )
        , .cfg_rdata            ( { mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_CHP_CNT_FRAG_REPLAYED_H * 32 +: 32 ] , mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_CHP_CNT_FRAG_REPLAYED_L * 32 +: 32 ] } )
        , .en                   ( hqm_chp_target_cfg_chp_cnt_frag_replayed_en )
        , .clr                  ( hqm_chp_target_cfg_chp_cnt_frag_replayed_clr )
        , .clrv                 ( hqm_chp_target_cfg_chp_cnt_frag_replayed_clrv )
        , .inc                  ( hqm_chp_target_cfg_chp_cnt_frag_replayed_inc )
        , .count                ( hqm_chp_target_cfg_chp_cnt_frag_replayed_count )
) ;
hqm_AW_inc_64b_wtcfg i_hqm_chp_target_cfg_chp_cnt_ldb_hcw_enq (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .cfg_write            ( { mux_cfg_req_write [ HQM_CHP_TARGET_CFG_CHP_CNT_LDB_HCW_ENQ_H ] , mux_cfg_req_write [ HQM_CHP_TARGET_CFG_CHP_CNT_LDB_HCW_ENQ_L ] } )
        , .cfg_read             ( { mux_cfg_req_read [ HQM_CHP_TARGET_CFG_CHP_CNT_LDB_HCW_ENQ_H ] , mux_cfg_req_read [ HQM_CHP_TARGET_CFG_CHP_CNT_LDB_HCW_ENQ_L ] } )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( { mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_CHP_CNT_LDB_HCW_ENQ_H ] , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_CHP_CNT_LDB_HCW_ENQ_L ] } )
        , .cfg_err              ( { mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_CHP_CNT_LDB_HCW_ENQ_H ] , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_CHP_CNT_LDB_HCW_ENQ_L ] } )
        , .cfg_rdata            ( { mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_CHP_CNT_LDB_HCW_ENQ_H * 32 +: 32 ] , mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_CHP_CNT_LDB_HCW_ENQ_L * 32 +: 32 ] } )
        , .en                   ( hqm_chp_target_cfg_chp_cnt_ldb_hcw_enq_en )
        , .clr                  ( hqm_chp_target_cfg_chp_cnt_ldb_hcw_enq_clr )
        , .clrv                 ( hqm_chp_target_cfg_chp_cnt_ldb_hcw_enq_clrv )
        , .inc                  ( hqm_chp_target_cfg_chp_cnt_ldb_hcw_enq_inc )
        , .count                ( hqm_chp_target_cfg_chp_cnt_ldb_hcw_enq_count )
) ;
hqm_AW_inc_64b_wtcfg i_hqm_chp_target_cfg_chp_cnt_ldb_qe_sch (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .cfg_write            ( { mux_cfg_req_write [ HQM_CHP_TARGET_CFG_CHP_CNT_LDB_QE_SCH_H ] , mux_cfg_req_write [ HQM_CHP_TARGET_CFG_CHP_CNT_LDB_QE_SCH_L ] } )
        , .cfg_read             ( { mux_cfg_req_read [ HQM_CHP_TARGET_CFG_CHP_CNT_LDB_QE_SCH_H ] , mux_cfg_req_read [ HQM_CHP_TARGET_CFG_CHP_CNT_LDB_QE_SCH_L ] } )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( { mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_CHP_CNT_LDB_QE_SCH_H ] , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_CHP_CNT_LDB_QE_SCH_L ] } )
        , .cfg_err              ( { mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_CHP_CNT_LDB_QE_SCH_H ] , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_CHP_CNT_LDB_QE_SCH_L ] } )
        , .cfg_rdata            ( { mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_CHP_CNT_LDB_QE_SCH_H * 32 +: 32 ] , mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_CHP_CNT_LDB_QE_SCH_L * 32 +: 32 ] } )
        , .en                   ( hqm_chp_target_cfg_chp_cnt_ldb_qe_sch_en )
        , .clr                  ( hqm_chp_target_cfg_chp_cnt_ldb_qe_sch_clr )
        , .clrv                 ( hqm_chp_target_cfg_chp_cnt_ldb_qe_sch_clrv )
        , .inc                  ( hqm_chp_target_cfg_chp_cnt_ldb_qe_sch_inc )
        , .count                ( hqm_chp_target_cfg_chp_cnt_ldb_qe_sch_count )
) ;
hqm_AW_inc_64b_wtcfg i_hqm_chp_target_cfg_chp_correctible_count (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .cfg_write            ( { mux_cfg_req_write [ HQM_CHP_TARGET_CFG_CHP_CORRECTIBLE_COUNT_H ] , mux_cfg_req_write [ HQM_CHP_TARGET_CFG_CHP_CORRECTIBLE_COUNT_L ] } )
        , .cfg_read             ( { mux_cfg_req_read [ HQM_CHP_TARGET_CFG_CHP_CORRECTIBLE_COUNT_H ] , mux_cfg_req_read [ HQM_CHP_TARGET_CFG_CHP_CORRECTIBLE_COUNT_L ] } )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( { mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_CHP_CORRECTIBLE_COUNT_H ] , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_CHP_CORRECTIBLE_COUNT_L ] } )
        , .cfg_err              ( { mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_CHP_CORRECTIBLE_COUNT_H ] , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_CHP_CORRECTIBLE_COUNT_L ] } )
        , .cfg_rdata            ( { mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_CHP_CORRECTIBLE_COUNT_H * 32 +: 32 ] , mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_CHP_CORRECTIBLE_COUNT_L * 32 +: 32 ] } )
        , .en                   ( hqm_chp_target_cfg_chp_correctible_count_en )
        , .clr                  ( hqm_chp_target_cfg_chp_correctible_count_clr )
        , .clrv                 ( hqm_chp_target_cfg_chp_correctible_count_clrv )
        , .inc                  ( hqm_chp_target_cfg_chp_correctible_count_inc )
        , .count                ( hqm_chp_target_cfg_chp_correctible_count_count )
) ;
hqm_AW_register_enable_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( CFG_CSR_CONTROL_DEFAULT )
) i_hqm_chp_target_cfg_chp_csr_control (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_chp_target_cfg_chp_csr_control_reg_nxt )
        , .reg_f                ( hqm_chp_target_cfg_chp_csr_control_reg_f )
        , .reg_v                ( hqm_chp_target_cfg_chp_csr_control_reg_v )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_CHP_CSR_CONTROL ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_CHP_CSR_CONTROL ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_CHP_CSR_CONTROL ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_CHP_CSR_CONTROL ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_CHP_CSR_CONTROL * 32 +: 32 ] )
) ;
hqm_AW_registerram_wtcfg #(
          .WIDTH                ( 7 )
        , .DEPTH                ( 64 )
        , .DEFAULT              ( { 64 { 7'h0 } } )
        , .COPY                 ( 1 )
        , .CFG_READ_MASK        ( 31 )
) i_hqm_chp_target_cfg_chp_frag_count (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_load             ( hqm_chp_target_cfg_chp_frag_count_reg_load )
        , .reg_nxt              ( hqm_chp_target_cfg_chp_frag_count_reg_nxt )
        , .reg_f                ( hqm_chp_target_cfg_chp_frag_count_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_CHP_FRAG_COUNT ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_CHP_FRAG_COUNT ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_CHP_FRAG_COUNT ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_CHP_FRAG_COUNT ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_CHP_FRAG_COUNT * 32 +: 32 ] )
) ;
hqm_AW_register_enable_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( CFG_PALB_CONTROL_DEFAULT )
) i_hqm_chp_target_cfg_chp_palb_control (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_chp_target_cfg_chp_palb_control_reg_nxt )
        , .reg_f                ( hqm_chp_target_cfg_chp_palb_control_reg_f )
        , .reg_v                ( hqm_chp_target_cfg_chp_palb_control_reg_v )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_CHP_PALB_CONTROL ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_CHP_PALB_CONTROL ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_CHP_PALB_CONTROL ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_CHP_PALB_CONTROL ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_CHP_PALB_CONTROL * 32 +: 32 ] )
) ;
hqm_AW_smon_wtcfg #( 
          .WIDTH                       ( 16 ) 
) i_hqm_chp_target_cfg_chp_smon ( 
          .clk                         ( hqm_gated_clk )
        , .rst_n                       ( hqm_gated_rst_n )
        , .cfg_write                   ( { mux_cfg_req_write[ HQM_CHP_TARGET_CFG_CHP_SMON_MAXIMUM_TIMER ]
                                          , mux_cfg_req_write[HQM_CHP_TARGET_CFG_CHP_SMON_TIMER ]
                                          , mux_cfg_req_write[ HQM_CHP_TARGET_CFG_CHP_SMON_ACTIVITYCOUNTER1 ]
                                          , mux_cfg_req_write[ HQM_CHP_TARGET_CFG_CHP_SMON_ACTIVITYCOUNTER0 ]
                                          , mux_cfg_req_write[ HQM_CHP_TARGET_CFG_CHP_SMON_COMPARE1 ]
                                          , mux_cfg_req_write[ HQM_CHP_TARGET_CFG_CHP_SMON_COMPARE0 ]
                                          , mux_cfg_req_write[ HQM_CHP_TARGET_CFG_CHP_SMON_CONFIGURATION1 ]
                                          , mux_cfg_req_write[ HQM_CHP_TARGET_CFG_CHP_SMON_CONFIGURATION0 ]
                                          }
                                        )
        , .cfg_read                    ( { mux_cfg_req_read[ HQM_CHP_TARGET_CFG_CHP_SMON_MAXIMUM_TIMER ]
                                          , mux_cfg_req_read[ HQM_CHP_TARGET_CFG_CHP_SMON_TIMER ]
                                          , mux_cfg_req_read[ HQM_CHP_TARGET_CFG_CHP_SMON_ACTIVITYCOUNTER1 ]
                                          , mux_cfg_req_read[ HQM_CHP_TARGET_CFG_CHP_SMON_ACTIVITYCOUNTER0 ]
                                          , mux_cfg_req_read[ HQM_CHP_TARGET_CFG_CHP_SMON_COMPARE1 ]
                                          , mux_cfg_req_read[ HQM_CHP_TARGET_CFG_CHP_SMON_COMPARE0 ]
                                          , mux_cfg_req_read[ HQM_CHP_TARGET_CFG_CHP_SMON_CONFIGURATION1 ]
                                          , mux_cfg_req_read[ HQM_CHP_TARGET_CFG_CHP_SMON_CONFIGURATION0 ]
                                          }
                                        )
        , .cfg_req                     ( mux_cfg_req )
        , .cfg_ack                     ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_CHP_SMON_CONFIGURATION0 * 1 +: 1 ] )
        , .cfg_err                     ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_CHP_SMON_CONFIGURATION0 * 1 +: 1 ] )
        , .cfg_rdata                   ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_CHP_SMON_CONFIGURATION0 * 32 +: 32 ] )
        , .disable_smon                ( hqm_chp_target_cfg_chp_smon_disable_smon )
        , .in_mon_v                    ( hqm_chp_target_cfg_chp_smon_smon_v )
        , .in_mon_comp                 ( hqm_chp_target_cfg_chp_smon_smon_comp )
        , .in_mon_val                  ( hqm_chp_target_cfg_chp_smon_smon_val )
        , .out_smon_interrupt          ( hqm_chp_target_cfg_chp_smon_smon_interrupt )
        , .out_smon_enabled            ( hqm_chp_target_cfg_chp_smon_smon_enabled )
) ;
assign mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_CHP_SMON_CONFIGURATION1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_CHP_SMON_CONFIGURATION1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_CHP_SMON_CONFIGURATION1 * 32 +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_CHP_SMON_COMPARE0 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_CHP_SMON_COMPARE0 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_CHP_SMON_COMPARE0 * 32 +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_CHP_SMON_COMPARE1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_CHP_SMON_COMPARE1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_CHP_SMON_COMPARE1 * 32 +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_CHP_SMON_ACTIVITYCOUNTER0 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_CHP_SMON_ACTIVITYCOUNTER0 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_CHP_SMON_ACTIVITYCOUNTER0 * 32 +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_CHP_SMON_ACTIVITYCOUNTER1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_CHP_SMON_ACTIVITYCOUNTER1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_CHP_SMON_ACTIVITYCOUNTER1 * 32 +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_CHP_SMON_TIMER ] = '0 ;
assign mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_CHP_SMON_TIMER ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_CHP_SMON_TIMER * 32 +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_CHP_SMON_MAXIMUM_TIMER ] = '0 ;
assign mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_CHP_SMON_MAXIMUM_TIMER ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_CHP_SMON_MAXIMUM_TIMER * 32 +: 32 ] = '0 ;
hqm_AW_register_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h00000000 )
) i_hqm_chp_target_cfg_control_diagnostic_00 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_chp_target_cfg_control_diagnostic_00_reg_nxt )
        , .reg_f                ( hqm_chp_target_cfg_control_diagnostic_00_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_CONTROL_DIAGNOSTIC_00 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_CONTROL_DIAGNOSTIC_00 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_CONTROL_DIAGNOSTIC_00 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_CONTROL_DIAGNOSTIC_00 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_CONTROL_DIAGNOSTIC_00 * 32 +: 32 ] )
) ;
hqm_AW_register_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h00000000 )
) i_hqm_chp_target_cfg_control_diagnostic_01 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_chp_target_cfg_control_diagnostic_01_reg_nxt )
        , .reg_f                ( hqm_chp_target_cfg_control_diagnostic_01_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_CONTROL_DIAGNOSTIC_01 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_CONTROL_DIAGNOSTIC_01 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_CONTROL_DIAGNOSTIC_01 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_CONTROL_DIAGNOSTIC_01 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_CONTROL_DIAGNOSTIC_01 * 32 +: 32 ] )
) ;
hqm_AW_register_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h00000000 )
) i_hqm_chp_target_cfg_control_diagnostic_02 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_chp_target_cfg_control_diagnostic_02_reg_nxt )
        , .reg_f                ( hqm_chp_target_cfg_control_diagnostic_02_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_CONTROL_DIAGNOSTIC_02 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_CONTROL_DIAGNOSTIC_02 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_CONTROL_DIAGNOSTIC_02 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_CONTROL_DIAGNOSTIC_02 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_CONTROL_DIAGNOSTIC_02 * 32 +: 32 ] )
) ;
hqm_AW_register_enable_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( CFG_CONTROL_GENERAL_00_DEFAULT )
) i_hqm_chp_target_cfg_control_general_00 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_chp_target_cfg_control_general_00_reg_nxt )
        , .reg_f                ( hqm_chp_target_cfg_control_general_00_reg_f )
        , .reg_v                ( hqm_chp_target_cfg_control_general_00_reg_v )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_CONTROL_GENERAL_00 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_CONTROL_GENERAL_00 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_CONTROL_GENERAL_00 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_CONTROL_GENERAL_00 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_CONTROL_GENERAL_00 * 32 +: 32 ] )
) ;
hqm_AW_register_enable_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( CFG_CONTROL_GENERAL_01_DEFAULT )
) i_hqm_chp_target_cfg_control_general_01 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_chp_target_cfg_control_general_01_reg_nxt )
        , .reg_f                ( hqm_chp_target_cfg_control_general_01_reg_f )
        , .reg_v                ( hqm_chp_target_cfg_control_general_01_reg_v )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_CONTROL_GENERAL_01 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_CONTROL_GENERAL_01 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_CONTROL_GENERAL_01 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_CONTROL_GENERAL_01 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_CONTROL_GENERAL_01 * 32 +: 32 ] )
) ;
hqm_AW_register_enable_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( CFG_CONTROL_GENERAL_02_DEFAULT )
) i_hqm_chp_target_cfg_control_general_02 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_chp_target_cfg_control_general_02_reg_nxt )
        , .reg_f                ( hqm_chp_target_cfg_control_general_02_reg_f )
        , .reg_v                ( hqm_chp_target_cfg_control_general_02_reg_v )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_CONTROL_GENERAL_02 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_CONTROL_GENERAL_02 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_CONTROL_GENERAL_02 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_CONTROL_GENERAL_02 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_CONTROL_GENERAL_02 * 32 +: 32 ] )
) ;
hqm_AW_inc_64b_wtcfg i_hqm_chp_target_cfg_counter_chp_error_drop (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .cfg_write            ( { mux_cfg_req_write [ HQM_CHP_TARGET_CFG_COUNTER_CHP_ERROR_DROP_H ] , mux_cfg_req_write [ HQM_CHP_TARGET_CFG_COUNTER_CHP_ERROR_DROP_L ] } )
        , .cfg_read             ( { mux_cfg_req_read [ HQM_CHP_TARGET_CFG_COUNTER_CHP_ERROR_DROP_H ] , mux_cfg_req_read [ HQM_CHP_TARGET_CFG_COUNTER_CHP_ERROR_DROP_L ] } )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( { mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_COUNTER_CHP_ERROR_DROP_H ] , mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_COUNTER_CHP_ERROR_DROP_L ] } )
        , .cfg_err              ( { mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_COUNTER_CHP_ERROR_DROP_H ] , mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_COUNTER_CHP_ERROR_DROP_L ] } )
        , .cfg_rdata            ( { mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_COUNTER_CHP_ERROR_DROP_H * 32 +: 32 ] , mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_COUNTER_CHP_ERROR_DROP_L * 32 +: 32 ] } )
        , .en                   ( hqm_chp_target_cfg_counter_chp_error_drop_en )
        , .clr                  ( hqm_chp_target_cfg_counter_chp_error_drop_clr )
        , .clrv                 ( hqm_chp_target_cfg_counter_chp_error_drop_clrv )
        , .inc                  ( hqm_chp_target_cfg_counter_chp_error_drop_inc )
        , .count                ( hqm_chp_target_cfg_counter_chp_error_drop_count )
) ;
hqm_AW_status_wtcfg i_hqm_chp_target_cfg_db_fifo_status_0 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .status               ( hqm_chp_target_cfg_db_fifo_status_0_status )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_DB_FIFO_STATUS_0 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_DB_FIFO_STATUS_0 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_DB_FIFO_STATUS_0 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_DB_FIFO_STATUS_0 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_DB_FIFO_STATUS_0 * 32 +: 32 ] )
) ;
hqm_AW_status_wtcfg i_hqm_chp_target_cfg_db_fifo_status_1 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .status               ( hqm_chp_target_cfg_db_fifo_status_1_status )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_DB_FIFO_STATUS_1 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_DB_FIFO_STATUS_1 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_DB_FIFO_STATUS_1 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_DB_FIFO_STATUS_1 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_DB_FIFO_STATUS_1 * 32 +: 32 ] )
) ;
hqm_AW_status_wtcfg i_hqm_chp_target_cfg_db_fifo_status_2 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .status               ( hqm_chp_target_cfg_db_fifo_status_2_status )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_DB_FIFO_STATUS_2 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_DB_FIFO_STATUS_2 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_DB_FIFO_STATUS_2 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_DB_FIFO_STATUS_2 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_DB_FIFO_STATUS_2 * 32 +: 32 ] )
) ;
hqm_AW_status_wtcfg i_hqm_chp_target_cfg_db_fifo_status_3 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .status               ( hqm_chp_target_cfg_db_fifo_status_3_status )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_DB_FIFO_STATUS_3 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_DB_FIFO_STATUS_3 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_DB_FIFO_STATUS_3 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_DB_FIFO_STATUS_3 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_DB_FIFO_STATUS_3 * 32 +: 32 ] )
) ;
hqm_AW_status_wtcfg i_hqm_chp_target_cfg_diagnostic_aw_status_0 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .status               ( hqm_chp_target_cfg_diagnostic_aw_status_0_status )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_DIAGNOSTIC_AW_STATUS_0 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_DIAGNOSTIC_AW_STATUS_0 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_DIAGNOSTIC_AW_STATUS_0 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_DIAGNOSTIC_AW_STATUS_0 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_DIAGNOSTIC_AW_STATUS_0 * 32 +: 32 ] )
) ;
hqm_AW_registerram_wtcfg #(
          .WIDTH                ( 6 )
        , .DEPTH                ( 64 )
        , .DEFAULT              ( { 64 { 6'h20 } } )
        , .COPY                 ( 1 )
        , .CFG_READ_MASK        ( 31 )
) i_hqm_chp_target_cfg_dir_cq2vas (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_load             ( hqm_chp_target_cfg_dir_cq2vas_reg_load )
        , .reg_nxt              ( hqm_chp_target_cfg_dir_cq2vas_reg_nxt )
        , .reg_f                ( hqm_chp_target_cfg_dir_cq2vas_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_DIR_CQ2VAS ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_DIR_CQ2VAS ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ2VAS ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ2VAS ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ2VAS * 32 +: 32 ] )
) ;
hqm_AW_register_enable_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h00000000 )
) i_hqm_chp_target_cfg_dir_cq_intr_armed0 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_chp_target_cfg_dir_cq_intr_armed0_reg_nxt )
        , .reg_f                ( hqm_chp_target_cfg_dir_cq_intr_armed0_reg_f )
        , .reg_v                ( hqm_chp_target_cfg_dir_cq_intr_armed0_reg_v )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_DIR_CQ_INTR_ARMED0 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_DIR_CQ_INTR_ARMED0 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ_INTR_ARMED0 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ_INTR_ARMED0 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ_INTR_ARMED0 * 32 +: 32 ] )
) ;
hqm_AW_register_enable_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h00000000 )
) i_hqm_chp_target_cfg_dir_cq_intr_armed1 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_chp_target_cfg_dir_cq_intr_armed1_reg_nxt )
        , .reg_f                ( hqm_chp_target_cfg_dir_cq_intr_armed1_reg_f )
        , .reg_v                ( hqm_chp_target_cfg_dir_cq_intr_armed1_reg_v )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_DIR_CQ_INTR_ARMED1 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_DIR_CQ_INTR_ARMED1 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ_INTR_ARMED1 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ_INTR_ARMED1 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ_INTR_ARMED1 * 32 +: 32 ] )
) ;
hqm_AW_status_wtcfg i_hqm_chp_target_cfg_dir_cq_intr_expired0 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .status               ( hqm_chp_target_cfg_dir_cq_intr_expired0_status )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_DIR_CQ_INTR_EXPIRED0 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_DIR_CQ_INTR_EXPIRED0 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ_INTR_EXPIRED0 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ_INTR_EXPIRED0 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ_INTR_EXPIRED0 * 32 +: 32 ] )
) ;
hqm_AW_status_wtcfg i_hqm_chp_target_cfg_dir_cq_intr_expired1 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .status               ( hqm_chp_target_cfg_dir_cq_intr_expired1_status )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_DIR_CQ_INTR_EXPIRED1 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_DIR_CQ_INTR_EXPIRED1 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ_INTR_EXPIRED1 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ_INTR_EXPIRED1 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ_INTR_EXPIRED1 * 32 +: 32 ] )
) ;
hqm_AW_status_wtcfg i_hqm_chp_target_cfg_dir_cq_intr_irq0 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .status               ( hqm_chp_target_cfg_dir_cq_intr_irq0_status )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_DIR_CQ_INTR_IRQ0 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_DIR_CQ_INTR_IRQ0 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ_INTR_IRQ0 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ_INTR_IRQ0 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ_INTR_IRQ0 * 32 +: 32 ] )
) ;
hqm_AW_status_wtcfg i_hqm_chp_target_cfg_dir_cq_intr_irq1 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .status               ( hqm_chp_target_cfg_dir_cq_intr_irq1_status )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_DIR_CQ_INTR_IRQ1 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_DIR_CQ_INTR_IRQ1 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ_INTR_IRQ1 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ_INTR_IRQ1 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ_INTR_IRQ1 * 32 +: 32 ] )
) ;
hqm_AW_status_wtcfg i_hqm_chp_target_cfg_dir_cq_intr_run_timer0 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .status               ( hqm_chp_target_cfg_dir_cq_intr_run_timer0_status )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_DIR_CQ_INTR_RUN_TIMER0 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_DIR_CQ_INTR_RUN_TIMER0 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ_INTR_RUN_TIMER0 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ_INTR_RUN_TIMER0 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ_INTR_RUN_TIMER0 * 32 +: 32 ] )
) ;
hqm_AW_status_wtcfg i_hqm_chp_target_cfg_dir_cq_intr_run_timer1 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .status               ( hqm_chp_target_cfg_dir_cq_intr_run_timer1_status )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_DIR_CQ_INTR_RUN_TIMER1 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_DIR_CQ_INTR_RUN_TIMER1 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ_INTR_RUN_TIMER1 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ_INTR_RUN_TIMER1 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ_INTR_RUN_TIMER1 * 32 +: 32 ] )
) ;
hqm_AW_status_wtcfg i_hqm_chp_target_cfg_dir_cq_intr_urgent0 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .status               ( hqm_chp_target_cfg_dir_cq_intr_urgent0_status )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_DIR_CQ_INTR_URGENT0 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_DIR_CQ_INTR_URGENT0 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ_INTR_URGENT0 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ_INTR_URGENT0 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ_INTR_URGENT0 * 32 +: 32 ] )
) ;
hqm_AW_status_wtcfg i_hqm_chp_target_cfg_dir_cq_intr_urgent1 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .status               ( hqm_chp_target_cfg_dir_cq_intr_urgent1_status )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_DIR_CQ_INTR_URGENT1 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_DIR_CQ_INTR_URGENT1 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ_INTR_URGENT1 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ_INTR_URGENT1 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ_INTR_URGENT1 * 32 +: 32 ] )
) ;
hqm_AW_registerram_wtcfg #(
          .WIDTH                ( 2 )
        , .DEPTH                ( 64 )
        , .DEFAULT              ( 128'h0 )
        , .COPY                 ( 1 )
        , .CFG_READ_MASK        ( 3 )
) i_hqm_chp_target_cfg_dir_cq_int_enb (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_load             ( hqm_chp_target_cfg_dir_cq_int_enb_reg_load )
        , .reg_nxt              ( hqm_chp_target_cfg_dir_cq_int_enb_reg_nxt )
        , .reg_f                ( hqm_chp_target_cfg_dir_cq_int_enb_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_DIR_CQ_INT_ENB ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_DIR_CQ_INT_ENB ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ_INT_ENB ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ_INT_ENB ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ_INT_ENB * 32 +: 32 ] )
) ;
hqm_AW_registerram_wtcfg #(
          .WIDTH                ( 1 )
        , .DEPTH                ( 64 )
        , .DEFAULT              ( {64{1'b0}} )
        , .COPY                 ( 1 )
        , .CFG_READ_MASK        ( 1 )
) i_hqm_chp_target_cfg_dir_cq_int_mask (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_load             ( hqm_chp_target_cfg_dir_cq_int_mask_reg_load )
        , .reg_nxt              ( hqm_chp_target_cfg_dir_cq_int_mask_reg_nxt )
        , .reg_f                ( hqm_chp_target_cfg_dir_cq_int_mask_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_DIR_CQ_INT_MASK ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_DIR_CQ_INT_MASK ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ_INT_MASK ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ_INT_MASK ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ_INT_MASK * 32 +: 32 ] )
) ;
hqm_AW_registerram_wtcfg #(
          .WIDTH                ( 1 )
        , .DEPTH                ( 64 )
        , .DEFAULT              ( {64{1'b0}} )
        , .COPY                 ( 1 )
        , .CFG_READ_MASK        ( 1 )
) i_hqm_chp_target_cfg_dir_cq_irq_pending (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_load             ( hqm_chp_target_cfg_dir_cq_irq_pending_reg_load )
        , .reg_nxt              ( hqm_chp_target_cfg_dir_cq_irq_pending_reg_nxt )
        , .reg_f                ( hqm_chp_target_cfg_dir_cq_irq_pending_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_DIR_CQ_IRQ_PENDING ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_DIR_CQ_IRQ_PENDING ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ_IRQ_PENDING ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ_IRQ_PENDING ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ_IRQ_PENDING * 32 +: 32 ] )
) ;
hqm_AW_register_enable_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h00000000 )
) i_hqm_chp_target_cfg_dir_cq_timer_ctl (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_chp_target_cfg_dir_cq_timer_ctl_reg_nxt )
        , .reg_f                ( hqm_chp_target_cfg_dir_cq_timer_ctl_reg_f )
        , .reg_v                ( hqm_chp_target_cfg_dir_cq_timer_ctl_reg_v )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_DIR_CQ_TIMER_CTL ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_DIR_CQ_TIMER_CTL ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ_TIMER_CTL ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ_TIMER_CTL ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ_TIMER_CTL * 32 +: 32 ] )
) ;
hqm_AW_registerram_wtcfg #(
          .WIDTH                ( 1 )
        , .DEPTH                ( 64 )
        , .DEFAULT              ( 64'h0 )
        , .COPY                 ( 1 )
        , .CFG_READ_MASK        ( 1 )
) i_hqm_chp_target_cfg_dir_cq_wd_enb (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_load             ( hqm_chp_target_cfg_dir_cq_wd_enb_reg_load )
        , .reg_nxt              ( hqm_chp_target_cfg_dir_cq_wd_enb_reg_nxt )
        , .reg_f                ( hqm_chp_target_cfg_dir_cq_wd_enb_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_DIR_CQ_WD_ENB ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_DIR_CQ_WD_ENB ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ_WD_ENB ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ_WD_ENB ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_DIR_CQ_WD_ENB * 32 +: 32 ] )
) ;
hqm_AW_status_wtcfg i_hqm_chp_target_cfg_dir_wdrt_0 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .status               ( hqm_chp_target_cfg_dir_wdrt_0_status )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_DIR_WDRT_0 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_DIR_WDRT_0 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_DIR_WDRT_0 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_DIR_WDRT_0 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_DIR_WDRT_0 * 32 +: 32 ] )
) ;
hqm_AW_status_wtcfg i_hqm_chp_target_cfg_dir_wdrt_1 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .status               ( hqm_chp_target_cfg_dir_wdrt_1_status )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_DIR_WDRT_1 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_DIR_WDRT_1 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_DIR_WDRT_1 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_DIR_WDRT_1 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_DIR_WDRT_1 * 32 +: 32 ] )
) ;
hqm_AW_register_sticky_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h00000000 )
        , .W1C                  ( 1 )
) i_hqm_chp_target_cfg_dir_wdto_0 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_chp_target_cfg_dir_wdto_0_reg_nxt )
        , .reg_f                ( hqm_chp_target_cfg_dir_wdto_0_reg_f )
        , .load                 ( hqm_chp_target_cfg_dir_wdto_0_reg_load )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_DIR_WDTO_0 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_DIR_WDTO_0 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_DIR_WDTO_0 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_DIR_WDTO_0 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_DIR_WDTO_0 * 32 +: 32 ] )
) ;
hqm_AW_register_sticky_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h00000000 )
        , .W1C                  ( 1 )
) i_hqm_chp_target_cfg_dir_wdto_1 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_chp_target_cfg_dir_wdto_1_reg_nxt )
        , .reg_f                ( hqm_chp_target_cfg_dir_wdto_1_reg_f )
        , .load                 ( hqm_chp_target_cfg_dir_wdto_1_reg_load )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_DIR_WDTO_1 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_DIR_WDTO_1 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_DIR_WDTO_1 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_DIR_WDTO_1 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_DIR_WDTO_1 * 32 +: 32 ] )
) ;
hqm_AW_register_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'hffffffff )
        , .W1C                  ( 1 )
) i_hqm_chp_target_cfg_dir_wd_disable0 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_chp_target_cfg_dir_wd_disable0_reg_nxt )
        , .reg_f                ( hqm_chp_target_cfg_dir_wd_disable0_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_DIR_WD_DISABLE0 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_DIR_WD_DISABLE0 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_DIR_WD_DISABLE0 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_DIR_WD_DISABLE0 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_DIR_WD_DISABLE0 * 32 +: 32 ] )
) ;
hqm_AW_register_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'hffffffff )
        , .W1C                  ( 1 )
) i_hqm_chp_target_cfg_dir_wd_disable1 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_chp_target_cfg_dir_wd_disable1_reg_nxt )
        , .reg_f                ( hqm_chp_target_cfg_dir_wd_disable1_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_DIR_WD_DISABLE1 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_DIR_WD_DISABLE1 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_DIR_WD_DISABLE1 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_DIR_WD_DISABLE1 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_DIR_WD_DISABLE1 * 32 +: 32 ] )
) ;
hqm_AW_register_enable_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h00000000 )
) i_hqm_chp_target_cfg_dir_wd_enb_interval (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_chp_target_cfg_dir_wd_enb_interval_reg_nxt )
        , .reg_f                ( hqm_chp_target_cfg_dir_wd_enb_interval_reg_f )
        , .reg_v                ( hqm_chp_target_cfg_dir_wd_enb_interval_reg_v )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_DIR_WD_ENB_INTERVAL ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_DIR_WD_ENB_INTERVAL ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_DIR_WD_ENB_INTERVAL ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_DIR_WD_ENB_INTERVAL ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_DIR_WD_ENB_INTERVAL * 32 +: 32 ] )
) ;
hqm_AW_status_wtcfg i_hqm_chp_target_cfg_dir_wd_irq0 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .status               ( hqm_chp_target_cfg_dir_wd_irq0_status )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_DIR_WD_IRQ0 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_DIR_WD_IRQ0 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_DIR_WD_IRQ0 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_DIR_WD_IRQ0 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_DIR_WD_IRQ0 * 32 +: 32 ] )
) ;
hqm_AW_status_wtcfg i_hqm_chp_target_cfg_dir_wd_irq1 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .status               ( hqm_chp_target_cfg_dir_wd_irq1_status )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_DIR_WD_IRQ1 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_DIR_WD_IRQ1 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_DIR_WD_IRQ1 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_DIR_WD_IRQ1 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_DIR_WD_IRQ1 * 32 +: 32 ] )
) ;
hqm_AW_register_enable_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h00000000 )
) i_hqm_chp_target_cfg_dir_wd_threshold (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_chp_target_cfg_dir_wd_threshold_reg_nxt )
        , .reg_f                ( hqm_chp_target_cfg_dir_wd_threshold_reg_f )
        , .reg_v                ( hqm_chp_target_cfg_dir_wd_threshold_reg_v )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_DIR_WD_THRESHOLD ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_DIR_WD_THRESHOLD ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_DIR_WD_THRESHOLD ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_DIR_WD_THRESHOLD ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_DIR_WD_THRESHOLD * 32 +: 32 ] )
) ;
hqm_AW_registerram_wtcfg #(
          .WIDTH                ( 1 )
        , .DEPTH                ( 64 )
        , .DEFAULT              ( 64'h0 )
        , .COPY                 ( 1 )
        , .CFG_READ_MASK        ( 1 )
) i_hqm_chp_target_cfg_hist_list_mode (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_load             ( hqm_chp_target_cfg_hist_list_mode_reg_load )
        , .reg_nxt              ( hqm_chp_target_cfg_hist_list_mode_reg_nxt )
        , .reg_f                ( hqm_chp_target_cfg_hist_list_mode_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_HIST_LIST_MODE ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_HIST_LIST_MODE ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_HIST_LIST_MODE ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_HIST_LIST_MODE ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_HIST_LIST_MODE * 32 +: 32 ] )
) ;
hqm_AW_register_enable_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h00000000 )
) i_hqm_chp_target_cfg_hw_agitate_control (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_chp_target_cfg_hw_agitate_control_reg_nxt )
        , .reg_f                ( hqm_chp_target_cfg_hw_agitate_control_reg_f )
        , .reg_v                ( hqm_chp_target_cfg_hw_agitate_control_reg_v )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_HW_AGITATE_CONTROL ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_HW_AGITATE_CONTROL ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_HW_AGITATE_CONTROL ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_HW_AGITATE_CONTROL ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_HW_AGITATE_CONTROL * 32 +: 32 ] )
) ;
hqm_AW_register_enable_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h00000000 )
) i_hqm_chp_target_cfg_hw_agitate_select (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_chp_target_cfg_hw_agitate_select_reg_nxt )
        , .reg_f                ( hqm_chp_target_cfg_hw_agitate_select_reg_f )
        , .reg_v                ( hqm_chp_target_cfg_hw_agitate_select_reg_v )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_HW_AGITATE_SELECT ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_HW_AGITATE_SELECT ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_HW_AGITATE_SELECT ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_HW_AGITATE_SELECT ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_HW_AGITATE_SELECT * 32 +: 32 ] )
) ;
hqm_AW_registerram_wtcfg #(
          .WIDTH                ( 6 )
        , .DEPTH                ( 64 )
        , .DEFAULT              ( { 64 { 6'h20 } } )
        , .COPY                 ( 1 )
        , .CFG_READ_MASK        ( 31 )
) i_hqm_chp_target_cfg_ldb_cq2vas (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_load             ( hqm_chp_target_cfg_ldb_cq2vas_reg_load )
        , .reg_nxt              ( hqm_chp_target_cfg_ldb_cq2vas_reg_nxt )
        , .reg_f                ( hqm_chp_target_cfg_ldb_cq2vas_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_LDB_CQ2VAS ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_LDB_CQ2VAS ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ2VAS ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ2VAS ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ2VAS * 32 +: 32 ] )
) ;
hqm_AW_register_enable_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h00000000 )
) i_hqm_chp_target_cfg_ldb_cq_intr_armed0 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_chp_target_cfg_ldb_cq_intr_armed0_reg_nxt )
        , .reg_f                ( hqm_chp_target_cfg_ldb_cq_intr_armed0_reg_f )
        , .reg_v                ( hqm_chp_target_cfg_ldb_cq_intr_armed0_reg_v )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_LDB_CQ_INTR_ARMED0 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_LDB_CQ_INTR_ARMED0 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ_INTR_ARMED0 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ_INTR_ARMED0 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ_INTR_ARMED0 * 32 +: 32 ] )
) ;
hqm_AW_register_enable_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h00000000 )
) i_hqm_chp_target_cfg_ldb_cq_intr_armed1 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_chp_target_cfg_ldb_cq_intr_armed1_reg_nxt )
        , .reg_f                ( hqm_chp_target_cfg_ldb_cq_intr_armed1_reg_f )
        , .reg_v                ( hqm_chp_target_cfg_ldb_cq_intr_armed1_reg_v )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_LDB_CQ_INTR_ARMED1 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_LDB_CQ_INTR_ARMED1 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ_INTR_ARMED1 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ_INTR_ARMED1 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ_INTR_ARMED1 * 32 +: 32 ] )
) ;
hqm_AW_status_wtcfg i_hqm_chp_target_cfg_ldb_cq_intr_expired0 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .status               ( hqm_chp_target_cfg_ldb_cq_intr_expired0_status )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_LDB_CQ_INTR_EXPIRED0 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_LDB_CQ_INTR_EXPIRED0 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ_INTR_EXPIRED0 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ_INTR_EXPIRED0 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ_INTR_EXPIRED0 * 32 +: 32 ] )
) ;
hqm_AW_status_wtcfg i_hqm_chp_target_cfg_ldb_cq_intr_expired1 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .status               ( hqm_chp_target_cfg_ldb_cq_intr_expired1_status )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_LDB_CQ_INTR_EXPIRED1 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_LDB_CQ_INTR_EXPIRED1 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ_INTR_EXPIRED1 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ_INTR_EXPIRED1 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ_INTR_EXPIRED1 * 32 +: 32 ] )
) ;
hqm_AW_status_wtcfg i_hqm_chp_target_cfg_ldb_cq_intr_irq0 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .status               ( hqm_chp_target_cfg_ldb_cq_intr_irq0_status )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_LDB_CQ_INTR_IRQ0 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_LDB_CQ_INTR_IRQ0 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ_INTR_IRQ0 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ_INTR_IRQ0 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ_INTR_IRQ0 * 32 +: 32 ] )
) ;
hqm_AW_status_wtcfg i_hqm_chp_target_cfg_ldb_cq_intr_irq1 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .status               ( hqm_chp_target_cfg_ldb_cq_intr_irq1_status )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_LDB_CQ_INTR_IRQ1 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_LDB_CQ_INTR_IRQ1 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ_INTR_IRQ1 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ_INTR_IRQ1 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ_INTR_IRQ1 * 32 +: 32 ] )
) ;
hqm_AW_status_wtcfg i_hqm_chp_target_cfg_ldb_cq_intr_run_timer0 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .status               ( hqm_chp_target_cfg_ldb_cq_intr_run_timer0_status )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_LDB_CQ_INTR_RUN_TIMER0 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_LDB_CQ_INTR_RUN_TIMER0 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ_INTR_RUN_TIMER0 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ_INTR_RUN_TIMER0 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ_INTR_RUN_TIMER0 * 32 +: 32 ] )
) ;
hqm_AW_status_wtcfg i_hqm_chp_target_cfg_ldb_cq_intr_run_timer1 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .status               ( hqm_chp_target_cfg_ldb_cq_intr_run_timer1_status )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_LDB_CQ_INTR_RUN_TIMER1 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_LDB_CQ_INTR_RUN_TIMER1 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ_INTR_RUN_TIMER1 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ_INTR_RUN_TIMER1 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ_INTR_RUN_TIMER1 * 32 +: 32 ] )
) ;
hqm_AW_status_wtcfg i_hqm_chp_target_cfg_ldb_cq_intr_urgent0 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .status               ( hqm_chp_target_cfg_ldb_cq_intr_urgent0_status )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_LDB_CQ_INTR_URGENT0 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_LDB_CQ_INTR_URGENT0 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ_INTR_URGENT0 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ_INTR_URGENT0 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ_INTR_URGENT0 * 32 +: 32 ] )
) ;
hqm_AW_status_wtcfg i_hqm_chp_target_cfg_ldb_cq_intr_urgent1 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .status               ( hqm_chp_target_cfg_ldb_cq_intr_urgent1_status )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_LDB_CQ_INTR_URGENT1 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_LDB_CQ_INTR_URGENT1 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ_INTR_URGENT1 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ_INTR_URGENT1 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ_INTR_URGENT1 * 32 +: 32 ] )
) ;
hqm_AW_registerram_wtcfg #(
          .WIDTH                ( 2 )
        , .DEPTH                ( 64 )
        , .DEFAULT              ( 128'h0 )
        , .COPY                 ( 1 )
        , .CFG_READ_MASK        ( 3 )
) i_hqm_chp_target_cfg_ldb_cq_int_enb (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_load             ( hqm_chp_target_cfg_ldb_cq_int_enb_reg_load )
        , .reg_nxt              ( hqm_chp_target_cfg_ldb_cq_int_enb_reg_nxt )
        , .reg_f                ( hqm_chp_target_cfg_ldb_cq_int_enb_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_LDB_CQ_INT_ENB ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_LDB_CQ_INT_ENB ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ_INT_ENB ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ_INT_ENB ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ_INT_ENB * 32 +: 32 ] )
) ;
hqm_AW_registerram_wtcfg #(
          .WIDTH                ( 1 )
        , .DEPTH                ( 64 )
        , .DEFAULT              ( {64{1'b0}} )
        , .COPY                 ( 1 )
        , .CFG_READ_MASK        ( 1 )
) i_hqm_chp_target_cfg_ldb_cq_int_mask (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_load             ( hqm_chp_target_cfg_ldb_cq_int_mask_reg_load )
        , .reg_nxt              ( hqm_chp_target_cfg_ldb_cq_int_mask_reg_nxt )
        , .reg_f                ( hqm_chp_target_cfg_ldb_cq_int_mask_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_LDB_CQ_INT_MASK ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_LDB_CQ_INT_MASK ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ_INT_MASK ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ_INT_MASK ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ_INT_MASK * 32 +: 32 ] )
) ;
hqm_AW_registerram_wtcfg #(
          .WIDTH                ( 1 )
        , .DEPTH                ( 64 )
        , .DEFAULT              ( {64{1'b0}} )
        , .COPY                 ( 1 )
        , .CFG_READ_MASK        ( 1 )
) i_hqm_chp_target_cfg_ldb_cq_irq_pending (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_load             ( hqm_chp_target_cfg_ldb_cq_irq_pending_reg_load )
        , .reg_nxt              ( hqm_chp_target_cfg_ldb_cq_irq_pending_reg_nxt )
        , .reg_f                ( hqm_chp_target_cfg_ldb_cq_irq_pending_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_LDB_CQ_IRQ_PENDING ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_LDB_CQ_IRQ_PENDING ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ_IRQ_PENDING ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ_IRQ_PENDING ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ_IRQ_PENDING * 32 +: 32 ] )
) ;
hqm_AW_register_enable_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h00000000 )
) i_hqm_chp_target_cfg_ldb_cq_timer_ctl (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_chp_target_cfg_ldb_cq_timer_ctl_reg_nxt )
        , .reg_f                ( hqm_chp_target_cfg_ldb_cq_timer_ctl_reg_f )
        , .reg_v                ( hqm_chp_target_cfg_ldb_cq_timer_ctl_reg_v )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_LDB_CQ_TIMER_CTL ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_LDB_CQ_TIMER_CTL ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ_TIMER_CTL ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ_TIMER_CTL ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ_TIMER_CTL * 32 +: 32 ] )
) ;
hqm_AW_registerram_wtcfg #(
          .WIDTH                ( 1 )
        , .DEPTH                ( 64 )
        , .DEFAULT              ( 64'h00000000 )
        , .COPY                 ( 1 )
        , .CFG_READ_MASK        ( 1 )
) i_hqm_chp_target_cfg_ldb_cq_wd_enb (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_load             ( hqm_chp_target_cfg_ldb_cq_wd_enb_reg_load )
        , .reg_nxt              ( hqm_chp_target_cfg_ldb_cq_wd_enb_reg_nxt )
        , .reg_f                ( hqm_chp_target_cfg_ldb_cq_wd_enb_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_LDB_CQ_WD_ENB ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_LDB_CQ_WD_ENB ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ_WD_ENB ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ_WD_ENB ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_LDB_CQ_WD_ENB * 32 +: 32 ] )
) ;
hqm_AW_status_wtcfg i_hqm_chp_target_cfg_ldb_wdrt_0 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .status               ( hqm_chp_target_cfg_ldb_wdrt_0_status )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_LDB_WDRT_0 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_LDB_WDRT_0 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_LDB_WDRT_0 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_LDB_WDRT_0 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_LDB_WDRT_0 * 32 +: 32 ] )
) ;
hqm_AW_status_wtcfg i_hqm_chp_target_cfg_ldb_wdrt_1 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .status               ( hqm_chp_target_cfg_ldb_wdrt_1_status )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_LDB_WDRT_1 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_LDB_WDRT_1 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_LDB_WDRT_1 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_LDB_WDRT_1 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_LDB_WDRT_1 * 32 +: 32 ] )
) ;
hqm_AW_register_sticky_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h00000000 )
        , .W1C                  ( 1 )
) i_hqm_chp_target_cfg_ldb_wdto_0 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_chp_target_cfg_ldb_wdto_0_reg_nxt )
        , .reg_f                ( hqm_chp_target_cfg_ldb_wdto_0_reg_f )
        , .load                 ( hqm_chp_target_cfg_ldb_wdto_0_reg_load )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_LDB_WDTO_0 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_LDB_WDTO_0 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_LDB_WDTO_0 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_LDB_WDTO_0 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_LDB_WDTO_0 * 32 +: 32 ] )
) ;
hqm_AW_register_sticky_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h00000000 )
        , .W1C                  ( 1 )
) i_hqm_chp_target_cfg_ldb_wdto_1 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_chp_target_cfg_ldb_wdto_1_reg_nxt )
        , .reg_f                ( hqm_chp_target_cfg_ldb_wdto_1_reg_f )
        , .load                 ( hqm_chp_target_cfg_ldb_wdto_1_reg_load )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_LDB_WDTO_1 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_LDB_WDTO_1 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_LDB_WDTO_1 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_LDB_WDTO_1 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_LDB_WDTO_1 * 32 +: 32 ] )
) ;
hqm_AW_register_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'hffffffff )
        , .W1C                  ( 1 )
) i_hqm_chp_target_cfg_ldb_wd_disable0 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_chp_target_cfg_ldb_wd_disable0_reg_nxt )
        , .reg_f                ( hqm_chp_target_cfg_ldb_wd_disable0_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_LDB_WD_DISABLE0 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_LDB_WD_DISABLE0 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_LDB_WD_DISABLE0 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_LDB_WD_DISABLE0 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_LDB_WD_DISABLE0 * 32 +: 32 ] )
) ;
hqm_AW_register_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'hffffffff )
        , .W1C                  ( 1 )
) i_hqm_chp_target_cfg_ldb_wd_disable1 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_chp_target_cfg_ldb_wd_disable1_reg_nxt )
        , .reg_f                ( hqm_chp_target_cfg_ldb_wd_disable1_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_LDB_WD_DISABLE1 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_LDB_WD_DISABLE1 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_LDB_WD_DISABLE1 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_LDB_WD_DISABLE1 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_LDB_WD_DISABLE1 * 32 +: 32 ] )
) ;
hqm_AW_register_enable_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h00000000 )
) i_hqm_chp_target_cfg_ldb_wd_enb_interval (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_chp_target_cfg_ldb_wd_enb_interval_reg_nxt )
        , .reg_f                ( hqm_chp_target_cfg_ldb_wd_enb_interval_reg_f )
        , .reg_v                ( hqm_chp_target_cfg_ldb_wd_enb_interval_reg_v )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_LDB_WD_ENB_INTERVAL ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_LDB_WD_ENB_INTERVAL ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_LDB_WD_ENB_INTERVAL ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_LDB_WD_ENB_INTERVAL ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_LDB_WD_ENB_INTERVAL * 32 +: 32 ] )
) ;
hqm_AW_status_wtcfg i_hqm_chp_target_cfg_ldb_wd_irq0 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .status               ( hqm_chp_target_cfg_ldb_wd_irq0_status )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_LDB_WD_IRQ0 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_LDB_WD_IRQ0 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_LDB_WD_IRQ0 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_LDB_WD_IRQ0 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_LDB_WD_IRQ0 * 32 +: 32 ] )
) ;
hqm_AW_status_wtcfg i_hqm_chp_target_cfg_ldb_wd_irq1 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .status               ( hqm_chp_target_cfg_ldb_wd_irq1_status )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_LDB_WD_IRQ1 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_LDB_WD_IRQ1 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_LDB_WD_IRQ1 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_LDB_WD_IRQ1 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_LDB_WD_IRQ1 * 32 +: 32 ] )
) ;
hqm_AW_register_enable_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h00000000 )
) i_hqm_chp_target_cfg_ldb_wd_threshold (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_chp_target_cfg_ldb_wd_threshold_reg_nxt )
        , .reg_f                ( hqm_chp_target_cfg_ldb_wd_threshold_reg_f )
        , .reg_v                ( hqm_chp_target_cfg_ldb_wd_threshold_reg_v )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_LDB_WD_THRESHOLD ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_LDB_WD_THRESHOLD ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_LDB_WD_THRESHOLD ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_LDB_WD_THRESHOLD ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_LDB_WD_THRESHOLD * 32 +: 32 ] )
) ;
hqm_AW_register_enable_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h00000740 )
) i_hqm_chp_target_cfg_patch_control (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_chp_target_cfg_patch_control_reg_nxt )
        , .reg_f                ( hqm_chp_target_cfg_patch_control_reg_f )
        , .reg_v                ( hqm_chp_target_cfg_patch_control_reg_v )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_PATCH_CONTROL ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_PATCH_CONTROL ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_PATCH_CONTROL ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_PATCH_CONTROL ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_PATCH_CONTROL * 32 +: 32 ] )
) ;
hqm_AW_status_wtcfg i_hqm_chp_target_cfg_pipe_health_hold (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .status               ( hqm_chp_target_cfg_pipe_health_hold_status )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_PIPE_HEALTH_HOLD ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_PIPE_HEALTH_HOLD ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_PIPE_HEALTH_HOLD ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_PIPE_HEALTH_HOLD ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_PIPE_HEALTH_HOLD * 32 +: 32 ] )
) ;
hqm_AW_status_wtcfg i_hqm_chp_target_cfg_pipe_health_valid (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .status               ( hqm_chp_target_cfg_pipe_health_valid_status )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_PIPE_HEALTH_VALID ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_PIPE_HEALTH_VALID ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_PIPE_HEALTH_VALID ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_PIPE_HEALTH_VALID ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_PIPE_HEALTH_VALID * 32 +: 32 ] )
) ;
hqm_AW_status_wtcfg i_hqm_chp_target_cfg_retn_zero (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .status               ( hqm_chp_target_cfg_retn_zero_status )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_RETN_ZERO ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_RETN_ZERO ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_RETN_ZERO ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_RETN_ZERO ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_RETN_ZERO * 32 +: 32 ] )
) ;
hqm_AW_syndrome_wtcfg i_hqm_chp_target_cfg_syndrome_00 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_SYNDROME_00 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_SYNDROME_00 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_SYNDROME_00 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_SYNDROME_00 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_SYNDROME_00 * 32 +: 32 ] )
        , .capture_v            ( hqm_chp_target_cfg_syndrome_00_capture_v )
        , .capture_data         ( hqm_chp_target_cfg_syndrome_00_capture_data )
        , .syndrome_data        ( hqm_chp_target_cfg_syndrome_00_syndrome_data )
) ;
hqm_AW_syndrome_wtcfg i_hqm_chp_target_cfg_syndrome_01 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_SYNDROME_01 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_SYNDROME_01 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_SYNDROME_01 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_SYNDROME_01 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_SYNDROME_01 * 32 +: 32 ] )
        , .capture_v            ( hqm_chp_target_cfg_syndrome_01_capture_v )
        , .capture_data         ( hqm_chp_target_cfg_syndrome_01_capture_data )
        , .syndrome_data        ( hqm_chp_target_cfg_syndrome_01_syndrome_data )
) ;
hqm_AW_register_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h00000003 )
) i_hqm_chp_target_cfg_unit_idle (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_chp_target_cfg_unit_idle_reg_nxt )
        , .reg_f                ( hqm_chp_target_cfg_unit_idle_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_UNIT_IDLE ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_UNIT_IDLE ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_UNIT_IDLE ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_UNIT_IDLE ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_UNIT_IDLE * 32 +: 32 ] )
) ;
hqm_AW_register_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( HQM_UNIT_TIMEOUT_DEFAULT )
) i_hqm_chp_target_cfg_unit_timeout (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_chp_target_cfg_unit_timeout_reg_nxt )
        , .reg_f                ( hqm_chp_target_cfg_unit_timeout_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_UNIT_TIMEOUT ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_UNIT_TIMEOUT ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_UNIT_TIMEOUT ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_UNIT_TIMEOUT ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_UNIT_TIMEOUT * 32 +: 32 ] )
) ;
hqm_AW_status_wtcfg i_hqm_chp_target_cfg_unit_version (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .status               ( hqm_chp_target_cfg_unit_version_status )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_UNIT_VERSION ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_UNIT_VERSION ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_UNIT_VERSION ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_UNIT_VERSION ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_UNIT_VERSION * 32 +: 32 ] )
) ;
hqm_AW_registerram_wres_wtcfg #(
          .WIDTH                ( 17 )
        , .DEPTH                ( 32 )
        , .DEFAULT              ( { 32 { 17'h00000 } } )
        , .COPY                 ( 1 )
        , .CFG_READ_MASK        ( 32767 )
) i_hqm_chp_target_cfg_vas_credit_count (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_load             ( hqm_chp_target_cfg_vas_credit_count_reg_load )
        , .reg_nxt              ( hqm_chp_target_cfg_vas_credit_count_reg_nxt )
        , .reg_f                ( hqm_chp_target_cfg_vas_credit_count_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_CHP_TARGET_CFG_VAS_CREDIT_COUNT ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_CHP_TARGET_CFG_VAS_CREDIT_COUNT ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_CHP_TARGET_CFG_VAS_CREDIT_COUNT ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_CHP_TARGET_CFG_VAS_CREDIT_COUNT ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_CHP_TARGET_CFG_VAS_CREDIT_COUNT * 32 +: 32 ] )
) ;
assign mux_cfg_rsp_ack_pnc [ (HQM_CHP_TARGET_CFG_CMP_SN_CHK_ENBL * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_CHP_TARGET_CFG_CMP_SN_CHK_ENBL * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_CHP_TARGET_CFG_CMP_SN_CHK_ENBL * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_CHP_TARGET_CFG_DIR_CQ_DEPTH * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_CHP_TARGET_CFG_DIR_CQ_DEPTH * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_CHP_TARGET_CFG_DIR_CQ_DEPTH * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_CHP_TARGET_CFG_DIR_CQ_INT_DEPTH_THRSH * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_CHP_TARGET_CFG_DIR_CQ_INT_DEPTH_THRSH * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_CHP_TARGET_CFG_DIR_CQ_INT_DEPTH_THRSH * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_CHP_TARGET_CFG_DIR_CQ_TIMER_COUNT * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_CHP_TARGET_CFG_DIR_CQ_TIMER_COUNT * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_CHP_TARGET_CFG_DIR_CQ_TIMER_COUNT * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_CHP_TARGET_CFG_DIR_CQ_TIMER_THRESHOLD * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_CHP_TARGET_CFG_DIR_CQ_TIMER_THRESHOLD * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_CHP_TARGET_CFG_DIR_CQ_TIMER_THRESHOLD * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_CHP_TARGET_CFG_DIR_CQ_TOKEN_DEPTH_SELECT * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_CHP_TARGET_CFG_DIR_CQ_TOKEN_DEPTH_SELECT * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_CHP_TARGET_CFG_DIR_CQ_TOKEN_DEPTH_SELECT * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_CHP_TARGET_CFG_DIR_CQ_WPTR * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_CHP_TARGET_CFG_DIR_CQ_WPTR * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_CHP_TARGET_CFG_DIR_CQ_WPTR * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_CHP_TARGET_CFG_FREELIST_0 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_CHP_TARGET_CFG_FREELIST_0 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_CHP_TARGET_CFG_FREELIST_0 * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_CHP_TARGET_CFG_FREELIST_1 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_CHP_TARGET_CFG_FREELIST_1 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_CHP_TARGET_CFG_FREELIST_1 * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_CHP_TARGET_CFG_FREELIST_2 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_CHP_TARGET_CFG_FREELIST_2 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_CHP_TARGET_CFG_FREELIST_2 * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_CHP_TARGET_CFG_FREELIST_3 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_CHP_TARGET_CFG_FREELIST_3 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_CHP_TARGET_CFG_FREELIST_3 * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_CHP_TARGET_CFG_FREELIST_4 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_CHP_TARGET_CFG_FREELIST_4 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_CHP_TARGET_CFG_FREELIST_4 * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_CHP_TARGET_CFG_FREELIST_5 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_CHP_TARGET_CFG_FREELIST_5 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_CHP_TARGET_CFG_FREELIST_5 * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_CHP_TARGET_CFG_FREELIST_6 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_CHP_TARGET_CFG_FREELIST_6 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_CHP_TARGET_CFG_FREELIST_6 * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_CHP_TARGET_CFG_FREELIST_7 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_CHP_TARGET_CFG_FREELIST_7 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_CHP_TARGET_CFG_FREELIST_7 * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_CHP_TARGET_CFG_HIST_LIST_0 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_CHP_TARGET_CFG_HIST_LIST_0 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_CHP_TARGET_CFG_HIST_LIST_0 * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_CHP_TARGET_CFG_HIST_LIST_1 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_CHP_TARGET_CFG_HIST_LIST_1 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_CHP_TARGET_CFG_HIST_LIST_1 * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_CHP_TARGET_CFG_HIST_LIST_A_0 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_CHP_TARGET_CFG_HIST_LIST_A_0 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_CHP_TARGET_CFG_HIST_LIST_A_0 * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_CHP_TARGET_CFG_HIST_LIST_A_1 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_CHP_TARGET_CFG_HIST_LIST_A_1 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_CHP_TARGET_CFG_HIST_LIST_A_1 * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_CHP_TARGET_CFG_HIST_LIST_A_BASE * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_CHP_TARGET_CFG_HIST_LIST_A_BASE * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_CHP_TARGET_CFG_HIST_LIST_A_BASE * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_CHP_TARGET_CFG_HIST_LIST_A_LIMIT * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_CHP_TARGET_CFG_HIST_LIST_A_LIMIT * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_CHP_TARGET_CFG_HIST_LIST_A_LIMIT * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_CHP_TARGET_CFG_HIST_LIST_A_POP_PTR * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_CHP_TARGET_CFG_HIST_LIST_A_POP_PTR * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_CHP_TARGET_CFG_HIST_LIST_A_POP_PTR * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_CHP_TARGET_CFG_HIST_LIST_A_PUSH_PTR * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_CHP_TARGET_CFG_HIST_LIST_A_PUSH_PTR * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_CHP_TARGET_CFG_HIST_LIST_A_PUSH_PTR * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_CHP_TARGET_CFG_HIST_LIST_BASE * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_CHP_TARGET_CFG_HIST_LIST_BASE * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_CHP_TARGET_CFG_HIST_LIST_BASE * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_CHP_TARGET_CFG_HIST_LIST_LIMIT * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_CHP_TARGET_CFG_HIST_LIST_LIMIT * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_CHP_TARGET_CFG_HIST_LIST_LIMIT * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_CHP_TARGET_CFG_HIST_LIST_POP_PTR * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_CHP_TARGET_CFG_HIST_LIST_POP_PTR * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_CHP_TARGET_CFG_HIST_LIST_POP_PTR * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_CHP_TARGET_CFG_HIST_LIST_PUSH_PTR * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_CHP_TARGET_CFG_HIST_LIST_PUSH_PTR * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_CHP_TARGET_CFG_HIST_LIST_PUSH_PTR * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_CHP_TARGET_CFG_LDB_CQ_DEPTH * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_CHP_TARGET_CFG_LDB_CQ_DEPTH * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_CHP_TARGET_CFG_LDB_CQ_DEPTH * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_CHP_TARGET_CFG_LDB_CQ_INT_DEPTH_THRSH * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_CHP_TARGET_CFG_LDB_CQ_INT_DEPTH_THRSH * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_CHP_TARGET_CFG_LDB_CQ_INT_DEPTH_THRSH * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_CHP_TARGET_CFG_LDB_CQ_ON_OFF_THRESHOLD * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_CHP_TARGET_CFG_LDB_CQ_ON_OFF_THRESHOLD * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_CHP_TARGET_CFG_LDB_CQ_ON_OFF_THRESHOLD * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_CHP_TARGET_CFG_LDB_CQ_TIMER_COUNT * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_CHP_TARGET_CFG_LDB_CQ_TIMER_COUNT * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_CHP_TARGET_CFG_LDB_CQ_TIMER_COUNT * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_CHP_TARGET_CFG_LDB_CQ_TIMER_THRESHOLD * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_CHP_TARGET_CFG_LDB_CQ_TIMER_THRESHOLD * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_CHP_TARGET_CFG_LDB_CQ_TIMER_THRESHOLD * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_CHP_TARGET_CFG_LDB_CQ_TOKEN_DEPTH_SELECT * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_CHP_TARGET_CFG_LDB_CQ_TOKEN_DEPTH_SELECT * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_CHP_TARGET_CFG_LDB_CQ_TOKEN_DEPTH_SELECT * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_CHP_TARGET_CFG_LDB_CQ_WPTR * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_CHP_TARGET_CFG_LDB_CQ_WPTR * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_CHP_TARGET_CFG_LDB_CQ_WPTR * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_CHP_TARGET_CFG_ORD_QID_SN * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_CHP_TARGET_CFG_ORD_QID_SN * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_CHP_TARGET_CFG_ORD_QID_SN * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_CHP_TARGET_CFG_ORD_QID_SN_MAP * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_CHP_TARGET_CFG_ORD_QID_SN_MAP * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_CHP_TARGET_CFG_ORD_QID_SN_MAP * 32 ) +: 32 ] = '0 ;
endmodule
