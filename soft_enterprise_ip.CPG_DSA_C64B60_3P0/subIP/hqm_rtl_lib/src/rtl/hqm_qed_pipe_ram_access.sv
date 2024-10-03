module hqm_qed_pipe_ram_access
     import hqm_AW_pkg::* , hqm_pkg::* , hqm_core_pkg::*;
(
     input  logic                  hqm_gated_clk
    ,input  logic                  hqm_inp_gated_clk

    ,input  logic                  hqm_gated_rst_n
    ,input  logic                  hqm_inp_gated_rst_n

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

    ,output logic                  hqm_qed_pipe_rfw_top_ipar_error

    ,input  logic                  func_qed_chp_sch_data_re
    ,input  logic [(       3)-1:0] func_qed_chp_sch_data_raddr
    ,input  logic [(       3)-1:0] func_qed_chp_sch_data_waddr
    ,input  logic                  func_qed_chp_sch_data_we
    ,input  logic [(     177)-1:0] func_qed_chp_sch_data_wdata
    ,output logic [(     177)-1:0] func_qed_chp_sch_data_rdata

    ,input  logic                  pf_qed_chp_sch_data_re
    ,input  logic [(       3)-1:0] pf_qed_chp_sch_data_raddr
    ,input  logic [(       3)-1:0] pf_qed_chp_sch_data_waddr
    ,input  logic                  pf_qed_chp_sch_data_we
    ,input  logic [(     177)-1:0] pf_qed_chp_sch_data_wdata
    ,output logic [(     177)-1:0] pf_qed_chp_sch_data_rdata

    ,output logic                  rf_qed_chp_sch_data_re
    ,output logic                  rf_qed_chp_sch_data_rclk
    ,output logic                  rf_qed_chp_sch_data_rclk_rst_n
    ,output logic [(       3)-1:0] rf_qed_chp_sch_data_raddr
    ,output logic [(       3)-1:0] rf_qed_chp_sch_data_waddr
    ,output logic                  rf_qed_chp_sch_data_we
    ,output logic                  rf_qed_chp_sch_data_wclk
    ,output logic                  rf_qed_chp_sch_data_wclk_rst_n
    ,output logic [(     177)-1:0] rf_qed_chp_sch_data_wdata
    ,input  logic [(     177)-1:0] rf_qed_chp_sch_data_rdata

    ,output logic                  rf_qed_chp_sch_data_error

    ,input  logic                  func_rx_sync_dp_dqed_data_re
    ,input  logic [(       2)-1:0] func_rx_sync_dp_dqed_data_raddr
    ,input  logic [(       2)-1:0] func_rx_sync_dp_dqed_data_waddr
    ,input  logic                  func_rx_sync_dp_dqed_data_we
    ,input  logic [(      45)-1:0] func_rx_sync_dp_dqed_data_wdata
    ,output logic [(      45)-1:0] func_rx_sync_dp_dqed_data_rdata

    ,input  logic                  pf_rx_sync_dp_dqed_data_re
    ,input  logic [(       2)-1:0] pf_rx_sync_dp_dqed_data_raddr
    ,input  logic [(       2)-1:0] pf_rx_sync_dp_dqed_data_waddr
    ,input  logic                  pf_rx_sync_dp_dqed_data_we
    ,input  logic [(      45)-1:0] pf_rx_sync_dp_dqed_data_wdata
    ,output logic [(      45)-1:0] pf_rx_sync_dp_dqed_data_rdata

    ,output logic                  rf_rx_sync_dp_dqed_data_re
    ,output logic                  rf_rx_sync_dp_dqed_data_rclk
    ,output logic                  rf_rx_sync_dp_dqed_data_rclk_rst_n
    ,output logic [(       2)-1:0] rf_rx_sync_dp_dqed_data_raddr
    ,output logic [(       2)-1:0] rf_rx_sync_dp_dqed_data_waddr
    ,output logic                  rf_rx_sync_dp_dqed_data_we
    ,output logic                  rf_rx_sync_dp_dqed_data_wclk
    ,output logic                  rf_rx_sync_dp_dqed_data_wclk_rst_n
    ,output logic [(      45)-1:0] rf_rx_sync_dp_dqed_data_wdata
    ,input  logic [(      45)-1:0] rf_rx_sync_dp_dqed_data_rdata

    ,output logic                  rf_rx_sync_dp_dqed_data_error

    ,input  logic                  func_rx_sync_nalb_qed_data_re
    ,input  logic [(       2)-1:0] func_rx_sync_nalb_qed_data_raddr
    ,input  logic [(       2)-1:0] func_rx_sync_nalb_qed_data_waddr
    ,input  logic                  func_rx_sync_nalb_qed_data_we
    ,input  logic [(      45)-1:0] func_rx_sync_nalb_qed_data_wdata
    ,output logic [(      45)-1:0] func_rx_sync_nalb_qed_data_rdata

    ,input  logic                  pf_rx_sync_nalb_qed_data_re
    ,input  logic [(       2)-1:0] pf_rx_sync_nalb_qed_data_raddr
    ,input  logic [(       2)-1:0] pf_rx_sync_nalb_qed_data_waddr
    ,input  logic                  pf_rx_sync_nalb_qed_data_we
    ,input  logic [(      45)-1:0] pf_rx_sync_nalb_qed_data_wdata
    ,output logic [(      45)-1:0] pf_rx_sync_nalb_qed_data_rdata

    ,output logic                  rf_rx_sync_nalb_qed_data_re
    ,output logic                  rf_rx_sync_nalb_qed_data_rclk
    ,output logic                  rf_rx_sync_nalb_qed_data_rclk_rst_n
    ,output logic [(       2)-1:0] rf_rx_sync_nalb_qed_data_raddr
    ,output logic [(       2)-1:0] rf_rx_sync_nalb_qed_data_waddr
    ,output logic                  rf_rx_sync_nalb_qed_data_we
    ,output logic                  rf_rx_sync_nalb_qed_data_wclk
    ,output logic                  rf_rx_sync_nalb_qed_data_wclk_rst_n
    ,output logic [(      45)-1:0] rf_rx_sync_nalb_qed_data_wdata
    ,input  logic [(      45)-1:0] rf_rx_sync_nalb_qed_data_rdata

    ,output logic                  rf_rx_sync_nalb_qed_data_error

    ,input  logic                  func_rx_sync_rop_qed_dqed_enq_re
    ,input  logic [(       2)-1:0] func_rx_sync_rop_qed_dqed_enq_raddr
    ,input  logic [(       2)-1:0] func_rx_sync_rop_qed_dqed_enq_waddr
    ,input  logic                  func_rx_sync_rop_qed_dqed_enq_we
    ,input  logic [(     157)-1:0] func_rx_sync_rop_qed_dqed_enq_wdata
    ,output logic [(     157)-1:0] func_rx_sync_rop_qed_dqed_enq_rdata

    ,input  logic                  pf_rx_sync_rop_qed_dqed_enq_re
    ,input  logic [(       2)-1:0] pf_rx_sync_rop_qed_dqed_enq_raddr
    ,input  logic [(       2)-1:0] pf_rx_sync_rop_qed_dqed_enq_waddr
    ,input  logic                  pf_rx_sync_rop_qed_dqed_enq_we
    ,input  logic [(     157)-1:0] pf_rx_sync_rop_qed_dqed_enq_wdata
    ,output logic [(     157)-1:0] pf_rx_sync_rop_qed_dqed_enq_rdata

    ,output logic                  rf_rx_sync_rop_qed_dqed_enq_re
    ,output logic                  rf_rx_sync_rop_qed_dqed_enq_rclk
    ,output logic                  rf_rx_sync_rop_qed_dqed_enq_rclk_rst_n
    ,output logic [(       2)-1:0] rf_rx_sync_rop_qed_dqed_enq_raddr
    ,output logic [(       2)-1:0] rf_rx_sync_rop_qed_dqed_enq_waddr
    ,output logic                  rf_rx_sync_rop_qed_dqed_enq_we
    ,output logic                  rf_rx_sync_rop_qed_dqed_enq_wclk
    ,output logic                  rf_rx_sync_rop_qed_dqed_enq_wclk_rst_n
    ,output logic [(     157)-1:0] rf_rx_sync_rop_qed_dqed_enq_wdata
    ,input  logic [(     157)-1:0] rf_rx_sync_rop_qed_dqed_enq_rdata

    ,output logic                  rf_rx_sync_rop_qed_dqed_enq_error

    ,input  logic                  func_qed_0_re
    ,input  logic [(      11)-1:0] func_qed_0_addr
    ,input  logic                  func_qed_0_we
    ,input  logic [(     139)-1:0] func_qed_0_wdata
    ,output logic [(     139)-1:0] func_qed_0_rdata

    ,input  logic                  pf_qed_0_re
    ,input  logic [(      11)-1:0] pf_qed_0_addr
    ,input  logic                  pf_qed_0_we
    ,input  logic [(     139)-1:0] pf_qed_0_wdata
    ,output logic [(     139)-1:0] pf_qed_0_rdata

    ,output logic                  sr_qed_0_re
    ,output logic                  sr_qed_0_clk
    ,output logic                  sr_qed_0_clk_rst_n
    ,output logic [(      11)-1:0] sr_qed_0_addr
    ,output logic                  sr_qed_0_we
    ,output logic [(     139)-1:0] sr_qed_0_wdata
    ,input  logic [(     139)-1:0] sr_qed_0_rdata

    ,output logic                  sr_qed_0_error

    ,input  logic                  func_qed_1_re
    ,input  logic [(      11)-1:0] func_qed_1_addr
    ,input  logic                  func_qed_1_we
    ,input  logic [(     139)-1:0] func_qed_1_wdata
    ,output logic [(     139)-1:0] func_qed_1_rdata

    ,input  logic                  pf_qed_1_re
    ,input  logic [(      11)-1:0] pf_qed_1_addr
    ,input  logic                  pf_qed_1_we
    ,input  logic [(     139)-1:0] pf_qed_1_wdata
    ,output logic [(     139)-1:0] pf_qed_1_rdata

    ,output logic                  sr_qed_1_re
    ,output logic                  sr_qed_1_clk
    ,output logic                  sr_qed_1_clk_rst_n
    ,output logic [(      11)-1:0] sr_qed_1_addr
    ,output logic                  sr_qed_1_we
    ,output logic [(     139)-1:0] sr_qed_1_wdata
    ,input  logic [(     139)-1:0] sr_qed_1_rdata

    ,output logic                  sr_qed_1_error

    ,input  logic                  func_qed_2_re
    ,input  logic [(      11)-1:0] func_qed_2_addr
    ,input  logic                  func_qed_2_we
    ,input  logic [(     139)-1:0] func_qed_2_wdata
    ,output logic [(     139)-1:0] func_qed_2_rdata

    ,input  logic                  pf_qed_2_re
    ,input  logic [(      11)-1:0] pf_qed_2_addr
    ,input  logic                  pf_qed_2_we
    ,input  logic [(     139)-1:0] pf_qed_2_wdata
    ,output logic [(     139)-1:0] pf_qed_2_rdata

    ,output logic                  sr_qed_2_re
    ,output logic                  sr_qed_2_clk
    ,output logic                  sr_qed_2_clk_rst_n
    ,output logic [(      11)-1:0] sr_qed_2_addr
    ,output logic                  sr_qed_2_we
    ,output logic [(     139)-1:0] sr_qed_2_wdata
    ,input  logic [(     139)-1:0] sr_qed_2_rdata

    ,output logic                  sr_qed_2_error

    ,input  logic                  func_qed_3_re
    ,input  logic [(      11)-1:0] func_qed_3_addr
    ,input  logic                  func_qed_3_we
    ,input  logic [(     139)-1:0] func_qed_3_wdata
    ,output logic [(     139)-1:0] func_qed_3_rdata

    ,input  logic                  pf_qed_3_re
    ,input  logic [(      11)-1:0] pf_qed_3_addr
    ,input  logic                  pf_qed_3_we
    ,input  logic [(     139)-1:0] pf_qed_3_wdata
    ,output logic [(     139)-1:0] pf_qed_3_rdata

    ,output logic                  sr_qed_3_re
    ,output logic                  sr_qed_3_clk
    ,output logic                  sr_qed_3_clk_rst_n
    ,output logic [(      11)-1:0] sr_qed_3_addr
    ,output logic                  sr_qed_3_we
    ,output logic [(     139)-1:0] sr_qed_3_wdata
    ,input  logic [(     139)-1:0] sr_qed_3_rdata

    ,output logic                  sr_qed_3_error

    ,input  logic                  func_qed_4_re
    ,input  logic [(      11)-1:0] func_qed_4_addr
    ,input  logic                  func_qed_4_we
    ,input  logic [(     139)-1:0] func_qed_4_wdata
    ,output logic [(     139)-1:0] func_qed_4_rdata

    ,input  logic                  pf_qed_4_re
    ,input  logic [(      11)-1:0] pf_qed_4_addr
    ,input  logic                  pf_qed_4_we
    ,input  logic [(     139)-1:0] pf_qed_4_wdata
    ,output logic [(     139)-1:0] pf_qed_4_rdata

    ,output logic                  sr_qed_4_re
    ,output logic                  sr_qed_4_clk
    ,output logic                  sr_qed_4_clk_rst_n
    ,output logic [(      11)-1:0] sr_qed_4_addr
    ,output logic                  sr_qed_4_we
    ,output logic [(     139)-1:0] sr_qed_4_wdata
    ,input  logic [(     139)-1:0] sr_qed_4_rdata

    ,output logic                  sr_qed_4_error

    ,input  logic                  func_qed_5_re
    ,input  logic [(      11)-1:0] func_qed_5_addr
    ,input  logic                  func_qed_5_we
    ,input  logic [(     139)-1:0] func_qed_5_wdata
    ,output logic [(     139)-1:0] func_qed_5_rdata

    ,input  logic                  pf_qed_5_re
    ,input  logic [(      11)-1:0] pf_qed_5_addr
    ,input  logic                  pf_qed_5_we
    ,input  logic [(     139)-1:0] pf_qed_5_wdata
    ,output logic [(     139)-1:0] pf_qed_5_rdata

    ,output logic                  sr_qed_5_re
    ,output logic                  sr_qed_5_clk
    ,output logic                  sr_qed_5_clk_rst_n
    ,output logic [(      11)-1:0] sr_qed_5_addr
    ,output logic                  sr_qed_5_we
    ,output logic [(     139)-1:0] sr_qed_5_wdata
    ,input  logic [(     139)-1:0] sr_qed_5_rdata

    ,output logic                  sr_qed_5_error

    ,input  logic                  func_qed_6_re
    ,input  logic [(      11)-1:0] func_qed_6_addr
    ,input  logic                  func_qed_6_we
    ,input  logic [(     139)-1:0] func_qed_6_wdata
    ,output logic [(     139)-1:0] func_qed_6_rdata

    ,input  logic                  pf_qed_6_re
    ,input  logic [(      11)-1:0] pf_qed_6_addr
    ,input  logic                  pf_qed_6_we
    ,input  logic [(     139)-1:0] pf_qed_6_wdata
    ,output logic [(     139)-1:0] pf_qed_6_rdata

    ,output logic                  sr_qed_6_re
    ,output logic                  sr_qed_6_clk
    ,output logic                  sr_qed_6_clk_rst_n
    ,output logic [(      11)-1:0] sr_qed_6_addr
    ,output logic                  sr_qed_6_we
    ,output logic [(     139)-1:0] sr_qed_6_wdata
    ,input  logic [(     139)-1:0] sr_qed_6_rdata

    ,output logic                  sr_qed_6_error

    ,input  logic                  func_qed_7_re
    ,input  logic [(      11)-1:0] func_qed_7_addr
    ,input  logic                  func_qed_7_we
    ,input  logic [(     139)-1:0] func_qed_7_wdata
    ,output logic [(     139)-1:0] func_qed_7_rdata

    ,input  logic                  pf_qed_7_re
    ,input  logic [(      11)-1:0] pf_qed_7_addr
    ,input  logic                  pf_qed_7_we
    ,input  logic [(     139)-1:0] pf_qed_7_wdata
    ,output logic [(     139)-1:0] pf_qed_7_rdata

    ,output logic                  sr_qed_7_re
    ,output logic                  sr_qed_7_clk
    ,output logic                  sr_qed_7_clk_rst_n
    ,output logic [(      11)-1:0] sr_qed_7_addr
    ,output logic                  sr_qed_7_we
    ,output logic [(     139)-1:0] sr_qed_7_wdata
    ,input  logic [(     139)-1:0] sr_qed_7_rdata

    ,output logic                  sr_qed_7_error

);

logic        rf_qed_chp_sch_data_rdata_error;

logic        cfg_mem_ack_qed_chp_sch_data_nc;
logic [31:0] cfg_mem_rdata_qed_chp_sch_data_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (8)
        ,.DWIDTH              (177)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_qed_chp_sch_data (
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_qed_chp_sch_data_re)
        ,.func_mem_raddr      (func_qed_chp_sch_data_raddr)
        ,.func_mem_waddr      (func_qed_chp_sch_data_waddr)
        ,.func_mem_we         (func_qed_chp_sch_data_we)
        ,.func_mem_wdata      (func_qed_chp_sch_data_wdata)
        ,.func_mem_rdata      (func_qed_chp_sch_data_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_qed_chp_sch_data_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_qed_chp_sch_data_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_qed_chp_sch_data_re)
        ,.pf_mem_raddr        (pf_qed_chp_sch_data_raddr)
        ,.pf_mem_waddr        (pf_qed_chp_sch_data_waddr)
        ,.pf_mem_we           (pf_qed_chp_sch_data_we)
        ,.pf_mem_wdata        (pf_qed_chp_sch_data_wdata)
        ,.pf_mem_rdata        (pf_qed_chp_sch_data_rdata)

        ,.mem_wclk            (rf_qed_chp_sch_data_wclk)
        ,.mem_rclk            (rf_qed_chp_sch_data_rclk)
        ,.mem_wclk_rst_n      (rf_qed_chp_sch_data_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_qed_chp_sch_data_rclk_rst_n)
        ,.mem_re              (rf_qed_chp_sch_data_re)
        ,.mem_raddr           (rf_qed_chp_sch_data_raddr)
        ,.mem_waddr           (rf_qed_chp_sch_data_waddr)
        ,.mem_we              (rf_qed_chp_sch_data_we)
        ,.mem_wdata           (rf_qed_chp_sch_data_wdata)
        ,.mem_rdata           (rf_qed_chp_sch_data_rdata)

        ,.mem_rdata_error     (rf_qed_chp_sch_data_rdata_error)
        ,.error               (rf_qed_chp_sch_data_error)
);

logic        rf_rx_sync_dp_dqed_data_rdata_error;

logic        cfg_mem_ack_rx_sync_dp_dqed_data_nc;
logic [31:0] cfg_mem_rdata_rx_sync_dp_dqed_data_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (4)
        ,.DWIDTH              (45)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_rx_sync_dp_dqed_data (
         .clk                 (hqm_inp_gated_clk)
        ,.rst_n               (hqm_inp_gated_rst_n)

        ,.func_mem_re         (func_rx_sync_dp_dqed_data_re)
        ,.func_mem_raddr      (func_rx_sync_dp_dqed_data_raddr)
        ,.func_mem_waddr      (func_rx_sync_dp_dqed_data_waddr)
        ,.func_mem_we         (func_rx_sync_dp_dqed_data_we)
        ,.func_mem_wdata      (func_rx_sync_dp_dqed_data_wdata)
        ,.func_mem_rdata      (func_rx_sync_dp_dqed_data_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_rx_sync_dp_dqed_data_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_rx_sync_dp_dqed_data_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_rx_sync_dp_dqed_data_re)
        ,.pf_mem_raddr        (pf_rx_sync_dp_dqed_data_raddr)
        ,.pf_mem_waddr        (pf_rx_sync_dp_dqed_data_waddr)
        ,.pf_mem_we           (pf_rx_sync_dp_dqed_data_we)
        ,.pf_mem_wdata        (pf_rx_sync_dp_dqed_data_wdata)
        ,.pf_mem_rdata        (pf_rx_sync_dp_dqed_data_rdata)

        ,.mem_wclk            (rf_rx_sync_dp_dqed_data_wclk)
        ,.mem_rclk            (rf_rx_sync_dp_dqed_data_rclk)
        ,.mem_wclk_rst_n      (rf_rx_sync_dp_dqed_data_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_rx_sync_dp_dqed_data_rclk_rst_n)
        ,.mem_re              (rf_rx_sync_dp_dqed_data_re)
        ,.mem_raddr           (rf_rx_sync_dp_dqed_data_raddr)
        ,.mem_waddr           (rf_rx_sync_dp_dqed_data_waddr)
        ,.mem_we              (rf_rx_sync_dp_dqed_data_we)
        ,.mem_wdata           (rf_rx_sync_dp_dqed_data_wdata)
        ,.mem_rdata           (rf_rx_sync_dp_dqed_data_rdata)

        ,.mem_rdata_error     (rf_rx_sync_dp_dqed_data_rdata_error)
        ,.error               (rf_rx_sync_dp_dqed_data_error)
);

logic        rf_rx_sync_nalb_qed_data_rdata_error;

logic        cfg_mem_ack_rx_sync_nalb_qed_data_nc;
logic [31:0] cfg_mem_rdata_rx_sync_nalb_qed_data_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (4)
        ,.DWIDTH              (45)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_rx_sync_nalb_qed_data (
         .clk                 (hqm_inp_gated_clk)
        ,.rst_n               (hqm_inp_gated_rst_n)

        ,.func_mem_re         (func_rx_sync_nalb_qed_data_re)
        ,.func_mem_raddr      (func_rx_sync_nalb_qed_data_raddr)
        ,.func_mem_waddr      (func_rx_sync_nalb_qed_data_waddr)
        ,.func_mem_we         (func_rx_sync_nalb_qed_data_we)
        ,.func_mem_wdata      (func_rx_sync_nalb_qed_data_wdata)
        ,.func_mem_rdata      (func_rx_sync_nalb_qed_data_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_rx_sync_nalb_qed_data_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_rx_sync_nalb_qed_data_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_rx_sync_nalb_qed_data_re)
        ,.pf_mem_raddr        (pf_rx_sync_nalb_qed_data_raddr)
        ,.pf_mem_waddr        (pf_rx_sync_nalb_qed_data_waddr)
        ,.pf_mem_we           (pf_rx_sync_nalb_qed_data_we)
        ,.pf_mem_wdata        (pf_rx_sync_nalb_qed_data_wdata)
        ,.pf_mem_rdata        (pf_rx_sync_nalb_qed_data_rdata)

        ,.mem_wclk            (rf_rx_sync_nalb_qed_data_wclk)
        ,.mem_rclk            (rf_rx_sync_nalb_qed_data_rclk)
        ,.mem_wclk_rst_n      (rf_rx_sync_nalb_qed_data_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_rx_sync_nalb_qed_data_rclk_rst_n)
        ,.mem_re              (rf_rx_sync_nalb_qed_data_re)
        ,.mem_raddr           (rf_rx_sync_nalb_qed_data_raddr)
        ,.mem_waddr           (rf_rx_sync_nalb_qed_data_waddr)
        ,.mem_we              (rf_rx_sync_nalb_qed_data_we)
        ,.mem_wdata           (rf_rx_sync_nalb_qed_data_wdata)
        ,.mem_rdata           (rf_rx_sync_nalb_qed_data_rdata)

        ,.mem_rdata_error     (rf_rx_sync_nalb_qed_data_rdata_error)
        ,.error               (rf_rx_sync_nalb_qed_data_error)
);

logic        rf_rx_sync_rop_qed_dqed_enq_rdata_error;

logic        cfg_mem_ack_rx_sync_rop_qed_dqed_enq_nc;
logic [31:0] cfg_mem_rdata_rx_sync_rop_qed_dqed_enq_nc;

hqm_AW_rfw_access #( 
         .DEPTH               (4)
        ,.DWIDTH              (157)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
        ,.IPAR_BITS           (0)
) i_rx_sync_rop_qed_dqed_enq (
         .clk                 (hqm_inp_gated_clk)
        ,.rst_n               (hqm_inp_gated_rst_n)

        ,.func_mem_re         (func_rx_sync_rop_qed_dqed_enq_re)
        ,.func_mem_raddr      (func_rx_sync_rop_qed_dqed_enq_raddr)
        ,.func_mem_waddr      (func_rx_sync_rop_qed_dqed_enq_waddr)
        ,.func_mem_we         (func_rx_sync_rop_qed_dqed_enq_we)
        ,.func_mem_wdata      (func_rx_sync_rop_qed_dqed_enq_wdata)
        ,.func_mem_rdata      (func_rx_sync_rop_qed_dqed_enq_rdata)

        ,.cfg_mem_re          ('0)
        ,.cfg_mem_we          ('0)
        ,.cfg_mem_addr        ('0)
        ,.cfg_mem_minbit      ('0)
        ,.cfg_mem_maxbit      ('0)
        ,.cfg_mem_wdata       ('0)
        ,.cfg_mem_rdata       (cfg_mem_rdata_rx_sync_rop_qed_dqed_enq_nc)
        ,.cfg_mem_ack         (cfg_mem_ack_rx_sync_rop_qed_dqed_enq_nc)
        ,.cfg_mem_cc_v        ('0)
        ,.cfg_mem_cc_value    ('0)
        ,.cfg_mem_cc_width    ('0)
        ,.cfg_mem_cc_position ('0)

        ,.pf_mem_re           (pf_rx_sync_rop_qed_dqed_enq_re)
        ,.pf_mem_raddr        (pf_rx_sync_rop_qed_dqed_enq_raddr)
        ,.pf_mem_waddr        (pf_rx_sync_rop_qed_dqed_enq_waddr)
        ,.pf_mem_we           (pf_rx_sync_rop_qed_dqed_enq_we)
        ,.pf_mem_wdata        (pf_rx_sync_rop_qed_dqed_enq_wdata)
        ,.pf_mem_rdata        (pf_rx_sync_rop_qed_dqed_enq_rdata)

        ,.mem_wclk            (rf_rx_sync_rop_qed_dqed_enq_wclk)
        ,.mem_rclk            (rf_rx_sync_rop_qed_dqed_enq_rclk)
        ,.mem_wclk_rst_n      (rf_rx_sync_rop_qed_dqed_enq_wclk_rst_n)
        ,.mem_rclk_rst_n      (rf_rx_sync_rop_qed_dqed_enq_rclk_rst_n)
        ,.mem_re              (rf_rx_sync_rop_qed_dqed_enq_re)
        ,.mem_raddr           (rf_rx_sync_rop_qed_dqed_enq_raddr)
        ,.mem_waddr           (rf_rx_sync_rop_qed_dqed_enq_waddr)
        ,.mem_we              (rf_rx_sync_rop_qed_dqed_enq_we)
        ,.mem_wdata           (rf_rx_sync_rop_qed_dqed_enq_wdata)
        ,.mem_rdata           (rf_rx_sync_rop_qed_dqed_enq_rdata)

        ,.mem_rdata_error     (rf_rx_sync_rop_qed_dqed_enq_rdata_error)
        ,.error               (rf_rx_sync_rop_qed_dqed_enq_error)
);

hqm_AW_srw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (139)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
) i_qed_0 ( 
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_qed_0_re)
        ,.func_mem_addr       (func_qed_0_addr)
        ,.func_mem_we         (func_qed_0_we)
        ,.func_mem_wdata      (func_qed_0_wdata)
        ,.func_mem_rdata      (func_qed_0_rdata)

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

        ,.pf_mem_re           (pf_qed_0_re)
        ,.pf_mem_addr         (pf_qed_0_addr)
        ,.pf_mem_we           (pf_qed_0_we)
        ,.pf_mem_wdata        (pf_qed_0_wdata)
        ,.pf_mem_rdata        (pf_qed_0_rdata)

        ,.mem_clk             (sr_qed_0_clk)
        ,.mem_clk_rst_n       (sr_qed_0_clk_rst_n)
        ,.mem_re              (sr_qed_0_re)
        ,.mem_addr            (sr_qed_0_addr)
        ,.mem_we              (sr_qed_0_we)
        ,.mem_wdata           (sr_qed_0_wdata)
        ,.mem_rdata           (sr_qed_0_rdata)

        ,.error               (sr_qed_0_error)
);


hqm_AW_srw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (139)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
) i_qed_1 ( 
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_qed_1_re)
        ,.func_mem_addr       (func_qed_1_addr)
        ,.func_mem_we         (func_qed_1_we)
        ,.func_mem_wdata      (func_qed_1_wdata)
        ,.func_mem_rdata      (func_qed_1_rdata)

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

        ,.pf_mem_re           (pf_qed_1_re)
        ,.pf_mem_addr         (pf_qed_1_addr)
        ,.pf_mem_we           (pf_qed_1_we)
        ,.pf_mem_wdata        (pf_qed_1_wdata)
        ,.pf_mem_rdata        (pf_qed_1_rdata)

        ,.mem_clk             (sr_qed_1_clk)
        ,.mem_clk_rst_n       (sr_qed_1_clk_rst_n)
        ,.mem_re              (sr_qed_1_re)
        ,.mem_addr            (sr_qed_1_addr)
        ,.mem_we              (sr_qed_1_we)
        ,.mem_wdata           (sr_qed_1_wdata)
        ,.mem_rdata           (sr_qed_1_rdata)

        ,.error               (sr_qed_1_error)
);


hqm_AW_srw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (139)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
) i_qed_2 ( 
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_qed_2_re)
        ,.func_mem_addr       (func_qed_2_addr)
        ,.func_mem_we         (func_qed_2_we)
        ,.func_mem_wdata      (func_qed_2_wdata)
        ,.func_mem_rdata      (func_qed_2_rdata)

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

        ,.pf_mem_re           (pf_qed_2_re)
        ,.pf_mem_addr         (pf_qed_2_addr)
        ,.pf_mem_we           (pf_qed_2_we)
        ,.pf_mem_wdata        (pf_qed_2_wdata)
        ,.pf_mem_rdata        (pf_qed_2_rdata)

        ,.mem_clk             (sr_qed_2_clk)
        ,.mem_clk_rst_n       (sr_qed_2_clk_rst_n)
        ,.mem_re              (sr_qed_2_re)
        ,.mem_addr            (sr_qed_2_addr)
        ,.mem_we              (sr_qed_2_we)
        ,.mem_wdata           (sr_qed_2_wdata)
        ,.mem_rdata           (sr_qed_2_rdata)

        ,.error               (sr_qed_2_error)
);


hqm_AW_srw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (139)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
) i_qed_3 ( 
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_qed_3_re)
        ,.func_mem_addr       (func_qed_3_addr)
        ,.func_mem_we         (func_qed_3_we)
        ,.func_mem_wdata      (func_qed_3_wdata)
        ,.func_mem_rdata      (func_qed_3_rdata)

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

        ,.pf_mem_re           (pf_qed_3_re)
        ,.pf_mem_addr         (pf_qed_3_addr)
        ,.pf_mem_we           (pf_qed_3_we)
        ,.pf_mem_wdata        (pf_qed_3_wdata)
        ,.pf_mem_rdata        (pf_qed_3_rdata)

        ,.mem_clk             (sr_qed_3_clk)
        ,.mem_clk_rst_n       (sr_qed_3_clk_rst_n)
        ,.mem_re              (sr_qed_3_re)
        ,.mem_addr            (sr_qed_3_addr)
        ,.mem_we              (sr_qed_3_we)
        ,.mem_wdata           (sr_qed_3_wdata)
        ,.mem_rdata           (sr_qed_3_rdata)

        ,.error               (sr_qed_3_error)
);


hqm_AW_srw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (139)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
) i_qed_4 ( 
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_qed_4_re)
        ,.func_mem_addr       (func_qed_4_addr)
        ,.func_mem_we         (func_qed_4_we)
        ,.func_mem_wdata      (func_qed_4_wdata)
        ,.func_mem_rdata      (func_qed_4_rdata)

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

        ,.pf_mem_re           (pf_qed_4_re)
        ,.pf_mem_addr         (pf_qed_4_addr)
        ,.pf_mem_we           (pf_qed_4_we)
        ,.pf_mem_wdata        (pf_qed_4_wdata)
        ,.pf_mem_rdata        (pf_qed_4_rdata)

        ,.mem_clk             (sr_qed_4_clk)
        ,.mem_clk_rst_n       (sr_qed_4_clk_rst_n)
        ,.mem_re              (sr_qed_4_re)
        ,.mem_addr            (sr_qed_4_addr)
        ,.mem_we              (sr_qed_4_we)
        ,.mem_wdata           (sr_qed_4_wdata)
        ,.mem_rdata           (sr_qed_4_rdata)

        ,.error               (sr_qed_4_error)
);


hqm_AW_srw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (139)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
) i_qed_5 ( 
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_qed_5_re)
        ,.func_mem_addr       (func_qed_5_addr)
        ,.func_mem_we         (func_qed_5_we)
        ,.func_mem_wdata      (func_qed_5_wdata)
        ,.func_mem_rdata      (func_qed_5_rdata)

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

        ,.pf_mem_re           (pf_qed_5_re)
        ,.pf_mem_addr         (pf_qed_5_addr)
        ,.pf_mem_we           (pf_qed_5_we)
        ,.pf_mem_wdata        (pf_qed_5_wdata)
        ,.pf_mem_rdata        (pf_qed_5_rdata)

        ,.mem_clk             (sr_qed_5_clk)
        ,.mem_clk_rst_n       (sr_qed_5_clk_rst_n)
        ,.mem_re              (sr_qed_5_re)
        ,.mem_addr            (sr_qed_5_addr)
        ,.mem_we              (sr_qed_5_we)
        ,.mem_wdata           (sr_qed_5_wdata)
        ,.mem_rdata           (sr_qed_5_rdata)

        ,.error               (sr_qed_5_error)
);


hqm_AW_srw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (139)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
) i_qed_6 ( 
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_qed_6_re)
        ,.func_mem_addr       (func_qed_6_addr)
        ,.func_mem_we         (func_qed_6_we)
        ,.func_mem_wdata      (func_qed_6_wdata)
        ,.func_mem_rdata      (func_qed_6_rdata)

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

        ,.pf_mem_re           (pf_qed_6_re)
        ,.pf_mem_addr         (pf_qed_6_addr)
        ,.pf_mem_we           (pf_qed_6_we)
        ,.pf_mem_wdata        (pf_qed_6_wdata)
        ,.pf_mem_rdata        (pf_qed_6_rdata)

        ,.mem_clk             (sr_qed_6_clk)
        ,.mem_clk_rst_n       (sr_qed_6_clk_rst_n)
        ,.mem_re              (sr_qed_6_re)
        ,.mem_addr            (sr_qed_6_addr)
        ,.mem_we              (sr_qed_6_we)
        ,.mem_wdata           (sr_qed_6_wdata)
        ,.mem_rdata           (sr_qed_6_rdata)

        ,.error               (sr_qed_6_error)
);


hqm_AW_srw_access #( 
         .DEPTH               (2048)
        ,.DWIDTH              (139)
        ,.AWIDTHPAD           (0)
        ,.DWIDTHPAD           (0)
) i_qed_7 ( 
         .clk                 (hqm_gated_clk)
        ,.rst_n               (hqm_gated_rst_n)

        ,.func_mem_re         (func_qed_7_re)
        ,.func_mem_addr       (func_qed_7_addr)
        ,.func_mem_we         (func_qed_7_we)
        ,.func_mem_wdata      (func_qed_7_wdata)
        ,.func_mem_rdata      (func_qed_7_rdata)

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

        ,.pf_mem_re           (pf_qed_7_re)
        ,.pf_mem_addr         (pf_qed_7_addr)
        ,.pf_mem_we           (pf_qed_7_we)
        ,.pf_mem_wdata        (pf_qed_7_wdata)
        ,.pf_mem_rdata        (pf_qed_7_rdata)

        ,.mem_clk             (sr_qed_7_clk)
        ,.mem_clk_rst_n       (sr_qed_7_clk_rst_n)
        ,.mem_re              (sr_qed_7_re)
        ,.mem_addr            (sr_qed_7_addr)
        ,.mem_we              (sr_qed_7_we)
        ,.mem_wdata           (sr_qed_7_wdata)
        ,.mem_rdata           (sr_qed_7_rdata)

        ,.error               (sr_qed_7_error)
);


assign hqm_qed_pipe_rfw_top_ipar_error = rf_qed_chp_sch_data_rdata_error | rf_rx_sync_dp_dqed_data_rdata_error | rf_rx_sync_nalb_qed_data_rdata_error | rf_rx_sync_rop_qed_dqed_enq_rdata_error ;

endmodule

