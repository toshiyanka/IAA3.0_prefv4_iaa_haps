module hqm_qed_mem (

     input  logic                       rf_atq_cnt_wclk
    ,input  logic                       rf_atq_cnt_wclk_rst_n
    ,input  logic                       rf_atq_cnt_we
    ,input  logic[ (   5 ) -1 : 0 ]     rf_atq_cnt_waddr
    ,input  logic[ (  68 ) -1 : 0 ]     rf_atq_cnt_wdata
    ,input  logic                       rf_atq_cnt_rclk
    ,input  logic                       rf_atq_cnt_rclk_rst_n
    ,input  logic                       rf_atq_cnt_re
    ,input  logic[ (   5 ) -1 : 0 ]     rf_atq_cnt_raddr
    ,output logic[ (  68 ) -1 : 0 ]     rf_atq_cnt_rdata

    ,input  logic                       rf_atq_cnt_isol_en
    ,input  logic                       rf_atq_cnt_pwr_enable_b_in
    ,output logic                       rf_atq_cnt_pwr_enable_b_out

    ,input  logic                       rf_atq_hp_wclk
    ,input  logic                       rf_atq_hp_wclk_rst_n
    ,input  logic                       rf_atq_hp_we
    ,input  logic[ (   7 ) -1 : 0 ]     rf_atq_hp_waddr
    ,input  logic[ (  15 ) -1 : 0 ]     rf_atq_hp_wdata
    ,input  logic                       rf_atq_hp_rclk
    ,input  logic                       rf_atq_hp_rclk_rst_n
    ,input  logic                       rf_atq_hp_re
    ,input  logic[ (   7 ) -1 : 0 ]     rf_atq_hp_raddr
    ,output logic[ (  15 ) -1 : 0 ]     rf_atq_hp_rdata

    ,input  logic                       rf_atq_hp_isol_en
    ,input  logic                       rf_atq_hp_pwr_enable_b_in
    ,output logic                       rf_atq_hp_pwr_enable_b_out

    ,input  logic                       rf_atq_tp_wclk
    ,input  logic                       rf_atq_tp_wclk_rst_n
    ,input  logic                       rf_atq_tp_we
    ,input  logic[ (   7 ) -1 : 0 ]     rf_atq_tp_waddr
    ,input  logic[ (  15 ) -1 : 0 ]     rf_atq_tp_wdata
    ,input  logic                       rf_atq_tp_rclk
    ,input  logic                       rf_atq_tp_rclk_rst_n
    ,input  logic                       rf_atq_tp_re
    ,input  logic[ (   7 ) -1 : 0 ]     rf_atq_tp_raddr
    ,output logic[ (  15 ) -1 : 0 ]     rf_atq_tp_rdata

    ,input  logic                       rf_atq_tp_isol_en
    ,input  logic                       rf_atq_tp_pwr_enable_b_in
    ,output logic                       rf_atq_tp_pwr_enable_b_out

    ,input  logic                       rf_dir_cnt_wclk
    ,input  logic                       rf_dir_cnt_wclk_rst_n
    ,input  logic                       rf_dir_cnt_we
    ,input  logic[ (   6 ) -1 : 0 ]     rf_dir_cnt_waddr
    ,input  logic[ (  68 ) -1 : 0 ]     rf_dir_cnt_wdata
    ,input  logic                       rf_dir_cnt_rclk
    ,input  logic                       rf_dir_cnt_rclk_rst_n
    ,input  logic                       rf_dir_cnt_re
    ,input  logic[ (   6 ) -1 : 0 ]     rf_dir_cnt_raddr
    ,output logic[ (  68 ) -1 : 0 ]     rf_dir_cnt_rdata

    ,input  logic                       rf_dir_cnt_isol_en
    ,input  logic                       rf_dir_cnt_pwr_enable_b_in
    ,output logic                       rf_dir_cnt_pwr_enable_b_out

    ,input  logic                       rf_dir_hp_wclk
    ,input  logic                       rf_dir_hp_wclk_rst_n
    ,input  logic                       rf_dir_hp_we
    ,input  logic[ (   8 ) -1 : 0 ]     rf_dir_hp_waddr
    ,input  logic[ (  15 ) -1 : 0 ]     rf_dir_hp_wdata
    ,input  logic                       rf_dir_hp_rclk
    ,input  logic                       rf_dir_hp_rclk_rst_n
    ,input  logic                       rf_dir_hp_re
    ,input  logic[ (   8 ) -1 : 0 ]     rf_dir_hp_raddr
    ,output logic[ (  15 ) -1 : 0 ]     rf_dir_hp_rdata

    ,input  logic                       rf_dir_hp_isol_en
    ,input  logic                       rf_dir_hp_pwr_enable_b_in
    ,output logic                       rf_dir_hp_pwr_enable_b_out

    ,input  logic                       rf_dir_replay_cnt_wclk
    ,input  logic                       rf_dir_replay_cnt_wclk_rst_n
    ,input  logic                       rf_dir_replay_cnt_we
    ,input  logic[ (   5 ) -1 : 0 ]     rf_dir_replay_cnt_waddr
    ,input  logic[ (  68 ) -1 : 0 ]     rf_dir_replay_cnt_wdata
    ,input  logic                       rf_dir_replay_cnt_rclk
    ,input  logic                       rf_dir_replay_cnt_rclk_rst_n
    ,input  logic                       rf_dir_replay_cnt_re
    ,input  logic[ (   5 ) -1 : 0 ]     rf_dir_replay_cnt_raddr
    ,output logic[ (  68 ) -1 : 0 ]     rf_dir_replay_cnt_rdata

    ,input  logic                       rf_dir_replay_cnt_isol_en
    ,input  logic                       rf_dir_replay_cnt_pwr_enable_b_in
    ,output logic                       rf_dir_replay_cnt_pwr_enable_b_out

    ,input  logic                       rf_dir_replay_hp_wclk
    ,input  logic                       rf_dir_replay_hp_wclk_rst_n
    ,input  logic                       rf_dir_replay_hp_we
    ,input  logic[ (   7 ) -1 : 0 ]     rf_dir_replay_hp_waddr
    ,input  logic[ (  15 ) -1 : 0 ]     rf_dir_replay_hp_wdata
    ,input  logic                       rf_dir_replay_hp_rclk
    ,input  logic                       rf_dir_replay_hp_rclk_rst_n
    ,input  logic                       rf_dir_replay_hp_re
    ,input  logic[ (   7 ) -1 : 0 ]     rf_dir_replay_hp_raddr
    ,output logic[ (  15 ) -1 : 0 ]     rf_dir_replay_hp_rdata

    ,input  logic                       rf_dir_replay_hp_isol_en
    ,input  logic                       rf_dir_replay_hp_pwr_enable_b_in
    ,output logic                       rf_dir_replay_hp_pwr_enable_b_out

    ,input  logic                       rf_dir_replay_tp_wclk
    ,input  logic                       rf_dir_replay_tp_wclk_rst_n
    ,input  logic                       rf_dir_replay_tp_we
    ,input  logic[ (   7 ) -1 : 0 ]     rf_dir_replay_tp_waddr
    ,input  logic[ (  15 ) -1 : 0 ]     rf_dir_replay_tp_wdata
    ,input  logic                       rf_dir_replay_tp_rclk
    ,input  logic                       rf_dir_replay_tp_rclk_rst_n
    ,input  logic                       rf_dir_replay_tp_re
    ,input  logic[ (   7 ) -1 : 0 ]     rf_dir_replay_tp_raddr
    ,output logic[ (  15 ) -1 : 0 ]     rf_dir_replay_tp_rdata

    ,input  logic                       rf_dir_replay_tp_isol_en
    ,input  logic                       rf_dir_replay_tp_pwr_enable_b_in
    ,output logic                       rf_dir_replay_tp_pwr_enable_b_out

    ,input  logic                       rf_dir_rofrag_cnt_wclk
    ,input  logic                       rf_dir_rofrag_cnt_wclk_rst_n
    ,input  logic                       rf_dir_rofrag_cnt_we
    ,input  logic[ (   9 ) -1 : 0 ]     rf_dir_rofrag_cnt_waddr
    ,input  logic[ (  17 ) -1 : 0 ]     rf_dir_rofrag_cnt_wdata
    ,input  logic                       rf_dir_rofrag_cnt_rclk
    ,input  logic                       rf_dir_rofrag_cnt_rclk_rst_n
    ,input  logic                       rf_dir_rofrag_cnt_re
    ,input  logic[ (   9 ) -1 : 0 ]     rf_dir_rofrag_cnt_raddr
    ,output logic[ (  17 ) -1 : 0 ]     rf_dir_rofrag_cnt_rdata

    ,input  logic                       rf_dir_rofrag_cnt_isol_en
    ,input  logic                       rf_dir_rofrag_cnt_pwr_enable_b_in
    ,output logic                       rf_dir_rofrag_cnt_pwr_enable_b_out

    ,input  logic                       rf_dir_rofrag_hp_wclk
    ,input  logic                       rf_dir_rofrag_hp_wclk_rst_n
    ,input  logic                       rf_dir_rofrag_hp_we
    ,input  logic[ (   9 ) -1 : 0 ]     rf_dir_rofrag_hp_waddr
    ,input  logic[ (  15 ) -1 : 0 ]     rf_dir_rofrag_hp_wdata
    ,input  logic                       rf_dir_rofrag_hp_rclk
    ,input  logic                       rf_dir_rofrag_hp_rclk_rst_n
    ,input  logic                       rf_dir_rofrag_hp_re
    ,input  logic[ (   9 ) -1 : 0 ]     rf_dir_rofrag_hp_raddr
    ,output logic[ (  15 ) -1 : 0 ]     rf_dir_rofrag_hp_rdata

    ,input  logic                       rf_dir_rofrag_hp_isol_en
    ,input  logic                       rf_dir_rofrag_hp_pwr_enable_b_in
    ,output logic                       rf_dir_rofrag_hp_pwr_enable_b_out

    ,input  logic                       rf_dir_rofrag_tp_wclk
    ,input  logic                       rf_dir_rofrag_tp_wclk_rst_n
    ,input  logic                       rf_dir_rofrag_tp_we
    ,input  logic[ (   9 ) -1 : 0 ]     rf_dir_rofrag_tp_waddr
    ,input  logic[ (  15 ) -1 : 0 ]     rf_dir_rofrag_tp_wdata
    ,input  logic                       rf_dir_rofrag_tp_rclk
    ,input  logic                       rf_dir_rofrag_tp_rclk_rst_n
    ,input  logic                       rf_dir_rofrag_tp_re
    ,input  logic[ (   9 ) -1 : 0 ]     rf_dir_rofrag_tp_raddr
    ,output logic[ (  15 ) -1 : 0 ]     rf_dir_rofrag_tp_rdata

    ,input  logic                       rf_dir_rofrag_tp_isol_en
    ,input  logic                       rf_dir_rofrag_tp_pwr_enable_b_in
    ,output logic                       rf_dir_rofrag_tp_pwr_enable_b_out

    ,input  logic                       rf_dir_tp_wclk
    ,input  logic                       rf_dir_tp_wclk_rst_n
    ,input  logic                       rf_dir_tp_we
    ,input  logic[ (   8 ) -1 : 0 ]     rf_dir_tp_waddr
    ,input  logic[ (  15 ) -1 : 0 ]     rf_dir_tp_wdata
    ,input  logic                       rf_dir_tp_rclk
    ,input  logic                       rf_dir_tp_rclk_rst_n
    ,input  logic                       rf_dir_tp_re
    ,input  logic[ (   8 ) -1 : 0 ]     rf_dir_tp_raddr
    ,output logic[ (  15 ) -1 : 0 ]     rf_dir_tp_rdata

    ,input  logic                       rf_dir_tp_isol_en
    ,input  logic                       rf_dir_tp_pwr_enable_b_in
    ,output logic                       rf_dir_tp_pwr_enable_b_out

    ,input  logic                       rf_dp_dqed_wclk
    ,input  logic                       rf_dp_dqed_wclk_rst_n
    ,input  logic                       rf_dp_dqed_we
    ,input  logic[ (   5 ) -1 : 0 ]     rf_dp_dqed_waddr
    ,input  logic[ (  45 ) -1 : 0 ]     rf_dp_dqed_wdata
    ,input  logic                       rf_dp_dqed_rclk
    ,input  logic                       rf_dp_dqed_rclk_rst_n
    ,input  logic                       rf_dp_dqed_re
    ,input  logic[ (   5 ) -1 : 0 ]     rf_dp_dqed_raddr
    ,output logic[ (  45 ) -1 : 0 ]     rf_dp_dqed_rdata

    ,input  logic                       rf_dp_dqed_isol_en
    ,input  logic                       rf_dp_dqed_pwr_enable_b_in
    ,output logic                       rf_dp_dqed_pwr_enable_b_out

    ,input  logic                       rf_dp_lsp_enq_dir_wclk
    ,input  logic                       rf_dp_lsp_enq_dir_wclk_rst_n
    ,input  logic                       rf_dp_lsp_enq_dir_we
    ,input  logic[ (   4 ) -1 : 0 ]     rf_dp_lsp_enq_dir_waddr
    ,input  logic[ (   8 ) -1 : 0 ]     rf_dp_lsp_enq_dir_wdata
    ,input  logic                       rf_dp_lsp_enq_dir_rclk
    ,input  logic                       rf_dp_lsp_enq_dir_rclk_rst_n
    ,input  logic                       rf_dp_lsp_enq_dir_re
    ,input  logic[ (   4 ) -1 : 0 ]     rf_dp_lsp_enq_dir_raddr
    ,output logic[ (   8 ) -1 : 0 ]     rf_dp_lsp_enq_dir_rdata

    ,input  logic                       rf_dp_lsp_enq_dir_isol_en
    ,input  logic                       rf_dp_lsp_enq_dir_pwr_enable_b_in
    ,output logic                       rf_dp_lsp_enq_dir_pwr_enable_b_out

    ,input  logic                       rf_dp_lsp_enq_rorply_wclk
    ,input  logic                       rf_dp_lsp_enq_rorply_wclk_rst_n
    ,input  logic                       rf_dp_lsp_enq_rorply_we
    ,input  logic[ (   4 ) -1 : 0 ]     rf_dp_lsp_enq_rorply_waddr
    ,input  logic[ (  23 ) -1 : 0 ]     rf_dp_lsp_enq_rorply_wdata
    ,input  logic                       rf_dp_lsp_enq_rorply_rclk
    ,input  logic                       rf_dp_lsp_enq_rorply_rclk_rst_n
    ,input  logic                       rf_dp_lsp_enq_rorply_re
    ,input  logic[ (   4 ) -1 : 0 ]     rf_dp_lsp_enq_rorply_raddr
    ,output logic[ (  23 ) -1 : 0 ]     rf_dp_lsp_enq_rorply_rdata

    ,input  logic                       rf_dp_lsp_enq_rorply_isol_en
    ,input  logic                       rf_dp_lsp_enq_rorply_pwr_enable_b_in
    ,output logic                       rf_dp_lsp_enq_rorply_pwr_enable_b_out

    ,input  logic                       rf_lsp_dp_sch_dir_wclk
    ,input  logic                       rf_lsp_dp_sch_dir_wclk_rst_n
    ,input  logic                       rf_lsp_dp_sch_dir_we
    ,input  logic[ (   2 ) -1 : 0 ]     rf_lsp_dp_sch_dir_waddr
    ,input  logic[ (  27 ) -1 : 0 ]     rf_lsp_dp_sch_dir_wdata
    ,input  logic                       rf_lsp_dp_sch_dir_rclk
    ,input  logic                       rf_lsp_dp_sch_dir_rclk_rst_n
    ,input  logic                       rf_lsp_dp_sch_dir_re
    ,input  logic[ (   2 ) -1 : 0 ]     rf_lsp_dp_sch_dir_raddr
    ,output logic[ (  27 ) -1 : 0 ]     rf_lsp_dp_sch_dir_rdata

    ,input  logic                       rf_lsp_dp_sch_dir_isol_en
    ,input  logic                       rf_lsp_dp_sch_dir_pwr_enable_b_in
    ,output logic                       rf_lsp_dp_sch_dir_pwr_enable_b_out

    ,input  logic                       rf_lsp_dp_sch_rorply_wclk
    ,input  logic                       rf_lsp_dp_sch_rorply_wclk_rst_n
    ,input  logic                       rf_lsp_dp_sch_rorply_we
    ,input  logic[ (   2 ) -1 : 0 ]     rf_lsp_dp_sch_rorply_waddr
    ,input  logic[ (   8 ) -1 : 0 ]     rf_lsp_dp_sch_rorply_wdata
    ,input  logic                       rf_lsp_dp_sch_rorply_rclk
    ,input  logic                       rf_lsp_dp_sch_rorply_rclk_rst_n
    ,input  logic                       rf_lsp_dp_sch_rorply_re
    ,input  logic[ (   2 ) -1 : 0 ]     rf_lsp_dp_sch_rorply_raddr
    ,output logic[ (   8 ) -1 : 0 ]     rf_lsp_dp_sch_rorply_rdata

    ,input  logic                       rf_lsp_dp_sch_rorply_isol_en
    ,input  logic                       rf_lsp_dp_sch_rorply_pwr_enable_b_in
    ,output logic                       rf_lsp_dp_sch_rorply_pwr_enable_b_out

    ,input  logic                       rf_lsp_nalb_sch_atq_wclk
    ,input  logic                       rf_lsp_nalb_sch_atq_wclk_rst_n
    ,input  logic                       rf_lsp_nalb_sch_atq_we
    ,input  logic[ (   5 ) -1 : 0 ]     rf_lsp_nalb_sch_atq_waddr
    ,input  logic[ (   8 ) -1 : 0 ]     rf_lsp_nalb_sch_atq_wdata
    ,input  logic                       rf_lsp_nalb_sch_atq_rclk
    ,input  logic                       rf_lsp_nalb_sch_atq_rclk_rst_n
    ,input  logic                       rf_lsp_nalb_sch_atq_re
    ,input  logic[ (   5 ) -1 : 0 ]     rf_lsp_nalb_sch_atq_raddr
    ,output logic[ (   8 ) -1 : 0 ]     rf_lsp_nalb_sch_atq_rdata

    ,input  logic                       rf_lsp_nalb_sch_atq_isol_en
    ,input  logic                       rf_lsp_nalb_sch_atq_pwr_enable_b_in
    ,output logic                       rf_lsp_nalb_sch_atq_pwr_enable_b_out

    ,input  logic                       rf_lsp_nalb_sch_rorply_wclk
    ,input  logic                       rf_lsp_nalb_sch_rorply_wclk_rst_n
    ,input  logic                       rf_lsp_nalb_sch_rorply_we
    ,input  logic[ (   2 ) -1 : 0 ]     rf_lsp_nalb_sch_rorply_waddr
    ,input  logic[ (   8 ) -1 : 0 ]     rf_lsp_nalb_sch_rorply_wdata
    ,input  logic                       rf_lsp_nalb_sch_rorply_rclk
    ,input  logic                       rf_lsp_nalb_sch_rorply_rclk_rst_n
    ,input  logic                       rf_lsp_nalb_sch_rorply_re
    ,input  logic[ (   2 ) -1 : 0 ]     rf_lsp_nalb_sch_rorply_raddr
    ,output logic[ (   8 ) -1 : 0 ]     rf_lsp_nalb_sch_rorply_rdata

    ,input  logic                       rf_lsp_nalb_sch_rorply_isol_en
    ,input  logic                       rf_lsp_nalb_sch_rorply_pwr_enable_b_in
    ,output logic                       rf_lsp_nalb_sch_rorply_pwr_enable_b_out

    ,input  logic                       rf_lsp_nalb_sch_unoord_wclk
    ,input  logic                       rf_lsp_nalb_sch_unoord_wclk_rst_n
    ,input  logic                       rf_lsp_nalb_sch_unoord_we
    ,input  logic[ (   2 ) -1 : 0 ]     rf_lsp_nalb_sch_unoord_waddr
    ,input  logic[ (  27 ) -1 : 0 ]     rf_lsp_nalb_sch_unoord_wdata
    ,input  logic                       rf_lsp_nalb_sch_unoord_rclk
    ,input  logic                       rf_lsp_nalb_sch_unoord_rclk_rst_n
    ,input  logic                       rf_lsp_nalb_sch_unoord_re
    ,input  logic[ (   2 ) -1 : 0 ]     rf_lsp_nalb_sch_unoord_raddr
    ,output logic[ (  27 ) -1 : 0 ]     rf_lsp_nalb_sch_unoord_rdata

    ,input  logic                       rf_lsp_nalb_sch_unoord_isol_en
    ,input  logic                       rf_lsp_nalb_sch_unoord_pwr_enable_b_in
    ,output logic                       rf_lsp_nalb_sch_unoord_pwr_enable_b_out

    ,input  logic                       rf_nalb_cnt_wclk
    ,input  logic                       rf_nalb_cnt_wclk_rst_n
    ,input  logic                       rf_nalb_cnt_we
    ,input  logic[ (   5 ) -1 : 0 ]     rf_nalb_cnt_waddr
    ,input  logic[ (  68 ) -1 : 0 ]     rf_nalb_cnt_wdata
    ,input  logic                       rf_nalb_cnt_rclk
    ,input  logic                       rf_nalb_cnt_rclk_rst_n
    ,input  logic                       rf_nalb_cnt_re
    ,input  logic[ (   5 ) -1 : 0 ]     rf_nalb_cnt_raddr
    ,output logic[ (  68 ) -1 : 0 ]     rf_nalb_cnt_rdata

    ,input  logic                       rf_nalb_cnt_isol_en
    ,input  logic                       rf_nalb_cnt_pwr_enable_b_in
    ,output logic                       rf_nalb_cnt_pwr_enable_b_out

    ,input  logic                       rf_nalb_hp_wclk
    ,input  logic                       rf_nalb_hp_wclk_rst_n
    ,input  logic                       rf_nalb_hp_we
    ,input  logic[ (   7 ) -1 : 0 ]     rf_nalb_hp_waddr
    ,input  logic[ (  15 ) -1 : 0 ]     rf_nalb_hp_wdata
    ,input  logic                       rf_nalb_hp_rclk
    ,input  logic                       rf_nalb_hp_rclk_rst_n
    ,input  logic                       rf_nalb_hp_re
    ,input  logic[ (   7 ) -1 : 0 ]     rf_nalb_hp_raddr
    ,output logic[ (  15 ) -1 : 0 ]     rf_nalb_hp_rdata

    ,input  logic                       rf_nalb_hp_isol_en
    ,input  logic                       rf_nalb_hp_pwr_enable_b_in
    ,output logic                       rf_nalb_hp_pwr_enable_b_out

    ,input  logic                       rf_nalb_lsp_enq_rorply_wclk
    ,input  logic                       rf_nalb_lsp_enq_rorply_wclk_rst_n
    ,input  logic                       rf_nalb_lsp_enq_rorply_we
    ,input  logic[ (   5 ) -1 : 0 ]     rf_nalb_lsp_enq_rorply_waddr
    ,input  logic[ (  27 ) -1 : 0 ]     rf_nalb_lsp_enq_rorply_wdata
    ,input  logic                       rf_nalb_lsp_enq_rorply_rclk
    ,input  logic                       rf_nalb_lsp_enq_rorply_rclk_rst_n
    ,input  logic                       rf_nalb_lsp_enq_rorply_re
    ,input  logic[ (   5 ) -1 : 0 ]     rf_nalb_lsp_enq_rorply_raddr
    ,output logic[ (  27 ) -1 : 0 ]     rf_nalb_lsp_enq_rorply_rdata

    ,input  logic                       rf_nalb_lsp_enq_rorply_isol_en
    ,input  logic                       rf_nalb_lsp_enq_rorply_pwr_enable_b_in
    ,output logic                       rf_nalb_lsp_enq_rorply_pwr_enable_b_out

    ,input  logic                       rf_nalb_lsp_enq_unoord_wclk
    ,input  logic                       rf_nalb_lsp_enq_unoord_wclk_rst_n
    ,input  logic                       rf_nalb_lsp_enq_unoord_we
    ,input  logic[ (   5 ) -1 : 0 ]     rf_nalb_lsp_enq_unoord_waddr
    ,input  logic[ (  10 ) -1 : 0 ]     rf_nalb_lsp_enq_unoord_wdata
    ,input  logic                       rf_nalb_lsp_enq_unoord_rclk
    ,input  logic                       rf_nalb_lsp_enq_unoord_rclk_rst_n
    ,input  logic                       rf_nalb_lsp_enq_unoord_re
    ,input  logic[ (   5 ) -1 : 0 ]     rf_nalb_lsp_enq_unoord_raddr
    ,output logic[ (  10 ) -1 : 0 ]     rf_nalb_lsp_enq_unoord_rdata

    ,input  logic                       rf_nalb_lsp_enq_unoord_isol_en
    ,input  logic                       rf_nalb_lsp_enq_unoord_pwr_enable_b_in
    ,output logic                       rf_nalb_lsp_enq_unoord_pwr_enable_b_out

    ,input  logic                       rf_nalb_qed_wclk
    ,input  logic                       rf_nalb_qed_wclk_rst_n
    ,input  logic                       rf_nalb_qed_we
    ,input  logic[ (   5 ) -1 : 0 ]     rf_nalb_qed_waddr
    ,input  logic[ (  45 ) -1 : 0 ]     rf_nalb_qed_wdata
    ,input  logic                       rf_nalb_qed_rclk
    ,input  logic                       rf_nalb_qed_rclk_rst_n
    ,input  logic                       rf_nalb_qed_re
    ,input  logic[ (   5 ) -1 : 0 ]     rf_nalb_qed_raddr
    ,output logic[ (  45 ) -1 : 0 ]     rf_nalb_qed_rdata

    ,input  logic                       rf_nalb_qed_isol_en
    ,input  logic                       rf_nalb_qed_pwr_enable_b_in
    ,output logic                       rf_nalb_qed_pwr_enable_b_out

    ,input  logic                       rf_nalb_replay_cnt_wclk
    ,input  logic                       rf_nalb_replay_cnt_wclk_rst_n
    ,input  logic                       rf_nalb_replay_cnt_we
    ,input  logic[ (   5 ) -1 : 0 ]     rf_nalb_replay_cnt_waddr
    ,input  logic[ (  68 ) -1 : 0 ]     rf_nalb_replay_cnt_wdata
    ,input  logic                       rf_nalb_replay_cnt_rclk
    ,input  logic                       rf_nalb_replay_cnt_rclk_rst_n
    ,input  logic                       rf_nalb_replay_cnt_re
    ,input  logic[ (   5 ) -1 : 0 ]     rf_nalb_replay_cnt_raddr
    ,output logic[ (  68 ) -1 : 0 ]     rf_nalb_replay_cnt_rdata

    ,input  logic                       rf_nalb_replay_cnt_isol_en
    ,input  logic                       rf_nalb_replay_cnt_pwr_enable_b_in
    ,output logic                       rf_nalb_replay_cnt_pwr_enable_b_out

    ,input  logic                       rf_nalb_replay_hp_wclk
    ,input  logic                       rf_nalb_replay_hp_wclk_rst_n
    ,input  logic                       rf_nalb_replay_hp_we
    ,input  logic[ (   7 ) -1 : 0 ]     rf_nalb_replay_hp_waddr
    ,input  logic[ (  15 ) -1 : 0 ]     rf_nalb_replay_hp_wdata
    ,input  logic                       rf_nalb_replay_hp_rclk
    ,input  logic                       rf_nalb_replay_hp_rclk_rst_n
    ,input  logic                       rf_nalb_replay_hp_re
    ,input  logic[ (   7 ) -1 : 0 ]     rf_nalb_replay_hp_raddr
    ,output logic[ (  15 ) -1 : 0 ]     rf_nalb_replay_hp_rdata

    ,input  logic                       rf_nalb_replay_hp_isol_en
    ,input  logic                       rf_nalb_replay_hp_pwr_enable_b_in
    ,output logic                       rf_nalb_replay_hp_pwr_enable_b_out

    ,input  logic                       rf_nalb_replay_tp_wclk
    ,input  logic                       rf_nalb_replay_tp_wclk_rst_n
    ,input  logic                       rf_nalb_replay_tp_we
    ,input  logic[ (   7 ) -1 : 0 ]     rf_nalb_replay_tp_waddr
    ,input  logic[ (  15 ) -1 : 0 ]     rf_nalb_replay_tp_wdata
    ,input  logic                       rf_nalb_replay_tp_rclk
    ,input  logic                       rf_nalb_replay_tp_rclk_rst_n
    ,input  logic                       rf_nalb_replay_tp_re
    ,input  logic[ (   7 ) -1 : 0 ]     rf_nalb_replay_tp_raddr
    ,output logic[ (  15 ) -1 : 0 ]     rf_nalb_replay_tp_rdata

    ,input  logic                       rf_nalb_replay_tp_isol_en
    ,input  logic                       rf_nalb_replay_tp_pwr_enable_b_in
    ,output logic                       rf_nalb_replay_tp_pwr_enable_b_out

    ,input  logic                       rf_nalb_rofrag_cnt_wclk
    ,input  logic                       rf_nalb_rofrag_cnt_wclk_rst_n
    ,input  logic                       rf_nalb_rofrag_cnt_we
    ,input  logic[ (   9 ) -1 : 0 ]     rf_nalb_rofrag_cnt_waddr
    ,input  logic[ (  17 ) -1 : 0 ]     rf_nalb_rofrag_cnt_wdata
    ,input  logic                       rf_nalb_rofrag_cnt_rclk
    ,input  logic                       rf_nalb_rofrag_cnt_rclk_rst_n
    ,input  logic                       rf_nalb_rofrag_cnt_re
    ,input  logic[ (   9 ) -1 : 0 ]     rf_nalb_rofrag_cnt_raddr
    ,output logic[ (  17 ) -1 : 0 ]     rf_nalb_rofrag_cnt_rdata

    ,input  logic                       rf_nalb_rofrag_cnt_isol_en
    ,input  logic                       rf_nalb_rofrag_cnt_pwr_enable_b_in
    ,output logic                       rf_nalb_rofrag_cnt_pwr_enable_b_out

    ,input  logic                       rf_nalb_rofrag_hp_wclk
    ,input  logic                       rf_nalb_rofrag_hp_wclk_rst_n
    ,input  logic                       rf_nalb_rofrag_hp_we
    ,input  logic[ (   9 ) -1 : 0 ]     rf_nalb_rofrag_hp_waddr
    ,input  logic[ (  15 ) -1 : 0 ]     rf_nalb_rofrag_hp_wdata
    ,input  logic                       rf_nalb_rofrag_hp_rclk
    ,input  logic                       rf_nalb_rofrag_hp_rclk_rst_n
    ,input  logic                       rf_nalb_rofrag_hp_re
    ,input  logic[ (   9 ) -1 : 0 ]     rf_nalb_rofrag_hp_raddr
    ,output logic[ (  15 ) -1 : 0 ]     rf_nalb_rofrag_hp_rdata

    ,input  logic                       rf_nalb_rofrag_hp_isol_en
    ,input  logic                       rf_nalb_rofrag_hp_pwr_enable_b_in
    ,output logic                       rf_nalb_rofrag_hp_pwr_enable_b_out

    ,input  logic                       rf_nalb_rofrag_tp_wclk
    ,input  logic                       rf_nalb_rofrag_tp_wclk_rst_n
    ,input  logic                       rf_nalb_rofrag_tp_we
    ,input  logic[ (   9 ) -1 : 0 ]     rf_nalb_rofrag_tp_waddr
    ,input  logic[ (  15 ) -1 : 0 ]     rf_nalb_rofrag_tp_wdata
    ,input  logic                       rf_nalb_rofrag_tp_rclk
    ,input  logic                       rf_nalb_rofrag_tp_rclk_rst_n
    ,input  logic                       rf_nalb_rofrag_tp_re
    ,input  logic[ (   9 ) -1 : 0 ]     rf_nalb_rofrag_tp_raddr
    ,output logic[ (  15 ) -1 : 0 ]     rf_nalb_rofrag_tp_rdata

    ,input  logic                       rf_nalb_rofrag_tp_isol_en
    ,input  logic                       rf_nalb_rofrag_tp_pwr_enable_b_in
    ,output logic                       rf_nalb_rofrag_tp_pwr_enable_b_out

    ,input  logic                       rf_nalb_tp_wclk
    ,input  logic                       rf_nalb_tp_wclk_rst_n
    ,input  logic                       rf_nalb_tp_we
    ,input  logic[ (   7 ) -1 : 0 ]     rf_nalb_tp_waddr
    ,input  logic[ (  15 ) -1 : 0 ]     rf_nalb_tp_wdata
    ,input  logic                       rf_nalb_tp_rclk
    ,input  logic                       rf_nalb_tp_rclk_rst_n
    ,input  logic                       rf_nalb_tp_re
    ,input  logic[ (   7 ) -1 : 0 ]     rf_nalb_tp_raddr
    ,output logic[ (  15 ) -1 : 0 ]     rf_nalb_tp_rdata

    ,input  logic                       rf_nalb_tp_isol_en
    ,input  logic                       rf_nalb_tp_pwr_enable_b_in
    ,output logic                       rf_nalb_tp_pwr_enable_b_out

    ,input  logic                       rf_qed_chp_sch_data_wclk
    ,input  logic                       rf_qed_chp_sch_data_wclk_rst_n
    ,input  logic                       rf_qed_chp_sch_data_we
    ,input  logic[ (   3 ) -1 : 0 ]     rf_qed_chp_sch_data_waddr
    ,input  logic[ ( 177 ) -1 : 0 ]     rf_qed_chp_sch_data_wdata
    ,input  logic                       rf_qed_chp_sch_data_rclk
    ,input  logic                       rf_qed_chp_sch_data_rclk_rst_n
    ,input  logic                       rf_qed_chp_sch_data_re
    ,input  logic[ (   3 ) -1 : 0 ]     rf_qed_chp_sch_data_raddr
    ,output logic[ ( 177 ) -1 : 0 ]     rf_qed_chp_sch_data_rdata

    ,input  logic                       rf_qed_chp_sch_data_isol_en
    ,input  logic                       rf_qed_chp_sch_data_pwr_enable_b_in
    ,output logic                       rf_qed_chp_sch_data_pwr_enable_b_out

    ,input  logic                       rf_rop_dp_enq_dir_wclk
    ,input  logic                       rf_rop_dp_enq_dir_wclk_rst_n
    ,input  logic                       rf_rop_dp_enq_dir_we
    ,input  logic[ (   2 ) -1 : 0 ]     rf_rop_dp_enq_dir_waddr
    ,input  logic[ ( 100 ) -1 : 0 ]     rf_rop_dp_enq_dir_wdata
    ,input  logic                       rf_rop_dp_enq_dir_rclk
    ,input  logic                       rf_rop_dp_enq_dir_rclk_rst_n
    ,input  logic                       rf_rop_dp_enq_dir_re
    ,input  logic[ (   2 ) -1 : 0 ]     rf_rop_dp_enq_dir_raddr
    ,output logic[ ( 100 ) -1 : 0 ]     rf_rop_dp_enq_dir_rdata

    ,input  logic                       rf_rop_dp_enq_dir_isol_en
    ,input  logic                       rf_rop_dp_enq_dir_pwr_enable_b_in
    ,output logic                       rf_rop_dp_enq_dir_pwr_enable_b_out

    ,input  logic                       rf_rop_dp_enq_ro_wclk
    ,input  logic                       rf_rop_dp_enq_ro_wclk_rst_n
    ,input  logic                       rf_rop_dp_enq_ro_we
    ,input  logic[ (   2 ) -1 : 0 ]     rf_rop_dp_enq_ro_waddr
    ,input  logic[ ( 100 ) -1 : 0 ]     rf_rop_dp_enq_ro_wdata
    ,input  logic                       rf_rop_dp_enq_ro_rclk
    ,input  logic                       rf_rop_dp_enq_ro_rclk_rst_n
    ,input  logic                       rf_rop_dp_enq_ro_re
    ,input  logic[ (   2 ) -1 : 0 ]     rf_rop_dp_enq_ro_raddr
    ,output logic[ ( 100 ) -1 : 0 ]     rf_rop_dp_enq_ro_rdata

    ,input  logic                       rf_rop_dp_enq_ro_isol_en
    ,input  logic                       rf_rop_dp_enq_ro_pwr_enable_b_in
    ,output logic                       rf_rop_dp_enq_ro_pwr_enable_b_out

    ,input  logic                       rf_rop_nalb_enq_ro_wclk
    ,input  logic                       rf_rop_nalb_enq_ro_wclk_rst_n
    ,input  logic                       rf_rop_nalb_enq_ro_we
    ,input  logic[ (   2 ) -1 : 0 ]     rf_rop_nalb_enq_ro_waddr
    ,input  logic[ ( 100 ) -1 : 0 ]     rf_rop_nalb_enq_ro_wdata
    ,input  logic                       rf_rop_nalb_enq_ro_rclk
    ,input  logic                       rf_rop_nalb_enq_ro_rclk_rst_n
    ,input  logic                       rf_rop_nalb_enq_ro_re
    ,input  logic[ (   2 ) -1 : 0 ]     rf_rop_nalb_enq_ro_raddr
    ,output logic[ ( 100 ) -1 : 0 ]     rf_rop_nalb_enq_ro_rdata

    ,input  logic                       rf_rop_nalb_enq_ro_isol_en
    ,input  logic                       rf_rop_nalb_enq_ro_pwr_enable_b_in
    ,output logic                       rf_rop_nalb_enq_ro_pwr_enable_b_out

    ,input  logic                       rf_rop_nalb_enq_unoord_wclk
    ,input  logic                       rf_rop_nalb_enq_unoord_wclk_rst_n
    ,input  logic                       rf_rop_nalb_enq_unoord_we
    ,input  logic[ (   2 ) -1 : 0 ]     rf_rop_nalb_enq_unoord_waddr
    ,input  logic[ ( 100 ) -1 : 0 ]     rf_rop_nalb_enq_unoord_wdata
    ,input  logic                       rf_rop_nalb_enq_unoord_rclk
    ,input  logic                       rf_rop_nalb_enq_unoord_rclk_rst_n
    ,input  logic                       rf_rop_nalb_enq_unoord_re
    ,input  logic[ (   2 ) -1 : 0 ]     rf_rop_nalb_enq_unoord_raddr
    ,output logic[ ( 100 ) -1 : 0 ]     rf_rop_nalb_enq_unoord_rdata

    ,input  logic                       rf_rop_nalb_enq_unoord_isol_en
    ,input  logic                       rf_rop_nalb_enq_unoord_pwr_enable_b_in
    ,output logic                       rf_rop_nalb_enq_unoord_pwr_enable_b_out

    ,input  logic                       rf_rx_sync_dp_dqed_data_wclk
    ,input  logic                       rf_rx_sync_dp_dqed_data_wclk_rst_n
    ,input  logic                       rf_rx_sync_dp_dqed_data_we
    ,input  logic[ (   2 ) -1 : 0 ]     rf_rx_sync_dp_dqed_data_waddr
    ,input  logic[ (  45 ) -1 : 0 ]     rf_rx_sync_dp_dqed_data_wdata
    ,input  logic                       rf_rx_sync_dp_dqed_data_rclk
    ,input  logic                       rf_rx_sync_dp_dqed_data_rclk_rst_n
    ,input  logic                       rf_rx_sync_dp_dqed_data_re
    ,input  logic[ (   2 ) -1 : 0 ]     rf_rx_sync_dp_dqed_data_raddr
    ,output logic[ (  45 ) -1 : 0 ]     rf_rx_sync_dp_dqed_data_rdata

    ,input  logic                       rf_rx_sync_dp_dqed_data_isol_en
    ,input  logic                       rf_rx_sync_dp_dqed_data_pwr_enable_b_in
    ,output logic                       rf_rx_sync_dp_dqed_data_pwr_enable_b_out

    ,input  logic                       rf_rx_sync_lsp_dp_sch_dir_wclk
    ,input  logic                       rf_rx_sync_lsp_dp_sch_dir_wclk_rst_n
    ,input  logic                       rf_rx_sync_lsp_dp_sch_dir_we
    ,input  logic[ (   2 ) -1 : 0 ]     rf_rx_sync_lsp_dp_sch_dir_waddr
    ,input  logic[ (  27 ) -1 : 0 ]     rf_rx_sync_lsp_dp_sch_dir_wdata
    ,input  logic                       rf_rx_sync_lsp_dp_sch_dir_rclk
    ,input  logic                       rf_rx_sync_lsp_dp_sch_dir_rclk_rst_n
    ,input  logic                       rf_rx_sync_lsp_dp_sch_dir_re
    ,input  logic[ (   2 ) -1 : 0 ]     rf_rx_sync_lsp_dp_sch_dir_raddr
    ,output logic[ (  27 ) -1 : 0 ]     rf_rx_sync_lsp_dp_sch_dir_rdata

    ,input  logic                       rf_rx_sync_lsp_dp_sch_dir_isol_en
    ,input  logic                       rf_rx_sync_lsp_dp_sch_dir_pwr_enable_b_in
    ,output logic                       rf_rx_sync_lsp_dp_sch_dir_pwr_enable_b_out

    ,input  logic                       rf_rx_sync_lsp_dp_sch_rorply_wclk
    ,input  logic                       rf_rx_sync_lsp_dp_sch_rorply_wclk_rst_n
    ,input  logic                       rf_rx_sync_lsp_dp_sch_rorply_we
    ,input  logic[ (   2 ) -1 : 0 ]     rf_rx_sync_lsp_dp_sch_rorply_waddr
    ,input  logic[ (   8 ) -1 : 0 ]     rf_rx_sync_lsp_dp_sch_rorply_wdata
    ,input  logic                       rf_rx_sync_lsp_dp_sch_rorply_rclk
    ,input  logic                       rf_rx_sync_lsp_dp_sch_rorply_rclk_rst_n
    ,input  logic                       rf_rx_sync_lsp_dp_sch_rorply_re
    ,input  logic[ (   2 ) -1 : 0 ]     rf_rx_sync_lsp_dp_sch_rorply_raddr
    ,output logic[ (   8 ) -1 : 0 ]     rf_rx_sync_lsp_dp_sch_rorply_rdata

    ,input  logic                       rf_rx_sync_lsp_dp_sch_rorply_isol_en
    ,input  logic                       rf_rx_sync_lsp_dp_sch_rorply_pwr_enable_b_in
    ,output logic                       rf_rx_sync_lsp_dp_sch_rorply_pwr_enable_b_out

    ,input  logic                       rf_rx_sync_lsp_nalb_sch_atq_wclk
    ,input  logic                       rf_rx_sync_lsp_nalb_sch_atq_wclk_rst_n
    ,input  logic                       rf_rx_sync_lsp_nalb_sch_atq_we
    ,input  logic[ (   2 ) -1 : 0 ]     rf_rx_sync_lsp_nalb_sch_atq_waddr
    ,input  logic[ (   8 ) -1 : 0 ]     rf_rx_sync_lsp_nalb_sch_atq_wdata
    ,input  logic                       rf_rx_sync_lsp_nalb_sch_atq_rclk
    ,input  logic                       rf_rx_sync_lsp_nalb_sch_atq_rclk_rst_n
    ,input  logic                       rf_rx_sync_lsp_nalb_sch_atq_re
    ,input  logic[ (   2 ) -1 : 0 ]     rf_rx_sync_lsp_nalb_sch_atq_raddr
    ,output logic[ (   8 ) -1 : 0 ]     rf_rx_sync_lsp_nalb_sch_atq_rdata

    ,input  logic                       rf_rx_sync_lsp_nalb_sch_atq_isol_en
    ,input  logic                       rf_rx_sync_lsp_nalb_sch_atq_pwr_enable_b_in
    ,output logic                       rf_rx_sync_lsp_nalb_sch_atq_pwr_enable_b_out

    ,input  logic                       rf_rx_sync_lsp_nalb_sch_rorply_wclk
    ,input  logic                       rf_rx_sync_lsp_nalb_sch_rorply_wclk_rst_n
    ,input  logic                       rf_rx_sync_lsp_nalb_sch_rorply_we
    ,input  logic[ (   2 ) -1 : 0 ]     rf_rx_sync_lsp_nalb_sch_rorply_waddr
    ,input  logic[ (   8 ) -1 : 0 ]     rf_rx_sync_lsp_nalb_sch_rorply_wdata
    ,input  logic                       rf_rx_sync_lsp_nalb_sch_rorply_rclk
    ,input  logic                       rf_rx_sync_lsp_nalb_sch_rorply_rclk_rst_n
    ,input  logic                       rf_rx_sync_lsp_nalb_sch_rorply_re
    ,input  logic[ (   2 ) -1 : 0 ]     rf_rx_sync_lsp_nalb_sch_rorply_raddr
    ,output logic[ (   8 ) -1 : 0 ]     rf_rx_sync_lsp_nalb_sch_rorply_rdata

    ,input  logic                       rf_rx_sync_lsp_nalb_sch_rorply_isol_en
    ,input  logic                       rf_rx_sync_lsp_nalb_sch_rorply_pwr_enable_b_in
    ,output logic                       rf_rx_sync_lsp_nalb_sch_rorply_pwr_enable_b_out

    ,input  logic                       rf_rx_sync_lsp_nalb_sch_unoord_wclk
    ,input  logic                       rf_rx_sync_lsp_nalb_sch_unoord_wclk_rst_n
    ,input  logic                       rf_rx_sync_lsp_nalb_sch_unoord_we
    ,input  logic[ (   2 ) -1 : 0 ]     rf_rx_sync_lsp_nalb_sch_unoord_waddr
    ,input  logic[ (  27 ) -1 : 0 ]     rf_rx_sync_lsp_nalb_sch_unoord_wdata
    ,input  logic                       rf_rx_sync_lsp_nalb_sch_unoord_rclk
    ,input  logic                       rf_rx_sync_lsp_nalb_sch_unoord_rclk_rst_n
    ,input  logic                       rf_rx_sync_lsp_nalb_sch_unoord_re
    ,input  logic[ (   2 ) -1 : 0 ]     rf_rx_sync_lsp_nalb_sch_unoord_raddr
    ,output logic[ (  27 ) -1 : 0 ]     rf_rx_sync_lsp_nalb_sch_unoord_rdata

    ,input  logic                       rf_rx_sync_lsp_nalb_sch_unoord_isol_en
    ,input  logic                       rf_rx_sync_lsp_nalb_sch_unoord_pwr_enable_b_in
    ,output logic                       rf_rx_sync_lsp_nalb_sch_unoord_pwr_enable_b_out

    ,input  logic                       rf_rx_sync_nalb_qed_data_wclk
    ,input  logic                       rf_rx_sync_nalb_qed_data_wclk_rst_n
    ,input  logic                       rf_rx_sync_nalb_qed_data_we
    ,input  logic[ (   2 ) -1 : 0 ]     rf_rx_sync_nalb_qed_data_waddr
    ,input  logic[ (  45 ) -1 : 0 ]     rf_rx_sync_nalb_qed_data_wdata
    ,input  logic                       rf_rx_sync_nalb_qed_data_rclk
    ,input  logic                       rf_rx_sync_nalb_qed_data_rclk_rst_n
    ,input  logic                       rf_rx_sync_nalb_qed_data_re
    ,input  logic[ (   2 ) -1 : 0 ]     rf_rx_sync_nalb_qed_data_raddr
    ,output logic[ (  45 ) -1 : 0 ]     rf_rx_sync_nalb_qed_data_rdata

    ,input  logic                       rf_rx_sync_nalb_qed_data_isol_en
    ,input  logic                       rf_rx_sync_nalb_qed_data_pwr_enable_b_in
    ,output logic                       rf_rx_sync_nalb_qed_data_pwr_enable_b_out

    ,input  logic                       rf_rx_sync_rop_dp_enq_wclk
    ,input  logic                       rf_rx_sync_rop_dp_enq_wclk_rst_n
    ,input  logic                       rf_rx_sync_rop_dp_enq_we
    ,input  logic[ (   2 ) -1 : 0 ]     rf_rx_sync_rop_dp_enq_waddr
    ,input  logic[ ( 100 ) -1 : 0 ]     rf_rx_sync_rop_dp_enq_wdata
    ,input  logic                       rf_rx_sync_rop_dp_enq_rclk
    ,input  logic                       rf_rx_sync_rop_dp_enq_rclk_rst_n
    ,input  logic                       rf_rx_sync_rop_dp_enq_re
    ,input  logic[ (   2 ) -1 : 0 ]     rf_rx_sync_rop_dp_enq_raddr
    ,output logic[ ( 100 ) -1 : 0 ]     rf_rx_sync_rop_dp_enq_rdata

    ,input  logic                       rf_rx_sync_rop_dp_enq_isol_en
    ,input  logic                       rf_rx_sync_rop_dp_enq_pwr_enable_b_in
    ,output logic                       rf_rx_sync_rop_dp_enq_pwr_enable_b_out

    ,input  logic                       rf_rx_sync_rop_nalb_enq_wclk
    ,input  logic                       rf_rx_sync_rop_nalb_enq_wclk_rst_n
    ,input  logic                       rf_rx_sync_rop_nalb_enq_we
    ,input  logic[ (   2 ) -1 : 0 ]     rf_rx_sync_rop_nalb_enq_waddr
    ,input  logic[ ( 100 ) -1 : 0 ]     rf_rx_sync_rop_nalb_enq_wdata
    ,input  logic                       rf_rx_sync_rop_nalb_enq_rclk
    ,input  logic                       rf_rx_sync_rop_nalb_enq_rclk_rst_n
    ,input  logic                       rf_rx_sync_rop_nalb_enq_re
    ,input  logic[ (   2 ) -1 : 0 ]     rf_rx_sync_rop_nalb_enq_raddr
    ,output logic[ ( 100 ) -1 : 0 ]     rf_rx_sync_rop_nalb_enq_rdata

    ,input  logic                       rf_rx_sync_rop_nalb_enq_isol_en
    ,input  logic                       rf_rx_sync_rop_nalb_enq_pwr_enable_b_in
    ,output logic                       rf_rx_sync_rop_nalb_enq_pwr_enable_b_out

    ,input  logic                       rf_rx_sync_rop_qed_dqed_enq_wclk
    ,input  logic                       rf_rx_sync_rop_qed_dqed_enq_wclk_rst_n
    ,input  logic                       rf_rx_sync_rop_qed_dqed_enq_we
    ,input  logic[ (   2 ) -1 : 0 ]     rf_rx_sync_rop_qed_dqed_enq_waddr
    ,input  logic[ ( 157 ) -1 : 0 ]     rf_rx_sync_rop_qed_dqed_enq_wdata
    ,input  logic                       rf_rx_sync_rop_qed_dqed_enq_rclk
    ,input  logic                       rf_rx_sync_rop_qed_dqed_enq_rclk_rst_n
    ,input  logic                       rf_rx_sync_rop_qed_dqed_enq_re
    ,input  logic[ (   2 ) -1 : 0 ]     rf_rx_sync_rop_qed_dqed_enq_raddr
    ,output logic[ ( 157 ) -1 : 0 ]     rf_rx_sync_rop_qed_dqed_enq_rdata

    ,input  logic                       rf_rx_sync_rop_qed_dqed_enq_isol_en
    ,input  logic                       rf_rx_sync_rop_qed_dqed_enq_pwr_enable_b_in
    ,output logic                       rf_rx_sync_rop_qed_dqed_enq_pwr_enable_b_out

    ,input  logic                       sr_dir_nxthp_clk
    ,input  logic                       sr_dir_nxthp_clk_rst_n
    ,input  logic[ (  14 ) -1 : 0 ]     sr_dir_nxthp_addr
    ,input  logic                       sr_dir_nxthp_we
    ,input  logic[ (  21 ) -1 : 0 ]     sr_dir_nxthp_wdata
    ,input  logic                       sr_dir_nxthp_re
    ,output logic[ (  21 ) -1 : 0 ]     sr_dir_nxthp_rdata

    ,input  logic                       sr_dir_nxthp_isol_en
    ,input  logic                       sr_dir_nxthp_pwr_enable_b_in
    ,output logic                       sr_dir_nxthp_pwr_enable_b_out

    ,input  logic                       sr_nalb_nxthp_clk
    ,input  logic                       sr_nalb_nxthp_clk_rst_n
    ,input  logic[ (  14 ) -1 : 0 ]     sr_nalb_nxthp_addr
    ,input  logic                       sr_nalb_nxthp_we
    ,input  logic[ (  21 ) -1 : 0 ]     sr_nalb_nxthp_wdata
    ,input  logic                       sr_nalb_nxthp_re
    ,output logic[ (  21 ) -1 : 0 ]     sr_nalb_nxthp_rdata

    ,input  logic                       sr_nalb_nxthp_isol_en
    ,input  logic                       sr_nalb_nxthp_pwr_enable_b_in
    ,output logic                       sr_nalb_nxthp_pwr_enable_b_out

    ,input  logic                       sr_qed_0_clk
    ,input  logic                       sr_qed_0_clk_rst_n
    ,input  logic[ (  11 ) -1 : 0 ]     sr_qed_0_addr
    ,input  logic                       sr_qed_0_we
    ,input  logic[ ( 139 ) -1 : 0 ]     sr_qed_0_wdata
    ,input  logic                       sr_qed_0_re
    ,output logic[ ( 139 ) -1 : 0 ]     sr_qed_0_rdata

    ,input  logic                       sr_qed_0_isol_en
    ,input  logic                       sr_qed_0_pwr_enable_b_in
    ,output logic                       sr_qed_0_pwr_enable_b_out

    ,input  logic                       sr_qed_1_clk
    ,input  logic                       sr_qed_1_clk_rst_n
    ,input  logic[ (  11 ) -1 : 0 ]     sr_qed_1_addr
    ,input  logic                       sr_qed_1_we
    ,input  logic[ ( 139 ) -1 : 0 ]     sr_qed_1_wdata
    ,input  logic                       sr_qed_1_re
    ,output logic[ ( 139 ) -1 : 0 ]     sr_qed_1_rdata

    ,input  logic                       sr_qed_1_isol_en
    ,input  logic                       sr_qed_1_pwr_enable_b_in
    ,output logic                       sr_qed_1_pwr_enable_b_out

    ,input  logic                       sr_qed_2_clk
    ,input  logic                       sr_qed_2_clk_rst_n
    ,input  logic[ (  11 ) -1 : 0 ]     sr_qed_2_addr
    ,input  logic                       sr_qed_2_we
    ,input  logic[ ( 139 ) -1 : 0 ]     sr_qed_2_wdata
    ,input  logic                       sr_qed_2_re
    ,output logic[ ( 139 ) -1 : 0 ]     sr_qed_2_rdata

    ,input  logic                       sr_qed_2_isol_en
    ,input  logic                       sr_qed_2_pwr_enable_b_in
    ,output logic                       sr_qed_2_pwr_enable_b_out

    ,input  logic                       sr_qed_3_clk
    ,input  logic                       sr_qed_3_clk_rst_n
    ,input  logic[ (  11 ) -1 : 0 ]     sr_qed_3_addr
    ,input  logic                       sr_qed_3_we
    ,input  logic[ ( 139 ) -1 : 0 ]     sr_qed_3_wdata
    ,input  logic                       sr_qed_3_re
    ,output logic[ ( 139 ) -1 : 0 ]     sr_qed_3_rdata

    ,input  logic                       sr_qed_3_isol_en
    ,input  logic                       sr_qed_3_pwr_enable_b_in
    ,output logic                       sr_qed_3_pwr_enable_b_out

    ,input  logic                       sr_qed_4_clk
    ,input  logic                       sr_qed_4_clk_rst_n
    ,input  logic[ (  11 ) -1 : 0 ]     sr_qed_4_addr
    ,input  logic                       sr_qed_4_we
    ,input  logic[ ( 139 ) -1 : 0 ]     sr_qed_4_wdata
    ,input  logic                       sr_qed_4_re
    ,output logic[ ( 139 ) -1 : 0 ]     sr_qed_4_rdata

    ,input  logic                       sr_qed_4_isol_en
    ,input  logic                       sr_qed_4_pwr_enable_b_in
    ,output logic                       sr_qed_4_pwr_enable_b_out

    ,input  logic                       sr_qed_5_clk
    ,input  logic                       sr_qed_5_clk_rst_n
    ,input  logic[ (  11 ) -1 : 0 ]     sr_qed_5_addr
    ,input  logic                       sr_qed_5_we
    ,input  logic[ ( 139 ) -1 : 0 ]     sr_qed_5_wdata
    ,input  logic                       sr_qed_5_re
    ,output logic[ ( 139 ) -1 : 0 ]     sr_qed_5_rdata

    ,input  logic                       sr_qed_5_isol_en
    ,input  logic                       sr_qed_5_pwr_enable_b_in
    ,output logic                       sr_qed_5_pwr_enable_b_out

    ,input  logic                       sr_qed_6_clk
    ,input  logic                       sr_qed_6_clk_rst_n
    ,input  logic[ (  11 ) -1 : 0 ]     sr_qed_6_addr
    ,input  logic                       sr_qed_6_we
    ,input  logic[ ( 139 ) -1 : 0 ]     sr_qed_6_wdata
    ,input  logic                       sr_qed_6_re
    ,output logic[ ( 139 ) -1 : 0 ]     sr_qed_6_rdata

    ,input  logic                       sr_qed_6_isol_en
    ,input  logic                       sr_qed_6_pwr_enable_b_in
    ,output logic                       sr_qed_6_pwr_enable_b_out

    ,input  logic                       sr_qed_7_clk
    ,input  logic                       sr_qed_7_clk_rst_n
    ,input  logic[ (  11 ) -1 : 0 ]     sr_qed_7_addr
    ,input  logic                       sr_qed_7_we
    ,input  logic[ ( 139 ) -1 : 0 ]     sr_qed_7_wdata
    ,input  logic                       sr_qed_7_re
    ,output logic[ ( 139 ) -1 : 0 ]     sr_qed_7_rdata

    ,input  logic                       sr_qed_7_isol_en
    ,input  logic                       sr_qed_7_pwr_enable_b_in
    ,output logic                       sr_qed_7_pwr_enable_b_out

    ,input  logic                       hqm_pwrgood_rst_b

    ,input  logic                       powergood_rst_b

    ,input  logic                       fscan_byprst_b
    ,input  logic                       fscan_clkungate
    ,input  logic                       fscan_rstbypen
);


endmodule


