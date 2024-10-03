module hqm_reorder_pipe_ram_access
     import hqm_AW_pkg::* , hqm_pkg::* , hqm_core_pkg::*;
(
     input  logic                  hqm_gated_clk

    ,input  logic                  hqm_gated_rst_n

    ,input  logic [(  8 *  1)-1:0] cfg_mem_re          // lintra s-0527
    ,input  logic [(  8 *  1)-1:0] cfg_mem_we          // lintra s-0527
    ,input  logic [(      20)-1:0] cfg_mem_addr        // lintra s-0527
    ,input  logic [(      12)-1:0] cfg_mem_minbit      // lintra s-0527
    ,input  logic [(      12)-1:0] cfg_mem_maxbit      // lintra s-0527
    ,input  logic [(      32)-1:0] cfg_mem_wdata       // lintra s-0527
    ,output logic [(  8 * 32)-1:0] cfg_mem_rdata
    ,output logic [(  8 *  1)-1:0] cfg_mem_ack
    ,input  logic                  cfg_mem_cc_v        // lintra s-0527
    ,input  logic [(       8)-1:0] cfg_mem_cc_value    // lintra s-0527
    ,input  logic [(       4)-1:0] cfg_mem_cc_width    // lintra s-0527
    ,input  logic [(      12)-1:0] cfg_mem_cc_position // lintra s-0527

    ,output logic                  hqm_reorder_pipe_rfw_top_ipar_error

    ,input  logic                  func_dir_rply_req_fifo_mem_re
    ,input  logic [(       3)-1:0] func_dir_rply_req_fifo_mem_raddr
    ,input  logic [(       3)-1:0] func_dir_rply_req_fifo_mem_waddr
    ,input  logic                  func_dir_rply_req_fifo_mem_we
    ,input  logic [(      60)-1:0] func_dir_rply_req_fifo_mem_wdata
    ,output logic [(      60)-1:0] func_dir_rply_req_fifo_mem_rdata

    ,input  logic                  pf_dir_rply_req_fifo_mem_re
    ,input  logic [(       3)-1:0] pf_dir_rply_req_fifo_mem_raddr
    ,input  logic [(       3)-1:0] pf_dir_rply_req_fifo_mem_waddr
    ,input  logic                  pf_dir_rply_req_fifo_mem_we
    ,input  logic [(      60)-1:0] pf_dir_rply_req_fifo_mem_wdata
    ,output logic [(      60)-1:0] pf_dir_rply_req_fifo_mem_rdata

    ,output logic                  rf_dir_rply_req_fifo_mem_re
    ,output logic                  rf_dir_rply_req_fifo_mem_rclk
    ,output logic                  rf_dir_rply_req_fifo_mem_rclk_rst_n
    ,output logic [(       3)-1:0] rf_dir_rply_req_fifo_mem_raddr
    ,output logic [(       3)-1:0] rf_dir_rply_req_fifo_mem_waddr
    ,output logic                  rf_dir_rply_req_fifo_mem_we
    ,output logic                  rf_dir_rply_req_fifo_mem_wclk
    ,output logic                  rf_dir_rply_req_fifo_mem_wclk_rst_n
    ,output logic [(      60)-1:0] rf_dir_rply_req_fifo_mem_wdata
    ,input  logic [(      60)-1:0] rf_dir_rply_req_fifo_mem_rdata

    ,output logic                  rf_dir_rply_req_fifo_mem_error

    ,input  logic                  func_ldb_rply_req_fifo_mem_re
    ,input  logic [(       3)-1:0] func_ldb_rply_req_fifo_mem_raddr
    ,input  logic [(       3)-1:0] func_ldb_rply_req_fifo_mem_waddr
    ,input  logic                  func_ldb_rply_req_fifo_mem_we
    ,input  logic [(      60)-1:0] func_ldb_rply_req_fifo_mem_wdata
    ,output logic [(      60)-1:0] func_ldb_rply_req_fifo_mem_rdata

    ,input  logic                  pf_ldb_rply_req_fifo_mem_re
    ,input  logic [(       3)-1:0] pf_ldb_rply_req_fifo_mem_raddr
    ,input  logic [(       3)-1:0] pf_ldb_rply_req_fifo_mem_waddr
    ,input  logic                  pf_ldb_rply_req_fifo_mem_we
    ,input  logic [(      60)-1:0] pf_ldb_rply_req_fifo_mem_wdata
    ,output logic [(      60)-1:0] pf_ldb_rply_req_fifo_mem_rdata

    ,output logic                  rf_ldb_rply_req_fifo_mem_re
    ,output logic                  rf_ldb_rply_req_fifo_mem_rclk
    ,output logic                  rf_ldb_rply_req_fifo_mem_rclk_rst_n
    ,output logic [(       3)-1:0] rf_ldb_rply_req_fifo_mem_raddr
    ,output logic [(       3)-1:0] rf_ldb_rply_req_fifo_mem_waddr
    ,output logic                  rf_ldb_rply_req_fifo_mem_we
    ,output logic                  rf_ldb_rply_req_fifo_mem_wclk
    ,output logic                  rf_ldb_rply_req_fifo_mem_wclk_rst_n
    ,output logic [(      60)-1:0] rf_ldb_rply_req_fifo_mem_wdata
    ,input  logic [(      60)-1:0] rf_ldb_rply_req_fifo_mem_rdata

    ,output logic                  rf_ldb_rply_req_fifo_mem_error

    ,input  logic                  func_lsp_reordercmp_fifo_mem_re
    ,input  logic [(       3)-1:0] func_lsp_reordercmp_fifo_mem_raddr
    ,input  logic [(       3)-1:0] func_lsp_reordercmp_fifo_mem_waddr
    ,input  logic                  func_lsp_reordercmp_fifo_mem_we
    ,input  logic [(      19)-1:0] func_lsp_reordercmp_fifo_mem_wdata
    ,output logic [(      19)-1:0] func_lsp_reordercmp_fifo_mem_rdata

    ,input  logic                  pf_lsp_reordercmp_fifo_mem_re
    ,input  logic [(       3)-1:0] pf_lsp_reordercmp_fifo_mem_raddr
    ,input  logic [(       3)-1:0] pf_lsp_reordercmp_fifo_mem_waddr
    ,input  logic                  pf_lsp_reordercmp_fifo_mem_we
    ,input  logic [(      19)-1:0] pf_lsp_reordercmp_fifo_mem_wdata
    ,output logic [(      19)-1:0] pf_lsp_reordercmp_fifo_mem_rdata

    ,output logic                  rf_lsp_reordercmp_fifo_mem_re
    ,output logic                  rf_lsp_reordercmp_fifo_mem_rclk
    ,output logic                  rf_lsp_reordercmp_fifo_mem_rclk_rst_n
    ,output logic [(       3)-1:0] rf_lsp_reordercmp_fifo_mem_raddr
    ,output logic [(       3)-1:0] rf_lsp_reordercmp_fifo_mem_waddr
    ,output logic                  rf_lsp_reordercmp_fifo_mem_we
    ,output logic                  rf_lsp_reordercmp_fifo_mem_wclk
    ,output logic                  rf_lsp_reordercmp_fifo_mem_wclk_rst_n
    ,output logic [(      19)-1:0] rf_lsp_reordercmp_fifo_mem_wdata
    ,input  logic [(      19)-1:0] rf_lsp_reordercmp_fifo_mem_rdata

    ,output logic                  rf_lsp_reordercmp_fifo_mem_error

    ,input  logic                  func_reord_cnt_mem_re
    ,input  logic [(      11)-1:0] func_reord_cnt_mem_raddr
    ,input  logic [(      11)-1:0] func_reord_cnt_mem_waddr
    ,input  logic                  func_reord_cnt_mem_we
    ,input  logic [(      14)-1:0] func_reord_cnt_mem_wdata
    ,output logic [(      14)-1:0] func_reord_cnt_mem_rdata

    ,input  logic                  pf_reord_cnt_mem_re
    ,input  logic [(      11)-1:0] pf_reord_cnt_mem_raddr
    ,input  logic [(      11)-1:0] pf_reord_cnt_mem_waddr
    ,input  logic                  pf_reord_cnt_mem_we
    ,input  logic [(      14)-1:0] pf_reord_cnt_mem_wdata
    ,output logic [(      14)-1:0] pf_reord_cnt_mem_rdata

    ,output logic                  rf_reord_cnt_mem_re
    ,output logic                  rf_reord_cnt_mem_rclk
    ,output logic                  rf_reord_cnt_mem_rclk_rst_n
    ,output logic [(      11)-1:0] rf_reord_cnt_mem_raddr
    ,output logic [(      11)-1:0] rf_reord_cnt_mem_waddr
    ,output logic                  rf_reord_cnt_mem_we
    ,output logic                  rf_reord_cnt_mem_wclk
    ,output logic                  rf_reord_cnt_mem_wclk_rst_n
    ,output logic [(      16)-1:0] rf_reord_cnt_mem_wdata
    ,input  logic [(      16)-1:0] rf_reord_cnt_mem_rdata

    ,output logic                  rf_reord_cnt_mem_error

    ,input  logic                  func_reord_dirhp_mem_re
    ,input  logic [(      11)-1:0] func_reord_dirhp_mem_raddr
    ,input  logic [(      11)-1:0] func_reord_dirhp_mem_waddr
    ,input  logic                  func_reord_dirhp_mem_we
    ,input  logic [(      15)-1:0] func_reord_dirhp_mem_wdata
    ,output logic [(      15)-1:0] func_reord_dirhp_mem_rdata

    ,input  logic                  pf_reord_dirhp_mem_re
    ,input  logic [(      11)-1:0] pf_reord_dirhp_mem_raddr
    ,input  logic [(      11)-1:0] pf_reord_dirhp_mem_waddr
    ,input  logic                  pf_reord_dirhp_mem_we
    ,input  logic [(      15)-1:0] pf_reord_dirhp_mem_wdata
    ,output logic [(      15)-1:0] pf_reord_dirhp_mem_rdata

    ,output logic                  rf_reord_dirhp_mem_re
    ,output logic                  rf_reord_dirhp_mem_rclk
    ,output logic                  rf_reord_dirhp_mem_rclk_rst_n
    ,output logic [(      11)-1:0] rf_reord_dirhp_mem_raddr
    ,output logic [(      11)-1:0] rf_reord_dirhp_mem_waddr
    ,output logic                  rf_reord_dirhp_mem_we
    ,output logic                  rf_reord_dirhp_mem_wclk
    ,output logic                  rf_reord_dirhp_mem_wclk_rst_n
    ,output logic [(      17)-1:0] rf_reord_dirhp_mem_wdata
    ,input  logic [(      17)-1:0] rf_reord_dirhp_mem_rdata

    ,output logic                  rf_reord_dirhp_mem_error

    ,input  logic                  func_reord_dirtp_mem_re
    ,input  logic [(      11)-1:0] func_reord_dirtp_mem_raddr
    ,input  logic [(      11)-1:0] func_reord_dirtp_mem_waddr
    ,input  logic                  func_reord_dirtp_mem_we
    ,input  logic [(      15)-1:0] func_reord_dirtp_mem_wdata
    ,output logic [(      15)-1:0] func_reord_dirtp_mem_rdata

    ,input  logic                  pf_reord_dirtp_mem_re
    ,input  logic [(      11)-1:0] pf_reord_dirtp_mem_raddr
    ,input  logic [(      11)-1:0] pf_reord_dirtp_mem_waddr
    ,input  logic                  pf_reord_dirtp_mem_we
    ,input  logic [(      15)-1:0] pf_reord_dirtp_mem_wdata
    ,output logic [(      15)-1:0] pf_reord_dirtp_mem_rdata

    ,output logic                  rf_reord_dirtp_mem_re
    ,output logic                  rf_reord_dirtp_mem_rclk
    ,output logic                  rf_reord_dirtp_mem_rclk_rst_n
    ,output logic [(      11)-1:0] rf_reord_dirtp_mem_raddr
    ,output logic [(      11)-1:0] rf_reord_dirtp_mem_waddr
    ,output logic                  rf_reord_dirtp_mem_we
    ,output logic                  rf_reord_dirtp_mem_wclk
    ,output logic                  rf_reord_dirtp_mem_wclk_rst_n
    ,output logic [(      17)-1:0] rf_reord_dirtp_mem_wdata
    ,input  logic [(      17)-1:0] rf_reord_dirtp_mem_rdata

    ,output logic                  rf_reord_dirtp_mem_error

    ,input  logic                  func_reord_lbhp_mem_re
    ,input  logic [(      11)-1:0] func_reord_lbhp_mem_raddr
    ,input  logic [(      11)-1:0] func_reord_lbhp_mem_waddr
    ,input  logic                  func_reord_lbhp_mem_we
    ,input  logic [(      15)-1:0] func_reord_lbhp_mem_wdata
    ,output logic [(      15)-1:0] func_reord_lbhp_mem_rdata

    ,input  logic                  pf_reord_lbhp_mem_re
    ,input  logic [(      11)-1:0] pf_reord_lbhp_mem_raddr
    ,input  logic [(      11)-1:0] pf_reord_lbhp_mem_waddr
    ,input  logic                  pf_reord_lbhp_mem_we
    ,input  logic [(      15)-1:0] pf_reord_lbhp_mem_wdata
    ,output logic [(      15)-1:0] pf_reord_lbhp_mem_rdata

    ,output logic                  rf_reord_lbhp_mem_re
    ,output logic                  rf_reord_lbhp_mem_rclk
    ,output logic                  rf_reord_lbhp_mem_rclk_rst_n
    ,output logic [(      11)-1:0] rf_reord_lbhp_mem_raddr
    ,output logic [(      11)-1:0] rf_reord_lbhp_mem_waddr
    ,output logic                  rf_reord_lbhp_mem_we
    ,output logic                  rf_reord_lbhp_mem_wclk
    ,output logic                  rf_reord_lbhp_mem_wclk_rst_n
    ,output logic [(      17)-1:0] rf_reord_lbhp_mem_wdata
    ,input  logic [(      17)-1:0] rf_reord_lbhp_mem_rdata

    ,output logic                  rf_reord_lbhp_mem_error

    ,input  logic                  func_reord_lbtp_mem_re
    ,input  logic [(      11)-1:0] func_reord_lbtp_mem_raddr
    ,input  logic [(      11)-1:0] func_reord_lbtp_mem_waddr
    ,input  logic                  func_reord_lbtp_mem_we
    ,input  logic [(      15)-1:0] func_reord_lbtp_mem_wdata
    ,output logic [(      15)-1:0] func_reord_lbtp_mem_rdata

    ,input  logic                  pf_reord_lbtp_mem_re
    ,input  logic [(      11)-1:0] pf_reord_lbtp_mem_raddr
    ,input  logic [(      11)-1:0] pf_reord_lbtp_mem_waddr
    ,input  logic                  pf_reord_lbtp_mem_we
    ,input  logic [(      15)-1:0] pf_reord_lbtp_mem_wdata
    ,output logic [(      15)-1:0] pf_reord_lbtp_mem_rdata

    ,output logic                  rf_reord_lbtp_mem_re
    ,output logic                  rf_reord_lbtp_mem_rclk
    ,output logic                  rf_reord_lbtp_mem_rclk_rst_n
    ,output logic [(      11)-1:0] rf_reord_lbtp_mem_raddr
    ,output logic [(      11)-1:0] rf_reord_lbtp_mem_waddr
    ,output logic                  rf_reord_lbtp_mem_we
    ,output logic                  rf_reord_lbtp_mem_wclk
    ,output logic                  rf_reord_lbtp_mem_wclk_rst_n
    ,output logic [(      17)-1:0] rf_reord_lbtp_mem_wdata
    ,input  logic [(      17)-1:0] rf_reord_lbtp_mem_rdata

    ,output logic                  rf_reord_lbtp_mem_error

    ,input  logic                  func_reord_st_mem_re
    ,input  logic [(      11)-1:0] func_reord_st_mem_raddr
    ,input  logic [(      11)-1:0] func_reord_st_mem_waddr
    ,input  logic                  func_reord_st_mem_we
    ,input  logic [(      23)-1:0] func_reord_st_mem_wdata
    ,output logic [(      23)-1:0] func_reord_st_mem_rdata

    ,input  logic                  pf_reord_st_mem_re
    ,input  logic [(      11)-1:0] pf_reord_st_mem_raddr
    ,input  logic [(      11)-1:0] pf_reord_st_mem_waddr
    ,input  logic                  pf_reord_st_mem_we
    ,input  logic [(      23)-1:0] pf_reord_st_mem_wdata
    ,output logic [(      23)-1:0] pf_reord_st_mem_rdata

    ,output logic                  rf_reord_st_mem_re
    ,output logic                  rf_reord_st_mem_rclk
    ,output logic                  rf_reord_st_mem_rclk_rst_n
    ,output logic [(      11)-1:0] rf_reord_st_mem_raddr
    ,output logic [(      11)-1:0] rf_reord_st_mem_waddr
    ,output logic                  rf_reord_st_mem_we
    ,output logic                  rf_reord_st_mem_wclk
    ,output logic                  rf_reord_st_mem_wclk_rst_n
    ,output logic [(      25)-1:0] rf_reord_st_mem_wdata
    ,input  logic [(      25)-1:0] rf_reord_st_mem_rdata

    ,output logic                  rf_reord_st_mem_error

    ,input  logic                  func_rop_chp_rop_hcw_fifo_mem_re
    ,input  logic [(       2)-1:0] func_rop_chp_rop_hcw_fifo_mem_raddr
    ,input  logic [(       2)-1:0] func_rop_chp_rop_hcw_fifo_mem_waddr
    ,input  logic                  func_rop_chp_rop_hcw_fifo_mem_we
    ,input  logic [(     204)-1:0] func_rop_chp_rop_hcw_fifo_mem_wdata
    ,output logic [(     204)-1:0] func_rop_chp_rop_hcw_fifo_mem_rdata

    ,input  logic                  pf_rop_chp_rop_hcw_fifo_mem_re
    ,input  logic [(       2)-1:0] pf_rop_chp_rop_hcw_fifo_mem_raddr
    ,input  logic [(       2)-1:0] pf_rop_chp_rop_hcw_fifo_mem_waddr
    ,input  logic                  pf_rop_chp_rop_hcw_fifo_mem_we
    ,input  logic [(     204)-1:0] pf_rop_chp_rop_hcw_fifo_mem_wdata
    ,output logic [(     204)-1:0] pf_rop_chp_rop_hcw_fifo_mem_rdata

    ,output logic                  rf_rop_chp_rop_hcw_fifo_mem_re
    ,output logic                  rf_rop_chp_rop_hcw_fifo_mem_rclk
    ,output logic                  rf_rop_chp_rop_hcw_fifo_mem_rclk_rst_n
    ,output logic [(       2)-1:0] rf_rop_chp_rop_hcw_fifo_mem_raddr
    ,output logic [(       2)-1:0] rf_rop_chp_rop_hcw_fifo_mem_waddr
    ,output logic                  rf_rop_chp_rop_hcw_fifo_mem_we
    ,output logic                  rf_rop_chp_rop_hcw_fifo_mem_wclk
    ,output logic                  rf_rop_chp_rop_hcw_fifo_mem_wclk_rst_n
    ,output logic [(     204)-1:0] rf_rop_chp_rop_hcw_fifo_mem_wdata
    ,input  logic [(     204)-1:0] rf_rop_chp_rop_hcw_fifo_mem_rdata

    ,output logic                  rf_rop_chp_rop_hcw_fifo_mem_error

    ,input  logic                  func_sn0_order_shft_mem_re
    ,input  logic [(       4)-1:0] func_sn0_order_shft_mem_raddr
    ,input  logic [(       4)-1:0] func_sn0_order_shft_mem_waddr
    ,input  logic                  func_sn0_order_shft_mem_we
    ,input  logic [(      12)-1:0] func_sn0_order_shft_mem_wdata
    ,output logic [(      12)-1:0] func_sn0_order_shft_mem_rdata

    ,input  logic                  pf_sn0_order_shft_mem_re
    ,input  logic [(       4)-1:0] pf_sn0_order_shft_mem_raddr
    ,input  logic [(       4)-1:0] pf_sn0_order_shft_mem_waddr
    ,input  logic                  pf_sn0_order_shft_mem_we
    ,input  logic [(      12)-1:0] pf_sn0_order_shft_mem_wdata
    ,output logic [(      12)-1:0] pf_sn0_order_shft_mem_rdata

    ,output logic                  rf_sn0_order_shft_mem_re
    ,output logic                  rf_sn0_order_shft_mem_rclk
    ,output logic                  rf_sn0_order_shft_mem_rclk_rst_n
    ,output logic [(       4)-1:0] rf_sn0_order_shft_mem_raddr
    ,output logic [(       4)-1:0] rf_sn0_order_shft_mem_waddr
    ,output logic                  rf_sn0_order_shft_mem_we
    ,output logic                  rf_sn0_order_shft_mem_wclk
    ,output logic                  rf_sn0_order_shft_mem_wclk_rst_n
    ,output logic [(      12)-1:0] rf_sn0_order_shft_mem_wdata
    ,input  logic [(      12)-1:0] rf_sn0_order_shft_mem_rdata

    ,output logic                  rf_sn0_order_shft_mem_error

    ,input  logic                  func_sn1_order_shft_mem_re
    ,input  logic [(       4)-1:0] func_sn1_order_shft_mem_raddr
    ,input  logic [(       4)-1:0] func_sn1_order_shft_mem_waddr
    ,input  logic                  func_sn1_order_shft_mem_we
    ,input  logic [(      12)-1:0] func_sn1_order_shft_mem_wdata
    ,output logic [(      12)-1:0] func_sn1_order_shft_mem_rdata

    ,input  logic                  pf_sn1_order_shft_mem_re
    ,input  logic [(       4)-1:0] pf_sn1_order_shft_mem_raddr
    ,input  logic [(       4)-1:0] pf_sn1_order_shft_mem_waddr
    ,input  logic                  pf_sn1_order_shft_mem_we
    ,input  logic [(      12)-1:0] pf_sn1_order_shft_mem_wdata
    ,output logic [(      12)-1:0] pf_sn1_order_shft_mem_rdata

    ,output logic                  rf_sn1_order_shft_mem_re
    ,output logic                  rf_sn1_order_shft_mem_rclk
    ,output logic                  rf_sn1_order_shft_mem_rclk_rst_n
    ,output logic [(       4)-1:0] rf_sn1_order_shft_mem_raddr
    ,output logic [(       4)-1:0] rf_sn1_order_shft_mem_waddr
    ,output logic                  rf_sn1_order_shft_mem_we
    ,output logic                  rf_sn1_order_shft_mem_wclk
    ,output logic                  rf_sn1_order_shft_mem_wclk_rst_n
    ,output logic [(      12)-1:0] rf_sn1_order_shft_mem_wdata
    ,input  logic [(      12)-1:0] rf_sn1_order_shft_mem_rdata

    ,output logic                  rf_sn1_order_shft_mem_error

    ,input  logic                  func_sn_complete_fifo_mem_re
    ,input  logic [(       2)-1:0] func_sn_complete_fifo_mem_raddr
    ,input  logic [(       2)-1:0] func_sn_complete_fifo_mem_waddr
    ,input  logic                  func_sn_complete_fifo_mem_we
    ,input  logic [(      21)-1:0] func_sn_complete_fifo_mem_wdata
    ,output logic [(      21)-1:0] func_sn_complete_fifo_mem_rdata

    ,input  logic                  pf_sn_complete_fifo_mem_re
    ,input  logic [(       2)-1:0] pf_sn_complete_fifo_mem_raddr
    ,input  logic [(       2)-1:0] pf_sn_complete_fifo_mem_waddr
    ,input  logic                  pf_sn_complete_fifo_mem_we
    ,input  logic [(      21)-1:0] pf_sn_complete_fifo_mem_wdata
    ,output logic [(      21)-1:0] pf_sn_complete_fifo_mem_rdata

    ,output logic                  rf_sn_complete_fifo_mem_re
    ,output logic                  rf_sn_complete_fifo_mem_rclk
    ,output logic                  rf_sn_complete_fifo_mem_rclk_rst_n
    ,output logic [(       2)-1:0] rf_sn_complete_fifo_mem_raddr
    ,output logic [(       2)-1:0] rf_sn_complete_fifo_mem_waddr
    ,output logic                  rf_sn_complete_fifo_mem_we
    ,output logic                  rf_sn_complete_fifo_mem_wclk
    ,output logic                  rf_sn_complete_fifo_mem_wclk_rst_n
    ,output logic [(      21)-1:0] rf_sn_complete_fifo_mem_wdata
    ,input  logic [(      21)-1:0] rf_sn_complete_fifo_mem_rdata

    ,output logic                  rf_sn_complete_fifo_mem_error

    ,input  logic                  func_sn_ordered_fifo_mem_re
    ,input  logic [(       5)-1:0] func_sn_ordered_fifo_mem_raddr
    ,input  logic [(       5)-1:0] func_sn_ordered_fifo_mem_waddr
    ,input  logic                  func_sn_ordered_fifo_mem_we
    ,input  logic [(      13)-1:0] func_sn_ordered_fifo_mem_wdata
    ,output logic [(      13)-1:0] func_sn_ordered_fifo_mem_rdata

    ,input  logic                  pf_sn_ordered_fifo_mem_re
    ,input  logic [(       5)-1:0] pf_sn_ordered_fifo_mem_raddr
    ,input  logic [(       5)-1:0] pf_sn_ordered_fifo_mem_waddr
    ,input  logic                  pf_sn_ordered_fifo_mem_we
    ,input  logic [(      13)-1:0] pf_sn_ordered_fifo_mem_wdata
    ,output logic [(      13)-1:0] pf_sn_ordered_fifo_mem_rdata

    ,output logic                  rf_sn_ordered_fifo_mem_re
    ,output logic                  rf_sn_ordered_fifo_mem_rclk
    ,output logic                  rf_sn_ordered_fifo_mem_rclk_rst_n
    ,output logic [(       5)-1:0] rf_sn_ordered_fifo_mem_raddr
    ,output logic [(       5)-1:0] rf_sn_ordered_fifo_mem_waddr
    ,output logic                  rf_sn_ordered_fifo_mem_we
    ,output logic                  rf_sn_ordered_fifo_mem_wclk
    ,output logic                  rf_sn_ordered_fifo_mem_wclk_rst_n
    ,output logic [(      13)-1:0] rf_sn_ordered_fifo_mem_wdata
    ,input  logic [(      13)-1:0] rf_sn_ordered_fifo_mem_rdata

    ,output logic                  rf_sn_ordered_fifo_mem_error

);

logic        rf_dir_rply_req_fifo_mem_rdata_error;

logic        cfg_mem_ack_dir_rply_req_fifo_mem_nc;
logic [31:0] cfg_mem_rdata_dir_rply_req_fifo_mem_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (8)
        ,.DWIDTH              (60)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_dir_rply_req_fifo_mem (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_dir_rply_req_fifo_mem_re)
        ,.func_mem_raddr      (func_dir_rply_req_fifo_mem_raddr)
        ,.func_mem_waddr      (func_dir_rply_req_fifo_mem_waddr)
        ,.func_mem_we         (func_dir_rply_req_fifo_mem_we)
        ,.func_mem_wdata      (func_dir_rply_req_fifo_mem_wdata)
        ,.func_mem_rdata      (func_dir_rply_req_fifo_mem_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_dir_rply_req_fifo_mem_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_dir_rply_req_fifo_mem_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_dir_rply_req_fifo_mem_re)
        ,.pf_mem_raddr        (pf_dir_rply_req_fifo_mem_raddr)
        ,.pf_mem_waddr        (pf_dir_rply_req_fifo_mem_waddr)
        ,.pf_mem_we           (pf_dir_rply_req_fifo_mem_we)
        ,.pf_mem_wdata        (pf_dir_rply_req_fifo_mem_wdata)
        ,.pf_mem_rdata        (pf_dir_rply_req_fifo_mem_rdata)

        ,.mem_wclk            (rf_dir_rply_req_fifo_mem_wclk)
        ,.mem_rclk            (rf_dir_rply_req_fifo_mem_rclk)
        ,.mem_wclk_rst_n      (rf_dir_rply_req_fifo_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_dir_rply_req_fifo_mem_rclk_rst_n)
        ,.mem_re              (rf_dir_rply_req_fifo_mem_re)
        ,.mem_raddr           (rf_dir_rply_req_fifo_mem_raddr)
        ,.mem_waddr           (rf_dir_rply_req_fifo_mem_waddr)
        ,.mem_we              (rf_dir_rply_req_fifo_mem_we)
        ,.mem_wdata           (rf_dir_rply_req_fifo_mem_wdata)
        ,.mem_rdata           (rf_dir_rply_req_fifo_mem_rdata)

        ,.mem_rdata_error     (rf_dir_rply_req_fifo_mem_rdata_error)
        ,.error               (rf_dir_rply_req_fifo_mem_error)
);

logic        rf_ldb_rply_req_fifo_mem_rdata_error;

logic        cfg_mem_ack_ldb_rply_req_fifo_mem_nc;
logic [31:0] cfg_mem_rdata_ldb_rply_req_fifo_mem_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (8)
        ,.DWIDTH              (60)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_ldb_rply_req_fifo_mem (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_ldb_rply_req_fifo_mem_re)
        ,.func_mem_raddr      (func_ldb_rply_req_fifo_mem_raddr)
        ,.func_mem_waddr      (func_ldb_rply_req_fifo_mem_waddr)
        ,.func_mem_we         (func_ldb_rply_req_fifo_mem_we)
        ,.func_mem_wdata      (func_ldb_rply_req_fifo_mem_wdata)
        ,.func_mem_rdata      (func_ldb_rply_req_fifo_mem_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_ldb_rply_req_fifo_mem_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_ldb_rply_req_fifo_mem_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_ldb_rply_req_fifo_mem_re)
        ,.pf_mem_raddr        (pf_ldb_rply_req_fifo_mem_raddr)
        ,.pf_mem_waddr        (pf_ldb_rply_req_fifo_mem_waddr)
        ,.pf_mem_we           (pf_ldb_rply_req_fifo_mem_we)
        ,.pf_mem_wdata        (pf_ldb_rply_req_fifo_mem_wdata)
        ,.pf_mem_rdata        (pf_ldb_rply_req_fifo_mem_rdata)

        ,.mem_wclk            (rf_ldb_rply_req_fifo_mem_wclk)
        ,.mem_rclk            (rf_ldb_rply_req_fifo_mem_rclk)
        ,.mem_wclk_rst_n      (rf_ldb_rply_req_fifo_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_ldb_rply_req_fifo_mem_rclk_rst_n)
        ,.mem_re              (rf_ldb_rply_req_fifo_mem_re)
        ,.mem_raddr           (rf_ldb_rply_req_fifo_mem_raddr)
        ,.mem_waddr           (rf_ldb_rply_req_fifo_mem_waddr)
        ,.mem_we              (rf_ldb_rply_req_fifo_mem_we)
        ,.mem_wdata           (rf_ldb_rply_req_fifo_mem_wdata)
        ,.mem_rdata           (rf_ldb_rply_req_fifo_mem_rdata)

        ,.mem_rdata_error     (rf_ldb_rply_req_fifo_mem_rdata_error)
        ,.error               (rf_ldb_rply_req_fifo_mem_error)
);

logic        rf_lsp_reordercmp_fifo_mem_rdata_error;

logic        cfg_mem_ack_lsp_reordercmp_fifo_mem_nc;
logic [31:0] cfg_mem_rdata_lsp_reordercmp_fifo_mem_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (8)
        ,.DWIDTH              (19)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_lsp_reordercmp_fifo_mem (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_lsp_reordercmp_fifo_mem_re)
        ,.func_mem_raddr      (func_lsp_reordercmp_fifo_mem_raddr)
        ,.func_mem_waddr      (func_lsp_reordercmp_fifo_mem_waddr)
        ,.func_mem_we         (func_lsp_reordercmp_fifo_mem_we)
        ,.func_mem_wdata      (func_lsp_reordercmp_fifo_mem_wdata)
        ,.func_mem_rdata      (func_lsp_reordercmp_fifo_mem_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_lsp_reordercmp_fifo_mem_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_lsp_reordercmp_fifo_mem_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_lsp_reordercmp_fifo_mem_re)
        ,.pf_mem_raddr        (pf_lsp_reordercmp_fifo_mem_raddr)
        ,.pf_mem_waddr        (pf_lsp_reordercmp_fifo_mem_waddr)
        ,.pf_mem_we           (pf_lsp_reordercmp_fifo_mem_we)
        ,.pf_mem_wdata        (pf_lsp_reordercmp_fifo_mem_wdata)
        ,.pf_mem_rdata        (pf_lsp_reordercmp_fifo_mem_rdata)

        ,.mem_wclk            (rf_lsp_reordercmp_fifo_mem_wclk)
        ,.mem_rclk            (rf_lsp_reordercmp_fifo_mem_rclk)
        ,.mem_wclk_rst_n      (rf_lsp_reordercmp_fifo_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_lsp_reordercmp_fifo_mem_rclk_rst_n)
        ,.mem_re              (rf_lsp_reordercmp_fifo_mem_re)
        ,.mem_raddr           (rf_lsp_reordercmp_fifo_mem_raddr)
        ,.mem_waddr           (rf_lsp_reordercmp_fifo_mem_waddr)
        ,.mem_we              (rf_lsp_reordercmp_fifo_mem_we)
        ,.mem_wdata           (rf_lsp_reordercmp_fifo_mem_wdata)
        ,.mem_rdata           (rf_lsp_reordercmp_fifo_mem_rdata)

        ,.mem_rdata_error     (rf_lsp_reordercmp_fifo_mem_rdata_error)
        ,.error               (rf_lsp_reordercmp_fifo_mem_error)
);

logic        rf_reord_cnt_mem_rdata_error;

hqm_AW_rfw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (14)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (2)
) i_reord_cnt_mem (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_reord_cnt_mem_re)
        ,.func_mem_raddr      (func_reord_cnt_mem_raddr)
        ,.func_mem_waddr      (func_reord_cnt_mem_waddr)
        ,.func_mem_we         (func_reord_cnt_mem_we)
        ,.func_mem_wdata      (func_reord_cnt_mem_wdata)
        ,.func_mem_rdata      (func_reord_cnt_mem_rdata)

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

        ,.pf_mem_re           (pf_reord_cnt_mem_re)
        ,.pf_mem_raddr        (pf_reord_cnt_mem_raddr)
        ,.pf_mem_waddr        (pf_reord_cnt_mem_waddr)
        ,.pf_mem_we           (pf_reord_cnt_mem_we)
        ,.pf_mem_wdata        (pf_reord_cnt_mem_wdata)
        ,.pf_mem_rdata        (pf_reord_cnt_mem_rdata)

        ,.mem_wclk            (rf_reord_cnt_mem_wclk)
        ,.mem_rclk            (rf_reord_cnt_mem_rclk)
        ,.mem_wclk_rst_n      (rf_reord_cnt_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_reord_cnt_mem_rclk_rst_n)
        ,.mem_re              (rf_reord_cnt_mem_re)
        ,.mem_raddr           (rf_reord_cnt_mem_raddr)
        ,.mem_waddr           (rf_reord_cnt_mem_waddr)
        ,.mem_we              (rf_reord_cnt_mem_we)
        ,.mem_wdata           (rf_reord_cnt_mem_wdata)
        ,.mem_rdata           (rf_reord_cnt_mem_rdata)

        ,.mem_rdata_error     (rf_reord_cnt_mem_rdata_error)
        ,.error               (rf_reord_cnt_mem_error)
);

logic        rf_reord_dirhp_mem_rdata_error;

hqm_AW_rfw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (15)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (2)
) i_reord_dirhp_mem (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_reord_dirhp_mem_re)
        ,.func_mem_raddr      (func_reord_dirhp_mem_raddr)
        ,.func_mem_waddr      (func_reord_dirhp_mem_waddr)
        ,.func_mem_we         (func_reord_dirhp_mem_we)
        ,.func_mem_wdata      (func_reord_dirhp_mem_wdata)
        ,.func_mem_rdata      (func_reord_dirhp_mem_rdata)

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

        ,.pf_mem_re           (pf_reord_dirhp_mem_re)
        ,.pf_mem_raddr        (pf_reord_dirhp_mem_raddr)
        ,.pf_mem_waddr        (pf_reord_dirhp_mem_waddr)
        ,.pf_mem_we           (pf_reord_dirhp_mem_we)
        ,.pf_mem_wdata        (pf_reord_dirhp_mem_wdata)
        ,.pf_mem_rdata        (pf_reord_dirhp_mem_rdata)

        ,.mem_wclk            (rf_reord_dirhp_mem_wclk)
        ,.mem_rclk            (rf_reord_dirhp_mem_rclk)
        ,.mem_wclk_rst_n      (rf_reord_dirhp_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_reord_dirhp_mem_rclk_rst_n)
        ,.mem_re              (rf_reord_dirhp_mem_re)
        ,.mem_raddr           (rf_reord_dirhp_mem_raddr)
        ,.mem_waddr           (rf_reord_dirhp_mem_waddr)
        ,.mem_we              (rf_reord_dirhp_mem_we)
        ,.mem_wdata           (rf_reord_dirhp_mem_wdata)
        ,.mem_rdata           (rf_reord_dirhp_mem_rdata)

        ,.mem_rdata_error     (rf_reord_dirhp_mem_rdata_error)
        ,.error               (rf_reord_dirhp_mem_error)
);

logic        rf_reord_dirtp_mem_rdata_error;

hqm_AW_rfw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (15)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (2)
) i_reord_dirtp_mem (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_reord_dirtp_mem_re)
        ,.func_mem_raddr      (func_reord_dirtp_mem_raddr)
        ,.func_mem_waddr      (func_reord_dirtp_mem_waddr)
        ,.func_mem_we         (func_reord_dirtp_mem_we)
        ,.func_mem_wdata      (func_reord_dirtp_mem_wdata)
        ,.func_mem_rdata      (func_reord_dirtp_mem_rdata)

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

        ,.pf_mem_re           (pf_reord_dirtp_mem_re)
        ,.pf_mem_raddr        (pf_reord_dirtp_mem_raddr)
        ,.pf_mem_waddr        (pf_reord_dirtp_mem_waddr)
        ,.pf_mem_we           (pf_reord_dirtp_mem_we)
        ,.pf_mem_wdata        (pf_reord_dirtp_mem_wdata)
        ,.pf_mem_rdata        (pf_reord_dirtp_mem_rdata)

        ,.mem_wclk            (rf_reord_dirtp_mem_wclk)
        ,.mem_rclk            (rf_reord_dirtp_mem_rclk)
        ,.mem_wclk_rst_n      (rf_reord_dirtp_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_reord_dirtp_mem_rclk_rst_n)
        ,.mem_re              (rf_reord_dirtp_mem_re)
        ,.mem_raddr           (rf_reord_dirtp_mem_raddr)
        ,.mem_waddr           (rf_reord_dirtp_mem_waddr)
        ,.mem_we              (rf_reord_dirtp_mem_we)
        ,.mem_wdata           (rf_reord_dirtp_mem_wdata)
        ,.mem_rdata           (rf_reord_dirtp_mem_rdata)

        ,.mem_rdata_error     (rf_reord_dirtp_mem_rdata_error)
        ,.error               (rf_reord_dirtp_mem_error)
);

logic        rf_reord_lbhp_mem_rdata_error;

hqm_AW_rfw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (15)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (2)
) i_reord_lbhp_mem (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_reord_lbhp_mem_re)
        ,.func_mem_raddr      (func_reord_lbhp_mem_raddr)
        ,.func_mem_waddr      (func_reord_lbhp_mem_waddr)
        ,.func_mem_we         (func_reord_lbhp_mem_we)
        ,.func_mem_wdata      (func_reord_lbhp_mem_wdata)
        ,.func_mem_rdata      (func_reord_lbhp_mem_rdata)

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

        ,.pf_mem_re           (pf_reord_lbhp_mem_re)
        ,.pf_mem_raddr        (pf_reord_lbhp_mem_raddr)
        ,.pf_mem_waddr        (pf_reord_lbhp_mem_waddr)
        ,.pf_mem_we           (pf_reord_lbhp_mem_we)
        ,.pf_mem_wdata        (pf_reord_lbhp_mem_wdata)
        ,.pf_mem_rdata        (pf_reord_lbhp_mem_rdata)

        ,.mem_wclk            (rf_reord_lbhp_mem_wclk)
        ,.mem_rclk            (rf_reord_lbhp_mem_rclk)
        ,.mem_wclk_rst_n      (rf_reord_lbhp_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_reord_lbhp_mem_rclk_rst_n)
        ,.mem_re              (rf_reord_lbhp_mem_re)
        ,.mem_raddr           (rf_reord_lbhp_mem_raddr)
        ,.mem_waddr           (rf_reord_lbhp_mem_waddr)
        ,.mem_we              (rf_reord_lbhp_mem_we)
        ,.mem_wdata           (rf_reord_lbhp_mem_wdata)
        ,.mem_rdata           (rf_reord_lbhp_mem_rdata)

        ,.mem_rdata_error     (rf_reord_lbhp_mem_rdata_error)
        ,.error               (rf_reord_lbhp_mem_error)
);

logic        rf_reord_lbtp_mem_rdata_error;

hqm_AW_rfw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (15)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (2)
) i_reord_lbtp_mem (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_reord_lbtp_mem_re)
        ,.func_mem_raddr      (func_reord_lbtp_mem_raddr)
        ,.func_mem_waddr      (func_reord_lbtp_mem_waddr)
        ,.func_mem_we         (func_reord_lbtp_mem_we)
        ,.func_mem_wdata      (func_reord_lbtp_mem_wdata)
        ,.func_mem_rdata      (func_reord_lbtp_mem_rdata)

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

        ,.pf_mem_re           (pf_reord_lbtp_mem_re)
        ,.pf_mem_raddr        (pf_reord_lbtp_mem_raddr)
        ,.pf_mem_waddr        (pf_reord_lbtp_mem_waddr)
        ,.pf_mem_we           (pf_reord_lbtp_mem_we)
        ,.pf_mem_wdata        (pf_reord_lbtp_mem_wdata)
        ,.pf_mem_rdata        (pf_reord_lbtp_mem_rdata)

        ,.mem_wclk            (rf_reord_lbtp_mem_wclk)
        ,.mem_rclk            (rf_reord_lbtp_mem_rclk)
        ,.mem_wclk_rst_n      (rf_reord_lbtp_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_reord_lbtp_mem_rclk_rst_n)
        ,.mem_re              (rf_reord_lbtp_mem_re)
        ,.mem_raddr           (rf_reord_lbtp_mem_raddr)
        ,.mem_waddr           (rf_reord_lbtp_mem_waddr)
        ,.mem_we              (rf_reord_lbtp_mem_we)
        ,.mem_wdata           (rf_reord_lbtp_mem_wdata)
        ,.mem_rdata           (rf_reord_lbtp_mem_rdata)

        ,.mem_rdata_error     (rf_reord_lbtp_mem_rdata_error)
        ,.error               (rf_reord_lbtp_mem_error)
);

logic        rf_reord_st_mem_rdata_error;

hqm_AW_rfw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (23)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (2)
) i_reord_st_mem (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_reord_st_mem_re)
        ,.func_mem_raddr      (func_reord_st_mem_raddr)
        ,.func_mem_waddr      (func_reord_st_mem_waddr)
        ,.func_mem_we         (func_reord_st_mem_we)
        ,.func_mem_wdata      (func_reord_st_mem_wdata)
        ,.func_mem_rdata      (func_reord_st_mem_rdata)

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

        ,.pf_mem_re           (pf_reord_st_mem_re)
        ,.pf_mem_raddr        (pf_reord_st_mem_raddr)
        ,.pf_mem_waddr        (pf_reord_st_mem_waddr)
        ,.pf_mem_we           (pf_reord_st_mem_we)
        ,.pf_mem_wdata        (pf_reord_st_mem_wdata)
        ,.pf_mem_rdata        (pf_reord_st_mem_rdata)

        ,.mem_wclk            (rf_reord_st_mem_wclk)
        ,.mem_rclk            (rf_reord_st_mem_rclk)
        ,.mem_wclk_rst_n      (rf_reord_st_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_reord_st_mem_rclk_rst_n)
        ,.mem_re              (rf_reord_st_mem_re)
        ,.mem_raddr           (rf_reord_st_mem_raddr)
        ,.mem_waddr           (rf_reord_st_mem_waddr)
        ,.mem_we              (rf_reord_st_mem_we)
        ,.mem_wdata           (rf_reord_st_mem_wdata)
        ,.mem_rdata           (rf_reord_st_mem_rdata)

        ,.mem_rdata_error     (rf_reord_st_mem_rdata_error)
        ,.error               (rf_reord_st_mem_error)
);

logic        rf_rop_chp_rop_hcw_fifo_mem_rdata_error;

logic        cfg_mem_ack_rop_chp_rop_hcw_fifo_mem_nc;
logic [31:0] cfg_mem_rdata_rop_chp_rop_hcw_fifo_mem_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (4)
        ,.DWIDTH              (204)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_rop_chp_rop_hcw_fifo_mem (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_rop_chp_rop_hcw_fifo_mem_re)
        ,.func_mem_raddr      (func_rop_chp_rop_hcw_fifo_mem_raddr)
        ,.func_mem_waddr      (func_rop_chp_rop_hcw_fifo_mem_waddr)
        ,.func_mem_we         (func_rop_chp_rop_hcw_fifo_mem_we)
        ,.func_mem_wdata      (func_rop_chp_rop_hcw_fifo_mem_wdata)
        ,.func_mem_rdata      (func_rop_chp_rop_hcw_fifo_mem_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_rop_chp_rop_hcw_fifo_mem_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_rop_chp_rop_hcw_fifo_mem_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_rop_chp_rop_hcw_fifo_mem_re)
        ,.pf_mem_raddr        (pf_rop_chp_rop_hcw_fifo_mem_raddr)
        ,.pf_mem_waddr        (pf_rop_chp_rop_hcw_fifo_mem_waddr)
        ,.pf_mem_we           (pf_rop_chp_rop_hcw_fifo_mem_we)
        ,.pf_mem_wdata        (pf_rop_chp_rop_hcw_fifo_mem_wdata)
        ,.pf_mem_rdata        (pf_rop_chp_rop_hcw_fifo_mem_rdata)

        ,.mem_wclk            (rf_rop_chp_rop_hcw_fifo_mem_wclk)
        ,.mem_rclk            (rf_rop_chp_rop_hcw_fifo_mem_rclk)
        ,.mem_wclk_rst_n      (rf_rop_chp_rop_hcw_fifo_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_rop_chp_rop_hcw_fifo_mem_rclk_rst_n)
        ,.mem_re              (rf_rop_chp_rop_hcw_fifo_mem_re)
        ,.mem_raddr           (rf_rop_chp_rop_hcw_fifo_mem_raddr)
        ,.mem_waddr           (rf_rop_chp_rop_hcw_fifo_mem_waddr)
        ,.mem_we              (rf_rop_chp_rop_hcw_fifo_mem_we)
        ,.mem_wdata           (rf_rop_chp_rop_hcw_fifo_mem_wdata)
        ,.mem_rdata           (rf_rop_chp_rop_hcw_fifo_mem_rdata)

        ,.mem_rdata_error     (rf_rop_chp_rop_hcw_fifo_mem_rdata_error)
        ,.error               (rf_rop_chp_rop_hcw_fifo_mem_error)
);

logic        rf_sn0_order_shft_mem_rdata_error;

hqm_AW_rfw_access #( 
         .DEPTH               (16)
        ,.DWIDTH              (12)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_sn0_order_shft_mem (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_sn0_order_shft_mem_re)
        ,.func_mem_raddr      (func_sn0_order_shft_mem_raddr)
        ,.func_mem_waddr      (func_sn0_order_shft_mem_waddr)
        ,.func_mem_we         (func_sn0_order_shft_mem_we)
        ,.func_mem_wdata      (func_sn0_order_shft_mem_wdata)
        ,.func_mem_rdata      (func_sn0_order_shft_mem_rdata)

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

        ,.pf_mem_re           (pf_sn0_order_shft_mem_re)
        ,.pf_mem_raddr        (pf_sn0_order_shft_mem_raddr)
        ,.pf_mem_waddr        (pf_sn0_order_shft_mem_waddr)
        ,.pf_mem_we           (pf_sn0_order_shft_mem_we)
        ,.pf_mem_wdata        (pf_sn0_order_shft_mem_wdata)
        ,.pf_mem_rdata        (pf_sn0_order_shft_mem_rdata)

        ,.mem_wclk            (rf_sn0_order_shft_mem_wclk)
        ,.mem_rclk            (rf_sn0_order_shft_mem_rclk)
        ,.mem_wclk_rst_n      (rf_sn0_order_shft_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_sn0_order_shft_mem_rclk_rst_n)
        ,.mem_re              (rf_sn0_order_shft_mem_re)
        ,.mem_raddr           (rf_sn0_order_shft_mem_raddr)
        ,.mem_waddr           (rf_sn0_order_shft_mem_waddr)
        ,.mem_we              (rf_sn0_order_shft_mem_we)
        ,.mem_wdata           (rf_sn0_order_shft_mem_wdata)
        ,.mem_rdata           (rf_sn0_order_shft_mem_rdata)

        ,.mem_rdata_error     (rf_sn0_order_shft_mem_rdata_error)
        ,.error               (rf_sn0_order_shft_mem_error)
);

logic        rf_sn1_order_shft_mem_rdata_error;

hqm_AW_rfw_access #( 
         .DEPTH               (16)
        ,.DWIDTH              (12)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_sn1_order_shft_mem (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_sn1_order_shft_mem_re)
        ,.func_mem_raddr      (func_sn1_order_shft_mem_raddr)
        ,.func_mem_waddr      (func_sn1_order_shft_mem_waddr)
        ,.func_mem_we         (func_sn1_order_shft_mem_we)
        ,.func_mem_wdata      (func_sn1_order_shft_mem_wdata)
        ,.func_mem_rdata      (func_sn1_order_shft_mem_rdata)

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

        ,.pf_mem_re           (pf_sn1_order_shft_mem_re)
        ,.pf_mem_raddr        (pf_sn1_order_shft_mem_raddr)
        ,.pf_mem_waddr        (pf_sn1_order_shft_mem_waddr)
        ,.pf_mem_we           (pf_sn1_order_shft_mem_we)
        ,.pf_mem_wdata        (pf_sn1_order_shft_mem_wdata)
        ,.pf_mem_rdata        (pf_sn1_order_shft_mem_rdata)

        ,.mem_wclk            (rf_sn1_order_shft_mem_wclk)
        ,.mem_rclk            (rf_sn1_order_shft_mem_rclk)
        ,.mem_wclk_rst_n      (rf_sn1_order_shft_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_sn1_order_shft_mem_rclk_rst_n)
        ,.mem_re              (rf_sn1_order_shft_mem_re)
        ,.mem_raddr           (rf_sn1_order_shft_mem_raddr)
        ,.mem_waddr           (rf_sn1_order_shft_mem_waddr)
        ,.mem_we              (rf_sn1_order_shft_mem_we)
        ,.mem_wdata           (rf_sn1_order_shft_mem_wdata)
        ,.mem_rdata           (rf_sn1_order_shft_mem_rdata)

        ,.mem_rdata_error     (rf_sn1_order_shft_mem_rdata_error)
        ,.error               (rf_sn1_order_shft_mem_error)
);

logic        rf_sn_complete_fifo_mem_rdata_error;

logic        cfg_mem_ack_sn_complete_fifo_mem_nc;
logic [31:0] cfg_mem_rdata_sn_complete_fifo_mem_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (4)
        ,.DWIDTH              (21)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_sn_complete_fifo_mem (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_sn_complete_fifo_mem_re)
        ,.func_mem_raddr      (func_sn_complete_fifo_mem_raddr)
        ,.func_mem_waddr      (func_sn_complete_fifo_mem_waddr)
        ,.func_mem_we         (func_sn_complete_fifo_mem_we)
        ,.func_mem_wdata      (func_sn_complete_fifo_mem_wdata)
        ,.func_mem_rdata      (func_sn_complete_fifo_mem_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_sn_complete_fifo_mem_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_sn_complete_fifo_mem_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_sn_complete_fifo_mem_re)
        ,.pf_mem_raddr        (pf_sn_complete_fifo_mem_raddr)
        ,.pf_mem_waddr        (pf_sn_complete_fifo_mem_waddr)
        ,.pf_mem_we           (pf_sn_complete_fifo_mem_we)
        ,.pf_mem_wdata        (pf_sn_complete_fifo_mem_wdata)
        ,.pf_mem_rdata        (pf_sn_complete_fifo_mem_rdata)

        ,.mem_wclk            (rf_sn_complete_fifo_mem_wclk)
        ,.mem_rclk            (rf_sn_complete_fifo_mem_rclk)
        ,.mem_wclk_rst_n      (rf_sn_complete_fifo_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_sn_complete_fifo_mem_rclk_rst_n)
        ,.mem_re              (rf_sn_complete_fifo_mem_re)
        ,.mem_raddr           (rf_sn_complete_fifo_mem_raddr)
        ,.mem_waddr           (rf_sn_complete_fifo_mem_waddr)
        ,.mem_we              (rf_sn_complete_fifo_mem_we)
        ,.mem_wdata           (rf_sn_complete_fifo_mem_wdata)
        ,.mem_rdata           (rf_sn_complete_fifo_mem_rdata)

        ,.mem_rdata_error     (rf_sn_complete_fifo_mem_rdata_error)
        ,.error               (rf_sn_complete_fifo_mem_error)
);

logic        rf_sn_ordered_fifo_mem_rdata_error;

logic        cfg_mem_ack_sn_ordered_fifo_mem_nc;
logic [31:0] cfg_mem_rdata_sn_ordered_fifo_mem_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (32)
        ,.DWIDTH              (13)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_sn_ordered_fifo_mem (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_sn_ordered_fifo_mem_re)
        ,.func_mem_raddr      (func_sn_ordered_fifo_mem_raddr)
        ,.func_mem_waddr      (func_sn_ordered_fifo_mem_waddr)
        ,.func_mem_we         (func_sn_ordered_fifo_mem_we)
        ,.func_mem_wdata      (func_sn_ordered_fifo_mem_wdata)
        ,.func_mem_rdata      (func_sn_ordered_fifo_mem_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_sn_ordered_fifo_mem_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_sn_ordered_fifo_mem_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_sn_ordered_fifo_mem_re)
        ,.pf_mem_raddr        (pf_sn_ordered_fifo_mem_raddr)
        ,.pf_mem_waddr        (pf_sn_ordered_fifo_mem_waddr)
        ,.pf_mem_we           (pf_sn_ordered_fifo_mem_we)
        ,.pf_mem_wdata        (pf_sn_ordered_fifo_mem_wdata)
        ,.pf_mem_rdata        (pf_sn_ordered_fifo_mem_rdata)

        ,.mem_wclk            (rf_sn_ordered_fifo_mem_wclk)
        ,.mem_rclk            (rf_sn_ordered_fifo_mem_rclk)
        ,.mem_wclk_rst_n      (rf_sn_ordered_fifo_mem_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_sn_ordered_fifo_mem_rclk_rst_n)
        ,.mem_re              (rf_sn_ordered_fifo_mem_re)
        ,.mem_raddr           (rf_sn_ordered_fifo_mem_raddr)
        ,.mem_waddr           (rf_sn_ordered_fifo_mem_waddr)
        ,.mem_we              (rf_sn_ordered_fifo_mem_we)
        ,.mem_wdata           (rf_sn_ordered_fifo_mem_wdata)
        ,.mem_rdata           (rf_sn_ordered_fifo_mem_rdata)

        ,.mem_rdata_error     (rf_sn_ordered_fifo_mem_rdata_error)
        ,.error               (rf_sn_ordered_fifo_mem_error)
);

assign hqm_reorder_pipe_rfw_top_ipar_error = rf_dir_rply_req_fifo_mem_rdata_error | rf_ldb_rply_req_fifo_mem_rdata_error | rf_lsp_reordercmp_fifo_mem_rdata_error | rf_reord_cnt_mem_rdata_error | rf_reord_dirhp_mem_rdata_error | rf_reord_dirtp_mem_rdata_error | rf_reord_lbhp_mem_rdata_error | rf_reord_lbtp_mem_rdata_error | rf_reord_st_mem_rdata_error | rf_rop_chp_rop_hcw_fifo_mem_rdata_error | rf_sn0_order_shft_mem_rdata_error | rf_sn1_order_shft_mem_rdata_error | rf_sn_complete_fifo_mem_rdata_error | rf_sn_ordered_fifo_mem_rdata_error ;

endmodule

