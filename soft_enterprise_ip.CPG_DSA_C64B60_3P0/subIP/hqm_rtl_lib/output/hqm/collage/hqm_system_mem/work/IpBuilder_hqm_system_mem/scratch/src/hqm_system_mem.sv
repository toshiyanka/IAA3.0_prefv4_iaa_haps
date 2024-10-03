// reuse-pragma startSub [InsertComponentPrefix %subText 7]
module hqm_system_mem (

     input  logic                       rf_alarm_vf_synd0_wclk
    ,input  logic                       rf_alarm_vf_synd0_wclk_rst_n
    ,input  logic                       rf_alarm_vf_synd0_we
    ,input  logic[ (   4 ) -1 : 0 ]     rf_alarm_vf_synd0_waddr
    ,input  logic[ (  30 ) -1 : 0 ]     rf_alarm_vf_synd0_wdata
    ,input  logic                       rf_alarm_vf_synd0_rclk
    ,input  logic                       rf_alarm_vf_synd0_rclk_rst_n
    ,input  logic                       rf_alarm_vf_synd0_re
    ,input  logic[ (   4 ) -1 : 0 ]     rf_alarm_vf_synd0_raddr
    ,output logic[ (  30 ) -1 : 0 ]     rf_alarm_vf_synd0_rdata

    ,input  logic                       rf_alarm_vf_synd0_isol_en
    ,input  logic                       rf_alarm_vf_synd0_pwr_enable_b_in
    ,output logic                       rf_alarm_vf_synd0_pwr_enable_b_out

    ,input  logic                       rf_alarm_vf_synd1_wclk
    ,input  logic                       rf_alarm_vf_synd1_wclk_rst_n
    ,input  logic                       rf_alarm_vf_synd1_we
    ,input  logic[ (   4 ) -1 : 0 ]     rf_alarm_vf_synd1_waddr
    ,input  logic[ (  32 ) -1 : 0 ]     rf_alarm_vf_synd1_wdata
    ,input  logic                       rf_alarm_vf_synd1_rclk
    ,input  logic                       rf_alarm_vf_synd1_rclk_rst_n
    ,input  logic                       rf_alarm_vf_synd1_re
    ,input  logic[ (   4 ) -1 : 0 ]     rf_alarm_vf_synd1_raddr
    ,output logic[ (  32 ) -1 : 0 ]     rf_alarm_vf_synd1_rdata

    ,input  logic                       rf_alarm_vf_synd1_isol_en
    ,input  logic                       rf_alarm_vf_synd1_pwr_enable_b_in
    ,output logic                       rf_alarm_vf_synd1_pwr_enable_b_out

    ,input  logic                       rf_alarm_vf_synd2_wclk
    ,input  logic                       rf_alarm_vf_synd2_wclk_rst_n
    ,input  logic                       rf_alarm_vf_synd2_we
    ,input  logic[ (   4 ) -1 : 0 ]     rf_alarm_vf_synd2_waddr
    ,input  logic[ (  32 ) -1 : 0 ]     rf_alarm_vf_synd2_wdata
    ,input  logic                       rf_alarm_vf_synd2_rclk
    ,input  logic                       rf_alarm_vf_synd2_rclk_rst_n
    ,input  logic                       rf_alarm_vf_synd2_re
    ,input  logic[ (   4 ) -1 : 0 ]     rf_alarm_vf_synd2_raddr
    ,output logic[ (  32 ) -1 : 0 ]     rf_alarm_vf_synd2_rdata

    ,input  logic                       rf_alarm_vf_synd2_isol_en
    ,input  logic                       rf_alarm_vf_synd2_pwr_enable_b_in
    ,output logic                       rf_alarm_vf_synd2_pwr_enable_b_out

    ,input  logic                       rf_aqed_chp_sch_rx_sync_mem_wclk
    ,input  logic                       rf_aqed_chp_sch_rx_sync_mem_wclk_rst_n
    ,input  logic                       rf_aqed_chp_sch_rx_sync_mem_we
    ,input  logic[ (   2 ) -1 : 0 ]     rf_aqed_chp_sch_rx_sync_mem_waddr
    ,input  logic[ ( 179 ) -1 : 0 ]     rf_aqed_chp_sch_rx_sync_mem_wdata
    ,input  logic                       rf_aqed_chp_sch_rx_sync_mem_rclk
    ,input  logic                       rf_aqed_chp_sch_rx_sync_mem_rclk_rst_n
    ,input  logic                       rf_aqed_chp_sch_rx_sync_mem_re
    ,input  logic[ (   2 ) -1 : 0 ]     rf_aqed_chp_sch_rx_sync_mem_raddr
    ,output logic[ ( 179 ) -1 : 0 ]     rf_aqed_chp_sch_rx_sync_mem_rdata

    ,input  logic                       rf_aqed_chp_sch_rx_sync_mem_isol_en
    ,input  logic                       rf_aqed_chp_sch_rx_sync_mem_pwr_enable_b_in
    ,output logic                       rf_aqed_chp_sch_rx_sync_mem_pwr_enable_b_out

    ,input  logic                       rf_chp_chp_rop_hcw_fifo_mem_wclk
    ,input  logic                       rf_chp_chp_rop_hcw_fifo_mem_wclk_rst_n
    ,input  logic                       rf_chp_chp_rop_hcw_fifo_mem_we
    ,input  logic[ (   4 ) -1 : 0 ]     rf_chp_chp_rop_hcw_fifo_mem_waddr
    ,input  logic[ ( 201 ) -1 : 0 ]     rf_chp_chp_rop_hcw_fifo_mem_wdata
    ,input  logic                       rf_chp_chp_rop_hcw_fifo_mem_rclk
    ,input  logic                       rf_chp_chp_rop_hcw_fifo_mem_rclk_rst_n
    ,input  logic                       rf_chp_chp_rop_hcw_fifo_mem_re
    ,input  logic[ (   4 ) -1 : 0 ]     rf_chp_chp_rop_hcw_fifo_mem_raddr
    ,output logic[ ( 201 ) -1 : 0 ]     rf_chp_chp_rop_hcw_fifo_mem_rdata

    ,input  logic                       rf_chp_chp_rop_hcw_fifo_mem_isol_en
    ,input  logic                       rf_chp_chp_rop_hcw_fifo_mem_pwr_enable_b_in
    ,output logic                       rf_chp_chp_rop_hcw_fifo_mem_pwr_enable_b_out

    ,input  logic                       rf_chp_lsp_ap_cmp_fifo_mem_wclk
    ,input  logic                       rf_chp_lsp_ap_cmp_fifo_mem_wclk_rst_n
    ,input  logic                       rf_chp_lsp_ap_cmp_fifo_mem_we
    ,input  logic[ (   4 ) -1 : 0 ]     rf_chp_lsp_ap_cmp_fifo_mem_waddr
    ,input  logic[ (  74 ) -1 : 0 ]     rf_chp_lsp_ap_cmp_fifo_mem_wdata
    ,input  logic                       rf_chp_lsp_ap_cmp_fifo_mem_rclk
    ,input  logic                       rf_chp_lsp_ap_cmp_fifo_mem_rclk_rst_n
    ,input  logic                       rf_chp_lsp_ap_cmp_fifo_mem_re
    ,input  logic[ (   4 ) -1 : 0 ]     rf_chp_lsp_ap_cmp_fifo_mem_raddr
    ,output logic[ (  74 ) -1 : 0 ]     rf_chp_lsp_ap_cmp_fifo_mem_rdata

    ,input  logic                       rf_chp_lsp_ap_cmp_fifo_mem_isol_en
    ,input  logic                       rf_chp_lsp_ap_cmp_fifo_mem_pwr_enable_b_in
    ,output logic                       rf_chp_lsp_ap_cmp_fifo_mem_pwr_enable_b_out

    ,input  logic                       rf_chp_lsp_tok_fifo_mem_wclk
    ,input  logic                       rf_chp_lsp_tok_fifo_mem_wclk_rst_n
    ,input  logic                       rf_chp_lsp_tok_fifo_mem_we
    ,input  logic[ (   4 ) -1 : 0 ]     rf_chp_lsp_tok_fifo_mem_waddr
    ,input  logic[ (  29 ) -1 : 0 ]     rf_chp_lsp_tok_fifo_mem_wdata
    ,input  logic                       rf_chp_lsp_tok_fifo_mem_rclk
    ,input  logic                       rf_chp_lsp_tok_fifo_mem_rclk_rst_n
    ,input  logic                       rf_chp_lsp_tok_fifo_mem_re
    ,input  logic[ (   4 ) -1 : 0 ]     rf_chp_lsp_tok_fifo_mem_raddr
    ,output logic[ (  29 ) -1 : 0 ]     rf_chp_lsp_tok_fifo_mem_rdata

    ,input  logic                       rf_chp_lsp_tok_fifo_mem_isol_en
    ,input  logic                       rf_chp_lsp_tok_fifo_mem_pwr_enable_b_in
    ,output logic                       rf_chp_lsp_tok_fifo_mem_pwr_enable_b_out

    ,input  logic                       rf_chp_sys_tx_fifo_mem_wclk
    ,input  logic                       rf_chp_sys_tx_fifo_mem_wclk_rst_n
    ,input  logic                       rf_chp_sys_tx_fifo_mem_we
    ,input  logic[ (   3 ) -1 : 0 ]     rf_chp_sys_tx_fifo_mem_waddr
    ,input  logic[ ( 200 ) -1 : 0 ]     rf_chp_sys_tx_fifo_mem_wdata
    ,input  logic                       rf_chp_sys_tx_fifo_mem_rclk
    ,input  logic                       rf_chp_sys_tx_fifo_mem_rclk_rst_n
    ,input  logic                       rf_chp_sys_tx_fifo_mem_re
    ,input  logic[ (   3 ) -1 : 0 ]     rf_chp_sys_tx_fifo_mem_raddr
    ,output logic[ ( 200 ) -1 : 0 ]     rf_chp_sys_tx_fifo_mem_rdata

    ,input  logic                       rf_chp_sys_tx_fifo_mem_isol_en
    ,input  logic                       rf_chp_sys_tx_fifo_mem_pwr_enable_b_in
    ,output logic                       rf_chp_sys_tx_fifo_mem_pwr_enable_b_out

    ,input  logic                       rf_cmp_id_chk_enbl_mem_wclk
    ,input  logic                       rf_cmp_id_chk_enbl_mem_wclk_rst_n
    ,input  logic                       rf_cmp_id_chk_enbl_mem_we
    ,input  logic[ (   6 ) -1 : 0 ]     rf_cmp_id_chk_enbl_mem_waddr
    ,input  logic[ (   2 ) -1 : 0 ]     rf_cmp_id_chk_enbl_mem_wdata
    ,input  logic                       rf_cmp_id_chk_enbl_mem_rclk
    ,input  logic                       rf_cmp_id_chk_enbl_mem_rclk_rst_n
    ,input  logic                       rf_cmp_id_chk_enbl_mem_re
    ,input  logic[ (   6 ) -1 : 0 ]     rf_cmp_id_chk_enbl_mem_raddr
    ,output logic[ (   2 ) -1 : 0 ]     rf_cmp_id_chk_enbl_mem_rdata

    ,input  logic                       rf_cmp_id_chk_enbl_mem_isol_en
    ,input  logic                       rf_cmp_id_chk_enbl_mem_pwr_enable_b_in
    ,output logic                       rf_cmp_id_chk_enbl_mem_pwr_enable_b_out

    ,input  logic                       rf_count_rmw_pipe_dir_mem_wclk
    ,input  logic                       rf_count_rmw_pipe_dir_mem_wclk_rst_n
    ,input  logic                       rf_count_rmw_pipe_dir_mem_we
    ,input  logic[ (   6 ) -1 : 0 ]     rf_count_rmw_pipe_dir_mem_waddr
    ,input  logic[ (  16 ) -1 : 0 ]     rf_count_rmw_pipe_dir_mem_wdata
    ,input  logic                       rf_count_rmw_pipe_dir_mem_rclk
    ,input  logic                       rf_count_rmw_pipe_dir_mem_rclk_rst_n
    ,input  logic                       rf_count_rmw_pipe_dir_mem_re
    ,input  logic[ (   6 ) -1 : 0 ]     rf_count_rmw_pipe_dir_mem_raddr
    ,output logic[ (  16 ) -1 : 0 ]     rf_count_rmw_pipe_dir_mem_rdata

    ,input  logic                       rf_count_rmw_pipe_dir_mem_isol_en
    ,input  logic                       rf_count_rmw_pipe_dir_mem_pwr_enable_b_in
    ,output logic                       rf_count_rmw_pipe_dir_mem_pwr_enable_b_out

    ,input  logic                       rf_count_rmw_pipe_ldb_mem_wclk
    ,input  logic                       rf_count_rmw_pipe_ldb_mem_wclk_rst_n
    ,input  logic                       rf_count_rmw_pipe_ldb_mem_we
    ,input  logic[ (   6 ) -1 : 0 ]     rf_count_rmw_pipe_ldb_mem_waddr
    ,input  logic[ (  16 ) -1 : 0 ]     rf_count_rmw_pipe_ldb_mem_wdata
    ,input  logic                       rf_count_rmw_pipe_ldb_mem_rclk
    ,input  logic                       rf_count_rmw_pipe_ldb_mem_rclk_rst_n
    ,input  logic                       rf_count_rmw_pipe_ldb_mem_re
    ,input  logic[ (   6 ) -1 : 0 ]     rf_count_rmw_pipe_ldb_mem_raddr
    ,output logic[ (  16 ) -1 : 0 ]     rf_count_rmw_pipe_ldb_mem_rdata

    ,input  logic                       rf_count_rmw_pipe_ldb_mem_isol_en
    ,input  logic                       rf_count_rmw_pipe_ldb_mem_pwr_enable_b_in
    ,output logic                       rf_count_rmw_pipe_ldb_mem_pwr_enable_b_out

    ,input  logic                       rf_dir_cq_depth_wclk
    ,input  logic                       rf_dir_cq_depth_wclk_rst_n
    ,input  logic                       rf_dir_cq_depth_we
    ,input  logic[ (   6 ) -1 : 0 ]     rf_dir_cq_depth_waddr
    ,input  logic[ (  13 ) -1 : 0 ]     rf_dir_cq_depth_wdata
    ,input  logic                       rf_dir_cq_depth_rclk
    ,input  logic                       rf_dir_cq_depth_rclk_rst_n
    ,input  logic                       rf_dir_cq_depth_re
    ,input  logic[ (   6 ) -1 : 0 ]     rf_dir_cq_depth_raddr
    ,output logic[ (  13 ) -1 : 0 ]     rf_dir_cq_depth_rdata

    ,input  logic                       rf_dir_cq_depth_isol_en
    ,input  logic                       rf_dir_cq_depth_pwr_enable_b_in
    ,output logic                       rf_dir_cq_depth_pwr_enable_b_out

    ,input  logic                       rf_dir_cq_intr_thresh_wclk
    ,input  logic                       rf_dir_cq_intr_thresh_wclk_rst_n
    ,input  logic                       rf_dir_cq_intr_thresh_we
    ,input  logic[ (   6 ) -1 : 0 ]     rf_dir_cq_intr_thresh_waddr
    ,input  logic[ (  15 ) -1 : 0 ]     rf_dir_cq_intr_thresh_wdata
    ,input  logic                       rf_dir_cq_intr_thresh_rclk
    ,input  logic                       rf_dir_cq_intr_thresh_rclk_rst_n
    ,input  logic                       rf_dir_cq_intr_thresh_re
    ,input  logic[ (   6 ) -1 : 0 ]     rf_dir_cq_intr_thresh_raddr
    ,output logic[ (  15 ) -1 : 0 ]     rf_dir_cq_intr_thresh_rdata

    ,input  logic                       rf_dir_cq_intr_thresh_isol_en
    ,input  logic                       rf_dir_cq_intr_thresh_pwr_enable_b_in
    ,output logic                       rf_dir_cq_intr_thresh_pwr_enable_b_out

    ,input  logic                       rf_dir_cq_token_depth_select_wclk
    ,input  logic                       rf_dir_cq_token_depth_select_wclk_rst_n
    ,input  logic                       rf_dir_cq_token_depth_select_we
    ,input  logic[ (   6 ) -1 : 0 ]     rf_dir_cq_token_depth_select_waddr
    ,input  logic[ (   6 ) -1 : 0 ]     rf_dir_cq_token_depth_select_wdata
    ,input  logic                       rf_dir_cq_token_depth_select_rclk
    ,input  logic                       rf_dir_cq_token_depth_select_rclk_rst_n
    ,input  logic                       rf_dir_cq_token_depth_select_re
    ,input  logic[ (   6 ) -1 : 0 ]     rf_dir_cq_token_depth_select_raddr
    ,output logic[ (   6 ) -1 : 0 ]     rf_dir_cq_token_depth_select_rdata

    ,input  logic                       rf_dir_cq_token_depth_select_isol_en
    ,input  logic                       rf_dir_cq_token_depth_select_pwr_enable_b_in
    ,output logic                       rf_dir_cq_token_depth_select_pwr_enable_b_out

    ,input  logic                       rf_dir_cq_wptr_wclk
    ,input  logic                       rf_dir_cq_wptr_wclk_rst_n
    ,input  logic                       rf_dir_cq_wptr_we
    ,input  logic[ (   6 ) -1 : 0 ]     rf_dir_cq_wptr_waddr
    ,input  logic[ (  13 ) -1 : 0 ]     rf_dir_cq_wptr_wdata
    ,input  logic                       rf_dir_cq_wptr_rclk
    ,input  logic                       rf_dir_cq_wptr_rclk_rst_n
    ,input  logic                       rf_dir_cq_wptr_re
    ,input  logic[ (   6 ) -1 : 0 ]     rf_dir_cq_wptr_raddr
    ,output logic[ (  13 ) -1 : 0 ]     rf_dir_cq_wptr_rdata

    ,input  logic                       rf_dir_cq_wptr_isol_en
    ,input  logic                       rf_dir_cq_wptr_pwr_enable_b_in
    ,output logic                       rf_dir_cq_wptr_pwr_enable_b_out

    ,input  logic                       rf_dir_rply_req_fifo_mem_wclk
    ,input  logic                       rf_dir_rply_req_fifo_mem_wclk_rst_n
    ,input  logic                       rf_dir_rply_req_fifo_mem_we
    ,input  logic[ (   3 ) -1 : 0 ]     rf_dir_rply_req_fifo_mem_waddr
    ,input  logic[ (  60 ) -1 : 0 ]     rf_dir_rply_req_fifo_mem_wdata
    ,input  logic                       rf_dir_rply_req_fifo_mem_rclk
    ,input  logic                       rf_dir_rply_req_fifo_mem_rclk_rst_n
    ,input  logic                       rf_dir_rply_req_fifo_mem_re
    ,input  logic[ (   3 ) -1 : 0 ]     rf_dir_rply_req_fifo_mem_raddr
    ,output logic[ (  60 ) -1 : 0 ]     rf_dir_rply_req_fifo_mem_rdata

    ,input  logic                       rf_dir_rply_req_fifo_mem_isol_en
    ,input  logic                       rf_dir_rply_req_fifo_mem_pwr_enable_b_in
    ,output logic                       rf_dir_rply_req_fifo_mem_pwr_enable_b_out

    ,input  logic                       rf_dir_wb0_wclk
    ,input  logic                       rf_dir_wb0_wclk_rst_n
    ,input  logic                       rf_dir_wb0_we
    ,input  logic[ (   6 ) -1 : 0 ]     rf_dir_wb0_waddr
    ,input  logic[ ( 144 ) -1 : 0 ]     rf_dir_wb0_wdata
    ,input  logic                       rf_dir_wb0_rclk
    ,input  logic                       rf_dir_wb0_rclk_rst_n
    ,input  logic                       rf_dir_wb0_re
    ,input  logic[ (   6 ) -1 : 0 ]     rf_dir_wb0_raddr
    ,output logic[ ( 144 ) -1 : 0 ]     rf_dir_wb0_rdata

    ,input  logic                       rf_dir_wb0_isol_en
    ,input  logic                       rf_dir_wb0_pwr_enable_b_in
    ,output logic                       rf_dir_wb0_pwr_enable_b_out

    ,input  logic                       rf_dir_wb1_wclk
    ,input  logic                       rf_dir_wb1_wclk_rst_n
    ,input  logic                       rf_dir_wb1_we
    ,input  logic[ (   6 ) -1 : 0 ]     rf_dir_wb1_waddr
    ,input  logic[ ( 144 ) -1 : 0 ]     rf_dir_wb1_wdata
    ,input  logic                       rf_dir_wb1_rclk
    ,input  logic                       rf_dir_wb1_rclk_rst_n
    ,input  logic                       rf_dir_wb1_re
    ,input  logic[ (   6 ) -1 : 0 ]     rf_dir_wb1_raddr
    ,output logic[ ( 144 ) -1 : 0 ]     rf_dir_wb1_rdata

    ,input  logic                       rf_dir_wb1_isol_en
    ,input  logic                       rf_dir_wb1_pwr_enable_b_in
    ,output logic                       rf_dir_wb1_pwr_enable_b_out

    ,input  logic                       rf_dir_wb2_wclk
    ,input  logic                       rf_dir_wb2_wclk_rst_n
    ,input  logic                       rf_dir_wb2_we
    ,input  logic[ (   6 ) -1 : 0 ]     rf_dir_wb2_waddr
    ,input  logic[ ( 144 ) -1 : 0 ]     rf_dir_wb2_wdata
    ,input  logic                       rf_dir_wb2_rclk
    ,input  logic                       rf_dir_wb2_rclk_rst_n
    ,input  logic                       rf_dir_wb2_re
    ,input  logic[ (   6 ) -1 : 0 ]     rf_dir_wb2_raddr
    ,output logic[ ( 144 ) -1 : 0 ]     rf_dir_wb2_rdata

    ,input  logic                       rf_dir_wb2_isol_en
    ,input  logic                       rf_dir_wb2_pwr_enable_b_in
    ,output logic                       rf_dir_wb2_pwr_enable_b_out

    ,input  logic                       rf_hcw_enq_w_rx_sync_mem_wclk
    ,input  logic                       rf_hcw_enq_w_rx_sync_mem_wclk_rst_n
    ,input  logic                       rf_hcw_enq_w_rx_sync_mem_we
    ,input  logic[ (   4 ) -1 : 0 ]     rf_hcw_enq_w_rx_sync_mem_waddr
    ,input  logic[ ( 160 ) -1 : 0 ]     rf_hcw_enq_w_rx_sync_mem_wdata
    ,input  logic                       rf_hcw_enq_w_rx_sync_mem_rclk
    ,input  logic                       rf_hcw_enq_w_rx_sync_mem_rclk_rst_n
    ,input  logic                       rf_hcw_enq_w_rx_sync_mem_re
    ,input  logic[ (   4 ) -1 : 0 ]     rf_hcw_enq_w_rx_sync_mem_raddr
    ,output logic[ ( 160 ) -1 : 0 ]     rf_hcw_enq_w_rx_sync_mem_rdata

    ,input  logic                       rf_hcw_enq_w_rx_sync_mem_isol_en
    ,input  logic                       rf_hcw_enq_w_rx_sync_mem_pwr_enable_b_in
    ,output logic                       rf_hcw_enq_w_rx_sync_mem_pwr_enable_b_out

    ,input  logic                       rf_hist_list_a_minmax_wclk
    ,input  logic                       rf_hist_list_a_minmax_wclk_rst_n
    ,input  logic                       rf_hist_list_a_minmax_we
    ,input  logic[ (   6 ) -1 : 0 ]     rf_hist_list_a_minmax_waddr
    ,input  logic[ (  30 ) -1 : 0 ]     rf_hist_list_a_minmax_wdata
    ,input  logic                       rf_hist_list_a_minmax_rclk
    ,input  logic                       rf_hist_list_a_minmax_rclk_rst_n
    ,input  logic                       rf_hist_list_a_minmax_re
    ,input  logic[ (   6 ) -1 : 0 ]     rf_hist_list_a_minmax_raddr
    ,output logic[ (  30 ) -1 : 0 ]     rf_hist_list_a_minmax_rdata

    ,input  logic                       rf_hist_list_a_minmax_isol_en
    ,input  logic                       rf_hist_list_a_minmax_pwr_enable_b_in
    ,output logic                       rf_hist_list_a_minmax_pwr_enable_b_out

    ,input  logic                       rf_hist_list_a_ptr_wclk
    ,input  logic                       rf_hist_list_a_ptr_wclk_rst_n
    ,input  logic                       rf_hist_list_a_ptr_we
    ,input  logic[ (   6 ) -1 : 0 ]     rf_hist_list_a_ptr_waddr
    ,input  logic[ (  32 ) -1 : 0 ]     rf_hist_list_a_ptr_wdata
    ,input  logic                       rf_hist_list_a_ptr_rclk
    ,input  logic                       rf_hist_list_a_ptr_rclk_rst_n
    ,input  logic                       rf_hist_list_a_ptr_re
    ,input  logic[ (   6 ) -1 : 0 ]     rf_hist_list_a_ptr_raddr
    ,output logic[ (  32 ) -1 : 0 ]     rf_hist_list_a_ptr_rdata

    ,input  logic                       rf_hist_list_a_ptr_isol_en
    ,input  logic                       rf_hist_list_a_ptr_pwr_enable_b_in
    ,output logic                       rf_hist_list_a_ptr_pwr_enable_b_out

    ,input  logic                       rf_hist_list_minmax_wclk
    ,input  logic                       rf_hist_list_minmax_wclk_rst_n
    ,input  logic                       rf_hist_list_minmax_we
    ,input  logic[ (   6 ) -1 : 0 ]     rf_hist_list_minmax_waddr
    ,input  logic[ (  30 ) -1 : 0 ]     rf_hist_list_minmax_wdata
    ,input  logic                       rf_hist_list_minmax_rclk
    ,input  logic                       rf_hist_list_minmax_rclk_rst_n
    ,input  logic                       rf_hist_list_minmax_re
    ,input  logic[ (   6 ) -1 : 0 ]     rf_hist_list_minmax_raddr
    ,output logic[ (  30 ) -1 : 0 ]     rf_hist_list_minmax_rdata

    ,input  logic                       rf_hist_list_minmax_isol_en
    ,input  logic                       rf_hist_list_minmax_pwr_enable_b_in
    ,output logic                       rf_hist_list_minmax_pwr_enable_b_out

    ,input  logic                       rf_hist_list_ptr_wclk
    ,input  logic                       rf_hist_list_ptr_wclk_rst_n
    ,input  logic                       rf_hist_list_ptr_we
    ,input  logic[ (   6 ) -1 : 0 ]     rf_hist_list_ptr_waddr
    ,input  logic[ (  32 ) -1 : 0 ]     rf_hist_list_ptr_wdata
    ,input  logic                       rf_hist_list_ptr_rclk
    ,input  logic                       rf_hist_list_ptr_rclk_rst_n
    ,input  logic                       rf_hist_list_ptr_re
    ,input  logic[ (   6 ) -1 : 0 ]     rf_hist_list_ptr_raddr
    ,output logic[ (  32 ) -1 : 0 ]     rf_hist_list_ptr_rdata

    ,input  logic                       rf_hist_list_ptr_isol_en
    ,input  logic                       rf_hist_list_ptr_pwr_enable_b_in
    ,output logic                       rf_hist_list_ptr_pwr_enable_b_out

    ,input  logic                       rf_ldb_cq_depth_wclk
    ,input  logic                       rf_ldb_cq_depth_wclk_rst_n
    ,input  logic                       rf_ldb_cq_depth_we
    ,input  logic[ (   6 ) -1 : 0 ]     rf_ldb_cq_depth_waddr
    ,input  logic[ (  13 ) -1 : 0 ]     rf_ldb_cq_depth_wdata
    ,input  logic                       rf_ldb_cq_depth_rclk
    ,input  logic                       rf_ldb_cq_depth_rclk_rst_n
    ,input  logic                       rf_ldb_cq_depth_re
    ,input  logic[ (   6 ) -1 : 0 ]     rf_ldb_cq_depth_raddr
    ,output logic[ (  13 ) -1 : 0 ]     rf_ldb_cq_depth_rdata

    ,input  logic                       rf_ldb_cq_depth_isol_en
    ,input  logic                       rf_ldb_cq_depth_pwr_enable_b_in
    ,output logic                       rf_ldb_cq_depth_pwr_enable_b_out

    ,input  logic                       rf_ldb_cq_intr_thresh_wclk
    ,input  logic                       rf_ldb_cq_intr_thresh_wclk_rst_n
    ,input  logic                       rf_ldb_cq_intr_thresh_we
    ,input  logic[ (   6 ) -1 : 0 ]     rf_ldb_cq_intr_thresh_waddr
    ,input  logic[ (  13 ) -1 : 0 ]     rf_ldb_cq_intr_thresh_wdata
    ,input  logic                       rf_ldb_cq_intr_thresh_rclk
    ,input  logic                       rf_ldb_cq_intr_thresh_rclk_rst_n
    ,input  logic                       rf_ldb_cq_intr_thresh_re
    ,input  logic[ (   6 ) -1 : 0 ]     rf_ldb_cq_intr_thresh_raddr
    ,output logic[ (  13 ) -1 : 0 ]     rf_ldb_cq_intr_thresh_rdata

    ,input  logic                       rf_ldb_cq_intr_thresh_isol_en
    ,input  logic                       rf_ldb_cq_intr_thresh_pwr_enable_b_in
    ,output logic                       rf_ldb_cq_intr_thresh_pwr_enable_b_out

    ,input  logic                       rf_ldb_cq_on_off_threshold_wclk
    ,input  logic                       rf_ldb_cq_on_off_threshold_wclk_rst_n
    ,input  logic                       rf_ldb_cq_on_off_threshold_we
    ,input  logic[ (   6 ) -1 : 0 ]     rf_ldb_cq_on_off_threshold_waddr
    ,input  logic[ (  32 ) -1 : 0 ]     rf_ldb_cq_on_off_threshold_wdata
    ,input  logic                       rf_ldb_cq_on_off_threshold_rclk
    ,input  logic                       rf_ldb_cq_on_off_threshold_rclk_rst_n
    ,input  logic                       rf_ldb_cq_on_off_threshold_re
    ,input  logic[ (   6 ) -1 : 0 ]     rf_ldb_cq_on_off_threshold_raddr
    ,output logic[ (  32 ) -1 : 0 ]     rf_ldb_cq_on_off_threshold_rdata

    ,input  logic                       rf_ldb_cq_on_off_threshold_isol_en
    ,input  logic                       rf_ldb_cq_on_off_threshold_pwr_enable_b_in
    ,output logic                       rf_ldb_cq_on_off_threshold_pwr_enable_b_out

    ,input  logic                       rf_ldb_cq_token_depth_select_wclk
    ,input  logic                       rf_ldb_cq_token_depth_select_wclk_rst_n
    ,input  logic                       rf_ldb_cq_token_depth_select_we
    ,input  logic[ (   6 ) -1 : 0 ]     rf_ldb_cq_token_depth_select_waddr
    ,input  logic[ (   6 ) -1 : 0 ]     rf_ldb_cq_token_depth_select_wdata
    ,input  logic                       rf_ldb_cq_token_depth_select_rclk
    ,input  logic                       rf_ldb_cq_token_depth_select_rclk_rst_n
    ,input  logic                       rf_ldb_cq_token_depth_select_re
    ,input  logic[ (   6 ) -1 : 0 ]     rf_ldb_cq_token_depth_select_raddr
    ,output logic[ (   6 ) -1 : 0 ]     rf_ldb_cq_token_depth_select_rdata

    ,input  logic                       rf_ldb_cq_token_depth_select_isol_en
    ,input  logic                       rf_ldb_cq_token_depth_select_pwr_enable_b_in
    ,output logic                       rf_ldb_cq_token_depth_select_pwr_enable_b_out

    ,input  logic                       rf_ldb_cq_wptr_wclk
    ,input  logic                       rf_ldb_cq_wptr_wclk_rst_n
    ,input  logic                       rf_ldb_cq_wptr_we
    ,input  logic[ (   6 ) -1 : 0 ]     rf_ldb_cq_wptr_waddr
    ,input  logic[ (  13 ) -1 : 0 ]     rf_ldb_cq_wptr_wdata
    ,input  logic                       rf_ldb_cq_wptr_rclk
    ,input  logic                       rf_ldb_cq_wptr_rclk_rst_n
    ,input  logic                       rf_ldb_cq_wptr_re
    ,input  logic[ (   6 ) -1 : 0 ]     rf_ldb_cq_wptr_raddr
    ,output logic[ (  13 ) -1 : 0 ]     rf_ldb_cq_wptr_rdata

    ,input  logic                       rf_ldb_cq_wptr_isol_en
    ,input  logic                       rf_ldb_cq_wptr_pwr_enable_b_in
    ,output logic                       rf_ldb_cq_wptr_pwr_enable_b_out

    ,input  logic                       rf_ldb_rply_req_fifo_mem_wclk
    ,input  logic                       rf_ldb_rply_req_fifo_mem_wclk_rst_n
    ,input  logic                       rf_ldb_rply_req_fifo_mem_we
    ,input  logic[ (   3 ) -1 : 0 ]     rf_ldb_rply_req_fifo_mem_waddr
    ,input  logic[ (  60 ) -1 : 0 ]     rf_ldb_rply_req_fifo_mem_wdata
    ,input  logic                       rf_ldb_rply_req_fifo_mem_rclk
    ,input  logic                       rf_ldb_rply_req_fifo_mem_rclk_rst_n
    ,input  logic                       rf_ldb_rply_req_fifo_mem_re
    ,input  logic[ (   3 ) -1 : 0 ]     rf_ldb_rply_req_fifo_mem_raddr
    ,output logic[ (  60 ) -1 : 0 ]     rf_ldb_rply_req_fifo_mem_rdata

    ,input  logic                       rf_ldb_rply_req_fifo_mem_isol_en
    ,input  logic                       rf_ldb_rply_req_fifo_mem_pwr_enable_b_in
    ,output logic                       rf_ldb_rply_req_fifo_mem_pwr_enable_b_out

    ,input  logic                       rf_ldb_wb0_wclk
    ,input  logic                       rf_ldb_wb0_wclk_rst_n
    ,input  logic                       rf_ldb_wb0_we
    ,input  logic[ (   6 ) -1 : 0 ]     rf_ldb_wb0_waddr
    ,input  logic[ ( 144 ) -1 : 0 ]     rf_ldb_wb0_wdata
    ,input  logic                       rf_ldb_wb0_rclk
    ,input  logic                       rf_ldb_wb0_rclk_rst_n
    ,input  logic                       rf_ldb_wb0_re
    ,input  logic[ (   6 ) -1 : 0 ]     rf_ldb_wb0_raddr
    ,output logic[ ( 144 ) -1 : 0 ]     rf_ldb_wb0_rdata

    ,input  logic                       rf_ldb_wb0_isol_en
    ,input  logic                       rf_ldb_wb0_pwr_enable_b_in
    ,output logic                       rf_ldb_wb0_pwr_enable_b_out

    ,input  logic                       rf_ldb_wb1_wclk
    ,input  logic                       rf_ldb_wb1_wclk_rst_n
    ,input  logic                       rf_ldb_wb1_we
    ,input  logic[ (   6 ) -1 : 0 ]     rf_ldb_wb1_waddr
    ,input  logic[ ( 144 ) -1 : 0 ]     rf_ldb_wb1_wdata
    ,input  logic                       rf_ldb_wb1_rclk
    ,input  logic                       rf_ldb_wb1_rclk_rst_n
    ,input  logic                       rf_ldb_wb1_re
    ,input  logic[ (   6 ) -1 : 0 ]     rf_ldb_wb1_raddr
    ,output logic[ ( 144 ) -1 : 0 ]     rf_ldb_wb1_rdata

    ,input  logic                       rf_ldb_wb1_isol_en
    ,input  logic                       rf_ldb_wb1_pwr_enable_b_in
    ,output logic                       rf_ldb_wb1_pwr_enable_b_out

    ,input  logic                       rf_ldb_wb2_wclk
    ,input  logic                       rf_ldb_wb2_wclk_rst_n
    ,input  logic                       rf_ldb_wb2_we
    ,input  logic[ (   6 ) -1 : 0 ]     rf_ldb_wb2_waddr
    ,input  logic[ ( 144 ) -1 : 0 ]     rf_ldb_wb2_wdata
    ,input  logic                       rf_ldb_wb2_rclk
    ,input  logic                       rf_ldb_wb2_rclk_rst_n
    ,input  logic                       rf_ldb_wb2_re
    ,input  logic[ (   6 ) -1 : 0 ]     rf_ldb_wb2_raddr
    ,output logic[ ( 144 ) -1 : 0 ]     rf_ldb_wb2_rdata

    ,input  logic                       rf_ldb_wb2_isol_en
    ,input  logic                       rf_ldb_wb2_pwr_enable_b_in
    ,output logic                       rf_ldb_wb2_pwr_enable_b_out

    ,input  logic                       rf_lsp_reordercmp_fifo_mem_wclk
    ,input  logic                       rf_lsp_reordercmp_fifo_mem_wclk_rst_n
    ,input  logic                       rf_lsp_reordercmp_fifo_mem_we
    ,input  logic[ (   3 ) -1 : 0 ]     rf_lsp_reordercmp_fifo_mem_waddr
    ,input  logic[ (  19 ) -1 : 0 ]     rf_lsp_reordercmp_fifo_mem_wdata
    ,input  logic                       rf_lsp_reordercmp_fifo_mem_rclk
    ,input  logic                       rf_lsp_reordercmp_fifo_mem_rclk_rst_n
    ,input  logic                       rf_lsp_reordercmp_fifo_mem_re
    ,input  logic[ (   3 ) -1 : 0 ]     rf_lsp_reordercmp_fifo_mem_raddr
    ,output logic[ (  19 ) -1 : 0 ]     rf_lsp_reordercmp_fifo_mem_rdata

    ,input  logic                       rf_lsp_reordercmp_fifo_mem_isol_en
    ,input  logic                       rf_lsp_reordercmp_fifo_mem_pwr_enable_b_in
    ,output logic                       rf_lsp_reordercmp_fifo_mem_pwr_enable_b_out

    ,input  logic                       rf_lut_dir_cq2vf_pf_ro_wclk
    ,input  logic                       rf_lut_dir_cq2vf_pf_ro_wclk_rst_n
    ,input  logic                       rf_lut_dir_cq2vf_pf_ro_we
    ,input  logic[ (   5 ) -1 : 0 ]     rf_lut_dir_cq2vf_pf_ro_waddr
    ,input  logic[ (  13 ) -1 : 0 ]     rf_lut_dir_cq2vf_pf_ro_wdata
    ,input  logic                       rf_lut_dir_cq2vf_pf_ro_rclk
    ,input  logic                       rf_lut_dir_cq2vf_pf_ro_rclk_rst_n
    ,input  logic                       rf_lut_dir_cq2vf_pf_ro_re
    ,input  logic[ (   5 ) -1 : 0 ]     rf_lut_dir_cq2vf_pf_ro_raddr
    ,output logic[ (  13 ) -1 : 0 ]     rf_lut_dir_cq2vf_pf_ro_rdata

    ,input  logic                       rf_lut_dir_cq2vf_pf_ro_isol_en
    ,input  logic                       rf_lut_dir_cq2vf_pf_ro_pwr_enable_b_in
    ,output logic                       rf_lut_dir_cq2vf_pf_ro_pwr_enable_b_out

    ,input  logic                       rf_lut_dir_cq_addr_l_wclk
    ,input  logic                       rf_lut_dir_cq_addr_l_wclk_rst_n
    ,input  logic                       rf_lut_dir_cq_addr_l_we
    ,input  logic[ (   6 ) -1 : 0 ]     rf_lut_dir_cq_addr_l_waddr
    ,input  logic[ (  27 ) -1 : 0 ]     rf_lut_dir_cq_addr_l_wdata
    ,input  logic                       rf_lut_dir_cq_addr_l_rclk
    ,input  logic                       rf_lut_dir_cq_addr_l_rclk_rst_n
    ,input  logic                       rf_lut_dir_cq_addr_l_re
    ,input  logic[ (   6 ) -1 : 0 ]     rf_lut_dir_cq_addr_l_raddr
    ,output logic[ (  27 ) -1 : 0 ]     rf_lut_dir_cq_addr_l_rdata

    ,input  logic                       rf_lut_dir_cq_addr_l_isol_en
    ,input  logic                       rf_lut_dir_cq_addr_l_pwr_enable_b_in
    ,output logic                       rf_lut_dir_cq_addr_l_pwr_enable_b_out

    ,input  logic                       rf_lut_dir_cq_addr_u_wclk
    ,input  logic                       rf_lut_dir_cq_addr_u_wclk_rst_n
    ,input  logic                       rf_lut_dir_cq_addr_u_we
    ,input  logic[ (   6 ) -1 : 0 ]     rf_lut_dir_cq_addr_u_waddr
    ,input  logic[ (  33 ) -1 : 0 ]     rf_lut_dir_cq_addr_u_wdata
    ,input  logic                       rf_lut_dir_cq_addr_u_rclk
    ,input  logic                       rf_lut_dir_cq_addr_u_rclk_rst_n
    ,input  logic                       rf_lut_dir_cq_addr_u_re
    ,input  logic[ (   6 ) -1 : 0 ]     rf_lut_dir_cq_addr_u_raddr
    ,output logic[ (  33 ) -1 : 0 ]     rf_lut_dir_cq_addr_u_rdata

    ,input  logic                       rf_lut_dir_cq_addr_u_isol_en
    ,input  logic                       rf_lut_dir_cq_addr_u_pwr_enable_b_in
    ,output logic                       rf_lut_dir_cq_addr_u_pwr_enable_b_out

    ,input  logic                       rf_lut_dir_cq_ai_addr_l_wclk
    ,input  logic                       rf_lut_dir_cq_ai_addr_l_wclk_rst_n
    ,input  logic                       rf_lut_dir_cq_ai_addr_l_we
    ,input  logic[ (   6 ) -1 : 0 ]     rf_lut_dir_cq_ai_addr_l_waddr
    ,input  logic[ (  31 ) -1 : 0 ]     rf_lut_dir_cq_ai_addr_l_wdata
    ,input  logic                       rf_lut_dir_cq_ai_addr_l_rclk
    ,input  logic                       rf_lut_dir_cq_ai_addr_l_rclk_rst_n
    ,input  logic                       rf_lut_dir_cq_ai_addr_l_re
    ,input  logic[ (   6 ) -1 : 0 ]     rf_lut_dir_cq_ai_addr_l_raddr
    ,output logic[ (  31 ) -1 : 0 ]     rf_lut_dir_cq_ai_addr_l_rdata

    ,input  logic                       rf_lut_dir_cq_ai_addr_l_isol_en
    ,input  logic                       rf_lut_dir_cq_ai_addr_l_pwr_enable_b_in
    ,output logic                       rf_lut_dir_cq_ai_addr_l_pwr_enable_b_out

    ,input  logic                       rf_lut_dir_cq_ai_addr_u_wclk
    ,input  logic                       rf_lut_dir_cq_ai_addr_u_wclk_rst_n
    ,input  logic                       rf_lut_dir_cq_ai_addr_u_we
    ,input  logic[ (   6 ) -1 : 0 ]     rf_lut_dir_cq_ai_addr_u_waddr
    ,input  logic[ (  33 ) -1 : 0 ]     rf_lut_dir_cq_ai_addr_u_wdata
    ,input  logic                       rf_lut_dir_cq_ai_addr_u_rclk
    ,input  logic                       rf_lut_dir_cq_ai_addr_u_rclk_rst_n
    ,input  logic                       rf_lut_dir_cq_ai_addr_u_re
    ,input  logic[ (   6 ) -1 : 0 ]     rf_lut_dir_cq_ai_addr_u_raddr
    ,output logic[ (  33 ) -1 : 0 ]     rf_lut_dir_cq_ai_addr_u_rdata

    ,input  logic                       rf_lut_dir_cq_ai_addr_u_isol_en
    ,input  logic                       rf_lut_dir_cq_ai_addr_u_pwr_enable_b_in
    ,output logic                       rf_lut_dir_cq_ai_addr_u_pwr_enable_b_out

    ,input  logic                       rf_lut_dir_cq_ai_data_wclk
    ,input  logic                       rf_lut_dir_cq_ai_data_wclk_rst_n
    ,input  logic                       rf_lut_dir_cq_ai_data_we
    ,input  logic[ (   6 ) -1 : 0 ]     rf_lut_dir_cq_ai_data_waddr
    ,input  logic[ (  33 ) -1 : 0 ]     rf_lut_dir_cq_ai_data_wdata
    ,input  logic                       rf_lut_dir_cq_ai_data_rclk
    ,input  logic                       rf_lut_dir_cq_ai_data_rclk_rst_n
    ,input  logic                       rf_lut_dir_cq_ai_data_re
    ,input  logic[ (   6 ) -1 : 0 ]     rf_lut_dir_cq_ai_data_raddr
    ,output logic[ (  33 ) -1 : 0 ]     rf_lut_dir_cq_ai_data_rdata

    ,input  logic                       rf_lut_dir_cq_ai_data_isol_en
    ,input  logic                       rf_lut_dir_cq_ai_data_pwr_enable_b_in
    ,output logic                       rf_lut_dir_cq_ai_data_pwr_enable_b_out

    ,input  logic                       rf_lut_dir_cq_isr_wclk
    ,input  logic                       rf_lut_dir_cq_isr_wclk_rst_n
    ,input  logic                       rf_lut_dir_cq_isr_we
    ,input  logic[ (   6 ) -1 : 0 ]     rf_lut_dir_cq_isr_waddr
    ,input  logic[ (  13 ) -1 : 0 ]     rf_lut_dir_cq_isr_wdata
    ,input  logic                       rf_lut_dir_cq_isr_rclk
    ,input  logic                       rf_lut_dir_cq_isr_rclk_rst_n
    ,input  logic                       rf_lut_dir_cq_isr_re
    ,input  logic[ (   6 ) -1 : 0 ]     rf_lut_dir_cq_isr_raddr
    ,output logic[ (  13 ) -1 : 0 ]     rf_lut_dir_cq_isr_rdata

    ,input  logic                       rf_lut_dir_cq_isr_isol_en
    ,input  logic                       rf_lut_dir_cq_isr_pwr_enable_b_in
    ,output logic                       rf_lut_dir_cq_isr_pwr_enable_b_out

    ,input  logic                       rf_lut_dir_cq_pasid_wclk
    ,input  logic                       rf_lut_dir_cq_pasid_wclk_rst_n
    ,input  logic                       rf_lut_dir_cq_pasid_we
    ,input  logic[ (   6 ) -1 : 0 ]     rf_lut_dir_cq_pasid_waddr
    ,input  logic[ (  24 ) -1 : 0 ]     rf_lut_dir_cq_pasid_wdata
    ,input  logic                       rf_lut_dir_cq_pasid_rclk
    ,input  logic                       rf_lut_dir_cq_pasid_rclk_rst_n
    ,input  logic                       rf_lut_dir_cq_pasid_re
    ,input  logic[ (   6 ) -1 : 0 ]     rf_lut_dir_cq_pasid_raddr
    ,output logic[ (  24 ) -1 : 0 ]     rf_lut_dir_cq_pasid_rdata

    ,input  logic                       rf_lut_dir_cq_pasid_isol_en
    ,input  logic                       rf_lut_dir_cq_pasid_pwr_enable_b_in
    ,output logic                       rf_lut_dir_cq_pasid_pwr_enable_b_out

    ,input  logic                       rf_lut_dir_pp2vas_wclk
    ,input  logic                       rf_lut_dir_pp2vas_wclk_rst_n
    ,input  logic                       rf_lut_dir_pp2vas_we
    ,input  logic[ (   5 ) -1 : 0 ]     rf_lut_dir_pp2vas_waddr
    ,input  logic[ (  11 ) -1 : 0 ]     rf_lut_dir_pp2vas_wdata
    ,input  logic                       rf_lut_dir_pp2vas_rclk
    ,input  logic                       rf_lut_dir_pp2vas_rclk_rst_n
    ,input  logic                       rf_lut_dir_pp2vas_re
    ,input  logic[ (   5 ) -1 : 0 ]     rf_lut_dir_pp2vas_raddr
    ,output logic[ (  11 ) -1 : 0 ]     rf_lut_dir_pp2vas_rdata

    ,input  logic                       rf_lut_dir_pp2vas_isol_en
    ,input  logic                       rf_lut_dir_pp2vas_pwr_enable_b_in
    ,output logic                       rf_lut_dir_pp2vas_pwr_enable_b_out

    ,input  logic                       rf_lut_dir_pp_v_wclk
    ,input  logic                       rf_lut_dir_pp_v_wclk_rst_n
    ,input  logic                       rf_lut_dir_pp_v_we
    ,input  logic[ (   2 ) -1 : 0 ]     rf_lut_dir_pp_v_waddr
    ,input  logic[ (  17 ) -1 : 0 ]     rf_lut_dir_pp_v_wdata
    ,input  logic                       rf_lut_dir_pp_v_rclk
    ,input  logic                       rf_lut_dir_pp_v_rclk_rst_n
    ,input  logic                       rf_lut_dir_pp_v_re
    ,input  logic[ (   2 ) -1 : 0 ]     rf_lut_dir_pp_v_raddr
    ,output logic[ (  17 ) -1 : 0 ]     rf_lut_dir_pp_v_rdata

    ,input  logic                       rf_lut_dir_pp_v_isol_en
    ,input  logic                       rf_lut_dir_pp_v_pwr_enable_b_in
    ,output logic                       rf_lut_dir_pp_v_pwr_enable_b_out

    ,input  logic                       rf_lut_dir_vasqid_v_wclk
    ,input  logic                       rf_lut_dir_vasqid_v_wclk_rst_n
    ,input  logic                       rf_lut_dir_vasqid_v_we
    ,input  logic[ (   6 ) -1 : 0 ]     rf_lut_dir_vasqid_v_waddr
    ,input  logic[ (  33 ) -1 : 0 ]     rf_lut_dir_vasqid_v_wdata
    ,input  logic                       rf_lut_dir_vasqid_v_rclk
    ,input  logic                       rf_lut_dir_vasqid_v_rclk_rst_n
    ,input  logic                       rf_lut_dir_vasqid_v_re
    ,input  logic[ (   6 ) -1 : 0 ]     rf_lut_dir_vasqid_v_raddr
    ,output logic[ (  33 ) -1 : 0 ]     rf_lut_dir_vasqid_v_rdata

    ,input  logic                       rf_lut_dir_vasqid_v_isol_en
    ,input  logic                       rf_lut_dir_vasqid_v_pwr_enable_b_in
    ,output logic                       rf_lut_dir_vasqid_v_pwr_enable_b_out

    ,input  logic                       rf_lut_ldb_cq2vf_pf_ro_wclk
    ,input  logic                       rf_lut_ldb_cq2vf_pf_ro_wclk_rst_n
    ,input  logic                       rf_lut_ldb_cq2vf_pf_ro_we
    ,input  logic[ (   5 ) -1 : 0 ]     rf_lut_ldb_cq2vf_pf_ro_waddr
    ,input  logic[ (  13 ) -1 : 0 ]     rf_lut_ldb_cq2vf_pf_ro_wdata
    ,input  logic                       rf_lut_ldb_cq2vf_pf_ro_rclk
    ,input  logic                       rf_lut_ldb_cq2vf_pf_ro_rclk_rst_n
    ,input  logic                       rf_lut_ldb_cq2vf_pf_ro_re
    ,input  logic[ (   5 ) -1 : 0 ]     rf_lut_ldb_cq2vf_pf_ro_raddr
    ,output logic[ (  13 ) -1 : 0 ]     rf_lut_ldb_cq2vf_pf_ro_rdata

    ,input  logic                       rf_lut_ldb_cq2vf_pf_ro_isol_en
    ,input  logic                       rf_lut_ldb_cq2vf_pf_ro_pwr_enable_b_in
    ,output logic                       rf_lut_ldb_cq2vf_pf_ro_pwr_enable_b_out

    ,input  logic                       rf_lut_ldb_cq_addr_l_wclk
    ,input  logic                       rf_lut_ldb_cq_addr_l_wclk_rst_n
    ,input  logic                       rf_lut_ldb_cq_addr_l_we
    ,input  logic[ (   6 ) -1 : 0 ]     rf_lut_ldb_cq_addr_l_waddr
    ,input  logic[ (  27 ) -1 : 0 ]     rf_lut_ldb_cq_addr_l_wdata
    ,input  logic                       rf_lut_ldb_cq_addr_l_rclk
    ,input  logic                       rf_lut_ldb_cq_addr_l_rclk_rst_n
    ,input  logic                       rf_lut_ldb_cq_addr_l_re
    ,input  logic[ (   6 ) -1 : 0 ]     rf_lut_ldb_cq_addr_l_raddr
    ,output logic[ (  27 ) -1 : 0 ]     rf_lut_ldb_cq_addr_l_rdata

    ,input  logic                       rf_lut_ldb_cq_addr_l_isol_en
    ,input  logic                       rf_lut_ldb_cq_addr_l_pwr_enable_b_in
    ,output logic                       rf_lut_ldb_cq_addr_l_pwr_enable_b_out

    ,input  logic                       rf_lut_ldb_cq_addr_u_wclk
    ,input  logic                       rf_lut_ldb_cq_addr_u_wclk_rst_n
    ,input  logic                       rf_lut_ldb_cq_addr_u_we
    ,input  logic[ (   6 ) -1 : 0 ]     rf_lut_ldb_cq_addr_u_waddr
    ,input  logic[ (  33 ) -1 : 0 ]     rf_lut_ldb_cq_addr_u_wdata
    ,input  logic                       rf_lut_ldb_cq_addr_u_rclk
    ,input  logic                       rf_lut_ldb_cq_addr_u_rclk_rst_n
    ,input  logic                       rf_lut_ldb_cq_addr_u_re
    ,input  logic[ (   6 ) -1 : 0 ]     rf_lut_ldb_cq_addr_u_raddr
    ,output logic[ (  33 ) -1 : 0 ]     rf_lut_ldb_cq_addr_u_rdata

    ,input  logic                       rf_lut_ldb_cq_addr_u_isol_en
    ,input  logic                       rf_lut_ldb_cq_addr_u_pwr_enable_b_in
    ,output logic                       rf_lut_ldb_cq_addr_u_pwr_enable_b_out

    ,input  logic                       rf_lut_ldb_cq_ai_addr_l_wclk
    ,input  logic                       rf_lut_ldb_cq_ai_addr_l_wclk_rst_n
    ,input  logic                       rf_lut_ldb_cq_ai_addr_l_we
    ,input  logic[ (   6 ) -1 : 0 ]     rf_lut_ldb_cq_ai_addr_l_waddr
    ,input  logic[ (  31 ) -1 : 0 ]     rf_lut_ldb_cq_ai_addr_l_wdata
    ,input  logic                       rf_lut_ldb_cq_ai_addr_l_rclk
    ,input  logic                       rf_lut_ldb_cq_ai_addr_l_rclk_rst_n
    ,input  logic                       rf_lut_ldb_cq_ai_addr_l_re
    ,input  logic[ (   6 ) -1 : 0 ]     rf_lut_ldb_cq_ai_addr_l_raddr
    ,output logic[ (  31 ) -1 : 0 ]     rf_lut_ldb_cq_ai_addr_l_rdata

    ,input  logic                       rf_lut_ldb_cq_ai_addr_l_isol_en
    ,input  logic                       rf_lut_ldb_cq_ai_addr_l_pwr_enable_b_in
    ,output logic                       rf_lut_ldb_cq_ai_addr_l_pwr_enable_b_out

    ,input  logic                       rf_lut_ldb_cq_ai_addr_u_wclk
    ,input  logic                       rf_lut_ldb_cq_ai_addr_u_wclk_rst_n
    ,input  logic                       rf_lut_ldb_cq_ai_addr_u_we
    ,input  logic[ (   6 ) -1 : 0 ]     rf_lut_ldb_cq_ai_addr_u_waddr
    ,input  logic[ (  33 ) -1 : 0 ]     rf_lut_ldb_cq_ai_addr_u_wdata
    ,input  logic                       rf_lut_ldb_cq_ai_addr_u_rclk
    ,input  logic                       rf_lut_ldb_cq_ai_addr_u_rclk_rst_n
    ,input  logic                       rf_lut_ldb_cq_ai_addr_u_re
    ,input  logic[ (   6 ) -1 : 0 ]     rf_lut_ldb_cq_ai_addr_u_raddr
    ,output logic[ (  33 ) -1 : 0 ]     rf_lut_ldb_cq_ai_addr_u_rdata

    ,input  logic                       rf_lut_ldb_cq_ai_addr_u_isol_en
    ,input  logic                       rf_lut_ldb_cq_ai_addr_u_pwr_enable_b_in
    ,output logic                       rf_lut_ldb_cq_ai_addr_u_pwr_enable_b_out

    ,input  logic                       rf_lut_ldb_cq_ai_data_wclk
    ,input  logic                       rf_lut_ldb_cq_ai_data_wclk_rst_n
    ,input  logic                       rf_lut_ldb_cq_ai_data_we
    ,input  logic[ (   6 ) -1 : 0 ]     rf_lut_ldb_cq_ai_data_waddr
    ,input  logic[ (  33 ) -1 : 0 ]     rf_lut_ldb_cq_ai_data_wdata
    ,input  logic                       rf_lut_ldb_cq_ai_data_rclk
    ,input  logic                       rf_lut_ldb_cq_ai_data_rclk_rst_n
    ,input  logic                       rf_lut_ldb_cq_ai_data_re
    ,input  logic[ (   6 ) -1 : 0 ]     rf_lut_ldb_cq_ai_data_raddr
    ,output logic[ (  33 ) -1 : 0 ]     rf_lut_ldb_cq_ai_data_rdata

    ,input  logic                       rf_lut_ldb_cq_ai_data_isol_en
    ,input  logic                       rf_lut_ldb_cq_ai_data_pwr_enable_b_in
    ,output logic                       rf_lut_ldb_cq_ai_data_pwr_enable_b_out

    ,input  logic                       rf_lut_ldb_cq_isr_wclk
    ,input  logic                       rf_lut_ldb_cq_isr_wclk_rst_n
    ,input  logic                       rf_lut_ldb_cq_isr_we
    ,input  logic[ (   6 ) -1 : 0 ]     rf_lut_ldb_cq_isr_waddr
    ,input  logic[ (  13 ) -1 : 0 ]     rf_lut_ldb_cq_isr_wdata
    ,input  logic                       rf_lut_ldb_cq_isr_rclk
    ,input  logic                       rf_lut_ldb_cq_isr_rclk_rst_n
    ,input  logic                       rf_lut_ldb_cq_isr_re
    ,input  logic[ (   6 ) -1 : 0 ]     rf_lut_ldb_cq_isr_raddr
    ,output logic[ (  13 ) -1 : 0 ]     rf_lut_ldb_cq_isr_rdata

    ,input  logic                       rf_lut_ldb_cq_isr_isol_en
    ,input  logic                       rf_lut_ldb_cq_isr_pwr_enable_b_in
    ,output logic                       rf_lut_ldb_cq_isr_pwr_enable_b_out

    ,input  logic                       rf_lut_ldb_cq_pasid_wclk
    ,input  logic                       rf_lut_ldb_cq_pasid_wclk_rst_n
    ,input  logic                       rf_lut_ldb_cq_pasid_we
    ,input  logic[ (   6 ) -1 : 0 ]     rf_lut_ldb_cq_pasid_waddr
    ,input  logic[ (  24 ) -1 : 0 ]     rf_lut_ldb_cq_pasid_wdata
    ,input  logic                       rf_lut_ldb_cq_pasid_rclk
    ,input  logic                       rf_lut_ldb_cq_pasid_rclk_rst_n
    ,input  logic                       rf_lut_ldb_cq_pasid_re
    ,input  logic[ (   6 ) -1 : 0 ]     rf_lut_ldb_cq_pasid_raddr
    ,output logic[ (  24 ) -1 : 0 ]     rf_lut_ldb_cq_pasid_rdata

    ,input  logic                       rf_lut_ldb_cq_pasid_isol_en
    ,input  logic                       rf_lut_ldb_cq_pasid_pwr_enable_b_in
    ,output logic                       rf_lut_ldb_cq_pasid_pwr_enable_b_out

    ,input  logic                       rf_lut_ldb_pp2vas_wclk
    ,input  logic                       rf_lut_ldb_pp2vas_wclk_rst_n
    ,input  logic                       rf_lut_ldb_pp2vas_we
    ,input  logic[ (   5 ) -1 : 0 ]     rf_lut_ldb_pp2vas_waddr
    ,input  logic[ (  11 ) -1 : 0 ]     rf_lut_ldb_pp2vas_wdata
    ,input  logic                       rf_lut_ldb_pp2vas_rclk
    ,input  logic                       rf_lut_ldb_pp2vas_rclk_rst_n
    ,input  logic                       rf_lut_ldb_pp2vas_re
    ,input  logic[ (   5 ) -1 : 0 ]     rf_lut_ldb_pp2vas_raddr
    ,output logic[ (  11 ) -1 : 0 ]     rf_lut_ldb_pp2vas_rdata

    ,input  logic                       rf_lut_ldb_pp2vas_isol_en
    ,input  logic                       rf_lut_ldb_pp2vas_pwr_enable_b_in
    ,output logic                       rf_lut_ldb_pp2vas_pwr_enable_b_out

    ,input  logic                       rf_lut_ldb_qid2vqid_wclk
    ,input  logic                       rf_lut_ldb_qid2vqid_wclk_rst_n
    ,input  logic                       rf_lut_ldb_qid2vqid_we
    ,input  logic[ (   3 ) -1 : 0 ]     rf_lut_ldb_qid2vqid_waddr
    ,input  logic[ (  21 ) -1 : 0 ]     rf_lut_ldb_qid2vqid_wdata
    ,input  logic                       rf_lut_ldb_qid2vqid_rclk
    ,input  logic                       rf_lut_ldb_qid2vqid_rclk_rst_n
    ,input  logic                       rf_lut_ldb_qid2vqid_re
    ,input  logic[ (   3 ) -1 : 0 ]     rf_lut_ldb_qid2vqid_raddr
    ,output logic[ (  21 ) -1 : 0 ]     rf_lut_ldb_qid2vqid_rdata

    ,input  logic                       rf_lut_ldb_qid2vqid_isol_en
    ,input  logic                       rf_lut_ldb_qid2vqid_pwr_enable_b_in
    ,output logic                       rf_lut_ldb_qid2vqid_pwr_enable_b_out

    ,input  logic                       rf_lut_ldb_vasqid_v_wclk
    ,input  logic                       rf_lut_ldb_vasqid_v_wclk_rst_n
    ,input  logic                       rf_lut_ldb_vasqid_v_we
    ,input  logic[ (   6 ) -1 : 0 ]     rf_lut_ldb_vasqid_v_waddr
    ,input  logic[ (  17 ) -1 : 0 ]     rf_lut_ldb_vasqid_v_wdata
    ,input  logic                       rf_lut_ldb_vasqid_v_rclk
    ,input  logic                       rf_lut_ldb_vasqid_v_rclk_rst_n
    ,input  logic                       rf_lut_ldb_vasqid_v_re
    ,input  logic[ (   6 ) -1 : 0 ]     rf_lut_ldb_vasqid_v_raddr
    ,output logic[ (  17 ) -1 : 0 ]     rf_lut_ldb_vasqid_v_rdata

    ,input  logic                       rf_lut_ldb_vasqid_v_isol_en
    ,input  logic                       rf_lut_ldb_vasqid_v_pwr_enable_b_in
    ,output logic                       rf_lut_ldb_vasqid_v_pwr_enable_b_out

    ,input  logic                       rf_lut_vf_dir_vpp2pp_wclk
    ,input  logic                       rf_lut_vf_dir_vpp2pp_wclk_rst_n
    ,input  logic                       rf_lut_vf_dir_vpp2pp_we
    ,input  logic[ (   8 ) -1 : 0 ]     rf_lut_vf_dir_vpp2pp_waddr
    ,input  logic[ (  31 ) -1 : 0 ]     rf_lut_vf_dir_vpp2pp_wdata
    ,input  logic                       rf_lut_vf_dir_vpp2pp_rclk
    ,input  logic                       rf_lut_vf_dir_vpp2pp_rclk_rst_n
    ,input  logic                       rf_lut_vf_dir_vpp2pp_re
    ,input  logic[ (   8 ) -1 : 0 ]     rf_lut_vf_dir_vpp2pp_raddr
    ,output logic[ (  31 ) -1 : 0 ]     rf_lut_vf_dir_vpp2pp_rdata

    ,input  logic                       rf_lut_vf_dir_vpp2pp_isol_en
    ,input  logic                       rf_lut_vf_dir_vpp2pp_pwr_enable_b_in
    ,output logic                       rf_lut_vf_dir_vpp2pp_pwr_enable_b_out

    ,input  logic                       rf_lut_vf_dir_vpp_v_wclk
    ,input  logic                       rf_lut_vf_dir_vpp_v_wclk_rst_n
    ,input  logic                       rf_lut_vf_dir_vpp_v_we
    ,input  logic[ (   6 ) -1 : 0 ]     rf_lut_vf_dir_vpp_v_waddr
    ,input  logic[ (  17 ) -1 : 0 ]     rf_lut_vf_dir_vpp_v_wdata
    ,input  logic                       rf_lut_vf_dir_vpp_v_rclk
    ,input  logic                       rf_lut_vf_dir_vpp_v_rclk_rst_n
    ,input  logic                       rf_lut_vf_dir_vpp_v_re
    ,input  logic[ (   6 ) -1 : 0 ]     rf_lut_vf_dir_vpp_v_raddr
    ,output logic[ (  17 ) -1 : 0 ]     rf_lut_vf_dir_vpp_v_rdata

    ,input  logic                       rf_lut_vf_dir_vpp_v_isol_en
    ,input  logic                       rf_lut_vf_dir_vpp_v_pwr_enable_b_in
    ,output logic                       rf_lut_vf_dir_vpp_v_pwr_enable_b_out

    ,input  logic                       rf_lut_vf_dir_vqid2qid_wclk
    ,input  logic                       rf_lut_vf_dir_vqid2qid_wclk_rst_n
    ,input  logic                       rf_lut_vf_dir_vqid2qid_we
    ,input  logic[ (   8 ) -1 : 0 ]     rf_lut_vf_dir_vqid2qid_waddr
    ,input  logic[ (  31 ) -1 : 0 ]     rf_lut_vf_dir_vqid2qid_wdata
    ,input  logic                       rf_lut_vf_dir_vqid2qid_rclk
    ,input  logic                       rf_lut_vf_dir_vqid2qid_rclk_rst_n
    ,input  logic                       rf_lut_vf_dir_vqid2qid_re
    ,input  logic[ (   8 ) -1 : 0 ]     rf_lut_vf_dir_vqid2qid_raddr
    ,output logic[ (  31 ) -1 : 0 ]     rf_lut_vf_dir_vqid2qid_rdata

    ,input  logic                       rf_lut_vf_dir_vqid2qid_isol_en
    ,input  logic                       rf_lut_vf_dir_vqid2qid_pwr_enable_b_in
    ,output logic                       rf_lut_vf_dir_vqid2qid_pwr_enable_b_out

    ,input  logic                       rf_lut_vf_dir_vqid_v_wclk
    ,input  logic                       rf_lut_vf_dir_vqid_v_wclk_rst_n
    ,input  logic                       rf_lut_vf_dir_vqid_v_we
    ,input  logic[ (   6 ) -1 : 0 ]     rf_lut_vf_dir_vqid_v_waddr
    ,input  logic[ (  17 ) -1 : 0 ]     rf_lut_vf_dir_vqid_v_wdata
    ,input  logic                       rf_lut_vf_dir_vqid_v_rclk
    ,input  logic                       rf_lut_vf_dir_vqid_v_rclk_rst_n
    ,input  logic                       rf_lut_vf_dir_vqid_v_re
    ,input  logic[ (   6 ) -1 : 0 ]     rf_lut_vf_dir_vqid_v_raddr
    ,output logic[ (  17 ) -1 : 0 ]     rf_lut_vf_dir_vqid_v_rdata

    ,input  logic                       rf_lut_vf_dir_vqid_v_isol_en
    ,input  logic                       rf_lut_vf_dir_vqid_v_pwr_enable_b_in
    ,output logic                       rf_lut_vf_dir_vqid_v_pwr_enable_b_out

    ,input  logic                       rf_lut_vf_ldb_vpp2pp_wclk
    ,input  logic                       rf_lut_vf_ldb_vpp2pp_wclk_rst_n
    ,input  logic                       rf_lut_vf_ldb_vpp2pp_we
    ,input  logic[ (   8 ) -1 : 0 ]     rf_lut_vf_ldb_vpp2pp_waddr
    ,input  logic[ (  25 ) -1 : 0 ]     rf_lut_vf_ldb_vpp2pp_wdata
    ,input  logic                       rf_lut_vf_ldb_vpp2pp_rclk
    ,input  logic                       rf_lut_vf_ldb_vpp2pp_rclk_rst_n
    ,input  logic                       rf_lut_vf_ldb_vpp2pp_re
    ,input  logic[ (   8 ) -1 : 0 ]     rf_lut_vf_ldb_vpp2pp_raddr
    ,output logic[ (  25 ) -1 : 0 ]     rf_lut_vf_ldb_vpp2pp_rdata

    ,input  logic                       rf_lut_vf_ldb_vpp2pp_isol_en
    ,input  logic                       rf_lut_vf_ldb_vpp2pp_pwr_enable_b_in
    ,output logic                       rf_lut_vf_ldb_vpp2pp_pwr_enable_b_out

    ,input  logic                       rf_lut_vf_ldb_vpp_v_wclk
    ,input  logic                       rf_lut_vf_ldb_vpp_v_wclk_rst_n
    ,input  logic                       rf_lut_vf_ldb_vpp_v_we
    ,input  logic[ (   6 ) -1 : 0 ]     rf_lut_vf_ldb_vpp_v_waddr
    ,input  logic[ (  17 ) -1 : 0 ]     rf_lut_vf_ldb_vpp_v_wdata
    ,input  logic                       rf_lut_vf_ldb_vpp_v_rclk
    ,input  logic                       rf_lut_vf_ldb_vpp_v_rclk_rst_n
    ,input  logic                       rf_lut_vf_ldb_vpp_v_re
    ,input  logic[ (   6 ) -1 : 0 ]     rf_lut_vf_ldb_vpp_v_raddr
    ,output logic[ (  17 ) -1 : 0 ]     rf_lut_vf_ldb_vpp_v_rdata

    ,input  logic                       rf_lut_vf_ldb_vpp_v_isol_en
    ,input  logic                       rf_lut_vf_ldb_vpp_v_pwr_enable_b_in
    ,output logic                       rf_lut_vf_ldb_vpp_v_pwr_enable_b_out

    ,input  logic                       rf_lut_vf_ldb_vqid2qid_wclk
    ,input  logic                       rf_lut_vf_ldb_vqid2qid_wclk_rst_n
    ,input  logic                       rf_lut_vf_ldb_vqid2qid_we
    ,input  logic[ (   7 ) -1 : 0 ]     rf_lut_vf_ldb_vqid2qid_waddr
    ,input  logic[ (  27 ) -1 : 0 ]     rf_lut_vf_ldb_vqid2qid_wdata
    ,input  logic                       rf_lut_vf_ldb_vqid2qid_rclk
    ,input  logic                       rf_lut_vf_ldb_vqid2qid_rclk_rst_n
    ,input  logic                       rf_lut_vf_ldb_vqid2qid_re
    ,input  logic[ (   7 ) -1 : 0 ]     rf_lut_vf_ldb_vqid2qid_raddr
    ,output logic[ (  27 ) -1 : 0 ]     rf_lut_vf_ldb_vqid2qid_rdata

    ,input  logic                       rf_lut_vf_ldb_vqid2qid_isol_en
    ,input  logic                       rf_lut_vf_ldb_vqid2qid_pwr_enable_b_in
    ,output logic                       rf_lut_vf_ldb_vqid2qid_pwr_enable_b_out

    ,input  logic                       rf_lut_vf_ldb_vqid_v_wclk
    ,input  logic                       rf_lut_vf_ldb_vqid_v_wclk_rst_n
    ,input  logic                       rf_lut_vf_ldb_vqid_v_we
    ,input  logic[ (   5 ) -1 : 0 ]     rf_lut_vf_ldb_vqid_v_waddr
    ,input  logic[ (  17 ) -1 : 0 ]     rf_lut_vf_ldb_vqid_v_wdata
    ,input  logic                       rf_lut_vf_ldb_vqid_v_rclk
    ,input  logic                       rf_lut_vf_ldb_vqid_v_rclk_rst_n
    ,input  logic                       rf_lut_vf_ldb_vqid_v_re
    ,input  logic[ (   5 ) -1 : 0 ]     rf_lut_vf_ldb_vqid_v_raddr
    ,output logic[ (  17 ) -1 : 0 ]     rf_lut_vf_ldb_vqid_v_rdata

    ,input  logic                       rf_lut_vf_ldb_vqid_v_isol_en
    ,input  logic                       rf_lut_vf_ldb_vqid_v_pwr_enable_b_in
    ,output logic                       rf_lut_vf_ldb_vqid_v_pwr_enable_b_out

    ,input  logic                       rf_msix_tbl_word0_wclk
    ,input  logic                       rf_msix_tbl_word0_wclk_rst_n
    ,input  logic                       rf_msix_tbl_word0_we
    ,input  logic[ (   6 ) -1 : 0 ]     rf_msix_tbl_word0_waddr
    ,input  logic[ (  33 ) -1 : 0 ]     rf_msix_tbl_word0_wdata
    ,input  logic                       rf_msix_tbl_word0_rclk
    ,input  logic                       rf_msix_tbl_word0_rclk_rst_n
    ,input  logic                       rf_msix_tbl_word0_re
    ,input  logic[ (   6 ) -1 : 0 ]     rf_msix_tbl_word0_raddr
    ,output logic[ (  33 ) -1 : 0 ]     rf_msix_tbl_word0_rdata

    ,input  logic                       rf_msix_tbl_word0_isol_en
    ,input  logic                       rf_msix_tbl_word0_pwr_enable_b_in
    ,output logic                       rf_msix_tbl_word0_pwr_enable_b_out

    ,input  logic                       rf_msix_tbl_word1_wclk
    ,input  logic                       rf_msix_tbl_word1_wclk_rst_n
    ,input  logic                       rf_msix_tbl_word1_we
    ,input  logic[ (   6 ) -1 : 0 ]     rf_msix_tbl_word1_waddr
    ,input  logic[ (  33 ) -1 : 0 ]     rf_msix_tbl_word1_wdata
    ,input  logic                       rf_msix_tbl_word1_rclk
    ,input  logic                       rf_msix_tbl_word1_rclk_rst_n
    ,input  logic                       rf_msix_tbl_word1_re
    ,input  logic[ (   6 ) -1 : 0 ]     rf_msix_tbl_word1_raddr
    ,output logic[ (  33 ) -1 : 0 ]     rf_msix_tbl_word1_rdata

    ,input  logic                       rf_msix_tbl_word1_isol_en
    ,input  logic                       rf_msix_tbl_word1_pwr_enable_b_in
    ,output logic                       rf_msix_tbl_word1_pwr_enable_b_out

    ,input  logic                       rf_msix_tbl_word2_wclk
    ,input  logic                       rf_msix_tbl_word2_wclk_rst_n
    ,input  logic                       rf_msix_tbl_word2_we
    ,input  logic[ (   6 ) -1 : 0 ]     rf_msix_tbl_word2_waddr
    ,input  logic[ (  33 ) -1 : 0 ]     rf_msix_tbl_word2_wdata
    ,input  logic                       rf_msix_tbl_word2_rclk
    ,input  logic                       rf_msix_tbl_word2_rclk_rst_n
    ,input  logic                       rf_msix_tbl_word2_re
    ,input  logic[ (   6 ) -1 : 0 ]     rf_msix_tbl_word2_raddr
    ,output logic[ (  33 ) -1 : 0 ]     rf_msix_tbl_word2_rdata

    ,input  logic                       rf_msix_tbl_word2_isol_en
    ,input  logic                       rf_msix_tbl_word2_pwr_enable_b_in
    ,output logic                       rf_msix_tbl_word2_pwr_enable_b_out

    ,input  logic                       rf_ord_qid_sn_wclk
    ,input  logic                       rf_ord_qid_sn_wclk_rst_n
    ,input  logic                       rf_ord_qid_sn_we
    ,input  logic[ (   5 ) -1 : 0 ]     rf_ord_qid_sn_waddr
    ,input  logic[ (  12 ) -1 : 0 ]     rf_ord_qid_sn_wdata
    ,input  logic                       rf_ord_qid_sn_rclk
    ,input  logic                       rf_ord_qid_sn_rclk_rst_n
    ,input  logic                       rf_ord_qid_sn_re
    ,input  logic[ (   5 ) -1 : 0 ]     rf_ord_qid_sn_raddr
    ,output logic[ (  12 ) -1 : 0 ]     rf_ord_qid_sn_rdata

    ,input  logic                       rf_ord_qid_sn_isol_en
    ,input  logic                       rf_ord_qid_sn_pwr_enable_b_in
    ,output logic                       rf_ord_qid_sn_pwr_enable_b_out

    ,input  logic                       rf_ord_qid_sn_map_wclk
    ,input  logic                       rf_ord_qid_sn_map_wclk_rst_n
    ,input  logic                       rf_ord_qid_sn_map_we
    ,input  logic[ (   5 ) -1 : 0 ]     rf_ord_qid_sn_map_waddr
    ,input  logic[ (  12 ) -1 : 0 ]     rf_ord_qid_sn_map_wdata
    ,input  logic                       rf_ord_qid_sn_map_rclk
    ,input  logic                       rf_ord_qid_sn_map_rclk_rst_n
    ,input  logic                       rf_ord_qid_sn_map_re
    ,input  logic[ (   5 ) -1 : 0 ]     rf_ord_qid_sn_map_raddr
    ,output logic[ (  12 ) -1 : 0 ]     rf_ord_qid_sn_map_rdata

    ,input  logic                       rf_ord_qid_sn_map_isol_en
    ,input  logic                       rf_ord_qid_sn_map_pwr_enable_b_in
    ,output logic                       rf_ord_qid_sn_map_pwr_enable_b_out

    ,input  logic                       rf_outbound_hcw_fifo_mem_wclk
    ,input  logic                       rf_outbound_hcw_fifo_mem_wclk_rst_n
    ,input  logic                       rf_outbound_hcw_fifo_mem_we
    ,input  logic[ (   4 ) -1 : 0 ]     rf_outbound_hcw_fifo_mem_waddr
    ,input  logic[ ( 160 ) -1 : 0 ]     rf_outbound_hcw_fifo_mem_wdata
    ,input  logic                       rf_outbound_hcw_fifo_mem_rclk
    ,input  logic                       rf_outbound_hcw_fifo_mem_rclk_rst_n
    ,input  logic                       rf_outbound_hcw_fifo_mem_re
    ,input  logic[ (   4 ) -1 : 0 ]     rf_outbound_hcw_fifo_mem_raddr
    ,output logic[ ( 160 ) -1 : 0 ]     rf_outbound_hcw_fifo_mem_rdata

    ,input  logic                       rf_outbound_hcw_fifo_mem_isol_en
    ,input  logic                       rf_outbound_hcw_fifo_mem_pwr_enable_b_in
    ,output logic                       rf_outbound_hcw_fifo_mem_pwr_enable_b_out

    ,input  logic                       rf_qed_chp_sch_flid_ret_rx_sync_mem_wclk
    ,input  logic                       rf_qed_chp_sch_flid_ret_rx_sync_mem_wclk_rst_n
    ,input  logic                       rf_qed_chp_sch_flid_ret_rx_sync_mem_we
    ,input  logic[ (   2 ) -1 : 0 ]     rf_qed_chp_sch_flid_ret_rx_sync_mem_waddr
    ,input  logic[ (  26 ) -1 : 0 ]     rf_qed_chp_sch_flid_ret_rx_sync_mem_wdata
    ,input  logic                       rf_qed_chp_sch_flid_ret_rx_sync_mem_rclk
    ,input  logic                       rf_qed_chp_sch_flid_ret_rx_sync_mem_rclk_rst_n
    ,input  logic                       rf_qed_chp_sch_flid_ret_rx_sync_mem_re
    ,input  logic[ (   2 ) -1 : 0 ]     rf_qed_chp_sch_flid_ret_rx_sync_mem_raddr
    ,output logic[ (  26 ) -1 : 0 ]     rf_qed_chp_sch_flid_ret_rx_sync_mem_rdata

    ,input  logic                       rf_qed_chp_sch_flid_ret_rx_sync_mem_isol_en
    ,input  logic                       rf_qed_chp_sch_flid_ret_rx_sync_mem_pwr_enable_b_in
    ,output logic                       rf_qed_chp_sch_flid_ret_rx_sync_mem_pwr_enable_b_out

    ,input  logic                       rf_qed_chp_sch_rx_sync_mem_wclk
    ,input  logic                       rf_qed_chp_sch_rx_sync_mem_wclk_rst_n
    ,input  logic                       rf_qed_chp_sch_rx_sync_mem_we
    ,input  logic[ (   3 ) -1 : 0 ]     rf_qed_chp_sch_rx_sync_mem_waddr
    ,input  logic[ ( 177 ) -1 : 0 ]     rf_qed_chp_sch_rx_sync_mem_wdata
    ,input  logic                       rf_qed_chp_sch_rx_sync_mem_rclk
    ,input  logic                       rf_qed_chp_sch_rx_sync_mem_rclk_rst_n
    ,input  logic                       rf_qed_chp_sch_rx_sync_mem_re
    ,input  logic[ (   3 ) -1 : 0 ]     rf_qed_chp_sch_rx_sync_mem_raddr
    ,output logic[ ( 177 ) -1 : 0 ]     rf_qed_chp_sch_rx_sync_mem_rdata

    ,input  logic                       rf_qed_chp_sch_rx_sync_mem_isol_en
    ,input  logic                       rf_qed_chp_sch_rx_sync_mem_pwr_enable_b_in
    ,output logic                       rf_qed_chp_sch_rx_sync_mem_pwr_enable_b_out

    ,input  logic                       rf_qed_to_cq_fifo_mem_wclk
    ,input  logic                       rf_qed_to_cq_fifo_mem_wclk_rst_n
    ,input  logic                       rf_qed_to_cq_fifo_mem_we
    ,input  logic[ (   3 ) -1 : 0 ]     rf_qed_to_cq_fifo_mem_waddr
    ,input  logic[ ( 197 ) -1 : 0 ]     rf_qed_to_cq_fifo_mem_wdata
    ,input  logic                       rf_qed_to_cq_fifo_mem_rclk
    ,input  logic                       rf_qed_to_cq_fifo_mem_rclk_rst_n
    ,input  logic                       rf_qed_to_cq_fifo_mem_re
    ,input  logic[ (   3 ) -1 : 0 ]     rf_qed_to_cq_fifo_mem_raddr
    ,output logic[ ( 197 ) -1 : 0 ]     rf_qed_to_cq_fifo_mem_rdata

    ,input  logic                       rf_qed_to_cq_fifo_mem_isol_en
    ,input  logic                       rf_qed_to_cq_fifo_mem_pwr_enable_b_in
    ,output logic                       rf_qed_to_cq_fifo_mem_pwr_enable_b_out

    ,input  logic                       rf_reord_cnt_mem_wclk
    ,input  logic                       rf_reord_cnt_mem_wclk_rst_n
    ,input  logic                       rf_reord_cnt_mem_we
    ,input  logic[ (  11 ) -1 : 0 ]     rf_reord_cnt_mem_waddr
    ,input  logic[ (  16 ) -1 : 0 ]     rf_reord_cnt_mem_wdata
    ,input  logic                       rf_reord_cnt_mem_rclk
    ,input  logic                       rf_reord_cnt_mem_rclk_rst_n
    ,input  logic                       rf_reord_cnt_mem_re
    ,input  logic[ (  11 ) -1 : 0 ]     rf_reord_cnt_mem_raddr
    ,output logic[ (  16 ) -1 : 0 ]     rf_reord_cnt_mem_rdata

    ,input  logic                       rf_reord_cnt_mem_isol_en
    ,input  logic                       rf_reord_cnt_mem_pwr_enable_b_in
    ,output logic                       rf_reord_cnt_mem_pwr_enable_b_out

    ,input  logic                       rf_reord_dirhp_mem_wclk
    ,input  logic                       rf_reord_dirhp_mem_wclk_rst_n
    ,input  logic                       rf_reord_dirhp_mem_we
    ,input  logic[ (  11 ) -1 : 0 ]     rf_reord_dirhp_mem_waddr
    ,input  logic[ (  17 ) -1 : 0 ]     rf_reord_dirhp_mem_wdata
    ,input  logic                       rf_reord_dirhp_mem_rclk
    ,input  logic                       rf_reord_dirhp_mem_rclk_rst_n
    ,input  logic                       rf_reord_dirhp_mem_re
    ,input  logic[ (  11 ) -1 : 0 ]     rf_reord_dirhp_mem_raddr
    ,output logic[ (  17 ) -1 : 0 ]     rf_reord_dirhp_mem_rdata

    ,input  logic                       rf_reord_dirhp_mem_isol_en
    ,input  logic                       rf_reord_dirhp_mem_pwr_enable_b_in
    ,output logic                       rf_reord_dirhp_mem_pwr_enable_b_out

    ,input  logic                       rf_reord_dirtp_mem_wclk
    ,input  logic                       rf_reord_dirtp_mem_wclk_rst_n
    ,input  logic                       rf_reord_dirtp_mem_we
    ,input  logic[ (  11 ) -1 : 0 ]     rf_reord_dirtp_mem_waddr
    ,input  logic[ (  17 ) -1 : 0 ]     rf_reord_dirtp_mem_wdata
    ,input  logic                       rf_reord_dirtp_mem_rclk
    ,input  logic                       rf_reord_dirtp_mem_rclk_rst_n
    ,input  logic                       rf_reord_dirtp_mem_re
    ,input  logic[ (  11 ) -1 : 0 ]     rf_reord_dirtp_mem_raddr
    ,output logic[ (  17 ) -1 : 0 ]     rf_reord_dirtp_mem_rdata

    ,input  logic                       rf_reord_dirtp_mem_isol_en
    ,input  logic                       rf_reord_dirtp_mem_pwr_enable_b_in
    ,output logic                       rf_reord_dirtp_mem_pwr_enable_b_out

    ,input  logic                       rf_reord_lbhp_mem_wclk
    ,input  logic                       rf_reord_lbhp_mem_wclk_rst_n
    ,input  logic                       rf_reord_lbhp_mem_we
    ,input  logic[ (  11 ) -1 : 0 ]     rf_reord_lbhp_mem_waddr
    ,input  logic[ (  17 ) -1 : 0 ]     rf_reord_lbhp_mem_wdata
    ,input  logic                       rf_reord_lbhp_mem_rclk
    ,input  logic                       rf_reord_lbhp_mem_rclk_rst_n
    ,input  logic                       rf_reord_lbhp_mem_re
    ,input  logic[ (  11 ) -1 : 0 ]     rf_reord_lbhp_mem_raddr
    ,output logic[ (  17 ) -1 : 0 ]     rf_reord_lbhp_mem_rdata

    ,input  logic                       rf_reord_lbhp_mem_isol_en
    ,input  logic                       rf_reord_lbhp_mem_pwr_enable_b_in
    ,output logic                       rf_reord_lbhp_mem_pwr_enable_b_out

    ,input  logic                       rf_reord_lbtp_mem_wclk
    ,input  logic                       rf_reord_lbtp_mem_wclk_rst_n
    ,input  logic                       rf_reord_lbtp_mem_we
    ,input  logic[ (  11 ) -1 : 0 ]     rf_reord_lbtp_mem_waddr
    ,input  logic[ (  17 ) -1 : 0 ]     rf_reord_lbtp_mem_wdata
    ,input  logic                       rf_reord_lbtp_mem_rclk
    ,input  logic                       rf_reord_lbtp_mem_rclk_rst_n
    ,input  logic                       rf_reord_lbtp_mem_re
    ,input  logic[ (  11 ) -1 : 0 ]     rf_reord_lbtp_mem_raddr
    ,output logic[ (  17 ) -1 : 0 ]     rf_reord_lbtp_mem_rdata

    ,input  logic                       rf_reord_lbtp_mem_isol_en
    ,input  logic                       rf_reord_lbtp_mem_pwr_enable_b_in
    ,output logic                       rf_reord_lbtp_mem_pwr_enable_b_out

    ,input  logic                       rf_reord_st_mem_wclk
    ,input  logic                       rf_reord_st_mem_wclk_rst_n
    ,input  logic                       rf_reord_st_mem_we
    ,input  logic[ (  11 ) -1 : 0 ]     rf_reord_st_mem_waddr
    ,input  logic[ (  25 ) -1 : 0 ]     rf_reord_st_mem_wdata
    ,input  logic                       rf_reord_st_mem_rclk
    ,input  logic                       rf_reord_st_mem_rclk_rst_n
    ,input  logic                       rf_reord_st_mem_re
    ,input  logic[ (  11 ) -1 : 0 ]     rf_reord_st_mem_raddr
    ,output logic[ (  25 ) -1 : 0 ]     rf_reord_st_mem_rdata

    ,input  logic                       rf_reord_st_mem_isol_en
    ,input  logic                       rf_reord_st_mem_pwr_enable_b_in
    ,output logic                       rf_reord_st_mem_pwr_enable_b_out

    ,input  logic                       rf_rop_chp_rop_hcw_fifo_mem_wclk
    ,input  logic                       rf_rop_chp_rop_hcw_fifo_mem_wclk_rst_n
    ,input  logic                       rf_rop_chp_rop_hcw_fifo_mem_we
    ,input  logic[ (   2 ) -1 : 0 ]     rf_rop_chp_rop_hcw_fifo_mem_waddr
    ,input  logic[ ( 204 ) -1 : 0 ]     rf_rop_chp_rop_hcw_fifo_mem_wdata
    ,input  logic                       rf_rop_chp_rop_hcw_fifo_mem_rclk
    ,input  logic                       rf_rop_chp_rop_hcw_fifo_mem_rclk_rst_n
    ,input  logic                       rf_rop_chp_rop_hcw_fifo_mem_re
    ,input  logic[ (   2 ) -1 : 0 ]     rf_rop_chp_rop_hcw_fifo_mem_raddr
    ,output logic[ ( 204 ) -1 : 0 ]     rf_rop_chp_rop_hcw_fifo_mem_rdata

    ,input  logic                       rf_rop_chp_rop_hcw_fifo_mem_isol_en
    ,input  logic                       rf_rop_chp_rop_hcw_fifo_mem_pwr_enable_b_in
    ,output logic                       rf_rop_chp_rop_hcw_fifo_mem_pwr_enable_b_out

    ,input  logic                       rf_sch_out_fifo_wclk
    ,input  logic                       rf_sch_out_fifo_wclk_rst_n
    ,input  logic                       rf_sch_out_fifo_we
    ,input  logic[ (   7 ) -1 : 0 ]     rf_sch_out_fifo_waddr
    ,input  logic[ ( 270 ) -1 : 0 ]     rf_sch_out_fifo_wdata
    ,input  logic                       rf_sch_out_fifo_rclk
    ,input  logic                       rf_sch_out_fifo_rclk_rst_n
    ,input  logic                       rf_sch_out_fifo_re
    ,input  logic[ (   7 ) -1 : 0 ]     rf_sch_out_fifo_raddr
    ,output logic[ ( 270 ) -1 : 0 ]     rf_sch_out_fifo_rdata

    ,input  logic                       rf_sch_out_fifo_isol_en
    ,input  logic                       rf_sch_out_fifo_pwr_enable_b_in
    ,output logic                       rf_sch_out_fifo_pwr_enable_b_out

    ,input  logic                       rf_sn0_order_shft_mem_wclk
    ,input  logic                       rf_sn0_order_shft_mem_wclk_rst_n
    ,input  logic                       rf_sn0_order_shft_mem_we
    ,input  logic[ (   4 ) -1 : 0 ]     rf_sn0_order_shft_mem_waddr
    ,input  logic[ (  12 ) -1 : 0 ]     rf_sn0_order_shft_mem_wdata
    ,input  logic                       rf_sn0_order_shft_mem_rclk
    ,input  logic                       rf_sn0_order_shft_mem_rclk_rst_n
    ,input  logic                       rf_sn0_order_shft_mem_re
    ,input  logic[ (   4 ) -1 : 0 ]     rf_sn0_order_shft_mem_raddr
    ,output logic[ (  12 ) -1 : 0 ]     rf_sn0_order_shft_mem_rdata

    ,input  logic                       rf_sn0_order_shft_mem_isol_en
    ,input  logic                       rf_sn0_order_shft_mem_pwr_enable_b_in
    ,output logic                       rf_sn0_order_shft_mem_pwr_enable_b_out

    ,input  logic                       rf_sn1_order_shft_mem_wclk
    ,input  logic                       rf_sn1_order_shft_mem_wclk_rst_n
    ,input  logic                       rf_sn1_order_shft_mem_we
    ,input  logic[ (   4 ) -1 : 0 ]     rf_sn1_order_shft_mem_waddr
    ,input  logic[ (  12 ) -1 : 0 ]     rf_sn1_order_shft_mem_wdata
    ,input  logic                       rf_sn1_order_shft_mem_rclk
    ,input  logic                       rf_sn1_order_shft_mem_rclk_rst_n
    ,input  logic                       rf_sn1_order_shft_mem_re
    ,input  logic[ (   4 ) -1 : 0 ]     rf_sn1_order_shft_mem_raddr
    ,output logic[ (  12 ) -1 : 0 ]     rf_sn1_order_shft_mem_rdata

    ,input  logic                       rf_sn1_order_shft_mem_isol_en
    ,input  logic                       rf_sn1_order_shft_mem_pwr_enable_b_in
    ,output logic                       rf_sn1_order_shft_mem_pwr_enable_b_out

    ,input  logic                       rf_sn_complete_fifo_mem_wclk
    ,input  logic                       rf_sn_complete_fifo_mem_wclk_rst_n
    ,input  logic                       rf_sn_complete_fifo_mem_we
    ,input  logic[ (   2 ) -1 : 0 ]     rf_sn_complete_fifo_mem_waddr
    ,input  logic[ (  21 ) -1 : 0 ]     rf_sn_complete_fifo_mem_wdata
    ,input  logic                       rf_sn_complete_fifo_mem_rclk
    ,input  logic                       rf_sn_complete_fifo_mem_rclk_rst_n
    ,input  logic                       rf_sn_complete_fifo_mem_re
    ,input  logic[ (   2 ) -1 : 0 ]     rf_sn_complete_fifo_mem_raddr
    ,output logic[ (  21 ) -1 : 0 ]     rf_sn_complete_fifo_mem_rdata

    ,input  logic                       rf_sn_complete_fifo_mem_isol_en
    ,input  logic                       rf_sn_complete_fifo_mem_pwr_enable_b_in
    ,output logic                       rf_sn_complete_fifo_mem_pwr_enable_b_out

    ,input  logic                       rf_sn_ordered_fifo_mem_wclk
    ,input  logic                       rf_sn_ordered_fifo_mem_wclk_rst_n
    ,input  logic                       rf_sn_ordered_fifo_mem_we
    ,input  logic[ (   5 ) -1 : 0 ]     rf_sn_ordered_fifo_mem_waddr
    ,input  logic[ (  13 ) -1 : 0 ]     rf_sn_ordered_fifo_mem_wdata
    ,input  logic                       rf_sn_ordered_fifo_mem_rclk
    ,input  logic                       rf_sn_ordered_fifo_mem_rclk_rst_n
    ,input  logic                       rf_sn_ordered_fifo_mem_re
    ,input  logic[ (   5 ) -1 : 0 ]     rf_sn_ordered_fifo_mem_raddr
    ,output logic[ (  13 ) -1 : 0 ]     rf_sn_ordered_fifo_mem_rdata

    ,input  logic                       rf_sn_ordered_fifo_mem_isol_en
    ,input  logic                       rf_sn_ordered_fifo_mem_pwr_enable_b_in
    ,output logic                       rf_sn_ordered_fifo_mem_pwr_enable_b_out

    ,input  logic                       rf_threshold_r_pipe_dir_mem_wclk
    ,input  logic                       rf_threshold_r_pipe_dir_mem_wclk_rst_n
    ,input  logic                       rf_threshold_r_pipe_dir_mem_we
    ,input  logic[ (   6 ) -1 : 0 ]     rf_threshold_r_pipe_dir_mem_waddr
    ,input  logic[ (  14 ) -1 : 0 ]     rf_threshold_r_pipe_dir_mem_wdata
    ,input  logic                       rf_threshold_r_pipe_dir_mem_rclk
    ,input  logic                       rf_threshold_r_pipe_dir_mem_rclk_rst_n
    ,input  logic                       rf_threshold_r_pipe_dir_mem_re
    ,input  logic[ (   6 ) -1 : 0 ]     rf_threshold_r_pipe_dir_mem_raddr
    ,output logic[ (  14 ) -1 : 0 ]     rf_threshold_r_pipe_dir_mem_rdata

    ,input  logic                       rf_threshold_r_pipe_dir_mem_isol_en
    ,input  logic                       rf_threshold_r_pipe_dir_mem_pwr_enable_b_in
    ,output logic                       rf_threshold_r_pipe_dir_mem_pwr_enable_b_out

    ,input  logic                       rf_threshold_r_pipe_ldb_mem_wclk
    ,input  logic                       rf_threshold_r_pipe_ldb_mem_wclk_rst_n
    ,input  logic                       rf_threshold_r_pipe_ldb_mem_we
    ,input  logic[ (   6 ) -1 : 0 ]     rf_threshold_r_pipe_ldb_mem_waddr
    ,input  logic[ (  14 ) -1 : 0 ]     rf_threshold_r_pipe_ldb_mem_wdata
    ,input  logic                       rf_threshold_r_pipe_ldb_mem_rclk
    ,input  logic                       rf_threshold_r_pipe_ldb_mem_rclk_rst_n
    ,input  logic                       rf_threshold_r_pipe_ldb_mem_re
    ,input  logic[ (   6 ) -1 : 0 ]     rf_threshold_r_pipe_ldb_mem_raddr
    ,output logic[ (  14 ) -1 : 0 ]     rf_threshold_r_pipe_ldb_mem_rdata

    ,input  logic                       rf_threshold_r_pipe_ldb_mem_isol_en
    ,input  logic                       rf_threshold_r_pipe_ldb_mem_pwr_enable_b_in
    ,output logic                       rf_threshold_r_pipe_ldb_mem_pwr_enable_b_out

    ,input  logic                       sr_freelist_0_clk
    ,input  logic                       sr_freelist_0_clk_rst_n
    ,input  logic[ (  11 ) -1 : 0 ]     sr_freelist_0_addr
    ,input  logic                       sr_freelist_0_we
    ,input  logic[ (  16 ) -1 : 0 ]     sr_freelist_0_wdata
    ,input  logic                       sr_freelist_0_re
    ,output logic[ (  16 ) -1 : 0 ]     sr_freelist_0_rdata

    ,input  logic                       sr_freelist_0_isol_en
    ,input  logic                       sr_freelist_0_pwr_enable_b_in
    ,output logic                       sr_freelist_0_pwr_enable_b_out

    ,input  logic                       sr_freelist_1_clk
    ,input  logic                       sr_freelist_1_clk_rst_n
    ,input  logic[ (  11 ) -1 : 0 ]     sr_freelist_1_addr
    ,input  logic                       sr_freelist_1_we
    ,input  logic[ (  16 ) -1 : 0 ]     sr_freelist_1_wdata
    ,input  logic                       sr_freelist_1_re
    ,output logic[ (  16 ) -1 : 0 ]     sr_freelist_1_rdata

    ,input  logic                       sr_freelist_1_isol_en
    ,input  logic                       sr_freelist_1_pwr_enable_b_in
    ,output logic                       sr_freelist_1_pwr_enable_b_out

    ,input  logic                       sr_freelist_2_clk
    ,input  logic                       sr_freelist_2_clk_rst_n
    ,input  logic[ (  11 ) -1 : 0 ]     sr_freelist_2_addr
    ,input  logic                       sr_freelist_2_we
    ,input  logic[ (  16 ) -1 : 0 ]     sr_freelist_2_wdata
    ,input  logic                       sr_freelist_2_re
    ,output logic[ (  16 ) -1 : 0 ]     sr_freelist_2_rdata

    ,input  logic                       sr_freelist_2_isol_en
    ,input  logic                       sr_freelist_2_pwr_enable_b_in
    ,output logic                       sr_freelist_2_pwr_enable_b_out

    ,input  logic                       sr_freelist_3_clk
    ,input  logic                       sr_freelist_3_clk_rst_n
    ,input  logic[ (  11 ) -1 : 0 ]     sr_freelist_3_addr
    ,input  logic                       sr_freelist_3_we
    ,input  logic[ (  16 ) -1 : 0 ]     sr_freelist_3_wdata
    ,input  logic                       sr_freelist_3_re
    ,output logic[ (  16 ) -1 : 0 ]     sr_freelist_3_rdata

    ,input  logic                       sr_freelist_3_isol_en
    ,input  logic                       sr_freelist_3_pwr_enable_b_in
    ,output logic                       sr_freelist_3_pwr_enable_b_out

    ,input  logic                       sr_freelist_4_clk
    ,input  logic                       sr_freelist_4_clk_rst_n
    ,input  logic[ (  11 ) -1 : 0 ]     sr_freelist_4_addr
    ,input  logic                       sr_freelist_4_we
    ,input  logic[ (  16 ) -1 : 0 ]     sr_freelist_4_wdata
    ,input  logic                       sr_freelist_4_re
    ,output logic[ (  16 ) -1 : 0 ]     sr_freelist_4_rdata

    ,input  logic                       sr_freelist_4_isol_en
    ,input  logic                       sr_freelist_4_pwr_enable_b_in
    ,output logic                       sr_freelist_4_pwr_enable_b_out

    ,input  logic                       sr_freelist_5_clk
    ,input  logic                       sr_freelist_5_clk_rst_n
    ,input  logic[ (  11 ) -1 : 0 ]     sr_freelist_5_addr
    ,input  logic                       sr_freelist_5_we
    ,input  logic[ (  16 ) -1 : 0 ]     sr_freelist_5_wdata
    ,input  logic                       sr_freelist_5_re
    ,output logic[ (  16 ) -1 : 0 ]     sr_freelist_5_rdata

    ,input  logic                       sr_freelist_5_isol_en
    ,input  logic                       sr_freelist_5_pwr_enable_b_in
    ,output logic                       sr_freelist_5_pwr_enable_b_out

    ,input  logic                       sr_freelist_6_clk
    ,input  logic                       sr_freelist_6_clk_rst_n
    ,input  logic[ (  11 ) -1 : 0 ]     sr_freelist_6_addr
    ,input  logic                       sr_freelist_6_we
    ,input  logic[ (  16 ) -1 : 0 ]     sr_freelist_6_wdata
    ,input  logic                       sr_freelist_6_re
    ,output logic[ (  16 ) -1 : 0 ]     sr_freelist_6_rdata

    ,input  logic                       sr_freelist_6_isol_en
    ,input  logic                       sr_freelist_6_pwr_enable_b_in
    ,output logic                       sr_freelist_6_pwr_enable_b_out

    ,input  logic                       sr_freelist_7_clk
    ,input  logic                       sr_freelist_7_clk_rst_n
    ,input  logic[ (  11 ) -1 : 0 ]     sr_freelist_7_addr
    ,input  logic                       sr_freelist_7_we
    ,input  logic[ (  16 ) -1 : 0 ]     sr_freelist_7_wdata
    ,input  logic                       sr_freelist_7_re
    ,output logic[ (  16 ) -1 : 0 ]     sr_freelist_7_rdata

    ,input  logic                       sr_freelist_7_isol_en
    ,input  logic                       sr_freelist_7_pwr_enable_b_in
    ,output logic                       sr_freelist_7_pwr_enable_b_out

    ,input  logic                       sr_hist_list_clk
    ,input  logic                       sr_hist_list_clk_rst_n
    ,input  logic[ (  11 ) -1 : 0 ]     sr_hist_list_addr
    ,input  logic                       sr_hist_list_we
    ,input  logic[ (  66 ) -1 : 0 ]     sr_hist_list_wdata
    ,input  logic                       sr_hist_list_re
    ,output logic[ (  66 ) -1 : 0 ]     sr_hist_list_rdata

    ,input  logic                       sr_hist_list_isol_en
    ,input  logic                       sr_hist_list_pwr_enable_b_in
    ,output logic                       sr_hist_list_pwr_enable_b_out

    ,input  logic                       sr_hist_list_a_clk
    ,input  logic                       sr_hist_list_a_clk_rst_n
    ,input  logic[ (  11 ) -1 : 0 ]     sr_hist_list_a_addr
    ,input  logic                       sr_hist_list_a_we
    ,input  logic[ (  66 ) -1 : 0 ]     sr_hist_list_a_wdata
    ,input  logic                       sr_hist_list_a_re
    ,output logic[ (  66 ) -1 : 0 ]     sr_hist_list_a_rdata

    ,input  logic                       sr_hist_list_a_isol_en
    ,input  logic                       sr_hist_list_a_pwr_enable_b_in
    ,output logic                       sr_hist_list_a_pwr_enable_b_out

    ,input  logic                       sr_rob_mem_clk
    ,input  logic                       sr_rob_mem_clk_rst_n
    ,input  logic[ (  11 ) -1 : 0 ]     sr_rob_mem_addr
    ,input  logic                       sr_rob_mem_we
    ,input  logic[ ( 156 ) -1 : 0 ]     sr_rob_mem_wdata
    ,input  logic                       sr_rob_mem_re
    ,output logic[ ( 156 ) -1 : 0 ]     sr_rob_mem_rdata

    ,input  logic                       sr_rob_mem_isol_en
    ,input  logic                       sr_rob_mem_pwr_enable_b_in
    ,output logic                       sr_rob_mem_pwr_enable_b_out

    ,input  logic                       rf_count_rmw_pipe_wd_dir_mem_wclk
    ,input  logic                       rf_count_rmw_pipe_wd_dir_mem_wclk_rst_n
    ,input  logic                       rf_count_rmw_pipe_wd_dir_mem_we
    ,input  logic[ (   6 ) -1 : 0 ]     rf_count_rmw_pipe_wd_dir_mem_waddr
    ,input  logic[ (  10 ) -1 : 0 ]     rf_count_rmw_pipe_wd_dir_mem_wdata
    ,input  logic                       rf_count_rmw_pipe_wd_dir_mem_rclk
    ,input  logic                       rf_count_rmw_pipe_wd_dir_mem_rclk_rst_n
    ,input  logic                       rf_count_rmw_pipe_wd_dir_mem_re
    ,input  logic[ (   6 ) -1 : 0 ]     rf_count_rmw_pipe_wd_dir_mem_raddr
    ,output logic[ (  10 ) -1 : 0 ]     rf_count_rmw_pipe_wd_dir_mem_rdata

    ,input  logic                       rf_count_rmw_pipe_wd_dir_mem_isol_en
    ,input  logic                       rf_count_rmw_pipe_wd_dir_mem_pwr_enable_b_in
    ,output logic                       rf_count_rmw_pipe_wd_dir_mem_pwr_enable_b_out

    ,input  logic                       rf_count_rmw_pipe_wd_ldb_mem_wclk
    ,input  logic                       rf_count_rmw_pipe_wd_ldb_mem_wclk_rst_n
    ,input  logic                       rf_count_rmw_pipe_wd_ldb_mem_we
    ,input  logic[ (   6 ) -1 : 0 ]     rf_count_rmw_pipe_wd_ldb_mem_waddr
    ,input  logic[ (  10 ) -1 : 0 ]     rf_count_rmw_pipe_wd_ldb_mem_wdata
    ,input  logic                       rf_count_rmw_pipe_wd_ldb_mem_rclk
    ,input  logic                       rf_count_rmw_pipe_wd_ldb_mem_rclk_rst_n
    ,input  logic                       rf_count_rmw_pipe_wd_ldb_mem_re
    ,input  logic[ (   6 ) -1 : 0 ]     rf_count_rmw_pipe_wd_ldb_mem_raddr
    ,output logic[ (  10 ) -1 : 0 ]     rf_count_rmw_pipe_wd_ldb_mem_rdata

    ,input  logic                       rf_count_rmw_pipe_wd_ldb_mem_isol_en
    ,input  logic                       rf_count_rmw_pipe_wd_ldb_mem_pwr_enable_b_in
    ,output logic                       rf_count_rmw_pipe_wd_ldb_mem_pwr_enable_b_out

    ,input  logic                       rf_ibcpl_data_fifo_wclk
    ,input  logic                       rf_ibcpl_data_fifo_wclk_rst_n
    ,input  logic                       rf_ibcpl_data_fifo_we
    ,input  logic[ (   8 ) -1 : 0 ]     rf_ibcpl_data_fifo_waddr
    ,input  logic[ (  66 ) -1 : 0 ]     rf_ibcpl_data_fifo_wdata
    ,input  logic                       rf_ibcpl_data_fifo_rclk
    ,input  logic                       rf_ibcpl_data_fifo_rclk_rst_n
    ,input  logic                       rf_ibcpl_data_fifo_re
    ,input  logic[ (   8 ) -1 : 0 ]     rf_ibcpl_data_fifo_raddr
    ,output logic[ (  66 ) -1 : 0 ]     rf_ibcpl_data_fifo_rdata

    ,input  logic                       rf_ibcpl_hdr_fifo_wclk
    ,input  logic                       rf_ibcpl_hdr_fifo_wclk_rst_n
    ,input  logic                       rf_ibcpl_hdr_fifo_we
    ,input  logic[ (   8 ) -1 : 0 ]     rf_ibcpl_hdr_fifo_waddr
    ,input  logic[ (  20 ) -1 : 0 ]     rf_ibcpl_hdr_fifo_wdata
    ,input  logic                       rf_ibcpl_hdr_fifo_rclk
    ,input  logic                       rf_ibcpl_hdr_fifo_rclk_rst_n
    ,input  logic                       rf_ibcpl_hdr_fifo_re
    ,input  logic[ (   8 ) -1 : 0 ]     rf_ibcpl_hdr_fifo_raddr
    ,output logic[ (  20 ) -1 : 0 ]     rf_ibcpl_hdr_fifo_rdata

    ,input  logic                       rf_mstr_ll_data0_wclk
    ,input  logic                       rf_mstr_ll_data0_wclk_rst_n
    ,input  logic                       rf_mstr_ll_data0_we
    ,input  logic[ (   8 ) -1 : 0 ]     rf_mstr_ll_data0_waddr
    ,input  logic[ ( 129 ) -1 : 0 ]     rf_mstr_ll_data0_wdata
    ,input  logic                       rf_mstr_ll_data0_rclk
    ,input  logic                       rf_mstr_ll_data0_rclk_rst_n
    ,input  logic                       rf_mstr_ll_data0_re
    ,input  logic[ (   8 ) -1 : 0 ]     rf_mstr_ll_data0_raddr
    ,output logic[ ( 129 ) -1 : 0 ]     rf_mstr_ll_data0_rdata

    ,input  logic                       rf_mstr_ll_data1_wclk
    ,input  logic                       rf_mstr_ll_data1_wclk_rst_n
    ,input  logic                       rf_mstr_ll_data1_we
    ,input  logic[ (   8 ) -1 : 0 ]     rf_mstr_ll_data1_waddr
    ,input  logic[ ( 129 ) -1 : 0 ]     rf_mstr_ll_data1_wdata
    ,input  logic                       rf_mstr_ll_data1_rclk
    ,input  logic                       rf_mstr_ll_data1_rclk_rst_n
    ,input  logic                       rf_mstr_ll_data1_re
    ,input  logic[ (   8 ) -1 : 0 ]     rf_mstr_ll_data1_raddr
    ,output logic[ ( 129 ) -1 : 0 ]     rf_mstr_ll_data1_rdata

    ,input  logic                       rf_mstr_ll_data2_wclk
    ,input  logic                       rf_mstr_ll_data2_wclk_rst_n
    ,input  logic                       rf_mstr_ll_data2_we
    ,input  logic[ (   8 ) -1 : 0 ]     rf_mstr_ll_data2_waddr
    ,input  logic[ ( 129 ) -1 : 0 ]     rf_mstr_ll_data2_wdata
    ,input  logic                       rf_mstr_ll_data2_rclk
    ,input  logic                       rf_mstr_ll_data2_rclk_rst_n
    ,input  logic                       rf_mstr_ll_data2_re
    ,input  logic[ (   8 ) -1 : 0 ]     rf_mstr_ll_data2_raddr
    ,output logic[ ( 129 ) -1 : 0 ]     rf_mstr_ll_data2_rdata

    ,input  logic                       rf_mstr_ll_data3_wclk
    ,input  logic                       rf_mstr_ll_data3_wclk_rst_n
    ,input  logic                       rf_mstr_ll_data3_we
    ,input  logic[ (   8 ) -1 : 0 ]     rf_mstr_ll_data3_waddr
    ,input  logic[ ( 129 ) -1 : 0 ]     rf_mstr_ll_data3_wdata
    ,input  logic                       rf_mstr_ll_data3_rclk
    ,input  logic                       rf_mstr_ll_data3_rclk_rst_n
    ,input  logic                       rf_mstr_ll_data3_re
    ,input  logic[ (   8 ) -1 : 0 ]     rf_mstr_ll_data3_raddr
    ,output logic[ ( 129 ) -1 : 0 ]     rf_mstr_ll_data3_rdata

    ,input  logic                       rf_mstr_ll_hdr_wclk
    ,input  logic                       rf_mstr_ll_hdr_wclk_rst_n
    ,input  logic                       rf_mstr_ll_hdr_we
    ,input  logic[ (   8 ) -1 : 0 ]     rf_mstr_ll_hdr_waddr
    ,input  logic[ ( 153 ) -1 : 0 ]     rf_mstr_ll_hdr_wdata
    ,input  logic                       rf_mstr_ll_hdr_rclk
    ,input  logic                       rf_mstr_ll_hdr_rclk_rst_n
    ,input  logic                       rf_mstr_ll_hdr_re
    ,input  logic[ (   8 ) -1 : 0 ]     rf_mstr_ll_hdr_raddr
    ,output logic[ ( 153 ) -1 : 0 ]     rf_mstr_ll_hdr_rdata

    ,input  logic                       rf_mstr_ll_hpa_wclk
    ,input  logic                       rf_mstr_ll_hpa_wclk_rst_n
    ,input  logic                       rf_mstr_ll_hpa_we
    ,input  logic[ (   7 ) -1 : 0 ]     rf_mstr_ll_hpa_waddr
    ,input  logic[ (  35 ) -1 : 0 ]     rf_mstr_ll_hpa_wdata
    ,input  logic                       rf_mstr_ll_hpa_rclk
    ,input  logic                       rf_mstr_ll_hpa_rclk_rst_n
    ,input  logic                       rf_mstr_ll_hpa_re
    ,input  logic[ (   7 ) -1 : 0 ]     rf_mstr_ll_hpa_raddr
    ,output logic[ (  35 ) -1 : 0 ]     rf_mstr_ll_hpa_rdata

    ,input  logic                       rf_ri_tlq_fifo_npdata_wclk
    ,input  logic                       rf_ri_tlq_fifo_npdata_wclk_rst_n
    ,input  logic                       rf_ri_tlq_fifo_npdata_we
    ,input  logic[ (   3 ) -1 : 0 ]     rf_ri_tlq_fifo_npdata_waddr
    ,input  logic[ (  33 ) -1 : 0 ]     rf_ri_tlq_fifo_npdata_wdata
    ,input  logic                       rf_ri_tlq_fifo_npdata_rclk
    ,input  logic                       rf_ri_tlq_fifo_npdata_rclk_rst_n
    ,input  logic                       rf_ri_tlq_fifo_npdata_re
    ,input  logic[ (   3 ) -1 : 0 ]     rf_ri_tlq_fifo_npdata_raddr
    ,output logic[ (  33 ) -1 : 0 ]     rf_ri_tlq_fifo_npdata_rdata

    ,input  logic                       rf_ri_tlq_fifo_nphdr_wclk
    ,input  logic                       rf_ri_tlq_fifo_nphdr_wclk_rst_n
    ,input  logic                       rf_ri_tlq_fifo_nphdr_we
    ,input  logic[ (   3 ) -1 : 0 ]     rf_ri_tlq_fifo_nphdr_waddr
    ,input  logic[ ( 158 ) -1 : 0 ]     rf_ri_tlq_fifo_nphdr_wdata
    ,input  logic                       rf_ri_tlq_fifo_nphdr_rclk
    ,input  logic                       rf_ri_tlq_fifo_nphdr_rclk_rst_n
    ,input  logic                       rf_ri_tlq_fifo_nphdr_re
    ,input  logic[ (   3 ) -1 : 0 ]     rf_ri_tlq_fifo_nphdr_raddr
    ,output logic[ ( 158 ) -1 : 0 ]     rf_ri_tlq_fifo_nphdr_rdata

    ,input  logic                       rf_ri_tlq_fifo_pdata_wclk
    ,input  logic                       rf_ri_tlq_fifo_pdata_wclk_rst_n
    ,input  logic                       rf_ri_tlq_fifo_pdata_we
    ,input  logic[ (   5 ) -1 : 0 ]     rf_ri_tlq_fifo_pdata_waddr
    ,input  logic[ ( 264 ) -1 : 0 ]     rf_ri_tlq_fifo_pdata_wdata
    ,input  logic                       rf_ri_tlq_fifo_pdata_rclk
    ,input  logic                       rf_ri_tlq_fifo_pdata_rclk_rst_n
    ,input  logic                       rf_ri_tlq_fifo_pdata_re
    ,input  logic[ (   5 ) -1 : 0 ]     rf_ri_tlq_fifo_pdata_raddr
    ,output logic[ ( 264 ) -1 : 0 ]     rf_ri_tlq_fifo_pdata_rdata

    ,input  logic                       rf_ri_tlq_fifo_phdr_wclk
    ,input  logic                       rf_ri_tlq_fifo_phdr_wclk_rst_n
    ,input  logic                       rf_ri_tlq_fifo_phdr_we
    ,input  logic[ (   4 ) -1 : 0 ]     rf_ri_tlq_fifo_phdr_waddr
    ,input  logic[ ( 153 ) -1 : 0 ]     rf_ri_tlq_fifo_phdr_wdata
    ,input  logic                       rf_ri_tlq_fifo_phdr_rclk
    ,input  logic                       rf_ri_tlq_fifo_phdr_rclk_rst_n
    ,input  logic                       rf_ri_tlq_fifo_phdr_re
    ,input  logic[ (   4 ) -1 : 0 ]     rf_ri_tlq_fifo_phdr_raddr
    ,output logic[ ( 153 ) -1 : 0 ]     rf_ri_tlq_fifo_phdr_rdata

    ,input  logic                       rf_scrbd_mem_wclk
    ,input  logic                       rf_scrbd_mem_wclk_rst_n
    ,input  logic                       rf_scrbd_mem_we
    ,input  logic[ (   8 ) -1 : 0 ]     rf_scrbd_mem_waddr
    ,input  logic[ (  10 ) -1 : 0 ]     rf_scrbd_mem_wdata
    ,input  logic                       rf_scrbd_mem_rclk
    ,input  logic                       rf_scrbd_mem_rclk_rst_n
    ,input  logic                       rf_scrbd_mem_re
    ,input  logic[ (   8 ) -1 : 0 ]     rf_scrbd_mem_raddr
    ,output logic[ (  10 ) -1 : 0 ]     rf_scrbd_mem_rdata

    ,input  logic                       rf_tlb_data0_4k_wclk
    ,input  logic                       rf_tlb_data0_4k_wclk_rst_n
    ,input  logic                       rf_tlb_data0_4k_we
    ,input  logic[ (   4 ) -1 : 0 ]     rf_tlb_data0_4k_waddr
    ,input  logic[ (  39 ) -1 : 0 ]     rf_tlb_data0_4k_wdata
    ,input  logic                       rf_tlb_data0_4k_rclk
    ,input  logic                       rf_tlb_data0_4k_rclk_rst_n
    ,input  logic                       rf_tlb_data0_4k_re
    ,input  logic[ (   4 ) -1 : 0 ]     rf_tlb_data0_4k_raddr
    ,output logic[ (  39 ) -1 : 0 ]     rf_tlb_data0_4k_rdata

    ,input  logic                       rf_tlb_data1_4k_wclk
    ,input  logic                       rf_tlb_data1_4k_wclk_rst_n
    ,input  logic                       rf_tlb_data1_4k_we
    ,input  logic[ (   4 ) -1 : 0 ]     rf_tlb_data1_4k_waddr
    ,input  logic[ (  39 ) -1 : 0 ]     rf_tlb_data1_4k_wdata
    ,input  logic                       rf_tlb_data1_4k_rclk
    ,input  logic                       rf_tlb_data1_4k_rclk_rst_n
    ,input  logic                       rf_tlb_data1_4k_re
    ,input  logic[ (   4 ) -1 : 0 ]     rf_tlb_data1_4k_raddr
    ,output logic[ (  39 ) -1 : 0 ]     rf_tlb_data1_4k_rdata

    ,input  logic                       rf_tlb_data2_4k_wclk
    ,input  logic                       rf_tlb_data2_4k_wclk_rst_n
    ,input  logic                       rf_tlb_data2_4k_we
    ,input  logic[ (   4 ) -1 : 0 ]     rf_tlb_data2_4k_waddr
    ,input  logic[ (  39 ) -1 : 0 ]     rf_tlb_data2_4k_wdata
    ,input  logic                       rf_tlb_data2_4k_rclk
    ,input  logic                       rf_tlb_data2_4k_rclk_rst_n
    ,input  logic                       rf_tlb_data2_4k_re
    ,input  logic[ (   4 ) -1 : 0 ]     rf_tlb_data2_4k_raddr
    ,output logic[ (  39 ) -1 : 0 ]     rf_tlb_data2_4k_rdata

    ,input  logic                       rf_tlb_data3_4k_wclk
    ,input  logic                       rf_tlb_data3_4k_wclk_rst_n
    ,input  logic                       rf_tlb_data3_4k_we
    ,input  logic[ (   4 ) -1 : 0 ]     rf_tlb_data3_4k_waddr
    ,input  logic[ (  39 ) -1 : 0 ]     rf_tlb_data3_4k_wdata
    ,input  logic                       rf_tlb_data3_4k_rclk
    ,input  logic                       rf_tlb_data3_4k_rclk_rst_n
    ,input  logic                       rf_tlb_data3_4k_re
    ,input  logic[ (   4 ) -1 : 0 ]     rf_tlb_data3_4k_raddr
    ,output logic[ (  39 ) -1 : 0 ]     rf_tlb_data3_4k_rdata

    ,input  logic                       rf_tlb_data4_4k_wclk
    ,input  logic                       rf_tlb_data4_4k_wclk_rst_n
    ,input  logic                       rf_tlb_data4_4k_we
    ,input  logic[ (   4 ) -1 : 0 ]     rf_tlb_data4_4k_waddr
    ,input  logic[ (  39 ) -1 : 0 ]     rf_tlb_data4_4k_wdata
    ,input  logic                       rf_tlb_data4_4k_rclk
    ,input  logic                       rf_tlb_data4_4k_rclk_rst_n
    ,input  logic                       rf_tlb_data4_4k_re
    ,input  logic[ (   4 ) -1 : 0 ]     rf_tlb_data4_4k_raddr
    ,output logic[ (  39 ) -1 : 0 ]     rf_tlb_data4_4k_rdata

    ,input  logic                       rf_tlb_data5_4k_wclk
    ,input  logic                       rf_tlb_data5_4k_wclk_rst_n
    ,input  logic                       rf_tlb_data5_4k_we
    ,input  logic[ (   4 ) -1 : 0 ]     rf_tlb_data5_4k_waddr
    ,input  logic[ (  39 ) -1 : 0 ]     rf_tlb_data5_4k_wdata
    ,input  logic                       rf_tlb_data5_4k_rclk
    ,input  logic                       rf_tlb_data5_4k_rclk_rst_n
    ,input  logic                       rf_tlb_data5_4k_re
    ,input  logic[ (   4 ) -1 : 0 ]     rf_tlb_data5_4k_raddr
    ,output logic[ (  39 ) -1 : 0 ]     rf_tlb_data5_4k_rdata

    ,input  logic                       rf_tlb_data6_4k_wclk
    ,input  logic                       rf_tlb_data6_4k_wclk_rst_n
    ,input  logic                       rf_tlb_data6_4k_we
    ,input  logic[ (   4 ) -1 : 0 ]     rf_tlb_data6_4k_waddr
    ,input  logic[ (  39 ) -1 : 0 ]     rf_tlb_data6_4k_wdata
    ,input  logic                       rf_tlb_data6_4k_rclk
    ,input  logic                       rf_tlb_data6_4k_rclk_rst_n
    ,input  logic                       rf_tlb_data6_4k_re
    ,input  logic[ (   4 ) -1 : 0 ]     rf_tlb_data6_4k_raddr
    ,output logic[ (  39 ) -1 : 0 ]     rf_tlb_data6_4k_rdata

    ,input  logic                       rf_tlb_data7_4k_wclk
    ,input  logic                       rf_tlb_data7_4k_wclk_rst_n
    ,input  logic                       rf_tlb_data7_4k_we
    ,input  logic[ (   4 ) -1 : 0 ]     rf_tlb_data7_4k_waddr
    ,input  logic[ (  39 ) -1 : 0 ]     rf_tlb_data7_4k_wdata
    ,input  logic                       rf_tlb_data7_4k_rclk
    ,input  logic                       rf_tlb_data7_4k_rclk_rst_n
    ,input  logic                       rf_tlb_data7_4k_re
    ,input  logic[ (   4 ) -1 : 0 ]     rf_tlb_data7_4k_raddr
    ,output logic[ (  39 ) -1 : 0 ]     rf_tlb_data7_4k_rdata

    ,input  logic                       rf_tlb_tag0_4k_wclk
    ,input  logic                       rf_tlb_tag0_4k_wclk_rst_n
    ,input  logic                       rf_tlb_tag0_4k_we
    ,input  logic[ (   4 ) -1 : 0 ]     rf_tlb_tag0_4k_waddr
    ,input  logic[ (  85 ) -1 : 0 ]     rf_tlb_tag0_4k_wdata
    ,input  logic                       rf_tlb_tag0_4k_rclk
    ,input  logic                       rf_tlb_tag0_4k_rclk_rst_n
    ,input  logic                       rf_tlb_tag0_4k_re
    ,input  logic[ (   4 ) -1 : 0 ]     rf_tlb_tag0_4k_raddr
    ,output logic[ (  85 ) -1 : 0 ]     rf_tlb_tag0_4k_rdata

    ,input  logic                       rf_tlb_tag1_4k_wclk
    ,input  logic                       rf_tlb_tag1_4k_wclk_rst_n
    ,input  logic                       rf_tlb_tag1_4k_we
    ,input  logic[ (   4 ) -1 : 0 ]     rf_tlb_tag1_4k_waddr
    ,input  logic[ (  85 ) -1 : 0 ]     rf_tlb_tag1_4k_wdata
    ,input  logic                       rf_tlb_tag1_4k_rclk
    ,input  logic                       rf_tlb_tag1_4k_rclk_rst_n
    ,input  logic                       rf_tlb_tag1_4k_re
    ,input  logic[ (   4 ) -1 : 0 ]     rf_tlb_tag1_4k_raddr
    ,output logic[ (  85 ) -1 : 0 ]     rf_tlb_tag1_4k_rdata

    ,input  logic                       rf_tlb_tag2_4k_wclk
    ,input  logic                       rf_tlb_tag2_4k_wclk_rst_n
    ,input  logic                       rf_tlb_tag2_4k_we
    ,input  logic[ (   4 ) -1 : 0 ]     rf_tlb_tag2_4k_waddr
    ,input  logic[ (  85 ) -1 : 0 ]     rf_tlb_tag2_4k_wdata
    ,input  logic                       rf_tlb_tag2_4k_rclk
    ,input  logic                       rf_tlb_tag2_4k_rclk_rst_n
    ,input  logic                       rf_tlb_tag2_4k_re
    ,input  logic[ (   4 ) -1 : 0 ]     rf_tlb_tag2_4k_raddr
    ,output logic[ (  85 ) -1 : 0 ]     rf_tlb_tag2_4k_rdata

    ,input  logic                       rf_tlb_tag3_4k_wclk
    ,input  logic                       rf_tlb_tag3_4k_wclk_rst_n
    ,input  logic                       rf_tlb_tag3_4k_we
    ,input  logic[ (   4 ) -1 : 0 ]     rf_tlb_tag3_4k_waddr
    ,input  logic[ (  85 ) -1 : 0 ]     rf_tlb_tag3_4k_wdata
    ,input  logic                       rf_tlb_tag3_4k_rclk
    ,input  logic                       rf_tlb_tag3_4k_rclk_rst_n
    ,input  logic                       rf_tlb_tag3_4k_re
    ,input  logic[ (   4 ) -1 : 0 ]     rf_tlb_tag3_4k_raddr
    ,output logic[ (  85 ) -1 : 0 ]     rf_tlb_tag3_4k_rdata

    ,input  logic                       rf_tlb_tag4_4k_wclk
    ,input  logic                       rf_tlb_tag4_4k_wclk_rst_n
    ,input  logic                       rf_tlb_tag4_4k_we
    ,input  logic[ (   4 ) -1 : 0 ]     rf_tlb_tag4_4k_waddr
    ,input  logic[ (  85 ) -1 : 0 ]     rf_tlb_tag4_4k_wdata
    ,input  logic                       rf_tlb_tag4_4k_rclk
    ,input  logic                       rf_tlb_tag4_4k_rclk_rst_n
    ,input  logic                       rf_tlb_tag4_4k_re
    ,input  logic[ (   4 ) -1 : 0 ]     rf_tlb_tag4_4k_raddr
    ,output logic[ (  85 ) -1 : 0 ]     rf_tlb_tag4_4k_rdata

    ,input  logic                       rf_tlb_tag5_4k_wclk
    ,input  logic                       rf_tlb_tag5_4k_wclk_rst_n
    ,input  logic                       rf_tlb_tag5_4k_we
    ,input  logic[ (   4 ) -1 : 0 ]     rf_tlb_tag5_4k_waddr
    ,input  logic[ (  85 ) -1 : 0 ]     rf_tlb_tag5_4k_wdata
    ,input  logic                       rf_tlb_tag5_4k_rclk
    ,input  logic                       rf_tlb_tag5_4k_rclk_rst_n
    ,input  logic                       rf_tlb_tag5_4k_re
    ,input  logic[ (   4 ) -1 : 0 ]     rf_tlb_tag5_4k_raddr
    ,output logic[ (  85 ) -1 : 0 ]     rf_tlb_tag5_4k_rdata

    ,input  logic                       rf_tlb_tag6_4k_wclk
    ,input  logic                       rf_tlb_tag6_4k_wclk_rst_n
    ,input  logic                       rf_tlb_tag6_4k_we
    ,input  logic[ (   4 ) -1 : 0 ]     rf_tlb_tag6_4k_waddr
    ,input  logic[ (  85 ) -1 : 0 ]     rf_tlb_tag6_4k_wdata
    ,input  logic                       rf_tlb_tag6_4k_rclk
    ,input  logic                       rf_tlb_tag6_4k_rclk_rst_n
    ,input  logic                       rf_tlb_tag6_4k_re
    ,input  logic[ (   4 ) -1 : 0 ]     rf_tlb_tag6_4k_raddr
    ,output logic[ (  85 ) -1 : 0 ]     rf_tlb_tag6_4k_rdata

    ,input  logic                       rf_tlb_tag7_4k_wclk
    ,input  logic                       rf_tlb_tag7_4k_wclk_rst_n
    ,input  logic                       rf_tlb_tag7_4k_we
    ,input  logic[ (   4 ) -1 : 0 ]     rf_tlb_tag7_4k_waddr
    ,input  logic[ (  85 ) -1 : 0 ]     rf_tlb_tag7_4k_wdata
    ,input  logic                       rf_tlb_tag7_4k_rclk
    ,input  logic                       rf_tlb_tag7_4k_rclk_rst_n
    ,input  logic                       rf_tlb_tag7_4k_re
    ,input  logic[ (   4 ) -1 : 0 ]     rf_tlb_tag7_4k_raddr
    ,output logic[ (  85 ) -1 : 0 ]     rf_tlb_tag7_4k_rdata

    ,input  logic                       rf_hcw_enq_fifo_wclk
    ,input  logic                       rf_hcw_enq_fifo_wclk_rst_n
    ,input  logic                       rf_hcw_enq_fifo_we
    ,input  logic[ (   8 ) -1 : 0 ]     rf_hcw_enq_fifo_waddr
    ,input  logic[ ( 167 ) -1 : 0 ]     rf_hcw_enq_fifo_wdata
    ,input  logic                       rf_hcw_enq_fifo_rclk
    ,input  logic                       rf_hcw_enq_fifo_rclk_rst_n
    ,input  logic                       rf_hcw_enq_fifo_re
    ,input  logic[ (   8 ) -1 : 0 ]     rf_hcw_enq_fifo_raddr
    ,output logic[ ( 167 ) -1 : 0 ]     rf_hcw_enq_fifo_rdata

    ,input  logic                       rf_hcw_enq_fifo_isol_en
    ,input  logic                       rf_hcw_enq_fifo_pwr_enable_b_in
    ,output logic                       rf_hcw_enq_fifo_pwr_enable_b_out

    ,input  logic                       hqm_pwrgood_rst_b

    ,input  logic                       powergood_rst_b

    ,input  logic                       fscan_byprst_b
    ,input  logic                       fscan_clkungate
    ,input  logic                       fscan_rstbypen
);


endmodule


