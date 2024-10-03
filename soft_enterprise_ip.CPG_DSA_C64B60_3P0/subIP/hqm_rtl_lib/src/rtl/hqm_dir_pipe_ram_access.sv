module hqm_dir_pipe_ram_access
     import hqm_AW_pkg::* , hqm_pkg::* , hqm_core_pkg::*;
(
     input  logic                  hqm_gated_clk
    ,input  logic                  hqm_inp_gated_clk

    ,input  logic                  hqm_gated_rst_n
    ,input  logic                  hqm_inp_gated_rst_n

    ,input  logic [(  1 *  1)-1:0] cfg_mem_re          // lintra s-0527
    ,input  logic [(  1 *  1)-1:0] cfg_mem_we          // lintra s-0527
    ,input  logic [(      20)-1:0] cfg_mem_addr        // lintra s-0527
    ,input  logic [(      12)-1:0] cfg_mem_minbit      // lintra s-0527
    ,input  logic [(      12)-1:0] cfg_mem_maxbit      // lintra s-0527
    ,input  logic [(      32)-1:0] cfg_mem_wdata       // lintra s-0527
    ,output logic [(  1 * 32)-1:0] cfg_mem_rdata
    ,output logic [(  1 *  1)-1:0] cfg_mem_ack
    ,input  logic                  cfg_mem_cc_v        // lintra s-0527
    ,input  logic [(       8)-1:0] cfg_mem_cc_value    // lintra s-0527
    ,input  logic [(       4)-1:0] cfg_mem_cc_width    // lintra s-0527
    ,input  logic [(      12)-1:0] cfg_mem_cc_position // lintra s-0527

    ,output logic                  hqm_dir_pipe_rfw_top_ipar_error

    ,input  logic                  func_dir_cnt_re
    ,input  logic [(       7)-1:0] func_dir_cnt_raddr
    ,input  logic [(       7)-1:0] func_dir_cnt_waddr
    ,input  logic                  func_dir_cnt_we
    ,input  logic [(      68)-1:0] func_dir_cnt_wdata
    ,output logic [(      68)-1:0] func_dir_cnt_rdata

    ,input  logic                  pf_dir_cnt_re
    ,input  logic [(       7)-1:0] pf_dir_cnt_raddr
    ,input  logic [(       7)-1:0] pf_dir_cnt_waddr
    ,input  logic                  pf_dir_cnt_we
    ,input  logic [(      68)-1:0] pf_dir_cnt_wdata
    ,output logic [(      68)-1:0] pf_dir_cnt_rdata

    ,output logic                  rf_dir_cnt_re
    ,output logic                  rf_dir_cnt_rclk
    ,output logic                  rf_dir_cnt_rclk_rst_n
    ,output logic [(       6)-1:0] rf_dir_cnt_raddr
    ,output logic [(       6)-1:0] rf_dir_cnt_waddr
    ,output logic                  rf_dir_cnt_we
    ,output logic                  rf_dir_cnt_wclk
    ,output logic                  rf_dir_cnt_wclk_rst_n
    ,output logic [(      68)-1:0] rf_dir_cnt_wdata
    ,input  logic [(      68)-1:0] rf_dir_cnt_rdata

    ,output logic                  rf_dir_cnt_error

    ,input  logic                  func_dir_hp_re
    ,input  logic [(      10)-1:0] func_dir_hp_raddr
    ,input  logic [(      10)-1:0] func_dir_hp_waddr
    ,input  logic                  func_dir_hp_we
    ,input  logic [(      15)-1:0] func_dir_hp_wdata
    ,output logic [(      15)-1:0] func_dir_hp_rdata

    ,input  logic                  pf_dir_hp_re
    ,input  logic [(      10)-1:0] pf_dir_hp_raddr
    ,input  logic [(      10)-1:0] pf_dir_hp_waddr
    ,input  logic                  pf_dir_hp_we
    ,input  logic [(      15)-1:0] pf_dir_hp_wdata
    ,output logic [(      15)-1:0] pf_dir_hp_rdata

    ,output logic                  rf_dir_hp_re
    ,output logic                  rf_dir_hp_rclk
    ,output logic                  rf_dir_hp_rclk_rst_n
    ,output logic [(       8)-1:0] rf_dir_hp_raddr
    ,output logic [(       8)-1:0] rf_dir_hp_waddr
    ,output logic                  rf_dir_hp_we
    ,output logic                  rf_dir_hp_wclk
    ,output logic                  rf_dir_hp_wclk_rst_n
    ,output logic [(      15)-1:0] rf_dir_hp_wdata
    ,input  logic [(      15)-1:0] rf_dir_hp_rdata

    ,output logic                  rf_dir_hp_error

    ,input  logic                  func_dir_replay_cnt_re
    ,input  logic [(       7)-1:0] func_dir_replay_cnt_raddr
    ,input  logic [(       7)-1:0] func_dir_replay_cnt_waddr
    ,input  logic                  func_dir_replay_cnt_we
    ,input  logic [(      68)-1:0] func_dir_replay_cnt_wdata
    ,output logic [(      68)-1:0] func_dir_replay_cnt_rdata

    ,input  logic                  pf_dir_replay_cnt_re
    ,input  logic [(       7)-1:0] pf_dir_replay_cnt_raddr
    ,input  logic [(       7)-1:0] pf_dir_replay_cnt_waddr
    ,input  logic                  pf_dir_replay_cnt_we
    ,input  logic [(      68)-1:0] pf_dir_replay_cnt_wdata
    ,output logic [(      68)-1:0] pf_dir_replay_cnt_rdata

    ,output logic                  rf_dir_replay_cnt_re
    ,output logic                  rf_dir_replay_cnt_rclk
    ,output logic                  rf_dir_replay_cnt_rclk_rst_n
    ,output logic [(       5)-1:0] rf_dir_replay_cnt_raddr
    ,output logic [(       5)-1:0] rf_dir_replay_cnt_waddr
    ,output logic                  rf_dir_replay_cnt_we
    ,output logic                  rf_dir_replay_cnt_wclk
    ,output logic                  rf_dir_replay_cnt_wclk_rst_n
    ,output logic [(      68)-1:0] rf_dir_replay_cnt_wdata
    ,input  logic [(      68)-1:0] rf_dir_replay_cnt_rdata

    ,output logic                  rf_dir_replay_cnt_error

    ,input  logic                  func_dir_replay_hp_re
    ,input  logic [(      10)-1:0] func_dir_replay_hp_raddr
    ,input  logic [(      10)-1:0] func_dir_replay_hp_waddr
    ,input  logic                  func_dir_replay_hp_we
    ,input  logic [(      15)-1:0] func_dir_replay_hp_wdata
    ,output logic [(      15)-1:0] func_dir_replay_hp_rdata

    ,input  logic                  pf_dir_replay_hp_re
    ,input  logic [(      10)-1:0] pf_dir_replay_hp_raddr
    ,input  logic [(      10)-1:0] pf_dir_replay_hp_waddr
    ,input  logic                  pf_dir_replay_hp_we
    ,input  logic [(      15)-1:0] pf_dir_replay_hp_wdata
    ,output logic [(      15)-1:0] pf_dir_replay_hp_rdata

    ,output logic                  rf_dir_replay_hp_re
    ,output logic                  rf_dir_replay_hp_rclk
    ,output logic                  rf_dir_replay_hp_rclk_rst_n
    ,output logic [(       7)-1:0] rf_dir_replay_hp_raddr
    ,output logic [(       7)-1:0] rf_dir_replay_hp_waddr
    ,output logic                  rf_dir_replay_hp_we
    ,output logic                  rf_dir_replay_hp_wclk
    ,output logic                  rf_dir_replay_hp_wclk_rst_n
    ,output logic [(      15)-1:0] rf_dir_replay_hp_wdata
    ,input  logic [(      15)-1:0] rf_dir_replay_hp_rdata

    ,output logic                  rf_dir_replay_hp_error

    ,input  logic                  func_dir_replay_tp_re
    ,input  logic [(      10)-1:0] func_dir_replay_tp_raddr
    ,input  logic [(      10)-1:0] func_dir_replay_tp_waddr
    ,input  logic                  func_dir_replay_tp_we
    ,input  logic [(      15)-1:0] func_dir_replay_tp_wdata
    ,output logic [(      15)-1:0] func_dir_replay_tp_rdata

    ,input  logic                  pf_dir_replay_tp_re
    ,input  logic [(      10)-1:0] pf_dir_replay_tp_raddr
    ,input  logic [(      10)-1:0] pf_dir_replay_tp_waddr
    ,input  logic                  pf_dir_replay_tp_we
    ,input  logic [(      15)-1:0] pf_dir_replay_tp_wdata
    ,output logic [(      15)-1:0] pf_dir_replay_tp_rdata

    ,output logic                  rf_dir_replay_tp_re
    ,output logic                  rf_dir_replay_tp_rclk
    ,output logic                  rf_dir_replay_tp_rclk_rst_n
    ,output logic [(       7)-1:0] rf_dir_replay_tp_raddr
    ,output logic [(       7)-1:0] rf_dir_replay_tp_waddr
    ,output logic                  rf_dir_replay_tp_we
    ,output logic                  rf_dir_replay_tp_wclk
    ,output logic                  rf_dir_replay_tp_wclk_rst_n
    ,output logic [(      15)-1:0] rf_dir_replay_tp_wdata
    ,input  logic [(      15)-1:0] rf_dir_replay_tp_rdata

    ,output logic                  rf_dir_replay_tp_error

    ,input  logic                  func_dir_rofrag_cnt_re
    ,input  logic [(       9)-1:0] func_dir_rofrag_cnt_raddr
    ,input  logic [(       9)-1:0] func_dir_rofrag_cnt_waddr
    ,input  logic                  func_dir_rofrag_cnt_we
    ,input  logic [(      17)-1:0] func_dir_rofrag_cnt_wdata
    ,output logic [(      17)-1:0] func_dir_rofrag_cnt_rdata

    ,input  logic                  pf_dir_rofrag_cnt_re
    ,input  logic [(       9)-1:0] pf_dir_rofrag_cnt_raddr
    ,input  logic [(       9)-1:0] pf_dir_rofrag_cnt_waddr
    ,input  logic                  pf_dir_rofrag_cnt_we
    ,input  logic [(      17)-1:0] pf_dir_rofrag_cnt_wdata
    ,output logic [(      17)-1:0] pf_dir_rofrag_cnt_rdata

    ,output logic                  rf_dir_rofrag_cnt_re
    ,output logic                  rf_dir_rofrag_cnt_rclk
    ,output logic                  rf_dir_rofrag_cnt_rclk_rst_n
    ,output logic [(       9)-1:0] rf_dir_rofrag_cnt_raddr
    ,output logic [(       9)-1:0] rf_dir_rofrag_cnt_waddr
    ,output logic                  rf_dir_rofrag_cnt_we
    ,output logic                  rf_dir_rofrag_cnt_wclk
    ,output logic                  rf_dir_rofrag_cnt_wclk_rst_n
    ,output logic [(      17)-1:0] rf_dir_rofrag_cnt_wdata
    ,input  logic [(      17)-1:0] rf_dir_rofrag_cnt_rdata

    ,output logic                  rf_dir_rofrag_cnt_error

    ,input  logic                  func_dir_rofrag_hp_re
    ,input  logic [(       9)-1:0] func_dir_rofrag_hp_raddr
    ,input  logic [(       9)-1:0] func_dir_rofrag_hp_waddr
    ,input  logic                  func_dir_rofrag_hp_we
    ,input  logic [(      15)-1:0] func_dir_rofrag_hp_wdata
    ,output logic [(      15)-1:0] func_dir_rofrag_hp_rdata

    ,input  logic                  pf_dir_rofrag_hp_re
    ,input  logic [(       9)-1:0] pf_dir_rofrag_hp_raddr
    ,input  logic [(       9)-1:0] pf_dir_rofrag_hp_waddr
    ,input  logic                  pf_dir_rofrag_hp_we
    ,input  logic [(      15)-1:0] pf_dir_rofrag_hp_wdata
    ,output logic [(      15)-1:0] pf_dir_rofrag_hp_rdata

    ,output logic                  rf_dir_rofrag_hp_re
    ,output logic                  rf_dir_rofrag_hp_rclk
    ,output logic                  rf_dir_rofrag_hp_rclk_rst_n
    ,output logic [(       9)-1:0] rf_dir_rofrag_hp_raddr
    ,output logic [(       9)-1:0] rf_dir_rofrag_hp_waddr
    ,output logic                  rf_dir_rofrag_hp_we
    ,output logic                  rf_dir_rofrag_hp_wclk
    ,output logic                  rf_dir_rofrag_hp_wclk_rst_n
    ,output logic [(      15)-1:0] rf_dir_rofrag_hp_wdata
    ,input  logic [(      15)-1:0] rf_dir_rofrag_hp_rdata

    ,output logic                  rf_dir_rofrag_hp_error

    ,input  logic                  func_dir_rofrag_tp_re
    ,input  logic [(       9)-1:0] func_dir_rofrag_tp_raddr
    ,input  logic [(       9)-1:0] func_dir_rofrag_tp_waddr
    ,input  logic                  func_dir_rofrag_tp_we
    ,input  logic [(      15)-1:0] func_dir_rofrag_tp_wdata
    ,output logic [(      15)-1:0] func_dir_rofrag_tp_rdata

    ,input  logic                  pf_dir_rofrag_tp_re
    ,input  logic [(       9)-1:0] pf_dir_rofrag_tp_raddr
    ,input  logic [(       9)-1:0] pf_dir_rofrag_tp_waddr
    ,input  logic                  pf_dir_rofrag_tp_we
    ,input  logic [(      15)-1:0] pf_dir_rofrag_tp_wdata
    ,output logic [(      15)-1:0] pf_dir_rofrag_tp_rdata

    ,output logic                  rf_dir_rofrag_tp_re
    ,output logic                  rf_dir_rofrag_tp_rclk
    ,output logic                  rf_dir_rofrag_tp_rclk_rst_n
    ,output logic [(       9)-1:0] rf_dir_rofrag_tp_raddr
    ,output logic [(       9)-1:0] rf_dir_rofrag_tp_waddr
    ,output logic                  rf_dir_rofrag_tp_we
    ,output logic                  rf_dir_rofrag_tp_wclk
    ,output logic                  rf_dir_rofrag_tp_wclk_rst_n
    ,output logic [(      15)-1:0] rf_dir_rofrag_tp_wdata
    ,input  logic [(      15)-1:0] rf_dir_rofrag_tp_rdata

    ,output logic                  rf_dir_rofrag_tp_error

    ,input  logic                  func_dir_tp_re
    ,input  logic [(      10)-1:0] func_dir_tp_raddr
    ,input  logic [(      10)-1:0] func_dir_tp_waddr
    ,input  logic                  func_dir_tp_we
    ,input  logic [(      15)-1:0] func_dir_tp_wdata
    ,output logic [(      15)-1:0] func_dir_tp_rdata

    ,input  logic                  pf_dir_tp_re
    ,input  logic [(      10)-1:0] pf_dir_tp_raddr
    ,input  logic [(      10)-1:0] pf_dir_tp_waddr
    ,input  logic                  pf_dir_tp_we
    ,input  logic [(      15)-1:0] pf_dir_tp_wdata
    ,output logic [(      15)-1:0] pf_dir_tp_rdata

    ,output logic                  rf_dir_tp_re
    ,output logic                  rf_dir_tp_rclk
    ,output logic                  rf_dir_tp_rclk_rst_n
    ,output logic [(       8)-1:0] rf_dir_tp_raddr
    ,output logic [(       8)-1:0] rf_dir_tp_waddr
    ,output logic                  rf_dir_tp_we
    ,output logic                  rf_dir_tp_wclk
    ,output logic                  rf_dir_tp_wclk_rst_n
    ,output logic [(      15)-1:0] rf_dir_tp_wdata
    ,input  logic [(      15)-1:0] rf_dir_tp_rdata

    ,output logic                  rf_dir_tp_error

    ,input  logic                  func_dp_dqed_re
    ,input  logic [(       5)-1:0] func_dp_dqed_raddr
    ,input  logic [(       5)-1:0] func_dp_dqed_waddr
    ,input  logic                  func_dp_dqed_we
    ,input  logic [(      45)-1:0] func_dp_dqed_wdata
    ,output logic [(      45)-1:0] func_dp_dqed_rdata

    ,input  logic                  pf_dp_dqed_re
    ,input  logic [(       5)-1:0] pf_dp_dqed_raddr
    ,input  logic [(       5)-1:0] pf_dp_dqed_waddr
    ,input  logic                  pf_dp_dqed_we
    ,input  logic [(      45)-1:0] pf_dp_dqed_wdata
    ,output logic [(      45)-1:0] pf_dp_dqed_rdata

    ,output logic                  rf_dp_dqed_re
    ,output logic                  rf_dp_dqed_rclk
    ,output logic                  rf_dp_dqed_rclk_rst_n
    ,output logic [(       5)-1:0] rf_dp_dqed_raddr
    ,output logic [(       5)-1:0] rf_dp_dqed_waddr
    ,output logic                  rf_dp_dqed_we
    ,output logic                  rf_dp_dqed_wclk
    ,output logic                  rf_dp_dqed_wclk_rst_n
    ,output logic [(      45)-1:0] rf_dp_dqed_wdata
    ,input  logic [(      45)-1:0] rf_dp_dqed_rdata

    ,output logic                  rf_dp_dqed_error

    ,input  logic                  func_dp_lsp_enq_dir_re
    ,input  logic [(       4)-1:0] func_dp_lsp_enq_dir_raddr
    ,input  logic [(       4)-1:0] func_dp_lsp_enq_dir_waddr
    ,input  logic                  func_dp_lsp_enq_dir_we
    ,input  logic [(       8)-1:0] func_dp_lsp_enq_dir_wdata
    ,output logic [(       8)-1:0] func_dp_lsp_enq_dir_rdata

    ,input  logic                  pf_dp_lsp_enq_dir_re
    ,input  logic [(       4)-1:0] pf_dp_lsp_enq_dir_raddr
    ,input  logic [(       4)-1:0] pf_dp_lsp_enq_dir_waddr
    ,input  logic                  pf_dp_lsp_enq_dir_we
    ,input  logic [(       8)-1:0] pf_dp_lsp_enq_dir_wdata
    ,output logic [(       8)-1:0] pf_dp_lsp_enq_dir_rdata

    ,output logic                  rf_dp_lsp_enq_dir_re
    ,output logic                  rf_dp_lsp_enq_dir_rclk
    ,output logic                  rf_dp_lsp_enq_dir_rclk_rst_n
    ,output logic [(       4)-1:0] rf_dp_lsp_enq_dir_raddr
    ,output logic [(       4)-1:0] rf_dp_lsp_enq_dir_waddr
    ,output logic                  rf_dp_lsp_enq_dir_we
    ,output logic                  rf_dp_lsp_enq_dir_wclk
    ,output logic                  rf_dp_lsp_enq_dir_wclk_rst_n
    ,output logic [(       8)-1:0] rf_dp_lsp_enq_dir_wdata
    ,input  logic [(       8)-1:0] rf_dp_lsp_enq_dir_rdata

    ,output logic                  rf_dp_lsp_enq_dir_error

    ,input  logic                  func_dp_lsp_enq_rorply_re
    ,input  logic [(       4)-1:0] func_dp_lsp_enq_rorply_raddr
    ,input  logic [(       4)-1:0] func_dp_lsp_enq_rorply_waddr
    ,input  logic                  func_dp_lsp_enq_rorply_we
    ,input  logic [(      23)-1:0] func_dp_lsp_enq_rorply_wdata
    ,output logic [(      23)-1:0] func_dp_lsp_enq_rorply_rdata

    ,input  logic                  pf_dp_lsp_enq_rorply_re
    ,input  logic [(       4)-1:0] pf_dp_lsp_enq_rorply_raddr
    ,input  logic [(       4)-1:0] pf_dp_lsp_enq_rorply_waddr
    ,input  logic                  pf_dp_lsp_enq_rorply_we
    ,input  logic [(      23)-1:0] pf_dp_lsp_enq_rorply_wdata
    ,output logic [(      23)-1:0] pf_dp_lsp_enq_rorply_rdata

    ,output logic                  rf_dp_lsp_enq_rorply_re
    ,output logic                  rf_dp_lsp_enq_rorply_rclk
    ,output logic                  rf_dp_lsp_enq_rorply_rclk_rst_n
    ,output logic [(       4)-1:0] rf_dp_lsp_enq_rorply_raddr
    ,output logic [(       4)-1:0] rf_dp_lsp_enq_rorply_waddr
    ,output logic                  rf_dp_lsp_enq_rorply_we
    ,output logic                  rf_dp_lsp_enq_rorply_wclk
    ,output logic                  rf_dp_lsp_enq_rorply_wclk_rst_n
    ,output logic [(      23)-1:0] rf_dp_lsp_enq_rorply_wdata
    ,input  logic [(      23)-1:0] rf_dp_lsp_enq_rorply_rdata

    ,output logic                  rf_dp_lsp_enq_rorply_error

    ,input  logic                  func_lsp_dp_sch_dir_re
    ,input  logic [(       2)-1:0] func_lsp_dp_sch_dir_raddr
    ,input  logic [(       2)-1:0] func_lsp_dp_sch_dir_waddr
    ,input  logic                  func_lsp_dp_sch_dir_we
    ,input  logic [(      27)-1:0] func_lsp_dp_sch_dir_wdata
    ,output logic [(      27)-1:0] func_lsp_dp_sch_dir_rdata

    ,input  logic                  pf_lsp_dp_sch_dir_re
    ,input  logic [(       2)-1:0] pf_lsp_dp_sch_dir_raddr
    ,input  logic [(       2)-1:0] pf_lsp_dp_sch_dir_waddr
    ,input  logic                  pf_lsp_dp_sch_dir_we
    ,input  logic [(      27)-1:0] pf_lsp_dp_sch_dir_wdata
    ,output logic [(      27)-1:0] pf_lsp_dp_sch_dir_rdata

    ,output logic                  rf_lsp_dp_sch_dir_re
    ,output logic                  rf_lsp_dp_sch_dir_rclk
    ,output logic                  rf_lsp_dp_sch_dir_rclk_rst_n
    ,output logic [(       2)-1:0] rf_lsp_dp_sch_dir_raddr
    ,output logic [(       2)-1:0] rf_lsp_dp_sch_dir_waddr
    ,output logic                  rf_lsp_dp_sch_dir_we
    ,output logic                  rf_lsp_dp_sch_dir_wclk
    ,output logic                  rf_lsp_dp_sch_dir_wclk_rst_n
    ,output logic [(      27)-1:0] rf_lsp_dp_sch_dir_wdata
    ,input  logic [(      27)-1:0] rf_lsp_dp_sch_dir_rdata

    ,output logic                  rf_lsp_dp_sch_dir_error

    ,input  logic                  func_lsp_dp_sch_rorply_re
    ,input  logic [(       2)-1:0] func_lsp_dp_sch_rorply_raddr
    ,input  logic [(       2)-1:0] func_lsp_dp_sch_rorply_waddr
    ,input  logic                  func_lsp_dp_sch_rorply_we
    ,input  logic [(       8)-1:0] func_lsp_dp_sch_rorply_wdata
    ,output logic [(       8)-1:0] func_lsp_dp_sch_rorply_rdata

    ,input  logic                  pf_lsp_dp_sch_rorply_re
    ,input  logic [(       2)-1:0] pf_lsp_dp_sch_rorply_raddr
    ,input  logic [(       2)-1:0] pf_lsp_dp_sch_rorply_waddr
    ,input  logic                  pf_lsp_dp_sch_rorply_we
    ,input  logic [(       8)-1:0] pf_lsp_dp_sch_rorply_wdata
    ,output logic [(       8)-1:0] pf_lsp_dp_sch_rorply_rdata

    ,output logic                  rf_lsp_dp_sch_rorply_re
    ,output logic                  rf_lsp_dp_sch_rorply_rclk
    ,output logic                  rf_lsp_dp_sch_rorply_rclk_rst_n
    ,output logic [(       2)-1:0] rf_lsp_dp_sch_rorply_raddr
    ,output logic [(       2)-1:0] rf_lsp_dp_sch_rorply_waddr
    ,output logic                  rf_lsp_dp_sch_rorply_we
    ,output logic                  rf_lsp_dp_sch_rorply_wclk
    ,output logic                  rf_lsp_dp_sch_rorply_wclk_rst_n
    ,output logic [(       8)-1:0] rf_lsp_dp_sch_rorply_wdata
    ,input  logic [(       8)-1:0] rf_lsp_dp_sch_rorply_rdata

    ,output logic                  rf_lsp_dp_sch_rorply_error

    ,input  logic                  func_rop_dp_enq_dir_re
    ,input  logic [(       2)-1:0] func_rop_dp_enq_dir_raddr
    ,input  logic [(       2)-1:0] func_rop_dp_enq_dir_waddr
    ,input  logic                  func_rop_dp_enq_dir_we
    ,input  logic [(     100)-1:0] func_rop_dp_enq_dir_wdata
    ,output logic [(     100)-1:0] func_rop_dp_enq_dir_rdata

    ,input  logic                  pf_rop_dp_enq_dir_re
    ,input  logic [(       2)-1:0] pf_rop_dp_enq_dir_raddr
    ,input  logic [(       2)-1:0] pf_rop_dp_enq_dir_waddr
    ,input  logic                  pf_rop_dp_enq_dir_we
    ,input  logic [(     100)-1:0] pf_rop_dp_enq_dir_wdata
    ,output logic [(     100)-1:0] pf_rop_dp_enq_dir_rdata

    ,output logic                  rf_rop_dp_enq_dir_re
    ,output logic                  rf_rop_dp_enq_dir_rclk
    ,output logic                  rf_rop_dp_enq_dir_rclk_rst_n
    ,output logic [(       2)-1:0] rf_rop_dp_enq_dir_raddr
    ,output logic [(       2)-1:0] rf_rop_dp_enq_dir_waddr
    ,output logic                  rf_rop_dp_enq_dir_we
    ,output logic                  rf_rop_dp_enq_dir_wclk
    ,output logic                  rf_rop_dp_enq_dir_wclk_rst_n
    ,output logic [(     100)-1:0] rf_rop_dp_enq_dir_wdata
    ,input  logic [(     100)-1:0] rf_rop_dp_enq_dir_rdata

    ,output logic                  rf_rop_dp_enq_dir_error

    ,input  logic                  func_rop_dp_enq_ro_re
    ,input  logic [(       2)-1:0] func_rop_dp_enq_ro_raddr
    ,input  logic [(       2)-1:0] func_rop_dp_enq_ro_waddr
    ,input  logic                  func_rop_dp_enq_ro_we
    ,input  logic [(     100)-1:0] func_rop_dp_enq_ro_wdata
    ,output logic [(     100)-1:0] func_rop_dp_enq_ro_rdata

    ,input  logic                  pf_rop_dp_enq_ro_re
    ,input  logic [(       2)-1:0] pf_rop_dp_enq_ro_raddr
    ,input  logic [(       2)-1:0] pf_rop_dp_enq_ro_waddr
    ,input  logic                  pf_rop_dp_enq_ro_we
    ,input  logic [(     100)-1:0] pf_rop_dp_enq_ro_wdata
    ,output logic [(     100)-1:0] pf_rop_dp_enq_ro_rdata

    ,output logic                  rf_rop_dp_enq_ro_re
    ,output logic                  rf_rop_dp_enq_ro_rclk
    ,output logic                  rf_rop_dp_enq_ro_rclk_rst_n
    ,output logic [(       2)-1:0] rf_rop_dp_enq_ro_raddr
    ,output logic [(       2)-1:0] rf_rop_dp_enq_ro_waddr
    ,output logic                  rf_rop_dp_enq_ro_we
    ,output logic                  rf_rop_dp_enq_ro_wclk
    ,output logic                  rf_rop_dp_enq_ro_wclk_rst_n
    ,output logic [(     100)-1:0] rf_rop_dp_enq_ro_wdata
    ,input  logic [(     100)-1:0] rf_rop_dp_enq_ro_rdata

    ,output logic                  rf_rop_dp_enq_ro_error

    ,input  logic                  func_rx_sync_lsp_dp_sch_dir_re
    ,input  logic [(       2)-1:0] func_rx_sync_lsp_dp_sch_dir_raddr
    ,input  logic [(       2)-1:0] func_rx_sync_lsp_dp_sch_dir_waddr
    ,input  logic                  func_rx_sync_lsp_dp_sch_dir_we
    ,input  logic [(      27)-1:0] func_rx_sync_lsp_dp_sch_dir_wdata
    ,output logic [(      27)-1:0] func_rx_sync_lsp_dp_sch_dir_rdata

    ,input  logic                  pf_rx_sync_lsp_dp_sch_dir_re
    ,input  logic [(       2)-1:0] pf_rx_sync_lsp_dp_sch_dir_raddr
    ,input  logic [(       2)-1:0] pf_rx_sync_lsp_dp_sch_dir_waddr
    ,input  logic                  pf_rx_sync_lsp_dp_sch_dir_we
    ,input  logic [(      27)-1:0] pf_rx_sync_lsp_dp_sch_dir_wdata
    ,output logic [(      27)-1:0] pf_rx_sync_lsp_dp_sch_dir_rdata

    ,output logic                  rf_rx_sync_lsp_dp_sch_dir_re
    ,output logic                  rf_rx_sync_lsp_dp_sch_dir_rclk
    ,output logic                  rf_rx_sync_lsp_dp_sch_dir_rclk_rst_n
    ,output logic [(       2)-1:0] rf_rx_sync_lsp_dp_sch_dir_raddr
    ,output logic [(       2)-1:0] rf_rx_sync_lsp_dp_sch_dir_waddr
    ,output logic                  rf_rx_sync_lsp_dp_sch_dir_we
    ,output logic                  rf_rx_sync_lsp_dp_sch_dir_wclk
    ,output logic                  rf_rx_sync_lsp_dp_sch_dir_wclk_rst_n
    ,output logic [(      27)-1:0] rf_rx_sync_lsp_dp_sch_dir_wdata
    ,input  logic [(      27)-1:0] rf_rx_sync_lsp_dp_sch_dir_rdata

    ,output logic                  rf_rx_sync_lsp_dp_sch_dir_error

    ,input  logic                  func_rx_sync_lsp_dp_sch_rorply_re
    ,input  logic [(       2)-1:0] func_rx_sync_lsp_dp_sch_rorply_raddr
    ,input  logic [(       2)-1:0] func_rx_sync_lsp_dp_sch_rorply_waddr
    ,input  logic                  func_rx_sync_lsp_dp_sch_rorply_we
    ,input  logic [(       8)-1:0] func_rx_sync_lsp_dp_sch_rorply_wdata
    ,output logic [(       8)-1:0] func_rx_sync_lsp_dp_sch_rorply_rdata

    ,input  logic                  pf_rx_sync_lsp_dp_sch_rorply_re
    ,input  logic [(       2)-1:0] pf_rx_sync_lsp_dp_sch_rorply_raddr
    ,input  logic [(       2)-1:0] pf_rx_sync_lsp_dp_sch_rorply_waddr
    ,input  logic                  pf_rx_sync_lsp_dp_sch_rorply_we
    ,input  logic [(       8)-1:0] pf_rx_sync_lsp_dp_sch_rorply_wdata
    ,output logic [(       8)-1:0] pf_rx_sync_lsp_dp_sch_rorply_rdata

    ,output logic                  rf_rx_sync_lsp_dp_sch_rorply_re
    ,output logic                  rf_rx_sync_lsp_dp_sch_rorply_rclk
    ,output logic                  rf_rx_sync_lsp_dp_sch_rorply_rclk_rst_n
    ,output logic [(       2)-1:0] rf_rx_sync_lsp_dp_sch_rorply_raddr
    ,output logic [(       2)-1:0] rf_rx_sync_lsp_dp_sch_rorply_waddr
    ,output logic                  rf_rx_sync_lsp_dp_sch_rorply_we
    ,output logic                  rf_rx_sync_lsp_dp_sch_rorply_wclk
    ,output logic                  rf_rx_sync_lsp_dp_sch_rorply_wclk_rst_n
    ,output logic [(       8)-1:0] rf_rx_sync_lsp_dp_sch_rorply_wdata
    ,input  logic [(       8)-1:0] rf_rx_sync_lsp_dp_sch_rorply_rdata

    ,output logic                  rf_rx_sync_lsp_dp_sch_rorply_error

    ,input  logic                  func_rx_sync_rop_dp_enq_re
    ,input  logic [(       2)-1:0] func_rx_sync_rop_dp_enq_raddr
    ,input  logic [(       2)-1:0] func_rx_sync_rop_dp_enq_waddr
    ,input  logic                  func_rx_sync_rop_dp_enq_we
    ,input  logic [(     100)-1:0] func_rx_sync_rop_dp_enq_wdata
    ,output logic [(     100)-1:0] func_rx_sync_rop_dp_enq_rdata

    ,input  logic                  pf_rx_sync_rop_dp_enq_re
    ,input  logic [(       2)-1:0] pf_rx_sync_rop_dp_enq_raddr
    ,input  logic [(       2)-1:0] pf_rx_sync_rop_dp_enq_waddr
    ,input  logic                  pf_rx_sync_rop_dp_enq_we
    ,input  logic [(     100)-1:0] pf_rx_sync_rop_dp_enq_wdata
    ,output logic [(     100)-1:0] pf_rx_sync_rop_dp_enq_rdata

    ,output logic                  rf_rx_sync_rop_dp_enq_re
    ,output logic                  rf_rx_sync_rop_dp_enq_rclk
    ,output logic                  rf_rx_sync_rop_dp_enq_rclk_rst_n
    ,output logic [(       2)-1:0] rf_rx_sync_rop_dp_enq_raddr
    ,output logic [(       2)-1:0] rf_rx_sync_rop_dp_enq_waddr
    ,output logic                  rf_rx_sync_rop_dp_enq_we
    ,output logic                  rf_rx_sync_rop_dp_enq_wclk
    ,output logic                  rf_rx_sync_rop_dp_enq_wclk_rst_n
    ,output logic [(     100)-1:0] rf_rx_sync_rop_dp_enq_wdata
    ,input  logic [(     100)-1:0] rf_rx_sync_rop_dp_enq_rdata

    ,output logic                  rf_rx_sync_rop_dp_enq_error

    ,input  logic                  func_dir_nxthp_re
    ,input  logic [(      14)-1:0] func_dir_nxthp_addr
    ,input  logic                  func_dir_nxthp_we
    ,input  logic [(      21)-1:0] func_dir_nxthp_wdata
    ,output logic [(      21)-1:0] func_dir_nxthp_rdata

    ,input  logic                  pf_dir_nxthp_re
    ,input  logic [(      14)-1:0] pf_dir_nxthp_addr
    ,input  logic                  pf_dir_nxthp_we
    ,input  logic [(      21)-1:0] pf_dir_nxthp_wdata
    ,output logic [(      21)-1:0] pf_dir_nxthp_rdata

    ,output logic                  sr_dir_nxthp_re
    ,output logic                  sr_dir_nxthp_clk
    ,output logic                  sr_dir_nxthp_clk_rst_n
    ,output logic [(      14)-1:0] sr_dir_nxthp_addr
    ,output logic                  sr_dir_nxthp_we
    ,output logic [(      21)-1:0] sr_dir_nxthp_wdata
    ,input  logic [(      21)-1:0] sr_dir_nxthp_rdata

    ,output logic                  sr_dir_nxthp_error

);

logic [(       1)-1:0] rf_dir_cnt_raddr_nc ;
logic [(       1)-1:0] rf_dir_cnt_waddr_nc ;

logic        rf_dir_cnt_rdata_error;

logic        cfg_mem_ack_dir_cnt_nc;
logic [31:0] cfg_mem_rdata_dir_cnt_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (64)
        ,.DWIDTH              (68)
        ,.AWIDTHPAD           (1)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_dir_cnt (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_dir_cnt_re)
        ,.func_mem_raddr      (func_dir_cnt_raddr)
        ,.func_mem_waddr      (func_dir_cnt_waddr)
        ,.func_mem_we         (func_dir_cnt_we)
        ,.func_mem_wdata      (func_dir_cnt_wdata)
        ,.func_mem_rdata      (func_dir_cnt_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_dir_cnt_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_dir_cnt_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_dir_cnt_re)
        ,.pf_mem_raddr        (pf_dir_cnt_raddr)
        ,.pf_mem_waddr        (pf_dir_cnt_waddr)
        ,.pf_mem_we           (pf_dir_cnt_we)
        ,.pf_mem_wdata        (pf_dir_cnt_wdata)
        ,.pf_mem_rdata        (pf_dir_cnt_rdata)

        ,.mem_wclk            (rf_dir_cnt_wclk)
        ,.mem_rclk            (rf_dir_cnt_rclk)
        ,.mem_wclk_rst_n      (rf_dir_cnt_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_dir_cnt_rclk_rst_n)
        ,.mem_re              (rf_dir_cnt_re)
        ,.mem_raddr           ({rf_dir_cnt_raddr_nc , rf_dir_cnt_raddr})
        ,.mem_waddr           ({rf_dir_cnt_waddr_nc , rf_dir_cnt_waddr})
        ,.mem_we              (rf_dir_cnt_we)
        ,.mem_wdata           (rf_dir_cnt_wdata)
        ,.mem_rdata           (rf_dir_cnt_rdata)

        ,.mem_rdata_error     (rf_dir_cnt_rdata_error)
        ,.error               (rf_dir_cnt_error)
);

logic [(       2)-1:0] rf_dir_hp_raddr_nc ;
logic [(       2)-1:0] rf_dir_hp_waddr_nc ;

logic        rf_dir_hp_rdata_error;

logic        cfg_mem_ack_dir_hp_nc;
logic [31:0] cfg_mem_rdata_dir_hp_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (256)
        ,.DWIDTH              (15)
        ,.AWIDTHPAD           (2)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_dir_hp (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_dir_hp_re)
        ,.func_mem_raddr      (func_dir_hp_raddr)
        ,.func_mem_waddr      (func_dir_hp_waddr)
        ,.func_mem_we         (func_dir_hp_we)
        ,.func_mem_wdata      (func_dir_hp_wdata)
        ,.func_mem_rdata      (func_dir_hp_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_dir_hp_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_dir_hp_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_dir_hp_re)
        ,.pf_mem_raddr        (pf_dir_hp_raddr)
        ,.pf_mem_waddr        (pf_dir_hp_waddr)
        ,.pf_mem_we           (pf_dir_hp_we)
        ,.pf_mem_wdata        (pf_dir_hp_wdata)
        ,.pf_mem_rdata        (pf_dir_hp_rdata)

        ,.mem_wclk            (rf_dir_hp_wclk)
        ,.mem_rclk            (rf_dir_hp_rclk)
        ,.mem_wclk_rst_n      (rf_dir_hp_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_dir_hp_rclk_rst_n)
        ,.mem_re              (rf_dir_hp_re)
        ,.mem_raddr           ({rf_dir_hp_raddr_nc , rf_dir_hp_raddr})
        ,.mem_waddr           ({rf_dir_hp_waddr_nc , rf_dir_hp_waddr})
        ,.mem_we              (rf_dir_hp_we)
        ,.mem_wdata           (rf_dir_hp_wdata)
        ,.mem_rdata           (rf_dir_hp_rdata)

        ,.mem_rdata_error     (rf_dir_hp_rdata_error)
        ,.error               (rf_dir_hp_error)
);

logic [(       2)-1:0] rf_dir_replay_cnt_raddr_nc ;
logic [(       2)-1:0] rf_dir_replay_cnt_waddr_nc ;

logic        rf_dir_replay_cnt_rdata_error;

logic        cfg_mem_ack_dir_replay_cnt_nc;
logic [31:0] cfg_mem_rdata_dir_replay_cnt_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (32)
        ,.DWIDTH              (68)
        ,.AWIDTHPAD           (2)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_dir_replay_cnt (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_dir_replay_cnt_re)
        ,.func_mem_raddr      (func_dir_replay_cnt_raddr)
        ,.func_mem_waddr      (func_dir_replay_cnt_waddr)
        ,.func_mem_we         (func_dir_replay_cnt_we)
        ,.func_mem_wdata      (func_dir_replay_cnt_wdata)
        ,.func_mem_rdata      (func_dir_replay_cnt_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_dir_replay_cnt_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_dir_replay_cnt_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_dir_replay_cnt_re)
        ,.pf_mem_raddr        (pf_dir_replay_cnt_raddr)
        ,.pf_mem_waddr        (pf_dir_replay_cnt_waddr)
        ,.pf_mem_we           (pf_dir_replay_cnt_we)
        ,.pf_mem_wdata        (pf_dir_replay_cnt_wdata)
        ,.pf_mem_rdata        (pf_dir_replay_cnt_rdata)

        ,.mem_wclk            (rf_dir_replay_cnt_wclk)
        ,.mem_rclk            (rf_dir_replay_cnt_rclk)
        ,.mem_wclk_rst_n      (rf_dir_replay_cnt_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_dir_replay_cnt_rclk_rst_n)
        ,.mem_re              (rf_dir_replay_cnt_re)
        ,.mem_raddr           ({rf_dir_replay_cnt_raddr_nc , rf_dir_replay_cnt_raddr})
        ,.mem_waddr           ({rf_dir_replay_cnt_waddr_nc , rf_dir_replay_cnt_waddr})
        ,.mem_we              (rf_dir_replay_cnt_we)
        ,.mem_wdata           (rf_dir_replay_cnt_wdata)
        ,.mem_rdata           (rf_dir_replay_cnt_rdata)

        ,.mem_rdata_error     (rf_dir_replay_cnt_rdata_error)
        ,.error               (rf_dir_replay_cnt_error)
);

logic [(       3)-1:0] rf_dir_replay_hp_raddr_nc ;
logic [(       3)-1:0] rf_dir_replay_hp_waddr_nc ;

logic        rf_dir_replay_hp_rdata_error;

logic        cfg_mem_ack_dir_replay_hp_nc;
logic [31:0] cfg_mem_rdata_dir_replay_hp_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (128)
        ,.DWIDTH              (15)
        ,.AWIDTHPAD           (3)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_dir_replay_hp (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_dir_replay_hp_re)
        ,.func_mem_raddr      (func_dir_replay_hp_raddr)
        ,.func_mem_waddr      (func_dir_replay_hp_waddr)
        ,.func_mem_we         (func_dir_replay_hp_we)
        ,.func_mem_wdata      (func_dir_replay_hp_wdata)
        ,.func_mem_rdata      (func_dir_replay_hp_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_dir_replay_hp_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_dir_replay_hp_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_dir_replay_hp_re)
        ,.pf_mem_raddr        (pf_dir_replay_hp_raddr)
        ,.pf_mem_waddr        (pf_dir_replay_hp_waddr)
        ,.pf_mem_we           (pf_dir_replay_hp_we)
        ,.pf_mem_wdata        (pf_dir_replay_hp_wdata)
        ,.pf_mem_rdata        (pf_dir_replay_hp_rdata)

        ,.mem_wclk            (rf_dir_replay_hp_wclk)
        ,.mem_rclk            (rf_dir_replay_hp_rclk)
        ,.mem_wclk_rst_n      (rf_dir_replay_hp_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_dir_replay_hp_rclk_rst_n)
        ,.mem_re              (rf_dir_replay_hp_re)
        ,.mem_raddr           ({rf_dir_replay_hp_raddr_nc , rf_dir_replay_hp_raddr})
        ,.mem_waddr           ({rf_dir_replay_hp_waddr_nc , rf_dir_replay_hp_waddr})
        ,.mem_we              (rf_dir_replay_hp_we)
        ,.mem_wdata           (rf_dir_replay_hp_wdata)
        ,.mem_rdata           (rf_dir_replay_hp_rdata)

        ,.mem_rdata_error     (rf_dir_replay_hp_rdata_error)
        ,.error               (rf_dir_replay_hp_error)
);

logic [(       3)-1:0] rf_dir_replay_tp_raddr_nc ;
logic [(       3)-1:0] rf_dir_replay_tp_waddr_nc ;

logic        rf_dir_replay_tp_rdata_error;

logic        cfg_mem_ack_dir_replay_tp_nc;
logic [31:0] cfg_mem_rdata_dir_replay_tp_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (128)
        ,.DWIDTH              (15)
        ,.AWIDTHPAD           (3)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_dir_replay_tp (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_dir_replay_tp_re)
        ,.func_mem_raddr      (func_dir_replay_tp_raddr)
        ,.func_mem_waddr      (func_dir_replay_tp_waddr)
        ,.func_mem_we         (func_dir_replay_tp_we)
        ,.func_mem_wdata      (func_dir_replay_tp_wdata)
        ,.func_mem_rdata      (func_dir_replay_tp_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_dir_replay_tp_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_dir_replay_tp_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_dir_replay_tp_re)
        ,.pf_mem_raddr        (pf_dir_replay_tp_raddr)
        ,.pf_mem_waddr        (pf_dir_replay_tp_waddr)
        ,.pf_mem_we           (pf_dir_replay_tp_we)
        ,.pf_mem_wdata        (pf_dir_replay_tp_wdata)
        ,.pf_mem_rdata        (pf_dir_replay_tp_rdata)

        ,.mem_wclk            (rf_dir_replay_tp_wclk)
        ,.mem_rclk            (rf_dir_replay_tp_rclk)
        ,.mem_wclk_rst_n      (rf_dir_replay_tp_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_dir_replay_tp_rclk_rst_n)
        ,.mem_re              (rf_dir_replay_tp_re)
        ,.mem_raddr           ({rf_dir_replay_tp_raddr_nc , rf_dir_replay_tp_raddr})
        ,.mem_waddr           ({rf_dir_replay_tp_waddr_nc , rf_dir_replay_tp_waddr})
        ,.mem_we              (rf_dir_replay_tp_we)
        ,.mem_wdata           (rf_dir_replay_tp_wdata)
        ,.mem_rdata           (rf_dir_replay_tp_rdata)

        ,.mem_rdata_error     (rf_dir_replay_tp_rdata_error)
        ,.error               (rf_dir_replay_tp_error)
);

logic        rf_dir_rofrag_cnt_rdata_error;

logic        cfg_mem_ack_dir_rofrag_cnt_nc;
logic [31:0] cfg_mem_rdata_dir_rofrag_cnt_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (512)
        ,.DWIDTH              (17)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_dir_rofrag_cnt (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_dir_rofrag_cnt_re)
        ,.func_mem_raddr      (func_dir_rofrag_cnt_raddr)
        ,.func_mem_waddr      (func_dir_rofrag_cnt_waddr)
        ,.func_mem_we         (func_dir_rofrag_cnt_we)
        ,.func_mem_wdata      (func_dir_rofrag_cnt_wdata)
        ,.func_mem_rdata      (func_dir_rofrag_cnt_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_dir_rofrag_cnt_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_dir_rofrag_cnt_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_dir_rofrag_cnt_re)
        ,.pf_mem_raddr        (pf_dir_rofrag_cnt_raddr)
        ,.pf_mem_waddr        (pf_dir_rofrag_cnt_waddr)
        ,.pf_mem_we           (pf_dir_rofrag_cnt_we)
        ,.pf_mem_wdata        (pf_dir_rofrag_cnt_wdata)
        ,.pf_mem_rdata        (pf_dir_rofrag_cnt_rdata)

        ,.mem_wclk            (rf_dir_rofrag_cnt_wclk)
        ,.mem_rclk            (rf_dir_rofrag_cnt_rclk)
        ,.mem_wclk_rst_n      (rf_dir_rofrag_cnt_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_dir_rofrag_cnt_rclk_rst_n)
        ,.mem_re              (rf_dir_rofrag_cnt_re)
        ,.mem_raddr           (rf_dir_rofrag_cnt_raddr)
        ,.mem_waddr           (rf_dir_rofrag_cnt_waddr)
        ,.mem_we              (rf_dir_rofrag_cnt_we)
        ,.mem_wdata           (rf_dir_rofrag_cnt_wdata)
        ,.mem_rdata           (rf_dir_rofrag_cnt_rdata)

        ,.mem_rdata_error     (rf_dir_rofrag_cnt_rdata_error)
        ,.error               (rf_dir_rofrag_cnt_error)
);

logic        rf_dir_rofrag_hp_rdata_error;

logic        cfg_mem_ack_dir_rofrag_hp_nc;
logic [31:0] cfg_mem_rdata_dir_rofrag_hp_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (512)
        ,.DWIDTH              (15)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_dir_rofrag_hp (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_dir_rofrag_hp_re)
        ,.func_mem_raddr      (func_dir_rofrag_hp_raddr)
        ,.func_mem_waddr      (func_dir_rofrag_hp_waddr)
        ,.func_mem_we         (func_dir_rofrag_hp_we)
        ,.func_mem_wdata      (func_dir_rofrag_hp_wdata)
        ,.func_mem_rdata      (func_dir_rofrag_hp_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_dir_rofrag_hp_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_dir_rofrag_hp_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_dir_rofrag_hp_re)
        ,.pf_mem_raddr        (pf_dir_rofrag_hp_raddr)
        ,.pf_mem_waddr        (pf_dir_rofrag_hp_waddr)
        ,.pf_mem_we           (pf_dir_rofrag_hp_we)
        ,.pf_mem_wdata        (pf_dir_rofrag_hp_wdata)
        ,.pf_mem_rdata        (pf_dir_rofrag_hp_rdata)

        ,.mem_wclk            (rf_dir_rofrag_hp_wclk)
        ,.mem_rclk            (rf_dir_rofrag_hp_rclk)
        ,.mem_wclk_rst_n      (rf_dir_rofrag_hp_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_dir_rofrag_hp_rclk_rst_n)
        ,.mem_re              (rf_dir_rofrag_hp_re)
        ,.mem_raddr           (rf_dir_rofrag_hp_raddr)
        ,.mem_waddr           (rf_dir_rofrag_hp_waddr)
        ,.mem_we              (rf_dir_rofrag_hp_we)
        ,.mem_wdata           (rf_dir_rofrag_hp_wdata)
        ,.mem_rdata           (rf_dir_rofrag_hp_rdata)

        ,.mem_rdata_error     (rf_dir_rofrag_hp_rdata_error)
        ,.error               (rf_dir_rofrag_hp_error)
);

logic        rf_dir_rofrag_tp_rdata_error;

logic        cfg_mem_ack_dir_rofrag_tp_nc;
logic [31:0] cfg_mem_rdata_dir_rofrag_tp_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (512)
        ,.DWIDTH              (15)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_dir_rofrag_tp (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_dir_rofrag_tp_re)
        ,.func_mem_raddr      (func_dir_rofrag_tp_raddr)
        ,.func_mem_waddr      (func_dir_rofrag_tp_waddr)
        ,.func_mem_we         (func_dir_rofrag_tp_we)
        ,.func_mem_wdata      (func_dir_rofrag_tp_wdata)
        ,.func_mem_rdata      (func_dir_rofrag_tp_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_dir_rofrag_tp_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_dir_rofrag_tp_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_dir_rofrag_tp_re)
        ,.pf_mem_raddr        (pf_dir_rofrag_tp_raddr)
        ,.pf_mem_waddr        (pf_dir_rofrag_tp_waddr)
        ,.pf_mem_we           (pf_dir_rofrag_tp_we)
        ,.pf_mem_wdata        (pf_dir_rofrag_tp_wdata)
        ,.pf_mem_rdata        (pf_dir_rofrag_tp_rdata)

        ,.mem_wclk            (rf_dir_rofrag_tp_wclk)
        ,.mem_rclk            (rf_dir_rofrag_tp_rclk)
        ,.mem_wclk_rst_n      (rf_dir_rofrag_tp_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_dir_rofrag_tp_rclk_rst_n)
        ,.mem_re              (rf_dir_rofrag_tp_re)
        ,.mem_raddr           (rf_dir_rofrag_tp_raddr)
        ,.mem_waddr           (rf_dir_rofrag_tp_waddr)
        ,.mem_we              (rf_dir_rofrag_tp_we)
        ,.mem_wdata           (rf_dir_rofrag_tp_wdata)
        ,.mem_rdata           (rf_dir_rofrag_tp_rdata)

        ,.mem_rdata_error     (rf_dir_rofrag_tp_rdata_error)
        ,.error               (rf_dir_rofrag_tp_error)
);

logic [(       2)-1:0] rf_dir_tp_raddr_nc ;
logic [(       2)-1:0] rf_dir_tp_waddr_nc ;

logic        rf_dir_tp_rdata_error;

logic        cfg_mem_ack_dir_tp_nc;
logic [31:0] cfg_mem_rdata_dir_tp_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (256)
        ,.DWIDTH              (15)
        ,.AWIDTHPAD           (2)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_dir_tp (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_dir_tp_re)
        ,.func_mem_raddr      (func_dir_tp_raddr)
        ,.func_mem_waddr      (func_dir_tp_waddr)
        ,.func_mem_we         (func_dir_tp_we)
        ,.func_mem_wdata      (func_dir_tp_wdata)
        ,.func_mem_rdata      (func_dir_tp_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_dir_tp_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_dir_tp_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_dir_tp_re)
        ,.pf_mem_raddr        (pf_dir_tp_raddr)
        ,.pf_mem_waddr        (pf_dir_tp_waddr)
        ,.pf_mem_we           (pf_dir_tp_we)
        ,.pf_mem_wdata        (pf_dir_tp_wdata)
        ,.pf_mem_rdata        (pf_dir_tp_rdata)

        ,.mem_wclk            (rf_dir_tp_wclk)
        ,.mem_rclk            (rf_dir_tp_rclk)
        ,.mem_wclk_rst_n      (rf_dir_tp_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_dir_tp_rclk_rst_n)
        ,.mem_re              (rf_dir_tp_re)
        ,.mem_raddr           ({rf_dir_tp_raddr_nc , rf_dir_tp_raddr})
        ,.mem_waddr           ({rf_dir_tp_waddr_nc , rf_dir_tp_waddr})
        ,.mem_we              (rf_dir_tp_we)
        ,.mem_wdata           (rf_dir_tp_wdata)
        ,.mem_rdata           (rf_dir_tp_rdata)

        ,.mem_rdata_error     (rf_dir_tp_rdata_error)
        ,.error               (rf_dir_tp_error)
);

logic        rf_dp_dqed_rdata_error;

logic        cfg_mem_ack_dp_dqed_nc;
logic [31:0] cfg_mem_rdata_dp_dqed_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (32)
        ,.DWIDTH              (45)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_dp_dqed (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_dp_dqed_re)
        ,.func_mem_raddr      (func_dp_dqed_raddr)
        ,.func_mem_waddr      (func_dp_dqed_waddr)
        ,.func_mem_we         (func_dp_dqed_we)
        ,.func_mem_wdata      (func_dp_dqed_wdata)
        ,.func_mem_rdata      (func_dp_dqed_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_dp_dqed_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_dp_dqed_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_dp_dqed_re)
        ,.pf_mem_raddr        (pf_dp_dqed_raddr)
        ,.pf_mem_waddr        (pf_dp_dqed_waddr)
        ,.pf_mem_we           (pf_dp_dqed_we)
        ,.pf_mem_wdata        (pf_dp_dqed_wdata)
        ,.pf_mem_rdata        (pf_dp_dqed_rdata)

        ,.mem_wclk            (rf_dp_dqed_wclk)
        ,.mem_rclk            (rf_dp_dqed_rclk)
        ,.mem_wclk_rst_n      (rf_dp_dqed_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_dp_dqed_rclk_rst_n)
        ,.mem_re              (rf_dp_dqed_re)
        ,.mem_raddr           (rf_dp_dqed_raddr)
        ,.mem_waddr           (rf_dp_dqed_waddr)
        ,.mem_we              (rf_dp_dqed_we)
        ,.mem_wdata           (rf_dp_dqed_wdata)
        ,.mem_rdata           (rf_dp_dqed_rdata)

        ,.mem_rdata_error     (rf_dp_dqed_rdata_error)
        ,.error               (rf_dp_dqed_error)
);

logic        rf_dp_lsp_enq_dir_rdata_error;

logic        cfg_mem_ack_dp_lsp_enq_dir_nc;
logic [31:0] cfg_mem_rdata_dp_lsp_enq_dir_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (16)
        ,.DWIDTH              (8)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_dp_lsp_enq_dir (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_dp_lsp_enq_dir_re)
        ,.func_mem_raddr      (func_dp_lsp_enq_dir_raddr)
        ,.func_mem_waddr      (func_dp_lsp_enq_dir_waddr)
        ,.func_mem_we         (func_dp_lsp_enq_dir_we)
        ,.func_mem_wdata      (func_dp_lsp_enq_dir_wdata)
        ,.func_mem_rdata      (func_dp_lsp_enq_dir_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_dp_lsp_enq_dir_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_dp_lsp_enq_dir_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_dp_lsp_enq_dir_re)
        ,.pf_mem_raddr        (pf_dp_lsp_enq_dir_raddr)
        ,.pf_mem_waddr        (pf_dp_lsp_enq_dir_waddr)
        ,.pf_mem_we           (pf_dp_lsp_enq_dir_we)
        ,.pf_mem_wdata        (pf_dp_lsp_enq_dir_wdata)
        ,.pf_mem_rdata        (pf_dp_lsp_enq_dir_rdata)

        ,.mem_wclk            (rf_dp_lsp_enq_dir_wclk)
        ,.mem_rclk            (rf_dp_lsp_enq_dir_rclk)
        ,.mem_wclk_rst_n      (rf_dp_lsp_enq_dir_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_dp_lsp_enq_dir_rclk_rst_n)
        ,.mem_re              (rf_dp_lsp_enq_dir_re)
        ,.mem_raddr           (rf_dp_lsp_enq_dir_raddr)
        ,.mem_waddr           (rf_dp_lsp_enq_dir_waddr)
        ,.mem_we              (rf_dp_lsp_enq_dir_we)
        ,.mem_wdata           (rf_dp_lsp_enq_dir_wdata)
        ,.mem_rdata           (rf_dp_lsp_enq_dir_rdata)

        ,.mem_rdata_error     (rf_dp_lsp_enq_dir_rdata_error)
        ,.error               (rf_dp_lsp_enq_dir_error)
);

logic        rf_dp_lsp_enq_rorply_rdata_error;

logic        cfg_mem_ack_dp_lsp_enq_rorply_nc;
logic [31:0] cfg_mem_rdata_dp_lsp_enq_rorply_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (16)
        ,.DWIDTH              (23)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_dp_lsp_enq_rorply (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_dp_lsp_enq_rorply_re)
        ,.func_mem_raddr      (func_dp_lsp_enq_rorply_raddr)
        ,.func_mem_waddr      (func_dp_lsp_enq_rorply_waddr)
        ,.func_mem_we         (func_dp_lsp_enq_rorply_we)
        ,.func_mem_wdata      (func_dp_lsp_enq_rorply_wdata)
        ,.func_mem_rdata      (func_dp_lsp_enq_rorply_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_dp_lsp_enq_rorply_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_dp_lsp_enq_rorply_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_dp_lsp_enq_rorply_re)
        ,.pf_mem_raddr        (pf_dp_lsp_enq_rorply_raddr)
        ,.pf_mem_waddr        (pf_dp_lsp_enq_rorply_waddr)
        ,.pf_mem_we           (pf_dp_lsp_enq_rorply_we)
        ,.pf_mem_wdata        (pf_dp_lsp_enq_rorply_wdata)
        ,.pf_mem_rdata        (pf_dp_lsp_enq_rorply_rdata)

        ,.mem_wclk            (rf_dp_lsp_enq_rorply_wclk)
        ,.mem_rclk            (rf_dp_lsp_enq_rorply_rclk)
        ,.mem_wclk_rst_n      (rf_dp_lsp_enq_rorply_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_dp_lsp_enq_rorply_rclk_rst_n)
        ,.mem_re              (rf_dp_lsp_enq_rorply_re)
        ,.mem_raddr           (rf_dp_lsp_enq_rorply_raddr)
        ,.mem_waddr           (rf_dp_lsp_enq_rorply_waddr)
        ,.mem_we              (rf_dp_lsp_enq_rorply_we)
        ,.mem_wdata           (rf_dp_lsp_enq_rorply_wdata)
        ,.mem_rdata           (rf_dp_lsp_enq_rorply_rdata)

        ,.mem_rdata_error     (rf_dp_lsp_enq_rorply_rdata_error)
        ,.error               (rf_dp_lsp_enq_rorply_error)
);

logic        rf_lsp_dp_sch_dir_rdata_error;

logic        cfg_mem_ack_lsp_dp_sch_dir_nc;
logic [31:0] cfg_mem_rdata_lsp_dp_sch_dir_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (4)
        ,.DWIDTH              (27)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_lsp_dp_sch_dir (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_lsp_dp_sch_dir_re)
        ,.func_mem_raddr      (func_lsp_dp_sch_dir_raddr)
        ,.func_mem_waddr      (func_lsp_dp_sch_dir_waddr)
        ,.func_mem_we         (func_lsp_dp_sch_dir_we)
        ,.func_mem_wdata      (func_lsp_dp_sch_dir_wdata)
        ,.func_mem_rdata      (func_lsp_dp_sch_dir_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_lsp_dp_sch_dir_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_lsp_dp_sch_dir_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_lsp_dp_sch_dir_re)
        ,.pf_mem_raddr        (pf_lsp_dp_sch_dir_raddr)
        ,.pf_mem_waddr        (pf_lsp_dp_sch_dir_waddr)
        ,.pf_mem_we           (pf_lsp_dp_sch_dir_we)
        ,.pf_mem_wdata        (pf_lsp_dp_sch_dir_wdata)
        ,.pf_mem_rdata        (pf_lsp_dp_sch_dir_rdata)

        ,.mem_wclk            (rf_lsp_dp_sch_dir_wclk)
        ,.mem_rclk            (rf_lsp_dp_sch_dir_rclk)
        ,.mem_wclk_rst_n      (rf_lsp_dp_sch_dir_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_lsp_dp_sch_dir_rclk_rst_n)
        ,.mem_re              (rf_lsp_dp_sch_dir_re)
        ,.mem_raddr           (rf_lsp_dp_sch_dir_raddr)
        ,.mem_waddr           (rf_lsp_dp_sch_dir_waddr)
        ,.mem_we              (rf_lsp_dp_sch_dir_we)
        ,.mem_wdata           (rf_lsp_dp_sch_dir_wdata)
        ,.mem_rdata           (rf_lsp_dp_sch_dir_rdata)

        ,.mem_rdata_error     (rf_lsp_dp_sch_dir_rdata_error)
        ,.error               (rf_lsp_dp_sch_dir_error)
);

logic        rf_lsp_dp_sch_rorply_rdata_error;

logic        cfg_mem_ack_lsp_dp_sch_rorply_nc;
logic [31:0] cfg_mem_rdata_lsp_dp_sch_rorply_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (4)
        ,.DWIDTH              (8)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_lsp_dp_sch_rorply (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_lsp_dp_sch_rorply_re)
        ,.func_mem_raddr      (func_lsp_dp_sch_rorply_raddr)
        ,.func_mem_waddr      (func_lsp_dp_sch_rorply_waddr)
        ,.func_mem_we         (func_lsp_dp_sch_rorply_we)
        ,.func_mem_wdata      (func_lsp_dp_sch_rorply_wdata)
        ,.func_mem_rdata      (func_lsp_dp_sch_rorply_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_lsp_dp_sch_rorply_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_lsp_dp_sch_rorply_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_lsp_dp_sch_rorply_re)
        ,.pf_mem_raddr        (pf_lsp_dp_sch_rorply_raddr)
        ,.pf_mem_waddr        (pf_lsp_dp_sch_rorply_waddr)
        ,.pf_mem_we           (pf_lsp_dp_sch_rorply_we)
        ,.pf_mem_wdata        (pf_lsp_dp_sch_rorply_wdata)
        ,.pf_mem_rdata        (pf_lsp_dp_sch_rorply_rdata)

        ,.mem_wclk            (rf_lsp_dp_sch_rorply_wclk)
        ,.mem_rclk            (rf_lsp_dp_sch_rorply_rclk)
        ,.mem_wclk_rst_n      (rf_lsp_dp_sch_rorply_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_lsp_dp_sch_rorply_rclk_rst_n)
        ,.mem_re              (rf_lsp_dp_sch_rorply_re)
        ,.mem_raddr           (rf_lsp_dp_sch_rorply_raddr)
        ,.mem_waddr           (rf_lsp_dp_sch_rorply_waddr)
        ,.mem_we              (rf_lsp_dp_sch_rorply_we)
        ,.mem_wdata           (rf_lsp_dp_sch_rorply_wdata)
        ,.mem_rdata           (rf_lsp_dp_sch_rorply_rdata)

        ,.mem_rdata_error     (rf_lsp_dp_sch_rorply_rdata_error)
        ,.error               (rf_lsp_dp_sch_rorply_error)
);

logic        rf_rop_dp_enq_dir_rdata_error;

logic        cfg_mem_ack_rop_dp_enq_dir_nc;
logic [31:0] cfg_mem_rdata_rop_dp_enq_dir_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (4)
        ,.DWIDTH              (100)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_rop_dp_enq_dir (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_rop_dp_enq_dir_re)
        ,.func_mem_raddr      (func_rop_dp_enq_dir_raddr)
        ,.func_mem_waddr      (func_rop_dp_enq_dir_waddr)
        ,.func_mem_we         (func_rop_dp_enq_dir_we)
        ,.func_mem_wdata      (func_rop_dp_enq_dir_wdata)
        ,.func_mem_rdata      (func_rop_dp_enq_dir_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_rop_dp_enq_dir_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_rop_dp_enq_dir_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_rop_dp_enq_dir_re)
        ,.pf_mem_raddr        (pf_rop_dp_enq_dir_raddr)
        ,.pf_mem_waddr        (pf_rop_dp_enq_dir_waddr)
        ,.pf_mem_we           (pf_rop_dp_enq_dir_we)
        ,.pf_mem_wdata        (pf_rop_dp_enq_dir_wdata)
        ,.pf_mem_rdata        (pf_rop_dp_enq_dir_rdata)

        ,.mem_wclk            (rf_rop_dp_enq_dir_wclk)
        ,.mem_rclk            (rf_rop_dp_enq_dir_rclk)
        ,.mem_wclk_rst_n      (rf_rop_dp_enq_dir_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_rop_dp_enq_dir_rclk_rst_n)
        ,.mem_re              (rf_rop_dp_enq_dir_re)
        ,.mem_raddr           (rf_rop_dp_enq_dir_raddr)
        ,.mem_waddr           (rf_rop_dp_enq_dir_waddr)
        ,.mem_we              (rf_rop_dp_enq_dir_we)
        ,.mem_wdata           (rf_rop_dp_enq_dir_wdata)
        ,.mem_rdata           (rf_rop_dp_enq_dir_rdata)

        ,.mem_rdata_error     (rf_rop_dp_enq_dir_rdata_error)
        ,.error               (rf_rop_dp_enq_dir_error)
);

logic        rf_rop_dp_enq_ro_rdata_error;

logic        cfg_mem_ack_rop_dp_enq_ro_nc;
logic [31:0] cfg_mem_rdata_rop_dp_enq_ro_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (4)
        ,.DWIDTH              (100)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_rop_dp_enq_ro (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_rop_dp_enq_ro_re)
        ,.func_mem_raddr      (func_rop_dp_enq_ro_raddr)
        ,.func_mem_waddr      (func_rop_dp_enq_ro_waddr)
        ,.func_mem_we         (func_rop_dp_enq_ro_we)
        ,.func_mem_wdata      (func_rop_dp_enq_ro_wdata)
        ,.func_mem_rdata      (func_rop_dp_enq_ro_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_rop_dp_enq_ro_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_rop_dp_enq_ro_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_rop_dp_enq_ro_re)
        ,.pf_mem_raddr        (pf_rop_dp_enq_ro_raddr)
        ,.pf_mem_waddr        (pf_rop_dp_enq_ro_waddr)
        ,.pf_mem_we           (pf_rop_dp_enq_ro_we)
        ,.pf_mem_wdata        (pf_rop_dp_enq_ro_wdata)
        ,.pf_mem_rdata        (pf_rop_dp_enq_ro_rdata)

        ,.mem_wclk            (rf_rop_dp_enq_ro_wclk)
        ,.mem_rclk            (rf_rop_dp_enq_ro_rclk)
        ,.mem_wclk_rst_n      (rf_rop_dp_enq_ro_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_rop_dp_enq_ro_rclk_rst_n)
        ,.mem_re              (rf_rop_dp_enq_ro_re)
        ,.mem_raddr           (rf_rop_dp_enq_ro_raddr)
        ,.mem_waddr           (rf_rop_dp_enq_ro_waddr)
        ,.mem_we              (rf_rop_dp_enq_ro_we)
        ,.mem_wdata           (rf_rop_dp_enq_ro_wdata)
        ,.mem_rdata           (rf_rop_dp_enq_ro_rdata)

        ,.mem_rdata_error     (rf_rop_dp_enq_ro_rdata_error)
        ,.error               (rf_rop_dp_enq_ro_error)
);

logic        rf_rx_sync_lsp_dp_sch_dir_rdata_error;

logic        cfg_mem_ack_rx_sync_lsp_dp_sch_dir_nc;
logic [31:0] cfg_mem_rdata_rx_sync_lsp_dp_sch_dir_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (4)
        ,.DWIDTH              (27)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_rx_sync_lsp_dp_sch_dir (
         .clk                 (hqm_inp_gated_clk)
        ,.rst_n               (hqm_inp_gated_rst_n)

        ,.func_mem_re         (func_rx_sync_lsp_dp_sch_dir_re)
        ,.func_mem_raddr      (func_rx_sync_lsp_dp_sch_dir_raddr)
        ,.func_mem_waddr      (func_rx_sync_lsp_dp_sch_dir_waddr)
        ,.func_mem_we         (func_rx_sync_lsp_dp_sch_dir_we)
        ,.func_mem_wdata      (func_rx_sync_lsp_dp_sch_dir_wdata)
        ,.func_mem_rdata      (func_rx_sync_lsp_dp_sch_dir_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_rx_sync_lsp_dp_sch_dir_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_rx_sync_lsp_dp_sch_dir_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_rx_sync_lsp_dp_sch_dir_re)
        ,.pf_mem_raddr        (pf_rx_sync_lsp_dp_sch_dir_raddr)
        ,.pf_mem_waddr        (pf_rx_sync_lsp_dp_sch_dir_waddr)
        ,.pf_mem_we           (pf_rx_sync_lsp_dp_sch_dir_we)
        ,.pf_mem_wdata        (pf_rx_sync_lsp_dp_sch_dir_wdata)
        ,.pf_mem_rdata        (pf_rx_sync_lsp_dp_sch_dir_rdata)

        ,.mem_wclk            (rf_rx_sync_lsp_dp_sch_dir_wclk)
        ,.mem_rclk            (rf_rx_sync_lsp_dp_sch_dir_rclk)
        ,.mem_wclk_rst_n      (rf_rx_sync_lsp_dp_sch_dir_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_rx_sync_lsp_dp_sch_dir_rclk_rst_n)
        ,.mem_re              (rf_rx_sync_lsp_dp_sch_dir_re)
        ,.mem_raddr           (rf_rx_sync_lsp_dp_sch_dir_raddr)
        ,.mem_waddr           (rf_rx_sync_lsp_dp_sch_dir_waddr)
        ,.mem_we              (rf_rx_sync_lsp_dp_sch_dir_we)
        ,.mem_wdata           (rf_rx_sync_lsp_dp_sch_dir_wdata)
        ,.mem_rdata           (rf_rx_sync_lsp_dp_sch_dir_rdata)

        ,.mem_rdata_error     (rf_rx_sync_lsp_dp_sch_dir_rdata_error)
        ,.error               (rf_rx_sync_lsp_dp_sch_dir_error)
);

logic        rf_rx_sync_lsp_dp_sch_rorply_rdata_error;

logic        cfg_mem_ack_rx_sync_lsp_dp_sch_rorply_nc;
logic [31:0] cfg_mem_rdata_rx_sync_lsp_dp_sch_rorply_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (4)
        ,.DWIDTH              (8)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_rx_sync_lsp_dp_sch_rorply (
         .clk                 (hqm_inp_gated_clk)
        ,.rst_n               (hqm_inp_gated_rst_n)

        ,.func_mem_re         (func_rx_sync_lsp_dp_sch_rorply_re)
        ,.func_mem_raddr      (func_rx_sync_lsp_dp_sch_rorply_raddr)
        ,.func_mem_waddr      (func_rx_sync_lsp_dp_sch_rorply_waddr)
        ,.func_mem_we         (func_rx_sync_lsp_dp_sch_rorply_we)
        ,.func_mem_wdata      (func_rx_sync_lsp_dp_sch_rorply_wdata)
        ,.func_mem_rdata      (func_rx_sync_lsp_dp_sch_rorply_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_rx_sync_lsp_dp_sch_rorply_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_rx_sync_lsp_dp_sch_rorply_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_rx_sync_lsp_dp_sch_rorply_re)
        ,.pf_mem_raddr        (pf_rx_sync_lsp_dp_sch_rorply_raddr)
        ,.pf_mem_waddr        (pf_rx_sync_lsp_dp_sch_rorply_waddr)
        ,.pf_mem_we           (pf_rx_sync_lsp_dp_sch_rorply_we)
        ,.pf_mem_wdata        (pf_rx_sync_lsp_dp_sch_rorply_wdata)
        ,.pf_mem_rdata        (pf_rx_sync_lsp_dp_sch_rorply_rdata)

        ,.mem_wclk            (rf_rx_sync_lsp_dp_sch_rorply_wclk)
        ,.mem_rclk            (rf_rx_sync_lsp_dp_sch_rorply_rclk)
        ,.mem_wclk_rst_n      (rf_rx_sync_lsp_dp_sch_rorply_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_rx_sync_lsp_dp_sch_rorply_rclk_rst_n)
        ,.mem_re              (rf_rx_sync_lsp_dp_sch_rorply_re)
        ,.mem_raddr           (rf_rx_sync_lsp_dp_sch_rorply_raddr)
        ,.mem_waddr           (rf_rx_sync_lsp_dp_sch_rorply_waddr)
        ,.mem_we              (rf_rx_sync_lsp_dp_sch_rorply_we)
        ,.mem_wdata           (rf_rx_sync_lsp_dp_sch_rorply_wdata)
        ,.mem_rdata           (rf_rx_sync_lsp_dp_sch_rorply_rdata)

        ,.mem_rdata_error     (rf_rx_sync_lsp_dp_sch_rorply_rdata_error)
        ,.error               (rf_rx_sync_lsp_dp_sch_rorply_error)
);

logic        rf_rx_sync_rop_dp_enq_rdata_error;

logic        cfg_mem_ack_rx_sync_rop_dp_enq_nc;
logic [31:0] cfg_mem_rdata_rx_sync_rop_dp_enq_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (4)
        ,.DWIDTH              (100)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_rx_sync_rop_dp_enq (
         .clk                 (hqm_inp_gated_clk)
        ,.rst_n               (hqm_inp_gated_rst_n)

        ,.func_mem_re         (func_rx_sync_rop_dp_enq_re)
        ,.func_mem_raddr      (func_rx_sync_rop_dp_enq_raddr)
        ,.func_mem_waddr      (func_rx_sync_rop_dp_enq_waddr)
        ,.func_mem_we         (func_rx_sync_rop_dp_enq_we)
        ,.func_mem_wdata      (func_rx_sync_rop_dp_enq_wdata)
        ,.func_mem_rdata      (func_rx_sync_rop_dp_enq_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_rx_sync_rop_dp_enq_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_rx_sync_rop_dp_enq_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_rx_sync_rop_dp_enq_re)
        ,.pf_mem_raddr        (pf_rx_sync_rop_dp_enq_raddr)
        ,.pf_mem_waddr        (pf_rx_sync_rop_dp_enq_waddr)
        ,.pf_mem_we           (pf_rx_sync_rop_dp_enq_we)
        ,.pf_mem_wdata        (pf_rx_sync_rop_dp_enq_wdata)
        ,.pf_mem_rdata        (pf_rx_sync_rop_dp_enq_rdata)

        ,.mem_wclk            (rf_rx_sync_rop_dp_enq_wclk)
        ,.mem_rclk            (rf_rx_sync_rop_dp_enq_rclk)
        ,.mem_wclk_rst_n      (rf_rx_sync_rop_dp_enq_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_rx_sync_rop_dp_enq_rclk_rst_n)
        ,.mem_re              (rf_rx_sync_rop_dp_enq_re)
        ,.mem_raddr           (rf_rx_sync_rop_dp_enq_raddr)
        ,.mem_waddr           (rf_rx_sync_rop_dp_enq_waddr)
        ,.mem_we              (rf_rx_sync_rop_dp_enq_we)
        ,.mem_wdata           (rf_rx_sync_rop_dp_enq_wdata)
        ,.mem_rdata           (rf_rx_sync_rop_dp_enq_rdata)

        ,.mem_rdata_error     (rf_rx_sync_rop_dp_enq_rdata_error)
        ,.error               (rf_rx_sync_rop_dp_enq_error)
);

logic        cfg_mem_ack_dir_nxthp_nc;
logic [31:0] cfg_mem_rdata_dir_nxthp_nc;

hqm_AW_srw_access #( 
         .DEPTH               (16384)
        ,.DWIDTH              (21)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
) i_dir_nxthp ( 
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_dir_nxthp_re)
        ,.func_mem_addr       (func_dir_nxthp_addr)
        ,.func_mem_we         (func_dir_nxthp_we)
        ,.func_mem_wdata      (func_dir_nxthp_wdata)
        ,.func_mem_rdata      (func_dir_nxthp_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_dir_nxthp_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_dir_nxthp_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_dir_nxthp_re)
        ,.pf_mem_addr         (pf_dir_nxthp_addr)
        ,.pf_mem_we           (pf_dir_nxthp_we)
        ,.pf_mem_wdata        (pf_dir_nxthp_wdata)
        ,.pf_mem_rdata        (pf_dir_nxthp_rdata)

        ,.mem_clk             (sr_dir_nxthp_clk)
        ,.mem_clk_rst_n       (sr_dir_nxthp_clk_rst_n)
        ,.mem_re              (sr_dir_nxthp_re)
        ,.mem_addr            (sr_dir_nxthp_addr)
        ,.mem_we              (sr_dir_nxthp_we)
        ,.mem_wdata           (sr_dir_nxthp_wdata)
        ,.mem_rdata           (sr_dir_nxthp_rdata)

        ,.error               (sr_dir_nxthp_error)
);


assign hqm_dir_pipe_rfw_top_ipar_error = rf_dir_cnt_rdata_error | rf_dir_hp_rdata_error | rf_dir_replay_cnt_rdata_error | rf_dir_replay_hp_rdata_error | rf_dir_replay_tp_rdata_error | rf_dir_rofrag_cnt_rdata_error | rf_dir_rofrag_hp_rdata_error | rf_dir_rofrag_tp_rdata_error | rf_dir_tp_rdata_error | rf_dp_dqed_rdata_error | rf_dp_lsp_enq_dir_rdata_error | rf_dp_lsp_enq_rorply_rdata_error | rf_lsp_dp_sch_dir_rdata_error | rf_lsp_dp_sch_rorply_rdata_error | rf_rop_dp_enq_dir_rdata_error | rf_rop_dp_enq_ro_rdata_error | rf_rx_sync_lsp_dp_sch_dir_rdata_error | rf_rx_sync_lsp_dp_sch_rorply_rdata_error | rf_rx_sync_rop_dp_enq_rdata_error ;
assign cfg_mem_rdata = '0;
assign cfg_mem_ack   = '0;

endmodule

