module hqm_cfg_master_register_prim
import hqm_AW_pkg::* , hqm_pkg::* , hqm_core_pkg::* ;
(
  input logic prim_gated_clk
, input logic prim_freerun_prim_gated_rst_b_sync
, input logic rst_prep 
, input logic [ ( HQM_MSTR_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] cfg_req_write 
, input logic [ ( HQM_MSTR_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] cfg_req_read 
, input cfg_req_t cfg_req 
, output logic cfg_rsp_ack 
, output logic cfg_rsp_err 
, output logic [ ( 32 ) - 1 : 0 ] cfg_rsp_rdata 
, input logic [ ( 32 ) - 1 : 0] hqm_mstr_target_cfg_clk_cnt_disable_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_mstr_target_cfg_clk_cnt_disable_reg_f
, input logic hqm_mstr_target_cfg_clk_on_cnt_en
, input logic hqm_mstr_target_cfg_clk_on_cnt_clr
, input logic hqm_mstr_target_cfg_clk_on_cnt_clrv
, input logic hqm_mstr_target_cfg_clk_on_cnt_inc
, output logic [ ( 64 ) - 1 : 0] hqm_mstr_target_cfg_clk_on_cnt_count
, input logic [ ( 32 ) - 1 : 0] hqm_mstr_target_cfg_control_general_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_mstr_target_cfg_control_general_reg_f
, input logic hqm_mstr_target_cfg_d3tod0_event_cnt_en
, input logic hqm_mstr_target_cfg_d3tod0_event_cnt_clr
, input logic hqm_mstr_target_cfg_d3tod0_event_cnt_clrv
, input logic hqm_mstr_target_cfg_d3tod0_event_cnt_inc
, output logic [ ( 64 ) - 1 : 0] hqm_mstr_target_cfg_d3tod0_event_cnt_count
, input logic [ ( 32 ) - 1 : 0] hqm_mstr_target_cfg_diagnostic_heartbeat_status
, input logic [ ( 32 ) - 1 : 0] hqm_mstr_target_cfg_diagnostic_idle_status_status
, input logic [ ( 32 ) - 1 : 0] hqm_mstr_target_cfg_diagnostic_proc_lcb_status_status
, input logic [ ( 32 ) - 1 : 0] hqm_mstr_target_cfg_diagnostic_reset_status_status
, input logic [ ( 32 ) - 1 : 0] hqm_mstr_target_cfg_diagnostic_status_1_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_mstr_target_cfg_diagnostic_status_1_reg_f
, input logic hqm_mstr_target_cfg_diagnostic_status_1_reg_load
, input logic hqm_mstr_target_cfg_diagnostic_syndrome_capture_v
, input logic [ ( 31 ) - 1 : 0] hqm_mstr_target_cfg_diagnostic_syndrome_capture_data
, output logic [ ( 32 ) - 1 : 0] hqm_mstr_target_cfg_diagnostic_syndrome_syndrome_data
, input logic [ ( 32 ) - 1 : 0] hqm_mstr_target_cfg_flr_count_h_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_mstr_target_cfg_flr_count_h_reg_f
, input logic [ ( 32 ) - 1 : 0] hqm_mstr_target_cfg_flr_count_l_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_mstr_target_cfg_flr_count_l_reg_f
, input logic [ ( 32 ) - 1 : 0] hqm_mstr_target_cfg_hqm_cdc_control_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_mstr_target_cfg_hqm_cdc_control_reg_f
, input logic [ ( 32 ) - 1 : 0] hqm_mstr_target_cfg_hqm_pgcb_control_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_mstr_target_cfg_hqm_pgcb_control_reg_f
, input logic [ ( 32 ) - 1 : 0] hqm_mstr_target_cfg_mstr_internal_timeout_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_mstr_target_cfg_mstr_internal_timeout_reg_f
, input logic [ ( 32 ) - 1 : 0] hqm_mstr_target_cfg_pm_override_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_mstr_target_cfg_pm_override_reg_f
, input logic [ ( 32 ) - 1 : 0] hqm_mstr_target_cfg_pm_pmcsr_disable_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_mstr_target_cfg_pm_pmcsr_disable_reg_f
, input logic [ ( 32 ) - 1 : 0] hqm_mstr_target_cfg_pm_status_status
, input logic hqm_mstr_target_cfg_prochot_cnt_en
, input logic hqm_mstr_target_cfg_prochot_cnt_clr
, input logic hqm_mstr_target_cfg_prochot_cnt_clrv
, input logic hqm_mstr_target_cfg_prochot_cnt_inc
, output logic [ ( 64 ) - 1 : 0] hqm_mstr_target_cfg_prochot_cnt_count
, input logic hqm_mstr_target_cfg_prochot_event_cnt_en
, input logic hqm_mstr_target_cfg_prochot_event_cnt_clr
, input logic hqm_mstr_target_cfg_prochot_event_cnt_clrv
, input logic hqm_mstr_target_cfg_prochot_event_cnt_inc
, output logic [ ( 64 ) - 1 : 0] hqm_mstr_target_cfg_prochot_event_cnt_count
, input logic hqm_mstr_target_cfg_proc_on_cnt_en
, input logic hqm_mstr_target_cfg_proc_on_cnt_clr
, input logic hqm_mstr_target_cfg_proc_on_cnt_clrv
, input logic hqm_mstr_target_cfg_proc_on_cnt_inc
, output logic [ ( 64 ) - 1 : 0] hqm_mstr_target_cfg_proc_on_cnt_count
, input logic [ ( 32 ) - 1 : 0] hqm_mstr_target_cfg_ts_control_reg_nxt
, output logic [ ( 32 ) - 1 : 0] hqm_mstr_target_cfg_ts_control_reg_f
, input logic [ ( 32 ) - 1 : 0] hqm_mstr_target_cfg_unit_version_status
);
logic [ ( HQM_MSTR_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] mux_cfg_req_write ;
logic [ ( HQM_MSTR_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] mux_cfg_req_read ;
cfg_req_t mux_cfg_req ;
logic [ ( HQM_MSTR_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] mux_cfg_rsp_ack_pnc ;
logic [ ( HQM_MSTR_CFG_UNIT_NUM_TGTS ) - 1 : 0 ] mux_cfg_rsp_err_pnc ;
logic [ ( HQM_MSTR_CFG_UNIT_NUM_TGTS * 32 ) - 1 : 0 ] mux_cfg_rsp_rdata_pnc ;
always_comb begin
  mux_cfg_req_write = cfg_req_write ;
  mux_cfg_req_read = cfg_req_read ;
  mux_cfg_req = cfg_req ;
end
hqm_AW_cfg_rsp #(
    .NUM_TGTS ( 28 )
) i_hqm_AW_cfg_rsp_0 (
    .clk ( prim_gated_clk )
  , .rst_n ( prim_freerun_prim_gated_rst_b_sync )
  , .in_cfg_rsp_ack ( {
                        mux_cfg_rsp_ack_pnc [ HQM_MSTR_TARGET_CFG_CLK_CNT_DISABLE ]
                      , mux_cfg_rsp_ack_pnc [ HQM_MSTR_TARGET_CFG_CLK_ON_CNT_H ]
                      , mux_cfg_rsp_ack_pnc [ HQM_MSTR_TARGET_CFG_CLK_ON_CNT_L ]
                      , mux_cfg_rsp_ack_pnc [ HQM_MSTR_TARGET_CFG_CONTROL_GENERAL ]
                      , mux_cfg_rsp_ack_pnc [ HQM_MSTR_TARGET_CFG_D3TOD0_EVENT_CNT_H ]
                      , mux_cfg_rsp_ack_pnc [ HQM_MSTR_TARGET_CFG_D3TOD0_EVENT_CNT_L ]
                      , mux_cfg_rsp_ack_pnc [ HQM_MSTR_TARGET_CFG_DIAGNOSTIC_HEARTBEAT ]
                      , mux_cfg_rsp_ack_pnc [ HQM_MSTR_TARGET_CFG_DIAGNOSTIC_IDLE_STATUS ]
                      , mux_cfg_rsp_ack_pnc [ HQM_MSTR_TARGET_CFG_DIAGNOSTIC_PROC_LCB_STATUS ]
                      , mux_cfg_rsp_ack_pnc [ HQM_MSTR_TARGET_CFG_DIAGNOSTIC_RESET_STATUS ]
                      , mux_cfg_rsp_ack_pnc [ HQM_MSTR_TARGET_CFG_DIAGNOSTIC_STATUS_1 ]
                      , mux_cfg_rsp_ack_pnc [ HQM_MSTR_TARGET_CFG_DIAGNOSTIC_SYNDROME ]
                      , mux_cfg_rsp_ack_pnc [ HQM_MSTR_TARGET_CFG_FLR_COUNT_H ]
                      , mux_cfg_rsp_ack_pnc [ HQM_MSTR_TARGET_CFG_FLR_COUNT_L ]
                      , mux_cfg_rsp_ack_pnc [ HQM_MSTR_TARGET_CFG_HQM_CDC_CONTROL ]
                      , mux_cfg_rsp_ack_pnc [ HQM_MSTR_TARGET_CFG_HQM_PGCB_CONTROL ]
                      , mux_cfg_rsp_ack_pnc [ HQM_MSTR_TARGET_CFG_MSTR_INTERNAL_TIMEOUT ]
                      , mux_cfg_rsp_ack_pnc [ HQM_MSTR_TARGET_CFG_PM_OVERRIDE ]
                      , mux_cfg_rsp_ack_pnc [ HQM_MSTR_TARGET_CFG_PM_PMCSR_DISABLE ]
                      , mux_cfg_rsp_ack_pnc [ HQM_MSTR_TARGET_CFG_PM_STATUS ]
                      , mux_cfg_rsp_ack_pnc [ HQM_MSTR_TARGET_CFG_PROCHOT_CNT_H ]
                      , mux_cfg_rsp_ack_pnc [ HQM_MSTR_TARGET_CFG_PROCHOT_CNT_L ]
                      , mux_cfg_rsp_ack_pnc [ HQM_MSTR_TARGET_CFG_PROCHOT_EVENT_CNT_H ]
                      , mux_cfg_rsp_ack_pnc [ HQM_MSTR_TARGET_CFG_PROCHOT_EVENT_CNT_L ]
                      , mux_cfg_rsp_ack_pnc [ HQM_MSTR_TARGET_CFG_PROC_ON_CNT_H ]
                      , mux_cfg_rsp_ack_pnc [ HQM_MSTR_TARGET_CFG_PROC_ON_CNT_L ]
                      , mux_cfg_rsp_ack_pnc [ HQM_MSTR_TARGET_CFG_TS_CONTROL ]
                      , mux_cfg_rsp_ack_pnc [ HQM_MSTR_TARGET_CFG_UNIT_VERSION ]
                      } )
  , .in_cfg_rsp_err ( {
                        mux_cfg_rsp_err_pnc [ HQM_MSTR_TARGET_CFG_CLK_CNT_DISABLE ]
                      , mux_cfg_rsp_err_pnc [ HQM_MSTR_TARGET_CFG_CLK_ON_CNT_H ]
                      , mux_cfg_rsp_err_pnc [ HQM_MSTR_TARGET_CFG_CLK_ON_CNT_L ]
                      , mux_cfg_rsp_err_pnc [ HQM_MSTR_TARGET_CFG_CONTROL_GENERAL ]
                      , mux_cfg_rsp_err_pnc [ HQM_MSTR_TARGET_CFG_D3TOD0_EVENT_CNT_H ]
                      , mux_cfg_rsp_err_pnc [ HQM_MSTR_TARGET_CFG_D3TOD0_EVENT_CNT_L ]
                      , mux_cfg_rsp_err_pnc [ HQM_MSTR_TARGET_CFG_DIAGNOSTIC_HEARTBEAT ]
                      , mux_cfg_rsp_err_pnc [ HQM_MSTR_TARGET_CFG_DIAGNOSTIC_IDLE_STATUS ]
                      , mux_cfg_rsp_err_pnc [ HQM_MSTR_TARGET_CFG_DIAGNOSTIC_PROC_LCB_STATUS ]
                      , mux_cfg_rsp_err_pnc [ HQM_MSTR_TARGET_CFG_DIAGNOSTIC_RESET_STATUS ]
                      , mux_cfg_rsp_err_pnc [ HQM_MSTR_TARGET_CFG_DIAGNOSTIC_STATUS_1 ]
                      , mux_cfg_rsp_err_pnc [ HQM_MSTR_TARGET_CFG_DIAGNOSTIC_SYNDROME ]
                      , mux_cfg_rsp_err_pnc [ HQM_MSTR_TARGET_CFG_FLR_COUNT_H ]
                      , mux_cfg_rsp_err_pnc [ HQM_MSTR_TARGET_CFG_FLR_COUNT_L ]
                      , mux_cfg_rsp_err_pnc [ HQM_MSTR_TARGET_CFG_HQM_CDC_CONTROL ]
                      , mux_cfg_rsp_err_pnc [ HQM_MSTR_TARGET_CFG_HQM_PGCB_CONTROL ]
                      , mux_cfg_rsp_err_pnc [ HQM_MSTR_TARGET_CFG_MSTR_INTERNAL_TIMEOUT ]
                      , mux_cfg_rsp_err_pnc [ HQM_MSTR_TARGET_CFG_PM_OVERRIDE ]
                      , mux_cfg_rsp_err_pnc [ HQM_MSTR_TARGET_CFG_PM_PMCSR_DISABLE ]
                      , mux_cfg_rsp_err_pnc [ HQM_MSTR_TARGET_CFG_PM_STATUS ]
                      , mux_cfg_rsp_err_pnc [ HQM_MSTR_TARGET_CFG_PROCHOT_CNT_H ]
                      , mux_cfg_rsp_err_pnc [ HQM_MSTR_TARGET_CFG_PROCHOT_CNT_L ]
                      , mux_cfg_rsp_err_pnc [ HQM_MSTR_TARGET_CFG_PROCHOT_EVENT_CNT_H ]
                      , mux_cfg_rsp_err_pnc [ HQM_MSTR_TARGET_CFG_PROCHOT_EVENT_CNT_L ]
                      , mux_cfg_rsp_err_pnc [ HQM_MSTR_TARGET_CFG_PROC_ON_CNT_H ]
                      , mux_cfg_rsp_err_pnc [ HQM_MSTR_TARGET_CFG_PROC_ON_CNT_L ]
                      , mux_cfg_rsp_err_pnc [ HQM_MSTR_TARGET_CFG_TS_CONTROL ]
                      , mux_cfg_rsp_err_pnc [ HQM_MSTR_TARGET_CFG_UNIT_VERSION ]
                      } )
  , .in_cfg_rsp_rdata ( {
                        mux_cfg_rsp_rdata_pnc [ ( HQM_MSTR_TARGET_CFG_CLK_CNT_DISABLE * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_MSTR_TARGET_CFG_CLK_ON_CNT_H * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_MSTR_TARGET_CFG_CLK_ON_CNT_L * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_MSTR_TARGET_CFG_CONTROL_GENERAL * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_MSTR_TARGET_CFG_D3TOD0_EVENT_CNT_H * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_MSTR_TARGET_CFG_D3TOD0_EVENT_CNT_L * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_MSTR_TARGET_CFG_DIAGNOSTIC_HEARTBEAT * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_MSTR_TARGET_CFG_DIAGNOSTIC_IDLE_STATUS * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_MSTR_TARGET_CFG_DIAGNOSTIC_PROC_LCB_STATUS * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_MSTR_TARGET_CFG_DIAGNOSTIC_RESET_STATUS * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_MSTR_TARGET_CFG_DIAGNOSTIC_STATUS_1 * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_MSTR_TARGET_CFG_DIAGNOSTIC_SYNDROME * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_MSTR_TARGET_CFG_FLR_COUNT_H * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_MSTR_TARGET_CFG_FLR_COUNT_L * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_MSTR_TARGET_CFG_HQM_CDC_CONTROL * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_MSTR_TARGET_CFG_HQM_PGCB_CONTROL * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_MSTR_TARGET_CFG_MSTR_INTERNAL_TIMEOUT * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_MSTR_TARGET_CFG_PM_OVERRIDE * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_MSTR_TARGET_CFG_PM_PMCSR_DISABLE * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_MSTR_TARGET_CFG_PM_STATUS * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_MSTR_TARGET_CFG_PROCHOT_CNT_H * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_MSTR_TARGET_CFG_PROCHOT_CNT_L * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_MSTR_TARGET_CFG_PROCHOT_EVENT_CNT_H * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_MSTR_TARGET_CFG_PROCHOT_EVENT_CNT_L * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_MSTR_TARGET_CFG_PROC_ON_CNT_H * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_MSTR_TARGET_CFG_PROC_ON_CNT_L * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_MSTR_TARGET_CFG_TS_CONTROL * 32 ) +: 32 ]
                      , mux_cfg_rsp_rdata_pnc [ ( HQM_MSTR_TARGET_CFG_UNIT_VERSION * 32 ) +: 32 ]
                      } )
   , .out_cfg_rsp_ack ( cfg_rsp_ack )
   , .out_cfg_rsp_err ( cfg_rsp_err )
   , .out_cfg_rsp_rdata ( cfg_rsp_rdata )
) ;
hqm_AW_register_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h00000000 )
) i_hqm_mstr_target_cfg_clk_cnt_disable (
          .clk                  ( prim_gated_clk )
        , .rst_n                ( prim_freerun_prim_gated_rst_b_sync )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_mstr_target_cfg_clk_cnt_disable_reg_nxt )
        , .reg_f                ( hqm_mstr_target_cfg_clk_cnt_disable_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_MSTR_TARGET_CFG_CLK_CNT_DISABLE ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_MSTR_TARGET_CFG_CLK_CNT_DISABLE ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_MSTR_TARGET_CFG_CLK_CNT_DISABLE ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_MSTR_TARGET_CFG_CLK_CNT_DISABLE ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_MSTR_TARGET_CFG_CLK_CNT_DISABLE * 32 +: 32 ] )
) ;
hqm_AW_inc_64b_wtcfg i_hqm_mstr_target_cfg_clk_on_cnt (
          .clk                  ( prim_gated_clk )
        , .rst_n                ( prim_freerun_prim_gated_rst_b_sync )
        , .cfg_write            ( { mux_cfg_req_write [ HQM_MSTR_TARGET_CFG_CLK_ON_CNT_H ] , mux_cfg_req_write [ HQM_MSTR_TARGET_CFG_CLK_ON_CNT_L ] } )
        , .cfg_read             ( { mux_cfg_req_read [ HQM_MSTR_TARGET_CFG_CLK_ON_CNT_H ] , mux_cfg_req_read [ HQM_MSTR_TARGET_CFG_CLK_ON_CNT_L ] } )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( { mux_cfg_rsp_ack_pnc [ HQM_MSTR_TARGET_CFG_CLK_ON_CNT_H ] , mux_cfg_rsp_ack_pnc [ HQM_MSTR_TARGET_CFG_CLK_ON_CNT_L ] } )
        , .cfg_err              ( { mux_cfg_rsp_err_pnc [ HQM_MSTR_TARGET_CFG_CLK_ON_CNT_H ] , mux_cfg_rsp_err_pnc [ HQM_MSTR_TARGET_CFG_CLK_ON_CNT_L ] } )
        , .cfg_rdata            ( { mux_cfg_rsp_rdata_pnc [ HQM_MSTR_TARGET_CFG_CLK_ON_CNT_H * 32 +: 32 ] , mux_cfg_rsp_rdata_pnc [ HQM_MSTR_TARGET_CFG_CLK_ON_CNT_L * 32 +: 32 ] } )
        , .en                   ( hqm_mstr_target_cfg_clk_on_cnt_en )
        , .clr                  ( hqm_mstr_target_cfg_clk_on_cnt_clr )
        , .clrv                 ( hqm_mstr_target_cfg_clk_on_cnt_clrv )
        , .inc                  ( hqm_mstr_target_cfg_clk_on_cnt_inc )
        , .count                ( hqm_mstr_target_cfg_clk_on_cnt_count )
) ;
hqm_AW_register_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( HQM_MSTR_CFG_CONTROL_GENERAL_DEFAULT )
) i_hqm_mstr_target_cfg_control_general (
          .clk                  ( prim_gated_clk )
        , .rst_n                ( prim_freerun_prim_gated_rst_b_sync )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_mstr_target_cfg_control_general_reg_nxt )
        , .reg_f                ( hqm_mstr_target_cfg_control_general_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_MSTR_TARGET_CFG_CONTROL_GENERAL ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_MSTR_TARGET_CFG_CONTROL_GENERAL ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_MSTR_TARGET_CFG_CONTROL_GENERAL ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_MSTR_TARGET_CFG_CONTROL_GENERAL ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_MSTR_TARGET_CFG_CONTROL_GENERAL * 32 +: 32 ] )
) ;
hqm_AW_inc_64b_wtcfg i_hqm_mstr_target_cfg_d3tod0_event_cnt (
          .clk                  ( prim_gated_clk )
        , .rst_n                ( prim_freerun_prim_gated_rst_b_sync )
        , .cfg_write            ( { mux_cfg_req_write [ HQM_MSTR_TARGET_CFG_D3TOD0_EVENT_CNT_H ] , mux_cfg_req_write [ HQM_MSTR_TARGET_CFG_D3TOD0_EVENT_CNT_L ] } )
        , .cfg_read             ( { mux_cfg_req_read [ HQM_MSTR_TARGET_CFG_D3TOD0_EVENT_CNT_H ] , mux_cfg_req_read [ HQM_MSTR_TARGET_CFG_D3TOD0_EVENT_CNT_L ] } )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( { mux_cfg_rsp_ack_pnc [ HQM_MSTR_TARGET_CFG_D3TOD0_EVENT_CNT_H ] , mux_cfg_rsp_ack_pnc [ HQM_MSTR_TARGET_CFG_D3TOD0_EVENT_CNT_L ] } )
        , .cfg_err              ( { mux_cfg_rsp_err_pnc [ HQM_MSTR_TARGET_CFG_D3TOD0_EVENT_CNT_H ] , mux_cfg_rsp_err_pnc [ HQM_MSTR_TARGET_CFG_D3TOD0_EVENT_CNT_L ] } )
        , .cfg_rdata            ( { mux_cfg_rsp_rdata_pnc [ HQM_MSTR_TARGET_CFG_D3TOD0_EVENT_CNT_H * 32 +: 32 ] , mux_cfg_rsp_rdata_pnc [ HQM_MSTR_TARGET_CFG_D3TOD0_EVENT_CNT_L * 32 +: 32 ] } )
        , .en                   ( hqm_mstr_target_cfg_d3tod0_event_cnt_en )
        , .clr                  ( hqm_mstr_target_cfg_d3tod0_event_cnt_clr )
        , .clrv                 ( hqm_mstr_target_cfg_d3tod0_event_cnt_clrv )
        , .inc                  ( hqm_mstr_target_cfg_d3tod0_event_cnt_inc )
        , .count                ( hqm_mstr_target_cfg_d3tod0_event_cnt_count )
) ;
hqm_AW_status_wtcfg i_hqm_mstr_target_cfg_diagnostic_heartbeat (
          .clk                  ( prim_gated_clk )
        , .rst_n                ( prim_freerun_prim_gated_rst_b_sync )
        , .status               ( hqm_mstr_target_cfg_diagnostic_heartbeat_status )
        , .cfg_write            ( mux_cfg_req_write [ HQM_MSTR_TARGET_CFG_DIAGNOSTIC_HEARTBEAT ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_MSTR_TARGET_CFG_DIAGNOSTIC_HEARTBEAT ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_MSTR_TARGET_CFG_DIAGNOSTIC_HEARTBEAT ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_MSTR_TARGET_CFG_DIAGNOSTIC_HEARTBEAT ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_MSTR_TARGET_CFG_DIAGNOSTIC_HEARTBEAT * 32 +: 32 ] )
) ;
hqm_AW_status_wtcfg i_hqm_mstr_target_cfg_diagnostic_idle_status (
          .clk                  ( prim_gated_clk )
        , .rst_n                ( prim_freerun_prim_gated_rst_b_sync )
        , .status               ( hqm_mstr_target_cfg_diagnostic_idle_status_status )
        , .cfg_write            ( mux_cfg_req_write [ HQM_MSTR_TARGET_CFG_DIAGNOSTIC_IDLE_STATUS ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_MSTR_TARGET_CFG_DIAGNOSTIC_IDLE_STATUS ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_MSTR_TARGET_CFG_DIAGNOSTIC_IDLE_STATUS ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_MSTR_TARGET_CFG_DIAGNOSTIC_IDLE_STATUS ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_MSTR_TARGET_CFG_DIAGNOSTIC_IDLE_STATUS * 32 +: 32 ] )
) ;
hqm_AW_status_wtcfg i_hqm_mstr_target_cfg_diagnostic_proc_lcb_status (
          .clk                  ( prim_gated_clk )
        , .rst_n                ( prim_freerun_prim_gated_rst_b_sync )
        , .status               ( hqm_mstr_target_cfg_diagnostic_proc_lcb_status_status )
        , .cfg_write            ( mux_cfg_req_write [ HQM_MSTR_TARGET_CFG_DIAGNOSTIC_PROC_LCB_STATUS ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_MSTR_TARGET_CFG_DIAGNOSTIC_PROC_LCB_STATUS ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_MSTR_TARGET_CFG_DIAGNOSTIC_PROC_LCB_STATUS ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_MSTR_TARGET_CFG_DIAGNOSTIC_PROC_LCB_STATUS ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_MSTR_TARGET_CFG_DIAGNOSTIC_PROC_LCB_STATUS * 32 +: 32 ] )
) ;
hqm_AW_status_wtcfg i_hqm_mstr_target_cfg_diagnostic_reset_status (
          .clk                  ( prim_gated_clk )
        , .rst_n                ( prim_freerun_prim_gated_rst_b_sync )
        , .status               ( hqm_mstr_target_cfg_diagnostic_reset_status_status )
        , .cfg_write            ( mux_cfg_req_write [ HQM_MSTR_TARGET_CFG_DIAGNOSTIC_RESET_STATUS ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_MSTR_TARGET_CFG_DIAGNOSTIC_RESET_STATUS ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_MSTR_TARGET_CFG_DIAGNOSTIC_RESET_STATUS ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_MSTR_TARGET_CFG_DIAGNOSTIC_RESET_STATUS ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_MSTR_TARGET_CFG_DIAGNOSTIC_RESET_STATUS * 32 +: 32 ] )
) ;
hqm_AW_register_sticky_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h00000000 )
        , .W1C                  ( 1 )
) i_hqm_mstr_target_cfg_diagnostic_status_1 (
          .clk                  ( prim_gated_clk )
        , .rst_n                ( prim_freerun_prim_gated_rst_b_sync )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_mstr_target_cfg_diagnostic_status_1_reg_nxt )
        , .reg_f                ( hqm_mstr_target_cfg_diagnostic_status_1_reg_f )
        , .load                 ( hqm_mstr_target_cfg_diagnostic_status_1_reg_load )
        , .cfg_write            ( mux_cfg_req_write [ HQM_MSTR_TARGET_CFG_DIAGNOSTIC_STATUS_1 ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_MSTR_TARGET_CFG_DIAGNOSTIC_STATUS_1 ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_MSTR_TARGET_CFG_DIAGNOSTIC_STATUS_1 ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_MSTR_TARGET_CFG_DIAGNOSTIC_STATUS_1 ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_MSTR_TARGET_CFG_DIAGNOSTIC_STATUS_1 * 32 +: 32 ] )
) ;
hqm_AW_syndrome_wtcfg i_hqm_mstr_target_cfg_diagnostic_syndrome (
          .clk                  ( prim_gated_clk )
        , .rst_n                ( prim_freerun_prim_gated_rst_b_sync )
        , .rst_prep             ( rst_prep )
        , .cfg_write            ( mux_cfg_req_write [ HQM_MSTR_TARGET_CFG_DIAGNOSTIC_SYNDROME ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_MSTR_TARGET_CFG_DIAGNOSTIC_SYNDROME ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_MSTR_TARGET_CFG_DIAGNOSTIC_SYNDROME ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_MSTR_TARGET_CFG_DIAGNOSTIC_SYNDROME ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_MSTR_TARGET_CFG_DIAGNOSTIC_SYNDROME * 32 +: 32 ] )
        , .capture_v            ( hqm_mstr_target_cfg_diagnostic_syndrome_capture_v )
        , .capture_data         ( hqm_mstr_target_cfg_diagnostic_syndrome_capture_data )
        , .syndrome_data        ( hqm_mstr_target_cfg_diagnostic_syndrome_syndrome_data )
) ;
hqm_AW_register_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h00000000 )
) i_hqm_mstr_target_cfg_flr_count_h (
          .clk                  ( prim_gated_clk )
        , .rst_n                ( prim_freerun_prim_gated_rst_b_sync )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_mstr_target_cfg_flr_count_h_reg_nxt )
        , .reg_f                ( hqm_mstr_target_cfg_flr_count_h_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_MSTR_TARGET_CFG_FLR_COUNT_H ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_MSTR_TARGET_CFG_FLR_COUNT_H ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_MSTR_TARGET_CFG_FLR_COUNT_H ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_MSTR_TARGET_CFG_FLR_COUNT_H ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_MSTR_TARGET_CFG_FLR_COUNT_H * 32 +: 32 ] )
) ;
hqm_AW_register_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h00000000 )
) i_hqm_mstr_target_cfg_flr_count_l (
          .clk                  ( prim_gated_clk )
        , .rst_n                ( prim_freerun_prim_gated_rst_b_sync )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_mstr_target_cfg_flr_count_l_reg_nxt )
        , .reg_f                ( hqm_mstr_target_cfg_flr_count_l_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_MSTR_TARGET_CFG_FLR_COUNT_L ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_MSTR_TARGET_CFG_FLR_COUNT_L ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_MSTR_TARGET_CFG_FLR_COUNT_L ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_MSTR_TARGET_CFG_FLR_COUNT_L ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_MSTR_TARGET_CFG_FLR_COUNT_L * 32 +: 32 ] )
) ;
hqm_AW_register_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( HQM_MSTR_CFG_HQM_CDC_CONTROL_DEFAULT )
) i_hqm_mstr_target_cfg_hqm_cdc_control (
          .clk                  ( prim_gated_clk )
        , .rst_n                ( prim_freerun_prim_gated_rst_b_sync )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_mstr_target_cfg_hqm_cdc_control_reg_nxt )
        , .reg_f                ( hqm_mstr_target_cfg_hqm_cdc_control_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_MSTR_TARGET_CFG_HQM_CDC_CONTROL ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_MSTR_TARGET_CFG_HQM_CDC_CONTROL ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_MSTR_TARGET_CFG_HQM_CDC_CONTROL ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_MSTR_TARGET_CFG_HQM_CDC_CONTROL ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_MSTR_TARGET_CFG_HQM_CDC_CONTROL * 32 +: 32 ] )
) ;
hqm_AW_register_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( HQM_MSTR_CFG_HQM_PGCB_CONTROL_DEFAULT )
) i_hqm_mstr_target_cfg_hqm_pgcb_control (
          .clk                  ( prim_gated_clk )
        , .rst_n                ( prim_freerun_prim_gated_rst_b_sync )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_mstr_target_cfg_hqm_pgcb_control_reg_nxt )
        , .reg_f                ( hqm_mstr_target_cfg_hqm_pgcb_control_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_MSTR_TARGET_CFG_HQM_PGCB_CONTROL ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_MSTR_TARGET_CFG_HQM_PGCB_CONTROL ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_MSTR_TARGET_CFG_HQM_PGCB_CONTROL ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_MSTR_TARGET_CFG_HQM_PGCB_CONTROL ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_MSTR_TARGET_CFG_HQM_PGCB_CONTROL * 32 +: 32 ] )
) ;
hqm_AW_register_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( HQM_UNIT_TIMEOUT_DEFAULT )
) i_hqm_mstr_target_cfg_mstr_internal_timeout (
          .clk                  ( prim_gated_clk )
        , .rst_n                ( prim_freerun_prim_gated_rst_b_sync )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_mstr_target_cfg_mstr_internal_timeout_reg_nxt )
        , .reg_f                ( hqm_mstr_target_cfg_mstr_internal_timeout_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_MSTR_TARGET_CFG_MSTR_INTERNAL_TIMEOUT ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_MSTR_TARGET_CFG_MSTR_INTERNAL_TIMEOUT ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_MSTR_TARGET_CFG_MSTR_INTERNAL_TIMEOUT ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_MSTR_TARGET_CFG_MSTR_INTERNAL_TIMEOUT ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_MSTR_TARGET_CFG_MSTR_INTERNAL_TIMEOUT * 32 +: 32 ] )
) ;
hqm_AW_register_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( HQM_MSTR_CFG_PM_OVERRIDE_DEFAULT )
) i_hqm_mstr_target_cfg_pm_override (
          .clk                  ( prim_gated_clk )
        , .rst_n                ( prim_freerun_prim_gated_rst_b_sync )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_mstr_target_cfg_pm_override_reg_nxt )
        , .reg_f                ( hqm_mstr_target_cfg_pm_override_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_MSTR_TARGET_CFG_PM_OVERRIDE ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_MSTR_TARGET_CFG_PM_OVERRIDE ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_MSTR_TARGET_CFG_PM_OVERRIDE ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_MSTR_TARGET_CFG_PM_OVERRIDE ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_MSTR_TARGET_CFG_PM_OVERRIDE * 32 +: 32 ] )
) ;
hqm_AW_register_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( HQM_MSTR_CFG_PM_PMCSR_DISABLE_DEFAULT )
) i_hqm_mstr_target_cfg_pm_pmcsr_disable (
          .clk                  ( prim_gated_clk )
        , .rst_n                ( prim_freerun_prim_gated_rst_b_sync )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_mstr_target_cfg_pm_pmcsr_disable_reg_nxt )
        , .reg_f                ( hqm_mstr_target_cfg_pm_pmcsr_disable_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_MSTR_TARGET_CFG_PM_PMCSR_DISABLE ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_MSTR_TARGET_CFG_PM_PMCSR_DISABLE ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_MSTR_TARGET_CFG_PM_PMCSR_DISABLE ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_MSTR_TARGET_CFG_PM_PMCSR_DISABLE ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_MSTR_TARGET_CFG_PM_PMCSR_DISABLE * 32 +: 32 ] )
) ;
hqm_AW_status_wtcfg i_hqm_mstr_target_cfg_pm_status (
          .clk                  ( prim_gated_clk )
        , .rst_n                ( prim_freerun_prim_gated_rst_b_sync )
        , .status               ( hqm_mstr_target_cfg_pm_status_status )
        , .cfg_write            ( mux_cfg_req_write [ HQM_MSTR_TARGET_CFG_PM_STATUS ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_MSTR_TARGET_CFG_PM_STATUS ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_MSTR_TARGET_CFG_PM_STATUS ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_MSTR_TARGET_CFG_PM_STATUS ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_MSTR_TARGET_CFG_PM_STATUS * 32 +: 32 ] )
) ;
hqm_AW_inc_64b_wtcfg i_hqm_mstr_target_cfg_prochot_cnt (
          .clk                  ( prim_gated_clk )
        , .rst_n                ( prim_freerun_prim_gated_rst_b_sync )
        , .cfg_write            ( { mux_cfg_req_write [ HQM_MSTR_TARGET_CFG_PROCHOT_CNT_H ] , mux_cfg_req_write [ HQM_MSTR_TARGET_CFG_PROCHOT_CNT_L ] } )
        , .cfg_read             ( { mux_cfg_req_read [ HQM_MSTR_TARGET_CFG_PROCHOT_CNT_H ] , mux_cfg_req_read [ HQM_MSTR_TARGET_CFG_PROCHOT_CNT_L ] } )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( { mux_cfg_rsp_ack_pnc [ HQM_MSTR_TARGET_CFG_PROCHOT_CNT_H ] , mux_cfg_rsp_ack_pnc [ HQM_MSTR_TARGET_CFG_PROCHOT_CNT_L ] } )
        , .cfg_err              ( { mux_cfg_rsp_err_pnc [ HQM_MSTR_TARGET_CFG_PROCHOT_CNT_H ] , mux_cfg_rsp_err_pnc [ HQM_MSTR_TARGET_CFG_PROCHOT_CNT_L ] } )
        , .cfg_rdata            ( { mux_cfg_rsp_rdata_pnc [ HQM_MSTR_TARGET_CFG_PROCHOT_CNT_H * 32 +: 32 ] , mux_cfg_rsp_rdata_pnc [ HQM_MSTR_TARGET_CFG_PROCHOT_CNT_L * 32 +: 32 ] } )
        , .en                   ( hqm_mstr_target_cfg_prochot_cnt_en )
        , .clr                  ( hqm_mstr_target_cfg_prochot_cnt_clr )
        , .clrv                 ( hqm_mstr_target_cfg_prochot_cnt_clrv )
        , .inc                  ( hqm_mstr_target_cfg_prochot_cnt_inc )
        , .count                ( hqm_mstr_target_cfg_prochot_cnt_count )
) ;
hqm_AW_inc_64b_wtcfg i_hqm_mstr_target_cfg_prochot_event_cnt (
          .clk                  ( prim_gated_clk )
        , .rst_n                ( prim_freerun_prim_gated_rst_b_sync )
        , .cfg_write            ( { mux_cfg_req_write [ HQM_MSTR_TARGET_CFG_PROCHOT_EVENT_CNT_H ] , mux_cfg_req_write [ HQM_MSTR_TARGET_CFG_PROCHOT_EVENT_CNT_L ] } )
        , .cfg_read             ( { mux_cfg_req_read [ HQM_MSTR_TARGET_CFG_PROCHOT_EVENT_CNT_H ] , mux_cfg_req_read [ HQM_MSTR_TARGET_CFG_PROCHOT_EVENT_CNT_L ] } )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( { mux_cfg_rsp_ack_pnc [ HQM_MSTR_TARGET_CFG_PROCHOT_EVENT_CNT_H ] , mux_cfg_rsp_ack_pnc [ HQM_MSTR_TARGET_CFG_PROCHOT_EVENT_CNT_L ] } )
        , .cfg_err              ( { mux_cfg_rsp_err_pnc [ HQM_MSTR_TARGET_CFG_PROCHOT_EVENT_CNT_H ] , mux_cfg_rsp_err_pnc [ HQM_MSTR_TARGET_CFG_PROCHOT_EVENT_CNT_L ] } )
        , .cfg_rdata            ( { mux_cfg_rsp_rdata_pnc [ HQM_MSTR_TARGET_CFG_PROCHOT_EVENT_CNT_H * 32 +: 32 ] , mux_cfg_rsp_rdata_pnc [ HQM_MSTR_TARGET_CFG_PROCHOT_EVENT_CNT_L * 32 +: 32 ] } )
        , .en                   ( hqm_mstr_target_cfg_prochot_event_cnt_en )
        , .clr                  ( hqm_mstr_target_cfg_prochot_event_cnt_clr )
        , .clrv                 ( hqm_mstr_target_cfg_prochot_event_cnt_clrv )
        , .inc                  ( hqm_mstr_target_cfg_prochot_event_cnt_inc )
        , .count                ( hqm_mstr_target_cfg_prochot_event_cnt_count )
) ;
hqm_AW_inc_64b_wtcfg i_hqm_mstr_target_cfg_proc_on_cnt (
          .clk                  ( prim_gated_clk )
        , .rst_n                ( prim_freerun_prim_gated_rst_b_sync )
        , .cfg_write            ( { mux_cfg_req_write [ HQM_MSTR_TARGET_CFG_PROC_ON_CNT_H ] , mux_cfg_req_write [ HQM_MSTR_TARGET_CFG_PROC_ON_CNT_L ] } )
        , .cfg_read             ( { mux_cfg_req_read [ HQM_MSTR_TARGET_CFG_PROC_ON_CNT_H ] , mux_cfg_req_read [ HQM_MSTR_TARGET_CFG_PROC_ON_CNT_L ] } )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( { mux_cfg_rsp_ack_pnc [ HQM_MSTR_TARGET_CFG_PROC_ON_CNT_H ] , mux_cfg_rsp_ack_pnc [ HQM_MSTR_TARGET_CFG_PROC_ON_CNT_L ] } )
        , .cfg_err              ( { mux_cfg_rsp_err_pnc [ HQM_MSTR_TARGET_CFG_PROC_ON_CNT_H ] , mux_cfg_rsp_err_pnc [ HQM_MSTR_TARGET_CFG_PROC_ON_CNT_L ] } )
        , .cfg_rdata            ( { mux_cfg_rsp_rdata_pnc [ HQM_MSTR_TARGET_CFG_PROC_ON_CNT_H * 32 +: 32 ] , mux_cfg_rsp_rdata_pnc [ HQM_MSTR_TARGET_CFG_PROC_ON_CNT_L * 32 +: 32 ] } )
        , .en                   ( hqm_mstr_target_cfg_proc_on_cnt_en )
        , .clr                  ( hqm_mstr_target_cfg_proc_on_cnt_clr )
        , .clrv                 ( hqm_mstr_target_cfg_proc_on_cnt_clrv )
        , .inc                  ( hqm_mstr_target_cfg_proc_on_cnt_inc )
        , .count                ( hqm_mstr_target_cfg_proc_on_cnt_count )
) ;
hqm_AW_register_wtcfg #(
          .WIDTH                ( 32 )
        , .DEFAULT              ( 32'h00000000 )
) i_hqm_mstr_target_cfg_ts_control (
          .clk                  ( prim_gated_clk )
        , .rst_n                ( prim_freerun_prim_gated_rst_b_sync )
        , .rst_prep             ( rst_prep )
        , .reg_nxt              ( hqm_mstr_target_cfg_ts_control_reg_nxt )
        , .reg_f                ( hqm_mstr_target_cfg_ts_control_reg_f )
        , .cfg_write            ( mux_cfg_req_write [ HQM_MSTR_TARGET_CFG_TS_CONTROL ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_MSTR_TARGET_CFG_TS_CONTROL ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_MSTR_TARGET_CFG_TS_CONTROL ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_MSTR_TARGET_CFG_TS_CONTROL ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_MSTR_TARGET_CFG_TS_CONTROL * 32 +: 32 ] )
) ;
hqm_AW_status_wtcfg i_hqm_mstr_target_cfg_unit_version (
          .clk                  ( prim_gated_clk )
        , .rst_n                ( prim_freerun_prim_gated_rst_b_sync )
        , .status               ( hqm_mstr_target_cfg_unit_version_status )
        , .cfg_write            ( mux_cfg_req_write [ HQM_MSTR_TARGET_CFG_UNIT_VERSION ] )
        , .cfg_read             ( mux_cfg_req_read [ HQM_MSTR_TARGET_CFG_UNIT_VERSION ] )
        , .cfg_req              ( mux_cfg_req )
        , .cfg_ack              ( mux_cfg_rsp_ack_pnc [ HQM_MSTR_TARGET_CFG_UNIT_VERSION ] )
        , .cfg_err              ( mux_cfg_rsp_err_pnc [ HQM_MSTR_TARGET_CFG_UNIT_VERSION ] )
        , .cfg_rdata            ( mux_cfg_rsp_rdata_pnc [ HQM_MSTR_TARGET_CFG_UNIT_VERSION * 32 +: 32 ] )
) ;
endmodule
