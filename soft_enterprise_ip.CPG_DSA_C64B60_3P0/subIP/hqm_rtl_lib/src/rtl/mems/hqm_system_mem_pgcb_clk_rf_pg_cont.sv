module hqm_system_mem_pgcb_clk_rf_pg_cont (

     input  logic                        rf_count_rmw_pipe_wd_dir_mem_wclk
    ,input  logic                        rf_count_rmw_pipe_wd_dir_mem_wclk_rst_n
    ,input  logic                        rf_count_rmw_pipe_wd_dir_mem_we
    ,input  logic [ (   6 ) -1 : 0 ]     rf_count_rmw_pipe_wd_dir_mem_waddr
    ,input  logic [ (  10 ) -1 : 0 ]     rf_count_rmw_pipe_wd_dir_mem_wdata
    ,input  logic                        rf_count_rmw_pipe_wd_dir_mem_rclk
    ,input  logic                        rf_count_rmw_pipe_wd_dir_mem_rclk_rst_n
    ,input  logic                        rf_count_rmw_pipe_wd_dir_mem_re
    ,input  logic [ (   6 ) -1 : 0 ]     rf_count_rmw_pipe_wd_dir_mem_raddr
    ,output logic [ (  10 ) -1 : 0 ]     rf_count_rmw_pipe_wd_dir_mem_rdata

    ,input  logic                        rf_count_rmw_pipe_wd_dir_mem_isol_en
    ,input  logic                        rf_count_rmw_pipe_wd_dir_mem_pwr_enable_b_in
    ,output logic                        rf_count_rmw_pipe_wd_dir_mem_pwr_enable_b_out

    ,input  logic                        rf_count_rmw_pipe_wd_ldb_mem_wclk
    ,input  logic                        rf_count_rmw_pipe_wd_ldb_mem_wclk_rst_n
    ,input  logic                        rf_count_rmw_pipe_wd_ldb_mem_we
    ,input  logic [ (   6 ) -1 : 0 ]     rf_count_rmw_pipe_wd_ldb_mem_waddr
    ,input  logic [ (  10 ) -1 : 0 ]     rf_count_rmw_pipe_wd_ldb_mem_wdata
    ,input  logic                        rf_count_rmw_pipe_wd_ldb_mem_rclk
    ,input  logic                        rf_count_rmw_pipe_wd_ldb_mem_rclk_rst_n
    ,input  logic                        rf_count_rmw_pipe_wd_ldb_mem_re
    ,input  logic [ (   6 ) -1 : 0 ]     rf_count_rmw_pipe_wd_ldb_mem_raddr
    ,output logic [ (  10 ) -1 : 0 ]     rf_count_rmw_pipe_wd_ldb_mem_rdata

    ,input  logic                        rf_count_rmw_pipe_wd_ldb_mem_isol_en
    ,input  logic                        rf_count_rmw_pipe_wd_ldb_mem_pwr_enable_b_in
    ,output logic                        rf_count_rmw_pipe_wd_ldb_mem_pwr_enable_b_out

    ,input  logic                        powergood_rst_b

    ,input  logic                        hqm_pwrgood_rst_b

    ,input  logic                        fscan_byprst_b
    ,input  logic                        fscan_clkungate
    ,input  logic                        fscan_rstbypen
);

logic ip_reset_b;

assign ip_reset_b = powergood_rst_b & hqm_pwrgood_rst_b;

hqm_system_mem_AW_rf_pg_64x10 i_rf_count_rmw_pipe_wd_dir_mem (

     .wclk                    (rf_count_rmw_pipe_wd_dir_mem_wclk)
    ,.wclk_rst_n              (rf_count_rmw_pipe_wd_dir_mem_wclk_rst_n)
    ,.we                      (rf_count_rmw_pipe_wd_dir_mem_we)
    ,.waddr                   (rf_count_rmw_pipe_wd_dir_mem_waddr)
    ,.wdata                   (rf_count_rmw_pipe_wd_dir_mem_wdata)
    ,.rclk                    (rf_count_rmw_pipe_wd_dir_mem_rclk)
    ,.rclk_rst_n              (rf_count_rmw_pipe_wd_dir_mem_rclk_rst_n)
    ,.re                      (rf_count_rmw_pipe_wd_dir_mem_re)
    ,.raddr                   (rf_count_rmw_pipe_wd_dir_mem_raddr)
    ,.rdata                   (rf_count_rmw_pipe_wd_dir_mem_rdata)

    ,.pgcb_isol_en            (rf_count_rmw_pipe_wd_dir_mem_isol_en)
    ,.pwr_enable_b_in         (rf_count_rmw_pipe_wd_dir_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_count_rmw_pipe_wd_dir_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_64x10 i_rf_count_rmw_pipe_wd_ldb_mem (

     .wclk                    (rf_count_rmw_pipe_wd_ldb_mem_wclk)
    ,.wclk_rst_n              (rf_count_rmw_pipe_wd_ldb_mem_wclk_rst_n)
    ,.we                      (rf_count_rmw_pipe_wd_ldb_mem_we)
    ,.waddr                   (rf_count_rmw_pipe_wd_ldb_mem_waddr)
    ,.wdata                   (rf_count_rmw_pipe_wd_ldb_mem_wdata)
    ,.rclk                    (rf_count_rmw_pipe_wd_ldb_mem_rclk)
    ,.rclk_rst_n              (rf_count_rmw_pipe_wd_ldb_mem_rclk_rst_n)
    ,.re                      (rf_count_rmw_pipe_wd_ldb_mem_re)
    ,.raddr                   (rf_count_rmw_pipe_wd_ldb_mem_raddr)
    ,.rdata                   (rf_count_rmw_pipe_wd_ldb_mem_rdata)

    ,.pgcb_isol_en            (rf_count_rmw_pipe_wd_ldb_mem_isol_en)
    ,.pwr_enable_b_in         (rf_count_rmw_pipe_wd_ldb_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_count_rmw_pipe_wd_ldb_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

endmodule

