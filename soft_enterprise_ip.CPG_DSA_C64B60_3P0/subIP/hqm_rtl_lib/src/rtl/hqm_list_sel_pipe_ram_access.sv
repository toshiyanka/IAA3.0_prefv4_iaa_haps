module hqm_list_sel_pipe_ram_access
     import hqm_AW_pkg::* , hqm_pkg::* , hqm_core_pkg::*;
(
     input  logic                  hqm_gated_clk
    ,input  logic                  hqm_inp_gated_clk

    ,input  logic                  hqm_gated_rst_n
    ,input  logic                  hqm_inp_gated_rst_n

    ,input  logic [( 34 *  1)-1:0] cfg_mem_re          // lintra s-0527
    ,input  logic [( 34 *  1)-1:0] cfg_mem_we          // lintra s-0527
    ,input  logic [(      20)-1:0] cfg_mem_addr        // lintra s-0527
    ,input  logic [(      12)-1:0] cfg_mem_minbit      // lintra s-0527
    ,input  logic [(      12)-1:0] cfg_mem_maxbit      // lintra s-0527
    ,input  logic [(      32)-1:0] cfg_mem_wdata       // lintra s-0527
    ,output logic [( 34 * 32)-1:0] cfg_mem_rdata
    ,output logic [( 34 *  1)-1:0] cfg_mem_ack
    ,input  logic                  cfg_mem_cc_v        // lintra s-0527
    ,input  logic [(       8)-1:0] cfg_mem_cc_value    // lintra s-0527
    ,input  logic [(       4)-1:0] cfg_mem_cc_width    // lintra s-0527
    ,input  logic [(      12)-1:0] cfg_mem_cc_position // lintra s-0527

    ,output logic                  hqm_list_sel_pipe_rfw_top_ipar_error

    ,input  logic                  func_aqed_lsp_deq_fifo_mem_re
    ,input  logic [(       5)-1:0] func_aqed_lsp_deq_fifo_mem_raddr
    ,input  logic [(       5)-1:0] func_aqed_lsp_deq_fifo_mem_waddr
    ,input  logic                  func_aqed_lsp_deq_fifo_mem_we
    ,input  logic [(       9)-1:0] func_aqed_lsp_deq_fifo_mem_wdata
    ,output logic [(       9)-1:0] func_aqed_lsp_deq_fifo_mem_rdata

    ,input  logic                  pf_aqed_lsp_deq_fifo_mem_re
    ,input  logic [(       5)-1:0] pf_aqed_lsp_deq_fifo_mem_raddr
    ,input  logic [(       5)-1:0] pf_aqed_lsp_deq_fifo_mem_waddr
    ,input  logic                  pf_aqed_lsp_deq_fifo_mem_we
    ,input  logic [(       9)-1:0] pf_aqed_lsp_deq_fifo_mem_wdata
    ,output logic [(       9)-1:0] pf_aqed_lsp_deq_fifo_mem_rdata

    ,output logic                  rf_aqed_lsp_deq_fifo_mem_re
    ,output logic                  rf_aqed_lsp_deq_fifo_mem_rclk
    ,output logic                  rf_aqed_lsp_deq_fifo_mem_rclk_rst_n
    ,output logic [(       5)-1:0] rf_aqed_lsp_deq_fifo_mem_raddr
    ,output logic [(       5)-1:0] rf_aqed_lsp_deq_fifo_mem_waddr
    ,output logic                  rf_aqed_lsp_deq_fifo_mem_we
    ,output logic                  rf_aqed_lsp_deq_fifo_mem_wclk
    ,output logic                  rf_aqed_lsp_deq_fifo_mem_wclk_rst_n
    ,output logic [(       9)-1:0] rf_aqed_lsp_deq_fifo_mem_wdata
    ,input  logic [(       9)-1:0] rf_aqed_lsp_deq_fifo_mem_rdata

    ,output logic                  rf_aqed_lsp_deq_fifo_mem_error

    ,input  logic                  func_atm_cmp_fifo_mem_re
    ,input  logic [(       3)-1:0] func_atm_cmp_fifo_mem_raddr
    ,input  logic [(       3)-1:0] func_atm_cmp_fifo_mem_waddr
    ,input  logic                  func_atm_cmp_fifo_mem_we
    ,input  logic [(      55)-1:0] func_atm_cmp_fifo_mem_wdata
    ,output logic [(      55)-1:0] func_atm_cmp_fifo_mem_rdata

    ,input  logic                  pf_atm_cmp_fifo_mem_re
    ,input  logic [(       3)-1:0] pf_atm_cmp_fifo_mem_raddr
    ,input  logic [(       3)-1:0] pf_atm_cmp_fifo_mem_waddr
    ,input  logic                  pf_atm_cmp_fifo_mem_we
    ,input  logic [(      55)-1:0] pf_atm_cmp_fifo_mem_wdata
    ,output logic [(      55)-1:0] pf_atm_cmp_fifo_mem_rdata

    ,output logic                  rf_atm_cmp_fifo_mem_re
    ,output logic                  rf_atm_cmp_fifo_mem_rclk
    ,output logic                  rf_atm_cmp_fifo_mem_rclk_rst_n
    ,output logic [(       3)-1:0] rf_atm_cmp_fifo_mem_raddr
    ,output logic [(       3)-1:0] rf_atm_cmp_fifo_mem_waddr
    ,output logic                  rf_atm_cmp_fifo_mem_we
    ,output logic                  rf_atm_cmp_fifo_mem_wclk
    ,output logic                  rf_atm_cmp_fifo_mem_wclk_rst_n
    ,output logic [(      55)-1:0] rf_atm_cmp_fifo_mem_wdata
    ,input  logic [(      55)-1:0] rf_atm_cmp_fifo_mem_rdata

    ,output logic                  rf_atm_cmp_fifo_mem_error

    ,input  logic                  func_cfg_atm_qid_dpth_thrsh_mem_re
    ,input  logic [(       7)-1:0] func_cfg_atm_qid_dpth_thrsh_mem_addr
    ,input  logic                  func_cfg_atm_qid_dpth_thrsh_mem_we
    ,input  logic [(      16)-1:0] func_cfg_atm_qid_dpth_thrsh_mem_wdata
    ,output logic [(      16)-1:0] func_cfg_atm_qid_dpth_thrsh_mem_rdata

    ,input  logic                  pf_cfg_atm_qid_dpth_thrsh_mem_re
    ,input  logic [(       7)-1:0] pf_cfg_atm_qid_dpth_thrsh_mem_addr
    ,input  logic                  pf_cfg_atm_qid_dpth_thrsh_mem_we
    ,input  logic [(      16)-1:0] pf_cfg_atm_qid_dpth_thrsh_mem_wdata
    ,output logic [(      16)-1:0] pf_cfg_atm_qid_dpth_thrsh_mem_rdata

    ,output logic                  rf_cfg_atm_qid_dpth_thrsh_mem_re
    ,output logic                  rf_cfg_atm_qid_dpth_thrsh_mem_rclk
    ,output logic                  rf_cfg_atm_qid_dpth_thrsh_mem_rclk_rst_n
    ,output logic [(       5)-1:0] rf_cfg_atm_qid_dpth_thrsh_mem_raddr
    ,output logic [(       5)-1:0] rf_cfg_atm_qid_dpth_thrsh_mem_waddr
    ,output logic                  rf_cfg_atm_qid_dpth_thrsh_mem_we
    ,output logic                  rf_cfg_atm_qid_dpth_thrsh_mem_wclk
    ,output logic                  rf_cfg_atm_qid_dpth_thrsh_mem_wclk_rst_n
    ,output logic [(      16)-1:0] rf_cfg_atm_qid_dpth_thrsh_mem_wdata
    ,input  logic [(      16)-1:0] rf_cfg_atm_qid_dpth_thrsh_mem_rdata

    ,output logic                  rf_cfg_atm_qid_dpth_thrsh_mem_error

    ,input  logic                  func_cfg_cq2priov_mem_re
    ,input  logic [(       5)-1:0] func_cfg_cq2priov_mem_addr
    ,input  logic                  func_cfg_cq2priov_mem_we
    ,input  logic [(      33)-1:0] func_cfg_cq2priov_mem_wdata
    ,output logic [(      33)-1:0] func_cfg_cq2priov_mem_rdata

    ,input  logic                  pf_cfg_cq2priov_mem_re
    ,input  logic [(       5)-1:0] pf_cfg_cq2priov_mem_addr
    ,input  logic                  pf_cfg_cq2priov_mem_we
    ,input  logic [(      33)-1:0] pf_cfg_cq2priov_mem_wdata
    ,output logic [(      33)-1:0] pf_cfg_cq2priov_mem_rdata

    ,output logic                  rf_cfg_cq2priov_mem_re
    ,output logic                  rf_cfg_cq2priov_mem_rclk
    ,output logic                  rf_cfg_cq2priov_mem_rclk_rst_n
    ,output logic [(       5)-1:0] rf_cfg_cq2priov_mem_raddr
    ,output logic [(       5)-1:0] rf_cfg_cq2priov_mem_waddr
    ,output logic                  rf_cfg_cq2priov_mem_we
    ,output logic                  rf_cfg_cq2priov_mem_wclk
    ,output logic                  rf_cfg_cq2priov_mem_wclk_rst_n
    ,output logic [(      33)-1:0] rf_cfg_cq2priov_mem_wdata
    ,input  logic [(      33)-1:0] rf_cfg_cq2priov_mem_rdata

    ,output logic                  rf_cfg_cq2priov_mem_error

    ,input  logic                  func_cfg_cq2priov_odd_mem_re
    ,input  logic [(       5)-1:0] func_cfg_cq2priov_odd_mem_addr
    ,input  logic                  func_cfg_cq2priov_odd_mem_we
    ,input  logic [(      33)-1:0] func_cfg_cq2priov_odd_mem_wdata
    ,output logic [(      33)-1:0] func_cfg_cq2priov_odd_mem_rdata

    ,input  logic                  pf_cfg_cq2priov_odd_mem_re
    ,input  logic [(       5)-1:0] pf_cfg_cq2priov_odd_mem_addr
    ,input  logic                  pf_cfg_cq2priov_odd_mem_we
    ,input  logic [(      33)-1:0] pf_cfg_cq2priov_odd_mem_wdata
    ,output logic [(      33)-1:0] pf_cfg_cq2priov_odd_mem_rdata

    ,output logic                  rf_cfg_cq2priov_odd_mem_re
    ,output logic                  rf_cfg_cq2priov_odd_mem_rclk
    ,output logic                  rf_cfg_cq2priov_odd_mem_rclk_rst_n
    ,output logic [(       5)-1:0] rf_cfg_cq2priov_odd_mem_raddr
    ,output logic [(       5)-1:0] rf_cfg_cq2priov_odd_mem_waddr
    ,output logic                  rf_cfg_cq2priov_odd_mem_we
    ,output logic                  rf_cfg_cq2priov_odd_mem_wclk
    ,output logic                  rf_cfg_cq2priov_odd_mem_wclk_rst_n
    ,output logic [(      33)-1:0] rf_cfg_cq2priov_odd_mem_wdata
    ,input  logic [(      33)-1:0] rf_cfg_cq2priov_odd_mem_rdata

    ,output logic                  rf_cfg_cq2priov_odd_mem_error

    ,input  logic                  func_cfg_cq2qid_0_mem_re
    ,input  logic [(       5)-1:0] func_cfg_cq2qid_0_mem_addr
    ,input  logic                  func_cfg_cq2qid_0_mem_we
    ,input  logic [(      29)-1:0] func_cfg_cq2qid_0_mem_wdata
    ,output logic [(      29)-1:0] func_cfg_cq2qid_0_mem_rdata

    ,input  logic                  pf_cfg_cq2qid_0_mem_re
    ,input  logic [(       5)-1:0] pf_cfg_cq2qid_0_mem_addr
    ,input  logic                  pf_cfg_cq2qid_0_mem_we
    ,input  logic [(      29)-1:0] pf_cfg_cq2qid_0_mem_wdata
    ,output logic [(      29)-1:0] pf_cfg_cq2qid_0_mem_rdata

    ,output logic                  rf_cfg_cq2qid_0_mem_re
    ,output logic                  rf_cfg_cq2qid_0_mem_rclk
    ,output logic                  rf_cfg_cq2qid_0_mem_rclk_rst_n
    ,output logic [(       5)-1:0] rf_cfg_cq2qid_0_mem_raddr
    ,output logic [(       5)-1:0] rf_cfg_cq2qid_0_mem_waddr
    ,output logic                  rf_cfg_cq2qid_0_mem_we
    ,output logic                  rf_cfg_cq2qid_0_mem_wclk
    ,output logic                  rf_cfg_cq2qid_0_mem_wclk_rst_n
    ,output logic [(      29)-1:0] rf_cfg_cq2qid_0_mem_wdata
    ,input  logic [(      29)-1:0] rf_cfg_cq2qid_0_mem_rdata

    ,output logic                  rf_cfg_cq2qid_0_mem_error

    ,input  logic                  func_cfg_cq2qid_0_odd_mem_re
    ,input  logic [(       5)-1:0] func_cfg_cq2qid_0_odd_mem_addr
    ,input  logic                  func_cfg_cq2qid_0_odd_mem_we
    ,input  logic [(      29)-1:0] func_cfg_cq2qid_0_odd_mem_wdata
    ,output logic [(      29)-1:0] func_cfg_cq2qid_0_odd_mem_rdata

    ,input  logic                  pf_cfg_cq2qid_0_odd_mem_re
    ,input  logic [(       5)-1:0] pf_cfg_cq2qid_0_odd_mem_addr
    ,input  logic                  pf_cfg_cq2qid_0_odd_mem_we
    ,input  logic [(      29)-1:0] pf_cfg_cq2qid_0_odd_mem_wdata
    ,output logic [(      29)-1:0] pf_cfg_cq2qid_0_odd_mem_rdata

    ,output logic                  rf_cfg_cq2qid_0_odd_mem_re
    ,output logic                  rf_cfg_cq2qid_0_odd_mem_rclk
    ,output logic                  rf_cfg_cq2qid_0_odd_mem_rclk_rst_n
    ,output logic [(       5)-1:0] rf_cfg_cq2qid_0_odd_mem_raddr
    ,output logic [(       5)-1:0] rf_cfg_cq2qid_0_odd_mem_waddr
    ,output logic                  rf_cfg_cq2qid_0_odd_mem_we
    ,output logic                  rf_cfg_cq2qid_0_odd_mem_wclk
    ,output logic                  rf_cfg_cq2qid_0_odd_mem_wclk_rst_n
    ,output logic [(      29)-1:0] rf_cfg_cq2qid_0_odd_mem_wdata
    ,input  logic [(      29)-1:0] rf_cfg_cq2qid_0_odd_mem_rdata

    ,output logic                  rf_cfg_cq2qid_0_odd_mem_error

    ,input  logic                  func_cfg_cq2qid_1_mem_re
    ,input  logic [(       5)-1:0] func_cfg_cq2qid_1_mem_addr
    ,input  logic                  func_cfg_cq2qid_1_mem_we
    ,input  logic [(      29)-1:0] func_cfg_cq2qid_1_mem_wdata
    ,output logic [(      29)-1:0] func_cfg_cq2qid_1_mem_rdata

    ,input  logic                  pf_cfg_cq2qid_1_mem_re
    ,input  logic [(       5)-1:0] pf_cfg_cq2qid_1_mem_addr
    ,input  logic                  pf_cfg_cq2qid_1_mem_we
    ,input  logic [(      29)-1:0] pf_cfg_cq2qid_1_mem_wdata
    ,output logic [(      29)-1:0] pf_cfg_cq2qid_1_mem_rdata

    ,output logic                  rf_cfg_cq2qid_1_mem_re
    ,output logic                  rf_cfg_cq2qid_1_mem_rclk
    ,output logic                  rf_cfg_cq2qid_1_mem_rclk_rst_n
    ,output logic [(       5)-1:0] rf_cfg_cq2qid_1_mem_raddr
    ,output logic [(       5)-1:0] rf_cfg_cq2qid_1_mem_waddr
    ,output logic                  rf_cfg_cq2qid_1_mem_we
    ,output logic                  rf_cfg_cq2qid_1_mem_wclk
    ,output logic                  rf_cfg_cq2qid_1_mem_wclk_rst_n
    ,output logic [(      29)-1:0] rf_cfg_cq2qid_1_mem_wdata
    ,input  logic [(      29)-1:0] rf_cfg_cq2qid_1_mem_rdata

    ,output logic                  rf_cfg_cq2qid_1_mem_error

    ,input  logic                  func_cfg_cq2qid_1_odd_mem_re
    ,input  logic [(       5)-1:0] func_cfg_cq2qid_1_odd_mem_addr
    ,input  logic                  func_cfg_cq2qid_1_odd_mem_we
    ,input  logic [(      29)-1:0] func_cfg_cq2qid_1_odd_mem_wdata
    ,output logic [(      29)-1:0] func_cfg_cq2qid_1_odd_mem_rdata

    ,input  logic                  pf_cfg_cq2qid_1_odd_mem_re
    ,input  logic [(       5)-1:0] pf_cfg_cq2qid_1_odd_mem_addr
    ,input  logic                  pf_cfg_cq2qid_1_odd_mem_we
    ,input  logic [(      29)-1:0] pf_cfg_cq2qid_1_odd_mem_wdata
    ,output logic [(      29)-1:0] pf_cfg_cq2qid_1_odd_mem_rdata

    ,output logic                  rf_cfg_cq2qid_1_odd_mem_re
    ,output logic                  rf_cfg_cq2qid_1_odd_mem_rclk
    ,output logic                  rf_cfg_cq2qid_1_odd_mem_rclk_rst_n
    ,output logic [(       5)-1:0] rf_cfg_cq2qid_1_odd_mem_raddr
    ,output logic [(       5)-1:0] rf_cfg_cq2qid_1_odd_mem_waddr
    ,output logic                  rf_cfg_cq2qid_1_odd_mem_we
    ,output logic                  rf_cfg_cq2qid_1_odd_mem_wclk
    ,output logic                  rf_cfg_cq2qid_1_odd_mem_wclk_rst_n
    ,output logic [(      29)-1:0] rf_cfg_cq2qid_1_odd_mem_wdata
    ,input  logic [(      29)-1:0] rf_cfg_cq2qid_1_odd_mem_rdata

    ,output logic                  rf_cfg_cq2qid_1_odd_mem_error

    ,input  logic                  func_cfg_cq_ldb_inflight_limit_mem_re
    ,input  logic [(       6)-1:0] func_cfg_cq_ldb_inflight_limit_mem_addr
    ,input  logic                  func_cfg_cq_ldb_inflight_limit_mem_we
    ,input  logic [(      14)-1:0] func_cfg_cq_ldb_inflight_limit_mem_wdata
    ,output logic [(      14)-1:0] func_cfg_cq_ldb_inflight_limit_mem_rdata

    ,input  logic                  pf_cfg_cq_ldb_inflight_limit_mem_re
    ,input  logic [(       6)-1:0] pf_cfg_cq_ldb_inflight_limit_mem_addr
    ,input  logic                  pf_cfg_cq_ldb_inflight_limit_mem_we
    ,input  logic [(      14)-1:0] pf_cfg_cq_ldb_inflight_limit_mem_wdata
    ,output logic [(      14)-1:0] pf_cfg_cq_ldb_inflight_limit_mem_rdata

    ,output logic                  rf_cfg_cq_ldb_inflight_limit_mem_re
    ,output logic                  rf_cfg_cq_ldb_inflight_limit_mem_rclk
    ,output logic                  rf_cfg_cq_ldb_inflight_limit_mem_rclk_rst_n
    ,output logic [(       6)-1:0] rf_cfg_cq_ldb_inflight_limit_mem_raddr
    ,output logic [(       6)-1:0] rf_cfg_cq_ldb_inflight_limit_mem_waddr
    ,output logic                  rf_cfg_cq_ldb_inflight_limit_mem_we
    ,output logic                  rf_cfg_cq_ldb_inflight_limit_mem_wclk
    ,output logic                  rf_cfg_cq_ldb_inflight_limit_mem_wclk_rst_n
    ,output logic [(      14)-1:0] rf_cfg_cq_ldb_inflight_limit_mem_wdata
    ,input  logic [(      14)-1:0] rf_cfg_cq_ldb_inflight_limit_mem_rdata

    ,output logic                  rf_cfg_cq_ldb_inflight_limit_mem_error

    ,input  logic                  func_cfg_cq_ldb_inflight_threshold_mem_re
    ,input  logic [(       6)-1:0] func_cfg_cq_ldb_inflight_threshold_mem_addr
    ,input  logic                  func_cfg_cq_ldb_inflight_threshold_mem_we
    ,input  logic [(      14)-1:0] func_cfg_cq_ldb_inflight_threshold_mem_wdata
    ,output logic [(      14)-1:0] func_cfg_cq_ldb_inflight_threshold_mem_rdata

    ,input  logic                  pf_cfg_cq_ldb_inflight_threshold_mem_re
    ,input  logic [(       6)-1:0] pf_cfg_cq_ldb_inflight_threshold_mem_addr
    ,input  logic                  pf_cfg_cq_ldb_inflight_threshold_mem_we
    ,input  logic [(      14)-1:0] pf_cfg_cq_ldb_inflight_threshold_mem_wdata
    ,output logic [(      14)-1:0] pf_cfg_cq_ldb_inflight_threshold_mem_rdata

    ,output logic                  rf_cfg_cq_ldb_inflight_threshold_mem_re
    ,output logic                  rf_cfg_cq_ldb_inflight_threshold_mem_rclk
    ,output logic                  rf_cfg_cq_ldb_inflight_threshold_mem_rclk_rst_n
    ,output logic [(       6)-1:0] rf_cfg_cq_ldb_inflight_threshold_mem_raddr
    ,output logic [(       6)-1:0] rf_cfg_cq_ldb_inflight_threshold_mem_waddr
    ,output logic                  rf_cfg_cq_ldb_inflight_threshold_mem_we
    ,output logic                  rf_cfg_cq_ldb_inflight_threshold_mem_wclk
    ,output logic                  rf_cfg_cq_ldb_inflight_threshold_mem_wclk_rst_n
    ,output logic [(      14)-1:0] rf_cfg_cq_ldb_inflight_threshold_mem_wdata
    ,input  logic [(      14)-1:0] rf_cfg_cq_ldb_inflight_threshold_mem_rdata

    ,output logic                  rf_cfg_cq_ldb_inflight_threshold_mem_error

    ,input  logic                  func_cfg_cq_ldb_token_depth_select_mem_re
    ,input  logic [(       6)-1:0] func_cfg_cq_ldb_token_depth_select_mem_addr
    ,input  logic                  func_cfg_cq_ldb_token_depth_select_mem_we
    ,input  logic [(       5)-1:0] func_cfg_cq_ldb_token_depth_select_mem_wdata
    ,output logic [(       5)-1:0] func_cfg_cq_ldb_token_depth_select_mem_rdata

    ,input  logic                  pf_cfg_cq_ldb_token_depth_select_mem_re
    ,input  logic [(       6)-1:0] pf_cfg_cq_ldb_token_depth_select_mem_addr
    ,input  logic                  pf_cfg_cq_ldb_token_depth_select_mem_we
    ,input  logic [(       5)-1:0] pf_cfg_cq_ldb_token_depth_select_mem_wdata
    ,output logic [(       5)-1:0] pf_cfg_cq_ldb_token_depth_select_mem_rdata

    ,output logic                  rf_cfg_cq_ldb_token_depth_select_mem_re
    ,output logic                  rf_cfg_cq_ldb_token_depth_select_mem_rclk
    ,output logic                  rf_cfg_cq_ldb_token_depth_select_mem_rclk_rst_n
    ,output logic [(       6)-1:0] rf_cfg_cq_ldb_token_depth_select_mem_raddr
    ,output logic [(       6)-1:0] rf_cfg_cq_ldb_token_depth_select_mem_waddr
    ,output logic                  rf_cfg_cq_ldb_token_depth_select_mem_we
    ,output logic                  rf_cfg_cq_ldb_token_depth_select_mem_wclk
    ,output logic                  rf_cfg_cq_ldb_token_depth_select_mem_wclk_rst_n
    ,output logic [(       5)-1:0] rf_cfg_cq_ldb_token_depth_select_mem_wdata
    ,input  logic [(       5)-1:0] rf_cfg_cq_ldb_token_depth_select_mem_rdata

    ,output logic                  rf_cfg_cq_ldb_token_depth_select_mem_error

    ,input  logic                  func_cfg_cq_ldb_wu_limit_mem_re
    ,input  logic [(       6)-1:0] func_cfg_cq_ldb_wu_limit_mem_raddr
    ,input  logic [(       6)-1:0] func_cfg_cq_ldb_wu_limit_mem_waddr
    ,input  logic                  func_cfg_cq_ldb_wu_limit_mem_we
    ,input  logic [(      17)-1:0] func_cfg_cq_ldb_wu_limit_mem_wdata
    ,output logic [(      17)-1:0] func_cfg_cq_ldb_wu_limit_mem_rdata

    ,input  logic                  pf_cfg_cq_ldb_wu_limit_mem_re
    ,input  logic [(       6)-1:0] pf_cfg_cq_ldb_wu_limit_mem_raddr
    ,input  logic [(       6)-1:0] pf_cfg_cq_ldb_wu_limit_mem_waddr
    ,input  logic                  pf_cfg_cq_ldb_wu_limit_mem_we
    ,input  logic [(      17)-1:0] pf_cfg_cq_ldb_wu_limit_mem_wdata
    ,output logic [(      17)-1:0] pf_cfg_cq_ldb_wu_limit_mem_rdata

    ,output logic                  rf_cfg_cq_ldb_wu_limit_mem_re
    ,output logic                  rf_cfg_cq_ldb_wu_limit_mem_rclk
    ,output logic                  rf_cfg_cq_ldb_wu_limit_mem_rclk_rst_n
    ,output logic [(       6)-1:0] rf_cfg_cq_ldb_wu_limit_mem_raddr
    ,output logic [(       6)-1:0] rf_cfg_cq_ldb_wu_limit_mem_waddr
    ,output logic                  rf_cfg_cq_ldb_wu_limit_mem_we
    ,output logic                  rf_cfg_cq_ldb_wu_limit_mem_wclk
    ,output logic                  rf_cfg_cq_ldb_wu_limit_mem_wclk_rst_n
    ,output logic [(      17)-1:0] rf_cfg_cq_ldb_wu_limit_mem_wdata
    ,input  logic [(      17)-1:0] rf_cfg_cq_ldb_wu_limit_mem_rdata

    ,output logic                  rf_cfg_cq_ldb_wu_limit_mem_error

    ,input  logic                  func_cfg_dir_qid_dpth_thrsh_mem_re
    ,input  logic [(       7)-1:0] func_cfg_dir_qid_dpth_thrsh_mem_addr
    ,input  logic                  func_cfg_dir_qid_dpth_thrsh_mem_we
    ,input  logic [(      16)-1:0] func_cfg_dir_qid_dpth_thrsh_mem_wdata
    ,output logic [(      16)-1:0] func_cfg_dir_qid_dpth_thrsh_mem_rdata

    ,input  logic                  pf_cfg_dir_qid_dpth_thrsh_mem_re
    ,input  logic [(       7)-1:0] pf_cfg_dir_qid_dpth_thrsh_mem_addr
    ,input  logic                  pf_cfg_dir_qid_dpth_thrsh_mem_we
    ,input  logic [(      16)-1:0] pf_cfg_dir_qid_dpth_thrsh_mem_wdata
    ,output logic [(      16)-1:0] pf_cfg_dir_qid_dpth_thrsh_mem_rdata

    ,output logic                  rf_cfg_dir_qid_dpth_thrsh_mem_re
    ,output logic                  rf_cfg_dir_qid_dpth_thrsh_mem_rclk
    ,output logic                  rf_cfg_dir_qid_dpth_thrsh_mem_rclk_rst_n
    ,output logic [(       6)-1:0] rf_cfg_dir_qid_dpth_thrsh_mem_raddr
    ,output logic [(       6)-1:0] rf_cfg_dir_qid_dpth_thrsh_mem_waddr
    ,output logic                  rf_cfg_dir_qid_dpth_thrsh_mem_we
    ,output logic                  rf_cfg_dir_qid_dpth_thrsh_mem_wclk
    ,output logic                  rf_cfg_dir_qid_dpth_thrsh_mem_wclk_rst_n
    ,output logic [(      16)-1:0] rf_cfg_dir_qid_dpth_thrsh_mem_wdata
    ,input  logic [(      16)-1:0] rf_cfg_dir_qid_dpth_thrsh_mem_rdata

    ,output logic                  rf_cfg_dir_qid_dpth_thrsh_mem_error

    ,input  logic                  func_cfg_nalb_qid_dpth_thrsh_mem_re
    ,input  logic [(       7)-1:0] func_cfg_nalb_qid_dpth_thrsh_mem_addr
    ,input  logic                  func_cfg_nalb_qid_dpth_thrsh_mem_we
    ,input  logic [(      16)-1:0] func_cfg_nalb_qid_dpth_thrsh_mem_wdata
    ,output logic [(      16)-1:0] func_cfg_nalb_qid_dpth_thrsh_mem_rdata

    ,input  logic                  pf_cfg_nalb_qid_dpth_thrsh_mem_re
    ,input  logic [(       7)-1:0] pf_cfg_nalb_qid_dpth_thrsh_mem_addr
    ,input  logic                  pf_cfg_nalb_qid_dpth_thrsh_mem_we
    ,input  logic [(      16)-1:0] pf_cfg_nalb_qid_dpth_thrsh_mem_wdata
    ,output logic [(      16)-1:0] pf_cfg_nalb_qid_dpth_thrsh_mem_rdata

    ,output logic                  rf_cfg_nalb_qid_dpth_thrsh_mem_re
    ,output logic                  rf_cfg_nalb_qid_dpth_thrsh_mem_rclk
    ,output logic                  rf_cfg_nalb_qid_dpth_thrsh_mem_rclk_rst_n
    ,output logic [(       5)-1:0] rf_cfg_nalb_qid_dpth_thrsh_mem_raddr
    ,output logic [(       5)-1:0] rf_cfg_nalb_qid_dpth_thrsh_mem_waddr
    ,output logic                  rf_cfg_nalb_qid_dpth_thrsh_mem_we
    ,output logic                  rf_cfg_nalb_qid_dpth_thrsh_mem_wclk
    ,output logic                  rf_cfg_nalb_qid_dpth_thrsh_mem_wclk_rst_n
    ,output logic [(      16)-1:0] rf_cfg_nalb_qid_dpth_thrsh_mem_wdata
    ,input  logic [(      16)-1:0] rf_cfg_nalb_qid_dpth_thrsh_mem_rdata

    ,output logic                  rf_cfg_nalb_qid_dpth_thrsh_mem_error

    ,input  logic                  func_cfg_qid_aqed_active_limit_mem_re
    ,input  logic [(       7)-1:0] func_cfg_qid_aqed_active_limit_mem_addr
    ,input  logic                  func_cfg_qid_aqed_active_limit_mem_we
    ,input  logic [(      13)-1:0] func_cfg_qid_aqed_active_limit_mem_wdata
    ,output logic [(      13)-1:0] func_cfg_qid_aqed_active_limit_mem_rdata

    ,input  logic                  pf_cfg_qid_aqed_active_limit_mem_re
    ,input  logic [(       7)-1:0] pf_cfg_qid_aqed_active_limit_mem_addr
    ,input  logic                  pf_cfg_qid_aqed_active_limit_mem_we
    ,input  logic [(      13)-1:0] pf_cfg_qid_aqed_active_limit_mem_wdata
    ,output logic [(      13)-1:0] pf_cfg_qid_aqed_active_limit_mem_rdata

    ,output logic                  rf_cfg_qid_aqed_active_limit_mem_re
    ,output logic                  rf_cfg_qid_aqed_active_limit_mem_rclk
    ,output logic                  rf_cfg_qid_aqed_active_limit_mem_rclk_rst_n
    ,output logic [(       5)-1:0] rf_cfg_qid_aqed_active_limit_mem_raddr
    ,output logic [(       5)-1:0] rf_cfg_qid_aqed_active_limit_mem_waddr
    ,output logic                  rf_cfg_qid_aqed_active_limit_mem_we
    ,output logic                  rf_cfg_qid_aqed_active_limit_mem_wclk
    ,output logic                  rf_cfg_qid_aqed_active_limit_mem_wclk_rst_n
    ,output logic [(      13)-1:0] rf_cfg_qid_aqed_active_limit_mem_wdata
    ,input  logic [(      13)-1:0] rf_cfg_qid_aqed_active_limit_mem_rdata

    ,output logic                  rf_cfg_qid_aqed_active_limit_mem_error

    ,input  logic                  func_cfg_qid_ldb_inflight_limit_mem_re
    ,input  logic [(       7)-1:0] func_cfg_qid_ldb_inflight_limit_mem_addr
    ,input  logic                  func_cfg_qid_ldb_inflight_limit_mem_we
    ,input  logic [(      13)-1:0] func_cfg_qid_ldb_inflight_limit_mem_wdata
    ,output logic [(      13)-1:0] func_cfg_qid_ldb_inflight_limit_mem_rdata

    ,input  logic                  pf_cfg_qid_ldb_inflight_limit_mem_re
    ,input  logic [(       7)-1:0] pf_cfg_qid_ldb_inflight_limit_mem_addr
    ,input  logic                  pf_cfg_qid_ldb_inflight_limit_mem_we
    ,input  logic [(      13)-1:0] pf_cfg_qid_ldb_inflight_limit_mem_wdata
    ,output logic [(      13)-1:0] pf_cfg_qid_ldb_inflight_limit_mem_rdata

    ,output logic                  rf_cfg_qid_ldb_inflight_limit_mem_re
    ,output logic                  rf_cfg_qid_ldb_inflight_limit_mem_rclk
    ,output logic                  rf_cfg_qid_ldb_inflight_limit_mem_rclk_rst_n
    ,output logic [(       5)-1:0] rf_cfg_qid_ldb_inflight_limit_mem_raddr
    ,output logic [(       5)-1:0] rf_cfg_qid_ldb_inflight_limit_mem_waddr
    ,output logic                  rf_cfg_qid_ldb_inflight_limit_mem_we
    ,output logic                  rf_cfg_qid_ldb_inflight_limit_mem_wclk
    ,output logic                  rf_cfg_qid_ldb_inflight_limit_mem_wclk_rst_n
    ,output logic [(      13)-1:0] rf_cfg_qid_ldb_inflight_limit_mem_wdata
    ,input  logic [(      13)-1:0] rf_cfg_qid_ldb_inflight_limit_mem_rdata

    ,output logic                  rf_cfg_qid_ldb_inflight_limit_mem_error

    ,input  logic                  func_cfg_qid_ldb_qid2cqidix2_mem_re
    ,input  logic [(       7)-1:0] func_cfg_qid_ldb_qid2cqidix2_mem_addr
    ,input  logic                  func_cfg_qid_ldb_qid2cqidix2_mem_we
    ,input  logic [(     528)-1:0] func_cfg_qid_ldb_qid2cqidix2_mem_wdata
    ,output logic [(     528)-1:0] func_cfg_qid_ldb_qid2cqidix2_mem_rdata

    ,input  logic                  pf_cfg_qid_ldb_qid2cqidix2_mem_re
    ,input  logic [(       7)-1:0] pf_cfg_qid_ldb_qid2cqidix2_mem_addr
    ,input  logic                  pf_cfg_qid_ldb_qid2cqidix2_mem_we
    ,input  logic [(     528)-1:0] pf_cfg_qid_ldb_qid2cqidix2_mem_wdata
    ,output logic [(     528)-1:0] pf_cfg_qid_ldb_qid2cqidix2_mem_rdata

    ,output logic                  rf_cfg_qid_ldb_qid2cqidix2_mem_re
    ,output logic                  rf_cfg_qid_ldb_qid2cqidix2_mem_rclk
    ,output logic                  rf_cfg_qid_ldb_qid2cqidix2_mem_rclk_rst_n
    ,output logic [(       5)-1:0] rf_cfg_qid_ldb_qid2cqidix2_mem_raddr
    ,output logic [(       5)-1:0] rf_cfg_qid_ldb_qid2cqidix2_mem_waddr
    ,output logic                  rf_cfg_qid_ldb_qid2cqidix2_mem_we
    ,output logic                  rf_cfg_qid_ldb_qid2cqidix2_mem_wclk
    ,output logic                  rf_cfg_qid_ldb_qid2cqidix2_mem_wclk_rst_n
    ,output logic [(     528)-1:0] rf_cfg_qid_ldb_qid2cqidix2_mem_wdata
    ,input  logic [(     528)-1:0] rf_cfg_qid_ldb_qid2cqidix2_mem_rdata

    ,output logic                  rf_cfg_qid_ldb_qid2cqidix2_mem_error

    ,input  logic                  func_cfg_qid_ldb_qid2cqidix_mem_re
    ,input  logic [(       7)-1:0] func_cfg_qid_ldb_qid2cqidix_mem_addr
    ,input  logic                  func_cfg_qid_ldb_qid2cqidix_mem_we
    ,input  logic [(     528)-1:0] func_cfg_qid_ldb_qid2cqidix_mem_wdata
    ,output logic [(     528)-1:0] func_cfg_qid_ldb_qid2cqidix_mem_rdata

    ,input  logic                  pf_cfg_qid_ldb_qid2cqidix_mem_re
    ,input  logic [(       7)-1:0] pf_cfg_qid_ldb_qid2cqidix_mem_addr
    ,input  logic                  pf_cfg_qid_ldb_qid2cqidix_mem_we
    ,input  logic [(     528)-1:0] pf_cfg_qid_ldb_qid2cqidix_mem_wdata
    ,output logic [(     528)-1:0] pf_cfg_qid_ldb_qid2cqidix_mem_rdata

    ,output logic                  rf_cfg_qid_ldb_qid2cqidix_mem_re
    ,output logic                  rf_cfg_qid_ldb_qid2cqidix_mem_rclk
    ,output logic                  rf_cfg_qid_ldb_qid2cqidix_mem_rclk_rst_n
    ,output logic [(       5)-1:0] rf_cfg_qid_ldb_qid2cqidix_mem_raddr
    ,output logic [(       5)-1:0] rf_cfg_qid_ldb_qid2cqidix_mem_waddr
    ,output logic                  rf_cfg_qid_ldb_qid2cqidix_mem_we
    ,output logic                  rf_cfg_qid_ldb_qid2cqidix_mem_wclk
    ,output logic                  rf_cfg_qid_ldb_qid2cqidix_mem_wclk_rst_n
    ,output logic [(     528)-1:0] rf_cfg_qid_ldb_qid2cqidix_mem_wdata
    ,input  logic [(     528)-1:0] rf_cfg_qid_ldb_qid2cqidix_mem_rdata

    ,output logic                  rf_cfg_qid_ldb_qid2cqidix_mem_error

    ,input  logic                  func_chp_lsp_cmp_rx_sync_fifo_mem_re
    ,input  logic [(       2)-1:0] func_chp_lsp_cmp_rx_sync_fifo_mem_raddr
    ,input  logic [(       2)-1:0] func_chp_lsp_cmp_rx_sync_fifo_mem_waddr
    ,input  logic                  func_chp_lsp_cmp_rx_sync_fifo_mem_we
    ,input  logic [(      73)-1:0] func_chp_lsp_cmp_rx_sync_fifo_mem_wdata
    ,output logic [(      73)-1:0] func_chp_lsp_cmp_rx_sync_fifo_mem_rdata

    ,input  logic                  pf_chp_lsp_cmp_rx_sync_fifo_mem_re
    ,input  logic [(       2)-1:0] pf_chp_lsp_cmp_rx_sync_fifo_mem_raddr
    ,input  logic [(       2)-1:0] pf_chp_lsp_cmp_rx_sync_fifo_mem_waddr
    ,input  logic                  pf_chp_lsp_cmp_rx_sync_fifo_mem_we
    ,input  logic [(      73)-1:0] pf_chp_lsp_cmp_rx_sync_fifo_mem_wdata
    ,output logic [(      73)-1:0] pf_chp_lsp_cmp_rx_sync_fifo_mem_rdata

    ,output logic                  rf_chp_lsp_cmp_rx_sync_fifo_mem_re
    ,output logic                  rf_chp_lsp_cmp_rx_sync_fifo_mem_rclk
    ,output logic                  rf_chp_lsp_cmp_rx_sync_fifo_mem_rclk_rst_n
    ,output logic [(       2)-1:0] rf_chp_lsp_cmp_rx_sync_fifo_mem_raddr
    ,output logic [(       2)-1:0] rf_chp_lsp_cmp_rx_sync_fifo_mem_waddr
    ,output logic                  rf_chp_lsp_cmp_rx_sync_fifo_mem_we
    ,output logic                  rf_chp_lsp_cmp_rx_sync_fifo_mem_wclk
    ,output logic                  rf_chp_lsp_cmp_rx_sync_fifo_mem_wclk_rst_n
    ,output logic [(      73)-1:0] rf_chp_lsp_cmp_rx_sync_fifo_mem_wdata
    ,input  logic [(      73)-1:0] rf_chp_lsp_cmp_rx_sync_fifo_mem_rdata

    ,output logic                  rf_chp_lsp_cmp_rx_sync_fifo_mem_error

    ,input  logic                  func_chp_lsp_token_rx_sync_fifo_mem_re
    ,input  logic [(       2)-1:0] func_chp_lsp_token_rx_sync_fifo_mem_raddr
    ,input  logic [(       2)-1:0] func_chp_lsp_token_rx_sync_fifo_mem_waddr
    ,input  logic                  func_chp_lsp_token_rx_sync_fifo_mem_we
    ,input  logic [(      25)-1:0] func_chp_lsp_token_rx_sync_fifo_mem_wdata
    ,output logic [(      25)-1:0] func_chp_lsp_token_rx_sync_fifo_mem_rdata

    ,input  logic                  pf_chp_lsp_token_rx_sync_fifo_mem_re
    ,input  logic [(       2)-1:0] pf_chp_lsp_token_rx_sync_fifo_mem_raddr
    ,input  logic [(       2)-1:0] pf_chp_lsp_token_rx_sync_fifo_mem_waddr
    ,input  logic                  pf_chp_lsp_token_rx_sync_fifo_mem_we
    ,input  logic [(      25)-1:0] pf_chp_lsp_token_rx_sync_fifo_mem_wdata
    ,output logic [(      25)-1:0] pf_chp_lsp_token_rx_sync_fifo_mem_rdata

    ,output logic                  rf_chp_lsp_token_rx_sync_fifo_mem_re
    ,output logic                  rf_chp_lsp_token_rx_sync_fifo_mem_rclk
    ,output logic                  rf_chp_lsp_token_rx_sync_fifo_mem_rclk_rst_n
    ,output logic [(       2)-1:0] rf_chp_lsp_token_rx_sync_fifo_mem_raddr
    ,output logic [(       2)-1:0] rf_chp_lsp_token_rx_sync_fifo_mem_waddr
    ,output logic                  rf_chp_lsp_token_rx_sync_fifo_mem_we
    ,output logic                  rf_chp_lsp_token_rx_sync_fifo_mem_wclk
    ,output logic                  rf_chp_lsp_token_rx_sync_fifo_mem_wclk_rst_n
    ,output logic [(      25)-1:0] rf_chp_lsp_token_rx_sync_fifo_mem_wdata
    ,input  logic [(      25)-1:0] rf_chp_lsp_token_rx_sync_fifo_mem_rdata

    ,output logic                  rf_chp_lsp_token_rx_sync_fifo_mem_error

    ,input  logic                  func_cq_atm_pri_arbindex_mem_re
    ,input  logic [(       5)-1:0] func_cq_atm_pri_arbindex_mem_raddr
    ,input  logic [(       5)-1:0] func_cq_atm_pri_arbindex_mem_waddr
    ,input  logic                  func_cq_atm_pri_arbindex_mem_we
    ,input  logic [(      96)-1:0] func_cq_atm_pri_arbindex_mem_wdata
    ,output logic [(      96)-1:0] func_cq_atm_pri_arbindex_mem_rdata

    ,input  logic                  pf_cq_atm_pri_arbindex_mem_re
    ,input  logic [(       5)-1:0] pf_cq_atm_pri_arbindex_mem_raddr
    ,input  logic [(       5)-1:0] pf_cq_atm_pri_arbindex_mem_waddr
    ,input  logic                  pf_cq_atm_pri_arbindex_mem_we
    ,input  logic [(      96)-1:0] pf_cq_atm_pri_arbindex_mem_wdata
    ,output logic [(      96)-1:0] pf_cq_atm_pri_arbindex_mem_rdata

    ,output logic                  rf_cq_atm_pri_arbindex_mem_re
    ,output logic                  rf_cq_atm_pri_arbindex_mem_rclk
    ,output logic                  rf_cq_atm_pri_arbindex_mem_rclk_rst_n
    ,output logic [(       5)-1:0] rf_cq_atm_pri_arbindex_mem_raddr
    ,output logic [(       5)-1:0] rf_cq_atm_pri_arbindex_mem_waddr
    ,output logic                  rf_cq_atm_pri_arbindex_mem_we
    ,output logic                  rf_cq_atm_pri_arbindex_mem_wclk
    ,output logic                  rf_cq_atm_pri_arbindex_mem_wclk_rst_n
    ,output logic [(      96)-1:0] rf_cq_atm_pri_arbindex_mem_wdata
    ,input  logic [(      96)-1:0] rf_cq_atm_pri_arbindex_mem_rdata

    ,output logic                  rf_cq_atm_pri_arbindex_mem_error

    ,input  logic                  func_cq_dir_tot_sch_cnt_mem_re
    ,input  logic [(       7)-1:0] func_cq_dir_tot_sch_cnt_mem_raddr
    ,input  logic [(       7)-1:0] func_cq_dir_tot_sch_cnt_mem_waddr
    ,input  logic                  func_cq_dir_tot_sch_cnt_mem_we
    ,input  logic [(      66)-1:0] func_cq_dir_tot_sch_cnt_mem_wdata
    ,output logic [(      66)-1:0] func_cq_dir_tot_sch_cnt_mem_rdata

    ,input  logic                  pf_cq_dir_tot_sch_cnt_mem_re
    ,input  logic [(       7)-1:0] pf_cq_dir_tot_sch_cnt_mem_raddr
    ,input  logic [(       7)-1:0] pf_cq_dir_tot_sch_cnt_mem_waddr
    ,input  logic                  pf_cq_dir_tot_sch_cnt_mem_we
    ,input  logic [(      66)-1:0] pf_cq_dir_tot_sch_cnt_mem_wdata
    ,output logic [(      66)-1:0] pf_cq_dir_tot_sch_cnt_mem_rdata

    ,output logic                  rf_cq_dir_tot_sch_cnt_mem_re
    ,output logic                  rf_cq_dir_tot_sch_cnt_mem_rclk
    ,output logic                  rf_cq_dir_tot_sch_cnt_mem_rclk_rst_n
    ,output logic [(       6)-1:0] rf_cq_dir_tot_sch_cnt_mem_raddr
    ,output logic [(       6)-1:0] rf_cq_dir_tot_sch_cnt_mem_waddr
    ,output logic                  rf_cq_dir_tot_sch_cnt_mem_we
    ,output logic                  rf_cq_dir_tot_sch_cnt_mem_wclk
    ,output logic                  rf_cq_dir_tot_sch_cnt_mem_wclk_rst_n
    ,output logic [(      66)-1:0] rf_cq_dir_tot_sch_cnt_mem_wdata
    ,input  logic [(      66)-1:0] rf_cq_dir_tot_sch_cnt_mem_rdata

    ,output logic                  rf_cq_dir_tot_sch_cnt_mem_error

    ,input  logic                  func_cq_ldb_inflight_count_mem_re
    ,input  logic [(       6)-1:0] func_cq_ldb_inflight_count_mem_raddr
    ,input  logic [(       6)-1:0] func_cq_ldb_inflight_count_mem_waddr
    ,input  logic                  func_cq_ldb_inflight_count_mem_we
    ,input  logic [(      15)-1:0] func_cq_ldb_inflight_count_mem_wdata
    ,output logic [(      15)-1:0] func_cq_ldb_inflight_count_mem_rdata

    ,input  logic                  pf_cq_ldb_inflight_count_mem_re
    ,input  logic [(       6)-1:0] pf_cq_ldb_inflight_count_mem_raddr
    ,input  logic [(       6)-1:0] pf_cq_ldb_inflight_count_mem_waddr
    ,input  logic                  pf_cq_ldb_inflight_count_mem_we
    ,input  logic [(      15)-1:0] pf_cq_ldb_inflight_count_mem_wdata
    ,output logic [(      15)-1:0] pf_cq_ldb_inflight_count_mem_rdata

    ,output logic                  rf_cq_ldb_inflight_count_mem_re
    ,output logic                  rf_cq_ldb_inflight_count_mem_rclk
    ,output logic                  rf_cq_ldb_inflight_count_mem_rclk_rst_n
    ,output logic [(       6)-1:0] rf_cq_ldb_inflight_count_mem_raddr
    ,output logic [(       6)-1:0] rf_cq_ldb_inflight_count_mem_waddr
    ,output logic                  rf_cq_ldb_inflight_count_mem_we
    ,output logic                  rf_cq_ldb_inflight_count_mem_wclk
    ,output logic                  rf_cq_ldb_inflight_count_mem_wclk_rst_n
    ,output logic [(      15)-1:0] rf_cq_ldb_inflight_count_mem_wdata
    ,input  logic [(      15)-1:0] rf_cq_ldb_inflight_count_mem_rdata

    ,output logic                  rf_cq_ldb_inflight_count_mem_error

    ,input  logic                  func_cq_ldb_token_count_mem_re
    ,input  logic [(       6)-1:0] func_cq_ldb_token_count_mem_raddr
    ,input  logic [(       6)-1:0] func_cq_ldb_token_count_mem_waddr
    ,input  logic                  func_cq_ldb_token_count_mem_we
    ,input  logic [(      13)-1:0] func_cq_ldb_token_count_mem_wdata
    ,output logic [(      13)-1:0] func_cq_ldb_token_count_mem_rdata

    ,input  logic                  pf_cq_ldb_token_count_mem_re
    ,input  logic [(       6)-1:0] pf_cq_ldb_token_count_mem_raddr
    ,input  logic [(       6)-1:0] pf_cq_ldb_token_count_mem_waddr
    ,input  logic                  pf_cq_ldb_token_count_mem_we
    ,input  logic [(      13)-1:0] pf_cq_ldb_token_count_mem_wdata
    ,output logic [(      13)-1:0] pf_cq_ldb_token_count_mem_rdata

    ,output logic                  rf_cq_ldb_token_count_mem_re
    ,output logic                  rf_cq_ldb_token_count_mem_rclk
    ,output logic                  rf_cq_ldb_token_count_mem_rclk_rst_n
    ,output logic [(       6)-1:0] rf_cq_ldb_token_count_mem_raddr
    ,output logic [(       6)-1:0] rf_cq_ldb_token_count_mem_waddr
    ,output logic                  rf_cq_ldb_token_count_mem_we
    ,output logic                  rf_cq_ldb_token_count_mem_wclk
    ,output logic                  rf_cq_ldb_token_count_mem_wclk_rst_n
    ,output logic [(      13)-1:0] rf_cq_ldb_token_count_mem_wdata
    ,input  logic [(      13)-1:0] rf_cq_ldb_token_count_mem_rdata

    ,output logic                  rf_cq_ldb_token_count_mem_error

    ,input  logic                  func_cq_ldb_tot_sch_cnt_mem_re
    ,input  logic [(       6)-1:0] func_cq_ldb_tot_sch_cnt_mem_raddr
    ,input  logic [(       6)-1:0] func_cq_ldb_tot_sch_cnt_mem_waddr
    ,input  logic                  func_cq_ldb_tot_sch_cnt_mem_we
    ,input  logic [(      66)-1:0] func_cq_ldb_tot_sch_cnt_mem_wdata
    ,output logic [(      66)-1:0] func_cq_ldb_tot_sch_cnt_mem_rdata

    ,input  logic                  pf_cq_ldb_tot_sch_cnt_mem_re
    ,input  logic [(       6)-1:0] pf_cq_ldb_tot_sch_cnt_mem_raddr
    ,input  logic [(       6)-1:0] pf_cq_ldb_tot_sch_cnt_mem_waddr
    ,input  logic                  pf_cq_ldb_tot_sch_cnt_mem_we
    ,input  logic [(      66)-1:0] pf_cq_ldb_tot_sch_cnt_mem_wdata
    ,output logic [(      66)-1:0] pf_cq_ldb_tot_sch_cnt_mem_rdata

    ,output logic                  rf_cq_ldb_tot_sch_cnt_mem_re
    ,output logic                  rf_cq_ldb_tot_sch_cnt_mem_rclk
    ,output logic                  rf_cq_ldb_tot_sch_cnt_mem_rclk_rst_n
    ,output logic [(       6)-1:0] rf_cq_ldb_tot_sch_cnt_mem_raddr
    ,output logic [(       6)-1:0] rf_cq_ldb_tot_sch_cnt_mem_waddr
    ,output logic                  rf_cq_ldb_tot_sch_cnt_mem_we
    ,output logic                  rf_cq_ldb_tot_sch_cnt_mem_wclk
    ,output logic                  rf_cq_ldb_tot_sch_cnt_mem_wclk_rst_n
    ,output logic [(      66)-1:0] rf_cq_ldb_tot_sch_cnt_mem_wdata
    ,input  logic [(      66)-1:0] rf_cq_ldb_tot_sch_cnt_mem_rdata

    ,output logic                  rf_cq_ldb_tot_sch_cnt_mem_error

    ,input  logic                  func_cq_ldb_wu_count_mem_re
    ,input  logic [(       6)-1:0] func_cq_ldb_wu_count_mem_raddr
    ,input  logic [(       6)-1:0] func_cq_ldb_wu_count_mem_waddr
    ,input  logic                  func_cq_ldb_wu_count_mem_we
    ,input  logic [(      19)-1:0] func_cq_ldb_wu_count_mem_wdata
    ,output logic [(      19)-1:0] func_cq_ldb_wu_count_mem_rdata

    ,input  logic                  pf_cq_ldb_wu_count_mem_re
    ,input  logic [(       6)-1:0] pf_cq_ldb_wu_count_mem_raddr
    ,input  logic [(       6)-1:0] pf_cq_ldb_wu_count_mem_waddr
    ,input  logic                  pf_cq_ldb_wu_count_mem_we
    ,input  logic [(      19)-1:0] pf_cq_ldb_wu_count_mem_wdata
    ,output logic [(      19)-1:0] pf_cq_ldb_wu_count_mem_rdata

    ,output logic                  rf_cq_ldb_wu_count_mem_re
    ,output logic                  rf_cq_ldb_wu_count_mem_rclk
    ,output logic                  rf_cq_ldb_wu_count_mem_rclk_rst_n
    ,output logic [(       6)-1:0] rf_cq_ldb_wu_count_mem_raddr
    ,output logic [(       6)-1:0] rf_cq_ldb_wu_count_mem_waddr
    ,output logic                  rf_cq_ldb_wu_count_mem_we
    ,output logic                  rf_cq_ldb_wu_count_mem_wclk
    ,output logic                  rf_cq_ldb_wu_count_mem_wclk_rst_n
    ,output logic [(      19)-1:0] rf_cq_ldb_wu_count_mem_wdata
    ,input  logic [(      19)-1:0] rf_cq_ldb_wu_count_mem_rdata

    ,output logic                  rf_cq_ldb_wu_count_mem_error

    ,input  logic                  func_cq_nalb_pri_arbindex_mem_re
    ,input  logic [(       5)-1:0] func_cq_nalb_pri_arbindex_mem_raddr
    ,input  logic [(       5)-1:0] func_cq_nalb_pri_arbindex_mem_waddr
    ,input  logic                  func_cq_nalb_pri_arbindex_mem_we
    ,input  logic [(      96)-1:0] func_cq_nalb_pri_arbindex_mem_wdata
    ,output logic [(      96)-1:0] func_cq_nalb_pri_arbindex_mem_rdata

    ,input  logic                  pf_cq_nalb_pri_arbindex_mem_re
    ,input  logic [(       5)-1:0] pf_cq_nalb_pri_arbindex_mem_raddr
    ,input  logic [(       5)-1:0] pf_cq_nalb_pri_arbindex_mem_waddr
    ,input  logic                  pf_cq_nalb_pri_arbindex_mem_we
    ,input  logic [(      96)-1:0] pf_cq_nalb_pri_arbindex_mem_wdata
    ,output logic [(      96)-1:0] pf_cq_nalb_pri_arbindex_mem_rdata

    ,output logic                  rf_cq_nalb_pri_arbindex_mem_re
    ,output logic                  rf_cq_nalb_pri_arbindex_mem_rclk
    ,output logic                  rf_cq_nalb_pri_arbindex_mem_rclk_rst_n
    ,output logic [(       5)-1:0] rf_cq_nalb_pri_arbindex_mem_raddr
    ,output logic [(       5)-1:0] rf_cq_nalb_pri_arbindex_mem_waddr
    ,output logic                  rf_cq_nalb_pri_arbindex_mem_we
    ,output logic                  rf_cq_nalb_pri_arbindex_mem_wclk
    ,output logic                  rf_cq_nalb_pri_arbindex_mem_wclk_rst_n
    ,output logic [(      96)-1:0] rf_cq_nalb_pri_arbindex_mem_wdata
    ,input  logic [(      96)-1:0] rf_cq_nalb_pri_arbindex_mem_rdata

    ,output logic                  rf_cq_nalb_pri_arbindex_mem_error

    ,input  logic                  func_dir_enq_cnt_mem_re
    ,input  logic [(       7)-1:0] func_dir_enq_cnt_mem_raddr
    ,input  logic [(       7)-1:0] func_dir_enq_cnt_mem_waddr
    ,input  logic                  func_dir_enq_cnt_mem_we
    ,input  logic [(      17)-1:0] func_dir_enq_cnt_mem_wdata
    ,output logic [(      17)-1:0] func_dir_enq_cnt_mem_rdata

    ,input  logic                  pf_dir_enq_cnt_mem_re
    ,input  logic [(       7)-1:0] pf_dir_enq_cnt_mem_raddr
    ,input  logic [(       7)-1:0] pf_dir_enq_cnt_mem_waddr
    ,input  logic                  pf_dir_enq_cnt_mem_we
    ,input  logic [(      17)-1:0] pf_dir_enq_cnt_mem_wdata
    ,output logic [(      17)-1:0] pf_dir_enq_cnt_mem_rdata

    ,output logic                  rf_dir_enq_cnt_mem_re
    ,output logic                  rf_dir_enq_cnt_mem_rclk
    ,output logic                  rf_dir_enq_cnt_mem_rclk_rst_n
    ,output logic [(       6)-1:0] rf_dir_enq_cnt_mem_raddr
    ,output logic [(       6)-1:0] rf_dir_enq_cnt_mem_waddr
    ,output logic                  rf_dir_enq_cnt_mem_we
    ,output logic                  rf_dir_enq_cnt_mem_wclk
    ,output logic                  rf_dir_enq_cnt_mem_wclk_rst_n
    ,output logic [(      17)-1:0] rf_dir_enq_cnt_mem_wdata
    ,input  logic [(      17)-1:0] rf_dir_enq_cnt_mem_rdata

    ,output logic                  rf_dir_enq_cnt_mem_error

    ,input  logic                  func_dir_tok_cnt_mem_re
    ,input  logic [(       7)-1:0] func_dir_tok_cnt_mem_raddr
    ,input  logic [(       7)-1:0] func_dir_tok_cnt_mem_waddr
    ,input  logic                  func_dir_tok_cnt_mem_we
    ,input  logic [(      13)-1:0] func_dir_tok_cnt_mem_wdata
    ,output logic [(      13)-1:0] func_dir_tok_cnt_mem_rdata

    ,input  logic                  pf_dir_tok_cnt_mem_re
    ,input  logic [(       7)-1:0] pf_dir_tok_cnt_mem_raddr
    ,input  logic [(       7)-1:0] pf_dir_tok_cnt_mem_waddr
    ,input  logic                  pf_dir_tok_cnt_mem_we
    ,input  logic [(      13)-1:0] pf_dir_tok_cnt_mem_wdata
    ,output logic [(      13)-1:0] pf_dir_tok_cnt_mem_rdata

    ,output logic                  rf_dir_tok_cnt_mem_re
    ,output logic                  rf_dir_tok_cnt_mem_rclk
    ,output logic                  rf_dir_tok_cnt_mem_rclk_rst_n
    ,output logic [(       6)-1:0] rf_dir_tok_cnt_mem_raddr
    ,output logic [(       6)-1:0] rf_dir_tok_cnt_mem_waddr
    ,output logic                  rf_dir_tok_cnt_mem_we
    ,output logic                  rf_dir_tok_cnt_mem_wclk
    ,output logic                  rf_dir_tok_cnt_mem_wclk_rst_n
    ,output logic [(      13)-1:0] rf_dir_tok_cnt_mem_wdata
    ,input  logic [(      13)-1:0] rf_dir_tok_cnt_mem_rdata

    ,output logic                  rf_dir_tok_cnt_mem_error

    ,input  logic                  func_dir_tok_lim_mem_re
    ,input  logic [(       7)-1:0] func_dir_tok_lim_mem_addr
    ,input  logic                  func_dir_tok_lim_mem_we
    ,input  logic [(       8)-1:0] func_dir_tok_lim_mem_wdata
    ,output logic [(       8)-1:0] func_dir_tok_lim_mem_rdata

    ,input  logic                  pf_dir_tok_lim_mem_re
    ,input  logic [(       7)-1:0] pf_dir_tok_lim_mem_addr
    ,input  logic                  pf_dir_tok_lim_mem_we
    ,input  logic [(       8)-1:0] pf_dir_tok_lim_mem_wdata
    ,output logic [(       8)-1:0] pf_dir_tok_lim_mem_rdata

    ,output logic                  rf_dir_tok_lim_mem_re
    ,output logic                  rf_dir_tok_lim_mem_rclk
    ,output logic                  rf_dir_tok_lim_mem_rclk_rst_n
    ,output logic [(       6)-1:0] rf_dir_tok_lim_mem_raddr
    ,output logic [(       6)-1:0] rf_dir_tok_lim_mem_waddr
    ,output logic                  rf_dir_tok_lim_mem_we
    ,output logic                  rf_dir_tok_lim_mem_wclk
    ,output logic                  rf_dir_tok_lim_mem_wclk_rst_n
    ,output logic [(       8)-1:0] rf_dir_tok_lim_mem_wdata
    ,input  logic [(       8)-1:0] rf_dir_tok_lim_mem_rdata

    ,output logic                  rf_dir_tok_lim_mem_error

    ,input  logic                  func_dp_lsp_enq_dir_rx_sync_fifo_mem_re
    ,input  logic [(       2)-1:0] func_dp_lsp_enq_dir_rx_sync_fifo_mem_raddr
    ,input  logic [(       2)-1:0] func_dp_lsp_enq_dir_rx_sync_fifo_mem_waddr
    ,input  logic                  func_dp_lsp_enq_dir_rx_sync_fifo_mem_we
    ,input  logic [(       8)-1:0] func_dp_lsp_enq_dir_rx_sync_fifo_mem_wdata
    ,output logic [(       8)-1:0] func_dp_lsp_enq_dir_rx_sync_fifo_mem_rdata

    ,input  logic                  pf_dp_lsp_enq_dir_rx_sync_fifo_mem_re
    ,input  logic [(       2)-1:0] pf_dp_lsp_enq_dir_rx_sync_fifo_mem_raddr
    ,input  logic [(       2)-1:0] pf_dp_lsp_enq_dir_rx_sync_fifo_mem_waddr
    ,input  logic                  pf_dp_lsp_enq_dir_rx_sync_fifo_mem_we
    ,input  logic [(       8)-1:0] pf_dp_lsp_enq_dir_rx_sync_fifo_mem_wdata
    ,output logic [(       8)-1:0] pf_dp_lsp_enq_dir_rx_sync_fifo_mem_rdata

    ,output logic                  rf_dp_lsp_enq_dir_rx_sync_fifo_mem_re
    ,output logic                  rf_dp_lsp_enq_dir_rx_sync_fifo_mem_rclk
    ,output logic                  rf_dp_lsp_enq_dir_rx_sync_fifo_mem_rclk_rst_n
    ,output logic [(       2)-1:0] rf_dp_lsp_enq_dir_rx_sync_fifo_mem_raddr
    ,output logic [(       2)-1:0] rf_dp_lsp_enq_dir_rx_sync_fifo_mem_waddr
    ,output logic                  rf_dp_lsp_enq_dir_rx_sync_fifo_mem_we
    ,output logic                  rf_dp_lsp_enq_dir_rx_sync_fifo_mem_wclk
    ,output logic                  rf_dp_lsp_enq_dir_rx_sync_fifo_mem_wclk_rst_n
    ,output logic [(       8)-1:0] rf_dp_lsp_enq_dir_rx_sync_fifo_mem_wdata
    ,input  logic [(       8)-1:0] rf_dp_lsp_enq_dir_rx_sync_fifo_mem_rdata

    ,output logic                  rf_dp_lsp_enq_dir_rx_sync_fifo_mem_error

    ,input  logic                  func_dp_lsp_enq_rorply_rx_sync_fifo_mem_re
    ,input  logic [(       2)-1:0] func_dp_lsp_enq_rorply_rx_sync_fifo_mem_raddr
    ,input  logic [(       2)-1:0] func_dp_lsp_enq_rorply_rx_sync_fifo_mem_waddr
    ,input  logic                  func_dp_lsp_enq_rorply_rx_sync_fifo_mem_we
    ,input  logic [(      23)-1:0] func_dp_lsp_enq_rorply_rx_sync_fifo_mem_wdata
    ,output logic [(      23)-1:0] func_dp_lsp_enq_rorply_rx_sync_fifo_mem_rdata

    ,input  logic                  pf_dp_lsp_enq_rorply_rx_sync_fifo_mem_re
    ,input  logic [(       2)-1:0] pf_dp_lsp_enq_rorply_rx_sync_fifo_mem_raddr
    ,input  logic [(       2)-1:0] pf_dp_lsp_enq_rorply_rx_sync_fifo_mem_waddr
    ,input  logic                  pf_dp_lsp_enq_rorply_rx_sync_fifo_mem_we
    ,input  logic [(      23)-1:0] pf_dp_lsp_enq_rorply_rx_sync_fifo_mem_wdata
    ,output logic [(      23)-1:0] pf_dp_lsp_enq_rorply_rx_sync_fifo_mem_rdata

    ,output logic                  rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_re
    ,output logic                  rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_rclk
    ,output logic                  rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_rclk_rst_n
    ,output logic [(       2)-1:0] rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_raddr
    ,output logic [(       2)-1:0] rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_waddr
    ,output logic                  rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_we
    ,output logic                  rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_wclk
    ,output logic                  rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_wclk_rst_n
    ,output logic [(      23)-1:0] rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_wdata
    ,input  logic [(      23)-1:0] rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_rdata

    ,output logic                  rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_error

    ,input  logic                  func_enq_nalb_fifo_mem_re
    ,input  logic [(       2)-1:0] func_enq_nalb_fifo_mem_raddr
    ,input  logic [(       2)-1:0] func_enq_nalb_fifo_mem_waddr
    ,input  logic                  func_enq_nalb_fifo_mem_we
    ,input  logic [(      10)-1:0] func_enq_nalb_fifo_mem_wdata
    ,output logic [(      10)-1:0] func_enq_nalb_fifo_mem_rdata

    ,input  logic                  pf_enq_nalb_fifo_mem_re
    ,input  logic [(       2)-1:0] pf_enq_nalb_fifo_mem_raddr
    ,input  logic [(       2)-1:0] pf_enq_nalb_fifo_mem_waddr
    ,input  logic                  pf_enq_nalb_fifo_mem_we
    ,input  logic [(      10)-1:0] pf_enq_nalb_fifo_mem_wdata
    ,output logic [(      10)-1:0] pf_enq_nalb_fifo_mem_rdata

    ,output logic                  rf_enq_nalb_fifo_mem_re
    ,output logic                  rf_enq_nalb_fifo_mem_rclk
    ,output logic                  rf_enq_nalb_fifo_mem_rclk_rst_n
    ,output logic [(       2)-1:0] rf_enq_nalb_fifo_mem_raddr
    ,output logic [(       2)-1:0] rf_enq_nalb_fifo_mem_waddr
    ,output logic                  rf_enq_nalb_fifo_mem_we
    ,output logic                  rf_enq_nalb_fifo_mem_wclk
    ,output logic                  rf_enq_nalb_fifo_mem_wclk_rst_n
    ,output logic [(      10)-1:0] rf_enq_nalb_fifo_mem_wdata
    ,input  logic [(      10)-1:0] rf_enq_nalb_fifo_mem_rdata

    ,output logic                  rf_enq_nalb_fifo_mem_error

    ,input  logic                  func_ldb_token_rtn_fifo_mem_re
    ,input  logic [(       3)-1:0] func_ldb_token_rtn_fifo_mem_raddr
    ,input  logic [(       3)-1:0] func_ldb_token_rtn_fifo_mem_waddr
    ,input  logic                  func_ldb_token_rtn_fifo_mem_we
    ,input  logic [(      25)-1:0] func_ldb_token_rtn_fifo_mem_wdata
    ,output logic [(      25)-1:0] func_ldb_token_rtn_fifo_mem_rdata

    ,input  logic                  pf_ldb_token_rtn_fifo_mem_re
    ,input  logic [(       3)-1:0] pf_ldb_token_rtn_fifo_mem_raddr
    ,input  logic [(       3)-1:0] pf_ldb_token_rtn_fifo_mem_waddr
    ,input  logic                  pf_ldb_token_rtn_fifo_mem_we
    ,input  logic [(      25)-1:0] pf_ldb_token_rtn_fifo_mem_wdata
    ,output logic [(      25)-1:0] pf_ldb_token_rtn_fifo_mem_rdata

    ,output logic                  rf_ldb_token_rtn_fifo_mem_re
    ,output logic                  rf_ldb_token_rtn_fifo_mem_rclk
    ,output logic                  rf_ldb_token_rtn_fifo_mem_rclk_rst_n
    ,output logic [(       3)-1:0] rf_ldb_token_rtn_fifo_mem_raddr
    ,output logic [(       3)-1:0] rf_ldb_token_rtn_fifo_mem_waddr
    ,output logic                  rf_ldb_token_rtn_fifo_mem_we
    ,output logic                  rf_ldb_token_rtn_fifo_mem_wclk
    ,output logic                  rf_ldb_token_rtn_fifo_mem_wclk_rst_n
    ,output logic [(      25)-1:0] rf_ldb_token_rtn_fifo_mem_wdata
    ,input  logic [(      25)-1:0] rf_ldb_token_rtn_fifo_mem_rdata

    ,output logic                  rf_ldb_token_rtn_fifo_mem_error

    ,input  logic                  func_nalb_cmp_fifo_mem_re
    ,input  logic [(       3)-1:0] func_nalb_cmp_fifo_mem_raddr
    ,input  logic [(       3)-1:0] func_nalb_cmp_fifo_mem_waddr
    ,input  logic                  func_nalb_cmp_fifo_mem_we
    ,input  logic [(      18)-1:0] func_nalb_cmp_fifo_mem_wdata
    ,output logic [(      18)-1:0] func_nalb_cmp_fifo_mem_rdata

    ,input  logic                  pf_nalb_cmp_fifo_mem_re
    ,input  logic [(       3)-1:0] pf_nalb_cmp_fifo_mem_raddr
    ,input  logic [(       3)-1:0] pf_nalb_cmp_fifo_mem_waddr
    ,input  logic                  pf_nalb_cmp_fifo_mem_we
    ,input  logic [(      18)-1:0] pf_nalb_cmp_fifo_mem_wdata
    ,output logic [(      18)-1:0] pf_nalb_cmp_fifo_mem_rdata

    ,output logic                  rf_nalb_cmp_fifo_mem_re
    ,output logic                  rf_nalb_cmp_fifo_mem_rclk
    ,output logic                  rf_nalb_cmp_fifo_mem_rclk_rst_n
    ,output logic [(       3)-1:0] rf_nalb_cmp_fifo_mem_raddr
    ,output logic [(       3)-1:0] rf_nalb_cmp_fifo_mem_waddr
    ,output logic                  rf_nalb_cmp_fifo_mem_we
    ,output logic                  rf_nalb_cmp_fifo_mem_wclk
    ,output logic                  rf_nalb_cmp_fifo_mem_wclk_rst_n
    ,output logic [(      18)-1:0] rf_nalb_cmp_fifo_mem_wdata
    ,input  logic [(      18)-1:0] rf_nalb_cmp_fifo_mem_rdata

    ,output logic                  rf_nalb_cmp_fifo_mem_error

    ,input  logic                  func_nalb_lsp_enq_lb_rx_sync_fifo_mem_re
    ,input  logic [(       2)-1:0] func_nalb_lsp_enq_lb_rx_sync_fifo_mem_raddr
    ,input  logic [(       2)-1:0] func_nalb_lsp_enq_lb_rx_sync_fifo_mem_waddr
    ,input  logic                  func_nalb_lsp_enq_lb_rx_sync_fifo_mem_we
    ,input  logic [(      10)-1:0] func_nalb_lsp_enq_lb_rx_sync_fifo_mem_wdata
    ,output logic [(      10)-1:0] func_nalb_lsp_enq_lb_rx_sync_fifo_mem_rdata

    ,input  logic                  pf_nalb_lsp_enq_lb_rx_sync_fifo_mem_re
    ,input  logic [(       2)-1:0] pf_nalb_lsp_enq_lb_rx_sync_fifo_mem_raddr
    ,input  logic [(       2)-1:0] pf_nalb_lsp_enq_lb_rx_sync_fifo_mem_waddr
    ,input  logic                  pf_nalb_lsp_enq_lb_rx_sync_fifo_mem_we
    ,input  logic [(      10)-1:0] pf_nalb_lsp_enq_lb_rx_sync_fifo_mem_wdata
    ,output logic [(      10)-1:0] pf_nalb_lsp_enq_lb_rx_sync_fifo_mem_rdata

    ,output logic                  rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_re
    ,output logic                  rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_rclk
    ,output logic                  rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_rclk_rst_n
    ,output logic [(       2)-1:0] rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_raddr
    ,output logic [(       2)-1:0] rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_waddr
    ,output logic                  rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_we
    ,output logic                  rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_wclk
    ,output logic                  rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_wclk_rst_n
    ,output logic [(      10)-1:0] rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_wdata
    ,input  logic [(      10)-1:0] rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_rdata

    ,output logic                  rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_error

    ,input  logic                  func_nalb_lsp_enq_rorply_rx_sync_fifo_mem_re
    ,input  logic [(       2)-1:0] func_nalb_lsp_enq_rorply_rx_sync_fifo_mem_raddr
    ,input  logic [(       2)-1:0] func_nalb_lsp_enq_rorply_rx_sync_fifo_mem_waddr
    ,input  logic                  func_nalb_lsp_enq_rorply_rx_sync_fifo_mem_we
    ,input  logic [(      27)-1:0] func_nalb_lsp_enq_rorply_rx_sync_fifo_mem_wdata
    ,output logic [(      27)-1:0] func_nalb_lsp_enq_rorply_rx_sync_fifo_mem_rdata

    ,input  logic                  pf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_re
    ,input  logic [(       2)-1:0] pf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_raddr
    ,input  logic [(       2)-1:0] pf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_waddr
    ,input  logic                  pf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_we
    ,input  logic [(      27)-1:0] pf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_wdata
    ,output logic [(      27)-1:0] pf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_rdata

    ,output logic                  rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_re
    ,output logic                  rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_rclk
    ,output logic                  rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_rclk_rst_n
    ,output logic [(       2)-1:0] rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_raddr
    ,output logic [(       2)-1:0] rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_waddr
    ,output logic                  rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_we
    ,output logic                  rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_wclk
    ,output logic                  rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_wclk_rst_n
    ,output logic [(      27)-1:0] rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_wdata
    ,input  logic [(      27)-1:0] rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_rdata

    ,output logic                  rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_error

    ,input  logic                  func_nalb_sel_nalb_fifo_mem_re
    ,input  logic [(       4)-1:0] func_nalb_sel_nalb_fifo_mem_raddr
    ,input  logic [(       4)-1:0] func_nalb_sel_nalb_fifo_mem_waddr
    ,input  logic                  func_nalb_sel_nalb_fifo_mem_we
    ,input  logic [(      27)-1:0] func_nalb_sel_nalb_fifo_mem_wdata
    ,output logic [(      27)-1:0] func_nalb_sel_nalb_fifo_mem_rdata

    ,input  logic                  pf_nalb_sel_nalb_fifo_mem_re
    ,input  logic [(       4)-1:0] pf_nalb_sel_nalb_fifo_mem_raddr
    ,input  logic [(       4)-1:0] pf_nalb_sel_nalb_fifo_mem_waddr
    ,input  logic                  pf_nalb_sel_nalb_fifo_mem_we
    ,input  logic [(      27)-1:0] pf_nalb_sel_nalb_fifo_mem_wdata
    ,output logic [(      27)-1:0] pf_nalb_sel_nalb_fifo_mem_rdata

    ,output logic                  rf_nalb_sel_nalb_fifo_mem_re
    ,output logic                  rf_nalb_sel_nalb_fifo_mem_rclk
    ,output logic                  rf_nalb_sel_nalb_fifo_mem_rclk_rst_n
    ,output logic [(       4)-1:0] rf_nalb_sel_nalb_fifo_mem_raddr
    ,output logic [(       4)-1:0] rf_nalb_sel_nalb_fifo_mem_waddr
    ,output logic                  rf_nalb_sel_nalb_fifo_mem_we
    ,output logic                  rf_nalb_sel_nalb_fifo_mem_wclk
    ,output logic                  rf_nalb_sel_nalb_fifo_mem_wclk_rst_n
    ,output logic [(      27)-1:0] rf_nalb_sel_nalb_fifo_mem_wdata
    ,input  logic [(      27)-1:0] rf_nalb_sel_nalb_fifo_mem_rdata

    ,output logic                  rf_nalb_sel_nalb_fifo_mem_error

    ,input  logic                  func_qed_lsp_deq_fifo_mem_re
    ,input  logic [(       5)-1:0] func_qed_lsp_deq_fifo_mem_raddr
    ,input  logic [(       5)-1:0] func_qed_lsp_deq_fifo_mem_waddr
    ,input  logic                  func_qed_lsp_deq_fifo_mem_we
    ,input  logic [(       9)-1:0] func_qed_lsp_deq_fifo_mem_wdata
    ,output logic [(       9)-1:0] func_qed_lsp_deq_fifo_mem_rdata

    ,input  logic                  pf_qed_lsp_deq_fifo_mem_re
    ,input  logic [(       5)-1:0] pf_qed_lsp_deq_fifo_mem_raddr
    ,input  logic [(       5)-1:0] pf_qed_lsp_deq_fifo_mem_waddr
    ,input  logic                  pf_qed_lsp_deq_fifo_mem_we
    ,input  logic [(       9)-1:0] pf_qed_lsp_deq_fifo_mem_wdata
    ,output logic [(       9)-1:0] pf_qed_lsp_deq_fifo_mem_rdata

    ,output logic                  rf_qed_lsp_deq_fifo_mem_re
    ,output logic                  rf_qed_lsp_deq_fifo_mem_rclk
    ,output logic                  rf_qed_lsp_deq_fifo_mem_rclk_rst_n
    ,output logic [(       5)-1:0] rf_qed_lsp_deq_fifo_mem_raddr
    ,output logic [(       5)-1:0] rf_qed_lsp_deq_fifo_mem_waddr
    ,output logic                  rf_qed_lsp_deq_fifo_mem_we
    ,output logic                  rf_qed_lsp_deq_fifo_mem_wclk
    ,output logic                  rf_qed_lsp_deq_fifo_mem_wclk_rst_n
    ,output logic [(       9)-1:0] rf_qed_lsp_deq_fifo_mem_wdata
    ,input  logic [(       9)-1:0] rf_qed_lsp_deq_fifo_mem_rdata

    ,output logic                  rf_qed_lsp_deq_fifo_mem_error

    ,input  logic                  func_qid_aqed_active_count_mem_re
    ,input  logic [(       7)-1:0] func_qid_aqed_active_count_mem_raddr
    ,input  logic [(       7)-1:0] func_qid_aqed_active_count_mem_waddr
    ,input  logic                  func_qid_aqed_active_count_mem_we
    ,input  logic [(      14)-1:0] func_qid_aqed_active_count_mem_wdata
    ,output logic [(      14)-1:0] func_qid_aqed_active_count_mem_rdata

    ,input  logic                  pf_qid_aqed_active_count_mem_re
    ,input  logic [(       7)-1:0] pf_qid_aqed_active_count_mem_raddr
    ,input  logic [(       7)-1:0] pf_qid_aqed_active_count_mem_waddr
    ,input  logic                  pf_qid_aqed_active_count_mem_we
    ,input  logic [(      14)-1:0] pf_qid_aqed_active_count_mem_wdata
    ,output logic [(      14)-1:0] pf_qid_aqed_active_count_mem_rdata

    ,output logic                  rf_qid_aqed_active_count_mem_re
    ,output logic                  rf_qid_aqed_active_count_mem_rclk
    ,output logic                  rf_qid_aqed_active_count_mem_rclk_rst_n
    ,output logic [(       5)-1:0] rf_qid_aqed_active_count_mem_raddr
    ,output logic [(       5)-1:0] rf_qid_aqed_active_count_mem_waddr
    ,output logic                  rf_qid_aqed_active_count_mem_we
    ,output logic                  rf_qid_aqed_active_count_mem_wclk
    ,output logic                  rf_qid_aqed_active_count_mem_wclk_rst_n
    ,output logic [(      14)-1:0] rf_qid_aqed_active_count_mem_wdata
    ,input  logic [(      14)-1:0] rf_qid_aqed_active_count_mem_rdata

    ,output logic                  rf_qid_aqed_active_count_mem_error

    ,input  logic                  func_qid_atm_active_mem_re
    ,input  logic [(       7)-1:0] func_qid_atm_active_mem_raddr
    ,input  logic [(       7)-1:0] func_qid_atm_active_mem_waddr
    ,input  logic                  func_qid_atm_active_mem_we
    ,input  logic [(      17)-1:0] func_qid_atm_active_mem_wdata
    ,output logic [(      17)-1:0] func_qid_atm_active_mem_rdata

    ,input  logic                  pf_qid_atm_active_mem_re
    ,input  logic [(       7)-1:0] pf_qid_atm_active_mem_raddr
    ,input  logic [(       7)-1:0] pf_qid_atm_active_mem_waddr
    ,input  logic                  pf_qid_atm_active_mem_we
    ,input  logic [(      17)-1:0] pf_qid_atm_active_mem_wdata
    ,output logic [(      17)-1:0] pf_qid_atm_active_mem_rdata

    ,output logic                  rf_qid_atm_active_mem_re
    ,output logic                  rf_qid_atm_active_mem_rclk
    ,output logic                  rf_qid_atm_active_mem_rclk_rst_n
    ,output logic [(       5)-1:0] rf_qid_atm_active_mem_raddr
    ,output logic [(       5)-1:0] rf_qid_atm_active_mem_waddr
    ,output logic                  rf_qid_atm_active_mem_we
    ,output logic                  rf_qid_atm_active_mem_wclk
    ,output logic                  rf_qid_atm_active_mem_wclk_rst_n
    ,output logic [(      17)-1:0] rf_qid_atm_active_mem_wdata
    ,input  logic [(      17)-1:0] rf_qid_atm_active_mem_rdata

    ,output logic                  rf_qid_atm_active_mem_error

    ,input  logic                  func_qid_atm_tot_enq_cnt_mem_re
    ,input  logic [(       7)-1:0] func_qid_atm_tot_enq_cnt_mem_raddr
    ,input  logic [(       7)-1:0] func_qid_atm_tot_enq_cnt_mem_waddr
    ,input  logic                  func_qid_atm_tot_enq_cnt_mem_we
    ,input  logic [(      66)-1:0] func_qid_atm_tot_enq_cnt_mem_wdata
    ,output logic [(      66)-1:0] func_qid_atm_tot_enq_cnt_mem_rdata

    ,input  logic                  pf_qid_atm_tot_enq_cnt_mem_re
    ,input  logic [(       7)-1:0] pf_qid_atm_tot_enq_cnt_mem_raddr
    ,input  logic [(       7)-1:0] pf_qid_atm_tot_enq_cnt_mem_waddr
    ,input  logic                  pf_qid_atm_tot_enq_cnt_mem_we
    ,input  logic [(      66)-1:0] pf_qid_atm_tot_enq_cnt_mem_wdata
    ,output logic [(      66)-1:0] pf_qid_atm_tot_enq_cnt_mem_rdata

    ,output logic                  rf_qid_atm_tot_enq_cnt_mem_re
    ,output logic                  rf_qid_atm_tot_enq_cnt_mem_rclk
    ,output logic                  rf_qid_atm_tot_enq_cnt_mem_rclk_rst_n
    ,output logic [(       5)-1:0] rf_qid_atm_tot_enq_cnt_mem_raddr
    ,output logic [(       5)-1:0] rf_qid_atm_tot_enq_cnt_mem_waddr
    ,output logic                  rf_qid_atm_tot_enq_cnt_mem_we
    ,output logic                  rf_qid_atm_tot_enq_cnt_mem_wclk
    ,output logic                  rf_qid_atm_tot_enq_cnt_mem_wclk_rst_n
    ,output logic [(      66)-1:0] rf_qid_atm_tot_enq_cnt_mem_wdata
    ,input  logic [(      66)-1:0] rf_qid_atm_tot_enq_cnt_mem_rdata

    ,output logic                  rf_qid_atm_tot_enq_cnt_mem_error

    ,input  logic                  func_qid_atq_enqueue_count_mem_re
    ,input  logic [(       7)-1:0] func_qid_atq_enqueue_count_mem_raddr
    ,input  logic [(       7)-1:0] func_qid_atq_enqueue_count_mem_waddr
    ,input  logic                  func_qid_atq_enqueue_count_mem_we
    ,input  logic [(      17)-1:0] func_qid_atq_enqueue_count_mem_wdata
    ,output logic [(      17)-1:0] func_qid_atq_enqueue_count_mem_rdata

    ,input  logic                  pf_qid_atq_enqueue_count_mem_re
    ,input  logic [(       7)-1:0] pf_qid_atq_enqueue_count_mem_raddr
    ,input  logic [(       7)-1:0] pf_qid_atq_enqueue_count_mem_waddr
    ,input  logic                  pf_qid_atq_enqueue_count_mem_we
    ,input  logic [(      17)-1:0] pf_qid_atq_enqueue_count_mem_wdata
    ,output logic [(      17)-1:0] pf_qid_atq_enqueue_count_mem_rdata

    ,output logic                  rf_qid_atq_enqueue_count_mem_re
    ,output logic                  rf_qid_atq_enqueue_count_mem_rclk
    ,output logic                  rf_qid_atq_enqueue_count_mem_rclk_rst_n
    ,output logic [(       5)-1:0] rf_qid_atq_enqueue_count_mem_raddr
    ,output logic [(       5)-1:0] rf_qid_atq_enqueue_count_mem_waddr
    ,output logic                  rf_qid_atq_enqueue_count_mem_we
    ,output logic                  rf_qid_atq_enqueue_count_mem_wclk
    ,output logic                  rf_qid_atq_enqueue_count_mem_wclk_rst_n
    ,output logic [(      17)-1:0] rf_qid_atq_enqueue_count_mem_wdata
    ,input  logic [(      17)-1:0] rf_qid_atq_enqueue_count_mem_rdata

    ,output logic                  rf_qid_atq_enqueue_count_mem_error

    ,input  logic                  func_qid_dir_max_depth_mem_re
    ,input  logic [(       7)-1:0] func_qid_dir_max_depth_mem_raddr
    ,input  logic [(       7)-1:0] func_qid_dir_max_depth_mem_waddr
    ,input  logic                  func_qid_dir_max_depth_mem_we
    ,input  logic [(      15)-1:0] func_qid_dir_max_depth_mem_wdata
    ,output logic [(      15)-1:0] func_qid_dir_max_depth_mem_rdata

    ,input  logic                  pf_qid_dir_max_depth_mem_re
    ,input  logic [(       7)-1:0] pf_qid_dir_max_depth_mem_raddr
    ,input  logic [(       7)-1:0] pf_qid_dir_max_depth_mem_waddr
    ,input  logic                  pf_qid_dir_max_depth_mem_we
    ,input  logic [(      15)-1:0] pf_qid_dir_max_depth_mem_wdata
    ,output logic [(      15)-1:0] pf_qid_dir_max_depth_mem_rdata

    ,output logic                  rf_qid_dir_max_depth_mem_re
    ,output logic                  rf_qid_dir_max_depth_mem_rclk
    ,output logic                  rf_qid_dir_max_depth_mem_rclk_rst_n
    ,output logic [(       6)-1:0] rf_qid_dir_max_depth_mem_raddr
    ,output logic [(       6)-1:0] rf_qid_dir_max_depth_mem_waddr
    ,output logic                  rf_qid_dir_max_depth_mem_we
    ,output logic                  rf_qid_dir_max_depth_mem_wclk
    ,output logic                  rf_qid_dir_max_depth_mem_wclk_rst_n
    ,output logic [(      15)-1:0] rf_qid_dir_max_depth_mem_wdata
    ,input  logic [(      15)-1:0] rf_qid_dir_max_depth_mem_rdata

    ,output logic                  rf_qid_dir_max_depth_mem_error

    ,input  logic                  func_qid_dir_replay_count_mem_re
    ,input  logic [(       7)-1:0] func_qid_dir_replay_count_mem_raddr
    ,input  logic [(       7)-1:0] func_qid_dir_replay_count_mem_waddr
    ,input  logic                  func_qid_dir_replay_count_mem_we
    ,input  logic [(      17)-1:0] func_qid_dir_replay_count_mem_wdata
    ,output logic [(      17)-1:0] func_qid_dir_replay_count_mem_rdata

    ,input  logic                  pf_qid_dir_replay_count_mem_re
    ,input  logic [(       7)-1:0] pf_qid_dir_replay_count_mem_raddr
    ,input  logic [(       7)-1:0] pf_qid_dir_replay_count_mem_waddr
    ,input  logic                  pf_qid_dir_replay_count_mem_we
    ,input  logic [(      17)-1:0] pf_qid_dir_replay_count_mem_wdata
    ,output logic [(      17)-1:0] pf_qid_dir_replay_count_mem_rdata

    ,output logic                  rf_qid_dir_replay_count_mem_re
    ,output logic                  rf_qid_dir_replay_count_mem_rclk
    ,output logic                  rf_qid_dir_replay_count_mem_rclk_rst_n
    ,output logic [(       5)-1:0] rf_qid_dir_replay_count_mem_raddr
    ,output logic [(       5)-1:0] rf_qid_dir_replay_count_mem_waddr
    ,output logic                  rf_qid_dir_replay_count_mem_we
    ,output logic                  rf_qid_dir_replay_count_mem_wclk
    ,output logic                  rf_qid_dir_replay_count_mem_wclk_rst_n
    ,output logic [(      17)-1:0] rf_qid_dir_replay_count_mem_wdata
    ,input  logic [(      17)-1:0] rf_qid_dir_replay_count_mem_rdata

    ,output logic                  rf_qid_dir_replay_count_mem_error

    ,input  logic                  func_qid_dir_tot_enq_cnt_mem_re
    ,input  logic [(       7)-1:0] func_qid_dir_tot_enq_cnt_mem_raddr
    ,input  logic [(       7)-1:0] func_qid_dir_tot_enq_cnt_mem_waddr
    ,input  logic                  func_qid_dir_tot_enq_cnt_mem_we
    ,input  logic [(      66)-1:0] func_qid_dir_tot_enq_cnt_mem_wdata
    ,output logic [(      66)-1:0] func_qid_dir_tot_enq_cnt_mem_rdata

    ,input  logic                  pf_qid_dir_tot_enq_cnt_mem_re
    ,input  logic [(       7)-1:0] pf_qid_dir_tot_enq_cnt_mem_raddr
    ,input  logic [(       7)-1:0] pf_qid_dir_tot_enq_cnt_mem_waddr
    ,input  logic                  pf_qid_dir_tot_enq_cnt_mem_we
    ,input  logic [(      66)-1:0] pf_qid_dir_tot_enq_cnt_mem_wdata
    ,output logic [(      66)-1:0] pf_qid_dir_tot_enq_cnt_mem_rdata

    ,output logic                  rf_qid_dir_tot_enq_cnt_mem_re
    ,output logic                  rf_qid_dir_tot_enq_cnt_mem_rclk
    ,output logic                  rf_qid_dir_tot_enq_cnt_mem_rclk_rst_n
    ,output logic [(       6)-1:0] rf_qid_dir_tot_enq_cnt_mem_raddr
    ,output logic [(       6)-1:0] rf_qid_dir_tot_enq_cnt_mem_waddr
    ,output logic                  rf_qid_dir_tot_enq_cnt_mem_we
    ,output logic                  rf_qid_dir_tot_enq_cnt_mem_wclk
    ,output logic                  rf_qid_dir_tot_enq_cnt_mem_wclk_rst_n
    ,output logic [(      66)-1:0] rf_qid_dir_tot_enq_cnt_mem_wdata
    ,input  logic [(      66)-1:0] rf_qid_dir_tot_enq_cnt_mem_rdata

    ,output logic                  rf_qid_dir_tot_enq_cnt_mem_error

    ,input  logic                  func_qid_ldb_enqueue_count_mem_re
    ,input  logic [(       7)-1:0] func_qid_ldb_enqueue_count_mem_raddr
    ,input  logic [(       7)-1:0] func_qid_ldb_enqueue_count_mem_waddr
    ,input  logic                  func_qid_ldb_enqueue_count_mem_we
    ,input  logic [(      17)-1:0] func_qid_ldb_enqueue_count_mem_wdata
    ,output logic [(      17)-1:0] func_qid_ldb_enqueue_count_mem_rdata

    ,input  logic                  pf_qid_ldb_enqueue_count_mem_re
    ,input  logic [(       7)-1:0] pf_qid_ldb_enqueue_count_mem_raddr
    ,input  logic [(       7)-1:0] pf_qid_ldb_enqueue_count_mem_waddr
    ,input  logic                  pf_qid_ldb_enqueue_count_mem_we
    ,input  logic [(      17)-1:0] pf_qid_ldb_enqueue_count_mem_wdata
    ,output logic [(      17)-1:0] pf_qid_ldb_enqueue_count_mem_rdata

    ,output logic                  rf_qid_ldb_enqueue_count_mem_re
    ,output logic                  rf_qid_ldb_enqueue_count_mem_rclk
    ,output logic                  rf_qid_ldb_enqueue_count_mem_rclk_rst_n
    ,output logic [(       5)-1:0] rf_qid_ldb_enqueue_count_mem_raddr
    ,output logic [(       5)-1:0] rf_qid_ldb_enqueue_count_mem_waddr
    ,output logic                  rf_qid_ldb_enqueue_count_mem_we
    ,output logic                  rf_qid_ldb_enqueue_count_mem_wclk
    ,output logic                  rf_qid_ldb_enqueue_count_mem_wclk_rst_n
    ,output logic [(      17)-1:0] rf_qid_ldb_enqueue_count_mem_wdata
    ,input  logic [(      17)-1:0] rf_qid_ldb_enqueue_count_mem_rdata

    ,output logic                  rf_qid_ldb_enqueue_count_mem_error

    ,input  logic                  func_qid_ldb_inflight_count_mem_re
    ,input  logic [(       7)-1:0] func_qid_ldb_inflight_count_mem_raddr
    ,input  logic [(       7)-1:0] func_qid_ldb_inflight_count_mem_waddr
    ,input  logic                  func_qid_ldb_inflight_count_mem_we
    ,input  logic [(      14)-1:0] func_qid_ldb_inflight_count_mem_wdata
    ,output logic [(      14)-1:0] func_qid_ldb_inflight_count_mem_rdata

    ,input  logic                  pf_qid_ldb_inflight_count_mem_re
    ,input  logic [(       7)-1:0] pf_qid_ldb_inflight_count_mem_raddr
    ,input  logic [(       7)-1:0] pf_qid_ldb_inflight_count_mem_waddr
    ,input  logic                  pf_qid_ldb_inflight_count_mem_we
    ,input  logic [(      14)-1:0] pf_qid_ldb_inflight_count_mem_wdata
    ,output logic [(      14)-1:0] pf_qid_ldb_inflight_count_mem_rdata

    ,output logic                  rf_qid_ldb_inflight_count_mem_re
    ,output logic                  rf_qid_ldb_inflight_count_mem_rclk
    ,output logic                  rf_qid_ldb_inflight_count_mem_rclk_rst_n
    ,output logic [(       5)-1:0] rf_qid_ldb_inflight_count_mem_raddr
    ,output logic [(       5)-1:0] rf_qid_ldb_inflight_count_mem_waddr
    ,output logic                  rf_qid_ldb_inflight_count_mem_we
    ,output logic                  rf_qid_ldb_inflight_count_mem_wclk
    ,output logic                  rf_qid_ldb_inflight_count_mem_wclk_rst_n
    ,output logic [(      14)-1:0] rf_qid_ldb_inflight_count_mem_wdata
    ,input  logic [(      14)-1:0] rf_qid_ldb_inflight_count_mem_rdata

    ,output logic                  rf_qid_ldb_inflight_count_mem_error

    ,input  logic                  func_qid_ldb_replay_count_mem_re
    ,input  logic [(       7)-1:0] func_qid_ldb_replay_count_mem_raddr
    ,input  logic [(       7)-1:0] func_qid_ldb_replay_count_mem_waddr
    ,input  logic                  func_qid_ldb_replay_count_mem_we
    ,input  logic [(      17)-1:0] func_qid_ldb_replay_count_mem_wdata
    ,output logic [(      17)-1:0] func_qid_ldb_replay_count_mem_rdata

    ,input  logic                  pf_qid_ldb_replay_count_mem_re
    ,input  logic [(       7)-1:0] pf_qid_ldb_replay_count_mem_raddr
    ,input  logic [(       7)-1:0] pf_qid_ldb_replay_count_mem_waddr
    ,input  logic                  pf_qid_ldb_replay_count_mem_we
    ,input  logic [(      17)-1:0] pf_qid_ldb_replay_count_mem_wdata
    ,output logic [(      17)-1:0] pf_qid_ldb_replay_count_mem_rdata

    ,output logic                  rf_qid_ldb_replay_count_mem_re
    ,output logic                  rf_qid_ldb_replay_count_mem_rclk
    ,output logic                  rf_qid_ldb_replay_count_mem_rclk_rst_n
    ,output logic [(       5)-1:0] rf_qid_ldb_replay_count_mem_raddr
    ,output logic [(       5)-1:0] rf_qid_ldb_replay_count_mem_waddr
    ,output logic                  rf_qid_ldb_replay_count_mem_we
    ,output logic                  rf_qid_ldb_replay_count_mem_wclk
    ,output logic                  rf_qid_ldb_replay_count_mem_wclk_rst_n
    ,output logic [(      17)-1:0] rf_qid_ldb_replay_count_mem_wdata
    ,input  logic [(      17)-1:0] rf_qid_ldb_replay_count_mem_rdata

    ,output logic                  rf_qid_ldb_replay_count_mem_error

    ,input  logic                  func_qid_naldb_max_depth_mem_re
    ,input  logic [(       7)-1:0] func_qid_naldb_max_depth_mem_raddr
    ,input  logic [(       7)-1:0] func_qid_naldb_max_depth_mem_waddr
    ,input  logic                  func_qid_naldb_max_depth_mem_we
    ,input  logic [(      15)-1:0] func_qid_naldb_max_depth_mem_wdata
    ,output logic [(      15)-1:0] func_qid_naldb_max_depth_mem_rdata

    ,input  logic                  pf_qid_naldb_max_depth_mem_re
    ,input  logic [(       7)-1:0] pf_qid_naldb_max_depth_mem_raddr
    ,input  logic [(       7)-1:0] pf_qid_naldb_max_depth_mem_waddr
    ,input  logic                  pf_qid_naldb_max_depth_mem_we
    ,input  logic [(      15)-1:0] pf_qid_naldb_max_depth_mem_wdata
    ,output logic [(      15)-1:0] pf_qid_naldb_max_depth_mem_rdata

    ,output logic                  rf_qid_naldb_max_depth_mem_re
    ,output logic                  rf_qid_naldb_max_depth_mem_rclk
    ,output logic                  rf_qid_naldb_max_depth_mem_rclk_rst_n
    ,output logic [(       5)-1:0] rf_qid_naldb_max_depth_mem_raddr
    ,output logic [(       5)-1:0] rf_qid_naldb_max_depth_mem_waddr
    ,output logic                  rf_qid_naldb_max_depth_mem_we
    ,output logic                  rf_qid_naldb_max_depth_mem_wclk
    ,output logic                  rf_qid_naldb_max_depth_mem_wclk_rst_n
    ,output logic [(      15)-1:0] rf_qid_naldb_max_depth_mem_wdata
    ,input  logic [(      15)-1:0] rf_qid_naldb_max_depth_mem_rdata

    ,output logic                  rf_qid_naldb_max_depth_mem_error

    ,input  logic                  func_qid_naldb_tot_enq_cnt_mem_re
    ,input  logic [(       7)-1:0] func_qid_naldb_tot_enq_cnt_mem_raddr
    ,input  logic [(       7)-1:0] func_qid_naldb_tot_enq_cnt_mem_waddr
    ,input  logic                  func_qid_naldb_tot_enq_cnt_mem_we
    ,input  logic [(      66)-1:0] func_qid_naldb_tot_enq_cnt_mem_wdata
    ,output logic [(      66)-1:0] func_qid_naldb_tot_enq_cnt_mem_rdata

    ,input  logic                  pf_qid_naldb_tot_enq_cnt_mem_re
    ,input  logic [(       7)-1:0] pf_qid_naldb_tot_enq_cnt_mem_raddr
    ,input  logic [(       7)-1:0] pf_qid_naldb_tot_enq_cnt_mem_waddr
    ,input  logic                  pf_qid_naldb_tot_enq_cnt_mem_we
    ,input  logic [(      66)-1:0] pf_qid_naldb_tot_enq_cnt_mem_wdata
    ,output logic [(      66)-1:0] pf_qid_naldb_tot_enq_cnt_mem_rdata

    ,output logic                  rf_qid_naldb_tot_enq_cnt_mem_re
    ,output logic                  rf_qid_naldb_tot_enq_cnt_mem_rclk
    ,output logic                  rf_qid_naldb_tot_enq_cnt_mem_rclk_rst_n
    ,output logic [(       5)-1:0] rf_qid_naldb_tot_enq_cnt_mem_raddr
    ,output logic [(       5)-1:0] rf_qid_naldb_tot_enq_cnt_mem_waddr
    ,output logic                  rf_qid_naldb_tot_enq_cnt_mem_we
    ,output logic                  rf_qid_naldb_tot_enq_cnt_mem_wclk
    ,output logic                  rf_qid_naldb_tot_enq_cnt_mem_wclk_rst_n
    ,output logic [(      66)-1:0] rf_qid_naldb_tot_enq_cnt_mem_wdata
    ,input  logic [(      66)-1:0] rf_qid_naldb_tot_enq_cnt_mem_rdata

    ,output logic                  rf_qid_naldb_tot_enq_cnt_mem_error

    ,input  logic                  func_rop_lsp_reordercmp_rx_sync_fifo_mem_re
    ,input  logic [(       3)-1:0] func_rop_lsp_reordercmp_rx_sync_fifo_mem_raddr
    ,input  logic [(       3)-1:0] func_rop_lsp_reordercmp_rx_sync_fifo_mem_waddr
    ,input  logic                  func_rop_lsp_reordercmp_rx_sync_fifo_mem_we
    ,input  logic [(      17)-1:0] func_rop_lsp_reordercmp_rx_sync_fifo_mem_wdata
    ,output logic [(      17)-1:0] func_rop_lsp_reordercmp_rx_sync_fifo_mem_rdata

    ,input  logic                  pf_rop_lsp_reordercmp_rx_sync_fifo_mem_re
    ,input  logic [(       3)-1:0] pf_rop_lsp_reordercmp_rx_sync_fifo_mem_raddr
    ,input  logic [(       3)-1:0] pf_rop_lsp_reordercmp_rx_sync_fifo_mem_waddr
    ,input  logic                  pf_rop_lsp_reordercmp_rx_sync_fifo_mem_we
    ,input  logic [(      17)-1:0] pf_rop_lsp_reordercmp_rx_sync_fifo_mem_wdata
    ,output logic [(      17)-1:0] pf_rop_lsp_reordercmp_rx_sync_fifo_mem_rdata

    ,output logic                  rf_rop_lsp_reordercmp_rx_sync_fifo_mem_re
    ,output logic                  rf_rop_lsp_reordercmp_rx_sync_fifo_mem_rclk
    ,output logic                  rf_rop_lsp_reordercmp_rx_sync_fifo_mem_rclk_rst_n
    ,output logic [(       3)-1:0] rf_rop_lsp_reordercmp_rx_sync_fifo_mem_raddr
    ,output logic [(       3)-1:0] rf_rop_lsp_reordercmp_rx_sync_fifo_mem_waddr
    ,output logic                  rf_rop_lsp_reordercmp_rx_sync_fifo_mem_we
    ,output logic                  rf_rop_lsp_reordercmp_rx_sync_fifo_mem_wclk
    ,output logic                  rf_rop_lsp_reordercmp_rx_sync_fifo_mem_wclk_rst_n
    ,output logic [(      17)-1:0] rf_rop_lsp_reordercmp_rx_sync_fifo_mem_wdata
    ,input  logic [(      17)-1:0] rf_rop_lsp_reordercmp_rx_sync_fifo_mem_rdata

    ,output logic                  rf_rop_lsp_reordercmp_rx_sync_fifo_mem_error

    ,input  logic                  func_send_atm_to_cq_rx_sync_fifo_mem_re
    ,input  logic [(       2)-1:0] func_send_atm_to_cq_rx_sync_fifo_mem_raddr
    ,input  logic [(       2)-1:0] func_send_atm_to_cq_rx_sync_fifo_mem_waddr
    ,input  logic                  func_send_atm_to_cq_rx_sync_fifo_mem_we
    ,input  logic [(      35)-1:0] func_send_atm_to_cq_rx_sync_fifo_mem_wdata
    ,output logic [(      35)-1:0] func_send_atm_to_cq_rx_sync_fifo_mem_rdata

    ,input  logic                  pf_send_atm_to_cq_rx_sync_fifo_mem_re
    ,input  logic [(       2)-1:0] pf_send_atm_to_cq_rx_sync_fifo_mem_raddr
    ,input  logic [(       2)-1:0] pf_send_atm_to_cq_rx_sync_fifo_mem_waddr
    ,input  logic                  pf_send_atm_to_cq_rx_sync_fifo_mem_we
    ,input  logic [(      35)-1:0] pf_send_atm_to_cq_rx_sync_fifo_mem_wdata
    ,output logic [(      35)-1:0] pf_send_atm_to_cq_rx_sync_fifo_mem_rdata

    ,output logic                  rf_send_atm_to_cq_rx_sync_fifo_mem_re
    ,output logic                  rf_send_atm_to_cq_rx_sync_fifo_mem_rclk
    ,output logic                  rf_send_atm_to_cq_rx_sync_fifo_mem_rclk_rst_n
    ,output logic [(       2)-1:0] rf_send_atm_to_cq_rx_sync_fifo_mem_raddr
    ,output logic [(       2)-1:0] rf_send_atm_to_cq_rx_sync_fifo_mem_waddr
    ,output logic                  rf_send_atm_to_cq_rx_sync_fifo_mem_we
    ,output logic                  rf_send_atm_to_cq_rx_sync_fifo_mem_wclk
    ,output logic                  rf_send_atm_to_cq_rx_sync_fifo_mem_wclk_rst_n
    ,output logic [(      35)-1:0] rf_send_atm_to_cq_rx_sync_fifo_mem_wdata
    ,input  logic [(      35)-1:0] rf_send_atm_to_cq_rx_sync_fifo_mem_rdata

    ,output logic                  rf_send_atm_to_cq_rx_sync_fifo_mem_error

    ,input  logic                  func_uno_atm_cmp_fifo_mem_re
    ,input  logic [(       3)-1:0] func_uno_atm_cmp_fifo_mem_raddr
    ,input  logic [(       3)-1:0] func_uno_atm_cmp_fifo_mem_waddr
    ,input  logic                  func_uno_atm_cmp_fifo_mem_we
    ,input  logic [(      20)-1:0] func_uno_atm_cmp_fifo_mem_wdata
    ,output logic [(      20)-1:0] func_uno_atm_cmp_fifo_mem_rdata

    ,input  logic                  pf_uno_atm_cmp_fifo_mem_re
    ,input  logic [(       3)-1:0] pf_uno_atm_cmp_fifo_mem_raddr
    ,input  logic [(       3)-1:0] pf_uno_atm_cmp_fifo_mem_waddr
    ,input  logic                  pf_uno_atm_cmp_fifo_mem_we
    ,input  logic [(      20)-1:0] pf_uno_atm_cmp_fifo_mem_wdata
    ,output logic [(      20)-1:0] pf_uno_atm_cmp_fifo_mem_rdata

    ,output logic                  rf_uno_atm_cmp_fifo_mem_re
    ,output logic                  rf_uno_atm_cmp_fifo_mem_rclk
    ,output logic                  rf_uno_atm_cmp_fifo_mem_rclk_rst_n
    ,output logic [(       3)-1:0] rf_uno_atm_cmp_fifo_mem_raddr
    ,output logic [(       3)-1:0] rf_uno_atm_cmp_fifo_mem_waddr
    ,output logic                  rf_uno_atm_cmp_fifo_mem_we
    ,output logic                  rf_uno_atm_cmp_fifo_mem_wclk
    ,output logic                  rf_uno_atm_cmp_fifo_mem_wclk_rst_n
    ,output logic [(      20)-1:0] rf_uno_atm_cmp_fifo_mem_wdata
    ,input  logic [(      20)-1:0] rf_uno_atm_cmp_fifo_mem_rdata

    ,output logic                  rf_uno_atm_cmp_fifo_mem_error

);

logic        rf_aqed_lsp_deq_fifo_mem_rdata_error;

logic        cfg_mem_ack_aqed_lsp_deq_fifo_mem_nc;
logic [31:0] cfg_mem_rdata_aqed_lsp_deq_fifo_mem_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (24)
        ,.DWIDTH              (9)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_aqed_lsp_deq_fifo_mem (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_aqed_lsp_deq_fifo_mem_re)
        ,.func_mem_raddr      (func_aqed_lsp_deq_fifo_mem_raddr)
        ,.func_mem_waddr      (func_aqed_lsp_deq_fifo_mem_waddr)
        ,.func_mem_we         (func_aqed_lsp_deq_fifo_mem_we)
        ,.func_mem_wdata      (func_aqed_lsp_deq_fifo_mem_wdata)
        ,.func_mem_rdata      (func_aqed_lsp_deq_fifo_mem_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_aqed_lsp_deq_fifo_mem_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_aqed_lsp_deq_fifo_mem_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_aqed_lsp_deq_fifo_mem_re)
        ,.pf_mem_raddr        (pf_aqed_lsp_deq_fifo_mem_raddr)
        ,.pf_mem_waddr        (pf_aqed_lsp_deq_fifo_mem_waddr)
        ,.pf_mem_we           (pf_aqed_lsp_deq_fifo_mem_we)
        ,.pf_mem_wdata        (pf_aqed_lsp_deq_fifo_mem_wdata)
        ,.pf_mem_rdata        (pf_aqed_lsp_deq_fifo_mem_rdata)

        ,.mem_wclk            (rf_aqed_lsp_deq_fifo_mem_wclk)
        ,.mem_rclk            (rf_aqed_lsp_deq_fifo_mem_rclk)
        ,.mem_wclk_rst_n      (rf_aqed_lsp_deq_fifo_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_aqed_lsp_deq_fifo_mem_rclk_rst_n)
        ,.mem_re              (rf_aqed_lsp_deq_fifo_mem_re)
        ,.mem_raddr           (rf_aqed_lsp_deq_fifo_mem_raddr)
        ,.mem_waddr           (rf_aqed_lsp_deq_fifo_mem_waddr)
        ,.mem_we              (rf_aqed_lsp_deq_fifo_mem_we)
        ,.mem_wdata           (rf_aqed_lsp_deq_fifo_mem_wdata)
        ,.mem_rdata           (rf_aqed_lsp_deq_fifo_mem_rdata)

        ,.mem_rdata_error     (rf_aqed_lsp_deq_fifo_mem_rdata_error)
        ,.error               (rf_aqed_lsp_deq_fifo_mem_error)
);

logic        rf_atm_cmp_fifo_mem_rdata_error;

logic        cfg_mem_ack_atm_cmp_fifo_mem_nc;
logic [31:0] cfg_mem_rdata_atm_cmp_fifo_mem_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (8)
        ,.DWIDTH              (55)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_atm_cmp_fifo_mem (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_atm_cmp_fifo_mem_re)
        ,.func_mem_raddr      (func_atm_cmp_fifo_mem_raddr)
        ,.func_mem_waddr      (func_atm_cmp_fifo_mem_waddr)
        ,.func_mem_we         (func_atm_cmp_fifo_mem_we)
        ,.func_mem_wdata      (func_atm_cmp_fifo_mem_wdata)
        ,.func_mem_rdata      (func_atm_cmp_fifo_mem_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_atm_cmp_fifo_mem_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_atm_cmp_fifo_mem_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_atm_cmp_fifo_mem_re)
        ,.pf_mem_raddr        (pf_atm_cmp_fifo_mem_raddr)
        ,.pf_mem_waddr        (pf_atm_cmp_fifo_mem_waddr)
        ,.pf_mem_we           (pf_atm_cmp_fifo_mem_we)
        ,.pf_mem_wdata        (pf_atm_cmp_fifo_mem_wdata)
        ,.pf_mem_rdata        (pf_atm_cmp_fifo_mem_rdata)

        ,.mem_wclk            (rf_atm_cmp_fifo_mem_wclk)
        ,.mem_rclk            (rf_atm_cmp_fifo_mem_rclk)
        ,.mem_wclk_rst_n      (rf_atm_cmp_fifo_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_atm_cmp_fifo_mem_rclk_rst_n)
        ,.mem_re              (rf_atm_cmp_fifo_mem_re)
        ,.mem_raddr           (rf_atm_cmp_fifo_mem_raddr)
        ,.mem_waddr           (rf_atm_cmp_fifo_mem_waddr)
        ,.mem_we              (rf_atm_cmp_fifo_mem_we)
        ,.mem_wdata           (rf_atm_cmp_fifo_mem_wdata)
        ,.mem_rdata           (rf_atm_cmp_fifo_mem_rdata)

        ,.mem_rdata_error     (rf_atm_cmp_fifo_mem_rdata_error)
        ,.error               (rf_atm_cmp_fifo_mem_error)
);

logic [(       2)-1:0] rf_cfg_atm_qid_dpth_thrsh_mem_raddr_nc ;
logic [(       2)-1:0] rf_cfg_atm_qid_dpth_thrsh_mem_waddr_nc ;

logic        rf_cfg_atm_qid_dpth_thrsh_mem_rdata_error;

hqm_AW_rfrw_access #( 
         .DEPTH               (32)
        ,.DWIDTH              (16)
        ,.AWIDTHPAD           (2)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_cfg_atm_qid_dpth_thrsh_mem (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_cfg_atm_qid_dpth_thrsh_mem_re)
        ,.func_mem_addr       (func_cfg_atm_qid_dpth_thrsh_mem_addr)
        ,.func_mem_we         (func_cfg_atm_qid_dpth_thrsh_mem_we)
        ,.func_mem_wdata      (func_cfg_atm_qid_dpth_thrsh_mem_wdata)
        ,.func_mem_rdata      (func_cfg_atm_qid_dpth_thrsh_mem_rdata)

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

        ,.pf_mem_re           (pf_cfg_atm_qid_dpth_thrsh_mem_re)
        ,.pf_mem_addr         (pf_cfg_atm_qid_dpth_thrsh_mem_addr)
        ,.pf_mem_we           (pf_cfg_atm_qid_dpth_thrsh_mem_we)
        ,.pf_mem_wdata        (pf_cfg_atm_qid_dpth_thrsh_mem_wdata)
        ,.pf_mem_rdata        (pf_cfg_atm_qid_dpth_thrsh_mem_rdata)

        ,.mem_wclk            (rf_cfg_atm_qid_dpth_thrsh_mem_wclk)
        ,.mem_rclk            (rf_cfg_atm_qid_dpth_thrsh_mem_rclk)
        ,.mem_wclk_rst_n      (rf_cfg_atm_qid_dpth_thrsh_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_cfg_atm_qid_dpth_thrsh_mem_rclk_rst_n)
        ,.mem_re              (rf_cfg_atm_qid_dpth_thrsh_mem_re)
        ,.mem_raddr           ({rf_cfg_atm_qid_dpth_thrsh_mem_raddr_nc , rf_cfg_atm_qid_dpth_thrsh_mem_raddr})
        ,.mem_waddr           ({rf_cfg_atm_qid_dpth_thrsh_mem_waddr_nc , rf_cfg_atm_qid_dpth_thrsh_mem_waddr})
        ,.mem_we              (rf_cfg_atm_qid_dpth_thrsh_mem_we)
        ,.mem_wdata           (rf_cfg_atm_qid_dpth_thrsh_mem_wdata)
        ,.mem_rdata           (rf_cfg_atm_qid_dpth_thrsh_mem_rdata)

        ,.mem_rdata_error     (rf_cfg_atm_qid_dpth_thrsh_mem_rdata_error)
        ,.error               (rf_cfg_atm_qid_dpth_thrsh_mem_error)
);

logic        rf_cfg_cq2priov_mem_rdata_error;

hqm_AW_rfrw_access #( 
         .DEPTH               (32)
        ,.DWIDTH              (33)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_cfg_cq2priov_mem (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_cfg_cq2priov_mem_re)
        ,.func_mem_addr       (func_cfg_cq2priov_mem_addr)
        ,.func_mem_we         (func_cfg_cq2priov_mem_we)
        ,.func_mem_wdata      (func_cfg_cq2priov_mem_wdata)
        ,.func_mem_rdata      (func_cfg_cq2priov_mem_rdata)

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

        ,.pf_mem_re           (pf_cfg_cq2priov_mem_re)
        ,.pf_mem_addr         (pf_cfg_cq2priov_mem_addr)
        ,.pf_mem_we           (pf_cfg_cq2priov_mem_we)
        ,.pf_mem_wdata        (pf_cfg_cq2priov_mem_wdata)
        ,.pf_mem_rdata        (pf_cfg_cq2priov_mem_rdata)

        ,.mem_wclk            (rf_cfg_cq2priov_mem_wclk)
        ,.mem_rclk            (rf_cfg_cq2priov_mem_rclk)
        ,.mem_wclk_rst_n      (rf_cfg_cq2priov_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_cfg_cq2priov_mem_rclk_rst_n)
        ,.mem_re              (rf_cfg_cq2priov_mem_re)
        ,.mem_raddr           (rf_cfg_cq2priov_mem_raddr)
        ,.mem_waddr           (rf_cfg_cq2priov_mem_waddr)
        ,.mem_we              (rf_cfg_cq2priov_mem_we)
        ,.mem_wdata           (rf_cfg_cq2priov_mem_wdata)
        ,.mem_rdata           (rf_cfg_cq2priov_mem_rdata)

        ,.mem_rdata_error     (rf_cfg_cq2priov_mem_rdata_error)
        ,.error               (rf_cfg_cq2priov_mem_error)
);

logic        rf_cfg_cq2priov_odd_mem_rdata_error;

logic        cfg_mem_ack_cfg_cq2priov_odd_mem_nc;
logic [31:0] cfg_mem_rdata_cfg_cq2priov_odd_mem_nc;

hqm_AW_rfrw_access #( 
         .DEPTH               (32)
        ,.DWIDTH              (33)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_cfg_cq2priov_odd_mem (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_cfg_cq2priov_odd_mem_re)
        ,.func_mem_addr       (func_cfg_cq2priov_odd_mem_addr)
        ,.func_mem_we         (func_cfg_cq2priov_odd_mem_we)
        ,.func_mem_wdata      (func_cfg_cq2priov_odd_mem_wdata)
        ,.func_mem_rdata      (func_cfg_cq2priov_odd_mem_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_cfg_cq2priov_odd_mem_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_cfg_cq2priov_odd_mem_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_cfg_cq2priov_odd_mem_re)
        ,.pf_mem_addr         (pf_cfg_cq2priov_odd_mem_addr)
        ,.pf_mem_we           (pf_cfg_cq2priov_odd_mem_we)
        ,.pf_mem_wdata        (pf_cfg_cq2priov_odd_mem_wdata)
        ,.pf_mem_rdata        (pf_cfg_cq2priov_odd_mem_rdata)

        ,.mem_wclk            (rf_cfg_cq2priov_odd_mem_wclk)
        ,.mem_rclk            (rf_cfg_cq2priov_odd_mem_rclk)
        ,.mem_wclk_rst_n      (rf_cfg_cq2priov_odd_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_cfg_cq2priov_odd_mem_rclk_rst_n)
        ,.mem_re              (rf_cfg_cq2priov_odd_mem_re)
        ,.mem_raddr           (rf_cfg_cq2priov_odd_mem_raddr)
        ,.mem_waddr           (rf_cfg_cq2priov_odd_mem_waddr)
        ,.mem_we              (rf_cfg_cq2priov_odd_mem_we)
        ,.mem_wdata           (rf_cfg_cq2priov_odd_mem_wdata)
        ,.mem_rdata           (rf_cfg_cq2priov_odd_mem_rdata)

        ,.mem_rdata_error     (rf_cfg_cq2priov_odd_mem_rdata_error)
        ,.error               (rf_cfg_cq2priov_odd_mem_error)
);

logic        rf_cfg_cq2qid_0_mem_rdata_error;

hqm_AW_rfrw_access #( 
         .DEPTH               (32)
        ,.DWIDTH              (29)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_cfg_cq2qid_0_mem (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_cfg_cq2qid_0_mem_re)
        ,.func_mem_addr       (func_cfg_cq2qid_0_mem_addr)
        ,.func_mem_we         (func_cfg_cq2qid_0_mem_we)
        ,.func_mem_wdata      (func_cfg_cq2qid_0_mem_wdata)
        ,.func_mem_rdata      (func_cfg_cq2qid_0_mem_rdata)

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

        ,.pf_mem_re           (pf_cfg_cq2qid_0_mem_re)
        ,.pf_mem_addr         (pf_cfg_cq2qid_0_mem_addr)
        ,.pf_mem_we           (pf_cfg_cq2qid_0_mem_we)
        ,.pf_mem_wdata        (pf_cfg_cq2qid_0_mem_wdata)
        ,.pf_mem_rdata        (pf_cfg_cq2qid_0_mem_rdata)

        ,.mem_wclk            (rf_cfg_cq2qid_0_mem_wclk)
        ,.mem_rclk            (rf_cfg_cq2qid_0_mem_rclk)
        ,.mem_wclk_rst_n      (rf_cfg_cq2qid_0_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_cfg_cq2qid_0_mem_rclk_rst_n)
        ,.mem_re              (rf_cfg_cq2qid_0_mem_re)
        ,.mem_raddr           (rf_cfg_cq2qid_0_mem_raddr)
        ,.mem_waddr           (rf_cfg_cq2qid_0_mem_waddr)
        ,.mem_we              (rf_cfg_cq2qid_0_mem_we)
        ,.mem_wdata           (rf_cfg_cq2qid_0_mem_wdata)
        ,.mem_rdata           (rf_cfg_cq2qid_0_mem_rdata)

        ,.mem_rdata_error     (rf_cfg_cq2qid_0_mem_rdata_error)
        ,.error               (rf_cfg_cq2qid_0_mem_error)
);

logic        rf_cfg_cq2qid_0_odd_mem_rdata_error;

logic        cfg_mem_ack_cfg_cq2qid_0_odd_mem_nc;
logic [31:0] cfg_mem_rdata_cfg_cq2qid_0_odd_mem_nc;

hqm_AW_rfrw_access #( 
         .DEPTH               (32)
        ,.DWIDTH              (29)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_cfg_cq2qid_0_odd_mem (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_cfg_cq2qid_0_odd_mem_re)
        ,.func_mem_addr       (func_cfg_cq2qid_0_odd_mem_addr)
        ,.func_mem_we         (func_cfg_cq2qid_0_odd_mem_we)
        ,.func_mem_wdata      (func_cfg_cq2qid_0_odd_mem_wdata)
        ,.func_mem_rdata      (func_cfg_cq2qid_0_odd_mem_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_cfg_cq2qid_0_odd_mem_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_cfg_cq2qid_0_odd_mem_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_cfg_cq2qid_0_odd_mem_re)
        ,.pf_mem_addr         (pf_cfg_cq2qid_0_odd_mem_addr)
        ,.pf_mem_we           (pf_cfg_cq2qid_0_odd_mem_we)
        ,.pf_mem_wdata        (pf_cfg_cq2qid_0_odd_mem_wdata)
        ,.pf_mem_rdata        (pf_cfg_cq2qid_0_odd_mem_rdata)

        ,.mem_wclk            (rf_cfg_cq2qid_0_odd_mem_wclk)
        ,.mem_rclk            (rf_cfg_cq2qid_0_odd_mem_rclk)
        ,.mem_wclk_rst_n      (rf_cfg_cq2qid_0_odd_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_cfg_cq2qid_0_odd_mem_rclk_rst_n)
        ,.mem_re              (rf_cfg_cq2qid_0_odd_mem_re)
        ,.mem_raddr           (rf_cfg_cq2qid_0_odd_mem_raddr)
        ,.mem_waddr           (rf_cfg_cq2qid_0_odd_mem_waddr)
        ,.mem_we              (rf_cfg_cq2qid_0_odd_mem_we)
        ,.mem_wdata           (rf_cfg_cq2qid_0_odd_mem_wdata)
        ,.mem_rdata           (rf_cfg_cq2qid_0_odd_mem_rdata)

        ,.mem_rdata_error     (rf_cfg_cq2qid_0_odd_mem_rdata_error)
        ,.error               (rf_cfg_cq2qid_0_odd_mem_error)
);

logic        rf_cfg_cq2qid_1_mem_rdata_error;

hqm_AW_rfrw_access #( 
         .DEPTH               (32)
        ,.DWIDTH              (29)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_cfg_cq2qid_1_mem (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_cfg_cq2qid_1_mem_re)
        ,.func_mem_addr       (func_cfg_cq2qid_1_mem_addr)
        ,.func_mem_we         (func_cfg_cq2qid_1_mem_we)
        ,.func_mem_wdata      (func_cfg_cq2qid_1_mem_wdata)
        ,.func_mem_rdata      (func_cfg_cq2qid_1_mem_rdata)

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

        ,.pf_mem_re           (pf_cfg_cq2qid_1_mem_re)
        ,.pf_mem_addr         (pf_cfg_cq2qid_1_mem_addr)
        ,.pf_mem_we           (pf_cfg_cq2qid_1_mem_we)
        ,.pf_mem_wdata        (pf_cfg_cq2qid_1_mem_wdata)
        ,.pf_mem_rdata        (pf_cfg_cq2qid_1_mem_rdata)

        ,.mem_wclk            (rf_cfg_cq2qid_1_mem_wclk)
        ,.mem_rclk            (rf_cfg_cq2qid_1_mem_rclk)
        ,.mem_wclk_rst_n      (rf_cfg_cq2qid_1_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_cfg_cq2qid_1_mem_rclk_rst_n)
        ,.mem_re              (rf_cfg_cq2qid_1_mem_re)
        ,.mem_raddr           (rf_cfg_cq2qid_1_mem_raddr)
        ,.mem_waddr           (rf_cfg_cq2qid_1_mem_waddr)
        ,.mem_we              (rf_cfg_cq2qid_1_mem_we)
        ,.mem_wdata           (rf_cfg_cq2qid_1_mem_wdata)
        ,.mem_rdata           (rf_cfg_cq2qid_1_mem_rdata)

        ,.mem_rdata_error     (rf_cfg_cq2qid_1_mem_rdata_error)
        ,.error               (rf_cfg_cq2qid_1_mem_error)
);

logic        rf_cfg_cq2qid_1_odd_mem_rdata_error;

logic        cfg_mem_ack_cfg_cq2qid_1_odd_mem_nc;
logic [31:0] cfg_mem_rdata_cfg_cq2qid_1_odd_mem_nc;

hqm_AW_rfrw_access #( 
         .DEPTH               (32)
        ,.DWIDTH              (29)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_cfg_cq2qid_1_odd_mem (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_cfg_cq2qid_1_odd_mem_re)
        ,.func_mem_addr       (func_cfg_cq2qid_1_odd_mem_addr)
        ,.func_mem_we         (func_cfg_cq2qid_1_odd_mem_we)
        ,.func_mem_wdata      (func_cfg_cq2qid_1_odd_mem_wdata)
        ,.func_mem_rdata      (func_cfg_cq2qid_1_odd_mem_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_cfg_cq2qid_1_odd_mem_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_cfg_cq2qid_1_odd_mem_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_cfg_cq2qid_1_odd_mem_re)
        ,.pf_mem_addr         (pf_cfg_cq2qid_1_odd_mem_addr)
        ,.pf_mem_we           (pf_cfg_cq2qid_1_odd_mem_we)
        ,.pf_mem_wdata        (pf_cfg_cq2qid_1_odd_mem_wdata)
        ,.pf_mem_rdata        (pf_cfg_cq2qid_1_odd_mem_rdata)

        ,.mem_wclk            (rf_cfg_cq2qid_1_odd_mem_wclk)
        ,.mem_rclk            (rf_cfg_cq2qid_1_odd_mem_rclk)
        ,.mem_wclk_rst_n      (rf_cfg_cq2qid_1_odd_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_cfg_cq2qid_1_odd_mem_rclk_rst_n)
        ,.mem_re              (rf_cfg_cq2qid_1_odd_mem_re)
        ,.mem_raddr           (rf_cfg_cq2qid_1_odd_mem_raddr)
        ,.mem_waddr           (rf_cfg_cq2qid_1_odd_mem_waddr)
        ,.mem_we              (rf_cfg_cq2qid_1_odd_mem_we)
        ,.mem_wdata           (rf_cfg_cq2qid_1_odd_mem_wdata)
        ,.mem_rdata           (rf_cfg_cq2qid_1_odd_mem_rdata)

        ,.mem_rdata_error     (rf_cfg_cq2qid_1_odd_mem_rdata_error)
        ,.error               (rf_cfg_cq2qid_1_odd_mem_error)
);

logic        rf_cfg_cq_ldb_inflight_limit_mem_rdata_error;

hqm_AW_rfrw_access #( 
         .DEPTH               (64)
        ,.DWIDTH              (14)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_cfg_cq_ldb_inflight_limit_mem (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_cfg_cq_ldb_inflight_limit_mem_re)
        ,.func_mem_addr       (func_cfg_cq_ldb_inflight_limit_mem_addr)
        ,.func_mem_we         (func_cfg_cq_ldb_inflight_limit_mem_we)
        ,.func_mem_wdata      (func_cfg_cq_ldb_inflight_limit_mem_wdata)
        ,.func_mem_rdata      (func_cfg_cq_ldb_inflight_limit_mem_rdata)

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

        ,.pf_mem_re           (pf_cfg_cq_ldb_inflight_limit_mem_re)
        ,.pf_mem_addr         (pf_cfg_cq_ldb_inflight_limit_mem_addr)
        ,.pf_mem_we           (pf_cfg_cq_ldb_inflight_limit_mem_we)
        ,.pf_mem_wdata        (pf_cfg_cq_ldb_inflight_limit_mem_wdata)
        ,.pf_mem_rdata        (pf_cfg_cq_ldb_inflight_limit_mem_rdata)

        ,.mem_wclk            (rf_cfg_cq_ldb_inflight_limit_mem_wclk)
        ,.mem_rclk            (rf_cfg_cq_ldb_inflight_limit_mem_rclk)
        ,.mem_wclk_rst_n      (rf_cfg_cq_ldb_inflight_limit_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_cfg_cq_ldb_inflight_limit_mem_rclk_rst_n)
        ,.mem_re              (rf_cfg_cq_ldb_inflight_limit_mem_re)
        ,.mem_raddr           (rf_cfg_cq_ldb_inflight_limit_mem_raddr)
        ,.mem_waddr           (rf_cfg_cq_ldb_inflight_limit_mem_waddr)
        ,.mem_we              (rf_cfg_cq_ldb_inflight_limit_mem_we)
        ,.mem_wdata           (rf_cfg_cq_ldb_inflight_limit_mem_wdata)
        ,.mem_rdata           (rf_cfg_cq_ldb_inflight_limit_mem_rdata)

        ,.mem_rdata_error     (rf_cfg_cq_ldb_inflight_limit_mem_rdata_error)
        ,.error               (rf_cfg_cq_ldb_inflight_limit_mem_error)
);

logic        rf_cfg_cq_ldb_inflight_threshold_mem_rdata_error;

hqm_AW_rfrw_access #( 
         .DEPTH               (64)
        ,.DWIDTH              (14)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_cfg_cq_ldb_inflight_threshold_mem (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_cfg_cq_ldb_inflight_threshold_mem_re)
        ,.func_mem_addr       (func_cfg_cq_ldb_inflight_threshold_mem_addr)
        ,.func_mem_we         (func_cfg_cq_ldb_inflight_threshold_mem_we)
        ,.func_mem_wdata      (func_cfg_cq_ldb_inflight_threshold_mem_wdata)
        ,.func_mem_rdata      (func_cfg_cq_ldb_inflight_threshold_mem_rdata)

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

        ,.pf_mem_re           (pf_cfg_cq_ldb_inflight_threshold_mem_re)
        ,.pf_mem_addr         (pf_cfg_cq_ldb_inflight_threshold_mem_addr)
        ,.pf_mem_we           (pf_cfg_cq_ldb_inflight_threshold_mem_we)
        ,.pf_mem_wdata        (pf_cfg_cq_ldb_inflight_threshold_mem_wdata)
        ,.pf_mem_rdata        (pf_cfg_cq_ldb_inflight_threshold_mem_rdata)

        ,.mem_wclk            (rf_cfg_cq_ldb_inflight_threshold_mem_wclk)
        ,.mem_rclk            (rf_cfg_cq_ldb_inflight_threshold_mem_rclk)
        ,.mem_wclk_rst_n      (rf_cfg_cq_ldb_inflight_threshold_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_cfg_cq_ldb_inflight_threshold_mem_rclk_rst_n)
        ,.mem_re              (rf_cfg_cq_ldb_inflight_threshold_mem_re)
        ,.mem_raddr           (rf_cfg_cq_ldb_inflight_threshold_mem_raddr)
        ,.mem_waddr           (rf_cfg_cq_ldb_inflight_threshold_mem_waddr)
        ,.mem_we              (rf_cfg_cq_ldb_inflight_threshold_mem_we)
        ,.mem_wdata           (rf_cfg_cq_ldb_inflight_threshold_mem_wdata)
        ,.mem_rdata           (rf_cfg_cq_ldb_inflight_threshold_mem_rdata)

        ,.mem_rdata_error     (rf_cfg_cq_ldb_inflight_threshold_mem_rdata_error)
        ,.error               (rf_cfg_cq_ldb_inflight_threshold_mem_error)
);

logic        rf_cfg_cq_ldb_token_depth_select_mem_rdata_error;

hqm_AW_rfrw_access #( 
         .DEPTH               (64)
        ,.DWIDTH              (5)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_cfg_cq_ldb_token_depth_select_mem (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_cfg_cq_ldb_token_depth_select_mem_re)
        ,.func_mem_addr       (func_cfg_cq_ldb_token_depth_select_mem_addr)
        ,.func_mem_we         (func_cfg_cq_ldb_token_depth_select_mem_we)
        ,.func_mem_wdata      (func_cfg_cq_ldb_token_depth_select_mem_wdata)
        ,.func_mem_rdata      (func_cfg_cq_ldb_token_depth_select_mem_rdata)

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

        ,.pf_mem_re           (pf_cfg_cq_ldb_token_depth_select_mem_re)
        ,.pf_mem_addr         (pf_cfg_cq_ldb_token_depth_select_mem_addr)
        ,.pf_mem_we           (pf_cfg_cq_ldb_token_depth_select_mem_we)
        ,.pf_mem_wdata        (pf_cfg_cq_ldb_token_depth_select_mem_wdata)
        ,.pf_mem_rdata        (pf_cfg_cq_ldb_token_depth_select_mem_rdata)

        ,.mem_wclk            (rf_cfg_cq_ldb_token_depth_select_mem_wclk)
        ,.mem_rclk            (rf_cfg_cq_ldb_token_depth_select_mem_rclk)
        ,.mem_wclk_rst_n      (rf_cfg_cq_ldb_token_depth_select_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_cfg_cq_ldb_token_depth_select_mem_rclk_rst_n)
        ,.mem_re              (rf_cfg_cq_ldb_token_depth_select_mem_re)
        ,.mem_raddr           (rf_cfg_cq_ldb_token_depth_select_mem_raddr)
        ,.mem_waddr           (rf_cfg_cq_ldb_token_depth_select_mem_waddr)
        ,.mem_we              (rf_cfg_cq_ldb_token_depth_select_mem_we)
        ,.mem_wdata           (rf_cfg_cq_ldb_token_depth_select_mem_wdata)
        ,.mem_rdata           (rf_cfg_cq_ldb_token_depth_select_mem_rdata)

        ,.mem_rdata_error     (rf_cfg_cq_ldb_token_depth_select_mem_rdata_error)
        ,.error               (rf_cfg_cq_ldb_token_depth_select_mem_error)
);

logic        rf_cfg_cq_ldb_wu_limit_mem_rdata_error;

hqm_AW_rfw_access #( 
         .DEPTH               (64)
        ,.DWIDTH              (17)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_cfg_cq_ldb_wu_limit_mem (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_cfg_cq_ldb_wu_limit_mem_re)
        ,.func_mem_raddr      (func_cfg_cq_ldb_wu_limit_mem_raddr)
        ,.func_mem_waddr      (func_cfg_cq_ldb_wu_limit_mem_waddr)
        ,.func_mem_we         (func_cfg_cq_ldb_wu_limit_mem_we)
        ,.func_mem_wdata      (func_cfg_cq_ldb_wu_limit_mem_wdata)
        ,.func_mem_rdata      (func_cfg_cq_ldb_wu_limit_mem_rdata)

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

        ,.pf_mem_re           (pf_cfg_cq_ldb_wu_limit_mem_re)
        ,.pf_mem_raddr        (pf_cfg_cq_ldb_wu_limit_mem_raddr)
        ,.pf_mem_waddr        (pf_cfg_cq_ldb_wu_limit_mem_waddr)
        ,.pf_mem_we           (pf_cfg_cq_ldb_wu_limit_mem_we)
        ,.pf_mem_wdata        (pf_cfg_cq_ldb_wu_limit_mem_wdata)
        ,.pf_mem_rdata        (pf_cfg_cq_ldb_wu_limit_mem_rdata)

        ,.mem_wclk            (rf_cfg_cq_ldb_wu_limit_mem_wclk)
        ,.mem_rclk            (rf_cfg_cq_ldb_wu_limit_mem_rclk)
        ,.mem_wclk_rst_n      (rf_cfg_cq_ldb_wu_limit_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_cfg_cq_ldb_wu_limit_mem_rclk_rst_n)
        ,.mem_re              (rf_cfg_cq_ldb_wu_limit_mem_re)
        ,.mem_raddr           (rf_cfg_cq_ldb_wu_limit_mem_raddr)
        ,.mem_waddr           (rf_cfg_cq_ldb_wu_limit_mem_waddr)
        ,.mem_we              (rf_cfg_cq_ldb_wu_limit_mem_we)
        ,.mem_wdata           (rf_cfg_cq_ldb_wu_limit_mem_wdata)
        ,.mem_rdata           (rf_cfg_cq_ldb_wu_limit_mem_rdata)

        ,.mem_rdata_error     (rf_cfg_cq_ldb_wu_limit_mem_rdata_error)
        ,.error               (rf_cfg_cq_ldb_wu_limit_mem_error)
);

logic [(       1)-1:0] rf_cfg_dir_qid_dpth_thrsh_mem_raddr_nc ;
logic [(       1)-1:0] rf_cfg_dir_qid_dpth_thrsh_mem_waddr_nc ;

logic        rf_cfg_dir_qid_dpth_thrsh_mem_rdata_error;

hqm_AW_rfrw_access #( 
         .DEPTH               (64)
        ,.DWIDTH              (16)
        ,.AWIDTHPAD           (1)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_cfg_dir_qid_dpth_thrsh_mem (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_cfg_dir_qid_dpth_thrsh_mem_re)
        ,.func_mem_addr       (func_cfg_dir_qid_dpth_thrsh_mem_addr)
        ,.func_mem_we         (func_cfg_dir_qid_dpth_thrsh_mem_we)
        ,.func_mem_wdata      (func_cfg_dir_qid_dpth_thrsh_mem_wdata)
        ,.func_mem_rdata      (func_cfg_dir_qid_dpth_thrsh_mem_rdata)

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

        ,.pf_mem_re           (pf_cfg_dir_qid_dpth_thrsh_mem_re)
        ,.pf_mem_addr         (pf_cfg_dir_qid_dpth_thrsh_mem_addr)
        ,.pf_mem_we           (pf_cfg_dir_qid_dpth_thrsh_mem_we)
        ,.pf_mem_wdata        (pf_cfg_dir_qid_dpth_thrsh_mem_wdata)
        ,.pf_mem_rdata        (pf_cfg_dir_qid_dpth_thrsh_mem_rdata)

        ,.mem_wclk            (rf_cfg_dir_qid_dpth_thrsh_mem_wclk)
        ,.mem_rclk            (rf_cfg_dir_qid_dpth_thrsh_mem_rclk)
        ,.mem_wclk_rst_n      (rf_cfg_dir_qid_dpth_thrsh_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_cfg_dir_qid_dpth_thrsh_mem_rclk_rst_n)
        ,.mem_re              (rf_cfg_dir_qid_dpth_thrsh_mem_re)
        ,.mem_raddr           ({rf_cfg_dir_qid_dpth_thrsh_mem_raddr_nc , rf_cfg_dir_qid_dpth_thrsh_mem_raddr})
        ,.mem_waddr           ({rf_cfg_dir_qid_dpth_thrsh_mem_waddr_nc , rf_cfg_dir_qid_dpth_thrsh_mem_waddr})
        ,.mem_we              (rf_cfg_dir_qid_dpth_thrsh_mem_we)
        ,.mem_wdata           (rf_cfg_dir_qid_dpth_thrsh_mem_wdata)
        ,.mem_rdata           (rf_cfg_dir_qid_dpth_thrsh_mem_rdata)

        ,.mem_rdata_error     (rf_cfg_dir_qid_dpth_thrsh_mem_rdata_error)
        ,.error               (rf_cfg_dir_qid_dpth_thrsh_mem_error)
);

logic [(       2)-1:0] rf_cfg_nalb_qid_dpth_thrsh_mem_raddr_nc ;
logic [(       2)-1:0] rf_cfg_nalb_qid_dpth_thrsh_mem_waddr_nc ;

logic        rf_cfg_nalb_qid_dpth_thrsh_mem_rdata_error;

hqm_AW_rfrw_access #( 
         .DEPTH               (32)
        ,.DWIDTH              (16)
        ,.AWIDTHPAD           (2)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_cfg_nalb_qid_dpth_thrsh_mem (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_cfg_nalb_qid_dpth_thrsh_mem_re)
        ,.func_mem_addr       (func_cfg_nalb_qid_dpth_thrsh_mem_addr)
        ,.func_mem_we         (func_cfg_nalb_qid_dpth_thrsh_mem_we)
        ,.func_mem_wdata      (func_cfg_nalb_qid_dpth_thrsh_mem_wdata)
        ,.func_mem_rdata      (func_cfg_nalb_qid_dpth_thrsh_mem_rdata)

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

        ,.pf_mem_re           (pf_cfg_nalb_qid_dpth_thrsh_mem_re)
        ,.pf_mem_addr         (pf_cfg_nalb_qid_dpth_thrsh_mem_addr)
        ,.pf_mem_we           (pf_cfg_nalb_qid_dpth_thrsh_mem_we)
        ,.pf_mem_wdata        (pf_cfg_nalb_qid_dpth_thrsh_mem_wdata)
        ,.pf_mem_rdata        (pf_cfg_nalb_qid_dpth_thrsh_mem_rdata)

        ,.mem_wclk            (rf_cfg_nalb_qid_dpth_thrsh_mem_wclk)
        ,.mem_rclk            (rf_cfg_nalb_qid_dpth_thrsh_mem_rclk)
        ,.mem_wclk_rst_n      (rf_cfg_nalb_qid_dpth_thrsh_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_cfg_nalb_qid_dpth_thrsh_mem_rclk_rst_n)
        ,.mem_re              (rf_cfg_nalb_qid_dpth_thrsh_mem_re)
        ,.mem_raddr           ({rf_cfg_nalb_qid_dpth_thrsh_mem_raddr_nc , rf_cfg_nalb_qid_dpth_thrsh_mem_raddr})
        ,.mem_waddr           ({rf_cfg_nalb_qid_dpth_thrsh_mem_waddr_nc , rf_cfg_nalb_qid_dpth_thrsh_mem_waddr})
        ,.mem_we              (rf_cfg_nalb_qid_dpth_thrsh_mem_we)
        ,.mem_wdata           (rf_cfg_nalb_qid_dpth_thrsh_mem_wdata)
        ,.mem_rdata           (rf_cfg_nalb_qid_dpth_thrsh_mem_rdata)

        ,.mem_rdata_error     (rf_cfg_nalb_qid_dpth_thrsh_mem_rdata_error)
        ,.error               (rf_cfg_nalb_qid_dpth_thrsh_mem_error)
);

logic [(       2)-1:0] rf_cfg_qid_aqed_active_limit_mem_raddr_nc ;
logic [(       2)-1:0] rf_cfg_qid_aqed_active_limit_mem_waddr_nc ;

logic        rf_cfg_qid_aqed_active_limit_mem_rdata_error;

hqm_AW_rfrw_access #( 
         .DEPTH               (32)
        ,.DWIDTH              (13)
        ,.AWIDTHPAD           (2)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_cfg_qid_aqed_active_limit_mem (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_cfg_qid_aqed_active_limit_mem_re)
        ,.func_mem_addr       (func_cfg_qid_aqed_active_limit_mem_addr)
        ,.func_mem_we         (func_cfg_qid_aqed_active_limit_mem_we)
        ,.func_mem_wdata      (func_cfg_qid_aqed_active_limit_mem_wdata)
        ,.func_mem_rdata      (func_cfg_qid_aqed_active_limit_mem_rdata)

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

        ,.pf_mem_re           (pf_cfg_qid_aqed_active_limit_mem_re)
        ,.pf_mem_addr         (pf_cfg_qid_aqed_active_limit_mem_addr)
        ,.pf_mem_we           (pf_cfg_qid_aqed_active_limit_mem_we)
        ,.pf_mem_wdata        (pf_cfg_qid_aqed_active_limit_mem_wdata)
        ,.pf_mem_rdata        (pf_cfg_qid_aqed_active_limit_mem_rdata)

        ,.mem_wclk            (rf_cfg_qid_aqed_active_limit_mem_wclk)
        ,.mem_rclk            (rf_cfg_qid_aqed_active_limit_mem_rclk)
        ,.mem_wclk_rst_n      (rf_cfg_qid_aqed_active_limit_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_cfg_qid_aqed_active_limit_mem_rclk_rst_n)
        ,.mem_re              (rf_cfg_qid_aqed_active_limit_mem_re)
        ,.mem_raddr           ({rf_cfg_qid_aqed_active_limit_mem_raddr_nc , rf_cfg_qid_aqed_active_limit_mem_raddr})
        ,.mem_waddr           ({rf_cfg_qid_aqed_active_limit_mem_waddr_nc , rf_cfg_qid_aqed_active_limit_mem_waddr})
        ,.mem_we              (rf_cfg_qid_aqed_active_limit_mem_we)
        ,.mem_wdata           (rf_cfg_qid_aqed_active_limit_mem_wdata)
        ,.mem_rdata           (rf_cfg_qid_aqed_active_limit_mem_rdata)

        ,.mem_rdata_error     (rf_cfg_qid_aqed_active_limit_mem_rdata_error)
        ,.error               (rf_cfg_qid_aqed_active_limit_mem_error)
);

logic [(       2)-1:0] rf_cfg_qid_ldb_inflight_limit_mem_raddr_nc ;
logic [(       2)-1:0] rf_cfg_qid_ldb_inflight_limit_mem_waddr_nc ;

logic        rf_cfg_qid_ldb_inflight_limit_mem_rdata_error;

hqm_AW_rfrw_access #( 
         .DEPTH               (32)
        ,.DWIDTH              (13)
        ,.AWIDTHPAD           (2)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_cfg_qid_ldb_inflight_limit_mem (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_cfg_qid_ldb_inflight_limit_mem_re)
        ,.func_mem_addr       (func_cfg_qid_ldb_inflight_limit_mem_addr)
        ,.func_mem_we         (func_cfg_qid_ldb_inflight_limit_mem_we)
        ,.func_mem_wdata      (func_cfg_qid_ldb_inflight_limit_mem_wdata)
        ,.func_mem_rdata      (func_cfg_qid_ldb_inflight_limit_mem_rdata)

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

        ,.pf_mem_re           (pf_cfg_qid_ldb_inflight_limit_mem_re)
        ,.pf_mem_addr         (pf_cfg_qid_ldb_inflight_limit_mem_addr)
        ,.pf_mem_we           (pf_cfg_qid_ldb_inflight_limit_mem_we)
        ,.pf_mem_wdata        (pf_cfg_qid_ldb_inflight_limit_mem_wdata)
        ,.pf_mem_rdata        (pf_cfg_qid_ldb_inflight_limit_mem_rdata)

        ,.mem_wclk            (rf_cfg_qid_ldb_inflight_limit_mem_wclk)
        ,.mem_rclk            (rf_cfg_qid_ldb_inflight_limit_mem_rclk)
        ,.mem_wclk_rst_n      (rf_cfg_qid_ldb_inflight_limit_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_cfg_qid_ldb_inflight_limit_mem_rclk_rst_n)
        ,.mem_re              (rf_cfg_qid_ldb_inflight_limit_mem_re)
        ,.mem_raddr           ({rf_cfg_qid_ldb_inflight_limit_mem_raddr_nc , rf_cfg_qid_ldb_inflight_limit_mem_raddr})
        ,.mem_waddr           ({rf_cfg_qid_ldb_inflight_limit_mem_waddr_nc , rf_cfg_qid_ldb_inflight_limit_mem_waddr})
        ,.mem_we              (rf_cfg_qid_ldb_inflight_limit_mem_we)
        ,.mem_wdata           (rf_cfg_qid_ldb_inflight_limit_mem_wdata)
        ,.mem_rdata           (rf_cfg_qid_ldb_inflight_limit_mem_rdata)

        ,.mem_rdata_error     (rf_cfg_qid_ldb_inflight_limit_mem_rdata_error)
        ,.error               (rf_cfg_qid_ldb_inflight_limit_mem_error)
);

logic [(       2)-1:0] rf_cfg_qid_ldb_qid2cqidix2_mem_raddr_nc ;
logic [(       2)-1:0] rf_cfg_qid_ldb_qid2cqidix2_mem_waddr_nc ;

logic        rf_cfg_qid_ldb_qid2cqidix2_mem_rdata_error;

hqm_AW_rfrw_access #( 
         .DEPTH               (32)
        ,.DWIDTH              (528)
        ,.AWIDTHPAD           (2)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_cfg_qid_ldb_qid2cqidix2_mem (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_cfg_qid_ldb_qid2cqidix2_mem_re)
        ,.func_mem_addr       (func_cfg_qid_ldb_qid2cqidix2_mem_addr)
        ,.func_mem_we         (func_cfg_qid_ldb_qid2cqidix2_mem_we)
        ,.func_mem_wdata      (func_cfg_qid_ldb_qid2cqidix2_mem_wdata)
        ,.func_mem_rdata      (func_cfg_qid_ldb_qid2cqidix2_mem_rdata)

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

        ,.pf_mem_re           (pf_cfg_qid_ldb_qid2cqidix2_mem_re)
        ,.pf_mem_addr         (pf_cfg_qid_ldb_qid2cqidix2_mem_addr)
        ,.pf_mem_we           (pf_cfg_qid_ldb_qid2cqidix2_mem_we)
        ,.pf_mem_wdata        (pf_cfg_qid_ldb_qid2cqidix2_mem_wdata)
        ,.pf_mem_rdata        (pf_cfg_qid_ldb_qid2cqidix2_mem_rdata)

        ,.mem_wclk            (rf_cfg_qid_ldb_qid2cqidix2_mem_wclk)
        ,.mem_rclk            (rf_cfg_qid_ldb_qid2cqidix2_mem_rclk)
        ,.mem_wclk_rst_n      (rf_cfg_qid_ldb_qid2cqidix2_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_cfg_qid_ldb_qid2cqidix2_mem_rclk_rst_n)
        ,.mem_re              (rf_cfg_qid_ldb_qid2cqidix2_mem_re)
        ,.mem_raddr           ({rf_cfg_qid_ldb_qid2cqidix2_mem_raddr_nc , rf_cfg_qid_ldb_qid2cqidix2_mem_raddr})
        ,.mem_waddr           ({rf_cfg_qid_ldb_qid2cqidix2_mem_waddr_nc , rf_cfg_qid_ldb_qid2cqidix2_mem_waddr})
        ,.mem_we              (rf_cfg_qid_ldb_qid2cqidix2_mem_we)
        ,.mem_wdata           (rf_cfg_qid_ldb_qid2cqidix2_mem_wdata)
        ,.mem_rdata           (rf_cfg_qid_ldb_qid2cqidix2_mem_rdata)

        ,.mem_rdata_error     (rf_cfg_qid_ldb_qid2cqidix2_mem_rdata_error)
        ,.error               (rf_cfg_qid_ldb_qid2cqidix2_mem_error)
);

logic [(       2)-1:0] rf_cfg_qid_ldb_qid2cqidix_mem_raddr_nc ;
logic [(       2)-1:0] rf_cfg_qid_ldb_qid2cqidix_mem_waddr_nc ;

logic        rf_cfg_qid_ldb_qid2cqidix_mem_rdata_error;

hqm_AW_rfrw_access #( 
         .DEPTH               (32)
        ,.DWIDTH              (528)
        ,.AWIDTHPAD           (2)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_cfg_qid_ldb_qid2cqidix_mem (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_cfg_qid_ldb_qid2cqidix_mem_re)
        ,.func_mem_addr       (func_cfg_qid_ldb_qid2cqidix_mem_addr)
        ,.func_mem_we         (func_cfg_qid_ldb_qid2cqidix_mem_we)
        ,.func_mem_wdata      (func_cfg_qid_ldb_qid2cqidix_mem_wdata)
        ,.func_mem_rdata      (func_cfg_qid_ldb_qid2cqidix_mem_rdata)

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

        ,.pf_mem_re           (pf_cfg_qid_ldb_qid2cqidix_mem_re)
        ,.pf_mem_addr         (pf_cfg_qid_ldb_qid2cqidix_mem_addr)
        ,.pf_mem_we           (pf_cfg_qid_ldb_qid2cqidix_mem_we)
        ,.pf_mem_wdata        (pf_cfg_qid_ldb_qid2cqidix_mem_wdata)
        ,.pf_mem_rdata        (pf_cfg_qid_ldb_qid2cqidix_mem_rdata)

        ,.mem_wclk            (rf_cfg_qid_ldb_qid2cqidix_mem_wclk)
        ,.mem_rclk            (rf_cfg_qid_ldb_qid2cqidix_mem_rclk)
        ,.mem_wclk_rst_n      (rf_cfg_qid_ldb_qid2cqidix_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_cfg_qid_ldb_qid2cqidix_mem_rclk_rst_n)
        ,.mem_re              (rf_cfg_qid_ldb_qid2cqidix_mem_re)
        ,.mem_raddr           ({rf_cfg_qid_ldb_qid2cqidix_mem_raddr_nc , rf_cfg_qid_ldb_qid2cqidix_mem_raddr})
        ,.mem_waddr           ({rf_cfg_qid_ldb_qid2cqidix_mem_waddr_nc , rf_cfg_qid_ldb_qid2cqidix_mem_waddr})
        ,.mem_we              (rf_cfg_qid_ldb_qid2cqidix_mem_we)
        ,.mem_wdata           (rf_cfg_qid_ldb_qid2cqidix_mem_wdata)
        ,.mem_rdata           (rf_cfg_qid_ldb_qid2cqidix_mem_rdata)

        ,.mem_rdata_error     (rf_cfg_qid_ldb_qid2cqidix_mem_rdata_error)
        ,.error               (rf_cfg_qid_ldb_qid2cqidix_mem_error)
);

logic        rf_chp_lsp_cmp_rx_sync_fifo_mem_rdata_error;

logic        cfg_mem_ack_chp_lsp_cmp_rx_sync_fifo_mem_nc;
logic [31:0] cfg_mem_rdata_chp_lsp_cmp_rx_sync_fifo_mem_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (4)
        ,.DWIDTH              (73)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_chp_lsp_cmp_rx_sync_fifo_mem (
         .clk                 (hqm_inp_gated_clk)
        ,.rst_n               (hqm_inp_gated_rst_n)

        ,.func_mem_re         (func_chp_lsp_cmp_rx_sync_fifo_mem_re)
        ,.func_mem_raddr      (func_chp_lsp_cmp_rx_sync_fifo_mem_raddr)
        ,.func_mem_waddr      (func_chp_lsp_cmp_rx_sync_fifo_mem_waddr)
        ,.func_mem_we         (func_chp_lsp_cmp_rx_sync_fifo_mem_we)
        ,.func_mem_wdata      (func_chp_lsp_cmp_rx_sync_fifo_mem_wdata)
        ,.func_mem_rdata      (func_chp_lsp_cmp_rx_sync_fifo_mem_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_chp_lsp_cmp_rx_sync_fifo_mem_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_chp_lsp_cmp_rx_sync_fifo_mem_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_chp_lsp_cmp_rx_sync_fifo_mem_re)
        ,.pf_mem_raddr        (pf_chp_lsp_cmp_rx_sync_fifo_mem_raddr)
        ,.pf_mem_waddr        (pf_chp_lsp_cmp_rx_sync_fifo_mem_waddr)
        ,.pf_mem_we           (pf_chp_lsp_cmp_rx_sync_fifo_mem_we)
        ,.pf_mem_wdata        (pf_chp_lsp_cmp_rx_sync_fifo_mem_wdata)
        ,.pf_mem_rdata        (pf_chp_lsp_cmp_rx_sync_fifo_mem_rdata)

        ,.mem_wclk            (rf_chp_lsp_cmp_rx_sync_fifo_mem_wclk)
        ,.mem_rclk            (rf_chp_lsp_cmp_rx_sync_fifo_mem_rclk)
        ,.mem_wclk_rst_n      (rf_chp_lsp_cmp_rx_sync_fifo_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_chp_lsp_cmp_rx_sync_fifo_mem_rclk_rst_n)
        ,.mem_re              (rf_chp_lsp_cmp_rx_sync_fifo_mem_re)
        ,.mem_raddr           (rf_chp_lsp_cmp_rx_sync_fifo_mem_raddr)
        ,.mem_waddr           (rf_chp_lsp_cmp_rx_sync_fifo_mem_waddr)
        ,.mem_we              (rf_chp_lsp_cmp_rx_sync_fifo_mem_we)
        ,.mem_wdata           (rf_chp_lsp_cmp_rx_sync_fifo_mem_wdata)
        ,.mem_rdata           (rf_chp_lsp_cmp_rx_sync_fifo_mem_rdata)

        ,.mem_rdata_error     (rf_chp_lsp_cmp_rx_sync_fifo_mem_rdata_error)
        ,.error               (rf_chp_lsp_cmp_rx_sync_fifo_mem_error)
);

logic        rf_chp_lsp_token_rx_sync_fifo_mem_rdata_error;

logic        cfg_mem_ack_chp_lsp_token_rx_sync_fifo_mem_nc;
logic [31:0] cfg_mem_rdata_chp_lsp_token_rx_sync_fifo_mem_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (4)
        ,.DWIDTH              (25)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_chp_lsp_token_rx_sync_fifo_mem (
         .clk                 (hqm_inp_gated_clk)
        ,.rst_n               (hqm_inp_gated_rst_n)

        ,.func_mem_re         (func_chp_lsp_token_rx_sync_fifo_mem_re)
        ,.func_mem_raddr      (func_chp_lsp_token_rx_sync_fifo_mem_raddr)
        ,.func_mem_waddr      (func_chp_lsp_token_rx_sync_fifo_mem_waddr)
        ,.func_mem_we         (func_chp_lsp_token_rx_sync_fifo_mem_we)
        ,.func_mem_wdata      (func_chp_lsp_token_rx_sync_fifo_mem_wdata)
        ,.func_mem_rdata      (func_chp_lsp_token_rx_sync_fifo_mem_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_chp_lsp_token_rx_sync_fifo_mem_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_chp_lsp_token_rx_sync_fifo_mem_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_chp_lsp_token_rx_sync_fifo_mem_re)
        ,.pf_mem_raddr        (pf_chp_lsp_token_rx_sync_fifo_mem_raddr)
        ,.pf_mem_waddr        (pf_chp_lsp_token_rx_sync_fifo_mem_waddr)
        ,.pf_mem_we           (pf_chp_lsp_token_rx_sync_fifo_mem_we)
        ,.pf_mem_wdata        (pf_chp_lsp_token_rx_sync_fifo_mem_wdata)
        ,.pf_mem_rdata        (pf_chp_lsp_token_rx_sync_fifo_mem_rdata)

        ,.mem_wclk            (rf_chp_lsp_token_rx_sync_fifo_mem_wclk)
        ,.mem_rclk            (rf_chp_lsp_token_rx_sync_fifo_mem_rclk)
        ,.mem_wclk_rst_n      (rf_chp_lsp_token_rx_sync_fifo_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_chp_lsp_token_rx_sync_fifo_mem_rclk_rst_n)
        ,.mem_re              (rf_chp_lsp_token_rx_sync_fifo_mem_re)
        ,.mem_raddr           (rf_chp_lsp_token_rx_sync_fifo_mem_raddr)
        ,.mem_waddr           (rf_chp_lsp_token_rx_sync_fifo_mem_waddr)
        ,.mem_we              (rf_chp_lsp_token_rx_sync_fifo_mem_we)
        ,.mem_wdata           (rf_chp_lsp_token_rx_sync_fifo_mem_wdata)
        ,.mem_rdata           (rf_chp_lsp_token_rx_sync_fifo_mem_rdata)

        ,.mem_rdata_error     (rf_chp_lsp_token_rx_sync_fifo_mem_rdata_error)
        ,.error               (rf_chp_lsp_token_rx_sync_fifo_mem_error)
);

logic        rf_cq_atm_pri_arbindex_mem_rdata_error;

logic        cfg_mem_ack_cq_atm_pri_arbindex_mem_nc;
logic [31:0] cfg_mem_rdata_cq_atm_pri_arbindex_mem_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (32)
        ,.DWIDTH              (96)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_cq_atm_pri_arbindex_mem (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_cq_atm_pri_arbindex_mem_re)
        ,.func_mem_raddr      (func_cq_atm_pri_arbindex_mem_raddr)
        ,.func_mem_waddr      (func_cq_atm_pri_arbindex_mem_waddr)
        ,.func_mem_we         (func_cq_atm_pri_arbindex_mem_we)
        ,.func_mem_wdata      (func_cq_atm_pri_arbindex_mem_wdata)
        ,.func_mem_rdata      (func_cq_atm_pri_arbindex_mem_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_cq_atm_pri_arbindex_mem_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_cq_atm_pri_arbindex_mem_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_cq_atm_pri_arbindex_mem_re)
        ,.pf_mem_raddr        (pf_cq_atm_pri_arbindex_mem_raddr)
        ,.pf_mem_waddr        (pf_cq_atm_pri_arbindex_mem_waddr)
        ,.pf_mem_we           (pf_cq_atm_pri_arbindex_mem_we)
        ,.pf_mem_wdata        (pf_cq_atm_pri_arbindex_mem_wdata)
        ,.pf_mem_rdata        (pf_cq_atm_pri_arbindex_mem_rdata)

        ,.mem_wclk            (rf_cq_atm_pri_arbindex_mem_wclk)
        ,.mem_rclk            (rf_cq_atm_pri_arbindex_mem_rclk)
        ,.mem_wclk_rst_n      (rf_cq_atm_pri_arbindex_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_cq_atm_pri_arbindex_mem_rclk_rst_n)
        ,.mem_re              (rf_cq_atm_pri_arbindex_mem_re)
        ,.mem_raddr           (rf_cq_atm_pri_arbindex_mem_raddr)
        ,.mem_waddr           (rf_cq_atm_pri_arbindex_mem_waddr)
        ,.mem_we              (rf_cq_atm_pri_arbindex_mem_we)
        ,.mem_wdata           (rf_cq_atm_pri_arbindex_mem_wdata)
        ,.mem_rdata           (rf_cq_atm_pri_arbindex_mem_rdata)

        ,.mem_rdata_error     (rf_cq_atm_pri_arbindex_mem_rdata_error)
        ,.error               (rf_cq_atm_pri_arbindex_mem_error)
);

logic [(       1)-1:0] rf_cq_dir_tot_sch_cnt_mem_raddr_nc ;
logic [(       1)-1:0] rf_cq_dir_tot_sch_cnt_mem_waddr_nc ;

logic        rf_cq_dir_tot_sch_cnt_mem_rdata_error;

hqm_AW_rfw_access #( 
         .DEPTH               (64)
        ,.DWIDTH              (66)
        ,.AWIDTHPAD           (1)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_cq_dir_tot_sch_cnt_mem (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_cq_dir_tot_sch_cnt_mem_re)
        ,.func_mem_raddr      (func_cq_dir_tot_sch_cnt_mem_raddr)
        ,.func_mem_waddr      (func_cq_dir_tot_sch_cnt_mem_waddr)
        ,.func_mem_we         (func_cq_dir_tot_sch_cnt_mem_we)
        ,.func_mem_wdata      (func_cq_dir_tot_sch_cnt_mem_wdata)
        ,.func_mem_rdata      (func_cq_dir_tot_sch_cnt_mem_rdata)

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

        ,.pf_mem_re           (pf_cq_dir_tot_sch_cnt_mem_re)
        ,.pf_mem_raddr        (pf_cq_dir_tot_sch_cnt_mem_raddr)
        ,.pf_mem_waddr        (pf_cq_dir_tot_sch_cnt_mem_waddr)
        ,.pf_mem_we           (pf_cq_dir_tot_sch_cnt_mem_we)
        ,.pf_mem_wdata        (pf_cq_dir_tot_sch_cnt_mem_wdata)
        ,.pf_mem_rdata        (pf_cq_dir_tot_sch_cnt_mem_rdata)

        ,.mem_wclk            (rf_cq_dir_tot_sch_cnt_mem_wclk)
        ,.mem_rclk            (rf_cq_dir_tot_sch_cnt_mem_rclk)
        ,.mem_wclk_rst_n      (rf_cq_dir_tot_sch_cnt_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_cq_dir_tot_sch_cnt_mem_rclk_rst_n)
        ,.mem_re              (rf_cq_dir_tot_sch_cnt_mem_re)
        ,.mem_raddr           ({rf_cq_dir_tot_sch_cnt_mem_raddr_nc , rf_cq_dir_tot_sch_cnt_mem_raddr})
        ,.mem_waddr           ({rf_cq_dir_tot_sch_cnt_mem_waddr_nc , rf_cq_dir_tot_sch_cnt_mem_waddr})
        ,.mem_we              (rf_cq_dir_tot_sch_cnt_mem_we)
        ,.mem_wdata           (rf_cq_dir_tot_sch_cnt_mem_wdata)
        ,.mem_rdata           (rf_cq_dir_tot_sch_cnt_mem_rdata)

        ,.mem_rdata_error     (rf_cq_dir_tot_sch_cnt_mem_rdata_error)
        ,.error               (rf_cq_dir_tot_sch_cnt_mem_error)
);

logic        rf_cq_ldb_inflight_count_mem_rdata_error;

hqm_AW_rfw_access #( 
         .DEPTH               (64)
        ,.DWIDTH              (15)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_cq_ldb_inflight_count_mem (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_cq_ldb_inflight_count_mem_re)
        ,.func_mem_raddr      (func_cq_ldb_inflight_count_mem_raddr)
        ,.func_mem_waddr      (func_cq_ldb_inflight_count_mem_waddr)
        ,.func_mem_we         (func_cq_ldb_inflight_count_mem_we)
        ,.func_mem_wdata      (func_cq_ldb_inflight_count_mem_wdata)
        ,.func_mem_rdata      (func_cq_ldb_inflight_count_mem_rdata)

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

        ,.pf_mem_re           (pf_cq_ldb_inflight_count_mem_re)
        ,.pf_mem_raddr        (pf_cq_ldb_inflight_count_mem_raddr)
        ,.pf_mem_waddr        (pf_cq_ldb_inflight_count_mem_waddr)
        ,.pf_mem_we           (pf_cq_ldb_inflight_count_mem_we)
        ,.pf_mem_wdata        (pf_cq_ldb_inflight_count_mem_wdata)
        ,.pf_mem_rdata        (pf_cq_ldb_inflight_count_mem_rdata)

        ,.mem_wclk            (rf_cq_ldb_inflight_count_mem_wclk)
        ,.mem_rclk            (rf_cq_ldb_inflight_count_mem_rclk)
        ,.mem_wclk_rst_n      (rf_cq_ldb_inflight_count_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_cq_ldb_inflight_count_mem_rclk_rst_n)
        ,.mem_re              (rf_cq_ldb_inflight_count_mem_re)
        ,.mem_raddr           (rf_cq_ldb_inflight_count_mem_raddr)
        ,.mem_waddr           (rf_cq_ldb_inflight_count_mem_waddr)
        ,.mem_we              (rf_cq_ldb_inflight_count_mem_we)
        ,.mem_wdata           (rf_cq_ldb_inflight_count_mem_wdata)
        ,.mem_rdata           (rf_cq_ldb_inflight_count_mem_rdata)

        ,.mem_rdata_error     (rf_cq_ldb_inflight_count_mem_rdata_error)
        ,.error               (rf_cq_ldb_inflight_count_mem_error)
);

logic        rf_cq_ldb_token_count_mem_rdata_error;

hqm_AW_rfw_access #( 
         .DEPTH               (64)
        ,.DWIDTH              (13)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_cq_ldb_token_count_mem (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_cq_ldb_token_count_mem_re)
        ,.func_mem_raddr      (func_cq_ldb_token_count_mem_raddr)
        ,.func_mem_waddr      (func_cq_ldb_token_count_mem_waddr)
        ,.func_mem_we         (func_cq_ldb_token_count_mem_we)
        ,.func_mem_wdata      (func_cq_ldb_token_count_mem_wdata)
        ,.func_mem_rdata      (func_cq_ldb_token_count_mem_rdata)

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

        ,.pf_mem_re           (pf_cq_ldb_token_count_mem_re)
        ,.pf_mem_raddr        (pf_cq_ldb_token_count_mem_raddr)
        ,.pf_mem_waddr        (pf_cq_ldb_token_count_mem_waddr)
        ,.pf_mem_we           (pf_cq_ldb_token_count_mem_we)
        ,.pf_mem_wdata        (pf_cq_ldb_token_count_mem_wdata)
        ,.pf_mem_rdata        (pf_cq_ldb_token_count_mem_rdata)

        ,.mem_wclk            (rf_cq_ldb_token_count_mem_wclk)
        ,.mem_rclk            (rf_cq_ldb_token_count_mem_rclk)
        ,.mem_wclk_rst_n      (rf_cq_ldb_token_count_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_cq_ldb_token_count_mem_rclk_rst_n)
        ,.mem_re              (rf_cq_ldb_token_count_mem_re)
        ,.mem_raddr           (rf_cq_ldb_token_count_mem_raddr)
        ,.mem_waddr           (rf_cq_ldb_token_count_mem_waddr)
        ,.mem_we              (rf_cq_ldb_token_count_mem_we)
        ,.mem_wdata           (rf_cq_ldb_token_count_mem_wdata)
        ,.mem_rdata           (rf_cq_ldb_token_count_mem_rdata)

        ,.mem_rdata_error     (rf_cq_ldb_token_count_mem_rdata_error)
        ,.error               (rf_cq_ldb_token_count_mem_error)
);

logic        rf_cq_ldb_tot_sch_cnt_mem_rdata_error;

hqm_AW_rfw_access #( 
         .DEPTH               (64)
        ,.DWIDTH              (66)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_cq_ldb_tot_sch_cnt_mem (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_cq_ldb_tot_sch_cnt_mem_re)
        ,.func_mem_raddr      (func_cq_ldb_tot_sch_cnt_mem_raddr)
        ,.func_mem_waddr      (func_cq_ldb_tot_sch_cnt_mem_waddr)
        ,.func_mem_we         (func_cq_ldb_tot_sch_cnt_mem_we)
        ,.func_mem_wdata      (func_cq_ldb_tot_sch_cnt_mem_wdata)
        ,.func_mem_rdata      (func_cq_ldb_tot_sch_cnt_mem_rdata)

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

        ,.pf_mem_re           (pf_cq_ldb_tot_sch_cnt_mem_re)
        ,.pf_mem_raddr        (pf_cq_ldb_tot_sch_cnt_mem_raddr)
        ,.pf_mem_waddr        (pf_cq_ldb_tot_sch_cnt_mem_waddr)
        ,.pf_mem_we           (pf_cq_ldb_tot_sch_cnt_mem_we)
        ,.pf_mem_wdata        (pf_cq_ldb_tot_sch_cnt_mem_wdata)
        ,.pf_mem_rdata        (pf_cq_ldb_tot_sch_cnt_mem_rdata)

        ,.mem_wclk            (rf_cq_ldb_tot_sch_cnt_mem_wclk)
        ,.mem_rclk            (rf_cq_ldb_tot_sch_cnt_mem_rclk)
        ,.mem_wclk_rst_n      (rf_cq_ldb_tot_sch_cnt_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_cq_ldb_tot_sch_cnt_mem_rclk_rst_n)
        ,.mem_re              (rf_cq_ldb_tot_sch_cnt_mem_re)
        ,.mem_raddr           (rf_cq_ldb_tot_sch_cnt_mem_raddr)
        ,.mem_waddr           (rf_cq_ldb_tot_sch_cnt_mem_waddr)
        ,.mem_we              (rf_cq_ldb_tot_sch_cnt_mem_we)
        ,.mem_wdata           (rf_cq_ldb_tot_sch_cnt_mem_wdata)
        ,.mem_rdata           (rf_cq_ldb_tot_sch_cnt_mem_rdata)

        ,.mem_rdata_error     (rf_cq_ldb_tot_sch_cnt_mem_rdata_error)
        ,.error               (rf_cq_ldb_tot_sch_cnt_mem_error)
);

logic        rf_cq_ldb_wu_count_mem_rdata_error;

hqm_AW_rfw_access #( 
         .DEPTH               (64)
        ,.DWIDTH              (19)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_cq_ldb_wu_count_mem (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_cq_ldb_wu_count_mem_re)
        ,.func_mem_raddr      (func_cq_ldb_wu_count_mem_raddr)
        ,.func_mem_waddr      (func_cq_ldb_wu_count_mem_waddr)
        ,.func_mem_we         (func_cq_ldb_wu_count_mem_we)
        ,.func_mem_wdata      (func_cq_ldb_wu_count_mem_wdata)
        ,.func_mem_rdata      (func_cq_ldb_wu_count_mem_rdata)

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

        ,.pf_mem_re           (pf_cq_ldb_wu_count_mem_re)
        ,.pf_mem_raddr        (pf_cq_ldb_wu_count_mem_raddr)
        ,.pf_mem_waddr        (pf_cq_ldb_wu_count_mem_waddr)
        ,.pf_mem_we           (pf_cq_ldb_wu_count_mem_we)
        ,.pf_mem_wdata        (pf_cq_ldb_wu_count_mem_wdata)
        ,.pf_mem_rdata        (pf_cq_ldb_wu_count_mem_rdata)

        ,.mem_wclk            (rf_cq_ldb_wu_count_mem_wclk)
        ,.mem_rclk            (rf_cq_ldb_wu_count_mem_rclk)
        ,.mem_wclk_rst_n      (rf_cq_ldb_wu_count_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_cq_ldb_wu_count_mem_rclk_rst_n)
        ,.mem_re              (rf_cq_ldb_wu_count_mem_re)
        ,.mem_raddr           (rf_cq_ldb_wu_count_mem_raddr)
        ,.mem_waddr           (rf_cq_ldb_wu_count_mem_waddr)
        ,.mem_we              (rf_cq_ldb_wu_count_mem_we)
        ,.mem_wdata           (rf_cq_ldb_wu_count_mem_wdata)
        ,.mem_rdata           (rf_cq_ldb_wu_count_mem_rdata)

        ,.mem_rdata_error     (rf_cq_ldb_wu_count_mem_rdata_error)
        ,.error               (rf_cq_ldb_wu_count_mem_error)
);

logic        rf_cq_nalb_pri_arbindex_mem_rdata_error;

logic        cfg_mem_ack_cq_nalb_pri_arbindex_mem_nc;
logic [31:0] cfg_mem_rdata_cq_nalb_pri_arbindex_mem_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (32)
        ,.DWIDTH              (96)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_cq_nalb_pri_arbindex_mem (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_cq_nalb_pri_arbindex_mem_re)
        ,.func_mem_raddr      (func_cq_nalb_pri_arbindex_mem_raddr)
        ,.func_mem_waddr      (func_cq_nalb_pri_arbindex_mem_waddr)
        ,.func_mem_we         (func_cq_nalb_pri_arbindex_mem_we)
        ,.func_mem_wdata      (func_cq_nalb_pri_arbindex_mem_wdata)
        ,.func_mem_rdata      (func_cq_nalb_pri_arbindex_mem_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_cq_nalb_pri_arbindex_mem_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_cq_nalb_pri_arbindex_mem_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_cq_nalb_pri_arbindex_mem_re)
        ,.pf_mem_raddr        (pf_cq_nalb_pri_arbindex_mem_raddr)
        ,.pf_mem_waddr        (pf_cq_nalb_pri_arbindex_mem_waddr)
        ,.pf_mem_we           (pf_cq_nalb_pri_arbindex_mem_we)
        ,.pf_mem_wdata        (pf_cq_nalb_pri_arbindex_mem_wdata)
        ,.pf_mem_rdata        (pf_cq_nalb_pri_arbindex_mem_rdata)

        ,.mem_wclk            (rf_cq_nalb_pri_arbindex_mem_wclk)
        ,.mem_rclk            (rf_cq_nalb_pri_arbindex_mem_rclk)
        ,.mem_wclk_rst_n      (rf_cq_nalb_pri_arbindex_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_cq_nalb_pri_arbindex_mem_rclk_rst_n)
        ,.mem_re              (rf_cq_nalb_pri_arbindex_mem_re)
        ,.mem_raddr           (rf_cq_nalb_pri_arbindex_mem_raddr)
        ,.mem_waddr           (rf_cq_nalb_pri_arbindex_mem_waddr)
        ,.mem_we              (rf_cq_nalb_pri_arbindex_mem_we)
        ,.mem_wdata           (rf_cq_nalb_pri_arbindex_mem_wdata)
        ,.mem_rdata           (rf_cq_nalb_pri_arbindex_mem_rdata)

        ,.mem_rdata_error     (rf_cq_nalb_pri_arbindex_mem_rdata_error)
        ,.error               (rf_cq_nalb_pri_arbindex_mem_error)
);

logic [(       1)-1:0] rf_dir_enq_cnt_mem_raddr_nc ;
logic [(       1)-1:0] rf_dir_enq_cnt_mem_waddr_nc ;

logic        rf_dir_enq_cnt_mem_rdata_error;

hqm_AW_rfw_access #( 
         .DEPTH               (64)
        ,.DWIDTH              (17)
        ,.AWIDTHPAD           (1)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_dir_enq_cnt_mem (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_dir_enq_cnt_mem_re)
        ,.func_mem_raddr      (func_dir_enq_cnt_mem_raddr)
        ,.func_mem_waddr      (func_dir_enq_cnt_mem_waddr)
        ,.func_mem_we         (func_dir_enq_cnt_mem_we)
        ,.func_mem_wdata      (func_dir_enq_cnt_mem_wdata)
        ,.func_mem_rdata      (func_dir_enq_cnt_mem_rdata)

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

        ,.pf_mem_re           (pf_dir_enq_cnt_mem_re)
        ,.pf_mem_raddr        (pf_dir_enq_cnt_mem_raddr)
        ,.pf_mem_waddr        (pf_dir_enq_cnt_mem_waddr)
        ,.pf_mem_we           (pf_dir_enq_cnt_mem_we)
        ,.pf_mem_wdata        (pf_dir_enq_cnt_mem_wdata)
        ,.pf_mem_rdata        (pf_dir_enq_cnt_mem_rdata)

        ,.mem_wclk            (rf_dir_enq_cnt_mem_wclk)
        ,.mem_rclk            (rf_dir_enq_cnt_mem_rclk)
        ,.mem_wclk_rst_n      (rf_dir_enq_cnt_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_dir_enq_cnt_mem_rclk_rst_n)
        ,.mem_re              (rf_dir_enq_cnt_mem_re)
        ,.mem_raddr           ({rf_dir_enq_cnt_mem_raddr_nc , rf_dir_enq_cnt_mem_raddr})
        ,.mem_waddr           ({rf_dir_enq_cnt_mem_waddr_nc , rf_dir_enq_cnt_mem_waddr})
        ,.mem_we              (rf_dir_enq_cnt_mem_we)
        ,.mem_wdata           (rf_dir_enq_cnt_mem_wdata)
        ,.mem_rdata           (rf_dir_enq_cnt_mem_rdata)

        ,.mem_rdata_error     (rf_dir_enq_cnt_mem_rdata_error)
        ,.error               (rf_dir_enq_cnt_mem_error)
);

logic [(       1)-1:0] rf_dir_tok_cnt_mem_raddr_nc ;
logic [(       1)-1:0] rf_dir_tok_cnt_mem_waddr_nc ;

logic        rf_dir_tok_cnt_mem_rdata_error;

hqm_AW_rfw_access #( 
         .DEPTH               (64)
        ,.DWIDTH              (13)
        ,.AWIDTHPAD           (1)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_dir_tok_cnt_mem (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_dir_tok_cnt_mem_re)
        ,.func_mem_raddr      (func_dir_tok_cnt_mem_raddr)
        ,.func_mem_waddr      (func_dir_tok_cnt_mem_waddr)
        ,.func_mem_we         (func_dir_tok_cnt_mem_we)
        ,.func_mem_wdata      (func_dir_tok_cnt_mem_wdata)
        ,.func_mem_rdata      (func_dir_tok_cnt_mem_rdata)

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

        ,.pf_mem_re           (pf_dir_tok_cnt_mem_re)
        ,.pf_mem_raddr        (pf_dir_tok_cnt_mem_raddr)
        ,.pf_mem_waddr        (pf_dir_tok_cnt_mem_waddr)
        ,.pf_mem_we           (pf_dir_tok_cnt_mem_we)
        ,.pf_mem_wdata        (pf_dir_tok_cnt_mem_wdata)
        ,.pf_mem_rdata        (pf_dir_tok_cnt_mem_rdata)

        ,.mem_wclk            (rf_dir_tok_cnt_mem_wclk)
        ,.mem_rclk            (rf_dir_tok_cnt_mem_rclk)
        ,.mem_wclk_rst_n      (rf_dir_tok_cnt_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_dir_tok_cnt_mem_rclk_rst_n)
        ,.mem_re              (rf_dir_tok_cnt_mem_re)
        ,.mem_raddr           ({rf_dir_tok_cnt_mem_raddr_nc , rf_dir_tok_cnt_mem_raddr})
        ,.mem_waddr           ({rf_dir_tok_cnt_mem_waddr_nc , rf_dir_tok_cnt_mem_waddr})
        ,.mem_we              (rf_dir_tok_cnt_mem_we)
        ,.mem_wdata           (rf_dir_tok_cnt_mem_wdata)
        ,.mem_rdata           (rf_dir_tok_cnt_mem_rdata)

        ,.mem_rdata_error     (rf_dir_tok_cnt_mem_rdata_error)
        ,.error               (rf_dir_tok_cnt_mem_error)
);

logic [(       1)-1:0] rf_dir_tok_lim_mem_raddr_nc ;
logic [(       1)-1:0] rf_dir_tok_lim_mem_waddr_nc ;

logic        rf_dir_tok_lim_mem_rdata_error;

hqm_AW_rfrw_access #( 
         .DEPTH               (64)
        ,.DWIDTH              (8)
        ,.AWIDTHPAD           (1)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_dir_tok_lim_mem (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_dir_tok_lim_mem_re)
        ,.func_mem_addr       (func_dir_tok_lim_mem_addr)
        ,.func_mem_we         (func_dir_tok_lim_mem_we)
        ,.func_mem_wdata      (func_dir_tok_lim_mem_wdata)
        ,.func_mem_rdata      (func_dir_tok_lim_mem_rdata)

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

        ,.pf_mem_re           (pf_dir_tok_lim_mem_re)
        ,.pf_mem_addr         (pf_dir_tok_lim_mem_addr)
        ,.pf_mem_we           (pf_dir_tok_lim_mem_we)
        ,.pf_mem_wdata        (pf_dir_tok_lim_mem_wdata)
        ,.pf_mem_rdata        (pf_dir_tok_lim_mem_rdata)

        ,.mem_wclk            (rf_dir_tok_lim_mem_wclk)
        ,.mem_rclk            (rf_dir_tok_lim_mem_rclk)
        ,.mem_wclk_rst_n      (rf_dir_tok_lim_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_dir_tok_lim_mem_rclk_rst_n)
        ,.mem_re              (rf_dir_tok_lim_mem_re)
        ,.mem_raddr           ({rf_dir_tok_lim_mem_raddr_nc , rf_dir_tok_lim_mem_raddr})
        ,.mem_waddr           ({rf_dir_tok_lim_mem_waddr_nc , rf_dir_tok_lim_mem_waddr})
        ,.mem_we              (rf_dir_tok_lim_mem_we)
        ,.mem_wdata           (rf_dir_tok_lim_mem_wdata)
        ,.mem_rdata           (rf_dir_tok_lim_mem_rdata)

        ,.mem_rdata_error     (rf_dir_tok_lim_mem_rdata_error)
        ,.error               (rf_dir_tok_lim_mem_error)
);

logic        rf_dp_lsp_enq_dir_rx_sync_fifo_mem_rdata_error;

logic        cfg_mem_ack_dp_lsp_enq_dir_rx_sync_fifo_mem_nc;
logic [31:0] cfg_mem_rdata_dp_lsp_enq_dir_rx_sync_fifo_mem_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (4)
        ,.DWIDTH              (8)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_dp_lsp_enq_dir_rx_sync_fifo_mem (
         .clk                 (hqm_inp_gated_clk)
        ,.rst_n               (hqm_inp_gated_rst_n)

        ,.func_mem_re         (func_dp_lsp_enq_dir_rx_sync_fifo_mem_re)
        ,.func_mem_raddr      (func_dp_lsp_enq_dir_rx_sync_fifo_mem_raddr)
        ,.func_mem_waddr      (func_dp_lsp_enq_dir_rx_sync_fifo_mem_waddr)
        ,.func_mem_we         (func_dp_lsp_enq_dir_rx_sync_fifo_mem_we)
        ,.func_mem_wdata      (func_dp_lsp_enq_dir_rx_sync_fifo_mem_wdata)
        ,.func_mem_rdata      (func_dp_lsp_enq_dir_rx_sync_fifo_mem_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_dp_lsp_enq_dir_rx_sync_fifo_mem_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_dp_lsp_enq_dir_rx_sync_fifo_mem_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_dp_lsp_enq_dir_rx_sync_fifo_mem_re)
        ,.pf_mem_raddr        (pf_dp_lsp_enq_dir_rx_sync_fifo_mem_raddr)
        ,.pf_mem_waddr        (pf_dp_lsp_enq_dir_rx_sync_fifo_mem_waddr)
        ,.pf_mem_we           (pf_dp_lsp_enq_dir_rx_sync_fifo_mem_we)
        ,.pf_mem_wdata        (pf_dp_lsp_enq_dir_rx_sync_fifo_mem_wdata)
        ,.pf_mem_rdata        (pf_dp_lsp_enq_dir_rx_sync_fifo_mem_rdata)

        ,.mem_wclk            (rf_dp_lsp_enq_dir_rx_sync_fifo_mem_wclk)
        ,.mem_rclk            (rf_dp_lsp_enq_dir_rx_sync_fifo_mem_rclk)
        ,.mem_wclk_rst_n      (rf_dp_lsp_enq_dir_rx_sync_fifo_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_dp_lsp_enq_dir_rx_sync_fifo_mem_rclk_rst_n)
        ,.mem_re              (rf_dp_lsp_enq_dir_rx_sync_fifo_mem_re)
        ,.mem_raddr           (rf_dp_lsp_enq_dir_rx_sync_fifo_mem_raddr)
        ,.mem_waddr           (rf_dp_lsp_enq_dir_rx_sync_fifo_mem_waddr)
        ,.mem_we              (rf_dp_lsp_enq_dir_rx_sync_fifo_mem_we)
        ,.mem_wdata           (rf_dp_lsp_enq_dir_rx_sync_fifo_mem_wdata)
        ,.mem_rdata           (rf_dp_lsp_enq_dir_rx_sync_fifo_mem_rdata)

        ,.mem_rdata_error     (rf_dp_lsp_enq_dir_rx_sync_fifo_mem_rdata_error)
        ,.error               (rf_dp_lsp_enq_dir_rx_sync_fifo_mem_error)
);

logic        rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_rdata_error;

logic        cfg_mem_ack_dp_lsp_enq_rorply_rx_sync_fifo_mem_nc;
logic [31:0] cfg_mem_rdata_dp_lsp_enq_rorply_rx_sync_fifo_mem_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (4)
        ,.DWIDTH              (23)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_dp_lsp_enq_rorply_rx_sync_fifo_mem (
         .clk                 (hqm_inp_gated_clk)
        ,.rst_n               (hqm_inp_gated_rst_n)

        ,.func_mem_re         (func_dp_lsp_enq_rorply_rx_sync_fifo_mem_re)
        ,.func_mem_raddr      (func_dp_lsp_enq_rorply_rx_sync_fifo_mem_raddr)
        ,.func_mem_waddr      (func_dp_lsp_enq_rorply_rx_sync_fifo_mem_waddr)
        ,.func_mem_we         (func_dp_lsp_enq_rorply_rx_sync_fifo_mem_we)
        ,.func_mem_wdata      (func_dp_lsp_enq_rorply_rx_sync_fifo_mem_wdata)
        ,.func_mem_rdata      (func_dp_lsp_enq_rorply_rx_sync_fifo_mem_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_dp_lsp_enq_rorply_rx_sync_fifo_mem_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_dp_lsp_enq_rorply_rx_sync_fifo_mem_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_dp_lsp_enq_rorply_rx_sync_fifo_mem_re)
        ,.pf_mem_raddr        (pf_dp_lsp_enq_rorply_rx_sync_fifo_mem_raddr)
        ,.pf_mem_waddr        (pf_dp_lsp_enq_rorply_rx_sync_fifo_mem_waddr)
        ,.pf_mem_we           (pf_dp_lsp_enq_rorply_rx_sync_fifo_mem_we)
        ,.pf_mem_wdata        (pf_dp_lsp_enq_rorply_rx_sync_fifo_mem_wdata)
        ,.pf_mem_rdata        (pf_dp_lsp_enq_rorply_rx_sync_fifo_mem_rdata)

        ,.mem_wclk            (rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_wclk)
        ,.mem_rclk            (rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_rclk)
        ,.mem_wclk_rst_n      (rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_rclk_rst_n)
        ,.mem_re              (rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_re)
        ,.mem_raddr           (rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_raddr)
        ,.mem_waddr           (rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_waddr)
        ,.mem_we              (rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_we)
        ,.mem_wdata           (rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_wdata)
        ,.mem_rdata           (rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_rdata)

        ,.mem_rdata_error     (rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_rdata_error)
        ,.error               (rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_error)
);

logic        rf_enq_nalb_fifo_mem_rdata_error;

logic        cfg_mem_ack_enq_nalb_fifo_mem_nc;
logic [31:0] cfg_mem_rdata_enq_nalb_fifo_mem_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (4)
        ,.DWIDTH              (10)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_enq_nalb_fifo_mem (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_enq_nalb_fifo_mem_re)
        ,.func_mem_raddr      (func_enq_nalb_fifo_mem_raddr)
        ,.func_mem_waddr      (func_enq_nalb_fifo_mem_waddr)
        ,.func_mem_we         (func_enq_nalb_fifo_mem_we)
        ,.func_mem_wdata      (func_enq_nalb_fifo_mem_wdata)
        ,.func_mem_rdata      (func_enq_nalb_fifo_mem_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_enq_nalb_fifo_mem_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_enq_nalb_fifo_mem_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_enq_nalb_fifo_mem_re)
        ,.pf_mem_raddr        (pf_enq_nalb_fifo_mem_raddr)
        ,.pf_mem_waddr        (pf_enq_nalb_fifo_mem_waddr)
        ,.pf_mem_we           (pf_enq_nalb_fifo_mem_we)
        ,.pf_mem_wdata        (pf_enq_nalb_fifo_mem_wdata)
        ,.pf_mem_rdata        (pf_enq_nalb_fifo_mem_rdata)

        ,.mem_wclk            (rf_enq_nalb_fifo_mem_wclk)
        ,.mem_rclk            (rf_enq_nalb_fifo_mem_rclk)
        ,.mem_wclk_rst_n      (rf_enq_nalb_fifo_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_enq_nalb_fifo_mem_rclk_rst_n)
        ,.mem_re              (rf_enq_nalb_fifo_mem_re)
        ,.mem_raddr           (rf_enq_nalb_fifo_mem_raddr)
        ,.mem_waddr           (rf_enq_nalb_fifo_mem_waddr)
        ,.mem_we              (rf_enq_nalb_fifo_mem_we)
        ,.mem_wdata           (rf_enq_nalb_fifo_mem_wdata)
        ,.mem_rdata           (rf_enq_nalb_fifo_mem_rdata)

        ,.mem_rdata_error     (rf_enq_nalb_fifo_mem_rdata_error)
        ,.error               (rf_enq_nalb_fifo_mem_error)
);

logic        rf_ldb_token_rtn_fifo_mem_rdata_error;

logic        cfg_mem_ack_ldb_token_rtn_fifo_mem_nc;
logic [31:0] cfg_mem_rdata_ldb_token_rtn_fifo_mem_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (8)
        ,.DWIDTH              (25)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_ldb_token_rtn_fifo_mem (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_ldb_token_rtn_fifo_mem_re)
        ,.func_mem_raddr      (func_ldb_token_rtn_fifo_mem_raddr)
        ,.func_mem_waddr      (func_ldb_token_rtn_fifo_mem_waddr)
        ,.func_mem_we         (func_ldb_token_rtn_fifo_mem_we)
        ,.func_mem_wdata      (func_ldb_token_rtn_fifo_mem_wdata)
        ,.func_mem_rdata      (func_ldb_token_rtn_fifo_mem_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_ldb_token_rtn_fifo_mem_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_ldb_token_rtn_fifo_mem_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_ldb_token_rtn_fifo_mem_re)
        ,.pf_mem_raddr        (pf_ldb_token_rtn_fifo_mem_raddr)
        ,.pf_mem_waddr        (pf_ldb_token_rtn_fifo_mem_waddr)
        ,.pf_mem_we           (pf_ldb_token_rtn_fifo_mem_we)
        ,.pf_mem_wdata        (pf_ldb_token_rtn_fifo_mem_wdata)
        ,.pf_mem_rdata        (pf_ldb_token_rtn_fifo_mem_rdata)

        ,.mem_wclk            (rf_ldb_token_rtn_fifo_mem_wclk)
        ,.mem_rclk            (rf_ldb_token_rtn_fifo_mem_rclk)
        ,.mem_wclk_rst_n      (rf_ldb_token_rtn_fifo_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_ldb_token_rtn_fifo_mem_rclk_rst_n)
        ,.mem_re              (rf_ldb_token_rtn_fifo_mem_re)
        ,.mem_raddr           (rf_ldb_token_rtn_fifo_mem_raddr)
        ,.mem_waddr           (rf_ldb_token_rtn_fifo_mem_waddr)
        ,.mem_we              (rf_ldb_token_rtn_fifo_mem_we)
        ,.mem_wdata           (rf_ldb_token_rtn_fifo_mem_wdata)
        ,.mem_rdata           (rf_ldb_token_rtn_fifo_mem_rdata)

        ,.mem_rdata_error     (rf_ldb_token_rtn_fifo_mem_rdata_error)
        ,.error               (rf_ldb_token_rtn_fifo_mem_error)
);

logic        rf_nalb_cmp_fifo_mem_rdata_error;

logic        cfg_mem_ack_nalb_cmp_fifo_mem_nc;
logic [31:0] cfg_mem_rdata_nalb_cmp_fifo_mem_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (8)
        ,.DWIDTH              (18)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_nalb_cmp_fifo_mem (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_nalb_cmp_fifo_mem_re)
        ,.func_mem_raddr      (func_nalb_cmp_fifo_mem_raddr)
        ,.func_mem_waddr      (func_nalb_cmp_fifo_mem_waddr)
        ,.func_mem_we         (func_nalb_cmp_fifo_mem_we)
        ,.func_mem_wdata      (func_nalb_cmp_fifo_mem_wdata)
        ,.func_mem_rdata      (func_nalb_cmp_fifo_mem_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_nalb_cmp_fifo_mem_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_nalb_cmp_fifo_mem_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_nalb_cmp_fifo_mem_re)
        ,.pf_mem_raddr        (pf_nalb_cmp_fifo_mem_raddr)
        ,.pf_mem_waddr        (pf_nalb_cmp_fifo_mem_waddr)
        ,.pf_mem_we           (pf_nalb_cmp_fifo_mem_we)
        ,.pf_mem_wdata        (pf_nalb_cmp_fifo_mem_wdata)
        ,.pf_mem_rdata        (pf_nalb_cmp_fifo_mem_rdata)

        ,.mem_wclk            (rf_nalb_cmp_fifo_mem_wclk)
        ,.mem_rclk            (rf_nalb_cmp_fifo_mem_rclk)
        ,.mem_wclk_rst_n      (rf_nalb_cmp_fifo_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_nalb_cmp_fifo_mem_rclk_rst_n)
        ,.mem_re              (rf_nalb_cmp_fifo_mem_re)
        ,.mem_raddr           (rf_nalb_cmp_fifo_mem_raddr)
        ,.mem_waddr           (rf_nalb_cmp_fifo_mem_waddr)
        ,.mem_we              (rf_nalb_cmp_fifo_mem_we)
        ,.mem_wdata           (rf_nalb_cmp_fifo_mem_wdata)
        ,.mem_rdata           (rf_nalb_cmp_fifo_mem_rdata)

        ,.mem_rdata_error     (rf_nalb_cmp_fifo_mem_rdata_error)
        ,.error               (rf_nalb_cmp_fifo_mem_error)
);

logic        rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_rdata_error;

logic        cfg_mem_ack_nalb_lsp_enq_lb_rx_sync_fifo_mem_nc;
logic [31:0] cfg_mem_rdata_nalb_lsp_enq_lb_rx_sync_fifo_mem_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (4)
        ,.DWIDTH              (10)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_nalb_lsp_enq_lb_rx_sync_fifo_mem (
         .clk                 (hqm_inp_gated_clk)
        ,.rst_n               (hqm_inp_gated_rst_n)

        ,.func_mem_re         (func_nalb_lsp_enq_lb_rx_sync_fifo_mem_re)
        ,.func_mem_raddr      (func_nalb_lsp_enq_lb_rx_sync_fifo_mem_raddr)
        ,.func_mem_waddr      (func_nalb_lsp_enq_lb_rx_sync_fifo_mem_waddr)
        ,.func_mem_we         (func_nalb_lsp_enq_lb_rx_sync_fifo_mem_we)
        ,.func_mem_wdata      (func_nalb_lsp_enq_lb_rx_sync_fifo_mem_wdata)
        ,.func_mem_rdata      (func_nalb_lsp_enq_lb_rx_sync_fifo_mem_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_nalb_lsp_enq_lb_rx_sync_fifo_mem_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_nalb_lsp_enq_lb_rx_sync_fifo_mem_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_nalb_lsp_enq_lb_rx_sync_fifo_mem_re)
        ,.pf_mem_raddr        (pf_nalb_lsp_enq_lb_rx_sync_fifo_mem_raddr)
        ,.pf_mem_waddr        (pf_nalb_lsp_enq_lb_rx_sync_fifo_mem_waddr)
        ,.pf_mem_we           (pf_nalb_lsp_enq_lb_rx_sync_fifo_mem_we)
        ,.pf_mem_wdata        (pf_nalb_lsp_enq_lb_rx_sync_fifo_mem_wdata)
        ,.pf_mem_rdata        (pf_nalb_lsp_enq_lb_rx_sync_fifo_mem_rdata)

        ,.mem_wclk            (rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_wclk)
        ,.mem_rclk            (rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_rclk)
        ,.mem_wclk_rst_n      (rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_rclk_rst_n)
        ,.mem_re              (rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_re)
        ,.mem_raddr           (rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_raddr)
        ,.mem_waddr           (rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_waddr)
        ,.mem_we              (rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_we)
        ,.mem_wdata           (rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_wdata)
        ,.mem_rdata           (rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_rdata)

        ,.mem_rdata_error     (rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_rdata_error)
        ,.error               (rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_error)
);

logic        rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_rdata_error;

logic        cfg_mem_ack_nalb_lsp_enq_rorply_rx_sync_fifo_mem_nc;
logic [31:0] cfg_mem_rdata_nalb_lsp_enq_rorply_rx_sync_fifo_mem_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (4)
        ,.DWIDTH              (27)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_nalb_lsp_enq_rorply_rx_sync_fifo_mem (
         .clk                 (hqm_inp_gated_clk)
        ,.rst_n               (hqm_inp_gated_rst_n)

        ,.func_mem_re         (func_nalb_lsp_enq_rorply_rx_sync_fifo_mem_re)
        ,.func_mem_raddr      (func_nalb_lsp_enq_rorply_rx_sync_fifo_mem_raddr)
        ,.func_mem_waddr      (func_nalb_lsp_enq_rorply_rx_sync_fifo_mem_waddr)
        ,.func_mem_we         (func_nalb_lsp_enq_rorply_rx_sync_fifo_mem_we)
        ,.func_mem_wdata      (func_nalb_lsp_enq_rorply_rx_sync_fifo_mem_wdata)
        ,.func_mem_rdata      (func_nalb_lsp_enq_rorply_rx_sync_fifo_mem_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_nalb_lsp_enq_rorply_rx_sync_fifo_mem_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_nalb_lsp_enq_rorply_rx_sync_fifo_mem_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_re)
        ,.pf_mem_raddr        (pf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_raddr)
        ,.pf_mem_waddr        (pf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_waddr)
        ,.pf_mem_we           (pf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_we)
        ,.pf_mem_wdata        (pf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_wdata)
        ,.pf_mem_rdata        (pf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_rdata)

        ,.mem_wclk            (rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_wclk)
        ,.mem_rclk            (rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_rclk)
        ,.mem_wclk_rst_n      (rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_rclk_rst_n)
        ,.mem_re              (rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_re)
        ,.mem_raddr           (rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_raddr)
        ,.mem_waddr           (rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_waddr)
        ,.mem_we              (rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_we)
        ,.mem_wdata           (rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_wdata)
        ,.mem_rdata           (rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_rdata)

        ,.mem_rdata_error     (rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_rdata_error)
        ,.error               (rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_error)
);

logic        rf_nalb_sel_nalb_fifo_mem_rdata_error;

logic        cfg_mem_ack_nalb_sel_nalb_fifo_mem_nc;
logic [31:0] cfg_mem_rdata_nalb_sel_nalb_fifo_mem_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (16)
        ,.DWIDTH              (27)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_nalb_sel_nalb_fifo_mem (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_nalb_sel_nalb_fifo_mem_re)
        ,.func_mem_raddr      (func_nalb_sel_nalb_fifo_mem_raddr)
        ,.func_mem_waddr      (func_nalb_sel_nalb_fifo_mem_waddr)
        ,.func_mem_we         (func_nalb_sel_nalb_fifo_mem_we)
        ,.func_mem_wdata      (func_nalb_sel_nalb_fifo_mem_wdata)
        ,.func_mem_rdata      (func_nalb_sel_nalb_fifo_mem_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_nalb_sel_nalb_fifo_mem_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_nalb_sel_nalb_fifo_mem_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_nalb_sel_nalb_fifo_mem_re)
        ,.pf_mem_raddr        (pf_nalb_sel_nalb_fifo_mem_raddr)
        ,.pf_mem_waddr        (pf_nalb_sel_nalb_fifo_mem_waddr)
        ,.pf_mem_we           (pf_nalb_sel_nalb_fifo_mem_we)
        ,.pf_mem_wdata        (pf_nalb_sel_nalb_fifo_mem_wdata)
        ,.pf_mem_rdata        (pf_nalb_sel_nalb_fifo_mem_rdata)

        ,.mem_wclk            (rf_nalb_sel_nalb_fifo_mem_wclk)
        ,.mem_rclk            (rf_nalb_sel_nalb_fifo_mem_rclk)
        ,.mem_wclk_rst_n      (rf_nalb_sel_nalb_fifo_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_nalb_sel_nalb_fifo_mem_rclk_rst_n)
        ,.mem_re              (rf_nalb_sel_nalb_fifo_mem_re)
        ,.mem_raddr           (rf_nalb_sel_nalb_fifo_mem_raddr)
        ,.mem_waddr           (rf_nalb_sel_nalb_fifo_mem_waddr)
        ,.mem_we              (rf_nalb_sel_nalb_fifo_mem_we)
        ,.mem_wdata           (rf_nalb_sel_nalb_fifo_mem_wdata)
        ,.mem_rdata           (rf_nalb_sel_nalb_fifo_mem_rdata)

        ,.mem_rdata_error     (rf_nalb_sel_nalb_fifo_mem_rdata_error)
        ,.error               (rf_nalb_sel_nalb_fifo_mem_error)
);

logic        rf_qed_lsp_deq_fifo_mem_rdata_error;

logic        cfg_mem_ack_qed_lsp_deq_fifo_mem_nc;
logic [31:0] cfg_mem_rdata_qed_lsp_deq_fifo_mem_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (24)
        ,.DWIDTH              (9)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_qed_lsp_deq_fifo_mem (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_qed_lsp_deq_fifo_mem_re)
        ,.func_mem_raddr      (func_qed_lsp_deq_fifo_mem_raddr)
        ,.func_mem_waddr      (func_qed_lsp_deq_fifo_mem_waddr)
        ,.func_mem_we         (func_qed_lsp_deq_fifo_mem_we)
        ,.func_mem_wdata      (func_qed_lsp_deq_fifo_mem_wdata)
        ,.func_mem_rdata      (func_qed_lsp_deq_fifo_mem_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_qed_lsp_deq_fifo_mem_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_qed_lsp_deq_fifo_mem_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_qed_lsp_deq_fifo_mem_re)
        ,.pf_mem_raddr        (pf_qed_lsp_deq_fifo_mem_raddr)
        ,.pf_mem_waddr        (pf_qed_lsp_deq_fifo_mem_waddr)
        ,.pf_mem_we           (pf_qed_lsp_deq_fifo_mem_we)
        ,.pf_mem_wdata        (pf_qed_lsp_deq_fifo_mem_wdata)
        ,.pf_mem_rdata        (pf_qed_lsp_deq_fifo_mem_rdata)

        ,.mem_wclk            (rf_qed_lsp_deq_fifo_mem_wclk)
        ,.mem_rclk            (rf_qed_lsp_deq_fifo_mem_rclk)
        ,.mem_wclk_rst_n      (rf_qed_lsp_deq_fifo_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_qed_lsp_deq_fifo_mem_rclk_rst_n)
        ,.mem_re              (rf_qed_lsp_deq_fifo_mem_re)
        ,.mem_raddr           (rf_qed_lsp_deq_fifo_mem_raddr)
        ,.mem_waddr           (rf_qed_lsp_deq_fifo_mem_waddr)
        ,.mem_we              (rf_qed_lsp_deq_fifo_mem_we)
        ,.mem_wdata           (rf_qed_lsp_deq_fifo_mem_wdata)
        ,.mem_rdata           (rf_qed_lsp_deq_fifo_mem_rdata)

        ,.mem_rdata_error     (rf_qed_lsp_deq_fifo_mem_rdata_error)
        ,.error               (rf_qed_lsp_deq_fifo_mem_error)
);

logic [(       2)-1:0] rf_qid_aqed_active_count_mem_raddr_nc ;
logic [(       2)-1:0] rf_qid_aqed_active_count_mem_waddr_nc ;

logic        rf_qid_aqed_active_count_mem_rdata_error;

hqm_AW_rfw_access #( 
         .DEPTH               (32)
        ,.DWIDTH              (14)
        ,.AWIDTHPAD           (2)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_qid_aqed_active_count_mem (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_qid_aqed_active_count_mem_re)
        ,.func_mem_raddr      (func_qid_aqed_active_count_mem_raddr)
        ,.func_mem_waddr      (func_qid_aqed_active_count_mem_waddr)
        ,.func_mem_we         (func_qid_aqed_active_count_mem_we)
        ,.func_mem_wdata      (func_qid_aqed_active_count_mem_wdata)
        ,.func_mem_rdata      (func_qid_aqed_active_count_mem_rdata)

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

        ,.pf_mem_re           (pf_qid_aqed_active_count_mem_re)
        ,.pf_mem_raddr        (pf_qid_aqed_active_count_mem_raddr)
        ,.pf_mem_waddr        (pf_qid_aqed_active_count_mem_waddr)
        ,.pf_mem_we           (pf_qid_aqed_active_count_mem_we)
        ,.pf_mem_wdata        (pf_qid_aqed_active_count_mem_wdata)
        ,.pf_mem_rdata        (pf_qid_aqed_active_count_mem_rdata)

        ,.mem_wclk            (rf_qid_aqed_active_count_mem_wclk)
        ,.mem_rclk            (rf_qid_aqed_active_count_mem_rclk)
        ,.mem_wclk_rst_n      (rf_qid_aqed_active_count_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_qid_aqed_active_count_mem_rclk_rst_n)
        ,.mem_re              (rf_qid_aqed_active_count_mem_re)
        ,.mem_raddr           ({rf_qid_aqed_active_count_mem_raddr_nc , rf_qid_aqed_active_count_mem_raddr})
        ,.mem_waddr           ({rf_qid_aqed_active_count_mem_waddr_nc , rf_qid_aqed_active_count_mem_waddr})
        ,.mem_we              (rf_qid_aqed_active_count_mem_we)
        ,.mem_wdata           (rf_qid_aqed_active_count_mem_wdata)
        ,.mem_rdata           (rf_qid_aqed_active_count_mem_rdata)

        ,.mem_rdata_error     (rf_qid_aqed_active_count_mem_rdata_error)
        ,.error               (rf_qid_aqed_active_count_mem_error)
);

logic [(       2)-1:0] rf_qid_atm_active_mem_raddr_nc ;
logic [(       2)-1:0] rf_qid_atm_active_mem_waddr_nc ;

logic        rf_qid_atm_active_mem_rdata_error;

hqm_AW_rfw_access #( 
         .DEPTH               (32)
        ,.DWIDTH              (17)
        ,.AWIDTHPAD           (2)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_qid_atm_active_mem (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_qid_atm_active_mem_re)
        ,.func_mem_raddr      (func_qid_atm_active_mem_raddr)
        ,.func_mem_waddr      (func_qid_atm_active_mem_waddr)
        ,.func_mem_we         (func_qid_atm_active_mem_we)
        ,.func_mem_wdata      (func_qid_atm_active_mem_wdata)
        ,.func_mem_rdata      (func_qid_atm_active_mem_rdata)

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

        ,.pf_mem_re           (pf_qid_atm_active_mem_re)
        ,.pf_mem_raddr        (pf_qid_atm_active_mem_raddr)
        ,.pf_mem_waddr        (pf_qid_atm_active_mem_waddr)
        ,.pf_mem_we           (pf_qid_atm_active_mem_we)
        ,.pf_mem_wdata        (pf_qid_atm_active_mem_wdata)
        ,.pf_mem_rdata        (pf_qid_atm_active_mem_rdata)

        ,.mem_wclk            (rf_qid_atm_active_mem_wclk)
        ,.mem_rclk            (rf_qid_atm_active_mem_rclk)
        ,.mem_wclk_rst_n      (rf_qid_atm_active_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_qid_atm_active_mem_rclk_rst_n)
        ,.mem_re              (rf_qid_atm_active_mem_re)
        ,.mem_raddr           ({rf_qid_atm_active_mem_raddr_nc , rf_qid_atm_active_mem_raddr})
        ,.mem_waddr           ({rf_qid_atm_active_mem_waddr_nc , rf_qid_atm_active_mem_waddr})
        ,.mem_we              (rf_qid_atm_active_mem_we)
        ,.mem_wdata           (rf_qid_atm_active_mem_wdata)
        ,.mem_rdata           (rf_qid_atm_active_mem_rdata)

        ,.mem_rdata_error     (rf_qid_atm_active_mem_rdata_error)
        ,.error               (rf_qid_atm_active_mem_error)
);

logic [(       2)-1:0] rf_qid_atm_tot_enq_cnt_mem_raddr_nc ;
logic [(       2)-1:0] rf_qid_atm_tot_enq_cnt_mem_waddr_nc ;

logic        rf_qid_atm_tot_enq_cnt_mem_rdata_error;

hqm_AW_rfw_access #( 
         .DEPTH               (32)
        ,.DWIDTH              (66)
        ,.AWIDTHPAD           (2)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_qid_atm_tot_enq_cnt_mem (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_qid_atm_tot_enq_cnt_mem_re)
        ,.func_mem_raddr      (func_qid_atm_tot_enq_cnt_mem_raddr)
        ,.func_mem_waddr      (func_qid_atm_tot_enq_cnt_mem_waddr)
        ,.func_mem_we         (func_qid_atm_tot_enq_cnt_mem_we)
        ,.func_mem_wdata      (func_qid_atm_tot_enq_cnt_mem_wdata)
        ,.func_mem_rdata      (func_qid_atm_tot_enq_cnt_mem_rdata)

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

        ,.pf_mem_re           (pf_qid_atm_tot_enq_cnt_mem_re)
        ,.pf_mem_raddr        (pf_qid_atm_tot_enq_cnt_mem_raddr)
        ,.pf_mem_waddr        (pf_qid_atm_tot_enq_cnt_mem_waddr)
        ,.pf_mem_we           (pf_qid_atm_tot_enq_cnt_mem_we)
        ,.pf_mem_wdata        (pf_qid_atm_tot_enq_cnt_mem_wdata)
        ,.pf_mem_rdata        (pf_qid_atm_tot_enq_cnt_mem_rdata)

        ,.mem_wclk            (rf_qid_atm_tot_enq_cnt_mem_wclk)
        ,.mem_rclk            (rf_qid_atm_tot_enq_cnt_mem_rclk)
        ,.mem_wclk_rst_n      (rf_qid_atm_tot_enq_cnt_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_qid_atm_tot_enq_cnt_mem_rclk_rst_n)
        ,.mem_re              (rf_qid_atm_tot_enq_cnt_mem_re)
        ,.mem_raddr           ({rf_qid_atm_tot_enq_cnt_mem_raddr_nc , rf_qid_atm_tot_enq_cnt_mem_raddr})
        ,.mem_waddr           ({rf_qid_atm_tot_enq_cnt_mem_waddr_nc , rf_qid_atm_tot_enq_cnt_mem_waddr})
        ,.mem_we              (rf_qid_atm_tot_enq_cnt_mem_we)
        ,.mem_wdata           (rf_qid_atm_tot_enq_cnt_mem_wdata)
        ,.mem_rdata           (rf_qid_atm_tot_enq_cnt_mem_rdata)

        ,.mem_rdata_error     (rf_qid_atm_tot_enq_cnt_mem_rdata_error)
        ,.error               (rf_qid_atm_tot_enq_cnt_mem_error)
);

logic [(       2)-1:0] rf_qid_atq_enqueue_count_mem_raddr_nc ;
logic [(       2)-1:0] rf_qid_atq_enqueue_count_mem_waddr_nc ;

logic        rf_qid_atq_enqueue_count_mem_rdata_error;

hqm_AW_rfw_access #( 
         .DEPTH               (32)
        ,.DWIDTH              (17)
        ,.AWIDTHPAD           (2)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_qid_atq_enqueue_count_mem (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_qid_atq_enqueue_count_mem_re)
        ,.func_mem_raddr      (func_qid_atq_enqueue_count_mem_raddr)
        ,.func_mem_waddr      (func_qid_atq_enqueue_count_mem_waddr)
        ,.func_mem_we         (func_qid_atq_enqueue_count_mem_we)
        ,.func_mem_wdata      (func_qid_atq_enqueue_count_mem_wdata)
        ,.func_mem_rdata      (func_qid_atq_enqueue_count_mem_rdata)

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

        ,.pf_mem_re           (pf_qid_atq_enqueue_count_mem_re)
        ,.pf_mem_raddr        (pf_qid_atq_enqueue_count_mem_raddr)
        ,.pf_mem_waddr        (pf_qid_atq_enqueue_count_mem_waddr)
        ,.pf_mem_we           (pf_qid_atq_enqueue_count_mem_we)
        ,.pf_mem_wdata        (pf_qid_atq_enqueue_count_mem_wdata)
        ,.pf_mem_rdata        (pf_qid_atq_enqueue_count_mem_rdata)

        ,.mem_wclk            (rf_qid_atq_enqueue_count_mem_wclk)
        ,.mem_rclk            (rf_qid_atq_enqueue_count_mem_rclk)
        ,.mem_wclk_rst_n      (rf_qid_atq_enqueue_count_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_qid_atq_enqueue_count_mem_rclk_rst_n)
        ,.mem_re              (rf_qid_atq_enqueue_count_mem_re)
        ,.mem_raddr           ({rf_qid_atq_enqueue_count_mem_raddr_nc , rf_qid_atq_enqueue_count_mem_raddr})
        ,.mem_waddr           ({rf_qid_atq_enqueue_count_mem_waddr_nc , rf_qid_atq_enqueue_count_mem_waddr})
        ,.mem_we              (rf_qid_atq_enqueue_count_mem_we)
        ,.mem_wdata           (rf_qid_atq_enqueue_count_mem_wdata)
        ,.mem_rdata           (rf_qid_atq_enqueue_count_mem_rdata)

        ,.mem_rdata_error     (rf_qid_atq_enqueue_count_mem_rdata_error)
        ,.error               (rf_qid_atq_enqueue_count_mem_error)
);

logic [(       1)-1:0] rf_qid_dir_max_depth_mem_raddr_nc ;
logic [(       1)-1:0] rf_qid_dir_max_depth_mem_waddr_nc ;

logic        rf_qid_dir_max_depth_mem_rdata_error;

hqm_AW_rfw_access #( 
         .DEPTH               (64)
        ,.DWIDTH              (15)
        ,.AWIDTHPAD           (1)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_qid_dir_max_depth_mem (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_qid_dir_max_depth_mem_re)
        ,.func_mem_raddr      (func_qid_dir_max_depth_mem_raddr)
        ,.func_mem_waddr      (func_qid_dir_max_depth_mem_waddr)
        ,.func_mem_we         (func_qid_dir_max_depth_mem_we)
        ,.func_mem_wdata      (func_qid_dir_max_depth_mem_wdata)
        ,.func_mem_rdata      (func_qid_dir_max_depth_mem_rdata)

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

        ,.pf_mem_re           (pf_qid_dir_max_depth_mem_re)
        ,.pf_mem_raddr        (pf_qid_dir_max_depth_mem_raddr)
        ,.pf_mem_waddr        (pf_qid_dir_max_depth_mem_waddr)
        ,.pf_mem_we           (pf_qid_dir_max_depth_mem_we)
        ,.pf_mem_wdata        (pf_qid_dir_max_depth_mem_wdata)
        ,.pf_mem_rdata        (pf_qid_dir_max_depth_mem_rdata)

        ,.mem_wclk            (rf_qid_dir_max_depth_mem_wclk)
        ,.mem_rclk            (rf_qid_dir_max_depth_mem_rclk)
        ,.mem_wclk_rst_n      (rf_qid_dir_max_depth_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_qid_dir_max_depth_mem_rclk_rst_n)
        ,.mem_re              (rf_qid_dir_max_depth_mem_re)
        ,.mem_raddr           ({rf_qid_dir_max_depth_mem_raddr_nc , rf_qid_dir_max_depth_mem_raddr})
        ,.mem_waddr           ({rf_qid_dir_max_depth_mem_waddr_nc , rf_qid_dir_max_depth_mem_waddr})
        ,.mem_we              (rf_qid_dir_max_depth_mem_we)
        ,.mem_wdata           (rf_qid_dir_max_depth_mem_wdata)
        ,.mem_rdata           (rf_qid_dir_max_depth_mem_rdata)

        ,.mem_rdata_error     (rf_qid_dir_max_depth_mem_rdata_error)
        ,.error               (rf_qid_dir_max_depth_mem_error)
);

logic [(       2)-1:0] rf_qid_dir_replay_count_mem_raddr_nc ;
logic [(       2)-1:0] rf_qid_dir_replay_count_mem_waddr_nc ;

logic        rf_qid_dir_replay_count_mem_rdata_error;

hqm_AW_rfw_access #( 
         .DEPTH               (32)
        ,.DWIDTH              (17)
        ,.AWIDTHPAD           (2)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_qid_dir_replay_count_mem (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_qid_dir_replay_count_mem_re)
        ,.func_mem_raddr      (func_qid_dir_replay_count_mem_raddr)
        ,.func_mem_waddr      (func_qid_dir_replay_count_mem_waddr)
        ,.func_mem_we         (func_qid_dir_replay_count_mem_we)
        ,.func_mem_wdata      (func_qid_dir_replay_count_mem_wdata)
        ,.func_mem_rdata      (func_qid_dir_replay_count_mem_rdata)

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

        ,.pf_mem_re           (pf_qid_dir_replay_count_mem_re)
        ,.pf_mem_raddr        (pf_qid_dir_replay_count_mem_raddr)
        ,.pf_mem_waddr        (pf_qid_dir_replay_count_mem_waddr)
        ,.pf_mem_we           (pf_qid_dir_replay_count_mem_we)
        ,.pf_mem_wdata        (pf_qid_dir_replay_count_mem_wdata)
        ,.pf_mem_rdata        (pf_qid_dir_replay_count_mem_rdata)

        ,.mem_wclk            (rf_qid_dir_replay_count_mem_wclk)
        ,.mem_rclk            (rf_qid_dir_replay_count_mem_rclk)
        ,.mem_wclk_rst_n      (rf_qid_dir_replay_count_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_qid_dir_replay_count_mem_rclk_rst_n)
        ,.mem_re              (rf_qid_dir_replay_count_mem_re)
        ,.mem_raddr           ({rf_qid_dir_replay_count_mem_raddr_nc , rf_qid_dir_replay_count_mem_raddr})
        ,.mem_waddr           ({rf_qid_dir_replay_count_mem_waddr_nc , rf_qid_dir_replay_count_mem_waddr})
        ,.mem_we              (rf_qid_dir_replay_count_mem_we)
        ,.mem_wdata           (rf_qid_dir_replay_count_mem_wdata)
        ,.mem_rdata           (rf_qid_dir_replay_count_mem_rdata)

        ,.mem_rdata_error     (rf_qid_dir_replay_count_mem_rdata_error)
        ,.error               (rf_qid_dir_replay_count_mem_error)
);

logic [(       1)-1:0] rf_qid_dir_tot_enq_cnt_mem_raddr_nc ;
logic [(       1)-1:0] rf_qid_dir_tot_enq_cnt_mem_waddr_nc ;

logic        rf_qid_dir_tot_enq_cnt_mem_rdata_error;

hqm_AW_rfw_access #( 
         .DEPTH               (64)
        ,.DWIDTH              (66)
        ,.AWIDTHPAD           (1)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_qid_dir_tot_enq_cnt_mem (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_qid_dir_tot_enq_cnt_mem_re)
        ,.func_mem_raddr      (func_qid_dir_tot_enq_cnt_mem_raddr)
        ,.func_mem_waddr      (func_qid_dir_tot_enq_cnt_mem_waddr)
        ,.func_mem_we         (func_qid_dir_tot_enq_cnt_mem_we)
        ,.func_mem_wdata      (func_qid_dir_tot_enq_cnt_mem_wdata)
        ,.func_mem_rdata      (func_qid_dir_tot_enq_cnt_mem_rdata)

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

        ,.pf_mem_re           (pf_qid_dir_tot_enq_cnt_mem_re)
        ,.pf_mem_raddr        (pf_qid_dir_tot_enq_cnt_mem_raddr)
        ,.pf_mem_waddr        (pf_qid_dir_tot_enq_cnt_mem_waddr)
        ,.pf_mem_we           (pf_qid_dir_tot_enq_cnt_mem_we)
        ,.pf_mem_wdata        (pf_qid_dir_tot_enq_cnt_mem_wdata)
        ,.pf_mem_rdata        (pf_qid_dir_tot_enq_cnt_mem_rdata)

        ,.mem_wclk            (rf_qid_dir_tot_enq_cnt_mem_wclk)
        ,.mem_rclk            (rf_qid_dir_tot_enq_cnt_mem_rclk)
        ,.mem_wclk_rst_n      (rf_qid_dir_tot_enq_cnt_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_qid_dir_tot_enq_cnt_mem_rclk_rst_n)
        ,.mem_re              (rf_qid_dir_tot_enq_cnt_mem_re)
        ,.mem_raddr           ({rf_qid_dir_tot_enq_cnt_mem_raddr_nc , rf_qid_dir_tot_enq_cnt_mem_raddr})
        ,.mem_waddr           ({rf_qid_dir_tot_enq_cnt_mem_waddr_nc , rf_qid_dir_tot_enq_cnt_mem_waddr})
        ,.mem_we              (rf_qid_dir_tot_enq_cnt_mem_we)
        ,.mem_wdata           (rf_qid_dir_tot_enq_cnt_mem_wdata)
        ,.mem_rdata           (rf_qid_dir_tot_enq_cnt_mem_rdata)

        ,.mem_rdata_error     (rf_qid_dir_tot_enq_cnt_mem_rdata_error)
        ,.error               (rf_qid_dir_tot_enq_cnt_mem_error)
);

logic [(       2)-1:0] rf_qid_ldb_enqueue_count_mem_raddr_nc ;
logic [(       2)-1:0] rf_qid_ldb_enqueue_count_mem_waddr_nc ;

logic        rf_qid_ldb_enqueue_count_mem_rdata_error;

hqm_AW_rfw_access #( 
         .DEPTH               (32)
        ,.DWIDTH              (17)
        ,.AWIDTHPAD           (2)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_qid_ldb_enqueue_count_mem (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_qid_ldb_enqueue_count_mem_re)
        ,.func_mem_raddr      (func_qid_ldb_enqueue_count_mem_raddr)
        ,.func_mem_waddr      (func_qid_ldb_enqueue_count_mem_waddr)
        ,.func_mem_we         (func_qid_ldb_enqueue_count_mem_we)
        ,.func_mem_wdata      (func_qid_ldb_enqueue_count_mem_wdata)
        ,.func_mem_rdata      (func_qid_ldb_enqueue_count_mem_rdata)

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

        ,.pf_mem_re           (pf_qid_ldb_enqueue_count_mem_re)
        ,.pf_mem_raddr        (pf_qid_ldb_enqueue_count_mem_raddr)
        ,.pf_mem_waddr        (pf_qid_ldb_enqueue_count_mem_waddr)
        ,.pf_mem_we           (pf_qid_ldb_enqueue_count_mem_we)
        ,.pf_mem_wdata        (pf_qid_ldb_enqueue_count_mem_wdata)
        ,.pf_mem_rdata        (pf_qid_ldb_enqueue_count_mem_rdata)

        ,.mem_wclk            (rf_qid_ldb_enqueue_count_mem_wclk)
        ,.mem_rclk            (rf_qid_ldb_enqueue_count_mem_rclk)
        ,.mem_wclk_rst_n      (rf_qid_ldb_enqueue_count_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_qid_ldb_enqueue_count_mem_rclk_rst_n)
        ,.mem_re              (rf_qid_ldb_enqueue_count_mem_re)
        ,.mem_raddr           ({rf_qid_ldb_enqueue_count_mem_raddr_nc , rf_qid_ldb_enqueue_count_mem_raddr})
        ,.mem_waddr           ({rf_qid_ldb_enqueue_count_mem_waddr_nc , rf_qid_ldb_enqueue_count_mem_waddr})
        ,.mem_we              (rf_qid_ldb_enqueue_count_mem_we)
        ,.mem_wdata           (rf_qid_ldb_enqueue_count_mem_wdata)
        ,.mem_rdata           (rf_qid_ldb_enqueue_count_mem_rdata)

        ,.mem_rdata_error     (rf_qid_ldb_enqueue_count_mem_rdata_error)
        ,.error               (rf_qid_ldb_enqueue_count_mem_error)
);

logic [(       2)-1:0] rf_qid_ldb_inflight_count_mem_raddr_nc ;
logic [(       2)-1:0] rf_qid_ldb_inflight_count_mem_waddr_nc ;

logic        rf_qid_ldb_inflight_count_mem_rdata_error;

hqm_AW_rfw_access #( 
         .DEPTH               (32)
        ,.DWIDTH              (14)
        ,.AWIDTHPAD           (2)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_qid_ldb_inflight_count_mem (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_qid_ldb_inflight_count_mem_re)
        ,.func_mem_raddr      (func_qid_ldb_inflight_count_mem_raddr)
        ,.func_mem_waddr      (func_qid_ldb_inflight_count_mem_waddr)
        ,.func_mem_we         (func_qid_ldb_inflight_count_mem_we)
        ,.func_mem_wdata      (func_qid_ldb_inflight_count_mem_wdata)
        ,.func_mem_rdata      (func_qid_ldb_inflight_count_mem_rdata)

        ,.cfg_mem_re          (cfg_mem_re[(30 * 1) +: 1])
        ,.cfg_mem_we          (cfg_mem_we[(30 * 1) +: 1])
        ,.cfg_mem_addr        (cfg_mem_addr)
        ,.cfg_mem_minbit      (cfg_mem_minbit)
        ,.cfg_mem_maxbit      (cfg_mem_maxbit)
        ,.cfg_mem_wdata       (cfg_mem_wdata)
        ,.cfg_mem_rdata       (cfg_mem_rdata[(30 * 32) +: 32])
        ,.cfg_mem_ack         (cfg_mem_ack[  (30 *  1) +:  1])
        ,.cfg_mem_cc_v        (cfg_mem_cc_v)
        ,.cfg_mem_cc_value    (cfg_mem_cc_value)
        ,.cfg_mem_cc_width    (cfg_mem_cc_width)
        ,.cfg_mem_cc_position (cfg_mem_cc_position)

        ,.pf_mem_re           (pf_qid_ldb_inflight_count_mem_re)
        ,.pf_mem_raddr        (pf_qid_ldb_inflight_count_mem_raddr)
        ,.pf_mem_waddr        (pf_qid_ldb_inflight_count_mem_waddr)
        ,.pf_mem_we           (pf_qid_ldb_inflight_count_mem_we)
        ,.pf_mem_wdata        (pf_qid_ldb_inflight_count_mem_wdata)
        ,.pf_mem_rdata        (pf_qid_ldb_inflight_count_mem_rdata)

        ,.mem_wclk            (rf_qid_ldb_inflight_count_mem_wclk)
        ,.mem_rclk            (rf_qid_ldb_inflight_count_mem_rclk)
        ,.mem_wclk_rst_n      (rf_qid_ldb_inflight_count_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_qid_ldb_inflight_count_mem_rclk_rst_n)
        ,.mem_re              (rf_qid_ldb_inflight_count_mem_re)
        ,.mem_raddr           ({rf_qid_ldb_inflight_count_mem_raddr_nc , rf_qid_ldb_inflight_count_mem_raddr})
        ,.mem_waddr           ({rf_qid_ldb_inflight_count_mem_waddr_nc , rf_qid_ldb_inflight_count_mem_waddr})
        ,.mem_we              (rf_qid_ldb_inflight_count_mem_we)
        ,.mem_wdata           (rf_qid_ldb_inflight_count_mem_wdata)
        ,.mem_rdata           (rf_qid_ldb_inflight_count_mem_rdata)

        ,.mem_rdata_error     (rf_qid_ldb_inflight_count_mem_rdata_error)
        ,.error               (rf_qid_ldb_inflight_count_mem_error)
);

logic [(       2)-1:0] rf_qid_ldb_replay_count_mem_raddr_nc ;
logic [(       2)-1:0] rf_qid_ldb_replay_count_mem_waddr_nc ;

logic        rf_qid_ldb_replay_count_mem_rdata_error;

hqm_AW_rfw_access #( 
         .DEPTH               (32)
        ,.DWIDTH              (17)
        ,.AWIDTHPAD           (2)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_qid_ldb_replay_count_mem (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_qid_ldb_replay_count_mem_re)
        ,.func_mem_raddr      (func_qid_ldb_replay_count_mem_raddr)
        ,.func_mem_waddr      (func_qid_ldb_replay_count_mem_waddr)
        ,.func_mem_we         (func_qid_ldb_replay_count_mem_we)
        ,.func_mem_wdata      (func_qid_ldb_replay_count_mem_wdata)
        ,.func_mem_rdata      (func_qid_ldb_replay_count_mem_rdata)

        ,.cfg_mem_re          (cfg_mem_re[(31 * 1) +: 1])
        ,.cfg_mem_we          (cfg_mem_we[(31 * 1) +: 1])
        ,.cfg_mem_addr        (cfg_mem_addr)
        ,.cfg_mem_minbit      (cfg_mem_minbit)
        ,.cfg_mem_maxbit      (cfg_mem_maxbit)
        ,.cfg_mem_wdata       (cfg_mem_wdata)
        ,.cfg_mem_rdata       (cfg_mem_rdata[(31 * 32) +: 32])
        ,.cfg_mem_ack         (cfg_mem_ack[  (31 *  1) +:  1])
        ,.cfg_mem_cc_v        (cfg_mem_cc_v)
        ,.cfg_mem_cc_value    (cfg_mem_cc_value)
        ,.cfg_mem_cc_width    (cfg_mem_cc_width)
        ,.cfg_mem_cc_position (cfg_mem_cc_position)

        ,.pf_mem_re           (pf_qid_ldb_replay_count_mem_re)
        ,.pf_mem_raddr        (pf_qid_ldb_replay_count_mem_raddr)
        ,.pf_mem_waddr        (pf_qid_ldb_replay_count_mem_waddr)
        ,.pf_mem_we           (pf_qid_ldb_replay_count_mem_we)
        ,.pf_mem_wdata        (pf_qid_ldb_replay_count_mem_wdata)
        ,.pf_mem_rdata        (pf_qid_ldb_replay_count_mem_rdata)

        ,.mem_wclk            (rf_qid_ldb_replay_count_mem_wclk)
        ,.mem_rclk            (rf_qid_ldb_replay_count_mem_rclk)
        ,.mem_wclk_rst_n      (rf_qid_ldb_replay_count_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_qid_ldb_replay_count_mem_rclk_rst_n)
        ,.mem_re              (rf_qid_ldb_replay_count_mem_re)
        ,.mem_raddr           ({rf_qid_ldb_replay_count_mem_raddr_nc , rf_qid_ldb_replay_count_mem_raddr})
        ,.mem_waddr           ({rf_qid_ldb_replay_count_mem_waddr_nc , rf_qid_ldb_replay_count_mem_waddr})
        ,.mem_we              (rf_qid_ldb_replay_count_mem_we)
        ,.mem_wdata           (rf_qid_ldb_replay_count_mem_wdata)
        ,.mem_rdata           (rf_qid_ldb_replay_count_mem_rdata)

        ,.mem_rdata_error     (rf_qid_ldb_replay_count_mem_rdata_error)
        ,.error               (rf_qid_ldb_replay_count_mem_error)
);

logic [(       2)-1:0] rf_qid_naldb_max_depth_mem_raddr_nc ;
logic [(       2)-1:0] rf_qid_naldb_max_depth_mem_waddr_nc ;

logic        rf_qid_naldb_max_depth_mem_rdata_error;

hqm_AW_rfw_access #( 
         .DEPTH               (32)
        ,.DWIDTH              (15)
        ,.AWIDTHPAD           (2)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_qid_naldb_max_depth_mem (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_qid_naldb_max_depth_mem_re)
        ,.func_mem_raddr      (func_qid_naldb_max_depth_mem_raddr)
        ,.func_mem_waddr      (func_qid_naldb_max_depth_mem_waddr)
        ,.func_mem_we         (func_qid_naldb_max_depth_mem_we)
        ,.func_mem_wdata      (func_qid_naldb_max_depth_mem_wdata)
        ,.func_mem_rdata      (func_qid_naldb_max_depth_mem_rdata)

        ,.cfg_mem_re          (cfg_mem_re[(32 * 1) +: 1])
        ,.cfg_mem_we          (cfg_mem_we[(32 * 1) +: 1])
        ,.cfg_mem_addr        (cfg_mem_addr)
        ,.cfg_mem_minbit      (cfg_mem_minbit)
        ,.cfg_mem_maxbit      (cfg_mem_maxbit)
        ,.cfg_mem_wdata       (cfg_mem_wdata)
        ,.cfg_mem_rdata       (cfg_mem_rdata[(32 * 32) +: 32])
        ,.cfg_mem_ack         (cfg_mem_ack[  (32 *  1) +:  1])
        ,.cfg_mem_cc_v        (cfg_mem_cc_v)
        ,.cfg_mem_cc_value    (cfg_mem_cc_value)
        ,.cfg_mem_cc_width    (cfg_mem_cc_width)
        ,.cfg_mem_cc_position (cfg_mem_cc_position)

        ,.pf_mem_re           (pf_qid_naldb_max_depth_mem_re)
        ,.pf_mem_raddr        (pf_qid_naldb_max_depth_mem_raddr)
        ,.pf_mem_waddr        (pf_qid_naldb_max_depth_mem_waddr)
        ,.pf_mem_we           (pf_qid_naldb_max_depth_mem_we)
        ,.pf_mem_wdata        (pf_qid_naldb_max_depth_mem_wdata)
        ,.pf_mem_rdata        (pf_qid_naldb_max_depth_mem_rdata)

        ,.mem_wclk            (rf_qid_naldb_max_depth_mem_wclk)
        ,.mem_rclk            (rf_qid_naldb_max_depth_mem_rclk)
        ,.mem_wclk_rst_n      (rf_qid_naldb_max_depth_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_qid_naldb_max_depth_mem_rclk_rst_n)
        ,.mem_re              (rf_qid_naldb_max_depth_mem_re)
        ,.mem_raddr           ({rf_qid_naldb_max_depth_mem_raddr_nc , rf_qid_naldb_max_depth_mem_raddr})
        ,.mem_waddr           ({rf_qid_naldb_max_depth_mem_waddr_nc , rf_qid_naldb_max_depth_mem_waddr})
        ,.mem_we              (rf_qid_naldb_max_depth_mem_we)
        ,.mem_wdata           (rf_qid_naldb_max_depth_mem_wdata)
        ,.mem_rdata           (rf_qid_naldb_max_depth_mem_rdata)

        ,.mem_rdata_error     (rf_qid_naldb_max_depth_mem_rdata_error)
        ,.error               (rf_qid_naldb_max_depth_mem_error)
);

logic [(       2)-1:0] rf_qid_naldb_tot_enq_cnt_mem_raddr_nc ;
logic [(       2)-1:0] rf_qid_naldb_tot_enq_cnt_mem_waddr_nc ;

logic        rf_qid_naldb_tot_enq_cnt_mem_rdata_error;

hqm_AW_rfw_access #( 
         .DEPTH               (32)
        ,.DWIDTH              (66)
        ,.AWIDTHPAD           (2)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_qid_naldb_tot_enq_cnt_mem (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_qid_naldb_tot_enq_cnt_mem_re)
        ,.func_mem_raddr      (func_qid_naldb_tot_enq_cnt_mem_raddr)
        ,.func_mem_waddr      (func_qid_naldb_tot_enq_cnt_mem_waddr)
        ,.func_mem_we         (func_qid_naldb_tot_enq_cnt_mem_we)
        ,.func_mem_wdata      (func_qid_naldb_tot_enq_cnt_mem_wdata)
        ,.func_mem_rdata      (func_qid_naldb_tot_enq_cnt_mem_rdata)

        ,.cfg_mem_re          (cfg_mem_re[(33 * 1) +: 1])
        ,.cfg_mem_we          (cfg_mem_we[(33 * 1) +: 1])
        ,.cfg_mem_addr        (cfg_mem_addr)
        ,.cfg_mem_minbit      (cfg_mem_minbit)
        ,.cfg_mem_maxbit      (cfg_mem_maxbit)
        ,.cfg_mem_wdata       (cfg_mem_wdata)
        ,.cfg_mem_rdata       (cfg_mem_rdata[(33 * 32) +: 32])
        ,.cfg_mem_ack         (cfg_mem_ack[  (33 *  1) +:  1])
        ,.cfg_mem_cc_v        (cfg_mem_cc_v)
        ,.cfg_mem_cc_value    (cfg_mem_cc_value)
        ,.cfg_mem_cc_width    (cfg_mem_cc_width)
        ,.cfg_mem_cc_position (cfg_mem_cc_position)

        ,.pf_mem_re           (pf_qid_naldb_tot_enq_cnt_mem_re)
        ,.pf_mem_raddr        (pf_qid_naldb_tot_enq_cnt_mem_raddr)
        ,.pf_mem_waddr        (pf_qid_naldb_tot_enq_cnt_mem_waddr)
        ,.pf_mem_we           (pf_qid_naldb_tot_enq_cnt_mem_we)
        ,.pf_mem_wdata        (pf_qid_naldb_tot_enq_cnt_mem_wdata)
        ,.pf_mem_rdata        (pf_qid_naldb_tot_enq_cnt_mem_rdata)

        ,.mem_wclk            (rf_qid_naldb_tot_enq_cnt_mem_wclk)
        ,.mem_rclk            (rf_qid_naldb_tot_enq_cnt_mem_rclk)
        ,.mem_wclk_rst_n      (rf_qid_naldb_tot_enq_cnt_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_qid_naldb_tot_enq_cnt_mem_rclk_rst_n)
        ,.mem_re              (rf_qid_naldb_tot_enq_cnt_mem_re)
        ,.mem_raddr           ({rf_qid_naldb_tot_enq_cnt_mem_raddr_nc , rf_qid_naldb_tot_enq_cnt_mem_raddr})
        ,.mem_waddr           ({rf_qid_naldb_tot_enq_cnt_mem_waddr_nc , rf_qid_naldb_tot_enq_cnt_mem_waddr})
        ,.mem_we              (rf_qid_naldb_tot_enq_cnt_mem_we)
        ,.mem_wdata           (rf_qid_naldb_tot_enq_cnt_mem_wdata)
        ,.mem_rdata           (rf_qid_naldb_tot_enq_cnt_mem_rdata)

        ,.mem_rdata_error     (rf_qid_naldb_tot_enq_cnt_mem_rdata_error)
        ,.error               (rf_qid_naldb_tot_enq_cnt_mem_error)
);

logic        rf_rop_lsp_reordercmp_rx_sync_fifo_mem_rdata_error;

logic        cfg_mem_ack_rop_lsp_reordercmp_rx_sync_fifo_mem_nc;
logic [31:0] cfg_mem_rdata_rop_lsp_reordercmp_rx_sync_fifo_mem_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (8)
        ,.DWIDTH              (17)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_rop_lsp_reordercmp_rx_sync_fifo_mem (
         .clk                 (hqm_inp_gated_clk)
        ,.rst_n               (hqm_inp_gated_rst_n)

        ,.func_mem_re         (func_rop_lsp_reordercmp_rx_sync_fifo_mem_re)
        ,.func_mem_raddr      (func_rop_lsp_reordercmp_rx_sync_fifo_mem_raddr)
        ,.func_mem_waddr      (func_rop_lsp_reordercmp_rx_sync_fifo_mem_waddr)
        ,.func_mem_we         (func_rop_lsp_reordercmp_rx_sync_fifo_mem_we)
        ,.func_mem_wdata      (func_rop_lsp_reordercmp_rx_sync_fifo_mem_wdata)
        ,.func_mem_rdata      (func_rop_lsp_reordercmp_rx_sync_fifo_mem_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_rop_lsp_reordercmp_rx_sync_fifo_mem_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_rop_lsp_reordercmp_rx_sync_fifo_mem_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_rop_lsp_reordercmp_rx_sync_fifo_mem_re)
        ,.pf_mem_raddr        (pf_rop_lsp_reordercmp_rx_sync_fifo_mem_raddr)
        ,.pf_mem_waddr        (pf_rop_lsp_reordercmp_rx_sync_fifo_mem_waddr)
        ,.pf_mem_we           (pf_rop_lsp_reordercmp_rx_sync_fifo_mem_we)
        ,.pf_mem_wdata        (pf_rop_lsp_reordercmp_rx_sync_fifo_mem_wdata)
        ,.pf_mem_rdata        (pf_rop_lsp_reordercmp_rx_sync_fifo_mem_rdata)

        ,.mem_wclk            (rf_rop_lsp_reordercmp_rx_sync_fifo_mem_wclk)
        ,.mem_rclk            (rf_rop_lsp_reordercmp_rx_sync_fifo_mem_rclk)
        ,.mem_wclk_rst_n      (rf_rop_lsp_reordercmp_rx_sync_fifo_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_rop_lsp_reordercmp_rx_sync_fifo_mem_rclk_rst_n)
        ,.mem_re              (rf_rop_lsp_reordercmp_rx_sync_fifo_mem_re)
        ,.mem_raddr           (rf_rop_lsp_reordercmp_rx_sync_fifo_mem_raddr)
        ,.mem_waddr           (rf_rop_lsp_reordercmp_rx_sync_fifo_mem_waddr)
        ,.mem_we              (rf_rop_lsp_reordercmp_rx_sync_fifo_mem_we)
        ,.mem_wdata           (rf_rop_lsp_reordercmp_rx_sync_fifo_mem_wdata)
        ,.mem_rdata           (rf_rop_lsp_reordercmp_rx_sync_fifo_mem_rdata)

        ,.mem_rdata_error     (rf_rop_lsp_reordercmp_rx_sync_fifo_mem_rdata_error)
        ,.error               (rf_rop_lsp_reordercmp_rx_sync_fifo_mem_error)
);

logic        rf_send_atm_to_cq_rx_sync_fifo_mem_rdata_error;

logic        cfg_mem_ack_send_atm_to_cq_rx_sync_fifo_mem_nc;
logic [31:0] cfg_mem_rdata_send_atm_to_cq_rx_sync_fifo_mem_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (4)
        ,.DWIDTH              (35)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_send_atm_to_cq_rx_sync_fifo_mem (
         .clk                 (hqm_inp_gated_clk)
        ,.rst_n               (hqm_inp_gated_rst_n)

        ,.func_mem_re         (func_send_atm_to_cq_rx_sync_fifo_mem_re)
        ,.func_mem_raddr      (func_send_atm_to_cq_rx_sync_fifo_mem_raddr)
        ,.func_mem_waddr      (func_send_atm_to_cq_rx_sync_fifo_mem_waddr)
        ,.func_mem_we         (func_send_atm_to_cq_rx_sync_fifo_mem_we)
        ,.func_mem_wdata      (func_send_atm_to_cq_rx_sync_fifo_mem_wdata)
        ,.func_mem_rdata      (func_send_atm_to_cq_rx_sync_fifo_mem_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_send_atm_to_cq_rx_sync_fifo_mem_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_send_atm_to_cq_rx_sync_fifo_mem_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_send_atm_to_cq_rx_sync_fifo_mem_re)
        ,.pf_mem_raddr        (pf_send_atm_to_cq_rx_sync_fifo_mem_raddr)
        ,.pf_mem_waddr        (pf_send_atm_to_cq_rx_sync_fifo_mem_waddr)
        ,.pf_mem_we           (pf_send_atm_to_cq_rx_sync_fifo_mem_we)
        ,.pf_mem_wdata        (pf_send_atm_to_cq_rx_sync_fifo_mem_wdata)
        ,.pf_mem_rdata        (pf_send_atm_to_cq_rx_sync_fifo_mem_rdata)

        ,.mem_wclk            (rf_send_atm_to_cq_rx_sync_fifo_mem_wclk)
        ,.mem_rclk            (rf_send_atm_to_cq_rx_sync_fifo_mem_rclk)
        ,.mem_wclk_rst_n      (rf_send_atm_to_cq_rx_sync_fifo_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_send_atm_to_cq_rx_sync_fifo_mem_rclk_rst_n)
        ,.mem_re              (rf_send_atm_to_cq_rx_sync_fifo_mem_re)
        ,.mem_raddr           (rf_send_atm_to_cq_rx_sync_fifo_mem_raddr)
        ,.mem_waddr           (rf_send_atm_to_cq_rx_sync_fifo_mem_waddr)
        ,.mem_we              (rf_send_atm_to_cq_rx_sync_fifo_mem_we)
        ,.mem_wdata           (rf_send_atm_to_cq_rx_sync_fifo_mem_wdata)
        ,.mem_rdata           (rf_send_atm_to_cq_rx_sync_fifo_mem_rdata)

        ,.mem_rdata_error     (rf_send_atm_to_cq_rx_sync_fifo_mem_rdata_error)
        ,.error               (rf_send_atm_to_cq_rx_sync_fifo_mem_error)
);

logic        rf_uno_atm_cmp_fifo_mem_rdata_error;

logic        cfg_mem_ack_uno_atm_cmp_fifo_mem_nc;
logic [31:0] cfg_mem_rdata_uno_atm_cmp_fifo_mem_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (8)
        ,.DWIDTH              (20)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_uno_atm_cmp_fifo_mem (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_uno_atm_cmp_fifo_mem_re)
        ,.func_mem_raddr      (func_uno_atm_cmp_fifo_mem_raddr)
        ,.func_mem_waddr      (func_uno_atm_cmp_fifo_mem_waddr)
        ,.func_mem_we         (func_uno_atm_cmp_fifo_mem_we)
        ,.func_mem_wdata      (func_uno_atm_cmp_fifo_mem_wdata)
        ,.func_mem_rdata      (func_uno_atm_cmp_fifo_mem_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_uno_atm_cmp_fifo_mem_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_uno_atm_cmp_fifo_mem_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_uno_atm_cmp_fifo_mem_re)
        ,.pf_mem_raddr        (pf_uno_atm_cmp_fifo_mem_raddr)
        ,.pf_mem_waddr        (pf_uno_atm_cmp_fifo_mem_waddr)
        ,.pf_mem_we           (pf_uno_atm_cmp_fifo_mem_we)
        ,.pf_mem_wdata        (pf_uno_atm_cmp_fifo_mem_wdata)
        ,.pf_mem_rdata        (pf_uno_atm_cmp_fifo_mem_rdata)

        ,.mem_wclk            (rf_uno_atm_cmp_fifo_mem_wclk)
        ,.mem_rclk            (rf_uno_atm_cmp_fifo_mem_rclk)
        ,.mem_wclk_rst_n      (rf_uno_atm_cmp_fifo_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_uno_atm_cmp_fifo_mem_rclk_rst_n)
        ,.mem_re              (rf_uno_atm_cmp_fifo_mem_re)
        ,.mem_raddr           (rf_uno_atm_cmp_fifo_mem_raddr)
        ,.mem_waddr           (rf_uno_atm_cmp_fifo_mem_waddr)
        ,.mem_we              (rf_uno_atm_cmp_fifo_mem_we)
        ,.mem_wdata           (rf_uno_atm_cmp_fifo_mem_wdata)
        ,.mem_rdata           (rf_uno_atm_cmp_fifo_mem_rdata)

        ,.mem_rdata_error     (rf_uno_atm_cmp_fifo_mem_rdata_error)
        ,.error               (rf_uno_atm_cmp_fifo_mem_error)
);

assign hqm_list_sel_pipe_rfw_top_ipar_error = rf_aqed_lsp_deq_fifo_mem_rdata_error | rf_atm_cmp_fifo_mem_rdata_error | rf_cfg_atm_qid_dpth_thrsh_mem_rdata_error | rf_cfg_cq2priov_mem_rdata_error | rf_cfg_cq2priov_odd_mem_rdata_error | rf_cfg_cq2qid_0_mem_rdata_error | rf_cfg_cq2qid_0_odd_mem_rdata_error | rf_cfg_cq2qid_1_mem_rdata_error | rf_cfg_cq2qid_1_odd_mem_rdata_error | rf_cfg_cq_ldb_inflight_limit_mem_rdata_error | rf_cfg_cq_ldb_inflight_threshold_mem_rdata_error | rf_cfg_cq_ldb_token_depth_select_mem_rdata_error | rf_cfg_cq_ldb_wu_limit_mem_rdata_error | rf_cfg_dir_qid_dpth_thrsh_mem_rdata_error | rf_cfg_nalb_qid_dpth_thrsh_mem_rdata_error | rf_cfg_qid_aqed_active_limit_mem_rdata_error | rf_cfg_qid_ldb_inflight_limit_mem_rdata_error | rf_cfg_qid_ldb_qid2cqidix2_mem_rdata_error | rf_cfg_qid_ldb_qid2cqidix_mem_rdata_error | rf_chp_lsp_cmp_rx_sync_fifo_mem_rdata_error | rf_chp_lsp_token_rx_sync_fifo_mem_rdata_error | rf_cq_atm_pri_arbindex_mem_rdata_error | rf_cq_dir_tot_sch_cnt_mem_rdata_error | rf_cq_ldb_inflight_count_mem_rdata_error | rf_cq_ldb_token_count_mem_rdata_error | rf_cq_ldb_tot_sch_cnt_mem_rdata_error | rf_cq_ldb_wu_count_mem_rdata_error | rf_cq_nalb_pri_arbindex_mem_rdata_error | rf_dir_enq_cnt_mem_rdata_error | rf_dir_tok_cnt_mem_rdata_error | rf_dir_tok_lim_mem_rdata_error | rf_dp_lsp_enq_dir_rx_sync_fifo_mem_rdata_error | rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_rdata_error | rf_enq_nalb_fifo_mem_rdata_error | rf_ldb_token_rtn_fifo_mem_rdata_error | rf_nalb_cmp_fifo_mem_rdata_error | rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_rdata_error | rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_rdata_error | rf_nalb_sel_nalb_fifo_mem_rdata_error | rf_qed_lsp_deq_fifo_mem_rdata_error | rf_qid_aqed_active_count_mem_rdata_error | rf_qid_atm_active_mem_rdata_error | rf_qid_atm_tot_enq_cnt_mem_rdata_error | rf_qid_atq_enqueue_count_mem_rdata_error | rf_qid_dir_max_depth_mem_rdata_error | rf_qid_dir_replay_count_mem_rdata_error | rf_qid_dir_tot_enq_cnt_mem_rdata_error | rf_qid_ldb_enqueue_count_mem_rdata_error | rf_qid_ldb_inflight_count_mem_rdata_error | rf_qid_ldb_replay_count_mem_rdata_error | rf_qid_naldb_max_depth_mem_rdata_error | rf_qid_naldb_tot_enq_cnt_mem_rdata_error | rf_rop_lsp_reordercmp_rx_sync_fifo_mem_rdata_error | rf_send_atm_to_cq_rx_sync_fifo_mem_rdata_error | rf_uno_atm_cmp_fifo_mem_rdata_error ;

endmodule

