module hqm_reorder_pipe_register_pfcsr
import hqm_AW_pkg::* , hqm_pkg::* , hqm_core_pkg::* ;
(
  input logic hqm_gated_clk
, input logic hqm_gated_rst_n
, input logic rst_prep 
, input logic [ ( HQM_ROP_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] cfg_req_write 
, input logic [ ( HQM_ROP_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] cfg_req_read 
, input cfg_req_t cfg_req 
, output logic cfg_rsp_ack 
, output logic cfg_rsp_err 
, output logic [ ( 32 ) - 1 : 0 ] cfg_rsp_rdata 
, input logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_control_general_0_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_control_general_0_reg_f
, input logic hqm_rop_target_cfg_control_general_0_reg_v
, input logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_diagnostic_aw_status_status
, input logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_fifo_wmstat_chp_rop_hcw_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_fifo_wmstat_chp_rop_hcw_reg_f
, input logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_fifo_wmstat_dir_rply_req_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_fifo_wmstat_dir_rply_req_reg_f
, input logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_fifo_wmstat_ldb_rply_req_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_fifo_wmstat_ldb_rply_req_reg_f
, input logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_fifo_wmstat_lsp_reordercmp_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_fifo_wmstat_lsp_reordercmp_reg_f
, input logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_fifo_wmstat_sn_complete_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_fifo_wmstat_sn_complete_reg_f
, input logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_fifo_wmstat_sn_ordered_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_fifo_wmstat_sn_ordered_reg_f
, input logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_frag_integrity_count_status
, input logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_grp_sn_mode_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_grp_sn_mode_reg_f
, input logic hqm_rop_target_cfg_grp_sn_mode_reg_v
, input logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_hw_agitate_control_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_hw_agitate_control_reg_f
, input logic hqm_rop_target_cfg_hw_agitate_control_reg_v
, input logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_hw_agitate_select_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_hw_agitate_select_reg_f
, input logic hqm_rop_target_cfg_hw_agitate_select_reg_v
, input logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_interface_status_status
, input logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_patch_control_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_patch_control_reg_f
, input logic hqm_rop_target_cfg_patch_control_reg_v
, input logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_pipe_health_hold_grp0_status
, input logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_pipe_health_hold_grp1_status
, input logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_pipe_health_hold_rop_dp_status
, input logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_pipe_health_hold_rop_lsp_reordcomp_status
, input logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_pipe_health_hold_rop_nalb_status
, input logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_pipe_health_hold_rop_qed_dqed_status
, input logic [ ( 32 * 32 ) - 1 : 0] hqm_rop_target_cfg_pipe_health_seqnum_state_grp0_status
, input logic [ ( 32 * 32 ) - 1 : 0] hqm_rop_target_cfg_pipe_health_seqnum_state_grp1_status
, input logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_pipe_health_valid_grp0_status
, input logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_pipe_health_valid_grp1_status
, input logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_pipe_health_valid_rop_dp_status
, input logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_pipe_health_valid_rop_lsp_reordcomp_status
, input logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_pipe_health_valid_rop_nalb_status
, input logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_pipe_health_valid_rop_qed_dqed_status
, input logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_rop_csr_control_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_rop_csr_control_reg_f
, input logic hqm_rop_target_cfg_rop_csr_control_reg_v
, input logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_serializer_status_status
, input logic hqm_rop_target_cfg_smon_disable_smon
, input logic [ 16 - 1 : 0 ] hqm_rop_target_cfg_smon_smon_v
, input logic [ ( 16 * 32 ) - 1 : 0 ] hqm_rop_target_cfg_smon_smon_comp
, input logic [ ( 16 * 32 ) - 1 : 0 ] hqm_rop_target_cfg_smon_smon_val
, output logic hqm_rop_target_cfg_smon_smon_enabled
, output logic hqm_rop_target_cfg_smon_smon_interrupt
, input logic hqm_rop_target_cfg_syndrome_00_capture_v
, input logic [ ( 31 ) - 1 : 0] hqm_rop_target_cfg_syndrome_00_capture_data
, output logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_syndrome_00_syndrome_data
, input logic hqm_rop_target_cfg_syndrome_01_capture_v
, input logic [ ( 31 ) - 1 : 0] hqm_rop_target_cfg_syndrome_01_capture_data
, output logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_syndrome_01_syndrome_data
, input logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_unit_idle_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_unit_idle_reg_f
, input logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_unit_timeout_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_unit_timeout_reg_f
, input logic [ ( 32 ) - 1 : 0] hqm_rop_target_cfg_unit_version_status
);
logic [ ( HQM_ROP_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] mux_cfg_req_write ;
logic [ ( HQM_ROP_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] mux_cfg_req_read ;
cfg_req_t mux_cfg_req ;
logic [ ( HQM_ROP_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] mux_cfg_rsp_ack_pnc ;
logic [ ( HQM_ROP_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] mux_cfg_rsp_err_pnc ;
logic [ ( HQM_ROP_CFG_UNIT_NUM_TGTS * 32 ) - 1 : 0 ] mux_cfg_rsp_rdata_pnc ;
always_comb begin
  mux_cfg_req_write = cfg_req_write ;
  mux_cfg_req_read = cfg_req_read ;
  mux_cfg_req = cfg_req ;
end
hqm_AW_cfg_rsp #(
    .NUM_TGTS ( 43 )
) i_hqm_AW_cfg_rsp_0 (
    .clk ( hqm_gated_clk )
  , .rst_n ( hqm_gated_rst_n )
  , .in_cfg_rsp_ack ( {
                        mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_CONTROL_GENERAL_0 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_DIAGNOSTIC_AW_STATUS ]
                      , mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_FIFO_WMSTAT_CHP_ROP_HCW ]
                      , mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_FIFO_WMSTAT_DIR_RPLY_REQ ]
                      , mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_FIFO_WMSTAT_LDB_RPLY_REQ ]
                      , mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_FIFO_WMSTAT_LSP_REORDERCMP ]
                      , mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_FIFO_WMSTAT_SN_COMPLETE ]
                      , mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_FIFO_WMSTAT_SN_ORDERED ]
                      , mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_FRAG_INTEGRITY_COUNT ]
                      , mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_GRP_SN_MODE ]
                      , mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_HW_AGITATE_CONTROL ]
                      , mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_HW_AGITATE_SELECT ]
                      , mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_INTERFACE_STATUS ]
                      , mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_PATCH_CONTROL ]
                      , mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_HOLD_GRP0 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_HOLD_GRP1 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_HOLD_ROP_DP ]
                      , mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_HOLD_ROP_LSP_REORDCOMP ]
                      , mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_HOLD_ROP_NALB ]
                      , mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_HOLD_ROP_QED_DQED ]
                      , mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_SEQNUM_STATE_GRP0 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_SEQNUM_STATE_GRP1 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_VALID_GRP0 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_VALID_GRP1 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_VALID_ROP_DP ]
                      , mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_VALID_ROP_LSP_REORDCOMP ]
                      , mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_VALID_ROP_NALB ]
                      , mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_VALID_ROP_QED_DQED ]
                      , mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_ROP_CSR_CONTROL ]
                      , mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_SERIALIZER_STATUS ]
                      , mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_SMON_ACTIVITYCOUNTER0 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_SMON_ACTIVITYCOUNTER1 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_SMON_COMPARE0 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_SMON_COMPARE1 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_SMON_CONFIGURATION0 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_SMON_CONFIGURATION1 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_SMON_MAXIMUM_TIMER ]
                      , mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_SMON_TIMER ]
                      , mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_SYNDROME_00 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_SYNDROME_01 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_UNIT_IDLE ]
                      , mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_UNIT_TIMEOUT ]
                      , mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_UNIT_VERSION ]
                      } )
  , .in_cfg_rsp_err ( {
                        mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_CONTROL_GENERAL_0 ]
                      , mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_DIAGNOSTIC_AW_STATUS ]
                      , mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_FIFO_WMSTAT_CHP_ROP_HCW ]
                      , mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_FIFO_WMSTAT_DIR_RPLY_REQ ]
                      , mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_FIFO_WMSTAT_LDB_RPLY_REQ ]
                      , mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_FIFO_WMSTAT_LSP_REORDERCMP ]
                      , mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_FIFO_WMSTAT_SN_COMPLETE ]
                      , mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_FIFO_WMSTAT_SN_ORDERED ]
                      , mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_FRAG_INTEGRITY_COUNT ]
                      , mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_GRP_SN_MODE ]
                      , mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_HW_AGITATE_CONTROL ]
                      , mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_HW_AGITATE_SELECT ]
                      , mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_INTERFACE_STATUS ]
                      , mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_PATCH_CONTROL ]
                      , mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_HOLD_GRP0 ]
                      , mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_HOLD_GRP1 ]
                      , mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_HOLD_ROP_DP ]
                      , mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_HOLD_ROP_LSP_REORDCOMP ]
                      , mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_HOLD_ROP_NALB ]
                      , mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_HOLD_ROP_QED_DQED ]
                      , mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_SEQNUM_STATE_GRP0 ]
                      , mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_SEQNUM_STATE_GRP1 ]
                      , mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_VALID_GRP0 ]
                      , mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_VALID_GRP1 ]
                      , mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_VALID_ROP_DP ]
                      , mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_VALID_ROP_LSP_REORDCOMP ]
                      , mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_VALID_ROP_NALB ]
                      , mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_VALID_ROP_QED_DQED ]
                      , mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_ROP_CSR_CONTROL ]
                      , mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_SERIALIZER_STATUS ]
                      , mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_SMON_ACTIVITYCOUNTER0 ]
                      , mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_SMON_ACTIVITYCOUNTER1 ]
                      , mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_SMON_COMPARE0 ]
                      , mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_SMON_COMPARE1 ]
                      , mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_SMON_CONFIGURATION0 ]
                      , mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_SMON_CONFIGURATION1 ]
                      , mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_SMON_MAXIMUM_TIMER ]
                      , mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_SMON_TIMER ]
                      , mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_SYNDROME_00 ]
                      , mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_SYNDROME_01 ]
                      , mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_UNIT_IDLE ]
                      , mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_UNIT_TIMEOUT ]
                      , mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_UNIT_VERSION ]
                      } )
  , .in_cfg_rsp_rdata ( {
                        mux_cfg_rsp_rdata_pnc [ ( HQM_ROP_TARGET_CFG_CONTROL_GENERAL_0 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_ROP_TARGET_CFG_DIAGNOSTIC_AW_STATUS * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_ROP_TARGET_CFG_FIFO_WMSTAT_CHP_ROP_HCW * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_ROP_TARGET_CFG_FIFO_WMSTAT_DIR_RPLY_REQ * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_ROP_TARGET_CFG_FIFO_WMSTAT_LDB_RPLY_REQ * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_ROP_TARGET_CFG_FIFO_WMSTAT_LSP_REORDERCMP * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_ROP_TARGET_CFG_FIFO_WMSTAT_SN_COMPLETE * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_ROP_TARGET_CFG_FIFO_WMSTAT_SN_ORDERED * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_ROP_TARGET_CFG_FRAG_INTEGRITY_COUNT * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_ROP_TARGET_CFG_GRP_SN_MODE * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_ROP_TARGET_CFG_HW_AGITATE_CONTROL * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_ROP_TARGET_CFG_HW_AGITATE_SELECT * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_ROP_TARGET_CFG_INTERFACE_STATUS * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_ROP_TARGET_CFG_PATCH_CONTROL * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_ROP_TARGET_CFG_PIPE_HEALTH_HOLD_GRP0 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_ROP_TARGET_CFG_PIPE_HEALTH_HOLD_GRP1 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_ROP_TARGET_CFG_PIPE_HEALTH_HOLD_ROP_DP * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_ROP_TARGET_CFG_PIPE_HEALTH_HOLD_ROP_LSP_REORDCOMP * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_ROP_TARGET_CFG_PIPE_HEALTH_HOLD_ROP_NALB * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_ROP_TARGET_CFG_PIPE_HEALTH_HOLD_ROP_QED_DQED * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_ROP_TARGET_CFG_PIPE_HEALTH_SEQNUM_STATE_GRP0 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_ROP_TARGET_CFG_PIPE_HEALTH_SEQNUM_STATE_GRP1 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_ROP_TARGET_CFG_PIPE_HEALTH_VALID_GRP0 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_ROP_TARGET_CFG_PIPE_HEALTH_VALID_GRP1 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_ROP_TARGET_CFG_PIPE_HEALTH_VALID_ROP_DP * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_ROP_TARGET_CFG_PIPE_HEALTH_VALID_ROP_LSP_REORDCOMP * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_ROP_TARGET_CFG_PIPE_HEALTH_VALID_ROP_NALB * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_ROP_TARGET_CFG_PIPE_HEALTH_VALID_ROP_QED_DQED * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_ROP_TARGET_CFG_ROP_CSR_CONTROL * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_ROP_TARGET_CFG_SERIALIZER_STATUS * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_ROP_TARGET_CFG_SMON_ACTIVITYCOUNTER0 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_ROP_TARGET_CFG_SMON_ACTIVITYCOUNTER1 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_ROP_TARGET_CFG_SMON_COMPARE0 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_ROP_TARGET_CFG_SMON_COMPARE1 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_ROP_TARGET_CFG_SMON_CONFIGURATION0 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_ROP_TARGET_CFG_SMON_CONFIGURATION1 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_ROP_TARGET_CFG_SMON_MAXIMUM_TIMER * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_ROP_TARGET_CFG_SMON_TIMER * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_ROP_TARGET_CFG_SYNDROME_00 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_ROP_TARGET_CFG_SYNDROME_01 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_ROP_TARGET_CFG_UNIT_IDLE * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_ROP_TARGET_CFG_UNIT_TIMEOUT * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_ROP_TARGET_CFG_UNIT_VERSION * 32 ) +: 32 ]
                      } )
   , .out_cfg_rsp_ack ( cfg_rsp_ack )
   , .out_cfg_rsp_err ( cfg_rsp_err )
   , .out_cfg_rsp_rdata ( cfg_rsp_rdata )
) ;
hqm_AW_register_enable_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h00000000 )
) i_hqm_rop_target_cfg_control_general_0 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_rop_target_cfg_control_general_0_reg_nxt )
        , .reg_f                ( hqm_rop_target_cfg_control_general_0_reg_f )
        , .reg_v                ( hqm_rop_target_cfg_control_general_0_reg_v )
        , .cfg_write            ( mux_cfg_req_write [ HQM_ROP_TARGET_CFG_CONTROL_GENERAL_0 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_ROP_TARGET_CFG_CONTROL_GENERAL_0 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_CONTROL_GENERAL_0 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_CONTROL_GENERAL_0 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_ROP_TARGET_CFG_CONTROL_GENERAL_0 * 32 +: 32 ] )
) ;
hqm_AW_status_wtcfg i_hqm_rop_target_cfg_diagnostic_aw_status (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .status               ( hqm_rop_target_cfg_diagnostic_aw_status_status )
        , .cfg_write            ( mux_cfg_req_write [ HQM_ROP_TARGET_CFG_DIAGNOSTIC_AW_STATUS ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_ROP_TARGET_CFG_DIAGNOSTIC_AW_STATUS ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_DIAGNOSTIC_AW_STATUS ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_DIAGNOSTIC_AW_STATUS ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_ROP_TARGET_CFG_DIAGNOSTIC_AW_STATUS * 32 +: 32 ] )
) ;
hqm_AW_register_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h00000004 )
) i_hqm_rop_target_cfg_fifo_wmstat_chp_rop_hcw (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_rop_target_cfg_fifo_wmstat_chp_rop_hcw_reg_nxt )
        , .reg_f                ( hqm_rop_target_cfg_fifo_wmstat_chp_rop_hcw_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_ROP_TARGET_CFG_FIFO_WMSTAT_CHP_ROP_HCW ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_ROP_TARGET_CFG_FIFO_WMSTAT_CHP_ROP_HCW ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_FIFO_WMSTAT_CHP_ROP_HCW ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_FIFO_WMSTAT_CHP_ROP_HCW ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_ROP_TARGET_CFG_FIFO_WMSTAT_CHP_ROP_HCW * 32 +: 32 ] )
) ;
hqm_AW_register_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h00000006 )
) i_hqm_rop_target_cfg_fifo_wmstat_dir_rply_req (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_rop_target_cfg_fifo_wmstat_dir_rply_req_reg_nxt )
        , .reg_f                ( hqm_rop_target_cfg_fifo_wmstat_dir_rply_req_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_ROP_TARGET_CFG_FIFO_WMSTAT_DIR_RPLY_REQ ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_ROP_TARGET_CFG_FIFO_WMSTAT_DIR_RPLY_REQ ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_FIFO_WMSTAT_DIR_RPLY_REQ ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_FIFO_WMSTAT_DIR_RPLY_REQ ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_ROP_TARGET_CFG_FIFO_WMSTAT_DIR_RPLY_REQ * 32 +: 32 ] )
) ;
hqm_AW_register_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h00000006 )
) i_hqm_rop_target_cfg_fifo_wmstat_ldb_rply_req (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_rop_target_cfg_fifo_wmstat_ldb_rply_req_reg_nxt )
        , .reg_f                ( hqm_rop_target_cfg_fifo_wmstat_ldb_rply_req_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_ROP_TARGET_CFG_FIFO_WMSTAT_LDB_RPLY_REQ ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_ROP_TARGET_CFG_FIFO_WMSTAT_LDB_RPLY_REQ ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_FIFO_WMSTAT_LDB_RPLY_REQ ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_FIFO_WMSTAT_LDB_RPLY_REQ ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_ROP_TARGET_CFG_FIFO_WMSTAT_LDB_RPLY_REQ * 32 +: 32 ] )
) ;
hqm_AW_register_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h00000004 )
) i_hqm_rop_target_cfg_fifo_wmstat_lsp_reordercmp (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_rop_target_cfg_fifo_wmstat_lsp_reordercmp_reg_nxt )
        , .reg_f                ( hqm_rop_target_cfg_fifo_wmstat_lsp_reordercmp_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_ROP_TARGET_CFG_FIFO_WMSTAT_LSP_REORDERCMP ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_ROP_TARGET_CFG_FIFO_WMSTAT_LSP_REORDERCMP ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_FIFO_WMSTAT_LSP_REORDERCMP ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_FIFO_WMSTAT_LSP_REORDERCMP ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_ROP_TARGET_CFG_FIFO_WMSTAT_LSP_REORDERCMP * 32 +: 32 ] )
) ;
hqm_AW_register_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h00000004 )
) i_hqm_rop_target_cfg_fifo_wmstat_sn_complete (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_rop_target_cfg_fifo_wmstat_sn_complete_reg_nxt )
        , .reg_f                ( hqm_rop_target_cfg_fifo_wmstat_sn_complete_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_ROP_TARGET_CFG_FIFO_WMSTAT_SN_COMPLETE ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_ROP_TARGET_CFG_FIFO_WMSTAT_SN_COMPLETE ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_FIFO_WMSTAT_SN_COMPLETE ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_FIFO_WMSTAT_SN_COMPLETE ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_ROP_TARGET_CFG_FIFO_WMSTAT_SN_COMPLETE * 32 +: 32 ] )
) ;
hqm_AW_register_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h00000018 )
) i_hqm_rop_target_cfg_fifo_wmstat_sn_ordered (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_rop_target_cfg_fifo_wmstat_sn_ordered_reg_nxt )
        , .reg_f                ( hqm_rop_target_cfg_fifo_wmstat_sn_ordered_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_ROP_TARGET_CFG_FIFO_WMSTAT_SN_ORDERED ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_ROP_TARGET_CFG_FIFO_WMSTAT_SN_ORDERED ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_FIFO_WMSTAT_SN_ORDERED ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_FIFO_WMSTAT_SN_ORDERED ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_ROP_TARGET_CFG_FIFO_WMSTAT_SN_ORDERED * 32 +: 32 ] )
) ;
hqm_AW_status_wtcfg i_hqm_rop_target_cfg_frag_integrity_count (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .status               ( hqm_rop_target_cfg_frag_integrity_count_status )
        , .cfg_write            ( mux_cfg_req_write [ HQM_ROP_TARGET_CFG_FRAG_INTEGRITY_COUNT ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_ROP_TARGET_CFG_FRAG_INTEGRITY_COUNT ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_FRAG_INTEGRITY_COUNT ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_FRAG_INTEGRITY_COUNT ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_ROP_TARGET_CFG_FRAG_INTEGRITY_COUNT * 32 +: 32 ] )
) ;
hqm_AW_register_enable_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h00000000 )
) i_hqm_rop_target_cfg_grp_sn_mode (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_rop_target_cfg_grp_sn_mode_reg_nxt )
        , .reg_f                ( hqm_rop_target_cfg_grp_sn_mode_reg_f )
        , .reg_v                ( hqm_rop_target_cfg_grp_sn_mode_reg_v )
        , .cfg_write            ( mux_cfg_req_write [ HQM_ROP_TARGET_CFG_GRP_SN_MODE ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_ROP_TARGET_CFG_GRP_SN_MODE ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_GRP_SN_MODE ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_GRP_SN_MODE ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_ROP_TARGET_CFG_GRP_SN_MODE * 32 +: 32 ] )
) ;
hqm_AW_register_enable_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h00000000 )
) i_hqm_rop_target_cfg_hw_agitate_control (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_rop_target_cfg_hw_agitate_control_reg_nxt )
        , .reg_f                ( hqm_rop_target_cfg_hw_agitate_control_reg_f )
        , .reg_v                ( hqm_rop_target_cfg_hw_agitate_control_reg_v )
        , .cfg_write            ( mux_cfg_req_write [ HQM_ROP_TARGET_CFG_HW_AGITATE_CONTROL ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_ROP_TARGET_CFG_HW_AGITATE_CONTROL ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_HW_AGITATE_CONTROL ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_HW_AGITATE_CONTROL ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_ROP_TARGET_CFG_HW_AGITATE_CONTROL * 32 +: 32 ] )
) ;
hqm_AW_register_enable_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h00000000 )
) i_hqm_rop_target_cfg_hw_agitate_select (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_rop_target_cfg_hw_agitate_select_reg_nxt )
        , .reg_f                ( hqm_rop_target_cfg_hw_agitate_select_reg_f )
        , .reg_v                ( hqm_rop_target_cfg_hw_agitate_select_reg_v )
        , .cfg_write            ( mux_cfg_req_write [ HQM_ROP_TARGET_CFG_HW_AGITATE_SELECT ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_ROP_TARGET_CFG_HW_AGITATE_SELECT ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_HW_AGITATE_SELECT ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_HW_AGITATE_SELECT ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_ROP_TARGET_CFG_HW_AGITATE_SELECT * 32 +: 32 ] )
) ;
hqm_AW_status_wtcfg i_hqm_rop_target_cfg_interface_status (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .status               ( hqm_rop_target_cfg_interface_status_status )
        , .cfg_write            ( mux_cfg_req_write [ HQM_ROP_TARGET_CFG_INTERFACE_STATUS ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_ROP_TARGET_CFG_INTERFACE_STATUS ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_INTERFACE_STATUS ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_INTERFACE_STATUS ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_ROP_TARGET_CFG_INTERFACE_STATUS * 32 +: 32 ] )
) ;
hqm_AW_register_enable_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h00000740 )
) i_hqm_rop_target_cfg_patch_control (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_rop_target_cfg_patch_control_reg_nxt )
        , .reg_f                ( hqm_rop_target_cfg_patch_control_reg_f )
        , .reg_v                ( hqm_rop_target_cfg_patch_control_reg_v )
        , .cfg_write            ( mux_cfg_req_write [ HQM_ROP_TARGET_CFG_PATCH_CONTROL ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_ROP_TARGET_CFG_PATCH_CONTROL ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_PATCH_CONTROL ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_PATCH_CONTROL ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_ROP_TARGET_CFG_PATCH_CONTROL * 32 +: 32 ] )
) ;
hqm_AW_status_wtcfg i_hqm_rop_target_cfg_pipe_health_hold_grp0 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .status               ( hqm_rop_target_cfg_pipe_health_hold_grp0_status )
        , .cfg_write            ( mux_cfg_req_write [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_HOLD_GRP0 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_HOLD_GRP0 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_HOLD_GRP0 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_HOLD_GRP0 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_HOLD_GRP0 * 32 +: 32 ] )
) ;
hqm_AW_status_wtcfg i_hqm_rop_target_cfg_pipe_health_hold_grp1 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .status               ( hqm_rop_target_cfg_pipe_health_hold_grp1_status )
        , .cfg_write            ( mux_cfg_req_write [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_HOLD_GRP1 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_HOLD_GRP1 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_HOLD_GRP1 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_HOLD_GRP1 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_HOLD_GRP1 * 32 +: 32 ] )
) ;
hqm_AW_status_wtcfg i_hqm_rop_target_cfg_pipe_health_hold_rop_dp (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .status               ( hqm_rop_target_cfg_pipe_health_hold_rop_dp_status )
        , .cfg_write            ( mux_cfg_req_write [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_HOLD_ROP_DP ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_HOLD_ROP_DP ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_HOLD_ROP_DP ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_HOLD_ROP_DP ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_HOLD_ROP_DP * 32 +: 32 ] )
) ;
hqm_AW_status_wtcfg i_hqm_rop_target_cfg_pipe_health_hold_rop_lsp_reordcomp (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .status               ( hqm_rop_target_cfg_pipe_health_hold_rop_lsp_reordcomp_status )
        , .cfg_write            ( mux_cfg_req_write [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_HOLD_ROP_LSP_REORDCOMP ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_HOLD_ROP_LSP_REORDCOMP ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_HOLD_ROP_LSP_REORDCOMP ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_HOLD_ROP_LSP_REORDCOMP ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_HOLD_ROP_LSP_REORDCOMP * 32 +: 32 ] )
) ;
hqm_AW_status_wtcfg i_hqm_rop_target_cfg_pipe_health_hold_rop_nalb (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .status               ( hqm_rop_target_cfg_pipe_health_hold_rop_nalb_status )
        , .cfg_write            ( mux_cfg_req_write [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_HOLD_ROP_NALB ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_HOLD_ROP_NALB ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_HOLD_ROP_NALB ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_HOLD_ROP_NALB ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_HOLD_ROP_NALB * 32 +: 32 ] )
) ;
hqm_AW_status_wtcfg i_hqm_rop_target_cfg_pipe_health_hold_rop_qed_dqed (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .status               ( hqm_rop_target_cfg_pipe_health_hold_rop_qed_dqed_status )
        , .cfg_write            ( mux_cfg_req_write [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_HOLD_ROP_QED_DQED ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_HOLD_ROP_QED_DQED ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_HOLD_ROP_QED_DQED ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_HOLD_ROP_QED_DQED ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_HOLD_ROP_QED_DQED * 32 +: 32 ] )
) ;
hqm_AW_statusram_wtcfg #(
          .WIDTH                ( 32 )
        , .DEPTH                ( 32 )
        , .CFG_READ_MASK        ( 32'hffffffff )
) i_hqm_rop_target_cfg_pipe_health_seqnum_state_grp0 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .status               ( hqm_rop_target_cfg_pipe_health_seqnum_state_grp0_status )
        , .cfg_write            ( mux_cfg_req_write [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_SEQNUM_STATE_GRP0 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_SEQNUM_STATE_GRP0 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_SEQNUM_STATE_GRP0 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_SEQNUM_STATE_GRP0 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_SEQNUM_STATE_GRP0 * 32 +: 32 ] )
) ;
hqm_AW_statusram_wtcfg #(
          .WIDTH                ( 32 )
        , .DEPTH                ( 32 )
        , .CFG_READ_MASK        ( 32'hffffffff )
) i_hqm_rop_target_cfg_pipe_health_seqnum_state_grp1 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .status               ( hqm_rop_target_cfg_pipe_health_seqnum_state_grp1_status )
        , .cfg_write            ( mux_cfg_req_write [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_SEQNUM_STATE_GRP1 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_SEQNUM_STATE_GRP1 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_SEQNUM_STATE_GRP1 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_SEQNUM_STATE_GRP1 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_SEQNUM_STATE_GRP1 * 32 +: 32 ] )
) ;
hqm_AW_status_wtcfg i_hqm_rop_target_cfg_pipe_health_valid_grp0 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .status               ( hqm_rop_target_cfg_pipe_health_valid_grp0_status )
        , .cfg_write            ( mux_cfg_req_write [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_VALID_GRP0 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_VALID_GRP0 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_VALID_GRP0 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_VALID_GRP0 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_VALID_GRP0 * 32 +: 32 ] )
) ;
hqm_AW_status_wtcfg i_hqm_rop_target_cfg_pipe_health_valid_grp1 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .status               ( hqm_rop_target_cfg_pipe_health_valid_grp1_status )
        , .cfg_write            ( mux_cfg_req_write [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_VALID_GRP1 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_VALID_GRP1 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_VALID_GRP1 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_VALID_GRP1 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_VALID_GRP1 * 32 +: 32 ] )
) ;
hqm_AW_status_wtcfg i_hqm_rop_target_cfg_pipe_health_valid_rop_dp (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .status               ( hqm_rop_target_cfg_pipe_health_valid_rop_dp_status )
        , .cfg_write            ( mux_cfg_req_write [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_VALID_ROP_DP ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_VALID_ROP_DP ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_VALID_ROP_DP ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_VALID_ROP_DP ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_VALID_ROP_DP * 32 +: 32 ] )
) ;
hqm_AW_status_wtcfg i_hqm_rop_target_cfg_pipe_health_valid_rop_lsp_reordcomp (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .status               ( hqm_rop_target_cfg_pipe_health_valid_rop_lsp_reordcomp_status )
        , .cfg_write            ( mux_cfg_req_write [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_VALID_ROP_LSP_REORDCOMP ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_VALID_ROP_LSP_REORDCOMP ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_VALID_ROP_LSP_REORDCOMP ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_VALID_ROP_LSP_REORDCOMP ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_VALID_ROP_LSP_REORDCOMP * 32 +: 32 ] )
) ;
hqm_AW_status_wtcfg i_hqm_rop_target_cfg_pipe_health_valid_rop_nalb (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .status               ( hqm_rop_target_cfg_pipe_health_valid_rop_nalb_status )
        , .cfg_write            ( mux_cfg_req_write [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_VALID_ROP_NALB ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_VALID_ROP_NALB ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_VALID_ROP_NALB ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_VALID_ROP_NALB ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_VALID_ROP_NALB * 32 +: 32 ] )
) ;
hqm_AW_status_wtcfg i_hqm_rop_target_cfg_pipe_health_valid_rop_qed_dqed (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .status               ( hqm_rop_target_cfg_pipe_health_valid_rop_qed_dqed_status )
        , .cfg_write            ( mux_cfg_req_write [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_VALID_ROP_QED_DQED ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_VALID_ROP_QED_DQED ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_VALID_ROP_QED_DQED ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_VALID_ROP_QED_DQED ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_ROP_TARGET_CFG_PIPE_HEALTH_VALID_ROP_QED_DQED * 32 +: 32 ] )
) ;
hqm_AW_register_enable_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h00003f7f )
) i_hqm_rop_target_cfg_rop_csr_control (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_rop_target_cfg_rop_csr_control_reg_nxt )
        , .reg_f                ( hqm_rop_target_cfg_rop_csr_control_reg_f )
        , .reg_v                ( hqm_rop_target_cfg_rop_csr_control_reg_v )
        , .cfg_write            ( mux_cfg_req_write [ HQM_ROP_TARGET_CFG_ROP_CSR_CONTROL ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_ROP_TARGET_CFG_ROP_CSR_CONTROL ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_ROP_CSR_CONTROL ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_ROP_CSR_CONTROL ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_ROP_TARGET_CFG_ROP_CSR_CONTROL * 32 +: 32 ] )
) ;
hqm_AW_status_wtcfg i_hqm_rop_target_cfg_serializer_status (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .status               ( hqm_rop_target_cfg_serializer_status_status )
        , .cfg_write            ( mux_cfg_req_write [ HQM_ROP_TARGET_CFG_SERIALIZER_STATUS ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_ROP_TARGET_CFG_SERIALIZER_STATUS ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_SERIALIZER_STATUS ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_SERIALIZER_STATUS ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_ROP_TARGET_CFG_SERIALIZER_STATUS * 32 +: 32 ] )
) ;
hqm_AW_smon_wtcfg #( 
          .WIDTH                       ( 16 ) 
) i_hqm_rop_target_cfg_smon ( 
          .clk                         ( hqm_gated_clk )
        , .rst_n                       ( hqm_gated_rst_n )
        , .cfg_write                   ( { mux_cfg_req_write[ HQM_ROP_TARGET_CFG_SMON_MAXIMUM_TIMER ]
                                          , mux_cfg_req_write[HQM_ROP_TARGET_CFG_SMON_TIMER ]
                                          , mux_cfg_req_write[ HQM_ROP_TARGET_CFG_SMON_ACTIVITYCOUNTER1 ]
                                          , mux_cfg_req_write[ HQM_ROP_TARGET_CFG_SMON_ACTIVITYCOUNTER0 ]
                                          , mux_cfg_req_write[ HQM_ROP_TARGET_CFG_SMON_COMPARE1 ]
                                          , mux_cfg_req_write[ HQM_ROP_TARGET_CFG_SMON_COMPARE0 ]
                                          , mux_cfg_req_write[ HQM_ROP_TARGET_CFG_SMON_CONFIGURATION1 ]
                                          , mux_cfg_req_write[ HQM_ROP_TARGET_CFG_SMON_CONFIGURATION0 ]
                                          }
                                        )
        , .cfg_read                    ( { mux_cfg_req_read[ HQM_ROP_TARGET_CFG_SMON_MAXIMUM_TIMER ]
                                          , mux_cfg_req_read[ HQM_ROP_TARGET_CFG_SMON_TIMER ]
                                          , mux_cfg_req_read[ HQM_ROP_TARGET_CFG_SMON_ACTIVITYCOUNTER1 ]
                                          , mux_cfg_req_read[ HQM_ROP_TARGET_CFG_SMON_ACTIVITYCOUNTER0 ]
                                          , mux_cfg_req_read[ HQM_ROP_TARGET_CFG_SMON_COMPARE1 ]
                                          , mux_cfg_req_read[ HQM_ROP_TARGET_CFG_SMON_COMPARE0 ]
                                          , mux_cfg_req_read[ HQM_ROP_TARGET_CFG_SMON_CONFIGURATION1 ]
                                          , mux_cfg_req_read[ HQM_ROP_TARGET_CFG_SMON_CONFIGURATION0 ]
                                          }
                                        )
        , .cfg_req                     ( mux_cfg_req )
        , .cfg_ack                     ( mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_SMON_CONFIGURATION0 * 1 +: 1 ] )
        , .cfg_err                     ( mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_SMON_CONFIGURATION0 * 1 +: 1 ] )
        , .cfg_rdata                   ( mux_cfg_rsp_rdata_pnc [ HQM_ROP_TARGET_CFG_SMON_CONFIGURATION0 * 32 +: 32 ] )
        , .disable_smon                ( hqm_rop_target_cfg_smon_disable_smon )
        , .in_mon_v                    ( hqm_rop_target_cfg_smon_smon_v )
        , .in_mon_comp                 ( hqm_rop_target_cfg_smon_smon_comp )
        , .in_mon_val                  ( hqm_rop_target_cfg_smon_smon_val )
        , .out_smon_interrupt          ( hqm_rop_target_cfg_smon_smon_interrupt )
        , .out_smon_enabled            ( hqm_rop_target_cfg_smon_smon_enabled )
) ;
assign mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_SMON_CONFIGURATION1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_SMON_CONFIGURATION1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ HQM_ROP_TARGET_CFG_SMON_CONFIGURATION1 * 32 +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_SMON_COMPARE0 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_SMON_COMPARE0 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ HQM_ROP_TARGET_CFG_SMON_COMPARE0 * 32 +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_SMON_COMPARE1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_SMON_COMPARE1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ HQM_ROP_TARGET_CFG_SMON_COMPARE1 * 32 +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_SMON_ACTIVITYCOUNTER0 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_SMON_ACTIVITYCOUNTER0 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ HQM_ROP_TARGET_CFG_SMON_ACTIVITYCOUNTER0 * 32 +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_SMON_ACTIVITYCOUNTER1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_SMON_ACTIVITYCOUNTER1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ HQM_ROP_TARGET_CFG_SMON_ACTIVITYCOUNTER1 * 32 +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_SMON_TIMER ] = '0 ;
assign mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_SMON_TIMER ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ HQM_ROP_TARGET_CFG_SMON_TIMER * 32 +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_SMON_MAXIMUM_TIMER ] = '0 ;
assign mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_SMON_MAXIMUM_TIMER ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ HQM_ROP_TARGET_CFG_SMON_MAXIMUM_TIMER * 32 +: 32 ] = '0 ;
hqm_AW_syndrome_wtcfg i_hqm_rop_target_cfg_syndrome_00 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .cfg_write            ( mux_cfg_req_write [ HQM_ROP_TARGET_CFG_SYNDROME_00 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_ROP_TARGET_CFG_SYNDROME_00 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_SYNDROME_00 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_SYNDROME_00 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_ROP_TARGET_CFG_SYNDROME_00 * 32 +: 32 ] )
        , .capture_v            ( hqm_rop_target_cfg_syndrome_00_capture_v )
        , .capture_data         ( hqm_rop_target_cfg_syndrome_00_capture_data )
        , .syndrome_data        ( hqm_rop_target_cfg_syndrome_00_syndrome_data )
) ;
hqm_AW_syndrome_wtcfg i_hqm_rop_target_cfg_syndrome_01 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .cfg_write            ( mux_cfg_req_write [ HQM_ROP_TARGET_CFG_SYNDROME_01 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_ROP_TARGET_CFG_SYNDROME_01 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_SYNDROME_01 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_SYNDROME_01 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_ROP_TARGET_CFG_SYNDROME_01 * 32 +: 32 ] )
        , .capture_v            ( hqm_rop_target_cfg_syndrome_01_capture_v )
        , .capture_data         ( hqm_rop_target_cfg_syndrome_01_capture_data )
        , .syndrome_data        ( hqm_rop_target_cfg_syndrome_01_syndrome_data )
) ;
hqm_AW_register_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h00000003 )
) i_hqm_rop_target_cfg_unit_idle (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_rop_target_cfg_unit_idle_reg_nxt )
        , .reg_f                ( hqm_rop_target_cfg_unit_idle_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_ROP_TARGET_CFG_UNIT_IDLE ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_ROP_TARGET_CFG_UNIT_IDLE ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_UNIT_IDLE ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_UNIT_IDLE ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_ROP_TARGET_CFG_UNIT_IDLE * 32 +: 32 ] )
) ;
hqm_AW_register_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( HQM_UNIT_TIMEOUT_DEFAULT )
) i_hqm_rop_target_cfg_unit_timeout (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_rop_target_cfg_unit_timeout_reg_nxt )
        , .reg_f                ( hqm_rop_target_cfg_unit_timeout_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_ROP_TARGET_CFG_UNIT_TIMEOUT ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_ROP_TARGET_CFG_UNIT_TIMEOUT ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_UNIT_TIMEOUT ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_UNIT_TIMEOUT ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_ROP_TARGET_CFG_UNIT_TIMEOUT * 32 +: 32 ] )
) ;
hqm_AW_status_wtcfg i_hqm_rop_target_cfg_unit_version (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .status               ( hqm_rop_target_cfg_unit_version_status )
        , .cfg_write            ( mux_cfg_req_write [ HQM_ROP_TARGET_CFG_UNIT_VERSION ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_ROP_TARGET_CFG_UNIT_VERSION ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_ROP_TARGET_CFG_UNIT_VERSION ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_ROP_TARGET_CFG_UNIT_VERSION ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_ROP_TARGET_CFG_UNIT_VERSION * 32 +: 32 ] )
) ;
assign mux_cfg_rsp_ack_pnc [ (HQM_ROP_TARGET_CFG_GRP_0_SLOT_SHIFT * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_ROP_TARGET_CFG_GRP_0_SLOT_SHIFT * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_ROP_TARGET_CFG_GRP_0_SLOT_SHIFT * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_ROP_TARGET_CFG_GRP_1_SLOT_SHIFT * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_ROP_TARGET_CFG_GRP_1_SLOT_SHIFT * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_ROP_TARGET_CFG_GRP_1_SLOT_SHIFT * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_ROP_TARGET_CFG_REORDER_STATE_CNT * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_ROP_TARGET_CFG_REORDER_STATE_CNT * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_ROP_TARGET_CFG_REORDER_STATE_CNT * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_ROP_TARGET_CFG_REORDER_STATE_DIR_HP * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_ROP_TARGET_CFG_REORDER_STATE_DIR_HP * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_ROP_TARGET_CFG_REORDER_STATE_DIR_HP * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_ROP_TARGET_CFG_REORDER_STATE_DIR_TP * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_ROP_TARGET_CFG_REORDER_STATE_DIR_TP * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_ROP_TARGET_CFG_REORDER_STATE_DIR_TP * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_ROP_TARGET_CFG_REORDER_STATE_NALB_HP * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_ROP_TARGET_CFG_REORDER_STATE_NALB_HP * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_ROP_TARGET_CFG_REORDER_STATE_NALB_HP * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_ROP_TARGET_CFG_REORDER_STATE_NALB_TP * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_ROP_TARGET_CFG_REORDER_STATE_NALB_TP * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_ROP_TARGET_CFG_REORDER_STATE_NALB_TP * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_ROP_TARGET_CFG_REORDER_STATE_QID_QIDIX_CQ * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_ROP_TARGET_CFG_REORDER_STATE_QID_QIDIX_CQ * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_ROP_TARGET_CFG_REORDER_STATE_QID_QIDIX_CQ * 32 ) +: 32 ] = '0 ;
endmodule
