module hqm_system_mem_hqm_clk_sram_pg_cont (

     input  logic                        sr_freelist_0_clk
    ,input  logic                        sr_freelist_0_clk_rst_n
    ,input  logic [ (  11 ) -1 : 0 ]     sr_freelist_0_addr
    ,input  logic                        sr_freelist_0_we
    ,input  logic [ (  16 ) -1 : 0 ]     sr_freelist_0_wdata
    ,input  logic                        sr_freelist_0_re
    ,output logic [ (  16 ) -1 : 0 ]     sr_freelist_0_rdata

    ,input  logic                        sr_freelist_0_isol_en
    ,input  logic                        sr_freelist_0_pwr_enable_b_in
    ,output logic                        sr_freelist_0_pwr_enable_b_out

    ,input  logic                        sr_freelist_1_clk
    ,input  logic                        sr_freelist_1_clk_rst_n
    ,input  logic [ (  11 ) -1 : 0 ]     sr_freelist_1_addr
    ,input  logic                        sr_freelist_1_we
    ,input  logic [ (  16 ) -1 : 0 ]     sr_freelist_1_wdata
    ,input  logic                        sr_freelist_1_re
    ,output logic [ (  16 ) -1 : 0 ]     sr_freelist_1_rdata

    ,input  logic                        sr_freelist_1_isol_en
    ,input  logic                        sr_freelist_1_pwr_enable_b_in
    ,output logic                        sr_freelist_1_pwr_enable_b_out

    ,input  logic                        sr_freelist_2_clk
    ,input  logic                        sr_freelist_2_clk_rst_n
    ,input  logic [ (  11 ) -1 : 0 ]     sr_freelist_2_addr
    ,input  logic                        sr_freelist_2_we
    ,input  logic [ (  16 ) -1 : 0 ]     sr_freelist_2_wdata
    ,input  logic                        sr_freelist_2_re
    ,output logic [ (  16 ) -1 : 0 ]     sr_freelist_2_rdata

    ,input  logic                        sr_freelist_2_isol_en
    ,input  logic                        sr_freelist_2_pwr_enable_b_in
    ,output logic                        sr_freelist_2_pwr_enable_b_out

    ,input  logic                        sr_freelist_3_clk
    ,input  logic                        sr_freelist_3_clk_rst_n
    ,input  logic [ (  11 ) -1 : 0 ]     sr_freelist_3_addr
    ,input  logic                        sr_freelist_3_we
    ,input  logic [ (  16 ) -1 : 0 ]     sr_freelist_3_wdata
    ,input  logic                        sr_freelist_3_re
    ,output logic [ (  16 ) -1 : 0 ]     sr_freelist_3_rdata

    ,input  logic                        sr_freelist_3_isol_en
    ,input  logic                        sr_freelist_3_pwr_enable_b_in
    ,output logic                        sr_freelist_3_pwr_enable_b_out

    ,input  logic                        sr_freelist_4_clk
    ,input  logic                        sr_freelist_4_clk_rst_n
    ,input  logic [ (  11 ) -1 : 0 ]     sr_freelist_4_addr
    ,input  logic                        sr_freelist_4_we
    ,input  logic [ (  16 ) -1 : 0 ]     sr_freelist_4_wdata
    ,input  logic                        sr_freelist_4_re
    ,output logic [ (  16 ) -1 : 0 ]     sr_freelist_4_rdata

    ,input  logic                        sr_freelist_4_isol_en
    ,input  logic                        sr_freelist_4_pwr_enable_b_in
    ,output logic                        sr_freelist_4_pwr_enable_b_out

    ,input  logic                        sr_freelist_5_clk
    ,input  logic                        sr_freelist_5_clk_rst_n
    ,input  logic [ (  11 ) -1 : 0 ]     sr_freelist_5_addr
    ,input  logic                        sr_freelist_5_we
    ,input  logic [ (  16 ) -1 : 0 ]     sr_freelist_5_wdata
    ,input  logic                        sr_freelist_5_re
    ,output logic [ (  16 ) -1 : 0 ]     sr_freelist_5_rdata

    ,input  logic                        sr_freelist_5_isol_en
    ,input  logic                        sr_freelist_5_pwr_enable_b_in
    ,output logic                        sr_freelist_5_pwr_enable_b_out

    ,input  logic                        sr_freelist_6_clk
    ,input  logic                        sr_freelist_6_clk_rst_n
    ,input  logic [ (  11 ) -1 : 0 ]     sr_freelist_6_addr
    ,input  logic                        sr_freelist_6_we
    ,input  logic [ (  16 ) -1 : 0 ]     sr_freelist_6_wdata
    ,input  logic                        sr_freelist_6_re
    ,output logic [ (  16 ) -1 : 0 ]     sr_freelist_6_rdata

    ,input  logic                        sr_freelist_6_isol_en
    ,input  logic                        sr_freelist_6_pwr_enable_b_in
    ,output logic                        sr_freelist_6_pwr_enable_b_out

    ,input  logic                        sr_freelist_7_clk
    ,input  logic                        sr_freelist_7_clk_rst_n
    ,input  logic [ (  11 ) -1 : 0 ]     sr_freelist_7_addr
    ,input  logic                        sr_freelist_7_we
    ,input  logic [ (  16 ) -1 : 0 ]     sr_freelist_7_wdata
    ,input  logic                        sr_freelist_7_re
    ,output logic [ (  16 ) -1 : 0 ]     sr_freelist_7_rdata

    ,input  logic                        sr_freelist_7_isol_en
    ,input  logic                        sr_freelist_7_pwr_enable_b_in
    ,output logic                        sr_freelist_7_pwr_enable_b_out

    ,input  logic                        sr_hist_list_clk
    ,input  logic                        sr_hist_list_clk_rst_n
    ,input  logic [ (  11 ) -1 : 0 ]     sr_hist_list_addr
    ,input  logic                        sr_hist_list_we
    ,input  logic [ (  66 ) -1 : 0 ]     sr_hist_list_wdata
    ,input  logic                        sr_hist_list_re
    ,output logic [ (  66 ) -1 : 0 ]     sr_hist_list_rdata

    ,input  logic                        sr_hist_list_isol_en
    ,input  logic                        sr_hist_list_pwr_enable_b_in
    ,output logic                        sr_hist_list_pwr_enable_b_out

    ,input  logic                        sr_hist_list_a_clk
    ,input  logic                        sr_hist_list_a_clk_rst_n
    ,input  logic [ (  11 ) -1 : 0 ]     sr_hist_list_a_addr
    ,input  logic                        sr_hist_list_a_we
    ,input  logic [ (  66 ) -1 : 0 ]     sr_hist_list_a_wdata
    ,input  logic                        sr_hist_list_a_re
    ,output logic [ (  66 ) -1 : 0 ]     sr_hist_list_a_rdata

    ,input  logic                        sr_hist_list_a_isol_en
    ,input  logic                        sr_hist_list_a_pwr_enable_b_in
    ,output logic                        sr_hist_list_a_pwr_enable_b_out

    ,input  logic                        sr_rob_mem_clk
    ,input  logic                        sr_rob_mem_clk_rst_n
    ,input  logic [ (  11 ) -1 : 0 ]     sr_rob_mem_addr
    ,input  logic                        sr_rob_mem_we
    ,input  logic [ ( 156 ) -1 : 0 ]     sr_rob_mem_wdata
    ,input  logic                        sr_rob_mem_re
    ,output logic [ ( 156 ) -1 : 0 ]     sr_rob_mem_rdata

    ,input  logic                        sr_rob_mem_isol_en
    ,input  logic                        sr_rob_mem_pwr_enable_b_in
    ,output logic                        sr_rob_mem_pwr_enable_b_out

    ,input  logic                        powergood_rst_b

    ,input  logic                        hqm_pwrgood_rst_b

    ,input  logic                        fscan_byprst_b
    ,input  logic                        fscan_clkungate
    ,input  logic                        fscan_rstbypen
);

logic ip_reset_b;

assign ip_reset_b = powergood_rst_b & hqm_pwrgood_rst_b;

hqm_system_mem_AW_sram_pg_2048x16 i_sr_freelist_0 (

     .clk                     (sr_freelist_0_clk)
    ,.clk_rst_n               (sr_freelist_0_clk_rst_n)
    ,.we                      (sr_freelist_0_we)
    ,.addr                    (sr_freelist_0_addr)
    ,.wdata                   (sr_freelist_0_wdata)
    ,.re                      (sr_freelist_0_re)
    ,.rdata                   (sr_freelist_0_rdata)

    ,.pgcb_isol_en            (sr_freelist_0_isol_en)
    ,.pwr_enable_b_in         (sr_freelist_0_pwr_enable_b_in)
    ,.pwr_enable_b_out        (sr_freelist_0_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_sram_pg_2048x16 i_sr_freelist_1 (

     .clk                     (sr_freelist_1_clk)
    ,.clk_rst_n               (sr_freelist_1_clk_rst_n)
    ,.we                      (sr_freelist_1_we)
    ,.addr                    (sr_freelist_1_addr)
    ,.wdata                   (sr_freelist_1_wdata)
    ,.re                      (sr_freelist_1_re)
    ,.rdata                   (sr_freelist_1_rdata)

    ,.pgcb_isol_en            (sr_freelist_1_isol_en)
    ,.pwr_enable_b_in         (sr_freelist_1_pwr_enable_b_in)
    ,.pwr_enable_b_out        (sr_freelist_1_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_sram_pg_2048x16 i_sr_freelist_2 (

     .clk                     (sr_freelist_2_clk)
    ,.clk_rst_n               (sr_freelist_2_clk_rst_n)
    ,.we                      (sr_freelist_2_we)
    ,.addr                    (sr_freelist_2_addr)
    ,.wdata                   (sr_freelist_2_wdata)
    ,.re                      (sr_freelist_2_re)
    ,.rdata                   (sr_freelist_2_rdata)

    ,.pgcb_isol_en            (sr_freelist_2_isol_en)
    ,.pwr_enable_b_in         (sr_freelist_2_pwr_enable_b_in)
    ,.pwr_enable_b_out        (sr_freelist_2_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_sram_pg_2048x16 i_sr_freelist_3 (

     .clk                     (sr_freelist_3_clk)
    ,.clk_rst_n               (sr_freelist_3_clk_rst_n)
    ,.we                      (sr_freelist_3_we)
    ,.addr                    (sr_freelist_3_addr)
    ,.wdata                   (sr_freelist_3_wdata)
    ,.re                      (sr_freelist_3_re)
    ,.rdata                   (sr_freelist_3_rdata)

    ,.pgcb_isol_en            (sr_freelist_3_isol_en)
    ,.pwr_enable_b_in         (sr_freelist_3_pwr_enable_b_in)
    ,.pwr_enable_b_out        (sr_freelist_3_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_sram_pg_2048x16 i_sr_freelist_4 (

     .clk                     (sr_freelist_4_clk)
    ,.clk_rst_n               (sr_freelist_4_clk_rst_n)
    ,.we                      (sr_freelist_4_we)
    ,.addr                    (sr_freelist_4_addr)
    ,.wdata                   (sr_freelist_4_wdata)
    ,.re                      (sr_freelist_4_re)
    ,.rdata                   (sr_freelist_4_rdata)

    ,.pgcb_isol_en            (sr_freelist_4_isol_en)
    ,.pwr_enable_b_in         (sr_freelist_4_pwr_enable_b_in)
    ,.pwr_enable_b_out        (sr_freelist_4_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_sram_pg_2048x16 i_sr_freelist_5 (

     .clk                     (sr_freelist_5_clk)
    ,.clk_rst_n               (sr_freelist_5_clk_rst_n)
    ,.we                      (sr_freelist_5_we)
    ,.addr                    (sr_freelist_5_addr)
    ,.wdata                   (sr_freelist_5_wdata)
    ,.re                      (sr_freelist_5_re)
    ,.rdata                   (sr_freelist_5_rdata)

    ,.pgcb_isol_en            (sr_freelist_5_isol_en)
    ,.pwr_enable_b_in         (sr_freelist_5_pwr_enable_b_in)
    ,.pwr_enable_b_out        (sr_freelist_5_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_sram_pg_2048x16 i_sr_freelist_6 (

     .clk                     (sr_freelist_6_clk)
    ,.clk_rst_n               (sr_freelist_6_clk_rst_n)
    ,.we                      (sr_freelist_6_we)
    ,.addr                    (sr_freelist_6_addr)
    ,.wdata                   (sr_freelist_6_wdata)
    ,.re                      (sr_freelist_6_re)
    ,.rdata                   (sr_freelist_6_rdata)

    ,.pgcb_isol_en            (sr_freelist_6_isol_en)
    ,.pwr_enable_b_in         (sr_freelist_6_pwr_enable_b_in)
    ,.pwr_enable_b_out        (sr_freelist_6_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_sram_pg_2048x16 i_sr_freelist_7 (

     .clk                     (sr_freelist_7_clk)
    ,.clk_rst_n               (sr_freelist_7_clk_rst_n)
    ,.we                      (sr_freelist_7_we)
    ,.addr                    (sr_freelist_7_addr)
    ,.wdata                   (sr_freelist_7_wdata)
    ,.re                      (sr_freelist_7_re)
    ,.rdata                   (sr_freelist_7_rdata)

    ,.pgcb_isol_en            (sr_freelist_7_isol_en)
    ,.pwr_enable_b_in         (sr_freelist_7_pwr_enable_b_in)
    ,.pwr_enable_b_out        (sr_freelist_7_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_sram_pg_2048x66 i_sr_hist_list (

     .clk                     (sr_hist_list_clk)
    ,.clk_rst_n               (sr_hist_list_clk_rst_n)
    ,.we                      (sr_hist_list_we)
    ,.addr                    (sr_hist_list_addr)
    ,.wdata                   (sr_hist_list_wdata)
    ,.re                      (sr_hist_list_re)
    ,.rdata                   (sr_hist_list_rdata)

    ,.pgcb_isol_en            (sr_hist_list_isol_en)
    ,.pwr_enable_b_in         (sr_hist_list_pwr_enable_b_in)
    ,.pwr_enable_b_out        (sr_hist_list_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_sram_pg_2048x66 i_sr_hist_list_a (

     .clk                     (sr_hist_list_a_clk)
    ,.clk_rst_n               (sr_hist_list_a_clk_rst_n)
    ,.we                      (sr_hist_list_a_we)
    ,.addr                    (sr_hist_list_a_addr)
    ,.wdata                   (sr_hist_list_a_wdata)
    ,.re                      (sr_hist_list_a_re)
    ,.rdata                   (sr_hist_list_a_rdata)

    ,.pgcb_isol_en            (sr_hist_list_a_isol_en)
    ,.pwr_enable_b_in         (sr_hist_list_a_pwr_enable_b_in)
    ,.pwr_enable_b_out        (sr_hist_list_a_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_sram_pg_2048x156 i_sr_rob_mem (

     .clk                     (sr_rob_mem_clk)
    ,.clk_rst_n               (sr_rob_mem_clk_rst_n)
    ,.we                      (sr_rob_mem_we)
    ,.addr                    (sr_rob_mem_addr)
    ,.wdata                   (sr_rob_mem_wdata)
    ,.re                      (sr_rob_mem_re)
    ,.rdata                   (sr_rob_mem_rdata)

    ,.pgcb_isol_en            (sr_rob_mem_isol_en)
    ,.pwr_enable_b_in         (sr_rob_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (sr_rob_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

endmodule

