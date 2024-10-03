module hqm_list_sel_mem_hqm_clk_rf_pg_cont (

     input  logic                        rf_aqed_fid_cnt_wclk
    ,input  logic                        rf_aqed_fid_cnt_wclk_rst_n
    ,input  logic                        rf_aqed_fid_cnt_we
    ,input  logic [ (  11 ) -1 : 0 ]     rf_aqed_fid_cnt_waddr
    ,input  logic [ (  17 ) -1 : 0 ]     rf_aqed_fid_cnt_wdata
    ,input  logic                        rf_aqed_fid_cnt_rclk
    ,input  logic                        rf_aqed_fid_cnt_rclk_rst_n
    ,input  logic                        rf_aqed_fid_cnt_re
    ,input  logic [ (  11 ) -1 : 0 ]     rf_aqed_fid_cnt_raddr
    ,output logic [ (  17 ) -1 : 0 ]     rf_aqed_fid_cnt_rdata

    ,input  logic                        rf_aqed_fid_cnt_isol_en
    ,input  logic                        rf_aqed_fid_cnt_pwr_enable_b_in
    ,output logic                        rf_aqed_fid_cnt_pwr_enable_b_out

    ,input  logic                        rf_aqed_fifo_ap_aqed_wclk
    ,input  logic                        rf_aqed_fifo_ap_aqed_wclk_rst_n
    ,input  logic                        rf_aqed_fifo_ap_aqed_we
    ,input  logic [ (   4 ) -1 : 0 ]     rf_aqed_fifo_ap_aqed_waddr
    ,input  logic [ (  45 ) -1 : 0 ]     rf_aqed_fifo_ap_aqed_wdata
    ,input  logic                        rf_aqed_fifo_ap_aqed_rclk
    ,input  logic                        rf_aqed_fifo_ap_aqed_rclk_rst_n
    ,input  logic                        rf_aqed_fifo_ap_aqed_re
    ,input  logic [ (   4 ) -1 : 0 ]     rf_aqed_fifo_ap_aqed_raddr
    ,output logic [ (  45 ) -1 : 0 ]     rf_aqed_fifo_ap_aqed_rdata

    ,input  logic                        rf_aqed_fifo_ap_aqed_isol_en
    ,input  logic                        rf_aqed_fifo_ap_aqed_pwr_enable_b_in
    ,output logic                        rf_aqed_fifo_ap_aqed_pwr_enable_b_out

    ,input  logic                        rf_aqed_fifo_aqed_ap_enq_wclk
    ,input  logic                        rf_aqed_fifo_aqed_ap_enq_wclk_rst_n
    ,input  logic                        rf_aqed_fifo_aqed_ap_enq_we
    ,input  logic [ (   4 ) -1 : 0 ]     rf_aqed_fifo_aqed_ap_enq_waddr
    ,input  logic [ (  24 ) -1 : 0 ]     rf_aqed_fifo_aqed_ap_enq_wdata
    ,input  logic                        rf_aqed_fifo_aqed_ap_enq_rclk
    ,input  logic                        rf_aqed_fifo_aqed_ap_enq_rclk_rst_n
    ,input  logic                        rf_aqed_fifo_aqed_ap_enq_re
    ,input  logic [ (   4 ) -1 : 0 ]     rf_aqed_fifo_aqed_ap_enq_raddr
    ,output logic [ (  24 ) -1 : 0 ]     rf_aqed_fifo_aqed_ap_enq_rdata

    ,input  logic                        rf_aqed_fifo_aqed_ap_enq_isol_en
    ,input  logic                        rf_aqed_fifo_aqed_ap_enq_pwr_enable_b_in
    ,output logic                        rf_aqed_fifo_aqed_ap_enq_pwr_enable_b_out

    ,input  logic                        rf_aqed_fifo_aqed_chp_sch_wclk
    ,input  logic                        rf_aqed_fifo_aqed_chp_sch_wclk_rst_n
    ,input  logic                        rf_aqed_fifo_aqed_chp_sch_we
    ,input  logic [ (   4 ) -1 : 0 ]     rf_aqed_fifo_aqed_chp_sch_waddr
    ,input  logic [ ( 180 ) -1 : 0 ]     rf_aqed_fifo_aqed_chp_sch_wdata
    ,input  logic                        rf_aqed_fifo_aqed_chp_sch_rclk
    ,input  logic                        rf_aqed_fifo_aqed_chp_sch_rclk_rst_n
    ,input  logic                        rf_aqed_fifo_aqed_chp_sch_re
    ,input  logic [ (   4 ) -1 : 0 ]     rf_aqed_fifo_aqed_chp_sch_raddr
    ,output logic [ ( 180 ) -1 : 0 ]     rf_aqed_fifo_aqed_chp_sch_rdata

    ,input  logic                        rf_aqed_fifo_aqed_chp_sch_isol_en
    ,input  logic                        rf_aqed_fifo_aqed_chp_sch_pwr_enable_b_in
    ,output logic                        rf_aqed_fifo_aqed_chp_sch_pwr_enable_b_out

    ,input  logic                        rf_aqed_fifo_freelist_return_wclk
    ,input  logic                        rf_aqed_fifo_freelist_return_wclk_rst_n
    ,input  logic                        rf_aqed_fifo_freelist_return_we
    ,input  logic [ (   4 ) -1 : 0 ]     rf_aqed_fifo_freelist_return_waddr
    ,input  logic [ (  32 ) -1 : 0 ]     rf_aqed_fifo_freelist_return_wdata
    ,input  logic                        rf_aqed_fifo_freelist_return_rclk
    ,input  logic                        rf_aqed_fifo_freelist_return_rclk_rst_n
    ,input  logic                        rf_aqed_fifo_freelist_return_re
    ,input  logic [ (   4 ) -1 : 0 ]     rf_aqed_fifo_freelist_return_raddr
    ,output logic [ (  32 ) -1 : 0 ]     rf_aqed_fifo_freelist_return_rdata

    ,input  logic                        rf_aqed_fifo_freelist_return_isol_en
    ,input  logic                        rf_aqed_fifo_freelist_return_pwr_enable_b_in
    ,output logic                        rf_aqed_fifo_freelist_return_pwr_enable_b_out

    ,input  logic                        rf_aqed_fifo_lsp_aqed_cmp_wclk
    ,input  logic                        rf_aqed_fifo_lsp_aqed_cmp_wclk_rst_n
    ,input  logic                        rf_aqed_fifo_lsp_aqed_cmp_we
    ,input  logic [ (   4 ) -1 : 0 ]     rf_aqed_fifo_lsp_aqed_cmp_waddr
    ,input  logic [ (  35 ) -1 : 0 ]     rf_aqed_fifo_lsp_aqed_cmp_wdata
    ,input  logic                        rf_aqed_fifo_lsp_aqed_cmp_rclk
    ,input  logic                        rf_aqed_fifo_lsp_aqed_cmp_rclk_rst_n
    ,input  logic                        rf_aqed_fifo_lsp_aqed_cmp_re
    ,input  logic [ (   4 ) -1 : 0 ]     rf_aqed_fifo_lsp_aqed_cmp_raddr
    ,output logic [ (  35 ) -1 : 0 ]     rf_aqed_fifo_lsp_aqed_cmp_rdata

    ,input  logic                        rf_aqed_fifo_lsp_aqed_cmp_isol_en
    ,input  logic                        rf_aqed_fifo_lsp_aqed_cmp_pwr_enable_b_in
    ,output logic                        rf_aqed_fifo_lsp_aqed_cmp_pwr_enable_b_out

    ,input  logic                        rf_aqed_fifo_qed_aqed_enq_wclk
    ,input  logic                        rf_aqed_fifo_qed_aqed_enq_wclk_rst_n
    ,input  logic                        rf_aqed_fifo_qed_aqed_enq_we
    ,input  logic [ (   2 ) -1 : 0 ]     rf_aqed_fifo_qed_aqed_enq_waddr
    ,input  logic [ ( 155 ) -1 : 0 ]     rf_aqed_fifo_qed_aqed_enq_wdata
    ,input  logic                        rf_aqed_fifo_qed_aqed_enq_rclk
    ,input  logic                        rf_aqed_fifo_qed_aqed_enq_rclk_rst_n
    ,input  logic                        rf_aqed_fifo_qed_aqed_enq_re
    ,input  logic [ (   2 ) -1 : 0 ]     rf_aqed_fifo_qed_aqed_enq_raddr
    ,output logic [ ( 155 ) -1 : 0 ]     rf_aqed_fifo_qed_aqed_enq_rdata

    ,input  logic                        rf_aqed_fifo_qed_aqed_enq_isol_en
    ,input  logic                        rf_aqed_fifo_qed_aqed_enq_pwr_enable_b_in
    ,output logic                        rf_aqed_fifo_qed_aqed_enq_pwr_enable_b_out

    ,input  logic                        rf_aqed_fifo_qed_aqed_enq_fid_wclk
    ,input  logic                        rf_aqed_fifo_qed_aqed_enq_fid_wclk_rst_n
    ,input  logic                        rf_aqed_fifo_qed_aqed_enq_fid_we
    ,input  logic [ (   3 ) -1 : 0 ]     rf_aqed_fifo_qed_aqed_enq_fid_waddr
    ,input  logic [ ( 153 ) -1 : 0 ]     rf_aqed_fifo_qed_aqed_enq_fid_wdata
    ,input  logic                        rf_aqed_fifo_qed_aqed_enq_fid_rclk
    ,input  logic                        rf_aqed_fifo_qed_aqed_enq_fid_rclk_rst_n
    ,input  logic                        rf_aqed_fifo_qed_aqed_enq_fid_re
    ,input  logic [ (   3 ) -1 : 0 ]     rf_aqed_fifo_qed_aqed_enq_fid_raddr
    ,output logic [ ( 153 ) -1 : 0 ]     rf_aqed_fifo_qed_aqed_enq_fid_rdata

    ,input  logic                        rf_aqed_fifo_qed_aqed_enq_fid_isol_en
    ,input  logic                        rf_aqed_fifo_qed_aqed_enq_fid_pwr_enable_b_in
    ,output logic                        rf_aqed_fifo_qed_aqed_enq_fid_pwr_enable_b_out

    ,input  logic                        rf_aqed_ll_cnt_pri0_wclk
    ,input  logic                        rf_aqed_ll_cnt_pri0_wclk_rst_n
    ,input  logic                        rf_aqed_ll_cnt_pri0_we
    ,input  logic [ (  11 ) -1 : 0 ]     rf_aqed_ll_cnt_pri0_waddr
    ,input  logic [ (  16 ) -1 : 0 ]     rf_aqed_ll_cnt_pri0_wdata
    ,input  logic                        rf_aqed_ll_cnt_pri0_rclk
    ,input  logic                        rf_aqed_ll_cnt_pri0_rclk_rst_n
    ,input  logic                        rf_aqed_ll_cnt_pri0_re
    ,input  logic [ (  11 ) -1 : 0 ]     rf_aqed_ll_cnt_pri0_raddr
    ,output logic [ (  16 ) -1 : 0 ]     rf_aqed_ll_cnt_pri0_rdata

    ,input  logic                        rf_aqed_ll_cnt_pri0_isol_en
    ,input  logic                        rf_aqed_ll_cnt_pri0_pwr_enable_b_in
    ,output logic                        rf_aqed_ll_cnt_pri0_pwr_enable_b_out

    ,input  logic                        rf_aqed_ll_cnt_pri1_wclk
    ,input  logic                        rf_aqed_ll_cnt_pri1_wclk_rst_n
    ,input  logic                        rf_aqed_ll_cnt_pri1_we
    ,input  logic [ (  11 ) -1 : 0 ]     rf_aqed_ll_cnt_pri1_waddr
    ,input  logic [ (  16 ) -1 : 0 ]     rf_aqed_ll_cnt_pri1_wdata
    ,input  logic                        rf_aqed_ll_cnt_pri1_rclk
    ,input  logic                        rf_aqed_ll_cnt_pri1_rclk_rst_n
    ,input  logic                        rf_aqed_ll_cnt_pri1_re
    ,input  logic [ (  11 ) -1 : 0 ]     rf_aqed_ll_cnt_pri1_raddr
    ,output logic [ (  16 ) -1 : 0 ]     rf_aqed_ll_cnt_pri1_rdata

    ,input  logic                        rf_aqed_ll_cnt_pri1_isol_en
    ,input  logic                        rf_aqed_ll_cnt_pri1_pwr_enable_b_in
    ,output logic                        rf_aqed_ll_cnt_pri1_pwr_enable_b_out

    ,input  logic                        rf_aqed_ll_cnt_pri2_wclk
    ,input  logic                        rf_aqed_ll_cnt_pri2_wclk_rst_n
    ,input  logic                        rf_aqed_ll_cnt_pri2_we
    ,input  logic [ (  11 ) -1 : 0 ]     rf_aqed_ll_cnt_pri2_waddr
    ,input  logic [ (  16 ) -1 : 0 ]     rf_aqed_ll_cnt_pri2_wdata
    ,input  logic                        rf_aqed_ll_cnt_pri2_rclk
    ,input  logic                        rf_aqed_ll_cnt_pri2_rclk_rst_n
    ,input  logic                        rf_aqed_ll_cnt_pri2_re
    ,input  logic [ (  11 ) -1 : 0 ]     rf_aqed_ll_cnt_pri2_raddr
    ,output logic [ (  16 ) -1 : 0 ]     rf_aqed_ll_cnt_pri2_rdata

    ,input  logic                        rf_aqed_ll_cnt_pri2_isol_en
    ,input  logic                        rf_aqed_ll_cnt_pri2_pwr_enable_b_in
    ,output logic                        rf_aqed_ll_cnt_pri2_pwr_enable_b_out

    ,input  logic                        rf_aqed_ll_cnt_pri3_wclk
    ,input  logic                        rf_aqed_ll_cnt_pri3_wclk_rst_n
    ,input  logic                        rf_aqed_ll_cnt_pri3_we
    ,input  logic [ (  11 ) -1 : 0 ]     rf_aqed_ll_cnt_pri3_waddr
    ,input  logic [ (  16 ) -1 : 0 ]     rf_aqed_ll_cnt_pri3_wdata
    ,input  logic                        rf_aqed_ll_cnt_pri3_rclk
    ,input  logic                        rf_aqed_ll_cnt_pri3_rclk_rst_n
    ,input  logic                        rf_aqed_ll_cnt_pri3_re
    ,input  logic [ (  11 ) -1 : 0 ]     rf_aqed_ll_cnt_pri3_raddr
    ,output logic [ (  16 ) -1 : 0 ]     rf_aqed_ll_cnt_pri3_rdata

    ,input  logic                        rf_aqed_ll_cnt_pri3_isol_en
    ,input  logic                        rf_aqed_ll_cnt_pri3_pwr_enable_b_in
    ,output logic                        rf_aqed_ll_cnt_pri3_pwr_enable_b_out

    ,input  logic                        rf_aqed_ll_qe_hp_pri0_wclk
    ,input  logic                        rf_aqed_ll_qe_hp_pri0_wclk_rst_n
    ,input  logic                        rf_aqed_ll_qe_hp_pri0_we
    ,input  logic [ (  11 ) -1 : 0 ]     rf_aqed_ll_qe_hp_pri0_waddr
    ,input  logic [ (  14 ) -1 : 0 ]     rf_aqed_ll_qe_hp_pri0_wdata
    ,input  logic                        rf_aqed_ll_qe_hp_pri0_rclk
    ,input  logic                        rf_aqed_ll_qe_hp_pri0_rclk_rst_n
    ,input  logic                        rf_aqed_ll_qe_hp_pri0_re
    ,input  logic [ (  11 ) -1 : 0 ]     rf_aqed_ll_qe_hp_pri0_raddr
    ,output logic [ (  14 ) -1 : 0 ]     rf_aqed_ll_qe_hp_pri0_rdata

    ,input  logic                        rf_aqed_ll_qe_hp_pri0_isol_en
    ,input  logic                        rf_aqed_ll_qe_hp_pri0_pwr_enable_b_in
    ,output logic                        rf_aqed_ll_qe_hp_pri0_pwr_enable_b_out

    ,input  logic                        rf_aqed_ll_qe_hp_pri1_wclk
    ,input  logic                        rf_aqed_ll_qe_hp_pri1_wclk_rst_n
    ,input  logic                        rf_aqed_ll_qe_hp_pri1_we
    ,input  logic [ (  11 ) -1 : 0 ]     rf_aqed_ll_qe_hp_pri1_waddr
    ,input  logic [ (  14 ) -1 : 0 ]     rf_aqed_ll_qe_hp_pri1_wdata
    ,input  logic                        rf_aqed_ll_qe_hp_pri1_rclk
    ,input  logic                        rf_aqed_ll_qe_hp_pri1_rclk_rst_n
    ,input  logic                        rf_aqed_ll_qe_hp_pri1_re
    ,input  logic [ (  11 ) -1 : 0 ]     rf_aqed_ll_qe_hp_pri1_raddr
    ,output logic [ (  14 ) -1 : 0 ]     rf_aqed_ll_qe_hp_pri1_rdata

    ,input  logic                        rf_aqed_ll_qe_hp_pri1_isol_en
    ,input  logic                        rf_aqed_ll_qe_hp_pri1_pwr_enable_b_in
    ,output logic                        rf_aqed_ll_qe_hp_pri1_pwr_enable_b_out

    ,input  logic                        rf_aqed_ll_qe_hp_pri2_wclk
    ,input  logic                        rf_aqed_ll_qe_hp_pri2_wclk_rst_n
    ,input  logic                        rf_aqed_ll_qe_hp_pri2_we
    ,input  logic [ (  11 ) -1 : 0 ]     rf_aqed_ll_qe_hp_pri2_waddr
    ,input  logic [ (  14 ) -1 : 0 ]     rf_aqed_ll_qe_hp_pri2_wdata
    ,input  logic                        rf_aqed_ll_qe_hp_pri2_rclk
    ,input  logic                        rf_aqed_ll_qe_hp_pri2_rclk_rst_n
    ,input  logic                        rf_aqed_ll_qe_hp_pri2_re
    ,input  logic [ (  11 ) -1 : 0 ]     rf_aqed_ll_qe_hp_pri2_raddr
    ,output logic [ (  14 ) -1 : 0 ]     rf_aqed_ll_qe_hp_pri2_rdata

    ,input  logic                        rf_aqed_ll_qe_hp_pri2_isol_en
    ,input  logic                        rf_aqed_ll_qe_hp_pri2_pwr_enable_b_in
    ,output logic                        rf_aqed_ll_qe_hp_pri2_pwr_enable_b_out

    ,input  logic                        rf_aqed_ll_qe_hp_pri3_wclk
    ,input  logic                        rf_aqed_ll_qe_hp_pri3_wclk_rst_n
    ,input  logic                        rf_aqed_ll_qe_hp_pri3_we
    ,input  logic [ (  11 ) -1 : 0 ]     rf_aqed_ll_qe_hp_pri3_waddr
    ,input  logic [ (  14 ) -1 : 0 ]     rf_aqed_ll_qe_hp_pri3_wdata
    ,input  logic                        rf_aqed_ll_qe_hp_pri3_rclk
    ,input  logic                        rf_aqed_ll_qe_hp_pri3_rclk_rst_n
    ,input  logic                        rf_aqed_ll_qe_hp_pri3_re
    ,input  logic [ (  11 ) -1 : 0 ]     rf_aqed_ll_qe_hp_pri3_raddr
    ,output logic [ (  14 ) -1 : 0 ]     rf_aqed_ll_qe_hp_pri3_rdata

    ,input  logic                        rf_aqed_ll_qe_hp_pri3_isol_en
    ,input  logic                        rf_aqed_ll_qe_hp_pri3_pwr_enable_b_in
    ,output logic                        rf_aqed_ll_qe_hp_pri3_pwr_enable_b_out

    ,input  logic                        rf_aqed_ll_qe_tp_pri0_wclk
    ,input  logic                        rf_aqed_ll_qe_tp_pri0_wclk_rst_n
    ,input  logic                        rf_aqed_ll_qe_tp_pri0_we
    ,input  logic [ (  11 ) -1 : 0 ]     rf_aqed_ll_qe_tp_pri0_waddr
    ,input  logic [ (  14 ) -1 : 0 ]     rf_aqed_ll_qe_tp_pri0_wdata
    ,input  logic                        rf_aqed_ll_qe_tp_pri0_rclk
    ,input  logic                        rf_aqed_ll_qe_tp_pri0_rclk_rst_n
    ,input  logic                        rf_aqed_ll_qe_tp_pri0_re
    ,input  logic [ (  11 ) -1 : 0 ]     rf_aqed_ll_qe_tp_pri0_raddr
    ,output logic [ (  14 ) -1 : 0 ]     rf_aqed_ll_qe_tp_pri0_rdata

    ,input  logic                        rf_aqed_ll_qe_tp_pri0_isol_en
    ,input  logic                        rf_aqed_ll_qe_tp_pri0_pwr_enable_b_in
    ,output logic                        rf_aqed_ll_qe_tp_pri0_pwr_enable_b_out

    ,input  logic                        rf_aqed_ll_qe_tp_pri1_wclk
    ,input  logic                        rf_aqed_ll_qe_tp_pri1_wclk_rst_n
    ,input  logic                        rf_aqed_ll_qe_tp_pri1_we
    ,input  logic [ (  11 ) -1 : 0 ]     rf_aqed_ll_qe_tp_pri1_waddr
    ,input  logic [ (  14 ) -1 : 0 ]     rf_aqed_ll_qe_tp_pri1_wdata
    ,input  logic                        rf_aqed_ll_qe_tp_pri1_rclk
    ,input  logic                        rf_aqed_ll_qe_tp_pri1_rclk_rst_n
    ,input  logic                        rf_aqed_ll_qe_tp_pri1_re
    ,input  logic [ (  11 ) -1 : 0 ]     rf_aqed_ll_qe_tp_pri1_raddr
    ,output logic [ (  14 ) -1 : 0 ]     rf_aqed_ll_qe_tp_pri1_rdata

    ,input  logic                        rf_aqed_ll_qe_tp_pri1_isol_en
    ,input  logic                        rf_aqed_ll_qe_tp_pri1_pwr_enable_b_in
    ,output logic                        rf_aqed_ll_qe_tp_pri1_pwr_enable_b_out

    ,input  logic                        rf_aqed_ll_qe_tp_pri2_wclk
    ,input  logic                        rf_aqed_ll_qe_tp_pri2_wclk_rst_n
    ,input  logic                        rf_aqed_ll_qe_tp_pri2_we
    ,input  logic [ (  11 ) -1 : 0 ]     rf_aqed_ll_qe_tp_pri2_waddr
    ,input  logic [ (  14 ) -1 : 0 ]     rf_aqed_ll_qe_tp_pri2_wdata
    ,input  logic                        rf_aqed_ll_qe_tp_pri2_rclk
    ,input  logic                        rf_aqed_ll_qe_tp_pri2_rclk_rst_n
    ,input  logic                        rf_aqed_ll_qe_tp_pri2_re
    ,input  logic [ (  11 ) -1 : 0 ]     rf_aqed_ll_qe_tp_pri2_raddr
    ,output logic [ (  14 ) -1 : 0 ]     rf_aqed_ll_qe_tp_pri2_rdata

    ,input  logic                        rf_aqed_ll_qe_tp_pri2_isol_en
    ,input  logic                        rf_aqed_ll_qe_tp_pri2_pwr_enable_b_in
    ,output logic                        rf_aqed_ll_qe_tp_pri2_pwr_enable_b_out

    ,input  logic                        rf_aqed_ll_qe_tp_pri3_wclk
    ,input  logic                        rf_aqed_ll_qe_tp_pri3_wclk_rst_n
    ,input  logic                        rf_aqed_ll_qe_tp_pri3_we
    ,input  logic [ (  11 ) -1 : 0 ]     rf_aqed_ll_qe_tp_pri3_waddr
    ,input  logic [ (  14 ) -1 : 0 ]     rf_aqed_ll_qe_tp_pri3_wdata
    ,input  logic                        rf_aqed_ll_qe_tp_pri3_rclk
    ,input  logic                        rf_aqed_ll_qe_tp_pri3_rclk_rst_n
    ,input  logic                        rf_aqed_ll_qe_tp_pri3_re
    ,input  logic [ (  11 ) -1 : 0 ]     rf_aqed_ll_qe_tp_pri3_raddr
    ,output logic [ (  14 ) -1 : 0 ]     rf_aqed_ll_qe_tp_pri3_rdata

    ,input  logic                        rf_aqed_ll_qe_tp_pri3_isol_en
    ,input  logic                        rf_aqed_ll_qe_tp_pri3_pwr_enable_b_in
    ,output logic                        rf_aqed_ll_qe_tp_pri3_pwr_enable_b_out

    ,input  logic                        rf_aqed_lsp_deq_fifo_mem_wclk
    ,input  logic                        rf_aqed_lsp_deq_fifo_mem_wclk_rst_n
    ,input  logic                        rf_aqed_lsp_deq_fifo_mem_we
    ,input  logic [ (   5 ) -1 : 0 ]     rf_aqed_lsp_deq_fifo_mem_waddr
    ,input  logic [ (   9 ) -1 : 0 ]     rf_aqed_lsp_deq_fifo_mem_wdata
    ,input  logic                        rf_aqed_lsp_deq_fifo_mem_rclk
    ,input  logic                        rf_aqed_lsp_deq_fifo_mem_rclk_rst_n
    ,input  logic                        rf_aqed_lsp_deq_fifo_mem_re
    ,input  logic [ (   5 ) -1 : 0 ]     rf_aqed_lsp_deq_fifo_mem_raddr
    ,output logic [ (   9 ) -1 : 0 ]     rf_aqed_lsp_deq_fifo_mem_rdata

    ,input  logic                        rf_aqed_lsp_deq_fifo_mem_isol_en
    ,input  logic                        rf_aqed_lsp_deq_fifo_mem_pwr_enable_b_in
    ,output logic                        rf_aqed_lsp_deq_fifo_mem_pwr_enable_b_out

    ,input  logic                        rf_aqed_qid2cqidix_wclk
    ,input  logic                        rf_aqed_qid2cqidix_wclk_rst_n
    ,input  logic                        rf_aqed_qid2cqidix_we
    ,input  logic [ (   5 ) -1 : 0 ]     rf_aqed_qid2cqidix_waddr
    ,input  logic [ ( 528 ) -1 : 0 ]     rf_aqed_qid2cqidix_wdata
    ,input  logic                        rf_aqed_qid2cqidix_rclk
    ,input  logic                        rf_aqed_qid2cqidix_rclk_rst_n
    ,input  logic                        rf_aqed_qid2cqidix_re
    ,input  logic [ (   5 ) -1 : 0 ]     rf_aqed_qid2cqidix_raddr
    ,output logic [ ( 528 ) -1 : 0 ]     rf_aqed_qid2cqidix_rdata

    ,input  logic                        rf_aqed_qid2cqidix_isol_en
    ,input  logic                        rf_aqed_qid2cqidix_pwr_enable_b_in
    ,output logic                        rf_aqed_qid2cqidix_pwr_enable_b_out

    ,input  logic                        rf_aqed_qid_cnt_wclk
    ,input  logic                        rf_aqed_qid_cnt_wclk_rst_n
    ,input  logic                        rf_aqed_qid_cnt_we
    ,input  logic [ (   5 ) -1 : 0 ]     rf_aqed_qid_cnt_waddr
    ,input  logic [ (  15 ) -1 : 0 ]     rf_aqed_qid_cnt_wdata
    ,input  logic                        rf_aqed_qid_cnt_rclk
    ,input  logic                        rf_aqed_qid_cnt_rclk_rst_n
    ,input  logic                        rf_aqed_qid_cnt_re
    ,input  logic [ (   5 ) -1 : 0 ]     rf_aqed_qid_cnt_raddr
    ,output logic [ (  15 ) -1 : 0 ]     rf_aqed_qid_cnt_rdata

    ,input  logic                        rf_aqed_qid_cnt_isol_en
    ,input  logic                        rf_aqed_qid_cnt_pwr_enable_b_in
    ,output logic                        rf_aqed_qid_cnt_pwr_enable_b_out

    ,input  logic                        rf_aqed_qid_fid_limit_wclk
    ,input  logic                        rf_aqed_qid_fid_limit_wclk_rst_n
    ,input  logic                        rf_aqed_qid_fid_limit_we
    ,input  logic [ (   5 ) -1 : 0 ]     rf_aqed_qid_fid_limit_waddr
    ,input  logic [ (  14 ) -1 : 0 ]     rf_aqed_qid_fid_limit_wdata
    ,input  logic                        rf_aqed_qid_fid_limit_rclk
    ,input  logic                        rf_aqed_qid_fid_limit_rclk_rst_n
    ,input  logic                        rf_aqed_qid_fid_limit_re
    ,input  logic [ (   5 ) -1 : 0 ]     rf_aqed_qid_fid_limit_raddr
    ,output logic [ (  14 ) -1 : 0 ]     rf_aqed_qid_fid_limit_rdata

    ,input  logic                        rf_aqed_qid_fid_limit_isol_en
    ,input  logic                        rf_aqed_qid_fid_limit_pwr_enable_b_in
    ,output logic                        rf_aqed_qid_fid_limit_pwr_enable_b_out

    ,input  logic                        rf_atm_cmp_fifo_mem_wclk
    ,input  logic                        rf_atm_cmp_fifo_mem_wclk_rst_n
    ,input  logic                        rf_atm_cmp_fifo_mem_we
    ,input  logic [ (   3 ) -1 : 0 ]     rf_atm_cmp_fifo_mem_waddr
    ,input  logic [ (  55 ) -1 : 0 ]     rf_atm_cmp_fifo_mem_wdata
    ,input  logic                        rf_atm_cmp_fifo_mem_rclk
    ,input  logic                        rf_atm_cmp_fifo_mem_rclk_rst_n
    ,input  logic                        rf_atm_cmp_fifo_mem_re
    ,input  logic [ (   3 ) -1 : 0 ]     rf_atm_cmp_fifo_mem_raddr
    ,output logic [ (  55 ) -1 : 0 ]     rf_atm_cmp_fifo_mem_rdata

    ,input  logic                        rf_atm_cmp_fifo_mem_isol_en
    ,input  logic                        rf_atm_cmp_fifo_mem_pwr_enable_b_in
    ,output logic                        rf_atm_cmp_fifo_mem_pwr_enable_b_out

    ,input  logic                        rf_atm_fifo_ap_aqed_wclk
    ,input  logic                        rf_atm_fifo_ap_aqed_wclk_rst_n
    ,input  logic                        rf_atm_fifo_ap_aqed_we
    ,input  logic [ (   4 ) -1 : 0 ]     rf_atm_fifo_ap_aqed_waddr
    ,input  logic [ (  45 ) -1 : 0 ]     rf_atm_fifo_ap_aqed_wdata
    ,input  logic                        rf_atm_fifo_ap_aqed_rclk
    ,input  logic                        rf_atm_fifo_ap_aqed_rclk_rst_n
    ,input  logic                        rf_atm_fifo_ap_aqed_re
    ,input  logic [ (   4 ) -1 : 0 ]     rf_atm_fifo_ap_aqed_raddr
    ,output logic [ (  45 ) -1 : 0 ]     rf_atm_fifo_ap_aqed_rdata

    ,input  logic                        rf_atm_fifo_ap_aqed_isol_en
    ,input  logic                        rf_atm_fifo_ap_aqed_pwr_enable_b_in
    ,output logic                        rf_atm_fifo_ap_aqed_pwr_enable_b_out

    ,input  logic                        rf_atm_fifo_aqed_ap_enq_wclk
    ,input  logic                        rf_atm_fifo_aqed_ap_enq_wclk_rst_n
    ,input  logic                        rf_atm_fifo_aqed_ap_enq_we
    ,input  logic [ (   5 ) -1 : 0 ]     rf_atm_fifo_aqed_ap_enq_waddr
    ,input  logic [ (  24 ) -1 : 0 ]     rf_atm_fifo_aqed_ap_enq_wdata
    ,input  logic                        rf_atm_fifo_aqed_ap_enq_rclk
    ,input  logic                        rf_atm_fifo_aqed_ap_enq_rclk_rst_n
    ,input  logic                        rf_atm_fifo_aqed_ap_enq_re
    ,input  logic [ (   5 ) -1 : 0 ]     rf_atm_fifo_aqed_ap_enq_raddr
    ,output logic [ (  24 ) -1 : 0 ]     rf_atm_fifo_aqed_ap_enq_rdata

    ,input  logic                        rf_atm_fifo_aqed_ap_enq_isol_en
    ,input  logic                        rf_atm_fifo_aqed_ap_enq_pwr_enable_b_in
    ,output logic                        rf_atm_fifo_aqed_ap_enq_pwr_enable_b_out

    ,input  logic                        rf_cfg_atm_qid_dpth_thrsh_mem_wclk
    ,input  logic                        rf_cfg_atm_qid_dpth_thrsh_mem_wclk_rst_n
    ,input  logic                        rf_cfg_atm_qid_dpth_thrsh_mem_we
    ,input  logic [ (   5 ) -1 : 0 ]     rf_cfg_atm_qid_dpth_thrsh_mem_waddr
    ,input  logic [ (  16 ) -1 : 0 ]     rf_cfg_atm_qid_dpth_thrsh_mem_wdata
    ,input  logic                        rf_cfg_atm_qid_dpth_thrsh_mem_rclk
    ,input  logic                        rf_cfg_atm_qid_dpth_thrsh_mem_rclk_rst_n
    ,input  logic                        rf_cfg_atm_qid_dpth_thrsh_mem_re
    ,input  logic [ (   5 ) -1 : 0 ]     rf_cfg_atm_qid_dpth_thrsh_mem_raddr
    ,output logic [ (  16 ) -1 : 0 ]     rf_cfg_atm_qid_dpth_thrsh_mem_rdata

    ,input  logic                        rf_cfg_atm_qid_dpth_thrsh_mem_isol_en
    ,input  logic                        rf_cfg_atm_qid_dpth_thrsh_mem_pwr_enable_b_in
    ,output logic                        rf_cfg_atm_qid_dpth_thrsh_mem_pwr_enable_b_out

    ,input  logic                        rf_cfg_cq2priov_mem_wclk
    ,input  logic                        rf_cfg_cq2priov_mem_wclk_rst_n
    ,input  logic                        rf_cfg_cq2priov_mem_we
    ,input  logic [ (   5 ) -1 : 0 ]     rf_cfg_cq2priov_mem_waddr
    ,input  logic [ (  33 ) -1 : 0 ]     rf_cfg_cq2priov_mem_wdata
    ,input  logic                        rf_cfg_cq2priov_mem_rclk
    ,input  logic                        rf_cfg_cq2priov_mem_rclk_rst_n
    ,input  logic                        rf_cfg_cq2priov_mem_re
    ,input  logic [ (   5 ) -1 : 0 ]     rf_cfg_cq2priov_mem_raddr
    ,output logic [ (  33 ) -1 : 0 ]     rf_cfg_cq2priov_mem_rdata

    ,input  logic                        rf_cfg_cq2priov_mem_isol_en
    ,input  logic                        rf_cfg_cq2priov_mem_pwr_enable_b_in
    ,output logic                        rf_cfg_cq2priov_mem_pwr_enable_b_out

    ,input  logic                        rf_cfg_cq2priov_odd_mem_wclk
    ,input  logic                        rf_cfg_cq2priov_odd_mem_wclk_rst_n
    ,input  logic                        rf_cfg_cq2priov_odd_mem_we
    ,input  logic [ (   5 ) -1 : 0 ]     rf_cfg_cq2priov_odd_mem_waddr
    ,input  logic [ (  33 ) -1 : 0 ]     rf_cfg_cq2priov_odd_mem_wdata
    ,input  logic                        rf_cfg_cq2priov_odd_mem_rclk
    ,input  logic                        rf_cfg_cq2priov_odd_mem_rclk_rst_n
    ,input  logic                        rf_cfg_cq2priov_odd_mem_re
    ,input  logic [ (   5 ) -1 : 0 ]     rf_cfg_cq2priov_odd_mem_raddr
    ,output logic [ (  33 ) -1 : 0 ]     rf_cfg_cq2priov_odd_mem_rdata

    ,input  logic                        rf_cfg_cq2priov_odd_mem_isol_en
    ,input  logic                        rf_cfg_cq2priov_odd_mem_pwr_enable_b_in
    ,output logic                        rf_cfg_cq2priov_odd_mem_pwr_enable_b_out

    ,input  logic                        rf_cfg_cq2qid_0_mem_wclk
    ,input  logic                        rf_cfg_cq2qid_0_mem_wclk_rst_n
    ,input  logic                        rf_cfg_cq2qid_0_mem_we
    ,input  logic [ (   5 ) -1 : 0 ]     rf_cfg_cq2qid_0_mem_waddr
    ,input  logic [ (  29 ) -1 : 0 ]     rf_cfg_cq2qid_0_mem_wdata
    ,input  logic                        rf_cfg_cq2qid_0_mem_rclk
    ,input  logic                        rf_cfg_cq2qid_0_mem_rclk_rst_n
    ,input  logic                        rf_cfg_cq2qid_0_mem_re
    ,input  logic [ (   5 ) -1 : 0 ]     rf_cfg_cq2qid_0_mem_raddr
    ,output logic [ (  29 ) -1 : 0 ]     rf_cfg_cq2qid_0_mem_rdata

    ,input  logic                        rf_cfg_cq2qid_0_mem_isol_en
    ,input  logic                        rf_cfg_cq2qid_0_mem_pwr_enable_b_in
    ,output logic                        rf_cfg_cq2qid_0_mem_pwr_enable_b_out

    ,input  logic                        rf_cfg_cq2qid_0_odd_mem_wclk
    ,input  logic                        rf_cfg_cq2qid_0_odd_mem_wclk_rst_n
    ,input  logic                        rf_cfg_cq2qid_0_odd_mem_we
    ,input  logic [ (   5 ) -1 : 0 ]     rf_cfg_cq2qid_0_odd_mem_waddr
    ,input  logic [ (  29 ) -1 : 0 ]     rf_cfg_cq2qid_0_odd_mem_wdata
    ,input  logic                        rf_cfg_cq2qid_0_odd_mem_rclk
    ,input  logic                        rf_cfg_cq2qid_0_odd_mem_rclk_rst_n
    ,input  logic                        rf_cfg_cq2qid_0_odd_mem_re
    ,input  logic [ (   5 ) -1 : 0 ]     rf_cfg_cq2qid_0_odd_mem_raddr
    ,output logic [ (  29 ) -1 : 0 ]     rf_cfg_cq2qid_0_odd_mem_rdata

    ,input  logic                        rf_cfg_cq2qid_0_odd_mem_isol_en
    ,input  logic                        rf_cfg_cq2qid_0_odd_mem_pwr_enable_b_in
    ,output logic                        rf_cfg_cq2qid_0_odd_mem_pwr_enable_b_out

    ,input  logic                        rf_cfg_cq2qid_1_mem_wclk
    ,input  logic                        rf_cfg_cq2qid_1_mem_wclk_rst_n
    ,input  logic                        rf_cfg_cq2qid_1_mem_we
    ,input  logic [ (   5 ) -1 : 0 ]     rf_cfg_cq2qid_1_mem_waddr
    ,input  logic [ (  29 ) -1 : 0 ]     rf_cfg_cq2qid_1_mem_wdata
    ,input  logic                        rf_cfg_cq2qid_1_mem_rclk
    ,input  logic                        rf_cfg_cq2qid_1_mem_rclk_rst_n
    ,input  logic                        rf_cfg_cq2qid_1_mem_re
    ,input  logic [ (   5 ) -1 : 0 ]     rf_cfg_cq2qid_1_mem_raddr
    ,output logic [ (  29 ) -1 : 0 ]     rf_cfg_cq2qid_1_mem_rdata

    ,input  logic                        rf_cfg_cq2qid_1_mem_isol_en
    ,input  logic                        rf_cfg_cq2qid_1_mem_pwr_enable_b_in
    ,output logic                        rf_cfg_cq2qid_1_mem_pwr_enable_b_out

    ,input  logic                        rf_cfg_cq2qid_1_odd_mem_wclk
    ,input  logic                        rf_cfg_cq2qid_1_odd_mem_wclk_rst_n
    ,input  logic                        rf_cfg_cq2qid_1_odd_mem_we
    ,input  logic [ (   5 ) -1 : 0 ]     rf_cfg_cq2qid_1_odd_mem_waddr
    ,input  logic [ (  29 ) -1 : 0 ]     rf_cfg_cq2qid_1_odd_mem_wdata
    ,input  logic                        rf_cfg_cq2qid_1_odd_mem_rclk
    ,input  logic                        rf_cfg_cq2qid_1_odd_mem_rclk_rst_n
    ,input  logic                        rf_cfg_cq2qid_1_odd_mem_re
    ,input  logic [ (   5 ) -1 : 0 ]     rf_cfg_cq2qid_1_odd_mem_raddr
    ,output logic [ (  29 ) -1 : 0 ]     rf_cfg_cq2qid_1_odd_mem_rdata

    ,input  logic                        rf_cfg_cq2qid_1_odd_mem_isol_en
    ,input  logic                        rf_cfg_cq2qid_1_odd_mem_pwr_enable_b_in
    ,output logic                        rf_cfg_cq2qid_1_odd_mem_pwr_enable_b_out

    ,input  logic                        rf_cfg_cq_ldb_inflight_limit_mem_wclk
    ,input  logic                        rf_cfg_cq_ldb_inflight_limit_mem_wclk_rst_n
    ,input  logic                        rf_cfg_cq_ldb_inflight_limit_mem_we
    ,input  logic [ (   6 ) -1 : 0 ]     rf_cfg_cq_ldb_inflight_limit_mem_waddr
    ,input  logic [ (  14 ) -1 : 0 ]     rf_cfg_cq_ldb_inflight_limit_mem_wdata
    ,input  logic                        rf_cfg_cq_ldb_inflight_limit_mem_rclk
    ,input  logic                        rf_cfg_cq_ldb_inflight_limit_mem_rclk_rst_n
    ,input  logic                        rf_cfg_cq_ldb_inflight_limit_mem_re
    ,input  logic [ (   6 ) -1 : 0 ]     rf_cfg_cq_ldb_inflight_limit_mem_raddr
    ,output logic [ (  14 ) -1 : 0 ]     rf_cfg_cq_ldb_inflight_limit_mem_rdata

    ,input  logic                        rf_cfg_cq_ldb_inflight_limit_mem_isol_en
    ,input  logic                        rf_cfg_cq_ldb_inflight_limit_mem_pwr_enable_b_in
    ,output logic                        rf_cfg_cq_ldb_inflight_limit_mem_pwr_enable_b_out

    ,input  logic                        rf_cfg_cq_ldb_inflight_threshold_mem_wclk
    ,input  logic                        rf_cfg_cq_ldb_inflight_threshold_mem_wclk_rst_n
    ,input  logic                        rf_cfg_cq_ldb_inflight_threshold_mem_we
    ,input  logic [ (   6 ) -1 : 0 ]     rf_cfg_cq_ldb_inflight_threshold_mem_waddr
    ,input  logic [ (  14 ) -1 : 0 ]     rf_cfg_cq_ldb_inflight_threshold_mem_wdata
    ,input  logic                        rf_cfg_cq_ldb_inflight_threshold_mem_rclk
    ,input  logic                        rf_cfg_cq_ldb_inflight_threshold_mem_rclk_rst_n
    ,input  logic                        rf_cfg_cq_ldb_inflight_threshold_mem_re
    ,input  logic [ (   6 ) -1 : 0 ]     rf_cfg_cq_ldb_inflight_threshold_mem_raddr
    ,output logic [ (  14 ) -1 : 0 ]     rf_cfg_cq_ldb_inflight_threshold_mem_rdata

    ,input  logic                        rf_cfg_cq_ldb_inflight_threshold_mem_isol_en
    ,input  logic                        rf_cfg_cq_ldb_inflight_threshold_mem_pwr_enable_b_in
    ,output logic                        rf_cfg_cq_ldb_inflight_threshold_mem_pwr_enable_b_out

    ,input  logic                        rf_cfg_cq_ldb_token_depth_select_mem_wclk
    ,input  logic                        rf_cfg_cq_ldb_token_depth_select_mem_wclk_rst_n
    ,input  logic                        rf_cfg_cq_ldb_token_depth_select_mem_we
    ,input  logic [ (   6 ) -1 : 0 ]     rf_cfg_cq_ldb_token_depth_select_mem_waddr
    ,input  logic [ (   5 ) -1 : 0 ]     rf_cfg_cq_ldb_token_depth_select_mem_wdata
    ,input  logic                        rf_cfg_cq_ldb_token_depth_select_mem_rclk
    ,input  logic                        rf_cfg_cq_ldb_token_depth_select_mem_rclk_rst_n
    ,input  logic                        rf_cfg_cq_ldb_token_depth_select_mem_re
    ,input  logic [ (   6 ) -1 : 0 ]     rf_cfg_cq_ldb_token_depth_select_mem_raddr
    ,output logic [ (   5 ) -1 : 0 ]     rf_cfg_cq_ldb_token_depth_select_mem_rdata

    ,input  logic                        rf_cfg_cq_ldb_token_depth_select_mem_isol_en
    ,input  logic                        rf_cfg_cq_ldb_token_depth_select_mem_pwr_enable_b_in
    ,output logic                        rf_cfg_cq_ldb_token_depth_select_mem_pwr_enable_b_out

    ,input  logic                        rf_cfg_cq_ldb_wu_limit_mem_wclk
    ,input  logic                        rf_cfg_cq_ldb_wu_limit_mem_wclk_rst_n
    ,input  logic                        rf_cfg_cq_ldb_wu_limit_mem_we
    ,input  logic [ (   6 ) -1 : 0 ]     rf_cfg_cq_ldb_wu_limit_mem_waddr
    ,input  logic [ (  17 ) -1 : 0 ]     rf_cfg_cq_ldb_wu_limit_mem_wdata
    ,input  logic                        rf_cfg_cq_ldb_wu_limit_mem_rclk
    ,input  logic                        rf_cfg_cq_ldb_wu_limit_mem_rclk_rst_n
    ,input  logic                        rf_cfg_cq_ldb_wu_limit_mem_re
    ,input  logic [ (   6 ) -1 : 0 ]     rf_cfg_cq_ldb_wu_limit_mem_raddr
    ,output logic [ (  17 ) -1 : 0 ]     rf_cfg_cq_ldb_wu_limit_mem_rdata

    ,input  logic                        rf_cfg_cq_ldb_wu_limit_mem_isol_en
    ,input  logic                        rf_cfg_cq_ldb_wu_limit_mem_pwr_enable_b_in
    ,output logic                        rf_cfg_cq_ldb_wu_limit_mem_pwr_enable_b_out

    ,input  logic                        rf_cfg_dir_qid_dpth_thrsh_mem_wclk
    ,input  logic                        rf_cfg_dir_qid_dpth_thrsh_mem_wclk_rst_n
    ,input  logic                        rf_cfg_dir_qid_dpth_thrsh_mem_we
    ,input  logic [ (   6 ) -1 : 0 ]     rf_cfg_dir_qid_dpth_thrsh_mem_waddr
    ,input  logic [ (  16 ) -1 : 0 ]     rf_cfg_dir_qid_dpth_thrsh_mem_wdata
    ,input  logic                        rf_cfg_dir_qid_dpth_thrsh_mem_rclk
    ,input  logic                        rf_cfg_dir_qid_dpth_thrsh_mem_rclk_rst_n
    ,input  logic                        rf_cfg_dir_qid_dpth_thrsh_mem_re
    ,input  logic [ (   6 ) -1 : 0 ]     rf_cfg_dir_qid_dpth_thrsh_mem_raddr
    ,output logic [ (  16 ) -1 : 0 ]     rf_cfg_dir_qid_dpth_thrsh_mem_rdata

    ,input  logic                        rf_cfg_dir_qid_dpth_thrsh_mem_isol_en
    ,input  logic                        rf_cfg_dir_qid_dpth_thrsh_mem_pwr_enable_b_in
    ,output logic                        rf_cfg_dir_qid_dpth_thrsh_mem_pwr_enable_b_out

    ,input  logic                        rf_cfg_nalb_qid_dpth_thrsh_mem_wclk
    ,input  logic                        rf_cfg_nalb_qid_dpth_thrsh_mem_wclk_rst_n
    ,input  logic                        rf_cfg_nalb_qid_dpth_thrsh_mem_we
    ,input  logic [ (   5 ) -1 : 0 ]     rf_cfg_nalb_qid_dpth_thrsh_mem_waddr
    ,input  logic [ (  16 ) -1 : 0 ]     rf_cfg_nalb_qid_dpth_thrsh_mem_wdata
    ,input  logic                        rf_cfg_nalb_qid_dpth_thrsh_mem_rclk
    ,input  logic                        rf_cfg_nalb_qid_dpth_thrsh_mem_rclk_rst_n
    ,input  logic                        rf_cfg_nalb_qid_dpth_thrsh_mem_re
    ,input  logic [ (   5 ) -1 : 0 ]     rf_cfg_nalb_qid_dpth_thrsh_mem_raddr
    ,output logic [ (  16 ) -1 : 0 ]     rf_cfg_nalb_qid_dpth_thrsh_mem_rdata

    ,input  logic                        rf_cfg_nalb_qid_dpth_thrsh_mem_isol_en
    ,input  logic                        rf_cfg_nalb_qid_dpth_thrsh_mem_pwr_enable_b_in
    ,output logic                        rf_cfg_nalb_qid_dpth_thrsh_mem_pwr_enable_b_out

    ,input  logic                        rf_cfg_qid_aqed_active_limit_mem_wclk
    ,input  logic                        rf_cfg_qid_aqed_active_limit_mem_wclk_rst_n
    ,input  logic                        rf_cfg_qid_aqed_active_limit_mem_we
    ,input  logic [ (   5 ) -1 : 0 ]     rf_cfg_qid_aqed_active_limit_mem_waddr
    ,input  logic [ (  13 ) -1 : 0 ]     rf_cfg_qid_aqed_active_limit_mem_wdata
    ,input  logic                        rf_cfg_qid_aqed_active_limit_mem_rclk
    ,input  logic                        rf_cfg_qid_aqed_active_limit_mem_rclk_rst_n
    ,input  logic                        rf_cfg_qid_aqed_active_limit_mem_re
    ,input  logic [ (   5 ) -1 : 0 ]     rf_cfg_qid_aqed_active_limit_mem_raddr
    ,output logic [ (  13 ) -1 : 0 ]     rf_cfg_qid_aqed_active_limit_mem_rdata

    ,input  logic                        rf_cfg_qid_aqed_active_limit_mem_isol_en
    ,input  logic                        rf_cfg_qid_aqed_active_limit_mem_pwr_enable_b_in
    ,output logic                        rf_cfg_qid_aqed_active_limit_mem_pwr_enable_b_out

    ,input  logic                        rf_cfg_qid_ldb_inflight_limit_mem_wclk
    ,input  logic                        rf_cfg_qid_ldb_inflight_limit_mem_wclk_rst_n
    ,input  logic                        rf_cfg_qid_ldb_inflight_limit_mem_we
    ,input  logic [ (   5 ) -1 : 0 ]     rf_cfg_qid_ldb_inflight_limit_mem_waddr
    ,input  logic [ (  13 ) -1 : 0 ]     rf_cfg_qid_ldb_inflight_limit_mem_wdata
    ,input  logic                        rf_cfg_qid_ldb_inflight_limit_mem_rclk
    ,input  logic                        rf_cfg_qid_ldb_inflight_limit_mem_rclk_rst_n
    ,input  logic                        rf_cfg_qid_ldb_inflight_limit_mem_re
    ,input  logic [ (   5 ) -1 : 0 ]     rf_cfg_qid_ldb_inflight_limit_mem_raddr
    ,output logic [ (  13 ) -1 : 0 ]     rf_cfg_qid_ldb_inflight_limit_mem_rdata

    ,input  logic                        rf_cfg_qid_ldb_inflight_limit_mem_isol_en
    ,input  logic                        rf_cfg_qid_ldb_inflight_limit_mem_pwr_enable_b_in
    ,output logic                        rf_cfg_qid_ldb_inflight_limit_mem_pwr_enable_b_out

    ,input  logic                        rf_cfg_qid_ldb_qid2cqidix2_mem_wclk
    ,input  logic                        rf_cfg_qid_ldb_qid2cqidix2_mem_wclk_rst_n
    ,input  logic                        rf_cfg_qid_ldb_qid2cqidix2_mem_we
    ,input  logic [ (   5 ) -1 : 0 ]     rf_cfg_qid_ldb_qid2cqidix2_mem_waddr
    ,input  logic [ ( 528 ) -1 : 0 ]     rf_cfg_qid_ldb_qid2cqidix2_mem_wdata
    ,input  logic                        rf_cfg_qid_ldb_qid2cqidix2_mem_rclk
    ,input  logic                        rf_cfg_qid_ldb_qid2cqidix2_mem_rclk_rst_n
    ,input  logic                        rf_cfg_qid_ldb_qid2cqidix2_mem_re
    ,input  logic [ (   5 ) -1 : 0 ]     rf_cfg_qid_ldb_qid2cqidix2_mem_raddr
    ,output logic [ ( 528 ) -1 : 0 ]     rf_cfg_qid_ldb_qid2cqidix2_mem_rdata

    ,input  logic                        rf_cfg_qid_ldb_qid2cqidix2_mem_isol_en
    ,input  logic                        rf_cfg_qid_ldb_qid2cqidix2_mem_pwr_enable_b_in
    ,output logic                        rf_cfg_qid_ldb_qid2cqidix2_mem_pwr_enable_b_out

    ,input  logic                        rf_cfg_qid_ldb_qid2cqidix_mem_wclk
    ,input  logic                        rf_cfg_qid_ldb_qid2cqidix_mem_wclk_rst_n
    ,input  logic                        rf_cfg_qid_ldb_qid2cqidix_mem_we
    ,input  logic [ (   5 ) -1 : 0 ]     rf_cfg_qid_ldb_qid2cqidix_mem_waddr
    ,input  logic [ ( 528 ) -1 : 0 ]     rf_cfg_qid_ldb_qid2cqidix_mem_wdata
    ,input  logic                        rf_cfg_qid_ldb_qid2cqidix_mem_rclk
    ,input  logic                        rf_cfg_qid_ldb_qid2cqidix_mem_rclk_rst_n
    ,input  logic                        rf_cfg_qid_ldb_qid2cqidix_mem_re
    ,input  logic [ (   5 ) -1 : 0 ]     rf_cfg_qid_ldb_qid2cqidix_mem_raddr
    ,output logic [ ( 528 ) -1 : 0 ]     rf_cfg_qid_ldb_qid2cqidix_mem_rdata

    ,input  logic                        rf_cfg_qid_ldb_qid2cqidix_mem_isol_en
    ,input  logic                        rf_cfg_qid_ldb_qid2cqidix_mem_pwr_enable_b_in
    ,output logic                        rf_cfg_qid_ldb_qid2cqidix_mem_pwr_enable_b_out

    ,input  logic                        rf_chp_lsp_cmp_rx_sync_fifo_mem_wclk
    ,input  logic                        rf_chp_lsp_cmp_rx_sync_fifo_mem_wclk_rst_n
    ,input  logic                        rf_chp_lsp_cmp_rx_sync_fifo_mem_we
    ,input  logic [ (   2 ) -1 : 0 ]     rf_chp_lsp_cmp_rx_sync_fifo_mem_waddr
    ,input  logic [ (  73 ) -1 : 0 ]     rf_chp_lsp_cmp_rx_sync_fifo_mem_wdata
    ,input  logic                        rf_chp_lsp_cmp_rx_sync_fifo_mem_rclk
    ,input  logic                        rf_chp_lsp_cmp_rx_sync_fifo_mem_rclk_rst_n
    ,input  logic                        rf_chp_lsp_cmp_rx_sync_fifo_mem_re
    ,input  logic [ (   2 ) -1 : 0 ]     rf_chp_lsp_cmp_rx_sync_fifo_mem_raddr
    ,output logic [ (  73 ) -1 : 0 ]     rf_chp_lsp_cmp_rx_sync_fifo_mem_rdata

    ,input  logic                        rf_chp_lsp_cmp_rx_sync_fifo_mem_isol_en
    ,input  logic                        rf_chp_lsp_cmp_rx_sync_fifo_mem_pwr_enable_b_in
    ,output logic                        rf_chp_lsp_cmp_rx_sync_fifo_mem_pwr_enable_b_out

    ,input  logic                        rf_chp_lsp_token_rx_sync_fifo_mem_wclk
    ,input  logic                        rf_chp_lsp_token_rx_sync_fifo_mem_wclk_rst_n
    ,input  logic                        rf_chp_lsp_token_rx_sync_fifo_mem_we
    ,input  logic [ (   2 ) -1 : 0 ]     rf_chp_lsp_token_rx_sync_fifo_mem_waddr
    ,input  logic [ (  25 ) -1 : 0 ]     rf_chp_lsp_token_rx_sync_fifo_mem_wdata
    ,input  logic                        rf_chp_lsp_token_rx_sync_fifo_mem_rclk
    ,input  logic                        rf_chp_lsp_token_rx_sync_fifo_mem_rclk_rst_n
    ,input  logic                        rf_chp_lsp_token_rx_sync_fifo_mem_re
    ,input  logic [ (   2 ) -1 : 0 ]     rf_chp_lsp_token_rx_sync_fifo_mem_raddr
    ,output logic [ (  25 ) -1 : 0 ]     rf_chp_lsp_token_rx_sync_fifo_mem_rdata

    ,input  logic                        rf_chp_lsp_token_rx_sync_fifo_mem_isol_en
    ,input  logic                        rf_chp_lsp_token_rx_sync_fifo_mem_pwr_enable_b_in
    ,output logic                        rf_chp_lsp_token_rx_sync_fifo_mem_pwr_enable_b_out

    ,input  logic                        rf_cq_atm_pri_arbindex_mem_wclk
    ,input  logic                        rf_cq_atm_pri_arbindex_mem_wclk_rst_n
    ,input  logic                        rf_cq_atm_pri_arbindex_mem_we
    ,input  logic [ (   5 ) -1 : 0 ]     rf_cq_atm_pri_arbindex_mem_waddr
    ,input  logic [ (  96 ) -1 : 0 ]     rf_cq_atm_pri_arbindex_mem_wdata
    ,input  logic                        rf_cq_atm_pri_arbindex_mem_rclk
    ,input  logic                        rf_cq_atm_pri_arbindex_mem_rclk_rst_n
    ,input  logic                        rf_cq_atm_pri_arbindex_mem_re
    ,input  logic [ (   5 ) -1 : 0 ]     rf_cq_atm_pri_arbindex_mem_raddr
    ,output logic [ (  96 ) -1 : 0 ]     rf_cq_atm_pri_arbindex_mem_rdata

    ,input  logic                        rf_cq_atm_pri_arbindex_mem_isol_en
    ,input  logic                        rf_cq_atm_pri_arbindex_mem_pwr_enable_b_in
    ,output logic                        rf_cq_atm_pri_arbindex_mem_pwr_enable_b_out

    ,input  logic                        rf_cq_dir_tot_sch_cnt_mem_wclk
    ,input  logic                        rf_cq_dir_tot_sch_cnt_mem_wclk_rst_n
    ,input  logic                        rf_cq_dir_tot_sch_cnt_mem_we
    ,input  logic [ (   6 ) -1 : 0 ]     rf_cq_dir_tot_sch_cnt_mem_waddr
    ,input  logic [ (  66 ) -1 : 0 ]     rf_cq_dir_tot_sch_cnt_mem_wdata
    ,input  logic                        rf_cq_dir_tot_sch_cnt_mem_rclk
    ,input  logic                        rf_cq_dir_tot_sch_cnt_mem_rclk_rst_n
    ,input  logic                        rf_cq_dir_tot_sch_cnt_mem_re
    ,input  logic [ (   6 ) -1 : 0 ]     rf_cq_dir_tot_sch_cnt_mem_raddr
    ,output logic [ (  66 ) -1 : 0 ]     rf_cq_dir_tot_sch_cnt_mem_rdata

    ,input  logic                        rf_cq_dir_tot_sch_cnt_mem_isol_en
    ,input  logic                        rf_cq_dir_tot_sch_cnt_mem_pwr_enable_b_in
    ,output logic                        rf_cq_dir_tot_sch_cnt_mem_pwr_enable_b_out

    ,input  logic                        rf_cq_ldb_inflight_count_mem_wclk
    ,input  logic                        rf_cq_ldb_inflight_count_mem_wclk_rst_n
    ,input  logic                        rf_cq_ldb_inflight_count_mem_we
    ,input  logic [ (   6 ) -1 : 0 ]     rf_cq_ldb_inflight_count_mem_waddr
    ,input  logic [ (  15 ) -1 : 0 ]     rf_cq_ldb_inflight_count_mem_wdata
    ,input  logic                        rf_cq_ldb_inflight_count_mem_rclk
    ,input  logic                        rf_cq_ldb_inflight_count_mem_rclk_rst_n
    ,input  logic                        rf_cq_ldb_inflight_count_mem_re
    ,input  logic [ (   6 ) -1 : 0 ]     rf_cq_ldb_inflight_count_mem_raddr
    ,output logic [ (  15 ) -1 : 0 ]     rf_cq_ldb_inflight_count_mem_rdata

    ,input  logic                        rf_cq_ldb_inflight_count_mem_isol_en
    ,input  logic                        rf_cq_ldb_inflight_count_mem_pwr_enable_b_in
    ,output logic                        rf_cq_ldb_inflight_count_mem_pwr_enable_b_out

    ,input  logic                        rf_cq_ldb_token_count_mem_wclk
    ,input  logic                        rf_cq_ldb_token_count_mem_wclk_rst_n
    ,input  logic                        rf_cq_ldb_token_count_mem_we
    ,input  logic [ (   6 ) -1 : 0 ]     rf_cq_ldb_token_count_mem_waddr
    ,input  logic [ (  13 ) -1 : 0 ]     rf_cq_ldb_token_count_mem_wdata
    ,input  logic                        rf_cq_ldb_token_count_mem_rclk
    ,input  logic                        rf_cq_ldb_token_count_mem_rclk_rst_n
    ,input  logic                        rf_cq_ldb_token_count_mem_re
    ,input  logic [ (   6 ) -1 : 0 ]     rf_cq_ldb_token_count_mem_raddr
    ,output logic [ (  13 ) -1 : 0 ]     rf_cq_ldb_token_count_mem_rdata

    ,input  logic                        rf_cq_ldb_token_count_mem_isol_en
    ,input  logic                        rf_cq_ldb_token_count_mem_pwr_enable_b_in
    ,output logic                        rf_cq_ldb_token_count_mem_pwr_enable_b_out

    ,input  logic                        rf_cq_ldb_tot_sch_cnt_mem_wclk
    ,input  logic                        rf_cq_ldb_tot_sch_cnt_mem_wclk_rst_n
    ,input  logic                        rf_cq_ldb_tot_sch_cnt_mem_we
    ,input  logic [ (   6 ) -1 : 0 ]     rf_cq_ldb_tot_sch_cnt_mem_waddr
    ,input  logic [ (  66 ) -1 : 0 ]     rf_cq_ldb_tot_sch_cnt_mem_wdata
    ,input  logic                        rf_cq_ldb_tot_sch_cnt_mem_rclk
    ,input  logic                        rf_cq_ldb_tot_sch_cnt_mem_rclk_rst_n
    ,input  logic                        rf_cq_ldb_tot_sch_cnt_mem_re
    ,input  logic [ (   6 ) -1 : 0 ]     rf_cq_ldb_tot_sch_cnt_mem_raddr
    ,output logic [ (  66 ) -1 : 0 ]     rf_cq_ldb_tot_sch_cnt_mem_rdata

    ,input  logic                        rf_cq_ldb_tot_sch_cnt_mem_isol_en
    ,input  logic                        rf_cq_ldb_tot_sch_cnt_mem_pwr_enable_b_in
    ,output logic                        rf_cq_ldb_tot_sch_cnt_mem_pwr_enable_b_out

    ,input  logic                        rf_cq_ldb_wu_count_mem_wclk
    ,input  logic                        rf_cq_ldb_wu_count_mem_wclk_rst_n
    ,input  logic                        rf_cq_ldb_wu_count_mem_we
    ,input  logic [ (   6 ) -1 : 0 ]     rf_cq_ldb_wu_count_mem_waddr
    ,input  logic [ (  19 ) -1 : 0 ]     rf_cq_ldb_wu_count_mem_wdata
    ,input  logic                        rf_cq_ldb_wu_count_mem_rclk
    ,input  logic                        rf_cq_ldb_wu_count_mem_rclk_rst_n
    ,input  logic                        rf_cq_ldb_wu_count_mem_re
    ,input  logic [ (   6 ) -1 : 0 ]     rf_cq_ldb_wu_count_mem_raddr
    ,output logic [ (  19 ) -1 : 0 ]     rf_cq_ldb_wu_count_mem_rdata

    ,input  logic                        rf_cq_ldb_wu_count_mem_isol_en
    ,input  logic                        rf_cq_ldb_wu_count_mem_pwr_enable_b_in
    ,output logic                        rf_cq_ldb_wu_count_mem_pwr_enable_b_out

    ,input  logic                        rf_cq_nalb_pri_arbindex_mem_wclk
    ,input  logic                        rf_cq_nalb_pri_arbindex_mem_wclk_rst_n
    ,input  logic                        rf_cq_nalb_pri_arbindex_mem_we
    ,input  logic [ (   5 ) -1 : 0 ]     rf_cq_nalb_pri_arbindex_mem_waddr
    ,input  logic [ (  96 ) -1 : 0 ]     rf_cq_nalb_pri_arbindex_mem_wdata
    ,input  logic                        rf_cq_nalb_pri_arbindex_mem_rclk
    ,input  logic                        rf_cq_nalb_pri_arbindex_mem_rclk_rst_n
    ,input  logic                        rf_cq_nalb_pri_arbindex_mem_re
    ,input  logic [ (   5 ) -1 : 0 ]     rf_cq_nalb_pri_arbindex_mem_raddr
    ,output logic [ (  96 ) -1 : 0 ]     rf_cq_nalb_pri_arbindex_mem_rdata

    ,input  logic                        rf_cq_nalb_pri_arbindex_mem_isol_en
    ,input  logic                        rf_cq_nalb_pri_arbindex_mem_pwr_enable_b_in
    ,output logic                        rf_cq_nalb_pri_arbindex_mem_pwr_enable_b_out

    ,input  logic                        rf_dir_enq_cnt_mem_wclk
    ,input  logic                        rf_dir_enq_cnt_mem_wclk_rst_n
    ,input  logic                        rf_dir_enq_cnt_mem_we
    ,input  logic [ (   6 ) -1 : 0 ]     rf_dir_enq_cnt_mem_waddr
    ,input  logic [ (  17 ) -1 : 0 ]     rf_dir_enq_cnt_mem_wdata
    ,input  logic                        rf_dir_enq_cnt_mem_rclk
    ,input  logic                        rf_dir_enq_cnt_mem_rclk_rst_n
    ,input  logic                        rf_dir_enq_cnt_mem_re
    ,input  logic [ (   6 ) -1 : 0 ]     rf_dir_enq_cnt_mem_raddr
    ,output logic [ (  17 ) -1 : 0 ]     rf_dir_enq_cnt_mem_rdata

    ,input  logic                        rf_dir_enq_cnt_mem_isol_en
    ,input  logic                        rf_dir_enq_cnt_mem_pwr_enable_b_in
    ,output logic                        rf_dir_enq_cnt_mem_pwr_enable_b_out

    ,input  logic                        rf_dir_tok_cnt_mem_wclk
    ,input  logic                        rf_dir_tok_cnt_mem_wclk_rst_n
    ,input  logic                        rf_dir_tok_cnt_mem_we
    ,input  logic [ (   6 ) -1 : 0 ]     rf_dir_tok_cnt_mem_waddr
    ,input  logic [ (  13 ) -1 : 0 ]     rf_dir_tok_cnt_mem_wdata
    ,input  logic                        rf_dir_tok_cnt_mem_rclk
    ,input  logic                        rf_dir_tok_cnt_mem_rclk_rst_n
    ,input  logic                        rf_dir_tok_cnt_mem_re
    ,input  logic [ (   6 ) -1 : 0 ]     rf_dir_tok_cnt_mem_raddr
    ,output logic [ (  13 ) -1 : 0 ]     rf_dir_tok_cnt_mem_rdata

    ,input  logic                        rf_dir_tok_cnt_mem_isol_en
    ,input  logic                        rf_dir_tok_cnt_mem_pwr_enable_b_in
    ,output logic                        rf_dir_tok_cnt_mem_pwr_enable_b_out

    ,input  logic                        rf_dir_tok_lim_mem_wclk
    ,input  logic                        rf_dir_tok_lim_mem_wclk_rst_n
    ,input  logic                        rf_dir_tok_lim_mem_we
    ,input  logic [ (   6 ) -1 : 0 ]     rf_dir_tok_lim_mem_waddr
    ,input  logic [ (   8 ) -1 : 0 ]     rf_dir_tok_lim_mem_wdata
    ,input  logic                        rf_dir_tok_lim_mem_rclk
    ,input  logic                        rf_dir_tok_lim_mem_rclk_rst_n
    ,input  logic                        rf_dir_tok_lim_mem_re
    ,input  logic [ (   6 ) -1 : 0 ]     rf_dir_tok_lim_mem_raddr
    ,output logic [ (   8 ) -1 : 0 ]     rf_dir_tok_lim_mem_rdata

    ,input  logic                        rf_dir_tok_lim_mem_isol_en
    ,input  logic                        rf_dir_tok_lim_mem_pwr_enable_b_in
    ,output logic                        rf_dir_tok_lim_mem_pwr_enable_b_out

    ,input  logic                        rf_dp_lsp_enq_dir_rx_sync_fifo_mem_wclk
    ,input  logic                        rf_dp_lsp_enq_dir_rx_sync_fifo_mem_wclk_rst_n
    ,input  logic                        rf_dp_lsp_enq_dir_rx_sync_fifo_mem_we
    ,input  logic [ (   2 ) -1 : 0 ]     rf_dp_lsp_enq_dir_rx_sync_fifo_mem_waddr
    ,input  logic [ (   8 ) -1 : 0 ]     rf_dp_lsp_enq_dir_rx_sync_fifo_mem_wdata
    ,input  logic                        rf_dp_lsp_enq_dir_rx_sync_fifo_mem_rclk
    ,input  logic                        rf_dp_lsp_enq_dir_rx_sync_fifo_mem_rclk_rst_n
    ,input  logic                        rf_dp_lsp_enq_dir_rx_sync_fifo_mem_re
    ,input  logic [ (   2 ) -1 : 0 ]     rf_dp_lsp_enq_dir_rx_sync_fifo_mem_raddr
    ,output logic [ (   8 ) -1 : 0 ]     rf_dp_lsp_enq_dir_rx_sync_fifo_mem_rdata

    ,input  logic                        rf_dp_lsp_enq_dir_rx_sync_fifo_mem_isol_en
    ,input  logic                        rf_dp_lsp_enq_dir_rx_sync_fifo_mem_pwr_enable_b_in
    ,output logic                        rf_dp_lsp_enq_dir_rx_sync_fifo_mem_pwr_enable_b_out

    ,input  logic                        rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_wclk
    ,input  logic                        rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_wclk_rst_n
    ,input  logic                        rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_we
    ,input  logic [ (   2 ) -1 : 0 ]     rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_waddr
    ,input  logic [ (  23 ) -1 : 0 ]     rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_wdata
    ,input  logic                        rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_rclk
    ,input  logic                        rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_rclk_rst_n
    ,input  logic                        rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_re
    ,input  logic [ (   2 ) -1 : 0 ]     rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_raddr
    ,output logic [ (  23 ) -1 : 0 ]     rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_rdata

    ,input  logic                        rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_isol_en
    ,input  logic                        rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_pwr_enable_b_in
    ,output logic                        rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_pwr_enable_b_out

    ,input  logic                        rf_enq_nalb_fifo_mem_wclk
    ,input  logic                        rf_enq_nalb_fifo_mem_wclk_rst_n
    ,input  logic                        rf_enq_nalb_fifo_mem_we
    ,input  logic [ (   2 ) -1 : 0 ]     rf_enq_nalb_fifo_mem_waddr
    ,input  logic [ (  10 ) -1 : 0 ]     rf_enq_nalb_fifo_mem_wdata
    ,input  logic                        rf_enq_nalb_fifo_mem_rclk
    ,input  logic                        rf_enq_nalb_fifo_mem_rclk_rst_n
    ,input  logic                        rf_enq_nalb_fifo_mem_re
    ,input  logic [ (   2 ) -1 : 0 ]     rf_enq_nalb_fifo_mem_raddr
    ,output logic [ (  10 ) -1 : 0 ]     rf_enq_nalb_fifo_mem_rdata

    ,input  logic                        rf_enq_nalb_fifo_mem_isol_en
    ,input  logic                        rf_enq_nalb_fifo_mem_pwr_enable_b_in
    ,output logic                        rf_enq_nalb_fifo_mem_pwr_enable_b_out

    ,input  logic                        rf_fid2cqqidix_wclk
    ,input  logic                        rf_fid2cqqidix_wclk_rst_n
    ,input  logic                        rf_fid2cqqidix_we
    ,input  logic [ (  11 ) -1 : 0 ]     rf_fid2cqqidix_waddr
    ,input  logic [ (  12 ) -1 : 0 ]     rf_fid2cqqidix_wdata
    ,input  logic                        rf_fid2cqqidix_rclk
    ,input  logic                        rf_fid2cqqidix_rclk_rst_n
    ,input  logic                        rf_fid2cqqidix_re
    ,input  logic [ (  11 ) -1 : 0 ]     rf_fid2cqqidix_raddr
    ,output logic [ (  12 ) -1 : 0 ]     rf_fid2cqqidix_rdata

    ,input  logic                        rf_fid2cqqidix_isol_en
    ,input  logic                        rf_fid2cqqidix_pwr_enable_b_in
    ,output logic                        rf_fid2cqqidix_pwr_enable_b_out

    ,input  logic                        rf_ldb_token_rtn_fifo_mem_wclk
    ,input  logic                        rf_ldb_token_rtn_fifo_mem_wclk_rst_n
    ,input  logic                        rf_ldb_token_rtn_fifo_mem_we
    ,input  logic [ (   3 ) -1 : 0 ]     rf_ldb_token_rtn_fifo_mem_waddr
    ,input  logic [ (  25 ) -1 : 0 ]     rf_ldb_token_rtn_fifo_mem_wdata
    ,input  logic                        rf_ldb_token_rtn_fifo_mem_rclk
    ,input  logic                        rf_ldb_token_rtn_fifo_mem_rclk_rst_n
    ,input  logic                        rf_ldb_token_rtn_fifo_mem_re
    ,input  logic [ (   3 ) -1 : 0 ]     rf_ldb_token_rtn_fifo_mem_raddr
    ,output logic [ (  25 ) -1 : 0 ]     rf_ldb_token_rtn_fifo_mem_rdata

    ,input  logic                        rf_ldb_token_rtn_fifo_mem_isol_en
    ,input  logic                        rf_ldb_token_rtn_fifo_mem_pwr_enable_b_in
    ,output logic                        rf_ldb_token_rtn_fifo_mem_pwr_enable_b_out

    ,input  logic                        rf_ll_enq_cnt_r_bin0_dup0_wclk
    ,input  logic                        rf_ll_enq_cnt_r_bin0_dup0_wclk_rst_n
    ,input  logic                        rf_ll_enq_cnt_r_bin0_dup0_we
    ,input  logic [ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin0_dup0_waddr
    ,input  logic [ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin0_dup0_wdata
    ,input  logic                        rf_ll_enq_cnt_r_bin0_dup0_rclk
    ,input  logic                        rf_ll_enq_cnt_r_bin0_dup0_rclk_rst_n
    ,input  logic                        rf_ll_enq_cnt_r_bin0_dup0_re
    ,input  logic [ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin0_dup0_raddr
    ,output logic [ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin0_dup0_rdata

    ,input  logic                        rf_ll_enq_cnt_r_bin0_dup0_isol_en
    ,input  logic                        rf_ll_enq_cnt_r_bin0_dup0_pwr_enable_b_in
    ,output logic                        rf_ll_enq_cnt_r_bin0_dup0_pwr_enable_b_out

    ,input  logic                        rf_ll_enq_cnt_r_bin0_dup1_wclk
    ,input  logic                        rf_ll_enq_cnt_r_bin0_dup1_wclk_rst_n
    ,input  logic                        rf_ll_enq_cnt_r_bin0_dup1_we
    ,input  logic [ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin0_dup1_waddr
    ,input  logic [ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin0_dup1_wdata
    ,input  logic                        rf_ll_enq_cnt_r_bin0_dup1_rclk
    ,input  logic                        rf_ll_enq_cnt_r_bin0_dup1_rclk_rst_n
    ,input  logic                        rf_ll_enq_cnt_r_bin0_dup1_re
    ,input  logic [ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin0_dup1_raddr
    ,output logic [ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin0_dup1_rdata

    ,input  logic                        rf_ll_enq_cnt_r_bin0_dup1_isol_en
    ,input  logic                        rf_ll_enq_cnt_r_bin0_dup1_pwr_enable_b_in
    ,output logic                        rf_ll_enq_cnt_r_bin0_dup1_pwr_enable_b_out

    ,input  logic                        rf_ll_enq_cnt_r_bin0_dup2_wclk
    ,input  logic                        rf_ll_enq_cnt_r_bin0_dup2_wclk_rst_n
    ,input  logic                        rf_ll_enq_cnt_r_bin0_dup2_we
    ,input  logic [ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin0_dup2_waddr
    ,input  logic [ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin0_dup2_wdata
    ,input  logic                        rf_ll_enq_cnt_r_bin0_dup2_rclk
    ,input  logic                        rf_ll_enq_cnt_r_bin0_dup2_rclk_rst_n
    ,input  logic                        rf_ll_enq_cnt_r_bin0_dup2_re
    ,input  logic [ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin0_dup2_raddr
    ,output logic [ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin0_dup2_rdata

    ,input  logic                        rf_ll_enq_cnt_r_bin0_dup2_isol_en
    ,input  logic                        rf_ll_enq_cnt_r_bin0_dup2_pwr_enable_b_in
    ,output logic                        rf_ll_enq_cnt_r_bin0_dup2_pwr_enable_b_out

    ,input  logic                        rf_ll_enq_cnt_r_bin0_dup3_wclk
    ,input  logic                        rf_ll_enq_cnt_r_bin0_dup3_wclk_rst_n
    ,input  logic                        rf_ll_enq_cnt_r_bin0_dup3_we
    ,input  logic [ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin0_dup3_waddr
    ,input  logic [ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin0_dup3_wdata
    ,input  logic                        rf_ll_enq_cnt_r_bin0_dup3_rclk
    ,input  logic                        rf_ll_enq_cnt_r_bin0_dup3_rclk_rst_n
    ,input  logic                        rf_ll_enq_cnt_r_bin0_dup3_re
    ,input  logic [ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin0_dup3_raddr
    ,output logic [ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin0_dup3_rdata

    ,input  logic                        rf_ll_enq_cnt_r_bin0_dup3_isol_en
    ,input  logic                        rf_ll_enq_cnt_r_bin0_dup3_pwr_enable_b_in
    ,output logic                        rf_ll_enq_cnt_r_bin0_dup3_pwr_enable_b_out

    ,input  logic                        rf_ll_enq_cnt_r_bin1_dup0_wclk
    ,input  logic                        rf_ll_enq_cnt_r_bin1_dup0_wclk_rst_n
    ,input  logic                        rf_ll_enq_cnt_r_bin1_dup0_we
    ,input  logic [ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin1_dup0_waddr
    ,input  logic [ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin1_dup0_wdata
    ,input  logic                        rf_ll_enq_cnt_r_bin1_dup0_rclk
    ,input  logic                        rf_ll_enq_cnt_r_bin1_dup0_rclk_rst_n
    ,input  logic                        rf_ll_enq_cnt_r_bin1_dup0_re
    ,input  logic [ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin1_dup0_raddr
    ,output logic [ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin1_dup0_rdata

    ,input  logic                        rf_ll_enq_cnt_r_bin1_dup0_isol_en
    ,input  logic                        rf_ll_enq_cnt_r_bin1_dup0_pwr_enable_b_in
    ,output logic                        rf_ll_enq_cnt_r_bin1_dup0_pwr_enable_b_out

    ,input  logic                        rf_ll_enq_cnt_r_bin1_dup1_wclk
    ,input  logic                        rf_ll_enq_cnt_r_bin1_dup1_wclk_rst_n
    ,input  logic                        rf_ll_enq_cnt_r_bin1_dup1_we
    ,input  logic [ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin1_dup1_waddr
    ,input  logic [ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin1_dup1_wdata
    ,input  logic                        rf_ll_enq_cnt_r_bin1_dup1_rclk
    ,input  logic                        rf_ll_enq_cnt_r_bin1_dup1_rclk_rst_n
    ,input  logic                        rf_ll_enq_cnt_r_bin1_dup1_re
    ,input  logic [ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin1_dup1_raddr
    ,output logic [ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin1_dup1_rdata

    ,input  logic                        rf_ll_enq_cnt_r_bin1_dup1_isol_en
    ,input  logic                        rf_ll_enq_cnt_r_bin1_dup1_pwr_enable_b_in
    ,output logic                        rf_ll_enq_cnt_r_bin1_dup1_pwr_enable_b_out

    ,input  logic                        rf_ll_enq_cnt_r_bin1_dup2_wclk
    ,input  logic                        rf_ll_enq_cnt_r_bin1_dup2_wclk_rst_n
    ,input  logic                        rf_ll_enq_cnt_r_bin1_dup2_we
    ,input  logic [ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin1_dup2_waddr
    ,input  logic [ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin1_dup2_wdata
    ,input  logic                        rf_ll_enq_cnt_r_bin1_dup2_rclk
    ,input  logic                        rf_ll_enq_cnt_r_bin1_dup2_rclk_rst_n
    ,input  logic                        rf_ll_enq_cnt_r_bin1_dup2_re
    ,input  logic [ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin1_dup2_raddr
    ,output logic [ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin1_dup2_rdata

    ,input  logic                        rf_ll_enq_cnt_r_bin1_dup2_isol_en
    ,input  logic                        rf_ll_enq_cnt_r_bin1_dup2_pwr_enable_b_in
    ,output logic                        rf_ll_enq_cnt_r_bin1_dup2_pwr_enable_b_out

    ,input  logic                        rf_ll_enq_cnt_r_bin1_dup3_wclk
    ,input  logic                        rf_ll_enq_cnt_r_bin1_dup3_wclk_rst_n
    ,input  logic                        rf_ll_enq_cnt_r_bin1_dup3_we
    ,input  logic [ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin1_dup3_waddr
    ,input  logic [ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin1_dup3_wdata
    ,input  logic                        rf_ll_enq_cnt_r_bin1_dup3_rclk
    ,input  logic                        rf_ll_enq_cnt_r_bin1_dup3_rclk_rst_n
    ,input  logic                        rf_ll_enq_cnt_r_bin1_dup3_re
    ,input  logic [ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin1_dup3_raddr
    ,output logic [ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin1_dup3_rdata

    ,input  logic                        rf_ll_enq_cnt_r_bin1_dup3_isol_en
    ,input  logic                        rf_ll_enq_cnt_r_bin1_dup3_pwr_enable_b_in
    ,output logic                        rf_ll_enq_cnt_r_bin1_dup3_pwr_enable_b_out

    ,input  logic                        rf_ll_enq_cnt_r_bin2_dup0_wclk
    ,input  logic                        rf_ll_enq_cnt_r_bin2_dup0_wclk_rst_n
    ,input  logic                        rf_ll_enq_cnt_r_bin2_dup0_we
    ,input  logic [ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin2_dup0_waddr
    ,input  logic [ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin2_dup0_wdata
    ,input  logic                        rf_ll_enq_cnt_r_bin2_dup0_rclk
    ,input  logic                        rf_ll_enq_cnt_r_bin2_dup0_rclk_rst_n
    ,input  logic                        rf_ll_enq_cnt_r_bin2_dup0_re
    ,input  logic [ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin2_dup0_raddr
    ,output logic [ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin2_dup0_rdata

    ,input  logic                        rf_ll_enq_cnt_r_bin2_dup0_isol_en
    ,input  logic                        rf_ll_enq_cnt_r_bin2_dup0_pwr_enable_b_in
    ,output logic                        rf_ll_enq_cnt_r_bin2_dup0_pwr_enable_b_out

    ,input  logic                        rf_ll_enq_cnt_r_bin2_dup1_wclk
    ,input  logic                        rf_ll_enq_cnt_r_bin2_dup1_wclk_rst_n
    ,input  logic                        rf_ll_enq_cnt_r_bin2_dup1_we
    ,input  logic [ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin2_dup1_waddr
    ,input  logic [ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin2_dup1_wdata
    ,input  logic                        rf_ll_enq_cnt_r_bin2_dup1_rclk
    ,input  logic                        rf_ll_enq_cnt_r_bin2_dup1_rclk_rst_n
    ,input  logic                        rf_ll_enq_cnt_r_bin2_dup1_re
    ,input  logic [ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin2_dup1_raddr
    ,output logic [ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin2_dup1_rdata

    ,input  logic                        rf_ll_enq_cnt_r_bin2_dup1_isol_en
    ,input  logic                        rf_ll_enq_cnt_r_bin2_dup1_pwr_enable_b_in
    ,output logic                        rf_ll_enq_cnt_r_bin2_dup1_pwr_enable_b_out

    ,input  logic                        rf_ll_enq_cnt_r_bin2_dup2_wclk
    ,input  logic                        rf_ll_enq_cnt_r_bin2_dup2_wclk_rst_n
    ,input  logic                        rf_ll_enq_cnt_r_bin2_dup2_we
    ,input  logic [ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin2_dup2_waddr
    ,input  logic [ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin2_dup2_wdata
    ,input  logic                        rf_ll_enq_cnt_r_bin2_dup2_rclk
    ,input  logic                        rf_ll_enq_cnt_r_bin2_dup2_rclk_rst_n
    ,input  logic                        rf_ll_enq_cnt_r_bin2_dup2_re
    ,input  logic [ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin2_dup2_raddr
    ,output logic [ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin2_dup2_rdata

    ,input  logic                        rf_ll_enq_cnt_r_bin2_dup2_isol_en
    ,input  logic                        rf_ll_enq_cnt_r_bin2_dup2_pwr_enable_b_in
    ,output logic                        rf_ll_enq_cnt_r_bin2_dup2_pwr_enable_b_out

    ,input  logic                        rf_ll_enq_cnt_r_bin2_dup3_wclk
    ,input  logic                        rf_ll_enq_cnt_r_bin2_dup3_wclk_rst_n
    ,input  logic                        rf_ll_enq_cnt_r_bin2_dup3_we
    ,input  logic [ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin2_dup3_waddr
    ,input  logic [ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin2_dup3_wdata
    ,input  logic                        rf_ll_enq_cnt_r_bin2_dup3_rclk
    ,input  logic                        rf_ll_enq_cnt_r_bin2_dup3_rclk_rst_n
    ,input  logic                        rf_ll_enq_cnt_r_bin2_dup3_re
    ,input  logic [ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin2_dup3_raddr
    ,output logic [ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin2_dup3_rdata

    ,input  logic                        rf_ll_enq_cnt_r_bin2_dup3_isol_en
    ,input  logic                        rf_ll_enq_cnt_r_bin2_dup3_pwr_enable_b_in
    ,output logic                        rf_ll_enq_cnt_r_bin2_dup3_pwr_enable_b_out

    ,input  logic                        rf_ll_enq_cnt_r_bin3_dup0_wclk
    ,input  logic                        rf_ll_enq_cnt_r_bin3_dup0_wclk_rst_n
    ,input  logic                        rf_ll_enq_cnt_r_bin3_dup0_we
    ,input  logic [ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin3_dup0_waddr
    ,input  logic [ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin3_dup0_wdata
    ,input  logic                        rf_ll_enq_cnt_r_bin3_dup0_rclk
    ,input  logic                        rf_ll_enq_cnt_r_bin3_dup0_rclk_rst_n
    ,input  logic                        rf_ll_enq_cnt_r_bin3_dup0_re
    ,input  logic [ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin3_dup0_raddr
    ,output logic [ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin3_dup0_rdata

    ,input  logic                        rf_ll_enq_cnt_r_bin3_dup0_isol_en
    ,input  logic                        rf_ll_enq_cnt_r_bin3_dup0_pwr_enable_b_in
    ,output logic                        rf_ll_enq_cnt_r_bin3_dup0_pwr_enable_b_out

    ,input  logic                        rf_ll_enq_cnt_r_bin3_dup1_wclk
    ,input  logic                        rf_ll_enq_cnt_r_bin3_dup1_wclk_rst_n
    ,input  logic                        rf_ll_enq_cnt_r_bin3_dup1_we
    ,input  logic [ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin3_dup1_waddr
    ,input  logic [ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin3_dup1_wdata
    ,input  logic                        rf_ll_enq_cnt_r_bin3_dup1_rclk
    ,input  logic                        rf_ll_enq_cnt_r_bin3_dup1_rclk_rst_n
    ,input  logic                        rf_ll_enq_cnt_r_bin3_dup1_re
    ,input  logic [ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin3_dup1_raddr
    ,output logic [ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin3_dup1_rdata

    ,input  logic                        rf_ll_enq_cnt_r_bin3_dup1_isol_en
    ,input  logic                        rf_ll_enq_cnt_r_bin3_dup1_pwr_enable_b_in
    ,output logic                        rf_ll_enq_cnt_r_bin3_dup1_pwr_enable_b_out

    ,input  logic                        rf_ll_enq_cnt_r_bin3_dup2_wclk
    ,input  logic                        rf_ll_enq_cnt_r_bin3_dup2_wclk_rst_n
    ,input  logic                        rf_ll_enq_cnt_r_bin3_dup2_we
    ,input  logic [ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin3_dup2_waddr
    ,input  logic [ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin3_dup2_wdata
    ,input  logic                        rf_ll_enq_cnt_r_bin3_dup2_rclk
    ,input  logic                        rf_ll_enq_cnt_r_bin3_dup2_rclk_rst_n
    ,input  logic                        rf_ll_enq_cnt_r_bin3_dup2_re
    ,input  logic [ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin3_dup2_raddr
    ,output logic [ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin3_dup2_rdata

    ,input  logic                        rf_ll_enq_cnt_r_bin3_dup2_isol_en
    ,input  logic                        rf_ll_enq_cnt_r_bin3_dup2_pwr_enable_b_in
    ,output logic                        rf_ll_enq_cnt_r_bin3_dup2_pwr_enable_b_out

    ,input  logic                        rf_ll_enq_cnt_r_bin3_dup3_wclk
    ,input  logic                        rf_ll_enq_cnt_r_bin3_dup3_wclk_rst_n
    ,input  logic                        rf_ll_enq_cnt_r_bin3_dup3_we
    ,input  logic [ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin3_dup3_waddr
    ,input  logic [ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin3_dup3_wdata
    ,input  logic                        rf_ll_enq_cnt_r_bin3_dup3_rclk
    ,input  logic                        rf_ll_enq_cnt_r_bin3_dup3_rclk_rst_n
    ,input  logic                        rf_ll_enq_cnt_r_bin3_dup3_re
    ,input  logic [ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin3_dup3_raddr
    ,output logic [ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin3_dup3_rdata

    ,input  logic                        rf_ll_enq_cnt_r_bin3_dup3_isol_en
    ,input  logic                        rf_ll_enq_cnt_r_bin3_dup3_pwr_enable_b_in
    ,output logic                        rf_ll_enq_cnt_r_bin3_dup3_pwr_enable_b_out

    ,input  logic                        rf_ll_enq_cnt_s_bin0_wclk
    ,input  logic                        rf_ll_enq_cnt_s_bin0_wclk_rst_n
    ,input  logic                        rf_ll_enq_cnt_s_bin0_we
    ,input  logic [ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_s_bin0_waddr
    ,input  logic [ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_s_bin0_wdata
    ,input  logic                        rf_ll_enq_cnt_s_bin0_rclk
    ,input  logic                        rf_ll_enq_cnt_s_bin0_rclk_rst_n
    ,input  logic                        rf_ll_enq_cnt_s_bin0_re
    ,input  logic [ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_s_bin0_raddr
    ,output logic [ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_s_bin0_rdata

    ,input  logic                        rf_ll_enq_cnt_s_bin0_isol_en
    ,input  logic                        rf_ll_enq_cnt_s_bin0_pwr_enable_b_in
    ,output logic                        rf_ll_enq_cnt_s_bin0_pwr_enable_b_out

    ,input  logic                        rf_ll_enq_cnt_s_bin1_wclk
    ,input  logic                        rf_ll_enq_cnt_s_bin1_wclk_rst_n
    ,input  logic                        rf_ll_enq_cnt_s_bin1_we
    ,input  logic [ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_s_bin1_waddr
    ,input  logic [ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_s_bin1_wdata
    ,input  logic                        rf_ll_enq_cnt_s_bin1_rclk
    ,input  logic                        rf_ll_enq_cnt_s_bin1_rclk_rst_n
    ,input  logic                        rf_ll_enq_cnt_s_bin1_re
    ,input  logic [ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_s_bin1_raddr
    ,output logic [ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_s_bin1_rdata

    ,input  logic                        rf_ll_enq_cnt_s_bin1_isol_en
    ,input  logic                        rf_ll_enq_cnt_s_bin1_pwr_enable_b_in
    ,output logic                        rf_ll_enq_cnt_s_bin1_pwr_enable_b_out

    ,input  logic                        rf_ll_enq_cnt_s_bin2_wclk
    ,input  logic                        rf_ll_enq_cnt_s_bin2_wclk_rst_n
    ,input  logic                        rf_ll_enq_cnt_s_bin2_we
    ,input  logic [ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_s_bin2_waddr
    ,input  logic [ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_s_bin2_wdata
    ,input  logic                        rf_ll_enq_cnt_s_bin2_rclk
    ,input  logic                        rf_ll_enq_cnt_s_bin2_rclk_rst_n
    ,input  logic                        rf_ll_enq_cnt_s_bin2_re
    ,input  logic [ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_s_bin2_raddr
    ,output logic [ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_s_bin2_rdata

    ,input  logic                        rf_ll_enq_cnt_s_bin2_isol_en
    ,input  logic                        rf_ll_enq_cnt_s_bin2_pwr_enable_b_in
    ,output logic                        rf_ll_enq_cnt_s_bin2_pwr_enable_b_out

    ,input  logic                        rf_ll_enq_cnt_s_bin3_wclk
    ,input  logic                        rf_ll_enq_cnt_s_bin3_wclk_rst_n
    ,input  logic                        rf_ll_enq_cnt_s_bin3_we
    ,input  logic [ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_s_bin3_waddr
    ,input  logic [ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_s_bin3_wdata
    ,input  logic                        rf_ll_enq_cnt_s_bin3_rclk
    ,input  logic                        rf_ll_enq_cnt_s_bin3_rclk_rst_n
    ,input  logic                        rf_ll_enq_cnt_s_bin3_re
    ,input  logic [ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_s_bin3_raddr
    ,output logic [ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_s_bin3_rdata

    ,input  logic                        rf_ll_enq_cnt_s_bin3_isol_en
    ,input  logic                        rf_ll_enq_cnt_s_bin3_pwr_enable_b_in
    ,output logic                        rf_ll_enq_cnt_s_bin3_pwr_enable_b_out

    ,input  logic                        rf_ll_rdylst_hp_bin0_wclk
    ,input  logic                        rf_ll_rdylst_hp_bin0_wclk_rst_n
    ,input  logic                        rf_ll_rdylst_hp_bin0_we
    ,input  logic [ (   5 ) -1 : 0 ]     rf_ll_rdylst_hp_bin0_waddr
    ,input  logic [ (  14 ) -1 : 0 ]     rf_ll_rdylst_hp_bin0_wdata
    ,input  logic                        rf_ll_rdylst_hp_bin0_rclk
    ,input  logic                        rf_ll_rdylst_hp_bin0_rclk_rst_n
    ,input  logic                        rf_ll_rdylst_hp_bin0_re
    ,input  logic [ (   5 ) -1 : 0 ]     rf_ll_rdylst_hp_bin0_raddr
    ,output logic [ (  14 ) -1 : 0 ]     rf_ll_rdylst_hp_bin0_rdata

    ,input  logic                        rf_ll_rdylst_hp_bin0_isol_en
    ,input  logic                        rf_ll_rdylst_hp_bin0_pwr_enable_b_in
    ,output logic                        rf_ll_rdylst_hp_bin0_pwr_enable_b_out

    ,input  logic                        rf_ll_rdylst_hp_bin1_wclk
    ,input  logic                        rf_ll_rdylst_hp_bin1_wclk_rst_n
    ,input  logic                        rf_ll_rdylst_hp_bin1_we
    ,input  logic [ (   5 ) -1 : 0 ]     rf_ll_rdylst_hp_bin1_waddr
    ,input  logic [ (  14 ) -1 : 0 ]     rf_ll_rdylst_hp_bin1_wdata
    ,input  logic                        rf_ll_rdylst_hp_bin1_rclk
    ,input  logic                        rf_ll_rdylst_hp_bin1_rclk_rst_n
    ,input  logic                        rf_ll_rdylst_hp_bin1_re
    ,input  logic [ (   5 ) -1 : 0 ]     rf_ll_rdylst_hp_bin1_raddr
    ,output logic [ (  14 ) -1 : 0 ]     rf_ll_rdylst_hp_bin1_rdata

    ,input  logic                        rf_ll_rdylst_hp_bin1_isol_en
    ,input  logic                        rf_ll_rdylst_hp_bin1_pwr_enable_b_in
    ,output logic                        rf_ll_rdylst_hp_bin1_pwr_enable_b_out

    ,input  logic                        rf_ll_rdylst_hp_bin2_wclk
    ,input  logic                        rf_ll_rdylst_hp_bin2_wclk_rst_n
    ,input  logic                        rf_ll_rdylst_hp_bin2_we
    ,input  logic [ (   5 ) -1 : 0 ]     rf_ll_rdylst_hp_bin2_waddr
    ,input  logic [ (  14 ) -1 : 0 ]     rf_ll_rdylst_hp_bin2_wdata
    ,input  logic                        rf_ll_rdylst_hp_bin2_rclk
    ,input  logic                        rf_ll_rdylst_hp_bin2_rclk_rst_n
    ,input  logic                        rf_ll_rdylst_hp_bin2_re
    ,input  logic [ (   5 ) -1 : 0 ]     rf_ll_rdylst_hp_bin2_raddr
    ,output logic [ (  14 ) -1 : 0 ]     rf_ll_rdylst_hp_bin2_rdata

    ,input  logic                        rf_ll_rdylst_hp_bin2_isol_en
    ,input  logic                        rf_ll_rdylst_hp_bin2_pwr_enable_b_in
    ,output logic                        rf_ll_rdylst_hp_bin2_pwr_enable_b_out

    ,input  logic                        rf_ll_rdylst_hp_bin3_wclk
    ,input  logic                        rf_ll_rdylst_hp_bin3_wclk_rst_n
    ,input  logic                        rf_ll_rdylst_hp_bin3_we
    ,input  logic [ (   5 ) -1 : 0 ]     rf_ll_rdylst_hp_bin3_waddr
    ,input  logic [ (  14 ) -1 : 0 ]     rf_ll_rdylst_hp_bin3_wdata
    ,input  logic                        rf_ll_rdylst_hp_bin3_rclk
    ,input  logic                        rf_ll_rdylst_hp_bin3_rclk_rst_n
    ,input  logic                        rf_ll_rdylst_hp_bin3_re
    ,input  logic [ (   5 ) -1 : 0 ]     rf_ll_rdylst_hp_bin3_raddr
    ,output logic [ (  14 ) -1 : 0 ]     rf_ll_rdylst_hp_bin3_rdata

    ,input  logic                        rf_ll_rdylst_hp_bin3_isol_en
    ,input  logic                        rf_ll_rdylst_hp_bin3_pwr_enable_b_in
    ,output logic                        rf_ll_rdylst_hp_bin3_pwr_enable_b_out

    ,input  logic                        rf_ll_rdylst_hpnxt_bin0_wclk
    ,input  logic                        rf_ll_rdylst_hpnxt_bin0_wclk_rst_n
    ,input  logic                        rf_ll_rdylst_hpnxt_bin0_we
    ,input  logic [ (  11 ) -1 : 0 ]     rf_ll_rdylst_hpnxt_bin0_waddr
    ,input  logic [ (  16 ) -1 : 0 ]     rf_ll_rdylst_hpnxt_bin0_wdata
    ,input  logic                        rf_ll_rdylst_hpnxt_bin0_rclk
    ,input  logic                        rf_ll_rdylst_hpnxt_bin0_rclk_rst_n
    ,input  logic                        rf_ll_rdylst_hpnxt_bin0_re
    ,input  logic [ (  11 ) -1 : 0 ]     rf_ll_rdylst_hpnxt_bin0_raddr
    ,output logic [ (  16 ) -1 : 0 ]     rf_ll_rdylst_hpnxt_bin0_rdata

    ,input  logic                        rf_ll_rdylst_hpnxt_bin0_isol_en
    ,input  logic                        rf_ll_rdylst_hpnxt_bin0_pwr_enable_b_in
    ,output logic                        rf_ll_rdylst_hpnxt_bin0_pwr_enable_b_out

    ,input  logic                        rf_ll_rdylst_hpnxt_bin1_wclk
    ,input  logic                        rf_ll_rdylst_hpnxt_bin1_wclk_rst_n
    ,input  logic                        rf_ll_rdylst_hpnxt_bin1_we
    ,input  logic [ (  11 ) -1 : 0 ]     rf_ll_rdylst_hpnxt_bin1_waddr
    ,input  logic [ (  16 ) -1 : 0 ]     rf_ll_rdylst_hpnxt_bin1_wdata
    ,input  logic                        rf_ll_rdylst_hpnxt_bin1_rclk
    ,input  logic                        rf_ll_rdylst_hpnxt_bin1_rclk_rst_n
    ,input  logic                        rf_ll_rdylst_hpnxt_bin1_re
    ,input  logic [ (  11 ) -1 : 0 ]     rf_ll_rdylst_hpnxt_bin1_raddr
    ,output logic [ (  16 ) -1 : 0 ]     rf_ll_rdylst_hpnxt_bin1_rdata

    ,input  logic                        rf_ll_rdylst_hpnxt_bin1_isol_en
    ,input  logic                        rf_ll_rdylst_hpnxt_bin1_pwr_enable_b_in
    ,output logic                        rf_ll_rdylst_hpnxt_bin1_pwr_enable_b_out

    ,input  logic                        rf_ll_rdylst_hpnxt_bin2_wclk
    ,input  logic                        rf_ll_rdylst_hpnxt_bin2_wclk_rst_n
    ,input  logic                        rf_ll_rdylst_hpnxt_bin2_we
    ,input  logic [ (  11 ) -1 : 0 ]     rf_ll_rdylst_hpnxt_bin2_waddr
    ,input  logic [ (  16 ) -1 : 0 ]     rf_ll_rdylst_hpnxt_bin2_wdata
    ,input  logic                        rf_ll_rdylst_hpnxt_bin2_rclk
    ,input  logic                        rf_ll_rdylst_hpnxt_bin2_rclk_rst_n
    ,input  logic                        rf_ll_rdylst_hpnxt_bin2_re
    ,input  logic [ (  11 ) -1 : 0 ]     rf_ll_rdylst_hpnxt_bin2_raddr
    ,output logic [ (  16 ) -1 : 0 ]     rf_ll_rdylst_hpnxt_bin2_rdata

    ,input  logic                        rf_ll_rdylst_hpnxt_bin2_isol_en
    ,input  logic                        rf_ll_rdylst_hpnxt_bin2_pwr_enable_b_in
    ,output logic                        rf_ll_rdylst_hpnxt_bin2_pwr_enable_b_out

    ,input  logic                        rf_ll_rdylst_hpnxt_bin3_wclk
    ,input  logic                        rf_ll_rdylst_hpnxt_bin3_wclk_rst_n
    ,input  logic                        rf_ll_rdylst_hpnxt_bin3_we
    ,input  logic [ (  11 ) -1 : 0 ]     rf_ll_rdylst_hpnxt_bin3_waddr
    ,input  logic [ (  16 ) -1 : 0 ]     rf_ll_rdylst_hpnxt_bin3_wdata
    ,input  logic                        rf_ll_rdylst_hpnxt_bin3_rclk
    ,input  logic                        rf_ll_rdylst_hpnxt_bin3_rclk_rst_n
    ,input  logic                        rf_ll_rdylst_hpnxt_bin3_re
    ,input  logic [ (  11 ) -1 : 0 ]     rf_ll_rdylst_hpnxt_bin3_raddr
    ,output logic [ (  16 ) -1 : 0 ]     rf_ll_rdylst_hpnxt_bin3_rdata

    ,input  logic                        rf_ll_rdylst_hpnxt_bin3_isol_en
    ,input  logic                        rf_ll_rdylst_hpnxt_bin3_pwr_enable_b_in
    ,output logic                        rf_ll_rdylst_hpnxt_bin3_pwr_enable_b_out

    ,input  logic                        rf_ll_rdylst_tp_bin0_wclk
    ,input  logic                        rf_ll_rdylst_tp_bin0_wclk_rst_n
    ,input  logic                        rf_ll_rdylst_tp_bin0_we
    ,input  logic [ (   5 ) -1 : 0 ]     rf_ll_rdylst_tp_bin0_waddr
    ,input  logic [ (  14 ) -1 : 0 ]     rf_ll_rdylst_tp_bin0_wdata
    ,input  logic                        rf_ll_rdylst_tp_bin0_rclk
    ,input  logic                        rf_ll_rdylst_tp_bin0_rclk_rst_n
    ,input  logic                        rf_ll_rdylst_tp_bin0_re
    ,input  logic [ (   5 ) -1 : 0 ]     rf_ll_rdylst_tp_bin0_raddr
    ,output logic [ (  14 ) -1 : 0 ]     rf_ll_rdylst_tp_bin0_rdata

    ,input  logic                        rf_ll_rdylst_tp_bin0_isol_en
    ,input  logic                        rf_ll_rdylst_tp_bin0_pwr_enable_b_in
    ,output logic                        rf_ll_rdylst_tp_bin0_pwr_enable_b_out

    ,input  logic                        rf_ll_rdylst_tp_bin1_wclk
    ,input  logic                        rf_ll_rdylst_tp_bin1_wclk_rst_n
    ,input  logic                        rf_ll_rdylst_tp_bin1_we
    ,input  logic [ (   5 ) -1 : 0 ]     rf_ll_rdylst_tp_bin1_waddr
    ,input  logic [ (  14 ) -1 : 0 ]     rf_ll_rdylst_tp_bin1_wdata
    ,input  logic                        rf_ll_rdylst_tp_bin1_rclk
    ,input  logic                        rf_ll_rdylst_tp_bin1_rclk_rst_n
    ,input  logic                        rf_ll_rdylst_tp_bin1_re
    ,input  logic [ (   5 ) -1 : 0 ]     rf_ll_rdylst_tp_bin1_raddr
    ,output logic [ (  14 ) -1 : 0 ]     rf_ll_rdylst_tp_bin1_rdata

    ,input  logic                        rf_ll_rdylst_tp_bin1_isol_en
    ,input  logic                        rf_ll_rdylst_tp_bin1_pwr_enable_b_in
    ,output logic                        rf_ll_rdylst_tp_bin1_pwr_enable_b_out

    ,input  logic                        rf_ll_rdylst_tp_bin2_wclk
    ,input  logic                        rf_ll_rdylst_tp_bin2_wclk_rst_n
    ,input  logic                        rf_ll_rdylst_tp_bin2_we
    ,input  logic [ (   5 ) -1 : 0 ]     rf_ll_rdylst_tp_bin2_waddr
    ,input  logic [ (  14 ) -1 : 0 ]     rf_ll_rdylst_tp_bin2_wdata
    ,input  logic                        rf_ll_rdylst_tp_bin2_rclk
    ,input  logic                        rf_ll_rdylst_tp_bin2_rclk_rst_n
    ,input  logic                        rf_ll_rdylst_tp_bin2_re
    ,input  logic [ (   5 ) -1 : 0 ]     rf_ll_rdylst_tp_bin2_raddr
    ,output logic [ (  14 ) -1 : 0 ]     rf_ll_rdylst_tp_bin2_rdata

    ,input  logic                        rf_ll_rdylst_tp_bin2_isol_en
    ,input  logic                        rf_ll_rdylst_tp_bin2_pwr_enable_b_in
    ,output logic                        rf_ll_rdylst_tp_bin2_pwr_enable_b_out

    ,input  logic                        rf_ll_rdylst_tp_bin3_wclk
    ,input  logic                        rf_ll_rdylst_tp_bin3_wclk_rst_n
    ,input  logic                        rf_ll_rdylst_tp_bin3_we
    ,input  logic [ (   5 ) -1 : 0 ]     rf_ll_rdylst_tp_bin3_waddr
    ,input  logic [ (  14 ) -1 : 0 ]     rf_ll_rdylst_tp_bin3_wdata
    ,input  logic                        rf_ll_rdylst_tp_bin3_rclk
    ,input  logic                        rf_ll_rdylst_tp_bin3_rclk_rst_n
    ,input  logic                        rf_ll_rdylst_tp_bin3_re
    ,input  logic [ (   5 ) -1 : 0 ]     rf_ll_rdylst_tp_bin3_raddr
    ,output logic [ (  14 ) -1 : 0 ]     rf_ll_rdylst_tp_bin3_rdata

    ,input  logic                        rf_ll_rdylst_tp_bin3_isol_en
    ,input  logic                        rf_ll_rdylst_tp_bin3_pwr_enable_b_in
    ,output logic                        rf_ll_rdylst_tp_bin3_pwr_enable_b_out

    ,input  logic                        rf_ll_rlst_cnt_wclk
    ,input  logic                        rf_ll_rlst_cnt_wclk_rst_n
    ,input  logic                        rf_ll_rlst_cnt_we
    ,input  logic [ (   5 ) -1 : 0 ]     rf_ll_rlst_cnt_waddr
    ,input  logic [ (  56 ) -1 : 0 ]     rf_ll_rlst_cnt_wdata
    ,input  logic                        rf_ll_rlst_cnt_rclk
    ,input  logic                        rf_ll_rlst_cnt_rclk_rst_n
    ,input  logic                        rf_ll_rlst_cnt_re
    ,input  logic [ (   5 ) -1 : 0 ]     rf_ll_rlst_cnt_raddr
    ,output logic [ (  56 ) -1 : 0 ]     rf_ll_rlst_cnt_rdata

    ,input  logic                        rf_ll_rlst_cnt_isol_en
    ,input  logic                        rf_ll_rlst_cnt_pwr_enable_b_in
    ,output logic                        rf_ll_rlst_cnt_pwr_enable_b_out

    ,input  logic                        rf_ll_sch_cnt_dup0_wclk
    ,input  logic                        rf_ll_sch_cnt_dup0_wclk_rst_n
    ,input  logic                        rf_ll_sch_cnt_dup0_we
    ,input  logic [ (  11 ) -1 : 0 ]     rf_ll_sch_cnt_dup0_waddr
    ,input  logic [ (  17 ) -1 : 0 ]     rf_ll_sch_cnt_dup0_wdata
    ,input  logic                        rf_ll_sch_cnt_dup0_rclk
    ,input  logic                        rf_ll_sch_cnt_dup0_rclk_rst_n
    ,input  logic                        rf_ll_sch_cnt_dup0_re
    ,input  logic [ (  11 ) -1 : 0 ]     rf_ll_sch_cnt_dup0_raddr
    ,output logic [ (  17 ) -1 : 0 ]     rf_ll_sch_cnt_dup0_rdata

    ,input  logic                        rf_ll_sch_cnt_dup0_isol_en
    ,input  logic                        rf_ll_sch_cnt_dup0_pwr_enable_b_in
    ,output logic                        rf_ll_sch_cnt_dup0_pwr_enable_b_out

    ,input  logic                        rf_ll_sch_cnt_dup1_wclk
    ,input  logic                        rf_ll_sch_cnt_dup1_wclk_rst_n
    ,input  logic                        rf_ll_sch_cnt_dup1_we
    ,input  logic [ (  11 ) -1 : 0 ]     rf_ll_sch_cnt_dup1_waddr
    ,input  logic [ (  17 ) -1 : 0 ]     rf_ll_sch_cnt_dup1_wdata
    ,input  logic                        rf_ll_sch_cnt_dup1_rclk
    ,input  logic                        rf_ll_sch_cnt_dup1_rclk_rst_n
    ,input  logic                        rf_ll_sch_cnt_dup1_re
    ,input  logic [ (  11 ) -1 : 0 ]     rf_ll_sch_cnt_dup1_raddr
    ,output logic [ (  17 ) -1 : 0 ]     rf_ll_sch_cnt_dup1_rdata

    ,input  logic                        rf_ll_sch_cnt_dup1_isol_en
    ,input  logic                        rf_ll_sch_cnt_dup1_pwr_enable_b_in
    ,output logic                        rf_ll_sch_cnt_dup1_pwr_enable_b_out

    ,input  logic                        rf_ll_sch_cnt_dup2_wclk
    ,input  logic                        rf_ll_sch_cnt_dup2_wclk_rst_n
    ,input  logic                        rf_ll_sch_cnt_dup2_we
    ,input  logic [ (  11 ) -1 : 0 ]     rf_ll_sch_cnt_dup2_waddr
    ,input  logic [ (  17 ) -1 : 0 ]     rf_ll_sch_cnt_dup2_wdata
    ,input  logic                        rf_ll_sch_cnt_dup2_rclk
    ,input  logic                        rf_ll_sch_cnt_dup2_rclk_rst_n
    ,input  logic                        rf_ll_sch_cnt_dup2_re
    ,input  logic [ (  11 ) -1 : 0 ]     rf_ll_sch_cnt_dup2_raddr
    ,output logic [ (  17 ) -1 : 0 ]     rf_ll_sch_cnt_dup2_rdata

    ,input  logic                        rf_ll_sch_cnt_dup2_isol_en
    ,input  logic                        rf_ll_sch_cnt_dup2_pwr_enable_b_in
    ,output logic                        rf_ll_sch_cnt_dup2_pwr_enable_b_out

    ,input  logic                        rf_ll_sch_cnt_dup3_wclk
    ,input  logic                        rf_ll_sch_cnt_dup3_wclk_rst_n
    ,input  logic                        rf_ll_sch_cnt_dup3_we
    ,input  logic [ (  11 ) -1 : 0 ]     rf_ll_sch_cnt_dup3_waddr
    ,input  logic [ (  17 ) -1 : 0 ]     rf_ll_sch_cnt_dup3_wdata
    ,input  logic                        rf_ll_sch_cnt_dup3_rclk
    ,input  logic                        rf_ll_sch_cnt_dup3_rclk_rst_n
    ,input  logic                        rf_ll_sch_cnt_dup3_re
    ,input  logic [ (  11 ) -1 : 0 ]     rf_ll_sch_cnt_dup3_raddr
    ,output logic [ (  17 ) -1 : 0 ]     rf_ll_sch_cnt_dup3_rdata

    ,input  logic                        rf_ll_sch_cnt_dup3_isol_en
    ,input  logic                        rf_ll_sch_cnt_dup3_pwr_enable_b_in
    ,output logic                        rf_ll_sch_cnt_dup3_pwr_enable_b_out

    ,input  logic                        rf_ll_schlst_hp_bin0_wclk
    ,input  logic                        rf_ll_schlst_hp_bin0_wclk_rst_n
    ,input  logic                        rf_ll_schlst_hp_bin0_we
    ,input  logic [ (   9 ) -1 : 0 ]     rf_ll_schlst_hp_bin0_waddr
    ,input  logic [ (  14 ) -1 : 0 ]     rf_ll_schlst_hp_bin0_wdata
    ,input  logic                        rf_ll_schlst_hp_bin0_rclk
    ,input  logic                        rf_ll_schlst_hp_bin0_rclk_rst_n
    ,input  logic                        rf_ll_schlst_hp_bin0_re
    ,input  logic [ (   9 ) -1 : 0 ]     rf_ll_schlst_hp_bin0_raddr
    ,output logic [ (  14 ) -1 : 0 ]     rf_ll_schlst_hp_bin0_rdata

    ,input  logic                        rf_ll_schlst_hp_bin0_isol_en
    ,input  logic                        rf_ll_schlst_hp_bin0_pwr_enable_b_in
    ,output logic                        rf_ll_schlst_hp_bin0_pwr_enable_b_out

    ,input  logic                        rf_ll_schlst_hp_bin1_wclk
    ,input  logic                        rf_ll_schlst_hp_bin1_wclk_rst_n
    ,input  logic                        rf_ll_schlst_hp_bin1_we
    ,input  logic [ (   9 ) -1 : 0 ]     rf_ll_schlst_hp_bin1_waddr
    ,input  logic [ (  14 ) -1 : 0 ]     rf_ll_schlst_hp_bin1_wdata
    ,input  logic                        rf_ll_schlst_hp_bin1_rclk
    ,input  logic                        rf_ll_schlst_hp_bin1_rclk_rst_n
    ,input  logic                        rf_ll_schlst_hp_bin1_re
    ,input  logic [ (   9 ) -1 : 0 ]     rf_ll_schlst_hp_bin1_raddr
    ,output logic [ (  14 ) -1 : 0 ]     rf_ll_schlst_hp_bin1_rdata

    ,input  logic                        rf_ll_schlst_hp_bin1_isol_en
    ,input  logic                        rf_ll_schlst_hp_bin1_pwr_enable_b_in
    ,output logic                        rf_ll_schlst_hp_bin1_pwr_enable_b_out

    ,input  logic                        rf_ll_schlst_hp_bin2_wclk
    ,input  logic                        rf_ll_schlst_hp_bin2_wclk_rst_n
    ,input  logic                        rf_ll_schlst_hp_bin2_we
    ,input  logic [ (   9 ) -1 : 0 ]     rf_ll_schlst_hp_bin2_waddr
    ,input  logic [ (  14 ) -1 : 0 ]     rf_ll_schlst_hp_bin2_wdata
    ,input  logic                        rf_ll_schlst_hp_bin2_rclk
    ,input  logic                        rf_ll_schlst_hp_bin2_rclk_rst_n
    ,input  logic                        rf_ll_schlst_hp_bin2_re
    ,input  logic [ (   9 ) -1 : 0 ]     rf_ll_schlst_hp_bin2_raddr
    ,output logic [ (  14 ) -1 : 0 ]     rf_ll_schlst_hp_bin2_rdata

    ,input  logic                        rf_ll_schlst_hp_bin2_isol_en
    ,input  logic                        rf_ll_schlst_hp_bin2_pwr_enable_b_in
    ,output logic                        rf_ll_schlst_hp_bin2_pwr_enable_b_out

    ,input  logic                        rf_ll_schlst_hp_bin3_wclk
    ,input  logic                        rf_ll_schlst_hp_bin3_wclk_rst_n
    ,input  logic                        rf_ll_schlst_hp_bin3_we
    ,input  logic [ (   9 ) -1 : 0 ]     rf_ll_schlst_hp_bin3_waddr
    ,input  logic [ (  14 ) -1 : 0 ]     rf_ll_schlst_hp_bin3_wdata
    ,input  logic                        rf_ll_schlst_hp_bin3_rclk
    ,input  logic                        rf_ll_schlst_hp_bin3_rclk_rst_n
    ,input  logic                        rf_ll_schlst_hp_bin3_re
    ,input  logic [ (   9 ) -1 : 0 ]     rf_ll_schlst_hp_bin3_raddr
    ,output logic [ (  14 ) -1 : 0 ]     rf_ll_schlst_hp_bin3_rdata

    ,input  logic                        rf_ll_schlst_hp_bin3_isol_en
    ,input  logic                        rf_ll_schlst_hp_bin3_pwr_enable_b_in
    ,output logic                        rf_ll_schlst_hp_bin3_pwr_enable_b_out

    ,input  logic                        rf_ll_schlst_hpnxt_bin0_wclk
    ,input  logic                        rf_ll_schlst_hpnxt_bin0_wclk_rst_n
    ,input  logic                        rf_ll_schlst_hpnxt_bin0_we
    ,input  logic [ (  11 ) -1 : 0 ]     rf_ll_schlst_hpnxt_bin0_waddr
    ,input  logic [ (  16 ) -1 : 0 ]     rf_ll_schlst_hpnxt_bin0_wdata
    ,input  logic                        rf_ll_schlst_hpnxt_bin0_rclk
    ,input  logic                        rf_ll_schlst_hpnxt_bin0_rclk_rst_n
    ,input  logic                        rf_ll_schlst_hpnxt_bin0_re
    ,input  logic [ (  11 ) -1 : 0 ]     rf_ll_schlst_hpnxt_bin0_raddr
    ,output logic [ (  16 ) -1 : 0 ]     rf_ll_schlst_hpnxt_bin0_rdata

    ,input  logic                        rf_ll_schlst_hpnxt_bin0_isol_en
    ,input  logic                        rf_ll_schlst_hpnxt_bin0_pwr_enable_b_in
    ,output logic                        rf_ll_schlst_hpnxt_bin0_pwr_enable_b_out

    ,input  logic                        rf_ll_schlst_hpnxt_bin1_wclk
    ,input  logic                        rf_ll_schlst_hpnxt_bin1_wclk_rst_n
    ,input  logic                        rf_ll_schlst_hpnxt_bin1_we
    ,input  logic [ (  11 ) -1 : 0 ]     rf_ll_schlst_hpnxt_bin1_waddr
    ,input  logic [ (  16 ) -1 : 0 ]     rf_ll_schlst_hpnxt_bin1_wdata
    ,input  logic                        rf_ll_schlst_hpnxt_bin1_rclk
    ,input  logic                        rf_ll_schlst_hpnxt_bin1_rclk_rst_n
    ,input  logic                        rf_ll_schlst_hpnxt_bin1_re
    ,input  logic [ (  11 ) -1 : 0 ]     rf_ll_schlst_hpnxt_bin1_raddr
    ,output logic [ (  16 ) -1 : 0 ]     rf_ll_schlst_hpnxt_bin1_rdata

    ,input  logic                        rf_ll_schlst_hpnxt_bin1_isol_en
    ,input  logic                        rf_ll_schlst_hpnxt_bin1_pwr_enable_b_in
    ,output logic                        rf_ll_schlst_hpnxt_bin1_pwr_enable_b_out

    ,input  logic                        rf_ll_schlst_hpnxt_bin2_wclk
    ,input  logic                        rf_ll_schlst_hpnxt_bin2_wclk_rst_n
    ,input  logic                        rf_ll_schlst_hpnxt_bin2_we
    ,input  logic [ (  11 ) -1 : 0 ]     rf_ll_schlst_hpnxt_bin2_waddr
    ,input  logic [ (  16 ) -1 : 0 ]     rf_ll_schlst_hpnxt_bin2_wdata
    ,input  logic                        rf_ll_schlst_hpnxt_bin2_rclk
    ,input  logic                        rf_ll_schlst_hpnxt_bin2_rclk_rst_n
    ,input  logic                        rf_ll_schlst_hpnxt_bin2_re
    ,input  logic [ (  11 ) -1 : 0 ]     rf_ll_schlst_hpnxt_bin2_raddr
    ,output logic [ (  16 ) -1 : 0 ]     rf_ll_schlst_hpnxt_bin2_rdata

    ,input  logic                        rf_ll_schlst_hpnxt_bin2_isol_en
    ,input  logic                        rf_ll_schlst_hpnxt_bin2_pwr_enable_b_in
    ,output logic                        rf_ll_schlst_hpnxt_bin2_pwr_enable_b_out

    ,input  logic                        rf_ll_schlst_hpnxt_bin3_wclk
    ,input  logic                        rf_ll_schlst_hpnxt_bin3_wclk_rst_n
    ,input  logic                        rf_ll_schlst_hpnxt_bin3_we
    ,input  logic [ (  11 ) -1 : 0 ]     rf_ll_schlst_hpnxt_bin3_waddr
    ,input  logic [ (  16 ) -1 : 0 ]     rf_ll_schlst_hpnxt_bin3_wdata
    ,input  logic                        rf_ll_schlst_hpnxt_bin3_rclk
    ,input  logic                        rf_ll_schlst_hpnxt_bin3_rclk_rst_n
    ,input  logic                        rf_ll_schlst_hpnxt_bin3_re
    ,input  logic [ (  11 ) -1 : 0 ]     rf_ll_schlst_hpnxt_bin3_raddr
    ,output logic [ (  16 ) -1 : 0 ]     rf_ll_schlst_hpnxt_bin3_rdata

    ,input  logic                        rf_ll_schlst_hpnxt_bin3_isol_en
    ,input  logic                        rf_ll_schlst_hpnxt_bin3_pwr_enable_b_in
    ,output logic                        rf_ll_schlst_hpnxt_bin3_pwr_enable_b_out

    ,input  logic                        rf_ll_schlst_tp_bin0_wclk
    ,input  logic                        rf_ll_schlst_tp_bin0_wclk_rst_n
    ,input  logic                        rf_ll_schlst_tp_bin0_we
    ,input  logic [ (   9 ) -1 : 0 ]     rf_ll_schlst_tp_bin0_waddr
    ,input  logic [ (  14 ) -1 : 0 ]     rf_ll_schlst_tp_bin0_wdata
    ,input  logic                        rf_ll_schlst_tp_bin0_rclk
    ,input  logic                        rf_ll_schlst_tp_bin0_rclk_rst_n
    ,input  logic                        rf_ll_schlst_tp_bin0_re
    ,input  logic [ (   9 ) -1 : 0 ]     rf_ll_schlst_tp_bin0_raddr
    ,output logic [ (  14 ) -1 : 0 ]     rf_ll_schlst_tp_bin0_rdata

    ,input  logic                        rf_ll_schlst_tp_bin0_isol_en
    ,input  logic                        rf_ll_schlst_tp_bin0_pwr_enable_b_in
    ,output logic                        rf_ll_schlst_tp_bin0_pwr_enable_b_out

    ,input  logic                        rf_ll_schlst_tp_bin1_wclk
    ,input  logic                        rf_ll_schlst_tp_bin1_wclk_rst_n
    ,input  logic                        rf_ll_schlst_tp_bin1_we
    ,input  logic [ (   9 ) -1 : 0 ]     rf_ll_schlst_tp_bin1_waddr
    ,input  logic [ (  14 ) -1 : 0 ]     rf_ll_schlst_tp_bin1_wdata
    ,input  logic                        rf_ll_schlst_tp_bin1_rclk
    ,input  logic                        rf_ll_schlst_tp_bin1_rclk_rst_n
    ,input  logic                        rf_ll_schlst_tp_bin1_re
    ,input  logic [ (   9 ) -1 : 0 ]     rf_ll_schlst_tp_bin1_raddr
    ,output logic [ (  14 ) -1 : 0 ]     rf_ll_schlst_tp_bin1_rdata

    ,input  logic                        rf_ll_schlst_tp_bin1_isol_en
    ,input  logic                        rf_ll_schlst_tp_bin1_pwr_enable_b_in
    ,output logic                        rf_ll_schlst_tp_bin1_pwr_enable_b_out

    ,input  logic                        rf_ll_schlst_tp_bin2_wclk
    ,input  logic                        rf_ll_schlst_tp_bin2_wclk_rst_n
    ,input  logic                        rf_ll_schlst_tp_bin2_we
    ,input  logic [ (   9 ) -1 : 0 ]     rf_ll_schlst_tp_bin2_waddr
    ,input  logic [ (  14 ) -1 : 0 ]     rf_ll_schlst_tp_bin2_wdata
    ,input  logic                        rf_ll_schlst_tp_bin2_rclk
    ,input  logic                        rf_ll_schlst_tp_bin2_rclk_rst_n
    ,input  logic                        rf_ll_schlst_tp_bin2_re
    ,input  logic [ (   9 ) -1 : 0 ]     rf_ll_schlst_tp_bin2_raddr
    ,output logic [ (  14 ) -1 : 0 ]     rf_ll_schlst_tp_bin2_rdata

    ,input  logic                        rf_ll_schlst_tp_bin2_isol_en
    ,input  logic                        rf_ll_schlst_tp_bin2_pwr_enable_b_in
    ,output logic                        rf_ll_schlst_tp_bin2_pwr_enable_b_out

    ,input  logic                        rf_ll_schlst_tp_bin3_wclk
    ,input  logic                        rf_ll_schlst_tp_bin3_wclk_rst_n
    ,input  logic                        rf_ll_schlst_tp_bin3_we
    ,input  logic [ (   9 ) -1 : 0 ]     rf_ll_schlst_tp_bin3_waddr
    ,input  logic [ (  14 ) -1 : 0 ]     rf_ll_schlst_tp_bin3_wdata
    ,input  logic                        rf_ll_schlst_tp_bin3_rclk
    ,input  logic                        rf_ll_schlst_tp_bin3_rclk_rst_n
    ,input  logic                        rf_ll_schlst_tp_bin3_re
    ,input  logic [ (   9 ) -1 : 0 ]     rf_ll_schlst_tp_bin3_raddr
    ,output logic [ (  14 ) -1 : 0 ]     rf_ll_schlst_tp_bin3_rdata

    ,input  logic                        rf_ll_schlst_tp_bin3_isol_en
    ,input  logic                        rf_ll_schlst_tp_bin3_pwr_enable_b_in
    ,output logic                        rf_ll_schlst_tp_bin3_pwr_enable_b_out

    ,input  logic                        rf_ll_schlst_tpprv_bin0_wclk
    ,input  logic                        rf_ll_schlst_tpprv_bin0_wclk_rst_n
    ,input  logic                        rf_ll_schlst_tpprv_bin0_we
    ,input  logic [ (  11 ) -1 : 0 ]     rf_ll_schlst_tpprv_bin0_waddr
    ,input  logic [ (  16 ) -1 : 0 ]     rf_ll_schlst_tpprv_bin0_wdata
    ,input  logic                        rf_ll_schlst_tpprv_bin0_rclk
    ,input  logic                        rf_ll_schlst_tpprv_bin0_rclk_rst_n
    ,input  logic                        rf_ll_schlst_tpprv_bin0_re
    ,input  logic [ (  11 ) -1 : 0 ]     rf_ll_schlst_tpprv_bin0_raddr
    ,output logic [ (  16 ) -1 : 0 ]     rf_ll_schlst_tpprv_bin0_rdata

    ,input  logic                        rf_ll_schlst_tpprv_bin0_isol_en
    ,input  logic                        rf_ll_schlst_tpprv_bin0_pwr_enable_b_in
    ,output logic                        rf_ll_schlst_tpprv_bin0_pwr_enable_b_out

    ,input  logic                        rf_ll_schlst_tpprv_bin1_wclk
    ,input  logic                        rf_ll_schlst_tpprv_bin1_wclk_rst_n
    ,input  logic                        rf_ll_schlst_tpprv_bin1_we
    ,input  logic [ (  11 ) -1 : 0 ]     rf_ll_schlst_tpprv_bin1_waddr
    ,input  logic [ (  16 ) -1 : 0 ]     rf_ll_schlst_tpprv_bin1_wdata
    ,input  logic                        rf_ll_schlst_tpprv_bin1_rclk
    ,input  logic                        rf_ll_schlst_tpprv_bin1_rclk_rst_n
    ,input  logic                        rf_ll_schlst_tpprv_bin1_re
    ,input  logic [ (  11 ) -1 : 0 ]     rf_ll_schlst_tpprv_bin1_raddr
    ,output logic [ (  16 ) -1 : 0 ]     rf_ll_schlst_tpprv_bin1_rdata

    ,input  logic                        rf_ll_schlst_tpprv_bin1_isol_en
    ,input  logic                        rf_ll_schlst_tpprv_bin1_pwr_enable_b_in
    ,output logic                        rf_ll_schlst_tpprv_bin1_pwr_enable_b_out

    ,input  logic                        rf_ll_schlst_tpprv_bin2_wclk
    ,input  logic                        rf_ll_schlst_tpprv_bin2_wclk_rst_n
    ,input  logic                        rf_ll_schlst_tpprv_bin2_we
    ,input  logic [ (  11 ) -1 : 0 ]     rf_ll_schlst_tpprv_bin2_waddr
    ,input  logic [ (  16 ) -1 : 0 ]     rf_ll_schlst_tpprv_bin2_wdata
    ,input  logic                        rf_ll_schlst_tpprv_bin2_rclk
    ,input  logic                        rf_ll_schlst_tpprv_bin2_rclk_rst_n
    ,input  logic                        rf_ll_schlst_tpprv_bin2_re
    ,input  logic [ (  11 ) -1 : 0 ]     rf_ll_schlst_tpprv_bin2_raddr
    ,output logic [ (  16 ) -1 : 0 ]     rf_ll_schlst_tpprv_bin2_rdata

    ,input  logic                        rf_ll_schlst_tpprv_bin2_isol_en
    ,input  logic                        rf_ll_schlst_tpprv_bin2_pwr_enable_b_in
    ,output logic                        rf_ll_schlst_tpprv_bin2_pwr_enable_b_out

    ,input  logic                        rf_ll_schlst_tpprv_bin3_wclk
    ,input  logic                        rf_ll_schlst_tpprv_bin3_wclk_rst_n
    ,input  logic                        rf_ll_schlst_tpprv_bin3_we
    ,input  logic [ (  11 ) -1 : 0 ]     rf_ll_schlst_tpprv_bin3_waddr
    ,input  logic [ (  16 ) -1 : 0 ]     rf_ll_schlst_tpprv_bin3_wdata
    ,input  logic                        rf_ll_schlst_tpprv_bin3_rclk
    ,input  logic                        rf_ll_schlst_tpprv_bin3_rclk_rst_n
    ,input  logic                        rf_ll_schlst_tpprv_bin3_re
    ,input  logic [ (  11 ) -1 : 0 ]     rf_ll_schlst_tpprv_bin3_raddr
    ,output logic [ (  16 ) -1 : 0 ]     rf_ll_schlst_tpprv_bin3_rdata

    ,input  logic                        rf_ll_schlst_tpprv_bin3_isol_en
    ,input  logic                        rf_ll_schlst_tpprv_bin3_pwr_enable_b_in
    ,output logic                        rf_ll_schlst_tpprv_bin3_pwr_enable_b_out

    ,input  logic                        rf_ll_slst_cnt_wclk
    ,input  logic                        rf_ll_slst_cnt_wclk_rst_n
    ,input  logic                        rf_ll_slst_cnt_we
    ,input  logic [ (   9 ) -1 : 0 ]     rf_ll_slst_cnt_waddr
    ,input  logic [ (  60 ) -1 : 0 ]     rf_ll_slst_cnt_wdata
    ,input  logic                        rf_ll_slst_cnt_rclk
    ,input  logic                        rf_ll_slst_cnt_rclk_rst_n
    ,input  logic                        rf_ll_slst_cnt_re
    ,input  logic [ (   9 ) -1 : 0 ]     rf_ll_slst_cnt_raddr
    ,output logic [ (  60 ) -1 : 0 ]     rf_ll_slst_cnt_rdata

    ,input  logic                        rf_ll_slst_cnt_isol_en
    ,input  logic                        rf_ll_slst_cnt_pwr_enable_b_in
    ,output logic                        rf_ll_slst_cnt_pwr_enable_b_out

    ,input  logic                        rf_nalb_cmp_fifo_mem_wclk
    ,input  logic                        rf_nalb_cmp_fifo_mem_wclk_rst_n
    ,input  logic                        rf_nalb_cmp_fifo_mem_we
    ,input  logic [ (   3 ) -1 : 0 ]     rf_nalb_cmp_fifo_mem_waddr
    ,input  logic [ (  18 ) -1 : 0 ]     rf_nalb_cmp_fifo_mem_wdata
    ,input  logic                        rf_nalb_cmp_fifo_mem_rclk
    ,input  logic                        rf_nalb_cmp_fifo_mem_rclk_rst_n
    ,input  logic                        rf_nalb_cmp_fifo_mem_re
    ,input  logic [ (   3 ) -1 : 0 ]     rf_nalb_cmp_fifo_mem_raddr
    ,output logic [ (  18 ) -1 : 0 ]     rf_nalb_cmp_fifo_mem_rdata

    ,input  logic                        rf_nalb_cmp_fifo_mem_isol_en
    ,input  logic                        rf_nalb_cmp_fifo_mem_pwr_enable_b_in
    ,output logic                        rf_nalb_cmp_fifo_mem_pwr_enable_b_out

    ,input  logic                        rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_wclk
    ,input  logic                        rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_wclk_rst_n
    ,input  logic                        rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_we
    ,input  logic [ (   2 ) -1 : 0 ]     rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_waddr
    ,input  logic [ (  10 ) -1 : 0 ]     rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_wdata
    ,input  logic                        rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_rclk
    ,input  logic                        rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_rclk_rst_n
    ,input  logic                        rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_re
    ,input  logic [ (   2 ) -1 : 0 ]     rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_raddr
    ,output logic [ (  10 ) -1 : 0 ]     rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_rdata

    ,input  logic                        rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_isol_en
    ,input  logic                        rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_pwr_enable_b_in
    ,output logic                        rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_pwr_enable_b_out

    ,input  logic                        rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_wclk
    ,input  logic                        rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_wclk_rst_n
    ,input  logic                        rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_we
    ,input  logic [ (   2 ) -1 : 0 ]     rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_waddr
    ,input  logic [ (  27 ) -1 : 0 ]     rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_wdata
    ,input  logic                        rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_rclk
    ,input  logic                        rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_rclk_rst_n
    ,input  logic                        rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_re
    ,input  logic [ (   2 ) -1 : 0 ]     rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_raddr
    ,output logic [ (  27 ) -1 : 0 ]     rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_rdata

    ,input  logic                        rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_isol_en
    ,input  logic                        rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_pwr_enable_b_in
    ,output logic                        rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_pwr_enable_b_out

    ,input  logic                        rf_nalb_sel_nalb_fifo_mem_wclk
    ,input  logic                        rf_nalb_sel_nalb_fifo_mem_wclk_rst_n
    ,input  logic                        rf_nalb_sel_nalb_fifo_mem_we
    ,input  logic [ (   4 ) -1 : 0 ]     rf_nalb_sel_nalb_fifo_mem_waddr
    ,input  logic [ (  27 ) -1 : 0 ]     rf_nalb_sel_nalb_fifo_mem_wdata
    ,input  logic                        rf_nalb_sel_nalb_fifo_mem_rclk
    ,input  logic                        rf_nalb_sel_nalb_fifo_mem_rclk_rst_n
    ,input  logic                        rf_nalb_sel_nalb_fifo_mem_re
    ,input  logic [ (   4 ) -1 : 0 ]     rf_nalb_sel_nalb_fifo_mem_raddr
    ,output logic [ (  27 ) -1 : 0 ]     rf_nalb_sel_nalb_fifo_mem_rdata

    ,input  logic                        rf_nalb_sel_nalb_fifo_mem_isol_en
    ,input  logic                        rf_nalb_sel_nalb_fifo_mem_pwr_enable_b_in
    ,output logic                        rf_nalb_sel_nalb_fifo_mem_pwr_enable_b_out

    ,input  logic                        rf_qed_lsp_deq_fifo_mem_wclk
    ,input  logic                        rf_qed_lsp_deq_fifo_mem_wclk_rst_n
    ,input  logic                        rf_qed_lsp_deq_fifo_mem_we
    ,input  logic [ (   5 ) -1 : 0 ]     rf_qed_lsp_deq_fifo_mem_waddr
    ,input  logic [ (   9 ) -1 : 0 ]     rf_qed_lsp_deq_fifo_mem_wdata
    ,input  logic                        rf_qed_lsp_deq_fifo_mem_rclk
    ,input  logic                        rf_qed_lsp_deq_fifo_mem_rclk_rst_n
    ,input  logic                        rf_qed_lsp_deq_fifo_mem_re
    ,input  logic [ (   5 ) -1 : 0 ]     rf_qed_lsp_deq_fifo_mem_raddr
    ,output logic [ (   9 ) -1 : 0 ]     rf_qed_lsp_deq_fifo_mem_rdata

    ,input  logic                        rf_qed_lsp_deq_fifo_mem_isol_en
    ,input  logic                        rf_qed_lsp_deq_fifo_mem_pwr_enable_b_in
    ,output logic                        rf_qed_lsp_deq_fifo_mem_pwr_enable_b_out

    ,input  logic                        rf_qid_aqed_active_count_mem_wclk
    ,input  logic                        rf_qid_aqed_active_count_mem_wclk_rst_n
    ,input  logic                        rf_qid_aqed_active_count_mem_we
    ,input  logic [ (   5 ) -1 : 0 ]     rf_qid_aqed_active_count_mem_waddr
    ,input  logic [ (  14 ) -1 : 0 ]     rf_qid_aqed_active_count_mem_wdata
    ,input  logic                        rf_qid_aqed_active_count_mem_rclk
    ,input  logic                        rf_qid_aqed_active_count_mem_rclk_rst_n
    ,input  logic                        rf_qid_aqed_active_count_mem_re
    ,input  logic [ (   5 ) -1 : 0 ]     rf_qid_aqed_active_count_mem_raddr
    ,output logic [ (  14 ) -1 : 0 ]     rf_qid_aqed_active_count_mem_rdata

    ,input  logic                        rf_qid_aqed_active_count_mem_isol_en
    ,input  logic                        rf_qid_aqed_active_count_mem_pwr_enable_b_in
    ,output logic                        rf_qid_aqed_active_count_mem_pwr_enable_b_out

    ,input  logic                        rf_qid_atm_active_mem_wclk
    ,input  logic                        rf_qid_atm_active_mem_wclk_rst_n
    ,input  logic                        rf_qid_atm_active_mem_we
    ,input  logic [ (   5 ) -1 : 0 ]     rf_qid_atm_active_mem_waddr
    ,input  logic [ (  17 ) -1 : 0 ]     rf_qid_atm_active_mem_wdata
    ,input  logic                        rf_qid_atm_active_mem_rclk
    ,input  logic                        rf_qid_atm_active_mem_rclk_rst_n
    ,input  logic                        rf_qid_atm_active_mem_re
    ,input  logic [ (   5 ) -1 : 0 ]     rf_qid_atm_active_mem_raddr
    ,output logic [ (  17 ) -1 : 0 ]     rf_qid_atm_active_mem_rdata

    ,input  logic                        rf_qid_atm_active_mem_isol_en
    ,input  logic                        rf_qid_atm_active_mem_pwr_enable_b_in
    ,output logic                        rf_qid_atm_active_mem_pwr_enable_b_out

    ,input  logic                        rf_qid_atm_tot_enq_cnt_mem_wclk
    ,input  logic                        rf_qid_atm_tot_enq_cnt_mem_wclk_rst_n
    ,input  logic                        rf_qid_atm_tot_enq_cnt_mem_we
    ,input  logic [ (   5 ) -1 : 0 ]     rf_qid_atm_tot_enq_cnt_mem_waddr
    ,input  logic [ (  66 ) -1 : 0 ]     rf_qid_atm_tot_enq_cnt_mem_wdata
    ,input  logic                        rf_qid_atm_tot_enq_cnt_mem_rclk
    ,input  logic                        rf_qid_atm_tot_enq_cnt_mem_rclk_rst_n
    ,input  logic                        rf_qid_atm_tot_enq_cnt_mem_re
    ,input  logic [ (   5 ) -1 : 0 ]     rf_qid_atm_tot_enq_cnt_mem_raddr
    ,output logic [ (  66 ) -1 : 0 ]     rf_qid_atm_tot_enq_cnt_mem_rdata

    ,input  logic                        rf_qid_atm_tot_enq_cnt_mem_isol_en
    ,input  logic                        rf_qid_atm_tot_enq_cnt_mem_pwr_enable_b_in
    ,output logic                        rf_qid_atm_tot_enq_cnt_mem_pwr_enable_b_out

    ,input  logic                        rf_qid_atq_enqueue_count_mem_wclk
    ,input  logic                        rf_qid_atq_enqueue_count_mem_wclk_rst_n
    ,input  logic                        rf_qid_atq_enqueue_count_mem_we
    ,input  logic [ (   5 ) -1 : 0 ]     rf_qid_atq_enqueue_count_mem_waddr
    ,input  logic [ (  17 ) -1 : 0 ]     rf_qid_atq_enqueue_count_mem_wdata
    ,input  logic                        rf_qid_atq_enqueue_count_mem_rclk
    ,input  logic                        rf_qid_atq_enqueue_count_mem_rclk_rst_n
    ,input  logic                        rf_qid_atq_enqueue_count_mem_re
    ,input  logic [ (   5 ) -1 : 0 ]     rf_qid_atq_enqueue_count_mem_raddr
    ,output logic [ (  17 ) -1 : 0 ]     rf_qid_atq_enqueue_count_mem_rdata

    ,input  logic                        rf_qid_atq_enqueue_count_mem_isol_en
    ,input  logic                        rf_qid_atq_enqueue_count_mem_pwr_enable_b_in
    ,output logic                        rf_qid_atq_enqueue_count_mem_pwr_enable_b_out

    ,input  logic                        rf_qid_dir_max_depth_mem_wclk
    ,input  logic                        rf_qid_dir_max_depth_mem_wclk_rst_n
    ,input  logic                        rf_qid_dir_max_depth_mem_we
    ,input  logic [ (   6 ) -1 : 0 ]     rf_qid_dir_max_depth_mem_waddr
    ,input  logic [ (  15 ) -1 : 0 ]     rf_qid_dir_max_depth_mem_wdata
    ,input  logic                        rf_qid_dir_max_depth_mem_rclk
    ,input  logic                        rf_qid_dir_max_depth_mem_rclk_rst_n
    ,input  logic                        rf_qid_dir_max_depth_mem_re
    ,input  logic [ (   6 ) -1 : 0 ]     rf_qid_dir_max_depth_mem_raddr
    ,output logic [ (  15 ) -1 : 0 ]     rf_qid_dir_max_depth_mem_rdata

    ,input  logic                        rf_qid_dir_max_depth_mem_isol_en
    ,input  logic                        rf_qid_dir_max_depth_mem_pwr_enable_b_in
    ,output logic                        rf_qid_dir_max_depth_mem_pwr_enable_b_out

    ,input  logic                        rf_qid_dir_replay_count_mem_wclk
    ,input  logic                        rf_qid_dir_replay_count_mem_wclk_rst_n
    ,input  logic                        rf_qid_dir_replay_count_mem_we
    ,input  logic [ (   5 ) -1 : 0 ]     rf_qid_dir_replay_count_mem_waddr
    ,input  logic [ (  17 ) -1 : 0 ]     rf_qid_dir_replay_count_mem_wdata
    ,input  logic                        rf_qid_dir_replay_count_mem_rclk
    ,input  logic                        rf_qid_dir_replay_count_mem_rclk_rst_n
    ,input  logic                        rf_qid_dir_replay_count_mem_re
    ,input  logic [ (   5 ) -1 : 0 ]     rf_qid_dir_replay_count_mem_raddr
    ,output logic [ (  17 ) -1 : 0 ]     rf_qid_dir_replay_count_mem_rdata

    ,input  logic                        rf_qid_dir_replay_count_mem_isol_en
    ,input  logic                        rf_qid_dir_replay_count_mem_pwr_enable_b_in
    ,output logic                        rf_qid_dir_replay_count_mem_pwr_enable_b_out

    ,input  logic                        rf_qid_dir_tot_enq_cnt_mem_wclk
    ,input  logic                        rf_qid_dir_tot_enq_cnt_mem_wclk_rst_n
    ,input  logic                        rf_qid_dir_tot_enq_cnt_mem_we
    ,input  logic [ (   6 ) -1 : 0 ]     rf_qid_dir_tot_enq_cnt_mem_waddr
    ,input  logic [ (  66 ) -1 : 0 ]     rf_qid_dir_tot_enq_cnt_mem_wdata
    ,input  logic                        rf_qid_dir_tot_enq_cnt_mem_rclk
    ,input  logic                        rf_qid_dir_tot_enq_cnt_mem_rclk_rst_n
    ,input  logic                        rf_qid_dir_tot_enq_cnt_mem_re
    ,input  logic [ (   6 ) -1 : 0 ]     rf_qid_dir_tot_enq_cnt_mem_raddr
    ,output logic [ (  66 ) -1 : 0 ]     rf_qid_dir_tot_enq_cnt_mem_rdata

    ,input  logic                        rf_qid_dir_tot_enq_cnt_mem_isol_en
    ,input  logic                        rf_qid_dir_tot_enq_cnt_mem_pwr_enable_b_in
    ,output logic                        rf_qid_dir_tot_enq_cnt_mem_pwr_enable_b_out

    ,input  logic                        rf_qid_ldb_enqueue_count_mem_wclk
    ,input  logic                        rf_qid_ldb_enqueue_count_mem_wclk_rst_n
    ,input  logic                        rf_qid_ldb_enqueue_count_mem_we
    ,input  logic [ (   5 ) -1 : 0 ]     rf_qid_ldb_enqueue_count_mem_waddr
    ,input  logic [ (  17 ) -1 : 0 ]     rf_qid_ldb_enqueue_count_mem_wdata
    ,input  logic                        rf_qid_ldb_enqueue_count_mem_rclk
    ,input  logic                        rf_qid_ldb_enqueue_count_mem_rclk_rst_n
    ,input  logic                        rf_qid_ldb_enqueue_count_mem_re
    ,input  logic [ (   5 ) -1 : 0 ]     rf_qid_ldb_enqueue_count_mem_raddr
    ,output logic [ (  17 ) -1 : 0 ]     rf_qid_ldb_enqueue_count_mem_rdata

    ,input  logic                        rf_qid_ldb_enqueue_count_mem_isol_en
    ,input  logic                        rf_qid_ldb_enqueue_count_mem_pwr_enable_b_in
    ,output logic                        rf_qid_ldb_enqueue_count_mem_pwr_enable_b_out

    ,input  logic                        rf_qid_ldb_inflight_count_mem_wclk
    ,input  logic                        rf_qid_ldb_inflight_count_mem_wclk_rst_n
    ,input  logic                        rf_qid_ldb_inflight_count_mem_we
    ,input  logic [ (   5 ) -1 : 0 ]     rf_qid_ldb_inflight_count_mem_waddr
    ,input  logic [ (  14 ) -1 : 0 ]     rf_qid_ldb_inflight_count_mem_wdata
    ,input  logic                        rf_qid_ldb_inflight_count_mem_rclk
    ,input  logic                        rf_qid_ldb_inflight_count_mem_rclk_rst_n
    ,input  logic                        rf_qid_ldb_inflight_count_mem_re
    ,input  logic [ (   5 ) -1 : 0 ]     rf_qid_ldb_inflight_count_mem_raddr
    ,output logic [ (  14 ) -1 : 0 ]     rf_qid_ldb_inflight_count_mem_rdata

    ,input  logic                        rf_qid_ldb_inflight_count_mem_isol_en
    ,input  logic                        rf_qid_ldb_inflight_count_mem_pwr_enable_b_in
    ,output logic                        rf_qid_ldb_inflight_count_mem_pwr_enable_b_out

    ,input  logic                        rf_qid_ldb_replay_count_mem_wclk
    ,input  logic                        rf_qid_ldb_replay_count_mem_wclk_rst_n
    ,input  logic                        rf_qid_ldb_replay_count_mem_we
    ,input  logic [ (   5 ) -1 : 0 ]     rf_qid_ldb_replay_count_mem_waddr
    ,input  logic [ (  17 ) -1 : 0 ]     rf_qid_ldb_replay_count_mem_wdata
    ,input  logic                        rf_qid_ldb_replay_count_mem_rclk
    ,input  logic                        rf_qid_ldb_replay_count_mem_rclk_rst_n
    ,input  logic                        rf_qid_ldb_replay_count_mem_re
    ,input  logic [ (   5 ) -1 : 0 ]     rf_qid_ldb_replay_count_mem_raddr
    ,output logic [ (  17 ) -1 : 0 ]     rf_qid_ldb_replay_count_mem_rdata

    ,input  logic                        rf_qid_ldb_replay_count_mem_isol_en
    ,input  logic                        rf_qid_ldb_replay_count_mem_pwr_enable_b_in
    ,output logic                        rf_qid_ldb_replay_count_mem_pwr_enable_b_out

    ,input  logic                        rf_qid_naldb_max_depth_mem_wclk
    ,input  logic                        rf_qid_naldb_max_depth_mem_wclk_rst_n
    ,input  logic                        rf_qid_naldb_max_depth_mem_we
    ,input  logic [ (   5 ) -1 : 0 ]     rf_qid_naldb_max_depth_mem_waddr
    ,input  logic [ (  15 ) -1 : 0 ]     rf_qid_naldb_max_depth_mem_wdata
    ,input  logic                        rf_qid_naldb_max_depth_mem_rclk
    ,input  logic                        rf_qid_naldb_max_depth_mem_rclk_rst_n
    ,input  logic                        rf_qid_naldb_max_depth_mem_re
    ,input  logic [ (   5 ) -1 : 0 ]     rf_qid_naldb_max_depth_mem_raddr
    ,output logic [ (  15 ) -1 : 0 ]     rf_qid_naldb_max_depth_mem_rdata

    ,input  logic                        rf_qid_naldb_max_depth_mem_isol_en
    ,input  logic                        rf_qid_naldb_max_depth_mem_pwr_enable_b_in
    ,output logic                        rf_qid_naldb_max_depth_mem_pwr_enable_b_out

    ,input  logic                        rf_qid_naldb_tot_enq_cnt_mem_wclk
    ,input  logic                        rf_qid_naldb_tot_enq_cnt_mem_wclk_rst_n
    ,input  logic                        rf_qid_naldb_tot_enq_cnt_mem_we
    ,input  logic [ (   5 ) -1 : 0 ]     rf_qid_naldb_tot_enq_cnt_mem_waddr
    ,input  logic [ (  66 ) -1 : 0 ]     rf_qid_naldb_tot_enq_cnt_mem_wdata
    ,input  logic                        rf_qid_naldb_tot_enq_cnt_mem_rclk
    ,input  logic                        rf_qid_naldb_tot_enq_cnt_mem_rclk_rst_n
    ,input  logic                        rf_qid_naldb_tot_enq_cnt_mem_re
    ,input  logic [ (   5 ) -1 : 0 ]     rf_qid_naldb_tot_enq_cnt_mem_raddr
    ,output logic [ (  66 ) -1 : 0 ]     rf_qid_naldb_tot_enq_cnt_mem_rdata

    ,input  logic                        rf_qid_naldb_tot_enq_cnt_mem_isol_en
    ,input  logic                        rf_qid_naldb_tot_enq_cnt_mem_pwr_enable_b_in
    ,output logic                        rf_qid_naldb_tot_enq_cnt_mem_pwr_enable_b_out

    ,input  logic                        rf_qid_rdylst_clamp_wclk
    ,input  logic                        rf_qid_rdylst_clamp_wclk_rst_n
    ,input  logic                        rf_qid_rdylst_clamp_we
    ,input  logic [ (   5 ) -1 : 0 ]     rf_qid_rdylst_clamp_waddr
    ,input  logic [ (   6 ) -1 : 0 ]     rf_qid_rdylst_clamp_wdata
    ,input  logic                        rf_qid_rdylst_clamp_rclk
    ,input  logic                        rf_qid_rdylst_clamp_rclk_rst_n
    ,input  logic                        rf_qid_rdylst_clamp_re
    ,input  logic [ (   5 ) -1 : 0 ]     rf_qid_rdylst_clamp_raddr
    ,output logic [ (   6 ) -1 : 0 ]     rf_qid_rdylst_clamp_rdata

    ,input  logic                        rf_qid_rdylst_clamp_isol_en
    ,input  logic                        rf_qid_rdylst_clamp_pwr_enable_b_in
    ,output logic                        rf_qid_rdylst_clamp_pwr_enable_b_out

    ,input  logic                        rf_rop_lsp_reordercmp_rx_sync_fifo_mem_wclk
    ,input  logic                        rf_rop_lsp_reordercmp_rx_sync_fifo_mem_wclk_rst_n
    ,input  logic                        rf_rop_lsp_reordercmp_rx_sync_fifo_mem_we
    ,input  logic [ (   3 ) -1 : 0 ]     rf_rop_lsp_reordercmp_rx_sync_fifo_mem_waddr
    ,input  logic [ (  17 ) -1 : 0 ]     rf_rop_lsp_reordercmp_rx_sync_fifo_mem_wdata
    ,input  logic                        rf_rop_lsp_reordercmp_rx_sync_fifo_mem_rclk
    ,input  logic                        rf_rop_lsp_reordercmp_rx_sync_fifo_mem_rclk_rst_n
    ,input  logic                        rf_rop_lsp_reordercmp_rx_sync_fifo_mem_re
    ,input  logic [ (   3 ) -1 : 0 ]     rf_rop_lsp_reordercmp_rx_sync_fifo_mem_raddr
    ,output logic [ (  17 ) -1 : 0 ]     rf_rop_lsp_reordercmp_rx_sync_fifo_mem_rdata

    ,input  logic                        rf_rop_lsp_reordercmp_rx_sync_fifo_mem_isol_en
    ,input  logic                        rf_rop_lsp_reordercmp_rx_sync_fifo_mem_pwr_enable_b_in
    ,output logic                        rf_rop_lsp_reordercmp_rx_sync_fifo_mem_pwr_enable_b_out

    ,input  logic                        rf_rx_sync_qed_aqed_enq_wclk
    ,input  logic                        rf_rx_sync_qed_aqed_enq_wclk_rst_n
    ,input  logic                        rf_rx_sync_qed_aqed_enq_we
    ,input  logic [ (   2 ) -1 : 0 ]     rf_rx_sync_qed_aqed_enq_waddr
    ,input  logic [ ( 139 ) -1 : 0 ]     rf_rx_sync_qed_aqed_enq_wdata
    ,input  logic                        rf_rx_sync_qed_aqed_enq_rclk
    ,input  logic                        rf_rx_sync_qed_aqed_enq_rclk_rst_n
    ,input  logic                        rf_rx_sync_qed_aqed_enq_re
    ,input  logic [ (   2 ) -1 : 0 ]     rf_rx_sync_qed_aqed_enq_raddr
    ,output logic [ ( 139 ) -1 : 0 ]     rf_rx_sync_qed_aqed_enq_rdata

    ,input  logic                        rf_rx_sync_qed_aqed_enq_isol_en
    ,input  logic                        rf_rx_sync_qed_aqed_enq_pwr_enable_b_in
    ,output logic                        rf_rx_sync_qed_aqed_enq_pwr_enable_b_out

    ,input  logic                        rf_send_atm_to_cq_rx_sync_fifo_mem_wclk
    ,input  logic                        rf_send_atm_to_cq_rx_sync_fifo_mem_wclk_rst_n
    ,input  logic                        rf_send_atm_to_cq_rx_sync_fifo_mem_we
    ,input  logic [ (   2 ) -1 : 0 ]     rf_send_atm_to_cq_rx_sync_fifo_mem_waddr
    ,input  logic [ (  35 ) -1 : 0 ]     rf_send_atm_to_cq_rx_sync_fifo_mem_wdata
    ,input  logic                        rf_send_atm_to_cq_rx_sync_fifo_mem_rclk
    ,input  logic                        rf_send_atm_to_cq_rx_sync_fifo_mem_rclk_rst_n
    ,input  logic                        rf_send_atm_to_cq_rx_sync_fifo_mem_re
    ,input  logic [ (   2 ) -1 : 0 ]     rf_send_atm_to_cq_rx_sync_fifo_mem_raddr
    ,output logic [ (  35 ) -1 : 0 ]     rf_send_atm_to_cq_rx_sync_fifo_mem_rdata

    ,input  logic                        rf_send_atm_to_cq_rx_sync_fifo_mem_isol_en
    ,input  logic                        rf_send_atm_to_cq_rx_sync_fifo_mem_pwr_enable_b_in
    ,output logic                        rf_send_atm_to_cq_rx_sync_fifo_mem_pwr_enable_b_out

    ,input  logic                        rf_uno_atm_cmp_fifo_mem_wclk
    ,input  logic                        rf_uno_atm_cmp_fifo_mem_wclk_rst_n
    ,input  logic                        rf_uno_atm_cmp_fifo_mem_we
    ,input  logic [ (   3 ) -1 : 0 ]     rf_uno_atm_cmp_fifo_mem_waddr
    ,input  logic [ (  20 ) -1 : 0 ]     rf_uno_atm_cmp_fifo_mem_wdata
    ,input  logic                        rf_uno_atm_cmp_fifo_mem_rclk
    ,input  logic                        rf_uno_atm_cmp_fifo_mem_rclk_rst_n
    ,input  logic                        rf_uno_atm_cmp_fifo_mem_re
    ,input  logic [ (   3 ) -1 : 0 ]     rf_uno_atm_cmp_fifo_mem_raddr
    ,output logic [ (  20 ) -1 : 0 ]     rf_uno_atm_cmp_fifo_mem_rdata

    ,input  logic                        rf_uno_atm_cmp_fifo_mem_isol_en
    ,input  logic                        rf_uno_atm_cmp_fifo_mem_pwr_enable_b_in
    ,output logic                        rf_uno_atm_cmp_fifo_mem_pwr_enable_b_out

    ,input  logic                        powergood_rst_b

    ,input  logic                        hqm_pwrgood_rst_b

    ,input  logic                        fscan_byprst_b
    ,input  logic                        fscan_clkungate
    ,input  logic                        fscan_rstbypen
);

logic ip_reset_b;

assign ip_reset_b = powergood_rst_b & hqm_pwrgood_rst_b;

hqm_list_sel_mem_AW_rf_pg_2048x17 i_rf_aqed_fid_cnt (

     .wclk                    (rf_aqed_fid_cnt_wclk)
    ,.wclk_rst_n              (rf_aqed_fid_cnt_wclk_rst_n)
    ,.we                      (rf_aqed_fid_cnt_we)
    ,.waddr                   (rf_aqed_fid_cnt_waddr)
    ,.wdata                   (rf_aqed_fid_cnt_wdata)
    ,.rclk                    (rf_aqed_fid_cnt_rclk)
    ,.rclk_rst_n              (rf_aqed_fid_cnt_rclk_rst_n)
    ,.re                      (rf_aqed_fid_cnt_re)
    ,.raddr                   (rf_aqed_fid_cnt_raddr)
    ,.rdata                   (rf_aqed_fid_cnt_rdata)

    ,.pgcb_isol_en            (rf_aqed_fid_cnt_isol_en)
    ,.pwr_enable_b_in         (rf_aqed_fid_cnt_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_aqed_fid_cnt_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_16x45 i_rf_aqed_fifo_ap_aqed (

     .wclk                    (rf_aqed_fifo_ap_aqed_wclk)
    ,.wclk_rst_n              (rf_aqed_fifo_ap_aqed_wclk_rst_n)
    ,.we                      (rf_aqed_fifo_ap_aqed_we)
    ,.waddr                   (rf_aqed_fifo_ap_aqed_waddr)
    ,.wdata                   (rf_aqed_fifo_ap_aqed_wdata)
    ,.rclk                    (rf_aqed_fifo_ap_aqed_rclk)
    ,.rclk_rst_n              (rf_aqed_fifo_ap_aqed_rclk_rst_n)
    ,.re                      (rf_aqed_fifo_ap_aqed_re)
    ,.raddr                   (rf_aqed_fifo_ap_aqed_raddr)
    ,.rdata                   (rf_aqed_fifo_ap_aqed_rdata)

    ,.pgcb_isol_en            (rf_aqed_fifo_ap_aqed_isol_en)
    ,.pwr_enable_b_in         (rf_aqed_fifo_ap_aqed_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_aqed_fifo_ap_aqed_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_16x24 i_rf_aqed_fifo_aqed_ap_enq (

     .wclk                    (rf_aqed_fifo_aqed_ap_enq_wclk)
    ,.wclk_rst_n              (rf_aqed_fifo_aqed_ap_enq_wclk_rst_n)
    ,.we                      (rf_aqed_fifo_aqed_ap_enq_we)
    ,.waddr                   (rf_aqed_fifo_aqed_ap_enq_waddr)
    ,.wdata                   (rf_aqed_fifo_aqed_ap_enq_wdata)
    ,.rclk                    (rf_aqed_fifo_aqed_ap_enq_rclk)
    ,.rclk_rst_n              (rf_aqed_fifo_aqed_ap_enq_rclk_rst_n)
    ,.re                      (rf_aqed_fifo_aqed_ap_enq_re)
    ,.raddr                   (rf_aqed_fifo_aqed_ap_enq_raddr)
    ,.rdata                   (rf_aqed_fifo_aqed_ap_enq_rdata)

    ,.pgcb_isol_en            (rf_aqed_fifo_aqed_ap_enq_isol_en)
    ,.pwr_enable_b_in         (rf_aqed_fifo_aqed_ap_enq_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_aqed_fifo_aqed_ap_enq_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_16x180 i_rf_aqed_fifo_aqed_chp_sch (

     .wclk                    (rf_aqed_fifo_aqed_chp_sch_wclk)
    ,.wclk_rst_n              (rf_aqed_fifo_aqed_chp_sch_wclk_rst_n)
    ,.we                      (rf_aqed_fifo_aqed_chp_sch_we)
    ,.waddr                   (rf_aqed_fifo_aqed_chp_sch_waddr)
    ,.wdata                   (rf_aqed_fifo_aqed_chp_sch_wdata)
    ,.rclk                    (rf_aqed_fifo_aqed_chp_sch_rclk)
    ,.rclk_rst_n              (rf_aqed_fifo_aqed_chp_sch_rclk_rst_n)
    ,.re                      (rf_aqed_fifo_aqed_chp_sch_re)
    ,.raddr                   (rf_aqed_fifo_aqed_chp_sch_raddr)
    ,.rdata                   (rf_aqed_fifo_aqed_chp_sch_rdata)

    ,.pgcb_isol_en            (rf_aqed_fifo_aqed_chp_sch_isol_en)
    ,.pwr_enable_b_in         (rf_aqed_fifo_aqed_chp_sch_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_aqed_fifo_aqed_chp_sch_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_16x32 i_rf_aqed_fifo_freelist_return (

     .wclk                    (rf_aqed_fifo_freelist_return_wclk)
    ,.wclk_rst_n              (rf_aqed_fifo_freelist_return_wclk_rst_n)
    ,.we                      (rf_aqed_fifo_freelist_return_we)
    ,.waddr                   (rf_aqed_fifo_freelist_return_waddr)
    ,.wdata                   (rf_aqed_fifo_freelist_return_wdata)
    ,.rclk                    (rf_aqed_fifo_freelist_return_rclk)
    ,.rclk_rst_n              (rf_aqed_fifo_freelist_return_rclk_rst_n)
    ,.re                      (rf_aqed_fifo_freelist_return_re)
    ,.raddr                   (rf_aqed_fifo_freelist_return_raddr)
    ,.rdata                   (rf_aqed_fifo_freelist_return_rdata)

    ,.pgcb_isol_en            (rf_aqed_fifo_freelist_return_isol_en)
    ,.pwr_enable_b_in         (rf_aqed_fifo_freelist_return_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_aqed_fifo_freelist_return_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_16x35 i_rf_aqed_fifo_lsp_aqed_cmp (

     .wclk                    (rf_aqed_fifo_lsp_aqed_cmp_wclk)
    ,.wclk_rst_n              (rf_aqed_fifo_lsp_aqed_cmp_wclk_rst_n)
    ,.we                      (rf_aqed_fifo_lsp_aqed_cmp_we)
    ,.waddr                   (rf_aqed_fifo_lsp_aqed_cmp_waddr)
    ,.wdata                   (rf_aqed_fifo_lsp_aqed_cmp_wdata)
    ,.rclk                    (rf_aqed_fifo_lsp_aqed_cmp_rclk)
    ,.rclk_rst_n              (rf_aqed_fifo_lsp_aqed_cmp_rclk_rst_n)
    ,.re                      (rf_aqed_fifo_lsp_aqed_cmp_re)
    ,.raddr                   (rf_aqed_fifo_lsp_aqed_cmp_raddr)
    ,.rdata                   (rf_aqed_fifo_lsp_aqed_cmp_rdata)

    ,.pgcb_isol_en            (rf_aqed_fifo_lsp_aqed_cmp_isol_en)
    ,.pwr_enable_b_in         (rf_aqed_fifo_lsp_aqed_cmp_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_aqed_fifo_lsp_aqed_cmp_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_4x155 i_rf_aqed_fifo_qed_aqed_enq (

     .wclk                    (rf_aqed_fifo_qed_aqed_enq_wclk)
    ,.wclk_rst_n              (rf_aqed_fifo_qed_aqed_enq_wclk_rst_n)
    ,.we                      (rf_aqed_fifo_qed_aqed_enq_we)
    ,.waddr                   (rf_aqed_fifo_qed_aqed_enq_waddr)
    ,.wdata                   (rf_aqed_fifo_qed_aqed_enq_wdata)
    ,.rclk                    (rf_aqed_fifo_qed_aqed_enq_rclk)
    ,.rclk_rst_n              (rf_aqed_fifo_qed_aqed_enq_rclk_rst_n)
    ,.re                      (rf_aqed_fifo_qed_aqed_enq_re)
    ,.raddr                   (rf_aqed_fifo_qed_aqed_enq_raddr)
    ,.rdata                   (rf_aqed_fifo_qed_aqed_enq_rdata)

    ,.pgcb_isol_en            (rf_aqed_fifo_qed_aqed_enq_isol_en)
    ,.pwr_enable_b_in         (rf_aqed_fifo_qed_aqed_enq_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_aqed_fifo_qed_aqed_enq_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_8x153 i_rf_aqed_fifo_qed_aqed_enq_fid (

     .wclk                    (rf_aqed_fifo_qed_aqed_enq_fid_wclk)
    ,.wclk_rst_n              (rf_aqed_fifo_qed_aqed_enq_fid_wclk_rst_n)
    ,.we                      (rf_aqed_fifo_qed_aqed_enq_fid_we)
    ,.waddr                   (rf_aqed_fifo_qed_aqed_enq_fid_waddr)
    ,.wdata                   (rf_aqed_fifo_qed_aqed_enq_fid_wdata)
    ,.rclk                    (rf_aqed_fifo_qed_aqed_enq_fid_rclk)
    ,.rclk_rst_n              (rf_aqed_fifo_qed_aqed_enq_fid_rclk_rst_n)
    ,.re                      (rf_aqed_fifo_qed_aqed_enq_fid_re)
    ,.raddr                   (rf_aqed_fifo_qed_aqed_enq_fid_raddr)
    ,.rdata                   (rf_aqed_fifo_qed_aqed_enq_fid_rdata)

    ,.pgcb_isol_en            (rf_aqed_fifo_qed_aqed_enq_fid_isol_en)
    ,.pwr_enable_b_in         (rf_aqed_fifo_qed_aqed_enq_fid_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_aqed_fifo_qed_aqed_enq_fid_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_2048x16 i_rf_aqed_ll_cnt_pri0 (

     .wclk                    (rf_aqed_ll_cnt_pri0_wclk)
    ,.wclk_rst_n              (rf_aqed_ll_cnt_pri0_wclk_rst_n)
    ,.we                      (rf_aqed_ll_cnt_pri0_we)
    ,.waddr                   (rf_aqed_ll_cnt_pri0_waddr)
    ,.wdata                   (rf_aqed_ll_cnt_pri0_wdata)
    ,.rclk                    (rf_aqed_ll_cnt_pri0_rclk)
    ,.rclk_rst_n              (rf_aqed_ll_cnt_pri0_rclk_rst_n)
    ,.re                      (rf_aqed_ll_cnt_pri0_re)
    ,.raddr                   (rf_aqed_ll_cnt_pri0_raddr)
    ,.rdata                   (rf_aqed_ll_cnt_pri0_rdata)

    ,.pgcb_isol_en            (rf_aqed_ll_cnt_pri0_isol_en)
    ,.pwr_enable_b_in         (rf_aqed_ll_cnt_pri0_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_aqed_ll_cnt_pri0_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_2048x16 i_rf_aqed_ll_cnt_pri1 (

     .wclk                    (rf_aqed_ll_cnt_pri1_wclk)
    ,.wclk_rst_n              (rf_aqed_ll_cnt_pri1_wclk_rst_n)
    ,.we                      (rf_aqed_ll_cnt_pri1_we)
    ,.waddr                   (rf_aqed_ll_cnt_pri1_waddr)
    ,.wdata                   (rf_aqed_ll_cnt_pri1_wdata)
    ,.rclk                    (rf_aqed_ll_cnt_pri1_rclk)
    ,.rclk_rst_n              (rf_aqed_ll_cnt_pri1_rclk_rst_n)
    ,.re                      (rf_aqed_ll_cnt_pri1_re)
    ,.raddr                   (rf_aqed_ll_cnt_pri1_raddr)
    ,.rdata                   (rf_aqed_ll_cnt_pri1_rdata)

    ,.pgcb_isol_en            (rf_aqed_ll_cnt_pri1_isol_en)
    ,.pwr_enable_b_in         (rf_aqed_ll_cnt_pri1_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_aqed_ll_cnt_pri1_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_2048x16 i_rf_aqed_ll_cnt_pri2 (

     .wclk                    (rf_aqed_ll_cnt_pri2_wclk)
    ,.wclk_rst_n              (rf_aqed_ll_cnt_pri2_wclk_rst_n)
    ,.we                      (rf_aqed_ll_cnt_pri2_we)
    ,.waddr                   (rf_aqed_ll_cnt_pri2_waddr)
    ,.wdata                   (rf_aqed_ll_cnt_pri2_wdata)
    ,.rclk                    (rf_aqed_ll_cnt_pri2_rclk)
    ,.rclk_rst_n              (rf_aqed_ll_cnt_pri2_rclk_rst_n)
    ,.re                      (rf_aqed_ll_cnt_pri2_re)
    ,.raddr                   (rf_aqed_ll_cnt_pri2_raddr)
    ,.rdata                   (rf_aqed_ll_cnt_pri2_rdata)

    ,.pgcb_isol_en            (rf_aqed_ll_cnt_pri2_isol_en)
    ,.pwr_enable_b_in         (rf_aqed_ll_cnt_pri2_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_aqed_ll_cnt_pri2_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_2048x16 i_rf_aqed_ll_cnt_pri3 (

     .wclk                    (rf_aqed_ll_cnt_pri3_wclk)
    ,.wclk_rst_n              (rf_aqed_ll_cnt_pri3_wclk_rst_n)
    ,.we                      (rf_aqed_ll_cnt_pri3_we)
    ,.waddr                   (rf_aqed_ll_cnt_pri3_waddr)
    ,.wdata                   (rf_aqed_ll_cnt_pri3_wdata)
    ,.rclk                    (rf_aqed_ll_cnt_pri3_rclk)
    ,.rclk_rst_n              (rf_aqed_ll_cnt_pri3_rclk_rst_n)
    ,.re                      (rf_aqed_ll_cnt_pri3_re)
    ,.raddr                   (rf_aqed_ll_cnt_pri3_raddr)
    ,.rdata                   (rf_aqed_ll_cnt_pri3_rdata)

    ,.pgcb_isol_en            (rf_aqed_ll_cnt_pri3_isol_en)
    ,.pwr_enable_b_in         (rf_aqed_ll_cnt_pri3_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_aqed_ll_cnt_pri3_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_2048x14 i_rf_aqed_ll_qe_hp_pri0 (

     .wclk                    (rf_aqed_ll_qe_hp_pri0_wclk)
    ,.wclk_rst_n              (rf_aqed_ll_qe_hp_pri0_wclk_rst_n)
    ,.we                      (rf_aqed_ll_qe_hp_pri0_we)
    ,.waddr                   (rf_aqed_ll_qe_hp_pri0_waddr)
    ,.wdata                   (rf_aqed_ll_qe_hp_pri0_wdata)
    ,.rclk                    (rf_aqed_ll_qe_hp_pri0_rclk)
    ,.rclk_rst_n              (rf_aqed_ll_qe_hp_pri0_rclk_rst_n)
    ,.re                      (rf_aqed_ll_qe_hp_pri0_re)
    ,.raddr                   (rf_aqed_ll_qe_hp_pri0_raddr)
    ,.rdata                   (rf_aqed_ll_qe_hp_pri0_rdata)

    ,.pgcb_isol_en            (rf_aqed_ll_qe_hp_pri0_isol_en)
    ,.pwr_enable_b_in         (rf_aqed_ll_qe_hp_pri0_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_aqed_ll_qe_hp_pri0_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_2048x14 i_rf_aqed_ll_qe_hp_pri1 (

     .wclk                    (rf_aqed_ll_qe_hp_pri1_wclk)
    ,.wclk_rst_n              (rf_aqed_ll_qe_hp_pri1_wclk_rst_n)
    ,.we                      (rf_aqed_ll_qe_hp_pri1_we)
    ,.waddr                   (rf_aqed_ll_qe_hp_pri1_waddr)
    ,.wdata                   (rf_aqed_ll_qe_hp_pri1_wdata)
    ,.rclk                    (rf_aqed_ll_qe_hp_pri1_rclk)
    ,.rclk_rst_n              (rf_aqed_ll_qe_hp_pri1_rclk_rst_n)
    ,.re                      (rf_aqed_ll_qe_hp_pri1_re)
    ,.raddr                   (rf_aqed_ll_qe_hp_pri1_raddr)
    ,.rdata                   (rf_aqed_ll_qe_hp_pri1_rdata)

    ,.pgcb_isol_en            (rf_aqed_ll_qe_hp_pri1_isol_en)
    ,.pwr_enable_b_in         (rf_aqed_ll_qe_hp_pri1_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_aqed_ll_qe_hp_pri1_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_2048x14 i_rf_aqed_ll_qe_hp_pri2 (

     .wclk                    (rf_aqed_ll_qe_hp_pri2_wclk)
    ,.wclk_rst_n              (rf_aqed_ll_qe_hp_pri2_wclk_rst_n)
    ,.we                      (rf_aqed_ll_qe_hp_pri2_we)
    ,.waddr                   (rf_aqed_ll_qe_hp_pri2_waddr)
    ,.wdata                   (rf_aqed_ll_qe_hp_pri2_wdata)
    ,.rclk                    (rf_aqed_ll_qe_hp_pri2_rclk)
    ,.rclk_rst_n              (rf_aqed_ll_qe_hp_pri2_rclk_rst_n)
    ,.re                      (rf_aqed_ll_qe_hp_pri2_re)
    ,.raddr                   (rf_aqed_ll_qe_hp_pri2_raddr)
    ,.rdata                   (rf_aqed_ll_qe_hp_pri2_rdata)

    ,.pgcb_isol_en            (rf_aqed_ll_qe_hp_pri2_isol_en)
    ,.pwr_enable_b_in         (rf_aqed_ll_qe_hp_pri2_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_aqed_ll_qe_hp_pri2_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_2048x14 i_rf_aqed_ll_qe_hp_pri3 (

     .wclk                    (rf_aqed_ll_qe_hp_pri3_wclk)
    ,.wclk_rst_n              (rf_aqed_ll_qe_hp_pri3_wclk_rst_n)
    ,.we                      (rf_aqed_ll_qe_hp_pri3_we)
    ,.waddr                   (rf_aqed_ll_qe_hp_pri3_waddr)
    ,.wdata                   (rf_aqed_ll_qe_hp_pri3_wdata)
    ,.rclk                    (rf_aqed_ll_qe_hp_pri3_rclk)
    ,.rclk_rst_n              (rf_aqed_ll_qe_hp_pri3_rclk_rst_n)
    ,.re                      (rf_aqed_ll_qe_hp_pri3_re)
    ,.raddr                   (rf_aqed_ll_qe_hp_pri3_raddr)
    ,.rdata                   (rf_aqed_ll_qe_hp_pri3_rdata)

    ,.pgcb_isol_en            (rf_aqed_ll_qe_hp_pri3_isol_en)
    ,.pwr_enable_b_in         (rf_aqed_ll_qe_hp_pri3_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_aqed_ll_qe_hp_pri3_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_2048x14 i_rf_aqed_ll_qe_tp_pri0 (

     .wclk                    (rf_aqed_ll_qe_tp_pri0_wclk)
    ,.wclk_rst_n              (rf_aqed_ll_qe_tp_pri0_wclk_rst_n)
    ,.we                      (rf_aqed_ll_qe_tp_pri0_we)
    ,.waddr                   (rf_aqed_ll_qe_tp_pri0_waddr)
    ,.wdata                   (rf_aqed_ll_qe_tp_pri0_wdata)
    ,.rclk                    (rf_aqed_ll_qe_tp_pri0_rclk)
    ,.rclk_rst_n              (rf_aqed_ll_qe_tp_pri0_rclk_rst_n)
    ,.re                      (rf_aqed_ll_qe_tp_pri0_re)
    ,.raddr                   (rf_aqed_ll_qe_tp_pri0_raddr)
    ,.rdata                   (rf_aqed_ll_qe_tp_pri0_rdata)

    ,.pgcb_isol_en            (rf_aqed_ll_qe_tp_pri0_isol_en)
    ,.pwr_enable_b_in         (rf_aqed_ll_qe_tp_pri0_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_aqed_ll_qe_tp_pri0_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_2048x14 i_rf_aqed_ll_qe_tp_pri1 (

     .wclk                    (rf_aqed_ll_qe_tp_pri1_wclk)
    ,.wclk_rst_n              (rf_aqed_ll_qe_tp_pri1_wclk_rst_n)
    ,.we                      (rf_aqed_ll_qe_tp_pri1_we)
    ,.waddr                   (rf_aqed_ll_qe_tp_pri1_waddr)
    ,.wdata                   (rf_aqed_ll_qe_tp_pri1_wdata)
    ,.rclk                    (rf_aqed_ll_qe_tp_pri1_rclk)
    ,.rclk_rst_n              (rf_aqed_ll_qe_tp_pri1_rclk_rst_n)
    ,.re                      (rf_aqed_ll_qe_tp_pri1_re)
    ,.raddr                   (rf_aqed_ll_qe_tp_pri1_raddr)
    ,.rdata                   (rf_aqed_ll_qe_tp_pri1_rdata)

    ,.pgcb_isol_en            (rf_aqed_ll_qe_tp_pri1_isol_en)
    ,.pwr_enable_b_in         (rf_aqed_ll_qe_tp_pri1_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_aqed_ll_qe_tp_pri1_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_2048x14 i_rf_aqed_ll_qe_tp_pri2 (

     .wclk                    (rf_aqed_ll_qe_tp_pri2_wclk)
    ,.wclk_rst_n              (rf_aqed_ll_qe_tp_pri2_wclk_rst_n)
    ,.we                      (rf_aqed_ll_qe_tp_pri2_we)
    ,.waddr                   (rf_aqed_ll_qe_tp_pri2_waddr)
    ,.wdata                   (rf_aqed_ll_qe_tp_pri2_wdata)
    ,.rclk                    (rf_aqed_ll_qe_tp_pri2_rclk)
    ,.rclk_rst_n              (rf_aqed_ll_qe_tp_pri2_rclk_rst_n)
    ,.re                      (rf_aqed_ll_qe_tp_pri2_re)
    ,.raddr                   (rf_aqed_ll_qe_tp_pri2_raddr)
    ,.rdata                   (rf_aqed_ll_qe_tp_pri2_rdata)

    ,.pgcb_isol_en            (rf_aqed_ll_qe_tp_pri2_isol_en)
    ,.pwr_enable_b_in         (rf_aqed_ll_qe_tp_pri2_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_aqed_ll_qe_tp_pri2_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_2048x14 i_rf_aqed_ll_qe_tp_pri3 (

     .wclk                    (rf_aqed_ll_qe_tp_pri3_wclk)
    ,.wclk_rst_n              (rf_aqed_ll_qe_tp_pri3_wclk_rst_n)
    ,.we                      (rf_aqed_ll_qe_tp_pri3_we)
    ,.waddr                   (rf_aqed_ll_qe_tp_pri3_waddr)
    ,.wdata                   (rf_aqed_ll_qe_tp_pri3_wdata)
    ,.rclk                    (rf_aqed_ll_qe_tp_pri3_rclk)
    ,.rclk_rst_n              (rf_aqed_ll_qe_tp_pri3_rclk_rst_n)
    ,.re                      (rf_aqed_ll_qe_tp_pri3_re)
    ,.raddr                   (rf_aqed_ll_qe_tp_pri3_raddr)
    ,.rdata                   (rf_aqed_ll_qe_tp_pri3_rdata)

    ,.pgcb_isol_en            (rf_aqed_ll_qe_tp_pri3_isol_en)
    ,.pwr_enable_b_in         (rf_aqed_ll_qe_tp_pri3_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_aqed_ll_qe_tp_pri3_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_24x9 i_rf_aqed_lsp_deq_fifo_mem (

     .wclk                    (rf_aqed_lsp_deq_fifo_mem_wclk)
    ,.wclk_rst_n              (rf_aqed_lsp_deq_fifo_mem_wclk_rst_n)
    ,.we                      (rf_aqed_lsp_deq_fifo_mem_we)
    ,.waddr                   (rf_aqed_lsp_deq_fifo_mem_waddr)
    ,.wdata                   (rf_aqed_lsp_deq_fifo_mem_wdata)
    ,.rclk                    (rf_aqed_lsp_deq_fifo_mem_rclk)
    ,.rclk_rst_n              (rf_aqed_lsp_deq_fifo_mem_rclk_rst_n)
    ,.re                      (rf_aqed_lsp_deq_fifo_mem_re)
    ,.raddr                   (rf_aqed_lsp_deq_fifo_mem_raddr)
    ,.rdata                   (rf_aqed_lsp_deq_fifo_mem_rdata)

    ,.pgcb_isol_en            (rf_aqed_lsp_deq_fifo_mem_isol_en)
    ,.pwr_enable_b_in         (rf_aqed_lsp_deq_fifo_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_aqed_lsp_deq_fifo_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_32x528 i_rf_aqed_qid2cqidix (

     .wclk                    (rf_aqed_qid2cqidix_wclk)
    ,.wclk_rst_n              (rf_aqed_qid2cqidix_wclk_rst_n)
    ,.we                      (rf_aqed_qid2cqidix_we)
    ,.waddr                   (rf_aqed_qid2cqidix_waddr)
    ,.wdata                   (rf_aqed_qid2cqidix_wdata)
    ,.rclk                    (rf_aqed_qid2cqidix_rclk)
    ,.rclk_rst_n              (rf_aqed_qid2cqidix_rclk_rst_n)
    ,.re                      (rf_aqed_qid2cqidix_re)
    ,.raddr                   (rf_aqed_qid2cqidix_raddr)
    ,.rdata                   (rf_aqed_qid2cqidix_rdata)

    ,.pgcb_isol_en            (rf_aqed_qid2cqidix_isol_en)
    ,.pwr_enable_b_in         (rf_aqed_qid2cqidix_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_aqed_qid2cqidix_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_32x15 i_rf_aqed_qid_cnt (

     .wclk                    (rf_aqed_qid_cnt_wclk)
    ,.wclk_rst_n              (rf_aqed_qid_cnt_wclk_rst_n)
    ,.we                      (rf_aqed_qid_cnt_we)
    ,.waddr                   (rf_aqed_qid_cnt_waddr)
    ,.wdata                   (rf_aqed_qid_cnt_wdata)
    ,.rclk                    (rf_aqed_qid_cnt_rclk)
    ,.rclk_rst_n              (rf_aqed_qid_cnt_rclk_rst_n)
    ,.re                      (rf_aqed_qid_cnt_re)
    ,.raddr                   (rf_aqed_qid_cnt_raddr)
    ,.rdata                   (rf_aqed_qid_cnt_rdata)

    ,.pgcb_isol_en            (rf_aqed_qid_cnt_isol_en)
    ,.pwr_enable_b_in         (rf_aqed_qid_cnt_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_aqed_qid_cnt_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_32x14 i_rf_aqed_qid_fid_limit (

     .wclk                    (rf_aqed_qid_fid_limit_wclk)
    ,.wclk_rst_n              (rf_aqed_qid_fid_limit_wclk_rst_n)
    ,.we                      (rf_aqed_qid_fid_limit_we)
    ,.waddr                   (rf_aqed_qid_fid_limit_waddr)
    ,.wdata                   (rf_aqed_qid_fid_limit_wdata)
    ,.rclk                    (rf_aqed_qid_fid_limit_rclk)
    ,.rclk_rst_n              (rf_aqed_qid_fid_limit_rclk_rst_n)
    ,.re                      (rf_aqed_qid_fid_limit_re)
    ,.raddr                   (rf_aqed_qid_fid_limit_raddr)
    ,.rdata                   (rf_aqed_qid_fid_limit_rdata)

    ,.pgcb_isol_en            (rf_aqed_qid_fid_limit_isol_en)
    ,.pwr_enable_b_in         (rf_aqed_qid_fid_limit_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_aqed_qid_fid_limit_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_8x55 i_rf_atm_cmp_fifo_mem (

     .wclk                    (rf_atm_cmp_fifo_mem_wclk)
    ,.wclk_rst_n              (rf_atm_cmp_fifo_mem_wclk_rst_n)
    ,.we                      (rf_atm_cmp_fifo_mem_we)
    ,.waddr                   (rf_atm_cmp_fifo_mem_waddr)
    ,.wdata                   (rf_atm_cmp_fifo_mem_wdata)
    ,.rclk                    (rf_atm_cmp_fifo_mem_rclk)
    ,.rclk_rst_n              (rf_atm_cmp_fifo_mem_rclk_rst_n)
    ,.re                      (rf_atm_cmp_fifo_mem_re)
    ,.raddr                   (rf_atm_cmp_fifo_mem_raddr)
    ,.rdata                   (rf_atm_cmp_fifo_mem_rdata)

    ,.pgcb_isol_en            (rf_atm_cmp_fifo_mem_isol_en)
    ,.pwr_enable_b_in         (rf_atm_cmp_fifo_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_atm_cmp_fifo_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_16x45 i_rf_atm_fifo_ap_aqed (

     .wclk                    (rf_atm_fifo_ap_aqed_wclk)
    ,.wclk_rst_n              (rf_atm_fifo_ap_aqed_wclk_rst_n)
    ,.we                      (rf_atm_fifo_ap_aqed_we)
    ,.waddr                   (rf_atm_fifo_ap_aqed_waddr)
    ,.wdata                   (rf_atm_fifo_ap_aqed_wdata)
    ,.rclk                    (rf_atm_fifo_ap_aqed_rclk)
    ,.rclk_rst_n              (rf_atm_fifo_ap_aqed_rclk_rst_n)
    ,.re                      (rf_atm_fifo_ap_aqed_re)
    ,.raddr                   (rf_atm_fifo_ap_aqed_raddr)
    ,.rdata                   (rf_atm_fifo_ap_aqed_rdata)

    ,.pgcb_isol_en            (rf_atm_fifo_ap_aqed_isol_en)
    ,.pwr_enable_b_in         (rf_atm_fifo_ap_aqed_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_atm_fifo_ap_aqed_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_32x24 i_rf_atm_fifo_aqed_ap_enq (

     .wclk                    (rf_atm_fifo_aqed_ap_enq_wclk)
    ,.wclk_rst_n              (rf_atm_fifo_aqed_ap_enq_wclk_rst_n)
    ,.we                      (rf_atm_fifo_aqed_ap_enq_we)
    ,.waddr                   (rf_atm_fifo_aqed_ap_enq_waddr)
    ,.wdata                   (rf_atm_fifo_aqed_ap_enq_wdata)
    ,.rclk                    (rf_atm_fifo_aqed_ap_enq_rclk)
    ,.rclk_rst_n              (rf_atm_fifo_aqed_ap_enq_rclk_rst_n)
    ,.re                      (rf_atm_fifo_aqed_ap_enq_re)
    ,.raddr                   (rf_atm_fifo_aqed_ap_enq_raddr)
    ,.rdata                   (rf_atm_fifo_aqed_ap_enq_rdata)

    ,.pgcb_isol_en            (rf_atm_fifo_aqed_ap_enq_isol_en)
    ,.pwr_enable_b_in         (rf_atm_fifo_aqed_ap_enq_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_atm_fifo_aqed_ap_enq_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_32x16 i_rf_cfg_atm_qid_dpth_thrsh_mem (

     .wclk                    (rf_cfg_atm_qid_dpth_thrsh_mem_wclk)
    ,.wclk_rst_n              (rf_cfg_atm_qid_dpth_thrsh_mem_wclk_rst_n)
    ,.we                      (rf_cfg_atm_qid_dpth_thrsh_mem_we)
    ,.waddr                   (rf_cfg_atm_qid_dpth_thrsh_mem_waddr)
    ,.wdata                   (rf_cfg_atm_qid_dpth_thrsh_mem_wdata)
    ,.rclk                    (rf_cfg_atm_qid_dpth_thrsh_mem_rclk)
    ,.rclk_rst_n              (rf_cfg_atm_qid_dpth_thrsh_mem_rclk_rst_n)
    ,.re                      (rf_cfg_atm_qid_dpth_thrsh_mem_re)
    ,.raddr                   (rf_cfg_atm_qid_dpth_thrsh_mem_raddr)
    ,.rdata                   (rf_cfg_atm_qid_dpth_thrsh_mem_rdata)

    ,.pgcb_isol_en            (rf_cfg_atm_qid_dpth_thrsh_mem_isol_en)
    ,.pwr_enable_b_in         (rf_cfg_atm_qid_dpth_thrsh_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_cfg_atm_qid_dpth_thrsh_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_32x33 i_rf_cfg_cq2priov_mem (

     .wclk                    (rf_cfg_cq2priov_mem_wclk)
    ,.wclk_rst_n              (rf_cfg_cq2priov_mem_wclk_rst_n)
    ,.we                      (rf_cfg_cq2priov_mem_we)
    ,.waddr                   (rf_cfg_cq2priov_mem_waddr)
    ,.wdata                   (rf_cfg_cq2priov_mem_wdata)
    ,.rclk                    (rf_cfg_cq2priov_mem_rclk)
    ,.rclk_rst_n              (rf_cfg_cq2priov_mem_rclk_rst_n)
    ,.re                      (rf_cfg_cq2priov_mem_re)
    ,.raddr                   (rf_cfg_cq2priov_mem_raddr)
    ,.rdata                   (rf_cfg_cq2priov_mem_rdata)

    ,.pgcb_isol_en            (rf_cfg_cq2priov_mem_isol_en)
    ,.pwr_enable_b_in         (rf_cfg_cq2priov_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_cfg_cq2priov_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_32x33 i_rf_cfg_cq2priov_odd_mem (

     .wclk                    (rf_cfg_cq2priov_odd_mem_wclk)
    ,.wclk_rst_n              (rf_cfg_cq2priov_odd_mem_wclk_rst_n)
    ,.we                      (rf_cfg_cq2priov_odd_mem_we)
    ,.waddr                   (rf_cfg_cq2priov_odd_mem_waddr)
    ,.wdata                   (rf_cfg_cq2priov_odd_mem_wdata)
    ,.rclk                    (rf_cfg_cq2priov_odd_mem_rclk)
    ,.rclk_rst_n              (rf_cfg_cq2priov_odd_mem_rclk_rst_n)
    ,.re                      (rf_cfg_cq2priov_odd_mem_re)
    ,.raddr                   (rf_cfg_cq2priov_odd_mem_raddr)
    ,.rdata                   (rf_cfg_cq2priov_odd_mem_rdata)

    ,.pgcb_isol_en            (rf_cfg_cq2priov_odd_mem_isol_en)
    ,.pwr_enable_b_in         (rf_cfg_cq2priov_odd_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_cfg_cq2priov_odd_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_32x29 i_rf_cfg_cq2qid_0_mem (

     .wclk                    (rf_cfg_cq2qid_0_mem_wclk)
    ,.wclk_rst_n              (rf_cfg_cq2qid_0_mem_wclk_rst_n)
    ,.we                      (rf_cfg_cq2qid_0_mem_we)
    ,.waddr                   (rf_cfg_cq2qid_0_mem_waddr)
    ,.wdata                   (rf_cfg_cq2qid_0_mem_wdata)
    ,.rclk                    (rf_cfg_cq2qid_0_mem_rclk)
    ,.rclk_rst_n              (rf_cfg_cq2qid_0_mem_rclk_rst_n)
    ,.re                      (rf_cfg_cq2qid_0_mem_re)
    ,.raddr                   (rf_cfg_cq2qid_0_mem_raddr)
    ,.rdata                   (rf_cfg_cq2qid_0_mem_rdata)

    ,.pgcb_isol_en            (rf_cfg_cq2qid_0_mem_isol_en)
    ,.pwr_enable_b_in         (rf_cfg_cq2qid_0_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_cfg_cq2qid_0_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_32x29 i_rf_cfg_cq2qid_0_odd_mem (

     .wclk                    (rf_cfg_cq2qid_0_odd_mem_wclk)
    ,.wclk_rst_n              (rf_cfg_cq2qid_0_odd_mem_wclk_rst_n)
    ,.we                      (rf_cfg_cq2qid_0_odd_mem_we)
    ,.waddr                   (rf_cfg_cq2qid_0_odd_mem_waddr)
    ,.wdata                   (rf_cfg_cq2qid_0_odd_mem_wdata)
    ,.rclk                    (rf_cfg_cq2qid_0_odd_mem_rclk)
    ,.rclk_rst_n              (rf_cfg_cq2qid_0_odd_mem_rclk_rst_n)
    ,.re                      (rf_cfg_cq2qid_0_odd_mem_re)
    ,.raddr                   (rf_cfg_cq2qid_0_odd_mem_raddr)
    ,.rdata                   (rf_cfg_cq2qid_0_odd_mem_rdata)

    ,.pgcb_isol_en            (rf_cfg_cq2qid_0_odd_mem_isol_en)
    ,.pwr_enable_b_in         (rf_cfg_cq2qid_0_odd_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_cfg_cq2qid_0_odd_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_32x29 i_rf_cfg_cq2qid_1_mem (

     .wclk                    (rf_cfg_cq2qid_1_mem_wclk)
    ,.wclk_rst_n              (rf_cfg_cq2qid_1_mem_wclk_rst_n)
    ,.we                      (rf_cfg_cq2qid_1_mem_we)
    ,.waddr                   (rf_cfg_cq2qid_1_mem_waddr)
    ,.wdata                   (rf_cfg_cq2qid_1_mem_wdata)
    ,.rclk                    (rf_cfg_cq2qid_1_mem_rclk)
    ,.rclk_rst_n              (rf_cfg_cq2qid_1_mem_rclk_rst_n)
    ,.re                      (rf_cfg_cq2qid_1_mem_re)
    ,.raddr                   (rf_cfg_cq2qid_1_mem_raddr)
    ,.rdata                   (rf_cfg_cq2qid_1_mem_rdata)

    ,.pgcb_isol_en            (rf_cfg_cq2qid_1_mem_isol_en)
    ,.pwr_enable_b_in         (rf_cfg_cq2qid_1_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_cfg_cq2qid_1_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_32x29 i_rf_cfg_cq2qid_1_odd_mem (

     .wclk                    (rf_cfg_cq2qid_1_odd_mem_wclk)
    ,.wclk_rst_n              (rf_cfg_cq2qid_1_odd_mem_wclk_rst_n)
    ,.we                      (rf_cfg_cq2qid_1_odd_mem_we)
    ,.waddr                   (rf_cfg_cq2qid_1_odd_mem_waddr)
    ,.wdata                   (rf_cfg_cq2qid_1_odd_mem_wdata)
    ,.rclk                    (rf_cfg_cq2qid_1_odd_mem_rclk)
    ,.rclk_rst_n              (rf_cfg_cq2qid_1_odd_mem_rclk_rst_n)
    ,.re                      (rf_cfg_cq2qid_1_odd_mem_re)
    ,.raddr                   (rf_cfg_cq2qid_1_odd_mem_raddr)
    ,.rdata                   (rf_cfg_cq2qid_1_odd_mem_rdata)

    ,.pgcb_isol_en            (rf_cfg_cq2qid_1_odd_mem_isol_en)
    ,.pwr_enable_b_in         (rf_cfg_cq2qid_1_odd_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_cfg_cq2qid_1_odd_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_64x14 i_rf_cfg_cq_ldb_inflight_limit_mem (

     .wclk                    (rf_cfg_cq_ldb_inflight_limit_mem_wclk)
    ,.wclk_rst_n              (rf_cfg_cq_ldb_inflight_limit_mem_wclk_rst_n)
    ,.we                      (rf_cfg_cq_ldb_inflight_limit_mem_we)
    ,.waddr                   (rf_cfg_cq_ldb_inflight_limit_mem_waddr)
    ,.wdata                   (rf_cfg_cq_ldb_inflight_limit_mem_wdata)
    ,.rclk                    (rf_cfg_cq_ldb_inflight_limit_mem_rclk)
    ,.rclk_rst_n              (rf_cfg_cq_ldb_inflight_limit_mem_rclk_rst_n)
    ,.re                      (rf_cfg_cq_ldb_inflight_limit_mem_re)
    ,.raddr                   (rf_cfg_cq_ldb_inflight_limit_mem_raddr)
    ,.rdata                   (rf_cfg_cq_ldb_inflight_limit_mem_rdata)

    ,.pgcb_isol_en            (rf_cfg_cq_ldb_inflight_limit_mem_isol_en)
    ,.pwr_enable_b_in         (rf_cfg_cq_ldb_inflight_limit_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_cfg_cq_ldb_inflight_limit_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_64x14 i_rf_cfg_cq_ldb_inflight_threshold_mem (

     .wclk                    (rf_cfg_cq_ldb_inflight_threshold_mem_wclk)
    ,.wclk_rst_n              (rf_cfg_cq_ldb_inflight_threshold_mem_wclk_rst_n)
    ,.we                      (rf_cfg_cq_ldb_inflight_threshold_mem_we)
    ,.waddr                   (rf_cfg_cq_ldb_inflight_threshold_mem_waddr)
    ,.wdata                   (rf_cfg_cq_ldb_inflight_threshold_mem_wdata)
    ,.rclk                    (rf_cfg_cq_ldb_inflight_threshold_mem_rclk)
    ,.rclk_rst_n              (rf_cfg_cq_ldb_inflight_threshold_mem_rclk_rst_n)
    ,.re                      (rf_cfg_cq_ldb_inflight_threshold_mem_re)
    ,.raddr                   (rf_cfg_cq_ldb_inflight_threshold_mem_raddr)
    ,.rdata                   (rf_cfg_cq_ldb_inflight_threshold_mem_rdata)

    ,.pgcb_isol_en            (rf_cfg_cq_ldb_inflight_threshold_mem_isol_en)
    ,.pwr_enable_b_in         (rf_cfg_cq_ldb_inflight_threshold_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_cfg_cq_ldb_inflight_threshold_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_64x5 i_rf_cfg_cq_ldb_token_depth_select_mem (

     .wclk                    (rf_cfg_cq_ldb_token_depth_select_mem_wclk)
    ,.wclk_rst_n              (rf_cfg_cq_ldb_token_depth_select_mem_wclk_rst_n)
    ,.we                      (rf_cfg_cq_ldb_token_depth_select_mem_we)
    ,.waddr                   (rf_cfg_cq_ldb_token_depth_select_mem_waddr)
    ,.wdata                   (rf_cfg_cq_ldb_token_depth_select_mem_wdata)
    ,.rclk                    (rf_cfg_cq_ldb_token_depth_select_mem_rclk)
    ,.rclk_rst_n              (rf_cfg_cq_ldb_token_depth_select_mem_rclk_rst_n)
    ,.re                      (rf_cfg_cq_ldb_token_depth_select_mem_re)
    ,.raddr                   (rf_cfg_cq_ldb_token_depth_select_mem_raddr)
    ,.rdata                   (rf_cfg_cq_ldb_token_depth_select_mem_rdata)

    ,.pgcb_isol_en            (rf_cfg_cq_ldb_token_depth_select_mem_isol_en)
    ,.pwr_enable_b_in         (rf_cfg_cq_ldb_token_depth_select_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_cfg_cq_ldb_token_depth_select_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_64x17 i_rf_cfg_cq_ldb_wu_limit_mem (

     .wclk                    (rf_cfg_cq_ldb_wu_limit_mem_wclk)
    ,.wclk_rst_n              (rf_cfg_cq_ldb_wu_limit_mem_wclk_rst_n)
    ,.we                      (rf_cfg_cq_ldb_wu_limit_mem_we)
    ,.waddr                   (rf_cfg_cq_ldb_wu_limit_mem_waddr)
    ,.wdata                   (rf_cfg_cq_ldb_wu_limit_mem_wdata)
    ,.rclk                    (rf_cfg_cq_ldb_wu_limit_mem_rclk)
    ,.rclk_rst_n              (rf_cfg_cq_ldb_wu_limit_mem_rclk_rst_n)
    ,.re                      (rf_cfg_cq_ldb_wu_limit_mem_re)
    ,.raddr                   (rf_cfg_cq_ldb_wu_limit_mem_raddr)
    ,.rdata                   (rf_cfg_cq_ldb_wu_limit_mem_rdata)

    ,.pgcb_isol_en            (rf_cfg_cq_ldb_wu_limit_mem_isol_en)
    ,.pwr_enable_b_in         (rf_cfg_cq_ldb_wu_limit_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_cfg_cq_ldb_wu_limit_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_64x16 i_rf_cfg_dir_qid_dpth_thrsh_mem (

     .wclk                    (rf_cfg_dir_qid_dpth_thrsh_mem_wclk)
    ,.wclk_rst_n              (rf_cfg_dir_qid_dpth_thrsh_mem_wclk_rst_n)
    ,.we                      (rf_cfg_dir_qid_dpth_thrsh_mem_we)
    ,.waddr                   (rf_cfg_dir_qid_dpth_thrsh_mem_waddr)
    ,.wdata                   (rf_cfg_dir_qid_dpth_thrsh_mem_wdata)
    ,.rclk                    (rf_cfg_dir_qid_dpth_thrsh_mem_rclk)
    ,.rclk_rst_n              (rf_cfg_dir_qid_dpth_thrsh_mem_rclk_rst_n)
    ,.re                      (rf_cfg_dir_qid_dpth_thrsh_mem_re)
    ,.raddr                   (rf_cfg_dir_qid_dpth_thrsh_mem_raddr)
    ,.rdata                   (rf_cfg_dir_qid_dpth_thrsh_mem_rdata)

    ,.pgcb_isol_en            (rf_cfg_dir_qid_dpth_thrsh_mem_isol_en)
    ,.pwr_enable_b_in         (rf_cfg_dir_qid_dpth_thrsh_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_cfg_dir_qid_dpth_thrsh_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_32x16 i_rf_cfg_nalb_qid_dpth_thrsh_mem (

     .wclk                    (rf_cfg_nalb_qid_dpth_thrsh_mem_wclk)
    ,.wclk_rst_n              (rf_cfg_nalb_qid_dpth_thrsh_mem_wclk_rst_n)
    ,.we                      (rf_cfg_nalb_qid_dpth_thrsh_mem_we)
    ,.waddr                   (rf_cfg_nalb_qid_dpth_thrsh_mem_waddr)
    ,.wdata                   (rf_cfg_nalb_qid_dpth_thrsh_mem_wdata)
    ,.rclk                    (rf_cfg_nalb_qid_dpth_thrsh_mem_rclk)
    ,.rclk_rst_n              (rf_cfg_nalb_qid_dpth_thrsh_mem_rclk_rst_n)
    ,.re                      (rf_cfg_nalb_qid_dpth_thrsh_mem_re)
    ,.raddr                   (rf_cfg_nalb_qid_dpth_thrsh_mem_raddr)
    ,.rdata                   (rf_cfg_nalb_qid_dpth_thrsh_mem_rdata)

    ,.pgcb_isol_en            (rf_cfg_nalb_qid_dpth_thrsh_mem_isol_en)
    ,.pwr_enable_b_in         (rf_cfg_nalb_qid_dpth_thrsh_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_cfg_nalb_qid_dpth_thrsh_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_32x13 i_rf_cfg_qid_aqed_active_limit_mem (

     .wclk                    (rf_cfg_qid_aqed_active_limit_mem_wclk)
    ,.wclk_rst_n              (rf_cfg_qid_aqed_active_limit_mem_wclk_rst_n)
    ,.we                      (rf_cfg_qid_aqed_active_limit_mem_we)
    ,.waddr                   (rf_cfg_qid_aqed_active_limit_mem_waddr)
    ,.wdata                   (rf_cfg_qid_aqed_active_limit_mem_wdata)
    ,.rclk                    (rf_cfg_qid_aqed_active_limit_mem_rclk)
    ,.rclk_rst_n              (rf_cfg_qid_aqed_active_limit_mem_rclk_rst_n)
    ,.re                      (rf_cfg_qid_aqed_active_limit_mem_re)
    ,.raddr                   (rf_cfg_qid_aqed_active_limit_mem_raddr)
    ,.rdata                   (rf_cfg_qid_aqed_active_limit_mem_rdata)

    ,.pgcb_isol_en            (rf_cfg_qid_aqed_active_limit_mem_isol_en)
    ,.pwr_enable_b_in         (rf_cfg_qid_aqed_active_limit_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_cfg_qid_aqed_active_limit_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_32x13 i_rf_cfg_qid_ldb_inflight_limit_mem (

     .wclk                    (rf_cfg_qid_ldb_inflight_limit_mem_wclk)
    ,.wclk_rst_n              (rf_cfg_qid_ldb_inflight_limit_mem_wclk_rst_n)
    ,.we                      (rf_cfg_qid_ldb_inflight_limit_mem_we)
    ,.waddr                   (rf_cfg_qid_ldb_inflight_limit_mem_waddr)
    ,.wdata                   (rf_cfg_qid_ldb_inflight_limit_mem_wdata)
    ,.rclk                    (rf_cfg_qid_ldb_inflight_limit_mem_rclk)
    ,.rclk_rst_n              (rf_cfg_qid_ldb_inflight_limit_mem_rclk_rst_n)
    ,.re                      (rf_cfg_qid_ldb_inflight_limit_mem_re)
    ,.raddr                   (rf_cfg_qid_ldb_inflight_limit_mem_raddr)
    ,.rdata                   (rf_cfg_qid_ldb_inflight_limit_mem_rdata)

    ,.pgcb_isol_en            (rf_cfg_qid_ldb_inflight_limit_mem_isol_en)
    ,.pwr_enable_b_in         (rf_cfg_qid_ldb_inflight_limit_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_cfg_qid_ldb_inflight_limit_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_32x528 i_rf_cfg_qid_ldb_qid2cqidix2_mem (

     .wclk                    (rf_cfg_qid_ldb_qid2cqidix2_mem_wclk)
    ,.wclk_rst_n              (rf_cfg_qid_ldb_qid2cqidix2_mem_wclk_rst_n)
    ,.we                      (rf_cfg_qid_ldb_qid2cqidix2_mem_we)
    ,.waddr                   (rf_cfg_qid_ldb_qid2cqidix2_mem_waddr)
    ,.wdata                   (rf_cfg_qid_ldb_qid2cqidix2_mem_wdata)
    ,.rclk                    (rf_cfg_qid_ldb_qid2cqidix2_mem_rclk)
    ,.rclk_rst_n              (rf_cfg_qid_ldb_qid2cqidix2_mem_rclk_rst_n)
    ,.re                      (rf_cfg_qid_ldb_qid2cqidix2_mem_re)
    ,.raddr                   (rf_cfg_qid_ldb_qid2cqidix2_mem_raddr)
    ,.rdata                   (rf_cfg_qid_ldb_qid2cqidix2_mem_rdata)

    ,.pgcb_isol_en            (rf_cfg_qid_ldb_qid2cqidix2_mem_isol_en)
    ,.pwr_enable_b_in         (rf_cfg_qid_ldb_qid2cqidix2_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_cfg_qid_ldb_qid2cqidix2_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_32x528 i_rf_cfg_qid_ldb_qid2cqidix_mem (

     .wclk                    (rf_cfg_qid_ldb_qid2cqidix_mem_wclk)
    ,.wclk_rst_n              (rf_cfg_qid_ldb_qid2cqidix_mem_wclk_rst_n)
    ,.we                      (rf_cfg_qid_ldb_qid2cqidix_mem_we)
    ,.waddr                   (rf_cfg_qid_ldb_qid2cqidix_mem_waddr)
    ,.wdata                   (rf_cfg_qid_ldb_qid2cqidix_mem_wdata)
    ,.rclk                    (rf_cfg_qid_ldb_qid2cqidix_mem_rclk)
    ,.rclk_rst_n              (rf_cfg_qid_ldb_qid2cqidix_mem_rclk_rst_n)
    ,.re                      (rf_cfg_qid_ldb_qid2cqidix_mem_re)
    ,.raddr                   (rf_cfg_qid_ldb_qid2cqidix_mem_raddr)
    ,.rdata                   (rf_cfg_qid_ldb_qid2cqidix_mem_rdata)

    ,.pgcb_isol_en            (rf_cfg_qid_ldb_qid2cqidix_mem_isol_en)
    ,.pwr_enable_b_in         (rf_cfg_qid_ldb_qid2cqidix_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_cfg_qid_ldb_qid2cqidix_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_4x73 i_rf_chp_lsp_cmp_rx_sync_fifo_mem (

     .wclk                    (rf_chp_lsp_cmp_rx_sync_fifo_mem_wclk)
    ,.wclk_rst_n              (rf_chp_lsp_cmp_rx_sync_fifo_mem_wclk_rst_n)
    ,.we                      (rf_chp_lsp_cmp_rx_sync_fifo_mem_we)
    ,.waddr                   (rf_chp_lsp_cmp_rx_sync_fifo_mem_waddr)
    ,.wdata                   (rf_chp_lsp_cmp_rx_sync_fifo_mem_wdata)
    ,.rclk                    (rf_chp_lsp_cmp_rx_sync_fifo_mem_rclk)
    ,.rclk_rst_n              (rf_chp_lsp_cmp_rx_sync_fifo_mem_rclk_rst_n)
    ,.re                      (rf_chp_lsp_cmp_rx_sync_fifo_mem_re)
    ,.raddr                   (rf_chp_lsp_cmp_rx_sync_fifo_mem_raddr)
    ,.rdata                   (rf_chp_lsp_cmp_rx_sync_fifo_mem_rdata)

    ,.pgcb_isol_en            (rf_chp_lsp_cmp_rx_sync_fifo_mem_isol_en)
    ,.pwr_enable_b_in         (rf_chp_lsp_cmp_rx_sync_fifo_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_chp_lsp_cmp_rx_sync_fifo_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_4x25 i_rf_chp_lsp_token_rx_sync_fifo_mem (

     .wclk                    (rf_chp_lsp_token_rx_sync_fifo_mem_wclk)
    ,.wclk_rst_n              (rf_chp_lsp_token_rx_sync_fifo_mem_wclk_rst_n)
    ,.we                      (rf_chp_lsp_token_rx_sync_fifo_mem_we)
    ,.waddr                   (rf_chp_lsp_token_rx_sync_fifo_mem_waddr)
    ,.wdata                   (rf_chp_lsp_token_rx_sync_fifo_mem_wdata)
    ,.rclk                    (rf_chp_lsp_token_rx_sync_fifo_mem_rclk)
    ,.rclk_rst_n              (rf_chp_lsp_token_rx_sync_fifo_mem_rclk_rst_n)
    ,.re                      (rf_chp_lsp_token_rx_sync_fifo_mem_re)
    ,.raddr                   (rf_chp_lsp_token_rx_sync_fifo_mem_raddr)
    ,.rdata                   (rf_chp_lsp_token_rx_sync_fifo_mem_rdata)

    ,.pgcb_isol_en            (rf_chp_lsp_token_rx_sync_fifo_mem_isol_en)
    ,.pwr_enable_b_in         (rf_chp_lsp_token_rx_sync_fifo_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_chp_lsp_token_rx_sync_fifo_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_32x96 i_rf_cq_atm_pri_arbindex_mem (

     .wclk                    (rf_cq_atm_pri_arbindex_mem_wclk)
    ,.wclk_rst_n              (rf_cq_atm_pri_arbindex_mem_wclk_rst_n)
    ,.we                      (rf_cq_atm_pri_arbindex_mem_we)
    ,.waddr                   (rf_cq_atm_pri_arbindex_mem_waddr)
    ,.wdata                   (rf_cq_atm_pri_arbindex_mem_wdata)
    ,.rclk                    (rf_cq_atm_pri_arbindex_mem_rclk)
    ,.rclk_rst_n              (rf_cq_atm_pri_arbindex_mem_rclk_rst_n)
    ,.re                      (rf_cq_atm_pri_arbindex_mem_re)
    ,.raddr                   (rf_cq_atm_pri_arbindex_mem_raddr)
    ,.rdata                   (rf_cq_atm_pri_arbindex_mem_rdata)

    ,.pgcb_isol_en            (rf_cq_atm_pri_arbindex_mem_isol_en)
    ,.pwr_enable_b_in         (rf_cq_atm_pri_arbindex_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_cq_atm_pri_arbindex_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_64x66 i_rf_cq_dir_tot_sch_cnt_mem (

     .wclk                    (rf_cq_dir_tot_sch_cnt_mem_wclk)
    ,.wclk_rst_n              (rf_cq_dir_tot_sch_cnt_mem_wclk_rst_n)
    ,.we                      (rf_cq_dir_tot_sch_cnt_mem_we)
    ,.waddr                   (rf_cq_dir_tot_sch_cnt_mem_waddr)
    ,.wdata                   (rf_cq_dir_tot_sch_cnt_mem_wdata)
    ,.rclk                    (rf_cq_dir_tot_sch_cnt_mem_rclk)
    ,.rclk_rst_n              (rf_cq_dir_tot_sch_cnt_mem_rclk_rst_n)
    ,.re                      (rf_cq_dir_tot_sch_cnt_mem_re)
    ,.raddr                   (rf_cq_dir_tot_sch_cnt_mem_raddr)
    ,.rdata                   (rf_cq_dir_tot_sch_cnt_mem_rdata)

    ,.pgcb_isol_en            (rf_cq_dir_tot_sch_cnt_mem_isol_en)
    ,.pwr_enable_b_in         (rf_cq_dir_tot_sch_cnt_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_cq_dir_tot_sch_cnt_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_64x15 i_rf_cq_ldb_inflight_count_mem (

     .wclk                    (rf_cq_ldb_inflight_count_mem_wclk)
    ,.wclk_rst_n              (rf_cq_ldb_inflight_count_mem_wclk_rst_n)
    ,.we                      (rf_cq_ldb_inflight_count_mem_we)
    ,.waddr                   (rf_cq_ldb_inflight_count_mem_waddr)
    ,.wdata                   (rf_cq_ldb_inflight_count_mem_wdata)
    ,.rclk                    (rf_cq_ldb_inflight_count_mem_rclk)
    ,.rclk_rst_n              (rf_cq_ldb_inflight_count_mem_rclk_rst_n)
    ,.re                      (rf_cq_ldb_inflight_count_mem_re)
    ,.raddr                   (rf_cq_ldb_inflight_count_mem_raddr)
    ,.rdata                   (rf_cq_ldb_inflight_count_mem_rdata)

    ,.pgcb_isol_en            (rf_cq_ldb_inflight_count_mem_isol_en)
    ,.pwr_enable_b_in         (rf_cq_ldb_inflight_count_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_cq_ldb_inflight_count_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_64x13 i_rf_cq_ldb_token_count_mem (

     .wclk                    (rf_cq_ldb_token_count_mem_wclk)
    ,.wclk_rst_n              (rf_cq_ldb_token_count_mem_wclk_rst_n)
    ,.we                      (rf_cq_ldb_token_count_mem_we)
    ,.waddr                   (rf_cq_ldb_token_count_mem_waddr)
    ,.wdata                   (rf_cq_ldb_token_count_mem_wdata)
    ,.rclk                    (rf_cq_ldb_token_count_mem_rclk)
    ,.rclk_rst_n              (rf_cq_ldb_token_count_mem_rclk_rst_n)
    ,.re                      (rf_cq_ldb_token_count_mem_re)
    ,.raddr                   (rf_cq_ldb_token_count_mem_raddr)
    ,.rdata                   (rf_cq_ldb_token_count_mem_rdata)

    ,.pgcb_isol_en            (rf_cq_ldb_token_count_mem_isol_en)
    ,.pwr_enable_b_in         (rf_cq_ldb_token_count_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_cq_ldb_token_count_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_64x66 i_rf_cq_ldb_tot_sch_cnt_mem (

     .wclk                    (rf_cq_ldb_tot_sch_cnt_mem_wclk)
    ,.wclk_rst_n              (rf_cq_ldb_tot_sch_cnt_mem_wclk_rst_n)
    ,.we                      (rf_cq_ldb_tot_sch_cnt_mem_we)
    ,.waddr                   (rf_cq_ldb_tot_sch_cnt_mem_waddr)
    ,.wdata                   (rf_cq_ldb_tot_sch_cnt_mem_wdata)
    ,.rclk                    (rf_cq_ldb_tot_sch_cnt_mem_rclk)
    ,.rclk_rst_n              (rf_cq_ldb_tot_sch_cnt_mem_rclk_rst_n)
    ,.re                      (rf_cq_ldb_tot_sch_cnt_mem_re)
    ,.raddr                   (rf_cq_ldb_tot_sch_cnt_mem_raddr)
    ,.rdata                   (rf_cq_ldb_tot_sch_cnt_mem_rdata)

    ,.pgcb_isol_en            (rf_cq_ldb_tot_sch_cnt_mem_isol_en)
    ,.pwr_enable_b_in         (rf_cq_ldb_tot_sch_cnt_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_cq_ldb_tot_sch_cnt_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_64x19 i_rf_cq_ldb_wu_count_mem (

     .wclk                    (rf_cq_ldb_wu_count_mem_wclk)
    ,.wclk_rst_n              (rf_cq_ldb_wu_count_mem_wclk_rst_n)
    ,.we                      (rf_cq_ldb_wu_count_mem_we)
    ,.waddr                   (rf_cq_ldb_wu_count_mem_waddr)
    ,.wdata                   (rf_cq_ldb_wu_count_mem_wdata)
    ,.rclk                    (rf_cq_ldb_wu_count_mem_rclk)
    ,.rclk_rst_n              (rf_cq_ldb_wu_count_mem_rclk_rst_n)
    ,.re                      (rf_cq_ldb_wu_count_mem_re)
    ,.raddr                   (rf_cq_ldb_wu_count_mem_raddr)
    ,.rdata                   (rf_cq_ldb_wu_count_mem_rdata)

    ,.pgcb_isol_en            (rf_cq_ldb_wu_count_mem_isol_en)
    ,.pwr_enable_b_in         (rf_cq_ldb_wu_count_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_cq_ldb_wu_count_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_32x96 i_rf_cq_nalb_pri_arbindex_mem (

     .wclk                    (rf_cq_nalb_pri_arbindex_mem_wclk)
    ,.wclk_rst_n              (rf_cq_nalb_pri_arbindex_mem_wclk_rst_n)
    ,.we                      (rf_cq_nalb_pri_arbindex_mem_we)
    ,.waddr                   (rf_cq_nalb_pri_arbindex_mem_waddr)
    ,.wdata                   (rf_cq_nalb_pri_arbindex_mem_wdata)
    ,.rclk                    (rf_cq_nalb_pri_arbindex_mem_rclk)
    ,.rclk_rst_n              (rf_cq_nalb_pri_arbindex_mem_rclk_rst_n)
    ,.re                      (rf_cq_nalb_pri_arbindex_mem_re)
    ,.raddr                   (rf_cq_nalb_pri_arbindex_mem_raddr)
    ,.rdata                   (rf_cq_nalb_pri_arbindex_mem_rdata)

    ,.pgcb_isol_en            (rf_cq_nalb_pri_arbindex_mem_isol_en)
    ,.pwr_enable_b_in         (rf_cq_nalb_pri_arbindex_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_cq_nalb_pri_arbindex_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_64x17 i_rf_dir_enq_cnt_mem (

     .wclk                    (rf_dir_enq_cnt_mem_wclk)
    ,.wclk_rst_n              (rf_dir_enq_cnt_mem_wclk_rst_n)
    ,.we                      (rf_dir_enq_cnt_mem_we)
    ,.waddr                   (rf_dir_enq_cnt_mem_waddr)
    ,.wdata                   (rf_dir_enq_cnt_mem_wdata)
    ,.rclk                    (rf_dir_enq_cnt_mem_rclk)
    ,.rclk_rst_n              (rf_dir_enq_cnt_mem_rclk_rst_n)
    ,.re                      (rf_dir_enq_cnt_mem_re)
    ,.raddr                   (rf_dir_enq_cnt_mem_raddr)
    ,.rdata                   (rf_dir_enq_cnt_mem_rdata)

    ,.pgcb_isol_en            (rf_dir_enq_cnt_mem_isol_en)
    ,.pwr_enable_b_in         (rf_dir_enq_cnt_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_dir_enq_cnt_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_64x13 i_rf_dir_tok_cnt_mem (

     .wclk                    (rf_dir_tok_cnt_mem_wclk)
    ,.wclk_rst_n              (rf_dir_tok_cnt_mem_wclk_rst_n)
    ,.we                      (rf_dir_tok_cnt_mem_we)
    ,.waddr                   (rf_dir_tok_cnt_mem_waddr)
    ,.wdata                   (rf_dir_tok_cnt_mem_wdata)
    ,.rclk                    (rf_dir_tok_cnt_mem_rclk)
    ,.rclk_rst_n              (rf_dir_tok_cnt_mem_rclk_rst_n)
    ,.re                      (rf_dir_tok_cnt_mem_re)
    ,.raddr                   (rf_dir_tok_cnt_mem_raddr)
    ,.rdata                   (rf_dir_tok_cnt_mem_rdata)

    ,.pgcb_isol_en            (rf_dir_tok_cnt_mem_isol_en)
    ,.pwr_enable_b_in         (rf_dir_tok_cnt_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_dir_tok_cnt_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_64x8 i_rf_dir_tok_lim_mem (

     .wclk                    (rf_dir_tok_lim_mem_wclk)
    ,.wclk_rst_n              (rf_dir_tok_lim_mem_wclk_rst_n)
    ,.we                      (rf_dir_tok_lim_mem_we)
    ,.waddr                   (rf_dir_tok_lim_mem_waddr)
    ,.wdata                   (rf_dir_tok_lim_mem_wdata)
    ,.rclk                    (rf_dir_tok_lim_mem_rclk)
    ,.rclk_rst_n              (rf_dir_tok_lim_mem_rclk_rst_n)
    ,.re                      (rf_dir_tok_lim_mem_re)
    ,.raddr                   (rf_dir_tok_lim_mem_raddr)
    ,.rdata                   (rf_dir_tok_lim_mem_rdata)

    ,.pgcb_isol_en            (rf_dir_tok_lim_mem_isol_en)
    ,.pwr_enable_b_in         (rf_dir_tok_lim_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_dir_tok_lim_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_4x8 i_rf_dp_lsp_enq_dir_rx_sync_fifo_mem (

     .wclk                    (rf_dp_lsp_enq_dir_rx_sync_fifo_mem_wclk)
    ,.wclk_rst_n              (rf_dp_lsp_enq_dir_rx_sync_fifo_mem_wclk_rst_n)
    ,.we                      (rf_dp_lsp_enq_dir_rx_sync_fifo_mem_we)
    ,.waddr                   (rf_dp_lsp_enq_dir_rx_sync_fifo_mem_waddr)
    ,.wdata                   (rf_dp_lsp_enq_dir_rx_sync_fifo_mem_wdata)
    ,.rclk                    (rf_dp_lsp_enq_dir_rx_sync_fifo_mem_rclk)
    ,.rclk_rst_n              (rf_dp_lsp_enq_dir_rx_sync_fifo_mem_rclk_rst_n)
    ,.re                      (rf_dp_lsp_enq_dir_rx_sync_fifo_mem_re)
    ,.raddr                   (rf_dp_lsp_enq_dir_rx_sync_fifo_mem_raddr)
    ,.rdata                   (rf_dp_lsp_enq_dir_rx_sync_fifo_mem_rdata)

    ,.pgcb_isol_en            (rf_dp_lsp_enq_dir_rx_sync_fifo_mem_isol_en)
    ,.pwr_enable_b_in         (rf_dp_lsp_enq_dir_rx_sync_fifo_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_dp_lsp_enq_dir_rx_sync_fifo_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_4x23 i_rf_dp_lsp_enq_rorply_rx_sync_fifo_mem (

     .wclk                    (rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_wclk)
    ,.wclk_rst_n              (rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_wclk_rst_n)
    ,.we                      (rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_we)
    ,.waddr                   (rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_waddr)
    ,.wdata                   (rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_wdata)
    ,.rclk                    (rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_rclk)
    ,.rclk_rst_n              (rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_rclk_rst_n)
    ,.re                      (rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_re)
    ,.raddr                   (rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_raddr)
    ,.rdata                   (rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_rdata)

    ,.pgcb_isol_en            (rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_isol_en)
    ,.pwr_enable_b_in         (rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_4x10 i_rf_enq_nalb_fifo_mem (

     .wclk                    (rf_enq_nalb_fifo_mem_wclk)
    ,.wclk_rst_n              (rf_enq_nalb_fifo_mem_wclk_rst_n)
    ,.we                      (rf_enq_nalb_fifo_mem_we)
    ,.waddr                   (rf_enq_nalb_fifo_mem_waddr)
    ,.wdata                   (rf_enq_nalb_fifo_mem_wdata)
    ,.rclk                    (rf_enq_nalb_fifo_mem_rclk)
    ,.rclk_rst_n              (rf_enq_nalb_fifo_mem_rclk_rst_n)
    ,.re                      (rf_enq_nalb_fifo_mem_re)
    ,.raddr                   (rf_enq_nalb_fifo_mem_raddr)
    ,.rdata                   (rf_enq_nalb_fifo_mem_rdata)

    ,.pgcb_isol_en            (rf_enq_nalb_fifo_mem_isol_en)
    ,.pwr_enable_b_in         (rf_enq_nalb_fifo_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_enq_nalb_fifo_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_2048x12 i_rf_fid2cqqidix (

     .wclk                    (rf_fid2cqqidix_wclk)
    ,.wclk_rst_n              (rf_fid2cqqidix_wclk_rst_n)
    ,.we                      (rf_fid2cqqidix_we)
    ,.waddr                   (rf_fid2cqqidix_waddr)
    ,.wdata                   (rf_fid2cqqidix_wdata)
    ,.rclk                    (rf_fid2cqqidix_rclk)
    ,.rclk_rst_n              (rf_fid2cqqidix_rclk_rst_n)
    ,.re                      (rf_fid2cqqidix_re)
    ,.raddr                   (rf_fid2cqqidix_raddr)
    ,.rdata                   (rf_fid2cqqidix_rdata)

    ,.pgcb_isol_en            (rf_fid2cqqidix_isol_en)
    ,.pwr_enable_b_in         (rf_fid2cqqidix_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_fid2cqqidix_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_8x25 i_rf_ldb_token_rtn_fifo_mem (

     .wclk                    (rf_ldb_token_rtn_fifo_mem_wclk)
    ,.wclk_rst_n              (rf_ldb_token_rtn_fifo_mem_wclk_rst_n)
    ,.we                      (rf_ldb_token_rtn_fifo_mem_we)
    ,.waddr                   (rf_ldb_token_rtn_fifo_mem_waddr)
    ,.wdata                   (rf_ldb_token_rtn_fifo_mem_wdata)
    ,.rclk                    (rf_ldb_token_rtn_fifo_mem_rclk)
    ,.rclk_rst_n              (rf_ldb_token_rtn_fifo_mem_rclk_rst_n)
    ,.re                      (rf_ldb_token_rtn_fifo_mem_re)
    ,.raddr                   (rf_ldb_token_rtn_fifo_mem_raddr)
    ,.rdata                   (rf_ldb_token_rtn_fifo_mem_rdata)

    ,.pgcb_isol_en            (rf_ldb_token_rtn_fifo_mem_isol_en)
    ,.pwr_enable_b_in         (rf_ldb_token_rtn_fifo_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_ldb_token_rtn_fifo_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_2048x16 i_rf_ll_enq_cnt_r_bin0_dup0 (

     .wclk                    (rf_ll_enq_cnt_r_bin0_dup0_wclk)
    ,.wclk_rst_n              (rf_ll_enq_cnt_r_bin0_dup0_wclk_rst_n)
    ,.we                      (rf_ll_enq_cnt_r_bin0_dup0_we)
    ,.waddr                   (rf_ll_enq_cnt_r_bin0_dup0_waddr)
    ,.wdata                   (rf_ll_enq_cnt_r_bin0_dup0_wdata)
    ,.rclk                    (rf_ll_enq_cnt_r_bin0_dup0_rclk)
    ,.rclk_rst_n              (rf_ll_enq_cnt_r_bin0_dup0_rclk_rst_n)
    ,.re                      (rf_ll_enq_cnt_r_bin0_dup0_re)
    ,.raddr                   (rf_ll_enq_cnt_r_bin0_dup0_raddr)
    ,.rdata                   (rf_ll_enq_cnt_r_bin0_dup0_rdata)

    ,.pgcb_isol_en            (rf_ll_enq_cnt_r_bin0_dup0_isol_en)
    ,.pwr_enable_b_in         (rf_ll_enq_cnt_r_bin0_dup0_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_ll_enq_cnt_r_bin0_dup0_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_2048x16 i_rf_ll_enq_cnt_r_bin0_dup1 (

     .wclk                    (rf_ll_enq_cnt_r_bin0_dup1_wclk)
    ,.wclk_rst_n              (rf_ll_enq_cnt_r_bin0_dup1_wclk_rst_n)
    ,.we                      (rf_ll_enq_cnt_r_bin0_dup1_we)
    ,.waddr                   (rf_ll_enq_cnt_r_bin0_dup1_waddr)
    ,.wdata                   (rf_ll_enq_cnt_r_bin0_dup1_wdata)
    ,.rclk                    (rf_ll_enq_cnt_r_bin0_dup1_rclk)
    ,.rclk_rst_n              (rf_ll_enq_cnt_r_bin0_dup1_rclk_rst_n)
    ,.re                      (rf_ll_enq_cnt_r_bin0_dup1_re)
    ,.raddr                   (rf_ll_enq_cnt_r_bin0_dup1_raddr)
    ,.rdata                   (rf_ll_enq_cnt_r_bin0_dup1_rdata)

    ,.pgcb_isol_en            (rf_ll_enq_cnt_r_bin0_dup1_isol_en)
    ,.pwr_enable_b_in         (rf_ll_enq_cnt_r_bin0_dup1_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_ll_enq_cnt_r_bin0_dup1_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_2048x16 i_rf_ll_enq_cnt_r_bin0_dup2 (

     .wclk                    (rf_ll_enq_cnt_r_bin0_dup2_wclk)
    ,.wclk_rst_n              (rf_ll_enq_cnt_r_bin0_dup2_wclk_rst_n)
    ,.we                      (rf_ll_enq_cnt_r_bin0_dup2_we)
    ,.waddr                   (rf_ll_enq_cnt_r_bin0_dup2_waddr)
    ,.wdata                   (rf_ll_enq_cnt_r_bin0_dup2_wdata)
    ,.rclk                    (rf_ll_enq_cnt_r_bin0_dup2_rclk)
    ,.rclk_rst_n              (rf_ll_enq_cnt_r_bin0_dup2_rclk_rst_n)
    ,.re                      (rf_ll_enq_cnt_r_bin0_dup2_re)
    ,.raddr                   (rf_ll_enq_cnt_r_bin0_dup2_raddr)
    ,.rdata                   (rf_ll_enq_cnt_r_bin0_dup2_rdata)

    ,.pgcb_isol_en            (rf_ll_enq_cnt_r_bin0_dup2_isol_en)
    ,.pwr_enable_b_in         (rf_ll_enq_cnt_r_bin0_dup2_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_ll_enq_cnt_r_bin0_dup2_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_2048x16 i_rf_ll_enq_cnt_r_bin0_dup3 (

     .wclk                    (rf_ll_enq_cnt_r_bin0_dup3_wclk)
    ,.wclk_rst_n              (rf_ll_enq_cnt_r_bin0_dup3_wclk_rst_n)
    ,.we                      (rf_ll_enq_cnt_r_bin0_dup3_we)
    ,.waddr                   (rf_ll_enq_cnt_r_bin0_dup3_waddr)
    ,.wdata                   (rf_ll_enq_cnt_r_bin0_dup3_wdata)
    ,.rclk                    (rf_ll_enq_cnt_r_bin0_dup3_rclk)
    ,.rclk_rst_n              (rf_ll_enq_cnt_r_bin0_dup3_rclk_rst_n)
    ,.re                      (rf_ll_enq_cnt_r_bin0_dup3_re)
    ,.raddr                   (rf_ll_enq_cnt_r_bin0_dup3_raddr)
    ,.rdata                   (rf_ll_enq_cnt_r_bin0_dup3_rdata)

    ,.pgcb_isol_en            (rf_ll_enq_cnt_r_bin0_dup3_isol_en)
    ,.pwr_enable_b_in         (rf_ll_enq_cnt_r_bin0_dup3_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_ll_enq_cnt_r_bin0_dup3_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_2048x16 i_rf_ll_enq_cnt_r_bin1_dup0 (

     .wclk                    (rf_ll_enq_cnt_r_bin1_dup0_wclk)
    ,.wclk_rst_n              (rf_ll_enq_cnt_r_bin1_dup0_wclk_rst_n)
    ,.we                      (rf_ll_enq_cnt_r_bin1_dup0_we)
    ,.waddr                   (rf_ll_enq_cnt_r_bin1_dup0_waddr)
    ,.wdata                   (rf_ll_enq_cnt_r_bin1_dup0_wdata)
    ,.rclk                    (rf_ll_enq_cnt_r_bin1_dup0_rclk)
    ,.rclk_rst_n              (rf_ll_enq_cnt_r_bin1_dup0_rclk_rst_n)
    ,.re                      (rf_ll_enq_cnt_r_bin1_dup0_re)
    ,.raddr                   (rf_ll_enq_cnt_r_bin1_dup0_raddr)
    ,.rdata                   (rf_ll_enq_cnt_r_bin1_dup0_rdata)

    ,.pgcb_isol_en            (rf_ll_enq_cnt_r_bin1_dup0_isol_en)
    ,.pwr_enable_b_in         (rf_ll_enq_cnt_r_bin1_dup0_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_ll_enq_cnt_r_bin1_dup0_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_2048x16 i_rf_ll_enq_cnt_r_bin1_dup1 (

     .wclk                    (rf_ll_enq_cnt_r_bin1_dup1_wclk)
    ,.wclk_rst_n              (rf_ll_enq_cnt_r_bin1_dup1_wclk_rst_n)
    ,.we                      (rf_ll_enq_cnt_r_bin1_dup1_we)
    ,.waddr                   (rf_ll_enq_cnt_r_bin1_dup1_waddr)
    ,.wdata                   (rf_ll_enq_cnt_r_bin1_dup1_wdata)
    ,.rclk                    (rf_ll_enq_cnt_r_bin1_dup1_rclk)
    ,.rclk_rst_n              (rf_ll_enq_cnt_r_bin1_dup1_rclk_rst_n)
    ,.re                      (rf_ll_enq_cnt_r_bin1_dup1_re)
    ,.raddr                   (rf_ll_enq_cnt_r_bin1_dup1_raddr)
    ,.rdata                   (rf_ll_enq_cnt_r_bin1_dup1_rdata)

    ,.pgcb_isol_en            (rf_ll_enq_cnt_r_bin1_dup1_isol_en)
    ,.pwr_enable_b_in         (rf_ll_enq_cnt_r_bin1_dup1_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_ll_enq_cnt_r_bin1_dup1_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_2048x16 i_rf_ll_enq_cnt_r_bin1_dup2 (

     .wclk                    (rf_ll_enq_cnt_r_bin1_dup2_wclk)
    ,.wclk_rst_n              (rf_ll_enq_cnt_r_bin1_dup2_wclk_rst_n)
    ,.we                      (rf_ll_enq_cnt_r_bin1_dup2_we)
    ,.waddr                   (rf_ll_enq_cnt_r_bin1_dup2_waddr)
    ,.wdata                   (rf_ll_enq_cnt_r_bin1_dup2_wdata)
    ,.rclk                    (rf_ll_enq_cnt_r_bin1_dup2_rclk)
    ,.rclk_rst_n              (rf_ll_enq_cnt_r_bin1_dup2_rclk_rst_n)
    ,.re                      (rf_ll_enq_cnt_r_bin1_dup2_re)
    ,.raddr                   (rf_ll_enq_cnt_r_bin1_dup2_raddr)
    ,.rdata                   (rf_ll_enq_cnt_r_bin1_dup2_rdata)

    ,.pgcb_isol_en            (rf_ll_enq_cnt_r_bin1_dup2_isol_en)
    ,.pwr_enable_b_in         (rf_ll_enq_cnt_r_bin1_dup2_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_ll_enq_cnt_r_bin1_dup2_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_2048x16 i_rf_ll_enq_cnt_r_bin1_dup3 (

     .wclk                    (rf_ll_enq_cnt_r_bin1_dup3_wclk)
    ,.wclk_rst_n              (rf_ll_enq_cnt_r_bin1_dup3_wclk_rst_n)
    ,.we                      (rf_ll_enq_cnt_r_bin1_dup3_we)
    ,.waddr                   (rf_ll_enq_cnt_r_bin1_dup3_waddr)
    ,.wdata                   (rf_ll_enq_cnt_r_bin1_dup3_wdata)
    ,.rclk                    (rf_ll_enq_cnt_r_bin1_dup3_rclk)
    ,.rclk_rst_n              (rf_ll_enq_cnt_r_bin1_dup3_rclk_rst_n)
    ,.re                      (rf_ll_enq_cnt_r_bin1_dup3_re)
    ,.raddr                   (rf_ll_enq_cnt_r_bin1_dup3_raddr)
    ,.rdata                   (rf_ll_enq_cnt_r_bin1_dup3_rdata)

    ,.pgcb_isol_en            (rf_ll_enq_cnt_r_bin1_dup3_isol_en)
    ,.pwr_enable_b_in         (rf_ll_enq_cnt_r_bin1_dup3_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_ll_enq_cnt_r_bin1_dup3_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_2048x16 i_rf_ll_enq_cnt_r_bin2_dup0 (

     .wclk                    (rf_ll_enq_cnt_r_bin2_dup0_wclk)
    ,.wclk_rst_n              (rf_ll_enq_cnt_r_bin2_dup0_wclk_rst_n)
    ,.we                      (rf_ll_enq_cnt_r_bin2_dup0_we)
    ,.waddr                   (rf_ll_enq_cnt_r_bin2_dup0_waddr)
    ,.wdata                   (rf_ll_enq_cnt_r_bin2_dup0_wdata)
    ,.rclk                    (rf_ll_enq_cnt_r_bin2_dup0_rclk)
    ,.rclk_rst_n              (rf_ll_enq_cnt_r_bin2_dup0_rclk_rst_n)
    ,.re                      (rf_ll_enq_cnt_r_bin2_dup0_re)
    ,.raddr                   (rf_ll_enq_cnt_r_bin2_dup0_raddr)
    ,.rdata                   (rf_ll_enq_cnt_r_bin2_dup0_rdata)

    ,.pgcb_isol_en            (rf_ll_enq_cnt_r_bin2_dup0_isol_en)
    ,.pwr_enable_b_in         (rf_ll_enq_cnt_r_bin2_dup0_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_ll_enq_cnt_r_bin2_dup0_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_2048x16 i_rf_ll_enq_cnt_r_bin2_dup1 (

     .wclk                    (rf_ll_enq_cnt_r_bin2_dup1_wclk)
    ,.wclk_rst_n              (rf_ll_enq_cnt_r_bin2_dup1_wclk_rst_n)
    ,.we                      (rf_ll_enq_cnt_r_bin2_dup1_we)
    ,.waddr                   (rf_ll_enq_cnt_r_bin2_dup1_waddr)
    ,.wdata                   (rf_ll_enq_cnt_r_bin2_dup1_wdata)
    ,.rclk                    (rf_ll_enq_cnt_r_bin2_dup1_rclk)
    ,.rclk_rst_n              (rf_ll_enq_cnt_r_bin2_dup1_rclk_rst_n)
    ,.re                      (rf_ll_enq_cnt_r_bin2_dup1_re)
    ,.raddr                   (rf_ll_enq_cnt_r_bin2_dup1_raddr)
    ,.rdata                   (rf_ll_enq_cnt_r_bin2_dup1_rdata)

    ,.pgcb_isol_en            (rf_ll_enq_cnt_r_bin2_dup1_isol_en)
    ,.pwr_enable_b_in         (rf_ll_enq_cnt_r_bin2_dup1_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_ll_enq_cnt_r_bin2_dup1_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_2048x16 i_rf_ll_enq_cnt_r_bin2_dup2 (

     .wclk                    (rf_ll_enq_cnt_r_bin2_dup2_wclk)
    ,.wclk_rst_n              (rf_ll_enq_cnt_r_bin2_dup2_wclk_rst_n)
    ,.we                      (rf_ll_enq_cnt_r_bin2_dup2_we)
    ,.waddr                   (rf_ll_enq_cnt_r_bin2_dup2_waddr)
    ,.wdata                   (rf_ll_enq_cnt_r_bin2_dup2_wdata)
    ,.rclk                    (rf_ll_enq_cnt_r_bin2_dup2_rclk)
    ,.rclk_rst_n              (rf_ll_enq_cnt_r_bin2_dup2_rclk_rst_n)
    ,.re                      (rf_ll_enq_cnt_r_bin2_dup2_re)
    ,.raddr                   (rf_ll_enq_cnt_r_bin2_dup2_raddr)
    ,.rdata                   (rf_ll_enq_cnt_r_bin2_dup2_rdata)

    ,.pgcb_isol_en            (rf_ll_enq_cnt_r_bin2_dup2_isol_en)
    ,.pwr_enable_b_in         (rf_ll_enq_cnt_r_bin2_dup2_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_ll_enq_cnt_r_bin2_dup2_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_2048x16 i_rf_ll_enq_cnt_r_bin2_dup3 (

     .wclk                    (rf_ll_enq_cnt_r_bin2_dup3_wclk)
    ,.wclk_rst_n              (rf_ll_enq_cnt_r_bin2_dup3_wclk_rst_n)
    ,.we                      (rf_ll_enq_cnt_r_bin2_dup3_we)
    ,.waddr                   (rf_ll_enq_cnt_r_bin2_dup3_waddr)
    ,.wdata                   (rf_ll_enq_cnt_r_bin2_dup3_wdata)
    ,.rclk                    (rf_ll_enq_cnt_r_bin2_dup3_rclk)
    ,.rclk_rst_n              (rf_ll_enq_cnt_r_bin2_dup3_rclk_rst_n)
    ,.re                      (rf_ll_enq_cnt_r_bin2_dup3_re)
    ,.raddr                   (rf_ll_enq_cnt_r_bin2_dup3_raddr)
    ,.rdata                   (rf_ll_enq_cnt_r_bin2_dup3_rdata)

    ,.pgcb_isol_en            (rf_ll_enq_cnt_r_bin2_dup3_isol_en)
    ,.pwr_enable_b_in         (rf_ll_enq_cnt_r_bin2_dup3_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_ll_enq_cnt_r_bin2_dup3_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_2048x16 i_rf_ll_enq_cnt_r_bin3_dup0 (

     .wclk                    (rf_ll_enq_cnt_r_bin3_dup0_wclk)
    ,.wclk_rst_n              (rf_ll_enq_cnt_r_bin3_dup0_wclk_rst_n)
    ,.we                      (rf_ll_enq_cnt_r_bin3_dup0_we)
    ,.waddr                   (rf_ll_enq_cnt_r_bin3_dup0_waddr)
    ,.wdata                   (rf_ll_enq_cnt_r_bin3_dup0_wdata)
    ,.rclk                    (rf_ll_enq_cnt_r_bin3_dup0_rclk)
    ,.rclk_rst_n              (rf_ll_enq_cnt_r_bin3_dup0_rclk_rst_n)
    ,.re                      (rf_ll_enq_cnt_r_bin3_dup0_re)
    ,.raddr                   (rf_ll_enq_cnt_r_bin3_dup0_raddr)
    ,.rdata                   (rf_ll_enq_cnt_r_bin3_dup0_rdata)

    ,.pgcb_isol_en            (rf_ll_enq_cnt_r_bin3_dup0_isol_en)
    ,.pwr_enable_b_in         (rf_ll_enq_cnt_r_bin3_dup0_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_ll_enq_cnt_r_bin3_dup0_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_2048x16 i_rf_ll_enq_cnt_r_bin3_dup1 (

     .wclk                    (rf_ll_enq_cnt_r_bin3_dup1_wclk)
    ,.wclk_rst_n              (rf_ll_enq_cnt_r_bin3_dup1_wclk_rst_n)
    ,.we                      (rf_ll_enq_cnt_r_bin3_dup1_we)
    ,.waddr                   (rf_ll_enq_cnt_r_bin3_dup1_waddr)
    ,.wdata                   (rf_ll_enq_cnt_r_bin3_dup1_wdata)
    ,.rclk                    (rf_ll_enq_cnt_r_bin3_dup1_rclk)
    ,.rclk_rst_n              (rf_ll_enq_cnt_r_bin3_dup1_rclk_rst_n)
    ,.re                      (rf_ll_enq_cnt_r_bin3_dup1_re)
    ,.raddr                   (rf_ll_enq_cnt_r_bin3_dup1_raddr)
    ,.rdata                   (rf_ll_enq_cnt_r_bin3_dup1_rdata)

    ,.pgcb_isol_en            (rf_ll_enq_cnt_r_bin3_dup1_isol_en)
    ,.pwr_enable_b_in         (rf_ll_enq_cnt_r_bin3_dup1_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_ll_enq_cnt_r_bin3_dup1_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_2048x16 i_rf_ll_enq_cnt_r_bin3_dup2 (

     .wclk                    (rf_ll_enq_cnt_r_bin3_dup2_wclk)
    ,.wclk_rst_n              (rf_ll_enq_cnt_r_bin3_dup2_wclk_rst_n)
    ,.we                      (rf_ll_enq_cnt_r_bin3_dup2_we)
    ,.waddr                   (rf_ll_enq_cnt_r_bin3_dup2_waddr)
    ,.wdata                   (rf_ll_enq_cnt_r_bin3_dup2_wdata)
    ,.rclk                    (rf_ll_enq_cnt_r_bin3_dup2_rclk)
    ,.rclk_rst_n              (rf_ll_enq_cnt_r_bin3_dup2_rclk_rst_n)
    ,.re                      (rf_ll_enq_cnt_r_bin3_dup2_re)
    ,.raddr                   (rf_ll_enq_cnt_r_bin3_dup2_raddr)
    ,.rdata                   (rf_ll_enq_cnt_r_bin3_dup2_rdata)

    ,.pgcb_isol_en            (rf_ll_enq_cnt_r_bin3_dup2_isol_en)
    ,.pwr_enable_b_in         (rf_ll_enq_cnt_r_bin3_dup2_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_ll_enq_cnt_r_bin3_dup2_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_2048x16 i_rf_ll_enq_cnt_r_bin3_dup3 (

     .wclk                    (rf_ll_enq_cnt_r_bin3_dup3_wclk)
    ,.wclk_rst_n              (rf_ll_enq_cnt_r_bin3_dup3_wclk_rst_n)
    ,.we                      (rf_ll_enq_cnt_r_bin3_dup3_we)
    ,.waddr                   (rf_ll_enq_cnt_r_bin3_dup3_waddr)
    ,.wdata                   (rf_ll_enq_cnt_r_bin3_dup3_wdata)
    ,.rclk                    (rf_ll_enq_cnt_r_bin3_dup3_rclk)
    ,.rclk_rst_n              (rf_ll_enq_cnt_r_bin3_dup3_rclk_rst_n)
    ,.re                      (rf_ll_enq_cnt_r_bin3_dup3_re)
    ,.raddr                   (rf_ll_enq_cnt_r_bin3_dup3_raddr)
    ,.rdata                   (rf_ll_enq_cnt_r_bin3_dup3_rdata)

    ,.pgcb_isol_en            (rf_ll_enq_cnt_r_bin3_dup3_isol_en)
    ,.pwr_enable_b_in         (rf_ll_enq_cnt_r_bin3_dup3_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_ll_enq_cnt_r_bin3_dup3_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_2048x16 i_rf_ll_enq_cnt_s_bin0 (

     .wclk                    (rf_ll_enq_cnt_s_bin0_wclk)
    ,.wclk_rst_n              (rf_ll_enq_cnt_s_bin0_wclk_rst_n)
    ,.we                      (rf_ll_enq_cnt_s_bin0_we)
    ,.waddr                   (rf_ll_enq_cnt_s_bin0_waddr)
    ,.wdata                   (rf_ll_enq_cnt_s_bin0_wdata)
    ,.rclk                    (rf_ll_enq_cnt_s_bin0_rclk)
    ,.rclk_rst_n              (rf_ll_enq_cnt_s_bin0_rclk_rst_n)
    ,.re                      (rf_ll_enq_cnt_s_bin0_re)
    ,.raddr                   (rf_ll_enq_cnt_s_bin0_raddr)
    ,.rdata                   (rf_ll_enq_cnt_s_bin0_rdata)

    ,.pgcb_isol_en            (rf_ll_enq_cnt_s_bin0_isol_en)
    ,.pwr_enable_b_in         (rf_ll_enq_cnt_s_bin0_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_ll_enq_cnt_s_bin0_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_2048x16 i_rf_ll_enq_cnt_s_bin1 (

     .wclk                    (rf_ll_enq_cnt_s_bin1_wclk)
    ,.wclk_rst_n              (rf_ll_enq_cnt_s_bin1_wclk_rst_n)
    ,.we                      (rf_ll_enq_cnt_s_bin1_we)
    ,.waddr                   (rf_ll_enq_cnt_s_bin1_waddr)
    ,.wdata                   (rf_ll_enq_cnt_s_bin1_wdata)
    ,.rclk                    (rf_ll_enq_cnt_s_bin1_rclk)
    ,.rclk_rst_n              (rf_ll_enq_cnt_s_bin1_rclk_rst_n)
    ,.re                      (rf_ll_enq_cnt_s_bin1_re)
    ,.raddr                   (rf_ll_enq_cnt_s_bin1_raddr)
    ,.rdata                   (rf_ll_enq_cnt_s_bin1_rdata)

    ,.pgcb_isol_en            (rf_ll_enq_cnt_s_bin1_isol_en)
    ,.pwr_enable_b_in         (rf_ll_enq_cnt_s_bin1_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_ll_enq_cnt_s_bin1_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_2048x16 i_rf_ll_enq_cnt_s_bin2 (

     .wclk                    (rf_ll_enq_cnt_s_bin2_wclk)
    ,.wclk_rst_n              (rf_ll_enq_cnt_s_bin2_wclk_rst_n)
    ,.we                      (rf_ll_enq_cnt_s_bin2_we)
    ,.waddr                   (rf_ll_enq_cnt_s_bin2_waddr)
    ,.wdata                   (rf_ll_enq_cnt_s_bin2_wdata)
    ,.rclk                    (rf_ll_enq_cnt_s_bin2_rclk)
    ,.rclk_rst_n              (rf_ll_enq_cnt_s_bin2_rclk_rst_n)
    ,.re                      (rf_ll_enq_cnt_s_bin2_re)
    ,.raddr                   (rf_ll_enq_cnt_s_bin2_raddr)
    ,.rdata                   (rf_ll_enq_cnt_s_bin2_rdata)

    ,.pgcb_isol_en            (rf_ll_enq_cnt_s_bin2_isol_en)
    ,.pwr_enable_b_in         (rf_ll_enq_cnt_s_bin2_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_ll_enq_cnt_s_bin2_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_2048x16 i_rf_ll_enq_cnt_s_bin3 (

     .wclk                    (rf_ll_enq_cnt_s_bin3_wclk)
    ,.wclk_rst_n              (rf_ll_enq_cnt_s_bin3_wclk_rst_n)
    ,.we                      (rf_ll_enq_cnt_s_bin3_we)
    ,.waddr                   (rf_ll_enq_cnt_s_bin3_waddr)
    ,.wdata                   (rf_ll_enq_cnt_s_bin3_wdata)
    ,.rclk                    (rf_ll_enq_cnt_s_bin3_rclk)
    ,.rclk_rst_n              (rf_ll_enq_cnt_s_bin3_rclk_rst_n)
    ,.re                      (rf_ll_enq_cnt_s_bin3_re)
    ,.raddr                   (rf_ll_enq_cnt_s_bin3_raddr)
    ,.rdata                   (rf_ll_enq_cnt_s_bin3_rdata)

    ,.pgcb_isol_en            (rf_ll_enq_cnt_s_bin3_isol_en)
    ,.pwr_enable_b_in         (rf_ll_enq_cnt_s_bin3_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_ll_enq_cnt_s_bin3_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_32x14 i_rf_ll_rdylst_hp_bin0 (

     .wclk                    (rf_ll_rdylst_hp_bin0_wclk)
    ,.wclk_rst_n              (rf_ll_rdylst_hp_bin0_wclk_rst_n)
    ,.we                      (rf_ll_rdylst_hp_bin0_we)
    ,.waddr                   (rf_ll_rdylst_hp_bin0_waddr)
    ,.wdata                   (rf_ll_rdylst_hp_bin0_wdata)
    ,.rclk                    (rf_ll_rdylst_hp_bin0_rclk)
    ,.rclk_rst_n              (rf_ll_rdylst_hp_bin0_rclk_rst_n)
    ,.re                      (rf_ll_rdylst_hp_bin0_re)
    ,.raddr                   (rf_ll_rdylst_hp_bin0_raddr)
    ,.rdata                   (rf_ll_rdylst_hp_bin0_rdata)

    ,.pgcb_isol_en            (rf_ll_rdylst_hp_bin0_isol_en)
    ,.pwr_enable_b_in         (rf_ll_rdylst_hp_bin0_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_ll_rdylst_hp_bin0_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_32x14 i_rf_ll_rdylst_hp_bin1 (

     .wclk                    (rf_ll_rdylst_hp_bin1_wclk)
    ,.wclk_rst_n              (rf_ll_rdylst_hp_bin1_wclk_rst_n)
    ,.we                      (rf_ll_rdylst_hp_bin1_we)
    ,.waddr                   (rf_ll_rdylst_hp_bin1_waddr)
    ,.wdata                   (rf_ll_rdylst_hp_bin1_wdata)
    ,.rclk                    (rf_ll_rdylst_hp_bin1_rclk)
    ,.rclk_rst_n              (rf_ll_rdylst_hp_bin1_rclk_rst_n)
    ,.re                      (rf_ll_rdylst_hp_bin1_re)
    ,.raddr                   (rf_ll_rdylst_hp_bin1_raddr)
    ,.rdata                   (rf_ll_rdylst_hp_bin1_rdata)

    ,.pgcb_isol_en            (rf_ll_rdylst_hp_bin1_isol_en)
    ,.pwr_enable_b_in         (rf_ll_rdylst_hp_bin1_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_ll_rdylst_hp_bin1_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_32x14 i_rf_ll_rdylst_hp_bin2 (

     .wclk                    (rf_ll_rdylst_hp_bin2_wclk)
    ,.wclk_rst_n              (rf_ll_rdylst_hp_bin2_wclk_rst_n)
    ,.we                      (rf_ll_rdylst_hp_bin2_we)
    ,.waddr                   (rf_ll_rdylst_hp_bin2_waddr)
    ,.wdata                   (rf_ll_rdylst_hp_bin2_wdata)
    ,.rclk                    (rf_ll_rdylst_hp_bin2_rclk)
    ,.rclk_rst_n              (rf_ll_rdylst_hp_bin2_rclk_rst_n)
    ,.re                      (rf_ll_rdylst_hp_bin2_re)
    ,.raddr                   (rf_ll_rdylst_hp_bin2_raddr)
    ,.rdata                   (rf_ll_rdylst_hp_bin2_rdata)

    ,.pgcb_isol_en            (rf_ll_rdylst_hp_bin2_isol_en)
    ,.pwr_enable_b_in         (rf_ll_rdylst_hp_bin2_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_ll_rdylst_hp_bin2_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_32x14 i_rf_ll_rdylst_hp_bin3 (

     .wclk                    (rf_ll_rdylst_hp_bin3_wclk)
    ,.wclk_rst_n              (rf_ll_rdylst_hp_bin3_wclk_rst_n)
    ,.we                      (rf_ll_rdylst_hp_bin3_we)
    ,.waddr                   (rf_ll_rdylst_hp_bin3_waddr)
    ,.wdata                   (rf_ll_rdylst_hp_bin3_wdata)
    ,.rclk                    (rf_ll_rdylst_hp_bin3_rclk)
    ,.rclk_rst_n              (rf_ll_rdylst_hp_bin3_rclk_rst_n)
    ,.re                      (rf_ll_rdylst_hp_bin3_re)
    ,.raddr                   (rf_ll_rdylst_hp_bin3_raddr)
    ,.rdata                   (rf_ll_rdylst_hp_bin3_rdata)

    ,.pgcb_isol_en            (rf_ll_rdylst_hp_bin3_isol_en)
    ,.pwr_enable_b_in         (rf_ll_rdylst_hp_bin3_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_ll_rdylst_hp_bin3_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_2048x16 i_rf_ll_rdylst_hpnxt_bin0 (

     .wclk                    (rf_ll_rdylst_hpnxt_bin0_wclk)
    ,.wclk_rst_n              (rf_ll_rdylst_hpnxt_bin0_wclk_rst_n)
    ,.we                      (rf_ll_rdylst_hpnxt_bin0_we)
    ,.waddr                   (rf_ll_rdylst_hpnxt_bin0_waddr)
    ,.wdata                   (rf_ll_rdylst_hpnxt_bin0_wdata)
    ,.rclk                    (rf_ll_rdylst_hpnxt_bin0_rclk)
    ,.rclk_rst_n              (rf_ll_rdylst_hpnxt_bin0_rclk_rst_n)
    ,.re                      (rf_ll_rdylst_hpnxt_bin0_re)
    ,.raddr                   (rf_ll_rdylst_hpnxt_bin0_raddr)
    ,.rdata                   (rf_ll_rdylst_hpnxt_bin0_rdata)

    ,.pgcb_isol_en            (rf_ll_rdylst_hpnxt_bin0_isol_en)
    ,.pwr_enable_b_in         (rf_ll_rdylst_hpnxt_bin0_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_ll_rdylst_hpnxt_bin0_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_2048x16 i_rf_ll_rdylst_hpnxt_bin1 (

     .wclk                    (rf_ll_rdylst_hpnxt_bin1_wclk)
    ,.wclk_rst_n              (rf_ll_rdylst_hpnxt_bin1_wclk_rst_n)
    ,.we                      (rf_ll_rdylst_hpnxt_bin1_we)
    ,.waddr                   (rf_ll_rdylst_hpnxt_bin1_waddr)
    ,.wdata                   (rf_ll_rdylst_hpnxt_bin1_wdata)
    ,.rclk                    (rf_ll_rdylst_hpnxt_bin1_rclk)
    ,.rclk_rst_n              (rf_ll_rdylst_hpnxt_bin1_rclk_rst_n)
    ,.re                      (rf_ll_rdylst_hpnxt_bin1_re)
    ,.raddr                   (rf_ll_rdylst_hpnxt_bin1_raddr)
    ,.rdata                   (rf_ll_rdylst_hpnxt_bin1_rdata)

    ,.pgcb_isol_en            (rf_ll_rdylst_hpnxt_bin1_isol_en)
    ,.pwr_enable_b_in         (rf_ll_rdylst_hpnxt_bin1_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_ll_rdylst_hpnxt_bin1_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_2048x16 i_rf_ll_rdylst_hpnxt_bin2 (

     .wclk                    (rf_ll_rdylst_hpnxt_bin2_wclk)
    ,.wclk_rst_n              (rf_ll_rdylst_hpnxt_bin2_wclk_rst_n)
    ,.we                      (rf_ll_rdylst_hpnxt_bin2_we)
    ,.waddr                   (rf_ll_rdylst_hpnxt_bin2_waddr)
    ,.wdata                   (rf_ll_rdylst_hpnxt_bin2_wdata)
    ,.rclk                    (rf_ll_rdylst_hpnxt_bin2_rclk)
    ,.rclk_rst_n              (rf_ll_rdylst_hpnxt_bin2_rclk_rst_n)
    ,.re                      (rf_ll_rdylst_hpnxt_bin2_re)
    ,.raddr                   (rf_ll_rdylst_hpnxt_bin2_raddr)
    ,.rdata                   (rf_ll_rdylst_hpnxt_bin2_rdata)

    ,.pgcb_isol_en            (rf_ll_rdylst_hpnxt_bin2_isol_en)
    ,.pwr_enable_b_in         (rf_ll_rdylst_hpnxt_bin2_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_ll_rdylst_hpnxt_bin2_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_2048x16 i_rf_ll_rdylst_hpnxt_bin3 (

     .wclk                    (rf_ll_rdylst_hpnxt_bin3_wclk)
    ,.wclk_rst_n              (rf_ll_rdylst_hpnxt_bin3_wclk_rst_n)
    ,.we                      (rf_ll_rdylst_hpnxt_bin3_we)
    ,.waddr                   (rf_ll_rdylst_hpnxt_bin3_waddr)
    ,.wdata                   (rf_ll_rdylst_hpnxt_bin3_wdata)
    ,.rclk                    (rf_ll_rdylst_hpnxt_bin3_rclk)
    ,.rclk_rst_n              (rf_ll_rdylst_hpnxt_bin3_rclk_rst_n)
    ,.re                      (rf_ll_rdylst_hpnxt_bin3_re)
    ,.raddr                   (rf_ll_rdylst_hpnxt_bin3_raddr)
    ,.rdata                   (rf_ll_rdylst_hpnxt_bin3_rdata)

    ,.pgcb_isol_en            (rf_ll_rdylst_hpnxt_bin3_isol_en)
    ,.pwr_enable_b_in         (rf_ll_rdylst_hpnxt_bin3_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_ll_rdylst_hpnxt_bin3_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_32x14 i_rf_ll_rdylst_tp_bin0 (

     .wclk                    (rf_ll_rdylst_tp_bin0_wclk)
    ,.wclk_rst_n              (rf_ll_rdylst_tp_bin0_wclk_rst_n)
    ,.we                      (rf_ll_rdylst_tp_bin0_we)
    ,.waddr                   (rf_ll_rdylst_tp_bin0_waddr)
    ,.wdata                   (rf_ll_rdylst_tp_bin0_wdata)
    ,.rclk                    (rf_ll_rdylst_tp_bin0_rclk)
    ,.rclk_rst_n              (rf_ll_rdylst_tp_bin0_rclk_rst_n)
    ,.re                      (rf_ll_rdylst_tp_bin0_re)
    ,.raddr                   (rf_ll_rdylst_tp_bin0_raddr)
    ,.rdata                   (rf_ll_rdylst_tp_bin0_rdata)

    ,.pgcb_isol_en            (rf_ll_rdylst_tp_bin0_isol_en)
    ,.pwr_enable_b_in         (rf_ll_rdylst_tp_bin0_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_ll_rdylst_tp_bin0_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_32x14 i_rf_ll_rdylst_tp_bin1 (

     .wclk                    (rf_ll_rdylst_tp_bin1_wclk)
    ,.wclk_rst_n              (rf_ll_rdylst_tp_bin1_wclk_rst_n)
    ,.we                      (rf_ll_rdylst_tp_bin1_we)
    ,.waddr                   (rf_ll_rdylst_tp_bin1_waddr)
    ,.wdata                   (rf_ll_rdylst_tp_bin1_wdata)
    ,.rclk                    (rf_ll_rdylst_tp_bin1_rclk)
    ,.rclk_rst_n              (rf_ll_rdylst_tp_bin1_rclk_rst_n)
    ,.re                      (rf_ll_rdylst_tp_bin1_re)
    ,.raddr                   (rf_ll_rdylst_tp_bin1_raddr)
    ,.rdata                   (rf_ll_rdylst_tp_bin1_rdata)

    ,.pgcb_isol_en            (rf_ll_rdylst_tp_bin1_isol_en)
    ,.pwr_enable_b_in         (rf_ll_rdylst_tp_bin1_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_ll_rdylst_tp_bin1_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_32x14 i_rf_ll_rdylst_tp_bin2 (

     .wclk                    (rf_ll_rdylst_tp_bin2_wclk)
    ,.wclk_rst_n              (rf_ll_rdylst_tp_bin2_wclk_rst_n)
    ,.we                      (rf_ll_rdylst_tp_bin2_we)
    ,.waddr                   (rf_ll_rdylst_tp_bin2_waddr)
    ,.wdata                   (rf_ll_rdylst_tp_bin2_wdata)
    ,.rclk                    (rf_ll_rdylst_tp_bin2_rclk)
    ,.rclk_rst_n              (rf_ll_rdylst_tp_bin2_rclk_rst_n)
    ,.re                      (rf_ll_rdylst_tp_bin2_re)
    ,.raddr                   (rf_ll_rdylst_tp_bin2_raddr)
    ,.rdata                   (rf_ll_rdylst_tp_bin2_rdata)

    ,.pgcb_isol_en            (rf_ll_rdylst_tp_bin2_isol_en)
    ,.pwr_enable_b_in         (rf_ll_rdylst_tp_bin2_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_ll_rdylst_tp_bin2_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_32x14 i_rf_ll_rdylst_tp_bin3 (

     .wclk                    (rf_ll_rdylst_tp_bin3_wclk)
    ,.wclk_rst_n              (rf_ll_rdylst_tp_bin3_wclk_rst_n)
    ,.we                      (rf_ll_rdylst_tp_bin3_we)
    ,.waddr                   (rf_ll_rdylst_tp_bin3_waddr)
    ,.wdata                   (rf_ll_rdylst_tp_bin3_wdata)
    ,.rclk                    (rf_ll_rdylst_tp_bin3_rclk)
    ,.rclk_rst_n              (rf_ll_rdylst_tp_bin3_rclk_rst_n)
    ,.re                      (rf_ll_rdylst_tp_bin3_re)
    ,.raddr                   (rf_ll_rdylst_tp_bin3_raddr)
    ,.rdata                   (rf_ll_rdylst_tp_bin3_rdata)

    ,.pgcb_isol_en            (rf_ll_rdylst_tp_bin3_isol_en)
    ,.pwr_enable_b_in         (rf_ll_rdylst_tp_bin3_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_ll_rdylst_tp_bin3_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_32x56 i_rf_ll_rlst_cnt (

     .wclk                    (rf_ll_rlst_cnt_wclk)
    ,.wclk_rst_n              (rf_ll_rlst_cnt_wclk_rst_n)
    ,.we                      (rf_ll_rlst_cnt_we)
    ,.waddr                   (rf_ll_rlst_cnt_waddr)
    ,.wdata                   (rf_ll_rlst_cnt_wdata)
    ,.rclk                    (rf_ll_rlst_cnt_rclk)
    ,.rclk_rst_n              (rf_ll_rlst_cnt_rclk_rst_n)
    ,.re                      (rf_ll_rlst_cnt_re)
    ,.raddr                   (rf_ll_rlst_cnt_raddr)
    ,.rdata                   (rf_ll_rlst_cnt_rdata)

    ,.pgcb_isol_en            (rf_ll_rlst_cnt_isol_en)
    ,.pwr_enable_b_in         (rf_ll_rlst_cnt_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_ll_rlst_cnt_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_2048x17 i_rf_ll_sch_cnt_dup0 (

     .wclk                    (rf_ll_sch_cnt_dup0_wclk)
    ,.wclk_rst_n              (rf_ll_sch_cnt_dup0_wclk_rst_n)
    ,.we                      (rf_ll_sch_cnt_dup0_we)
    ,.waddr                   (rf_ll_sch_cnt_dup0_waddr)
    ,.wdata                   (rf_ll_sch_cnt_dup0_wdata)
    ,.rclk                    (rf_ll_sch_cnt_dup0_rclk)
    ,.rclk_rst_n              (rf_ll_sch_cnt_dup0_rclk_rst_n)
    ,.re                      (rf_ll_sch_cnt_dup0_re)
    ,.raddr                   (rf_ll_sch_cnt_dup0_raddr)
    ,.rdata                   (rf_ll_sch_cnt_dup0_rdata)

    ,.pgcb_isol_en            (rf_ll_sch_cnt_dup0_isol_en)
    ,.pwr_enable_b_in         (rf_ll_sch_cnt_dup0_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_ll_sch_cnt_dup0_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_2048x17 i_rf_ll_sch_cnt_dup1 (

     .wclk                    (rf_ll_sch_cnt_dup1_wclk)
    ,.wclk_rst_n              (rf_ll_sch_cnt_dup1_wclk_rst_n)
    ,.we                      (rf_ll_sch_cnt_dup1_we)
    ,.waddr                   (rf_ll_sch_cnt_dup1_waddr)
    ,.wdata                   (rf_ll_sch_cnt_dup1_wdata)
    ,.rclk                    (rf_ll_sch_cnt_dup1_rclk)
    ,.rclk_rst_n              (rf_ll_sch_cnt_dup1_rclk_rst_n)
    ,.re                      (rf_ll_sch_cnt_dup1_re)
    ,.raddr                   (rf_ll_sch_cnt_dup1_raddr)
    ,.rdata                   (rf_ll_sch_cnt_dup1_rdata)

    ,.pgcb_isol_en            (rf_ll_sch_cnt_dup1_isol_en)
    ,.pwr_enable_b_in         (rf_ll_sch_cnt_dup1_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_ll_sch_cnt_dup1_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_2048x17 i_rf_ll_sch_cnt_dup2 (

     .wclk                    (rf_ll_sch_cnt_dup2_wclk)
    ,.wclk_rst_n              (rf_ll_sch_cnt_dup2_wclk_rst_n)
    ,.we                      (rf_ll_sch_cnt_dup2_we)
    ,.waddr                   (rf_ll_sch_cnt_dup2_waddr)
    ,.wdata                   (rf_ll_sch_cnt_dup2_wdata)
    ,.rclk                    (rf_ll_sch_cnt_dup2_rclk)
    ,.rclk_rst_n              (rf_ll_sch_cnt_dup2_rclk_rst_n)
    ,.re                      (rf_ll_sch_cnt_dup2_re)
    ,.raddr                   (rf_ll_sch_cnt_dup2_raddr)
    ,.rdata                   (rf_ll_sch_cnt_dup2_rdata)

    ,.pgcb_isol_en            (rf_ll_sch_cnt_dup2_isol_en)
    ,.pwr_enable_b_in         (rf_ll_sch_cnt_dup2_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_ll_sch_cnt_dup2_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_2048x17 i_rf_ll_sch_cnt_dup3 (

     .wclk                    (rf_ll_sch_cnt_dup3_wclk)
    ,.wclk_rst_n              (rf_ll_sch_cnt_dup3_wclk_rst_n)
    ,.we                      (rf_ll_sch_cnt_dup3_we)
    ,.waddr                   (rf_ll_sch_cnt_dup3_waddr)
    ,.wdata                   (rf_ll_sch_cnt_dup3_wdata)
    ,.rclk                    (rf_ll_sch_cnt_dup3_rclk)
    ,.rclk_rst_n              (rf_ll_sch_cnt_dup3_rclk_rst_n)
    ,.re                      (rf_ll_sch_cnt_dup3_re)
    ,.raddr                   (rf_ll_sch_cnt_dup3_raddr)
    ,.rdata                   (rf_ll_sch_cnt_dup3_rdata)

    ,.pgcb_isol_en            (rf_ll_sch_cnt_dup3_isol_en)
    ,.pwr_enable_b_in         (rf_ll_sch_cnt_dup3_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_ll_sch_cnt_dup3_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_512x14 i_rf_ll_schlst_hp_bin0 (

     .wclk                    (rf_ll_schlst_hp_bin0_wclk)
    ,.wclk_rst_n              (rf_ll_schlst_hp_bin0_wclk_rst_n)
    ,.we                      (rf_ll_schlst_hp_bin0_we)
    ,.waddr                   (rf_ll_schlst_hp_bin0_waddr)
    ,.wdata                   (rf_ll_schlst_hp_bin0_wdata)
    ,.rclk                    (rf_ll_schlst_hp_bin0_rclk)
    ,.rclk_rst_n              (rf_ll_schlst_hp_bin0_rclk_rst_n)
    ,.re                      (rf_ll_schlst_hp_bin0_re)
    ,.raddr                   (rf_ll_schlst_hp_bin0_raddr)
    ,.rdata                   (rf_ll_schlst_hp_bin0_rdata)

    ,.pgcb_isol_en            (rf_ll_schlst_hp_bin0_isol_en)
    ,.pwr_enable_b_in         (rf_ll_schlst_hp_bin0_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_ll_schlst_hp_bin0_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_512x14 i_rf_ll_schlst_hp_bin1 (

     .wclk                    (rf_ll_schlst_hp_bin1_wclk)
    ,.wclk_rst_n              (rf_ll_schlst_hp_bin1_wclk_rst_n)
    ,.we                      (rf_ll_schlst_hp_bin1_we)
    ,.waddr                   (rf_ll_schlst_hp_bin1_waddr)
    ,.wdata                   (rf_ll_schlst_hp_bin1_wdata)
    ,.rclk                    (rf_ll_schlst_hp_bin1_rclk)
    ,.rclk_rst_n              (rf_ll_schlst_hp_bin1_rclk_rst_n)
    ,.re                      (rf_ll_schlst_hp_bin1_re)
    ,.raddr                   (rf_ll_schlst_hp_bin1_raddr)
    ,.rdata                   (rf_ll_schlst_hp_bin1_rdata)

    ,.pgcb_isol_en            (rf_ll_schlst_hp_bin1_isol_en)
    ,.pwr_enable_b_in         (rf_ll_schlst_hp_bin1_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_ll_schlst_hp_bin1_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_512x14 i_rf_ll_schlst_hp_bin2 (

     .wclk                    (rf_ll_schlst_hp_bin2_wclk)
    ,.wclk_rst_n              (rf_ll_schlst_hp_bin2_wclk_rst_n)
    ,.we                      (rf_ll_schlst_hp_bin2_we)
    ,.waddr                   (rf_ll_schlst_hp_bin2_waddr)
    ,.wdata                   (rf_ll_schlst_hp_bin2_wdata)
    ,.rclk                    (rf_ll_schlst_hp_bin2_rclk)
    ,.rclk_rst_n              (rf_ll_schlst_hp_bin2_rclk_rst_n)
    ,.re                      (rf_ll_schlst_hp_bin2_re)
    ,.raddr                   (rf_ll_schlst_hp_bin2_raddr)
    ,.rdata                   (rf_ll_schlst_hp_bin2_rdata)

    ,.pgcb_isol_en            (rf_ll_schlst_hp_bin2_isol_en)
    ,.pwr_enable_b_in         (rf_ll_schlst_hp_bin2_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_ll_schlst_hp_bin2_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_512x14 i_rf_ll_schlst_hp_bin3 (

     .wclk                    (rf_ll_schlst_hp_bin3_wclk)
    ,.wclk_rst_n              (rf_ll_schlst_hp_bin3_wclk_rst_n)
    ,.we                      (rf_ll_schlst_hp_bin3_we)
    ,.waddr                   (rf_ll_schlst_hp_bin3_waddr)
    ,.wdata                   (rf_ll_schlst_hp_bin3_wdata)
    ,.rclk                    (rf_ll_schlst_hp_bin3_rclk)
    ,.rclk_rst_n              (rf_ll_schlst_hp_bin3_rclk_rst_n)
    ,.re                      (rf_ll_schlst_hp_bin3_re)
    ,.raddr                   (rf_ll_schlst_hp_bin3_raddr)
    ,.rdata                   (rf_ll_schlst_hp_bin3_rdata)

    ,.pgcb_isol_en            (rf_ll_schlst_hp_bin3_isol_en)
    ,.pwr_enable_b_in         (rf_ll_schlst_hp_bin3_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_ll_schlst_hp_bin3_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_2048x16 i_rf_ll_schlst_hpnxt_bin0 (

     .wclk                    (rf_ll_schlst_hpnxt_bin0_wclk)
    ,.wclk_rst_n              (rf_ll_schlst_hpnxt_bin0_wclk_rst_n)
    ,.we                      (rf_ll_schlst_hpnxt_bin0_we)
    ,.waddr                   (rf_ll_schlst_hpnxt_bin0_waddr)
    ,.wdata                   (rf_ll_schlst_hpnxt_bin0_wdata)
    ,.rclk                    (rf_ll_schlst_hpnxt_bin0_rclk)
    ,.rclk_rst_n              (rf_ll_schlst_hpnxt_bin0_rclk_rst_n)
    ,.re                      (rf_ll_schlst_hpnxt_bin0_re)
    ,.raddr                   (rf_ll_schlst_hpnxt_bin0_raddr)
    ,.rdata                   (rf_ll_schlst_hpnxt_bin0_rdata)

    ,.pgcb_isol_en            (rf_ll_schlst_hpnxt_bin0_isol_en)
    ,.pwr_enable_b_in         (rf_ll_schlst_hpnxt_bin0_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_ll_schlst_hpnxt_bin0_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_2048x16 i_rf_ll_schlst_hpnxt_bin1 (

     .wclk                    (rf_ll_schlst_hpnxt_bin1_wclk)
    ,.wclk_rst_n              (rf_ll_schlst_hpnxt_bin1_wclk_rst_n)
    ,.we                      (rf_ll_schlst_hpnxt_bin1_we)
    ,.waddr                   (rf_ll_schlst_hpnxt_bin1_waddr)
    ,.wdata                   (rf_ll_schlst_hpnxt_bin1_wdata)
    ,.rclk                    (rf_ll_schlst_hpnxt_bin1_rclk)
    ,.rclk_rst_n              (rf_ll_schlst_hpnxt_bin1_rclk_rst_n)
    ,.re                      (rf_ll_schlst_hpnxt_bin1_re)
    ,.raddr                   (rf_ll_schlst_hpnxt_bin1_raddr)
    ,.rdata                   (rf_ll_schlst_hpnxt_bin1_rdata)

    ,.pgcb_isol_en            (rf_ll_schlst_hpnxt_bin1_isol_en)
    ,.pwr_enable_b_in         (rf_ll_schlst_hpnxt_bin1_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_ll_schlst_hpnxt_bin1_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_2048x16 i_rf_ll_schlst_hpnxt_bin2 (

     .wclk                    (rf_ll_schlst_hpnxt_bin2_wclk)
    ,.wclk_rst_n              (rf_ll_schlst_hpnxt_bin2_wclk_rst_n)
    ,.we                      (rf_ll_schlst_hpnxt_bin2_we)
    ,.waddr                   (rf_ll_schlst_hpnxt_bin2_waddr)
    ,.wdata                   (rf_ll_schlst_hpnxt_bin2_wdata)
    ,.rclk                    (rf_ll_schlst_hpnxt_bin2_rclk)
    ,.rclk_rst_n              (rf_ll_schlst_hpnxt_bin2_rclk_rst_n)
    ,.re                      (rf_ll_schlst_hpnxt_bin2_re)
    ,.raddr                   (rf_ll_schlst_hpnxt_bin2_raddr)
    ,.rdata                   (rf_ll_schlst_hpnxt_bin2_rdata)

    ,.pgcb_isol_en            (rf_ll_schlst_hpnxt_bin2_isol_en)
    ,.pwr_enable_b_in         (rf_ll_schlst_hpnxt_bin2_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_ll_schlst_hpnxt_bin2_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_2048x16 i_rf_ll_schlst_hpnxt_bin3 (

     .wclk                    (rf_ll_schlst_hpnxt_bin3_wclk)
    ,.wclk_rst_n              (rf_ll_schlst_hpnxt_bin3_wclk_rst_n)
    ,.we                      (rf_ll_schlst_hpnxt_bin3_we)
    ,.waddr                   (rf_ll_schlst_hpnxt_bin3_waddr)
    ,.wdata                   (rf_ll_schlst_hpnxt_bin3_wdata)
    ,.rclk                    (rf_ll_schlst_hpnxt_bin3_rclk)
    ,.rclk_rst_n              (rf_ll_schlst_hpnxt_bin3_rclk_rst_n)
    ,.re                      (rf_ll_schlst_hpnxt_bin3_re)
    ,.raddr                   (rf_ll_schlst_hpnxt_bin3_raddr)
    ,.rdata                   (rf_ll_schlst_hpnxt_bin3_rdata)

    ,.pgcb_isol_en            (rf_ll_schlst_hpnxt_bin3_isol_en)
    ,.pwr_enable_b_in         (rf_ll_schlst_hpnxt_bin3_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_ll_schlst_hpnxt_bin3_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_512x14 i_rf_ll_schlst_tp_bin0 (

     .wclk                    (rf_ll_schlst_tp_bin0_wclk)
    ,.wclk_rst_n              (rf_ll_schlst_tp_bin0_wclk_rst_n)
    ,.we                      (rf_ll_schlst_tp_bin0_we)
    ,.waddr                   (rf_ll_schlst_tp_bin0_waddr)
    ,.wdata                   (rf_ll_schlst_tp_bin0_wdata)
    ,.rclk                    (rf_ll_schlst_tp_bin0_rclk)
    ,.rclk_rst_n              (rf_ll_schlst_tp_bin0_rclk_rst_n)
    ,.re                      (rf_ll_schlst_tp_bin0_re)
    ,.raddr                   (rf_ll_schlst_tp_bin0_raddr)
    ,.rdata                   (rf_ll_schlst_tp_bin0_rdata)

    ,.pgcb_isol_en            (rf_ll_schlst_tp_bin0_isol_en)
    ,.pwr_enable_b_in         (rf_ll_schlst_tp_bin0_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_ll_schlst_tp_bin0_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_512x14 i_rf_ll_schlst_tp_bin1 (

     .wclk                    (rf_ll_schlst_tp_bin1_wclk)
    ,.wclk_rst_n              (rf_ll_schlst_tp_bin1_wclk_rst_n)
    ,.we                      (rf_ll_schlst_tp_bin1_we)
    ,.waddr                   (rf_ll_schlst_tp_bin1_waddr)
    ,.wdata                   (rf_ll_schlst_tp_bin1_wdata)
    ,.rclk                    (rf_ll_schlst_tp_bin1_rclk)
    ,.rclk_rst_n              (rf_ll_schlst_tp_bin1_rclk_rst_n)
    ,.re                      (rf_ll_schlst_tp_bin1_re)
    ,.raddr                   (rf_ll_schlst_tp_bin1_raddr)
    ,.rdata                   (rf_ll_schlst_tp_bin1_rdata)

    ,.pgcb_isol_en            (rf_ll_schlst_tp_bin1_isol_en)
    ,.pwr_enable_b_in         (rf_ll_schlst_tp_bin1_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_ll_schlst_tp_bin1_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_512x14 i_rf_ll_schlst_tp_bin2 (

     .wclk                    (rf_ll_schlst_tp_bin2_wclk)
    ,.wclk_rst_n              (rf_ll_schlst_tp_bin2_wclk_rst_n)
    ,.we                      (rf_ll_schlst_tp_bin2_we)
    ,.waddr                   (rf_ll_schlst_tp_bin2_waddr)
    ,.wdata                   (rf_ll_schlst_tp_bin2_wdata)
    ,.rclk                    (rf_ll_schlst_tp_bin2_rclk)
    ,.rclk_rst_n              (rf_ll_schlst_tp_bin2_rclk_rst_n)
    ,.re                      (rf_ll_schlst_tp_bin2_re)
    ,.raddr                   (rf_ll_schlst_tp_bin2_raddr)
    ,.rdata                   (rf_ll_schlst_tp_bin2_rdata)

    ,.pgcb_isol_en            (rf_ll_schlst_tp_bin2_isol_en)
    ,.pwr_enable_b_in         (rf_ll_schlst_tp_bin2_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_ll_schlst_tp_bin2_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_512x14 i_rf_ll_schlst_tp_bin3 (

     .wclk                    (rf_ll_schlst_tp_bin3_wclk)
    ,.wclk_rst_n              (rf_ll_schlst_tp_bin3_wclk_rst_n)
    ,.we                      (rf_ll_schlst_tp_bin3_we)
    ,.waddr                   (rf_ll_schlst_tp_bin3_waddr)
    ,.wdata                   (rf_ll_schlst_tp_bin3_wdata)
    ,.rclk                    (rf_ll_schlst_tp_bin3_rclk)
    ,.rclk_rst_n              (rf_ll_schlst_tp_bin3_rclk_rst_n)
    ,.re                      (rf_ll_schlst_tp_bin3_re)
    ,.raddr                   (rf_ll_schlst_tp_bin3_raddr)
    ,.rdata                   (rf_ll_schlst_tp_bin3_rdata)

    ,.pgcb_isol_en            (rf_ll_schlst_tp_bin3_isol_en)
    ,.pwr_enable_b_in         (rf_ll_schlst_tp_bin3_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_ll_schlst_tp_bin3_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_2048x16 i_rf_ll_schlst_tpprv_bin0 (

     .wclk                    (rf_ll_schlst_tpprv_bin0_wclk)
    ,.wclk_rst_n              (rf_ll_schlst_tpprv_bin0_wclk_rst_n)
    ,.we                      (rf_ll_schlst_tpprv_bin0_we)
    ,.waddr                   (rf_ll_schlst_tpprv_bin0_waddr)
    ,.wdata                   (rf_ll_schlst_tpprv_bin0_wdata)
    ,.rclk                    (rf_ll_schlst_tpprv_bin0_rclk)
    ,.rclk_rst_n              (rf_ll_schlst_tpprv_bin0_rclk_rst_n)
    ,.re                      (rf_ll_schlst_tpprv_bin0_re)
    ,.raddr                   (rf_ll_schlst_tpprv_bin0_raddr)
    ,.rdata                   (rf_ll_schlst_tpprv_bin0_rdata)

    ,.pgcb_isol_en            (rf_ll_schlst_tpprv_bin0_isol_en)
    ,.pwr_enable_b_in         (rf_ll_schlst_tpprv_bin0_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_ll_schlst_tpprv_bin0_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_2048x16 i_rf_ll_schlst_tpprv_bin1 (

     .wclk                    (rf_ll_schlst_tpprv_bin1_wclk)
    ,.wclk_rst_n              (rf_ll_schlst_tpprv_bin1_wclk_rst_n)
    ,.we                      (rf_ll_schlst_tpprv_bin1_we)
    ,.waddr                   (rf_ll_schlst_tpprv_bin1_waddr)
    ,.wdata                   (rf_ll_schlst_tpprv_bin1_wdata)
    ,.rclk                    (rf_ll_schlst_tpprv_bin1_rclk)
    ,.rclk_rst_n              (rf_ll_schlst_tpprv_bin1_rclk_rst_n)
    ,.re                      (rf_ll_schlst_tpprv_bin1_re)
    ,.raddr                   (rf_ll_schlst_tpprv_bin1_raddr)
    ,.rdata                   (rf_ll_schlst_tpprv_bin1_rdata)

    ,.pgcb_isol_en            (rf_ll_schlst_tpprv_bin1_isol_en)
    ,.pwr_enable_b_in         (rf_ll_schlst_tpprv_bin1_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_ll_schlst_tpprv_bin1_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_2048x16 i_rf_ll_schlst_tpprv_bin2 (

     .wclk                    (rf_ll_schlst_tpprv_bin2_wclk)
    ,.wclk_rst_n              (rf_ll_schlst_tpprv_bin2_wclk_rst_n)
    ,.we                      (rf_ll_schlst_tpprv_bin2_we)
    ,.waddr                   (rf_ll_schlst_tpprv_bin2_waddr)
    ,.wdata                   (rf_ll_schlst_tpprv_bin2_wdata)
    ,.rclk                    (rf_ll_schlst_tpprv_bin2_rclk)
    ,.rclk_rst_n              (rf_ll_schlst_tpprv_bin2_rclk_rst_n)
    ,.re                      (rf_ll_schlst_tpprv_bin2_re)
    ,.raddr                   (rf_ll_schlst_tpprv_bin2_raddr)
    ,.rdata                   (rf_ll_schlst_tpprv_bin2_rdata)

    ,.pgcb_isol_en            (rf_ll_schlst_tpprv_bin2_isol_en)
    ,.pwr_enable_b_in         (rf_ll_schlst_tpprv_bin2_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_ll_schlst_tpprv_bin2_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_2048x16 i_rf_ll_schlst_tpprv_bin3 (

     .wclk                    (rf_ll_schlst_tpprv_bin3_wclk)
    ,.wclk_rst_n              (rf_ll_schlst_tpprv_bin3_wclk_rst_n)
    ,.we                      (rf_ll_schlst_tpprv_bin3_we)
    ,.waddr                   (rf_ll_schlst_tpprv_bin3_waddr)
    ,.wdata                   (rf_ll_schlst_tpprv_bin3_wdata)
    ,.rclk                    (rf_ll_schlst_tpprv_bin3_rclk)
    ,.rclk_rst_n              (rf_ll_schlst_tpprv_bin3_rclk_rst_n)
    ,.re                      (rf_ll_schlst_tpprv_bin3_re)
    ,.raddr                   (rf_ll_schlst_tpprv_bin3_raddr)
    ,.rdata                   (rf_ll_schlst_tpprv_bin3_rdata)

    ,.pgcb_isol_en            (rf_ll_schlst_tpprv_bin3_isol_en)
    ,.pwr_enable_b_in         (rf_ll_schlst_tpprv_bin3_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_ll_schlst_tpprv_bin3_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_512x60 i_rf_ll_slst_cnt (

     .wclk                    (rf_ll_slst_cnt_wclk)
    ,.wclk_rst_n              (rf_ll_slst_cnt_wclk_rst_n)
    ,.we                      (rf_ll_slst_cnt_we)
    ,.waddr                   (rf_ll_slst_cnt_waddr)
    ,.wdata                   (rf_ll_slst_cnt_wdata)
    ,.rclk                    (rf_ll_slst_cnt_rclk)
    ,.rclk_rst_n              (rf_ll_slst_cnt_rclk_rst_n)
    ,.re                      (rf_ll_slst_cnt_re)
    ,.raddr                   (rf_ll_slst_cnt_raddr)
    ,.rdata                   (rf_ll_slst_cnt_rdata)

    ,.pgcb_isol_en            (rf_ll_slst_cnt_isol_en)
    ,.pwr_enable_b_in         (rf_ll_slst_cnt_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_ll_slst_cnt_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_8x18 i_rf_nalb_cmp_fifo_mem (

     .wclk                    (rf_nalb_cmp_fifo_mem_wclk)
    ,.wclk_rst_n              (rf_nalb_cmp_fifo_mem_wclk_rst_n)
    ,.we                      (rf_nalb_cmp_fifo_mem_we)
    ,.waddr                   (rf_nalb_cmp_fifo_mem_waddr)
    ,.wdata                   (rf_nalb_cmp_fifo_mem_wdata)
    ,.rclk                    (rf_nalb_cmp_fifo_mem_rclk)
    ,.rclk_rst_n              (rf_nalb_cmp_fifo_mem_rclk_rst_n)
    ,.re                      (rf_nalb_cmp_fifo_mem_re)
    ,.raddr                   (rf_nalb_cmp_fifo_mem_raddr)
    ,.rdata                   (rf_nalb_cmp_fifo_mem_rdata)

    ,.pgcb_isol_en            (rf_nalb_cmp_fifo_mem_isol_en)
    ,.pwr_enable_b_in         (rf_nalb_cmp_fifo_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_nalb_cmp_fifo_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_4x10 i_rf_nalb_lsp_enq_lb_rx_sync_fifo_mem (

     .wclk                    (rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_wclk)
    ,.wclk_rst_n              (rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_wclk_rst_n)
    ,.we                      (rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_we)
    ,.waddr                   (rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_waddr)
    ,.wdata                   (rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_wdata)
    ,.rclk                    (rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_rclk)
    ,.rclk_rst_n              (rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_rclk_rst_n)
    ,.re                      (rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_re)
    ,.raddr                   (rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_raddr)
    ,.rdata                   (rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_rdata)

    ,.pgcb_isol_en            (rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_isol_en)
    ,.pwr_enable_b_in         (rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_4x27 i_rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem (

     .wclk                    (rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_wclk)
    ,.wclk_rst_n              (rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_wclk_rst_n)
    ,.we                      (rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_we)
    ,.waddr                   (rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_waddr)
    ,.wdata                   (rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_wdata)
    ,.rclk                    (rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_rclk)
    ,.rclk_rst_n              (rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_rclk_rst_n)
    ,.re                      (rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_re)
    ,.raddr                   (rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_raddr)
    ,.rdata                   (rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_rdata)

    ,.pgcb_isol_en            (rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_isol_en)
    ,.pwr_enable_b_in         (rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_16x27 i_rf_nalb_sel_nalb_fifo_mem (

     .wclk                    (rf_nalb_sel_nalb_fifo_mem_wclk)
    ,.wclk_rst_n              (rf_nalb_sel_nalb_fifo_mem_wclk_rst_n)
    ,.we                      (rf_nalb_sel_nalb_fifo_mem_we)
    ,.waddr                   (rf_nalb_sel_nalb_fifo_mem_waddr)
    ,.wdata                   (rf_nalb_sel_nalb_fifo_mem_wdata)
    ,.rclk                    (rf_nalb_sel_nalb_fifo_mem_rclk)
    ,.rclk_rst_n              (rf_nalb_sel_nalb_fifo_mem_rclk_rst_n)
    ,.re                      (rf_nalb_sel_nalb_fifo_mem_re)
    ,.raddr                   (rf_nalb_sel_nalb_fifo_mem_raddr)
    ,.rdata                   (rf_nalb_sel_nalb_fifo_mem_rdata)

    ,.pgcb_isol_en            (rf_nalb_sel_nalb_fifo_mem_isol_en)
    ,.pwr_enable_b_in         (rf_nalb_sel_nalb_fifo_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_nalb_sel_nalb_fifo_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_24x9 i_rf_qed_lsp_deq_fifo_mem (

     .wclk                    (rf_qed_lsp_deq_fifo_mem_wclk)
    ,.wclk_rst_n              (rf_qed_lsp_deq_fifo_mem_wclk_rst_n)
    ,.we                      (rf_qed_lsp_deq_fifo_mem_we)
    ,.waddr                   (rf_qed_lsp_deq_fifo_mem_waddr)
    ,.wdata                   (rf_qed_lsp_deq_fifo_mem_wdata)
    ,.rclk                    (rf_qed_lsp_deq_fifo_mem_rclk)
    ,.rclk_rst_n              (rf_qed_lsp_deq_fifo_mem_rclk_rst_n)
    ,.re                      (rf_qed_lsp_deq_fifo_mem_re)
    ,.raddr                   (rf_qed_lsp_deq_fifo_mem_raddr)
    ,.rdata                   (rf_qed_lsp_deq_fifo_mem_rdata)

    ,.pgcb_isol_en            (rf_qed_lsp_deq_fifo_mem_isol_en)
    ,.pwr_enable_b_in         (rf_qed_lsp_deq_fifo_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_qed_lsp_deq_fifo_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_32x14 i_rf_qid_aqed_active_count_mem (

     .wclk                    (rf_qid_aqed_active_count_mem_wclk)
    ,.wclk_rst_n              (rf_qid_aqed_active_count_mem_wclk_rst_n)
    ,.we                      (rf_qid_aqed_active_count_mem_we)
    ,.waddr                   (rf_qid_aqed_active_count_mem_waddr)
    ,.wdata                   (rf_qid_aqed_active_count_mem_wdata)
    ,.rclk                    (rf_qid_aqed_active_count_mem_rclk)
    ,.rclk_rst_n              (rf_qid_aqed_active_count_mem_rclk_rst_n)
    ,.re                      (rf_qid_aqed_active_count_mem_re)
    ,.raddr                   (rf_qid_aqed_active_count_mem_raddr)
    ,.rdata                   (rf_qid_aqed_active_count_mem_rdata)

    ,.pgcb_isol_en            (rf_qid_aqed_active_count_mem_isol_en)
    ,.pwr_enable_b_in         (rf_qid_aqed_active_count_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_qid_aqed_active_count_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_32x17 i_rf_qid_atm_active_mem (

     .wclk                    (rf_qid_atm_active_mem_wclk)
    ,.wclk_rst_n              (rf_qid_atm_active_mem_wclk_rst_n)
    ,.we                      (rf_qid_atm_active_mem_we)
    ,.waddr                   (rf_qid_atm_active_mem_waddr)
    ,.wdata                   (rf_qid_atm_active_mem_wdata)
    ,.rclk                    (rf_qid_atm_active_mem_rclk)
    ,.rclk_rst_n              (rf_qid_atm_active_mem_rclk_rst_n)
    ,.re                      (rf_qid_atm_active_mem_re)
    ,.raddr                   (rf_qid_atm_active_mem_raddr)
    ,.rdata                   (rf_qid_atm_active_mem_rdata)

    ,.pgcb_isol_en            (rf_qid_atm_active_mem_isol_en)
    ,.pwr_enable_b_in         (rf_qid_atm_active_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_qid_atm_active_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_32x66 i_rf_qid_atm_tot_enq_cnt_mem (

     .wclk                    (rf_qid_atm_tot_enq_cnt_mem_wclk)
    ,.wclk_rst_n              (rf_qid_atm_tot_enq_cnt_mem_wclk_rst_n)
    ,.we                      (rf_qid_atm_tot_enq_cnt_mem_we)
    ,.waddr                   (rf_qid_atm_tot_enq_cnt_mem_waddr)
    ,.wdata                   (rf_qid_atm_tot_enq_cnt_mem_wdata)
    ,.rclk                    (rf_qid_atm_tot_enq_cnt_mem_rclk)
    ,.rclk_rst_n              (rf_qid_atm_tot_enq_cnt_mem_rclk_rst_n)
    ,.re                      (rf_qid_atm_tot_enq_cnt_mem_re)
    ,.raddr                   (rf_qid_atm_tot_enq_cnt_mem_raddr)
    ,.rdata                   (rf_qid_atm_tot_enq_cnt_mem_rdata)

    ,.pgcb_isol_en            (rf_qid_atm_tot_enq_cnt_mem_isol_en)
    ,.pwr_enable_b_in         (rf_qid_atm_tot_enq_cnt_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_qid_atm_tot_enq_cnt_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_32x17 i_rf_qid_atq_enqueue_count_mem (

     .wclk                    (rf_qid_atq_enqueue_count_mem_wclk)
    ,.wclk_rst_n              (rf_qid_atq_enqueue_count_mem_wclk_rst_n)
    ,.we                      (rf_qid_atq_enqueue_count_mem_we)
    ,.waddr                   (rf_qid_atq_enqueue_count_mem_waddr)
    ,.wdata                   (rf_qid_atq_enqueue_count_mem_wdata)
    ,.rclk                    (rf_qid_atq_enqueue_count_mem_rclk)
    ,.rclk_rst_n              (rf_qid_atq_enqueue_count_mem_rclk_rst_n)
    ,.re                      (rf_qid_atq_enqueue_count_mem_re)
    ,.raddr                   (rf_qid_atq_enqueue_count_mem_raddr)
    ,.rdata                   (rf_qid_atq_enqueue_count_mem_rdata)

    ,.pgcb_isol_en            (rf_qid_atq_enqueue_count_mem_isol_en)
    ,.pwr_enable_b_in         (rf_qid_atq_enqueue_count_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_qid_atq_enqueue_count_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_64x15 i_rf_qid_dir_max_depth_mem (

     .wclk                    (rf_qid_dir_max_depth_mem_wclk)
    ,.wclk_rst_n              (rf_qid_dir_max_depth_mem_wclk_rst_n)
    ,.we                      (rf_qid_dir_max_depth_mem_we)
    ,.waddr                   (rf_qid_dir_max_depth_mem_waddr)
    ,.wdata                   (rf_qid_dir_max_depth_mem_wdata)
    ,.rclk                    (rf_qid_dir_max_depth_mem_rclk)
    ,.rclk_rst_n              (rf_qid_dir_max_depth_mem_rclk_rst_n)
    ,.re                      (rf_qid_dir_max_depth_mem_re)
    ,.raddr                   (rf_qid_dir_max_depth_mem_raddr)
    ,.rdata                   (rf_qid_dir_max_depth_mem_rdata)

    ,.pgcb_isol_en            (rf_qid_dir_max_depth_mem_isol_en)
    ,.pwr_enable_b_in         (rf_qid_dir_max_depth_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_qid_dir_max_depth_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_32x17 i_rf_qid_dir_replay_count_mem (

     .wclk                    (rf_qid_dir_replay_count_mem_wclk)
    ,.wclk_rst_n              (rf_qid_dir_replay_count_mem_wclk_rst_n)
    ,.we                      (rf_qid_dir_replay_count_mem_we)
    ,.waddr                   (rf_qid_dir_replay_count_mem_waddr)
    ,.wdata                   (rf_qid_dir_replay_count_mem_wdata)
    ,.rclk                    (rf_qid_dir_replay_count_mem_rclk)
    ,.rclk_rst_n              (rf_qid_dir_replay_count_mem_rclk_rst_n)
    ,.re                      (rf_qid_dir_replay_count_mem_re)
    ,.raddr                   (rf_qid_dir_replay_count_mem_raddr)
    ,.rdata                   (rf_qid_dir_replay_count_mem_rdata)

    ,.pgcb_isol_en            (rf_qid_dir_replay_count_mem_isol_en)
    ,.pwr_enable_b_in         (rf_qid_dir_replay_count_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_qid_dir_replay_count_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_64x66 i_rf_qid_dir_tot_enq_cnt_mem (

     .wclk                    (rf_qid_dir_tot_enq_cnt_mem_wclk)
    ,.wclk_rst_n              (rf_qid_dir_tot_enq_cnt_mem_wclk_rst_n)
    ,.we                      (rf_qid_dir_tot_enq_cnt_mem_we)
    ,.waddr                   (rf_qid_dir_tot_enq_cnt_mem_waddr)
    ,.wdata                   (rf_qid_dir_tot_enq_cnt_mem_wdata)
    ,.rclk                    (rf_qid_dir_tot_enq_cnt_mem_rclk)
    ,.rclk_rst_n              (rf_qid_dir_tot_enq_cnt_mem_rclk_rst_n)
    ,.re                      (rf_qid_dir_tot_enq_cnt_mem_re)
    ,.raddr                   (rf_qid_dir_tot_enq_cnt_mem_raddr)
    ,.rdata                   (rf_qid_dir_tot_enq_cnt_mem_rdata)

    ,.pgcb_isol_en            (rf_qid_dir_tot_enq_cnt_mem_isol_en)
    ,.pwr_enable_b_in         (rf_qid_dir_tot_enq_cnt_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_qid_dir_tot_enq_cnt_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_32x17 i_rf_qid_ldb_enqueue_count_mem (

     .wclk                    (rf_qid_ldb_enqueue_count_mem_wclk)
    ,.wclk_rst_n              (rf_qid_ldb_enqueue_count_mem_wclk_rst_n)
    ,.we                      (rf_qid_ldb_enqueue_count_mem_we)
    ,.waddr                   (rf_qid_ldb_enqueue_count_mem_waddr)
    ,.wdata                   (rf_qid_ldb_enqueue_count_mem_wdata)
    ,.rclk                    (rf_qid_ldb_enqueue_count_mem_rclk)
    ,.rclk_rst_n              (rf_qid_ldb_enqueue_count_mem_rclk_rst_n)
    ,.re                      (rf_qid_ldb_enqueue_count_mem_re)
    ,.raddr                   (rf_qid_ldb_enqueue_count_mem_raddr)
    ,.rdata                   (rf_qid_ldb_enqueue_count_mem_rdata)

    ,.pgcb_isol_en            (rf_qid_ldb_enqueue_count_mem_isol_en)
    ,.pwr_enable_b_in         (rf_qid_ldb_enqueue_count_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_qid_ldb_enqueue_count_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_32x14 i_rf_qid_ldb_inflight_count_mem (

     .wclk                    (rf_qid_ldb_inflight_count_mem_wclk)
    ,.wclk_rst_n              (rf_qid_ldb_inflight_count_mem_wclk_rst_n)
    ,.we                      (rf_qid_ldb_inflight_count_mem_we)
    ,.waddr                   (rf_qid_ldb_inflight_count_mem_waddr)
    ,.wdata                   (rf_qid_ldb_inflight_count_mem_wdata)
    ,.rclk                    (rf_qid_ldb_inflight_count_mem_rclk)
    ,.rclk_rst_n              (rf_qid_ldb_inflight_count_mem_rclk_rst_n)
    ,.re                      (rf_qid_ldb_inflight_count_mem_re)
    ,.raddr                   (rf_qid_ldb_inflight_count_mem_raddr)
    ,.rdata                   (rf_qid_ldb_inflight_count_mem_rdata)

    ,.pgcb_isol_en            (rf_qid_ldb_inflight_count_mem_isol_en)
    ,.pwr_enable_b_in         (rf_qid_ldb_inflight_count_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_qid_ldb_inflight_count_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_32x17 i_rf_qid_ldb_replay_count_mem (

     .wclk                    (rf_qid_ldb_replay_count_mem_wclk)
    ,.wclk_rst_n              (rf_qid_ldb_replay_count_mem_wclk_rst_n)
    ,.we                      (rf_qid_ldb_replay_count_mem_we)
    ,.waddr                   (rf_qid_ldb_replay_count_mem_waddr)
    ,.wdata                   (rf_qid_ldb_replay_count_mem_wdata)
    ,.rclk                    (rf_qid_ldb_replay_count_mem_rclk)
    ,.rclk_rst_n              (rf_qid_ldb_replay_count_mem_rclk_rst_n)
    ,.re                      (rf_qid_ldb_replay_count_mem_re)
    ,.raddr                   (rf_qid_ldb_replay_count_mem_raddr)
    ,.rdata                   (rf_qid_ldb_replay_count_mem_rdata)

    ,.pgcb_isol_en            (rf_qid_ldb_replay_count_mem_isol_en)
    ,.pwr_enable_b_in         (rf_qid_ldb_replay_count_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_qid_ldb_replay_count_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_32x15 i_rf_qid_naldb_max_depth_mem (

     .wclk                    (rf_qid_naldb_max_depth_mem_wclk)
    ,.wclk_rst_n              (rf_qid_naldb_max_depth_mem_wclk_rst_n)
    ,.we                      (rf_qid_naldb_max_depth_mem_we)
    ,.waddr                   (rf_qid_naldb_max_depth_mem_waddr)
    ,.wdata                   (rf_qid_naldb_max_depth_mem_wdata)
    ,.rclk                    (rf_qid_naldb_max_depth_mem_rclk)
    ,.rclk_rst_n              (rf_qid_naldb_max_depth_mem_rclk_rst_n)
    ,.re                      (rf_qid_naldb_max_depth_mem_re)
    ,.raddr                   (rf_qid_naldb_max_depth_mem_raddr)
    ,.rdata                   (rf_qid_naldb_max_depth_mem_rdata)

    ,.pgcb_isol_en            (rf_qid_naldb_max_depth_mem_isol_en)
    ,.pwr_enable_b_in         (rf_qid_naldb_max_depth_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_qid_naldb_max_depth_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_32x66 i_rf_qid_naldb_tot_enq_cnt_mem (

     .wclk                    (rf_qid_naldb_tot_enq_cnt_mem_wclk)
    ,.wclk_rst_n              (rf_qid_naldb_tot_enq_cnt_mem_wclk_rst_n)
    ,.we                      (rf_qid_naldb_tot_enq_cnt_mem_we)
    ,.waddr                   (rf_qid_naldb_tot_enq_cnt_mem_waddr)
    ,.wdata                   (rf_qid_naldb_tot_enq_cnt_mem_wdata)
    ,.rclk                    (rf_qid_naldb_tot_enq_cnt_mem_rclk)
    ,.rclk_rst_n              (rf_qid_naldb_tot_enq_cnt_mem_rclk_rst_n)
    ,.re                      (rf_qid_naldb_tot_enq_cnt_mem_re)
    ,.raddr                   (rf_qid_naldb_tot_enq_cnt_mem_raddr)
    ,.rdata                   (rf_qid_naldb_tot_enq_cnt_mem_rdata)

    ,.pgcb_isol_en            (rf_qid_naldb_tot_enq_cnt_mem_isol_en)
    ,.pwr_enable_b_in         (rf_qid_naldb_tot_enq_cnt_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_qid_naldb_tot_enq_cnt_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_32x6 i_rf_qid_rdylst_clamp (

     .wclk                    (rf_qid_rdylst_clamp_wclk)
    ,.wclk_rst_n              (rf_qid_rdylst_clamp_wclk_rst_n)
    ,.we                      (rf_qid_rdylst_clamp_we)
    ,.waddr                   (rf_qid_rdylst_clamp_waddr)
    ,.wdata                   (rf_qid_rdylst_clamp_wdata)
    ,.rclk                    (rf_qid_rdylst_clamp_rclk)
    ,.rclk_rst_n              (rf_qid_rdylst_clamp_rclk_rst_n)
    ,.re                      (rf_qid_rdylst_clamp_re)
    ,.raddr                   (rf_qid_rdylst_clamp_raddr)
    ,.rdata                   (rf_qid_rdylst_clamp_rdata)

    ,.pgcb_isol_en            (rf_qid_rdylst_clamp_isol_en)
    ,.pwr_enable_b_in         (rf_qid_rdylst_clamp_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_qid_rdylst_clamp_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_8x17 i_rf_rop_lsp_reordercmp_rx_sync_fifo_mem (

     .wclk                    (rf_rop_lsp_reordercmp_rx_sync_fifo_mem_wclk)
    ,.wclk_rst_n              (rf_rop_lsp_reordercmp_rx_sync_fifo_mem_wclk_rst_n)
    ,.we                      (rf_rop_lsp_reordercmp_rx_sync_fifo_mem_we)
    ,.waddr                   (rf_rop_lsp_reordercmp_rx_sync_fifo_mem_waddr)
    ,.wdata                   (rf_rop_lsp_reordercmp_rx_sync_fifo_mem_wdata)
    ,.rclk                    (rf_rop_lsp_reordercmp_rx_sync_fifo_mem_rclk)
    ,.rclk_rst_n              (rf_rop_lsp_reordercmp_rx_sync_fifo_mem_rclk_rst_n)
    ,.re                      (rf_rop_lsp_reordercmp_rx_sync_fifo_mem_re)
    ,.raddr                   (rf_rop_lsp_reordercmp_rx_sync_fifo_mem_raddr)
    ,.rdata                   (rf_rop_lsp_reordercmp_rx_sync_fifo_mem_rdata)

    ,.pgcb_isol_en            (rf_rop_lsp_reordercmp_rx_sync_fifo_mem_isol_en)
    ,.pwr_enable_b_in         (rf_rop_lsp_reordercmp_rx_sync_fifo_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_rop_lsp_reordercmp_rx_sync_fifo_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_4x139 i_rf_rx_sync_qed_aqed_enq (

     .wclk                    (rf_rx_sync_qed_aqed_enq_wclk)
    ,.wclk_rst_n              (rf_rx_sync_qed_aqed_enq_wclk_rst_n)
    ,.we                      (rf_rx_sync_qed_aqed_enq_we)
    ,.waddr                   (rf_rx_sync_qed_aqed_enq_waddr)
    ,.wdata                   (rf_rx_sync_qed_aqed_enq_wdata)
    ,.rclk                    (rf_rx_sync_qed_aqed_enq_rclk)
    ,.rclk_rst_n              (rf_rx_sync_qed_aqed_enq_rclk_rst_n)
    ,.re                      (rf_rx_sync_qed_aqed_enq_re)
    ,.raddr                   (rf_rx_sync_qed_aqed_enq_raddr)
    ,.rdata                   (rf_rx_sync_qed_aqed_enq_rdata)

    ,.pgcb_isol_en            (rf_rx_sync_qed_aqed_enq_isol_en)
    ,.pwr_enable_b_in         (rf_rx_sync_qed_aqed_enq_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_rx_sync_qed_aqed_enq_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_4x35 i_rf_send_atm_to_cq_rx_sync_fifo_mem (

     .wclk                    (rf_send_atm_to_cq_rx_sync_fifo_mem_wclk)
    ,.wclk_rst_n              (rf_send_atm_to_cq_rx_sync_fifo_mem_wclk_rst_n)
    ,.we                      (rf_send_atm_to_cq_rx_sync_fifo_mem_we)
    ,.waddr                   (rf_send_atm_to_cq_rx_sync_fifo_mem_waddr)
    ,.wdata                   (rf_send_atm_to_cq_rx_sync_fifo_mem_wdata)
    ,.rclk                    (rf_send_atm_to_cq_rx_sync_fifo_mem_rclk)
    ,.rclk_rst_n              (rf_send_atm_to_cq_rx_sync_fifo_mem_rclk_rst_n)
    ,.re                      (rf_send_atm_to_cq_rx_sync_fifo_mem_re)
    ,.raddr                   (rf_send_atm_to_cq_rx_sync_fifo_mem_raddr)
    ,.rdata                   (rf_send_atm_to_cq_rx_sync_fifo_mem_rdata)

    ,.pgcb_isol_en            (rf_send_atm_to_cq_rx_sync_fifo_mem_isol_en)
    ,.pwr_enable_b_in         (rf_send_atm_to_cq_rx_sync_fifo_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_send_atm_to_cq_rx_sync_fifo_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_list_sel_mem_AW_rf_pg_8x20 i_rf_uno_atm_cmp_fifo_mem (

     .wclk                    (rf_uno_atm_cmp_fifo_mem_wclk)
    ,.wclk_rst_n              (rf_uno_atm_cmp_fifo_mem_wclk_rst_n)
    ,.we                      (rf_uno_atm_cmp_fifo_mem_we)
    ,.waddr                   (rf_uno_atm_cmp_fifo_mem_waddr)
    ,.wdata                   (rf_uno_atm_cmp_fifo_mem_wdata)
    ,.rclk                    (rf_uno_atm_cmp_fifo_mem_rclk)
    ,.rclk_rst_n              (rf_uno_atm_cmp_fifo_mem_rclk_rst_n)
    ,.re                      (rf_uno_atm_cmp_fifo_mem_re)
    ,.raddr                   (rf_uno_atm_cmp_fifo_mem_raddr)
    ,.rdata                   (rf_uno_atm_cmp_fifo_mem_rdata)

    ,.pgcb_isol_en            (rf_uno_atm_cmp_fifo_mem_isol_en)
    ,.pwr_enable_b_in         (rf_uno_atm_cmp_fifo_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_uno_atm_cmp_fifo_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

endmodule

