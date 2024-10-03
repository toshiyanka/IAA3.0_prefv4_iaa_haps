module hqm_sip_aon_wrap (
  adtf_dnstream_data,
  adtf_dnstream_header,
  adtf_dnstream_valid,
  ap_alarm_down_v,
  ap_alarm_up_ready,
  ap_aqed_ready,
  ap_aqed_v,
  ap_cfg_req_down_read,
  ap_cfg_req_down_write,
  ap_cfg_rsp_down_ack,
  ap_reset_done,
  ap_unit_idle,
  ap_unit_pipeidle,
  aqed_alarm_down_v,
  aqed_ap_enq_ready,
  aqed_ap_enq_v,
  aqed_cfg_req_down,
  aqed_cfg_req_down_read,
  aqed_cfg_req_down_write,
  aqed_cfg_rsp_down,
  aqed_cfg_rsp_down_ack,
  aqed_chp_sch_ready,
  aqed_chp_sch_v,
  aqed_lsp_sch_ready,
  aqed_lsp_sch_v,
  aqed_reset_done,
  aqed_unit_idle,
  aqed_unit_pipeidle,
  atrig_fabric_in_ack,
  atrig_fabric_out,
  chp_alarm_up_ready,
  chp_cfg_req_down_read,
  chp_cfg_req_down_write,
  chp_cfg_rsp_down_ack,
  chp_lsp_cmp_ready,
  chp_lsp_cmp_v,
  chp_lsp_token_ready,
  chp_lsp_token_v,
  chp_reset_done,
  chp_rop_hcw_ready,
  chp_rop_hcw_v,
  chp_unit_idle,
  chp_unit_pipeidle,
  cwdi_interrupt_w_req_ready,
  cwdi_interrupt_w_req_valid,
  dig_view_out_0,
  dig_view_out_1,
  dp_lsp_enq_dir_ready,
  dp_lsp_enq_dir_v,
  dp_lsp_enq_rorply_ready,
  dp_lsp_enq_rorply_v,
  dp_reset_done,
  dp_unit_idle,
  dp_unit_pipeidle,
  dvp_paddr,
  dvp_penable,
  dvp_pprot,
  dvp_prdata,
  dvp_pready,
  dvp_psel,
  dvp_pslverr,
  dvp_pstrb,
  dvp_pwdata,
  dvp_pwrite,
  early_fuses,
  fdfx_debug_cap,
  fdfx_debug_cap_valid,
  fdfx_earlyboot_debug_exit,
  fdfx_policy_update,
  fdfx_powergood,
  fdfx_sbparity_def,
  fdfx_security_policy,
  fdtf_clk,
  fdtf_cry_clk,
  fdtf_fast_cnt_width,
  fdtf_force_ts,
  fdtf_packetizer_cid,
  fdtf_packetizer_mid,
  fdtf_rst_b,
  fdtf_serial_download_tsc,
  fdtf_survive_mode,
  fdtf_timestamp_valid,
  fdtf_timestamp_value,
  fdtf_tsc_adjustment_strap,
  fdtf_upstream_active,
  fdtf_upstream_credit,
  fdtf_upstream_sync,
  fscan_byprst_b,
  fscan_clkungate,
  fscan_clkungate_syn,
  fscan_latchclosed_b,
  fscan_latchopen,
  fscan_mode,
  fscan_rstbypen,
  fscan_shiften,
  ftrig_fabric_in,
  ftrig_fabric_out_ack,
  gpsb_meom,
  gpsb_mnpcup,
  gpsb_mnpput,
  gpsb_mparity,
  gpsb_mpayload,
  gpsb_mpccup,
  gpsb_mpcput,
  gpsb_side_ism_agent,
  gpsb_side_ism_fabric,
  gpsb_teom,
  gpsb_tnpcup,
  gpsb_tnpput,
  gpsb_tparity,
  gpsb_tpayload,
  gpsb_tpccup,
  gpsb_tpcput,
  hcw_enq_in_data,
  hcw_enq_in_ready,
  hcw_enq_in_v,
  hcw_enq_w_req_ready,
  hcw_enq_w_req_valid,
  hcw_sched_w_req_ready,
  hcw_sched_w_req_valid,
  hqm_alarm_ready,
  hqm_alarm_v,
  hqm_clk_enable,
  hqm_clk_rptr_rst_b,
  hqm_clk_trunk,
  hqm_clk_ungate,
  hqm_flr_prep,
  hqm_gated_local_override,
  hqm_gated_rst_b,
  hqm_pm_adr_ack,
  hqm_proc_clk_en_chp,
  hqm_proc_clk_en_dir,
  hqm_proc_clk_en_lsp,
  hqm_proc_clk_en_nalb,
  hqm_proc_clk_en_qed,
  hqm_proc_clk_en_sys,
  hqm_proc_reset_done_sync_hqm,
  hqm_system_visa_str,
  i_hqm_AW_fet_en_sequencer_par_mem_pgcb_fet_en_ack_b,
  i_hqm_AW_fet_en_sequencer_par_mem_pgcb_fet_en_b,
  i_hqm_master_fscan_isol_ctrl,
  i_hqm_master_fscan_isol_lat_ctrl,
  i_hqm_master_fscan_ret_ctrl,
  i_hqm_master_pgcb_isol_en,
  i_hqm_master_pgcb_isol_en_b,
  i_hqm_pwrgood_rst_b_buf_o,
  i_hqm_sif_rf_ibcpl_data_fifo_raddr,
  i_hqm_sif_rf_ibcpl_data_fifo_rclk,
  i_hqm_sif_rf_ibcpl_data_fifo_rclk_rst_n,
  i_hqm_sif_rf_ibcpl_data_fifo_rdata,
  i_hqm_sif_rf_ibcpl_data_fifo_re,
  i_hqm_sif_rf_ibcpl_data_fifo_waddr,
  i_hqm_sif_rf_ibcpl_data_fifo_wclk,
  i_hqm_sif_rf_ibcpl_data_fifo_wclk_rst_n,
  i_hqm_sif_rf_ibcpl_data_fifo_wdata,
  i_hqm_sif_rf_ibcpl_data_fifo_we,
  i_hqm_sif_rf_ibcpl_hdr_fifo_raddr,
  i_hqm_sif_rf_ibcpl_hdr_fifo_rclk,
  i_hqm_sif_rf_ibcpl_hdr_fifo_rclk_rst_n,
  i_hqm_sif_rf_ibcpl_hdr_fifo_rdata,
  i_hqm_sif_rf_ibcpl_hdr_fifo_re,
  i_hqm_sif_rf_ibcpl_hdr_fifo_waddr,
  i_hqm_sif_rf_ibcpl_hdr_fifo_wclk,
  i_hqm_sif_rf_ibcpl_hdr_fifo_wclk_rst_n,
  i_hqm_sif_rf_ibcpl_hdr_fifo_wdata,
  i_hqm_sif_rf_ibcpl_hdr_fifo_we,
  i_hqm_sif_rf_mstr_ll_data0_raddr,
  i_hqm_sif_rf_mstr_ll_data0_rclk,
  i_hqm_sif_rf_mstr_ll_data0_rclk_rst_n,
  i_hqm_sif_rf_mstr_ll_data0_rdata,
  i_hqm_sif_rf_mstr_ll_data0_re,
  i_hqm_sif_rf_mstr_ll_data0_waddr,
  i_hqm_sif_rf_mstr_ll_data0_wclk,
  i_hqm_sif_rf_mstr_ll_data0_wclk_rst_n,
  i_hqm_sif_rf_mstr_ll_data0_wdata,
  i_hqm_sif_rf_mstr_ll_data0_we,
  i_hqm_sif_rf_mstr_ll_data1_raddr,
  i_hqm_sif_rf_mstr_ll_data1_rclk,
  i_hqm_sif_rf_mstr_ll_data1_rclk_rst_n,
  i_hqm_sif_rf_mstr_ll_data1_rdata,
  i_hqm_sif_rf_mstr_ll_data1_re,
  i_hqm_sif_rf_mstr_ll_data1_waddr,
  i_hqm_sif_rf_mstr_ll_data1_wclk,
  i_hqm_sif_rf_mstr_ll_data1_wclk_rst_n,
  i_hqm_sif_rf_mstr_ll_data1_wdata,
  i_hqm_sif_rf_mstr_ll_data1_we,
  i_hqm_sif_rf_mstr_ll_data2_raddr,
  i_hqm_sif_rf_mstr_ll_data2_rclk,
  i_hqm_sif_rf_mstr_ll_data2_rclk_rst_n,
  i_hqm_sif_rf_mstr_ll_data2_rdata,
  i_hqm_sif_rf_mstr_ll_data2_re,
  i_hqm_sif_rf_mstr_ll_data2_waddr,
  i_hqm_sif_rf_mstr_ll_data2_wclk,
  i_hqm_sif_rf_mstr_ll_data2_wclk_rst_n,
  i_hqm_sif_rf_mstr_ll_data2_wdata,
  i_hqm_sif_rf_mstr_ll_data2_we,
  i_hqm_sif_rf_mstr_ll_data3_raddr,
  i_hqm_sif_rf_mstr_ll_data3_rclk,
  i_hqm_sif_rf_mstr_ll_data3_rclk_rst_n,
  i_hqm_sif_rf_mstr_ll_data3_rdata,
  i_hqm_sif_rf_mstr_ll_data3_re,
  i_hqm_sif_rf_mstr_ll_data3_waddr,
  i_hqm_sif_rf_mstr_ll_data3_wclk,
  i_hqm_sif_rf_mstr_ll_data3_wclk_rst_n,
  i_hqm_sif_rf_mstr_ll_data3_wdata,
  i_hqm_sif_rf_mstr_ll_data3_we,
  i_hqm_sif_rf_mstr_ll_hdr_raddr,
  i_hqm_sif_rf_mstr_ll_hdr_rclk,
  i_hqm_sif_rf_mstr_ll_hdr_rclk_rst_n,
  i_hqm_sif_rf_mstr_ll_hdr_rdata,
  i_hqm_sif_rf_mstr_ll_hdr_re,
  i_hqm_sif_rf_mstr_ll_hdr_waddr,
  i_hqm_sif_rf_mstr_ll_hdr_wclk,
  i_hqm_sif_rf_mstr_ll_hdr_wclk_rst_n,
  i_hqm_sif_rf_mstr_ll_hdr_wdata,
  i_hqm_sif_rf_mstr_ll_hdr_we,
  i_hqm_sif_rf_mstr_ll_hpa_raddr,
  i_hqm_sif_rf_mstr_ll_hpa_rclk,
  i_hqm_sif_rf_mstr_ll_hpa_rclk_rst_n,
  i_hqm_sif_rf_mstr_ll_hpa_rdata,
  i_hqm_sif_rf_mstr_ll_hpa_re,
  i_hqm_sif_rf_mstr_ll_hpa_waddr,
  i_hqm_sif_rf_mstr_ll_hpa_wclk,
  i_hqm_sif_rf_mstr_ll_hpa_wclk_rst_n,
  i_hqm_sif_rf_mstr_ll_hpa_wdata,
  i_hqm_sif_rf_mstr_ll_hpa_we,
  i_hqm_sif_rf_ri_tlq_fifo_npdata_raddr,
  i_hqm_sif_rf_ri_tlq_fifo_npdata_rclk,
  i_hqm_sif_rf_ri_tlq_fifo_npdata_rclk_rst_n,
  i_hqm_sif_rf_ri_tlq_fifo_npdata_rdata,
  i_hqm_sif_rf_ri_tlq_fifo_npdata_re,
  i_hqm_sif_rf_ri_tlq_fifo_npdata_waddr,
  i_hqm_sif_rf_ri_tlq_fifo_npdata_wclk,
  i_hqm_sif_rf_ri_tlq_fifo_npdata_wclk_rst_n,
  i_hqm_sif_rf_ri_tlq_fifo_npdata_wdata,
  i_hqm_sif_rf_ri_tlq_fifo_npdata_we,
  i_hqm_sif_rf_ri_tlq_fifo_nphdr_raddr,
  i_hqm_sif_rf_ri_tlq_fifo_nphdr_rclk,
  i_hqm_sif_rf_ri_tlq_fifo_nphdr_rclk_rst_n,
  i_hqm_sif_rf_ri_tlq_fifo_nphdr_rdata,
  i_hqm_sif_rf_ri_tlq_fifo_nphdr_re,
  i_hqm_sif_rf_ri_tlq_fifo_nphdr_waddr,
  i_hqm_sif_rf_ri_tlq_fifo_nphdr_wclk,
  i_hqm_sif_rf_ri_tlq_fifo_nphdr_wclk_rst_n,
  i_hqm_sif_rf_ri_tlq_fifo_nphdr_wdata,
  i_hqm_sif_rf_ri_tlq_fifo_nphdr_we,
  i_hqm_sif_rf_ri_tlq_fifo_pdata_raddr,
  i_hqm_sif_rf_ri_tlq_fifo_pdata_rclk,
  i_hqm_sif_rf_ri_tlq_fifo_pdata_rclk_rst_n,
  i_hqm_sif_rf_ri_tlq_fifo_pdata_rdata,
  i_hqm_sif_rf_ri_tlq_fifo_pdata_re,
  i_hqm_sif_rf_ri_tlq_fifo_pdata_waddr,
  i_hqm_sif_rf_ri_tlq_fifo_pdata_wclk,
  i_hqm_sif_rf_ri_tlq_fifo_pdata_wclk_rst_n,
  i_hqm_sif_rf_ri_tlq_fifo_pdata_wdata,
  i_hqm_sif_rf_ri_tlq_fifo_pdata_we,
  i_hqm_sif_rf_ri_tlq_fifo_phdr_raddr,
  i_hqm_sif_rf_ri_tlq_fifo_phdr_rclk,
  i_hqm_sif_rf_ri_tlq_fifo_phdr_rclk_rst_n,
  i_hqm_sif_rf_ri_tlq_fifo_phdr_rdata,
  i_hqm_sif_rf_ri_tlq_fifo_phdr_re,
  i_hqm_sif_rf_ri_tlq_fifo_phdr_waddr,
  i_hqm_sif_rf_ri_tlq_fifo_phdr_wclk,
  i_hqm_sif_rf_ri_tlq_fifo_phdr_wclk_rst_n,
  i_hqm_sif_rf_ri_tlq_fifo_phdr_wdata,
  i_hqm_sif_rf_ri_tlq_fifo_phdr_we,
  i_hqm_sif_rf_scrbd_mem_raddr,
  i_hqm_sif_rf_scrbd_mem_rclk,
  i_hqm_sif_rf_scrbd_mem_rclk_rst_n,
  i_hqm_sif_rf_scrbd_mem_rdata,
  i_hqm_sif_rf_scrbd_mem_re,
  i_hqm_sif_rf_scrbd_mem_waddr,
  i_hqm_sif_rf_scrbd_mem_wclk,
  i_hqm_sif_rf_scrbd_mem_wclk_rst_n,
  i_hqm_sif_rf_scrbd_mem_wdata,
  i_hqm_sif_rf_scrbd_mem_we,
  i_hqm_sif_rf_tlb_data0_4k_raddr,
  i_hqm_sif_rf_tlb_data0_4k_rclk,
  i_hqm_sif_rf_tlb_data0_4k_rclk_rst_n,
  i_hqm_sif_rf_tlb_data0_4k_rdata,
  i_hqm_sif_rf_tlb_data0_4k_re,
  i_hqm_sif_rf_tlb_data0_4k_waddr,
  i_hqm_sif_rf_tlb_data0_4k_wclk,
  i_hqm_sif_rf_tlb_data0_4k_wclk_rst_n,
  i_hqm_sif_rf_tlb_data0_4k_wdata,
  i_hqm_sif_rf_tlb_data0_4k_we,
  i_hqm_sif_rf_tlb_data1_4k_raddr,
  i_hqm_sif_rf_tlb_data1_4k_rclk,
  i_hqm_sif_rf_tlb_data1_4k_rclk_rst_n,
  i_hqm_sif_rf_tlb_data1_4k_rdata,
  i_hqm_sif_rf_tlb_data1_4k_re,
  i_hqm_sif_rf_tlb_data1_4k_waddr,
  i_hqm_sif_rf_tlb_data1_4k_wclk,
  i_hqm_sif_rf_tlb_data1_4k_wclk_rst_n,
  i_hqm_sif_rf_tlb_data1_4k_wdata,
  i_hqm_sif_rf_tlb_data1_4k_we,
  i_hqm_sif_rf_tlb_data2_4k_raddr,
  i_hqm_sif_rf_tlb_data2_4k_rclk,
  i_hqm_sif_rf_tlb_data2_4k_rclk_rst_n,
  i_hqm_sif_rf_tlb_data2_4k_rdata,
  i_hqm_sif_rf_tlb_data2_4k_re,
  i_hqm_sif_rf_tlb_data2_4k_waddr,
  i_hqm_sif_rf_tlb_data2_4k_wclk,
  i_hqm_sif_rf_tlb_data2_4k_wclk_rst_n,
  i_hqm_sif_rf_tlb_data2_4k_wdata,
  i_hqm_sif_rf_tlb_data2_4k_we,
  i_hqm_sif_rf_tlb_data3_4k_raddr,
  i_hqm_sif_rf_tlb_data3_4k_rclk,
  i_hqm_sif_rf_tlb_data3_4k_rclk_rst_n,
  i_hqm_sif_rf_tlb_data3_4k_rdata,
  i_hqm_sif_rf_tlb_data3_4k_re,
  i_hqm_sif_rf_tlb_data3_4k_waddr,
  i_hqm_sif_rf_tlb_data3_4k_wclk,
  i_hqm_sif_rf_tlb_data3_4k_wclk_rst_n,
  i_hqm_sif_rf_tlb_data3_4k_wdata,
  i_hqm_sif_rf_tlb_data3_4k_we,
  i_hqm_sif_rf_tlb_data4_4k_raddr,
  i_hqm_sif_rf_tlb_data4_4k_rclk,
  i_hqm_sif_rf_tlb_data4_4k_rclk_rst_n,
  i_hqm_sif_rf_tlb_data4_4k_rdata,
  i_hqm_sif_rf_tlb_data4_4k_re,
  i_hqm_sif_rf_tlb_data4_4k_waddr,
  i_hqm_sif_rf_tlb_data4_4k_wclk,
  i_hqm_sif_rf_tlb_data4_4k_wclk_rst_n,
  i_hqm_sif_rf_tlb_data4_4k_wdata,
  i_hqm_sif_rf_tlb_data4_4k_we,
  i_hqm_sif_rf_tlb_data5_4k_raddr,
  i_hqm_sif_rf_tlb_data5_4k_rclk,
  i_hqm_sif_rf_tlb_data5_4k_rclk_rst_n,
  i_hqm_sif_rf_tlb_data5_4k_rdata,
  i_hqm_sif_rf_tlb_data5_4k_re,
  i_hqm_sif_rf_tlb_data5_4k_waddr,
  i_hqm_sif_rf_tlb_data5_4k_wclk,
  i_hqm_sif_rf_tlb_data5_4k_wclk_rst_n,
  i_hqm_sif_rf_tlb_data5_4k_wdata,
  i_hqm_sif_rf_tlb_data5_4k_we,
  i_hqm_sif_rf_tlb_data6_4k_raddr,
  i_hqm_sif_rf_tlb_data6_4k_rclk,
  i_hqm_sif_rf_tlb_data6_4k_rclk_rst_n,
  i_hqm_sif_rf_tlb_data6_4k_rdata,
  i_hqm_sif_rf_tlb_data6_4k_re,
  i_hqm_sif_rf_tlb_data6_4k_waddr,
  i_hqm_sif_rf_tlb_data6_4k_wclk,
  i_hqm_sif_rf_tlb_data6_4k_wclk_rst_n,
  i_hqm_sif_rf_tlb_data6_4k_wdata,
  i_hqm_sif_rf_tlb_data6_4k_we,
  i_hqm_sif_rf_tlb_data7_4k_raddr,
  i_hqm_sif_rf_tlb_data7_4k_rclk,
  i_hqm_sif_rf_tlb_data7_4k_rclk_rst_n,
  i_hqm_sif_rf_tlb_data7_4k_rdata,
  i_hqm_sif_rf_tlb_data7_4k_re,
  i_hqm_sif_rf_tlb_data7_4k_waddr,
  i_hqm_sif_rf_tlb_data7_4k_wclk,
  i_hqm_sif_rf_tlb_data7_4k_wclk_rst_n,
  i_hqm_sif_rf_tlb_data7_4k_wdata,
  i_hqm_sif_rf_tlb_data7_4k_we,
  i_hqm_sif_rf_tlb_tag0_4k_raddr,
  i_hqm_sif_rf_tlb_tag0_4k_rclk,
  i_hqm_sif_rf_tlb_tag0_4k_rclk_rst_n,
  i_hqm_sif_rf_tlb_tag0_4k_rdata,
  i_hqm_sif_rf_tlb_tag0_4k_re,
  i_hqm_sif_rf_tlb_tag0_4k_waddr,
  i_hqm_sif_rf_tlb_tag0_4k_wclk,
  i_hqm_sif_rf_tlb_tag0_4k_wclk_rst_n,
  i_hqm_sif_rf_tlb_tag0_4k_wdata,
  i_hqm_sif_rf_tlb_tag0_4k_we,
  i_hqm_sif_rf_tlb_tag1_4k_raddr,
  i_hqm_sif_rf_tlb_tag1_4k_rclk,
  i_hqm_sif_rf_tlb_tag1_4k_rclk_rst_n,
  i_hqm_sif_rf_tlb_tag1_4k_rdata,
  i_hqm_sif_rf_tlb_tag1_4k_re,
  i_hqm_sif_rf_tlb_tag1_4k_waddr,
  i_hqm_sif_rf_tlb_tag1_4k_wclk,
  i_hqm_sif_rf_tlb_tag1_4k_wclk_rst_n,
  i_hqm_sif_rf_tlb_tag1_4k_wdata,
  i_hqm_sif_rf_tlb_tag1_4k_we,
  i_hqm_sif_rf_tlb_tag2_4k_raddr,
  i_hqm_sif_rf_tlb_tag2_4k_rclk,
  i_hqm_sif_rf_tlb_tag2_4k_rclk_rst_n,
  i_hqm_sif_rf_tlb_tag2_4k_rdata,
  i_hqm_sif_rf_tlb_tag2_4k_re,
  i_hqm_sif_rf_tlb_tag2_4k_waddr,
  i_hqm_sif_rf_tlb_tag2_4k_wclk,
  i_hqm_sif_rf_tlb_tag2_4k_wclk_rst_n,
  i_hqm_sif_rf_tlb_tag2_4k_wdata,
  i_hqm_sif_rf_tlb_tag2_4k_we,
  i_hqm_sif_rf_tlb_tag3_4k_raddr,
  i_hqm_sif_rf_tlb_tag3_4k_rclk,
  i_hqm_sif_rf_tlb_tag3_4k_rclk_rst_n,
  i_hqm_sif_rf_tlb_tag3_4k_rdata,
  i_hqm_sif_rf_tlb_tag3_4k_re,
  i_hqm_sif_rf_tlb_tag3_4k_waddr,
  i_hqm_sif_rf_tlb_tag3_4k_wclk,
  i_hqm_sif_rf_tlb_tag3_4k_wclk_rst_n,
  i_hqm_sif_rf_tlb_tag3_4k_wdata,
  i_hqm_sif_rf_tlb_tag3_4k_we,
  i_hqm_sif_rf_tlb_tag4_4k_raddr,
  i_hqm_sif_rf_tlb_tag4_4k_rclk,
  i_hqm_sif_rf_tlb_tag4_4k_rclk_rst_n,
  i_hqm_sif_rf_tlb_tag4_4k_rdata,
  i_hqm_sif_rf_tlb_tag4_4k_re,
  i_hqm_sif_rf_tlb_tag4_4k_waddr,
  i_hqm_sif_rf_tlb_tag4_4k_wclk,
  i_hqm_sif_rf_tlb_tag4_4k_wclk_rst_n,
  i_hqm_sif_rf_tlb_tag4_4k_wdata,
  i_hqm_sif_rf_tlb_tag4_4k_we,
  i_hqm_sif_rf_tlb_tag5_4k_raddr,
  i_hqm_sif_rf_tlb_tag5_4k_rclk,
  i_hqm_sif_rf_tlb_tag5_4k_rclk_rst_n,
  i_hqm_sif_rf_tlb_tag5_4k_rdata,
  i_hqm_sif_rf_tlb_tag5_4k_re,
  i_hqm_sif_rf_tlb_tag5_4k_waddr,
  i_hqm_sif_rf_tlb_tag5_4k_wclk,
  i_hqm_sif_rf_tlb_tag5_4k_wclk_rst_n,
  i_hqm_sif_rf_tlb_tag5_4k_wdata,
  i_hqm_sif_rf_tlb_tag5_4k_we,
  i_hqm_sif_rf_tlb_tag6_4k_raddr,
  i_hqm_sif_rf_tlb_tag6_4k_rclk,
  i_hqm_sif_rf_tlb_tag6_4k_rclk_rst_n,
  i_hqm_sif_rf_tlb_tag6_4k_rdata,
  i_hqm_sif_rf_tlb_tag6_4k_re,
  i_hqm_sif_rf_tlb_tag6_4k_waddr,
  i_hqm_sif_rf_tlb_tag6_4k_wclk,
  i_hqm_sif_rf_tlb_tag6_4k_wclk_rst_n,
  i_hqm_sif_rf_tlb_tag6_4k_wdata,
  i_hqm_sif_rf_tlb_tag6_4k_we,
  i_hqm_sif_rf_tlb_tag7_4k_raddr,
  i_hqm_sif_rf_tlb_tag7_4k_rclk,
  i_hqm_sif_rf_tlb_tag7_4k_rclk_rst_n,
  i_hqm_sif_rf_tlb_tag7_4k_rdata,
  i_hqm_sif_rf_tlb_tag7_4k_re,
  i_hqm_sif_rf_tlb_tag7_4k_waddr,
  i_hqm_sif_rf_tlb_tag7_4k_wclk,
  i_hqm_sif_rf_tlb_tag7_4k_wclk_rst_n,
  i_hqm_sif_rf_tlb_tag7_4k_wdata,
  i_hqm_sif_rf_tlb_tag7_4k_we,
  i_hqm_visa_hqm_core_visa_str_175_174,
  i_hqm_visa_hqm_core_visa_str_178_177,
  i_hqm_visa_hqm_core_visa_str_182_181,
  i_hqm_visa_hqm_core_visa_str_185_184,
  i_hqm_visa_hqm_core_visa_str_189_188,
  i_hqm_visa_hqm_core_visa_str_192_191,
  i_hqm_visa_hqm_core_visa_str_196_195,
  i_hqm_visa_hqm_core_visa_str_199_198,
  i_hqm_visa_hqm_core_visa_str_210_209,
  i_hqm_visa_hqm_core_visa_str_213_212,
  i_hqm_visa_hqm_core_visa_str_224_223,
  i_hqm_visa_hqm_core_visa_str_227_226,
  i_hqm_visa_hqm_core_visa_str_238_237,
  i_hqm_visa_hqm_core_visa_str_241_240,
  i_hqm_visa_hqm_core_visa_str_252,
  i_hqm_visa_hqm_core_visa_str_253,
  interrupt_w_req_ready,
  interrupt_w_req_valid,
  iosf_pgcb_clk,
  ip_ready,
  logic_pgcb_fet_en_b,
  lsp_alarm_down_v,
  lsp_alarm_up_ready,
  lsp_cfg_req_down_read,
  lsp_cfg_req_down_write,
  lsp_cfg_rsp_down_ack,
  lsp_dp_sch_dir_ready,
  lsp_dp_sch_dir_v,
  lsp_dp_sch_rorply_ready,
  lsp_dp_sch_rorply_v,
  lsp_nalb_sch_atq_ready,
  lsp_nalb_sch_atq_v,
  lsp_nalb_sch_rorply_ready,
  lsp_nalb_sch_rorply_v,
  lsp_nalb_sch_unoord_ready,
  lsp_nalb_sch_unoord_v,
  lsp_reset_done,
  lsp_unit_idle,
  lsp_unit_pipeidle,
  master_chp_timestamp,
  mstr_cfg_req_down,
  mstr_cfg_req_down_read,
  mstr_cfg_req_down_write,
  nalb_lsp_enq_lb_ready,
  nalb_lsp_enq_lb_v,
  nalb_lsp_enq_rorply_ready,
  nalb_lsp_enq_rorply_v,
  nalb_reset_done,
  nalb_unit_idle,
  nalb_unit_pipeidle,
  par_logic_pgcb_fet_en_ack_b,
  pci_cfg_pmsixctl_fm,
  pci_cfg_pmsixctl_msie,
  pci_cfg_sciov_en,
  pgcb_clk,
  pgcb_tck,
  pm_hqm_adr_assert,
  pma_safemode,
  powergood_rst_b,
  prim_clk,
  prim_clk_enable,
  prim_clk_ungate,
  prim_clkack,
  prim_clkreq,
  prim_pwrgate_pmc_wake,
  prim_rst_b,
  prochot,
  qed_alarm_down_v,
  qed_alarm_up_ready,
  qed_aqed_enq_ready,
  qed_aqed_enq_v,
  qed_cfg_req_down_read,
  qed_cfg_req_down_write,
  qed_cfg_rsp_down_ack,
  qed_chp_sch_ready,
  qed_chp_sch_v,
  qed_reset_done,
  qed_unit_idle,
  qed_unit_pipeidle,
  reset_prep_ack,
  rop_alarm_down_v,
  rop_alarm_up_ready,
  rop_cfg_req_down_read,
  rop_cfg_req_down_write,
  rop_cfg_rsp_down_ack,
  rop_dp_enq_ready,
  rop_dp_enq_v,
  rop_dqed_enq_ready,
  rop_lsp_reordercmp_ready,
  rop_lsp_reordercmp_v,
  rop_nalb_enq_ready,
  rop_nalb_enq_v,
  rop_qed_dqed_enq_v,
  rop_qed_enq_ready,
  rop_qed_force_clockon,
  rop_reset_done,
  rop_unit_idle,
  rop_unit_pipeidle,
  rtdr_iosfsb_ism_capturedr,
  rtdr_iosfsb_ism_irdec,
  rtdr_iosfsb_ism_shiftdr,
  rtdr_iosfsb_ism_tck,
  rtdr_iosfsb_ism_tdi,
  rtdr_iosfsb_ism_tdo,
  rtdr_iosfsb_ism_trst_b,
  rtdr_iosfsb_ism_updatedr,
  rtdr_tapconfig_capturedr,
  rtdr_tapconfig_irdec,
  rtdr_tapconfig_shiftdr,
  rtdr_tapconfig_tck,
  rtdr_tapconfig_tdi,
  rtdr_tapconfig_tdo,
  rtdr_tapconfig_trst_b,
  rtdr_tapconfig_updatedr,
  rtdr_taptrigger_capturedr,
  rtdr_taptrigger_irdec,
  rtdr_taptrigger_shiftdr,
  rtdr_taptrigger_tck,
  rtdr_taptrigger_tdi,
  rtdr_taptrigger_tdo,
  rtdr_taptrigger_trst_b,
  rtdr_taptrigger_updatedr,
  sfi_rx_data,
  sfi_rx_data_aux_parity,
  sfi_rx_data_block,
  sfi_rx_data_crd_rtn_block,
  sfi_rx_data_crd_rtn_fc_id,
  sfi_rx_data_crd_rtn_valid,
  sfi_rx_data_crd_rtn_value,
  sfi_rx_data_crd_rtn_vc_id,
  sfi_rx_data_early_valid,
  sfi_rx_data_edb,
  sfi_rx_data_end,
  sfi_rx_data_info_byte,
  sfi_rx_data_parity,
  sfi_rx_data_poison,
  sfi_rx_data_start,
  sfi_rx_data_valid,
  sfi_rx_hdr_block,
  sfi_rx_hdr_crd_rtn_block,
  sfi_rx_hdr_crd_rtn_fc_id,
  sfi_rx_hdr_crd_rtn_valid,
  sfi_rx_hdr_crd_rtn_value,
  sfi_rx_hdr_crd_rtn_vc_id,
  sfi_rx_hdr_early_valid,
  sfi_rx_hdr_info_bytes,
  sfi_rx_hdr_valid,
  sfi_rx_header,
  sfi_rx_rx_empty,
  sfi_rx_rxcon_ack,
  sfi_rx_rxdiscon_nack,
  sfi_rx_txcon_req,
  sfi_tx_data,
  sfi_tx_data_aux_parity,
  sfi_tx_data_block,
  sfi_tx_data_crd_rtn_block,
  sfi_tx_data_crd_rtn_fc_id,
  sfi_tx_data_crd_rtn_valid,
  sfi_tx_data_crd_rtn_value,
  sfi_tx_data_crd_rtn_vc_id,
  sfi_tx_data_early_valid,
  sfi_tx_data_edb,
  sfi_tx_data_end,
  sfi_tx_data_info_byte,
  sfi_tx_data_parity,
  sfi_tx_data_poison,
  sfi_tx_data_start,
  sfi_tx_data_valid,
  sfi_tx_hdr_block,
  sfi_tx_hdr_crd_rtn_block,
  sfi_tx_hdr_crd_rtn_fc_id,
  sfi_tx_hdr_crd_rtn_valid,
  sfi_tx_hdr_crd_rtn_value,
  sfi_tx_hdr_crd_rtn_vc_id,
  sfi_tx_hdr_early_valid,
  sfi_tx_hdr_info_bytes,
  sfi_tx_hdr_valid,
  sfi_tx_header,
  sfi_tx_rx_empty,
  sfi_tx_rxcon_ack,
  sfi_tx_rxdiscon_nack,
  sfi_tx_txcon_req,
  side_clk,
  side_clkack,
  side_clkreq,
  side_pok,
  side_pwrgate_pmc_wake,
  side_rst_b,
  sif_alarm_data,
  sif_alarm_ready,
  sif_alarm_v,
  strap_hqm_16b_portids,
  strap_hqm_cmpl_sai,
  strap_hqm_csr_cp,
  strap_hqm_csr_rac,
  strap_hqm_csr_wac,
  strap_hqm_device_id,
  strap_hqm_do_serr_dstid,
  strap_hqm_do_serr_rs,
  strap_hqm_do_serr_sai,
  strap_hqm_do_serr_sairs_valid,
  strap_hqm_do_serr_tag,
  strap_hqm_err_sb_dstid,
  strap_hqm_err_sb_sai,
  strap_hqm_force_pok_sai_0,
  strap_hqm_force_pok_sai_1,
  strap_hqm_gpsb_srcid,
  strap_hqm_resetprep_ack_sai,
  strap_hqm_resetprep_sai_0,
  strap_hqm_resetprep_sai_1,
  strap_hqm_tx_sai,
  strap_no_mgmt_acks,
  system_cfg_req_down_read,
  system_cfg_req_down_write,
  system_cfg_rsp_down_ack,
  system_idle,
  system_reset_done,
  visa_str_chp_lsp_cmp_data,
  wd_clkreq,
  write_buffer_mstr,
  write_buffer_mstr_ready,
  write_buffer_mstr_v
);
 output [63:0] adtf_dnstream_data;
 output [24:0] adtf_dnstream_header;
 output  adtf_dnstream_valid;
 input  ap_alarm_down_v;
 input  ap_alarm_up_ready;
 input  ap_aqed_ready;
 input  ap_aqed_v;
 input  ap_cfg_req_down_read;
 input  ap_cfg_req_down_write;
 input  ap_cfg_rsp_down_ack;
 input  ap_reset_done;
 input  ap_unit_idle;
 input  ap_unit_pipeidle;
 input  aqed_alarm_down_v;
 input  aqed_ap_enq_ready;
 input  aqed_ap_enq_v;
 input [92:0] aqed_cfg_req_down;
 input  aqed_cfg_req_down_read;
 input  aqed_cfg_req_down_write;
 input [38:0] aqed_cfg_rsp_down;
 input  aqed_cfg_rsp_down_ack;
 input  aqed_chp_sch_ready;
 input  aqed_chp_sch_v;
 input  aqed_lsp_sch_ready;
 input  aqed_lsp_sch_v;
 input  aqed_reset_done;
 input  aqed_unit_idle;
 input  aqed_unit_pipeidle;
 output [3:0] atrig_fabric_in_ack;
 output [3:0] atrig_fabric_out;
 input  chp_alarm_up_ready;
 input  chp_cfg_req_down_read;
 input  chp_cfg_req_down_write;
 input  chp_cfg_rsp_down_ack;
 input  chp_lsp_cmp_ready;
 input  chp_lsp_cmp_v;
 input  chp_lsp_token_ready;
 input  chp_lsp_token_v;
 input  chp_reset_done;
 input  chp_rop_hcw_ready;
 input  chp_rop_hcw_v;
 input  chp_unit_idle;
 input  chp_unit_pipeidle;
 input  cwdi_interrupt_w_req_ready;
 input  cwdi_interrupt_w_req_valid;
 output  dig_view_out_0;
 output  dig_view_out_1;
 input  dp_lsp_enq_dir_ready;
 input  dp_lsp_enq_dir_v;
 input  dp_lsp_enq_rorply_ready;
 input  dp_lsp_enq_rorply_v;
 input  dp_reset_done;
 input  dp_unit_idle;
 input  dp_unit_pipeidle;
 input [31:0] dvp_paddr;
 input  dvp_penable;
 input [2:0] dvp_pprot;
 output [31:0] dvp_prdata;
 output  dvp_pready;
 input  dvp_psel;
 output  dvp_pslverr;
 input [3:0] dvp_pstrb;
 input [31:0] dvp_pwdata;
 input  dvp_pwrite;
 input [15:0] early_fuses;
 input [7:0] fdfx_debug_cap;
 input  fdfx_debug_cap_valid;
 input  fdfx_earlyboot_debug_exit;
 input  fdfx_policy_update;
 input  fdfx_powergood;
 input  fdfx_sbparity_def;
 input [7:0] fdfx_security_policy;
 input  fdtf_clk;
 input  fdtf_cry_clk;
 input [1:0] fdtf_fast_cnt_width;
 input  fdtf_force_ts;
 input [7:0] fdtf_packetizer_cid;
 input [7:0] fdtf_packetizer_mid;
 input  fdtf_rst_b;
 input  fdtf_serial_download_tsc;
 input  fdtf_survive_mode;
 input  fdtf_timestamp_valid;
 input [55:0] fdtf_timestamp_value;
 input [15:0] fdtf_tsc_adjustment_strap;
 input  fdtf_upstream_active;
 input  fdtf_upstream_credit;
 input  fdtf_upstream_sync;
 input  fscan_byprst_b;
 input  fscan_clkungate;
 input  fscan_clkungate_syn;
 input  fscan_latchclosed_b;
 input  fscan_latchopen;
 input  fscan_mode;
 input  fscan_rstbypen;
 input  fscan_shiften;
 input [3:0] ftrig_fabric_in;
 input [3:0] ftrig_fabric_out_ack;
 output  gpsb_meom;
 input  gpsb_mnpcup;
 output  gpsb_mnpput;
 output  gpsb_mparity;
 output [7:0] gpsb_mpayload;
 input  gpsb_mpccup;
 output  gpsb_mpcput;
 output [2:0] gpsb_side_ism_agent;
 input [2:0] gpsb_side_ism_fabric;
 input  gpsb_teom;
 output  gpsb_tnpcup;
 input  gpsb_tnpput;
 input  gpsb_tparity;
 input [7:0] gpsb_tpayload;
 output  gpsb_tpccup;
 input  gpsb_tpcput;
 output [160:0] hcw_enq_in_data;
 input  hcw_enq_in_ready;
 output  hcw_enq_in_v;
 input  hcw_enq_w_req_ready;
 input  hcw_enq_w_req_valid;
 input  hcw_sched_w_req_ready;
 input  hcw_sched_w_req_valid;
 input  hqm_alarm_ready;
 input  hqm_alarm_v;
 output  hqm_clk_enable;
 output  hqm_clk_rptr_rst_b;
 output  hqm_clk_trunk;
 output  hqm_clk_ungate;
 output  hqm_flr_prep;
 output  hqm_gated_local_override;
 output  hqm_gated_rst_b;
 output  hqm_pm_adr_ack;
 input  hqm_proc_clk_en_chp;
 input  hqm_proc_clk_en_dir;
 input  hqm_proc_clk_en_lsp;
 input  hqm_proc_clk_en_nalb;
 input  hqm_proc_clk_en_qed;
 input  hqm_proc_clk_en_sys;
 output  hqm_proc_reset_done_sync_hqm;
 input [29:0] hqm_system_visa_str;
 input  i_hqm_AW_fet_en_sequencer_par_mem_pgcb_fet_en_ack_b;
 output  i_hqm_AW_fet_en_sequencer_par_mem_pgcb_fet_en_b;
 input  i_hqm_master_fscan_isol_ctrl;
 input  i_hqm_master_fscan_isol_lat_ctrl;
 input  i_hqm_master_fscan_ret_ctrl;
 output  i_hqm_master_pgcb_isol_en;
 output  i_hqm_master_pgcb_isol_en_b;
 output  i_hqm_pwrgood_rst_b_buf_o;
 output [7:0] i_hqm_sif_rf_ibcpl_data_fifo_raddr;
 output  i_hqm_sif_rf_ibcpl_data_fifo_rclk;
 output  i_hqm_sif_rf_ibcpl_data_fifo_rclk_rst_n;
 input [65:0] i_hqm_sif_rf_ibcpl_data_fifo_rdata;
 output  i_hqm_sif_rf_ibcpl_data_fifo_re;
 output [7:0] i_hqm_sif_rf_ibcpl_data_fifo_waddr;
 output  i_hqm_sif_rf_ibcpl_data_fifo_wclk;
 output  i_hqm_sif_rf_ibcpl_data_fifo_wclk_rst_n;
 output [65:0] i_hqm_sif_rf_ibcpl_data_fifo_wdata;
 output  i_hqm_sif_rf_ibcpl_data_fifo_we;
 output [7:0] i_hqm_sif_rf_ibcpl_hdr_fifo_raddr;
 output  i_hqm_sif_rf_ibcpl_hdr_fifo_rclk;
 output  i_hqm_sif_rf_ibcpl_hdr_fifo_rclk_rst_n;
 input [19:0] i_hqm_sif_rf_ibcpl_hdr_fifo_rdata;
 output  i_hqm_sif_rf_ibcpl_hdr_fifo_re;
 output [7:0] i_hqm_sif_rf_ibcpl_hdr_fifo_waddr;
 output  i_hqm_sif_rf_ibcpl_hdr_fifo_wclk;
 output  i_hqm_sif_rf_ibcpl_hdr_fifo_wclk_rst_n;
 output [19:0] i_hqm_sif_rf_ibcpl_hdr_fifo_wdata;
 output  i_hqm_sif_rf_ibcpl_hdr_fifo_we;
 output [7:0] i_hqm_sif_rf_mstr_ll_data0_raddr;
 output  i_hqm_sif_rf_mstr_ll_data0_rclk;
 output  i_hqm_sif_rf_mstr_ll_data0_rclk_rst_n;
 input [128:0] i_hqm_sif_rf_mstr_ll_data0_rdata;
 output  i_hqm_sif_rf_mstr_ll_data0_re;
 output [7:0] i_hqm_sif_rf_mstr_ll_data0_waddr;
 output  i_hqm_sif_rf_mstr_ll_data0_wclk;
 output  i_hqm_sif_rf_mstr_ll_data0_wclk_rst_n;
 output [128:0] i_hqm_sif_rf_mstr_ll_data0_wdata;
 output  i_hqm_sif_rf_mstr_ll_data0_we;
 output [7:0] i_hqm_sif_rf_mstr_ll_data1_raddr;
 output  i_hqm_sif_rf_mstr_ll_data1_rclk;
 output  i_hqm_sif_rf_mstr_ll_data1_rclk_rst_n;
 input [128:0] i_hqm_sif_rf_mstr_ll_data1_rdata;
 output  i_hqm_sif_rf_mstr_ll_data1_re;
 output [7:0] i_hqm_sif_rf_mstr_ll_data1_waddr;
 output  i_hqm_sif_rf_mstr_ll_data1_wclk;
 output  i_hqm_sif_rf_mstr_ll_data1_wclk_rst_n;
 output [128:0] i_hqm_sif_rf_mstr_ll_data1_wdata;
 output  i_hqm_sif_rf_mstr_ll_data1_we;
 output [7:0] i_hqm_sif_rf_mstr_ll_data2_raddr;
 output  i_hqm_sif_rf_mstr_ll_data2_rclk;
 output  i_hqm_sif_rf_mstr_ll_data2_rclk_rst_n;
 input [128:0] i_hqm_sif_rf_mstr_ll_data2_rdata;
 output  i_hqm_sif_rf_mstr_ll_data2_re;
 output [7:0] i_hqm_sif_rf_mstr_ll_data2_waddr;
 output  i_hqm_sif_rf_mstr_ll_data2_wclk;
 output  i_hqm_sif_rf_mstr_ll_data2_wclk_rst_n;
 output [128:0] i_hqm_sif_rf_mstr_ll_data2_wdata;
 output  i_hqm_sif_rf_mstr_ll_data2_we;
 output [7:0] i_hqm_sif_rf_mstr_ll_data3_raddr;
 output  i_hqm_sif_rf_mstr_ll_data3_rclk;
 output  i_hqm_sif_rf_mstr_ll_data3_rclk_rst_n;
 input [128:0] i_hqm_sif_rf_mstr_ll_data3_rdata;
 output  i_hqm_sif_rf_mstr_ll_data3_re;
 output [7:0] i_hqm_sif_rf_mstr_ll_data3_waddr;
 output  i_hqm_sif_rf_mstr_ll_data3_wclk;
 output  i_hqm_sif_rf_mstr_ll_data3_wclk_rst_n;
 output [128:0] i_hqm_sif_rf_mstr_ll_data3_wdata;
 output  i_hqm_sif_rf_mstr_ll_data3_we;
 output [7:0] i_hqm_sif_rf_mstr_ll_hdr_raddr;
 output  i_hqm_sif_rf_mstr_ll_hdr_rclk;
 output  i_hqm_sif_rf_mstr_ll_hdr_rclk_rst_n;
 input [152:0] i_hqm_sif_rf_mstr_ll_hdr_rdata;
 output  i_hqm_sif_rf_mstr_ll_hdr_re;
 output [7:0] i_hqm_sif_rf_mstr_ll_hdr_waddr;
 output  i_hqm_sif_rf_mstr_ll_hdr_wclk;
 output  i_hqm_sif_rf_mstr_ll_hdr_wclk_rst_n;
 output [152:0] i_hqm_sif_rf_mstr_ll_hdr_wdata;
 output  i_hqm_sif_rf_mstr_ll_hdr_we;
 output [6:0] i_hqm_sif_rf_mstr_ll_hpa_raddr;
 output  i_hqm_sif_rf_mstr_ll_hpa_rclk;
 output  i_hqm_sif_rf_mstr_ll_hpa_rclk_rst_n;
 input [34:0] i_hqm_sif_rf_mstr_ll_hpa_rdata;
 output  i_hqm_sif_rf_mstr_ll_hpa_re;
 output [6:0] i_hqm_sif_rf_mstr_ll_hpa_waddr;
 output  i_hqm_sif_rf_mstr_ll_hpa_wclk;
 output  i_hqm_sif_rf_mstr_ll_hpa_wclk_rst_n;
 output [34:0] i_hqm_sif_rf_mstr_ll_hpa_wdata;
 output  i_hqm_sif_rf_mstr_ll_hpa_we;
 output [2:0] i_hqm_sif_rf_ri_tlq_fifo_npdata_raddr;
 output  i_hqm_sif_rf_ri_tlq_fifo_npdata_rclk;
 output  i_hqm_sif_rf_ri_tlq_fifo_npdata_rclk_rst_n;
 input [32:0] i_hqm_sif_rf_ri_tlq_fifo_npdata_rdata;
 output  i_hqm_sif_rf_ri_tlq_fifo_npdata_re;
 output [2:0] i_hqm_sif_rf_ri_tlq_fifo_npdata_waddr;
 output  i_hqm_sif_rf_ri_tlq_fifo_npdata_wclk;
 output  i_hqm_sif_rf_ri_tlq_fifo_npdata_wclk_rst_n;
 output [32:0] i_hqm_sif_rf_ri_tlq_fifo_npdata_wdata;
 output  i_hqm_sif_rf_ri_tlq_fifo_npdata_we;
 output [2:0] i_hqm_sif_rf_ri_tlq_fifo_nphdr_raddr;
 output  i_hqm_sif_rf_ri_tlq_fifo_nphdr_rclk;
 output  i_hqm_sif_rf_ri_tlq_fifo_nphdr_rclk_rst_n;
 input [157:0] i_hqm_sif_rf_ri_tlq_fifo_nphdr_rdata;
 output  i_hqm_sif_rf_ri_tlq_fifo_nphdr_re;
 output [2:0] i_hqm_sif_rf_ri_tlq_fifo_nphdr_waddr;
 output  i_hqm_sif_rf_ri_tlq_fifo_nphdr_wclk;
 output  i_hqm_sif_rf_ri_tlq_fifo_nphdr_wclk_rst_n;
 output [157:0] i_hqm_sif_rf_ri_tlq_fifo_nphdr_wdata;
 output  i_hqm_sif_rf_ri_tlq_fifo_nphdr_we;
 output [4:0] i_hqm_sif_rf_ri_tlq_fifo_pdata_raddr;
 output  i_hqm_sif_rf_ri_tlq_fifo_pdata_rclk;
 output  i_hqm_sif_rf_ri_tlq_fifo_pdata_rclk_rst_n;
 input [263:0] i_hqm_sif_rf_ri_tlq_fifo_pdata_rdata;
 output  i_hqm_sif_rf_ri_tlq_fifo_pdata_re;
 output [4:0] i_hqm_sif_rf_ri_tlq_fifo_pdata_waddr;
 output  i_hqm_sif_rf_ri_tlq_fifo_pdata_wclk;
 output  i_hqm_sif_rf_ri_tlq_fifo_pdata_wclk_rst_n;
 output [263:0] i_hqm_sif_rf_ri_tlq_fifo_pdata_wdata;
 output  i_hqm_sif_rf_ri_tlq_fifo_pdata_we;
 output [3:0] i_hqm_sif_rf_ri_tlq_fifo_phdr_raddr;
 output  i_hqm_sif_rf_ri_tlq_fifo_phdr_rclk;
 output  i_hqm_sif_rf_ri_tlq_fifo_phdr_rclk_rst_n;
 input [152:0] i_hqm_sif_rf_ri_tlq_fifo_phdr_rdata;
 output  i_hqm_sif_rf_ri_tlq_fifo_phdr_re;
 output [3:0] i_hqm_sif_rf_ri_tlq_fifo_phdr_waddr;
 output  i_hqm_sif_rf_ri_tlq_fifo_phdr_wclk;
 output  i_hqm_sif_rf_ri_tlq_fifo_phdr_wclk_rst_n;
 output [152:0] i_hqm_sif_rf_ri_tlq_fifo_phdr_wdata;
 output  i_hqm_sif_rf_ri_tlq_fifo_phdr_we;
 output [7:0] i_hqm_sif_rf_scrbd_mem_raddr;
 output  i_hqm_sif_rf_scrbd_mem_rclk;
 output  i_hqm_sif_rf_scrbd_mem_rclk_rst_n;
 input [9:0] i_hqm_sif_rf_scrbd_mem_rdata;
 output  i_hqm_sif_rf_scrbd_mem_re;
 output [7:0] i_hqm_sif_rf_scrbd_mem_waddr;
 output  i_hqm_sif_rf_scrbd_mem_wclk;
 output  i_hqm_sif_rf_scrbd_mem_wclk_rst_n;
 output [9:0] i_hqm_sif_rf_scrbd_mem_wdata;
 output  i_hqm_sif_rf_scrbd_mem_we;
 output [3:0] i_hqm_sif_rf_tlb_data0_4k_raddr;
 output  i_hqm_sif_rf_tlb_data0_4k_rclk;
 output  i_hqm_sif_rf_tlb_data0_4k_rclk_rst_n;
 input [38:0] i_hqm_sif_rf_tlb_data0_4k_rdata;
 output  i_hqm_sif_rf_tlb_data0_4k_re;
 output [3:0] i_hqm_sif_rf_tlb_data0_4k_waddr;
 output  i_hqm_sif_rf_tlb_data0_4k_wclk;
 output  i_hqm_sif_rf_tlb_data0_4k_wclk_rst_n;
 output [38:0] i_hqm_sif_rf_tlb_data0_4k_wdata;
 output  i_hqm_sif_rf_tlb_data0_4k_we;
 output [3:0] i_hqm_sif_rf_tlb_data1_4k_raddr;
 output  i_hqm_sif_rf_tlb_data1_4k_rclk;
 output  i_hqm_sif_rf_tlb_data1_4k_rclk_rst_n;
 input [38:0] i_hqm_sif_rf_tlb_data1_4k_rdata;
 output  i_hqm_sif_rf_tlb_data1_4k_re;
 output [3:0] i_hqm_sif_rf_tlb_data1_4k_waddr;
 output  i_hqm_sif_rf_tlb_data1_4k_wclk;
 output  i_hqm_sif_rf_tlb_data1_4k_wclk_rst_n;
 output [38:0] i_hqm_sif_rf_tlb_data1_4k_wdata;
 output  i_hqm_sif_rf_tlb_data1_4k_we;
 output [3:0] i_hqm_sif_rf_tlb_data2_4k_raddr;
 output  i_hqm_sif_rf_tlb_data2_4k_rclk;
 output  i_hqm_sif_rf_tlb_data2_4k_rclk_rst_n;
 input [38:0] i_hqm_sif_rf_tlb_data2_4k_rdata;
 output  i_hqm_sif_rf_tlb_data2_4k_re;
 output [3:0] i_hqm_sif_rf_tlb_data2_4k_waddr;
 output  i_hqm_sif_rf_tlb_data2_4k_wclk;
 output  i_hqm_sif_rf_tlb_data2_4k_wclk_rst_n;
 output [38:0] i_hqm_sif_rf_tlb_data2_4k_wdata;
 output  i_hqm_sif_rf_tlb_data2_4k_we;
 output [3:0] i_hqm_sif_rf_tlb_data3_4k_raddr;
 output  i_hqm_sif_rf_tlb_data3_4k_rclk;
 output  i_hqm_sif_rf_tlb_data3_4k_rclk_rst_n;
 input [38:0] i_hqm_sif_rf_tlb_data3_4k_rdata;
 output  i_hqm_sif_rf_tlb_data3_4k_re;
 output [3:0] i_hqm_sif_rf_tlb_data3_4k_waddr;
 output  i_hqm_sif_rf_tlb_data3_4k_wclk;
 output  i_hqm_sif_rf_tlb_data3_4k_wclk_rst_n;
 output [38:0] i_hqm_sif_rf_tlb_data3_4k_wdata;
 output  i_hqm_sif_rf_tlb_data3_4k_we;
 output [3:0] i_hqm_sif_rf_tlb_data4_4k_raddr;
 output  i_hqm_sif_rf_tlb_data4_4k_rclk;
 output  i_hqm_sif_rf_tlb_data4_4k_rclk_rst_n;
 input [38:0] i_hqm_sif_rf_tlb_data4_4k_rdata;
 output  i_hqm_sif_rf_tlb_data4_4k_re;
 output [3:0] i_hqm_sif_rf_tlb_data4_4k_waddr;
 output  i_hqm_sif_rf_tlb_data4_4k_wclk;
 output  i_hqm_sif_rf_tlb_data4_4k_wclk_rst_n;
 output [38:0] i_hqm_sif_rf_tlb_data4_4k_wdata;
 output  i_hqm_sif_rf_tlb_data4_4k_we;
 output [3:0] i_hqm_sif_rf_tlb_data5_4k_raddr;
 output  i_hqm_sif_rf_tlb_data5_4k_rclk;
 output  i_hqm_sif_rf_tlb_data5_4k_rclk_rst_n;
 input [38:0] i_hqm_sif_rf_tlb_data5_4k_rdata;
 output  i_hqm_sif_rf_tlb_data5_4k_re;
 output [3:0] i_hqm_sif_rf_tlb_data5_4k_waddr;
 output  i_hqm_sif_rf_tlb_data5_4k_wclk;
 output  i_hqm_sif_rf_tlb_data5_4k_wclk_rst_n;
 output [38:0] i_hqm_sif_rf_tlb_data5_4k_wdata;
 output  i_hqm_sif_rf_tlb_data5_4k_we;
 output [3:0] i_hqm_sif_rf_tlb_data6_4k_raddr;
 output  i_hqm_sif_rf_tlb_data6_4k_rclk;
 output  i_hqm_sif_rf_tlb_data6_4k_rclk_rst_n;
 input [38:0] i_hqm_sif_rf_tlb_data6_4k_rdata;
 output  i_hqm_sif_rf_tlb_data6_4k_re;
 output [3:0] i_hqm_sif_rf_tlb_data6_4k_waddr;
 output  i_hqm_sif_rf_tlb_data6_4k_wclk;
 output  i_hqm_sif_rf_tlb_data6_4k_wclk_rst_n;
 output [38:0] i_hqm_sif_rf_tlb_data6_4k_wdata;
 output  i_hqm_sif_rf_tlb_data6_4k_we;
 output [3:0] i_hqm_sif_rf_tlb_data7_4k_raddr;
 output  i_hqm_sif_rf_tlb_data7_4k_rclk;
 output  i_hqm_sif_rf_tlb_data7_4k_rclk_rst_n;
 input [38:0] i_hqm_sif_rf_tlb_data7_4k_rdata;
 output  i_hqm_sif_rf_tlb_data7_4k_re;
 output [3:0] i_hqm_sif_rf_tlb_data7_4k_waddr;
 output  i_hqm_sif_rf_tlb_data7_4k_wclk;
 output  i_hqm_sif_rf_tlb_data7_4k_wclk_rst_n;
 output [38:0] i_hqm_sif_rf_tlb_data7_4k_wdata;
 output  i_hqm_sif_rf_tlb_data7_4k_we;
 output [3:0] i_hqm_sif_rf_tlb_tag0_4k_raddr;
 output  i_hqm_sif_rf_tlb_tag0_4k_rclk;
 output  i_hqm_sif_rf_tlb_tag0_4k_rclk_rst_n;
 input [84:0] i_hqm_sif_rf_tlb_tag0_4k_rdata;
 output  i_hqm_sif_rf_tlb_tag0_4k_re;
 output [3:0] i_hqm_sif_rf_tlb_tag0_4k_waddr;
 output  i_hqm_sif_rf_tlb_tag0_4k_wclk;
 output  i_hqm_sif_rf_tlb_tag0_4k_wclk_rst_n;
 output [84:0] i_hqm_sif_rf_tlb_tag0_4k_wdata;
 output  i_hqm_sif_rf_tlb_tag0_4k_we;
 output [3:0] i_hqm_sif_rf_tlb_tag1_4k_raddr;
 output  i_hqm_sif_rf_tlb_tag1_4k_rclk;
 output  i_hqm_sif_rf_tlb_tag1_4k_rclk_rst_n;
 input [84:0] i_hqm_sif_rf_tlb_tag1_4k_rdata;
 output  i_hqm_sif_rf_tlb_tag1_4k_re;
 output [3:0] i_hqm_sif_rf_tlb_tag1_4k_waddr;
 output  i_hqm_sif_rf_tlb_tag1_4k_wclk;
 output  i_hqm_sif_rf_tlb_tag1_4k_wclk_rst_n;
 output [84:0] i_hqm_sif_rf_tlb_tag1_4k_wdata;
 output  i_hqm_sif_rf_tlb_tag1_4k_we;
 output [3:0] i_hqm_sif_rf_tlb_tag2_4k_raddr;
 output  i_hqm_sif_rf_tlb_tag2_4k_rclk;
 output  i_hqm_sif_rf_tlb_tag2_4k_rclk_rst_n;
 input [84:0] i_hqm_sif_rf_tlb_tag2_4k_rdata;
 output  i_hqm_sif_rf_tlb_tag2_4k_re;
 output [3:0] i_hqm_sif_rf_tlb_tag2_4k_waddr;
 output  i_hqm_sif_rf_tlb_tag2_4k_wclk;
 output  i_hqm_sif_rf_tlb_tag2_4k_wclk_rst_n;
 output [84:0] i_hqm_sif_rf_tlb_tag2_4k_wdata;
 output  i_hqm_sif_rf_tlb_tag2_4k_we;
 output [3:0] i_hqm_sif_rf_tlb_tag3_4k_raddr;
 output  i_hqm_sif_rf_tlb_tag3_4k_rclk;
 output  i_hqm_sif_rf_tlb_tag3_4k_rclk_rst_n;
 input [84:0] i_hqm_sif_rf_tlb_tag3_4k_rdata;
 output  i_hqm_sif_rf_tlb_tag3_4k_re;
 output [3:0] i_hqm_sif_rf_tlb_tag3_4k_waddr;
 output  i_hqm_sif_rf_tlb_tag3_4k_wclk;
 output  i_hqm_sif_rf_tlb_tag3_4k_wclk_rst_n;
 output [84:0] i_hqm_sif_rf_tlb_tag3_4k_wdata;
 output  i_hqm_sif_rf_tlb_tag3_4k_we;
 output [3:0] i_hqm_sif_rf_tlb_tag4_4k_raddr;
 output  i_hqm_sif_rf_tlb_tag4_4k_rclk;
 output  i_hqm_sif_rf_tlb_tag4_4k_rclk_rst_n;
 input [84:0] i_hqm_sif_rf_tlb_tag4_4k_rdata;
 output  i_hqm_sif_rf_tlb_tag4_4k_re;
 output [3:0] i_hqm_sif_rf_tlb_tag4_4k_waddr;
 output  i_hqm_sif_rf_tlb_tag4_4k_wclk;
 output  i_hqm_sif_rf_tlb_tag4_4k_wclk_rst_n;
 output [84:0] i_hqm_sif_rf_tlb_tag4_4k_wdata;
 output  i_hqm_sif_rf_tlb_tag4_4k_we;
 output [3:0] i_hqm_sif_rf_tlb_tag5_4k_raddr;
 output  i_hqm_sif_rf_tlb_tag5_4k_rclk;
 output  i_hqm_sif_rf_tlb_tag5_4k_rclk_rst_n;
 input [84:0] i_hqm_sif_rf_tlb_tag5_4k_rdata;
 output  i_hqm_sif_rf_tlb_tag5_4k_re;
 output [3:0] i_hqm_sif_rf_tlb_tag5_4k_waddr;
 output  i_hqm_sif_rf_tlb_tag5_4k_wclk;
 output  i_hqm_sif_rf_tlb_tag5_4k_wclk_rst_n;
 output [84:0] i_hqm_sif_rf_tlb_tag5_4k_wdata;
 output  i_hqm_sif_rf_tlb_tag5_4k_we;
 output [3:0] i_hqm_sif_rf_tlb_tag6_4k_raddr;
 output  i_hqm_sif_rf_tlb_tag6_4k_rclk;
 output  i_hqm_sif_rf_tlb_tag6_4k_rclk_rst_n;
 input [84:0] i_hqm_sif_rf_tlb_tag6_4k_rdata;
 output  i_hqm_sif_rf_tlb_tag6_4k_re;
 output [3:0] i_hqm_sif_rf_tlb_tag6_4k_waddr;
 output  i_hqm_sif_rf_tlb_tag6_4k_wclk;
 output  i_hqm_sif_rf_tlb_tag6_4k_wclk_rst_n;
 output [84:0] i_hqm_sif_rf_tlb_tag6_4k_wdata;
 output  i_hqm_sif_rf_tlb_tag6_4k_we;
 output [3:0] i_hqm_sif_rf_tlb_tag7_4k_raddr;
 output  i_hqm_sif_rf_tlb_tag7_4k_rclk;
 output  i_hqm_sif_rf_tlb_tag7_4k_rclk_rst_n;
 input [84:0] i_hqm_sif_rf_tlb_tag7_4k_rdata;
 output  i_hqm_sif_rf_tlb_tag7_4k_re;
 output [3:0] i_hqm_sif_rf_tlb_tag7_4k_waddr;
 output  i_hqm_sif_rf_tlb_tag7_4k_wclk;
 output  i_hqm_sif_rf_tlb_tag7_4k_wclk_rst_n;
 output [84:0] i_hqm_sif_rf_tlb_tag7_4k_wdata;
 output  i_hqm_sif_rf_tlb_tag7_4k_we;
 input [1:0] i_hqm_visa_hqm_core_visa_str_175_174;
 input [1:0] i_hqm_visa_hqm_core_visa_str_178_177;
 input [1:0] i_hqm_visa_hqm_core_visa_str_182_181;
 input [1:0] i_hqm_visa_hqm_core_visa_str_185_184;
 input [1:0] i_hqm_visa_hqm_core_visa_str_189_188;
 input [1:0] i_hqm_visa_hqm_core_visa_str_192_191;
 input [1:0] i_hqm_visa_hqm_core_visa_str_196_195;
 input [1:0] i_hqm_visa_hqm_core_visa_str_199_198;
 input [1:0] i_hqm_visa_hqm_core_visa_str_210_209;
 input [1:0] i_hqm_visa_hqm_core_visa_str_213_212;
 input [1:0] i_hqm_visa_hqm_core_visa_str_224_223;
 input [1:0] i_hqm_visa_hqm_core_visa_str_227_226;
 input [1:0] i_hqm_visa_hqm_core_visa_str_238_237;
 input [1:0] i_hqm_visa_hqm_core_visa_str_241_240;
 input  i_hqm_visa_hqm_core_visa_str_252;
 input  i_hqm_visa_hqm_core_visa_str_253;
 input  interrupt_w_req_ready;
 input  interrupt_w_req_valid;
 input  iosf_pgcb_clk;
 output  ip_ready;
 output  logic_pgcb_fet_en_b;
 input  lsp_alarm_down_v;
 input  lsp_alarm_up_ready;
 input  lsp_cfg_req_down_read;
 input  lsp_cfg_req_down_write;
 input  lsp_cfg_rsp_down_ack;
 input  lsp_dp_sch_dir_ready;
 input  lsp_dp_sch_dir_v;
 input  lsp_dp_sch_rorply_ready;
 input  lsp_dp_sch_rorply_v;
 input  lsp_nalb_sch_atq_ready;
 input  lsp_nalb_sch_atq_v;
 input  lsp_nalb_sch_rorply_ready;
 input  lsp_nalb_sch_rorply_v;
 input  lsp_nalb_sch_unoord_ready;
 input  lsp_nalb_sch_unoord_v;
 input  lsp_reset_done;
 input  lsp_unit_idle;
 input  lsp_unit_pipeidle;
 output [15:0] master_chp_timestamp;
 output [92:0] mstr_cfg_req_down;
 output  mstr_cfg_req_down_read;
 output  mstr_cfg_req_down_write;
 input  nalb_lsp_enq_lb_ready;
 input  nalb_lsp_enq_lb_v;
 input  nalb_lsp_enq_rorply_ready;
 input  nalb_lsp_enq_rorply_v;
 input  nalb_reset_done;
 input  nalb_unit_idle;
 input  nalb_unit_pipeidle;
 input  par_logic_pgcb_fet_en_ack_b;
 output  pci_cfg_pmsixctl_fm;
 output  pci_cfg_pmsixctl_msie;
 output  pci_cfg_sciov_en;
 input  pgcb_clk;
 input  pgcb_tck;
 input  pm_hqm_adr_assert;
 input  pma_safemode;
 input  powergood_rst_b;
 input  prim_clk;
 output  prim_clk_enable;
 output  prim_clk_ungate;
 input  prim_clkack;
 output  prim_clkreq;
 input  prim_pwrgate_pmc_wake;
 input  prim_rst_b;
 input  prochot;
 input  qed_alarm_down_v;
 input  qed_alarm_up_ready;
 input  qed_aqed_enq_ready;
 input  qed_aqed_enq_v;
 input  qed_cfg_req_down_read;
 input  qed_cfg_req_down_write;
 input  qed_cfg_rsp_down_ack;
 input  qed_chp_sch_ready;
 input  qed_chp_sch_v;
 input  qed_reset_done;
 input  qed_unit_idle;
 input  qed_unit_pipeidle;
 output  reset_prep_ack;
 input  rop_alarm_down_v;
 input  rop_alarm_up_ready;
 input  rop_cfg_req_down_read;
 input  rop_cfg_req_down_write;
 input  rop_cfg_rsp_down_ack;
 input  rop_dp_enq_ready;
 input  rop_dp_enq_v;
 input  rop_dqed_enq_ready;
 input  rop_lsp_reordercmp_ready;
 input  rop_lsp_reordercmp_v;
 input  rop_nalb_enq_ready;
 input  rop_nalb_enq_v;
 input  rop_qed_dqed_enq_v;
 input  rop_qed_enq_ready;
 input  rop_qed_force_clockon;
 input  rop_reset_done;
 input  rop_unit_idle;
 input  rop_unit_pipeidle;
 input  rtdr_iosfsb_ism_capturedr;
 input  rtdr_iosfsb_ism_irdec;
 input  rtdr_iosfsb_ism_shiftdr;
 input  rtdr_iosfsb_ism_tck;
 input  rtdr_iosfsb_ism_tdi;
 output  rtdr_iosfsb_ism_tdo;
 input  rtdr_iosfsb_ism_trst_b;
 input  rtdr_iosfsb_ism_updatedr;
 input  rtdr_tapconfig_capturedr;
 input  rtdr_tapconfig_irdec;
 input  rtdr_tapconfig_shiftdr;
 input  rtdr_tapconfig_tck;
 input  rtdr_tapconfig_tdi;
 output  rtdr_tapconfig_tdo;
 input  rtdr_tapconfig_trst_b;
 input  rtdr_tapconfig_updatedr;
 input  rtdr_taptrigger_capturedr;
 input  rtdr_taptrigger_irdec;
 input  rtdr_taptrigger_shiftdr;
 input  rtdr_taptrigger_tck;
 input  rtdr_taptrigger_tdi;
 output  rtdr_taptrigger_tdo;
 input  rtdr_taptrigger_trst_b;
 input  rtdr_taptrigger_updatedr;
 input [255:0] sfi_rx_data;
 input  sfi_rx_data_aux_parity;
 output  sfi_rx_data_block;
 input  sfi_rx_data_crd_rtn_block;
 output [1:0] sfi_rx_data_crd_rtn_fc_id;
 output  sfi_rx_data_crd_rtn_valid;
 output [3:0] sfi_rx_data_crd_rtn_value;
 output [4:0] sfi_rx_data_crd_rtn_vc_id;
 input  sfi_rx_data_early_valid;
 input [7:0] sfi_rx_data_edb;
 input [7:0] sfi_rx_data_end;
 input [7:0] sfi_rx_data_info_byte;
 input [3:0] sfi_rx_data_parity;
 input [7:0] sfi_rx_data_poison;
 input  sfi_rx_data_start;
 input  sfi_rx_data_valid;
 output  sfi_rx_hdr_block;
 input  sfi_rx_hdr_crd_rtn_block;
 output [1:0] sfi_rx_hdr_crd_rtn_fc_id;
 output  sfi_rx_hdr_crd_rtn_valid;
 output [3:0] sfi_rx_hdr_crd_rtn_value;
 output [4:0] sfi_rx_hdr_crd_rtn_vc_id;
 input  sfi_rx_hdr_early_valid;
 input [15:0] sfi_rx_hdr_info_bytes;
 input  sfi_rx_hdr_valid;
 input [255:0] sfi_rx_header;
 output  sfi_rx_rx_empty;
 output  sfi_rx_rxcon_ack;
 output  sfi_rx_rxdiscon_nack;
 input  sfi_rx_txcon_req;
 output [255:0] sfi_tx_data;
 output  sfi_tx_data_aux_parity;
 input  sfi_tx_data_block;
 output  sfi_tx_data_crd_rtn_block;
 input [1:0] sfi_tx_data_crd_rtn_fc_id;
 input  sfi_tx_data_crd_rtn_valid;
 input [3:0] sfi_tx_data_crd_rtn_value;
 input [4:0] sfi_tx_data_crd_rtn_vc_id;
 output  sfi_tx_data_early_valid;
 output [7:0] sfi_tx_data_edb;
 output [7:0] sfi_tx_data_end;
 output [7:0] sfi_tx_data_info_byte;
 output [3:0] sfi_tx_data_parity;
 output [7:0] sfi_tx_data_poison;
 output  sfi_tx_data_start;
 output  sfi_tx_data_valid;
 input  sfi_tx_hdr_block;
 output  sfi_tx_hdr_crd_rtn_block;
 input [1:0] sfi_tx_hdr_crd_rtn_fc_id;
 input  sfi_tx_hdr_crd_rtn_valid;
 input [3:0] sfi_tx_hdr_crd_rtn_value;
 input [4:0] sfi_tx_hdr_crd_rtn_vc_id;
 output  sfi_tx_hdr_early_valid;
 output [15:0] sfi_tx_hdr_info_bytes;
 output  sfi_tx_hdr_valid;
 output [255:0] sfi_tx_header;
 input  sfi_tx_rx_empty;
 input  sfi_tx_rxcon_ack;
 input  sfi_tx_rxdiscon_nack;
 output  sfi_tx_txcon_req;
 input  side_clk;
 input  side_clkack;
 output  side_clkreq;
 output  side_pok;
 input  side_pwrgate_pmc_wake;
 input  side_rst_b;
 output [24:0] sif_alarm_data;
 input  sif_alarm_ready;
 output  sif_alarm_v;
 input  strap_hqm_16b_portids;
 input [7:0] strap_hqm_cmpl_sai;
 input [63:0] strap_hqm_csr_cp;
 input [63:0] strap_hqm_csr_rac;
 input [63:0] strap_hqm_csr_wac;
 input [15:0] strap_hqm_device_id;
 input [15:0] strap_hqm_do_serr_dstid;
 input  strap_hqm_do_serr_rs;
 input [7:0] strap_hqm_do_serr_sai;
 input  strap_hqm_do_serr_sairs_valid;
 input [2:0] strap_hqm_do_serr_tag;
 input [15:0] strap_hqm_err_sb_dstid;
 input [7:0] strap_hqm_err_sb_sai;
 input [7:0] strap_hqm_force_pok_sai_0;
 input [7:0] strap_hqm_force_pok_sai_1;
 input [15:0] strap_hqm_gpsb_srcid;
 input [7:0] strap_hqm_resetprep_ack_sai;
 input [7:0] strap_hqm_resetprep_sai_0;
 input [7:0] strap_hqm_resetprep_sai_1;
 input [7:0] strap_hqm_tx_sai;
 input  strap_no_mgmt_acks;
 input  system_cfg_req_down_read;
 input  system_cfg_req_down_write;
 input  system_cfg_rsp_down_ack;
 input  system_idle;
 input  system_reset_done;
 input  visa_str_chp_lsp_cmp_data;
 input  wd_clkreq;
 input [638:0] write_buffer_mstr;
 output  write_buffer_mstr_ready;
 input  write_buffer_mstr_v;
 // Output assigns 
endmodule // hqm_sip_aon_wrap
