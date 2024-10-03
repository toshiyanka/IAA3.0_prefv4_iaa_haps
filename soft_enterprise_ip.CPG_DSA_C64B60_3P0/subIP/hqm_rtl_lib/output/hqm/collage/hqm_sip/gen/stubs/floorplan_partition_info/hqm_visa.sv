module hqm_visa 
 #(
  parameter HQM_DTF_DATA_WIDTH = 64,
  parameter HQM_DTF_HEADER_WIDTH = 25,
  parameter HQM_DTF_TO_CNT_THRESHOLD = 1000,
  parameter HQM_DVP_USE_LEGACY_TIMESTAMP = 0,
  parameter HQM_DVP_USE_PUSH_SWD = 0,
  parameter HQM_TRIGFABWIDTH = 4
)
(
input     fvisa_frame_vcfn,
input     fvisa_serdata_vcfn,
input     fvisa_serstb_vcfn,
input    [8:0]  fvisa_startid0_vcfn,
input    [8:0]  fvisa_startid1_vcfn,
input    [8:0]  fvisa_startid2_vcfn,
input    [8:0]  fvisa_startid3_vcfn,
input     prim_freerun_clk,
input     powergood_rst_b,
input     visa_all_dis,
input     visa_customer_dis,
output   [7:0]  avisa_dbgbus0_vcfn,
output   [7:0]  avisa_dbgbus1_vcfn,
output   [7:0]  avisa_dbgbus2_vcfn,
output   [7:0]  avisa_dbgbus3_vcfn,
input    [679:0]  hqm_sif_visa,
input     pgcb_clk,
input    [23:0]  hqm_cdc_visa,
input    [23:0]  hqm_pgcbunit_visa,
input    [31:0]  hqm_pmsm_visa,
input     clk,
input    [29:0]  hqm_system_visa_str,
input     side_clk,
input     wd_clkreq,
input     hqm_cfg_master_clkreq_b,
input     side_rst_b,
input     prim_gated_rst_b,
input     hqm_gated_rst_b,
input     hqm_clk_rptr_rst_b,
input     hqm_pwrgood_rst_b,
input     prochot,
input    [31:0]  master_ctl,
input     pgcb_isol_en_b,
input     pgcb_isol_en,
input     pgcb_fet_en_b,
input     pgcb_fet_en_ack_b,
input     pgcb_fet_en_ack_b_sys,
input     pgcb_fet_en_ack_b_qed,
input     cdc_hqm_jta_force_clkreq,
input     cdc_hqm_jta_clkgate_ovrd,
input     hqm_fullrate_clk,
input    [259:0]  hqm_core_visa_str,
input     fscan_byprst_b,
input     fscan_rstbypen,
input     fscan_mode,
input     fdtf_clk,
input     fdtf_cry_clk,
input     fdtf_rst_b,
input     pma_safemode,
input     fdtf_survive_mode,
input    [1:0]  fdtf_fast_cnt_width,
input    [7:0]  fdtf_packetizer_mid,
input    [7:0]  fdtf_packetizer_cid,
output   [24:0]  adtf_dnstream_header,
output   [63:0]  adtf_dnstream_data,
output    adtf_dnstream_valid,
input     fdtf_upstream_credit,
input     fdtf_upstream_active,
input     fdtf_upstream_sync,
input     fdtf_serial_download_tsc,
input    [15:0]  fdtf_tsc_adjustment_strap,
input     fdtf_timestamp_valid,
input    [55:0]  fdtf_timestamp_value,
input     fdtf_force_ts,
input    [3:0]  ftrig_fabric_in,
output   [3:0]  atrig_fabric_in_ack,
output   [3:0]  atrig_fabric_out,
input    [3:0]  ftrig_fabric_out_ack,
input    [31:0]  dvp_paddr,
input    [2:0]  dvp_pprot,
input     dvp_psel,
input     dvp_penable,
input     dvp_pwrite,
input    [31:0]  dvp_pwdata,
input    [3:0]  dvp_pstrb,
output    dvp_pready,
output    dvp_pslverr,
output   [31:0]  dvp_prdata,
input     fdfx_powergood,
input     fdfx_earlyboot_debug_exit,
input     fdfx_policy_update,
input    [7:0]  fdfx_security_policy,
input    [7:0]  fdfx_debug_cap,
input     fdfx_debug_cap_valid
);

endmodule // hqm_visa
