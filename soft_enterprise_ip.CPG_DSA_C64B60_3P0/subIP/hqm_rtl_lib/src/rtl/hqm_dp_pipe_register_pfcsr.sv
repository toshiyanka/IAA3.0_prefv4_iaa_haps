module hqm_dp_pipe_register_pfcsr
import hqm_AW_pkg::* , hqm_pkg::* , hqm_core_pkg::* ;
(
  input logic hqm_gated_clk
, input logic hqm_gated_rst_n
, input logic rst_prep 
, input logic [ ( HQM_DP_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] cfg_req_write 
, input logic [ ( HQM_DP_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] cfg_req_read 
, input cfg_req_t cfg_req 
, output logic cfg_rsp_ack 
, output logic cfg_rsp_err 
, output logic [ ( 32 ) - 1 : 0 ] cfg_rsp_rdata 
, input logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_control_arb_weights_tqpri_dir_0_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_control_arb_weights_tqpri_dir_0_reg_f
, input logic hqm_dp_target_cfg_control_arb_weights_tqpri_dir_0_reg_v
, input logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_control_arb_weights_tqpri_dir_1_status
, input logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_control_arb_weights_tqpri_replay_0_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_control_arb_weights_tqpri_replay_0_reg_f
, input logic hqm_dp_target_cfg_control_arb_weights_tqpri_replay_0_reg_v
, input logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_control_arb_weights_tqpri_replay_1_status
, input logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_control_general_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_control_general_reg_f
, input logic hqm_dp_target_cfg_control_general_reg_v
, input logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_control_pipeline_credits_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_control_pipeline_credits_reg_f
, input logic hqm_dp_target_cfg_control_pipeline_credits_reg_v
, input logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_detect_feature_operation_00_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_detect_feature_operation_00_reg_f
, input logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_detect_feature_operation_01_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_detect_feature_operation_01_reg_f
, input logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_diagnostic_aw_status_status
, input logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_diagnostic_aw_status_01_status
, input logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_diagnostic_aw_status_02_status
, input logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_dir_csr_control_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_dir_csr_control_reg_f
, input logic hqm_dp_target_cfg_dir_csr_control_reg_v
, input logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_error_inject_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_error_inject_reg_f
, input logic hqm_dp_target_cfg_error_inject_reg_v
, input logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_fifo_wmstat_dp_dqed_if_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_fifo_wmstat_dp_dqed_if_reg_f
, input logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_fifo_wmstat_dp_lsp_enq_dir_if_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_fifo_wmstat_dp_lsp_enq_dir_if_reg_f
, input logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_fifo_wmstat_dp_lsp_enq_rorply_if_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_fifo_wmstat_dp_lsp_enq_rorply_if_reg_f
, input logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_fifo_wmstat_lsp_dp_sch_dir_if_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_fifo_wmstat_lsp_dp_sch_dir_if_reg_f
, input logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_fifo_wmstat_lsp_dp_sch_rorply_if_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_fifo_wmstat_lsp_dp_sch_rorply_if_reg_f
, input logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_fifo_wmstat_rop_dp_enq_dir_if_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_fifo_wmstat_rop_dp_enq_dir_if_reg_f
, input logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_fifo_wmstat_rop_dp_enq_ro_if_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_fifo_wmstat_rop_dp_enq_ro_if_reg_f
, input logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_hw_agitate_control_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_hw_agitate_control_reg_f
, input logic hqm_dp_target_cfg_hw_agitate_control_reg_v
, input logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_hw_agitate_select_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_hw_agitate_select_reg_f
, input logic hqm_dp_target_cfg_hw_agitate_select_reg_v
, input logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_interface_status_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_interface_status_reg_f
, input logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_patch_control_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_patch_control_reg_f
, input logic hqm_dp_target_cfg_patch_control_reg_v
, input logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_pipe_health_hold_00_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_pipe_health_hold_00_reg_f
, input logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_pipe_health_valid_00_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_pipe_health_valid_00_reg_f
, input logic hqm_dp_target_cfg_smon_disable_smon
, input logic [ 24 - 1 : 0 ] hqm_dp_target_cfg_smon_smon_v
, input logic [ ( 24 * 32 ) - 1 : 0 ] hqm_dp_target_cfg_smon_smon_comp
, input logic [ ( 24 * 32 ) - 1 : 0 ] hqm_dp_target_cfg_smon_smon_val
, output logic hqm_dp_target_cfg_smon_smon_enabled
, output logic hqm_dp_target_cfg_smon_smon_interrupt
, input logic hqm_dp_target_cfg_syndrome_00_capture_v
, input logic [ ( 31 ) - 1 : 0] hqm_dp_target_cfg_syndrome_00_capture_data
, output logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_syndrome_00_syndrome_data
, input logic hqm_dp_target_cfg_syndrome_01_capture_v
, input logic [ ( 31 ) - 1 : 0] hqm_dp_target_cfg_syndrome_01_capture_data
, output logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_syndrome_01_syndrome_data
, input logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_unit_idle_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_unit_idle_reg_f
, input logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_unit_timeout_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_unit_timeout_reg_f
, input logic [ ( 32 ) - 1 : 0] hqm_dp_target_cfg_unit_version_status
);
logic [ ( HQM_DP_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] mux_cfg_req_write ;
logic [ ( HQM_DP_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] mux_cfg_req_read ;
cfg_req_t mux_cfg_req ;
logic [ ( HQM_DP_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] mux_cfg_rsp_ack_pnc ;
logic [ ( HQM_DP_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] mux_cfg_rsp_err_pnc ;
logic [ ( HQM_DP_CFG_UNIT_NUM_TGTS * 32 ) - 1 : 0 ] mux_cfg_rsp_rdata_pnc ;
always_comb begin
  mux_cfg_req_write = cfg_req_write ;
  mux_cfg_req_read = cfg_req_read ;
  mux_cfg_req = cfg_req ;
end
hqm_AW_cfg_rsp #(
    .NUM_TGTS ( 39 )
) i_hqm_AW_cfg_rsp_0 (
    .clk ( hqm_gated_clk )
  , .rst_n ( hqm_gated_rst_n )
  , .in_cfg_rsp_ack ( {
                        mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_DIR_0 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_DIR_1 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_REPLAY_0 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_REPLAY_1 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_CONTROL_GENERAL ]
                      , mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_CONTROL_PIPELINE_CREDITS ]
                      , mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_DETECT_FEATURE_OPERATION_00 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_DETECT_FEATURE_OPERATION_01 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_DIAGNOSTIC_AW_STATUS ]
                      , mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_DIAGNOSTIC_AW_STATUS_01 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_DIAGNOSTIC_AW_STATUS_02 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_DIR_CSR_CONTROL ]
                      , mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_ERROR_INJECT ]
                      , mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_FIFO_WMSTAT_DP_DQED_IF ]
                      , mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_FIFO_WMSTAT_DP_LSP_ENQ_DIR_IF ]
                      , mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_FIFO_WMSTAT_DP_LSP_ENQ_RORPLY_IF ]
                      , mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_FIFO_WMSTAT_LSP_DP_SCH_DIR_IF ]
                      , mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_FIFO_WMSTAT_LSP_DP_SCH_RORPLY_IF ]
                      , mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_FIFO_WMSTAT_ROP_DP_ENQ_DIR_IF ]
                      , mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_FIFO_WMSTAT_ROP_DP_ENQ_RO_IF ]
                      , mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_HW_AGITATE_CONTROL ]
                      , mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_HW_AGITATE_SELECT ]
                      , mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_INTERFACE_STATUS ]
                      , mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_PATCH_CONTROL ]
                      , mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_PIPE_HEALTH_HOLD_00 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_PIPE_HEALTH_VALID_00 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_SMON_ACTIVITYCOUNTER0 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_SMON_ACTIVITYCOUNTER1 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_SMON_COMPARE0 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_SMON_COMPARE1 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_SMON_CONFIGURATION0 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_SMON_CONFIGURATION1 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_SMON_MAXIMUM_TIMER ]
                      , mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_SMON_TIMER ]
                      , mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_SYNDROME_00 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_SYNDROME_01 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_UNIT_IDLE ]
                      , mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_UNIT_TIMEOUT ]
                      , mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_UNIT_VERSION ]
                      } )
  , .in_cfg_rsp_err ( {
                        mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_DIR_0 ]
                      , mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_DIR_1 ]
                      , mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_REPLAY_0 ]
                      , mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_REPLAY_1 ]
                      , mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_CONTROL_GENERAL ]
                      , mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_CONTROL_PIPELINE_CREDITS ]
                      , mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_DETECT_FEATURE_OPERATION_00 ]
                      , mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_DETECT_FEATURE_OPERATION_01 ]
                      , mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_DIAGNOSTIC_AW_STATUS ]
                      , mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_DIAGNOSTIC_AW_STATUS_01 ]
                      , mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_DIAGNOSTIC_AW_STATUS_02 ]
                      , mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_DIR_CSR_CONTROL ]
                      , mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_ERROR_INJECT ]
                      , mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_FIFO_WMSTAT_DP_DQED_IF ]
                      , mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_FIFO_WMSTAT_DP_LSP_ENQ_DIR_IF ]
                      , mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_FIFO_WMSTAT_DP_LSP_ENQ_RORPLY_IF ]
                      , mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_FIFO_WMSTAT_LSP_DP_SCH_DIR_IF ]
                      , mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_FIFO_WMSTAT_LSP_DP_SCH_RORPLY_IF ]
                      , mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_FIFO_WMSTAT_ROP_DP_ENQ_DIR_IF ]
                      , mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_FIFO_WMSTAT_ROP_DP_ENQ_RO_IF ]
                      , mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_HW_AGITATE_CONTROL ]
                      , mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_HW_AGITATE_SELECT ]
                      , mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_INTERFACE_STATUS ]
                      , mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_PATCH_CONTROL ]
                      , mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_PIPE_HEALTH_HOLD_00 ]
                      , mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_PIPE_HEALTH_VALID_00 ]
                      , mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_SMON_ACTIVITYCOUNTER0 ]
                      , mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_SMON_ACTIVITYCOUNTER1 ]
                      , mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_SMON_COMPARE0 ]
                      , mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_SMON_COMPARE1 ]
                      , mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_SMON_CONFIGURATION0 ]
                      , mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_SMON_CONFIGURATION1 ]
                      , mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_SMON_MAXIMUM_TIMER ]
                      , mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_SMON_TIMER ]
                      , mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_SYNDROME_00 ]
                      , mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_SYNDROME_01 ]
                      , mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_UNIT_IDLE ]
                      , mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_UNIT_TIMEOUT ]
                      , mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_UNIT_VERSION ]
                      } )
  , .in_cfg_rsp_rdata ( {
                        mux_cfg_rsp_rdata_pnc [ ( HQM_DP_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_DIR_0 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_DP_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_DIR_1 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_DP_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_REPLAY_0 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_DP_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_REPLAY_1 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_DP_TARGET_CFG_CONTROL_GENERAL * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_DP_TARGET_CFG_CONTROL_PIPELINE_CREDITS * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_DP_TARGET_CFG_DETECT_FEATURE_OPERATION_00 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_DP_TARGET_CFG_DETECT_FEATURE_OPERATION_01 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_DP_TARGET_CFG_DIAGNOSTIC_AW_STATUS * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_DP_TARGET_CFG_DIAGNOSTIC_AW_STATUS_01 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_DP_TARGET_CFG_DIAGNOSTIC_AW_STATUS_02 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_DP_TARGET_CFG_DIR_CSR_CONTROL * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_DP_TARGET_CFG_ERROR_INJECT * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_DP_TARGET_CFG_FIFO_WMSTAT_DP_DQED_IF * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_DP_TARGET_CFG_FIFO_WMSTAT_DP_LSP_ENQ_DIR_IF * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_DP_TARGET_CFG_FIFO_WMSTAT_DP_LSP_ENQ_RORPLY_IF * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_DP_TARGET_CFG_FIFO_WMSTAT_LSP_DP_SCH_DIR_IF * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_DP_TARGET_CFG_FIFO_WMSTAT_LSP_DP_SCH_RORPLY_IF * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_DP_TARGET_CFG_FIFO_WMSTAT_ROP_DP_ENQ_DIR_IF * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_DP_TARGET_CFG_FIFO_WMSTAT_ROP_DP_ENQ_RO_IF * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_DP_TARGET_CFG_HW_AGITATE_CONTROL * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_DP_TARGET_CFG_HW_AGITATE_SELECT * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_DP_TARGET_CFG_INTERFACE_STATUS * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_DP_TARGET_CFG_PATCH_CONTROL * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_DP_TARGET_CFG_PIPE_HEALTH_HOLD_00 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_DP_TARGET_CFG_PIPE_HEALTH_VALID_00 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_DP_TARGET_CFG_SMON_ACTIVITYCOUNTER0 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_DP_TARGET_CFG_SMON_ACTIVITYCOUNTER1 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_DP_TARGET_CFG_SMON_COMPARE0 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_DP_TARGET_CFG_SMON_COMPARE1 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_DP_TARGET_CFG_SMON_CONFIGURATION0 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_DP_TARGET_CFG_SMON_CONFIGURATION1 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_DP_TARGET_CFG_SMON_MAXIMUM_TIMER * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_DP_TARGET_CFG_SMON_TIMER * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_DP_TARGET_CFG_SYNDROME_00 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_DP_TARGET_CFG_SYNDROME_01 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_DP_TARGET_CFG_UNIT_IDLE * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_DP_TARGET_CFG_UNIT_TIMEOUT * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_DP_TARGET_CFG_UNIT_VERSION * 32 ) +: 32 ]
                      } )
   , .out_cfg_rsp_ack ( cfg_rsp_ack )
   , .out_cfg_rsp_err ( cfg_rsp_err )
   , .out_cfg_rsp_rdata ( cfg_rsp_rdata )
) ;
hqm_AW_register_enable_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( { HQM_DP_DIR_TQPRI_ARB_WEIGHT_REQ3,HQM_DP_DIR_TQPRI_ARB_WEIGHT_REQ2 , HQM_DP_DIR_TQPRI_ARB_WEIGHT_REQ1, HQM_DP_DIR_TQPRI_ARB_WEIGHT_REQ0 } )
) i_hqm_dp_target_cfg_control_arb_weights_tqpri_dir_0 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_dp_target_cfg_control_arb_weights_tqpri_dir_0_reg_nxt )
        , .reg_f                ( hqm_dp_target_cfg_control_arb_weights_tqpri_dir_0_reg_f )
        , .reg_v                ( hqm_dp_target_cfg_control_arb_weights_tqpri_dir_0_reg_v )
        , .cfg_write            ( mux_cfg_req_write [ HQM_DP_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_DIR_0 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_DP_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_DIR_0 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_DIR_0 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_DIR_0 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_DP_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_DIR_0 * 32 +: 32 ] )
) ;
hqm_AW_status_wtcfg i_hqm_dp_target_cfg_control_arb_weights_tqpri_dir_1 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .status               ( hqm_dp_target_cfg_control_arb_weights_tqpri_dir_1_status )
        , .cfg_write            ( mux_cfg_req_write [ HQM_DP_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_DIR_1 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_DP_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_DIR_1 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_DIR_1 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_DIR_1 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_DP_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_DIR_1 * 32 +: 32 ] )
) ;
hqm_AW_register_enable_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( { HQM_DP_REPLAY_TQPRI_ARB_WEIGHT_REQ3,HQM_DP_REPLAY_TQPRI_ARB_WEIGHT_REQ2, HQM_DP_REPLAY_TQPRI_ARB_WEIGHT_REQ1,HQM_DP_REPLAY_TQPRI_ARB_WEIGHT_REQ0 } )
) i_hqm_dp_target_cfg_control_arb_weights_tqpri_replay_0 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_dp_target_cfg_control_arb_weights_tqpri_replay_0_reg_nxt )
        , .reg_f                ( hqm_dp_target_cfg_control_arb_weights_tqpri_replay_0_reg_f )
        , .reg_v                ( hqm_dp_target_cfg_control_arb_weights_tqpri_replay_0_reg_v )
        , .cfg_write            ( mux_cfg_req_write [ HQM_DP_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_REPLAY_0 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_DP_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_REPLAY_0 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_REPLAY_0 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_REPLAY_0 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_DP_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_REPLAY_0 * 32 +: 32 ] )
) ;
hqm_AW_status_wtcfg i_hqm_dp_target_cfg_control_arb_weights_tqpri_replay_1 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .status               ( hqm_dp_target_cfg_control_arb_weights_tqpri_replay_1_status )
        , .cfg_write            ( mux_cfg_req_write [ HQM_DP_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_REPLAY_1 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_DP_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_REPLAY_1 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_REPLAY_1 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_REPLAY_1 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_DP_TARGET_CFG_CONTROL_ARB_WEIGHTS_TQPRI_REPLAY_1 * 32 +: 32 ] )
) ;
hqm_AW_register_enable_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h00000000 )
) i_hqm_dp_target_cfg_control_general (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_dp_target_cfg_control_general_reg_nxt )
        , .reg_f                ( hqm_dp_target_cfg_control_general_reg_f )
        , .reg_v                ( hqm_dp_target_cfg_control_general_reg_v )
        , .cfg_write            ( mux_cfg_req_write [ HQM_DP_TARGET_CFG_CONTROL_GENERAL ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_DP_TARGET_CFG_CONTROL_GENERAL ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_CONTROL_GENERAL ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_CONTROL_GENERAL ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_DP_TARGET_CFG_CONTROL_GENERAL * 32 +: 32 ] )
) ;
hqm_AW_register_enable_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h0004a529 )
) i_hqm_dp_target_cfg_control_pipeline_credits (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_dp_target_cfg_control_pipeline_credits_reg_nxt )
        , .reg_f                ( hqm_dp_target_cfg_control_pipeline_credits_reg_f )
        , .reg_v                ( hqm_dp_target_cfg_control_pipeline_credits_reg_v )
        , .cfg_write            ( mux_cfg_req_write [ HQM_DP_TARGET_CFG_CONTROL_PIPELINE_CREDITS ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_DP_TARGET_CFG_CONTROL_PIPELINE_CREDITS ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_CONTROL_PIPELINE_CREDITS ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_CONTROL_PIPELINE_CREDITS ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_DP_TARGET_CFG_CONTROL_PIPELINE_CREDITS * 32 +: 32 ] )
) ;
hqm_AW_register_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h00000000 )
) i_hqm_dp_target_cfg_detect_feature_operation_00 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_dp_target_cfg_detect_feature_operation_00_reg_nxt )
        , .reg_f                ( hqm_dp_target_cfg_detect_feature_operation_00_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_DP_TARGET_CFG_DETECT_FEATURE_OPERATION_00 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_DP_TARGET_CFG_DETECT_FEATURE_OPERATION_00 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_DETECT_FEATURE_OPERATION_00 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_DETECT_FEATURE_OPERATION_00 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_DP_TARGET_CFG_DETECT_FEATURE_OPERATION_00 * 32 +: 32 ] )
) ;
hqm_AW_register_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h00000000 )
) i_hqm_dp_target_cfg_detect_feature_operation_01 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_dp_target_cfg_detect_feature_operation_01_reg_nxt )
        , .reg_f                ( hqm_dp_target_cfg_detect_feature_operation_01_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_DP_TARGET_CFG_DETECT_FEATURE_OPERATION_01 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_DP_TARGET_CFG_DETECT_FEATURE_OPERATION_01 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_DETECT_FEATURE_OPERATION_01 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_DETECT_FEATURE_OPERATION_01 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_DP_TARGET_CFG_DETECT_FEATURE_OPERATION_01 * 32 +: 32 ] )
) ;
hqm_AW_status_wtcfg i_hqm_dp_target_cfg_diagnostic_aw_status (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .status               ( hqm_dp_target_cfg_diagnostic_aw_status_status )
        , .cfg_write            ( mux_cfg_req_write [ HQM_DP_TARGET_CFG_DIAGNOSTIC_AW_STATUS ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_DP_TARGET_CFG_DIAGNOSTIC_AW_STATUS ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_DIAGNOSTIC_AW_STATUS ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_DIAGNOSTIC_AW_STATUS ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_DP_TARGET_CFG_DIAGNOSTIC_AW_STATUS * 32 +: 32 ] )
) ;
hqm_AW_status_wtcfg i_hqm_dp_target_cfg_diagnostic_aw_status_01 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .status               ( hqm_dp_target_cfg_diagnostic_aw_status_01_status )
        , .cfg_write            ( mux_cfg_req_write [ HQM_DP_TARGET_CFG_DIAGNOSTIC_AW_STATUS_01 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_DP_TARGET_CFG_DIAGNOSTIC_AW_STATUS_01 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_DIAGNOSTIC_AW_STATUS_01 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_DIAGNOSTIC_AW_STATUS_01 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_DP_TARGET_CFG_DIAGNOSTIC_AW_STATUS_01 * 32 +: 32 ] )
) ;
hqm_AW_status_wtcfg i_hqm_dp_target_cfg_diagnostic_aw_status_02 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .status               ( hqm_dp_target_cfg_diagnostic_aw_status_02_status )
        , .cfg_write            ( mux_cfg_req_write [ HQM_DP_TARGET_CFG_DIAGNOSTIC_AW_STATUS_02 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_DP_TARGET_CFG_DIAGNOSTIC_AW_STATUS_02 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_DIAGNOSTIC_AW_STATUS_02 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_DIAGNOSTIC_AW_STATUS_02 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_DP_TARGET_CFG_DIAGNOSTIC_AW_STATUS_02 * 32 +: 32 ] )
) ;
hqm_AW_register_enable_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h00000000 )
) i_hqm_dp_target_cfg_dir_csr_control (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_dp_target_cfg_dir_csr_control_reg_nxt )
        , .reg_f                ( hqm_dp_target_cfg_dir_csr_control_reg_f )
        , .reg_v                ( hqm_dp_target_cfg_dir_csr_control_reg_v )
        , .cfg_write            ( mux_cfg_req_write [ HQM_DP_TARGET_CFG_DIR_CSR_CONTROL ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_DP_TARGET_CFG_DIR_CSR_CONTROL ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_DIR_CSR_CONTROL ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_DIR_CSR_CONTROL ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_DP_TARGET_CFG_DIR_CSR_CONTROL * 32 +: 32 ] )
) ;
hqm_AW_register_enable_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h00000000 )
) i_hqm_dp_target_cfg_error_inject (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_dp_target_cfg_error_inject_reg_nxt )
        , .reg_f                ( hqm_dp_target_cfg_error_inject_reg_f )
        , .reg_v                ( hqm_dp_target_cfg_error_inject_reg_v )
        , .cfg_write            ( mux_cfg_req_write [ HQM_DP_TARGET_CFG_ERROR_INJECT ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_DP_TARGET_CFG_ERROR_INJECT ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_ERROR_INJECT ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_ERROR_INJECT ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_DP_TARGET_CFG_ERROR_INJECT * 32 +: 32 ] )
) ;
hqm_AW_register_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h0000001d )
) i_hqm_dp_target_cfg_fifo_wmstat_dp_dqed_if (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_dp_target_cfg_fifo_wmstat_dp_dqed_if_reg_nxt )
        , .reg_f                ( hqm_dp_target_cfg_fifo_wmstat_dp_dqed_if_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_DP_TARGET_CFG_FIFO_WMSTAT_DP_DQED_IF ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_DP_TARGET_CFG_FIFO_WMSTAT_DP_DQED_IF ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_FIFO_WMSTAT_DP_DQED_IF ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_FIFO_WMSTAT_DP_DQED_IF ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_DP_TARGET_CFG_FIFO_WMSTAT_DP_DQED_IF * 32 +: 32 ] )
) ;
hqm_AW_register_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h0000000d )
) i_hqm_dp_target_cfg_fifo_wmstat_dp_lsp_enq_dir_if (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_dp_target_cfg_fifo_wmstat_dp_lsp_enq_dir_if_reg_nxt )
        , .reg_f                ( hqm_dp_target_cfg_fifo_wmstat_dp_lsp_enq_dir_if_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_DP_TARGET_CFG_FIFO_WMSTAT_DP_LSP_ENQ_DIR_IF ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_DP_TARGET_CFG_FIFO_WMSTAT_DP_LSP_ENQ_DIR_IF ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_FIFO_WMSTAT_DP_LSP_ENQ_DIR_IF ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_FIFO_WMSTAT_DP_LSP_ENQ_DIR_IF ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_DP_TARGET_CFG_FIFO_WMSTAT_DP_LSP_ENQ_DIR_IF * 32 +: 32 ] )
) ;
hqm_AW_register_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h0000000d )
) i_hqm_dp_target_cfg_fifo_wmstat_dp_lsp_enq_rorply_if (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_dp_target_cfg_fifo_wmstat_dp_lsp_enq_rorply_if_reg_nxt )
        , .reg_f                ( hqm_dp_target_cfg_fifo_wmstat_dp_lsp_enq_rorply_if_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_DP_TARGET_CFG_FIFO_WMSTAT_DP_LSP_ENQ_RORPLY_IF ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_DP_TARGET_CFG_FIFO_WMSTAT_DP_LSP_ENQ_RORPLY_IF ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_FIFO_WMSTAT_DP_LSP_ENQ_RORPLY_IF ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_FIFO_WMSTAT_DP_LSP_ENQ_RORPLY_IF ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_DP_TARGET_CFG_FIFO_WMSTAT_DP_LSP_ENQ_RORPLY_IF * 32 +: 32 ] )
) ;
hqm_AW_register_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h00000004 )
) i_hqm_dp_target_cfg_fifo_wmstat_lsp_dp_sch_dir_if (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_dp_target_cfg_fifo_wmstat_lsp_dp_sch_dir_if_reg_nxt )
        , .reg_f                ( hqm_dp_target_cfg_fifo_wmstat_lsp_dp_sch_dir_if_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_DP_TARGET_CFG_FIFO_WMSTAT_LSP_DP_SCH_DIR_IF ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_DP_TARGET_CFG_FIFO_WMSTAT_LSP_DP_SCH_DIR_IF ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_FIFO_WMSTAT_LSP_DP_SCH_DIR_IF ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_FIFO_WMSTAT_LSP_DP_SCH_DIR_IF ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_DP_TARGET_CFG_FIFO_WMSTAT_LSP_DP_SCH_DIR_IF * 32 +: 32 ] )
) ;
hqm_AW_register_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h00000004 )
) i_hqm_dp_target_cfg_fifo_wmstat_lsp_dp_sch_rorply_if (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_dp_target_cfg_fifo_wmstat_lsp_dp_sch_rorply_if_reg_nxt )
        , .reg_f                ( hqm_dp_target_cfg_fifo_wmstat_lsp_dp_sch_rorply_if_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_DP_TARGET_CFG_FIFO_WMSTAT_LSP_DP_SCH_RORPLY_IF ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_DP_TARGET_CFG_FIFO_WMSTAT_LSP_DP_SCH_RORPLY_IF ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_FIFO_WMSTAT_LSP_DP_SCH_RORPLY_IF ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_FIFO_WMSTAT_LSP_DP_SCH_RORPLY_IF ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_DP_TARGET_CFG_FIFO_WMSTAT_LSP_DP_SCH_RORPLY_IF * 32 +: 32 ] )
) ;
hqm_AW_register_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h00000004 )
) i_hqm_dp_target_cfg_fifo_wmstat_rop_dp_enq_dir_if (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_dp_target_cfg_fifo_wmstat_rop_dp_enq_dir_if_reg_nxt )
        , .reg_f                ( hqm_dp_target_cfg_fifo_wmstat_rop_dp_enq_dir_if_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_DP_TARGET_CFG_FIFO_WMSTAT_ROP_DP_ENQ_DIR_IF ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_DP_TARGET_CFG_FIFO_WMSTAT_ROP_DP_ENQ_DIR_IF ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_FIFO_WMSTAT_ROP_DP_ENQ_DIR_IF ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_FIFO_WMSTAT_ROP_DP_ENQ_DIR_IF ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_DP_TARGET_CFG_FIFO_WMSTAT_ROP_DP_ENQ_DIR_IF * 32 +: 32 ] )
) ;
hqm_AW_register_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h00000004 )
) i_hqm_dp_target_cfg_fifo_wmstat_rop_dp_enq_ro_if (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_dp_target_cfg_fifo_wmstat_rop_dp_enq_ro_if_reg_nxt )
        , .reg_f                ( hqm_dp_target_cfg_fifo_wmstat_rop_dp_enq_ro_if_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_DP_TARGET_CFG_FIFO_WMSTAT_ROP_DP_ENQ_RO_IF ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_DP_TARGET_CFG_FIFO_WMSTAT_ROP_DP_ENQ_RO_IF ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_FIFO_WMSTAT_ROP_DP_ENQ_RO_IF ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_FIFO_WMSTAT_ROP_DP_ENQ_RO_IF ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_DP_TARGET_CFG_FIFO_WMSTAT_ROP_DP_ENQ_RO_IF * 32 +: 32 ] )
) ;
hqm_AW_register_enable_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h00000000 )
) i_hqm_dp_target_cfg_hw_agitate_control (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_dp_target_cfg_hw_agitate_control_reg_nxt )
        , .reg_f                ( hqm_dp_target_cfg_hw_agitate_control_reg_f )
        , .reg_v                ( hqm_dp_target_cfg_hw_agitate_control_reg_v )
        , .cfg_write            ( mux_cfg_req_write [ HQM_DP_TARGET_CFG_HW_AGITATE_CONTROL ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_DP_TARGET_CFG_HW_AGITATE_CONTROL ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_HW_AGITATE_CONTROL ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_HW_AGITATE_CONTROL ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_DP_TARGET_CFG_HW_AGITATE_CONTROL * 32 +: 32 ] )
) ;
hqm_AW_register_enable_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h00000000 )
) i_hqm_dp_target_cfg_hw_agitate_select (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_dp_target_cfg_hw_agitate_select_reg_nxt )
        , .reg_f                ( hqm_dp_target_cfg_hw_agitate_select_reg_f )
        , .reg_v                ( hqm_dp_target_cfg_hw_agitate_select_reg_v )
        , .cfg_write            ( mux_cfg_req_write [ HQM_DP_TARGET_CFG_HW_AGITATE_SELECT ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_DP_TARGET_CFG_HW_AGITATE_SELECT ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_HW_AGITATE_SELECT ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_HW_AGITATE_SELECT ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_DP_TARGET_CFG_HW_AGITATE_SELECT * 32 +: 32 ] )
) ;
hqm_AW_register_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h00000000 )
) i_hqm_dp_target_cfg_interface_status (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_dp_target_cfg_interface_status_reg_nxt )
        , .reg_f                ( hqm_dp_target_cfg_interface_status_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_DP_TARGET_CFG_INTERFACE_STATUS ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_DP_TARGET_CFG_INTERFACE_STATUS ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_INTERFACE_STATUS ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_INTERFACE_STATUS ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_DP_TARGET_CFG_INTERFACE_STATUS * 32 +: 32 ] )
) ;
hqm_AW_register_enable_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h00000740 )
) i_hqm_dp_target_cfg_patch_control (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_dp_target_cfg_patch_control_reg_nxt )
        , .reg_f                ( hqm_dp_target_cfg_patch_control_reg_f )
        , .reg_v                ( hqm_dp_target_cfg_patch_control_reg_v )
        , .cfg_write            ( mux_cfg_req_write [ HQM_DP_TARGET_CFG_PATCH_CONTROL ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_DP_TARGET_CFG_PATCH_CONTROL ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_PATCH_CONTROL ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_PATCH_CONTROL ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_DP_TARGET_CFG_PATCH_CONTROL * 32 +: 32 ] )
) ;
hqm_AW_register_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h00000000 )
) i_hqm_dp_target_cfg_pipe_health_hold_00 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_dp_target_cfg_pipe_health_hold_00_reg_nxt )
        , .reg_f                ( hqm_dp_target_cfg_pipe_health_hold_00_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_DP_TARGET_CFG_PIPE_HEALTH_HOLD_00 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_DP_TARGET_CFG_PIPE_HEALTH_HOLD_00 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_PIPE_HEALTH_HOLD_00 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_PIPE_HEALTH_HOLD_00 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_DP_TARGET_CFG_PIPE_HEALTH_HOLD_00 * 32 +: 32 ] )
) ;
hqm_AW_register_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h00000000 )
) i_hqm_dp_target_cfg_pipe_health_valid_00 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_dp_target_cfg_pipe_health_valid_00_reg_nxt )
        , .reg_f                ( hqm_dp_target_cfg_pipe_health_valid_00_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_DP_TARGET_CFG_PIPE_HEALTH_VALID_00 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_DP_TARGET_CFG_PIPE_HEALTH_VALID_00 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_PIPE_HEALTH_VALID_00 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_PIPE_HEALTH_VALID_00 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_DP_TARGET_CFG_PIPE_HEALTH_VALID_00 * 32 +: 32 ] )
) ;
hqm_AW_smon_wtcfg #( 
          .WIDTH                       ( 24 ) 
) i_hqm_dp_target_cfg_smon ( 
          .clk                         ( hqm_gated_clk )
        , .rst_n                       ( hqm_gated_rst_n )
        , .cfg_write                   ( { mux_cfg_req_write[ HQM_DP_TARGET_CFG_SMON_MAXIMUM_TIMER ]
                                          , mux_cfg_req_write[HQM_DP_TARGET_CFG_SMON_TIMER ]
                                          , mux_cfg_req_write[ HQM_DP_TARGET_CFG_SMON_ACTIVITYCOUNTER1 ]
                                          , mux_cfg_req_write[ HQM_DP_TARGET_CFG_SMON_ACTIVITYCOUNTER0 ]
                                          , mux_cfg_req_write[ HQM_DP_TARGET_CFG_SMON_COMPARE1 ]
                                          , mux_cfg_req_write[ HQM_DP_TARGET_CFG_SMON_COMPARE0 ]
                                          , mux_cfg_req_write[ HQM_DP_TARGET_CFG_SMON_CONFIGURATION1 ]
                                          , mux_cfg_req_write[ HQM_DP_TARGET_CFG_SMON_CONFIGURATION0 ]
                                          }
                                        )
        , .cfg_read                    ( { mux_cfg_req_read[ HQM_DP_TARGET_CFG_SMON_MAXIMUM_TIMER ]
                                          , mux_cfg_req_read[ HQM_DP_TARGET_CFG_SMON_TIMER ]
                                          , mux_cfg_req_read[ HQM_DP_TARGET_CFG_SMON_ACTIVITYCOUNTER1 ]
                                          , mux_cfg_req_read[ HQM_DP_TARGET_CFG_SMON_ACTIVITYCOUNTER0 ]
                                          , mux_cfg_req_read[ HQM_DP_TARGET_CFG_SMON_COMPARE1 ]
                                          , mux_cfg_req_read[ HQM_DP_TARGET_CFG_SMON_COMPARE0 ]
                                          , mux_cfg_req_read[ HQM_DP_TARGET_CFG_SMON_CONFIGURATION1 ]
                                          , mux_cfg_req_read[ HQM_DP_TARGET_CFG_SMON_CONFIGURATION0 ]
                                          }
                                        )
        , .cfg_req                     ( mux_cfg_req )
        , .cfg_ack                     ( mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_SMON_CONFIGURATION0 * 1 +: 1 ] )
        , .cfg_err                     ( mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_SMON_CONFIGURATION0 * 1 +: 1 ] )
        , .cfg_rdata                   ( mux_cfg_rsp_rdata_pnc [ HQM_DP_TARGET_CFG_SMON_CONFIGURATION0 * 32 +: 32 ] )
        , .disable_smon                ( hqm_dp_target_cfg_smon_disable_smon )
        , .in_mon_v                    ( hqm_dp_target_cfg_smon_smon_v )
        , .in_mon_comp                 ( hqm_dp_target_cfg_smon_smon_comp )
        , .in_mon_val                  ( hqm_dp_target_cfg_smon_smon_val )
        , .out_smon_interrupt          ( hqm_dp_target_cfg_smon_smon_interrupt )
        , .out_smon_enabled            ( hqm_dp_target_cfg_smon_smon_enabled )
) ;
assign mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_SMON_CONFIGURATION1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_SMON_CONFIGURATION1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ HQM_DP_TARGET_CFG_SMON_CONFIGURATION1 * 32 +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_SMON_COMPARE0 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_SMON_COMPARE0 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ HQM_DP_TARGET_CFG_SMON_COMPARE0 * 32 +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_SMON_COMPARE1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_SMON_COMPARE1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ HQM_DP_TARGET_CFG_SMON_COMPARE1 * 32 +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_SMON_ACTIVITYCOUNTER0 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_SMON_ACTIVITYCOUNTER0 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ HQM_DP_TARGET_CFG_SMON_ACTIVITYCOUNTER0 * 32 +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_SMON_ACTIVITYCOUNTER1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_SMON_ACTIVITYCOUNTER1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ HQM_DP_TARGET_CFG_SMON_ACTIVITYCOUNTER1 * 32 +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_SMON_TIMER ] = '0 ;
assign mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_SMON_TIMER ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ HQM_DP_TARGET_CFG_SMON_TIMER * 32 +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_SMON_MAXIMUM_TIMER ] = '0 ;
assign mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_SMON_MAXIMUM_TIMER ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ HQM_DP_TARGET_CFG_SMON_MAXIMUM_TIMER * 32 +: 32 ] = '0 ;
hqm_AW_syndrome_wtcfg i_hqm_dp_target_cfg_syndrome_00 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .cfg_write            ( mux_cfg_req_write [ HQM_DP_TARGET_CFG_SYNDROME_00 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_DP_TARGET_CFG_SYNDROME_00 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_SYNDROME_00 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_SYNDROME_00 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_DP_TARGET_CFG_SYNDROME_00 * 32 +: 32 ] )
        , .capture_v            ( hqm_dp_target_cfg_syndrome_00_capture_v )
        , .capture_data         ( hqm_dp_target_cfg_syndrome_00_capture_data )
        , .syndrome_data        ( hqm_dp_target_cfg_syndrome_00_syndrome_data )
) ;
hqm_AW_syndrome_wtcfg i_hqm_dp_target_cfg_syndrome_01 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .cfg_write            ( mux_cfg_req_write [ HQM_DP_TARGET_CFG_SYNDROME_01 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_DP_TARGET_CFG_SYNDROME_01 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_SYNDROME_01 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_SYNDROME_01 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_DP_TARGET_CFG_SYNDROME_01 * 32 +: 32 ] )
        , .capture_v            ( hqm_dp_target_cfg_syndrome_01_capture_v )
        , .capture_data         ( hqm_dp_target_cfg_syndrome_01_capture_data )
        , .syndrome_data        ( hqm_dp_target_cfg_syndrome_01_syndrome_data )
) ;
hqm_AW_register_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h00000003 )
) i_hqm_dp_target_cfg_unit_idle (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_dp_target_cfg_unit_idle_reg_nxt )
        , .reg_f                ( hqm_dp_target_cfg_unit_idle_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_DP_TARGET_CFG_UNIT_IDLE ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_DP_TARGET_CFG_UNIT_IDLE ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_UNIT_IDLE ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_UNIT_IDLE ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_DP_TARGET_CFG_UNIT_IDLE * 32 +: 32 ] )
) ;
hqm_AW_register_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( HQM_UNIT_TIMEOUT_DEFAULT )
) i_hqm_dp_target_cfg_unit_timeout (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_dp_target_cfg_unit_timeout_reg_nxt )
        , .reg_f                ( hqm_dp_target_cfg_unit_timeout_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_DP_TARGET_CFG_UNIT_TIMEOUT ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_DP_TARGET_CFG_UNIT_TIMEOUT ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_UNIT_TIMEOUT ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_UNIT_TIMEOUT ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_DP_TARGET_CFG_UNIT_TIMEOUT * 32 +: 32 ] )
) ;
hqm_AW_status_wtcfg i_hqm_dp_target_cfg_unit_version (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .status               ( hqm_dp_target_cfg_unit_version_status )
        , .cfg_write            ( mux_cfg_req_write [ HQM_DP_TARGET_CFG_UNIT_VERSION ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_DP_TARGET_CFG_UNIT_VERSION ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_DP_TARGET_CFG_UNIT_VERSION ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_DP_TARGET_CFG_UNIT_VERSION ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_DP_TARGET_CFG_UNIT_VERSION * 32 +: 32 ] )
) ;
endmodule
