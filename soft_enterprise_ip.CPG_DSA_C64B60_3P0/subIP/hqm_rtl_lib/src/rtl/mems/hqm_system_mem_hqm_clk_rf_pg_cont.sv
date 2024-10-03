module hqm_system_mem_hqm_clk_rf_pg_cont (

     input  logic                        rf_alarm_vf_synd0_wclk
    ,input  logic                        rf_alarm_vf_synd0_wclk_rst_n
    ,input  logic                        rf_alarm_vf_synd0_we
    ,input  logic [ (   4 ) -1 : 0 ]     rf_alarm_vf_synd0_waddr
    ,input  logic [ (  30 ) -1 : 0 ]     rf_alarm_vf_synd0_wdata
    ,input  logic                        rf_alarm_vf_synd0_rclk
    ,input  logic                        rf_alarm_vf_synd0_rclk_rst_n
    ,input  logic                        rf_alarm_vf_synd0_re
    ,input  logic [ (   4 ) -1 : 0 ]     rf_alarm_vf_synd0_raddr
    ,output logic [ (  30 ) -1 : 0 ]     rf_alarm_vf_synd0_rdata

    ,input  logic                        rf_alarm_vf_synd0_isol_en
    ,input  logic                        rf_alarm_vf_synd0_pwr_enable_b_in
    ,output logic                        rf_alarm_vf_synd0_pwr_enable_b_out

    ,input  logic                        rf_alarm_vf_synd1_wclk
    ,input  logic                        rf_alarm_vf_synd1_wclk_rst_n
    ,input  logic                        rf_alarm_vf_synd1_we
    ,input  logic [ (   4 ) -1 : 0 ]     rf_alarm_vf_synd1_waddr
    ,input  logic [ (  32 ) -1 : 0 ]     rf_alarm_vf_synd1_wdata
    ,input  logic                        rf_alarm_vf_synd1_rclk
    ,input  logic                        rf_alarm_vf_synd1_rclk_rst_n
    ,input  logic                        rf_alarm_vf_synd1_re
    ,input  logic [ (   4 ) -1 : 0 ]     rf_alarm_vf_synd1_raddr
    ,output logic [ (  32 ) -1 : 0 ]     rf_alarm_vf_synd1_rdata

    ,input  logic                        rf_alarm_vf_synd1_isol_en
    ,input  logic                        rf_alarm_vf_synd1_pwr_enable_b_in
    ,output logic                        rf_alarm_vf_synd1_pwr_enable_b_out

    ,input  logic                        rf_alarm_vf_synd2_wclk
    ,input  logic                        rf_alarm_vf_synd2_wclk_rst_n
    ,input  logic                        rf_alarm_vf_synd2_we
    ,input  logic [ (   4 ) -1 : 0 ]     rf_alarm_vf_synd2_waddr
    ,input  logic [ (  32 ) -1 : 0 ]     rf_alarm_vf_synd2_wdata
    ,input  logic                        rf_alarm_vf_synd2_rclk
    ,input  logic                        rf_alarm_vf_synd2_rclk_rst_n
    ,input  logic                        rf_alarm_vf_synd2_re
    ,input  logic [ (   4 ) -1 : 0 ]     rf_alarm_vf_synd2_raddr
    ,output logic [ (  32 ) -1 : 0 ]     rf_alarm_vf_synd2_rdata

    ,input  logic                        rf_alarm_vf_synd2_isol_en
    ,input  logic                        rf_alarm_vf_synd2_pwr_enable_b_in
    ,output logic                        rf_alarm_vf_synd2_pwr_enable_b_out

    ,input  logic                        rf_aqed_chp_sch_rx_sync_mem_wclk
    ,input  logic                        rf_aqed_chp_sch_rx_sync_mem_wclk_rst_n
    ,input  logic                        rf_aqed_chp_sch_rx_sync_mem_we
    ,input  logic [ (   2 ) -1 : 0 ]     rf_aqed_chp_sch_rx_sync_mem_waddr
    ,input  logic [ ( 179 ) -1 : 0 ]     rf_aqed_chp_sch_rx_sync_mem_wdata
    ,input  logic                        rf_aqed_chp_sch_rx_sync_mem_rclk
    ,input  logic                        rf_aqed_chp_sch_rx_sync_mem_rclk_rst_n
    ,input  logic                        rf_aqed_chp_sch_rx_sync_mem_re
    ,input  logic [ (   2 ) -1 : 0 ]     rf_aqed_chp_sch_rx_sync_mem_raddr
    ,output logic [ ( 179 ) -1 : 0 ]     rf_aqed_chp_sch_rx_sync_mem_rdata

    ,input  logic                        rf_aqed_chp_sch_rx_sync_mem_isol_en
    ,input  logic                        rf_aqed_chp_sch_rx_sync_mem_pwr_enable_b_in
    ,output logic                        rf_aqed_chp_sch_rx_sync_mem_pwr_enable_b_out

    ,input  logic                        rf_chp_chp_rop_hcw_fifo_mem_wclk
    ,input  logic                        rf_chp_chp_rop_hcw_fifo_mem_wclk_rst_n
    ,input  logic                        rf_chp_chp_rop_hcw_fifo_mem_we
    ,input  logic [ (   4 ) -1 : 0 ]     rf_chp_chp_rop_hcw_fifo_mem_waddr
    ,input  logic [ ( 201 ) -1 : 0 ]     rf_chp_chp_rop_hcw_fifo_mem_wdata
    ,input  logic                        rf_chp_chp_rop_hcw_fifo_mem_rclk
    ,input  logic                        rf_chp_chp_rop_hcw_fifo_mem_rclk_rst_n
    ,input  logic                        rf_chp_chp_rop_hcw_fifo_mem_re
    ,input  logic [ (   4 ) -1 : 0 ]     rf_chp_chp_rop_hcw_fifo_mem_raddr
    ,output logic [ ( 201 ) -1 : 0 ]     rf_chp_chp_rop_hcw_fifo_mem_rdata

    ,input  logic                        rf_chp_chp_rop_hcw_fifo_mem_isol_en
    ,input  logic                        rf_chp_chp_rop_hcw_fifo_mem_pwr_enable_b_in
    ,output logic                        rf_chp_chp_rop_hcw_fifo_mem_pwr_enable_b_out

    ,input  logic                        rf_chp_lsp_ap_cmp_fifo_mem_wclk
    ,input  logic                        rf_chp_lsp_ap_cmp_fifo_mem_wclk_rst_n
    ,input  logic                        rf_chp_lsp_ap_cmp_fifo_mem_we
    ,input  logic [ (   4 ) -1 : 0 ]     rf_chp_lsp_ap_cmp_fifo_mem_waddr
    ,input  logic [ (  74 ) -1 : 0 ]     rf_chp_lsp_ap_cmp_fifo_mem_wdata
    ,input  logic                        rf_chp_lsp_ap_cmp_fifo_mem_rclk
    ,input  logic                        rf_chp_lsp_ap_cmp_fifo_mem_rclk_rst_n
    ,input  logic                        rf_chp_lsp_ap_cmp_fifo_mem_re
    ,input  logic [ (   4 ) -1 : 0 ]     rf_chp_lsp_ap_cmp_fifo_mem_raddr
    ,output logic [ (  74 ) -1 : 0 ]     rf_chp_lsp_ap_cmp_fifo_mem_rdata

    ,input  logic                        rf_chp_lsp_ap_cmp_fifo_mem_isol_en
    ,input  logic                        rf_chp_lsp_ap_cmp_fifo_mem_pwr_enable_b_in
    ,output logic                        rf_chp_lsp_ap_cmp_fifo_mem_pwr_enable_b_out

    ,input  logic                        rf_chp_lsp_tok_fifo_mem_wclk
    ,input  logic                        rf_chp_lsp_tok_fifo_mem_wclk_rst_n
    ,input  logic                        rf_chp_lsp_tok_fifo_mem_we
    ,input  logic [ (   4 ) -1 : 0 ]     rf_chp_lsp_tok_fifo_mem_waddr
    ,input  logic [ (  29 ) -1 : 0 ]     rf_chp_lsp_tok_fifo_mem_wdata
    ,input  logic                        rf_chp_lsp_tok_fifo_mem_rclk
    ,input  logic                        rf_chp_lsp_tok_fifo_mem_rclk_rst_n
    ,input  logic                        rf_chp_lsp_tok_fifo_mem_re
    ,input  logic [ (   4 ) -1 : 0 ]     rf_chp_lsp_tok_fifo_mem_raddr
    ,output logic [ (  29 ) -1 : 0 ]     rf_chp_lsp_tok_fifo_mem_rdata

    ,input  logic                        rf_chp_lsp_tok_fifo_mem_isol_en
    ,input  logic                        rf_chp_lsp_tok_fifo_mem_pwr_enable_b_in
    ,output logic                        rf_chp_lsp_tok_fifo_mem_pwr_enable_b_out

    ,input  logic                        rf_chp_sys_tx_fifo_mem_wclk
    ,input  logic                        rf_chp_sys_tx_fifo_mem_wclk_rst_n
    ,input  logic                        rf_chp_sys_tx_fifo_mem_we
    ,input  logic [ (   3 ) -1 : 0 ]     rf_chp_sys_tx_fifo_mem_waddr
    ,input  logic [ ( 200 ) -1 : 0 ]     rf_chp_sys_tx_fifo_mem_wdata
    ,input  logic                        rf_chp_sys_tx_fifo_mem_rclk
    ,input  logic                        rf_chp_sys_tx_fifo_mem_rclk_rst_n
    ,input  logic                        rf_chp_sys_tx_fifo_mem_re
    ,input  logic [ (   3 ) -1 : 0 ]     rf_chp_sys_tx_fifo_mem_raddr
    ,output logic [ ( 200 ) -1 : 0 ]     rf_chp_sys_tx_fifo_mem_rdata

    ,input  logic                        rf_chp_sys_tx_fifo_mem_isol_en
    ,input  logic                        rf_chp_sys_tx_fifo_mem_pwr_enable_b_in
    ,output logic                        rf_chp_sys_tx_fifo_mem_pwr_enable_b_out

    ,input  logic                        rf_cmp_id_chk_enbl_mem_wclk
    ,input  logic                        rf_cmp_id_chk_enbl_mem_wclk_rst_n
    ,input  logic                        rf_cmp_id_chk_enbl_mem_we
    ,input  logic [ (   6 ) -1 : 0 ]     rf_cmp_id_chk_enbl_mem_waddr
    ,input  logic [ (   2 ) -1 : 0 ]     rf_cmp_id_chk_enbl_mem_wdata
    ,input  logic                        rf_cmp_id_chk_enbl_mem_rclk
    ,input  logic                        rf_cmp_id_chk_enbl_mem_rclk_rst_n
    ,input  logic                        rf_cmp_id_chk_enbl_mem_re
    ,input  logic [ (   6 ) -1 : 0 ]     rf_cmp_id_chk_enbl_mem_raddr
    ,output logic [ (   2 ) -1 : 0 ]     rf_cmp_id_chk_enbl_mem_rdata

    ,input  logic                        rf_cmp_id_chk_enbl_mem_isol_en
    ,input  logic                        rf_cmp_id_chk_enbl_mem_pwr_enable_b_in
    ,output logic                        rf_cmp_id_chk_enbl_mem_pwr_enable_b_out

    ,input  logic                        rf_count_rmw_pipe_dir_mem_wclk
    ,input  logic                        rf_count_rmw_pipe_dir_mem_wclk_rst_n
    ,input  logic                        rf_count_rmw_pipe_dir_mem_we
    ,input  logic [ (   6 ) -1 : 0 ]     rf_count_rmw_pipe_dir_mem_waddr
    ,input  logic [ (  16 ) -1 : 0 ]     rf_count_rmw_pipe_dir_mem_wdata
    ,input  logic                        rf_count_rmw_pipe_dir_mem_rclk
    ,input  logic                        rf_count_rmw_pipe_dir_mem_rclk_rst_n
    ,input  logic                        rf_count_rmw_pipe_dir_mem_re
    ,input  logic [ (   6 ) -1 : 0 ]     rf_count_rmw_pipe_dir_mem_raddr
    ,output logic [ (  16 ) -1 : 0 ]     rf_count_rmw_pipe_dir_mem_rdata

    ,input  logic                        rf_count_rmw_pipe_dir_mem_isol_en
    ,input  logic                        rf_count_rmw_pipe_dir_mem_pwr_enable_b_in
    ,output logic                        rf_count_rmw_pipe_dir_mem_pwr_enable_b_out

    ,input  logic                        rf_count_rmw_pipe_ldb_mem_wclk
    ,input  logic                        rf_count_rmw_pipe_ldb_mem_wclk_rst_n
    ,input  logic                        rf_count_rmw_pipe_ldb_mem_we
    ,input  logic [ (   6 ) -1 : 0 ]     rf_count_rmw_pipe_ldb_mem_waddr
    ,input  logic [ (  16 ) -1 : 0 ]     rf_count_rmw_pipe_ldb_mem_wdata
    ,input  logic                        rf_count_rmw_pipe_ldb_mem_rclk
    ,input  logic                        rf_count_rmw_pipe_ldb_mem_rclk_rst_n
    ,input  logic                        rf_count_rmw_pipe_ldb_mem_re
    ,input  logic [ (   6 ) -1 : 0 ]     rf_count_rmw_pipe_ldb_mem_raddr
    ,output logic [ (  16 ) -1 : 0 ]     rf_count_rmw_pipe_ldb_mem_rdata

    ,input  logic                        rf_count_rmw_pipe_ldb_mem_isol_en
    ,input  logic                        rf_count_rmw_pipe_ldb_mem_pwr_enable_b_in
    ,output logic                        rf_count_rmw_pipe_ldb_mem_pwr_enable_b_out

    ,input  logic                        rf_dir_cq_depth_wclk
    ,input  logic                        rf_dir_cq_depth_wclk_rst_n
    ,input  logic                        rf_dir_cq_depth_we
    ,input  logic [ (   6 ) -1 : 0 ]     rf_dir_cq_depth_waddr
    ,input  logic [ (  13 ) -1 : 0 ]     rf_dir_cq_depth_wdata
    ,input  logic                        rf_dir_cq_depth_rclk
    ,input  logic                        rf_dir_cq_depth_rclk_rst_n
    ,input  logic                        rf_dir_cq_depth_re
    ,input  logic [ (   6 ) -1 : 0 ]     rf_dir_cq_depth_raddr
    ,output logic [ (  13 ) -1 : 0 ]     rf_dir_cq_depth_rdata

    ,input  logic                        rf_dir_cq_depth_isol_en
    ,input  logic                        rf_dir_cq_depth_pwr_enable_b_in
    ,output logic                        rf_dir_cq_depth_pwr_enable_b_out

    ,input  logic                        rf_dir_cq_intr_thresh_wclk
    ,input  logic                        rf_dir_cq_intr_thresh_wclk_rst_n
    ,input  logic                        rf_dir_cq_intr_thresh_we
    ,input  logic [ (   6 ) -1 : 0 ]     rf_dir_cq_intr_thresh_waddr
    ,input  logic [ (  15 ) -1 : 0 ]     rf_dir_cq_intr_thresh_wdata
    ,input  logic                        rf_dir_cq_intr_thresh_rclk
    ,input  logic                        rf_dir_cq_intr_thresh_rclk_rst_n
    ,input  logic                        rf_dir_cq_intr_thresh_re
    ,input  logic [ (   6 ) -1 : 0 ]     rf_dir_cq_intr_thresh_raddr
    ,output logic [ (  15 ) -1 : 0 ]     rf_dir_cq_intr_thresh_rdata

    ,input  logic                        rf_dir_cq_intr_thresh_isol_en
    ,input  logic                        rf_dir_cq_intr_thresh_pwr_enable_b_in
    ,output logic                        rf_dir_cq_intr_thresh_pwr_enable_b_out

    ,input  logic                        rf_dir_cq_token_depth_select_wclk
    ,input  logic                        rf_dir_cq_token_depth_select_wclk_rst_n
    ,input  logic                        rf_dir_cq_token_depth_select_we
    ,input  logic [ (   6 ) -1 : 0 ]     rf_dir_cq_token_depth_select_waddr
    ,input  logic [ (   6 ) -1 : 0 ]     rf_dir_cq_token_depth_select_wdata
    ,input  logic                        rf_dir_cq_token_depth_select_rclk
    ,input  logic                        rf_dir_cq_token_depth_select_rclk_rst_n
    ,input  logic                        rf_dir_cq_token_depth_select_re
    ,input  logic [ (   6 ) -1 : 0 ]     rf_dir_cq_token_depth_select_raddr
    ,output logic [ (   6 ) -1 : 0 ]     rf_dir_cq_token_depth_select_rdata

    ,input  logic                        rf_dir_cq_token_depth_select_isol_en
    ,input  logic                        rf_dir_cq_token_depth_select_pwr_enable_b_in
    ,output logic                        rf_dir_cq_token_depth_select_pwr_enable_b_out

    ,input  logic                        rf_dir_cq_wptr_wclk
    ,input  logic                        rf_dir_cq_wptr_wclk_rst_n
    ,input  logic                        rf_dir_cq_wptr_we
    ,input  logic [ (   6 ) -1 : 0 ]     rf_dir_cq_wptr_waddr
    ,input  logic [ (  13 ) -1 : 0 ]     rf_dir_cq_wptr_wdata
    ,input  logic                        rf_dir_cq_wptr_rclk
    ,input  logic                        rf_dir_cq_wptr_rclk_rst_n
    ,input  logic                        rf_dir_cq_wptr_re
    ,input  logic [ (   6 ) -1 : 0 ]     rf_dir_cq_wptr_raddr
    ,output logic [ (  13 ) -1 : 0 ]     rf_dir_cq_wptr_rdata

    ,input  logic                        rf_dir_cq_wptr_isol_en
    ,input  logic                        rf_dir_cq_wptr_pwr_enable_b_in
    ,output logic                        rf_dir_cq_wptr_pwr_enable_b_out

    ,input  logic                        rf_dir_rply_req_fifo_mem_wclk
    ,input  logic                        rf_dir_rply_req_fifo_mem_wclk_rst_n
    ,input  logic                        rf_dir_rply_req_fifo_mem_we
    ,input  logic [ (   3 ) -1 : 0 ]     rf_dir_rply_req_fifo_mem_waddr
    ,input  logic [ (  60 ) -1 : 0 ]     rf_dir_rply_req_fifo_mem_wdata
    ,input  logic                        rf_dir_rply_req_fifo_mem_rclk
    ,input  logic                        rf_dir_rply_req_fifo_mem_rclk_rst_n
    ,input  logic                        rf_dir_rply_req_fifo_mem_re
    ,input  logic [ (   3 ) -1 : 0 ]     rf_dir_rply_req_fifo_mem_raddr
    ,output logic [ (  60 ) -1 : 0 ]     rf_dir_rply_req_fifo_mem_rdata

    ,input  logic                        rf_dir_rply_req_fifo_mem_isol_en
    ,input  logic                        rf_dir_rply_req_fifo_mem_pwr_enable_b_in
    ,output logic                        rf_dir_rply_req_fifo_mem_pwr_enable_b_out

    ,input  logic                        rf_dir_wb0_wclk
    ,input  logic                        rf_dir_wb0_wclk_rst_n
    ,input  logic                        rf_dir_wb0_we
    ,input  logic [ (   6 ) -1 : 0 ]     rf_dir_wb0_waddr
    ,input  logic [ ( 144 ) -1 : 0 ]     rf_dir_wb0_wdata
    ,input  logic                        rf_dir_wb0_rclk
    ,input  logic                        rf_dir_wb0_rclk_rst_n
    ,input  logic                        rf_dir_wb0_re
    ,input  logic [ (   6 ) -1 : 0 ]     rf_dir_wb0_raddr
    ,output logic [ ( 144 ) -1 : 0 ]     rf_dir_wb0_rdata

    ,input  logic                        rf_dir_wb0_isol_en
    ,input  logic                        rf_dir_wb0_pwr_enable_b_in
    ,output logic                        rf_dir_wb0_pwr_enable_b_out

    ,input  logic                        rf_dir_wb1_wclk
    ,input  logic                        rf_dir_wb1_wclk_rst_n
    ,input  logic                        rf_dir_wb1_we
    ,input  logic [ (   6 ) -1 : 0 ]     rf_dir_wb1_waddr
    ,input  logic [ ( 144 ) -1 : 0 ]     rf_dir_wb1_wdata
    ,input  logic                        rf_dir_wb1_rclk
    ,input  logic                        rf_dir_wb1_rclk_rst_n
    ,input  logic                        rf_dir_wb1_re
    ,input  logic [ (   6 ) -1 : 0 ]     rf_dir_wb1_raddr
    ,output logic [ ( 144 ) -1 : 0 ]     rf_dir_wb1_rdata

    ,input  logic                        rf_dir_wb1_isol_en
    ,input  logic                        rf_dir_wb1_pwr_enable_b_in
    ,output logic                        rf_dir_wb1_pwr_enable_b_out

    ,input  logic                        rf_dir_wb2_wclk
    ,input  logic                        rf_dir_wb2_wclk_rst_n
    ,input  logic                        rf_dir_wb2_we
    ,input  logic [ (   6 ) -1 : 0 ]     rf_dir_wb2_waddr
    ,input  logic [ ( 144 ) -1 : 0 ]     rf_dir_wb2_wdata
    ,input  logic                        rf_dir_wb2_rclk
    ,input  logic                        rf_dir_wb2_rclk_rst_n
    ,input  logic                        rf_dir_wb2_re
    ,input  logic [ (   6 ) -1 : 0 ]     rf_dir_wb2_raddr
    ,output logic [ ( 144 ) -1 : 0 ]     rf_dir_wb2_rdata

    ,input  logic                        rf_dir_wb2_isol_en
    ,input  logic                        rf_dir_wb2_pwr_enable_b_in
    ,output logic                        rf_dir_wb2_pwr_enable_b_out

    ,input  logic                        rf_hcw_enq_w_rx_sync_mem_wclk
    ,input  logic                        rf_hcw_enq_w_rx_sync_mem_wclk_rst_n
    ,input  logic                        rf_hcw_enq_w_rx_sync_mem_we
    ,input  logic [ (   4 ) -1 : 0 ]     rf_hcw_enq_w_rx_sync_mem_waddr
    ,input  logic [ ( 160 ) -1 : 0 ]     rf_hcw_enq_w_rx_sync_mem_wdata
    ,input  logic                        rf_hcw_enq_w_rx_sync_mem_rclk
    ,input  logic                        rf_hcw_enq_w_rx_sync_mem_rclk_rst_n
    ,input  logic                        rf_hcw_enq_w_rx_sync_mem_re
    ,input  logic [ (   4 ) -1 : 0 ]     rf_hcw_enq_w_rx_sync_mem_raddr
    ,output logic [ ( 160 ) -1 : 0 ]     rf_hcw_enq_w_rx_sync_mem_rdata

    ,input  logic                        rf_hcw_enq_w_rx_sync_mem_isol_en
    ,input  logic                        rf_hcw_enq_w_rx_sync_mem_pwr_enable_b_in
    ,output logic                        rf_hcw_enq_w_rx_sync_mem_pwr_enable_b_out

    ,input  logic                        rf_hist_list_a_minmax_wclk
    ,input  logic                        rf_hist_list_a_minmax_wclk_rst_n
    ,input  logic                        rf_hist_list_a_minmax_we
    ,input  logic [ (   6 ) -1 : 0 ]     rf_hist_list_a_minmax_waddr
    ,input  logic [ (  30 ) -1 : 0 ]     rf_hist_list_a_minmax_wdata
    ,input  logic                        rf_hist_list_a_minmax_rclk
    ,input  logic                        rf_hist_list_a_minmax_rclk_rst_n
    ,input  logic                        rf_hist_list_a_minmax_re
    ,input  logic [ (   6 ) -1 : 0 ]     rf_hist_list_a_minmax_raddr
    ,output logic [ (  30 ) -1 : 0 ]     rf_hist_list_a_minmax_rdata

    ,input  logic                        rf_hist_list_a_minmax_isol_en
    ,input  logic                        rf_hist_list_a_minmax_pwr_enable_b_in
    ,output logic                        rf_hist_list_a_minmax_pwr_enable_b_out

    ,input  logic                        rf_hist_list_a_ptr_wclk
    ,input  logic                        rf_hist_list_a_ptr_wclk_rst_n
    ,input  logic                        rf_hist_list_a_ptr_we
    ,input  logic [ (   6 ) -1 : 0 ]     rf_hist_list_a_ptr_waddr
    ,input  logic [ (  32 ) -1 : 0 ]     rf_hist_list_a_ptr_wdata
    ,input  logic                        rf_hist_list_a_ptr_rclk
    ,input  logic                        rf_hist_list_a_ptr_rclk_rst_n
    ,input  logic                        rf_hist_list_a_ptr_re
    ,input  logic [ (   6 ) -1 : 0 ]     rf_hist_list_a_ptr_raddr
    ,output logic [ (  32 ) -1 : 0 ]     rf_hist_list_a_ptr_rdata

    ,input  logic                        rf_hist_list_a_ptr_isol_en
    ,input  logic                        rf_hist_list_a_ptr_pwr_enable_b_in
    ,output logic                        rf_hist_list_a_ptr_pwr_enable_b_out

    ,input  logic                        rf_hist_list_minmax_wclk
    ,input  logic                        rf_hist_list_minmax_wclk_rst_n
    ,input  logic                        rf_hist_list_minmax_we
    ,input  logic [ (   6 ) -1 : 0 ]     rf_hist_list_minmax_waddr
    ,input  logic [ (  30 ) -1 : 0 ]     rf_hist_list_minmax_wdata
    ,input  logic                        rf_hist_list_minmax_rclk
    ,input  logic                        rf_hist_list_minmax_rclk_rst_n
    ,input  logic                        rf_hist_list_minmax_re
    ,input  logic [ (   6 ) -1 : 0 ]     rf_hist_list_minmax_raddr
    ,output logic [ (  30 ) -1 : 0 ]     rf_hist_list_minmax_rdata

    ,input  logic                        rf_hist_list_minmax_isol_en
    ,input  logic                        rf_hist_list_minmax_pwr_enable_b_in
    ,output logic                        rf_hist_list_minmax_pwr_enable_b_out

    ,input  logic                        rf_hist_list_ptr_wclk
    ,input  logic                        rf_hist_list_ptr_wclk_rst_n
    ,input  logic                        rf_hist_list_ptr_we
    ,input  logic [ (   6 ) -1 : 0 ]     rf_hist_list_ptr_waddr
    ,input  logic [ (  32 ) -1 : 0 ]     rf_hist_list_ptr_wdata
    ,input  logic                        rf_hist_list_ptr_rclk
    ,input  logic                        rf_hist_list_ptr_rclk_rst_n
    ,input  logic                        rf_hist_list_ptr_re
    ,input  logic [ (   6 ) -1 : 0 ]     rf_hist_list_ptr_raddr
    ,output logic [ (  32 ) -1 : 0 ]     rf_hist_list_ptr_rdata

    ,input  logic                        rf_hist_list_ptr_isol_en
    ,input  logic                        rf_hist_list_ptr_pwr_enable_b_in
    ,output logic                        rf_hist_list_ptr_pwr_enable_b_out

    ,input  logic                        rf_ldb_cq_depth_wclk
    ,input  logic                        rf_ldb_cq_depth_wclk_rst_n
    ,input  logic                        rf_ldb_cq_depth_we
    ,input  logic [ (   6 ) -1 : 0 ]     rf_ldb_cq_depth_waddr
    ,input  logic [ (  13 ) -1 : 0 ]     rf_ldb_cq_depth_wdata
    ,input  logic                        rf_ldb_cq_depth_rclk
    ,input  logic                        rf_ldb_cq_depth_rclk_rst_n
    ,input  logic                        rf_ldb_cq_depth_re
    ,input  logic [ (   6 ) -1 : 0 ]     rf_ldb_cq_depth_raddr
    ,output logic [ (  13 ) -1 : 0 ]     rf_ldb_cq_depth_rdata

    ,input  logic                        rf_ldb_cq_depth_isol_en
    ,input  logic                        rf_ldb_cq_depth_pwr_enable_b_in
    ,output logic                        rf_ldb_cq_depth_pwr_enable_b_out

    ,input  logic                        rf_ldb_cq_intr_thresh_wclk
    ,input  logic                        rf_ldb_cq_intr_thresh_wclk_rst_n
    ,input  logic                        rf_ldb_cq_intr_thresh_we
    ,input  logic [ (   6 ) -1 : 0 ]     rf_ldb_cq_intr_thresh_waddr
    ,input  logic [ (  13 ) -1 : 0 ]     rf_ldb_cq_intr_thresh_wdata
    ,input  logic                        rf_ldb_cq_intr_thresh_rclk
    ,input  logic                        rf_ldb_cq_intr_thresh_rclk_rst_n
    ,input  logic                        rf_ldb_cq_intr_thresh_re
    ,input  logic [ (   6 ) -1 : 0 ]     rf_ldb_cq_intr_thresh_raddr
    ,output logic [ (  13 ) -1 : 0 ]     rf_ldb_cq_intr_thresh_rdata

    ,input  logic                        rf_ldb_cq_intr_thresh_isol_en
    ,input  logic                        rf_ldb_cq_intr_thresh_pwr_enable_b_in
    ,output logic                        rf_ldb_cq_intr_thresh_pwr_enable_b_out

    ,input  logic                        rf_ldb_cq_on_off_threshold_wclk
    ,input  logic                        rf_ldb_cq_on_off_threshold_wclk_rst_n
    ,input  logic                        rf_ldb_cq_on_off_threshold_we
    ,input  logic [ (   6 ) -1 : 0 ]     rf_ldb_cq_on_off_threshold_waddr
    ,input  logic [ (  32 ) -1 : 0 ]     rf_ldb_cq_on_off_threshold_wdata
    ,input  logic                        rf_ldb_cq_on_off_threshold_rclk
    ,input  logic                        rf_ldb_cq_on_off_threshold_rclk_rst_n
    ,input  logic                        rf_ldb_cq_on_off_threshold_re
    ,input  logic [ (   6 ) -1 : 0 ]     rf_ldb_cq_on_off_threshold_raddr
    ,output logic [ (  32 ) -1 : 0 ]     rf_ldb_cq_on_off_threshold_rdata

    ,input  logic                        rf_ldb_cq_on_off_threshold_isol_en
    ,input  logic                        rf_ldb_cq_on_off_threshold_pwr_enable_b_in
    ,output logic                        rf_ldb_cq_on_off_threshold_pwr_enable_b_out

    ,input  logic                        rf_ldb_cq_token_depth_select_wclk
    ,input  logic                        rf_ldb_cq_token_depth_select_wclk_rst_n
    ,input  logic                        rf_ldb_cq_token_depth_select_we
    ,input  logic [ (   6 ) -1 : 0 ]     rf_ldb_cq_token_depth_select_waddr
    ,input  logic [ (   6 ) -1 : 0 ]     rf_ldb_cq_token_depth_select_wdata
    ,input  logic                        rf_ldb_cq_token_depth_select_rclk
    ,input  logic                        rf_ldb_cq_token_depth_select_rclk_rst_n
    ,input  logic                        rf_ldb_cq_token_depth_select_re
    ,input  logic [ (   6 ) -1 : 0 ]     rf_ldb_cq_token_depth_select_raddr
    ,output logic [ (   6 ) -1 : 0 ]     rf_ldb_cq_token_depth_select_rdata

    ,input  logic                        rf_ldb_cq_token_depth_select_isol_en
    ,input  logic                        rf_ldb_cq_token_depth_select_pwr_enable_b_in
    ,output logic                        rf_ldb_cq_token_depth_select_pwr_enable_b_out

    ,input  logic                        rf_ldb_cq_wptr_wclk
    ,input  logic                        rf_ldb_cq_wptr_wclk_rst_n
    ,input  logic                        rf_ldb_cq_wptr_we
    ,input  logic [ (   6 ) -1 : 0 ]     rf_ldb_cq_wptr_waddr
    ,input  logic [ (  13 ) -1 : 0 ]     rf_ldb_cq_wptr_wdata
    ,input  logic                        rf_ldb_cq_wptr_rclk
    ,input  logic                        rf_ldb_cq_wptr_rclk_rst_n
    ,input  logic                        rf_ldb_cq_wptr_re
    ,input  logic [ (   6 ) -1 : 0 ]     rf_ldb_cq_wptr_raddr
    ,output logic [ (  13 ) -1 : 0 ]     rf_ldb_cq_wptr_rdata

    ,input  logic                        rf_ldb_cq_wptr_isol_en
    ,input  logic                        rf_ldb_cq_wptr_pwr_enable_b_in
    ,output logic                        rf_ldb_cq_wptr_pwr_enable_b_out

    ,input  logic                        rf_ldb_rply_req_fifo_mem_wclk
    ,input  logic                        rf_ldb_rply_req_fifo_mem_wclk_rst_n
    ,input  logic                        rf_ldb_rply_req_fifo_mem_we
    ,input  logic [ (   3 ) -1 : 0 ]     rf_ldb_rply_req_fifo_mem_waddr
    ,input  logic [ (  60 ) -1 : 0 ]     rf_ldb_rply_req_fifo_mem_wdata
    ,input  logic                        rf_ldb_rply_req_fifo_mem_rclk
    ,input  logic                        rf_ldb_rply_req_fifo_mem_rclk_rst_n
    ,input  logic                        rf_ldb_rply_req_fifo_mem_re
    ,input  logic [ (   3 ) -1 : 0 ]     rf_ldb_rply_req_fifo_mem_raddr
    ,output logic [ (  60 ) -1 : 0 ]     rf_ldb_rply_req_fifo_mem_rdata

    ,input  logic                        rf_ldb_rply_req_fifo_mem_isol_en
    ,input  logic                        rf_ldb_rply_req_fifo_mem_pwr_enable_b_in
    ,output logic                        rf_ldb_rply_req_fifo_mem_pwr_enable_b_out

    ,input  logic                        rf_ldb_wb0_wclk
    ,input  logic                        rf_ldb_wb0_wclk_rst_n
    ,input  logic                        rf_ldb_wb0_we
    ,input  logic [ (   6 ) -1 : 0 ]     rf_ldb_wb0_waddr
    ,input  logic [ ( 144 ) -1 : 0 ]     rf_ldb_wb0_wdata
    ,input  logic                        rf_ldb_wb0_rclk
    ,input  logic                        rf_ldb_wb0_rclk_rst_n
    ,input  logic                        rf_ldb_wb0_re
    ,input  logic [ (   6 ) -1 : 0 ]     rf_ldb_wb0_raddr
    ,output logic [ ( 144 ) -1 : 0 ]     rf_ldb_wb0_rdata

    ,input  logic                        rf_ldb_wb0_isol_en
    ,input  logic                        rf_ldb_wb0_pwr_enable_b_in
    ,output logic                        rf_ldb_wb0_pwr_enable_b_out

    ,input  logic                        rf_ldb_wb1_wclk
    ,input  logic                        rf_ldb_wb1_wclk_rst_n
    ,input  logic                        rf_ldb_wb1_we
    ,input  logic [ (   6 ) -1 : 0 ]     rf_ldb_wb1_waddr
    ,input  logic [ ( 144 ) -1 : 0 ]     rf_ldb_wb1_wdata
    ,input  logic                        rf_ldb_wb1_rclk
    ,input  logic                        rf_ldb_wb1_rclk_rst_n
    ,input  logic                        rf_ldb_wb1_re
    ,input  logic [ (   6 ) -1 : 0 ]     rf_ldb_wb1_raddr
    ,output logic [ ( 144 ) -1 : 0 ]     rf_ldb_wb1_rdata

    ,input  logic                        rf_ldb_wb1_isol_en
    ,input  logic                        rf_ldb_wb1_pwr_enable_b_in
    ,output logic                        rf_ldb_wb1_pwr_enable_b_out

    ,input  logic                        rf_ldb_wb2_wclk
    ,input  logic                        rf_ldb_wb2_wclk_rst_n
    ,input  logic                        rf_ldb_wb2_we
    ,input  logic [ (   6 ) -1 : 0 ]     rf_ldb_wb2_waddr
    ,input  logic [ ( 144 ) -1 : 0 ]     rf_ldb_wb2_wdata
    ,input  logic                        rf_ldb_wb2_rclk
    ,input  logic                        rf_ldb_wb2_rclk_rst_n
    ,input  logic                        rf_ldb_wb2_re
    ,input  logic [ (   6 ) -1 : 0 ]     rf_ldb_wb2_raddr
    ,output logic [ ( 144 ) -1 : 0 ]     rf_ldb_wb2_rdata

    ,input  logic                        rf_ldb_wb2_isol_en
    ,input  logic                        rf_ldb_wb2_pwr_enable_b_in
    ,output logic                        rf_ldb_wb2_pwr_enable_b_out

    ,input  logic                        rf_lsp_reordercmp_fifo_mem_wclk
    ,input  logic                        rf_lsp_reordercmp_fifo_mem_wclk_rst_n
    ,input  logic                        rf_lsp_reordercmp_fifo_mem_we
    ,input  logic [ (   3 ) -1 : 0 ]     rf_lsp_reordercmp_fifo_mem_waddr
    ,input  logic [ (  19 ) -1 : 0 ]     rf_lsp_reordercmp_fifo_mem_wdata
    ,input  logic                        rf_lsp_reordercmp_fifo_mem_rclk
    ,input  logic                        rf_lsp_reordercmp_fifo_mem_rclk_rst_n
    ,input  logic                        rf_lsp_reordercmp_fifo_mem_re
    ,input  logic [ (   3 ) -1 : 0 ]     rf_lsp_reordercmp_fifo_mem_raddr
    ,output logic [ (  19 ) -1 : 0 ]     rf_lsp_reordercmp_fifo_mem_rdata

    ,input  logic                        rf_lsp_reordercmp_fifo_mem_isol_en
    ,input  logic                        rf_lsp_reordercmp_fifo_mem_pwr_enable_b_in
    ,output logic                        rf_lsp_reordercmp_fifo_mem_pwr_enable_b_out

    ,input  logic                        rf_lut_dir_cq2vf_pf_ro_wclk
    ,input  logic                        rf_lut_dir_cq2vf_pf_ro_wclk_rst_n
    ,input  logic                        rf_lut_dir_cq2vf_pf_ro_we
    ,input  logic [ (   5 ) -1 : 0 ]     rf_lut_dir_cq2vf_pf_ro_waddr
    ,input  logic [ (  13 ) -1 : 0 ]     rf_lut_dir_cq2vf_pf_ro_wdata
    ,input  logic                        rf_lut_dir_cq2vf_pf_ro_rclk
    ,input  logic                        rf_lut_dir_cq2vf_pf_ro_rclk_rst_n
    ,input  logic                        rf_lut_dir_cq2vf_pf_ro_re
    ,input  logic [ (   5 ) -1 : 0 ]     rf_lut_dir_cq2vf_pf_ro_raddr
    ,output logic [ (  13 ) -1 : 0 ]     rf_lut_dir_cq2vf_pf_ro_rdata

    ,input  logic                        rf_lut_dir_cq2vf_pf_ro_isol_en
    ,input  logic                        rf_lut_dir_cq2vf_pf_ro_pwr_enable_b_in
    ,output logic                        rf_lut_dir_cq2vf_pf_ro_pwr_enable_b_out

    ,input  logic                        rf_lut_dir_cq_addr_l_wclk
    ,input  logic                        rf_lut_dir_cq_addr_l_wclk_rst_n
    ,input  logic                        rf_lut_dir_cq_addr_l_we
    ,input  logic [ (   6 ) -1 : 0 ]     rf_lut_dir_cq_addr_l_waddr
    ,input  logic [ (  27 ) -1 : 0 ]     rf_lut_dir_cq_addr_l_wdata
    ,input  logic                        rf_lut_dir_cq_addr_l_rclk
    ,input  logic                        rf_lut_dir_cq_addr_l_rclk_rst_n
    ,input  logic                        rf_lut_dir_cq_addr_l_re
    ,input  logic [ (   6 ) -1 : 0 ]     rf_lut_dir_cq_addr_l_raddr
    ,output logic [ (  27 ) -1 : 0 ]     rf_lut_dir_cq_addr_l_rdata

    ,input  logic                        rf_lut_dir_cq_addr_l_isol_en
    ,input  logic                        rf_lut_dir_cq_addr_l_pwr_enable_b_in
    ,output logic                        rf_lut_dir_cq_addr_l_pwr_enable_b_out

    ,input  logic                        rf_lut_dir_cq_addr_u_wclk
    ,input  logic                        rf_lut_dir_cq_addr_u_wclk_rst_n
    ,input  logic                        rf_lut_dir_cq_addr_u_we
    ,input  logic [ (   6 ) -1 : 0 ]     rf_lut_dir_cq_addr_u_waddr
    ,input  logic [ (  33 ) -1 : 0 ]     rf_lut_dir_cq_addr_u_wdata
    ,input  logic                        rf_lut_dir_cq_addr_u_rclk
    ,input  logic                        rf_lut_dir_cq_addr_u_rclk_rst_n
    ,input  logic                        rf_lut_dir_cq_addr_u_re
    ,input  logic [ (   6 ) -1 : 0 ]     rf_lut_dir_cq_addr_u_raddr
    ,output logic [ (  33 ) -1 : 0 ]     rf_lut_dir_cq_addr_u_rdata

    ,input  logic                        rf_lut_dir_cq_addr_u_isol_en
    ,input  logic                        rf_lut_dir_cq_addr_u_pwr_enable_b_in
    ,output logic                        rf_lut_dir_cq_addr_u_pwr_enable_b_out

    ,input  logic                        rf_lut_dir_cq_ai_addr_l_wclk
    ,input  logic                        rf_lut_dir_cq_ai_addr_l_wclk_rst_n
    ,input  logic                        rf_lut_dir_cq_ai_addr_l_we
    ,input  logic [ (   6 ) -1 : 0 ]     rf_lut_dir_cq_ai_addr_l_waddr
    ,input  logic [ (  31 ) -1 : 0 ]     rf_lut_dir_cq_ai_addr_l_wdata
    ,input  logic                        rf_lut_dir_cq_ai_addr_l_rclk
    ,input  logic                        rf_lut_dir_cq_ai_addr_l_rclk_rst_n
    ,input  logic                        rf_lut_dir_cq_ai_addr_l_re
    ,input  logic [ (   6 ) -1 : 0 ]     rf_lut_dir_cq_ai_addr_l_raddr
    ,output logic [ (  31 ) -1 : 0 ]     rf_lut_dir_cq_ai_addr_l_rdata

    ,input  logic                        rf_lut_dir_cq_ai_addr_l_isol_en
    ,input  logic                        rf_lut_dir_cq_ai_addr_l_pwr_enable_b_in
    ,output logic                        rf_lut_dir_cq_ai_addr_l_pwr_enable_b_out

    ,input  logic                        rf_lut_dir_cq_ai_addr_u_wclk
    ,input  logic                        rf_lut_dir_cq_ai_addr_u_wclk_rst_n
    ,input  logic                        rf_lut_dir_cq_ai_addr_u_we
    ,input  logic [ (   6 ) -1 : 0 ]     rf_lut_dir_cq_ai_addr_u_waddr
    ,input  logic [ (  33 ) -1 : 0 ]     rf_lut_dir_cq_ai_addr_u_wdata
    ,input  logic                        rf_lut_dir_cq_ai_addr_u_rclk
    ,input  logic                        rf_lut_dir_cq_ai_addr_u_rclk_rst_n
    ,input  logic                        rf_lut_dir_cq_ai_addr_u_re
    ,input  logic [ (   6 ) -1 : 0 ]     rf_lut_dir_cq_ai_addr_u_raddr
    ,output logic [ (  33 ) -1 : 0 ]     rf_lut_dir_cq_ai_addr_u_rdata

    ,input  logic                        rf_lut_dir_cq_ai_addr_u_isol_en
    ,input  logic                        rf_lut_dir_cq_ai_addr_u_pwr_enable_b_in
    ,output logic                        rf_lut_dir_cq_ai_addr_u_pwr_enable_b_out

    ,input  logic                        rf_lut_dir_cq_ai_data_wclk
    ,input  logic                        rf_lut_dir_cq_ai_data_wclk_rst_n
    ,input  logic                        rf_lut_dir_cq_ai_data_we
    ,input  logic [ (   6 ) -1 : 0 ]     rf_lut_dir_cq_ai_data_waddr
    ,input  logic [ (  33 ) -1 : 0 ]     rf_lut_dir_cq_ai_data_wdata
    ,input  logic                        rf_lut_dir_cq_ai_data_rclk
    ,input  logic                        rf_lut_dir_cq_ai_data_rclk_rst_n
    ,input  logic                        rf_lut_dir_cq_ai_data_re
    ,input  logic [ (   6 ) -1 : 0 ]     rf_lut_dir_cq_ai_data_raddr
    ,output logic [ (  33 ) -1 : 0 ]     rf_lut_dir_cq_ai_data_rdata

    ,input  logic                        rf_lut_dir_cq_ai_data_isol_en
    ,input  logic                        rf_lut_dir_cq_ai_data_pwr_enable_b_in
    ,output logic                        rf_lut_dir_cq_ai_data_pwr_enable_b_out

    ,input  logic                        rf_lut_dir_cq_isr_wclk
    ,input  logic                        rf_lut_dir_cq_isr_wclk_rst_n
    ,input  logic                        rf_lut_dir_cq_isr_we
    ,input  logic [ (   6 ) -1 : 0 ]     rf_lut_dir_cq_isr_waddr
    ,input  logic [ (  13 ) -1 : 0 ]     rf_lut_dir_cq_isr_wdata
    ,input  logic                        rf_lut_dir_cq_isr_rclk
    ,input  logic                        rf_lut_dir_cq_isr_rclk_rst_n
    ,input  logic                        rf_lut_dir_cq_isr_re
    ,input  logic [ (   6 ) -1 : 0 ]     rf_lut_dir_cq_isr_raddr
    ,output logic [ (  13 ) -1 : 0 ]     rf_lut_dir_cq_isr_rdata

    ,input  logic                        rf_lut_dir_cq_isr_isol_en
    ,input  logic                        rf_lut_dir_cq_isr_pwr_enable_b_in
    ,output logic                        rf_lut_dir_cq_isr_pwr_enable_b_out

    ,input  logic                        rf_lut_dir_cq_pasid_wclk
    ,input  logic                        rf_lut_dir_cq_pasid_wclk_rst_n
    ,input  logic                        rf_lut_dir_cq_pasid_we
    ,input  logic [ (   6 ) -1 : 0 ]     rf_lut_dir_cq_pasid_waddr
    ,input  logic [ (  24 ) -1 : 0 ]     rf_lut_dir_cq_pasid_wdata
    ,input  logic                        rf_lut_dir_cq_pasid_rclk
    ,input  logic                        rf_lut_dir_cq_pasid_rclk_rst_n
    ,input  logic                        rf_lut_dir_cq_pasid_re
    ,input  logic [ (   6 ) -1 : 0 ]     rf_lut_dir_cq_pasid_raddr
    ,output logic [ (  24 ) -1 : 0 ]     rf_lut_dir_cq_pasid_rdata

    ,input  logic                        rf_lut_dir_cq_pasid_isol_en
    ,input  logic                        rf_lut_dir_cq_pasid_pwr_enable_b_in
    ,output logic                        rf_lut_dir_cq_pasid_pwr_enable_b_out

    ,input  logic                        rf_lut_dir_pp2vas_wclk
    ,input  logic                        rf_lut_dir_pp2vas_wclk_rst_n
    ,input  logic                        rf_lut_dir_pp2vas_we
    ,input  logic [ (   5 ) -1 : 0 ]     rf_lut_dir_pp2vas_waddr
    ,input  logic [ (  11 ) -1 : 0 ]     rf_lut_dir_pp2vas_wdata
    ,input  logic                        rf_lut_dir_pp2vas_rclk
    ,input  logic                        rf_lut_dir_pp2vas_rclk_rst_n
    ,input  logic                        rf_lut_dir_pp2vas_re
    ,input  logic [ (   5 ) -1 : 0 ]     rf_lut_dir_pp2vas_raddr
    ,output logic [ (  11 ) -1 : 0 ]     rf_lut_dir_pp2vas_rdata

    ,input  logic                        rf_lut_dir_pp2vas_isol_en
    ,input  logic                        rf_lut_dir_pp2vas_pwr_enable_b_in
    ,output logic                        rf_lut_dir_pp2vas_pwr_enable_b_out

    ,input  logic                        rf_lut_dir_pp_v_wclk
    ,input  logic                        rf_lut_dir_pp_v_wclk_rst_n
    ,input  logic                        rf_lut_dir_pp_v_we
    ,input  logic [ (   2 ) -1 : 0 ]     rf_lut_dir_pp_v_waddr
    ,input  logic [ (  17 ) -1 : 0 ]     rf_lut_dir_pp_v_wdata
    ,input  logic                        rf_lut_dir_pp_v_rclk
    ,input  logic                        rf_lut_dir_pp_v_rclk_rst_n
    ,input  logic                        rf_lut_dir_pp_v_re
    ,input  logic [ (   2 ) -1 : 0 ]     rf_lut_dir_pp_v_raddr
    ,output logic [ (  17 ) -1 : 0 ]     rf_lut_dir_pp_v_rdata

    ,input  logic                        rf_lut_dir_pp_v_isol_en
    ,input  logic                        rf_lut_dir_pp_v_pwr_enable_b_in
    ,output logic                        rf_lut_dir_pp_v_pwr_enable_b_out

    ,input  logic                        rf_lut_dir_vasqid_v_wclk
    ,input  logic                        rf_lut_dir_vasqid_v_wclk_rst_n
    ,input  logic                        rf_lut_dir_vasqid_v_we
    ,input  logic [ (   6 ) -1 : 0 ]     rf_lut_dir_vasqid_v_waddr
    ,input  logic [ (  33 ) -1 : 0 ]     rf_lut_dir_vasqid_v_wdata
    ,input  logic                        rf_lut_dir_vasqid_v_rclk
    ,input  logic                        rf_lut_dir_vasqid_v_rclk_rst_n
    ,input  logic                        rf_lut_dir_vasqid_v_re
    ,input  logic [ (   6 ) -1 : 0 ]     rf_lut_dir_vasqid_v_raddr
    ,output logic [ (  33 ) -1 : 0 ]     rf_lut_dir_vasqid_v_rdata

    ,input  logic                        rf_lut_dir_vasqid_v_isol_en
    ,input  logic                        rf_lut_dir_vasqid_v_pwr_enable_b_in
    ,output logic                        rf_lut_dir_vasqid_v_pwr_enable_b_out

    ,input  logic                        rf_lut_ldb_cq2vf_pf_ro_wclk
    ,input  logic                        rf_lut_ldb_cq2vf_pf_ro_wclk_rst_n
    ,input  logic                        rf_lut_ldb_cq2vf_pf_ro_we
    ,input  logic [ (   5 ) -1 : 0 ]     rf_lut_ldb_cq2vf_pf_ro_waddr
    ,input  logic [ (  13 ) -1 : 0 ]     rf_lut_ldb_cq2vf_pf_ro_wdata
    ,input  logic                        rf_lut_ldb_cq2vf_pf_ro_rclk
    ,input  logic                        rf_lut_ldb_cq2vf_pf_ro_rclk_rst_n
    ,input  logic                        rf_lut_ldb_cq2vf_pf_ro_re
    ,input  logic [ (   5 ) -1 : 0 ]     rf_lut_ldb_cq2vf_pf_ro_raddr
    ,output logic [ (  13 ) -1 : 0 ]     rf_lut_ldb_cq2vf_pf_ro_rdata

    ,input  logic                        rf_lut_ldb_cq2vf_pf_ro_isol_en
    ,input  logic                        rf_lut_ldb_cq2vf_pf_ro_pwr_enable_b_in
    ,output logic                        rf_lut_ldb_cq2vf_pf_ro_pwr_enable_b_out

    ,input  logic                        rf_lut_ldb_cq_addr_l_wclk
    ,input  logic                        rf_lut_ldb_cq_addr_l_wclk_rst_n
    ,input  logic                        rf_lut_ldb_cq_addr_l_we
    ,input  logic [ (   6 ) -1 : 0 ]     rf_lut_ldb_cq_addr_l_waddr
    ,input  logic [ (  27 ) -1 : 0 ]     rf_lut_ldb_cq_addr_l_wdata
    ,input  logic                        rf_lut_ldb_cq_addr_l_rclk
    ,input  logic                        rf_lut_ldb_cq_addr_l_rclk_rst_n
    ,input  logic                        rf_lut_ldb_cq_addr_l_re
    ,input  logic [ (   6 ) -1 : 0 ]     rf_lut_ldb_cq_addr_l_raddr
    ,output logic [ (  27 ) -1 : 0 ]     rf_lut_ldb_cq_addr_l_rdata

    ,input  logic                        rf_lut_ldb_cq_addr_l_isol_en
    ,input  logic                        rf_lut_ldb_cq_addr_l_pwr_enable_b_in
    ,output logic                        rf_lut_ldb_cq_addr_l_pwr_enable_b_out

    ,input  logic                        rf_lut_ldb_cq_addr_u_wclk
    ,input  logic                        rf_lut_ldb_cq_addr_u_wclk_rst_n
    ,input  logic                        rf_lut_ldb_cq_addr_u_we
    ,input  logic [ (   6 ) -1 : 0 ]     rf_lut_ldb_cq_addr_u_waddr
    ,input  logic [ (  33 ) -1 : 0 ]     rf_lut_ldb_cq_addr_u_wdata
    ,input  logic                        rf_lut_ldb_cq_addr_u_rclk
    ,input  logic                        rf_lut_ldb_cq_addr_u_rclk_rst_n
    ,input  logic                        rf_lut_ldb_cq_addr_u_re
    ,input  logic [ (   6 ) -1 : 0 ]     rf_lut_ldb_cq_addr_u_raddr
    ,output logic [ (  33 ) -1 : 0 ]     rf_lut_ldb_cq_addr_u_rdata

    ,input  logic                        rf_lut_ldb_cq_addr_u_isol_en
    ,input  logic                        rf_lut_ldb_cq_addr_u_pwr_enable_b_in
    ,output logic                        rf_lut_ldb_cq_addr_u_pwr_enable_b_out

    ,input  logic                        rf_lut_ldb_cq_ai_addr_l_wclk
    ,input  logic                        rf_lut_ldb_cq_ai_addr_l_wclk_rst_n
    ,input  logic                        rf_lut_ldb_cq_ai_addr_l_we
    ,input  logic [ (   6 ) -1 : 0 ]     rf_lut_ldb_cq_ai_addr_l_waddr
    ,input  logic [ (  31 ) -1 : 0 ]     rf_lut_ldb_cq_ai_addr_l_wdata
    ,input  logic                        rf_lut_ldb_cq_ai_addr_l_rclk
    ,input  logic                        rf_lut_ldb_cq_ai_addr_l_rclk_rst_n
    ,input  logic                        rf_lut_ldb_cq_ai_addr_l_re
    ,input  logic [ (   6 ) -1 : 0 ]     rf_lut_ldb_cq_ai_addr_l_raddr
    ,output logic [ (  31 ) -1 : 0 ]     rf_lut_ldb_cq_ai_addr_l_rdata

    ,input  logic                        rf_lut_ldb_cq_ai_addr_l_isol_en
    ,input  logic                        rf_lut_ldb_cq_ai_addr_l_pwr_enable_b_in
    ,output logic                        rf_lut_ldb_cq_ai_addr_l_pwr_enable_b_out

    ,input  logic                        rf_lut_ldb_cq_ai_addr_u_wclk
    ,input  logic                        rf_lut_ldb_cq_ai_addr_u_wclk_rst_n
    ,input  logic                        rf_lut_ldb_cq_ai_addr_u_we
    ,input  logic [ (   6 ) -1 : 0 ]     rf_lut_ldb_cq_ai_addr_u_waddr
    ,input  logic [ (  33 ) -1 : 0 ]     rf_lut_ldb_cq_ai_addr_u_wdata
    ,input  logic                        rf_lut_ldb_cq_ai_addr_u_rclk
    ,input  logic                        rf_lut_ldb_cq_ai_addr_u_rclk_rst_n
    ,input  logic                        rf_lut_ldb_cq_ai_addr_u_re
    ,input  logic [ (   6 ) -1 : 0 ]     rf_lut_ldb_cq_ai_addr_u_raddr
    ,output logic [ (  33 ) -1 : 0 ]     rf_lut_ldb_cq_ai_addr_u_rdata

    ,input  logic                        rf_lut_ldb_cq_ai_addr_u_isol_en
    ,input  logic                        rf_lut_ldb_cq_ai_addr_u_pwr_enable_b_in
    ,output logic                        rf_lut_ldb_cq_ai_addr_u_pwr_enable_b_out

    ,input  logic                        rf_lut_ldb_cq_ai_data_wclk
    ,input  logic                        rf_lut_ldb_cq_ai_data_wclk_rst_n
    ,input  logic                        rf_lut_ldb_cq_ai_data_we
    ,input  logic [ (   6 ) -1 : 0 ]     rf_lut_ldb_cq_ai_data_waddr
    ,input  logic [ (  33 ) -1 : 0 ]     rf_lut_ldb_cq_ai_data_wdata
    ,input  logic                        rf_lut_ldb_cq_ai_data_rclk
    ,input  logic                        rf_lut_ldb_cq_ai_data_rclk_rst_n
    ,input  logic                        rf_lut_ldb_cq_ai_data_re
    ,input  logic [ (   6 ) -1 : 0 ]     rf_lut_ldb_cq_ai_data_raddr
    ,output logic [ (  33 ) -1 : 0 ]     rf_lut_ldb_cq_ai_data_rdata

    ,input  logic                        rf_lut_ldb_cq_ai_data_isol_en
    ,input  logic                        rf_lut_ldb_cq_ai_data_pwr_enable_b_in
    ,output logic                        rf_lut_ldb_cq_ai_data_pwr_enable_b_out

    ,input  logic                        rf_lut_ldb_cq_isr_wclk
    ,input  logic                        rf_lut_ldb_cq_isr_wclk_rst_n
    ,input  logic                        rf_lut_ldb_cq_isr_we
    ,input  logic [ (   6 ) -1 : 0 ]     rf_lut_ldb_cq_isr_waddr
    ,input  logic [ (  13 ) -1 : 0 ]     rf_lut_ldb_cq_isr_wdata
    ,input  logic                        rf_lut_ldb_cq_isr_rclk
    ,input  logic                        rf_lut_ldb_cq_isr_rclk_rst_n
    ,input  logic                        rf_lut_ldb_cq_isr_re
    ,input  logic [ (   6 ) -1 : 0 ]     rf_lut_ldb_cq_isr_raddr
    ,output logic [ (  13 ) -1 : 0 ]     rf_lut_ldb_cq_isr_rdata

    ,input  logic                        rf_lut_ldb_cq_isr_isol_en
    ,input  logic                        rf_lut_ldb_cq_isr_pwr_enable_b_in
    ,output logic                        rf_lut_ldb_cq_isr_pwr_enable_b_out

    ,input  logic                        rf_lut_ldb_cq_pasid_wclk
    ,input  logic                        rf_lut_ldb_cq_pasid_wclk_rst_n
    ,input  logic                        rf_lut_ldb_cq_pasid_we
    ,input  logic [ (   6 ) -1 : 0 ]     rf_lut_ldb_cq_pasid_waddr
    ,input  logic [ (  24 ) -1 : 0 ]     rf_lut_ldb_cq_pasid_wdata
    ,input  logic                        rf_lut_ldb_cq_pasid_rclk
    ,input  logic                        rf_lut_ldb_cq_pasid_rclk_rst_n
    ,input  logic                        rf_lut_ldb_cq_pasid_re
    ,input  logic [ (   6 ) -1 : 0 ]     rf_lut_ldb_cq_pasid_raddr
    ,output logic [ (  24 ) -1 : 0 ]     rf_lut_ldb_cq_pasid_rdata

    ,input  logic                        rf_lut_ldb_cq_pasid_isol_en
    ,input  logic                        rf_lut_ldb_cq_pasid_pwr_enable_b_in
    ,output logic                        rf_lut_ldb_cq_pasid_pwr_enable_b_out

    ,input  logic                        rf_lut_ldb_pp2vas_wclk
    ,input  logic                        rf_lut_ldb_pp2vas_wclk_rst_n
    ,input  logic                        rf_lut_ldb_pp2vas_we
    ,input  logic [ (   5 ) -1 : 0 ]     rf_lut_ldb_pp2vas_waddr
    ,input  logic [ (  11 ) -1 : 0 ]     rf_lut_ldb_pp2vas_wdata
    ,input  logic                        rf_lut_ldb_pp2vas_rclk
    ,input  logic                        rf_lut_ldb_pp2vas_rclk_rst_n
    ,input  logic                        rf_lut_ldb_pp2vas_re
    ,input  logic [ (   5 ) -1 : 0 ]     rf_lut_ldb_pp2vas_raddr
    ,output logic [ (  11 ) -1 : 0 ]     rf_lut_ldb_pp2vas_rdata

    ,input  logic                        rf_lut_ldb_pp2vas_isol_en
    ,input  logic                        rf_lut_ldb_pp2vas_pwr_enable_b_in
    ,output logic                        rf_lut_ldb_pp2vas_pwr_enable_b_out

    ,input  logic                        rf_lut_ldb_qid2vqid_wclk
    ,input  logic                        rf_lut_ldb_qid2vqid_wclk_rst_n
    ,input  logic                        rf_lut_ldb_qid2vqid_we
    ,input  logic [ (   3 ) -1 : 0 ]     rf_lut_ldb_qid2vqid_waddr
    ,input  logic [ (  21 ) -1 : 0 ]     rf_lut_ldb_qid2vqid_wdata
    ,input  logic                        rf_lut_ldb_qid2vqid_rclk
    ,input  logic                        rf_lut_ldb_qid2vqid_rclk_rst_n
    ,input  logic                        rf_lut_ldb_qid2vqid_re
    ,input  logic [ (   3 ) -1 : 0 ]     rf_lut_ldb_qid2vqid_raddr
    ,output logic [ (  21 ) -1 : 0 ]     rf_lut_ldb_qid2vqid_rdata

    ,input  logic                        rf_lut_ldb_qid2vqid_isol_en
    ,input  logic                        rf_lut_ldb_qid2vqid_pwr_enable_b_in
    ,output logic                        rf_lut_ldb_qid2vqid_pwr_enable_b_out

    ,input  logic                        rf_lut_ldb_vasqid_v_wclk
    ,input  logic                        rf_lut_ldb_vasqid_v_wclk_rst_n
    ,input  logic                        rf_lut_ldb_vasqid_v_we
    ,input  logic [ (   6 ) -1 : 0 ]     rf_lut_ldb_vasqid_v_waddr
    ,input  logic [ (  17 ) -1 : 0 ]     rf_lut_ldb_vasqid_v_wdata
    ,input  logic                        rf_lut_ldb_vasqid_v_rclk
    ,input  logic                        rf_lut_ldb_vasqid_v_rclk_rst_n
    ,input  logic                        rf_lut_ldb_vasqid_v_re
    ,input  logic [ (   6 ) -1 : 0 ]     rf_lut_ldb_vasqid_v_raddr
    ,output logic [ (  17 ) -1 : 0 ]     rf_lut_ldb_vasqid_v_rdata

    ,input  logic                        rf_lut_ldb_vasqid_v_isol_en
    ,input  logic                        rf_lut_ldb_vasqid_v_pwr_enable_b_in
    ,output logic                        rf_lut_ldb_vasqid_v_pwr_enable_b_out

    ,input  logic                        rf_lut_vf_dir_vpp2pp_wclk
    ,input  logic                        rf_lut_vf_dir_vpp2pp_wclk_rst_n
    ,input  logic                        rf_lut_vf_dir_vpp2pp_we
    ,input  logic [ (   8 ) -1 : 0 ]     rf_lut_vf_dir_vpp2pp_waddr
    ,input  logic [ (  31 ) -1 : 0 ]     rf_lut_vf_dir_vpp2pp_wdata
    ,input  logic                        rf_lut_vf_dir_vpp2pp_rclk
    ,input  logic                        rf_lut_vf_dir_vpp2pp_rclk_rst_n
    ,input  logic                        rf_lut_vf_dir_vpp2pp_re
    ,input  logic [ (   8 ) -1 : 0 ]     rf_lut_vf_dir_vpp2pp_raddr
    ,output logic [ (  31 ) -1 : 0 ]     rf_lut_vf_dir_vpp2pp_rdata

    ,input  logic                        rf_lut_vf_dir_vpp2pp_isol_en
    ,input  logic                        rf_lut_vf_dir_vpp2pp_pwr_enable_b_in
    ,output logic                        rf_lut_vf_dir_vpp2pp_pwr_enable_b_out

    ,input  logic                        rf_lut_vf_dir_vpp_v_wclk
    ,input  logic                        rf_lut_vf_dir_vpp_v_wclk_rst_n
    ,input  logic                        rf_lut_vf_dir_vpp_v_we
    ,input  logic [ (   6 ) -1 : 0 ]     rf_lut_vf_dir_vpp_v_waddr
    ,input  logic [ (  17 ) -1 : 0 ]     rf_lut_vf_dir_vpp_v_wdata
    ,input  logic                        rf_lut_vf_dir_vpp_v_rclk
    ,input  logic                        rf_lut_vf_dir_vpp_v_rclk_rst_n
    ,input  logic                        rf_lut_vf_dir_vpp_v_re
    ,input  logic [ (   6 ) -1 : 0 ]     rf_lut_vf_dir_vpp_v_raddr
    ,output logic [ (  17 ) -1 : 0 ]     rf_lut_vf_dir_vpp_v_rdata

    ,input  logic                        rf_lut_vf_dir_vpp_v_isol_en
    ,input  logic                        rf_lut_vf_dir_vpp_v_pwr_enable_b_in
    ,output logic                        rf_lut_vf_dir_vpp_v_pwr_enable_b_out

    ,input  logic                        rf_lut_vf_dir_vqid2qid_wclk
    ,input  logic                        rf_lut_vf_dir_vqid2qid_wclk_rst_n
    ,input  logic                        rf_lut_vf_dir_vqid2qid_we
    ,input  logic [ (   8 ) -1 : 0 ]     rf_lut_vf_dir_vqid2qid_waddr
    ,input  logic [ (  31 ) -1 : 0 ]     rf_lut_vf_dir_vqid2qid_wdata
    ,input  logic                        rf_lut_vf_dir_vqid2qid_rclk
    ,input  logic                        rf_lut_vf_dir_vqid2qid_rclk_rst_n
    ,input  logic                        rf_lut_vf_dir_vqid2qid_re
    ,input  logic [ (   8 ) -1 : 0 ]     rf_lut_vf_dir_vqid2qid_raddr
    ,output logic [ (  31 ) -1 : 0 ]     rf_lut_vf_dir_vqid2qid_rdata

    ,input  logic                        rf_lut_vf_dir_vqid2qid_isol_en
    ,input  logic                        rf_lut_vf_dir_vqid2qid_pwr_enable_b_in
    ,output logic                        rf_lut_vf_dir_vqid2qid_pwr_enable_b_out

    ,input  logic                        rf_lut_vf_dir_vqid_v_wclk
    ,input  logic                        rf_lut_vf_dir_vqid_v_wclk_rst_n
    ,input  logic                        rf_lut_vf_dir_vqid_v_we
    ,input  logic [ (   6 ) -1 : 0 ]     rf_lut_vf_dir_vqid_v_waddr
    ,input  logic [ (  17 ) -1 : 0 ]     rf_lut_vf_dir_vqid_v_wdata
    ,input  logic                        rf_lut_vf_dir_vqid_v_rclk
    ,input  logic                        rf_lut_vf_dir_vqid_v_rclk_rst_n
    ,input  logic                        rf_lut_vf_dir_vqid_v_re
    ,input  logic [ (   6 ) -1 : 0 ]     rf_lut_vf_dir_vqid_v_raddr
    ,output logic [ (  17 ) -1 : 0 ]     rf_lut_vf_dir_vqid_v_rdata

    ,input  logic                        rf_lut_vf_dir_vqid_v_isol_en
    ,input  logic                        rf_lut_vf_dir_vqid_v_pwr_enable_b_in
    ,output logic                        rf_lut_vf_dir_vqid_v_pwr_enable_b_out

    ,input  logic                        rf_lut_vf_ldb_vpp2pp_wclk
    ,input  logic                        rf_lut_vf_ldb_vpp2pp_wclk_rst_n
    ,input  logic                        rf_lut_vf_ldb_vpp2pp_we
    ,input  logic [ (   8 ) -1 : 0 ]     rf_lut_vf_ldb_vpp2pp_waddr
    ,input  logic [ (  25 ) -1 : 0 ]     rf_lut_vf_ldb_vpp2pp_wdata
    ,input  logic                        rf_lut_vf_ldb_vpp2pp_rclk
    ,input  logic                        rf_lut_vf_ldb_vpp2pp_rclk_rst_n
    ,input  logic                        rf_lut_vf_ldb_vpp2pp_re
    ,input  logic [ (   8 ) -1 : 0 ]     rf_lut_vf_ldb_vpp2pp_raddr
    ,output logic [ (  25 ) -1 : 0 ]     rf_lut_vf_ldb_vpp2pp_rdata

    ,input  logic                        rf_lut_vf_ldb_vpp2pp_isol_en
    ,input  logic                        rf_lut_vf_ldb_vpp2pp_pwr_enable_b_in
    ,output logic                        rf_lut_vf_ldb_vpp2pp_pwr_enable_b_out

    ,input  logic                        rf_lut_vf_ldb_vpp_v_wclk
    ,input  logic                        rf_lut_vf_ldb_vpp_v_wclk_rst_n
    ,input  logic                        rf_lut_vf_ldb_vpp_v_we
    ,input  logic [ (   6 ) -1 : 0 ]     rf_lut_vf_ldb_vpp_v_waddr
    ,input  logic [ (  17 ) -1 : 0 ]     rf_lut_vf_ldb_vpp_v_wdata
    ,input  logic                        rf_lut_vf_ldb_vpp_v_rclk
    ,input  logic                        rf_lut_vf_ldb_vpp_v_rclk_rst_n
    ,input  logic                        rf_lut_vf_ldb_vpp_v_re
    ,input  logic [ (   6 ) -1 : 0 ]     rf_lut_vf_ldb_vpp_v_raddr
    ,output logic [ (  17 ) -1 : 0 ]     rf_lut_vf_ldb_vpp_v_rdata

    ,input  logic                        rf_lut_vf_ldb_vpp_v_isol_en
    ,input  logic                        rf_lut_vf_ldb_vpp_v_pwr_enable_b_in
    ,output logic                        rf_lut_vf_ldb_vpp_v_pwr_enable_b_out

    ,input  logic                        rf_lut_vf_ldb_vqid2qid_wclk
    ,input  logic                        rf_lut_vf_ldb_vqid2qid_wclk_rst_n
    ,input  logic                        rf_lut_vf_ldb_vqid2qid_we
    ,input  logic [ (   7 ) -1 : 0 ]     rf_lut_vf_ldb_vqid2qid_waddr
    ,input  logic [ (  27 ) -1 : 0 ]     rf_lut_vf_ldb_vqid2qid_wdata
    ,input  logic                        rf_lut_vf_ldb_vqid2qid_rclk
    ,input  logic                        rf_lut_vf_ldb_vqid2qid_rclk_rst_n
    ,input  logic                        rf_lut_vf_ldb_vqid2qid_re
    ,input  logic [ (   7 ) -1 : 0 ]     rf_lut_vf_ldb_vqid2qid_raddr
    ,output logic [ (  27 ) -1 : 0 ]     rf_lut_vf_ldb_vqid2qid_rdata

    ,input  logic                        rf_lut_vf_ldb_vqid2qid_isol_en
    ,input  logic                        rf_lut_vf_ldb_vqid2qid_pwr_enable_b_in
    ,output logic                        rf_lut_vf_ldb_vqid2qid_pwr_enable_b_out

    ,input  logic                        rf_lut_vf_ldb_vqid_v_wclk
    ,input  logic                        rf_lut_vf_ldb_vqid_v_wclk_rst_n
    ,input  logic                        rf_lut_vf_ldb_vqid_v_we
    ,input  logic [ (   5 ) -1 : 0 ]     rf_lut_vf_ldb_vqid_v_waddr
    ,input  logic [ (  17 ) -1 : 0 ]     rf_lut_vf_ldb_vqid_v_wdata
    ,input  logic                        rf_lut_vf_ldb_vqid_v_rclk
    ,input  logic                        rf_lut_vf_ldb_vqid_v_rclk_rst_n
    ,input  logic                        rf_lut_vf_ldb_vqid_v_re
    ,input  logic [ (   5 ) -1 : 0 ]     rf_lut_vf_ldb_vqid_v_raddr
    ,output logic [ (  17 ) -1 : 0 ]     rf_lut_vf_ldb_vqid_v_rdata

    ,input  logic                        rf_lut_vf_ldb_vqid_v_isol_en
    ,input  logic                        rf_lut_vf_ldb_vqid_v_pwr_enable_b_in
    ,output logic                        rf_lut_vf_ldb_vqid_v_pwr_enable_b_out

    ,input  logic                        rf_msix_tbl_word0_wclk
    ,input  logic                        rf_msix_tbl_word0_wclk_rst_n
    ,input  logic                        rf_msix_tbl_word0_we
    ,input  logic [ (   6 ) -1 : 0 ]     rf_msix_tbl_word0_waddr
    ,input  logic [ (  33 ) -1 : 0 ]     rf_msix_tbl_word0_wdata
    ,input  logic                        rf_msix_tbl_word0_rclk
    ,input  logic                        rf_msix_tbl_word0_rclk_rst_n
    ,input  logic                        rf_msix_tbl_word0_re
    ,input  logic [ (   6 ) -1 : 0 ]     rf_msix_tbl_word0_raddr
    ,output logic [ (  33 ) -1 : 0 ]     rf_msix_tbl_word0_rdata

    ,input  logic                        rf_msix_tbl_word0_isol_en
    ,input  logic                        rf_msix_tbl_word0_pwr_enable_b_in
    ,output logic                        rf_msix_tbl_word0_pwr_enable_b_out

    ,input  logic                        rf_msix_tbl_word1_wclk
    ,input  logic                        rf_msix_tbl_word1_wclk_rst_n
    ,input  logic                        rf_msix_tbl_word1_we
    ,input  logic [ (   6 ) -1 : 0 ]     rf_msix_tbl_word1_waddr
    ,input  logic [ (  33 ) -1 : 0 ]     rf_msix_tbl_word1_wdata
    ,input  logic                        rf_msix_tbl_word1_rclk
    ,input  logic                        rf_msix_tbl_word1_rclk_rst_n
    ,input  logic                        rf_msix_tbl_word1_re
    ,input  logic [ (   6 ) -1 : 0 ]     rf_msix_tbl_word1_raddr
    ,output logic [ (  33 ) -1 : 0 ]     rf_msix_tbl_word1_rdata

    ,input  logic                        rf_msix_tbl_word1_isol_en
    ,input  logic                        rf_msix_tbl_word1_pwr_enable_b_in
    ,output logic                        rf_msix_tbl_word1_pwr_enable_b_out

    ,input  logic                        rf_msix_tbl_word2_wclk
    ,input  logic                        rf_msix_tbl_word2_wclk_rst_n
    ,input  logic                        rf_msix_tbl_word2_we
    ,input  logic [ (   6 ) -1 : 0 ]     rf_msix_tbl_word2_waddr
    ,input  logic [ (  33 ) -1 : 0 ]     rf_msix_tbl_word2_wdata
    ,input  logic                        rf_msix_tbl_word2_rclk
    ,input  logic                        rf_msix_tbl_word2_rclk_rst_n
    ,input  logic                        rf_msix_tbl_word2_re
    ,input  logic [ (   6 ) -1 : 0 ]     rf_msix_tbl_word2_raddr
    ,output logic [ (  33 ) -1 : 0 ]     rf_msix_tbl_word2_rdata

    ,input  logic                        rf_msix_tbl_word2_isol_en
    ,input  logic                        rf_msix_tbl_word2_pwr_enable_b_in
    ,output logic                        rf_msix_tbl_word2_pwr_enable_b_out

    ,input  logic                        rf_ord_qid_sn_wclk
    ,input  logic                        rf_ord_qid_sn_wclk_rst_n
    ,input  logic                        rf_ord_qid_sn_we
    ,input  logic [ (   5 ) -1 : 0 ]     rf_ord_qid_sn_waddr
    ,input  logic [ (  12 ) -1 : 0 ]     rf_ord_qid_sn_wdata
    ,input  logic                        rf_ord_qid_sn_rclk
    ,input  logic                        rf_ord_qid_sn_rclk_rst_n
    ,input  logic                        rf_ord_qid_sn_re
    ,input  logic [ (   5 ) -1 : 0 ]     rf_ord_qid_sn_raddr
    ,output logic [ (  12 ) -1 : 0 ]     rf_ord_qid_sn_rdata

    ,input  logic                        rf_ord_qid_sn_isol_en
    ,input  logic                        rf_ord_qid_sn_pwr_enable_b_in
    ,output logic                        rf_ord_qid_sn_pwr_enable_b_out

    ,input  logic                        rf_ord_qid_sn_map_wclk
    ,input  logic                        rf_ord_qid_sn_map_wclk_rst_n
    ,input  logic                        rf_ord_qid_sn_map_we
    ,input  logic [ (   5 ) -1 : 0 ]     rf_ord_qid_sn_map_waddr
    ,input  logic [ (  12 ) -1 : 0 ]     rf_ord_qid_sn_map_wdata
    ,input  logic                        rf_ord_qid_sn_map_rclk
    ,input  logic                        rf_ord_qid_sn_map_rclk_rst_n
    ,input  logic                        rf_ord_qid_sn_map_re
    ,input  logic [ (   5 ) -1 : 0 ]     rf_ord_qid_sn_map_raddr
    ,output logic [ (  12 ) -1 : 0 ]     rf_ord_qid_sn_map_rdata

    ,input  logic                        rf_ord_qid_sn_map_isol_en
    ,input  logic                        rf_ord_qid_sn_map_pwr_enable_b_in
    ,output logic                        rf_ord_qid_sn_map_pwr_enable_b_out

    ,input  logic                        rf_outbound_hcw_fifo_mem_wclk
    ,input  logic                        rf_outbound_hcw_fifo_mem_wclk_rst_n
    ,input  logic                        rf_outbound_hcw_fifo_mem_we
    ,input  logic [ (   4 ) -1 : 0 ]     rf_outbound_hcw_fifo_mem_waddr
    ,input  logic [ ( 160 ) -1 : 0 ]     rf_outbound_hcw_fifo_mem_wdata
    ,input  logic                        rf_outbound_hcw_fifo_mem_rclk
    ,input  logic                        rf_outbound_hcw_fifo_mem_rclk_rst_n
    ,input  logic                        rf_outbound_hcw_fifo_mem_re
    ,input  logic [ (   4 ) -1 : 0 ]     rf_outbound_hcw_fifo_mem_raddr
    ,output logic [ ( 160 ) -1 : 0 ]     rf_outbound_hcw_fifo_mem_rdata

    ,input  logic                        rf_outbound_hcw_fifo_mem_isol_en
    ,input  logic                        rf_outbound_hcw_fifo_mem_pwr_enable_b_in
    ,output logic                        rf_outbound_hcw_fifo_mem_pwr_enable_b_out

    ,input  logic                        rf_qed_chp_sch_flid_ret_rx_sync_mem_wclk
    ,input  logic                        rf_qed_chp_sch_flid_ret_rx_sync_mem_wclk_rst_n
    ,input  logic                        rf_qed_chp_sch_flid_ret_rx_sync_mem_we
    ,input  logic [ (   2 ) -1 : 0 ]     rf_qed_chp_sch_flid_ret_rx_sync_mem_waddr
    ,input  logic [ (  26 ) -1 : 0 ]     rf_qed_chp_sch_flid_ret_rx_sync_mem_wdata
    ,input  logic                        rf_qed_chp_sch_flid_ret_rx_sync_mem_rclk
    ,input  logic                        rf_qed_chp_sch_flid_ret_rx_sync_mem_rclk_rst_n
    ,input  logic                        rf_qed_chp_sch_flid_ret_rx_sync_mem_re
    ,input  logic [ (   2 ) -1 : 0 ]     rf_qed_chp_sch_flid_ret_rx_sync_mem_raddr
    ,output logic [ (  26 ) -1 : 0 ]     rf_qed_chp_sch_flid_ret_rx_sync_mem_rdata

    ,input  logic                        rf_qed_chp_sch_flid_ret_rx_sync_mem_isol_en
    ,input  logic                        rf_qed_chp_sch_flid_ret_rx_sync_mem_pwr_enable_b_in
    ,output logic                        rf_qed_chp_sch_flid_ret_rx_sync_mem_pwr_enable_b_out

    ,input  logic                        rf_qed_chp_sch_rx_sync_mem_wclk
    ,input  logic                        rf_qed_chp_sch_rx_sync_mem_wclk_rst_n
    ,input  logic                        rf_qed_chp_sch_rx_sync_mem_we
    ,input  logic [ (   3 ) -1 : 0 ]     rf_qed_chp_sch_rx_sync_mem_waddr
    ,input  logic [ ( 177 ) -1 : 0 ]     rf_qed_chp_sch_rx_sync_mem_wdata
    ,input  logic                        rf_qed_chp_sch_rx_sync_mem_rclk
    ,input  logic                        rf_qed_chp_sch_rx_sync_mem_rclk_rst_n
    ,input  logic                        rf_qed_chp_sch_rx_sync_mem_re
    ,input  logic [ (   3 ) -1 : 0 ]     rf_qed_chp_sch_rx_sync_mem_raddr
    ,output logic [ ( 177 ) -1 : 0 ]     rf_qed_chp_sch_rx_sync_mem_rdata

    ,input  logic                        rf_qed_chp_sch_rx_sync_mem_isol_en
    ,input  logic                        rf_qed_chp_sch_rx_sync_mem_pwr_enable_b_in
    ,output logic                        rf_qed_chp_sch_rx_sync_mem_pwr_enable_b_out

    ,input  logic                        rf_qed_to_cq_fifo_mem_wclk
    ,input  logic                        rf_qed_to_cq_fifo_mem_wclk_rst_n
    ,input  logic                        rf_qed_to_cq_fifo_mem_we
    ,input  logic [ (   3 ) -1 : 0 ]     rf_qed_to_cq_fifo_mem_waddr
    ,input  logic [ ( 197 ) -1 : 0 ]     rf_qed_to_cq_fifo_mem_wdata
    ,input  logic                        rf_qed_to_cq_fifo_mem_rclk
    ,input  logic                        rf_qed_to_cq_fifo_mem_rclk_rst_n
    ,input  logic                        rf_qed_to_cq_fifo_mem_re
    ,input  logic [ (   3 ) -1 : 0 ]     rf_qed_to_cq_fifo_mem_raddr
    ,output logic [ ( 197 ) -1 : 0 ]     rf_qed_to_cq_fifo_mem_rdata

    ,input  logic                        rf_qed_to_cq_fifo_mem_isol_en
    ,input  logic                        rf_qed_to_cq_fifo_mem_pwr_enable_b_in
    ,output logic                        rf_qed_to_cq_fifo_mem_pwr_enable_b_out

    ,input  logic                        rf_reord_cnt_mem_wclk
    ,input  logic                        rf_reord_cnt_mem_wclk_rst_n
    ,input  logic                        rf_reord_cnt_mem_we
    ,input  logic [ (  11 ) -1 : 0 ]     rf_reord_cnt_mem_waddr
    ,input  logic [ (  16 ) -1 : 0 ]     rf_reord_cnt_mem_wdata
    ,input  logic                        rf_reord_cnt_mem_rclk
    ,input  logic                        rf_reord_cnt_mem_rclk_rst_n
    ,input  logic                        rf_reord_cnt_mem_re
    ,input  logic [ (  11 ) -1 : 0 ]     rf_reord_cnt_mem_raddr
    ,output logic [ (  16 ) -1 : 0 ]     rf_reord_cnt_mem_rdata

    ,input  logic                        rf_reord_cnt_mem_isol_en
    ,input  logic                        rf_reord_cnt_mem_pwr_enable_b_in
    ,output logic                        rf_reord_cnt_mem_pwr_enable_b_out

    ,input  logic                        rf_reord_dirhp_mem_wclk
    ,input  logic                        rf_reord_dirhp_mem_wclk_rst_n
    ,input  logic                        rf_reord_dirhp_mem_we
    ,input  logic [ (  11 ) -1 : 0 ]     rf_reord_dirhp_mem_waddr
    ,input  logic [ (  17 ) -1 : 0 ]     rf_reord_dirhp_mem_wdata
    ,input  logic                        rf_reord_dirhp_mem_rclk
    ,input  logic                        rf_reord_dirhp_mem_rclk_rst_n
    ,input  logic                        rf_reord_dirhp_mem_re
    ,input  logic [ (  11 ) -1 : 0 ]     rf_reord_dirhp_mem_raddr
    ,output logic [ (  17 ) -1 : 0 ]     rf_reord_dirhp_mem_rdata

    ,input  logic                        rf_reord_dirhp_mem_isol_en
    ,input  logic                        rf_reord_dirhp_mem_pwr_enable_b_in
    ,output logic                        rf_reord_dirhp_mem_pwr_enable_b_out

    ,input  logic                        rf_reord_dirtp_mem_wclk
    ,input  logic                        rf_reord_dirtp_mem_wclk_rst_n
    ,input  logic                        rf_reord_dirtp_mem_we
    ,input  logic [ (  11 ) -1 : 0 ]     rf_reord_dirtp_mem_waddr
    ,input  logic [ (  17 ) -1 : 0 ]     rf_reord_dirtp_mem_wdata
    ,input  logic                        rf_reord_dirtp_mem_rclk
    ,input  logic                        rf_reord_dirtp_mem_rclk_rst_n
    ,input  logic                        rf_reord_dirtp_mem_re
    ,input  logic [ (  11 ) -1 : 0 ]     rf_reord_dirtp_mem_raddr
    ,output logic [ (  17 ) -1 : 0 ]     rf_reord_dirtp_mem_rdata

    ,input  logic                        rf_reord_dirtp_mem_isol_en
    ,input  logic                        rf_reord_dirtp_mem_pwr_enable_b_in
    ,output logic                        rf_reord_dirtp_mem_pwr_enable_b_out

    ,input  logic                        rf_reord_lbhp_mem_wclk
    ,input  logic                        rf_reord_lbhp_mem_wclk_rst_n
    ,input  logic                        rf_reord_lbhp_mem_we
    ,input  logic [ (  11 ) -1 : 0 ]     rf_reord_lbhp_mem_waddr
    ,input  logic [ (  17 ) -1 : 0 ]     rf_reord_lbhp_mem_wdata
    ,input  logic                        rf_reord_lbhp_mem_rclk
    ,input  logic                        rf_reord_lbhp_mem_rclk_rst_n
    ,input  logic                        rf_reord_lbhp_mem_re
    ,input  logic [ (  11 ) -1 : 0 ]     rf_reord_lbhp_mem_raddr
    ,output logic [ (  17 ) -1 : 0 ]     rf_reord_lbhp_mem_rdata

    ,input  logic                        rf_reord_lbhp_mem_isol_en
    ,input  logic                        rf_reord_lbhp_mem_pwr_enable_b_in
    ,output logic                        rf_reord_lbhp_mem_pwr_enable_b_out

    ,input  logic                        rf_reord_lbtp_mem_wclk
    ,input  logic                        rf_reord_lbtp_mem_wclk_rst_n
    ,input  logic                        rf_reord_lbtp_mem_we
    ,input  logic [ (  11 ) -1 : 0 ]     rf_reord_lbtp_mem_waddr
    ,input  logic [ (  17 ) -1 : 0 ]     rf_reord_lbtp_mem_wdata
    ,input  logic                        rf_reord_lbtp_mem_rclk
    ,input  logic                        rf_reord_lbtp_mem_rclk_rst_n
    ,input  logic                        rf_reord_lbtp_mem_re
    ,input  logic [ (  11 ) -1 : 0 ]     rf_reord_lbtp_mem_raddr
    ,output logic [ (  17 ) -1 : 0 ]     rf_reord_lbtp_mem_rdata

    ,input  logic                        rf_reord_lbtp_mem_isol_en
    ,input  logic                        rf_reord_lbtp_mem_pwr_enable_b_in
    ,output logic                        rf_reord_lbtp_mem_pwr_enable_b_out

    ,input  logic                        rf_reord_st_mem_wclk
    ,input  logic                        rf_reord_st_mem_wclk_rst_n
    ,input  logic                        rf_reord_st_mem_we
    ,input  logic [ (  11 ) -1 : 0 ]     rf_reord_st_mem_waddr
    ,input  logic [ (  25 ) -1 : 0 ]     rf_reord_st_mem_wdata
    ,input  logic                        rf_reord_st_mem_rclk
    ,input  logic                        rf_reord_st_mem_rclk_rst_n
    ,input  logic                        rf_reord_st_mem_re
    ,input  logic [ (  11 ) -1 : 0 ]     rf_reord_st_mem_raddr
    ,output logic [ (  25 ) -1 : 0 ]     rf_reord_st_mem_rdata

    ,input  logic                        rf_reord_st_mem_isol_en
    ,input  logic                        rf_reord_st_mem_pwr_enable_b_in
    ,output logic                        rf_reord_st_mem_pwr_enable_b_out

    ,input  logic                        rf_rop_chp_rop_hcw_fifo_mem_wclk
    ,input  logic                        rf_rop_chp_rop_hcw_fifo_mem_wclk_rst_n
    ,input  logic                        rf_rop_chp_rop_hcw_fifo_mem_we
    ,input  logic [ (   2 ) -1 : 0 ]     rf_rop_chp_rop_hcw_fifo_mem_waddr
    ,input  logic [ ( 204 ) -1 : 0 ]     rf_rop_chp_rop_hcw_fifo_mem_wdata
    ,input  logic                        rf_rop_chp_rop_hcw_fifo_mem_rclk
    ,input  logic                        rf_rop_chp_rop_hcw_fifo_mem_rclk_rst_n
    ,input  logic                        rf_rop_chp_rop_hcw_fifo_mem_re
    ,input  logic [ (   2 ) -1 : 0 ]     rf_rop_chp_rop_hcw_fifo_mem_raddr
    ,output logic [ ( 204 ) -1 : 0 ]     rf_rop_chp_rop_hcw_fifo_mem_rdata

    ,input  logic                        rf_rop_chp_rop_hcw_fifo_mem_isol_en
    ,input  logic                        rf_rop_chp_rop_hcw_fifo_mem_pwr_enable_b_in
    ,output logic                        rf_rop_chp_rop_hcw_fifo_mem_pwr_enable_b_out

    ,input  logic                        rf_sch_out_fifo_wclk
    ,input  logic                        rf_sch_out_fifo_wclk_rst_n
    ,input  logic                        rf_sch_out_fifo_we
    ,input  logic [ (   7 ) -1 : 0 ]     rf_sch_out_fifo_waddr
    ,input  logic [ ( 270 ) -1 : 0 ]     rf_sch_out_fifo_wdata
    ,input  logic                        rf_sch_out_fifo_rclk
    ,input  logic                        rf_sch_out_fifo_rclk_rst_n
    ,input  logic                        rf_sch_out_fifo_re
    ,input  logic [ (   7 ) -1 : 0 ]     rf_sch_out_fifo_raddr
    ,output logic [ ( 270 ) -1 : 0 ]     rf_sch_out_fifo_rdata

    ,input  logic                        rf_sch_out_fifo_isol_en
    ,input  logic                        rf_sch_out_fifo_pwr_enable_b_in
    ,output logic                        rf_sch_out_fifo_pwr_enable_b_out

    ,input  logic                        rf_sn0_order_shft_mem_wclk
    ,input  logic                        rf_sn0_order_shft_mem_wclk_rst_n
    ,input  logic                        rf_sn0_order_shft_mem_we
    ,input  logic [ (   4 ) -1 : 0 ]     rf_sn0_order_shft_mem_waddr
    ,input  logic [ (  12 ) -1 : 0 ]     rf_sn0_order_shft_mem_wdata
    ,input  logic                        rf_sn0_order_shft_mem_rclk
    ,input  logic                        rf_sn0_order_shft_mem_rclk_rst_n
    ,input  logic                        rf_sn0_order_shft_mem_re
    ,input  logic [ (   4 ) -1 : 0 ]     rf_sn0_order_shft_mem_raddr
    ,output logic [ (  12 ) -1 : 0 ]     rf_sn0_order_shft_mem_rdata

    ,input  logic                        rf_sn0_order_shft_mem_isol_en
    ,input  logic                        rf_sn0_order_shft_mem_pwr_enable_b_in
    ,output logic                        rf_sn0_order_shft_mem_pwr_enable_b_out

    ,input  logic                        rf_sn1_order_shft_mem_wclk
    ,input  logic                        rf_sn1_order_shft_mem_wclk_rst_n
    ,input  logic                        rf_sn1_order_shft_mem_we
    ,input  logic [ (   4 ) -1 : 0 ]     rf_sn1_order_shft_mem_waddr
    ,input  logic [ (  12 ) -1 : 0 ]     rf_sn1_order_shft_mem_wdata
    ,input  logic                        rf_sn1_order_shft_mem_rclk
    ,input  logic                        rf_sn1_order_shft_mem_rclk_rst_n
    ,input  logic                        rf_sn1_order_shft_mem_re
    ,input  logic [ (   4 ) -1 : 0 ]     rf_sn1_order_shft_mem_raddr
    ,output logic [ (  12 ) -1 : 0 ]     rf_sn1_order_shft_mem_rdata

    ,input  logic                        rf_sn1_order_shft_mem_isol_en
    ,input  logic                        rf_sn1_order_shft_mem_pwr_enable_b_in
    ,output logic                        rf_sn1_order_shft_mem_pwr_enable_b_out

    ,input  logic                        rf_sn_complete_fifo_mem_wclk
    ,input  logic                        rf_sn_complete_fifo_mem_wclk_rst_n
    ,input  logic                        rf_sn_complete_fifo_mem_we
    ,input  logic [ (   2 ) -1 : 0 ]     rf_sn_complete_fifo_mem_waddr
    ,input  logic [ (  21 ) -1 : 0 ]     rf_sn_complete_fifo_mem_wdata
    ,input  logic                        rf_sn_complete_fifo_mem_rclk
    ,input  logic                        rf_sn_complete_fifo_mem_rclk_rst_n
    ,input  logic                        rf_sn_complete_fifo_mem_re
    ,input  logic [ (   2 ) -1 : 0 ]     rf_sn_complete_fifo_mem_raddr
    ,output logic [ (  21 ) -1 : 0 ]     rf_sn_complete_fifo_mem_rdata

    ,input  logic                        rf_sn_complete_fifo_mem_isol_en
    ,input  logic                        rf_sn_complete_fifo_mem_pwr_enable_b_in
    ,output logic                        rf_sn_complete_fifo_mem_pwr_enable_b_out

    ,input  logic                        rf_sn_ordered_fifo_mem_wclk
    ,input  logic                        rf_sn_ordered_fifo_mem_wclk_rst_n
    ,input  logic                        rf_sn_ordered_fifo_mem_we
    ,input  logic [ (   5 ) -1 : 0 ]     rf_sn_ordered_fifo_mem_waddr
    ,input  logic [ (  13 ) -1 : 0 ]     rf_sn_ordered_fifo_mem_wdata
    ,input  logic                        rf_sn_ordered_fifo_mem_rclk
    ,input  logic                        rf_sn_ordered_fifo_mem_rclk_rst_n
    ,input  logic                        rf_sn_ordered_fifo_mem_re
    ,input  logic [ (   5 ) -1 : 0 ]     rf_sn_ordered_fifo_mem_raddr
    ,output logic [ (  13 ) -1 : 0 ]     rf_sn_ordered_fifo_mem_rdata

    ,input  logic                        rf_sn_ordered_fifo_mem_isol_en
    ,input  logic                        rf_sn_ordered_fifo_mem_pwr_enable_b_in
    ,output logic                        rf_sn_ordered_fifo_mem_pwr_enable_b_out

    ,input  logic                        rf_threshold_r_pipe_dir_mem_wclk
    ,input  logic                        rf_threshold_r_pipe_dir_mem_wclk_rst_n
    ,input  logic                        rf_threshold_r_pipe_dir_mem_we
    ,input  logic [ (   6 ) -1 : 0 ]     rf_threshold_r_pipe_dir_mem_waddr
    ,input  logic [ (  14 ) -1 : 0 ]     rf_threshold_r_pipe_dir_mem_wdata
    ,input  logic                        rf_threshold_r_pipe_dir_mem_rclk
    ,input  logic                        rf_threshold_r_pipe_dir_mem_rclk_rst_n
    ,input  logic                        rf_threshold_r_pipe_dir_mem_re
    ,input  logic [ (   6 ) -1 : 0 ]     rf_threshold_r_pipe_dir_mem_raddr
    ,output logic [ (  14 ) -1 : 0 ]     rf_threshold_r_pipe_dir_mem_rdata

    ,input  logic                        rf_threshold_r_pipe_dir_mem_isol_en
    ,input  logic                        rf_threshold_r_pipe_dir_mem_pwr_enable_b_in
    ,output logic                        rf_threshold_r_pipe_dir_mem_pwr_enable_b_out

    ,input  logic                        rf_threshold_r_pipe_ldb_mem_wclk
    ,input  logic                        rf_threshold_r_pipe_ldb_mem_wclk_rst_n
    ,input  logic                        rf_threshold_r_pipe_ldb_mem_we
    ,input  logic [ (   6 ) -1 : 0 ]     rf_threshold_r_pipe_ldb_mem_waddr
    ,input  logic [ (  14 ) -1 : 0 ]     rf_threshold_r_pipe_ldb_mem_wdata
    ,input  logic                        rf_threshold_r_pipe_ldb_mem_rclk
    ,input  logic                        rf_threshold_r_pipe_ldb_mem_rclk_rst_n
    ,input  logic                        rf_threshold_r_pipe_ldb_mem_re
    ,input  logic [ (   6 ) -1 : 0 ]     rf_threshold_r_pipe_ldb_mem_raddr
    ,output logic [ (  14 ) -1 : 0 ]     rf_threshold_r_pipe_ldb_mem_rdata

    ,input  logic                        rf_threshold_r_pipe_ldb_mem_isol_en
    ,input  logic                        rf_threshold_r_pipe_ldb_mem_pwr_enable_b_in
    ,output logic                        rf_threshold_r_pipe_ldb_mem_pwr_enable_b_out

    ,input  logic                        powergood_rst_b

    ,input  logic                        hqm_pwrgood_rst_b

    ,input  logic                        fscan_byprst_b
    ,input  logic                        fscan_clkungate
    ,input  logic                        fscan_rstbypen
);

logic ip_reset_b;

assign ip_reset_b = powergood_rst_b & hqm_pwrgood_rst_b;

hqm_system_mem_AW_rf_pg_16x30 i_rf_alarm_vf_synd0 (

     .wclk                    (rf_alarm_vf_synd0_wclk)
    ,.wclk_rst_n              (rf_alarm_vf_synd0_wclk_rst_n)
    ,.we                      (rf_alarm_vf_synd0_we)
    ,.waddr                   (rf_alarm_vf_synd0_waddr)
    ,.wdata                   (rf_alarm_vf_synd0_wdata)
    ,.rclk                    (rf_alarm_vf_synd0_rclk)
    ,.rclk_rst_n              (rf_alarm_vf_synd0_rclk_rst_n)
    ,.re                      (rf_alarm_vf_synd0_re)
    ,.raddr                   (rf_alarm_vf_synd0_raddr)
    ,.rdata                   (rf_alarm_vf_synd0_rdata)

    ,.pgcb_isol_en            (rf_alarm_vf_synd0_isol_en)
    ,.pwr_enable_b_in         (rf_alarm_vf_synd0_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_alarm_vf_synd0_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_16x32 i_rf_alarm_vf_synd1 (

     .wclk                    (rf_alarm_vf_synd1_wclk)
    ,.wclk_rst_n              (rf_alarm_vf_synd1_wclk_rst_n)
    ,.we                      (rf_alarm_vf_synd1_we)
    ,.waddr                   (rf_alarm_vf_synd1_waddr)
    ,.wdata                   (rf_alarm_vf_synd1_wdata)
    ,.rclk                    (rf_alarm_vf_synd1_rclk)
    ,.rclk_rst_n              (rf_alarm_vf_synd1_rclk_rst_n)
    ,.re                      (rf_alarm_vf_synd1_re)
    ,.raddr                   (rf_alarm_vf_synd1_raddr)
    ,.rdata                   (rf_alarm_vf_synd1_rdata)

    ,.pgcb_isol_en            (rf_alarm_vf_synd1_isol_en)
    ,.pwr_enable_b_in         (rf_alarm_vf_synd1_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_alarm_vf_synd1_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_16x32 i_rf_alarm_vf_synd2 (

     .wclk                    (rf_alarm_vf_synd2_wclk)
    ,.wclk_rst_n              (rf_alarm_vf_synd2_wclk_rst_n)
    ,.we                      (rf_alarm_vf_synd2_we)
    ,.waddr                   (rf_alarm_vf_synd2_waddr)
    ,.wdata                   (rf_alarm_vf_synd2_wdata)
    ,.rclk                    (rf_alarm_vf_synd2_rclk)
    ,.rclk_rst_n              (rf_alarm_vf_synd2_rclk_rst_n)
    ,.re                      (rf_alarm_vf_synd2_re)
    ,.raddr                   (rf_alarm_vf_synd2_raddr)
    ,.rdata                   (rf_alarm_vf_synd2_rdata)

    ,.pgcb_isol_en            (rf_alarm_vf_synd2_isol_en)
    ,.pwr_enable_b_in         (rf_alarm_vf_synd2_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_alarm_vf_synd2_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_4x179 i_rf_aqed_chp_sch_rx_sync_mem (

     .wclk                    (rf_aqed_chp_sch_rx_sync_mem_wclk)
    ,.wclk_rst_n              (rf_aqed_chp_sch_rx_sync_mem_wclk_rst_n)
    ,.we                      (rf_aqed_chp_sch_rx_sync_mem_we)
    ,.waddr                   (rf_aqed_chp_sch_rx_sync_mem_waddr)
    ,.wdata                   (rf_aqed_chp_sch_rx_sync_mem_wdata)
    ,.rclk                    (rf_aqed_chp_sch_rx_sync_mem_rclk)
    ,.rclk_rst_n              (rf_aqed_chp_sch_rx_sync_mem_rclk_rst_n)
    ,.re                      (rf_aqed_chp_sch_rx_sync_mem_re)
    ,.raddr                   (rf_aqed_chp_sch_rx_sync_mem_raddr)
    ,.rdata                   (rf_aqed_chp_sch_rx_sync_mem_rdata)

    ,.pgcb_isol_en            (rf_aqed_chp_sch_rx_sync_mem_isol_en)
    ,.pwr_enable_b_in         (rf_aqed_chp_sch_rx_sync_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_aqed_chp_sch_rx_sync_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_16x201 i_rf_chp_chp_rop_hcw_fifo_mem (

     .wclk                    (rf_chp_chp_rop_hcw_fifo_mem_wclk)
    ,.wclk_rst_n              (rf_chp_chp_rop_hcw_fifo_mem_wclk_rst_n)
    ,.we                      (rf_chp_chp_rop_hcw_fifo_mem_we)
    ,.waddr                   (rf_chp_chp_rop_hcw_fifo_mem_waddr)
    ,.wdata                   (rf_chp_chp_rop_hcw_fifo_mem_wdata)
    ,.rclk                    (rf_chp_chp_rop_hcw_fifo_mem_rclk)
    ,.rclk_rst_n              (rf_chp_chp_rop_hcw_fifo_mem_rclk_rst_n)
    ,.re                      (rf_chp_chp_rop_hcw_fifo_mem_re)
    ,.raddr                   (rf_chp_chp_rop_hcw_fifo_mem_raddr)
    ,.rdata                   (rf_chp_chp_rop_hcw_fifo_mem_rdata)

    ,.pgcb_isol_en            (rf_chp_chp_rop_hcw_fifo_mem_isol_en)
    ,.pwr_enable_b_in         (rf_chp_chp_rop_hcw_fifo_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_chp_chp_rop_hcw_fifo_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_16x74 i_rf_chp_lsp_ap_cmp_fifo_mem (

     .wclk                    (rf_chp_lsp_ap_cmp_fifo_mem_wclk)
    ,.wclk_rst_n              (rf_chp_lsp_ap_cmp_fifo_mem_wclk_rst_n)
    ,.we                      (rf_chp_lsp_ap_cmp_fifo_mem_we)
    ,.waddr                   (rf_chp_lsp_ap_cmp_fifo_mem_waddr)
    ,.wdata                   (rf_chp_lsp_ap_cmp_fifo_mem_wdata)
    ,.rclk                    (rf_chp_lsp_ap_cmp_fifo_mem_rclk)
    ,.rclk_rst_n              (rf_chp_lsp_ap_cmp_fifo_mem_rclk_rst_n)
    ,.re                      (rf_chp_lsp_ap_cmp_fifo_mem_re)
    ,.raddr                   (rf_chp_lsp_ap_cmp_fifo_mem_raddr)
    ,.rdata                   (rf_chp_lsp_ap_cmp_fifo_mem_rdata)

    ,.pgcb_isol_en            (rf_chp_lsp_ap_cmp_fifo_mem_isol_en)
    ,.pwr_enable_b_in         (rf_chp_lsp_ap_cmp_fifo_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_chp_lsp_ap_cmp_fifo_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_16x29 i_rf_chp_lsp_tok_fifo_mem (

     .wclk                    (rf_chp_lsp_tok_fifo_mem_wclk)
    ,.wclk_rst_n              (rf_chp_lsp_tok_fifo_mem_wclk_rst_n)
    ,.we                      (rf_chp_lsp_tok_fifo_mem_we)
    ,.waddr                   (rf_chp_lsp_tok_fifo_mem_waddr)
    ,.wdata                   (rf_chp_lsp_tok_fifo_mem_wdata)
    ,.rclk                    (rf_chp_lsp_tok_fifo_mem_rclk)
    ,.rclk_rst_n              (rf_chp_lsp_tok_fifo_mem_rclk_rst_n)
    ,.re                      (rf_chp_lsp_tok_fifo_mem_re)
    ,.raddr                   (rf_chp_lsp_tok_fifo_mem_raddr)
    ,.rdata                   (rf_chp_lsp_tok_fifo_mem_rdata)

    ,.pgcb_isol_en            (rf_chp_lsp_tok_fifo_mem_isol_en)
    ,.pwr_enable_b_in         (rf_chp_lsp_tok_fifo_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_chp_lsp_tok_fifo_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_8x200 i_rf_chp_sys_tx_fifo_mem (

     .wclk                    (rf_chp_sys_tx_fifo_mem_wclk)
    ,.wclk_rst_n              (rf_chp_sys_tx_fifo_mem_wclk_rst_n)
    ,.we                      (rf_chp_sys_tx_fifo_mem_we)
    ,.waddr                   (rf_chp_sys_tx_fifo_mem_waddr)
    ,.wdata                   (rf_chp_sys_tx_fifo_mem_wdata)
    ,.rclk                    (rf_chp_sys_tx_fifo_mem_rclk)
    ,.rclk_rst_n              (rf_chp_sys_tx_fifo_mem_rclk_rst_n)
    ,.re                      (rf_chp_sys_tx_fifo_mem_re)
    ,.raddr                   (rf_chp_sys_tx_fifo_mem_raddr)
    ,.rdata                   (rf_chp_sys_tx_fifo_mem_rdata)

    ,.pgcb_isol_en            (rf_chp_sys_tx_fifo_mem_isol_en)
    ,.pwr_enable_b_in         (rf_chp_sys_tx_fifo_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_chp_sys_tx_fifo_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_64x2 i_rf_cmp_id_chk_enbl_mem (

     .wclk                    (rf_cmp_id_chk_enbl_mem_wclk)
    ,.wclk_rst_n              (rf_cmp_id_chk_enbl_mem_wclk_rst_n)
    ,.we                      (rf_cmp_id_chk_enbl_mem_we)
    ,.waddr                   (rf_cmp_id_chk_enbl_mem_waddr)
    ,.wdata                   (rf_cmp_id_chk_enbl_mem_wdata)
    ,.rclk                    (rf_cmp_id_chk_enbl_mem_rclk)
    ,.rclk_rst_n              (rf_cmp_id_chk_enbl_mem_rclk_rst_n)
    ,.re                      (rf_cmp_id_chk_enbl_mem_re)
    ,.raddr                   (rf_cmp_id_chk_enbl_mem_raddr)
    ,.rdata                   (rf_cmp_id_chk_enbl_mem_rdata)

    ,.pgcb_isol_en            (rf_cmp_id_chk_enbl_mem_isol_en)
    ,.pwr_enable_b_in         (rf_cmp_id_chk_enbl_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_cmp_id_chk_enbl_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_64x16 i_rf_count_rmw_pipe_dir_mem (

     .wclk                    (rf_count_rmw_pipe_dir_mem_wclk)
    ,.wclk_rst_n              (rf_count_rmw_pipe_dir_mem_wclk_rst_n)
    ,.we                      (rf_count_rmw_pipe_dir_mem_we)
    ,.waddr                   (rf_count_rmw_pipe_dir_mem_waddr)
    ,.wdata                   (rf_count_rmw_pipe_dir_mem_wdata)
    ,.rclk                    (rf_count_rmw_pipe_dir_mem_rclk)
    ,.rclk_rst_n              (rf_count_rmw_pipe_dir_mem_rclk_rst_n)
    ,.re                      (rf_count_rmw_pipe_dir_mem_re)
    ,.raddr                   (rf_count_rmw_pipe_dir_mem_raddr)
    ,.rdata                   (rf_count_rmw_pipe_dir_mem_rdata)

    ,.pgcb_isol_en            (rf_count_rmw_pipe_dir_mem_isol_en)
    ,.pwr_enable_b_in         (rf_count_rmw_pipe_dir_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_count_rmw_pipe_dir_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_64x16 i_rf_count_rmw_pipe_ldb_mem (

     .wclk                    (rf_count_rmw_pipe_ldb_mem_wclk)
    ,.wclk_rst_n              (rf_count_rmw_pipe_ldb_mem_wclk_rst_n)
    ,.we                      (rf_count_rmw_pipe_ldb_mem_we)
    ,.waddr                   (rf_count_rmw_pipe_ldb_mem_waddr)
    ,.wdata                   (rf_count_rmw_pipe_ldb_mem_wdata)
    ,.rclk                    (rf_count_rmw_pipe_ldb_mem_rclk)
    ,.rclk_rst_n              (rf_count_rmw_pipe_ldb_mem_rclk_rst_n)
    ,.re                      (rf_count_rmw_pipe_ldb_mem_re)
    ,.raddr                   (rf_count_rmw_pipe_ldb_mem_raddr)
    ,.rdata                   (rf_count_rmw_pipe_ldb_mem_rdata)

    ,.pgcb_isol_en            (rf_count_rmw_pipe_ldb_mem_isol_en)
    ,.pwr_enable_b_in         (rf_count_rmw_pipe_ldb_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_count_rmw_pipe_ldb_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_64x13 i_rf_dir_cq_depth (

     .wclk                    (rf_dir_cq_depth_wclk)
    ,.wclk_rst_n              (rf_dir_cq_depth_wclk_rst_n)
    ,.we                      (rf_dir_cq_depth_we)
    ,.waddr                   (rf_dir_cq_depth_waddr)
    ,.wdata                   (rf_dir_cq_depth_wdata)
    ,.rclk                    (rf_dir_cq_depth_rclk)
    ,.rclk_rst_n              (rf_dir_cq_depth_rclk_rst_n)
    ,.re                      (rf_dir_cq_depth_re)
    ,.raddr                   (rf_dir_cq_depth_raddr)
    ,.rdata                   (rf_dir_cq_depth_rdata)

    ,.pgcb_isol_en            (rf_dir_cq_depth_isol_en)
    ,.pwr_enable_b_in         (rf_dir_cq_depth_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_dir_cq_depth_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_64x15 i_rf_dir_cq_intr_thresh (

     .wclk                    (rf_dir_cq_intr_thresh_wclk)
    ,.wclk_rst_n              (rf_dir_cq_intr_thresh_wclk_rst_n)
    ,.we                      (rf_dir_cq_intr_thresh_we)
    ,.waddr                   (rf_dir_cq_intr_thresh_waddr)
    ,.wdata                   (rf_dir_cq_intr_thresh_wdata)
    ,.rclk                    (rf_dir_cq_intr_thresh_rclk)
    ,.rclk_rst_n              (rf_dir_cq_intr_thresh_rclk_rst_n)
    ,.re                      (rf_dir_cq_intr_thresh_re)
    ,.raddr                   (rf_dir_cq_intr_thresh_raddr)
    ,.rdata                   (rf_dir_cq_intr_thresh_rdata)

    ,.pgcb_isol_en            (rf_dir_cq_intr_thresh_isol_en)
    ,.pwr_enable_b_in         (rf_dir_cq_intr_thresh_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_dir_cq_intr_thresh_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_64x6 i_rf_dir_cq_token_depth_select (

     .wclk                    (rf_dir_cq_token_depth_select_wclk)
    ,.wclk_rst_n              (rf_dir_cq_token_depth_select_wclk_rst_n)
    ,.we                      (rf_dir_cq_token_depth_select_we)
    ,.waddr                   (rf_dir_cq_token_depth_select_waddr)
    ,.wdata                   (rf_dir_cq_token_depth_select_wdata)
    ,.rclk                    (rf_dir_cq_token_depth_select_rclk)
    ,.rclk_rst_n              (rf_dir_cq_token_depth_select_rclk_rst_n)
    ,.re                      (rf_dir_cq_token_depth_select_re)
    ,.raddr                   (rf_dir_cq_token_depth_select_raddr)
    ,.rdata                   (rf_dir_cq_token_depth_select_rdata)

    ,.pgcb_isol_en            (rf_dir_cq_token_depth_select_isol_en)
    ,.pwr_enable_b_in         (rf_dir_cq_token_depth_select_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_dir_cq_token_depth_select_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_64x13 i_rf_dir_cq_wptr (

     .wclk                    (rf_dir_cq_wptr_wclk)
    ,.wclk_rst_n              (rf_dir_cq_wptr_wclk_rst_n)
    ,.we                      (rf_dir_cq_wptr_we)
    ,.waddr                   (rf_dir_cq_wptr_waddr)
    ,.wdata                   (rf_dir_cq_wptr_wdata)
    ,.rclk                    (rf_dir_cq_wptr_rclk)
    ,.rclk_rst_n              (rf_dir_cq_wptr_rclk_rst_n)
    ,.re                      (rf_dir_cq_wptr_re)
    ,.raddr                   (rf_dir_cq_wptr_raddr)
    ,.rdata                   (rf_dir_cq_wptr_rdata)

    ,.pgcb_isol_en            (rf_dir_cq_wptr_isol_en)
    ,.pwr_enable_b_in         (rf_dir_cq_wptr_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_dir_cq_wptr_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_8x60 i_rf_dir_rply_req_fifo_mem (

     .wclk                    (rf_dir_rply_req_fifo_mem_wclk)
    ,.wclk_rst_n              (rf_dir_rply_req_fifo_mem_wclk_rst_n)
    ,.we                      (rf_dir_rply_req_fifo_mem_we)
    ,.waddr                   (rf_dir_rply_req_fifo_mem_waddr)
    ,.wdata                   (rf_dir_rply_req_fifo_mem_wdata)
    ,.rclk                    (rf_dir_rply_req_fifo_mem_rclk)
    ,.rclk_rst_n              (rf_dir_rply_req_fifo_mem_rclk_rst_n)
    ,.re                      (rf_dir_rply_req_fifo_mem_re)
    ,.raddr                   (rf_dir_rply_req_fifo_mem_raddr)
    ,.rdata                   (rf_dir_rply_req_fifo_mem_rdata)

    ,.pgcb_isol_en            (rf_dir_rply_req_fifo_mem_isol_en)
    ,.pwr_enable_b_in         (rf_dir_rply_req_fifo_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_dir_rply_req_fifo_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_64x144 i_rf_dir_wb0 (

     .wclk                    (rf_dir_wb0_wclk)
    ,.wclk_rst_n              (rf_dir_wb0_wclk_rst_n)
    ,.we                      (rf_dir_wb0_we)
    ,.waddr                   (rf_dir_wb0_waddr)
    ,.wdata                   (rf_dir_wb0_wdata)
    ,.rclk                    (rf_dir_wb0_rclk)
    ,.rclk_rst_n              (rf_dir_wb0_rclk_rst_n)
    ,.re                      (rf_dir_wb0_re)
    ,.raddr                   (rf_dir_wb0_raddr)
    ,.rdata                   (rf_dir_wb0_rdata)

    ,.pgcb_isol_en            (rf_dir_wb0_isol_en)
    ,.pwr_enable_b_in         (rf_dir_wb0_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_dir_wb0_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_64x144 i_rf_dir_wb1 (

     .wclk                    (rf_dir_wb1_wclk)
    ,.wclk_rst_n              (rf_dir_wb1_wclk_rst_n)
    ,.we                      (rf_dir_wb1_we)
    ,.waddr                   (rf_dir_wb1_waddr)
    ,.wdata                   (rf_dir_wb1_wdata)
    ,.rclk                    (rf_dir_wb1_rclk)
    ,.rclk_rst_n              (rf_dir_wb1_rclk_rst_n)
    ,.re                      (rf_dir_wb1_re)
    ,.raddr                   (rf_dir_wb1_raddr)
    ,.rdata                   (rf_dir_wb1_rdata)

    ,.pgcb_isol_en            (rf_dir_wb1_isol_en)
    ,.pwr_enable_b_in         (rf_dir_wb1_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_dir_wb1_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_64x144 i_rf_dir_wb2 (

     .wclk                    (rf_dir_wb2_wclk)
    ,.wclk_rst_n              (rf_dir_wb2_wclk_rst_n)
    ,.we                      (rf_dir_wb2_we)
    ,.waddr                   (rf_dir_wb2_waddr)
    ,.wdata                   (rf_dir_wb2_wdata)
    ,.rclk                    (rf_dir_wb2_rclk)
    ,.rclk_rst_n              (rf_dir_wb2_rclk_rst_n)
    ,.re                      (rf_dir_wb2_re)
    ,.raddr                   (rf_dir_wb2_raddr)
    ,.rdata                   (rf_dir_wb2_rdata)

    ,.pgcb_isol_en            (rf_dir_wb2_isol_en)
    ,.pwr_enable_b_in         (rf_dir_wb2_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_dir_wb2_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_16x160 i_rf_hcw_enq_w_rx_sync_mem (

     .wclk                    (rf_hcw_enq_w_rx_sync_mem_wclk)
    ,.wclk_rst_n              (rf_hcw_enq_w_rx_sync_mem_wclk_rst_n)
    ,.we                      (rf_hcw_enq_w_rx_sync_mem_we)
    ,.waddr                   (rf_hcw_enq_w_rx_sync_mem_waddr)
    ,.wdata                   (rf_hcw_enq_w_rx_sync_mem_wdata)
    ,.rclk                    (rf_hcw_enq_w_rx_sync_mem_rclk)
    ,.rclk_rst_n              (rf_hcw_enq_w_rx_sync_mem_rclk_rst_n)
    ,.re                      (rf_hcw_enq_w_rx_sync_mem_re)
    ,.raddr                   (rf_hcw_enq_w_rx_sync_mem_raddr)
    ,.rdata                   (rf_hcw_enq_w_rx_sync_mem_rdata)

    ,.pgcb_isol_en            (rf_hcw_enq_w_rx_sync_mem_isol_en)
    ,.pwr_enable_b_in         (rf_hcw_enq_w_rx_sync_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_hcw_enq_w_rx_sync_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_64x30 i_rf_hist_list_a_minmax (

     .wclk                    (rf_hist_list_a_minmax_wclk)
    ,.wclk_rst_n              (rf_hist_list_a_minmax_wclk_rst_n)
    ,.we                      (rf_hist_list_a_minmax_we)
    ,.waddr                   (rf_hist_list_a_minmax_waddr)
    ,.wdata                   (rf_hist_list_a_minmax_wdata)
    ,.rclk                    (rf_hist_list_a_minmax_rclk)
    ,.rclk_rst_n              (rf_hist_list_a_minmax_rclk_rst_n)
    ,.re                      (rf_hist_list_a_minmax_re)
    ,.raddr                   (rf_hist_list_a_minmax_raddr)
    ,.rdata                   (rf_hist_list_a_minmax_rdata)

    ,.pgcb_isol_en            (rf_hist_list_a_minmax_isol_en)
    ,.pwr_enable_b_in         (rf_hist_list_a_minmax_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_hist_list_a_minmax_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_64x32 i_rf_hist_list_a_ptr (

     .wclk                    (rf_hist_list_a_ptr_wclk)
    ,.wclk_rst_n              (rf_hist_list_a_ptr_wclk_rst_n)
    ,.we                      (rf_hist_list_a_ptr_we)
    ,.waddr                   (rf_hist_list_a_ptr_waddr)
    ,.wdata                   (rf_hist_list_a_ptr_wdata)
    ,.rclk                    (rf_hist_list_a_ptr_rclk)
    ,.rclk_rst_n              (rf_hist_list_a_ptr_rclk_rst_n)
    ,.re                      (rf_hist_list_a_ptr_re)
    ,.raddr                   (rf_hist_list_a_ptr_raddr)
    ,.rdata                   (rf_hist_list_a_ptr_rdata)

    ,.pgcb_isol_en            (rf_hist_list_a_ptr_isol_en)
    ,.pwr_enable_b_in         (rf_hist_list_a_ptr_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_hist_list_a_ptr_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_64x30 i_rf_hist_list_minmax (

     .wclk                    (rf_hist_list_minmax_wclk)
    ,.wclk_rst_n              (rf_hist_list_minmax_wclk_rst_n)
    ,.we                      (rf_hist_list_minmax_we)
    ,.waddr                   (rf_hist_list_minmax_waddr)
    ,.wdata                   (rf_hist_list_minmax_wdata)
    ,.rclk                    (rf_hist_list_minmax_rclk)
    ,.rclk_rst_n              (rf_hist_list_minmax_rclk_rst_n)
    ,.re                      (rf_hist_list_minmax_re)
    ,.raddr                   (rf_hist_list_minmax_raddr)
    ,.rdata                   (rf_hist_list_minmax_rdata)

    ,.pgcb_isol_en            (rf_hist_list_minmax_isol_en)
    ,.pwr_enable_b_in         (rf_hist_list_minmax_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_hist_list_minmax_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_64x32 i_rf_hist_list_ptr (

     .wclk                    (rf_hist_list_ptr_wclk)
    ,.wclk_rst_n              (rf_hist_list_ptr_wclk_rst_n)
    ,.we                      (rf_hist_list_ptr_we)
    ,.waddr                   (rf_hist_list_ptr_waddr)
    ,.wdata                   (rf_hist_list_ptr_wdata)
    ,.rclk                    (rf_hist_list_ptr_rclk)
    ,.rclk_rst_n              (rf_hist_list_ptr_rclk_rst_n)
    ,.re                      (rf_hist_list_ptr_re)
    ,.raddr                   (rf_hist_list_ptr_raddr)
    ,.rdata                   (rf_hist_list_ptr_rdata)

    ,.pgcb_isol_en            (rf_hist_list_ptr_isol_en)
    ,.pwr_enable_b_in         (rf_hist_list_ptr_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_hist_list_ptr_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_64x13 i_rf_ldb_cq_depth (

     .wclk                    (rf_ldb_cq_depth_wclk)
    ,.wclk_rst_n              (rf_ldb_cq_depth_wclk_rst_n)
    ,.we                      (rf_ldb_cq_depth_we)
    ,.waddr                   (rf_ldb_cq_depth_waddr)
    ,.wdata                   (rf_ldb_cq_depth_wdata)
    ,.rclk                    (rf_ldb_cq_depth_rclk)
    ,.rclk_rst_n              (rf_ldb_cq_depth_rclk_rst_n)
    ,.re                      (rf_ldb_cq_depth_re)
    ,.raddr                   (rf_ldb_cq_depth_raddr)
    ,.rdata                   (rf_ldb_cq_depth_rdata)

    ,.pgcb_isol_en            (rf_ldb_cq_depth_isol_en)
    ,.pwr_enable_b_in         (rf_ldb_cq_depth_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_ldb_cq_depth_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_64x13 i_rf_ldb_cq_intr_thresh (

     .wclk                    (rf_ldb_cq_intr_thresh_wclk)
    ,.wclk_rst_n              (rf_ldb_cq_intr_thresh_wclk_rst_n)
    ,.we                      (rf_ldb_cq_intr_thresh_we)
    ,.waddr                   (rf_ldb_cq_intr_thresh_waddr)
    ,.wdata                   (rf_ldb_cq_intr_thresh_wdata)
    ,.rclk                    (rf_ldb_cq_intr_thresh_rclk)
    ,.rclk_rst_n              (rf_ldb_cq_intr_thresh_rclk_rst_n)
    ,.re                      (rf_ldb_cq_intr_thresh_re)
    ,.raddr                   (rf_ldb_cq_intr_thresh_raddr)
    ,.rdata                   (rf_ldb_cq_intr_thresh_rdata)

    ,.pgcb_isol_en            (rf_ldb_cq_intr_thresh_isol_en)
    ,.pwr_enable_b_in         (rf_ldb_cq_intr_thresh_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_ldb_cq_intr_thresh_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_64x32 i_rf_ldb_cq_on_off_threshold (

     .wclk                    (rf_ldb_cq_on_off_threshold_wclk)
    ,.wclk_rst_n              (rf_ldb_cq_on_off_threshold_wclk_rst_n)
    ,.we                      (rf_ldb_cq_on_off_threshold_we)
    ,.waddr                   (rf_ldb_cq_on_off_threshold_waddr)
    ,.wdata                   (rf_ldb_cq_on_off_threshold_wdata)
    ,.rclk                    (rf_ldb_cq_on_off_threshold_rclk)
    ,.rclk_rst_n              (rf_ldb_cq_on_off_threshold_rclk_rst_n)
    ,.re                      (rf_ldb_cq_on_off_threshold_re)
    ,.raddr                   (rf_ldb_cq_on_off_threshold_raddr)
    ,.rdata                   (rf_ldb_cq_on_off_threshold_rdata)

    ,.pgcb_isol_en            (rf_ldb_cq_on_off_threshold_isol_en)
    ,.pwr_enable_b_in         (rf_ldb_cq_on_off_threshold_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_ldb_cq_on_off_threshold_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_64x6 i_rf_ldb_cq_token_depth_select (

     .wclk                    (rf_ldb_cq_token_depth_select_wclk)
    ,.wclk_rst_n              (rf_ldb_cq_token_depth_select_wclk_rst_n)
    ,.we                      (rf_ldb_cq_token_depth_select_we)
    ,.waddr                   (rf_ldb_cq_token_depth_select_waddr)
    ,.wdata                   (rf_ldb_cq_token_depth_select_wdata)
    ,.rclk                    (rf_ldb_cq_token_depth_select_rclk)
    ,.rclk_rst_n              (rf_ldb_cq_token_depth_select_rclk_rst_n)
    ,.re                      (rf_ldb_cq_token_depth_select_re)
    ,.raddr                   (rf_ldb_cq_token_depth_select_raddr)
    ,.rdata                   (rf_ldb_cq_token_depth_select_rdata)

    ,.pgcb_isol_en            (rf_ldb_cq_token_depth_select_isol_en)
    ,.pwr_enable_b_in         (rf_ldb_cq_token_depth_select_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_ldb_cq_token_depth_select_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_64x13 i_rf_ldb_cq_wptr (

     .wclk                    (rf_ldb_cq_wptr_wclk)
    ,.wclk_rst_n              (rf_ldb_cq_wptr_wclk_rst_n)
    ,.we                      (rf_ldb_cq_wptr_we)
    ,.waddr                   (rf_ldb_cq_wptr_waddr)
    ,.wdata                   (rf_ldb_cq_wptr_wdata)
    ,.rclk                    (rf_ldb_cq_wptr_rclk)
    ,.rclk_rst_n              (rf_ldb_cq_wptr_rclk_rst_n)
    ,.re                      (rf_ldb_cq_wptr_re)
    ,.raddr                   (rf_ldb_cq_wptr_raddr)
    ,.rdata                   (rf_ldb_cq_wptr_rdata)

    ,.pgcb_isol_en            (rf_ldb_cq_wptr_isol_en)
    ,.pwr_enable_b_in         (rf_ldb_cq_wptr_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_ldb_cq_wptr_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_8x60 i_rf_ldb_rply_req_fifo_mem (

     .wclk                    (rf_ldb_rply_req_fifo_mem_wclk)
    ,.wclk_rst_n              (rf_ldb_rply_req_fifo_mem_wclk_rst_n)
    ,.we                      (rf_ldb_rply_req_fifo_mem_we)
    ,.waddr                   (rf_ldb_rply_req_fifo_mem_waddr)
    ,.wdata                   (rf_ldb_rply_req_fifo_mem_wdata)
    ,.rclk                    (rf_ldb_rply_req_fifo_mem_rclk)
    ,.rclk_rst_n              (rf_ldb_rply_req_fifo_mem_rclk_rst_n)
    ,.re                      (rf_ldb_rply_req_fifo_mem_re)
    ,.raddr                   (rf_ldb_rply_req_fifo_mem_raddr)
    ,.rdata                   (rf_ldb_rply_req_fifo_mem_rdata)

    ,.pgcb_isol_en            (rf_ldb_rply_req_fifo_mem_isol_en)
    ,.pwr_enable_b_in         (rf_ldb_rply_req_fifo_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_ldb_rply_req_fifo_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_64x144 i_rf_ldb_wb0 (

     .wclk                    (rf_ldb_wb0_wclk)
    ,.wclk_rst_n              (rf_ldb_wb0_wclk_rst_n)
    ,.we                      (rf_ldb_wb0_we)
    ,.waddr                   (rf_ldb_wb0_waddr)
    ,.wdata                   (rf_ldb_wb0_wdata)
    ,.rclk                    (rf_ldb_wb0_rclk)
    ,.rclk_rst_n              (rf_ldb_wb0_rclk_rst_n)
    ,.re                      (rf_ldb_wb0_re)
    ,.raddr                   (rf_ldb_wb0_raddr)
    ,.rdata                   (rf_ldb_wb0_rdata)

    ,.pgcb_isol_en            (rf_ldb_wb0_isol_en)
    ,.pwr_enable_b_in         (rf_ldb_wb0_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_ldb_wb0_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_64x144 i_rf_ldb_wb1 (

     .wclk                    (rf_ldb_wb1_wclk)
    ,.wclk_rst_n              (rf_ldb_wb1_wclk_rst_n)
    ,.we                      (rf_ldb_wb1_we)
    ,.waddr                   (rf_ldb_wb1_waddr)
    ,.wdata                   (rf_ldb_wb1_wdata)
    ,.rclk                    (rf_ldb_wb1_rclk)
    ,.rclk_rst_n              (rf_ldb_wb1_rclk_rst_n)
    ,.re                      (rf_ldb_wb1_re)
    ,.raddr                   (rf_ldb_wb1_raddr)
    ,.rdata                   (rf_ldb_wb1_rdata)

    ,.pgcb_isol_en            (rf_ldb_wb1_isol_en)
    ,.pwr_enable_b_in         (rf_ldb_wb1_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_ldb_wb1_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_64x144 i_rf_ldb_wb2 (

     .wclk                    (rf_ldb_wb2_wclk)
    ,.wclk_rst_n              (rf_ldb_wb2_wclk_rst_n)
    ,.we                      (rf_ldb_wb2_we)
    ,.waddr                   (rf_ldb_wb2_waddr)
    ,.wdata                   (rf_ldb_wb2_wdata)
    ,.rclk                    (rf_ldb_wb2_rclk)
    ,.rclk_rst_n              (rf_ldb_wb2_rclk_rst_n)
    ,.re                      (rf_ldb_wb2_re)
    ,.raddr                   (rf_ldb_wb2_raddr)
    ,.rdata                   (rf_ldb_wb2_rdata)

    ,.pgcb_isol_en            (rf_ldb_wb2_isol_en)
    ,.pwr_enable_b_in         (rf_ldb_wb2_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_ldb_wb2_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_8x19 i_rf_lsp_reordercmp_fifo_mem (

     .wclk                    (rf_lsp_reordercmp_fifo_mem_wclk)
    ,.wclk_rst_n              (rf_lsp_reordercmp_fifo_mem_wclk_rst_n)
    ,.we                      (rf_lsp_reordercmp_fifo_mem_we)
    ,.waddr                   (rf_lsp_reordercmp_fifo_mem_waddr)
    ,.wdata                   (rf_lsp_reordercmp_fifo_mem_wdata)
    ,.rclk                    (rf_lsp_reordercmp_fifo_mem_rclk)
    ,.rclk_rst_n              (rf_lsp_reordercmp_fifo_mem_rclk_rst_n)
    ,.re                      (rf_lsp_reordercmp_fifo_mem_re)
    ,.raddr                   (rf_lsp_reordercmp_fifo_mem_raddr)
    ,.rdata                   (rf_lsp_reordercmp_fifo_mem_rdata)

    ,.pgcb_isol_en            (rf_lsp_reordercmp_fifo_mem_isol_en)
    ,.pwr_enable_b_in         (rf_lsp_reordercmp_fifo_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_lsp_reordercmp_fifo_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_32x13 i_rf_lut_dir_cq2vf_pf_ro (

     .wclk                    (rf_lut_dir_cq2vf_pf_ro_wclk)
    ,.wclk_rst_n              (rf_lut_dir_cq2vf_pf_ro_wclk_rst_n)
    ,.we                      (rf_lut_dir_cq2vf_pf_ro_we)
    ,.waddr                   (rf_lut_dir_cq2vf_pf_ro_waddr)
    ,.wdata                   (rf_lut_dir_cq2vf_pf_ro_wdata)
    ,.rclk                    (rf_lut_dir_cq2vf_pf_ro_rclk)
    ,.rclk_rst_n              (rf_lut_dir_cq2vf_pf_ro_rclk_rst_n)
    ,.re                      (rf_lut_dir_cq2vf_pf_ro_re)
    ,.raddr                   (rf_lut_dir_cq2vf_pf_ro_raddr)
    ,.rdata                   (rf_lut_dir_cq2vf_pf_ro_rdata)

    ,.pgcb_isol_en            (rf_lut_dir_cq2vf_pf_ro_isol_en)
    ,.pwr_enable_b_in         (rf_lut_dir_cq2vf_pf_ro_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_lut_dir_cq2vf_pf_ro_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_64x27 i_rf_lut_dir_cq_addr_l (

     .wclk                    (rf_lut_dir_cq_addr_l_wclk)
    ,.wclk_rst_n              (rf_lut_dir_cq_addr_l_wclk_rst_n)
    ,.we                      (rf_lut_dir_cq_addr_l_we)
    ,.waddr                   (rf_lut_dir_cq_addr_l_waddr)
    ,.wdata                   (rf_lut_dir_cq_addr_l_wdata)
    ,.rclk                    (rf_lut_dir_cq_addr_l_rclk)
    ,.rclk_rst_n              (rf_lut_dir_cq_addr_l_rclk_rst_n)
    ,.re                      (rf_lut_dir_cq_addr_l_re)
    ,.raddr                   (rf_lut_dir_cq_addr_l_raddr)
    ,.rdata                   (rf_lut_dir_cq_addr_l_rdata)

    ,.pgcb_isol_en            (rf_lut_dir_cq_addr_l_isol_en)
    ,.pwr_enable_b_in         (rf_lut_dir_cq_addr_l_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_lut_dir_cq_addr_l_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_64x33 i_rf_lut_dir_cq_addr_u (

     .wclk                    (rf_lut_dir_cq_addr_u_wclk)
    ,.wclk_rst_n              (rf_lut_dir_cq_addr_u_wclk_rst_n)
    ,.we                      (rf_lut_dir_cq_addr_u_we)
    ,.waddr                   (rf_lut_dir_cq_addr_u_waddr)
    ,.wdata                   (rf_lut_dir_cq_addr_u_wdata)
    ,.rclk                    (rf_lut_dir_cq_addr_u_rclk)
    ,.rclk_rst_n              (rf_lut_dir_cq_addr_u_rclk_rst_n)
    ,.re                      (rf_lut_dir_cq_addr_u_re)
    ,.raddr                   (rf_lut_dir_cq_addr_u_raddr)
    ,.rdata                   (rf_lut_dir_cq_addr_u_rdata)

    ,.pgcb_isol_en            (rf_lut_dir_cq_addr_u_isol_en)
    ,.pwr_enable_b_in         (rf_lut_dir_cq_addr_u_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_lut_dir_cq_addr_u_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_64x31 i_rf_lut_dir_cq_ai_addr_l (

     .wclk                    (rf_lut_dir_cq_ai_addr_l_wclk)
    ,.wclk_rst_n              (rf_lut_dir_cq_ai_addr_l_wclk_rst_n)
    ,.we                      (rf_lut_dir_cq_ai_addr_l_we)
    ,.waddr                   (rf_lut_dir_cq_ai_addr_l_waddr)
    ,.wdata                   (rf_lut_dir_cq_ai_addr_l_wdata)
    ,.rclk                    (rf_lut_dir_cq_ai_addr_l_rclk)
    ,.rclk_rst_n              (rf_lut_dir_cq_ai_addr_l_rclk_rst_n)
    ,.re                      (rf_lut_dir_cq_ai_addr_l_re)
    ,.raddr                   (rf_lut_dir_cq_ai_addr_l_raddr)
    ,.rdata                   (rf_lut_dir_cq_ai_addr_l_rdata)

    ,.pgcb_isol_en            (rf_lut_dir_cq_ai_addr_l_isol_en)
    ,.pwr_enable_b_in         (rf_lut_dir_cq_ai_addr_l_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_lut_dir_cq_ai_addr_l_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_64x33 i_rf_lut_dir_cq_ai_addr_u (

     .wclk                    (rf_lut_dir_cq_ai_addr_u_wclk)
    ,.wclk_rst_n              (rf_lut_dir_cq_ai_addr_u_wclk_rst_n)
    ,.we                      (rf_lut_dir_cq_ai_addr_u_we)
    ,.waddr                   (rf_lut_dir_cq_ai_addr_u_waddr)
    ,.wdata                   (rf_lut_dir_cq_ai_addr_u_wdata)
    ,.rclk                    (rf_lut_dir_cq_ai_addr_u_rclk)
    ,.rclk_rst_n              (rf_lut_dir_cq_ai_addr_u_rclk_rst_n)
    ,.re                      (rf_lut_dir_cq_ai_addr_u_re)
    ,.raddr                   (rf_lut_dir_cq_ai_addr_u_raddr)
    ,.rdata                   (rf_lut_dir_cq_ai_addr_u_rdata)

    ,.pgcb_isol_en            (rf_lut_dir_cq_ai_addr_u_isol_en)
    ,.pwr_enable_b_in         (rf_lut_dir_cq_ai_addr_u_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_lut_dir_cq_ai_addr_u_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_64x33 i_rf_lut_dir_cq_ai_data (

     .wclk                    (rf_lut_dir_cq_ai_data_wclk)
    ,.wclk_rst_n              (rf_lut_dir_cq_ai_data_wclk_rst_n)
    ,.we                      (rf_lut_dir_cq_ai_data_we)
    ,.waddr                   (rf_lut_dir_cq_ai_data_waddr)
    ,.wdata                   (rf_lut_dir_cq_ai_data_wdata)
    ,.rclk                    (rf_lut_dir_cq_ai_data_rclk)
    ,.rclk_rst_n              (rf_lut_dir_cq_ai_data_rclk_rst_n)
    ,.re                      (rf_lut_dir_cq_ai_data_re)
    ,.raddr                   (rf_lut_dir_cq_ai_data_raddr)
    ,.rdata                   (rf_lut_dir_cq_ai_data_rdata)

    ,.pgcb_isol_en            (rf_lut_dir_cq_ai_data_isol_en)
    ,.pwr_enable_b_in         (rf_lut_dir_cq_ai_data_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_lut_dir_cq_ai_data_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_64x13 i_rf_lut_dir_cq_isr (

     .wclk                    (rf_lut_dir_cq_isr_wclk)
    ,.wclk_rst_n              (rf_lut_dir_cq_isr_wclk_rst_n)
    ,.we                      (rf_lut_dir_cq_isr_we)
    ,.waddr                   (rf_lut_dir_cq_isr_waddr)
    ,.wdata                   (rf_lut_dir_cq_isr_wdata)
    ,.rclk                    (rf_lut_dir_cq_isr_rclk)
    ,.rclk_rst_n              (rf_lut_dir_cq_isr_rclk_rst_n)
    ,.re                      (rf_lut_dir_cq_isr_re)
    ,.raddr                   (rf_lut_dir_cq_isr_raddr)
    ,.rdata                   (rf_lut_dir_cq_isr_rdata)

    ,.pgcb_isol_en            (rf_lut_dir_cq_isr_isol_en)
    ,.pwr_enable_b_in         (rf_lut_dir_cq_isr_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_lut_dir_cq_isr_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_64x24 i_rf_lut_dir_cq_pasid (

     .wclk                    (rf_lut_dir_cq_pasid_wclk)
    ,.wclk_rst_n              (rf_lut_dir_cq_pasid_wclk_rst_n)
    ,.we                      (rf_lut_dir_cq_pasid_we)
    ,.waddr                   (rf_lut_dir_cq_pasid_waddr)
    ,.wdata                   (rf_lut_dir_cq_pasid_wdata)
    ,.rclk                    (rf_lut_dir_cq_pasid_rclk)
    ,.rclk_rst_n              (rf_lut_dir_cq_pasid_rclk_rst_n)
    ,.re                      (rf_lut_dir_cq_pasid_re)
    ,.raddr                   (rf_lut_dir_cq_pasid_raddr)
    ,.rdata                   (rf_lut_dir_cq_pasid_rdata)

    ,.pgcb_isol_en            (rf_lut_dir_cq_pasid_isol_en)
    ,.pwr_enable_b_in         (rf_lut_dir_cq_pasid_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_lut_dir_cq_pasid_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_32x11 i_rf_lut_dir_pp2vas (

     .wclk                    (rf_lut_dir_pp2vas_wclk)
    ,.wclk_rst_n              (rf_lut_dir_pp2vas_wclk_rst_n)
    ,.we                      (rf_lut_dir_pp2vas_we)
    ,.waddr                   (rf_lut_dir_pp2vas_waddr)
    ,.wdata                   (rf_lut_dir_pp2vas_wdata)
    ,.rclk                    (rf_lut_dir_pp2vas_rclk)
    ,.rclk_rst_n              (rf_lut_dir_pp2vas_rclk_rst_n)
    ,.re                      (rf_lut_dir_pp2vas_re)
    ,.raddr                   (rf_lut_dir_pp2vas_raddr)
    ,.rdata                   (rf_lut_dir_pp2vas_rdata)

    ,.pgcb_isol_en            (rf_lut_dir_pp2vas_isol_en)
    ,.pwr_enable_b_in         (rf_lut_dir_pp2vas_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_lut_dir_pp2vas_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_4x17 i_rf_lut_dir_pp_v (

     .wclk                    (rf_lut_dir_pp_v_wclk)
    ,.wclk_rst_n              (rf_lut_dir_pp_v_wclk_rst_n)
    ,.we                      (rf_lut_dir_pp_v_we)
    ,.waddr                   (rf_lut_dir_pp_v_waddr)
    ,.wdata                   (rf_lut_dir_pp_v_wdata)
    ,.rclk                    (rf_lut_dir_pp_v_rclk)
    ,.rclk_rst_n              (rf_lut_dir_pp_v_rclk_rst_n)
    ,.re                      (rf_lut_dir_pp_v_re)
    ,.raddr                   (rf_lut_dir_pp_v_raddr)
    ,.rdata                   (rf_lut_dir_pp_v_rdata)

    ,.pgcb_isol_en            (rf_lut_dir_pp_v_isol_en)
    ,.pwr_enable_b_in         (rf_lut_dir_pp_v_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_lut_dir_pp_v_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_64x33 i_rf_lut_dir_vasqid_v (

     .wclk                    (rf_lut_dir_vasqid_v_wclk)
    ,.wclk_rst_n              (rf_lut_dir_vasqid_v_wclk_rst_n)
    ,.we                      (rf_lut_dir_vasqid_v_we)
    ,.waddr                   (rf_lut_dir_vasqid_v_waddr)
    ,.wdata                   (rf_lut_dir_vasqid_v_wdata)
    ,.rclk                    (rf_lut_dir_vasqid_v_rclk)
    ,.rclk_rst_n              (rf_lut_dir_vasqid_v_rclk_rst_n)
    ,.re                      (rf_lut_dir_vasqid_v_re)
    ,.raddr                   (rf_lut_dir_vasqid_v_raddr)
    ,.rdata                   (rf_lut_dir_vasqid_v_rdata)

    ,.pgcb_isol_en            (rf_lut_dir_vasqid_v_isol_en)
    ,.pwr_enable_b_in         (rf_lut_dir_vasqid_v_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_lut_dir_vasqid_v_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_32x13 i_rf_lut_ldb_cq2vf_pf_ro (

     .wclk                    (rf_lut_ldb_cq2vf_pf_ro_wclk)
    ,.wclk_rst_n              (rf_lut_ldb_cq2vf_pf_ro_wclk_rst_n)
    ,.we                      (rf_lut_ldb_cq2vf_pf_ro_we)
    ,.waddr                   (rf_lut_ldb_cq2vf_pf_ro_waddr)
    ,.wdata                   (rf_lut_ldb_cq2vf_pf_ro_wdata)
    ,.rclk                    (rf_lut_ldb_cq2vf_pf_ro_rclk)
    ,.rclk_rst_n              (rf_lut_ldb_cq2vf_pf_ro_rclk_rst_n)
    ,.re                      (rf_lut_ldb_cq2vf_pf_ro_re)
    ,.raddr                   (rf_lut_ldb_cq2vf_pf_ro_raddr)
    ,.rdata                   (rf_lut_ldb_cq2vf_pf_ro_rdata)

    ,.pgcb_isol_en            (rf_lut_ldb_cq2vf_pf_ro_isol_en)
    ,.pwr_enable_b_in         (rf_lut_ldb_cq2vf_pf_ro_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_lut_ldb_cq2vf_pf_ro_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_64x27 i_rf_lut_ldb_cq_addr_l (

     .wclk                    (rf_lut_ldb_cq_addr_l_wclk)
    ,.wclk_rst_n              (rf_lut_ldb_cq_addr_l_wclk_rst_n)
    ,.we                      (rf_lut_ldb_cq_addr_l_we)
    ,.waddr                   (rf_lut_ldb_cq_addr_l_waddr)
    ,.wdata                   (rf_lut_ldb_cq_addr_l_wdata)
    ,.rclk                    (rf_lut_ldb_cq_addr_l_rclk)
    ,.rclk_rst_n              (rf_lut_ldb_cq_addr_l_rclk_rst_n)
    ,.re                      (rf_lut_ldb_cq_addr_l_re)
    ,.raddr                   (rf_lut_ldb_cq_addr_l_raddr)
    ,.rdata                   (rf_lut_ldb_cq_addr_l_rdata)

    ,.pgcb_isol_en            (rf_lut_ldb_cq_addr_l_isol_en)
    ,.pwr_enable_b_in         (rf_lut_ldb_cq_addr_l_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_lut_ldb_cq_addr_l_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_64x33 i_rf_lut_ldb_cq_addr_u (

     .wclk                    (rf_lut_ldb_cq_addr_u_wclk)
    ,.wclk_rst_n              (rf_lut_ldb_cq_addr_u_wclk_rst_n)
    ,.we                      (rf_lut_ldb_cq_addr_u_we)
    ,.waddr                   (rf_lut_ldb_cq_addr_u_waddr)
    ,.wdata                   (rf_lut_ldb_cq_addr_u_wdata)
    ,.rclk                    (rf_lut_ldb_cq_addr_u_rclk)
    ,.rclk_rst_n              (rf_lut_ldb_cq_addr_u_rclk_rst_n)
    ,.re                      (rf_lut_ldb_cq_addr_u_re)
    ,.raddr                   (rf_lut_ldb_cq_addr_u_raddr)
    ,.rdata                   (rf_lut_ldb_cq_addr_u_rdata)

    ,.pgcb_isol_en            (rf_lut_ldb_cq_addr_u_isol_en)
    ,.pwr_enable_b_in         (rf_lut_ldb_cq_addr_u_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_lut_ldb_cq_addr_u_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_64x31 i_rf_lut_ldb_cq_ai_addr_l (

     .wclk                    (rf_lut_ldb_cq_ai_addr_l_wclk)
    ,.wclk_rst_n              (rf_lut_ldb_cq_ai_addr_l_wclk_rst_n)
    ,.we                      (rf_lut_ldb_cq_ai_addr_l_we)
    ,.waddr                   (rf_lut_ldb_cq_ai_addr_l_waddr)
    ,.wdata                   (rf_lut_ldb_cq_ai_addr_l_wdata)
    ,.rclk                    (rf_lut_ldb_cq_ai_addr_l_rclk)
    ,.rclk_rst_n              (rf_lut_ldb_cq_ai_addr_l_rclk_rst_n)
    ,.re                      (rf_lut_ldb_cq_ai_addr_l_re)
    ,.raddr                   (rf_lut_ldb_cq_ai_addr_l_raddr)
    ,.rdata                   (rf_lut_ldb_cq_ai_addr_l_rdata)

    ,.pgcb_isol_en            (rf_lut_ldb_cq_ai_addr_l_isol_en)
    ,.pwr_enable_b_in         (rf_lut_ldb_cq_ai_addr_l_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_lut_ldb_cq_ai_addr_l_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_64x33 i_rf_lut_ldb_cq_ai_addr_u (

     .wclk                    (rf_lut_ldb_cq_ai_addr_u_wclk)
    ,.wclk_rst_n              (rf_lut_ldb_cq_ai_addr_u_wclk_rst_n)
    ,.we                      (rf_lut_ldb_cq_ai_addr_u_we)
    ,.waddr                   (rf_lut_ldb_cq_ai_addr_u_waddr)
    ,.wdata                   (rf_lut_ldb_cq_ai_addr_u_wdata)
    ,.rclk                    (rf_lut_ldb_cq_ai_addr_u_rclk)
    ,.rclk_rst_n              (rf_lut_ldb_cq_ai_addr_u_rclk_rst_n)
    ,.re                      (rf_lut_ldb_cq_ai_addr_u_re)
    ,.raddr                   (rf_lut_ldb_cq_ai_addr_u_raddr)
    ,.rdata                   (rf_lut_ldb_cq_ai_addr_u_rdata)

    ,.pgcb_isol_en            (rf_lut_ldb_cq_ai_addr_u_isol_en)
    ,.pwr_enable_b_in         (rf_lut_ldb_cq_ai_addr_u_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_lut_ldb_cq_ai_addr_u_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_64x33 i_rf_lut_ldb_cq_ai_data (

     .wclk                    (rf_lut_ldb_cq_ai_data_wclk)
    ,.wclk_rst_n              (rf_lut_ldb_cq_ai_data_wclk_rst_n)
    ,.we                      (rf_lut_ldb_cq_ai_data_we)
    ,.waddr                   (rf_lut_ldb_cq_ai_data_waddr)
    ,.wdata                   (rf_lut_ldb_cq_ai_data_wdata)
    ,.rclk                    (rf_lut_ldb_cq_ai_data_rclk)
    ,.rclk_rst_n              (rf_lut_ldb_cq_ai_data_rclk_rst_n)
    ,.re                      (rf_lut_ldb_cq_ai_data_re)
    ,.raddr                   (rf_lut_ldb_cq_ai_data_raddr)
    ,.rdata                   (rf_lut_ldb_cq_ai_data_rdata)

    ,.pgcb_isol_en            (rf_lut_ldb_cq_ai_data_isol_en)
    ,.pwr_enable_b_in         (rf_lut_ldb_cq_ai_data_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_lut_ldb_cq_ai_data_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_64x13 i_rf_lut_ldb_cq_isr (

     .wclk                    (rf_lut_ldb_cq_isr_wclk)
    ,.wclk_rst_n              (rf_lut_ldb_cq_isr_wclk_rst_n)
    ,.we                      (rf_lut_ldb_cq_isr_we)
    ,.waddr                   (rf_lut_ldb_cq_isr_waddr)
    ,.wdata                   (rf_lut_ldb_cq_isr_wdata)
    ,.rclk                    (rf_lut_ldb_cq_isr_rclk)
    ,.rclk_rst_n              (rf_lut_ldb_cq_isr_rclk_rst_n)
    ,.re                      (rf_lut_ldb_cq_isr_re)
    ,.raddr                   (rf_lut_ldb_cq_isr_raddr)
    ,.rdata                   (rf_lut_ldb_cq_isr_rdata)

    ,.pgcb_isol_en            (rf_lut_ldb_cq_isr_isol_en)
    ,.pwr_enable_b_in         (rf_lut_ldb_cq_isr_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_lut_ldb_cq_isr_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_64x24 i_rf_lut_ldb_cq_pasid (

     .wclk                    (rf_lut_ldb_cq_pasid_wclk)
    ,.wclk_rst_n              (rf_lut_ldb_cq_pasid_wclk_rst_n)
    ,.we                      (rf_lut_ldb_cq_pasid_we)
    ,.waddr                   (rf_lut_ldb_cq_pasid_waddr)
    ,.wdata                   (rf_lut_ldb_cq_pasid_wdata)
    ,.rclk                    (rf_lut_ldb_cq_pasid_rclk)
    ,.rclk_rst_n              (rf_lut_ldb_cq_pasid_rclk_rst_n)
    ,.re                      (rf_lut_ldb_cq_pasid_re)
    ,.raddr                   (rf_lut_ldb_cq_pasid_raddr)
    ,.rdata                   (rf_lut_ldb_cq_pasid_rdata)

    ,.pgcb_isol_en            (rf_lut_ldb_cq_pasid_isol_en)
    ,.pwr_enable_b_in         (rf_lut_ldb_cq_pasid_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_lut_ldb_cq_pasid_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_32x11 i_rf_lut_ldb_pp2vas (

     .wclk                    (rf_lut_ldb_pp2vas_wclk)
    ,.wclk_rst_n              (rf_lut_ldb_pp2vas_wclk_rst_n)
    ,.we                      (rf_lut_ldb_pp2vas_we)
    ,.waddr                   (rf_lut_ldb_pp2vas_waddr)
    ,.wdata                   (rf_lut_ldb_pp2vas_wdata)
    ,.rclk                    (rf_lut_ldb_pp2vas_rclk)
    ,.rclk_rst_n              (rf_lut_ldb_pp2vas_rclk_rst_n)
    ,.re                      (rf_lut_ldb_pp2vas_re)
    ,.raddr                   (rf_lut_ldb_pp2vas_raddr)
    ,.rdata                   (rf_lut_ldb_pp2vas_rdata)

    ,.pgcb_isol_en            (rf_lut_ldb_pp2vas_isol_en)
    ,.pwr_enable_b_in         (rf_lut_ldb_pp2vas_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_lut_ldb_pp2vas_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_8x21 i_rf_lut_ldb_qid2vqid (

     .wclk                    (rf_lut_ldb_qid2vqid_wclk)
    ,.wclk_rst_n              (rf_lut_ldb_qid2vqid_wclk_rst_n)
    ,.we                      (rf_lut_ldb_qid2vqid_we)
    ,.waddr                   (rf_lut_ldb_qid2vqid_waddr)
    ,.wdata                   (rf_lut_ldb_qid2vqid_wdata)
    ,.rclk                    (rf_lut_ldb_qid2vqid_rclk)
    ,.rclk_rst_n              (rf_lut_ldb_qid2vqid_rclk_rst_n)
    ,.re                      (rf_lut_ldb_qid2vqid_re)
    ,.raddr                   (rf_lut_ldb_qid2vqid_raddr)
    ,.rdata                   (rf_lut_ldb_qid2vqid_rdata)

    ,.pgcb_isol_en            (rf_lut_ldb_qid2vqid_isol_en)
    ,.pwr_enable_b_in         (rf_lut_ldb_qid2vqid_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_lut_ldb_qid2vqid_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_64x17 i_rf_lut_ldb_vasqid_v (

     .wclk                    (rf_lut_ldb_vasqid_v_wclk)
    ,.wclk_rst_n              (rf_lut_ldb_vasqid_v_wclk_rst_n)
    ,.we                      (rf_lut_ldb_vasqid_v_we)
    ,.waddr                   (rf_lut_ldb_vasqid_v_waddr)
    ,.wdata                   (rf_lut_ldb_vasqid_v_wdata)
    ,.rclk                    (rf_lut_ldb_vasqid_v_rclk)
    ,.rclk_rst_n              (rf_lut_ldb_vasqid_v_rclk_rst_n)
    ,.re                      (rf_lut_ldb_vasqid_v_re)
    ,.raddr                   (rf_lut_ldb_vasqid_v_raddr)
    ,.rdata                   (rf_lut_ldb_vasqid_v_rdata)

    ,.pgcb_isol_en            (rf_lut_ldb_vasqid_v_isol_en)
    ,.pwr_enable_b_in         (rf_lut_ldb_vasqid_v_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_lut_ldb_vasqid_v_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_256x31 i_rf_lut_vf_dir_vpp2pp (

     .wclk                    (rf_lut_vf_dir_vpp2pp_wclk)
    ,.wclk_rst_n              (rf_lut_vf_dir_vpp2pp_wclk_rst_n)
    ,.we                      (rf_lut_vf_dir_vpp2pp_we)
    ,.waddr                   (rf_lut_vf_dir_vpp2pp_waddr)
    ,.wdata                   (rf_lut_vf_dir_vpp2pp_wdata)
    ,.rclk                    (rf_lut_vf_dir_vpp2pp_rclk)
    ,.rclk_rst_n              (rf_lut_vf_dir_vpp2pp_rclk_rst_n)
    ,.re                      (rf_lut_vf_dir_vpp2pp_re)
    ,.raddr                   (rf_lut_vf_dir_vpp2pp_raddr)
    ,.rdata                   (rf_lut_vf_dir_vpp2pp_rdata)

    ,.pgcb_isol_en            (rf_lut_vf_dir_vpp2pp_isol_en)
    ,.pwr_enable_b_in         (rf_lut_vf_dir_vpp2pp_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_lut_vf_dir_vpp2pp_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_64x17 i_rf_lut_vf_dir_vpp_v (

     .wclk                    (rf_lut_vf_dir_vpp_v_wclk)
    ,.wclk_rst_n              (rf_lut_vf_dir_vpp_v_wclk_rst_n)
    ,.we                      (rf_lut_vf_dir_vpp_v_we)
    ,.waddr                   (rf_lut_vf_dir_vpp_v_waddr)
    ,.wdata                   (rf_lut_vf_dir_vpp_v_wdata)
    ,.rclk                    (rf_lut_vf_dir_vpp_v_rclk)
    ,.rclk_rst_n              (rf_lut_vf_dir_vpp_v_rclk_rst_n)
    ,.re                      (rf_lut_vf_dir_vpp_v_re)
    ,.raddr                   (rf_lut_vf_dir_vpp_v_raddr)
    ,.rdata                   (rf_lut_vf_dir_vpp_v_rdata)

    ,.pgcb_isol_en            (rf_lut_vf_dir_vpp_v_isol_en)
    ,.pwr_enable_b_in         (rf_lut_vf_dir_vpp_v_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_lut_vf_dir_vpp_v_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_256x31 i_rf_lut_vf_dir_vqid2qid (

     .wclk                    (rf_lut_vf_dir_vqid2qid_wclk)
    ,.wclk_rst_n              (rf_lut_vf_dir_vqid2qid_wclk_rst_n)
    ,.we                      (rf_lut_vf_dir_vqid2qid_we)
    ,.waddr                   (rf_lut_vf_dir_vqid2qid_waddr)
    ,.wdata                   (rf_lut_vf_dir_vqid2qid_wdata)
    ,.rclk                    (rf_lut_vf_dir_vqid2qid_rclk)
    ,.rclk_rst_n              (rf_lut_vf_dir_vqid2qid_rclk_rst_n)
    ,.re                      (rf_lut_vf_dir_vqid2qid_re)
    ,.raddr                   (rf_lut_vf_dir_vqid2qid_raddr)
    ,.rdata                   (rf_lut_vf_dir_vqid2qid_rdata)

    ,.pgcb_isol_en            (rf_lut_vf_dir_vqid2qid_isol_en)
    ,.pwr_enable_b_in         (rf_lut_vf_dir_vqid2qid_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_lut_vf_dir_vqid2qid_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_64x17 i_rf_lut_vf_dir_vqid_v (

     .wclk                    (rf_lut_vf_dir_vqid_v_wclk)
    ,.wclk_rst_n              (rf_lut_vf_dir_vqid_v_wclk_rst_n)
    ,.we                      (rf_lut_vf_dir_vqid_v_we)
    ,.waddr                   (rf_lut_vf_dir_vqid_v_waddr)
    ,.wdata                   (rf_lut_vf_dir_vqid_v_wdata)
    ,.rclk                    (rf_lut_vf_dir_vqid_v_rclk)
    ,.rclk_rst_n              (rf_lut_vf_dir_vqid_v_rclk_rst_n)
    ,.re                      (rf_lut_vf_dir_vqid_v_re)
    ,.raddr                   (rf_lut_vf_dir_vqid_v_raddr)
    ,.rdata                   (rf_lut_vf_dir_vqid_v_rdata)

    ,.pgcb_isol_en            (rf_lut_vf_dir_vqid_v_isol_en)
    ,.pwr_enable_b_in         (rf_lut_vf_dir_vqid_v_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_lut_vf_dir_vqid_v_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_256x25 i_rf_lut_vf_ldb_vpp2pp (

     .wclk                    (rf_lut_vf_ldb_vpp2pp_wclk)
    ,.wclk_rst_n              (rf_lut_vf_ldb_vpp2pp_wclk_rst_n)
    ,.we                      (rf_lut_vf_ldb_vpp2pp_we)
    ,.waddr                   (rf_lut_vf_ldb_vpp2pp_waddr)
    ,.wdata                   (rf_lut_vf_ldb_vpp2pp_wdata)
    ,.rclk                    (rf_lut_vf_ldb_vpp2pp_rclk)
    ,.rclk_rst_n              (rf_lut_vf_ldb_vpp2pp_rclk_rst_n)
    ,.re                      (rf_lut_vf_ldb_vpp2pp_re)
    ,.raddr                   (rf_lut_vf_ldb_vpp2pp_raddr)
    ,.rdata                   (rf_lut_vf_ldb_vpp2pp_rdata)

    ,.pgcb_isol_en            (rf_lut_vf_ldb_vpp2pp_isol_en)
    ,.pwr_enable_b_in         (rf_lut_vf_ldb_vpp2pp_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_lut_vf_ldb_vpp2pp_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_64x17 i_rf_lut_vf_ldb_vpp_v (

     .wclk                    (rf_lut_vf_ldb_vpp_v_wclk)
    ,.wclk_rst_n              (rf_lut_vf_ldb_vpp_v_wclk_rst_n)
    ,.we                      (rf_lut_vf_ldb_vpp_v_we)
    ,.waddr                   (rf_lut_vf_ldb_vpp_v_waddr)
    ,.wdata                   (rf_lut_vf_ldb_vpp_v_wdata)
    ,.rclk                    (rf_lut_vf_ldb_vpp_v_rclk)
    ,.rclk_rst_n              (rf_lut_vf_ldb_vpp_v_rclk_rst_n)
    ,.re                      (rf_lut_vf_ldb_vpp_v_re)
    ,.raddr                   (rf_lut_vf_ldb_vpp_v_raddr)
    ,.rdata                   (rf_lut_vf_ldb_vpp_v_rdata)

    ,.pgcb_isol_en            (rf_lut_vf_ldb_vpp_v_isol_en)
    ,.pwr_enable_b_in         (rf_lut_vf_ldb_vpp_v_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_lut_vf_ldb_vpp_v_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_128x27 i_rf_lut_vf_ldb_vqid2qid (

     .wclk                    (rf_lut_vf_ldb_vqid2qid_wclk)
    ,.wclk_rst_n              (rf_lut_vf_ldb_vqid2qid_wclk_rst_n)
    ,.we                      (rf_lut_vf_ldb_vqid2qid_we)
    ,.waddr                   (rf_lut_vf_ldb_vqid2qid_waddr)
    ,.wdata                   (rf_lut_vf_ldb_vqid2qid_wdata)
    ,.rclk                    (rf_lut_vf_ldb_vqid2qid_rclk)
    ,.rclk_rst_n              (rf_lut_vf_ldb_vqid2qid_rclk_rst_n)
    ,.re                      (rf_lut_vf_ldb_vqid2qid_re)
    ,.raddr                   (rf_lut_vf_ldb_vqid2qid_raddr)
    ,.rdata                   (rf_lut_vf_ldb_vqid2qid_rdata)

    ,.pgcb_isol_en            (rf_lut_vf_ldb_vqid2qid_isol_en)
    ,.pwr_enable_b_in         (rf_lut_vf_ldb_vqid2qid_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_lut_vf_ldb_vqid2qid_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_32x17 i_rf_lut_vf_ldb_vqid_v (

     .wclk                    (rf_lut_vf_ldb_vqid_v_wclk)
    ,.wclk_rst_n              (rf_lut_vf_ldb_vqid_v_wclk_rst_n)
    ,.we                      (rf_lut_vf_ldb_vqid_v_we)
    ,.waddr                   (rf_lut_vf_ldb_vqid_v_waddr)
    ,.wdata                   (rf_lut_vf_ldb_vqid_v_wdata)
    ,.rclk                    (rf_lut_vf_ldb_vqid_v_rclk)
    ,.rclk_rst_n              (rf_lut_vf_ldb_vqid_v_rclk_rst_n)
    ,.re                      (rf_lut_vf_ldb_vqid_v_re)
    ,.raddr                   (rf_lut_vf_ldb_vqid_v_raddr)
    ,.rdata                   (rf_lut_vf_ldb_vqid_v_rdata)

    ,.pgcb_isol_en            (rf_lut_vf_ldb_vqid_v_isol_en)
    ,.pwr_enable_b_in         (rf_lut_vf_ldb_vqid_v_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_lut_vf_ldb_vqid_v_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_64x33 i_rf_msix_tbl_word0 (

     .wclk                    (rf_msix_tbl_word0_wclk)
    ,.wclk_rst_n              (rf_msix_tbl_word0_wclk_rst_n)
    ,.we                      (rf_msix_tbl_word0_we)
    ,.waddr                   (rf_msix_tbl_word0_waddr)
    ,.wdata                   (rf_msix_tbl_word0_wdata)
    ,.rclk                    (rf_msix_tbl_word0_rclk)
    ,.rclk_rst_n              (rf_msix_tbl_word0_rclk_rst_n)
    ,.re                      (rf_msix_tbl_word0_re)
    ,.raddr                   (rf_msix_tbl_word0_raddr)
    ,.rdata                   (rf_msix_tbl_word0_rdata)

    ,.pgcb_isol_en            (rf_msix_tbl_word0_isol_en)
    ,.pwr_enable_b_in         (rf_msix_tbl_word0_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_msix_tbl_word0_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_64x33 i_rf_msix_tbl_word1 (

     .wclk                    (rf_msix_tbl_word1_wclk)
    ,.wclk_rst_n              (rf_msix_tbl_word1_wclk_rst_n)
    ,.we                      (rf_msix_tbl_word1_we)
    ,.waddr                   (rf_msix_tbl_word1_waddr)
    ,.wdata                   (rf_msix_tbl_word1_wdata)
    ,.rclk                    (rf_msix_tbl_word1_rclk)
    ,.rclk_rst_n              (rf_msix_tbl_word1_rclk_rst_n)
    ,.re                      (rf_msix_tbl_word1_re)
    ,.raddr                   (rf_msix_tbl_word1_raddr)
    ,.rdata                   (rf_msix_tbl_word1_rdata)

    ,.pgcb_isol_en            (rf_msix_tbl_word1_isol_en)
    ,.pwr_enable_b_in         (rf_msix_tbl_word1_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_msix_tbl_word1_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_64x33 i_rf_msix_tbl_word2 (

     .wclk                    (rf_msix_tbl_word2_wclk)
    ,.wclk_rst_n              (rf_msix_tbl_word2_wclk_rst_n)
    ,.we                      (rf_msix_tbl_word2_we)
    ,.waddr                   (rf_msix_tbl_word2_waddr)
    ,.wdata                   (rf_msix_tbl_word2_wdata)
    ,.rclk                    (rf_msix_tbl_word2_rclk)
    ,.rclk_rst_n              (rf_msix_tbl_word2_rclk_rst_n)
    ,.re                      (rf_msix_tbl_word2_re)
    ,.raddr                   (rf_msix_tbl_word2_raddr)
    ,.rdata                   (rf_msix_tbl_word2_rdata)

    ,.pgcb_isol_en            (rf_msix_tbl_word2_isol_en)
    ,.pwr_enable_b_in         (rf_msix_tbl_word2_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_msix_tbl_word2_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_32x12 i_rf_ord_qid_sn (

     .wclk                    (rf_ord_qid_sn_wclk)
    ,.wclk_rst_n              (rf_ord_qid_sn_wclk_rst_n)
    ,.we                      (rf_ord_qid_sn_we)
    ,.waddr                   (rf_ord_qid_sn_waddr)
    ,.wdata                   (rf_ord_qid_sn_wdata)
    ,.rclk                    (rf_ord_qid_sn_rclk)
    ,.rclk_rst_n              (rf_ord_qid_sn_rclk_rst_n)
    ,.re                      (rf_ord_qid_sn_re)
    ,.raddr                   (rf_ord_qid_sn_raddr)
    ,.rdata                   (rf_ord_qid_sn_rdata)

    ,.pgcb_isol_en            (rf_ord_qid_sn_isol_en)
    ,.pwr_enable_b_in         (rf_ord_qid_sn_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_ord_qid_sn_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_32x12 i_rf_ord_qid_sn_map (

     .wclk                    (rf_ord_qid_sn_map_wclk)
    ,.wclk_rst_n              (rf_ord_qid_sn_map_wclk_rst_n)
    ,.we                      (rf_ord_qid_sn_map_we)
    ,.waddr                   (rf_ord_qid_sn_map_waddr)
    ,.wdata                   (rf_ord_qid_sn_map_wdata)
    ,.rclk                    (rf_ord_qid_sn_map_rclk)
    ,.rclk_rst_n              (rf_ord_qid_sn_map_rclk_rst_n)
    ,.re                      (rf_ord_qid_sn_map_re)
    ,.raddr                   (rf_ord_qid_sn_map_raddr)
    ,.rdata                   (rf_ord_qid_sn_map_rdata)

    ,.pgcb_isol_en            (rf_ord_qid_sn_map_isol_en)
    ,.pwr_enable_b_in         (rf_ord_qid_sn_map_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_ord_qid_sn_map_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_16x160 i_rf_outbound_hcw_fifo_mem (

     .wclk                    (rf_outbound_hcw_fifo_mem_wclk)
    ,.wclk_rst_n              (rf_outbound_hcw_fifo_mem_wclk_rst_n)
    ,.we                      (rf_outbound_hcw_fifo_mem_we)
    ,.waddr                   (rf_outbound_hcw_fifo_mem_waddr)
    ,.wdata                   (rf_outbound_hcw_fifo_mem_wdata)
    ,.rclk                    (rf_outbound_hcw_fifo_mem_rclk)
    ,.rclk_rst_n              (rf_outbound_hcw_fifo_mem_rclk_rst_n)
    ,.re                      (rf_outbound_hcw_fifo_mem_re)
    ,.raddr                   (rf_outbound_hcw_fifo_mem_raddr)
    ,.rdata                   (rf_outbound_hcw_fifo_mem_rdata)

    ,.pgcb_isol_en            (rf_outbound_hcw_fifo_mem_isol_en)
    ,.pwr_enable_b_in         (rf_outbound_hcw_fifo_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_outbound_hcw_fifo_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_4x26 i_rf_qed_chp_sch_flid_ret_rx_sync_mem (

     .wclk                    (rf_qed_chp_sch_flid_ret_rx_sync_mem_wclk)
    ,.wclk_rst_n              (rf_qed_chp_sch_flid_ret_rx_sync_mem_wclk_rst_n)
    ,.we                      (rf_qed_chp_sch_flid_ret_rx_sync_mem_we)
    ,.waddr                   (rf_qed_chp_sch_flid_ret_rx_sync_mem_waddr)
    ,.wdata                   (rf_qed_chp_sch_flid_ret_rx_sync_mem_wdata)
    ,.rclk                    (rf_qed_chp_sch_flid_ret_rx_sync_mem_rclk)
    ,.rclk_rst_n              (rf_qed_chp_sch_flid_ret_rx_sync_mem_rclk_rst_n)
    ,.re                      (rf_qed_chp_sch_flid_ret_rx_sync_mem_re)
    ,.raddr                   (rf_qed_chp_sch_flid_ret_rx_sync_mem_raddr)
    ,.rdata                   (rf_qed_chp_sch_flid_ret_rx_sync_mem_rdata)

    ,.pgcb_isol_en            (rf_qed_chp_sch_flid_ret_rx_sync_mem_isol_en)
    ,.pwr_enable_b_in         (rf_qed_chp_sch_flid_ret_rx_sync_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_qed_chp_sch_flid_ret_rx_sync_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_8x177 i_rf_qed_chp_sch_rx_sync_mem (

     .wclk                    (rf_qed_chp_sch_rx_sync_mem_wclk)
    ,.wclk_rst_n              (rf_qed_chp_sch_rx_sync_mem_wclk_rst_n)
    ,.we                      (rf_qed_chp_sch_rx_sync_mem_we)
    ,.waddr                   (rf_qed_chp_sch_rx_sync_mem_waddr)
    ,.wdata                   (rf_qed_chp_sch_rx_sync_mem_wdata)
    ,.rclk                    (rf_qed_chp_sch_rx_sync_mem_rclk)
    ,.rclk_rst_n              (rf_qed_chp_sch_rx_sync_mem_rclk_rst_n)
    ,.re                      (rf_qed_chp_sch_rx_sync_mem_re)
    ,.raddr                   (rf_qed_chp_sch_rx_sync_mem_raddr)
    ,.rdata                   (rf_qed_chp_sch_rx_sync_mem_rdata)

    ,.pgcb_isol_en            (rf_qed_chp_sch_rx_sync_mem_isol_en)
    ,.pwr_enable_b_in         (rf_qed_chp_sch_rx_sync_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_qed_chp_sch_rx_sync_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_8x197 i_rf_qed_to_cq_fifo_mem (

     .wclk                    (rf_qed_to_cq_fifo_mem_wclk)
    ,.wclk_rst_n              (rf_qed_to_cq_fifo_mem_wclk_rst_n)
    ,.we                      (rf_qed_to_cq_fifo_mem_we)
    ,.waddr                   (rf_qed_to_cq_fifo_mem_waddr)
    ,.wdata                   (rf_qed_to_cq_fifo_mem_wdata)
    ,.rclk                    (rf_qed_to_cq_fifo_mem_rclk)
    ,.rclk_rst_n              (rf_qed_to_cq_fifo_mem_rclk_rst_n)
    ,.re                      (rf_qed_to_cq_fifo_mem_re)
    ,.raddr                   (rf_qed_to_cq_fifo_mem_raddr)
    ,.rdata                   (rf_qed_to_cq_fifo_mem_rdata)

    ,.pgcb_isol_en            (rf_qed_to_cq_fifo_mem_isol_en)
    ,.pwr_enable_b_in         (rf_qed_to_cq_fifo_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_qed_to_cq_fifo_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_2048x16 i_rf_reord_cnt_mem (

     .wclk                    (rf_reord_cnt_mem_wclk)
    ,.wclk_rst_n              (rf_reord_cnt_mem_wclk_rst_n)
    ,.we                      (rf_reord_cnt_mem_we)
    ,.waddr                   (rf_reord_cnt_mem_waddr)
    ,.wdata                   (rf_reord_cnt_mem_wdata)
    ,.rclk                    (rf_reord_cnt_mem_rclk)
    ,.rclk_rst_n              (rf_reord_cnt_mem_rclk_rst_n)
    ,.re                      (rf_reord_cnt_mem_re)
    ,.raddr                   (rf_reord_cnt_mem_raddr)
    ,.rdata                   (rf_reord_cnt_mem_rdata)

    ,.pgcb_isol_en            (rf_reord_cnt_mem_isol_en)
    ,.pwr_enable_b_in         (rf_reord_cnt_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_reord_cnt_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_2048x17 i_rf_reord_dirhp_mem (

     .wclk                    (rf_reord_dirhp_mem_wclk)
    ,.wclk_rst_n              (rf_reord_dirhp_mem_wclk_rst_n)
    ,.we                      (rf_reord_dirhp_mem_we)
    ,.waddr                   (rf_reord_dirhp_mem_waddr)
    ,.wdata                   (rf_reord_dirhp_mem_wdata)
    ,.rclk                    (rf_reord_dirhp_mem_rclk)
    ,.rclk_rst_n              (rf_reord_dirhp_mem_rclk_rst_n)
    ,.re                      (rf_reord_dirhp_mem_re)
    ,.raddr                   (rf_reord_dirhp_mem_raddr)
    ,.rdata                   (rf_reord_dirhp_mem_rdata)

    ,.pgcb_isol_en            (rf_reord_dirhp_mem_isol_en)
    ,.pwr_enable_b_in         (rf_reord_dirhp_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_reord_dirhp_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_2048x17 i_rf_reord_dirtp_mem (

     .wclk                    (rf_reord_dirtp_mem_wclk)
    ,.wclk_rst_n              (rf_reord_dirtp_mem_wclk_rst_n)
    ,.we                      (rf_reord_dirtp_mem_we)
    ,.waddr                   (rf_reord_dirtp_mem_waddr)
    ,.wdata                   (rf_reord_dirtp_mem_wdata)
    ,.rclk                    (rf_reord_dirtp_mem_rclk)
    ,.rclk_rst_n              (rf_reord_dirtp_mem_rclk_rst_n)
    ,.re                      (rf_reord_dirtp_mem_re)
    ,.raddr                   (rf_reord_dirtp_mem_raddr)
    ,.rdata                   (rf_reord_dirtp_mem_rdata)

    ,.pgcb_isol_en            (rf_reord_dirtp_mem_isol_en)
    ,.pwr_enable_b_in         (rf_reord_dirtp_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_reord_dirtp_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_2048x17 i_rf_reord_lbhp_mem (

     .wclk                    (rf_reord_lbhp_mem_wclk)
    ,.wclk_rst_n              (rf_reord_lbhp_mem_wclk_rst_n)
    ,.we                      (rf_reord_lbhp_mem_we)
    ,.waddr                   (rf_reord_lbhp_mem_waddr)
    ,.wdata                   (rf_reord_lbhp_mem_wdata)
    ,.rclk                    (rf_reord_lbhp_mem_rclk)
    ,.rclk_rst_n              (rf_reord_lbhp_mem_rclk_rst_n)
    ,.re                      (rf_reord_lbhp_mem_re)
    ,.raddr                   (rf_reord_lbhp_mem_raddr)
    ,.rdata                   (rf_reord_lbhp_mem_rdata)

    ,.pgcb_isol_en            (rf_reord_lbhp_mem_isol_en)
    ,.pwr_enable_b_in         (rf_reord_lbhp_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_reord_lbhp_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_2048x17 i_rf_reord_lbtp_mem (

     .wclk                    (rf_reord_lbtp_mem_wclk)
    ,.wclk_rst_n              (rf_reord_lbtp_mem_wclk_rst_n)
    ,.we                      (rf_reord_lbtp_mem_we)
    ,.waddr                   (rf_reord_lbtp_mem_waddr)
    ,.wdata                   (rf_reord_lbtp_mem_wdata)
    ,.rclk                    (rf_reord_lbtp_mem_rclk)
    ,.rclk_rst_n              (rf_reord_lbtp_mem_rclk_rst_n)
    ,.re                      (rf_reord_lbtp_mem_re)
    ,.raddr                   (rf_reord_lbtp_mem_raddr)
    ,.rdata                   (rf_reord_lbtp_mem_rdata)

    ,.pgcb_isol_en            (rf_reord_lbtp_mem_isol_en)
    ,.pwr_enable_b_in         (rf_reord_lbtp_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_reord_lbtp_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_2048x25 i_rf_reord_st_mem (

     .wclk                    (rf_reord_st_mem_wclk)
    ,.wclk_rst_n              (rf_reord_st_mem_wclk_rst_n)
    ,.we                      (rf_reord_st_mem_we)
    ,.waddr                   (rf_reord_st_mem_waddr)
    ,.wdata                   (rf_reord_st_mem_wdata)
    ,.rclk                    (rf_reord_st_mem_rclk)
    ,.rclk_rst_n              (rf_reord_st_mem_rclk_rst_n)
    ,.re                      (rf_reord_st_mem_re)
    ,.raddr                   (rf_reord_st_mem_raddr)
    ,.rdata                   (rf_reord_st_mem_rdata)

    ,.pgcb_isol_en            (rf_reord_st_mem_isol_en)
    ,.pwr_enable_b_in         (rf_reord_st_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_reord_st_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_4x204 i_rf_rop_chp_rop_hcw_fifo_mem (

     .wclk                    (rf_rop_chp_rop_hcw_fifo_mem_wclk)
    ,.wclk_rst_n              (rf_rop_chp_rop_hcw_fifo_mem_wclk_rst_n)
    ,.we                      (rf_rop_chp_rop_hcw_fifo_mem_we)
    ,.waddr                   (rf_rop_chp_rop_hcw_fifo_mem_waddr)
    ,.wdata                   (rf_rop_chp_rop_hcw_fifo_mem_wdata)
    ,.rclk                    (rf_rop_chp_rop_hcw_fifo_mem_rclk)
    ,.rclk_rst_n              (rf_rop_chp_rop_hcw_fifo_mem_rclk_rst_n)
    ,.re                      (rf_rop_chp_rop_hcw_fifo_mem_re)
    ,.raddr                   (rf_rop_chp_rop_hcw_fifo_mem_raddr)
    ,.rdata                   (rf_rop_chp_rop_hcw_fifo_mem_rdata)

    ,.pgcb_isol_en            (rf_rop_chp_rop_hcw_fifo_mem_isol_en)
    ,.pwr_enable_b_in         (rf_rop_chp_rop_hcw_fifo_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_rop_chp_rop_hcw_fifo_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_128x270 i_rf_sch_out_fifo (

     .wclk                    (rf_sch_out_fifo_wclk)
    ,.wclk_rst_n              (rf_sch_out_fifo_wclk_rst_n)
    ,.we                      (rf_sch_out_fifo_we)
    ,.waddr                   (rf_sch_out_fifo_waddr)
    ,.wdata                   (rf_sch_out_fifo_wdata)
    ,.rclk                    (rf_sch_out_fifo_rclk)
    ,.rclk_rst_n              (rf_sch_out_fifo_rclk_rst_n)
    ,.re                      (rf_sch_out_fifo_re)
    ,.raddr                   (rf_sch_out_fifo_raddr)
    ,.rdata                   (rf_sch_out_fifo_rdata)

    ,.pgcb_isol_en            (rf_sch_out_fifo_isol_en)
    ,.pwr_enable_b_in         (rf_sch_out_fifo_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_sch_out_fifo_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_16x12 i_rf_sn0_order_shft_mem (

     .wclk                    (rf_sn0_order_shft_mem_wclk)
    ,.wclk_rst_n              (rf_sn0_order_shft_mem_wclk_rst_n)
    ,.we                      (rf_sn0_order_shft_mem_we)
    ,.waddr                   (rf_sn0_order_shft_mem_waddr)
    ,.wdata                   (rf_sn0_order_shft_mem_wdata)
    ,.rclk                    (rf_sn0_order_shft_mem_rclk)
    ,.rclk_rst_n              (rf_sn0_order_shft_mem_rclk_rst_n)
    ,.re                      (rf_sn0_order_shft_mem_re)
    ,.raddr                   (rf_sn0_order_shft_mem_raddr)
    ,.rdata                   (rf_sn0_order_shft_mem_rdata)

    ,.pgcb_isol_en            (rf_sn0_order_shft_mem_isol_en)
    ,.pwr_enable_b_in         (rf_sn0_order_shft_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_sn0_order_shft_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_16x12 i_rf_sn1_order_shft_mem (

     .wclk                    (rf_sn1_order_shft_mem_wclk)
    ,.wclk_rst_n              (rf_sn1_order_shft_mem_wclk_rst_n)
    ,.we                      (rf_sn1_order_shft_mem_we)
    ,.waddr                   (rf_sn1_order_shft_mem_waddr)
    ,.wdata                   (rf_sn1_order_shft_mem_wdata)
    ,.rclk                    (rf_sn1_order_shft_mem_rclk)
    ,.rclk_rst_n              (rf_sn1_order_shft_mem_rclk_rst_n)
    ,.re                      (rf_sn1_order_shft_mem_re)
    ,.raddr                   (rf_sn1_order_shft_mem_raddr)
    ,.rdata                   (rf_sn1_order_shft_mem_rdata)

    ,.pgcb_isol_en            (rf_sn1_order_shft_mem_isol_en)
    ,.pwr_enable_b_in         (rf_sn1_order_shft_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_sn1_order_shft_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_4x21 i_rf_sn_complete_fifo_mem (

     .wclk                    (rf_sn_complete_fifo_mem_wclk)
    ,.wclk_rst_n              (rf_sn_complete_fifo_mem_wclk_rst_n)
    ,.we                      (rf_sn_complete_fifo_mem_we)
    ,.waddr                   (rf_sn_complete_fifo_mem_waddr)
    ,.wdata                   (rf_sn_complete_fifo_mem_wdata)
    ,.rclk                    (rf_sn_complete_fifo_mem_rclk)
    ,.rclk_rst_n              (rf_sn_complete_fifo_mem_rclk_rst_n)
    ,.re                      (rf_sn_complete_fifo_mem_re)
    ,.raddr                   (rf_sn_complete_fifo_mem_raddr)
    ,.rdata                   (rf_sn_complete_fifo_mem_rdata)

    ,.pgcb_isol_en            (rf_sn_complete_fifo_mem_isol_en)
    ,.pwr_enable_b_in         (rf_sn_complete_fifo_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_sn_complete_fifo_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_32x13 i_rf_sn_ordered_fifo_mem (

     .wclk                    (rf_sn_ordered_fifo_mem_wclk)
    ,.wclk_rst_n              (rf_sn_ordered_fifo_mem_wclk_rst_n)
    ,.we                      (rf_sn_ordered_fifo_mem_we)
    ,.waddr                   (rf_sn_ordered_fifo_mem_waddr)
    ,.wdata                   (rf_sn_ordered_fifo_mem_wdata)
    ,.rclk                    (rf_sn_ordered_fifo_mem_rclk)
    ,.rclk_rst_n              (rf_sn_ordered_fifo_mem_rclk_rst_n)
    ,.re                      (rf_sn_ordered_fifo_mem_re)
    ,.raddr                   (rf_sn_ordered_fifo_mem_raddr)
    ,.rdata                   (rf_sn_ordered_fifo_mem_rdata)

    ,.pgcb_isol_en            (rf_sn_ordered_fifo_mem_isol_en)
    ,.pwr_enable_b_in         (rf_sn_ordered_fifo_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_sn_ordered_fifo_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_64x14 i_rf_threshold_r_pipe_dir_mem (

     .wclk                    (rf_threshold_r_pipe_dir_mem_wclk)
    ,.wclk_rst_n              (rf_threshold_r_pipe_dir_mem_wclk_rst_n)
    ,.we                      (rf_threshold_r_pipe_dir_mem_we)
    ,.waddr                   (rf_threshold_r_pipe_dir_mem_waddr)
    ,.wdata                   (rf_threshold_r_pipe_dir_mem_wdata)
    ,.rclk                    (rf_threshold_r_pipe_dir_mem_rclk)
    ,.rclk_rst_n              (rf_threshold_r_pipe_dir_mem_rclk_rst_n)
    ,.re                      (rf_threshold_r_pipe_dir_mem_re)
    ,.raddr                   (rf_threshold_r_pipe_dir_mem_raddr)
    ,.rdata                   (rf_threshold_r_pipe_dir_mem_rdata)

    ,.pgcb_isol_en            (rf_threshold_r_pipe_dir_mem_isol_en)
    ,.pwr_enable_b_in         (rf_threshold_r_pipe_dir_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_threshold_r_pipe_dir_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

hqm_system_mem_AW_rf_pg_64x14 i_rf_threshold_r_pipe_ldb_mem (

     .wclk                    (rf_threshold_r_pipe_ldb_mem_wclk)
    ,.wclk_rst_n              (rf_threshold_r_pipe_ldb_mem_wclk_rst_n)
    ,.we                      (rf_threshold_r_pipe_ldb_mem_we)
    ,.waddr                   (rf_threshold_r_pipe_ldb_mem_waddr)
    ,.wdata                   (rf_threshold_r_pipe_ldb_mem_wdata)
    ,.rclk                    (rf_threshold_r_pipe_ldb_mem_rclk)
    ,.rclk_rst_n              (rf_threshold_r_pipe_ldb_mem_rclk_rst_n)
    ,.re                      (rf_threshold_r_pipe_ldb_mem_re)
    ,.raddr                   (rf_threshold_r_pipe_ldb_mem_raddr)
    ,.rdata                   (rf_threshold_r_pipe_ldb_mem_rdata)

    ,.pgcb_isol_en            (rf_threshold_r_pipe_ldb_mem_isol_en)
    ,.pwr_enable_b_in         (rf_threshold_r_pipe_ldb_mem_pwr_enable_b_in)
    ,.pwr_enable_b_out        (rf_threshold_r_pipe_ldb_mem_pwr_enable_b_out)

    ,.ip_reset_b              (ip_reset_b)

    ,.fscan_byprst_b          (fscan_byprst_b)
    ,.fscan_clkungate         (fscan_clkungate)
    ,.fscan_rstbypen          (fscan_rstbypen)
);

endmodule

