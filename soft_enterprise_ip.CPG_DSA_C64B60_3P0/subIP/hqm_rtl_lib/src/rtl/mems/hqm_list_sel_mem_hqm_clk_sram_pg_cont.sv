module hqm_list_sel_mem_hqm_clk_sram_pg_cont (

     input  logic                        sr_aqed_clk
    ,input  logic                        sr_aqed_clk_rst_n
    ,input  logic [ (  11 ) -1 : 0 ]     sr_aqed_addr
    ,input  logic                        sr_aqed_we
    ,input  logic [ ( 139 ) -1 : 0 ]     sr_aqed_wdata
    ,input  logic                        sr_aqed_re
    ,output logic [ ( 139 ) -1 : 0 ]     sr_aqed_rdata

    ,input  logic                        sr_aqed_isol_en
    ,input  logic                        sr_aqed_pwr_enable_b_in
    ,output logic                        sr_aqed_pwr_enable_b_out

    ,input  logic                        sr_aqed_freelist_clk
    ,input  logic                        sr_aqed_freelist_clk_rst_n
    ,input  logic [ (  11 ) -1 : 0 ]     sr_aqed_freelist_addr
    ,input  logic                        sr_aqed_freelist_we
    ,input  logic [ (  16 ) -1 : 0 ]     sr_aqed_freelist_wdata
    ,input  logic                        sr_aqed_freelist_re
    ,output logic [ (  16 ) -1 : 0 ]     sr_aqed_freelist_rdata

    ,input  logic                        sr_aqed_freelist_isol_en
    ,input  logic                        sr_aqed_freelist_pwr_enable_b_in
    ,output logic                        sr_aqed_freelist_pwr_enable_b_out

    ,input  logic                        sr_aqed_ll_qe_hpnxt_clk
    ,input  logic                        sr_aqed_ll_qe_hpnxt_clk_rst_n
    ,input  logic [ (  11 ) -1 : 0 ]     sr_aqed_ll_qe_hpnxt_addr
    ,input  logic                        sr_aqed_ll_qe_hpnxt_we
    ,input  logic [ (  16 ) -1 : 0 ]     sr_aqed_ll_qe_hpnxt_wdata
    ,input  logic                        sr_aqed_ll_qe_hpnxt_re
    ,output logic [ (  16 ) -1 : 0 ]     sr_aqed_ll_qe_hpnxt_rdata

    ,input  logic                        sr_aqed_ll_qe_hpnxt_isol_en
    ,input  logic                        sr_aqed_ll_qe_hpnxt_pwr_enable_b_in
    ,output logic                        sr_aqed_ll_qe_hpnxt_pwr_enable_b_out

    ,input  logic                        powergood_rst_b

    ,input  logic                        hqm_pwrgood_rst_b

    ,input  logic                        fscan_byprst_b
    ,input  logic                        fscan_clkungate
    ,input  logic                        fscan_rstbypen
);

logic ip_reset_b;

assign ip_reset_b = powergood_rst_b & hqm_pwrgood_rst_b;

hqm_list_sel_mem_AW_sram_pg_2048x139 i_sr_aqed (

     .clk                     (sr_aqed_clk)
    ,.clk_rst_n               (sr_aqed_clk_rst_n)
    ,.we                      (sr_aqed_we)
    ,.addr                    (sr_aqed_addr)
    ,.wdata                   (sr_aqed_wdata)
    ,.re                      (sr_aqed_re)
    ,.rdata                   (sr_aqed_rdata)

    ,.pgcb_isol_en            (sr_aqed_isol_en)
    ,.pwr_enable_b_in         (sr_aqed_pwr_enable_b_in)
    ,.pwr_enable_b_out        (sr_aqed_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_sram_pg_2048x16 i_sr_aqed_freelist (

     .clk                     (sr_aqed_freelist_clk)
    ,.clk_rst_n               (sr_aqed_freelist_clk_rst_n)
    ,.we                      (sr_aqed_freelist_we)
    ,.addr                    (sr_aqed_freelist_addr)
    ,.wdata                   (sr_aqed_freelist_wdata)
    ,.re                      (sr_aqed_freelist_re)
    ,.rdata                   (sr_aqed_freelist_rdata)

    ,.pgcb_isol_en            (sr_aqed_freelist_isol_en)
    ,.pwr_enable_b_in         (sr_aqed_freelist_pwr_enable_b_in)
    ,.pwr_enable_b_out        (sr_aqed_freelist_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_sram_pg_2048x16 i_sr_aqed_ll_qe_hpnxt (

     .clk                     (sr_aqed_ll_qe_hpnxt_clk)
    ,.clk_rst_n               (sr_aqed_ll_qe_hpnxt_clk_rst_n)
    ,.we                      (sr_aqed_ll_qe_hpnxt_we)
    ,.addr                    (sr_aqed_ll_qe_hpnxt_addr)
    ,.wdata                   (sr_aqed_ll_qe_hpnxt_wdata)
    ,.re                      (sr_aqed_ll_qe_hpnxt_re)
    ,.rdata                   (sr_aqed_ll_qe_hpnxt_rdata)

    ,.pgcb_isol_en            (sr_aqed_ll_qe_hpnxt_isol_en)
    ,.pwr_enable_b_in         (sr_aqed_ll_qe_hpnxt_pwr_enable_b_in)
    ,.pwr_enable_b_out        (sr_aqed_ll_qe_hpnxt_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

endmodule

