module hqm_qed_mem_hqm_clk_sram_pg_cont (

     input  logic                        sr_dir_nxthp_clk
    ,input  logic                        sr_dir_nxthp_clk_rst_n
    ,input  logic [ (  14 ) -1 : 0 ]     sr_dir_nxthp_addr
    ,input  logic                        sr_dir_nxthp_we
    ,input  logic [ (  21 ) -1 : 0 ]     sr_dir_nxthp_wdata
    ,input  logic                        sr_dir_nxthp_re
    ,output logic [ (  21 ) -1 : 0 ]     sr_dir_nxthp_rdata

    ,input  logic                        sr_dir_nxthp_isol_en
    ,input  logic                        sr_dir_nxthp_pwr_enable_b_in
    ,output logic                        sr_dir_nxthp_pwr_enable_b_out

    ,input  logic                        sr_nalb_nxthp_clk
    ,input  logic                        sr_nalb_nxthp_clk_rst_n
    ,input  logic [ (  14 ) -1 : 0 ]     sr_nalb_nxthp_addr
    ,input  logic                        sr_nalb_nxthp_we
    ,input  logic [ (  21 ) -1 : 0 ]     sr_nalb_nxthp_wdata
    ,input  logic                        sr_nalb_nxthp_re
    ,output logic [ (  21 ) -1 : 0 ]     sr_nalb_nxthp_rdata

    ,input  logic                        sr_nalb_nxthp_isol_en
    ,input  logic                        sr_nalb_nxthp_pwr_enable_b_in
    ,output logic                        sr_nalb_nxthp_pwr_enable_b_out

    ,input  logic                        sr_qed_0_clk
    ,input  logic                        sr_qed_0_clk_rst_n
    ,input  logic [ (  11 ) -1 : 0 ]     sr_qed_0_addr
    ,input  logic                        sr_qed_0_we
    ,input  logic [ ( 139 ) -1 : 0 ]     sr_qed_0_wdata
    ,input  logic                        sr_qed_0_re
    ,output logic [ ( 139 ) -1 : 0 ]     sr_qed_0_rdata

    ,input  logic                        sr_qed_0_isol_en
    ,input  logic                        sr_qed_0_pwr_enable_b_in
    ,output logic                        sr_qed_0_pwr_enable_b_out

    ,input  logic                        sr_qed_1_clk
    ,input  logic                        sr_qed_1_clk_rst_n
    ,input  logic [ (  11 ) -1 : 0 ]     sr_qed_1_addr
    ,input  logic                        sr_qed_1_we
    ,input  logic [ ( 139 ) -1 : 0 ]     sr_qed_1_wdata
    ,input  logic                        sr_qed_1_re
    ,output logic [ ( 139 ) -1 : 0 ]     sr_qed_1_rdata

    ,input  logic                        sr_qed_1_isol_en
    ,input  logic                        sr_qed_1_pwr_enable_b_in
    ,output logic                        sr_qed_1_pwr_enable_b_out

    ,input  logic                        sr_qed_2_clk
    ,input  logic                        sr_qed_2_clk_rst_n
    ,input  logic [ (  11 ) -1 : 0 ]     sr_qed_2_addr
    ,input  logic                        sr_qed_2_we
    ,input  logic [ ( 139 ) -1 : 0 ]     sr_qed_2_wdata
    ,input  logic                        sr_qed_2_re
    ,output logic [ ( 139 ) -1 : 0 ]     sr_qed_2_rdata

    ,input  logic                        sr_qed_2_isol_en
    ,input  logic                        sr_qed_2_pwr_enable_b_in
    ,output logic                        sr_qed_2_pwr_enable_b_out

    ,input  logic                        sr_qed_3_clk
    ,input  logic                        sr_qed_3_clk_rst_n
    ,input  logic [ (  11 ) -1 : 0 ]     sr_qed_3_addr
    ,input  logic                        sr_qed_3_we
    ,input  logic [ ( 139 ) -1 : 0 ]     sr_qed_3_wdata
    ,input  logic                        sr_qed_3_re
    ,output logic [ ( 139 ) -1 : 0 ]     sr_qed_3_rdata

    ,input  logic                        sr_qed_3_isol_en
    ,input  logic                        sr_qed_3_pwr_enable_b_in
    ,output logic                        sr_qed_3_pwr_enable_b_out

    ,input  logic                        sr_qed_4_clk
    ,input  logic                        sr_qed_4_clk_rst_n
    ,input  logic [ (  11 ) -1 : 0 ]     sr_qed_4_addr
    ,input  logic                        sr_qed_4_we
    ,input  logic [ ( 139 ) -1 : 0 ]     sr_qed_4_wdata
    ,input  logic                        sr_qed_4_re
    ,output logic [ ( 139 ) -1 : 0 ]     sr_qed_4_rdata

    ,input  logic                        sr_qed_4_isol_en
    ,input  logic                        sr_qed_4_pwr_enable_b_in
    ,output logic                        sr_qed_4_pwr_enable_b_out

    ,input  logic                        sr_qed_5_clk
    ,input  logic                        sr_qed_5_clk_rst_n
    ,input  logic [ (  11 ) -1 : 0 ]     sr_qed_5_addr
    ,input  logic                        sr_qed_5_we
    ,input  logic [ ( 139 ) -1 : 0 ]     sr_qed_5_wdata
    ,input  logic                        sr_qed_5_re
    ,output logic [ ( 139 ) -1 : 0 ]     sr_qed_5_rdata

    ,input  logic                        sr_qed_5_isol_en
    ,input  logic                        sr_qed_5_pwr_enable_b_in
    ,output logic                        sr_qed_5_pwr_enable_b_out

    ,input  logic                        sr_qed_6_clk
    ,input  logic                        sr_qed_6_clk_rst_n
    ,input  logic [ (  11 ) -1 : 0 ]     sr_qed_6_addr
    ,input  logic                        sr_qed_6_we
    ,input  logic [ ( 139 ) -1 : 0 ]     sr_qed_6_wdata
    ,input  logic                        sr_qed_6_re
    ,output logic [ ( 139 ) -1 : 0 ]     sr_qed_6_rdata

    ,input  logic                        sr_qed_6_isol_en
    ,input  logic                        sr_qed_6_pwr_enable_b_in
    ,output logic                        sr_qed_6_pwr_enable_b_out

    ,input  logic                        sr_qed_7_clk
    ,input  logic                        sr_qed_7_clk_rst_n
    ,input  logic [ (  11 ) -1 : 0 ]     sr_qed_7_addr
    ,input  logic                        sr_qed_7_we
    ,input  logic [ ( 139 ) -1 : 0 ]     sr_qed_7_wdata
    ,input  logic                        sr_qed_7_re
    ,output logic [ ( 139 ) -1 : 0 ]     sr_qed_7_rdata

    ,input  logic                        sr_qed_7_isol_en
    ,input  logic                        sr_qed_7_pwr_enable_b_in
    ,output logic                        sr_qed_7_pwr_enable_b_out

    ,input  logic                        powergood_rst_b

    ,input  logic                        hqm_pwrgood_rst_b

    ,input  logic                        fscan_byprst_b
    ,input  logic                        fscan_clkungate
    ,input  logic                        fscan_rstbypen
);

logic ip_reset_b;

assign ip_reset_b = powergood_rst_b & hqm_pwrgood_rst_b;

hqm_qed_mem_AW_sram_pg_16384x21 i_sr_dir_nxthp (

     .clk                     (sr_dir_nxthp_clk)
    ,.clk_rst_n               (sr_dir_nxthp_clk_rst_n)
    ,.we                      (sr_dir_nxthp_we)
    ,.addr                    (sr_dir_nxthp_addr)
    ,.wdata                   (sr_dir_nxthp_wdata)
    ,.re                      (sr_dir_nxthp_re)
    ,.rdata                   (sr_dir_nxthp_rdata)

    ,.pgcb_isol_en            (sr_dir_nxthp_isol_en)
    ,.pwr_enable_b_in         (sr_dir_nxthp_pwr_enable_b_in)
    ,.pwr_enable_b_out        (sr_dir_nxthp_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_qed_mem_AW_sram_pg_16384x21 i_sr_nalb_nxthp (

     .clk                     (sr_nalb_nxthp_clk)
    ,.clk_rst_n               (sr_nalb_nxthp_clk_rst_n)
    ,.we                      (sr_nalb_nxthp_we)
    ,.addr                    (sr_nalb_nxthp_addr)
    ,.wdata                   (sr_nalb_nxthp_wdata)
    ,.re                      (sr_nalb_nxthp_re)
    ,.rdata                   (sr_nalb_nxthp_rdata)

    ,.pgcb_isol_en            (sr_nalb_nxthp_isol_en)
    ,.pwr_enable_b_in         (sr_nalb_nxthp_pwr_enable_b_in)
    ,.pwr_enable_b_out        (sr_nalb_nxthp_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_qed_mem_AW_sram_pg_2048x139 i_sr_qed_0 (

     .clk                     (sr_qed_0_clk)
    ,.clk_rst_n               (sr_qed_0_clk_rst_n)
    ,.we                      (sr_qed_0_we)
    ,.addr                    (sr_qed_0_addr)
    ,.wdata                   (sr_qed_0_wdata)
    ,.re                      (sr_qed_0_re)
    ,.rdata                   (sr_qed_0_rdata)

    ,.pgcb_isol_en            (sr_qed_0_isol_en)
    ,.pwr_enable_b_in         (sr_qed_0_pwr_enable_b_in)
    ,.pwr_enable_b_out        (sr_qed_0_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_qed_mem_AW_sram_pg_2048x139 i_sr_qed_1 (

     .clk                     (sr_qed_1_clk)
    ,.clk_rst_n               (sr_qed_1_clk_rst_n)
    ,.we                      (sr_qed_1_we)
    ,.addr                    (sr_qed_1_addr)
    ,.wdata                   (sr_qed_1_wdata)
    ,.re                      (sr_qed_1_re)
    ,.rdata                   (sr_qed_1_rdata)

    ,.pgcb_isol_en            (sr_qed_1_isol_en)
    ,.pwr_enable_b_in         (sr_qed_1_pwr_enable_b_in)
    ,.pwr_enable_b_out        (sr_qed_1_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_qed_mem_AW_sram_pg_2048x139 i_sr_qed_2 (

     .clk                     (sr_qed_2_clk)
    ,.clk_rst_n               (sr_qed_2_clk_rst_n)
    ,.we                      (sr_qed_2_we)
    ,.addr                    (sr_qed_2_addr)
    ,.wdata                   (sr_qed_2_wdata)
    ,.re                      (sr_qed_2_re)
    ,.rdata                   (sr_qed_2_rdata)

    ,.pgcb_isol_en            (sr_qed_2_isol_en)
    ,.pwr_enable_b_in         (sr_qed_2_pwr_enable_b_in)
    ,.pwr_enable_b_out        (sr_qed_2_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_qed_mem_AW_sram_pg_2048x139 i_sr_qed_3 (

     .clk                     (sr_qed_3_clk)
    ,.clk_rst_n               (sr_qed_3_clk_rst_n)
    ,.we                      (sr_qed_3_we)
    ,.addr                    (sr_qed_3_addr)
    ,.wdata                   (sr_qed_3_wdata)
    ,.re                      (sr_qed_3_re)
    ,.rdata                   (sr_qed_3_rdata)

    ,.pgcb_isol_en            (sr_qed_3_isol_en)
    ,.pwr_enable_b_in         (sr_qed_3_pwr_enable_b_in)
    ,.pwr_enable_b_out        (sr_qed_3_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_qed_mem_AW_sram_pg_2048x139 i_sr_qed_4 (

     .clk                     (sr_qed_4_clk)
    ,.clk_rst_n               (sr_qed_4_clk_rst_n)
    ,.we                      (sr_qed_4_we)
    ,.addr                    (sr_qed_4_addr)
    ,.wdata                   (sr_qed_4_wdata)
    ,.re                      (sr_qed_4_re)
    ,.rdata                   (sr_qed_4_rdata)

    ,.pgcb_isol_en            (sr_qed_4_isol_en)
    ,.pwr_enable_b_in         (sr_qed_4_pwr_enable_b_in)
    ,.pwr_enable_b_out        (sr_qed_4_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_qed_mem_AW_sram_pg_2048x139 i_sr_qed_5 (

     .clk                     (sr_qed_5_clk)
    ,.clk_rst_n               (sr_qed_5_clk_rst_n)
    ,.we                      (sr_qed_5_we)
    ,.addr                    (sr_qed_5_addr)
    ,.wdata                   (sr_qed_5_wdata)
    ,.re                      (sr_qed_5_re)
    ,.rdata                   (sr_qed_5_rdata)

    ,.pgcb_isol_en            (sr_qed_5_isol_en)
    ,.pwr_enable_b_in         (sr_qed_5_pwr_enable_b_in)
    ,.pwr_enable_b_out        (sr_qed_5_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_qed_mem_AW_sram_pg_2048x139 i_sr_qed_6 (

     .clk                     (sr_qed_6_clk)
    ,.clk_rst_n               (sr_qed_6_clk_rst_n)
    ,.we                      (sr_qed_6_we)
    ,.addr                    (sr_qed_6_addr)
    ,.wdata                   (sr_qed_6_wdata)
    ,.re                      (sr_qed_6_re)
    ,.rdata                   (sr_qed_6_rdata)

    ,.pgcb_isol_en            (sr_qed_6_isol_en)
    ,.pwr_enable_b_in         (sr_qed_6_pwr_enable_b_in)
    ,.pwr_enable_b_out        (sr_qed_6_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_qed_mem_AW_sram_pg_2048x139 i_sr_qed_7 (

     .clk                     (sr_qed_7_clk)
    ,.clk_rst_n               (sr_qed_7_clk_rst_n)
    ,.we                      (sr_qed_7_we)
    ,.addr                    (sr_qed_7_addr)
    ,.wdata                   (sr_qed_7_wdata)
    ,.re                      (sr_qed_7_re)
    ,.rdata                   (sr_qed_7_rdata)

    ,.pgcb_isol_en            (sr_qed_7_isol_en)
    ,.pwr_enable_b_in         (sr_qed_7_pwr_enable_b_in)
    ,.pwr_enable_b_out        (sr_qed_7_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

endmodule

