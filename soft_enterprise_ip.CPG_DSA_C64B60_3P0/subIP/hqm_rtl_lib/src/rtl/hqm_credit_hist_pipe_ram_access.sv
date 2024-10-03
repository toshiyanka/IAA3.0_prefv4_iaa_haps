module hqm_credit_hist_pipe_ram_access
     import hqm_AW_pkg::* , hqm_pkg::* , hqm_core_pkg::*;
(
     input  logic                  hqm_gated_clk
    ,input  logic                  hqm_inp_gated_clk
    ,input  logic                  hqm_pgcb_clk

    ,input  logic                  hqm_gated_rst_n
    ,input  logic                  hqm_inp_gated_rst_n
    ,input  logic                  hqm_pgcb_rst_n

    ,input  logic [( 30 *  1)-1:0] cfg_mem_re          // lintra s-0527
    ,input  logic [( 30 *  1)-1:0] cfg_mem_we          // lintra s-0527
    ,input  logic [(      20)-1:0] cfg_mem_addr        // lintra s-0527
    ,input  logic [(      12)-1:0] cfg_mem_minbit      // lintra s-0527
    ,input  logic [(      12)-1:0] cfg_mem_maxbit      // lintra s-0527
    ,input  logic [(      32)-1:0] cfg_mem_wdata       // lintra s-0527
    ,output logic [( 30 * 32)-1:0] cfg_mem_rdata
    ,output logic [( 30 *  1)-1:0] cfg_mem_ack
    ,input  logic                  cfg_mem_cc_v        // lintra s-0527
    ,input  logic [(       8)-1:0] cfg_mem_cc_value    // lintra s-0527
    ,input  logic [(       4)-1:0] cfg_mem_cc_width    // lintra s-0527
    ,input  logic [(      12)-1:0] cfg_mem_cc_position // lintra s-0527

    ,output logic                  hqm_credit_hist_pipe_rfw_top_ipar_error

    ,input  logic                  func_aqed_chp_sch_rx_sync_mem_re
    ,input  logic [(       2)-1:0] func_aqed_chp_sch_rx_sync_mem_raddr
    ,input  logic [(       2)-1:0] func_aqed_chp_sch_rx_sync_mem_waddr
    ,input  logic                  func_aqed_chp_sch_rx_sync_mem_we
    ,input  logic [(     179)-1:0] func_aqed_chp_sch_rx_sync_mem_wdata
    ,output logic [(     179)-1:0] func_aqed_chp_sch_rx_sync_mem_rdata

    ,input  logic                  pf_aqed_chp_sch_rx_sync_mem_re
    ,input  logic [(       2)-1:0] pf_aqed_chp_sch_rx_sync_mem_raddr
    ,input  logic [(       2)-1:0] pf_aqed_chp_sch_rx_sync_mem_waddr
    ,input  logic                  pf_aqed_chp_sch_rx_sync_mem_we
    ,input  logic [(     179)-1:0] pf_aqed_chp_sch_rx_sync_mem_wdata
    ,output logic [(     179)-1:0] pf_aqed_chp_sch_rx_sync_mem_rdata

    ,output logic                  rf_aqed_chp_sch_rx_sync_mem_re
    ,output logic                  rf_aqed_chp_sch_rx_sync_mem_rclk
    ,output logic                  rf_aqed_chp_sch_rx_sync_mem_rclk_rst_n
    ,output logic [(       2)-1:0] rf_aqed_chp_sch_rx_sync_mem_raddr
    ,output logic [(       2)-1:0] rf_aqed_chp_sch_rx_sync_mem_waddr
    ,output logic                  rf_aqed_chp_sch_rx_sync_mem_we
    ,output logic                  rf_aqed_chp_sch_rx_sync_mem_wclk
    ,output logic                  rf_aqed_chp_sch_rx_sync_mem_wclk_rst_n
    ,output logic [(     179)-1:0] rf_aqed_chp_sch_rx_sync_mem_wdata
    ,input  logic [(     179)-1:0] rf_aqed_chp_sch_rx_sync_mem_rdata

    ,output logic                  rf_aqed_chp_sch_rx_sync_mem_error

    ,input  logic                  func_chp_chp_rop_hcw_fifo_mem_re
    ,input  logic [(       4)-1:0] func_chp_chp_rop_hcw_fifo_mem_raddr
    ,input  logic [(       4)-1:0] func_chp_chp_rop_hcw_fifo_mem_waddr
    ,input  logic                  func_chp_chp_rop_hcw_fifo_mem_we
    ,input  logic [(     201)-1:0] func_chp_chp_rop_hcw_fifo_mem_wdata
    ,output logic [(     201)-1:0] func_chp_chp_rop_hcw_fifo_mem_rdata

    ,input  logic                  pf_chp_chp_rop_hcw_fifo_mem_re
    ,input  logic [(       4)-1:0] pf_chp_chp_rop_hcw_fifo_mem_raddr
    ,input  logic [(       4)-1:0] pf_chp_chp_rop_hcw_fifo_mem_waddr
    ,input  logic                  pf_chp_chp_rop_hcw_fifo_mem_we
    ,input  logic [(     201)-1:0] pf_chp_chp_rop_hcw_fifo_mem_wdata
    ,output logic [(     201)-1:0] pf_chp_chp_rop_hcw_fifo_mem_rdata

    ,output logic                  rf_chp_chp_rop_hcw_fifo_mem_re
    ,output logic                  rf_chp_chp_rop_hcw_fifo_mem_rclk
    ,output logic                  rf_chp_chp_rop_hcw_fifo_mem_rclk_rst_n
    ,output logic [(       4)-1:0] rf_chp_chp_rop_hcw_fifo_mem_raddr
    ,output logic [(       4)-1:0] rf_chp_chp_rop_hcw_fifo_mem_waddr
    ,output logic                  rf_chp_chp_rop_hcw_fifo_mem_we
    ,output logic                  rf_chp_chp_rop_hcw_fifo_mem_wclk
    ,output logic                  rf_chp_chp_rop_hcw_fifo_mem_wclk_rst_n
    ,output logic [(     201)-1:0] rf_chp_chp_rop_hcw_fifo_mem_wdata
    ,input  logic [(     201)-1:0] rf_chp_chp_rop_hcw_fifo_mem_rdata

    ,output logic                  rf_chp_chp_rop_hcw_fifo_mem_error

    ,input  logic                  func_chp_lsp_ap_cmp_fifo_mem_re
    ,input  logic [(       4)-1:0] func_chp_lsp_ap_cmp_fifo_mem_raddr
    ,input  logic [(       4)-1:0] func_chp_lsp_ap_cmp_fifo_mem_waddr
    ,input  logic                  func_chp_lsp_ap_cmp_fifo_mem_we
    ,input  logic [(      74)-1:0] func_chp_lsp_ap_cmp_fifo_mem_wdata
    ,output logic [(      74)-1:0] func_chp_lsp_ap_cmp_fifo_mem_rdata

    ,input  logic                  pf_chp_lsp_ap_cmp_fifo_mem_re
    ,input  logic [(       4)-1:0] pf_chp_lsp_ap_cmp_fifo_mem_raddr
    ,input  logic [(       4)-1:0] pf_chp_lsp_ap_cmp_fifo_mem_waddr
    ,input  logic                  pf_chp_lsp_ap_cmp_fifo_mem_we
    ,input  logic [(      74)-1:0] pf_chp_lsp_ap_cmp_fifo_mem_wdata
    ,output logic [(      74)-1:0] pf_chp_lsp_ap_cmp_fifo_mem_rdata

    ,output logic                  rf_chp_lsp_ap_cmp_fifo_mem_re
    ,output logic                  rf_chp_lsp_ap_cmp_fifo_mem_rclk
    ,output logic                  rf_chp_lsp_ap_cmp_fifo_mem_rclk_rst_n
    ,output logic [(       4)-1:0] rf_chp_lsp_ap_cmp_fifo_mem_raddr
    ,output logic [(       4)-1:0] rf_chp_lsp_ap_cmp_fifo_mem_waddr
    ,output logic                  rf_chp_lsp_ap_cmp_fifo_mem_we
    ,output logic                  rf_chp_lsp_ap_cmp_fifo_mem_wclk
    ,output logic                  rf_chp_lsp_ap_cmp_fifo_mem_wclk_rst_n
    ,output logic [(      74)-1:0] rf_chp_lsp_ap_cmp_fifo_mem_wdata
    ,input  logic [(      74)-1:0] rf_chp_lsp_ap_cmp_fifo_mem_rdata

    ,output logic                  rf_chp_lsp_ap_cmp_fifo_mem_error

    ,input  logic                  func_chp_lsp_tok_fifo_mem_re
    ,input  logic [(       4)-1:0] func_chp_lsp_tok_fifo_mem_raddr
    ,input  logic [(       4)-1:0] func_chp_lsp_tok_fifo_mem_waddr
    ,input  logic                  func_chp_lsp_tok_fifo_mem_we
    ,input  logic [(      29)-1:0] func_chp_lsp_tok_fifo_mem_wdata
    ,output logic [(      29)-1:0] func_chp_lsp_tok_fifo_mem_rdata

    ,input  logic                  pf_chp_lsp_tok_fifo_mem_re
    ,input  logic [(       4)-1:0] pf_chp_lsp_tok_fifo_mem_raddr
    ,input  logic [(       4)-1:0] pf_chp_lsp_tok_fifo_mem_waddr
    ,input  logic                  pf_chp_lsp_tok_fifo_mem_we
    ,input  logic [(      29)-1:0] pf_chp_lsp_tok_fifo_mem_wdata
    ,output logic [(      29)-1:0] pf_chp_lsp_tok_fifo_mem_rdata

    ,output logic                  rf_chp_lsp_tok_fifo_mem_re
    ,output logic                  rf_chp_lsp_tok_fifo_mem_rclk
    ,output logic                  rf_chp_lsp_tok_fifo_mem_rclk_rst_n
    ,output logic [(       4)-1:0] rf_chp_lsp_tok_fifo_mem_raddr
    ,output logic [(       4)-1:0] rf_chp_lsp_tok_fifo_mem_waddr
    ,output logic                  rf_chp_lsp_tok_fifo_mem_we
    ,output logic                  rf_chp_lsp_tok_fifo_mem_wclk
    ,output logic                  rf_chp_lsp_tok_fifo_mem_wclk_rst_n
    ,output logic [(      29)-1:0] rf_chp_lsp_tok_fifo_mem_wdata
    ,input  logic [(      29)-1:0] rf_chp_lsp_tok_fifo_mem_rdata

    ,output logic                  rf_chp_lsp_tok_fifo_mem_error

    ,input  logic                  func_chp_sys_tx_fifo_mem_re
    ,input  logic [(       3)-1:0] func_chp_sys_tx_fifo_mem_raddr
    ,input  logic [(       3)-1:0] func_chp_sys_tx_fifo_mem_waddr
    ,input  logic                  func_chp_sys_tx_fifo_mem_we
    ,input  logic [(     200)-1:0] func_chp_sys_tx_fifo_mem_wdata
    ,output logic [(     200)-1:0] func_chp_sys_tx_fifo_mem_rdata

    ,input  logic                  pf_chp_sys_tx_fifo_mem_re
    ,input  logic [(       3)-1:0] pf_chp_sys_tx_fifo_mem_raddr
    ,input  logic [(       3)-1:0] pf_chp_sys_tx_fifo_mem_waddr
    ,input  logic                  pf_chp_sys_tx_fifo_mem_we
    ,input  logic [(     200)-1:0] pf_chp_sys_tx_fifo_mem_wdata
    ,output logic [(     200)-1:0] pf_chp_sys_tx_fifo_mem_rdata

    ,output logic                  rf_chp_sys_tx_fifo_mem_re
    ,output logic                  rf_chp_sys_tx_fifo_mem_rclk
    ,output logic                  rf_chp_sys_tx_fifo_mem_rclk_rst_n
    ,output logic [(       3)-1:0] rf_chp_sys_tx_fifo_mem_raddr
    ,output logic [(       3)-1:0] rf_chp_sys_tx_fifo_mem_waddr
    ,output logic                  rf_chp_sys_tx_fifo_mem_we
    ,output logic                  rf_chp_sys_tx_fifo_mem_wclk
    ,output logic                  rf_chp_sys_tx_fifo_mem_wclk_rst_n
    ,output logic [(     200)-1:0] rf_chp_sys_tx_fifo_mem_wdata
    ,input  logic [(     200)-1:0] rf_chp_sys_tx_fifo_mem_rdata

    ,output logic                  rf_chp_sys_tx_fifo_mem_error

    ,input  logic                  func_cmp_id_chk_enbl_mem_re
    ,input  logic [(       6)-1:0] func_cmp_id_chk_enbl_mem_raddr
    ,input  logic [(       6)-1:0] func_cmp_id_chk_enbl_mem_waddr
    ,input  logic                  func_cmp_id_chk_enbl_mem_we
    ,input  logic [(       2)-1:0] func_cmp_id_chk_enbl_mem_wdata
    ,output logic [(       2)-1:0] func_cmp_id_chk_enbl_mem_rdata

    ,input  logic                  pf_cmp_id_chk_enbl_mem_re
    ,input  logic [(       6)-1:0] pf_cmp_id_chk_enbl_mem_raddr
    ,input  logic [(       6)-1:0] pf_cmp_id_chk_enbl_mem_waddr
    ,input  logic                  pf_cmp_id_chk_enbl_mem_we
    ,input  logic [(       2)-1:0] pf_cmp_id_chk_enbl_mem_wdata
    ,output logic [(       2)-1:0] pf_cmp_id_chk_enbl_mem_rdata

    ,output logic                  rf_cmp_id_chk_enbl_mem_re
    ,output logic                  rf_cmp_id_chk_enbl_mem_rclk
    ,output logic                  rf_cmp_id_chk_enbl_mem_rclk_rst_n
    ,output logic [(       6)-1:0] rf_cmp_id_chk_enbl_mem_raddr
    ,output logic [(       6)-1:0] rf_cmp_id_chk_enbl_mem_waddr
    ,output logic                  rf_cmp_id_chk_enbl_mem_we
    ,output logic                  rf_cmp_id_chk_enbl_mem_wclk
    ,output logic                  rf_cmp_id_chk_enbl_mem_wclk_rst_n
    ,output logic [(       2)-1:0] rf_cmp_id_chk_enbl_mem_wdata
    ,input  logic [(       2)-1:0] rf_cmp_id_chk_enbl_mem_rdata

    ,output logic                  rf_cmp_id_chk_enbl_mem_error

    ,input  logic                  func_count_rmw_pipe_dir_mem_re
    ,input  logic [(       6)-1:0] func_count_rmw_pipe_dir_mem_raddr
    ,input  logic [(       6)-1:0] func_count_rmw_pipe_dir_mem_waddr
    ,input  logic                  func_count_rmw_pipe_dir_mem_we
    ,input  logic [(      16)-1:0] func_count_rmw_pipe_dir_mem_wdata
    ,output logic [(      16)-1:0] func_count_rmw_pipe_dir_mem_rdata

    ,input  logic                  pf_count_rmw_pipe_dir_mem_re
    ,input  logic [(       6)-1:0] pf_count_rmw_pipe_dir_mem_raddr
    ,input  logic [(       6)-1:0] pf_count_rmw_pipe_dir_mem_waddr
    ,input  logic                  pf_count_rmw_pipe_dir_mem_we
    ,input  logic [(      16)-1:0] pf_count_rmw_pipe_dir_mem_wdata
    ,output logic [(      16)-1:0] pf_count_rmw_pipe_dir_mem_rdata

    ,output logic                  rf_count_rmw_pipe_dir_mem_re
    ,output logic                  rf_count_rmw_pipe_dir_mem_rclk
    ,output logic                  rf_count_rmw_pipe_dir_mem_rclk_rst_n
    ,output logic [(       6)-1:0] rf_count_rmw_pipe_dir_mem_raddr
    ,output logic [(       6)-1:0] rf_count_rmw_pipe_dir_mem_waddr
    ,output logic                  rf_count_rmw_pipe_dir_mem_we
    ,output logic                  rf_count_rmw_pipe_dir_mem_wclk
    ,output logic                  rf_count_rmw_pipe_dir_mem_wclk_rst_n
    ,output logic [(      16)-1:0] rf_count_rmw_pipe_dir_mem_wdata
    ,input  logic [(      16)-1:0] rf_count_rmw_pipe_dir_mem_rdata

    ,output logic                  rf_count_rmw_pipe_dir_mem_error

    ,input  logic                  func_count_rmw_pipe_ldb_mem_re
    ,input  logic [(       6)-1:0] func_count_rmw_pipe_ldb_mem_raddr
    ,input  logic [(       6)-1:0] func_count_rmw_pipe_ldb_mem_waddr
    ,input  logic                  func_count_rmw_pipe_ldb_mem_we
    ,input  logic [(      16)-1:0] func_count_rmw_pipe_ldb_mem_wdata
    ,output logic [(      16)-1:0] func_count_rmw_pipe_ldb_mem_rdata

    ,input  logic                  pf_count_rmw_pipe_ldb_mem_re
    ,input  logic [(       6)-1:0] pf_count_rmw_pipe_ldb_mem_raddr
    ,input  logic [(       6)-1:0] pf_count_rmw_pipe_ldb_mem_waddr
    ,input  logic                  pf_count_rmw_pipe_ldb_mem_we
    ,input  logic [(      16)-1:0] pf_count_rmw_pipe_ldb_mem_wdata
    ,output logic [(      16)-1:0] pf_count_rmw_pipe_ldb_mem_rdata

    ,output logic                  rf_count_rmw_pipe_ldb_mem_re
    ,output logic                  rf_count_rmw_pipe_ldb_mem_rclk
    ,output logic                  rf_count_rmw_pipe_ldb_mem_rclk_rst_n
    ,output logic [(       6)-1:0] rf_count_rmw_pipe_ldb_mem_raddr
    ,output logic [(       6)-1:0] rf_count_rmw_pipe_ldb_mem_waddr
    ,output logic                  rf_count_rmw_pipe_ldb_mem_we
    ,output logic                  rf_count_rmw_pipe_ldb_mem_wclk
    ,output logic                  rf_count_rmw_pipe_ldb_mem_wclk_rst_n
    ,output logic [(      16)-1:0] rf_count_rmw_pipe_ldb_mem_wdata
    ,input  logic [(      16)-1:0] rf_count_rmw_pipe_ldb_mem_rdata

    ,output logic                  rf_count_rmw_pipe_ldb_mem_error

    ,input  logic                  func_count_rmw_pipe_wd_dir_mem_re
    ,input  logic [(       6)-1:0] func_count_rmw_pipe_wd_dir_mem_raddr
    ,input  logic [(       6)-1:0] func_count_rmw_pipe_wd_dir_mem_waddr
    ,input  logic                  func_count_rmw_pipe_wd_dir_mem_we
    ,input  logic [(      10)-1:0] func_count_rmw_pipe_wd_dir_mem_wdata
    ,output logic [(      10)-1:0] func_count_rmw_pipe_wd_dir_mem_rdata

    ,input  logic                  pf_count_rmw_pipe_wd_dir_mem_re
    ,input  logic [(       6)-1:0] pf_count_rmw_pipe_wd_dir_mem_raddr
    ,input  logic [(       6)-1:0] pf_count_rmw_pipe_wd_dir_mem_waddr
    ,input  logic                  pf_count_rmw_pipe_wd_dir_mem_we
    ,input  logic [(      10)-1:0] pf_count_rmw_pipe_wd_dir_mem_wdata
    ,output logic [(      10)-1:0] pf_count_rmw_pipe_wd_dir_mem_rdata

    ,output logic                  rf_count_rmw_pipe_wd_dir_mem_re
    ,output logic                  rf_count_rmw_pipe_wd_dir_mem_rclk
    ,output logic                  rf_count_rmw_pipe_wd_dir_mem_rclk_rst_n
    ,output logic [(       6)-1:0] rf_count_rmw_pipe_wd_dir_mem_raddr
    ,output logic [(       6)-1:0] rf_count_rmw_pipe_wd_dir_mem_waddr
    ,output logic                  rf_count_rmw_pipe_wd_dir_mem_we
    ,output logic                  rf_count_rmw_pipe_wd_dir_mem_wclk
    ,output logic                  rf_count_rmw_pipe_wd_dir_mem_wclk_rst_n
    ,output logic [(      10)-1:0] rf_count_rmw_pipe_wd_dir_mem_wdata
    ,input  logic [(      10)-1:0] rf_count_rmw_pipe_wd_dir_mem_rdata

    ,output logic                  rf_count_rmw_pipe_wd_dir_mem_error

    ,input  logic                  func_count_rmw_pipe_wd_ldb_mem_re
    ,input  logic [(       6)-1:0] func_count_rmw_pipe_wd_ldb_mem_raddr
    ,input  logic [(       6)-1:0] func_count_rmw_pipe_wd_ldb_mem_waddr
    ,input  logic                  func_count_rmw_pipe_wd_ldb_mem_we
    ,input  logic [(      10)-1:0] func_count_rmw_pipe_wd_ldb_mem_wdata
    ,output logic [(      10)-1:0] func_count_rmw_pipe_wd_ldb_mem_rdata

    ,input  logic                  pf_count_rmw_pipe_wd_ldb_mem_re
    ,input  logic [(       6)-1:0] pf_count_rmw_pipe_wd_ldb_mem_raddr
    ,input  logic [(       6)-1:0] pf_count_rmw_pipe_wd_ldb_mem_waddr
    ,input  logic                  pf_count_rmw_pipe_wd_ldb_mem_we
    ,input  logic [(      10)-1:0] pf_count_rmw_pipe_wd_ldb_mem_wdata
    ,output logic [(      10)-1:0] pf_count_rmw_pipe_wd_ldb_mem_rdata

    ,output logic                  rf_count_rmw_pipe_wd_ldb_mem_re
    ,output logic                  rf_count_rmw_pipe_wd_ldb_mem_rclk
    ,output logic                  rf_count_rmw_pipe_wd_ldb_mem_rclk_rst_n
    ,output logic [(       6)-1:0] rf_count_rmw_pipe_wd_ldb_mem_raddr
    ,output logic [(       6)-1:0] rf_count_rmw_pipe_wd_ldb_mem_waddr
    ,output logic                  rf_count_rmw_pipe_wd_ldb_mem_we
    ,output logic                  rf_count_rmw_pipe_wd_ldb_mem_wclk
    ,output logic                  rf_count_rmw_pipe_wd_ldb_mem_wclk_rst_n
    ,output logic [(      10)-1:0] rf_count_rmw_pipe_wd_ldb_mem_wdata
    ,input  logic [(      10)-1:0] rf_count_rmw_pipe_wd_ldb_mem_rdata

    ,output logic                  rf_count_rmw_pipe_wd_ldb_mem_error

    ,input  logic                  func_dir_cq_depth_re
    ,input  logic [(       6)-1:0] func_dir_cq_depth_raddr
    ,input  logic [(       6)-1:0] func_dir_cq_depth_waddr
    ,input  logic                  func_dir_cq_depth_we
    ,input  logic [(      13)-1:0] func_dir_cq_depth_wdata
    ,output logic [(      13)-1:0] func_dir_cq_depth_rdata

    ,input  logic                  pf_dir_cq_depth_re
    ,input  logic [(       6)-1:0] pf_dir_cq_depth_raddr
    ,input  logic [(       6)-1:0] pf_dir_cq_depth_waddr
    ,input  logic                  pf_dir_cq_depth_we
    ,input  logic [(      13)-1:0] pf_dir_cq_depth_wdata
    ,output logic [(      13)-1:0] pf_dir_cq_depth_rdata

    ,output logic                  rf_dir_cq_depth_re
    ,output logic                  rf_dir_cq_depth_rclk
    ,output logic                  rf_dir_cq_depth_rclk_rst_n
    ,output logic [(       6)-1:0] rf_dir_cq_depth_raddr
    ,output logic [(       6)-1:0] rf_dir_cq_depth_waddr
    ,output logic                  rf_dir_cq_depth_we
    ,output logic                  rf_dir_cq_depth_wclk
    ,output logic                  rf_dir_cq_depth_wclk_rst_n
    ,output logic [(      13)-1:0] rf_dir_cq_depth_wdata
    ,input  logic [(      13)-1:0] rf_dir_cq_depth_rdata

    ,output logic                  rf_dir_cq_depth_error

    ,input  logic                  func_dir_cq_intr_thresh_re
    ,input  logic [(       6)-1:0] func_dir_cq_intr_thresh_raddr
    ,input  logic [(       6)-1:0] func_dir_cq_intr_thresh_waddr
    ,input  logic                  func_dir_cq_intr_thresh_we
    ,input  logic [(      15)-1:0] func_dir_cq_intr_thresh_wdata
    ,output logic [(      15)-1:0] func_dir_cq_intr_thresh_rdata

    ,input  logic                  pf_dir_cq_intr_thresh_re
    ,input  logic [(       6)-1:0] pf_dir_cq_intr_thresh_raddr
    ,input  logic [(       6)-1:0] pf_dir_cq_intr_thresh_waddr
    ,input  logic                  pf_dir_cq_intr_thresh_we
    ,input  logic [(      15)-1:0] pf_dir_cq_intr_thresh_wdata
    ,output logic [(      15)-1:0] pf_dir_cq_intr_thresh_rdata

    ,output logic                  rf_dir_cq_intr_thresh_re
    ,output logic                  rf_dir_cq_intr_thresh_rclk
    ,output logic                  rf_dir_cq_intr_thresh_rclk_rst_n
    ,output logic [(       6)-1:0] rf_dir_cq_intr_thresh_raddr
    ,output logic [(       6)-1:0] rf_dir_cq_intr_thresh_waddr
    ,output logic                  rf_dir_cq_intr_thresh_we
    ,output logic                  rf_dir_cq_intr_thresh_wclk
    ,output logic                  rf_dir_cq_intr_thresh_wclk_rst_n
    ,output logic [(      15)-1:0] rf_dir_cq_intr_thresh_wdata
    ,input  logic [(      15)-1:0] rf_dir_cq_intr_thresh_rdata

    ,output logic                  rf_dir_cq_intr_thresh_error

    ,input  logic                  func_dir_cq_token_depth_select_re
    ,input  logic [(       6)-1:0] func_dir_cq_token_depth_select_raddr
    ,input  logic [(       6)-1:0] func_dir_cq_token_depth_select_waddr
    ,input  logic                  func_dir_cq_token_depth_select_we
    ,input  logic [(       6)-1:0] func_dir_cq_token_depth_select_wdata
    ,output logic [(       6)-1:0] func_dir_cq_token_depth_select_rdata

    ,input  logic                  pf_dir_cq_token_depth_select_re
    ,input  logic [(       6)-1:0] pf_dir_cq_token_depth_select_raddr
    ,input  logic [(       6)-1:0] pf_dir_cq_token_depth_select_waddr
    ,input  logic                  pf_dir_cq_token_depth_select_we
    ,input  logic [(       6)-1:0] pf_dir_cq_token_depth_select_wdata
    ,output logic [(       6)-1:0] pf_dir_cq_token_depth_select_rdata

    ,output logic                  rf_dir_cq_token_depth_select_re
    ,output logic                  rf_dir_cq_token_depth_select_rclk
    ,output logic                  rf_dir_cq_token_depth_select_rclk_rst_n
    ,output logic [(       6)-1:0] rf_dir_cq_token_depth_select_raddr
    ,output logic [(       6)-1:0] rf_dir_cq_token_depth_select_waddr
    ,output logic                  rf_dir_cq_token_depth_select_we
    ,output logic                  rf_dir_cq_token_depth_select_wclk
    ,output logic                  rf_dir_cq_token_depth_select_wclk_rst_n
    ,output logic [(       6)-1:0] rf_dir_cq_token_depth_select_wdata
    ,input  logic [(       6)-1:0] rf_dir_cq_token_depth_select_rdata

    ,output logic                  rf_dir_cq_token_depth_select_error

    ,input  logic                  func_dir_cq_wptr_re
    ,input  logic [(       6)-1:0] func_dir_cq_wptr_raddr
    ,input  logic [(       6)-1:0] func_dir_cq_wptr_waddr
    ,input  logic                  func_dir_cq_wptr_we
    ,input  logic [(      13)-1:0] func_dir_cq_wptr_wdata
    ,output logic [(      13)-1:0] func_dir_cq_wptr_rdata

    ,input  logic                  pf_dir_cq_wptr_re
    ,input  logic [(       6)-1:0] pf_dir_cq_wptr_raddr
    ,input  logic [(       6)-1:0] pf_dir_cq_wptr_waddr
    ,input  logic                  pf_dir_cq_wptr_we
    ,input  logic [(      13)-1:0] pf_dir_cq_wptr_wdata
    ,output logic [(      13)-1:0] pf_dir_cq_wptr_rdata

    ,output logic                  rf_dir_cq_wptr_re
    ,output logic                  rf_dir_cq_wptr_rclk
    ,output logic                  rf_dir_cq_wptr_rclk_rst_n
    ,output logic [(       6)-1:0] rf_dir_cq_wptr_raddr
    ,output logic [(       6)-1:0] rf_dir_cq_wptr_waddr
    ,output logic                  rf_dir_cq_wptr_we
    ,output logic                  rf_dir_cq_wptr_wclk
    ,output logic                  rf_dir_cq_wptr_wclk_rst_n
    ,output logic [(      13)-1:0] rf_dir_cq_wptr_wdata
    ,input  logic [(      13)-1:0] rf_dir_cq_wptr_rdata

    ,output logic                  rf_dir_cq_wptr_error

    ,input  logic                  func_hcw_enq_w_rx_sync_mem_re
    ,input  logic [(       4)-1:0] func_hcw_enq_w_rx_sync_mem_raddr
    ,input  logic [(       4)-1:0] func_hcw_enq_w_rx_sync_mem_waddr
    ,input  logic                  func_hcw_enq_w_rx_sync_mem_we
    ,input  logic [(     160)-1:0] func_hcw_enq_w_rx_sync_mem_wdata
    ,output logic [(     160)-1:0] func_hcw_enq_w_rx_sync_mem_rdata

    ,input  logic                  pf_hcw_enq_w_rx_sync_mem_re
    ,input  logic [(       4)-1:0] pf_hcw_enq_w_rx_sync_mem_raddr
    ,input  logic [(       4)-1:0] pf_hcw_enq_w_rx_sync_mem_waddr
    ,input  logic                  pf_hcw_enq_w_rx_sync_mem_we
    ,input  logic [(     160)-1:0] pf_hcw_enq_w_rx_sync_mem_wdata
    ,output logic [(     160)-1:0] pf_hcw_enq_w_rx_sync_mem_rdata

    ,output logic                  rf_hcw_enq_w_rx_sync_mem_re
    ,output logic                  rf_hcw_enq_w_rx_sync_mem_rclk
    ,output logic                  rf_hcw_enq_w_rx_sync_mem_rclk_rst_n
    ,output logic [(       4)-1:0] rf_hcw_enq_w_rx_sync_mem_raddr
    ,output logic [(       4)-1:0] rf_hcw_enq_w_rx_sync_mem_waddr
    ,output logic                  rf_hcw_enq_w_rx_sync_mem_we
    ,output logic                  rf_hcw_enq_w_rx_sync_mem_wclk
    ,output logic                  rf_hcw_enq_w_rx_sync_mem_wclk_rst_n
    ,output logic [(     160)-1:0] rf_hcw_enq_w_rx_sync_mem_wdata
    ,input  logic [(     160)-1:0] rf_hcw_enq_w_rx_sync_mem_rdata

    ,output logic                  rf_hcw_enq_w_rx_sync_mem_error

    ,input  logic                  func_hist_list_a_minmax_re
    ,input  logic [(       6)-1:0] func_hist_list_a_minmax_addr
    ,input  logic                  func_hist_list_a_minmax_we
    ,input  logic [(      30)-1:0] func_hist_list_a_minmax_wdata
    ,output logic [(      30)-1:0] func_hist_list_a_minmax_rdata

    ,input  logic                  pf_hist_list_a_minmax_re
    ,input  logic [(       6)-1:0] pf_hist_list_a_minmax_addr
    ,input  logic                  pf_hist_list_a_minmax_we
    ,input  logic [(      30)-1:0] pf_hist_list_a_minmax_wdata
    ,output logic [(      30)-1:0] pf_hist_list_a_minmax_rdata

    ,output logic                  rf_hist_list_a_minmax_re
    ,output logic                  rf_hist_list_a_minmax_rclk
    ,output logic                  rf_hist_list_a_minmax_rclk_rst_n
    ,output logic [(       6)-1:0] rf_hist_list_a_minmax_raddr
    ,output logic [(       6)-1:0] rf_hist_list_a_minmax_waddr
    ,output logic                  rf_hist_list_a_minmax_we
    ,output logic                  rf_hist_list_a_minmax_wclk
    ,output logic                  rf_hist_list_a_minmax_wclk_rst_n
    ,output logic [(      30)-1:0] rf_hist_list_a_minmax_wdata
    ,input  logic [(      30)-1:0] rf_hist_list_a_minmax_rdata

    ,output logic                  rf_hist_list_a_minmax_error

    ,input  logic                  func_hist_list_a_ptr_re
    ,input  logic [(       6)-1:0] func_hist_list_a_ptr_raddr
    ,input  logic [(       6)-1:0] func_hist_list_a_ptr_waddr
    ,input  logic                  func_hist_list_a_ptr_we
    ,input  logic [(      32)-1:0] func_hist_list_a_ptr_wdata
    ,output logic [(      32)-1:0] func_hist_list_a_ptr_rdata

    ,input  logic                  pf_hist_list_a_ptr_re
    ,input  logic [(       6)-1:0] pf_hist_list_a_ptr_raddr
    ,input  logic [(       6)-1:0] pf_hist_list_a_ptr_waddr
    ,input  logic                  pf_hist_list_a_ptr_we
    ,input  logic [(      32)-1:0] pf_hist_list_a_ptr_wdata
    ,output logic [(      32)-1:0] pf_hist_list_a_ptr_rdata

    ,output logic                  rf_hist_list_a_ptr_re
    ,output logic                  rf_hist_list_a_ptr_rclk
    ,output logic                  rf_hist_list_a_ptr_rclk_rst_n
    ,output logic [(       6)-1:0] rf_hist_list_a_ptr_raddr
    ,output logic [(       6)-1:0] rf_hist_list_a_ptr_waddr
    ,output logic                  rf_hist_list_a_ptr_we
    ,output logic                  rf_hist_list_a_ptr_wclk
    ,output logic                  rf_hist_list_a_ptr_wclk_rst_n
    ,output logic [(      32)-1:0] rf_hist_list_a_ptr_wdata
    ,input  logic [(      32)-1:0] rf_hist_list_a_ptr_rdata

    ,output logic                  rf_hist_list_a_ptr_error

    ,input  logic                  func_hist_list_minmax_re
    ,input  logic [(       6)-1:0] func_hist_list_minmax_addr
    ,input  logic                  func_hist_list_minmax_we
    ,input  logic [(      30)-1:0] func_hist_list_minmax_wdata
    ,output logic [(      30)-1:0] func_hist_list_minmax_rdata

    ,input  logic                  pf_hist_list_minmax_re
    ,input  logic [(       6)-1:0] pf_hist_list_minmax_addr
    ,input  logic                  pf_hist_list_minmax_we
    ,input  logic [(      30)-1:0] pf_hist_list_minmax_wdata
    ,output logic [(      30)-1:0] pf_hist_list_minmax_rdata

    ,output logic                  rf_hist_list_minmax_re
    ,output logic                  rf_hist_list_minmax_rclk
    ,output logic                  rf_hist_list_minmax_rclk_rst_n
    ,output logic [(       6)-1:0] rf_hist_list_minmax_raddr
    ,output logic [(       6)-1:0] rf_hist_list_minmax_waddr
    ,output logic                  rf_hist_list_minmax_we
    ,output logic                  rf_hist_list_minmax_wclk
    ,output logic                  rf_hist_list_minmax_wclk_rst_n
    ,output logic [(      30)-1:0] rf_hist_list_minmax_wdata
    ,input  logic [(      30)-1:0] rf_hist_list_minmax_rdata

    ,output logic                  rf_hist_list_minmax_error

    ,input  logic                  func_hist_list_ptr_re
    ,input  logic [(       6)-1:0] func_hist_list_ptr_raddr
    ,input  logic [(       6)-1:0] func_hist_list_ptr_waddr
    ,input  logic                  func_hist_list_ptr_we
    ,input  logic [(      32)-1:0] func_hist_list_ptr_wdata
    ,output logic [(      32)-1:0] func_hist_list_ptr_rdata

    ,input  logic                  pf_hist_list_ptr_re
    ,input  logic [(       6)-1:0] pf_hist_list_ptr_raddr
    ,input  logic [(       6)-1:0] pf_hist_list_ptr_waddr
    ,input  logic                  pf_hist_list_ptr_we
    ,input  logic [(      32)-1:0] pf_hist_list_ptr_wdata
    ,output logic [(      32)-1:0] pf_hist_list_ptr_rdata

    ,output logic                  rf_hist_list_ptr_re
    ,output logic                  rf_hist_list_ptr_rclk
    ,output logic                  rf_hist_list_ptr_rclk_rst_n
    ,output logic [(       6)-1:0] rf_hist_list_ptr_raddr
    ,output logic [(       6)-1:0] rf_hist_list_ptr_waddr
    ,output logic                  rf_hist_list_ptr_we
    ,output logic                  rf_hist_list_ptr_wclk
    ,output logic                  rf_hist_list_ptr_wclk_rst_n
    ,output logic [(      32)-1:0] rf_hist_list_ptr_wdata
    ,input  logic [(      32)-1:0] rf_hist_list_ptr_rdata

    ,output logic                  rf_hist_list_ptr_error

    ,input  logic                  func_ldb_cq_depth_re
    ,input  logic [(       6)-1:0] func_ldb_cq_depth_raddr
    ,input  logic [(       6)-1:0] func_ldb_cq_depth_waddr
    ,input  logic                  func_ldb_cq_depth_we
    ,input  logic [(      13)-1:0] func_ldb_cq_depth_wdata
    ,output logic [(      13)-1:0] func_ldb_cq_depth_rdata

    ,input  logic                  pf_ldb_cq_depth_re
    ,input  logic [(       6)-1:0] pf_ldb_cq_depth_raddr
    ,input  logic [(       6)-1:0] pf_ldb_cq_depth_waddr
    ,input  logic                  pf_ldb_cq_depth_we
    ,input  logic [(      13)-1:0] pf_ldb_cq_depth_wdata
    ,output logic [(      13)-1:0] pf_ldb_cq_depth_rdata

    ,output logic                  rf_ldb_cq_depth_re
    ,output logic                  rf_ldb_cq_depth_rclk
    ,output logic                  rf_ldb_cq_depth_rclk_rst_n
    ,output logic [(       6)-1:0] rf_ldb_cq_depth_raddr
    ,output logic [(       6)-1:0] rf_ldb_cq_depth_waddr
    ,output logic                  rf_ldb_cq_depth_we
    ,output logic                  rf_ldb_cq_depth_wclk
    ,output logic                  rf_ldb_cq_depth_wclk_rst_n
    ,output logic [(      13)-1:0] rf_ldb_cq_depth_wdata
    ,input  logic [(      13)-1:0] rf_ldb_cq_depth_rdata

    ,output logic                  rf_ldb_cq_depth_error

    ,input  logic                  func_ldb_cq_intr_thresh_re
    ,input  logic [(       6)-1:0] func_ldb_cq_intr_thresh_raddr
    ,input  logic [(       6)-1:0] func_ldb_cq_intr_thresh_waddr
    ,input  logic                  func_ldb_cq_intr_thresh_we
    ,input  logic [(      13)-1:0] func_ldb_cq_intr_thresh_wdata
    ,output logic [(      13)-1:0] func_ldb_cq_intr_thresh_rdata

    ,input  logic                  pf_ldb_cq_intr_thresh_re
    ,input  logic [(       6)-1:0] pf_ldb_cq_intr_thresh_raddr
    ,input  logic [(       6)-1:0] pf_ldb_cq_intr_thresh_waddr
    ,input  logic                  pf_ldb_cq_intr_thresh_we
    ,input  logic [(      13)-1:0] pf_ldb_cq_intr_thresh_wdata
    ,output logic [(      13)-1:0] pf_ldb_cq_intr_thresh_rdata

    ,output logic                  rf_ldb_cq_intr_thresh_re
    ,output logic                  rf_ldb_cq_intr_thresh_rclk
    ,output logic                  rf_ldb_cq_intr_thresh_rclk_rst_n
    ,output logic [(       6)-1:0] rf_ldb_cq_intr_thresh_raddr
    ,output logic [(       6)-1:0] rf_ldb_cq_intr_thresh_waddr
    ,output logic                  rf_ldb_cq_intr_thresh_we
    ,output logic                  rf_ldb_cq_intr_thresh_wclk
    ,output logic                  rf_ldb_cq_intr_thresh_wclk_rst_n
    ,output logic [(      13)-1:0] rf_ldb_cq_intr_thresh_wdata
    ,input  logic [(      13)-1:0] rf_ldb_cq_intr_thresh_rdata

    ,output logic                  rf_ldb_cq_intr_thresh_error

    ,input  logic                  func_ldb_cq_on_off_threshold_re
    ,input  logic [(       6)-1:0] func_ldb_cq_on_off_threshold_raddr
    ,input  logic [(       6)-1:0] func_ldb_cq_on_off_threshold_waddr
    ,input  logic                  func_ldb_cq_on_off_threshold_we
    ,input  logic [(      32)-1:0] func_ldb_cq_on_off_threshold_wdata
    ,output logic [(      32)-1:0] func_ldb_cq_on_off_threshold_rdata

    ,input  logic                  pf_ldb_cq_on_off_threshold_re
    ,input  logic [(       6)-1:0] pf_ldb_cq_on_off_threshold_raddr
    ,input  logic [(       6)-1:0] pf_ldb_cq_on_off_threshold_waddr
    ,input  logic                  pf_ldb_cq_on_off_threshold_we
    ,input  logic [(      32)-1:0] pf_ldb_cq_on_off_threshold_wdata
    ,output logic [(      32)-1:0] pf_ldb_cq_on_off_threshold_rdata

    ,output logic                  rf_ldb_cq_on_off_threshold_re
    ,output logic                  rf_ldb_cq_on_off_threshold_rclk
    ,output logic                  rf_ldb_cq_on_off_threshold_rclk_rst_n
    ,output logic [(       6)-1:0] rf_ldb_cq_on_off_threshold_raddr
    ,output logic [(       6)-1:0] rf_ldb_cq_on_off_threshold_waddr
    ,output logic                  rf_ldb_cq_on_off_threshold_we
    ,output logic                  rf_ldb_cq_on_off_threshold_wclk
    ,output logic                  rf_ldb_cq_on_off_threshold_wclk_rst_n
    ,output logic [(      32)-1:0] rf_ldb_cq_on_off_threshold_wdata
    ,input  logic [(      32)-1:0] rf_ldb_cq_on_off_threshold_rdata

    ,output logic                  rf_ldb_cq_on_off_threshold_error

    ,input  logic                  func_ldb_cq_token_depth_select_re
    ,input  logic [(       6)-1:0] func_ldb_cq_token_depth_select_raddr
    ,input  logic [(       6)-1:0] func_ldb_cq_token_depth_select_waddr
    ,input  logic                  func_ldb_cq_token_depth_select_we
    ,input  logic [(       6)-1:0] func_ldb_cq_token_depth_select_wdata
    ,output logic [(       6)-1:0] func_ldb_cq_token_depth_select_rdata

    ,input  logic                  pf_ldb_cq_token_depth_select_re
    ,input  logic [(       6)-1:0] pf_ldb_cq_token_depth_select_raddr
    ,input  logic [(       6)-1:0] pf_ldb_cq_token_depth_select_waddr
    ,input  logic                  pf_ldb_cq_token_depth_select_we
    ,input  logic [(       6)-1:0] pf_ldb_cq_token_depth_select_wdata
    ,output logic [(       6)-1:0] pf_ldb_cq_token_depth_select_rdata

    ,output logic                  rf_ldb_cq_token_depth_select_re
    ,output logic                  rf_ldb_cq_token_depth_select_rclk
    ,output logic                  rf_ldb_cq_token_depth_select_rclk_rst_n
    ,output logic [(       6)-1:0] rf_ldb_cq_token_depth_select_raddr
    ,output logic [(       6)-1:0] rf_ldb_cq_token_depth_select_waddr
    ,output logic                  rf_ldb_cq_token_depth_select_we
    ,output logic                  rf_ldb_cq_token_depth_select_wclk
    ,output logic                  rf_ldb_cq_token_depth_select_wclk_rst_n
    ,output logic [(       6)-1:0] rf_ldb_cq_token_depth_select_wdata
    ,input  logic [(       6)-1:0] rf_ldb_cq_token_depth_select_rdata

    ,output logic                  rf_ldb_cq_token_depth_select_error

    ,input  logic                  func_ldb_cq_wptr_re
    ,input  logic [(       6)-1:0] func_ldb_cq_wptr_raddr
    ,input  logic [(       6)-1:0] func_ldb_cq_wptr_waddr
    ,input  logic                  func_ldb_cq_wptr_we
    ,input  logic [(      13)-1:0] func_ldb_cq_wptr_wdata
    ,output logic [(      13)-1:0] func_ldb_cq_wptr_rdata

    ,input  logic                  pf_ldb_cq_wptr_re
    ,input  logic [(       6)-1:0] pf_ldb_cq_wptr_raddr
    ,input  logic [(       6)-1:0] pf_ldb_cq_wptr_waddr
    ,input  logic                  pf_ldb_cq_wptr_we
    ,input  logic [(      13)-1:0] pf_ldb_cq_wptr_wdata
    ,output logic [(      13)-1:0] pf_ldb_cq_wptr_rdata

    ,output logic                  rf_ldb_cq_wptr_re
    ,output logic                  rf_ldb_cq_wptr_rclk
    ,output logic                  rf_ldb_cq_wptr_rclk_rst_n
    ,output logic [(       6)-1:0] rf_ldb_cq_wptr_raddr
    ,output logic [(       6)-1:0] rf_ldb_cq_wptr_waddr
    ,output logic                  rf_ldb_cq_wptr_we
    ,output logic                  rf_ldb_cq_wptr_wclk
    ,output logic                  rf_ldb_cq_wptr_wclk_rst_n
    ,output logic [(      13)-1:0] rf_ldb_cq_wptr_wdata
    ,input  logic [(      13)-1:0] rf_ldb_cq_wptr_rdata

    ,output logic                  rf_ldb_cq_wptr_error

    ,input  logic                  func_ord_qid_sn_re
    ,input  logic [(       5)-1:0] func_ord_qid_sn_raddr
    ,input  logic [(       5)-1:0] func_ord_qid_sn_waddr
    ,input  logic                  func_ord_qid_sn_we
    ,input  logic [(      12)-1:0] func_ord_qid_sn_wdata
    ,output logic [(      12)-1:0] func_ord_qid_sn_rdata

    ,input  logic                  pf_ord_qid_sn_re
    ,input  logic [(       5)-1:0] pf_ord_qid_sn_raddr
    ,input  logic [(       5)-1:0] pf_ord_qid_sn_waddr
    ,input  logic                  pf_ord_qid_sn_we
    ,input  logic [(      12)-1:0] pf_ord_qid_sn_wdata
    ,output logic [(      12)-1:0] pf_ord_qid_sn_rdata

    ,output logic                  rf_ord_qid_sn_re
    ,output logic                  rf_ord_qid_sn_rclk
    ,output logic                  rf_ord_qid_sn_rclk_rst_n
    ,output logic [(       5)-1:0] rf_ord_qid_sn_raddr
    ,output logic [(       5)-1:0] rf_ord_qid_sn_waddr
    ,output logic                  rf_ord_qid_sn_we
    ,output logic                  rf_ord_qid_sn_wclk
    ,output logic                  rf_ord_qid_sn_wclk_rst_n
    ,output logic [(      12)-1:0] rf_ord_qid_sn_wdata
    ,input  logic [(      12)-1:0] rf_ord_qid_sn_rdata

    ,output logic                  rf_ord_qid_sn_error

    ,input  logic                  func_ord_qid_sn_map_re
    ,input  logic [(       5)-1:0] func_ord_qid_sn_map_raddr
    ,input  logic [(       5)-1:0] func_ord_qid_sn_map_waddr
    ,input  logic                  func_ord_qid_sn_map_we
    ,input  logic [(      12)-1:0] func_ord_qid_sn_map_wdata
    ,output logic [(      12)-1:0] func_ord_qid_sn_map_rdata

    ,input  logic                  pf_ord_qid_sn_map_re
    ,input  logic [(       5)-1:0] pf_ord_qid_sn_map_raddr
    ,input  logic [(       5)-1:0] pf_ord_qid_sn_map_waddr
    ,input  logic                  pf_ord_qid_sn_map_we
    ,input  logic [(      12)-1:0] pf_ord_qid_sn_map_wdata
    ,output logic [(      12)-1:0] pf_ord_qid_sn_map_rdata

    ,output logic                  rf_ord_qid_sn_map_re
    ,output logic                  rf_ord_qid_sn_map_rclk
    ,output logic                  rf_ord_qid_sn_map_rclk_rst_n
    ,output logic [(       5)-1:0] rf_ord_qid_sn_map_raddr
    ,output logic [(       5)-1:0] rf_ord_qid_sn_map_waddr
    ,output logic                  rf_ord_qid_sn_map_we
    ,output logic                  rf_ord_qid_sn_map_wclk
    ,output logic                  rf_ord_qid_sn_map_wclk_rst_n
    ,output logic [(      12)-1:0] rf_ord_qid_sn_map_wdata
    ,input  logic [(      12)-1:0] rf_ord_qid_sn_map_rdata

    ,output logic                  rf_ord_qid_sn_map_error

    ,input  logic                  func_outbound_hcw_fifo_mem_re
    ,input  logic [(       4)-1:0] func_outbound_hcw_fifo_mem_raddr
    ,input  logic [(       4)-1:0] func_outbound_hcw_fifo_mem_waddr
    ,input  logic                  func_outbound_hcw_fifo_mem_we
    ,input  logic [(     160)-1:0] func_outbound_hcw_fifo_mem_wdata
    ,output logic [(     160)-1:0] func_outbound_hcw_fifo_mem_rdata

    ,input  logic                  pf_outbound_hcw_fifo_mem_re
    ,input  logic [(       4)-1:0] pf_outbound_hcw_fifo_mem_raddr
    ,input  logic [(       4)-1:0] pf_outbound_hcw_fifo_mem_waddr
    ,input  logic                  pf_outbound_hcw_fifo_mem_we
    ,input  logic [(     160)-1:0] pf_outbound_hcw_fifo_mem_wdata
    ,output logic [(     160)-1:0] pf_outbound_hcw_fifo_mem_rdata

    ,output logic                  rf_outbound_hcw_fifo_mem_re
    ,output logic                  rf_outbound_hcw_fifo_mem_rclk
    ,output logic                  rf_outbound_hcw_fifo_mem_rclk_rst_n
    ,output logic [(       4)-1:0] rf_outbound_hcw_fifo_mem_raddr
    ,output logic [(       4)-1:0] rf_outbound_hcw_fifo_mem_waddr
    ,output logic                  rf_outbound_hcw_fifo_mem_we
    ,output logic                  rf_outbound_hcw_fifo_mem_wclk
    ,output logic                  rf_outbound_hcw_fifo_mem_wclk_rst_n
    ,output logic [(     160)-1:0] rf_outbound_hcw_fifo_mem_wdata
    ,input  logic [(     160)-1:0] rf_outbound_hcw_fifo_mem_rdata

    ,output logic                  rf_outbound_hcw_fifo_mem_error

    ,input  logic                  func_qed_chp_sch_flid_ret_rx_sync_mem_re
    ,input  logic [(       2)-1:0] func_qed_chp_sch_flid_ret_rx_sync_mem_raddr
    ,input  logic [(       2)-1:0] func_qed_chp_sch_flid_ret_rx_sync_mem_waddr
    ,input  logic                  func_qed_chp_sch_flid_ret_rx_sync_mem_we
    ,input  logic [(      26)-1:0] func_qed_chp_sch_flid_ret_rx_sync_mem_wdata
    ,output logic [(      26)-1:0] func_qed_chp_sch_flid_ret_rx_sync_mem_rdata

    ,input  logic                  pf_qed_chp_sch_flid_ret_rx_sync_mem_re
    ,input  logic [(       2)-1:0] pf_qed_chp_sch_flid_ret_rx_sync_mem_raddr
    ,input  logic [(       2)-1:0] pf_qed_chp_sch_flid_ret_rx_sync_mem_waddr
    ,input  logic                  pf_qed_chp_sch_flid_ret_rx_sync_mem_we
    ,input  logic [(      26)-1:0] pf_qed_chp_sch_flid_ret_rx_sync_mem_wdata
    ,output logic [(      26)-1:0] pf_qed_chp_sch_flid_ret_rx_sync_mem_rdata

    ,output logic                  rf_qed_chp_sch_flid_ret_rx_sync_mem_re
    ,output logic                  rf_qed_chp_sch_flid_ret_rx_sync_mem_rclk
    ,output logic                  rf_qed_chp_sch_flid_ret_rx_sync_mem_rclk_rst_n
    ,output logic [(       2)-1:0] rf_qed_chp_sch_flid_ret_rx_sync_mem_raddr
    ,output logic [(       2)-1:0] rf_qed_chp_sch_flid_ret_rx_sync_mem_waddr
    ,output logic                  rf_qed_chp_sch_flid_ret_rx_sync_mem_we
    ,output logic                  rf_qed_chp_sch_flid_ret_rx_sync_mem_wclk
    ,output logic                  rf_qed_chp_sch_flid_ret_rx_sync_mem_wclk_rst_n
    ,output logic [(      26)-1:0] rf_qed_chp_sch_flid_ret_rx_sync_mem_wdata
    ,input  logic [(      26)-1:0] rf_qed_chp_sch_flid_ret_rx_sync_mem_rdata

    ,output logic                  rf_qed_chp_sch_flid_ret_rx_sync_mem_error

    ,input  logic                  func_qed_chp_sch_rx_sync_mem_re
    ,input  logic [(       3)-1:0] func_qed_chp_sch_rx_sync_mem_raddr
    ,input  logic [(       3)-1:0] func_qed_chp_sch_rx_sync_mem_waddr
    ,input  logic                  func_qed_chp_sch_rx_sync_mem_we
    ,input  logic [(     177)-1:0] func_qed_chp_sch_rx_sync_mem_wdata
    ,output logic [(     177)-1:0] func_qed_chp_sch_rx_sync_mem_rdata

    ,input  logic                  pf_qed_chp_sch_rx_sync_mem_re
    ,input  logic [(       3)-1:0] pf_qed_chp_sch_rx_sync_mem_raddr
    ,input  logic [(       3)-1:0] pf_qed_chp_sch_rx_sync_mem_waddr
    ,input  logic                  pf_qed_chp_sch_rx_sync_mem_we
    ,input  logic [(     177)-1:0] pf_qed_chp_sch_rx_sync_mem_wdata
    ,output logic [(     177)-1:0] pf_qed_chp_sch_rx_sync_mem_rdata

    ,output logic                  rf_qed_chp_sch_rx_sync_mem_re
    ,output logic                  rf_qed_chp_sch_rx_sync_mem_rclk
    ,output logic                  rf_qed_chp_sch_rx_sync_mem_rclk_rst_n
    ,output logic [(       3)-1:0] rf_qed_chp_sch_rx_sync_mem_raddr
    ,output logic [(       3)-1:0] rf_qed_chp_sch_rx_sync_mem_waddr
    ,output logic                  rf_qed_chp_sch_rx_sync_mem_we
    ,output logic                  rf_qed_chp_sch_rx_sync_mem_wclk
    ,output logic                  rf_qed_chp_sch_rx_sync_mem_wclk_rst_n
    ,output logic [(     177)-1:0] rf_qed_chp_sch_rx_sync_mem_wdata
    ,input  logic [(     177)-1:0] rf_qed_chp_sch_rx_sync_mem_rdata

    ,output logic                  rf_qed_chp_sch_rx_sync_mem_error

    ,input  logic                  func_qed_to_cq_fifo_mem_re
    ,input  logic [(       3)-1:0] func_qed_to_cq_fifo_mem_raddr
    ,input  logic [(       3)-1:0] func_qed_to_cq_fifo_mem_waddr
    ,input  logic                  func_qed_to_cq_fifo_mem_we
    ,input  logic [(     197)-1:0] func_qed_to_cq_fifo_mem_wdata
    ,output logic [(     197)-1:0] func_qed_to_cq_fifo_mem_rdata

    ,input  logic                  pf_qed_to_cq_fifo_mem_re
    ,input  logic [(       3)-1:0] pf_qed_to_cq_fifo_mem_raddr
    ,input  logic [(       3)-1:0] pf_qed_to_cq_fifo_mem_waddr
    ,input  logic                  pf_qed_to_cq_fifo_mem_we
    ,input  logic [(     197)-1:0] pf_qed_to_cq_fifo_mem_wdata
    ,output logic [(     197)-1:0] pf_qed_to_cq_fifo_mem_rdata

    ,output logic                  rf_qed_to_cq_fifo_mem_re
    ,output logic                  rf_qed_to_cq_fifo_mem_rclk
    ,output logic                  rf_qed_to_cq_fifo_mem_rclk_rst_n
    ,output logic [(       3)-1:0] rf_qed_to_cq_fifo_mem_raddr
    ,output logic [(       3)-1:0] rf_qed_to_cq_fifo_mem_waddr
    ,output logic                  rf_qed_to_cq_fifo_mem_we
    ,output logic                  rf_qed_to_cq_fifo_mem_wclk
    ,output logic                  rf_qed_to_cq_fifo_mem_wclk_rst_n
    ,output logic [(     197)-1:0] rf_qed_to_cq_fifo_mem_wdata
    ,input  logic [(     197)-1:0] rf_qed_to_cq_fifo_mem_rdata

    ,output logic                  rf_qed_to_cq_fifo_mem_error

    ,input  logic                  func_threshold_r_pipe_dir_mem_re
    ,input  logic [(       6)-1:0] func_threshold_r_pipe_dir_mem_addr
    ,input  logic                  func_threshold_r_pipe_dir_mem_we
    ,input  logic [(      14)-1:0] func_threshold_r_pipe_dir_mem_wdata
    ,output logic [(      14)-1:0] func_threshold_r_pipe_dir_mem_rdata

    ,input  logic                  pf_threshold_r_pipe_dir_mem_re
    ,input  logic [(       6)-1:0] pf_threshold_r_pipe_dir_mem_addr
    ,input  logic                  pf_threshold_r_pipe_dir_mem_we
    ,input  logic [(      14)-1:0] pf_threshold_r_pipe_dir_mem_wdata
    ,output logic [(      14)-1:0] pf_threshold_r_pipe_dir_mem_rdata

    ,output logic                  rf_threshold_r_pipe_dir_mem_re
    ,output logic                  rf_threshold_r_pipe_dir_mem_rclk
    ,output logic                  rf_threshold_r_pipe_dir_mem_rclk_rst_n
    ,output logic [(       6)-1:0] rf_threshold_r_pipe_dir_mem_raddr
    ,output logic [(       6)-1:0] rf_threshold_r_pipe_dir_mem_waddr
    ,output logic                  rf_threshold_r_pipe_dir_mem_we
    ,output logic                  rf_threshold_r_pipe_dir_mem_wclk
    ,output logic                  rf_threshold_r_pipe_dir_mem_wclk_rst_n
    ,output logic [(      14)-1:0] rf_threshold_r_pipe_dir_mem_wdata
    ,input  logic [(      14)-1:0] rf_threshold_r_pipe_dir_mem_rdata

    ,output logic                  rf_threshold_r_pipe_dir_mem_error

    ,input  logic                  func_threshold_r_pipe_ldb_mem_re
    ,input  logic [(       6)-1:0] func_threshold_r_pipe_ldb_mem_addr
    ,input  logic                  func_threshold_r_pipe_ldb_mem_we
    ,input  logic [(      14)-1:0] func_threshold_r_pipe_ldb_mem_wdata
    ,output logic [(      14)-1:0] func_threshold_r_pipe_ldb_mem_rdata

    ,input  logic                  pf_threshold_r_pipe_ldb_mem_re
    ,input  logic [(       6)-1:0] pf_threshold_r_pipe_ldb_mem_addr
    ,input  logic                  pf_threshold_r_pipe_ldb_mem_we
    ,input  logic [(      14)-1:0] pf_threshold_r_pipe_ldb_mem_wdata
    ,output logic [(      14)-1:0] pf_threshold_r_pipe_ldb_mem_rdata

    ,output logic                  rf_threshold_r_pipe_ldb_mem_re
    ,output logic                  rf_threshold_r_pipe_ldb_mem_rclk
    ,output logic                  rf_threshold_r_pipe_ldb_mem_rclk_rst_n
    ,output logic [(       6)-1:0] rf_threshold_r_pipe_ldb_mem_raddr
    ,output logic [(       6)-1:0] rf_threshold_r_pipe_ldb_mem_waddr
    ,output logic                  rf_threshold_r_pipe_ldb_mem_we
    ,output logic                  rf_threshold_r_pipe_ldb_mem_wclk
    ,output logic                  rf_threshold_r_pipe_ldb_mem_wclk_rst_n
    ,output logic [(      14)-1:0] rf_threshold_r_pipe_ldb_mem_wdata
    ,input  logic [(      14)-1:0] rf_threshold_r_pipe_ldb_mem_rdata

    ,output logic                  rf_threshold_r_pipe_ldb_mem_error

    ,input  logic                  func_freelist_0_re
    ,input  logic [(      11)-1:0] func_freelist_0_addr
    ,input  logic                  func_freelist_0_we
    ,input  logic [(      16)-1:0] func_freelist_0_wdata
    ,output logic [(      16)-1:0] func_freelist_0_rdata

    ,input  logic                  pf_freelist_0_re
    ,input  logic [(      11)-1:0] pf_freelist_0_addr
    ,input  logic                  pf_freelist_0_we
    ,input  logic [(      16)-1:0] pf_freelist_0_wdata
    ,output logic [(      16)-1:0] pf_freelist_0_rdata

    ,output logic                  sr_freelist_0_re
    ,output logic                  sr_freelist_0_clk
    ,output logic                  sr_freelist_0_clk_rst_n
    ,output logic [(      11)-1:0] sr_freelist_0_addr
    ,output logic                  sr_freelist_0_we
    ,output logic [(      16)-1:0] sr_freelist_0_wdata
    ,input  logic [(      16)-1:0] sr_freelist_0_rdata

    ,output logic                  sr_freelist_0_error

    ,input  logic                  func_freelist_1_re
    ,input  logic [(      11)-1:0] func_freelist_1_addr
    ,input  logic                  func_freelist_1_we
    ,input  logic [(      16)-1:0] func_freelist_1_wdata
    ,output logic [(      16)-1:0] func_freelist_1_rdata

    ,input  logic                  pf_freelist_1_re
    ,input  logic [(      11)-1:0] pf_freelist_1_addr
    ,input  logic                  pf_freelist_1_we
    ,input  logic [(      16)-1:0] pf_freelist_1_wdata
    ,output logic [(      16)-1:0] pf_freelist_1_rdata

    ,output logic                  sr_freelist_1_re
    ,output logic                  sr_freelist_1_clk
    ,output logic                  sr_freelist_1_clk_rst_n
    ,output logic [(      11)-1:0] sr_freelist_1_addr
    ,output logic                  sr_freelist_1_we
    ,output logic [(      16)-1:0] sr_freelist_1_wdata
    ,input  logic [(      16)-1:0] sr_freelist_1_rdata

    ,output logic                  sr_freelist_1_error

    ,input  logic                  func_freelist_2_re
    ,input  logic [(      11)-1:0] func_freelist_2_addr
    ,input  logic                  func_freelist_2_we
    ,input  logic [(      16)-1:0] func_freelist_2_wdata
    ,output logic [(      16)-1:0] func_freelist_2_rdata

    ,input  logic                  pf_freelist_2_re
    ,input  logic [(      11)-1:0] pf_freelist_2_addr
    ,input  logic                  pf_freelist_2_we
    ,input  logic [(      16)-1:0] pf_freelist_2_wdata
    ,output logic [(      16)-1:0] pf_freelist_2_rdata

    ,output logic                  sr_freelist_2_re
    ,output logic                  sr_freelist_2_clk
    ,output logic                  sr_freelist_2_clk_rst_n
    ,output logic [(      11)-1:0] sr_freelist_2_addr
    ,output logic                  sr_freelist_2_we
    ,output logic [(      16)-1:0] sr_freelist_2_wdata
    ,input  logic [(      16)-1:0] sr_freelist_2_rdata

    ,output logic                  sr_freelist_2_error

    ,input  logic                  func_freelist_3_re
    ,input  logic [(      11)-1:0] func_freelist_3_addr
    ,input  logic                  func_freelist_3_we
    ,input  logic [(      16)-1:0] func_freelist_3_wdata
    ,output logic [(      16)-1:0] func_freelist_3_rdata

    ,input  logic                  pf_freelist_3_re
    ,input  logic [(      11)-1:0] pf_freelist_3_addr
    ,input  logic                  pf_freelist_3_we
    ,input  logic [(      16)-1:0] pf_freelist_3_wdata
    ,output logic [(      16)-1:0] pf_freelist_3_rdata

    ,output logic                  sr_freelist_3_re
    ,output logic                  sr_freelist_3_clk
    ,output logic                  sr_freelist_3_clk_rst_n
    ,output logic [(      11)-1:0] sr_freelist_3_addr
    ,output logic                  sr_freelist_3_we
    ,output logic [(      16)-1:0] sr_freelist_3_wdata
    ,input  logic [(      16)-1:0] sr_freelist_3_rdata

    ,output logic                  sr_freelist_3_error

    ,input  logic                  func_freelist_4_re
    ,input  logic [(      11)-1:0] func_freelist_4_addr
    ,input  logic                  func_freelist_4_we
    ,input  logic [(      16)-1:0] func_freelist_4_wdata
    ,output logic [(      16)-1:0] func_freelist_4_rdata

    ,input  logic                  pf_freelist_4_re
    ,input  logic [(      11)-1:0] pf_freelist_4_addr
    ,input  logic                  pf_freelist_4_we
    ,input  logic [(      16)-1:0] pf_freelist_4_wdata
    ,output logic [(      16)-1:0] pf_freelist_4_rdata

    ,output logic                  sr_freelist_4_re
    ,output logic                  sr_freelist_4_clk
    ,output logic                  sr_freelist_4_clk_rst_n
    ,output logic [(      11)-1:0] sr_freelist_4_addr
    ,output logic                  sr_freelist_4_we
    ,output logic [(      16)-1:0] sr_freelist_4_wdata
    ,input  logic [(      16)-1:0] sr_freelist_4_rdata

    ,output logic                  sr_freelist_4_error

    ,input  logic                  func_freelist_5_re
    ,input  logic [(      11)-1:0] func_freelist_5_addr
    ,input  logic                  func_freelist_5_we
    ,input  logic [(      16)-1:0] func_freelist_5_wdata
    ,output logic [(      16)-1:0] func_freelist_5_rdata

    ,input  logic                  pf_freelist_5_re
    ,input  logic [(      11)-1:0] pf_freelist_5_addr
    ,input  logic                  pf_freelist_5_we
    ,input  logic [(      16)-1:0] pf_freelist_5_wdata
    ,output logic [(      16)-1:0] pf_freelist_5_rdata

    ,output logic                  sr_freelist_5_re
    ,output logic                  sr_freelist_5_clk
    ,output logic                  sr_freelist_5_clk_rst_n
    ,output logic [(      11)-1:0] sr_freelist_5_addr
    ,output logic                  sr_freelist_5_we
    ,output logic [(      16)-1:0] sr_freelist_5_wdata
    ,input  logic [(      16)-1:0] sr_freelist_5_rdata

    ,output logic                  sr_freelist_5_error

    ,input  logic                  func_freelist_6_re
    ,input  logic [(      11)-1:0] func_freelist_6_addr
    ,input  logic                  func_freelist_6_we
    ,input  logic [(      16)-1:0] func_freelist_6_wdata
    ,output logic [(      16)-1:0] func_freelist_6_rdata

    ,input  logic                  pf_freelist_6_re
    ,input  logic [(      11)-1:0] pf_freelist_6_addr
    ,input  logic                  pf_freelist_6_we
    ,input  logic [(      16)-1:0] pf_freelist_6_wdata
    ,output logic [(      16)-1:0] pf_freelist_6_rdata

    ,output logic                  sr_freelist_6_re
    ,output logic                  sr_freelist_6_clk
    ,output logic                  sr_freelist_6_clk_rst_n
    ,output logic [(      11)-1:0] sr_freelist_6_addr
    ,output logic                  sr_freelist_6_we
    ,output logic [(      16)-1:0] sr_freelist_6_wdata
    ,input  logic [(      16)-1:0] sr_freelist_6_rdata

    ,output logic                  sr_freelist_6_error

    ,input  logic                  func_freelist_7_re
    ,input  logic [(      11)-1:0] func_freelist_7_addr
    ,input  logic                  func_freelist_7_we
    ,input  logic [(      16)-1:0] func_freelist_7_wdata
    ,output logic [(      16)-1:0] func_freelist_7_rdata

    ,input  logic                  pf_freelist_7_re
    ,input  logic [(      11)-1:0] pf_freelist_7_addr
    ,input  logic                  pf_freelist_7_we
    ,input  logic [(      16)-1:0] pf_freelist_7_wdata
    ,output logic [(      16)-1:0] pf_freelist_7_rdata

    ,output logic                  sr_freelist_7_re
    ,output logic                  sr_freelist_7_clk
    ,output logic                  sr_freelist_7_clk_rst_n
    ,output logic [(      11)-1:0] sr_freelist_7_addr
    ,output logic                  sr_freelist_7_we
    ,output logic [(      16)-1:0] sr_freelist_7_wdata
    ,input  logic [(      16)-1:0] sr_freelist_7_rdata

    ,output logic                  sr_freelist_7_error

    ,input  logic                  func_hist_list_re
    ,input  logic [(      13)-1:0] func_hist_list_addr
    ,input  logic                  func_hist_list_we
    ,input  logic [(      66)-1:0] func_hist_list_wdata
    ,output logic [(      66)-1:0] func_hist_list_rdata

    ,input  logic                  pf_hist_list_re
    ,input  logic [(      13)-1:0] pf_hist_list_addr
    ,input  logic                  pf_hist_list_we
    ,input  logic [(      66)-1:0] pf_hist_list_wdata
    ,output logic [(      66)-1:0] pf_hist_list_rdata

    ,output logic                  sr_hist_list_re
    ,output logic                  sr_hist_list_clk
    ,output logic                  sr_hist_list_clk_rst_n
    ,output logic [(      11)-1:0] sr_hist_list_addr
    ,output logic                  sr_hist_list_we
    ,output logic [(      66)-1:0] sr_hist_list_wdata
    ,input  logic [(      66)-1:0] sr_hist_list_rdata

    ,output logic                  sr_hist_list_error

    ,input  logic                  func_hist_list_a_re
    ,input  logic [(      13)-1:0] func_hist_list_a_addr
    ,input  logic                  func_hist_list_a_we
    ,input  logic [(      66)-1:0] func_hist_list_a_wdata
    ,output logic [(      66)-1:0] func_hist_list_a_rdata

    ,input  logic                  pf_hist_list_a_re
    ,input  logic [(      13)-1:0] pf_hist_list_a_addr
    ,input  logic                  pf_hist_list_a_we
    ,input  logic [(      66)-1:0] pf_hist_list_a_wdata
    ,output logic [(      66)-1:0] pf_hist_list_a_rdata

    ,output logic                  sr_hist_list_a_re
    ,output logic                  sr_hist_list_a_clk
    ,output logic                  sr_hist_list_a_clk_rst_n
    ,output logic [(      11)-1:0] sr_hist_list_a_addr
    ,output logic                  sr_hist_list_a_we
    ,output logic [(      66)-1:0] sr_hist_list_a_wdata
    ,input  logic [(      66)-1:0] sr_hist_list_a_rdata

    ,output logic                  sr_hist_list_a_error

);

logic        rf_aqed_chp_sch_rx_sync_mem_rdata_error;

logic        cfg_mem_ack_aqed_chp_sch_rx_sync_mem_nc;
logic [31:0] cfg_mem_rdata_aqed_chp_sch_rx_sync_mem_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (4)
        ,.DWIDTH              (179)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_aqed_chp_sch_rx_sync_mem (
         .clk                 (hqm_inp_gated_clk)
        ,.rst_n               (hqm_inp_gated_rst_n)

        ,.func_mem_re         (func_aqed_chp_sch_rx_sync_mem_re)
        ,.func_mem_raddr      (func_aqed_chp_sch_rx_sync_mem_raddr)
        ,.func_mem_waddr      (func_aqed_chp_sch_rx_sync_mem_waddr)
        ,.func_mem_we         (func_aqed_chp_sch_rx_sync_mem_we)
        ,.func_mem_wdata      (func_aqed_chp_sch_rx_sync_mem_wdata)
        ,.func_mem_rdata      (func_aqed_chp_sch_rx_sync_mem_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_aqed_chp_sch_rx_sync_mem_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_aqed_chp_sch_rx_sync_mem_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_aqed_chp_sch_rx_sync_mem_re)
        ,.pf_mem_raddr        (pf_aqed_chp_sch_rx_sync_mem_raddr)
        ,.pf_mem_waddr        (pf_aqed_chp_sch_rx_sync_mem_waddr)
        ,.pf_mem_we           (pf_aqed_chp_sch_rx_sync_mem_we)
        ,.pf_mem_wdata        (pf_aqed_chp_sch_rx_sync_mem_wdata)
        ,.pf_mem_rdata        (pf_aqed_chp_sch_rx_sync_mem_rdata)

        ,.mem_wclk            (rf_aqed_chp_sch_rx_sync_mem_wclk)
        ,.mem_rclk            (rf_aqed_chp_sch_rx_sync_mem_rclk)
        ,.mem_wclk_rst_n      (rf_aqed_chp_sch_rx_sync_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_aqed_chp_sch_rx_sync_mem_rclk_rst_n)
        ,.mem_re              (rf_aqed_chp_sch_rx_sync_mem_re)
        ,.mem_raddr           (rf_aqed_chp_sch_rx_sync_mem_raddr)
        ,.mem_waddr           (rf_aqed_chp_sch_rx_sync_mem_waddr)
        ,.mem_we              (rf_aqed_chp_sch_rx_sync_mem_we)
        ,.mem_wdata           (rf_aqed_chp_sch_rx_sync_mem_wdata)
        ,.mem_rdata           (rf_aqed_chp_sch_rx_sync_mem_rdata)

        ,.mem_rdata_error     (rf_aqed_chp_sch_rx_sync_mem_rdata_error)
        ,.error               (rf_aqed_chp_sch_rx_sync_mem_error)
);

logic        rf_chp_chp_rop_hcw_fifo_mem_rdata_error;

logic        cfg_mem_ack_chp_chp_rop_hcw_fifo_mem_nc;
logic [31:0] cfg_mem_rdata_chp_chp_rop_hcw_fifo_mem_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (16)
        ,.DWIDTH              (201)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_chp_chp_rop_hcw_fifo_mem (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_chp_chp_rop_hcw_fifo_mem_re)
        ,.func_mem_raddr      (func_chp_chp_rop_hcw_fifo_mem_raddr)
        ,.func_mem_waddr      (func_chp_chp_rop_hcw_fifo_mem_waddr)
        ,.func_mem_we         (func_chp_chp_rop_hcw_fifo_mem_we)
        ,.func_mem_wdata      (func_chp_chp_rop_hcw_fifo_mem_wdata)
        ,.func_mem_rdata      (func_chp_chp_rop_hcw_fifo_mem_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_chp_chp_rop_hcw_fifo_mem_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_chp_chp_rop_hcw_fifo_mem_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_chp_chp_rop_hcw_fifo_mem_re)
        ,.pf_mem_raddr        (pf_chp_chp_rop_hcw_fifo_mem_raddr)
        ,.pf_mem_waddr        (pf_chp_chp_rop_hcw_fifo_mem_waddr)
        ,.pf_mem_we           (pf_chp_chp_rop_hcw_fifo_mem_we)
        ,.pf_mem_wdata        (pf_chp_chp_rop_hcw_fifo_mem_wdata)
        ,.pf_mem_rdata        (pf_chp_chp_rop_hcw_fifo_mem_rdata)

        ,.mem_wclk            (rf_chp_chp_rop_hcw_fifo_mem_wclk)
        ,.mem_rclk            (rf_chp_chp_rop_hcw_fifo_mem_rclk)
        ,.mem_wclk_rst_n      (rf_chp_chp_rop_hcw_fifo_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_chp_chp_rop_hcw_fifo_mem_rclk_rst_n)
        ,.mem_re              (rf_chp_chp_rop_hcw_fifo_mem_re)
        ,.mem_raddr           (rf_chp_chp_rop_hcw_fifo_mem_raddr)
        ,.mem_waddr           (rf_chp_chp_rop_hcw_fifo_mem_waddr)
        ,.mem_we              (rf_chp_chp_rop_hcw_fifo_mem_we)
        ,.mem_wdata           (rf_chp_chp_rop_hcw_fifo_mem_wdata)
        ,.mem_rdata           (rf_chp_chp_rop_hcw_fifo_mem_rdata)

        ,.mem_rdata_error     (rf_chp_chp_rop_hcw_fifo_mem_rdata_error)
        ,.error               (rf_chp_chp_rop_hcw_fifo_mem_error)
);

logic        rf_chp_lsp_ap_cmp_fifo_mem_rdata_error;

logic        cfg_mem_ack_chp_lsp_ap_cmp_fifo_mem_nc;
logic [31:0] cfg_mem_rdata_chp_lsp_ap_cmp_fifo_mem_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (16)
        ,.DWIDTH              (74)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_chp_lsp_ap_cmp_fifo_mem (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_chp_lsp_ap_cmp_fifo_mem_re)
        ,.func_mem_raddr      (func_chp_lsp_ap_cmp_fifo_mem_raddr)
        ,.func_mem_waddr      (func_chp_lsp_ap_cmp_fifo_mem_waddr)
        ,.func_mem_we         (func_chp_lsp_ap_cmp_fifo_mem_we)
        ,.func_mem_wdata      (func_chp_lsp_ap_cmp_fifo_mem_wdata)
        ,.func_mem_rdata      (func_chp_lsp_ap_cmp_fifo_mem_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_chp_lsp_ap_cmp_fifo_mem_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_chp_lsp_ap_cmp_fifo_mem_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_chp_lsp_ap_cmp_fifo_mem_re)
        ,.pf_mem_raddr        (pf_chp_lsp_ap_cmp_fifo_mem_raddr)
        ,.pf_mem_waddr        (pf_chp_lsp_ap_cmp_fifo_mem_waddr)
        ,.pf_mem_we           (pf_chp_lsp_ap_cmp_fifo_mem_we)
        ,.pf_mem_wdata        (pf_chp_lsp_ap_cmp_fifo_mem_wdata)
        ,.pf_mem_rdata        (pf_chp_lsp_ap_cmp_fifo_mem_rdata)

        ,.mem_wclk            (rf_chp_lsp_ap_cmp_fifo_mem_wclk)
        ,.mem_rclk            (rf_chp_lsp_ap_cmp_fifo_mem_rclk)
        ,.mem_wclk_rst_n      (rf_chp_lsp_ap_cmp_fifo_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_chp_lsp_ap_cmp_fifo_mem_rclk_rst_n)
        ,.mem_re              (rf_chp_lsp_ap_cmp_fifo_mem_re)
        ,.mem_raddr           (rf_chp_lsp_ap_cmp_fifo_mem_raddr)
        ,.mem_waddr           (rf_chp_lsp_ap_cmp_fifo_mem_waddr)
        ,.mem_we              (rf_chp_lsp_ap_cmp_fifo_mem_we)
        ,.mem_wdata           (rf_chp_lsp_ap_cmp_fifo_mem_wdata)
        ,.mem_rdata           (rf_chp_lsp_ap_cmp_fifo_mem_rdata)

        ,.mem_rdata_error     (rf_chp_lsp_ap_cmp_fifo_mem_rdata_error)
        ,.error               (rf_chp_lsp_ap_cmp_fifo_mem_error)
);

logic        rf_chp_lsp_tok_fifo_mem_rdata_error;

logic        cfg_mem_ack_chp_lsp_tok_fifo_mem_nc;
logic [31:0] cfg_mem_rdata_chp_lsp_tok_fifo_mem_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (16)
        ,.DWIDTH              (29)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_chp_lsp_tok_fifo_mem (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_chp_lsp_tok_fifo_mem_re)
        ,.func_mem_raddr      (func_chp_lsp_tok_fifo_mem_raddr)
        ,.func_mem_waddr      (func_chp_lsp_tok_fifo_mem_waddr)
        ,.func_mem_we         (func_chp_lsp_tok_fifo_mem_we)
        ,.func_mem_wdata      (func_chp_lsp_tok_fifo_mem_wdata)
        ,.func_mem_rdata      (func_chp_lsp_tok_fifo_mem_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_chp_lsp_tok_fifo_mem_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_chp_lsp_tok_fifo_mem_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_chp_lsp_tok_fifo_mem_re)
        ,.pf_mem_raddr        (pf_chp_lsp_tok_fifo_mem_raddr)
        ,.pf_mem_waddr        (pf_chp_lsp_tok_fifo_mem_waddr)
        ,.pf_mem_we           (pf_chp_lsp_tok_fifo_mem_we)
        ,.pf_mem_wdata        (pf_chp_lsp_tok_fifo_mem_wdata)
        ,.pf_mem_rdata        (pf_chp_lsp_tok_fifo_mem_rdata)

        ,.mem_wclk            (rf_chp_lsp_tok_fifo_mem_wclk)
        ,.mem_rclk            (rf_chp_lsp_tok_fifo_mem_rclk)
        ,.mem_wclk_rst_n      (rf_chp_lsp_tok_fifo_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_chp_lsp_tok_fifo_mem_rclk_rst_n)
        ,.mem_re              (rf_chp_lsp_tok_fifo_mem_re)
        ,.mem_raddr           (rf_chp_lsp_tok_fifo_mem_raddr)
        ,.mem_waddr           (rf_chp_lsp_tok_fifo_mem_waddr)
        ,.mem_we              (rf_chp_lsp_tok_fifo_mem_we)
        ,.mem_wdata           (rf_chp_lsp_tok_fifo_mem_wdata)
        ,.mem_rdata           (rf_chp_lsp_tok_fifo_mem_rdata)

        ,.mem_rdata_error     (rf_chp_lsp_tok_fifo_mem_rdata_error)
        ,.error               (rf_chp_lsp_tok_fifo_mem_error)
);

logic        rf_chp_sys_tx_fifo_mem_rdata_error;

logic        cfg_mem_ack_chp_sys_tx_fifo_mem_nc;
logic [31:0] cfg_mem_rdata_chp_sys_tx_fifo_mem_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (8)
        ,.DWIDTH              (200)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_chp_sys_tx_fifo_mem (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_chp_sys_tx_fifo_mem_re)
        ,.func_mem_raddr      (func_chp_sys_tx_fifo_mem_raddr)
        ,.func_mem_waddr      (func_chp_sys_tx_fifo_mem_waddr)
        ,.func_mem_we         (func_chp_sys_tx_fifo_mem_we)
        ,.func_mem_wdata      (func_chp_sys_tx_fifo_mem_wdata)
        ,.func_mem_rdata      (func_chp_sys_tx_fifo_mem_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_chp_sys_tx_fifo_mem_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_chp_sys_tx_fifo_mem_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_chp_sys_tx_fifo_mem_re)
        ,.pf_mem_raddr        (pf_chp_sys_tx_fifo_mem_raddr)
        ,.pf_mem_waddr        (pf_chp_sys_tx_fifo_mem_waddr)
        ,.pf_mem_we           (pf_chp_sys_tx_fifo_mem_we)
        ,.pf_mem_wdata        (pf_chp_sys_tx_fifo_mem_wdata)
        ,.pf_mem_rdata        (pf_chp_sys_tx_fifo_mem_rdata)

        ,.mem_wclk            (rf_chp_sys_tx_fifo_mem_wclk)
        ,.mem_rclk            (rf_chp_sys_tx_fifo_mem_rclk)
        ,.mem_wclk_rst_n      (rf_chp_sys_tx_fifo_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_chp_sys_tx_fifo_mem_rclk_rst_n)
        ,.mem_re              (rf_chp_sys_tx_fifo_mem_re)
        ,.mem_raddr           (rf_chp_sys_tx_fifo_mem_raddr)
        ,.mem_waddr           (rf_chp_sys_tx_fifo_mem_waddr)
        ,.mem_we              (rf_chp_sys_tx_fifo_mem_we)
        ,.mem_wdata           (rf_chp_sys_tx_fifo_mem_wdata)
        ,.mem_rdata           (rf_chp_sys_tx_fifo_mem_rdata)

        ,.mem_rdata_error     (rf_chp_sys_tx_fifo_mem_rdata_error)
        ,.error               (rf_chp_sys_tx_fifo_mem_error)
);

logic        rf_cmp_id_chk_enbl_mem_rdata_error;

hqm_AW_rfw_access #( 
         .DEPTH               (64)
        ,.DWIDTH              (2)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_cmp_id_chk_enbl_mem (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_cmp_id_chk_enbl_mem_re)
        ,.func_mem_raddr      (func_cmp_id_chk_enbl_mem_raddr)
        ,.func_mem_waddr      (func_cmp_id_chk_enbl_mem_waddr)
        ,.func_mem_we         (func_cmp_id_chk_enbl_mem_we)
        ,.func_mem_wdata      (func_cmp_id_chk_enbl_mem_wdata)
        ,.func_mem_rdata      (func_cmp_id_chk_enbl_mem_rdata)

        ,.cfg_mem_re          (cfg_mem_re[(10 * 1) +: 1])
        ,.cfg_mem_we          (cfg_mem_we[(10 * 1) +: 1])
        ,.cfg_mem_addr        (cfg_mem_addr)
        ,.cfg_mem_minbit      (cfg_mem_minbit)
        ,.cfg_mem_maxbit      (cfg_mem_maxbit)
        ,.cfg_mem_wdata       (cfg_mem_wdata)
        ,.cfg_mem_rdata       (cfg_mem_rdata[(10 * 32) +: 32])
        ,.cfg_mem_ack         (cfg_mem_ack[  (10 *  1) +:  1])
        ,.cfg_mem_cc_v        (cfg_mem_cc_v)
        ,.cfg_mem_cc_value    (cfg_mem_cc_value)
        ,.cfg_mem_cc_width    (cfg_mem_cc_width)
        ,.cfg_mem_cc_position (cfg_mem_cc_position)

        ,.pf_mem_re           (pf_cmp_id_chk_enbl_mem_re)
        ,.pf_mem_raddr        (pf_cmp_id_chk_enbl_mem_raddr)
        ,.pf_mem_waddr        (pf_cmp_id_chk_enbl_mem_waddr)
        ,.pf_mem_we           (pf_cmp_id_chk_enbl_mem_we)
        ,.pf_mem_wdata        (pf_cmp_id_chk_enbl_mem_wdata)
        ,.pf_mem_rdata        (pf_cmp_id_chk_enbl_mem_rdata)

        ,.mem_wclk            (rf_cmp_id_chk_enbl_mem_wclk)
        ,.mem_rclk            (rf_cmp_id_chk_enbl_mem_rclk)
        ,.mem_wclk_rst_n      (rf_cmp_id_chk_enbl_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_cmp_id_chk_enbl_mem_rclk_rst_n)
        ,.mem_re              (rf_cmp_id_chk_enbl_mem_re)
        ,.mem_raddr           (rf_cmp_id_chk_enbl_mem_raddr)
        ,.mem_waddr           (rf_cmp_id_chk_enbl_mem_waddr)
        ,.mem_we              (rf_cmp_id_chk_enbl_mem_we)
        ,.mem_wdata           (rf_cmp_id_chk_enbl_mem_wdata)
        ,.mem_rdata           (rf_cmp_id_chk_enbl_mem_rdata)

        ,.mem_rdata_error     (rf_cmp_id_chk_enbl_mem_rdata_error)
        ,.error               (rf_cmp_id_chk_enbl_mem_error)
);

logic        rf_count_rmw_pipe_dir_mem_rdata_error;

hqm_AW_rfw_access #( 
         .DEPTH               (64)
        ,.DWIDTH              (16)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_count_rmw_pipe_dir_mem (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_count_rmw_pipe_dir_mem_re)
        ,.func_mem_raddr      (func_count_rmw_pipe_dir_mem_raddr)
        ,.func_mem_waddr      (func_count_rmw_pipe_dir_mem_waddr)
        ,.func_mem_we         (func_count_rmw_pipe_dir_mem_we)
        ,.func_mem_wdata      (func_count_rmw_pipe_dir_mem_wdata)
        ,.func_mem_rdata      (func_count_rmw_pipe_dir_mem_rdata)

        ,.cfg_mem_re          (cfg_mem_re[(11 * 1) +: 1])
        ,.cfg_mem_we          (cfg_mem_we[(11 * 1) +: 1])
        ,.cfg_mem_addr        (cfg_mem_addr)
        ,.cfg_mem_minbit      (cfg_mem_minbit)
        ,.cfg_mem_maxbit      (cfg_mem_maxbit)
        ,.cfg_mem_wdata       (cfg_mem_wdata)
        ,.cfg_mem_rdata       (cfg_mem_rdata[(11 * 32) +: 32])
        ,.cfg_mem_ack         (cfg_mem_ack[  (11 *  1) +:  1])
        ,.cfg_mem_cc_v        (cfg_mem_cc_v)
        ,.cfg_mem_cc_value    (cfg_mem_cc_value)
        ,.cfg_mem_cc_width    (cfg_mem_cc_width)
        ,.cfg_mem_cc_position (cfg_mem_cc_position)

        ,.pf_mem_re           (pf_count_rmw_pipe_dir_mem_re)
        ,.pf_mem_raddr        (pf_count_rmw_pipe_dir_mem_raddr)
        ,.pf_mem_waddr        (pf_count_rmw_pipe_dir_mem_waddr)
        ,.pf_mem_we           (pf_count_rmw_pipe_dir_mem_we)
        ,.pf_mem_wdata        (pf_count_rmw_pipe_dir_mem_wdata)
        ,.pf_mem_rdata        (pf_count_rmw_pipe_dir_mem_rdata)

        ,.mem_wclk            (rf_count_rmw_pipe_dir_mem_wclk)
        ,.mem_rclk            (rf_count_rmw_pipe_dir_mem_rclk)
        ,.mem_wclk_rst_n      (rf_count_rmw_pipe_dir_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_count_rmw_pipe_dir_mem_rclk_rst_n)
        ,.mem_re              (rf_count_rmw_pipe_dir_mem_re)
        ,.mem_raddr           (rf_count_rmw_pipe_dir_mem_raddr)
        ,.mem_waddr           (rf_count_rmw_pipe_dir_mem_waddr)
        ,.mem_we              (rf_count_rmw_pipe_dir_mem_we)
        ,.mem_wdata           (rf_count_rmw_pipe_dir_mem_wdata)
        ,.mem_rdata           (rf_count_rmw_pipe_dir_mem_rdata)

        ,.mem_rdata_error     (rf_count_rmw_pipe_dir_mem_rdata_error)
        ,.error               (rf_count_rmw_pipe_dir_mem_error)
);

logic        rf_count_rmw_pipe_ldb_mem_rdata_error;

hqm_AW_rfw_access #( 
         .DEPTH               (64)
        ,.DWIDTH              (16)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_count_rmw_pipe_ldb_mem (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_count_rmw_pipe_ldb_mem_re)
        ,.func_mem_raddr      (func_count_rmw_pipe_ldb_mem_raddr)
        ,.func_mem_waddr      (func_count_rmw_pipe_ldb_mem_waddr)
        ,.func_mem_we         (func_count_rmw_pipe_ldb_mem_we)
        ,.func_mem_wdata      (func_count_rmw_pipe_ldb_mem_wdata)
        ,.func_mem_rdata      (func_count_rmw_pipe_ldb_mem_rdata)

        ,.cfg_mem_re          (cfg_mem_re[(12 * 1) +: 1])
        ,.cfg_mem_we          (cfg_mem_we[(12 * 1) +: 1])
        ,.cfg_mem_addr        (cfg_mem_addr)
        ,.cfg_mem_minbit      (cfg_mem_minbit)
        ,.cfg_mem_maxbit      (cfg_mem_maxbit)
        ,.cfg_mem_wdata       (cfg_mem_wdata)
        ,.cfg_mem_rdata       (cfg_mem_rdata[(12 * 32) +: 32])
        ,.cfg_mem_ack         (cfg_mem_ack[  (12 *  1) +:  1])
        ,.cfg_mem_cc_v        (cfg_mem_cc_v)
        ,.cfg_mem_cc_value    (cfg_mem_cc_value)
        ,.cfg_mem_cc_width    (cfg_mem_cc_width)
        ,.cfg_mem_cc_position (cfg_mem_cc_position)

        ,.pf_mem_re           (pf_count_rmw_pipe_ldb_mem_re)
        ,.pf_mem_raddr        (pf_count_rmw_pipe_ldb_mem_raddr)
        ,.pf_mem_waddr        (pf_count_rmw_pipe_ldb_mem_waddr)
        ,.pf_mem_we           (pf_count_rmw_pipe_ldb_mem_we)
        ,.pf_mem_wdata        (pf_count_rmw_pipe_ldb_mem_wdata)
        ,.pf_mem_rdata        (pf_count_rmw_pipe_ldb_mem_rdata)

        ,.mem_wclk            (rf_count_rmw_pipe_ldb_mem_wclk)
        ,.mem_rclk            (rf_count_rmw_pipe_ldb_mem_rclk)
        ,.mem_wclk_rst_n      (rf_count_rmw_pipe_ldb_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_count_rmw_pipe_ldb_mem_rclk_rst_n)
        ,.mem_re              (rf_count_rmw_pipe_ldb_mem_re)
        ,.mem_raddr           (rf_count_rmw_pipe_ldb_mem_raddr)
        ,.mem_waddr           (rf_count_rmw_pipe_ldb_mem_waddr)
        ,.mem_we              (rf_count_rmw_pipe_ldb_mem_we)
        ,.mem_wdata           (rf_count_rmw_pipe_ldb_mem_wdata)
        ,.mem_rdata           (rf_count_rmw_pipe_ldb_mem_rdata)

        ,.mem_rdata_error     (rf_count_rmw_pipe_ldb_mem_rdata_error)
        ,.error               (rf_count_rmw_pipe_ldb_mem_error)
);

logic        cfg_mem_ack_count_rmw_pipe_wd_dir_mem_nc;
logic [31:0] cfg_mem_rdata_count_rmw_pipe_wd_dir_mem_nc;

hqm_chp_wd_rfw_async_access #( 
         .DEPTH               (64)
        ,.DWIDTH              (10)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
) i_count_rmw_pipe_wd_dir_mem (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.mem_clk             (hqm_pgcb_clk)
        ,.mem_rst_n           (hqm_pgcb_rst_n)

        ,.func_mem_re         (func_count_rmw_pipe_wd_dir_mem_re)
        ,.func_mem_raddr      (func_count_rmw_pipe_wd_dir_mem_raddr)
        ,.func_mem_waddr      (func_count_rmw_pipe_wd_dir_mem_waddr)
        ,.func_mem_we         (func_count_rmw_pipe_wd_dir_mem_we)
        ,.func_mem_wdata      (func_count_rmw_pipe_wd_dir_mem_wdata)
        ,.func_mem_rdata      (func_count_rmw_pipe_wd_dir_mem_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_count_rmw_pipe_wd_dir_mem_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_count_rmw_pipe_wd_dir_mem_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_count_rmw_pipe_wd_dir_mem_re)
        ,.pf_mem_raddr        (pf_count_rmw_pipe_wd_dir_mem_raddr)
        ,.pf_mem_waddr        (pf_count_rmw_pipe_wd_dir_mem_waddr)
        ,.pf_mem_we           (pf_count_rmw_pipe_wd_dir_mem_we)
        ,.pf_mem_wdata        (pf_count_rmw_pipe_wd_dir_mem_wdata)
        ,.pf_mem_rdata        (pf_count_rmw_pipe_wd_dir_mem_rdata)

        ,.mem_wclk            (rf_count_rmw_pipe_wd_dir_mem_wclk)
        ,.mem_rclk            (rf_count_rmw_pipe_wd_dir_mem_rclk)
        ,.mem_wclk_rst_n      (rf_count_rmw_pipe_wd_dir_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_count_rmw_pipe_wd_dir_mem_rclk_rst_n)
        ,.mem_re              (rf_count_rmw_pipe_wd_dir_mem_re)
        ,.mem_raddr           (rf_count_rmw_pipe_wd_dir_mem_raddr)
        ,.mem_waddr           (rf_count_rmw_pipe_wd_dir_mem_waddr)
        ,.mem_we              (rf_count_rmw_pipe_wd_dir_mem_we)
        ,.mem_wdata           (rf_count_rmw_pipe_wd_dir_mem_wdata)
        ,.mem_rdata           (rf_count_rmw_pipe_wd_dir_mem_rdata)

        ,.error               (rf_count_rmw_pipe_wd_dir_mem_error)
);

logic        cfg_mem_ack_count_rmw_pipe_wd_ldb_mem_nc;
logic [31:0] cfg_mem_rdata_count_rmw_pipe_wd_ldb_mem_nc;

hqm_chp_wd_rfw_async_access #( 
         .DEPTH               (64)
        ,.DWIDTH              (10)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
) i_count_rmw_pipe_wd_ldb_mem (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.mem_clk             (hqm_pgcb_clk)
        ,.mem_rst_n           (hqm_pgcb_rst_n)

        ,.func_mem_re         (func_count_rmw_pipe_wd_ldb_mem_re)
        ,.func_mem_raddr      (func_count_rmw_pipe_wd_ldb_mem_raddr)
        ,.func_mem_waddr      (func_count_rmw_pipe_wd_ldb_mem_waddr)
        ,.func_mem_we         (func_count_rmw_pipe_wd_ldb_mem_we)
        ,.func_mem_wdata      (func_count_rmw_pipe_wd_ldb_mem_wdata)
        ,.func_mem_rdata      (func_count_rmw_pipe_wd_ldb_mem_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_count_rmw_pipe_wd_ldb_mem_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_count_rmw_pipe_wd_ldb_mem_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_count_rmw_pipe_wd_ldb_mem_re)
        ,.pf_mem_raddr        (pf_count_rmw_pipe_wd_ldb_mem_raddr)
        ,.pf_mem_waddr        (pf_count_rmw_pipe_wd_ldb_mem_waddr)
        ,.pf_mem_we           (pf_count_rmw_pipe_wd_ldb_mem_we)
        ,.pf_mem_wdata        (pf_count_rmw_pipe_wd_ldb_mem_wdata)
        ,.pf_mem_rdata        (pf_count_rmw_pipe_wd_ldb_mem_rdata)

        ,.mem_wclk            (rf_count_rmw_pipe_wd_ldb_mem_wclk)
        ,.mem_rclk            (rf_count_rmw_pipe_wd_ldb_mem_rclk)
        ,.mem_wclk_rst_n      (rf_count_rmw_pipe_wd_ldb_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_count_rmw_pipe_wd_ldb_mem_rclk_rst_n)
        ,.mem_re              (rf_count_rmw_pipe_wd_ldb_mem_re)
        ,.mem_raddr           (rf_count_rmw_pipe_wd_ldb_mem_raddr)
        ,.mem_waddr           (rf_count_rmw_pipe_wd_ldb_mem_waddr)
        ,.mem_we              (rf_count_rmw_pipe_wd_ldb_mem_we)
        ,.mem_wdata           (rf_count_rmw_pipe_wd_ldb_mem_wdata)
        ,.mem_rdata           (rf_count_rmw_pipe_wd_ldb_mem_rdata)

        ,.error               (rf_count_rmw_pipe_wd_ldb_mem_error)
);

logic        rf_dir_cq_depth_rdata_error;

hqm_AW_rfw_access #( 
         .DEPTH               (64)
        ,.DWIDTH              (13)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_dir_cq_depth (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_dir_cq_depth_re)
        ,.func_mem_raddr      (func_dir_cq_depth_raddr)
        ,.func_mem_waddr      (func_dir_cq_depth_waddr)
        ,.func_mem_we         (func_dir_cq_depth_we)
        ,.func_mem_wdata      (func_dir_cq_depth_wdata)
        ,.func_mem_rdata      (func_dir_cq_depth_rdata)

        ,.cfg_mem_re          (cfg_mem_re[(13 * 1) +: 1])
        ,.cfg_mem_we          (cfg_mem_we[(13 * 1) +: 1])
        ,.cfg_mem_addr        (cfg_mem_addr)
        ,.cfg_mem_minbit      (cfg_mem_minbit)
        ,.cfg_mem_maxbit      (cfg_mem_maxbit)
        ,.cfg_mem_wdata       (cfg_mem_wdata)
        ,.cfg_mem_rdata       (cfg_mem_rdata[(13 * 32) +: 32])
        ,.cfg_mem_ack         (cfg_mem_ack[  (13 *  1) +:  1])
        ,.cfg_mem_cc_v        (cfg_mem_cc_v)
        ,.cfg_mem_cc_value    (cfg_mem_cc_value)
        ,.cfg_mem_cc_width    (cfg_mem_cc_width)
        ,.cfg_mem_cc_position (cfg_mem_cc_position)

        ,.pf_mem_re           (pf_dir_cq_depth_re)
        ,.pf_mem_raddr        (pf_dir_cq_depth_raddr)
        ,.pf_mem_waddr        (pf_dir_cq_depth_waddr)
        ,.pf_mem_we           (pf_dir_cq_depth_we)
        ,.pf_mem_wdata        (pf_dir_cq_depth_wdata)
        ,.pf_mem_rdata        (pf_dir_cq_depth_rdata)

        ,.mem_wclk            (rf_dir_cq_depth_wclk)
        ,.mem_rclk            (rf_dir_cq_depth_rclk)
        ,.mem_wclk_rst_n      (rf_dir_cq_depth_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_dir_cq_depth_rclk_rst_n)
        ,.mem_re              (rf_dir_cq_depth_re)
        ,.mem_raddr           (rf_dir_cq_depth_raddr)
        ,.mem_waddr           (rf_dir_cq_depth_waddr)
        ,.mem_we              (rf_dir_cq_depth_we)
        ,.mem_wdata           (rf_dir_cq_depth_wdata)
        ,.mem_rdata           (rf_dir_cq_depth_rdata)

        ,.mem_rdata_error     (rf_dir_cq_depth_rdata_error)
        ,.error               (rf_dir_cq_depth_error)
);

logic        rf_dir_cq_intr_thresh_rdata_error;

hqm_AW_rfw_access #( 
         .DEPTH               (64)
        ,.DWIDTH              (15)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_dir_cq_intr_thresh (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_dir_cq_intr_thresh_re)
        ,.func_mem_raddr      (func_dir_cq_intr_thresh_raddr)
        ,.func_mem_waddr      (func_dir_cq_intr_thresh_waddr)
        ,.func_mem_we         (func_dir_cq_intr_thresh_we)
        ,.func_mem_wdata      (func_dir_cq_intr_thresh_wdata)
        ,.func_mem_rdata      (func_dir_cq_intr_thresh_rdata)

        ,.cfg_mem_re          (cfg_mem_re[(14 * 1) +: 1])
        ,.cfg_mem_we          (cfg_mem_we[(14 * 1) +: 1])
        ,.cfg_mem_addr        (cfg_mem_addr)
        ,.cfg_mem_minbit      (cfg_mem_minbit)
        ,.cfg_mem_maxbit      (cfg_mem_maxbit)
        ,.cfg_mem_wdata       (cfg_mem_wdata)
        ,.cfg_mem_rdata       (cfg_mem_rdata[(14 * 32) +: 32])
        ,.cfg_mem_ack         (cfg_mem_ack[  (14 *  1) +:  1])
        ,.cfg_mem_cc_v        (cfg_mem_cc_v)
        ,.cfg_mem_cc_value    (cfg_mem_cc_value)
        ,.cfg_mem_cc_width    (cfg_mem_cc_width)
        ,.cfg_mem_cc_position (cfg_mem_cc_position)

        ,.pf_mem_re           (pf_dir_cq_intr_thresh_re)
        ,.pf_mem_raddr        (pf_dir_cq_intr_thresh_raddr)
        ,.pf_mem_waddr        (pf_dir_cq_intr_thresh_waddr)
        ,.pf_mem_we           (pf_dir_cq_intr_thresh_we)
        ,.pf_mem_wdata        (pf_dir_cq_intr_thresh_wdata)
        ,.pf_mem_rdata        (pf_dir_cq_intr_thresh_rdata)

        ,.mem_wclk            (rf_dir_cq_intr_thresh_wclk)
        ,.mem_rclk            (rf_dir_cq_intr_thresh_rclk)
        ,.mem_wclk_rst_n      (rf_dir_cq_intr_thresh_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_dir_cq_intr_thresh_rclk_rst_n)
        ,.mem_re              (rf_dir_cq_intr_thresh_re)
        ,.mem_raddr           (rf_dir_cq_intr_thresh_raddr)
        ,.mem_waddr           (rf_dir_cq_intr_thresh_waddr)
        ,.mem_we              (rf_dir_cq_intr_thresh_we)
        ,.mem_wdata           (rf_dir_cq_intr_thresh_wdata)
        ,.mem_rdata           (rf_dir_cq_intr_thresh_rdata)

        ,.mem_rdata_error     (rf_dir_cq_intr_thresh_rdata_error)
        ,.error               (rf_dir_cq_intr_thresh_error)
);

logic        rf_dir_cq_token_depth_select_rdata_error;

hqm_AW_rfw_access #( 
         .DEPTH               (64)
        ,.DWIDTH              (6)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_dir_cq_token_depth_select (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_dir_cq_token_depth_select_re)
        ,.func_mem_raddr      (func_dir_cq_token_depth_select_raddr)
        ,.func_mem_waddr      (func_dir_cq_token_depth_select_waddr)
        ,.func_mem_we         (func_dir_cq_token_depth_select_we)
        ,.func_mem_wdata      (func_dir_cq_token_depth_select_wdata)
        ,.func_mem_rdata      (func_dir_cq_token_depth_select_rdata)

        ,.cfg_mem_re          (cfg_mem_re[(15 * 1) +: 1])
        ,.cfg_mem_we          (cfg_mem_we[(15 * 1) +: 1])
        ,.cfg_mem_addr        (cfg_mem_addr)
        ,.cfg_mem_minbit      (cfg_mem_minbit)
        ,.cfg_mem_maxbit      (cfg_mem_maxbit)
        ,.cfg_mem_wdata       (cfg_mem_wdata)
        ,.cfg_mem_rdata       (cfg_mem_rdata[(15 * 32) +: 32])
        ,.cfg_mem_ack         (cfg_mem_ack[  (15 *  1) +:  1])
        ,.cfg_mem_cc_v        (cfg_mem_cc_v)
        ,.cfg_mem_cc_value    (cfg_mem_cc_value)
        ,.cfg_mem_cc_width    (cfg_mem_cc_width)
        ,.cfg_mem_cc_position (cfg_mem_cc_position)

        ,.pf_mem_re           (pf_dir_cq_token_depth_select_re)
        ,.pf_mem_raddr        (pf_dir_cq_token_depth_select_raddr)
        ,.pf_mem_waddr        (pf_dir_cq_token_depth_select_waddr)
        ,.pf_mem_we           (pf_dir_cq_token_depth_select_we)
        ,.pf_mem_wdata        (pf_dir_cq_token_depth_select_wdata)
        ,.pf_mem_rdata        (pf_dir_cq_token_depth_select_rdata)

        ,.mem_wclk            (rf_dir_cq_token_depth_select_wclk)
        ,.mem_rclk            (rf_dir_cq_token_depth_select_rclk)
        ,.mem_wclk_rst_n      (rf_dir_cq_token_depth_select_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_dir_cq_token_depth_select_rclk_rst_n)
        ,.mem_re              (rf_dir_cq_token_depth_select_re)
        ,.mem_raddr           (rf_dir_cq_token_depth_select_raddr)
        ,.mem_waddr           (rf_dir_cq_token_depth_select_waddr)
        ,.mem_we              (rf_dir_cq_token_depth_select_we)
        ,.mem_wdata           (rf_dir_cq_token_depth_select_wdata)
        ,.mem_rdata           (rf_dir_cq_token_depth_select_rdata)

        ,.mem_rdata_error     (rf_dir_cq_token_depth_select_rdata_error)
        ,.error               (rf_dir_cq_token_depth_select_error)
);

logic        rf_dir_cq_wptr_rdata_error;

hqm_AW_rfw_access #( 
         .DEPTH               (64)
        ,.DWIDTH              (13)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_dir_cq_wptr (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_dir_cq_wptr_re)
        ,.func_mem_raddr      (func_dir_cq_wptr_raddr)
        ,.func_mem_waddr      (func_dir_cq_wptr_waddr)
        ,.func_mem_we         (func_dir_cq_wptr_we)
        ,.func_mem_wdata      (func_dir_cq_wptr_wdata)
        ,.func_mem_rdata      (func_dir_cq_wptr_rdata)

        ,.cfg_mem_re          (cfg_mem_re[(16 * 1) +: 1])
        ,.cfg_mem_we          (cfg_mem_we[(16 * 1) +: 1])
        ,.cfg_mem_addr        (cfg_mem_addr)
        ,.cfg_mem_minbit      (cfg_mem_minbit)
        ,.cfg_mem_maxbit      (cfg_mem_maxbit)
        ,.cfg_mem_wdata       (cfg_mem_wdata)
        ,.cfg_mem_rdata       (cfg_mem_rdata[(16 * 32) +: 32])
        ,.cfg_mem_ack         (cfg_mem_ack[  (16 *  1) +:  1])
        ,.cfg_mem_cc_v        (cfg_mem_cc_v)
        ,.cfg_mem_cc_value    (cfg_mem_cc_value)
        ,.cfg_mem_cc_width    (cfg_mem_cc_width)
        ,.cfg_mem_cc_position (cfg_mem_cc_position)

        ,.pf_mem_re           (pf_dir_cq_wptr_re)
        ,.pf_mem_raddr        (pf_dir_cq_wptr_raddr)
        ,.pf_mem_waddr        (pf_dir_cq_wptr_waddr)
        ,.pf_mem_we           (pf_dir_cq_wptr_we)
        ,.pf_mem_wdata        (pf_dir_cq_wptr_wdata)
        ,.pf_mem_rdata        (pf_dir_cq_wptr_rdata)

        ,.mem_wclk            (rf_dir_cq_wptr_wclk)
        ,.mem_rclk            (rf_dir_cq_wptr_rclk)
        ,.mem_wclk_rst_n      (rf_dir_cq_wptr_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_dir_cq_wptr_rclk_rst_n)
        ,.mem_re              (rf_dir_cq_wptr_re)
        ,.mem_raddr           (rf_dir_cq_wptr_raddr)
        ,.mem_waddr           (rf_dir_cq_wptr_waddr)
        ,.mem_we              (rf_dir_cq_wptr_we)
        ,.mem_wdata           (rf_dir_cq_wptr_wdata)
        ,.mem_rdata           (rf_dir_cq_wptr_rdata)

        ,.mem_rdata_error     (rf_dir_cq_wptr_rdata_error)
        ,.error               (rf_dir_cq_wptr_error)
);

logic        rf_hcw_enq_w_rx_sync_mem_rdata_error;

logic        cfg_mem_ack_hcw_enq_w_rx_sync_mem_nc;
logic [31:0] cfg_mem_rdata_hcw_enq_w_rx_sync_mem_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (16)
        ,.DWIDTH              (160)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_hcw_enq_w_rx_sync_mem (
         .clk                 (hqm_inp_gated_clk)
        ,.rst_n               (hqm_inp_gated_rst_n)

        ,.func_mem_re         (func_hcw_enq_w_rx_sync_mem_re)
        ,.func_mem_raddr      (func_hcw_enq_w_rx_sync_mem_raddr)
        ,.func_mem_waddr      (func_hcw_enq_w_rx_sync_mem_waddr)
        ,.func_mem_we         (func_hcw_enq_w_rx_sync_mem_we)
        ,.func_mem_wdata      (func_hcw_enq_w_rx_sync_mem_wdata)
        ,.func_mem_rdata      (func_hcw_enq_w_rx_sync_mem_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_hcw_enq_w_rx_sync_mem_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_hcw_enq_w_rx_sync_mem_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_hcw_enq_w_rx_sync_mem_re)
        ,.pf_mem_raddr        (pf_hcw_enq_w_rx_sync_mem_raddr)
        ,.pf_mem_waddr        (pf_hcw_enq_w_rx_sync_mem_waddr)
        ,.pf_mem_we           (pf_hcw_enq_w_rx_sync_mem_we)
        ,.pf_mem_wdata        (pf_hcw_enq_w_rx_sync_mem_wdata)
        ,.pf_mem_rdata        (pf_hcw_enq_w_rx_sync_mem_rdata)

        ,.mem_wclk            (rf_hcw_enq_w_rx_sync_mem_wclk)
        ,.mem_rclk            (rf_hcw_enq_w_rx_sync_mem_rclk)
        ,.mem_wclk_rst_n      (rf_hcw_enq_w_rx_sync_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_hcw_enq_w_rx_sync_mem_rclk_rst_n)
        ,.mem_re              (rf_hcw_enq_w_rx_sync_mem_re)
        ,.mem_raddr           (rf_hcw_enq_w_rx_sync_mem_raddr)
        ,.mem_waddr           (rf_hcw_enq_w_rx_sync_mem_waddr)
        ,.mem_we              (rf_hcw_enq_w_rx_sync_mem_we)
        ,.mem_wdata           (rf_hcw_enq_w_rx_sync_mem_wdata)
        ,.mem_rdata           (rf_hcw_enq_w_rx_sync_mem_rdata)

        ,.mem_rdata_error     (rf_hcw_enq_w_rx_sync_mem_rdata_error)
        ,.error               (rf_hcw_enq_w_rx_sync_mem_error)
);

logic        rf_hist_list_a_minmax_rdata_error;

hqm_AW_rfrw_access #( 
         .DEPTH               (64)
        ,.DWIDTH              (30)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_hist_list_a_minmax (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_hist_list_a_minmax_re)
        ,.func_mem_addr       (func_hist_list_a_minmax_addr)
        ,.func_mem_we         (func_hist_list_a_minmax_we)
        ,.func_mem_wdata      (func_hist_list_a_minmax_wdata)
        ,.func_mem_rdata      (func_hist_list_a_minmax_rdata)

        ,.cfg_mem_re          (cfg_mem_re[(17 * 1) +: 1])
        ,.cfg_mem_we          (cfg_mem_we[(17 * 1) +: 1])
        ,.cfg_mem_addr        (cfg_mem_addr)
        ,.cfg_mem_minbit      (cfg_mem_minbit)
        ,.cfg_mem_maxbit      (cfg_mem_maxbit)
        ,.cfg_mem_wdata       (cfg_mem_wdata)
        ,.cfg_mem_rdata       (cfg_mem_rdata[(17 * 32) +: 32])
        ,.cfg_mem_ack         (cfg_mem_ack[  (17 *  1) +:  1])
        ,.cfg_mem_cc_v        (cfg_mem_cc_v)
        ,.cfg_mem_cc_value    (cfg_mem_cc_value)
        ,.cfg_mem_cc_width    (cfg_mem_cc_width)
        ,.cfg_mem_cc_position (cfg_mem_cc_position)

        ,.pf_mem_re           (pf_hist_list_a_minmax_re)
        ,.pf_mem_addr         (pf_hist_list_a_minmax_addr)
        ,.pf_mem_we           (pf_hist_list_a_minmax_we)
        ,.pf_mem_wdata        (pf_hist_list_a_minmax_wdata)
        ,.pf_mem_rdata        (pf_hist_list_a_minmax_rdata)

        ,.mem_wclk            (rf_hist_list_a_minmax_wclk)
        ,.mem_rclk            (rf_hist_list_a_minmax_rclk)
        ,.mem_wclk_rst_n      (rf_hist_list_a_minmax_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_hist_list_a_minmax_rclk_rst_n)
        ,.mem_re              (rf_hist_list_a_minmax_re)
        ,.mem_raddr           (rf_hist_list_a_minmax_raddr)
        ,.mem_waddr           (rf_hist_list_a_minmax_waddr)
        ,.mem_we              (rf_hist_list_a_minmax_we)
        ,.mem_wdata           (rf_hist_list_a_minmax_wdata)
        ,.mem_rdata           (rf_hist_list_a_minmax_rdata)

        ,.mem_rdata_error     (rf_hist_list_a_minmax_rdata_error)
        ,.error               (rf_hist_list_a_minmax_error)
);

logic        rf_hist_list_a_ptr_rdata_error;

hqm_AW_rfw_access #( 
         .DEPTH               (64)
        ,.DWIDTH              (32)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_hist_list_a_ptr (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_hist_list_a_ptr_re)
        ,.func_mem_raddr      (func_hist_list_a_ptr_raddr)
        ,.func_mem_waddr      (func_hist_list_a_ptr_waddr)
        ,.func_mem_we         (func_hist_list_a_ptr_we)
        ,.func_mem_wdata      (func_hist_list_a_ptr_wdata)
        ,.func_mem_rdata      (func_hist_list_a_ptr_rdata)

        ,.cfg_mem_re          (cfg_mem_re[(18 * 1) +: 1])
        ,.cfg_mem_we          (cfg_mem_we[(18 * 1) +: 1])
        ,.cfg_mem_addr        (cfg_mem_addr)
        ,.cfg_mem_minbit      (cfg_mem_minbit)
        ,.cfg_mem_maxbit      (cfg_mem_maxbit)
        ,.cfg_mem_wdata       (cfg_mem_wdata)
        ,.cfg_mem_rdata       (cfg_mem_rdata[(18 * 32) +: 32])
        ,.cfg_mem_ack         (cfg_mem_ack[  (18 *  1) +:  1])
        ,.cfg_mem_cc_v        (cfg_mem_cc_v)
        ,.cfg_mem_cc_value    (cfg_mem_cc_value)
        ,.cfg_mem_cc_width    (cfg_mem_cc_width)
        ,.cfg_mem_cc_position (cfg_mem_cc_position)

        ,.pf_mem_re           (pf_hist_list_a_ptr_re)
        ,.pf_mem_raddr        (pf_hist_list_a_ptr_raddr)
        ,.pf_mem_waddr        (pf_hist_list_a_ptr_waddr)
        ,.pf_mem_we           (pf_hist_list_a_ptr_we)
        ,.pf_mem_wdata        (pf_hist_list_a_ptr_wdata)
        ,.pf_mem_rdata        (pf_hist_list_a_ptr_rdata)

        ,.mem_wclk            (rf_hist_list_a_ptr_wclk)
        ,.mem_rclk            (rf_hist_list_a_ptr_rclk)
        ,.mem_wclk_rst_n      (rf_hist_list_a_ptr_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_hist_list_a_ptr_rclk_rst_n)
        ,.mem_re              (rf_hist_list_a_ptr_re)
        ,.mem_raddr           (rf_hist_list_a_ptr_raddr)
        ,.mem_waddr           (rf_hist_list_a_ptr_waddr)
        ,.mem_we              (rf_hist_list_a_ptr_we)
        ,.mem_wdata           (rf_hist_list_a_ptr_wdata)
        ,.mem_rdata           (rf_hist_list_a_ptr_rdata)

        ,.mem_rdata_error     (rf_hist_list_a_ptr_rdata_error)
        ,.error               (rf_hist_list_a_ptr_error)
);

logic        rf_hist_list_minmax_rdata_error;

hqm_AW_rfrw_access #( 
         .DEPTH               (64)
        ,.DWIDTH              (30)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_hist_list_minmax (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_hist_list_minmax_re)
        ,.func_mem_addr       (func_hist_list_minmax_addr)
        ,.func_mem_we         (func_hist_list_minmax_we)
        ,.func_mem_wdata      (func_hist_list_minmax_wdata)
        ,.func_mem_rdata      (func_hist_list_minmax_rdata)

        ,.cfg_mem_re          (cfg_mem_re[(19 * 1) +: 1])
        ,.cfg_mem_we          (cfg_mem_we[(19 * 1) +: 1])
        ,.cfg_mem_addr        (cfg_mem_addr)
        ,.cfg_mem_minbit      (cfg_mem_minbit)
        ,.cfg_mem_maxbit      (cfg_mem_maxbit)
        ,.cfg_mem_wdata       (cfg_mem_wdata)
        ,.cfg_mem_rdata       (cfg_mem_rdata[(19 * 32) +: 32])
        ,.cfg_mem_ack         (cfg_mem_ack[  (19 *  1) +:  1])
        ,.cfg_mem_cc_v        (cfg_mem_cc_v)
        ,.cfg_mem_cc_value    (cfg_mem_cc_value)
        ,.cfg_mem_cc_width    (cfg_mem_cc_width)
        ,.cfg_mem_cc_position (cfg_mem_cc_position)

        ,.pf_mem_re           (pf_hist_list_minmax_re)
        ,.pf_mem_addr         (pf_hist_list_minmax_addr)
        ,.pf_mem_we           (pf_hist_list_minmax_we)
        ,.pf_mem_wdata        (pf_hist_list_minmax_wdata)
        ,.pf_mem_rdata        (pf_hist_list_minmax_rdata)

        ,.mem_wclk            (rf_hist_list_minmax_wclk)
        ,.mem_rclk            (rf_hist_list_minmax_rclk)
        ,.mem_wclk_rst_n      (rf_hist_list_minmax_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_hist_list_minmax_rclk_rst_n)
        ,.mem_re              (rf_hist_list_minmax_re)
        ,.mem_raddr           (rf_hist_list_minmax_raddr)
        ,.mem_waddr           (rf_hist_list_minmax_waddr)
        ,.mem_we              (rf_hist_list_minmax_we)
        ,.mem_wdata           (rf_hist_list_minmax_wdata)
        ,.mem_rdata           (rf_hist_list_minmax_rdata)

        ,.mem_rdata_error     (rf_hist_list_minmax_rdata_error)
        ,.error               (rf_hist_list_minmax_error)
);

logic        rf_hist_list_ptr_rdata_error;

hqm_AW_rfw_access #( 
         .DEPTH               (64)
        ,.DWIDTH              (32)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_hist_list_ptr (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_hist_list_ptr_re)
        ,.func_mem_raddr      (func_hist_list_ptr_raddr)
        ,.func_mem_waddr      (func_hist_list_ptr_waddr)
        ,.func_mem_we         (func_hist_list_ptr_we)
        ,.func_mem_wdata      (func_hist_list_ptr_wdata)
        ,.func_mem_rdata      (func_hist_list_ptr_rdata)

        ,.cfg_mem_re          (cfg_mem_re[(20 * 1) +: 1])
        ,.cfg_mem_we          (cfg_mem_we[(20 * 1) +: 1])
        ,.cfg_mem_addr        (cfg_mem_addr)
        ,.cfg_mem_minbit      (cfg_mem_minbit)
        ,.cfg_mem_maxbit      (cfg_mem_maxbit)
        ,.cfg_mem_wdata       (cfg_mem_wdata)
        ,.cfg_mem_rdata       (cfg_mem_rdata[(20 * 32) +: 32])
        ,.cfg_mem_ack         (cfg_mem_ack[  (20 *  1) +:  1])
        ,.cfg_mem_cc_v        (cfg_mem_cc_v)
        ,.cfg_mem_cc_value    (cfg_mem_cc_value)
        ,.cfg_mem_cc_width    (cfg_mem_cc_width)
        ,.cfg_mem_cc_position (cfg_mem_cc_position)

        ,.pf_mem_re           (pf_hist_list_ptr_re)
        ,.pf_mem_raddr        (pf_hist_list_ptr_raddr)
        ,.pf_mem_waddr        (pf_hist_list_ptr_waddr)
        ,.pf_mem_we           (pf_hist_list_ptr_we)
        ,.pf_mem_wdata        (pf_hist_list_ptr_wdata)
        ,.pf_mem_rdata        (pf_hist_list_ptr_rdata)

        ,.mem_wclk            (rf_hist_list_ptr_wclk)
        ,.mem_rclk            (rf_hist_list_ptr_rclk)
        ,.mem_wclk_rst_n      (rf_hist_list_ptr_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_hist_list_ptr_rclk_rst_n)
        ,.mem_re              (rf_hist_list_ptr_re)
        ,.mem_raddr           (rf_hist_list_ptr_raddr)
        ,.mem_waddr           (rf_hist_list_ptr_waddr)
        ,.mem_we              (rf_hist_list_ptr_we)
        ,.mem_wdata           (rf_hist_list_ptr_wdata)
        ,.mem_rdata           (rf_hist_list_ptr_rdata)

        ,.mem_rdata_error     (rf_hist_list_ptr_rdata_error)
        ,.error               (rf_hist_list_ptr_error)
);

logic        rf_ldb_cq_depth_rdata_error;

hqm_AW_rfw_access #( 
         .DEPTH               (64)
        ,.DWIDTH              (13)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_ldb_cq_depth (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_ldb_cq_depth_re)
        ,.func_mem_raddr      (func_ldb_cq_depth_raddr)
        ,.func_mem_waddr      (func_ldb_cq_depth_waddr)
        ,.func_mem_we         (func_ldb_cq_depth_we)
        ,.func_mem_wdata      (func_ldb_cq_depth_wdata)
        ,.func_mem_rdata      (func_ldb_cq_depth_rdata)

        ,.cfg_mem_re          (cfg_mem_re[(21 * 1) +: 1])
        ,.cfg_mem_we          (cfg_mem_we[(21 * 1) +: 1])
        ,.cfg_mem_addr        (cfg_mem_addr)
        ,.cfg_mem_minbit      (cfg_mem_minbit)
        ,.cfg_mem_maxbit      (cfg_mem_maxbit)
        ,.cfg_mem_wdata       (cfg_mem_wdata)
        ,.cfg_mem_rdata       (cfg_mem_rdata[(21 * 32) +: 32])
        ,.cfg_mem_ack         (cfg_mem_ack[  (21 *  1) +:  1])
        ,.cfg_mem_cc_v        (cfg_mem_cc_v)
        ,.cfg_mem_cc_value    (cfg_mem_cc_value)
        ,.cfg_mem_cc_width    (cfg_mem_cc_width)
        ,.cfg_mem_cc_position (cfg_mem_cc_position)

        ,.pf_mem_re           (pf_ldb_cq_depth_re)
        ,.pf_mem_raddr        (pf_ldb_cq_depth_raddr)
        ,.pf_mem_waddr        (pf_ldb_cq_depth_waddr)
        ,.pf_mem_we           (pf_ldb_cq_depth_we)
        ,.pf_mem_wdata        (pf_ldb_cq_depth_wdata)
        ,.pf_mem_rdata        (pf_ldb_cq_depth_rdata)

        ,.mem_wclk            (rf_ldb_cq_depth_wclk)
        ,.mem_rclk            (rf_ldb_cq_depth_rclk)
        ,.mem_wclk_rst_n      (rf_ldb_cq_depth_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_ldb_cq_depth_rclk_rst_n)
        ,.mem_re              (rf_ldb_cq_depth_re)
        ,.mem_raddr           (rf_ldb_cq_depth_raddr)
        ,.mem_waddr           (rf_ldb_cq_depth_waddr)
        ,.mem_we              (rf_ldb_cq_depth_we)
        ,.mem_wdata           (rf_ldb_cq_depth_wdata)
        ,.mem_rdata           (rf_ldb_cq_depth_rdata)

        ,.mem_rdata_error     (rf_ldb_cq_depth_rdata_error)
        ,.error               (rf_ldb_cq_depth_error)
);

logic        rf_ldb_cq_intr_thresh_rdata_error;

hqm_AW_rfw_access #( 
         .DEPTH               (64)
        ,.DWIDTH              (13)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_ldb_cq_intr_thresh (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_ldb_cq_intr_thresh_re)
        ,.func_mem_raddr      (func_ldb_cq_intr_thresh_raddr)
        ,.func_mem_waddr      (func_ldb_cq_intr_thresh_waddr)
        ,.func_mem_we         (func_ldb_cq_intr_thresh_we)
        ,.func_mem_wdata      (func_ldb_cq_intr_thresh_wdata)
        ,.func_mem_rdata      (func_ldb_cq_intr_thresh_rdata)

        ,.cfg_mem_re          (cfg_mem_re[(22 * 1) +: 1])
        ,.cfg_mem_we          (cfg_mem_we[(22 * 1) +: 1])
        ,.cfg_mem_addr        (cfg_mem_addr)
        ,.cfg_mem_minbit      (cfg_mem_minbit)
        ,.cfg_mem_maxbit      (cfg_mem_maxbit)
        ,.cfg_mem_wdata       (cfg_mem_wdata)
        ,.cfg_mem_rdata       (cfg_mem_rdata[(22 * 32) +: 32])
        ,.cfg_mem_ack         (cfg_mem_ack[  (22 *  1) +:  1])
        ,.cfg_mem_cc_v        (cfg_mem_cc_v)
        ,.cfg_mem_cc_value    (cfg_mem_cc_value)
        ,.cfg_mem_cc_width    (cfg_mem_cc_width)
        ,.cfg_mem_cc_position (cfg_mem_cc_position)

        ,.pf_mem_re           (pf_ldb_cq_intr_thresh_re)
        ,.pf_mem_raddr        (pf_ldb_cq_intr_thresh_raddr)
        ,.pf_mem_waddr        (pf_ldb_cq_intr_thresh_waddr)
        ,.pf_mem_we           (pf_ldb_cq_intr_thresh_we)
        ,.pf_mem_wdata        (pf_ldb_cq_intr_thresh_wdata)
        ,.pf_mem_rdata        (pf_ldb_cq_intr_thresh_rdata)

        ,.mem_wclk            (rf_ldb_cq_intr_thresh_wclk)
        ,.mem_rclk            (rf_ldb_cq_intr_thresh_rclk)
        ,.mem_wclk_rst_n      (rf_ldb_cq_intr_thresh_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_ldb_cq_intr_thresh_rclk_rst_n)
        ,.mem_re              (rf_ldb_cq_intr_thresh_re)
        ,.mem_raddr           (rf_ldb_cq_intr_thresh_raddr)
        ,.mem_waddr           (rf_ldb_cq_intr_thresh_waddr)
        ,.mem_we              (rf_ldb_cq_intr_thresh_we)
        ,.mem_wdata           (rf_ldb_cq_intr_thresh_wdata)
        ,.mem_rdata           (rf_ldb_cq_intr_thresh_rdata)

        ,.mem_rdata_error     (rf_ldb_cq_intr_thresh_rdata_error)
        ,.error               (rf_ldb_cq_intr_thresh_error)
);

logic        rf_ldb_cq_on_off_threshold_rdata_error;

hqm_AW_rfw_access #( 
         .DEPTH               (64)
        ,.DWIDTH              (32)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_ldb_cq_on_off_threshold (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_ldb_cq_on_off_threshold_re)
        ,.func_mem_raddr      (func_ldb_cq_on_off_threshold_raddr)
        ,.func_mem_waddr      (func_ldb_cq_on_off_threshold_waddr)
        ,.func_mem_we         (func_ldb_cq_on_off_threshold_we)
        ,.func_mem_wdata      (func_ldb_cq_on_off_threshold_wdata)
        ,.func_mem_rdata      (func_ldb_cq_on_off_threshold_rdata)

        ,.cfg_mem_re          (cfg_mem_re[(23 * 1) +: 1])
        ,.cfg_mem_we          (cfg_mem_we[(23 * 1) +: 1])
        ,.cfg_mem_addr        (cfg_mem_addr)
        ,.cfg_mem_minbit      (cfg_mem_minbit)
        ,.cfg_mem_maxbit      (cfg_mem_maxbit)
        ,.cfg_mem_wdata       (cfg_mem_wdata)
        ,.cfg_mem_rdata       (cfg_mem_rdata[(23 * 32) +: 32])
        ,.cfg_mem_ack         (cfg_mem_ack[  (23 *  1) +:  1])
        ,.cfg_mem_cc_v        (cfg_mem_cc_v)
        ,.cfg_mem_cc_value    (cfg_mem_cc_value)
        ,.cfg_mem_cc_width    (cfg_mem_cc_width)
        ,.cfg_mem_cc_position (cfg_mem_cc_position)

        ,.pf_mem_re           (pf_ldb_cq_on_off_threshold_re)
        ,.pf_mem_raddr        (pf_ldb_cq_on_off_threshold_raddr)
        ,.pf_mem_waddr        (pf_ldb_cq_on_off_threshold_waddr)
        ,.pf_mem_we           (pf_ldb_cq_on_off_threshold_we)
        ,.pf_mem_wdata        (pf_ldb_cq_on_off_threshold_wdata)
        ,.pf_mem_rdata        (pf_ldb_cq_on_off_threshold_rdata)

        ,.mem_wclk            (rf_ldb_cq_on_off_threshold_wclk)
        ,.mem_rclk            (rf_ldb_cq_on_off_threshold_rclk)
        ,.mem_wclk_rst_n      (rf_ldb_cq_on_off_threshold_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_ldb_cq_on_off_threshold_rclk_rst_n)
        ,.mem_re              (rf_ldb_cq_on_off_threshold_re)
        ,.mem_raddr           (rf_ldb_cq_on_off_threshold_raddr)
        ,.mem_waddr           (rf_ldb_cq_on_off_threshold_waddr)
        ,.mem_we              (rf_ldb_cq_on_off_threshold_we)
        ,.mem_wdata           (rf_ldb_cq_on_off_threshold_wdata)
        ,.mem_rdata           (rf_ldb_cq_on_off_threshold_rdata)

        ,.mem_rdata_error     (rf_ldb_cq_on_off_threshold_rdata_error)
        ,.error               (rf_ldb_cq_on_off_threshold_error)
);

logic        rf_ldb_cq_token_depth_select_rdata_error;

hqm_AW_rfw_access #( 
         .DEPTH               (64)
        ,.DWIDTH              (6)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_ldb_cq_token_depth_select (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_ldb_cq_token_depth_select_re)
        ,.func_mem_raddr      (func_ldb_cq_token_depth_select_raddr)
        ,.func_mem_waddr      (func_ldb_cq_token_depth_select_waddr)
        ,.func_mem_we         (func_ldb_cq_token_depth_select_we)
        ,.func_mem_wdata      (func_ldb_cq_token_depth_select_wdata)
        ,.func_mem_rdata      (func_ldb_cq_token_depth_select_rdata)

        ,.cfg_mem_re          (cfg_mem_re[(24 * 1) +: 1])
        ,.cfg_mem_we          (cfg_mem_we[(24 * 1) +: 1])
        ,.cfg_mem_addr        (cfg_mem_addr)
        ,.cfg_mem_minbit      (cfg_mem_minbit)
        ,.cfg_mem_maxbit      (cfg_mem_maxbit)
        ,.cfg_mem_wdata       (cfg_mem_wdata)
        ,.cfg_mem_rdata       (cfg_mem_rdata[(24 * 32) +: 32])
        ,.cfg_mem_ack         (cfg_mem_ack[  (24 *  1) +:  1])
        ,.cfg_mem_cc_v        (cfg_mem_cc_v)
        ,.cfg_mem_cc_value    (cfg_mem_cc_value)
        ,.cfg_mem_cc_width    (cfg_mem_cc_width)
        ,.cfg_mem_cc_position (cfg_mem_cc_position)

        ,.pf_mem_re           (pf_ldb_cq_token_depth_select_re)
        ,.pf_mem_raddr        (pf_ldb_cq_token_depth_select_raddr)
        ,.pf_mem_waddr        (pf_ldb_cq_token_depth_select_waddr)
        ,.pf_mem_we           (pf_ldb_cq_token_depth_select_we)
        ,.pf_mem_wdata        (pf_ldb_cq_token_depth_select_wdata)
        ,.pf_mem_rdata        (pf_ldb_cq_token_depth_select_rdata)

        ,.mem_wclk            (rf_ldb_cq_token_depth_select_wclk)
        ,.mem_rclk            (rf_ldb_cq_token_depth_select_rclk)
        ,.mem_wclk_rst_n      (rf_ldb_cq_token_depth_select_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_ldb_cq_token_depth_select_rclk_rst_n)
        ,.mem_re              (rf_ldb_cq_token_depth_select_re)
        ,.mem_raddr           (rf_ldb_cq_token_depth_select_raddr)
        ,.mem_waddr           (rf_ldb_cq_token_depth_select_waddr)
        ,.mem_we              (rf_ldb_cq_token_depth_select_we)
        ,.mem_wdata           (rf_ldb_cq_token_depth_select_wdata)
        ,.mem_rdata           (rf_ldb_cq_token_depth_select_rdata)

        ,.mem_rdata_error     (rf_ldb_cq_token_depth_select_rdata_error)
        ,.error               (rf_ldb_cq_token_depth_select_error)
);

logic        rf_ldb_cq_wptr_rdata_error;

hqm_AW_rfw_access #( 
         .DEPTH               (64)
        ,.DWIDTH              (13)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_ldb_cq_wptr (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_ldb_cq_wptr_re)
        ,.func_mem_raddr      (func_ldb_cq_wptr_raddr)
        ,.func_mem_waddr      (func_ldb_cq_wptr_waddr)
        ,.func_mem_we         (func_ldb_cq_wptr_we)
        ,.func_mem_wdata      (func_ldb_cq_wptr_wdata)
        ,.func_mem_rdata      (func_ldb_cq_wptr_rdata)

        ,.cfg_mem_re          (cfg_mem_re[(25 * 1) +: 1])
        ,.cfg_mem_we          (cfg_mem_we[(25 * 1) +: 1])
        ,.cfg_mem_addr        (cfg_mem_addr)
        ,.cfg_mem_minbit      (cfg_mem_minbit)
        ,.cfg_mem_maxbit      (cfg_mem_maxbit)
        ,.cfg_mem_wdata       (cfg_mem_wdata)
        ,.cfg_mem_rdata       (cfg_mem_rdata[(25 * 32) +: 32])
        ,.cfg_mem_ack         (cfg_mem_ack[  (25 *  1) +:  1])
        ,.cfg_mem_cc_v        (cfg_mem_cc_v)
        ,.cfg_mem_cc_value    (cfg_mem_cc_value)
        ,.cfg_mem_cc_width    (cfg_mem_cc_width)
        ,.cfg_mem_cc_position (cfg_mem_cc_position)

        ,.pf_mem_re           (pf_ldb_cq_wptr_re)
        ,.pf_mem_raddr        (pf_ldb_cq_wptr_raddr)
        ,.pf_mem_waddr        (pf_ldb_cq_wptr_waddr)
        ,.pf_mem_we           (pf_ldb_cq_wptr_we)
        ,.pf_mem_wdata        (pf_ldb_cq_wptr_wdata)
        ,.pf_mem_rdata        (pf_ldb_cq_wptr_rdata)

        ,.mem_wclk            (rf_ldb_cq_wptr_wclk)
        ,.mem_rclk            (rf_ldb_cq_wptr_rclk)
        ,.mem_wclk_rst_n      (rf_ldb_cq_wptr_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_ldb_cq_wptr_rclk_rst_n)
        ,.mem_re              (rf_ldb_cq_wptr_re)
        ,.mem_raddr           (rf_ldb_cq_wptr_raddr)
        ,.mem_waddr           (rf_ldb_cq_wptr_waddr)
        ,.mem_we              (rf_ldb_cq_wptr_we)
        ,.mem_wdata           (rf_ldb_cq_wptr_wdata)
        ,.mem_rdata           (rf_ldb_cq_wptr_rdata)

        ,.mem_rdata_error     (rf_ldb_cq_wptr_rdata_error)
        ,.error               (rf_ldb_cq_wptr_error)
);

logic        rf_ord_qid_sn_rdata_error;

hqm_AW_rfw_access #( 
         .DEPTH               (32)
        ,.DWIDTH              (12)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_ord_qid_sn (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_ord_qid_sn_re)
        ,.func_mem_raddr      (func_ord_qid_sn_raddr)
        ,.func_mem_waddr      (func_ord_qid_sn_waddr)
        ,.func_mem_we         (func_ord_qid_sn_we)
        ,.func_mem_wdata      (func_ord_qid_sn_wdata)
        ,.func_mem_rdata      (func_ord_qid_sn_rdata)

        ,.cfg_mem_re          (cfg_mem_re[(26 * 1) +: 1])
        ,.cfg_mem_we          (cfg_mem_we[(26 * 1) +: 1])
        ,.cfg_mem_addr        (cfg_mem_addr)
        ,.cfg_mem_minbit      (cfg_mem_minbit)
        ,.cfg_mem_maxbit      (cfg_mem_maxbit)
        ,.cfg_mem_wdata       (cfg_mem_wdata)
        ,.cfg_mem_rdata       (cfg_mem_rdata[(26 * 32) +: 32])
        ,.cfg_mem_ack         (cfg_mem_ack[  (26 *  1) +:  1])
        ,.cfg_mem_cc_v        (cfg_mem_cc_v)
        ,.cfg_mem_cc_value    (cfg_mem_cc_value)
        ,.cfg_mem_cc_width    (cfg_mem_cc_width)
        ,.cfg_mem_cc_position (cfg_mem_cc_position)

        ,.pf_mem_re           (pf_ord_qid_sn_re)
        ,.pf_mem_raddr        (pf_ord_qid_sn_raddr)
        ,.pf_mem_waddr        (pf_ord_qid_sn_waddr)
        ,.pf_mem_we           (pf_ord_qid_sn_we)
        ,.pf_mem_wdata        (pf_ord_qid_sn_wdata)
        ,.pf_mem_rdata        (pf_ord_qid_sn_rdata)

        ,.mem_wclk            (rf_ord_qid_sn_wclk)
        ,.mem_rclk            (rf_ord_qid_sn_rclk)
        ,.mem_wclk_rst_n      (rf_ord_qid_sn_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_ord_qid_sn_rclk_rst_n)
        ,.mem_re              (rf_ord_qid_sn_re)
        ,.mem_raddr           (rf_ord_qid_sn_raddr)
        ,.mem_waddr           (rf_ord_qid_sn_waddr)
        ,.mem_we              (rf_ord_qid_sn_we)
        ,.mem_wdata           (rf_ord_qid_sn_wdata)
        ,.mem_rdata           (rf_ord_qid_sn_rdata)

        ,.mem_rdata_error     (rf_ord_qid_sn_rdata_error)
        ,.error               (rf_ord_qid_sn_error)
);

logic        rf_ord_qid_sn_map_rdata_error;

hqm_AW_rfw_access #( 
         .DEPTH               (32)
        ,.DWIDTH              (12)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_ord_qid_sn_map (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_ord_qid_sn_map_re)
        ,.func_mem_raddr      (func_ord_qid_sn_map_raddr)
        ,.func_mem_waddr      (func_ord_qid_sn_map_waddr)
        ,.func_mem_we         (func_ord_qid_sn_map_we)
        ,.func_mem_wdata      (func_ord_qid_sn_map_wdata)
        ,.func_mem_rdata      (func_ord_qid_sn_map_rdata)

        ,.cfg_mem_re          (cfg_mem_re[(27 * 1) +: 1])
        ,.cfg_mem_we          (cfg_mem_we[(27 * 1) +: 1])
        ,.cfg_mem_addr        (cfg_mem_addr)
        ,.cfg_mem_minbit      (cfg_mem_minbit)
        ,.cfg_mem_maxbit      (cfg_mem_maxbit)
        ,.cfg_mem_wdata       (cfg_mem_wdata)
        ,.cfg_mem_rdata       (cfg_mem_rdata[(27 * 32) +: 32])
        ,.cfg_mem_ack         (cfg_mem_ack[  (27 *  1) +:  1])
        ,.cfg_mem_cc_v        (cfg_mem_cc_v)
        ,.cfg_mem_cc_value    (cfg_mem_cc_value)
        ,.cfg_mem_cc_width    (cfg_mem_cc_width)
        ,.cfg_mem_cc_position (cfg_mem_cc_position)

        ,.pf_mem_re           (pf_ord_qid_sn_map_re)
        ,.pf_mem_raddr        (pf_ord_qid_sn_map_raddr)
        ,.pf_mem_waddr        (pf_ord_qid_sn_map_waddr)
        ,.pf_mem_we           (pf_ord_qid_sn_map_we)
        ,.pf_mem_wdata        (pf_ord_qid_sn_map_wdata)
        ,.pf_mem_rdata        (pf_ord_qid_sn_map_rdata)

        ,.mem_wclk            (rf_ord_qid_sn_map_wclk)
        ,.mem_rclk            (rf_ord_qid_sn_map_rclk)
        ,.mem_wclk_rst_n      (rf_ord_qid_sn_map_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_ord_qid_sn_map_rclk_rst_n)
        ,.mem_re              (rf_ord_qid_sn_map_re)
        ,.mem_raddr           (rf_ord_qid_sn_map_raddr)
        ,.mem_waddr           (rf_ord_qid_sn_map_waddr)
        ,.mem_we              (rf_ord_qid_sn_map_we)
        ,.mem_wdata           (rf_ord_qid_sn_map_wdata)
        ,.mem_rdata           (rf_ord_qid_sn_map_rdata)

        ,.mem_rdata_error     (rf_ord_qid_sn_map_rdata_error)
        ,.error               (rf_ord_qid_sn_map_error)
);

logic        rf_outbound_hcw_fifo_mem_rdata_error;

logic        cfg_mem_ack_outbound_hcw_fifo_mem_nc;
logic [31:0] cfg_mem_rdata_outbound_hcw_fifo_mem_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (16)
        ,.DWIDTH              (160)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_outbound_hcw_fifo_mem (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_outbound_hcw_fifo_mem_re)
        ,.func_mem_raddr      (func_outbound_hcw_fifo_mem_raddr)
        ,.func_mem_waddr      (func_outbound_hcw_fifo_mem_waddr)
        ,.func_mem_we         (func_outbound_hcw_fifo_mem_we)
        ,.func_mem_wdata      (func_outbound_hcw_fifo_mem_wdata)
        ,.func_mem_rdata      (func_outbound_hcw_fifo_mem_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_outbound_hcw_fifo_mem_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_outbound_hcw_fifo_mem_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_outbound_hcw_fifo_mem_re)
        ,.pf_mem_raddr        (pf_outbound_hcw_fifo_mem_raddr)
        ,.pf_mem_waddr        (pf_outbound_hcw_fifo_mem_waddr)
        ,.pf_mem_we           (pf_outbound_hcw_fifo_mem_we)
        ,.pf_mem_wdata        (pf_outbound_hcw_fifo_mem_wdata)
        ,.pf_mem_rdata        (pf_outbound_hcw_fifo_mem_rdata)

        ,.mem_wclk            (rf_outbound_hcw_fifo_mem_wclk)
        ,.mem_rclk            (rf_outbound_hcw_fifo_mem_rclk)
        ,.mem_wclk_rst_n      (rf_outbound_hcw_fifo_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_outbound_hcw_fifo_mem_rclk_rst_n)
        ,.mem_re              (rf_outbound_hcw_fifo_mem_re)
        ,.mem_raddr           (rf_outbound_hcw_fifo_mem_raddr)
        ,.mem_waddr           (rf_outbound_hcw_fifo_mem_waddr)
        ,.mem_we              (rf_outbound_hcw_fifo_mem_we)
        ,.mem_wdata           (rf_outbound_hcw_fifo_mem_wdata)
        ,.mem_rdata           (rf_outbound_hcw_fifo_mem_rdata)

        ,.mem_rdata_error     (rf_outbound_hcw_fifo_mem_rdata_error)
        ,.error               (rf_outbound_hcw_fifo_mem_error)
);

logic        rf_qed_chp_sch_flid_ret_rx_sync_mem_rdata_error;

logic        cfg_mem_ack_qed_chp_sch_flid_ret_rx_sync_mem_nc;
logic [31:0] cfg_mem_rdata_qed_chp_sch_flid_ret_rx_sync_mem_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (4)
        ,.DWIDTH              (26)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_qed_chp_sch_flid_ret_rx_sync_mem (
         .clk                 (hqm_inp_gated_clk)
        ,.rst_n               (hqm_inp_gated_rst_n)

        ,.func_mem_re         (func_qed_chp_sch_flid_ret_rx_sync_mem_re)
        ,.func_mem_raddr      (func_qed_chp_sch_flid_ret_rx_sync_mem_raddr)
        ,.func_mem_waddr      (func_qed_chp_sch_flid_ret_rx_sync_mem_waddr)
        ,.func_mem_we         (func_qed_chp_sch_flid_ret_rx_sync_mem_we)
        ,.func_mem_wdata      (func_qed_chp_sch_flid_ret_rx_sync_mem_wdata)
        ,.func_mem_rdata      (func_qed_chp_sch_flid_ret_rx_sync_mem_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_qed_chp_sch_flid_ret_rx_sync_mem_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_qed_chp_sch_flid_ret_rx_sync_mem_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_qed_chp_sch_flid_ret_rx_sync_mem_re)
        ,.pf_mem_raddr        (pf_qed_chp_sch_flid_ret_rx_sync_mem_raddr)
        ,.pf_mem_waddr        (pf_qed_chp_sch_flid_ret_rx_sync_mem_waddr)
        ,.pf_mem_we           (pf_qed_chp_sch_flid_ret_rx_sync_mem_we)
        ,.pf_mem_wdata        (pf_qed_chp_sch_flid_ret_rx_sync_mem_wdata)
        ,.pf_mem_rdata        (pf_qed_chp_sch_flid_ret_rx_sync_mem_rdata)

        ,.mem_wclk            (rf_qed_chp_sch_flid_ret_rx_sync_mem_wclk)
        ,.mem_rclk            (rf_qed_chp_sch_flid_ret_rx_sync_mem_rclk)
        ,.mem_wclk_rst_n      (rf_qed_chp_sch_flid_ret_rx_sync_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_qed_chp_sch_flid_ret_rx_sync_mem_rclk_rst_n)
        ,.mem_re              (rf_qed_chp_sch_flid_ret_rx_sync_mem_re)
        ,.mem_raddr           (rf_qed_chp_sch_flid_ret_rx_sync_mem_raddr)
        ,.mem_waddr           (rf_qed_chp_sch_flid_ret_rx_sync_mem_waddr)
        ,.mem_we              (rf_qed_chp_sch_flid_ret_rx_sync_mem_we)
        ,.mem_wdata           (rf_qed_chp_sch_flid_ret_rx_sync_mem_wdata)
        ,.mem_rdata           (rf_qed_chp_sch_flid_ret_rx_sync_mem_rdata)

        ,.mem_rdata_error     (rf_qed_chp_sch_flid_ret_rx_sync_mem_rdata_error)
        ,.error               (rf_qed_chp_sch_flid_ret_rx_sync_mem_error)
);

logic        rf_qed_chp_sch_rx_sync_mem_rdata_error;

logic        cfg_mem_ack_qed_chp_sch_rx_sync_mem_nc;
logic [31:0] cfg_mem_rdata_qed_chp_sch_rx_sync_mem_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (8)
        ,.DWIDTH              (177)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_qed_chp_sch_rx_sync_mem (
         .clk                 (hqm_inp_gated_clk)
        ,.rst_n               (hqm_inp_gated_rst_n)

        ,.func_mem_re         (func_qed_chp_sch_rx_sync_mem_re)
        ,.func_mem_raddr      (func_qed_chp_sch_rx_sync_mem_raddr)
        ,.func_mem_waddr      (func_qed_chp_sch_rx_sync_mem_waddr)
        ,.func_mem_we         (func_qed_chp_sch_rx_sync_mem_we)
        ,.func_mem_wdata      (func_qed_chp_sch_rx_sync_mem_wdata)
        ,.func_mem_rdata      (func_qed_chp_sch_rx_sync_mem_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_qed_chp_sch_rx_sync_mem_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_qed_chp_sch_rx_sync_mem_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_qed_chp_sch_rx_sync_mem_re)
        ,.pf_mem_raddr        (pf_qed_chp_sch_rx_sync_mem_raddr)
        ,.pf_mem_waddr        (pf_qed_chp_sch_rx_sync_mem_waddr)
        ,.pf_mem_we           (pf_qed_chp_sch_rx_sync_mem_we)
        ,.pf_mem_wdata        (pf_qed_chp_sch_rx_sync_mem_wdata)
        ,.pf_mem_rdata        (pf_qed_chp_sch_rx_sync_mem_rdata)

        ,.mem_wclk            (rf_qed_chp_sch_rx_sync_mem_wclk)
        ,.mem_rclk            (rf_qed_chp_sch_rx_sync_mem_rclk)
        ,.mem_wclk_rst_n      (rf_qed_chp_sch_rx_sync_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_qed_chp_sch_rx_sync_mem_rclk_rst_n)
        ,.mem_re              (rf_qed_chp_sch_rx_sync_mem_re)
        ,.mem_raddr           (rf_qed_chp_sch_rx_sync_mem_raddr)
        ,.mem_waddr           (rf_qed_chp_sch_rx_sync_mem_waddr)
        ,.mem_we              (rf_qed_chp_sch_rx_sync_mem_we)
        ,.mem_wdata           (rf_qed_chp_sch_rx_sync_mem_wdata)
        ,.mem_rdata           (rf_qed_chp_sch_rx_sync_mem_rdata)

        ,.mem_rdata_error     (rf_qed_chp_sch_rx_sync_mem_rdata_error)
        ,.error               (rf_qed_chp_sch_rx_sync_mem_error)
);

logic        rf_qed_to_cq_fifo_mem_rdata_error;

logic        cfg_mem_ack_qed_to_cq_fifo_mem_nc;
logic [31:0] cfg_mem_rdata_qed_to_cq_fifo_mem_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (8)
        ,.DWIDTH              (197)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_qed_to_cq_fifo_mem (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_qed_to_cq_fifo_mem_re)
        ,.func_mem_raddr      (func_qed_to_cq_fifo_mem_raddr)
        ,.func_mem_waddr      (func_qed_to_cq_fifo_mem_waddr)
        ,.func_mem_we         (func_qed_to_cq_fifo_mem_we)
        ,.func_mem_wdata      (func_qed_to_cq_fifo_mem_wdata)
        ,.func_mem_rdata      (func_qed_to_cq_fifo_mem_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_qed_to_cq_fifo_mem_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_qed_to_cq_fifo_mem_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_qed_to_cq_fifo_mem_re)
        ,.pf_mem_raddr        (pf_qed_to_cq_fifo_mem_raddr)
        ,.pf_mem_waddr        (pf_qed_to_cq_fifo_mem_waddr)
        ,.pf_mem_we           (pf_qed_to_cq_fifo_mem_we)
        ,.pf_mem_wdata        (pf_qed_to_cq_fifo_mem_wdata)
        ,.pf_mem_rdata        (pf_qed_to_cq_fifo_mem_rdata)

        ,.mem_wclk            (rf_qed_to_cq_fifo_mem_wclk)
        ,.mem_rclk            (rf_qed_to_cq_fifo_mem_rclk)
        ,.mem_wclk_rst_n      (rf_qed_to_cq_fifo_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_qed_to_cq_fifo_mem_rclk_rst_n)
        ,.mem_re              (rf_qed_to_cq_fifo_mem_re)
        ,.mem_raddr           (rf_qed_to_cq_fifo_mem_raddr)
        ,.mem_waddr           (rf_qed_to_cq_fifo_mem_waddr)
        ,.mem_we              (rf_qed_to_cq_fifo_mem_we)
        ,.mem_wdata           (rf_qed_to_cq_fifo_mem_wdata)
        ,.mem_rdata           (rf_qed_to_cq_fifo_mem_rdata)

        ,.mem_rdata_error     (rf_qed_to_cq_fifo_mem_rdata_error)
        ,.error               (rf_qed_to_cq_fifo_mem_error)
);

hqm_chp_threshold_r_pipe_access #( 
         .DEPTH               (64)
        ,.DWIDTH              (14)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
) i_threshold_r_pipe_dir_mem (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_threshold_r_pipe_dir_mem_re)
        ,.func_mem_addr       (func_threshold_r_pipe_dir_mem_addr)
        ,.func_mem_we         (func_threshold_r_pipe_dir_mem_we)
        ,.func_mem_wdata      (func_threshold_r_pipe_dir_mem_wdata)
        ,.func_mem_rdata      (func_threshold_r_pipe_dir_mem_rdata)

        ,.cfg_mem_re          (cfg_mem_re[(28 * 1) +: 1])
        ,.cfg_mem_we          (cfg_mem_we[(28 * 1) +: 1])
        ,.cfg_mem_addr        (cfg_mem_addr)
        ,.cfg_mem_minbit      (cfg_mem_minbit)
        ,.cfg_mem_maxbit      (cfg_mem_maxbit)
        ,.cfg_mem_wdata       (cfg_mem_wdata)
        ,.cfg_mem_rdata       (cfg_mem_rdata[(28 * 32) +: 32])
        ,.cfg_mem_ack         (cfg_mem_ack[  (28 *  1) +:  1])
        ,.cfg_mem_cc_v        (cfg_mem_cc_v)
        ,.cfg_mem_cc_value    (cfg_mem_cc_value)
        ,.cfg_mem_cc_width    (cfg_mem_cc_width)
        ,.cfg_mem_cc_position (cfg_mem_cc_position)

        ,.pf_mem_re           (pf_threshold_r_pipe_dir_mem_re)
        ,.pf_mem_addr         (pf_threshold_r_pipe_dir_mem_addr)
        ,.pf_mem_we           (pf_threshold_r_pipe_dir_mem_we)
        ,.pf_mem_wdata        (pf_threshold_r_pipe_dir_mem_wdata)
        ,.pf_mem_rdata        (pf_threshold_r_pipe_dir_mem_rdata)

        ,.mem_wclk            (rf_threshold_r_pipe_dir_mem_wclk)
        ,.mem_rclk            (rf_threshold_r_pipe_dir_mem_rclk)
        ,.mem_wclk_rst_n      (rf_threshold_r_pipe_dir_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_threshold_r_pipe_dir_mem_rclk_rst_n)
        ,.mem_re              (rf_threshold_r_pipe_dir_mem_re)
        ,.mem_raddr           (rf_threshold_r_pipe_dir_mem_raddr)
        ,.mem_waddr           (rf_threshold_r_pipe_dir_mem_waddr)
        ,.mem_we              (rf_threshold_r_pipe_dir_mem_we)
        ,.mem_wdata           (rf_threshold_r_pipe_dir_mem_wdata)
        ,.mem_rdata           (rf_threshold_r_pipe_dir_mem_rdata)

        ,.error               (rf_threshold_r_pipe_dir_mem_error)
);

hqm_chp_threshold_r_pipe_access #( 
         .DEPTH               (64)
        ,.DWIDTH              (14)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
) i_threshold_r_pipe_ldb_mem (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_threshold_r_pipe_ldb_mem_re)
        ,.func_mem_addr       (func_threshold_r_pipe_ldb_mem_addr)
        ,.func_mem_we         (func_threshold_r_pipe_ldb_mem_we)
        ,.func_mem_wdata      (func_threshold_r_pipe_ldb_mem_wdata)
        ,.func_mem_rdata      (func_threshold_r_pipe_ldb_mem_rdata)

        ,.cfg_mem_re          (cfg_mem_re[(29 * 1) +: 1])
        ,.cfg_mem_we          (cfg_mem_we[(29 * 1) +: 1])
        ,.cfg_mem_addr        (cfg_mem_addr)
        ,.cfg_mem_minbit      (cfg_mem_minbit)
        ,.cfg_mem_maxbit      (cfg_mem_maxbit)
        ,.cfg_mem_wdata       (cfg_mem_wdata)
        ,.cfg_mem_rdata       (cfg_mem_rdata[(29 * 32) +: 32])
        ,.cfg_mem_ack         (cfg_mem_ack[  (29 *  1) +:  1])
        ,.cfg_mem_cc_v        (cfg_mem_cc_v)
        ,.cfg_mem_cc_value    (cfg_mem_cc_value)
        ,.cfg_mem_cc_width    (cfg_mem_cc_width)
        ,.cfg_mem_cc_position (cfg_mem_cc_position)

        ,.pf_mem_re           (pf_threshold_r_pipe_ldb_mem_re)
        ,.pf_mem_addr         (pf_threshold_r_pipe_ldb_mem_addr)
        ,.pf_mem_we           (pf_threshold_r_pipe_ldb_mem_we)
        ,.pf_mem_wdata        (pf_threshold_r_pipe_ldb_mem_wdata)
        ,.pf_mem_rdata        (pf_threshold_r_pipe_ldb_mem_rdata)

        ,.mem_wclk            (rf_threshold_r_pipe_ldb_mem_wclk)
        ,.mem_rclk            (rf_threshold_r_pipe_ldb_mem_rclk)
        ,.mem_wclk_rst_n      (rf_threshold_r_pipe_ldb_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_threshold_r_pipe_ldb_mem_rclk_rst_n)
        ,.mem_re              (rf_threshold_r_pipe_ldb_mem_re)
        ,.mem_raddr           (rf_threshold_r_pipe_ldb_mem_raddr)
        ,.mem_waddr           (rf_threshold_r_pipe_ldb_mem_waddr)
        ,.mem_we              (rf_threshold_r_pipe_ldb_mem_we)
        ,.mem_wdata           (rf_threshold_r_pipe_ldb_mem_wdata)
        ,.mem_rdata           (rf_threshold_r_pipe_ldb_mem_rdata)

        ,.error               (rf_threshold_r_pipe_ldb_mem_error)
);

hqm_AW_srw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (16)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
) i_freelist_0 ( 
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_freelist_0_re)
        ,.func_mem_addr       (func_freelist_0_addr)
        ,.func_mem_we         (func_freelist_0_we)
        ,.func_mem_wdata      (func_freelist_0_wdata)
        ,.func_mem_rdata      (func_freelist_0_rdata)

        ,.cfg_mem_re          (cfg_mem_re[(0 * 1) +: 1])
        ,.cfg_mem_we          (cfg_mem_we[(0 * 1) +: 1])
        ,.cfg_mem_addr        (cfg_mem_addr)
        ,.cfg_mem_minbit      (cfg_mem_minbit)
        ,.cfg_mem_maxbit      (cfg_mem_maxbit)
        ,.cfg_mem_wdata       (cfg_mem_wdata)
        ,.cfg_mem_rdata       (cfg_mem_rdata[(0 * 32) +: 32])
        ,.cfg_mem_ack         (cfg_mem_ack[  (0 *  1) +:  1])
        ,.cfg_mem_cc_v        (cfg_mem_cc_v)
        ,.cfg_mem_cc_value    (cfg_mem_cc_value)
        ,.cfg_mem_cc_width    (cfg_mem_cc_width)
        ,.cfg_mem_cc_position (cfg_mem_cc_position)

        ,.pf_mem_re           (pf_freelist_0_re)
        ,.pf_mem_addr         (pf_freelist_0_addr)
        ,.pf_mem_we           (pf_freelist_0_we)
        ,.pf_mem_wdata        (pf_freelist_0_wdata)
        ,.pf_mem_rdata        (pf_freelist_0_rdata)

        ,.mem_clk             (sr_freelist_0_clk)
        ,.mem_clk_rst_n       (sr_freelist_0_clk_rst_n)
        ,.mem_re              (sr_freelist_0_re)
        ,.mem_addr            (sr_freelist_0_addr)
        ,.mem_we              (sr_freelist_0_we)
        ,.mem_wdata           (sr_freelist_0_wdata)
        ,.mem_rdata           (sr_freelist_0_rdata)

        ,.error               (sr_freelist_0_error)
);


hqm_AW_srw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (16)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
) i_freelist_1 ( 
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_freelist_1_re)
        ,.func_mem_addr       (func_freelist_1_addr)
        ,.func_mem_we         (func_freelist_1_we)
        ,.func_mem_wdata      (func_freelist_1_wdata)
        ,.func_mem_rdata      (func_freelist_1_rdata)

        ,.cfg_mem_re          (cfg_mem_re[(1 * 1) +: 1])
        ,.cfg_mem_we          (cfg_mem_we[(1 * 1) +: 1])
        ,.cfg_mem_addr        (cfg_mem_addr)
        ,.cfg_mem_minbit      (cfg_mem_minbit)
        ,.cfg_mem_maxbit      (cfg_mem_maxbit)
        ,.cfg_mem_wdata       (cfg_mem_wdata)
        ,.cfg_mem_rdata       (cfg_mem_rdata[(1 * 32) +: 32])
        ,.cfg_mem_ack         (cfg_mem_ack[  (1 *  1) +:  1])
        ,.cfg_mem_cc_v        (cfg_mem_cc_v)
        ,.cfg_mem_cc_value    (cfg_mem_cc_value)
        ,.cfg_mem_cc_width    (cfg_mem_cc_width)
        ,.cfg_mem_cc_position (cfg_mem_cc_position)

        ,.pf_mem_re           (pf_freelist_1_re)
        ,.pf_mem_addr         (pf_freelist_1_addr)
        ,.pf_mem_we           (pf_freelist_1_we)
        ,.pf_mem_wdata        (pf_freelist_1_wdata)
        ,.pf_mem_rdata        (pf_freelist_1_rdata)

        ,.mem_clk             (sr_freelist_1_clk)
        ,.mem_clk_rst_n       (sr_freelist_1_clk_rst_n)
        ,.mem_re              (sr_freelist_1_re)
        ,.mem_addr            (sr_freelist_1_addr)
        ,.mem_we              (sr_freelist_1_we)
        ,.mem_wdata           (sr_freelist_1_wdata)
        ,.mem_rdata           (sr_freelist_1_rdata)

        ,.error               (sr_freelist_1_error)
);


hqm_AW_srw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (16)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
) i_freelist_2 ( 
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_freelist_2_re)
        ,.func_mem_addr       (func_freelist_2_addr)
        ,.func_mem_we         (func_freelist_2_we)
        ,.func_mem_wdata      (func_freelist_2_wdata)
        ,.func_mem_rdata      (func_freelist_2_rdata)

        ,.cfg_mem_re          (cfg_mem_re[(2 * 1) +: 1])
        ,.cfg_mem_we          (cfg_mem_we[(2 * 1) +: 1])
        ,.cfg_mem_addr        (cfg_mem_addr)
        ,.cfg_mem_minbit      (cfg_mem_minbit)
        ,.cfg_mem_maxbit      (cfg_mem_maxbit)
        ,.cfg_mem_wdata       (cfg_mem_wdata)
        ,.cfg_mem_rdata       (cfg_mem_rdata[(2 * 32) +: 32])
        ,.cfg_mem_ack         (cfg_mem_ack[  (2 *  1) +:  1])
        ,.cfg_mem_cc_v        (cfg_mem_cc_v)
        ,.cfg_mem_cc_value    (cfg_mem_cc_value)
        ,.cfg_mem_cc_width    (cfg_mem_cc_width)
        ,.cfg_mem_cc_position (cfg_mem_cc_position)

        ,.pf_mem_re           (pf_freelist_2_re)
        ,.pf_mem_addr         (pf_freelist_2_addr)
        ,.pf_mem_we           (pf_freelist_2_we)
        ,.pf_mem_wdata        (pf_freelist_2_wdata)
        ,.pf_mem_rdata        (pf_freelist_2_rdata)

        ,.mem_clk             (sr_freelist_2_clk)
        ,.mem_clk_rst_n       (sr_freelist_2_clk_rst_n)
        ,.mem_re              (sr_freelist_2_re)
        ,.mem_addr            (sr_freelist_2_addr)
        ,.mem_we              (sr_freelist_2_we)
        ,.mem_wdata           (sr_freelist_2_wdata)
        ,.mem_rdata           (sr_freelist_2_rdata)

        ,.error               (sr_freelist_2_error)
);


hqm_AW_srw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (16)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
) i_freelist_3 ( 
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_freelist_3_re)
        ,.func_mem_addr       (func_freelist_3_addr)
        ,.func_mem_we         (func_freelist_3_we)
        ,.func_mem_wdata      (func_freelist_3_wdata)
        ,.func_mem_rdata      (func_freelist_3_rdata)

        ,.cfg_mem_re          (cfg_mem_re[(3 * 1) +: 1])
        ,.cfg_mem_we          (cfg_mem_we[(3 * 1) +: 1])
        ,.cfg_mem_addr        (cfg_mem_addr)
        ,.cfg_mem_minbit      (cfg_mem_minbit)
        ,.cfg_mem_maxbit      (cfg_mem_maxbit)
        ,.cfg_mem_wdata       (cfg_mem_wdata)
        ,.cfg_mem_rdata       (cfg_mem_rdata[(3 * 32) +: 32])
        ,.cfg_mem_ack         (cfg_mem_ack[  (3 *  1) +:  1])
        ,.cfg_mem_cc_v        (cfg_mem_cc_v)
        ,.cfg_mem_cc_value    (cfg_mem_cc_value)
        ,.cfg_mem_cc_width    (cfg_mem_cc_width)
        ,.cfg_mem_cc_position (cfg_mem_cc_position)

        ,.pf_mem_re           (pf_freelist_3_re)
        ,.pf_mem_addr         (pf_freelist_3_addr)
        ,.pf_mem_we           (pf_freelist_3_we)
        ,.pf_mem_wdata        (pf_freelist_3_wdata)
        ,.pf_mem_rdata        (pf_freelist_3_rdata)

        ,.mem_clk             (sr_freelist_3_clk)
        ,.mem_clk_rst_n       (sr_freelist_3_clk_rst_n)
        ,.mem_re              (sr_freelist_3_re)
        ,.mem_addr            (sr_freelist_3_addr)
        ,.mem_we              (sr_freelist_3_we)
        ,.mem_wdata           (sr_freelist_3_wdata)
        ,.mem_rdata           (sr_freelist_3_rdata)

        ,.error               (sr_freelist_3_error)
);


hqm_AW_srw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (16)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
) i_freelist_4 ( 
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_freelist_4_re)
        ,.func_mem_addr       (func_freelist_4_addr)
        ,.func_mem_we         (func_freelist_4_we)
        ,.func_mem_wdata      (func_freelist_4_wdata)
        ,.func_mem_rdata      (func_freelist_4_rdata)

        ,.cfg_mem_re          (cfg_mem_re[(4 * 1) +: 1])
        ,.cfg_mem_we          (cfg_mem_we[(4 * 1) +: 1])
        ,.cfg_mem_addr        (cfg_mem_addr)
        ,.cfg_mem_minbit      (cfg_mem_minbit)
        ,.cfg_mem_maxbit      (cfg_mem_maxbit)
        ,.cfg_mem_wdata       (cfg_mem_wdata)
        ,.cfg_mem_rdata       (cfg_mem_rdata[(4 * 32) +: 32])
        ,.cfg_mem_ack         (cfg_mem_ack[  (4 *  1) +:  1])
        ,.cfg_mem_cc_v        (cfg_mem_cc_v)
        ,.cfg_mem_cc_value    (cfg_mem_cc_value)
        ,.cfg_mem_cc_width    (cfg_mem_cc_width)
        ,.cfg_mem_cc_position (cfg_mem_cc_position)

        ,.pf_mem_re           (pf_freelist_4_re)
        ,.pf_mem_addr         (pf_freelist_4_addr)
        ,.pf_mem_we           (pf_freelist_4_we)
        ,.pf_mem_wdata        (pf_freelist_4_wdata)
        ,.pf_mem_rdata        (pf_freelist_4_rdata)

        ,.mem_clk             (sr_freelist_4_clk)
        ,.mem_clk_rst_n       (sr_freelist_4_clk_rst_n)
        ,.mem_re              (sr_freelist_4_re)
        ,.mem_addr            (sr_freelist_4_addr)
        ,.mem_we              (sr_freelist_4_we)
        ,.mem_wdata           (sr_freelist_4_wdata)
        ,.mem_rdata           (sr_freelist_4_rdata)

        ,.error               (sr_freelist_4_error)
);


hqm_AW_srw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (16)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
) i_freelist_5 ( 
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_freelist_5_re)
        ,.func_mem_addr       (func_freelist_5_addr)
        ,.func_mem_we         (func_freelist_5_we)
        ,.func_mem_wdata      (func_freelist_5_wdata)
        ,.func_mem_rdata      (func_freelist_5_rdata)

        ,.cfg_mem_re          (cfg_mem_re[(5 * 1) +: 1])
        ,.cfg_mem_we          (cfg_mem_we[(5 * 1) +: 1])
        ,.cfg_mem_addr        (cfg_mem_addr)
        ,.cfg_mem_minbit      (cfg_mem_minbit)
        ,.cfg_mem_maxbit      (cfg_mem_maxbit)
        ,.cfg_mem_wdata       (cfg_mem_wdata)
        ,.cfg_mem_rdata       (cfg_mem_rdata[(5 * 32) +: 32])
        ,.cfg_mem_ack         (cfg_mem_ack[  (5 *  1) +:  1])
        ,.cfg_mem_cc_v        (cfg_mem_cc_v)
        ,.cfg_mem_cc_value    (cfg_mem_cc_value)
        ,.cfg_mem_cc_width    (cfg_mem_cc_width)
        ,.cfg_mem_cc_position (cfg_mem_cc_position)

        ,.pf_mem_re           (pf_freelist_5_re)
        ,.pf_mem_addr         (pf_freelist_5_addr)
        ,.pf_mem_we           (pf_freelist_5_we)
        ,.pf_mem_wdata        (pf_freelist_5_wdata)
        ,.pf_mem_rdata        (pf_freelist_5_rdata)

        ,.mem_clk             (sr_freelist_5_clk)
        ,.mem_clk_rst_n       (sr_freelist_5_clk_rst_n)
        ,.mem_re              (sr_freelist_5_re)
        ,.mem_addr            (sr_freelist_5_addr)
        ,.mem_we              (sr_freelist_5_we)
        ,.mem_wdata           (sr_freelist_5_wdata)
        ,.mem_rdata           (sr_freelist_5_rdata)

        ,.error               (sr_freelist_5_error)
);


hqm_AW_srw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (16)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
) i_freelist_6 ( 
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_freelist_6_re)
        ,.func_mem_addr       (func_freelist_6_addr)
        ,.func_mem_we         (func_freelist_6_we)
        ,.func_mem_wdata      (func_freelist_6_wdata)
        ,.func_mem_rdata      (func_freelist_6_rdata)

        ,.cfg_mem_re          (cfg_mem_re[(6 * 1) +: 1])
        ,.cfg_mem_we          (cfg_mem_we[(6 * 1) +: 1])
        ,.cfg_mem_addr        (cfg_mem_addr)
        ,.cfg_mem_minbit      (cfg_mem_minbit)
        ,.cfg_mem_maxbit      (cfg_mem_maxbit)
        ,.cfg_mem_wdata       (cfg_mem_wdata)
        ,.cfg_mem_rdata       (cfg_mem_rdata[(6 * 32) +: 32])
        ,.cfg_mem_ack         (cfg_mem_ack[  (6 *  1) +:  1])
        ,.cfg_mem_cc_v        (cfg_mem_cc_v)
        ,.cfg_mem_cc_value    (cfg_mem_cc_value)
        ,.cfg_mem_cc_width    (cfg_mem_cc_width)
        ,.cfg_mem_cc_position (cfg_mem_cc_position)

        ,.pf_mem_re           (pf_freelist_6_re)
        ,.pf_mem_addr         (pf_freelist_6_addr)
        ,.pf_mem_we           (pf_freelist_6_we)
        ,.pf_mem_wdata        (pf_freelist_6_wdata)
        ,.pf_mem_rdata        (pf_freelist_6_rdata)

        ,.mem_clk             (sr_freelist_6_clk)
        ,.mem_clk_rst_n       (sr_freelist_6_clk_rst_n)
        ,.mem_re              (sr_freelist_6_re)
        ,.mem_addr            (sr_freelist_6_addr)
        ,.mem_we              (sr_freelist_6_we)
        ,.mem_wdata           (sr_freelist_6_wdata)
        ,.mem_rdata           (sr_freelist_6_rdata)

        ,.error               (sr_freelist_6_error)
);


hqm_AW_srw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (16)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
) i_freelist_7 ( 
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_freelist_7_re)
        ,.func_mem_addr       (func_freelist_7_addr)
        ,.func_mem_we         (func_freelist_7_we)
        ,.func_mem_wdata      (func_freelist_7_wdata)
        ,.func_mem_rdata      (func_freelist_7_rdata)

        ,.cfg_mem_re          (cfg_mem_re[(7 * 1) +: 1])
        ,.cfg_mem_we          (cfg_mem_we[(7 * 1) +: 1])
        ,.cfg_mem_addr        (cfg_mem_addr)
        ,.cfg_mem_minbit      (cfg_mem_minbit)
        ,.cfg_mem_maxbit      (cfg_mem_maxbit)
        ,.cfg_mem_wdata       (cfg_mem_wdata)
        ,.cfg_mem_rdata       (cfg_mem_rdata[(7 * 32) +: 32])
        ,.cfg_mem_ack         (cfg_mem_ack[  (7 *  1) +:  1])
        ,.cfg_mem_cc_v        (cfg_mem_cc_v)
        ,.cfg_mem_cc_value    (cfg_mem_cc_value)
        ,.cfg_mem_cc_width    (cfg_mem_cc_width)
        ,.cfg_mem_cc_position (cfg_mem_cc_position)

        ,.pf_mem_re           (pf_freelist_7_re)
        ,.pf_mem_addr         (pf_freelist_7_addr)
        ,.pf_mem_we           (pf_freelist_7_we)
        ,.pf_mem_wdata        (pf_freelist_7_wdata)
        ,.pf_mem_rdata        (pf_freelist_7_rdata)

        ,.mem_clk             (sr_freelist_7_clk)
        ,.mem_clk_rst_n       (sr_freelist_7_clk_rst_n)
        ,.mem_re              (sr_freelist_7_re)
        ,.mem_addr            (sr_freelist_7_addr)
        ,.mem_we              (sr_freelist_7_we)
        ,.mem_wdata           (sr_freelist_7_wdata)
        ,.mem_rdata           (sr_freelist_7_rdata)

        ,.error               (sr_freelist_7_error)
);


logic [(       2)-1:0] sr_hist_list_addr_nc ;


hqm_AW_srw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (66)
        ,.AWIDTHPAD           (2)
        ,.DWIDTHPAD           (0)
) i_hist_list ( 
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_hist_list_re)
        ,.func_mem_addr       (func_hist_list_addr)
        ,.func_mem_we         (func_hist_list_we)
        ,.func_mem_wdata      (func_hist_list_wdata)
        ,.func_mem_rdata      (func_hist_list_rdata)

        ,.cfg_mem_re          (cfg_mem_re[(8 * 1) +: 1])
        ,.cfg_mem_we          (cfg_mem_we[(8 * 1) +: 1])
        ,.cfg_mem_addr        (cfg_mem_addr)
        ,.cfg_mem_minbit      (cfg_mem_minbit)
        ,.cfg_mem_maxbit      (cfg_mem_maxbit)
        ,.cfg_mem_wdata       (cfg_mem_wdata)
        ,.cfg_mem_rdata       (cfg_mem_rdata[(8 * 32) +: 32])
        ,.cfg_mem_ack         (cfg_mem_ack[  (8 *  1) +:  1])
        ,.cfg_mem_cc_v        (cfg_mem_cc_v)
        ,.cfg_mem_cc_value    (cfg_mem_cc_value)
        ,.cfg_mem_cc_width    (cfg_mem_cc_width)
        ,.cfg_mem_cc_position (cfg_mem_cc_position)

        ,.pf_mem_re           (pf_hist_list_re)
        ,.pf_mem_addr         (pf_hist_list_addr)
        ,.pf_mem_we           (pf_hist_list_we)
        ,.pf_mem_wdata        (pf_hist_list_wdata)
        ,.pf_mem_rdata        (pf_hist_list_rdata)

        ,.mem_clk             (sr_hist_list_clk)
        ,.mem_clk_rst_n       (sr_hist_list_clk_rst_n)
        ,.mem_re              (sr_hist_list_re)
        ,.mem_addr            ({sr_hist_list_addr_nc , sr_hist_list_addr})
        ,.mem_we              (sr_hist_list_we)
        ,.mem_wdata           (sr_hist_list_wdata)
        ,.mem_rdata           (sr_hist_list_rdata)

        ,.error               (sr_hist_list_error)
);


logic [(       2)-1:0] sr_hist_list_a_addr_nc ;


hqm_AW_srw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (66)
        ,.AWIDTHPAD           (2)
        ,.DWIDTHPAD           (0)
) i_hist_list_a ( 
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_hist_list_a_re)
        ,.func_mem_addr       (func_hist_list_a_addr)
        ,.func_mem_we         (func_hist_list_a_we)
        ,.func_mem_wdata      (func_hist_list_a_wdata)
        ,.func_mem_rdata      (func_hist_list_a_rdata)

        ,.cfg_mem_re          (cfg_mem_re[(9 * 1) +: 1])
        ,.cfg_mem_we          (cfg_mem_we[(9 * 1) +: 1])
        ,.cfg_mem_addr        (cfg_mem_addr)
        ,.cfg_mem_minbit      (cfg_mem_minbit)
        ,.cfg_mem_maxbit      (cfg_mem_maxbit)
        ,.cfg_mem_wdata       (cfg_mem_wdata)
        ,.cfg_mem_rdata       (cfg_mem_rdata[(9 * 32) +: 32])
        ,.cfg_mem_ack         (cfg_mem_ack[  (9 *  1) +:  1])
        ,.cfg_mem_cc_v        (cfg_mem_cc_v)
        ,.cfg_mem_cc_value    (cfg_mem_cc_value)
        ,.cfg_mem_cc_width    (cfg_mem_cc_width)
        ,.cfg_mem_cc_position (cfg_mem_cc_position)

        ,.pf_mem_re           (pf_hist_list_a_re)
        ,.pf_mem_addr         (pf_hist_list_a_addr)
        ,.pf_mem_we           (pf_hist_list_a_we)
        ,.pf_mem_wdata        (pf_hist_list_a_wdata)
        ,.pf_mem_rdata        (pf_hist_list_a_rdata)

        ,.mem_clk             (sr_hist_list_a_clk)
        ,.mem_clk_rst_n       (sr_hist_list_a_clk_rst_n)
        ,.mem_re              (sr_hist_list_a_re)
        ,.mem_addr            ({sr_hist_list_a_addr_nc , sr_hist_list_a_addr})
        ,.mem_we              (sr_hist_list_a_we)
        ,.mem_wdata           (sr_hist_list_a_wdata)
        ,.mem_rdata           (sr_hist_list_a_rdata)

        ,.error               (sr_hist_list_a_error)
);


assign hqm_credit_hist_pipe_rfw_top_ipar_error = rf_aqed_chp_sch_rx_sync_mem_rdata_error | rf_chp_chp_rop_hcw_fifo_mem_rdata_error | rf_chp_lsp_ap_cmp_fifo_mem_rdata_error | rf_chp_lsp_tok_fifo_mem_rdata_error | rf_chp_sys_tx_fifo_mem_rdata_error | rf_cmp_id_chk_enbl_mem_rdata_error | rf_count_rmw_pipe_dir_mem_rdata_error | rf_count_rmw_pipe_ldb_mem_rdata_error | rf_dir_cq_depth_rdata_error | rf_dir_cq_intr_thresh_rdata_error | rf_dir_cq_token_depth_select_rdata_error | rf_dir_cq_wptr_rdata_error | rf_hcw_enq_w_rx_sync_mem_rdata_error | rf_hist_list_a_minmax_rdata_error | rf_hist_list_a_ptr_rdata_error | rf_hist_list_minmax_rdata_error | rf_hist_list_ptr_rdata_error | rf_ldb_cq_depth_rdata_error | rf_ldb_cq_intr_thresh_rdata_error | rf_ldb_cq_on_off_threshold_rdata_error | rf_ldb_cq_token_depth_select_rdata_error | rf_ldb_cq_wptr_rdata_error | rf_ord_qid_sn_rdata_error | rf_ord_qid_sn_map_rdata_error | rf_outbound_hcw_fifo_mem_rdata_error | rf_qed_chp_sch_flid_ret_rx_sync_mem_rdata_error | rf_qed_chp_sch_rx_sync_mem_rdata_error | rf_qed_to_cq_fifo_mem_rdata_error ;

endmodule

