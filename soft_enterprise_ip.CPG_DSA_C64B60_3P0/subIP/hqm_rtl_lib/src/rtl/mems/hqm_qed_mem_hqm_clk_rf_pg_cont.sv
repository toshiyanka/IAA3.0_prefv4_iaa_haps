module hqm_qed_mem_hqm_clk_rf_pg_cont (

     input  logic                        rf_atq_cnt_wclk
    ,input  logic                        rf_atq_cnt_wclk_rst_n
    ,input  logic                        rf_atq_cnt_we
    ,input  logic [ (   5 ) -1 : 0 ]     rf_atq_cnt_waddr
    ,input  logic [ (  68 ) -1 : 0 ]     rf_atq_cnt_wdata
    ,input  logic                        rf_atq_cnt_rclk
    ,input  logic                        rf_atq_cnt_rclk_rst_n
    ,input  logic                        rf_atq_cnt_re
    ,input  logic [ (   5 ) -1 : 0 ]     rf_atq_cnt_raddr
    ,output logic [ (  68 ) -1 : 0 ]     rf_atq_cnt_rdata

    ,input  logic                        rf_atq_cnt_isol_en
    ,input  logic                        rf_atq_cnt_pwr_enable_b_in
    ,output logic                        rf_atq_cnt_pwr_enable_b_out

    ,input  logic                        rf_atq_hp_wclk
    ,input  logic                        rf_atq_hp_wclk_rst_n
    ,input  logic                        rf_atq_hp_we
    ,input  logic [ (   7 ) -1 : 0 ]     rf_atq_hp_waddr
    ,input  logic [ (  15 ) -1 : 0 ]     rf_atq_hp_wdata
    ,input  logic                        rf_atq_hp_rclk
    ,input  logic                        rf_atq_hp_rclk_rst_n
    ,input  logic                        rf_atq_hp_re
    ,input  logic [ (   7 ) -1 : 0 ]     rf_atq_hp_raddr
    ,output logic [ (  15 ) -1 : 0 ]     rf_atq_hp_rdata

    ,input  logic                        rf_atq_hp_isol_en
    ,input  logic                        rf_atq_hp_pwr_enable_b_in
    ,output logic                        rf_atq_hp_pwr_enable_b_out

    ,input  logic                        rf_atq_tp_wclk
    ,input  logic                        rf_atq_tp_wclk_rst_n
    ,input  logic                        rf_atq_tp_we
    ,input  logic [ (   7 ) -1 : 0 ]     rf_atq_tp_waddr
    ,input  logic [ (  15 ) -1 : 0 ]     rf_atq_tp_wdata
    ,input  logic                        rf_atq_tp_rclk
    ,input  logic                        rf_atq_tp_rclk_rst_n
    ,input  logic                        rf_atq_tp_re
    ,input  logic [ (   7 ) -1 : 0 ]     rf_atq_tp_raddr
    ,output logic [ (  15 ) -1 : 0 ]     rf_atq_tp_rdata

    ,input  logic                        rf_atq_tp_isol_en
    ,input  logic                        rf_atq_tp_pwr_enable_b_in
    ,output logic                        rf_atq_tp_pwr_enable_b_out

    ,input  logic                        rf_dir_cnt_wclk
    ,input  logic                        rf_dir_cnt_wclk_rst_n
    ,input  logic                        rf_dir_cnt_we
    ,input  logic [ (   6 ) -1 : 0 ]     rf_dir_cnt_waddr
    ,input  logic [ (  68 ) -1 : 0 ]     rf_dir_cnt_wdata
    ,input  logic                        rf_dir_cnt_rclk
    ,input  logic                        rf_dir_cnt_rclk_rst_n
    ,input  logic                        rf_dir_cnt_re
    ,input  logic [ (   6 ) -1 : 0 ]     rf_dir_cnt_raddr
    ,output logic [ (  68 ) -1 : 0 ]     rf_dir_cnt_rdata

    ,input  logic                        rf_dir_cnt_isol_en
    ,input  logic                        rf_dir_cnt_pwr_enable_b_in
    ,output logic                        rf_dir_cnt_pwr_enable_b_out

    ,input  logic                        rf_dir_hp_wclk
    ,input  logic                        rf_dir_hp_wclk_rst_n
    ,input  logic                        rf_dir_hp_we
    ,input  logic [ (   8 ) -1 : 0 ]     rf_dir_hp_waddr
    ,input  logic [ (  15 ) -1 : 0 ]     rf_dir_hp_wdata
    ,input  logic                        rf_dir_hp_rclk
    ,input  logic                        rf_dir_hp_rclk_rst_n
    ,input  logic                        rf_dir_hp_re
    ,input  logic [ (   8 ) -1 : 0 ]     rf_dir_hp_raddr
    ,output logic [ (  15 ) -1 : 0 ]     rf_dir_hp_rdata

    ,input  logic                        rf_dir_hp_isol_en
    ,input  logic                        rf_dir_hp_pwr_enable_b_in
    ,output logic                        rf_dir_hp_pwr_enable_b_out

    ,input  logic                        rf_dir_replay_cnt_wclk
    ,input  logic                        rf_dir_replay_cnt_wclk_rst_n
    ,input  logic                        rf_dir_replay_cnt_we
    ,input  logic [ (   5 ) -1 : 0 ]     rf_dir_replay_cnt_waddr
    ,input  logic [ (  68 ) -1 : 0 ]     rf_dir_replay_cnt_wdata
    ,input  logic                        rf_dir_replay_cnt_rclk
    ,input  logic                        rf_dir_replay_cnt_rclk_rst_n
    ,input  logic                        rf_dir_replay_cnt_re
    ,input  logic [ (   5 ) -1 : 0 ]     rf_dir_replay_cnt_raddr
    ,output logic [ (  68 ) -1 : 0 ]     rf_dir_replay_cnt_rdata

    ,input  logic                        rf_dir_replay_cnt_isol_en
    ,input  logic                        rf_dir_replay_cnt_pwr_enable_b_in
    ,output logic                        rf_dir_replay_cnt_pwr_enable_b_out

    ,input  logic                        rf_dir_replay_hp_wclk
    ,input  logic                        rf_dir_replay_hp_wclk_rst_n
    ,input  logic                        rf_dir_replay_hp_we
    ,input  logic [ (   7 ) -1 : 0 ]     rf_dir_replay_hp_waddr
    ,input  logic [ (  15 ) -1 : 0 ]     rf_dir_replay_hp_wdata
    ,input  logic                        rf_dir_replay_hp_rclk
    ,input  logic                        rf_dir_replay_hp_rclk_rst_n
    ,input  logic                        rf_dir_replay_hp_re
    ,input  logic [ (   7 ) -1 : 0 ]     rf_dir_replay_hp_raddr
    ,output logic [ (  15 ) -1 : 0 ]     rf_dir_replay_hp_rdata

    ,input  logic                        rf_dir_replay_hp_isol_en
    ,input  logic                        rf_dir_replay_hp_pwr_enable_b_in
    ,output logic                        rf_dir_replay_hp_pwr_enable_b_out

    ,input  logic                        rf_dir_replay_tp_wclk
    ,input  logic                        rf_dir_replay_tp_wclk_rst_n
    ,input  logic                        rf_dir_replay_tp_we
    ,input  logic [ (   7 ) -1 : 0 ]     rf_dir_replay_tp_waddr
    ,input  logic [ (  15 ) -1 : 0 ]     rf_dir_replay_tp_wdata
    ,input  logic                        rf_dir_replay_tp_rclk
    ,input  logic                        rf_dir_replay_tp_rclk_rst_n
    ,input  logic                        rf_dir_replay_tp_re
    ,input  logic [ (   7 ) -1 : 0 ]     rf_dir_replay_tp_raddr
    ,output logic [ (  15 ) -1 : 0 ]     rf_dir_replay_tp_rdata

    ,input  logic                        rf_dir_replay_tp_isol_en
    ,input  logic                        rf_dir_replay_tp_pwr_enable_b_in
    ,output logic                        rf_dir_replay_tp_pwr_enable_b_out

    ,input  logic                        rf_dir_rofrag_cnt_wclk
    ,input  logic                        rf_dir_rofrag_cnt_wclk_rst_n
    ,input  logic                        rf_dir_rofrag_cnt_we
    ,input  logic [ (   9 ) -1 : 0 ]     rf_dir_rofrag_cnt_waddr
    ,input  logic [ (  17 ) -1 : 0 ]     rf_dir_rofrag_cnt_wdata
    ,input  logic                        rf_dir_rofrag_cnt_rclk
    ,input  logic                        rf_dir_rofrag_cnt_rclk_rst_n
    ,input  logic                        rf_dir_rofrag_cnt_re
    ,input  logic [ (   9 ) -1 : 0 ]     rf_dir_rofrag_cnt_raddr
    ,output logic [ (  17 ) -1 : 0 ]     rf_dir_rofrag_cnt_rdata

    ,input  logic                        rf_dir_rofrag_cnt_isol_en
    ,input  logic                        rf_dir_rofrag_cnt_pwr_enable_b_in
    ,output logic                        rf_dir_rofrag_cnt_pwr_enable_b_out

    ,input  logic                        rf_dir_rofrag_hp_wclk
    ,input  logic                        rf_dir_rofrag_hp_wclk_rst_n
    ,input  logic                        rf_dir_rofrag_hp_we
    ,input  logic [ (   9 ) -1 : 0 ]     rf_dir_rofrag_hp_waddr
    ,input  logic [ (  15 ) -1 : 0 ]     rf_dir_rofrag_hp_wdata
    ,input  logic                        rf_dir_rofrag_hp_rclk
    ,input  logic                        rf_dir_rofrag_hp_rclk_rst_n
    ,input  logic                        rf_dir_rofrag_hp_re
    ,input  logic [ (   9 ) -1 : 0 ]     rf_dir_rofrag_hp_raddr
    ,output logic [ (  15 ) -1 : 0 ]     rf_dir_rofrag_hp_rdata

    ,input  logic                        rf_dir_rofrag_hp_isol_en
    ,input  logic                        rf_dir_rofrag_hp_pwr_enable_b_in
    ,output logic                        rf_dir_rofrag_hp_pwr_enable_b_out

    ,input  logic                        rf_dir_rofrag_tp_wclk
    ,input  logic                        rf_dir_rofrag_tp_wclk_rst_n
    ,input  logic                        rf_dir_rofrag_tp_we
    ,input  logic [ (   9 ) -1 : 0 ]     rf_dir_rofrag_tp_waddr
    ,input  logic [ (  15 ) -1 : 0 ]     rf_dir_rofrag_tp_wdata
    ,input  logic                        rf_dir_rofrag_tp_rclk
    ,input  logic                        rf_dir_rofrag_tp_rclk_rst_n
    ,input  logic                        rf_dir_rofrag_tp_re
    ,input  logic [ (   9 ) -1 : 0 ]     rf_dir_rofrag_tp_raddr
    ,output logic [ (  15 ) -1 : 0 ]     rf_dir_rofrag_tp_rdata

    ,input  logic                        rf_dir_rofrag_tp_isol_en
    ,input  logic                        rf_dir_rofrag_tp_pwr_enable_b_in
    ,output logic                        rf_dir_rofrag_tp_pwr_enable_b_out

    ,input  logic                        rf_dir_tp_wclk
    ,input  logic                        rf_dir_tp_wclk_rst_n
    ,input  logic                        rf_dir_tp_we
    ,input  logic [ (   8 ) -1 : 0 ]     rf_dir_tp_waddr
    ,input  logic [ (  15 ) -1 : 0 ]     rf_dir_tp_wdata
    ,input  logic                        rf_dir_tp_rclk
    ,input  logic                        rf_dir_tp_rclk_rst_n
    ,input  logic                        rf_dir_tp_re
    ,input  logic [ (   8 ) -1 : 0 ]     rf_dir_tp_raddr
    ,output logic [ (  15 ) -1 : 0 ]     rf_dir_tp_rdata

    ,input  logic                        rf_dir_tp_isol_en
    ,input  logic                        rf_dir_tp_pwr_enable_b_in
    ,output logic                        rf_dir_tp_pwr_enable_b_out

    ,input  logic                        rf_dp_dqed_wclk
    ,input  logic                        rf_dp_dqed_wclk_rst_n
    ,input  logic                        rf_dp_dqed_we
    ,input  logic [ (   5 ) -1 : 0 ]     rf_dp_dqed_waddr
    ,input  logic [ (  45 ) -1 : 0 ]     rf_dp_dqed_wdata
    ,input  logic                        rf_dp_dqed_rclk
    ,input  logic                        rf_dp_dqed_rclk_rst_n
    ,input  logic                        rf_dp_dqed_re
    ,input  logic [ (   5 ) -1 : 0 ]     rf_dp_dqed_raddr
    ,output logic [ (  45 ) -1 : 0 ]     rf_dp_dqed_rdata

    ,input  logic                        rf_dp_dqed_isol_en
    ,input  logic                        rf_dp_dqed_pwr_enable_b_in
    ,output logic                        rf_dp_dqed_pwr_enable_b_out

    ,input  logic                        rf_dp_lsp_enq_dir_wclk
    ,input  logic                        rf_dp_lsp_enq_dir_wclk_rst_n
    ,input  logic                        rf_dp_lsp_enq_dir_we
    ,input  logic [ (   4 ) -1 : 0 ]     rf_dp_lsp_enq_dir_waddr
    ,input  logic [ (   8 ) -1 : 0 ]     rf_dp_lsp_enq_dir_wdata
    ,input  logic                        rf_dp_lsp_enq_dir_rclk
    ,input  logic                        rf_dp_lsp_enq_dir_rclk_rst_n
    ,input  logic                        rf_dp_lsp_enq_dir_re
    ,input  logic [ (   4 ) -1 : 0 ]     rf_dp_lsp_enq_dir_raddr
    ,output logic [ (   8 ) -1 : 0 ]     rf_dp_lsp_enq_dir_rdata

    ,input  logic                        rf_dp_lsp_enq_dir_isol_en
    ,input  logic                        rf_dp_lsp_enq_dir_pwr_enable_b_in
    ,output logic                        rf_dp_lsp_enq_dir_pwr_enable_b_out

    ,input  logic                        rf_dp_lsp_enq_rorply_wclk
    ,input  logic                        rf_dp_lsp_enq_rorply_wclk_rst_n
    ,input  logic                        rf_dp_lsp_enq_rorply_we
    ,input  logic [ (   4 ) -1 : 0 ]     rf_dp_lsp_enq_rorply_waddr
    ,input  logic [ (  23 ) -1 : 0 ]     rf_dp_lsp_enq_rorply_wdata
    ,input  logic                        rf_dp_lsp_enq_rorply_rclk
    ,input  logic                        rf_dp_lsp_enq_rorply_rclk_rst_n
    ,input  logic                        rf_dp_lsp_enq_rorply_re
    ,input  logic [ (   4 ) -1 : 0 ]     rf_dp_lsp_enq_rorply_raddr
    ,output logic [ (  23 ) -1 : 0 ]     rf_dp_lsp_enq_rorply_rdata

    ,input  logic                        rf_dp_lsp_enq_rorply_isol_en
    ,input  logic                        rf_dp_lsp_enq_rorply_pwr_enable_b_in
    ,output logic                        rf_dp_lsp_enq_rorply_pwr_enable_b_out

    ,input  logic                        rf_lsp_dp_sch_dir_wclk
    ,input  logic                        rf_lsp_dp_sch_dir_wclk_rst_n
    ,input  logic                        rf_lsp_dp_sch_dir_we
    ,input  logic [ (   2 ) -1 : 0 ]     rf_lsp_dp_sch_dir_waddr
    ,input  logic [ (  27 ) -1 : 0 ]     rf_lsp_dp_sch_dir_wdata
    ,input  logic                        rf_lsp_dp_sch_dir_rclk
    ,input  logic                        rf_lsp_dp_sch_dir_rclk_rst_n
    ,input  logic                        rf_lsp_dp_sch_dir_re
    ,input  logic [ (   2 ) -1 : 0 ]     rf_lsp_dp_sch_dir_raddr
    ,output logic [ (  27 ) -1 : 0 ]     rf_lsp_dp_sch_dir_rdata

    ,input  logic                        rf_lsp_dp_sch_dir_isol_en
    ,input  logic                        rf_lsp_dp_sch_dir_pwr_enable_b_in
    ,output logic                        rf_lsp_dp_sch_dir_pwr_enable_b_out

    ,input  logic                        rf_lsp_dp_sch_rorply_wclk
    ,input  logic                        rf_lsp_dp_sch_rorply_wclk_rst_n
    ,input  logic                        rf_lsp_dp_sch_rorply_we
    ,input  logic [ (   2 ) -1 : 0 ]     rf_lsp_dp_sch_rorply_waddr
    ,input  logic [ (   8 ) -1 : 0 ]     rf_lsp_dp_sch_rorply_wdata
    ,input  logic                        rf_lsp_dp_sch_rorply_rclk
    ,input  logic                        rf_lsp_dp_sch_rorply_rclk_rst_n
    ,input  logic                        rf_lsp_dp_sch_rorply_re
    ,input  logic [ (   2 ) -1 : 0 ]     rf_lsp_dp_sch_rorply_raddr
    ,output logic [ (   8 ) -1 : 0 ]     rf_lsp_dp_sch_rorply_rdata

    ,input  logic                        rf_lsp_dp_sch_rorply_isol_en
    ,input  logic                        rf_lsp_dp_sch_rorply_pwr_enable_b_in
    ,output logic                        rf_lsp_dp_sch_rorply_pwr_enable_b_out

    ,input  logic                        rf_lsp_nalb_sch_atq_wclk
    ,input  logic                        rf_lsp_nalb_sch_atq_wclk_rst_n
    ,input  logic                        rf_lsp_nalb_sch_atq_we
    ,input  logic [ (   5 ) -1 : 0 ]     rf_lsp_nalb_sch_atq_waddr
    ,input  logic [ (   8 ) -1 : 0 ]     rf_lsp_nalb_sch_atq_wdata
    ,input  logic                        rf_lsp_nalb_sch_atq_rclk
    ,input  logic                        rf_lsp_nalb_sch_atq_rclk_rst_n
    ,input  logic                        rf_lsp_nalb_sch_atq_re
    ,input  logic [ (   5 ) -1 : 0 ]     rf_lsp_nalb_sch_atq_raddr
    ,output logic [ (   8 ) -1 : 0 ]     rf_lsp_nalb_sch_atq_rdata

    ,input  logic                        rf_lsp_nalb_sch_atq_isol_en
    ,input  logic                        rf_lsp_nalb_sch_atq_pwr_enable_b_in
    ,output logic                        rf_lsp_nalb_sch_atq_pwr_enable_b_out

    ,input  logic                        rf_lsp_nalb_sch_rorply_wclk
    ,input  logic                        rf_lsp_nalb_sch_rorply_wclk_rst_n
    ,input  logic                        rf_lsp_nalb_sch_rorply_we
    ,input  logic [ (   2 ) -1 : 0 ]     rf_lsp_nalb_sch_rorply_waddr
    ,input  logic [ (   8 ) -1 : 0 ]     rf_lsp_nalb_sch_rorply_wdata
    ,input  logic                        rf_lsp_nalb_sch_rorply_rclk
    ,input  logic                        rf_lsp_nalb_sch_rorply_rclk_rst_n
    ,input  logic                        rf_lsp_nalb_sch_rorply_re
    ,input  logic [ (   2 ) -1 : 0 ]     rf_lsp_nalb_sch_rorply_raddr
    ,output logic [ (   8 ) -1 : 0 ]     rf_lsp_nalb_sch_rorply_rdata

    ,input  logic                        rf_lsp_nalb_sch_rorply_isol_en
    ,input  logic                        rf_lsp_nalb_sch_rorply_pwr_enable_b_in
    ,output logic                        rf_lsp_nalb_sch_rorply_pwr_enable_b_out

    ,input  logic                        rf_lsp_nalb_sch_unoord_wclk
    ,input  logic                        rf_lsp_nalb_sch_unoord_wclk_rst_n
    ,input  logic                        rf_lsp_nalb_sch_unoord_we
    ,input  logic [ (   2 ) -1 : 0 ]     rf_lsp_nalb_sch_unoord_waddr
    ,input  logic [ (  27 ) -1 : 0 ]     rf_lsp_nalb_sch_unoord_wdata
    ,input  logic                        rf_lsp_nalb_sch_unoord_rclk
    ,input  logic                        rf_lsp_nalb_sch_unoord_rclk_rst_n
    ,input  logic                        rf_lsp_nalb_sch_unoord_re
    ,input  logic [ (   2 ) -1 : 0 ]     rf_lsp_nalb_sch_unoord_raddr
    ,output logic [ (  27 ) -1 : 0 ]     rf_lsp_nalb_sch_unoord_rdata

    ,input  logic                        rf_lsp_nalb_sch_unoord_isol_en
    ,input  logic                        rf_lsp_nalb_sch_unoord_pwr_enable_b_in
    ,output logic                        rf_lsp_nalb_sch_unoord_pwr_enable_b_out

    ,input  logic                        rf_nalb_cnt_wclk
    ,input  logic                        rf_nalb_cnt_wclk_rst_n
    ,input  logic                        rf_nalb_cnt_we
    ,input  logic [ (   5 ) -1 : 0 ]     rf_nalb_cnt_waddr
    ,input  logic [ (  68 ) -1 : 0 ]     rf_nalb_cnt_wdata
    ,input  logic                        rf_nalb_cnt_rclk
    ,input  logic                        rf_nalb_cnt_rclk_rst_n
    ,input  logic                        rf_nalb_cnt_re
    ,input  logic [ (   5 ) -1 : 0 ]     rf_nalb_cnt_raddr
    ,output logic [ (  68 ) -1 : 0 ]     rf_nalb_cnt_rdata

    ,input  logic                        rf_nalb_cnt_isol_en
    ,input  logic                        rf_nalb_cnt_pwr_enable_b_in
    ,output logic                        rf_nalb_cnt_pwr_enable_b_out

    ,input  logic                        rf_nalb_hp_wclk
    ,input  logic                        rf_nalb_hp_wclk_rst_n
    ,input  logic                        rf_nalb_hp_we
    ,input  logic [ (   7 ) -1 : 0 ]     rf_nalb_hp_waddr
    ,input  logic [ (  15 ) -1 : 0 ]     rf_nalb_hp_wdata
    ,input  logic                        rf_nalb_hp_rclk
    ,input  logic                        rf_nalb_hp_rclk_rst_n
    ,input  logic                        rf_nalb_hp_re
    ,input  logic [ (   7 ) -1 : 0 ]     rf_nalb_hp_raddr
    ,output logic [ (  15 ) -1 : 0 ]     rf_nalb_hp_rdata

    ,input  logic                        rf_nalb_hp_isol_en
    ,input  logic                        rf_nalb_hp_pwr_enable_b_in
    ,output logic                        rf_nalb_hp_pwr_enable_b_out

    ,input  logic                        rf_nalb_lsp_enq_rorply_wclk
    ,input  logic                        rf_nalb_lsp_enq_rorply_wclk_rst_n
    ,input  logic                        rf_nalb_lsp_enq_rorply_we
    ,input  logic [ (   5 ) -1 : 0 ]     rf_nalb_lsp_enq_rorply_waddr
    ,input  logic [ (  27 ) -1 : 0 ]     rf_nalb_lsp_enq_rorply_wdata
    ,input  logic                        rf_nalb_lsp_enq_rorply_rclk
    ,input  logic                        rf_nalb_lsp_enq_rorply_rclk_rst_n
    ,input  logic                        rf_nalb_lsp_enq_rorply_re
    ,input  logic [ (   5 ) -1 : 0 ]     rf_nalb_lsp_enq_rorply_raddr
    ,output logic [ (  27 ) -1 : 0 ]     rf_nalb_lsp_enq_rorply_rdata

    ,input  logic                        rf_nalb_lsp_enq_rorply_isol_en
    ,input  logic                        rf_nalb_lsp_enq_rorply_pwr_enable_b_in
    ,output logic                        rf_nalb_lsp_enq_rorply_pwr_enable_b_out

    ,input  logic                        rf_nalb_lsp_enq_unoord_wclk
    ,input  logic                        rf_nalb_lsp_enq_unoord_wclk_rst_n
    ,input  logic                        rf_nalb_lsp_enq_unoord_we
    ,input  logic [ (   5 ) -1 : 0 ]     rf_nalb_lsp_enq_unoord_waddr
    ,input  logic [ (  10 ) -1 : 0 ]     rf_nalb_lsp_enq_unoord_wdata
    ,input  logic                        rf_nalb_lsp_enq_unoord_rclk
    ,input  logic                        rf_nalb_lsp_enq_unoord_rclk_rst_n
    ,input  logic                        rf_nalb_lsp_enq_unoord_re
    ,input  logic [ (   5 ) -1 : 0 ]     rf_nalb_lsp_enq_unoord_raddr
    ,output logic [ (  10 ) -1 : 0 ]     rf_nalb_lsp_enq_unoord_rdata

    ,input  logic                        rf_nalb_lsp_enq_unoord_isol_en
    ,input  logic                        rf_nalb_lsp_enq_unoord_pwr_enable_b_in
    ,output logic                        rf_nalb_lsp_enq_unoord_pwr_enable_b_out

    ,input  logic                        rf_nalb_qed_wclk
    ,input  logic                        rf_nalb_qed_wclk_rst_n
    ,input  logic                        rf_nalb_qed_we
    ,input  logic [ (   5 ) -1 : 0 ]     rf_nalb_qed_waddr
    ,input  logic [ (  45 ) -1 : 0 ]     rf_nalb_qed_wdata
    ,input  logic                        rf_nalb_qed_rclk
    ,input  logic                        rf_nalb_qed_rclk_rst_n
    ,input  logic                        rf_nalb_qed_re
    ,input  logic [ (   5 ) -1 : 0 ]     rf_nalb_qed_raddr
    ,output logic [ (  45 ) -1 : 0 ]     rf_nalb_qed_rdata

    ,input  logic                        rf_nalb_qed_isol_en
    ,input  logic                        rf_nalb_qed_pwr_enable_b_in
    ,output logic                        rf_nalb_qed_pwr_enable_b_out

    ,input  logic                        rf_nalb_replay_cnt_wclk
    ,input  logic                        rf_nalb_replay_cnt_wclk_rst_n
    ,input  logic                        rf_nalb_replay_cnt_we
    ,input  logic [ (   5 ) -1 : 0 ]     rf_nalb_replay_cnt_waddr
    ,input  logic [ (  68 ) -1 : 0 ]     rf_nalb_replay_cnt_wdata
    ,input  logic                        rf_nalb_replay_cnt_rclk
    ,input  logic                        rf_nalb_replay_cnt_rclk_rst_n
    ,input  logic                        rf_nalb_replay_cnt_re
    ,input  logic [ (   5 ) -1 : 0 ]     rf_nalb_replay_cnt_raddr
    ,output logic [ (  68 ) -1 : 0 ]     rf_nalb_replay_cnt_rdata

    ,input  logic                        rf_nalb_replay_cnt_isol_en
    ,input  logic                        rf_nalb_replay_cnt_pwr_enable_b_in
    ,output logic                        rf_nalb_replay_cnt_pwr_enable_b_out

    ,input  logic                        rf_nalb_replay_hp_wclk
    ,input  logic                        rf_nalb_replay_hp_wclk_rst_n
    ,input  logic                        rf_nalb_replay_hp_we
    ,input  logic [ (   7 ) -1 : 0 ]     rf_nalb_replay_hp_waddr
    ,input  logic [ (  15 ) -1 : 0 ]     rf_nalb_replay_hp_wdata
    ,input  logic                        rf_nalb_replay_hp_rclk
    ,input  logic                        rf_nalb_replay_hp_rclk_rst_n
    ,input  logic                        rf_nalb_replay_hp_re
    ,input  logic [ (   7 ) -1 : 0 ]     rf_nalb_replay_hp_raddr
    ,output logic [ (  15 ) -1 : 0 ]     rf_nalb_replay_hp_rdata

    ,input  logic                        rf_nalb_replay_hp_isol_en
    ,input  logic                        rf_nalb_replay_hp_pwr_enable_b_in
    ,output logic                        rf_nalb_replay_hp_pwr_enable_b_out

    ,input  logic                        rf_nalb_replay_tp_wclk
    ,input  logic                        rf_nalb_replay_tp_wclk_rst_n
    ,input  logic                        rf_nalb_replay_tp_we
    ,input  logic [ (   7 ) -1 : 0 ]     rf_nalb_replay_tp_waddr
    ,input  logic [ (  15 ) -1 : 0 ]     rf_nalb_replay_tp_wdata
    ,input  logic                        rf_nalb_replay_tp_rclk
    ,input  logic                        rf_nalb_replay_tp_rclk_rst_n
    ,input  logic                        rf_nalb_replay_tp_re
    ,input  logic [ (   7 ) -1 : 0 ]     rf_nalb_replay_tp_raddr
    ,output logic [ (  15 ) -1 : 0 ]     rf_nalb_replay_tp_rdata

    ,input  logic                        rf_nalb_replay_tp_isol_en
    ,input  logic                        rf_nalb_replay_tp_pwr_enable_b_in
    ,output logic                        rf_nalb_replay_tp_pwr_enable_b_out

    ,input  logic                        rf_nalb_rofrag_cnt_wclk
    ,input  logic                        rf_nalb_rofrag_cnt_wclk_rst_n
    ,input  logic                        rf_nalb_rofrag_cnt_we
    ,input  logic [ (   9 ) -1 : 0 ]     rf_nalb_rofrag_cnt_waddr
    ,input  logic [ (  17 ) -1 : 0 ]     rf_nalb_rofrag_cnt_wdata
    ,input  logic                        rf_nalb_rofrag_cnt_rclk
    ,input  logic                        rf_nalb_rofrag_cnt_rclk_rst_n
    ,input  logic                        rf_nalb_rofrag_cnt_re
    ,input  logic [ (   9 ) -1 : 0 ]     rf_nalb_rofrag_cnt_raddr
    ,output logic [ (  17 ) -1 : 0 ]     rf_nalb_rofrag_cnt_rdata

    ,input  logic                        rf_nalb_rofrag_cnt_isol_en
    ,input  logic                        rf_nalb_rofrag_cnt_pwr_enable_b_in
    ,output logic                        rf_nalb_rofrag_cnt_pwr_enable_b_out

    ,input  logic                        rf_nalb_rofrag_hp_wclk
    ,input  logic                        rf_nalb_rofrag_hp_wclk_rst_n
    ,input  logic                        rf_nalb_rofrag_hp_we
    ,input  logic [ (   9 ) -1 : 0 ]     rf_nalb_rofrag_hp_waddr
    ,input  logic [ (  15 ) -1 : 0 ]     rf_nalb_rofrag_hp_wdata
    ,input  logic                        rf_nalb_rofrag_hp_rclk
    ,input  logic                        rf_nalb_rofrag_hp_rclk_rst_n
    ,input  logic                        rf_nalb_rofrag_hp_re
    ,input  logic [ (   9 ) -1 : 0 ]     rf_nalb_rofrag_hp_raddr
    ,output logic [ (  15 ) -1 : 0 ]     rf_nalb_rofrag_hp_rdata

    ,input  logic                        rf_nalb_rofrag_hp_isol_en
    ,input  logic                        rf_nalb_rofrag_hp_pwr_enable_b_in
    ,output logic                        rf_nalb_rofrag_hp_pwr_enable_b_out

    ,input  logic                        rf_nalb_rofrag_tp_wclk
    ,input  logic                        rf_nalb_rofrag_tp_wclk_rst_n
    ,input  logic                        rf_nalb_rofrag_tp_we
    ,input  logic [ (   9 ) -1 : 0 ]     rf_nalb_rofrag_tp_waddr
    ,input  logic [ (  15 ) -1 : 0 ]     rf_nalb_rofrag_tp_wdata
    ,input  logic                        rf_nalb_rofrag_tp_rclk
    ,input  logic                        rf_nalb_rofrag_tp_rclk_rst_n
    ,input  logic                        rf_nalb_rofrag_tp_re
    ,input  logic [ (   9 ) -1 : 0 ]     rf_nalb_rofrag_tp_raddr
    ,output logic [ (  15 ) -1 : 0 ]     rf_nalb_rofrag_tp_rdata

    ,input  logic                        rf_nalb_rofrag_tp_isol_en
    ,input  logic                        rf_nalb_rofrag_tp_pwr_enable_b_in
    ,output logic                        rf_nalb_rofrag_tp_pwr_enable_b_out

    ,input  logic                        rf_nalb_tp_wclk
    ,input  logic                        rf_nalb_tp_wclk_rst_n
    ,input  logic                        rf_nalb_tp_we
    ,input  logic [ (   7 ) -1 : 0 ]     rf_nalb_tp_waddr
    ,input  logic [ (  15 ) -1 : 0 ]     rf_nalb_tp_wdata
    ,input  logic                        rf_nalb_tp_rclk
    ,input  logic                        rf_nalb_tp_rclk_rst_n
    ,input  logic                        rf_nalb_tp_re
    ,input  logic [ (   7 ) -1 : 0 ]     rf_nalb_tp_raddr
    ,output logic [ (  15 ) -1 : 0 ]     rf_nalb_tp_rdata

    ,input  logic                        rf_nalb_tp_isol_en
    ,input  logic                        rf_nalb_tp_pwr_enable_b_in
    ,output logic                        rf_nalb_tp_pwr_enable_b_out

    ,input  logic                        rf_qed_chp_sch_data_wclk
    ,input  logic                        rf_qed_chp_sch_data_wclk_rst_n
    ,input  logic                        rf_qed_chp_sch_data_we
    ,input  logic [ (   3 ) -1 : 0 ]     rf_qed_chp_sch_data_waddr
    ,input  logic [ ( 177 ) -1 : 0 ]     rf_qed_chp_sch_data_wdata
    ,input  logic                        rf_qed_chp_sch_data_rclk
    ,input  logic                        rf_qed_chp_sch_data_rclk_rst_n
    ,input  logic                        rf_qed_chp_sch_data_re
    ,input  logic [ (   3 ) -1 : 0 ]     rf_qed_chp_sch_data_raddr
    ,output logic [ ( 177 ) -1 : 0 ]     rf_qed_chp_sch_data_rdata

    ,input  logic                        rf_qed_chp_sch_data_isol_en
    ,input  logic                        rf_qed_chp_sch_data_pwr_enable_b_in
    ,output logic                        rf_qed_chp_sch_data_pwr_enable_b_out

    ,input  logic                        rf_rop_dp_enq_dir_wclk
    ,input  logic                        rf_rop_dp_enq_dir_wclk_rst_n
    ,input  logic                        rf_rop_dp_enq_dir_we
    ,input  logic [ (   2 ) -1 : 0 ]     rf_rop_dp_enq_dir_waddr
    ,input  logic [ ( 100 ) -1 : 0 ]     rf_rop_dp_enq_dir_wdata
    ,input  logic                        rf_rop_dp_enq_dir_rclk
    ,input  logic                        rf_rop_dp_enq_dir_rclk_rst_n
    ,input  logic                        rf_rop_dp_enq_dir_re
    ,input  logic [ (   2 ) -1 : 0 ]     rf_rop_dp_enq_dir_raddr
    ,output logic [ ( 100 ) -1 : 0 ]     rf_rop_dp_enq_dir_rdata

    ,input  logic                        rf_rop_dp_enq_dir_isol_en
    ,input  logic                        rf_rop_dp_enq_dir_pwr_enable_b_in
    ,output logic                        rf_rop_dp_enq_dir_pwr_enable_b_out

    ,input  logic                        rf_rop_dp_enq_ro_wclk
    ,input  logic                        rf_rop_dp_enq_ro_wclk_rst_n
    ,input  logic                        rf_rop_dp_enq_ro_we
    ,input  logic [ (   2 ) -1 : 0 ]     rf_rop_dp_enq_ro_waddr
    ,input  logic [ ( 100 ) -1 : 0 ]     rf_rop_dp_enq_ro_wdata
    ,input  logic                        rf_rop_dp_enq_ro_rclk
    ,input  logic                        rf_rop_dp_enq_ro_rclk_rst_n
    ,input  logic                        rf_rop_dp_enq_ro_re
    ,input  logic [ (   2 ) -1 : 0 ]     rf_rop_dp_enq_ro_raddr
    ,output logic [ ( 100 ) -1 : 0 ]     rf_rop_dp_enq_ro_rdata

    ,input  logic                        rf_rop_dp_enq_ro_isol_en
    ,input  logic                        rf_rop_dp_enq_ro_pwr_enable_b_in
    ,output logic                        rf_rop_dp_enq_ro_pwr_enable_b_out

    ,input  logic                        rf_rop_nalb_enq_ro_wclk
    ,input  logic                        rf_rop_nalb_enq_ro_wclk_rst_n
    ,input  logic                        rf_rop_nalb_enq_ro_we
    ,input  logic [ (   2 ) -1 : 0 ]     rf_rop_nalb_enq_ro_waddr
    ,input  logic [ ( 100 ) -1 : 0 ]     rf_rop_nalb_enq_ro_wdata
    ,input  logic                        rf_rop_nalb_enq_ro_rclk
    ,input  logic                        rf_rop_nalb_enq_ro_rclk_rst_n
    ,input  logic                        rf_rop_nalb_enq_ro_re
    ,input  logic [ (   2 ) -1 : 0 ]     rf_rop_nalb_enq_ro_raddr
    ,output logic [ ( 100 ) -1 : 0 ]     rf_rop_nalb_enq_ro_rdata

    ,input  logic                        rf_rop_nalb_enq_ro_isol_en
    ,input  logic                        rf_rop_nalb_enq_ro_pwr_enable_b_in
    ,output logic                        rf_rop_nalb_enq_ro_pwr_enable_b_out

    ,input  logic                        rf_rop_nalb_enq_unoord_wclk
    ,input  logic                        rf_rop_nalb_enq_unoord_wclk_rst_n
    ,input  logic                        rf_rop_nalb_enq_unoord_we
    ,input  logic [ (   2 ) -1 : 0 ]     rf_rop_nalb_enq_unoord_waddr
    ,input  logic [ ( 100 ) -1 : 0 ]     rf_rop_nalb_enq_unoord_wdata
    ,input  logic                        rf_rop_nalb_enq_unoord_rclk
    ,input  logic                        rf_rop_nalb_enq_unoord_rclk_rst_n
    ,input  logic                        rf_rop_nalb_enq_unoord_re
    ,input  logic [ (   2 ) -1 : 0 ]     rf_rop_nalb_enq_unoord_raddr
    ,output logic [ ( 100 ) -1 : 0 ]     rf_rop_nalb_enq_unoord_rdata

    ,input  logic                        rf_rop_nalb_enq_unoord_isol_en
    ,input  logic                        rf_rop_nalb_enq_unoord_pwr_enable_b_in
    ,output logic                        rf_rop_nalb_enq_unoord_pwr_enable_b_out

    ,input  logic                        rf_rx_sync_dp_dqed_data_wclk
    ,input  logic                        rf_rx_sync_dp_dqed_data_wclk_rst_n
    ,input  logic                        rf_rx_sync_dp_dqed_data_we
    ,input  logic [ (   2 ) -1 : 0 ]     rf_rx_sync_dp_dqed_data_waddr
    ,input  logic [ (  45 ) -1 : 0 ]     rf_rx_sync_dp_dqed_data_wdata
    ,input  logic                        rf_rx_sync_dp_dqed_data_rclk
    ,input  logic                        rf_rx_sync_dp_dqed_data_rclk_rst_n
    ,input  logic                        rf_rx_sync_dp_dqed_data_re
    ,input  logic [ (   2 ) -1 : 0 ]     rf_rx_sync_dp_dqed_data_raddr
    ,output logic [ (  45 ) -1 : 0 ]     rf_rx_sync_dp_dqed_data_rdata

    ,input  logic                        rf_rx_sync_dp_dqed_data_isol_en
    ,input  logic                        rf_rx_sync_dp_dqed_data_pwr_enable_b_in
    ,output logic                        rf_rx_sync_dp_dqed_data_pwr_enable_b_out

    ,input  logic                        rf_rx_sync_lsp_dp_sch_dir_wclk
    ,input  logic                        rf_rx_sync_lsp_dp_sch_dir_wclk_rst_n
    ,input  logic                        rf_rx_sync_lsp_dp_sch_dir_we
    ,input  logic [ (   2 ) -1 : 0 ]     rf_rx_sync_lsp_dp_sch_dir_waddr
    ,input  logic [ (  27 ) -1 : 0 ]     rf_rx_sync_lsp_dp_sch_dir_wdata
    ,input  logic                        rf_rx_sync_lsp_dp_sch_dir_rclk
    ,input  logic                        rf_rx_sync_lsp_dp_sch_dir_rclk_rst_n
    ,input  logic                        rf_rx_sync_lsp_dp_sch_dir_re
    ,input  logic [ (   2 ) -1 : 0 ]     rf_rx_sync_lsp_dp_sch_dir_raddr
    ,output logic [ (  27 ) -1 : 0 ]     rf_rx_sync_lsp_dp_sch_dir_rdata

    ,input  logic                        rf_rx_sync_lsp_dp_sch_dir_isol_en
    ,input  logic                        rf_rx_sync_lsp_dp_sch_dir_pwr_enable_b_in
    ,output logic                        rf_rx_sync_lsp_dp_sch_dir_pwr_enable_b_out

    ,input  logic                        rf_rx_sync_lsp_dp_sch_rorply_wclk
    ,input  logic                        rf_rx_sync_lsp_dp_sch_rorply_wclk_rst_n
    ,input  logic                        rf_rx_sync_lsp_dp_sch_rorply_we
    ,input  logic [ (   2 ) -1 : 0 ]     rf_rx_sync_lsp_dp_sch_rorply_waddr
    ,input  logic [ (   8 ) -1 : 0 ]     rf_rx_sync_lsp_dp_sch_rorply_wdata
    ,input  logic                        rf_rx_sync_lsp_dp_sch_rorply_rclk
    ,input  logic                        rf_rx_sync_lsp_dp_sch_rorply_rclk_rst_n
    ,input  logic                        rf_rx_sync_lsp_dp_sch_rorply_re
    ,input  logic [ (   2 ) -1 : 0 ]     rf_rx_sync_lsp_dp_sch_rorply_raddr
    ,output logic [ (   8 ) -1 : 0 ]     rf_rx_sync_lsp_dp_sch_rorply_rdata

    ,input  logic                        rf_rx_sync_lsp_dp_sch_rorply_isol_en
    ,input  logic                        rf_rx_sync_lsp_dp_sch_rorply_pwr_enable_b_in
    ,output logic                        rf_rx_sync_lsp_dp_sch_rorply_pwr_enable_b_out

    ,input  logic                        rf_rx_sync_lsp_nalb_sch_atq_wclk
    ,input  logic                        rf_rx_sync_lsp_nalb_sch_atq_wclk_rst_n
    ,input  logic                        rf_rx_sync_lsp_nalb_sch_atq_we
    ,input  logic [ (   2 ) -1 : 0 ]     rf_rx_sync_lsp_nalb_sch_atq_waddr
    ,input  logic [ (   8 ) -1 : 0 ]     rf_rx_sync_lsp_nalb_sch_atq_wdata
    ,input  logic                        rf_rx_sync_lsp_nalb_sch_atq_rclk
    ,input  logic                        rf_rx_sync_lsp_nalb_sch_atq_rclk_rst_n
    ,input  logic                        rf_rx_sync_lsp_nalb_sch_atq_re
    ,input  logic [ (   2 ) -1 : 0 ]     rf_rx_sync_lsp_nalb_sch_atq_raddr
    ,output logic [ (   8 ) -1 : 0 ]     rf_rx_sync_lsp_nalb_sch_atq_rdata

    ,input  logic                        rf_rx_sync_lsp_nalb_sch_atq_isol_en
    ,input  logic                        rf_rx_sync_lsp_nalb_sch_atq_pwr_enable_b_in
    ,output logic                        rf_rx_sync_lsp_nalb_sch_atq_pwr_enable_b_out

    ,input  logic                        rf_rx_sync_lsp_nalb_sch_rorply_wclk
    ,input  logic                        rf_rx_sync_lsp_nalb_sch_rorply_wclk_rst_n
    ,input  logic                        rf_rx_sync_lsp_nalb_sch_rorply_we
    ,input  logic [ (   2 ) -1 : 0 ]     rf_rx_sync_lsp_nalb_sch_rorply_waddr
    ,input  logic [ (   8 ) -1 : 0 ]     rf_rx_sync_lsp_nalb_sch_rorply_wdata
    ,input  logic                        rf_rx_sync_lsp_nalb_sch_rorply_rclk
    ,input  logic                        rf_rx_sync_lsp_nalb_sch_rorply_rclk_rst_n
    ,input  logic                        rf_rx_sync_lsp_nalb_sch_rorply_re
    ,input  logic [ (   2 ) -1 : 0 ]     rf_rx_sync_lsp_nalb_sch_rorply_raddr
    ,output logic [ (   8 ) -1 : 0 ]     rf_rx_sync_lsp_nalb_sch_rorply_rdata

    ,input  logic                        rf_rx_sync_lsp_nalb_sch_rorply_isol_en
    ,input  logic                        rf_rx_sync_lsp_nalb_sch_rorply_pwr_enable_b_in
    ,output logic                        rf_rx_sync_lsp_nalb_sch_rorply_pwr_enable_b_out

    ,input  logic                        rf_rx_sync_lsp_nalb_sch_unoord_wclk
    ,input  logic                        rf_rx_sync_lsp_nalb_sch_unoord_wclk_rst_n
    ,input  logic                        rf_rx_sync_lsp_nalb_sch_unoord_we
    ,input  logic [ (   2 ) -1 : 0 ]     rf_rx_sync_lsp_nalb_sch_unoord_waddr
    ,input  logic [ (  27 ) -1 : 0 ]     rf_rx_sync_lsp_nalb_sch_unoord_wdata
    ,input  logic                        rf_rx_sync_lsp_nalb_sch_unoord_rclk
    ,input  logic                        rf_rx_sync_lsp_nalb_sch_unoord_rclk_rst_n
    ,input  logic                        rf_rx_sync_lsp_nalb_sch_unoord_re
    ,input  logic [ (   2 ) -1 : 0 ]     rf_rx_sync_lsp_nalb_sch_unoord_raddr
    ,output logic [ (  27 ) -1 : 0 ]     rf_rx_sync_lsp_nalb_sch_unoord_rdata

    ,input  logic                        rf_rx_sync_lsp_nalb_sch_unoord_isol_en
    ,input  logic                        rf_rx_sync_lsp_nalb_sch_unoord_pwr_enable_b_in
    ,output logic                        rf_rx_sync_lsp_nalb_sch_unoord_pwr_enable_b_out

    ,input  logic                        rf_rx_sync_nalb_qed_data_wclk
    ,input  logic                        rf_rx_sync_nalb_qed_data_wclk_rst_n
    ,input  logic                        rf_rx_sync_nalb_qed_data_we
    ,input  logic [ (   2 ) -1 : 0 ]     rf_rx_sync_nalb_qed_data_waddr
    ,input  logic [ (  45 ) -1 : 0 ]     rf_rx_sync_nalb_qed_data_wdata
    ,input  logic                        rf_rx_sync_nalb_qed_data_rclk
    ,input  logic                        rf_rx_sync_nalb_qed_data_rclk_rst_n
    ,input  logic                        rf_rx_sync_nalb_qed_data_re
    ,input  logic [ (   2 ) -1 : 0 ]     rf_rx_sync_nalb_qed_data_raddr
    ,output logic [ (  45 ) -1 : 0 ]     rf_rx_sync_nalb_qed_data_rdata

    ,input  logic                        rf_rx_sync_nalb_qed_data_isol_en
    ,input  logic                        rf_rx_sync_nalb_qed_data_pwr_enable_b_in
    ,output logic                        rf_rx_sync_nalb_qed_data_pwr_enable_b_out

    ,input  logic                        rf_rx_sync_rop_dp_enq_wclk
    ,input  logic                        rf_rx_sync_rop_dp_enq_wclk_rst_n
    ,input  logic                        rf_rx_sync_rop_dp_enq_we
    ,input  logic [ (   2 ) -1 : 0 ]     rf_rx_sync_rop_dp_enq_waddr
    ,input  logic [ ( 100 ) -1 : 0 ]     rf_rx_sync_rop_dp_enq_wdata
    ,input  logic                        rf_rx_sync_rop_dp_enq_rclk
    ,input  logic                        rf_rx_sync_rop_dp_enq_rclk_rst_n
    ,input  logic                        rf_rx_sync_rop_dp_enq_re
    ,input  logic [ (   2 ) -1 : 0 ]     rf_rx_sync_rop_dp_enq_raddr
    ,output logic [ ( 100 ) -1 : 0 ]     rf_rx_sync_rop_dp_enq_rdata

    ,input  logic                        rf_rx_sync_rop_dp_enq_isol_en
    ,input  logic                        rf_rx_sync_rop_dp_enq_pwr_enable_b_in
    ,output logic                        rf_rx_sync_rop_dp_enq_pwr_enable_b_out

    ,input  logic                        rf_rx_sync_rop_nalb_enq_wclk
    ,input  logic                        rf_rx_sync_rop_nalb_enq_wclk_rst_n
    ,input  logic                        rf_rx_sync_rop_nalb_enq_we
    ,input  logic [ (   2 ) -1 : 0 ]     rf_rx_sync_rop_nalb_enq_waddr
    ,input  logic [ ( 100 ) -1 : 0 ]     rf_rx_sync_rop_nalb_enq_wdata
    ,input  logic                        rf_rx_sync_rop_nalb_enq_rclk
    ,input  logic                        rf_rx_sync_rop_nalb_enq_rclk_rst_n
    ,input  logic                        rf_rx_sync_rop_nalb_enq_re
    ,input  logic [ (   2 ) -1 : 0 ]     rf_rx_sync_rop_nalb_enq_raddr
    ,output logic [ ( 100 ) -1 : 0 ]     rf_rx_sync_rop_nalb_enq_rdata

    ,input  logic                        rf_rx_sync_rop_nalb_enq_isol_en
    ,input  logic                        rf_rx_sync_rop_nalb_enq_pwr_enable_b_in
    ,output logic                        rf_rx_sync_rop_nalb_enq_pwr_enable_b_out

    ,input  logic                        rf_rx_sync_rop_qed_dqed_enq_wclk
    ,input  logic                        rf_rx_sync_rop_qed_dqed_enq_wclk_rst_n
    ,input  logic                        rf_rx_sync_rop_qed_dqed_enq_we
    ,input  logic [ (   2 ) -1 : 0 ]     rf_rx_sync_rop_qed_dqed_enq_waddr
    ,input  logic [ ( 157 ) -1 : 0 ]     rf_rx_sync_rop_qed_dqed_enq_wdata
    ,input  logic                        rf_rx_sync_rop_qed_dqed_enq_rclk
    ,input  logic                        rf_rx_sync_rop_qed_dqed_enq_rclk_rst_n
    ,input  logic                        rf_rx_sync_rop_qed_dqed_enq_re
    ,input  logic [ (   2 ) -1 : 0 ]     rf_rx_sync_rop_qed_dqed_enq_raddr
    ,output logic [ ( 157 ) -1 : 0 ]     rf_rx_sync_rop_qed_dqed_enq_rdata

    ,input  logic                        rf_rx_sync_rop_qed_dqed_enq_isol_en
    ,input  logic                        rf_rx_sync_rop_qed_dqed_enq_pwr_enable_b_in
    ,output logic                        rf_rx_sync_rop_qed_dqed_enq_pwr_enable_b_out

    ,input  logic                        powergood_rst_b

    ,input  logic                        hqm_pwrgood_rst_b

    ,input  logic                        fscan_byprst_b
    ,input  logic                        fscan_clkungate
    ,input  logic                        fscan_rstbypen
);

logic ip_reset_b;

assign ip_reset_b = powergood_rst_b & hqm_pwrgood_rst_b;

hqm_qed_mem_AW_rf_pg_32x68 i_rf_atq_cnt (

     .wclk                    (rf_atq_cnt_wclk)
    ,.wclk_rst_n              (rf_atq_cnt_wclk_rst_n)
    ,.we                      (rf_atq_cnt_we)
    ,.waddr                   (rf_atq_cnt_waddr)
    ,.wdata                   (rf_atq_cnt_wdata)
    ,.rclk                    (rf_atq_cnt_rclk)
    ,.rclk_rst_n              (rf_atq_cnt_rclk_rst_n)
    ,.re                      (rf_atq_cnt_re)
    ,.raddr                   (rf_atq_cnt_raddr)
    ,.rdata                   (rf_atq_cnt_rdata)

    ,.pgcb_isol_en            (rf_atq_cnt_isol_en)
    ,.pwr_enable_b_in         (rf_atq_cnt_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_atq_cnt_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_qed_mem_AW_rf_pg_128x15 i_rf_atq_hp (

     .wclk                    (rf_atq_hp_wclk)
    ,.wclk_rst_n              (rf_atq_hp_wclk_rst_n)
    ,.we                      (rf_atq_hp_we)
    ,.waddr                   (rf_atq_hp_waddr)
    ,.wdata                   (rf_atq_hp_wdata)
    ,.rclk                    (rf_atq_hp_rclk)
    ,.rclk_rst_n              (rf_atq_hp_rclk_rst_n)
    ,.re                      (rf_atq_hp_re)
    ,.raddr                   (rf_atq_hp_raddr)
    ,.rdata                   (rf_atq_hp_rdata)

    ,.pgcb_isol_en            (rf_atq_hp_isol_en)
    ,.pwr_enable_b_in         (rf_atq_hp_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_atq_hp_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_qed_mem_AW_rf_pg_128x15 i_rf_atq_tp (

     .wclk                    (rf_atq_tp_wclk)
    ,.wclk_rst_n              (rf_atq_tp_wclk_rst_n)
    ,.we                      (rf_atq_tp_we)
    ,.waddr                   (rf_atq_tp_waddr)
    ,.wdata                   (rf_atq_tp_wdata)
    ,.rclk                    (rf_atq_tp_rclk)
    ,.rclk_rst_n              (rf_atq_tp_rclk_rst_n)
    ,.re                      (rf_atq_tp_re)
    ,.raddr                   (rf_atq_tp_raddr)
    ,.rdata                   (rf_atq_tp_rdata)

    ,.pgcb_isol_en            (rf_atq_tp_isol_en)
    ,.pwr_enable_b_in         (rf_atq_tp_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_atq_tp_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_qed_mem_AW_rf_pg_64x68 i_rf_dir_cnt (

     .wclk                    (rf_dir_cnt_wclk)
    ,.wclk_rst_n              (rf_dir_cnt_wclk_rst_n)
    ,.we                      (rf_dir_cnt_we)
    ,.waddr                   (rf_dir_cnt_waddr)
    ,.wdata                   (rf_dir_cnt_wdata)
    ,.rclk                    (rf_dir_cnt_rclk)
    ,.rclk_rst_n              (rf_dir_cnt_rclk_rst_n)
    ,.re                      (rf_dir_cnt_re)
    ,.raddr                   (rf_dir_cnt_raddr)
    ,.rdata                   (rf_dir_cnt_rdata)

    ,.pgcb_isol_en            (rf_dir_cnt_isol_en)
    ,.pwr_enable_b_in         (rf_dir_cnt_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_dir_cnt_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_qed_mem_AW_rf_pg_256x15 i_rf_dir_hp (

     .wclk                    (rf_dir_hp_wclk)
    ,.wclk_rst_n              (rf_dir_hp_wclk_rst_n)
    ,.we                      (rf_dir_hp_we)
    ,.waddr                   (rf_dir_hp_waddr)
    ,.wdata                   (rf_dir_hp_wdata)
    ,.rclk                    (rf_dir_hp_rclk)
    ,.rclk_rst_n              (rf_dir_hp_rclk_rst_n)
    ,.re                      (rf_dir_hp_re)
    ,.raddr                   (rf_dir_hp_raddr)
    ,.rdata                   (rf_dir_hp_rdata)

    ,.pgcb_isol_en            (rf_dir_hp_isol_en)
    ,.pwr_enable_b_in         (rf_dir_hp_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_dir_hp_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_qed_mem_AW_rf_pg_32x68 i_rf_dir_replay_cnt (

     .wclk                    (rf_dir_replay_cnt_wclk)
    ,.wclk_rst_n              (rf_dir_replay_cnt_wclk_rst_n)
    ,.we                      (rf_dir_replay_cnt_we)
    ,.waddr                   (rf_dir_replay_cnt_waddr)
    ,.wdata                   (rf_dir_replay_cnt_wdata)
    ,.rclk                    (rf_dir_replay_cnt_rclk)
    ,.rclk_rst_n              (rf_dir_replay_cnt_rclk_rst_n)
    ,.re                      (rf_dir_replay_cnt_re)
    ,.raddr                   (rf_dir_replay_cnt_raddr)
    ,.rdata                   (rf_dir_replay_cnt_rdata)

    ,.pgcb_isol_en            (rf_dir_replay_cnt_isol_en)
    ,.pwr_enable_b_in         (rf_dir_replay_cnt_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_dir_replay_cnt_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_qed_mem_AW_rf_pg_128x15 i_rf_dir_replay_hp (

     .wclk                    (rf_dir_replay_hp_wclk)
    ,.wclk_rst_n              (rf_dir_replay_hp_wclk_rst_n)
    ,.we                      (rf_dir_replay_hp_we)
    ,.waddr                   (rf_dir_replay_hp_waddr)
    ,.wdata                   (rf_dir_replay_hp_wdata)
    ,.rclk                    (rf_dir_replay_hp_rclk)
    ,.rclk_rst_n              (rf_dir_replay_hp_rclk_rst_n)
    ,.re                      (rf_dir_replay_hp_re)
    ,.raddr                   (rf_dir_replay_hp_raddr)
    ,.rdata                   (rf_dir_replay_hp_rdata)

    ,.pgcb_isol_en            (rf_dir_replay_hp_isol_en)
    ,.pwr_enable_b_in         (rf_dir_replay_hp_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_dir_replay_hp_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_qed_mem_AW_rf_pg_128x15 i_rf_dir_replay_tp (

     .wclk                    (rf_dir_replay_tp_wclk)
    ,.wclk_rst_n              (rf_dir_replay_tp_wclk_rst_n)
    ,.we                      (rf_dir_replay_tp_we)
    ,.waddr                   (rf_dir_replay_tp_waddr)
    ,.wdata                   (rf_dir_replay_tp_wdata)
    ,.rclk                    (rf_dir_replay_tp_rclk)
    ,.rclk_rst_n              (rf_dir_replay_tp_rclk_rst_n)
    ,.re                      (rf_dir_replay_tp_re)
    ,.raddr                   (rf_dir_replay_tp_raddr)
    ,.rdata                   (rf_dir_replay_tp_rdata)

    ,.pgcb_isol_en            (rf_dir_replay_tp_isol_en)
    ,.pwr_enable_b_in         (rf_dir_replay_tp_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_dir_replay_tp_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_qed_mem_AW_rf_pg_512x17 i_rf_dir_rofrag_cnt (

     .wclk                    (rf_dir_rofrag_cnt_wclk)
    ,.wclk_rst_n              (rf_dir_rofrag_cnt_wclk_rst_n)
    ,.we                      (rf_dir_rofrag_cnt_we)
    ,.waddr                   (rf_dir_rofrag_cnt_waddr)
    ,.wdata                   (rf_dir_rofrag_cnt_wdata)
    ,.rclk                    (rf_dir_rofrag_cnt_rclk)
    ,.rclk_rst_n              (rf_dir_rofrag_cnt_rclk_rst_n)
    ,.re                      (rf_dir_rofrag_cnt_re)
    ,.raddr                   (rf_dir_rofrag_cnt_raddr)
    ,.rdata                   (rf_dir_rofrag_cnt_rdata)

    ,.pgcb_isol_en            (rf_dir_rofrag_cnt_isol_en)
    ,.pwr_enable_b_in         (rf_dir_rofrag_cnt_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_dir_rofrag_cnt_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_qed_mem_AW_rf_pg_512x15 i_rf_dir_rofrag_hp (

     .wclk                    (rf_dir_rofrag_hp_wclk)
    ,.wclk_rst_n              (rf_dir_rofrag_hp_wclk_rst_n)
    ,.we                      (rf_dir_rofrag_hp_we)
    ,.waddr                   (rf_dir_rofrag_hp_waddr)
    ,.wdata                   (rf_dir_rofrag_hp_wdata)
    ,.rclk                    (rf_dir_rofrag_hp_rclk)
    ,.rclk_rst_n              (rf_dir_rofrag_hp_rclk_rst_n)
    ,.re                      (rf_dir_rofrag_hp_re)
    ,.raddr                   (rf_dir_rofrag_hp_raddr)
    ,.rdata                   (rf_dir_rofrag_hp_rdata)

    ,.pgcb_isol_en            (rf_dir_rofrag_hp_isol_en)
    ,.pwr_enable_b_in         (rf_dir_rofrag_hp_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_dir_rofrag_hp_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_qed_mem_AW_rf_pg_512x15 i_rf_dir_rofrag_tp (

     .wclk                    (rf_dir_rofrag_tp_wclk)
    ,.wclk_rst_n              (rf_dir_rofrag_tp_wclk_rst_n)
    ,.we                      (rf_dir_rofrag_tp_we)
    ,.waddr                   (rf_dir_rofrag_tp_waddr)
    ,.wdata                   (rf_dir_rofrag_tp_wdata)
    ,.rclk                    (rf_dir_rofrag_tp_rclk)
    ,.rclk_rst_n              (rf_dir_rofrag_tp_rclk_rst_n)
    ,.re                      (rf_dir_rofrag_tp_re)
    ,.raddr                   (rf_dir_rofrag_tp_raddr)
    ,.rdata                   (rf_dir_rofrag_tp_rdata)

    ,.pgcb_isol_en            (rf_dir_rofrag_tp_isol_en)
    ,.pwr_enable_b_in         (rf_dir_rofrag_tp_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_dir_rofrag_tp_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_qed_mem_AW_rf_pg_256x15 i_rf_dir_tp (

     .wclk                    (rf_dir_tp_wclk)
    ,.wclk_rst_n              (rf_dir_tp_wclk_rst_n)
    ,.we                      (rf_dir_tp_we)
    ,.waddr                   (rf_dir_tp_waddr)
    ,.wdata                   (rf_dir_tp_wdata)
    ,.rclk                    (rf_dir_tp_rclk)
    ,.rclk_rst_n              (rf_dir_tp_rclk_rst_n)
    ,.re                      (rf_dir_tp_re)
    ,.raddr                   (rf_dir_tp_raddr)
    ,.rdata                   (rf_dir_tp_rdata)

    ,.pgcb_isol_en            (rf_dir_tp_isol_en)
    ,.pwr_enable_b_in         (rf_dir_tp_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_dir_tp_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_qed_mem_AW_rf_pg_32x45 i_rf_dp_dqed (

     .wclk                    (rf_dp_dqed_wclk)
    ,.wclk_rst_n              (rf_dp_dqed_wclk_rst_n)
    ,.we                      (rf_dp_dqed_we)
    ,.waddr                   (rf_dp_dqed_waddr)
    ,.wdata                   (rf_dp_dqed_wdata)
    ,.rclk                    (rf_dp_dqed_rclk)
    ,.rclk_rst_n              (rf_dp_dqed_rclk_rst_n)
    ,.re                      (rf_dp_dqed_re)
    ,.raddr                   (rf_dp_dqed_raddr)
    ,.rdata                   (rf_dp_dqed_rdata)

    ,.pgcb_isol_en            (rf_dp_dqed_isol_en)
    ,.pwr_enable_b_in         (rf_dp_dqed_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_dp_dqed_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_qed_mem_AW_rf_pg_16x8 i_rf_dp_lsp_enq_dir (

     .wclk                    (rf_dp_lsp_enq_dir_wclk)
    ,.wclk_rst_n              (rf_dp_lsp_enq_dir_wclk_rst_n)
    ,.we                      (rf_dp_lsp_enq_dir_we)
    ,.waddr                   (rf_dp_lsp_enq_dir_waddr)
    ,.wdata                   (rf_dp_lsp_enq_dir_wdata)
    ,.rclk                    (rf_dp_lsp_enq_dir_rclk)
    ,.rclk_rst_n              (rf_dp_lsp_enq_dir_rclk_rst_n)
    ,.re                      (rf_dp_lsp_enq_dir_re)
    ,.raddr                   (rf_dp_lsp_enq_dir_raddr)
    ,.rdata                   (rf_dp_lsp_enq_dir_rdata)

    ,.pgcb_isol_en            (rf_dp_lsp_enq_dir_isol_en)
    ,.pwr_enable_b_in         (rf_dp_lsp_enq_dir_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_dp_lsp_enq_dir_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_qed_mem_AW_rf_pg_16x23 i_rf_dp_lsp_enq_rorply (

     .wclk                    (rf_dp_lsp_enq_rorply_wclk)
    ,.wclk_rst_n              (rf_dp_lsp_enq_rorply_wclk_rst_n)
    ,.we                      (rf_dp_lsp_enq_rorply_we)
    ,.waddr                   (rf_dp_lsp_enq_rorply_waddr)
    ,.wdata                   (rf_dp_lsp_enq_rorply_wdata)
    ,.rclk                    (rf_dp_lsp_enq_rorply_rclk)
    ,.rclk_rst_n              (rf_dp_lsp_enq_rorply_rclk_rst_n)
    ,.re                      (rf_dp_lsp_enq_rorply_re)
    ,.raddr                   (rf_dp_lsp_enq_rorply_raddr)
    ,.rdata                   (rf_dp_lsp_enq_rorply_rdata)

    ,.pgcb_isol_en            (rf_dp_lsp_enq_rorply_isol_en)
    ,.pwr_enable_b_in         (rf_dp_lsp_enq_rorply_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_dp_lsp_enq_rorply_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_qed_mem_AW_rf_pg_4x27 i_rf_lsp_dp_sch_dir (

     .wclk                    (rf_lsp_dp_sch_dir_wclk)
    ,.wclk_rst_n              (rf_lsp_dp_sch_dir_wclk_rst_n)
    ,.we                      (rf_lsp_dp_sch_dir_we)
    ,.waddr                   (rf_lsp_dp_sch_dir_waddr)
    ,.wdata                   (rf_lsp_dp_sch_dir_wdata)
    ,.rclk                    (rf_lsp_dp_sch_dir_rclk)
    ,.rclk_rst_n              (rf_lsp_dp_sch_dir_rclk_rst_n)
    ,.re                      (rf_lsp_dp_sch_dir_re)
    ,.raddr                   (rf_lsp_dp_sch_dir_raddr)
    ,.rdata                   (rf_lsp_dp_sch_dir_rdata)

    ,.pgcb_isol_en            (rf_lsp_dp_sch_dir_isol_en)
    ,.pwr_enable_b_in         (rf_lsp_dp_sch_dir_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_lsp_dp_sch_dir_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_qed_mem_AW_rf_pg_4x8 i_rf_lsp_dp_sch_rorply (

     .wclk                    (rf_lsp_dp_sch_rorply_wclk)
    ,.wclk_rst_n              (rf_lsp_dp_sch_rorply_wclk_rst_n)
    ,.we                      (rf_lsp_dp_sch_rorply_we)
    ,.waddr                   (rf_lsp_dp_sch_rorply_waddr)
    ,.wdata                   (rf_lsp_dp_sch_rorply_wdata)
    ,.rclk                    (rf_lsp_dp_sch_rorply_rclk)
    ,.rclk_rst_n              (rf_lsp_dp_sch_rorply_rclk_rst_n)
    ,.re                      (rf_lsp_dp_sch_rorply_re)
    ,.raddr                   (rf_lsp_dp_sch_rorply_raddr)
    ,.rdata                   (rf_lsp_dp_sch_rorply_rdata)

    ,.pgcb_isol_en            (rf_lsp_dp_sch_rorply_isol_en)
    ,.pwr_enable_b_in         (rf_lsp_dp_sch_rorply_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_lsp_dp_sch_rorply_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_qed_mem_AW_rf_pg_32x8 i_rf_lsp_nalb_sch_atq (

     .wclk                    (rf_lsp_nalb_sch_atq_wclk)
    ,.wclk_rst_n              (rf_lsp_nalb_sch_atq_wclk_rst_n)
    ,.we                      (rf_lsp_nalb_sch_atq_we)
    ,.waddr                   (rf_lsp_nalb_sch_atq_waddr)
    ,.wdata                   (rf_lsp_nalb_sch_atq_wdata)
    ,.rclk                    (rf_lsp_nalb_sch_atq_rclk)
    ,.rclk_rst_n              (rf_lsp_nalb_sch_atq_rclk_rst_n)
    ,.re                      (rf_lsp_nalb_sch_atq_re)
    ,.raddr                   (rf_lsp_nalb_sch_atq_raddr)
    ,.rdata                   (rf_lsp_nalb_sch_atq_rdata)

    ,.pgcb_isol_en            (rf_lsp_nalb_sch_atq_isol_en)
    ,.pwr_enable_b_in         (rf_lsp_nalb_sch_atq_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_lsp_nalb_sch_atq_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_qed_mem_AW_rf_pg_4x8 i_rf_lsp_nalb_sch_rorply (

     .wclk                    (rf_lsp_nalb_sch_rorply_wclk)
    ,.wclk_rst_n              (rf_lsp_nalb_sch_rorply_wclk_rst_n)
    ,.we                      (rf_lsp_nalb_sch_rorply_we)
    ,.waddr                   (rf_lsp_nalb_sch_rorply_waddr)
    ,.wdata                   (rf_lsp_nalb_sch_rorply_wdata)
    ,.rclk                    (rf_lsp_nalb_sch_rorply_rclk)
    ,.rclk_rst_n              (rf_lsp_nalb_sch_rorply_rclk_rst_n)
    ,.re                      (rf_lsp_nalb_sch_rorply_re)
    ,.raddr                   (rf_lsp_nalb_sch_rorply_raddr)
    ,.rdata                   (rf_lsp_nalb_sch_rorply_rdata)

    ,.pgcb_isol_en            (rf_lsp_nalb_sch_rorply_isol_en)
    ,.pwr_enable_b_in         (rf_lsp_nalb_sch_rorply_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_lsp_nalb_sch_rorply_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_qed_mem_AW_rf_pg_4x27 i_rf_lsp_nalb_sch_unoord (

     .wclk                    (rf_lsp_nalb_sch_unoord_wclk)
    ,.wclk_rst_n              (rf_lsp_nalb_sch_unoord_wclk_rst_n)
    ,.we                      (rf_lsp_nalb_sch_unoord_we)
    ,.waddr                   (rf_lsp_nalb_sch_unoord_waddr)
    ,.wdata                   (rf_lsp_nalb_sch_unoord_wdata)
    ,.rclk                    (rf_lsp_nalb_sch_unoord_rclk)
    ,.rclk_rst_n              (rf_lsp_nalb_sch_unoord_rclk_rst_n)
    ,.re                      (rf_lsp_nalb_sch_unoord_re)
    ,.raddr                   (rf_lsp_nalb_sch_unoord_raddr)
    ,.rdata                   (rf_lsp_nalb_sch_unoord_rdata)

    ,.pgcb_isol_en            (rf_lsp_nalb_sch_unoord_isol_en)
    ,.pwr_enable_b_in         (rf_lsp_nalb_sch_unoord_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_lsp_nalb_sch_unoord_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_qed_mem_AW_rf_pg_32x68 i_rf_nalb_cnt (

     .wclk                    (rf_nalb_cnt_wclk)
    ,.wclk_rst_n              (rf_nalb_cnt_wclk_rst_n)
    ,.we                      (rf_nalb_cnt_we)
    ,.waddr                   (rf_nalb_cnt_waddr)
    ,.wdata                   (rf_nalb_cnt_wdata)
    ,.rclk                    (rf_nalb_cnt_rclk)
    ,.rclk_rst_n              (rf_nalb_cnt_rclk_rst_n)
    ,.re                      (rf_nalb_cnt_re)
    ,.raddr                   (rf_nalb_cnt_raddr)
    ,.rdata                   (rf_nalb_cnt_rdata)

    ,.pgcb_isol_en            (rf_nalb_cnt_isol_en)
    ,.pwr_enable_b_in         (rf_nalb_cnt_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_nalb_cnt_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_qed_mem_AW_rf_pg_128x15 i_rf_nalb_hp (

     .wclk                    (rf_nalb_hp_wclk)
    ,.wclk_rst_n              (rf_nalb_hp_wclk_rst_n)
    ,.we                      (rf_nalb_hp_we)
    ,.waddr                   (rf_nalb_hp_waddr)
    ,.wdata                   (rf_nalb_hp_wdata)
    ,.rclk                    (rf_nalb_hp_rclk)
    ,.rclk_rst_n              (rf_nalb_hp_rclk_rst_n)
    ,.re                      (rf_nalb_hp_re)
    ,.raddr                   (rf_nalb_hp_raddr)
    ,.rdata                   (rf_nalb_hp_rdata)

    ,.pgcb_isol_en            (rf_nalb_hp_isol_en)
    ,.pwr_enable_b_in         (rf_nalb_hp_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_nalb_hp_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_qed_mem_AW_rf_pg_32x27 i_rf_nalb_lsp_enq_rorply (

     .wclk                    (rf_nalb_lsp_enq_rorply_wclk)
    ,.wclk_rst_n              (rf_nalb_lsp_enq_rorply_wclk_rst_n)
    ,.we                      (rf_nalb_lsp_enq_rorply_we)
    ,.waddr                   (rf_nalb_lsp_enq_rorply_waddr)
    ,.wdata                   (rf_nalb_lsp_enq_rorply_wdata)
    ,.rclk                    (rf_nalb_lsp_enq_rorply_rclk)
    ,.rclk_rst_n              (rf_nalb_lsp_enq_rorply_rclk_rst_n)
    ,.re                      (rf_nalb_lsp_enq_rorply_re)
    ,.raddr                   (rf_nalb_lsp_enq_rorply_raddr)
    ,.rdata                   (rf_nalb_lsp_enq_rorply_rdata)

    ,.pgcb_isol_en            (rf_nalb_lsp_enq_rorply_isol_en)
    ,.pwr_enable_b_in         (rf_nalb_lsp_enq_rorply_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_nalb_lsp_enq_rorply_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_qed_mem_AW_rf_pg_32x10 i_rf_nalb_lsp_enq_unoord (

     .wclk                    (rf_nalb_lsp_enq_unoord_wclk)
    ,.wclk_rst_n              (rf_nalb_lsp_enq_unoord_wclk_rst_n)
    ,.we                      (rf_nalb_lsp_enq_unoord_we)
    ,.waddr                   (rf_nalb_lsp_enq_unoord_waddr)
    ,.wdata                   (rf_nalb_lsp_enq_unoord_wdata)
    ,.rclk                    (rf_nalb_lsp_enq_unoord_rclk)
    ,.rclk_rst_n              (rf_nalb_lsp_enq_unoord_rclk_rst_n)
    ,.re                      (rf_nalb_lsp_enq_unoord_re)
    ,.raddr                   (rf_nalb_lsp_enq_unoord_raddr)
    ,.rdata                   (rf_nalb_lsp_enq_unoord_rdata)

    ,.pgcb_isol_en            (rf_nalb_lsp_enq_unoord_isol_en)
    ,.pwr_enable_b_in         (rf_nalb_lsp_enq_unoord_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_nalb_lsp_enq_unoord_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_qed_mem_AW_rf_pg_32x45 i_rf_nalb_qed (

     .wclk                    (rf_nalb_qed_wclk)
    ,.wclk_rst_n              (rf_nalb_qed_wclk_rst_n)
    ,.we                      (rf_nalb_qed_we)
    ,.waddr                   (rf_nalb_qed_waddr)
    ,.wdata                   (rf_nalb_qed_wdata)
    ,.rclk                    (rf_nalb_qed_rclk)
    ,.rclk_rst_n              (rf_nalb_qed_rclk_rst_n)
    ,.re                      (rf_nalb_qed_re)
    ,.raddr                   (rf_nalb_qed_raddr)
    ,.rdata                   (rf_nalb_qed_rdata)

    ,.pgcb_isol_en            (rf_nalb_qed_isol_en)
    ,.pwr_enable_b_in         (rf_nalb_qed_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_nalb_qed_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_qed_mem_AW_rf_pg_32x68 i_rf_nalb_replay_cnt (

     .wclk                    (rf_nalb_replay_cnt_wclk)
    ,.wclk_rst_n              (rf_nalb_replay_cnt_wclk_rst_n)
    ,.we                      (rf_nalb_replay_cnt_we)
    ,.waddr                   (rf_nalb_replay_cnt_waddr)
    ,.wdata                   (rf_nalb_replay_cnt_wdata)
    ,.rclk                    (rf_nalb_replay_cnt_rclk)
    ,.rclk_rst_n              (rf_nalb_replay_cnt_rclk_rst_n)
    ,.re                      (rf_nalb_replay_cnt_re)
    ,.raddr                   (rf_nalb_replay_cnt_raddr)
    ,.rdata                   (rf_nalb_replay_cnt_rdata)

    ,.pgcb_isol_en            (rf_nalb_replay_cnt_isol_en)
    ,.pwr_enable_b_in         (rf_nalb_replay_cnt_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_nalb_replay_cnt_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_qed_mem_AW_rf_pg_128x15 i_rf_nalb_replay_hp (

     .wclk                    (rf_nalb_replay_hp_wclk)
    ,.wclk_rst_n              (rf_nalb_replay_hp_wclk_rst_n)
    ,.we                      (rf_nalb_replay_hp_we)
    ,.waddr                   (rf_nalb_replay_hp_waddr)
    ,.wdata                   (rf_nalb_replay_hp_wdata)
    ,.rclk                    (rf_nalb_replay_hp_rclk)
    ,.rclk_rst_n              (rf_nalb_replay_hp_rclk_rst_n)
    ,.re                      (rf_nalb_replay_hp_re)
    ,.raddr                   (rf_nalb_replay_hp_raddr)
    ,.rdata                   (rf_nalb_replay_hp_rdata)

    ,.pgcb_isol_en            (rf_nalb_replay_hp_isol_en)
    ,.pwr_enable_b_in         (rf_nalb_replay_hp_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_nalb_replay_hp_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_qed_mem_AW_rf_pg_128x15 i_rf_nalb_replay_tp (

     .wclk                    (rf_nalb_replay_tp_wclk)
    ,.wclk_rst_n              (rf_nalb_replay_tp_wclk_rst_n)
    ,.we                      (rf_nalb_replay_tp_we)
    ,.waddr                   (rf_nalb_replay_tp_waddr)
    ,.wdata                   (rf_nalb_replay_tp_wdata)
    ,.rclk                    (rf_nalb_replay_tp_rclk)
    ,.rclk_rst_n              (rf_nalb_replay_tp_rclk_rst_n)
    ,.re                      (rf_nalb_replay_tp_re)
    ,.raddr                   (rf_nalb_replay_tp_raddr)
    ,.rdata                   (rf_nalb_replay_tp_rdata)

    ,.pgcb_isol_en            (rf_nalb_replay_tp_isol_en)
    ,.pwr_enable_b_in         (rf_nalb_replay_tp_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_nalb_replay_tp_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_qed_mem_AW_rf_pg_512x17 i_rf_nalb_rofrag_cnt (

     .wclk                    (rf_nalb_rofrag_cnt_wclk)
    ,.wclk_rst_n              (rf_nalb_rofrag_cnt_wclk_rst_n)
    ,.we                      (rf_nalb_rofrag_cnt_we)
    ,.waddr                   (rf_nalb_rofrag_cnt_waddr)
    ,.wdata                   (rf_nalb_rofrag_cnt_wdata)
    ,.rclk                    (rf_nalb_rofrag_cnt_rclk)
    ,.rclk_rst_n              (rf_nalb_rofrag_cnt_rclk_rst_n)
    ,.re                      (rf_nalb_rofrag_cnt_re)
    ,.raddr                   (rf_nalb_rofrag_cnt_raddr)
    ,.rdata                   (rf_nalb_rofrag_cnt_rdata)

    ,.pgcb_isol_en            (rf_nalb_rofrag_cnt_isol_en)
    ,.pwr_enable_b_in         (rf_nalb_rofrag_cnt_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_nalb_rofrag_cnt_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_qed_mem_AW_rf_pg_512x15 i_rf_nalb_rofrag_hp (

     .wclk                    (rf_nalb_rofrag_hp_wclk)
    ,.wclk_rst_n              (rf_nalb_rofrag_hp_wclk_rst_n)
    ,.we                      (rf_nalb_rofrag_hp_we)
    ,.waddr                   (rf_nalb_rofrag_hp_waddr)
    ,.wdata                   (rf_nalb_rofrag_hp_wdata)
    ,.rclk                    (rf_nalb_rofrag_hp_rclk)
    ,.rclk_rst_n              (rf_nalb_rofrag_hp_rclk_rst_n)
    ,.re                      (rf_nalb_rofrag_hp_re)
    ,.raddr                   (rf_nalb_rofrag_hp_raddr)
    ,.rdata                   (rf_nalb_rofrag_hp_rdata)

    ,.pgcb_isol_en            (rf_nalb_rofrag_hp_isol_en)
    ,.pwr_enable_b_in         (rf_nalb_rofrag_hp_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_nalb_rofrag_hp_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_qed_mem_AW_rf_pg_512x15 i_rf_nalb_rofrag_tp (

     .wclk                    (rf_nalb_rofrag_tp_wclk)
    ,.wclk_rst_n              (rf_nalb_rofrag_tp_wclk_rst_n)
    ,.we                      (rf_nalb_rofrag_tp_we)
    ,.waddr                   (rf_nalb_rofrag_tp_waddr)
    ,.wdata                   (rf_nalb_rofrag_tp_wdata)
    ,.rclk                    (rf_nalb_rofrag_tp_rclk)
    ,.rclk_rst_n              (rf_nalb_rofrag_tp_rclk_rst_n)
    ,.re                      (rf_nalb_rofrag_tp_re)
    ,.raddr                   (rf_nalb_rofrag_tp_raddr)
    ,.rdata                   (rf_nalb_rofrag_tp_rdata)

    ,.pgcb_isol_en            (rf_nalb_rofrag_tp_isol_en)
    ,.pwr_enable_b_in         (rf_nalb_rofrag_tp_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_nalb_rofrag_tp_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_qed_mem_AW_rf_pg_128x15 i_rf_nalb_tp (

     .wclk                    (rf_nalb_tp_wclk)
    ,.wclk_rst_n              (rf_nalb_tp_wclk_rst_n)
    ,.we                      (rf_nalb_tp_we)
    ,.waddr                   (rf_nalb_tp_waddr)
    ,.wdata                   (rf_nalb_tp_wdata)
    ,.rclk                    (rf_nalb_tp_rclk)
    ,.rclk_rst_n              (rf_nalb_tp_rclk_rst_n)
    ,.re                      (rf_nalb_tp_re)
    ,.raddr                   (rf_nalb_tp_raddr)
    ,.rdata                   (rf_nalb_tp_rdata)

    ,.pgcb_isol_en            (rf_nalb_tp_isol_en)
    ,.pwr_enable_b_in         (rf_nalb_tp_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_nalb_tp_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_qed_mem_AW_rf_pg_8x177 i_rf_qed_chp_sch_data (

     .wclk                    (rf_qed_chp_sch_data_wclk)
    ,.wclk_rst_n              (rf_qed_chp_sch_data_wclk_rst_n)
    ,.we                      (rf_qed_chp_sch_data_we)
    ,.waddr                   (rf_qed_chp_sch_data_waddr)
    ,.wdata                   (rf_qed_chp_sch_data_wdata)
    ,.rclk                    (rf_qed_chp_sch_data_rclk)
    ,.rclk_rst_n              (rf_qed_chp_sch_data_rclk_rst_n)
    ,.re                      (rf_qed_chp_sch_data_re)
    ,.raddr                   (rf_qed_chp_sch_data_raddr)
    ,.rdata                   (rf_qed_chp_sch_data_rdata)

    ,.pgcb_isol_en            (rf_qed_chp_sch_data_isol_en)
    ,.pwr_enable_b_in         (rf_qed_chp_sch_data_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_qed_chp_sch_data_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_qed_mem_AW_rf_pg_4x100 i_rf_rop_dp_enq_dir (

     .wclk                    (rf_rop_dp_enq_dir_wclk)
    ,.wclk_rst_n              (rf_rop_dp_enq_dir_wclk_rst_n)
    ,.we                      (rf_rop_dp_enq_dir_we)
    ,.waddr                   (rf_rop_dp_enq_dir_waddr)
    ,.wdata                   (rf_rop_dp_enq_dir_wdata)
    ,.rclk                    (rf_rop_dp_enq_dir_rclk)
    ,.rclk_rst_n              (rf_rop_dp_enq_dir_rclk_rst_n)
    ,.re                      (rf_rop_dp_enq_dir_re)
    ,.raddr                   (rf_rop_dp_enq_dir_raddr)
    ,.rdata                   (rf_rop_dp_enq_dir_rdata)

    ,.pgcb_isol_en            (rf_rop_dp_enq_dir_isol_en)
    ,.pwr_enable_b_in         (rf_rop_dp_enq_dir_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_rop_dp_enq_dir_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_qed_mem_AW_rf_pg_4x100 i_rf_rop_dp_enq_ro (

     .wclk                    (rf_rop_dp_enq_ro_wclk)
    ,.wclk_rst_n              (rf_rop_dp_enq_ro_wclk_rst_n)
    ,.we                      (rf_rop_dp_enq_ro_we)
    ,.waddr                   (rf_rop_dp_enq_ro_waddr)
    ,.wdata                   (rf_rop_dp_enq_ro_wdata)
    ,.rclk                    (rf_rop_dp_enq_ro_rclk)
    ,.rclk_rst_n              (rf_rop_dp_enq_ro_rclk_rst_n)
    ,.re                      (rf_rop_dp_enq_ro_re)
    ,.raddr                   (rf_rop_dp_enq_ro_raddr)
    ,.rdata                   (rf_rop_dp_enq_ro_rdata)

    ,.pgcb_isol_en            (rf_rop_dp_enq_ro_isol_en)
    ,.pwr_enable_b_in         (rf_rop_dp_enq_ro_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_rop_dp_enq_ro_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_qed_mem_AW_rf_pg_4x100 i_rf_rop_nalb_enq_ro (

     .wclk                    (rf_rop_nalb_enq_ro_wclk)
    ,.wclk_rst_n              (rf_rop_nalb_enq_ro_wclk_rst_n)
    ,.we                      (rf_rop_nalb_enq_ro_we)
    ,.waddr                   (rf_rop_nalb_enq_ro_waddr)
    ,.wdata                   (rf_rop_nalb_enq_ro_wdata)
    ,.rclk                    (rf_rop_nalb_enq_ro_rclk)
    ,.rclk_rst_n              (rf_rop_nalb_enq_ro_rclk_rst_n)
    ,.re                      (rf_rop_nalb_enq_ro_re)
    ,.raddr                   (rf_rop_nalb_enq_ro_raddr)
    ,.rdata                   (rf_rop_nalb_enq_ro_rdata)

    ,.pgcb_isol_en            (rf_rop_nalb_enq_ro_isol_en)
    ,.pwr_enable_b_in         (rf_rop_nalb_enq_ro_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_rop_nalb_enq_ro_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_qed_mem_AW_rf_pg_4x100 i_rf_rop_nalb_enq_unoord (

     .wclk                    (rf_rop_nalb_enq_unoord_wclk)
    ,.wclk_rst_n              (rf_rop_nalb_enq_unoord_wclk_rst_n)
    ,.we                      (rf_rop_nalb_enq_unoord_we)
    ,.waddr                   (rf_rop_nalb_enq_unoord_waddr)
    ,.wdata                   (rf_rop_nalb_enq_unoord_wdata)
    ,.rclk                    (rf_rop_nalb_enq_unoord_rclk)
    ,.rclk_rst_n              (rf_rop_nalb_enq_unoord_rclk_rst_n)
    ,.re                      (rf_rop_nalb_enq_unoord_re)
    ,.raddr                   (rf_rop_nalb_enq_unoord_raddr)
    ,.rdata                   (rf_rop_nalb_enq_unoord_rdata)

    ,.pgcb_isol_en            (rf_rop_nalb_enq_unoord_isol_en)
    ,.pwr_enable_b_in         (rf_rop_nalb_enq_unoord_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_rop_nalb_enq_unoord_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_qed_mem_AW_rf_pg_4x45 i_rf_rx_sync_dp_dqed_data (

     .wclk                    (rf_rx_sync_dp_dqed_data_wclk)
    ,.wclk_rst_n              (rf_rx_sync_dp_dqed_data_wclk_rst_n)
    ,.we                      (rf_rx_sync_dp_dqed_data_we)
    ,.waddr                   (rf_rx_sync_dp_dqed_data_waddr)
    ,.wdata                   (rf_rx_sync_dp_dqed_data_wdata)
    ,.rclk                    (rf_rx_sync_dp_dqed_data_rclk)
    ,.rclk_rst_n              (rf_rx_sync_dp_dqed_data_rclk_rst_n)
    ,.re                      (rf_rx_sync_dp_dqed_data_re)
    ,.raddr                   (rf_rx_sync_dp_dqed_data_raddr)
    ,.rdata                   (rf_rx_sync_dp_dqed_data_rdata)

    ,.pgcb_isol_en            (rf_rx_sync_dp_dqed_data_isol_en)
    ,.pwr_enable_b_in         (rf_rx_sync_dp_dqed_data_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_rx_sync_dp_dqed_data_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_qed_mem_AW_rf_pg_4x27 i_rf_rx_sync_lsp_dp_sch_dir (

     .wclk                    (rf_rx_sync_lsp_dp_sch_dir_wclk)
    ,.wclk_rst_n              (rf_rx_sync_lsp_dp_sch_dir_wclk_rst_n)
    ,.we                      (rf_rx_sync_lsp_dp_sch_dir_we)
    ,.waddr                   (rf_rx_sync_lsp_dp_sch_dir_waddr)
    ,.wdata                   (rf_rx_sync_lsp_dp_sch_dir_wdata)
    ,.rclk                    (rf_rx_sync_lsp_dp_sch_dir_rclk)
    ,.rclk_rst_n              (rf_rx_sync_lsp_dp_sch_dir_rclk_rst_n)
    ,.re                      (rf_rx_sync_lsp_dp_sch_dir_re)
    ,.raddr                   (rf_rx_sync_lsp_dp_sch_dir_raddr)
    ,.rdata                   (rf_rx_sync_lsp_dp_sch_dir_rdata)

    ,.pgcb_isol_en            (rf_rx_sync_lsp_dp_sch_dir_isol_en)
    ,.pwr_enable_b_in         (rf_rx_sync_lsp_dp_sch_dir_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_rx_sync_lsp_dp_sch_dir_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_qed_mem_AW_rf_pg_4x8 i_rf_rx_sync_lsp_dp_sch_rorply (

     .wclk                    (rf_rx_sync_lsp_dp_sch_rorply_wclk)
    ,.wclk_rst_n              (rf_rx_sync_lsp_dp_sch_rorply_wclk_rst_n)
    ,.we                      (rf_rx_sync_lsp_dp_sch_rorply_we)
    ,.waddr                   (rf_rx_sync_lsp_dp_sch_rorply_waddr)
    ,.wdata                   (rf_rx_sync_lsp_dp_sch_rorply_wdata)
    ,.rclk                    (rf_rx_sync_lsp_dp_sch_rorply_rclk)
    ,.rclk_rst_n              (rf_rx_sync_lsp_dp_sch_rorply_rclk_rst_n)
    ,.re                      (rf_rx_sync_lsp_dp_sch_rorply_re)
    ,.raddr                   (rf_rx_sync_lsp_dp_sch_rorply_raddr)
    ,.rdata                   (rf_rx_sync_lsp_dp_sch_rorply_rdata)

    ,.pgcb_isol_en            (rf_rx_sync_lsp_dp_sch_rorply_isol_en)
    ,.pwr_enable_b_in         (rf_rx_sync_lsp_dp_sch_rorply_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_rx_sync_lsp_dp_sch_rorply_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_qed_mem_AW_rf_pg_4x8 i_rf_rx_sync_lsp_nalb_sch_atq (

     .wclk                    (rf_rx_sync_lsp_nalb_sch_atq_wclk)
    ,.wclk_rst_n              (rf_rx_sync_lsp_nalb_sch_atq_wclk_rst_n)
    ,.we                      (rf_rx_sync_lsp_nalb_sch_atq_we)
    ,.waddr                   (rf_rx_sync_lsp_nalb_sch_atq_waddr)
    ,.wdata                   (rf_rx_sync_lsp_nalb_sch_atq_wdata)
    ,.rclk                    (rf_rx_sync_lsp_nalb_sch_atq_rclk)
    ,.rclk_rst_n              (rf_rx_sync_lsp_nalb_sch_atq_rclk_rst_n)
    ,.re                      (rf_rx_sync_lsp_nalb_sch_atq_re)
    ,.raddr                   (rf_rx_sync_lsp_nalb_sch_atq_raddr)
    ,.rdata                   (rf_rx_sync_lsp_nalb_sch_atq_rdata)

    ,.pgcb_isol_en            (rf_rx_sync_lsp_nalb_sch_atq_isol_en)
    ,.pwr_enable_b_in         (rf_rx_sync_lsp_nalb_sch_atq_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_rx_sync_lsp_nalb_sch_atq_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_qed_mem_AW_rf_pg_4x8 i_rf_rx_sync_lsp_nalb_sch_rorply (

     .wclk                    (rf_rx_sync_lsp_nalb_sch_rorply_wclk)
    ,.wclk_rst_n              (rf_rx_sync_lsp_nalb_sch_rorply_wclk_rst_n)
    ,.we                      (rf_rx_sync_lsp_nalb_sch_rorply_we)
    ,.waddr                   (rf_rx_sync_lsp_nalb_sch_rorply_waddr)
    ,.wdata                   (rf_rx_sync_lsp_nalb_sch_rorply_wdata)
    ,.rclk                    (rf_rx_sync_lsp_nalb_sch_rorply_rclk)
    ,.rclk_rst_n              (rf_rx_sync_lsp_nalb_sch_rorply_rclk_rst_n)
    ,.re                      (rf_rx_sync_lsp_nalb_sch_rorply_re)
    ,.raddr                   (rf_rx_sync_lsp_nalb_sch_rorply_raddr)
    ,.rdata                   (rf_rx_sync_lsp_nalb_sch_rorply_rdata)

    ,.pgcb_isol_en            (rf_rx_sync_lsp_nalb_sch_rorply_isol_en)
    ,.pwr_enable_b_in         (rf_rx_sync_lsp_nalb_sch_rorply_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_rx_sync_lsp_nalb_sch_rorply_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_qed_mem_AW_rf_pg_4x27 i_rf_rx_sync_lsp_nalb_sch_unoord (

     .wclk                    (rf_rx_sync_lsp_nalb_sch_unoord_wclk)
    ,.wclk_rst_n              (rf_rx_sync_lsp_nalb_sch_unoord_wclk_rst_n)
    ,.we                      (rf_rx_sync_lsp_nalb_sch_unoord_we)
    ,.waddr                   (rf_rx_sync_lsp_nalb_sch_unoord_waddr)
    ,.wdata                   (rf_rx_sync_lsp_nalb_sch_unoord_wdata)
    ,.rclk                    (rf_rx_sync_lsp_nalb_sch_unoord_rclk)
    ,.rclk_rst_n              (rf_rx_sync_lsp_nalb_sch_unoord_rclk_rst_n)
    ,.re                      (rf_rx_sync_lsp_nalb_sch_unoord_re)
    ,.raddr                   (rf_rx_sync_lsp_nalb_sch_unoord_raddr)
    ,.rdata                   (rf_rx_sync_lsp_nalb_sch_unoord_rdata)

    ,.pgcb_isol_en            (rf_rx_sync_lsp_nalb_sch_unoord_isol_en)
    ,.pwr_enable_b_in         (rf_rx_sync_lsp_nalb_sch_unoord_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_rx_sync_lsp_nalb_sch_unoord_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_qed_mem_AW_rf_pg_4x45 i_rf_rx_sync_nalb_qed_data (

     .wclk                    (rf_rx_sync_nalb_qed_data_wclk)
    ,.wclk_rst_n              (rf_rx_sync_nalb_qed_data_wclk_rst_n)
    ,.we                      (rf_rx_sync_nalb_qed_data_we)
    ,.waddr                   (rf_rx_sync_nalb_qed_data_waddr)
    ,.wdata                   (rf_rx_sync_nalb_qed_data_wdata)
    ,.rclk                    (rf_rx_sync_nalb_qed_data_rclk)
    ,.rclk_rst_n              (rf_rx_sync_nalb_qed_data_rclk_rst_n)
    ,.re                      (rf_rx_sync_nalb_qed_data_re)
    ,.raddr                   (rf_rx_sync_nalb_qed_data_raddr)
    ,.rdata                   (rf_rx_sync_nalb_qed_data_rdata)

    ,.pgcb_isol_en            (rf_rx_sync_nalb_qed_data_isol_en)
    ,.pwr_enable_b_in         (rf_rx_sync_nalb_qed_data_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_rx_sync_nalb_qed_data_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_qed_mem_AW_rf_pg_4x100 i_rf_rx_sync_rop_dp_enq (

     .wclk                    (rf_rx_sync_rop_dp_enq_wclk)
    ,.wclk_rst_n              (rf_rx_sync_rop_dp_enq_wclk_rst_n)
    ,.we                      (rf_rx_sync_rop_dp_enq_we)
    ,.waddr                   (rf_rx_sync_rop_dp_enq_waddr)
    ,.wdata                   (rf_rx_sync_rop_dp_enq_wdata)
    ,.rclk                    (rf_rx_sync_rop_dp_enq_rclk)
    ,.rclk_rst_n              (rf_rx_sync_rop_dp_enq_rclk_rst_n)
    ,.re                      (rf_rx_sync_rop_dp_enq_re)
    ,.raddr                   (rf_rx_sync_rop_dp_enq_raddr)
    ,.rdata                   (rf_rx_sync_rop_dp_enq_rdata)

    ,.pgcb_isol_en            (rf_rx_sync_rop_dp_enq_isol_en)
    ,.pwr_enable_b_in         (rf_rx_sync_rop_dp_enq_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_rx_sync_rop_dp_enq_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_qed_mem_AW_rf_pg_4x100 i_rf_rx_sync_rop_nalb_enq (

     .wclk                    (rf_rx_sync_rop_nalb_enq_wclk)
    ,.wclk_rst_n              (rf_rx_sync_rop_nalb_enq_wclk_rst_n)
    ,.we                      (rf_rx_sync_rop_nalb_enq_we)
    ,.waddr                   (rf_rx_sync_rop_nalb_enq_waddr)
    ,.wdata                   (rf_rx_sync_rop_nalb_enq_wdata)
    ,.rclk                    (rf_rx_sync_rop_nalb_enq_rclk)
    ,.rclk_rst_n              (rf_rx_sync_rop_nalb_enq_rclk_rst_n)
    ,.re                      (rf_rx_sync_rop_nalb_enq_re)
    ,.raddr                   (rf_rx_sync_rop_nalb_enq_raddr)
    ,.rdata                   (rf_rx_sync_rop_nalb_enq_rdata)

    ,.pgcb_isol_en            (rf_rx_sync_rop_nalb_enq_isol_en)
    ,.pwr_enable_b_in         (rf_rx_sync_rop_nalb_enq_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_rx_sync_rop_nalb_enq_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_qed_mem_AW_rf_pg_4x157 i_rf_rx_sync_rop_qed_dqed_enq (

     .wclk                    (rf_rx_sync_rop_qed_dqed_enq_wclk)
    ,.wclk_rst_n              (rf_rx_sync_rop_qed_dqed_enq_wclk_rst_n)
    ,.we                      (rf_rx_sync_rop_qed_dqed_enq_we)
    ,.waddr                   (rf_rx_sync_rop_qed_dqed_enq_waddr)
    ,.wdata                   (rf_rx_sync_rop_qed_dqed_enq_wdata)
    ,.rclk                    (rf_rx_sync_rop_qed_dqed_enq_rclk)
    ,.rclk_rst_n              (rf_rx_sync_rop_qed_dqed_enq_rclk_rst_n)
    ,.re                      (rf_rx_sync_rop_qed_dqed_enq_re)
    ,.raddr                   (rf_rx_sync_rop_qed_dqed_enq_raddr)
    ,.rdata                   (rf_rx_sync_rop_qed_dqed_enq_rdata)

    ,.pgcb_isol_en            (rf_rx_sync_rop_qed_dqed_enq_isol_en)
    ,.pwr_enable_b_in         (rf_rx_sync_rop_qed_dqed_enq_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_rx_sync_rop_qed_dqed_enq_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

endmodule

