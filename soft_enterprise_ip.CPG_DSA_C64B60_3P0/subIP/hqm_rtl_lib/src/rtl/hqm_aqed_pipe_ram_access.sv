module hqm_aqed_pipe_ram_access
     import hqm_AW_pkg::* , hqm_pkg::* , hqm_core_pkg::*;
(
     input  logic                  clk_pre_rcb_lcb
    ,input  logic                  hqm_gated_clk
    ,input  logic                  hqm_inp_gated_clk

    ,input  logic                  hqm_clk_rptr_rst_sync_b
    ,input  logic                  hqm_clk_ungate
    ,input  logic                  hqm_fullrate_clk
    ,input  logic                  hqm_gated_rst_n
    ,input  logic                  hqm_gatedclk_enable_and
    ,input  logic                  hqm_inp_gated_rst_n

    ,input  logic [(  3 *  1)-1:0] cfg_mem_re          // lintra s-0527
    ,input  logic [(  3 *  1)-1:0] cfg_mem_we          // lintra s-0527
    ,input  logic [(      20)-1:0] cfg_mem_addr        // lintra s-0527
    ,input  logic [(      12)-1:0] cfg_mem_minbit      // lintra s-0527
    ,input  logic [(      12)-1:0] cfg_mem_maxbit      // lintra s-0527
    ,input  logic [(      32)-1:0] cfg_mem_wdata       // lintra s-0527
    ,output logic [(  3 * 32)-1:0] cfg_mem_rdata
    ,output logic [(  3 *  1)-1:0] cfg_mem_ack
    ,input  logic                  cfg_mem_cc_v        // lintra s-0527
    ,input  logic [(       8)-1:0] cfg_mem_cc_value    // lintra s-0527
    ,input  logic [(       4)-1:0] cfg_mem_cc_width    // lintra s-0527
    ,input  logic [(      12)-1:0] cfg_mem_cc_position // lintra s-0527

    ,output logic                  hqm_aqed_pipe_rfw_top_ipar_error

,input  logic [(       8)-1:0] func_FUNC_WEN_RF_IN_P0
,input  logic [( 8 *   8)-1:0] func_FUNC_WR_ADDR_RF_IN_P0
,input  logic [( 8 *  26)-1:0] func_FUNC_WR_DATA_RF_IN_P0
,input  logic [(       8)-1:0] func_FUNC_CEN_RF_IN_P0
,input  logic [( 8 *  26)-1:0] func_FUNC_CM_DATA_RF_IN_P0
,output logic [( 8 * 256)-1:0] func_CM_MATCH_RF_OUT_P0
,input  logic                   func_FUNC_REN_RF_IN_P0
,input  logic [(       8)-1:0] func_FUNC_RD_ADDR_RF_IN_P0
,output logic [( 8 *  26)-1:0] func_DATA_RF_OUT_P0
,input  logic [(       8)-1:0] pf_FUNC_WEN_RF_IN_P0
,input  logic [( 8 *   8)-1:0] pf_FUNC_WR_ADDR_RF_IN_P0
,input  logic [( 8 *  26)-1:0] pf_FUNC_WR_DATA_RF_IN_P0
,input  logic [(       8)-1:0] pf_FUNC_CEN_RF_IN_P0
,input  logic [( 8 *  26)-1:0] pf_FUNC_CM_DATA_RF_IN_P0
,output logic [( 8 * 256)-1:0] pf_CM_MATCH_RF_OUT_P0
,input  logic                  pf_FUNC_REN_RF_IN_P0
,input  logic [(       8)-1:0] pf_FUNC_RD_ADDR_RF_IN_P0
,output logic [( 8 *  26)-1:0] pf_DATA_RF_OUT_P0
,output logic                  bcam_AW_bcam_2048x26_wclk
,output logic                  bcam_AW_bcam_2048x26_rclk
,output logic                  bcam_AW_bcam_2048x26_cclk
,output logic                  bcam_AW_bcam_2048x26_dfx_clk
,output logic [(       8)-1:0] bcam_AW_bcam_2048x26_we
,output logic [( 8 *   8)-1:0] bcam_AW_bcam_2048x26_waddr
,output logic [( 8 *  26)-1:0] bcam_AW_bcam_2048x26_wdata
,output logic [(       8)-1:0] bcam_AW_bcam_2048x26_ce
,output logic [( 8 *  26)-1:0] bcam_AW_bcam_2048x26_cdata
,input  logic [( 8 * 256)-1:0] bcam_AW_bcam_2048x26_cmatch
,output logic                  bcam_AW_bcam_2048x26_re
,output logic [(       8)-1:0] bcam_AW_bcam_2048x26_raddr
,input  logic [( 8 *  26)-1:0] bcam_AW_bcam_2048x26_rdata
,output logic                  AW_bcam_2048x26_error
    ,input  logic                  func_aqed_fid_cnt_re
    ,input  logic [(      12)-1:0] func_aqed_fid_cnt_raddr
    ,input  logic [(      12)-1:0] func_aqed_fid_cnt_waddr
    ,input  logic                  func_aqed_fid_cnt_we
    ,input  logic [(      15)-1:0] func_aqed_fid_cnt_wdata
    ,output logic [(      15)-1:0] func_aqed_fid_cnt_rdata

    ,input  logic                  pf_aqed_fid_cnt_re
    ,input  logic [(      12)-1:0] pf_aqed_fid_cnt_raddr
    ,input  logic [(      12)-1:0] pf_aqed_fid_cnt_waddr
    ,input  logic                  pf_aqed_fid_cnt_we
    ,input  logic [(      15)-1:0] pf_aqed_fid_cnt_wdata
    ,output logic [(      15)-1:0] pf_aqed_fid_cnt_rdata

    ,output logic                  rf_aqed_fid_cnt_re
    ,output logic                  rf_aqed_fid_cnt_rclk
    ,output logic                  rf_aqed_fid_cnt_rclk_rst_n
    ,output logic [(      11)-1:0] rf_aqed_fid_cnt_raddr
    ,output logic [(      11)-1:0] rf_aqed_fid_cnt_waddr
    ,output logic                  rf_aqed_fid_cnt_we
    ,output logic                  rf_aqed_fid_cnt_wclk
    ,output logic                  rf_aqed_fid_cnt_wclk_rst_n
    ,output logic [(      17)-1:0] rf_aqed_fid_cnt_wdata
    ,input  logic [(      17)-1:0] rf_aqed_fid_cnt_rdata

    ,output logic                  rf_aqed_fid_cnt_error

    ,input  logic                  func_aqed_fifo_ap_aqed_re
    ,input  logic [(       4)-1:0] func_aqed_fifo_ap_aqed_raddr
    ,input  logic [(       4)-1:0] func_aqed_fifo_ap_aqed_waddr
    ,input  logic                  func_aqed_fifo_ap_aqed_we
    ,input  logic [(      45)-1:0] func_aqed_fifo_ap_aqed_wdata
    ,output logic [(      45)-1:0] func_aqed_fifo_ap_aqed_rdata

    ,input  logic                  pf_aqed_fifo_ap_aqed_re
    ,input  logic [(       4)-1:0] pf_aqed_fifo_ap_aqed_raddr
    ,input  logic [(       4)-1:0] pf_aqed_fifo_ap_aqed_waddr
    ,input  logic                  pf_aqed_fifo_ap_aqed_we
    ,input  logic [(      45)-1:0] pf_aqed_fifo_ap_aqed_wdata
    ,output logic [(      45)-1:0] pf_aqed_fifo_ap_aqed_rdata

    ,output logic                  rf_aqed_fifo_ap_aqed_re
    ,output logic                  rf_aqed_fifo_ap_aqed_rclk
    ,output logic                  rf_aqed_fifo_ap_aqed_rclk_rst_n
    ,output logic [(       4)-1:0] rf_aqed_fifo_ap_aqed_raddr
    ,output logic [(       4)-1:0] rf_aqed_fifo_ap_aqed_waddr
    ,output logic                  rf_aqed_fifo_ap_aqed_we
    ,output logic                  rf_aqed_fifo_ap_aqed_wclk
    ,output logic                  rf_aqed_fifo_ap_aqed_wclk_rst_n
    ,output logic [(      45)-1:0] rf_aqed_fifo_ap_aqed_wdata
    ,input  logic [(      45)-1:0] rf_aqed_fifo_ap_aqed_rdata

    ,output logic                  rf_aqed_fifo_ap_aqed_error

    ,input  logic                  func_aqed_fifo_aqed_ap_enq_re
    ,input  logic [(       4)-1:0] func_aqed_fifo_aqed_ap_enq_raddr
    ,input  logic [(       4)-1:0] func_aqed_fifo_aqed_ap_enq_waddr
    ,input  logic                  func_aqed_fifo_aqed_ap_enq_we
    ,input  logic [(      24)-1:0] func_aqed_fifo_aqed_ap_enq_wdata
    ,output logic [(      24)-1:0] func_aqed_fifo_aqed_ap_enq_rdata

    ,input  logic                  pf_aqed_fifo_aqed_ap_enq_re
    ,input  logic [(       4)-1:0] pf_aqed_fifo_aqed_ap_enq_raddr
    ,input  logic [(       4)-1:0] pf_aqed_fifo_aqed_ap_enq_waddr
    ,input  logic                  pf_aqed_fifo_aqed_ap_enq_we
    ,input  logic [(      24)-1:0] pf_aqed_fifo_aqed_ap_enq_wdata
    ,output logic [(      24)-1:0] pf_aqed_fifo_aqed_ap_enq_rdata

    ,output logic                  rf_aqed_fifo_aqed_ap_enq_re
    ,output logic                  rf_aqed_fifo_aqed_ap_enq_rclk
    ,output logic                  rf_aqed_fifo_aqed_ap_enq_rclk_rst_n
    ,output logic [(       4)-1:0] rf_aqed_fifo_aqed_ap_enq_raddr
    ,output logic [(       4)-1:0] rf_aqed_fifo_aqed_ap_enq_waddr
    ,output logic                  rf_aqed_fifo_aqed_ap_enq_we
    ,output logic                  rf_aqed_fifo_aqed_ap_enq_wclk
    ,output logic                  rf_aqed_fifo_aqed_ap_enq_wclk_rst_n
    ,output logic [(      24)-1:0] rf_aqed_fifo_aqed_ap_enq_wdata
    ,input  logic [(      24)-1:0] rf_aqed_fifo_aqed_ap_enq_rdata

    ,output logic                  rf_aqed_fifo_aqed_ap_enq_error

    ,input  logic                  func_aqed_fifo_aqed_chp_sch_re
    ,input  logic [(       4)-1:0] func_aqed_fifo_aqed_chp_sch_raddr
    ,input  logic [(       4)-1:0] func_aqed_fifo_aqed_chp_sch_waddr
    ,input  logic                  func_aqed_fifo_aqed_chp_sch_we
    ,input  logic [(     180)-1:0] func_aqed_fifo_aqed_chp_sch_wdata
    ,output logic [(     180)-1:0] func_aqed_fifo_aqed_chp_sch_rdata

    ,input  logic                  pf_aqed_fifo_aqed_chp_sch_re
    ,input  logic [(       4)-1:0] pf_aqed_fifo_aqed_chp_sch_raddr
    ,input  logic [(       4)-1:0] pf_aqed_fifo_aqed_chp_sch_waddr
    ,input  logic                  pf_aqed_fifo_aqed_chp_sch_we
    ,input  logic [(     180)-1:0] pf_aqed_fifo_aqed_chp_sch_wdata
    ,output logic [(     180)-1:0] pf_aqed_fifo_aqed_chp_sch_rdata

    ,output logic                  rf_aqed_fifo_aqed_chp_sch_re
    ,output logic                  rf_aqed_fifo_aqed_chp_sch_rclk
    ,output logic                  rf_aqed_fifo_aqed_chp_sch_rclk_rst_n
    ,output logic [(       4)-1:0] rf_aqed_fifo_aqed_chp_sch_raddr
    ,output logic [(       4)-1:0] rf_aqed_fifo_aqed_chp_sch_waddr
    ,output logic                  rf_aqed_fifo_aqed_chp_sch_we
    ,output logic                  rf_aqed_fifo_aqed_chp_sch_wclk
    ,output logic                  rf_aqed_fifo_aqed_chp_sch_wclk_rst_n
    ,output logic [(     180)-1:0] rf_aqed_fifo_aqed_chp_sch_wdata
    ,input  logic [(     180)-1:0] rf_aqed_fifo_aqed_chp_sch_rdata

    ,output logic                  rf_aqed_fifo_aqed_chp_sch_error

    ,input  logic                  func_aqed_fifo_freelist_return_re
    ,input  logic [(       4)-1:0] func_aqed_fifo_freelist_return_raddr
    ,input  logic [(       4)-1:0] func_aqed_fifo_freelist_return_waddr
    ,input  logic                  func_aqed_fifo_freelist_return_we
    ,input  logic [(      32)-1:0] func_aqed_fifo_freelist_return_wdata
    ,output logic [(      32)-1:0] func_aqed_fifo_freelist_return_rdata

    ,input  logic                  pf_aqed_fifo_freelist_return_re
    ,input  logic [(       4)-1:0] pf_aqed_fifo_freelist_return_raddr
    ,input  logic [(       4)-1:0] pf_aqed_fifo_freelist_return_waddr
    ,input  logic                  pf_aqed_fifo_freelist_return_we
    ,input  logic [(      32)-1:0] pf_aqed_fifo_freelist_return_wdata
    ,output logic [(      32)-1:0] pf_aqed_fifo_freelist_return_rdata

    ,output logic                  rf_aqed_fifo_freelist_return_re
    ,output logic                  rf_aqed_fifo_freelist_return_rclk
    ,output logic                  rf_aqed_fifo_freelist_return_rclk_rst_n
    ,output logic [(       4)-1:0] rf_aqed_fifo_freelist_return_raddr
    ,output logic [(       4)-1:0] rf_aqed_fifo_freelist_return_waddr
    ,output logic                  rf_aqed_fifo_freelist_return_we
    ,output logic                  rf_aqed_fifo_freelist_return_wclk
    ,output logic                  rf_aqed_fifo_freelist_return_wclk_rst_n
    ,output logic [(      32)-1:0] rf_aqed_fifo_freelist_return_wdata
    ,input  logic [(      32)-1:0] rf_aqed_fifo_freelist_return_rdata

    ,output logic                  rf_aqed_fifo_freelist_return_error

    ,input  logic                  func_aqed_fifo_lsp_aqed_cmp_re
    ,input  logic [(       4)-1:0] func_aqed_fifo_lsp_aqed_cmp_raddr
    ,input  logic [(       4)-1:0] func_aqed_fifo_lsp_aqed_cmp_waddr
    ,input  logic                  func_aqed_fifo_lsp_aqed_cmp_we
    ,input  logic [(      35)-1:0] func_aqed_fifo_lsp_aqed_cmp_wdata
    ,output logic [(      35)-1:0] func_aqed_fifo_lsp_aqed_cmp_rdata

    ,input  logic                  pf_aqed_fifo_lsp_aqed_cmp_re
    ,input  logic [(       4)-1:0] pf_aqed_fifo_lsp_aqed_cmp_raddr
    ,input  logic [(       4)-1:0] pf_aqed_fifo_lsp_aqed_cmp_waddr
    ,input  logic                  pf_aqed_fifo_lsp_aqed_cmp_we
    ,input  logic [(      35)-1:0] pf_aqed_fifo_lsp_aqed_cmp_wdata
    ,output logic [(      35)-1:0] pf_aqed_fifo_lsp_aqed_cmp_rdata

    ,output logic                  rf_aqed_fifo_lsp_aqed_cmp_re
    ,output logic                  rf_aqed_fifo_lsp_aqed_cmp_rclk
    ,output logic                  rf_aqed_fifo_lsp_aqed_cmp_rclk_rst_n
    ,output logic [(       4)-1:0] rf_aqed_fifo_lsp_aqed_cmp_raddr
    ,output logic [(       4)-1:0] rf_aqed_fifo_lsp_aqed_cmp_waddr
    ,output logic                  rf_aqed_fifo_lsp_aqed_cmp_we
    ,output logic                  rf_aqed_fifo_lsp_aqed_cmp_wclk
    ,output logic                  rf_aqed_fifo_lsp_aqed_cmp_wclk_rst_n
    ,output logic [(      35)-1:0] rf_aqed_fifo_lsp_aqed_cmp_wdata
    ,input  logic [(      35)-1:0] rf_aqed_fifo_lsp_aqed_cmp_rdata

    ,output logic                  rf_aqed_fifo_lsp_aqed_cmp_error

    ,input  logic                  func_aqed_fifo_qed_aqed_enq_re
    ,input  logic [(       2)-1:0] func_aqed_fifo_qed_aqed_enq_raddr
    ,input  logic [(       2)-1:0] func_aqed_fifo_qed_aqed_enq_waddr
    ,input  logic                  func_aqed_fifo_qed_aqed_enq_we
    ,input  logic [(     155)-1:0] func_aqed_fifo_qed_aqed_enq_wdata
    ,output logic [(     155)-1:0] func_aqed_fifo_qed_aqed_enq_rdata

    ,input  logic                  pf_aqed_fifo_qed_aqed_enq_re
    ,input  logic [(       2)-1:0] pf_aqed_fifo_qed_aqed_enq_raddr
    ,input  logic [(       2)-1:0] pf_aqed_fifo_qed_aqed_enq_waddr
    ,input  logic                  pf_aqed_fifo_qed_aqed_enq_we
    ,input  logic [(     155)-1:0] pf_aqed_fifo_qed_aqed_enq_wdata
    ,output logic [(     155)-1:0] pf_aqed_fifo_qed_aqed_enq_rdata

    ,output logic                  rf_aqed_fifo_qed_aqed_enq_re
    ,output logic                  rf_aqed_fifo_qed_aqed_enq_rclk
    ,output logic                  rf_aqed_fifo_qed_aqed_enq_rclk_rst_n
    ,output logic [(       2)-1:0] rf_aqed_fifo_qed_aqed_enq_raddr
    ,output logic [(       2)-1:0] rf_aqed_fifo_qed_aqed_enq_waddr
    ,output logic                  rf_aqed_fifo_qed_aqed_enq_we
    ,output logic                  rf_aqed_fifo_qed_aqed_enq_wclk
    ,output logic                  rf_aqed_fifo_qed_aqed_enq_wclk_rst_n
    ,output logic [(     155)-1:0] rf_aqed_fifo_qed_aqed_enq_wdata
    ,input  logic [(     155)-1:0] rf_aqed_fifo_qed_aqed_enq_rdata

    ,output logic                  rf_aqed_fifo_qed_aqed_enq_error

    ,input  logic                  func_aqed_fifo_qed_aqed_enq_fid_re
    ,input  logic [(       3)-1:0] func_aqed_fifo_qed_aqed_enq_fid_raddr
    ,input  logic [(       3)-1:0] func_aqed_fifo_qed_aqed_enq_fid_waddr
    ,input  logic                  func_aqed_fifo_qed_aqed_enq_fid_we
    ,input  logic [(     153)-1:0] func_aqed_fifo_qed_aqed_enq_fid_wdata
    ,output logic [(     153)-1:0] func_aqed_fifo_qed_aqed_enq_fid_rdata

    ,input  logic                  pf_aqed_fifo_qed_aqed_enq_fid_re
    ,input  logic [(       3)-1:0] pf_aqed_fifo_qed_aqed_enq_fid_raddr
    ,input  logic [(       3)-1:0] pf_aqed_fifo_qed_aqed_enq_fid_waddr
    ,input  logic                  pf_aqed_fifo_qed_aqed_enq_fid_we
    ,input  logic [(     153)-1:0] pf_aqed_fifo_qed_aqed_enq_fid_wdata
    ,output logic [(     153)-1:0] pf_aqed_fifo_qed_aqed_enq_fid_rdata

    ,output logic                  rf_aqed_fifo_qed_aqed_enq_fid_re
    ,output logic                  rf_aqed_fifo_qed_aqed_enq_fid_rclk
    ,output logic                  rf_aqed_fifo_qed_aqed_enq_fid_rclk_rst_n
    ,output logic [(       3)-1:0] rf_aqed_fifo_qed_aqed_enq_fid_raddr
    ,output logic [(       3)-1:0] rf_aqed_fifo_qed_aqed_enq_fid_waddr
    ,output logic                  rf_aqed_fifo_qed_aqed_enq_fid_we
    ,output logic                  rf_aqed_fifo_qed_aqed_enq_fid_wclk
    ,output logic                  rf_aqed_fifo_qed_aqed_enq_fid_wclk_rst_n
    ,output logic [(     153)-1:0] rf_aqed_fifo_qed_aqed_enq_fid_wdata
    ,input  logic [(     153)-1:0] rf_aqed_fifo_qed_aqed_enq_fid_rdata

    ,output logic                  rf_aqed_fifo_qed_aqed_enq_fid_error

    ,input  logic                  func_aqed_ll_cnt_pri0_re
    ,input  logic [(      12)-1:0] func_aqed_ll_cnt_pri0_raddr
    ,input  logic [(      12)-1:0] func_aqed_ll_cnt_pri0_waddr
    ,input  logic                  func_aqed_ll_cnt_pri0_we
    ,input  logic [(      14)-1:0] func_aqed_ll_cnt_pri0_wdata
    ,output logic [(      14)-1:0] func_aqed_ll_cnt_pri0_rdata

    ,input  logic                  pf_aqed_ll_cnt_pri0_re
    ,input  logic [(      12)-1:0] pf_aqed_ll_cnt_pri0_raddr
    ,input  logic [(      12)-1:0] pf_aqed_ll_cnt_pri0_waddr
    ,input  logic                  pf_aqed_ll_cnt_pri0_we
    ,input  logic [(      14)-1:0] pf_aqed_ll_cnt_pri0_wdata
    ,output logic [(      14)-1:0] pf_aqed_ll_cnt_pri0_rdata

    ,output logic                  rf_aqed_ll_cnt_pri0_re
    ,output logic                  rf_aqed_ll_cnt_pri0_rclk
    ,output logic                  rf_aqed_ll_cnt_pri0_rclk_rst_n
    ,output logic [(      11)-1:0] rf_aqed_ll_cnt_pri0_raddr
    ,output logic [(      11)-1:0] rf_aqed_ll_cnt_pri0_waddr
    ,output logic                  rf_aqed_ll_cnt_pri0_we
    ,output logic                  rf_aqed_ll_cnt_pri0_wclk
    ,output logic                  rf_aqed_ll_cnt_pri0_wclk_rst_n
    ,output logic [(      16)-1:0] rf_aqed_ll_cnt_pri0_wdata
    ,input  logic [(      16)-1:0] rf_aqed_ll_cnt_pri0_rdata

    ,output logic                  rf_aqed_ll_cnt_pri0_error

    ,input  logic                  func_aqed_ll_cnt_pri1_re
    ,input  logic [(      12)-1:0] func_aqed_ll_cnt_pri1_raddr
    ,input  logic [(      12)-1:0] func_aqed_ll_cnt_pri1_waddr
    ,input  logic                  func_aqed_ll_cnt_pri1_we
    ,input  logic [(      14)-1:0] func_aqed_ll_cnt_pri1_wdata
    ,output logic [(      14)-1:0] func_aqed_ll_cnt_pri1_rdata

    ,input  logic                  pf_aqed_ll_cnt_pri1_re
    ,input  logic [(      12)-1:0] pf_aqed_ll_cnt_pri1_raddr
    ,input  logic [(      12)-1:0] pf_aqed_ll_cnt_pri1_waddr
    ,input  logic                  pf_aqed_ll_cnt_pri1_we
    ,input  logic [(      14)-1:0] pf_aqed_ll_cnt_pri1_wdata
    ,output logic [(      14)-1:0] pf_aqed_ll_cnt_pri1_rdata

    ,output logic                  rf_aqed_ll_cnt_pri1_re
    ,output logic                  rf_aqed_ll_cnt_pri1_rclk
    ,output logic                  rf_aqed_ll_cnt_pri1_rclk_rst_n
    ,output logic [(      11)-1:0] rf_aqed_ll_cnt_pri1_raddr
    ,output logic [(      11)-1:0] rf_aqed_ll_cnt_pri1_waddr
    ,output logic                  rf_aqed_ll_cnt_pri1_we
    ,output logic                  rf_aqed_ll_cnt_pri1_wclk
    ,output logic                  rf_aqed_ll_cnt_pri1_wclk_rst_n
    ,output logic [(      16)-1:0] rf_aqed_ll_cnt_pri1_wdata
    ,input  logic [(      16)-1:0] rf_aqed_ll_cnt_pri1_rdata

    ,output logic                  rf_aqed_ll_cnt_pri1_error

    ,input  logic                  func_aqed_ll_cnt_pri2_re
    ,input  logic [(      12)-1:0] func_aqed_ll_cnt_pri2_raddr
    ,input  logic [(      12)-1:0] func_aqed_ll_cnt_pri2_waddr
    ,input  logic                  func_aqed_ll_cnt_pri2_we
    ,input  logic [(      14)-1:0] func_aqed_ll_cnt_pri2_wdata
    ,output logic [(      14)-1:0] func_aqed_ll_cnt_pri2_rdata

    ,input  logic                  pf_aqed_ll_cnt_pri2_re
    ,input  logic [(      12)-1:0] pf_aqed_ll_cnt_pri2_raddr
    ,input  logic [(      12)-1:0] pf_aqed_ll_cnt_pri2_waddr
    ,input  logic                  pf_aqed_ll_cnt_pri2_we
    ,input  logic [(      14)-1:0] pf_aqed_ll_cnt_pri2_wdata
    ,output logic [(      14)-1:0] pf_aqed_ll_cnt_pri2_rdata

    ,output logic                  rf_aqed_ll_cnt_pri2_re
    ,output logic                  rf_aqed_ll_cnt_pri2_rclk
    ,output logic                  rf_aqed_ll_cnt_pri2_rclk_rst_n
    ,output logic [(      11)-1:0] rf_aqed_ll_cnt_pri2_raddr
    ,output logic [(      11)-1:0] rf_aqed_ll_cnt_pri2_waddr
    ,output logic                  rf_aqed_ll_cnt_pri2_we
    ,output logic                  rf_aqed_ll_cnt_pri2_wclk
    ,output logic                  rf_aqed_ll_cnt_pri2_wclk_rst_n
    ,output logic [(      16)-1:0] rf_aqed_ll_cnt_pri2_wdata
    ,input  logic [(      16)-1:0] rf_aqed_ll_cnt_pri2_rdata

    ,output logic                  rf_aqed_ll_cnt_pri2_error

    ,input  logic                  func_aqed_ll_cnt_pri3_re
    ,input  logic [(      12)-1:0] func_aqed_ll_cnt_pri3_raddr
    ,input  logic [(      12)-1:0] func_aqed_ll_cnt_pri3_waddr
    ,input  logic                  func_aqed_ll_cnt_pri3_we
    ,input  logic [(      14)-1:0] func_aqed_ll_cnt_pri3_wdata
    ,output logic [(      14)-1:0] func_aqed_ll_cnt_pri3_rdata

    ,input  logic                  pf_aqed_ll_cnt_pri3_re
    ,input  logic [(      12)-1:0] pf_aqed_ll_cnt_pri3_raddr
    ,input  logic [(      12)-1:0] pf_aqed_ll_cnt_pri3_waddr
    ,input  logic                  pf_aqed_ll_cnt_pri3_we
    ,input  logic [(      14)-1:0] pf_aqed_ll_cnt_pri3_wdata
    ,output logic [(      14)-1:0] pf_aqed_ll_cnt_pri3_rdata

    ,output logic                  rf_aqed_ll_cnt_pri3_re
    ,output logic                  rf_aqed_ll_cnt_pri3_rclk
    ,output logic                  rf_aqed_ll_cnt_pri3_rclk_rst_n
    ,output logic [(      11)-1:0] rf_aqed_ll_cnt_pri3_raddr
    ,output logic [(      11)-1:0] rf_aqed_ll_cnt_pri3_waddr
    ,output logic                  rf_aqed_ll_cnt_pri3_we
    ,output logic                  rf_aqed_ll_cnt_pri3_wclk
    ,output logic                  rf_aqed_ll_cnt_pri3_wclk_rst_n
    ,output logic [(      16)-1:0] rf_aqed_ll_cnt_pri3_wdata
    ,input  logic [(      16)-1:0] rf_aqed_ll_cnt_pri3_rdata

    ,output logic                  rf_aqed_ll_cnt_pri3_error

    ,input  logic                  func_aqed_ll_qe_hp_pri0_re
    ,input  logic [(      12)-1:0] func_aqed_ll_qe_hp_pri0_raddr
    ,input  logic [(      12)-1:0] func_aqed_ll_qe_hp_pri0_waddr
    ,input  logic                  func_aqed_ll_qe_hp_pri0_we
    ,input  logic [(      12)-1:0] func_aqed_ll_qe_hp_pri0_wdata
    ,output logic [(      12)-1:0] func_aqed_ll_qe_hp_pri0_rdata

    ,input  logic                  pf_aqed_ll_qe_hp_pri0_re
    ,input  logic [(      12)-1:0] pf_aqed_ll_qe_hp_pri0_raddr
    ,input  logic [(      12)-1:0] pf_aqed_ll_qe_hp_pri0_waddr
    ,input  logic                  pf_aqed_ll_qe_hp_pri0_we
    ,input  logic [(      12)-1:0] pf_aqed_ll_qe_hp_pri0_wdata
    ,output logic [(      12)-1:0] pf_aqed_ll_qe_hp_pri0_rdata

    ,output logic                  rf_aqed_ll_qe_hp_pri0_re
    ,output logic                  rf_aqed_ll_qe_hp_pri0_rclk
    ,output logic                  rf_aqed_ll_qe_hp_pri0_rclk_rst_n
    ,output logic [(      11)-1:0] rf_aqed_ll_qe_hp_pri0_raddr
    ,output logic [(      11)-1:0] rf_aqed_ll_qe_hp_pri0_waddr
    ,output logic                  rf_aqed_ll_qe_hp_pri0_we
    ,output logic                  rf_aqed_ll_qe_hp_pri0_wclk
    ,output logic                  rf_aqed_ll_qe_hp_pri0_wclk_rst_n
    ,output logic [(      14)-1:0] rf_aqed_ll_qe_hp_pri0_wdata
    ,input  logic [(      14)-1:0] rf_aqed_ll_qe_hp_pri0_rdata

    ,output logic                  rf_aqed_ll_qe_hp_pri0_error

    ,input  logic                  func_aqed_ll_qe_hp_pri1_re
    ,input  logic [(      12)-1:0] func_aqed_ll_qe_hp_pri1_raddr
    ,input  logic [(      12)-1:0] func_aqed_ll_qe_hp_pri1_waddr
    ,input  logic                  func_aqed_ll_qe_hp_pri1_we
    ,input  logic [(      12)-1:0] func_aqed_ll_qe_hp_pri1_wdata
    ,output logic [(      12)-1:0] func_aqed_ll_qe_hp_pri1_rdata

    ,input  logic                  pf_aqed_ll_qe_hp_pri1_re
    ,input  logic [(      12)-1:0] pf_aqed_ll_qe_hp_pri1_raddr
    ,input  logic [(      12)-1:0] pf_aqed_ll_qe_hp_pri1_waddr
    ,input  logic                  pf_aqed_ll_qe_hp_pri1_we
    ,input  logic [(      12)-1:0] pf_aqed_ll_qe_hp_pri1_wdata
    ,output logic [(      12)-1:0] pf_aqed_ll_qe_hp_pri1_rdata

    ,output logic                  rf_aqed_ll_qe_hp_pri1_re
    ,output logic                  rf_aqed_ll_qe_hp_pri1_rclk
    ,output logic                  rf_aqed_ll_qe_hp_pri1_rclk_rst_n
    ,output logic [(      11)-1:0] rf_aqed_ll_qe_hp_pri1_raddr
    ,output logic [(      11)-1:0] rf_aqed_ll_qe_hp_pri1_waddr
    ,output logic                  rf_aqed_ll_qe_hp_pri1_we
    ,output logic                  rf_aqed_ll_qe_hp_pri1_wclk
    ,output logic                  rf_aqed_ll_qe_hp_pri1_wclk_rst_n
    ,output logic [(      14)-1:0] rf_aqed_ll_qe_hp_pri1_wdata
    ,input  logic [(      14)-1:0] rf_aqed_ll_qe_hp_pri1_rdata

    ,output logic                  rf_aqed_ll_qe_hp_pri1_error

    ,input  logic                  func_aqed_ll_qe_hp_pri2_re
    ,input  logic [(      12)-1:0] func_aqed_ll_qe_hp_pri2_raddr
    ,input  logic [(      12)-1:0] func_aqed_ll_qe_hp_pri2_waddr
    ,input  logic                  func_aqed_ll_qe_hp_pri2_we
    ,input  logic [(      12)-1:0] func_aqed_ll_qe_hp_pri2_wdata
    ,output logic [(      12)-1:0] func_aqed_ll_qe_hp_pri2_rdata

    ,input  logic                  pf_aqed_ll_qe_hp_pri2_re
    ,input  logic [(      12)-1:0] pf_aqed_ll_qe_hp_pri2_raddr
    ,input  logic [(      12)-1:0] pf_aqed_ll_qe_hp_pri2_waddr
    ,input  logic                  pf_aqed_ll_qe_hp_pri2_we
    ,input  logic [(      12)-1:0] pf_aqed_ll_qe_hp_pri2_wdata
    ,output logic [(      12)-1:0] pf_aqed_ll_qe_hp_pri2_rdata

    ,output logic                  rf_aqed_ll_qe_hp_pri2_re
    ,output logic                  rf_aqed_ll_qe_hp_pri2_rclk
    ,output logic                  rf_aqed_ll_qe_hp_pri2_rclk_rst_n
    ,output logic [(      11)-1:0] rf_aqed_ll_qe_hp_pri2_raddr
    ,output logic [(      11)-1:0] rf_aqed_ll_qe_hp_pri2_waddr
    ,output logic                  rf_aqed_ll_qe_hp_pri2_we
    ,output logic                  rf_aqed_ll_qe_hp_pri2_wclk
    ,output logic                  rf_aqed_ll_qe_hp_pri2_wclk_rst_n
    ,output logic [(      14)-1:0] rf_aqed_ll_qe_hp_pri2_wdata
    ,input  logic [(      14)-1:0] rf_aqed_ll_qe_hp_pri2_rdata

    ,output logic                  rf_aqed_ll_qe_hp_pri2_error

    ,input  logic                  func_aqed_ll_qe_hp_pri3_re
    ,input  logic [(      12)-1:0] func_aqed_ll_qe_hp_pri3_raddr
    ,input  logic [(      12)-1:0] func_aqed_ll_qe_hp_pri3_waddr
    ,input  logic                  func_aqed_ll_qe_hp_pri3_we
    ,input  logic [(      12)-1:0] func_aqed_ll_qe_hp_pri3_wdata
    ,output logic [(      12)-1:0] func_aqed_ll_qe_hp_pri3_rdata

    ,input  logic                  pf_aqed_ll_qe_hp_pri3_re
    ,input  logic [(      12)-1:0] pf_aqed_ll_qe_hp_pri3_raddr
    ,input  logic [(      12)-1:0] pf_aqed_ll_qe_hp_pri3_waddr
    ,input  logic                  pf_aqed_ll_qe_hp_pri3_we
    ,input  logic [(      12)-1:0] pf_aqed_ll_qe_hp_pri3_wdata
    ,output logic [(      12)-1:0] pf_aqed_ll_qe_hp_pri3_rdata

    ,output logic                  rf_aqed_ll_qe_hp_pri3_re
    ,output logic                  rf_aqed_ll_qe_hp_pri3_rclk
    ,output logic                  rf_aqed_ll_qe_hp_pri3_rclk_rst_n
    ,output logic [(      11)-1:0] rf_aqed_ll_qe_hp_pri3_raddr
    ,output logic [(      11)-1:0] rf_aqed_ll_qe_hp_pri3_waddr
    ,output logic                  rf_aqed_ll_qe_hp_pri3_we
    ,output logic                  rf_aqed_ll_qe_hp_pri3_wclk
    ,output logic                  rf_aqed_ll_qe_hp_pri3_wclk_rst_n
    ,output logic [(      14)-1:0] rf_aqed_ll_qe_hp_pri3_wdata
    ,input  logic [(      14)-1:0] rf_aqed_ll_qe_hp_pri3_rdata

    ,output logic                  rf_aqed_ll_qe_hp_pri3_error

    ,input  logic                  func_aqed_ll_qe_tp_pri0_re
    ,input  logic [(      12)-1:0] func_aqed_ll_qe_tp_pri0_raddr
    ,input  logic [(      12)-1:0] func_aqed_ll_qe_tp_pri0_waddr
    ,input  logic                  func_aqed_ll_qe_tp_pri0_we
    ,input  logic [(      12)-1:0] func_aqed_ll_qe_tp_pri0_wdata
    ,output logic [(      12)-1:0] func_aqed_ll_qe_tp_pri0_rdata

    ,input  logic                  pf_aqed_ll_qe_tp_pri0_re
    ,input  logic [(      12)-1:0] pf_aqed_ll_qe_tp_pri0_raddr
    ,input  logic [(      12)-1:0] pf_aqed_ll_qe_tp_pri0_waddr
    ,input  logic                  pf_aqed_ll_qe_tp_pri0_we
    ,input  logic [(      12)-1:0] pf_aqed_ll_qe_tp_pri0_wdata
    ,output logic [(      12)-1:0] pf_aqed_ll_qe_tp_pri0_rdata

    ,output logic                  rf_aqed_ll_qe_tp_pri0_re
    ,output logic                  rf_aqed_ll_qe_tp_pri0_rclk
    ,output logic                  rf_aqed_ll_qe_tp_pri0_rclk_rst_n
    ,output logic [(      11)-1:0] rf_aqed_ll_qe_tp_pri0_raddr
    ,output logic [(      11)-1:0] rf_aqed_ll_qe_tp_pri0_waddr
    ,output logic                  rf_aqed_ll_qe_tp_pri0_we
    ,output logic                  rf_aqed_ll_qe_tp_pri0_wclk
    ,output logic                  rf_aqed_ll_qe_tp_pri0_wclk_rst_n
    ,output logic [(      14)-1:0] rf_aqed_ll_qe_tp_pri0_wdata
    ,input  logic [(      14)-1:0] rf_aqed_ll_qe_tp_pri0_rdata

    ,output logic                  rf_aqed_ll_qe_tp_pri0_error

    ,input  logic                  func_aqed_ll_qe_tp_pri1_re
    ,input  logic [(      12)-1:0] func_aqed_ll_qe_tp_pri1_raddr
    ,input  logic [(      12)-1:0] func_aqed_ll_qe_tp_pri1_waddr
    ,input  logic                  func_aqed_ll_qe_tp_pri1_we
    ,input  logic [(      12)-1:0] func_aqed_ll_qe_tp_pri1_wdata
    ,output logic [(      12)-1:0] func_aqed_ll_qe_tp_pri1_rdata

    ,input  logic                  pf_aqed_ll_qe_tp_pri1_re
    ,input  logic [(      12)-1:0] pf_aqed_ll_qe_tp_pri1_raddr
    ,input  logic [(      12)-1:0] pf_aqed_ll_qe_tp_pri1_waddr
    ,input  logic                  pf_aqed_ll_qe_tp_pri1_we
    ,input  logic [(      12)-1:0] pf_aqed_ll_qe_tp_pri1_wdata
    ,output logic [(      12)-1:0] pf_aqed_ll_qe_tp_pri1_rdata

    ,output logic                  rf_aqed_ll_qe_tp_pri1_re
    ,output logic                  rf_aqed_ll_qe_tp_pri1_rclk
    ,output logic                  rf_aqed_ll_qe_tp_pri1_rclk_rst_n
    ,output logic [(      11)-1:0] rf_aqed_ll_qe_tp_pri1_raddr
    ,output logic [(      11)-1:0] rf_aqed_ll_qe_tp_pri1_waddr
    ,output logic                  rf_aqed_ll_qe_tp_pri1_we
    ,output logic                  rf_aqed_ll_qe_tp_pri1_wclk
    ,output logic                  rf_aqed_ll_qe_tp_pri1_wclk_rst_n
    ,output logic [(      14)-1:0] rf_aqed_ll_qe_tp_pri1_wdata
    ,input  logic [(      14)-1:0] rf_aqed_ll_qe_tp_pri1_rdata

    ,output logic                  rf_aqed_ll_qe_tp_pri1_error

    ,input  logic                  func_aqed_ll_qe_tp_pri2_re
    ,input  logic [(      12)-1:0] func_aqed_ll_qe_tp_pri2_raddr
    ,input  logic [(      12)-1:0] func_aqed_ll_qe_tp_pri2_waddr
    ,input  logic                  func_aqed_ll_qe_tp_pri2_we
    ,input  logic [(      12)-1:0] func_aqed_ll_qe_tp_pri2_wdata
    ,output logic [(      12)-1:0] func_aqed_ll_qe_tp_pri2_rdata

    ,input  logic                  pf_aqed_ll_qe_tp_pri2_re
    ,input  logic [(      12)-1:0] pf_aqed_ll_qe_tp_pri2_raddr
    ,input  logic [(      12)-1:0] pf_aqed_ll_qe_tp_pri2_waddr
    ,input  logic                  pf_aqed_ll_qe_tp_pri2_we
    ,input  logic [(      12)-1:0] pf_aqed_ll_qe_tp_pri2_wdata
    ,output logic [(      12)-1:0] pf_aqed_ll_qe_tp_pri2_rdata

    ,output logic                  rf_aqed_ll_qe_tp_pri2_re
    ,output logic                  rf_aqed_ll_qe_tp_pri2_rclk
    ,output logic                  rf_aqed_ll_qe_tp_pri2_rclk_rst_n
    ,output logic [(      11)-1:0] rf_aqed_ll_qe_tp_pri2_raddr
    ,output logic [(      11)-1:0] rf_aqed_ll_qe_tp_pri2_waddr
    ,output logic                  rf_aqed_ll_qe_tp_pri2_we
    ,output logic                  rf_aqed_ll_qe_tp_pri2_wclk
    ,output logic                  rf_aqed_ll_qe_tp_pri2_wclk_rst_n
    ,output logic [(      14)-1:0] rf_aqed_ll_qe_tp_pri2_wdata
    ,input  logic [(      14)-1:0] rf_aqed_ll_qe_tp_pri2_rdata

    ,output logic                  rf_aqed_ll_qe_tp_pri2_error

    ,input  logic                  func_aqed_ll_qe_tp_pri3_re
    ,input  logic [(      12)-1:0] func_aqed_ll_qe_tp_pri3_raddr
    ,input  logic [(      12)-1:0] func_aqed_ll_qe_tp_pri3_waddr
    ,input  logic                  func_aqed_ll_qe_tp_pri3_we
    ,input  logic [(      12)-1:0] func_aqed_ll_qe_tp_pri3_wdata
    ,output logic [(      12)-1:0] func_aqed_ll_qe_tp_pri3_rdata

    ,input  logic                  pf_aqed_ll_qe_tp_pri3_re
    ,input  logic [(      12)-1:0] pf_aqed_ll_qe_tp_pri3_raddr
    ,input  logic [(      12)-1:0] pf_aqed_ll_qe_tp_pri3_waddr
    ,input  logic                  pf_aqed_ll_qe_tp_pri3_we
    ,input  logic [(      12)-1:0] pf_aqed_ll_qe_tp_pri3_wdata
    ,output logic [(      12)-1:0] pf_aqed_ll_qe_tp_pri3_rdata

    ,output logic                  rf_aqed_ll_qe_tp_pri3_re
    ,output logic                  rf_aqed_ll_qe_tp_pri3_rclk
    ,output logic                  rf_aqed_ll_qe_tp_pri3_rclk_rst_n
    ,output logic [(      11)-1:0] rf_aqed_ll_qe_tp_pri3_raddr
    ,output logic [(      11)-1:0] rf_aqed_ll_qe_tp_pri3_waddr
    ,output logic                  rf_aqed_ll_qe_tp_pri3_we
    ,output logic                  rf_aqed_ll_qe_tp_pri3_wclk
    ,output logic                  rf_aqed_ll_qe_tp_pri3_wclk_rst_n
    ,output logic [(      14)-1:0] rf_aqed_ll_qe_tp_pri3_wdata
    ,input  logic [(      14)-1:0] rf_aqed_ll_qe_tp_pri3_rdata

    ,output logic                  rf_aqed_ll_qe_tp_pri3_error

    ,input  logic                  func_aqed_qid_cnt_re
    ,input  logic [(       7)-1:0] func_aqed_qid_cnt_raddr
    ,input  logic [(       7)-1:0] func_aqed_qid_cnt_waddr
    ,input  logic                  func_aqed_qid_cnt_we
    ,input  logic [(      15)-1:0] func_aqed_qid_cnt_wdata
    ,output logic [(      15)-1:0] func_aqed_qid_cnt_rdata

    ,input  logic                  pf_aqed_qid_cnt_re
    ,input  logic [(       7)-1:0] pf_aqed_qid_cnt_raddr
    ,input  logic [(       7)-1:0] pf_aqed_qid_cnt_waddr
    ,input  logic                  pf_aqed_qid_cnt_we
    ,input  logic [(      15)-1:0] pf_aqed_qid_cnt_wdata
    ,output logic [(      15)-1:0] pf_aqed_qid_cnt_rdata

    ,output logic                  rf_aqed_qid_cnt_re
    ,output logic                  rf_aqed_qid_cnt_rclk
    ,output logic                  rf_aqed_qid_cnt_rclk_rst_n
    ,output logic [(       5)-1:0] rf_aqed_qid_cnt_raddr
    ,output logic [(       5)-1:0] rf_aqed_qid_cnt_waddr
    ,output logic                  rf_aqed_qid_cnt_we
    ,output logic                  rf_aqed_qid_cnt_wclk
    ,output logic                  rf_aqed_qid_cnt_wclk_rst_n
    ,output logic [(      15)-1:0] rf_aqed_qid_cnt_wdata
    ,input  logic [(      15)-1:0] rf_aqed_qid_cnt_rdata

    ,output logic                  rf_aqed_qid_cnt_error

    ,input  logic                  func_aqed_qid_fid_limit_re
    ,input  logic [(       7)-1:0] func_aqed_qid_fid_limit_addr
    ,input  logic                  func_aqed_qid_fid_limit_we
    ,input  logic [(      14)-1:0] func_aqed_qid_fid_limit_wdata
    ,output logic [(      14)-1:0] func_aqed_qid_fid_limit_rdata

    ,input  logic                  pf_aqed_qid_fid_limit_re
    ,input  logic [(       7)-1:0] pf_aqed_qid_fid_limit_addr
    ,input  logic                  pf_aqed_qid_fid_limit_we
    ,input  logic [(      14)-1:0] pf_aqed_qid_fid_limit_wdata
    ,output logic [(      14)-1:0] pf_aqed_qid_fid_limit_rdata

    ,output logic                  rf_aqed_qid_fid_limit_re
    ,output logic                  rf_aqed_qid_fid_limit_rclk
    ,output logic                  rf_aqed_qid_fid_limit_rclk_rst_n
    ,output logic [(       5)-1:0] rf_aqed_qid_fid_limit_raddr
    ,output logic [(       5)-1:0] rf_aqed_qid_fid_limit_waddr
    ,output logic                  rf_aqed_qid_fid_limit_we
    ,output logic                  rf_aqed_qid_fid_limit_wclk
    ,output logic                  rf_aqed_qid_fid_limit_wclk_rst_n
    ,output logic [(      14)-1:0] rf_aqed_qid_fid_limit_wdata
    ,input  logic [(      14)-1:0] rf_aqed_qid_fid_limit_rdata

    ,output logic                  rf_aqed_qid_fid_limit_error

    ,input  logic                  func_rx_sync_qed_aqed_enq_re
    ,input  logic [(       2)-1:0] func_rx_sync_qed_aqed_enq_raddr
    ,input  logic [(       2)-1:0] func_rx_sync_qed_aqed_enq_waddr
    ,input  logic                  func_rx_sync_qed_aqed_enq_we
    ,input  logic [(     139)-1:0] func_rx_sync_qed_aqed_enq_wdata
    ,output logic [(     139)-1:0] func_rx_sync_qed_aqed_enq_rdata

    ,input  logic                  pf_rx_sync_qed_aqed_enq_re
    ,input  logic [(       2)-1:0] pf_rx_sync_qed_aqed_enq_raddr
    ,input  logic [(       2)-1:0] pf_rx_sync_qed_aqed_enq_waddr
    ,input  logic                  pf_rx_sync_qed_aqed_enq_we
    ,input  logic [(     139)-1:0] pf_rx_sync_qed_aqed_enq_wdata
    ,output logic [(     139)-1:0] pf_rx_sync_qed_aqed_enq_rdata

    ,output logic                  rf_rx_sync_qed_aqed_enq_re
    ,output logic                  rf_rx_sync_qed_aqed_enq_rclk
    ,output logic                  rf_rx_sync_qed_aqed_enq_rclk_rst_n
    ,output logic [(       2)-1:0] rf_rx_sync_qed_aqed_enq_raddr
    ,output logic [(       2)-1:0] rf_rx_sync_qed_aqed_enq_waddr
    ,output logic                  rf_rx_sync_qed_aqed_enq_we
    ,output logic                  rf_rx_sync_qed_aqed_enq_wclk
    ,output logic                  rf_rx_sync_qed_aqed_enq_wclk_rst_n
    ,output logic [(     139)-1:0] rf_rx_sync_qed_aqed_enq_wdata
    ,input  logic [(     139)-1:0] rf_rx_sync_qed_aqed_enq_rdata

    ,output logic                  rf_rx_sync_qed_aqed_enq_error

    ,input  logic                  func_aqed_re
    ,input  logic [(      11)-1:0] func_aqed_addr
    ,input  logic                  func_aqed_we
    ,input  logic [(     139)-1:0] func_aqed_wdata
    ,output logic [(     139)-1:0] func_aqed_rdata

    ,input  logic                  pf_aqed_re
    ,input  logic [(      11)-1:0] pf_aqed_addr
    ,input  logic                  pf_aqed_we
    ,input  logic [(     139)-1:0] pf_aqed_wdata
    ,output logic [(     139)-1:0] pf_aqed_rdata

    ,output logic                  sr_aqed_re
    ,output logic                  sr_aqed_clk
    ,output logic                  sr_aqed_clk_rst_n
    ,output logic [(      11)-1:0] sr_aqed_addr
    ,output logic                  sr_aqed_we
    ,output logic [(     139)-1:0] sr_aqed_wdata
    ,input  logic [(     139)-1:0] sr_aqed_rdata

    ,output logic                  sr_aqed_error

    ,input  logic                  func_aqed_freelist_re
    ,input  logic [(      11)-1:0] func_aqed_freelist_addr
    ,input  logic                  func_aqed_freelist_we
    ,input  logic [(      16)-1:0] func_aqed_freelist_wdata
    ,output logic [(      16)-1:0] func_aqed_freelist_rdata

    ,input  logic                  pf_aqed_freelist_re
    ,input  logic [(      11)-1:0] pf_aqed_freelist_addr
    ,input  logic                  pf_aqed_freelist_we
    ,input  logic [(      16)-1:0] pf_aqed_freelist_wdata
    ,output logic [(      16)-1:0] pf_aqed_freelist_rdata

    ,output logic                  sr_aqed_freelist_re
    ,output logic                  sr_aqed_freelist_clk
    ,output logic                  sr_aqed_freelist_clk_rst_n
    ,output logic [(      11)-1:0] sr_aqed_freelist_addr
    ,output logic                  sr_aqed_freelist_we
    ,output logic [(      16)-1:0] sr_aqed_freelist_wdata
    ,input  logic [(      16)-1:0] sr_aqed_freelist_rdata

    ,output logic                  sr_aqed_freelist_error

    ,input  logic                  func_aqed_ll_qe_hpnxt_re
    ,input  logic [(      11)-1:0] func_aqed_ll_qe_hpnxt_addr
    ,input  logic                  func_aqed_ll_qe_hpnxt_we
    ,input  logic [(      16)-1:0] func_aqed_ll_qe_hpnxt_wdata
    ,output logic [(      16)-1:0] func_aqed_ll_qe_hpnxt_rdata

    ,input  logic                  pf_aqed_ll_qe_hpnxt_re
    ,input  logic [(      11)-1:0] pf_aqed_ll_qe_hpnxt_addr
    ,input  logic                  pf_aqed_ll_qe_hpnxt_we
    ,input  logic [(      16)-1:0] pf_aqed_ll_qe_hpnxt_wdata
    ,output logic [(      16)-1:0] pf_aqed_ll_qe_hpnxt_rdata

    ,output logic                  sr_aqed_ll_qe_hpnxt_re
    ,output logic                  sr_aqed_ll_qe_hpnxt_clk
    ,output logic                  sr_aqed_ll_qe_hpnxt_clk_rst_n
    ,output logic [(      11)-1:0] sr_aqed_ll_qe_hpnxt_addr
    ,output logic                  sr_aqed_ll_qe_hpnxt_we
    ,output logic [(      16)-1:0] sr_aqed_ll_qe_hpnxt_wdata
    ,input  logic [(      16)-1:0] sr_aqed_ll_qe_hpnxt_rdata

    ,output logic                  sr_aqed_ll_qe_hpnxt_error

);

hqm_AW_bcam_access #( 
         .NUM                          (8)
        ,.DEPTH                        (256)
        ,.DWIDTH                       (26)
) i_AW_bcam_2048x26 ( 
         .clk                          (hqm_gated_clk)
        ,.clk_pre_rcb_lcb              (clk_pre_rcb_lcb)
        ,.rst_n                        (hqm_gated_rst_n)
        ,.hqm_fullrate_clk             (hqm_fullrate_clk)
        ,.hqm_clk_rptr_rst_sync_b      (hqm_clk_rptr_rst_sync_b)
        ,.hqm_gatedclk_enable_and      (hqm_gatedclk_enable_and)
        ,.hqm_clk_ungate               (hqm_clk_ungate)

        ,.cfg_mem_re                   (cfg_mem_re[(2 * 1) +: 1])
        ,.cfg_mem_we                   (cfg_mem_we[(2 * 1) +: 1])
        ,.cfg_mem_addr                 (cfg_mem_addr)
        ,.cfg_mem_minbit               (cfg_mem_minbit)
        ,.cfg_mem_maxbit               (cfg_mem_maxbit)
        ,.cfg_mem_wdata                (cfg_mem_wdata)
        ,.cfg_mem_rdata                (cfg_mem_rdata[(2 * 32 ) +: 32])
        ,.cfg_mem_ack                  (cfg_mem_ack[  (2 *  1 ) +:  1])
        ,.cfg_mem_cc_v                 (cfg_mem_cc_v)
        ,.cfg_mem_cc_value             (cfg_mem_cc_value)
        ,.cfg_mem_cc_width             (cfg_mem_cc_width)
        ,.cfg_mem_cc_position          (cfg_mem_cc_position)

        ,.func_FUNC_WEN_RF_IN_P0       (func_FUNC_WEN_RF_IN_P0)
        ,.func_FUNC_WR_ADDR_RF_IN_P0   (func_FUNC_WR_ADDR_RF_IN_P0)
        ,.func_FUNC_WR_DATA_RF_IN_P0   (func_FUNC_WR_DATA_RF_IN_P0)
        ,.func_FUNC_CEN_RF_IN_P0       (func_FUNC_CEN_RF_IN_P0)
        ,.func_FUNC_CM_DATA_RF_IN_P0   (func_FUNC_CM_DATA_RF_IN_P0)
        ,.func_CM_MATCH_RF_OUT_P0      (func_CM_MATCH_RF_OUT_P0)
        ,.func_FUNC_REN_RF_IN_P0       (func_FUNC_REN_RF_IN_P0)
        ,.func_FUNC_RD_ADDR_RF_IN_P0   (func_FUNC_RD_ADDR_RF_IN_P0)
        ,.func_DATA_RF_OUT_P0          (func_DATA_RF_OUT_P0)

        ,.pf_FUNC_WEN_RF_IN_P0         (pf_FUNC_WEN_RF_IN_P0)
        ,.pf_FUNC_WR_ADDR_RF_IN_P0     (pf_FUNC_WR_ADDR_RF_IN_P0)
        ,.pf_FUNC_WR_DATA_RF_IN_P0     (pf_FUNC_WR_DATA_RF_IN_P0)
        ,.pf_FUNC_CEN_RF_IN_P0         (pf_FUNC_CEN_RF_IN_P0)
        ,.pf_FUNC_CM_DATA_RF_IN_P0     (pf_FUNC_CM_DATA_RF_IN_P0)
        ,.pf_CM_MATCH_RF_OUT_P0        (pf_CM_MATCH_RF_OUT_P0)
        ,.pf_FUNC_REN_RF_IN_P0         (pf_FUNC_REN_RF_IN_P0)
        ,.pf_FUNC_RD_ADDR_RF_IN_P0     (pf_FUNC_RD_ADDR_RF_IN_P0)
        ,.pf_DATA_RF_OUT_P0            (pf_DATA_RF_OUT_P0)

        ,.bcam_AW_bcam_2048x26_wclk    (bcam_AW_bcam_2048x26_wclk)
        ,.bcam_AW_bcam_2048x26_rclk    (bcam_AW_bcam_2048x26_rclk)
        ,.bcam_AW_bcam_2048x26_cclk    (bcam_AW_bcam_2048x26_cclk)
        ,.bcam_AW_bcam_2048x26_dfx_clk (bcam_AW_bcam_2048x26_dfx_clk)
        ,.bcam_AW_bcam_2048x26_we      (bcam_AW_bcam_2048x26_we)
        ,.bcam_AW_bcam_2048x26_waddr   (bcam_AW_bcam_2048x26_waddr)
        ,.bcam_AW_bcam_2048x26_wdata   (bcam_AW_bcam_2048x26_wdata)
        ,.bcam_AW_bcam_2048x26_ce      (bcam_AW_bcam_2048x26_ce)
        ,.bcam_AW_bcam_2048x26_cdata   (bcam_AW_bcam_2048x26_cdata)
        ,.bcam_AW_bcam_2048x26_cmatch  (bcam_AW_bcam_2048x26_cmatch)
        ,.bcam_AW_bcam_2048x26_re      (bcam_AW_bcam_2048x26_re)
        ,.bcam_AW_bcam_2048x26_raddr   (bcam_AW_bcam_2048x26_raddr)
        ,.bcam_AW_bcam_2048x26_rdata   (bcam_AW_bcam_2048x26_rdata)

        ,.error                        (AW_bcam_2048x26_error)
);

logic [(       1)-1:0] rf_aqed_fid_cnt_raddr_nc ;
logic [(       1)-1:0] rf_aqed_fid_cnt_waddr_nc ;

logic        rf_aqed_fid_cnt_rdata_error;

logic        cfg_mem_ack_aqed_fid_cnt_nc;
logic [31:0] cfg_mem_rdata_aqed_fid_cnt_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (15)
        ,.AWIDTHPAD           (1)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (2)
) i_aqed_fid_cnt (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_aqed_fid_cnt_re)
        ,.func_mem_raddr      (func_aqed_fid_cnt_raddr)
        ,.func_mem_waddr      (func_aqed_fid_cnt_waddr)
        ,.func_mem_we         (func_aqed_fid_cnt_we)
        ,.func_mem_wdata      (func_aqed_fid_cnt_wdata)
        ,.func_mem_rdata      (func_aqed_fid_cnt_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_aqed_fid_cnt_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_aqed_fid_cnt_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_aqed_fid_cnt_re)
        ,.pf_mem_raddr        (pf_aqed_fid_cnt_raddr)
        ,.pf_mem_waddr        (pf_aqed_fid_cnt_waddr)
        ,.pf_mem_we           (pf_aqed_fid_cnt_we)
        ,.pf_mem_wdata        (pf_aqed_fid_cnt_wdata)
        ,.pf_mem_rdata        (pf_aqed_fid_cnt_rdata)

        ,.mem_wclk            (rf_aqed_fid_cnt_wclk)
        ,.mem_rclk            (rf_aqed_fid_cnt_rclk)
        ,.mem_wclk_rst_n      (rf_aqed_fid_cnt_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_aqed_fid_cnt_rclk_rst_n)
        ,.mem_re              (rf_aqed_fid_cnt_re)
        ,.mem_raddr           ({rf_aqed_fid_cnt_raddr_nc , rf_aqed_fid_cnt_raddr})
        ,.mem_waddr           ({rf_aqed_fid_cnt_waddr_nc , rf_aqed_fid_cnt_waddr})
        ,.mem_we              (rf_aqed_fid_cnt_we)
        ,.mem_wdata           (rf_aqed_fid_cnt_wdata)
        ,.mem_rdata           (rf_aqed_fid_cnt_rdata)

        ,.mem_rdata_error     (rf_aqed_fid_cnt_rdata_error)
        ,.error               (rf_aqed_fid_cnt_error)
);

logic        rf_aqed_fifo_ap_aqed_rdata_error;

logic        cfg_mem_ack_aqed_fifo_ap_aqed_nc;
logic [31:0] cfg_mem_rdata_aqed_fifo_ap_aqed_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (16)
        ,.DWIDTH              (45)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_aqed_fifo_ap_aqed (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_aqed_fifo_ap_aqed_re)
        ,.func_mem_raddr      (func_aqed_fifo_ap_aqed_raddr)
        ,.func_mem_waddr      (func_aqed_fifo_ap_aqed_waddr)
        ,.func_mem_we         (func_aqed_fifo_ap_aqed_we)
        ,.func_mem_wdata      (func_aqed_fifo_ap_aqed_wdata)
        ,.func_mem_rdata      (func_aqed_fifo_ap_aqed_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_aqed_fifo_ap_aqed_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_aqed_fifo_ap_aqed_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_aqed_fifo_ap_aqed_re)
        ,.pf_mem_raddr        (pf_aqed_fifo_ap_aqed_raddr)
        ,.pf_mem_waddr        (pf_aqed_fifo_ap_aqed_waddr)
        ,.pf_mem_we           (pf_aqed_fifo_ap_aqed_we)
        ,.pf_mem_wdata        (pf_aqed_fifo_ap_aqed_wdata)
        ,.pf_mem_rdata        (pf_aqed_fifo_ap_aqed_rdata)

        ,.mem_wclk            (rf_aqed_fifo_ap_aqed_wclk)
        ,.mem_rclk            (rf_aqed_fifo_ap_aqed_rclk)
        ,.mem_wclk_rst_n      (rf_aqed_fifo_ap_aqed_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_aqed_fifo_ap_aqed_rclk_rst_n)
        ,.mem_re              (rf_aqed_fifo_ap_aqed_re)
        ,.mem_raddr           (rf_aqed_fifo_ap_aqed_raddr)
        ,.mem_waddr           (rf_aqed_fifo_ap_aqed_waddr)
        ,.mem_we              (rf_aqed_fifo_ap_aqed_we)
        ,.mem_wdata           (rf_aqed_fifo_ap_aqed_wdata)
        ,.mem_rdata           (rf_aqed_fifo_ap_aqed_rdata)

        ,.mem_rdata_error     (rf_aqed_fifo_ap_aqed_rdata_error)
        ,.error               (rf_aqed_fifo_ap_aqed_error)
);

logic        rf_aqed_fifo_aqed_ap_enq_rdata_error;

logic        cfg_mem_ack_aqed_fifo_aqed_ap_enq_nc;
logic [31:0] cfg_mem_rdata_aqed_fifo_aqed_ap_enq_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (16)
        ,.DWIDTH              (24)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_aqed_fifo_aqed_ap_enq (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_aqed_fifo_aqed_ap_enq_re)
        ,.func_mem_raddr      (func_aqed_fifo_aqed_ap_enq_raddr)
        ,.func_mem_waddr      (func_aqed_fifo_aqed_ap_enq_waddr)
        ,.func_mem_we         (func_aqed_fifo_aqed_ap_enq_we)
        ,.func_mem_wdata      (func_aqed_fifo_aqed_ap_enq_wdata)
        ,.func_mem_rdata      (func_aqed_fifo_aqed_ap_enq_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_aqed_fifo_aqed_ap_enq_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_aqed_fifo_aqed_ap_enq_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_aqed_fifo_aqed_ap_enq_re)
        ,.pf_mem_raddr        (pf_aqed_fifo_aqed_ap_enq_raddr)
        ,.pf_mem_waddr        (pf_aqed_fifo_aqed_ap_enq_waddr)
        ,.pf_mem_we           (pf_aqed_fifo_aqed_ap_enq_we)
        ,.pf_mem_wdata        (pf_aqed_fifo_aqed_ap_enq_wdata)
        ,.pf_mem_rdata        (pf_aqed_fifo_aqed_ap_enq_rdata)

        ,.mem_wclk            (rf_aqed_fifo_aqed_ap_enq_wclk)
        ,.mem_rclk            (rf_aqed_fifo_aqed_ap_enq_rclk)
        ,.mem_wclk_rst_n      (rf_aqed_fifo_aqed_ap_enq_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_aqed_fifo_aqed_ap_enq_rclk_rst_n)
        ,.mem_re              (rf_aqed_fifo_aqed_ap_enq_re)
        ,.mem_raddr           (rf_aqed_fifo_aqed_ap_enq_raddr)
        ,.mem_waddr           (rf_aqed_fifo_aqed_ap_enq_waddr)
        ,.mem_we              (rf_aqed_fifo_aqed_ap_enq_we)
        ,.mem_wdata           (rf_aqed_fifo_aqed_ap_enq_wdata)
        ,.mem_rdata           (rf_aqed_fifo_aqed_ap_enq_rdata)

        ,.mem_rdata_error     (rf_aqed_fifo_aqed_ap_enq_rdata_error)
        ,.error               (rf_aqed_fifo_aqed_ap_enq_error)
);

logic        rf_aqed_fifo_aqed_chp_sch_rdata_error;

logic        cfg_mem_ack_aqed_fifo_aqed_chp_sch_nc;
logic [31:0] cfg_mem_rdata_aqed_fifo_aqed_chp_sch_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (16)
        ,.DWIDTH              (180)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_aqed_fifo_aqed_chp_sch (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_aqed_fifo_aqed_chp_sch_re)
        ,.func_mem_raddr      (func_aqed_fifo_aqed_chp_sch_raddr)
        ,.func_mem_waddr      (func_aqed_fifo_aqed_chp_sch_waddr)
        ,.func_mem_we         (func_aqed_fifo_aqed_chp_sch_we)
        ,.func_mem_wdata      (func_aqed_fifo_aqed_chp_sch_wdata)
        ,.func_mem_rdata      (func_aqed_fifo_aqed_chp_sch_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_aqed_fifo_aqed_chp_sch_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_aqed_fifo_aqed_chp_sch_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_aqed_fifo_aqed_chp_sch_re)
        ,.pf_mem_raddr        (pf_aqed_fifo_aqed_chp_sch_raddr)
        ,.pf_mem_waddr        (pf_aqed_fifo_aqed_chp_sch_waddr)
        ,.pf_mem_we           (pf_aqed_fifo_aqed_chp_sch_we)
        ,.pf_mem_wdata        (pf_aqed_fifo_aqed_chp_sch_wdata)
        ,.pf_mem_rdata        (pf_aqed_fifo_aqed_chp_sch_rdata)

        ,.mem_wclk            (rf_aqed_fifo_aqed_chp_sch_wclk)
        ,.mem_rclk            (rf_aqed_fifo_aqed_chp_sch_rclk)
        ,.mem_wclk_rst_n      (rf_aqed_fifo_aqed_chp_sch_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_aqed_fifo_aqed_chp_sch_rclk_rst_n)
        ,.mem_re              (rf_aqed_fifo_aqed_chp_sch_re)
        ,.mem_raddr           (rf_aqed_fifo_aqed_chp_sch_raddr)
        ,.mem_waddr           (rf_aqed_fifo_aqed_chp_sch_waddr)
        ,.mem_we              (rf_aqed_fifo_aqed_chp_sch_we)
        ,.mem_wdata           (rf_aqed_fifo_aqed_chp_sch_wdata)
        ,.mem_rdata           (rf_aqed_fifo_aqed_chp_sch_rdata)

        ,.mem_rdata_error     (rf_aqed_fifo_aqed_chp_sch_rdata_error)
        ,.error               (rf_aqed_fifo_aqed_chp_sch_error)
);

logic        rf_aqed_fifo_freelist_return_rdata_error;

logic        cfg_mem_ack_aqed_fifo_freelist_return_nc;
logic [31:0] cfg_mem_rdata_aqed_fifo_freelist_return_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (16)
        ,.DWIDTH              (32)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_aqed_fifo_freelist_return (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_aqed_fifo_freelist_return_re)
        ,.func_mem_raddr      (func_aqed_fifo_freelist_return_raddr)
        ,.func_mem_waddr      (func_aqed_fifo_freelist_return_waddr)
        ,.func_mem_we         (func_aqed_fifo_freelist_return_we)
        ,.func_mem_wdata      (func_aqed_fifo_freelist_return_wdata)
        ,.func_mem_rdata      (func_aqed_fifo_freelist_return_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_aqed_fifo_freelist_return_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_aqed_fifo_freelist_return_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_aqed_fifo_freelist_return_re)
        ,.pf_mem_raddr        (pf_aqed_fifo_freelist_return_raddr)
        ,.pf_mem_waddr        (pf_aqed_fifo_freelist_return_waddr)
        ,.pf_mem_we           (pf_aqed_fifo_freelist_return_we)
        ,.pf_mem_wdata        (pf_aqed_fifo_freelist_return_wdata)
        ,.pf_mem_rdata        (pf_aqed_fifo_freelist_return_rdata)

        ,.mem_wclk            (rf_aqed_fifo_freelist_return_wclk)
        ,.mem_rclk            (rf_aqed_fifo_freelist_return_rclk)
        ,.mem_wclk_rst_n      (rf_aqed_fifo_freelist_return_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_aqed_fifo_freelist_return_rclk_rst_n)
        ,.mem_re              (rf_aqed_fifo_freelist_return_re)
        ,.mem_raddr           (rf_aqed_fifo_freelist_return_raddr)
        ,.mem_waddr           (rf_aqed_fifo_freelist_return_waddr)
        ,.mem_we              (rf_aqed_fifo_freelist_return_we)
        ,.mem_wdata           (rf_aqed_fifo_freelist_return_wdata)
        ,.mem_rdata           (rf_aqed_fifo_freelist_return_rdata)

        ,.mem_rdata_error     (rf_aqed_fifo_freelist_return_rdata_error)
        ,.error               (rf_aqed_fifo_freelist_return_error)
);

logic        rf_aqed_fifo_lsp_aqed_cmp_rdata_error;

logic        cfg_mem_ack_aqed_fifo_lsp_aqed_cmp_nc;
logic [31:0] cfg_mem_rdata_aqed_fifo_lsp_aqed_cmp_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (16)
        ,.DWIDTH              (35)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_aqed_fifo_lsp_aqed_cmp (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_aqed_fifo_lsp_aqed_cmp_re)
        ,.func_mem_raddr      (func_aqed_fifo_lsp_aqed_cmp_raddr)
        ,.func_mem_waddr      (func_aqed_fifo_lsp_aqed_cmp_waddr)
        ,.func_mem_we         (func_aqed_fifo_lsp_aqed_cmp_we)
        ,.func_mem_wdata      (func_aqed_fifo_lsp_aqed_cmp_wdata)
        ,.func_mem_rdata      (func_aqed_fifo_lsp_aqed_cmp_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_aqed_fifo_lsp_aqed_cmp_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_aqed_fifo_lsp_aqed_cmp_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_aqed_fifo_lsp_aqed_cmp_re)
        ,.pf_mem_raddr        (pf_aqed_fifo_lsp_aqed_cmp_raddr)
        ,.pf_mem_waddr        (pf_aqed_fifo_lsp_aqed_cmp_waddr)
        ,.pf_mem_we           (pf_aqed_fifo_lsp_aqed_cmp_we)
        ,.pf_mem_wdata        (pf_aqed_fifo_lsp_aqed_cmp_wdata)
        ,.pf_mem_rdata        (pf_aqed_fifo_lsp_aqed_cmp_rdata)

        ,.mem_wclk            (rf_aqed_fifo_lsp_aqed_cmp_wclk)
        ,.mem_rclk            (rf_aqed_fifo_lsp_aqed_cmp_rclk)
        ,.mem_wclk_rst_n      (rf_aqed_fifo_lsp_aqed_cmp_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_aqed_fifo_lsp_aqed_cmp_rclk_rst_n)
        ,.mem_re              (rf_aqed_fifo_lsp_aqed_cmp_re)
        ,.mem_raddr           (rf_aqed_fifo_lsp_aqed_cmp_raddr)
        ,.mem_waddr           (rf_aqed_fifo_lsp_aqed_cmp_waddr)
        ,.mem_we              (rf_aqed_fifo_lsp_aqed_cmp_we)
        ,.mem_wdata           (rf_aqed_fifo_lsp_aqed_cmp_wdata)
        ,.mem_rdata           (rf_aqed_fifo_lsp_aqed_cmp_rdata)

        ,.mem_rdata_error     (rf_aqed_fifo_lsp_aqed_cmp_rdata_error)
        ,.error               (rf_aqed_fifo_lsp_aqed_cmp_error)
);

logic        rf_aqed_fifo_qed_aqed_enq_rdata_error;

logic        cfg_mem_ack_aqed_fifo_qed_aqed_enq_nc;
logic [31:0] cfg_mem_rdata_aqed_fifo_qed_aqed_enq_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (4)
        ,.DWIDTH              (155)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_aqed_fifo_qed_aqed_enq (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_aqed_fifo_qed_aqed_enq_re)
        ,.func_mem_raddr      (func_aqed_fifo_qed_aqed_enq_raddr)
        ,.func_mem_waddr      (func_aqed_fifo_qed_aqed_enq_waddr)
        ,.func_mem_we         (func_aqed_fifo_qed_aqed_enq_we)
        ,.func_mem_wdata      (func_aqed_fifo_qed_aqed_enq_wdata)
        ,.func_mem_rdata      (func_aqed_fifo_qed_aqed_enq_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_aqed_fifo_qed_aqed_enq_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_aqed_fifo_qed_aqed_enq_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_aqed_fifo_qed_aqed_enq_re)
        ,.pf_mem_raddr        (pf_aqed_fifo_qed_aqed_enq_raddr)
        ,.pf_mem_waddr        (pf_aqed_fifo_qed_aqed_enq_waddr)
        ,.pf_mem_we           (pf_aqed_fifo_qed_aqed_enq_we)
        ,.pf_mem_wdata        (pf_aqed_fifo_qed_aqed_enq_wdata)
        ,.pf_mem_rdata        (pf_aqed_fifo_qed_aqed_enq_rdata)

        ,.mem_wclk            (rf_aqed_fifo_qed_aqed_enq_wclk)
        ,.mem_rclk            (rf_aqed_fifo_qed_aqed_enq_rclk)
        ,.mem_wclk_rst_n      (rf_aqed_fifo_qed_aqed_enq_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_aqed_fifo_qed_aqed_enq_rclk_rst_n)
        ,.mem_re              (rf_aqed_fifo_qed_aqed_enq_re)
        ,.mem_raddr           (rf_aqed_fifo_qed_aqed_enq_raddr)
        ,.mem_waddr           (rf_aqed_fifo_qed_aqed_enq_waddr)
        ,.mem_we              (rf_aqed_fifo_qed_aqed_enq_we)
        ,.mem_wdata           (rf_aqed_fifo_qed_aqed_enq_wdata)
        ,.mem_rdata           (rf_aqed_fifo_qed_aqed_enq_rdata)

        ,.mem_rdata_error     (rf_aqed_fifo_qed_aqed_enq_rdata_error)
        ,.error               (rf_aqed_fifo_qed_aqed_enq_error)
);

logic        rf_aqed_fifo_qed_aqed_enq_fid_rdata_error;

logic        cfg_mem_ack_aqed_fifo_qed_aqed_enq_fid_nc;
logic [31:0] cfg_mem_rdata_aqed_fifo_qed_aqed_enq_fid_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (8)
        ,.DWIDTH              (153)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_aqed_fifo_qed_aqed_enq_fid (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_aqed_fifo_qed_aqed_enq_fid_re)
        ,.func_mem_raddr      (func_aqed_fifo_qed_aqed_enq_fid_raddr)
        ,.func_mem_waddr      (func_aqed_fifo_qed_aqed_enq_fid_waddr)
        ,.func_mem_we         (func_aqed_fifo_qed_aqed_enq_fid_we)
        ,.func_mem_wdata      (func_aqed_fifo_qed_aqed_enq_fid_wdata)
        ,.func_mem_rdata      (func_aqed_fifo_qed_aqed_enq_fid_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_aqed_fifo_qed_aqed_enq_fid_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_aqed_fifo_qed_aqed_enq_fid_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_aqed_fifo_qed_aqed_enq_fid_re)
        ,.pf_mem_raddr        (pf_aqed_fifo_qed_aqed_enq_fid_raddr)
        ,.pf_mem_waddr        (pf_aqed_fifo_qed_aqed_enq_fid_waddr)
        ,.pf_mem_we           (pf_aqed_fifo_qed_aqed_enq_fid_we)
        ,.pf_mem_wdata        (pf_aqed_fifo_qed_aqed_enq_fid_wdata)
        ,.pf_mem_rdata        (pf_aqed_fifo_qed_aqed_enq_fid_rdata)

        ,.mem_wclk            (rf_aqed_fifo_qed_aqed_enq_fid_wclk)
        ,.mem_rclk            (rf_aqed_fifo_qed_aqed_enq_fid_rclk)
        ,.mem_wclk_rst_n      (rf_aqed_fifo_qed_aqed_enq_fid_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_aqed_fifo_qed_aqed_enq_fid_rclk_rst_n)
        ,.mem_re              (rf_aqed_fifo_qed_aqed_enq_fid_re)
        ,.mem_raddr           (rf_aqed_fifo_qed_aqed_enq_fid_raddr)
        ,.mem_waddr           (rf_aqed_fifo_qed_aqed_enq_fid_waddr)
        ,.mem_we              (rf_aqed_fifo_qed_aqed_enq_fid_we)
        ,.mem_wdata           (rf_aqed_fifo_qed_aqed_enq_fid_wdata)
        ,.mem_rdata           (rf_aqed_fifo_qed_aqed_enq_fid_rdata)

        ,.mem_rdata_error     (rf_aqed_fifo_qed_aqed_enq_fid_rdata_error)
        ,.error               (rf_aqed_fifo_qed_aqed_enq_fid_error)
);

logic [(       1)-1:0] rf_aqed_ll_cnt_pri0_raddr_nc ;
logic [(       1)-1:0] rf_aqed_ll_cnt_pri0_waddr_nc ;

logic        rf_aqed_ll_cnt_pri0_rdata_error;

logic        cfg_mem_ack_aqed_ll_cnt_pri0_nc;
logic [31:0] cfg_mem_rdata_aqed_ll_cnt_pri0_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (14)
        ,.AWIDTHPAD           (1)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (2)
) i_aqed_ll_cnt_pri0 (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_aqed_ll_cnt_pri0_re)
        ,.func_mem_raddr      (func_aqed_ll_cnt_pri0_raddr)
        ,.func_mem_waddr      (func_aqed_ll_cnt_pri0_waddr)
        ,.func_mem_we         (func_aqed_ll_cnt_pri0_we)
        ,.func_mem_wdata      (func_aqed_ll_cnt_pri0_wdata)
        ,.func_mem_rdata      (func_aqed_ll_cnt_pri0_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_aqed_ll_cnt_pri0_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_aqed_ll_cnt_pri0_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_aqed_ll_cnt_pri0_re)
        ,.pf_mem_raddr        (pf_aqed_ll_cnt_pri0_raddr)
        ,.pf_mem_waddr        (pf_aqed_ll_cnt_pri0_waddr)
        ,.pf_mem_we           (pf_aqed_ll_cnt_pri0_we)
        ,.pf_mem_wdata        (pf_aqed_ll_cnt_pri0_wdata)
        ,.pf_mem_rdata        (pf_aqed_ll_cnt_pri0_rdata)

        ,.mem_wclk            (rf_aqed_ll_cnt_pri0_wclk)
        ,.mem_rclk            (rf_aqed_ll_cnt_pri0_rclk)
        ,.mem_wclk_rst_n      (rf_aqed_ll_cnt_pri0_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_aqed_ll_cnt_pri0_rclk_rst_n)
        ,.mem_re              (rf_aqed_ll_cnt_pri0_re)
        ,.mem_raddr           ({rf_aqed_ll_cnt_pri0_raddr_nc , rf_aqed_ll_cnt_pri0_raddr})
        ,.mem_waddr           ({rf_aqed_ll_cnt_pri0_waddr_nc , rf_aqed_ll_cnt_pri0_waddr})
        ,.mem_we              (rf_aqed_ll_cnt_pri0_we)
        ,.mem_wdata           (rf_aqed_ll_cnt_pri0_wdata)
        ,.mem_rdata           (rf_aqed_ll_cnt_pri0_rdata)

        ,.mem_rdata_error     (rf_aqed_ll_cnt_pri0_rdata_error)
        ,.error               (rf_aqed_ll_cnt_pri0_error)
);

logic [(       1)-1:0] rf_aqed_ll_cnt_pri1_raddr_nc ;
logic [(       1)-1:0] rf_aqed_ll_cnt_pri1_waddr_nc ;

logic        rf_aqed_ll_cnt_pri1_rdata_error;

logic        cfg_mem_ack_aqed_ll_cnt_pri1_nc;
logic [31:0] cfg_mem_rdata_aqed_ll_cnt_pri1_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (14)
        ,.AWIDTHPAD           (1)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (2)
) i_aqed_ll_cnt_pri1 (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_aqed_ll_cnt_pri1_re)
        ,.func_mem_raddr      (func_aqed_ll_cnt_pri1_raddr)
        ,.func_mem_waddr      (func_aqed_ll_cnt_pri1_waddr)
        ,.func_mem_we         (func_aqed_ll_cnt_pri1_we)
        ,.func_mem_wdata      (func_aqed_ll_cnt_pri1_wdata)
        ,.func_mem_rdata      (func_aqed_ll_cnt_pri1_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_aqed_ll_cnt_pri1_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_aqed_ll_cnt_pri1_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_aqed_ll_cnt_pri1_re)
        ,.pf_mem_raddr        (pf_aqed_ll_cnt_pri1_raddr)
        ,.pf_mem_waddr        (pf_aqed_ll_cnt_pri1_waddr)
        ,.pf_mem_we           (pf_aqed_ll_cnt_pri1_we)
        ,.pf_mem_wdata        (pf_aqed_ll_cnt_pri1_wdata)
        ,.pf_mem_rdata        (pf_aqed_ll_cnt_pri1_rdata)

        ,.mem_wclk            (rf_aqed_ll_cnt_pri1_wclk)
        ,.mem_rclk            (rf_aqed_ll_cnt_pri1_rclk)
        ,.mem_wclk_rst_n      (rf_aqed_ll_cnt_pri1_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_aqed_ll_cnt_pri1_rclk_rst_n)
        ,.mem_re              (rf_aqed_ll_cnt_pri1_re)
        ,.mem_raddr           ({rf_aqed_ll_cnt_pri1_raddr_nc , rf_aqed_ll_cnt_pri1_raddr})
        ,.mem_waddr           ({rf_aqed_ll_cnt_pri1_waddr_nc , rf_aqed_ll_cnt_pri1_waddr})
        ,.mem_we              (rf_aqed_ll_cnt_pri1_we)
        ,.mem_wdata           (rf_aqed_ll_cnt_pri1_wdata)
        ,.mem_rdata           (rf_aqed_ll_cnt_pri1_rdata)

        ,.mem_rdata_error     (rf_aqed_ll_cnt_pri1_rdata_error)
        ,.error               (rf_aqed_ll_cnt_pri1_error)
);

logic [(       1)-1:0] rf_aqed_ll_cnt_pri2_raddr_nc ;
logic [(       1)-1:0] rf_aqed_ll_cnt_pri2_waddr_nc ;

logic        rf_aqed_ll_cnt_pri2_rdata_error;

logic        cfg_mem_ack_aqed_ll_cnt_pri2_nc;
logic [31:0] cfg_mem_rdata_aqed_ll_cnt_pri2_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (14)
        ,.AWIDTHPAD           (1)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (2)
) i_aqed_ll_cnt_pri2 (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_aqed_ll_cnt_pri2_re)
        ,.func_mem_raddr      (func_aqed_ll_cnt_pri2_raddr)
        ,.func_mem_waddr      (func_aqed_ll_cnt_pri2_waddr)
        ,.func_mem_we         (func_aqed_ll_cnt_pri2_we)
        ,.func_mem_wdata      (func_aqed_ll_cnt_pri2_wdata)
        ,.func_mem_rdata      (func_aqed_ll_cnt_pri2_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_aqed_ll_cnt_pri2_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_aqed_ll_cnt_pri2_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_aqed_ll_cnt_pri2_re)
        ,.pf_mem_raddr        (pf_aqed_ll_cnt_pri2_raddr)
        ,.pf_mem_waddr        (pf_aqed_ll_cnt_pri2_waddr)
        ,.pf_mem_we           (pf_aqed_ll_cnt_pri2_we)
        ,.pf_mem_wdata        (pf_aqed_ll_cnt_pri2_wdata)
        ,.pf_mem_rdata        (pf_aqed_ll_cnt_pri2_rdata)

        ,.mem_wclk            (rf_aqed_ll_cnt_pri2_wclk)
        ,.mem_rclk            (rf_aqed_ll_cnt_pri2_rclk)
        ,.mem_wclk_rst_n      (rf_aqed_ll_cnt_pri2_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_aqed_ll_cnt_pri2_rclk_rst_n)
        ,.mem_re              (rf_aqed_ll_cnt_pri2_re)
        ,.mem_raddr           ({rf_aqed_ll_cnt_pri2_raddr_nc , rf_aqed_ll_cnt_pri2_raddr})
        ,.mem_waddr           ({rf_aqed_ll_cnt_pri2_waddr_nc , rf_aqed_ll_cnt_pri2_waddr})
        ,.mem_we              (rf_aqed_ll_cnt_pri2_we)
        ,.mem_wdata           (rf_aqed_ll_cnt_pri2_wdata)
        ,.mem_rdata           (rf_aqed_ll_cnt_pri2_rdata)

        ,.mem_rdata_error     (rf_aqed_ll_cnt_pri2_rdata_error)
        ,.error               (rf_aqed_ll_cnt_pri2_error)
);

logic [(       1)-1:0] rf_aqed_ll_cnt_pri3_raddr_nc ;
logic [(       1)-1:0] rf_aqed_ll_cnt_pri3_waddr_nc ;

logic        rf_aqed_ll_cnt_pri3_rdata_error;

logic        cfg_mem_ack_aqed_ll_cnt_pri3_nc;
logic [31:0] cfg_mem_rdata_aqed_ll_cnt_pri3_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (14)
        ,.AWIDTHPAD           (1)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (2)
) i_aqed_ll_cnt_pri3 (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_aqed_ll_cnt_pri3_re)
        ,.func_mem_raddr      (func_aqed_ll_cnt_pri3_raddr)
        ,.func_mem_waddr      (func_aqed_ll_cnt_pri3_waddr)
        ,.func_mem_we         (func_aqed_ll_cnt_pri3_we)
        ,.func_mem_wdata      (func_aqed_ll_cnt_pri3_wdata)
        ,.func_mem_rdata      (func_aqed_ll_cnt_pri3_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_aqed_ll_cnt_pri3_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_aqed_ll_cnt_pri3_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_aqed_ll_cnt_pri3_re)
        ,.pf_mem_raddr        (pf_aqed_ll_cnt_pri3_raddr)
        ,.pf_mem_waddr        (pf_aqed_ll_cnt_pri3_waddr)
        ,.pf_mem_we           (pf_aqed_ll_cnt_pri3_we)
        ,.pf_mem_wdata        (pf_aqed_ll_cnt_pri3_wdata)
        ,.pf_mem_rdata        (pf_aqed_ll_cnt_pri3_rdata)

        ,.mem_wclk            (rf_aqed_ll_cnt_pri3_wclk)
        ,.mem_rclk            (rf_aqed_ll_cnt_pri3_rclk)
        ,.mem_wclk_rst_n      (rf_aqed_ll_cnt_pri3_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_aqed_ll_cnt_pri3_rclk_rst_n)
        ,.mem_re              (rf_aqed_ll_cnt_pri3_re)
        ,.mem_raddr           ({rf_aqed_ll_cnt_pri3_raddr_nc , rf_aqed_ll_cnt_pri3_raddr})
        ,.mem_waddr           ({rf_aqed_ll_cnt_pri3_waddr_nc , rf_aqed_ll_cnt_pri3_waddr})
        ,.mem_we              (rf_aqed_ll_cnt_pri3_we)
        ,.mem_wdata           (rf_aqed_ll_cnt_pri3_wdata)
        ,.mem_rdata           (rf_aqed_ll_cnt_pri3_rdata)

        ,.mem_rdata_error     (rf_aqed_ll_cnt_pri3_rdata_error)
        ,.error               (rf_aqed_ll_cnt_pri3_error)
);

logic [(       1)-1:0] rf_aqed_ll_qe_hp_pri0_raddr_nc ;
logic [(       1)-1:0] rf_aqed_ll_qe_hp_pri0_waddr_nc ;

logic        rf_aqed_ll_qe_hp_pri0_rdata_error;

logic        cfg_mem_ack_aqed_ll_qe_hp_pri0_nc;
logic [31:0] cfg_mem_rdata_aqed_ll_qe_hp_pri0_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (12)
        ,.AWIDTHPAD           (1)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (2)
) i_aqed_ll_qe_hp_pri0 (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_aqed_ll_qe_hp_pri0_re)
        ,.func_mem_raddr      (func_aqed_ll_qe_hp_pri0_raddr)
        ,.func_mem_waddr      (func_aqed_ll_qe_hp_pri0_waddr)
        ,.func_mem_we         (func_aqed_ll_qe_hp_pri0_we)
        ,.func_mem_wdata      (func_aqed_ll_qe_hp_pri0_wdata)
        ,.func_mem_rdata      (func_aqed_ll_qe_hp_pri0_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_aqed_ll_qe_hp_pri0_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_aqed_ll_qe_hp_pri0_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_aqed_ll_qe_hp_pri0_re)
        ,.pf_mem_raddr        (pf_aqed_ll_qe_hp_pri0_raddr)
        ,.pf_mem_waddr        (pf_aqed_ll_qe_hp_pri0_waddr)
        ,.pf_mem_we           (pf_aqed_ll_qe_hp_pri0_we)
        ,.pf_mem_wdata        (pf_aqed_ll_qe_hp_pri0_wdata)
        ,.pf_mem_rdata        (pf_aqed_ll_qe_hp_pri0_rdata)

        ,.mem_wclk            (rf_aqed_ll_qe_hp_pri0_wclk)
        ,.mem_rclk            (rf_aqed_ll_qe_hp_pri0_rclk)
        ,.mem_wclk_rst_n      (rf_aqed_ll_qe_hp_pri0_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_aqed_ll_qe_hp_pri0_rclk_rst_n)
        ,.mem_re              (rf_aqed_ll_qe_hp_pri0_re)
        ,.mem_raddr           ({rf_aqed_ll_qe_hp_pri0_raddr_nc , rf_aqed_ll_qe_hp_pri0_raddr})
        ,.mem_waddr           ({rf_aqed_ll_qe_hp_pri0_waddr_nc , rf_aqed_ll_qe_hp_pri0_waddr})
        ,.mem_we              (rf_aqed_ll_qe_hp_pri0_we)
        ,.mem_wdata           (rf_aqed_ll_qe_hp_pri0_wdata)
        ,.mem_rdata           (rf_aqed_ll_qe_hp_pri0_rdata)

        ,.mem_rdata_error     (rf_aqed_ll_qe_hp_pri0_rdata_error)
        ,.error               (rf_aqed_ll_qe_hp_pri0_error)
);

logic [(       1)-1:0] rf_aqed_ll_qe_hp_pri1_raddr_nc ;
logic [(       1)-1:0] rf_aqed_ll_qe_hp_pri1_waddr_nc ;

logic        rf_aqed_ll_qe_hp_pri1_rdata_error;

logic        cfg_mem_ack_aqed_ll_qe_hp_pri1_nc;
logic [31:0] cfg_mem_rdata_aqed_ll_qe_hp_pri1_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (12)
        ,.AWIDTHPAD           (1)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (2)
) i_aqed_ll_qe_hp_pri1 (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_aqed_ll_qe_hp_pri1_re)
        ,.func_mem_raddr      (func_aqed_ll_qe_hp_pri1_raddr)
        ,.func_mem_waddr      (func_aqed_ll_qe_hp_pri1_waddr)
        ,.func_mem_we         (func_aqed_ll_qe_hp_pri1_we)
        ,.func_mem_wdata      (func_aqed_ll_qe_hp_pri1_wdata)
        ,.func_mem_rdata      (func_aqed_ll_qe_hp_pri1_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_aqed_ll_qe_hp_pri1_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_aqed_ll_qe_hp_pri1_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_aqed_ll_qe_hp_pri1_re)
        ,.pf_mem_raddr        (pf_aqed_ll_qe_hp_pri1_raddr)
        ,.pf_mem_waddr        (pf_aqed_ll_qe_hp_pri1_waddr)
        ,.pf_mem_we           (pf_aqed_ll_qe_hp_pri1_we)
        ,.pf_mem_wdata        (pf_aqed_ll_qe_hp_pri1_wdata)
        ,.pf_mem_rdata        (pf_aqed_ll_qe_hp_pri1_rdata)

        ,.mem_wclk            (rf_aqed_ll_qe_hp_pri1_wclk)
        ,.mem_rclk            (rf_aqed_ll_qe_hp_pri1_rclk)
        ,.mem_wclk_rst_n      (rf_aqed_ll_qe_hp_pri1_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_aqed_ll_qe_hp_pri1_rclk_rst_n)
        ,.mem_re              (rf_aqed_ll_qe_hp_pri1_re)
        ,.mem_raddr           ({rf_aqed_ll_qe_hp_pri1_raddr_nc , rf_aqed_ll_qe_hp_pri1_raddr})
        ,.mem_waddr           ({rf_aqed_ll_qe_hp_pri1_waddr_nc , rf_aqed_ll_qe_hp_pri1_waddr})
        ,.mem_we              (rf_aqed_ll_qe_hp_pri1_we)
        ,.mem_wdata           (rf_aqed_ll_qe_hp_pri1_wdata)
        ,.mem_rdata           (rf_aqed_ll_qe_hp_pri1_rdata)

        ,.mem_rdata_error     (rf_aqed_ll_qe_hp_pri1_rdata_error)
        ,.error               (rf_aqed_ll_qe_hp_pri1_error)
);

logic [(       1)-1:0] rf_aqed_ll_qe_hp_pri2_raddr_nc ;
logic [(       1)-1:0] rf_aqed_ll_qe_hp_pri2_waddr_nc ;

logic        rf_aqed_ll_qe_hp_pri2_rdata_error;

logic        cfg_mem_ack_aqed_ll_qe_hp_pri2_nc;
logic [31:0] cfg_mem_rdata_aqed_ll_qe_hp_pri2_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (12)
        ,.AWIDTHPAD           (1)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (2)
) i_aqed_ll_qe_hp_pri2 (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_aqed_ll_qe_hp_pri2_re)
        ,.func_mem_raddr      (func_aqed_ll_qe_hp_pri2_raddr)
        ,.func_mem_waddr      (func_aqed_ll_qe_hp_pri2_waddr)
        ,.func_mem_we         (func_aqed_ll_qe_hp_pri2_we)
        ,.func_mem_wdata      (func_aqed_ll_qe_hp_pri2_wdata)
        ,.func_mem_rdata      (func_aqed_ll_qe_hp_pri2_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_aqed_ll_qe_hp_pri2_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_aqed_ll_qe_hp_pri2_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_aqed_ll_qe_hp_pri2_re)
        ,.pf_mem_raddr        (pf_aqed_ll_qe_hp_pri2_raddr)
        ,.pf_mem_waddr        (pf_aqed_ll_qe_hp_pri2_waddr)
        ,.pf_mem_we           (pf_aqed_ll_qe_hp_pri2_we)
        ,.pf_mem_wdata        (pf_aqed_ll_qe_hp_pri2_wdata)
        ,.pf_mem_rdata        (pf_aqed_ll_qe_hp_pri2_rdata)

        ,.mem_wclk            (rf_aqed_ll_qe_hp_pri2_wclk)
        ,.mem_rclk            (rf_aqed_ll_qe_hp_pri2_rclk)
        ,.mem_wclk_rst_n      (rf_aqed_ll_qe_hp_pri2_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_aqed_ll_qe_hp_pri2_rclk_rst_n)
        ,.mem_re              (rf_aqed_ll_qe_hp_pri2_re)
        ,.mem_raddr           ({rf_aqed_ll_qe_hp_pri2_raddr_nc , rf_aqed_ll_qe_hp_pri2_raddr})
        ,.mem_waddr           ({rf_aqed_ll_qe_hp_pri2_waddr_nc , rf_aqed_ll_qe_hp_pri2_waddr})
        ,.mem_we              (rf_aqed_ll_qe_hp_pri2_we)
        ,.mem_wdata           (rf_aqed_ll_qe_hp_pri2_wdata)
        ,.mem_rdata           (rf_aqed_ll_qe_hp_pri2_rdata)

        ,.mem_rdata_error     (rf_aqed_ll_qe_hp_pri2_rdata_error)
        ,.error               (rf_aqed_ll_qe_hp_pri2_error)
);

logic [(       1)-1:0] rf_aqed_ll_qe_hp_pri3_raddr_nc ;
logic [(       1)-1:0] rf_aqed_ll_qe_hp_pri3_waddr_nc ;

logic        rf_aqed_ll_qe_hp_pri3_rdata_error;

logic        cfg_mem_ack_aqed_ll_qe_hp_pri3_nc;
logic [31:0] cfg_mem_rdata_aqed_ll_qe_hp_pri3_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (12)
        ,.AWIDTHPAD           (1)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (2)
) i_aqed_ll_qe_hp_pri3 (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_aqed_ll_qe_hp_pri3_re)
        ,.func_mem_raddr      (func_aqed_ll_qe_hp_pri3_raddr)
        ,.func_mem_waddr      (func_aqed_ll_qe_hp_pri3_waddr)
        ,.func_mem_we         (func_aqed_ll_qe_hp_pri3_we)
        ,.func_mem_wdata      (func_aqed_ll_qe_hp_pri3_wdata)
        ,.func_mem_rdata      (func_aqed_ll_qe_hp_pri3_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_aqed_ll_qe_hp_pri3_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_aqed_ll_qe_hp_pri3_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_aqed_ll_qe_hp_pri3_re)
        ,.pf_mem_raddr        (pf_aqed_ll_qe_hp_pri3_raddr)
        ,.pf_mem_waddr        (pf_aqed_ll_qe_hp_pri3_waddr)
        ,.pf_mem_we           (pf_aqed_ll_qe_hp_pri3_we)
        ,.pf_mem_wdata        (pf_aqed_ll_qe_hp_pri3_wdata)
        ,.pf_mem_rdata        (pf_aqed_ll_qe_hp_pri3_rdata)

        ,.mem_wclk            (rf_aqed_ll_qe_hp_pri3_wclk)
        ,.mem_rclk            (rf_aqed_ll_qe_hp_pri3_rclk)
        ,.mem_wclk_rst_n      (rf_aqed_ll_qe_hp_pri3_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_aqed_ll_qe_hp_pri3_rclk_rst_n)
        ,.mem_re              (rf_aqed_ll_qe_hp_pri3_re)
        ,.mem_raddr           ({rf_aqed_ll_qe_hp_pri3_raddr_nc , rf_aqed_ll_qe_hp_pri3_raddr})
        ,.mem_waddr           ({rf_aqed_ll_qe_hp_pri3_waddr_nc , rf_aqed_ll_qe_hp_pri3_waddr})
        ,.mem_we              (rf_aqed_ll_qe_hp_pri3_we)
        ,.mem_wdata           (rf_aqed_ll_qe_hp_pri3_wdata)
        ,.mem_rdata           (rf_aqed_ll_qe_hp_pri3_rdata)

        ,.mem_rdata_error     (rf_aqed_ll_qe_hp_pri3_rdata_error)
        ,.error               (rf_aqed_ll_qe_hp_pri3_error)
);

logic [(       1)-1:0] rf_aqed_ll_qe_tp_pri0_raddr_nc ;
logic [(       1)-1:0] rf_aqed_ll_qe_tp_pri0_waddr_nc ;

logic        rf_aqed_ll_qe_tp_pri0_rdata_error;

logic        cfg_mem_ack_aqed_ll_qe_tp_pri0_nc;
logic [31:0] cfg_mem_rdata_aqed_ll_qe_tp_pri0_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (12)
        ,.AWIDTHPAD           (1)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (2)
) i_aqed_ll_qe_tp_pri0 (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_aqed_ll_qe_tp_pri0_re)
        ,.func_mem_raddr      (func_aqed_ll_qe_tp_pri0_raddr)
        ,.func_mem_waddr      (func_aqed_ll_qe_tp_pri0_waddr)
        ,.func_mem_we         (func_aqed_ll_qe_tp_pri0_we)
        ,.func_mem_wdata      (func_aqed_ll_qe_tp_pri0_wdata)
        ,.func_mem_rdata      (func_aqed_ll_qe_tp_pri0_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_aqed_ll_qe_tp_pri0_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_aqed_ll_qe_tp_pri0_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_aqed_ll_qe_tp_pri0_re)
        ,.pf_mem_raddr        (pf_aqed_ll_qe_tp_pri0_raddr)
        ,.pf_mem_waddr        (pf_aqed_ll_qe_tp_pri0_waddr)
        ,.pf_mem_we           (pf_aqed_ll_qe_tp_pri0_we)
        ,.pf_mem_wdata        (pf_aqed_ll_qe_tp_pri0_wdata)
        ,.pf_mem_rdata        (pf_aqed_ll_qe_tp_pri0_rdata)

        ,.mem_wclk            (rf_aqed_ll_qe_tp_pri0_wclk)
        ,.mem_rclk            (rf_aqed_ll_qe_tp_pri0_rclk)
        ,.mem_wclk_rst_n      (rf_aqed_ll_qe_tp_pri0_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_aqed_ll_qe_tp_pri0_rclk_rst_n)
        ,.mem_re              (rf_aqed_ll_qe_tp_pri0_re)
        ,.mem_raddr           ({rf_aqed_ll_qe_tp_pri0_raddr_nc , rf_aqed_ll_qe_tp_pri0_raddr})
        ,.mem_waddr           ({rf_aqed_ll_qe_tp_pri0_waddr_nc , rf_aqed_ll_qe_tp_pri0_waddr})
        ,.mem_we              (rf_aqed_ll_qe_tp_pri0_we)
        ,.mem_wdata           (rf_aqed_ll_qe_tp_pri0_wdata)
        ,.mem_rdata           (rf_aqed_ll_qe_tp_pri0_rdata)

        ,.mem_rdata_error     (rf_aqed_ll_qe_tp_pri0_rdata_error)
        ,.error               (rf_aqed_ll_qe_tp_pri0_error)
);

logic [(       1)-1:0] rf_aqed_ll_qe_tp_pri1_raddr_nc ;
logic [(       1)-1:0] rf_aqed_ll_qe_tp_pri1_waddr_nc ;

logic        rf_aqed_ll_qe_tp_pri1_rdata_error;

logic        cfg_mem_ack_aqed_ll_qe_tp_pri1_nc;
logic [31:0] cfg_mem_rdata_aqed_ll_qe_tp_pri1_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (12)
        ,.AWIDTHPAD           (1)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (2)
) i_aqed_ll_qe_tp_pri1 (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_aqed_ll_qe_tp_pri1_re)
        ,.func_mem_raddr      (func_aqed_ll_qe_tp_pri1_raddr)
        ,.func_mem_waddr      (func_aqed_ll_qe_tp_pri1_waddr)
        ,.func_mem_we         (func_aqed_ll_qe_tp_pri1_we)
        ,.func_mem_wdata      (func_aqed_ll_qe_tp_pri1_wdata)
        ,.func_mem_rdata      (func_aqed_ll_qe_tp_pri1_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_aqed_ll_qe_tp_pri1_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_aqed_ll_qe_tp_pri1_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_aqed_ll_qe_tp_pri1_re)
        ,.pf_mem_raddr        (pf_aqed_ll_qe_tp_pri1_raddr)
        ,.pf_mem_waddr        (pf_aqed_ll_qe_tp_pri1_waddr)
        ,.pf_mem_we           (pf_aqed_ll_qe_tp_pri1_we)
        ,.pf_mem_wdata        (pf_aqed_ll_qe_tp_pri1_wdata)
        ,.pf_mem_rdata        (pf_aqed_ll_qe_tp_pri1_rdata)

        ,.mem_wclk            (rf_aqed_ll_qe_tp_pri1_wclk)
        ,.mem_rclk            (rf_aqed_ll_qe_tp_pri1_rclk)
        ,.mem_wclk_rst_n      (rf_aqed_ll_qe_tp_pri1_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_aqed_ll_qe_tp_pri1_rclk_rst_n)
        ,.mem_re              (rf_aqed_ll_qe_tp_pri1_re)
        ,.mem_raddr           ({rf_aqed_ll_qe_tp_pri1_raddr_nc , rf_aqed_ll_qe_tp_pri1_raddr})
        ,.mem_waddr           ({rf_aqed_ll_qe_tp_pri1_waddr_nc , rf_aqed_ll_qe_tp_pri1_waddr})
        ,.mem_we              (rf_aqed_ll_qe_tp_pri1_we)
        ,.mem_wdata           (rf_aqed_ll_qe_tp_pri1_wdata)
        ,.mem_rdata           (rf_aqed_ll_qe_tp_pri1_rdata)

        ,.mem_rdata_error     (rf_aqed_ll_qe_tp_pri1_rdata_error)
        ,.error               (rf_aqed_ll_qe_tp_pri1_error)
);

logic [(       1)-1:0] rf_aqed_ll_qe_tp_pri2_raddr_nc ;
logic [(       1)-1:0] rf_aqed_ll_qe_tp_pri2_waddr_nc ;

logic        rf_aqed_ll_qe_tp_pri2_rdata_error;

logic        cfg_mem_ack_aqed_ll_qe_tp_pri2_nc;
logic [31:0] cfg_mem_rdata_aqed_ll_qe_tp_pri2_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (12)
        ,.AWIDTHPAD           (1)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (2)
) i_aqed_ll_qe_tp_pri2 (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_aqed_ll_qe_tp_pri2_re)
        ,.func_mem_raddr      (func_aqed_ll_qe_tp_pri2_raddr)
        ,.func_mem_waddr      (func_aqed_ll_qe_tp_pri2_waddr)
        ,.func_mem_we         (func_aqed_ll_qe_tp_pri2_we)
        ,.func_mem_wdata      (func_aqed_ll_qe_tp_pri2_wdata)
        ,.func_mem_rdata      (func_aqed_ll_qe_tp_pri2_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_aqed_ll_qe_tp_pri2_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_aqed_ll_qe_tp_pri2_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_aqed_ll_qe_tp_pri2_re)
        ,.pf_mem_raddr        (pf_aqed_ll_qe_tp_pri2_raddr)
        ,.pf_mem_waddr        (pf_aqed_ll_qe_tp_pri2_waddr)
        ,.pf_mem_we           (pf_aqed_ll_qe_tp_pri2_we)
        ,.pf_mem_wdata        (pf_aqed_ll_qe_tp_pri2_wdata)
        ,.pf_mem_rdata        (pf_aqed_ll_qe_tp_pri2_rdata)

        ,.mem_wclk            (rf_aqed_ll_qe_tp_pri2_wclk)
        ,.mem_rclk            (rf_aqed_ll_qe_tp_pri2_rclk)
        ,.mem_wclk_rst_n      (rf_aqed_ll_qe_tp_pri2_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_aqed_ll_qe_tp_pri2_rclk_rst_n)
        ,.mem_re              (rf_aqed_ll_qe_tp_pri2_re)
        ,.mem_raddr           ({rf_aqed_ll_qe_tp_pri2_raddr_nc , rf_aqed_ll_qe_tp_pri2_raddr})
        ,.mem_waddr           ({rf_aqed_ll_qe_tp_pri2_waddr_nc , rf_aqed_ll_qe_tp_pri2_waddr})
        ,.mem_we              (rf_aqed_ll_qe_tp_pri2_we)
        ,.mem_wdata           (rf_aqed_ll_qe_tp_pri2_wdata)
        ,.mem_rdata           (rf_aqed_ll_qe_tp_pri2_rdata)

        ,.mem_rdata_error     (rf_aqed_ll_qe_tp_pri2_rdata_error)
        ,.error               (rf_aqed_ll_qe_tp_pri2_error)
);

logic [(       1)-1:0] rf_aqed_ll_qe_tp_pri3_raddr_nc ;
logic [(       1)-1:0] rf_aqed_ll_qe_tp_pri3_waddr_nc ;

logic        rf_aqed_ll_qe_tp_pri3_rdata_error;

logic        cfg_mem_ack_aqed_ll_qe_tp_pri3_nc;
logic [31:0] cfg_mem_rdata_aqed_ll_qe_tp_pri3_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (12)
        ,.AWIDTHPAD           (1)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (2)
) i_aqed_ll_qe_tp_pri3 (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_aqed_ll_qe_tp_pri3_re)
        ,.func_mem_raddr      (func_aqed_ll_qe_tp_pri3_raddr)
        ,.func_mem_waddr      (func_aqed_ll_qe_tp_pri3_waddr)
        ,.func_mem_we         (func_aqed_ll_qe_tp_pri3_we)
        ,.func_mem_wdata      (func_aqed_ll_qe_tp_pri3_wdata)
        ,.func_mem_rdata      (func_aqed_ll_qe_tp_pri3_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_aqed_ll_qe_tp_pri3_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_aqed_ll_qe_tp_pri3_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_aqed_ll_qe_tp_pri3_re)
        ,.pf_mem_raddr        (pf_aqed_ll_qe_tp_pri3_raddr)
        ,.pf_mem_waddr        (pf_aqed_ll_qe_tp_pri3_waddr)
        ,.pf_mem_we           (pf_aqed_ll_qe_tp_pri3_we)
        ,.pf_mem_wdata        (pf_aqed_ll_qe_tp_pri3_wdata)
        ,.pf_mem_rdata        (pf_aqed_ll_qe_tp_pri3_rdata)

        ,.mem_wclk            (rf_aqed_ll_qe_tp_pri3_wclk)
        ,.mem_rclk            (rf_aqed_ll_qe_tp_pri3_rclk)
        ,.mem_wclk_rst_n      (rf_aqed_ll_qe_tp_pri3_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_aqed_ll_qe_tp_pri3_rclk_rst_n)
        ,.mem_re              (rf_aqed_ll_qe_tp_pri3_re)
        ,.mem_raddr           ({rf_aqed_ll_qe_tp_pri3_raddr_nc , rf_aqed_ll_qe_tp_pri3_raddr})
        ,.mem_waddr           ({rf_aqed_ll_qe_tp_pri3_waddr_nc , rf_aqed_ll_qe_tp_pri3_waddr})
        ,.mem_we              (rf_aqed_ll_qe_tp_pri3_we)
        ,.mem_wdata           (rf_aqed_ll_qe_tp_pri3_wdata)
        ,.mem_rdata           (rf_aqed_ll_qe_tp_pri3_rdata)

        ,.mem_rdata_error     (rf_aqed_ll_qe_tp_pri3_rdata_error)
        ,.error               (rf_aqed_ll_qe_tp_pri3_error)
);

logic [(       2)-1:0] rf_aqed_qid_cnt_raddr_nc ;
logic [(       2)-1:0] rf_aqed_qid_cnt_waddr_nc ;

logic        rf_aqed_qid_cnt_rdata_error;

logic        cfg_mem_ack_aqed_qid_cnt_nc;
logic [31:0] cfg_mem_rdata_aqed_qid_cnt_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (32)
        ,.DWIDTH              (15)
        ,.AWIDTHPAD           (2)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_aqed_qid_cnt (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_aqed_qid_cnt_re)
        ,.func_mem_raddr      (func_aqed_qid_cnt_raddr)
        ,.func_mem_waddr      (func_aqed_qid_cnt_waddr)
        ,.func_mem_we         (func_aqed_qid_cnt_we)
        ,.func_mem_wdata      (func_aqed_qid_cnt_wdata)
        ,.func_mem_rdata      (func_aqed_qid_cnt_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_aqed_qid_cnt_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_aqed_qid_cnt_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_aqed_qid_cnt_re)
        ,.pf_mem_raddr        (pf_aqed_qid_cnt_raddr)
        ,.pf_mem_waddr        (pf_aqed_qid_cnt_waddr)
        ,.pf_mem_we           (pf_aqed_qid_cnt_we)
        ,.pf_mem_wdata        (pf_aqed_qid_cnt_wdata)
        ,.pf_mem_rdata        (pf_aqed_qid_cnt_rdata)

        ,.mem_wclk            (rf_aqed_qid_cnt_wclk)
        ,.mem_rclk            (rf_aqed_qid_cnt_rclk)
        ,.mem_wclk_rst_n      (rf_aqed_qid_cnt_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_aqed_qid_cnt_rclk_rst_n)
        ,.mem_re              (rf_aqed_qid_cnt_re)
        ,.mem_raddr           ({rf_aqed_qid_cnt_raddr_nc , rf_aqed_qid_cnt_raddr})
        ,.mem_waddr           ({rf_aqed_qid_cnt_waddr_nc , rf_aqed_qid_cnt_waddr})
        ,.mem_we              (rf_aqed_qid_cnt_we)
        ,.mem_wdata           (rf_aqed_qid_cnt_wdata)
        ,.mem_rdata           (rf_aqed_qid_cnt_rdata)

        ,.mem_rdata_error     (rf_aqed_qid_cnt_rdata_error)
        ,.error               (rf_aqed_qid_cnt_error)
);

logic [(       2)-1:0] rf_aqed_qid_fid_limit_raddr_nc ;
logic [(       2)-1:0] rf_aqed_qid_fid_limit_waddr_nc ;

logic        rf_aqed_qid_fid_limit_rdata_error;

hqm_AW_rfrw_access #( 
         .DEPTH               (32)
        ,.DWIDTH              (14)
        ,.AWIDTHPAD           (2)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_aqed_qid_fid_limit (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_aqed_qid_fid_limit_re)
        ,.func_mem_addr       (func_aqed_qid_fid_limit_addr)
        ,.func_mem_we         (func_aqed_qid_fid_limit_we)
        ,.func_mem_wdata      (func_aqed_qid_fid_limit_wdata)
        ,.func_mem_rdata      (func_aqed_qid_fid_limit_rdata)

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

        ,.pf_mem_re           (pf_aqed_qid_fid_limit_re)
        ,.pf_mem_addr         (pf_aqed_qid_fid_limit_addr)
        ,.pf_mem_we           (pf_aqed_qid_fid_limit_we)
        ,.pf_mem_wdata        (pf_aqed_qid_fid_limit_wdata)
        ,.pf_mem_rdata        (pf_aqed_qid_fid_limit_rdata)

        ,.mem_wclk            (rf_aqed_qid_fid_limit_wclk)
        ,.mem_rclk            (rf_aqed_qid_fid_limit_rclk)
        ,.mem_wclk_rst_n      (rf_aqed_qid_fid_limit_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_aqed_qid_fid_limit_rclk_rst_n)
        ,.mem_re              (rf_aqed_qid_fid_limit_re)
        ,.mem_raddr           ({rf_aqed_qid_fid_limit_raddr_nc , rf_aqed_qid_fid_limit_raddr})
        ,.mem_waddr           ({rf_aqed_qid_fid_limit_waddr_nc , rf_aqed_qid_fid_limit_waddr})
        ,.mem_we              (rf_aqed_qid_fid_limit_we)
        ,.mem_wdata           (rf_aqed_qid_fid_limit_wdata)
        ,.mem_rdata           (rf_aqed_qid_fid_limit_rdata)

        ,.mem_rdata_error     (rf_aqed_qid_fid_limit_rdata_error)
        ,.error               (rf_aqed_qid_fid_limit_error)
);

logic        rf_rx_sync_qed_aqed_enq_rdata_error;

logic        cfg_mem_ack_rx_sync_qed_aqed_enq_nc;
logic [31:0] cfg_mem_rdata_rx_sync_qed_aqed_enq_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (4)
        ,.DWIDTH              (139)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_rx_sync_qed_aqed_enq (
         .clk                 (hqm_inp_gated_clk)
        ,.rst_n               (hqm_inp_gated_rst_n)

        ,.func_mem_re         (func_rx_sync_qed_aqed_enq_re)
        ,.func_mem_raddr      (func_rx_sync_qed_aqed_enq_raddr)
        ,.func_mem_waddr      (func_rx_sync_qed_aqed_enq_waddr)
        ,.func_mem_we         (func_rx_sync_qed_aqed_enq_we)
        ,.func_mem_wdata      (func_rx_sync_qed_aqed_enq_wdata)
        ,.func_mem_rdata      (func_rx_sync_qed_aqed_enq_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_rx_sync_qed_aqed_enq_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_rx_sync_qed_aqed_enq_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_rx_sync_qed_aqed_enq_re)
        ,.pf_mem_raddr        (pf_rx_sync_qed_aqed_enq_raddr)
        ,.pf_mem_waddr        (pf_rx_sync_qed_aqed_enq_waddr)
        ,.pf_mem_we           (pf_rx_sync_qed_aqed_enq_we)
        ,.pf_mem_wdata        (pf_rx_sync_qed_aqed_enq_wdata)
        ,.pf_mem_rdata        (pf_rx_sync_qed_aqed_enq_rdata)

        ,.mem_wclk            (rf_rx_sync_qed_aqed_enq_wclk)
        ,.mem_rclk            (rf_rx_sync_qed_aqed_enq_rclk)
        ,.mem_wclk_rst_n      (rf_rx_sync_qed_aqed_enq_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_rx_sync_qed_aqed_enq_rclk_rst_n)
        ,.mem_re              (rf_rx_sync_qed_aqed_enq_re)
        ,.mem_raddr           (rf_rx_sync_qed_aqed_enq_raddr)
        ,.mem_waddr           (rf_rx_sync_qed_aqed_enq_waddr)
        ,.mem_we              (rf_rx_sync_qed_aqed_enq_we)
        ,.mem_wdata           (rf_rx_sync_qed_aqed_enq_wdata)
        ,.mem_rdata           (rf_rx_sync_qed_aqed_enq_rdata)

        ,.mem_rdata_error     (rf_rx_sync_qed_aqed_enq_rdata_error)
        ,.error               (rf_rx_sync_qed_aqed_enq_error)
);

hqm_AW_srw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (139)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
) i_aqed ( 
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_aqed_re)
        ,.func_mem_addr       (func_aqed_addr)
        ,.func_mem_we         (func_aqed_we)
        ,.func_mem_wdata      (func_aqed_wdata)
        ,.func_mem_rdata      (func_aqed_rdata)

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

        ,.pf_mem_re           (pf_aqed_re)
        ,.pf_mem_addr         (pf_aqed_addr)
        ,.pf_mem_we           (pf_aqed_we)
        ,.pf_mem_wdata        (pf_aqed_wdata)
        ,.pf_mem_rdata        (pf_aqed_rdata)

        ,.mem_clk             (sr_aqed_clk)
        ,.mem_clk_rst_n       (sr_aqed_clk_rst_n)
        ,.mem_re              (sr_aqed_re)
        ,.mem_addr            (sr_aqed_addr)
        ,.mem_we              (sr_aqed_we)
        ,.mem_wdata           (sr_aqed_wdata)
        ,.mem_rdata           (sr_aqed_rdata)

        ,.error               (sr_aqed_error)
);


logic        cfg_mem_ack_aqed_freelist_nc;
logic [31:0] cfg_mem_rdata_aqed_freelist_nc;

hqm_AW_srw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (16)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
) i_aqed_freelist ( 
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_aqed_freelist_re)
        ,.func_mem_addr       (func_aqed_freelist_addr)
        ,.func_mem_we         (func_aqed_freelist_we)
        ,.func_mem_wdata      (func_aqed_freelist_wdata)
        ,.func_mem_rdata      (func_aqed_freelist_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_aqed_freelist_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_aqed_freelist_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_aqed_freelist_re)
        ,.pf_mem_addr         (pf_aqed_freelist_addr)
        ,.pf_mem_we           (pf_aqed_freelist_we)
        ,.pf_mem_wdata        (pf_aqed_freelist_wdata)
        ,.pf_mem_rdata        (pf_aqed_freelist_rdata)

        ,.mem_clk             (sr_aqed_freelist_clk)
        ,.mem_clk_rst_n       (sr_aqed_freelist_clk_rst_n)
        ,.mem_re              (sr_aqed_freelist_re)
        ,.mem_addr            (sr_aqed_freelist_addr)
        ,.mem_we              (sr_aqed_freelist_we)
        ,.mem_wdata           (sr_aqed_freelist_wdata)
        ,.mem_rdata           (sr_aqed_freelist_rdata)

        ,.error               (sr_aqed_freelist_error)
);


logic        cfg_mem_ack_aqed_ll_qe_hpnxt_nc;
logic [31:0] cfg_mem_rdata_aqed_ll_qe_hpnxt_nc;

hqm_AW_srw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (16)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
) i_aqed_ll_qe_hpnxt ( 
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_aqed_ll_qe_hpnxt_re)
        ,.func_mem_addr       (func_aqed_ll_qe_hpnxt_addr)
        ,.func_mem_we         (func_aqed_ll_qe_hpnxt_we)
        ,.func_mem_wdata      (func_aqed_ll_qe_hpnxt_wdata)
        ,.func_mem_rdata      (func_aqed_ll_qe_hpnxt_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_aqed_ll_qe_hpnxt_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_aqed_ll_qe_hpnxt_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_aqed_ll_qe_hpnxt_re)
        ,.pf_mem_addr         (pf_aqed_ll_qe_hpnxt_addr)
        ,.pf_mem_we           (pf_aqed_ll_qe_hpnxt_we)
        ,.pf_mem_wdata        (pf_aqed_ll_qe_hpnxt_wdata)
        ,.pf_mem_rdata        (pf_aqed_ll_qe_hpnxt_rdata)

        ,.mem_clk             (sr_aqed_ll_qe_hpnxt_clk)
        ,.mem_clk_rst_n       (sr_aqed_ll_qe_hpnxt_clk_rst_n)
        ,.mem_re              (sr_aqed_ll_qe_hpnxt_re)
        ,.mem_addr            (sr_aqed_ll_qe_hpnxt_addr)
        ,.mem_we              (sr_aqed_ll_qe_hpnxt_we)
        ,.mem_wdata           (sr_aqed_ll_qe_hpnxt_wdata)
        ,.mem_rdata           (sr_aqed_ll_qe_hpnxt_rdata)

        ,.error               (sr_aqed_ll_qe_hpnxt_error)
);


assign hqm_aqed_pipe_rfw_top_ipar_error = rf_aqed_fid_cnt_rdata_error | rf_aqed_fifo_ap_aqed_rdata_error | rf_aqed_fifo_aqed_ap_enq_rdata_error | rf_aqed_fifo_aqed_chp_sch_rdata_error | rf_aqed_fifo_freelist_return_rdata_error | rf_aqed_fifo_lsp_aqed_cmp_rdata_error | rf_aqed_fifo_qed_aqed_enq_rdata_error | rf_aqed_fifo_qed_aqed_enq_fid_rdata_error | rf_aqed_ll_cnt_pri0_rdata_error | rf_aqed_ll_cnt_pri1_rdata_error | rf_aqed_ll_cnt_pri2_rdata_error | rf_aqed_ll_cnt_pri3_rdata_error | rf_aqed_ll_qe_hp_pri0_rdata_error | rf_aqed_ll_qe_hp_pri1_rdata_error | rf_aqed_ll_qe_hp_pri2_rdata_error | rf_aqed_ll_qe_hp_pri3_rdata_error | rf_aqed_ll_qe_tp_pri0_rdata_error | rf_aqed_ll_qe_tp_pri1_rdata_error | rf_aqed_ll_qe_tp_pri2_rdata_error | rf_aqed_ll_qe_tp_pri3_rdata_error | rf_aqed_qid_cnt_rdata_error | rf_aqed_qid_fid_limit_rdata_error | rf_rx_sync_qed_aqed_enq_rdata_error ;

endmodule

