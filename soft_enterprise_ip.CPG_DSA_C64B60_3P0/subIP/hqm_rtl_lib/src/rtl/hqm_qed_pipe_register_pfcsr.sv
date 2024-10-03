module hqm_qed_pipe_register_pfcsr
import hqm_AW_pkg::* , hqm_pkg::* , hqm_core_pkg::* ;
(
  input logic hqm_gated_clk
, input logic hqm_gated_rst_n
, input logic rst_prep 
, input logic [ ( HQM_QED_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] cfg_req_write 
, input logic [ ( HQM_QED_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] cfg_req_read 
, input cfg_req_t cfg_req 
, output logic cfg_rsp_ack 
, output logic cfg_rsp_err 
, output logic [ ( 32 ) - 1 : 0 ] cfg_rsp_rdata 
, input logic hqm_qed_target_cfg_2rdy1iss_en
, input logic hqm_qed_target_cfg_2rdy1iss_clr
, input logic hqm_qed_target_cfg_2rdy1iss_clrv
, input logic hqm_qed_target_cfg_2rdy1iss_inc
, output logic [ ( 64 ) - 1 : 0] hqm_qed_target_cfg_2rdy1iss_count
, input logic hqm_qed_target_cfg_2rdy2iss_en
, input logic hqm_qed_target_cfg_2rdy2iss_clr
, input logic hqm_qed_target_cfg_2rdy2iss_clrv
, input logic hqm_qed_target_cfg_2rdy2iss_inc
, output logic [ ( 64 ) - 1 : 0] hqm_qed_target_cfg_2rdy2iss_count
, input logic hqm_qed_target_cfg_3rdy1iss_en
, input logic hqm_qed_target_cfg_3rdy1iss_clr
, input logic hqm_qed_target_cfg_3rdy1iss_clrv
, input logic hqm_qed_target_cfg_3rdy1iss_inc
, output logic [ ( 64 ) - 1 : 0] hqm_qed_target_cfg_3rdy1iss_count
, input logic hqm_qed_target_cfg_3rdy2iss_en
, input logic hqm_qed_target_cfg_3rdy2iss_clr
, input logic hqm_qed_target_cfg_3rdy2iss_clrv
, input logic hqm_qed_target_cfg_3rdy2iss_inc
, output logic [ ( 64 ) - 1 : 0] hqm_qed_target_cfg_3rdy2iss_count
, input logic [ ( 32 ) - 1 : 0] hqm_qed_target_cfg_control_general_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_qed_target_cfg_control_general_reg_f
, input logic hqm_qed_target_cfg_control_general_reg_v
, input logic [ ( 32 ) - 1 : 0] hqm_qed_target_cfg_control_pipeline_credits_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_qed_target_cfg_control_pipeline_credits_reg_f
, input logic hqm_qed_target_cfg_control_pipeline_credits_reg_v
, input logic [ ( 32 ) - 1 : 0] hqm_qed_target_cfg_diagnostic_aw_status_status
, input logic [ ( 32 ) - 1 : 0] hqm_qed_target_cfg_error_inject_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_qed_target_cfg_error_inject_reg_f
, input logic hqm_qed_target_cfg_error_inject_reg_v
, input logic [ ( 32 ) - 1 : 0] hqm_qed_target_cfg_hw_agitate_control_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_qed_target_cfg_hw_agitate_control_reg_f
, input logic hqm_qed_target_cfg_hw_agitate_control_reg_v
, input logic [ ( 32 ) - 1 : 0] hqm_qed_target_cfg_hw_agitate_select_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_qed_target_cfg_hw_agitate_select_reg_f
, input logic hqm_qed_target_cfg_hw_agitate_select_reg_v
, input logic [ ( 32 ) - 1 : 0] hqm_qed_target_cfg_interface_status_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_qed_target_cfg_interface_status_reg_f
, input logic [ ( 32 ) - 1 : 0] hqm_qed_target_cfg_patch_control_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_qed_target_cfg_patch_control_reg_f
, input logic hqm_qed_target_cfg_patch_control_reg_v
, input logic [ ( 32 ) - 1 : 0] hqm_qed_target_cfg_pipe_health_hold_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_qed_target_cfg_pipe_health_hold_reg_f
, input logic [ ( 32 ) - 1 : 0] hqm_qed_target_cfg_pipe_health_valid_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_qed_target_cfg_pipe_health_valid_reg_f
, input logic [ ( 32 ) - 1 : 0] hqm_qed_target_cfg_qed_csr_control_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_qed_target_cfg_qed_csr_control_reg_f
, input logic hqm_qed_target_cfg_qed_csr_control_reg_v
, input logic hqm_qed_target_cfg_smon_disable_smon
, input logic [ 16 - 1 : 0 ] hqm_qed_target_cfg_smon_smon_v
, input logic [ ( 16 * 32 ) - 1 : 0 ] hqm_qed_target_cfg_smon_smon_comp
, input logic [ ( 16 * 32 ) - 1 : 0 ] hqm_qed_target_cfg_smon_smon_val
, output logic hqm_qed_target_cfg_smon_smon_enabled
, output logic hqm_qed_target_cfg_smon_smon_interrupt
, input logic hqm_qed_target_cfg_syndrome_00_capture_v
, input logic [ ( 31 ) - 1 : 0] hqm_qed_target_cfg_syndrome_00_capture_data
, output logic [ ( 32 ) - 1 : 0] hqm_qed_target_cfg_syndrome_00_syndrome_data
, input logic [ ( 32 ) - 1 : 0] hqm_qed_target_cfg_unit_idle_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_qed_target_cfg_unit_idle_reg_f
, input logic [ ( 32 ) - 1 : 0] hqm_qed_target_cfg_unit_timeout_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_qed_target_cfg_unit_timeout_reg_f
, input logic [ ( 32 ) - 1 : 0] hqm_qed_target_cfg_unit_version_status
);
logic [ ( HQM_QED_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] mux_cfg_req_write ;
logic [ ( HQM_QED_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] mux_cfg_req_read ;
cfg_req_t mux_cfg_req ;
logic [ ( HQM_QED_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] mux_cfg_rsp_ack_pnc ;
logic [ ( HQM_QED_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] mux_cfg_rsp_err_pnc ;
logic [ ( HQM_QED_CFG_UNIT_NUM_TGTS * 32 ) - 1 : 0 ] mux_cfg_rsp_rdata_pnc ;
always_comb begin
  mux_cfg_req_write = cfg_req_write ;
  mux_cfg_req_read = cfg_req_read ;
  mux_cfg_req = cfg_req ;
end
hqm_AW_cfg_rsp #(
    .NUM_TGTS ( 31 )
) i_hqm_AW_cfg_rsp_0 (
    .clk ( hqm_gated_clk )
  , .rst_n ( hqm_gated_rst_n )
  , .in_cfg_rsp_ack ( {
                        mux_cfg_rsp_ack_pnc [ HQM_QED_TARGET_CFG_2RDY1ISS_H ]
                      , mux_cfg_rsp_ack_pnc [ HQM_QED_TARGET_CFG_2RDY1ISS_L ]
                      , mux_cfg_rsp_ack_pnc [ HQM_QED_TARGET_CFG_2RDY2ISS_H ]
                      , mux_cfg_rsp_ack_pnc [ HQM_QED_TARGET_CFG_2RDY2ISS_L ]
                      , mux_cfg_rsp_ack_pnc [ HQM_QED_TARGET_CFG_3RDY1ISS_H ]
                      , mux_cfg_rsp_ack_pnc [ HQM_QED_TARGET_CFG_3RDY1ISS_L ]
                      , mux_cfg_rsp_ack_pnc [ HQM_QED_TARGET_CFG_3RDY2ISS_H ]
                      , mux_cfg_rsp_ack_pnc [ HQM_QED_TARGET_CFG_3RDY2ISS_L ]
                      , mux_cfg_rsp_ack_pnc [ HQM_QED_TARGET_CFG_CONTROL_GENERAL ]
                      , mux_cfg_rsp_ack_pnc [ HQM_QED_TARGET_CFG_CONTROL_PIPELINE_CREDITS ]
                      , mux_cfg_rsp_ack_pnc [ HQM_QED_TARGET_CFG_DIAGNOSTIC_AW_STATUS ]
                      , mux_cfg_rsp_ack_pnc [ HQM_QED_TARGET_CFG_ERROR_INJECT ]
                      , mux_cfg_rsp_ack_pnc [ HQM_QED_TARGET_CFG_HW_AGITATE_CONTROL ]
                      , mux_cfg_rsp_ack_pnc [ HQM_QED_TARGET_CFG_HW_AGITATE_SELECT ]
                      , mux_cfg_rsp_ack_pnc [ HQM_QED_TARGET_CFG_INTERFACE_STATUS ]
                      , mux_cfg_rsp_ack_pnc [ HQM_QED_TARGET_CFG_PATCH_CONTROL ]
                      , mux_cfg_rsp_ack_pnc [ HQM_QED_TARGET_CFG_PIPE_HEALTH_HOLD ]
                      , mux_cfg_rsp_ack_pnc [ HQM_QED_TARGET_CFG_PIPE_HEALTH_VALID ]
                      , mux_cfg_rsp_ack_pnc [ HQM_QED_TARGET_CFG_QED_CSR_CONTROL ]
                      , mux_cfg_rsp_ack_pnc [ HQM_QED_TARGET_CFG_SMON_ACTIVITYCOUNTER0 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_QED_TARGET_CFG_SMON_ACTIVITYCOUNTER1 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_QED_TARGET_CFG_SMON_COMPARE0 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_QED_TARGET_CFG_SMON_COMPARE1 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_QED_TARGET_CFG_SMON_CONFIGURATION0 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_QED_TARGET_CFG_SMON_CONFIGURATION1 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_QED_TARGET_CFG_SMON_MAXIMUM_TIMER ]
                      , mux_cfg_rsp_ack_pnc [ HQM_QED_TARGET_CFG_SMON_TIMER ]
                      , mux_cfg_rsp_ack_pnc [ HQM_QED_TARGET_CFG_SYNDROME_00 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_QED_TARGET_CFG_UNIT_IDLE ]
                      , mux_cfg_rsp_ack_pnc [ HQM_QED_TARGET_CFG_UNIT_TIMEOUT ]
                      , mux_cfg_rsp_ack_pnc [ HQM_QED_TARGET_CFG_UNIT_VERSION ]
                      } )
  , .in_cfg_rsp_err ( {
                        mux_cfg_rsp_err_pnc [ HQM_QED_TARGET_CFG_2RDY1ISS_H ]
                      , mux_cfg_rsp_err_pnc [ HQM_QED_TARGET_CFG_2RDY1ISS_L ]
                      , mux_cfg_rsp_err_pnc [ HQM_QED_TARGET_CFG_2RDY2ISS_H ]
                      , mux_cfg_rsp_err_pnc [ HQM_QED_TARGET_CFG_2RDY2ISS_L ]
                      , mux_cfg_rsp_err_pnc [ HQM_QED_TARGET_CFG_3RDY1ISS_H ]
                      , mux_cfg_rsp_err_pnc [ HQM_QED_TARGET_CFG_3RDY1ISS_L ]
                      , mux_cfg_rsp_err_pnc [ HQM_QED_TARGET_CFG_3RDY2ISS_H ]
                      , mux_cfg_rsp_err_pnc [ HQM_QED_TARGET_CFG_3RDY2ISS_L ]
                      , mux_cfg_rsp_err_pnc [ HQM_QED_TARGET_CFG_CONTROL_GENERAL ]
                      , mux_cfg_rsp_err_pnc [ HQM_QED_TARGET_CFG_CONTROL_PIPELINE_CREDITS ]
                      , mux_cfg_rsp_err_pnc [ HQM_QED_TARGET_CFG_DIAGNOSTIC_AW_STATUS ]
                      , mux_cfg_rsp_err_pnc [ HQM_QED_TARGET_CFG_ERROR_INJECT ]
                      , mux_cfg_rsp_err_pnc [ HQM_QED_TARGET_CFG_HW_AGITATE_CONTROL ]
                      , mux_cfg_rsp_err_pnc [ HQM_QED_TARGET_CFG_HW_AGITATE_SELECT ]
                      , mux_cfg_rsp_err_pnc [ HQM_QED_TARGET_CFG_INTERFACE_STATUS ]
                      , mux_cfg_rsp_err_pnc [ HQM_QED_TARGET_CFG_PATCH_CONTROL ]
                      , mux_cfg_rsp_err_pnc [ HQM_QED_TARGET_CFG_PIPE_HEALTH_HOLD ]
                      , mux_cfg_rsp_err_pnc [ HQM_QED_TARGET_CFG_PIPE_HEALTH_VALID ]
                      , mux_cfg_rsp_err_pnc [ HQM_QED_TARGET_CFG_QED_CSR_CONTROL ]
                      , mux_cfg_rsp_err_pnc [ HQM_QED_TARGET_CFG_SMON_ACTIVITYCOUNTER0 ]
                      , mux_cfg_rsp_err_pnc [ HQM_QED_TARGET_CFG_SMON_ACTIVITYCOUNTER1 ]
                      , mux_cfg_rsp_err_pnc [ HQM_QED_TARGET_CFG_SMON_COMPARE0 ]
                      , mux_cfg_rsp_err_pnc [ HQM_QED_TARGET_CFG_SMON_COMPARE1 ]
                      , mux_cfg_rsp_err_pnc [ HQM_QED_TARGET_CFG_SMON_CONFIGURATION0 ]
                      , mux_cfg_rsp_err_pnc [ HQM_QED_TARGET_CFG_SMON_CONFIGURATION1 ]
                      , mux_cfg_rsp_err_pnc [ HQM_QED_TARGET_CFG_SMON_MAXIMUM_TIMER ]
                      , mux_cfg_rsp_err_pnc [ HQM_QED_TARGET_CFG_SMON_TIMER ]
                      , mux_cfg_rsp_err_pnc [ HQM_QED_TARGET_CFG_SYNDROME_00 ]
                      , mux_cfg_rsp_err_pnc [ HQM_QED_TARGET_CFG_UNIT_IDLE ]
                      , mux_cfg_rsp_err_pnc [ HQM_QED_TARGET_CFG_UNIT_TIMEOUT ]
                      , mux_cfg_rsp_err_pnc [ HQM_QED_TARGET_CFG_UNIT_VERSION ]
                      } )
  , .in_cfg_rsp_rdata ( {
                        mux_cfg_rsp_rdata_pnc [ ( HQM_QED_TARGET_CFG_2RDY1ISS_H * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_QED_TARGET_CFG_2RDY1ISS_L * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_QED_TARGET_CFG_2RDY2ISS_H * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_QED_TARGET_CFG_2RDY2ISS_L * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_QED_TARGET_CFG_3RDY1ISS_H * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_QED_TARGET_CFG_3RDY1ISS_L * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_QED_TARGET_CFG_3RDY2ISS_H * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_QED_TARGET_CFG_3RDY2ISS_L * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_QED_TARGET_CFG_CONTROL_GENERAL * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_QED_TARGET_CFG_CONTROL_PIPELINE_CREDITS * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_QED_TARGET_CFG_DIAGNOSTIC_AW_STATUS * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_QED_TARGET_CFG_ERROR_INJECT * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_QED_TARGET_CFG_HW_AGITATE_CONTROL * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_QED_TARGET_CFG_HW_AGITATE_SELECT * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_QED_TARGET_CFG_INTERFACE_STATUS * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_QED_TARGET_CFG_PATCH_CONTROL * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_QED_TARGET_CFG_PIPE_HEALTH_HOLD * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_QED_TARGET_CFG_PIPE_HEALTH_VALID * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_QED_TARGET_CFG_QED_CSR_CONTROL * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_QED_TARGET_CFG_SMON_ACTIVITYCOUNTER0 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_QED_TARGET_CFG_SMON_ACTIVITYCOUNTER1 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_QED_TARGET_CFG_SMON_COMPARE0 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_QED_TARGET_CFG_SMON_COMPARE1 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_QED_TARGET_CFG_SMON_CONFIGURATION0 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_QED_TARGET_CFG_SMON_CONFIGURATION1 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_QED_TARGET_CFG_SMON_MAXIMUM_TIMER * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_QED_TARGET_CFG_SMON_TIMER * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_QED_TARGET_CFG_SYNDROME_00 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_QED_TARGET_CFG_UNIT_IDLE * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_QED_TARGET_CFG_UNIT_TIMEOUT * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_QED_TARGET_CFG_UNIT_VERSION * 32 ) +: 32 ]
                      } )
   , .out_cfg_rsp_ack ( cfg_rsp_ack )
   , .out_cfg_rsp_err ( cfg_rsp_err )
   , .out_cfg_rsp_rdata ( cfg_rsp_rdata )
) ;
hqm_AW_inc_64b_wtcfg i_hqm_qed_target_cfg_2rdy1iss (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .cfg_write            ( { mux_cfg_req_write [ HQM_QED_TARGET_CFG_2RDY1ISS_H ] , mux_cfg_req_write [ HQM_QED_TARGET_CFG_2RDY1ISS_L ] } )
        , .cfg_read             ( { mux_cfg_req_read [ HQM_QED_TARGET_CFG_2RDY1ISS_H ] , mux_cfg_req_read [ HQM_QED_TARGET_CFG_2RDY1ISS_L ] } )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( { mux_cfg_rsp_ack_pnc [ HQM_QED_TARGET_CFG_2RDY1ISS_H ] , mux_cfg_rsp_ack_pnc [ HQM_QED_TARGET_CFG_2RDY1ISS_L ] } )
        , .cfg_err              ( { mux_cfg_rsp_err_pnc [ HQM_QED_TARGET_CFG_2RDY1ISS_H ] , mux_cfg_rsp_err_pnc [ HQM_QED_TARGET_CFG_2RDY1ISS_L ] } )
        , .cfg_rdata            ( { mux_cfg_rsp_rdata_pnc [ HQM_QED_TARGET_CFG_2RDY1ISS_H * 32 +: 32 ] , mux_cfg_rsp_rdata_pnc [ HQM_QED_TARGET_CFG_2RDY1ISS_L * 32 +: 32 ] } )
        , .en                   ( hqm_qed_target_cfg_2rdy1iss_en )
        , .clr                  ( hqm_qed_target_cfg_2rdy1iss_clr )
        , .clrv                 ( hqm_qed_target_cfg_2rdy1iss_clrv )
        , .inc                  ( hqm_qed_target_cfg_2rdy1iss_inc )
        , .count                ( hqm_qed_target_cfg_2rdy1iss_count )
) ;
hqm_AW_inc_64b_wtcfg i_hqm_qed_target_cfg_2rdy2iss (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .cfg_write            ( { mux_cfg_req_write [ HQM_QED_TARGET_CFG_2RDY2ISS_H ] , mux_cfg_req_write [ HQM_QED_TARGET_CFG_2RDY2ISS_L ] } )
        , .cfg_read             ( { mux_cfg_req_read [ HQM_QED_TARGET_CFG_2RDY2ISS_H ] , mux_cfg_req_read [ HQM_QED_TARGET_CFG_2RDY2ISS_L ] } )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( { mux_cfg_rsp_ack_pnc [ HQM_QED_TARGET_CFG_2RDY2ISS_H ] , mux_cfg_rsp_ack_pnc [ HQM_QED_TARGET_CFG_2RDY2ISS_L ] } )
        , .cfg_err              ( { mux_cfg_rsp_err_pnc [ HQM_QED_TARGET_CFG_2RDY2ISS_H ] , mux_cfg_rsp_err_pnc [ HQM_QED_TARGET_CFG_2RDY2ISS_L ] } )
        , .cfg_rdata            ( { mux_cfg_rsp_rdata_pnc [ HQM_QED_TARGET_CFG_2RDY2ISS_H * 32 +: 32 ] , mux_cfg_rsp_rdata_pnc [ HQM_QED_TARGET_CFG_2RDY2ISS_L * 32 +: 32 ] } )
        , .en                   ( hqm_qed_target_cfg_2rdy2iss_en )
        , .clr                  ( hqm_qed_target_cfg_2rdy2iss_clr )
        , .clrv                 ( hqm_qed_target_cfg_2rdy2iss_clrv )
        , .inc                  ( hqm_qed_target_cfg_2rdy2iss_inc )
        , .count                ( hqm_qed_target_cfg_2rdy2iss_count )
) ;
hqm_AW_inc_64b_wtcfg i_hqm_qed_target_cfg_3rdy1iss (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .cfg_write            ( { mux_cfg_req_write [ HQM_QED_TARGET_CFG_3RDY1ISS_H ] , mux_cfg_req_write [ HQM_QED_TARGET_CFG_3RDY1ISS_L ] } )
        , .cfg_read             ( { mux_cfg_req_read [ HQM_QED_TARGET_CFG_3RDY1ISS_H ] , mux_cfg_req_read [ HQM_QED_TARGET_CFG_3RDY1ISS_L ] } )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( { mux_cfg_rsp_ack_pnc [ HQM_QED_TARGET_CFG_3RDY1ISS_H ] , mux_cfg_rsp_ack_pnc [ HQM_QED_TARGET_CFG_3RDY1ISS_L ] } )
        , .cfg_err              ( { mux_cfg_rsp_err_pnc [ HQM_QED_TARGET_CFG_3RDY1ISS_H ] , mux_cfg_rsp_err_pnc [ HQM_QED_TARGET_CFG_3RDY1ISS_L ] } )
        , .cfg_rdata            ( { mux_cfg_rsp_rdata_pnc [ HQM_QED_TARGET_CFG_3RDY1ISS_H * 32 +: 32 ] , mux_cfg_rsp_rdata_pnc [ HQM_QED_TARGET_CFG_3RDY1ISS_L * 32 +: 32 ] } )
        , .en                   ( hqm_qed_target_cfg_3rdy1iss_en )
        , .clr                  ( hqm_qed_target_cfg_3rdy1iss_clr )
        , .clrv                 ( hqm_qed_target_cfg_3rdy1iss_clrv )
        , .inc                  ( hqm_qed_target_cfg_3rdy1iss_inc )
        , .count                ( hqm_qed_target_cfg_3rdy1iss_count )
) ;
hqm_AW_inc_64b_wtcfg i_hqm_qed_target_cfg_3rdy2iss (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .cfg_write            ( { mux_cfg_req_write [ HQM_QED_TARGET_CFG_3RDY2ISS_H ] , mux_cfg_req_write [ HQM_QED_TARGET_CFG_3RDY2ISS_L ] } )
        , .cfg_read             ( { mux_cfg_req_read [ HQM_QED_TARGET_CFG_3RDY2ISS_H ] , mux_cfg_req_read [ HQM_QED_TARGET_CFG_3RDY2ISS_L ] } )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( { mux_cfg_rsp_ack_pnc [ HQM_QED_TARGET_CFG_3RDY2ISS_H ] , mux_cfg_rsp_ack_pnc [ HQM_QED_TARGET_CFG_3RDY2ISS_L ] } )
        , .cfg_err              ( { mux_cfg_rsp_err_pnc [ HQM_QED_TARGET_CFG_3RDY2ISS_H ] , mux_cfg_rsp_err_pnc [ HQM_QED_TARGET_CFG_3RDY2ISS_L ] } )
        , .cfg_rdata            ( { mux_cfg_rsp_rdata_pnc [ HQM_QED_TARGET_CFG_3RDY2ISS_H * 32 +: 32 ] , mux_cfg_rsp_rdata_pnc [ HQM_QED_TARGET_CFG_3RDY2ISS_L * 32 +: 32 ] } )
        , .en                   ( hqm_qed_target_cfg_3rdy2iss_en )
        , .clr                  ( hqm_qed_target_cfg_3rdy2iss_clr )
        , .clrv                 ( hqm_qed_target_cfg_3rdy2iss_clrv )
        , .inc                  ( hqm_qed_target_cfg_3rdy2iss_inc )
        , .count                ( hqm_qed_target_cfg_3rdy2iss_count )
) ;
hqm_AW_register_enable_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h00000000 )
) i_hqm_qed_target_cfg_control_general (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_qed_target_cfg_control_general_reg_nxt )
        , .reg_f                ( hqm_qed_target_cfg_control_general_reg_f )
        , .reg_v                ( hqm_qed_target_cfg_control_general_reg_v )
        , .cfg_write            ( mux_cfg_req_write [ HQM_QED_TARGET_CFG_CONTROL_GENERAL ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_QED_TARGET_CFG_CONTROL_GENERAL ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_QED_TARGET_CFG_CONTROL_GENERAL ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_QED_TARGET_CFG_CONTROL_GENERAL ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_QED_TARGET_CFG_CONTROL_GENERAL * 32 +: 32 ] )
) ;
hqm_AW_register_enable_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( HQM_QED_CFG_CONTROL_PIPE_CREDITS_DEFAULT )
) i_hqm_qed_target_cfg_control_pipeline_credits (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_qed_target_cfg_control_pipeline_credits_reg_nxt )
        , .reg_f                ( hqm_qed_target_cfg_control_pipeline_credits_reg_f )
        , .reg_v                ( hqm_qed_target_cfg_control_pipeline_credits_reg_v )
        , .cfg_write            ( mux_cfg_req_write [ HQM_QED_TARGET_CFG_CONTROL_PIPELINE_CREDITS ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_QED_TARGET_CFG_CONTROL_PIPELINE_CREDITS ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_QED_TARGET_CFG_CONTROL_PIPELINE_CREDITS ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_QED_TARGET_CFG_CONTROL_PIPELINE_CREDITS ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_QED_TARGET_CFG_CONTROL_PIPELINE_CREDITS * 32 +: 32 ] )
) ;
hqm_AW_status_wtcfg i_hqm_qed_target_cfg_diagnostic_aw_status (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .status               ( hqm_qed_target_cfg_diagnostic_aw_status_status )
        , .cfg_write            ( mux_cfg_req_write [ HQM_QED_TARGET_CFG_DIAGNOSTIC_AW_STATUS ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_QED_TARGET_CFG_DIAGNOSTIC_AW_STATUS ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_QED_TARGET_CFG_DIAGNOSTIC_AW_STATUS ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_QED_TARGET_CFG_DIAGNOSTIC_AW_STATUS ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_QED_TARGET_CFG_DIAGNOSTIC_AW_STATUS * 32 +: 32 ] )
) ;
hqm_AW_register_enable_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h00000000 )
) i_hqm_qed_target_cfg_error_inject (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_qed_target_cfg_error_inject_reg_nxt )
        , .reg_f                ( hqm_qed_target_cfg_error_inject_reg_f )
        , .reg_v                ( hqm_qed_target_cfg_error_inject_reg_v )
        , .cfg_write            ( mux_cfg_req_write [ HQM_QED_TARGET_CFG_ERROR_INJECT ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_QED_TARGET_CFG_ERROR_INJECT ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_QED_TARGET_CFG_ERROR_INJECT ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_QED_TARGET_CFG_ERROR_INJECT ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_QED_TARGET_CFG_ERROR_INJECT * 32 +: 32 ] )
) ;
hqm_AW_register_enable_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h00000000 )
) i_hqm_qed_target_cfg_hw_agitate_control (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_qed_target_cfg_hw_agitate_control_reg_nxt )
        , .reg_f                ( hqm_qed_target_cfg_hw_agitate_control_reg_f )
        , .reg_v                ( hqm_qed_target_cfg_hw_agitate_control_reg_v )
        , .cfg_write            ( mux_cfg_req_write [ HQM_QED_TARGET_CFG_HW_AGITATE_CONTROL ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_QED_TARGET_CFG_HW_AGITATE_CONTROL ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_QED_TARGET_CFG_HW_AGITATE_CONTROL ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_QED_TARGET_CFG_HW_AGITATE_CONTROL ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_QED_TARGET_CFG_HW_AGITATE_CONTROL * 32 +: 32 ] )
) ;
hqm_AW_register_enable_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h00000000 )
) i_hqm_qed_target_cfg_hw_agitate_select (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_qed_target_cfg_hw_agitate_select_reg_nxt )
        , .reg_f                ( hqm_qed_target_cfg_hw_agitate_select_reg_f )
        , .reg_v                ( hqm_qed_target_cfg_hw_agitate_select_reg_v )
        , .cfg_write            ( mux_cfg_req_write [ HQM_QED_TARGET_CFG_HW_AGITATE_SELECT ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_QED_TARGET_CFG_HW_AGITATE_SELECT ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_QED_TARGET_CFG_HW_AGITATE_SELECT ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_QED_TARGET_CFG_HW_AGITATE_SELECT ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_QED_TARGET_CFG_HW_AGITATE_SELECT * 32 +: 32 ] )
) ;
hqm_AW_register_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h00000000 )
) i_hqm_qed_target_cfg_interface_status (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_qed_target_cfg_interface_status_reg_nxt )
        , .reg_f                ( hqm_qed_target_cfg_interface_status_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_QED_TARGET_CFG_INTERFACE_STATUS ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_QED_TARGET_CFG_INTERFACE_STATUS ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_QED_TARGET_CFG_INTERFACE_STATUS ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_QED_TARGET_CFG_INTERFACE_STATUS ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_QED_TARGET_CFG_INTERFACE_STATUS * 32 +: 32 ] )
) ;
hqm_AW_register_enable_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h00000740 )
) i_hqm_qed_target_cfg_patch_control (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_qed_target_cfg_patch_control_reg_nxt )
        , .reg_f                ( hqm_qed_target_cfg_patch_control_reg_f )
        , .reg_v                ( hqm_qed_target_cfg_patch_control_reg_v )
        , .cfg_write            ( mux_cfg_req_write [ HQM_QED_TARGET_CFG_PATCH_CONTROL ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_QED_TARGET_CFG_PATCH_CONTROL ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_QED_TARGET_CFG_PATCH_CONTROL ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_QED_TARGET_CFG_PATCH_CONTROL ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_QED_TARGET_CFG_PATCH_CONTROL * 32 +: 32 ] )
) ;
hqm_AW_register_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h00000000 )
) i_hqm_qed_target_cfg_pipe_health_hold (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_qed_target_cfg_pipe_health_hold_reg_nxt )
        , .reg_f                ( hqm_qed_target_cfg_pipe_health_hold_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_QED_TARGET_CFG_PIPE_HEALTH_HOLD ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_QED_TARGET_CFG_PIPE_HEALTH_HOLD ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_QED_TARGET_CFG_PIPE_HEALTH_HOLD ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_QED_TARGET_CFG_PIPE_HEALTH_HOLD ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_QED_TARGET_CFG_PIPE_HEALTH_HOLD * 32 +: 32 ] )
) ;
hqm_AW_register_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h00000000 )
) i_hqm_qed_target_cfg_pipe_health_valid (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_qed_target_cfg_pipe_health_valid_reg_nxt )
        , .reg_f                ( hqm_qed_target_cfg_pipe_health_valid_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_QED_TARGET_CFG_PIPE_HEALTH_VALID ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_QED_TARGET_CFG_PIPE_HEALTH_VALID ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_QED_TARGET_CFG_PIPE_HEALTH_VALID ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_QED_TARGET_CFG_PIPE_HEALTH_VALID ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_QED_TARGET_CFG_PIPE_HEALTH_VALID * 32 +: 32 ] )
) ;
hqm_AW_register_enable_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h00000000 )
) i_hqm_qed_target_cfg_qed_csr_control (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_qed_target_cfg_qed_csr_control_reg_nxt )
        , .reg_f                ( hqm_qed_target_cfg_qed_csr_control_reg_f )
        , .reg_v                ( hqm_qed_target_cfg_qed_csr_control_reg_v )
        , .cfg_write            ( mux_cfg_req_write [ HQM_QED_TARGET_CFG_QED_CSR_CONTROL ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_QED_TARGET_CFG_QED_CSR_CONTROL ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_QED_TARGET_CFG_QED_CSR_CONTROL ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_QED_TARGET_CFG_QED_CSR_CONTROL ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_QED_TARGET_CFG_QED_CSR_CONTROL * 32 +: 32 ] )
) ;
hqm_AW_smon_wtcfg #( 
          .WIDTH                       ( 16 ) 
) i_hqm_qed_target_cfg_smon ( 
          .clk                         ( hqm_gated_clk )
        , .rst_n                       ( hqm_gated_rst_n )
        , .cfg_write                   ( { mux_cfg_req_write[ HQM_QED_TARGET_CFG_SMON_MAXIMUM_TIMER ]
                                          , mux_cfg_req_write[HQM_QED_TARGET_CFG_SMON_TIMER ]
                                          , mux_cfg_req_write[ HQM_QED_TARGET_CFG_SMON_ACTIVITYCOUNTER1 ]
                                          , mux_cfg_req_write[ HQM_QED_TARGET_CFG_SMON_ACTIVITYCOUNTER0 ]
                                          , mux_cfg_req_write[ HQM_QED_TARGET_CFG_SMON_COMPARE1 ]
                                          , mux_cfg_req_write[ HQM_QED_TARGET_CFG_SMON_COMPARE0 ]
                                          , mux_cfg_req_write[ HQM_QED_TARGET_CFG_SMON_CONFIGURATION1 ]
                                          , mux_cfg_req_write[ HQM_QED_TARGET_CFG_SMON_CONFIGURATION0 ]
                                          }
                                        )
        , .cfg_read                    ( { mux_cfg_req_read[ HQM_QED_TARGET_CFG_SMON_MAXIMUM_TIMER ]
                                          , mux_cfg_req_read[ HQM_QED_TARGET_CFG_SMON_TIMER ]
                                          , mux_cfg_req_read[ HQM_QED_TARGET_CFG_SMON_ACTIVITYCOUNTER1 ]
                                          , mux_cfg_req_read[ HQM_QED_TARGET_CFG_SMON_ACTIVITYCOUNTER0 ]
                                          , mux_cfg_req_read[ HQM_QED_TARGET_CFG_SMON_COMPARE1 ]
                                          , mux_cfg_req_read[ HQM_QED_TARGET_CFG_SMON_COMPARE0 ]
                                          , mux_cfg_req_read[ HQM_QED_TARGET_CFG_SMON_CONFIGURATION1 ]
                                          , mux_cfg_req_read[ HQM_QED_TARGET_CFG_SMON_CONFIGURATION0 ]
                                          }
                                        )
        , .cfg_req                     ( mux_cfg_req )
        , .cfg_ack                     ( mux_cfg_rsp_ack_pnc [ HQM_QED_TARGET_CFG_SMON_CONFIGURATION0 * 1 +: 1 ] )
        , .cfg_err                     ( mux_cfg_rsp_err_pnc [ HQM_QED_TARGET_CFG_SMON_CONFIGURATION0 * 1 +: 1 ] )
        , .cfg_rdata                   ( mux_cfg_rsp_rdata_pnc [ HQM_QED_TARGET_CFG_SMON_CONFIGURATION0 * 32 +: 32 ] )
        , .disable_smon                ( hqm_qed_target_cfg_smon_disable_smon )
        , .in_mon_v                    ( hqm_qed_target_cfg_smon_smon_v )
        , .in_mon_comp                 ( hqm_qed_target_cfg_smon_smon_comp )
        , .in_mon_val                  ( hqm_qed_target_cfg_smon_smon_val )
        , .out_smon_interrupt          ( hqm_qed_target_cfg_smon_smon_interrupt )
        , .out_smon_enabled            ( hqm_qed_target_cfg_smon_smon_enabled )
) ;
assign mux_cfg_rsp_ack_pnc [ HQM_QED_TARGET_CFG_SMON_CONFIGURATION1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ HQM_QED_TARGET_CFG_SMON_CONFIGURATION1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ HQM_QED_TARGET_CFG_SMON_CONFIGURATION1 * 32 +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ HQM_QED_TARGET_CFG_SMON_COMPARE0 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ HQM_QED_TARGET_CFG_SMON_COMPARE0 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ HQM_QED_TARGET_CFG_SMON_COMPARE0 * 32 +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ HQM_QED_TARGET_CFG_SMON_COMPARE1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ HQM_QED_TARGET_CFG_SMON_COMPARE1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ HQM_QED_TARGET_CFG_SMON_COMPARE1 * 32 +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ HQM_QED_TARGET_CFG_SMON_ACTIVITYCOUNTER0 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ HQM_QED_TARGET_CFG_SMON_ACTIVITYCOUNTER0 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ HQM_QED_TARGET_CFG_SMON_ACTIVITYCOUNTER0 * 32 +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ HQM_QED_TARGET_CFG_SMON_ACTIVITYCOUNTER1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ HQM_QED_TARGET_CFG_SMON_ACTIVITYCOUNTER1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ HQM_QED_TARGET_CFG_SMON_ACTIVITYCOUNTER1 * 32 +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ HQM_QED_TARGET_CFG_SMON_TIMER ] = '0 ;
assign mux_cfg_rsp_err_pnc [ HQM_QED_TARGET_CFG_SMON_TIMER ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ HQM_QED_TARGET_CFG_SMON_TIMER * 32 +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ HQM_QED_TARGET_CFG_SMON_MAXIMUM_TIMER ] = '0 ;
assign mux_cfg_rsp_err_pnc [ HQM_QED_TARGET_CFG_SMON_MAXIMUM_TIMER ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ HQM_QED_TARGET_CFG_SMON_MAXIMUM_TIMER * 32 +: 32 ] = '0 ;
hqm_AW_syndrome_wtcfg i_hqm_qed_target_cfg_syndrome_00 (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .cfg_write            ( mux_cfg_req_write [ HQM_QED_TARGET_CFG_SYNDROME_00 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_QED_TARGET_CFG_SYNDROME_00 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_QED_TARGET_CFG_SYNDROME_00 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_QED_TARGET_CFG_SYNDROME_00 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_QED_TARGET_CFG_SYNDROME_00 * 32 +: 32 ] )
        , .capture_v            ( hqm_qed_target_cfg_syndrome_00_capture_v )
        , .capture_data         ( hqm_qed_target_cfg_syndrome_00_capture_data )
        , .syndrome_data        ( hqm_qed_target_cfg_syndrome_00_syndrome_data )
) ;
hqm_AW_register_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h00000003 )
) i_hqm_qed_target_cfg_unit_idle (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_qed_target_cfg_unit_idle_reg_nxt )
        , .reg_f                ( hqm_qed_target_cfg_unit_idle_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_QED_TARGET_CFG_UNIT_IDLE ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_QED_TARGET_CFG_UNIT_IDLE ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_QED_TARGET_CFG_UNIT_IDLE ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_QED_TARGET_CFG_UNIT_IDLE ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_QED_TARGET_CFG_UNIT_IDLE * 32 +: 32 ] )
) ;
hqm_AW_register_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( HQM_UNIT_TIMEOUT_DEFAULT )
) i_hqm_qed_target_cfg_unit_timeout (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_qed_target_cfg_unit_timeout_reg_nxt )
        , .reg_f                ( hqm_qed_target_cfg_unit_timeout_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_QED_TARGET_CFG_UNIT_TIMEOUT ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_QED_TARGET_CFG_UNIT_TIMEOUT ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_QED_TARGET_CFG_UNIT_TIMEOUT ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_QED_TARGET_CFG_UNIT_TIMEOUT ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_QED_TARGET_CFG_UNIT_TIMEOUT * 32 +: 32 ] )
) ;
hqm_AW_status_wtcfg i_hqm_qed_target_cfg_unit_version (
          .clk                  ( hqm_gated_clk )
        , .rst_n                ( hqm_gated_rst_n )
        , .status               ( hqm_qed_target_cfg_unit_version_status )
        , .cfg_write            ( mux_cfg_req_write [ HQM_QED_TARGET_CFG_UNIT_VERSION ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_QED_TARGET_CFG_UNIT_VERSION ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_QED_TARGET_CFG_UNIT_VERSION ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_QED_TARGET_CFG_UNIT_VERSION ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_QED_TARGET_CFG_UNIT_VERSION * 32 +: 32 ] )
) ;
assign mux_cfg_rsp_ack_pnc [ (HQM_QED_TARGET_CFG_QED0_WRD0 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_QED_TARGET_CFG_QED0_WRD0 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_QED_TARGET_CFG_QED0_WRD0 * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_QED_TARGET_CFG_QED0_WRD1 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_QED_TARGET_CFG_QED0_WRD1 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_QED_TARGET_CFG_QED0_WRD1 * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_QED_TARGET_CFG_QED0_WRD2 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_QED_TARGET_CFG_QED0_WRD2 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_QED_TARGET_CFG_QED0_WRD2 * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_QED_TARGET_CFG_QED0_WRD3 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_QED_TARGET_CFG_QED0_WRD3 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_QED_TARGET_CFG_QED0_WRD3 * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_QED_TARGET_CFG_QED1_WRD0 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_QED_TARGET_CFG_QED1_WRD0 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_QED_TARGET_CFG_QED1_WRD0 * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_QED_TARGET_CFG_QED1_WRD1 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_QED_TARGET_CFG_QED1_WRD1 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_QED_TARGET_CFG_QED1_WRD1 * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_QED_TARGET_CFG_QED1_WRD2 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_QED_TARGET_CFG_QED1_WRD2 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_QED_TARGET_CFG_QED1_WRD2 * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_QED_TARGET_CFG_QED1_WRD3 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_QED_TARGET_CFG_QED1_WRD3 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_QED_TARGET_CFG_QED1_WRD3 * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_QED_TARGET_CFG_QED2_WRD0 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_QED_TARGET_CFG_QED2_WRD0 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_QED_TARGET_CFG_QED2_WRD0 * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_QED_TARGET_CFG_QED2_WRD1 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_QED_TARGET_CFG_QED2_WRD1 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_QED_TARGET_CFG_QED2_WRD1 * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_QED_TARGET_CFG_QED2_WRD2 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_QED_TARGET_CFG_QED2_WRD2 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_QED_TARGET_CFG_QED2_WRD2 * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_QED_TARGET_CFG_QED2_WRD3 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_QED_TARGET_CFG_QED2_WRD3 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_QED_TARGET_CFG_QED2_WRD3 * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_QED_TARGET_CFG_QED3_WRD0 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_QED_TARGET_CFG_QED3_WRD0 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_QED_TARGET_CFG_QED3_WRD0 * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_QED_TARGET_CFG_QED3_WRD1 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_QED_TARGET_CFG_QED3_WRD1 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_QED_TARGET_CFG_QED3_WRD1 * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_QED_TARGET_CFG_QED3_WRD2 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_QED_TARGET_CFG_QED3_WRD2 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_QED_TARGET_CFG_QED3_WRD2 * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_QED_TARGET_CFG_QED3_WRD3 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_QED_TARGET_CFG_QED3_WRD3 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_QED_TARGET_CFG_QED3_WRD3 * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_QED_TARGET_CFG_QED4_WRD0 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_QED_TARGET_CFG_QED4_WRD0 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_QED_TARGET_CFG_QED4_WRD0 * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_QED_TARGET_CFG_QED4_WRD1 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_QED_TARGET_CFG_QED4_WRD1 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_QED_TARGET_CFG_QED4_WRD1 * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_QED_TARGET_CFG_QED4_WRD2 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_QED_TARGET_CFG_QED4_WRD2 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_QED_TARGET_CFG_QED4_WRD2 * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_QED_TARGET_CFG_QED4_WRD3 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_QED_TARGET_CFG_QED4_WRD3 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_QED_TARGET_CFG_QED4_WRD3 * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_QED_TARGET_CFG_QED5_WRD0 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_QED_TARGET_CFG_QED5_WRD0 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_QED_TARGET_CFG_QED5_WRD0 * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_QED_TARGET_CFG_QED5_WRD1 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_QED_TARGET_CFG_QED5_WRD1 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_QED_TARGET_CFG_QED5_WRD1 * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_QED_TARGET_CFG_QED5_WRD2 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_QED_TARGET_CFG_QED5_WRD2 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_QED_TARGET_CFG_QED5_WRD2 * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_QED_TARGET_CFG_QED5_WRD3 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_QED_TARGET_CFG_QED5_WRD3 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_QED_TARGET_CFG_QED5_WRD3 * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_QED_TARGET_CFG_QED6_WRD0 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_QED_TARGET_CFG_QED6_WRD0 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_QED_TARGET_CFG_QED6_WRD0 * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_QED_TARGET_CFG_QED6_WRD1 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_QED_TARGET_CFG_QED6_WRD1 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_QED_TARGET_CFG_QED6_WRD1 * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_QED_TARGET_CFG_QED6_WRD2 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_QED_TARGET_CFG_QED6_WRD2 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_QED_TARGET_CFG_QED6_WRD2 * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_QED_TARGET_CFG_QED6_WRD3 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_QED_TARGET_CFG_QED6_WRD3 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_QED_TARGET_CFG_QED6_WRD3 * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_QED_TARGET_CFG_QED7_WRD0 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_QED_TARGET_CFG_QED7_WRD0 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_QED_TARGET_CFG_QED7_WRD0 * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_QED_TARGET_CFG_QED7_WRD1 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_QED_TARGET_CFG_QED7_WRD1 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_QED_TARGET_CFG_QED7_WRD1 * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_QED_TARGET_CFG_QED7_WRD2 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_QED_TARGET_CFG_QED7_WRD2 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_QED_TARGET_CFG_QED7_WRD2 * 32 ) +: 32 ] = '0 ;
assign mux_cfg_rsp_ack_pnc [ (HQM_QED_TARGET_CFG_QED7_WRD3 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_err_pnc [ (HQM_QED_TARGET_CFG_QED7_WRD3 * 1 ) +: 1 ] = '0 ;
assign mux_cfg_rsp_rdata_pnc [ (HQM_QED_TARGET_CFG_QED7_WRD3 * 32 ) +: 32 ] = '0 ;
endmodule
