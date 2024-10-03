module hqm_list_sel_mem (

     input  logic                       bcam_AW_bcam_2048x26_wclk
    ,input  logic[ 64 -1 : 0 ]          bcam_AW_bcam_2048x26_waddr
    ,input  logic[ 8  -1 : 0 ]          bcam_AW_bcam_2048x26_we
    ,input  logic[ 208 -1 : 0 ]         bcam_AW_bcam_2048x26_wdata
    ,input  logic                       bcam_AW_bcam_2048x26_rclk
    ,input  logic[ 8-1 : 0 ]            bcam_AW_bcam_2048x26_raddr
    ,input  logic                       bcam_AW_bcam_2048x26_re
    ,output logic[ 208 -1 : 0 ]         bcam_AW_bcam_2048x26_rdata
    ,input  logic                       bcam_AW_bcam_2048x26_cclk
    ,input  logic[ 208 -1 : 0 ]         bcam_AW_bcam_2048x26_cdata
    ,input  logic[ 8  -1 : 0 ]          bcam_AW_bcam_2048x26_ce
    ,output logic[ 2048 -1 : 0 ]        bcam_AW_bcam_2048x26_cmatch

    ,input  logic                       bcam_AW_bcam_2048x26_isol_en_b
    ,input  logic                       bcam_AW_bcam_2048x26_dfx_clk

    ,input  logic                       bcam_AW_bcam_2048x26_fd
    ,input  logic                       bcam_AW_bcam_2048x26_rd

    ,input  logic                       rf_aqed_fid_cnt_wclk
    ,input  logic                       rf_aqed_fid_cnt_wclk_rst_n
    ,input  logic                       rf_aqed_fid_cnt_we
    ,input  logic[ (  11 ) -1 : 0 ]     rf_aqed_fid_cnt_waddr
    ,input  logic[ (  17 ) -1 : 0 ]     rf_aqed_fid_cnt_wdata
    ,input  logic                       rf_aqed_fid_cnt_rclk
    ,input  logic                       rf_aqed_fid_cnt_rclk_rst_n
    ,input  logic                       rf_aqed_fid_cnt_re
    ,input  logic[ (  11 ) -1 : 0 ]     rf_aqed_fid_cnt_raddr
    ,output logic[ (  17 ) -1 : 0 ]     rf_aqed_fid_cnt_rdata

    ,input  logic                       rf_aqed_fid_cnt_isol_en
    ,input  logic                       rf_aqed_fid_cnt_pwr_enable_b_in
    ,output logic                       rf_aqed_fid_cnt_pwr_enable_b_out

    ,input  logic                       rf_aqed_fifo_ap_aqed_wclk
    ,input  logic                       rf_aqed_fifo_ap_aqed_wclk_rst_n
    ,input  logic                       rf_aqed_fifo_ap_aqed_we
    ,input  logic[ (   4 ) -1 : 0 ]     rf_aqed_fifo_ap_aqed_waddr
    ,input  logic[ (  45 ) -1 : 0 ]     rf_aqed_fifo_ap_aqed_wdata
    ,input  logic                       rf_aqed_fifo_ap_aqed_rclk
    ,input  logic                       rf_aqed_fifo_ap_aqed_rclk_rst_n
    ,input  logic                       rf_aqed_fifo_ap_aqed_re
    ,input  logic[ (   4 ) -1 : 0 ]     rf_aqed_fifo_ap_aqed_raddr
    ,output logic[ (  45 ) -1 : 0 ]     rf_aqed_fifo_ap_aqed_rdata

    ,input  logic                       rf_aqed_fifo_ap_aqed_isol_en
    ,input  logic                       rf_aqed_fifo_ap_aqed_pwr_enable_b_in
    ,output logic                       rf_aqed_fifo_ap_aqed_pwr_enable_b_out

    ,input  logic                       rf_aqed_fifo_aqed_ap_enq_wclk
    ,input  logic                       rf_aqed_fifo_aqed_ap_enq_wclk_rst_n
    ,input  logic                       rf_aqed_fifo_aqed_ap_enq_we
    ,input  logic[ (   4 ) -1 : 0 ]     rf_aqed_fifo_aqed_ap_enq_waddr
    ,input  logic[ (  24 ) -1 : 0 ]     rf_aqed_fifo_aqed_ap_enq_wdata
    ,input  logic                       rf_aqed_fifo_aqed_ap_enq_rclk
    ,input  logic                       rf_aqed_fifo_aqed_ap_enq_rclk_rst_n
    ,input  logic                       rf_aqed_fifo_aqed_ap_enq_re
    ,input  logic[ (   4 ) -1 : 0 ]     rf_aqed_fifo_aqed_ap_enq_raddr
    ,output logic[ (  24 ) -1 : 0 ]     rf_aqed_fifo_aqed_ap_enq_rdata

    ,input  logic                       rf_aqed_fifo_aqed_ap_enq_isol_en
    ,input  logic                       rf_aqed_fifo_aqed_ap_enq_pwr_enable_b_in
    ,output logic                       rf_aqed_fifo_aqed_ap_enq_pwr_enable_b_out

    ,input  logic                       rf_aqed_fifo_aqed_chp_sch_wclk
    ,input  logic                       rf_aqed_fifo_aqed_chp_sch_wclk_rst_n
    ,input  logic                       rf_aqed_fifo_aqed_chp_sch_we
    ,input  logic[ (   4 ) -1 : 0 ]     rf_aqed_fifo_aqed_chp_sch_waddr
    ,input  logic[ ( 180 ) -1 : 0 ]     rf_aqed_fifo_aqed_chp_sch_wdata
    ,input  logic                       rf_aqed_fifo_aqed_chp_sch_rclk
    ,input  logic                       rf_aqed_fifo_aqed_chp_sch_rclk_rst_n
    ,input  logic                       rf_aqed_fifo_aqed_chp_sch_re
    ,input  logic[ (   4 ) -1 : 0 ]     rf_aqed_fifo_aqed_chp_sch_raddr
    ,output logic[ ( 180 ) -1 : 0 ]     rf_aqed_fifo_aqed_chp_sch_rdata

    ,input  logic                       rf_aqed_fifo_aqed_chp_sch_isol_en
    ,input  logic                       rf_aqed_fifo_aqed_chp_sch_pwr_enable_b_in
    ,output logic                       rf_aqed_fifo_aqed_chp_sch_pwr_enable_b_out

    ,input  logic                       rf_aqed_fifo_freelist_return_wclk
    ,input  logic                       rf_aqed_fifo_freelist_return_wclk_rst_n
    ,input  logic                       rf_aqed_fifo_freelist_return_we
    ,input  logic[ (   4 ) -1 : 0 ]     rf_aqed_fifo_freelist_return_waddr
    ,input  logic[ (  32 ) -1 : 0 ]     rf_aqed_fifo_freelist_return_wdata
    ,input  logic                       rf_aqed_fifo_freelist_return_rclk
    ,input  logic                       rf_aqed_fifo_freelist_return_rclk_rst_n
    ,input  logic                       rf_aqed_fifo_freelist_return_re
    ,input  logic[ (   4 ) -1 : 0 ]     rf_aqed_fifo_freelist_return_raddr
    ,output logic[ (  32 ) -1 : 0 ]     rf_aqed_fifo_freelist_return_rdata

    ,input  logic                       rf_aqed_fifo_freelist_return_isol_en
    ,input  logic                       rf_aqed_fifo_freelist_return_pwr_enable_b_in
    ,output logic                       rf_aqed_fifo_freelist_return_pwr_enable_b_out

    ,input  logic                       rf_aqed_fifo_lsp_aqed_cmp_wclk
    ,input  logic                       rf_aqed_fifo_lsp_aqed_cmp_wclk_rst_n
    ,input  logic                       rf_aqed_fifo_lsp_aqed_cmp_we
    ,input  logic[ (   4 ) -1 : 0 ]     rf_aqed_fifo_lsp_aqed_cmp_waddr
    ,input  logic[ (  35 ) -1 : 0 ]     rf_aqed_fifo_lsp_aqed_cmp_wdata
    ,input  logic                       rf_aqed_fifo_lsp_aqed_cmp_rclk
    ,input  logic                       rf_aqed_fifo_lsp_aqed_cmp_rclk_rst_n
    ,input  logic                       rf_aqed_fifo_lsp_aqed_cmp_re
    ,input  logic[ (   4 ) -1 : 0 ]     rf_aqed_fifo_lsp_aqed_cmp_raddr
    ,output logic[ (  35 ) -1 : 0 ]     rf_aqed_fifo_lsp_aqed_cmp_rdata

    ,input  logic                       rf_aqed_fifo_lsp_aqed_cmp_isol_en
    ,input  logic                       rf_aqed_fifo_lsp_aqed_cmp_pwr_enable_b_in
    ,output logic                       rf_aqed_fifo_lsp_aqed_cmp_pwr_enable_b_out

    ,input  logic                       rf_aqed_fifo_qed_aqed_enq_wclk
    ,input  logic                       rf_aqed_fifo_qed_aqed_enq_wclk_rst_n
    ,input  logic                       rf_aqed_fifo_qed_aqed_enq_we
    ,input  logic[ (   2 ) -1 : 0 ]     rf_aqed_fifo_qed_aqed_enq_waddr
    ,input  logic[ ( 155 ) -1 : 0 ]     rf_aqed_fifo_qed_aqed_enq_wdata
    ,input  logic                       rf_aqed_fifo_qed_aqed_enq_rclk
    ,input  logic                       rf_aqed_fifo_qed_aqed_enq_rclk_rst_n
    ,input  logic                       rf_aqed_fifo_qed_aqed_enq_re
    ,input  logic[ (   2 ) -1 : 0 ]     rf_aqed_fifo_qed_aqed_enq_raddr
    ,output logic[ ( 155 ) -1 : 0 ]     rf_aqed_fifo_qed_aqed_enq_rdata

    ,input  logic                       rf_aqed_fifo_qed_aqed_enq_isol_en
    ,input  logic                       rf_aqed_fifo_qed_aqed_enq_pwr_enable_b_in
    ,output logic                       rf_aqed_fifo_qed_aqed_enq_pwr_enable_b_out

    ,input  logic                       rf_aqed_fifo_qed_aqed_enq_fid_wclk
    ,input  logic                       rf_aqed_fifo_qed_aqed_enq_fid_wclk_rst_n
    ,input  logic                       rf_aqed_fifo_qed_aqed_enq_fid_we
    ,input  logic[ (   3 ) -1 : 0 ]     rf_aqed_fifo_qed_aqed_enq_fid_waddr
    ,input  logic[ ( 153 ) -1 : 0 ]     rf_aqed_fifo_qed_aqed_enq_fid_wdata
    ,input  logic                       rf_aqed_fifo_qed_aqed_enq_fid_rclk
    ,input  logic                       rf_aqed_fifo_qed_aqed_enq_fid_rclk_rst_n
    ,input  logic                       rf_aqed_fifo_qed_aqed_enq_fid_re
    ,input  logic[ (   3 ) -1 : 0 ]     rf_aqed_fifo_qed_aqed_enq_fid_raddr
    ,output logic[ ( 153 ) -1 : 0 ]     rf_aqed_fifo_qed_aqed_enq_fid_rdata

    ,input  logic                       rf_aqed_fifo_qed_aqed_enq_fid_isol_en
    ,input  logic                       rf_aqed_fifo_qed_aqed_enq_fid_pwr_enable_b_in
    ,output logic                       rf_aqed_fifo_qed_aqed_enq_fid_pwr_enable_b_out

    ,input  logic                       rf_aqed_ll_cnt_pri0_wclk
    ,input  logic                       rf_aqed_ll_cnt_pri0_wclk_rst_n
    ,input  logic                       rf_aqed_ll_cnt_pri0_we
    ,input  logic[ (  11 ) -1 : 0 ]     rf_aqed_ll_cnt_pri0_waddr
    ,input  logic[ (  16 ) -1 : 0 ]     rf_aqed_ll_cnt_pri0_wdata
    ,input  logic                       rf_aqed_ll_cnt_pri0_rclk
    ,input  logic                       rf_aqed_ll_cnt_pri0_rclk_rst_n
    ,input  logic                       rf_aqed_ll_cnt_pri0_re
    ,input  logic[ (  11 ) -1 : 0 ]     rf_aqed_ll_cnt_pri0_raddr
    ,output logic[ (  16 ) -1 : 0 ]     rf_aqed_ll_cnt_pri0_rdata

    ,input  logic                       rf_aqed_ll_cnt_pri0_isol_en
    ,input  logic                       rf_aqed_ll_cnt_pri0_pwr_enable_b_in
    ,output logic                       rf_aqed_ll_cnt_pri0_pwr_enable_b_out

    ,input  logic                       rf_aqed_ll_cnt_pri1_wclk
    ,input  logic                       rf_aqed_ll_cnt_pri1_wclk_rst_n
    ,input  logic                       rf_aqed_ll_cnt_pri1_we
    ,input  logic[ (  11 ) -1 : 0 ]     rf_aqed_ll_cnt_pri1_waddr
    ,input  logic[ (  16 ) -1 : 0 ]     rf_aqed_ll_cnt_pri1_wdata
    ,input  logic                       rf_aqed_ll_cnt_pri1_rclk
    ,input  logic                       rf_aqed_ll_cnt_pri1_rclk_rst_n
    ,input  logic                       rf_aqed_ll_cnt_pri1_re
    ,input  logic[ (  11 ) -1 : 0 ]     rf_aqed_ll_cnt_pri1_raddr
    ,output logic[ (  16 ) -1 : 0 ]     rf_aqed_ll_cnt_pri1_rdata

    ,input  logic                       rf_aqed_ll_cnt_pri1_isol_en
    ,input  logic                       rf_aqed_ll_cnt_pri1_pwr_enable_b_in
    ,output logic                       rf_aqed_ll_cnt_pri1_pwr_enable_b_out

    ,input  logic                       rf_aqed_ll_cnt_pri2_wclk
    ,input  logic                       rf_aqed_ll_cnt_pri2_wclk_rst_n
    ,input  logic                       rf_aqed_ll_cnt_pri2_we
    ,input  logic[ (  11 ) -1 : 0 ]     rf_aqed_ll_cnt_pri2_waddr
    ,input  logic[ (  16 ) -1 : 0 ]     rf_aqed_ll_cnt_pri2_wdata
    ,input  logic                       rf_aqed_ll_cnt_pri2_rclk
    ,input  logic                       rf_aqed_ll_cnt_pri2_rclk_rst_n
    ,input  logic                       rf_aqed_ll_cnt_pri2_re
    ,input  logic[ (  11 ) -1 : 0 ]     rf_aqed_ll_cnt_pri2_raddr
    ,output logic[ (  16 ) -1 : 0 ]     rf_aqed_ll_cnt_pri2_rdata

    ,input  logic                       rf_aqed_ll_cnt_pri2_isol_en
    ,input  logic                       rf_aqed_ll_cnt_pri2_pwr_enable_b_in
    ,output logic                       rf_aqed_ll_cnt_pri2_pwr_enable_b_out

    ,input  logic                       rf_aqed_ll_cnt_pri3_wclk
    ,input  logic                       rf_aqed_ll_cnt_pri3_wclk_rst_n
    ,input  logic                       rf_aqed_ll_cnt_pri3_we
    ,input  logic[ (  11 ) -1 : 0 ]     rf_aqed_ll_cnt_pri3_waddr
    ,input  logic[ (  16 ) -1 : 0 ]     rf_aqed_ll_cnt_pri3_wdata
    ,input  logic                       rf_aqed_ll_cnt_pri3_rclk
    ,input  logic                       rf_aqed_ll_cnt_pri3_rclk_rst_n
    ,input  logic                       rf_aqed_ll_cnt_pri3_re
    ,input  logic[ (  11 ) -1 : 0 ]     rf_aqed_ll_cnt_pri3_raddr
    ,output logic[ (  16 ) -1 : 0 ]     rf_aqed_ll_cnt_pri3_rdata

    ,input  logic                       rf_aqed_ll_cnt_pri3_isol_en
    ,input  logic                       rf_aqed_ll_cnt_pri3_pwr_enable_b_in
    ,output logic                       rf_aqed_ll_cnt_pri3_pwr_enable_b_out

    ,input  logic                       rf_aqed_ll_qe_hp_pri0_wclk
    ,input  logic                       rf_aqed_ll_qe_hp_pri0_wclk_rst_n
    ,input  logic                       rf_aqed_ll_qe_hp_pri0_we
    ,input  logic[ (  11 ) -1 : 0 ]     rf_aqed_ll_qe_hp_pri0_waddr
    ,input  logic[ (  14 ) -1 : 0 ]     rf_aqed_ll_qe_hp_pri0_wdata
    ,input  logic                       rf_aqed_ll_qe_hp_pri0_rclk
    ,input  logic                       rf_aqed_ll_qe_hp_pri0_rclk_rst_n
    ,input  logic                       rf_aqed_ll_qe_hp_pri0_re
    ,input  logic[ (  11 ) -1 : 0 ]     rf_aqed_ll_qe_hp_pri0_raddr
    ,output logic[ (  14 ) -1 : 0 ]     rf_aqed_ll_qe_hp_pri0_rdata

    ,input  logic                       rf_aqed_ll_qe_hp_pri0_isol_en
    ,input  logic                       rf_aqed_ll_qe_hp_pri0_pwr_enable_b_in
    ,output logic                       rf_aqed_ll_qe_hp_pri0_pwr_enable_b_out

    ,input  logic                       rf_aqed_ll_qe_hp_pri1_wclk
    ,input  logic                       rf_aqed_ll_qe_hp_pri1_wclk_rst_n
    ,input  logic                       rf_aqed_ll_qe_hp_pri1_we
    ,input  logic[ (  11 ) -1 : 0 ]     rf_aqed_ll_qe_hp_pri1_waddr
    ,input  logic[ (  14 ) -1 : 0 ]     rf_aqed_ll_qe_hp_pri1_wdata
    ,input  logic                       rf_aqed_ll_qe_hp_pri1_rclk
    ,input  logic                       rf_aqed_ll_qe_hp_pri1_rclk_rst_n
    ,input  logic                       rf_aqed_ll_qe_hp_pri1_re
    ,input  logic[ (  11 ) -1 : 0 ]     rf_aqed_ll_qe_hp_pri1_raddr
    ,output logic[ (  14 ) -1 : 0 ]     rf_aqed_ll_qe_hp_pri1_rdata

    ,input  logic                       rf_aqed_ll_qe_hp_pri1_isol_en
    ,input  logic                       rf_aqed_ll_qe_hp_pri1_pwr_enable_b_in
    ,output logic                       rf_aqed_ll_qe_hp_pri1_pwr_enable_b_out

    ,input  logic                       rf_aqed_ll_qe_hp_pri2_wclk
    ,input  logic                       rf_aqed_ll_qe_hp_pri2_wclk_rst_n
    ,input  logic                       rf_aqed_ll_qe_hp_pri2_we
    ,input  logic[ (  11 ) -1 : 0 ]     rf_aqed_ll_qe_hp_pri2_waddr
    ,input  logic[ (  14 ) -1 : 0 ]     rf_aqed_ll_qe_hp_pri2_wdata
    ,input  logic                       rf_aqed_ll_qe_hp_pri2_rclk
    ,input  logic                       rf_aqed_ll_qe_hp_pri2_rclk_rst_n
    ,input  logic                       rf_aqed_ll_qe_hp_pri2_re
    ,input  logic[ (  11 ) -1 : 0 ]     rf_aqed_ll_qe_hp_pri2_raddr
    ,output logic[ (  14 ) -1 : 0 ]     rf_aqed_ll_qe_hp_pri2_rdata

    ,input  logic                       rf_aqed_ll_qe_hp_pri2_isol_en
    ,input  logic                       rf_aqed_ll_qe_hp_pri2_pwr_enable_b_in
    ,output logic                       rf_aqed_ll_qe_hp_pri2_pwr_enable_b_out

    ,input  logic                       rf_aqed_ll_qe_hp_pri3_wclk
    ,input  logic                       rf_aqed_ll_qe_hp_pri3_wclk_rst_n
    ,input  logic                       rf_aqed_ll_qe_hp_pri3_we
    ,input  logic[ (  11 ) -1 : 0 ]     rf_aqed_ll_qe_hp_pri3_waddr
    ,input  logic[ (  14 ) -1 : 0 ]     rf_aqed_ll_qe_hp_pri3_wdata
    ,input  logic                       rf_aqed_ll_qe_hp_pri3_rclk
    ,input  logic                       rf_aqed_ll_qe_hp_pri3_rclk_rst_n
    ,input  logic                       rf_aqed_ll_qe_hp_pri3_re
    ,input  logic[ (  11 ) -1 : 0 ]     rf_aqed_ll_qe_hp_pri3_raddr
    ,output logic[ (  14 ) -1 : 0 ]     rf_aqed_ll_qe_hp_pri3_rdata

    ,input  logic                       rf_aqed_ll_qe_hp_pri3_isol_en
    ,input  logic                       rf_aqed_ll_qe_hp_pri3_pwr_enable_b_in
    ,output logic                       rf_aqed_ll_qe_hp_pri3_pwr_enable_b_out

    ,input  logic                       rf_aqed_ll_qe_tp_pri0_wclk
    ,input  logic                       rf_aqed_ll_qe_tp_pri0_wclk_rst_n
    ,input  logic                       rf_aqed_ll_qe_tp_pri0_we
    ,input  logic[ (  11 ) -1 : 0 ]     rf_aqed_ll_qe_tp_pri0_waddr
    ,input  logic[ (  14 ) -1 : 0 ]     rf_aqed_ll_qe_tp_pri0_wdata
    ,input  logic                       rf_aqed_ll_qe_tp_pri0_rclk
    ,input  logic                       rf_aqed_ll_qe_tp_pri0_rclk_rst_n
    ,input  logic                       rf_aqed_ll_qe_tp_pri0_re
    ,input  logic[ (  11 ) -1 : 0 ]     rf_aqed_ll_qe_tp_pri0_raddr
    ,output logic[ (  14 ) -1 : 0 ]     rf_aqed_ll_qe_tp_pri0_rdata

    ,input  logic                       rf_aqed_ll_qe_tp_pri0_isol_en
    ,input  logic                       rf_aqed_ll_qe_tp_pri0_pwr_enable_b_in
    ,output logic                       rf_aqed_ll_qe_tp_pri0_pwr_enable_b_out

    ,input  logic                       rf_aqed_ll_qe_tp_pri1_wclk
    ,input  logic                       rf_aqed_ll_qe_tp_pri1_wclk_rst_n
    ,input  logic                       rf_aqed_ll_qe_tp_pri1_we
    ,input  logic[ (  11 ) -1 : 0 ]     rf_aqed_ll_qe_tp_pri1_waddr
    ,input  logic[ (  14 ) -1 : 0 ]     rf_aqed_ll_qe_tp_pri1_wdata
    ,input  logic                       rf_aqed_ll_qe_tp_pri1_rclk
    ,input  logic                       rf_aqed_ll_qe_tp_pri1_rclk_rst_n
    ,input  logic                       rf_aqed_ll_qe_tp_pri1_re
    ,input  logic[ (  11 ) -1 : 0 ]     rf_aqed_ll_qe_tp_pri1_raddr
    ,output logic[ (  14 ) -1 : 0 ]     rf_aqed_ll_qe_tp_pri1_rdata

    ,input  logic                       rf_aqed_ll_qe_tp_pri1_isol_en
    ,input  logic                       rf_aqed_ll_qe_tp_pri1_pwr_enable_b_in
    ,output logic                       rf_aqed_ll_qe_tp_pri1_pwr_enable_b_out

    ,input  logic                       rf_aqed_ll_qe_tp_pri2_wclk
    ,input  logic                       rf_aqed_ll_qe_tp_pri2_wclk_rst_n
    ,input  logic                       rf_aqed_ll_qe_tp_pri2_we
    ,input  logic[ (  11 ) -1 : 0 ]     rf_aqed_ll_qe_tp_pri2_waddr
    ,input  logic[ (  14 ) -1 : 0 ]     rf_aqed_ll_qe_tp_pri2_wdata
    ,input  logic                       rf_aqed_ll_qe_tp_pri2_rclk
    ,input  logic                       rf_aqed_ll_qe_tp_pri2_rclk_rst_n
    ,input  logic                       rf_aqed_ll_qe_tp_pri2_re
    ,input  logic[ (  11 ) -1 : 0 ]     rf_aqed_ll_qe_tp_pri2_raddr
    ,output logic[ (  14 ) -1 : 0 ]     rf_aqed_ll_qe_tp_pri2_rdata

    ,input  logic                       rf_aqed_ll_qe_tp_pri2_isol_en
    ,input  logic                       rf_aqed_ll_qe_tp_pri2_pwr_enable_b_in
    ,output logic                       rf_aqed_ll_qe_tp_pri2_pwr_enable_b_out

    ,input  logic                       rf_aqed_ll_qe_tp_pri3_wclk
    ,input  logic                       rf_aqed_ll_qe_tp_pri3_wclk_rst_n
    ,input  logic                       rf_aqed_ll_qe_tp_pri3_we
    ,input  logic[ (  11 ) -1 : 0 ]     rf_aqed_ll_qe_tp_pri3_waddr
    ,input  logic[ (  14 ) -1 : 0 ]     rf_aqed_ll_qe_tp_pri3_wdata
    ,input  logic                       rf_aqed_ll_qe_tp_pri3_rclk
    ,input  logic                       rf_aqed_ll_qe_tp_pri3_rclk_rst_n
    ,input  logic                       rf_aqed_ll_qe_tp_pri3_re
    ,input  logic[ (  11 ) -1 : 0 ]     rf_aqed_ll_qe_tp_pri3_raddr
    ,output logic[ (  14 ) -1 : 0 ]     rf_aqed_ll_qe_tp_pri3_rdata

    ,input  logic                       rf_aqed_ll_qe_tp_pri3_isol_en
    ,input  logic                       rf_aqed_ll_qe_tp_pri3_pwr_enable_b_in
    ,output logic                       rf_aqed_ll_qe_tp_pri3_pwr_enable_b_out

    ,input  logic                       rf_aqed_lsp_deq_fifo_mem_wclk
    ,input  logic                       rf_aqed_lsp_deq_fifo_mem_wclk_rst_n
    ,input  logic                       rf_aqed_lsp_deq_fifo_mem_we
    ,input  logic[ (   5 ) -1 : 0 ]     rf_aqed_lsp_deq_fifo_mem_waddr
    ,input  logic[ (   9 ) -1 : 0 ]     rf_aqed_lsp_deq_fifo_mem_wdata
    ,input  logic                       rf_aqed_lsp_deq_fifo_mem_rclk
    ,input  logic                       rf_aqed_lsp_deq_fifo_mem_rclk_rst_n
    ,input  logic                       rf_aqed_lsp_deq_fifo_mem_re
    ,input  logic[ (   5 ) -1 : 0 ]     rf_aqed_lsp_deq_fifo_mem_raddr
    ,output logic[ (   9 ) -1 : 0 ]     rf_aqed_lsp_deq_fifo_mem_rdata

    ,input  logic                       rf_aqed_lsp_deq_fifo_mem_isol_en
    ,input  logic                       rf_aqed_lsp_deq_fifo_mem_pwr_enable_b_in
    ,output logic                       rf_aqed_lsp_deq_fifo_mem_pwr_enable_b_out

    ,input  logic                       rf_aqed_qid2cqidix_wclk
    ,input  logic                       rf_aqed_qid2cqidix_wclk_rst_n
    ,input  logic                       rf_aqed_qid2cqidix_we
    ,input  logic[ (   5 ) -1 : 0 ]     rf_aqed_qid2cqidix_waddr
    ,input  logic[ ( 528 ) -1 : 0 ]     rf_aqed_qid2cqidix_wdata
    ,input  logic                       rf_aqed_qid2cqidix_rclk
    ,input  logic                       rf_aqed_qid2cqidix_rclk_rst_n
    ,input  logic                       rf_aqed_qid2cqidix_re
    ,input  logic[ (   5 ) -1 : 0 ]     rf_aqed_qid2cqidix_raddr
    ,output logic[ ( 528 ) -1 : 0 ]     rf_aqed_qid2cqidix_rdata

    ,input  logic                       rf_aqed_qid2cqidix_isol_en
    ,input  logic                       rf_aqed_qid2cqidix_pwr_enable_b_in
    ,output logic                       rf_aqed_qid2cqidix_pwr_enable_b_out

    ,input  logic                       rf_aqed_qid_cnt_wclk
    ,input  logic                       rf_aqed_qid_cnt_wclk_rst_n
    ,input  logic                       rf_aqed_qid_cnt_we
    ,input  logic[ (   5 ) -1 : 0 ]     rf_aqed_qid_cnt_waddr
    ,input  logic[ (  15 ) -1 : 0 ]     rf_aqed_qid_cnt_wdata
    ,input  logic                       rf_aqed_qid_cnt_rclk
    ,input  logic                       rf_aqed_qid_cnt_rclk_rst_n
    ,input  logic                       rf_aqed_qid_cnt_re
    ,input  logic[ (   5 ) -1 : 0 ]     rf_aqed_qid_cnt_raddr
    ,output logic[ (  15 ) -1 : 0 ]     rf_aqed_qid_cnt_rdata

    ,input  logic                       rf_aqed_qid_cnt_isol_en
    ,input  logic                       rf_aqed_qid_cnt_pwr_enable_b_in
    ,output logic                       rf_aqed_qid_cnt_pwr_enable_b_out

    ,input  logic                       rf_aqed_qid_fid_limit_wclk
    ,input  logic                       rf_aqed_qid_fid_limit_wclk_rst_n
    ,input  logic                       rf_aqed_qid_fid_limit_we
    ,input  logic[ (   5 ) -1 : 0 ]     rf_aqed_qid_fid_limit_waddr
    ,input  logic[ (  14 ) -1 : 0 ]     rf_aqed_qid_fid_limit_wdata
    ,input  logic                       rf_aqed_qid_fid_limit_rclk
    ,input  logic                       rf_aqed_qid_fid_limit_rclk_rst_n
    ,input  logic                       rf_aqed_qid_fid_limit_re
    ,input  logic[ (   5 ) -1 : 0 ]     rf_aqed_qid_fid_limit_raddr
    ,output logic[ (  14 ) -1 : 0 ]     rf_aqed_qid_fid_limit_rdata

    ,input  logic                       rf_aqed_qid_fid_limit_isol_en
    ,input  logic                       rf_aqed_qid_fid_limit_pwr_enable_b_in
    ,output logic                       rf_aqed_qid_fid_limit_pwr_enable_b_out

    ,input  logic                       rf_atm_cmp_fifo_mem_wclk
    ,input  logic                       rf_atm_cmp_fifo_mem_wclk_rst_n
    ,input  logic                       rf_atm_cmp_fifo_mem_we
    ,input  logic[ (   3 ) -1 : 0 ]     rf_atm_cmp_fifo_mem_waddr
    ,input  logic[ (  55 ) -1 : 0 ]     rf_atm_cmp_fifo_mem_wdata
    ,input  logic                       rf_atm_cmp_fifo_mem_rclk
    ,input  logic                       rf_atm_cmp_fifo_mem_rclk_rst_n
    ,input  logic                       rf_atm_cmp_fifo_mem_re
    ,input  logic[ (   3 ) -1 : 0 ]     rf_atm_cmp_fifo_mem_raddr
    ,output logic[ (  55 ) -1 : 0 ]     rf_atm_cmp_fifo_mem_rdata

    ,input  logic                       rf_atm_cmp_fifo_mem_isol_en
    ,input  logic                       rf_atm_cmp_fifo_mem_pwr_enable_b_in
    ,output logic                       rf_atm_cmp_fifo_mem_pwr_enable_b_out

    ,input  logic                       rf_atm_fifo_ap_aqed_wclk
    ,input  logic                       rf_atm_fifo_ap_aqed_wclk_rst_n
    ,input  logic                       rf_atm_fifo_ap_aqed_we
    ,input  logic[ (   4 ) -1 : 0 ]     rf_atm_fifo_ap_aqed_waddr
    ,input  logic[ (  45 ) -1 : 0 ]     rf_atm_fifo_ap_aqed_wdata
    ,input  logic                       rf_atm_fifo_ap_aqed_rclk
    ,input  logic                       rf_atm_fifo_ap_aqed_rclk_rst_n
    ,input  logic                       rf_atm_fifo_ap_aqed_re
    ,input  logic[ (   4 ) -1 : 0 ]     rf_atm_fifo_ap_aqed_raddr
    ,output logic[ (  45 ) -1 : 0 ]     rf_atm_fifo_ap_aqed_rdata

    ,input  logic                       rf_atm_fifo_ap_aqed_isol_en
    ,input  logic                       rf_atm_fifo_ap_aqed_pwr_enable_b_in
    ,output logic                       rf_atm_fifo_ap_aqed_pwr_enable_b_out

    ,input  logic                       rf_atm_fifo_aqed_ap_enq_wclk
    ,input  logic                       rf_atm_fifo_aqed_ap_enq_wclk_rst_n
    ,input  logic                       rf_atm_fifo_aqed_ap_enq_we
    ,input  logic[ (   5 ) -1 : 0 ]     rf_atm_fifo_aqed_ap_enq_waddr
    ,input  logic[ (  24 ) -1 : 0 ]     rf_atm_fifo_aqed_ap_enq_wdata
    ,input  logic                       rf_atm_fifo_aqed_ap_enq_rclk
    ,input  logic                       rf_atm_fifo_aqed_ap_enq_rclk_rst_n
    ,input  logic                       rf_atm_fifo_aqed_ap_enq_re
    ,input  logic[ (   5 ) -1 : 0 ]     rf_atm_fifo_aqed_ap_enq_raddr
    ,output logic[ (  24 ) -1 : 0 ]     rf_atm_fifo_aqed_ap_enq_rdata

    ,input  logic                       rf_atm_fifo_aqed_ap_enq_isol_en
    ,input  logic                       rf_atm_fifo_aqed_ap_enq_pwr_enable_b_in
    ,output logic                       rf_atm_fifo_aqed_ap_enq_pwr_enable_b_out

    ,input  logic                       rf_cfg_atm_qid_dpth_thrsh_mem_wclk
    ,input  logic                       rf_cfg_atm_qid_dpth_thrsh_mem_wclk_rst_n
    ,input  logic                       rf_cfg_atm_qid_dpth_thrsh_mem_we
    ,input  logic[ (   5 ) -1 : 0 ]     rf_cfg_atm_qid_dpth_thrsh_mem_waddr
    ,input  logic[ (  16 ) -1 : 0 ]     rf_cfg_atm_qid_dpth_thrsh_mem_wdata
    ,input  logic                       rf_cfg_atm_qid_dpth_thrsh_mem_rclk
    ,input  logic                       rf_cfg_atm_qid_dpth_thrsh_mem_rclk_rst_n
    ,input  logic                       rf_cfg_atm_qid_dpth_thrsh_mem_re
    ,input  logic[ (   5 ) -1 : 0 ]     rf_cfg_atm_qid_dpth_thrsh_mem_raddr
    ,output logic[ (  16 ) -1 : 0 ]     rf_cfg_atm_qid_dpth_thrsh_mem_rdata

    ,input  logic                       rf_cfg_atm_qid_dpth_thrsh_mem_isol_en
    ,input  logic                       rf_cfg_atm_qid_dpth_thrsh_mem_pwr_enable_b_in
    ,output logic                       rf_cfg_atm_qid_dpth_thrsh_mem_pwr_enable_b_out

    ,input  logic                       rf_cfg_cq2priov_mem_wclk
    ,input  logic                       rf_cfg_cq2priov_mem_wclk_rst_n
    ,input  logic                       rf_cfg_cq2priov_mem_we
    ,input  logic[ (   5 ) -1 : 0 ]     rf_cfg_cq2priov_mem_waddr
    ,input  logic[ (  33 ) -1 : 0 ]     rf_cfg_cq2priov_mem_wdata
    ,input  logic                       rf_cfg_cq2priov_mem_rclk
    ,input  logic                       rf_cfg_cq2priov_mem_rclk_rst_n
    ,input  logic                       rf_cfg_cq2priov_mem_re
    ,input  logic[ (   5 ) -1 : 0 ]     rf_cfg_cq2priov_mem_raddr
    ,output logic[ (  33 ) -1 : 0 ]     rf_cfg_cq2priov_mem_rdata

    ,input  logic                       rf_cfg_cq2priov_mem_isol_en
    ,input  logic                       rf_cfg_cq2priov_mem_pwr_enable_b_in
    ,output logic                       rf_cfg_cq2priov_mem_pwr_enable_b_out

    ,input  logic                       rf_cfg_cq2priov_odd_mem_wclk
    ,input  logic                       rf_cfg_cq2priov_odd_mem_wclk_rst_n
    ,input  logic                       rf_cfg_cq2priov_odd_mem_we
    ,input  logic[ (   5 ) -1 : 0 ]     rf_cfg_cq2priov_odd_mem_waddr
    ,input  logic[ (  33 ) -1 : 0 ]     rf_cfg_cq2priov_odd_mem_wdata
    ,input  logic                       rf_cfg_cq2priov_odd_mem_rclk
    ,input  logic                       rf_cfg_cq2priov_odd_mem_rclk_rst_n
    ,input  logic                       rf_cfg_cq2priov_odd_mem_re
    ,input  logic[ (   5 ) -1 : 0 ]     rf_cfg_cq2priov_odd_mem_raddr
    ,output logic[ (  33 ) -1 : 0 ]     rf_cfg_cq2priov_odd_mem_rdata

    ,input  logic                       rf_cfg_cq2priov_odd_mem_isol_en
    ,input  logic                       rf_cfg_cq2priov_odd_mem_pwr_enable_b_in
    ,output logic                       rf_cfg_cq2priov_odd_mem_pwr_enable_b_out

    ,input  logic                       rf_cfg_cq2qid_0_mem_wclk
    ,input  logic                       rf_cfg_cq2qid_0_mem_wclk_rst_n
    ,input  logic                       rf_cfg_cq2qid_0_mem_we
    ,input  logic[ (   5 ) -1 : 0 ]     rf_cfg_cq2qid_0_mem_waddr
    ,input  logic[ (  29 ) -1 : 0 ]     rf_cfg_cq2qid_0_mem_wdata
    ,input  logic                       rf_cfg_cq2qid_0_mem_rclk
    ,input  logic                       rf_cfg_cq2qid_0_mem_rclk_rst_n
    ,input  logic                       rf_cfg_cq2qid_0_mem_re
    ,input  logic[ (   5 ) -1 : 0 ]     rf_cfg_cq2qid_0_mem_raddr
    ,output logic[ (  29 ) -1 : 0 ]     rf_cfg_cq2qid_0_mem_rdata

    ,input  logic                       rf_cfg_cq2qid_0_mem_isol_en
    ,input  logic                       rf_cfg_cq2qid_0_mem_pwr_enable_b_in
    ,output logic                       rf_cfg_cq2qid_0_mem_pwr_enable_b_out

    ,input  logic                       rf_cfg_cq2qid_0_odd_mem_wclk
    ,input  logic                       rf_cfg_cq2qid_0_odd_mem_wclk_rst_n
    ,input  logic                       rf_cfg_cq2qid_0_odd_mem_we
    ,input  logic[ (   5 ) -1 : 0 ]     rf_cfg_cq2qid_0_odd_mem_waddr
    ,input  logic[ (  29 ) -1 : 0 ]     rf_cfg_cq2qid_0_odd_mem_wdata
    ,input  logic                       rf_cfg_cq2qid_0_odd_mem_rclk
    ,input  logic                       rf_cfg_cq2qid_0_odd_mem_rclk_rst_n
    ,input  logic                       rf_cfg_cq2qid_0_odd_mem_re
    ,input  logic[ (   5 ) -1 : 0 ]     rf_cfg_cq2qid_0_odd_mem_raddr
    ,output logic[ (  29 ) -1 : 0 ]     rf_cfg_cq2qid_0_odd_mem_rdata

    ,input  logic                       rf_cfg_cq2qid_0_odd_mem_isol_en
    ,input  logic                       rf_cfg_cq2qid_0_odd_mem_pwr_enable_b_in
    ,output logic                       rf_cfg_cq2qid_0_odd_mem_pwr_enable_b_out

    ,input  logic                       rf_cfg_cq2qid_1_mem_wclk
    ,input  logic                       rf_cfg_cq2qid_1_mem_wclk_rst_n
    ,input  logic                       rf_cfg_cq2qid_1_mem_we
    ,input  logic[ (   5 ) -1 : 0 ]     rf_cfg_cq2qid_1_mem_waddr
    ,input  logic[ (  29 ) -1 : 0 ]     rf_cfg_cq2qid_1_mem_wdata
    ,input  logic                       rf_cfg_cq2qid_1_mem_rclk
    ,input  logic                       rf_cfg_cq2qid_1_mem_rclk_rst_n
    ,input  logic                       rf_cfg_cq2qid_1_mem_re
    ,input  logic[ (   5 ) -1 : 0 ]     rf_cfg_cq2qid_1_mem_raddr
    ,output logic[ (  29 ) -1 : 0 ]     rf_cfg_cq2qid_1_mem_rdata

    ,input  logic                       rf_cfg_cq2qid_1_mem_isol_en
    ,input  logic                       rf_cfg_cq2qid_1_mem_pwr_enable_b_in
    ,output logic                       rf_cfg_cq2qid_1_mem_pwr_enable_b_out

    ,input  logic                       rf_cfg_cq2qid_1_odd_mem_wclk
    ,input  logic                       rf_cfg_cq2qid_1_odd_mem_wclk_rst_n
    ,input  logic                       rf_cfg_cq2qid_1_odd_mem_we
    ,input  logic[ (   5 ) -1 : 0 ]     rf_cfg_cq2qid_1_odd_mem_waddr
    ,input  logic[ (  29 ) -1 : 0 ]     rf_cfg_cq2qid_1_odd_mem_wdata
    ,input  logic                       rf_cfg_cq2qid_1_odd_mem_rclk
    ,input  logic                       rf_cfg_cq2qid_1_odd_mem_rclk_rst_n
    ,input  logic                       rf_cfg_cq2qid_1_odd_mem_re
    ,input  logic[ (   5 ) -1 : 0 ]     rf_cfg_cq2qid_1_odd_mem_raddr
    ,output logic[ (  29 ) -1 : 0 ]     rf_cfg_cq2qid_1_odd_mem_rdata

    ,input  logic                       rf_cfg_cq2qid_1_odd_mem_isol_en
    ,input  logic                       rf_cfg_cq2qid_1_odd_mem_pwr_enable_b_in
    ,output logic                       rf_cfg_cq2qid_1_odd_mem_pwr_enable_b_out

    ,input  logic                       rf_cfg_cq_ldb_inflight_limit_mem_wclk
    ,input  logic                       rf_cfg_cq_ldb_inflight_limit_mem_wclk_rst_n
    ,input  logic                       rf_cfg_cq_ldb_inflight_limit_mem_we
    ,input  logic[ (   6 ) -1 : 0 ]     rf_cfg_cq_ldb_inflight_limit_mem_waddr
    ,input  logic[ (  14 ) -1 : 0 ]     rf_cfg_cq_ldb_inflight_limit_mem_wdata
    ,input  logic                       rf_cfg_cq_ldb_inflight_limit_mem_rclk
    ,input  logic                       rf_cfg_cq_ldb_inflight_limit_mem_rclk_rst_n
    ,input  logic                       rf_cfg_cq_ldb_inflight_limit_mem_re
    ,input  logic[ (   6 ) -1 : 0 ]     rf_cfg_cq_ldb_inflight_limit_mem_raddr
    ,output logic[ (  14 ) -1 : 0 ]     rf_cfg_cq_ldb_inflight_limit_mem_rdata

    ,input  logic                       rf_cfg_cq_ldb_inflight_limit_mem_isol_en
    ,input  logic                       rf_cfg_cq_ldb_inflight_limit_mem_pwr_enable_b_in
    ,output logic                       rf_cfg_cq_ldb_inflight_limit_mem_pwr_enable_b_out

    ,input  logic                       rf_cfg_cq_ldb_inflight_threshold_mem_wclk
    ,input  logic                       rf_cfg_cq_ldb_inflight_threshold_mem_wclk_rst_n
    ,input  logic                       rf_cfg_cq_ldb_inflight_threshold_mem_we
    ,input  logic[ (   6 ) -1 : 0 ]     rf_cfg_cq_ldb_inflight_threshold_mem_waddr
    ,input  logic[ (  14 ) -1 : 0 ]     rf_cfg_cq_ldb_inflight_threshold_mem_wdata
    ,input  logic                       rf_cfg_cq_ldb_inflight_threshold_mem_rclk
    ,input  logic                       rf_cfg_cq_ldb_inflight_threshold_mem_rclk_rst_n
    ,input  logic                       rf_cfg_cq_ldb_inflight_threshold_mem_re
    ,input  logic[ (   6 ) -1 : 0 ]     rf_cfg_cq_ldb_inflight_threshold_mem_raddr
    ,output logic[ (  14 ) -1 : 0 ]     rf_cfg_cq_ldb_inflight_threshold_mem_rdata

    ,input  logic                       rf_cfg_cq_ldb_inflight_threshold_mem_isol_en
    ,input  logic                       rf_cfg_cq_ldb_inflight_threshold_mem_pwr_enable_b_in
    ,output logic                       rf_cfg_cq_ldb_inflight_threshold_mem_pwr_enable_b_out

    ,input  logic                       rf_cfg_cq_ldb_token_depth_select_mem_wclk
    ,input  logic                       rf_cfg_cq_ldb_token_depth_select_mem_wclk_rst_n
    ,input  logic                       rf_cfg_cq_ldb_token_depth_select_mem_we
    ,input  logic[ (   6 ) -1 : 0 ]     rf_cfg_cq_ldb_token_depth_select_mem_waddr
    ,input  logic[ (   5 ) -1 : 0 ]     rf_cfg_cq_ldb_token_depth_select_mem_wdata
    ,input  logic                       rf_cfg_cq_ldb_token_depth_select_mem_rclk
    ,input  logic                       rf_cfg_cq_ldb_token_depth_select_mem_rclk_rst_n
    ,input  logic                       rf_cfg_cq_ldb_token_depth_select_mem_re
    ,input  logic[ (   6 ) -1 : 0 ]     rf_cfg_cq_ldb_token_depth_select_mem_raddr
    ,output logic[ (   5 ) -1 : 0 ]     rf_cfg_cq_ldb_token_depth_select_mem_rdata

    ,input  logic                       rf_cfg_cq_ldb_token_depth_select_mem_isol_en
    ,input  logic                       rf_cfg_cq_ldb_token_depth_select_mem_pwr_enable_b_in
    ,output logic                       rf_cfg_cq_ldb_token_depth_select_mem_pwr_enable_b_out

    ,input  logic                       rf_cfg_cq_ldb_wu_limit_mem_wclk
    ,input  logic                       rf_cfg_cq_ldb_wu_limit_mem_wclk_rst_n
    ,input  logic                       rf_cfg_cq_ldb_wu_limit_mem_we
    ,input  logic[ (   6 ) -1 : 0 ]     rf_cfg_cq_ldb_wu_limit_mem_waddr
    ,input  logic[ (  17 ) -1 : 0 ]     rf_cfg_cq_ldb_wu_limit_mem_wdata
    ,input  logic                       rf_cfg_cq_ldb_wu_limit_mem_rclk
    ,input  logic                       rf_cfg_cq_ldb_wu_limit_mem_rclk_rst_n
    ,input  logic                       rf_cfg_cq_ldb_wu_limit_mem_re
    ,input  logic[ (   6 ) -1 : 0 ]     rf_cfg_cq_ldb_wu_limit_mem_raddr
    ,output logic[ (  17 ) -1 : 0 ]     rf_cfg_cq_ldb_wu_limit_mem_rdata

    ,input  logic                       rf_cfg_cq_ldb_wu_limit_mem_isol_en
    ,input  logic                       rf_cfg_cq_ldb_wu_limit_mem_pwr_enable_b_in
    ,output logic                       rf_cfg_cq_ldb_wu_limit_mem_pwr_enable_b_out

    ,input  logic                       rf_cfg_dir_qid_dpth_thrsh_mem_wclk
    ,input  logic                       rf_cfg_dir_qid_dpth_thrsh_mem_wclk_rst_n
    ,input  logic                       rf_cfg_dir_qid_dpth_thrsh_mem_we
    ,input  logic[ (   6 ) -1 : 0 ]     rf_cfg_dir_qid_dpth_thrsh_mem_waddr
    ,input  logic[ (  16 ) -1 : 0 ]     rf_cfg_dir_qid_dpth_thrsh_mem_wdata
    ,input  logic                       rf_cfg_dir_qid_dpth_thrsh_mem_rclk
    ,input  logic                       rf_cfg_dir_qid_dpth_thrsh_mem_rclk_rst_n
    ,input  logic                       rf_cfg_dir_qid_dpth_thrsh_mem_re
    ,input  logic[ (   6 ) -1 : 0 ]     rf_cfg_dir_qid_dpth_thrsh_mem_raddr
    ,output logic[ (  16 ) -1 : 0 ]     rf_cfg_dir_qid_dpth_thrsh_mem_rdata

    ,input  logic                       rf_cfg_dir_qid_dpth_thrsh_mem_isol_en
    ,input  logic                       rf_cfg_dir_qid_dpth_thrsh_mem_pwr_enable_b_in
    ,output logic                       rf_cfg_dir_qid_dpth_thrsh_mem_pwr_enable_b_out

    ,input  logic                       rf_cfg_nalb_qid_dpth_thrsh_mem_wclk
    ,input  logic                       rf_cfg_nalb_qid_dpth_thrsh_mem_wclk_rst_n
    ,input  logic                       rf_cfg_nalb_qid_dpth_thrsh_mem_we
    ,input  logic[ (   5 ) -1 : 0 ]     rf_cfg_nalb_qid_dpth_thrsh_mem_waddr
    ,input  logic[ (  16 ) -1 : 0 ]     rf_cfg_nalb_qid_dpth_thrsh_mem_wdata
    ,input  logic                       rf_cfg_nalb_qid_dpth_thrsh_mem_rclk
    ,input  logic                       rf_cfg_nalb_qid_dpth_thrsh_mem_rclk_rst_n
    ,input  logic                       rf_cfg_nalb_qid_dpth_thrsh_mem_re
    ,input  logic[ (   5 ) -1 : 0 ]     rf_cfg_nalb_qid_dpth_thrsh_mem_raddr
    ,output logic[ (  16 ) -1 : 0 ]     rf_cfg_nalb_qid_dpth_thrsh_mem_rdata

    ,input  logic                       rf_cfg_nalb_qid_dpth_thrsh_mem_isol_en
    ,input  logic                       rf_cfg_nalb_qid_dpth_thrsh_mem_pwr_enable_b_in
    ,output logic                       rf_cfg_nalb_qid_dpth_thrsh_mem_pwr_enable_b_out

    ,input  logic                       rf_cfg_qid_aqed_active_limit_mem_wclk
    ,input  logic                       rf_cfg_qid_aqed_active_limit_mem_wclk_rst_n
    ,input  logic                       rf_cfg_qid_aqed_active_limit_mem_we
    ,input  logic[ (   5 ) -1 : 0 ]     rf_cfg_qid_aqed_active_limit_mem_waddr
    ,input  logic[ (  13 ) -1 : 0 ]     rf_cfg_qid_aqed_active_limit_mem_wdata
    ,input  logic                       rf_cfg_qid_aqed_active_limit_mem_rclk
    ,input  logic                       rf_cfg_qid_aqed_active_limit_mem_rclk_rst_n
    ,input  logic                       rf_cfg_qid_aqed_active_limit_mem_re
    ,input  logic[ (   5 ) -1 : 0 ]     rf_cfg_qid_aqed_active_limit_mem_raddr
    ,output logic[ (  13 ) -1 : 0 ]     rf_cfg_qid_aqed_active_limit_mem_rdata

    ,input  logic                       rf_cfg_qid_aqed_active_limit_mem_isol_en
    ,input  logic                       rf_cfg_qid_aqed_active_limit_mem_pwr_enable_b_in
    ,output logic                       rf_cfg_qid_aqed_active_limit_mem_pwr_enable_b_out

    ,input  logic                       rf_cfg_qid_ldb_inflight_limit_mem_wclk
    ,input  logic                       rf_cfg_qid_ldb_inflight_limit_mem_wclk_rst_n
    ,input  logic                       rf_cfg_qid_ldb_inflight_limit_mem_we
    ,input  logic[ (   5 ) -1 : 0 ]     rf_cfg_qid_ldb_inflight_limit_mem_waddr
    ,input  logic[ (  13 ) -1 : 0 ]     rf_cfg_qid_ldb_inflight_limit_mem_wdata
    ,input  logic                       rf_cfg_qid_ldb_inflight_limit_mem_rclk
    ,input  logic                       rf_cfg_qid_ldb_inflight_limit_mem_rclk_rst_n
    ,input  logic                       rf_cfg_qid_ldb_inflight_limit_mem_re
    ,input  logic[ (   5 ) -1 : 0 ]     rf_cfg_qid_ldb_inflight_limit_mem_raddr
    ,output logic[ (  13 ) -1 : 0 ]     rf_cfg_qid_ldb_inflight_limit_mem_rdata

    ,input  logic                       rf_cfg_qid_ldb_inflight_limit_mem_isol_en
    ,input  logic                       rf_cfg_qid_ldb_inflight_limit_mem_pwr_enable_b_in
    ,output logic                       rf_cfg_qid_ldb_inflight_limit_mem_pwr_enable_b_out

    ,input  logic                       rf_cfg_qid_ldb_qid2cqidix2_mem_wclk
    ,input  logic                       rf_cfg_qid_ldb_qid2cqidix2_mem_wclk_rst_n
    ,input  logic                       rf_cfg_qid_ldb_qid2cqidix2_mem_we
    ,input  logic[ (   5 ) -1 : 0 ]     rf_cfg_qid_ldb_qid2cqidix2_mem_waddr
    ,input  logic[ ( 528 ) -1 : 0 ]     rf_cfg_qid_ldb_qid2cqidix2_mem_wdata
    ,input  logic                       rf_cfg_qid_ldb_qid2cqidix2_mem_rclk
    ,input  logic                       rf_cfg_qid_ldb_qid2cqidix2_mem_rclk_rst_n
    ,input  logic                       rf_cfg_qid_ldb_qid2cqidix2_mem_re
    ,input  logic[ (   5 ) -1 : 0 ]     rf_cfg_qid_ldb_qid2cqidix2_mem_raddr
    ,output logic[ ( 528 ) -1 : 0 ]     rf_cfg_qid_ldb_qid2cqidix2_mem_rdata

    ,input  logic                       rf_cfg_qid_ldb_qid2cqidix2_mem_isol_en
    ,input  logic                       rf_cfg_qid_ldb_qid2cqidix2_mem_pwr_enable_b_in
    ,output logic                       rf_cfg_qid_ldb_qid2cqidix2_mem_pwr_enable_b_out

    ,input  logic                       rf_cfg_qid_ldb_qid2cqidix_mem_wclk
    ,input  logic                       rf_cfg_qid_ldb_qid2cqidix_mem_wclk_rst_n
    ,input  logic                       rf_cfg_qid_ldb_qid2cqidix_mem_we
    ,input  logic[ (   5 ) -1 : 0 ]     rf_cfg_qid_ldb_qid2cqidix_mem_waddr
    ,input  logic[ ( 528 ) -1 : 0 ]     rf_cfg_qid_ldb_qid2cqidix_mem_wdata
    ,input  logic                       rf_cfg_qid_ldb_qid2cqidix_mem_rclk
    ,input  logic                       rf_cfg_qid_ldb_qid2cqidix_mem_rclk_rst_n
    ,input  logic                       rf_cfg_qid_ldb_qid2cqidix_mem_re
    ,input  logic[ (   5 ) -1 : 0 ]     rf_cfg_qid_ldb_qid2cqidix_mem_raddr
    ,output logic[ ( 528 ) -1 : 0 ]     rf_cfg_qid_ldb_qid2cqidix_mem_rdata

    ,input  logic                       rf_cfg_qid_ldb_qid2cqidix_mem_isol_en
    ,input  logic                       rf_cfg_qid_ldb_qid2cqidix_mem_pwr_enable_b_in
    ,output logic                       rf_cfg_qid_ldb_qid2cqidix_mem_pwr_enable_b_out

    ,input  logic                       rf_chp_lsp_cmp_rx_sync_fifo_mem_wclk
    ,input  logic                       rf_chp_lsp_cmp_rx_sync_fifo_mem_wclk_rst_n
    ,input  logic                       rf_chp_lsp_cmp_rx_sync_fifo_mem_we
    ,input  logic[ (   2 ) -1 : 0 ]     rf_chp_lsp_cmp_rx_sync_fifo_mem_waddr
    ,input  logic[ (  73 ) -1 : 0 ]     rf_chp_lsp_cmp_rx_sync_fifo_mem_wdata
    ,input  logic                       rf_chp_lsp_cmp_rx_sync_fifo_mem_rclk
    ,input  logic                       rf_chp_lsp_cmp_rx_sync_fifo_mem_rclk_rst_n
    ,input  logic                       rf_chp_lsp_cmp_rx_sync_fifo_mem_re
    ,input  logic[ (   2 ) -1 : 0 ]     rf_chp_lsp_cmp_rx_sync_fifo_mem_raddr
    ,output logic[ (  73 ) -1 : 0 ]     rf_chp_lsp_cmp_rx_sync_fifo_mem_rdata

    ,input  logic                       rf_chp_lsp_cmp_rx_sync_fifo_mem_isol_en
    ,input  logic                       rf_chp_lsp_cmp_rx_sync_fifo_mem_pwr_enable_b_in
    ,output logic                       rf_chp_lsp_cmp_rx_sync_fifo_mem_pwr_enable_b_out

    ,input  logic                       rf_chp_lsp_token_rx_sync_fifo_mem_wclk
    ,input  logic                       rf_chp_lsp_token_rx_sync_fifo_mem_wclk_rst_n
    ,input  logic                       rf_chp_lsp_token_rx_sync_fifo_mem_we
    ,input  logic[ (   2 ) -1 : 0 ]     rf_chp_lsp_token_rx_sync_fifo_mem_waddr
    ,input  logic[ (  25 ) -1 : 0 ]     rf_chp_lsp_token_rx_sync_fifo_mem_wdata
    ,input  logic                       rf_chp_lsp_token_rx_sync_fifo_mem_rclk
    ,input  logic                       rf_chp_lsp_token_rx_sync_fifo_mem_rclk_rst_n
    ,input  logic                       rf_chp_lsp_token_rx_sync_fifo_mem_re
    ,input  logic[ (   2 ) -1 : 0 ]     rf_chp_lsp_token_rx_sync_fifo_mem_raddr
    ,output logic[ (  25 ) -1 : 0 ]     rf_chp_lsp_token_rx_sync_fifo_mem_rdata

    ,input  logic                       rf_chp_lsp_token_rx_sync_fifo_mem_isol_en
    ,input  logic                       rf_chp_lsp_token_rx_sync_fifo_mem_pwr_enable_b_in
    ,output logic                       rf_chp_lsp_token_rx_sync_fifo_mem_pwr_enable_b_out

    ,input  logic                       rf_cq_atm_pri_arbindex_mem_wclk
    ,input  logic                       rf_cq_atm_pri_arbindex_mem_wclk_rst_n
    ,input  logic                       rf_cq_atm_pri_arbindex_mem_we
    ,input  logic[ (   5 ) -1 : 0 ]     rf_cq_atm_pri_arbindex_mem_waddr
    ,input  logic[ (  96 ) -1 : 0 ]     rf_cq_atm_pri_arbindex_mem_wdata
    ,input  logic                       rf_cq_atm_pri_arbindex_mem_rclk
    ,input  logic                       rf_cq_atm_pri_arbindex_mem_rclk_rst_n
    ,input  logic                       rf_cq_atm_pri_arbindex_mem_re
    ,input  logic[ (   5 ) -1 : 0 ]     rf_cq_atm_pri_arbindex_mem_raddr
    ,output logic[ (  96 ) -1 : 0 ]     rf_cq_atm_pri_arbindex_mem_rdata

    ,input  logic                       rf_cq_atm_pri_arbindex_mem_isol_en
    ,input  logic                       rf_cq_atm_pri_arbindex_mem_pwr_enable_b_in
    ,output logic                       rf_cq_atm_pri_arbindex_mem_pwr_enable_b_out

    ,input  logic                       rf_cq_dir_tot_sch_cnt_mem_wclk
    ,input  logic                       rf_cq_dir_tot_sch_cnt_mem_wclk_rst_n
    ,input  logic                       rf_cq_dir_tot_sch_cnt_mem_we
    ,input  logic[ (   6 ) -1 : 0 ]     rf_cq_dir_tot_sch_cnt_mem_waddr
    ,input  logic[ (  66 ) -1 : 0 ]     rf_cq_dir_tot_sch_cnt_mem_wdata
    ,input  logic                       rf_cq_dir_tot_sch_cnt_mem_rclk
    ,input  logic                       rf_cq_dir_tot_sch_cnt_mem_rclk_rst_n
    ,input  logic                       rf_cq_dir_tot_sch_cnt_mem_re
    ,input  logic[ (   6 ) -1 : 0 ]     rf_cq_dir_tot_sch_cnt_mem_raddr
    ,output logic[ (  66 ) -1 : 0 ]     rf_cq_dir_tot_sch_cnt_mem_rdata

    ,input  logic                       rf_cq_dir_tot_sch_cnt_mem_isol_en
    ,input  logic                       rf_cq_dir_tot_sch_cnt_mem_pwr_enable_b_in
    ,output logic                       rf_cq_dir_tot_sch_cnt_mem_pwr_enable_b_out

    ,input  logic                       rf_cq_ldb_inflight_count_mem_wclk
    ,input  logic                       rf_cq_ldb_inflight_count_mem_wclk_rst_n
    ,input  logic                       rf_cq_ldb_inflight_count_mem_we
    ,input  logic[ (   6 ) -1 : 0 ]     rf_cq_ldb_inflight_count_mem_waddr
    ,input  logic[ (  15 ) -1 : 0 ]     rf_cq_ldb_inflight_count_mem_wdata
    ,input  logic                       rf_cq_ldb_inflight_count_mem_rclk
    ,input  logic                       rf_cq_ldb_inflight_count_mem_rclk_rst_n
    ,input  logic                       rf_cq_ldb_inflight_count_mem_re
    ,input  logic[ (   6 ) -1 : 0 ]     rf_cq_ldb_inflight_count_mem_raddr
    ,output logic[ (  15 ) -1 : 0 ]     rf_cq_ldb_inflight_count_mem_rdata

    ,input  logic                       rf_cq_ldb_inflight_count_mem_isol_en
    ,input  logic                       rf_cq_ldb_inflight_count_mem_pwr_enable_b_in
    ,output logic                       rf_cq_ldb_inflight_count_mem_pwr_enable_b_out

    ,input  logic                       rf_cq_ldb_token_count_mem_wclk
    ,input  logic                       rf_cq_ldb_token_count_mem_wclk_rst_n
    ,input  logic                       rf_cq_ldb_token_count_mem_we
    ,input  logic[ (   6 ) -1 : 0 ]     rf_cq_ldb_token_count_mem_waddr
    ,input  logic[ (  13 ) -1 : 0 ]     rf_cq_ldb_token_count_mem_wdata
    ,input  logic                       rf_cq_ldb_token_count_mem_rclk
    ,input  logic                       rf_cq_ldb_token_count_mem_rclk_rst_n
    ,input  logic                       rf_cq_ldb_token_count_mem_re
    ,input  logic[ (   6 ) -1 : 0 ]     rf_cq_ldb_token_count_mem_raddr
    ,output logic[ (  13 ) -1 : 0 ]     rf_cq_ldb_token_count_mem_rdata

    ,input  logic                       rf_cq_ldb_token_count_mem_isol_en
    ,input  logic                       rf_cq_ldb_token_count_mem_pwr_enable_b_in
    ,output logic                       rf_cq_ldb_token_count_mem_pwr_enable_b_out

    ,input  logic                       rf_cq_ldb_tot_sch_cnt_mem_wclk
    ,input  logic                       rf_cq_ldb_tot_sch_cnt_mem_wclk_rst_n
    ,input  logic                       rf_cq_ldb_tot_sch_cnt_mem_we
    ,input  logic[ (   6 ) -1 : 0 ]     rf_cq_ldb_tot_sch_cnt_mem_waddr
    ,input  logic[ (  66 ) -1 : 0 ]     rf_cq_ldb_tot_sch_cnt_mem_wdata
    ,input  logic                       rf_cq_ldb_tot_sch_cnt_mem_rclk
    ,input  logic                       rf_cq_ldb_tot_sch_cnt_mem_rclk_rst_n
    ,input  logic                       rf_cq_ldb_tot_sch_cnt_mem_re
    ,input  logic[ (   6 ) -1 : 0 ]     rf_cq_ldb_tot_sch_cnt_mem_raddr
    ,output logic[ (  66 ) -1 : 0 ]     rf_cq_ldb_tot_sch_cnt_mem_rdata

    ,input  logic                       rf_cq_ldb_tot_sch_cnt_mem_isol_en
    ,input  logic                       rf_cq_ldb_tot_sch_cnt_mem_pwr_enable_b_in
    ,output logic                       rf_cq_ldb_tot_sch_cnt_mem_pwr_enable_b_out

    ,input  logic                       rf_cq_ldb_wu_count_mem_wclk
    ,input  logic                       rf_cq_ldb_wu_count_mem_wclk_rst_n
    ,input  logic                       rf_cq_ldb_wu_count_mem_we
    ,input  logic[ (   6 ) -1 : 0 ]     rf_cq_ldb_wu_count_mem_waddr
    ,input  logic[ (  19 ) -1 : 0 ]     rf_cq_ldb_wu_count_mem_wdata
    ,input  logic                       rf_cq_ldb_wu_count_mem_rclk
    ,input  logic                       rf_cq_ldb_wu_count_mem_rclk_rst_n
    ,input  logic                       rf_cq_ldb_wu_count_mem_re
    ,input  logic[ (   6 ) -1 : 0 ]     rf_cq_ldb_wu_count_mem_raddr
    ,output logic[ (  19 ) -1 : 0 ]     rf_cq_ldb_wu_count_mem_rdata

    ,input  logic                       rf_cq_ldb_wu_count_mem_isol_en
    ,input  logic                       rf_cq_ldb_wu_count_mem_pwr_enable_b_in
    ,output logic                       rf_cq_ldb_wu_count_mem_pwr_enable_b_out

    ,input  logic                       rf_cq_nalb_pri_arbindex_mem_wclk
    ,input  logic                       rf_cq_nalb_pri_arbindex_mem_wclk_rst_n
    ,input  logic                       rf_cq_nalb_pri_arbindex_mem_we
    ,input  logic[ (   5 ) -1 : 0 ]     rf_cq_nalb_pri_arbindex_mem_waddr
    ,input  logic[ (  96 ) -1 : 0 ]     rf_cq_nalb_pri_arbindex_mem_wdata
    ,input  logic                       rf_cq_nalb_pri_arbindex_mem_rclk
    ,input  logic                       rf_cq_nalb_pri_arbindex_mem_rclk_rst_n
    ,input  logic                       rf_cq_nalb_pri_arbindex_mem_re
    ,input  logic[ (   5 ) -1 : 0 ]     rf_cq_nalb_pri_arbindex_mem_raddr
    ,output logic[ (  96 ) -1 : 0 ]     rf_cq_nalb_pri_arbindex_mem_rdata

    ,input  logic                       rf_cq_nalb_pri_arbindex_mem_isol_en
    ,input  logic                       rf_cq_nalb_pri_arbindex_mem_pwr_enable_b_in
    ,output logic                       rf_cq_nalb_pri_arbindex_mem_pwr_enable_b_out

    ,input  logic                       rf_dir_enq_cnt_mem_wclk
    ,input  logic                       rf_dir_enq_cnt_mem_wclk_rst_n
    ,input  logic                       rf_dir_enq_cnt_mem_we
    ,input  logic[ (   6 ) -1 : 0 ]     rf_dir_enq_cnt_mem_waddr
    ,input  logic[ (  17 ) -1 : 0 ]     rf_dir_enq_cnt_mem_wdata
    ,input  logic                       rf_dir_enq_cnt_mem_rclk
    ,input  logic                       rf_dir_enq_cnt_mem_rclk_rst_n
    ,input  logic                       rf_dir_enq_cnt_mem_re
    ,input  logic[ (   6 ) -1 : 0 ]     rf_dir_enq_cnt_mem_raddr
    ,output logic[ (  17 ) -1 : 0 ]     rf_dir_enq_cnt_mem_rdata

    ,input  logic                       rf_dir_enq_cnt_mem_isol_en
    ,input  logic                       rf_dir_enq_cnt_mem_pwr_enable_b_in
    ,output logic                       rf_dir_enq_cnt_mem_pwr_enable_b_out

    ,input  logic                       rf_dir_tok_cnt_mem_wclk
    ,input  logic                       rf_dir_tok_cnt_mem_wclk_rst_n
    ,input  logic                       rf_dir_tok_cnt_mem_we
    ,input  logic[ (   6 ) -1 : 0 ]     rf_dir_tok_cnt_mem_waddr
    ,input  logic[ (  13 ) -1 : 0 ]     rf_dir_tok_cnt_mem_wdata
    ,input  logic                       rf_dir_tok_cnt_mem_rclk
    ,input  logic                       rf_dir_tok_cnt_mem_rclk_rst_n
    ,input  logic                       rf_dir_tok_cnt_mem_re
    ,input  logic[ (   6 ) -1 : 0 ]     rf_dir_tok_cnt_mem_raddr
    ,output logic[ (  13 ) -1 : 0 ]     rf_dir_tok_cnt_mem_rdata

    ,input  logic                       rf_dir_tok_cnt_mem_isol_en
    ,input  logic                       rf_dir_tok_cnt_mem_pwr_enable_b_in
    ,output logic                       rf_dir_tok_cnt_mem_pwr_enable_b_out

    ,input  logic                       rf_dir_tok_lim_mem_wclk
    ,input  logic                       rf_dir_tok_lim_mem_wclk_rst_n
    ,input  logic                       rf_dir_tok_lim_mem_we
    ,input  logic[ (   6 ) -1 : 0 ]     rf_dir_tok_lim_mem_waddr
    ,input  logic[ (   8 ) -1 : 0 ]     rf_dir_tok_lim_mem_wdata
    ,input  logic                       rf_dir_tok_lim_mem_rclk
    ,input  logic                       rf_dir_tok_lim_mem_rclk_rst_n
    ,input  logic                       rf_dir_tok_lim_mem_re
    ,input  logic[ (   6 ) -1 : 0 ]     rf_dir_tok_lim_mem_raddr
    ,output logic[ (   8 ) -1 : 0 ]     rf_dir_tok_lim_mem_rdata

    ,input  logic                       rf_dir_tok_lim_mem_isol_en
    ,input  logic                       rf_dir_tok_lim_mem_pwr_enable_b_in
    ,output logic                       rf_dir_tok_lim_mem_pwr_enable_b_out

    ,input  logic                       rf_dp_lsp_enq_dir_rx_sync_fifo_mem_wclk
    ,input  logic                       rf_dp_lsp_enq_dir_rx_sync_fifo_mem_wclk_rst_n
    ,input  logic                       rf_dp_lsp_enq_dir_rx_sync_fifo_mem_we
    ,input  logic[ (   2 ) -1 : 0 ]     rf_dp_lsp_enq_dir_rx_sync_fifo_mem_waddr
    ,input  logic[ (   8 ) -1 : 0 ]     rf_dp_lsp_enq_dir_rx_sync_fifo_mem_wdata
    ,input  logic                       rf_dp_lsp_enq_dir_rx_sync_fifo_mem_rclk
    ,input  logic                       rf_dp_lsp_enq_dir_rx_sync_fifo_mem_rclk_rst_n
    ,input  logic                       rf_dp_lsp_enq_dir_rx_sync_fifo_mem_re
    ,input  logic[ (   2 ) -1 : 0 ]     rf_dp_lsp_enq_dir_rx_sync_fifo_mem_raddr
    ,output logic[ (   8 ) -1 : 0 ]     rf_dp_lsp_enq_dir_rx_sync_fifo_mem_rdata

    ,input  logic                       rf_dp_lsp_enq_dir_rx_sync_fifo_mem_isol_en
    ,input  logic                       rf_dp_lsp_enq_dir_rx_sync_fifo_mem_pwr_enable_b_in
    ,output logic                       rf_dp_lsp_enq_dir_rx_sync_fifo_mem_pwr_enable_b_out

    ,input  logic                       rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_wclk
    ,input  logic                       rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_wclk_rst_n
    ,input  logic                       rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_we
    ,input  logic[ (   2 ) -1 : 0 ]     rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_waddr
    ,input  logic[ (  23 ) -1 : 0 ]     rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_wdata
    ,input  logic                       rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_rclk
    ,input  logic                       rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_rclk_rst_n
    ,input  logic                       rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_re
    ,input  logic[ (   2 ) -1 : 0 ]     rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_raddr
    ,output logic[ (  23 ) -1 : 0 ]     rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_rdata

    ,input  logic                       rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_isol_en
    ,input  logic                       rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_pwr_enable_b_in
    ,output logic                       rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_pwr_enable_b_out

    ,input  logic                       rf_enq_nalb_fifo_mem_wclk
    ,input  logic                       rf_enq_nalb_fifo_mem_wclk_rst_n
    ,input  logic                       rf_enq_nalb_fifo_mem_we
    ,input  logic[ (   2 ) -1 : 0 ]     rf_enq_nalb_fifo_mem_waddr
    ,input  logic[ (  10 ) -1 : 0 ]     rf_enq_nalb_fifo_mem_wdata
    ,input  logic                       rf_enq_nalb_fifo_mem_rclk
    ,input  logic                       rf_enq_nalb_fifo_mem_rclk_rst_n
    ,input  logic                       rf_enq_nalb_fifo_mem_re
    ,input  logic[ (   2 ) -1 : 0 ]     rf_enq_nalb_fifo_mem_raddr
    ,output logic[ (  10 ) -1 : 0 ]     rf_enq_nalb_fifo_mem_rdata

    ,input  logic                       rf_enq_nalb_fifo_mem_isol_en
    ,input  logic                       rf_enq_nalb_fifo_mem_pwr_enable_b_in
    ,output logic                       rf_enq_nalb_fifo_mem_pwr_enable_b_out

    ,input  logic                       rf_fid2cqqidix_wclk
    ,input  logic                       rf_fid2cqqidix_wclk_rst_n
    ,input  logic                       rf_fid2cqqidix_we
    ,input  logic[ (  11 ) -1 : 0 ]     rf_fid2cqqidix_waddr
    ,input  logic[ (  12 ) -1 : 0 ]     rf_fid2cqqidix_wdata
    ,input  logic                       rf_fid2cqqidix_rclk
    ,input  logic                       rf_fid2cqqidix_rclk_rst_n
    ,input  logic                       rf_fid2cqqidix_re
    ,input  logic[ (  11 ) -1 : 0 ]     rf_fid2cqqidix_raddr
    ,output logic[ (  12 ) -1 : 0 ]     rf_fid2cqqidix_rdata

    ,input  logic                       rf_fid2cqqidix_isol_en
    ,input  logic                       rf_fid2cqqidix_pwr_enable_b_in
    ,output logic                       rf_fid2cqqidix_pwr_enable_b_out

    ,input  logic                       rf_ldb_token_rtn_fifo_mem_wclk
    ,input  logic                       rf_ldb_token_rtn_fifo_mem_wclk_rst_n
    ,input  logic                       rf_ldb_token_rtn_fifo_mem_we
    ,input  logic[ (   3 ) -1 : 0 ]     rf_ldb_token_rtn_fifo_mem_waddr
    ,input  logic[ (  25 ) -1 : 0 ]     rf_ldb_token_rtn_fifo_mem_wdata
    ,input  logic                       rf_ldb_token_rtn_fifo_mem_rclk
    ,input  logic                       rf_ldb_token_rtn_fifo_mem_rclk_rst_n
    ,input  logic                       rf_ldb_token_rtn_fifo_mem_re
    ,input  logic[ (   3 ) -1 : 0 ]     rf_ldb_token_rtn_fifo_mem_raddr
    ,output logic[ (  25 ) -1 : 0 ]     rf_ldb_token_rtn_fifo_mem_rdata

    ,input  logic                       rf_ldb_token_rtn_fifo_mem_isol_en
    ,input  logic                       rf_ldb_token_rtn_fifo_mem_pwr_enable_b_in
    ,output logic                       rf_ldb_token_rtn_fifo_mem_pwr_enable_b_out

    ,input  logic                       rf_ll_enq_cnt_r_bin0_dup0_wclk
    ,input  logic                       rf_ll_enq_cnt_r_bin0_dup0_wclk_rst_n
    ,input  logic                       rf_ll_enq_cnt_r_bin0_dup0_we
    ,input  logic[ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin0_dup0_waddr
    ,input  logic[ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin0_dup0_wdata
    ,input  logic                       rf_ll_enq_cnt_r_bin0_dup0_rclk
    ,input  logic                       rf_ll_enq_cnt_r_bin0_dup0_rclk_rst_n
    ,input  logic                       rf_ll_enq_cnt_r_bin0_dup0_re
    ,input  logic[ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin0_dup0_raddr
    ,output logic[ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin0_dup0_rdata

    ,input  logic                       rf_ll_enq_cnt_r_bin0_dup0_isol_en
    ,input  logic                       rf_ll_enq_cnt_r_bin0_dup0_pwr_enable_b_in
    ,output logic                       rf_ll_enq_cnt_r_bin0_dup0_pwr_enable_b_out

    ,input  logic                       rf_ll_enq_cnt_r_bin0_dup1_wclk
    ,input  logic                       rf_ll_enq_cnt_r_bin0_dup1_wclk_rst_n
    ,input  logic                       rf_ll_enq_cnt_r_bin0_dup1_we
    ,input  logic[ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin0_dup1_waddr
    ,input  logic[ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin0_dup1_wdata
    ,input  logic                       rf_ll_enq_cnt_r_bin0_dup1_rclk
    ,input  logic                       rf_ll_enq_cnt_r_bin0_dup1_rclk_rst_n
    ,input  logic                       rf_ll_enq_cnt_r_bin0_dup1_re
    ,input  logic[ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin0_dup1_raddr
    ,output logic[ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin0_dup1_rdata

    ,input  logic                       rf_ll_enq_cnt_r_bin0_dup1_isol_en
    ,input  logic                       rf_ll_enq_cnt_r_bin0_dup1_pwr_enable_b_in
    ,output logic                       rf_ll_enq_cnt_r_bin0_dup1_pwr_enable_b_out

    ,input  logic                       rf_ll_enq_cnt_r_bin0_dup2_wclk
    ,input  logic                       rf_ll_enq_cnt_r_bin0_dup2_wclk_rst_n
    ,input  logic                       rf_ll_enq_cnt_r_bin0_dup2_we
    ,input  logic[ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin0_dup2_waddr
    ,input  logic[ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin0_dup2_wdata
    ,input  logic                       rf_ll_enq_cnt_r_bin0_dup2_rclk
    ,input  logic                       rf_ll_enq_cnt_r_bin0_dup2_rclk_rst_n
    ,input  logic                       rf_ll_enq_cnt_r_bin0_dup2_re
    ,input  logic[ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin0_dup2_raddr
    ,output logic[ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin0_dup2_rdata

    ,input  logic                       rf_ll_enq_cnt_r_bin0_dup2_isol_en
    ,input  logic                       rf_ll_enq_cnt_r_bin0_dup2_pwr_enable_b_in
    ,output logic                       rf_ll_enq_cnt_r_bin0_dup2_pwr_enable_b_out

    ,input  logic                       rf_ll_enq_cnt_r_bin0_dup3_wclk
    ,input  logic                       rf_ll_enq_cnt_r_bin0_dup3_wclk_rst_n
    ,input  logic                       rf_ll_enq_cnt_r_bin0_dup3_we
    ,input  logic[ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin0_dup3_waddr
    ,input  logic[ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin0_dup3_wdata
    ,input  logic                       rf_ll_enq_cnt_r_bin0_dup3_rclk
    ,input  logic                       rf_ll_enq_cnt_r_bin0_dup3_rclk_rst_n
    ,input  logic                       rf_ll_enq_cnt_r_bin0_dup3_re
    ,input  logic[ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin0_dup3_raddr
    ,output logic[ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin0_dup3_rdata

    ,input  logic                       rf_ll_enq_cnt_r_bin0_dup3_isol_en
    ,input  logic                       rf_ll_enq_cnt_r_bin0_dup3_pwr_enable_b_in
    ,output logic                       rf_ll_enq_cnt_r_bin0_dup3_pwr_enable_b_out

    ,input  logic                       rf_ll_enq_cnt_r_bin1_dup0_wclk
    ,input  logic                       rf_ll_enq_cnt_r_bin1_dup0_wclk_rst_n
    ,input  logic                       rf_ll_enq_cnt_r_bin1_dup0_we
    ,input  logic[ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin1_dup0_waddr
    ,input  logic[ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin1_dup0_wdata
    ,input  logic                       rf_ll_enq_cnt_r_bin1_dup0_rclk
    ,input  logic                       rf_ll_enq_cnt_r_bin1_dup0_rclk_rst_n
    ,input  logic                       rf_ll_enq_cnt_r_bin1_dup0_re
    ,input  logic[ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin1_dup0_raddr
    ,output logic[ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin1_dup0_rdata

    ,input  logic                       rf_ll_enq_cnt_r_bin1_dup0_isol_en
    ,input  logic                       rf_ll_enq_cnt_r_bin1_dup0_pwr_enable_b_in
    ,output logic                       rf_ll_enq_cnt_r_bin1_dup0_pwr_enable_b_out

    ,input  logic                       rf_ll_enq_cnt_r_bin1_dup1_wclk
    ,input  logic                       rf_ll_enq_cnt_r_bin1_dup1_wclk_rst_n
    ,input  logic                       rf_ll_enq_cnt_r_bin1_dup1_we
    ,input  logic[ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin1_dup1_waddr
    ,input  logic[ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin1_dup1_wdata
    ,input  logic                       rf_ll_enq_cnt_r_bin1_dup1_rclk
    ,input  logic                       rf_ll_enq_cnt_r_bin1_dup1_rclk_rst_n
    ,input  logic                       rf_ll_enq_cnt_r_bin1_dup1_re
    ,input  logic[ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin1_dup1_raddr
    ,output logic[ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin1_dup1_rdata

    ,input  logic                       rf_ll_enq_cnt_r_bin1_dup1_isol_en
    ,input  logic                       rf_ll_enq_cnt_r_bin1_dup1_pwr_enable_b_in
    ,output logic                       rf_ll_enq_cnt_r_bin1_dup1_pwr_enable_b_out

    ,input  logic                       rf_ll_enq_cnt_r_bin1_dup2_wclk
    ,input  logic                       rf_ll_enq_cnt_r_bin1_dup2_wclk_rst_n
    ,input  logic                       rf_ll_enq_cnt_r_bin1_dup2_we
    ,input  logic[ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin1_dup2_waddr
    ,input  logic[ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin1_dup2_wdata
    ,input  logic                       rf_ll_enq_cnt_r_bin1_dup2_rclk
    ,input  logic                       rf_ll_enq_cnt_r_bin1_dup2_rclk_rst_n
    ,input  logic                       rf_ll_enq_cnt_r_bin1_dup2_re
    ,input  logic[ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin1_dup2_raddr
    ,output logic[ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin1_dup2_rdata

    ,input  logic                       rf_ll_enq_cnt_r_bin1_dup2_isol_en
    ,input  logic                       rf_ll_enq_cnt_r_bin1_dup2_pwr_enable_b_in
    ,output logic                       rf_ll_enq_cnt_r_bin1_dup2_pwr_enable_b_out

    ,input  logic                       rf_ll_enq_cnt_r_bin1_dup3_wclk
    ,input  logic                       rf_ll_enq_cnt_r_bin1_dup3_wclk_rst_n
    ,input  logic                       rf_ll_enq_cnt_r_bin1_dup3_we
    ,input  logic[ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin1_dup3_waddr
    ,input  logic[ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin1_dup3_wdata
    ,input  logic                       rf_ll_enq_cnt_r_bin1_dup3_rclk
    ,input  logic                       rf_ll_enq_cnt_r_bin1_dup3_rclk_rst_n
    ,input  logic                       rf_ll_enq_cnt_r_bin1_dup3_re
    ,input  logic[ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin1_dup3_raddr
    ,output logic[ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin1_dup3_rdata

    ,input  logic                       rf_ll_enq_cnt_r_bin1_dup3_isol_en
    ,input  logic                       rf_ll_enq_cnt_r_bin1_dup3_pwr_enable_b_in
    ,output logic                       rf_ll_enq_cnt_r_bin1_dup3_pwr_enable_b_out

    ,input  logic                       rf_ll_enq_cnt_r_bin2_dup0_wclk
    ,input  logic                       rf_ll_enq_cnt_r_bin2_dup0_wclk_rst_n
    ,input  logic                       rf_ll_enq_cnt_r_bin2_dup0_we
    ,input  logic[ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin2_dup0_waddr
    ,input  logic[ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin2_dup0_wdata
    ,input  logic                       rf_ll_enq_cnt_r_bin2_dup0_rclk
    ,input  logic                       rf_ll_enq_cnt_r_bin2_dup0_rclk_rst_n
    ,input  logic                       rf_ll_enq_cnt_r_bin2_dup0_re
    ,input  logic[ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin2_dup0_raddr
    ,output logic[ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin2_dup0_rdata

    ,input  logic                       rf_ll_enq_cnt_r_bin2_dup0_isol_en
    ,input  logic                       rf_ll_enq_cnt_r_bin2_dup0_pwr_enable_b_in
    ,output logic                       rf_ll_enq_cnt_r_bin2_dup0_pwr_enable_b_out

    ,input  logic                       rf_ll_enq_cnt_r_bin2_dup1_wclk
    ,input  logic                       rf_ll_enq_cnt_r_bin2_dup1_wclk_rst_n
    ,input  logic                       rf_ll_enq_cnt_r_bin2_dup1_we
    ,input  logic[ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin2_dup1_waddr
    ,input  logic[ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin2_dup1_wdata
    ,input  logic                       rf_ll_enq_cnt_r_bin2_dup1_rclk
    ,input  logic                       rf_ll_enq_cnt_r_bin2_dup1_rclk_rst_n
    ,input  logic                       rf_ll_enq_cnt_r_bin2_dup1_re
    ,input  logic[ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin2_dup1_raddr
    ,output logic[ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin2_dup1_rdata

    ,input  logic                       rf_ll_enq_cnt_r_bin2_dup1_isol_en
    ,input  logic                       rf_ll_enq_cnt_r_bin2_dup1_pwr_enable_b_in
    ,output logic                       rf_ll_enq_cnt_r_bin2_dup1_pwr_enable_b_out

    ,input  logic                       rf_ll_enq_cnt_r_bin2_dup2_wclk
    ,input  logic                       rf_ll_enq_cnt_r_bin2_dup2_wclk_rst_n
    ,input  logic                       rf_ll_enq_cnt_r_bin2_dup2_we
    ,input  logic[ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin2_dup2_waddr
    ,input  logic[ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin2_dup2_wdata
    ,input  logic                       rf_ll_enq_cnt_r_bin2_dup2_rclk
    ,input  logic                       rf_ll_enq_cnt_r_bin2_dup2_rclk_rst_n
    ,input  logic                       rf_ll_enq_cnt_r_bin2_dup2_re
    ,input  logic[ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin2_dup2_raddr
    ,output logic[ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin2_dup2_rdata

    ,input  logic                       rf_ll_enq_cnt_r_bin2_dup2_isol_en
    ,input  logic                       rf_ll_enq_cnt_r_bin2_dup2_pwr_enable_b_in
    ,output logic                       rf_ll_enq_cnt_r_bin2_dup2_pwr_enable_b_out

    ,input  logic                       rf_ll_enq_cnt_r_bin2_dup3_wclk
    ,input  logic                       rf_ll_enq_cnt_r_bin2_dup3_wclk_rst_n
    ,input  logic                       rf_ll_enq_cnt_r_bin2_dup3_we
    ,input  logic[ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin2_dup3_waddr
    ,input  logic[ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin2_dup3_wdata
    ,input  logic                       rf_ll_enq_cnt_r_bin2_dup3_rclk
    ,input  logic                       rf_ll_enq_cnt_r_bin2_dup3_rclk_rst_n
    ,input  logic                       rf_ll_enq_cnt_r_bin2_dup3_re
    ,input  logic[ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin2_dup3_raddr
    ,output logic[ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin2_dup3_rdata

    ,input  logic                       rf_ll_enq_cnt_r_bin2_dup3_isol_en
    ,input  logic                       rf_ll_enq_cnt_r_bin2_dup3_pwr_enable_b_in
    ,output logic                       rf_ll_enq_cnt_r_bin2_dup3_pwr_enable_b_out

    ,input  logic                       rf_ll_enq_cnt_r_bin3_dup0_wclk
    ,input  logic                       rf_ll_enq_cnt_r_bin3_dup0_wclk_rst_n
    ,input  logic                       rf_ll_enq_cnt_r_bin3_dup0_we
    ,input  logic[ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin3_dup0_waddr
    ,input  logic[ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin3_dup0_wdata
    ,input  logic                       rf_ll_enq_cnt_r_bin3_dup0_rclk
    ,input  logic                       rf_ll_enq_cnt_r_bin3_dup0_rclk_rst_n
    ,input  logic                       rf_ll_enq_cnt_r_bin3_dup0_re
    ,input  logic[ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin3_dup0_raddr
    ,output logic[ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin3_dup0_rdata

    ,input  logic                       rf_ll_enq_cnt_r_bin3_dup0_isol_en
    ,input  logic                       rf_ll_enq_cnt_r_bin3_dup0_pwr_enable_b_in
    ,output logic                       rf_ll_enq_cnt_r_bin3_dup0_pwr_enable_b_out

    ,input  logic                       rf_ll_enq_cnt_r_bin3_dup1_wclk
    ,input  logic                       rf_ll_enq_cnt_r_bin3_dup1_wclk_rst_n
    ,input  logic                       rf_ll_enq_cnt_r_bin3_dup1_we
    ,input  logic[ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin3_dup1_waddr
    ,input  logic[ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin3_dup1_wdata
    ,input  logic                       rf_ll_enq_cnt_r_bin3_dup1_rclk
    ,input  logic                       rf_ll_enq_cnt_r_bin3_dup1_rclk_rst_n
    ,input  logic                       rf_ll_enq_cnt_r_bin3_dup1_re
    ,input  logic[ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin3_dup1_raddr
    ,output logic[ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin3_dup1_rdata

    ,input  logic                       rf_ll_enq_cnt_r_bin3_dup1_isol_en
    ,input  logic                       rf_ll_enq_cnt_r_bin3_dup1_pwr_enable_b_in
    ,output logic                       rf_ll_enq_cnt_r_bin3_dup1_pwr_enable_b_out

    ,input  logic                       rf_ll_enq_cnt_r_bin3_dup2_wclk
    ,input  logic                       rf_ll_enq_cnt_r_bin3_dup2_wclk_rst_n
    ,input  logic                       rf_ll_enq_cnt_r_bin3_dup2_we
    ,input  logic[ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin3_dup2_waddr
    ,input  logic[ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin3_dup2_wdata
    ,input  logic                       rf_ll_enq_cnt_r_bin3_dup2_rclk
    ,input  logic                       rf_ll_enq_cnt_r_bin3_dup2_rclk_rst_n
    ,input  logic                       rf_ll_enq_cnt_r_bin3_dup2_re
    ,input  logic[ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin3_dup2_raddr
    ,output logic[ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin3_dup2_rdata

    ,input  logic                       rf_ll_enq_cnt_r_bin3_dup2_isol_en
    ,input  logic                       rf_ll_enq_cnt_r_bin3_dup2_pwr_enable_b_in
    ,output logic                       rf_ll_enq_cnt_r_bin3_dup2_pwr_enable_b_out

    ,input  logic                       rf_ll_enq_cnt_r_bin3_dup3_wclk
    ,input  logic                       rf_ll_enq_cnt_r_bin3_dup3_wclk_rst_n
    ,input  logic                       rf_ll_enq_cnt_r_bin3_dup3_we
    ,input  logic[ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin3_dup3_waddr
    ,input  logic[ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin3_dup3_wdata
    ,input  logic                       rf_ll_enq_cnt_r_bin3_dup3_rclk
    ,input  logic                       rf_ll_enq_cnt_r_bin3_dup3_rclk_rst_n
    ,input  logic                       rf_ll_enq_cnt_r_bin3_dup3_re
    ,input  logic[ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin3_dup3_raddr
    ,output logic[ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_r_bin3_dup3_rdata

    ,input  logic                       rf_ll_enq_cnt_r_bin3_dup3_isol_en
    ,input  logic                       rf_ll_enq_cnt_r_bin3_dup3_pwr_enable_b_in
    ,output logic                       rf_ll_enq_cnt_r_bin3_dup3_pwr_enable_b_out

    ,input  logic                       rf_ll_enq_cnt_s_bin0_wclk
    ,input  logic                       rf_ll_enq_cnt_s_bin0_wclk_rst_n
    ,input  logic                       rf_ll_enq_cnt_s_bin0_we
    ,input  logic[ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_s_bin0_waddr
    ,input  logic[ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_s_bin0_wdata
    ,input  logic                       rf_ll_enq_cnt_s_bin0_rclk
    ,input  logic                       rf_ll_enq_cnt_s_bin0_rclk_rst_n
    ,input  logic                       rf_ll_enq_cnt_s_bin0_re
    ,input  logic[ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_s_bin0_raddr
    ,output logic[ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_s_bin0_rdata

    ,input  logic                       rf_ll_enq_cnt_s_bin0_isol_en
    ,input  logic                       rf_ll_enq_cnt_s_bin0_pwr_enable_b_in
    ,output logic                       rf_ll_enq_cnt_s_bin0_pwr_enable_b_out

    ,input  logic                       rf_ll_enq_cnt_s_bin1_wclk
    ,input  logic                       rf_ll_enq_cnt_s_bin1_wclk_rst_n
    ,input  logic                       rf_ll_enq_cnt_s_bin1_we
    ,input  logic[ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_s_bin1_waddr
    ,input  logic[ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_s_bin1_wdata
    ,input  logic                       rf_ll_enq_cnt_s_bin1_rclk
    ,input  logic                       rf_ll_enq_cnt_s_bin1_rclk_rst_n
    ,input  logic                       rf_ll_enq_cnt_s_bin1_re
    ,input  logic[ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_s_bin1_raddr
    ,output logic[ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_s_bin1_rdata

    ,input  logic                       rf_ll_enq_cnt_s_bin1_isol_en
    ,input  logic                       rf_ll_enq_cnt_s_bin1_pwr_enable_b_in
    ,output logic                       rf_ll_enq_cnt_s_bin1_pwr_enable_b_out

    ,input  logic                       rf_ll_enq_cnt_s_bin2_wclk
    ,input  logic                       rf_ll_enq_cnt_s_bin2_wclk_rst_n
    ,input  logic                       rf_ll_enq_cnt_s_bin2_we
    ,input  logic[ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_s_bin2_waddr
    ,input  logic[ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_s_bin2_wdata
    ,input  logic                       rf_ll_enq_cnt_s_bin2_rclk
    ,input  logic                       rf_ll_enq_cnt_s_bin2_rclk_rst_n
    ,input  logic                       rf_ll_enq_cnt_s_bin2_re
    ,input  logic[ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_s_bin2_raddr
    ,output logic[ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_s_bin2_rdata

    ,input  logic                       rf_ll_enq_cnt_s_bin2_isol_en
    ,input  logic                       rf_ll_enq_cnt_s_bin2_pwr_enable_b_in
    ,output logic                       rf_ll_enq_cnt_s_bin2_pwr_enable_b_out

    ,input  logic                       rf_ll_enq_cnt_s_bin3_wclk
    ,input  logic                       rf_ll_enq_cnt_s_bin3_wclk_rst_n
    ,input  logic                       rf_ll_enq_cnt_s_bin3_we
    ,input  logic[ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_s_bin3_waddr
    ,input  logic[ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_s_bin3_wdata
    ,input  logic                       rf_ll_enq_cnt_s_bin3_rclk
    ,input  logic                       rf_ll_enq_cnt_s_bin3_rclk_rst_n
    ,input  logic                       rf_ll_enq_cnt_s_bin3_re
    ,input  logic[ (  11 ) -1 : 0 ]     rf_ll_enq_cnt_s_bin3_raddr
    ,output logic[ (  16 ) -1 : 0 ]     rf_ll_enq_cnt_s_bin3_rdata

    ,input  logic                       rf_ll_enq_cnt_s_bin3_isol_en
    ,input  logic                       rf_ll_enq_cnt_s_bin3_pwr_enable_b_in
    ,output logic                       rf_ll_enq_cnt_s_bin3_pwr_enable_b_out

    ,input  logic                       rf_ll_rdylst_hp_bin0_wclk
    ,input  logic                       rf_ll_rdylst_hp_bin0_wclk_rst_n
    ,input  logic                       rf_ll_rdylst_hp_bin0_we
    ,input  logic[ (   5 ) -1 : 0 ]     rf_ll_rdylst_hp_bin0_waddr
    ,input  logic[ (  14 ) -1 : 0 ]     rf_ll_rdylst_hp_bin0_wdata
    ,input  logic                       rf_ll_rdylst_hp_bin0_rclk
    ,input  logic                       rf_ll_rdylst_hp_bin0_rclk_rst_n
    ,input  logic                       rf_ll_rdylst_hp_bin0_re
    ,input  logic[ (   5 ) -1 : 0 ]     rf_ll_rdylst_hp_bin0_raddr
    ,output logic[ (  14 ) -1 : 0 ]     rf_ll_rdylst_hp_bin0_rdata

    ,input  logic                       rf_ll_rdylst_hp_bin0_isol_en
    ,input  logic                       rf_ll_rdylst_hp_bin0_pwr_enable_b_in
    ,output logic                       rf_ll_rdylst_hp_bin0_pwr_enable_b_out

    ,input  logic                       rf_ll_rdylst_hp_bin1_wclk
    ,input  logic                       rf_ll_rdylst_hp_bin1_wclk_rst_n
    ,input  logic                       rf_ll_rdylst_hp_bin1_we
    ,input  logic[ (   5 ) -1 : 0 ]     rf_ll_rdylst_hp_bin1_waddr
    ,input  logic[ (  14 ) -1 : 0 ]     rf_ll_rdylst_hp_bin1_wdata
    ,input  logic                       rf_ll_rdylst_hp_bin1_rclk
    ,input  logic                       rf_ll_rdylst_hp_bin1_rclk_rst_n
    ,input  logic                       rf_ll_rdylst_hp_bin1_re
    ,input  logic[ (   5 ) -1 : 0 ]     rf_ll_rdylst_hp_bin1_raddr
    ,output logic[ (  14 ) -1 : 0 ]     rf_ll_rdylst_hp_bin1_rdata

    ,input  logic                       rf_ll_rdylst_hp_bin1_isol_en
    ,input  logic                       rf_ll_rdylst_hp_bin1_pwr_enable_b_in
    ,output logic                       rf_ll_rdylst_hp_bin1_pwr_enable_b_out

    ,input  logic                       rf_ll_rdylst_hp_bin2_wclk
    ,input  logic                       rf_ll_rdylst_hp_bin2_wclk_rst_n
    ,input  logic                       rf_ll_rdylst_hp_bin2_we
    ,input  logic[ (   5 ) -1 : 0 ]     rf_ll_rdylst_hp_bin2_waddr
    ,input  logic[ (  14 ) -1 : 0 ]     rf_ll_rdylst_hp_bin2_wdata
    ,input  logic                       rf_ll_rdylst_hp_bin2_rclk
    ,input  logic                       rf_ll_rdylst_hp_bin2_rclk_rst_n
    ,input  logic                       rf_ll_rdylst_hp_bin2_re
    ,input  logic[ (   5 ) -1 : 0 ]     rf_ll_rdylst_hp_bin2_raddr
    ,output logic[ (  14 ) -1 : 0 ]     rf_ll_rdylst_hp_bin2_rdata

    ,input  logic                       rf_ll_rdylst_hp_bin2_isol_en
    ,input  logic                       rf_ll_rdylst_hp_bin2_pwr_enable_b_in
    ,output logic                       rf_ll_rdylst_hp_bin2_pwr_enable_b_out

    ,input  logic                       rf_ll_rdylst_hp_bin3_wclk
    ,input  logic                       rf_ll_rdylst_hp_bin3_wclk_rst_n
    ,input  logic                       rf_ll_rdylst_hp_bin3_we
    ,input  logic[ (   5 ) -1 : 0 ]     rf_ll_rdylst_hp_bin3_waddr
    ,input  logic[ (  14 ) -1 : 0 ]     rf_ll_rdylst_hp_bin3_wdata
    ,input  logic                       rf_ll_rdylst_hp_bin3_rclk
    ,input  logic                       rf_ll_rdylst_hp_bin3_rclk_rst_n
    ,input  logic                       rf_ll_rdylst_hp_bin3_re
    ,input  logic[ (   5 ) -1 : 0 ]     rf_ll_rdylst_hp_bin3_raddr
    ,output logic[ (  14 ) -1 : 0 ]     rf_ll_rdylst_hp_bin3_rdata

    ,input  logic                       rf_ll_rdylst_hp_bin3_isol_en
    ,input  logic                       rf_ll_rdylst_hp_bin3_pwr_enable_b_in
    ,output logic                       rf_ll_rdylst_hp_bin3_pwr_enable_b_out

    ,input  logic                       rf_ll_rdylst_hpnxt_bin0_wclk
    ,input  logic                       rf_ll_rdylst_hpnxt_bin0_wclk_rst_n
    ,input  logic                       rf_ll_rdylst_hpnxt_bin0_we
    ,input  logic[ (  11 ) -1 : 0 ]     rf_ll_rdylst_hpnxt_bin0_waddr
    ,input  logic[ (  16 ) -1 : 0 ]     rf_ll_rdylst_hpnxt_bin0_wdata
    ,input  logic                       rf_ll_rdylst_hpnxt_bin0_rclk
    ,input  logic                       rf_ll_rdylst_hpnxt_bin0_rclk_rst_n
    ,input  logic                       rf_ll_rdylst_hpnxt_bin0_re
    ,input  logic[ (  11 ) -1 : 0 ]     rf_ll_rdylst_hpnxt_bin0_raddr
    ,output logic[ (  16 ) -1 : 0 ]     rf_ll_rdylst_hpnxt_bin0_rdata

    ,input  logic                       rf_ll_rdylst_hpnxt_bin0_isol_en
    ,input  logic                       rf_ll_rdylst_hpnxt_bin0_pwr_enable_b_in
    ,output logic                       rf_ll_rdylst_hpnxt_bin0_pwr_enable_b_out

    ,input  logic                       rf_ll_rdylst_hpnxt_bin1_wclk
    ,input  logic                       rf_ll_rdylst_hpnxt_bin1_wclk_rst_n
    ,input  logic                       rf_ll_rdylst_hpnxt_bin1_we
    ,input  logic[ (  11 ) -1 : 0 ]     rf_ll_rdylst_hpnxt_bin1_waddr
    ,input  logic[ (  16 ) -1 : 0 ]     rf_ll_rdylst_hpnxt_bin1_wdata
    ,input  logic                       rf_ll_rdylst_hpnxt_bin1_rclk
    ,input  logic                       rf_ll_rdylst_hpnxt_bin1_rclk_rst_n
    ,input  logic                       rf_ll_rdylst_hpnxt_bin1_re
    ,input  logic[ (  11 ) -1 : 0 ]     rf_ll_rdylst_hpnxt_bin1_raddr
    ,output logic[ (  16 ) -1 : 0 ]     rf_ll_rdylst_hpnxt_bin1_rdata

    ,input  logic                       rf_ll_rdylst_hpnxt_bin1_isol_en
    ,input  logic                       rf_ll_rdylst_hpnxt_bin1_pwr_enable_b_in
    ,output logic                       rf_ll_rdylst_hpnxt_bin1_pwr_enable_b_out

    ,input  logic                       rf_ll_rdylst_hpnxt_bin2_wclk
    ,input  logic                       rf_ll_rdylst_hpnxt_bin2_wclk_rst_n
    ,input  logic                       rf_ll_rdylst_hpnxt_bin2_we
    ,input  logic[ (  11 ) -1 : 0 ]     rf_ll_rdylst_hpnxt_bin2_waddr
    ,input  logic[ (  16 ) -1 : 0 ]     rf_ll_rdylst_hpnxt_bin2_wdata
    ,input  logic                       rf_ll_rdylst_hpnxt_bin2_rclk
    ,input  logic                       rf_ll_rdylst_hpnxt_bin2_rclk_rst_n
    ,input  logic                       rf_ll_rdylst_hpnxt_bin2_re
    ,input  logic[ (  11 ) -1 : 0 ]     rf_ll_rdylst_hpnxt_bin2_raddr
    ,output logic[ (  16 ) -1 : 0 ]     rf_ll_rdylst_hpnxt_bin2_rdata

    ,input  logic                       rf_ll_rdylst_hpnxt_bin2_isol_en
    ,input  logic                       rf_ll_rdylst_hpnxt_bin2_pwr_enable_b_in
    ,output logic                       rf_ll_rdylst_hpnxt_bin2_pwr_enable_b_out

    ,input  logic                       rf_ll_rdylst_hpnxt_bin3_wclk
    ,input  logic                       rf_ll_rdylst_hpnxt_bin3_wclk_rst_n
    ,input  logic                       rf_ll_rdylst_hpnxt_bin3_we
    ,input  logic[ (  11 ) -1 : 0 ]     rf_ll_rdylst_hpnxt_bin3_waddr
    ,input  logic[ (  16 ) -1 : 0 ]     rf_ll_rdylst_hpnxt_bin3_wdata
    ,input  logic                       rf_ll_rdylst_hpnxt_bin3_rclk
    ,input  logic                       rf_ll_rdylst_hpnxt_bin3_rclk_rst_n
    ,input  logic                       rf_ll_rdylst_hpnxt_bin3_re
    ,input  logic[ (  11 ) -1 : 0 ]     rf_ll_rdylst_hpnxt_bin3_raddr
    ,output logic[ (  16 ) -1 : 0 ]     rf_ll_rdylst_hpnxt_bin3_rdata

    ,input  logic                       rf_ll_rdylst_hpnxt_bin3_isol_en
    ,input  logic                       rf_ll_rdylst_hpnxt_bin3_pwr_enable_b_in
    ,output logic                       rf_ll_rdylst_hpnxt_bin3_pwr_enable_b_out

    ,input  logic                       rf_ll_rdylst_tp_bin0_wclk
    ,input  logic                       rf_ll_rdylst_tp_bin0_wclk_rst_n
    ,input  logic                       rf_ll_rdylst_tp_bin0_we
    ,input  logic[ (   5 ) -1 : 0 ]     rf_ll_rdylst_tp_bin0_waddr
    ,input  logic[ (  14 ) -1 : 0 ]     rf_ll_rdylst_tp_bin0_wdata
    ,input  logic                       rf_ll_rdylst_tp_bin0_rclk
    ,input  logic                       rf_ll_rdylst_tp_bin0_rclk_rst_n
    ,input  logic                       rf_ll_rdylst_tp_bin0_re
    ,input  logic[ (   5 ) -1 : 0 ]     rf_ll_rdylst_tp_bin0_raddr
    ,output logic[ (  14 ) -1 : 0 ]     rf_ll_rdylst_tp_bin0_rdata

    ,input  logic                       rf_ll_rdylst_tp_bin0_isol_en
    ,input  logic                       rf_ll_rdylst_tp_bin0_pwr_enable_b_in
    ,output logic                       rf_ll_rdylst_tp_bin0_pwr_enable_b_out

    ,input  logic                       rf_ll_rdylst_tp_bin1_wclk
    ,input  logic                       rf_ll_rdylst_tp_bin1_wclk_rst_n
    ,input  logic                       rf_ll_rdylst_tp_bin1_we
    ,input  logic[ (   5 ) -1 : 0 ]     rf_ll_rdylst_tp_bin1_waddr
    ,input  logic[ (  14 ) -1 : 0 ]     rf_ll_rdylst_tp_bin1_wdata
    ,input  logic                       rf_ll_rdylst_tp_bin1_rclk
    ,input  logic                       rf_ll_rdylst_tp_bin1_rclk_rst_n
    ,input  logic                       rf_ll_rdylst_tp_bin1_re
    ,input  logic[ (   5 ) -1 : 0 ]     rf_ll_rdylst_tp_bin1_raddr
    ,output logic[ (  14 ) -1 : 0 ]     rf_ll_rdylst_tp_bin1_rdata

    ,input  logic                       rf_ll_rdylst_tp_bin1_isol_en
    ,input  logic                       rf_ll_rdylst_tp_bin1_pwr_enable_b_in
    ,output logic                       rf_ll_rdylst_tp_bin1_pwr_enable_b_out

    ,input  logic                       rf_ll_rdylst_tp_bin2_wclk
    ,input  logic                       rf_ll_rdylst_tp_bin2_wclk_rst_n
    ,input  logic                       rf_ll_rdylst_tp_bin2_we
    ,input  logic[ (   5 ) -1 : 0 ]     rf_ll_rdylst_tp_bin2_waddr
    ,input  logic[ (  14 ) -1 : 0 ]     rf_ll_rdylst_tp_bin2_wdata
    ,input  logic                       rf_ll_rdylst_tp_bin2_rclk
    ,input  logic                       rf_ll_rdylst_tp_bin2_rclk_rst_n
    ,input  logic                       rf_ll_rdylst_tp_bin2_re
    ,input  logic[ (   5 ) -1 : 0 ]     rf_ll_rdylst_tp_bin2_raddr
    ,output logic[ (  14 ) -1 : 0 ]     rf_ll_rdylst_tp_bin2_rdata

    ,input  logic                       rf_ll_rdylst_tp_bin2_isol_en
    ,input  logic                       rf_ll_rdylst_tp_bin2_pwr_enable_b_in
    ,output logic                       rf_ll_rdylst_tp_bin2_pwr_enable_b_out

    ,input  logic                       rf_ll_rdylst_tp_bin3_wclk
    ,input  logic                       rf_ll_rdylst_tp_bin3_wclk_rst_n
    ,input  logic                       rf_ll_rdylst_tp_bin3_we
    ,input  logic[ (   5 ) -1 : 0 ]     rf_ll_rdylst_tp_bin3_waddr
    ,input  logic[ (  14 ) -1 : 0 ]     rf_ll_rdylst_tp_bin3_wdata
    ,input  logic                       rf_ll_rdylst_tp_bin3_rclk
    ,input  logic                       rf_ll_rdylst_tp_bin3_rclk_rst_n
    ,input  logic                       rf_ll_rdylst_tp_bin3_re
    ,input  logic[ (   5 ) -1 : 0 ]     rf_ll_rdylst_tp_bin3_raddr
    ,output logic[ (  14 ) -1 : 0 ]     rf_ll_rdylst_tp_bin3_rdata

    ,input  logic                       rf_ll_rdylst_tp_bin3_isol_en
    ,input  logic                       rf_ll_rdylst_tp_bin3_pwr_enable_b_in
    ,output logic                       rf_ll_rdylst_tp_bin3_pwr_enable_b_out

    ,input  logic                       rf_ll_rlst_cnt_wclk
    ,input  logic                       rf_ll_rlst_cnt_wclk_rst_n
    ,input  logic                       rf_ll_rlst_cnt_we
    ,input  logic[ (   5 ) -1 : 0 ]     rf_ll_rlst_cnt_waddr
    ,input  logic[ (  56 ) -1 : 0 ]     rf_ll_rlst_cnt_wdata
    ,input  logic                       rf_ll_rlst_cnt_rclk
    ,input  logic                       rf_ll_rlst_cnt_rclk_rst_n
    ,input  logic                       rf_ll_rlst_cnt_re
    ,input  logic[ (   5 ) -1 : 0 ]     rf_ll_rlst_cnt_raddr
    ,output logic[ (  56 ) -1 : 0 ]     rf_ll_rlst_cnt_rdata

    ,input  logic                       rf_ll_rlst_cnt_isol_en
    ,input  logic                       rf_ll_rlst_cnt_pwr_enable_b_in
    ,output logic                       rf_ll_rlst_cnt_pwr_enable_b_out

    ,input  logic                       rf_ll_sch_cnt_dup0_wclk
    ,input  logic                       rf_ll_sch_cnt_dup0_wclk_rst_n
    ,input  logic                       rf_ll_sch_cnt_dup0_we
    ,input  logic[ (  11 ) -1 : 0 ]     rf_ll_sch_cnt_dup0_waddr
    ,input  logic[ (  17 ) -1 : 0 ]     rf_ll_sch_cnt_dup0_wdata
    ,input  logic                       rf_ll_sch_cnt_dup0_rclk
    ,input  logic                       rf_ll_sch_cnt_dup0_rclk_rst_n
    ,input  logic                       rf_ll_sch_cnt_dup0_re
    ,input  logic[ (  11 ) -1 : 0 ]     rf_ll_sch_cnt_dup0_raddr
    ,output logic[ (  17 ) -1 : 0 ]     rf_ll_sch_cnt_dup0_rdata

    ,input  logic                       rf_ll_sch_cnt_dup0_isol_en
    ,input  logic                       rf_ll_sch_cnt_dup0_pwr_enable_b_in
    ,output logic                       rf_ll_sch_cnt_dup0_pwr_enable_b_out

    ,input  logic                       rf_ll_sch_cnt_dup1_wclk
    ,input  logic                       rf_ll_sch_cnt_dup1_wclk_rst_n
    ,input  logic                       rf_ll_sch_cnt_dup1_we
    ,input  logic[ (  11 ) -1 : 0 ]     rf_ll_sch_cnt_dup1_waddr
    ,input  logic[ (  17 ) -1 : 0 ]     rf_ll_sch_cnt_dup1_wdata
    ,input  logic                       rf_ll_sch_cnt_dup1_rclk
    ,input  logic                       rf_ll_sch_cnt_dup1_rclk_rst_n
    ,input  logic                       rf_ll_sch_cnt_dup1_re
    ,input  logic[ (  11 ) -1 : 0 ]     rf_ll_sch_cnt_dup1_raddr
    ,output logic[ (  17 ) -1 : 0 ]     rf_ll_sch_cnt_dup1_rdata

    ,input  logic                       rf_ll_sch_cnt_dup1_isol_en
    ,input  logic                       rf_ll_sch_cnt_dup1_pwr_enable_b_in
    ,output logic                       rf_ll_sch_cnt_dup1_pwr_enable_b_out

    ,input  logic                       rf_ll_sch_cnt_dup2_wclk
    ,input  logic                       rf_ll_sch_cnt_dup2_wclk_rst_n
    ,input  logic                       rf_ll_sch_cnt_dup2_we
    ,input  logic[ (  11 ) -1 : 0 ]     rf_ll_sch_cnt_dup2_waddr
    ,input  logic[ (  17 ) -1 : 0 ]     rf_ll_sch_cnt_dup2_wdata
    ,input  logic                       rf_ll_sch_cnt_dup2_rclk
    ,input  logic                       rf_ll_sch_cnt_dup2_rclk_rst_n
    ,input  logic                       rf_ll_sch_cnt_dup2_re
    ,input  logic[ (  11 ) -1 : 0 ]     rf_ll_sch_cnt_dup2_raddr
    ,output logic[ (  17 ) -1 : 0 ]     rf_ll_sch_cnt_dup2_rdata

    ,input  logic                       rf_ll_sch_cnt_dup2_isol_en
    ,input  logic                       rf_ll_sch_cnt_dup2_pwr_enable_b_in
    ,output logic                       rf_ll_sch_cnt_dup2_pwr_enable_b_out

    ,input  logic                       rf_ll_sch_cnt_dup3_wclk
    ,input  logic                       rf_ll_sch_cnt_dup3_wclk_rst_n
    ,input  logic                       rf_ll_sch_cnt_dup3_we
    ,input  logic[ (  11 ) -1 : 0 ]     rf_ll_sch_cnt_dup3_waddr
    ,input  logic[ (  17 ) -1 : 0 ]     rf_ll_sch_cnt_dup3_wdata
    ,input  logic                       rf_ll_sch_cnt_dup3_rclk
    ,input  logic                       rf_ll_sch_cnt_dup3_rclk_rst_n
    ,input  logic                       rf_ll_sch_cnt_dup3_re
    ,input  logic[ (  11 ) -1 : 0 ]     rf_ll_sch_cnt_dup3_raddr
    ,output logic[ (  17 ) -1 : 0 ]     rf_ll_sch_cnt_dup3_rdata

    ,input  logic                       rf_ll_sch_cnt_dup3_isol_en
    ,input  logic                       rf_ll_sch_cnt_dup3_pwr_enable_b_in
    ,output logic                       rf_ll_sch_cnt_dup3_pwr_enable_b_out

    ,input  logic                       rf_ll_schlst_hp_bin0_wclk
    ,input  logic                       rf_ll_schlst_hp_bin0_wclk_rst_n
    ,input  logic                       rf_ll_schlst_hp_bin0_we
    ,input  logic[ (   9 ) -1 : 0 ]     rf_ll_schlst_hp_bin0_waddr
    ,input  logic[ (  14 ) -1 : 0 ]     rf_ll_schlst_hp_bin0_wdata
    ,input  logic                       rf_ll_schlst_hp_bin0_rclk
    ,input  logic                       rf_ll_schlst_hp_bin0_rclk_rst_n
    ,input  logic                       rf_ll_schlst_hp_bin0_re
    ,input  logic[ (   9 ) -1 : 0 ]     rf_ll_schlst_hp_bin0_raddr
    ,output logic[ (  14 ) -1 : 0 ]     rf_ll_schlst_hp_bin0_rdata

    ,input  logic                       rf_ll_schlst_hp_bin0_isol_en
    ,input  logic                       rf_ll_schlst_hp_bin0_pwr_enable_b_in
    ,output logic                       rf_ll_schlst_hp_bin0_pwr_enable_b_out

    ,input  logic                       rf_ll_schlst_hp_bin1_wclk
    ,input  logic                       rf_ll_schlst_hp_bin1_wclk_rst_n
    ,input  logic                       rf_ll_schlst_hp_bin1_we
    ,input  logic[ (   9 ) -1 : 0 ]     rf_ll_schlst_hp_bin1_waddr
    ,input  logic[ (  14 ) -1 : 0 ]     rf_ll_schlst_hp_bin1_wdata
    ,input  logic                       rf_ll_schlst_hp_bin1_rclk
    ,input  logic                       rf_ll_schlst_hp_bin1_rclk_rst_n
    ,input  logic                       rf_ll_schlst_hp_bin1_re
    ,input  logic[ (   9 ) -1 : 0 ]     rf_ll_schlst_hp_bin1_raddr
    ,output logic[ (  14 ) -1 : 0 ]     rf_ll_schlst_hp_bin1_rdata

    ,input  logic                       rf_ll_schlst_hp_bin1_isol_en
    ,input  logic                       rf_ll_schlst_hp_bin1_pwr_enable_b_in
    ,output logic                       rf_ll_schlst_hp_bin1_pwr_enable_b_out

    ,input  logic                       rf_ll_schlst_hp_bin2_wclk
    ,input  logic                       rf_ll_schlst_hp_bin2_wclk_rst_n
    ,input  logic                       rf_ll_schlst_hp_bin2_we
    ,input  logic[ (   9 ) -1 : 0 ]     rf_ll_schlst_hp_bin2_waddr
    ,input  logic[ (  14 ) -1 : 0 ]     rf_ll_schlst_hp_bin2_wdata
    ,input  logic                       rf_ll_schlst_hp_bin2_rclk
    ,input  logic                       rf_ll_schlst_hp_bin2_rclk_rst_n
    ,input  logic                       rf_ll_schlst_hp_bin2_re
    ,input  logic[ (   9 ) -1 : 0 ]     rf_ll_schlst_hp_bin2_raddr
    ,output logic[ (  14 ) -1 : 0 ]     rf_ll_schlst_hp_bin2_rdata

    ,input  logic                       rf_ll_schlst_hp_bin2_isol_en
    ,input  logic                       rf_ll_schlst_hp_bin2_pwr_enable_b_in
    ,output logic                       rf_ll_schlst_hp_bin2_pwr_enable_b_out

    ,input  logic                       rf_ll_schlst_hp_bin3_wclk
    ,input  logic                       rf_ll_schlst_hp_bin3_wclk_rst_n
    ,input  logic                       rf_ll_schlst_hp_bin3_we
    ,input  logic[ (   9 ) -1 : 0 ]     rf_ll_schlst_hp_bin3_waddr
    ,input  logic[ (  14 ) -1 : 0 ]     rf_ll_schlst_hp_bin3_wdata
    ,input  logic                       rf_ll_schlst_hp_bin3_rclk
    ,input  logic                       rf_ll_schlst_hp_bin3_rclk_rst_n
    ,input  logic                       rf_ll_schlst_hp_bin3_re
    ,input  logic[ (   9 ) -1 : 0 ]     rf_ll_schlst_hp_bin3_raddr
    ,output logic[ (  14 ) -1 : 0 ]     rf_ll_schlst_hp_bin3_rdata

    ,input  logic                       rf_ll_schlst_hp_bin3_isol_en
    ,input  logic                       rf_ll_schlst_hp_bin3_pwr_enable_b_in
    ,output logic                       rf_ll_schlst_hp_bin3_pwr_enable_b_out

    ,input  logic                       rf_ll_schlst_hpnxt_bin0_wclk
    ,input  logic                       rf_ll_schlst_hpnxt_bin0_wclk_rst_n
    ,input  logic                       rf_ll_schlst_hpnxt_bin0_we
    ,input  logic[ (  11 ) -1 : 0 ]     rf_ll_schlst_hpnxt_bin0_waddr
    ,input  logic[ (  16 ) -1 : 0 ]     rf_ll_schlst_hpnxt_bin0_wdata
    ,input  logic                       rf_ll_schlst_hpnxt_bin0_rclk
    ,input  logic                       rf_ll_schlst_hpnxt_bin0_rclk_rst_n
    ,input  logic                       rf_ll_schlst_hpnxt_bin0_re
    ,input  logic[ (  11 ) -1 : 0 ]     rf_ll_schlst_hpnxt_bin0_raddr
    ,output logic[ (  16 ) -1 : 0 ]     rf_ll_schlst_hpnxt_bin0_rdata

    ,input  logic                       rf_ll_schlst_hpnxt_bin0_isol_en
    ,input  logic                       rf_ll_schlst_hpnxt_bin0_pwr_enable_b_in
    ,output logic                       rf_ll_schlst_hpnxt_bin0_pwr_enable_b_out

    ,input  logic                       rf_ll_schlst_hpnxt_bin1_wclk
    ,input  logic                       rf_ll_schlst_hpnxt_bin1_wclk_rst_n
    ,input  logic                       rf_ll_schlst_hpnxt_bin1_we
    ,input  logic[ (  11 ) -1 : 0 ]     rf_ll_schlst_hpnxt_bin1_waddr
    ,input  logic[ (  16 ) -1 : 0 ]     rf_ll_schlst_hpnxt_bin1_wdata
    ,input  logic                       rf_ll_schlst_hpnxt_bin1_rclk
    ,input  logic                       rf_ll_schlst_hpnxt_bin1_rclk_rst_n
    ,input  logic                       rf_ll_schlst_hpnxt_bin1_re
    ,input  logic[ (  11 ) -1 : 0 ]     rf_ll_schlst_hpnxt_bin1_raddr
    ,output logic[ (  16 ) -1 : 0 ]     rf_ll_schlst_hpnxt_bin1_rdata

    ,input  logic                       rf_ll_schlst_hpnxt_bin1_isol_en
    ,input  logic                       rf_ll_schlst_hpnxt_bin1_pwr_enable_b_in
    ,output logic                       rf_ll_schlst_hpnxt_bin1_pwr_enable_b_out

    ,input  logic                       rf_ll_schlst_hpnxt_bin2_wclk
    ,input  logic                       rf_ll_schlst_hpnxt_bin2_wclk_rst_n
    ,input  logic                       rf_ll_schlst_hpnxt_bin2_we
    ,input  logic[ (  11 ) -1 : 0 ]     rf_ll_schlst_hpnxt_bin2_waddr
    ,input  logic[ (  16 ) -1 : 0 ]     rf_ll_schlst_hpnxt_bin2_wdata
    ,input  logic                       rf_ll_schlst_hpnxt_bin2_rclk
    ,input  logic                       rf_ll_schlst_hpnxt_bin2_rclk_rst_n
    ,input  logic                       rf_ll_schlst_hpnxt_bin2_re
    ,input  logic[ (  11 ) -1 : 0 ]     rf_ll_schlst_hpnxt_bin2_raddr
    ,output logic[ (  16 ) -1 : 0 ]     rf_ll_schlst_hpnxt_bin2_rdata

    ,input  logic                       rf_ll_schlst_hpnxt_bin2_isol_en
    ,input  logic                       rf_ll_schlst_hpnxt_bin2_pwr_enable_b_in
    ,output logic                       rf_ll_schlst_hpnxt_bin2_pwr_enable_b_out

    ,input  logic                       rf_ll_schlst_hpnxt_bin3_wclk
    ,input  logic                       rf_ll_schlst_hpnxt_bin3_wclk_rst_n
    ,input  logic                       rf_ll_schlst_hpnxt_bin3_we
    ,input  logic[ (  11 ) -1 : 0 ]     rf_ll_schlst_hpnxt_bin3_waddr
    ,input  logic[ (  16 ) -1 : 0 ]     rf_ll_schlst_hpnxt_bin3_wdata
    ,input  logic                       rf_ll_schlst_hpnxt_bin3_rclk
    ,input  logic                       rf_ll_schlst_hpnxt_bin3_rclk_rst_n
    ,input  logic                       rf_ll_schlst_hpnxt_bin3_re
    ,input  logic[ (  11 ) -1 : 0 ]     rf_ll_schlst_hpnxt_bin3_raddr
    ,output logic[ (  16 ) -1 : 0 ]     rf_ll_schlst_hpnxt_bin3_rdata

    ,input  logic                       rf_ll_schlst_hpnxt_bin3_isol_en
    ,input  logic                       rf_ll_schlst_hpnxt_bin3_pwr_enable_b_in
    ,output logic                       rf_ll_schlst_hpnxt_bin3_pwr_enable_b_out

    ,input  logic                       rf_ll_schlst_tp_bin0_wclk
    ,input  logic                       rf_ll_schlst_tp_bin0_wclk_rst_n
    ,input  logic                       rf_ll_schlst_tp_bin0_we
    ,input  logic[ (   9 ) -1 : 0 ]     rf_ll_schlst_tp_bin0_waddr
    ,input  logic[ (  14 ) -1 : 0 ]     rf_ll_schlst_tp_bin0_wdata
    ,input  logic                       rf_ll_schlst_tp_bin0_rclk
    ,input  logic                       rf_ll_schlst_tp_bin0_rclk_rst_n
    ,input  logic                       rf_ll_schlst_tp_bin0_re
    ,input  logic[ (   9 ) -1 : 0 ]     rf_ll_schlst_tp_bin0_raddr
    ,output logic[ (  14 ) -1 : 0 ]     rf_ll_schlst_tp_bin0_rdata

    ,input  logic                       rf_ll_schlst_tp_bin0_isol_en
    ,input  logic                       rf_ll_schlst_tp_bin0_pwr_enable_b_in
    ,output logic                       rf_ll_schlst_tp_bin0_pwr_enable_b_out

    ,input  logic                       rf_ll_schlst_tp_bin1_wclk
    ,input  logic                       rf_ll_schlst_tp_bin1_wclk_rst_n
    ,input  logic                       rf_ll_schlst_tp_bin1_we
    ,input  logic[ (   9 ) -1 : 0 ]     rf_ll_schlst_tp_bin1_waddr
    ,input  logic[ (  14 ) -1 : 0 ]     rf_ll_schlst_tp_bin1_wdata
    ,input  logic                       rf_ll_schlst_tp_bin1_rclk
    ,input  logic                       rf_ll_schlst_tp_bin1_rclk_rst_n
    ,input  logic                       rf_ll_schlst_tp_bin1_re
    ,input  logic[ (   9 ) -1 : 0 ]     rf_ll_schlst_tp_bin1_raddr
    ,output logic[ (  14 ) -1 : 0 ]     rf_ll_schlst_tp_bin1_rdata

    ,input  logic                       rf_ll_schlst_tp_bin1_isol_en
    ,input  logic                       rf_ll_schlst_tp_bin1_pwr_enable_b_in
    ,output logic                       rf_ll_schlst_tp_bin1_pwr_enable_b_out

    ,input  logic                       rf_ll_schlst_tp_bin2_wclk
    ,input  logic                       rf_ll_schlst_tp_bin2_wclk_rst_n
    ,input  logic                       rf_ll_schlst_tp_bin2_we
    ,input  logic[ (   9 ) -1 : 0 ]     rf_ll_schlst_tp_bin2_waddr
    ,input  logic[ (  14 ) -1 : 0 ]     rf_ll_schlst_tp_bin2_wdata
    ,input  logic                       rf_ll_schlst_tp_bin2_rclk
    ,input  logic                       rf_ll_schlst_tp_bin2_rclk_rst_n
    ,input  logic                       rf_ll_schlst_tp_bin2_re
    ,input  logic[ (   9 ) -1 : 0 ]     rf_ll_schlst_tp_bin2_raddr
    ,output logic[ (  14 ) -1 : 0 ]     rf_ll_schlst_tp_bin2_rdata

    ,input  logic                       rf_ll_schlst_tp_bin2_isol_en
    ,input  logic                       rf_ll_schlst_tp_bin2_pwr_enable_b_in
    ,output logic                       rf_ll_schlst_tp_bin2_pwr_enable_b_out

    ,input  logic                       rf_ll_schlst_tp_bin3_wclk
    ,input  logic                       rf_ll_schlst_tp_bin3_wclk_rst_n
    ,input  logic                       rf_ll_schlst_tp_bin3_we
    ,input  logic[ (   9 ) -1 : 0 ]     rf_ll_schlst_tp_bin3_waddr
    ,input  logic[ (  14 ) -1 : 0 ]     rf_ll_schlst_tp_bin3_wdata
    ,input  logic                       rf_ll_schlst_tp_bin3_rclk
    ,input  logic                       rf_ll_schlst_tp_bin3_rclk_rst_n
    ,input  logic                       rf_ll_schlst_tp_bin3_re
    ,input  logic[ (   9 ) -1 : 0 ]     rf_ll_schlst_tp_bin3_raddr
    ,output logic[ (  14 ) -1 : 0 ]     rf_ll_schlst_tp_bin3_rdata

    ,input  logic                       rf_ll_schlst_tp_bin3_isol_en
    ,input  logic                       rf_ll_schlst_tp_bin3_pwr_enable_b_in
    ,output logic                       rf_ll_schlst_tp_bin3_pwr_enable_b_out

    ,input  logic                       rf_ll_schlst_tpprv_bin0_wclk
    ,input  logic                       rf_ll_schlst_tpprv_bin0_wclk_rst_n
    ,input  logic                       rf_ll_schlst_tpprv_bin0_we
    ,input  logic[ (  11 ) -1 : 0 ]     rf_ll_schlst_tpprv_bin0_waddr
    ,input  logic[ (  16 ) -1 : 0 ]     rf_ll_schlst_tpprv_bin0_wdata
    ,input  logic                       rf_ll_schlst_tpprv_bin0_rclk
    ,input  logic                       rf_ll_schlst_tpprv_bin0_rclk_rst_n
    ,input  logic                       rf_ll_schlst_tpprv_bin0_re
    ,input  logic[ (  11 ) -1 : 0 ]     rf_ll_schlst_tpprv_bin0_raddr
    ,output logic[ (  16 ) -1 : 0 ]     rf_ll_schlst_tpprv_bin0_rdata

    ,input  logic                       rf_ll_schlst_tpprv_bin0_isol_en
    ,input  logic                       rf_ll_schlst_tpprv_bin0_pwr_enable_b_in
    ,output logic                       rf_ll_schlst_tpprv_bin0_pwr_enable_b_out

    ,input  logic                       rf_ll_schlst_tpprv_bin1_wclk
    ,input  logic                       rf_ll_schlst_tpprv_bin1_wclk_rst_n
    ,input  logic                       rf_ll_schlst_tpprv_bin1_we
    ,input  logic[ (  11 ) -1 : 0 ]     rf_ll_schlst_tpprv_bin1_waddr
    ,input  logic[ (  16 ) -1 : 0 ]     rf_ll_schlst_tpprv_bin1_wdata
    ,input  logic                       rf_ll_schlst_tpprv_bin1_rclk
    ,input  logic                       rf_ll_schlst_tpprv_bin1_rclk_rst_n
    ,input  logic                       rf_ll_schlst_tpprv_bin1_re
    ,input  logic[ (  11 ) -1 : 0 ]     rf_ll_schlst_tpprv_bin1_raddr
    ,output logic[ (  16 ) -1 : 0 ]     rf_ll_schlst_tpprv_bin1_rdata

    ,input  logic                       rf_ll_schlst_tpprv_bin1_isol_en
    ,input  logic                       rf_ll_schlst_tpprv_bin1_pwr_enable_b_in
    ,output logic                       rf_ll_schlst_tpprv_bin1_pwr_enable_b_out

    ,input  logic                       rf_ll_schlst_tpprv_bin2_wclk
    ,input  logic                       rf_ll_schlst_tpprv_bin2_wclk_rst_n
    ,input  logic                       rf_ll_schlst_tpprv_bin2_we
    ,input  logic[ (  11 ) -1 : 0 ]     rf_ll_schlst_tpprv_bin2_waddr
    ,input  logic[ (  16 ) -1 : 0 ]     rf_ll_schlst_tpprv_bin2_wdata
    ,input  logic                       rf_ll_schlst_tpprv_bin2_rclk
    ,input  logic                       rf_ll_schlst_tpprv_bin2_rclk_rst_n
    ,input  logic                       rf_ll_schlst_tpprv_bin2_re
    ,input  logic[ (  11 ) -1 : 0 ]     rf_ll_schlst_tpprv_bin2_raddr
    ,output logic[ (  16 ) -1 : 0 ]     rf_ll_schlst_tpprv_bin2_rdata

    ,input  logic                       rf_ll_schlst_tpprv_bin2_isol_en
    ,input  logic                       rf_ll_schlst_tpprv_bin2_pwr_enable_b_in
    ,output logic                       rf_ll_schlst_tpprv_bin2_pwr_enable_b_out

    ,input  logic                       rf_ll_schlst_tpprv_bin3_wclk
    ,input  logic                       rf_ll_schlst_tpprv_bin3_wclk_rst_n
    ,input  logic                       rf_ll_schlst_tpprv_bin3_we
    ,input  logic[ (  11 ) -1 : 0 ]     rf_ll_schlst_tpprv_bin3_waddr
    ,input  logic[ (  16 ) -1 : 0 ]     rf_ll_schlst_tpprv_bin3_wdata
    ,input  logic                       rf_ll_schlst_tpprv_bin3_rclk
    ,input  logic                       rf_ll_schlst_tpprv_bin3_rclk_rst_n
    ,input  logic                       rf_ll_schlst_tpprv_bin3_re
    ,input  logic[ (  11 ) -1 : 0 ]     rf_ll_schlst_tpprv_bin3_raddr
    ,output logic[ (  16 ) -1 : 0 ]     rf_ll_schlst_tpprv_bin3_rdata

    ,input  logic                       rf_ll_schlst_tpprv_bin3_isol_en
    ,input  logic                       rf_ll_schlst_tpprv_bin3_pwr_enable_b_in
    ,output logic                       rf_ll_schlst_tpprv_bin3_pwr_enable_b_out

    ,input  logic                       rf_ll_slst_cnt_wclk
    ,input  logic                       rf_ll_slst_cnt_wclk_rst_n
    ,input  logic                       rf_ll_slst_cnt_we
    ,input  logic[ (   9 ) -1 : 0 ]     rf_ll_slst_cnt_waddr
    ,input  logic[ (  60 ) -1 : 0 ]     rf_ll_slst_cnt_wdata
    ,input  logic                       rf_ll_slst_cnt_rclk
    ,input  logic                       rf_ll_slst_cnt_rclk_rst_n
    ,input  logic                       rf_ll_slst_cnt_re
    ,input  logic[ (   9 ) -1 : 0 ]     rf_ll_slst_cnt_raddr
    ,output logic[ (  60 ) -1 : 0 ]     rf_ll_slst_cnt_rdata

    ,input  logic                       rf_ll_slst_cnt_isol_en
    ,input  logic                       rf_ll_slst_cnt_pwr_enable_b_in
    ,output logic                       rf_ll_slst_cnt_pwr_enable_b_out

    ,input  logic                       rf_nalb_cmp_fifo_mem_wclk
    ,input  logic                       rf_nalb_cmp_fifo_mem_wclk_rst_n
    ,input  logic                       rf_nalb_cmp_fifo_mem_we
    ,input  logic[ (   3 ) -1 : 0 ]     rf_nalb_cmp_fifo_mem_waddr
    ,input  logic[ (  18 ) -1 : 0 ]     rf_nalb_cmp_fifo_mem_wdata
    ,input  logic                       rf_nalb_cmp_fifo_mem_rclk
    ,input  logic                       rf_nalb_cmp_fifo_mem_rclk_rst_n
    ,input  logic                       rf_nalb_cmp_fifo_mem_re
    ,input  logic[ (   3 ) -1 : 0 ]     rf_nalb_cmp_fifo_mem_raddr
    ,output logic[ (  18 ) -1 : 0 ]     rf_nalb_cmp_fifo_mem_rdata

    ,input  logic                       rf_nalb_cmp_fifo_mem_isol_en
    ,input  logic                       rf_nalb_cmp_fifo_mem_pwr_enable_b_in
    ,output logic                       rf_nalb_cmp_fifo_mem_pwr_enable_b_out

    ,input  logic                       rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_wclk
    ,input  logic                       rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_wclk_rst_n
    ,input  logic                       rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_we
    ,input  logic[ (   2 ) -1 : 0 ]     rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_waddr
    ,input  logic[ (  10 ) -1 : 0 ]     rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_wdata
    ,input  logic                       rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_rclk
    ,input  logic                       rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_rclk_rst_n
    ,input  logic                       rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_re
    ,input  logic[ (   2 ) -1 : 0 ]     rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_raddr
    ,output logic[ (  10 ) -1 : 0 ]     rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_rdata

    ,input  logic                       rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_isol_en
    ,input  logic                       rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_pwr_enable_b_in
    ,output logic                       rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_pwr_enable_b_out

    ,input  logic                       rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_wclk
    ,input  logic                       rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_wclk_rst_n
    ,input  logic                       rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_we
    ,input  logic[ (   2 ) -1 : 0 ]     rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_waddr
    ,input  logic[ (  27 ) -1 : 0 ]     rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_wdata
    ,input  logic                       rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_rclk
    ,input  logic                       rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_rclk_rst_n
    ,input  logic                       rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_re
    ,input  logic[ (   2 ) -1 : 0 ]     rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_raddr
    ,output logic[ (  27 ) -1 : 0 ]     rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_rdata

    ,input  logic                       rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_isol_en
    ,input  logic                       rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_pwr_enable_b_in
    ,output logic                       rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_pwr_enable_b_out

    ,input  logic                       rf_nalb_sel_nalb_fifo_mem_wclk
    ,input  logic                       rf_nalb_sel_nalb_fifo_mem_wclk_rst_n
    ,input  logic                       rf_nalb_sel_nalb_fifo_mem_we
    ,input  logic[ (   4 ) -1 : 0 ]     rf_nalb_sel_nalb_fifo_mem_waddr
    ,input  logic[ (  27 ) -1 : 0 ]     rf_nalb_sel_nalb_fifo_mem_wdata
    ,input  logic                       rf_nalb_sel_nalb_fifo_mem_rclk
    ,input  logic                       rf_nalb_sel_nalb_fifo_mem_rclk_rst_n
    ,input  logic                       rf_nalb_sel_nalb_fifo_mem_re
    ,input  logic[ (   4 ) -1 : 0 ]     rf_nalb_sel_nalb_fifo_mem_raddr
    ,output logic[ (  27 ) -1 : 0 ]     rf_nalb_sel_nalb_fifo_mem_rdata

    ,input  logic                       rf_nalb_sel_nalb_fifo_mem_isol_en
    ,input  logic                       rf_nalb_sel_nalb_fifo_mem_pwr_enable_b_in
    ,output logic                       rf_nalb_sel_nalb_fifo_mem_pwr_enable_b_out

    ,input  logic                       rf_qed_lsp_deq_fifo_mem_wclk
    ,input  logic                       rf_qed_lsp_deq_fifo_mem_wclk_rst_n
    ,input  logic                       rf_qed_lsp_deq_fifo_mem_we
    ,input  logic[ (   5 ) -1 : 0 ]     rf_qed_lsp_deq_fifo_mem_waddr
    ,input  logic[ (   9 ) -1 : 0 ]     rf_qed_lsp_deq_fifo_mem_wdata
    ,input  logic                       rf_qed_lsp_deq_fifo_mem_rclk
    ,input  logic                       rf_qed_lsp_deq_fifo_mem_rclk_rst_n
    ,input  logic                       rf_qed_lsp_deq_fifo_mem_re
    ,input  logic[ (   5 ) -1 : 0 ]     rf_qed_lsp_deq_fifo_mem_raddr
    ,output logic[ (   9 ) -1 : 0 ]     rf_qed_lsp_deq_fifo_mem_rdata

    ,input  logic                       rf_qed_lsp_deq_fifo_mem_isol_en
    ,input  logic                       rf_qed_lsp_deq_fifo_mem_pwr_enable_b_in
    ,output logic                       rf_qed_lsp_deq_fifo_mem_pwr_enable_b_out

    ,input  logic                       rf_qid_aqed_active_count_mem_wclk
    ,input  logic                       rf_qid_aqed_active_count_mem_wclk_rst_n
    ,input  logic                       rf_qid_aqed_active_count_mem_we
    ,input  logic[ (   5 ) -1 : 0 ]     rf_qid_aqed_active_count_mem_waddr
    ,input  logic[ (  14 ) -1 : 0 ]     rf_qid_aqed_active_count_mem_wdata
    ,input  logic                       rf_qid_aqed_active_count_mem_rclk
    ,input  logic                       rf_qid_aqed_active_count_mem_rclk_rst_n
    ,input  logic                       rf_qid_aqed_active_count_mem_re
    ,input  logic[ (   5 ) -1 : 0 ]     rf_qid_aqed_active_count_mem_raddr
    ,output logic[ (  14 ) -1 : 0 ]     rf_qid_aqed_active_count_mem_rdata

    ,input  logic                       rf_qid_aqed_active_count_mem_isol_en
    ,input  logic                       rf_qid_aqed_active_count_mem_pwr_enable_b_in
    ,output logic                       rf_qid_aqed_active_count_mem_pwr_enable_b_out

    ,input  logic                       rf_qid_atm_active_mem_wclk
    ,input  logic                       rf_qid_atm_active_mem_wclk_rst_n
    ,input  logic                       rf_qid_atm_active_mem_we
    ,input  logic[ (   5 ) -1 : 0 ]     rf_qid_atm_active_mem_waddr
    ,input  logic[ (  17 ) -1 : 0 ]     rf_qid_atm_active_mem_wdata
    ,input  logic                       rf_qid_atm_active_mem_rclk
    ,input  logic                       rf_qid_atm_active_mem_rclk_rst_n
    ,input  logic                       rf_qid_atm_active_mem_re
    ,input  logic[ (   5 ) -1 : 0 ]     rf_qid_atm_active_mem_raddr
    ,output logic[ (  17 ) -1 : 0 ]     rf_qid_atm_active_mem_rdata

    ,input  logic                       rf_qid_atm_active_mem_isol_en
    ,input  logic                       rf_qid_atm_active_mem_pwr_enable_b_in
    ,output logic                       rf_qid_atm_active_mem_pwr_enable_b_out

    ,input  logic                       rf_qid_atm_tot_enq_cnt_mem_wclk
    ,input  logic                       rf_qid_atm_tot_enq_cnt_mem_wclk_rst_n
    ,input  logic                       rf_qid_atm_tot_enq_cnt_mem_we
    ,input  logic[ (   5 ) -1 : 0 ]     rf_qid_atm_tot_enq_cnt_mem_waddr
    ,input  logic[ (  66 ) -1 : 0 ]     rf_qid_atm_tot_enq_cnt_mem_wdata
    ,input  logic                       rf_qid_atm_tot_enq_cnt_mem_rclk
    ,input  logic                       rf_qid_atm_tot_enq_cnt_mem_rclk_rst_n
    ,input  logic                       rf_qid_atm_tot_enq_cnt_mem_re
    ,input  logic[ (   5 ) -1 : 0 ]     rf_qid_atm_tot_enq_cnt_mem_raddr
    ,output logic[ (  66 ) -1 : 0 ]     rf_qid_atm_tot_enq_cnt_mem_rdata

    ,input  logic                       rf_qid_atm_tot_enq_cnt_mem_isol_en
    ,input  logic                       rf_qid_atm_tot_enq_cnt_mem_pwr_enable_b_in
    ,output logic                       rf_qid_atm_tot_enq_cnt_mem_pwr_enable_b_out

    ,input  logic                       rf_qid_atq_enqueue_count_mem_wclk
    ,input  logic                       rf_qid_atq_enqueue_count_mem_wclk_rst_n
    ,input  logic                       rf_qid_atq_enqueue_count_mem_we
    ,input  logic[ (   5 ) -1 : 0 ]     rf_qid_atq_enqueue_count_mem_waddr
    ,input  logic[ (  17 ) -1 : 0 ]     rf_qid_atq_enqueue_count_mem_wdata
    ,input  logic                       rf_qid_atq_enqueue_count_mem_rclk
    ,input  logic                       rf_qid_atq_enqueue_count_mem_rclk_rst_n
    ,input  logic                       rf_qid_atq_enqueue_count_mem_re
    ,input  logic[ (   5 ) -1 : 0 ]     rf_qid_atq_enqueue_count_mem_raddr
    ,output logic[ (  17 ) -1 : 0 ]     rf_qid_atq_enqueue_count_mem_rdata

    ,input  logic                       rf_qid_atq_enqueue_count_mem_isol_en
    ,input  logic                       rf_qid_atq_enqueue_count_mem_pwr_enable_b_in
    ,output logic                       rf_qid_atq_enqueue_count_mem_pwr_enable_b_out

    ,input  logic                       rf_qid_dir_max_depth_mem_wclk
    ,input  logic                       rf_qid_dir_max_depth_mem_wclk_rst_n
    ,input  logic                       rf_qid_dir_max_depth_mem_we
    ,input  logic[ (   6 ) -1 : 0 ]     rf_qid_dir_max_depth_mem_waddr
    ,input  logic[ (  15 ) -1 : 0 ]     rf_qid_dir_max_depth_mem_wdata
    ,input  logic                       rf_qid_dir_max_depth_mem_rclk
    ,input  logic                       rf_qid_dir_max_depth_mem_rclk_rst_n
    ,input  logic                       rf_qid_dir_max_depth_mem_re
    ,input  logic[ (   6 ) -1 : 0 ]     rf_qid_dir_max_depth_mem_raddr
    ,output logic[ (  15 ) -1 : 0 ]     rf_qid_dir_max_depth_mem_rdata

    ,input  logic                       rf_qid_dir_max_depth_mem_isol_en
    ,input  logic                       rf_qid_dir_max_depth_mem_pwr_enable_b_in
    ,output logic                       rf_qid_dir_max_depth_mem_pwr_enable_b_out

    ,input  logic                       rf_qid_dir_replay_count_mem_wclk
    ,input  logic                       rf_qid_dir_replay_count_mem_wclk_rst_n
    ,input  logic                       rf_qid_dir_replay_count_mem_we
    ,input  logic[ (   5 ) -1 : 0 ]     rf_qid_dir_replay_count_mem_waddr
    ,input  logic[ (  17 ) -1 : 0 ]     rf_qid_dir_replay_count_mem_wdata
    ,input  logic                       rf_qid_dir_replay_count_mem_rclk
    ,input  logic                       rf_qid_dir_replay_count_mem_rclk_rst_n
    ,input  logic                       rf_qid_dir_replay_count_mem_re
    ,input  logic[ (   5 ) -1 : 0 ]     rf_qid_dir_replay_count_mem_raddr
    ,output logic[ (  17 ) -1 : 0 ]     rf_qid_dir_replay_count_mem_rdata

    ,input  logic                       rf_qid_dir_replay_count_mem_isol_en
    ,input  logic                       rf_qid_dir_replay_count_mem_pwr_enable_b_in
    ,output logic                       rf_qid_dir_replay_count_mem_pwr_enable_b_out

    ,input  logic                       rf_qid_dir_tot_enq_cnt_mem_wclk
    ,input  logic                       rf_qid_dir_tot_enq_cnt_mem_wclk_rst_n
    ,input  logic                       rf_qid_dir_tot_enq_cnt_mem_we
    ,input  logic[ (   6 ) -1 : 0 ]     rf_qid_dir_tot_enq_cnt_mem_waddr
    ,input  logic[ (  66 ) -1 : 0 ]     rf_qid_dir_tot_enq_cnt_mem_wdata
    ,input  logic                       rf_qid_dir_tot_enq_cnt_mem_rclk
    ,input  logic                       rf_qid_dir_tot_enq_cnt_mem_rclk_rst_n
    ,input  logic                       rf_qid_dir_tot_enq_cnt_mem_re
    ,input  logic[ (   6 ) -1 : 0 ]     rf_qid_dir_tot_enq_cnt_mem_raddr
    ,output logic[ (  66 ) -1 : 0 ]     rf_qid_dir_tot_enq_cnt_mem_rdata

    ,input  logic                       rf_qid_dir_tot_enq_cnt_mem_isol_en
    ,input  logic                       rf_qid_dir_tot_enq_cnt_mem_pwr_enable_b_in
    ,output logic                       rf_qid_dir_tot_enq_cnt_mem_pwr_enable_b_out

    ,input  logic                       rf_qid_ldb_enqueue_count_mem_wclk
    ,input  logic                       rf_qid_ldb_enqueue_count_mem_wclk_rst_n
    ,input  logic                       rf_qid_ldb_enqueue_count_mem_we
    ,input  logic[ (   5 ) -1 : 0 ]     rf_qid_ldb_enqueue_count_mem_waddr
    ,input  logic[ (  17 ) -1 : 0 ]     rf_qid_ldb_enqueue_count_mem_wdata
    ,input  logic                       rf_qid_ldb_enqueue_count_mem_rclk
    ,input  logic                       rf_qid_ldb_enqueue_count_mem_rclk_rst_n
    ,input  logic                       rf_qid_ldb_enqueue_count_mem_re
    ,input  logic[ (   5 ) -1 : 0 ]     rf_qid_ldb_enqueue_count_mem_raddr
    ,output logic[ (  17 ) -1 : 0 ]     rf_qid_ldb_enqueue_count_mem_rdata

    ,input  logic                       rf_qid_ldb_enqueue_count_mem_isol_en
    ,input  logic                       rf_qid_ldb_enqueue_count_mem_pwr_enable_b_in
    ,output logic                       rf_qid_ldb_enqueue_count_mem_pwr_enable_b_out

    ,input  logic                       rf_qid_ldb_inflight_count_mem_wclk
    ,input  logic                       rf_qid_ldb_inflight_count_mem_wclk_rst_n
    ,input  logic                       rf_qid_ldb_inflight_count_mem_we
    ,input  logic[ (   5 ) -1 : 0 ]     rf_qid_ldb_inflight_count_mem_waddr
    ,input  logic[ (  14 ) -1 : 0 ]     rf_qid_ldb_inflight_count_mem_wdata
    ,input  logic                       rf_qid_ldb_inflight_count_mem_rclk
    ,input  logic                       rf_qid_ldb_inflight_count_mem_rclk_rst_n
    ,input  logic                       rf_qid_ldb_inflight_count_mem_re
    ,input  logic[ (   5 ) -1 : 0 ]     rf_qid_ldb_inflight_count_mem_raddr
    ,output logic[ (  14 ) -1 : 0 ]     rf_qid_ldb_inflight_count_mem_rdata

    ,input  logic                       rf_qid_ldb_inflight_count_mem_isol_en
    ,input  logic                       rf_qid_ldb_inflight_count_mem_pwr_enable_b_in
    ,output logic                       rf_qid_ldb_inflight_count_mem_pwr_enable_b_out

    ,input  logic                       rf_qid_ldb_replay_count_mem_wclk
    ,input  logic                       rf_qid_ldb_replay_count_mem_wclk_rst_n
    ,input  logic                       rf_qid_ldb_replay_count_mem_we
    ,input  logic[ (   5 ) -1 : 0 ]     rf_qid_ldb_replay_count_mem_waddr
    ,input  logic[ (  17 ) -1 : 0 ]     rf_qid_ldb_replay_count_mem_wdata
    ,input  logic                       rf_qid_ldb_replay_count_mem_rclk
    ,input  logic                       rf_qid_ldb_replay_count_mem_rclk_rst_n
    ,input  logic                       rf_qid_ldb_replay_count_mem_re
    ,input  logic[ (   5 ) -1 : 0 ]     rf_qid_ldb_replay_count_mem_raddr
    ,output logic[ (  17 ) -1 : 0 ]     rf_qid_ldb_replay_count_mem_rdata

    ,input  logic                       rf_qid_ldb_replay_count_mem_isol_en
    ,input  logic                       rf_qid_ldb_replay_count_mem_pwr_enable_b_in
    ,output logic                       rf_qid_ldb_replay_count_mem_pwr_enable_b_out

    ,input  logic                       rf_qid_naldb_max_depth_mem_wclk
    ,input  logic                       rf_qid_naldb_max_depth_mem_wclk_rst_n
    ,input  logic                       rf_qid_naldb_max_depth_mem_we
    ,input  logic[ (   5 ) -1 : 0 ]     rf_qid_naldb_max_depth_mem_waddr
    ,input  logic[ (  15 ) -1 : 0 ]     rf_qid_naldb_max_depth_mem_wdata
    ,input  logic                       rf_qid_naldb_max_depth_mem_rclk
    ,input  logic                       rf_qid_naldb_max_depth_mem_rclk_rst_n
    ,input  logic                       rf_qid_naldb_max_depth_mem_re
    ,input  logic[ (   5 ) -1 : 0 ]     rf_qid_naldb_max_depth_mem_raddr
    ,output logic[ (  15 ) -1 : 0 ]     rf_qid_naldb_max_depth_mem_rdata

    ,input  logic                       rf_qid_naldb_max_depth_mem_isol_en
    ,input  logic                       rf_qid_naldb_max_depth_mem_pwr_enable_b_in
    ,output logic                       rf_qid_naldb_max_depth_mem_pwr_enable_b_out

    ,input  logic                       rf_qid_naldb_tot_enq_cnt_mem_wclk
    ,input  logic                       rf_qid_naldb_tot_enq_cnt_mem_wclk_rst_n
    ,input  logic                       rf_qid_naldb_tot_enq_cnt_mem_we
    ,input  logic[ (   5 ) -1 : 0 ]     rf_qid_naldb_tot_enq_cnt_mem_waddr
    ,input  logic[ (  66 ) -1 : 0 ]     rf_qid_naldb_tot_enq_cnt_mem_wdata
    ,input  logic                       rf_qid_naldb_tot_enq_cnt_mem_rclk
    ,input  logic                       rf_qid_naldb_tot_enq_cnt_mem_rclk_rst_n
    ,input  logic                       rf_qid_naldb_tot_enq_cnt_mem_re
    ,input  logic[ (   5 ) -1 : 0 ]     rf_qid_naldb_tot_enq_cnt_mem_raddr
    ,output logic[ (  66 ) -1 : 0 ]     rf_qid_naldb_tot_enq_cnt_mem_rdata

    ,input  logic                       rf_qid_naldb_tot_enq_cnt_mem_isol_en
    ,input  logic                       rf_qid_naldb_tot_enq_cnt_mem_pwr_enable_b_in
    ,output logic                       rf_qid_naldb_tot_enq_cnt_mem_pwr_enable_b_out

    ,input  logic                       rf_qid_rdylst_clamp_wclk
    ,input  logic                       rf_qid_rdylst_clamp_wclk_rst_n
    ,input  logic                       rf_qid_rdylst_clamp_we
    ,input  logic[ (   5 ) -1 : 0 ]     rf_qid_rdylst_clamp_waddr
    ,input  logic[ (   6 ) -1 : 0 ]     rf_qid_rdylst_clamp_wdata
    ,input  logic                       rf_qid_rdylst_clamp_rclk
    ,input  logic                       rf_qid_rdylst_clamp_rclk_rst_n
    ,input  logic                       rf_qid_rdylst_clamp_re
    ,input  logic[ (   5 ) -1 : 0 ]     rf_qid_rdylst_clamp_raddr
    ,output logic[ (   6 ) -1 : 0 ]     rf_qid_rdylst_clamp_rdata

    ,input  logic                       rf_qid_rdylst_clamp_isol_en
    ,input  logic                       rf_qid_rdylst_clamp_pwr_enable_b_in
    ,output logic                       rf_qid_rdylst_clamp_pwr_enable_b_out

    ,input  logic                       rf_rop_lsp_reordercmp_rx_sync_fifo_mem_wclk
    ,input  logic                       rf_rop_lsp_reordercmp_rx_sync_fifo_mem_wclk_rst_n
    ,input  logic                       rf_rop_lsp_reordercmp_rx_sync_fifo_mem_we
    ,input  logic[ (   3 ) -1 : 0 ]     rf_rop_lsp_reordercmp_rx_sync_fifo_mem_waddr
    ,input  logic[ (  17 ) -1 : 0 ]     rf_rop_lsp_reordercmp_rx_sync_fifo_mem_wdata
    ,input  logic                       rf_rop_lsp_reordercmp_rx_sync_fifo_mem_rclk
    ,input  logic                       rf_rop_lsp_reordercmp_rx_sync_fifo_mem_rclk_rst_n
    ,input  logic                       rf_rop_lsp_reordercmp_rx_sync_fifo_mem_re
    ,input  logic[ (   3 ) -1 : 0 ]     rf_rop_lsp_reordercmp_rx_sync_fifo_mem_raddr
    ,output logic[ (  17 ) -1 : 0 ]     rf_rop_lsp_reordercmp_rx_sync_fifo_mem_rdata

    ,input  logic                       rf_rop_lsp_reordercmp_rx_sync_fifo_mem_isol_en
    ,input  logic                       rf_rop_lsp_reordercmp_rx_sync_fifo_mem_pwr_enable_b_in
    ,output logic                       rf_rop_lsp_reordercmp_rx_sync_fifo_mem_pwr_enable_b_out

    ,input  logic                       rf_rx_sync_qed_aqed_enq_wclk
    ,input  logic                       rf_rx_sync_qed_aqed_enq_wclk_rst_n
    ,input  logic                       rf_rx_sync_qed_aqed_enq_we
    ,input  logic[ (   2 ) -1 : 0 ]     rf_rx_sync_qed_aqed_enq_waddr
    ,input  logic[ ( 139 ) -1 : 0 ]     rf_rx_sync_qed_aqed_enq_wdata
    ,input  logic                       rf_rx_sync_qed_aqed_enq_rclk
    ,input  logic                       rf_rx_sync_qed_aqed_enq_rclk_rst_n
    ,input  logic                       rf_rx_sync_qed_aqed_enq_re
    ,input  logic[ (   2 ) -1 : 0 ]     rf_rx_sync_qed_aqed_enq_raddr
    ,output logic[ ( 139 ) -1 : 0 ]     rf_rx_sync_qed_aqed_enq_rdata

    ,input  logic                       rf_rx_sync_qed_aqed_enq_isol_en
    ,input  logic                       rf_rx_sync_qed_aqed_enq_pwr_enable_b_in
    ,output logic                       rf_rx_sync_qed_aqed_enq_pwr_enable_b_out

    ,input  logic                       rf_send_atm_to_cq_rx_sync_fifo_mem_wclk
    ,input  logic                       rf_send_atm_to_cq_rx_sync_fifo_mem_wclk_rst_n
    ,input  logic                       rf_send_atm_to_cq_rx_sync_fifo_mem_we
    ,input  logic[ (   2 ) -1 : 0 ]     rf_send_atm_to_cq_rx_sync_fifo_mem_waddr
    ,input  logic[ (  35 ) -1 : 0 ]     rf_send_atm_to_cq_rx_sync_fifo_mem_wdata
    ,input  logic                       rf_send_atm_to_cq_rx_sync_fifo_mem_rclk
    ,input  logic                       rf_send_atm_to_cq_rx_sync_fifo_mem_rclk_rst_n
    ,input  logic                       rf_send_atm_to_cq_rx_sync_fifo_mem_re
    ,input  logic[ (   2 ) -1 : 0 ]     rf_send_atm_to_cq_rx_sync_fifo_mem_raddr
    ,output logic[ (  35 ) -1 : 0 ]     rf_send_atm_to_cq_rx_sync_fifo_mem_rdata

    ,input  logic                       rf_send_atm_to_cq_rx_sync_fifo_mem_isol_en
    ,input  logic                       rf_send_atm_to_cq_rx_sync_fifo_mem_pwr_enable_b_in
    ,output logic                       rf_send_atm_to_cq_rx_sync_fifo_mem_pwr_enable_b_out

    ,input  logic                       rf_uno_atm_cmp_fifo_mem_wclk
    ,input  logic                       rf_uno_atm_cmp_fifo_mem_wclk_rst_n
    ,input  logic                       rf_uno_atm_cmp_fifo_mem_we
    ,input  logic[ (   3 ) -1 : 0 ]     rf_uno_atm_cmp_fifo_mem_waddr
    ,input  logic[ (  20 ) -1 : 0 ]     rf_uno_atm_cmp_fifo_mem_wdata
    ,input  logic                       rf_uno_atm_cmp_fifo_mem_rclk
    ,input  logic                       rf_uno_atm_cmp_fifo_mem_rclk_rst_n
    ,input  logic                       rf_uno_atm_cmp_fifo_mem_re
    ,input  logic[ (   3 ) -1 : 0 ]     rf_uno_atm_cmp_fifo_mem_raddr
    ,output logic[ (  20 ) -1 : 0 ]     rf_uno_atm_cmp_fifo_mem_rdata

    ,input  logic                       rf_uno_atm_cmp_fifo_mem_isol_en
    ,input  logic                       rf_uno_atm_cmp_fifo_mem_pwr_enable_b_in
    ,output logic                       rf_uno_atm_cmp_fifo_mem_pwr_enable_b_out

    ,input  logic                       sr_aqed_clk
    ,input  logic                       sr_aqed_clk_rst_n
    ,input  logic[ (  11 ) -1 : 0 ]     sr_aqed_addr
    ,input  logic                       sr_aqed_we
    ,input  logic[ ( 139 ) -1 : 0 ]     sr_aqed_wdata
    ,input  logic                       sr_aqed_re
    ,output logic[ ( 139 ) -1 : 0 ]     sr_aqed_rdata

    ,input  logic                       sr_aqed_isol_en
    ,input  logic                       sr_aqed_pwr_enable_b_in
    ,output logic                       sr_aqed_pwr_enable_b_out

    ,input  logic                       sr_aqed_freelist_clk
    ,input  logic                       sr_aqed_freelist_clk_rst_n
    ,input  logic[ (  11 ) -1 : 0 ]     sr_aqed_freelist_addr
    ,input  logic                       sr_aqed_freelist_we
    ,input  logic[ (  16 ) -1 : 0 ]     sr_aqed_freelist_wdata
    ,input  logic                       sr_aqed_freelist_re
    ,output logic[ (  16 ) -1 : 0 ]     sr_aqed_freelist_rdata

    ,input  logic                       sr_aqed_freelist_isol_en
    ,input  logic                       sr_aqed_freelist_pwr_enable_b_in
    ,output logic                       sr_aqed_freelist_pwr_enable_b_out

    ,input  logic                       sr_aqed_ll_qe_hpnxt_clk
    ,input  logic                       sr_aqed_ll_qe_hpnxt_clk_rst_n
    ,input  logic[ (  11 ) -1 : 0 ]     sr_aqed_ll_qe_hpnxt_addr
    ,input  logic                       sr_aqed_ll_qe_hpnxt_we
    ,input  logic[ (  16 ) -1 : 0 ]     sr_aqed_ll_qe_hpnxt_wdata
    ,input  logic                       sr_aqed_ll_qe_hpnxt_re
    ,output logic[ (  16 ) -1 : 0 ]     sr_aqed_ll_qe_hpnxt_rdata

    ,input  logic                       sr_aqed_ll_qe_hpnxt_isol_en
    ,input  logic                       sr_aqed_ll_qe_hpnxt_pwr_enable_b_in
    ,output logic                       sr_aqed_ll_qe_hpnxt_pwr_enable_b_out

    ,input  logic                       hqm_pwrgood_rst_b

    ,input  logic                       powergood_rst_b

    ,input  logic                       fscan_byprst_b
    ,input  logic                       fscan_clkungate
    ,input  logic                       fscan_rstbypen
);


endmodule


