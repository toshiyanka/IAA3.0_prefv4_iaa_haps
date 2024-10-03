module hqm_system_mem_prim_clk_rf_dc_pg_cont (

     input  logic                        rf_hcw_enq_fifo_wclk
    ,input  logic                        rf_hcw_enq_fifo_wclk_rst_n
    ,input  logic                        rf_hcw_enq_fifo_we
    ,input  logic [ (   8 ) -1 : 0 ]     rf_hcw_enq_fifo_waddr
    ,input  logic [ ( 167 ) -1 : 0 ]     rf_hcw_enq_fifo_wdata
    ,input  logic                        rf_hcw_enq_fifo_rclk
    ,input  logic                        rf_hcw_enq_fifo_rclk_rst_n
    ,input  logic                        rf_hcw_enq_fifo_re
    ,input  logic [ (   8 ) -1 : 0 ]     rf_hcw_enq_fifo_raddr
    ,output logic [ ( 167 ) -1 : 0 ]     rf_hcw_enq_fifo_rdata

    ,input  logic                        rf_hcw_enq_fifo_isol_en
    ,input  logic                        rf_hcw_enq_fifo_pwr_enable_b_in
    ,output logic                        rf_hcw_enq_fifo_pwr_enable_b_out

    ,input  logic                        powergood_rst_b

    ,input  logic                        hqm_pwrgood_rst_b

    ,input  logic                        fscan_byprst_b
    ,input  logic                        fscan_clkungate
    ,input  logic                        fscan_rstbypen
);

logic ip_reset_b;

assign ip_reset_b = powergood_rst_b & hqm_pwrgood_rst_b;

hqm_system_mem_AW_rf_dc_pg_256x167 i_rf_hcw_enq_fifo (

     .wclk                    (rf_hcw_enq_fifo_wclk)
    ,.wclk_rst_n              (rf_hcw_enq_fifo_wclk_rst_n)
    ,.we                      (rf_hcw_enq_fifo_we)
    ,.waddr                   (rf_hcw_enq_fifo_waddr)
    ,.wdata                   (rf_hcw_enq_fifo_wdata)
    ,.rclk                    (rf_hcw_enq_fifo_rclk)
    ,.rclk_rst_n              (rf_hcw_enq_fifo_rclk_rst_n)
    ,.re                      (rf_hcw_enq_fifo_re)
    ,.raddr                   (rf_hcw_enq_fifo_raddr)
    ,.rdata                   (rf_hcw_enq_fifo_rdata)

    ,.pgcb_isol_en            (rf_hcw_enq_fifo_isol_en)
    ,.pwr_enable_b_in         (rf_hcw_enq_fifo_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_hcw_enq_fifo_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

endmodule

