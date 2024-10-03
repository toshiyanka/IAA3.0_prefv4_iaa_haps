module hqm_lsp_atm_pipe_ram_access
     import hqm_AW_pkg::* , hqm_pkg::* , hqm_core_pkg::*;
(
     input  logic                  hqm_gated_clk

    ,input  logic                  hqm_gated_rst_n

    ,input  logic [(  2 *  1)-1:0] cfg_mem_re          // lintra s-0527
    ,input  logic [(  2 *  1)-1:0] cfg_mem_we          // lintra s-0527
    ,input  logic [(      20)-1:0] cfg_mem_addr        // lintra s-0527
    ,input  logic [(      12)-1:0] cfg_mem_minbit      // lintra s-0527
    ,input  logic [(      12)-1:0] cfg_mem_maxbit      // lintra s-0527
    ,input  logic [(      32)-1:0] cfg_mem_wdata       // lintra s-0527
    ,output logic [(  2 * 32)-1:0] cfg_mem_rdata
    ,output logic [(  2 *  1)-1:0] cfg_mem_ack
    ,input  logic                  cfg_mem_cc_v        // lintra s-0527
    ,input  logic [(       8)-1:0] cfg_mem_cc_value    // lintra s-0527
    ,input  logic [(       4)-1:0] cfg_mem_cc_width    // lintra s-0527
    ,input  logic [(      12)-1:0] cfg_mem_cc_position // lintra s-0527

    ,output logic                  hqm_lsp_atm_pipe_rfw_top_ipar_error

    ,input  logic                  func_aqed_qid2cqidix_re
    ,input  logic [(       7)-1:0] func_aqed_qid2cqidix_addr
    ,input  logic                  func_aqed_qid2cqidix_we
    ,input  logic [(     528)-1:0] func_aqed_qid2cqidix_wdata
    ,output logic [(     528)-1:0] func_aqed_qid2cqidix_rdata

    ,input  logic                  pf_aqed_qid2cqidix_re
    ,input  logic [(       7)-1:0] pf_aqed_qid2cqidix_addr
    ,input  logic                  pf_aqed_qid2cqidix_we
    ,input  logic [(     528)-1:0] pf_aqed_qid2cqidix_wdata
    ,output logic [(     528)-1:0] pf_aqed_qid2cqidix_rdata

    ,output logic                  rf_aqed_qid2cqidix_re
    ,output logic                  rf_aqed_qid2cqidix_rclk
    ,output logic                  rf_aqed_qid2cqidix_rclk_rst_n
    ,output logic [(       5)-1:0] rf_aqed_qid2cqidix_raddr
    ,output logic [(       5)-1:0] rf_aqed_qid2cqidix_waddr
    ,output logic                  rf_aqed_qid2cqidix_we
    ,output logic                  rf_aqed_qid2cqidix_wclk
    ,output logic                  rf_aqed_qid2cqidix_wclk_rst_n
    ,output logic [(     528)-1:0] rf_aqed_qid2cqidix_wdata
    ,input  logic [(     528)-1:0] rf_aqed_qid2cqidix_rdata

    ,output logic                  rf_aqed_qid2cqidix_error

    ,input  logic                  func_atm_fifo_ap_aqed_re
    ,input  logic [(       4)-1:0] func_atm_fifo_ap_aqed_raddr
    ,input  logic [(       4)-1:0] func_atm_fifo_ap_aqed_waddr
    ,input  logic                  func_atm_fifo_ap_aqed_we
    ,input  logic [(      45)-1:0] func_atm_fifo_ap_aqed_wdata
    ,output logic [(      45)-1:0] func_atm_fifo_ap_aqed_rdata

    ,input  logic                  pf_atm_fifo_ap_aqed_re
    ,input  logic [(       4)-1:0] pf_atm_fifo_ap_aqed_raddr
    ,input  logic [(       4)-1:0] pf_atm_fifo_ap_aqed_waddr
    ,input  logic                  pf_atm_fifo_ap_aqed_we
    ,input  logic [(      45)-1:0] pf_atm_fifo_ap_aqed_wdata
    ,output logic [(      45)-1:0] pf_atm_fifo_ap_aqed_rdata

    ,output logic                  rf_atm_fifo_ap_aqed_re
    ,output logic                  rf_atm_fifo_ap_aqed_rclk
    ,output logic                  rf_atm_fifo_ap_aqed_rclk_rst_n
    ,output logic [(       4)-1:0] rf_atm_fifo_ap_aqed_raddr
    ,output logic [(       4)-1:0] rf_atm_fifo_ap_aqed_waddr
    ,output logic                  rf_atm_fifo_ap_aqed_we
    ,output logic                  rf_atm_fifo_ap_aqed_wclk
    ,output logic                  rf_atm_fifo_ap_aqed_wclk_rst_n
    ,output logic [(      45)-1:0] rf_atm_fifo_ap_aqed_wdata
    ,input  logic [(      45)-1:0] rf_atm_fifo_ap_aqed_rdata

    ,output logic                  rf_atm_fifo_ap_aqed_error

    ,input  logic                  func_atm_fifo_aqed_ap_enq_re
    ,input  logic [(       5)-1:0] func_atm_fifo_aqed_ap_enq_raddr
    ,input  logic [(       5)-1:0] func_atm_fifo_aqed_ap_enq_waddr
    ,input  logic                  func_atm_fifo_aqed_ap_enq_we
    ,input  logic [(      24)-1:0] func_atm_fifo_aqed_ap_enq_wdata
    ,output logic [(      24)-1:0] func_atm_fifo_aqed_ap_enq_rdata

    ,input  logic                  pf_atm_fifo_aqed_ap_enq_re
    ,input  logic [(       5)-1:0] pf_atm_fifo_aqed_ap_enq_raddr
    ,input  logic [(       5)-1:0] pf_atm_fifo_aqed_ap_enq_waddr
    ,input  logic                  pf_atm_fifo_aqed_ap_enq_we
    ,input  logic [(      24)-1:0] pf_atm_fifo_aqed_ap_enq_wdata
    ,output logic [(      24)-1:0] pf_atm_fifo_aqed_ap_enq_rdata

    ,output logic                  rf_atm_fifo_aqed_ap_enq_re
    ,output logic                  rf_atm_fifo_aqed_ap_enq_rclk
    ,output logic                  rf_atm_fifo_aqed_ap_enq_rclk_rst_n
    ,output logic [(       5)-1:0] rf_atm_fifo_aqed_ap_enq_raddr
    ,output logic [(       5)-1:0] rf_atm_fifo_aqed_ap_enq_waddr
    ,output logic                  rf_atm_fifo_aqed_ap_enq_we
    ,output logic                  rf_atm_fifo_aqed_ap_enq_wclk
    ,output logic                  rf_atm_fifo_aqed_ap_enq_wclk_rst_n
    ,output logic [(      24)-1:0] rf_atm_fifo_aqed_ap_enq_wdata
    ,input  logic [(      24)-1:0] rf_atm_fifo_aqed_ap_enq_rdata

    ,output logic                  rf_atm_fifo_aqed_ap_enq_error

    ,input  logic                  func_fid2cqqidix_re
    ,input  logic [(      12)-1:0] func_fid2cqqidix_raddr
    ,input  logic [(      12)-1:0] func_fid2cqqidix_waddr
    ,input  logic                  func_fid2cqqidix_we
    ,input  logic [(      10)-1:0] func_fid2cqqidix_wdata
    ,output logic [(      10)-1:0] func_fid2cqqidix_rdata

    ,input  logic                  pf_fid2cqqidix_re
    ,input  logic [(      12)-1:0] pf_fid2cqqidix_raddr
    ,input  logic [(      12)-1:0] pf_fid2cqqidix_waddr
    ,input  logic                  pf_fid2cqqidix_we
    ,input  logic [(      10)-1:0] pf_fid2cqqidix_wdata
    ,output logic [(      10)-1:0] pf_fid2cqqidix_rdata

    ,output logic                  rf_fid2cqqidix_re
    ,output logic                  rf_fid2cqqidix_rclk
    ,output logic                  rf_fid2cqqidix_rclk_rst_n
    ,output logic [(      11)-1:0] rf_fid2cqqidix_raddr
    ,output logic [(      11)-1:0] rf_fid2cqqidix_waddr
    ,output logic                  rf_fid2cqqidix_we
    ,output logic                  rf_fid2cqqidix_wclk
    ,output logic                  rf_fid2cqqidix_wclk_rst_n
    ,output logic [(      12)-1:0] rf_fid2cqqidix_wdata
    ,input  logic [(      12)-1:0] rf_fid2cqqidix_rdata

    ,output logic                  rf_fid2cqqidix_error

    ,input  logic                  func_ll_enq_cnt_r_bin0_dup0_re
    ,input  logic [(      12)-1:0] func_ll_enq_cnt_r_bin0_dup0_raddr
    ,input  logic [(      12)-1:0] func_ll_enq_cnt_r_bin0_dup0_waddr
    ,input  logic                  func_ll_enq_cnt_r_bin0_dup0_we
    ,input  logic [(      14)-1:0] func_ll_enq_cnt_r_bin0_dup0_wdata
    ,output logic [(      14)-1:0] func_ll_enq_cnt_r_bin0_dup0_rdata

    ,input  logic                  pf_ll_enq_cnt_r_bin0_dup0_re
    ,input  logic [(      12)-1:0] pf_ll_enq_cnt_r_bin0_dup0_raddr
    ,input  logic [(      12)-1:0] pf_ll_enq_cnt_r_bin0_dup0_waddr
    ,input  logic                  pf_ll_enq_cnt_r_bin0_dup0_we
    ,input  logic [(      14)-1:0] pf_ll_enq_cnt_r_bin0_dup0_wdata
    ,output logic [(      14)-1:0] pf_ll_enq_cnt_r_bin0_dup0_rdata

    ,output logic                  rf_ll_enq_cnt_r_bin0_dup0_re
    ,output logic                  rf_ll_enq_cnt_r_bin0_dup0_rclk
    ,output logic                  rf_ll_enq_cnt_r_bin0_dup0_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin0_dup0_raddr
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin0_dup0_waddr
    ,output logic                  rf_ll_enq_cnt_r_bin0_dup0_we
    ,output logic                  rf_ll_enq_cnt_r_bin0_dup0_wclk
    ,output logic                  rf_ll_enq_cnt_r_bin0_dup0_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_enq_cnt_r_bin0_dup0_wdata
    ,input  logic [(      16)-1:0] rf_ll_enq_cnt_r_bin0_dup0_rdata

    ,output logic                  rf_ll_enq_cnt_r_bin0_dup0_error

    ,input  logic                  func_ll_enq_cnt_r_bin0_dup1_re
    ,input  logic [(      12)-1:0] func_ll_enq_cnt_r_bin0_dup1_raddr
    ,input  logic [(      12)-1:0] func_ll_enq_cnt_r_bin0_dup1_waddr
    ,input  logic                  func_ll_enq_cnt_r_bin0_dup1_we
    ,input  logic [(      14)-1:0] func_ll_enq_cnt_r_bin0_dup1_wdata
    ,output logic [(      14)-1:0] func_ll_enq_cnt_r_bin0_dup1_rdata

    ,input  logic                  pf_ll_enq_cnt_r_bin0_dup1_re
    ,input  logic [(      12)-1:0] pf_ll_enq_cnt_r_bin0_dup1_raddr
    ,input  logic [(      12)-1:0] pf_ll_enq_cnt_r_bin0_dup1_waddr
    ,input  logic                  pf_ll_enq_cnt_r_bin0_dup1_we
    ,input  logic [(      14)-1:0] pf_ll_enq_cnt_r_bin0_dup1_wdata
    ,output logic [(      14)-1:0] pf_ll_enq_cnt_r_bin0_dup1_rdata

    ,output logic                  rf_ll_enq_cnt_r_bin0_dup1_re
    ,output logic                  rf_ll_enq_cnt_r_bin0_dup1_rclk
    ,output logic                  rf_ll_enq_cnt_r_bin0_dup1_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin0_dup1_raddr
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin0_dup1_waddr
    ,output logic                  rf_ll_enq_cnt_r_bin0_dup1_we
    ,output logic                  rf_ll_enq_cnt_r_bin0_dup1_wclk
    ,output logic                  rf_ll_enq_cnt_r_bin0_dup1_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_enq_cnt_r_bin0_dup1_wdata
    ,input  logic [(      16)-1:0] rf_ll_enq_cnt_r_bin0_dup1_rdata

    ,output logic                  rf_ll_enq_cnt_r_bin0_dup1_error

    ,input  logic                  func_ll_enq_cnt_r_bin0_dup2_re
    ,input  logic [(      12)-1:0] func_ll_enq_cnt_r_bin0_dup2_raddr
    ,input  logic [(      12)-1:0] func_ll_enq_cnt_r_bin0_dup2_waddr
    ,input  logic                  func_ll_enq_cnt_r_bin0_dup2_we
    ,input  logic [(      14)-1:0] func_ll_enq_cnt_r_bin0_dup2_wdata
    ,output logic [(      14)-1:0] func_ll_enq_cnt_r_bin0_dup2_rdata

    ,input  logic                  pf_ll_enq_cnt_r_bin0_dup2_re
    ,input  logic [(      12)-1:0] pf_ll_enq_cnt_r_bin0_dup2_raddr
    ,input  logic [(      12)-1:0] pf_ll_enq_cnt_r_bin0_dup2_waddr
    ,input  logic                  pf_ll_enq_cnt_r_bin0_dup2_we
    ,input  logic [(      14)-1:0] pf_ll_enq_cnt_r_bin0_dup2_wdata
    ,output logic [(      14)-1:0] pf_ll_enq_cnt_r_bin0_dup2_rdata

    ,output logic                  rf_ll_enq_cnt_r_bin0_dup2_re
    ,output logic                  rf_ll_enq_cnt_r_bin0_dup2_rclk
    ,output logic                  rf_ll_enq_cnt_r_bin0_dup2_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin0_dup2_raddr
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin0_dup2_waddr
    ,output logic                  rf_ll_enq_cnt_r_bin0_dup2_we
    ,output logic                  rf_ll_enq_cnt_r_bin0_dup2_wclk
    ,output logic                  rf_ll_enq_cnt_r_bin0_dup2_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_enq_cnt_r_bin0_dup2_wdata
    ,input  logic [(      16)-1:0] rf_ll_enq_cnt_r_bin0_dup2_rdata

    ,output logic                  rf_ll_enq_cnt_r_bin0_dup2_error

    ,input  logic                  func_ll_enq_cnt_r_bin0_dup3_re
    ,input  logic [(      12)-1:0] func_ll_enq_cnt_r_bin0_dup3_raddr
    ,input  logic [(      12)-1:0] func_ll_enq_cnt_r_bin0_dup3_waddr
    ,input  logic                  func_ll_enq_cnt_r_bin0_dup3_we
    ,input  logic [(      14)-1:0] func_ll_enq_cnt_r_bin0_dup3_wdata
    ,output logic [(      14)-1:0] func_ll_enq_cnt_r_bin0_dup3_rdata

    ,input  logic                  pf_ll_enq_cnt_r_bin0_dup3_re
    ,input  logic [(      12)-1:0] pf_ll_enq_cnt_r_bin0_dup3_raddr
    ,input  logic [(      12)-1:0] pf_ll_enq_cnt_r_bin0_dup3_waddr
    ,input  logic                  pf_ll_enq_cnt_r_bin0_dup3_we
    ,input  logic [(      14)-1:0] pf_ll_enq_cnt_r_bin0_dup3_wdata
    ,output logic [(      14)-1:0] pf_ll_enq_cnt_r_bin0_dup3_rdata

    ,output logic                  rf_ll_enq_cnt_r_bin0_dup3_re
    ,output logic                  rf_ll_enq_cnt_r_bin0_dup3_rclk
    ,output logic                  rf_ll_enq_cnt_r_bin0_dup3_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin0_dup3_raddr
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin0_dup3_waddr
    ,output logic                  rf_ll_enq_cnt_r_bin0_dup3_we
    ,output logic                  rf_ll_enq_cnt_r_bin0_dup3_wclk
    ,output logic                  rf_ll_enq_cnt_r_bin0_dup3_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_enq_cnt_r_bin0_dup3_wdata
    ,input  logic [(      16)-1:0] rf_ll_enq_cnt_r_bin0_dup3_rdata

    ,output logic                  rf_ll_enq_cnt_r_bin0_dup3_error

    ,input  logic                  func_ll_enq_cnt_r_bin1_dup0_re
    ,input  logic [(      12)-1:0] func_ll_enq_cnt_r_bin1_dup0_raddr
    ,input  logic [(      12)-1:0] func_ll_enq_cnt_r_bin1_dup0_waddr
    ,input  logic                  func_ll_enq_cnt_r_bin1_dup0_we
    ,input  logic [(      14)-1:0] func_ll_enq_cnt_r_bin1_dup0_wdata
    ,output logic [(      14)-1:0] func_ll_enq_cnt_r_bin1_dup0_rdata

    ,input  logic                  pf_ll_enq_cnt_r_bin1_dup0_re
    ,input  logic [(      12)-1:0] pf_ll_enq_cnt_r_bin1_dup0_raddr
    ,input  logic [(      12)-1:0] pf_ll_enq_cnt_r_bin1_dup0_waddr
    ,input  logic                  pf_ll_enq_cnt_r_bin1_dup0_we
    ,input  logic [(      14)-1:0] pf_ll_enq_cnt_r_bin1_dup0_wdata
    ,output logic [(      14)-1:0] pf_ll_enq_cnt_r_bin1_dup0_rdata

    ,output logic                  rf_ll_enq_cnt_r_bin1_dup0_re
    ,output logic                  rf_ll_enq_cnt_r_bin1_dup0_rclk
    ,output logic                  rf_ll_enq_cnt_r_bin1_dup0_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin1_dup0_raddr
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin1_dup0_waddr
    ,output logic                  rf_ll_enq_cnt_r_bin1_dup0_we
    ,output logic                  rf_ll_enq_cnt_r_bin1_dup0_wclk
    ,output logic                  rf_ll_enq_cnt_r_bin1_dup0_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_enq_cnt_r_bin1_dup0_wdata
    ,input  logic [(      16)-1:0] rf_ll_enq_cnt_r_bin1_dup0_rdata

    ,output logic                  rf_ll_enq_cnt_r_bin1_dup0_error

    ,input  logic                  func_ll_enq_cnt_r_bin1_dup1_re
    ,input  logic [(      12)-1:0] func_ll_enq_cnt_r_bin1_dup1_raddr
    ,input  logic [(      12)-1:0] func_ll_enq_cnt_r_bin1_dup1_waddr
    ,input  logic                  func_ll_enq_cnt_r_bin1_dup1_we
    ,input  logic [(      14)-1:0] func_ll_enq_cnt_r_bin1_dup1_wdata
    ,output logic [(      14)-1:0] func_ll_enq_cnt_r_bin1_dup1_rdata

    ,input  logic                  pf_ll_enq_cnt_r_bin1_dup1_re
    ,input  logic [(      12)-1:0] pf_ll_enq_cnt_r_bin1_dup1_raddr
    ,input  logic [(      12)-1:0] pf_ll_enq_cnt_r_bin1_dup1_waddr
    ,input  logic                  pf_ll_enq_cnt_r_bin1_dup1_we
    ,input  logic [(      14)-1:0] pf_ll_enq_cnt_r_bin1_dup1_wdata
    ,output logic [(      14)-1:0] pf_ll_enq_cnt_r_bin1_dup1_rdata

    ,output logic                  rf_ll_enq_cnt_r_bin1_dup1_re
    ,output logic                  rf_ll_enq_cnt_r_bin1_dup1_rclk
    ,output logic                  rf_ll_enq_cnt_r_bin1_dup1_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin1_dup1_raddr
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin1_dup1_waddr
    ,output logic                  rf_ll_enq_cnt_r_bin1_dup1_we
    ,output logic                  rf_ll_enq_cnt_r_bin1_dup1_wclk
    ,output logic                  rf_ll_enq_cnt_r_bin1_dup1_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_enq_cnt_r_bin1_dup1_wdata
    ,input  logic [(      16)-1:0] rf_ll_enq_cnt_r_bin1_dup1_rdata

    ,output logic                  rf_ll_enq_cnt_r_bin1_dup1_error

    ,input  logic                  func_ll_enq_cnt_r_bin1_dup2_re
    ,input  logic [(      12)-1:0] func_ll_enq_cnt_r_bin1_dup2_raddr
    ,input  logic [(      12)-1:0] func_ll_enq_cnt_r_bin1_dup2_waddr
    ,input  logic                  func_ll_enq_cnt_r_bin1_dup2_we
    ,input  logic [(      14)-1:0] func_ll_enq_cnt_r_bin1_dup2_wdata
    ,output logic [(      14)-1:0] func_ll_enq_cnt_r_bin1_dup2_rdata

    ,input  logic                  pf_ll_enq_cnt_r_bin1_dup2_re
    ,input  logic [(      12)-1:0] pf_ll_enq_cnt_r_bin1_dup2_raddr
    ,input  logic [(      12)-1:0] pf_ll_enq_cnt_r_bin1_dup2_waddr
    ,input  logic                  pf_ll_enq_cnt_r_bin1_dup2_we
    ,input  logic [(      14)-1:0] pf_ll_enq_cnt_r_bin1_dup2_wdata
    ,output logic [(      14)-1:0] pf_ll_enq_cnt_r_bin1_dup2_rdata

    ,output logic                  rf_ll_enq_cnt_r_bin1_dup2_re
    ,output logic                  rf_ll_enq_cnt_r_bin1_dup2_rclk
    ,output logic                  rf_ll_enq_cnt_r_bin1_dup2_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin1_dup2_raddr
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin1_dup2_waddr
    ,output logic                  rf_ll_enq_cnt_r_bin1_dup2_we
    ,output logic                  rf_ll_enq_cnt_r_bin1_dup2_wclk
    ,output logic                  rf_ll_enq_cnt_r_bin1_dup2_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_enq_cnt_r_bin1_dup2_wdata
    ,input  logic [(      16)-1:0] rf_ll_enq_cnt_r_bin1_dup2_rdata

    ,output logic                  rf_ll_enq_cnt_r_bin1_dup2_error

    ,input  logic                  func_ll_enq_cnt_r_bin1_dup3_re
    ,input  logic [(      12)-1:0] func_ll_enq_cnt_r_bin1_dup3_raddr
    ,input  logic [(      12)-1:0] func_ll_enq_cnt_r_bin1_dup3_waddr
    ,input  logic                  func_ll_enq_cnt_r_bin1_dup3_we
    ,input  logic [(      14)-1:0] func_ll_enq_cnt_r_bin1_dup3_wdata
    ,output logic [(      14)-1:0] func_ll_enq_cnt_r_bin1_dup3_rdata

    ,input  logic                  pf_ll_enq_cnt_r_bin1_dup3_re
    ,input  logic [(      12)-1:0] pf_ll_enq_cnt_r_bin1_dup3_raddr
    ,input  logic [(      12)-1:0] pf_ll_enq_cnt_r_bin1_dup3_waddr
    ,input  logic                  pf_ll_enq_cnt_r_bin1_dup3_we
    ,input  logic [(      14)-1:0] pf_ll_enq_cnt_r_bin1_dup3_wdata
    ,output logic [(      14)-1:0] pf_ll_enq_cnt_r_bin1_dup3_rdata

    ,output logic                  rf_ll_enq_cnt_r_bin1_dup3_re
    ,output logic                  rf_ll_enq_cnt_r_bin1_dup3_rclk
    ,output logic                  rf_ll_enq_cnt_r_bin1_dup3_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin1_dup3_raddr
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin1_dup3_waddr
    ,output logic                  rf_ll_enq_cnt_r_bin1_dup3_we
    ,output logic                  rf_ll_enq_cnt_r_bin1_dup3_wclk
    ,output logic                  rf_ll_enq_cnt_r_bin1_dup3_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_enq_cnt_r_bin1_dup3_wdata
    ,input  logic [(      16)-1:0] rf_ll_enq_cnt_r_bin1_dup3_rdata

    ,output logic                  rf_ll_enq_cnt_r_bin1_dup3_error

    ,input  logic                  func_ll_enq_cnt_r_bin2_dup0_re
    ,input  logic [(      12)-1:0] func_ll_enq_cnt_r_bin2_dup0_raddr
    ,input  logic [(      12)-1:0] func_ll_enq_cnt_r_bin2_dup0_waddr
    ,input  logic                  func_ll_enq_cnt_r_bin2_dup0_we
    ,input  logic [(      14)-1:0] func_ll_enq_cnt_r_bin2_dup0_wdata
    ,output logic [(      14)-1:0] func_ll_enq_cnt_r_bin2_dup0_rdata

    ,input  logic                  pf_ll_enq_cnt_r_bin2_dup0_re
    ,input  logic [(      12)-1:0] pf_ll_enq_cnt_r_bin2_dup0_raddr
    ,input  logic [(      12)-1:0] pf_ll_enq_cnt_r_bin2_dup0_waddr
    ,input  logic                  pf_ll_enq_cnt_r_bin2_dup0_we
    ,input  logic [(      14)-1:0] pf_ll_enq_cnt_r_bin2_dup0_wdata
    ,output logic [(      14)-1:0] pf_ll_enq_cnt_r_bin2_dup0_rdata

    ,output logic                  rf_ll_enq_cnt_r_bin2_dup0_re
    ,output logic                  rf_ll_enq_cnt_r_bin2_dup0_rclk
    ,output logic                  rf_ll_enq_cnt_r_bin2_dup0_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin2_dup0_raddr
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin2_dup0_waddr
    ,output logic                  rf_ll_enq_cnt_r_bin2_dup0_we
    ,output logic                  rf_ll_enq_cnt_r_bin2_dup0_wclk
    ,output logic                  rf_ll_enq_cnt_r_bin2_dup0_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_enq_cnt_r_bin2_dup0_wdata
    ,input  logic [(      16)-1:0] rf_ll_enq_cnt_r_bin2_dup0_rdata

    ,output logic                  rf_ll_enq_cnt_r_bin2_dup0_error

    ,input  logic                  func_ll_enq_cnt_r_bin2_dup1_re
    ,input  logic [(      12)-1:0] func_ll_enq_cnt_r_bin2_dup1_raddr
    ,input  logic [(      12)-1:0] func_ll_enq_cnt_r_bin2_dup1_waddr
    ,input  logic                  func_ll_enq_cnt_r_bin2_dup1_we
    ,input  logic [(      14)-1:0] func_ll_enq_cnt_r_bin2_dup1_wdata
    ,output logic [(      14)-1:0] func_ll_enq_cnt_r_bin2_dup1_rdata

    ,input  logic                  pf_ll_enq_cnt_r_bin2_dup1_re
    ,input  logic [(      12)-1:0] pf_ll_enq_cnt_r_bin2_dup1_raddr
    ,input  logic [(      12)-1:0] pf_ll_enq_cnt_r_bin2_dup1_waddr
    ,input  logic                  pf_ll_enq_cnt_r_bin2_dup1_we
    ,input  logic [(      14)-1:0] pf_ll_enq_cnt_r_bin2_dup1_wdata
    ,output logic [(      14)-1:0] pf_ll_enq_cnt_r_bin2_dup1_rdata

    ,output logic                  rf_ll_enq_cnt_r_bin2_dup1_re
    ,output logic                  rf_ll_enq_cnt_r_bin2_dup1_rclk
    ,output logic                  rf_ll_enq_cnt_r_bin2_dup1_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin2_dup1_raddr
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin2_dup1_waddr
    ,output logic                  rf_ll_enq_cnt_r_bin2_dup1_we
    ,output logic                  rf_ll_enq_cnt_r_bin2_dup1_wclk
    ,output logic                  rf_ll_enq_cnt_r_bin2_dup1_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_enq_cnt_r_bin2_dup1_wdata
    ,input  logic [(      16)-1:0] rf_ll_enq_cnt_r_bin2_dup1_rdata

    ,output logic                  rf_ll_enq_cnt_r_bin2_dup1_error

    ,input  logic                  func_ll_enq_cnt_r_bin2_dup2_re
    ,input  logic [(      12)-1:0] func_ll_enq_cnt_r_bin2_dup2_raddr
    ,input  logic [(      12)-1:0] func_ll_enq_cnt_r_bin2_dup2_waddr
    ,input  logic                  func_ll_enq_cnt_r_bin2_dup2_we
    ,input  logic [(      14)-1:0] func_ll_enq_cnt_r_bin2_dup2_wdata
    ,output logic [(      14)-1:0] func_ll_enq_cnt_r_bin2_dup2_rdata

    ,input  logic                  pf_ll_enq_cnt_r_bin2_dup2_re
    ,input  logic [(      12)-1:0] pf_ll_enq_cnt_r_bin2_dup2_raddr
    ,input  logic [(      12)-1:0] pf_ll_enq_cnt_r_bin2_dup2_waddr
    ,input  logic                  pf_ll_enq_cnt_r_bin2_dup2_we
    ,input  logic [(      14)-1:0] pf_ll_enq_cnt_r_bin2_dup2_wdata
    ,output logic [(      14)-1:0] pf_ll_enq_cnt_r_bin2_dup2_rdata

    ,output logic                  rf_ll_enq_cnt_r_bin2_dup2_re
    ,output logic                  rf_ll_enq_cnt_r_bin2_dup2_rclk
    ,output logic                  rf_ll_enq_cnt_r_bin2_dup2_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin2_dup2_raddr
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin2_dup2_waddr
    ,output logic                  rf_ll_enq_cnt_r_bin2_dup2_we
    ,output logic                  rf_ll_enq_cnt_r_bin2_dup2_wclk
    ,output logic                  rf_ll_enq_cnt_r_bin2_dup2_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_enq_cnt_r_bin2_dup2_wdata
    ,input  logic [(      16)-1:0] rf_ll_enq_cnt_r_bin2_dup2_rdata

    ,output logic                  rf_ll_enq_cnt_r_bin2_dup2_error

    ,input  logic                  func_ll_enq_cnt_r_bin2_dup3_re
    ,input  logic [(      12)-1:0] func_ll_enq_cnt_r_bin2_dup3_raddr
    ,input  logic [(      12)-1:0] func_ll_enq_cnt_r_bin2_dup3_waddr
    ,input  logic                  func_ll_enq_cnt_r_bin2_dup3_we
    ,input  logic [(      14)-1:0] func_ll_enq_cnt_r_bin2_dup3_wdata
    ,output logic [(      14)-1:0] func_ll_enq_cnt_r_bin2_dup3_rdata

    ,input  logic                  pf_ll_enq_cnt_r_bin2_dup3_re
    ,input  logic [(      12)-1:0] pf_ll_enq_cnt_r_bin2_dup3_raddr
    ,input  logic [(      12)-1:0] pf_ll_enq_cnt_r_bin2_dup3_waddr
    ,input  logic                  pf_ll_enq_cnt_r_bin2_dup3_we
    ,input  logic [(      14)-1:0] pf_ll_enq_cnt_r_bin2_dup3_wdata
    ,output logic [(      14)-1:0] pf_ll_enq_cnt_r_bin2_dup3_rdata

    ,output logic                  rf_ll_enq_cnt_r_bin2_dup3_re
    ,output logic                  rf_ll_enq_cnt_r_bin2_dup3_rclk
    ,output logic                  rf_ll_enq_cnt_r_bin2_dup3_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin2_dup3_raddr
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin2_dup3_waddr
    ,output logic                  rf_ll_enq_cnt_r_bin2_dup3_we
    ,output logic                  rf_ll_enq_cnt_r_bin2_dup3_wclk
    ,output logic                  rf_ll_enq_cnt_r_bin2_dup3_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_enq_cnt_r_bin2_dup3_wdata
    ,input  logic [(      16)-1:0] rf_ll_enq_cnt_r_bin2_dup3_rdata

    ,output logic                  rf_ll_enq_cnt_r_bin2_dup3_error

    ,input  logic                  func_ll_enq_cnt_r_bin3_dup0_re
    ,input  logic [(      12)-1:0] func_ll_enq_cnt_r_bin3_dup0_raddr
    ,input  logic [(      12)-1:0] func_ll_enq_cnt_r_bin3_dup0_waddr
    ,input  logic                  func_ll_enq_cnt_r_bin3_dup0_we
    ,input  logic [(      14)-1:0] func_ll_enq_cnt_r_bin3_dup0_wdata
    ,output logic [(      14)-1:0] func_ll_enq_cnt_r_bin3_dup0_rdata

    ,input  logic                  pf_ll_enq_cnt_r_bin3_dup0_re
    ,input  logic [(      12)-1:0] pf_ll_enq_cnt_r_bin3_dup0_raddr
    ,input  logic [(      12)-1:0] pf_ll_enq_cnt_r_bin3_dup0_waddr
    ,input  logic                  pf_ll_enq_cnt_r_bin3_dup0_we
    ,input  logic [(      14)-1:0] pf_ll_enq_cnt_r_bin3_dup0_wdata
    ,output logic [(      14)-1:0] pf_ll_enq_cnt_r_bin3_dup0_rdata

    ,output logic                  rf_ll_enq_cnt_r_bin3_dup0_re
    ,output logic                  rf_ll_enq_cnt_r_bin3_dup0_rclk
    ,output logic                  rf_ll_enq_cnt_r_bin3_dup0_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin3_dup0_raddr
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin3_dup0_waddr
    ,output logic                  rf_ll_enq_cnt_r_bin3_dup0_we
    ,output logic                  rf_ll_enq_cnt_r_bin3_dup0_wclk
    ,output logic                  rf_ll_enq_cnt_r_bin3_dup0_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_enq_cnt_r_bin3_dup0_wdata
    ,input  logic [(      16)-1:0] rf_ll_enq_cnt_r_bin3_dup0_rdata

    ,output logic                  rf_ll_enq_cnt_r_bin3_dup0_error

    ,input  logic                  func_ll_enq_cnt_r_bin3_dup1_re
    ,input  logic [(      12)-1:0] func_ll_enq_cnt_r_bin3_dup1_raddr
    ,input  logic [(      12)-1:0] func_ll_enq_cnt_r_bin3_dup1_waddr
    ,input  logic                  func_ll_enq_cnt_r_bin3_dup1_we
    ,input  logic [(      14)-1:0] func_ll_enq_cnt_r_bin3_dup1_wdata
    ,output logic [(      14)-1:0] func_ll_enq_cnt_r_bin3_dup1_rdata

    ,input  logic                  pf_ll_enq_cnt_r_bin3_dup1_re
    ,input  logic [(      12)-1:0] pf_ll_enq_cnt_r_bin3_dup1_raddr
    ,input  logic [(      12)-1:0] pf_ll_enq_cnt_r_bin3_dup1_waddr
    ,input  logic                  pf_ll_enq_cnt_r_bin3_dup1_we
    ,input  logic [(      14)-1:0] pf_ll_enq_cnt_r_bin3_dup1_wdata
    ,output logic [(      14)-1:0] pf_ll_enq_cnt_r_bin3_dup1_rdata

    ,output logic                  rf_ll_enq_cnt_r_bin3_dup1_re
    ,output logic                  rf_ll_enq_cnt_r_bin3_dup1_rclk
    ,output logic                  rf_ll_enq_cnt_r_bin3_dup1_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin3_dup1_raddr
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin3_dup1_waddr
    ,output logic                  rf_ll_enq_cnt_r_bin3_dup1_we
    ,output logic                  rf_ll_enq_cnt_r_bin3_dup1_wclk
    ,output logic                  rf_ll_enq_cnt_r_bin3_dup1_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_enq_cnt_r_bin3_dup1_wdata
    ,input  logic [(      16)-1:0] rf_ll_enq_cnt_r_bin3_dup1_rdata

    ,output logic                  rf_ll_enq_cnt_r_bin3_dup1_error

    ,input  logic                  func_ll_enq_cnt_r_bin3_dup2_re
    ,input  logic [(      12)-1:0] func_ll_enq_cnt_r_bin3_dup2_raddr
    ,input  logic [(      12)-1:0] func_ll_enq_cnt_r_bin3_dup2_waddr
    ,input  logic                  func_ll_enq_cnt_r_bin3_dup2_we
    ,input  logic [(      14)-1:0] func_ll_enq_cnt_r_bin3_dup2_wdata
    ,output logic [(      14)-1:0] func_ll_enq_cnt_r_bin3_dup2_rdata

    ,input  logic                  pf_ll_enq_cnt_r_bin3_dup2_re
    ,input  logic [(      12)-1:0] pf_ll_enq_cnt_r_bin3_dup2_raddr
    ,input  logic [(      12)-1:0] pf_ll_enq_cnt_r_bin3_dup2_waddr
    ,input  logic                  pf_ll_enq_cnt_r_bin3_dup2_we
    ,input  logic [(      14)-1:0] pf_ll_enq_cnt_r_bin3_dup2_wdata
    ,output logic [(      14)-1:0] pf_ll_enq_cnt_r_bin3_dup2_rdata

    ,output logic                  rf_ll_enq_cnt_r_bin3_dup2_re
    ,output logic                  rf_ll_enq_cnt_r_bin3_dup2_rclk
    ,output logic                  rf_ll_enq_cnt_r_bin3_dup2_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin3_dup2_raddr
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin3_dup2_waddr
    ,output logic                  rf_ll_enq_cnt_r_bin3_dup2_we
    ,output logic                  rf_ll_enq_cnt_r_bin3_dup2_wclk
    ,output logic                  rf_ll_enq_cnt_r_bin3_dup2_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_enq_cnt_r_bin3_dup2_wdata
    ,input  logic [(      16)-1:0] rf_ll_enq_cnt_r_bin3_dup2_rdata

    ,output logic                  rf_ll_enq_cnt_r_bin3_dup2_error

    ,input  logic                  func_ll_enq_cnt_r_bin3_dup3_re
    ,input  logic [(      12)-1:0] func_ll_enq_cnt_r_bin3_dup3_raddr
    ,input  logic [(      12)-1:0] func_ll_enq_cnt_r_bin3_dup3_waddr
    ,input  logic                  func_ll_enq_cnt_r_bin3_dup3_we
    ,input  logic [(      14)-1:0] func_ll_enq_cnt_r_bin3_dup3_wdata
    ,output logic [(      14)-1:0] func_ll_enq_cnt_r_bin3_dup3_rdata

    ,input  logic                  pf_ll_enq_cnt_r_bin3_dup3_re
    ,input  logic [(      12)-1:0] pf_ll_enq_cnt_r_bin3_dup3_raddr
    ,input  logic [(      12)-1:0] pf_ll_enq_cnt_r_bin3_dup3_waddr
    ,input  logic                  pf_ll_enq_cnt_r_bin3_dup3_we
    ,input  logic [(      14)-1:0] pf_ll_enq_cnt_r_bin3_dup3_wdata
    ,output logic [(      14)-1:0] pf_ll_enq_cnt_r_bin3_dup3_rdata

    ,output logic                  rf_ll_enq_cnt_r_bin3_dup3_re
    ,output logic                  rf_ll_enq_cnt_r_bin3_dup3_rclk
    ,output logic                  rf_ll_enq_cnt_r_bin3_dup3_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin3_dup3_raddr
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_r_bin3_dup3_waddr
    ,output logic                  rf_ll_enq_cnt_r_bin3_dup3_we
    ,output logic                  rf_ll_enq_cnt_r_bin3_dup3_wclk
    ,output logic                  rf_ll_enq_cnt_r_bin3_dup3_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_enq_cnt_r_bin3_dup3_wdata
    ,input  logic [(      16)-1:0] rf_ll_enq_cnt_r_bin3_dup3_rdata

    ,output logic                  rf_ll_enq_cnt_r_bin3_dup3_error

    ,input  logic                  func_ll_enq_cnt_s_bin0_re
    ,input  logic [(      12)-1:0] func_ll_enq_cnt_s_bin0_raddr
    ,input  logic [(      12)-1:0] func_ll_enq_cnt_s_bin0_waddr
    ,input  logic                  func_ll_enq_cnt_s_bin0_we
    ,input  logic [(      14)-1:0] func_ll_enq_cnt_s_bin0_wdata
    ,output logic [(      14)-1:0] func_ll_enq_cnt_s_bin0_rdata

    ,input  logic                  pf_ll_enq_cnt_s_bin0_re
    ,input  logic [(      12)-1:0] pf_ll_enq_cnt_s_bin0_raddr
    ,input  logic [(      12)-1:0] pf_ll_enq_cnt_s_bin0_waddr
    ,input  logic                  pf_ll_enq_cnt_s_bin0_we
    ,input  logic [(      14)-1:0] pf_ll_enq_cnt_s_bin0_wdata
    ,output logic [(      14)-1:0] pf_ll_enq_cnt_s_bin0_rdata

    ,output logic                  rf_ll_enq_cnt_s_bin0_re
    ,output logic                  rf_ll_enq_cnt_s_bin0_rclk
    ,output logic                  rf_ll_enq_cnt_s_bin0_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_s_bin0_raddr
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_s_bin0_waddr
    ,output logic                  rf_ll_enq_cnt_s_bin0_we
    ,output logic                  rf_ll_enq_cnt_s_bin0_wclk
    ,output logic                  rf_ll_enq_cnt_s_bin0_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_enq_cnt_s_bin0_wdata
    ,input  logic [(      16)-1:0] rf_ll_enq_cnt_s_bin0_rdata

    ,output logic                  rf_ll_enq_cnt_s_bin0_error

    ,input  logic                  func_ll_enq_cnt_s_bin1_re
    ,input  logic [(      12)-1:0] func_ll_enq_cnt_s_bin1_raddr
    ,input  logic [(      12)-1:0] func_ll_enq_cnt_s_bin1_waddr
    ,input  logic                  func_ll_enq_cnt_s_bin1_we
    ,input  logic [(      14)-1:0] func_ll_enq_cnt_s_bin1_wdata
    ,output logic [(      14)-1:0] func_ll_enq_cnt_s_bin1_rdata

    ,input  logic                  pf_ll_enq_cnt_s_bin1_re
    ,input  logic [(      12)-1:0] pf_ll_enq_cnt_s_bin1_raddr
    ,input  logic [(      12)-1:0] pf_ll_enq_cnt_s_bin1_waddr
    ,input  logic                  pf_ll_enq_cnt_s_bin1_we
    ,input  logic [(      14)-1:0] pf_ll_enq_cnt_s_bin1_wdata
    ,output logic [(      14)-1:0] pf_ll_enq_cnt_s_bin1_rdata

    ,output logic                  rf_ll_enq_cnt_s_bin1_re
    ,output logic                  rf_ll_enq_cnt_s_bin1_rclk
    ,output logic                  rf_ll_enq_cnt_s_bin1_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_s_bin1_raddr
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_s_bin1_waddr
    ,output logic                  rf_ll_enq_cnt_s_bin1_we
    ,output logic                  rf_ll_enq_cnt_s_bin1_wclk
    ,output logic                  rf_ll_enq_cnt_s_bin1_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_enq_cnt_s_bin1_wdata
    ,input  logic [(      16)-1:0] rf_ll_enq_cnt_s_bin1_rdata

    ,output logic                  rf_ll_enq_cnt_s_bin1_error

    ,input  logic                  func_ll_enq_cnt_s_bin2_re
    ,input  logic [(      12)-1:0] func_ll_enq_cnt_s_bin2_raddr
    ,input  logic [(      12)-1:0] func_ll_enq_cnt_s_bin2_waddr
    ,input  logic                  func_ll_enq_cnt_s_bin2_we
    ,input  logic [(      14)-1:0] func_ll_enq_cnt_s_bin2_wdata
    ,output logic [(      14)-1:0] func_ll_enq_cnt_s_bin2_rdata

    ,input  logic                  pf_ll_enq_cnt_s_bin2_re
    ,input  logic [(      12)-1:0] pf_ll_enq_cnt_s_bin2_raddr
    ,input  logic [(      12)-1:0] pf_ll_enq_cnt_s_bin2_waddr
    ,input  logic                  pf_ll_enq_cnt_s_bin2_we
    ,input  logic [(      14)-1:0] pf_ll_enq_cnt_s_bin2_wdata
    ,output logic [(      14)-1:0] pf_ll_enq_cnt_s_bin2_rdata

    ,output logic                  rf_ll_enq_cnt_s_bin2_re
    ,output logic                  rf_ll_enq_cnt_s_bin2_rclk
    ,output logic                  rf_ll_enq_cnt_s_bin2_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_s_bin2_raddr
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_s_bin2_waddr
    ,output logic                  rf_ll_enq_cnt_s_bin2_we
    ,output logic                  rf_ll_enq_cnt_s_bin2_wclk
    ,output logic                  rf_ll_enq_cnt_s_bin2_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_enq_cnt_s_bin2_wdata
    ,input  logic [(      16)-1:0] rf_ll_enq_cnt_s_bin2_rdata

    ,output logic                  rf_ll_enq_cnt_s_bin2_error

    ,input  logic                  func_ll_enq_cnt_s_bin3_re
    ,input  logic [(      12)-1:0] func_ll_enq_cnt_s_bin3_raddr
    ,input  logic [(      12)-1:0] func_ll_enq_cnt_s_bin3_waddr
    ,input  logic                  func_ll_enq_cnt_s_bin3_we
    ,input  logic [(      14)-1:0] func_ll_enq_cnt_s_bin3_wdata
    ,output logic [(      14)-1:0] func_ll_enq_cnt_s_bin3_rdata

    ,input  logic                  pf_ll_enq_cnt_s_bin3_re
    ,input  logic [(      12)-1:0] pf_ll_enq_cnt_s_bin3_raddr
    ,input  logic [(      12)-1:0] pf_ll_enq_cnt_s_bin3_waddr
    ,input  logic                  pf_ll_enq_cnt_s_bin3_we
    ,input  logic [(      14)-1:0] pf_ll_enq_cnt_s_bin3_wdata
    ,output logic [(      14)-1:0] pf_ll_enq_cnt_s_bin3_rdata

    ,output logic                  rf_ll_enq_cnt_s_bin3_re
    ,output logic                  rf_ll_enq_cnt_s_bin3_rclk
    ,output logic                  rf_ll_enq_cnt_s_bin3_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_s_bin3_raddr
    ,output logic [(      11)-1:0] rf_ll_enq_cnt_s_bin3_waddr
    ,output logic                  rf_ll_enq_cnt_s_bin3_we
    ,output logic                  rf_ll_enq_cnt_s_bin3_wclk
    ,output logic                  rf_ll_enq_cnt_s_bin3_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_enq_cnt_s_bin3_wdata
    ,input  logic [(      16)-1:0] rf_ll_enq_cnt_s_bin3_rdata

    ,output logic                  rf_ll_enq_cnt_s_bin3_error

    ,input  logic                  func_ll_rdylst_hp_bin0_re
    ,input  logic [(       7)-1:0] func_ll_rdylst_hp_bin0_raddr
    ,input  logic [(       7)-1:0] func_ll_rdylst_hp_bin0_waddr
    ,input  logic                  func_ll_rdylst_hp_bin0_we
    ,input  logic [(      14)-1:0] func_ll_rdylst_hp_bin0_wdata
    ,output logic [(      14)-1:0] func_ll_rdylst_hp_bin0_rdata

    ,input  logic                  pf_ll_rdylst_hp_bin0_re
    ,input  logic [(       7)-1:0] pf_ll_rdylst_hp_bin0_raddr
    ,input  logic [(       7)-1:0] pf_ll_rdylst_hp_bin0_waddr
    ,input  logic                  pf_ll_rdylst_hp_bin0_we
    ,input  logic [(      14)-1:0] pf_ll_rdylst_hp_bin0_wdata
    ,output logic [(      14)-1:0] pf_ll_rdylst_hp_bin0_rdata

    ,output logic                  rf_ll_rdylst_hp_bin0_re
    ,output logic                  rf_ll_rdylst_hp_bin0_rclk
    ,output logic                  rf_ll_rdylst_hp_bin0_rclk_rst_n
    ,output logic [(       5)-1:0] rf_ll_rdylst_hp_bin0_raddr
    ,output logic [(       5)-1:0] rf_ll_rdylst_hp_bin0_waddr
    ,output logic                  rf_ll_rdylst_hp_bin0_we
    ,output logic                  rf_ll_rdylst_hp_bin0_wclk
    ,output logic                  rf_ll_rdylst_hp_bin0_wclk_rst_n
    ,output logic [(      14)-1:0] rf_ll_rdylst_hp_bin0_wdata
    ,input  logic [(      14)-1:0] rf_ll_rdylst_hp_bin0_rdata

    ,output logic                  rf_ll_rdylst_hp_bin0_error

    ,input  logic                  func_ll_rdylst_hp_bin1_re
    ,input  logic [(       7)-1:0] func_ll_rdylst_hp_bin1_raddr
    ,input  logic [(       7)-1:0] func_ll_rdylst_hp_bin1_waddr
    ,input  logic                  func_ll_rdylst_hp_bin1_we
    ,input  logic [(      14)-1:0] func_ll_rdylst_hp_bin1_wdata
    ,output logic [(      14)-1:0] func_ll_rdylst_hp_bin1_rdata

    ,input  logic                  pf_ll_rdylst_hp_bin1_re
    ,input  logic [(       7)-1:0] pf_ll_rdylst_hp_bin1_raddr
    ,input  logic [(       7)-1:0] pf_ll_rdylst_hp_bin1_waddr
    ,input  logic                  pf_ll_rdylst_hp_bin1_we
    ,input  logic [(      14)-1:0] pf_ll_rdylst_hp_bin1_wdata
    ,output logic [(      14)-1:0] pf_ll_rdylst_hp_bin1_rdata

    ,output logic                  rf_ll_rdylst_hp_bin1_re
    ,output logic                  rf_ll_rdylst_hp_bin1_rclk
    ,output logic                  rf_ll_rdylst_hp_bin1_rclk_rst_n
    ,output logic [(       5)-1:0] rf_ll_rdylst_hp_bin1_raddr
    ,output logic [(       5)-1:0] rf_ll_rdylst_hp_bin1_waddr
    ,output logic                  rf_ll_rdylst_hp_bin1_we
    ,output logic                  rf_ll_rdylst_hp_bin1_wclk
    ,output logic                  rf_ll_rdylst_hp_bin1_wclk_rst_n
    ,output logic [(      14)-1:0] rf_ll_rdylst_hp_bin1_wdata
    ,input  logic [(      14)-1:0] rf_ll_rdylst_hp_bin1_rdata

    ,output logic                  rf_ll_rdylst_hp_bin1_error

    ,input  logic                  func_ll_rdylst_hp_bin2_re
    ,input  logic [(       7)-1:0] func_ll_rdylst_hp_bin2_raddr
    ,input  logic [(       7)-1:0] func_ll_rdylst_hp_bin2_waddr
    ,input  logic                  func_ll_rdylst_hp_bin2_we
    ,input  logic [(      14)-1:0] func_ll_rdylst_hp_bin2_wdata
    ,output logic [(      14)-1:0] func_ll_rdylst_hp_bin2_rdata

    ,input  logic                  pf_ll_rdylst_hp_bin2_re
    ,input  logic [(       7)-1:0] pf_ll_rdylst_hp_bin2_raddr
    ,input  logic [(       7)-1:0] pf_ll_rdylst_hp_bin2_waddr
    ,input  logic                  pf_ll_rdylst_hp_bin2_we
    ,input  logic [(      14)-1:0] pf_ll_rdylst_hp_bin2_wdata
    ,output logic [(      14)-1:0] pf_ll_rdylst_hp_bin2_rdata

    ,output logic                  rf_ll_rdylst_hp_bin2_re
    ,output logic                  rf_ll_rdylst_hp_bin2_rclk
    ,output logic                  rf_ll_rdylst_hp_bin2_rclk_rst_n
    ,output logic [(       5)-1:0] rf_ll_rdylst_hp_bin2_raddr
    ,output logic [(       5)-1:0] rf_ll_rdylst_hp_bin2_waddr
    ,output logic                  rf_ll_rdylst_hp_bin2_we
    ,output logic                  rf_ll_rdylst_hp_bin2_wclk
    ,output logic                  rf_ll_rdylst_hp_bin2_wclk_rst_n
    ,output logic [(      14)-1:0] rf_ll_rdylst_hp_bin2_wdata
    ,input  logic [(      14)-1:0] rf_ll_rdylst_hp_bin2_rdata

    ,output logic                  rf_ll_rdylst_hp_bin2_error

    ,input  logic                  func_ll_rdylst_hp_bin3_re
    ,input  logic [(       7)-1:0] func_ll_rdylst_hp_bin3_raddr
    ,input  logic [(       7)-1:0] func_ll_rdylst_hp_bin3_waddr
    ,input  logic                  func_ll_rdylst_hp_bin3_we
    ,input  logic [(      14)-1:0] func_ll_rdylst_hp_bin3_wdata
    ,output logic [(      14)-1:0] func_ll_rdylst_hp_bin3_rdata

    ,input  logic                  pf_ll_rdylst_hp_bin3_re
    ,input  logic [(       7)-1:0] pf_ll_rdylst_hp_bin3_raddr
    ,input  logic [(       7)-1:0] pf_ll_rdylst_hp_bin3_waddr
    ,input  logic                  pf_ll_rdylst_hp_bin3_we
    ,input  logic [(      14)-1:0] pf_ll_rdylst_hp_bin3_wdata
    ,output logic [(      14)-1:0] pf_ll_rdylst_hp_bin3_rdata

    ,output logic                  rf_ll_rdylst_hp_bin3_re
    ,output logic                  rf_ll_rdylst_hp_bin3_rclk
    ,output logic                  rf_ll_rdylst_hp_bin3_rclk_rst_n
    ,output logic [(       5)-1:0] rf_ll_rdylst_hp_bin3_raddr
    ,output logic [(       5)-1:0] rf_ll_rdylst_hp_bin3_waddr
    ,output logic                  rf_ll_rdylst_hp_bin3_we
    ,output logic                  rf_ll_rdylst_hp_bin3_wclk
    ,output logic                  rf_ll_rdylst_hp_bin3_wclk_rst_n
    ,output logic [(      14)-1:0] rf_ll_rdylst_hp_bin3_wdata
    ,input  logic [(      14)-1:0] rf_ll_rdylst_hp_bin3_rdata

    ,output logic                  rf_ll_rdylst_hp_bin3_error

    ,input  logic                  func_ll_rdylst_hpnxt_bin0_re
    ,input  logic [(      12)-1:0] func_ll_rdylst_hpnxt_bin0_raddr
    ,input  logic [(      12)-1:0] func_ll_rdylst_hpnxt_bin0_waddr
    ,input  logic                  func_ll_rdylst_hpnxt_bin0_we
    ,input  logic [(      14)-1:0] func_ll_rdylst_hpnxt_bin0_wdata
    ,output logic [(      14)-1:0] func_ll_rdylst_hpnxt_bin0_rdata

    ,input  logic                  pf_ll_rdylst_hpnxt_bin0_re
    ,input  logic [(      12)-1:0] pf_ll_rdylst_hpnxt_bin0_raddr
    ,input  logic [(      12)-1:0] pf_ll_rdylst_hpnxt_bin0_waddr
    ,input  logic                  pf_ll_rdylst_hpnxt_bin0_we
    ,input  logic [(      14)-1:0] pf_ll_rdylst_hpnxt_bin0_wdata
    ,output logic [(      14)-1:0] pf_ll_rdylst_hpnxt_bin0_rdata

    ,output logic                  rf_ll_rdylst_hpnxt_bin0_re
    ,output logic                  rf_ll_rdylst_hpnxt_bin0_rclk
    ,output logic                  rf_ll_rdylst_hpnxt_bin0_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_rdylst_hpnxt_bin0_raddr
    ,output logic [(      11)-1:0] rf_ll_rdylst_hpnxt_bin0_waddr
    ,output logic                  rf_ll_rdylst_hpnxt_bin0_we
    ,output logic                  rf_ll_rdylst_hpnxt_bin0_wclk
    ,output logic                  rf_ll_rdylst_hpnxt_bin0_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_rdylst_hpnxt_bin0_wdata
    ,input  logic [(      16)-1:0] rf_ll_rdylst_hpnxt_bin0_rdata

    ,output logic                  rf_ll_rdylst_hpnxt_bin0_error

    ,input  logic                  func_ll_rdylst_hpnxt_bin1_re
    ,input  logic [(      12)-1:0] func_ll_rdylst_hpnxt_bin1_raddr
    ,input  logic [(      12)-1:0] func_ll_rdylst_hpnxt_bin1_waddr
    ,input  logic                  func_ll_rdylst_hpnxt_bin1_we
    ,input  logic [(      14)-1:0] func_ll_rdylst_hpnxt_bin1_wdata
    ,output logic [(      14)-1:0] func_ll_rdylst_hpnxt_bin1_rdata

    ,input  logic                  pf_ll_rdylst_hpnxt_bin1_re
    ,input  logic [(      12)-1:0] pf_ll_rdylst_hpnxt_bin1_raddr
    ,input  logic [(      12)-1:0] pf_ll_rdylst_hpnxt_bin1_waddr
    ,input  logic                  pf_ll_rdylst_hpnxt_bin1_we
    ,input  logic [(      14)-1:0] pf_ll_rdylst_hpnxt_bin1_wdata
    ,output logic [(      14)-1:0] pf_ll_rdylst_hpnxt_bin1_rdata

    ,output logic                  rf_ll_rdylst_hpnxt_bin1_re
    ,output logic                  rf_ll_rdylst_hpnxt_bin1_rclk
    ,output logic                  rf_ll_rdylst_hpnxt_bin1_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_rdylst_hpnxt_bin1_raddr
    ,output logic [(      11)-1:0] rf_ll_rdylst_hpnxt_bin1_waddr
    ,output logic                  rf_ll_rdylst_hpnxt_bin1_we
    ,output logic                  rf_ll_rdylst_hpnxt_bin1_wclk
    ,output logic                  rf_ll_rdylst_hpnxt_bin1_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_rdylst_hpnxt_bin1_wdata
    ,input  logic [(      16)-1:0] rf_ll_rdylst_hpnxt_bin1_rdata

    ,output logic                  rf_ll_rdylst_hpnxt_bin1_error

    ,input  logic                  func_ll_rdylst_hpnxt_bin2_re
    ,input  logic [(      12)-1:0] func_ll_rdylst_hpnxt_bin2_raddr
    ,input  logic [(      12)-1:0] func_ll_rdylst_hpnxt_bin2_waddr
    ,input  logic                  func_ll_rdylst_hpnxt_bin2_we
    ,input  logic [(      14)-1:0] func_ll_rdylst_hpnxt_bin2_wdata
    ,output logic [(      14)-1:0] func_ll_rdylst_hpnxt_bin2_rdata

    ,input  logic                  pf_ll_rdylst_hpnxt_bin2_re
    ,input  logic [(      12)-1:0] pf_ll_rdylst_hpnxt_bin2_raddr
    ,input  logic [(      12)-1:0] pf_ll_rdylst_hpnxt_bin2_waddr
    ,input  logic                  pf_ll_rdylst_hpnxt_bin2_we
    ,input  logic [(      14)-1:0] pf_ll_rdylst_hpnxt_bin2_wdata
    ,output logic [(      14)-1:0] pf_ll_rdylst_hpnxt_bin2_rdata

    ,output logic                  rf_ll_rdylst_hpnxt_bin2_re
    ,output logic                  rf_ll_rdylst_hpnxt_bin2_rclk
    ,output logic                  rf_ll_rdylst_hpnxt_bin2_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_rdylst_hpnxt_bin2_raddr
    ,output logic [(      11)-1:0] rf_ll_rdylst_hpnxt_bin2_waddr
    ,output logic                  rf_ll_rdylst_hpnxt_bin2_we
    ,output logic                  rf_ll_rdylst_hpnxt_bin2_wclk
    ,output logic                  rf_ll_rdylst_hpnxt_bin2_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_rdylst_hpnxt_bin2_wdata
    ,input  logic [(      16)-1:0] rf_ll_rdylst_hpnxt_bin2_rdata

    ,output logic                  rf_ll_rdylst_hpnxt_bin2_error

    ,input  logic                  func_ll_rdylst_hpnxt_bin3_re
    ,input  logic [(      12)-1:0] func_ll_rdylst_hpnxt_bin3_raddr
    ,input  logic [(      12)-1:0] func_ll_rdylst_hpnxt_bin3_waddr
    ,input  logic                  func_ll_rdylst_hpnxt_bin3_we
    ,input  logic [(      14)-1:0] func_ll_rdylst_hpnxt_bin3_wdata
    ,output logic [(      14)-1:0] func_ll_rdylst_hpnxt_bin3_rdata

    ,input  logic                  pf_ll_rdylst_hpnxt_bin3_re
    ,input  logic [(      12)-1:0] pf_ll_rdylst_hpnxt_bin3_raddr
    ,input  logic [(      12)-1:0] pf_ll_rdylst_hpnxt_bin3_waddr
    ,input  logic                  pf_ll_rdylst_hpnxt_bin3_we
    ,input  logic [(      14)-1:0] pf_ll_rdylst_hpnxt_bin3_wdata
    ,output logic [(      14)-1:0] pf_ll_rdylst_hpnxt_bin3_rdata

    ,output logic                  rf_ll_rdylst_hpnxt_bin3_re
    ,output logic                  rf_ll_rdylst_hpnxt_bin3_rclk
    ,output logic                  rf_ll_rdylst_hpnxt_bin3_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_rdylst_hpnxt_bin3_raddr
    ,output logic [(      11)-1:0] rf_ll_rdylst_hpnxt_bin3_waddr
    ,output logic                  rf_ll_rdylst_hpnxt_bin3_we
    ,output logic                  rf_ll_rdylst_hpnxt_bin3_wclk
    ,output logic                  rf_ll_rdylst_hpnxt_bin3_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_rdylst_hpnxt_bin3_wdata
    ,input  logic [(      16)-1:0] rf_ll_rdylst_hpnxt_bin3_rdata

    ,output logic                  rf_ll_rdylst_hpnxt_bin3_error

    ,input  logic                  func_ll_rdylst_tp_bin0_re
    ,input  logic [(       7)-1:0] func_ll_rdylst_tp_bin0_raddr
    ,input  logic [(       7)-1:0] func_ll_rdylst_tp_bin0_waddr
    ,input  logic                  func_ll_rdylst_tp_bin0_we
    ,input  logic [(      14)-1:0] func_ll_rdylst_tp_bin0_wdata
    ,output logic [(      14)-1:0] func_ll_rdylst_tp_bin0_rdata

    ,input  logic                  pf_ll_rdylst_tp_bin0_re
    ,input  logic [(       7)-1:0] pf_ll_rdylst_tp_bin0_raddr
    ,input  logic [(       7)-1:0] pf_ll_rdylst_tp_bin0_waddr
    ,input  logic                  pf_ll_rdylst_tp_bin0_we
    ,input  logic [(      14)-1:0] pf_ll_rdylst_tp_bin0_wdata
    ,output logic [(      14)-1:0] pf_ll_rdylst_tp_bin0_rdata

    ,output logic                  rf_ll_rdylst_tp_bin0_re
    ,output logic                  rf_ll_rdylst_tp_bin0_rclk
    ,output logic                  rf_ll_rdylst_tp_bin0_rclk_rst_n
    ,output logic [(       5)-1:0] rf_ll_rdylst_tp_bin0_raddr
    ,output logic [(       5)-1:0] rf_ll_rdylst_tp_bin0_waddr
    ,output logic                  rf_ll_rdylst_tp_bin0_we
    ,output logic                  rf_ll_rdylst_tp_bin0_wclk
    ,output logic                  rf_ll_rdylst_tp_bin0_wclk_rst_n
    ,output logic [(      14)-1:0] rf_ll_rdylst_tp_bin0_wdata
    ,input  logic [(      14)-1:0] rf_ll_rdylst_tp_bin0_rdata

    ,output logic                  rf_ll_rdylst_tp_bin0_error

    ,input  logic                  func_ll_rdylst_tp_bin1_re
    ,input  logic [(       7)-1:0] func_ll_rdylst_tp_bin1_raddr
    ,input  logic [(       7)-1:0] func_ll_rdylst_tp_bin1_waddr
    ,input  logic                  func_ll_rdylst_tp_bin1_we
    ,input  logic [(      14)-1:0] func_ll_rdylst_tp_bin1_wdata
    ,output logic [(      14)-1:0] func_ll_rdylst_tp_bin1_rdata

    ,input  logic                  pf_ll_rdylst_tp_bin1_re
    ,input  logic [(       7)-1:0] pf_ll_rdylst_tp_bin1_raddr
    ,input  logic [(       7)-1:0] pf_ll_rdylst_tp_bin1_waddr
    ,input  logic                  pf_ll_rdylst_tp_bin1_we
    ,input  logic [(      14)-1:0] pf_ll_rdylst_tp_bin1_wdata
    ,output logic [(      14)-1:0] pf_ll_rdylst_tp_bin1_rdata

    ,output logic                  rf_ll_rdylst_tp_bin1_re
    ,output logic                  rf_ll_rdylst_tp_bin1_rclk
    ,output logic                  rf_ll_rdylst_tp_bin1_rclk_rst_n
    ,output logic [(       5)-1:0] rf_ll_rdylst_tp_bin1_raddr
    ,output logic [(       5)-1:0] rf_ll_rdylst_tp_bin1_waddr
    ,output logic                  rf_ll_rdylst_tp_bin1_we
    ,output logic                  rf_ll_rdylst_tp_bin1_wclk
    ,output logic                  rf_ll_rdylst_tp_bin1_wclk_rst_n
    ,output logic [(      14)-1:0] rf_ll_rdylst_tp_bin1_wdata
    ,input  logic [(      14)-1:0] rf_ll_rdylst_tp_bin1_rdata

    ,output logic                  rf_ll_rdylst_tp_bin1_error

    ,input  logic                  func_ll_rdylst_tp_bin2_re
    ,input  logic [(       7)-1:0] func_ll_rdylst_tp_bin2_raddr
    ,input  logic [(       7)-1:0] func_ll_rdylst_tp_bin2_waddr
    ,input  logic                  func_ll_rdylst_tp_bin2_we
    ,input  logic [(      14)-1:0] func_ll_rdylst_tp_bin2_wdata
    ,output logic [(      14)-1:0] func_ll_rdylst_tp_bin2_rdata

    ,input  logic                  pf_ll_rdylst_tp_bin2_re
    ,input  logic [(       7)-1:0] pf_ll_rdylst_tp_bin2_raddr
    ,input  logic [(       7)-1:0] pf_ll_rdylst_tp_bin2_waddr
    ,input  logic                  pf_ll_rdylst_tp_bin2_we
    ,input  logic [(      14)-1:0] pf_ll_rdylst_tp_bin2_wdata
    ,output logic [(      14)-1:0] pf_ll_rdylst_tp_bin2_rdata

    ,output logic                  rf_ll_rdylst_tp_bin2_re
    ,output logic                  rf_ll_rdylst_tp_bin2_rclk
    ,output logic                  rf_ll_rdylst_tp_bin2_rclk_rst_n
    ,output logic [(       5)-1:0] rf_ll_rdylst_tp_bin2_raddr
    ,output logic [(       5)-1:0] rf_ll_rdylst_tp_bin2_waddr
    ,output logic                  rf_ll_rdylst_tp_bin2_we
    ,output logic                  rf_ll_rdylst_tp_bin2_wclk
    ,output logic                  rf_ll_rdylst_tp_bin2_wclk_rst_n
    ,output logic [(      14)-1:0] rf_ll_rdylst_tp_bin2_wdata
    ,input  logic [(      14)-1:0] rf_ll_rdylst_tp_bin2_rdata

    ,output logic                  rf_ll_rdylst_tp_bin2_error

    ,input  logic                  func_ll_rdylst_tp_bin3_re
    ,input  logic [(       7)-1:0] func_ll_rdylst_tp_bin3_raddr
    ,input  logic [(       7)-1:0] func_ll_rdylst_tp_bin3_waddr
    ,input  logic                  func_ll_rdylst_tp_bin3_we
    ,input  logic [(      14)-1:0] func_ll_rdylst_tp_bin3_wdata
    ,output logic [(      14)-1:0] func_ll_rdylst_tp_bin3_rdata

    ,input  logic                  pf_ll_rdylst_tp_bin3_re
    ,input  logic [(       7)-1:0] pf_ll_rdylst_tp_bin3_raddr
    ,input  logic [(       7)-1:0] pf_ll_rdylst_tp_bin3_waddr
    ,input  logic                  pf_ll_rdylst_tp_bin3_we
    ,input  logic [(      14)-1:0] pf_ll_rdylst_tp_bin3_wdata
    ,output logic [(      14)-1:0] pf_ll_rdylst_tp_bin3_rdata

    ,output logic                  rf_ll_rdylst_tp_bin3_re
    ,output logic                  rf_ll_rdylst_tp_bin3_rclk
    ,output logic                  rf_ll_rdylst_tp_bin3_rclk_rst_n
    ,output logic [(       5)-1:0] rf_ll_rdylst_tp_bin3_raddr
    ,output logic [(       5)-1:0] rf_ll_rdylst_tp_bin3_waddr
    ,output logic                  rf_ll_rdylst_tp_bin3_we
    ,output logic                  rf_ll_rdylst_tp_bin3_wclk
    ,output logic                  rf_ll_rdylst_tp_bin3_wclk_rst_n
    ,output logic [(      14)-1:0] rf_ll_rdylst_tp_bin3_wdata
    ,input  logic [(      14)-1:0] rf_ll_rdylst_tp_bin3_rdata

    ,output logic                  rf_ll_rdylst_tp_bin3_error

    ,input  logic                  func_ll_rlst_cnt_re
    ,input  logic [(       7)-1:0] func_ll_rlst_cnt_raddr
    ,input  logic [(       7)-1:0] func_ll_rlst_cnt_waddr
    ,input  logic                  func_ll_rlst_cnt_we
    ,input  logic [(      56)-1:0] func_ll_rlst_cnt_wdata
    ,output logic [(      56)-1:0] func_ll_rlst_cnt_rdata

    ,input  logic                  pf_ll_rlst_cnt_re
    ,input  logic [(       7)-1:0] pf_ll_rlst_cnt_raddr
    ,input  logic [(       7)-1:0] pf_ll_rlst_cnt_waddr
    ,input  logic                  pf_ll_rlst_cnt_we
    ,input  logic [(      56)-1:0] pf_ll_rlst_cnt_wdata
    ,output logic [(      56)-1:0] pf_ll_rlst_cnt_rdata

    ,output logic                  rf_ll_rlst_cnt_re
    ,output logic                  rf_ll_rlst_cnt_rclk
    ,output logic                  rf_ll_rlst_cnt_rclk_rst_n
    ,output logic [(       5)-1:0] rf_ll_rlst_cnt_raddr
    ,output logic [(       5)-1:0] rf_ll_rlst_cnt_waddr
    ,output logic                  rf_ll_rlst_cnt_we
    ,output logic                  rf_ll_rlst_cnt_wclk
    ,output logic                  rf_ll_rlst_cnt_wclk_rst_n
    ,output logic [(      56)-1:0] rf_ll_rlst_cnt_wdata
    ,input  logic [(      56)-1:0] rf_ll_rlst_cnt_rdata

    ,output logic                  rf_ll_rlst_cnt_error

    ,input  logic                  func_ll_sch_cnt_dup0_re
    ,input  logic [(      12)-1:0] func_ll_sch_cnt_dup0_raddr
    ,input  logic [(      12)-1:0] func_ll_sch_cnt_dup0_waddr
    ,input  logic                  func_ll_sch_cnt_dup0_we
    ,input  logic [(      15)-1:0] func_ll_sch_cnt_dup0_wdata
    ,output logic [(      15)-1:0] func_ll_sch_cnt_dup0_rdata

    ,input  logic                  pf_ll_sch_cnt_dup0_re
    ,input  logic [(      12)-1:0] pf_ll_sch_cnt_dup0_raddr
    ,input  logic [(      12)-1:0] pf_ll_sch_cnt_dup0_waddr
    ,input  logic                  pf_ll_sch_cnt_dup0_we
    ,input  logic [(      15)-1:0] pf_ll_sch_cnt_dup0_wdata
    ,output logic [(      15)-1:0] pf_ll_sch_cnt_dup0_rdata

    ,output logic                  rf_ll_sch_cnt_dup0_re
    ,output logic                  rf_ll_sch_cnt_dup0_rclk
    ,output logic                  rf_ll_sch_cnt_dup0_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_sch_cnt_dup0_raddr
    ,output logic [(      11)-1:0] rf_ll_sch_cnt_dup0_waddr
    ,output logic                  rf_ll_sch_cnt_dup0_we
    ,output logic                  rf_ll_sch_cnt_dup0_wclk
    ,output logic                  rf_ll_sch_cnt_dup0_wclk_rst_n
    ,output logic [(      17)-1:0] rf_ll_sch_cnt_dup0_wdata
    ,input  logic [(      17)-1:0] rf_ll_sch_cnt_dup0_rdata

    ,output logic                  rf_ll_sch_cnt_dup0_error

    ,input  logic                  func_ll_sch_cnt_dup1_re
    ,input  logic [(      12)-1:0] func_ll_sch_cnt_dup1_raddr
    ,input  logic [(      12)-1:0] func_ll_sch_cnt_dup1_waddr
    ,input  logic                  func_ll_sch_cnt_dup1_we
    ,input  logic [(      15)-1:0] func_ll_sch_cnt_dup1_wdata
    ,output logic [(      15)-1:0] func_ll_sch_cnt_dup1_rdata

    ,input  logic                  pf_ll_sch_cnt_dup1_re
    ,input  logic [(      12)-1:0] pf_ll_sch_cnt_dup1_raddr
    ,input  logic [(      12)-1:0] pf_ll_sch_cnt_dup1_waddr
    ,input  logic                  pf_ll_sch_cnt_dup1_we
    ,input  logic [(      15)-1:0] pf_ll_sch_cnt_dup1_wdata
    ,output logic [(      15)-1:0] pf_ll_sch_cnt_dup1_rdata

    ,output logic                  rf_ll_sch_cnt_dup1_re
    ,output logic                  rf_ll_sch_cnt_dup1_rclk
    ,output logic                  rf_ll_sch_cnt_dup1_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_sch_cnt_dup1_raddr
    ,output logic [(      11)-1:0] rf_ll_sch_cnt_dup1_waddr
    ,output logic                  rf_ll_sch_cnt_dup1_we
    ,output logic                  rf_ll_sch_cnt_dup1_wclk
    ,output logic                  rf_ll_sch_cnt_dup1_wclk_rst_n
    ,output logic [(      17)-1:0] rf_ll_sch_cnt_dup1_wdata
    ,input  logic [(      17)-1:0] rf_ll_sch_cnt_dup1_rdata

    ,output logic                  rf_ll_sch_cnt_dup1_error

    ,input  logic                  func_ll_sch_cnt_dup2_re
    ,input  logic [(      12)-1:0] func_ll_sch_cnt_dup2_raddr
    ,input  logic [(      12)-1:0] func_ll_sch_cnt_dup2_waddr
    ,input  logic                  func_ll_sch_cnt_dup2_we
    ,input  logic [(      15)-1:0] func_ll_sch_cnt_dup2_wdata
    ,output logic [(      15)-1:0] func_ll_sch_cnt_dup2_rdata

    ,input  logic                  pf_ll_sch_cnt_dup2_re
    ,input  logic [(      12)-1:0] pf_ll_sch_cnt_dup2_raddr
    ,input  logic [(      12)-1:0] pf_ll_sch_cnt_dup2_waddr
    ,input  logic                  pf_ll_sch_cnt_dup2_we
    ,input  logic [(      15)-1:0] pf_ll_sch_cnt_dup2_wdata
    ,output logic [(      15)-1:0] pf_ll_sch_cnt_dup2_rdata

    ,output logic                  rf_ll_sch_cnt_dup2_re
    ,output logic                  rf_ll_sch_cnt_dup2_rclk
    ,output logic                  rf_ll_sch_cnt_dup2_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_sch_cnt_dup2_raddr
    ,output logic [(      11)-1:0] rf_ll_sch_cnt_dup2_waddr
    ,output logic                  rf_ll_sch_cnt_dup2_we
    ,output logic                  rf_ll_sch_cnt_dup2_wclk
    ,output logic                  rf_ll_sch_cnt_dup2_wclk_rst_n
    ,output logic [(      17)-1:0] rf_ll_sch_cnt_dup2_wdata
    ,input  logic [(      17)-1:0] rf_ll_sch_cnt_dup2_rdata

    ,output logic                  rf_ll_sch_cnt_dup2_error

    ,input  logic                  func_ll_sch_cnt_dup3_re
    ,input  logic [(      12)-1:0] func_ll_sch_cnt_dup3_raddr
    ,input  logic [(      12)-1:0] func_ll_sch_cnt_dup3_waddr
    ,input  logic                  func_ll_sch_cnt_dup3_we
    ,input  logic [(      15)-1:0] func_ll_sch_cnt_dup3_wdata
    ,output logic [(      15)-1:0] func_ll_sch_cnt_dup3_rdata

    ,input  logic                  pf_ll_sch_cnt_dup3_re
    ,input  logic [(      12)-1:0] pf_ll_sch_cnt_dup3_raddr
    ,input  logic [(      12)-1:0] pf_ll_sch_cnt_dup3_waddr
    ,input  logic                  pf_ll_sch_cnt_dup3_we
    ,input  logic [(      15)-1:0] pf_ll_sch_cnt_dup3_wdata
    ,output logic [(      15)-1:0] pf_ll_sch_cnt_dup3_rdata

    ,output logic                  rf_ll_sch_cnt_dup3_re
    ,output logic                  rf_ll_sch_cnt_dup3_rclk
    ,output logic                  rf_ll_sch_cnt_dup3_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_sch_cnt_dup3_raddr
    ,output logic [(      11)-1:0] rf_ll_sch_cnt_dup3_waddr
    ,output logic                  rf_ll_sch_cnt_dup3_we
    ,output logic                  rf_ll_sch_cnt_dup3_wclk
    ,output logic                  rf_ll_sch_cnt_dup3_wclk_rst_n
    ,output logic [(      17)-1:0] rf_ll_sch_cnt_dup3_wdata
    ,input  logic [(      17)-1:0] rf_ll_sch_cnt_dup3_rdata

    ,output logic                  rf_ll_sch_cnt_dup3_error

    ,input  logic                  func_ll_schlst_hp_bin0_re
    ,input  logic [(       9)-1:0] func_ll_schlst_hp_bin0_raddr
    ,input  logic [(       9)-1:0] func_ll_schlst_hp_bin0_waddr
    ,input  logic                  func_ll_schlst_hp_bin0_we
    ,input  logic [(      14)-1:0] func_ll_schlst_hp_bin0_wdata
    ,output logic [(      14)-1:0] func_ll_schlst_hp_bin0_rdata

    ,input  logic                  pf_ll_schlst_hp_bin0_re
    ,input  logic [(       9)-1:0] pf_ll_schlst_hp_bin0_raddr
    ,input  logic [(       9)-1:0] pf_ll_schlst_hp_bin0_waddr
    ,input  logic                  pf_ll_schlst_hp_bin0_we
    ,input  logic [(      14)-1:0] pf_ll_schlst_hp_bin0_wdata
    ,output logic [(      14)-1:0] pf_ll_schlst_hp_bin0_rdata

    ,output logic                  rf_ll_schlst_hp_bin0_re
    ,output logic                  rf_ll_schlst_hp_bin0_rclk
    ,output logic                  rf_ll_schlst_hp_bin0_rclk_rst_n
    ,output logic [(       9)-1:0] rf_ll_schlst_hp_bin0_raddr
    ,output logic [(       9)-1:0] rf_ll_schlst_hp_bin0_waddr
    ,output logic                  rf_ll_schlst_hp_bin0_we
    ,output logic                  rf_ll_schlst_hp_bin0_wclk
    ,output logic                  rf_ll_schlst_hp_bin0_wclk_rst_n
    ,output logic [(      14)-1:0] rf_ll_schlst_hp_bin0_wdata
    ,input  logic [(      14)-1:0] rf_ll_schlst_hp_bin0_rdata

    ,output logic                  rf_ll_schlst_hp_bin0_error

    ,input  logic                  func_ll_schlst_hp_bin1_re
    ,input  logic [(       9)-1:0] func_ll_schlst_hp_bin1_raddr
    ,input  logic [(       9)-1:0] func_ll_schlst_hp_bin1_waddr
    ,input  logic                  func_ll_schlst_hp_bin1_we
    ,input  logic [(      14)-1:0] func_ll_schlst_hp_bin1_wdata
    ,output logic [(      14)-1:0] func_ll_schlst_hp_bin1_rdata

    ,input  logic                  pf_ll_schlst_hp_bin1_re
    ,input  logic [(       9)-1:0] pf_ll_schlst_hp_bin1_raddr
    ,input  logic [(       9)-1:0] pf_ll_schlst_hp_bin1_waddr
    ,input  logic                  pf_ll_schlst_hp_bin1_we
    ,input  logic [(      14)-1:0] pf_ll_schlst_hp_bin1_wdata
    ,output logic [(      14)-1:0] pf_ll_schlst_hp_bin1_rdata

    ,output logic                  rf_ll_schlst_hp_bin1_re
    ,output logic                  rf_ll_schlst_hp_bin1_rclk
    ,output logic                  rf_ll_schlst_hp_bin1_rclk_rst_n
    ,output logic [(       9)-1:0] rf_ll_schlst_hp_bin1_raddr
    ,output logic [(       9)-1:0] rf_ll_schlst_hp_bin1_waddr
    ,output logic                  rf_ll_schlst_hp_bin1_we
    ,output logic                  rf_ll_schlst_hp_bin1_wclk
    ,output logic                  rf_ll_schlst_hp_bin1_wclk_rst_n
    ,output logic [(      14)-1:0] rf_ll_schlst_hp_bin1_wdata
    ,input  logic [(      14)-1:0] rf_ll_schlst_hp_bin1_rdata

    ,output logic                  rf_ll_schlst_hp_bin1_error

    ,input  logic                  func_ll_schlst_hp_bin2_re
    ,input  logic [(       9)-1:0] func_ll_schlst_hp_bin2_raddr
    ,input  logic [(       9)-1:0] func_ll_schlst_hp_bin2_waddr
    ,input  logic                  func_ll_schlst_hp_bin2_we
    ,input  logic [(      14)-1:0] func_ll_schlst_hp_bin2_wdata
    ,output logic [(      14)-1:0] func_ll_schlst_hp_bin2_rdata

    ,input  logic                  pf_ll_schlst_hp_bin2_re
    ,input  logic [(       9)-1:0] pf_ll_schlst_hp_bin2_raddr
    ,input  logic [(       9)-1:0] pf_ll_schlst_hp_bin2_waddr
    ,input  logic                  pf_ll_schlst_hp_bin2_we
    ,input  logic [(      14)-1:0] pf_ll_schlst_hp_bin2_wdata
    ,output logic [(      14)-1:0] pf_ll_schlst_hp_bin2_rdata

    ,output logic                  rf_ll_schlst_hp_bin2_re
    ,output logic                  rf_ll_schlst_hp_bin2_rclk
    ,output logic                  rf_ll_schlst_hp_bin2_rclk_rst_n
    ,output logic [(       9)-1:0] rf_ll_schlst_hp_bin2_raddr
    ,output logic [(       9)-1:0] rf_ll_schlst_hp_bin2_waddr
    ,output logic                  rf_ll_schlst_hp_bin2_we
    ,output logic                  rf_ll_schlst_hp_bin2_wclk
    ,output logic                  rf_ll_schlst_hp_bin2_wclk_rst_n
    ,output logic [(      14)-1:0] rf_ll_schlst_hp_bin2_wdata
    ,input  logic [(      14)-1:0] rf_ll_schlst_hp_bin2_rdata

    ,output logic                  rf_ll_schlst_hp_bin2_error

    ,input  logic                  func_ll_schlst_hp_bin3_re
    ,input  logic [(       9)-1:0] func_ll_schlst_hp_bin3_raddr
    ,input  logic [(       9)-1:0] func_ll_schlst_hp_bin3_waddr
    ,input  logic                  func_ll_schlst_hp_bin3_we
    ,input  logic [(      14)-1:0] func_ll_schlst_hp_bin3_wdata
    ,output logic [(      14)-1:0] func_ll_schlst_hp_bin3_rdata

    ,input  logic                  pf_ll_schlst_hp_bin3_re
    ,input  logic [(       9)-1:0] pf_ll_schlst_hp_bin3_raddr
    ,input  logic [(       9)-1:0] pf_ll_schlst_hp_bin3_waddr
    ,input  logic                  pf_ll_schlst_hp_bin3_we
    ,input  logic [(      14)-1:0] pf_ll_schlst_hp_bin3_wdata
    ,output logic [(      14)-1:0] pf_ll_schlst_hp_bin3_rdata

    ,output logic                  rf_ll_schlst_hp_bin3_re
    ,output logic                  rf_ll_schlst_hp_bin3_rclk
    ,output logic                  rf_ll_schlst_hp_bin3_rclk_rst_n
    ,output logic [(       9)-1:0] rf_ll_schlst_hp_bin3_raddr
    ,output logic [(       9)-1:0] rf_ll_schlst_hp_bin3_waddr
    ,output logic                  rf_ll_schlst_hp_bin3_we
    ,output logic                  rf_ll_schlst_hp_bin3_wclk
    ,output logic                  rf_ll_schlst_hp_bin3_wclk_rst_n
    ,output logic [(      14)-1:0] rf_ll_schlst_hp_bin3_wdata
    ,input  logic [(      14)-1:0] rf_ll_schlst_hp_bin3_rdata

    ,output logic                  rf_ll_schlst_hp_bin3_error

    ,input  logic                  func_ll_schlst_hpnxt_bin0_re
    ,input  logic [(      12)-1:0] func_ll_schlst_hpnxt_bin0_raddr
    ,input  logic [(      12)-1:0] func_ll_schlst_hpnxt_bin0_waddr
    ,input  logic                  func_ll_schlst_hpnxt_bin0_we
    ,input  logic [(      14)-1:0] func_ll_schlst_hpnxt_bin0_wdata
    ,output logic [(      14)-1:0] func_ll_schlst_hpnxt_bin0_rdata

    ,input  logic                  pf_ll_schlst_hpnxt_bin0_re
    ,input  logic [(      12)-1:0] pf_ll_schlst_hpnxt_bin0_raddr
    ,input  logic [(      12)-1:0] pf_ll_schlst_hpnxt_bin0_waddr
    ,input  logic                  pf_ll_schlst_hpnxt_bin0_we
    ,input  logic [(      14)-1:0] pf_ll_schlst_hpnxt_bin0_wdata
    ,output logic [(      14)-1:0] pf_ll_schlst_hpnxt_bin0_rdata

    ,output logic                  rf_ll_schlst_hpnxt_bin0_re
    ,output logic                  rf_ll_schlst_hpnxt_bin0_rclk
    ,output logic                  rf_ll_schlst_hpnxt_bin0_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_schlst_hpnxt_bin0_raddr
    ,output logic [(      11)-1:0] rf_ll_schlst_hpnxt_bin0_waddr
    ,output logic                  rf_ll_schlst_hpnxt_bin0_we
    ,output logic                  rf_ll_schlst_hpnxt_bin0_wclk
    ,output logic                  rf_ll_schlst_hpnxt_bin0_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_schlst_hpnxt_bin0_wdata
    ,input  logic [(      16)-1:0] rf_ll_schlst_hpnxt_bin0_rdata

    ,output logic                  rf_ll_schlst_hpnxt_bin0_error

    ,input  logic                  func_ll_schlst_hpnxt_bin1_re
    ,input  logic [(      12)-1:0] func_ll_schlst_hpnxt_bin1_raddr
    ,input  logic [(      12)-1:0] func_ll_schlst_hpnxt_bin1_waddr
    ,input  logic                  func_ll_schlst_hpnxt_bin1_we
    ,input  logic [(      14)-1:0] func_ll_schlst_hpnxt_bin1_wdata
    ,output logic [(      14)-1:0] func_ll_schlst_hpnxt_bin1_rdata

    ,input  logic                  pf_ll_schlst_hpnxt_bin1_re
    ,input  logic [(      12)-1:0] pf_ll_schlst_hpnxt_bin1_raddr
    ,input  logic [(      12)-1:0] pf_ll_schlst_hpnxt_bin1_waddr
    ,input  logic                  pf_ll_schlst_hpnxt_bin1_we
    ,input  logic [(      14)-1:0] pf_ll_schlst_hpnxt_bin1_wdata
    ,output logic [(      14)-1:0] pf_ll_schlst_hpnxt_bin1_rdata

    ,output logic                  rf_ll_schlst_hpnxt_bin1_re
    ,output logic                  rf_ll_schlst_hpnxt_bin1_rclk
    ,output logic                  rf_ll_schlst_hpnxt_bin1_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_schlst_hpnxt_bin1_raddr
    ,output logic [(      11)-1:0] rf_ll_schlst_hpnxt_bin1_waddr
    ,output logic                  rf_ll_schlst_hpnxt_bin1_we
    ,output logic                  rf_ll_schlst_hpnxt_bin1_wclk
    ,output logic                  rf_ll_schlst_hpnxt_bin1_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_schlst_hpnxt_bin1_wdata
    ,input  logic [(      16)-1:0] rf_ll_schlst_hpnxt_bin1_rdata

    ,output logic                  rf_ll_schlst_hpnxt_bin1_error

    ,input  logic                  func_ll_schlst_hpnxt_bin2_re
    ,input  logic [(      12)-1:0] func_ll_schlst_hpnxt_bin2_raddr
    ,input  logic [(      12)-1:0] func_ll_schlst_hpnxt_bin2_waddr
    ,input  logic                  func_ll_schlst_hpnxt_bin2_we
    ,input  logic [(      14)-1:0] func_ll_schlst_hpnxt_bin2_wdata
    ,output logic [(      14)-1:0] func_ll_schlst_hpnxt_bin2_rdata

    ,input  logic                  pf_ll_schlst_hpnxt_bin2_re
    ,input  logic [(      12)-1:0] pf_ll_schlst_hpnxt_bin2_raddr
    ,input  logic [(      12)-1:0] pf_ll_schlst_hpnxt_bin2_waddr
    ,input  logic                  pf_ll_schlst_hpnxt_bin2_we
    ,input  logic [(      14)-1:0] pf_ll_schlst_hpnxt_bin2_wdata
    ,output logic [(      14)-1:0] pf_ll_schlst_hpnxt_bin2_rdata

    ,output logic                  rf_ll_schlst_hpnxt_bin2_re
    ,output logic                  rf_ll_schlst_hpnxt_bin2_rclk
    ,output logic                  rf_ll_schlst_hpnxt_bin2_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_schlst_hpnxt_bin2_raddr
    ,output logic [(      11)-1:0] rf_ll_schlst_hpnxt_bin2_waddr
    ,output logic                  rf_ll_schlst_hpnxt_bin2_we
    ,output logic                  rf_ll_schlst_hpnxt_bin2_wclk
    ,output logic                  rf_ll_schlst_hpnxt_bin2_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_schlst_hpnxt_bin2_wdata
    ,input  logic [(      16)-1:0] rf_ll_schlst_hpnxt_bin2_rdata

    ,output logic                  rf_ll_schlst_hpnxt_bin2_error

    ,input  logic                  func_ll_schlst_hpnxt_bin3_re
    ,input  logic [(      12)-1:0] func_ll_schlst_hpnxt_bin3_raddr
    ,input  logic [(      12)-1:0] func_ll_schlst_hpnxt_bin3_waddr
    ,input  logic                  func_ll_schlst_hpnxt_bin3_we
    ,input  logic [(      14)-1:0] func_ll_schlst_hpnxt_bin3_wdata
    ,output logic [(      14)-1:0] func_ll_schlst_hpnxt_bin3_rdata

    ,input  logic                  pf_ll_schlst_hpnxt_bin3_re
    ,input  logic [(      12)-1:0] pf_ll_schlst_hpnxt_bin3_raddr
    ,input  logic [(      12)-1:0] pf_ll_schlst_hpnxt_bin3_waddr
    ,input  logic                  pf_ll_schlst_hpnxt_bin3_we
    ,input  logic [(      14)-1:0] pf_ll_schlst_hpnxt_bin3_wdata
    ,output logic [(      14)-1:0] pf_ll_schlst_hpnxt_bin3_rdata

    ,output logic                  rf_ll_schlst_hpnxt_bin3_re
    ,output logic                  rf_ll_schlst_hpnxt_bin3_rclk
    ,output logic                  rf_ll_schlst_hpnxt_bin3_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_schlst_hpnxt_bin3_raddr
    ,output logic [(      11)-1:0] rf_ll_schlst_hpnxt_bin3_waddr
    ,output logic                  rf_ll_schlst_hpnxt_bin3_we
    ,output logic                  rf_ll_schlst_hpnxt_bin3_wclk
    ,output logic                  rf_ll_schlst_hpnxt_bin3_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_schlst_hpnxt_bin3_wdata
    ,input  logic [(      16)-1:0] rf_ll_schlst_hpnxt_bin3_rdata

    ,output logic                  rf_ll_schlst_hpnxt_bin3_error

    ,input  logic                  func_ll_schlst_tp_bin0_re
    ,input  logic [(       9)-1:0] func_ll_schlst_tp_bin0_raddr
    ,input  logic [(       9)-1:0] func_ll_schlst_tp_bin0_waddr
    ,input  logic                  func_ll_schlst_tp_bin0_we
    ,input  logic [(      14)-1:0] func_ll_schlst_tp_bin0_wdata
    ,output logic [(      14)-1:0] func_ll_schlst_tp_bin0_rdata

    ,input  logic                  pf_ll_schlst_tp_bin0_re
    ,input  logic [(       9)-1:0] pf_ll_schlst_tp_bin0_raddr
    ,input  logic [(       9)-1:0] pf_ll_schlst_tp_bin0_waddr
    ,input  logic                  pf_ll_schlst_tp_bin0_we
    ,input  logic [(      14)-1:0] pf_ll_schlst_tp_bin0_wdata
    ,output logic [(      14)-1:0] pf_ll_schlst_tp_bin0_rdata

    ,output logic                  rf_ll_schlst_tp_bin0_re
    ,output logic                  rf_ll_schlst_tp_bin0_rclk
    ,output logic                  rf_ll_schlst_tp_bin0_rclk_rst_n
    ,output logic [(       9)-1:0] rf_ll_schlst_tp_bin0_raddr
    ,output logic [(       9)-1:0] rf_ll_schlst_tp_bin0_waddr
    ,output logic                  rf_ll_schlst_tp_bin0_we
    ,output logic                  rf_ll_schlst_tp_bin0_wclk
    ,output logic                  rf_ll_schlst_tp_bin0_wclk_rst_n
    ,output logic [(      14)-1:0] rf_ll_schlst_tp_bin0_wdata
    ,input  logic [(      14)-1:0] rf_ll_schlst_tp_bin0_rdata

    ,output logic                  rf_ll_schlst_tp_bin0_error

    ,input  logic                  func_ll_schlst_tp_bin1_re
    ,input  logic [(       9)-1:0] func_ll_schlst_tp_bin1_raddr
    ,input  logic [(       9)-1:0] func_ll_schlst_tp_bin1_waddr
    ,input  logic                  func_ll_schlst_tp_bin1_we
    ,input  logic [(      14)-1:0] func_ll_schlst_tp_bin1_wdata
    ,output logic [(      14)-1:0] func_ll_schlst_tp_bin1_rdata

    ,input  logic                  pf_ll_schlst_tp_bin1_re
    ,input  logic [(       9)-1:0] pf_ll_schlst_tp_bin1_raddr
    ,input  logic [(       9)-1:0] pf_ll_schlst_tp_bin1_waddr
    ,input  logic                  pf_ll_schlst_tp_bin1_we
    ,input  logic [(      14)-1:0] pf_ll_schlst_tp_bin1_wdata
    ,output logic [(      14)-1:0] pf_ll_schlst_tp_bin1_rdata

    ,output logic                  rf_ll_schlst_tp_bin1_re
    ,output logic                  rf_ll_schlst_tp_bin1_rclk
    ,output logic                  rf_ll_schlst_tp_bin1_rclk_rst_n
    ,output logic [(       9)-1:0] rf_ll_schlst_tp_bin1_raddr
    ,output logic [(       9)-1:0] rf_ll_schlst_tp_bin1_waddr
    ,output logic                  rf_ll_schlst_tp_bin1_we
    ,output logic                  rf_ll_schlst_tp_bin1_wclk
    ,output logic                  rf_ll_schlst_tp_bin1_wclk_rst_n
    ,output logic [(      14)-1:0] rf_ll_schlst_tp_bin1_wdata
    ,input  logic [(      14)-1:0] rf_ll_schlst_tp_bin1_rdata

    ,output logic                  rf_ll_schlst_tp_bin1_error

    ,input  logic                  func_ll_schlst_tp_bin2_re
    ,input  logic [(       9)-1:0] func_ll_schlst_tp_bin2_raddr
    ,input  logic [(       9)-1:0] func_ll_schlst_tp_bin2_waddr
    ,input  logic                  func_ll_schlst_tp_bin2_we
    ,input  logic [(      14)-1:0] func_ll_schlst_tp_bin2_wdata
    ,output logic [(      14)-1:0] func_ll_schlst_tp_bin2_rdata

    ,input  logic                  pf_ll_schlst_tp_bin2_re
    ,input  logic [(       9)-1:0] pf_ll_schlst_tp_bin2_raddr
    ,input  logic [(       9)-1:0] pf_ll_schlst_tp_bin2_waddr
    ,input  logic                  pf_ll_schlst_tp_bin2_we
    ,input  logic [(      14)-1:0] pf_ll_schlst_tp_bin2_wdata
    ,output logic [(      14)-1:0] pf_ll_schlst_tp_bin2_rdata

    ,output logic                  rf_ll_schlst_tp_bin2_re
    ,output logic                  rf_ll_schlst_tp_bin2_rclk
    ,output logic                  rf_ll_schlst_tp_bin2_rclk_rst_n
    ,output logic [(       9)-1:0] rf_ll_schlst_tp_bin2_raddr
    ,output logic [(       9)-1:0] rf_ll_schlst_tp_bin2_waddr
    ,output logic                  rf_ll_schlst_tp_bin2_we
    ,output logic                  rf_ll_schlst_tp_bin2_wclk
    ,output logic                  rf_ll_schlst_tp_bin2_wclk_rst_n
    ,output logic [(      14)-1:0] rf_ll_schlst_tp_bin2_wdata
    ,input  logic [(      14)-1:0] rf_ll_schlst_tp_bin2_rdata

    ,output logic                  rf_ll_schlst_tp_bin2_error

    ,input  logic                  func_ll_schlst_tp_bin3_re
    ,input  logic [(       9)-1:0] func_ll_schlst_tp_bin3_raddr
    ,input  logic [(       9)-1:0] func_ll_schlst_tp_bin3_waddr
    ,input  logic                  func_ll_schlst_tp_bin3_we
    ,input  logic [(      14)-1:0] func_ll_schlst_tp_bin3_wdata
    ,output logic [(      14)-1:0] func_ll_schlst_tp_bin3_rdata

    ,input  logic                  pf_ll_schlst_tp_bin3_re
    ,input  logic [(       9)-1:0] pf_ll_schlst_tp_bin3_raddr
    ,input  logic [(       9)-1:0] pf_ll_schlst_tp_bin3_waddr
    ,input  logic                  pf_ll_schlst_tp_bin3_we
    ,input  logic [(      14)-1:0] pf_ll_schlst_tp_bin3_wdata
    ,output logic [(      14)-1:0] pf_ll_schlst_tp_bin3_rdata

    ,output logic                  rf_ll_schlst_tp_bin3_re
    ,output logic                  rf_ll_schlst_tp_bin3_rclk
    ,output logic                  rf_ll_schlst_tp_bin3_rclk_rst_n
    ,output logic [(       9)-1:0] rf_ll_schlst_tp_bin3_raddr
    ,output logic [(       9)-1:0] rf_ll_schlst_tp_bin3_waddr
    ,output logic                  rf_ll_schlst_tp_bin3_we
    ,output logic                  rf_ll_schlst_tp_bin3_wclk
    ,output logic                  rf_ll_schlst_tp_bin3_wclk_rst_n
    ,output logic [(      14)-1:0] rf_ll_schlst_tp_bin3_wdata
    ,input  logic [(      14)-1:0] rf_ll_schlst_tp_bin3_rdata

    ,output logic                  rf_ll_schlst_tp_bin3_error

    ,input  logic                  func_ll_schlst_tpprv_bin0_re
    ,input  logic [(      12)-1:0] func_ll_schlst_tpprv_bin0_raddr
    ,input  logic [(      12)-1:0] func_ll_schlst_tpprv_bin0_waddr
    ,input  logic                  func_ll_schlst_tpprv_bin0_we
    ,input  logic [(      14)-1:0] func_ll_schlst_tpprv_bin0_wdata
    ,output logic [(      14)-1:0] func_ll_schlst_tpprv_bin0_rdata

    ,input  logic                  pf_ll_schlst_tpprv_bin0_re
    ,input  logic [(      12)-1:0] pf_ll_schlst_tpprv_bin0_raddr
    ,input  logic [(      12)-1:0] pf_ll_schlst_tpprv_bin0_waddr
    ,input  logic                  pf_ll_schlst_tpprv_bin0_we
    ,input  logic [(      14)-1:0] pf_ll_schlst_tpprv_bin0_wdata
    ,output logic [(      14)-1:0] pf_ll_schlst_tpprv_bin0_rdata

    ,output logic                  rf_ll_schlst_tpprv_bin0_re
    ,output logic                  rf_ll_schlst_tpprv_bin0_rclk
    ,output logic                  rf_ll_schlst_tpprv_bin0_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_schlst_tpprv_bin0_raddr
    ,output logic [(      11)-1:0] rf_ll_schlst_tpprv_bin0_waddr
    ,output logic                  rf_ll_schlst_tpprv_bin0_we
    ,output logic                  rf_ll_schlst_tpprv_bin0_wclk
    ,output logic                  rf_ll_schlst_tpprv_bin0_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_schlst_tpprv_bin0_wdata
    ,input  logic [(      16)-1:0] rf_ll_schlst_tpprv_bin0_rdata

    ,output logic                  rf_ll_schlst_tpprv_bin0_error

    ,input  logic                  func_ll_schlst_tpprv_bin1_re
    ,input  logic [(      12)-1:0] func_ll_schlst_tpprv_bin1_raddr
    ,input  logic [(      12)-1:0] func_ll_schlst_tpprv_bin1_waddr
    ,input  logic                  func_ll_schlst_tpprv_bin1_we
    ,input  logic [(      14)-1:0] func_ll_schlst_tpprv_bin1_wdata
    ,output logic [(      14)-1:0] func_ll_schlst_tpprv_bin1_rdata

    ,input  logic                  pf_ll_schlst_tpprv_bin1_re
    ,input  logic [(      12)-1:0] pf_ll_schlst_tpprv_bin1_raddr
    ,input  logic [(      12)-1:0] pf_ll_schlst_tpprv_bin1_waddr
    ,input  logic                  pf_ll_schlst_tpprv_bin1_we
    ,input  logic [(      14)-1:0] pf_ll_schlst_tpprv_bin1_wdata
    ,output logic [(      14)-1:0] pf_ll_schlst_tpprv_bin1_rdata

    ,output logic                  rf_ll_schlst_tpprv_bin1_re
    ,output logic                  rf_ll_schlst_tpprv_bin1_rclk
    ,output logic                  rf_ll_schlst_tpprv_bin1_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_schlst_tpprv_bin1_raddr
    ,output logic [(      11)-1:0] rf_ll_schlst_tpprv_bin1_waddr
    ,output logic                  rf_ll_schlst_tpprv_bin1_we
    ,output logic                  rf_ll_schlst_tpprv_bin1_wclk
    ,output logic                  rf_ll_schlst_tpprv_bin1_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_schlst_tpprv_bin1_wdata
    ,input  logic [(      16)-1:0] rf_ll_schlst_tpprv_bin1_rdata

    ,output logic                  rf_ll_schlst_tpprv_bin1_error

    ,input  logic                  func_ll_schlst_tpprv_bin2_re
    ,input  logic [(      12)-1:0] func_ll_schlst_tpprv_bin2_raddr
    ,input  logic [(      12)-1:0] func_ll_schlst_tpprv_bin2_waddr
    ,input  logic                  func_ll_schlst_tpprv_bin2_we
    ,input  logic [(      14)-1:0] func_ll_schlst_tpprv_bin2_wdata
    ,output logic [(      14)-1:0] func_ll_schlst_tpprv_bin2_rdata

    ,input  logic                  pf_ll_schlst_tpprv_bin2_re
    ,input  logic [(      12)-1:0] pf_ll_schlst_tpprv_bin2_raddr
    ,input  logic [(      12)-1:0] pf_ll_schlst_tpprv_bin2_waddr
    ,input  logic                  pf_ll_schlst_tpprv_bin2_we
    ,input  logic [(      14)-1:0] pf_ll_schlst_tpprv_bin2_wdata
    ,output logic [(      14)-1:0] pf_ll_schlst_tpprv_bin2_rdata

    ,output logic                  rf_ll_schlst_tpprv_bin2_re
    ,output logic                  rf_ll_schlst_tpprv_bin2_rclk
    ,output logic                  rf_ll_schlst_tpprv_bin2_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_schlst_tpprv_bin2_raddr
    ,output logic [(      11)-1:0] rf_ll_schlst_tpprv_bin2_waddr
    ,output logic                  rf_ll_schlst_tpprv_bin2_we
    ,output logic                  rf_ll_schlst_tpprv_bin2_wclk
    ,output logic                  rf_ll_schlst_tpprv_bin2_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_schlst_tpprv_bin2_wdata
    ,input  logic [(      16)-1:0] rf_ll_schlst_tpprv_bin2_rdata

    ,output logic                  rf_ll_schlst_tpprv_bin2_error

    ,input  logic                  func_ll_schlst_tpprv_bin3_re
    ,input  logic [(      12)-1:0] func_ll_schlst_tpprv_bin3_raddr
    ,input  logic [(      12)-1:0] func_ll_schlst_tpprv_bin3_waddr
    ,input  logic                  func_ll_schlst_tpprv_bin3_we
    ,input  logic [(      14)-1:0] func_ll_schlst_tpprv_bin3_wdata
    ,output logic [(      14)-1:0] func_ll_schlst_tpprv_bin3_rdata

    ,input  logic                  pf_ll_schlst_tpprv_bin3_re
    ,input  logic [(      12)-1:0] pf_ll_schlst_tpprv_bin3_raddr
    ,input  logic [(      12)-1:0] pf_ll_schlst_tpprv_bin3_waddr
    ,input  logic                  pf_ll_schlst_tpprv_bin3_we
    ,input  logic [(      14)-1:0] pf_ll_schlst_tpprv_bin3_wdata
    ,output logic [(      14)-1:0] pf_ll_schlst_tpprv_bin3_rdata

    ,output logic                  rf_ll_schlst_tpprv_bin3_re
    ,output logic                  rf_ll_schlst_tpprv_bin3_rclk
    ,output logic                  rf_ll_schlst_tpprv_bin3_rclk_rst_n
    ,output logic [(      11)-1:0] rf_ll_schlst_tpprv_bin3_raddr
    ,output logic [(      11)-1:0] rf_ll_schlst_tpprv_bin3_waddr
    ,output logic                  rf_ll_schlst_tpprv_bin3_we
    ,output logic                  rf_ll_schlst_tpprv_bin3_wclk
    ,output logic                  rf_ll_schlst_tpprv_bin3_wclk_rst_n
    ,output logic [(      16)-1:0] rf_ll_schlst_tpprv_bin3_wdata
    ,input  logic [(      16)-1:0] rf_ll_schlst_tpprv_bin3_rdata

    ,output logic                  rf_ll_schlst_tpprv_bin3_error

    ,input  logic                  func_ll_slst_cnt_re
    ,input  logic [(       9)-1:0] func_ll_slst_cnt_raddr
    ,input  logic [(       9)-1:0] func_ll_slst_cnt_waddr
    ,input  logic                  func_ll_slst_cnt_we
    ,input  logic [(      56)-1:0] func_ll_slst_cnt_wdata
    ,output logic [(      56)-1:0] func_ll_slst_cnt_rdata

    ,input  logic                  pf_ll_slst_cnt_re
    ,input  logic [(       9)-1:0] pf_ll_slst_cnt_raddr
    ,input  logic [(       9)-1:0] pf_ll_slst_cnt_waddr
    ,input  logic                  pf_ll_slst_cnt_we
    ,input  logic [(      56)-1:0] pf_ll_slst_cnt_wdata
    ,output logic [(      56)-1:0] pf_ll_slst_cnt_rdata

    ,output logic                  rf_ll_slst_cnt_re
    ,output logic                  rf_ll_slst_cnt_rclk
    ,output logic                  rf_ll_slst_cnt_rclk_rst_n
    ,output logic [(       9)-1:0] rf_ll_slst_cnt_raddr
    ,output logic [(       9)-1:0] rf_ll_slst_cnt_waddr
    ,output logic                  rf_ll_slst_cnt_we
    ,output logic                  rf_ll_slst_cnt_wclk
    ,output logic                  rf_ll_slst_cnt_wclk_rst_n
    ,output logic [(      60)-1:0] rf_ll_slst_cnt_wdata
    ,input  logic [(      60)-1:0] rf_ll_slst_cnt_rdata

    ,output logic                  rf_ll_slst_cnt_error

    ,input  logic                  func_qid_rdylst_clamp_re
    ,input  logic [(       7)-1:0] func_qid_rdylst_clamp_raddr
    ,input  logic [(       7)-1:0] func_qid_rdylst_clamp_waddr
    ,input  logic                  func_qid_rdylst_clamp_we
    ,input  logic [(       6)-1:0] func_qid_rdylst_clamp_wdata
    ,output logic [(       6)-1:0] func_qid_rdylst_clamp_rdata

    ,input  logic                  pf_qid_rdylst_clamp_re
    ,input  logic [(       7)-1:0] pf_qid_rdylst_clamp_raddr
    ,input  logic [(       7)-1:0] pf_qid_rdylst_clamp_waddr
    ,input  logic                  pf_qid_rdylst_clamp_we
    ,input  logic [(       6)-1:0] pf_qid_rdylst_clamp_wdata
    ,output logic [(       6)-1:0] pf_qid_rdylst_clamp_rdata

    ,output logic                  rf_qid_rdylst_clamp_re
    ,output logic                  rf_qid_rdylst_clamp_rclk
    ,output logic                  rf_qid_rdylst_clamp_rclk_rst_n
    ,output logic [(       5)-1:0] rf_qid_rdylst_clamp_raddr
    ,output logic [(       5)-1:0] rf_qid_rdylst_clamp_waddr
    ,output logic                  rf_qid_rdylst_clamp_we
    ,output logic                  rf_qid_rdylst_clamp_wclk
    ,output logic                  rf_qid_rdylst_clamp_wclk_rst_n
    ,output logic [(       6)-1:0] rf_qid_rdylst_clamp_wdata
    ,input  logic [(       6)-1:0] rf_qid_rdylst_clamp_rdata

    ,output logic                  rf_qid_rdylst_clamp_error

);

logic [(       2)-1:0] rf_aqed_qid2cqidix_raddr_nc ;
logic [(       2)-1:0] rf_aqed_qid2cqidix_waddr_nc ;

logic        rf_aqed_qid2cqidix_rdata_error;

hqm_AW_rfrw_access #( 
         .DEPTH               (32)
        ,.DWIDTH              (528)
        ,.AWIDTHPAD           (2)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_aqed_qid2cqidix (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_aqed_qid2cqidix_re)
        ,.func_mem_addr       (func_aqed_qid2cqidix_addr)
        ,.func_mem_we         (func_aqed_qid2cqidix_we)
        ,.func_mem_wdata      (func_aqed_qid2cqidix_wdata)
        ,.func_mem_rdata      (func_aqed_qid2cqidix_rdata)

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

        ,.pf_mem_re           (pf_aqed_qid2cqidix_re)
        ,.pf_mem_addr         (pf_aqed_qid2cqidix_addr)
        ,.pf_mem_we           (pf_aqed_qid2cqidix_we)
        ,.pf_mem_wdata        (pf_aqed_qid2cqidix_wdata)
        ,.pf_mem_rdata        (pf_aqed_qid2cqidix_rdata)

        ,.mem_wclk            (rf_aqed_qid2cqidix_wclk)
        ,.mem_rclk            (rf_aqed_qid2cqidix_rclk)
        ,.mem_wclk_rst_n      (rf_aqed_qid2cqidix_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_aqed_qid2cqidix_rclk_rst_n)
        ,.mem_re              (rf_aqed_qid2cqidix_re)
        ,.mem_raddr           ({rf_aqed_qid2cqidix_raddr_nc , rf_aqed_qid2cqidix_raddr})
        ,.mem_waddr           ({rf_aqed_qid2cqidix_waddr_nc , rf_aqed_qid2cqidix_waddr})
        ,.mem_we              (rf_aqed_qid2cqidix_we)
        ,.mem_wdata           (rf_aqed_qid2cqidix_wdata)
        ,.mem_rdata           (rf_aqed_qid2cqidix_rdata)

        ,.mem_rdata_error     (rf_aqed_qid2cqidix_rdata_error)
        ,.error               (rf_aqed_qid2cqidix_error)
);

logic        rf_atm_fifo_ap_aqed_rdata_error;

logic        cfg_mem_ack_atm_fifo_ap_aqed_nc;
logic [31:0] cfg_mem_rdata_atm_fifo_ap_aqed_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (16)
        ,.DWIDTH              (45)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_atm_fifo_ap_aqed (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_atm_fifo_ap_aqed_re)
        ,.func_mem_raddr      (func_atm_fifo_ap_aqed_raddr)
        ,.func_mem_waddr      (func_atm_fifo_ap_aqed_waddr)
        ,.func_mem_we         (func_atm_fifo_ap_aqed_we)
        ,.func_mem_wdata      (func_atm_fifo_ap_aqed_wdata)
        ,.func_mem_rdata      (func_atm_fifo_ap_aqed_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_atm_fifo_ap_aqed_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_atm_fifo_ap_aqed_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_atm_fifo_ap_aqed_re)
        ,.pf_mem_raddr        (pf_atm_fifo_ap_aqed_raddr)
        ,.pf_mem_waddr        (pf_atm_fifo_ap_aqed_waddr)
        ,.pf_mem_we           (pf_atm_fifo_ap_aqed_we)
        ,.pf_mem_wdata        (pf_atm_fifo_ap_aqed_wdata)
        ,.pf_mem_rdata        (pf_atm_fifo_ap_aqed_rdata)

        ,.mem_wclk            (rf_atm_fifo_ap_aqed_wclk)
        ,.mem_rclk            (rf_atm_fifo_ap_aqed_rclk)
        ,.mem_wclk_rst_n      (rf_atm_fifo_ap_aqed_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_atm_fifo_ap_aqed_rclk_rst_n)
        ,.mem_re              (rf_atm_fifo_ap_aqed_re)
        ,.mem_raddr           (rf_atm_fifo_ap_aqed_raddr)
        ,.mem_waddr           (rf_atm_fifo_ap_aqed_waddr)
        ,.mem_we              (rf_atm_fifo_ap_aqed_we)
        ,.mem_wdata           (rf_atm_fifo_ap_aqed_wdata)
        ,.mem_rdata           (rf_atm_fifo_ap_aqed_rdata)

        ,.mem_rdata_error     (rf_atm_fifo_ap_aqed_rdata_error)
        ,.error               (rf_atm_fifo_ap_aqed_error)
);

logic        rf_atm_fifo_aqed_ap_enq_rdata_error;

logic        cfg_mem_ack_atm_fifo_aqed_ap_enq_nc;
logic [31:0] cfg_mem_rdata_atm_fifo_aqed_ap_enq_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (32)
        ,.DWIDTH              (24)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_atm_fifo_aqed_ap_enq (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_atm_fifo_aqed_ap_enq_re)
        ,.func_mem_raddr      (func_atm_fifo_aqed_ap_enq_raddr)
        ,.func_mem_waddr      (func_atm_fifo_aqed_ap_enq_waddr)
        ,.func_mem_we         (func_atm_fifo_aqed_ap_enq_we)
        ,.func_mem_wdata      (func_atm_fifo_aqed_ap_enq_wdata)
        ,.func_mem_rdata      (func_atm_fifo_aqed_ap_enq_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_atm_fifo_aqed_ap_enq_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_atm_fifo_aqed_ap_enq_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_atm_fifo_aqed_ap_enq_re)
        ,.pf_mem_raddr        (pf_atm_fifo_aqed_ap_enq_raddr)
        ,.pf_mem_waddr        (pf_atm_fifo_aqed_ap_enq_waddr)
        ,.pf_mem_we           (pf_atm_fifo_aqed_ap_enq_we)
        ,.pf_mem_wdata        (pf_atm_fifo_aqed_ap_enq_wdata)
        ,.pf_mem_rdata        (pf_atm_fifo_aqed_ap_enq_rdata)

        ,.mem_wclk            (rf_atm_fifo_aqed_ap_enq_wclk)
        ,.mem_rclk            (rf_atm_fifo_aqed_ap_enq_rclk)
        ,.mem_wclk_rst_n      (rf_atm_fifo_aqed_ap_enq_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_atm_fifo_aqed_ap_enq_rclk_rst_n)
        ,.mem_re              (rf_atm_fifo_aqed_ap_enq_re)
        ,.mem_raddr           (rf_atm_fifo_aqed_ap_enq_raddr)
        ,.mem_waddr           (rf_atm_fifo_aqed_ap_enq_waddr)
        ,.mem_we              (rf_atm_fifo_aqed_ap_enq_we)
        ,.mem_wdata           (rf_atm_fifo_aqed_ap_enq_wdata)
        ,.mem_rdata           (rf_atm_fifo_aqed_ap_enq_rdata)

        ,.mem_rdata_error     (rf_atm_fifo_aqed_ap_enq_rdata_error)
        ,.error               (rf_atm_fifo_aqed_ap_enq_error)
);

logic [(       1)-1:0] rf_fid2cqqidix_raddr_nc ;
logic [(       1)-1:0] rf_fid2cqqidix_waddr_nc ;

logic        rf_fid2cqqidix_rdata_error;

logic        cfg_mem_ack_fid2cqqidix_nc;
logic [31:0] cfg_mem_rdata_fid2cqqidix_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (10)
        ,.AWIDTHPAD           (1)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (2)
) i_fid2cqqidix (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_fid2cqqidix_re)
        ,.func_mem_raddr      (func_fid2cqqidix_raddr)
        ,.func_mem_waddr      (func_fid2cqqidix_waddr)
        ,.func_mem_we         (func_fid2cqqidix_we)
        ,.func_mem_wdata      (func_fid2cqqidix_wdata)
        ,.func_mem_rdata      (func_fid2cqqidix_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_fid2cqqidix_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_fid2cqqidix_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_fid2cqqidix_re)
        ,.pf_mem_raddr        (pf_fid2cqqidix_raddr)
        ,.pf_mem_waddr        (pf_fid2cqqidix_waddr)
        ,.pf_mem_we           (pf_fid2cqqidix_we)
        ,.pf_mem_wdata        (pf_fid2cqqidix_wdata)
        ,.pf_mem_rdata        (pf_fid2cqqidix_rdata)

        ,.mem_wclk            (rf_fid2cqqidix_wclk)
        ,.mem_rclk            (rf_fid2cqqidix_rclk)
        ,.mem_wclk_rst_n      (rf_fid2cqqidix_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_fid2cqqidix_rclk_rst_n)
        ,.mem_re              (rf_fid2cqqidix_re)
        ,.mem_raddr           ({rf_fid2cqqidix_raddr_nc , rf_fid2cqqidix_raddr})
        ,.mem_waddr           ({rf_fid2cqqidix_waddr_nc , rf_fid2cqqidix_waddr})
        ,.mem_we              (rf_fid2cqqidix_we)
        ,.mem_wdata           (rf_fid2cqqidix_wdata)
        ,.mem_rdata           (rf_fid2cqqidix_rdata)

        ,.mem_rdata_error     (rf_fid2cqqidix_rdata_error)
        ,.error               (rf_fid2cqqidix_error)
);

logic [(       1)-1:0] rf_ll_enq_cnt_r_bin0_dup0_raddr_nc ;
logic [(       1)-1:0] rf_ll_enq_cnt_r_bin0_dup0_waddr_nc ;

logic        rf_ll_enq_cnt_r_bin0_dup0_rdata_error;

logic        cfg_mem_ack_ll_enq_cnt_r_bin0_dup0_nc;
logic [31:0] cfg_mem_rdata_ll_enq_cnt_r_bin0_dup0_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (14)
        ,.AWIDTHPAD           (1)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (2)
) i_ll_enq_cnt_r_bin0_dup0 (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_ll_enq_cnt_r_bin0_dup0_re)
        ,.func_mem_raddr      (func_ll_enq_cnt_r_bin0_dup0_raddr)
        ,.func_mem_waddr      (func_ll_enq_cnt_r_bin0_dup0_waddr)
        ,.func_mem_we         (func_ll_enq_cnt_r_bin0_dup0_we)
        ,.func_mem_wdata      (func_ll_enq_cnt_r_bin0_dup0_wdata)
        ,.func_mem_rdata      (func_ll_enq_cnt_r_bin0_dup0_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_ll_enq_cnt_r_bin0_dup0_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_ll_enq_cnt_r_bin0_dup0_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_ll_enq_cnt_r_bin0_dup0_re)
        ,.pf_mem_raddr        (pf_ll_enq_cnt_r_bin0_dup0_raddr)
        ,.pf_mem_waddr        (pf_ll_enq_cnt_r_bin0_dup0_waddr)
        ,.pf_mem_we           (pf_ll_enq_cnt_r_bin0_dup0_we)
        ,.pf_mem_wdata        (pf_ll_enq_cnt_r_bin0_dup0_wdata)
        ,.pf_mem_rdata        (pf_ll_enq_cnt_r_bin0_dup0_rdata)

        ,.mem_wclk            (rf_ll_enq_cnt_r_bin0_dup0_wclk)
        ,.mem_rclk            (rf_ll_enq_cnt_r_bin0_dup0_rclk)
        ,.mem_wclk_rst_n      (rf_ll_enq_cnt_r_bin0_dup0_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_ll_enq_cnt_r_bin0_dup0_rclk_rst_n)
        ,.mem_re              (rf_ll_enq_cnt_r_bin0_dup0_re)
        ,.mem_raddr           ({rf_ll_enq_cnt_r_bin0_dup0_raddr_nc , rf_ll_enq_cnt_r_bin0_dup0_raddr})
        ,.mem_waddr           ({rf_ll_enq_cnt_r_bin0_dup0_waddr_nc , rf_ll_enq_cnt_r_bin0_dup0_waddr})
        ,.mem_we              (rf_ll_enq_cnt_r_bin0_dup0_we)
        ,.mem_wdata           (rf_ll_enq_cnt_r_bin0_dup0_wdata)
        ,.mem_rdata           (rf_ll_enq_cnt_r_bin0_dup0_rdata)

        ,.mem_rdata_error     (rf_ll_enq_cnt_r_bin0_dup0_rdata_error)
        ,.error               (rf_ll_enq_cnt_r_bin0_dup0_error)
);

logic [(       1)-1:0] rf_ll_enq_cnt_r_bin0_dup1_raddr_nc ;
logic [(       1)-1:0] rf_ll_enq_cnt_r_bin0_dup1_waddr_nc ;

logic        rf_ll_enq_cnt_r_bin0_dup1_rdata_error;

logic        cfg_mem_ack_ll_enq_cnt_r_bin0_dup1_nc;
logic [31:0] cfg_mem_rdata_ll_enq_cnt_r_bin0_dup1_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (14)
        ,.AWIDTHPAD           (1)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (2)
) i_ll_enq_cnt_r_bin0_dup1 (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_ll_enq_cnt_r_bin0_dup1_re)
        ,.func_mem_raddr      (func_ll_enq_cnt_r_bin0_dup1_raddr)
        ,.func_mem_waddr      (func_ll_enq_cnt_r_bin0_dup1_waddr)
        ,.func_mem_we         (func_ll_enq_cnt_r_bin0_dup1_we)
        ,.func_mem_wdata      (func_ll_enq_cnt_r_bin0_dup1_wdata)
        ,.func_mem_rdata      (func_ll_enq_cnt_r_bin0_dup1_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_ll_enq_cnt_r_bin0_dup1_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_ll_enq_cnt_r_bin0_dup1_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_ll_enq_cnt_r_bin0_dup1_re)
        ,.pf_mem_raddr        (pf_ll_enq_cnt_r_bin0_dup1_raddr)
        ,.pf_mem_waddr        (pf_ll_enq_cnt_r_bin0_dup1_waddr)
        ,.pf_mem_we           (pf_ll_enq_cnt_r_bin0_dup1_we)
        ,.pf_mem_wdata        (pf_ll_enq_cnt_r_bin0_dup1_wdata)
        ,.pf_mem_rdata        (pf_ll_enq_cnt_r_bin0_dup1_rdata)

        ,.mem_wclk            (rf_ll_enq_cnt_r_bin0_dup1_wclk)
        ,.mem_rclk            (rf_ll_enq_cnt_r_bin0_dup1_rclk)
        ,.mem_wclk_rst_n      (rf_ll_enq_cnt_r_bin0_dup1_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_ll_enq_cnt_r_bin0_dup1_rclk_rst_n)
        ,.mem_re              (rf_ll_enq_cnt_r_bin0_dup1_re)
        ,.mem_raddr           ({rf_ll_enq_cnt_r_bin0_dup1_raddr_nc , rf_ll_enq_cnt_r_bin0_dup1_raddr})
        ,.mem_waddr           ({rf_ll_enq_cnt_r_bin0_dup1_waddr_nc , rf_ll_enq_cnt_r_bin0_dup1_waddr})
        ,.mem_we              (rf_ll_enq_cnt_r_bin0_dup1_we)
        ,.mem_wdata           (rf_ll_enq_cnt_r_bin0_dup1_wdata)
        ,.mem_rdata           (rf_ll_enq_cnt_r_bin0_dup1_rdata)

        ,.mem_rdata_error     (rf_ll_enq_cnt_r_bin0_dup1_rdata_error)
        ,.error               (rf_ll_enq_cnt_r_bin0_dup1_error)
);

logic [(       1)-1:0] rf_ll_enq_cnt_r_bin0_dup2_raddr_nc ;
logic [(       1)-1:0] rf_ll_enq_cnt_r_bin0_dup2_waddr_nc ;

logic        rf_ll_enq_cnt_r_bin0_dup2_rdata_error;

logic        cfg_mem_ack_ll_enq_cnt_r_bin0_dup2_nc;
logic [31:0] cfg_mem_rdata_ll_enq_cnt_r_bin0_dup2_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (14)
        ,.AWIDTHPAD           (1)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (2)
) i_ll_enq_cnt_r_bin0_dup2 (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_ll_enq_cnt_r_bin0_dup2_re)
        ,.func_mem_raddr      (func_ll_enq_cnt_r_bin0_dup2_raddr)
        ,.func_mem_waddr      (func_ll_enq_cnt_r_bin0_dup2_waddr)
        ,.func_mem_we         (func_ll_enq_cnt_r_bin0_dup2_we)
        ,.func_mem_wdata      (func_ll_enq_cnt_r_bin0_dup2_wdata)
        ,.func_mem_rdata      (func_ll_enq_cnt_r_bin0_dup2_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_ll_enq_cnt_r_bin0_dup2_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_ll_enq_cnt_r_bin0_dup2_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_ll_enq_cnt_r_bin0_dup2_re)
        ,.pf_mem_raddr        (pf_ll_enq_cnt_r_bin0_dup2_raddr)
        ,.pf_mem_waddr        (pf_ll_enq_cnt_r_bin0_dup2_waddr)
        ,.pf_mem_we           (pf_ll_enq_cnt_r_bin0_dup2_we)
        ,.pf_mem_wdata        (pf_ll_enq_cnt_r_bin0_dup2_wdata)
        ,.pf_mem_rdata        (pf_ll_enq_cnt_r_bin0_dup2_rdata)

        ,.mem_wclk            (rf_ll_enq_cnt_r_bin0_dup2_wclk)
        ,.mem_rclk            (rf_ll_enq_cnt_r_bin0_dup2_rclk)
        ,.mem_wclk_rst_n      (rf_ll_enq_cnt_r_bin0_dup2_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_ll_enq_cnt_r_bin0_dup2_rclk_rst_n)
        ,.mem_re              (rf_ll_enq_cnt_r_bin0_dup2_re)
        ,.mem_raddr           ({rf_ll_enq_cnt_r_bin0_dup2_raddr_nc , rf_ll_enq_cnt_r_bin0_dup2_raddr})
        ,.mem_waddr           ({rf_ll_enq_cnt_r_bin0_dup2_waddr_nc , rf_ll_enq_cnt_r_bin0_dup2_waddr})
        ,.mem_we              (rf_ll_enq_cnt_r_bin0_dup2_we)
        ,.mem_wdata           (rf_ll_enq_cnt_r_bin0_dup2_wdata)
        ,.mem_rdata           (rf_ll_enq_cnt_r_bin0_dup2_rdata)

        ,.mem_rdata_error     (rf_ll_enq_cnt_r_bin0_dup2_rdata_error)
        ,.error               (rf_ll_enq_cnt_r_bin0_dup2_error)
);

logic [(       1)-1:0] rf_ll_enq_cnt_r_bin0_dup3_raddr_nc ;
logic [(       1)-1:0] rf_ll_enq_cnt_r_bin0_dup3_waddr_nc ;

logic        rf_ll_enq_cnt_r_bin0_dup3_rdata_error;

logic        cfg_mem_ack_ll_enq_cnt_r_bin0_dup3_nc;
logic [31:0] cfg_mem_rdata_ll_enq_cnt_r_bin0_dup3_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (14)
        ,.AWIDTHPAD           (1)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (2)
) i_ll_enq_cnt_r_bin0_dup3 (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_ll_enq_cnt_r_bin0_dup3_re)
        ,.func_mem_raddr      (func_ll_enq_cnt_r_bin0_dup3_raddr)
        ,.func_mem_waddr      (func_ll_enq_cnt_r_bin0_dup3_waddr)
        ,.func_mem_we         (func_ll_enq_cnt_r_bin0_dup3_we)
        ,.func_mem_wdata      (func_ll_enq_cnt_r_bin0_dup3_wdata)
        ,.func_mem_rdata      (func_ll_enq_cnt_r_bin0_dup3_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_ll_enq_cnt_r_bin0_dup3_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_ll_enq_cnt_r_bin0_dup3_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_ll_enq_cnt_r_bin0_dup3_re)
        ,.pf_mem_raddr        (pf_ll_enq_cnt_r_bin0_dup3_raddr)
        ,.pf_mem_waddr        (pf_ll_enq_cnt_r_bin0_dup3_waddr)
        ,.pf_mem_we           (pf_ll_enq_cnt_r_bin0_dup3_we)
        ,.pf_mem_wdata        (pf_ll_enq_cnt_r_bin0_dup3_wdata)
        ,.pf_mem_rdata        (pf_ll_enq_cnt_r_bin0_dup3_rdata)

        ,.mem_wclk            (rf_ll_enq_cnt_r_bin0_dup3_wclk)
        ,.mem_rclk            (rf_ll_enq_cnt_r_bin0_dup3_rclk)
        ,.mem_wclk_rst_n      (rf_ll_enq_cnt_r_bin0_dup3_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_ll_enq_cnt_r_bin0_dup3_rclk_rst_n)
        ,.mem_re              (rf_ll_enq_cnt_r_bin0_dup3_re)
        ,.mem_raddr           ({rf_ll_enq_cnt_r_bin0_dup3_raddr_nc , rf_ll_enq_cnt_r_bin0_dup3_raddr})
        ,.mem_waddr           ({rf_ll_enq_cnt_r_bin0_dup3_waddr_nc , rf_ll_enq_cnt_r_bin0_dup3_waddr})
        ,.mem_we              (rf_ll_enq_cnt_r_bin0_dup3_we)
        ,.mem_wdata           (rf_ll_enq_cnt_r_bin0_dup3_wdata)
        ,.mem_rdata           (rf_ll_enq_cnt_r_bin0_dup3_rdata)

        ,.mem_rdata_error     (rf_ll_enq_cnt_r_bin0_dup3_rdata_error)
        ,.error               (rf_ll_enq_cnt_r_bin0_dup3_error)
);

logic [(       1)-1:0] rf_ll_enq_cnt_r_bin1_dup0_raddr_nc ;
logic [(       1)-1:0] rf_ll_enq_cnt_r_bin1_dup0_waddr_nc ;

logic        rf_ll_enq_cnt_r_bin1_dup0_rdata_error;

logic        cfg_mem_ack_ll_enq_cnt_r_bin1_dup0_nc;
logic [31:0] cfg_mem_rdata_ll_enq_cnt_r_bin1_dup0_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (14)
        ,.AWIDTHPAD           (1)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (2)
) i_ll_enq_cnt_r_bin1_dup0 (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_ll_enq_cnt_r_bin1_dup0_re)
        ,.func_mem_raddr      (func_ll_enq_cnt_r_bin1_dup0_raddr)
        ,.func_mem_waddr      (func_ll_enq_cnt_r_bin1_dup0_waddr)
        ,.func_mem_we         (func_ll_enq_cnt_r_bin1_dup0_we)
        ,.func_mem_wdata      (func_ll_enq_cnt_r_bin1_dup0_wdata)
        ,.func_mem_rdata      (func_ll_enq_cnt_r_bin1_dup0_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_ll_enq_cnt_r_bin1_dup0_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_ll_enq_cnt_r_bin1_dup0_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_ll_enq_cnt_r_bin1_dup0_re)
        ,.pf_mem_raddr        (pf_ll_enq_cnt_r_bin1_dup0_raddr)
        ,.pf_mem_waddr        (pf_ll_enq_cnt_r_bin1_dup0_waddr)
        ,.pf_mem_we           (pf_ll_enq_cnt_r_bin1_dup0_we)
        ,.pf_mem_wdata        (pf_ll_enq_cnt_r_bin1_dup0_wdata)
        ,.pf_mem_rdata        (pf_ll_enq_cnt_r_bin1_dup0_rdata)

        ,.mem_wclk            (rf_ll_enq_cnt_r_bin1_dup0_wclk)
        ,.mem_rclk            (rf_ll_enq_cnt_r_bin1_dup0_rclk)
        ,.mem_wclk_rst_n      (rf_ll_enq_cnt_r_bin1_dup0_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_ll_enq_cnt_r_bin1_dup0_rclk_rst_n)
        ,.mem_re              (rf_ll_enq_cnt_r_bin1_dup0_re)
        ,.mem_raddr           ({rf_ll_enq_cnt_r_bin1_dup0_raddr_nc , rf_ll_enq_cnt_r_bin1_dup0_raddr})
        ,.mem_waddr           ({rf_ll_enq_cnt_r_bin1_dup0_waddr_nc , rf_ll_enq_cnt_r_bin1_dup0_waddr})
        ,.mem_we              (rf_ll_enq_cnt_r_bin1_dup0_we)
        ,.mem_wdata           (rf_ll_enq_cnt_r_bin1_dup0_wdata)
        ,.mem_rdata           (rf_ll_enq_cnt_r_bin1_dup0_rdata)

        ,.mem_rdata_error     (rf_ll_enq_cnt_r_bin1_dup0_rdata_error)
        ,.error               (rf_ll_enq_cnt_r_bin1_dup0_error)
);

logic [(       1)-1:0] rf_ll_enq_cnt_r_bin1_dup1_raddr_nc ;
logic [(       1)-1:0] rf_ll_enq_cnt_r_bin1_dup1_waddr_nc ;

logic        rf_ll_enq_cnt_r_bin1_dup1_rdata_error;

logic        cfg_mem_ack_ll_enq_cnt_r_bin1_dup1_nc;
logic [31:0] cfg_mem_rdata_ll_enq_cnt_r_bin1_dup1_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (14)
        ,.AWIDTHPAD           (1)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (2)
) i_ll_enq_cnt_r_bin1_dup1 (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_ll_enq_cnt_r_bin1_dup1_re)
        ,.func_mem_raddr      (func_ll_enq_cnt_r_bin1_dup1_raddr)
        ,.func_mem_waddr      (func_ll_enq_cnt_r_bin1_dup1_waddr)
        ,.func_mem_we         (func_ll_enq_cnt_r_bin1_dup1_we)
        ,.func_mem_wdata      (func_ll_enq_cnt_r_bin1_dup1_wdata)
        ,.func_mem_rdata      (func_ll_enq_cnt_r_bin1_dup1_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_ll_enq_cnt_r_bin1_dup1_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_ll_enq_cnt_r_bin1_dup1_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_ll_enq_cnt_r_bin1_dup1_re)
        ,.pf_mem_raddr        (pf_ll_enq_cnt_r_bin1_dup1_raddr)
        ,.pf_mem_waddr        (pf_ll_enq_cnt_r_bin1_dup1_waddr)
        ,.pf_mem_we           (pf_ll_enq_cnt_r_bin1_dup1_we)
        ,.pf_mem_wdata        (pf_ll_enq_cnt_r_bin1_dup1_wdata)
        ,.pf_mem_rdata        (pf_ll_enq_cnt_r_bin1_dup1_rdata)

        ,.mem_wclk            (rf_ll_enq_cnt_r_bin1_dup1_wclk)
        ,.mem_rclk            (rf_ll_enq_cnt_r_bin1_dup1_rclk)
        ,.mem_wclk_rst_n      (rf_ll_enq_cnt_r_bin1_dup1_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_ll_enq_cnt_r_bin1_dup1_rclk_rst_n)
        ,.mem_re              (rf_ll_enq_cnt_r_bin1_dup1_re)
        ,.mem_raddr           ({rf_ll_enq_cnt_r_bin1_dup1_raddr_nc , rf_ll_enq_cnt_r_bin1_dup1_raddr})
        ,.mem_waddr           ({rf_ll_enq_cnt_r_bin1_dup1_waddr_nc , rf_ll_enq_cnt_r_bin1_dup1_waddr})
        ,.mem_we              (rf_ll_enq_cnt_r_bin1_dup1_we)
        ,.mem_wdata           (rf_ll_enq_cnt_r_bin1_dup1_wdata)
        ,.mem_rdata           (rf_ll_enq_cnt_r_bin1_dup1_rdata)

        ,.mem_rdata_error     (rf_ll_enq_cnt_r_bin1_dup1_rdata_error)
        ,.error               (rf_ll_enq_cnt_r_bin1_dup1_error)
);

logic [(       1)-1:0] rf_ll_enq_cnt_r_bin1_dup2_raddr_nc ;
logic [(       1)-1:0] rf_ll_enq_cnt_r_bin1_dup2_waddr_nc ;

logic        rf_ll_enq_cnt_r_bin1_dup2_rdata_error;

logic        cfg_mem_ack_ll_enq_cnt_r_bin1_dup2_nc;
logic [31:0] cfg_mem_rdata_ll_enq_cnt_r_bin1_dup2_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (14)
        ,.AWIDTHPAD           (1)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (2)
) i_ll_enq_cnt_r_bin1_dup2 (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_ll_enq_cnt_r_bin1_dup2_re)
        ,.func_mem_raddr      (func_ll_enq_cnt_r_bin1_dup2_raddr)
        ,.func_mem_waddr      (func_ll_enq_cnt_r_bin1_dup2_waddr)
        ,.func_mem_we         (func_ll_enq_cnt_r_bin1_dup2_we)
        ,.func_mem_wdata      (func_ll_enq_cnt_r_bin1_dup2_wdata)
        ,.func_mem_rdata      (func_ll_enq_cnt_r_bin1_dup2_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_ll_enq_cnt_r_bin1_dup2_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_ll_enq_cnt_r_bin1_dup2_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_ll_enq_cnt_r_bin1_dup2_re)
        ,.pf_mem_raddr        (pf_ll_enq_cnt_r_bin1_dup2_raddr)
        ,.pf_mem_waddr        (pf_ll_enq_cnt_r_bin1_dup2_waddr)
        ,.pf_mem_we           (pf_ll_enq_cnt_r_bin1_dup2_we)
        ,.pf_mem_wdata        (pf_ll_enq_cnt_r_bin1_dup2_wdata)
        ,.pf_mem_rdata        (pf_ll_enq_cnt_r_bin1_dup2_rdata)

        ,.mem_wclk            (rf_ll_enq_cnt_r_bin1_dup2_wclk)
        ,.mem_rclk            (rf_ll_enq_cnt_r_bin1_dup2_rclk)
        ,.mem_wclk_rst_n      (rf_ll_enq_cnt_r_bin1_dup2_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_ll_enq_cnt_r_bin1_dup2_rclk_rst_n)
        ,.mem_re              (rf_ll_enq_cnt_r_bin1_dup2_re)
        ,.mem_raddr           ({rf_ll_enq_cnt_r_bin1_dup2_raddr_nc , rf_ll_enq_cnt_r_bin1_dup2_raddr})
        ,.mem_waddr           ({rf_ll_enq_cnt_r_bin1_dup2_waddr_nc , rf_ll_enq_cnt_r_bin1_dup2_waddr})
        ,.mem_we              (rf_ll_enq_cnt_r_bin1_dup2_we)
        ,.mem_wdata           (rf_ll_enq_cnt_r_bin1_dup2_wdata)
        ,.mem_rdata           (rf_ll_enq_cnt_r_bin1_dup2_rdata)

        ,.mem_rdata_error     (rf_ll_enq_cnt_r_bin1_dup2_rdata_error)
        ,.error               (rf_ll_enq_cnt_r_bin1_dup2_error)
);

logic [(       1)-1:0] rf_ll_enq_cnt_r_bin1_dup3_raddr_nc ;
logic [(       1)-1:0] rf_ll_enq_cnt_r_bin1_dup3_waddr_nc ;

logic        rf_ll_enq_cnt_r_bin1_dup3_rdata_error;

logic        cfg_mem_ack_ll_enq_cnt_r_bin1_dup3_nc;
logic [31:0] cfg_mem_rdata_ll_enq_cnt_r_bin1_dup3_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (14)
        ,.AWIDTHPAD           (1)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (2)
) i_ll_enq_cnt_r_bin1_dup3 (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_ll_enq_cnt_r_bin1_dup3_re)
        ,.func_mem_raddr      (func_ll_enq_cnt_r_bin1_dup3_raddr)
        ,.func_mem_waddr      (func_ll_enq_cnt_r_bin1_dup3_waddr)
        ,.func_mem_we         (func_ll_enq_cnt_r_bin1_dup3_we)
        ,.func_mem_wdata      (func_ll_enq_cnt_r_bin1_dup3_wdata)
        ,.func_mem_rdata      (func_ll_enq_cnt_r_bin1_dup3_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_ll_enq_cnt_r_bin1_dup3_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_ll_enq_cnt_r_bin1_dup3_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_ll_enq_cnt_r_bin1_dup3_re)
        ,.pf_mem_raddr        (pf_ll_enq_cnt_r_bin1_dup3_raddr)
        ,.pf_mem_waddr        (pf_ll_enq_cnt_r_bin1_dup3_waddr)
        ,.pf_mem_we           (pf_ll_enq_cnt_r_bin1_dup3_we)
        ,.pf_mem_wdata        (pf_ll_enq_cnt_r_bin1_dup3_wdata)
        ,.pf_mem_rdata        (pf_ll_enq_cnt_r_bin1_dup3_rdata)

        ,.mem_wclk            (rf_ll_enq_cnt_r_bin1_dup3_wclk)
        ,.mem_rclk            (rf_ll_enq_cnt_r_bin1_dup3_rclk)
        ,.mem_wclk_rst_n      (rf_ll_enq_cnt_r_bin1_dup3_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_ll_enq_cnt_r_bin1_dup3_rclk_rst_n)
        ,.mem_re              (rf_ll_enq_cnt_r_bin1_dup3_re)
        ,.mem_raddr           ({rf_ll_enq_cnt_r_bin1_dup3_raddr_nc , rf_ll_enq_cnt_r_bin1_dup3_raddr})
        ,.mem_waddr           ({rf_ll_enq_cnt_r_bin1_dup3_waddr_nc , rf_ll_enq_cnt_r_bin1_dup3_waddr})
        ,.mem_we              (rf_ll_enq_cnt_r_bin1_dup3_we)
        ,.mem_wdata           (rf_ll_enq_cnt_r_bin1_dup3_wdata)
        ,.mem_rdata           (rf_ll_enq_cnt_r_bin1_dup3_rdata)

        ,.mem_rdata_error     (rf_ll_enq_cnt_r_bin1_dup3_rdata_error)
        ,.error               (rf_ll_enq_cnt_r_bin1_dup3_error)
);

logic [(       1)-1:0] rf_ll_enq_cnt_r_bin2_dup0_raddr_nc ;
logic [(       1)-1:0] rf_ll_enq_cnt_r_bin2_dup0_waddr_nc ;

logic        rf_ll_enq_cnt_r_bin2_dup0_rdata_error;

logic        cfg_mem_ack_ll_enq_cnt_r_bin2_dup0_nc;
logic [31:0] cfg_mem_rdata_ll_enq_cnt_r_bin2_dup0_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (14)
        ,.AWIDTHPAD           (1)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (2)
) i_ll_enq_cnt_r_bin2_dup0 (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_ll_enq_cnt_r_bin2_dup0_re)
        ,.func_mem_raddr      (func_ll_enq_cnt_r_bin2_dup0_raddr)
        ,.func_mem_waddr      (func_ll_enq_cnt_r_bin2_dup0_waddr)
        ,.func_mem_we         (func_ll_enq_cnt_r_bin2_dup0_we)
        ,.func_mem_wdata      (func_ll_enq_cnt_r_bin2_dup0_wdata)
        ,.func_mem_rdata      (func_ll_enq_cnt_r_bin2_dup0_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_ll_enq_cnt_r_bin2_dup0_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_ll_enq_cnt_r_bin2_dup0_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_ll_enq_cnt_r_bin2_dup0_re)
        ,.pf_mem_raddr        (pf_ll_enq_cnt_r_bin2_dup0_raddr)
        ,.pf_mem_waddr        (pf_ll_enq_cnt_r_bin2_dup0_waddr)
        ,.pf_mem_we           (pf_ll_enq_cnt_r_bin2_dup0_we)
        ,.pf_mem_wdata        (pf_ll_enq_cnt_r_bin2_dup0_wdata)
        ,.pf_mem_rdata        (pf_ll_enq_cnt_r_bin2_dup0_rdata)

        ,.mem_wclk            (rf_ll_enq_cnt_r_bin2_dup0_wclk)
        ,.mem_rclk            (rf_ll_enq_cnt_r_bin2_dup0_rclk)
        ,.mem_wclk_rst_n      (rf_ll_enq_cnt_r_bin2_dup0_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_ll_enq_cnt_r_bin2_dup0_rclk_rst_n)
        ,.mem_re              (rf_ll_enq_cnt_r_bin2_dup0_re)
        ,.mem_raddr           ({rf_ll_enq_cnt_r_bin2_dup0_raddr_nc , rf_ll_enq_cnt_r_bin2_dup0_raddr})
        ,.mem_waddr           ({rf_ll_enq_cnt_r_bin2_dup0_waddr_nc , rf_ll_enq_cnt_r_bin2_dup0_waddr})
        ,.mem_we              (rf_ll_enq_cnt_r_bin2_dup0_we)
        ,.mem_wdata           (rf_ll_enq_cnt_r_bin2_dup0_wdata)
        ,.mem_rdata           (rf_ll_enq_cnt_r_bin2_dup0_rdata)

        ,.mem_rdata_error     (rf_ll_enq_cnt_r_bin2_dup0_rdata_error)
        ,.error               (rf_ll_enq_cnt_r_bin2_dup0_error)
);

logic [(       1)-1:0] rf_ll_enq_cnt_r_bin2_dup1_raddr_nc ;
logic [(       1)-1:0] rf_ll_enq_cnt_r_bin2_dup1_waddr_nc ;

logic        rf_ll_enq_cnt_r_bin2_dup1_rdata_error;

logic        cfg_mem_ack_ll_enq_cnt_r_bin2_dup1_nc;
logic [31:0] cfg_mem_rdata_ll_enq_cnt_r_bin2_dup1_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (14)
        ,.AWIDTHPAD           (1)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (2)
) i_ll_enq_cnt_r_bin2_dup1 (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_ll_enq_cnt_r_bin2_dup1_re)
        ,.func_mem_raddr      (func_ll_enq_cnt_r_bin2_dup1_raddr)
        ,.func_mem_waddr      (func_ll_enq_cnt_r_bin2_dup1_waddr)
        ,.func_mem_we         (func_ll_enq_cnt_r_bin2_dup1_we)
        ,.func_mem_wdata      (func_ll_enq_cnt_r_bin2_dup1_wdata)
        ,.func_mem_rdata      (func_ll_enq_cnt_r_bin2_dup1_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_ll_enq_cnt_r_bin2_dup1_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_ll_enq_cnt_r_bin2_dup1_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_ll_enq_cnt_r_bin2_dup1_re)
        ,.pf_mem_raddr        (pf_ll_enq_cnt_r_bin2_dup1_raddr)
        ,.pf_mem_waddr        (pf_ll_enq_cnt_r_bin2_dup1_waddr)
        ,.pf_mem_we           (pf_ll_enq_cnt_r_bin2_dup1_we)
        ,.pf_mem_wdata        (pf_ll_enq_cnt_r_bin2_dup1_wdata)
        ,.pf_mem_rdata        (pf_ll_enq_cnt_r_bin2_dup1_rdata)

        ,.mem_wclk            (rf_ll_enq_cnt_r_bin2_dup1_wclk)
        ,.mem_rclk            (rf_ll_enq_cnt_r_bin2_dup1_rclk)
        ,.mem_wclk_rst_n      (rf_ll_enq_cnt_r_bin2_dup1_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_ll_enq_cnt_r_bin2_dup1_rclk_rst_n)
        ,.mem_re              (rf_ll_enq_cnt_r_bin2_dup1_re)
        ,.mem_raddr           ({rf_ll_enq_cnt_r_bin2_dup1_raddr_nc , rf_ll_enq_cnt_r_bin2_dup1_raddr})
        ,.mem_waddr           ({rf_ll_enq_cnt_r_bin2_dup1_waddr_nc , rf_ll_enq_cnt_r_bin2_dup1_waddr})
        ,.mem_we              (rf_ll_enq_cnt_r_bin2_dup1_we)
        ,.mem_wdata           (rf_ll_enq_cnt_r_bin2_dup1_wdata)
        ,.mem_rdata           (rf_ll_enq_cnt_r_bin2_dup1_rdata)

        ,.mem_rdata_error     (rf_ll_enq_cnt_r_bin2_dup1_rdata_error)
        ,.error               (rf_ll_enq_cnt_r_bin2_dup1_error)
);

logic [(       1)-1:0] rf_ll_enq_cnt_r_bin2_dup2_raddr_nc ;
logic [(       1)-1:0] rf_ll_enq_cnt_r_bin2_dup2_waddr_nc ;

logic        rf_ll_enq_cnt_r_bin2_dup2_rdata_error;

logic        cfg_mem_ack_ll_enq_cnt_r_bin2_dup2_nc;
logic [31:0] cfg_mem_rdata_ll_enq_cnt_r_bin2_dup2_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (14)
        ,.AWIDTHPAD           (1)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (2)
) i_ll_enq_cnt_r_bin2_dup2 (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_ll_enq_cnt_r_bin2_dup2_re)
        ,.func_mem_raddr      (func_ll_enq_cnt_r_bin2_dup2_raddr)
        ,.func_mem_waddr      (func_ll_enq_cnt_r_bin2_dup2_waddr)
        ,.func_mem_we         (func_ll_enq_cnt_r_bin2_dup2_we)
        ,.func_mem_wdata      (func_ll_enq_cnt_r_bin2_dup2_wdata)
        ,.func_mem_rdata      (func_ll_enq_cnt_r_bin2_dup2_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_ll_enq_cnt_r_bin2_dup2_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_ll_enq_cnt_r_bin2_dup2_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_ll_enq_cnt_r_bin2_dup2_re)
        ,.pf_mem_raddr        (pf_ll_enq_cnt_r_bin2_dup2_raddr)
        ,.pf_mem_waddr        (pf_ll_enq_cnt_r_bin2_dup2_waddr)
        ,.pf_mem_we           (pf_ll_enq_cnt_r_bin2_dup2_we)
        ,.pf_mem_wdata        (pf_ll_enq_cnt_r_bin2_dup2_wdata)
        ,.pf_mem_rdata        (pf_ll_enq_cnt_r_bin2_dup2_rdata)

        ,.mem_wclk            (rf_ll_enq_cnt_r_bin2_dup2_wclk)
        ,.mem_rclk            (rf_ll_enq_cnt_r_bin2_dup2_rclk)
        ,.mem_wclk_rst_n      (rf_ll_enq_cnt_r_bin2_dup2_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_ll_enq_cnt_r_bin2_dup2_rclk_rst_n)
        ,.mem_re              (rf_ll_enq_cnt_r_bin2_dup2_re)
        ,.mem_raddr           ({rf_ll_enq_cnt_r_bin2_dup2_raddr_nc , rf_ll_enq_cnt_r_bin2_dup2_raddr})
        ,.mem_waddr           ({rf_ll_enq_cnt_r_bin2_dup2_waddr_nc , rf_ll_enq_cnt_r_bin2_dup2_waddr})
        ,.mem_we              (rf_ll_enq_cnt_r_bin2_dup2_we)
        ,.mem_wdata           (rf_ll_enq_cnt_r_bin2_dup2_wdata)
        ,.mem_rdata           (rf_ll_enq_cnt_r_bin2_dup2_rdata)

        ,.mem_rdata_error     (rf_ll_enq_cnt_r_bin2_dup2_rdata_error)
        ,.error               (rf_ll_enq_cnt_r_bin2_dup2_error)
);

logic [(       1)-1:0] rf_ll_enq_cnt_r_bin2_dup3_raddr_nc ;
logic [(       1)-1:0] rf_ll_enq_cnt_r_bin2_dup3_waddr_nc ;

logic        rf_ll_enq_cnt_r_bin2_dup3_rdata_error;

logic        cfg_mem_ack_ll_enq_cnt_r_bin2_dup3_nc;
logic [31:0] cfg_mem_rdata_ll_enq_cnt_r_bin2_dup3_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (14)
        ,.AWIDTHPAD           (1)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (2)
) i_ll_enq_cnt_r_bin2_dup3 (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_ll_enq_cnt_r_bin2_dup3_re)
        ,.func_mem_raddr      (func_ll_enq_cnt_r_bin2_dup3_raddr)
        ,.func_mem_waddr      (func_ll_enq_cnt_r_bin2_dup3_waddr)
        ,.func_mem_we         (func_ll_enq_cnt_r_bin2_dup3_we)
        ,.func_mem_wdata      (func_ll_enq_cnt_r_bin2_dup3_wdata)
        ,.func_mem_rdata      (func_ll_enq_cnt_r_bin2_dup3_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_ll_enq_cnt_r_bin2_dup3_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_ll_enq_cnt_r_bin2_dup3_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_ll_enq_cnt_r_bin2_dup3_re)
        ,.pf_mem_raddr        (pf_ll_enq_cnt_r_bin2_dup3_raddr)
        ,.pf_mem_waddr        (pf_ll_enq_cnt_r_bin2_dup3_waddr)
        ,.pf_mem_we           (pf_ll_enq_cnt_r_bin2_dup3_we)
        ,.pf_mem_wdata        (pf_ll_enq_cnt_r_bin2_dup3_wdata)
        ,.pf_mem_rdata        (pf_ll_enq_cnt_r_bin2_dup3_rdata)

        ,.mem_wclk            (rf_ll_enq_cnt_r_bin2_dup3_wclk)
        ,.mem_rclk            (rf_ll_enq_cnt_r_bin2_dup3_rclk)
        ,.mem_wclk_rst_n      (rf_ll_enq_cnt_r_bin2_dup3_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_ll_enq_cnt_r_bin2_dup3_rclk_rst_n)
        ,.mem_re              (rf_ll_enq_cnt_r_bin2_dup3_re)
        ,.mem_raddr           ({rf_ll_enq_cnt_r_bin2_dup3_raddr_nc , rf_ll_enq_cnt_r_bin2_dup3_raddr})
        ,.mem_waddr           ({rf_ll_enq_cnt_r_bin2_dup3_waddr_nc , rf_ll_enq_cnt_r_bin2_dup3_waddr})
        ,.mem_we              (rf_ll_enq_cnt_r_bin2_dup3_we)
        ,.mem_wdata           (rf_ll_enq_cnt_r_bin2_dup3_wdata)
        ,.mem_rdata           (rf_ll_enq_cnt_r_bin2_dup3_rdata)

        ,.mem_rdata_error     (rf_ll_enq_cnt_r_bin2_dup3_rdata_error)
        ,.error               (rf_ll_enq_cnt_r_bin2_dup3_error)
);

logic [(       1)-1:0] rf_ll_enq_cnt_r_bin3_dup0_raddr_nc ;
logic [(       1)-1:0] rf_ll_enq_cnt_r_bin3_dup0_waddr_nc ;

logic        rf_ll_enq_cnt_r_bin3_dup0_rdata_error;

logic        cfg_mem_ack_ll_enq_cnt_r_bin3_dup0_nc;
logic [31:0] cfg_mem_rdata_ll_enq_cnt_r_bin3_dup0_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (14)
        ,.AWIDTHPAD           (1)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (2)
) i_ll_enq_cnt_r_bin3_dup0 (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_ll_enq_cnt_r_bin3_dup0_re)
        ,.func_mem_raddr      (func_ll_enq_cnt_r_bin3_dup0_raddr)
        ,.func_mem_waddr      (func_ll_enq_cnt_r_bin3_dup0_waddr)
        ,.func_mem_we         (func_ll_enq_cnt_r_bin3_dup0_we)
        ,.func_mem_wdata      (func_ll_enq_cnt_r_bin3_dup0_wdata)
        ,.func_mem_rdata      (func_ll_enq_cnt_r_bin3_dup0_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_ll_enq_cnt_r_bin3_dup0_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_ll_enq_cnt_r_bin3_dup0_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_ll_enq_cnt_r_bin3_dup0_re)
        ,.pf_mem_raddr        (pf_ll_enq_cnt_r_bin3_dup0_raddr)
        ,.pf_mem_waddr        (pf_ll_enq_cnt_r_bin3_dup0_waddr)
        ,.pf_mem_we           (pf_ll_enq_cnt_r_bin3_dup0_we)
        ,.pf_mem_wdata        (pf_ll_enq_cnt_r_bin3_dup0_wdata)
        ,.pf_mem_rdata        (pf_ll_enq_cnt_r_bin3_dup0_rdata)

        ,.mem_wclk            (rf_ll_enq_cnt_r_bin3_dup0_wclk)
        ,.mem_rclk            (rf_ll_enq_cnt_r_bin3_dup0_rclk)
        ,.mem_wclk_rst_n      (rf_ll_enq_cnt_r_bin3_dup0_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_ll_enq_cnt_r_bin3_dup0_rclk_rst_n)
        ,.mem_re              (rf_ll_enq_cnt_r_bin3_dup0_re)
        ,.mem_raddr           ({rf_ll_enq_cnt_r_bin3_dup0_raddr_nc , rf_ll_enq_cnt_r_bin3_dup0_raddr})
        ,.mem_waddr           ({rf_ll_enq_cnt_r_bin3_dup0_waddr_nc , rf_ll_enq_cnt_r_bin3_dup0_waddr})
        ,.mem_we              (rf_ll_enq_cnt_r_bin3_dup0_we)
        ,.mem_wdata           (rf_ll_enq_cnt_r_bin3_dup0_wdata)
        ,.mem_rdata           (rf_ll_enq_cnt_r_bin3_dup0_rdata)

        ,.mem_rdata_error     (rf_ll_enq_cnt_r_bin3_dup0_rdata_error)
        ,.error               (rf_ll_enq_cnt_r_bin3_dup0_error)
);

logic [(       1)-1:0] rf_ll_enq_cnt_r_bin3_dup1_raddr_nc ;
logic [(       1)-1:0] rf_ll_enq_cnt_r_bin3_dup1_waddr_nc ;

logic        rf_ll_enq_cnt_r_bin3_dup1_rdata_error;

logic        cfg_mem_ack_ll_enq_cnt_r_bin3_dup1_nc;
logic [31:0] cfg_mem_rdata_ll_enq_cnt_r_bin3_dup1_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (14)
        ,.AWIDTHPAD           (1)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (2)
) i_ll_enq_cnt_r_bin3_dup1 (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_ll_enq_cnt_r_bin3_dup1_re)
        ,.func_mem_raddr      (func_ll_enq_cnt_r_bin3_dup1_raddr)
        ,.func_mem_waddr      (func_ll_enq_cnt_r_bin3_dup1_waddr)
        ,.func_mem_we         (func_ll_enq_cnt_r_bin3_dup1_we)
        ,.func_mem_wdata      (func_ll_enq_cnt_r_bin3_dup1_wdata)
        ,.func_mem_rdata      (func_ll_enq_cnt_r_bin3_dup1_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_ll_enq_cnt_r_bin3_dup1_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_ll_enq_cnt_r_bin3_dup1_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_ll_enq_cnt_r_bin3_dup1_re)
        ,.pf_mem_raddr        (pf_ll_enq_cnt_r_bin3_dup1_raddr)
        ,.pf_mem_waddr        (pf_ll_enq_cnt_r_bin3_dup1_waddr)
        ,.pf_mem_we           (pf_ll_enq_cnt_r_bin3_dup1_we)
        ,.pf_mem_wdata        (pf_ll_enq_cnt_r_bin3_dup1_wdata)
        ,.pf_mem_rdata        (pf_ll_enq_cnt_r_bin3_dup1_rdata)

        ,.mem_wclk            (rf_ll_enq_cnt_r_bin3_dup1_wclk)
        ,.mem_rclk            (rf_ll_enq_cnt_r_bin3_dup1_rclk)
        ,.mem_wclk_rst_n      (rf_ll_enq_cnt_r_bin3_dup1_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_ll_enq_cnt_r_bin3_dup1_rclk_rst_n)
        ,.mem_re              (rf_ll_enq_cnt_r_bin3_dup1_re)
        ,.mem_raddr           ({rf_ll_enq_cnt_r_bin3_dup1_raddr_nc , rf_ll_enq_cnt_r_bin3_dup1_raddr})
        ,.mem_waddr           ({rf_ll_enq_cnt_r_bin3_dup1_waddr_nc , rf_ll_enq_cnt_r_bin3_dup1_waddr})
        ,.mem_we              (rf_ll_enq_cnt_r_bin3_dup1_we)
        ,.mem_wdata           (rf_ll_enq_cnt_r_bin3_dup1_wdata)
        ,.mem_rdata           (rf_ll_enq_cnt_r_bin3_dup1_rdata)

        ,.mem_rdata_error     (rf_ll_enq_cnt_r_bin3_dup1_rdata_error)
        ,.error               (rf_ll_enq_cnt_r_bin3_dup1_error)
);

logic [(       1)-1:0] rf_ll_enq_cnt_r_bin3_dup2_raddr_nc ;
logic [(       1)-1:0] rf_ll_enq_cnt_r_bin3_dup2_waddr_nc ;

logic        rf_ll_enq_cnt_r_bin3_dup2_rdata_error;

logic        cfg_mem_ack_ll_enq_cnt_r_bin3_dup2_nc;
logic [31:0] cfg_mem_rdata_ll_enq_cnt_r_bin3_dup2_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (14)
        ,.AWIDTHPAD           (1)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (2)
) i_ll_enq_cnt_r_bin3_dup2 (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_ll_enq_cnt_r_bin3_dup2_re)
        ,.func_mem_raddr      (func_ll_enq_cnt_r_bin3_dup2_raddr)
        ,.func_mem_waddr      (func_ll_enq_cnt_r_bin3_dup2_waddr)
        ,.func_mem_we         (func_ll_enq_cnt_r_bin3_dup2_we)
        ,.func_mem_wdata      (func_ll_enq_cnt_r_bin3_dup2_wdata)
        ,.func_mem_rdata      (func_ll_enq_cnt_r_bin3_dup2_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_ll_enq_cnt_r_bin3_dup2_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_ll_enq_cnt_r_bin3_dup2_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_ll_enq_cnt_r_bin3_dup2_re)
        ,.pf_mem_raddr        (pf_ll_enq_cnt_r_bin3_dup2_raddr)
        ,.pf_mem_waddr        (pf_ll_enq_cnt_r_bin3_dup2_waddr)
        ,.pf_mem_we           (pf_ll_enq_cnt_r_bin3_dup2_we)
        ,.pf_mem_wdata        (pf_ll_enq_cnt_r_bin3_dup2_wdata)
        ,.pf_mem_rdata        (pf_ll_enq_cnt_r_bin3_dup2_rdata)

        ,.mem_wclk            (rf_ll_enq_cnt_r_bin3_dup2_wclk)
        ,.mem_rclk            (rf_ll_enq_cnt_r_bin3_dup2_rclk)
        ,.mem_wclk_rst_n      (rf_ll_enq_cnt_r_bin3_dup2_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_ll_enq_cnt_r_bin3_dup2_rclk_rst_n)
        ,.mem_re              (rf_ll_enq_cnt_r_bin3_dup2_re)
        ,.mem_raddr           ({rf_ll_enq_cnt_r_bin3_dup2_raddr_nc , rf_ll_enq_cnt_r_bin3_dup2_raddr})
        ,.mem_waddr           ({rf_ll_enq_cnt_r_bin3_dup2_waddr_nc , rf_ll_enq_cnt_r_bin3_dup2_waddr})
        ,.mem_we              (rf_ll_enq_cnt_r_bin3_dup2_we)
        ,.mem_wdata           (rf_ll_enq_cnt_r_bin3_dup2_wdata)
        ,.mem_rdata           (rf_ll_enq_cnt_r_bin3_dup2_rdata)

        ,.mem_rdata_error     (rf_ll_enq_cnt_r_bin3_dup2_rdata_error)
        ,.error               (rf_ll_enq_cnt_r_bin3_dup2_error)
);

logic [(       1)-1:0] rf_ll_enq_cnt_r_bin3_dup3_raddr_nc ;
logic [(       1)-1:0] rf_ll_enq_cnt_r_bin3_dup3_waddr_nc ;

logic        rf_ll_enq_cnt_r_bin3_dup3_rdata_error;

logic        cfg_mem_ack_ll_enq_cnt_r_bin3_dup3_nc;
logic [31:0] cfg_mem_rdata_ll_enq_cnt_r_bin3_dup3_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (14)
        ,.AWIDTHPAD           (1)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (2)
) i_ll_enq_cnt_r_bin3_dup3 (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_ll_enq_cnt_r_bin3_dup3_re)
        ,.func_mem_raddr      (func_ll_enq_cnt_r_bin3_dup3_raddr)
        ,.func_mem_waddr      (func_ll_enq_cnt_r_bin3_dup3_waddr)
        ,.func_mem_we         (func_ll_enq_cnt_r_bin3_dup3_we)
        ,.func_mem_wdata      (func_ll_enq_cnt_r_bin3_dup3_wdata)
        ,.func_mem_rdata      (func_ll_enq_cnt_r_bin3_dup3_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_ll_enq_cnt_r_bin3_dup3_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_ll_enq_cnt_r_bin3_dup3_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_ll_enq_cnt_r_bin3_dup3_re)
        ,.pf_mem_raddr        (pf_ll_enq_cnt_r_bin3_dup3_raddr)
        ,.pf_mem_waddr        (pf_ll_enq_cnt_r_bin3_dup3_waddr)
        ,.pf_mem_we           (pf_ll_enq_cnt_r_bin3_dup3_we)
        ,.pf_mem_wdata        (pf_ll_enq_cnt_r_bin3_dup3_wdata)
        ,.pf_mem_rdata        (pf_ll_enq_cnt_r_bin3_dup3_rdata)

        ,.mem_wclk            (rf_ll_enq_cnt_r_bin3_dup3_wclk)
        ,.mem_rclk            (rf_ll_enq_cnt_r_bin3_dup3_rclk)
        ,.mem_wclk_rst_n      (rf_ll_enq_cnt_r_bin3_dup3_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_ll_enq_cnt_r_bin3_dup3_rclk_rst_n)
        ,.mem_re              (rf_ll_enq_cnt_r_bin3_dup3_re)
        ,.mem_raddr           ({rf_ll_enq_cnt_r_bin3_dup3_raddr_nc , rf_ll_enq_cnt_r_bin3_dup3_raddr})
        ,.mem_waddr           ({rf_ll_enq_cnt_r_bin3_dup3_waddr_nc , rf_ll_enq_cnt_r_bin3_dup3_waddr})
        ,.mem_we              (rf_ll_enq_cnt_r_bin3_dup3_we)
        ,.mem_wdata           (rf_ll_enq_cnt_r_bin3_dup3_wdata)
        ,.mem_rdata           (rf_ll_enq_cnt_r_bin3_dup3_rdata)

        ,.mem_rdata_error     (rf_ll_enq_cnt_r_bin3_dup3_rdata_error)
        ,.error               (rf_ll_enq_cnt_r_bin3_dup3_error)
);

logic [(       1)-1:0] rf_ll_enq_cnt_s_bin0_raddr_nc ;
logic [(       1)-1:0] rf_ll_enq_cnt_s_bin0_waddr_nc ;

logic        rf_ll_enq_cnt_s_bin0_rdata_error;

logic        cfg_mem_ack_ll_enq_cnt_s_bin0_nc;
logic [31:0] cfg_mem_rdata_ll_enq_cnt_s_bin0_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (14)
        ,.AWIDTHPAD           (1)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (2)
) i_ll_enq_cnt_s_bin0 (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_ll_enq_cnt_s_bin0_re)
        ,.func_mem_raddr      (func_ll_enq_cnt_s_bin0_raddr)
        ,.func_mem_waddr      (func_ll_enq_cnt_s_bin0_waddr)
        ,.func_mem_we         (func_ll_enq_cnt_s_bin0_we)
        ,.func_mem_wdata      (func_ll_enq_cnt_s_bin0_wdata)
        ,.func_mem_rdata      (func_ll_enq_cnt_s_bin0_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_ll_enq_cnt_s_bin0_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_ll_enq_cnt_s_bin0_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_ll_enq_cnt_s_bin0_re)
        ,.pf_mem_raddr        (pf_ll_enq_cnt_s_bin0_raddr)
        ,.pf_mem_waddr        (pf_ll_enq_cnt_s_bin0_waddr)
        ,.pf_mem_we           (pf_ll_enq_cnt_s_bin0_we)
        ,.pf_mem_wdata        (pf_ll_enq_cnt_s_bin0_wdata)
        ,.pf_mem_rdata        (pf_ll_enq_cnt_s_bin0_rdata)

        ,.mem_wclk            (rf_ll_enq_cnt_s_bin0_wclk)
        ,.mem_rclk            (rf_ll_enq_cnt_s_bin0_rclk)
        ,.mem_wclk_rst_n      (rf_ll_enq_cnt_s_bin0_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_ll_enq_cnt_s_bin0_rclk_rst_n)
        ,.mem_re              (rf_ll_enq_cnt_s_bin0_re)
        ,.mem_raddr           ({rf_ll_enq_cnt_s_bin0_raddr_nc , rf_ll_enq_cnt_s_bin0_raddr})
        ,.mem_waddr           ({rf_ll_enq_cnt_s_bin0_waddr_nc , rf_ll_enq_cnt_s_bin0_waddr})
        ,.mem_we              (rf_ll_enq_cnt_s_bin0_we)
        ,.mem_wdata           (rf_ll_enq_cnt_s_bin0_wdata)
        ,.mem_rdata           (rf_ll_enq_cnt_s_bin0_rdata)

        ,.mem_rdata_error     (rf_ll_enq_cnt_s_bin0_rdata_error)
        ,.error               (rf_ll_enq_cnt_s_bin0_error)
);

logic [(       1)-1:0] rf_ll_enq_cnt_s_bin1_raddr_nc ;
logic [(       1)-1:0] rf_ll_enq_cnt_s_bin1_waddr_nc ;

logic        rf_ll_enq_cnt_s_bin1_rdata_error;

logic        cfg_mem_ack_ll_enq_cnt_s_bin1_nc;
logic [31:0] cfg_mem_rdata_ll_enq_cnt_s_bin1_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (14)
        ,.AWIDTHPAD           (1)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (2)
) i_ll_enq_cnt_s_bin1 (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_ll_enq_cnt_s_bin1_re)
        ,.func_mem_raddr      (func_ll_enq_cnt_s_bin1_raddr)
        ,.func_mem_waddr      (func_ll_enq_cnt_s_bin1_waddr)
        ,.func_mem_we         (func_ll_enq_cnt_s_bin1_we)
        ,.func_mem_wdata      (func_ll_enq_cnt_s_bin1_wdata)
        ,.func_mem_rdata      (func_ll_enq_cnt_s_bin1_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_ll_enq_cnt_s_bin1_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_ll_enq_cnt_s_bin1_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_ll_enq_cnt_s_bin1_re)
        ,.pf_mem_raddr        (pf_ll_enq_cnt_s_bin1_raddr)
        ,.pf_mem_waddr        (pf_ll_enq_cnt_s_bin1_waddr)
        ,.pf_mem_we           (pf_ll_enq_cnt_s_bin1_we)
        ,.pf_mem_wdata        (pf_ll_enq_cnt_s_bin1_wdata)
        ,.pf_mem_rdata        (pf_ll_enq_cnt_s_bin1_rdata)

        ,.mem_wclk            (rf_ll_enq_cnt_s_bin1_wclk)
        ,.mem_rclk            (rf_ll_enq_cnt_s_bin1_rclk)
        ,.mem_wclk_rst_n      (rf_ll_enq_cnt_s_bin1_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_ll_enq_cnt_s_bin1_rclk_rst_n)
        ,.mem_re              (rf_ll_enq_cnt_s_bin1_re)
        ,.mem_raddr           ({rf_ll_enq_cnt_s_bin1_raddr_nc , rf_ll_enq_cnt_s_bin1_raddr})
        ,.mem_waddr           ({rf_ll_enq_cnt_s_bin1_waddr_nc , rf_ll_enq_cnt_s_bin1_waddr})
        ,.mem_we              (rf_ll_enq_cnt_s_bin1_we)
        ,.mem_wdata           (rf_ll_enq_cnt_s_bin1_wdata)
        ,.mem_rdata           (rf_ll_enq_cnt_s_bin1_rdata)

        ,.mem_rdata_error     (rf_ll_enq_cnt_s_bin1_rdata_error)
        ,.error               (rf_ll_enq_cnt_s_bin1_error)
);

logic [(       1)-1:0] rf_ll_enq_cnt_s_bin2_raddr_nc ;
logic [(       1)-1:0] rf_ll_enq_cnt_s_bin2_waddr_nc ;

logic        rf_ll_enq_cnt_s_bin2_rdata_error;

logic        cfg_mem_ack_ll_enq_cnt_s_bin2_nc;
logic [31:0] cfg_mem_rdata_ll_enq_cnt_s_bin2_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (14)
        ,.AWIDTHPAD           (1)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (2)
) i_ll_enq_cnt_s_bin2 (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_ll_enq_cnt_s_bin2_re)
        ,.func_mem_raddr      (func_ll_enq_cnt_s_bin2_raddr)
        ,.func_mem_waddr      (func_ll_enq_cnt_s_bin2_waddr)
        ,.func_mem_we         (func_ll_enq_cnt_s_bin2_we)
        ,.func_mem_wdata      (func_ll_enq_cnt_s_bin2_wdata)
        ,.func_mem_rdata      (func_ll_enq_cnt_s_bin2_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_ll_enq_cnt_s_bin2_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_ll_enq_cnt_s_bin2_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_ll_enq_cnt_s_bin2_re)
        ,.pf_mem_raddr        (pf_ll_enq_cnt_s_bin2_raddr)
        ,.pf_mem_waddr        (pf_ll_enq_cnt_s_bin2_waddr)
        ,.pf_mem_we           (pf_ll_enq_cnt_s_bin2_we)
        ,.pf_mem_wdata        (pf_ll_enq_cnt_s_bin2_wdata)
        ,.pf_mem_rdata        (pf_ll_enq_cnt_s_bin2_rdata)

        ,.mem_wclk            (rf_ll_enq_cnt_s_bin2_wclk)
        ,.mem_rclk            (rf_ll_enq_cnt_s_bin2_rclk)
        ,.mem_wclk_rst_n      (rf_ll_enq_cnt_s_bin2_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_ll_enq_cnt_s_bin2_rclk_rst_n)
        ,.mem_re              (rf_ll_enq_cnt_s_bin2_re)
        ,.mem_raddr           ({rf_ll_enq_cnt_s_bin2_raddr_nc , rf_ll_enq_cnt_s_bin2_raddr})
        ,.mem_waddr           ({rf_ll_enq_cnt_s_bin2_waddr_nc , rf_ll_enq_cnt_s_bin2_waddr})
        ,.mem_we              (rf_ll_enq_cnt_s_bin2_we)
        ,.mem_wdata           (rf_ll_enq_cnt_s_bin2_wdata)
        ,.mem_rdata           (rf_ll_enq_cnt_s_bin2_rdata)

        ,.mem_rdata_error     (rf_ll_enq_cnt_s_bin2_rdata_error)
        ,.error               (rf_ll_enq_cnt_s_bin2_error)
);

logic [(       1)-1:0] rf_ll_enq_cnt_s_bin3_raddr_nc ;
logic [(       1)-1:0] rf_ll_enq_cnt_s_bin3_waddr_nc ;

logic        rf_ll_enq_cnt_s_bin3_rdata_error;

logic        cfg_mem_ack_ll_enq_cnt_s_bin3_nc;
logic [31:0] cfg_mem_rdata_ll_enq_cnt_s_bin3_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (14)
        ,.AWIDTHPAD           (1)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (2)
) i_ll_enq_cnt_s_bin3 (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_ll_enq_cnt_s_bin3_re)
        ,.func_mem_raddr      (func_ll_enq_cnt_s_bin3_raddr)
        ,.func_mem_waddr      (func_ll_enq_cnt_s_bin3_waddr)
        ,.func_mem_we         (func_ll_enq_cnt_s_bin3_we)
        ,.func_mem_wdata      (func_ll_enq_cnt_s_bin3_wdata)
        ,.func_mem_rdata      (func_ll_enq_cnt_s_bin3_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_ll_enq_cnt_s_bin3_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_ll_enq_cnt_s_bin3_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_ll_enq_cnt_s_bin3_re)
        ,.pf_mem_raddr        (pf_ll_enq_cnt_s_bin3_raddr)
        ,.pf_mem_waddr        (pf_ll_enq_cnt_s_bin3_waddr)
        ,.pf_mem_we           (pf_ll_enq_cnt_s_bin3_we)
        ,.pf_mem_wdata        (pf_ll_enq_cnt_s_bin3_wdata)
        ,.pf_mem_rdata        (pf_ll_enq_cnt_s_bin3_rdata)

        ,.mem_wclk            (rf_ll_enq_cnt_s_bin3_wclk)
        ,.mem_rclk            (rf_ll_enq_cnt_s_bin3_rclk)
        ,.mem_wclk_rst_n      (rf_ll_enq_cnt_s_bin3_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_ll_enq_cnt_s_bin3_rclk_rst_n)
        ,.mem_re              (rf_ll_enq_cnt_s_bin3_re)
        ,.mem_raddr           ({rf_ll_enq_cnt_s_bin3_raddr_nc , rf_ll_enq_cnt_s_bin3_raddr})
        ,.mem_waddr           ({rf_ll_enq_cnt_s_bin3_waddr_nc , rf_ll_enq_cnt_s_bin3_waddr})
        ,.mem_we              (rf_ll_enq_cnt_s_bin3_we)
        ,.mem_wdata           (rf_ll_enq_cnt_s_bin3_wdata)
        ,.mem_rdata           (rf_ll_enq_cnt_s_bin3_rdata)

        ,.mem_rdata_error     (rf_ll_enq_cnt_s_bin3_rdata_error)
        ,.error               (rf_ll_enq_cnt_s_bin3_error)
);

logic [(       2)-1:0] rf_ll_rdylst_hp_bin0_raddr_nc ;
logic [(       2)-1:0] rf_ll_rdylst_hp_bin0_waddr_nc ;

logic        rf_ll_rdylst_hp_bin0_rdata_error;

logic        cfg_mem_ack_ll_rdylst_hp_bin0_nc;
logic [31:0] cfg_mem_rdata_ll_rdylst_hp_bin0_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (32)
        ,.DWIDTH              (14)
        ,.AWIDTHPAD           (2)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_ll_rdylst_hp_bin0 (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_ll_rdylst_hp_bin0_re)
        ,.func_mem_raddr      (func_ll_rdylst_hp_bin0_raddr)
        ,.func_mem_waddr      (func_ll_rdylst_hp_bin0_waddr)
        ,.func_mem_we         (func_ll_rdylst_hp_bin0_we)
        ,.func_mem_wdata      (func_ll_rdylst_hp_bin0_wdata)
        ,.func_mem_rdata      (func_ll_rdylst_hp_bin0_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_ll_rdylst_hp_bin0_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_ll_rdylst_hp_bin0_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_ll_rdylst_hp_bin0_re)
        ,.pf_mem_raddr        (pf_ll_rdylst_hp_bin0_raddr)
        ,.pf_mem_waddr        (pf_ll_rdylst_hp_bin0_waddr)
        ,.pf_mem_we           (pf_ll_rdylst_hp_bin0_we)
        ,.pf_mem_wdata        (pf_ll_rdylst_hp_bin0_wdata)
        ,.pf_mem_rdata        (pf_ll_rdylst_hp_bin0_rdata)

        ,.mem_wclk            (rf_ll_rdylst_hp_bin0_wclk)
        ,.mem_rclk            (rf_ll_rdylst_hp_bin0_rclk)
        ,.mem_wclk_rst_n      (rf_ll_rdylst_hp_bin0_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_ll_rdylst_hp_bin0_rclk_rst_n)
        ,.mem_re              (rf_ll_rdylst_hp_bin0_re)
        ,.mem_raddr           ({rf_ll_rdylst_hp_bin0_raddr_nc , rf_ll_rdylst_hp_bin0_raddr})
        ,.mem_waddr           ({rf_ll_rdylst_hp_bin0_waddr_nc , rf_ll_rdylst_hp_bin0_waddr})
        ,.mem_we              (rf_ll_rdylst_hp_bin0_we)
        ,.mem_wdata           (rf_ll_rdylst_hp_bin0_wdata)
        ,.mem_rdata           (rf_ll_rdylst_hp_bin0_rdata)

        ,.mem_rdata_error     (rf_ll_rdylst_hp_bin0_rdata_error)
        ,.error               (rf_ll_rdylst_hp_bin0_error)
);

logic [(       2)-1:0] rf_ll_rdylst_hp_bin1_raddr_nc ;
logic [(       2)-1:0] rf_ll_rdylst_hp_bin1_waddr_nc ;

logic        rf_ll_rdylst_hp_bin1_rdata_error;

logic        cfg_mem_ack_ll_rdylst_hp_bin1_nc;
logic [31:0] cfg_mem_rdata_ll_rdylst_hp_bin1_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (32)
        ,.DWIDTH              (14)
        ,.AWIDTHPAD           (2)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_ll_rdylst_hp_bin1 (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_ll_rdylst_hp_bin1_re)
        ,.func_mem_raddr      (func_ll_rdylst_hp_bin1_raddr)
        ,.func_mem_waddr      (func_ll_rdylst_hp_bin1_waddr)
        ,.func_mem_we         (func_ll_rdylst_hp_bin1_we)
        ,.func_mem_wdata      (func_ll_rdylst_hp_bin1_wdata)
        ,.func_mem_rdata      (func_ll_rdylst_hp_bin1_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_ll_rdylst_hp_bin1_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_ll_rdylst_hp_bin1_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_ll_rdylst_hp_bin1_re)
        ,.pf_mem_raddr        (pf_ll_rdylst_hp_bin1_raddr)
        ,.pf_mem_waddr        (pf_ll_rdylst_hp_bin1_waddr)
        ,.pf_mem_we           (pf_ll_rdylst_hp_bin1_we)
        ,.pf_mem_wdata        (pf_ll_rdylst_hp_bin1_wdata)
        ,.pf_mem_rdata        (pf_ll_rdylst_hp_bin1_rdata)

        ,.mem_wclk            (rf_ll_rdylst_hp_bin1_wclk)
        ,.mem_rclk            (rf_ll_rdylst_hp_bin1_rclk)
        ,.mem_wclk_rst_n      (rf_ll_rdylst_hp_bin1_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_ll_rdylst_hp_bin1_rclk_rst_n)
        ,.mem_re              (rf_ll_rdylst_hp_bin1_re)
        ,.mem_raddr           ({rf_ll_rdylst_hp_bin1_raddr_nc , rf_ll_rdylst_hp_bin1_raddr})
        ,.mem_waddr           ({rf_ll_rdylst_hp_bin1_waddr_nc , rf_ll_rdylst_hp_bin1_waddr})
        ,.mem_we              (rf_ll_rdylst_hp_bin1_we)
        ,.mem_wdata           (rf_ll_rdylst_hp_bin1_wdata)
        ,.mem_rdata           (rf_ll_rdylst_hp_bin1_rdata)

        ,.mem_rdata_error     (rf_ll_rdylst_hp_bin1_rdata_error)
        ,.error               (rf_ll_rdylst_hp_bin1_error)
);

logic [(       2)-1:0] rf_ll_rdylst_hp_bin2_raddr_nc ;
logic [(       2)-1:0] rf_ll_rdylst_hp_bin2_waddr_nc ;

logic        rf_ll_rdylst_hp_bin2_rdata_error;

logic        cfg_mem_ack_ll_rdylst_hp_bin2_nc;
logic [31:0] cfg_mem_rdata_ll_rdylst_hp_bin2_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (32)
        ,.DWIDTH              (14)
        ,.AWIDTHPAD           (2)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_ll_rdylst_hp_bin2 (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_ll_rdylst_hp_bin2_re)
        ,.func_mem_raddr      (func_ll_rdylst_hp_bin2_raddr)
        ,.func_mem_waddr      (func_ll_rdylst_hp_bin2_waddr)
        ,.func_mem_we         (func_ll_rdylst_hp_bin2_we)
        ,.func_mem_wdata      (func_ll_rdylst_hp_bin2_wdata)
        ,.func_mem_rdata      (func_ll_rdylst_hp_bin2_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_ll_rdylst_hp_bin2_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_ll_rdylst_hp_bin2_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_ll_rdylst_hp_bin2_re)
        ,.pf_mem_raddr        (pf_ll_rdylst_hp_bin2_raddr)
        ,.pf_mem_waddr        (pf_ll_rdylst_hp_bin2_waddr)
        ,.pf_mem_we           (pf_ll_rdylst_hp_bin2_we)
        ,.pf_mem_wdata        (pf_ll_rdylst_hp_bin2_wdata)
        ,.pf_mem_rdata        (pf_ll_rdylst_hp_bin2_rdata)

        ,.mem_wclk            (rf_ll_rdylst_hp_bin2_wclk)
        ,.mem_rclk            (rf_ll_rdylst_hp_bin2_rclk)
        ,.mem_wclk_rst_n      (rf_ll_rdylst_hp_bin2_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_ll_rdylst_hp_bin2_rclk_rst_n)
        ,.mem_re              (rf_ll_rdylst_hp_bin2_re)
        ,.mem_raddr           ({rf_ll_rdylst_hp_bin2_raddr_nc , rf_ll_rdylst_hp_bin2_raddr})
        ,.mem_waddr           ({rf_ll_rdylst_hp_bin2_waddr_nc , rf_ll_rdylst_hp_bin2_waddr})
        ,.mem_we              (rf_ll_rdylst_hp_bin2_we)
        ,.mem_wdata           (rf_ll_rdylst_hp_bin2_wdata)
        ,.mem_rdata           (rf_ll_rdylst_hp_bin2_rdata)

        ,.mem_rdata_error     (rf_ll_rdylst_hp_bin2_rdata_error)
        ,.error               (rf_ll_rdylst_hp_bin2_error)
);

logic [(       2)-1:0] rf_ll_rdylst_hp_bin3_raddr_nc ;
logic [(       2)-1:0] rf_ll_rdylst_hp_bin3_waddr_nc ;

logic        rf_ll_rdylst_hp_bin3_rdata_error;

logic        cfg_mem_ack_ll_rdylst_hp_bin3_nc;
logic [31:0] cfg_mem_rdata_ll_rdylst_hp_bin3_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (32)
        ,.DWIDTH              (14)
        ,.AWIDTHPAD           (2)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_ll_rdylst_hp_bin3 (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_ll_rdylst_hp_bin3_re)
        ,.func_mem_raddr      (func_ll_rdylst_hp_bin3_raddr)
        ,.func_mem_waddr      (func_ll_rdylst_hp_bin3_waddr)
        ,.func_mem_we         (func_ll_rdylst_hp_bin3_we)
        ,.func_mem_wdata      (func_ll_rdylst_hp_bin3_wdata)
        ,.func_mem_rdata      (func_ll_rdylst_hp_bin3_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_ll_rdylst_hp_bin3_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_ll_rdylst_hp_bin3_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_ll_rdylst_hp_bin3_re)
        ,.pf_mem_raddr        (pf_ll_rdylst_hp_bin3_raddr)
        ,.pf_mem_waddr        (pf_ll_rdylst_hp_bin3_waddr)
        ,.pf_mem_we           (pf_ll_rdylst_hp_bin3_we)
        ,.pf_mem_wdata        (pf_ll_rdylst_hp_bin3_wdata)
        ,.pf_mem_rdata        (pf_ll_rdylst_hp_bin3_rdata)

        ,.mem_wclk            (rf_ll_rdylst_hp_bin3_wclk)
        ,.mem_rclk            (rf_ll_rdylst_hp_bin3_rclk)
        ,.mem_wclk_rst_n      (rf_ll_rdylst_hp_bin3_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_ll_rdylst_hp_bin3_rclk_rst_n)
        ,.mem_re              (rf_ll_rdylst_hp_bin3_re)
        ,.mem_raddr           ({rf_ll_rdylst_hp_bin3_raddr_nc , rf_ll_rdylst_hp_bin3_raddr})
        ,.mem_waddr           ({rf_ll_rdylst_hp_bin3_waddr_nc , rf_ll_rdylst_hp_bin3_waddr})
        ,.mem_we              (rf_ll_rdylst_hp_bin3_we)
        ,.mem_wdata           (rf_ll_rdylst_hp_bin3_wdata)
        ,.mem_rdata           (rf_ll_rdylst_hp_bin3_rdata)

        ,.mem_rdata_error     (rf_ll_rdylst_hp_bin3_rdata_error)
        ,.error               (rf_ll_rdylst_hp_bin3_error)
);

logic [(       1)-1:0] rf_ll_rdylst_hpnxt_bin0_raddr_nc ;
logic [(       1)-1:0] rf_ll_rdylst_hpnxt_bin0_waddr_nc ;

logic        rf_ll_rdylst_hpnxt_bin0_rdata_error;

logic        cfg_mem_ack_ll_rdylst_hpnxt_bin0_nc;
logic [31:0] cfg_mem_rdata_ll_rdylst_hpnxt_bin0_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (14)
        ,.AWIDTHPAD           (1)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (2)
) i_ll_rdylst_hpnxt_bin0 (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_ll_rdylst_hpnxt_bin0_re)
        ,.func_mem_raddr      (func_ll_rdylst_hpnxt_bin0_raddr)
        ,.func_mem_waddr      (func_ll_rdylst_hpnxt_bin0_waddr)
        ,.func_mem_we         (func_ll_rdylst_hpnxt_bin0_we)
        ,.func_mem_wdata      (func_ll_rdylst_hpnxt_bin0_wdata)
        ,.func_mem_rdata      (func_ll_rdylst_hpnxt_bin0_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_ll_rdylst_hpnxt_bin0_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_ll_rdylst_hpnxt_bin0_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_ll_rdylst_hpnxt_bin0_re)
        ,.pf_mem_raddr        (pf_ll_rdylst_hpnxt_bin0_raddr)
        ,.pf_mem_waddr        (pf_ll_rdylst_hpnxt_bin0_waddr)
        ,.pf_mem_we           (pf_ll_rdylst_hpnxt_bin0_we)
        ,.pf_mem_wdata        (pf_ll_rdylst_hpnxt_bin0_wdata)
        ,.pf_mem_rdata        (pf_ll_rdylst_hpnxt_bin0_rdata)

        ,.mem_wclk            (rf_ll_rdylst_hpnxt_bin0_wclk)
        ,.mem_rclk            (rf_ll_rdylst_hpnxt_bin0_rclk)
        ,.mem_wclk_rst_n      (rf_ll_rdylst_hpnxt_bin0_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_ll_rdylst_hpnxt_bin0_rclk_rst_n)
        ,.mem_re              (rf_ll_rdylst_hpnxt_bin0_re)
        ,.mem_raddr           ({rf_ll_rdylst_hpnxt_bin0_raddr_nc , rf_ll_rdylst_hpnxt_bin0_raddr})
        ,.mem_waddr           ({rf_ll_rdylst_hpnxt_bin0_waddr_nc , rf_ll_rdylst_hpnxt_bin0_waddr})
        ,.mem_we              (rf_ll_rdylst_hpnxt_bin0_we)
        ,.mem_wdata           (rf_ll_rdylst_hpnxt_bin0_wdata)
        ,.mem_rdata           (rf_ll_rdylst_hpnxt_bin0_rdata)

        ,.mem_rdata_error     (rf_ll_rdylst_hpnxt_bin0_rdata_error)
        ,.error               (rf_ll_rdylst_hpnxt_bin0_error)
);

logic [(       1)-1:0] rf_ll_rdylst_hpnxt_bin1_raddr_nc ;
logic [(       1)-1:0] rf_ll_rdylst_hpnxt_bin1_waddr_nc ;

logic        rf_ll_rdylst_hpnxt_bin1_rdata_error;

logic        cfg_mem_ack_ll_rdylst_hpnxt_bin1_nc;
logic [31:0] cfg_mem_rdata_ll_rdylst_hpnxt_bin1_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (14)
        ,.AWIDTHPAD           (1)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (2)
) i_ll_rdylst_hpnxt_bin1 (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_ll_rdylst_hpnxt_bin1_re)
        ,.func_mem_raddr      (func_ll_rdylst_hpnxt_bin1_raddr)
        ,.func_mem_waddr      (func_ll_rdylst_hpnxt_bin1_waddr)
        ,.func_mem_we         (func_ll_rdylst_hpnxt_bin1_we)
        ,.func_mem_wdata      (func_ll_rdylst_hpnxt_bin1_wdata)
        ,.func_mem_rdata      (func_ll_rdylst_hpnxt_bin1_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_ll_rdylst_hpnxt_bin1_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_ll_rdylst_hpnxt_bin1_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_ll_rdylst_hpnxt_bin1_re)
        ,.pf_mem_raddr        (pf_ll_rdylst_hpnxt_bin1_raddr)
        ,.pf_mem_waddr        (pf_ll_rdylst_hpnxt_bin1_waddr)
        ,.pf_mem_we           (pf_ll_rdylst_hpnxt_bin1_we)
        ,.pf_mem_wdata        (pf_ll_rdylst_hpnxt_bin1_wdata)
        ,.pf_mem_rdata        (pf_ll_rdylst_hpnxt_bin1_rdata)

        ,.mem_wclk            (rf_ll_rdylst_hpnxt_bin1_wclk)
        ,.mem_rclk            (rf_ll_rdylst_hpnxt_bin1_rclk)
        ,.mem_wclk_rst_n      (rf_ll_rdylst_hpnxt_bin1_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_ll_rdylst_hpnxt_bin1_rclk_rst_n)
        ,.mem_re              (rf_ll_rdylst_hpnxt_bin1_re)
        ,.mem_raddr           ({rf_ll_rdylst_hpnxt_bin1_raddr_nc , rf_ll_rdylst_hpnxt_bin1_raddr})
        ,.mem_waddr           ({rf_ll_rdylst_hpnxt_bin1_waddr_nc , rf_ll_rdylst_hpnxt_bin1_waddr})
        ,.mem_we              (rf_ll_rdylst_hpnxt_bin1_we)
        ,.mem_wdata           (rf_ll_rdylst_hpnxt_bin1_wdata)
        ,.mem_rdata           (rf_ll_rdylst_hpnxt_bin1_rdata)

        ,.mem_rdata_error     (rf_ll_rdylst_hpnxt_bin1_rdata_error)
        ,.error               (rf_ll_rdylst_hpnxt_bin1_error)
);

logic [(       1)-1:0] rf_ll_rdylst_hpnxt_bin2_raddr_nc ;
logic [(       1)-1:0] rf_ll_rdylst_hpnxt_bin2_waddr_nc ;

logic        rf_ll_rdylst_hpnxt_bin2_rdata_error;

logic        cfg_mem_ack_ll_rdylst_hpnxt_bin2_nc;
logic [31:0] cfg_mem_rdata_ll_rdylst_hpnxt_bin2_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (14)
        ,.AWIDTHPAD           (1)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (2)
) i_ll_rdylst_hpnxt_bin2 (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_ll_rdylst_hpnxt_bin2_re)
        ,.func_mem_raddr      (func_ll_rdylst_hpnxt_bin2_raddr)
        ,.func_mem_waddr      (func_ll_rdylst_hpnxt_bin2_waddr)
        ,.func_mem_we         (func_ll_rdylst_hpnxt_bin2_we)
        ,.func_mem_wdata      (func_ll_rdylst_hpnxt_bin2_wdata)
        ,.func_mem_rdata      (func_ll_rdylst_hpnxt_bin2_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_ll_rdylst_hpnxt_bin2_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_ll_rdylst_hpnxt_bin2_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_ll_rdylst_hpnxt_bin2_re)
        ,.pf_mem_raddr        (pf_ll_rdylst_hpnxt_bin2_raddr)
        ,.pf_mem_waddr        (pf_ll_rdylst_hpnxt_bin2_waddr)
        ,.pf_mem_we           (pf_ll_rdylst_hpnxt_bin2_we)
        ,.pf_mem_wdata        (pf_ll_rdylst_hpnxt_bin2_wdata)
        ,.pf_mem_rdata        (pf_ll_rdylst_hpnxt_bin2_rdata)

        ,.mem_wclk            (rf_ll_rdylst_hpnxt_bin2_wclk)
        ,.mem_rclk            (rf_ll_rdylst_hpnxt_bin2_rclk)
        ,.mem_wclk_rst_n      (rf_ll_rdylst_hpnxt_bin2_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_ll_rdylst_hpnxt_bin2_rclk_rst_n)
        ,.mem_re              (rf_ll_rdylst_hpnxt_bin2_re)
        ,.mem_raddr           ({rf_ll_rdylst_hpnxt_bin2_raddr_nc , rf_ll_rdylst_hpnxt_bin2_raddr})
        ,.mem_waddr           ({rf_ll_rdylst_hpnxt_bin2_waddr_nc , rf_ll_rdylst_hpnxt_bin2_waddr})
        ,.mem_we              (rf_ll_rdylst_hpnxt_bin2_we)
        ,.mem_wdata           (rf_ll_rdylst_hpnxt_bin2_wdata)
        ,.mem_rdata           (rf_ll_rdylst_hpnxt_bin2_rdata)

        ,.mem_rdata_error     (rf_ll_rdylst_hpnxt_bin2_rdata_error)
        ,.error               (rf_ll_rdylst_hpnxt_bin2_error)
);

logic [(       1)-1:0] rf_ll_rdylst_hpnxt_bin3_raddr_nc ;
logic [(       1)-1:0] rf_ll_rdylst_hpnxt_bin3_waddr_nc ;

logic        rf_ll_rdylst_hpnxt_bin3_rdata_error;

logic        cfg_mem_ack_ll_rdylst_hpnxt_bin3_nc;
logic [31:0] cfg_mem_rdata_ll_rdylst_hpnxt_bin3_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (14)
        ,.AWIDTHPAD           (1)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (2)
) i_ll_rdylst_hpnxt_bin3 (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_ll_rdylst_hpnxt_bin3_re)
        ,.func_mem_raddr      (func_ll_rdylst_hpnxt_bin3_raddr)
        ,.func_mem_waddr      (func_ll_rdylst_hpnxt_bin3_waddr)
        ,.func_mem_we         (func_ll_rdylst_hpnxt_bin3_we)
        ,.func_mem_wdata      (func_ll_rdylst_hpnxt_bin3_wdata)
        ,.func_mem_rdata      (func_ll_rdylst_hpnxt_bin3_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_ll_rdylst_hpnxt_bin3_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_ll_rdylst_hpnxt_bin3_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_ll_rdylst_hpnxt_bin3_re)
        ,.pf_mem_raddr        (pf_ll_rdylst_hpnxt_bin3_raddr)
        ,.pf_mem_waddr        (pf_ll_rdylst_hpnxt_bin3_waddr)
        ,.pf_mem_we           (pf_ll_rdylst_hpnxt_bin3_we)
        ,.pf_mem_wdata        (pf_ll_rdylst_hpnxt_bin3_wdata)
        ,.pf_mem_rdata        (pf_ll_rdylst_hpnxt_bin3_rdata)

        ,.mem_wclk            (rf_ll_rdylst_hpnxt_bin3_wclk)
        ,.mem_rclk            (rf_ll_rdylst_hpnxt_bin3_rclk)
        ,.mem_wclk_rst_n      (rf_ll_rdylst_hpnxt_bin3_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_ll_rdylst_hpnxt_bin3_rclk_rst_n)
        ,.mem_re              (rf_ll_rdylst_hpnxt_bin3_re)
        ,.mem_raddr           ({rf_ll_rdylst_hpnxt_bin3_raddr_nc , rf_ll_rdylst_hpnxt_bin3_raddr})
        ,.mem_waddr           ({rf_ll_rdylst_hpnxt_bin3_waddr_nc , rf_ll_rdylst_hpnxt_bin3_waddr})
        ,.mem_we              (rf_ll_rdylst_hpnxt_bin3_we)
        ,.mem_wdata           (rf_ll_rdylst_hpnxt_bin3_wdata)
        ,.mem_rdata           (rf_ll_rdylst_hpnxt_bin3_rdata)

        ,.mem_rdata_error     (rf_ll_rdylst_hpnxt_bin3_rdata_error)
        ,.error               (rf_ll_rdylst_hpnxt_bin3_error)
);

logic [(       2)-1:0] rf_ll_rdylst_tp_bin0_raddr_nc ;
logic [(       2)-1:0] rf_ll_rdylst_tp_bin0_waddr_nc ;

logic        rf_ll_rdylst_tp_bin0_rdata_error;

logic        cfg_mem_ack_ll_rdylst_tp_bin0_nc;
logic [31:0] cfg_mem_rdata_ll_rdylst_tp_bin0_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (32)
        ,.DWIDTH              (14)
        ,.AWIDTHPAD           (2)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_ll_rdylst_tp_bin0 (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_ll_rdylst_tp_bin0_re)
        ,.func_mem_raddr      (func_ll_rdylst_tp_bin0_raddr)
        ,.func_mem_waddr      (func_ll_rdylst_tp_bin0_waddr)
        ,.func_mem_we         (func_ll_rdylst_tp_bin0_we)
        ,.func_mem_wdata      (func_ll_rdylst_tp_bin0_wdata)
        ,.func_mem_rdata      (func_ll_rdylst_tp_bin0_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_ll_rdylst_tp_bin0_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_ll_rdylst_tp_bin0_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_ll_rdylst_tp_bin0_re)
        ,.pf_mem_raddr        (pf_ll_rdylst_tp_bin0_raddr)
        ,.pf_mem_waddr        (pf_ll_rdylst_tp_bin0_waddr)
        ,.pf_mem_we           (pf_ll_rdylst_tp_bin0_we)
        ,.pf_mem_wdata        (pf_ll_rdylst_tp_bin0_wdata)
        ,.pf_mem_rdata        (pf_ll_rdylst_tp_bin0_rdata)

        ,.mem_wclk            (rf_ll_rdylst_tp_bin0_wclk)
        ,.mem_rclk            (rf_ll_rdylst_tp_bin0_rclk)
        ,.mem_wclk_rst_n      (rf_ll_rdylst_tp_bin0_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_ll_rdylst_tp_bin0_rclk_rst_n)
        ,.mem_re              (rf_ll_rdylst_tp_bin0_re)
        ,.mem_raddr           ({rf_ll_rdylst_tp_bin0_raddr_nc , rf_ll_rdylst_tp_bin0_raddr})
        ,.mem_waddr           ({rf_ll_rdylst_tp_bin0_waddr_nc , rf_ll_rdylst_tp_bin0_waddr})
        ,.mem_we              (rf_ll_rdylst_tp_bin0_we)
        ,.mem_wdata           (rf_ll_rdylst_tp_bin0_wdata)
        ,.mem_rdata           (rf_ll_rdylst_tp_bin0_rdata)

        ,.mem_rdata_error     (rf_ll_rdylst_tp_bin0_rdata_error)
        ,.error               (rf_ll_rdylst_tp_bin0_error)
);

logic [(       2)-1:0] rf_ll_rdylst_tp_bin1_raddr_nc ;
logic [(       2)-1:0] rf_ll_rdylst_tp_bin1_waddr_nc ;

logic        rf_ll_rdylst_tp_bin1_rdata_error;

logic        cfg_mem_ack_ll_rdylst_tp_bin1_nc;
logic [31:0] cfg_mem_rdata_ll_rdylst_tp_bin1_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (32)
        ,.DWIDTH              (14)
        ,.AWIDTHPAD           (2)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_ll_rdylst_tp_bin1 (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_ll_rdylst_tp_bin1_re)
        ,.func_mem_raddr      (func_ll_rdylst_tp_bin1_raddr)
        ,.func_mem_waddr      (func_ll_rdylst_tp_bin1_waddr)
        ,.func_mem_we         (func_ll_rdylst_tp_bin1_we)
        ,.func_mem_wdata      (func_ll_rdylst_tp_bin1_wdata)
        ,.func_mem_rdata      (func_ll_rdylst_tp_bin1_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_ll_rdylst_tp_bin1_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_ll_rdylst_tp_bin1_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_ll_rdylst_tp_bin1_re)
        ,.pf_mem_raddr        (pf_ll_rdylst_tp_bin1_raddr)
        ,.pf_mem_waddr        (pf_ll_rdylst_tp_bin1_waddr)
        ,.pf_mem_we           (pf_ll_rdylst_tp_bin1_we)
        ,.pf_mem_wdata        (pf_ll_rdylst_tp_bin1_wdata)
        ,.pf_mem_rdata        (pf_ll_rdylst_tp_bin1_rdata)

        ,.mem_wclk            (rf_ll_rdylst_tp_bin1_wclk)
        ,.mem_rclk            (rf_ll_rdylst_tp_bin1_rclk)
        ,.mem_wclk_rst_n      (rf_ll_rdylst_tp_bin1_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_ll_rdylst_tp_bin1_rclk_rst_n)
        ,.mem_re              (rf_ll_rdylst_tp_bin1_re)
        ,.mem_raddr           ({rf_ll_rdylst_tp_bin1_raddr_nc , rf_ll_rdylst_tp_bin1_raddr})
        ,.mem_waddr           ({rf_ll_rdylst_tp_bin1_waddr_nc , rf_ll_rdylst_tp_bin1_waddr})
        ,.mem_we              (rf_ll_rdylst_tp_bin1_we)
        ,.mem_wdata           (rf_ll_rdylst_tp_bin1_wdata)
        ,.mem_rdata           (rf_ll_rdylst_tp_bin1_rdata)

        ,.mem_rdata_error     (rf_ll_rdylst_tp_bin1_rdata_error)
        ,.error               (rf_ll_rdylst_tp_bin1_error)
);

logic [(       2)-1:0] rf_ll_rdylst_tp_bin2_raddr_nc ;
logic [(       2)-1:0] rf_ll_rdylst_tp_bin2_waddr_nc ;

logic        rf_ll_rdylst_tp_bin2_rdata_error;

logic        cfg_mem_ack_ll_rdylst_tp_bin2_nc;
logic [31:0] cfg_mem_rdata_ll_rdylst_tp_bin2_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (32)
        ,.DWIDTH              (14)
        ,.AWIDTHPAD           (2)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_ll_rdylst_tp_bin2 (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_ll_rdylst_tp_bin2_re)
        ,.func_mem_raddr      (func_ll_rdylst_tp_bin2_raddr)
        ,.func_mem_waddr      (func_ll_rdylst_tp_bin2_waddr)
        ,.func_mem_we         (func_ll_rdylst_tp_bin2_we)
        ,.func_mem_wdata      (func_ll_rdylst_tp_bin2_wdata)
        ,.func_mem_rdata      (func_ll_rdylst_tp_bin2_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_ll_rdylst_tp_bin2_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_ll_rdylst_tp_bin2_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_ll_rdylst_tp_bin2_re)
        ,.pf_mem_raddr        (pf_ll_rdylst_tp_bin2_raddr)
        ,.pf_mem_waddr        (pf_ll_rdylst_tp_bin2_waddr)
        ,.pf_mem_we           (pf_ll_rdylst_tp_bin2_we)
        ,.pf_mem_wdata        (pf_ll_rdylst_tp_bin2_wdata)
        ,.pf_mem_rdata        (pf_ll_rdylst_tp_bin2_rdata)

        ,.mem_wclk            (rf_ll_rdylst_tp_bin2_wclk)
        ,.mem_rclk            (rf_ll_rdylst_tp_bin2_rclk)
        ,.mem_wclk_rst_n      (rf_ll_rdylst_tp_bin2_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_ll_rdylst_tp_bin2_rclk_rst_n)
        ,.mem_re              (rf_ll_rdylst_tp_bin2_re)
        ,.mem_raddr           ({rf_ll_rdylst_tp_bin2_raddr_nc , rf_ll_rdylst_tp_bin2_raddr})
        ,.mem_waddr           ({rf_ll_rdylst_tp_bin2_waddr_nc , rf_ll_rdylst_tp_bin2_waddr})
        ,.mem_we              (rf_ll_rdylst_tp_bin2_we)
        ,.mem_wdata           (rf_ll_rdylst_tp_bin2_wdata)
        ,.mem_rdata           (rf_ll_rdylst_tp_bin2_rdata)

        ,.mem_rdata_error     (rf_ll_rdylst_tp_bin2_rdata_error)
        ,.error               (rf_ll_rdylst_tp_bin2_error)
);

logic [(       2)-1:0] rf_ll_rdylst_tp_bin3_raddr_nc ;
logic [(       2)-1:0] rf_ll_rdylst_tp_bin3_waddr_nc ;

logic        rf_ll_rdylst_tp_bin3_rdata_error;

logic        cfg_mem_ack_ll_rdylst_tp_bin3_nc;
logic [31:0] cfg_mem_rdata_ll_rdylst_tp_bin3_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (32)
        ,.DWIDTH              (14)
        ,.AWIDTHPAD           (2)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_ll_rdylst_tp_bin3 (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_ll_rdylst_tp_bin3_re)
        ,.func_mem_raddr      (func_ll_rdylst_tp_bin3_raddr)
        ,.func_mem_waddr      (func_ll_rdylst_tp_bin3_waddr)
        ,.func_mem_we         (func_ll_rdylst_tp_bin3_we)
        ,.func_mem_wdata      (func_ll_rdylst_tp_bin3_wdata)
        ,.func_mem_rdata      (func_ll_rdylst_tp_bin3_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_ll_rdylst_tp_bin3_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_ll_rdylst_tp_bin3_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_ll_rdylst_tp_bin3_re)
        ,.pf_mem_raddr        (pf_ll_rdylst_tp_bin3_raddr)
        ,.pf_mem_waddr        (pf_ll_rdylst_tp_bin3_waddr)
        ,.pf_mem_we           (pf_ll_rdylst_tp_bin3_we)
        ,.pf_mem_wdata        (pf_ll_rdylst_tp_bin3_wdata)
        ,.pf_mem_rdata        (pf_ll_rdylst_tp_bin3_rdata)

        ,.mem_wclk            (rf_ll_rdylst_tp_bin3_wclk)
        ,.mem_rclk            (rf_ll_rdylst_tp_bin3_rclk)
        ,.mem_wclk_rst_n      (rf_ll_rdylst_tp_bin3_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_ll_rdylst_tp_bin3_rclk_rst_n)
        ,.mem_re              (rf_ll_rdylst_tp_bin3_re)
        ,.mem_raddr           ({rf_ll_rdylst_tp_bin3_raddr_nc , rf_ll_rdylst_tp_bin3_raddr})
        ,.mem_waddr           ({rf_ll_rdylst_tp_bin3_waddr_nc , rf_ll_rdylst_tp_bin3_waddr})
        ,.mem_we              (rf_ll_rdylst_tp_bin3_we)
        ,.mem_wdata           (rf_ll_rdylst_tp_bin3_wdata)
        ,.mem_rdata           (rf_ll_rdylst_tp_bin3_rdata)

        ,.mem_rdata_error     (rf_ll_rdylst_tp_bin3_rdata_error)
        ,.error               (rf_ll_rdylst_tp_bin3_error)
);

logic [(       2)-1:0] rf_ll_rlst_cnt_raddr_nc ;
logic [(       2)-1:0] rf_ll_rlst_cnt_waddr_nc ;

logic        rf_ll_rlst_cnt_rdata_error;

logic        cfg_mem_ack_ll_rlst_cnt_nc;
logic [31:0] cfg_mem_rdata_ll_rlst_cnt_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (32)
        ,.DWIDTH              (56)
        ,.AWIDTHPAD           (2)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_ll_rlst_cnt (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_ll_rlst_cnt_re)
        ,.func_mem_raddr      (func_ll_rlst_cnt_raddr)
        ,.func_mem_waddr      (func_ll_rlst_cnt_waddr)
        ,.func_mem_we         (func_ll_rlst_cnt_we)
        ,.func_mem_wdata      (func_ll_rlst_cnt_wdata)
        ,.func_mem_rdata      (func_ll_rlst_cnt_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_ll_rlst_cnt_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_ll_rlst_cnt_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_ll_rlst_cnt_re)
        ,.pf_mem_raddr        (pf_ll_rlst_cnt_raddr)
        ,.pf_mem_waddr        (pf_ll_rlst_cnt_waddr)
        ,.pf_mem_we           (pf_ll_rlst_cnt_we)
        ,.pf_mem_wdata        (pf_ll_rlst_cnt_wdata)
        ,.pf_mem_rdata        (pf_ll_rlst_cnt_rdata)

        ,.mem_wclk            (rf_ll_rlst_cnt_wclk)
        ,.mem_rclk            (rf_ll_rlst_cnt_rclk)
        ,.mem_wclk_rst_n      (rf_ll_rlst_cnt_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_ll_rlst_cnt_rclk_rst_n)
        ,.mem_re              (rf_ll_rlst_cnt_re)
        ,.mem_raddr           ({rf_ll_rlst_cnt_raddr_nc , rf_ll_rlst_cnt_raddr})
        ,.mem_waddr           ({rf_ll_rlst_cnt_waddr_nc , rf_ll_rlst_cnt_waddr})
        ,.mem_we              (rf_ll_rlst_cnt_we)
        ,.mem_wdata           (rf_ll_rlst_cnt_wdata)
        ,.mem_rdata           (rf_ll_rlst_cnt_rdata)

        ,.mem_rdata_error     (rf_ll_rlst_cnt_rdata_error)
        ,.error               (rf_ll_rlst_cnt_error)
);

logic [(       1)-1:0] rf_ll_sch_cnt_dup0_raddr_nc ;
logic [(       1)-1:0] rf_ll_sch_cnt_dup0_waddr_nc ;

logic        rf_ll_sch_cnt_dup0_rdata_error;

logic        cfg_mem_ack_ll_sch_cnt_dup0_nc;
logic [31:0] cfg_mem_rdata_ll_sch_cnt_dup0_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (15)
        ,.AWIDTHPAD           (1)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (2)
) i_ll_sch_cnt_dup0 (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_ll_sch_cnt_dup0_re)
        ,.func_mem_raddr      (func_ll_sch_cnt_dup0_raddr)
        ,.func_mem_waddr      (func_ll_sch_cnt_dup0_waddr)
        ,.func_mem_we         (func_ll_sch_cnt_dup0_we)
        ,.func_mem_wdata      (func_ll_sch_cnt_dup0_wdata)
        ,.func_mem_rdata      (func_ll_sch_cnt_dup0_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_ll_sch_cnt_dup0_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_ll_sch_cnt_dup0_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_ll_sch_cnt_dup0_re)
        ,.pf_mem_raddr        (pf_ll_sch_cnt_dup0_raddr)
        ,.pf_mem_waddr        (pf_ll_sch_cnt_dup0_waddr)
        ,.pf_mem_we           (pf_ll_sch_cnt_dup0_we)
        ,.pf_mem_wdata        (pf_ll_sch_cnt_dup0_wdata)
        ,.pf_mem_rdata        (pf_ll_sch_cnt_dup0_rdata)

        ,.mem_wclk            (rf_ll_sch_cnt_dup0_wclk)
        ,.mem_rclk            (rf_ll_sch_cnt_dup0_rclk)
        ,.mem_wclk_rst_n      (rf_ll_sch_cnt_dup0_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_ll_sch_cnt_dup0_rclk_rst_n)
        ,.mem_re              (rf_ll_sch_cnt_dup0_re)
        ,.mem_raddr           ({rf_ll_sch_cnt_dup0_raddr_nc , rf_ll_sch_cnt_dup0_raddr})
        ,.mem_waddr           ({rf_ll_sch_cnt_dup0_waddr_nc , rf_ll_sch_cnt_dup0_waddr})
        ,.mem_we              (rf_ll_sch_cnt_dup0_we)
        ,.mem_wdata           (rf_ll_sch_cnt_dup0_wdata)
        ,.mem_rdata           (rf_ll_sch_cnt_dup0_rdata)

        ,.mem_rdata_error     (rf_ll_sch_cnt_dup0_rdata_error)
        ,.error               (rf_ll_sch_cnt_dup0_error)
);

logic [(       1)-1:0] rf_ll_sch_cnt_dup1_raddr_nc ;
logic [(       1)-1:0] rf_ll_sch_cnt_dup1_waddr_nc ;

logic        rf_ll_sch_cnt_dup1_rdata_error;

logic        cfg_mem_ack_ll_sch_cnt_dup1_nc;
logic [31:0] cfg_mem_rdata_ll_sch_cnt_dup1_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (15)
        ,.AWIDTHPAD           (1)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (2)
) i_ll_sch_cnt_dup1 (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_ll_sch_cnt_dup1_re)
        ,.func_mem_raddr      (func_ll_sch_cnt_dup1_raddr)
        ,.func_mem_waddr      (func_ll_sch_cnt_dup1_waddr)
        ,.func_mem_we         (func_ll_sch_cnt_dup1_we)
        ,.func_mem_wdata      (func_ll_sch_cnt_dup1_wdata)
        ,.func_mem_rdata      (func_ll_sch_cnt_dup1_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_ll_sch_cnt_dup1_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_ll_sch_cnt_dup1_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_ll_sch_cnt_dup1_re)
        ,.pf_mem_raddr        (pf_ll_sch_cnt_dup1_raddr)
        ,.pf_mem_waddr        (pf_ll_sch_cnt_dup1_waddr)
        ,.pf_mem_we           (pf_ll_sch_cnt_dup1_we)
        ,.pf_mem_wdata        (pf_ll_sch_cnt_dup1_wdata)
        ,.pf_mem_rdata        (pf_ll_sch_cnt_dup1_rdata)

        ,.mem_wclk            (rf_ll_sch_cnt_dup1_wclk)
        ,.mem_rclk            (rf_ll_sch_cnt_dup1_rclk)
        ,.mem_wclk_rst_n      (rf_ll_sch_cnt_dup1_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_ll_sch_cnt_dup1_rclk_rst_n)
        ,.mem_re              (rf_ll_sch_cnt_dup1_re)
        ,.mem_raddr           ({rf_ll_sch_cnt_dup1_raddr_nc , rf_ll_sch_cnt_dup1_raddr})
        ,.mem_waddr           ({rf_ll_sch_cnt_dup1_waddr_nc , rf_ll_sch_cnt_dup1_waddr})
        ,.mem_we              (rf_ll_sch_cnt_dup1_we)
        ,.mem_wdata           (rf_ll_sch_cnt_dup1_wdata)
        ,.mem_rdata           (rf_ll_sch_cnt_dup1_rdata)

        ,.mem_rdata_error     (rf_ll_sch_cnt_dup1_rdata_error)
        ,.error               (rf_ll_sch_cnt_dup1_error)
);

logic [(       1)-1:0] rf_ll_sch_cnt_dup2_raddr_nc ;
logic [(       1)-1:0] rf_ll_sch_cnt_dup2_waddr_nc ;

logic        rf_ll_sch_cnt_dup2_rdata_error;

logic        cfg_mem_ack_ll_sch_cnt_dup2_nc;
logic [31:0] cfg_mem_rdata_ll_sch_cnt_dup2_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (15)
        ,.AWIDTHPAD           (1)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (2)
) i_ll_sch_cnt_dup2 (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_ll_sch_cnt_dup2_re)
        ,.func_mem_raddr      (func_ll_sch_cnt_dup2_raddr)
        ,.func_mem_waddr      (func_ll_sch_cnt_dup2_waddr)
        ,.func_mem_we         (func_ll_sch_cnt_dup2_we)
        ,.func_mem_wdata      (func_ll_sch_cnt_dup2_wdata)
        ,.func_mem_rdata      (func_ll_sch_cnt_dup2_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_ll_sch_cnt_dup2_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_ll_sch_cnt_dup2_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_ll_sch_cnt_dup2_re)
        ,.pf_mem_raddr        (pf_ll_sch_cnt_dup2_raddr)
        ,.pf_mem_waddr        (pf_ll_sch_cnt_dup2_waddr)
        ,.pf_mem_we           (pf_ll_sch_cnt_dup2_we)
        ,.pf_mem_wdata        (pf_ll_sch_cnt_dup2_wdata)
        ,.pf_mem_rdata        (pf_ll_sch_cnt_dup2_rdata)

        ,.mem_wclk            (rf_ll_sch_cnt_dup2_wclk)
        ,.mem_rclk            (rf_ll_sch_cnt_dup2_rclk)
        ,.mem_wclk_rst_n      (rf_ll_sch_cnt_dup2_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_ll_sch_cnt_dup2_rclk_rst_n)
        ,.mem_re              (rf_ll_sch_cnt_dup2_re)
        ,.mem_raddr           ({rf_ll_sch_cnt_dup2_raddr_nc , rf_ll_sch_cnt_dup2_raddr})
        ,.mem_waddr           ({rf_ll_sch_cnt_dup2_waddr_nc , rf_ll_sch_cnt_dup2_waddr})
        ,.mem_we              (rf_ll_sch_cnt_dup2_we)
        ,.mem_wdata           (rf_ll_sch_cnt_dup2_wdata)
        ,.mem_rdata           (rf_ll_sch_cnt_dup2_rdata)

        ,.mem_rdata_error     (rf_ll_sch_cnt_dup2_rdata_error)
        ,.error               (rf_ll_sch_cnt_dup2_error)
);

logic [(       1)-1:0] rf_ll_sch_cnt_dup3_raddr_nc ;
logic [(       1)-1:0] rf_ll_sch_cnt_dup3_waddr_nc ;

logic        rf_ll_sch_cnt_dup3_rdata_error;

logic        cfg_mem_ack_ll_sch_cnt_dup3_nc;
logic [31:0] cfg_mem_rdata_ll_sch_cnt_dup3_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (15)
        ,.AWIDTHPAD           (1)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (2)
) i_ll_sch_cnt_dup3 (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_ll_sch_cnt_dup3_re)
        ,.func_mem_raddr      (func_ll_sch_cnt_dup3_raddr)
        ,.func_mem_waddr      (func_ll_sch_cnt_dup3_waddr)
        ,.func_mem_we         (func_ll_sch_cnt_dup3_we)
        ,.func_mem_wdata      (func_ll_sch_cnt_dup3_wdata)
        ,.func_mem_rdata      (func_ll_sch_cnt_dup3_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_ll_sch_cnt_dup3_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_ll_sch_cnt_dup3_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_ll_sch_cnt_dup3_re)
        ,.pf_mem_raddr        (pf_ll_sch_cnt_dup3_raddr)
        ,.pf_mem_waddr        (pf_ll_sch_cnt_dup3_waddr)
        ,.pf_mem_we           (pf_ll_sch_cnt_dup3_we)
        ,.pf_mem_wdata        (pf_ll_sch_cnt_dup3_wdata)
        ,.pf_mem_rdata        (pf_ll_sch_cnt_dup3_rdata)

        ,.mem_wclk            (rf_ll_sch_cnt_dup3_wclk)
        ,.mem_rclk            (rf_ll_sch_cnt_dup3_rclk)
        ,.mem_wclk_rst_n      (rf_ll_sch_cnt_dup3_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_ll_sch_cnt_dup3_rclk_rst_n)
        ,.mem_re              (rf_ll_sch_cnt_dup3_re)
        ,.mem_raddr           ({rf_ll_sch_cnt_dup3_raddr_nc , rf_ll_sch_cnt_dup3_raddr})
        ,.mem_waddr           ({rf_ll_sch_cnt_dup3_waddr_nc , rf_ll_sch_cnt_dup3_waddr})
        ,.mem_we              (rf_ll_sch_cnt_dup3_we)
        ,.mem_wdata           (rf_ll_sch_cnt_dup3_wdata)
        ,.mem_rdata           (rf_ll_sch_cnt_dup3_rdata)

        ,.mem_rdata_error     (rf_ll_sch_cnt_dup3_rdata_error)
        ,.error               (rf_ll_sch_cnt_dup3_error)
);

logic        rf_ll_schlst_hp_bin0_rdata_error;

logic        cfg_mem_ack_ll_schlst_hp_bin0_nc;
logic [31:0] cfg_mem_rdata_ll_schlst_hp_bin0_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (512)
        ,.DWIDTH              (14)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_ll_schlst_hp_bin0 (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_ll_schlst_hp_bin0_re)
        ,.func_mem_raddr      (func_ll_schlst_hp_bin0_raddr)
        ,.func_mem_waddr      (func_ll_schlst_hp_bin0_waddr)
        ,.func_mem_we         (func_ll_schlst_hp_bin0_we)
        ,.func_mem_wdata      (func_ll_schlst_hp_bin0_wdata)
        ,.func_mem_rdata      (func_ll_schlst_hp_bin0_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_ll_schlst_hp_bin0_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_ll_schlst_hp_bin0_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_ll_schlst_hp_bin0_re)
        ,.pf_mem_raddr        (pf_ll_schlst_hp_bin0_raddr)
        ,.pf_mem_waddr        (pf_ll_schlst_hp_bin0_waddr)
        ,.pf_mem_we           (pf_ll_schlst_hp_bin0_we)
        ,.pf_mem_wdata        (pf_ll_schlst_hp_bin0_wdata)
        ,.pf_mem_rdata        (pf_ll_schlst_hp_bin0_rdata)

        ,.mem_wclk            (rf_ll_schlst_hp_bin0_wclk)
        ,.mem_rclk            (rf_ll_schlst_hp_bin0_rclk)
        ,.mem_wclk_rst_n      (rf_ll_schlst_hp_bin0_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_ll_schlst_hp_bin0_rclk_rst_n)
        ,.mem_re              (rf_ll_schlst_hp_bin0_re)
        ,.mem_raddr           (rf_ll_schlst_hp_bin0_raddr)
        ,.mem_waddr           (rf_ll_schlst_hp_bin0_waddr)
        ,.mem_we              (rf_ll_schlst_hp_bin0_we)
        ,.mem_wdata           (rf_ll_schlst_hp_bin0_wdata)
        ,.mem_rdata           (rf_ll_schlst_hp_bin0_rdata)

        ,.mem_rdata_error     (rf_ll_schlst_hp_bin0_rdata_error)
        ,.error               (rf_ll_schlst_hp_bin0_error)
);

logic        rf_ll_schlst_hp_bin1_rdata_error;

logic        cfg_mem_ack_ll_schlst_hp_bin1_nc;
logic [31:0] cfg_mem_rdata_ll_schlst_hp_bin1_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (512)
        ,.DWIDTH              (14)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_ll_schlst_hp_bin1 (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_ll_schlst_hp_bin1_re)
        ,.func_mem_raddr      (func_ll_schlst_hp_bin1_raddr)
        ,.func_mem_waddr      (func_ll_schlst_hp_bin1_waddr)
        ,.func_mem_we         (func_ll_schlst_hp_bin1_we)
        ,.func_mem_wdata      (func_ll_schlst_hp_bin1_wdata)
        ,.func_mem_rdata      (func_ll_schlst_hp_bin1_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_ll_schlst_hp_bin1_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_ll_schlst_hp_bin1_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_ll_schlst_hp_bin1_re)
        ,.pf_mem_raddr        (pf_ll_schlst_hp_bin1_raddr)
        ,.pf_mem_waddr        (pf_ll_schlst_hp_bin1_waddr)
        ,.pf_mem_we           (pf_ll_schlst_hp_bin1_we)
        ,.pf_mem_wdata        (pf_ll_schlst_hp_bin1_wdata)
        ,.pf_mem_rdata        (pf_ll_schlst_hp_bin1_rdata)

        ,.mem_wclk            (rf_ll_schlst_hp_bin1_wclk)
        ,.mem_rclk            (rf_ll_schlst_hp_bin1_rclk)
        ,.mem_wclk_rst_n      (rf_ll_schlst_hp_bin1_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_ll_schlst_hp_bin1_rclk_rst_n)
        ,.mem_re              (rf_ll_schlst_hp_bin1_re)
        ,.mem_raddr           (rf_ll_schlst_hp_bin1_raddr)
        ,.mem_waddr           (rf_ll_schlst_hp_bin1_waddr)
        ,.mem_we              (rf_ll_schlst_hp_bin1_we)
        ,.mem_wdata           (rf_ll_schlst_hp_bin1_wdata)
        ,.mem_rdata           (rf_ll_schlst_hp_bin1_rdata)

        ,.mem_rdata_error     (rf_ll_schlst_hp_bin1_rdata_error)
        ,.error               (rf_ll_schlst_hp_bin1_error)
);

logic        rf_ll_schlst_hp_bin2_rdata_error;

logic        cfg_mem_ack_ll_schlst_hp_bin2_nc;
logic [31:0] cfg_mem_rdata_ll_schlst_hp_bin2_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (512)
        ,.DWIDTH              (14)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_ll_schlst_hp_bin2 (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_ll_schlst_hp_bin2_re)
        ,.func_mem_raddr      (func_ll_schlst_hp_bin2_raddr)
        ,.func_mem_waddr      (func_ll_schlst_hp_bin2_waddr)
        ,.func_mem_we         (func_ll_schlst_hp_bin2_we)
        ,.func_mem_wdata      (func_ll_schlst_hp_bin2_wdata)
        ,.func_mem_rdata      (func_ll_schlst_hp_bin2_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_ll_schlst_hp_bin2_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_ll_schlst_hp_bin2_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_ll_schlst_hp_bin2_re)
        ,.pf_mem_raddr        (pf_ll_schlst_hp_bin2_raddr)
        ,.pf_mem_waddr        (pf_ll_schlst_hp_bin2_waddr)
        ,.pf_mem_we           (pf_ll_schlst_hp_bin2_we)
        ,.pf_mem_wdata        (pf_ll_schlst_hp_bin2_wdata)
        ,.pf_mem_rdata        (pf_ll_schlst_hp_bin2_rdata)

        ,.mem_wclk            (rf_ll_schlst_hp_bin2_wclk)
        ,.mem_rclk            (rf_ll_schlst_hp_bin2_rclk)
        ,.mem_wclk_rst_n      (rf_ll_schlst_hp_bin2_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_ll_schlst_hp_bin2_rclk_rst_n)
        ,.mem_re              (rf_ll_schlst_hp_bin2_re)
        ,.mem_raddr           (rf_ll_schlst_hp_bin2_raddr)
        ,.mem_waddr           (rf_ll_schlst_hp_bin2_waddr)
        ,.mem_we              (rf_ll_schlst_hp_bin2_we)
        ,.mem_wdata           (rf_ll_schlst_hp_bin2_wdata)
        ,.mem_rdata           (rf_ll_schlst_hp_bin2_rdata)

        ,.mem_rdata_error     (rf_ll_schlst_hp_bin2_rdata_error)
        ,.error               (rf_ll_schlst_hp_bin2_error)
);

logic        rf_ll_schlst_hp_bin3_rdata_error;

logic        cfg_mem_ack_ll_schlst_hp_bin3_nc;
logic [31:0] cfg_mem_rdata_ll_schlst_hp_bin3_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (512)
        ,.DWIDTH              (14)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_ll_schlst_hp_bin3 (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_ll_schlst_hp_bin3_re)
        ,.func_mem_raddr      (func_ll_schlst_hp_bin3_raddr)
        ,.func_mem_waddr      (func_ll_schlst_hp_bin3_waddr)
        ,.func_mem_we         (func_ll_schlst_hp_bin3_we)
        ,.func_mem_wdata      (func_ll_schlst_hp_bin3_wdata)
        ,.func_mem_rdata      (func_ll_schlst_hp_bin3_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_ll_schlst_hp_bin3_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_ll_schlst_hp_bin3_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_ll_schlst_hp_bin3_re)
        ,.pf_mem_raddr        (pf_ll_schlst_hp_bin3_raddr)
        ,.pf_mem_waddr        (pf_ll_schlst_hp_bin3_waddr)
        ,.pf_mem_we           (pf_ll_schlst_hp_bin3_we)
        ,.pf_mem_wdata        (pf_ll_schlst_hp_bin3_wdata)
        ,.pf_mem_rdata        (pf_ll_schlst_hp_bin3_rdata)

        ,.mem_wclk            (rf_ll_schlst_hp_bin3_wclk)
        ,.mem_rclk            (rf_ll_schlst_hp_bin3_rclk)
        ,.mem_wclk_rst_n      (rf_ll_schlst_hp_bin3_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_ll_schlst_hp_bin3_rclk_rst_n)
        ,.mem_re              (rf_ll_schlst_hp_bin3_re)
        ,.mem_raddr           (rf_ll_schlst_hp_bin3_raddr)
        ,.mem_waddr           (rf_ll_schlst_hp_bin3_waddr)
        ,.mem_we              (rf_ll_schlst_hp_bin3_we)
        ,.mem_wdata           (rf_ll_schlst_hp_bin3_wdata)
        ,.mem_rdata           (rf_ll_schlst_hp_bin3_rdata)

        ,.mem_rdata_error     (rf_ll_schlst_hp_bin3_rdata_error)
        ,.error               (rf_ll_schlst_hp_bin3_error)
);

logic [(       1)-1:0] rf_ll_schlst_hpnxt_bin0_raddr_nc ;
logic [(       1)-1:0] rf_ll_schlst_hpnxt_bin0_waddr_nc ;

logic        rf_ll_schlst_hpnxt_bin0_rdata_error;

logic        cfg_mem_ack_ll_schlst_hpnxt_bin0_nc;
logic [31:0] cfg_mem_rdata_ll_schlst_hpnxt_bin0_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (14)
        ,.AWIDTHPAD           (1)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (2)
) i_ll_schlst_hpnxt_bin0 (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_ll_schlst_hpnxt_bin0_re)
        ,.func_mem_raddr      (func_ll_schlst_hpnxt_bin0_raddr)
        ,.func_mem_waddr      (func_ll_schlst_hpnxt_bin0_waddr)
        ,.func_mem_we         (func_ll_schlst_hpnxt_bin0_we)
        ,.func_mem_wdata      (func_ll_schlst_hpnxt_bin0_wdata)
        ,.func_mem_rdata      (func_ll_schlst_hpnxt_bin0_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_ll_schlst_hpnxt_bin0_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_ll_schlst_hpnxt_bin0_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_ll_schlst_hpnxt_bin0_re)
        ,.pf_mem_raddr        (pf_ll_schlst_hpnxt_bin0_raddr)
        ,.pf_mem_waddr        (pf_ll_schlst_hpnxt_bin0_waddr)
        ,.pf_mem_we           (pf_ll_schlst_hpnxt_bin0_we)
        ,.pf_mem_wdata        (pf_ll_schlst_hpnxt_bin0_wdata)
        ,.pf_mem_rdata        (pf_ll_schlst_hpnxt_bin0_rdata)

        ,.mem_wclk            (rf_ll_schlst_hpnxt_bin0_wclk)
        ,.mem_rclk            (rf_ll_schlst_hpnxt_bin0_rclk)
        ,.mem_wclk_rst_n      (rf_ll_schlst_hpnxt_bin0_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_ll_schlst_hpnxt_bin0_rclk_rst_n)
        ,.mem_re              (rf_ll_schlst_hpnxt_bin0_re)
        ,.mem_raddr           ({rf_ll_schlst_hpnxt_bin0_raddr_nc , rf_ll_schlst_hpnxt_bin0_raddr})
        ,.mem_waddr           ({rf_ll_schlst_hpnxt_bin0_waddr_nc , rf_ll_schlst_hpnxt_bin0_waddr})
        ,.mem_we              (rf_ll_schlst_hpnxt_bin0_we)
        ,.mem_wdata           (rf_ll_schlst_hpnxt_bin0_wdata)
        ,.mem_rdata           (rf_ll_schlst_hpnxt_bin0_rdata)

        ,.mem_rdata_error     (rf_ll_schlst_hpnxt_bin0_rdata_error)
        ,.error               (rf_ll_schlst_hpnxt_bin0_error)
);

logic [(       1)-1:0] rf_ll_schlst_hpnxt_bin1_raddr_nc ;
logic [(       1)-1:0] rf_ll_schlst_hpnxt_bin1_waddr_nc ;

logic        rf_ll_schlst_hpnxt_bin1_rdata_error;

logic        cfg_mem_ack_ll_schlst_hpnxt_bin1_nc;
logic [31:0] cfg_mem_rdata_ll_schlst_hpnxt_bin1_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (14)
        ,.AWIDTHPAD           (1)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (2)
) i_ll_schlst_hpnxt_bin1 (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_ll_schlst_hpnxt_bin1_re)
        ,.func_mem_raddr      (func_ll_schlst_hpnxt_bin1_raddr)
        ,.func_mem_waddr      (func_ll_schlst_hpnxt_bin1_waddr)
        ,.func_mem_we         (func_ll_schlst_hpnxt_bin1_we)
        ,.func_mem_wdata      (func_ll_schlst_hpnxt_bin1_wdata)
        ,.func_mem_rdata      (func_ll_schlst_hpnxt_bin1_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_ll_schlst_hpnxt_bin1_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_ll_schlst_hpnxt_bin1_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_ll_schlst_hpnxt_bin1_re)
        ,.pf_mem_raddr        (pf_ll_schlst_hpnxt_bin1_raddr)
        ,.pf_mem_waddr        (pf_ll_schlst_hpnxt_bin1_waddr)
        ,.pf_mem_we           (pf_ll_schlst_hpnxt_bin1_we)
        ,.pf_mem_wdata        (pf_ll_schlst_hpnxt_bin1_wdata)
        ,.pf_mem_rdata        (pf_ll_schlst_hpnxt_bin1_rdata)

        ,.mem_wclk            (rf_ll_schlst_hpnxt_bin1_wclk)
        ,.mem_rclk            (rf_ll_schlst_hpnxt_bin1_rclk)
        ,.mem_wclk_rst_n      (rf_ll_schlst_hpnxt_bin1_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_ll_schlst_hpnxt_bin1_rclk_rst_n)
        ,.mem_re              (rf_ll_schlst_hpnxt_bin1_re)
        ,.mem_raddr           ({rf_ll_schlst_hpnxt_bin1_raddr_nc , rf_ll_schlst_hpnxt_bin1_raddr})
        ,.mem_waddr           ({rf_ll_schlst_hpnxt_bin1_waddr_nc , rf_ll_schlst_hpnxt_bin1_waddr})
        ,.mem_we              (rf_ll_schlst_hpnxt_bin1_we)
        ,.mem_wdata           (rf_ll_schlst_hpnxt_bin1_wdata)
        ,.mem_rdata           (rf_ll_schlst_hpnxt_bin1_rdata)

        ,.mem_rdata_error     (rf_ll_schlst_hpnxt_bin1_rdata_error)
        ,.error               (rf_ll_schlst_hpnxt_bin1_error)
);

logic [(       1)-1:0] rf_ll_schlst_hpnxt_bin2_raddr_nc ;
logic [(       1)-1:0] rf_ll_schlst_hpnxt_bin2_waddr_nc ;

logic        rf_ll_schlst_hpnxt_bin2_rdata_error;

logic        cfg_mem_ack_ll_schlst_hpnxt_bin2_nc;
logic [31:0] cfg_mem_rdata_ll_schlst_hpnxt_bin2_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (14)
        ,.AWIDTHPAD           (1)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (2)
) i_ll_schlst_hpnxt_bin2 (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_ll_schlst_hpnxt_bin2_re)
        ,.func_mem_raddr      (func_ll_schlst_hpnxt_bin2_raddr)
        ,.func_mem_waddr      (func_ll_schlst_hpnxt_bin2_waddr)
        ,.func_mem_we         (func_ll_schlst_hpnxt_bin2_we)
        ,.func_mem_wdata      (func_ll_schlst_hpnxt_bin2_wdata)
        ,.func_mem_rdata      (func_ll_schlst_hpnxt_bin2_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_ll_schlst_hpnxt_bin2_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_ll_schlst_hpnxt_bin2_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_ll_schlst_hpnxt_bin2_re)
        ,.pf_mem_raddr        (pf_ll_schlst_hpnxt_bin2_raddr)
        ,.pf_mem_waddr        (pf_ll_schlst_hpnxt_bin2_waddr)
        ,.pf_mem_we           (pf_ll_schlst_hpnxt_bin2_we)
        ,.pf_mem_wdata        (pf_ll_schlst_hpnxt_bin2_wdata)
        ,.pf_mem_rdata        (pf_ll_schlst_hpnxt_bin2_rdata)

        ,.mem_wclk            (rf_ll_schlst_hpnxt_bin2_wclk)
        ,.mem_rclk            (rf_ll_schlst_hpnxt_bin2_rclk)
        ,.mem_wclk_rst_n      (rf_ll_schlst_hpnxt_bin2_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_ll_schlst_hpnxt_bin2_rclk_rst_n)
        ,.mem_re              (rf_ll_schlst_hpnxt_bin2_re)
        ,.mem_raddr           ({rf_ll_schlst_hpnxt_bin2_raddr_nc , rf_ll_schlst_hpnxt_bin2_raddr})
        ,.mem_waddr           ({rf_ll_schlst_hpnxt_bin2_waddr_nc , rf_ll_schlst_hpnxt_bin2_waddr})
        ,.mem_we              (rf_ll_schlst_hpnxt_bin2_we)
        ,.mem_wdata           (rf_ll_schlst_hpnxt_bin2_wdata)
        ,.mem_rdata           (rf_ll_schlst_hpnxt_bin2_rdata)

        ,.mem_rdata_error     (rf_ll_schlst_hpnxt_bin2_rdata_error)
        ,.error               (rf_ll_schlst_hpnxt_bin2_error)
);

logic [(       1)-1:0] rf_ll_schlst_hpnxt_bin3_raddr_nc ;
logic [(       1)-1:0] rf_ll_schlst_hpnxt_bin3_waddr_nc ;

logic        rf_ll_schlst_hpnxt_bin3_rdata_error;

logic        cfg_mem_ack_ll_schlst_hpnxt_bin3_nc;
logic [31:0] cfg_mem_rdata_ll_schlst_hpnxt_bin3_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (14)
        ,.AWIDTHPAD           (1)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (2)
) i_ll_schlst_hpnxt_bin3 (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_ll_schlst_hpnxt_bin3_re)
        ,.func_mem_raddr      (func_ll_schlst_hpnxt_bin3_raddr)
        ,.func_mem_waddr      (func_ll_schlst_hpnxt_bin3_waddr)
        ,.func_mem_we         (func_ll_schlst_hpnxt_bin3_we)
        ,.func_mem_wdata      (func_ll_schlst_hpnxt_bin3_wdata)
        ,.func_mem_rdata      (func_ll_schlst_hpnxt_bin3_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_ll_schlst_hpnxt_bin3_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_ll_schlst_hpnxt_bin3_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_ll_schlst_hpnxt_bin3_re)
        ,.pf_mem_raddr        (pf_ll_schlst_hpnxt_bin3_raddr)
        ,.pf_mem_waddr        (pf_ll_schlst_hpnxt_bin3_waddr)
        ,.pf_mem_we           (pf_ll_schlst_hpnxt_bin3_we)
        ,.pf_mem_wdata        (pf_ll_schlst_hpnxt_bin3_wdata)
        ,.pf_mem_rdata        (pf_ll_schlst_hpnxt_bin3_rdata)

        ,.mem_wclk            (rf_ll_schlst_hpnxt_bin3_wclk)
        ,.mem_rclk            (rf_ll_schlst_hpnxt_bin3_rclk)
        ,.mem_wclk_rst_n      (rf_ll_schlst_hpnxt_bin3_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_ll_schlst_hpnxt_bin3_rclk_rst_n)
        ,.mem_re              (rf_ll_schlst_hpnxt_bin3_re)
        ,.mem_raddr           ({rf_ll_schlst_hpnxt_bin3_raddr_nc , rf_ll_schlst_hpnxt_bin3_raddr})
        ,.mem_waddr           ({rf_ll_schlst_hpnxt_bin3_waddr_nc , rf_ll_schlst_hpnxt_bin3_waddr})
        ,.mem_we              (rf_ll_schlst_hpnxt_bin3_we)
        ,.mem_wdata           (rf_ll_schlst_hpnxt_bin3_wdata)
        ,.mem_rdata           (rf_ll_schlst_hpnxt_bin3_rdata)

        ,.mem_rdata_error     (rf_ll_schlst_hpnxt_bin3_rdata_error)
        ,.error               (rf_ll_schlst_hpnxt_bin3_error)
);

logic        rf_ll_schlst_tp_bin0_rdata_error;

logic        cfg_mem_ack_ll_schlst_tp_bin0_nc;
logic [31:0] cfg_mem_rdata_ll_schlst_tp_bin0_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (512)
        ,.DWIDTH              (14)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_ll_schlst_tp_bin0 (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_ll_schlst_tp_bin0_re)
        ,.func_mem_raddr      (func_ll_schlst_tp_bin0_raddr)
        ,.func_mem_waddr      (func_ll_schlst_tp_bin0_waddr)
        ,.func_mem_we         (func_ll_schlst_tp_bin0_we)
        ,.func_mem_wdata      (func_ll_schlst_tp_bin0_wdata)
        ,.func_mem_rdata      (func_ll_schlst_tp_bin0_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_ll_schlst_tp_bin0_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_ll_schlst_tp_bin0_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_ll_schlst_tp_bin0_re)
        ,.pf_mem_raddr        (pf_ll_schlst_tp_bin0_raddr)
        ,.pf_mem_waddr        (pf_ll_schlst_tp_bin0_waddr)
        ,.pf_mem_we           (pf_ll_schlst_tp_bin0_we)
        ,.pf_mem_wdata        (pf_ll_schlst_tp_bin0_wdata)
        ,.pf_mem_rdata        (pf_ll_schlst_tp_bin0_rdata)

        ,.mem_wclk            (rf_ll_schlst_tp_bin0_wclk)
        ,.mem_rclk            (rf_ll_schlst_tp_bin0_rclk)
        ,.mem_wclk_rst_n      (rf_ll_schlst_tp_bin0_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_ll_schlst_tp_bin0_rclk_rst_n)
        ,.mem_re              (rf_ll_schlst_tp_bin0_re)
        ,.mem_raddr           (rf_ll_schlst_tp_bin0_raddr)
        ,.mem_waddr           (rf_ll_schlst_tp_bin0_waddr)
        ,.mem_we              (rf_ll_schlst_tp_bin0_we)
        ,.mem_wdata           (rf_ll_schlst_tp_bin0_wdata)
        ,.mem_rdata           (rf_ll_schlst_tp_bin0_rdata)

        ,.mem_rdata_error     (rf_ll_schlst_tp_bin0_rdata_error)
        ,.error               (rf_ll_schlst_tp_bin0_error)
);

logic        rf_ll_schlst_tp_bin1_rdata_error;

logic        cfg_mem_ack_ll_schlst_tp_bin1_nc;
logic [31:0] cfg_mem_rdata_ll_schlst_tp_bin1_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (512)
        ,.DWIDTH              (14)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_ll_schlst_tp_bin1 (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_ll_schlst_tp_bin1_re)
        ,.func_mem_raddr      (func_ll_schlst_tp_bin1_raddr)
        ,.func_mem_waddr      (func_ll_schlst_tp_bin1_waddr)
        ,.func_mem_we         (func_ll_schlst_tp_bin1_we)
        ,.func_mem_wdata      (func_ll_schlst_tp_bin1_wdata)
        ,.func_mem_rdata      (func_ll_schlst_tp_bin1_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_ll_schlst_tp_bin1_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_ll_schlst_tp_bin1_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_ll_schlst_tp_bin1_re)
        ,.pf_mem_raddr        (pf_ll_schlst_tp_bin1_raddr)
        ,.pf_mem_waddr        (pf_ll_schlst_tp_bin1_waddr)
        ,.pf_mem_we           (pf_ll_schlst_tp_bin1_we)
        ,.pf_mem_wdata        (pf_ll_schlst_tp_bin1_wdata)
        ,.pf_mem_rdata        (pf_ll_schlst_tp_bin1_rdata)

        ,.mem_wclk            (rf_ll_schlst_tp_bin1_wclk)
        ,.mem_rclk            (rf_ll_schlst_tp_bin1_rclk)
        ,.mem_wclk_rst_n      (rf_ll_schlst_tp_bin1_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_ll_schlst_tp_bin1_rclk_rst_n)
        ,.mem_re              (rf_ll_schlst_tp_bin1_re)
        ,.mem_raddr           (rf_ll_schlst_tp_bin1_raddr)
        ,.mem_waddr           (rf_ll_schlst_tp_bin1_waddr)
        ,.mem_we              (rf_ll_schlst_tp_bin1_we)
        ,.mem_wdata           (rf_ll_schlst_tp_bin1_wdata)
        ,.mem_rdata           (rf_ll_schlst_tp_bin1_rdata)

        ,.mem_rdata_error     (rf_ll_schlst_tp_bin1_rdata_error)
        ,.error               (rf_ll_schlst_tp_bin1_error)
);

logic        rf_ll_schlst_tp_bin2_rdata_error;

logic        cfg_mem_ack_ll_schlst_tp_bin2_nc;
logic [31:0] cfg_mem_rdata_ll_schlst_tp_bin2_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (512)
        ,.DWIDTH              (14)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_ll_schlst_tp_bin2 (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_ll_schlst_tp_bin2_re)
        ,.func_mem_raddr      (func_ll_schlst_tp_bin2_raddr)
        ,.func_mem_waddr      (func_ll_schlst_tp_bin2_waddr)
        ,.func_mem_we         (func_ll_schlst_tp_bin2_we)
        ,.func_mem_wdata      (func_ll_schlst_tp_bin2_wdata)
        ,.func_mem_rdata      (func_ll_schlst_tp_bin2_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_ll_schlst_tp_bin2_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_ll_schlst_tp_bin2_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_ll_schlst_tp_bin2_re)
        ,.pf_mem_raddr        (pf_ll_schlst_tp_bin2_raddr)
        ,.pf_mem_waddr        (pf_ll_schlst_tp_bin2_waddr)
        ,.pf_mem_we           (pf_ll_schlst_tp_bin2_we)
        ,.pf_mem_wdata        (pf_ll_schlst_tp_bin2_wdata)
        ,.pf_mem_rdata        (pf_ll_schlst_tp_bin2_rdata)

        ,.mem_wclk            (rf_ll_schlst_tp_bin2_wclk)
        ,.mem_rclk            (rf_ll_schlst_tp_bin2_rclk)
        ,.mem_wclk_rst_n      (rf_ll_schlst_tp_bin2_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_ll_schlst_tp_bin2_rclk_rst_n)
        ,.mem_re              (rf_ll_schlst_tp_bin2_re)
        ,.mem_raddr           (rf_ll_schlst_tp_bin2_raddr)
        ,.mem_waddr           (rf_ll_schlst_tp_bin2_waddr)
        ,.mem_we              (rf_ll_schlst_tp_bin2_we)
        ,.mem_wdata           (rf_ll_schlst_tp_bin2_wdata)
        ,.mem_rdata           (rf_ll_schlst_tp_bin2_rdata)

        ,.mem_rdata_error     (rf_ll_schlst_tp_bin2_rdata_error)
        ,.error               (rf_ll_schlst_tp_bin2_error)
);

logic        rf_ll_schlst_tp_bin3_rdata_error;

logic        cfg_mem_ack_ll_schlst_tp_bin3_nc;
logic [31:0] cfg_mem_rdata_ll_schlst_tp_bin3_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (512)
        ,.DWIDTH              (14)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_ll_schlst_tp_bin3 (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_ll_schlst_tp_bin3_re)
        ,.func_mem_raddr      (func_ll_schlst_tp_bin3_raddr)
        ,.func_mem_waddr      (func_ll_schlst_tp_bin3_waddr)
        ,.func_mem_we         (func_ll_schlst_tp_bin3_we)
        ,.func_mem_wdata      (func_ll_schlst_tp_bin3_wdata)
        ,.func_mem_rdata      (func_ll_schlst_tp_bin3_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_ll_schlst_tp_bin3_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_ll_schlst_tp_bin3_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_ll_schlst_tp_bin3_re)
        ,.pf_mem_raddr        (pf_ll_schlst_tp_bin3_raddr)
        ,.pf_mem_waddr        (pf_ll_schlst_tp_bin3_waddr)
        ,.pf_mem_we           (pf_ll_schlst_tp_bin3_we)
        ,.pf_mem_wdata        (pf_ll_schlst_tp_bin3_wdata)
        ,.pf_mem_rdata        (pf_ll_schlst_tp_bin3_rdata)

        ,.mem_wclk            (rf_ll_schlst_tp_bin3_wclk)
        ,.mem_rclk            (rf_ll_schlst_tp_bin3_rclk)
        ,.mem_wclk_rst_n      (rf_ll_schlst_tp_bin3_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_ll_schlst_tp_bin3_rclk_rst_n)
        ,.mem_re              (rf_ll_schlst_tp_bin3_re)
        ,.mem_raddr           (rf_ll_schlst_tp_bin3_raddr)
        ,.mem_waddr           (rf_ll_schlst_tp_bin3_waddr)
        ,.mem_we              (rf_ll_schlst_tp_bin3_we)
        ,.mem_wdata           (rf_ll_schlst_tp_bin3_wdata)
        ,.mem_rdata           (rf_ll_schlst_tp_bin3_rdata)

        ,.mem_rdata_error     (rf_ll_schlst_tp_bin3_rdata_error)
        ,.error               (rf_ll_schlst_tp_bin3_error)
);

logic [(       1)-1:0] rf_ll_schlst_tpprv_bin0_raddr_nc ;
logic [(       1)-1:0] rf_ll_schlst_tpprv_bin0_waddr_nc ;

logic        rf_ll_schlst_tpprv_bin0_rdata_error;

logic        cfg_mem_ack_ll_schlst_tpprv_bin0_nc;
logic [31:0] cfg_mem_rdata_ll_schlst_tpprv_bin0_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (14)
        ,.AWIDTHPAD           (1)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (2)
) i_ll_schlst_tpprv_bin0 (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_ll_schlst_tpprv_bin0_re)
        ,.func_mem_raddr      (func_ll_schlst_tpprv_bin0_raddr)
        ,.func_mem_waddr      (func_ll_schlst_tpprv_bin0_waddr)
        ,.func_mem_we         (func_ll_schlst_tpprv_bin0_we)
        ,.func_mem_wdata      (func_ll_schlst_tpprv_bin0_wdata)
        ,.func_mem_rdata      (func_ll_schlst_tpprv_bin0_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_ll_schlst_tpprv_bin0_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_ll_schlst_tpprv_bin0_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_ll_schlst_tpprv_bin0_re)
        ,.pf_mem_raddr        (pf_ll_schlst_tpprv_bin0_raddr)
        ,.pf_mem_waddr        (pf_ll_schlst_tpprv_bin0_waddr)
        ,.pf_mem_we           (pf_ll_schlst_tpprv_bin0_we)
        ,.pf_mem_wdata        (pf_ll_schlst_tpprv_bin0_wdata)
        ,.pf_mem_rdata        (pf_ll_schlst_tpprv_bin0_rdata)

        ,.mem_wclk            (rf_ll_schlst_tpprv_bin0_wclk)
        ,.mem_rclk            (rf_ll_schlst_tpprv_bin0_rclk)
        ,.mem_wclk_rst_n      (rf_ll_schlst_tpprv_bin0_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_ll_schlst_tpprv_bin0_rclk_rst_n)
        ,.mem_re              (rf_ll_schlst_tpprv_bin0_re)
        ,.mem_raddr           ({rf_ll_schlst_tpprv_bin0_raddr_nc , rf_ll_schlst_tpprv_bin0_raddr})
        ,.mem_waddr           ({rf_ll_schlst_tpprv_bin0_waddr_nc , rf_ll_schlst_tpprv_bin0_waddr})
        ,.mem_we              (rf_ll_schlst_tpprv_bin0_we)
        ,.mem_wdata           (rf_ll_schlst_tpprv_bin0_wdata)
        ,.mem_rdata           (rf_ll_schlst_tpprv_bin0_rdata)

        ,.mem_rdata_error     (rf_ll_schlst_tpprv_bin0_rdata_error)
        ,.error               (rf_ll_schlst_tpprv_bin0_error)
);

logic [(       1)-1:0] rf_ll_schlst_tpprv_bin1_raddr_nc ;
logic [(       1)-1:0] rf_ll_schlst_tpprv_bin1_waddr_nc ;

logic        rf_ll_schlst_tpprv_bin1_rdata_error;

logic        cfg_mem_ack_ll_schlst_tpprv_bin1_nc;
logic [31:0] cfg_mem_rdata_ll_schlst_tpprv_bin1_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (14)
        ,.AWIDTHPAD           (1)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (2)
) i_ll_schlst_tpprv_bin1 (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_ll_schlst_tpprv_bin1_re)
        ,.func_mem_raddr      (func_ll_schlst_tpprv_bin1_raddr)
        ,.func_mem_waddr      (func_ll_schlst_tpprv_bin1_waddr)
        ,.func_mem_we         (func_ll_schlst_tpprv_bin1_we)
        ,.func_mem_wdata      (func_ll_schlst_tpprv_bin1_wdata)
        ,.func_mem_rdata      (func_ll_schlst_tpprv_bin1_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_ll_schlst_tpprv_bin1_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_ll_schlst_tpprv_bin1_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_ll_schlst_tpprv_bin1_re)
        ,.pf_mem_raddr        (pf_ll_schlst_tpprv_bin1_raddr)
        ,.pf_mem_waddr        (pf_ll_schlst_tpprv_bin1_waddr)
        ,.pf_mem_we           (pf_ll_schlst_tpprv_bin1_we)
        ,.pf_mem_wdata        (pf_ll_schlst_tpprv_bin1_wdata)
        ,.pf_mem_rdata        (pf_ll_schlst_tpprv_bin1_rdata)

        ,.mem_wclk            (rf_ll_schlst_tpprv_bin1_wclk)
        ,.mem_rclk            (rf_ll_schlst_tpprv_bin1_rclk)
        ,.mem_wclk_rst_n      (rf_ll_schlst_tpprv_bin1_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_ll_schlst_tpprv_bin1_rclk_rst_n)
        ,.mem_re              (rf_ll_schlst_tpprv_bin1_re)
        ,.mem_raddr           ({rf_ll_schlst_tpprv_bin1_raddr_nc , rf_ll_schlst_tpprv_bin1_raddr})
        ,.mem_waddr           ({rf_ll_schlst_tpprv_bin1_waddr_nc , rf_ll_schlst_tpprv_bin1_waddr})
        ,.mem_we              (rf_ll_schlst_tpprv_bin1_we)
        ,.mem_wdata           (rf_ll_schlst_tpprv_bin1_wdata)
        ,.mem_rdata           (rf_ll_schlst_tpprv_bin1_rdata)

        ,.mem_rdata_error     (rf_ll_schlst_tpprv_bin1_rdata_error)
        ,.error               (rf_ll_schlst_tpprv_bin1_error)
);

logic [(       1)-1:0] rf_ll_schlst_tpprv_bin2_raddr_nc ;
logic [(       1)-1:0] rf_ll_schlst_tpprv_bin2_waddr_nc ;

logic        rf_ll_schlst_tpprv_bin2_rdata_error;

logic        cfg_mem_ack_ll_schlst_tpprv_bin2_nc;
logic [31:0] cfg_mem_rdata_ll_schlst_tpprv_bin2_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (14)
        ,.AWIDTHPAD           (1)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (2)
) i_ll_schlst_tpprv_bin2 (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_ll_schlst_tpprv_bin2_re)
        ,.func_mem_raddr      (func_ll_schlst_tpprv_bin2_raddr)
        ,.func_mem_waddr      (func_ll_schlst_tpprv_bin2_waddr)
        ,.func_mem_we         (func_ll_schlst_tpprv_bin2_we)
        ,.func_mem_wdata      (func_ll_schlst_tpprv_bin2_wdata)
        ,.func_mem_rdata      (func_ll_schlst_tpprv_bin2_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_ll_schlst_tpprv_bin2_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_ll_schlst_tpprv_bin2_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_ll_schlst_tpprv_bin2_re)
        ,.pf_mem_raddr        (pf_ll_schlst_tpprv_bin2_raddr)
        ,.pf_mem_waddr        (pf_ll_schlst_tpprv_bin2_waddr)
        ,.pf_mem_we           (pf_ll_schlst_tpprv_bin2_we)
        ,.pf_mem_wdata        (pf_ll_schlst_tpprv_bin2_wdata)
        ,.pf_mem_rdata        (pf_ll_schlst_tpprv_bin2_rdata)

        ,.mem_wclk            (rf_ll_schlst_tpprv_bin2_wclk)
        ,.mem_rclk            (rf_ll_schlst_tpprv_bin2_rclk)
        ,.mem_wclk_rst_n      (rf_ll_schlst_tpprv_bin2_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_ll_schlst_tpprv_bin2_rclk_rst_n)
        ,.mem_re              (rf_ll_schlst_tpprv_bin2_re)
        ,.mem_raddr           ({rf_ll_schlst_tpprv_bin2_raddr_nc , rf_ll_schlst_tpprv_bin2_raddr})
        ,.mem_waddr           ({rf_ll_schlst_tpprv_bin2_waddr_nc , rf_ll_schlst_tpprv_bin2_waddr})
        ,.mem_we              (rf_ll_schlst_tpprv_bin2_we)
        ,.mem_wdata           (rf_ll_schlst_tpprv_bin2_wdata)
        ,.mem_rdata           (rf_ll_schlst_tpprv_bin2_rdata)

        ,.mem_rdata_error     (rf_ll_schlst_tpprv_bin2_rdata_error)
        ,.error               (rf_ll_schlst_tpprv_bin2_error)
);

logic [(       1)-1:0] rf_ll_schlst_tpprv_bin3_raddr_nc ;
logic [(       1)-1:0] rf_ll_schlst_tpprv_bin3_waddr_nc ;

logic        rf_ll_schlst_tpprv_bin3_rdata_error;

logic        cfg_mem_ack_ll_schlst_tpprv_bin3_nc;
logic [31:0] cfg_mem_rdata_ll_schlst_tpprv_bin3_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (14)
        ,.AWIDTHPAD           (1)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (2)
) i_ll_schlst_tpprv_bin3 (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_ll_schlst_tpprv_bin3_re)
        ,.func_mem_raddr      (func_ll_schlst_tpprv_bin3_raddr)
        ,.func_mem_waddr      (func_ll_schlst_tpprv_bin3_waddr)
        ,.func_mem_we         (func_ll_schlst_tpprv_bin3_we)
        ,.func_mem_wdata      (func_ll_schlst_tpprv_bin3_wdata)
        ,.func_mem_rdata      (func_ll_schlst_tpprv_bin3_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_ll_schlst_tpprv_bin3_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_ll_schlst_tpprv_bin3_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_ll_schlst_tpprv_bin3_re)
        ,.pf_mem_raddr        (pf_ll_schlst_tpprv_bin3_raddr)
        ,.pf_mem_waddr        (pf_ll_schlst_tpprv_bin3_waddr)
        ,.pf_mem_we           (pf_ll_schlst_tpprv_bin3_we)
        ,.pf_mem_wdata        (pf_ll_schlst_tpprv_bin3_wdata)
        ,.pf_mem_rdata        (pf_ll_schlst_tpprv_bin3_rdata)

        ,.mem_wclk            (rf_ll_schlst_tpprv_bin3_wclk)
        ,.mem_rclk            (rf_ll_schlst_tpprv_bin3_rclk)
        ,.mem_wclk_rst_n      (rf_ll_schlst_tpprv_bin3_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_ll_schlst_tpprv_bin3_rclk_rst_n)
        ,.mem_re              (rf_ll_schlst_tpprv_bin3_re)
        ,.mem_raddr           ({rf_ll_schlst_tpprv_bin3_raddr_nc , rf_ll_schlst_tpprv_bin3_raddr})
        ,.mem_waddr           ({rf_ll_schlst_tpprv_bin3_waddr_nc , rf_ll_schlst_tpprv_bin3_waddr})
        ,.mem_we              (rf_ll_schlst_tpprv_bin3_we)
        ,.mem_wdata           (rf_ll_schlst_tpprv_bin3_wdata)
        ,.mem_rdata           (rf_ll_schlst_tpprv_bin3_rdata)

        ,.mem_rdata_error     (rf_ll_schlst_tpprv_bin3_rdata_error)
        ,.error               (rf_ll_schlst_tpprv_bin3_error)
);

logic        rf_ll_slst_cnt_rdata_error;

logic        cfg_mem_ack_ll_slst_cnt_nc;
logic [31:0] cfg_mem_rdata_ll_slst_cnt_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (512)
        ,.DWIDTH              (56)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (4)
) i_ll_slst_cnt (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_ll_slst_cnt_re)
        ,.func_mem_raddr      (func_ll_slst_cnt_raddr)
        ,.func_mem_waddr      (func_ll_slst_cnt_waddr)
        ,.func_mem_we         (func_ll_slst_cnt_we)
        ,.func_mem_wdata      (func_ll_slst_cnt_wdata)
        ,.func_mem_rdata      (func_ll_slst_cnt_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_ll_slst_cnt_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_ll_slst_cnt_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_ll_slst_cnt_re)
        ,.pf_mem_raddr        (pf_ll_slst_cnt_raddr)
        ,.pf_mem_waddr        (pf_ll_slst_cnt_waddr)
        ,.pf_mem_we           (pf_ll_slst_cnt_we)
        ,.pf_mem_wdata        (pf_ll_slst_cnt_wdata)
        ,.pf_mem_rdata        (pf_ll_slst_cnt_rdata)

        ,.mem_wclk            (rf_ll_slst_cnt_wclk)
        ,.mem_rclk            (rf_ll_slst_cnt_rclk)
        ,.mem_wclk_rst_n      (rf_ll_slst_cnt_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_ll_slst_cnt_rclk_rst_n)
        ,.mem_re              (rf_ll_slst_cnt_re)
        ,.mem_raddr           (rf_ll_slst_cnt_raddr)
        ,.mem_waddr           (rf_ll_slst_cnt_waddr)
        ,.mem_we              (rf_ll_slst_cnt_we)
        ,.mem_wdata           (rf_ll_slst_cnt_wdata)
        ,.mem_rdata           (rf_ll_slst_cnt_rdata)

        ,.mem_rdata_error     (rf_ll_slst_cnt_rdata_error)
        ,.error               (rf_ll_slst_cnt_error)
);

logic [(       2)-1:0] rf_qid_rdylst_clamp_raddr_nc ;
logic [(       2)-1:0] rf_qid_rdylst_clamp_waddr_nc ;

logic        rf_qid_rdylst_clamp_rdata_error;

hqm_AW_rfw_access #( 
         .DEPTH               (32)
        ,.DWIDTH              (6)
        ,.AWIDTHPAD           (2)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_qid_rdylst_clamp (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_qid_rdylst_clamp_re)
        ,.func_mem_raddr      (func_qid_rdylst_clamp_raddr)
        ,.func_mem_waddr      (func_qid_rdylst_clamp_waddr)
        ,.func_mem_we         (func_qid_rdylst_clamp_we)
        ,.func_mem_wdata      (func_qid_rdylst_clamp_wdata)
        ,.func_mem_rdata      (func_qid_rdylst_clamp_rdata)

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

        ,.pf_mem_re           (pf_qid_rdylst_clamp_re)
        ,.pf_mem_raddr        (pf_qid_rdylst_clamp_raddr)
        ,.pf_mem_waddr        (pf_qid_rdylst_clamp_waddr)
        ,.pf_mem_we           (pf_qid_rdylst_clamp_we)
        ,.pf_mem_wdata        (pf_qid_rdylst_clamp_wdata)
        ,.pf_mem_rdata        (pf_qid_rdylst_clamp_rdata)

        ,.mem_wclk            (rf_qid_rdylst_clamp_wclk)
        ,.mem_rclk            (rf_qid_rdylst_clamp_rclk)
        ,.mem_wclk_rst_n      (rf_qid_rdylst_clamp_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_qid_rdylst_clamp_rclk_rst_n)
        ,.mem_re              (rf_qid_rdylst_clamp_re)
        ,.mem_raddr           ({rf_qid_rdylst_clamp_raddr_nc , rf_qid_rdylst_clamp_raddr})
        ,.mem_waddr           ({rf_qid_rdylst_clamp_waddr_nc , rf_qid_rdylst_clamp_waddr})
        ,.mem_we              (rf_qid_rdylst_clamp_we)
        ,.mem_wdata           (rf_qid_rdylst_clamp_wdata)
        ,.mem_rdata           (rf_qid_rdylst_clamp_rdata)

        ,.mem_rdata_error     (rf_qid_rdylst_clamp_rdata_error)
        ,.error               (rf_qid_rdylst_clamp_error)
);

assign hqm_lsp_atm_pipe_rfw_top_ipar_error = rf_aqed_qid2cqidix_rdata_error | rf_atm_fifo_ap_aqed_rdata_error | rf_atm_fifo_aqed_ap_enq_rdata_error | rf_fid2cqqidix_rdata_error | rf_ll_enq_cnt_r_bin0_dup0_rdata_error | rf_ll_enq_cnt_r_bin0_dup1_rdata_error | rf_ll_enq_cnt_r_bin0_dup2_rdata_error | rf_ll_enq_cnt_r_bin0_dup3_rdata_error | rf_ll_enq_cnt_r_bin1_dup0_rdata_error | rf_ll_enq_cnt_r_bin1_dup1_rdata_error | rf_ll_enq_cnt_r_bin1_dup2_rdata_error | rf_ll_enq_cnt_r_bin1_dup3_rdata_error | rf_ll_enq_cnt_r_bin2_dup0_rdata_error | rf_ll_enq_cnt_r_bin2_dup1_rdata_error | rf_ll_enq_cnt_r_bin2_dup2_rdata_error | rf_ll_enq_cnt_r_bin2_dup3_rdata_error | rf_ll_enq_cnt_r_bin3_dup0_rdata_error | rf_ll_enq_cnt_r_bin3_dup1_rdata_error | rf_ll_enq_cnt_r_bin3_dup2_rdata_error | rf_ll_enq_cnt_r_bin3_dup3_rdata_error | rf_ll_enq_cnt_s_bin0_rdata_error | rf_ll_enq_cnt_s_bin1_rdata_error | rf_ll_enq_cnt_s_bin2_rdata_error | rf_ll_enq_cnt_s_bin3_rdata_error | rf_ll_rdylst_hp_bin0_rdata_error | rf_ll_rdylst_hp_bin1_rdata_error | rf_ll_rdylst_hp_bin2_rdata_error | rf_ll_rdylst_hp_bin3_rdata_error | rf_ll_rdylst_hpnxt_bin0_rdata_error | rf_ll_rdylst_hpnxt_bin1_rdata_error | rf_ll_rdylst_hpnxt_bin2_rdata_error | rf_ll_rdylst_hpnxt_bin3_rdata_error | rf_ll_rdylst_tp_bin0_rdata_error | rf_ll_rdylst_tp_bin1_rdata_error | rf_ll_rdylst_tp_bin2_rdata_error | rf_ll_rdylst_tp_bin3_rdata_error | rf_ll_rlst_cnt_rdata_error | rf_ll_sch_cnt_dup0_rdata_error | rf_ll_sch_cnt_dup1_rdata_error | rf_ll_sch_cnt_dup2_rdata_error | rf_ll_sch_cnt_dup3_rdata_error | rf_ll_schlst_hp_bin0_rdata_error | rf_ll_schlst_hp_bin1_rdata_error | rf_ll_schlst_hp_bin2_rdata_error | rf_ll_schlst_hp_bin3_rdata_error | rf_ll_schlst_hpnxt_bin0_rdata_error | rf_ll_schlst_hpnxt_bin1_rdata_error | rf_ll_schlst_hpnxt_bin2_rdata_error | rf_ll_schlst_hpnxt_bin3_rdata_error | rf_ll_schlst_tp_bin0_rdata_error | rf_ll_schlst_tp_bin1_rdata_error | rf_ll_schlst_tp_bin2_rdata_error | rf_ll_schlst_tp_bin3_rdata_error | rf_ll_schlst_tpprv_bin0_rdata_error | rf_ll_schlst_tpprv_bin1_rdata_error | rf_ll_schlst_tpprv_bin2_rdata_error | rf_ll_schlst_tpprv_bin3_rdata_error | rf_ll_slst_cnt_rdata_error | rf_qid_rdylst_clamp_rdata_error ;

endmodule

