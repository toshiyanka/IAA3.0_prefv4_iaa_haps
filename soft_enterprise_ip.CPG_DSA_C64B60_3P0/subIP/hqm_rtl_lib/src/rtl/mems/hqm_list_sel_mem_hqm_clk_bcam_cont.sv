module hqm_list_sel_mem_hqm_clk_bcam_cont (

     input  logic                        bcam_AW_bcam_2048x26_wclk
    ,input  logic [ 64 -1 : 0 ]          bcam_AW_bcam_2048x26_waddr
    ,input  logic [ 8  -1 : 0 ]          bcam_AW_bcam_2048x26_we
    ,input  logic [ 208 -1 : 0 ]         bcam_AW_bcam_2048x26_wdata
    ,input  logic                        bcam_AW_bcam_2048x26_rclk
    ,input  logic [ 8-1 : 0 ]            bcam_AW_bcam_2048x26_raddr
    ,input  logic                        bcam_AW_bcam_2048x26_re
    ,output logic [ 208 -1 : 0 ]         bcam_AW_bcam_2048x26_rdata
    ,input  logic                        bcam_AW_bcam_2048x26_cclk
    ,input  logic [ 208 -1 : 0 ]         bcam_AW_bcam_2048x26_cdata
    ,input  logic [ 8  -1 : 0 ]          bcam_AW_bcam_2048x26_ce
    ,output logic [ 2048 -1 : 0 ]        bcam_AW_bcam_2048x26_cmatch

    ,input  logic                        bcam_AW_bcam_2048x26_isol_en_b

    ,input  logic                        bcam_AW_bcam_2048x26_dfx_clk

    ,input  logic                        bcam_AW_bcam_2048x26_fd
    ,input  logic                        bcam_AW_bcam_2048x26_rd

    ,input  logic                        powergood_rst_b

    ,input  logic                        hqm_pwrgood_rst_b

    ,input  logic                        fscan_byprst_b
    ,input  logic                        fscan_rstbypen
);

logic ip_reset_b;

assign ip_reset_b = powergood_rst_b & hqm_pwrgood_rst_b;

hqm_list_sel_mem_AW_bcam_2048x26 i_AW_bcam_2048x26 (

     .FUNC_WR_CLK_RF_IN_P0    (bcam_AW_bcam_2048x26_wclk)
    ,.FUNC_WEN_RF_IN_P0       (bcam_AW_bcam_2048x26_we)
    ,.FUNC_WR_ADDR_RF_IN_P0   (bcam_AW_bcam_2048x26_waddr)
    ,.FUNC_WR_DATA_RF_IN_P0   (bcam_AW_bcam_2048x26_wdata)
    ,.FUNC_CM_CLK_RF_IN_P0    (bcam_AW_bcam_2048x26_cclk)
    ,.FUNC_CEN_RF_IN_P0       (bcam_AW_bcam_2048x26_ce)
    ,.FUNC_CM_DATA_RF_IN_P0   (bcam_AW_bcam_2048x26_cdata)
    ,.CM_MATCH_RF_OUT_P0      (bcam_AW_bcam_2048x26_cmatch)
    ,.FUNC_RD_CLK_RF_IN_P0    (bcam_AW_bcam_2048x26_rclk)
    ,.FUNC_REN_RF_IN_P0       (bcam_AW_bcam_2048x26_re)
    ,.FUNC_RD_ADDR_RF_IN_P0   (bcam_AW_bcam_2048x26_raddr)
    ,.DATA_RF_OUT_P0          (bcam_AW_bcam_2048x26_rdata)

    ,.CLK_DFX_WRAPPER         (bcam_AW_bcam_2048x26_dfx_clk)

    ,.pgcb_isol_en_b          (bcam_AW_bcam_2048x26_isol_en_b)

    ,.fd                      (bcam_AW_bcam_2048x26_fd)
    ,.rd                      (bcam_AW_bcam_2048x26_rd)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

endmodule

