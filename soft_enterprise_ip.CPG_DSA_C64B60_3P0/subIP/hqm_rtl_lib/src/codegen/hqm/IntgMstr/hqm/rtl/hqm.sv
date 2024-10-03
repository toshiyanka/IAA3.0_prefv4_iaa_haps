// RTL Generated using Collage

module hqm # (
    // Subsystem Parameters
    parameter HQM_DTF_DATA_WIDTH = 64,
    parameter HQM_DTF_HEADER_WIDTH = 25,
    parameter HQM_DTF_TO_CNT_THRESHOLD = 1000,
    parameter HQM_DVP_USE_LEGACY_TIMESTAMP = 0,
    parameter HQM_DVP_USE_PUSH_SWD = 0,
    parameter HQM_SBE_DATAWIDTH = 8,
    parameter HQM_SBE_NPQUEUEDEPTH = 4,
    parameter HQM_SBE_PARITY_REQUIRED = 1,
    parameter HQM_SBE_PCQUEUEDEPTH = 4,
    parameter HQM_SFI_RX_BCM_EN = 1,
    parameter HQM_SFI_RX_BLOCK_EARLY_VLD_EN = 1,
    parameter HQM_SFI_RX_D = 32,
    parameter HQM_SFI_RX_DATA_AUX_PARITY_EN = 1,
    parameter HQM_SFI_RX_DATA_CRD_GRAN = 4,
    parameter HQM_SFI_RX_DATA_INTERLEAVE = 0,
    parameter HQM_SFI_RX_DATA_LAYER_EN = 1,
    parameter HQM_SFI_RX_DATA_MAX_FC_VC = 1,
    parameter HQM_SFI_RX_DATA_PARITY_EN = 1,
    parameter HQM_SFI_RX_DATA_PASS_HDR = 0,
    parameter HQM_SFI_RX_DS = 1,
    parameter HQM_SFI_RX_ECRC_SUPPORT = 0,
    parameter HQM_SFI_RX_FATAL_EN = 0,
    parameter HQM_SFI_RX_FLIT_MODE_PREFIX_EN = 0,
    parameter HQM_SFI_RX_H = 32,
    parameter HQM_SFI_RX_HDR_DATA_SEP = 1,
    parameter HQM_SFI_RX_HDR_MAX_FC_VC = 1,
    parameter HQM_SFI_RX_HGRAN = 4,
    parameter HQM_SFI_RX_HPARITY = 1,
    parameter HQM_SFI_RX_IDE_SUPPORT = 0,
    parameter HQM_SFI_RX_M = 1,
    parameter HQM_SFI_RX_MAX_CRD_CNT_WIDTH = 12,
    parameter HQM_SFI_RX_MAX_HDR_WIDTH = 32,
    parameter HQM_SFI_RX_NDCRD = 4,
    parameter HQM_SFI_RX_NHCRD = 4,
    parameter HQM_SFI_RX_NUM_SHARED_POOLS = 0,
    parameter HQM_SFI_RX_PCIE_MERGED_SELECT = 0,
    parameter HQM_SFI_RX_PCIE_SHARED_SELECT = 0,
    parameter HQM_SFI_RX_RBN = 3,
    parameter HQM_SFI_RX_SHARED_CREDIT_EN = 0,
    parameter HQM_SFI_RX_SH_DATA_CRD_BLK_SZ = 1,
    parameter HQM_SFI_RX_SH_HDR_CRD_BLK_SZ = 1,
    parameter HQM_SFI_RX_TBN = 1,
    parameter HQM_SFI_RX_TX_CRD_REG = 1,
    parameter HQM_SFI_RX_VIRAL_EN = 0,
    parameter HQM_SFI_RX_VR = 0,
    parameter HQM_SFI_RX_VT = 0,
    parameter HQM_SFI_TX_BCM_EN = 1,
    parameter HQM_SFI_TX_BLOCK_EARLY_VLD_EN = 1,
    parameter HQM_SFI_TX_D = 32,
    parameter HQM_SFI_TX_DATA_AUX_PARITY_EN = 1,
    parameter HQM_SFI_TX_DATA_CRD_GRAN = 4,
    parameter HQM_SFI_TX_DATA_INTERLEAVE = 0,
    parameter HQM_SFI_TX_DATA_LAYER_EN = 1,
    parameter HQM_SFI_TX_DATA_MAX_FC_VC = 1,
    parameter HQM_SFI_TX_DATA_PARITY_EN = 1,
    parameter HQM_SFI_TX_DATA_PASS_HDR = 0,
    parameter HQM_SFI_TX_DS = 1,
    parameter HQM_SFI_TX_ECRC_SUPPORT = 0,
    parameter HQM_SFI_TX_FATAL_EN = 0,
    parameter HQM_SFI_TX_FLIT_MODE_PREFIX_EN = 0,
    parameter HQM_SFI_TX_H = 32,
    parameter HQM_SFI_TX_HDR_DATA_SEP = 1,
    parameter HQM_SFI_TX_HDR_MAX_FC_VC = 1,
    parameter HQM_SFI_TX_HGRAN = 4,
    parameter HQM_SFI_TX_HPARITY = 1,
    parameter HQM_SFI_TX_IDE_SUPPORT = 0,
    parameter HQM_SFI_TX_M = 1,
    parameter HQM_SFI_TX_MAX_CRD_CNT_WIDTH = 12,
    parameter HQM_SFI_TX_MAX_HDR_WIDTH = 32,
    parameter HQM_SFI_TX_NDCRD = 4,
    parameter HQM_SFI_TX_NHCRD = 4,
    parameter HQM_SFI_TX_NUM_SHARED_POOLS = 0,
    parameter HQM_SFI_TX_PCIE_MERGED_SELECT = 0,
    parameter HQM_SFI_TX_PCIE_SHARED_SELECT = 0,
    parameter HQM_SFI_TX_RBN = 1,
    parameter HQM_SFI_TX_SHARED_CREDIT_EN = 0,
    parameter HQM_SFI_TX_SH_DATA_CRD_BLK_SZ = 1,
    parameter HQM_SFI_TX_SH_HDR_CRD_BLK_SZ = 1,
    parameter HQM_SFI_TX_TBN = 3,
    parameter HQM_SFI_TX_TX_CRD_REG = 1,
    parameter HQM_SFI_TX_VIRAL_EN = 0,
    parameter HQM_SFI_TX_VR = 0,
    parameter HQM_SFI_TX_VT = 0,
    parameter HQM_TRIGFABWIDTH = 4,
    parameter HQM_TRIGGER_WIDTH = 3  ) (
    input logic   [15:0]  early_fuses,
    input logic           fdfx_sbparity_def,
    input logic           fdtf_force_ts,
    input logic           fdtf_serial_download_tsc,
    input logic           fdtf_timestamp_valid,
    input logic   [55:0]  fdtf_timestamp_value,
    input logic   [15:0]  fdtf_tsc_adjustment_strap,
    input logic           iosf_pgcb_clk,
    input logic           pgcb_clk,
    input logic           pgcb_tck,
    input logic           pm_hqm_adr_assert,
    input logic           prim_clk,
    input logic           prochot,
    input logic           strap_hqm_16b_portids,
    input logic   [7:0]   strap_hqm_cmpl_sai,
    input logic   [63:0]  strap_hqm_csr_cp,
    input logic   [63:0]  strap_hqm_csr_rac,
    input logic   [63:0]  strap_hqm_csr_wac,
    input logic   [15:0]  strap_hqm_device_id,
    input logic   [0:0]   strap_hqm_do_serr_rs,
    input logic   [7:0]   strap_hqm_do_serr_sai,
    input logic           strap_hqm_do_serr_sairs_valid,
    input logic   [2:0]   strap_hqm_do_serr_tag,
    input logic   [7:0]   strap_hqm_err_sb_sai,
    input logic   [7:0]   strap_hqm_force_pok_sai_0,
    input logic   [7:0]   strap_hqm_force_pok_sai_1,
    input logic   [7:0]   strap_hqm_resetprep_ack_sai,
    input logic   [7:0]   strap_hqm_resetprep_sai_0,
    input logic   [7:0]   strap_hqm_resetprep_sai_1,
    input logic   [7:0]   strap_hqm_tx_sai,
    input logic           strap_no_mgmt_acks,
    output logic          hqm_pm_adr_ack,
    output logic          ip_ready,
    output logic          reset_prep_ack,
    // Ports for Interface dvp_apb4
    input logic   [31:0]  dvp_paddr,
    input logic           dvp_penable,
    input logic   [2:0]   dvp_pprot,
    input logic           dvp_psel,
    input logic   [3:0]   dvp_pstrb,
    input logic   [31:0]  dvp_pwdata,
    input logic           dvp_pwrite,
    output logic  [31:0]  dvp_prdata,
    output logic          dvp_pready,
    output logic          dvp_pslverr,
    // Ports for Interface dvp_ctf
    input logic   [(HQM_TRIGFABWIDTH-1):0] ftrig_fabric_in,
    input logic   [(HQM_TRIGFABWIDTH-1):0] ftrig_fabric_out_ack,
    output logic  [(HQM_TRIGFABWIDTH-1):0] atrig_fabric_in_ack,
    output logic  [(HQM_TRIGFABWIDTH-1):0] atrig_fabric_out,
    // Ports for Interface dvp_dsp_inside
    input logic   [7:0]   fdfx_debug_cap,
    input logic           fdfx_debug_cap_valid,
    input logic           fdfx_earlyboot_debug_exit,
    input logic           fdfx_policy_update,
    input logic   [7:0]   fdfx_security_policy,
    // Ports for Interface dvp_dtf
    input logic           fdtf_upstream_active,
    input logic           fdtf_upstream_credit,
    input logic           fdtf_upstream_sync,
    output logic  [(HQM_DTF_DATA_WIDTH-1):0] adtf_dnstream_data,
    output logic  [(HQM_DTF_HEADER_WIDTH-1):0] adtf_dnstream_header,
    output logic          adtf_dnstream_valid,
    // Ports for Interface dvp_dtf_clock
    input logic           fdtf_clk,
    input logic           fdtf_cry_clk,
    // Ports for Interface dvp_dtf_misc
    input logic   [1:0]   fdtf_fast_cnt_width,
    input logic   [7:0]   fdtf_packetizer_cid,
    input logic   [7:0]   fdtf_packetizer_mid,
    input logic           fdtf_survive_mode,
    // Ports for Interface dvp_dtf_reset
    input logic           fdtf_rst_b,
    // Ports for Interface iosf_sideband
    input logic           gpsb_mnpcup,
    input logic           gpsb_mpccup,
    input logic   [2:0]   gpsb_side_ism_fabric,
    input logic           gpsb_teom,
    input logic           gpsb_tnpput,
    input logic           gpsb_tparity,
    input logic   [(HQM_SBE_DATAWIDTH-1):0] gpsb_tpayload,
    input logic           gpsb_tpcput,
    output logic          gpsb_meom,
    output logic          gpsb_mnpput,
    output logic          gpsb_mparity,
    output logic  [(HQM_SBE_DATAWIDTH-1):0] gpsb_mpayload,
    output logic          gpsb_mpcput,
    output logic  [2:0]   gpsb_side_ism_agent,
    output logic          gpsb_tnpcup,
    output logic          gpsb_tpccup,
    // Ports for Interface iosf_sideband_clock
    input logic           side_clk,
    // Ports for Interface iosf_sideband_idstraps
    input logic   [15:0]  strap_hqm_do_serr_dstid,
    input logic   [15:0]  strap_hqm_err_sb_dstid,
    input logic   [15:0]  strap_hqm_gpsb_srcid,
    // Ports for Interface iosf_sideband_pok
    output logic          side_pok,
    // Ports for Interface iosf_sideband_power
    input logic           side_clkack,
    output logic          side_clkreq,
    // Ports for Interface iosf_sideband_reset
    input logic           side_rst_b,
    // Ports for Interface iosf_sideband_wake
    input logic           side_pwrgate_pmc_wake,
    // Ports for Interface prim_clock_req_ack
    input logic           prim_clkack,
    output logic          prim_clkreq,
    // Ports for Interface prim_reset
    input logic           pma_safemode,
    input logic           powergood_rst_b,
    input logic           prim_pwrgate_pmc_wake,
    input logic           prim_rst_b,
    // Ports for Interface rtdr_iosfsb_ism
    input logic           rtdr_iosfsb_ism_capturedr,
    input logic           rtdr_iosfsb_ism_irdec,
    input logic           rtdr_iosfsb_ism_shiftdr,
    input logic           rtdr_iosfsb_ism_tdi,
    input logic           rtdr_iosfsb_ism_updatedr,
    output logic          rtdr_iosfsb_ism_tdo,
    // Ports for Interface rtdr_iosfsb_ism_clock
    input logic           rtdr_iosfsb_ism_tck,
    // Ports for Interface rtdr_iosfsb_ism_reset
    input logic           rtdr_iosfsb_ism_trst_b,
    // Ports for Interface rtdr_tapconfig
    input logic           rtdr_tapconfig_capturedr,
    input logic           rtdr_tapconfig_irdec,
    input logic           rtdr_tapconfig_shiftdr,
    input logic           rtdr_tapconfig_tdi,
    input logic           rtdr_tapconfig_updatedr,
    output logic          rtdr_tapconfig_tdo,
    // Ports for Interface rtdr_tapconfig_clock
    input logic           rtdr_tapconfig_tck,
    // Ports for Interface rtdr_tapconfig_reset
    input logic           rtdr_tapconfig_trst_b,
    // Ports for Interface rtdr_taptrigger
    input logic           rtdr_taptrigger_capturedr,
    input logic           rtdr_taptrigger_irdec,
    input logic           rtdr_taptrigger_shiftdr,
    input logic           rtdr_taptrigger_tdi,
    input logic           rtdr_taptrigger_updatedr,
    output logic          rtdr_taptrigger_tdo,
    // Ports for Interface rtdr_taptrigger_clock
    input logic           rtdr_taptrigger_tck,
    // Ports for Interface rtdr_taptrigger_reset
    input logic           rtdr_taptrigger_trst_b,
    // Ports for Interface scan
    input logic           fscan_byprst_b,
    input logic           fscan_clkungate,
    input logic           fscan_clkungate_syn,
    input logic           fscan_isol_ctrl,
    input logic           fscan_isol_lat_ctrl,
    input logic           fscan_latchclosed_b,
    input logic           fscan_latchopen,
    input logic           fscan_mode,
    input logic           fscan_ret_ctrl,
    input logic           fscan_rstbypen,
    input logic           fscan_shiften,
    // Ports for Interface scan_reset
    input logic           fdfx_powergood,
    // Ports for Interface sfi_rx_data
    input logic   [((HQM_SFI_RX_D*8)-1):0] sfi_rx_data,
    input logic           sfi_rx_data_aux_parity,
    input logic           sfi_rx_data_crd_rtn_block,
    input logic           sfi_rx_data_early_valid,
    input logic   [((HQM_SFI_RX_D/4)-1):0] sfi_rx_data_edb,
    input logic   [((HQM_SFI_RX_D/4)-1):0] sfi_rx_data_end,
    input logic   [((HQM_SFI_RX_DS*8)-1):0] sfi_rx_data_info_byte,
    input logic   [((HQM_SFI_RX_D/8)-1):0] sfi_rx_data_parity,
    input logic   [((HQM_SFI_RX_D/4)-1):0] sfi_rx_data_poison,
    input logic           sfi_rx_data_start,
    input logic           sfi_rx_data_valid,
    output logic          sfi_rx_data_block,
    output logic  [1:0]   sfi_rx_data_crd_rtn_fc_id,
    output logic          sfi_rx_data_crd_rtn_valid,
    output logic  [(HQM_SFI_RX_NDCRD-1):0] sfi_rx_data_crd_rtn_value,
    output logic  [4:0]   sfi_rx_data_crd_rtn_vc_id,
    // Ports for Interface sfi_rx_globals
    input logic           sfi_rx_txcon_req,
    output logic          sfi_rx_rx_empty,
    output logic          sfi_rx_rxcon_ack,
    output logic          sfi_rx_rxdiscon_nack,
    // Ports for Interface sfi_rx_header
    input logic           sfi_rx_hdr_crd_rtn_block,
    input logic           sfi_rx_hdr_early_valid,
    input logic   [((HQM_SFI_RX_M*16)-1):0] sfi_rx_hdr_info_bytes,
    input logic           sfi_rx_hdr_valid,
    input logic   [((HQM_SFI_RX_H*8)-1):0] sfi_rx_header,
    output logic          sfi_rx_hdr_block,
    output logic  [1:0]   sfi_rx_hdr_crd_rtn_fc_id,
    output logic          sfi_rx_hdr_crd_rtn_valid,
    output logic  [(HQM_SFI_RX_NHCRD-1):0] sfi_rx_hdr_crd_rtn_value,
    output logic  [4:0]   sfi_rx_hdr_crd_rtn_vc_id,
    // Ports for Interface sfi_tx_data
    input logic           sfi_tx_data_block,
    input logic   [1:0]   sfi_tx_data_crd_rtn_fc_id,
    input logic           sfi_tx_data_crd_rtn_valid,
    input logic   [(HQM_SFI_TX_NDCRD-1):0] sfi_tx_data_crd_rtn_value,
    input logic   [4:0]   sfi_tx_data_crd_rtn_vc_id,
    output logic  [((HQM_SFI_TX_D*8)-1):0] sfi_tx_data,
    output logic          sfi_tx_data_aux_parity,
    output logic          sfi_tx_data_crd_rtn_block,
    output logic          sfi_tx_data_early_valid,
    output logic  [((HQM_SFI_TX_D/4)-1):0] sfi_tx_data_edb,
    output logic  [((HQM_SFI_TX_D/4)-1):0] sfi_tx_data_end,
    output logic  [((HQM_SFI_TX_DS*8)-1):0] sfi_tx_data_info_byte,
    output logic  [((HQM_SFI_TX_D/8)-1):0] sfi_tx_data_parity,
    output logic  [((HQM_SFI_TX_D/4)-1):0] sfi_tx_data_poison,
    output logic          sfi_tx_data_start,
    output logic          sfi_tx_data_valid,
    // Ports for Interface sfi_tx_globals
    input logic           sfi_tx_rx_empty,
    input logic           sfi_tx_rxcon_ack,
    input logic           sfi_tx_rxdiscon_nack,
    output logic          sfi_tx_txcon_req,
    // Ports for Interface sfi_tx_header
    input logic           sfi_tx_hdr_block,
    input logic   [1:0]   sfi_tx_hdr_crd_rtn_fc_id,
    input logic           sfi_tx_hdr_crd_rtn_valid,
    input logic   [(HQM_SFI_TX_NHCRD-1):0] sfi_tx_hdr_crd_rtn_value,
    input logic   [4:0]   sfi_tx_hdr_crd_rtn_vc_id,
    output logic          sfi_tx_hdr_crd_rtn_block,
    output logic          sfi_tx_hdr_early_valid,
    output logic  [((HQM_SFI_TX_M*16)-1):0] sfi_tx_hdr_info_bytes,
    output logic          sfi_tx_hdr_valid,
    output logic  [((HQM_SFI_TX_H*8)-1):0] sfi_tx_header,
    // Ports for Interface viewpins_dig
    output logic          dig_view_out_0,
    output logic          dig_view_out_1
);


`ifndef INTEL_HIDE_INTEGRATION

// collage-pragma translate_off
  `ifdef INTEL_INST_ON
    `ifndef LINT_ON
      `ifndef VISA_ELABORATE
        `include "hqm_cra_vcccfn.sv" 
      `endif
    `endif
  `endif
// collage-pragma translate_on


   wire [2047:0] i_hqm_list_sel_mem_bcam_AW_bcam_2048x26_cmatch;
   wire [207:0] i_hqm_list_sel_mem_bcam_AW_bcam_2048x26_rdata;
   wire         i_hqm_list_sel_mem_rf_aqed_fid_cnt_pwr_enable_b_out;
   wire [16:0]  i_hqm_list_sel_mem_rf_aqed_fid_cnt_rdata;
   wire         i_hqm_list_sel_mem_rf_aqed_fifo_ap_aqed_pwr_enable_b_out;
   wire [44:0]  i_hqm_list_sel_mem_rf_aqed_fifo_ap_aqed_rdata;
   wire         i_hqm_list_sel_mem_rf_aqed_fifo_aqed_ap_enq_pwr_enable_b_out;
   wire [23:0]  i_hqm_list_sel_mem_rf_aqed_fifo_aqed_ap_enq_rdata;
   wire         i_hqm_list_sel_mem_rf_aqed_fifo_aqed_chp_sch_pwr_enable_b_out;
   wire [179:0] i_hqm_list_sel_mem_rf_aqed_fifo_aqed_chp_sch_rdata;
   wire         i_hqm_list_sel_mem_rf_aqed_fifo_freelist_return_pwr_enable_b_out;
   wire [31:0]  i_hqm_list_sel_mem_rf_aqed_fifo_freelist_return_rdata;
   wire         i_hqm_list_sel_mem_rf_aqed_fifo_lsp_aqed_cmp_pwr_enable_b_out;
   wire [34:0]  i_hqm_list_sel_mem_rf_aqed_fifo_lsp_aqed_cmp_rdata;
   wire         i_hqm_list_sel_mem_rf_aqed_fifo_qed_aqed_enq_fid_pwr_enable_b_out;
   wire [152:0] i_hqm_list_sel_mem_rf_aqed_fifo_qed_aqed_enq_fid_rdata;
   wire         i_hqm_list_sel_mem_rf_aqed_fifo_qed_aqed_enq_pwr_enable_b_out;
   wire [154:0] i_hqm_list_sel_mem_rf_aqed_fifo_qed_aqed_enq_rdata;
   wire         i_hqm_list_sel_mem_rf_aqed_ll_cnt_pri0_pwr_enable_b_out;
   wire [15:0]  i_hqm_list_sel_mem_rf_aqed_ll_cnt_pri0_rdata;
   wire         i_hqm_list_sel_mem_rf_aqed_ll_cnt_pri1_pwr_enable_b_out;
   wire [15:0]  i_hqm_list_sel_mem_rf_aqed_ll_cnt_pri1_rdata;
   wire         i_hqm_list_sel_mem_rf_aqed_ll_cnt_pri2_pwr_enable_b_out;
   wire [15:0]  i_hqm_list_sel_mem_rf_aqed_ll_cnt_pri2_rdata;
   wire         i_hqm_list_sel_mem_rf_aqed_ll_cnt_pri3_pwr_enable_b_out;
   wire [15:0]  i_hqm_list_sel_mem_rf_aqed_ll_cnt_pri3_rdata;
   wire         i_hqm_list_sel_mem_rf_aqed_ll_qe_hp_pri0_pwr_enable_b_out;
   wire [13:0]  i_hqm_list_sel_mem_rf_aqed_ll_qe_hp_pri0_rdata;
   wire         i_hqm_list_sel_mem_rf_aqed_ll_qe_hp_pri1_pwr_enable_b_out;
   wire [13:0]  i_hqm_list_sel_mem_rf_aqed_ll_qe_hp_pri1_rdata;
   wire         i_hqm_list_sel_mem_rf_aqed_ll_qe_hp_pri2_pwr_enable_b_out;
   wire [13:0]  i_hqm_list_sel_mem_rf_aqed_ll_qe_hp_pri2_rdata;
   wire         i_hqm_list_sel_mem_rf_aqed_ll_qe_hp_pri3_pwr_enable_b_out;
   wire [13:0]  i_hqm_list_sel_mem_rf_aqed_ll_qe_hp_pri3_rdata;
   wire         i_hqm_list_sel_mem_rf_aqed_ll_qe_tp_pri0_pwr_enable_b_out;
   wire [13:0]  i_hqm_list_sel_mem_rf_aqed_ll_qe_tp_pri0_rdata;
   wire         i_hqm_list_sel_mem_rf_aqed_ll_qe_tp_pri1_pwr_enable_b_out;
   wire [13:0]  i_hqm_list_sel_mem_rf_aqed_ll_qe_tp_pri1_rdata;
   wire         i_hqm_list_sel_mem_rf_aqed_ll_qe_tp_pri2_pwr_enable_b_out;
   wire [13:0]  i_hqm_list_sel_mem_rf_aqed_ll_qe_tp_pri2_rdata;
   wire         i_hqm_list_sel_mem_rf_aqed_ll_qe_tp_pri3_pwr_enable_b_out;
   wire [13:0]  i_hqm_list_sel_mem_rf_aqed_ll_qe_tp_pri3_rdata;
   wire         i_hqm_list_sel_mem_rf_aqed_lsp_deq_fifo_mem_pwr_enable_b_out;
   wire [8:0]   i_hqm_list_sel_mem_rf_aqed_lsp_deq_fifo_mem_rdata;
   wire         i_hqm_list_sel_mem_rf_aqed_qid2cqidix_pwr_enable_b_out;
   wire [527:0] i_hqm_list_sel_mem_rf_aqed_qid2cqidix_rdata;
   wire         i_hqm_list_sel_mem_rf_aqed_qid_cnt_pwr_enable_b_out;
   wire [14:0]  i_hqm_list_sel_mem_rf_aqed_qid_cnt_rdata;
   wire         i_hqm_list_sel_mem_rf_aqed_qid_fid_limit_pwr_enable_b_out;
   wire [13:0]  i_hqm_list_sel_mem_rf_aqed_qid_fid_limit_rdata;
   wire         i_hqm_list_sel_mem_rf_atm_cmp_fifo_mem_pwr_enable_b_out;
   wire [54:0]  i_hqm_list_sel_mem_rf_atm_cmp_fifo_mem_rdata;
   wire         i_hqm_list_sel_mem_rf_atm_fifo_ap_aqed_pwr_enable_b_out;
   wire [44:0]  i_hqm_list_sel_mem_rf_atm_fifo_ap_aqed_rdata;
   wire         i_hqm_list_sel_mem_rf_atm_fifo_aqed_ap_enq_pwr_enable_b_out;
   wire [23:0]  i_hqm_list_sel_mem_rf_atm_fifo_aqed_ap_enq_rdata;
   wire         i_hqm_list_sel_mem_rf_cfg_atm_qid_dpth_thrsh_mem_pwr_enable_b_out;
   wire [15:0]  i_hqm_list_sel_mem_rf_cfg_atm_qid_dpth_thrsh_mem_rdata;
   wire         i_hqm_list_sel_mem_rf_cfg_cq2priov_mem_pwr_enable_b_out;
   wire [32:0]  i_hqm_list_sel_mem_rf_cfg_cq2priov_mem_rdata;
   wire         i_hqm_list_sel_mem_rf_cfg_cq2priov_odd_mem_pwr_enable_b_out;
   wire [32:0]  i_hqm_list_sel_mem_rf_cfg_cq2priov_odd_mem_rdata;
   wire         i_hqm_list_sel_mem_rf_cfg_cq2qid_0_mem_pwr_enable_b_out;
   wire [28:0]  i_hqm_list_sel_mem_rf_cfg_cq2qid_0_mem_rdata;
   wire         i_hqm_list_sel_mem_rf_cfg_cq2qid_0_odd_mem_pwr_enable_b_out;
   wire [28:0]  i_hqm_list_sel_mem_rf_cfg_cq2qid_0_odd_mem_rdata;
   wire         i_hqm_list_sel_mem_rf_cfg_cq2qid_1_mem_pwr_enable_b_out;
   wire [28:0]  i_hqm_list_sel_mem_rf_cfg_cq2qid_1_mem_rdata;
   wire         i_hqm_list_sel_mem_rf_cfg_cq2qid_1_odd_mem_pwr_enable_b_out;
   wire [28:0]  i_hqm_list_sel_mem_rf_cfg_cq2qid_1_odd_mem_rdata;
   wire         i_hqm_list_sel_mem_rf_cfg_cq_ldb_inflight_limit_mem_pwr_enable_b_out;
   wire [13:0]  i_hqm_list_sel_mem_rf_cfg_cq_ldb_inflight_limit_mem_rdata;
   wire         i_hqm_list_sel_mem_rf_cfg_cq_ldb_inflight_threshold_mem_pwr_enable_b_out;
   wire [13:0]  i_hqm_list_sel_mem_rf_cfg_cq_ldb_inflight_threshold_mem_rdata;
   wire         i_hqm_list_sel_mem_rf_cfg_cq_ldb_token_depth_select_mem_pwr_enable_b_out;
   wire [4:0]   i_hqm_list_sel_mem_rf_cfg_cq_ldb_token_depth_select_mem_rdata;
   wire         i_hqm_list_sel_mem_rf_cfg_cq_ldb_wu_limit_mem_pwr_enable_b_out;
   wire [16:0]  i_hqm_list_sel_mem_rf_cfg_cq_ldb_wu_limit_mem_rdata;
   wire         i_hqm_list_sel_mem_rf_cfg_dir_qid_dpth_thrsh_mem_pwr_enable_b_out;
   wire [15:0]  i_hqm_list_sel_mem_rf_cfg_dir_qid_dpth_thrsh_mem_rdata;
   wire         i_hqm_list_sel_mem_rf_cfg_nalb_qid_dpth_thrsh_mem_pwr_enable_b_out;
   wire [15:0]  i_hqm_list_sel_mem_rf_cfg_nalb_qid_dpth_thrsh_mem_rdata;
   wire         i_hqm_list_sel_mem_rf_cfg_qid_aqed_active_limit_mem_pwr_enable_b_out;
   wire [12:0]  i_hqm_list_sel_mem_rf_cfg_qid_aqed_active_limit_mem_rdata;
   wire         i_hqm_list_sel_mem_rf_cfg_qid_ldb_inflight_limit_mem_pwr_enable_b_out;
   wire [12:0]  i_hqm_list_sel_mem_rf_cfg_qid_ldb_inflight_limit_mem_rdata;
   wire         i_hqm_list_sel_mem_rf_cfg_qid_ldb_qid2cqidix2_mem_pwr_enable_b_out;
   wire [527:0] i_hqm_list_sel_mem_rf_cfg_qid_ldb_qid2cqidix2_mem_rdata;
   wire         i_hqm_list_sel_mem_rf_cfg_qid_ldb_qid2cqidix_mem_pwr_enable_b_out;
   wire [527:0] i_hqm_list_sel_mem_rf_cfg_qid_ldb_qid2cqidix_mem_rdata;
   wire         i_hqm_list_sel_mem_rf_chp_lsp_cmp_rx_sync_fifo_mem_pwr_enable_b_out;
   wire [72:0]  i_hqm_list_sel_mem_rf_chp_lsp_cmp_rx_sync_fifo_mem_rdata;
   wire         i_hqm_list_sel_mem_rf_chp_lsp_token_rx_sync_fifo_mem_pwr_enable_b_out;
   wire [24:0]  i_hqm_list_sel_mem_rf_chp_lsp_token_rx_sync_fifo_mem_rdata;
   wire         i_hqm_list_sel_mem_rf_cq_atm_pri_arbindex_mem_pwr_enable_b_out;
   wire [95:0]  i_hqm_list_sel_mem_rf_cq_atm_pri_arbindex_mem_rdata;
   wire         i_hqm_list_sel_mem_rf_cq_dir_tot_sch_cnt_mem_pwr_enable_b_out;
   wire [65:0]  i_hqm_list_sel_mem_rf_cq_dir_tot_sch_cnt_mem_rdata;
   wire         i_hqm_list_sel_mem_rf_cq_ldb_inflight_count_mem_pwr_enable_b_out;
   wire [14:0]  i_hqm_list_sel_mem_rf_cq_ldb_inflight_count_mem_rdata;
   wire         i_hqm_list_sel_mem_rf_cq_ldb_token_count_mem_pwr_enable_b_out;
   wire [12:0]  i_hqm_list_sel_mem_rf_cq_ldb_token_count_mem_rdata;
   wire         i_hqm_list_sel_mem_rf_cq_ldb_tot_sch_cnt_mem_pwr_enable_b_out;
   wire [65:0]  i_hqm_list_sel_mem_rf_cq_ldb_tot_sch_cnt_mem_rdata;
   wire         i_hqm_list_sel_mem_rf_cq_ldb_wu_count_mem_pwr_enable_b_out;
   wire [18:0]  i_hqm_list_sel_mem_rf_cq_ldb_wu_count_mem_rdata;
   wire         i_hqm_list_sel_mem_rf_cq_nalb_pri_arbindex_mem_pwr_enable_b_out;
   wire [95:0]  i_hqm_list_sel_mem_rf_cq_nalb_pri_arbindex_mem_rdata;
   wire         i_hqm_list_sel_mem_rf_dir_enq_cnt_mem_pwr_enable_b_out;
   wire [16:0]  i_hqm_list_sel_mem_rf_dir_enq_cnt_mem_rdata;
   wire         i_hqm_list_sel_mem_rf_dir_tok_cnt_mem_pwr_enable_b_out;
   wire [12:0]  i_hqm_list_sel_mem_rf_dir_tok_cnt_mem_rdata;
   wire         i_hqm_list_sel_mem_rf_dir_tok_lim_mem_pwr_enable_b_out;
   wire [7:0]   i_hqm_list_sel_mem_rf_dir_tok_lim_mem_rdata;
   wire         i_hqm_list_sel_mem_rf_dp_lsp_enq_dir_rx_sync_fifo_mem_pwr_enable_b_out;
   wire [7:0]   i_hqm_list_sel_mem_rf_dp_lsp_enq_dir_rx_sync_fifo_mem_rdata;
   wire         i_hqm_list_sel_mem_rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_pwr_enable_b_out;
   wire [22:0]  i_hqm_list_sel_mem_rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_rdata;
   wire         i_hqm_list_sel_mem_rf_enq_nalb_fifo_mem_pwr_enable_b_out;
   wire [9:0]   i_hqm_list_sel_mem_rf_enq_nalb_fifo_mem_rdata;
   wire         i_hqm_list_sel_mem_rf_fid2cqqidix_pwr_enable_b_out;
   wire [11:0]  i_hqm_list_sel_mem_rf_fid2cqqidix_rdata;
   wire         i_hqm_list_sel_mem_rf_ldb_token_rtn_fifo_mem_pwr_enable_b_out;
   wire [24:0]  i_hqm_list_sel_mem_rf_ldb_token_rtn_fifo_mem_rdata;
   wire         i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin0_dup0_pwr_enable_b_out;
   wire [15:0]  i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin0_dup0_rdata;
   wire         i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin0_dup1_pwr_enable_b_out;
   wire [15:0]  i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin0_dup1_rdata;
   wire         i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin0_dup2_pwr_enable_b_out;
   wire [15:0]  i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin0_dup2_rdata;
   wire         i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin0_dup3_pwr_enable_b_out;
   wire [15:0]  i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin0_dup3_rdata;
   wire         i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin1_dup0_pwr_enable_b_out;
   wire [15:0]  i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin1_dup0_rdata;
   wire         i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin1_dup1_pwr_enable_b_out;
   wire [15:0]  i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin1_dup1_rdata;
   wire         i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin1_dup2_pwr_enable_b_out;
   wire [15:0]  i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin1_dup2_rdata;
   wire         i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin1_dup3_pwr_enable_b_out;
   wire [15:0]  i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin1_dup3_rdata;
   wire         i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin2_dup0_pwr_enable_b_out;
   wire [15:0]  i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin2_dup0_rdata;
   wire         i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin2_dup1_pwr_enable_b_out;
   wire [15:0]  i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin2_dup1_rdata;
   wire         i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin2_dup2_pwr_enable_b_out;
   wire [15:0]  i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin2_dup2_rdata;
   wire         i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin2_dup3_pwr_enable_b_out;
   wire [15:0]  i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin2_dup3_rdata;
   wire         i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin3_dup0_pwr_enable_b_out;
   wire [15:0]  i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin3_dup0_rdata;
   wire         i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin3_dup1_pwr_enable_b_out;
   wire [15:0]  i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin3_dup1_rdata;
   wire         i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin3_dup2_pwr_enable_b_out;
   wire [15:0]  i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin3_dup2_rdata;
   wire         i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin3_dup3_pwr_enable_b_out;
   wire [15:0]  i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin3_dup3_rdata;
   wire         i_hqm_list_sel_mem_rf_ll_enq_cnt_s_bin0_pwr_enable_b_out;
   wire [15:0]  i_hqm_list_sel_mem_rf_ll_enq_cnt_s_bin0_rdata;
   wire         i_hqm_list_sel_mem_rf_ll_enq_cnt_s_bin1_pwr_enable_b_out;
   wire [15:0]  i_hqm_list_sel_mem_rf_ll_enq_cnt_s_bin1_rdata;
   wire         i_hqm_list_sel_mem_rf_ll_enq_cnt_s_bin2_pwr_enable_b_out;
   wire [15:0]  i_hqm_list_sel_mem_rf_ll_enq_cnt_s_bin2_rdata;
   wire         i_hqm_list_sel_mem_rf_ll_enq_cnt_s_bin3_pwr_enable_b_out;
   wire [15:0]  i_hqm_list_sel_mem_rf_ll_enq_cnt_s_bin3_rdata;
   wire         i_hqm_list_sel_mem_rf_ll_rdylst_hp_bin0_pwr_enable_b_out;
   wire [13:0]  i_hqm_list_sel_mem_rf_ll_rdylst_hp_bin0_rdata;
   wire         i_hqm_list_sel_mem_rf_ll_rdylst_hp_bin1_pwr_enable_b_out;
   wire [13:0]  i_hqm_list_sel_mem_rf_ll_rdylst_hp_bin1_rdata;
   wire         i_hqm_list_sel_mem_rf_ll_rdylst_hp_bin2_pwr_enable_b_out;
   wire [13:0]  i_hqm_list_sel_mem_rf_ll_rdylst_hp_bin2_rdata;
   wire         i_hqm_list_sel_mem_rf_ll_rdylst_hp_bin3_pwr_enable_b_out;
   wire [13:0]  i_hqm_list_sel_mem_rf_ll_rdylst_hp_bin3_rdata;
   wire         i_hqm_list_sel_mem_rf_ll_rdylst_hpnxt_bin0_pwr_enable_b_out;
   wire [15:0]  i_hqm_list_sel_mem_rf_ll_rdylst_hpnxt_bin0_rdata;
   wire         i_hqm_list_sel_mem_rf_ll_rdylst_hpnxt_bin1_pwr_enable_b_out;
   wire [15:0]  i_hqm_list_sel_mem_rf_ll_rdylst_hpnxt_bin1_rdata;
   wire         i_hqm_list_sel_mem_rf_ll_rdylst_hpnxt_bin2_pwr_enable_b_out;
   wire [15:0]  i_hqm_list_sel_mem_rf_ll_rdylst_hpnxt_bin2_rdata;
   wire         i_hqm_list_sel_mem_rf_ll_rdylst_hpnxt_bin3_pwr_enable_b_out;
   wire [15:0]  i_hqm_list_sel_mem_rf_ll_rdylst_hpnxt_bin3_rdata;
   wire         i_hqm_list_sel_mem_rf_ll_rdylst_tp_bin0_pwr_enable_b_out;
   wire [13:0]  i_hqm_list_sel_mem_rf_ll_rdylst_tp_bin0_rdata;
   wire         i_hqm_list_sel_mem_rf_ll_rdylst_tp_bin1_pwr_enable_b_out;
   wire [13:0]  i_hqm_list_sel_mem_rf_ll_rdylst_tp_bin1_rdata;
   wire         i_hqm_list_sel_mem_rf_ll_rdylst_tp_bin2_pwr_enable_b_out;
   wire [13:0]  i_hqm_list_sel_mem_rf_ll_rdylst_tp_bin2_rdata;
   wire         i_hqm_list_sel_mem_rf_ll_rdylst_tp_bin3_pwr_enable_b_out;
   wire [13:0]  i_hqm_list_sel_mem_rf_ll_rdylst_tp_bin3_rdata;
   wire         i_hqm_list_sel_mem_rf_ll_rlst_cnt_pwr_enable_b_out;
   wire [55:0]  i_hqm_list_sel_mem_rf_ll_rlst_cnt_rdata;
   wire         i_hqm_list_sel_mem_rf_ll_sch_cnt_dup0_pwr_enable_b_out;
   wire [16:0]  i_hqm_list_sel_mem_rf_ll_sch_cnt_dup0_rdata;
   wire         i_hqm_list_sel_mem_rf_ll_sch_cnt_dup1_pwr_enable_b_out;
   wire [16:0]  i_hqm_list_sel_mem_rf_ll_sch_cnt_dup1_rdata;
   wire         i_hqm_list_sel_mem_rf_ll_sch_cnt_dup2_pwr_enable_b_out;
   wire [16:0]  i_hqm_list_sel_mem_rf_ll_sch_cnt_dup2_rdata;
   wire         i_hqm_list_sel_mem_rf_ll_sch_cnt_dup3_pwr_enable_b_out;
   wire [16:0]  i_hqm_list_sel_mem_rf_ll_sch_cnt_dup3_rdata;
   wire         i_hqm_list_sel_mem_rf_ll_schlst_hp_bin0_pwr_enable_b_out;
   wire [13:0]  i_hqm_list_sel_mem_rf_ll_schlst_hp_bin0_rdata;
   wire         i_hqm_list_sel_mem_rf_ll_schlst_hp_bin1_pwr_enable_b_out;
   wire [13:0]  i_hqm_list_sel_mem_rf_ll_schlst_hp_bin1_rdata;
   wire         i_hqm_list_sel_mem_rf_ll_schlst_hp_bin2_pwr_enable_b_out;
   wire [13:0]  i_hqm_list_sel_mem_rf_ll_schlst_hp_bin2_rdata;
   wire         i_hqm_list_sel_mem_rf_ll_schlst_hp_bin3_pwr_enable_b_out;
   wire [13:0]  i_hqm_list_sel_mem_rf_ll_schlst_hp_bin3_rdata;
   wire         i_hqm_list_sel_mem_rf_ll_schlst_hpnxt_bin0_pwr_enable_b_out;
   wire [15:0]  i_hqm_list_sel_mem_rf_ll_schlst_hpnxt_bin0_rdata;
   wire         i_hqm_list_sel_mem_rf_ll_schlst_hpnxt_bin1_pwr_enable_b_out;
   wire [15:0]  i_hqm_list_sel_mem_rf_ll_schlst_hpnxt_bin1_rdata;
   wire         i_hqm_list_sel_mem_rf_ll_schlst_hpnxt_bin2_pwr_enable_b_out;
   wire [15:0]  i_hqm_list_sel_mem_rf_ll_schlst_hpnxt_bin2_rdata;
   wire         i_hqm_list_sel_mem_rf_ll_schlst_hpnxt_bin3_pwr_enable_b_out;
   wire [15:0]  i_hqm_list_sel_mem_rf_ll_schlst_hpnxt_bin3_rdata;
   wire         i_hqm_list_sel_mem_rf_ll_schlst_tp_bin0_pwr_enable_b_out;
   wire [13:0]  i_hqm_list_sel_mem_rf_ll_schlst_tp_bin0_rdata;
   wire         i_hqm_list_sel_mem_rf_ll_schlst_tp_bin1_pwr_enable_b_out;
   wire [13:0]  i_hqm_list_sel_mem_rf_ll_schlst_tp_bin1_rdata;
   wire         i_hqm_list_sel_mem_rf_ll_schlst_tp_bin2_pwr_enable_b_out;
   wire [13:0]  i_hqm_list_sel_mem_rf_ll_schlst_tp_bin2_rdata;
   wire         i_hqm_list_sel_mem_rf_ll_schlst_tp_bin3_pwr_enable_b_out;
   wire [13:0]  i_hqm_list_sel_mem_rf_ll_schlst_tp_bin3_rdata;
   wire         i_hqm_list_sel_mem_rf_ll_schlst_tpprv_bin0_pwr_enable_b_out;
   wire [15:0]  i_hqm_list_sel_mem_rf_ll_schlst_tpprv_bin0_rdata;
   wire         i_hqm_list_sel_mem_rf_ll_schlst_tpprv_bin1_pwr_enable_b_out;
   wire [15:0]  i_hqm_list_sel_mem_rf_ll_schlst_tpprv_bin1_rdata;
   wire         i_hqm_list_sel_mem_rf_ll_schlst_tpprv_bin2_pwr_enable_b_out;
   wire [15:0]  i_hqm_list_sel_mem_rf_ll_schlst_tpprv_bin2_rdata;
   wire         i_hqm_list_sel_mem_rf_ll_schlst_tpprv_bin3_pwr_enable_b_out;
   wire [15:0]  i_hqm_list_sel_mem_rf_ll_schlst_tpprv_bin3_rdata;
   wire         i_hqm_list_sel_mem_rf_ll_slst_cnt_pwr_enable_b_out;
   wire [59:0]  i_hqm_list_sel_mem_rf_ll_slst_cnt_rdata;
   wire         i_hqm_list_sel_mem_rf_nalb_cmp_fifo_mem_pwr_enable_b_out;
   wire [17:0]  i_hqm_list_sel_mem_rf_nalb_cmp_fifo_mem_rdata;
   wire         i_hqm_list_sel_mem_rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_pwr_enable_b_out;
   wire [9:0]   i_hqm_list_sel_mem_rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_rdata;
   wire         i_hqm_list_sel_mem_rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_pwr_enable_b_out;
   wire [26:0]  i_hqm_list_sel_mem_rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_rdata;
   wire         i_hqm_list_sel_mem_rf_nalb_sel_nalb_fifo_mem_pwr_enable_b_out;
   wire [26:0]  i_hqm_list_sel_mem_rf_nalb_sel_nalb_fifo_mem_rdata;
   wire         i_hqm_list_sel_mem_rf_qed_lsp_deq_fifo_mem_pwr_enable_b_out;
   wire [8:0]   i_hqm_list_sel_mem_rf_qed_lsp_deq_fifo_mem_rdata;
   wire         i_hqm_list_sel_mem_rf_qid_aqed_active_count_mem_pwr_enable_b_out;
   wire [13:0]  i_hqm_list_sel_mem_rf_qid_aqed_active_count_mem_rdata;
   wire         i_hqm_list_sel_mem_rf_qid_atm_active_mem_pwr_enable_b_out;
   wire [16:0]  i_hqm_list_sel_mem_rf_qid_atm_active_mem_rdata;
   wire         i_hqm_list_sel_mem_rf_qid_atm_tot_enq_cnt_mem_pwr_enable_b_out;
   wire [65:0]  i_hqm_list_sel_mem_rf_qid_atm_tot_enq_cnt_mem_rdata;
   wire         i_hqm_list_sel_mem_rf_qid_atq_enqueue_count_mem_pwr_enable_b_out;
   wire [16:0]  i_hqm_list_sel_mem_rf_qid_atq_enqueue_count_mem_rdata;
   wire         i_hqm_list_sel_mem_rf_qid_dir_max_depth_mem_pwr_enable_b_out;
   wire [14:0]  i_hqm_list_sel_mem_rf_qid_dir_max_depth_mem_rdata;
   wire         i_hqm_list_sel_mem_rf_qid_dir_replay_count_mem_pwr_enable_b_out;
   wire [16:0]  i_hqm_list_sel_mem_rf_qid_dir_replay_count_mem_rdata;
   wire         i_hqm_list_sel_mem_rf_qid_dir_tot_enq_cnt_mem_pwr_enable_b_out;
   wire [65:0]  i_hqm_list_sel_mem_rf_qid_dir_tot_enq_cnt_mem_rdata;
   wire         i_hqm_list_sel_mem_rf_qid_ldb_enqueue_count_mem_pwr_enable_b_out;
   wire [16:0]  i_hqm_list_sel_mem_rf_qid_ldb_enqueue_count_mem_rdata;
   wire         i_hqm_list_sel_mem_rf_qid_ldb_inflight_count_mem_pwr_enable_b_out;
   wire [13:0]  i_hqm_list_sel_mem_rf_qid_ldb_inflight_count_mem_rdata;
   wire         i_hqm_list_sel_mem_rf_qid_ldb_replay_count_mem_pwr_enable_b_out;
   wire [16:0]  i_hqm_list_sel_mem_rf_qid_ldb_replay_count_mem_rdata;
   wire         i_hqm_list_sel_mem_rf_qid_naldb_max_depth_mem_pwr_enable_b_out;
   wire [14:0]  i_hqm_list_sel_mem_rf_qid_naldb_max_depth_mem_rdata;
   wire         i_hqm_list_sel_mem_rf_qid_naldb_tot_enq_cnt_mem_pwr_enable_b_out;
   wire [65:0]  i_hqm_list_sel_mem_rf_qid_naldb_tot_enq_cnt_mem_rdata;
   wire         i_hqm_list_sel_mem_rf_qid_rdylst_clamp_pwr_enable_b_out;
   wire [5:0]   i_hqm_list_sel_mem_rf_qid_rdylst_clamp_rdata;
   wire         i_hqm_list_sel_mem_rf_rop_lsp_reordercmp_rx_sync_fifo_mem_pwr_enable_b_out;
   wire [16:0]  i_hqm_list_sel_mem_rf_rop_lsp_reordercmp_rx_sync_fifo_mem_rdata;
   wire         i_hqm_list_sel_mem_rf_rx_sync_qed_aqed_enq_pwr_enable_b_out;
   wire [138:0] i_hqm_list_sel_mem_rf_rx_sync_qed_aqed_enq_rdata;
   wire         i_hqm_list_sel_mem_rf_send_atm_to_cq_rx_sync_fifo_mem_pwr_enable_b_out;
   wire [34:0]  i_hqm_list_sel_mem_rf_send_atm_to_cq_rx_sync_fifo_mem_rdata;
   wire         i_hqm_list_sel_mem_rf_uno_atm_cmp_fifo_mem_pwr_enable_b_out;
   wire [19:0]  i_hqm_list_sel_mem_rf_uno_atm_cmp_fifo_mem_rdata;
   wire         i_hqm_list_sel_mem_sr_aqed_freelist_pwr_enable_b_out;
   wire [15:0]  i_hqm_list_sel_mem_sr_aqed_freelist_rdata;
   wire         i_hqm_list_sel_mem_sr_aqed_ll_qe_hpnxt_pwr_enable_b_out;
   wire [15:0]  i_hqm_list_sel_mem_sr_aqed_ll_qe_hpnxt_rdata;
   wire         i_hqm_list_sel_mem_sr_aqed_pwr_enable_b_out;
   wire [138:0] i_hqm_list_sel_mem_sr_aqed_rdata;
   wire         i_hqm_qed_mem_rf_atq_cnt_pwr_enable_b_out;
   wire [67:0]  i_hqm_qed_mem_rf_atq_cnt_rdata;
   wire         i_hqm_qed_mem_rf_atq_hp_pwr_enable_b_out;
   wire [14:0]  i_hqm_qed_mem_rf_atq_hp_rdata;
   wire         i_hqm_qed_mem_rf_atq_tp_pwr_enable_b_out;
   wire [14:0]  i_hqm_qed_mem_rf_atq_tp_rdata;
   wire         i_hqm_qed_mem_rf_dir_cnt_pwr_enable_b_out;
   wire [67:0]  i_hqm_qed_mem_rf_dir_cnt_rdata;
   wire         i_hqm_qed_mem_rf_dir_hp_pwr_enable_b_out;
   wire [14:0]  i_hqm_qed_mem_rf_dir_hp_rdata;
   wire         i_hqm_qed_mem_rf_dir_replay_cnt_pwr_enable_b_out;
   wire [67:0]  i_hqm_qed_mem_rf_dir_replay_cnt_rdata;
   wire         i_hqm_qed_mem_rf_dir_replay_hp_pwr_enable_b_out;
   wire [14:0]  i_hqm_qed_mem_rf_dir_replay_hp_rdata;
   wire         i_hqm_qed_mem_rf_dir_replay_tp_pwr_enable_b_out;
   wire [14:0]  i_hqm_qed_mem_rf_dir_replay_tp_rdata;
   wire         i_hqm_qed_mem_rf_dir_rofrag_cnt_pwr_enable_b_out;
   wire [16:0]  i_hqm_qed_mem_rf_dir_rofrag_cnt_rdata;
   wire         i_hqm_qed_mem_rf_dir_rofrag_hp_pwr_enable_b_out;
   wire [14:0]  i_hqm_qed_mem_rf_dir_rofrag_hp_rdata;
   wire         i_hqm_qed_mem_rf_dir_rofrag_tp_pwr_enable_b_out;
   wire [14:0]  i_hqm_qed_mem_rf_dir_rofrag_tp_rdata;
   wire         i_hqm_qed_mem_rf_dir_tp_pwr_enable_b_out;
   wire [14:0]  i_hqm_qed_mem_rf_dir_tp_rdata;
   wire         i_hqm_qed_mem_rf_dp_dqed_pwr_enable_b_out;
   wire [44:0]  i_hqm_qed_mem_rf_dp_dqed_rdata;
   wire         i_hqm_qed_mem_rf_dp_lsp_enq_dir_pwr_enable_b_out;
   wire [7:0]   i_hqm_qed_mem_rf_dp_lsp_enq_dir_rdata;
   wire         i_hqm_qed_mem_rf_dp_lsp_enq_rorply_pwr_enable_b_out;
   wire [22:0]  i_hqm_qed_mem_rf_dp_lsp_enq_rorply_rdata;
   wire         i_hqm_qed_mem_rf_lsp_dp_sch_dir_pwr_enable_b_out;
   wire [26:0]  i_hqm_qed_mem_rf_lsp_dp_sch_dir_rdata;
   wire         i_hqm_qed_mem_rf_lsp_dp_sch_rorply_pwr_enable_b_out;
   wire [7:0]   i_hqm_qed_mem_rf_lsp_dp_sch_rorply_rdata;
   wire         i_hqm_qed_mem_rf_lsp_nalb_sch_atq_pwr_enable_b_out;
   wire [7:0]   i_hqm_qed_mem_rf_lsp_nalb_sch_atq_rdata;
   wire         i_hqm_qed_mem_rf_lsp_nalb_sch_rorply_pwr_enable_b_out;
   wire [7:0]   i_hqm_qed_mem_rf_lsp_nalb_sch_rorply_rdata;
   wire         i_hqm_qed_mem_rf_lsp_nalb_sch_unoord_pwr_enable_b_out;
   wire [26:0]  i_hqm_qed_mem_rf_lsp_nalb_sch_unoord_rdata;
   wire         i_hqm_qed_mem_rf_nalb_cnt_pwr_enable_b_out;
   wire [67:0]  i_hqm_qed_mem_rf_nalb_cnt_rdata;
   wire         i_hqm_qed_mem_rf_nalb_hp_pwr_enable_b_out;
   wire [14:0]  i_hqm_qed_mem_rf_nalb_hp_rdata;
   wire         i_hqm_qed_mem_rf_nalb_lsp_enq_rorply_pwr_enable_b_out;
   wire [26:0]  i_hqm_qed_mem_rf_nalb_lsp_enq_rorply_rdata;
   wire         i_hqm_qed_mem_rf_nalb_lsp_enq_unoord_pwr_enable_b_out;
   wire [9:0]   i_hqm_qed_mem_rf_nalb_lsp_enq_unoord_rdata;
   wire         i_hqm_qed_mem_rf_nalb_qed_pwr_enable_b_out;
   wire [44:0]  i_hqm_qed_mem_rf_nalb_qed_rdata;
   wire         i_hqm_qed_mem_rf_nalb_replay_cnt_pwr_enable_b_out;
   wire [67:0]  i_hqm_qed_mem_rf_nalb_replay_cnt_rdata;
   wire         i_hqm_qed_mem_rf_nalb_replay_hp_pwr_enable_b_out;
   wire [14:0]  i_hqm_qed_mem_rf_nalb_replay_hp_rdata;
   wire         i_hqm_qed_mem_rf_nalb_replay_tp_pwr_enable_b_out;
   wire [14:0]  i_hqm_qed_mem_rf_nalb_replay_tp_rdata;
   wire         i_hqm_qed_mem_rf_nalb_rofrag_cnt_pwr_enable_b_out;
   wire [16:0]  i_hqm_qed_mem_rf_nalb_rofrag_cnt_rdata;
   wire         i_hqm_qed_mem_rf_nalb_rofrag_hp_pwr_enable_b_out;
   wire [14:0]  i_hqm_qed_mem_rf_nalb_rofrag_hp_rdata;
   wire         i_hqm_qed_mem_rf_nalb_rofrag_tp_pwr_enable_b_out;
   wire [14:0]  i_hqm_qed_mem_rf_nalb_rofrag_tp_rdata;
   wire         i_hqm_qed_mem_rf_nalb_tp_pwr_enable_b_out;
   wire [14:0]  i_hqm_qed_mem_rf_nalb_tp_rdata;
   wire         i_hqm_qed_mem_rf_qed_chp_sch_data_pwr_enable_b_out;
   wire [176:0] i_hqm_qed_mem_rf_qed_chp_sch_data_rdata;
   wire         i_hqm_qed_mem_rf_rop_dp_enq_dir_pwr_enable_b_out;
   wire [99:0]  i_hqm_qed_mem_rf_rop_dp_enq_dir_rdata;
   wire         i_hqm_qed_mem_rf_rop_dp_enq_ro_pwr_enable_b_out;
   wire [99:0]  i_hqm_qed_mem_rf_rop_dp_enq_ro_rdata;
   wire         i_hqm_qed_mem_rf_rop_nalb_enq_ro_pwr_enable_b_out;
   wire [99:0]  i_hqm_qed_mem_rf_rop_nalb_enq_ro_rdata;
   wire         i_hqm_qed_mem_rf_rop_nalb_enq_unoord_pwr_enable_b_out;
   wire [99:0]  i_hqm_qed_mem_rf_rop_nalb_enq_unoord_rdata;
   wire         i_hqm_qed_mem_rf_rx_sync_dp_dqed_data_pwr_enable_b_out;
   wire [44:0]  i_hqm_qed_mem_rf_rx_sync_dp_dqed_data_rdata;
   wire         i_hqm_qed_mem_rf_rx_sync_lsp_dp_sch_dir_pwr_enable_b_out;
   wire [26:0]  i_hqm_qed_mem_rf_rx_sync_lsp_dp_sch_dir_rdata;
   wire         i_hqm_qed_mem_rf_rx_sync_lsp_dp_sch_rorply_pwr_enable_b_out;
   wire [7:0]   i_hqm_qed_mem_rf_rx_sync_lsp_dp_sch_rorply_rdata;
   wire         i_hqm_qed_mem_rf_rx_sync_lsp_nalb_sch_atq_pwr_enable_b_out;
   wire [7:0]   i_hqm_qed_mem_rf_rx_sync_lsp_nalb_sch_atq_rdata;
   wire         i_hqm_qed_mem_rf_rx_sync_lsp_nalb_sch_rorply_pwr_enable_b_out;
   wire [7:0]   i_hqm_qed_mem_rf_rx_sync_lsp_nalb_sch_rorply_rdata;
   wire         i_hqm_qed_mem_rf_rx_sync_lsp_nalb_sch_unoord_pwr_enable_b_out;
   wire [26:0]  i_hqm_qed_mem_rf_rx_sync_lsp_nalb_sch_unoord_rdata;
   wire         i_hqm_qed_mem_rf_rx_sync_nalb_qed_data_pwr_enable_b_out;
   wire [44:0]  i_hqm_qed_mem_rf_rx_sync_nalb_qed_data_rdata;
   wire         i_hqm_qed_mem_rf_rx_sync_rop_dp_enq_pwr_enable_b_out;
   wire [99:0]  i_hqm_qed_mem_rf_rx_sync_rop_dp_enq_rdata;
   wire         i_hqm_qed_mem_rf_rx_sync_rop_nalb_enq_pwr_enable_b_out;
   wire [99:0]  i_hqm_qed_mem_rf_rx_sync_rop_nalb_enq_rdata;
   wire         i_hqm_qed_mem_rf_rx_sync_rop_qed_dqed_enq_pwr_enable_b_out;
   wire [156:0] i_hqm_qed_mem_rf_rx_sync_rop_qed_dqed_enq_rdata;
   wire         i_hqm_qed_mem_sr_dir_nxthp_pwr_enable_b_out;
   wire [20:0]  i_hqm_qed_mem_sr_dir_nxthp_rdata;
   wire         i_hqm_qed_mem_sr_nalb_nxthp_pwr_enable_b_out;
   wire [20:0]  i_hqm_qed_mem_sr_nalb_nxthp_rdata;
   wire         i_hqm_qed_mem_sr_qed_0_pwr_enable_b_out;
   wire [138:0] i_hqm_qed_mem_sr_qed_0_rdata;
   wire         i_hqm_qed_mem_sr_qed_1_pwr_enable_b_out;
   wire [138:0] i_hqm_qed_mem_sr_qed_1_rdata;
   wire         i_hqm_qed_mem_sr_qed_2_pwr_enable_b_out;
   wire [138:0] i_hqm_qed_mem_sr_qed_2_rdata;
   wire         i_hqm_qed_mem_sr_qed_3_pwr_enable_b_out;
   wire [138:0] i_hqm_qed_mem_sr_qed_3_rdata;
   wire         i_hqm_qed_mem_sr_qed_4_pwr_enable_b_out;
   wire [138:0] i_hqm_qed_mem_sr_qed_4_rdata;
   wire         i_hqm_qed_mem_sr_qed_5_pwr_enable_b_out;
   wire [138:0] i_hqm_qed_mem_sr_qed_5_rdata;
   wire         i_hqm_qed_mem_sr_qed_6_pwr_enable_b_out;
   wire [138:0] i_hqm_qed_mem_sr_qed_6_rdata;
   wire         i_hqm_qed_mem_sr_qed_7_pwr_enable_b_out;
   wire [138:0] i_hqm_qed_mem_sr_qed_7_rdata;
   wire         i_hqm_sip_bcam_AW_bcam_2048x26_cclk;
   wire [207:0] i_hqm_sip_bcam_AW_bcam_2048x26_cdata;
   wire [7:0]   i_hqm_sip_bcam_AW_bcam_2048x26_ce;
   wire         i_hqm_sip_bcam_AW_bcam_2048x26_dfx_clk;
   wire [7:0]   i_hqm_sip_bcam_AW_bcam_2048x26_raddr;
   wire         i_hqm_sip_bcam_AW_bcam_2048x26_rclk;
   wire         i_hqm_sip_bcam_AW_bcam_2048x26_re;
   wire [63:0]  i_hqm_sip_bcam_AW_bcam_2048x26_waddr;
   wire         i_hqm_sip_bcam_AW_bcam_2048x26_wclk;
   wire [207:0] i_hqm_sip_bcam_AW_bcam_2048x26_wdata;
   wire [7:0]   i_hqm_sip_bcam_AW_bcam_2048x26_we;
   wire         i_hqm_sip_hqm_pwrgood_rst_b;
   wire         i_hqm_sip_par_mem_pgcb_fet_en_b;
   wire         i_hqm_sip_pgcb_isol_en;
   wire         i_hqm_sip_pgcb_isol_en_b;
   wire [3:0]   i_hqm_sip_rf_alarm_vf_synd0_raddr;
   wire         i_hqm_sip_rf_alarm_vf_synd0_rclk;
   wire         i_hqm_sip_rf_alarm_vf_synd0_rclk_rst_n;
   wire         i_hqm_sip_rf_alarm_vf_synd0_re;
   wire [3:0]   i_hqm_sip_rf_alarm_vf_synd0_waddr;
   wire         i_hqm_sip_rf_alarm_vf_synd0_wclk;
   wire         i_hqm_sip_rf_alarm_vf_synd0_wclk_rst_n;
   wire [29:0]  i_hqm_sip_rf_alarm_vf_synd0_wdata;
   wire         i_hqm_sip_rf_alarm_vf_synd0_we;
   wire [3:0]   i_hqm_sip_rf_alarm_vf_synd1_raddr;
   wire         i_hqm_sip_rf_alarm_vf_synd1_rclk;
   wire         i_hqm_sip_rf_alarm_vf_synd1_rclk_rst_n;
   wire         i_hqm_sip_rf_alarm_vf_synd1_re;
   wire [3:0]   i_hqm_sip_rf_alarm_vf_synd1_waddr;
   wire         i_hqm_sip_rf_alarm_vf_synd1_wclk;
   wire         i_hqm_sip_rf_alarm_vf_synd1_wclk_rst_n;
   wire [31:0]  i_hqm_sip_rf_alarm_vf_synd1_wdata;
   wire         i_hqm_sip_rf_alarm_vf_synd1_we;
   wire [3:0]   i_hqm_sip_rf_alarm_vf_synd2_raddr;
   wire         i_hqm_sip_rf_alarm_vf_synd2_rclk;
   wire         i_hqm_sip_rf_alarm_vf_synd2_rclk_rst_n;
   wire         i_hqm_sip_rf_alarm_vf_synd2_re;
   wire [3:0]   i_hqm_sip_rf_alarm_vf_synd2_waddr;
   wire         i_hqm_sip_rf_alarm_vf_synd2_wclk;
   wire         i_hqm_sip_rf_alarm_vf_synd2_wclk_rst_n;
   wire [31:0]  i_hqm_sip_rf_alarm_vf_synd2_wdata;
   wire         i_hqm_sip_rf_alarm_vf_synd2_we;
   wire [1:0]   i_hqm_sip_rf_aqed_chp_sch_rx_sync_mem_raddr;
   wire         i_hqm_sip_rf_aqed_chp_sch_rx_sync_mem_rclk;
   wire         i_hqm_sip_rf_aqed_chp_sch_rx_sync_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_aqed_chp_sch_rx_sync_mem_re;
   wire [1:0]   i_hqm_sip_rf_aqed_chp_sch_rx_sync_mem_waddr;
   wire         i_hqm_sip_rf_aqed_chp_sch_rx_sync_mem_wclk;
   wire         i_hqm_sip_rf_aqed_chp_sch_rx_sync_mem_wclk_rst_n;
   wire [178:0] i_hqm_sip_rf_aqed_chp_sch_rx_sync_mem_wdata;
   wire         i_hqm_sip_rf_aqed_chp_sch_rx_sync_mem_we;
   wire [10:0]  i_hqm_sip_rf_aqed_fid_cnt_raddr;
   wire         i_hqm_sip_rf_aqed_fid_cnt_rclk;
   wire         i_hqm_sip_rf_aqed_fid_cnt_rclk_rst_n;
   wire         i_hqm_sip_rf_aqed_fid_cnt_re;
   wire [10:0]  i_hqm_sip_rf_aqed_fid_cnt_waddr;
   wire         i_hqm_sip_rf_aqed_fid_cnt_wclk;
   wire         i_hqm_sip_rf_aqed_fid_cnt_wclk_rst_n;
   wire [16:0]  i_hqm_sip_rf_aqed_fid_cnt_wdata;
   wire         i_hqm_sip_rf_aqed_fid_cnt_we;
   wire [3:0]   i_hqm_sip_rf_aqed_fifo_ap_aqed_raddr;
   wire         i_hqm_sip_rf_aqed_fifo_ap_aqed_rclk;
   wire         i_hqm_sip_rf_aqed_fifo_ap_aqed_rclk_rst_n;
   wire         i_hqm_sip_rf_aqed_fifo_ap_aqed_re;
   wire [3:0]   i_hqm_sip_rf_aqed_fifo_ap_aqed_waddr;
   wire         i_hqm_sip_rf_aqed_fifo_ap_aqed_wclk;
   wire         i_hqm_sip_rf_aqed_fifo_ap_aqed_wclk_rst_n;
   wire [44:0]  i_hqm_sip_rf_aqed_fifo_ap_aqed_wdata;
   wire         i_hqm_sip_rf_aqed_fifo_ap_aqed_we;
   wire [3:0]   i_hqm_sip_rf_aqed_fifo_aqed_ap_enq_raddr;
   wire         i_hqm_sip_rf_aqed_fifo_aqed_ap_enq_rclk;
   wire         i_hqm_sip_rf_aqed_fifo_aqed_ap_enq_rclk_rst_n;
   wire         i_hqm_sip_rf_aqed_fifo_aqed_ap_enq_re;
   wire [3:0]   i_hqm_sip_rf_aqed_fifo_aqed_ap_enq_waddr;
   wire         i_hqm_sip_rf_aqed_fifo_aqed_ap_enq_wclk;
   wire         i_hqm_sip_rf_aqed_fifo_aqed_ap_enq_wclk_rst_n;
   wire [23:0]  i_hqm_sip_rf_aqed_fifo_aqed_ap_enq_wdata;
   wire         i_hqm_sip_rf_aqed_fifo_aqed_ap_enq_we;
   wire [3:0]   i_hqm_sip_rf_aqed_fifo_aqed_chp_sch_raddr;
   wire         i_hqm_sip_rf_aqed_fifo_aqed_chp_sch_rclk;
   wire         i_hqm_sip_rf_aqed_fifo_aqed_chp_sch_rclk_rst_n;
   wire         i_hqm_sip_rf_aqed_fifo_aqed_chp_sch_re;
   wire [3:0]   i_hqm_sip_rf_aqed_fifo_aqed_chp_sch_waddr;
   wire         i_hqm_sip_rf_aqed_fifo_aqed_chp_sch_wclk;
   wire         i_hqm_sip_rf_aqed_fifo_aqed_chp_sch_wclk_rst_n;
   wire [179:0] i_hqm_sip_rf_aqed_fifo_aqed_chp_sch_wdata;
   wire         i_hqm_sip_rf_aqed_fifo_aqed_chp_sch_we;
   wire [3:0]   i_hqm_sip_rf_aqed_fifo_freelist_return_raddr;
   wire         i_hqm_sip_rf_aqed_fifo_freelist_return_rclk;
   wire         i_hqm_sip_rf_aqed_fifo_freelist_return_rclk_rst_n;
   wire         i_hqm_sip_rf_aqed_fifo_freelist_return_re;
   wire [3:0]   i_hqm_sip_rf_aqed_fifo_freelist_return_waddr;
   wire         i_hqm_sip_rf_aqed_fifo_freelist_return_wclk;
   wire         i_hqm_sip_rf_aqed_fifo_freelist_return_wclk_rst_n;
   wire [31:0]  i_hqm_sip_rf_aqed_fifo_freelist_return_wdata;
   wire         i_hqm_sip_rf_aqed_fifo_freelist_return_we;
   wire [3:0]   i_hqm_sip_rf_aqed_fifo_lsp_aqed_cmp_raddr;
   wire         i_hqm_sip_rf_aqed_fifo_lsp_aqed_cmp_rclk;
   wire         i_hqm_sip_rf_aqed_fifo_lsp_aqed_cmp_rclk_rst_n;
   wire         i_hqm_sip_rf_aqed_fifo_lsp_aqed_cmp_re;
   wire [3:0]   i_hqm_sip_rf_aqed_fifo_lsp_aqed_cmp_waddr;
   wire         i_hqm_sip_rf_aqed_fifo_lsp_aqed_cmp_wclk;
   wire         i_hqm_sip_rf_aqed_fifo_lsp_aqed_cmp_wclk_rst_n;
   wire [34:0]  i_hqm_sip_rf_aqed_fifo_lsp_aqed_cmp_wdata;
   wire         i_hqm_sip_rf_aqed_fifo_lsp_aqed_cmp_we;
   wire [2:0]   i_hqm_sip_rf_aqed_fifo_qed_aqed_enq_fid_raddr;
   wire         i_hqm_sip_rf_aqed_fifo_qed_aqed_enq_fid_rclk;
   wire         i_hqm_sip_rf_aqed_fifo_qed_aqed_enq_fid_rclk_rst_n;
   wire         i_hqm_sip_rf_aqed_fifo_qed_aqed_enq_fid_re;
   wire [2:0]   i_hqm_sip_rf_aqed_fifo_qed_aqed_enq_fid_waddr;
   wire         i_hqm_sip_rf_aqed_fifo_qed_aqed_enq_fid_wclk;
   wire         i_hqm_sip_rf_aqed_fifo_qed_aqed_enq_fid_wclk_rst_n;
   wire [152:0] i_hqm_sip_rf_aqed_fifo_qed_aqed_enq_fid_wdata;
   wire         i_hqm_sip_rf_aqed_fifo_qed_aqed_enq_fid_we;
   wire [1:0]   i_hqm_sip_rf_aqed_fifo_qed_aqed_enq_raddr;
   wire         i_hqm_sip_rf_aqed_fifo_qed_aqed_enq_rclk;
   wire         i_hqm_sip_rf_aqed_fifo_qed_aqed_enq_rclk_rst_n;
   wire         i_hqm_sip_rf_aqed_fifo_qed_aqed_enq_re;
   wire [1:0]   i_hqm_sip_rf_aqed_fifo_qed_aqed_enq_waddr;
   wire         i_hqm_sip_rf_aqed_fifo_qed_aqed_enq_wclk;
   wire         i_hqm_sip_rf_aqed_fifo_qed_aqed_enq_wclk_rst_n;
   wire [154:0] i_hqm_sip_rf_aqed_fifo_qed_aqed_enq_wdata;
   wire         i_hqm_sip_rf_aqed_fifo_qed_aqed_enq_we;
   wire [10:0]  i_hqm_sip_rf_aqed_ll_cnt_pri0_raddr;
   wire         i_hqm_sip_rf_aqed_ll_cnt_pri0_rclk;
   wire         i_hqm_sip_rf_aqed_ll_cnt_pri0_rclk_rst_n;
   wire         i_hqm_sip_rf_aqed_ll_cnt_pri0_re;
   wire [10:0]  i_hqm_sip_rf_aqed_ll_cnt_pri0_waddr;
   wire         i_hqm_sip_rf_aqed_ll_cnt_pri0_wclk;
   wire         i_hqm_sip_rf_aqed_ll_cnt_pri0_wclk_rst_n;
   wire [15:0]  i_hqm_sip_rf_aqed_ll_cnt_pri0_wdata;
   wire         i_hqm_sip_rf_aqed_ll_cnt_pri0_we;
   wire [10:0]  i_hqm_sip_rf_aqed_ll_cnt_pri1_raddr;
   wire         i_hqm_sip_rf_aqed_ll_cnt_pri1_rclk;
   wire         i_hqm_sip_rf_aqed_ll_cnt_pri1_rclk_rst_n;
   wire         i_hqm_sip_rf_aqed_ll_cnt_pri1_re;
   wire [10:0]  i_hqm_sip_rf_aqed_ll_cnt_pri1_waddr;
   wire         i_hqm_sip_rf_aqed_ll_cnt_pri1_wclk;
   wire         i_hqm_sip_rf_aqed_ll_cnt_pri1_wclk_rst_n;
   wire [15:0]  i_hqm_sip_rf_aqed_ll_cnt_pri1_wdata;
   wire         i_hqm_sip_rf_aqed_ll_cnt_pri1_we;
   wire [10:0]  i_hqm_sip_rf_aqed_ll_cnt_pri2_raddr;
   wire         i_hqm_sip_rf_aqed_ll_cnt_pri2_rclk;
   wire         i_hqm_sip_rf_aqed_ll_cnt_pri2_rclk_rst_n;
   wire         i_hqm_sip_rf_aqed_ll_cnt_pri2_re;
   wire [10:0]  i_hqm_sip_rf_aqed_ll_cnt_pri2_waddr;
   wire         i_hqm_sip_rf_aqed_ll_cnt_pri2_wclk;
   wire         i_hqm_sip_rf_aqed_ll_cnt_pri2_wclk_rst_n;
   wire [15:0]  i_hqm_sip_rf_aqed_ll_cnt_pri2_wdata;
   wire         i_hqm_sip_rf_aqed_ll_cnt_pri2_we;
   wire [10:0]  i_hqm_sip_rf_aqed_ll_cnt_pri3_raddr;
   wire         i_hqm_sip_rf_aqed_ll_cnt_pri3_rclk;
   wire         i_hqm_sip_rf_aqed_ll_cnt_pri3_rclk_rst_n;
   wire         i_hqm_sip_rf_aqed_ll_cnt_pri3_re;
   wire [10:0]  i_hqm_sip_rf_aqed_ll_cnt_pri3_waddr;
   wire         i_hqm_sip_rf_aqed_ll_cnt_pri3_wclk;
   wire         i_hqm_sip_rf_aqed_ll_cnt_pri3_wclk_rst_n;
   wire [15:0]  i_hqm_sip_rf_aqed_ll_cnt_pri3_wdata;
   wire         i_hqm_sip_rf_aqed_ll_cnt_pri3_we;
   wire [10:0]  i_hqm_sip_rf_aqed_ll_qe_hp_pri0_raddr;
   wire         i_hqm_sip_rf_aqed_ll_qe_hp_pri0_rclk;
   wire         i_hqm_sip_rf_aqed_ll_qe_hp_pri0_rclk_rst_n;
   wire         i_hqm_sip_rf_aqed_ll_qe_hp_pri0_re;
   wire [10:0]  i_hqm_sip_rf_aqed_ll_qe_hp_pri0_waddr;
   wire         i_hqm_sip_rf_aqed_ll_qe_hp_pri0_wclk;
   wire         i_hqm_sip_rf_aqed_ll_qe_hp_pri0_wclk_rst_n;
   wire [13:0]  i_hqm_sip_rf_aqed_ll_qe_hp_pri0_wdata;
   wire         i_hqm_sip_rf_aqed_ll_qe_hp_pri0_we;
   wire [10:0]  i_hqm_sip_rf_aqed_ll_qe_hp_pri1_raddr;
   wire         i_hqm_sip_rf_aqed_ll_qe_hp_pri1_rclk;
   wire         i_hqm_sip_rf_aqed_ll_qe_hp_pri1_rclk_rst_n;
   wire         i_hqm_sip_rf_aqed_ll_qe_hp_pri1_re;
   wire [10:0]  i_hqm_sip_rf_aqed_ll_qe_hp_pri1_waddr;
   wire         i_hqm_sip_rf_aqed_ll_qe_hp_pri1_wclk;
   wire         i_hqm_sip_rf_aqed_ll_qe_hp_pri1_wclk_rst_n;
   wire [13:0]  i_hqm_sip_rf_aqed_ll_qe_hp_pri1_wdata;
   wire         i_hqm_sip_rf_aqed_ll_qe_hp_pri1_we;
   wire [10:0]  i_hqm_sip_rf_aqed_ll_qe_hp_pri2_raddr;
   wire         i_hqm_sip_rf_aqed_ll_qe_hp_pri2_rclk;
   wire         i_hqm_sip_rf_aqed_ll_qe_hp_pri2_rclk_rst_n;
   wire         i_hqm_sip_rf_aqed_ll_qe_hp_pri2_re;
   wire [10:0]  i_hqm_sip_rf_aqed_ll_qe_hp_pri2_waddr;
   wire         i_hqm_sip_rf_aqed_ll_qe_hp_pri2_wclk;
   wire         i_hqm_sip_rf_aqed_ll_qe_hp_pri2_wclk_rst_n;
   wire [13:0]  i_hqm_sip_rf_aqed_ll_qe_hp_pri2_wdata;
   wire         i_hqm_sip_rf_aqed_ll_qe_hp_pri2_we;
   wire [10:0]  i_hqm_sip_rf_aqed_ll_qe_hp_pri3_raddr;
   wire         i_hqm_sip_rf_aqed_ll_qe_hp_pri3_rclk;
   wire         i_hqm_sip_rf_aqed_ll_qe_hp_pri3_rclk_rst_n;
   wire         i_hqm_sip_rf_aqed_ll_qe_hp_pri3_re;
   wire [10:0]  i_hqm_sip_rf_aqed_ll_qe_hp_pri3_waddr;
   wire         i_hqm_sip_rf_aqed_ll_qe_hp_pri3_wclk;
   wire         i_hqm_sip_rf_aqed_ll_qe_hp_pri3_wclk_rst_n;
   wire [13:0]  i_hqm_sip_rf_aqed_ll_qe_hp_pri3_wdata;
   wire         i_hqm_sip_rf_aqed_ll_qe_hp_pri3_we;
   wire [10:0]  i_hqm_sip_rf_aqed_ll_qe_tp_pri0_raddr;
   wire         i_hqm_sip_rf_aqed_ll_qe_tp_pri0_rclk;
   wire         i_hqm_sip_rf_aqed_ll_qe_tp_pri0_rclk_rst_n;
   wire         i_hqm_sip_rf_aqed_ll_qe_tp_pri0_re;
   wire [10:0]  i_hqm_sip_rf_aqed_ll_qe_tp_pri0_waddr;
   wire         i_hqm_sip_rf_aqed_ll_qe_tp_pri0_wclk;
   wire         i_hqm_sip_rf_aqed_ll_qe_tp_pri0_wclk_rst_n;
   wire [13:0]  i_hqm_sip_rf_aqed_ll_qe_tp_pri0_wdata;
   wire         i_hqm_sip_rf_aqed_ll_qe_tp_pri0_we;
   wire [10:0]  i_hqm_sip_rf_aqed_ll_qe_tp_pri1_raddr;
   wire         i_hqm_sip_rf_aqed_ll_qe_tp_pri1_rclk;
   wire         i_hqm_sip_rf_aqed_ll_qe_tp_pri1_rclk_rst_n;
   wire         i_hqm_sip_rf_aqed_ll_qe_tp_pri1_re;
   wire [10:0]  i_hqm_sip_rf_aqed_ll_qe_tp_pri1_waddr;
   wire         i_hqm_sip_rf_aqed_ll_qe_tp_pri1_wclk;
   wire         i_hqm_sip_rf_aqed_ll_qe_tp_pri1_wclk_rst_n;
   wire [13:0]  i_hqm_sip_rf_aqed_ll_qe_tp_pri1_wdata;
   wire         i_hqm_sip_rf_aqed_ll_qe_tp_pri1_we;
   wire [10:0]  i_hqm_sip_rf_aqed_ll_qe_tp_pri2_raddr;
   wire         i_hqm_sip_rf_aqed_ll_qe_tp_pri2_rclk;
   wire         i_hqm_sip_rf_aqed_ll_qe_tp_pri2_rclk_rst_n;
   wire         i_hqm_sip_rf_aqed_ll_qe_tp_pri2_re;
   wire [10:0]  i_hqm_sip_rf_aqed_ll_qe_tp_pri2_waddr;
   wire         i_hqm_sip_rf_aqed_ll_qe_tp_pri2_wclk;
   wire         i_hqm_sip_rf_aqed_ll_qe_tp_pri2_wclk_rst_n;
   wire [13:0]  i_hqm_sip_rf_aqed_ll_qe_tp_pri2_wdata;
   wire         i_hqm_sip_rf_aqed_ll_qe_tp_pri2_we;
   wire [10:0]  i_hqm_sip_rf_aqed_ll_qe_tp_pri3_raddr;
   wire         i_hqm_sip_rf_aqed_ll_qe_tp_pri3_rclk;
   wire         i_hqm_sip_rf_aqed_ll_qe_tp_pri3_rclk_rst_n;
   wire         i_hqm_sip_rf_aqed_ll_qe_tp_pri3_re;
   wire [10:0]  i_hqm_sip_rf_aqed_ll_qe_tp_pri3_waddr;
   wire         i_hqm_sip_rf_aqed_ll_qe_tp_pri3_wclk;
   wire         i_hqm_sip_rf_aqed_ll_qe_tp_pri3_wclk_rst_n;
   wire [13:0]  i_hqm_sip_rf_aqed_ll_qe_tp_pri3_wdata;
   wire         i_hqm_sip_rf_aqed_ll_qe_tp_pri3_we;
   wire [4:0]   i_hqm_sip_rf_aqed_lsp_deq_fifo_mem_raddr;
   wire         i_hqm_sip_rf_aqed_lsp_deq_fifo_mem_rclk;
   wire         i_hqm_sip_rf_aqed_lsp_deq_fifo_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_aqed_lsp_deq_fifo_mem_re;
   wire [4:0]   i_hqm_sip_rf_aqed_lsp_deq_fifo_mem_waddr;
   wire         i_hqm_sip_rf_aqed_lsp_deq_fifo_mem_wclk;
   wire         i_hqm_sip_rf_aqed_lsp_deq_fifo_mem_wclk_rst_n;
   wire [8:0]   i_hqm_sip_rf_aqed_lsp_deq_fifo_mem_wdata;
   wire         i_hqm_sip_rf_aqed_lsp_deq_fifo_mem_we;
   wire [4:0]   i_hqm_sip_rf_aqed_qid2cqidix_raddr;
   wire         i_hqm_sip_rf_aqed_qid2cqidix_rclk;
   wire         i_hqm_sip_rf_aqed_qid2cqidix_rclk_rst_n;
   wire         i_hqm_sip_rf_aqed_qid2cqidix_re;
   wire [4:0]   i_hqm_sip_rf_aqed_qid2cqidix_waddr;
   wire         i_hqm_sip_rf_aqed_qid2cqidix_wclk;
   wire         i_hqm_sip_rf_aqed_qid2cqidix_wclk_rst_n;
   wire [527:0] i_hqm_sip_rf_aqed_qid2cqidix_wdata;
   wire         i_hqm_sip_rf_aqed_qid2cqidix_we;
   wire [4:0]   i_hqm_sip_rf_aqed_qid_cnt_raddr;
   wire         i_hqm_sip_rf_aqed_qid_cnt_rclk;
   wire         i_hqm_sip_rf_aqed_qid_cnt_rclk_rst_n;
   wire         i_hqm_sip_rf_aqed_qid_cnt_re;
   wire [4:0]   i_hqm_sip_rf_aqed_qid_cnt_waddr;
   wire         i_hqm_sip_rf_aqed_qid_cnt_wclk;
   wire         i_hqm_sip_rf_aqed_qid_cnt_wclk_rst_n;
   wire [14:0]  i_hqm_sip_rf_aqed_qid_cnt_wdata;
   wire         i_hqm_sip_rf_aqed_qid_cnt_we;
   wire [4:0]   i_hqm_sip_rf_aqed_qid_fid_limit_raddr;
   wire         i_hqm_sip_rf_aqed_qid_fid_limit_rclk;
   wire         i_hqm_sip_rf_aqed_qid_fid_limit_rclk_rst_n;
   wire         i_hqm_sip_rf_aqed_qid_fid_limit_re;
   wire [4:0]   i_hqm_sip_rf_aqed_qid_fid_limit_waddr;
   wire         i_hqm_sip_rf_aqed_qid_fid_limit_wclk;
   wire         i_hqm_sip_rf_aqed_qid_fid_limit_wclk_rst_n;
   wire [13:0]  i_hqm_sip_rf_aqed_qid_fid_limit_wdata;
   wire         i_hqm_sip_rf_aqed_qid_fid_limit_we;
   wire [2:0]   i_hqm_sip_rf_atm_cmp_fifo_mem_raddr;
   wire         i_hqm_sip_rf_atm_cmp_fifo_mem_rclk;
   wire         i_hqm_sip_rf_atm_cmp_fifo_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_atm_cmp_fifo_mem_re;
   wire [2:0]   i_hqm_sip_rf_atm_cmp_fifo_mem_waddr;
   wire         i_hqm_sip_rf_atm_cmp_fifo_mem_wclk;
   wire         i_hqm_sip_rf_atm_cmp_fifo_mem_wclk_rst_n;
   wire [54:0]  i_hqm_sip_rf_atm_cmp_fifo_mem_wdata;
   wire         i_hqm_sip_rf_atm_cmp_fifo_mem_we;
   wire [3:0]   i_hqm_sip_rf_atm_fifo_ap_aqed_raddr;
   wire         i_hqm_sip_rf_atm_fifo_ap_aqed_rclk;
   wire         i_hqm_sip_rf_atm_fifo_ap_aqed_rclk_rst_n;
   wire         i_hqm_sip_rf_atm_fifo_ap_aqed_re;
   wire [3:0]   i_hqm_sip_rf_atm_fifo_ap_aqed_waddr;
   wire         i_hqm_sip_rf_atm_fifo_ap_aqed_wclk;
   wire         i_hqm_sip_rf_atm_fifo_ap_aqed_wclk_rst_n;
   wire [44:0]  i_hqm_sip_rf_atm_fifo_ap_aqed_wdata;
   wire         i_hqm_sip_rf_atm_fifo_ap_aqed_we;
   wire [4:0]   i_hqm_sip_rf_atm_fifo_aqed_ap_enq_raddr;
   wire         i_hqm_sip_rf_atm_fifo_aqed_ap_enq_rclk;
   wire         i_hqm_sip_rf_atm_fifo_aqed_ap_enq_rclk_rst_n;
   wire         i_hqm_sip_rf_atm_fifo_aqed_ap_enq_re;
   wire [4:0]   i_hqm_sip_rf_atm_fifo_aqed_ap_enq_waddr;
   wire         i_hqm_sip_rf_atm_fifo_aqed_ap_enq_wclk;
   wire         i_hqm_sip_rf_atm_fifo_aqed_ap_enq_wclk_rst_n;
   wire [23:0]  i_hqm_sip_rf_atm_fifo_aqed_ap_enq_wdata;
   wire         i_hqm_sip_rf_atm_fifo_aqed_ap_enq_we;
   wire [4:0]   i_hqm_sip_rf_atq_cnt_raddr;
   wire         i_hqm_sip_rf_atq_cnt_rclk;
   wire         i_hqm_sip_rf_atq_cnt_rclk_rst_n;
   wire         i_hqm_sip_rf_atq_cnt_re;
   wire [4:0]   i_hqm_sip_rf_atq_cnt_waddr;
   wire         i_hqm_sip_rf_atq_cnt_wclk;
   wire         i_hqm_sip_rf_atq_cnt_wclk_rst_n;
   wire [67:0]  i_hqm_sip_rf_atq_cnt_wdata;
   wire         i_hqm_sip_rf_atq_cnt_we;
   wire [6:0]   i_hqm_sip_rf_atq_hp_raddr;
   wire         i_hqm_sip_rf_atq_hp_rclk;
   wire         i_hqm_sip_rf_atq_hp_rclk_rst_n;
   wire         i_hqm_sip_rf_atq_hp_re;
   wire [6:0]   i_hqm_sip_rf_atq_hp_waddr;
   wire         i_hqm_sip_rf_atq_hp_wclk;
   wire         i_hqm_sip_rf_atq_hp_wclk_rst_n;
   wire [14:0]  i_hqm_sip_rf_atq_hp_wdata;
   wire         i_hqm_sip_rf_atq_hp_we;
   wire [6:0]   i_hqm_sip_rf_atq_tp_raddr;
   wire         i_hqm_sip_rf_atq_tp_rclk;
   wire         i_hqm_sip_rf_atq_tp_rclk_rst_n;
   wire         i_hqm_sip_rf_atq_tp_re;
   wire [6:0]   i_hqm_sip_rf_atq_tp_waddr;
   wire         i_hqm_sip_rf_atq_tp_wclk;
   wire         i_hqm_sip_rf_atq_tp_wclk_rst_n;
   wire [14:0]  i_hqm_sip_rf_atq_tp_wdata;
   wire         i_hqm_sip_rf_atq_tp_we;
   wire [4:0]   i_hqm_sip_rf_cfg_atm_qid_dpth_thrsh_mem_raddr;
   wire         i_hqm_sip_rf_cfg_atm_qid_dpth_thrsh_mem_rclk;
   wire         i_hqm_sip_rf_cfg_atm_qid_dpth_thrsh_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_cfg_atm_qid_dpth_thrsh_mem_re;
   wire [4:0]   i_hqm_sip_rf_cfg_atm_qid_dpth_thrsh_mem_waddr;
   wire         i_hqm_sip_rf_cfg_atm_qid_dpth_thrsh_mem_wclk;
   wire         i_hqm_sip_rf_cfg_atm_qid_dpth_thrsh_mem_wclk_rst_n;
   wire [15:0]  i_hqm_sip_rf_cfg_atm_qid_dpth_thrsh_mem_wdata;
   wire         i_hqm_sip_rf_cfg_atm_qid_dpth_thrsh_mem_we;
   wire [4:0]   i_hqm_sip_rf_cfg_cq2priov_mem_raddr;
   wire         i_hqm_sip_rf_cfg_cq2priov_mem_rclk;
   wire         i_hqm_sip_rf_cfg_cq2priov_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_cfg_cq2priov_mem_re;
   wire [4:0]   i_hqm_sip_rf_cfg_cq2priov_mem_waddr;
   wire         i_hqm_sip_rf_cfg_cq2priov_mem_wclk;
   wire         i_hqm_sip_rf_cfg_cq2priov_mem_wclk_rst_n;
   wire [32:0]  i_hqm_sip_rf_cfg_cq2priov_mem_wdata;
   wire         i_hqm_sip_rf_cfg_cq2priov_mem_we;
   wire [4:0]   i_hqm_sip_rf_cfg_cq2priov_odd_mem_raddr;
   wire         i_hqm_sip_rf_cfg_cq2priov_odd_mem_rclk;
   wire         i_hqm_sip_rf_cfg_cq2priov_odd_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_cfg_cq2priov_odd_mem_re;
   wire [4:0]   i_hqm_sip_rf_cfg_cq2priov_odd_mem_waddr;
   wire         i_hqm_sip_rf_cfg_cq2priov_odd_mem_wclk;
   wire         i_hqm_sip_rf_cfg_cq2priov_odd_mem_wclk_rst_n;
   wire [32:0]  i_hqm_sip_rf_cfg_cq2priov_odd_mem_wdata;
   wire         i_hqm_sip_rf_cfg_cq2priov_odd_mem_we;
   wire [4:0]   i_hqm_sip_rf_cfg_cq2qid_0_mem_raddr;
   wire         i_hqm_sip_rf_cfg_cq2qid_0_mem_rclk;
   wire         i_hqm_sip_rf_cfg_cq2qid_0_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_cfg_cq2qid_0_mem_re;
   wire [4:0]   i_hqm_sip_rf_cfg_cq2qid_0_mem_waddr;
   wire         i_hqm_sip_rf_cfg_cq2qid_0_mem_wclk;
   wire         i_hqm_sip_rf_cfg_cq2qid_0_mem_wclk_rst_n;
   wire [28:0]  i_hqm_sip_rf_cfg_cq2qid_0_mem_wdata;
   wire         i_hqm_sip_rf_cfg_cq2qid_0_mem_we;
   wire [4:0]   i_hqm_sip_rf_cfg_cq2qid_0_odd_mem_raddr;
   wire         i_hqm_sip_rf_cfg_cq2qid_0_odd_mem_rclk;
   wire         i_hqm_sip_rf_cfg_cq2qid_0_odd_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_cfg_cq2qid_0_odd_mem_re;
   wire [4:0]   i_hqm_sip_rf_cfg_cq2qid_0_odd_mem_waddr;
   wire         i_hqm_sip_rf_cfg_cq2qid_0_odd_mem_wclk;
   wire         i_hqm_sip_rf_cfg_cq2qid_0_odd_mem_wclk_rst_n;
   wire [28:0]  i_hqm_sip_rf_cfg_cq2qid_0_odd_mem_wdata;
   wire         i_hqm_sip_rf_cfg_cq2qid_0_odd_mem_we;
   wire [4:0]   i_hqm_sip_rf_cfg_cq2qid_1_mem_raddr;
   wire         i_hqm_sip_rf_cfg_cq2qid_1_mem_rclk;
   wire         i_hqm_sip_rf_cfg_cq2qid_1_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_cfg_cq2qid_1_mem_re;
   wire [4:0]   i_hqm_sip_rf_cfg_cq2qid_1_mem_waddr;
   wire         i_hqm_sip_rf_cfg_cq2qid_1_mem_wclk;
   wire         i_hqm_sip_rf_cfg_cq2qid_1_mem_wclk_rst_n;
   wire [28:0]  i_hqm_sip_rf_cfg_cq2qid_1_mem_wdata;
   wire         i_hqm_sip_rf_cfg_cq2qid_1_mem_we;
   wire [4:0]   i_hqm_sip_rf_cfg_cq2qid_1_odd_mem_raddr;
   wire         i_hqm_sip_rf_cfg_cq2qid_1_odd_mem_rclk;
   wire         i_hqm_sip_rf_cfg_cq2qid_1_odd_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_cfg_cq2qid_1_odd_mem_re;
   wire [4:0]   i_hqm_sip_rf_cfg_cq2qid_1_odd_mem_waddr;
   wire         i_hqm_sip_rf_cfg_cq2qid_1_odd_mem_wclk;
   wire         i_hqm_sip_rf_cfg_cq2qid_1_odd_mem_wclk_rst_n;
   wire [28:0]  i_hqm_sip_rf_cfg_cq2qid_1_odd_mem_wdata;
   wire         i_hqm_sip_rf_cfg_cq2qid_1_odd_mem_we;
   wire [5:0]   i_hqm_sip_rf_cfg_cq_ldb_inflight_limit_mem_raddr;
   wire         i_hqm_sip_rf_cfg_cq_ldb_inflight_limit_mem_rclk;
   wire         i_hqm_sip_rf_cfg_cq_ldb_inflight_limit_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_cfg_cq_ldb_inflight_limit_mem_re;
   wire [5:0]   i_hqm_sip_rf_cfg_cq_ldb_inflight_limit_mem_waddr;
   wire         i_hqm_sip_rf_cfg_cq_ldb_inflight_limit_mem_wclk;
   wire         i_hqm_sip_rf_cfg_cq_ldb_inflight_limit_mem_wclk_rst_n;
   wire [13:0]  i_hqm_sip_rf_cfg_cq_ldb_inflight_limit_mem_wdata;
   wire         i_hqm_sip_rf_cfg_cq_ldb_inflight_limit_mem_we;
   wire [5:0]   i_hqm_sip_rf_cfg_cq_ldb_inflight_threshold_mem_raddr;
   wire         i_hqm_sip_rf_cfg_cq_ldb_inflight_threshold_mem_rclk;
   wire         i_hqm_sip_rf_cfg_cq_ldb_inflight_threshold_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_cfg_cq_ldb_inflight_threshold_mem_re;
   wire [5:0]   i_hqm_sip_rf_cfg_cq_ldb_inflight_threshold_mem_waddr;
   wire         i_hqm_sip_rf_cfg_cq_ldb_inflight_threshold_mem_wclk;
   wire         i_hqm_sip_rf_cfg_cq_ldb_inflight_threshold_mem_wclk_rst_n;
   wire [13:0]  i_hqm_sip_rf_cfg_cq_ldb_inflight_threshold_mem_wdata;
   wire         i_hqm_sip_rf_cfg_cq_ldb_inflight_threshold_mem_we;
   wire [5:0]   i_hqm_sip_rf_cfg_cq_ldb_token_depth_select_mem_raddr;
   wire         i_hqm_sip_rf_cfg_cq_ldb_token_depth_select_mem_rclk;
   wire         i_hqm_sip_rf_cfg_cq_ldb_token_depth_select_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_cfg_cq_ldb_token_depth_select_mem_re;
   wire [5:0]   i_hqm_sip_rf_cfg_cq_ldb_token_depth_select_mem_waddr;
   wire         i_hqm_sip_rf_cfg_cq_ldb_token_depth_select_mem_wclk;
   wire         i_hqm_sip_rf_cfg_cq_ldb_token_depth_select_mem_wclk_rst_n;
   wire [4:0]   i_hqm_sip_rf_cfg_cq_ldb_token_depth_select_mem_wdata;
   wire         i_hqm_sip_rf_cfg_cq_ldb_token_depth_select_mem_we;
   wire [5:0]   i_hqm_sip_rf_cfg_cq_ldb_wu_limit_mem_raddr;
   wire         i_hqm_sip_rf_cfg_cq_ldb_wu_limit_mem_rclk;
   wire         i_hqm_sip_rf_cfg_cq_ldb_wu_limit_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_cfg_cq_ldb_wu_limit_mem_re;
   wire [5:0]   i_hqm_sip_rf_cfg_cq_ldb_wu_limit_mem_waddr;
   wire         i_hqm_sip_rf_cfg_cq_ldb_wu_limit_mem_wclk;
   wire         i_hqm_sip_rf_cfg_cq_ldb_wu_limit_mem_wclk_rst_n;
   wire [16:0]  i_hqm_sip_rf_cfg_cq_ldb_wu_limit_mem_wdata;
   wire         i_hqm_sip_rf_cfg_cq_ldb_wu_limit_mem_we;
   wire [5:0]   i_hqm_sip_rf_cfg_dir_qid_dpth_thrsh_mem_raddr;
   wire         i_hqm_sip_rf_cfg_dir_qid_dpth_thrsh_mem_rclk;
   wire         i_hqm_sip_rf_cfg_dir_qid_dpth_thrsh_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_cfg_dir_qid_dpth_thrsh_mem_re;
   wire [5:0]   i_hqm_sip_rf_cfg_dir_qid_dpth_thrsh_mem_waddr;
   wire         i_hqm_sip_rf_cfg_dir_qid_dpth_thrsh_mem_wclk;
   wire         i_hqm_sip_rf_cfg_dir_qid_dpth_thrsh_mem_wclk_rst_n;
   wire [15:0]  i_hqm_sip_rf_cfg_dir_qid_dpth_thrsh_mem_wdata;
   wire         i_hqm_sip_rf_cfg_dir_qid_dpth_thrsh_mem_we;
   wire [4:0]   i_hqm_sip_rf_cfg_nalb_qid_dpth_thrsh_mem_raddr;
   wire         i_hqm_sip_rf_cfg_nalb_qid_dpth_thrsh_mem_rclk;
   wire         i_hqm_sip_rf_cfg_nalb_qid_dpth_thrsh_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_cfg_nalb_qid_dpth_thrsh_mem_re;
   wire [4:0]   i_hqm_sip_rf_cfg_nalb_qid_dpth_thrsh_mem_waddr;
   wire         i_hqm_sip_rf_cfg_nalb_qid_dpth_thrsh_mem_wclk;
   wire         i_hqm_sip_rf_cfg_nalb_qid_dpth_thrsh_mem_wclk_rst_n;
   wire [15:0]  i_hqm_sip_rf_cfg_nalb_qid_dpth_thrsh_mem_wdata;
   wire         i_hqm_sip_rf_cfg_nalb_qid_dpth_thrsh_mem_we;
   wire [4:0]   i_hqm_sip_rf_cfg_qid_aqed_active_limit_mem_raddr;
   wire         i_hqm_sip_rf_cfg_qid_aqed_active_limit_mem_rclk;
   wire         i_hqm_sip_rf_cfg_qid_aqed_active_limit_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_cfg_qid_aqed_active_limit_mem_re;
   wire [4:0]   i_hqm_sip_rf_cfg_qid_aqed_active_limit_mem_waddr;
   wire         i_hqm_sip_rf_cfg_qid_aqed_active_limit_mem_wclk;
   wire         i_hqm_sip_rf_cfg_qid_aqed_active_limit_mem_wclk_rst_n;
   wire [12:0]  i_hqm_sip_rf_cfg_qid_aqed_active_limit_mem_wdata;
   wire         i_hqm_sip_rf_cfg_qid_aqed_active_limit_mem_we;
   wire [4:0]   i_hqm_sip_rf_cfg_qid_ldb_inflight_limit_mem_raddr;
   wire         i_hqm_sip_rf_cfg_qid_ldb_inflight_limit_mem_rclk;
   wire         i_hqm_sip_rf_cfg_qid_ldb_inflight_limit_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_cfg_qid_ldb_inflight_limit_mem_re;
   wire [4:0]   i_hqm_sip_rf_cfg_qid_ldb_inflight_limit_mem_waddr;
   wire         i_hqm_sip_rf_cfg_qid_ldb_inflight_limit_mem_wclk;
   wire         i_hqm_sip_rf_cfg_qid_ldb_inflight_limit_mem_wclk_rst_n;
   wire [12:0]  i_hqm_sip_rf_cfg_qid_ldb_inflight_limit_mem_wdata;
   wire         i_hqm_sip_rf_cfg_qid_ldb_inflight_limit_mem_we;
   wire [4:0]   i_hqm_sip_rf_cfg_qid_ldb_qid2cqidix2_mem_raddr;
   wire         i_hqm_sip_rf_cfg_qid_ldb_qid2cqidix2_mem_rclk;
   wire         i_hqm_sip_rf_cfg_qid_ldb_qid2cqidix2_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_cfg_qid_ldb_qid2cqidix2_mem_re;
   wire [4:0]   i_hqm_sip_rf_cfg_qid_ldb_qid2cqidix2_mem_waddr;
   wire         i_hqm_sip_rf_cfg_qid_ldb_qid2cqidix2_mem_wclk;
   wire         i_hqm_sip_rf_cfg_qid_ldb_qid2cqidix2_mem_wclk_rst_n;
   wire [527:0] i_hqm_sip_rf_cfg_qid_ldb_qid2cqidix2_mem_wdata;
   wire         i_hqm_sip_rf_cfg_qid_ldb_qid2cqidix2_mem_we;
   wire [4:0]   i_hqm_sip_rf_cfg_qid_ldb_qid2cqidix_mem_raddr;
   wire         i_hqm_sip_rf_cfg_qid_ldb_qid2cqidix_mem_rclk;
   wire         i_hqm_sip_rf_cfg_qid_ldb_qid2cqidix_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_cfg_qid_ldb_qid2cqidix_mem_re;
   wire [4:0]   i_hqm_sip_rf_cfg_qid_ldb_qid2cqidix_mem_waddr;
   wire         i_hqm_sip_rf_cfg_qid_ldb_qid2cqidix_mem_wclk;
   wire         i_hqm_sip_rf_cfg_qid_ldb_qid2cqidix_mem_wclk_rst_n;
   wire [527:0] i_hqm_sip_rf_cfg_qid_ldb_qid2cqidix_mem_wdata;
   wire         i_hqm_sip_rf_cfg_qid_ldb_qid2cqidix_mem_we;
   wire [3:0]   i_hqm_sip_rf_chp_chp_rop_hcw_fifo_mem_raddr;
   wire         i_hqm_sip_rf_chp_chp_rop_hcw_fifo_mem_rclk;
   wire         i_hqm_sip_rf_chp_chp_rop_hcw_fifo_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_chp_chp_rop_hcw_fifo_mem_re;
   wire [3:0]   i_hqm_sip_rf_chp_chp_rop_hcw_fifo_mem_waddr;
   wire         i_hqm_sip_rf_chp_chp_rop_hcw_fifo_mem_wclk;
   wire         i_hqm_sip_rf_chp_chp_rop_hcw_fifo_mem_wclk_rst_n;
   wire [200:0] i_hqm_sip_rf_chp_chp_rop_hcw_fifo_mem_wdata;
   wire         i_hqm_sip_rf_chp_chp_rop_hcw_fifo_mem_we;
   wire [3:0]   i_hqm_sip_rf_chp_lsp_ap_cmp_fifo_mem_raddr;
   wire         i_hqm_sip_rf_chp_lsp_ap_cmp_fifo_mem_rclk;
   wire         i_hqm_sip_rf_chp_lsp_ap_cmp_fifo_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_chp_lsp_ap_cmp_fifo_mem_re;
   wire [3:0]   i_hqm_sip_rf_chp_lsp_ap_cmp_fifo_mem_waddr;
   wire         i_hqm_sip_rf_chp_lsp_ap_cmp_fifo_mem_wclk;
   wire         i_hqm_sip_rf_chp_lsp_ap_cmp_fifo_mem_wclk_rst_n;
   wire [73:0]  i_hqm_sip_rf_chp_lsp_ap_cmp_fifo_mem_wdata;
   wire         i_hqm_sip_rf_chp_lsp_ap_cmp_fifo_mem_we;
   wire [1:0]   i_hqm_sip_rf_chp_lsp_cmp_rx_sync_fifo_mem_raddr;
   wire         i_hqm_sip_rf_chp_lsp_cmp_rx_sync_fifo_mem_rclk;
   wire         i_hqm_sip_rf_chp_lsp_cmp_rx_sync_fifo_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_chp_lsp_cmp_rx_sync_fifo_mem_re;
   wire [1:0]   i_hqm_sip_rf_chp_lsp_cmp_rx_sync_fifo_mem_waddr;
   wire         i_hqm_sip_rf_chp_lsp_cmp_rx_sync_fifo_mem_wclk;
   wire         i_hqm_sip_rf_chp_lsp_cmp_rx_sync_fifo_mem_wclk_rst_n;
   wire [72:0]  i_hqm_sip_rf_chp_lsp_cmp_rx_sync_fifo_mem_wdata;
   wire         i_hqm_sip_rf_chp_lsp_cmp_rx_sync_fifo_mem_we;
   wire [3:0]   i_hqm_sip_rf_chp_lsp_tok_fifo_mem_raddr;
   wire         i_hqm_sip_rf_chp_lsp_tok_fifo_mem_rclk;
   wire         i_hqm_sip_rf_chp_lsp_tok_fifo_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_chp_lsp_tok_fifo_mem_re;
   wire [3:0]   i_hqm_sip_rf_chp_lsp_tok_fifo_mem_waddr;
   wire         i_hqm_sip_rf_chp_lsp_tok_fifo_mem_wclk;
   wire         i_hqm_sip_rf_chp_lsp_tok_fifo_mem_wclk_rst_n;
   wire [28:0]  i_hqm_sip_rf_chp_lsp_tok_fifo_mem_wdata;
   wire         i_hqm_sip_rf_chp_lsp_tok_fifo_mem_we;
   wire [1:0]   i_hqm_sip_rf_chp_lsp_token_rx_sync_fifo_mem_raddr;
   wire         i_hqm_sip_rf_chp_lsp_token_rx_sync_fifo_mem_rclk;
   wire         i_hqm_sip_rf_chp_lsp_token_rx_sync_fifo_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_chp_lsp_token_rx_sync_fifo_mem_re;
   wire [1:0]   i_hqm_sip_rf_chp_lsp_token_rx_sync_fifo_mem_waddr;
   wire         i_hqm_sip_rf_chp_lsp_token_rx_sync_fifo_mem_wclk;
   wire         i_hqm_sip_rf_chp_lsp_token_rx_sync_fifo_mem_wclk_rst_n;
   wire [24:0]  i_hqm_sip_rf_chp_lsp_token_rx_sync_fifo_mem_wdata;
   wire         i_hqm_sip_rf_chp_lsp_token_rx_sync_fifo_mem_we;
   wire [2:0]   i_hqm_sip_rf_chp_sys_tx_fifo_mem_raddr;
   wire         i_hqm_sip_rf_chp_sys_tx_fifo_mem_rclk;
   wire         i_hqm_sip_rf_chp_sys_tx_fifo_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_chp_sys_tx_fifo_mem_re;
   wire [2:0]   i_hqm_sip_rf_chp_sys_tx_fifo_mem_waddr;
   wire         i_hqm_sip_rf_chp_sys_tx_fifo_mem_wclk;
   wire         i_hqm_sip_rf_chp_sys_tx_fifo_mem_wclk_rst_n;
   wire [199:0] i_hqm_sip_rf_chp_sys_tx_fifo_mem_wdata;
   wire         i_hqm_sip_rf_chp_sys_tx_fifo_mem_we;
   wire [5:0]   i_hqm_sip_rf_cmp_id_chk_enbl_mem_raddr;
   wire         i_hqm_sip_rf_cmp_id_chk_enbl_mem_rclk;
   wire         i_hqm_sip_rf_cmp_id_chk_enbl_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_cmp_id_chk_enbl_mem_re;
   wire [5:0]   i_hqm_sip_rf_cmp_id_chk_enbl_mem_waddr;
   wire         i_hqm_sip_rf_cmp_id_chk_enbl_mem_wclk;
   wire         i_hqm_sip_rf_cmp_id_chk_enbl_mem_wclk_rst_n;
   wire [1:0]   i_hqm_sip_rf_cmp_id_chk_enbl_mem_wdata;
   wire         i_hqm_sip_rf_cmp_id_chk_enbl_mem_we;
   wire [5:0]   i_hqm_sip_rf_count_rmw_pipe_dir_mem_raddr;
   wire         i_hqm_sip_rf_count_rmw_pipe_dir_mem_rclk;
   wire         i_hqm_sip_rf_count_rmw_pipe_dir_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_count_rmw_pipe_dir_mem_re;
   wire [5:0]   i_hqm_sip_rf_count_rmw_pipe_dir_mem_waddr;
   wire         i_hqm_sip_rf_count_rmw_pipe_dir_mem_wclk;
   wire         i_hqm_sip_rf_count_rmw_pipe_dir_mem_wclk_rst_n;
   wire [15:0]  i_hqm_sip_rf_count_rmw_pipe_dir_mem_wdata;
   wire         i_hqm_sip_rf_count_rmw_pipe_dir_mem_we;
   wire [5:0]   i_hqm_sip_rf_count_rmw_pipe_ldb_mem_raddr;
   wire         i_hqm_sip_rf_count_rmw_pipe_ldb_mem_rclk;
   wire         i_hqm_sip_rf_count_rmw_pipe_ldb_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_count_rmw_pipe_ldb_mem_re;
   wire [5:0]   i_hqm_sip_rf_count_rmw_pipe_ldb_mem_waddr;
   wire         i_hqm_sip_rf_count_rmw_pipe_ldb_mem_wclk;
   wire         i_hqm_sip_rf_count_rmw_pipe_ldb_mem_wclk_rst_n;
   wire [15:0]  i_hqm_sip_rf_count_rmw_pipe_ldb_mem_wdata;
   wire         i_hqm_sip_rf_count_rmw_pipe_ldb_mem_we;
   wire [5:0]   i_hqm_sip_rf_count_rmw_pipe_wd_dir_mem_raddr;
   wire         i_hqm_sip_rf_count_rmw_pipe_wd_dir_mem_rclk;
   wire         i_hqm_sip_rf_count_rmw_pipe_wd_dir_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_count_rmw_pipe_wd_dir_mem_re;
   wire [5:0]   i_hqm_sip_rf_count_rmw_pipe_wd_dir_mem_waddr;
   wire         i_hqm_sip_rf_count_rmw_pipe_wd_dir_mem_wclk;
   wire         i_hqm_sip_rf_count_rmw_pipe_wd_dir_mem_wclk_rst_n;
   wire [9:0]   i_hqm_sip_rf_count_rmw_pipe_wd_dir_mem_wdata;
   wire         i_hqm_sip_rf_count_rmw_pipe_wd_dir_mem_we;
   wire [5:0]   i_hqm_sip_rf_count_rmw_pipe_wd_ldb_mem_raddr;
   wire         i_hqm_sip_rf_count_rmw_pipe_wd_ldb_mem_rclk;
   wire         i_hqm_sip_rf_count_rmw_pipe_wd_ldb_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_count_rmw_pipe_wd_ldb_mem_re;
   wire [5:0]   i_hqm_sip_rf_count_rmw_pipe_wd_ldb_mem_waddr;
   wire         i_hqm_sip_rf_count_rmw_pipe_wd_ldb_mem_wclk;
   wire         i_hqm_sip_rf_count_rmw_pipe_wd_ldb_mem_wclk_rst_n;
   wire [9:0]   i_hqm_sip_rf_count_rmw_pipe_wd_ldb_mem_wdata;
   wire         i_hqm_sip_rf_count_rmw_pipe_wd_ldb_mem_we;
   wire [4:0]   i_hqm_sip_rf_cq_atm_pri_arbindex_mem_raddr;
   wire         i_hqm_sip_rf_cq_atm_pri_arbindex_mem_rclk;
   wire         i_hqm_sip_rf_cq_atm_pri_arbindex_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_cq_atm_pri_arbindex_mem_re;
   wire [4:0]   i_hqm_sip_rf_cq_atm_pri_arbindex_mem_waddr;
   wire         i_hqm_sip_rf_cq_atm_pri_arbindex_mem_wclk;
   wire         i_hqm_sip_rf_cq_atm_pri_arbindex_mem_wclk_rst_n;
   wire [95:0]  i_hqm_sip_rf_cq_atm_pri_arbindex_mem_wdata;
   wire         i_hqm_sip_rf_cq_atm_pri_arbindex_mem_we;
   wire [5:0]   i_hqm_sip_rf_cq_dir_tot_sch_cnt_mem_raddr;
   wire         i_hqm_sip_rf_cq_dir_tot_sch_cnt_mem_rclk;
   wire         i_hqm_sip_rf_cq_dir_tot_sch_cnt_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_cq_dir_tot_sch_cnt_mem_re;
   wire [5:0]   i_hqm_sip_rf_cq_dir_tot_sch_cnt_mem_waddr;
   wire         i_hqm_sip_rf_cq_dir_tot_sch_cnt_mem_wclk;
   wire         i_hqm_sip_rf_cq_dir_tot_sch_cnt_mem_wclk_rst_n;
   wire [65:0]  i_hqm_sip_rf_cq_dir_tot_sch_cnt_mem_wdata;
   wire         i_hqm_sip_rf_cq_dir_tot_sch_cnt_mem_we;
   wire [5:0]   i_hqm_sip_rf_cq_ldb_inflight_count_mem_raddr;
   wire         i_hqm_sip_rf_cq_ldb_inflight_count_mem_rclk;
   wire         i_hqm_sip_rf_cq_ldb_inflight_count_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_cq_ldb_inflight_count_mem_re;
   wire [5:0]   i_hqm_sip_rf_cq_ldb_inflight_count_mem_waddr;
   wire         i_hqm_sip_rf_cq_ldb_inflight_count_mem_wclk;
   wire         i_hqm_sip_rf_cq_ldb_inflight_count_mem_wclk_rst_n;
   wire [14:0]  i_hqm_sip_rf_cq_ldb_inflight_count_mem_wdata;
   wire         i_hqm_sip_rf_cq_ldb_inflight_count_mem_we;
   wire [5:0]   i_hqm_sip_rf_cq_ldb_token_count_mem_raddr;
   wire         i_hqm_sip_rf_cq_ldb_token_count_mem_rclk;
   wire         i_hqm_sip_rf_cq_ldb_token_count_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_cq_ldb_token_count_mem_re;
   wire [5:0]   i_hqm_sip_rf_cq_ldb_token_count_mem_waddr;
   wire         i_hqm_sip_rf_cq_ldb_token_count_mem_wclk;
   wire         i_hqm_sip_rf_cq_ldb_token_count_mem_wclk_rst_n;
   wire [12:0]  i_hqm_sip_rf_cq_ldb_token_count_mem_wdata;
   wire         i_hqm_sip_rf_cq_ldb_token_count_mem_we;
   wire [5:0]   i_hqm_sip_rf_cq_ldb_tot_sch_cnt_mem_raddr;
   wire         i_hqm_sip_rf_cq_ldb_tot_sch_cnt_mem_rclk;
   wire         i_hqm_sip_rf_cq_ldb_tot_sch_cnt_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_cq_ldb_tot_sch_cnt_mem_re;
   wire [5:0]   i_hqm_sip_rf_cq_ldb_tot_sch_cnt_mem_waddr;
   wire         i_hqm_sip_rf_cq_ldb_tot_sch_cnt_mem_wclk;
   wire         i_hqm_sip_rf_cq_ldb_tot_sch_cnt_mem_wclk_rst_n;
   wire [65:0]  i_hqm_sip_rf_cq_ldb_tot_sch_cnt_mem_wdata;
   wire         i_hqm_sip_rf_cq_ldb_tot_sch_cnt_mem_we;
   wire [5:0]   i_hqm_sip_rf_cq_ldb_wu_count_mem_raddr;
   wire         i_hqm_sip_rf_cq_ldb_wu_count_mem_rclk;
   wire         i_hqm_sip_rf_cq_ldb_wu_count_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_cq_ldb_wu_count_mem_re;
   wire [5:0]   i_hqm_sip_rf_cq_ldb_wu_count_mem_waddr;
   wire         i_hqm_sip_rf_cq_ldb_wu_count_mem_wclk;
   wire         i_hqm_sip_rf_cq_ldb_wu_count_mem_wclk_rst_n;
   wire [18:0]  i_hqm_sip_rf_cq_ldb_wu_count_mem_wdata;
   wire         i_hqm_sip_rf_cq_ldb_wu_count_mem_we;
   wire [4:0]   i_hqm_sip_rf_cq_nalb_pri_arbindex_mem_raddr;
   wire         i_hqm_sip_rf_cq_nalb_pri_arbindex_mem_rclk;
   wire         i_hqm_sip_rf_cq_nalb_pri_arbindex_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_cq_nalb_pri_arbindex_mem_re;
   wire [4:0]   i_hqm_sip_rf_cq_nalb_pri_arbindex_mem_waddr;
   wire         i_hqm_sip_rf_cq_nalb_pri_arbindex_mem_wclk;
   wire         i_hqm_sip_rf_cq_nalb_pri_arbindex_mem_wclk_rst_n;
   wire [95:0]  i_hqm_sip_rf_cq_nalb_pri_arbindex_mem_wdata;
   wire         i_hqm_sip_rf_cq_nalb_pri_arbindex_mem_we;
   wire [5:0]   i_hqm_sip_rf_dir_cnt_raddr;
   wire         i_hqm_sip_rf_dir_cnt_rclk;
   wire         i_hqm_sip_rf_dir_cnt_rclk_rst_n;
   wire         i_hqm_sip_rf_dir_cnt_re;
   wire [5:0]   i_hqm_sip_rf_dir_cnt_waddr;
   wire         i_hqm_sip_rf_dir_cnt_wclk;
   wire         i_hqm_sip_rf_dir_cnt_wclk_rst_n;
   wire [67:0]  i_hqm_sip_rf_dir_cnt_wdata;
   wire         i_hqm_sip_rf_dir_cnt_we;
   wire [5:0]   i_hqm_sip_rf_dir_cq_depth_raddr;
   wire         i_hqm_sip_rf_dir_cq_depth_rclk;
   wire         i_hqm_sip_rf_dir_cq_depth_rclk_rst_n;
   wire         i_hqm_sip_rf_dir_cq_depth_re;
   wire [5:0]   i_hqm_sip_rf_dir_cq_depth_waddr;
   wire         i_hqm_sip_rf_dir_cq_depth_wclk;
   wire         i_hqm_sip_rf_dir_cq_depth_wclk_rst_n;
   wire [12:0]  i_hqm_sip_rf_dir_cq_depth_wdata;
   wire         i_hqm_sip_rf_dir_cq_depth_we;
   wire [5:0]   i_hqm_sip_rf_dir_cq_intr_thresh_raddr;
   wire         i_hqm_sip_rf_dir_cq_intr_thresh_rclk;
   wire         i_hqm_sip_rf_dir_cq_intr_thresh_rclk_rst_n;
   wire         i_hqm_sip_rf_dir_cq_intr_thresh_re;
   wire [5:0]   i_hqm_sip_rf_dir_cq_intr_thresh_waddr;
   wire         i_hqm_sip_rf_dir_cq_intr_thresh_wclk;
   wire         i_hqm_sip_rf_dir_cq_intr_thresh_wclk_rst_n;
   wire [14:0]  i_hqm_sip_rf_dir_cq_intr_thresh_wdata;
   wire         i_hqm_sip_rf_dir_cq_intr_thresh_we;
   wire [5:0]   i_hqm_sip_rf_dir_cq_token_depth_select_raddr;
   wire         i_hqm_sip_rf_dir_cq_token_depth_select_rclk;
   wire         i_hqm_sip_rf_dir_cq_token_depth_select_rclk_rst_n;
   wire         i_hqm_sip_rf_dir_cq_token_depth_select_re;
   wire [5:0]   i_hqm_sip_rf_dir_cq_token_depth_select_waddr;
   wire         i_hqm_sip_rf_dir_cq_token_depth_select_wclk;
   wire         i_hqm_sip_rf_dir_cq_token_depth_select_wclk_rst_n;
   wire [5:0]   i_hqm_sip_rf_dir_cq_token_depth_select_wdata;
   wire         i_hqm_sip_rf_dir_cq_token_depth_select_we;
   wire [5:0]   i_hqm_sip_rf_dir_cq_wptr_raddr;
   wire         i_hqm_sip_rf_dir_cq_wptr_rclk;
   wire         i_hqm_sip_rf_dir_cq_wptr_rclk_rst_n;
   wire         i_hqm_sip_rf_dir_cq_wptr_re;
   wire [5:0]   i_hqm_sip_rf_dir_cq_wptr_waddr;
   wire         i_hqm_sip_rf_dir_cq_wptr_wclk;
   wire         i_hqm_sip_rf_dir_cq_wptr_wclk_rst_n;
   wire [12:0]  i_hqm_sip_rf_dir_cq_wptr_wdata;
   wire         i_hqm_sip_rf_dir_cq_wptr_we;
   wire [5:0]   i_hqm_sip_rf_dir_enq_cnt_mem_raddr;
   wire         i_hqm_sip_rf_dir_enq_cnt_mem_rclk;
   wire         i_hqm_sip_rf_dir_enq_cnt_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_dir_enq_cnt_mem_re;
   wire [5:0]   i_hqm_sip_rf_dir_enq_cnt_mem_waddr;
   wire         i_hqm_sip_rf_dir_enq_cnt_mem_wclk;
   wire         i_hqm_sip_rf_dir_enq_cnt_mem_wclk_rst_n;
   wire [16:0]  i_hqm_sip_rf_dir_enq_cnt_mem_wdata;
   wire         i_hqm_sip_rf_dir_enq_cnt_mem_we;
   wire [7:0]   i_hqm_sip_rf_dir_hp_raddr;
   wire         i_hqm_sip_rf_dir_hp_rclk;
   wire         i_hqm_sip_rf_dir_hp_rclk_rst_n;
   wire         i_hqm_sip_rf_dir_hp_re;
   wire [7:0]   i_hqm_sip_rf_dir_hp_waddr;
   wire         i_hqm_sip_rf_dir_hp_wclk;
   wire         i_hqm_sip_rf_dir_hp_wclk_rst_n;
   wire [14:0]  i_hqm_sip_rf_dir_hp_wdata;
   wire         i_hqm_sip_rf_dir_hp_we;
   wire [4:0]   i_hqm_sip_rf_dir_replay_cnt_raddr;
   wire         i_hqm_sip_rf_dir_replay_cnt_rclk;
   wire         i_hqm_sip_rf_dir_replay_cnt_rclk_rst_n;
   wire         i_hqm_sip_rf_dir_replay_cnt_re;
   wire [4:0]   i_hqm_sip_rf_dir_replay_cnt_waddr;
   wire         i_hqm_sip_rf_dir_replay_cnt_wclk;
   wire         i_hqm_sip_rf_dir_replay_cnt_wclk_rst_n;
   wire [67:0]  i_hqm_sip_rf_dir_replay_cnt_wdata;
   wire         i_hqm_sip_rf_dir_replay_cnt_we;
   wire [6:0]   i_hqm_sip_rf_dir_replay_hp_raddr;
   wire         i_hqm_sip_rf_dir_replay_hp_rclk;
   wire         i_hqm_sip_rf_dir_replay_hp_rclk_rst_n;
   wire         i_hqm_sip_rf_dir_replay_hp_re;
   wire [6:0]   i_hqm_sip_rf_dir_replay_hp_waddr;
   wire         i_hqm_sip_rf_dir_replay_hp_wclk;
   wire         i_hqm_sip_rf_dir_replay_hp_wclk_rst_n;
   wire [14:0]  i_hqm_sip_rf_dir_replay_hp_wdata;
   wire         i_hqm_sip_rf_dir_replay_hp_we;
   wire [6:0]   i_hqm_sip_rf_dir_replay_tp_raddr;
   wire         i_hqm_sip_rf_dir_replay_tp_rclk;
   wire         i_hqm_sip_rf_dir_replay_tp_rclk_rst_n;
   wire         i_hqm_sip_rf_dir_replay_tp_re;
   wire [6:0]   i_hqm_sip_rf_dir_replay_tp_waddr;
   wire         i_hqm_sip_rf_dir_replay_tp_wclk;
   wire         i_hqm_sip_rf_dir_replay_tp_wclk_rst_n;
   wire [14:0]  i_hqm_sip_rf_dir_replay_tp_wdata;
   wire         i_hqm_sip_rf_dir_replay_tp_we;
   wire [8:0]   i_hqm_sip_rf_dir_rofrag_cnt_raddr;
   wire         i_hqm_sip_rf_dir_rofrag_cnt_rclk;
   wire         i_hqm_sip_rf_dir_rofrag_cnt_rclk_rst_n;
   wire         i_hqm_sip_rf_dir_rofrag_cnt_re;
   wire [8:0]   i_hqm_sip_rf_dir_rofrag_cnt_waddr;
   wire         i_hqm_sip_rf_dir_rofrag_cnt_wclk;
   wire         i_hqm_sip_rf_dir_rofrag_cnt_wclk_rst_n;
   wire [16:0]  i_hqm_sip_rf_dir_rofrag_cnt_wdata;
   wire         i_hqm_sip_rf_dir_rofrag_cnt_we;
   wire [8:0]   i_hqm_sip_rf_dir_rofrag_hp_raddr;
   wire         i_hqm_sip_rf_dir_rofrag_hp_rclk;
   wire         i_hqm_sip_rf_dir_rofrag_hp_rclk_rst_n;
   wire         i_hqm_sip_rf_dir_rofrag_hp_re;
   wire [8:0]   i_hqm_sip_rf_dir_rofrag_hp_waddr;
   wire         i_hqm_sip_rf_dir_rofrag_hp_wclk;
   wire         i_hqm_sip_rf_dir_rofrag_hp_wclk_rst_n;
   wire [14:0]  i_hqm_sip_rf_dir_rofrag_hp_wdata;
   wire         i_hqm_sip_rf_dir_rofrag_hp_we;
   wire [8:0]   i_hqm_sip_rf_dir_rofrag_tp_raddr;
   wire         i_hqm_sip_rf_dir_rofrag_tp_rclk;
   wire         i_hqm_sip_rf_dir_rofrag_tp_rclk_rst_n;
   wire         i_hqm_sip_rf_dir_rofrag_tp_re;
   wire [8:0]   i_hqm_sip_rf_dir_rofrag_tp_waddr;
   wire         i_hqm_sip_rf_dir_rofrag_tp_wclk;
   wire         i_hqm_sip_rf_dir_rofrag_tp_wclk_rst_n;
   wire [14:0]  i_hqm_sip_rf_dir_rofrag_tp_wdata;
   wire         i_hqm_sip_rf_dir_rofrag_tp_we;
   wire [2:0]   i_hqm_sip_rf_dir_rply_req_fifo_mem_raddr;
   wire         i_hqm_sip_rf_dir_rply_req_fifo_mem_rclk;
   wire         i_hqm_sip_rf_dir_rply_req_fifo_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_dir_rply_req_fifo_mem_re;
   wire [2:0]   i_hqm_sip_rf_dir_rply_req_fifo_mem_waddr;
   wire         i_hqm_sip_rf_dir_rply_req_fifo_mem_wclk;
   wire         i_hqm_sip_rf_dir_rply_req_fifo_mem_wclk_rst_n;
   wire [59:0]  i_hqm_sip_rf_dir_rply_req_fifo_mem_wdata;
   wire         i_hqm_sip_rf_dir_rply_req_fifo_mem_we;
   wire [5:0]   i_hqm_sip_rf_dir_tok_cnt_mem_raddr;
   wire         i_hqm_sip_rf_dir_tok_cnt_mem_rclk;
   wire         i_hqm_sip_rf_dir_tok_cnt_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_dir_tok_cnt_mem_re;
   wire [5:0]   i_hqm_sip_rf_dir_tok_cnt_mem_waddr;
   wire         i_hqm_sip_rf_dir_tok_cnt_mem_wclk;
   wire         i_hqm_sip_rf_dir_tok_cnt_mem_wclk_rst_n;
   wire [12:0]  i_hqm_sip_rf_dir_tok_cnt_mem_wdata;
   wire         i_hqm_sip_rf_dir_tok_cnt_mem_we;
   wire [5:0]   i_hqm_sip_rf_dir_tok_lim_mem_raddr;
   wire         i_hqm_sip_rf_dir_tok_lim_mem_rclk;
   wire         i_hqm_sip_rf_dir_tok_lim_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_dir_tok_lim_mem_re;
   wire [5:0]   i_hqm_sip_rf_dir_tok_lim_mem_waddr;
   wire         i_hqm_sip_rf_dir_tok_lim_mem_wclk;
   wire         i_hqm_sip_rf_dir_tok_lim_mem_wclk_rst_n;
   wire [7:0]   i_hqm_sip_rf_dir_tok_lim_mem_wdata;
   wire         i_hqm_sip_rf_dir_tok_lim_mem_we;
   wire [7:0]   i_hqm_sip_rf_dir_tp_raddr;
   wire         i_hqm_sip_rf_dir_tp_rclk;
   wire         i_hqm_sip_rf_dir_tp_rclk_rst_n;
   wire         i_hqm_sip_rf_dir_tp_re;
   wire [7:0]   i_hqm_sip_rf_dir_tp_waddr;
   wire         i_hqm_sip_rf_dir_tp_wclk;
   wire         i_hqm_sip_rf_dir_tp_wclk_rst_n;
   wire [14:0]  i_hqm_sip_rf_dir_tp_wdata;
   wire         i_hqm_sip_rf_dir_tp_we;
   wire [5:0]   i_hqm_sip_rf_dir_wb0_raddr;
   wire         i_hqm_sip_rf_dir_wb0_rclk;
   wire         i_hqm_sip_rf_dir_wb0_rclk_rst_n;
   wire         i_hqm_sip_rf_dir_wb0_re;
   wire [5:0]   i_hqm_sip_rf_dir_wb0_waddr;
   wire         i_hqm_sip_rf_dir_wb0_wclk;
   wire         i_hqm_sip_rf_dir_wb0_wclk_rst_n;
   wire [143:0] i_hqm_sip_rf_dir_wb0_wdata;
   wire         i_hqm_sip_rf_dir_wb0_we;
   wire [5:0]   i_hqm_sip_rf_dir_wb1_raddr;
   wire         i_hqm_sip_rf_dir_wb1_rclk;
   wire         i_hqm_sip_rf_dir_wb1_rclk_rst_n;
   wire         i_hqm_sip_rf_dir_wb1_re;
   wire [5:0]   i_hqm_sip_rf_dir_wb1_waddr;
   wire         i_hqm_sip_rf_dir_wb1_wclk;
   wire         i_hqm_sip_rf_dir_wb1_wclk_rst_n;
   wire [143:0] i_hqm_sip_rf_dir_wb1_wdata;
   wire         i_hqm_sip_rf_dir_wb1_we;
   wire [5:0]   i_hqm_sip_rf_dir_wb2_raddr;
   wire         i_hqm_sip_rf_dir_wb2_rclk;
   wire         i_hqm_sip_rf_dir_wb2_rclk_rst_n;
   wire         i_hqm_sip_rf_dir_wb2_re;
   wire [5:0]   i_hqm_sip_rf_dir_wb2_waddr;
   wire         i_hqm_sip_rf_dir_wb2_wclk;
   wire         i_hqm_sip_rf_dir_wb2_wclk_rst_n;
   wire [143:0] i_hqm_sip_rf_dir_wb2_wdata;
   wire         i_hqm_sip_rf_dir_wb2_we;
   wire [4:0]   i_hqm_sip_rf_dp_dqed_raddr;
   wire         i_hqm_sip_rf_dp_dqed_rclk;
   wire         i_hqm_sip_rf_dp_dqed_rclk_rst_n;
   wire         i_hqm_sip_rf_dp_dqed_re;
   wire [4:0]   i_hqm_sip_rf_dp_dqed_waddr;
   wire         i_hqm_sip_rf_dp_dqed_wclk;
   wire         i_hqm_sip_rf_dp_dqed_wclk_rst_n;
   wire [44:0]  i_hqm_sip_rf_dp_dqed_wdata;
   wire         i_hqm_sip_rf_dp_dqed_we;
   wire [3:0]   i_hqm_sip_rf_dp_lsp_enq_dir_raddr;
   wire         i_hqm_sip_rf_dp_lsp_enq_dir_rclk;
   wire         i_hqm_sip_rf_dp_lsp_enq_dir_rclk_rst_n;
   wire         i_hqm_sip_rf_dp_lsp_enq_dir_re;
   wire [1:0]   i_hqm_sip_rf_dp_lsp_enq_dir_rx_sync_fifo_mem_raddr;
   wire         i_hqm_sip_rf_dp_lsp_enq_dir_rx_sync_fifo_mem_rclk;
   wire         i_hqm_sip_rf_dp_lsp_enq_dir_rx_sync_fifo_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_dp_lsp_enq_dir_rx_sync_fifo_mem_re;
   wire [1:0]   i_hqm_sip_rf_dp_lsp_enq_dir_rx_sync_fifo_mem_waddr;
   wire         i_hqm_sip_rf_dp_lsp_enq_dir_rx_sync_fifo_mem_wclk;
   wire         i_hqm_sip_rf_dp_lsp_enq_dir_rx_sync_fifo_mem_wclk_rst_n;
   wire [7:0]   i_hqm_sip_rf_dp_lsp_enq_dir_rx_sync_fifo_mem_wdata;
   wire         i_hqm_sip_rf_dp_lsp_enq_dir_rx_sync_fifo_mem_we;
   wire [3:0]   i_hqm_sip_rf_dp_lsp_enq_dir_waddr;
   wire         i_hqm_sip_rf_dp_lsp_enq_dir_wclk;
   wire         i_hqm_sip_rf_dp_lsp_enq_dir_wclk_rst_n;
   wire [7:0]   i_hqm_sip_rf_dp_lsp_enq_dir_wdata;
   wire         i_hqm_sip_rf_dp_lsp_enq_dir_we;
   wire [3:0]   i_hqm_sip_rf_dp_lsp_enq_rorply_raddr;
   wire         i_hqm_sip_rf_dp_lsp_enq_rorply_rclk;
   wire         i_hqm_sip_rf_dp_lsp_enq_rorply_rclk_rst_n;
   wire         i_hqm_sip_rf_dp_lsp_enq_rorply_re;
   wire [1:0]   i_hqm_sip_rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_raddr;
   wire         i_hqm_sip_rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_rclk;
   wire         i_hqm_sip_rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_re;
   wire [1:0]   i_hqm_sip_rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_waddr;
   wire         i_hqm_sip_rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_wclk;
   wire         i_hqm_sip_rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_wclk_rst_n;
   wire [22:0]  i_hqm_sip_rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_wdata;
   wire         i_hqm_sip_rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_we;
   wire [3:0]   i_hqm_sip_rf_dp_lsp_enq_rorply_waddr;
   wire         i_hqm_sip_rf_dp_lsp_enq_rorply_wclk;
   wire         i_hqm_sip_rf_dp_lsp_enq_rorply_wclk_rst_n;
   wire [22:0]  i_hqm_sip_rf_dp_lsp_enq_rorply_wdata;
   wire         i_hqm_sip_rf_dp_lsp_enq_rorply_we;
   wire [1:0]   i_hqm_sip_rf_enq_nalb_fifo_mem_raddr;
   wire         i_hqm_sip_rf_enq_nalb_fifo_mem_rclk;
   wire         i_hqm_sip_rf_enq_nalb_fifo_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_enq_nalb_fifo_mem_re;
   wire [1:0]   i_hqm_sip_rf_enq_nalb_fifo_mem_waddr;
   wire         i_hqm_sip_rf_enq_nalb_fifo_mem_wclk;
   wire         i_hqm_sip_rf_enq_nalb_fifo_mem_wclk_rst_n;
   wire [9:0]   i_hqm_sip_rf_enq_nalb_fifo_mem_wdata;
   wire         i_hqm_sip_rf_enq_nalb_fifo_mem_we;
   wire [10:0]  i_hqm_sip_rf_fid2cqqidix_raddr;
   wire         i_hqm_sip_rf_fid2cqqidix_rclk;
   wire         i_hqm_sip_rf_fid2cqqidix_rclk_rst_n;
   wire         i_hqm_sip_rf_fid2cqqidix_re;
   wire [10:0]  i_hqm_sip_rf_fid2cqqidix_waddr;
   wire         i_hqm_sip_rf_fid2cqqidix_wclk;
   wire         i_hqm_sip_rf_fid2cqqidix_wclk_rst_n;
   wire [11:0]  i_hqm_sip_rf_fid2cqqidix_wdata;
   wire         i_hqm_sip_rf_fid2cqqidix_we;
   wire [7:0]   i_hqm_sip_rf_hcw_enq_fifo_raddr;
   wire         i_hqm_sip_rf_hcw_enq_fifo_rclk;
   wire         i_hqm_sip_rf_hcw_enq_fifo_rclk_rst_n;
   wire         i_hqm_sip_rf_hcw_enq_fifo_re;
   wire [7:0]   i_hqm_sip_rf_hcw_enq_fifo_waddr;
   wire         i_hqm_sip_rf_hcw_enq_fifo_wclk;
   wire         i_hqm_sip_rf_hcw_enq_fifo_wclk_rst_n;
   wire [166:0] i_hqm_sip_rf_hcw_enq_fifo_wdata;
   wire         i_hqm_sip_rf_hcw_enq_fifo_we;
   wire [3:0]   i_hqm_sip_rf_hcw_enq_w_rx_sync_mem_raddr;
   wire         i_hqm_sip_rf_hcw_enq_w_rx_sync_mem_rclk;
   wire         i_hqm_sip_rf_hcw_enq_w_rx_sync_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_hcw_enq_w_rx_sync_mem_re;
   wire [3:0]   i_hqm_sip_rf_hcw_enq_w_rx_sync_mem_waddr;
   wire         i_hqm_sip_rf_hcw_enq_w_rx_sync_mem_wclk;
   wire         i_hqm_sip_rf_hcw_enq_w_rx_sync_mem_wclk_rst_n;
   wire [159:0] i_hqm_sip_rf_hcw_enq_w_rx_sync_mem_wdata;
   wire         i_hqm_sip_rf_hcw_enq_w_rx_sync_mem_we;
   wire [5:0]   i_hqm_sip_rf_hist_list_a_minmax_raddr;
   wire         i_hqm_sip_rf_hist_list_a_minmax_rclk;
   wire         i_hqm_sip_rf_hist_list_a_minmax_rclk_rst_n;
   wire         i_hqm_sip_rf_hist_list_a_minmax_re;
   wire [5:0]   i_hqm_sip_rf_hist_list_a_minmax_waddr;
   wire         i_hqm_sip_rf_hist_list_a_minmax_wclk;
   wire         i_hqm_sip_rf_hist_list_a_minmax_wclk_rst_n;
   wire [29:0]  i_hqm_sip_rf_hist_list_a_minmax_wdata;
   wire         i_hqm_sip_rf_hist_list_a_minmax_we;
   wire [5:0]   i_hqm_sip_rf_hist_list_a_ptr_raddr;
   wire         i_hqm_sip_rf_hist_list_a_ptr_rclk;
   wire         i_hqm_sip_rf_hist_list_a_ptr_rclk_rst_n;
   wire         i_hqm_sip_rf_hist_list_a_ptr_re;
   wire [5:0]   i_hqm_sip_rf_hist_list_a_ptr_waddr;
   wire         i_hqm_sip_rf_hist_list_a_ptr_wclk;
   wire         i_hqm_sip_rf_hist_list_a_ptr_wclk_rst_n;
   wire [31:0]  i_hqm_sip_rf_hist_list_a_ptr_wdata;
   wire         i_hqm_sip_rf_hist_list_a_ptr_we;
   wire [5:0]   i_hqm_sip_rf_hist_list_minmax_raddr;
   wire         i_hqm_sip_rf_hist_list_minmax_rclk;
   wire         i_hqm_sip_rf_hist_list_minmax_rclk_rst_n;
   wire         i_hqm_sip_rf_hist_list_minmax_re;
   wire [5:0]   i_hqm_sip_rf_hist_list_minmax_waddr;
   wire         i_hqm_sip_rf_hist_list_minmax_wclk;
   wire         i_hqm_sip_rf_hist_list_minmax_wclk_rst_n;
   wire [29:0]  i_hqm_sip_rf_hist_list_minmax_wdata;
   wire         i_hqm_sip_rf_hist_list_minmax_we;
   wire [5:0]   i_hqm_sip_rf_hist_list_ptr_raddr;
   wire         i_hqm_sip_rf_hist_list_ptr_rclk;
   wire         i_hqm_sip_rf_hist_list_ptr_rclk_rst_n;
   wire         i_hqm_sip_rf_hist_list_ptr_re;
   wire [5:0]   i_hqm_sip_rf_hist_list_ptr_waddr;
   wire         i_hqm_sip_rf_hist_list_ptr_wclk;
   wire         i_hqm_sip_rf_hist_list_ptr_wclk_rst_n;
   wire [31:0]  i_hqm_sip_rf_hist_list_ptr_wdata;
   wire         i_hqm_sip_rf_hist_list_ptr_we;
   wire [7:0]   i_hqm_sip_rf_ibcpl_data_fifo_raddr;
   wire         i_hqm_sip_rf_ibcpl_data_fifo_rclk;
   wire         i_hqm_sip_rf_ibcpl_data_fifo_rclk_rst_n;
   wire         i_hqm_sip_rf_ibcpl_data_fifo_re;
   wire [7:0]   i_hqm_sip_rf_ibcpl_data_fifo_waddr;
   wire         i_hqm_sip_rf_ibcpl_data_fifo_wclk;
   wire         i_hqm_sip_rf_ibcpl_data_fifo_wclk_rst_n;
   wire [65:0]  i_hqm_sip_rf_ibcpl_data_fifo_wdata;
   wire         i_hqm_sip_rf_ibcpl_data_fifo_we;
   wire [7:0]   i_hqm_sip_rf_ibcpl_hdr_fifo_raddr;
   wire         i_hqm_sip_rf_ibcpl_hdr_fifo_rclk;
   wire         i_hqm_sip_rf_ibcpl_hdr_fifo_rclk_rst_n;
   wire         i_hqm_sip_rf_ibcpl_hdr_fifo_re;
   wire [7:0]   i_hqm_sip_rf_ibcpl_hdr_fifo_waddr;
   wire         i_hqm_sip_rf_ibcpl_hdr_fifo_wclk;
   wire         i_hqm_sip_rf_ibcpl_hdr_fifo_wclk_rst_n;
   wire [19:0]  i_hqm_sip_rf_ibcpl_hdr_fifo_wdata;
   wire         i_hqm_sip_rf_ibcpl_hdr_fifo_we;
   wire [5:0]   i_hqm_sip_rf_ldb_cq_depth_raddr;
   wire         i_hqm_sip_rf_ldb_cq_depth_rclk;
   wire         i_hqm_sip_rf_ldb_cq_depth_rclk_rst_n;
   wire         i_hqm_sip_rf_ldb_cq_depth_re;
   wire [5:0]   i_hqm_sip_rf_ldb_cq_depth_waddr;
   wire         i_hqm_sip_rf_ldb_cq_depth_wclk;
   wire         i_hqm_sip_rf_ldb_cq_depth_wclk_rst_n;
   wire [12:0]  i_hqm_sip_rf_ldb_cq_depth_wdata;
   wire         i_hqm_sip_rf_ldb_cq_depth_we;
   wire [5:0]   i_hqm_sip_rf_ldb_cq_intr_thresh_raddr;
   wire         i_hqm_sip_rf_ldb_cq_intr_thresh_rclk;
   wire         i_hqm_sip_rf_ldb_cq_intr_thresh_rclk_rst_n;
   wire         i_hqm_sip_rf_ldb_cq_intr_thresh_re;
   wire [5:0]   i_hqm_sip_rf_ldb_cq_intr_thresh_waddr;
   wire         i_hqm_sip_rf_ldb_cq_intr_thresh_wclk;
   wire         i_hqm_sip_rf_ldb_cq_intr_thresh_wclk_rst_n;
   wire [12:0]  i_hqm_sip_rf_ldb_cq_intr_thresh_wdata;
   wire         i_hqm_sip_rf_ldb_cq_intr_thresh_we;
   wire [5:0]   i_hqm_sip_rf_ldb_cq_on_off_threshold_raddr;
   wire         i_hqm_sip_rf_ldb_cq_on_off_threshold_rclk;
   wire         i_hqm_sip_rf_ldb_cq_on_off_threshold_rclk_rst_n;
   wire         i_hqm_sip_rf_ldb_cq_on_off_threshold_re;
   wire [5:0]   i_hqm_sip_rf_ldb_cq_on_off_threshold_waddr;
   wire         i_hqm_sip_rf_ldb_cq_on_off_threshold_wclk;
   wire         i_hqm_sip_rf_ldb_cq_on_off_threshold_wclk_rst_n;
   wire [31:0]  i_hqm_sip_rf_ldb_cq_on_off_threshold_wdata;
   wire         i_hqm_sip_rf_ldb_cq_on_off_threshold_we;
   wire [5:0]   i_hqm_sip_rf_ldb_cq_token_depth_select_raddr;
   wire         i_hqm_sip_rf_ldb_cq_token_depth_select_rclk;
   wire         i_hqm_sip_rf_ldb_cq_token_depth_select_rclk_rst_n;
   wire         i_hqm_sip_rf_ldb_cq_token_depth_select_re;
   wire [5:0]   i_hqm_sip_rf_ldb_cq_token_depth_select_waddr;
   wire         i_hqm_sip_rf_ldb_cq_token_depth_select_wclk;
   wire         i_hqm_sip_rf_ldb_cq_token_depth_select_wclk_rst_n;
   wire [5:0]   i_hqm_sip_rf_ldb_cq_token_depth_select_wdata;
   wire         i_hqm_sip_rf_ldb_cq_token_depth_select_we;
   wire [5:0]   i_hqm_sip_rf_ldb_cq_wptr_raddr;
   wire         i_hqm_sip_rf_ldb_cq_wptr_rclk;
   wire         i_hqm_sip_rf_ldb_cq_wptr_rclk_rst_n;
   wire         i_hqm_sip_rf_ldb_cq_wptr_re;
   wire [5:0]   i_hqm_sip_rf_ldb_cq_wptr_waddr;
   wire         i_hqm_sip_rf_ldb_cq_wptr_wclk;
   wire         i_hqm_sip_rf_ldb_cq_wptr_wclk_rst_n;
   wire [12:0]  i_hqm_sip_rf_ldb_cq_wptr_wdata;
   wire         i_hqm_sip_rf_ldb_cq_wptr_we;
   wire [2:0]   i_hqm_sip_rf_ldb_rply_req_fifo_mem_raddr;
   wire         i_hqm_sip_rf_ldb_rply_req_fifo_mem_rclk;
   wire         i_hqm_sip_rf_ldb_rply_req_fifo_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_ldb_rply_req_fifo_mem_re;
   wire [2:0]   i_hqm_sip_rf_ldb_rply_req_fifo_mem_waddr;
   wire         i_hqm_sip_rf_ldb_rply_req_fifo_mem_wclk;
   wire         i_hqm_sip_rf_ldb_rply_req_fifo_mem_wclk_rst_n;
   wire [59:0]  i_hqm_sip_rf_ldb_rply_req_fifo_mem_wdata;
   wire         i_hqm_sip_rf_ldb_rply_req_fifo_mem_we;
   wire [2:0]   i_hqm_sip_rf_ldb_token_rtn_fifo_mem_raddr;
   wire         i_hqm_sip_rf_ldb_token_rtn_fifo_mem_rclk;
   wire         i_hqm_sip_rf_ldb_token_rtn_fifo_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_ldb_token_rtn_fifo_mem_re;
   wire [2:0]   i_hqm_sip_rf_ldb_token_rtn_fifo_mem_waddr;
   wire         i_hqm_sip_rf_ldb_token_rtn_fifo_mem_wclk;
   wire         i_hqm_sip_rf_ldb_token_rtn_fifo_mem_wclk_rst_n;
   wire [24:0]  i_hqm_sip_rf_ldb_token_rtn_fifo_mem_wdata;
   wire         i_hqm_sip_rf_ldb_token_rtn_fifo_mem_we;
   wire [5:0]   i_hqm_sip_rf_ldb_wb0_raddr;
   wire         i_hqm_sip_rf_ldb_wb0_rclk;
   wire         i_hqm_sip_rf_ldb_wb0_rclk_rst_n;
   wire         i_hqm_sip_rf_ldb_wb0_re;
   wire [5:0]   i_hqm_sip_rf_ldb_wb0_waddr;
   wire         i_hqm_sip_rf_ldb_wb0_wclk;
   wire         i_hqm_sip_rf_ldb_wb0_wclk_rst_n;
   wire [143:0] i_hqm_sip_rf_ldb_wb0_wdata;
   wire         i_hqm_sip_rf_ldb_wb0_we;
   wire [5:0]   i_hqm_sip_rf_ldb_wb1_raddr;
   wire         i_hqm_sip_rf_ldb_wb1_rclk;
   wire         i_hqm_sip_rf_ldb_wb1_rclk_rst_n;
   wire         i_hqm_sip_rf_ldb_wb1_re;
   wire [5:0]   i_hqm_sip_rf_ldb_wb1_waddr;
   wire         i_hqm_sip_rf_ldb_wb1_wclk;
   wire         i_hqm_sip_rf_ldb_wb1_wclk_rst_n;
   wire [143:0] i_hqm_sip_rf_ldb_wb1_wdata;
   wire         i_hqm_sip_rf_ldb_wb1_we;
   wire [5:0]   i_hqm_sip_rf_ldb_wb2_raddr;
   wire         i_hqm_sip_rf_ldb_wb2_rclk;
   wire         i_hqm_sip_rf_ldb_wb2_rclk_rst_n;
   wire         i_hqm_sip_rf_ldb_wb2_re;
   wire [5:0]   i_hqm_sip_rf_ldb_wb2_waddr;
   wire         i_hqm_sip_rf_ldb_wb2_wclk;
   wire         i_hqm_sip_rf_ldb_wb2_wclk_rst_n;
   wire [143:0] i_hqm_sip_rf_ldb_wb2_wdata;
   wire         i_hqm_sip_rf_ldb_wb2_we;
   wire [10:0]  i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup0_raddr;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup0_rclk;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup0_rclk_rst_n;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup0_re;
   wire [10:0]  i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup0_waddr;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup0_wclk;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup0_wclk_rst_n;
   wire [15:0]  i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup0_wdata;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup0_we;
   wire [10:0]  i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup1_raddr;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup1_rclk;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup1_rclk_rst_n;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup1_re;
   wire [10:0]  i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup1_waddr;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup1_wclk;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup1_wclk_rst_n;
   wire [15:0]  i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup1_wdata;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup1_we;
   wire [10:0]  i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup2_raddr;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup2_rclk;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup2_rclk_rst_n;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup2_re;
   wire [10:0]  i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup2_waddr;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup2_wclk;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup2_wclk_rst_n;
   wire [15:0]  i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup2_wdata;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup2_we;
   wire [10:0]  i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup3_raddr;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup3_rclk;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup3_rclk_rst_n;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup3_re;
   wire [10:0]  i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup3_waddr;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup3_wclk;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup3_wclk_rst_n;
   wire [15:0]  i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup3_wdata;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup3_we;
   wire [10:0]  i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup0_raddr;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup0_rclk;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup0_rclk_rst_n;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup0_re;
   wire [10:0]  i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup0_waddr;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup0_wclk;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup0_wclk_rst_n;
   wire [15:0]  i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup0_wdata;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup0_we;
   wire [10:0]  i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup1_raddr;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup1_rclk;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup1_rclk_rst_n;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup1_re;
   wire [10:0]  i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup1_waddr;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup1_wclk;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup1_wclk_rst_n;
   wire [15:0]  i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup1_wdata;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup1_we;
   wire [10:0]  i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup2_raddr;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup2_rclk;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup2_rclk_rst_n;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup2_re;
   wire [10:0]  i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup2_waddr;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup2_wclk;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup2_wclk_rst_n;
   wire [15:0]  i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup2_wdata;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup2_we;
   wire [10:0]  i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup3_raddr;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup3_rclk;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup3_rclk_rst_n;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup3_re;
   wire [10:0]  i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup3_waddr;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup3_wclk;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup3_wclk_rst_n;
   wire [15:0]  i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup3_wdata;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup3_we;
   wire [10:0]  i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup0_raddr;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup0_rclk;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup0_rclk_rst_n;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup0_re;
   wire [10:0]  i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup0_waddr;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup0_wclk;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup0_wclk_rst_n;
   wire [15:0]  i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup0_wdata;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup0_we;
   wire [10:0]  i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup1_raddr;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup1_rclk;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup1_rclk_rst_n;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup1_re;
   wire [10:0]  i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup1_waddr;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup1_wclk;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup1_wclk_rst_n;
   wire [15:0]  i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup1_wdata;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup1_we;
   wire [10:0]  i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup2_raddr;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup2_rclk;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup2_rclk_rst_n;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup2_re;
   wire [10:0]  i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup2_waddr;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup2_wclk;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup2_wclk_rst_n;
   wire [15:0]  i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup2_wdata;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup2_we;
   wire [10:0]  i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup3_raddr;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup3_rclk;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup3_rclk_rst_n;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup3_re;
   wire [10:0]  i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup3_waddr;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup3_wclk;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup3_wclk_rst_n;
   wire [15:0]  i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup3_wdata;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup3_we;
   wire [10:0]  i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup0_raddr;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup0_rclk;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup0_rclk_rst_n;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup0_re;
   wire [10:0]  i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup0_waddr;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup0_wclk;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup0_wclk_rst_n;
   wire [15:0]  i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup0_wdata;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup0_we;
   wire [10:0]  i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup1_raddr;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup1_rclk;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup1_rclk_rst_n;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup1_re;
   wire [10:0]  i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup1_waddr;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup1_wclk;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup1_wclk_rst_n;
   wire [15:0]  i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup1_wdata;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup1_we;
   wire [10:0]  i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup2_raddr;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup2_rclk;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup2_rclk_rst_n;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup2_re;
   wire [10:0]  i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup2_waddr;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup2_wclk;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup2_wclk_rst_n;
   wire [15:0]  i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup2_wdata;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup2_we;
   wire [10:0]  i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup3_raddr;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup3_rclk;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup3_rclk_rst_n;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup3_re;
   wire [10:0]  i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup3_waddr;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup3_wclk;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup3_wclk_rst_n;
   wire [15:0]  i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup3_wdata;
   wire         i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup3_we;
   wire [10:0]  i_hqm_sip_rf_ll_enq_cnt_s_bin0_raddr;
   wire         i_hqm_sip_rf_ll_enq_cnt_s_bin0_rclk;
   wire         i_hqm_sip_rf_ll_enq_cnt_s_bin0_rclk_rst_n;
   wire         i_hqm_sip_rf_ll_enq_cnt_s_bin0_re;
   wire [10:0]  i_hqm_sip_rf_ll_enq_cnt_s_bin0_waddr;
   wire         i_hqm_sip_rf_ll_enq_cnt_s_bin0_wclk;
   wire         i_hqm_sip_rf_ll_enq_cnt_s_bin0_wclk_rst_n;
   wire [15:0]  i_hqm_sip_rf_ll_enq_cnt_s_bin0_wdata;
   wire         i_hqm_sip_rf_ll_enq_cnt_s_bin0_we;
   wire [10:0]  i_hqm_sip_rf_ll_enq_cnt_s_bin1_raddr;
   wire         i_hqm_sip_rf_ll_enq_cnt_s_bin1_rclk;
   wire         i_hqm_sip_rf_ll_enq_cnt_s_bin1_rclk_rst_n;
   wire         i_hqm_sip_rf_ll_enq_cnt_s_bin1_re;
   wire [10:0]  i_hqm_sip_rf_ll_enq_cnt_s_bin1_waddr;
   wire         i_hqm_sip_rf_ll_enq_cnt_s_bin1_wclk;
   wire         i_hqm_sip_rf_ll_enq_cnt_s_bin1_wclk_rst_n;
   wire [15:0]  i_hqm_sip_rf_ll_enq_cnt_s_bin1_wdata;
   wire         i_hqm_sip_rf_ll_enq_cnt_s_bin1_we;
   wire [10:0]  i_hqm_sip_rf_ll_enq_cnt_s_bin2_raddr;
   wire         i_hqm_sip_rf_ll_enq_cnt_s_bin2_rclk;
   wire         i_hqm_sip_rf_ll_enq_cnt_s_bin2_rclk_rst_n;
   wire         i_hqm_sip_rf_ll_enq_cnt_s_bin2_re;
   wire [10:0]  i_hqm_sip_rf_ll_enq_cnt_s_bin2_waddr;
   wire         i_hqm_sip_rf_ll_enq_cnt_s_bin2_wclk;
   wire         i_hqm_sip_rf_ll_enq_cnt_s_bin2_wclk_rst_n;
   wire [15:0]  i_hqm_sip_rf_ll_enq_cnt_s_bin2_wdata;
   wire         i_hqm_sip_rf_ll_enq_cnt_s_bin2_we;
   wire [10:0]  i_hqm_sip_rf_ll_enq_cnt_s_bin3_raddr;
   wire         i_hqm_sip_rf_ll_enq_cnt_s_bin3_rclk;
   wire         i_hqm_sip_rf_ll_enq_cnt_s_bin3_rclk_rst_n;
   wire         i_hqm_sip_rf_ll_enq_cnt_s_bin3_re;
   wire [10:0]  i_hqm_sip_rf_ll_enq_cnt_s_bin3_waddr;
   wire         i_hqm_sip_rf_ll_enq_cnt_s_bin3_wclk;
   wire         i_hqm_sip_rf_ll_enq_cnt_s_bin3_wclk_rst_n;
   wire [15:0]  i_hqm_sip_rf_ll_enq_cnt_s_bin3_wdata;
   wire         i_hqm_sip_rf_ll_enq_cnt_s_bin3_we;
   wire [4:0]   i_hqm_sip_rf_ll_rdylst_hp_bin0_raddr;
   wire         i_hqm_sip_rf_ll_rdylst_hp_bin0_rclk;
   wire         i_hqm_sip_rf_ll_rdylst_hp_bin0_rclk_rst_n;
   wire         i_hqm_sip_rf_ll_rdylst_hp_bin0_re;
   wire [4:0]   i_hqm_sip_rf_ll_rdylst_hp_bin0_waddr;
   wire         i_hqm_sip_rf_ll_rdylst_hp_bin0_wclk;
   wire         i_hqm_sip_rf_ll_rdylst_hp_bin0_wclk_rst_n;
   wire [13:0]  i_hqm_sip_rf_ll_rdylst_hp_bin0_wdata;
   wire         i_hqm_sip_rf_ll_rdylst_hp_bin0_we;
   wire [4:0]   i_hqm_sip_rf_ll_rdylst_hp_bin1_raddr;
   wire         i_hqm_sip_rf_ll_rdylst_hp_bin1_rclk;
   wire         i_hqm_sip_rf_ll_rdylst_hp_bin1_rclk_rst_n;
   wire         i_hqm_sip_rf_ll_rdylst_hp_bin1_re;
   wire [4:0]   i_hqm_sip_rf_ll_rdylst_hp_bin1_waddr;
   wire         i_hqm_sip_rf_ll_rdylst_hp_bin1_wclk;
   wire         i_hqm_sip_rf_ll_rdylst_hp_bin1_wclk_rst_n;
   wire [13:0]  i_hqm_sip_rf_ll_rdylst_hp_bin1_wdata;
   wire         i_hqm_sip_rf_ll_rdylst_hp_bin1_we;
   wire [4:0]   i_hqm_sip_rf_ll_rdylst_hp_bin2_raddr;
   wire         i_hqm_sip_rf_ll_rdylst_hp_bin2_rclk;
   wire         i_hqm_sip_rf_ll_rdylst_hp_bin2_rclk_rst_n;
   wire         i_hqm_sip_rf_ll_rdylst_hp_bin2_re;
   wire [4:0]   i_hqm_sip_rf_ll_rdylst_hp_bin2_waddr;
   wire         i_hqm_sip_rf_ll_rdylst_hp_bin2_wclk;
   wire         i_hqm_sip_rf_ll_rdylst_hp_bin2_wclk_rst_n;
   wire [13:0]  i_hqm_sip_rf_ll_rdylst_hp_bin2_wdata;
   wire         i_hqm_sip_rf_ll_rdylst_hp_bin2_we;
   wire [4:0]   i_hqm_sip_rf_ll_rdylst_hp_bin3_raddr;
   wire         i_hqm_sip_rf_ll_rdylst_hp_bin3_rclk;
   wire         i_hqm_sip_rf_ll_rdylst_hp_bin3_rclk_rst_n;
   wire         i_hqm_sip_rf_ll_rdylst_hp_bin3_re;
   wire [4:0]   i_hqm_sip_rf_ll_rdylst_hp_bin3_waddr;
   wire         i_hqm_sip_rf_ll_rdylst_hp_bin3_wclk;
   wire         i_hqm_sip_rf_ll_rdylst_hp_bin3_wclk_rst_n;
   wire [13:0]  i_hqm_sip_rf_ll_rdylst_hp_bin3_wdata;
   wire         i_hqm_sip_rf_ll_rdylst_hp_bin3_we;
   wire [10:0]  i_hqm_sip_rf_ll_rdylst_hpnxt_bin0_raddr;
   wire         i_hqm_sip_rf_ll_rdylst_hpnxt_bin0_rclk;
   wire         i_hqm_sip_rf_ll_rdylst_hpnxt_bin0_rclk_rst_n;
   wire         i_hqm_sip_rf_ll_rdylst_hpnxt_bin0_re;
   wire [10:0]  i_hqm_sip_rf_ll_rdylst_hpnxt_bin0_waddr;
   wire         i_hqm_sip_rf_ll_rdylst_hpnxt_bin0_wclk;
   wire         i_hqm_sip_rf_ll_rdylst_hpnxt_bin0_wclk_rst_n;
   wire [15:0]  i_hqm_sip_rf_ll_rdylst_hpnxt_bin0_wdata;
   wire         i_hqm_sip_rf_ll_rdylst_hpnxt_bin0_we;
   wire [10:0]  i_hqm_sip_rf_ll_rdylst_hpnxt_bin1_raddr;
   wire         i_hqm_sip_rf_ll_rdylst_hpnxt_bin1_rclk;
   wire         i_hqm_sip_rf_ll_rdylst_hpnxt_bin1_rclk_rst_n;
   wire         i_hqm_sip_rf_ll_rdylst_hpnxt_bin1_re;
   wire [10:0]  i_hqm_sip_rf_ll_rdylst_hpnxt_bin1_waddr;
   wire         i_hqm_sip_rf_ll_rdylst_hpnxt_bin1_wclk;
   wire         i_hqm_sip_rf_ll_rdylst_hpnxt_bin1_wclk_rst_n;
   wire [15:0]  i_hqm_sip_rf_ll_rdylst_hpnxt_bin1_wdata;
   wire         i_hqm_sip_rf_ll_rdylst_hpnxt_bin1_we;
   wire [10:0]  i_hqm_sip_rf_ll_rdylst_hpnxt_bin2_raddr;
   wire         i_hqm_sip_rf_ll_rdylst_hpnxt_bin2_rclk;
   wire         i_hqm_sip_rf_ll_rdylst_hpnxt_bin2_rclk_rst_n;
   wire         i_hqm_sip_rf_ll_rdylst_hpnxt_bin2_re;
   wire [10:0]  i_hqm_sip_rf_ll_rdylst_hpnxt_bin2_waddr;
   wire         i_hqm_sip_rf_ll_rdylst_hpnxt_bin2_wclk;
   wire         i_hqm_sip_rf_ll_rdylst_hpnxt_bin2_wclk_rst_n;
   wire [15:0]  i_hqm_sip_rf_ll_rdylst_hpnxt_bin2_wdata;
   wire         i_hqm_sip_rf_ll_rdylst_hpnxt_bin2_we;
   wire [10:0]  i_hqm_sip_rf_ll_rdylst_hpnxt_bin3_raddr;
   wire         i_hqm_sip_rf_ll_rdylst_hpnxt_bin3_rclk;
   wire         i_hqm_sip_rf_ll_rdylst_hpnxt_bin3_rclk_rst_n;
   wire         i_hqm_sip_rf_ll_rdylst_hpnxt_bin3_re;
   wire [10:0]  i_hqm_sip_rf_ll_rdylst_hpnxt_bin3_waddr;
   wire         i_hqm_sip_rf_ll_rdylst_hpnxt_bin3_wclk;
   wire         i_hqm_sip_rf_ll_rdylst_hpnxt_bin3_wclk_rst_n;
   wire [15:0]  i_hqm_sip_rf_ll_rdylst_hpnxt_bin3_wdata;
   wire         i_hqm_sip_rf_ll_rdylst_hpnxt_bin3_we;
   wire [4:0]   i_hqm_sip_rf_ll_rdylst_tp_bin0_raddr;
   wire         i_hqm_sip_rf_ll_rdylst_tp_bin0_rclk;
   wire         i_hqm_sip_rf_ll_rdylst_tp_bin0_rclk_rst_n;
   wire         i_hqm_sip_rf_ll_rdylst_tp_bin0_re;
   wire [4:0]   i_hqm_sip_rf_ll_rdylst_tp_bin0_waddr;
   wire         i_hqm_sip_rf_ll_rdylst_tp_bin0_wclk;
   wire         i_hqm_sip_rf_ll_rdylst_tp_bin0_wclk_rst_n;
   wire [13:0]  i_hqm_sip_rf_ll_rdylst_tp_bin0_wdata;
   wire         i_hqm_sip_rf_ll_rdylst_tp_bin0_we;
   wire [4:0]   i_hqm_sip_rf_ll_rdylst_tp_bin1_raddr;
   wire         i_hqm_sip_rf_ll_rdylst_tp_bin1_rclk;
   wire         i_hqm_sip_rf_ll_rdylst_tp_bin1_rclk_rst_n;
   wire         i_hqm_sip_rf_ll_rdylst_tp_bin1_re;
   wire [4:0]   i_hqm_sip_rf_ll_rdylst_tp_bin1_waddr;
   wire         i_hqm_sip_rf_ll_rdylst_tp_bin1_wclk;
   wire         i_hqm_sip_rf_ll_rdylst_tp_bin1_wclk_rst_n;
   wire [13:0]  i_hqm_sip_rf_ll_rdylst_tp_bin1_wdata;
   wire         i_hqm_sip_rf_ll_rdylst_tp_bin1_we;
   wire [4:0]   i_hqm_sip_rf_ll_rdylst_tp_bin2_raddr;
   wire         i_hqm_sip_rf_ll_rdylst_tp_bin2_rclk;
   wire         i_hqm_sip_rf_ll_rdylst_tp_bin2_rclk_rst_n;
   wire         i_hqm_sip_rf_ll_rdylst_tp_bin2_re;
   wire [4:0]   i_hqm_sip_rf_ll_rdylst_tp_bin2_waddr;
   wire         i_hqm_sip_rf_ll_rdylst_tp_bin2_wclk;
   wire         i_hqm_sip_rf_ll_rdylst_tp_bin2_wclk_rst_n;
   wire [13:0]  i_hqm_sip_rf_ll_rdylst_tp_bin2_wdata;
   wire         i_hqm_sip_rf_ll_rdylst_tp_bin2_we;
   wire [4:0]   i_hqm_sip_rf_ll_rdylst_tp_bin3_raddr;
   wire         i_hqm_sip_rf_ll_rdylst_tp_bin3_rclk;
   wire         i_hqm_sip_rf_ll_rdylst_tp_bin3_rclk_rst_n;
   wire         i_hqm_sip_rf_ll_rdylst_tp_bin3_re;
   wire [4:0]   i_hqm_sip_rf_ll_rdylst_tp_bin3_waddr;
   wire         i_hqm_sip_rf_ll_rdylst_tp_bin3_wclk;
   wire         i_hqm_sip_rf_ll_rdylst_tp_bin3_wclk_rst_n;
   wire [13:0]  i_hqm_sip_rf_ll_rdylst_tp_bin3_wdata;
   wire         i_hqm_sip_rf_ll_rdylst_tp_bin3_we;
   wire [4:0]   i_hqm_sip_rf_ll_rlst_cnt_raddr;
   wire         i_hqm_sip_rf_ll_rlst_cnt_rclk;
   wire         i_hqm_sip_rf_ll_rlst_cnt_rclk_rst_n;
   wire         i_hqm_sip_rf_ll_rlst_cnt_re;
   wire [4:0]   i_hqm_sip_rf_ll_rlst_cnt_waddr;
   wire         i_hqm_sip_rf_ll_rlst_cnt_wclk;
   wire         i_hqm_sip_rf_ll_rlst_cnt_wclk_rst_n;
   wire [55:0]  i_hqm_sip_rf_ll_rlst_cnt_wdata;
   wire         i_hqm_sip_rf_ll_rlst_cnt_we;
   wire [10:0]  i_hqm_sip_rf_ll_sch_cnt_dup0_raddr;
   wire         i_hqm_sip_rf_ll_sch_cnt_dup0_rclk;
   wire         i_hqm_sip_rf_ll_sch_cnt_dup0_rclk_rst_n;
   wire         i_hqm_sip_rf_ll_sch_cnt_dup0_re;
   wire [10:0]  i_hqm_sip_rf_ll_sch_cnt_dup0_waddr;
   wire         i_hqm_sip_rf_ll_sch_cnt_dup0_wclk;
   wire         i_hqm_sip_rf_ll_sch_cnt_dup0_wclk_rst_n;
   wire [16:0]  i_hqm_sip_rf_ll_sch_cnt_dup0_wdata;
   wire         i_hqm_sip_rf_ll_sch_cnt_dup0_we;
   wire [10:0]  i_hqm_sip_rf_ll_sch_cnt_dup1_raddr;
   wire         i_hqm_sip_rf_ll_sch_cnt_dup1_rclk;
   wire         i_hqm_sip_rf_ll_sch_cnt_dup1_rclk_rst_n;
   wire         i_hqm_sip_rf_ll_sch_cnt_dup1_re;
   wire [10:0]  i_hqm_sip_rf_ll_sch_cnt_dup1_waddr;
   wire         i_hqm_sip_rf_ll_sch_cnt_dup1_wclk;
   wire         i_hqm_sip_rf_ll_sch_cnt_dup1_wclk_rst_n;
   wire [16:0]  i_hqm_sip_rf_ll_sch_cnt_dup1_wdata;
   wire         i_hqm_sip_rf_ll_sch_cnt_dup1_we;
   wire [10:0]  i_hqm_sip_rf_ll_sch_cnt_dup2_raddr;
   wire         i_hqm_sip_rf_ll_sch_cnt_dup2_rclk;
   wire         i_hqm_sip_rf_ll_sch_cnt_dup2_rclk_rst_n;
   wire         i_hqm_sip_rf_ll_sch_cnt_dup2_re;
   wire [10:0]  i_hqm_sip_rf_ll_sch_cnt_dup2_waddr;
   wire         i_hqm_sip_rf_ll_sch_cnt_dup2_wclk;
   wire         i_hqm_sip_rf_ll_sch_cnt_dup2_wclk_rst_n;
   wire [16:0]  i_hqm_sip_rf_ll_sch_cnt_dup2_wdata;
   wire         i_hqm_sip_rf_ll_sch_cnt_dup2_we;
   wire [10:0]  i_hqm_sip_rf_ll_sch_cnt_dup3_raddr;
   wire         i_hqm_sip_rf_ll_sch_cnt_dup3_rclk;
   wire         i_hqm_sip_rf_ll_sch_cnt_dup3_rclk_rst_n;
   wire         i_hqm_sip_rf_ll_sch_cnt_dup3_re;
   wire [10:0]  i_hqm_sip_rf_ll_sch_cnt_dup3_waddr;
   wire         i_hqm_sip_rf_ll_sch_cnt_dup3_wclk;
   wire         i_hqm_sip_rf_ll_sch_cnt_dup3_wclk_rst_n;
   wire [16:0]  i_hqm_sip_rf_ll_sch_cnt_dup3_wdata;
   wire         i_hqm_sip_rf_ll_sch_cnt_dup3_we;
   wire [8:0]   i_hqm_sip_rf_ll_schlst_hp_bin0_raddr;
   wire         i_hqm_sip_rf_ll_schlst_hp_bin0_rclk;
   wire         i_hqm_sip_rf_ll_schlst_hp_bin0_rclk_rst_n;
   wire         i_hqm_sip_rf_ll_schlst_hp_bin0_re;
   wire [8:0]   i_hqm_sip_rf_ll_schlst_hp_bin0_waddr;
   wire         i_hqm_sip_rf_ll_schlst_hp_bin0_wclk;
   wire         i_hqm_sip_rf_ll_schlst_hp_bin0_wclk_rst_n;
   wire [13:0]  i_hqm_sip_rf_ll_schlst_hp_bin0_wdata;
   wire         i_hqm_sip_rf_ll_schlst_hp_bin0_we;
   wire [8:0]   i_hqm_sip_rf_ll_schlst_hp_bin1_raddr;
   wire         i_hqm_sip_rf_ll_schlst_hp_bin1_rclk;
   wire         i_hqm_sip_rf_ll_schlst_hp_bin1_rclk_rst_n;
   wire         i_hqm_sip_rf_ll_schlst_hp_bin1_re;
   wire [8:0]   i_hqm_sip_rf_ll_schlst_hp_bin1_waddr;
   wire         i_hqm_sip_rf_ll_schlst_hp_bin1_wclk;
   wire         i_hqm_sip_rf_ll_schlst_hp_bin1_wclk_rst_n;
   wire [13:0]  i_hqm_sip_rf_ll_schlst_hp_bin1_wdata;
   wire         i_hqm_sip_rf_ll_schlst_hp_bin1_we;
   wire [8:0]   i_hqm_sip_rf_ll_schlst_hp_bin2_raddr;
   wire         i_hqm_sip_rf_ll_schlst_hp_bin2_rclk;
   wire         i_hqm_sip_rf_ll_schlst_hp_bin2_rclk_rst_n;
   wire         i_hqm_sip_rf_ll_schlst_hp_bin2_re;
   wire [8:0]   i_hqm_sip_rf_ll_schlst_hp_bin2_waddr;
   wire         i_hqm_sip_rf_ll_schlst_hp_bin2_wclk;
   wire         i_hqm_sip_rf_ll_schlst_hp_bin2_wclk_rst_n;
   wire [13:0]  i_hqm_sip_rf_ll_schlst_hp_bin2_wdata;
   wire         i_hqm_sip_rf_ll_schlst_hp_bin2_we;
   wire [8:0]   i_hqm_sip_rf_ll_schlst_hp_bin3_raddr;
   wire         i_hqm_sip_rf_ll_schlst_hp_bin3_rclk;
   wire         i_hqm_sip_rf_ll_schlst_hp_bin3_rclk_rst_n;
   wire         i_hqm_sip_rf_ll_schlst_hp_bin3_re;
   wire [8:0]   i_hqm_sip_rf_ll_schlst_hp_bin3_waddr;
   wire         i_hqm_sip_rf_ll_schlst_hp_bin3_wclk;
   wire         i_hqm_sip_rf_ll_schlst_hp_bin3_wclk_rst_n;
   wire [13:0]  i_hqm_sip_rf_ll_schlst_hp_bin3_wdata;
   wire         i_hqm_sip_rf_ll_schlst_hp_bin3_we;
   wire [10:0]  i_hqm_sip_rf_ll_schlst_hpnxt_bin0_raddr;
   wire         i_hqm_sip_rf_ll_schlst_hpnxt_bin0_rclk;
   wire         i_hqm_sip_rf_ll_schlst_hpnxt_bin0_rclk_rst_n;
   wire         i_hqm_sip_rf_ll_schlst_hpnxt_bin0_re;
   wire [10:0]  i_hqm_sip_rf_ll_schlst_hpnxt_bin0_waddr;
   wire         i_hqm_sip_rf_ll_schlst_hpnxt_bin0_wclk;
   wire         i_hqm_sip_rf_ll_schlst_hpnxt_bin0_wclk_rst_n;
   wire [15:0]  i_hqm_sip_rf_ll_schlst_hpnxt_bin0_wdata;
   wire         i_hqm_sip_rf_ll_schlst_hpnxt_bin0_we;
   wire [10:0]  i_hqm_sip_rf_ll_schlst_hpnxt_bin1_raddr;
   wire         i_hqm_sip_rf_ll_schlst_hpnxt_bin1_rclk;
   wire         i_hqm_sip_rf_ll_schlst_hpnxt_bin1_rclk_rst_n;
   wire         i_hqm_sip_rf_ll_schlst_hpnxt_bin1_re;
   wire [10:0]  i_hqm_sip_rf_ll_schlst_hpnxt_bin1_waddr;
   wire         i_hqm_sip_rf_ll_schlst_hpnxt_bin1_wclk;
   wire         i_hqm_sip_rf_ll_schlst_hpnxt_bin1_wclk_rst_n;
   wire [15:0]  i_hqm_sip_rf_ll_schlst_hpnxt_bin1_wdata;
   wire         i_hqm_sip_rf_ll_schlst_hpnxt_bin1_we;
   wire [10:0]  i_hqm_sip_rf_ll_schlst_hpnxt_bin2_raddr;
   wire         i_hqm_sip_rf_ll_schlst_hpnxt_bin2_rclk;
   wire         i_hqm_sip_rf_ll_schlst_hpnxt_bin2_rclk_rst_n;
   wire         i_hqm_sip_rf_ll_schlst_hpnxt_bin2_re;
   wire [10:0]  i_hqm_sip_rf_ll_schlst_hpnxt_bin2_waddr;
   wire         i_hqm_sip_rf_ll_schlst_hpnxt_bin2_wclk;
   wire         i_hqm_sip_rf_ll_schlst_hpnxt_bin2_wclk_rst_n;
   wire [15:0]  i_hqm_sip_rf_ll_schlst_hpnxt_bin2_wdata;
   wire         i_hqm_sip_rf_ll_schlst_hpnxt_bin2_we;
   wire [10:0]  i_hqm_sip_rf_ll_schlst_hpnxt_bin3_raddr;
   wire         i_hqm_sip_rf_ll_schlst_hpnxt_bin3_rclk;
   wire         i_hqm_sip_rf_ll_schlst_hpnxt_bin3_rclk_rst_n;
   wire         i_hqm_sip_rf_ll_schlst_hpnxt_bin3_re;
   wire [10:0]  i_hqm_sip_rf_ll_schlst_hpnxt_bin3_waddr;
   wire         i_hqm_sip_rf_ll_schlst_hpnxt_bin3_wclk;
   wire         i_hqm_sip_rf_ll_schlst_hpnxt_bin3_wclk_rst_n;
   wire [15:0]  i_hqm_sip_rf_ll_schlst_hpnxt_bin3_wdata;
   wire         i_hqm_sip_rf_ll_schlst_hpnxt_bin3_we;
   wire [8:0]   i_hqm_sip_rf_ll_schlst_tp_bin0_raddr;
   wire         i_hqm_sip_rf_ll_schlst_tp_bin0_rclk;
   wire         i_hqm_sip_rf_ll_schlst_tp_bin0_rclk_rst_n;
   wire         i_hqm_sip_rf_ll_schlst_tp_bin0_re;
   wire [8:0]   i_hqm_sip_rf_ll_schlst_tp_bin0_waddr;
   wire         i_hqm_sip_rf_ll_schlst_tp_bin0_wclk;
   wire         i_hqm_sip_rf_ll_schlst_tp_bin0_wclk_rst_n;
   wire [13:0]  i_hqm_sip_rf_ll_schlst_tp_bin0_wdata;
   wire         i_hqm_sip_rf_ll_schlst_tp_bin0_we;
   wire [8:0]   i_hqm_sip_rf_ll_schlst_tp_bin1_raddr;
   wire         i_hqm_sip_rf_ll_schlst_tp_bin1_rclk;
   wire         i_hqm_sip_rf_ll_schlst_tp_bin1_rclk_rst_n;
   wire         i_hqm_sip_rf_ll_schlst_tp_bin1_re;
   wire [8:0]   i_hqm_sip_rf_ll_schlst_tp_bin1_waddr;
   wire         i_hqm_sip_rf_ll_schlst_tp_bin1_wclk;
   wire         i_hqm_sip_rf_ll_schlst_tp_bin1_wclk_rst_n;
   wire [13:0]  i_hqm_sip_rf_ll_schlst_tp_bin1_wdata;
   wire         i_hqm_sip_rf_ll_schlst_tp_bin1_we;
   wire [8:0]   i_hqm_sip_rf_ll_schlst_tp_bin2_raddr;
   wire         i_hqm_sip_rf_ll_schlst_tp_bin2_rclk;
   wire         i_hqm_sip_rf_ll_schlst_tp_bin2_rclk_rst_n;
   wire         i_hqm_sip_rf_ll_schlst_tp_bin2_re;
   wire [8:0]   i_hqm_sip_rf_ll_schlst_tp_bin2_waddr;
   wire         i_hqm_sip_rf_ll_schlst_tp_bin2_wclk;
   wire         i_hqm_sip_rf_ll_schlst_tp_bin2_wclk_rst_n;
   wire [13:0]  i_hqm_sip_rf_ll_schlst_tp_bin2_wdata;
   wire         i_hqm_sip_rf_ll_schlst_tp_bin2_we;
   wire [8:0]   i_hqm_sip_rf_ll_schlst_tp_bin3_raddr;
   wire         i_hqm_sip_rf_ll_schlst_tp_bin3_rclk;
   wire         i_hqm_sip_rf_ll_schlst_tp_bin3_rclk_rst_n;
   wire         i_hqm_sip_rf_ll_schlst_tp_bin3_re;
   wire [8:0]   i_hqm_sip_rf_ll_schlst_tp_bin3_waddr;
   wire         i_hqm_sip_rf_ll_schlst_tp_bin3_wclk;
   wire         i_hqm_sip_rf_ll_schlst_tp_bin3_wclk_rst_n;
   wire [13:0]  i_hqm_sip_rf_ll_schlst_tp_bin3_wdata;
   wire         i_hqm_sip_rf_ll_schlst_tp_bin3_we;
   wire [10:0]  i_hqm_sip_rf_ll_schlst_tpprv_bin0_raddr;
   wire         i_hqm_sip_rf_ll_schlst_tpprv_bin0_rclk;
   wire         i_hqm_sip_rf_ll_schlst_tpprv_bin0_rclk_rst_n;
   wire         i_hqm_sip_rf_ll_schlst_tpprv_bin0_re;
   wire [10:0]  i_hqm_sip_rf_ll_schlst_tpprv_bin0_waddr;
   wire         i_hqm_sip_rf_ll_schlst_tpprv_bin0_wclk;
   wire         i_hqm_sip_rf_ll_schlst_tpprv_bin0_wclk_rst_n;
   wire [15:0]  i_hqm_sip_rf_ll_schlst_tpprv_bin0_wdata;
   wire         i_hqm_sip_rf_ll_schlst_tpprv_bin0_we;
   wire [10:0]  i_hqm_sip_rf_ll_schlst_tpprv_bin1_raddr;
   wire         i_hqm_sip_rf_ll_schlst_tpprv_bin1_rclk;
   wire         i_hqm_sip_rf_ll_schlst_tpprv_bin1_rclk_rst_n;
   wire         i_hqm_sip_rf_ll_schlst_tpprv_bin1_re;
   wire [10:0]  i_hqm_sip_rf_ll_schlst_tpprv_bin1_waddr;
   wire         i_hqm_sip_rf_ll_schlst_tpprv_bin1_wclk;
   wire         i_hqm_sip_rf_ll_schlst_tpprv_bin1_wclk_rst_n;
   wire [15:0]  i_hqm_sip_rf_ll_schlst_tpprv_bin1_wdata;
   wire         i_hqm_sip_rf_ll_schlst_tpprv_bin1_we;
   wire [10:0]  i_hqm_sip_rf_ll_schlst_tpprv_bin2_raddr;
   wire         i_hqm_sip_rf_ll_schlst_tpprv_bin2_rclk;
   wire         i_hqm_sip_rf_ll_schlst_tpprv_bin2_rclk_rst_n;
   wire         i_hqm_sip_rf_ll_schlst_tpprv_bin2_re;
   wire [10:0]  i_hqm_sip_rf_ll_schlst_tpprv_bin2_waddr;
   wire         i_hqm_sip_rf_ll_schlst_tpprv_bin2_wclk;
   wire         i_hqm_sip_rf_ll_schlst_tpprv_bin2_wclk_rst_n;
   wire [15:0]  i_hqm_sip_rf_ll_schlst_tpprv_bin2_wdata;
   wire         i_hqm_sip_rf_ll_schlst_tpprv_bin2_we;
   wire [10:0]  i_hqm_sip_rf_ll_schlst_tpprv_bin3_raddr;
   wire         i_hqm_sip_rf_ll_schlst_tpprv_bin3_rclk;
   wire         i_hqm_sip_rf_ll_schlst_tpprv_bin3_rclk_rst_n;
   wire         i_hqm_sip_rf_ll_schlst_tpprv_bin3_re;
   wire [10:0]  i_hqm_sip_rf_ll_schlst_tpprv_bin3_waddr;
   wire         i_hqm_sip_rf_ll_schlst_tpprv_bin3_wclk;
   wire         i_hqm_sip_rf_ll_schlst_tpprv_bin3_wclk_rst_n;
   wire [15:0]  i_hqm_sip_rf_ll_schlst_tpprv_bin3_wdata;
   wire         i_hqm_sip_rf_ll_schlst_tpprv_bin3_we;
   wire [8:0]   i_hqm_sip_rf_ll_slst_cnt_raddr;
   wire         i_hqm_sip_rf_ll_slst_cnt_rclk;
   wire         i_hqm_sip_rf_ll_slst_cnt_rclk_rst_n;
   wire         i_hqm_sip_rf_ll_slst_cnt_re;
   wire [8:0]   i_hqm_sip_rf_ll_slst_cnt_waddr;
   wire         i_hqm_sip_rf_ll_slst_cnt_wclk;
   wire         i_hqm_sip_rf_ll_slst_cnt_wclk_rst_n;
   wire [59:0]  i_hqm_sip_rf_ll_slst_cnt_wdata;
   wire         i_hqm_sip_rf_ll_slst_cnt_we;
   wire [1:0]   i_hqm_sip_rf_lsp_dp_sch_dir_raddr;
   wire         i_hqm_sip_rf_lsp_dp_sch_dir_rclk;
   wire         i_hqm_sip_rf_lsp_dp_sch_dir_rclk_rst_n;
   wire         i_hqm_sip_rf_lsp_dp_sch_dir_re;
   wire [1:0]   i_hqm_sip_rf_lsp_dp_sch_dir_waddr;
   wire         i_hqm_sip_rf_lsp_dp_sch_dir_wclk;
   wire         i_hqm_sip_rf_lsp_dp_sch_dir_wclk_rst_n;
   wire [26:0]  i_hqm_sip_rf_lsp_dp_sch_dir_wdata;
   wire         i_hqm_sip_rf_lsp_dp_sch_dir_we;
   wire [1:0]   i_hqm_sip_rf_lsp_dp_sch_rorply_raddr;
   wire         i_hqm_sip_rf_lsp_dp_sch_rorply_rclk;
   wire         i_hqm_sip_rf_lsp_dp_sch_rorply_rclk_rst_n;
   wire         i_hqm_sip_rf_lsp_dp_sch_rorply_re;
   wire [1:0]   i_hqm_sip_rf_lsp_dp_sch_rorply_waddr;
   wire         i_hqm_sip_rf_lsp_dp_sch_rorply_wclk;
   wire         i_hqm_sip_rf_lsp_dp_sch_rorply_wclk_rst_n;
   wire [7:0]   i_hqm_sip_rf_lsp_dp_sch_rorply_wdata;
   wire         i_hqm_sip_rf_lsp_dp_sch_rorply_we;
   wire [4:0]   i_hqm_sip_rf_lsp_nalb_sch_atq_raddr;
   wire         i_hqm_sip_rf_lsp_nalb_sch_atq_rclk;
   wire         i_hqm_sip_rf_lsp_nalb_sch_atq_rclk_rst_n;
   wire         i_hqm_sip_rf_lsp_nalb_sch_atq_re;
   wire [4:0]   i_hqm_sip_rf_lsp_nalb_sch_atq_waddr;
   wire         i_hqm_sip_rf_lsp_nalb_sch_atq_wclk;
   wire         i_hqm_sip_rf_lsp_nalb_sch_atq_wclk_rst_n;
   wire [7:0]   i_hqm_sip_rf_lsp_nalb_sch_atq_wdata;
   wire         i_hqm_sip_rf_lsp_nalb_sch_atq_we;
   wire [1:0]   i_hqm_sip_rf_lsp_nalb_sch_rorply_raddr;
   wire         i_hqm_sip_rf_lsp_nalb_sch_rorply_rclk;
   wire         i_hqm_sip_rf_lsp_nalb_sch_rorply_rclk_rst_n;
   wire         i_hqm_sip_rf_lsp_nalb_sch_rorply_re;
   wire [1:0]   i_hqm_sip_rf_lsp_nalb_sch_rorply_waddr;
   wire         i_hqm_sip_rf_lsp_nalb_sch_rorply_wclk;
   wire         i_hqm_sip_rf_lsp_nalb_sch_rorply_wclk_rst_n;
   wire [7:0]   i_hqm_sip_rf_lsp_nalb_sch_rorply_wdata;
   wire         i_hqm_sip_rf_lsp_nalb_sch_rorply_we;
   wire [1:0]   i_hqm_sip_rf_lsp_nalb_sch_unoord_raddr;
   wire         i_hqm_sip_rf_lsp_nalb_sch_unoord_rclk;
   wire         i_hqm_sip_rf_lsp_nalb_sch_unoord_rclk_rst_n;
   wire         i_hqm_sip_rf_lsp_nalb_sch_unoord_re;
   wire [1:0]   i_hqm_sip_rf_lsp_nalb_sch_unoord_waddr;
   wire         i_hqm_sip_rf_lsp_nalb_sch_unoord_wclk;
   wire         i_hqm_sip_rf_lsp_nalb_sch_unoord_wclk_rst_n;
   wire [26:0]  i_hqm_sip_rf_lsp_nalb_sch_unoord_wdata;
   wire         i_hqm_sip_rf_lsp_nalb_sch_unoord_we;
   wire [2:0]   i_hqm_sip_rf_lsp_reordercmp_fifo_mem_raddr;
   wire         i_hqm_sip_rf_lsp_reordercmp_fifo_mem_rclk;
   wire         i_hqm_sip_rf_lsp_reordercmp_fifo_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_lsp_reordercmp_fifo_mem_re;
   wire [2:0]   i_hqm_sip_rf_lsp_reordercmp_fifo_mem_waddr;
   wire         i_hqm_sip_rf_lsp_reordercmp_fifo_mem_wclk;
   wire         i_hqm_sip_rf_lsp_reordercmp_fifo_mem_wclk_rst_n;
   wire [18:0]  i_hqm_sip_rf_lsp_reordercmp_fifo_mem_wdata;
   wire         i_hqm_sip_rf_lsp_reordercmp_fifo_mem_we;
   wire [4:0]   i_hqm_sip_rf_lut_dir_cq2vf_pf_ro_raddr;
   wire         i_hqm_sip_rf_lut_dir_cq2vf_pf_ro_rclk;
   wire         i_hqm_sip_rf_lut_dir_cq2vf_pf_ro_rclk_rst_n;
   wire         i_hqm_sip_rf_lut_dir_cq2vf_pf_ro_re;
   wire [4:0]   i_hqm_sip_rf_lut_dir_cq2vf_pf_ro_waddr;
   wire         i_hqm_sip_rf_lut_dir_cq2vf_pf_ro_wclk;
   wire         i_hqm_sip_rf_lut_dir_cq2vf_pf_ro_wclk_rst_n;
   wire [12:0]  i_hqm_sip_rf_lut_dir_cq2vf_pf_ro_wdata;
   wire         i_hqm_sip_rf_lut_dir_cq2vf_pf_ro_we;
   wire [5:0]   i_hqm_sip_rf_lut_dir_cq_addr_l_raddr;
   wire         i_hqm_sip_rf_lut_dir_cq_addr_l_rclk;
   wire         i_hqm_sip_rf_lut_dir_cq_addr_l_rclk_rst_n;
   wire         i_hqm_sip_rf_lut_dir_cq_addr_l_re;
   wire [5:0]   i_hqm_sip_rf_lut_dir_cq_addr_l_waddr;
   wire         i_hqm_sip_rf_lut_dir_cq_addr_l_wclk;
   wire         i_hqm_sip_rf_lut_dir_cq_addr_l_wclk_rst_n;
   wire [26:0]  i_hqm_sip_rf_lut_dir_cq_addr_l_wdata;
   wire         i_hqm_sip_rf_lut_dir_cq_addr_l_we;
   wire [5:0]   i_hqm_sip_rf_lut_dir_cq_addr_u_raddr;
   wire         i_hqm_sip_rf_lut_dir_cq_addr_u_rclk;
   wire         i_hqm_sip_rf_lut_dir_cq_addr_u_rclk_rst_n;
   wire         i_hqm_sip_rf_lut_dir_cq_addr_u_re;
   wire [5:0]   i_hqm_sip_rf_lut_dir_cq_addr_u_waddr;
   wire         i_hqm_sip_rf_lut_dir_cq_addr_u_wclk;
   wire         i_hqm_sip_rf_lut_dir_cq_addr_u_wclk_rst_n;
   wire [32:0]  i_hqm_sip_rf_lut_dir_cq_addr_u_wdata;
   wire         i_hqm_sip_rf_lut_dir_cq_addr_u_we;
   wire [5:0]   i_hqm_sip_rf_lut_dir_cq_ai_addr_l_raddr;
   wire         i_hqm_sip_rf_lut_dir_cq_ai_addr_l_rclk;
   wire         i_hqm_sip_rf_lut_dir_cq_ai_addr_l_rclk_rst_n;
   wire         i_hqm_sip_rf_lut_dir_cq_ai_addr_l_re;
   wire [5:0]   i_hqm_sip_rf_lut_dir_cq_ai_addr_l_waddr;
   wire         i_hqm_sip_rf_lut_dir_cq_ai_addr_l_wclk;
   wire         i_hqm_sip_rf_lut_dir_cq_ai_addr_l_wclk_rst_n;
   wire [30:0]  i_hqm_sip_rf_lut_dir_cq_ai_addr_l_wdata;
   wire         i_hqm_sip_rf_lut_dir_cq_ai_addr_l_we;
   wire [5:0]   i_hqm_sip_rf_lut_dir_cq_ai_addr_u_raddr;
   wire         i_hqm_sip_rf_lut_dir_cq_ai_addr_u_rclk;
   wire         i_hqm_sip_rf_lut_dir_cq_ai_addr_u_rclk_rst_n;
   wire         i_hqm_sip_rf_lut_dir_cq_ai_addr_u_re;
   wire [5:0]   i_hqm_sip_rf_lut_dir_cq_ai_addr_u_waddr;
   wire         i_hqm_sip_rf_lut_dir_cq_ai_addr_u_wclk;
   wire         i_hqm_sip_rf_lut_dir_cq_ai_addr_u_wclk_rst_n;
   wire [32:0]  i_hqm_sip_rf_lut_dir_cq_ai_addr_u_wdata;
   wire         i_hqm_sip_rf_lut_dir_cq_ai_addr_u_we;
   wire [5:0]   i_hqm_sip_rf_lut_dir_cq_ai_data_raddr;
   wire         i_hqm_sip_rf_lut_dir_cq_ai_data_rclk;
   wire         i_hqm_sip_rf_lut_dir_cq_ai_data_rclk_rst_n;
   wire         i_hqm_sip_rf_lut_dir_cq_ai_data_re;
   wire [5:0]   i_hqm_sip_rf_lut_dir_cq_ai_data_waddr;
   wire         i_hqm_sip_rf_lut_dir_cq_ai_data_wclk;
   wire         i_hqm_sip_rf_lut_dir_cq_ai_data_wclk_rst_n;
   wire [32:0]  i_hqm_sip_rf_lut_dir_cq_ai_data_wdata;
   wire         i_hqm_sip_rf_lut_dir_cq_ai_data_we;
   wire [5:0]   i_hqm_sip_rf_lut_dir_cq_isr_raddr;
   wire         i_hqm_sip_rf_lut_dir_cq_isr_rclk;
   wire         i_hqm_sip_rf_lut_dir_cq_isr_rclk_rst_n;
   wire         i_hqm_sip_rf_lut_dir_cq_isr_re;
   wire [5:0]   i_hqm_sip_rf_lut_dir_cq_isr_waddr;
   wire         i_hqm_sip_rf_lut_dir_cq_isr_wclk;
   wire         i_hqm_sip_rf_lut_dir_cq_isr_wclk_rst_n;
   wire [12:0]  i_hqm_sip_rf_lut_dir_cq_isr_wdata;
   wire         i_hqm_sip_rf_lut_dir_cq_isr_we;
   wire [5:0]   i_hqm_sip_rf_lut_dir_cq_pasid_raddr;
   wire         i_hqm_sip_rf_lut_dir_cq_pasid_rclk;
   wire         i_hqm_sip_rf_lut_dir_cq_pasid_rclk_rst_n;
   wire         i_hqm_sip_rf_lut_dir_cq_pasid_re;
   wire [5:0]   i_hqm_sip_rf_lut_dir_cq_pasid_waddr;
   wire         i_hqm_sip_rf_lut_dir_cq_pasid_wclk;
   wire         i_hqm_sip_rf_lut_dir_cq_pasid_wclk_rst_n;
   wire [23:0]  i_hqm_sip_rf_lut_dir_cq_pasid_wdata;
   wire         i_hqm_sip_rf_lut_dir_cq_pasid_we;
   wire [4:0]   i_hqm_sip_rf_lut_dir_pp2vas_raddr;
   wire         i_hqm_sip_rf_lut_dir_pp2vas_rclk;
   wire         i_hqm_sip_rf_lut_dir_pp2vas_rclk_rst_n;
   wire         i_hqm_sip_rf_lut_dir_pp2vas_re;
   wire [4:0]   i_hqm_sip_rf_lut_dir_pp2vas_waddr;
   wire         i_hqm_sip_rf_lut_dir_pp2vas_wclk;
   wire         i_hqm_sip_rf_lut_dir_pp2vas_wclk_rst_n;
   wire [10:0]  i_hqm_sip_rf_lut_dir_pp2vas_wdata;
   wire         i_hqm_sip_rf_lut_dir_pp2vas_we;
   wire [1:0]   i_hqm_sip_rf_lut_dir_pp_v_raddr;
   wire         i_hqm_sip_rf_lut_dir_pp_v_rclk;
   wire         i_hqm_sip_rf_lut_dir_pp_v_rclk_rst_n;
   wire         i_hqm_sip_rf_lut_dir_pp_v_re;
   wire [1:0]   i_hqm_sip_rf_lut_dir_pp_v_waddr;
   wire         i_hqm_sip_rf_lut_dir_pp_v_wclk;
   wire         i_hqm_sip_rf_lut_dir_pp_v_wclk_rst_n;
   wire [16:0]  i_hqm_sip_rf_lut_dir_pp_v_wdata;
   wire         i_hqm_sip_rf_lut_dir_pp_v_we;
   wire [5:0]   i_hqm_sip_rf_lut_dir_vasqid_v_raddr;
   wire         i_hqm_sip_rf_lut_dir_vasqid_v_rclk;
   wire         i_hqm_sip_rf_lut_dir_vasqid_v_rclk_rst_n;
   wire         i_hqm_sip_rf_lut_dir_vasqid_v_re;
   wire [5:0]   i_hqm_sip_rf_lut_dir_vasqid_v_waddr;
   wire         i_hqm_sip_rf_lut_dir_vasqid_v_wclk;
   wire         i_hqm_sip_rf_lut_dir_vasqid_v_wclk_rst_n;
   wire [32:0]  i_hqm_sip_rf_lut_dir_vasqid_v_wdata;
   wire         i_hqm_sip_rf_lut_dir_vasqid_v_we;
   wire [4:0]   i_hqm_sip_rf_lut_ldb_cq2vf_pf_ro_raddr;
   wire         i_hqm_sip_rf_lut_ldb_cq2vf_pf_ro_rclk;
   wire         i_hqm_sip_rf_lut_ldb_cq2vf_pf_ro_rclk_rst_n;
   wire         i_hqm_sip_rf_lut_ldb_cq2vf_pf_ro_re;
   wire [4:0]   i_hqm_sip_rf_lut_ldb_cq2vf_pf_ro_waddr;
   wire         i_hqm_sip_rf_lut_ldb_cq2vf_pf_ro_wclk;
   wire         i_hqm_sip_rf_lut_ldb_cq2vf_pf_ro_wclk_rst_n;
   wire [12:0]  i_hqm_sip_rf_lut_ldb_cq2vf_pf_ro_wdata;
   wire         i_hqm_sip_rf_lut_ldb_cq2vf_pf_ro_we;
   wire [5:0]   i_hqm_sip_rf_lut_ldb_cq_addr_l_raddr;
   wire         i_hqm_sip_rf_lut_ldb_cq_addr_l_rclk;
   wire         i_hqm_sip_rf_lut_ldb_cq_addr_l_rclk_rst_n;
   wire         i_hqm_sip_rf_lut_ldb_cq_addr_l_re;
   wire [5:0]   i_hqm_sip_rf_lut_ldb_cq_addr_l_waddr;
   wire         i_hqm_sip_rf_lut_ldb_cq_addr_l_wclk;
   wire         i_hqm_sip_rf_lut_ldb_cq_addr_l_wclk_rst_n;
   wire [26:0]  i_hqm_sip_rf_lut_ldb_cq_addr_l_wdata;
   wire         i_hqm_sip_rf_lut_ldb_cq_addr_l_we;
   wire [5:0]   i_hqm_sip_rf_lut_ldb_cq_addr_u_raddr;
   wire         i_hqm_sip_rf_lut_ldb_cq_addr_u_rclk;
   wire         i_hqm_sip_rf_lut_ldb_cq_addr_u_rclk_rst_n;
   wire         i_hqm_sip_rf_lut_ldb_cq_addr_u_re;
   wire [5:0]   i_hqm_sip_rf_lut_ldb_cq_addr_u_waddr;
   wire         i_hqm_sip_rf_lut_ldb_cq_addr_u_wclk;
   wire         i_hqm_sip_rf_lut_ldb_cq_addr_u_wclk_rst_n;
   wire [32:0]  i_hqm_sip_rf_lut_ldb_cq_addr_u_wdata;
   wire         i_hqm_sip_rf_lut_ldb_cq_addr_u_we;
   wire [5:0]   i_hqm_sip_rf_lut_ldb_cq_ai_addr_l_raddr;
   wire         i_hqm_sip_rf_lut_ldb_cq_ai_addr_l_rclk;
   wire         i_hqm_sip_rf_lut_ldb_cq_ai_addr_l_rclk_rst_n;
   wire         i_hqm_sip_rf_lut_ldb_cq_ai_addr_l_re;
   wire [5:0]   i_hqm_sip_rf_lut_ldb_cq_ai_addr_l_waddr;
   wire         i_hqm_sip_rf_lut_ldb_cq_ai_addr_l_wclk;
   wire         i_hqm_sip_rf_lut_ldb_cq_ai_addr_l_wclk_rst_n;
   wire [30:0]  i_hqm_sip_rf_lut_ldb_cq_ai_addr_l_wdata;
   wire         i_hqm_sip_rf_lut_ldb_cq_ai_addr_l_we;
   wire [5:0]   i_hqm_sip_rf_lut_ldb_cq_ai_addr_u_raddr;
   wire         i_hqm_sip_rf_lut_ldb_cq_ai_addr_u_rclk;
   wire         i_hqm_sip_rf_lut_ldb_cq_ai_addr_u_rclk_rst_n;
   wire         i_hqm_sip_rf_lut_ldb_cq_ai_addr_u_re;
   wire [5:0]   i_hqm_sip_rf_lut_ldb_cq_ai_addr_u_waddr;
   wire         i_hqm_sip_rf_lut_ldb_cq_ai_addr_u_wclk;
   wire         i_hqm_sip_rf_lut_ldb_cq_ai_addr_u_wclk_rst_n;
   wire [32:0]  i_hqm_sip_rf_lut_ldb_cq_ai_addr_u_wdata;
   wire         i_hqm_sip_rf_lut_ldb_cq_ai_addr_u_we;
   wire [5:0]   i_hqm_sip_rf_lut_ldb_cq_ai_data_raddr;
   wire         i_hqm_sip_rf_lut_ldb_cq_ai_data_rclk;
   wire         i_hqm_sip_rf_lut_ldb_cq_ai_data_rclk_rst_n;
   wire         i_hqm_sip_rf_lut_ldb_cq_ai_data_re;
   wire [5:0]   i_hqm_sip_rf_lut_ldb_cq_ai_data_waddr;
   wire         i_hqm_sip_rf_lut_ldb_cq_ai_data_wclk;
   wire         i_hqm_sip_rf_lut_ldb_cq_ai_data_wclk_rst_n;
   wire [32:0]  i_hqm_sip_rf_lut_ldb_cq_ai_data_wdata;
   wire         i_hqm_sip_rf_lut_ldb_cq_ai_data_we;
   wire [5:0]   i_hqm_sip_rf_lut_ldb_cq_isr_raddr;
   wire         i_hqm_sip_rf_lut_ldb_cq_isr_rclk;
   wire         i_hqm_sip_rf_lut_ldb_cq_isr_rclk_rst_n;
   wire         i_hqm_sip_rf_lut_ldb_cq_isr_re;
   wire [5:0]   i_hqm_sip_rf_lut_ldb_cq_isr_waddr;
   wire         i_hqm_sip_rf_lut_ldb_cq_isr_wclk;
   wire         i_hqm_sip_rf_lut_ldb_cq_isr_wclk_rst_n;
   wire [12:0]  i_hqm_sip_rf_lut_ldb_cq_isr_wdata;
   wire         i_hqm_sip_rf_lut_ldb_cq_isr_we;
   wire [5:0]   i_hqm_sip_rf_lut_ldb_cq_pasid_raddr;
   wire         i_hqm_sip_rf_lut_ldb_cq_pasid_rclk;
   wire         i_hqm_sip_rf_lut_ldb_cq_pasid_rclk_rst_n;
   wire         i_hqm_sip_rf_lut_ldb_cq_pasid_re;
   wire [5:0]   i_hqm_sip_rf_lut_ldb_cq_pasid_waddr;
   wire         i_hqm_sip_rf_lut_ldb_cq_pasid_wclk;
   wire         i_hqm_sip_rf_lut_ldb_cq_pasid_wclk_rst_n;
   wire [23:0]  i_hqm_sip_rf_lut_ldb_cq_pasid_wdata;
   wire         i_hqm_sip_rf_lut_ldb_cq_pasid_we;
   wire [4:0]   i_hqm_sip_rf_lut_ldb_pp2vas_raddr;
   wire         i_hqm_sip_rf_lut_ldb_pp2vas_rclk;
   wire         i_hqm_sip_rf_lut_ldb_pp2vas_rclk_rst_n;
   wire         i_hqm_sip_rf_lut_ldb_pp2vas_re;
   wire [4:0]   i_hqm_sip_rf_lut_ldb_pp2vas_waddr;
   wire         i_hqm_sip_rf_lut_ldb_pp2vas_wclk;
   wire         i_hqm_sip_rf_lut_ldb_pp2vas_wclk_rst_n;
   wire [10:0]  i_hqm_sip_rf_lut_ldb_pp2vas_wdata;
   wire         i_hqm_sip_rf_lut_ldb_pp2vas_we;
   wire [2:0]   i_hqm_sip_rf_lut_ldb_qid2vqid_raddr;
   wire         i_hqm_sip_rf_lut_ldb_qid2vqid_rclk;
   wire         i_hqm_sip_rf_lut_ldb_qid2vqid_rclk_rst_n;
   wire         i_hqm_sip_rf_lut_ldb_qid2vqid_re;
   wire [2:0]   i_hqm_sip_rf_lut_ldb_qid2vqid_waddr;
   wire         i_hqm_sip_rf_lut_ldb_qid2vqid_wclk;
   wire         i_hqm_sip_rf_lut_ldb_qid2vqid_wclk_rst_n;
   wire [20:0]  i_hqm_sip_rf_lut_ldb_qid2vqid_wdata;
   wire         i_hqm_sip_rf_lut_ldb_qid2vqid_we;
   wire [5:0]   i_hqm_sip_rf_lut_ldb_vasqid_v_raddr;
   wire         i_hqm_sip_rf_lut_ldb_vasqid_v_rclk;
   wire         i_hqm_sip_rf_lut_ldb_vasqid_v_rclk_rst_n;
   wire         i_hqm_sip_rf_lut_ldb_vasqid_v_re;
   wire [5:0]   i_hqm_sip_rf_lut_ldb_vasqid_v_waddr;
   wire         i_hqm_sip_rf_lut_ldb_vasqid_v_wclk;
   wire         i_hqm_sip_rf_lut_ldb_vasqid_v_wclk_rst_n;
   wire [16:0]  i_hqm_sip_rf_lut_ldb_vasqid_v_wdata;
   wire         i_hqm_sip_rf_lut_ldb_vasqid_v_we;
   wire [7:0]   i_hqm_sip_rf_lut_vf_dir_vpp2pp_raddr;
   wire         i_hqm_sip_rf_lut_vf_dir_vpp2pp_rclk;
   wire         i_hqm_sip_rf_lut_vf_dir_vpp2pp_rclk_rst_n;
   wire         i_hqm_sip_rf_lut_vf_dir_vpp2pp_re;
   wire [7:0]   i_hqm_sip_rf_lut_vf_dir_vpp2pp_waddr;
   wire         i_hqm_sip_rf_lut_vf_dir_vpp2pp_wclk;
   wire         i_hqm_sip_rf_lut_vf_dir_vpp2pp_wclk_rst_n;
   wire [30:0]  i_hqm_sip_rf_lut_vf_dir_vpp2pp_wdata;
   wire         i_hqm_sip_rf_lut_vf_dir_vpp2pp_we;
   wire [5:0]   i_hqm_sip_rf_lut_vf_dir_vpp_v_raddr;
   wire         i_hqm_sip_rf_lut_vf_dir_vpp_v_rclk;
   wire         i_hqm_sip_rf_lut_vf_dir_vpp_v_rclk_rst_n;
   wire         i_hqm_sip_rf_lut_vf_dir_vpp_v_re;
   wire [5:0]   i_hqm_sip_rf_lut_vf_dir_vpp_v_waddr;
   wire         i_hqm_sip_rf_lut_vf_dir_vpp_v_wclk;
   wire         i_hqm_sip_rf_lut_vf_dir_vpp_v_wclk_rst_n;
   wire [16:0]  i_hqm_sip_rf_lut_vf_dir_vpp_v_wdata;
   wire         i_hqm_sip_rf_lut_vf_dir_vpp_v_we;
   wire [7:0]   i_hqm_sip_rf_lut_vf_dir_vqid2qid_raddr;
   wire         i_hqm_sip_rf_lut_vf_dir_vqid2qid_rclk;
   wire         i_hqm_sip_rf_lut_vf_dir_vqid2qid_rclk_rst_n;
   wire         i_hqm_sip_rf_lut_vf_dir_vqid2qid_re;
   wire [7:0]   i_hqm_sip_rf_lut_vf_dir_vqid2qid_waddr;
   wire         i_hqm_sip_rf_lut_vf_dir_vqid2qid_wclk;
   wire         i_hqm_sip_rf_lut_vf_dir_vqid2qid_wclk_rst_n;
   wire [30:0]  i_hqm_sip_rf_lut_vf_dir_vqid2qid_wdata;
   wire         i_hqm_sip_rf_lut_vf_dir_vqid2qid_we;
   wire [5:0]   i_hqm_sip_rf_lut_vf_dir_vqid_v_raddr;
   wire         i_hqm_sip_rf_lut_vf_dir_vqid_v_rclk;
   wire         i_hqm_sip_rf_lut_vf_dir_vqid_v_rclk_rst_n;
   wire         i_hqm_sip_rf_lut_vf_dir_vqid_v_re;
   wire [5:0]   i_hqm_sip_rf_lut_vf_dir_vqid_v_waddr;
   wire         i_hqm_sip_rf_lut_vf_dir_vqid_v_wclk;
   wire         i_hqm_sip_rf_lut_vf_dir_vqid_v_wclk_rst_n;
   wire [16:0]  i_hqm_sip_rf_lut_vf_dir_vqid_v_wdata;
   wire         i_hqm_sip_rf_lut_vf_dir_vqid_v_we;
   wire [7:0]   i_hqm_sip_rf_lut_vf_ldb_vpp2pp_raddr;
   wire         i_hqm_sip_rf_lut_vf_ldb_vpp2pp_rclk;
   wire         i_hqm_sip_rf_lut_vf_ldb_vpp2pp_rclk_rst_n;
   wire         i_hqm_sip_rf_lut_vf_ldb_vpp2pp_re;
   wire [7:0]   i_hqm_sip_rf_lut_vf_ldb_vpp2pp_waddr;
   wire         i_hqm_sip_rf_lut_vf_ldb_vpp2pp_wclk;
   wire         i_hqm_sip_rf_lut_vf_ldb_vpp2pp_wclk_rst_n;
   wire [24:0]  i_hqm_sip_rf_lut_vf_ldb_vpp2pp_wdata;
   wire         i_hqm_sip_rf_lut_vf_ldb_vpp2pp_we;
   wire [5:0]   i_hqm_sip_rf_lut_vf_ldb_vpp_v_raddr;
   wire         i_hqm_sip_rf_lut_vf_ldb_vpp_v_rclk;
   wire         i_hqm_sip_rf_lut_vf_ldb_vpp_v_rclk_rst_n;
   wire         i_hqm_sip_rf_lut_vf_ldb_vpp_v_re;
   wire [5:0]   i_hqm_sip_rf_lut_vf_ldb_vpp_v_waddr;
   wire         i_hqm_sip_rf_lut_vf_ldb_vpp_v_wclk;
   wire         i_hqm_sip_rf_lut_vf_ldb_vpp_v_wclk_rst_n;
   wire [16:0]  i_hqm_sip_rf_lut_vf_ldb_vpp_v_wdata;
   wire         i_hqm_sip_rf_lut_vf_ldb_vpp_v_we;
   wire [6:0]   i_hqm_sip_rf_lut_vf_ldb_vqid2qid_raddr;
   wire         i_hqm_sip_rf_lut_vf_ldb_vqid2qid_rclk;
   wire         i_hqm_sip_rf_lut_vf_ldb_vqid2qid_rclk_rst_n;
   wire         i_hqm_sip_rf_lut_vf_ldb_vqid2qid_re;
   wire [6:0]   i_hqm_sip_rf_lut_vf_ldb_vqid2qid_waddr;
   wire         i_hqm_sip_rf_lut_vf_ldb_vqid2qid_wclk;
   wire         i_hqm_sip_rf_lut_vf_ldb_vqid2qid_wclk_rst_n;
   wire [26:0]  i_hqm_sip_rf_lut_vf_ldb_vqid2qid_wdata;
   wire         i_hqm_sip_rf_lut_vf_ldb_vqid2qid_we;
   wire [4:0]   i_hqm_sip_rf_lut_vf_ldb_vqid_v_raddr;
   wire         i_hqm_sip_rf_lut_vf_ldb_vqid_v_rclk;
   wire         i_hqm_sip_rf_lut_vf_ldb_vqid_v_rclk_rst_n;
   wire         i_hqm_sip_rf_lut_vf_ldb_vqid_v_re;
   wire [4:0]   i_hqm_sip_rf_lut_vf_ldb_vqid_v_waddr;
   wire         i_hqm_sip_rf_lut_vf_ldb_vqid_v_wclk;
   wire         i_hqm_sip_rf_lut_vf_ldb_vqid_v_wclk_rst_n;
   wire [16:0]  i_hqm_sip_rf_lut_vf_ldb_vqid_v_wdata;
   wire         i_hqm_sip_rf_lut_vf_ldb_vqid_v_we;
   wire [5:0]   i_hqm_sip_rf_msix_tbl_word0_raddr;
   wire         i_hqm_sip_rf_msix_tbl_word0_rclk;
   wire         i_hqm_sip_rf_msix_tbl_word0_rclk_rst_n;
   wire         i_hqm_sip_rf_msix_tbl_word0_re;
   wire [5:0]   i_hqm_sip_rf_msix_tbl_word0_waddr;
   wire         i_hqm_sip_rf_msix_tbl_word0_wclk;
   wire         i_hqm_sip_rf_msix_tbl_word0_wclk_rst_n;
   wire [32:0]  i_hqm_sip_rf_msix_tbl_word0_wdata;
   wire         i_hqm_sip_rf_msix_tbl_word0_we;
   wire [5:0]   i_hqm_sip_rf_msix_tbl_word1_raddr;
   wire         i_hqm_sip_rf_msix_tbl_word1_rclk;
   wire         i_hqm_sip_rf_msix_tbl_word1_rclk_rst_n;
   wire         i_hqm_sip_rf_msix_tbl_word1_re;
   wire [5:0]   i_hqm_sip_rf_msix_tbl_word1_waddr;
   wire         i_hqm_sip_rf_msix_tbl_word1_wclk;
   wire         i_hqm_sip_rf_msix_tbl_word1_wclk_rst_n;
   wire [32:0]  i_hqm_sip_rf_msix_tbl_word1_wdata;
   wire         i_hqm_sip_rf_msix_tbl_word1_we;
   wire [5:0]   i_hqm_sip_rf_msix_tbl_word2_raddr;
   wire         i_hqm_sip_rf_msix_tbl_word2_rclk;
   wire         i_hqm_sip_rf_msix_tbl_word2_rclk_rst_n;
   wire         i_hqm_sip_rf_msix_tbl_word2_re;
   wire [5:0]   i_hqm_sip_rf_msix_tbl_word2_waddr;
   wire         i_hqm_sip_rf_msix_tbl_word2_wclk;
   wire         i_hqm_sip_rf_msix_tbl_word2_wclk_rst_n;
   wire [32:0]  i_hqm_sip_rf_msix_tbl_word2_wdata;
   wire         i_hqm_sip_rf_msix_tbl_word2_we;
   wire [7:0]   i_hqm_sip_rf_mstr_ll_data0_raddr;
   wire         i_hqm_sip_rf_mstr_ll_data0_rclk;
   wire         i_hqm_sip_rf_mstr_ll_data0_rclk_rst_n;
   wire         i_hqm_sip_rf_mstr_ll_data0_re;
   wire [7:0]   i_hqm_sip_rf_mstr_ll_data0_waddr;
   wire         i_hqm_sip_rf_mstr_ll_data0_wclk;
   wire         i_hqm_sip_rf_mstr_ll_data0_wclk_rst_n;
   wire [128:0] i_hqm_sip_rf_mstr_ll_data0_wdata;
   wire         i_hqm_sip_rf_mstr_ll_data0_we;
   wire [7:0]   i_hqm_sip_rf_mstr_ll_data1_raddr;
   wire         i_hqm_sip_rf_mstr_ll_data1_rclk;
   wire         i_hqm_sip_rf_mstr_ll_data1_rclk_rst_n;
   wire         i_hqm_sip_rf_mstr_ll_data1_re;
   wire [7:0]   i_hqm_sip_rf_mstr_ll_data1_waddr;
   wire         i_hqm_sip_rf_mstr_ll_data1_wclk;
   wire         i_hqm_sip_rf_mstr_ll_data1_wclk_rst_n;
   wire [128:0] i_hqm_sip_rf_mstr_ll_data1_wdata;
   wire         i_hqm_sip_rf_mstr_ll_data1_we;
   wire [7:0]   i_hqm_sip_rf_mstr_ll_data2_raddr;
   wire         i_hqm_sip_rf_mstr_ll_data2_rclk;
   wire         i_hqm_sip_rf_mstr_ll_data2_rclk_rst_n;
   wire         i_hqm_sip_rf_mstr_ll_data2_re;
   wire [7:0]   i_hqm_sip_rf_mstr_ll_data2_waddr;
   wire         i_hqm_sip_rf_mstr_ll_data2_wclk;
   wire         i_hqm_sip_rf_mstr_ll_data2_wclk_rst_n;
   wire [128:0] i_hqm_sip_rf_mstr_ll_data2_wdata;
   wire         i_hqm_sip_rf_mstr_ll_data2_we;
   wire [7:0]   i_hqm_sip_rf_mstr_ll_data3_raddr;
   wire         i_hqm_sip_rf_mstr_ll_data3_rclk;
   wire         i_hqm_sip_rf_mstr_ll_data3_rclk_rst_n;
   wire         i_hqm_sip_rf_mstr_ll_data3_re;
   wire [7:0]   i_hqm_sip_rf_mstr_ll_data3_waddr;
   wire         i_hqm_sip_rf_mstr_ll_data3_wclk;
   wire         i_hqm_sip_rf_mstr_ll_data3_wclk_rst_n;
   wire [128:0] i_hqm_sip_rf_mstr_ll_data3_wdata;
   wire         i_hqm_sip_rf_mstr_ll_data3_we;
   wire [7:0]   i_hqm_sip_rf_mstr_ll_hdr_raddr;
   wire         i_hqm_sip_rf_mstr_ll_hdr_rclk;
   wire         i_hqm_sip_rf_mstr_ll_hdr_rclk_rst_n;
   wire         i_hqm_sip_rf_mstr_ll_hdr_re;
   wire [7:0]   i_hqm_sip_rf_mstr_ll_hdr_waddr;
   wire         i_hqm_sip_rf_mstr_ll_hdr_wclk;
   wire         i_hqm_sip_rf_mstr_ll_hdr_wclk_rst_n;
   wire [152:0] i_hqm_sip_rf_mstr_ll_hdr_wdata;
   wire         i_hqm_sip_rf_mstr_ll_hdr_we;
   wire [6:0]   i_hqm_sip_rf_mstr_ll_hpa_raddr;
   wire         i_hqm_sip_rf_mstr_ll_hpa_rclk;
   wire         i_hqm_sip_rf_mstr_ll_hpa_rclk_rst_n;
   wire         i_hqm_sip_rf_mstr_ll_hpa_re;
   wire [6:0]   i_hqm_sip_rf_mstr_ll_hpa_waddr;
   wire         i_hqm_sip_rf_mstr_ll_hpa_wclk;
   wire         i_hqm_sip_rf_mstr_ll_hpa_wclk_rst_n;
   wire [34:0]  i_hqm_sip_rf_mstr_ll_hpa_wdata;
   wire         i_hqm_sip_rf_mstr_ll_hpa_we;
   wire [2:0]   i_hqm_sip_rf_nalb_cmp_fifo_mem_raddr;
   wire         i_hqm_sip_rf_nalb_cmp_fifo_mem_rclk;
   wire         i_hqm_sip_rf_nalb_cmp_fifo_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_nalb_cmp_fifo_mem_re;
   wire [2:0]   i_hqm_sip_rf_nalb_cmp_fifo_mem_waddr;
   wire         i_hqm_sip_rf_nalb_cmp_fifo_mem_wclk;
   wire         i_hqm_sip_rf_nalb_cmp_fifo_mem_wclk_rst_n;
   wire [17:0]  i_hqm_sip_rf_nalb_cmp_fifo_mem_wdata;
   wire         i_hqm_sip_rf_nalb_cmp_fifo_mem_we;
   wire [4:0]   i_hqm_sip_rf_nalb_cnt_raddr;
   wire         i_hqm_sip_rf_nalb_cnt_rclk;
   wire         i_hqm_sip_rf_nalb_cnt_rclk_rst_n;
   wire         i_hqm_sip_rf_nalb_cnt_re;
   wire [4:0]   i_hqm_sip_rf_nalb_cnt_waddr;
   wire         i_hqm_sip_rf_nalb_cnt_wclk;
   wire         i_hqm_sip_rf_nalb_cnt_wclk_rst_n;
   wire [67:0]  i_hqm_sip_rf_nalb_cnt_wdata;
   wire         i_hqm_sip_rf_nalb_cnt_we;
   wire [6:0]   i_hqm_sip_rf_nalb_hp_raddr;
   wire         i_hqm_sip_rf_nalb_hp_rclk;
   wire         i_hqm_sip_rf_nalb_hp_rclk_rst_n;
   wire         i_hqm_sip_rf_nalb_hp_re;
   wire [6:0]   i_hqm_sip_rf_nalb_hp_waddr;
   wire         i_hqm_sip_rf_nalb_hp_wclk;
   wire         i_hqm_sip_rf_nalb_hp_wclk_rst_n;
   wire [14:0]  i_hqm_sip_rf_nalb_hp_wdata;
   wire         i_hqm_sip_rf_nalb_hp_we;
   wire [1:0]   i_hqm_sip_rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_raddr;
   wire         i_hqm_sip_rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_rclk;
   wire         i_hqm_sip_rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_re;
   wire [1:0]   i_hqm_sip_rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_waddr;
   wire         i_hqm_sip_rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_wclk;
   wire         i_hqm_sip_rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_wclk_rst_n;
   wire [9:0]   i_hqm_sip_rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_wdata;
   wire         i_hqm_sip_rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_we;
   wire [4:0]   i_hqm_sip_rf_nalb_lsp_enq_rorply_raddr;
   wire         i_hqm_sip_rf_nalb_lsp_enq_rorply_rclk;
   wire         i_hqm_sip_rf_nalb_lsp_enq_rorply_rclk_rst_n;
   wire         i_hqm_sip_rf_nalb_lsp_enq_rorply_re;
   wire [1:0]   i_hqm_sip_rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_raddr;
   wire         i_hqm_sip_rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_rclk;
   wire         i_hqm_sip_rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_re;
   wire [1:0]   i_hqm_sip_rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_waddr;
   wire         i_hqm_sip_rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_wclk;
   wire         i_hqm_sip_rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_wclk_rst_n;
   wire [26:0]  i_hqm_sip_rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_wdata;
   wire         i_hqm_sip_rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_we;
   wire [4:0]   i_hqm_sip_rf_nalb_lsp_enq_rorply_waddr;
   wire         i_hqm_sip_rf_nalb_lsp_enq_rorply_wclk;
   wire         i_hqm_sip_rf_nalb_lsp_enq_rorply_wclk_rst_n;
   wire [26:0]  i_hqm_sip_rf_nalb_lsp_enq_rorply_wdata;
   wire         i_hqm_sip_rf_nalb_lsp_enq_rorply_we;
   wire [4:0]   i_hqm_sip_rf_nalb_lsp_enq_unoord_raddr;
   wire         i_hqm_sip_rf_nalb_lsp_enq_unoord_rclk;
   wire         i_hqm_sip_rf_nalb_lsp_enq_unoord_rclk_rst_n;
   wire         i_hqm_sip_rf_nalb_lsp_enq_unoord_re;
   wire [4:0]   i_hqm_sip_rf_nalb_lsp_enq_unoord_waddr;
   wire         i_hqm_sip_rf_nalb_lsp_enq_unoord_wclk;
   wire         i_hqm_sip_rf_nalb_lsp_enq_unoord_wclk_rst_n;
   wire [9:0]   i_hqm_sip_rf_nalb_lsp_enq_unoord_wdata;
   wire         i_hqm_sip_rf_nalb_lsp_enq_unoord_we;
   wire [4:0]   i_hqm_sip_rf_nalb_qed_raddr;
   wire         i_hqm_sip_rf_nalb_qed_rclk;
   wire         i_hqm_sip_rf_nalb_qed_rclk_rst_n;
   wire         i_hqm_sip_rf_nalb_qed_re;
   wire [4:0]   i_hqm_sip_rf_nalb_qed_waddr;
   wire         i_hqm_sip_rf_nalb_qed_wclk;
   wire         i_hqm_sip_rf_nalb_qed_wclk_rst_n;
   wire [44:0]  i_hqm_sip_rf_nalb_qed_wdata;
   wire         i_hqm_sip_rf_nalb_qed_we;
   wire [4:0]   i_hqm_sip_rf_nalb_replay_cnt_raddr;
   wire         i_hqm_sip_rf_nalb_replay_cnt_rclk;
   wire         i_hqm_sip_rf_nalb_replay_cnt_rclk_rst_n;
   wire         i_hqm_sip_rf_nalb_replay_cnt_re;
   wire [4:0]   i_hqm_sip_rf_nalb_replay_cnt_waddr;
   wire         i_hqm_sip_rf_nalb_replay_cnt_wclk;
   wire         i_hqm_sip_rf_nalb_replay_cnt_wclk_rst_n;
   wire [67:0]  i_hqm_sip_rf_nalb_replay_cnt_wdata;
   wire         i_hqm_sip_rf_nalb_replay_cnt_we;
   wire [6:0]   i_hqm_sip_rf_nalb_replay_hp_raddr;
   wire         i_hqm_sip_rf_nalb_replay_hp_rclk;
   wire         i_hqm_sip_rf_nalb_replay_hp_rclk_rst_n;
   wire         i_hqm_sip_rf_nalb_replay_hp_re;
   wire [6:0]   i_hqm_sip_rf_nalb_replay_hp_waddr;
   wire         i_hqm_sip_rf_nalb_replay_hp_wclk;
   wire         i_hqm_sip_rf_nalb_replay_hp_wclk_rst_n;
   wire [14:0]  i_hqm_sip_rf_nalb_replay_hp_wdata;
   wire         i_hqm_sip_rf_nalb_replay_hp_we;
   wire [6:0]   i_hqm_sip_rf_nalb_replay_tp_raddr;
   wire         i_hqm_sip_rf_nalb_replay_tp_rclk;
   wire         i_hqm_sip_rf_nalb_replay_tp_rclk_rst_n;
   wire         i_hqm_sip_rf_nalb_replay_tp_re;
   wire [6:0]   i_hqm_sip_rf_nalb_replay_tp_waddr;
   wire         i_hqm_sip_rf_nalb_replay_tp_wclk;
   wire         i_hqm_sip_rf_nalb_replay_tp_wclk_rst_n;
   wire [14:0]  i_hqm_sip_rf_nalb_replay_tp_wdata;
   wire         i_hqm_sip_rf_nalb_replay_tp_we;
   wire [8:0]   i_hqm_sip_rf_nalb_rofrag_cnt_raddr;
   wire         i_hqm_sip_rf_nalb_rofrag_cnt_rclk;
   wire         i_hqm_sip_rf_nalb_rofrag_cnt_rclk_rst_n;
   wire         i_hqm_sip_rf_nalb_rofrag_cnt_re;
   wire [8:0]   i_hqm_sip_rf_nalb_rofrag_cnt_waddr;
   wire         i_hqm_sip_rf_nalb_rofrag_cnt_wclk;
   wire         i_hqm_sip_rf_nalb_rofrag_cnt_wclk_rst_n;
   wire [16:0]  i_hqm_sip_rf_nalb_rofrag_cnt_wdata;
   wire         i_hqm_sip_rf_nalb_rofrag_cnt_we;
   wire [8:0]   i_hqm_sip_rf_nalb_rofrag_hp_raddr;
   wire         i_hqm_sip_rf_nalb_rofrag_hp_rclk;
   wire         i_hqm_sip_rf_nalb_rofrag_hp_rclk_rst_n;
   wire         i_hqm_sip_rf_nalb_rofrag_hp_re;
   wire [8:0]   i_hqm_sip_rf_nalb_rofrag_hp_waddr;
   wire         i_hqm_sip_rf_nalb_rofrag_hp_wclk;
   wire         i_hqm_sip_rf_nalb_rofrag_hp_wclk_rst_n;
   wire [14:0]  i_hqm_sip_rf_nalb_rofrag_hp_wdata;
   wire         i_hqm_sip_rf_nalb_rofrag_hp_we;
   wire [8:0]   i_hqm_sip_rf_nalb_rofrag_tp_raddr;
   wire         i_hqm_sip_rf_nalb_rofrag_tp_rclk;
   wire         i_hqm_sip_rf_nalb_rofrag_tp_rclk_rst_n;
   wire         i_hqm_sip_rf_nalb_rofrag_tp_re;
   wire [8:0]   i_hqm_sip_rf_nalb_rofrag_tp_waddr;
   wire         i_hqm_sip_rf_nalb_rofrag_tp_wclk;
   wire         i_hqm_sip_rf_nalb_rofrag_tp_wclk_rst_n;
   wire [14:0]  i_hqm_sip_rf_nalb_rofrag_tp_wdata;
   wire         i_hqm_sip_rf_nalb_rofrag_tp_we;
   wire [3:0]   i_hqm_sip_rf_nalb_sel_nalb_fifo_mem_raddr;
   wire         i_hqm_sip_rf_nalb_sel_nalb_fifo_mem_rclk;
   wire         i_hqm_sip_rf_nalb_sel_nalb_fifo_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_nalb_sel_nalb_fifo_mem_re;
   wire [3:0]   i_hqm_sip_rf_nalb_sel_nalb_fifo_mem_waddr;
   wire         i_hqm_sip_rf_nalb_sel_nalb_fifo_mem_wclk;
   wire         i_hqm_sip_rf_nalb_sel_nalb_fifo_mem_wclk_rst_n;
   wire [26:0]  i_hqm_sip_rf_nalb_sel_nalb_fifo_mem_wdata;
   wire         i_hqm_sip_rf_nalb_sel_nalb_fifo_mem_we;
   wire [6:0]   i_hqm_sip_rf_nalb_tp_raddr;
   wire         i_hqm_sip_rf_nalb_tp_rclk;
   wire         i_hqm_sip_rf_nalb_tp_rclk_rst_n;
   wire         i_hqm_sip_rf_nalb_tp_re;
   wire [6:0]   i_hqm_sip_rf_nalb_tp_waddr;
   wire         i_hqm_sip_rf_nalb_tp_wclk;
   wire         i_hqm_sip_rf_nalb_tp_wclk_rst_n;
   wire [14:0]  i_hqm_sip_rf_nalb_tp_wdata;
   wire         i_hqm_sip_rf_nalb_tp_we;
   wire [4:0]   i_hqm_sip_rf_ord_qid_sn_map_raddr;
   wire         i_hqm_sip_rf_ord_qid_sn_map_rclk;
   wire         i_hqm_sip_rf_ord_qid_sn_map_rclk_rst_n;
   wire         i_hqm_sip_rf_ord_qid_sn_map_re;
   wire [4:0]   i_hqm_sip_rf_ord_qid_sn_map_waddr;
   wire         i_hqm_sip_rf_ord_qid_sn_map_wclk;
   wire         i_hqm_sip_rf_ord_qid_sn_map_wclk_rst_n;
   wire [11:0]  i_hqm_sip_rf_ord_qid_sn_map_wdata;
   wire         i_hqm_sip_rf_ord_qid_sn_map_we;
   wire [4:0]   i_hqm_sip_rf_ord_qid_sn_raddr;
   wire         i_hqm_sip_rf_ord_qid_sn_rclk;
   wire         i_hqm_sip_rf_ord_qid_sn_rclk_rst_n;
   wire         i_hqm_sip_rf_ord_qid_sn_re;
   wire [4:0]   i_hqm_sip_rf_ord_qid_sn_waddr;
   wire         i_hqm_sip_rf_ord_qid_sn_wclk;
   wire         i_hqm_sip_rf_ord_qid_sn_wclk_rst_n;
   wire [11:0]  i_hqm_sip_rf_ord_qid_sn_wdata;
   wire         i_hqm_sip_rf_ord_qid_sn_we;
   wire [3:0]   i_hqm_sip_rf_outbound_hcw_fifo_mem_raddr;
   wire         i_hqm_sip_rf_outbound_hcw_fifo_mem_rclk;
   wire         i_hqm_sip_rf_outbound_hcw_fifo_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_outbound_hcw_fifo_mem_re;
   wire [3:0]   i_hqm_sip_rf_outbound_hcw_fifo_mem_waddr;
   wire         i_hqm_sip_rf_outbound_hcw_fifo_mem_wclk;
   wire         i_hqm_sip_rf_outbound_hcw_fifo_mem_wclk_rst_n;
   wire [159:0] i_hqm_sip_rf_outbound_hcw_fifo_mem_wdata;
   wire         i_hqm_sip_rf_outbound_hcw_fifo_mem_we;
   wire [2:0]   i_hqm_sip_rf_qed_chp_sch_data_raddr;
   wire         i_hqm_sip_rf_qed_chp_sch_data_rclk;
   wire         i_hqm_sip_rf_qed_chp_sch_data_rclk_rst_n;
   wire         i_hqm_sip_rf_qed_chp_sch_data_re;
   wire [2:0]   i_hqm_sip_rf_qed_chp_sch_data_waddr;
   wire         i_hqm_sip_rf_qed_chp_sch_data_wclk;
   wire         i_hqm_sip_rf_qed_chp_sch_data_wclk_rst_n;
   wire [176:0] i_hqm_sip_rf_qed_chp_sch_data_wdata;
   wire         i_hqm_sip_rf_qed_chp_sch_data_we;
   wire [1:0]   i_hqm_sip_rf_qed_chp_sch_flid_ret_rx_sync_mem_raddr;
   wire         i_hqm_sip_rf_qed_chp_sch_flid_ret_rx_sync_mem_rclk;
   wire         i_hqm_sip_rf_qed_chp_sch_flid_ret_rx_sync_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_qed_chp_sch_flid_ret_rx_sync_mem_re;
   wire [1:0]   i_hqm_sip_rf_qed_chp_sch_flid_ret_rx_sync_mem_waddr;
   wire         i_hqm_sip_rf_qed_chp_sch_flid_ret_rx_sync_mem_wclk;
   wire         i_hqm_sip_rf_qed_chp_sch_flid_ret_rx_sync_mem_wclk_rst_n;
   wire [25:0]  i_hqm_sip_rf_qed_chp_sch_flid_ret_rx_sync_mem_wdata;
   wire         i_hqm_sip_rf_qed_chp_sch_flid_ret_rx_sync_mem_we;
   wire [2:0]   i_hqm_sip_rf_qed_chp_sch_rx_sync_mem_raddr;
   wire         i_hqm_sip_rf_qed_chp_sch_rx_sync_mem_rclk;
   wire         i_hqm_sip_rf_qed_chp_sch_rx_sync_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_qed_chp_sch_rx_sync_mem_re;
   wire [2:0]   i_hqm_sip_rf_qed_chp_sch_rx_sync_mem_waddr;
   wire         i_hqm_sip_rf_qed_chp_sch_rx_sync_mem_wclk;
   wire         i_hqm_sip_rf_qed_chp_sch_rx_sync_mem_wclk_rst_n;
   wire [176:0] i_hqm_sip_rf_qed_chp_sch_rx_sync_mem_wdata;
   wire         i_hqm_sip_rf_qed_chp_sch_rx_sync_mem_we;
   wire [4:0]   i_hqm_sip_rf_qed_lsp_deq_fifo_mem_raddr;
   wire         i_hqm_sip_rf_qed_lsp_deq_fifo_mem_rclk;
   wire         i_hqm_sip_rf_qed_lsp_deq_fifo_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_qed_lsp_deq_fifo_mem_re;
   wire [4:0]   i_hqm_sip_rf_qed_lsp_deq_fifo_mem_waddr;
   wire         i_hqm_sip_rf_qed_lsp_deq_fifo_mem_wclk;
   wire         i_hqm_sip_rf_qed_lsp_deq_fifo_mem_wclk_rst_n;
   wire [8:0]   i_hqm_sip_rf_qed_lsp_deq_fifo_mem_wdata;
   wire         i_hqm_sip_rf_qed_lsp_deq_fifo_mem_we;
   wire [2:0]   i_hqm_sip_rf_qed_to_cq_fifo_mem_raddr;
   wire         i_hqm_sip_rf_qed_to_cq_fifo_mem_rclk;
   wire         i_hqm_sip_rf_qed_to_cq_fifo_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_qed_to_cq_fifo_mem_re;
   wire [2:0]   i_hqm_sip_rf_qed_to_cq_fifo_mem_waddr;
   wire         i_hqm_sip_rf_qed_to_cq_fifo_mem_wclk;
   wire         i_hqm_sip_rf_qed_to_cq_fifo_mem_wclk_rst_n;
   wire [196:0] i_hqm_sip_rf_qed_to_cq_fifo_mem_wdata;
   wire         i_hqm_sip_rf_qed_to_cq_fifo_mem_we;
   wire [4:0]   i_hqm_sip_rf_qid_aqed_active_count_mem_raddr;
   wire         i_hqm_sip_rf_qid_aqed_active_count_mem_rclk;
   wire         i_hqm_sip_rf_qid_aqed_active_count_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_qid_aqed_active_count_mem_re;
   wire [4:0]   i_hqm_sip_rf_qid_aqed_active_count_mem_waddr;
   wire         i_hqm_sip_rf_qid_aqed_active_count_mem_wclk;
   wire         i_hqm_sip_rf_qid_aqed_active_count_mem_wclk_rst_n;
   wire [13:0]  i_hqm_sip_rf_qid_aqed_active_count_mem_wdata;
   wire         i_hqm_sip_rf_qid_aqed_active_count_mem_we;
   wire [4:0]   i_hqm_sip_rf_qid_atm_active_mem_raddr;
   wire         i_hqm_sip_rf_qid_atm_active_mem_rclk;
   wire         i_hqm_sip_rf_qid_atm_active_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_qid_atm_active_mem_re;
   wire [4:0]   i_hqm_sip_rf_qid_atm_active_mem_waddr;
   wire         i_hqm_sip_rf_qid_atm_active_mem_wclk;
   wire         i_hqm_sip_rf_qid_atm_active_mem_wclk_rst_n;
   wire [16:0]  i_hqm_sip_rf_qid_atm_active_mem_wdata;
   wire         i_hqm_sip_rf_qid_atm_active_mem_we;
   wire [4:0]   i_hqm_sip_rf_qid_atm_tot_enq_cnt_mem_raddr;
   wire         i_hqm_sip_rf_qid_atm_tot_enq_cnt_mem_rclk;
   wire         i_hqm_sip_rf_qid_atm_tot_enq_cnt_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_qid_atm_tot_enq_cnt_mem_re;
   wire [4:0]   i_hqm_sip_rf_qid_atm_tot_enq_cnt_mem_waddr;
   wire         i_hqm_sip_rf_qid_atm_tot_enq_cnt_mem_wclk;
   wire         i_hqm_sip_rf_qid_atm_tot_enq_cnt_mem_wclk_rst_n;
   wire [65:0]  i_hqm_sip_rf_qid_atm_tot_enq_cnt_mem_wdata;
   wire         i_hqm_sip_rf_qid_atm_tot_enq_cnt_mem_we;
   wire [4:0]   i_hqm_sip_rf_qid_atq_enqueue_count_mem_raddr;
   wire         i_hqm_sip_rf_qid_atq_enqueue_count_mem_rclk;
   wire         i_hqm_sip_rf_qid_atq_enqueue_count_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_qid_atq_enqueue_count_mem_re;
   wire [4:0]   i_hqm_sip_rf_qid_atq_enqueue_count_mem_waddr;
   wire         i_hqm_sip_rf_qid_atq_enqueue_count_mem_wclk;
   wire         i_hqm_sip_rf_qid_atq_enqueue_count_mem_wclk_rst_n;
   wire [16:0]  i_hqm_sip_rf_qid_atq_enqueue_count_mem_wdata;
   wire         i_hqm_sip_rf_qid_atq_enqueue_count_mem_we;
   wire [5:0]   i_hqm_sip_rf_qid_dir_max_depth_mem_raddr;
   wire         i_hqm_sip_rf_qid_dir_max_depth_mem_rclk;
   wire         i_hqm_sip_rf_qid_dir_max_depth_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_qid_dir_max_depth_mem_re;
   wire [5:0]   i_hqm_sip_rf_qid_dir_max_depth_mem_waddr;
   wire         i_hqm_sip_rf_qid_dir_max_depth_mem_wclk;
   wire         i_hqm_sip_rf_qid_dir_max_depth_mem_wclk_rst_n;
   wire [14:0]  i_hqm_sip_rf_qid_dir_max_depth_mem_wdata;
   wire         i_hqm_sip_rf_qid_dir_max_depth_mem_we;
   wire [4:0]   i_hqm_sip_rf_qid_dir_replay_count_mem_raddr;
   wire         i_hqm_sip_rf_qid_dir_replay_count_mem_rclk;
   wire         i_hqm_sip_rf_qid_dir_replay_count_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_qid_dir_replay_count_mem_re;
   wire [4:0]   i_hqm_sip_rf_qid_dir_replay_count_mem_waddr;
   wire         i_hqm_sip_rf_qid_dir_replay_count_mem_wclk;
   wire         i_hqm_sip_rf_qid_dir_replay_count_mem_wclk_rst_n;
   wire [16:0]  i_hqm_sip_rf_qid_dir_replay_count_mem_wdata;
   wire         i_hqm_sip_rf_qid_dir_replay_count_mem_we;
   wire [5:0]   i_hqm_sip_rf_qid_dir_tot_enq_cnt_mem_raddr;
   wire         i_hqm_sip_rf_qid_dir_tot_enq_cnt_mem_rclk;
   wire         i_hqm_sip_rf_qid_dir_tot_enq_cnt_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_qid_dir_tot_enq_cnt_mem_re;
   wire [5:0]   i_hqm_sip_rf_qid_dir_tot_enq_cnt_mem_waddr;
   wire         i_hqm_sip_rf_qid_dir_tot_enq_cnt_mem_wclk;
   wire         i_hqm_sip_rf_qid_dir_tot_enq_cnt_mem_wclk_rst_n;
   wire [65:0]  i_hqm_sip_rf_qid_dir_tot_enq_cnt_mem_wdata;
   wire         i_hqm_sip_rf_qid_dir_tot_enq_cnt_mem_we;
   wire [4:0]   i_hqm_sip_rf_qid_ldb_enqueue_count_mem_raddr;
   wire         i_hqm_sip_rf_qid_ldb_enqueue_count_mem_rclk;
   wire         i_hqm_sip_rf_qid_ldb_enqueue_count_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_qid_ldb_enqueue_count_mem_re;
   wire [4:0]   i_hqm_sip_rf_qid_ldb_enqueue_count_mem_waddr;
   wire         i_hqm_sip_rf_qid_ldb_enqueue_count_mem_wclk;
   wire         i_hqm_sip_rf_qid_ldb_enqueue_count_mem_wclk_rst_n;
   wire [16:0]  i_hqm_sip_rf_qid_ldb_enqueue_count_mem_wdata;
   wire         i_hqm_sip_rf_qid_ldb_enqueue_count_mem_we;
   wire [4:0]   i_hqm_sip_rf_qid_ldb_inflight_count_mem_raddr;
   wire         i_hqm_sip_rf_qid_ldb_inflight_count_mem_rclk;
   wire         i_hqm_sip_rf_qid_ldb_inflight_count_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_qid_ldb_inflight_count_mem_re;
   wire [4:0]   i_hqm_sip_rf_qid_ldb_inflight_count_mem_waddr;
   wire         i_hqm_sip_rf_qid_ldb_inflight_count_mem_wclk;
   wire         i_hqm_sip_rf_qid_ldb_inflight_count_mem_wclk_rst_n;
   wire [13:0]  i_hqm_sip_rf_qid_ldb_inflight_count_mem_wdata;
   wire         i_hqm_sip_rf_qid_ldb_inflight_count_mem_we;
   wire [4:0]   i_hqm_sip_rf_qid_ldb_replay_count_mem_raddr;
   wire         i_hqm_sip_rf_qid_ldb_replay_count_mem_rclk;
   wire         i_hqm_sip_rf_qid_ldb_replay_count_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_qid_ldb_replay_count_mem_re;
   wire [4:0]   i_hqm_sip_rf_qid_ldb_replay_count_mem_waddr;
   wire         i_hqm_sip_rf_qid_ldb_replay_count_mem_wclk;
   wire         i_hqm_sip_rf_qid_ldb_replay_count_mem_wclk_rst_n;
   wire [16:0]  i_hqm_sip_rf_qid_ldb_replay_count_mem_wdata;
   wire         i_hqm_sip_rf_qid_ldb_replay_count_mem_we;
   wire [4:0]   i_hqm_sip_rf_qid_naldb_max_depth_mem_raddr;
   wire         i_hqm_sip_rf_qid_naldb_max_depth_mem_rclk;
   wire         i_hqm_sip_rf_qid_naldb_max_depth_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_qid_naldb_max_depth_mem_re;
   wire [4:0]   i_hqm_sip_rf_qid_naldb_max_depth_mem_waddr;
   wire         i_hqm_sip_rf_qid_naldb_max_depth_mem_wclk;
   wire         i_hqm_sip_rf_qid_naldb_max_depth_mem_wclk_rst_n;
   wire [14:0]  i_hqm_sip_rf_qid_naldb_max_depth_mem_wdata;
   wire         i_hqm_sip_rf_qid_naldb_max_depth_mem_we;
   wire [4:0]   i_hqm_sip_rf_qid_naldb_tot_enq_cnt_mem_raddr;
   wire         i_hqm_sip_rf_qid_naldb_tot_enq_cnt_mem_rclk;
   wire         i_hqm_sip_rf_qid_naldb_tot_enq_cnt_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_qid_naldb_tot_enq_cnt_mem_re;
   wire [4:0]   i_hqm_sip_rf_qid_naldb_tot_enq_cnt_mem_waddr;
   wire         i_hqm_sip_rf_qid_naldb_tot_enq_cnt_mem_wclk;
   wire         i_hqm_sip_rf_qid_naldb_tot_enq_cnt_mem_wclk_rst_n;
   wire [65:0]  i_hqm_sip_rf_qid_naldb_tot_enq_cnt_mem_wdata;
   wire         i_hqm_sip_rf_qid_naldb_tot_enq_cnt_mem_we;
   wire [4:0]   i_hqm_sip_rf_qid_rdylst_clamp_raddr;
   wire         i_hqm_sip_rf_qid_rdylst_clamp_rclk;
   wire         i_hqm_sip_rf_qid_rdylst_clamp_rclk_rst_n;
   wire         i_hqm_sip_rf_qid_rdylst_clamp_re;
   wire [4:0]   i_hqm_sip_rf_qid_rdylst_clamp_waddr;
   wire         i_hqm_sip_rf_qid_rdylst_clamp_wclk;
   wire         i_hqm_sip_rf_qid_rdylst_clamp_wclk_rst_n;
   wire [5:0]   i_hqm_sip_rf_qid_rdylst_clamp_wdata;
   wire         i_hqm_sip_rf_qid_rdylst_clamp_we;
   wire [10:0]  i_hqm_sip_rf_reord_cnt_mem_raddr;
   wire         i_hqm_sip_rf_reord_cnt_mem_rclk;
   wire         i_hqm_sip_rf_reord_cnt_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_reord_cnt_mem_re;
   wire [10:0]  i_hqm_sip_rf_reord_cnt_mem_waddr;
   wire         i_hqm_sip_rf_reord_cnt_mem_wclk;
   wire         i_hqm_sip_rf_reord_cnt_mem_wclk_rst_n;
   wire [15:0]  i_hqm_sip_rf_reord_cnt_mem_wdata;
   wire         i_hqm_sip_rf_reord_cnt_mem_we;
   wire [10:0]  i_hqm_sip_rf_reord_dirhp_mem_raddr;
   wire         i_hqm_sip_rf_reord_dirhp_mem_rclk;
   wire         i_hqm_sip_rf_reord_dirhp_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_reord_dirhp_mem_re;
   wire [10:0]  i_hqm_sip_rf_reord_dirhp_mem_waddr;
   wire         i_hqm_sip_rf_reord_dirhp_mem_wclk;
   wire         i_hqm_sip_rf_reord_dirhp_mem_wclk_rst_n;
   wire [16:0]  i_hqm_sip_rf_reord_dirhp_mem_wdata;
   wire         i_hqm_sip_rf_reord_dirhp_mem_we;
   wire [10:0]  i_hqm_sip_rf_reord_dirtp_mem_raddr;
   wire         i_hqm_sip_rf_reord_dirtp_mem_rclk;
   wire         i_hqm_sip_rf_reord_dirtp_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_reord_dirtp_mem_re;
   wire [10:0]  i_hqm_sip_rf_reord_dirtp_mem_waddr;
   wire         i_hqm_sip_rf_reord_dirtp_mem_wclk;
   wire         i_hqm_sip_rf_reord_dirtp_mem_wclk_rst_n;
   wire [16:0]  i_hqm_sip_rf_reord_dirtp_mem_wdata;
   wire         i_hqm_sip_rf_reord_dirtp_mem_we;
   wire [10:0]  i_hqm_sip_rf_reord_lbhp_mem_raddr;
   wire         i_hqm_sip_rf_reord_lbhp_mem_rclk;
   wire         i_hqm_sip_rf_reord_lbhp_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_reord_lbhp_mem_re;
   wire [10:0]  i_hqm_sip_rf_reord_lbhp_mem_waddr;
   wire         i_hqm_sip_rf_reord_lbhp_mem_wclk;
   wire         i_hqm_sip_rf_reord_lbhp_mem_wclk_rst_n;
   wire [16:0]  i_hqm_sip_rf_reord_lbhp_mem_wdata;
   wire         i_hqm_sip_rf_reord_lbhp_mem_we;
   wire [10:0]  i_hqm_sip_rf_reord_lbtp_mem_raddr;
   wire         i_hqm_sip_rf_reord_lbtp_mem_rclk;
   wire         i_hqm_sip_rf_reord_lbtp_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_reord_lbtp_mem_re;
   wire [10:0]  i_hqm_sip_rf_reord_lbtp_mem_waddr;
   wire         i_hqm_sip_rf_reord_lbtp_mem_wclk;
   wire         i_hqm_sip_rf_reord_lbtp_mem_wclk_rst_n;
   wire [16:0]  i_hqm_sip_rf_reord_lbtp_mem_wdata;
   wire         i_hqm_sip_rf_reord_lbtp_mem_we;
   wire [10:0]  i_hqm_sip_rf_reord_st_mem_raddr;
   wire         i_hqm_sip_rf_reord_st_mem_rclk;
   wire         i_hqm_sip_rf_reord_st_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_reord_st_mem_re;
   wire [10:0]  i_hqm_sip_rf_reord_st_mem_waddr;
   wire         i_hqm_sip_rf_reord_st_mem_wclk;
   wire         i_hqm_sip_rf_reord_st_mem_wclk_rst_n;
   wire [24:0]  i_hqm_sip_rf_reord_st_mem_wdata;
   wire         i_hqm_sip_rf_reord_st_mem_we;
   wire [2:0]   i_hqm_sip_rf_ri_tlq_fifo_npdata_raddr;
   wire         i_hqm_sip_rf_ri_tlq_fifo_npdata_rclk;
   wire         i_hqm_sip_rf_ri_tlq_fifo_npdata_rclk_rst_n;
   wire         i_hqm_sip_rf_ri_tlq_fifo_npdata_re;
   wire [2:0]   i_hqm_sip_rf_ri_tlq_fifo_npdata_waddr;
   wire         i_hqm_sip_rf_ri_tlq_fifo_npdata_wclk;
   wire         i_hqm_sip_rf_ri_tlq_fifo_npdata_wclk_rst_n;
   wire [32:0]  i_hqm_sip_rf_ri_tlq_fifo_npdata_wdata;
   wire         i_hqm_sip_rf_ri_tlq_fifo_npdata_we;
   wire [2:0]   i_hqm_sip_rf_ri_tlq_fifo_nphdr_raddr;
   wire         i_hqm_sip_rf_ri_tlq_fifo_nphdr_rclk;
   wire         i_hqm_sip_rf_ri_tlq_fifo_nphdr_rclk_rst_n;
   wire         i_hqm_sip_rf_ri_tlq_fifo_nphdr_re;
   wire [2:0]   i_hqm_sip_rf_ri_tlq_fifo_nphdr_waddr;
   wire         i_hqm_sip_rf_ri_tlq_fifo_nphdr_wclk;
   wire         i_hqm_sip_rf_ri_tlq_fifo_nphdr_wclk_rst_n;
   wire [157:0] i_hqm_sip_rf_ri_tlq_fifo_nphdr_wdata;
   wire         i_hqm_sip_rf_ri_tlq_fifo_nphdr_we;
   wire [4:0]   i_hqm_sip_rf_ri_tlq_fifo_pdata_raddr;
   wire         i_hqm_sip_rf_ri_tlq_fifo_pdata_rclk;
   wire         i_hqm_sip_rf_ri_tlq_fifo_pdata_rclk_rst_n;
   wire         i_hqm_sip_rf_ri_tlq_fifo_pdata_re;
   wire [4:0]   i_hqm_sip_rf_ri_tlq_fifo_pdata_waddr;
   wire         i_hqm_sip_rf_ri_tlq_fifo_pdata_wclk;
   wire         i_hqm_sip_rf_ri_tlq_fifo_pdata_wclk_rst_n;
   wire [263:0] i_hqm_sip_rf_ri_tlq_fifo_pdata_wdata;
   wire         i_hqm_sip_rf_ri_tlq_fifo_pdata_we;
   wire [3:0]   i_hqm_sip_rf_ri_tlq_fifo_phdr_raddr;
   wire         i_hqm_sip_rf_ri_tlq_fifo_phdr_rclk;
   wire         i_hqm_sip_rf_ri_tlq_fifo_phdr_rclk_rst_n;
   wire         i_hqm_sip_rf_ri_tlq_fifo_phdr_re;
   wire [3:0]   i_hqm_sip_rf_ri_tlq_fifo_phdr_waddr;
   wire         i_hqm_sip_rf_ri_tlq_fifo_phdr_wclk;
   wire         i_hqm_sip_rf_ri_tlq_fifo_phdr_wclk_rst_n;
   wire [152:0] i_hqm_sip_rf_ri_tlq_fifo_phdr_wdata;
   wire         i_hqm_sip_rf_ri_tlq_fifo_phdr_we;
   wire [1:0]   i_hqm_sip_rf_rop_chp_rop_hcw_fifo_mem_raddr;
   wire         i_hqm_sip_rf_rop_chp_rop_hcw_fifo_mem_rclk;
   wire         i_hqm_sip_rf_rop_chp_rop_hcw_fifo_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_rop_chp_rop_hcw_fifo_mem_re;
   wire [1:0]   i_hqm_sip_rf_rop_chp_rop_hcw_fifo_mem_waddr;
   wire         i_hqm_sip_rf_rop_chp_rop_hcw_fifo_mem_wclk;
   wire         i_hqm_sip_rf_rop_chp_rop_hcw_fifo_mem_wclk_rst_n;
   wire [203:0] i_hqm_sip_rf_rop_chp_rop_hcw_fifo_mem_wdata;
   wire         i_hqm_sip_rf_rop_chp_rop_hcw_fifo_mem_we;
   wire [1:0]   i_hqm_sip_rf_rop_dp_enq_dir_raddr;
   wire         i_hqm_sip_rf_rop_dp_enq_dir_rclk;
   wire         i_hqm_sip_rf_rop_dp_enq_dir_rclk_rst_n;
   wire         i_hqm_sip_rf_rop_dp_enq_dir_re;
   wire [1:0]   i_hqm_sip_rf_rop_dp_enq_dir_waddr;
   wire         i_hqm_sip_rf_rop_dp_enq_dir_wclk;
   wire         i_hqm_sip_rf_rop_dp_enq_dir_wclk_rst_n;
   wire [99:0]  i_hqm_sip_rf_rop_dp_enq_dir_wdata;
   wire         i_hqm_sip_rf_rop_dp_enq_dir_we;
   wire [1:0]   i_hqm_sip_rf_rop_dp_enq_ro_raddr;
   wire         i_hqm_sip_rf_rop_dp_enq_ro_rclk;
   wire         i_hqm_sip_rf_rop_dp_enq_ro_rclk_rst_n;
   wire         i_hqm_sip_rf_rop_dp_enq_ro_re;
   wire [1:0]   i_hqm_sip_rf_rop_dp_enq_ro_waddr;
   wire         i_hqm_sip_rf_rop_dp_enq_ro_wclk;
   wire         i_hqm_sip_rf_rop_dp_enq_ro_wclk_rst_n;
   wire [99:0]  i_hqm_sip_rf_rop_dp_enq_ro_wdata;
   wire         i_hqm_sip_rf_rop_dp_enq_ro_we;
   wire [2:0]   i_hqm_sip_rf_rop_lsp_reordercmp_rx_sync_fifo_mem_raddr;
   wire         i_hqm_sip_rf_rop_lsp_reordercmp_rx_sync_fifo_mem_rclk;
   wire         i_hqm_sip_rf_rop_lsp_reordercmp_rx_sync_fifo_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_rop_lsp_reordercmp_rx_sync_fifo_mem_re;
   wire [2:0]   i_hqm_sip_rf_rop_lsp_reordercmp_rx_sync_fifo_mem_waddr;
   wire         i_hqm_sip_rf_rop_lsp_reordercmp_rx_sync_fifo_mem_wclk;
   wire         i_hqm_sip_rf_rop_lsp_reordercmp_rx_sync_fifo_mem_wclk_rst_n;
   wire [16:0]  i_hqm_sip_rf_rop_lsp_reordercmp_rx_sync_fifo_mem_wdata;
   wire         i_hqm_sip_rf_rop_lsp_reordercmp_rx_sync_fifo_mem_we;
   wire [1:0]   i_hqm_sip_rf_rop_nalb_enq_ro_raddr;
   wire         i_hqm_sip_rf_rop_nalb_enq_ro_rclk;
   wire         i_hqm_sip_rf_rop_nalb_enq_ro_rclk_rst_n;
   wire         i_hqm_sip_rf_rop_nalb_enq_ro_re;
   wire [1:0]   i_hqm_sip_rf_rop_nalb_enq_ro_waddr;
   wire         i_hqm_sip_rf_rop_nalb_enq_ro_wclk;
   wire         i_hqm_sip_rf_rop_nalb_enq_ro_wclk_rst_n;
   wire [99:0]  i_hqm_sip_rf_rop_nalb_enq_ro_wdata;
   wire         i_hqm_sip_rf_rop_nalb_enq_ro_we;
   wire [1:0]   i_hqm_sip_rf_rop_nalb_enq_unoord_raddr;
   wire         i_hqm_sip_rf_rop_nalb_enq_unoord_rclk;
   wire         i_hqm_sip_rf_rop_nalb_enq_unoord_rclk_rst_n;
   wire         i_hqm_sip_rf_rop_nalb_enq_unoord_re;
   wire [1:0]   i_hqm_sip_rf_rop_nalb_enq_unoord_waddr;
   wire         i_hqm_sip_rf_rop_nalb_enq_unoord_wclk;
   wire         i_hqm_sip_rf_rop_nalb_enq_unoord_wclk_rst_n;
   wire [99:0]  i_hqm_sip_rf_rop_nalb_enq_unoord_wdata;
   wire         i_hqm_sip_rf_rop_nalb_enq_unoord_we;
   wire [1:0]   i_hqm_sip_rf_rx_sync_dp_dqed_data_raddr;
   wire         i_hqm_sip_rf_rx_sync_dp_dqed_data_rclk;
   wire         i_hqm_sip_rf_rx_sync_dp_dqed_data_rclk_rst_n;
   wire         i_hqm_sip_rf_rx_sync_dp_dqed_data_re;
   wire [1:0]   i_hqm_sip_rf_rx_sync_dp_dqed_data_waddr;
   wire         i_hqm_sip_rf_rx_sync_dp_dqed_data_wclk;
   wire         i_hqm_sip_rf_rx_sync_dp_dqed_data_wclk_rst_n;
   wire [44:0]  i_hqm_sip_rf_rx_sync_dp_dqed_data_wdata;
   wire         i_hqm_sip_rf_rx_sync_dp_dqed_data_we;
   wire [1:0]   i_hqm_sip_rf_rx_sync_lsp_dp_sch_dir_raddr;
   wire         i_hqm_sip_rf_rx_sync_lsp_dp_sch_dir_rclk;
   wire         i_hqm_sip_rf_rx_sync_lsp_dp_sch_dir_rclk_rst_n;
   wire         i_hqm_sip_rf_rx_sync_lsp_dp_sch_dir_re;
   wire [1:0]   i_hqm_sip_rf_rx_sync_lsp_dp_sch_dir_waddr;
   wire         i_hqm_sip_rf_rx_sync_lsp_dp_sch_dir_wclk;
   wire         i_hqm_sip_rf_rx_sync_lsp_dp_sch_dir_wclk_rst_n;
   wire [26:0]  i_hqm_sip_rf_rx_sync_lsp_dp_sch_dir_wdata;
   wire         i_hqm_sip_rf_rx_sync_lsp_dp_sch_dir_we;
   wire [1:0]   i_hqm_sip_rf_rx_sync_lsp_dp_sch_rorply_raddr;
   wire         i_hqm_sip_rf_rx_sync_lsp_dp_sch_rorply_rclk;
   wire         i_hqm_sip_rf_rx_sync_lsp_dp_sch_rorply_rclk_rst_n;
   wire         i_hqm_sip_rf_rx_sync_lsp_dp_sch_rorply_re;
   wire [1:0]   i_hqm_sip_rf_rx_sync_lsp_dp_sch_rorply_waddr;
   wire         i_hqm_sip_rf_rx_sync_lsp_dp_sch_rorply_wclk;
   wire         i_hqm_sip_rf_rx_sync_lsp_dp_sch_rorply_wclk_rst_n;
   wire [7:0]   i_hqm_sip_rf_rx_sync_lsp_dp_sch_rorply_wdata;
   wire         i_hqm_sip_rf_rx_sync_lsp_dp_sch_rorply_we;
   wire [1:0]   i_hqm_sip_rf_rx_sync_lsp_nalb_sch_atq_raddr;
   wire         i_hqm_sip_rf_rx_sync_lsp_nalb_sch_atq_rclk;
   wire         i_hqm_sip_rf_rx_sync_lsp_nalb_sch_atq_rclk_rst_n;
   wire         i_hqm_sip_rf_rx_sync_lsp_nalb_sch_atq_re;
   wire [1:0]   i_hqm_sip_rf_rx_sync_lsp_nalb_sch_atq_waddr;
   wire         i_hqm_sip_rf_rx_sync_lsp_nalb_sch_atq_wclk;
   wire         i_hqm_sip_rf_rx_sync_lsp_nalb_sch_atq_wclk_rst_n;
   wire [7:0]   i_hqm_sip_rf_rx_sync_lsp_nalb_sch_atq_wdata;
   wire         i_hqm_sip_rf_rx_sync_lsp_nalb_sch_atq_we;
   wire [1:0]   i_hqm_sip_rf_rx_sync_lsp_nalb_sch_rorply_raddr;
   wire         i_hqm_sip_rf_rx_sync_lsp_nalb_sch_rorply_rclk;
   wire         i_hqm_sip_rf_rx_sync_lsp_nalb_sch_rorply_rclk_rst_n;
   wire         i_hqm_sip_rf_rx_sync_lsp_nalb_sch_rorply_re;
   wire [1:0]   i_hqm_sip_rf_rx_sync_lsp_nalb_sch_rorply_waddr;
   wire         i_hqm_sip_rf_rx_sync_lsp_nalb_sch_rorply_wclk;
   wire         i_hqm_sip_rf_rx_sync_lsp_nalb_sch_rorply_wclk_rst_n;
   wire [7:0]   i_hqm_sip_rf_rx_sync_lsp_nalb_sch_rorply_wdata;
   wire         i_hqm_sip_rf_rx_sync_lsp_nalb_sch_rorply_we;
   wire [1:0]   i_hqm_sip_rf_rx_sync_lsp_nalb_sch_unoord_raddr;
   wire         i_hqm_sip_rf_rx_sync_lsp_nalb_sch_unoord_rclk;
   wire         i_hqm_sip_rf_rx_sync_lsp_nalb_sch_unoord_rclk_rst_n;
   wire         i_hqm_sip_rf_rx_sync_lsp_nalb_sch_unoord_re;
   wire [1:0]   i_hqm_sip_rf_rx_sync_lsp_nalb_sch_unoord_waddr;
   wire         i_hqm_sip_rf_rx_sync_lsp_nalb_sch_unoord_wclk;
   wire         i_hqm_sip_rf_rx_sync_lsp_nalb_sch_unoord_wclk_rst_n;
   wire [26:0]  i_hqm_sip_rf_rx_sync_lsp_nalb_sch_unoord_wdata;
   wire         i_hqm_sip_rf_rx_sync_lsp_nalb_sch_unoord_we;
   wire [1:0]   i_hqm_sip_rf_rx_sync_nalb_qed_data_raddr;
   wire         i_hqm_sip_rf_rx_sync_nalb_qed_data_rclk;
   wire         i_hqm_sip_rf_rx_sync_nalb_qed_data_rclk_rst_n;
   wire         i_hqm_sip_rf_rx_sync_nalb_qed_data_re;
   wire [1:0]   i_hqm_sip_rf_rx_sync_nalb_qed_data_waddr;
   wire         i_hqm_sip_rf_rx_sync_nalb_qed_data_wclk;
   wire         i_hqm_sip_rf_rx_sync_nalb_qed_data_wclk_rst_n;
   wire [44:0]  i_hqm_sip_rf_rx_sync_nalb_qed_data_wdata;
   wire         i_hqm_sip_rf_rx_sync_nalb_qed_data_we;
   wire [1:0]   i_hqm_sip_rf_rx_sync_qed_aqed_enq_raddr;
   wire         i_hqm_sip_rf_rx_sync_qed_aqed_enq_rclk;
   wire         i_hqm_sip_rf_rx_sync_qed_aqed_enq_rclk_rst_n;
   wire         i_hqm_sip_rf_rx_sync_qed_aqed_enq_re;
   wire [1:0]   i_hqm_sip_rf_rx_sync_qed_aqed_enq_waddr;
   wire         i_hqm_sip_rf_rx_sync_qed_aqed_enq_wclk;
   wire         i_hqm_sip_rf_rx_sync_qed_aqed_enq_wclk_rst_n;
   wire [138:0] i_hqm_sip_rf_rx_sync_qed_aqed_enq_wdata;
   wire         i_hqm_sip_rf_rx_sync_qed_aqed_enq_we;
   wire [1:0]   i_hqm_sip_rf_rx_sync_rop_dp_enq_raddr;
   wire         i_hqm_sip_rf_rx_sync_rop_dp_enq_rclk;
   wire         i_hqm_sip_rf_rx_sync_rop_dp_enq_rclk_rst_n;
   wire         i_hqm_sip_rf_rx_sync_rop_dp_enq_re;
   wire [1:0]   i_hqm_sip_rf_rx_sync_rop_dp_enq_waddr;
   wire         i_hqm_sip_rf_rx_sync_rop_dp_enq_wclk;
   wire         i_hqm_sip_rf_rx_sync_rop_dp_enq_wclk_rst_n;
   wire [99:0]  i_hqm_sip_rf_rx_sync_rop_dp_enq_wdata;
   wire         i_hqm_sip_rf_rx_sync_rop_dp_enq_we;
   wire [1:0]   i_hqm_sip_rf_rx_sync_rop_nalb_enq_raddr;
   wire         i_hqm_sip_rf_rx_sync_rop_nalb_enq_rclk;
   wire         i_hqm_sip_rf_rx_sync_rop_nalb_enq_rclk_rst_n;
   wire         i_hqm_sip_rf_rx_sync_rop_nalb_enq_re;
   wire [1:0]   i_hqm_sip_rf_rx_sync_rop_nalb_enq_waddr;
   wire         i_hqm_sip_rf_rx_sync_rop_nalb_enq_wclk;
   wire         i_hqm_sip_rf_rx_sync_rop_nalb_enq_wclk_rst_n;
   wire [99:0]  i_hqm_sip_rf_rx_sync_rop_nalb_enq_wdata;
   wire         i_hqm_sip_rf_rx_sync_rop_nalb_enq_we;
   wire [1:0]   i_hqm_sip_rf_rx_sync_rop_qed_dqed_enq_raddr;
   wire         i_hqm_sip_rf_rx_sync_rop_qed_dqed_enq_rclk;
   wire         i_hqm_sip_rf_rx_sync_rop_qed_dqed_enq_rclk_rst_n;
   wire         i_hqm_sip_rf_rx_sync_rop_qed_dqed_enq_re;
   wire [1:0]   i_hqm_sip_rf_rx_sync_rop_qed_dqed_enq_waddr;
   wire         i_hqm_sip_rf_rx_sync_rop_qed_dqed_enq_wclk;
   wire         i_hqm_sip_rf_rx_sync_rop_qed_dqed_enq_wclk_rst_n;
   wire [156:0] i_hqm_sip_rf_rx_sync_rop_qed_dqed_enq_wdata;
   wire         i_hqm_sip_rf_rx_sync_rop_qed_dqed_enq_we;
   wire [6:0]   i_hqm_sip_rf_sch_out_fifo_raddr;
   wire         i_hqm_sip_rf_sch_out_fifo_rclk;
   wire         i_hqm_sip_rf_sch_out_fifo_rclk_rst_n;
   wire         i_hqm_sip_rf_sch_out_fifo_re;
   wire [6:0]   i_hqm_sip_rf_sch_out_fifo_waddr;
   wire         i_hqm_sip_rf_sch_out_fifo_wclk;
   wire         i_hqm_sip_rf_sch_out_fifo_wclk_rst_n;
   wire [269:0] i_hqm_sip_rf_sch_out_fifo_wdata;
   wire         i_hqm_sip_rf_sch_out_fifo_we;
   wire [7:0]   i_hqm_sip_rf_scrbd_mem_raddr;
   wire         i_hqm_sip_rf_scrbd_mem_rclk;
   wire         i_hqm_sip_rf_scrbd_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_scrbd_mem_re;
   wire [7:0]   i_hqm_sip_rf_scrbd_mem_waddr;
   wire         i_hqm_sip_rf_scrbd_mem_wclk;
   wire         i_hqm_sip_rf_scrbd_mem_wclk_rst_n;
   wire [9:0]   i_hqm_sip_rf_scrbd_mem_wdata;
   wire         i_hqm_sip_rf_scrbd_mem_we;
   wire [1:0]   i_hqm_sip_rf_send_atm_to_cq_rx_sync_fifo_mem_raddr;
   wire         i_hqm_sip_rf_send_atm_to_cq_rx_sync_fifo_mem_rclk;
   wire         i_hqm_sip_rf_send_atm_to_cq_rx_sync_fifo_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_send_atm_to_cq_rx_sync_fifo_mem_re;
   wire [1:0]   i_hqm_sip_rf_send_atm_to_cq_rx_sync_fifo_mem_waddr;
   wire         i_hqm_sip_rf_send_atm_to_cq_rx_sync_fifo_mem_wclk;
   wire         i_hqm_sip_rf_send_atm_to_cq_rx_sync_fifo_mem_wclk_rst_n;
   wire [34:0]  i_hqm_sip_rf_send_atm_to_cq_rx_sync_fifo_mem_wdata;
   wire         i_hqm_sip_rf_send_atm_to_cq_rx_sync_fifo_mem_we;
   wire [3:0]   i_hqm_sip_rf_sn0_order_shft_mem_raddr;
   wire         i_hqm_sip_rf_sn0_order_shft_mem_rclk;
   wire         i_hqm_sip_rf_sn0_order_shft_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_sn0_order_shft_mem_re;
   wire [3:0]   i_hqm_sip_rf_sn0_order_shft_mem_waddr;
   wire         i_hqm_sip_rf_sn0_order_shft_mem_wclk;
   wire         i_hqm_sip_rf_sn0_order_shft_mem_wclk_rst_n;
   wire [11:0]  i_hqm_sip_rf_sn0_order_shft_mem_wdata;
   wire         i_hqm_sip_rf_sn0_order_shft_mem_we;
   wire [3:0]   i_hqm_sip_rf_sn1_order_shft_mem_raddr;
   wire         i_hqm_sip_rf_sn1_order_shft_mem_rclk;
   wire         i_hqm_sip_rf_sn1_order_shft_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_sn1_order_shft_mem_re;
   wire [3:0]   i_hqm_sip_rf_sn1_order_shft_mem_waddr;
   wire         i_hqm_sip_rf_sn1_order_shft_mem_wclk;
   wire         i_hqm_sip_rf_sn1_order_shft_mem_wclk_rst_n;
   wire [11:0]  i_hqm_sip_rf_sn1_order_shft_mem_wdata;
   wire         i_hqm_sip_rf_sn1_order_shft_mem_we;
   wire [1:0]   i_hqm_sip_rf_sn_complete_fifo_mem_raddr;
   wire         i_hqm_sip_rf_sn_complete_fifo_mem_rclk;
   wire         i_hqm_sip_rf_sn_complete_fifo_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_sn_complete_fifo_mem_re;
   wire [1:0]   i_hqm_sip_rf_sn_complete_fifo_mem_waddr;
   wire         i_hqm_sip_rf_sn_complete_fifo_mem_wclk;
   wire         i_hqm_sip_rf_sn_complete_fifo_mem_wclk_rst_n;
   wire [20:0]  i_hqm_sip_rf_sn_complete_fifo_mem_wdata;
   wire         i_hqm_sip_rf_sn_complete_fifo_mem_we;
   wire [4:0]   i_hqm_sip_rf_sn_ordered_fifo_mem_raddr;
   wire         i_hqm_sip_rf_sn_ordered_fifo_mem_rclk;
   wire         i_hqm_sip_rf_sn_ordered_fifo_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_sn_ordered_fifo_mem_re;
   wire [4:0]   i_hqm_sip_rf_sn_ordered_fifo_mem_waddr;
   wire         i_hqm_sip_rf_sn_ordered_fifo_mem_wclk;
   wire         i_hqm_sip_rf_sn_ordered_fifo_mem_wclk_rst_n;
   wire [12:0]  i_hqm_sip_rf_sn_ordered_fifo_mem_wdata;
   wire         i_hqm_sip_rf_sn_ordered_fifo_mem_we;
   wire [5:0]   i_hqm_sip_rf_threshold_r_pipe_dir_mem_raddr;
   wire         i_hqm_sip_rf_threshold_r_pipe_dir_mem_rclk;
   wire         i_hqm_sip_rf_threshold_r_pipe_dir_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_threshold_r_pipe_dir_mem_re;
   wire [5:0]   i_hqm_sip_rf_threshold_r_pipe_dir_mem_waddr;
   wire         i_hqm_sip_rf_threshold_r_pipe_dir_mem_wclk;
   wire         i_hqm_sip_rf_threshold_r_pipe_dir_mem_wclk_rst_n;
   wire [13:0]  i_hqm_sip_rf_threshold_r_pipe_dir_mem_wdata;
   wire         i_hqm_sip_rf_threshold_r_pipe_dir_mem_we;
   wire [5:0]   i_hqm_sip_rf_threshold_r_pipe_ldb_mem_raddr;
   wire         i_hqm_sip_rf_threshold_r_pipe_ldb_mem_rclk;
   wire         i_hqm_sip_rf_threshold_r_pipe_ldb_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_threshold_r_pipe_ldb_mem_re;
   wire [5:0]   i_hqm_sip_rf_threshold_r_pipe_ldb_mem_waddr;
   wire         i_hqm_sip_rf_threshold_r_pipe_ldb_mem_wclk;
   wire         i_hqm_sip_rf_threshold_r_pipe_ldb_mem_wclk_rst_n;
   wire [13:0]  i_hqm_sip_rf_threshold_r_pipe_ldb_mem_wdata;
   wire         i_hqm_sip_rf_threshold_r_pipe_ldb_mem_we;
   wire [3:0]   i_hqm_sip_rf_tlb_data0_4k_raddr;
   wire         i_hqm_sip_rf_tlb_data0_4k_rclk;
   wire         i_hqm_sip_rf_tlb_data0_4k_rclk_rst_n;
   wire         i_hqm_sip_rf_tlb_data0_4k_re;
   wire [3:0]   i_hqm_sip_rf_tlb_data0_4k_waddr;
   wire         i_hqm_sip_rf_tlb_data0_4k_wclk;
   wire         i_hqm_sip_rf_tlb_data0_4k_wclk_rst_n;
   wire [38:0]  i_hqm_sip_rf_tlb_data0_4k_wdata;
   wire         i_hqm_sip_rf_tlb_data0_4k_we;
   wire [3:0]   i_hqm_sip_rf_tlb_data1_4k_raddr;
   wire         i_hqm_sip_rf_tlb_data1_4k_rclk;
   wire         i_hqm_sip_rf_tlb_data1_4k_rclk_rst_n;
   wire         i_hqm_sip_rf_tlb_data1_4k_re;
   wire [3:0]   i_hqm_sip_rf_tlb_data1_4k_waddr;
   wire         i_hqm_sip_rf_tlb_data1_4k_wclk;
   wire         i_hqm_sip_rf_tlb_data1_4k_wclk_rst_n;
   wire [38:0]  i_hqm_sip_rf_tlb_data1_4k_wdata;
   wire         i_hqm_sip_rf_tlb_data1_4k_we;
   wire [3:0]   i_hqm_sip_rf_tlb_data2_4k_raddr;
   wire         i_hqm_sip_rf_tlb_data2_4k_rclk;
   wire         i_hqm_sip_rf_tlb_data2_4k_rclk_rst_n;
   wire         i_hqm_sip_rf_tlb_data2_4k_re;
   wire [3:0]   i_hqm_sip_rf_tlb_data2_4k_waddr;
   wire         i_hqm_sip_rf_tlb_data2_4k_wclk;
   wire         i_hqm_sip_rf_tlb_data2_4k_wclk_rst_n;
   wire [38:0]  i_hqm_sip_rf_tlb_data2_4k_wdata;
   wire         i_hqm_sip_rf_tlb_data2_4k_we;
   wire [3:0]   i_hqm_sip_rf_tlb_data3_4k_raddr;
   wire         i_hqm_sip_rf_tlb_data3_4k_rclk;
   wire         i_hqm_sip_rf_tlb_data3_4k_rclk_rst_n;
   wire         i_hqm_sip_rf_tlb_data3_4k_re;
   wire [3:0]   i_hqm_sip_rf_tlb_data3_4k_waddr;
   wire         i_hqm_sip_rf_tlb_data3_4k_wclk;
   wire         i_hqm_sip_rf_tlb_data3_4k_wclk_rst_n;
   wire [38:0]  i_hqm_sip_rf_tlb_data3_4k_wdata;
   wire         i_hqm_sip_rf_tlb_data3_4k_we;
   wire [3:0]   i_hqm_sip_rf_tlb_data4_4k_raddr;
   wire         i_hqm_sip_rf_tlb_data4_4k_rclk;
   wire         i_hqm_sip_rf_tlb_data4_4k_rclk_rst_n;
   wire         i_hqm_sip_rf_tlb_data4_4k_re;
   wire [3:0]   i_hqm_sip_rf_tlb_data4_4k_waddr;
   wire         i_hqm_sip_rf_tlb_data4_4k_wclk;
   wire         i_hqm_sip_rf_tlb_data4_4k_wclk_rst_n;
   wire [38:0]  i_hqm_sip_rf_tlb_data4_4k_wdata;
   wire         i_hqm_sip_rf_tlb_data4_4k_we;
   wire [3:0]   i_hqm_sip_rf_tlb_data5_4k_raddr;
   wire         i_hqm_sip_rf_tlb_data5_4k_rclk;
   wire         i_hqm_sip_rf_tlb_data5_4k_rclk_rst_n;
   wire         i_hqm_sip_rf_tlb_data5_4k_re;
   wire [3:0]   i_hqm_sip_rf_tlb_data5_4k_waddr;
   wire         i_hqm_sip_rf_tlb_data5_4k_wclk;
   wire         i_hqm_sip_rf_tlb_data5_4k_wclk_rst_n;
   wire [38:0]  i_hqm_sip_rf_tlb_data5_4k_wdata;
   wire         i_hqm_sip_rf_tlb_data5_4k_we;
   wire [3:0]   i_hqm_sip_rf_tlb_data6_4k_raddr;
   wire         i_hqm_sip_rf_tlb_data6_4k_rclk;
   wire         i_hqm_sip_rf_tlb_data6_4k_rclk_rst_n;
   wire         i_hqm_sip_rf_tlb_data6_4k_re;
   wire [3:0]   i_hqm_sip_rf_tlb_data6_4k_waddr;
   wire         i_hqm_sip_rf_tlb_data6_4k_wclk;
   wire         i_hqm_sip_rf_tlb_data6_4k_wclk_rst_n;
   wire [38:0]  i_hqm_sip_rf_tlb_data6_4k_wdata;
   wire         i_hqm_sip_rf_tlb_data6_4k_we;
   wire [3:0]   i_hqm_sip_rf_tlb_data7_4k_raddr;
   wire         i_hqm_sip_rf_tlb_data7_4k_rclk;
   wire         i_hqm_sip_rf_tlb_data7_4k_rclk_rst_n;
   wire         i_hqm_sip_rf_tlb_data7_4k_re;
   wire [3:0]   i_hqm_sip_rf_tlb_data7_4k_waddr;
   wire         i_hqm_sip_rf_tlb_data7_4k_wclk;
   wire         i_hqm_sip_rf_tlb_data7_4k_wclk_rst_n;
   wire [38:0]  i_hqm_sip_rf_tlb_data7_4k_wdata;
   wire         i_hqm_sip_rf_tlb_data7_4k_we;
   wire [3:0]   i_hqm_sip_rf_tlb_tag0_4k_raddr;
   wire         i_hqm_sip_rf_tlb_tag0_4k_rclk;
   wire         i_hqm_sip_rf_tlb_tag0_4k_rclk_rst_n;
   wire         i_hqm_sip_rf_tlb_tag0_4k_re;
   wire [3:0]   i_hqm_sip_rf_tlb_tag0_4k_waddr;
   wire         i_hqm_sip_rf_tlb_tag0_4k_wclk;
   wire         i_hqm_sip_rf_tlb_tag0_4k_wclk_rst_n;
   wire [84:0]  i_hqm_sip_rf_tlb_tag0_4k_wdata;
   wire         i_hqm_sip_rf_tlb_tag0_4k_we;
   wire [3:0]   i_hqm_sip_rf_tlb_tag1_4k_raddr;
   wire         i_hqm_sip_rf_tlb_tag1_4k_rclk;
   wire         i_hqm_sip_rf_tlb_tag1_4k_rclk_rst_n;
   wire         i_hqm_sip_rf_tlb_tag1_4k_re;
   wire [3:0]   i_hqm_sip_rf_tlb_tag1_4k_waddr;
   wire         i_hqm_sip_rf_tlb_tag1_4k_wclk;
   wire         i_hqm_sip_rf_tlb_tag1_4k_wclk_rst_n;
   wire [84:0]  i_hqm_sip_rf_tlb_tag1_4k_wdata;
   wire         i_hqm_sip_rf_tlb_tag1_4k_we;
   wire [3:0]   i_hqm_sip_rf_tlb_tag2_4k_raddr;
   wire         i_hqm_sip_rf_tlb_tag2_4k_rclk;
   wire         i_hqm_sip_rf_tlb_tag2_4k_rclk_rst_n;
   wire         i_hqm_sip_rf_tlb_tag2_4k_re;
   wire [3:0]   i_hqm_sip_rf_tlb_tag2_4k_waddr;
   wire         i_hqm_sip_rf_tlb_tag2_4k_wclk;
   wire         i_hqm_sip_rf_tlb_tag2_4k_wclk_rst_n;
   wire [84:0]  i_hqm_sip_rf_tlb_tag2_4k_wdata;
   wire         i_hqm_sip_rf_tlb_tag2_4k_we;
   wire [3:0]   i_hqm_sip_rf_tlb_tag3_4k_raddr;
   wire         i_hqm_sip_rf_tlb_tag3_4k_rclk;
   wire         i_hqm_sip_rf_tlb_tag3_4k_rclk_rst_n;
   wire         i_hqm_sip_rf_tlb_tag3_4k_re;
   wire [3:0]   i_hqm_sip_rf_tlb_tag3_4k_waddr;
   wire         i_hqm_sip_rf_tlb_tag3_4k_wclk;
   wire         i_hqm_sip_rf_tlb_tag3_4k_wclk_rst_n;
   wire [84:0]  i_hqm_sip_rf_tlb_tag3_4k_wdata;
   wire         i_hqm_sip_rf_tlb_tag3_4k_we;
   wire [3:0]   i_hqm_sip_rf_tlb_tag4_4k_raddr;
   wire         i_hqm_sip_rf_tlb_tag4_4k_rclk;
   wire         i_hqm_sip_rf_tlb_tag4_4k_rclk_rst_n;
   wire         i_hqm_sip_rf_tlb_tag4_4k_re;
   wire [3:0]   i_hqm_sip_rf_tlb_tag4_4k_waddr;
   wire         i_hqm_sip_rf_tlb_tag4_4k_wclk;
   wire         i_hqm_sip_rf_tlb_tag4_4k_wclk_rst_n;
   wire [84:0]  i_hqm_sip_rf_tlb_tag4_4k_wdata;
   wire         i_hqm_sip_rf_tlb_tag4_4k_we;
   wire [3:0]   i_hqm_sip_rf_tlb_tag5_4k_raddr;
   wire         i_hqm_sip_rf_tlb_tag5_4k_rclk;
   wire         i_hqm_sip_rf_tlb_tag5_4k_rclk_rst_n;
   wire         i_hqm_sip_rf_tlb_tag5_4k_re;
   wire [3:0]   i_hqm_sip_rf_tlb_tag5_4k_waddr;
   wire         i_hqm_sip_rf_tlb_tag5_4k_wclk;
   wire         i_hqm_sip_rf_tlb_tag5_4k_wclk_rst_n;
   wire [84:0]  i_hqm_sip_rf_tlb_tag5_4k_wdata;
   wire         i_hqm_sip_rf_tlb_tag5_4k_we;
   wire [3:0]   i_hqm_sip_rf_tlb_tag6_4k_raddr;
   wire         i_hqm_sip_rf_tlb_tag6_4k_rclk;
   wire         i_hqm_sip_rf_tlb_tag6_4k_rclk_rst_n;
   wire         i_hqm_sip_rf_tlb_tag6_4k_re;
   wire [3:0]   i_hqm_sip_rf_tlb_tag6_4k_waddr;
   wire         i_hqm_sip_rf_tlb_tag6_4k_wclk;
   wire         i_hqm_sip_rf_tlb_tag6_4k_wclk_rst_n;
   wire [84:0]  i_hqm_sip_rf_tlb_tag6_4k_wdata;
   wire         i_hqm_sip_rf_tlb_tag6_4k_we;
   wire [3:0]   i_hqm_sip_rf_tlb_tag7_4k_raddr;
   wire         i_hqm_sip_rf_tlb_tag7_4k_rclk;
   wire         i_hqm_sip_rf_tlb_tag7_4k_rclk_rst_n;
   wire         i_hqm_sip_rf_tlb_tag7_4k_re;
   wire [3:0]   i_hqm_sip_rf_tlb_tag7_4k_waddr;
   wire         i_hqm_sip_rf_tlb_tag7_4k_wclk;
   wire         i_hqm_sip_rf_tlb_tag7_4k_wclk_rst_n;
   wire [84:0]  i_hqm_sip_rf_tlb_tag7_4k_wdata;
   wire         i_hqm_sip_rf_tlb_tag7_4k_we;
   wire [2:0]   i_hqm_sip_rf_uno_atm_cmp_fifo_mem_raddr;
   wire         i_hqm_sip_rf_uno_atm_cmp_fifo_mem_rclk;
   wire         i_hqm_sip_rf_uno_atm_cmp_fifo_mem_rclk_rst_n;
   wire         i_hqm_sip_rf_uno_atm_cmp_fifo_mem_re;
   wire [2:0]   i_hqm_sip_rf_uno_atm_cmp_fifo_mem_waddr;
   wire         i_hqm_sip_rf_uno_atm_cmp_fifo_mem_wclk;
   wire         i_hqm_sip_rf_uno_atm_cmp_fifo_mem_wclk_rst_n;
   wire [19:0]  i_hqm_sip_rf_uno_atm_cmp_fifo_mem_wdata;
   wire         i_hqm_sip_rf_uno_atm_cmp_fifo_mem_we;
   wire [10:0]  i_hqm_sip_sr_aqed_addr;
   wire         i_hqm_sip_sr_aqed_clk;
   wire         i_hqm_sip_sr_aqed_clk_rst_n;
   wire [10:0]  i_hqm_sip_sr_aqed_freelist_addr;
   wire         i_hqm_sip_sr_aqed_freelist_clk;
   wire         i_hqm_sip_sr_aqed_freelist_clk_rst_n;
   wire         i_hqm_sip_sr_aqed_freelist_re;
   wire [15:0]  i_hqm_sip_sr_aqed_freelist_wdata;
   wire         i_hqm_sip_sr_aqed_freelist_we;
   wire [10:0]  i_hqm_sip_sr_aqed_ll_qe_hpnxt_addr;
   wire         i_hqm_sip_sr_aqed_ll_qe_hpnxt_clk;
   wire         i_hqm_sip_sr_aqed_ll_qe_hpnxt_clk_rst_n;
   wire         i_hqm_sip_sr_aqed_ll_qe_hpnxt_re;
   wire [15:0]  i_hqm_sip_sr_aqed_ll_qe_hpnxt_wdata;
   wire         i_hqm_sip_sr_aqed_ll_qe_hpnxt_we;
   wire         i_hqm_sip_sr_aqed_re;
   wire [138:0] i_hqm_sip_sr_aqed_wdata;
   wire         i_hqm_sip_sr_aqed_we;
   wire [13:0]  i_hqm_sip_sr_dir_nxthp_addr;
   wire         i_hqm_sip_sr_dir_nxthp_clk;
   wire         i_hqm_sip_sr_dir_nxthp_clk_rst_n;
   wire         i_hqm_sip_sr_dir_nxthp_re;
   wire [20:0]  i_hqm_sip_sr_dir_nxthp_wdata;
   wire         i_hqm_sip_sr_dir_nxthp_we;
   wire [10:0]  i_hqm_sip_sr_freelist_0_addr;
   wire         i_hqm_sip_sr_freelist_0_clk;
   wire         i_hqm_sip_sr_freelist_0_clk_rst_n;
   wire         i_hqm_sip_sr_freelist_0_re;
   wire [15:0]  i_hqm_sip_sr_freelist_0_wdata;
   wire         i_hqm_sip_sr_freelist_0_we;
   wire [10:0]  i_hqm_sip_sr_freelist_1_addr;
   wire         i_hqm_sip_sr_freelist_1_clk;
   wire         i_hqm_sip_sr_freelist_1_clk_rst_n;
   wire         i_hqm_sip_sr_freelist_1_re;
   wire [15:0]  i_hqm_sip_sr_freelist_1_wdata;
   wire         i_hqm_sip_sr_freelist_1_we;
   wire [10:0]  i_hqm_sip_sr_freelist_2_addr;
   wire         i_hqm_sip_sr_freelist_2_clk;
   wire         i_hqm_sip_sr_freelist_2_clk_rst_n;
   wire         i_hqm_sip_sr_freelist_2_re;
   wire [15:0]  i_hqm_sip_sr_freelist_2_wdata;
   wire         i_hqm_sip_sr_freelist_2_we;
   wire [10:0]  i_hqm_sip_sr_freelist_3_addr;
   wire         i_hqm_sip_sr_freelist_3_clk;
   wire         i_hqm_sip_sr_freelist_3_clk_rst_n;
   wire         i_hqm_sip_sr_freelist_3_re;
   wire [15:0]  i_hqm_sip_sr_freelist_3_wdata;
   wire         i_hqm_sip_sr_freelist_3_we;
   wire [10:0]  i_hqm_sip_sr_freelist_4_addr;
   wire         i_hqm_sip_sr_freelist_4_clk;
   wire         i_hqm_sip_sr_freelist_4_clk_rst_n;
   wire         i_hqm_sip_sr_freelist_4_re;
   wire [15:0]  i_hqm_sip_sr_freelist_4_wdata;
   wire         i_hqm_sip_sr_freelist_4_we;
   wire [10:0]  i_hqm_sip_sr_freelist_5_addr;
   wire         i_hqm_sip_sr_freelist_5_clk;
   wire         i_hqm_sip_sr_freelist_5_clk_rst_n;
   wire         i_hqm_sip_sr_freelist_5_re;
   wire [15:0]  i_hqm_sip_sr_freelist_5_wdata;
   wire         i_hqm_sip_sr_freelist_5_we;
   wire [10:0]  i_hqm_sip_sr_freelist_6_addr;
   wire         i_hqm_sip_sr_freelist_6_clk;
   wire         i_hqm_sip_sr_freelist_6_clk_rst_n;
   wire         i_hqm_sip_sr_freelist_6_re;
   wire [15:0]  i_hqm_sip_sr_freelist_6_wdata;
   wire         i_hqm_sip_sr_freelist_6_we;
   wire [10:0]  i_hqm_sip_sr_freelist_7_addr;
   wire         i_hqm_sip_sr_freelist_7_clk;
   wire         i_hqm_sip_sr_freelist_7_clk_rst_n;
   wire         i_hqm_sip_sr_freelist_7_re;
   wire [15:0]  i_hqm_sip_sr_freelist_7_wdata;
   wire         i_hqm_sip_sr_freelist_7_we;
   wire [10:0]  i_hqm_sip_sr_hist_list_a_addr;
   wire         i_hqm_sip_sr_hist_list_a_clk;
   wire         i_hqm_sip_sr_hist_list_a_clk_rst_n;
   wire         i_hqm_sip_sr_hist_list_a_re;
   wire [65:0]  i_hqm_sip_sr_hist_list_a_wdata;
   wire         i_hqm_sip_sr_hist_list_a_we;
   wire [10:0]  i_hqm_sip_sr_hist_list_addr;
   wire         i_hqm_sip_sr_hist_list_clk;
   wire         i_hqm_sip_sr_hist_list_clk_rst_n;
   wire         i_hqm_sip_sr_hist_list_re;
   wire [65:0]  i_hqm_sip_sr_hist_list_wdata;
   wire         i_hqm_sip_sr_hist_list_we;
   wire [13:0]  i_hqm_sip_sr_nalb_nxthp_addr;
   wire         i_hqm_sip_sr_nalb_nxthp_clk;
   wire         i_hqm_sip_sr_nalb_nxthp_clk_rst_n;
   wire         i_hqm_sip_sr_nalb_nxthp_re;
   wire [20:0]  i_hqm_sip_sr_nalb_nxthp_wdata;
   wire         i_hqm_sip_sr_nalb_nxthp_we;
   wire [10:0]  i_hqm_sip_sr_qed_0_addr;
   wire         i_hqm_sip_sr_qed_0_clk;
   wire         i_hqm_sip_sr_qed_0_clk_rst_n;
   wire         i_hqm_sip_sr_qed_0_re;
   wire [138:0] i_hqm_sip_sr_qed_0_wdata;
   wire         i_hqm_sip_sr_qed_0_we;
   wire [10:0]  i_hqm_sip_sr_qed_1_addr;
   wire         i_hqm_sip_sr_qed_1_clk;
   wire         i_hqm_sip_sr_qed_1_clk_rst_n;
   wire         i_hqm_sip_sr_qed_1_re;
   wire [138:0] i_hqm_sip_sr_qed_1_wdata;
   wire         i_hqm_sip_sr_qed_1_we;
   wire [10:0]  i_hqm_sip_sr_qed_2_addr;
   wire         i_hqm_sip_sr_qed_2_clk;
   wire         i_hqm_sip_sr_qed_2_clk_rst_n;
   wire         i_hqm_sip_sr_qed_2_re;
   wire [138:0] i_hqm_sip_sr_qed_2_wdata;
   wire         i_hqm_sip_sr_qed_2_we;
   wire [10:0]  i_hqm_sip_sr_qed_3_addr;
   wire         i_hqm_sip_sr_qed_3_clk;
   wire         i_hqm_sip_sr_qed_3_clk_rst_n;
   wire         i_hqm_sip_sr_qed_3_re;
   wire [138:0] i_hqm_sip_sr_qed_3_wdata;
   wire         i_hqm_sip_sr_qed_3_we;
   wire [10:0]  i_hqm_sip_sr_qed_4_addr;
   wire         i_hqm_sip_sr_qed_4_clk;
   wire         i_hqm_sip_sr_qed_4_clk_rst_n;
   wire         i_hqm_sip_sr_qed_4_re;
   wire [138:0] i_hqm_sip_sr_qed_4_wdata;
   wire         i_hqm_sip_sr_qed_4_we;
   wire [10:0]  i_hqm_sip_sr_qed_5_addr;
   wire         i_hqm_sip_sr_qed_5_clk;
   wire         i_hqm_sip_sr_qed_5_clk_rst_n;
   wire         i_hqm_sip_sr_qed_5_re;
   wire [138:0] i_hqm_sip_sr_qed_5_wdata;
   wire         i_hqm_sip_sr_qed_5_we;
   wire [10:0]  i_hqm_sip_sr_qed_6_addr;
   wire         i_hqm_sip_sr_qed_6_clk;
   wire         i_hqm_sip_sr_qed_6_clk_rst_n;
   wire         i_hqm_sip_sr_qed_6_re;
   wire [138:0] i_hqm_sip_sr_qed_6_wdata;
   wire         i_hqm_sip_sr_qed_6_we;
   wire [10:0]  i_hqm_sip_sr_qed_7_addr;
   wire         i_hqm_sip_sr_qed_7_clk;
   wire         i_hqm_sip_sr_qed_7_clk_rst_n;
   wire         i_hqm_sip_sr_qed_7_re;
   wire [138:0] i_hqm_sip_sr_qed_7_wdata;
   wire         i_hqm_sip_sr_qed_7_we;
   wire [10:0]  i_hqm_sip_sr_rob_mem_addr;
   wire         i_hqm_sip_sr_rob_mem_clk;
   wire         i_hqm_sip_sr_rob_mem_clk_rst_n;
   wire         i_hqm_sip_sr_rob_mem_re;
   wire [155:0] i_hqm_sip_sr_rob_mem_wdata;
   wire         i_hqm_sip_sr_rob_mem_we;
   wire         i_hqm_system_mem_rf_alarm_vf_synd0_pwr_enable_b_out;
   wire [29:0]  i_hqm_system_mem_rf_alarm_vf_synd0_rdata;
   wire         i_hqm_system_mem_rf_alarm_vf_synd1_pwr_enable_b_out;
   wire [31:0]  i_hqm_system_mem_rf_alarm_vf_synd1_rdata;
   wire         i_hqm_system_mem_rf_alarm_vf_synd2_pwr_enable_b_out;
   wire [31:0]  i_hqm_system_mem_rf_alarm_vf_synd2_rdata;
   wire         i_hqm_system_mem_rf_aqed_chp_sch_rx_sync_mem_pwr_enable_b_out;
   wire [178:0] i_hqm_system_mem_rf_aqed_chp_sch_rx_sync_mem_rdata;
   wire         i_hqm_system_mem_rf_chp_chp_rop_hcw_fifo_mem_pwr_enable_b_out;
   wire [200:0] i_hqm_system_mem_rf_chp_chp_rop_hcw_fifo_mem_rdata;
   wire         i_hqm_system_mem_rf_chp_lsp_ap_cmp_fifo_mem_pwr_enable_b_out;
   wire [73:0]  i_hqm_system_mem_rf_chp_lsp_ap_cmp_fifo_mem_rdata;
   wire         i_hqm_system_mem_rf_chp_lsp_tok_fifo_mem_pwr_enable_b_out;
   wire [28:0]  i_hqm_system_mem_rf_chp_lsp_tok_fifo_mem_rdata;
   wire         i_hqm_system_mem_rf_chp_sys_tx_fifo_mem_pwr_enable_b_out;
   wire [199:0] i_hqm_system_mem_rf_chp_sys_tx_fifo_mem_rdata;
   wire         i_hqm_system_mem_rf_cmp_id_chk_enbl_mem_pwr_enable_b_out;
   wire [1:0]   i_hqm_system_mem_rf_cmp_id_chk_enbl_mem_rdata;
   wire         i_hqm_system_mem_rf_count_rmw_pipe_dir_mem_pwr_enable_b_out;
   wire [15:0]  i_hqm_system_mem_rf_count_rmw_pipe_dir_mem_rdata;
   wire         i_hqm_system_mem_rf_count_rmw_pipe_ldb_mem_pwr_enable_b_out;
   wire [15:0]  i_hqm_system_mem_rf_count_rmw_pipe_ldb_mem_rdata;
   wire         i_hqm_system_mem_rf_count_rmw_pipe_wd_dir_mem_pwr_enable_b_out;
   wire [9:0]   i_hqm_system_mem_rf_count_rmw_pipe_wd_dir_mem_rdata;
   wire         i_hqm_system_mem_rf_count_rmw_pipe_wd_ldb_mem_pwr_enable_b_out;
   wire [9:0]   i_hqm_system_mem_rf_count_rmw_pipe_wd_ldb_mem_rdata;
   wire         i_hqm_system_mem_rf_dir_cq_depth_pwr_enable_b_out;
   wire [12:0]  i_hqm_system_mem_rf_dir_cq_depth_rdata;
   wire         i_hqm_system_mem_rf_dir_cq_intr_thresh_pwr_enable_b_out;
   wire [14:0]  i_hqm_system_mem_rf_dir_cq_intr_thresh_rdata;
   wire         i_hqm_system_mem_rf_dir_cq_token_depth_select_pwr_enable_b_out;
   wire [5:0]   i_hqm_system_mem_rf_dir_cq_token_depth_select_rdata;
   wire         i_hqm_system_mem_rf_dir_cq_wptr_pwr_enable_b_out;
   wire [12:0]  i_hqm_system_mem_rf_dir_cq_wptr_rdata;
   wire         i_hqm_system_mem_rf_dir_rply_req_fifo_mem_pwr_enable_b_out;
   wire [59:0]  i_hqm_system_mem_rf_dir_rply_req_fifo_mem_rdata;
   wire         i_hqm_system_mem_rf_dir_wb0_pwr_enable_b_out;
   wire [143:0] i_hqm_system_mem_rf_dir_wb0_rdata;
   wire         i_hqm_system_mem_rf_dir_wb1_pwr_enable_b_out;
   wire [143:0] i_hqm_system_mem_rf_dir_wb1_rdata;
   wire         i_hqm_system_mem_rf_dir_wb2_pwr_enable_b_out;
   wire [143:0] i_hqm_system_mem_rf_dir_wb2_rdata;
   wire         i_hqm_system_mem_rf_hcw_enq_fifo_pwr_enable_b_out;
   wire [166:0] i_hqm_system_mem_rf_hcw_enq_fifo_rdata;
   wire         i_hqm_system_mem_rf_hcw_enq_w_rx_sync_mem_pwr_enable_b_out;
   wire [159:0] i_hqm_system_mem_rf_hcw_enq_w_rx_sync_mem_rdata;
   wire         i_hqm_system_mem_rf_hist_list_a_minmax_pwr_enable_b_out;
   wire [29:0]  i_hqm_system_mem_rf_hist_list_a_minmax_rdata;
   wire         i_hqm_system_mem_rf_hist_list_a_ptr_pwr_enable_b_out;
   wire [31:0]  i_hqm_system_mem_rf_hist_list_a_ptr_rdata;
   wire         i_hqm_system_mem_rf_hist_list_minmax_pwr_enable_b_out;
   wire [29:0]  i_hqm_system_mem_rf_hist_list_minmax_rdata;
   wire         i_hqm_system_mem_rf_hist_list_ptr_pwr_enable_b_out;
   wire [31:0]  i_hqm_system_mem_rf_hist_list_ptr_rdata;
   wire [65:0]  i_hqm_system_mem_rf_ibcpl_data_fifo_rdata;
   wire [19:0]  i_hqm_system_mem_rf_ibcpl_hdr_fifo_rdata;
   wire         i_hqm_system_mem_rf_ldb_cq_depth_pwr_enable_b_out;
   wire [12:0]  i_hqm_system_mem_rf_ldb_cq_depth_rdata;
   wire         i_hqm_system_mem_rf_ldb_cq_intr_thresh_pwr_enable_b_out;
   wire [12:0]  i_hqm_system_mem_rf_ldb_cq_intr_thresh_rdata;
   wire         i_hqm_system_mem_rf_ldb_cq_on_off_threshold_pwr_enable_b_out;
   wire [31:0]  i_hqm_system_mem_rf_ldb_cq_on_off_threshold_rdata;
   wire         i_hqm_system_mem_rf_ldb_cq_token_depth_select_pwr_enable_b_out;
   wire [5:0]   i_hqm_system_mem_rf_ldb_cq_token_depth_select_rdata;
   wire         i_hqm_system_mem_rf_ldb_cq_wptr_pwr_enable_b_out;
   wire [12:0]  i_hqm_system_mem_rf_ldb_cq_wptr_rdata;
   wire         i_hqm_system_mem_rf_ldb_rply_req_fifo_mem_pwr_enable_b_out;
   wire [59:0]  i_hqm_system_mem_rf_ldb_rply_req_fifo_mem_rdata;
   wire         i_hqm_system_mem_rf_ldb_wb0_pwr_enable_b_out;
   wire [143:0] i_hqm_system_mem_rf_ldb_wb0_rdata;
   wire         i_hqm_system_mem_rf_ldb_wb1_pwr_enable_b_out;
   wire [143:0] i_hqm_system_mem_rf_ldb_wb1_rdata;
   wire         i_hqm_system_mem_rf_ldb_wb2_pwr_enable_b_out;
   wire [143:0] i_hqm_system_mem_rf_ldb_wb2_rdata;
   wire         i_hqm_system_mem_rf_lsp_reordercmp_fifo_mem_pwr_enable_b_out;
   wire [18:0]  i_hqm_system_mem_rf_lsp_reordercmp_fifo_mem_rdata;
   wire         i_hqm_system_mem_rf_lut_dir_cq2vf_pf_ro_pwr_enable_b_out;
   wire [12:0]  i_hqm_system_mem_rf_lut_dir_cq2vf_pf_ro_rdata;
   wire         i_hqm_system_mem_rf_lut_dir_cq_addr_l_pwr_enable_b_out;
   wire [26:0]  i_hqm_system_mem_rf_lut_dir_cq_addr_l_rdata;
   wire         i_hqm_system_mem_rf_lut_dir_cq_addr_u_pwr_enable_b_out;
   wire [32:0]  i_hqm_system_mem_rf_lut_dir_cq_addr_u_rdata;
   wire         i_hqm_system_mem_rf_lut_dir_cq_ai_addr_l_pwr_enable_b_out;
   wire [30:0]  i_hqm_system_mem_rf_lut_dir_cq_ai_addr_l_rdata;
   wire         i_hqm_system_mem_rf_lut_dir_cq_ai_addr_u_pwr_enable_b_out;
   wire [32:0]  i_hqm_system_mem_rf_lut_dir_cq_ai_addr_u_rdata;
   wire         i_hqm_system_mem_rf_lut_dir_cq_ai_data_pwr_enable_b_out;
   wire [32:0]  i_hqm_system_mem_rf_lut_dir_cq_ai_data_rdata;
   wire         i_hqm_system_mem_rf_lut_dir_cq_isr_pwr_enable_b_out;
   wire [12:0]  i_hqm_system_mem_rf_lut_dir_cq_isr_rdata;
   wire         i_hqm_system_mem_rf_lut_dir_cq_pasid_pwr_enable_b_out;
   wire [23:0]  i_hqm_system_mem_rf_lut_dir_cq_pasid_rdata;
   wire         i_hqm_system_mem_rf_lut_dir_pp2vas_pwr_enable_b_out;
   wire [10:0]  i_hqm_system_mem_rf_lut_dir_pp2vas_rdata;
   wire         i_hqm_system_mem_rf_lut_dir_pp_v_pwr_enable_b_out;
   wire [16:0]  i_hqm_system_mem_rf_lut_dir_pp_v_rdata;
   wire         i_hqm_system_mem_rf_lut_dir_vasqid_v_pwr_enable_b_out;
   wire [32:0]  i_hqm_system_mem_rf_lut_dir_vasqid_v_rdata;
   wire         i_hqm_system_mem_rf_lut_ldb_cq2vf_pf_ro_pwr_enable_b_out;
   wire [12:0]  i_hqm_system_mem_rf_lut_ldb_cq2vf_pf_ro_rdata;
   wire         i_hqm_system_mem_rf_lut_ldb_cq_addr_l_pwr_enable_b_out;
   wire [26:0]  i_hqm_system_mem_rf_lut_ldb_cq_addr_l_rdata;
   wire         i_hqm_system_mem_rf_lut_ldb_cq_addr_u_pwr_enable_b_out;
   wire [32:0]  i_hqm_system_mem_rf_lut_ldb_cq_addr_u_rdata;
   wire         i_hqm_system_mem_rf_lut_ldb_cq_ai_addr_l_pwr_enable_b_out;
   wire [30:0]  i_hqm_system_mem_rf_lut_ldb_cq_ai_addr_l_rdata;
   wire         i_hqm_system_mem_rf_lut_ldb_cq_ai_addr_u_pwr_enable_b_out;
   wire [32:0]  i_hqm_system_mem_rf_lut_ldb_cq_ai_addr_u_rdata;
   wire         i_hqm_system_mem_rf_lut_ldb_cq_ai_data_pwr_enable_b_out;
   wire [32:0]  i_hqm_system_mem_rf_lut_ldb_cq_ai_data_rdata;
   wire         i_hqm_system_mem_rf_lut_ldb_cq_isr_pwr_enable_b_out;
   wire [12:0]  i_hqm_system_mem_rf_lut_ldb_cq_isr_rdata;
   wire         i_hqm_system_mem_rf_lut_ldb_cq_pasid_pwr_enable_b_out;
   wire [23:0]  i_hqm_system_mem_rf_lut_ldb_cq_pasid_rdata;
   wire         i_hqm_system_mem_rf_lut_ldb_pp2vas_pwr_enable_b_out;
   wire [10:0]  i_hqm_system_mem_rf_lut_ldb_pp2vas_rdata;
   wire         i_hqm_system_mem_rf_lut_ldb_qid2vqid_pwr_enable_b_out;
   wire [20:0]  i_hqm_system_mem_rf_lut_ldb_qid2vqid_rdata;
   wire         i_hqm_system_mem_rf_lut_ldb_vasqid_v_pwr_enable_b_out;
   wire [16:0]  i_hqm_system_mem_rf_lut_ldb_vasqid_v_rdata;
   wire         i_hqm_system_mem_rf_lut_vf_dir_vpp2pp_pwr_enable_b_out;
   wire [30:0]  i_hqm_system_mem_rf_lut_vf_dir_vpp2pp_rdata;
   wire         i_hqm_system_mem_rf_lut_vf_dir_vpp_v_pwr_enable_b_out;
   wire [16:0]  i_hqm_system_mem_rf_lut_vf_dir_vpp_v_rdata;
   wire         i_hqm_system_mem_rf_lut_vf_dir_vqid2qid_pwr_enable_b_out;
   wire [30:0]  i_hqm_system_mem_rf_lut_vf_dir_vqid2qid_rdata;
   wire         i_hqm_system_mem_rf_lut_vf_dir_vqid_v_pwr_enable_b_out;
   wire [16:0]  i_hqm_system_mem_rf_lut_vf_dir_vqid_v_rdata;
   wire         i_hqm_system_mem_rf_lut_vf_ldb_vpp2pp_pwr_enable_b_out;
   wire [24:0]  i_hqm_system_mem_rf_lut_vf_ldb_vpp2pp_rdata;
   wire         i_hqm_system_mem_rf_lut_vf_ldb_vpp_v_pwr_enable_b_out;
   wire [16:0]  i_hqm_system_mem_rf_lut_vf_ldb_vpp_v_rdata;
   wire         i_hqm_system_mem_rf_lut_vf_ldb_vqid2qid_pwr_enable_b_out;
   wire [26:0]  i_hqm_system_mem_rf_lut_vf_ldb_vqid2qid_rdata;
   wire         i_hqm_system_mem_rf_lut_vf_ldb_vqid_v_pwr_enable_b_out;
   wire [16:0]  i_hqm_system_mem_rf_lut_vf_ldb_vqid_v_rdata;
   wire         i_hqm_system_mem_rf_msix_tbl_word0_pwr_enable_b_out;
   wire [32:0]  i_hqm_system_mem_rf_msix_tbl_word0_rdata;
   wire         i_hqm_system_mem_rf_msix_tbl_word1_pwr_enable_b_out;
   wire [32:0]  i_hqm_system_mem_rf_msix_tbl_word1_rdata;
   wire         i_hqm_system_mem_rf_msix_tbl_word2_pwr_enable_b_out;
   wire [32:0]  i_hqm_system_mem_rf_msix_tbl_word2_rdata;
   wire [128:0] i_hqm_system_mem_rf_mstr_ll_data0_rdata;
   wire [128:0] i_hqm_system_mem_rf_mstr_ll_data1_rdata;
   wire [128:0] i_hqm_system_mem_rf_mstr_ll_data2_rdata;
   wire [128:0] i_hqm_system_mem_rf_mstr_ll_data3_rdata;
   wire [152:0] i_hqm_system_mem_rf_mstr_ll_hdr_rdata;
   wire [34:0]  i_hqm_system_mem_rf_mstr_ll_hpa_rdata;
   wire         i_hqm_system_mem_rf_ord_qid_sn_map_pwr_enable_b_out;
   wire [11:0]  i_hqm_system_mem_rf_ord_qid_sn_map_rdata;
   wire         i_hqm_system_mem_rf_ord_qid_sn_pwr_enable_b_out;
   wire [11:0]  i_hqm_system_mem_rf_ord_qid_sn_rdata;
   wire         i_hqm_system_mem_rf_outbound_hcw_fifo_mem_pwr_enable_b_out;
   wire [159:0] i_hqm_system_mem_rf_outbound_hcw_fifo_mem_rdata;
   wire         i_hqm_system_mem_rf_qed_chp_sch_flid_ret_rx_sync_mem_pwr_enable_b_out;
   wire [25:0]  i_hqm_system_mem_rf_qed_chp_sch_flid_ret_rx_sync_mem_rdata;
   wire         i_hqm_system_mem_rf_qed_chp_sch_rx_sync_mem_pwr_enable_b_out;
   wire [176:0] i_hqm_system_mem_rf_qed_chp_sch_rx_sync_mem_rdata;
   wire         i_hqm_system_mem_rf_qed_to_cq_fifo_mem_pwr_enable_b_out;
   wire [196:0] i_hqm_system_mem_rf_qed_to_cq_fifo_mem_rdata;
   wire         i_hqm_system_mem_rf_reord_cnt_mem_pwr_enable_b_out;
   wire [15:0]  i_hqm_system_mem_rf_reord_cnt_mem_rdata;
   wire         i_hqm_system_mem_rf_reord_dirhp_mem_pwr_enable_b_out;
   wire [16:0]  i_hqm_system_mem_rf_reord_dirhp_mem_rdata;
   wire         i_hqm_system_mem_rf_reord_dirtp_mem_pwr_enable_b_out;
   wire [16:0]  i_hqm_system_mem_rf_reord_dirtp_mem_rdata;
   wire         i_hqm_system_mem_rf_reord_lbhp_mem_pwr_enable_b_out;
   wire [16:0]  i_hqm_system_mem_rf_reord_lbhp_mem_rdata;
   wire         i_hqm_system_mem_rf_reord_lbtp_mem_pwr_enable_b_out;
   wire [16:0]  i_hqm_system_mem_rf_reord_lbtp_mem_rdata;
   wire         i_hqm_system_mem_rf_reord_st_mem_pwr_enable_b_out;
   wire [24:0]  i_hqm_system_mem_rf_reord_st_mem_rdata;
   wire [32:0]  i_hqm_system_mem_rf_ri_tlq_fifo_npdata_rdata;
   wire [157:0] i_hqm_system_mem_rf_ri_tlq_fifo_nphdr_rdata;
   wire [263:0] i_hqm_system_mem_rf_ri_tlq_fifo_pdata_rdata;
   wire [152:0] i_hqm_system_mem_rf_ri_tlq_fifo_phdr_rdata;
   wire         i_hqm_system_mem_rf_rop_chp_rop_hcw_fifo_mem_pwr_enable_b_out;
   wire [203:0] i_hqm_system_mem_rf_rop_chp_rop_hcw_fifo_mem_rdata;
   wire         i_hqm_system_mem_rf_sch_out_fifo_pwr_enable_b_out;
   wire [269:0] i_hqm_system_mem_rf_sch_out_fifo_rdata;
   wire [9:0]   i_hqm_system_mem_rf_scrbd_mem_rdata;
   wire         i_hqm_system_mem_rf_sn0_order_shft_mem_pwr_enable_b_out;
   wire [11:0]  i_hqm_system_mem_rf_sn0_order_shft_mem_rdata;
   wire         i_hqm_system_mem_rf_sn1_order_shft_mem_pwr_enable_b_out;
   wire [11:0]  i_hqm_system_mem_rf_sn1_order_shft_mem_rdata;
   wire         i_hqm_system_mem_rf_sn_complete_fifo_mem_pwr_enable_b_out;
   wire [20:0]  i_hqm_system_mem_rf_sn_complete_fifo_mem_rdata;
   wire         i_hqm_system_mem_rf_sn_ordered_fifo_mem_pwr_enable_b_out;
   wire [12:0]  i_hqm_system_mem_rf_sn_ordered_fifo_mem_rdata;
   wire         i_hqm_system_mem_rf_threshold_r_pipe_dir_mem_pwr_enable_b_out;
   wire [13:0]  i_hqm_system_mem_rf_threshold_r_pipe_dir_mem_rdata;
   wire         i_hqm_system_mem_rf_threshold_r_pipe_ldb_mem_pwr_enable_b_out;
   wire [13:0]  i_hqm_system_mem_rf_threshold_r_pipe_ldb_mem_rdata;
   wire [38:0]  i_hqm_system_mem_rf_tlb_data0_4k_rdata;
   wire [38:0]  i_hqm_system_mem_rf_tlb_data1_4k_rdata;
   wire [38:0]  i_hqm_system_mem_rf_tlb_data2_4k_rdata;
   wire [38:0]  i_hqm_system_mem_rf_tlb_data3_4k_rdata;
   wire [38:0]  i_hqm_system_mem_rf_tlb_data4_4k_rdata;
   wire [38:0]  i_hqm_system_mem_rf_tlb_data5_4k_rdata;
   wire [38:0]  i_hqm_system_mem_rf_tlb_data6_4k_rdata;
   wire [38:0]  i_hqm_system_mem_rf_tlb_data7_4k_rdata;
   wire [84:0]  i_hqm_system_mem_rf_tlb_tag0_4k_rdata;
   wire [84:0]  i_hqm_system_mem_rf_tlb_tag1_4k_rdata;
   wire [84:0]  i_hqm_system_mem_rf_tlb_tag2_4k_rdata;
   wire [84:0]  i_hqm_system_mem_rf_tlb_tag3_4k_rdata;
   wire [84:0]  i_hqm_system_mem_rf_tlb_tag4_4k_rdata;
   wire [84:0]  i_hqm_system_mem_rf_tlb_tag5_4k_rdata;
   wire [84:0]  i_hqm_system_mem_rf_tlb_tag6_4k_rdata;
   wire [84:0]  i_hqm_system_mem_rf_tlb_tag7_4k_rdata;
   wire         i_hqm_system_mem_sr_freelist_0_pwr_enable_b_out;
   wire [15:0]  i_hqm_system_mem_sr_freelist_0_rdata;
   wire         i_hqm_system_mem_sr_freelist_1_pwr_enable_b_out;
   wire [15:0]  i_hqm_system_mem_sr_freelist_1_rdata;
   wire         i_hqm_system_mem_sr_freelist_2_pwr_enable_b_out;
   wire [15:0]  i_hqm_system_mem_sr_freelist_2_rdata;
   wire         i_hqm_system_mem_sr_freelist_3_pwr_enable_b_out;
   wire [15:0]  i_hqm_system_mem_sr_freelist_3_rdata;
   wire         i_hqm_system_mem_sr_freelist_4_pwr_enable_b_out;
   wire [15:0]  i_hqm_system_mem_sr_freelist_4_rdata;
   wire         i_hqm_system_mem_sr_freelist_5_pwr_enable_b_out;
   wire [15:0]  i_hqm_system_mem_sr_freelist_5_rdata;
   wire         i_hqm_system_mem_sr_freelist_6_pwr_enable_b_out;
   wire [15:0]  i_hqm_system_mem_sr_freelist_6_rdata;
   wire         i_hqm_system_mem_sr_freelist_7_pwr_enable_b_out;
   wire [15:0]  i_hqm_system_mem_sr_freelist_7_rdata;
   wire         i_hqm_system_mem_sr_hist_list_a_pwr_enable_b_out;
   wire [65:0]  i_hqm_system_mem_sr_hist_list_a_rdata;
   wire         i_hqm_system_mem_sr_hist_list_pwr_enable_b_out;
   wire [65:0]  i_hqm_system_mem_sr_hist_list_rdata;
   wire         i_hqm_system_mem_sr_rob_mem_pwr_enable_b_out;
   wire [155:0] i_hqm_system_mem_sr_rob_mem_rdata;

   hqm_list_sel_mem i_hqm_list_sel_mem
      (.bcam_AW_bcam_2048x26_wclk                                (i_hqm_sip_bcam_AW_bcam_2048x26_wclk),
       .bcam_AW_bcam_2048x26_waddr                               (i_hqm_sip_bcam_AW_bcam_2048x26_waddr),
       .bcam_AW_bcam_2048x26_we                                  (i_hqm_sip_bcam_AW_bcam_2048x26_we),
       .bcam_AW_bcam_2048x26_wdata                               (i_hqm_sip_bcam_AW_bcam_2048x26_wdata),
       .bcam_AW_bcam_2048x26_rclk                                (i_hqm_sip_bcam_AW_bcam_2048x26_rclk),
       .bcam_AW_bcam_2048x26_raddr                               (i_hqm_sip_bcam_AW_bcam_2048x26_raddr),
       .bcam_AW_bcam_2048x26_re                                  (i_hqm_sip_bcam_AW_bcam_2048x26_re),
       .bcam_AW_bcam_2048x26_rdata                               (i_hqm_list_sel_mem_bcam_AW_bcam_2048x26_rdata),
       .bcam_AW_bcam_2048x26_cclk                                (i_hqm_sip_bcam_AW_bcam_2048x26_cclk),
       .bcam_AW_bcam_2048x26_cdata                               (i_hqm_sip_bcam_AW_bcam_2048x26_cdata),
       .bcam_AW_bcam_2048x26_ce                                  (i_hqm_sip_bcam_AW_bcam_2048x26_ce),
       .bcam_AW_bcam_2048x26_cmatch                              (i_hqm_list_sel_mem_bcam_AW_bcam_2048x26_cmatch),
       .bcam_AW_bcam_2048x26_isol_en_b                           (i_hqm_sip_pgcb_isol_en_b),
       .bcam_AW_bcam_2048x26_dfx_clk                             (i_hqm_sip_bcam_AW_bcam_2048x26_dfx_clk),
       // Tie to constant value: zero
       .bcam_AW_bcam_2048x26_fd                                  (1'b0),
       // Tie to constant value: zero
       .bcam_AW_bcam_2048x26_rd                                  (1'b0),
       .rf_aqed_fid_cnt_wclk                                     (i_hqm_sip_rf_aqed_fid_cnt_wclk),
       .rf_aqed_fid_cnt_wclk_rst_n                               (i_hqm_sip_rf_aqed_fid_cnt_wclk_rst_n),
       .rf_aqed_fid_cnt_we                                       (i_hqm_sip_rf_aqed_fid_cnt_we),
       .rf_aqed_fid_cnt_waddr                                    (i_hqm_sip_rf_aqed_fid_cnt_waddr),
       .rf_aqed_fid_cnt_wdata                                    (i_hqm_sip_rf_aqed_fid_cnt_wdata),
       .rf_aqed_fid_cnt_rclk                                     (i_hqm_sip_rf_aqed_fid_cnt_rclk),
       .rf_aqed_fid_cnt_rclk_rst_n                               (i_hqm_sip_rf_aqed_fid_cnt_rclk_rst_n),
       .rf_aqed_fid_cnt_re                                       (i_hqm_sip_rf_aqed_fid_cnt_re),
       .rf_aqed_fid_cnt_raddr                                    (i_hqm_sip_rf_aqed_fid_cnt_raddr),
       .rf_aqed_fid_cnt_rdata                                    (i_hqm_list_sel_mem_rf_aqed_fid_cnt_rdata),
       .rf_aqed_fid_cnt_isol_en                                  (i_hqm_sip_pgcb_isol_en),
       .rf_aqed_fid_cnt_pwr_enable_b_in                          (i_hqm_list_sel_mem_sr_aqed_ll_qe_hpnxt_pwr_enable_b_out),
       .rf_aqed_fid_cnt_pwr_enable_b_out                         (i_hqm_list_sel_mem_rf_aqed_fid_cnt_pwr_enable_b_out),
       .rf_aqed_fifo_ap_aqed_wclk                                (i_hqm_sip_rf_aqed_fifo_ap_aqed_wclk),
       .rf_aqed_fifo_ap_aqed_wclk_rst_n                          (i_hqm_sip_rf_aqed_fifo_ap_aqed_wclk_rst_n),
       .rf_aqed_fifo_ap_aqed_we                                  (i_hqm_sip_rf_aqed_fifo_ap_aqed_we),
       .rf_aqed_fifo_ap_aqed_waddr                               (i_hqm_sip_rf_aqed_fifo_ap_aqed_waddr),
       .rf_aqed_fifo_ap_aqed_wdata                               (i_hqm_sip_rf_aqed_fifo_ap_aqed_wdata),
       .rf_aqed_fifo_ap_aqed_rclk                                (i_hqm_sip_rf_aqed_fifo_ap_aqed_rclk),
       .rf_aqed_fifo_ap_aqed_rclk_rst_n                          (i_hqm_sip_rf_aqed_fifo_ap_aqed_rclk_rst_n),
       .rf_aqed_fifo_ap_aqed_re                                  (i_hqm_sip_rf_aqed_fifo_ap_aqed_re),
       .rf_aqed_fifo_ap_aqed_raddr                               (i_hqm_sip_rf_aqed_fifo_ap_aqed_raddr),
       .rf_aqed_fifo_ap_aqed_rdata                               (i_hqm_list_sel_mem_rf_aqed_fifo_ap_aqed_rdata),
       .rf_aqed_fifo_ap_aqed_isol_en                             (i_hqm_sip_pgcb_isol_en),
       .rf_aqed_fifo_ap_aqed_pwr_enable_b_in                     (i_hqm_list_sel_mem_rf_aqed_fid_cnt_pwr_enable_b_out),
       .rf_aqed_fifo_ap_aqed_pwr_enable_b_out                    (i_hqm_list_sel_mem_rf_aqed_fifo_ap_aqed_pwr_enable_b_out),
       .rf_aqed_fifo_aqed_ap_enq_wclk                            (i_hqm_sip_rf_aqed_fifo_aqed_ap_enq_wclk),
       .rf_aqed_fifo_aqed_ap_enq_wclk_rst_n                      (i_hqm_sip_rf_aqed_fifo_aqed_ap_enq_wclk_rst_n),
       .rf_aqed_fifo_aqed_ap_enq_we                              (i_hqm_sip_rf_aqed_fifo_aqed_ap_enq_we),
       .rf_aqed_fifo_aqed_ap_enq_waddr                           (i_hqm_sip_rf_aqed_fifo_aqed_ap_enq_waddr),
       .rf_aqed_fifo_aqed_ap_enq_wdata                           (i_hqm_sip_rf_aqed_fifo_aqed_ap_enq_wdata),
       .rf_aqed_fifo_aqed_ap_enq_rclk                            (i_hqm_sip_rf_aqed_fifo_aqed_ap_enq_rclk),
       .rf_aqed_fifo_aqed_ap_enq_rclk_rst_n                      (i_hqm_sip_rf_aqed_fifo_aqed_ap_enq_rclk_rst_n),
       .rf_aqed_fifo_aqed_ap_enq_re                              (i_hqm_sip_rf_aqed_fifo_aqed_ap_enq_re),
       .rf_aqed_fifo_aqed_ap_enq_raddr                           (i_hqm_sip_rf_aqed_fifo_aqed_ap_enq_raddr),
       .rf_aqed_fifo_aqed_ap_enq_rdata                           (i_hqm_list_sel_mem_rf_aqed_fifo_aqed_ap_enq_rdata),
       .rf_aqed_fifo_aqed_ap_enq_isol_en                         (i_hqm_sip_pgcb_isol_en),
       .rf_aqed_fifo_aqed_ap_enq_pwr_enable_b_in                 (i_hqm_list_sel_mem_rf_aqed_fifo_ap_aqed_pwr_enable_b_out),
       .rf_aqed_fifo_aqed_ap_enq_pwr_enable_b_out                (i_hqm_list_sel_mem_rf_aqed_fifo_aqed_ap_enq_pwr_enable_b_out),
       .rf_aqed_fifo_aqed_chp_sch_wclk                           (i_hqm_sip_rf_aqed_fifo_aqed_chp_sch_wclk),
       .rf_aqed_fifo_aqed_chp_sch_wclk_rst_n                     (i_hqm_sip_rf_aqed_fifo_aqed_chp_sch_wclk_rst_n),
       .rf_aqed_fifo_aqed_chp_sch_we                             (i_hqm_sip_rf_aqed_fifo_aqed_chp_sch_we),
       .rf_aqed_fifo_aqed_chp_sch_waddr                          (i_hqm_sip_rf_aqed_fifo_aqed_chp_sch_waddr),
       .rf_aqed_fifo_aqed_chp_sch_wdata                          (i_hqm_sip_rf_aqed_fifo_aqed_chp_sch_wdata),
       .rf_aqed_fifo_aqed_chp_sch_rclk                           (i_hqm_sip_rf_aqed_fifo_aqed_chp_sch_rclk),
       .rf_aqed_fifo_aqed_chp_sch_rclk_rst_n                     (i_hqm_sip_rf_aqed_fifo_aqed_chp_sch_rclk_rst_n),
       .rf_aqed_fifo_aqed_chp_sch_re                             (i_hqm_sip_rf_aqed_fifo_aqed_chp_sch_re),
       .rf_aqed_fifo_aqed_chp_sch_raddr                          (i_hqm_sip_rf_aqed_fifo_aqed_chp_sch_raddr),
       .rf_aqed_fifo_aqed_chp_sch_rdata                          (i_hqm_list_sel_mem_rf_aqed_fifo_aqed_chp_sch_rdata),
       .rf_aqed_fifo_aqed_chp_sch_isol_en                        (i_hqm_sip_pgcb_isol_en),
       .rf_aqed_fifo_aqed_chp_sch_pwr_enable_b_in                (i_hqm_list_sel_mem_rf_aqed_fifo_aqed_ap_enq_pwr_enable_b_out),
       .rf_aqed_fifo_aqed_chp_sch_pwr_enable_b_out               (i_hqm_list_sel_mem_rf_aqed_fifo_aqed_chp_sch_pwr_enable_b_out),
       .rf_aqed_fifo_freelist_return_wclk                        (i_hqm_sip_rf_aqed_fifo_freelist_return_wclk),
       .rf_aqed_fifo_freelist_return_wclk_rst_n                  (i_hqm_sip_rf_aqed_fifo_freelist_return_wclk_rst_n),
       .rf_aqed_fifo_freelist_return_we                          (i_hqm_sip_rf_aqed_fifo_freelist_return_we),
       .rf_aqed_fifo_freelist_return_waddr                       (i_hqm_sip_rf_aqed_fifo_freelist_return_waddr),
       .rf_aqed_fifo_freelist_return_wdata                       (i_hqm_sip_rf_aqed_fifo_freelist_return_wdata),
       .rf_aqed_fifo_freelist_return_rclk                        (i_hqm_sip_rf_aqed_fifo_freelist_return_rclk),
       .rf_aqed_fifo_freelist_return_rclk_rst_n                  (i_hqm_sip_rf_aqed_fifo_freelist_return_rclk_rst_n),
       .rf_aqed_fifo_freelist_return_re                          (i_hqm_sip_rf_aqed_fifo_freelist_return_re),
       .rf_aqed_fifo_freelist_return_raddr                       (i_hqm_sip_rf_aqed_fifo_freelist_return_raddr),
       .rf_aqed_fifo_freelist_return_rdata                       (i_hqm_list_sel_mem_rf_aqed_fifo_freelist_return_rdata),
       .rf_aqed_fifo_freelist_return_isol_en                     (i_hqm_sip_pgcb_isol_en),
       .rf_aqed_fifo_freelist_return_pwr_enable_b_in             (i_hqm_list_sel_mem_rf_aqed_fifo_aqed_chp_sch_pwr_enable_b_out),
       .rf_aqed_fifo_freelist_return_pwr_enable_b_out            (i_hqm_list_sel_mem_rf_aqed_fifo_freelist_return_pwr_enable_b_out),
       .rf_aqed_fifo_lsp_aqed_cmp_wclk                           (i_hqm_sip_rf_aqed_fifo_lsp_aqed_cmp_wclk),
       .rf_aqed_fifo_lsp_aqed_cmp_wclk_rst_n                     (i_hqm_sip_rf_aqed_fifo_lsp_aqed_cmp_wclk_rst_n),
       .rf_aqed_fifo_lsp_aqed_cmp_we                             (i_hqm_sip_rf_aqed_fifo_lsp_aqed_cmp_we),
       .rf_aqed_fifo_lsp_aqed_cmp_waddr                          (i_hqm_sip_rf_aqed_fifo_lsp_aqed_cmp_waddr),
       .rf_aqed_fifo_lsp_aqed_cmp_wdata                          (i_hqm_sip_rf_aqed_fifo_lsp_aqed_cmp_wdata),
       .rf_aqed_fifo_lsp_aqed_cmp_rclk                           (i_hqm_sip_rf_aqed_fifo_lsp_aqed_cmp_rclk),
       .rf_aqed_fifo_lsp_aqed_cmp_rclk_rst_n                     (i_hqm_sip_rf_aqed_fifo_lsp_aqed_cmp_rclk_rst_n),
       .rf_aqed_fifo_lsp_aqed_cmp_re                             (i_hqm_sip_rf_aqed_fifo_lsp_aqed_cmp_re),
       .rf_aqed_fifo_lsp_aqed_cmp_raddr                          (i_hqm_sip_rf_aqed_fifo_lsp_aqed_cmp_raddr),
       .rf_aqed_fifo_lsp_aqed_cmp_rdata                          (i_hqm_list_sel_mem_rf_aqed_fifo_lsp_aqed_cmp_rdata),
       .rf_aqed_fifo_lsp_aqed_cmp_isol_en                        (i_hqm_sip_pgcb_isol_en),
       .rf_aqed_fifo_lsp_aqed_cmp_pwr_enable_b_in                (i_hqm_list_sel_mem_rf_aqed_fifo_freelist_return_pwr_enable_b_out),
       .rf_aqed_fifo_lsp_aqed_cmp_pwr_enable_b_out               (i_hqm_list_sel_mem_rf_aqed_fifo_lsp_aqed_cmp_pwr_enable_b_out),
       .rf_aqed_fifo_qed_aqed_enq_wclk                           (i_hqm_sip_rf_aqed_fifo_qed_aqed_enq_wclk),
       .rf_aqed_fifo_qed_aqed_enq_wclk_rst_n                     (i_hqm_sip_rf_aqed_fifo_qed_aqed_enq_wclk_rst_n),
       .rf_aqed_fifo_qed_aqed_enq_we                             (i_hqm_sip_rf_aqed_fifo_qed_aqed_enq_we),
       .rf_aqed_fifo_qed_aqed_enq_waddr                          (i_hqm_sip_rf_aqed_fifo_qed_aqed_enq_waddr),
       .rf_aqed_fifo_qed_aqed_enq_wdata                          (i_hqm_sip_rf_aqed_fifo_qed_aqed_enq_wdata),
       .rf_aqed_fifo_qed_aqed_enq_rclk                           (i_hqm_sip_rf_aqed_fifo_qed_aqed_enq_rclk),
       .rf_aqed_fifo_qed_aqed_enq_rclk_rst_n                     (i_hqm_sip_rf_aqed_fifo_qed_aqed_enq_rclk_rst_n),
       .rf_aqed_fifo_qed_aqed_enq_re                             (i_hqm_sip_rf_aqed_fifo_qed_aqed_enq_re),
       .rf_aqed_fifo_qed_aqed_enq_raddr                          (i_hqm_sip_rf_aqed_fifo_qed_aqed_enq_raddr),
       .rf_aqed_fifo_qed_aqed_enq_rdata                          (i_hqm_list_sel_mem_rf_aqed_fifo_qed_aqed_enq_rdata),
       .rf_aqed_fifo_qed_aqed_enq_isol_en                        (i_hqm_sip_pgcb_isol_en),
       .rf_aqed_fifo_qed_aqed_enq_pwr_enable_b_in                (i_hqm_list_sel_mem_rf_aqed_fifo_lsp_aqed_cmp_pwr_enable_b_out),
       .rf_aqed_fifo_qed_aqed_enq_pwr_enable_b_out               (i_hqm_list_sel_mem_rf_aqed_fifo_qed_aqed_enq_pwr_enable_b_out),
       .rf_aqed_fifo_qed_aqed_enq_fid_wclk                       (i_hqm_sip_rf_aqed_fifo_qed_aqed_enq_fid_wclk),
       .rf_aqed_fifo_qed_aqed_enq_fid_wclk_rst_n                 (i_hqm_sip_rf_aqed_fifo_qed_aqed_enq_fid_wclk_rst_n),
       .rf_aqed_fifo_qed_aqed_enq_fid_we                         (i_hqm_sip_rf_aqed_fifo_qed_aqed_enq_fid_we),
       .rf_aqed_fifo_qed_aqed_enq_fid_waddr                      (i_hqm_sip_rf_aqed_fifo_qed_aqed_enq_fid_waddr),
       .rf_aqed_fifo_qed_aqed_enq_fid_wdata                      (i_hqm_sip_rf_aqed_fifo_qed_aqed_enq_fid_wdata),
       .rf_aqed_fifo_qed_aqed_enq_fid_rclk                       (i_hqm_sip_rf_aqed_fifo_qed_aqed_enq_fid_rclk),
       .rf_aqed_fifo_qed_aqed_enq_fid_rclk_rst_n                 (i_hqm_sip_rf_aqed_fifo_qed_aqed_enq_fid_rclk_rst_n),
       .rf_aqed_fifo_qed_aqed_enq_fid_re                         (i_hqm_sip_rf_aqed_fifo_qed_aqed_enq_fid_re),
       .rf_aqed_fifo_qed_aqed_enq_fid_raddr                      (i_hqm_sip_rf_aqed_fifo_qed_aqed_enq_fid_raddr),
       .rf_aqed_fifo_qed_aqed_enq_fid_rdata                      (i_hqm_list_sel_mem_rf_aqed_fifo_qed_aqed_enq_fid_rdata),
       .rf_aqed_fifo_qed_aqed_enq_fid_isol_en                    (i_hqm_sip_pgcb_isol_en),
       .rf_aqed_fifo_qed_aqed_enq_fid_pwr_enable_b_in            (i_hqm_list_sel_mem_rf_aqed_fifo_qed_aqed_enq_pwr_enable_b_out),
       .rf_aqed_fifo_qed_aqed_enq_fid_pwr_enable_b_out           (i_hqm_list_sel_mem_rf_aqed_fifo_qed_aqed_enq_fid_pwr_enable_b_out),
       .rf_aqed_ll_cnt_pri0_wclk                                 (i_hqm_sip_rf_aqed_ll_cnt_pri0_wclk),
       .rf_aqed_ll_cnt_pri0_wclk_rst_n                           (i_hqm_sip_rf_aqed_ll_cnt_pri0_wclk_rst_n),
       .rf_aqed_ll_cnt_pri0_we                                   (i_hqm_sip_rf_aqed_ll_cnt_pri0_we),
       .rf_aqed_ll_cnt_pri0_waddr                                (i_hqm_sip_rf_aqed_ll_cnt_pri0_waddr),
       .rf_aqed_ll_cnt_pri0_wdata                                (i_hqm_sip_rf_aqed_ll_cnt_pri0_wdata),
       .rf_aqed_ll_cnt_pri0_rclk                                 (i_hqm_sip_rf_aqed_ll_cnt_pri0_rclk),
       .rf_aqed_ll_cnt_pri0_rclk_rst_n                           (i_hqm_sip_rf_aqed_ll_cnt_pri0_rclk_rst_n),
       .rf_aqed_ll_cnt_pri0_re                                   (i_hqm_sip_rf_aqed_ll_cnt_pri0_re),
       .rf_aqed_ll_cnt_pri0_raddr                                (i_hqm_sip_rf_aqed_ll_cnt_pri0_raddr),
       .rf_aqed_ll_cnt_pri0_rdata                                (i_hqm_list_sel_mem_rf_aqed_ll_cnt_pri0_rdata),
       .rf_aqed_ll_cnt_pri0_isol_en                              (i_hqm_sip_pgcb_isol_en),
       .rf_aqed_ll_cnt_pri0_pwr_enable_b_in                      (i_hqm_list_sel_mem_rf_aqed_fifo_qed_aqed_enq_fid_pwr_enable_b_out),
       .rf_aqed_ll_cnt_pri0_pwr_enable_b_out                     (i_hqm_list_sel_mem_rf_aqed_ll_cnt_pri0_pwr_enable_b_out),
       .rf_aqed_ll_cnt_pri1_wclk                                 (i_hqm_sip_rf_aqed_ll_cnt_pri1_wclk),
       .rf_aqed_ll_cnt_pri1_wclk_rst_n                           (i_hqm_sip_rf_aqed_ll_cnt_pri1_wclk_rst_n),
       .rf_aqed_ll_cnt_pri1_we                                   (i_hqm_sip_rf_aqed_ll_cnt_pri1_we),
       .rf_aqed_ll_cnt_pri1_waddr                                (i_hqm_sip_rf_aqed_ll_cnt_pri1_waddr),
       .rf_aqed_ll_cnt_pri1_wdata                                (i_hqm_sip_rf_aqed_ll_cnt_pri1_wdata),
       .rf_aqed_ll_cnt_pri1_rclk                                 (i_hqm_sip_rf_aqed_ll_cnt_pri1_rclk),
       .rf_aqed_ll_cnt_pri1_rclk_rst_n                           (i_hqm_sip_rf_aqed_ll_cnt_pri1_rclk_rst_n),
       .rf_aqed_ll_cnt_pri1_re                                   (i_hqm_sip_rf_aqed_ll_cnt_pri1_re),
       .rf_aqed_ll_cnt_pri1_raddr                                (i_hqm_sip_rf_aqed_ll_cnt_pri1_raddr),
       .rf_aqed_ll_cnt_pri1_rdata                                (i_hqm_list_sel_mem_rf_aqed_ll_cnt_pri1_rdata),
       .rf_aqed_ll_cnt_pri1_isol_en                              (i_hqm_sip_pgcb_isol_en),
       .rf_aqed_ll_cnt_pri1_pwr_enable_b_in                      (i_hqm_list_sel_mem_rf_aqed_ll_cnt_pri0_pwr_enable_b_out),
       .rf_aqed_ll_cnt_pri1_pwr_enable_b_out                     (i_hqm_list_sel_mem_rf_aqed_ll_cnt_pri1_pwr_enable_b_out),
       .rf_aqed_ll_cnt_pri2_wclk                                 (i_hqm_sip_rf_aqed_ll_cnt_pri2_wclk),
       .rf_aqed_ll_cnt_pri2_wclk_rst_n                           (i_hqm_sip_rf_aqed_ll_cnt_pri2_wclk_rst_n),
       .rf_aqed_ll_cnt_pri2_we                                   (i_hqm_sip_rf_aqed_ll_cnt_pri2_we),
       .rf_aqed_ll_cnt_pri2_waddr                                (i_hqm_sip_rf_aqed_ll_cnt_pri2_waddr),
       .rf_aqed_ll_cnt_pri2_wdata                                (i_hqm_sip_rf_aqed_ll_cnt_pri2_wdata),
       .rf_aqed_ll_cnt_pri2_rclk                                 (i_hqm_sip_rf_aqed_ll_cnt_pri2_rclk),
       .rf_aqed_ll_cnt_pri2_rclk_rst_n                           (i_hqm_sip_rf_aqed_ll_cnt_pri2_rclk_rst_n),
       .rf_aqed_ll_cnt_pri2_re                                   (i_hqm_sip_rf_aqed_ll_cnt_pri2_re),
       .rf_aqed_ll_cnt_pri2_raddr                                (i_hqm_sip_rf_aqed_ll_cnt_pri2_raddr),
       .rf_aqed_ll_cnt_pri2_rdata                                (i_hqm_list_sel_mem_rf_aqed_ll_cnt_pri2_rdata),
       .rf_aqed_ll_cnt_pri2_isol_en                              (i_hqm_sip_pgcb_isol_en),
       .rf_aqed_ll_cnt_pri2_pwr_enable_b_in                      (i_hqm_list_sel_mem_rf_aqed_ll_cnt_pri1_pwr_enable_b_out),
       .rf_aqed_ll_cnt_pri2_pwr_enable_b_out                     (i_hqm_list_sel_mem_rf_aqed_ll_cnt_pri2_pwr_enable_b_out),
       .rf_aqed_ll_cnt_pri3_wclk                                 (i_hqm_sip_rf_aqed_ll_cnt_pri3_wclk),
       .rf_aqed_ll_cnt_pri3_wclk_rst_n                           (i_hqm_sip_rf_aqed_ll_cnt_pri3_wclk_rst_n),
       .rf_aqed_ll_cnt_pri3_we                                   (i_hqm_sip_rf_aqed_ll_cnt_pri3_we),
       .rf_aqed_ll_cnt_pri3_waddr                                (i_hqm_sip_rf_aqed_ll_cnt_pri3_waddr),
       .rf_aqed_ll_cnt_pri3_wdata                                (i_hqm_sip_rf_aqed_ll_cnt_pri3_wdata),
       .rf_aqed_ll_cnt_pri3_rclk                                 (i_hqm_sip_rf_aqed_ll_cnt_pri3_rclk),
       .rf_aqed_ll_cnt_pri3_rclk_rst_n                           (i_hqm_sip_rf_aqed_ll_cnt_pri3_rclk_rst_n),
       .rf_aqed_ll_cnt_pri3_re                                   (i_hqm_sip_rf_aqed_ll_cnt_pri3_re),
       .rf_aqed_ll_cnt_pri3_raddr                                (i_hqm_sip_rf_aqed_ll_cnt_pri3_raddr),
       .rf_aqed_ll_cnt_pri3_rdata                                (i_hqm_list_sel_mem_rf_aqed_ll_cnt_pri3_rdata),
       .rf_aqed_ll_cnt_pri3_isol_en                              (i_hqm_sip_pgcb_isol_en),
       .rf_aqed_ll_cnt_pri3_pwr_enable_b_in                      (i_hqm_list_sel_mem_rf_aqed_ll_cnt_pri2_pwr_enable_b_out),
       .rf_aqed_ll_cnt_pri3_pwr_enable_b_out                     (i_hqm_list_sel_mem_rf_aqed_ll_cnt_pri3_pwr_enable_b_out),
       .rf_aqed_ll_qe_hp_pri0_wclk                               (i_hqm_sip_rf_aqed_ll_qe_hp_pri0_wclk),
       .rf_aqed_ll_qe_hp_pri0_wclk_rst_n                         (i_hqm_sip_rf_aqed_ll_qe_hp_pri0_wclk_rst_n),
       .rf_aqed_ll_qe_hp_pri0_we                                 (i_hqm_sip_rf_aqed_ll_qe_hp_pri0_we),
       .rf_aqed_ll_qe_hp_pri0_waddr                              (i_hqm_sip_rf_aqed_ll_qe_hp_pri0_waddr),
       .rf_aqed_ll_qe_hp_pri0_wdata                              (i_hqm_sip_rf_aqed_ll_qe_hp_pri0_wdata),
       .rf_aqed_ll_qe_hp_pri0_rclk                               (i_hqm_sip_rf_aqed_ll_qe_hp_pri0_rclk),
       .rf_aqed_ll_qe_hp_pri0_rclk_rst_n                         (i_hqm_sip_rf_aqed_ll_qe_hp_pri0_rclk_rst_n),
       .rf_aqed_ll_qe_hp_pri0_re                                 (i_hqm_sip_rf_aqed_ll_qe_hp_pri0_re),
       .rf_aqed_ll_qe_hp_pri0_raddr                              (i_hqm_sip_rf_aqed_ll_qe_hp_pri0_raddr),
       .rf_aqed_ll_qe_hp_pri0_rdata                              (i_hqm_list_sel_mem_rf_aqed_ll_qe_hp_pri0_rdata),
       .rf_aqed_ll_qe_hp_pri0_isol_en                            (i_hqm_sip_pgcb_isol_en),
       .rf_aqed_ll_qe_hp_pri0_pwr_enable_b_in                    (i_hqm_list_sel_mem_rf_aqed_ll_cnt_pri3_pwr_enable_b_out),
       .rf_aqed_ll_qe_hp_pri0_pwr_enable_b_out                   (i_hqm_list_sel_mem_rf_aqed_ll_qe_hp_pri0_pwr_enable_b_out),
       .rf_aqed_ll_qe_hp_pri1_wclk                               (i_hqm_sip_rf_aqed_ll_qe_hp_pri1_wclk),
       .rf_aqed_ll_qe_hp_pri1_wclk_rst_n                         (i_hqm_sip_rf_aqed_ll_qe_hp_pri1_wclk_rst_n),
       .rf_aqed_ll_qe_hp_pri1_we                                 (i_hqm_sip_rf_aqed_ll_qe_hp_pri1_we),
       .rf_aqed_ll_qe_hp_pri1_waddr                              (i_hqm_sip_rf_aqed_ll_qe_hp_pri1_waddr),
       .rf_aqed_ll_qe_hp_pri1_wdata                              (i_hqm_sip_rf_aqed_ll_qe_hp_pri1_wdata),
       .rf_aqed_ll_qe_hp_pri1_rclk                               (i_hqm_sip_rf_aqed_ll_qe_hp_pri1_rclk),
       .rf_aqed_ll_qe_hp_pri1_rclk_rst_n                         (i_hqm_sip_rf_aqed_ll_qe_hp_pri1_rclk_rst_n),
       .rf_aqed_ll_qe_hp_pri1_re                                 (i_hqm_sip_rf_aqed_ll_qe_hp_pri1_re),
       .rf_aqed_ll_qe_hp_pri1_raddr                              (i_hqm_sip_rf_aqed_ll_qe_hp_pri1_raddr),
       .rf_aqed_ll_qe_hp_pri1_rdata                              (i_hqm_list_sel_mem_rf_aqed_ll_qe_hp_pri1_rdata),
       .rf_aqed_ll_qe_hp_pri1_isol_en                            (i_hqm_sip_pgcb_isol_en),
       .rf_aqed_ll_qe_hp_pri1_pwr_enable_b_in                    (i_hqm_list_sel_mem_rf_aqed_ll_qe_hp_pri0_pwr_enable_b_out),
       .rf_aqed_ll_qe_hp_pri1_pwr_enable_b_out                   (i_hqm_list_sel_mem_rf_aqed_ll_qe_hp_pri1_pwr_enable_b_out),
       .rf_aqed_ll_qe_hp_pri2_wclk                               (i_hqm_sip_rf_aqed_ll_qe_hp_pri2_wclk),
       .rf_aqed_ll_qe_hp_pri2_wclk_rst_n                         (i_hqm_sip_rf_aqed_ll_qe_hp_pri2_wclk_rst_n),
       .rf_aqed_ll_qe_hp_pri2_we                                 (i_hqm_sip_rf_aqed_ll_qe_hp_pri2_we),
       .rf_aqed_ll_qe_hp_pri2_waddr                              (i_hqm_sip_rf_aqed_ll_qe_hp_pri2_waddr),
       .rf_aqed_ll_qe_hp_pri2_wdata                              (i_hqm_sip_rf_aqed_ll_qe_hp_pri2_wdata),
       .rf_aqed_ll_qe_hp_pri2_rclk                               (i_hqm_sip_rf_aqed_ll_qe_hp_pri2_rclk),
       .rf_aqed_ll_qe_hp_pri2_rclk_rst_n                         (i_hqm_sip_rf_aqed_ll_qe_hp_pri2_rclk_rst_n),
       .rf_aqed_ll_qe_hp_pri2_re                                 (i_hqm_sip_rf_aqed_ll_qe_hp_pri2_re),
       .rf_aqed_ll_qe_hp_pri2_raddr                              (i_hqm_sip_rf_aqed_ll_qe_hp_pri2_raddr),
       .rf_aqed_ll_qe_hp_pri2_rdata                              (i_hqm_list_sel_mem_rf_aqed_ll_qe_hp_pri2_rdata),
       .rf_aqed_ll_qe_hp_pri2_isol_en                            (i_hqm_sip_pgcb_isol_en),
       .rf_aqed_ll_qe_hp_pri2_pwr_enable_b_in                    (i_hqm_list_sel_mem_rf_aqed_ll_qe_hp_pri1_pwr_enable_b_out),
       .rf_aqed_ll_qe_hp_pri2_pwr_enable_b_out                   (i_hqm_list_sel_mem_rf_aqed_ll_qe_hp_pri2_pwr_enable_b_out),
       .rf_aqed_ll_qe_hp_pri3_wclk                               (i_hqm_sip_rf_aqed_ll_qe_hp_pri3_wclk),
       .rf_aqed_ll_qe_hp_pri3_wclk_rst_n                         (i_hqm_sip_rf_aqed_ll_qe_hp_pri3_wclk_rst_n),
       .rf_aqed_ll_qe_hp_pri3_we                                 (i_hqm_sip_rf_aqed_ll_qe_hp_pri3_we),
       .rf_aqed_ll_qe_hp_pri3_waddr                              (i_hqm_sip_rf_aqed_ll_qe_hp_pri3_waddr),
       .rf_aqed_ll_qe_hp_pri3_wdata                              (i_hqm_sip_rf_aqed_ll_qe_hp_pri3_wdata),
       .rf_aqed_ll_qe_hp_pri3_rclk                               (i_hqm_sip_rf_aqed_ll_qe_hp_pri3_rclk),
       .rf_aqed_ll_qe_hp_pri3_rclk_rst_n                         (i_hqm_sip_rf_aqed_ll_qe_hp_pri3_rclk_rst_n),
       .rf_aqed_ll_qe_hp_pri3_re                                 (i_hqm_sip_rf_aqed_ll_qe_hp_pri3_re),
       .rf_aqed_ll_qe_hp_pri3_raddr                              (i_hqm_sip_rf_aqed_ll_qe_hp_pri3_raddr),
       .rf_aqed_ll_qe_hp_pri3_rdata                              (i_hqm_list_sel_mem_rf_aqed_ll_qe_hp_pri3_rdata),
       .rf_aqed_ll_qe_hp_pri3_isol_en                            (i_hqm_sip_pgcb_isol_en),
       .rf_aqed_ll_qe_hp_pri3_pwr_enable_b_in                    (i_hqm_list_sel_mem_rf_aqed_ll_qe_hp_pri2_pwr_enable_b_out),
       .rf_aqed_ll_qe_hp_pri3_pwr_enable_b_out                   (i_hqm_list_sel_mem_rf_aqed_ll_qe_hp_pri3_pwr_enable_b_out),
       .rf_aqed_ll_qe_tp_pri0_wclk                               (i_hqm_sip_rf_aqed_ll_qe_tp_pri0_wclk),
       .rf_aqed_ll_qe_tp_pri0_wclk_rst_n                         (i_hqm_sip_rf_aqed_ll_qe_tp_pri0_wclk_rst_n),
       .rf_aqed_ll_qe_tp_pri0_we                                 (i_hqm_sip_rf_aqed_ll_qe_tp_pri0_we),
       .rf_aqed_ll_qe_tp_pri0_waddr                              (i_hqm_sip_rf_aqed_ll_qe_tp_pri0_waddr),
       .rf_aqed_ll_qe_tp_pri0_wdata                              (i_hqm_sip_rf_aqed_ll_qe_tp_pri0_wdata),
       .rf_aqed_ll_qe_tp_pri0_rclk                               (i_hqm_sip_rf_aqed_ll_qe_tp_pri0_rclk),
       .rf_aqed_ll_qe_tp_pri0_rclk_rst_n                         (i_hqm_sip_rf_aqed_ll_qe_tp_pri0_rclk_rst_n),
       .rf_aqed_ll_qe_tp_pri0_re                                 (i_hqm_sip_rf_aqed_ll_qe_tp_pri0_re),
       .rf_aqed_ll_qe_tp_pri0_raddr                              (i_hqm_sip_rf_aqed_ll_qe_tp_pri0_raddr),
       .rf_aqed_ll_qe_tp_pri0_rdata                              (i_hqm_list_sel_mem_rf_aqed_ll_qe_tp_pri0_rdata),
       .rf_aqed_ll_qe_tp_pri0_isol_en                            (i_hqm_sip_pgcb_isol_en),
       .rf_aqed_ll_qe_tp_pri0_pwr_enable_b_in                    (i_hqm_list_sel_mem_rf_aqed_ll_qe_hp_pri3_pwr_enable_b_out),
       .rf_aqed_ll_qe_tp_pri0_pwr_enable_b_out                   (i_hqm_list_sel_mem_rf_aqed_ll_qe_tp_pri0_pwr_enable_b_out),
       .rf_aqed_ll_qe_tp_pri1_wclk                               (i_hqm_sip_rf_aqed_ll_qe_tp_pri1_wclk),
       .rf_aqed_ll_qe_tp_pri1_wclk_rst_n                         (i_hqm_sip_rf_aqed_ll_qe_tp_pri1_wclk_rst_n),
       .rf_aqed_ll_qe_tp_pri1_we                                 (i_hqm_sip_rf_aqed_ll_qe_tp_pri1_we),
       .rf_aqed_ll_qe_tp_pri1_waddr                              (i_hqm_sip_rf_aqed_ll_qe_tp_pri1_waddr),
       .rf_aqed_ll_qe_tp_pri1_wdata                              (i_hqm_sip_rf_aqed_ll_qe_tp_pri1_wdata),
       .rf_aqed_ll_qe_tp_pri1_rclk                               (i_hqm_sip_rf_aqed_ll_qe_tp_pri1_rclk),
       .rf_aqed_ll_qe_tp_pri1_rclk_rst_n                         (i_hqm_sip_rf_aqed_ll_qe_tp_pri1_rclk_rst_n),
       .rf_aqed_ll_qe_tp_pri1_re                                 (i_hqm_sip_rf_aqed_ll_qe_tp_pri1_re),
       .rf_aqed_ll_qe_tp_pri1_raddr                              (i_hqm_sip_rf_aqed_ll_qe_tp_pri1_raddr),
       .rf_aqed_ll_qe_tp_pri1_rdata                              (i_hqm_list_sel_mem_rf_aqed_ll_qe_tp_pri1_rdata),
       .rf_aqed_ll_qe_tp_pri1_isol_en                            (i_hqm_sip_pgcb_isol_en),
       .rf_aqed_ll_qe_tp_pri1_pwr_enable_b_in                    (i_hqm_list_sel_mem_rf_aqed_ll_qe_tp_pri0_pwr_enable_b_out),
       .rf_aqed_ll_qe_tp_pri1_pwr_enable_b_out                   (i_hqm_list_sel_mem_rf_aqed_ll_qe_tp_pri1_pwr_enable_b_out),
       .rf_aqed_ll_qe_tp_pri2_wclk                               (i_hqm_sip_rf_aqed_ll_qe_tp_pri2_wclk),
       .rf_aqed_ll_qe_tp_pri2_wclk_rst_n                         (i_hqm_sip_rf_aqed_ll_qe_tp_pri2_wclk_rst_n),
       .rf_aqed_ll_qe_tp_pri2_we                                 (i_hqm_sip_rf_aqed_ll_qe_tp_pri2_we),
       .rf_aqed_ll_qe_tp_pri2_waddr                              (i_hqm_sip_rf_aqed_ll_qe_tp_pri2_waddr),
       .rf_aqed_ll_qe_tp_pri2_wdata                              (i_hqm_sip_rf_aqed_ll_qe_tp_pri2_wdata),
       .rf_aqed_ll_qe_tp_pri2_rclk                               (i_hqm_sip_rf_aqed_ll_qe_tp_pri2_rclk),
       .rf_aqed_ll_qe_tp_pri2_rclk_rst_n                         (i_hqm_sip_rf_aqed_ll_qe_tp_pri2_rclk_rst_n),
       .rf_aqed_ll_qe_tp_pri2_re                                 (i_hqm_sip_rf_aqed_ll_qe_tp_pri2_re),
       .rf_aqed_ll_qe_tp_pri2_raddr                              (i_hqm_sip_rf_aqed_ll_qe_tp_pri2_raddr),
       .rf_aqed_ll_qe_tp_pri2_rdata                              (i_hqm_list_sel_mem_rf_aqed_ll_qe_tp_pri2_rdata),
       .rf_aqed_ll_qe_tp_pri2_isol_en                            (i_hqm_sip_pgcb_isol_en),
       .rf_aqed_ll_qe_tp_pri2_pwr_enable_b_in                    (i_hqm_list_sel_mem_rf_aqed_ll_qe_tp_pri1_pwr_enable_b_out),
       .rf_aqed_ll_qe_tp_pri2_pwr_enable_b_out                   (i_hqm_list_sel_mem_rf_aqed_ll_qe_tp_pri2_pwr_enable_b_out),
       .rf_aqed_ll_qe_tp_pri3_wclk                               (i_hqm_sip_rf_aqed_ll_qe_tp_pri3_wclk),
       .rf_aqed_ll_qe_tp_pri3_wclk_rst_n                         (i_hqm_sip_rf_aqed_ll_qe_tp_pri3_wclk_rst_n),
       .rf_aqed_ll_qe_tp_pri3_we                                 (i_hqm_sip_rf_aqed_ll_qe_tp_pri3_we),
       .rf_aqed_ll_qe_tp_pri3_waddr                              (i_hqm_sip_rf_aqed_ll_qe_tp_pri3_waddr),
       .rf_aqed_ll_qe_tp_pri3_wdata                              (i_hqm_sip_rf_aqed_ll_qe_tp_pri3_wdata),
       .rf_aqed_ll_qe_tp_pri3_rclk                               (i_hqm_sip_rf_aqed_ll_qe_tp_pri3_rclk),
       .rf_aqed_ll_qe_tp_pri3_rclk_rst_n                         (i_hqm_sip_rf_aqed_ll_qe_tp_pri3_rclk_rst_n),
       .rf_aqed_ll_qe_tp_pri3_re                                 (i_hqm_sip_rf_aqed_ll_qe_tp_pri3_re),
       .rf_aqed_ll_qe_tp_pri3_raddr                              (i_hqm_sip_rf_aqed_ll_qe_tp_pri3_raddr),
       .rf_aqed_ll_qe_tp_pri3_rdata                              (i_hqm_list_sel_mem_rf_aqed_ll_qe_tp_pri3_rdata),
       .rf_aqed_ll_qe_tp_pri3_isol_en                            (i_hqm_sip_pgcb_isol_en),
       .rf_aqed_ll_qe_tp_pri3_pwr_enable_b_in                    (i_hqm_list_sel_mem_rf_aqed_ll_qe_tp_pri2_pwr_enable_b_out),
       .rf_aqed_ll_qe_tp_pri3_pwr_enable_b_out                   (i_hqm_list_sel_mem_rf_aqed_ll_qe_tp_pri3_pwr_enable_b_out),
       .rf_aqed_lsp_deq_fifo_mem_wclk                            (i_hqm_sip_rf_aqed_lsp_deq_fifo_mem_wclk),
       .rf_aqed_lsp_deq_fifo_mem_wclk_rst_n                      (i_hqm_sip_rf_aqed_lsp_deq_fifo_mem_wclk_rst_n),
       .rf_aqed_lsp_deq_fifo_mem_we                              (i_hqm_sip_rf_aqed_lsp_deq_fifo_mem_we),
       .rf_aqed_lsp_deq_fifo_mem_waddr                           (i_hqm_sip_rf_aqed_lsp_deq_fifo_mem_waddr),
       .rf_aqed_lsp_deq_fifo_mem_wdata                           (i_hqm_sip_rf_aqed_lsp_deq_fifo_mem_wdata),
       .rf_aqed_lsp_deq_fifo_mem_rclk                            (i_hqm_sip_rf_aqed_lsp_deq_fifo_mem_rclk),
       .rf_aqed_lsp_deq_fifo_mem_rclk_rst_n                      (i_hqm_sip_rf_aqed_lsp_deq_fifo_mem_rclk_rst_n),
       .rf_aqed_lsp_deq_fifo_mem_re                              (i_hqm_sip_rf_aqed_lsp_deq_fifo_mem_re),
       .rf_aqed_lsp_deq_fifo_mem_raddr                           (i_hqm_sip_rf_aqed_lsp_deq_fifo_mem_raddr),
       .rf_aqed_lsp_deq_fifo_mem_rdata                           (i_hqm_list_sel_mem_rf_aqed_lsp_deq_fifo_mem_rdata),
       .rf_aqed_lsp_deq_fifo_mem_isol_en                         (i_hqm_sip_pgcb_isol_en),
       .rf_aqed_lsp_deq_fifo_mem_pwr_enable_b_in                 (i_hqm_list_sel_mem_rf_aqed_ll_qe_tp_pri3_pwr_enable_b_out),
       .rf_aqed_lsp_deq_fifo_mem_pwr_enable_b_out                (i_hqm_list_sel_mem_rf_aqed_lsp_deq_fifo_mem_pwr_enable_b_out),
       .rf_aqed_qid2cqidix_wclk                                  (i_hqm_sip_rf_aqed_qid2cqidix_wclk),
       .rf_aqed_qid2cqidix_wclk_rst_n                            (i_hqm_sip_rf_aqed_qid2cqidix_wclk_rst_n),
       .rf_aqed_qid2cqidix_we                                    (i_hqm_sip_rf_aqed_qid2cqidix_we),
       .rf_aqed_qid2cqidix_waddr                                 (i_hqm_sip_rf_aqed_qid2cqidix_waddr),
       .rf_aqed_qid2cqidix_wdata                                 (i_hqm_sip_rf_aqed_qid2cqidix_wdata),
       .rf_aqed_qid2cqidix_rclk                                  (i_hqm_sip_rf_aqed_qid2cqidix_rclk),
       .rf_aqed_qid2cqidix_rclk_rst_n                            (i_hqm_sip_rf_aqed_qid2cqidix_rclk_rst_n),
       .rf_aqed_qid2cqidix_re                                    (i_hqm_sip_rf_aqed_qid2cqidix_re),
       .rf_aqed_qid2cqidix_raddr                                 (i_hqm_sip_rf_aqed_qid2cqidix_raddr),
       .rf_aqed_qid2cqidix_rdata                                 (i_hqm_list_sel_mem_rf_aqed_qid2cqidix_rdata),
       .rf_aqed_qid2cqidix_isol_en                               (i_hqm_sip_pgcb_isol_en),
       .rf_aqed_qid2cqidix_pwr_enable_b_in                       (i_hqm_list_sel_mem_rf_aqed_lsp_deq_fifo_mem_pwr_enable_b_out),
       .rf_aqed_qid2cqidix_pwr_enable_b_out                      (i_hqm_list_sel_mem_rf_aqed_qid2cqidix_pwr_enable_b_out),
       .rf_aqed_qid_cnt_wclk                                     (i_hqm_sip_rf_aqed_qid_cnt_wclk),
       .rf_aqed_qid_cnt_wclk_rst_n                               (i_hqm_sip_rf_aqed_qid_cnt_wclk_rst_n),
       .rf_aqed_qid_cnt_we                                       (i_hqm_sip_rf_aqed_qid_cnt_we),
       .rf_aqed_qid_cnt_waddr                                    (i_hqm_sip_rf_aqed_qid_cnt_waddr),
       .rf_aqed_qid_cnt_wdata                                    (i_hqm_sip_rf_aqed_qid_cnt_wdata),
       .rf_aqed_qid_cnt_rclk                                     (i_hqm_sip_rf_aqed_qid_cnt_rclk),
       .rf_aqed_qid_cnt_rclk_rst_n                               (i_hqm_sip_rf_aqed_qid_cnt_rclk_rst_n),
       .rf_aqed_qid_cnt_re                                       (i_hqm_sip_rf_aqed_qid_cnt_re),
       .rf_aqed_qid_cnt_raddr                                    (i_hqm_sip_rf_aqed_qid_cnt_raddr),
       .rf_aqed_qid_cnt_rdata                                    (i_hqm_list_sel_mem_rf_aqed_qid_cnt_rdata),
       .rf_aqed_qid_cnt_isol_en                                  (i_hqm_sip_pgcb_isol_en),
       .rf_aqed_qid_cnt_pwr_enable_b_in                          (i_hqm_list_sel_mem_rf_aqed_qid2cqidix_pwr_enable_b_out),
       .rf_aqed_qid_cnt_pwr_enable_b_out                         (i_hqm_list_sel_mem_rf_aqed_qid_cnt_pwr_enable_b_out),
       .rf_aqed_qid_fid_limit_wclk                               (i_hqm_sip_rf_aqed_qid_fid_limit_wclk),
       .rf_aqed_qid_fid_limit_wclk_rst_n                         (i_hqm_sip_rf_aqed_qid_fid_limit_wclk_rst_n),
       .rf_aqed_qid_fid_limit_we                                 (i_hqm_sip_rf_aqed_qid_fid_limit_we),
       .rf_aqed_qid_fid_limit_waddr                              (i_hqm_sip_rf_aqed_qid_fid_limit_waddr),
       .rf_aqed_qid_fid_limit_wdata                              (i_hqm_sip_rf_aqed_qid_fid_limit_wdata),
       .rf_aqed_qid_fid_limit_rclk                               (i_hqm_sip_rf_aqed_qid_fid_limit_rclk),
       .rf_aqed_qid_fid_limit_rclk_rst_n                         (i_hqm_sip_rf_aqed_qid_fid_limit_rclk_rst_n),
       .rf_aqed_qid_fid_limit_re                                 (i_hqm_sip_rf_aqed_qid_fid_limit_re),
       .rf_aqed_qid_fid_limit_raddr                              (i_hqm_sip_rf_aqed_qid_fid_limit_raddr),
       .rf_aqed_qid_fid_limit_rdata                              (i_hqm_list_sel_mem_rf_aqed_qid_fid_limit_rdata),
       .rf_aqed_qid_fid_limit_isol_en                            (i_hqm_sip_pgcb_isol_en),
       .rf_aqed_qid_fid_limit_pwr_enable_b_in                    (i_hqm_list_sel_mem_rf_aqed_qid_cnt_pwr_enable_b_out),
       .rf_aqed_qid_fid_limit_pwr_enable_b_out                   (i_hqm_list_sel_mem_rf_aqed_qid_fid_limit_pwr_enable_b_out),
       .rf_atm_cmp_fifo_mem_wclk                                 (i_hqm_sip_rf_atm_cmp_fifo_mem_wclk),
       .rf_atm_cmp_fifo_mem_wclk_rst_n                           (i_hqm_sip_rf_atm_cmp_fifo_mem_wclk_rst_n),
       .rf_atm_cmp_fifo_mem_we                                   (i_hqm_sip_rf_atm_cmp_fifo_mem_we),
       .rf_atm_cmp_fifo_mem_waddr                                (i_hqm_sip_rf_atm_cmp_fifo_mem_waddr),
       .rf_atm_cmp_fifo_mem_wdata                                (i_hqm_sip_rf_atm_cmp_fifo_mem_wdata),
       .rf_atm_cmp_fifo_mem_rclk                                 (i_hqm_sip_rf_atm_cmp_fifo_mem_rclk),
       .rf_atm_cmp_fifo_mem_rclk_rst_n                           (i_hqm_sip_rf_atm_cmp_fifo_mem_rclk_rst_n),
       .rf_atm_cmp_fifo_mem_re                                   (i_hqm_sip_rf_atm_cmp_fifo_mem_re),
       .rf_atm_cmp_fifo_mem_raddr                                (i_hqm_sip_rf_atm_cmp_fifo_mem_raddr),
       .rf_atm_cmp_fifo_mem_rdata                                (i_hqm_list_sel_mem_rf_atm_cmp_fifo_mem_rdata),
       .rf_atm_cmp_fifo_mem_isol_en                              (i_hqm_sip_pgcb_isol_en),
       .rf_atm_cmp_fifo_mem_pwr_enable_b_in                      (i_hqm_list_sel_mem_rf_aqed_qid_fid_limit_pwr_enable_b_out),
       .rf_atm_cmp_fifo_mem_pwr_enable_b_out                     (i_hqm_list_sel_mem_rf_atm_cmp_fifo_mem_pwr_enable_b_out),
       .rf_atm_fifo_ap_aqed_wclk                                 (i_hqm_sip_rf_atm_fifo_ap_aqed_wclk),
       .rf_atm_fifo_ap_aqed_wclk_rst_n                           (i_hqm_sip_rf_atm_fifo_ap_aqed_wclk_rst_n),
       .rf_atm_fifo_ap_aqed_we                                   (i_hqm_sip_rf_atm_fifo_ap_aqed_we),
       .rf_atm_fifo_ap_aqed_waddr                                (i_hqm_sip_rf_atm_fifo_ap_aqed_waddr),
       .rf_atm_fifo_ap_aqed_wdata                                (i_hqm_sip_rf_atm_fifo_ap_aqed_wdata),
       .rf_atm_fifo_ap_aqed_rclk                                 (i_hqm_sip_rf_atm_fifo_ap_aqed_rclk),
       .rf_atm_fifo_ap_aqed_rclk_rst_n                           (i_hqm_sip_rf_atm_fifo_ap_aqed_rclk_rst_n),
       .rf_atm_fifo_ap_aqed_re                                   (i_hqm_sip_rf_atm_fifo_ap_aqed_re),
       .rf_atm_fifo_ap_aqed_raddr                                (i_hqm_sip_rf_atm_fifo_ap_aqed_raddr),
       .rf_atm_fifo_ap_aqed_rdata                                (i_hqm_list_sel_mem_rf_atm_fifo_ap_aqed_rdata),
       .rf_atm_fifo_ap_aqed_isol_en                              (i_hqm_sip_pgcb_isol_en),
       .rf_atm_fifo_ap_aqed_pwr_enable_b_in                      (i_hqm_list_sel_mem_rf_atm_cmp_fifo_mem_pwr_enable_b_out),
       .rf_atm_fifo_ap_aqed_pwr_enable_b_out                     (i_hqm_list_sel_mem_rf_atm_fifo_ap_aqed_pwr_enable_b_out),
       .rf_atm_fifo_aqed_ap_enq_wclk                             (i_hqm_sip_rf_atm_fifo_aqed_ap_enq_wclk),
       .rf_atm_fifo_aqed_ap_enq_wclk_rst_n                       (i_hqm_sip_rf_atm_fifo_aqed_ap_enq_wclk_rst_n),
       .rf_atm_fifo_aqed_ap_enq_we                               (i_hqm_sip_rf_atm_fifo_aqed_ap_enq_we),
       .rf_atm_fifo_aqed_ap_enq_waddr                            (i_hqm_sip_rf_atm_fifo_aqed_ap_enq_waddr),
       .rf_atm_fifo_aqed_ap_enq_wdata                            (i_hqm_sip_rf_atm_fifo_aqed_ap_enq_wdata),
       .rf_atm_fifo_aqed_ap_enq_rclk                             (i_hqm_sip_rf_atm_fifo_aqed_ap_enq_rclk),
       .rf_atm_fifo_aqed_ap_enq_rclk_rst_n                       (i_hqm_sip_rf_atm_fifo_aqed_ap_enq_rclk_rst_n),
       .rf_atm_fifo_aqed_ap_enq_re                               (i_hqm_sip_rf_atm_fifo_aqed_ap_enq_re),
       .rf_atm_fifo_aqed_ap_enq_raddr                            (i_hqm_sip_rf_atm_fifo_aqed_ap_enq_raddr),
       .rf_atm_fifo_aqed_ap_enq_rdata                            (i_hqm_list_sel_mem_rf_atm_fifo_aqed_ap_enq_rdata),
       .rf_atm_fifo_aqed_ap_enq_isol_en                          (i_hqm_sip_pgcb_isol_en),
       .rf_atm_fifo_aqed_ap_enq_pwr_enable_b_in                  (i_hqm_list_sel_mem_rf_atm_fifo_ap_aqed_pwr_enable_b_out),
       .rf_atm_fifo_aqed_ap_enq_pwr_enable_b_out                 (i_hqm_list_sel_mem_rf_atm_fifo_aqed_ap_enq_pwr_enable_b_out),
       .rf_cfg_atm_qid_dpth_thrsh_mem_wclk                       (i_hqm_sip_rf_cfg_atm_qid_dpth_thrsh_mem_wclk),
       .rf_cfg_atm_qid_dpth_thrsh_mem_wclk_rst_n                 (i_hqm_sip_rf_cfg_atm_qid_dpth_thrsh_mem_wclk_rst_n),
       .rf_cfg_atm_qid_dpth_thrsh_mem_we                         (i_hqm_sip_rf_cfg_atm_qid_dpth_thrsh_mem_we),
       .rf_cfg_atm_qid_dpth_thrsh_mem_waddr                      (i_hqm_sip_rf_cfg_atm_qid_dpth_thrsh_mem_waddr),
       .rf_cfg_atm_qid_dpth_thrsh_mem_wdata                      (i_hqm_sip_rf_cfg_atm_qid_dpth_thrsh_mem_wdata),
       .rf_cfg_atm_qid_dpth_thrsh_mem_rclk                       (i_hqm_sip_rf_cfg_atm_qid_dpth_thrsh_mem_rclk),
       .rf_cfg_atm_qid_dpth_thrsh_mem_rclk_rst_n                 (i_hqm_sip_rf_cfg_atm_qid_dpth_thrsh_mem_rclk_rst_n),
       .rf_cfg_atm_qid_dpth_thrsh_mem_re                         (i_hqm_sip_rf_cfg_atm_qid_dpth_thrsh_mem_re),
       .rf_cfg_atm_qid_dpth_thrsh_mem_raddr                      (i_hqm_sip_rf_cfg_atm_qid_dpth_thrsh_mem_raddr),
       .rf_cfg_atm_qid_dpth_thrsh_mem_rdata                      (i_hqm_list_sel_mem_rf_cfg_atm_qid_dpth_thrsh_mem_rdata),
       .rf_cfg_atm_qid_dpth_thrsh_mem_isol_en                    (i_hqm_sip_pgcb_isol_en),
       .rf_cfg_atm_qid_dpth_thrsh_mem_pwr_enable_b_in            (i_hqm_list_sel_mem_rf_atm_fifo_aqed_ap_enq_pwr_enable_b_out),
       .rf_cfg_atm_qid_dpth_thrsh_mem_pwr_enable_b_out           (i_hqm_list_sel_mem_rf_cfg_atm_qid_dpth_thrsh_mem_pwr_enable_b_out),
       .rf_cfg_cq2priov_mem_wclk                                 (i_hqm_sip_rf_cfg_cq2priov_mem_wclk),
       .rf_cfg_cq2priov_mem_wclk_rst_n                           (i_hqm_sip_rf_cfg_cq2priov_mem_wclk_rst_n),
       .rf_cfg_cq2priov_mem_we                                   (i_hqm_sip_rf_cfg_cq2priov_mem_we),
       .rf_cfg_cq2priov_mem_waddr                                (i_hqm_sip_rf_cfg_cq2priov_mem_waddr),
       .rf_cfg_cq2priov_mem_wdata                                (i_hqm_sip_rf_cfg_cq2priov_mem_wdata),
       .rf_cfg_cq2priov_mem_rclk                                 (i_hqm_sip_rf_cfg_cq2priov_mem_rclk),
       .rf_cfg_cq2priov_mem_rclk_rst_n                           (i_hqm_sip_rf_cfg_cq2priov_mem_rclk_rst_n),
       .rf_cfg_cq2priov_mem_re                                   (i_hqm_sip_rf_cfg_cq2priov_mem_re),
       .rf_cfg_cq2priov_mem_raddr                                (i_hqm_sip_rf_cfg_cq2priov_mem_raddr),
       .rf_cfg_cq2priov_mem_rdata                                (i_hqm_list_sel_mem_rf_cfg_cq2priov_mem_rdata),
       .rf_cfg_cq2priov_mem_isol_en                              (i_hqm_sip_pgcb_isol_en),
       .rf_cfg_cq2priov_mem_pwr_enable_b_in                      (i_hqm_list_sel_mem_rf_cfg_atm_qid_dpth_thrsh_mem_pwr_enable_b_out),
       .rf_cfg_cq2priov_mem_pwr_enable_b_out                     (i_hqm_list_sel_mem_rf_cfg_cq2priov_mem_pwr_enable_b_out),
       .rf_cfg_cq2priov_odd_mem_wclk                             (i_hqm_sip_rf_cfg_cq2priov_odd_mem_wclk),
       .rf_cfg_cq2priov_odd_mem_wclk_rst_n                       (i_hqm_sip_rf_cfg_cq2priov_odd_mem_wclk_rst_n),
       .rf_cfg_cq2priov_odd_mem_we                               (i_hqm_sip_rf_cfg_cq2priov_odd_mem_we),
       .rf_cfg_cq2priov_odd_mem_waddr                            (i_hqm_sip_rf_cfg_cq2priov_odd_mem_waddr),
       .rf_cfg_cq2priov_odd_mem_wdata                            (i_hqm_sip_rf_cfg_cq2priov_odd_mem_wdata),
       .rf_cfg_cq2priov_odd_mem_rclk                             (i_hqm_sip_rf_cfg_cq2priov_odd_mem_rclk),
       .rf_cfg_cq2priov_odd_mem_rclk_rst_n                       (i_hqm_sip_rf_cfg_cq2priov_odd_mem_rclk_rst_n),
       .rf_cfg_cq2priov_odd_mem_re                               (i_hqm_sip_rf_cfg_cq2priov_odd_mem_re),
       .rf_cfg_cq2priov_odd_mem_raddr                            (i_hqm_sip_rf_cfg_cq2priov_odd_mem_raddr),
       .rf_cfg_cq2priov_odd_mem_rdata                            (i_hqm_list_sel_mem_rf_cfg_cq2priov_odd_mem_rdata),
       .rf_cfg_cq2priov_odd_mem_isol_en                          (i_hqm_sip_pgcb_isol_en),
       .rf_cfg_cq2priov_odd_mem_pwr_enable_b_in                  (i_hqm_list_sel_mem_rf_cfg_cq2priov_mem_pwr_enable_b_out),
       .rf_cfg_cq2priov_odd_mem_pwr_enable_b_out                 (i_hqm_list_sel_mem_rf_cfg_cq2priov_odd_mem_pwr_enable_b_out),
       .rf_cfg_cq2qid_0_mem_wclk                                 (i_hqm_sip_rf_cfg_cq2qid_0_mem_wclk),
       .rf_cfg_cq2qid_0_mem_wclk_rst_n                           (i_hqm_sip_rf_cfg_cq2qid_0_mem_wclk_rst_n),
       .rf_cfg_cq2qid_0_mem_we                                   (i_hqm_sip_rf_cfg_cq2qid_0_mem_we),
       .rf_cfg_cq2qid_0_mem_waddr                                (i_hqm_sip_rf_cfg_cq2qid_0_mem_waddr),
       .rf_cfg_cq2qid_0_mem_wdata                                (i_hqm_sip_rf_cfg_cq2qid_0_mem_wdata),
       .rf_cfg_cq2qid_0_mem_rclk                                 (i_hqm_sip_rf_cfg_cq2qid_0_mem_rclk),
       .rf_cfg_cq2qid_0_mem_rclk_rst_n                           (i_hqm_sip_rf_cfg_cq2qid_0_mem_rclk_rst_n),
       .rf_cfg_cq2qid_0_mem_re                                   (i_hqm_sip_rf_cfg_cq2qid_0_mem_re),
       .rf_cfg_cq2qid_0_mem_raddr                                (i_hqm_sip_rf_cfg_cq2qid_0_mem_raddr),
       .rf_cfg_cq2qid_0_mem_rdata                                (i_hqm_list_sel_mem_rf_cfg_cq2qid_0_mem_rdata),
       .rf_cfg_cq2qid_0_mem_isol_en                              (i_hqm_sip_pgcb_isol_en),
       .rf_cfg_cq2qid_0_mem_pwr_enable_b_in                      (i_hqm_list_sel_mem_rf_cfg_cq2priov_odd_mem_pwr_enable_b_out),
       .rf_cfg_cq2qid_0_mem_pwr_enable_b_out                     (i_hqm_list_sel_mem_rf_cfg_cq2qid_0_mem_pwr_enable_b_out),
       .rf_cfg_cq2qid_0_odd_mem_wclk                             (i_hqm_sip_rf_cfg_cq2qid_0_odd_mem_wclk),
       .rf_cfg_cq2qid_0_odd_mem_wclk_rst_n                       (i_hqm_sip_rf_cfg_cq2qid_0_odd_mem_wclk_rst_n),
       .rf_cfg_cq2qid_0_odd_mem_we                               (i_hqm_sip_rf_cfg_cq2qid_0_odd_mem_we),
       .rf_cfg_cq2qid_0_odd_mem_waddr                            (i_hqm_sip_rf_cfg_cq2qid_0_odd_mem_waddr),
       .rf_cfg_cq2qid_0_odd_mem_wdata                            (i_hqm_sip_rf_cfg_cq2qid_0_odd_mem_wdata),
       .rf_cfg_cq2qid_0_odd_mem_rclk                             (i_hqm_sip_rf_cfg_cq2qid_0_odd_mem_rclk),
       .rf_cfg_cq2qid_0_odd_mem_rclk_rst_n                       (i_hqm_sip_rf_cfg_cq2qid_0_odd_mem_rclk_rst_n),
       .rf_cfg_cq2qid_0_odd_mem_re                               (i_hqm_sip_rf_cfg_cq2qid_0_odd_mem_re),
       .rf_cfg_cq2qid_0_odd_mem_raddr                            (i_hqm_sip_rf_cfg_cq2qid_0_odd_mem_raddr),
       .rf_cfg_cq2qid_0_odd_mem_rdata                            (i_hqm_list_sel_mem_rf_cfg_cq2qid_0_odd_mem_rdata),
       .rf_cfg_cq2qid_0_odd_mem_isol_en                          (i_hqm_sip_pgcb_isol_en),
       .rf_cfg_cq2qid_0_odd_mem_pwr_enable_b_in                  (i_hqm_list_sel_mem_rf_cfg_cq2qid_0_mem_pwr_enable_b_out),
       .rf_cfg_cq2qid_0_odd_mem_pwr_enable_b_out                 (i_hqm_list_sel_mem_rf_cfg_cq2qid_0_odd_mem_pwr_enable_b_out),
       .rf_cfg_cq2qid_1_mem_wclk                                 (i_hqm_sip_rf_cfg_cq2qid_1_mem_wclk),
       .rf_cfg_cq2qid_1_mem_wclk_rst_n                           (i_hqm_sip_rf_cfg_cq2qid_1_mem_wclk_rst_n),
       .rf_cfg_cq2qid_1_mem_we                                   (i_hqm_sip_rf_cfg_cq2qid_1_mem_we),
       .rf_cfg_cq2qid_1_mem_waddr                                (i_hqm_sip_rf_cfg_cq2qid_1_mem_waddr),
       .rf_cfg_cq2qid_1_mem_wdata                                (i_hqm_sip_rf_cfg_cq2qid_1_mem_wdata),
       .rf_cfg_cq2qid_1_mem_rclk                                 (i_hqm_sip_rf_cfg_cq2qid_1_mem_rclk),
       .rf_cfg_cq2qid_1_mem_rclk_rst_n                           (i_hqm_sip_rf_cfg_cq2qid_1_mem_rclk_rst_n),
       .rf_cfg_cq2qid_1_mem_re                                   (i_hqm_sip_rf_cfg_cq2qid_1_mem_re),
       .rf_cfg_cq2qid_1_mem_raddr                                (i_hqm_sip_rf_cfg_cq2qid_1_mem_raddr),
       .rf_cfg_cq2qid_1_mem_rdata                                (i_hqm_list_sel_mem_rf_cfg_cq2qid_1_mem_rdata),
       .rf_cfg_cq2qid_1_mem_isol_en                              (i_hqm_sip_pgcb_isol_en),
       .rf_cfg_cq2qid_1_mem_pwr_enable_b_in                      (i_hqm_list_sel_mem_rf_cfg_cq2qid_0_odd_mem_pwr_enable_b_out),
       .rf_cfg_cq2qid_1_mem_pwr_enable_b_out                     (i_hqm_list_sel_mem_rf_cfg_cq2qid_1_mem_pwr_enable_b_out),
       .rf_cfg_cq2qid_1_odd_mem_wclk                             (i_hqm_sip_rf_cfg_cq2qid_1_odd_mem_wclk),
       .rf_cfg_cq2qid_1_odd_mem_wclk_rst_n                       (i_hqm_sip_rf_cfg_cq2qid_1_odd_mem_wclk_rst_n),
       .rf_cfg_cq2qid_1_odd_mem_we                               (i_hqm_sip_rf_cfg_cq2qid_1_odd_mem_we),
       .rf_cfg_cq2qid_1_odd_mem_waddr                            (i_hqm_sip_rf_cfg_cq2qid_1_odd_mem_waddr),
       .rf_cfg_cq2qid_1_odd_mem_wdata                            (i_hqm_sip_rf_cfg_cq2qid_1_odd_mem_wdata),
       .rf_cfg_cq2qid_1_odd_mem_rclk                             (i_hqm_sip_rf_cfg_cq2qid_1_odd_mem_rclk),
       .rf_cfg_cq2qid_1_odd_mem_rclk_rst_n                       (i_hqm_sip_rf_cfg_cq2qid_1_odd_mem_rclk_rst_n),
       .rf_cfg_cq2qid_1_odd_mem_re                               (i_hqm_sip_rf_cfg_cq2qid_1_odd_mem_re),
       .rf_cfg_cq2qid_1_odd_mem_raddr                            (i_hqm_sip_rf_cfg_cq2qid_1_odd_mem_raddr),
       .rf_cfg_cq2qid_1_odd_mem_rdata                            (i_hqm_list_sel_mem_rf_cfg_cq2qid_1_odd_mem_rdata),
       .rf_cfg_cq2qid_1_odd_mem_isol_en                          (i_hqm_sip_pgcb_isol_en),
       .rf_cfg_cq2qid_1_odd_mem_pwr_enable_b_in                  (i_hqm_list_sel_mem_rf_cfg_cq2qid_1_mem_pwr_enable_b_out),
       .rf_cfg_cq2qid_1_odd_mem_pwr_enable_b_out                 (i_hqm_list_sel_mem_rf_cfg_cq2qid_1_odd_mem_pwr_enable_b_out),
       .rf_cfg_cq_ldb_inflight_limit_mem_wclk                    (i_hqm_sip_rf_cfg_cq_ldb_inflight_limit_mem_wclk),
       .rf_cfg_cq_ldb_inflight_limit_mem_wclk_rst_n              (i_hqm_sip_rf_cfg_cq_ldb_inflight_limit_mem_wclk_rst_n),
       .rf_cfg_cq_ldb_inflight_limit_mem_we                      (i_hqm_sip_rf_cfg_cq_ldb_inflight_limit_mem_we),
       .rf_cfg_cq_ldb_inflight_limit_mem_waddr                   (i_hqm_sip_rf_cfg_cq_ldb_inflight_limit_mem_waddr),
       .rf_cfg_cq_ldb_inflight_limit_mem_wdata                   (i_hqm_sip_rf_cfg_cq_ldb_inflight_limit_mem_wdata),
       .rf_cfg_cq_ldb_inflight_limit_mem_rclk                    (i_hqm_sip_rf_cfg_cq_ldb_inflight_limit_mem_rclk),
       .rf_cfg_cq_ldb_inflight_limit_mem_rclk_rst_n              (i_hqm_sip_rf_cfg_cq_ldb_inflight_limit_mem_rclk_rst_n),
       .rf_cfg_cq_ldb_inflight_limit_mem_re                      (i_hqm_sip_rf_cfg_cq_ldb_inflight_limit_mem_re),
       .rf_cfg_cq_ldb_inflight_limit_mem_raddr                   (i_hqm_sip_rf_cfg_cq_ldb_inflight_limit_mem_raddr),
       .rf_cfg_cq_ldb_inflight_limit_mem_rdata                   (i_hqm_list_sel_mem_rf_cfg_cq_ldb_inflight_limit_mem_rdata),
       .rf_cfg_cq_ldb_inflight_limit_mem_isol_en                 (i_hqm_sip_pgcb_isol_en),
       .rf_cfg_cq_ldb_inflight_limit_mem_pwr_enable_b_in         (i_hqm_list_sel_mem_rf_cfg_cq2qid_1_odd_mem_pwr_enable_b_out),
       .rf_cfg_cq_ldb_inflight_limit_mem_pwr_enable_b_out        (i_hqm_list_sel_mem_rf_cfg_cq_ldb_inflight_limit_mem_pwr_enable_b_out),
       .rf_cfg_cq_ldb_inflight_threshold_mem_wclk                (i_hqm_sip_rf_cfg_cq_ldb_inflight_threshold_mem_wclk),
       .rf_cfg_cq_ldb_inflight_threshold_mem_wclk_rst_n          (i_hqm_sip_rf_cfg_cq_ldb_inflight_threshold_mem_wclk_rst_n),
       .rf_cfg_cq_ldb_inflight_threshold_mem_we                  (i_hqm_sip_rf_cfg_cq_ldb_inflight_threshold_mem_we),
       .rf_cfg_cq_ldb_inflight_threshold_mem_waddr               (i_hqm_sip_rf_cfg_cq_ldb_inflight_threshold_mem_waddr),
       .rf_cfg_cq_ldb_inflight_threshold_mem_wdata               (i_hqm_sip_rf_cfg_cq_ldb_inflight_threshold_mem_wdata),
       .rf_cfg_cq_ldb_inflight_threshold_mem_rclk                (i_hqm_sip_rf_cfg_cq_ldb_inflight_threshold_mem_rclk),
       .rf_cfg_cq_ldb_inflight_threshold_mem_rclk_rst_n          (i_hqm_sip_rf_cfg_cq_ldb_inflight_threshold_mem_rclk_rst_n),
       .rf_cfg_cq_ldb_inflight_threshold_mem_re                  (i_hqm_sip_rf_cfg_cq_ldb_inflight_threshold_mem_re),
       .rf_cfg_cq_ldb_inflight_threshold_mem_raddr               (i_hqm_sip_rf_cfg_cq_ldb_inflight_threshold_mem_raddr),
       .rf_cfg_cq_ldb_inflight_threshold_mem_rdata               (i_hqm_list_sel_mem_rf_cfg_cq_ldb_inflight_threshold_mem_rdata),
       .rf_cfg_cq_ldb_inflight_threshold_mem_isol_en             (i_hqm_sip_pgcb_isol_en),
       .rf_cfg_cq_ldb_inflight_threshold_mem_pwr_enable_b_in     (i_hqm_list_sel_mem_rf_cfg_cq_ldb_inflight_limit_mem_pwr_enable_b_out),
       .rf_cfg_cq_ldb_inflight_threshold_mem_pwr_enable_b_out    (i_hqm_list_sel_mem_rf_cfg_cq_ldb_inflight_threshold_mem_pwr_enable_b_out),
       .rf_cfg_cq_ldb_token_depth_select_mem_wclk                (i_hqm_sip_rf_cfg_cq_ldb_token_depth_select_mem_wclk),
       .rf_cfg_cq_ldb_token_depth_select_mem_wclk_rst_n          (i_hqm_sip_rf_cfg_cq_ldb_token_depth_select_mem_wclk_rst_n),
       .rf_cfg_cq_ldb_token_depth_select_mem_we                  (i_hqm_sip_rf_cfg_cq_ldb_token_depth_select_mem_we),
       .rf_cfg_cq_ldb_token_depth_select_mem_waddr               (i_hqm_sip_rf_cfg_cq_ldb_token_depth_select_mem_waddr),
       .rf_cfg_cq_ldb_token_depth_select_mem_wdata               (i_hqm_sip_rf_cfg_cq_ldb_token_depth_select_mem_wdata),
       .rf_cfg_cq_ldb_token_depth_select_mem_rclk                (i_hqm_sip_rf_cfg_cq_ldb_token_depth_select_mem_rclk),
       .rf_cfg_cq_ldb_token_depth_select_mem_rclk_rst_n          (i_hqm_sip_rf_cfg_cq_ldb_token_depth_select_mem_rclk_rst_n),
       .rf_cfg_cq_ldb_token_depth_select_mem_re                  (i_hqm_sip_rf_cfg_cq_ldb_token_depth_select_mem_re),
       .rf_cfg_cq_ldb_token_depth_select_mem_raddr               (i_hqm_sip_rf_cfg_cq_ldb_token_depth_select_mem_raddr),
       .rf_cfg_cq_ldb_token_depth_select_mem_rdata               (i_hqm_list_sel_mem_rf_cfg_cq_ldb_token_depth_select_mem_rdata),
       .rf_cfg_cq_ldb_token_depth_select_mem_isol_en             (i_hqm_sip_pgcb_isol_en),
       .rf_cfg_cq_ldb_token_depth_select_mem_pwr_enable_b_in     (i_hqm_list_sel_mem_rf_cfg_cq_ldb_inflight_threshold_mem_pwr_enable_b_out),
       .rf_cfg_cq_ldb_token_depth_select_mem_pwr_enable_b_out    (i_hqm_list_sel_mem_rf_cfg_cq_ldb_token_depth_select_mem_pwr_enable_b_out),
       .rf_cfg_cq_ldb_wu_limit_mem_wclk                          (i_hqm_sip_rf_cfg_cq_ldb_wu_limit_mem_wclk),
       .rf_cfg_cq_ldb_wu_limit_mem_wclk_rst_n                    (i_hqm_sip_rf_cfg_cq_ldb_wu_limit_mem_wclk_rst_n),
       .rf_cfg_cq_ldb_wu_limit_mem_we                            (i_hqm_sip_rf_cfg_cq_ldb_wu_limit_mem_we),
       .rf_cfg_cq_ldb_wu_limit_mem_waddr                         (i_hqm_sip_rf_cfg_cq_ldb_wu_limit_mem_waddr),
       .rf_cfg_cq_ldb_wu_limit_mem_wdata                         (i_hqm_sip_rf_cfg_cq_ldb_wu_limit_mem_wdata),
       .rf_cfg_cq_ldb_wu_limit_mem_rclk                          (i_hqm_sip_rf_cfg_cq_ldb_wu_limit_mem_rclk),
       .rf_cfg_cq_ldb_wu_limit_mem_rclk_rst_n                    (i_hqm_sip_rf_cfg_cq_ldb_wu_limit_mem_rclk_rst_n),
       .rf_cfg_cq_ldb_wu_limit_mem_re                            (i_hqm_sip_rf_cfg_cq_ldb_wu_limit_mem_re),
       .rf_cfg_cq_ldb_wu_limit_mem_raddr                         (i_hqm_sip_rf_cfg_cq_ldb_wu_limit_mem_raddr),
       .rf_cfg_cq_ldb_wu_limit_mem_rdata                         (i_hqm_list_sel_mem_rf_cfg_cq_ldb_wu_limit_mem_rdata),
       .rf_cfg_cq_ldb_wu_limit_mem_isol_en                       (i_hqm_sip_pgcb_isol_en),
       .rf_cfg_cq_ldb_wu_limit_mem_pwr_enable_b_in               (i_hqm_list_sel_mem_rf_cfg_cq_ldb_token_depth_select_mem_pwr_enable_b_out),
       .rf_cfg_cq_ldb_wu_limit_mem_pwr_enable_b_out              (i_hqm_list_sel_mem_rf_cfg_cq_ldb_wu_limit_mem_pwr_enable_b_out),
       .rf_cfg_dir_qid_dpth_thrsh_mem_wclk                       (i_hqm_sip_rf_cfg_dir_qid_dpth_thrsh_mem_wclk),
       .rf_cfg_dir_qid_dpth_thrsh_mem_wclk_rst_n                 (i_hqm_sip_rf_cfg_dir_qid_dpth_thrsh_mem_wclk_rst_n),
       .rf_cfg_dir_qid_dpth_thrsh_mem_we                         (i_hqm_sip_rf_cfg_dir_qid_dpth_thrsh_mem_we),
       .rf_cfg_dir_qid_dpth_thrsh_mem_waddr                      (i_hqm_sip_rf_cfg_dir_qid_dpth_thrsh_mem_waddr),
       .rf_cfg_dir_qid_dpth_thrsh_mem_wdata                      (i_hqm_sip_rf_cfg_dir_qid_dpth_thrsh_mem_wdata),
       .rf_cfg_dir_qid_dpth_thrsh_mem_rclk                       (i_hqm_sip_rf_cfg_dir_qid_dpth_thrsh_mem_rclk),
       .rf_cfg_dir_qid_dpth_thrsh_mem_rclk_rst_n                 (i_hqm_sip_rf_cfg_dir_qid_dpth_thrsh_mem_rclk_rst_n),
       .rf_cfg_dir_qid_dpth_thrsh_mem_re                         (i_hqm_sip_rf_cfg_dir_qid_dpth_thrsh_mem_re),
       .rf_cfg_dir_qid_dpth_thrsh_mem_raddr                      (i_hqm_sip_rf_cfg_dir_qid_dpth_thrsh_mem_raddr),
       .rf_cfg_dir_qid_dpth_thrsh_mem_rdata                      (i_hqm_list_sel_mem_rf_cfg_dir_qid_dpth_thrsh_mem_rdata),
       .rf_cfg_dir_qid_dpth_thrsh_mem_isol_en                    (i_hqm_sip_pgcb_isol_en),
       .rf_cfg_dir_qid_dpth_thrsh_mem_pwr_enable_b_in            (i_hqm_list_sel_mem_rf_cfg_cq_ldb_wu_limit_mem_pwr_enable_b_out),
       .rf_cfg_dir_qid_dpth_thrsh_mem_pwr_enable_b_out           (i_hqm_list_sel_mem_rf_cfg_dir_qid_dpth_thrsh_mem_pwr_enable_b_out),
       .rf_cfg_nalb_qid_dpth_thrsh_mem_wclk                      (i_hqm_sip_rf_cfg_nalb_qid_dpth_thrsh_mem_wclk),
       .rf_cfg_nalb_qid_dpth_thrsh_mem_wclk_rst_n                (i_hqm_sip_rf_cfg_nalb_qid_dpth_thrsh_mem_wclk_rst_n),
       .rf_cfg_nalb_qid_dpth_thrsh_mem_we                        (i_hqm_sip_rf_cfg_nalb_qid_dpth_thrsh_mem_we),
       .rf_cfg_nalb_qid_dpth_thrsh_mem_waddr                     (i_hqm_sip_rf_cfg_nalb_qid_dpth_thrsh_mem_waddr),
       .rf_cfg_nalb_qid_dpth_thrsh_mem_wdata                     (i_hqm_sip_rf_cfg_nalb_qid_dpth_thrsh_mem_wdata),
       .rf_cfg_nalb_qid_dpth_thrsh_mem_rclk                      (i_hqm_sip_rf_cfg_nalb_qid_dpth_thrsh_mem_rclk),
       .rf_cfg_nalb_qid_dpth_thrsh_mem_rclk_rst_n                (i_hqm_sip_rf_cfg_nalb_qid_dpth_thrsh_mem_rclk_rst_n),
       .rf_cfg_nalb_qid_dpth_thrsh_mem_re                        (i_hqm_sip_rf_cfg_nalb_qid_dpth_thrsh_mem_re),
       .rf_cfg_nalb_qid_dpth_thrsh_mem_raddr                     (i_hqm_sip_rf_cfg_nalb_qid_dpth_thrsh_mem_raddr),
       .rf_cfg_nalb_qid_dpth_thrsh_mem_rdata                     (i_hqm_list_sel_mem_rf_cfg_nalb_qid_dpth_thrsh_mem_rdata),
       .rf_cfg_nalb_qid_dpth_thrsh_mem_isol_en                   (i_hqm_sip_pgcb_isol_en),
       .rf_cfg_nalb_qid_dpth_thrsh_mem_pwr_enable_b_in           (i_hqm_list_sel_mem_rf_cfg_dir_qid_dpth_thrsh_mem_pwr_enable_b_out),
       .rf_cfg_nalb_qid_dpth_thrsh_mem_pwr_enable_b_out          (i_hqm_list_sel_mem_rf_cfg_nalb_qid_dpth_thrsh_mem_pwr_enable_b_out),
       .rf_cfg_qid_aqed_active_limit_mem_wclk                    (i_hqm_sip_rf_cfg_qid_aqed_active_limit_mem_wclk),
       .rf_cfg_qid_aqed_active_limit_mem_wclk_rst_n              (i_hqm_sip_rf_cfg_qid_aqed_active_limit_mem_wclk_rst_n),
       .rf_cfg_qid_aqed_active_limit_mem_we                      (i_hqm_sip_rf_cfg_qid_aqed_active_limit_mem_we),
       .rf_cfg_qid_aqed_active_limit_mem_waddr                   (i_hqm_sip_rf_cfg_qid_aqed_active_limit_mem_waddr),
       .rf_cfg_qid_aqed_active_limit_mem_wdata                   (i_hqm_sip_rf_cfg_qid_aqed_active_limit_mem_wdata),
       .rf_cfg_qid_aqed_active_limit_mem_rclk                    (i_hqm_sip_rf_cfg_qid_aqed_active_limit_mem_rclk),
       .rf_cfg_qid_aqed_active_limit_mem_rclk_rst_n              (i_hqm_sip_rf_cfg_qid_aqed_active_limit_mem_rclk_rst_n),
       .rf_cfg_qid_aqed_active_limit_mem_re                      (i_hqm_sip_rf_cfg_qid_aqed_active_limit_mem_re),
       .rf_cfg_qid_aqed_active_limit_mem_raddr                   (i_hqm_sip_rf_cfg_qid_aqed_active_limit_mem_raddr),
       .rf_cfg_qid_aqed_active_limit_mem_rdata                   (i_hqm_list_sel_mem_rf_cfg_qid_aqed_active_limit_mem_rdata),
       .rf_cfg_qid_aqed_active_limit_mem_isol_en                 (i_hqm_sip_pgcb_isol_en),
       .rf_cfg_qid_aqed_active_limit_mem_pwr_enable_b_in         (i_hqm_list_sel_mem_rf_cfg_nalb_qid_dpth_thrsh_mem_pwr_enable_b_out),
       .rf_cfg_qid_aqed_active_limit_mem_pwr_enable_b_out        (i_hqm_list_sel_mem_rf_cfg_qid_aqed_active_limit_mem_pwr_enable_b_out),
       .rf_cfg_qid_ldb_inflight_limit_mem_wclk                   (i_hqm_sip_rf_cfg_qid_ldb_inflight_limit_mem_wclk),
       .rf_cfg_qid_ldb_inflight_limit_mem_wclk_rst_n             (i_hqm_sip_rf_cfg_qid_ldb_inflight_limit_mem_wclk_rst_n),
       .rf_cfg_qid_ldb_inflight_limit_mem_we                     (i_hqm_sip_rf_cfg_qid_ldb_inflight_limit_mem_we),
       .rf_cfg_qid_ldb_inflight_limit_mem_waddr                  (i_hqm_sip_rf_cfg_qid_ldb_inflight_limit_mem_waddr),
       .rf_cfg_qid_ldb_inflight_limit_mem_wdata                  (i_hqm_sip_rf_cfg_qid_ldb_inflight_limit_mem_wdata),
       .rf_cfg_qid_ldb_inflight_limit_mem_rclk                   (i_hqm_sip_rf_cfg_qid_ldb_inflight_limit_mem_rclk),
       .rf_cfg_qid_ldb_inflight_limit_mem_rclk_rst_n             (i_hqm_sip_rf_cfg_qid_ldb_inflight_limit_mem_rclk_rst_n),
       .rf_cfg_qid_ldb_inflight_limit_mem_re                     (i_hqm_sip_rf_cfg_qid_ldb_inflight_limit_mem_re),
       .rf_cfg_qid_ldb_inflight_limit_mem_raddr                  (i_hqm_sip_rf_cfg_qid_ldb_inflight_limit_mem_raddr),
       .rf_cfg_qid_ldb_inflight_limit_mem_rdata                  (i_hqm_list_sel_mem_rf_cfg_qid_ldb_inflight_limit_mem_rdata),
       .rf_cfg_qid_ldb_inflight_limit_mem_isol_en                (i_hqm_sip_pgcb_isol_en),
       .rf_cfg_qid_ldb_inflight_limit_mem_pwr_enable_b_in        (i_hqm_list_sel_mem_rf_cfg_qid_aqed_active_limit_mem_pwr_enable_b_out),
       .rf_cfg_qid_ldb_inflight_limit_mem_pwr_enable_b_out       (i_hqm_list_sel_mem_rf_cfg_qid_ldb_inflight_limit_mem_pwr_enable_b_out),
       .rf_cfg_qid_ldb_qid2cqidix2_mem_wclk                      (i_hqm_sip_rf_cfg_qid_ldb_qid2cqidix2_mem_wclk),
       .rf_cfg_qid_ldb_qid2cqidix2_mem_wclk_rst_n                (i_hqm_sip_rf_cfg_qid_ldb_qid2cqidix2_mem_wclk_rst_n),
       .rf_cfg_qid_ldb_qid2cqidix2_mem_we                        (i_hqm_sip_rf_cfg_qid_ldb_qid2cqidix2_mem_we),
       .rf_cfg_qid_ldb_qid2cqidix2_mem_waddr                     (i_hqm_sip_rf_cfg_qid_ldb_qid2cqidix2_mem_waddr),
       .rf_cfg_qid_ldb_qid2cqidix2_mem_wdata                     (i_hqm_sip_rf_cfg_qid_ldb_qid2cqidix2_mem_wdata),
       .rf_cfg_qid_ldb_qid2cqidix2_mem_rclk                      (i_hqm_sip_rf_cfg_qid_ldb_qid2cqidix2_mem_rclk),
       .rf_cfg_qid_ldb_qid2cqidix2_mem_rclk_rst_n                (i_hqm_sip_rf_cfg_qid_ldb_qid2cqidix2_mem_rclk_rst_n),
       .rf_cfg_qid_ldb_qid2cqidix2_mem_re                        (i_hqm_sip_rf_cfg_qid_ldb_qid2cqidix2_mem_re),
       .rf_cfg_qid_ldb_qid2cqidix2_mem_raddr                     (i_hqm_sip_rf_cfg_qid_ldb_qid2cqidix2_mem_raddr),
       .rf_cfg_qid_ldb_qid2cqidix2_mem_rdata                     (i_hqm_list_sel_mem_rf_cfg_qid_ldb_qid2cqidix2_mem_rdata),
       .rf_cfg_qid_ldb_qid2cqidix2_mem_isol_en                   (i_hqm_sip_pgcb_isol_en),
       .rf_cfg_qid_ldb_qid2cqidix2_mem_pwr_enable_b_in           (i_hqm_list_sel_mem_rf_cfg_qid_ldb_inflight_limit_mem_pwr_enable_b_out),
       .rf_cfg_qid_ldb_qid2cqidix2_mem_pwr_enable_b_out          (i_hqm_list_sel_mem_rf_cfg_qid_ldb_qid2cqidix2_mem_pwr_enable_b_out),
       .rf_cfg_qid_ldb_qid2cqidix_mem_wclk                       (i_hqm_sip_rf_cfg_qid_ldb_qid2cqidix_mem_wclk),
       .rf_cfg_qid_ldb_qid2cqidix_mem_wclk_rst_n                 (i_hqm_sip_rf_cfg_qid_ldb_qid2cqidix_mem_wclk_rst_n),
       .rf_cfg_qid_ldb_qid2cqidix_mem_we                         (i_hqm_sip_rf_cfg_qid_ldb_qid2cqidix_mem_we),
       .rf_cfg_qid_ldb_qid2cqidix_mem_waddr                      (i_hqm_sip_rf_cfg_qid_ldb_qid2cqidix_mem_waddr),
       .rf_cfg_qid_ldb_qid2cqidix_mem_wdata                      (i_hqm_sip_rf_cfg_qid_ldb_qid2cqidix_mem_wdata),
       .rf_cfg_qid_ldb_qid2cqidix_mem_rclk                       (i_hqm_sip_rf_cfg_qid_ldb_qid2cqidix_mem_rclk),
       .rf_cfg_qid_ldb_qid2cqidix_mem_rclk_rst_n                 (i_hqm_sip_rf_cfg_qid_ldb_qid2cqidix_mem_rclk_rst_n),
       .rf_cfg_qid_ldb_qid2cqidix_mem_re                         (i_hqm_sip_rf_cfg_qid_ldb_qid2cqidix_mem_re),
       .rf_cfg_qid_ldb_qid2cqidix_mem_raddr                      (i_hqm_sip_rf_cfg_qid_ldb_qid2cqidix_mem_raddr),
       .rf_cfg_qid_ldb_qid2cqidix_mem_rdata                      (i_hqm_list_sel_mem_rf_cfg_qid_ldb_qid2cqidix_mem_rdata),
       .rf_cfg_qid_ldb_qid2cqidix_mem_isol_en                    (i_hqm_sip_pgcb_isol_en),
       .rf_cfg_qid_ldb_qid2cqidix_mem_pwr_enable_b_in            (i_hqm_list_sel_mem_rf_cfg_qid_ldb_qid2cqidix2_mem_pwr_enable_b_out),
       .rf_cfg_qid_ldb_qid2cqidix_mem_pwr_enable_b_out           (i_hqm_list_sel_mem_rf_cfg_qid_ldb_qid2cqidix_mem_pwr_enable_b_out),
       .rf_chp_lsp_cmp_rx_sync_fifo_mem_wclk                     (i_hqm_sip_rf_chp_lsp_cmp_rx_sync_fifo_mem_wclk),
       .rf_chp_lsp_cmp_rx_sync_fifo_mem_wclk_rst_n               (i_hqm_sip_rf_chp_lsp_cmp_rx_sync_fifo_mem_wclk_rst_n),
       .rf_chp_lsp_cmp_rx_sync_fifo_mem_we                       (i_hqm_sip_rf_chp_lsp_cmp_rx_sync_fifo_mem_we),
       .rf_chp_lsp_cmp_rx_sync_fifo_mem_waddr                    (i_hqm_sip_rf_chp_lsp_cmp_rx_sync_fifo_mem_waddr),
       .rf_chp_lsp_cmp_rx_sync_fifo_mem_wdata                    (i_hqm_sip_rf_chp_lsp_cmp_rx_sync_fifo_mem_wdata),
       .rf_chp_lsp_cmp_rx_sync_fifo_mem_rclk                     (i_hqm_sip_rf_chp_lsp_cmp_rx_sync_fifo_mem_rclk),
       .rf_chp_lsp_cmp_rx_sync_fifo_mem_rclk_rst_n               (i_hqm_sip_rf_chp_lsp_cmp_rx_sync_fifo_mem_rclk_rst_n),
       .rf_chp_lsp_cmp_rx_sync_fifo_mem_re                       (i_hqm_sip_rf_chp_lsp_cmp_rx_sync_fifo_mem_re),
       .rf_chp_lsp_cmp_rx_sync_fifo_mem_raddr                    (i_hqm_sip_rf_chp_lsp_cmp_rx_sync_fifo_mem_raddr),
       .rf_chp_lsp_cmp_rx_sync_fifo_mem_rdata                    (i_hqm_list_sel_mem_rf_chp_lsp_cmp_rx_sync_fifo_mem_rdata),
       .rf_chp_lsp_cmp_rx_sync_fifo_mem_isol_en                  (i_hqm_sip_pgcb_isol_en),
       .rf_chp_lsp_cmp_rx_sync_fifo_mem_pwr_enable_b_in          (i_hqm_list_sel_mem_rf_cfg_qid_ldb_qid2cqidix_mem_pwr_enable_b_out),
       .rf_chp_lsp_cmp_rx_sync_fifo_mem_pwr_enable_b_out         (i_hqm_list_sel_mem_rf_chp_lsp_cmp_rx_sync_fifo_mem_pwr_enable_b_out),
       .rf_chp_lsp_token_rx_sync_fifo_mem_wclk                   (i_hqm_sip_rf_chp_lsp_token_rx_sync_fifo_mem_wclk),
       .rf_chp_lsp_token_rx_sync_fifo_mem_wclk_rst_n             (i_hqm_sip_rf_chp_lsp_token_rx_sync_fifo_mem_wclk_rst_n),
       .rf_chp_lsp_token_rx_sync_fifo_mem_we                     (i_hqm_sip_rf_chp_lsp_token_rx_sync_fifo_mem_we),
       .rf_chp_lsp_token_rx_sync_fifo_mem_waddr                  (i_hqm_sip_rf_chp_lsp_token_rx_sync_fifo_mem_waddr),
       .rf_chp_lsp_token_rx_sync_fifo_mem_wdata                  (i_hqm_sip_rf_chp_lsp_token_rx_sync_fifo_mem_wdata),
       .rf_chp_lsp_token_rx_sync_fifo_mem_rclk                   (i_hqm_sip_rf_chp_lsp_token_rx_sync_fifo_mem_rclk),
       .rf_chp_lsp_token_rx_sync_fifo_mem_rclk_rst_n             (i_hqm_sip_rf_chp_lsp_token_rx_sync_fifo_mem_rclk_rst_n),
       .rf_chp_lsp_token_rx_sync_fifo_mem_re                     (i_hqm_sip_rf_chp_lsp_token_rx_sync_fifo_mem_re),
       .rf_chp_lsp_token_rx_sync_fifo_mem_raddr                  (i_hqm_sip_rf_chp_lsp_token_rx_sync_fifo_mem_raddr),
       .rf_chp_lsp_token_rx_sync_fifo_mem_rdata                  (i_hqm_list_sel_mem_rf_chp_lsp_token_rx_sync_fifo_mem_rdata),
       .rf_chp_lsp_token_rx_sync_fifo_mem_isol_en                (i_hqm_sip_pgcb_isol_en),
       .rf_chp_lsp_token_rx_sync_fifo_mem_pwr_enable_b_in        (i_hqm_list_sel_mem_rf_chp_lsp_cmp_rx_sync_fifo_mem_pwr_enable_b_out),
       .rf_chp_lsp_token_rx_sync_fifo_mem_pwr_enable_b_out       (i_hqm_list_sel_mem_rf_chp_lsp_token_rx_sync_fifo_mem_pwr_enable_b_out),
       .rf_cq_atm_pri_arbindex_mem_wclk                          (i_hqm_sip_rf_cq_atm_pri_arbindex_mem_wclk),
       .rf_cq_atm_pri_arbindex_mem_wclk_rst_n                    (i_hqm_sip_rf_cq_atm_pri_arbindex_mem_wclk_rst_n),
       .rf_cq_atm_pri_arbindex_mem_we                            (i_hqm_sip_rf_cq_atm_pri_arbindex_mem_we),
       .rf_cq_atm_pri_arbindex_mem_waddr                         (i_hqm_sip_rf_cq_atm_pri_arbindex_mem_waddr),
       .rf_cq_atm_pri_arbindex_mem_wdata                         (i_hqm_sip_rf_cq_atm_pri_arbindex_mem_wdata),
       .rf_cq_atm_pri_arbindex_mem_rclk                          (i_hqm_sip_rf_cq_atm_pri_arbindex_mem_rclk),
       .rf_cq_atm_pri_arbindex_mem_rclk_rst_n                    (i_hqm_sip_rf_cq_atm_pri_arbindex_mem_rclk_rst_n),
       .rf_cq_atm_pri_arbindex_mem_re                            (i_hqm_sip_rf_cq_atm_pri_arbindex_mem_re),
       .rf_cq_atm_pri_arbindex_mem_raddr                         (i_hqm_sip_rf_cq_atm_pri_arbindex_mem_raddr),
       .rf_cq_atm_pri_arbindex_mem_rdata                         (i_hqm_list_sel_mem_rf_cq_atm_pri_arbindex_mem_rdata),
       .rf_cq_atm_pri_arbindex_mem_isol_en                       (i_hqm_sip_pgcb_isol_en),
       .rf_cq_atm_pri_arbindex_mem_pwr_enable_b_in               (i_hqm_list_sel_mem_rf_chp_lsp_token_rx_sync_fifo_mem_pwr_enable_b_out),
       .rf_cq_atm_pri_arbindex_mem_pwr_enable_b_out              (i_hqm_list_sel_mem_rf_cq_atm_pri_arbindex_mem_pwr_enable_b_out),
       .rf_cq_dir_tot_sch_cnt_mem_wclk                           (i_hqm_sip_rf_cq_dir_tot_sch_cnt_mem_wclk),
       .rf_cq_dir_tot_sch_cnt_mem_wclk_rst_n                     (i_hqm_sip_rf_cq_dir_tot_sch_cnt_mem_wclk_rst_n),
       .rf_cq_dir_tot_sch_cnt_mem_we                             (i_hqm_sip_rf_cq_dir_tot_sch_cnt_mem_we),
       .rf_cq_dir_tot_sch_cnt_mem_waddr                          (i_hqm_sip_rf_cq_dir_tot_sch_cnt_mem_waddr),
       .rf_cq_dir_tot_sch_cnt_mem_wdata                          (i_hqm_sip_rf_cq_dir_tot_sch_cnt_mem_wdata),
       .rf_cq_dir_tot_sch_cnt_mem_rclk                           (i_hqm_sip_rf_cq_dir_tot_sch_cnt_mem_rclk),
       .rf_cq_dir_tot_sch_cnt_mem_rclk_rst_n                     (i_hqm_sip_rf_cq_dir_tot_sch_cnt_mem_rclk_rst_n),
       .rf_cq_dir_tot_sch_cnt_mem_re                             (i_hqm_sip_rf_cq_dir_tot_sch_cnt_mem_re),
       .rf_cq_dir_tot_sch_cnt_mem_raddr                          (i_hqm_sip_rf_cq_dir_tot_sch_cnt_mem_raddr),
       .rf_cq_dir_tot_sch_cnt_mem_rdata                          (i_hqm_list_sel_mem_rf_cq_dir_tot_sch_cnt_mem_rdata),
       .rf_cq_dir_tot_sch_cnt_mem_isol_en                        (i_hqm_sip_pgcb_isol_en),
       .rf_cq_dir_tot_sch_cnt_mem_pwr_enable_b_in                (i_hqm_list_sel_mem_rf_cq_atm_pri_arbindex_mem_pwr_enable_b_out),
       .rf_cq_dir_tot_sch_cnt_mem_pwr_enable_b_out               (i_hqm_list_sel_mem_rf_cq_dir_tot_sch_cnt_mem_pwr_enable_b_out),
       .rf_cq_ldb_inflight_count_mem_wclk                        (i_hqm_sip_rf_cq_ldb_inflight_count_mem_wclk),
       .rf_cq_ldb_inflight_count_mem_wclk_rst_n                  (i_hqm_sip_rf_cq_ldb_inflight_count_mem_wclk_rst_n),
       .rf_cq_ldb_inflight_count_mem_we                          (i_hqm_sip_rf_cq_ldb_inflight_count_mem_we),
       .rf_cq_ldb_inflight_count_mem_waddr                       (i_hqm_sip_rf_cq_ldb_inflight_count_mem_waddr),
       .rf_cq_ldb_inflight_count_mem_wdata                       (i_hqm_sip_rf_cq_ldb_inflight_count_mem_wdata),
       .rf_cq_ldb_inflight_count_mem_rclk                        (i_hqm_sip_rf_cq_ldb_inflight_count_mem_rclk),
       .rf_cq_ldb_inflight_count_mem_rclk_rst_n                  (i_hqm_sip_rf_cq_ldb_inflight_count_mem_rclk_rst_n),
       .rf_cq_ldb_inflight_count_mem_re                          (i_hqm_sip_rf_cq_ldb_inflight_count_mem_re),
       .rf_cq_ldb_inflight_count_mem_raddr                       (i_hqm_sip_rf_cq_ldb_inflight_count_mem_raddr),
       .rf_cq_ldb_inflight_count_mem_rdata                       (i_hqm_list_sel_mem_rf_cq_ldb_inflight_count_mem_rdata),
       .rf_cq_ldb_inflight_count_mem_isol_en                     (i_hqm_sip_pgcb_isol_en),
       .rf_cq_ldb_inflight_count_mem_pwr_enable_b_in             (i_hqm_list_sel_mem_rf_cq_dir_tot_sch_cnt_mem_pwr_enable_b_out),
       .rf_cq_ldb_inflight_count_mem_pwr_enable_b_out            (i_hqm_list_sel_mem_rf_cq_ldb_inflight_count_mem_pwr_enable_b_out),
       .rf_cq_ldb_token_count_mem_wclk                           (i_hqm_sip_rf_cq_ldb_token_count_mem_wclk),
       .rf_cq_ldb_token_count_mem_wclk_rst_n                     (i_hqm_sip_rf_cq_ldb_token_count_mem_wclk_rst_n),
       .rf_cq_ldb_token_count_mem_we                             (i_hqm_sip_rf_cq_ldb_token_count_mem_we),
       .rf_cq_ldb_token_count_mem_waddr                          (i_hqm_sip_rf_cq_ldb_token_count_mem_waddr),
       .rf_cq_ldb_token_count_mem_wdata                          (i_hqm_sip_rf_cq_ldb_token_count_mem_wdata),
       .rf_cq_ldb_token_count_mem_rclk                           (i_hqm_sip_rf_cq_ldb_token_count_mem_rclk),
       .rf_cq_ldb_token_count_mem_rclk_rst_n                     (i_hqm_sip_rf_cq_ldb_token_count_mem_rclk_rst_n),
       .rf_cq_ldb_token_count_mem_re                             (i_hqm_sip_rf_cq_ldb_token_count_mem_re),
       .rf_cq_ldb_token_count_mem_raddr                          (i_hqm_sip_rf_cq_ldb_token_count_mem_raddr),
       .rf_cq_ldb_token_count_mem_rdata                          (i_hqm_list_sel_mem_rf_cq_ldb_token_count_mem_rdata),
       .rf_cq_ldb_token_count_mem_isol_en                        (i_hqm_sip_pgcb_isol_en),
       .rf_cq_ldb_token_count_mem_pwr_enable_b_in                (i_hqm_list_sel_mem_rf_cq_ldb_inflight_count_mem_pwr_enable_b_out),
       .rf_cq_ldb_token_count_mem_pwr_enable_b_out               (i_hqm_list_sel_mem_rf_cq_ldb_token_count_mem_pwr_enable_b_out),
       .rf_cq_ldb_tot_sch_cnt_mem_wclk                           (i_hqm_sip_rf_cq_ldb_tot_sch_cnt_mem_wclk),
       .rf_cq_ldb_tot_sch_cnt_mem_wclk_rst_n                     (i_hqm_sip_rf_cq_ldb_tot_sch_cnt_mem_wclk_rst_n),
       .rf_cq_ldb_tot_sch_cnt_mem_we                             (i_hqm_sip_rf_cq_ldb_tot_sch_cnt_mem_we),
       .rf_cq_ldb_tot_sch_cnt_mem_waddr                          (i_hqm_sip_rf_cq_ldb_tot_sch_cnt_mem_waddr),
       .rf_cq_ldb_tot_sch_cnt_mem_wdata                          (i_hqm_sip_rf_cq_ldb_tot_sch_cnt_mem_wdata),
       .rf_cq_ldb_tot_sch_cnt_mem_rclk                           (i_hqm_sip_rf_cq_ldb_tot_sch_cnt_mem_rclk),
       .rf_cq_ldb_tot_sch_cnt_mem_rclk_rst_n                     (i_hqm_sip_rf_cq_ldb_tot_sch_cnt_mem_rclk_rst_n),
       .rf_cq_ldb_tot_sch_cnt_mem_re                             (i_hqm_sip_rf_cq_ldb_tot_sch_cnt_mem_re),
       .rf_cq_ldb_tot_sch_cnt_mem_raddr                          (i_hqm_sip_rf_cq_ldb_tot_sch_cnt_mem_raddr),
       .rf_cq_ldb_tot_sch_cnt_mem_rdata                          (i_hqm_list_sel_mem_rf_cq_ldb_tot_sch_cnt_mem_rdata),
       .rf_cq_ldb_tot_sch_cnt_mem_isol_en                        (i_hqm_sip_pgcb_isol_en),
       .rf_cq_ldb_tot_sch_cnt_mem_pwr_enable_b_in                (i_hqm_list_sel_mem_rf_cq_ldb_token_count_mem_pwr_enable_b_out),
       .rf_cq_ldb_tot_sch_cnt_mem_pwr_enable_b_out               (i_hqm_list_sel_mem_rf_cq_ldb_tot_sch_cnt_mem_pwr_enable_b_out),
       .rf_cq_ldb_wu_count_mem_wclk                              (i_hqm_sip_rf_cq_ldb_wu_count_mem_wclk),
       .rf_cq_ldb_wu_count_mem_wclk_rst_n                        (i_hqm_sip_rf_cq_ldb_wu_count_mem_wclk_rst_n),
       .rf_cq_ldb_wu_count_mem_we                                (i_hqm_sip_rf_cq_ldb_wu_count_mem_we),
       .rf_cq_ldb_wu_count_mem_waddr                             (i_hqm_sip_rf_cq_ldb_wu_count_mem_waddr),
       .rf_cq_ldb_wu_count_mem_wdata                             (i_hqm_sip_rf_cq_ldb_wu_count_mem_wdata),
       .rf_cq_ldb_wu_count_mem_rclk                              (i_hqm_sip_rf_cq_ldb_wu_count_mem_rclk),
       .rf_cq_ldb_wu_count_mem_rclk_rst_n                        (i_hqm_sip_rf_cq_ldb_wu_count_mem_rclk_rst_n),
       .rf_cq_ldb_wu_count_mem_re                                (i_hqm_sip_rf_cq_ldb_wu_count_mem_re),
       .rf_cq_ldb_wu_count_mem_raddr                             (i_hqm_sip_rf_cq_ldb_wu_count_mem_raddr),
       .rf_cq_ldb_wu_count_mem_rdata                             (i_hqm_list_sel_mem_rf_cq_ldb_wu_count_mem_rdata),
       .rf_cq_ldb_wu_count_mem_isol_en                           (i_hqm_sip_pgcb_isol_en),
       .rf_cq_ldb_wu_count_mem_pwr_enable_b_in                   (i_hqm_list_sel_mem_rf_cq_ldb_tot_sch_cnt_mem_pwr_enable_b_out),
       .rf_cq_ldb_wu_count_mem_pwr_enable_b_out                  (i_hqm_list_sel_mem_rf_cq_ldb_wu_count_mem_pwr_enable_b_out),
       .rf_cq_nalb_pri_arbindex_mem_wclk                         (i_hqm_sip_rf_cq_nalb_pri_arbindex_mem_wclk),
       .rf_cq_nalb_pri_arbindex_mem_wclk_rst_n                   (i_hqm_sip_rf_cq_nalb_pri_arbindex_mem_wclk_rst_n),
       .rf_cq_nalb_pri_arbindex_mem_we                           (i_hqm_sip_rf_cq_nalb_pri_arbindex_mem_we),
       .rf_cq_nalb_pri_arbindex_mem_waddr                        (i_hqm_sip_rf_cq_nalb_pri_arbindex_mem_waddr),
       .rf_cq_nalb_pri_arbindex_mem_wdata                        (i_hqm_sip_rf_cq_nalb_pri_arbindex_mem_wdata),
       .rf_cq_nalb_pri_arbindex_mem_rclk                         (i_hqm_sip_rf_cq_nalb_pri_arbindex_mem_rclk),
       .rf_cq_nalb_pri_arbindex_mem_rclk_rst_n                   (i_hqm_sip_rf_cq_nalb_pri_arbindex_mem_rclk_rst_n),
       .rf_cq_nalb_pri_arbindex_mem_re                           (i_hqm_sip_rf_cq_nalb_pri_arbindex_mem_re),
       .rf_cq_nalb_pri_arbindex_mem_raddr                        (i_hqm_sip_rf_cq_nalb_pri_arbindex_mem_raddr),
       .rf_cq_nalb_pri_arbindex_mem_rdata                        (i_hqm_list_sel_mem_rf_cq_nalb_pri_arbindex_mem_rdata),
       .rf_cq_nalb_pri_arbindex_mem_isol_en                      (i_hqm_sip_pgcb_isol_en),
       .rf_cq_nalb_pri_arbindex_mem_pwr_enable_b_in              (i_hqm_list_sel_mem_rf_cq_ldb_wu_count_mem_pwr_enable_b_out),
       .rf_cq_nalb_pri_arbindex_mem_pwr_enable_b_out             (i_hqm_list_sel_mem_rf_cq_nalb_pri_arbindex_mem_pwr_enable_b_out),
       .rf_dir_enq_cnt_mem_wclk                                  (i_hqm_sip_rf_dir_enq_cnt_mem_wclk),
       .rf_dir_enq_cnt_mem_wclk_rst_n                            (i_hqm_sip_rf_dir_enq_cnt_mem_wclk_rst_n),
       .rf_dir_enq_cnt_mem_we                                    (i_hqm_sip_rf_dir_enq_cnt_mem_we),
       .rf_dir_enq_cnt_mem_waddr                                 (i_hqm_sip_rf_dir_enq_cnt_mem_waddr),
       .rf_dir_enq_cnt_mem_wdata                                 (i_hqm_sip_rf_dir_enq_cnt_mem_wdata),
       .rf_dir_enq_cnt_mem_rclk                                  (i_hqm_sip_rf_dir_enq_cnt_mem_rclk),
       .rf_dir_enq_cnt_mem_rclk_rst_n                            (i_hqm_sip_rf_dir_enq_cnt_mem_rclk_rst_n),
       .rf_dir_enq_cnt_mem_re                                    (i_hqm_sip_rf_dir_enq_cnt_mem_re),
       .rf_dir_enq_cnt_mem_raddr                                 (i_hqm_sip_rf_dir_enq_cnt_mem_raddr),
       .rf_dir_enq_cnt_mem_rdata                                 (i_hqm_list_sel_mem_rf_dir_enq_cnt_mem_rdata),
       .rf_dir_enq_cnt_mem_isol_en                               (i_hqm_sip_pgcb_isol_en),
       .rf_dir_enq_cnt_mem_pwr_enable_b_in                       (i_hqm_list_sel_mem_rf_cq_nalb_pri_arbindex_mem_pwr_enable_b_out),
       .rf_dir_enq_cnt_mem_pwr_enable_b_out                      (i_hqm_list_sel_mem_rf_dir_enq_cnt_mem_pwr_enable_b_out),
       .rf_dir_tok_cnt_mem_wclk                                  (i_hqm_sip_rf_dir_tok_cnt_mem_wclk),
       .rf_dir_tok_cnt_mem_wclk_rst_n                            (i_hqm_sip_rf_dir_tok_cnt_mem_wclk_rst_n),
       .rf_dir_tok_cnt_mem_we                                    (i_hqm_sip_rf_dir_tok_cnt_mem_we),
       .rf_dir_tok_cnt_mem_waddr                                 (i_hqm_sip_rf_dir_tok_cnt_mem_waddr),
       .rf_dir_tok_cnt_mem_wdata                                 (i_hqm_sip_rf_dir_tok_cnt_mem_wdata),
       .rf_dir_tok_cnt_mem_rclk                                  (i_hqm_sip_rf_dir_tok_cnt_mem_rclk),
       .rf_dir_tok_cnt_mem_rclk_rst_n                            (i_hqm_sip_rf_dir_tok_cnt_mem_rclk_rst_n),
       .rf_dir_tok_cnt_mem_re                                    (i_hqm_sip_rf_dir_tok_cnt_mem_re),
       .rf_dir_tok_cnt_mem_raddr                                 (i_hqm_sip_rf_dir_tok_cnt_mem_raddr),
       .rf_dir_tok_cnt_mem_rdata                                 (i_hqm_list_sel_mem_rf_dir_tok_cnt_mem_rdata),
       .rf_dir_tok_cnt_mem_isol_en                               (i_hqm_sip_pgcb_isol_en),
       .rf_dir_tok_cnt_mem_pwr_enable_b_in                       (i_hqm_list_sel_mem_rf_dir_enq_cnt_mem_pwr_enable_b_out),
       .rf_dir_tok_cnt_mem_pwr_enable_b_out                      (i_hqm_list_sel_mem_rf_dir_tok_cnt_mem_pwr_enable_b_out),
       .rf_dir_tok_lim_mem_wclk                                  (i_hqm_sip_rf_dir_tok_lim_mem_wclk),
       .rf_dir_tok_lim_mem_wclk_rst_n                            (i_hqm_sip_rf_dir_tok_lim_mem_wclk_rst_n),
       .rf_dir_tok_lim_mem_we                                    (i_hqm_sip_rf_dir_tok_lim_mem_we),
       .rf_dir_tok_lim_mem_waddr                                 (i_hqm_sip_rf_dir_tok_lim_mem_waddr),
       .rf_dir_tok_lim_mem_wdata                                 (i_hqm_sip_rf_dir_tok_lim_mem_wdata),
       .rf_dir_tok_lim_mem_rclk                                  (i_hqm_sip_rf_dir_tok_lim_mem_rclk),
       .rf_dir_tok_lim_mem_rclk_rst_n                            (i_hqm_sip_rf_dir_tok_lim_mem_rclk_rst_n),
       .rf_dir_tok_lim_mem_re                                    (i_hqm_sip_rf_dir_tok_lim_mem_re),
       .rf_dir_tok_lim_mem_raddr                                 (i_hqm_sip_rf_dir_tok_lim_mem_raddr),
       .rf_dir_tok_lim_mem_rdata                                 (i_hqm_list_sel_mem_rf_dir_tok_lim_mem_rdata),
       .rf_dir_tok_lim_mem_isol_en                               (i_hqm_sip_pgcb_isol_en),
       .rf_dir_tok_lim_mem_pwr_enable_b_in                       (i_hqm_list_sel_mem_rf_dir_tok_cnt_mem_pwr_enable_b_out),
       .rf_dir_tok_lim_mem_pwr_enable_b_out                      (i_hqm_list_sel_mem_rf_dir_tok_lim_mem_pwr_enable_b_out),
       .rf_dp_lsp_enq_dir_rx_sync_fifo_mem_wclk                  (i_hqm_sip_rf_dp_lsp_enq_dir_rx_sync_fifo_mem_wclk),
       .rf_dp_lsp_enq_dir_rx_sync_fifo_mem_wclk_rst_n            (i_hqm_sip_rf_dp_lsp_enq_dir_rx_sync_fifo_mem_wclk_rst_n),
       .rf_dp_lsp_enq_dir_rx_sync_fifo_mem_we                    (i_hqm_sip_rf_dp_lsp_enq_dir_rx_sync_fifo_mem_we),
       .rf_dp_lsp_enq_dir_rx_sync_fifo_mem_waddr                 (i_hqm_sip_rf_dp_lsp_enq_dir_rx_sync_fifo_mem_waddr),
       .rf_dp_lsp_enq_dir_rx_sync_fifo_mem_wdata                 (i_hqm_sip_rf_dp_lsp_enq_dir_rx_sync_fifo_mem_wdata),
       .rf_dp_lsp_enq_dir_rx_sync_fifo_mem_rclk                  (i_hqm_sip_rf_dp_lsp_enq_dir_rx_sync_fifo_mem_rclk),
       .rf_dp_lsp_enq_dir_rx_sync_fifo_mem_rclk_rst_n            (i_hqm_sip_rf_dp_lsp_enq_dir_rx_sync_fifo_mem_rclk_rst_n),
       .rf_dp_lsp_enq_dir_rx_sync_fifo_mem_re                    (i_hqm_sip_rf_dp_lsp_enq_dir_rx_sync_fifo_mem_re),
       .rf_dp_lsp_enq_dir_rx_sync_fifo_mem_raddr                 (i_hqm_sip_rf_dp_lsp_enq_dir_rx_sync_fifo_mem_raddr),
       .rf_dp_lsp_enq_dir_rx_sync_fifo_mem_rdata                 (i_hqm_list_sel_mem_rf_dp_lsp_enq_dir_rx_sync_fifo_mem_rdata),
       .rf_dp_lsp_enq_dir_rx_sync_fifo_mem_isol_en               (i_hqm_sip_pgcb_isol_en),
       .rf_dp_lsp_enq_dir_rx_sync_fifo_mem_pwr_enable_b_in       (i_hqm_list_sel_mem_rf_dir_tok_lim_mem_pwr_enable_b_out),
       .rf_dp_lsp_enq_dir_rx_sync_fifo_mem_pwr_enable_b_out      (i_hqm_list_sel_mem_rf_dp_lsp_enq_dir_rx_sync_fifo_mem_pwr_enable_b_out),
       .rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_wclk               (i_hqm_sip_rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_wclk),
       .rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_wclk_rst_n         (i_hqm_sip_rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_wclk_rst_n),
       .rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_we                 (i_hqm_sip_rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_we),
       .rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_waddr              (i_hqm_sip_rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_waddr),
       .rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_wdata              (i_hqm_sip_rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_wdata),
       .rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_rclk               (i_hqm_sip_rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_rclk),
       .rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_rclk_rst_n         (i_hqm_sip_rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_rclk_rst_n),
       .rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_re                 (i_hqm_sip_rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_re),
       .rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_raddr              (i_hqm_sip_rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_raddr),
       .rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_rdata              (i_hqm_list_sel_mem_rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_rdata),
       .rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_isol_en            (i_hqm_sip_pgcb_isol_en),
       .rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_pwr_enable_b_in    (i_hqm_list_sel_mem_rf_dp_lsp_enq_dir_rx_sync_fifo_mem_pwr_enable_b_out),
       .rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_pwr_enable_b_out   (i_hqm_list_sel_mem_rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_pwr_enable_b_out),
       .rf_enq_nalb_fifo_mem_wclk                                (i_hqm_sip_rf_enq_nalb_fifo_mem_wclk),
       .rf_enq_nalb_fifo_mem_wclk_rst_n                          (i_hqm_sip_rf_enq_nalb_fifo_mem_wclk_rst_n),
       .rf_enq_nalb_fifo_mem_we                                  (i_hqm_sip_rf_enq_nalb_fifo_mem_we),
       .rf_enq_nalb_fifo_mem_waddr                               (i_hqm_sip_rf_enq_nalb_fifo_mem_waddr),
       .rf_enq_nalb_fifo_mem_wdata                               (i_hqm_sip_rf_enq_nalb_fifo_mem_wdata),
       .rf_enq_nalb_fifo_mem_rclk                                (i_hqm_sip_rf_enq_nalb_fifo_mem_rclk),
       .rf_enq_nalb_fifo_mem_rclk_rst_n                          (i_hqm_sip_rf_enq_nalb_fifo_mem_rclk_rst_n),
       .rf_enq_nalb_fifo_mem_re                                  (i_hqm_sip_rf_enq_nalb_fifo_mem_re),
       .rf_enq_nalb_fifo_mem_raddr                               (i_hqm_sip_rf_enq_nalb_fifo_mem_raddr),
       .rf_enq_nalb_fifo_mem_rdata                               (i_hqm_list_sel_mem_rf_enq_nalb_fifo_mem_rdata),
       .rf_enq_nalb_fifo_mem_isol_en                             (i_hqm_sip_pgcb_isol_en),
       .rf_enq_nalb_fifo_mem_pwr_enable_b_in                     (i_hqm_list_sel_mem_rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_pwr_enable_b_out),
       .rf_enq_nalb_fifo_mem_pwr_enable_b_out                    (i_hqm_list_sel_mem_rf_enq_nalb_fifo_mem_pwr_enable_b_out),
       .rf_fid2cqqidix_wclk                                      (i_hqm_sip_rf_fid2cqqidix_wclk),
       .rf_fid2cqqidix_wclk_rst_n                                (i_hqm_sip_rf_fid2cqqidix_wclk_rst_n),
       .rf_fid2cqqidix_we                                        (i_hqm_sip_rf_fid2cqqidix_we),
       .rf_fid2cqqidix_waddr                                     (i_hqm_sip_rf_fid2cqqidix_waddr),
       .rf_fid2cqqidix_wdata                                     (i_hqm_sip_rf_fid2cqqidix_wdata),
       .rf_fid2cqqidix_rclk                                      (i_hqm_sip_rf_fid2cqqidix_rclk),
       .rf_fid2cqqidix_rclk_rst_n                                (i_hqm_sip_rf_fid2cqqidix_rclk_rst_n),
       .rf_fid2cqqidix_re                                        (i_hqm_sip_rf_fid2cqqidix_re),
       .rf_fid2cqqidix_raddr                                     (i_hqm_sip_rf_fid2cqqidix_raddr),
       .rf_fid2cqqidix_rdata                                     (i_hqm_list_sel_mem_rf_fid2cqqidix_rdata),
       .rf_fid2cqqidix_isol_en                                   (i_hqm_sip_pgcb_isol_en),
       .rf_fid2cqqidix_pwr_enable_b_in                           (i_hqm_list_sel_mem_rf_enq_nalb_fifo_mem_pwr_enable_b_out),
       .rf_fid2cqqidix_pwr_enable_b_out                          (i_hqm_list_sel_mem_rf_fid2cqqidix_pwr_enable_b_out),
       .rf_ldb_token_rtn_fifo_mem_wclk                           (i_hqm_sip_rf_ldb_token_rtn_fifo_mem_wclk),
       .rf_ldb_token_rtn_fifo_mem_wclk_rst_n                     (i_hqm_sip_rf_ldb_token_rtn_fifo_mem_wclk_rst_n),
       .rf_ldb_token_rtn_fifo_mem_we                             (i_hqm_sip_rf_ldb_token_rtn_fifo_mem_we),
       .rf_ldb_token_rtn_fifo_mem_waddr                          (i_hqm_sip_rf_ldb_token_rtn_fifo_mem_waddr),
       .rf_ldb_token_rtn_fifo_mem_wdata                          (i_hqm_sip_rf_ldb_token_rtn_fifo_mem_wdata),
       .rf_ldb_token_rtn_fifo_mem_rclk                           (i_hqm_sip_rf_ldb_token_rtn_fifo_mem_rclk),
       .rf_ldb_token_rtn_fifo_mem_rclk_rst_n                     (i_hqm_sip_rf_ldb_token_rtn_fifo_mem_rclk_rst_n),
       .rf_ldb_token_rtn_fifo_mem_re                             (i_hqm_sip_rf_ldb_token_rtn_fifo_mem_re),
       .rf_ldb_token_rtn_fifo_mem_raddr                          (i_hqm_sip_rf_ldb_token_rtn_fifo_mem_raddr),
       .rf_ldb_token_rtn_fifo_mem_rdata                          (i_hqm_list_sel_mem_rf_ldb_token_rtn_fifo_mem_rdata),
       .rf_ldb_token_rtn_fifo_mem_isol_en                        (i_hqm_sip_pgcb_isol_en),
       .rf_ldb_token_rtn_fifo_mem_pwr_enable_b_in                (i_hqm_list_sel_mem_rf_fid2cqqidix_pwr_enable_b_out),
       .rf_ldb_token_rtn_fifo_mem_pwr_enable_b_out               (i_hqm_list_sel_mem_rf_ldb_token_rtn_fifo_mem_pwr_enable_b_out),
       .rf_ll_enq_cnt_r_bin0_dup0_wclk                           (i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup0_wclk),
       .rf_ll_enq_cnt_r_bin0_dup0_wclk_rst_n                     (i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup0_wclk_rst_n),
       .rf_ll_enq_cnt_r_bin0_dup0_we                             (i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup0_we),
       .rf_ll_enq_cnt_r_bin0_dup0_waddr                          (i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup0_waddr),
       .rf_ll_enq_cnt_r_bin0_dup0_wdata                          (i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup0_wdata),
       .rf_ll_enq_cnt_r_bin0_dup0_rclk                           (i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup0_rclk),
       .rf_ll_enq_cnt_r_bin0_dup0_rclk_rst_n                     (i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup0_rclk_rst_n),
       .rf_ll_enq_cnt_r_bin0_dup0_re                             (i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup0_re),
       .rf_ll_enq_cnt_r_bin0_dup0_raddr                          (i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup0_raddr),
       .rf_ll_enq_cnt_r_bin0_dup0_rdata                          (i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin0_dup0_rdata),
       .rf_ll_enq_cnt_r_bin0_dup0_isol_en                        (i_hqm_sip_pgcb_isol_en),
       .rf_ll_enq_cnt_r_bin0_dup0_pwr_enable_b_in                (i_hqm_list_sel_mem_rf_ldb_token_rtn_fifo_mem_pwr_enable_b_out),
       .rf_ll_enq_cnt_r_bin0_dup0_pwr_enable_b_out               (i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin0_dup0_pwr_enable_b_out),
       .rf_ll_enq_cnt_r_bin0_dup1_wclk                           (i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup1_wclk),
       .rf_ll_enq_cnt_r_bin0_dup1_wclk_rst_n                     (i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup1_wclk_rst_n),
       .rf_ll_enq_cnt_r_bin0_dup1_we                             (i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup1_we),
       .rf_ll_enq_cnt_r_bin0_dup1_waddr                          (i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup1_waddr),
       .rf_ll_enq_cnt_r_bin0_dup1_wdata                          (i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup1_wdata),
       .rf_ll_enq_cnt_r_bin0_dup1_rclk                           (i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup1_rclk),
       .rf_ll_enq_cnt_r_bin0_dup1_rclk_rst_n                     (i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup1_rclk_rst_n),
       .rf_ll_enq_cnt_r_bin0_dup1_re                             (i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup1_re),
       .rf_ll_enq_cnt_r_bin0_dup1_raddr                          (i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup1_raddr),
       .rf_ll_enq_cnt_r_bin0_dup1_rdata                          (i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin0_dup1_rdata),
       .rf_ll_enq_cnt_r_bin0_dup1_isol_en                        (i_hqm_sip_pgcb_isol_en),
       .rf_ll_enq_cnt_r_bin0_dup1_pwr_enable_b_in                (i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin0_dup0_pwr_enable_b_out),
       .rf_ll_enq_cnt_r_bin0_dup1_pwr_enable_b_out               (i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin0_dup1_pwr_enable_b_out),
       .rf_ll_enq_cnt_r_bin0_dup2_wclk                           (i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup2_wclk),
       .rf_ll_enq_cnt_r_bin0_dup2_wclk_rst_n                     (i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup2_wclk_rst_n),
       .rf_ll_enq_cnt_r_bin0_dup2_we                             (i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup2_we),
       .rf_ll_enq_cnt_r_bin0_dup2_waddr                          (i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup2_waddr),
       .rf_ll_enq_cnt_r_bin0_dup2_wdata                          (i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup2_wdata),
       .rf_ll_enq_cnt_r_bin0_dup2_rclk                           (i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup2_rclk),
       .rf_ll_enq_cnt_r_bin0_dup2_rclk_rst_n                     (i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup2_rclk_rst_n),
       .rf_ll_enq_cnt_r_bin0_dup2_re                             (i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup2_re),
       .rf_ll_enq_cnt_r_bin0_dup2_raddr                          (i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup2_raddr),
       .rf_ll_enq_cnt_r_bin0_dup2_rdata                          (i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin0_dup2_rdata),
       .rf_ll_enq_cnt_r_bin0_dup2_isol_en                        (i_hqm_sip_pgcb_isol_en),
       .rf_ll_enq_cnt_r_bin0_dup2_pwr_enable_b_in                (i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin0_dup1_pwr_enable_b_out),
       .rf_ll_enq_cnt_r_bin0_dup2_pwr_enable_b_out               (i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin0_dup2_pwr_enable_b_out),
       .rf_ll_enq_cnt_r_bin0_dup3_wclk                           (i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup3_wclk),
       .rf_ll_enq_cnt_r_bin0_dup3_wclk_rst_n                     (i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup3_wclk_rst_n),
       .rf_ll_enq_cnt_r_bin0_dup3_we                             (i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup3_we),
       .rf_ll_enq_cnt_r_bin0_dup3_waddr                          (i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup3_waddr),
       .rf_ll_enq_cnt_r_bin0_dup3_wdata                          (i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup3_wdata),
       .rf_ll_enq_cnt_r_bin0_dup3_rclk                           (i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup3_rclk),
       .rf_ll_enq_cnt_r_bin0_dup3_rclk_rst_n                     (i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup3_rclk_rst_n),
       .rf_ll_enq_cnt_r_bin0_dup3_re                             (i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup3_re),
       .rf_ll_enq_cnt_r_bin0_dup3_raddr                          (i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup3_raddr),
       .rf_ll_enq_cnt_r_bin0_dup3_rdata                          (i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin0_dup3_rdata),
       .rf_ll_enq_cnt_r_bin0_dup3_isol_en                        (i_hqm_sip_pgcb_isol_en),
       .rf_ll_enq_cnt_r_bin0_dup3_pwr_enable_b_in                (i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin0_dup2_pwr_enable_b_out),
       .rf_ll_enq_cnt_r_bin0_dup3_pwr_enable_b_out               (i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin0_dup3_pwr_enable_b_out),
       .rf_ll_enq_cnt_r_bin1_dup0_wclk                           (i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup0_wclk),
       .rf_ll_enq_cnt_r_bin1_dup0_wclk_rst_n                     (i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup0_wclk_rst_n),
       .rf_ll_enq_cnt_r_bin1_dup0_we                             (i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup0_we),
       .rf_ll_enq_cnt_r_bin1_dup0_waddr                          (i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup0_waddr),
       .rf_ll_enq_cnt_r_bin1_dup0_wdata                          (i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup0_wdata),
       .rf_ll_enq_cnt_r_bin1_dup0_rclk                           (i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup0_rclk),
       .rf_ll_enq_cnt_r_bin1_dup0_rclk_rst_n                     (i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup0_rclk_rst_n),
       .rf_ll_enq_cnt_r_bin1_dup0_re                             (i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup0_re),
       .rf_ll_enq_cnt_r_bin1_dup0_raddr                          (i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup0_raddr),
       .rf_ll_enq_cnt_r_bin1_dup0_rdata                          (i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin1_dup0_rdata),
       .rf_ll_enq_cnt_r_bin1_dup0_isol_en                        (i_hqm_sip_pgcb_isol_en),
       .rf_ll_enq_cnt_r_bin1_dup0_pwr_enable_b_in                (i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin0_dup3_pwr_enable_b_out),
       .rf_ll_enq_cnt_r_bin1_dup0_pwr_enable_b_out               (i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin1_dup0_pwr_enable_b_out),
       .rf_ll_enq_cnt_r_bin1_dup1_wclk                           (i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup1_wclk),
       .rf_ll_enq_cnt_r_bin1_dup1_wclk_rst_n                     (i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup1_wclk_rst_n),
       .rf_ll_enq_cnt_r_bin1_dup1_we                             (i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup1_we),
       .rf_ll_enq_cnt_r_bin1_dup1_waddr                          (i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup1_waddr),
       .rf_ll_enq_cnt_r_bin1_dup1_wdata                          (i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup1_wdata),
       .rf_ll_enq_cnt_r_bin1_dup1_rclk                           (i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup1_rclk),
       .rf_ll_enq_cnt_r_bin1_dup1_rclk_rst_n                     (i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup1_rclk_rst_n),
       .rf_ll_enq_cnt_r_bin1_dup1_re                             (i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup1_re),
       .rf_ll_enq_cnt_r_bin1_dup1_raddr                          (i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup1_raddr),
       .rf_ll_enq_cnt_r_bin1_dup1_rdata                          (i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin1_dup1_rdata),
       .rf_ll_enq_cnt_r_bin1_dup1_isol_en                        (i_hqm_sip_pgcb_isol_en),
       .rf_ll_enq_cnt_r_bin1_dup1_pwr_enable_b_in                (i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin1_dup0_pwr_enable_b_out),
       .rf_ll_enq_cnt_r_bin1_dup1_pwr_enable_b_out               (i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin1_dup1_pwr_enable_b_out),
       .rf_ll_enq_cnt_r_bin1_dup2_wclk                           (i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup2_wclk),
       .rf_ll_enq_cnt_r_bin1_dup2_wclk_rst_n                     (i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup2_wclk_rst_n),
       .rf_ll_enq_cnt_r_bin1_dup2_we                             (i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup2_we),
       .rf_ll_enq_cnt_r_bin1_dup2_waddr                          (i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup2_waddr),
       .rf_ll_enq_cnt_r_bin1_dup2_wdata                          (i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup2_wdata),
       .rf_ll_enq_cnt_r_bin1_dup2_rclk                           (i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup2_rclk),
       .rf_ll_enq_cnt_r_bin1_dup2_rclk_rst_n                     (i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup2_rclk_rst_n),
       .rf_ll_enq_cnt_r_bin1_dup2_re                             (i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup2_re),
       .rf_ll_enq_cnt_r_bin1_dup2_raddr                          (i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup2_raddr),
       .rf_ll_enq_cnt_r_bin1_dup2_rdata                          (i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin1_dup2_rdata),
       .rf_ll_enq_cnt_r_bin1_dup2_isol_en                        (i_hqm_sip_pgcb_isol_en),
       .rf_ll_enq_cnt_r_bin1_dup2_pwr_enable_b_in                (i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin1_dup1_pwr_enable_b_out),
       .rf_ll_enq_cnt_r_bin1_dup2_pwr_enable_b_out               (i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin1_dup2_pwr_enable_b_out),
       .rf_ll_enq_cnt_r_bin1_dup3_wclk                           (i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup3_wclk),
       .rf_ll_enq_cnt_r_bin1_dup3_wclk_rst_n                     (i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup3_wclk_rst_n),
       .rf_ll_enq_cnt_r_bin1_dup3_we                             (i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup3_we),
       .rf_ll_enq_cnt_r_bin1_dup3_waddr                          (i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup3_waddr),
       .rf_ll_enq_cnt_r_bin1_dup3_wdata                          (i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup3_wdata),
       .rf_ll_enq_cnt_r_bin1_dup3_rclk                           (i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup3_rclk),
       .rf_ll_enq_cnt_r_bin1_dup3_rclk_rst_n                     (i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup3_rclk_rst_n),
       .rf_ll_enq_cnt_r_bin1_dup3_re                             (i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup3_re),
       .rf_ll_enq_cnt_r_bin1_dup3_raddr                          (i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup3_raddr),
       .rf_ll_enq_cnt_r_bin1_dup3_rdata                          (i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin1_dup3_rdata),
       .rf_ll_enq_cnt_r_bin1_dup3_isol_en                        (i_hqm_sip_pgcb_isol_en),
       .rf_ll_enq_cnt_r_bin1_dup3_pwr_enable_b_in                (i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin1_dup2_pwr_enable_b_out),
       .rf_ll_enq_cnt_r_bin1_dup3_pwr_enable_b_out               (i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin1_dup3_pwr_enable_b_out),
       .rf_ll_enq_cnt_r_bin2_dup0_wclk                           (i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup0_wclk),
       .rf_ll_enq_cnt_r_bin2_dup0_wclk_rst_n                     (i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup0_wclk_rst_n),
       .rf_ll_enq_cnt_r_bin2_dup0_we                             (i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup0_we),
       .rf_ll_enq_cnt_r_bin2_dup0_waddr                          (i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup0_waddr),
       .rf_ll_enq_cnt_r_bin2_dup0_wdata                          (i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup0_wdata),
       .rf_ll_enq_cnt_r_bin2_dup0_rclk                           (i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup0_rclk),
       .rf_ll_enq_cnt_r_bin2_dup0_rclk_rst_n                     (i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup0_rclk_rst_n),
       .rf_ll_enq_cnt_r_bin2_dup0_re                             (i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup0_re),
       .rf_ll_enq_cnt_r_bin2_dup0_raddr                          (i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup0_raddr),
       .rf_ll_enq_cnt_r_bin2_dup0_rdata                          (i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin2_dup0_rdata),
       .rf_ll_enq_cnt_r_bin2_dup0_isol_en                        (i_hqm_sip_pgcb_isol_en),
       .rf_ll_enq_cnt_r_bin2_dup0_pwr_enable_b_in                (i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin1_dup3_pwr_enable_b_out),
       .rf_ll_enq_cnt_r_bin2_dup0_pwr_enable_b_out               (i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin2_dup0_pwr_enable_b_out),
       .rf_ll_enq_cnt_r_bin2_dup1_wclk                           (i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup1_wclk),
       .rf_ll_enq_cnt_r_bin2_dup1_wclk_rst_n                     (i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup1_wclk_rst_n),
       .rf_ll_enq_cnt_r_bin2_dup1_we                             (i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup1_we),
       .rf_ll_enq_cnt_r_bin2_dup1_waddr                          (i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup1_waddr),
       .rf_ll_enq_cnt_r_bin2_dup1_wdata                          (i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup1_wdata),
       .rf_ll_enq_cnt_r_bin2_dup1_rclk                           (i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup1_rclk),
       .rf_ll_enq_cnt_r_bin2_dup1_rclk_rst_n                     (i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup1_rclk_rst_n),
       .rf_ll_enq_cnt_r_bin2_dup1_re                             (i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup1_re),
       .rf_ll_enq_cnt_r_bin2_dup1_raddr                          (i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup1_raddr),
       .rf_ll_enq_cnt_r_bin2_dup1_rdata                          (i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin2_dup1_rdata),
       .rf_ll_enq_cnt_r_bin2_dup1_isol_en                        (i_hqm_sip_pgcb_isol_en),
       .rf_ll_enq_cnt_r_bin2_dup1_pwr_enable_b_in                (i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin2_dup0_pwr_enable_b_out),
       .rf_ll_enq_cnt_r_bin2_dup1_pwr_enable_b_out               (i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin2_dup1_pwr_enable_b_out),
       .rf_ll_enq_cnt_r_bin2_dup2_wclk                           (i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup2_wclk),
       .rf_ll_enq_cnt_r_bin2_dup2_wclk_rst_n                     (i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup2_wclk_rst_n),
       .rf_ll_enq_cnt_r_bin2_dup2_we                             (i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup2_we),
       .rf_ll_enq_cnt_r_bin2_dup2_waddr                          (i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup2_waddr),
       .rf_ll_enq_cnt_r_bin2_dup2_wdata                          (i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup2_wdata),
       .rf_ll_enq_cnt_r_bin2_dup2_rclk                           (i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup2_rclk),
       .rf_ll_enq_cnt_r_bin2_dup2_rclk_rst_n                     (i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup2_rclk_rst_n),
       .rf_ll_enq_cnt_r_bin2_dup2_re                             (i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup2_re),
       .rf_ll_enq_cnt_r_bin2_dup2_raddr                          (i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup2_raddr),
       .rf_ll_enq_cnt_r_bin2_dup2_rdata                          (i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin2_dup2_rdata),
       .rf_ll_enq_cnt_r_bin2_dup2_isol_en                        (i_hqm_sip_pgcb_isol_en),
       .rf_ll_enq_cnt_r_bin2_dup2_pwr_enable_b_in                (i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin2_dup1_pwr_enable_b_out),
       .rf_ll_enq_cnt_r_bin2_dup2_pwr_enable_b_out               (i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin2_dup2_pwr_enable_b_out),
       .rf_ll_enq_cnt_r_bin2_dup3_wclk                           (i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup3_wclk),
       .rf_ll_enq_cnt_r_bin2_dup3_wclk_rst_n                     (i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup3_wclk_rst_n),
       .rf_ll_enq_cnt_r_bin2_dup3_we                             (i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup3_we),
       .rf_ll_enq_cnt_r_bin2_dup3_waddr                          (i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup3_waddr),
       .rf_ll_enq_cnt_r_bin2_dup3_wdata                          (i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup3_wdata),
       .rf_ll_enq_cnt_r_bin2_dup3_rclk                           (i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup3_rclk),
       .rf_ll_enq_cnt_r_bin2_dup3_rclk_rst_n                     (i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup3_rclk_rst_n),
       .rf_ll_enq_cnt_r_bin2_dup3_re                             (i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup3_re),
       .rf_ll_enq_cnt_r_bin2_dup3_raddr                          (i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup3_raddr),
       .rf_ll_enq_cnt_r_bin2_dup3_rdata                          (i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin2_dup3_rdata),
       .rf_ll_enq_cnt_r_bin2_dup3_isol_en                        (i_hqm_sip_pgcb_isol_en),
       .rf_ll_enq_cnt_r_bin2_dup3_pwr_enable_b_in                (i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin2_dup2_pwr_enable_b_out),
       .rf_ll_enq_cnt_r_bin2_dup3_pwr_enable_b_out               (i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin2_dup3_pwr_enable_b_out),
       .rf_ll_enq_cnt_r_bin3_dup0_wclk                           (i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup0_wclk),
       .rf_ll_enq_cnt_r_bin3_dup0_wclk_rst_n                     (i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup0_wclk_rst_n),
       .rf_ll_enq_cnt_r_bin3_dup0_we                             (i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup0_we),
       .rf_ll_enq_cnt_r_bin3_dup0_waddr                          (i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup0_waddr),
       .rf_ll_enq_cnt_r_bin3_dup0_wdata                          (i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup0_wdata),
       .rf_ll_enq_cnt_r_bin3_dup0_rclk                           (i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup0_rclk),
       .rf_ll_enq_cnt_r_bin3_dup0_rclk_rst_n                     (i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup0_rclk_rst_n),
       .rf_ll_enq_cnt_r_bin3_dup0_re                             (i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup0_re),
       .rf_ll_enq_cnt_r_bin3_dup0_raddr                          (i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup0_raddr),
       .rf_ll_enq_cnt_r_bin3_dup0_rdata                          (i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin3_dup0_rdata),
       .rf_ll_enq_cnt_r_bin3_dup0_isol_en                        (i_hqm_sip_pgcb_isol_en),
       .rf_ll_enq_cnt_r_bin3_dup0_pwr_enable_b_in                (i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin2_dup3_pwr_enable_b_out),
       .rf_ll_enq_cnt_r_bin3_dup0_pwr_enable_b_out               (i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin3_dup0_pwr_enable_b_out),
       .rf_ll_enq_cnt_r_bin3_dup1_wclk                           (i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup1_wclk),
       .rf_ll_enq_cnt_r_bin3_dup1_wclk_rst_n                     (i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup1_wclk_rst_n),
       .rf_ll_enq_cnt_r_bin3_dup1_we                             (i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup1_we),
       .rf_ll_enq_cnt_r_bin3_dup1_waddr                          (i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup1_waddr),
       .rf_ll_enq_cnt_r_bin3_dup1_wdata                          (i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup1_wdata),
       .rf_ll_enq_cnt_r_bin3_dup1_rclk                           (i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup1_rclk),
       .rf_ll_enq_cnt_r_bin3_dup1_rclk_rst_n                     (i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup1_rclk_rst_n),
       .rf_ll_enq_cnt_r_bin3_dup1_re                             (i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup1_re),
       .rf_ll_enq_cnt_r_bin3_dup1_raddr                          (i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup1_raddr),
       .rf_ll_enq_cnt_r_bin3_dup1_rdata                          (i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin3_dup1_rdata),
       .rf_ll_enq_cnt_r_bin3_dup1_isol_en                        (i_hqm_sip_pgcb_isol_en),
       .rf_ll_enq_cnt_r_bin3_dup1_pwr_enable_b_in                (i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin3_dup0_pwr_enable_b_out),
       .rf_ll_enq_cnt_r_bin3_dup1_pwr_enable_b_out               (i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin3_dup1_pwr_enable_b_out),
       .rf_ll_enq_cnt_r_bin3_dup2_wclk                           (i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup2_wclk),
       .rf_ll_enq_cnt_r_bin3_dup2_wclk_rst_n                     (i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup2_wclk_rst_n),
       .rf_ll_enq_cnt_r_bin3_dup2_we                             (i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup2_we),
       .rf_ll_enq_cnt_r_bin3_dup2_waddr                          (i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup2_waddr),
       .rf_ll_enq_cnt_r_bin3_dup2_wdata                          (i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup2_wdata),
       .rf_ll_enq_cnt_r_bin3_dup2_rclk                           (i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup2_rclk),
       .rf_ll_enq_cnt_r_bin3_dup2_rclk_rst_n                     (i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup2_rclk_rst_n),
       .rf_ll_enq_cnt_r_bin3_dup2_re                             (i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup2_re),
       .rf_ll_enq_cnt_r_bin3_dup2_raddr                          (i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup2_raddr),
       .rf_ll_enq_cnt_r_bin3_dup2_rdata                          (i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin3_dup2_rdata),
       .rf_ll_enq_cnt_r_bin3_dup2_isol_en                        (i_hqm_sip_pgcb_isol_en),
       .rf_ll_enq_cnt_r_bin3_dup2_pwr_enable_b_in                (i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin3_dup1_pwr_enable_b_out),
       .rf_ll_enq_cnt_r_bin3_dup2_pwr_enable_b_out               (i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin3_dup2_pwr_enable_b_out),
       .rf_ll_enq_cnt_r_bin3_dup3_wclk                           (i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup3_wclk),
       .rf_ll_enq_cnt_r_bin3_dup3_wclk_rst_n                     (i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup3_wclk_rst_n),
       .rf_ll_enq_cnt_r_bin3_dup3_we                             (i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup3_we),
       .rf_ll_enq_cnt_r_bin3_dup3_waddr                          (i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup3_waddr),
       .rf_ll_enq_cnt_r_bin3_dup3_wdata                          (i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup3_wdata),
       .rf_ll_enq_cnt_r_bin3_dup3_rclk                           (i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup3_rclk),
       .rf_ll_enq_cnt_r_bin3_dup3_rclk_rst_n                     (i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup3_rclk_rst_n),
       .rf_ll_enq_cnt_r_bin3_dup3_re                             (i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup3_re),
       .rf_ll_enq_cnt_r_bin3_dup3_raddr                          (i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup3_raddr),
       .rf_ll_enq_cnt_r_bin3_dup3_rdata                          (i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin3_dup3_rdata),
       .rf_ll_enq_cnt_r_bin3_dup3_isol_en                        (i_hqm_sip_pgcb_isol_en),
       .rf_ll_enq_cnt_r_bin3_dup3_pwr_enable_b_in                (i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin3_dup2_pwr_enable_b_out),
       .rf_ll_enq_cnt_r_bin3_dup3_pwr_enable_b_out               (i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin3_dup3_pwr_enable_b_out),
       .rf_ll_enq_cnt_s_bin0_wclk                                (i_hqm_sip_rf_ll_enq_cnt_s_bin0_wclk),
       .rf_ll_enq_cnt_s_bin0_wclk_rst_n                          (i_hqm_sip_rf_ll_enq_cnt_s_bin0_wclk_rst_n),
       .rf_ll_enq_cnt_s_bin0_we                                  (i_hqm_sip_rf_ll_enq_cnt_s_bin0_we),
       .rf_ll_enq_cnt_s_bin0_waddr                               (i_hqm_sip_rf_ll_enq_cnt_s_bin0_waddr),
       .rf_ll_enq_cnt_s_bin0_wdata                               (i_hqm_sip_rf_ll_enq_cnt_s_bin0_wdata),
       .rf_ll_enq_cnt_s_bin0_rclk                                (i_hqm_sip_rf_ll_enq_cnt_s_bin0_rclk),
       .rf_ll_enq_cnt_s_bin0_rclk_rst_n                          (i_hqm_sip_rf_ll_enq_cnt_s_bin0_rclk_rst_n),
       .rf_ll_enq_cnt_s_bin0_re                                  (i_hqm_sip_rf_ll_enq_cnt_s_bin0_re),
       .rf_ll_enq_cnt_s_bin0_raddr                               (i_hqm_sip_rf_ll_enq_cnt_s_bin0_raddr),
       .rf_ll_enq_cnt_s_bin0_rdata                               (i_hqm_list_sel_mem_rf_ll_enq_cnt_s_bin0_rdata),
       .rf_ll_enq_cnt_s_bin0_isol_en                             (i_hqm_sip_pgcb_isol_en),
       .rf_ll_enq_cnt_s_bin0_pwr_enable_b_in                     (i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin3_dup3_pwr_enable_b_out),
       .rf_ll_enq_cnt_s_bin0_pwr_enable_b_out                    (i_hqm_list_sel_mem_rf_ll_enq_cnt_s_bin0_pwr_enable_b_out),
       .rf_ll_enq_cnt_s_bin1_wclk                                (i_hqm_sip_rf_ll_enq_cnt_s_bin1_wclk),
       .rf_ll_enq_cnt_s_bin1_wclk_rst_n                          (i_hqm_sip_rf_ll_enq_cnt_s_bin1_wclk_rst_n),
       .rf_ll_enq_cnt_s_bin1_we                                  (i_hqm_sip_rf_ll_enq_cnt_s_bin1_we),
       .rf_ll_enq_cnt_s_bin1_waddr                               (i_hqm_sip_rf_ll_enq_cnt_s_bin1_waddr),
       .rf_ll_enq_cnt_s_bin1_wdata                               (i_hqm_sip_rf_ll_enq_cnt_s_bin1_wdata),
       .rf_ll_enq_cnt_s_bin1_rclk                                (i_hqm_sip_rf_ll_enq_cnt_s_bin1_rclk),
       .rf_ll_enq_cnt_s_bin1_rclk_rst_n                          (i_hqm_sip_rf_ll_enq_cnt_s_bin1_rclk_rst_n),
       .rf_ll_enq_cnt_s_bin1_re                                  (i_hqm_sip_rf_ll_enq_cnt_s_bin1_re),
       .rf_ll_enq_cnt_s_bin1_raddr                               (i_hqm_sip_rf_ll_enq_cnt_s_bin1_raddr),
       .rf_ll_enq_cnt_s_bin1_rdata                               (i_hqm_list_sel_mem_rf_ll_enq_cnt_s_bin1_rdata),
       .rf_ll_enq_cnt_s_bin1_isol_en                             (i_hqm_sip_pgcb_isol_en),
       .rf_ll_enq_cnt_s_bin1_pwr_enable_b_in                     (i_hqm_list_sel_mem_rf_ll_enq_cnt_s_bin0_pwr_enable_b_out),
       .rf_ll_enq_cnt_s_bin1_pwr_enable_b_out                    (i_hqm_list_sel_mem_rf_ll_enq_cnt_s_bin1_pwr_enable_b_out),
       .rf_ll_enq_cnt_s_bin2_wclk                                (i_hqm_sip_rf_ll_enq_cnt_s_bin2_wclk),
       .rf_ll_enq_cnt_s_bin2_wclk_rst_n                          (i_hqm_sip_rf_ll_enq_cnt_s_bin2_wclk_rst_n),
       .rf_ll_enq_cnt_s_bin2_we                                  (i_hqm_sip_rf_ll_enq_cnt_s_bin2_we),
       .rf_ll_enq_cnt_s_bin2_waddr                               (i_hqm_sip_rf_ll_enq_cnt_s_bin2_waddr),
       .rf_ll_enq_cnt_s_bin2_wdata                               (i_hqm_sip_rf_ll_enq_cnt_s_bin2_wdata),
       .rf_ll_enq_cnt_s_bin2_rclk                                (i_hqm_sip_rf_ll_enq_cnt_s_bin2_rclk),
       .rf_ll_enq_cnt_s_bin2_rclk_rst_n                          (i_hqm_sip_rf_ll_enq_cnt_s_bin2_rclk_rst_n),
       .rf_ll_enq_cnt_s_bin2_re                                  (i_hqm_sip_rf_ll_enq_cnt_s_bin2_re),
       .rf_ll_enq_cnt_s_bin2_raddr                               (i_hqm_sip_rf_ll_enq_cnt_s_bin2_raddr),
       .rf_ll_enq_cnt_s_bin2_rdata                               (i_hqm_list_sel_mem_rf_ll_enq_cnt_s_bin2_rdata),
       .rf_ll_enq_cnt_s_bin2_isol_en                             (i_hqm_sip_pgcb_isol_en),
       .rf_ll_enq_cnt_s_bin2_pwr_enable_b_in                     (i_hqm_list_sel_mem_rf_ll_enq_cnt_s_bin1_pwr_enable_b_out),
       .rf_ll_enq_cnt_s_bin2_pwr_enable_b_out                    (i_hqm_list_sel_mem_rf_ll_enq_cnt_s_bin2_pwr_enable_b_out),
       .rf_ll_enq_cnt_s_bin3_wclk                                (i_hqm_sip_rf_ll_enq_cnt_s_bin3_wclk),
       .rf_ll_enq_cnt_s_bin3_wclk_rst_n                          (i_hqm_sip_rf_ll_enq_cnt_s_bin3_wclk_rst_n),
       .rf_ll_enq_cnt_s_bin3_we                                  (i_hqm_sip_rf_ll_enq_cnt_s_bin3_we),
       .rf_ll_enq_cnt_s_bin3_waddr                               (i_hqm_sip_rf_ll_enq_cnt_s_bin3_waddr),
       .rf_ll_enq_cnt_s_bin3_wdata                               (i_hqm_sip_rf_ll_enq_cnt_s_bin3_wdata),
       .rf_ll_enq_cnt_s_bin3_rclk                                (i_hqm_sip_rf_ll_enq_cnt_s_bin3_rclk),
       .rf_ll_enq_cnt_s_bin3_rclk_rst_n                          (i_hqm_sip_rf_ll_enq_cnt_s_bin3_rclk_rst_n),
       .rf_ll_enq_cnt_s_bin3_re                                  (i_hqm_sip_rf_ll_enq_cnt_s_bin3_re),
       .rf_ll_enq_cnt_s_bin3_raddr                               (i_hqm_sip_rf_ll_enq_cnt_s_bin3_raddr),
       .rf_ll_enq_cnt_s_bin3_rdata                               (i_hqm_list_sel_mem_rf_ll_enq_cnt_s_bin3_rdata),
       .rf_ll_enq_cnt_s_bin3_isol_en                             (i_hqm_sip_pgcb_isol_en),
       .rf_ll_enq_cnt_s_bin3_pwr_enable_b_in                     (i_hqm_list_sel_mem_rf_ll_enq_cnt_s_bin2_pwr_enable_b_out),
       .rf_ll_enq_cnt_s_bin3_pwr_enable_b_out                    (i_hqm_list_sel_mem_rf_ll_enq_cnt_s_bin3_pwr_enable_b_out),
       .rf_ll_rdylst_hp_bin0_wclk                                (i_hqm_sip_rf_ll_rdylst_hp_bin0_wclk),
       .rf_ll_rdylst_hp_bin0_wclk_rst_n                          (i_hqm_sip_rf_ll_rdylst_hp_bin0_wclk_rst_n),
       .rf_ll_rdylst_hp_bin0_we                                  (i_hqm_sip_rf_ll_rdylst_hp_bin0_we),
       .rf_ll_rdylst_hp_bin0_waddr                               (i_hqm_sip_rf_ll_rdylst_hp_bin0_waddr),
       .rf_ll_rdylst_hp_bin0_wdata                               (i_hqm_sip_rf_ll_rdylst_hp_bin0_wdata),
       .rf_ll_rdylst_hp_bin0_rclk                                (i_hqm_sip_rf_ll_rdylst_hp_bin0_rclk),
       .rf_ll_rdylst_hp_bin0_rclk_rst_n                          (i_hqm_sip_rf_ll_rdylst_hp_bin0_rclk_rst_n),
       .rf_ll_rdylst_hp_bin0_re                                  (i_hqm_sip_rf_ll_rdylst_hp_bin0_re),
       .rf_ll_rdylst_hp_bin0_raddr                               (i_hqm_sip_rf_ll_rdylst_hp_bin0_raddr),
       .rf_ll_rdylst_hp_bin0_rdata                               (i_hqm_list_sel_mem_rf_ll_rdylst_hp_bin0_rdata),
       .rf_ll_rdylst_hp_bin0_isol_en                             (i_hqm_sip_pgcb_isol_en),
       .rf_ll_rdylst_hp_bin0_pwr_enable_b_in                     (i_hqm_list_sel_mem_rf_ll_enq_cnt_s_bin3_pwr_enable_b_out),
       .rf_ll_rdylst_hp_bin0_pwr_enable_b_out                    (i_hqm_list_sel_mem_rf_ll_rdylst_hp_bin0_pwr_enable_b_out),
       .rf_ll_rdylst_hp_bin1_wclk                                (i_hqm_sip_rf_ll_rdylst_hp_bin1_wclk),
       .rf_ll_rdylst_hp_bin1_wclk_rst_n                          (i_hqm_sip_rf_ll_rdylst_hp_bin1_wclk_rst_n),
       .rf_ll_rdylst_hp_bin1_we                                  (i_hqm_sip_rf_ll_rdylst_hp_bin1_we),
       .rf_ll_rdylst_hp_bin1_waddr                               (i_hqm_sip_rf_ll_rdylst_hp_bin1_waddr),
       .rf_ll_rdylst_hp_bin1_wdata                               (i_hqm_sip_rf_ll_rdylst_hp_bin1_wdata),
       .rf_ll_rdylst_hp_bin1_rclk                                (i_hqm_sip_rf_ll_rdylst_hp_bin1_rclk),
       .rf_ll_rdylst_hp_bin1_rclk_rst_n                          (i_hqm_sip_rf_ll_rdylst_hp_bin1_rclk_rst_n),
       .rf_ll_rdylst_hp_bin1_re                                  (i_hqm_sip_rf_ll_rdylst_hp_bin1_re),
       .rf_ll_rdylst_hp_bin1_raddr                               (i_hqm_sip_rf_ll_rdylst_hp_bin1_raddr),
       .rf_ll_rdylst_hp_bin1_rdata                               (i_hqm_list_sel_mem_rf_ll_rdylst_hp_bin1_rdata),
       .rf_ll_rdylst_hp_bin1_isol_en                             (i_hqm_sip_pgcb_isol_en),
       .rf_ll_rdylst_hp_bin1_pwr_enable_b_in                     (i_hqm_list_sel_mem_rf_ll_rdylst_hp_bin0_pwr_enable_b_out),
       .rf_ll_rdylst_hp_bin1_pwr_enable_b_out                    (i_hqm_list_sel_mem_rf_ll_rdylst_hp_bin1_pwr_enable_b_out),
       .rf_ll_rdylst_hp_bin2_wclk                                (i_hqm_sip_rf_ll_rdylst_hp_bin2_wclk),
       .rf_ll_rdylst_hp_bin2_wclk_rst_n                          (i_hqm_sip_rf_ll_rdylst_hp_bin2_wclk_rst_n),
       .rf_ll_rdylst_hp_bin2_we                                  (i_hqm_sip_rf_ll_rdylst_hp_bin2_we),
       .rf_ll_rdylst_hp_bin2_waddr                               (i_hqm_sip_rf_ll_rdylst_hp_bin2_waddr),
       .rf_ll_rdylst_hp_bin2_wdata                               (i_hqm_sip_rf_ll_rdylst_hp_bin2_wdata),
       .rf_ll_rdylst_hp_bin2_rclk                                (i_hqm_sip_rf_ll_rdylst_hp_bin2_rclk),
       .rf_ll_rdylst_hp_bin2_rclk_rst_n                          (i_hqm_sip_rf_ll_rdylst_hp_bin2_rclk_rst_n),
       .rf_ll_rdylst_hp_bin2_re                                  (i_hqm_sip_rf_ll_rdylst_hp_bin2_re),
       .rf_ll_rdylst_hp_bin2_raddr                               (i_hqm_sip_rf_ll_rdylst_hp_bin2_raddr),
       .rf_ll_rdylst_hp_bin2_rdata                               (i_hqm_list_sel_mem_rf_ll_rdylst_hp_bin2_rdata),
       .rf_ll_rdylst_hp_bin2_isol_en                             (i_hqm_sip_pgcb_isol_en),
       .rf_ll_rdylst_hp_bin2_pwr_enable_b_in                     (i_hqm_list_sel_mem_rf_ll_rdylst_hp_bin1_pwr_enable_b_out),
       .rf_ll_rdylst_hp_bin2_pwr_enable_b_out                    (i_hqm_list_sel_mem_rf_ll_rdylst_hp_bin2_pwr_enable_b_out),
       .rf_ll_rdylst_hp_bin3_wclk                                (i_hqm_sip_rf_ll_rdylst_hp_bin3_wclk),
       .rf_ll_rdylst_hp_bin3_wclk_rst_n                          (i_hqm_sip_rf_ll_rdylst_hp_bin3_wclk_rst_n),
       .rf_ll_rdylst_hp_bin3_we                                  (i_hqm_sip_rf_ll_rdylst_hp_bin3_we),
       .rf_ll_rdylst_hp_bin3_waddr                               (i_hqm_sip_rf_ll_rdylst_hp_bin3_waddr),
       .rf_ll_rdylst_hp_bin3_wdata                               (i_hqm_sip_rf_ll_rdylst_hp_bin3_wdata),
       .rf_ll_rdylst_hp_bin3_rclk                                (i_hqm_sip_rf_ll_rdylst_hp_bin3_rclk),
       .rf_ll_rdylst_hp_bin3_rclk_rst_n                          (i_hqm_sip_rf_ll_rdylst_hp_bin3_rclk_rst_n),
       .rf_ll_rdylst_hp_bin3_re                                  (i_hqm_sip_rf_ll_rdylst_hp_bin3_re),
       .rf_ll_rdylst_hp_bin3_raddr                               (i_hqm_sip_rf_ll_rdylst_hp_bin3_raddr),
       .rf_ll_rdylst_hp_bin3_rdata                               (i_hqm_list_sel_mem_rf_ll_rdylst_hp_bin3_rdata),
       .rf_ll_rdylst_hp_bin3_isol_en                             (i_hqm_sip_pgcb_isol_en),
       .rf_ll_rdylst_hp_bin3_pwr_enable_b_in                     (i_hqm_list_sel_mem_rf_ll_rdylst_hp_bin2_pwr_enable_b_out),
       .rf_ll_rdylst_hp_bin3_pwr_enable_b_out                    (i_hqm_list_sel_mem_rf_ll_rdylst_hp_bin3_pwr_enable_b_out),
       .rf_ll_rdylst_hpnxt_bin0_wclk                             (i_hqm_sip_rf_ll_rdylst_hpnxt_bin0_wclk),
       .rf_ll_rdylst_hpnxt_bin0_wclk_rst_n                       (i_hqm_sip_rf_ll_rdylst_hpnxt_bin0_wclk_rst_n),
       .rf_ll_rdylst_hpnxt_bin0_we                               (i_hqm_sip_rf_ll_rdylst_hpnxt_bin0_we),
       .rf_ll_rdylst_hpnxt_bin0_waddr                            (i_hqm_sip_rf_ll_rdylst_hpnxt_bin0_waddr),
       .rf_ll_rdylst_hpnxt_bin0_wdata                            (i_hqm_sip_rf_ll_rdylst_hpnxt_bin0_wdata),
       .rf_ll_rdylst_hpnxt_bin0_rclk                             (i_hqm_sip_rf_ll_rdylst_hpnxt_bin0_rclk),
       .rf_ll_rdylst_hpnxt_bin0_rclk_rst_n                       (i_hqm_sip_rf_ll_rdylst_hpnxt_bin0_rclk_rst_n),
       .rf_ll_rdylst_hpnxt_bin0_re                               (i_hqm_sip_rf_ll_rdylst_hpnxt_bin0_re),
       .rf_ll_rdylst_hpnxt_bin0_raddr                            (i_hqm_sip_rf_ll_rdylst_hpnxt_bin0_raddr),
       .rf_ll_rdylst_hpnxt_bin0_rdata                            (i_hqm_list_sel_mem_rf_ll_rdylst_hpnxt_bin0_rdata),
       .rf_ll_rdylst_hpnxt_bin0_isol_en                          (i_hqm_sip_pgcb_isol_en),
       .rf_ll_rdylst_hpnxt_bin0_pwr_enable_b_in                  (i_hqm_list_sel_mem_rf_ll_rdylst_hp_bin3_pwr_enable_b_out),
       .rf_ll_rdylst_hpnxt_bin0_pwr_enable_b_out                 (i_hqm_list_sel_mem_rf_ll_rdylst_hpnxt_bin0_pwr_enable_b_out),
       .rf_ll_rdylst_hpnxt_bin1_wclk                             (i_hqm_sip_rf_ll_rdylst_hpnxt_bin1_wclk),
       .rf_ll_rdylst_hpnxt_bin1_wclk_rst_n                       (i_hqm_sip_rf_ll_rdylst_hpnxt_bin1_wclk_rst_n),
       .rf_ll_rdylst_hpnxt_bin1_we                               (i_hqm_sip_rf_ll_rdylst_hpnxt_bin1_we),
       .rf_ll_rdylst_hpnxt_bin1_waddr                            (i_hqm_sip_rf_ll_rdylst_hpnxt_bin1_waddr),
       .rf_ll_rdylst_hpnxt_bin1_wdata                            (i_hqm_sip_rf_ll_rdylst_hpnxt_bin1_wdata),
       .rf_ll_rdylst_hpnxt_bin1_rclk                             (i_hqm_sip_rf_ll_rdylst_hpnxt_bin1_rclk),
       .rf_ll_rdylst_hpnxt_bin1_rclk_rst_n                       (i_hqm_sip_rf_ll_rdylst_hpnxt_bin1_rclk_rst_n),
       .rf_ll_rdylst_hpnxt_bin1_re                               (i_hqm_sip_rf_ll_rdylst_hpnxt_bin1_re),
       .rf_ll_rdylst_hpnxt_bin1_raddr                            (i_hqm_sip_rf_ll_rdylst_hpnxt_bin1_raddr),
       .rf_ll_rdylst_hpnxt_bin1_rdata                            (i_hqm_list_sel_mem_rf_ll_rdylst_hpnxt_bin1_rdata),
       .rf_ll_rdylst_hpnxt_bin1_isol_en                          (i_hqm_sip_pgcb_isol_en),
       .rf_ll_rdylst_hpnxt_bin1_pwr_enable_b_in                  (i_hqm_list_sel_mem_rf_ll_rdylst_hpnxt_bin0_pwr_enable_b_out),
       .rf_ll_rdylst_hpnxt_bin1_pwr_enable_b_out                 (i_hqm_list_sel_mem_rf_ll_rdylst_hpnxt_bin1_pwr_enable_b_out),
       .rf_ll_rdylst_hpnxt_bin2_wclk                             (i_hqm_sip_rf_ll_rdylst_hpnxt_bin2_wclk),
       .rf_ll_rdylst_hpnxt_bin2_wclk_rst_n                       (i_hqm_sip_rf_ll_rdylst_hpnxt_bin2_wclk_rst_n),
       .rf_ll_rdylst_hpnxt_bin2_we                               (i_hqm_sip_rf_ll_rdylst_hpnxt_bin2_we),
       .rf_ll_rdylst_hpnxt_bin2_waddr                            (i_hqm_sip_rf_ll_rdylst_hpnxt_bin2_waddr),
       .rf_ll_rdylst_hpnxt_bin2_wdata                            (i_hqm_sip_rf_ll_rdylst_hpnxt_bin2_wdata),
       .rf_ll_rdylst_hpnxt_bin2_rclk                             (i_hqm_sip_rf_ll_rdylst_hpnxt_bin2_rclk),
       .rf_ll_rdylst_hpnxt_bin2_rclk_rst_n                       (i_hqm_sip_rf_ll_rdylst_hpnxt_bin2_rclk_rst_n),
       .rf_ll_rdylst_hpnxt_bin2_re                               (i_hqm_sip_rf_ll_rdylst_hpnxt_bin2_re),
       .rf_ll_rdylst_hpnxt_bin2_raddr                            (i_hqm_sip_rf_ll_rdylst_hpnxt_bin2_raddr),
       .rf_ll_rdylst_hpnxt_bin2_rdata                            (i_hqm_list_sel_mem_rf_ll_rdylst_hpnxt_bin2_rdata),
       .rf_ll_rdylst_hpnxt_bin2_isol_en                          (i_hqm_sip_pgcb_isol_en),
       .rf_ll_rdylst_hpnxt_bin2_pwr_enable_b_in                  (i_hqm_list_sel_mem_rf_ll_rdylst_hpnxt_bin1_pwr_enable_b_out),
       .rf_ll_rdylst_hpnxt_bin2_pwr_enable_b_out                 (i_hqm_list_sel_mem_rf_ll_rdylst_hpnxt_bin2_pwr_enable_b_out),
       .rf_ll_rdylst_hpnxt_bin3_wclk                             (i_hqm_sip_rf_ll_rdylst_hpnxt_bin3_wclk),
       .rf_ll_rdylst_hpnxt_bin3_wclk_rst_n                       (i_hqm_sip_rf_ll_rdylst_hpnxt_bin3_wclk_rst_n),
       .rf_ll_rdylst_hpnxt_bin3_we                               (i_hqm_sip_rf_ll_rdylst_hpnxt_bin3_we),
       .rf_ll_rdylst_hpnxt_bin3_waddr                            (i_hqm_sip_rf_ll_rdylst_hpnxt_bin3_waddr),
       .rf_ll_rdylst_hpnxt_bin3_wdata                            (i_hqm_sip_rf_ll_rdylst_hpnxt_bin3_wdata),
       .rf_ll_rdylst_hpnxt_bin3_rclk                             (i_hqm_sip_rf_ll_rdylst_hpnxt_bin3_rclk),
       .rf_ll_rdylst_hpnxt_bin3_rclk_rst_n                       (i_hqm_sip_rf_ll_rdylst_hpnxt_bin3_rclk_rst_n),
       .rf_ll_rdylst_hpnxt_bin3_re                               (i_hqm_sip_rf_ll_rdylst_hpnxt_bin3_re),
       .rf_ll_rdylst_hpnxt_bin3_raddr                            (i_hqm_sip_rf_ll_rdylst_hpnxt_bin3_raddr),
       .rf_ll_rdylst_hpnxt_bin3_rdata                            (i_hqm_list_sel_mem_rf_ll_rdylst_hpnxt_bin3_rdata),
       .rf_ll_rdylst_hpnxt_bin3_isol_en                          (i_hqm_sip_pgcb_isol_en),
       .rf_ll_rdylst_hpnxt_bin3_pwr_enable_b_in                  (i_hqm_list_sel_mem_rf_ll_rdylst_hpnxt_bin2_pwr_enable_b_out),
       .rf_ll_rdylst_hpnxt_bin3_pwr_enable_b_out                 (i_hqm_list_sel_mem_rf_ll_rdylst_hpnxt_bin3_pwr_enable_b_out),
       .rf_ll_rdylst_tp_bin0_wclk                                (i_hqm_sip_rf_ll_rdylst_tp_bin0_wclk),
       .rf_ll_rdylst_tp_bin0_wclk_rst_n                          (i_hqm_sip_rf_ll_rdylst_tp_bin0_wclk_rst_n),
       .rf_ll_rdylst_tp_bin0_we                                  (i_hqm_sip_rf_ll_rdylst_tp_bin0_we),
       .rf_ll_rdylst_tp_bin0_waddr                               (i_hqm_sip_rf_ll_rdylst_tp_bin0_waddr),
       .rf_ll_rdylst_tp_bin0_wdata                               (i_hqm_sip_rf_ll_rdylst_tp_bin0_wdata),
       .rf_ll_rdylst_tp_bin0_rclk                                (i_hqm_sip_rf_ll_rdylst_tp_bin0_rclk),
       .rf_ll_rdylst_tp_bin0_rclk_rst_n                          (i_hqm_sip_rf_ll_rdylst_tp_bin0_rclk_rst_n),
       .rf_ll_rdylst_tp_bin0_re                                  (i_hqm_sip_rf_ll_rdylst_tp_bin0_re),
       .rf_ll_rdylst_tp_bin0_raddr                               (i_hqm_sip_rf_ll_rdylst_tp_bin0_raddr),
       .rf_ll_rdylst_tp_bin0_rdata                               (i_hqm_list_sel_mem_rf_ll_rdylst_tp_bin0_rdata),
       .rf_ll_rdylst_tp_bin0_isol_en                             (i_hqm_sip_pgcb_isol_en),
       .rf_ll_rdylst_tp_bin0_pwr_enable_b_in                     (i_hqm_list_sel_mem_rf_ll_rdylst_hpnxt_bin3_pwr_enable_b_out),
       .rf_ll_rdylst_tp_bin0_pwr_enable_b_out                    (i_hqm_list_sel_mem_rf_ll_rdylst_tp_bin0_pwr_enable_b_out),
       .rf_ll_rdylst_tp_bin1_wclk                                (i_hqm_sip_rf_ll_rdylst_tp_bin1_wclk),
       .rf_ll_rdylst_tp_bin1_wclk_rst_n                          (i_hqm_sip_rf_ll_rdylst_tp_bin1_wclk_rst_n),
       .rf_ll_rdylst_tp_bin1_we                                  (i_hqm_sip_rf_ll_rdylst_tp_bin1_we),
       .rf_ll_rdylst_tp_bin1_waddr                               (i_hqm_sip_rf_ll_rdylst_tp_bin1_waddr),
       .rf_ll_rdylst_tp_bin1_wdata                               (i_hqm_sip_rf_ll_rdylst_tp_bin1_wdata),
       .rf_ll_rdylst_tp_bin1_rclk                                (i_hqm_sip_rf_ll_rdylst_tp_bin1_rclk),
       .rf_ll_rdylst_tp_bin1_rclk_rst_n                          (i_hqm_sip_rf_ll_rdylst_tp_bin1_rclk_rst_n),
       .rf_ll_rdylst_tp_bin1_re                                  (i_hqm_sip_rf_ll_rdylst_tp_bin1_re),
       .rf_ll_rdylst_tp_bin1_raddr                               (i_hqm_sip_rf_ll_rdylst_tp_bin1_raddr),
       .rf_ll_rdylst_tp_bin1_rdata                               (i_hqm_list_sel_mem_rf_ll_rdylst_tp_bin1_rdata),
       .rf_ll_rdylst_tp_bin1_isol_en                             (i_hqm_sip_pgcb_isol_en),
       .rf_ll_rdylst_tp_bin1_pwr_enable_b_in                     (i_hqm_list_sel_mem_rf_ll_rdylst_tp_bin0_pwr_enable_b_out),
       .rf_ll_rdylst_tp_bin1_pwr_enable_b_out                    (i_hqm_list_sel_mem_rf_ll_rdylst_tp_bin1_pwr_enable_b_out),
       .rf_ll_rdylst_tp_bin2_wclk                                (i_hqm_sip_rf_ll_rdylst_tp_bin2_wclk),
       .rf_ll_rdylst_tp_bin2_wclk_rst_n                          (i_hqm_sip_rf_ll_rdylst_tp_bin2_wclk_rst_n),
       .rf_ll_rdylst_tp_bin2_we                                  (i_hqm_sip_rf_ll_rdylst_tp_bin2_we),
       .rf_ll_rdylst_tp_bin2_waddr                               (i_hqm_sip_rf_ll_rdylst_tp_bin2_waddr),
       .rf_ll_rdylst_tp_bin2_wdata                               (i_hqm_sip_rf_ll_rdylst_tp_bin2_wdata),
       .rf_ll_rdylst_tp_bin2_rclk                                (i_hqm_sip_rf_ll_rdylst_tp_bin2_rclk),
       .rf_ll_rdylst_tp_bin2_rclk_rst_n                          (i_hqm_sip_rf_ll_rdylst_tp_bin2_rclk_rst_n),
       .rf_ll_rdylst_tp_bin2_re                                  (i_hqm_sip_rf_ll_rdylst_tp_bin2_re),
       .rf_ll_rdylst_tp_bin2_raddr                               (i_hqm_sip_rf_ll_rdylst_tp_bin2_raddr),
       .rf_ll_rdylst_tp_bin2_rdata                               (i_hqm_list_sel_mem_rf_ll_rdylst_tp_bin2_rdata),
       .rf_ll_rdylst_tp_bin2_isol_en                             (i_hqm_sip_pgcb_isol_en),
       .rf_ll_rdylst_tp_bin2_pwr_enable_b_in                     (i_hqm_list_sel_mem_rf_ll_rdylst_tp_bin1_pwr_enable_b_out),
       .rf_ll_rdylst_tp_bin2_pwr_enable_b_out                    (i_hqm_list_sel_mem_rf_ll_rdylst_tp_bin2_pwr_enable_b_out),
       .rf_ll_rdylst_tp_bin3_wclk                                (i_hqm_sip_rf_ll_rdylst_tp_bin3_wclk),
       .rf_ll_rdylst_tp_bin3_wclk_rst_n                          (i_hqm_sip_rf_ll_rdylst_tp_bin3_wclk_rst_n),
       .rf_ll_rdylst_tp_bin3_we                                  (i_hqm_sip_rf_ll_rdylst_tp_bin3_we),
       .rf_ll_rdylst_tp_bin3_waddr                               (i_hqm_sip_rf_ll_rdylst_tp_bin3_waddr),
       .rf_ll_rdylst_tp_bin3_wdata                               (i_hqm_sip_rf_ll_rdylst_tp_bin3_wdata),
       .rf_ll_rdylst_tp_bin3_rclk                                (i_hqm_sip_rf_ll_rdylst_tp_bin3_rclk),
       .rf_ll_rdylst_tp_bin3_rclk_rst_n                          (i_hqm_sip_rf_ll_rdylst_tp_bin3_rclk_rst_n),
       .rf_ll_rdylst_tp_bin3_re                                  (i_hqm_sip_rf_ll_rdylst_tp_bin3_re),
       .rf_ll_rdylst_tp_bin3_raddr                               (i_hqm_sip_rf_ll_rdylst_tp_bin3_raddr),
       .rf_ll_rdylst_tp_bin3_rdata                               (i_hqm_list_sel_mem_rf_ll_rdylst_tp_bin3_rdata),
       .rf_ll_rdylst_tp_bin3_isol_en                             (i_hqm_sip_pgcb_isol_en),
       .rf_ll_rdylst_tp_bin3_pwr_enable_b_in                     (i_hqm_list_sel_mem_rf_ll_rdylst_tp_bin2_pwr_enable_b_out),
       .rf_ll_rdylst_tp_bin3_pwr_enable_b_out                    (i_hqm_list_sel_mem_rf_ll_rdylst_tp_bin3_pwr_enable_b_out),
       .rf_ll_rlst_cnt_wclk                                      (i_hqm_sip_rf_ll_rlst_cnt_wclk),
       .rf_ll_rlst_cnt_wclk_rst_n                                (i_hqm_sip_rf_ll_rlst_cnt_wclk_rst_n),
       .rf_ll_rlst_cnt_we                                        (i_hqm_sip_rf_ll_rlst_cnt_we),
       .rf_ll_rlst_cnt_waddr                                     (i_hqm_sip_rf_ll_rlst_cnt_waddr),
       .rf_ll_rlst_cnt_wdata                                     (i_hqm_sip_rf_ll_rlst_cnt_wdata),
       .rf_ll_rlst_cnt_rclk                                      (i_hqm_sip_rf_ll_rlst_cnt_rclk),
       .rf_ll_rlst_cnt_rclk_rst_n                                (i_hqm_sip_rf_ll_rlst_cnt_rclk_rst_n),
       .rf_ll_rlst_cnt_re                                        (i_hqm_sip_rf_ll_rlst_cnt_re),
       .rf_ll_rlst_cnt_raddr                                     (i_hqm_sip_rf_ll_rlst_cnt_raddr),
       .rf_ll_rlst_cnt_rdata                                     (i_hqm_list_sel_mem_rf_ll_rlst_cnt_rdata),
       .rf_ll_rlst_cnt_isol_en                                   (i_hqm_sip_pgcb_isol_en),
       .rf_ll_rlst_cnt_pwr_enable_b_in                           (i_hqm_list_sel_mem_rf_ll_rdylst_tp_bin3_pwr_enable_b_out),
       .rf_ll_rlst_cnt_pwr_enable_b_out                          (i_hqm_list_sel_mem_rf_ll_rlst_cnt_pwr_enable_b_out),
       .rf_ll_sch_cnt_dup0_wclk                                  (i_hqm_sip_rf_ll_sch_cnt_dup0_wclk),
       .rf_ll_sch_cnt_dup0_wclk_rst_n                            (i_hqm_sip_rf_ll_sch_cnt_dup0_wclk_rst_n),
       .rf_ll_sch_cnt_dup0_we                                    (i_hqm_sip_rf_ll_sch_cnt_dup0_we),
       .rf_ll_sch_cnt_dup0_waddr                                 (i_hqm_sip_rf_ll_sch_cnt_dup0_waddr),
       .rf_ll_sch_cnt_dup0_wdata                                 (i_hqm_sip_rf_ll_sch_cnt_dup0_wdata),
       .rf_ll_sch_cnt_dup0_rclk                                  (i_hqm_sip_rf_ll_sch_cnt_dup0_rclk),
       .rf_ll_sch_cnt_dup0_rclk_rst_n                            (i_hqm_sip_rf_ll_sch_cnt_dup0_rclk_rst_n),
       .rf_ll_sch_cnt_dup0_re                                    (i_hqm_sip_rf_ll_sch_cnt_dup0_re),
       .rf_ll_sch_cnt_dup0_raddr                                 (i_hqm_sip_rf_ll_sch_cnt_dup0_raddr),
       .rf_ll_sch_cnt_dup0_rdata                                 (i_hqm_list_sel_mem_rf_ll_sch_cnt_dup0_rdata),
       .rf_ll_sch_cnt_dup0_isol_en                               (i_hqm_sip_pgcb_isol_en),
       .rf_ll_sch_cnt_dup0_pwr_enable_b_in                       (i_hqm_list_sel_mem_rf_ll_rlst_cnt_pwr_enable_b_out),
       .rf_ll_sch_cnt_dup0_pwr_enable_b_out                      (i_hqm_list_sel_mem_rf_ll_sch_cnt_dup0_pwr_enable_b_out),
       .rf_ll_sch_cnt_dup1_wclk                                  (i_hqm_sip_rf_ll_sch_cnt_dup1_wclk),
       .rf_ll_sch_cnt_dup1_wclk_rst_n                            (i_hqm_sip_rf_ll_sch_cnt_dup1_wclk_rst_n),
       .rf_ll_sch_cnt_dup1_we                                    (i_hqm_sip_rf_ll_sch_cnt_dup1_we),
       .rf_ll_sch_cnt_dup1_waddr                                 (i_hqm_sip_rf_ll_sch_cnt_dup1_waddr),
       .rf_ll_sch_cnt_dup1_wdata                                 (i_hqm_sip_rf_ll_sch_cnt_dup1_wdata),
       .rf_ll_sch_cnt_dup1_rclk                                  (i_hqm_sip_rf_ll_sch_cnt_dup1_rclk),
       .rf_ll_sch_cnt_dup1_rclk_rst_n                            (i_hqm_sip_rf_ll_sch_cnt_dup1_rclk_rst_n),
       .rf_ll_sch_cnt_dup1_re                                    (i_hqm_sip_rf_ll_sch_cnt_dup1_re),
       .rf_ll_sch_cnt_dup1_raddr                                 (i_hqm_sip_rf_ll_sch_cnt_dup1_raddr),
       .rf_ll_sch_cnt_dup1_rdata                                 (i_hqm_list_sel_mem_rf_ll_sch_cnt_dup1_rdata),
       .rf_ll_sch_cnt_dup1_isol_en                               (i_hqm_sip_pgcb_isol_en),
       .rf_ll_sch_cnt_dup1_pwr_enable_b_in                       (i_hqm_list_sel_mem_rf_ll_sch_cnt_dup0_pwr_enable_b_out),
       .rf_ll_sch_cnt_dup1_pwr_enable_b_out                      (i_hqm_list_sel_mem_rf_ll_sch_cnt_dup1_pwr_enable_b_out),
       .rf_ll_sch_cnt_dup2_wclk                                  (i_hqm_sip_rf_ll_sch_cnt_dup2_wclk),
       .rf_ll_sch_cnt_dup2_wclk_rst_n                            (i_hqm_sip_rf_ll_sch_cnt_dup2_wclk_rst_n),
       .rf_ll_sch_cnt_dup2_we                                    (i_hqm_sip_rf_ll_sch_cnt_dup2_we),
       .rf_ll_sch_cnt_dup2_waddr                                 (i_hqm_sip_rf_ll_sch_cnt_dup2_waddr),
       .rf_ll_sch_cnt_dup2_wdata                                 (i_hqm_sip_rf_ll_sch_cnt_dup2_wdata),
       .rf_ll_sch_cnt_dup2_rclk                                  (i_hqm_sip_rf_ll_sch_cnt_dup2_rclk),
       .rf_ll_sch_cnt_dup2_rclk_rst_n                            (i_hqm_sip_rf_ll_sch_cnt_dup2_rclk_rst_n),
       .rf_ll_sch_cnt_dup2_re                                    (i_hqm_sip_rf_ll_sch_cnt_dup2_re),
       .rf_ll_sch_cnt_dup2_raddr                                 (i_hqm_sip_rf_ll_sch_cnt_dup2_raddr),
       .rf_ll_sch_cnt_dup2_rdata                                 (i_hqm_list_sel_mem_rf_ll_sch_cnt_dup2_rdata),
       .rf_ll_sch_cnt_dup2_isol_en                               (i_hqm_sip_pgcb_isol_en),
       .rf_ll_sch_cnt_dup2_pwr_enable_b_in                       (i_hqm_list_sel_mem_rf_ll_sch_cnt_dup1_pwr_enable_b_out),
       .rf_ll_sch_cnt_dup2_pwr_enable_b_out                      (i_hqm_list_sel_mem_rf_ll_sch_cnt_dup2_pwr_enable_b_out),
       .rf_ll_sch_cnt_dup3_wclk                                  (i_hqm_sip_rf_ll_sch_cnt_dup3_wclk),
       .rf_ll_sch_cnt_dup3_wclk_rst_n                            (i_hqm_sip_rf_ll_sch_cnt_dup3_wclk_rst_n),
       .rf_ll_sch_cnt_dup3_we                                    (i_hqm_sip_rf_ll_sch_cnt_dup3_we),
       .rf_ll_sch_cnt_dup3_waddr                                 (i_hqm_sip_rf_ll_sch_cnt_dup3_waddr),
       .rf_ll_sch_cnt_dup3_wdata                                 (i_hqm_sip_rf_ll_sch_cnt_dup3_wdata),
       .rf_ll_sch_cnt_dup3_rclk                                  (i_hqm_sip_rf_ll_sch_cnt_dup3_rclk),
       .rf_ll_sch_cnt_dup3_rclk_rst_n                            (i_hqm_sip_rf_ll_sch_cnt_dup3_rclk_rst_n),
       .rf_ll_sch_cnt_dup3_re                                    (i_hqm_sip_rf_ll_sch_cnt_dup3_re),
       .rf_ll_sch_cnt_dup3_raddr                                 (i_hqm_sip_rf_ll_sch_cnt_dup3_raddr),
       .rf_ll_sch_cnt_dup3_rdata                                 (i_hqm_list_sel_mem_rf_ll_sch_cnt_dup3_rdata),
       .rf_ll_sch_cnt_dup3_isol_en                               (i_hqm_sip_pgcb_isol_en),
       .rf_ll_sch_cnt_dup3_pwr_enable_b_in                       (i_hqm_list_sel_mem_rf_ll_sch_cnt_dup2_pwr_enable_b_out),
       .rf_ll_sch_cnt_dup3_pwr_enable_b_out                      (i_hqm_list_sel_mem_rf_ll_sch_cnt_dup3_pwr_enable_b_out),
       .rf_ll_schlst_hp_bin0_wclk                                (i_hqm_sip_rf_ll_schlst_hp_bin0_wclk),
       .rf_ll_schlst_hp_bin0_wclk_rst_n                          (i_hqm_sip_rf_ll_schlst_hp_bin0_wclk_rst_n),
       .rf_ll_schlst_hp_bin0_we                                  (i_hqm_sip_rf_ll_schlst_hp_bin0_we),
       .rf_ll_schlst_hp_bin0_waddr                               (i_hqm_sip_rf_ll_schlst_hp_bin0_waddr),
       .rf_ll_schlst_hp_bin0_wdata                               (i_hqm_sip_rf_ll_schlst_hp_bin0_wdata),
       .rf_ll_schlst_hp_bin0_rclk                                (i_hqm_sip_rf_ll_schlst_hp_bin0_rclk),
       .rf_ll_schlst_hp_bin0_rclk_rst_n                          (i_hqm_sip_rf_ll_schlst_hp_bin0_rclk_rst_n),
       .rf_ll_schlst_hp_bin0_re                                  (i_hqm_sip_rf_ll_schlst_hp_bin0_re),
       .rf_ll_schlst_hp_bin0_raddr                               (i_hqm_sip_rf_ll_schlst_hp_bin0_raddr),
       .rf_ll_schlst_hp_bin0_rdata                               (i_hqm_list_sel_mem_rf_ll_schlst_hp_bin0_rdata),
       .rf_ll_schlst_hp_bin0_isol_en                             (i_hqm_sip_pgcb_isol_en),
       .rf_ll_schlst_hp_bin0_pwr_enable_b_in                     (i_hqm_list_sel_mem_rf_ll_sch_cnt_dup3_pwr_enable_b_out),
       .rf_ll_schlst_hp_bin0_pwr_enable_b_out                    (i_hqm_list_sel_mem_rf_ll_schlst_hp_bin0_pwr_enable_b_out),
       .rf_ll_schlst_hp_bin1_wclk                                (i_hqm_sip_rf_ll_schlst_hp_bin1_wclk),
       .rf_ll_schlst_hp_bin1_wclk_rst_n                          (i_hqm_sip_rf_ll_schlst_hp_bin1_wclk_rst_n),
       .rf_ll_schlst_hp_bin1_we                                  (i_hqm_sip_rf_ll_schlst_hp_bin1_we),
       .rf_ll_schlst_hp_bin1_waddr                               (i_hqm_sip_rf_ll_schlst_hp_bin1_waddr),
       .rf_ll_schlst_hp_bin1_wdata                               (i_hqm_sip_rf_ll_schlst_hp_bin1_wdata),
       .rf_ll_schlst_hp_bin1_rclk                                (i_hqm_sip_rf_ll_schlst_hp_bin1_rclk),
       .rf_ll_schlst_hp_bin1_rclk_rst_n                          (i_hqm_sip_rf_ll_schlst_hp_bin1_rclk_rst_n),
       .rf_ll_schlst_hp_bin1_re                                  (i_hqm_sip_rf_ll_schlst_hp_bin1_re),
       .rf_ll_schlst_hp_bin1_raddr                               (i_hqm_sip_rf_ll_schlst_hp_bin1_raddr),
       .rf_ll_schlst_hp_bin1_rdata                               (i_hqm_list_sel_mem_rf_ll_schlst_hp_bin1_rdata),
       .rf_ll_schlst_hp_bin1_isol_en                             (i_hqm_sip_pgcb_isol_en),
       .rf_ll_schlst_hp_bin1_pwr_enable_b_in                     (i_hqm_list_sel_mem_rf_ll_schlst_hp_bin0_pwr_enable_b_out),
       .rf_ll_schlst_hp_bin1_pwr_enable_b_out                    (i_hqm_list_sel_mem_rf_ll_schlst_hp_bin1_pwr_enable_b_out),
       .rf_ll_schlst_hp_bin2_wclk                                (i_hqm_sip_rf_ll_schlst_hp_bin2_wclk),
       .rf_ll_schlst_hp_bin2_wclk_rst_n                          (i_hqm_sip_rf_ll_schlst_hp_bin2_wclk_rst_n),
       .rf_ll_schlst_hp_bin2_we                                  (i_hqm_sip_rf_ll_schlst_hp_bin2_we),
       .rf_ll_schlst_hp_bin2_waddr                               (i_hqm_sip_rf_ll_schlst_hp_bin2_waddr),
       .rf_ll_schlst_hp_bin2_wdata                               (i_hqm_sip_rf_ll_schlst_hp_bin2_wdata),
       .rf_ll_schlst_hp_bin2_rclk                                (i_hqm_sip_rf_ll_schlst_hp_bin2_rclk),
       .rf_ll_schlst_hp_bin2_rclk_rst_n                          (i_hqm_sip_rf_ll_schlst_hp_bin2_rclk_rst_n),
       .rf_ll_schlst_hp_bin2_re                                  (i_hqm_sip_rf_ll_schlst_hp_bin2_re),
       .rf_ll_schlst_hp_bin2_raddr                               (i_hqm_sip_rf_ll_schlst_hp_bin2_raddr),
       .rf_ll_schlst_hp_bin2_rdata                               (i_hqm_list_sel_mem_rf_ll_schlst_hp_bin2_rdata),
       .rf_ll_schlst_hp_bin2_isol_en                             (i_hqm_sip_pgcb_isol_en),
       .rf_ll_schlst_hp_bin2_pwr_enable_b_in                     (i_hqm_list_sel_mem_rf_ll_schlst_hp_bin1_pwr_enable_b_out),
       .rf_ll_schlst_hp_bin2_pwr_enable_b_out                    (i_hqm_list_sel_mem_rf_ll_schlst_hp_bin2_pwr_enable_b_out),
       .rf_ll_schlst_hp_bin3_wclk                                (i_hqm_sip_rf_ll_schlst_hp_bin3_wclk),
       .rf_ll_schlst_hp_bin3_wclk_rst_n                          (i_hqm_sip_rf_ll_schlst_hp_bin3_wclk_rst_n),
       .rf_ll_schlst_hp_bin3_we                                  (i_hqm_sip_rf_ll_schlst_hp_bin3_we),
       .rf_ll_schlst_hp_bin3_waddr                               (i_hqm_sip_rf_ll_schlst_hp_bin3_waddr),
       .rf_ll_schlst_hp_bin3_wdata                               (i_hqm_sip_rf_ll_schlst_hp_bin3_wdata),
       .rf_ll_schlst_hp_bin3_rclk                                (i_hqm_sip_rf_ll_schlst_hp_bin3_rclk),
       .rf_ll_schlst_hp_bin3_rclk_rst_n                          (i_hqm_sip_rf_ll_schlst_hp_bin3_rclk_rst_n),
       .rf_ll_schlst_hp_bin3_re                                  (i_hqm_sip_rf_ll_schlst_hp_bin3_re),
       .rf_ll_schlst_hp_bin3_raddr                               (i_hqm_sip_rf_ll_schlst_hp_bin3_raddr),
       .rf_ll_schlst_hp_bin3_rdata                               (i_hqm_list_sel_mem_rf_ll_schlst_hp_bin3_rdata),
       .rf_ll_schlst_hp_bin3_isol_en                             (i_hqm_sip_pgcb_isol_en),
       .rf_ll_schlst_hp_bin3_pwr_enable_b_in                     (i_hqm_list_sel_mem_rf_ll_schlst_hp_bin2_pwr_enable_b_out),
       .rf_ll_schlst_hp_bin3_pwr_enable_b_out                    (i_hqm_list_sel_mem_rf_ll_schlst_hp_bin3_pwr_enable_b_out),
       .rf_ll_schlst_hpnxt_bin0_wclk                             (i_hqm_sip_rf_ll_schlst_hpnxt_bin0_wclk),
       .rf_ll_schlst_hpnxt_bin0_wclk_rst_n                       (i_hqm_sip_rf_ll_schlst_hpnxt_bin0_wclk_rst_n),
       .rf_ll_schlst_hpnxt_bin0_we                               (i_hqm_sip_rf_ll_schlst_hpnxt_bin0_we),
       .rf_ll_schlst_hpnxt_bin0_waddr                            (i_hqm_sip_rf_ll_schlst_hpnxt_bin0_waddr),
       .rf_ll_schlst_hpnxt_bin0_wdata                            (i_hqm_sip_rf_ll_schlst_hpnxt_bin0_wdata),
       .rf_ll_schlst_hpnxt_bin0_rclk                             (i_hqm_sip_rf_ll_schlst_hpnxt_bin0_rclk),
       .rf_ll_schlst_hpnxt_bin0_rclk_rst_n                       (i_hqm_sip_rf_ll_schlst_hpnxt_bin0_rclk_rst_n),
       .rf_ll_schlst_hpnxt_bin0_re                               (i_hqm_sip_rf_ll_schlst_hpnxt_bin0_re),
       .rf_ll_schlst_hpnxt_bin0_raddr                            (i_hqm_sip_rf_ll_schlst_hpnxt_bin0_raddr),
       .rf_ll_schlst_hpnxt_bin0_rdata                            (i_hqm_list_sel_mem_rf_ll_schlst_hpnxt_bin0_rdata),
       .rf_ll_schlst_hpnxt_bin0_isol_en                          (i_hqm_sip_pgcb_isol_en),
       .rf_ll_schlst_hpnxt_bin0_pwr_enable_b_in                  (i_hqm_list_sel_mem_rf_ll_schlst_hp_bin3_pwr_enable_b_out),
       .rf_ll_schlst_hpnxt_bin0_pwr_enable_b_out                 (i_hqm_list_sel_mem_rf_ll_schlst_hpnxt_bin0_pwr_enable_b_out),
       .rf_ll_schlst_hpnxt_bin1_wclk                             (i_hqm_sip_rf_ll_schlst_hpnxt_bin1_wclk),
       .rf_ll_schlst_hpnxt_bin1_wclk_rst_n                       (i_hqm_sip_rf_ll_schlst_hpnxt_bin1_wclk_rst_n),
       .rf_ll_schlst_hpnxt_bin1_we                               (i_hqm_sip_rf_ll_schlst_hpnxt_bin1_we),
       .rf_ll_schlst_hpnxt_bin1_waddr                            (i_hqm_sip_rf_ll_schlst_hpnxt_bin1_waddr),
       .rf_ll_schlst_hpnxt_bin1_wdata                            (i_hqm_sip_rf_ll_schlst_hpnxt_bin1_wdata),
       .rf_ll_schlst_hpnxt_bin1_rclk                             (i_hqm_sip_rf_ll_schlst_hpnxt_bin1_rclk),
       .rf_ll_schlst_hpnxt_bin1_rclk_rst_n                       (i_hqm_sip_rf_ll_schlst_hpnxt_bin1_rclk_rst_n),
       .rf_ll_schlst_hpnxt_bin1_re                               (i_hqm_sip_rf_ll_schlst_hpnxt_bin1_re),
       .rf_ll_schlst_hpnxt_bin1_raddr                            (i_hqm_sip_rf_ll_schlst_hpnxt_bin1_raddr),
       .rf_ll_schlst_hpnxt_bin1_rdata                            (i_hqm_list_sel_mem_rf_ll_schlst_hpnxt_bin1_rdata),
       .rf_ll_schlst_hpnxt_bin1_isol_en                          (i_hqm_sip_pgcb_isol_en),
       .rf_ll_schlst_hpnxt_bin1_pwr_enable_b_in                  (i_hqm_list_sel_mem_rf_ll_schlst_hpnxt_bin0_pwr_enable_b_out),
       .rf_ll_schlst_hpnxt_bin1_pwr_enable_b_out                 (i_hqm_list_sel_mem_rf_ll_schlst_hpnxt_bin1_pwr_enable_b_out),
       .rf_ll_schlst_hpnxt_bin2_wclk                             (i_hqm_sip_rf_ll_schlst_hpnxt_bin2_wclk),
       .rf_ll_schlst_hpnxt_bin2_wclk_rst_n                       (i_hqm_sip_rf_ll_schlst_hpnxt_bin2_wclk_rst_n),
       .rf_ll_schlst_hpnxt_bin2_we                               (i_hqm_sip_rf_ll_schlst_hpnxt_bin2_we),
       .rf_ll_schlst_hpnxt_bin2_waddr                            (i_hqm_sip_rf_ll_schlst_hpnxt_bin2_waddr),
       .rf_ll_schlst_hpnxt_bin2_wdata                            (i_hqm_sip_rf_ll_schlst_hpnxt_bin2_wdata),
       .rf_ll_schlst_hpnxt_bin2_rclk                             (i_hqm_sip_rf_ll_schlst_hpnxt_bin2_rclk),
       .rf_ll_schlst_hpnxt_bin2_rclk_rst_n                       (i_hqm_sip_rf_ll_schlst_hpnxt_bin2_rclk_rst_n),
       .rf_ll_schlst_hpnxt_bin2_re                               (i_hqm_sip_rf_ll_schlst_hpnxt_bin2_re),
       .rf_ll_schlst_hpnxt_bin2_raddr                            (i_hqm_sip_rf_ll_schlst_hpnxt_bin2_raddr),
       .rf_ll_schlst_hpnxt_bin2_rdata                            (i_hqm_list_sel_mem_rf_ll_schlst_hpnxt_bin2_rdata),
       .rf_ll_schlst_hpnxt_bin2_isol_en                          (i_hqm_sip_pgcb_isol_en),
       .rf_ll_schlst_hpnxt_bin2_pwr_enable_b_in                  (i_hqm_list_sel_mem_rf_ll_schlst_hpnxt_bin1_pwr_enable_b_out),
       .rf_ll_schlst_hpnxt_bin2_pwr_enable_b_out                 (i_hqm_list_sel_mem_rf_ll_schlst_hpnxt_bin2_pwr_enable_b_out),
       .rf_ll_schlst_hpnxt_bin3_wclk                             (i_hqm_sip_rf_ll_schlst_hpnxt_bin3_wclk),
       .rf_ll_schlst_hpnxt_bin3_wclk_rst_n                       (i_hqm_sip_rf_ll_schlst_hpnxt_bin3_wclk_rst_n),
       .rf_ll_schlst_hpnxt_bin3_we                               (i_hqm_sip_rf_ll_schlst_hpnxt_bin3_we),
       .rf_ll_schlst_hpnxt_bin3_waddr                            (i_hqm_sip_rf_ll_schlst_hpnxt_bin3_waddr),
       .rf_ll_schlst_hpnxt_bin3_wdata                            (i_hqm_sip_rf_ll_schlst_hpnxt_bin3_wdata),
       .rf_ll_schlst_hpnxt_bin3_rclk                             (i_hqm_sip_rf_ll_schlst_hpnxt_bin3_rclk),
       .rf_ll_schlst_hpnxt_bin3_rclk_rst_n                       (i_hqm_sip_rf_ll_schlst_hpnxt_bin3_rclk_rst_n),
       .rf_ll_schlst_hpnxt_bin3_re                               (i_hqm_sip_rf_ll_schlst_hpnxt_bin3_re),
       .rf_ll_schlst_hpnxt_bin3_raddr                            (i_hqm_sip_rf_ll_schlst_hpnxt_bin3_raddr),
       .rf_ll_schlst_hpnxt_bin3_rdata                            (i_hqm_list_sel_mem_rf_ll_schlst_hpnxt_bin3_rdata),
       .rf_ll_schlst_hpnxt_bin3_isol_en                          (i_hqm_sip_pgcb_isol_en),
       .rf_ll_schlst_hpnxt_bin3_pwr_enable_b_in                  (i_hqm_list_sel_mem_rf_ll_schlst_hpnxt_bin2_pwr_enable_b_out),
       .rf_ll_schlst_hpnxt_bin3_pwr_enable_b_out                 (i_hqm_list_sel_mem_rf_ll_schlst_hpnxt_bin3_pwr_enable_b_out),
       .rf_ll_schlst_tp_bin0_wclk                                (i_hqm_sip_rf_ll_schlst_tp_bin0_wclk),
       .rf_ll_schlst_tp_bin0_wclk_rst_n                          (i_hqm_sip_rf_ll_schlst_tp_bin0_wclk_rst_n),
       .rf_ll_schlst_tp_bin0_we                                  (i_hqm_sip_rf_ll_schlst_tp_bin0_we),
       .rf_ll_schlst_tp_bin0_waddr                               (i_hqm_sip_rf_ll_schlst_tp_bin0_waddr),
       .rf_ll_schlst_tp_bin0_wdata                               (i_hqm_sip_rf_ll_schlst_tp_bin0_wdata),
       .rf_ll_schlst_tp_bin0_rclk                                (i_hqm_sip_rf_ll_schlst_tp_bin0_rclk),
       .rf_ll_schlst_tp_bin0_rclk_rst_n                          (i_hqm_sip_rf_ll_schlst_tp_bin0_rclk_rst_n),
       .rf_ll_schlst_tp_bin0_re                                  (i_hqm_sip_rf_ll_schlst_tp_bin0_re),
       .rf_ll_schlst_tp_bin0_raddr                               (i_hqm_sip_rf_ll_schlst_tp_bin0_raddr),
       .rf_ll_schlst_tp_bin0_rdata                               (i_hqm_list_sel_mem_rf_ll_schlst_tp_bin0_rdata),
       .rf_ll_schlst_tp_bin0_isol_en                             (i_hqm_sip_pgcb_isol_en),
       .rf_ll_schlst_tp_bin0_pwr_enable_b_in                     (i_hqm_list_sel_mem_rf_ll_schlst_hpnxt_bin3_pwr_enable_b_out),
       .rf_ll_schlst_tp_bin0_pwr_enable_b_out                    (i_hqm_list_sel_mem_rf_ll_schlst_tp_bin0_pwr_enable_b_out),
       .rf_ll_schlst_tp_bin1_wclk                                (i_hqm_sip_rf_ll_schlst_tp_bin1_wclk),
       .rf_ll_schlst_tp_bin1_wclk_rst_n                          (i_hqm_sip_rf_ll_schlst_tp_bin1_wclk_rst_n),
       .rf_ll_schlst_tp_bin1_we                                  (i_hqm_sip_rf_ll_schlst_tp_bin1_we),
       .rf_ll_schlst_tp_bin1_waddr                               (i_hqm_sip_rf_ll_schlst_tp_bin1_waddr),
       .rf_ll_schlst_tp_bin1_wdata                               (i_hqm_sip_rf_ll_schlst_tp_bin1_wdata),
       .rf_ll_schlst_tp_bin1_rclk                                (i_hqm_sip_rf_ll_schlst_tp_bin1_rclk),
       .rf_ll_schlst_tp_bin1_rclk_rst_n                          (i_hqm_sip_rf_ll_schlst_tp_bin1_rclk_rst_n),
       .rf_ll_schlst_tp_bin1_re                                  (i_hqm_sip_rf_ll_schlst_tp_bin1_re),
       .rf_ll_schlst_tp_bin1_raddr                               (i_hqm_sip_rf_ll_schlst_tp_bin1_raddr),
       .rf_ll_schlst_tp_bin1_rdata                               (i_hqm_list_sel_mem_rf_ll_schlst_tp_bin1_rdata),
       .rf_ll_schlst_tp_bin1_isol_en                             (i_hqm_sip_pgcb_isol_en),
       .rf_ll_schlst_tp_bin1_pwr_enable_b_in                     (i_hqm_list_sel_mem_rf_ll_schlst_tp_bin0_pwr_enable_b_out),
       .rf_ll_schlst_tp_bin1_pwr_enable_b_out                    (i_hqm_list_sel_mem_rf_ll_schlst_tp_bin1_pwr_enable_b_out),
       .rf_ll_schlst_tp_bin2_wclk                                (i_hqm_sip_rf_ll_schlst_tp_bin2_wclk),
       .rf_ll_schlst_tp_bin2_wclk_rst_n                          (i_hqm_sip_rf_ll_schlst_tp_bin2_wclk_rst_n),
       .rf_ll_schlst_tp_bin2_we                                  (i_hqm_sip_rf_ll_schlst_tp_bin2_we),
       .rf_ll_schlst_tp_bin2_waddr                               (i_hqm_sip_rf_ll_schlst_tp_bin2_waddr),
       .rf_ll_schlst_tp_bin2_wdata                               (i_hqm_sip_rf_ll_schlst_tp_bin2_wdata),
       .rf_ll_schlst_tp_bin2_rclk                                (i_hqm_sip_rf_ll_schlst_tp_bin2_rclk),
       .rf_ll_schlst_tp_bin2_rclk_rst_n                          (i_hqm_sip_rf_ll_schlst_tp_bin2_rclk_rst_n),
       .rf_ll_schlst_tp_bin2_re                                  (i_hqm_sip_rf_ll_schlst_tp_bin2_re),
       .rf_ll_schlst_tp_bin2_raddr                               (i_hqm_sip_rf_ll_schlst_tp_bin2_raddr),
       .rf_ll_schlst_tp_bin2_rdata                               (i_hqm_list_sel_mem_rf_ll_schlst_tp_bin2_rdata),
       .rf_ll_schlst_tp_bin2_isol_en                             (i_hqm_sip_pgcb_isol_en),
       .rf_ll_schlst_tp_bin2_pwr_enable_b_in                     (i_hqm_list_sel_mem_rf_ll_schlst_tp_bin1_pwr_enable_b_out),
       .rf_ll_schlst_tp_bin2_pwr_enable_b_out                    (i_hqm_list_sel_mem_rf_ll_schlst_tp_bin2_pwr_enable_b_out),
       .rf_ll_schlst_tp_bin3_wclk                                (i_hqm_sip_rf_ll_schlst_tp_bin3_wclk),
       .rf_ll_schlst_tp_bin3_wclk_rst_n                          (i_hqm_sip_rf_ll_schlst_tp_bin3_wclk_rst_n),
       .rf_ll_schlst_tp_bin3_we                                  (i_hqm_sip_rf_ll_schlst_tp_bin3_we),
       .rf_ll_schlst_tp_bin3_waddr                               (i_hqm_sip_rf_ll_schlst_tp_bin3_waddr),
       .rf_ll_schlst_tp_bin3_wdata                               (i_hqm_sip_rf_ll_schlst_tp_bin3_wdata),
       .rf_ll_schlst_tp_bin3_rclk                                (i_hqm_sip_rf_ll_schlst_tp_bin3_rclk),
       .rf_ll_schlst_tp_bin3_rclk_rst_n                          (i_hqm_sip_rf_ll_schlst_tp_bin3_rclk_rst_n),
       .rf_ll_schlst_tp_bin3_re                                  (i_hqm_sip_rf_ll_schlst_tp_bin3_re),
       .rf_ll_schlst_tp_bin3_raddr                               (i_hqm_sip_rf_ll_schlst_tp_bin3_raddr),
       .rf_ll_schlst_tp_bin3_rdata                               (i_hqm_list_sel_mem_rf_ll_schlst_tp_bin3_rdata),
       .rf_ll_schlst_tp_bin3_isol_en                             (i_hqm_sip_pgcb_isol_en),
       .rf_ll_schlst_tp_bin3_pwr_enable_b_in                     (i_hqm_list_sel_mem_rf_ll_schlst_tp_bin2_pwr_enable_b_out),
       .rf_ll_schlst_tp_bin3_pwr_enable_b_out                    (i_hqm_list_sel_mem_rf_ll_schlst_tp_bin3_pwr_enable_b_out),
       .rf_ll_schlst_tpprv_bin0_wclk                             (i_hqm_sip_rf_ll_schlst_tpprv_bin0_wclk),
       .rf_ll_schlst_tpprv_bin0_wclk_rst_n                       (i_hqm_sip_rf_ll_schlst_tpprv_bin0_wclk_rst_n),
       .rf_ll_schlst_tpprv_bin0_we                               (i_hqm_sip_rf_ll_schlst_tpprv_bin0_we),
       .rf_ll_schlst_tpprv_bin0_waddr                            (i_hqm_sip_rf_ll_schlst_tpprv_bin0_waddr),
       .rf_ll_schlst_tpprv_bin0_wdata                            (i_hqm_sip_rf_ll_schlst_tpprv_bin0_wdata),
       .rf_ll_schlst_tpprv_bin0_rclk                             (i_hqm_sip_rf_ll_schlst_tpprv_bin0_rclk),
       .rf_ll_schlst_tpprv_bin0_rclk_rst_n                       (i_hqm_sip_rf_ll_schlst_tpprv_bin0_rclk_rst_n),
       .rf_ll_schlst_tpprv_bin0_re                               (i_hqm_sip_rf_ll_schlst_tpprv_bin0_re),
       .rf_ll_schlst_tpprv_bin0_raddr                            (i_hqm_sip_rf_ll_schlst_tpprv_bin0_raddr),
       .rf_ll_schlst_tpprv_bin0_rdata                            (i_hqm_list_sel_mem_rf_ll_schlst_tpprv_bin0_rdata),
       .rf_ll_schlst_tpprv_bin0_isol_en                          (i_hqm_sip_pgcb_isol_en),
       .rf_ll_schlst_tpprv_bin0_pwr_enable_b_in                  (i_hqm_list_sel_mem_rf_ll_schlst_tp_bin3_pwr_enable_b_out),
       .rf_ll_schlst_tpprv_bin0_pwr_enable_b_out                 (i_hqm_list_sel_mem_rf_ll_schlst_tpprv_bin0_pwr_enable_b_out),
       .rf_ll_schlst_tpprv_bin1_wclk                             (i_hqm_sip_rf_ll_schlst_tpprv_bin1_wclk),
       .rf_ll_schlst_tpprv_bin1_wclk_rst_n                       (i_hqm_sip_rf_ll_schlst_tpprv_bin1_wclk_rst_n),
       .rf_ll_schlst_tpprv_bin1_we                               (i_hqm_sip_rf_ll_schlst_tpprv_bin1_we),
       .rf_ll_schlst_tpprv_bin1_waddr                            (i_hqm_sip_rf_ll_schlst_tpprv_bin1_waddr),
       .rf_ll_schlst_tpprv_bin1_wdata                            (i_hqm_sip_rf_ll_schlst_tpprv_bin1_wdata),
       .rf_ll_schlst_tpprv_bin1_rclk                             (i_hqm_sip_rf_ll_schlst_tpprv_bin1_rclk),
       .rf_ll_schlst_tpprv_bin1_rclk_rst_n                       (i_hqm_sip_rf_ll_schlst_tpprv_bin1_rclk_rst_n),
       .rf_ll_schlst_tpprv_bin1_re                               (i_hqm_sip_rf_ll_schlst_tpprv_bin1_re),
       .rf_ll_schlst_tpprv_bin1_raddr                            (i_hqm_sip_rf_ll_schlst_tpprv_bin1_raddr),
       .rf_ll_schlst_tpprv_bin1_rdata                            (i_hqm_list_sel_mem_rf_ll_schlst_tpprv_bin1_rdata),
       .rf_ll_schlst_tpprv_bin1_isol_en                          (i_hqm_sip_pgcb_isol_en),
       .rf_ll_schlst_tpprv_bin1_pwr_enable_b_in                  (i_hqm_list_sel_mem_rf_ll_schlst_tpprv_bin0_pwr_enable_b_out),
       .rf_ll_schlst_tpprv_bin1_pwr_enable_b_out                 (i_hqm_list_sel_mem_rf_ll_schlst_tpprv_bin1_pwr_enable_b_out),
       .rf_ll_schlst_tpprv_bin2_wclk                             (i_hqm_sip_rf_ll_schlst_tpprv_bin2_wclk),
       .rf_ll_schlst_tpprv_bin2_wclk_rst_n                       (i_hqm_sip_rf_ll_schlst_tpprv_bin2_wclk_rst_n),
       .rf_ll_schlst_tpprv_bin2_we                               (i_hqm_sip_rf_ll_schlst_tpprv_bin2_we),
       .rf_ll_schlst_tpprv_bin2_waddr                            (i_hqm_sip_rf_ll_schlst_tpprv_bin2_waddr),
       .rf_ll_schlst_tpprv_bin2_wdata                            (i_hqm_sip_rf_ll_schlst_tpprv_bin2_wdata),
       .rf_ll_schlst_tpprv_bin2_rclk                             (i_hqm_sip_rf_ll_schlst_tpprv_bin2_rclk),
       .rf_ll_schlst_tpprv_bin2_rclk_rst_n                       (i_hqm_sip_rf_ll_schlst_tpprv_bin2_rclk_rst_n),
       .rf_ll_schlst_tpprv_bin2_re                               (i_hqm_sip_rf_ll_schlst_tpprv_bin2_re),
       .rf_ll_schlst_tpprv_bin2_raddr                            (i_hqm_sip_rf_ll_schlst_tpprv_bin2_raddr),
       .rf_ll_schlst_tpprv_bin2_rdata                            (i_hqm_list_sel_mem_rf_ll_schlst_tpprv_bin2_rdata),
       .rf_ll_schlst_tpprv_bin2_isol_en                          (i_hqm_sip_pgcb_isol_en),
       .rf_ll_schlst_tpprv_bin2_pwr_enable_b_in                  (i_hqm_list_sel_mem_rf_ll_schlst_tpprv_bin1_pwr_enable_b_out),
       .rf_ll_schlst_tpprv_bin2_pwr_enable_b_out                 (i_hqm_list_sel_mem_rf_ll_schlst_tpprv_bin2_pwr_enable_b_out),
       .rf_ll_schlst_tpprv_bin3_wclk                             (i_hqm_sip_rf_ll_schlst_tpprv_bin3_wclk),
       .rf_ll_schlst_tpprv_bin3_wclk_rst_n                       (i_hqm_sip_rf_ll_schlst_tpprv_bin3_wclk_rst_n),
       .rf_ll_schlst_tpprv_bin3_we                               (i_hqm_sip_rf_ll_schlst_tpprv_bin3_we),
       .rf_ll_schlst_tpprv_bin3_waddr                            (i_hqm_sip_rf_ll_schlst_tpprv_bin3_waddr),
       .rf_ll_schlst_tpprv_bin3_wdata                            (i_hqm_sip_rf_ll_schlst_tpprv_bin3_wdata),
       .rf_ll_schlst_tpprv_bin3_rclk                             (i_hqm_sip_rf_ll_schlst_tpprv_bin3_rclk),
       .rf_ll_schlst_tpprv_bin3_rclk_rst_n                       (i_hqm_sip_rf_ll_schlst_tpprv_bin3_rclk_rst_n),
       .rf_ll_schlst_tpprv_bin3_re                               (i_hqm_sip_rf_ll_schlst_tpprv_bin3_re),
       .rf_ll_schlst_tpprv_bin3_raddr                            (i_hqm_sip_rf_ll_schlst_tpprv_bin3_raddr),
       .rf_ll_schlst_tpprv_bin3_rdata                            (i_hqm_list_sel_mem_rf_ll_schlst_tpprv_bin3_rdata),
       .rf_ll_schlst_tpprv_bin3_isol_en                          (i_hqm_sip_pgcb_isol_en),
       .rf_ll_schlst_tpprv_bin3_pwr_enable_b_in                  (i_hqm_list_sel_mem_rf_ll_schlst_tpprv_bin2_pwr_enable_b_out),
       .rf_ll_schlst_tpprv_bin3_pwr_enable_b_out                 (i_hqm_list_sel_mem_rf_ll_schlst_tpprv_bin3_pwr_enable_b_out),
       .rf_ll_slst_cnt_wclk                                      (i_hqm_sip_rf_ll_slst_cnt_wclk),
       .rf_ll_slst_cnt_wclk_rst_n                                (i_hqm_sip_rf_ll_slst_cnt_wclk_rst_n),
       .rf_ll_slst_cnt_we                                        (i_hqm_sip_rf_ll_slst_cnt_we),
       .rf_ll_slst_cnt_waddr                                     (i_hqm_sip_rf_ll_slst_cnt_waddr),
       .rf_ll_slst_cnt_wdata                                     (i_hqm_sip_rf_ll_slst_cnt_wdata),
       .rf_ll_slst_cnt_rclk                                      (i_hqm_sip_rf_ll_slst_cnt_rclk),
       .rf_ll_slst_cnt_rclk_rst_n                                (i_hqm_sip_rf_ll_slst_cnt_rclk_rst_n),
       .rf_ll_slst_cnt_re                                        (i_hqm_sip_rf_ll_slst_cnt_re),
       .rf_ll_slst_cnt_raddr                                     (i_hqm_sip_rf_ll_slst_cnt_raddr),
       .rf_ll_slst_cnt_rdata                                     (i_hqm_list_sel_mem_rf_ll_slst_cnt_rdata),
       .rf_ll_slst_cnt_isol_en                                   (i_hqm_sip_pgcb_isol_en),
       .rf_ll_slst_cnt_pwr_enable_b_in                           (i_hqm_list_sel_mem_rf_ll_schlst_tpprv_bin3_pwr_enable_b_out),
       .rf_ll_slst_cnt_pwr_enable_b_out                          (i_hqm_list_sel_mem_rf_ll_slst_cnt_pwr_enable_b_out),
       .rf_nalb_cmp_fifo_mem_wclk                                (i_hqm_sip_rf_nalb_cmp_fifo_mem_wclk),
       .rf_nalb_cmp_fifo_mem_wclk_rst_n                          (i_hqm_sip_rf_nalb_cmp_fifo_mem_wclk_rst_n),
       .rf_nalb_cmp_fifo_mem_we                                  (i_hqm_sip_rf_nalb_cmp_fifo_mem_we),
       .rf_nalb_cmp_fifo_mem_waddr                               (i_hqm_sip_rf_nalb_cmp_fifo_mem_waddr),
       .rf_nalb_cmp_fifo_mem_wdata                               (i_hqm_sip_rf_nalb_cmp_fifo_mem_wdata),
       .rf_nalb_cmp_fifo_mem_rclk                                (i_hqm_sip_rf_nalb_cmp_fifo_mem_rclk),
       .rf_nalb_cmp_fifo_mem_rclk_rst_n                          (i_hqm_sip_rf_nalb_cmp_fifo_mem_rclk_rst_n),
       .rf_nalb_cmp_fifo_mem_re                                  (i_hqm_sip_rf_nalb_cmp_fifo_mem_re),
       .rf_nalb_cmp_fifo_mem_raddr                               (i_hqm_sip_rf_nalb_cmp_fifo_mem_raddr),
       .rf_nalb_cmp_fifo_mem_rdata                               (i_hqm_list_sel_mem_rf_nalb_cmp_fifo_mem_rdata),
       .rf_nalb_cmp_fifo_mem_isol_en                             (i_hqm_sip_pgcb_isol_en),
       .rf_nalb_cmp_fifo_mem_pwr_enable_b_in                     (i_hqm_list_sel_mem_rf_ll_slst_cnt_pwr_enable_b_out),
       .rf_nalb_cmp_fifo_mem_pwr_enable_b_out                    (i_hqm_list_sel_mem_rf_nalb_cmp_fifo_mem_pwr_enable_b_out),
       .rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_wclk                 (i_hqm_sip_rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_wclk),
       .rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_wclk_rst_n           (i_hqm_sip_rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_wclk_rst_n),
       .rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_we                   (i_hqm_sip_rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_we),
       .rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_waddr                (i_hqm_sip_rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_waddr),
       .rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_wdata                (i_hqm_sip_rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_wdata),
       .rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_rclk                 (i_hqm_sip_rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_rclk),
       .rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_rclk_rst_n           (i_hqm_sip_rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_rclk_rst_n),
       .rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_re                   (i_hqm_sip_rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_re),
       .rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_raddr                (i_hqm_sip_rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_raddr),
       .rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_rdata                (i_hqm_list_sel_mem_rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_rdata),
       .rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_isol_en              (i_hqm_sip_pgcb_isol_en),
       .rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_pwr_enable_b_in      (i_hqm_list_sel_mem_rf_nalb_cmp_fifo_mem_pwr_enable_b_out),
       .rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_pwr_enable_b_out     (i_hqm_list_sel_mem_rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_pwr_enable_b_out),
       .rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_wclk             (i_hqm_sip_rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_wclk),
       .rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_wclk_rst_n       (i_hqm_sip_rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_wclk_rst_n),
       .rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_we               (i_hqm_sip_rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_we),
       .rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_waddr            (i_hqm_sip_rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_waddr),
       .rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_wdata            (i_hqm_sip_rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_wdata),
       .rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_rclk             (i_hqm_sip_rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_rclk),
       .rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_rclk_rst_n       (i_hqm_sip_rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_rclk_rst_n),
       .rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_re               (i_hqm_sip_rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_re),
       .rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_raddr            (i_hqm_sip_rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_raddr),
       .rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_rdata            (i_hqm_list_sel_mem_rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_rdata),
       .rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_isol_en          (i_hqm_sip_pgcb_isol_en),
       .rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_pwr_enable_b_in  (i_hqm_list_sel_mem_rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_pwr_enable_b_out),
       .rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_pwr_enable_b_out (i_hqm_list_sel_mem_rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_pwr_enable_b_out),
       .rf_nalb_sel_nalb_fifo_mem_wclk                           (i_hqm_sip_rf_nalb_sel_nalb_fifo_mem_wclk),
       .rf_nalb_sel_nalb_fifo_mem_wclk_rst_n                     (i_hqm_sip_rf_nalb_sel_nalb_fifo_mem_wclk_rst_n),
       .rf_nalb_sel_nalb_fifo_mem_we                             (i_hqm_sip_rf_nalb_sel_nalb_fifo_mem_we),
       .rf_nalb_sel_nalb_fifo_mem_waddr                          (i_hqm_sip_rf_nalb_sel_nalb_fifo_mem_waddr),
       .rf_nalb_sel_nalb_fifo_mem_wdata                          (i_hqm_sip_rf_nalb_sel_nalb_fifo_mem_wdata),
       .rf_nalb_sel_nalb_fifo_mem_rclk                           (i_hqm_sip_rf_nalb_sel_nalb_fifo_mem_rclk),
       .rf_nalb_sel_nalb_fifo_mem_rclk_rst_n                     (i_hqm_sip_rf_nalb_sel_nalb_fifo_mem_rclk_rst_n),
       .rf_nalb_sel_nalb_fifo_mem_re                             (i_hqm_sip_rf_nalb_sel_nalb_fifo_mem_re),
       .rf_nalb_sel_nalb_fifo_mem_raddr                          (i_hqm_sip_rf_nalb_sel_nalb_fifo_mem_raddr),
       .rf_nalb_sel_nalb_fifo_mem_rdata                          (i_hqm_list_sel_mem_rf_nalb_sel_nalb_fifo_mem_rdata),
       .rf_nalb_sel_nalb_fifo_mem_isol_en                        (i_hqm_sip_pgcb_isol_en),
       .rf_nalb_sel_nalb_fifo_mem_pwr_enable_b_in                (i_hqm_list_sel_mem_rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_pwr_enable_b_out),
       .rf_nalb_sel_nalb_fifo_mem_pwr_enable_b_out               (i_hqm_list_sel_mem_rf_nalb_sel_nalb_fifo_mem_pwr_enable_b_out),
       .rf_qed_lsp_deq_fifo_mem_wclk                             (i_hqm_sip_rf_qed_lsp_deq_fifo_mem_wclk),
       .rf_qed_lsp_deq_fifo_mem_wclk_rst_n                       (i_hqm_sip_rf_qed_lsp_deq_fifo_mem_wclk_rst_n),
       .rf_qed_lsp_deq_fifo_mem_we                               (i_hqm_sip_rf_qed_lsp_deq_fifo_mem_we),
       .rf_qed_lsp_deq_fifo_mem_waddr                            (i_hqm_sip_rf_qed_lsp_deq_fifo_mem_waddr),
       .rf_qed_lsp_deq_fifo_mem_wdata                            (i_hqm_sip_rf_qed_lsp_deq_fifo_mem_wdata),
       .rf_qed_lsp_deq_fifo_mem_rclk                             (i_hqm_sip_rf_qed_lsp_deq_fifo_mem_rclk),
       .rf_qed_lsp_deq_fifo_mem_rclk_rst_n                       (i_hqm_sip_rf_qed_lsp_deq_fifo_mem_rclk_rst_n),
       .rf_qed_lsp_deq_fifo_mem_re                               (i_hqm_sip_rf_qed_lsp_deq_fifo_mem_re),
       .rf_qed_lsp_deq_fifo_mem_raddr                            (i_hqm_sip_rf_qed_lsp_deq_fifo_mem_raddr),
       .rf_qed_lsp_deq_fifo_mem_rdata                            (i_hqm_list_sel_mem_rf_qed_lsp_deq_fifo_mem_rdata),
       .rf_qed_lsp_deq_fifo_mem_isol_en                          (i_hqm_sip_pgcb_isol_en),
       .rf_qed_lsp_deq_fifo_mem_pwr_enable_b_in                  (i_hqm_list_sel_mem_rf_nalb_sel_nalb_fifo_mem_pwr_enable_b_out),
       .rf_qed_lsp_deq_fifo_mem_pwr_enable_b_out                 (i_hqm_list_sel_mem_rf_qed_lsp_deq_fifo_mem_pwr_enable_b_out),
       .rf_qid_aqed_active_count_mem_wclk                        (i_hqm_sip_rf_qid_aqed_active_count_mem_wclk),
       .rf_qid_aqed_active_count_mem_wclk_rst_n                  (i_hqm_sip_rf_qid_aqed_active_count_mem_wclk_rst_n),
       .rf_qid_aqed_active_count_mem_we                          (i_hqm_sip_rf_qid_aqed_active_count_mem_we),
       .rf_qid_aqed_active_count_mem_waddr                       (i_hqm_sip_rf_qid_aqed_active_count_mem_waddr),
       .rf_qid_aqed_active_count_mem_wdata                       (i_hqm_sip_rf_qid_aqed_active_count_mem_wdata),
       .rf_qid_aqed_active_count_mem_rclk                        (i_hqm_sip_rf_qid_aqed_active_count_mem_rclk),
       .rf_qid_aqed_active_count_mem_rclk_rst_n                  (i_hqm_sip_rf_qid_aqed_active_count_mem_rclk_rst_n),
       .rf_qid_aqed_active_count_mem_re                          (i_hqm_sip_rf_qid_aqed_active_count_mem_re),
       .rf_qid_aqed_active_count_mem_raddr                       (i_hqm_sip_rf_qid_aqed_active_count_mem_raddr),
       .rf_qid_aqed_active_count_mem_rdata                       (i_hqm_list_sel_mem_rf_qid_aqed_active_count_mem_rdata),
       .rf_qid_aqed_active_count_mem_isol_en                     (i_hqm_sip_pgcb_isol_en),
       .rf_qid_aqed_active_count_mem_pwr_enable_b_in             (i_hqm_list_sel_mem_rf_qed_lsp_deq_fifo_mem_pwr_enable_b_out),
       .rf_qid_aqed_active_count_mem_pwr_enable_b_out            (i_hqm_list_sel_mem_rf_qid_aqed_active_count_mem_pwr_enable_b_out),
       .rf_qid_atm_active_mem_wclk                               (i_hqm_sip_rf_qid_atm_active_mem_wclk),
       .rf_qid_atm_active_mem_wclk_rst_n                         (i_hqm_sip_rf_qid_atm_active_mem_wclk_rst_n),
       .rf_qid_atm_active_mem_we                                 (i_hqm_sip_rf_qid_atm_active_mem_we),
       .rf_qid_atm_active_mem_waddr                              (i_hqm_sip_rf_qid_atm_active_mem_waddr),
       .rf_qid_atm_active_mem_wdata                              (i_hqm_sip_rf_qid_atm_active_mem_wdata),
       .rf_qid_atm_active_mem_rclk                               (i_hqm_sip_rf_qid_atm_active_mem_rclk),
       .rf_qid_atm_active_mem_rclk_rst_n                         (i_hqm_sip_rf_qid_atm_active_mem_rclk_rst_n),
       .rf_qid_atm_active_mem_re                                 (i_hqm_sip_rf_qid_atm_active_mem_re),
       .rf_qid_atm_active_mem_raddr                              (i_hqm_sip_rf_qid_atm_active_mem_raddr),
       .rf_qid_atm_active_mem_rdata                              (i_hqm_list_sel_mem_rf_qid_atm_active_mem_rdata),
       .rf_qid_atm_active_mem_isol_en                            (i_hqm_sip_pgcb_isol_en),
       .rf_qid_atm_active_mem_pwr_enable_b_in                    (i_hqm_list_sel_mem_rf_qid_aqed_active_count_mem_pwr_enable_b_out),
       .rf_qid_atm_active_mem_pwr_enable_b_out                   (i_hqm_list_sel_mem_rf_qid_atm_active_mem_pwr_enable_b_out),
       .rf_qid_atm_tot_enq_cnt_mem_wclk                          (i_hqm_sip_rf_qid_atm_tot_enq_cnt_mem_wclk),
       .rf_qid_atm_tot_enq_cnt_mem_wclk_rst_n                    (i_hqm_sip_rf_qid_atm_tot_enq_cnt_mem_wclk_rst_n),
       .rf_qid_atm_tot_enq_cnt_mem_we                            (i_hqm_sip_rf_qid_atm_tot_enq_cnt_mem_we),
       .rf_qid_atm_tot_enq_cnt_mem_waddr                         (i_hqm_sip_rf_qid_atm_tot_enq_cnt_mem_waddr),
       .rf_qid_atm_tot_enq_cnt_mem_wdata                         (i_hqm_sip_rf_qid_atm_tot_enq_cnt_mem_wdata),
       .rf_qid_atm_tot_enq_cnt_mem_rclk                          (i_hqm_sip_rf_qid_atm_tot_enq_cnt_mem_rclk),
       .rf_qid_atm_tot_enq_cnt_mem_rclk_rst_n                    (i_hqm_sip_rf_qid_atm_tot_enq_cnt_mem_rclk_rst_n),
       .rf_qid_atm_tot_enq_cnt_mem_re                            (i_hqm_sip_rf_qid_atm_tot_enq_cnt_mem_re),
       .rf_qid_atm_tot_enq_cnt_mem_raddr                         (i_hqm_sip_rf_qid_atm_tot_enq_cnt_mem_raddr),
       .rf_qid_atm_tot_enq_cnt_mem_rdata                         (i_hqm_list_sel_mem_rf_qid_atm_tot_enq_cnt_mem_rdata),
       .rf_qid_atm_tot_enq_cnt_mem_isol_en                       (i_hqm_sip_pgcb_isol_en),
       .rf_qid_atm_tot_enq_cnt_mem_pwr_enable_b_in               (i_hqm_list_sel_mem_rf_qid_atm_active_mem_pwr_enable_b_out),
       .rf_qid_atm_tot_enq_cnt_mem_pwr_enable_b_out              (i_hqm_list_sel_mem_rf_qid_atm_tot_enq_cnt_mem_pwr_enable_b_out),
       .rf_qid_atq_enqueue_count_mem_wclk                        (i_hqm_sip_rf_qid_atq_enqueue_count_mem_wclk),
       .rf_qid_atq_enqueue_count_mem_wclk_rst_n                  (i_hqm_sip_rf_qid_atq_enqueue_count_mem_wclk_rst_n),
       .rf_qid_atq_enqueue_count_mem_we                          (i_hqm_sip_rf_qid_atq_enqueue_count_mem_we),
       .rf_qid_atq_enqueue_count_mem_waddr                       (i_hqm_sip_rf_qid_atq_enqueue_count_mem_waddr),
       .rf_qid_atq_enqueue_count_mem_wdata                       (i_hqm_sip_rf_qid_atq_enqueue_count_mem_wdata),
       .rf_qid_atq_enqueue_count_mem_rclk                        (i_hqm_sip_rf_qid_atq_enqueue_count_mem_rclk),
       .rf_qid_atq_enqueue_count_mem_rclk_rst_n                  (i_hqm_sip_rf_qid_atq_enqueue_count_mem_rclk_rst_n),
       .rf_qid_atq_enqueue_count_mem_re                          (i_hqm_sip_rf_qid_atq_enqueue_count_mem_re),
       .rf_qid_atq_enqueue_count_mem_raddr                       (i_hqm_sip_rf_qid_atq_enqueue_count_mem_raddr),
       .rf_qid_atq_enqueue_count_mem_rdata                       (i_hqm_list_sel_mem_rf_qid_atq_enqueue_count_mem_rdata),
       .rf_qid_atq_enqueue_count_mem_isol_en                     (i_hqm_sip_pgcb_isol_en),
       .rf_qid_atq_enqueue_count_mem_pwr_enable_b_in             (i_hqm_list_sel_mem_rf_qid_atm_tot_enq_cnt_mem_pwr_enable_b_out),
       .rf_qid_atq_enqueue_count_mem_pwr_enable_b_out            (i_hqm_list_sel_mem_rf_qid_atq_enqueue_count_mem_pwr_enable_b_out),
       .rf_qid_dir_max_depth_mem_wclk                            (i_hqm_sip_rf_qid_dir_max_depth_mem_wclk),
       .rf_qid_dir_max_depth_mem_wclk_rst_n                      (i_hqm_sip_rf_qid_dir_max_depth_mem_wclk_rst_n),
       .rf_qid_dir_max_depth_mem_we                              (i_hqm_sip_rf_qid_dir_max_depth_mem_we),
       .rf_qid_dir_max_depth_mem_waddr                           (i_hqm_sip_rf_qid_dir_max_depth_mem_waddr),
       .rf_qid_dir_max_depth_mem_wdata                           (i_hqm_sip_rf_qid_dir_max_depth_mem_wdata),
       .rf_qid_dir_max_depth_mem_rclk                            (i_hqm_sip_rf_qid_dir_max_depth_mem_rclk),
       .rf_qid_dir_max_depth_mem_rclk_rst_n                      (i_hqm_sip_rf_qid_dir_max_depth_mem_rclk_rst_n),
       .rf_qid_dir_max_depth_mem_re                              (i_hqm_sip_rf_qid_dir_max_depth_mem_re),
       .rf_qid_dir_max_depth_mem_raddr                           (i_hqm_sip_rf_qid_dir_max_depth_mem_raddr),
       .rf_qid_dir_max_depth_mem_rdata                           (i_hqm_list_sel_mem_rf_qid_dir_max_depth_mem_rdata),
       .rf_qid_dir_max_depth_mem_isol_en                         (i_hqm_sip_pgcb_isol_en),
       .rf_qid_dir_max_depth_mem_pwr_enable_b_in                 (i_hqm_list_sel_mem_rf_qid_atq_enqueue_count_mem_pwr_enable_b_out),
       .rf_qid_dir_max_depth_mem_pwr_enable_b_out                (i_hqm_list_sel_mem_rf_qid_dir_max_depth_mem_pwr_enable_b_out),
       .rf_qid_dir_replay_count_mem_wclk                         (i_hqm_sip_rf_qid_dir_replay_count_mem_wclk),
       .rf_qid_dir_replay_count_mem_wclk_rst_n                   (i_hqm_sip_rf_qid_dir_replay_count_mem_wclk_rst_n),
       .rf_qid_dir_replay_count_mem_we                           (i_hqm_sip_rf_qid_dir_replay_count_mem_we),
       .rf_qid_dir_replay_count_mem_waddr                        (i_hqm_sip_rf_qid_dir_replay_count_mem_waddr),
       .rf_qid_dir_replay_count_mem_wdata                        (i_hqm_sip_rf_qid_dir_replay_count_mem_wdata),
       .rf_qid_dir_replay_count_mem_rclk                         (i_hqm_sip_rf_qid_dir_replay_count_mem_rclk),
       .rf_qid_dir_replay_count_mem_rclk_rst_n                   (i_hqm_sip_rf_qid_dir_replay_count_mem_rclk_rst_n),
       .rf_qid_dir_replay_count_mem_re                           (i_hqm_sip_rf_qid_dir_replay_count_mem_re),
       .rf_qid_dir_replay_count_mem_raddr                        (i_hqm_sip_rf_qid_dir_replay_count_mem_raddr),
       .rf_qid_dir_replay_count_mem_rdata                        (i_hqm_list_sel_mem_rf_qid_dir_replay_count_mem_rdata),
       .rf_qid_dir_replay_count_mem_isol_en                      (i_hqm_sip_pgcb_isol_en),
       .rf_qid_dir_replay_count_mem_pwr_enable_b_in              (i_hqm_list_sel_mem_rf_qid_dir_max_depth_mem_pwr_enable_b_out),
       .rf_qid_dir_replay_count_mem_pwr_enable_b_out             (i_hqm_list_sel_mem_rf_qid_dir_replay_count_mem_pwr_enable_b_out),
       .rf_qid_dir_tot_enq_cnt_mem_wclk                          (i_hqm_sip_rf_qid_dir_tot_enq_cnt_mem_wclk),
       .rf_qid_dir_tot_enq_cnt_mem_wclk_rst_n                    (i_hqm_sip_rf_qid_dir_tot_enq_cnt_mem_wclk_rst_n),
       .rf_qid_dir_tot_enq_cnt_mem_we                            (i_hqm_sip_rf_qid_dir_tot_enq_cnt_mem_we),
       .rf_qid_dir_tot_enq_cnt_mem_waddr                         (i_hqm_sip_rf_qid_dir_tot_enq_cnt_mem_waddr),
       .rf_qid_dir_tot_enq_cnt_mem_wdata                         (i_hqm_sip_rf_qid_dir_tot_enq_cnt_mem_wdata),
       .rf_qid_dir_tot_enq_cnt_mem_rclk                          (i_hqm_sip_rf_qid_dir_tot_enq_cnt_mem_rclk),
       .rf_qid_dir_tot_enq_cnt_mem_rclk_rst_n                    (i_hqm_sip_rf_qid_dir_tot_enq_cnt_mem_rclk_rst_n),
       .rf_qid_dir_tot_enq_cnt_mem_re                            (i_hqm_sip_rf_qid_dir_tot_enq_cnt_mem_re),
       .rf_qid_dir_tot_enq_cnt_mem_raddr                         (i_hqm_sip_rf_qid_dir_tot_enq_cnt_mem_raddr),
       .rf_qid_dir_tot_enq_cnt_mem_rdata                         (i_hqm_list_sel_mem_rf_qid_dir_tot_enq_cnt_mem_rdata),
       .rf_qid_dir_tot_enq_cnt_mem_isol_en                       (i_hqm_sip_pgcb_isol_en),
       .rf_qid_dir_tot_enq_cnt_mem_pwr_enable_b_in               (i_hqm_list_sel_mem_rf_qid_dir_replay_count_mem_pwr_enable_b_out),
       .rf_qid_dir_tot_enq_cnt_mem_pwr_enable_b_out              (i_hqm_list_sel_mem_rf_qid_dir_tot_enq_cnt_mem_pwr_enable_b_out),
       .rf_qid_ldb_enqueue_count_mem_wclk                        (i_hqm_sip_rf_qid_ldb_enqueue_count_mem_wclk),
       .rf_qid_ldb_enqueue_count_mem_wclk_rst_n                  (i_hqm_sip_rf_qid_ldb_enqueue_count_mem_wclk_rst_n),
       .rf_qid_ldb_enqueue_count_mem_we                          (i_hqm_sip_rf_qid_ldb_enqueue_count_mem_we),
       .rf_qid_ldb_enqueue_count_mem_waddr                       (i_hqm_sip_rf_qid_ldb_enqueue_count_mem_waddr),
       .rf_qid_ldb_enqueue_count_mem_wdata                       (i_hqm_sip_rf_qid_ldb_enqueue_count_mem_wdata),
       .rf_qid_ldb_enqueue_count_mem_rclk                        (i_hqm_sip_rf_qid_ldb_enqueue_count_mem_rclk),
       .rf_qid_ldb_enqueue_count_mem_rclk_rst_n                  (i_hqm_sip_rf_qid_ldb_enqueue_count_mem_rclk_rst_n),
       .rf_qid_ldb_enqueue_count_mem_re                          (i_hqm_sip_rf_qid_ldb_enqueue_count_mem_re),
       .rf_qid_ldb_enqueue_count_mem_raddr                       (i_hqm_sip_rf_qid_ldb_enqueue_count_mem_raddr),
       .rf_qid_ldb_enqueue_count_mem_rdata                       (i_hqm_list_sel_mem_rf_qid_ldb_enqueue_count_mem_rdata),
       .rf_qid_ldb_enqueue_count_mem_isol_en                     (i_hqm_sip_pgcb_isol_en),
       .rf_qid_ldb_enqueue_count_mem_pwr_enable_b_in             (i_hqm_list_sel_mem_rf_qid_dir_tot_enq_cnt_mem_pwr_enable_b_out),
       .rf_qid_ldb_enqueue_count_mem_pwr_enable_b_out            (i_hqm_list_sel_mem_rf_qid_ldb_enqueue_count_mem_pwr_enable_b_out),
       .rf_qid_ldb_inflight_count_mem_wclk                       (i_hqm_sip_rf_qid_ldb_inflight_count_mem_wclk),
       .rf_qid_ldb_inflight_count_mem_wclk_rst_n                 (i_hqm_sip_rf_qid_ldb_inflight_count_mem_wclk_rst_n),
       .rf_qid_ldb_inflight_count_mem_we                         (i_hqm_sip_rf_qid_ldb_inflight_count_mem_we),
       .rf_qid_ldb_inflight_count_mem_waddr                      (i_hqm_sip_rf_qid_ldb_inflight_count_mem_waddr),
       .rf_qid_ldb_inflight_count_mem_wdata                      (i_hqm_sip_rf_qid_ldb_inflight_count_mem_wdata),
       .rf_qid_ldb_inflight_count_mem_rclk                       (i_hqm_sip_rf_qid_ldb_inflight_count_mem_rclk),
       .rf_qid_ldb_inflight_count_mem_rclk_rst_n                 (i_hqm_sip_rf_qid_ldb_inflight_count_mem_rclk_rst_n),
       .rf_qid_ldb_inflight_count_mem_re                         (i_hqm_sip_rf_qid_ldb_inflight_count_mem_re),
       .rf_qid_ldb_inflight_count_mem_raddr                      (i_hqm_sip_rf_qid_ldb_inflight_count_mem_raddr),
       .rf_qid_ldb_inflight_count_mem_rdata                      (i_hqm_list_sel_mem_rf_qid_ldb_inflight_count_mem_rdata),
       .rf_qid_ldb_inflight_count_mem_isol_en                    (i_hqm_sip_pgcb_isol_en),
       .rf_qid_ldb_inflight_count_mem_pwr_enable_b_in            (i_hqm_list_sel_mem_rf_qid_ldb_enqueue_count_mem_pwr_enable_b_out),
       .rf_qid_ldb_inflight_count_mem_pwr_enable_b_out           (i_hqm_list_sel_mem_rf_qid_ldb_inflight_count_mem_pwr_enable_b_out),
       .rf_qid_ldb_replay_count_mem_wclk                         (i_hqm_sip_rf_qid_ldb_replay_count_mem_wclk),
       .rf_qid_ldb_replay_count_mem_wclk_rst_n                   (i_hqm_sip_rf_qid_ldb_replay_count_mem_wclk_rst_n),
       .rf_qid_ldb_replay_count_mem_we                           (i_hqm_sip_rf_qid_ldb_replay_count_mem_we),
       .rf_qid_ldb_replay_count_mem_waddr                        (i_hqm_sip_rf_qid_ldb_replay_count_mem_waddr),
       .rf_qid_ldb_replay_count_mem_wdata                        (i_hqm_sip_rf_qid_ldb_replay_count_mem_wdata),
       .rf_qid_ldb_replay_count_mem_rclk                         (i_hqm_sip_rf_qid_ldb_replay_count_mem_rclk),
       .rf_qid_ldb_replay_count_mem_rclk_rst_n                   (i_hqm_sip_rf_qid_ldb_replay_count_mem_rclk_rst_n),
       .rf_qid_ldb_replay_count_mem_re                           (i_hqm_sip_rf_qid_ldb_replay_count_mem_re),
       .rf_qid_ldb_replay_count_mem_raddr                        (i_hqm_sip_rf_qid_ldb_replay_count_mem_raddr),
       .rf_qid_ldb_replay_count_mem_rdata                        (i_hqm_list_sel_mem_rf_qid_ldb_replay_count_mem_rdata),
       .rf_qid_ldb_replay_count_mem_isol_en                      (i_hqm_sip_pgcb_isol_en),
       .rf_qid_ldb_replay_count_mem_pwr_enable_b_in              (i_hqm_list_sel_mem_rf_qid_ldb_inflight_count_mem_pwr_enable_b_out),
       .rf_qid_ldb_replay_count_mem_pwr_enable_b_out             (i_hqm_list_sel_mem_rf_qid_ldb_replay_count_mem_pwr_enable_b_out),
       .rf_qid_naldb_max_depth_mem_wclk                          (i_hqm_sip_rf_qid_naldb_max_depth_mem_wclk),
       .rf_qid_naldb_max_depth_mem_wclk_rst_n                    (i_hqm_sip_rf_qid_naldb_max_depth_mem_wclk_rst_n),
       .rf_qid_naldb_max_depth_mem_we                            (i_hqm_sip_rf_qid_naldb_max_depth_mem_we),
       .rf_qid_naldb_max_depth_mem_waddr                         (i_hqm_sip_rf_qid_naldb_max_depth_mem_waddr),
       .rf_qid_naldb_max_depth_mem_wdata                         (i_hqm_sip_rf_qid_naldb_max_depth_mem_wdata),
       .rf_qid_naldb_max_depth_mem_rclk                          (i_hqm_sip_rf_qid_naldb_max_depth_mem_rclk),
       .rf_qid_naldb_max_depth_mem_rclk_rst_n                    (i_hqm_sip_rf_qid_naldb_max_depth_mem_rclk_rst_n),
       .rf_qid_naldb_max_depth_mem_re                            (i_hqm_sip_rf_qid_naldb_max_depth_mem_re),
       .rf_qid_naldb_max_depth_mem_raddr                         (i_hqm_sip_rf_qid_naldb_max_depth_mem_raddr),
       .rf_qid_naldb_max_depth_mem_rdata                         (i_hqm_list_sel_mem_rf_qid_naldb_max_depth_mem_rdata),
       .rf_qid_naldb_max_depth_mem_isol_en                       (i_hqm_sip_pgcb_isol_en),
       .rf_qid_naldb_max_depth_mem_pwr_enable_b_in               (i_hqm_list_sel_mem_rf_qid_ldb_replay_count_mem_pwr_enable_b_out),
       .rf_qid_naldb_max_depth_mem_pwr_enable_b_out              (i_hqm_list_sel_mem_rf_qid_naldb_max_depth_mem_pwr_enable_b_out),
       .rf_qid_naldb_tot_enq_cnt_mem_wclk                        (i_hqm_sip_rf_qid_naldb_tot_enq_cnt_mem_wclk),
       .rf_qid_naldb_tot_enq_cnt_mem_wclk_rst_n                  (i_hqm_sip_rf_qid_naldb_tot_enq_cnt_mem_wclk_rst_n),
       .rf_qid_naldb_tot_enq_cnt_mem_we                          (i_hqm_sip_rf_qid_naldb_tot_enq_cnt_mem_we),
       .rf_qid_naldb_tot_enq_cnt_mem_waddr                       (i_hqm_sip_rf_qid_naldb_tot_enq_cnt_mem_waddr),
       .rf_qid_naldb_tot_enq_cnt_mem_wdata                       (i_hqm_sip_rf_qid_naldb_tot_enq_cnt_mem_wdata),
       .rf_qid_naldb_tot_enq_cnt_mem_rclk                        (i_hqm_sip_rf_qid_naldb_tot_enq_cnt_mem_rclk),
       .rf_qid_naldb_tot_enq_cnt_mem_rclk_rst_n                  (i_hqm_sip_rf_qid_naldb_tot_enq_cnt_mem_rclk_rst_n),
       .rf_qid_naldb_tot_enq_cnt_mem_re                          (i_hqm_sip_rf_qid_naldb_tot_enq_cnt_mem_re),
       .rf_qid_naldb_tot_enq_cnt_mem_raddr                       (i_hqm_sip_rf_qid_naldb_tot_enq_cnt_mem_raddr),
       .rf_qid_naldb_tot_enq_cnt_mem_rdata                       (i_hqm_list_sel_mem_rf_qid_naldb_tot_enq_cnt_mem_rdata),
       .rf_qid_naldb_tot_enq_cnt_mem_isol_en                     (i_hqm_sip_pgcb_isol_en),
       .rf_qid_naldb_tot_enq_cnt_mem_pwr_enable_b_in             (i_hqm_list_sel_mem_rf_qid_naldb_max_depth_mem_pwr_enable_b_out),
       .rf_qid_naldb_tot_enq_cnt_mem_pwr_enable_b_out            (i_hqm_list_sel_mem_rf_qid_naldb_tot_enq_cnt_mem_pwr_enable_b_out),
       .rf_qid_rdylst_clamp_wclk                                 (i_hqm_sip_rf_qid_rdylst_clamp_wclk),
       .rf_qid_rdylst_clamp_wclk_rst_n                           (i_hqm_sip_rf_qid_rdylst_clamp_wclk_rst_n),
       .rf_qid_rdylst_clamp_we                                   (i_hqm_sip_rf_qid_rdylst_clamp_we),
       .rf_qid_rdylst_clamp_waddr                                (i_hqm_sip_rf_qid_rdylst_clamp_waddr),
       .rf_qid_rdylst_clamp_wdata                                (i_hqm_sip_rf_qid_rdylst_clamp_wdata),
       .rf_qid_rdylst_clamp_rclk                                 (i_hqm_sip_rf_qid_rdylst_clamp_rclk),
       .rf_qid_rdylst_clamp_rclk_rst_n                           (i_hqm_sip_rf_qid_rdylst_clamp_rclk_rst_n),
       .rf_qid_rdylst_clamp_re                                   (i_hqm_sip_rf_qid_rdylst_clamp_re),
       .rf_qid_rdylst_clamp_raddr                                (i_hqm_sip_rf_qid_rdylst_clamp_raddr),
       .rf_qid_rdylst_clamp_rdata                                (i_hqm_list_sel_mem_rf_qid_rdylst_clamp_rdata),
       .rf_qid_rdylst_clamp_isol_en                              (i_hqm_sip_pgcb_isol_en),
       .rf_qid_rdylst_clamp_pwr_enable_b_in                      (i_hqm_list_sel_mem_rf_qid_naldb_tot_enq_cnt_mem_pwr_enable_b_out),
       .rf_qid_rdylst_clamp_pwr_enable_b_out                     (i_hqm_list_sel_mem_rf_qid_rdylst_clamp_pwr_enable_b_out),
       .rf_rop_lsp_reordercmp_rx_sync_fifo_mem_wclk              (i_hqm_sip_rf_rop_lsp_reordercmp_rx_sync_fifo_mem_wclk),
       .rf_rop_lsp_reordercmp_rx_sync_fifo_mem_wclk_rst_n        (i_hqm_sip_rf_rop_lsp_reordercmp_rx_sync_fifo_mem_wclk_rst_n),
       .rf_rop_lsp_reordercmp_rx_sync_fifo_mem_we                (i_hqm_sip_rf_rop_lsp_reordercmp_rx_sync_fifo_mem_we),
       .rf_rop_lsp_reordercmp_rx_sync_fifo_mem_waddr             (i_hqm_sip_rf_rop_lsp_reordercmp_rx_sync_fifo_mem_waddr),
       .rf_rop_lsp_reordercmp_rx_sync_fifo_mem_wdata             (i_hqm_sip_rf_rop_lsp_reordercmp_rx_sync_fifo_mem_wdata),
       .rf_rop_lsp_reordercmp_rx_sync_fifo_mem_rclk              (i_hqm_sip_rf_rop_lsp_reordercmp_rx_sync_fifo_mem_rclk),
       .rf_rop_lsp_reordercmp_rx_sync_fifo_mem_rclk_rst_n        (i_hqm_sip_rf_rop_lsp_reordercmp_rx_sync_fifo_mem_rclk_rst_n),
       .rf_rop_lsp_reordercmp_rx_sync_fifo_mem_re                (i_hqm_sip_rf_rop_lsp_reordercmp_rx_sync_fifo_mem_re),
       .rf_rop_lsp_reordercmp_rx_sync_fifo_mem_raddr             (i_hqm_sip_rf_rop_lsp_reordercmp_rx_sync_fifo_mem_raddr),
       .rf_rop_lsp_reordercmp_rx_sync_fifo_mem_rdata             (i_hqm_list_sel_mem_rf_rop_lsp_reordercmp_rx_sync_fifo_mem_rdata),
       .rf_rop_lsp_reordercmp_rx_sync_fifo_mem_isol_en           (i_hqm_sip_pgcb_isol_en),
       .rf_rop_lsp_reordercmp_rx_sync_fifo_mem_pwr_enable_b_in   (i_hqm_list_sel_mem_rf_qid_rdylst_clamp_pwr_enable_b_out),
       .rf_rop_lsp_reordercmp_rx_sync_fifo_mem_pwr_enable_b_out  (i_hqm_list_sel_mem_rf_rop_lsp_reordercmp_rx_sync_fifo_mem_pwr_enable_b_out),
       .rf_rx_sync_qed_aqed_enq_wclk                             (i_hqm_sip_rf_rx_sync_qed_aqed_enq_wclk),
       .rf_rx_sync_qed_aqed_enq_wclk_rst_n                       (i_hqm_sip_rf_rx_sync_qed_aqed_enq_wclk_rst_n),
       .rf_rx_sync_qed_aqed_enq_we                               (i_hqm_sip_rf_rx_sync_qed_aqed_enq_we),
       .rf_rx_sync_qed_aqed_enq_waddr                            (i_hqm_sip_rf_rx_sync_qed_aqed_enq_waddr),
       .rf_rx_sync_qed_aqed_enq_wdata                            (i_hqm_sip_rf_rx_sync_qed_aqed_enq_wdata),
       .rf_rx_sync_qed_aqed_enq_rclk                             (i_hqm_sip_rf_rx_sync_qed_aqed_enq_rclk),
       .rf_rx_sync_qed_aqed_enq_rclk_rst_n                       (i_hqm_sip_rf_rx_sync_qed_aqed_enq_rclk_rst_n),
       .rf_rx_sync_qed_aqed_enq_re                               (i_hqm_sip_rf_rx_sync_qed_aqed_enq_re),
       .rf_rx_sync_qed_aqed_enq_raddr                            (i_hqm_sip_rf_rx_sync_qed_aqed_enq_raddr),
       .rf_rx_sync_qed_aqed_enq_rdata                            (i_hqm_list_sel_mem_rf_rx_sync_qed_aqed_enq_rdata),
       .rf_rx_sync_qed_aqed_enq_isol_en                          (i_hqm_sip_pgcb_isol_en),
       .rf_rx_sync_qed_aqed_enq_pwr_enable_b_in                  (i_hqm_list_sel_mem_rf_rop_lsp_reordercmp_rx_sync_fifo_mem_pwr_enable_b_out),
       .rf_rx_sync_qed_aqed_enq_pwr_enable_b_out                 (i_hqm_list_sel_mem_rf_rx_sync_qed_aqed_enq_pwr_enable_b_out),
       .rf_send_atm_to_cq_rx_sync_fifo_mem_wclk                  (i_hqm_sip_rf_send_atm_to_cq_rx_sync_fifo_mem_wclk),
       .rf_send_atm_to_cq_rx_sync_fifo_mem_wclk_rst_n            (i_hqm_sip_rf_send_atm_to_cq_rx_sync_fifo_mem_wclk_rst_n),
       .rf_send_atm_to_cq_rx_sync_fifo_mem_we                    (i_hqm_sip_rf_send_atm_to_cq_rx_sync_fifo_mem_we),
       .rf_send_atm_to_cq_rx_sync_fifo_mem_waddr                 (i_hqm_sip_rf_send_atm_to_cq_rx_sync_fifo_mem_waddr),
       .rf_send_atm_to_cq_rx_sync_fifo_mem_wdata                 (i_hqm_sip_rf_send_atm_to_cq_rx_sync_fifo_mem_wdata),
       .rf_send_atm_to_cq_rx_sync_fifo_mem_rclk                  (i_hqm_sip_rf_send_atm_to_cq_rx_sync_fifo_mem_rclk),
       .rf_send_atm_to_cq_rx_sync_fifo_mem_rclk_rst_n            (i_hqm_sip_rf_send_atm_to_cq_rx_sync_fifo_mem_rclk_rst_n),
       .rf_send_atm_to_cq_rx_sync_fifo_mem_re                    (i_hqm_sip_rf_send_atm_to_cq_rx_sync_fifo_mem_re),
       .rf_send_atm_to_cq_rx_sync_fifo_mem_raddr                 (i_hqm_sip_rf_send_atm_to_cq_rx_sync_fifo_mem_raddr),
       .rf_send_atm_to_cq_rx_sync_fifo_mem_rdata                 (i_hqm_list_sel_mem_rf_send_atm_to_cq_rx_sync_fifo_mem_rdata),
       .rf_send_atm_to_cq_rx_sync_fifo_mem_isol_en               (i_hqm_sip_pgcb_isol_en),
       .rf_send_atm_to_cq_rx_sync_fifo_mem_pwr_enable_b_in       (i_hqm_list_sel_mem_rf_rx_sync_qed_aqed_enq_pwr_enable_b_out),
       .rf_send_atm_to_cq_rx_sync_fifo_mem_pwr_enable_b_out      (i_hqm_list_sel_mem_rf_send_atm_to_cq_rx_sync_fifo_mem_pwr_enable_b_out),
       .rf_uno_atm_cmp_fifo_mem_wclk                             (i_hqm_sip_rf_uno_atm_cmp_fifo_mem_wclk),
       .rf_uno_atm_cmp_fifo_mem_wclk_rst_n                       (i_hqm_sip_rf_uno_atm_cmp_fifo_mem_wclk_rst_n),
       .rf_uno_atm_cmp_fifo_mem_we                               (i_hqm_sip_rf_uno_atm_cmp_fifo_mem_we),
       .rf_uno_atm_cmp_fifo_mem_waddr                            (i_hqm_sip_rf_uno_atm_cmp_fifo_mem_waddr),
       .rf_uno_atm_cmp_fifo_mem_wdata                            (i_hqm_sip_rf_uno_atm_cmp_fifo_mem_wdata),
       .rf_uno_atm_cmp_fifo_mem_rclk                             (i_hqm_sip_rf_uno_atm_cmp_fifo_mem_rclk),
       .rf_uno_atm_cmp_fifo_mem_rclk_rst_n                       (i_hqm_sip_rf_uno_atm_cmp_fifo_mem_rclk_rst_n),
       .rf_uno_atm_cmp_fifo_mem_re                               (i_hqm_sip_rf_uno_atm_cmp_fifo_mem_re),
       .rf_uno_atm_cmp_fifo_mem_raddr                            (i_hqm_sip_rf_uno_atm_cmp_fifo_mem_raddr),
       .rf_uno_atm_cmp_fifo_mem_rdata                            (i_hqm_list_sel_mem_rf_uno_atm_cmp_fifo_mem_rdata),
       .rf_uno_atm_cmp_fifo_mem_isol_en                          (i_hqm_sip_pgcb_isol_en),
       .rf_uno_atm_cmp_fifo_mem_pwr_enable_b_in                  (i_hqm_list_sel_mem_rf_send_atm_to_cq_rx_sync_fifo_mem_pwr_enable_b_out),
       .rf_uno_atm_cmp_fifo_mem_pwr_enable_b_out                 (i_hqm_list_sel_mem_rf_uno_atm_cmp_fifo_mem_pwr_enable_b_out),
       .sr_aqed_clk                                              (i_hqm_sip_sr_aqed_clk),
       .sr_aqed_clk_rst_n                                        (i_hqm_sip_sr_aqed_clk_rst_n),
       .sr_aqed_addr                                             (i_hqm_sip_sr_aqed_addr),
       .sr_aqed_we                                               (i_hqm_sip_sr_aqed_we),
       .sr_aqed_wdata                                            (i_hqm_sip_sr_aqed_wdata),
       .sr_aqed_re                                               (i_hqm_sip_sr_aqed_re),
       .sr_aqed_rdata                                            (i_hqm_list_sel_mem_sr_aqed_rdata),
       .sr_aqed_isol_en                                          (i_hqm_sip_pgcb_isol_en),
       .sr_aqed_pwr_enable_b_in                                  (i_hqm_sip_par_mem_pgcb_fet_en_b),
       .sr_aqed_pwr_enable_b_out                                 (i_hqm_list_sel_mem_sr_aqed_pwr_enable_b_out),
       .sr_aqed_freelist_clk                                     (i_hqm_sip_sr_aqed_freelist_clk),
       .sr_aqed_freelist_clk_rst_n                               (i_hqm_sip_sr_aqed_freelist_clk_rst_n),
       .sr_aqed_freelist_addr                                    (i_hqm_sip_sr_aqed_freelist_addr),
       .sr_aqed_freelist_we                                      (i_hqm_sip_sr_aqed_freelist_we),
       .sr_aqed_freelist_wdata                                   (i_hqm_sip_sr_aqed_freelist_wdata),
       .sr_aqed_freelist_re                                      (i_hqm_sip_sr_aqed_freelist_re),
       .sr_aqed_freelist_rdata                                   (i_hqm_list_sel_mem_sr_aqed_freelist_rdata),
       .sr_aqed_freelist_isol_en                                 (i_hqm_sip_pgcb_isol_en),
       .sr_aqed_freelist_pwr_enable_b_in                         (i_hqm_list_sel_mem_sr_aqed_pwr_enable_b_out),
       .sr_aqed_freelist_pwr_enable_b_out                        (i_hqm_list_sel_mem_sr_aqed_freelist_pwr_enable_b_out),
       .sr_aqed_ll_qe_hpnxt_clk                                  (i_hqm_sip_sr_aqed_ll_qe_hpnxt_clk),
       .sr_aqed_ll_qe_hpnxt_clk_rst_n                            (i_hqm_sip_sr_aqed_ll_qe_hpnxt_clk_rst_n),
       .sr_aqed_ll_qe_hpnxt_addr                                 (i_hqm_sip_sr_aqed_ll_qe_hpnxt_addr),
       .sr_aqed_ll_qe_hpnxt_we                                   (i_hqm_sip_sr_aqed_ll_qe_hpnxt_we),
       .sr_aqed_ll_qe_hpnxt_wdata                                (i_hqm_sip_sr_aqed_ll_qe_hpnxt_wdata),
       .sr_aqed_ll_qe_hpnxt_re                                   (i_hqm_sip_sr_aqed_ll_qe_hpnxt_re),
       .sr_aqed_ll_qe_hpnxt_rdata                                (i_hqm_list_sel_mem_sr_aqed_ll_qe_hpnxt_rdata),
       .sr_aqed_ll_qe_hpnxt_isol_en                              (i_hqm_sip_pgcb_isol_en),
       .sr_aqed_ll_qe_hpnxt_pwr_enable_b_in                      (i_hqm_list_sel_mem_sr_aqed_freelist_pwr_enable_b_out),
       .sr_aqed_ll_qe_hpnxt_pwr_enable_b_out                     (i_hqm_list_sel_mem_sr_aqed_ll_qe_hpnxt_pwr_enable_b_out),
       .hqm_pwrgood_rst_b                                        (i_hqm_sip_hqm_pwrgood_rst_b),
       .powergood_rst_b,
       .fscan_byprst_b,
       .fscan_clkungate,
       .fscan_rstbypen);

   hqm_qed_mem i_hqm_qed_mem
      (.rf_atq_cnt_wclk                                 (i_hqm_sip_rf_atq_cnt_wclk),
       .rf_atq_cnt_wclk_rst_n                           (i_hqm_sip_rf_atq_cnt_wclk_rst_n),
       .rf_atq_cnt_we                                   (i_hqm_sip_rf_atq_cnt_we),
       .rf_atq_cnt_waddr                                (i_hqm_sip_rf_atq_cnt_waddr),
       .rf_atq_cnt_wdata                                (i_hqm_sip_rf_atq_cnt_wdata),
       .rf_atq_cnt_rclk                                 (i_hqm_sip_rf_atq_cnt_rclk),
       .rf_atq_cnt_rclk_rst_n                           (i_hqm_sip_rf_atq_cnt_rclk_rst_n),
       .rf_atq_cnt_re                                   (i_hqm_sip_rf_atq_cnt_re),
       .rf_atq_cnt_raddr                                (i_hqm_sip_rf_atq_cnt_raddr),
       .rf_atq_cnt_rdata                                (i_hqm_qed_mem_rf_atq_cnt_rdata),
       .rf_atq_cnt_isol_en                              (i_hqm_sip_pgcb_isol_en),
       .rf_atq_cnt_pwr_enable_b_in                      (i_hqm_qed_mem_sr_qed_7_pwr_enable_b_out),
       .rf_atq_cnt_pwr_enable_b_out                     (i_hqm_qed_mem_rf_atq_cnt_pwr_enable_b_out),
       .rf_atq_hp_wclk                                  (i_hqm_sip_rf_atq_hp_wclk),
       .rf_atq_hp_wclk_rst_n                            (i_hqm_sip_rf_atq_hp_wclk_rst_n),
       .rf_atq_hp_we                                    (i_hqm_sip_rf_atq_hp_we),
       .rf_atq_hp_waddr                                 (i_hqm_sip_rf_atq_hp_waddr),
       .rf_atq_hp_wdata                                 (i_hqm_sip_rf_atq_hp_wdata),
       .rf_atq_hp_rclk                                  (i_hqm_sip_rf_atq_hp_rclk),
       .rf_atq_hp_rclk_rst_n                            (i_hqm_sip_rf_atq_hp_rclk_rst_n),
       .rf_atq_hp_re                                    (i_hqm_sip_rf_atq_hp_re),
       .rf_atq_hp_raddr                                 (i_hqm_sip_rf_atq_hp_raddr),
       .rf_atq_hp_rdata                                 (i_hqm_qed_mem_rf_atq_hp_rdata),
       .rf_atq_hp_isol_en                               (i_hqm_sip_pgcb_isol_en),
       .rf_atq_hp_pwr_enable_b_in                       (i_hqm_qed_mem_rf_atq_cnt_pwr_enable_b_out),
       .rf_atq_hp_pwr_enable_b_out                      (i_hqm_qed_mem_rf_atq_hp_pwr_enable_b_out),
       .rf_atq_tp_wclk                                  (i_hqm_sip_rf_atq_tp_wclk),
       .rf_atq_tp_wclk_rst_n                            (i_hqm_sip_rf_atq_tp_wclk_rst_n),
       .rf_atq_tp_we                                    (i_hqm_sip_rf_atq_tp_we),
       .rf_atq_tp_waddr                                 (i_hqm_sip_rf_atq_tp_waddr),
       .rf_atq_tp_wdata                                 (i_hqm_sip_rf_atq_tp_wdata),
       .rf_atq_tp_rclk                                  (i_hqm_sip_rf_atq_tp_rclk),
       .rf_atq_tp_rclk_rst_n                            (i_hqm_sip_rf_atq_tp_rclk_rst_n),
       .rf_atq_tp_re                                    (i_hqm_sip_rf_atq_tp_re),
       .rf_atq_tp_raddr                                 (i_hqm_sip_rf_atq_tp_raddr),
       .rf_atq_tp_rdata                                 (i_hqm_qed_mem_rf_atq_tp_rdata),
       .rf_atq_tp_isol_en                               (i_hqm_sip_pgcb_isol_en),
       .rf_atq_tp_pwr_enable_b_in                       (i_hqm_qed_mem_rf_atq_hp_pwr_enable_b_out),
       .rf_atq_tp_pwr_enable_b_out                      (i_hqm_qed_mem_rf_atq_tp_pwr_enable_b_out),
       .rf_dir_cnt_wclk                                 (i_hqm_sip_rf_dir_cnt_wclk),
       .rf_dir_cnt_wclk_rst_n                           (i_hqm_sip_rf_dir_cnt_wclk_rst_n),
       .rf_dir_cnt_we                                   (i_hqm_sip_rf_dir_cnt_we),
       .rf_dir_cnt_waddr                                (i_hqm_sip_rf_dir_cnt_waddr),
       .rf_dir_cnt_wdata                                (i_hqm_sip_rf_dir_cnt_wdata),
       .rf_dir_cnt_rclk                                 (i_hqm_sip_rf_dir_cnt_rclk),
       .rf_dir_cnt_rclk_rst_n                           (i_hqm_sip_rf_dir_cnt_rclk_rst_n),
       .rf_dir_cnt_re                                   (i_hqm_sip_rf_dir_cnt_re),
       .rf_dir_cnt_raddr                                (i_hqm_sip_rf_dir_cnt_raddr),
       .rf_dir_cnt_rdata                                (i_hqm_qed_mem_rf_dir_cnt_rdata),
       .rf_dir_cnt_isol_en                              (i_hqm_sip_pgcb_isol_en),
       .rf_dir_cnt_pwr_enable_b_in                      (i_hqm_qed_mem_rf_atq_tp_pwr_enable_b_out),
       .rf_dir_cnt_pwr_enable_b_out                     (i_hqm_qed_mem_rf_dir_cnt_pwr_enable_b_out),
       .rf_dir_hp_wclk                                  (i_hqm_sip_rf_dir_hp_wclk),
       .rf_dir_hp_wclk_rst_n                            (i_hqm_sip_rf_dir_hp_wclk_rst_n),
       .rf_dir_hp_we                                    (i_hqm_sip_rf_dir_hp_we),
       .rf_dir_hp_waddr                                 (i_hqm_sip_rf_dir_hp_waddr),
       .rf_dir_hp_wdata                                 (i_hqm_sip_rf_dir_hp_wdata),
       .rf_dir_hp_rclk                                  (i_hqm_sip_rf_dir_hp_rclk),
       .rf_dir_hp_rclk_rst_n                            (i_hqm_sip_rf_dir_hp_rclk_rst_n),
       .rf_dir_hp_re                                    (i_hqm_sip_rf_dir_hp_re),
       .rf_dir_hp_raddr                                 (i_hqm_sip_rf_dir_hp_raddr),
       .rf_dir_hp_rdata                                 (i_hqm_qed_mem_rf_dir_hp_rdata),
       .rf_dir_hp_isol_en                               (i_hqm_sip_pgcb_isol_en),
       .rf_dir_hp_pwr_enable_b_in                       (i_hqm_qed_mem_rf_dir_cnt_pwr_enable_b_out),
       .rf_dir_hp_pwr_enable_b_out                      (i_hqm_qed_mem_rf_dir_hp_pwr_enable_b_out),
       .rf_dir_replay_cnt_wclk                          (i_hqm_sip_rf_dir_replay_cnt_wclk),
       .rf_dir_replay_cnt_wclk_rst_n                    (i_hqm_sip_rf_dir_replay_cnt_wclk_rst_n),
       .rf_dir_replay_cnt_we                            (i_hqm_sip_rf_dir_replay_cnt_we),
       .rf_dir_replay_cnt_waddr                         (i_hqm_sip_rf_dir_replay_cnt_waddr),
       .rf_dir_replay_cnt_wdata                         (i_hqm_sip_rf_dir_replay_cnt_wdata),
       .rf_dir_replay_cnt_rclk                          (i_hqm_sip_rf_dir_replay_cnt_rclk),
       .rf_dir_replay_cnt_rclk_rst_n                    (i_hqm_sip_rf_dir_replay_cnt_rclk_rst_n),
       .rf_dir_replay_cnt_re                            (i_hqm_sip_rf_dir_replay_cnt_re),
       .rf_dir_replay_cnt_raddr                         (i_hqm_sip_rf_dir_replay_cnt_raddr),
       .rf_dir_replay_cnt_rdata                         (i_hqm_qed_mem_rf_dir_replay_cnt_rdata),
       .rf_dir_replay_cnt_isol_en                       (i_hqm_sip_pgcb_isol_en),
       .rf_dir_replay_cnt_pwr_enable_b_in               (i_hqm_qed_mem_rf_dir_hp_pwr_enable_b_out),
       .rf_dir_replay_cnt_pwr_enable_b_out              (i_hqm_qed_mem_rf_dir_replay_cnt_pwr_enable_b_out),
       .rf_dir_replay_hp_wclk                           (i_hqm_sip_rf_dir_replay_hp_wclk),
       .rf_dir_replay_hp_wclk_rst_n                     (i_hqm_sip_rf_dir_replay_hp_wclk_rst_n),
       .rf_dir_replay_hp_we                             (i_hqm_sip_rf_dir_replay_hp_we),
       .rf_dir_replay_hp_waddr                          (i_hqm_sip_rf_dir_replay_hp_waddr),
       .rf_dir_replay_hp_wdata                          (i_hqm_sip_rf_dir_replay_hp_wdata),
       .rf_dir_replay_hp_rclk                           (i_hqm_sip_rf_dir_replay_hp_rclk),
       .rf_dir_replay_hp_rclk_rst_n                     (i_hqm_sip_rf_dir_replay_hp_rclk_rst_n),
       .rf_dir_replay_hp_re                             (i_hqm_sip_rf_dir_replay_hp_re),
       .rf_dir_replay_hp_raddr                          (i_hqm_sip_rf_dir_replay_hp_raddr),
       .rf_dir_replay_hp_rdata                          (i_hqm_qed_mem_rf_dir_replay_hp_rdata),
       .rf_dir_replay_hp_isol_en                        (i_hqm_sip_pgcb_isol_en),
       .rf_dir_replay_hp_pwr_enable_b_in                (i_hqm_qed_mem_rf_dir_replay_cnt_pwr_enable_b_out),
       .rf_dir_replay_hp_pwr_enable_b_out               (i_hqm_qed_mem_rf_dir_replay_hp_pwr_enable_b_out),
       .rf_dir_replay_tp_wclk                           (i_hqm_sip_rf_dir_replay_tp_wclk),
       .rf_dir_replay_tp_wclk_rst_n                     (i_hqm_sip_rf_dir_replay_tp_wclk_rst_n),
       .rf_dir_replay_tp_we                             (i_hqm_sip_rf_dir_replay_tp_we),
       .rf_dir_replay_tp_waddr                          (i_hqm_sip_rf_dir_replay_tp_waddr),
       .rf_dir_replay_tp_wdata                          (i_hqm_sip_rf_dir_replay_tp_wdata),
       .rf_dir_replay_tp_rclk                           (i_hqm_sip_rf_dir_replay_tp_rclk),
       .rf_dir_replay_tp_rclk_rst_n                     (i_hqm_sip_rf_dir_replay_tp_rclk_rst_n),
       .rf_dir_replay_tp_re                             (i_hqm_sip_rf_dir_replay_tp_re),
       .rf_dir_replay_tp_raddr                          (i_hqm_sip_rf_dir_replay_tp_raddr),
       .rf_dir_replay_tp_rdata                          (i_hqm_qed_mem_rf_dir_replay_tp_rdata),
       .rf_dir_replay_tp_isol_en                        (i_hqm_sip_pgcb_isol_en),
       .rf_dir_replay_tp_pwr_enable_b_in                (i_hqm_qed_mem_rf_dir_replay_hp_pwr_enable_b_out),
       .rf_dir_replay_tp_pwr_enable_b_out               (i_hqm_qed_mem_rf_dir_replay_tp_pwr_enable_b_out),
       .rf_dir_rofrag_cnt_wclk                          (i_hqm_sip_rf_dir_rofrag_cnt_wclk),
       .rf_dir_rofrag_cnt_wclk_rst_n                    (i_hqm_sip_rf_dir_rofrag_cnt_wclk_rst_n),
       .rf_dir_rofrag_cnt_we                            (i_hqm_sip_rf_dir_rofrag_cnt_we),
       .rf_dir_rofrag_cnt_waddr                         (i_hqm_sip_rf_dir_rofrag_cnt_waddr),
       .rf_dir_rofrag_cnt_wdata                         (i_hqm_sip_rf_dir_rofrag_cnt_wdata),
       .rf_dir_rofrag_cnt_rclk                          (i_hqm_sip_rf_dir_rofrag_cnt_rclk),
       .rf_dir_rofrag_cnt_rclk_rst_n                    (i_hqm_sip_rf_dir_rofrag_cnt_rclk_rst_n),
       .rf_dir_rofrag_cnt_re                            (i_hqm_sip_rf_dir_rofrag_cnt_re),
       .rf_dir_rofrag_cnt_raddr                         (i_hqm_sip_rf_dir_rofrag_cnt_raddr),
       .rf_dir_rofrag_cnt_rdata                         (i_hqm_qed_mem_rf_dir_rofrag_cnt_rdata),
       .rf_dir_rofrag_cnt_isol_en                       (i_hqm_sip_pgcb_isol_en),
       .rf_dir_rofrag_cnt_pwr_enable_b_in               (i_hqm_qed_mem_rf_dir_replay_tp_pwr_enable_b_out),
       .rf_dir_rofrag_cnt_pwr_enable_b_out              (i_hqm_qed_mem_rf_dir_rofrag_cnt_pwr_enable_b_out),
       .rf_dir_rofrag_hp_wclk                           (i_hqm_sip_rf_dir_rofrag_hp_wclk),
       .rf_dir_rofrag_hp_wclk_rst_n                     (i_hqm_sip_rf_dir_rofrag_hp_wclk_rst_n),
       .rf_dir_rofrag_hp_we                             (i_hqm_sip_rf_dir_rofrag_hp_we),
       .rf_dir_rofrag_hp_waddr                          (i_hqm_sip_rf_dir_rofrag_hp_waddr),
       .rf_dir_rofrag_hp_wdata                          (i_hqm_sip_rf_dir_rofrag_hp_wdata),
       .rf_dir_rofrag_hp_rclk                           (i_hqm_sip_rf_dir_rofrag_hp_rclk),
       .rf_dir_rofrag_hp_rclk_rst_n                     (i_hqm_sip_rf_dir_rofrag_hp_rclk_rst_n),
       .rf_dir_rofrag_hp_re                             (i_hqm_sip_rf_dir_rofrag_hp_re),
       .rf_dir_rofrag_hp_raddr                          (i_hqm_sip_rf_dir_rofrag_hp_raddr),
       .rf_dir_rofrag_hp_rdata                          (i_hqm_qed_mem_rf_dir_rofrag_hp_rdata),
       .rf_dir_rofrag_hp_isol_en                        (i_hqm_sip_pgcb_isol_en),
       .rf_dir_rofrag_hp_pwr_enable_b_in                (i_hqm_qed_mem_rf_dir_rofrag_cnt_pwr_enable_b_out),
       .rf_dir_rofrag_hp_pwr_enable_b_out               (i_hqm_qed_mem_rf_dir_rofrag_hp_pwr_enable_b_out),
       .rf_dir_rofrag_tp_wclk                           (i_hqm_sip_rf_dir_rofrag_tp_wclk),
       .rf_dir_rofrag_tp_wclk_rst_n                     (i_hqm_sip_rf_dir_rofrag_tp_wclk_rst_n),
       .rf_dir_rofrag_tp_we                             (i_hqm_sip_rf_dir_rofrag_tp_we),
       .rf_dir_rofrag_tp_waddr                          (i_hqm_sip_rf_dir_rofrag_tp_waddr),
       .rf_dir_rofrag_tp_wdata                          (i_hqm_sip_rf_dir_rofrag_tp_wdata),
       .rf_dir_rofrag_tp_rclk                           (i_hqm_sip_rf_dir_rofrag_tp_rclk),
       .rf_dir_rofrag_tp_rclk_rst_n                     (i_hqm_sip_rf_dir_rofrag_tp_rclk_rst_n),
       .rf_dir_rofrag_tp_re                             (i_hqm_sip_rf_dir_rofrag_tp_re),
       .rf_dir_rofrag_tp_raddr                          (i_hqm_sip_rf_dir_rofrag_tp_raddr),
       .rf_dir_rofrag_tp_rdata                          (i_hqm_qed_mem_rf_dir_rofrag_tp_rdata),
       .rf_dir_rofrag_tp_isol_en                        (i_hqm_sip_pgcb_isol_en),
       .rf_dir_rofrag_tp_pwr_enable_b_in                (i_hqm_qed_mem_rf_dir_rofrag_hp_pwr_enable_b_out),
       .rf_dir_rofrag_tp_pwr_enable_b_out               (i_hqm_qed_mem_rf_dir_rofrag_tp_pwr_enable_b_out),
       .rf_dir_tp_wclk                                  (i_hqm_sip_rf_dir_tp_wclk),
       .rf_dir_tp_wclk_rst_n                            (i_hqm_sip_rf_dir_tp_wclk_rst_n),
       .rf_dir_tp_we                                    (i_hqm_sip_rf_dir_tp_we),
       .rf_dir_tp_waddr                                 (i_hqm_sip_rf_dir_tp_waddr),
       .rf_dir_tp_wdata                                 (i_hqm_sip_rf_dir_tp_wdata),
       .rf_dir_tp_rclk                                  (i_hqm_sip_rf_dir_tp_rclk),
       .rf_dir_tp_rclk_rst_n                            (i_hqm_sip_rf_dir_tp_rclk_rst_n),
       .rf_dir_tp_re                                    (i_hqm_sip_rf_dir_tp_re),
       .rf_dir_tp_raddr                                 (i_hqm_sip_rf_dir_tp_raddr),
       .rf_dir_tp_rdata                                 (i_hqm_qed_mem_rf_dir_tp_rdata),
       .rf_dir_tp_isol_en                               (i_hqm_sip_pgcb_isol_en),
       .rf_dir_tp_pwr_enable_b_in                       (i_hqm_qed_mem_rf_dir_rofrag_tp_pwr_enable_b_out),
       .rf_dir_tp_pwr_enable_b_out                      (i_hqm_qed_mem_rf_dir_tp_pwr_enable_b_out),
       .rf_dp_dqed_wclk                                 (i_hqm_sip_rf_dp_dqed_wclk),
       .rf_dp_dqed_wclk_rst_n                           (i_hqm_sip_rf_dp_dqed_wclk_rst_n),
       .rf_dp_dqed_we                                   (i_hqm_sip_rf_dp_dqed_we),
       .rf_dp_dqed_waddr                                (i_hqm_sip_rf_dp_dqed_waddr),
       .rf_dp_dqed_wdata                                (i_hqm_sip_rf_dp_dqed_wdata),
       .rf_dp_dqed_rclk                                 (i_hqm_sip_rf_dp_dqed_rclk),
       .rf_dp_dqed_rclk_rst_n                           (i_hqm_sip_rf_dp_dqed_rclk_rst_n),
       .rf_dp_dqed_re                                   (i_hqm_sip_rf_dp_dqed_re),
       .rf_dp_dqed_raddr                                (i_hqm_sip_rf_dp_dqed_raddr),
       .rf_dp_dqed_rdata                                (i_hqm_qed_mem_rf_dp_dqed_rdata),
       .rf_dp_dqed_isol_en                              (i_hqm_sip_pgcb_isol_en),
       .rf_dp_dqed_pwr_enable_b_in                      (i_hqm_qed_mem_rf_dir_tp_pwr_enable_b_out),
       .rf_dp_dqed_pwr_enable_b_out                     (i_hqm_qed_mem_rf_dp_dqed_pwr_enable_b_out),
       .rf_dp_lsp_enq_dir_wclk                          (i_hqm_sip_rf_dp_lsp_enq_dir_wclk),
       .rf_dp_lsp_enq_dir_wclk_rst_n                    (i_hqm_sip_rf_dp_lsp_enq_dir_wclk_rst_n),
       .rf_dp_lsp_enq_dir_we                            (i_hqm_sip_rf_dp_lsp_enq_dir_we),
       .rf_dp_lsp_enq_dir_waddr                         (i_hqm_sip_rf_dp_lsp_enq_dir_waddr),
       .rf_dp_lsp_enq_dir_wdata                         (i_hqm_sip_rf_dp_lsp_enq_dir_wdata),
       .rf_dp_lsp_enq_dir_rclk                          (i_hqm_sip_rf_dp_lsp_enq_dir_rclk),
       .rf_dp_lsp_enq_dir_rclk_rst_n                    (i_hqm_sip_rf_dp_lsp_enq_dir_rclk_rst_n),
       .rf_dp_lsp_enq_dir_re                            (i_hqm_sip_rf_dp_lsp_enq_dir_re),
       .rf_dp_lsp_enq_dir_raddr                         (i_hqm_sip_rf_dp_lsp_enq_dir_raddr),
       .rf_dp_lsp_enq_dir_rdata                         (i_hqm_qed_mem_rf_dp_lsp_enq_dir_rdata),
       .rf_dp_lsp_enq_dir_isol_en                       (i_hqm_sip_pgcb_isol_en),
       .rf_dp_lsp_enq_dir_pwr_enable_b_in               (i_hqm_qed_mem_rf_dp_dqed_pwr_enable_b_out),
       .rf_dp_lsp_enq_dir_pwr_enable_b_out              (i_hqm_qed_mem_rf_dp_lsp_enq_dir_pwr_enable_b_out),
       .rf_dp_lsp_enq_rorply_wclk                       (i_hqm_sip_rf_dp_lsp_enq_rorply_wclk),
       .rf_dp_lsp_enq_rorply_wclk_rst_n                 (i_hqm_sip_rf_dp_lsp_enq_rorply_wclk_rst_n),
       .rf_dp_lsp_enq_rorply_we                         (i_hqm_sip_rf_dp_lsp_enq_rorply_we),
       .rf_dp_lsp_enq_rorply_waddr                      (i_hqm_sip_rf_dp_lsp_enq_rorply_waddr),
       .rf_dp_lsp_enq_rorply_wdata                      (i_hqm_sip_rf_dp_lsp_enq_rorply_wdata),
       .rf_dp_lsp_enq_rorply_rclk                       (i_hqm_sip_rf_dp_lsp_enq_rorply_rclk),
       .rf_dp_lsp_enq_rorply_rclk_rst_n                 (i_hqm_sip_rf_dp_lsp_enq_rorply_rclk_rst_n),
       .rf_dp_lsp_enq_rorply_re                         (i_hqm_sip_rf_dp_lsp_enq_rorply_re),
       .rf_dp_lsp_enq_rorply_raddr                      (i_hqm_sip_rf_dp_lsp_enq_rorply_raddr),
       .rf_dp_lsp_enq_rorply_rdata                      (i_hqm_qed_mem_rf_dp_lsp_enq_rorply_rdata),
       .rf_dp_lsp_enq_rorply_isol_en                    (i_hqm_sip_pgcb_isol_en),
       .rf_dp_lsp_enq_rorply_pwr_enable_b_in            (i_hqm_qed_mem_rf_dp_lsp_enq_dir_pwr_enable_b_out),
       .rf_dp_lsp_enq_rorply_pwr_enable_b_out           (i_hqm_qed_mem_rf_dp_lsp_enq_rorply_pwr_enable_b_out),
       .rf_lsp_dp_sch_dir_wclk                          (i_hqm_sip_rf_lsp_dp_sch_dir_wclk),
       .rf_lsp_dp_sch_dir_wclk_rst_n                    (i_hqm_sip_rf_lsp_dp_sch_dir_wclk_rst_n),
       .rf_lsp_dp_sch_dir_we                            (i_hqm_sip_rf_lsp_dp_sch_dir_we),
       .rf_lsp_dp_sch_dir_waddr                         (i_hqm_sip_rf_lsp_dp_sch_dir_waddr),
       .rf_lsp_dp_sch_dir_wdata                         (i_hqm_sip_rf_lsp_dp_sch_dir_wdata),
       .rf_lsp_dp_sch_dir_rclk                          (i_hqm_sip_rf_lsp_dp_sch_dir_rclk),
       .rf_lsp_dp_sch_dir_rclk_rst_n                    (i_hqm_sip_rf_lsp_dp_sch_dir_rclk_rst_n),
       .rf_lsp_dp_sch_dir_re                            (i_hqm_sip_rf_lsp_dp_sch_dir_re),
       .rf_lsp_dp_sch_dir_raddr                         (i_hqm_sip_rf_lsp_dp_sch_dir_raddr),
       .rf_lsp_dp_sch_dir_rdata                         (i_hqm_qed_mem_rf_lsp_dp_sch_dir_rdata),
       .rf_lsp_dp_sch_dir_isol_en                       (i_hqm_sip_pgcb_isol_en),
       .rf_lsp_dp_sch_dir_pwr_enable_b_in               (i_hqm_qed_mem_rf_dp_lsp_enq_rorply_pwr_enable_b_out),
       .rf_lsp_dp_sch_dir_pwr_enable_b_out              (i_hqm_qed_mem_rf_lsp_dp_sch_dir_pwr_enable_b_out),
       .rf_lsp_dp_sch_rorply_wclk                       (i_hqm_sip_rf_lsp_dp_sch_rorply_wclk),
       .rf_lsp_dp_sch_rorply_wclk_rst_n                 (i_hqm_sip_rf_lsp_dp_sch_rorply_wclk_rst_n),
       .rf_lsp_dp_sch_rorply_we                         (i_hqm_sip_rf_lsp_dp_sch_rorply_we),
       .rf_lsp_dp_sch_rorply_waddr                      (i_hqm_sip_rf_lsp_dp_sch_rorply_waddr),
       .rf_lsp_dp_sch_rorply_wdata                      (i_hqm_sip_rf_lsp_dp_sch_rorply_wdata),
       .rf_lsp_dp_sch_rorply_rclk                       (i_hqm_sip_rf_lsp_dp_sch_rorply_rclk),
       .rf_lsp_dp_sch_rorply_rclk_rst_n                 (i_hqm_sip_rf_lsp_dp_sch_rorply_rclk_rst_n),
       .rf_lsp_dp_sch_rorply_re                         (i_hqm_sip_rf_lsp_dp_sch_rorply_re),
       .rf_lsp_dp_sch_rorply_raddr                      (i_hqm_sip_rf_lsp_dp_sch_rorply_raddr),
       .rf_lsp_dp_sch_rorply_rdata                      (i_hqm_qed_mem_rf_lsp_dp_sch_rorply_rdata),
       .rf_lsp_dp_sch_rorply_isol_en                    (i_hqm_sip_pgcb_isol_en),
       .rf_lsp_dp_sch_rorply_pwr_enable_b_in            (i_hqm_qed_mem_rf_lsp_dp_sch_dir_pwr_enable_b_out),
       .rf_lsp_dp_sch_rorply_pwr_enable_b_out           (i_hqm_qed_mem_rf_lsp_dp_sch_rorply_pwr_enable_b_out),
       .rf_lsp_nalb_sch_atq_wclk                        (i_hqm_sip_rf_lsp_nalb_sch_atq_wclk),
       .rf_lsp_nalb_sch_atq_wclk_rst_n                  (i_hqm_sip_rf_lsp_nalb_sch_atq_wclk_rst_n),
       .rf_lsp_nalb_sch_atq_we                          (i_hqm_sip_rf_lsp_nalb_sch_atq_we),
       .rf_lsp_nalb_sch_atq_waddr                       (i_hqm_sip_rf_lsp_nalb_sch_atq_waddr),
       .rf_lsp_nalb_sch_atq_wdata                       (i_hqm_sip_rf_lsp_nalb_sch_atq_wdata),
       .rf_lsp_nalb_sch_atq_rclk                        (i_hqm_sip_rf_lsp_nalb_sch_atq_rclk),
       .rf_lsp_nalb_sch_atq_rclk_rst_n                  (i_hqm_sip_rf_lsp_nalb_sch_atq_rclk_rst_n),
       .rf_lsp_nalb_sch_atq_re                          (i_hqm_sip_rf_lsp_nalb_sch_atq_re),
       .rf_lsp_nalb_sch_atq_raddr                       (i_hqm_sip_rf_lsp_nalb_sch_atq_raddr),
       .rf_lsp_nalb_sch_atq_rdata                       (i_hqm_qed_mem_rf_lsp_nalb_sch_atq_rdata),
       .rf_lsp_nalb_sch_atq_isol_en                     (i_hqm_sip_pgcb_isol_en),
       .rf_lsp_nalb_sch_atq_pwr_enable_b_in             (i_hqm_qed_mem_rf_lsp_dp_sch_rorply_pwr_enable_b_out),
       .rf_lsp_nalb_sch_atq_pwr_enable_b_out            (i_hqm_qed_mem_rf_lsp_nalb_sch_atq_pwr_enable_b_out),
       .rf_lsp_nalb_sch_rorply_wclk                     (i_hqm_sip_rf_lsp_nalb_sch_rorply_wclk),
       .rf_lsp_nalb_sch_rorply_wclk_rst_n               (i_hqm_sip_rf_lsp_nalb_sch_rorply_wclk_rst_n),
       .rf_lsp_nalb_sch_rorply_we                       (i_hqm_sip_rf_lsp_nalb_sch_rorply_we),
       .rf_lsp_nalb_sch_rorply_waddr                    (i_hqm_sip_rf_lsp_nalb_sch_rorply_waddr),
       .rf_lsp_nalb_sch_rorply_wdata                    (i_hqm_sip_rf_lsp_nalb_sch_rorply_wdata),
       .rf_lsp_nalb_sch_rorply_rclk                     (i_hqm_sip_rf_lsp_nalb_sch_rorply_rclk),
       .rf_lsp_nalb_sch_rorply_rclk_rst_n               (i_hqm_sip_rf_lsp_nalb_sch_rorply_rclk_rst_n),
       .rf_lsp_nalb_sch_rorply_re                       (i_hqm_sip_rf_lsp_nalb_sch_rorply_re),
       .rf_lsp_nalb_sch_rorply_raddr                    (i_hqm_sip_rf_lsp_nalb_sch_rorply_raddr),
       .rf_lsp_nalb_sch_rorply_rdata                    (i_hqm_qed_mem_rf_lsp_nalb_sch_rorply_rdata),
       .rf_lsp_nalb_sch_rorply_isol_en                  (i_hqm_sip_pgcb_isol_en),
       .rf_lsp_nalb_sch_rorply_pwr_enable_b_in          (i_hqm_qed_mem_rf_lsp_nalb_sch_atq_pwr_enable_b_out),
       .rf_lsp_nalb_sch_rorply_pwr_enable_b_out         (i_hqm_qed_mem_rf_lsp_nalb_sch_rorply_pwr_enable_b_out),
       .rf_lsp_nalb_sch_unoord_wclk                     (i_hqm_sip_rf_lsp_nalb_sch_unoord_wclk),
       .rf_lsp_nalb_sch_unoord_wclk_rst_n               (i_hqm_sip_rf_lsp_nalb_sch_unoord_wclk_rst_n),
       .rf_lsp_nalb_sch_unoord_we                       (i_hqm_sip_rf_lsp_nalb_sch_unoord_we),
       .rf_lsp_nalb_sch_unoord_waddr                    (i_hqm_sip_rf_lsp_nalb_sch_unoord_waddr),
       .rf_lsp_nalb_sch_unoord_wdata                    (i_hqm_sip_rf_lsp_nalb_sch_unoord_wdata),
       .rf_lsp_nalb_sch_unoord_rclk                     (i_hqm_sip_rf_lsp_nalb_sch_unoord_rclk),
       .rf_lsp_nalb_sch_unoord_rclk_rst_n               (i_hqm_sip_rf_lsp_nalb_sch_unoord_rclk_rst_n),
       .rf_lsp_nalb_sch_unoord_re                       (i_hqm_sip_rf_lsp_nalb_sch_unoord_re),
       .rf_lsp_nalb_sch_unoord_raddr                    (i_hqm_sip_rf_lsp_nalb_sch_unoord_raddr),
       .rf_lsp_nalb_sch_unoord_rdata                    (i_hqm_qed_mem_rf_lsp_nalb_sch_unoord_rdata),
       .rf_lsp_nalb_sch_unoord_isol_en                  (i_hqm_sip_pgcb_isol_en),
       .rf_lsp_nalb_sch_unoord_pwr_enable_b_in          (i_hqm_qed_mem_rf_lsp_nalb_sch_rorply_pwr_enable_b_out),
       .rf_lsp_nalb_sch_unoord_pwr_enable_b_out         (i_hqm_qed_mem_rf_lsp_nalb_sch_unoord_pwr_enable_b_out),
       .rf_nalb_cnt_wclk                                (i_hqm_sip_rf_nalb_cnt_wclk),
       .rf_nalb_cnt_wclk_rst_n                          (i_hqm_sip_rf_nalb_cnt_wclk_rst_n),
       .rf_nalb_cnt_we                                  (i_hqm_sip_rf_nalb_cnt_we),
       .rf_nalb_cnt_waddr                               (i_hqm_sip_rf_nalb_cnt_waddr),
       .rf_nalb_cnt_wdata                               (i_hqm_sip_rf_nalb_cnt_wdata),
       .rf_nalb_cnt_rclk                                (i_hqm_sip_rf_nalb_cnt_rclk),
       .rf_nalb_cnt_rclk_rst_n                          (i_hqm_sip_rf_nalb_cnt_rclk_rst_n),
       .rf_nalb_cnt_re                                  (i_hqm_sip_rf_nalb_cnt_re),
       .rf_nalb_cnt_raddr                               (i_hqm_sip_rf_nalb_cnt_raddr),
       .rf_nalb_cnt_rdata                               (i_hqm_qed_mem_rf_nalb_cnt_rdata),
       .rf_nalb_cnt_isol_en                             (i_hqm_sip_pgcb_isol_en),
       .rf_nalb_cnt_pwr_enable_b_in                     (i_hqm_qed_mem_rf_lsp_nalb_sch_unoord_pwr_enable_b_out),
       .rf_nalb_cnt_pwr_enable_b_out                    (i_hqm_qed_mem_rf_nalb_cnt_pwr_enable_b_out),
       .rf_nalb_hp_wclk                                 (i_hqm_sip_rf_nalb_hp_wclk),
       .rf_nalb_hp_wclk_rst_n                           (i_hqm_sip_rf_nalb_hp_wclk_rst_n),
       .rf_nalb_hp_we                                   (i_hqm_sip_rf_nalb_hp_we),
       .rf_nalb_hp_waddr                                (i_hqm_sip_rf_nalb_hp_waddr),
       .rf_nalb_hp_wdata                                (i_hqm_sip_rf_nalb_hp_wdata),
       .rf_nalb_hp_rclk                                 (i_hqm_sip_rf_nalb_hp_rclk),
       .rf_nalb_hp_rclk_rst_n                           (i_hqm_sip_rf_nalb_hp_rclk_rst_n),
       .rf_nalb_hp_re                                   (i_hqm_sip_rf_nalb_hp_re),
       .rf_nalb_hp_raddr                                (i_hqm_sip_rf_nalb_hp_raddr),
       .rf_nalb_hp_rdata                                (i_hqm_qed_mem_rf_nalb_hp_rdata),
       .rf_nalb_hp_isol_en                              (i_hqm_sip_pgcb_isol_en),
       .rf_nalb_hp_pwr_enable_b_in                      (i_hqm_qed_mem_rf_nalb_cnt_pwr_enable_b_out),
       .rf_nalb_hp_pwr_enable_b_out                     (i_hqm_qed_mem_rf_nalb_hp_pwr_enable_b_out),
       .rf_nalb_lsp_enq_rorply_wclk                     (i_hqm_sip_rf_nalb_lsp_enq_rorply_wclk),
       .rf_nalb_lsp_enq_rorply_wclk_rst_n               (i_hqm_sip_rf_nalb_lsp_enq_rorply_wclk_rst_n),
       .rf_nalb_lsp_enq_rorply_we                       (i_hqm_sip_rf_nalb_lsp_enq_rorply_we),
       .rf_nalb_lsp_enq_rorply_waddr                    (i_hqm_sip_rf_nalb_lsp_enq_rorply_waddr),
       .rf_nalb_lsp_enq_rorply_wdata                    (i_hqm_sip_rf_nalb_lsp_enq_rorply_wdata),
       .rf_nalb_lsp_enq_rorply_rclk                     (i_hqm_sip_rf_nalb_lsp_enq_rorply_rclk),
       .rf_nalb_lsp_enq_rorply_rclk_rst_n               (i_hqm_sip_rf_nalb_lsp_enq_rorply_rclk_rst_n),
       .rf_nalb_lsp_enq_rorply_re                       (i_hqm_sip_rf_nalb_lsp_enq_rorply_re),
       .rf_nalb_lsp_enq_rorply_raddr                    (i_hqm_sip_rf_nalb_lsp_enq_rorply_raddr),
       .rf_nalb_lsp_enq_rorply_rdata                    (i_hqm_qed_mem_rf_nalb_lsp_enq_rorply_rdata),
       .rf_nalb_lsp_enq_rorply_isol_en                  (i_hqm_sip_pgcb_isol_en),
       .rf_nalb_lsp_enq_rorply_pwr_enable_b_in          (i_hqm_qed_mem_rf_nalb_hp_pwr_enable_b_out),
       .rf_nalb_lsp_enq_rorply_pwr_enable_b_out         (i_hqm_qed_mem_rf_nalb_lsp_enq_rorply_pwr_enable_b_out),
       .rf_nalb_lsp_enq_unoord_wclk                     (i_hqm_sip_rf_nalb_lsp_enq_unoord_wclk),
       .rf_nalb_lsp_enq_unoord_wclk_rst_n               (i_hqm_sip_rf_nalb_lsp_enq_unoord_wclk_rst_n),
       .rf_nalb_lsp_enq_unoord_we                       (i_hqm_sip_rf_nalb_lsp_enq_unoord_we),
       .rf_nalb_lsp_enq_unoord_waddr                    (i_hqm_sip_rf_nalb_lsp_enq_unoord_waddr),
       .rf_nalb_lsp_enq_unoord_wdata                    (i_hqm_sip_rf_nalb_lsp_enq_unoord_wdata),
       .rf_nalb_lsp_enq_unoord_rclk                     (i_hqm_sip_rf_nalb_lsp_enq_unoord_rclk),
       .rf_nalb_lsp_enq_unoord_rclk_rst_n               (i_hqm_sip_rf_nalb_lsp_enq_unoord_rclk_rst_n),
       .rf_nalb_lsp_enq_unoord_re                       (i_hqm_sip_rf_nalb_lsp_enq_unoord_re),
       .rf_nalb_lsp_enq_unoord_raddr                    (i_hqm_sip_rf_nalb_lsp_enq_unoord_raddr),
       .rf_nalb_lsp_enq_unoord_rdata                    (i_hqm_qed_mem_rf_nalb_lsp_enq_unoord_rdata),
       .rf_nalb_lsp_enq_unoord_isol_en                  (i_hqm_sip_pgcb_isol_en),
       .rf_nalb_lsp_enq_unoord_pwr_enable_b_in          (i_hqm_qed_mem_rf_nalb_lsp_enq_rorply_pwr_enable_b_out),
       .rf_nalb_lsp_enq_unoord_pwr_enable_b_out         (i_hqm_qed_mem_rf_nalb_lsp_enq_unoord_pwr_enable_b_out),
       .rf_nalb_qed_wclk                                (i_hqm_sip_rf_nalb_qed_wclk),
       .rf_nalb_qed_wclk_rst_n                          (i_hqm_sip_rf_nalb_qed_wclk_rst_n),
       .rf_nalb_qed_we                                  (i_hqm_sip_rf_nalb_qed_we),
       .rf_nalb_qed_waddr                               (i_hqm_sip_rf_nalb_qed_waddr),
       .rf_nalb_qed_wdata                               (i_hqm_sip_rf_nalb_qed_wdata),
       .rf_nalb_qed_rclk                                (i_hqm_sip_rf_nalb_qed_rclk),
       .rf_nalb_qed_rclk_rst_n                          (i_hqm_sip_rf_nalb_qed_rclk_rst_n),
       .rf_nalb_qed_re                                  (i_hqm_sip_rf_nalb_qed_re),
       .rf_nalb_qed_raddr                               (i_hqm_sip_rf_nalb_qed_raddr),
       .rf_nalb_qed_rdata                               (i_hqm_qed_mem_rf_nalb_qed_rdata),
       .rf_nalb_qed_isol_en                             (i_hqm_sip_pgcb_isol_en),
       .rf_nalb_qed_pwr_enable_b_in                     (i_hqm_qed_mem_rf_nalb_lsp_enq_unoord_pwr_enable_b_out),
       .rf_nalb_qed_pwr_enable_b_out                    (i_hqm_qed_mem_rf_nalb_qed_pwr_enable_b_out),
       .rf_nalb_replay_cnt_wclk                         (i_hqm_sip_rf_nalb_replay_cnt_wclk),
       .rf_nalb_replay_cnt_wclk_rst_n                   (i_hqm_sip_rf_nalb_replay_cnt_wclk_rst_n),
       .rf_nalb_replay_cnt_we                           (i_hqm_sip_rf_nalb_replay_cnt_we),
       .rf_nalb_replay_cnt_waddr                        (i_hqm_sip_rf_nalb_replay_cnt_waddr),
       .rf_nalb_replay_cnt_wdata                        (i_hqm_sip_rf_nalb_replay_cnt_wdata),
       .rf_nalb_replay_cnt_rclk                         (i_hqm_sip_rf_nalb_replay_cnt_rclk),
       .rf_nalb_replay_cnt_rclk_rst_n                   (i_hqm_sip_rf_nalb_replay_cnt_rclk_rst_n),
       .rf_nalb_replay_cnt_re                           (i_hqm_sip_rf_nalb_replay_cnt_re),
       .rf_nalb_replay_cnt_raddr                        (i_hqm_sip_rf_nalb_replay_cnt_raddr),
       .rf_nalb_replay_cnt_rdata                        (i_hqm_qed_mem_rf_nalb_replay_cnt_rdata),
       .rf_nalb_replay_cnt_isol_en                      (i_hqm_sip_pgcb_isol_en),
       .rf_nalb_replay_cnt_pwr_enable_b_in              (i_hqm_qed_mem_rf_nalb_qed_pwr_enable_b_out),
       .rf_nalb_replay_cnt_pwr_enable_b_out             (i_hqm_qed_mem_rf_nalb_replay_cnt_pwr_enable_b_out),
       .rf_nalb_replay_hp_wclk                          (i_hqm_sip_rf_nalb_replay_hp_wclk),
       .rf_nalb_replay_hp_wclk_rst_n                    (i_hqm_sip_rf_nalb_replay_hp_wclk_rst_n),
       .rf_nalb_replay_hp_we                            (i_hqm_sip_rf_nalb_replay_hp_we),
       .rf_nalb_replay_hp_waddr                         (i_hqm_sip_rf_nalb_replay_hp_waddr),
       .rf_nalb_replay_hp_wdata                         (i_hqm_sip_rf_nalb_replay_hp_wdata),
       .rf_nalb_replay_hp_rclk                          (i_hqm_sip_rf_nalb_replay_hp_rclk),
       .rf_nalb_replay_hp_rclk_rst_n                    (i_hqm_sip_rf_nalb_replay_hp_rclk_rst_n),
       .rf_nalb_replay_hp_re                            (i_hqm_sip_rf_nalb_replay_hp_re),
       .rf_nalb_replay_hp_raddr                         (i_hqm_sip_rf_nalb_replay_hp_raddr),
       .rf_nalb_replay_hp_rdata                         (i_hqm_qed_mem_rf_nalb_replay_hp_rdata),
       .rf_nalb_replay_hp_isol_en                       (i_hqm_sip_pgcb_isol_en),
       .rf_nalb_replay_hp_pwr_enable_b_in               (i_hqm_qed_mem_rf_nalb_replay_cnt_pwr_enable_b_out),
       .rf_nalb_replay_hp_pwr_enable_b_out              (i_hqm_qed_mem_rf_nalb_replay_hp_pwr_enable_b_out),
       .rf_nalb_replay_tp_wclk                          (i_hqm_sip_rf_nalb_replay_tp_wclk),
       .rf_nalb_replay_tp_wclk_rst_n                    (i_hqm_sip_rf_nalb_replay_tp_wclk_rst_n),
       .rf_nalb_replay_tp_we                            (i_hqm_sip_rf_nalb_replay_tp_we),
       .rf_nalb_replay_tp_waddr                         (i_hqm_sip_rf_nalb_replay_tp_waddr),
       .rf_nalb_replay_tp_wdata                         (i_hqm_sip_rf_nalb_replay_tp_wdata),
       .rf_nalb_replay_tp_rclk                          (i_hqm_sip_rf_nalb_replay_tp_rclk),
       .rf_nalb_replay_tp_rclk_rst_n                    (i_hqm_sip_rf_nalb_replay_tp_rclk_rst_n),
       .rf_nalb_replay_tp_re                            (i_hqm_sip_rf_nalb_replay_tp_re),
       .rf_nalb_replay_tp_raddr                         (i_hqm_sip_rf_nalb_replay_tp_raddr),
       .rf_nalb_replay_tp_rdata                         (i_hqm_qed_mem_rf_nalb_replay_tp_rdata),
       .rf_nalb_replay_tp_isol_en                       (i_hqm_sip_pgcb_isol_en),
       .rf_nalb_replay_tp_pwr_enable_b_in               (i_hqm_qed_mem_rf_nalb_replay_hp_pwr_enable_b_out),
       .rf_nalb_replay_tp_pwr_enable_b_out              (i_hqm_qed_mem_rf_nalb_replay_tp_pwr_enable_b_out),
       .rf_nalb_rofrag_cnt_wclk                         (i_hqm_sip_rf_nalb_rofrag_cnt_wclk),
       .rf_nalb_rofrag_cnt_wclk_rst_n                   (i_hqm_sip_rf_nalb_rofrag_cnt_wclk_rst_n),
       .rf_nalb_rofrag_cnt_we                           (i_hqm_sip_rf_nalb_rofrag_cnt_we),
       .rf_nalb_rofrag_cnt_waddr                        (i_hqm_sip_rf_nalb_rofrag_cnt_waddr),
       .rf_nalb_rofrag_cnt_wdata                        (i_hqm_sip_rf_nalb_rofrag_cnt_wdata),
       .rf_nalb_rofrag_cnt_rclk                         (i_hqm_sip_rf_nalb_rofrag_cnt_rclk),
       .rf_nalb_rofrag_cnt_rclk_rst_n                   (i_hqm_sip_rf_nalb_rofrag_cnt_rclk_rst_n),
       .rf_nalb_rofrag_cnt_re                           (i_hqm_sip_rf_nalb_rofrag_cnt_re),
       .rf_nalb_rofrag_cnt_raddr                        (i_hqm_sip_rf_nalb_rofrag_cnt_raddr),
       .rf_nalb_rofrag_cnt_rdata                        (i_hqm_qed_mem_rf_nalb_rofrag_cnt_rdata),
       .rf_nalb_rofrag_cnt_isol_en                      (i_hqm_sip_pgcb_isol_en),
       .rf_nalb_rofrag_cnt_pwr_enable_b_in              (i_hqm_qed_mem_rf_nalb_replay_tp_pwr_enable_b_out),
       .rf_nalb_rofrag_cnt_pwr_enable_b_out             (i_hqm_qed_mem_rf_nalb_rofrag_cnt_pwr_enable_b_out),
       .rf_nalb_rofrag_hp_wclk                          (i_hqm_sip_rf_nalb_rofrag_hp_wclk),
       .rf_nalb_rofrag_hp_wclk_rst_n                    (i_hqm_sip_rf_nalb_rofrag_hp_wclk_rst_n),
       .rf_nalb_rofrag_hp_we                            (i_hqm_sip_rf_nalb_rofrag_hp_we),
       .rf_nalb_rofrag_hp_waddr                         (i_hqm_sip_rf_nalb_rofrag_hp_waddr),
       .rf_nalb_rofrag_hp_wdata                         (i_hqm_sip_rf_nalb_rofrag_hp_wdata),
       .rf_nalb_rofrag_hp_rclk                          (i_hqm_sip_rf_nalb_rofrag_hp_rclk),
       .rf_nalb_rofrag_hp_rclk_rst_n                    (i_hqm_sip_rf_nalb_rofrag_hp_rclk_rst_n),
       .rf_nalb_rofrag_hp_re                            (i_hqm_sip_rf_nalb_rofrag_hp_re),
       .rf_nalb_rofrag_hp_raddr                         (i_hqm_sip_rf_nalb_rofrag_hp_raddr),
       .rf_nalb_rofrag_hp_rdata                         (i_hqm_qed_mem_rf_nalb_rofrag_hp_rdata),
       .rf_nalb_rofrag_hp_isol_en                       (i_hqm_sip_pgcb_isol_en),
       .rf_nalb_rofrag_hp_pwr_enable_b_in               (i_hqm_qed_mem_rf_nalb_rofrag_cnt_pwr_enable_b_out),
       .rf_nalb_rofrag_hp_pwr_enable_b_out              (i_hqm_qed_mem_rf_nalb_rofrag_hp_pwr_enable_b_out),
       .rf_nalb_rofrag_tp_wclk                          (i_hqm_sip_rf_nalb_rofrag_tp_wclk),
       .rf_nalb_rofrag_tp_wclk_rst_n                    (i_hqm_sip_rf_nalb_rofrag_tp_wclk_rst_n),
       .rf_nalb_rofrag_tp_we                            (i_hqm_sip_rf_nalb_rofrag_tp_we),
       .rf_nalb_rofrag_tp_waddr                         (i_hqm_sip_rf_nalb_rofrag_tp_waddr),
       .rf_nalb_rofrag_tp_wdata                         (i_hqm_sip_rf_nalb_rofrag_tp_wdata),
       .rf_nalb_rofrag_tp_rclk                          (i_hqm_sip_rf_nalb_rofrag_tp_rclk),
       .rf_nalb_rofrag_tp_rclk_rst_n                    (i_hqm_sip_rf_nalb_rofrag_tp_rclk_rst_n),
       .rf_nalb_rofrag_tp_re                            (i_hqm_sip_rf_nalb_rofrag_tp_re),
       .rf_nalb_rofrag_tp_raddr                         (i_hqm_sip_rf_nalb_rofrag_tp_raddr),
       .rf_nalb_rofrag_tp_rdata                         (i_hqm_qed_mem_rf_nalb_rofrag_tp_rdata),
       .rf_nalb_rofrag_tp_isol_en                       (i_hqm_sip_pgcb_isol_en),
       .rf_nalb_rofrag_tp_pwr_enable_b_in               (i_hqm_qed_mem_rf_nalb_rofrag_hp_pwr_enable_b_out),
       .rf_nalb_rofrag_tp_pwr_enable_b_out              (i_hqm_qed_mem_rf_nalb_rofrag_tp_pwr_enable_b_out),
       .rf_nalb_tp_wclk                                 (i_hqm_sip_rf_nalb_tp_wclk),
       .rf_nalb_tp_wclk_rst_n                           (i_hqm_sip_rf_nalb_tp_wclk_rst_n),
       .rf_nalb_tp_we                                   (i_hqm_sip_rf_nalb_tp_we),
       .rf_nalb_tp_waddr                                (i_hqm_sip_rf_nalb_tp_waddr),
       .rf_nalb_tp_wdata                                (i_hqm_sip_rf_nalb_tp_wdata),
       .rf_nalb_tp_rclk                                 (i_hqm_sip_rf_nalb_tp_rclk),
       .rf_nalb_tp_rclk_rst_n                           (i_hqm_sip_rf_nalb_tp_rclk_rst_n),
       .rf_nalb_tp_re                                   (i_hqm_sip_rf_nalb_tp_re),
       .rf_nalb_tp_raddr                                (i_hqm_sip_rf_nalb_tp_raddr),
       .rf_nalb_tp_rdata                                (i_hqm_qed_mem_rf_nalb_tp_rdata),
       .rf_nalb_tp_isol_en                              (i_hqm_sip_pgcb_isol_en),
       .rf_nalb_tp_pwr_enable_b_in                      (i_hqm_qed_mem_rf_nalb_rofrag_tp_pwr_enable_b_out),
       .rf_nalb_tp_pwr_enable_b_out                     (i_hqm_qed_mem_rf_nalb_tp_pwr_enable_b_out),
       .rf_qed_chp_sch_data_wclk                        (i_hqm_sip_rf_qed_chp_sch_data_wclk),
       .rf_qed_chp_sch_data_wclk_rst_n                  (i_hqm_sip_rf_qed_chp_sch_data_wclk_rst_n),
       .rf_qed_chp_sch_data_we                          (i_hqm_sip_rf_qed_chp_sch_data_we),
       .rf_qed_chp_sch_data_waddr                       (i_hqm_sip_rf_qed_chp_sch_data_waddr),
       .rf_qed_chp_sch_data_wdata                       (i_hqm_sip_rf_qed_chp_sch_data_wdata),
       .rf_qed_chp_sch_data_rclk                        (i_hqm_sip_rf_qed_chp_sch_data_rclk),
       .rf_qed_chp_sch_data_rclk_rst_n                  (i_hqm_sip_rf_qed_chp_sch_data_rclk_rst_n),
       .rf_qed_chp_sch_data_re                          (i_hqm_sip_rf_qed_chp_sch_data_re),
       .rf_qed_chp_sch_data_raddr                       (i_hqm_sip_rf_qed_chp_sch_data_raddr),
       .rf_qed_chp_sch_data_rdata                       (i_hqm_qed_mem_rf_qed_chp_sch_data_rdata),
       .rf_qed_chp_sch_data_isol_en                     (i_hqm_sip_pgcb_isol_en),
       .rf_qed_chp_sch_data_pwr_enable_b_in             (i_hqm_qed_mem_rf_nalb_tp_pwr_enable_b_out),
       .rf_qed_chp_sch_data_pwr_enable_b_out            (i_hqm_qed_mem_rf_qed_chp_sch_data_pwr_enable_b_out),
       .rf_rop_dp_enq_dir_wclk                          (i_hqm_sip_rf_rop_dp_enq_dir_wclk),
       .rf_rop_dp_enq_dir_wclk_rst_n                    (i_hqm_sip_rf_rop_dp_enq_dir_wclk_rst_n),
       .rf_rop_dp_enq_dir_we                            (i_hqm_sip_rf_rop_dp_enq_dir_we),
       .rf_rop_dp_enq_dir_waddr                         (i_hqm_sip_rf_rop_dp_enq_dir_waddr),
       .rf_rop_dp_enq_dir_wdata                         (i_hqm_sip_rf_rop_dp_enq_dir_wdata),
       .rf_rop_dp_enq_dir_rclk                          (i_hqm_sip_rf_rop_dp_enq_dir_rclk),
       .rf_rop_dp_enq_dir_rclk_rst_n                    (i_hqm_sip_rf_rop_dp_enq_dir_rclk_rst_n),
       .rf_rop_dp_enq_dir_re                            (i_hqm_sip_rf_rop_dp_enq_dir_re),
       .rf_rop_dp_enq_dir_raddr                         (i_hqm_sip_rf_rop_dp_enq_dir_raddr),
       .rf_rop_dp_enq_dir_rdata                         (i_hqm_qed_mem_rf_rop_dp_enq_dir_rdata),
       .rf_rop_dp_enq_dir_isol_en                       (i_hqm_sip_pgcb_isol_en),
       .rf_rop_dp_enq_dir_pwr_enable_b_in               (i_hqm_qed_mem_rf_qed_chp_sch_data_pwr_enable_b_out),
       .rf_rop_dp_enq_dir_pwr_enable_b_out              (i_hqm_qed_mem_rf_rop_dp_enq_dir_pwr_enable_b_out),
       .rf_rop_dp_enq_ro_wclk                           (i_hqm_sip_rf_rop_dp_enq_ro_wclk),
       .rf_rop_dp_enq_ro_wclk_rst_n                     (i_hqm_sip_rf_rop_dp_enq_ro_wclk_rst_n),
       .rf_rop_dp_enq_ro_we                             (i_hqm_sip_rf_rop_dp_enq_ro_we),
       .rf_rop_dp_enq_ro_waddr                          (i_hqm_sip_rf_rop_dp_enq_ro_waddr),
       .rf_rop_dp_enq_ro_wdata                          (i_hqm_sip_rf_rop_dp_enq_ro_wdata),
       .rf_rop_dp_enq_ro_rclk                           (i_hqm_sip_rf_rop_dp_enq_ro_rclk),
       .rf_rop_dp_enq_ro_rclk_rst_n                     (i_hqm_sip_rf_rop_dp_enq_ro_rclk_rst_n),
       .rf_rop_dp_enq_ro_re                             (i_hqm_sip_rf_rop_dp_enq_ro_re),
       .rf_rop_dp_enq_ro_raddr                          (i_hqm_sip_rf_rop_dp_enq_ro_raddr),
       .rf_rop_dp_enq_ro_rdata                          (i_hqm_qed_mem_rf_rop_dp_enq_ro_rdata),
       .rf_rop_dp_enq_ro_isol_en                        (i_hqm_sip_pgcb_isol_en),
       .rf_rop_dp_enq_ro_pwr_enable_b_in                (i_hqm_qed_mem_rf_rop_dp_enq_dir_pwr_enable_b_out),
       .rf_rop_dp_enq_ro_pwr_enable_b_out               (i_hqm_qed_mem_rf_rop_dp_enq_ro_pwr_enable_b_out),
       .rf_rop_nalb_enq_ro_wclk                         (i_hqm_sip_rf_rop_nalb_enq_ro_wclk),
       .rf_rop_nalb_enq_ro_wclk_rst_n                   (i_hqm_sip_rf_rop_nalb_enq_ro_wclk_rst_n),
       .rf_rop_nalb_enq_ro_we                           (i_hqm_sip_rf_rop_nalb_enq_ro_we),
       .rf_rop_nalb_enq_ro_waddr                        (i_hqm_sip_rf_rop_nalb_enq_ro_waddr),
       .rf_rop_nalb_enq_ro_wdata                        (i_hqm_sip_rf_rop_nalb_enq_ro_wdata),
       .rf_rop_nalb_enq_ro_rclk                         (i_hqm_sip_rf_rop_nalb_enq_ro_rclk),
       .rf_rop_nalb_enq_ro_rclk_rst_n                   (i_hqm_sip_rf_rop_nalb_enq_ro_rclk_rst_n),
       .rf_rop_nalb_enq_ro_re                           (i_hqm_sip_rf_rop_nalb_enq_ro_re),
       .rf_rop_nalb_enq_ro_raddr                        (i_hqm_sip_rf_rop_nalb_enq_ro_raddr),
       .rf_rop_nalb_enq_ro_rdata                        (i_hqm_qed_mem_rf_rop_nalb_enq_ro_rdata),
       .rf_rop_nalb_enq_ro_isol_en                      (i_hqm_sip_pgcb_isol_en),
       .rf_rop_nalb_enq_ro_pwr_enable_b_in              (i_hqm_qed_mem_rf_rop_dp_enq_ro_pwr_enable_b_out),
       .rf_rop_nalb_enq_ro_pwr_enable_b_out             (i_hqm_qed_mem_rf_rop_nalb_enq_ro_pwr_enable_b_out),
       .rf_rop_nalb_enq_unoord_wclk                     (i_hqm_sip_rf_rop_nalb_enq_unoord_wclk),
       .rf_rop_nalb_enq_unoord_wclk_rst_n               (i_hqm_sip_rf_rop_nalb_enq_unoord_wclk_rst_n),
       .rf_rop_nalb_enq_unoord_we                       (i_hqm_sip_rf_rop_nalb_enq_unoord_we),
       .rf_rop_nalb_enq_unoord_waddr                    (i_hqm_sip_rf_rop_nalb_enq_unoord_waddr),
       .rf_rop_nalb_enq_unoord_wdata                    (i_hqm_sip_rf_rop_nalb_enq_unoord_wdata),
       .rf_rop_nalb_enq_unoord_rclk                     (i_hqm_sip_rf_rop_nalb_enq_unoord_rclk),
       .rf_rop_nalb_enq_unoord_rclk_rst_n               (i_hqm_sip_rf_rop_nalb_enq_unoord_rclk_rst_n),
       .rf_rop_nalb_enq_unoord_re                       (i_hqm_sip_rf_rop_nalb_enq_unoord_re),
       .rf_rop_nalb_enq_unoord_raddr                    (i_hqm_sip_rf_rop_nalb_enq_unoord_raddr),
       .rf_rop_nalb_enq_unoord_rdata                    (i_hqm_qed_mem_rf_rop_nalb_enq_unoord_rdata),
       .rf_rop_nalb_enq_unoord_isol_en                  (i_hqm_sip_pgcb_isol_en),
       .rf_rop_nalb_enq_unoord_pwr_enable_b_in          (i_hqm_qed_mem_rf_rop_nalb_enq_ro_pwr_enable_b_out),
       .rf_rop_nalb_enq_unoord_pwr_enable_b_out         (i_hqm_qed_mem_rf_rop_nalb_enq_unoord_pwr_enable_b_out),
       .rf_rx_sync_dp_dqed_data_wclk                    (i_hqm_sip_rf_rx_sync_dp_dqed_data_wclk),
       .rf_rx_sync_dp_dqed_data_wclk_rst_n              (i_hqm_sip_rf_rx_sync_dp_dqed_data_wclk_rst_n),
       .rf_rx_sync_dp_dqed_data_we                      (i_hqm_sip_rf_rx_sync_dp_dqed_data_we),
       .rf_rx_sync_dp_dqed_data_waddr                   (i_hqm_sip_rf_rx_sync_dp_dqed_data_waddr),
       .rf_rx_sync_dp_dqed_data_wdata                   (i_hqm_sip_rf_rx_sync_dp_dqed_data_wdata),
       .rf_rx_sync_dp_dqed_data_rclk                    (i_hqm_sip_rf_rx_sync_dp_dqed_data_rclk),
       .rf_rx_sync_dp_dqed_data_rclk_rst_n              (i_hqm_sip_rf_rx_sync_dp_dqed_data_rclk_rst_n),
       .rf_rx_sync_dp_dqed_data_re                      (i_hqm_sip_rf_rx_sync_dp_dqed_data_re),
       .rf_rx_sync_dp_dqed_data_raddr                   (i_hqm_sip_rf_rx_sync_dp_dqed_data_raddr),
       .rf_rx_sync_dp_dqed_data_rdata                   (i_hqm_qed_mem_rf_rx_sync_dp_dqed_data_rdata),
       .rf_rx_sync_dp_dqed_data_isol_en                 (i_hqm_sip_pgcb_isol_en),
       .rf_rx_sync_dp_dqed_data_pwr_enable_b_in         (i_hqm_qed_mem_rf_rop_nalb_enq_unoord_pwr_enable_b_out),
       .rf_rx_sync_dp_dqed_data_pwr_enable_b_out        (i_hqm_qed_mem_rf_rx_sync_dp_dqed_data_pwr_enable_b_out),
       .rf_rx_sync_lsp_dp_sch_dir_wclk                  (i_hqm_sip_rf_rx_sync_lsp_dp_sch_dir_wclk),
       .rf_rx_sync_lsp_dp_sch_dir_wclk_rst_n            (i_hqm_sip_rf_rx_sync_lsp_dp_sch_dir_wclk_rst_n),
       .rf_rx_sync_lsp_dp_sch_dir_we                    (i_hqm_sip_rf_rx_sync_lsp_dp_sch_dir_we),
       .rf_rx_sync_lsp_dp_sch_dir_waddr                 (i_hqm_sip_rf_rx_sync_lsp_dp_sch_dir_waddr),
       .rf_rx_sync_lsp_dp_sch_dir_wdata                 (i_hqm_sip_rf_rx_sync_lsp_dp_sch_dir_wdata),
       .rf_rx_sync_lsp_dp_sch_dir_rclk                  (i_hqm_sip_rf_rx_sync_lsp_dp_sch_dir_rclk),
       .rf_rx_sync_lsp_dp_sch_dir_rclk_rst_n            (i_hqm_sip_rf_rx_sync_lsp_dp_sch_dir_rclk_rst_n),
       .rf_rx_sync_lsp_dp_sch_dir_re                    (i_hqm_sip_rf_rx_sync_lsp_dp_sch_dir_re),
       .rf_rx_sync_lsp_dp_sch_dir_raddr                 (i_hqm_sip_rf_rx_sync_lsp_dp_sch_dir_raddr),
       .rf_rx_sync_lsp_dp_sch_dir_rdata                 (i_hqm_qed_mem_rf_rx_sync_lsp_dp_sch_dir_rdata),
       .rf_rx_sync_lsp_dp_sch_dir_isol_en               (i_hqm_sip_pgcb_isol_en),
       .rf_rx_sync_lsp_dp_sch_dir_pwr_enable_b_in       (i_hqm_qed_mem_rf_rx_sync_dp_dqed_data_pwr_enable_b_out),
       .rf_rx_sync_lsp_dp_sch_dir_pwr_enable_b_out      (i_hqm_qed_mem_rf_rx_sync_lsp_dp_sch_dir_pwr_enable_b_out),
       .rf_rx_sync_lsp_dp_sch_rorply_wclk               (i_hqm_sip_rf_rx_sync_lsp_dp_sch_rorply_wclk),
       .rf_rx_sync_lsp_dp_sch_rorply_wclk_rst_n         (i_hqm_sip_rf_rx_sync_lsp_dp_sch_rorply_wclk_rst_n),
       .rf_rx_sync_lsp_dp_sch_rorply_we                 (i_hqm_sip_rf_rx_sync_lsp_dp_sch_rorply_we),
       .rf_rx_sync_lsp_dp_sch_rorply_waddr              (i_hqm_sip_rf_rx_sync_lsp_dp_sch_rorply_waddr),
       .rf_rx_sync_lsp_dp_sch_rorply_wdata              (i_hqm_sip_rf_rx_sync_lsp_dp_sch_rorply_wdata),
       .rf_rx_sync_lsp_dp_sch_rorply_rclk               (i_hqm_sip_rf_rx_sync_lsp_dp_sch_rorply_rclk),
       .rf_rx_sync_lsp_dp_sch_rorply_rclk_rst_n         (i_hqm_sip_rf_rx_sync_lsp_dp_sch_rorply_rclk_rst_n),
       .rf_rx_sync_lsp_dp_sch_rorply_re                 (i_hqm_sip_rf_rx_sync_lsp_dp_sch_rorply_re),
       .rf_rx_sync_lsp_dp_sch_rorply_raddr              (i_hqm_sip_rf_rx_sync_lsp_dp_sch_rorply_raddr),
       .rf_rx_sync_lsp_dp_sch_rorply_rdata              (i_hqm_qed_mem_rf_rx_sync_lsp_dp_sch_rorply_rdata),
       .rf_rx_sync_lsp_dp_sch_rorply_isol_en            (i_hqm_sip_pgcb_isol_en),
       .rf_rx_sync_lsp_dp_sch_rorply_pwr_enable_b_in    (i_hqm_qed_mem_rf_rx_sync_lsp_dp_sch_dir_pwr_enable_b_out),
       .rf_rx_sync_lsp_dp_sch_rorply_pwr_enable_b_out   (i_hqm_qed_mem_rf_rx_sync_lsp_dp_sch_rorply_pwr_enable_b_out),
       .rf_rx_sync_lsp_nalb_sch_atq_wclk                (i_hqm_sip_rf_rx_sync_lsp_nalb_sch_atq_wclk),
       .rf_rx_sync_lsp_nalb_sch_atq_wclk_rst_n          (i_hqm_sip_rf_rx_sync_lsp_nalb_sch_atq_wclk_rst_n),
       .rf_rx_sync_lsp_nalb_sch_atq_we                  (i_hqm_sip_rf_rx_sync_lsp_nalb_sch_atq_we),
       .rf_rx_sync_lsp_nalb_sch_atq_waddr               (i_hqm_sip_rf_rx_sync_lsp_nalb_sch_atq_waddr),
       .rf_rx_sync_lsp_nalb_sch_atq_wdata               (i_hqm_sip_rf_rx_sync_lsp_nalb_sch_atq_wdata),
       .rf_rx_sync_lsp_nalb_sch_atq_rclk                (i_hqm_sip_rf_rx_sync_lsp_nalb_sch_atq_rclk),
       .rf_rx_sync_lsp_nalb_sch_atq_rclk_rst_n          (i_hqm_sip_rf_rx_sync_lsp_nalb_sch_atq_rclk_rst_n),
       .rf_rx_sync_lsp_nalb_sch_atq_re                  (i_hqm_sip_rf_rx_sync_lsp_nalb_sch_atq_re),
       .rf_rx_sync_lsp_nalb_sch_atq_raddr               (i_hqm_sip_rf_rx_sync_lsp_nalb_sch_atq_raddr),
       .rf_rx_sync_lsp_nalb_sch_atq_rdata               (i_hqm_qed_mem_rf_rx_sync_lsp_nalb_sch_atq_rdata),
       .rf_rx_sync_lsp_nalb_sch_atq_isol_en             (i_hqm_sip_pgcb_isol_en),
       .rf_rx_sync_lsp_nalb_sch_atq_pwr_enable_b_in     (i_hqm_qed_mem_rf_rx_sync_lsp_dp_sch_rorply_pwr_enable_b_out),
       .rf_rx_sync_lsp_nalb_sch_atq_pwr_enable_b_out    (i_hqm_qed_mem_rf_rx_sync_lsp_nalb_sch_atq_pwr_enable_b_out),
       .rf_rx_sync_lsp_nalb_sch_rorply_wclk             (i_hqm_sip_rf_rx_sync_lsp_nalb_sch_rorply_wclk),
       .rf_rx_sync_lsp_nalb_sch_rorply_wclk_rst_n       (i_hqm_sip_rf_rx_sync_lsp_nalb_sch_rorply_wclk_rst_n),
       .rf_rx_sync_lsp_nalb_sch_rorply_we               (i_hqm_sip_rf_rx_sync_lsp_nalb_sch_rorply_we),
       .rf_rx_sync_lsp_nalb_sch_rorply_waddr            (i_hqm_sip_rf_rx_sync_lsp_nalb_sch_rorply_waddr),
       .rf_rx_sync_lsp_nalb_sch_rorply_wdata            (i_hqm_sip_rf_rx_sync_lsp_nalb_sch_rorply_wdata),
       .rf_rx_sync_lsp_nalb_sch_rorply_rclk             (i_hqm_sip_rf_rx_sync_lsp_nalb_sch_rorply_rclk),
       .rf_rx_sync_lsp_nalb_sch_rorply_rclk_rst_n       (i_hqm_sip_rf_rx_sync_lsp_nalb_sch_rorply_rclk_rst_n),
       .rf_rx_sync_lsp_nalb_sch_rorply_re               (i_hqm_sip_rf_rx_sync_lsp_nalb_sch_rorply_re),
       .rf_rx_sync_lsp_nalb_sch_rorply_raddr            (i_hqm_sip_rf_rx_sync_lsp_nalb_sch_rorply_raddr),
       .rf_rx_sync_lsp_nalb_sch_rorply_rdata            (i_hqm_qed_mem_rf_rx_sync_lsp_nalb_sch_rorply_rdata),
       .rf_rx_sync_lsp_nalb_sch_rorply_isol_en          (i_hqm_sip_pgcb_isol_en),
       .rf_rx_sync_lsp_nalb_sch_rorply_pwr_enable_b_in  (i_hqm_qed_mem_rf_rx_sync_lsp_nalb_sch_atq_pwr_enable_b_out),
       .rf_rx_sync_lsp_nalb_sch_rorply_pwr_enable_b_out (i_hqm_qed_mem_rf_rx_sync_lsp_nalb_sch_rorply_pwr_enable_b_out),
       .rf_rx_sync_lsp_nalb_sch_unoord_wclk             (i_hqm_sip_rf_rx_sync_lsp_nalb_sch_unoord_wclk),
       .rf_rx_sync_lsp_nalb_sch_unoord_wclk_rst_n       (i_hqm_sip_rf_rx_sync_lsp_nalb_sch_unoord_wclk_rst_n),
       .rf_rx_sync_lsp_nalb_sch_unoord_we               (i_hqm_sip_rf_rx_sync_lsp_nalb_sch_unoord_we),
       .rf_rx_sync_lsp_nalb_sch_unoord_waddr            (i_hqm_sip_rf_rx_sync_lsp_nalb_sch_unoord_waddr),
       .rf_rx_sync_lsp_nalb_sch_unoord_wdata            (i_hqm_sip_rf_rx_sync_lsp_nalb_sch_unoord_wdata),
       .rf_rx_sync_lsp_nalb_sch_unoord_rclk             (i_hqm_sip_rf_rx_sync_lsp_nalb_sch_unoord_rclk),
       .rf_rx_sync_lsp_nalb_sch_unoord_rclk_rst_n       (i_hqm_sip_rf_rx_sync_lsp_nalb_sch_unoord_rclk_rst_n),
       .rf_rx_sync_lsp_nalb_sch_unoord_re               (i_hqm_sip_rf_rx_sync_lsp_nalb_sch_unoord_re),
       .rf_rx_sync_lsp_nalb_sch_unoord_raddr            (i_hqm_sip_rf_rx_sync_lsp_nalb_sch_unoord_raddr),
       .rf_rx_sync_lsp_nalb_sch_unoord_rdata            (i_hqm_qed_mem_rf_rx_sync_lsp_nalb_sch_unoord_rdata),
       .rf_rx_sync_lsp_nalb_sch_unoord_isol_en          (i_hqm_sip_pgcb_isol_en),
       .rf_rx_sync_lsp_nalb_sch_unoord_pwr_enable_b_in  (i_hqm_qed_mem_rf_rx_sync_lsp_nalb_sch_rorply_pwr_enable_b_out),
       .rf_rx_sync_lsp_nalb_sch_unoord_pwr_enable_b_out (i_hqm_qed_mem_rf_rx_sync_lsp_nalb_sch_unoord_pwr_enable_b_out),
       .rf_rx_sync_nalb_qed_data_wclk                   (i_hqm_sip_rf_rx_sync_nalb_qed_data_wclk),
       .rf_rx_sync_nalb_qed_data_wclk_rst_n             (i_hqm_sip_rf_rx_sync_nalb_qed_data_wclk_rst_n),
       .rf_rx_sync_nalb_qed_data_we                     (i_hqm_sip_rf_rx_sync_nalb_qed_data_we),
       .rf_rx_sync_nalb_qed_data_waddr                  (i_hqm_sip_rf_rx_sync_nalb_qed_data_waddr),
       .rf_rx_sync_nalb_qed_data_wdata                  (i_hqm_sip_rf_rx_sync_nalb_qed_data_wdata),
       .rf_rx_sync_nalb_qed_data_rclk                   (i_hqm_sip_rf_rx_sync_nalb_qed_data_rclk),
       .rf_rx_sync_nalb_qed_data_rclk_rst_n             (i_hqm_sip_rf_rx_sync_nalb_qed_data_rclk_rst_n),
       .rf_rx_sync_nalb_qed_data_re                     (i_hqm_sip_rf_rx_sync_nalb_qed_data_re),
       .rf_rx_sync_nalb_qed_data_raddr                  (i_hqm_sip_rf_rx_sync_nalb_qed_data_raddr),
       .rf_rx_sync_nalb_qed_data_rdata                  (i_hqm_qed_mem_rf_rx_sync_nalb_qed_data_rdata),
       .rf_rx_sync_nalb_qed_data_isol_en                (i_hqm_sip_pgcb_isol_en),
       .rf_rx_sync_nalb_qed_data_pwr_enable_b_in        (i_hqm_qed_mem_rf_rx_sync_lsp_nalb_sch_unoord_pwr_enable_b_out),
       .rf_rx_sync_nalb_qed_data_pwr_enable_b_out       (i_hqm_qed_mem_rf_rx_sync_nalb_qed_data_pwr_enable_b_out),
       .rf_rx_sync_rop_dp_enq_wclk                      (i_hqm_sip_rf_rx_sync_rop_dp_enq_wclk),
       .rf_rx_sync_rop_dp_enq_wclk_rst_n                (i_hqm_sip_rf_rx_sync_rop_dp_enq_wclk_rst_n),
       .rf_rx_sync_rop_dp_enq_we                        (i_hqm_sip_rf_rx_sync_rop_dp_enq_we),
       .rf_rx_sync_rop_dp_enq_waddr                     (i_hqm_sip_rf_rx_sync_rop_dp_enq_waddr),
       .rf_rx_sync_rop_dp_enq_wdata                     (i_hqm_sip_rf_rx_sync_rop_dp_enq_wdata),
       .rf_rx_sync_rop_dp_enq_rclk                      (i_hqm_sip_rf_rx_sync_rop_dp_enq_rclk),
       .rf_rx_sync_rop_dp_enq_rclk_rst_n                (i_hqm_sip_rf_rx_sync_rop_dp_enq_rclk_rst_n),
       .rf_rx_sync_rop_dp_enq_re                        (i_hqm_sip_rf_rx_sync_rop_dp_enq_re),
       .rf_rx_sync_rop_dp_enq_raddr                     (i_hqm_sip_rf_rx_sync_rop_dp_enq_raddr),
       .rf_rx_sync_rop_dp_enq_rdata                     (i_hqm_qed_mem_rf_rx_sync_rop_dp_enq_rdata),
       .rf_rx_sync_rop_dp_enq_isol_en                   (i_hqm_sip_pgcb_isol_en),
       .rf_rx_sync_rop_dp_enq_pwr_enable_b_in           (i_hqm_qed_mem_rf_rx_sync_nalb_qed_data_pwr_enable_b_out),
       .rf_rx_sync_rop_dp_enq_pwr_enable_b_out          (i_hqm_qed_mem_rf_rx_sync_rop_dp_enq_pwr_enable_b_out),
       .rf_rx_sync_rop_nalb_enq_wclk                    (i_hqm_sip_rf_rx_sync_rop_nalb_enq_wclk),
       .rf_rx_sync_rop_nalb_enq_wclk_rst_n              (i_hqm_sip_rf_rx_sync_rop_nalb_enq_wclk_rst_n),
       .rf_rx_sync_rop_nalb_enq_we                      (i_hqm_sip_rf_rx_sync_rop_nalb_enq_we),
       .rf_rx_sync_rop_nalb_enq_waddr                   (i_hqm_sip_rf_rx_sync_rop_nalb_enq_waddr),
       .rf_rx_sync_rop_nalb_enq_wdata                   (i_hqm_sip_rf_rx_sync_rop_nalb_enq_wdata),
       .rf_rx_sync_rop_nalb_enq_rclk                    (i_hqm_sip_rf_rx_sync_rop_nalb_enq_rclk),
       .rf_rx_sync_rop_nalb_enq_rclk_rst_n              (i_hqm_sip_rf_rx_sync_rop_nalb_enq_rclk_rst_n),
       .rf_rx_sync_rop_nalb_enq_re                      (i_hqm_sip_rf_rx_sync_rop_nalb_enq_re),
       .rf_rx_sync_rop_nalb_enq_raddr                   (i_hqm_sip_rf_rx_sync_rop_nalb_enq_raddr),
       .rf_rx_sync_rop_nalb_enq_rdata                   (i_hqm_qed_mem_rf_rx_sync_rop_nalb_enq_rdata),
       .rf_rx_sync_rop_nalb_enq_isol_en                 (i_hqm_sip_pgcb_isol_en),
       .rf_rx_sync_rop_nalb_enq_pwr_enable_b_in         (i_hqm_qed_mem_rf_rx_sync_rop_dp_enq_pwr_enable_b_out),
       .rf_rx_sync_rop_nalb_enq_pwr_enable_b_out        (i_hqm_qed_mem_rf_rx_sync_rop_nalb_enq_pwr_enable_b_out),
       .rf_rx_sync_rop_qed_dqed_enq_wclk                (i_hqm_sip_rf_rx_sync_rop_qed_dqed_enq_wclk),
       .rf_rx_sync_rop_qed_dqed_enq_wclk_rst_n          (i_hqm_sip_rf_rx_sync_rop_qed_dqed_enq_wclk_rst_n),
       .rf_rx_sync_rop_qed_dqed_enq_we                  (i_hqm_sip_rf_rx_sync_rop_qed_dqed_enq_we),
       .rf_rx_sync_rop_qed_dqed_enq_waddr               (i_hqm_sip_rf_rx_sync_rop_qed_dqed_enq_waddr),
       .rf_rx_sync_rop_qed_dqed_enq_wdata               (i_hqm_sip_rf_rx_sync_rop_qed_dqed_enq_wdata),
       .rf_rx_sync_rop_qed_dqed_enq_rclk                (i_hqm_sip_rf_rx_sync_rop_qed_dqed_enq_rclk),
       .rf_rx_sync_rop_qed_dqed_enq_rclk_rst_n          (i_hqm_sip_rf_rx_sync_rop_qed_dqed_enq_rclk_rst_n),
       .rf_rx_sync_rop_qed_dqed_enq_re                  (i_hqm_sip_rf_rx_sync_rop_qed_dqed_enq_re),
       .rf_rx_sync_rop_qed_dqed_enq_raddr               (i_hqm_sip_rf_rx_sync_rop_qed_dqed_enq_raddr),
       .rf_rx_sync_rop_qed_dqed_enq_rdata               (i_hqm_qed_mem_rf_rx_sync_rop_qed_dqed_enq_rdata),
       .rf_rx_sync_rop_qed_dqed_enq_isol_en             (i_hqm_sip_pgcb_isol_en),
       .rf_rx_sync_rop_qed_dqed_enq_pwr_enable_b_in     (i_hqm_qed_mem_rf_rx_sync_rop_nalb_enq_pwr_enable_b_out),
       .rf_rx_sync_rop_qed_dqed_enq_pwr_enable_b_out    (i_hqm_qed_mem_rf_rx_sync_rop_qed_dqed_enq_pwr_enable_b_out),
       .sr_dir_nxthp_clk                                (i_hqm_sip_sr_dir_nxthp_clk),
       .sr_dir_nxthp_clk_rst_n                          (i_hqm_sip_sr_dir_nxthp_clk_rst_n),
       .sr_dir_nxthp_addr                               (i_hqm_sip_sr_dir_nxthp_addr),
       .sr_dir_nxthp_we                                 (i_hqm_sip_sr_dir_nxthp_we),
       .sr_dir_nxthp_wdata                              (i_hqm_sip_sr_dir_nxthp_wdata),
       .sr_dir_nxthp_re                                 (i_hqm_sip_sr_dir_nxthp_re),
       .sr_dir_nxthp_rdata                              (i_hqm_qed_mem_sr_dir_nxthp_rdata),
       .sr_dir_nxthp_isol_en                            (i_hqm_sip_pgcb_isol_en),
       .sr_dir_nxthp_pwr_enable_b_in                    (i_hqm_list_sel_mem_rf_uno_atm_cmp_fifo_mem_pwr_enable_b_out),
       .sr_dir_nxthp_pwr_enable_b_out                   (i_hqm_qed_mem_sr_dir_nxthp_pwr_enable_b_out),
       .sr_nalb_nxthp_clk                               (i_hqm_sip_sr_nalb_nxthp_clk),
       .sr_nalb_nxthp_clk_rst_n                         (i_hqm_sip_sr_nalb_nxthp_clk_rst_n),
       .sr_nalb_nxthp_addr                              (i_hqm_sip_sr_nalb_nxthp_addr),
       .sr_nalb_nxthp_we                                (i_hqm_sip_sr_nalb_nxthp_we),
       .sr_nalb_nxthp_wdata                             (i_hqm_sip_sr_nalb_nxthp_wdata),
       .sr_nalb_nxthp_re                                (i_hqm_sip_sr_nalb_nxthp_re),
       .sr_nalb_nxthp_rdata                             (i_hqm_qed_mem_sr_nalb_nxthp_rdata),
       .sr_nalb_nxthp_isol_en                           (i_hqm_sip_pgcb_isol_en),
       .sr_nalb_nxthp_pwr_enable_b_in                   (i_hqm_qed_mem_sr_dir_nxthp_pwr_enable_b_out),
       .sr_nalb_nxthp_pwr_enable_b_out                  (i_hqm_qed_mem_sr_nalb_nxthp_pwr_enable_b_out),
       .sr_qed_0_clk                                    (i_hqm_sip_sr_qed_0_clk),
       .sr_qed_0_clk_rst_n                              (i_hqm_sip_sr_qed_0_clk_rst_n),
       .sr_qed_0_addr                                   (i_hqm_sip_sr_qed_0_addr),
       .sr_qed_0_we                                     (i_hqm_sip_sr_qed_0_we),
       .sr_qed_0_wdata                                  (i_hqm_sip_sr_qed_0_wdata),
       .sr_qed_0_re                                     (i_hqm_sip_sr_qed_0_re),
       .sr_qed_0_rdata                                  (i_hqm_qed_mem_sr_qed_0_rdata),
       .sr_qed_0_isol_en                                (i_hqm_sip_pgcb_isol_en),
       .sr_qed_0_pwr_enable_b_in                        (i_hqm_qed_mem_sr_nalb_nxthp_pwr_enable_b_out),
       .sr_qed_0_pwr_enable_b_out                       (i_hqm_qed_mem_sr_qed_0_pwr_enable_b_out),
       .sr_qed_1_clk                                    (i_hqm_sip_sr_qed_1_clk),
       .sr_qed_1_clk_rst_n                              (i_hqm_sip_sr_qed_1_clk_rst_n),
       .sr_qed_1_addr                                   (i_hqm_sip_sr_qed_1_addr),
       .sr_qed_1_we                                     (i_hqm_sip_sr_qed_1_we),
       .sr_qed_1_wdata                                  (i_hqm_sip_sr_qed_1_wdata),
       .sr_qed_1_re                                     (i_hqm_sip_sr_qed_1_re),
       .sr_qed_1_rdata                                  (i_hqm_qed_mem_sr_qed_1_rdata),
       .sr_qed_1_isol_en                                (i_hqm_sip_pgcb_isol_en),
       .sr_qed_1_pwr_enable_b_in                        (i_hqm_qed_mem_sr_qed_0_pwr_enable_b_out),
       .sr_qed_1_pwr_enable_b_out                       (i_hqm_qed_mem_sr_qed_1_pwr_enable_b_out),
       .sr_qed_2_clk                                    (i_hqm_sip_sr_qed_2_clk),
       .sr_qed_2_clk_rst_n                              (i_hqm_sip_sr_qed_2_clk_rst_n),
       .sr_qed_2_addr                                   (i_hqm_sip_sr_qed_2_addr),
       .sr_qed_2_we                                     (i_hqm_sip_sr_qed_2_we),
       .sr_qed_2_wdata                                  (i_hqm_sip_sr_qed_2_wdata),
       .sr_qed_2_re                                     (i_hqm_sip_sr_qed_2_re),
       .sr_qed_2_rdata                                  (i_hqm_qed_mem_sr_qed_2_rdata),
       .sr_qed_2_isol_en                                (i_hqm_sip_pgcb_isol_en),
       .sr_qed_2_pwr_enable_b_in                        (i_hqm_qed_mem_sr_qed_1_pwr_enable_b_out),
       .sr_qed_2_pwr_enable_b_out                       (i_hqm_qed_mem_sr_qed_2_pwr_enable_b_out),
       .sr_qed_3_clk                                    (i_hqm_sip_sr_qed_3_clk),
       .sr_qed_3_clk_rst_n                              (i_hqm_sip_sr_qed_3_clk_rst_n),
       .sr_qed_3_addr                                   (i_hqm_sip_sr_qed_3_addr),
       .sr_qed_3_we                                     (i_hqm_sip_sr_qed_3_we),
       .sr_qed_3_wdata                                  (i_hqm_sip_sr_qed_3_wdata),
       .sr_qed_3_re                                     (i_hqm_sip_sr_qed_3_re),
       .sr_qed_3_rdata                                  (i_hqm_qed_mem_sr_qed_3_rdata),
       .sr_qed_3_isol_en                                (i_hqm_sip_pgcb_isol_en),
       .sr_qed_3_pwr_enable_b_in                        (i_hqm_qed_mem_sr_qed_2_pwr_enable_b_out),
       .sr_qed_3_pwr_enable_b_out                       (i_hqm_qed_mem_sr_qed_3_pwr_enable_b_out),
       .sr_qed_4_clk                                    (i_hqm_sip_sr_qed_4_clk),
       .sr_qed_4_clk_rst_n                              (i_hqm_sip_sr_qed_4_clk_rst_n),
       .sr_qed_4_addr                                   (i_hqm_sip_sr_qed_4_addr),
       .sr_qed_4_we                                     (i_hqm_sip_sr_qed_4_we),
       .sr_qed_4_wdata                                  (i_hqm_sip_sr_qed_4_wdata),
       .sr_qed_4_re                                     (i_hqm_sip_sr_qed_4_re),
       .sr_qed_4_rdata                                  (i_hqm_qed_mem_sr_qed_4_rdata),
       .sr_qed_4_isol_en                                (i_hqm_sip_pgcb_isol_en),
       .sr_qed_4_pwr_enable_b_in                        (i_hqm_qed_mem_sr_qed_3_pwr_enable_b_out),
       .sr_qed_4_pwr_enable_b_out                       (i_hqm_qed_mem_sr_qed_4_pwr_enable_b_out),
       .sr_qed_5_clk                                    (i_hqm_sip_sr_qed_5_clk),
       .sr_qed_5_clk_rst_n                              (i_hqm_sip_sr_qed_5_clk_rst_n),
       .sr_qed_5_addr                                   (i_hqm_sip_sr_qed_5_addr),
       .sr_qed_5_we                                     (i_hqm_sip_sr_qed_5_we),
       .sr_qed_5_wdata                                  (i_hqm_sip_sr_qed_5_wdata),
       .sr_qed_5_re                                     (i_hqm_sip_sr_qed_5_re),
       .sr_qed_5_rdata                                  (i_hqm_qed_mem_sr_qed_5_rdata),
       .sr_qed_5_isol_en                                (i_hqm_sip_pgcb_isol_en),
       .sr_qed_5_pwr_enable_b_in                        (i_hqm_qed_mem_sr_qed_4_pwr_enable_b_out),
       .sr_qed_5_pwr_enable_b_out                       (i_hqm_qed_mem_sr_qed_5_pwr_enable_b_out),
       .sr_qed_6_clk                                    (i_hqm_sip_sr_qed_6_clk),
       .sr_qed_6_clk_rst_n                              (i_hqm_sip_sr_qed_6_clk_rst_n),
       .sr_qed_6_addr                                   (i_hqm_sip_sr_qed_6_addr),
       .sr_qed_6_we                                     (i_hqm_sip_sr_qed_6_we),
       .sr_qed_6_wdata                                  (i_hqm_sip_sr_qed_6_wdata),
       .sr_qed_6_re                                     (i_hqm_sip_sr_qed_6_re),
       .sr_qed_6_rdata                                  (i_hqm_qed_mem_sr_qed_6_rdata),
       .sr_qed_6_isol_en                                (i_hqm_sip_pgcb_isol_en),
       .sr_qed_6_pwr_enable_b_in                        (i_hqm_qed_mem_sr_qed_5_pwr_enable_b_out),
       .sr_qed_6_pwr_enable_b_out                       (i_hqm_qed_mem_sr_qed_6_pwr_enable_b_out),
       .sr_qed_7_clk                                    (i_hqm_sip_sr_qed_7_clk),
       .sr_qed_7_clk_rst_n                              (i_hqm_sip_sr_qed_7_clk_rst_n),
       .sr_qed_7_addr                                   (i_hqm_sip_sr_qed_7_addr),
       .sr_qed_7_we                                     (i_hqm_sip_sr_qed_7_we),
       .sr_qed_7_wdata                                  (i_hqm_sip_sr_qed_7_wdata),
       .sr_qed_7_re                                     (i_hqm_sip_sr_qed_7_re),
       .sr_qed_7_rdata                                  (i_hqm_qed_mem_sr_qed_7_rdata),
       .sr_qed_7_isol_en                                (i_hqm_sip_pgcb_isol_en),
       .sr_qed_7_pwr_enable_b_in                        (i_hqm_qed_mem_sr_qed_6_pwr_enable_b_out),
       .sr_qed_7_pwr_enable_b_out                       (i_hqm_qed_mem_sr_qed_7_pwr_enable_b_out),
       .hqm_pwrgood_rst_b                               (i_hqm_sip_hqm_pwrgood_rst_b),
       .powergood_rst_b,
       .fscan_byprst_b,
       .fscan_clkungate,
       .fscan_rstbypen);

   hqm_sip
      #(.HQM_DTF_DATA_WIDTH(HQM_DTF_DATA_WIDTH),
        .HQM_DTF_HEADER_WIDTH(HQM_DTF_HEADER_WIDTH),
        .HQM_DTF_TO_CNT_THRESHOLD(HQM_DTF_TO_CNT_THRESHOLD),
        .HQM_DVP_USE_LEGACY_TIMESTAMP(HQM_DVP_USE_LEGACY_TIMESTAMP),
        .HQM_DVP_USE_PUSH_SWD(HQM_DVP_USE_PUSH_SWD),
        .HQM_SBE_DATAWIDTH(HQM_SBE_DATAWIDTH),
        .HQM_SBE_NPQUEUEDEPTH(HQM_SBE_NPQUEUEDEPTH),
        .HQM_SBE_PARITY_REQUIRED(HQM_SBE_PARITY_REQUIRED),
        .HQM_SBE_PCQUEUEDEPTH(HQM_SBE_PCQUEUEDEPTH),
        .HQM_SFI_RX_BCM_EN(HQM_SFI_RX_BCM_EN),
        .HQM_SFI_RX_BLOCK_EARLY_VLD_EN(HQM_SFI_RX_BLOCK_EARLY_VLD_EN),
        .HQM_SFI_RX_D(HQM_SFI_RX_D),
        .HQM_SFI_RX_DATA_AUX_PARITY_EN(HQM_SFI_RX_DATA_AUX_PARITY_EN),
        .HQM_SFI_RX_DATA_CRD_GRAN(HQM_SFI_RX_DATA_CRD_GRAN),
        .HQM_SFI_RX_DATA_INTERLEAVE(HQM_SFI_RX_DATA_INTERLEAVE),
        .HQM_SFI_RX_DATA_LAYER_EN(HQM_SFI_RX_DATA_LAYER_EN),
        .HQM_SFI_RX_DATA_MAX_FC_VC(HQM_SFI_RX_DATA_MAX_FC_VC),
        .HQM_SFI_RX_DATA_PARITY_EN(HQM_SFI_RX_DATA_PARITY_EN),
        .HQM_SFI_RX_DATA_PASS_HDR(HQM_SFI_RX_DATA_PASS_HDR),
        .HQM_SFI_RX_DS(HQM_SFI_RX_DS),
        .HQM_SFI_RX_ECRC_SUPPORT(HQM_SFI_RX_ECRC_SUPPORT),
        .HQM_SFI_RX_FATAL_EN(HQM_SFI_RX_FATAL_EN),
        .HQM_SFI_RX_FLIT_MODE_PREFIX_EN(HQM_SFI_RX_FLIT_MODE_PREFIX_EN),
        .HQM_SFI_RX_H(HQM_SFI_RX_H),
        .HQM_SFI_RX_HDR_DATA_SEP(HQM_SFI_RX_HDR_DATA_SEP),
        .HQM_SFI_RX_HDR_MAX_FC_VC(HQM_SFI_RX_HDR_MAX_FC_VC),
        .HQM_SFI_RX_HGRAN(HQM_SFI_RX_HGRAN),
        .HQM_SFI_RX_HPARITY(HQM_SFI_RX_HPARITY),
        .HQM_SFI_RX_IDE_SUPPORT(HQM_SFI_RX_IDE_SUPPORT),
        .HQM_SFI_RX_M(HQM_SFI_RX_M),
        .HQM_SFI_RX_MAX_CRD_CNT_WIDTH(HQM_SFI_RX_MAX_CRD_CNT_WIDTH),
        .HQM_SFI_RX_MAX_HDR_WIDTH(HQM_SFI_RX_MAX_HDR_WIDTH),
        .HQM_SFI_RX_NDCRD(HQM_SFI_RX_NDCRD),
        .HQM_SFI_RX_NHCRD(HQM_SFI_RX_NHCRD),
        .HQM_SFI_RX_NUM_SHARED_POOLS(HQM_SFI_RX_NUM_SHARED_POOLS),
        .HQM_SFI_RX_PCIE_MERGED_SELECT(HQM_SFI_RX_PCIE_MERGED_SELECT),
        .HQM_SFI_RX_PCIE_SHARED_SELECT(HQM_SFI_RX_PCIE_SHARED_SELECT),
        .HQM_SFI_RX_RBN(HQM_SFI_RX_RBN),
        .HQM_SFI_RX_SHARED_CREDIT_EN(HQM_SFI_RX_SHARED_CREDIT_EN),
        .HQM_SFI_RX_SH_DATA_CRD_BLK_SZ(HQM_SFI_RX_SH_DATA_CRD_BLK_SZ),
        .HQM_SFI_RX_SH_HDR_CRD_BLK_SZ(HQM_SFI_RX_SH_HDR_CRD_BLK_SZ),
        .HQM_SFI_RX_TBN(HQM_SFI_RX_TBN),
        .HQM_SFI_RX_TX_CRD_REG(HQM_SFI_RX_TX_CRD_REG),
        .HQM_SFI_RX_VIRAL_EN(HQM_SFI_RX_VIRAL_EN),
        .HQM_SFI_RX_VR(HQM_SFI_RX_VR),
        .HQM_SFI_RX_VT(HQM_SFI_RX_VT),
        .HQM_SFI_TX_BCM_EN(HQM_SFI_TX_BCM_EN),
        .HQM_SFI_TX_BLOCK_EARLY_VLD_EN(HQM_SFI_TX_BLOCK_EARLY_VLD_EN),
        .HQM_SFI_TX_D(HQM_SFI_TX_D),
        .HQM_SFI_TX_DATA_AUX_PARITY_EN(HQM_SFI_TX_DATA_AUX_PARITY_EN),
        .HQM_SFI_TX_DATA_CRD_GRAN(HQM_SFI_TX_DATA_CRD_GRAN),
        .HQM_SFI_TX_DATA_INTERLEAVE(HQM_SFI_TX_DATA_INTERLEAVE),
        .HQM_SFI_TX_DATA_LAYER_EN(HQM_SFI_TX_DATA_LAYER_EN),
        .HQM_SFI_TX_DATA_MAX_FC_VC(HQM_SFI_TX_DATA_MAX_FC_VC),
        .HQM_SFI_TX_DATA_PARITY_EN(HQM_SFI_TX_DATA_PARITY_EN),
        .HQM_SFI_TX_DATA_PASS_HDR(HQM_SFI_TX_DATA_PASS_HDR),
        .HQM_SFI_TX_DS(HQM_SFI_TX_DS),
        .HQM_SFI_TX_ECRC_SUPPORT(HQM_SFI_TX_ECRC_SUPPORT),
        .HQM_SFI_TX_FATAL_EN(HQM_SFI_TX_FATAL_EN),
        .HQM_SFI_TX_FLIT_MODE_PREFIX_EN(HQM_SFI_TX_FLIT_MODE_PREFIX_EN),
        .HQM_SFI_TX_H(HQM_SFI_TX_H),
        .HQM_SFI_TX_HDR_DATA_SEP(HQM_SFI_TX_HDR_DATA_SEP),
        .HQM_SFI_TX_HDR_MAX_FC_VC(HQM_SFI_TX_HDR_MAX_FC_VC),
        .HQM_SFI_TX_HGRAN(HQM_SFI_TX_HGRAN),
        .HQM_SFI_TX_HPARITY(HQM_SFI_TX_HPARITY),
        .HQM_SFI_TX_IDE_SUPPORT(HQM_SFI_TX_IDE_SUPPORT),
        .HQM_SFI_TX_M(HQM_SFI_TX_M),
        .HQM_SFI_TX_MAX_CRD_CNT_WIDTH(HQM_SFI_TX_MAX_CRD_CNT_WIDTH),
        .HQM_SFI_TX_MAX_HDR_WIDTH(HQM_SFI_TX_MAX_HDR_WIDTH),
        .HQM_SFI_TX_NDCRD(HQM_SFI_TX_NDCRD),
        .HQM_SFI_TX_NHCRD(HQM_SFI_TX_NHCRD),
        .HQM_SFI_TX_NUM_SHARED_POOLS(HQM_SFI_TX_NUM_SHARED_POOLS),
        .HQM_SFI_TX_PCIE_MERGED_SELECT(HQM_SFI_TX_PCIE_MERGED_SELECT),
        .HQM_SFI_TX_PCIE_SHARED_SELECT(HQM_SFI_TX_PCIE_SHARED_SELECT),
        .HQM_SFI_TX_RBN(HQM_SFI_TX_RBN),
        .HQM_SFI_TX_SHARED_CREDIT_EN(HQM_SFI_TX_SHARED_CREDIT_EN),
        .HQM_SFI_TX_SH_DATA_CRD_BLK_SZ(HQM_SFI_TX_SH_DATA_CRD_BLK_SZ),
        .HQM_SFI_TX_SH_HDR_CRD_BLK_SZ(HQM_SFI_TX_SH_HDR_CRD_BLK_SZ),
        .HQM_SFI_TX_TBN(HQM_SFI_TX_TBN),
        .HQM_SFI_TX_TX_CRD_REG(HQM_SFI_TX_TX_CRD_REG),
        .HQM_SFI_TX_VIRAL_EN(HQM_SFI_TX_VIRAL_EN),
        .HQM_SFI_TX_VR(HQM_SFI_TX_VR),
        .HQM_SFI_TX_VT(HQM_SFI_TX_VT),
        .HQM_TRIGFABWIDTH(HQM_TRIGFABWIDTH),
        .HQM_TRIGGER_WIDTH(HQM_TRIGGER_WIDTH)) i_hqm_sip
      (.early_fuses,
       // GPSB parity disable
       .fdfx_sbparity_def,
       .fdtf_force_ts,
       // DVP Tiemstamp
       .fdtf_serial_download_tsc,
       .fdtf_timestamp_valid,
       .fdtf_timestamp_value,
       .fdtf_tsc_adjustment_strap,
       .iosf_pgcb_clk,
       .pgcb_clk,
       .pgcb_tck,
       // Asynchronous DIMM Refresh interface
       .pm_hqm_adr_assert,
       // Clocks
       .prim_clk,
       // Emergency power reduction request
       .prochot,
       .strap_hqm_16b_portids,
       // SAI for completions
       .strap_hqm_cmpl_sai,
       // CSR control straps
       .strap_hqm_csr_cp,
       // CSR control straps
       .strap_hqm_csr_rac,
       // CSR control straps
       .strap_hqm_csr_wac,
       // ID Straps
       .strap_hqm_device_id,
       .strap_hqm_do_serr_rs,
       .strap_hqm_do_serr_sai,
       .strap_hqm_do_serr_sairs_valid,
       .strap_hqm_do_serr_tag,
       // SAI sent with PCIe error messages
       .strap_hqm_err_sb_sai,
       // Legal SAI values for Sideband ForcePwrGatePOK message
       .strap_hqm_force_pok_sai_0,
       .strap_hqm_force_pok_sai_1,
       // SAI sent with ResetPrepAck messages
       .strap_hqm_resetprep_ack_sai,
       // Legal SAI values for Sideband ResetPrep message
       .strap_hqm_resetprep_sai_0,
       .strap_hqm_resetprep_sai_1,
       // SAI for tx
       .strap_hqm_tx_sai,
       .strap_no_mgmt_acks,
       .hqm_pm_adr_ack,
       .ip_ready,
       .reset_prep_ack,
       .dvp_paddr,
       .dvp_penable,
       .dvp_pprot,
       .dvp_psel,
       .dvp_pstrb,
       .dvp_pwdata,
       .dvp_pwrite,
       .dvp_prdata,
       .dvp_pready,
       .dvp_pslverr,
       .ftrig_fabric_in,
       .ftrig_fabric_out_ack,
       .atrig_fabric_in_ack,
       .atrig_fabric_out,
       .fdfx_debug_cap,
       .fdfx_debug_cap_valid,
       .fdfx_earlyboot_debug_exit,
       .fdfx_policy_update,
       .fdfx_security_policy,
       .fdtf_upstream_active,
       .fdtf_upstream_credit,
       .fdtf_upstream_sync,
       .adtf_dnstream_data,
       .adtf_dnstream_header,
       .adtf_dnstream_valid,
       .fdtf_clk,
       .fdtf_cry_clk,
       .fdtf_fast_cnt_width,
       .fdtf_packetizer_cid,
       .fdtf_packetizer_mid,
       .fdtf_survive_mode,
       .fdtf_rst_b,
       .gpsb_mnpcup,
       .gpsb_mpccup,
       .gpsb_side_ism_fabric,
       .gpsb_teom,
       .gpsb_tnpput,
       .gpsb_tparity,
       .gpsb_tpayload,
       .gpsb_tpcput,
       .gpsb_meom,
       .gpsb_mnpput,
       .gpsb_mparity,
       .gpsb_mpayload,
       .gpsb_mpcput,
       .gpsb_side_ism_agent,
       .gpsb_tnpcup,
       .gpsb_tpccup,
       .side_clk,
       .strap_hqm_do_serr_dstid,
       .strap_hqm_err_sb_dstid,
       .strap_hqm_gpsb_srcid,
       .side_pok,
       .side_clkack,
       .side_clkreq,
       .side_rst_b,
       .side_pwrgate_pmc_wake,
       .prim_clkack,
       .prim_clkreq,
       .pma_safemode,
       .powergood_rst_b,
       .prim_pwrgate_pmc_wake,
       .prim_rst_b,
       .rtdr_iosfsb_ism_capturedr,
       .rtdr_iosfsb_ism_irdec,
       .rtdr_iosfsb_ism_shiftdr,
       .rtdr_iosfsb_ism_tdi,
       .rtdr_iosfsb_ism_updatedr,
       .rtdr_iosfsb_ism_tdo,
       .rtdr_iosfsb_ism_tck,
       .rtdr_iosfsb_ism_trst_b,
       .rtdr_tapconfig_capturedr,
       .rtdr_tapconfig_irdec,
       .rtdr_tapconfig_shiftdr,
       .rtdr_tapconfig_tdi,
       .rtdr_tapconfig_updatedr,
       .rtdr_tapconfig_tdo,
       .rtdr_tapconfig_tck,
       .rtdr_tapconfig_trst_b,
       .rtdr_taptrigger_capturedr,
       .rtdr_taptrigger_irdec,
       .rtdr_taptrigger_shiftdr,
       .rtdr_taptrigger_tdi,
       .rtdr_taptrigger_updatedr,
       .rtdr_taptrigger_tdo,
       .rtdr_taptrigger_tck,
       .rtdr_taptrigger_trst_b,
       .fscan_byprst_b,
       .fscan_clkungate,
       .fscan_clkungate_syn,
       .fscan_latchclosed_b,
       .fscan_latchopen,
       .fscan_mode,
       .fscan_rstbypen,
       .fscan_shiften,
       .fdfx_powergood,
       .sfi_rx_data,
       .sfi_rx_data_aux_parity,
       .sfi_rx_data_crd_rtn_block,
       .sfi_rx_data_early_valid,
       .sfi_rx_data_edb,
       .sfi_rx_data_end,
       .sfi_rx_data_info_byte,
       .sfi_rx_data_parity,
       .sfi_rx_data_poison,
       .sfi_rx_data_start,
       .sfi_rx_data_valid,
       .sfi_rx_data_block,
       .sfi_rx_data_crd_rtn_fc_id,
       .sfi_rx_data_crd_rtn_valid,
       .sfi_rx_data_crd_rtn_value,
       .sfi_rx_data_crd_rtn_vc_id,
       .sfi_rx_txcon_req,
       .sfi_rx_rx_empty,
       .sfi_rx_rxcon_ack,
       .sfi_rx_rxdiscon_nack,
       .sfi_rx_hdr_crd_rtn_block,
       .sfi_rx_hdr_early_valid,
       .sfi_rx_hdr_info_bytes,
       .sfi_rx_hdr_valid,
       .sfi_rx_header,
       .sfi_rx_hdr_block,
       .sfi_rx_hdr_crd_rtn_fc_id,
       .sfi_rx_hdr_crd_rtn_valid,
       .sfi_rx_hdr_crd_rtn_value,
       .sfi_rx_hdr_crd_rtn_vc_id,
       .sfi_tx_data_block,
       .sfi_tx_data_crd_rtn_fc_id,
       .sfi_tx_data_crd_rtn_valid,
       .sfi_tx_data_crd_rtn_value,
       .sfi_tx_data_crd_rtn_vc_id,
       .sfi_tx_data,
       .sfi_tx_data_aux_parity,
       .sfi_tx_data_crd_rtn_block,
       .sfi_tx_data_early_valid,
       .sfi_tx_data_edb,
       .sfi_tx_data_end,
       .sfi_tx_data_info_byte,
       .sfi_tx_data_parity,
       .sfi_tx_data_poison,
       .sfi_tx_data_start,
       .sfi_tx_data_valid,
       .sfi_tx_rx_empty,
       .sfi_tx_rxcon_ack,
       .sfi_tx_rxdiscon_nack,
       .sfi_tx_txcon_req,
       .sfi_tx_hdr_block,
       .sfi_tx_hdr_crd_rtn_fc_id,
       .sfi_tx_hdr_crd_rtn_valid,
       .sfi_tx_hdr_crd_rtn_value,
       .sfi_tx_hdr_crd_rtn_vc_id,
       .sfi_tx_hdr_crd_rtn_block,
       .sfi_tx_hdr_early_valid,
       .sfi_tx_hdr_info_bytes,
       .sfi_tx_hdr_valid,
       .sfi_tx_header,
       .dig_view_out_0,
       .dig_view_out_1,
       .bcam_AW_bcam_2048x26_cmatch                        (i_hqm_list_sel_mem_bcam_AW_bcam_2048x26_cmatch),
       .bcam_AW_bcam_2048x26_rdata                         (i_hqm_list_sel_mem_bcam_AW_bcam_2048x26_rdata),
       .fscan_isol_ctrl,
       .fscan_isol_lat_ctrl,
       .fscan_ret_ctrl,
       .par_mem_pgcb_fet_en_ack_b                          (i_hqm_system_mem_rf_threshold_r_pipe_ldb_mem_pwr_enable_b_out),
       .rf_alarm_vf_synd0_rdata                            (i_hqm_system_mem_rf_alarm_vf_synd0_rdata),
       .rf_alarm_vf_synd1_rdata                            (i_hqm_system_mem_rf_alarm_vf_synd1_rdata),
       .rf_alarm_vf_synd2_rdata                            (i_hqm_system_mem_rf_alarm_vf_synd2_rdata),
       .rf_aqed_chp_sch_rx_sync_mem_rdata                  (i_hqm_system_mem_rf_aqed_chp_sch_rx_sync_mem_rdata),
       .rf_aqed_fid_cnt_rdata                              (i_hqm_list_sel_mem_rf_aqed_fid_cnt_rdata),
       .rf_aqed_fifo_ap_aqed_rdata                         (i_hqm_list_sel_mem_rf_aqed_fifo_ap_aqed_rdata),
       .rf_aqed_fifo_aqed_ap_enq_rdata                     (i_hqm_list_sel_mem_rf_aqed_fifo_aqed_ap_enq_rdata),
       .rf_aqed_fifo_aqed_chp_sch_rdata                    (i_hqm_list_sel_mem_rf_aqed_fifo_aqed_chp_sch_rdata),
       .rf_aqed_fifo_freelist_return_rdata                 (i_hqm_list_sel_mem_rf_aqed_fifo_freelist_return_rdata),
       .rf_aqed_fifo_lsp_aqed_cmp_rdata                    (i_hqm_list_sel_mem_rf_aqed_fifo_lsp_aqed_cmp_rdata),
       .rf_aqed_fifo_qed_aqed_enq_fid_rdata                (i_hqm_list_sel_mem_rf_aqed_fifo_qed_aqed_enq_fid_rdata),
       .rf_aqed_fifo_qed_aqed_enq_rdata                    (i_hqm_list_sel_mem_rf_aqed_fifo_qed_aqed_enq_rdata),
       .rf_aqed_ll_cnt_pri0_rdata                          (i_hqm_list_sel_mem_rf_aqed_ll_cnt_pri0_rdata),
       .rf_aqed_ll_cnt_pri1_rdata                          (i_hqm_list_sel_mem_rf_aqed_ll_cnt_pri1_rdata),
       .rf_aqed_ll_cnt_pri2_rdata                          (i_hqm_list_sel_mem_rf_aqed_ll_cnt_pri2_rdata),
       .rf_aqed_ll_cnt_pri3_rdata                          (i_hqm_list_sel_mem_rf_aqed_ll_cnt_pri3_rdata),
       .rf_aqed_ll_qe_hp_pri0_rdata                        (i_hqm_list_sel_mem_rf_aqed_ll_qe_hp_pri0_rdata),
       .rf_aqed_ll_qe_hp_pri1_rdata                        (i_hqm_list_sel_mem_rf_aqed_ll_qe_hp_pri1_rdata),
       .rf_aqed_ll_qe_hp_pri2_rdata                        (i_hqm_list_sel_mem_rf_aqed_ll_qe_hp_pri2_rdata),
       .rf_aqed_ll_qe_hp_pri3_rdata                        (i_hqm_list_sel_mem_rf_aqed_ll_qe_hp_pri3_rdata),
       .rf_aqed_ll_qe_tp_pri0_rdata                        (i_hqm_list_sel_mem_rf_aqed_ll_qe_tp_pri0_rdata),
       .rf_aqed_ll_qe_tp_pri1_rdata                        (i_hqm_list_sel_mem_rf_aqed_ll_qe_tp_pri1_rdata),
       .rf_aqed_ll_qe_tp_pri2_rdata                        (i_hqm_list_sel_mem_rf_aqed_ll_qe_tp_pri2_rdata),
       .rf_aqed_ll_qe_tp_pri3_rdata                        (i_hqm_list_sel_mem_rf_aqed_ll_qe_tp_pri3_rdata),
       .rf_aqed_lsp_deq_fifo_mem_rdata                     (i_hqm_list_sel_mem_rf_aqed_lsp_deq_fifo_mem_rdata),
       .rf_aqed_qid2cqidix_rdata                           (i_hqm_list_sel_mem_rf_aqed_qid2cqidix_rdata),
       .rf_aqed_qid_cnt_rdata                              (i_hqm_list_sel_mem_rf_aqed_qid_cnt_rdata),
       .rf_aqed_qid_fid_limit_rdata                        (i_hqm_list_sel_mem_rf_aqed_qid_fid_limit_rdata),
       .rf_atm_cmp_fifo_mem_rdata                          (i_hqm_list_sel_mem_rf_atm_cmp_fifo_mem_rdata),
       .rf_atm_fifo_ap_aqed_rdata                          (i_hqm_list_sel_mem_rf_atm_fifo_ap_aqed_rdata),
       .rf_atm_fifo_aqed_ap_enq_rdata                      (i_hqm_list_sel_mem_rf_atm_fifo_aqed_ap_enq_rdata),
       .rf_atq_cnt_rdata                                   (i_hqm_qed_mem_rf_atq_cnt_rdata),
       .rf_atq_hp_rdata                                    (i_hqm_qed_mem_rf_atq_hp_rdata),
       .rf_atq_tp_rdata                                    (i_hqm_qed_mem_rf_atq_tp_rdata),
       .rf_cfg_atm_qid_dpth_thrsh_mem_rdata                (i_hqm_list_sel_mem_rf_cfg_atm_qid_dpth_thrsh_mem_rdata),
       .rf_cfg_cq2priov_mem_rdata                          (i_hqm_list_sel_mem_rf_cfg_cq2priov_mem_rdata),
       .rf_cfg_cq2priov_odd_mem_rdata                      (i_hqm_list_sel_mem_rf_cfg_cq2priov_odd_mem_rdata),
       .rf_cfg_cq2qid_0_mem_rdata                          (i_hqm_list_sel_mem_rf_cfg_cq2qid_0_mem_rdata),
       .rf_cfg_cq2qid_0_odd_mem_rdata                      (i_hqm_list_sel_mem_rf_cfg_cq2qid_0_odd_mem_rdata),
       .rf_cfg_cq2qid_1_mem_rdata                          (i_hqm_list_sel_mem_rf_cfg_cq2qid_1_mem_rdata),
       .rf_cfg_cq2qid_1_odd_mem_rdata                      (i_hqm_list_sel_mem_rf_cfg_cq2qid_1_odd_mem_rdata),
       .rf_cfg_cq_ldb_inflight_limit_mem_rdata             (i_hqm_list_sel_mem_rf_cfg_cq_ldb_inflight_limit_mem_rdata),
       .rf_cfg_cq_ldb_inflight_threshold_mem_rdata         (i_hqm_list_sel_mem_rf_cfg_cq_ldb_inflight_threshold_mem_rdata),
       .rf_cfg_cq_ldb_token_depth_select_mem_rdata         (i_hqm_list_sel_mem_rf_cfg_cq_ldb_token_depth_select_mem_rdata),
       .rf_cfg_cq_ldb_wu_limit_mem_rdata                   (i_hqm_list_sel_mem_rf_cfg_cq_ldb_wu_limit_mem_rdata),
       .rf_cfg_dir_qid_dpth_thrsh_mem_rdata                (i_hqm_list_sel_mem_rf_cfg_dir_qid_dpth_thrsh_mem_rdata),
       .rf_cfg_nalb_qid_dpth_thrsh_mem_rdata               (i_hqm_list_sel_mem_rf_cfg_nalb_qid_dpth_thrsh_mem_rdata),
       .rf_cfg_qid_aqed_active_limit_mem_rdata             (i_hqm_list_sel_mem_rf_cfg_qid_aqed_active_limit_mem_rdata),
       .rf_cfg_qid_ldb_inflight_limit_mem_rdata            (i_hqm_list_sel_mem_rf_cfg_qid_ldb_inflight_limit_mem_rdata),
       .rf_cfg_qid_ldb_qid2cqidix2_mem_rdata               (i_hqm_list_sel_mem_rf_cfg_qid_ldb_qid2cqidix2_mem_rdata),
       .rf_cfg_qid_ldb_qid2cqidix_mem_rdata                (i_hqm_list_sel_mem_rf_cfg_qid_ldb_qid2cqidix_mem_rdata),
       .rf_chp_chp_rop_hcw_fifo_mem_rdata                  (i_hqm_system_mem_rf_chp_chp_rop_hcw_fifo_mem_rdata),
       .rf_chp_lsp_ap_cmp_fifo_mem_rdata                   (i_hqm_system_mem_rf_chp_lsp_ap_cmp_fifo_mem_rdata),
       .rf_chp_lsp_cmp_rx_sync_fifo_mem_rdata              (i_hqm_list_sel_mem_rf_chp_lsp_cmp_rx_sync_fifo_mem_rdata),
       .rf_chp_lsp_tok_fifo_mem_rdata                      (i_hqm_system_mem_rf_chp_lsp_tok_fifo_mem_rdata),
       .rf_chp_lsp_token_rx_sync_fifo_mem_rdata            (i_hqm_list_sel_mem_rf_chp_lsp_token_rx_sync_fifo_mem_rdata),
       .rf_chp_sys_tx_fifo_mem_rdata                       (i_hqm_system_mem_rf_chp_sys_tx_fifo_mem_rdata),
       .rf_cmp_id_chk_enbl_mem_rdata                       (i_hqm_system_mem_rf_cmp_id_chk_enbl_mem_rdata),
       .rf_count_rmw_pipe_dir_mem_rdata                    (i_hqm_system_mem_rf_count_rmw_pipe_dir_mem_rdata),
       .rf_count_rmw_pipe_ldb_mem_rdata                    (i_hqm_system_mem_rf_count_rmw_pipe_ldb_mem_rdata),
       .rf_count_rmw_pipe_wd_dir_mem_rdata                 (i_hqm_system_mem_rf_count_rmw_pipe_wd_dir_mem_rdata),
       .rf_count_rmw_pipe_wd_ldb_mem_rdata                 (i_hqm_system_mem_rf_count_rmw_pipe_wd_ldb_mem_rdata),
       .rf_cq_atm_pri_arbindex_mem_rdata                   (i_hqm_list_sel_mem_rf_cq_atm_pri_arbindex_mem_rdata),
       .rf_cq_dir_tot_sch_cnt_mem_rdata                    (i_hqm_list_sel_mem_rf_cq_dir_tot_sch_cnt_mem_rdata),
       .rf_cq_ldb_inflight_count_mem_rdata                 (i_hqm_list_sel_mem_rf_cq_ldb_inflight_count_mem_rdata),
       .rf_cq_ldb_token_count_mem_rdata                    (i_hqm_list_sel_mem_rf_cq_ldb_token_count_mem_rdata),
       .rf_cq_ldb_tot_sch_cnt_mem_rdata                    (i_hqm_list_sel_mem_rf_cq_ldb_tot_sch_cnt_mem_rdata),
       .rf_cq_ldb_wu_count_mem_rdata                       (i_hqm_list_sel_mem_rf_cq_ldb_wu_count_mem_rdata),
       .rf_cq_nalb_pri_arbindex_mem_rdata                  (i_hqm_list_sel_mem_rf_cq_nalb_pri_arbindex_mem_rdata),
       .rf_dir_cnt_rdata                                   (i_hqm_qed_mem_rf_dir_cnt_rdata),
       .rf_dir_cq_depth_rdata                              (i_hqm_system_mem_rf_dir_cq_depth_rdata),
       .rf_dir_cq_intr_thresh_rdata                        (i_hqm_system_mem_rf_dir_cq_intr_thresh_rdata),
       .rf_dir_cq_token_depth_select_rdata                 (i_hqm_system_mem_rf_dir_cq_token_depth_select_rdata),
       .rf_dir_cq_wptr_rdata                               (i_hqm_system_mem_rf_dir_cq_wptr_rdata),
       .rf_dir_enq_cnt_mem_rdata                           (i_hqm_list_sel_mem_rf_dir_enq_cnt_mem_rdata),
       .rf_dir_hp_rdata                                    (i_hqm_qed_mem_rf_dir_hp_rdata),
       .rf_dir_replay_cnt_rdata                            (i_hqm_qed_mem_rf_dir_replay_cnt_rdata),
       .rf_dir_replay_hp_rdata                             (i_hqm_qed_mem_rf_dir_replay_hp_rdata),
       .rf_dir_replay_tp_rdata                             (i_hqm_qed_mem_rf_dir_replay_tp_rdata),
       .rf_dir_rofrag_cnt_rdata                            (i_hqm_qed_mem_rf_dir_rofrag_cnt_rdata),
       .rf_dir_rofrag_hp_rdata                             (i_hqm_qed_mem_rf_dir_rofrag_hp_rdata),
       .rf_dir_rofrag_tp_rdata                             (i_hqm_qed_mem_rf_dir_rofrag_tp_rdata),
       .rf_dir_rply_req_fifo_mem_rdata                     (i_hqm_system_mem_rf_dir_rply_req_fifo_mem_rdata),
       .rf_dir_tok_cnt_mem_rdata                           (i_hqm_list_sel_mem_rf_dir_tok_cnt_mem_rdata),
       .rf_dir_tok_lim_mem_rdata                           (i_hqm_list_sel_mem_rf_dir_tok_lim_mem_rdata),
       .rf_dir_tp_rdata                                    (i_hqm_qed_mem_rf_dir_tp_rdata),
       .rf_dir_wb0_rdata                                   (i_hqm_system_mem_rf_dir_wb0_rdata),
       .rf_dir_wb1_rdata                                   (i_hqm_system_mem_rf_dir_wb1_rdata),
       .rf_dir_wb2_rdata                                   (i_hqm_system_mem_rf_dir_wb2_rdata),
       .rf_dp_dqed_rdata                                   (i_hqm_qed_mem_rf_dp_dqed_rdata),
       .rf_dp_lsp_enq_dir_rdata                            (i_hqm_qed_mem_rf_dp_lsp_enq_dir_rdata),
       .rf_dp_lsp_enq_dir_rx_sync_fifo_mem_rdata           (i_hqm_list_sel_mem_rf_dp_lsp_enq_dir_rx_sync_fifo_mem_rdata),
       .rf_dp_lsp_enq_rorply_rdata                         (i_hqm_qed_mem_rf_dp_lsp_enq_rorply_rdata),
       .rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_rdata        (i_hqm_list_sel_mem_rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_rdata),
       .rf_enq_nalb_fifo_mem_rdata                         (i_hqm_list_sel_mem_rf_enq_nalb_fifo_mem_rdata),
       .rf_fid2cqqidix_rdata                               (i_hqm_list_sel_mem_rf_fid2cqqidix_rdata),
       .rf_hcw_enq_fifo_rdata                              (i_hqm_system_mem_rf_hcw_enq_fifo_rdata),
       .rf_hcw_enq_w_rx_sync_mem_rdata                     (i_hqm_system_mem_rf_hcw_enq_w_rx_sync_mem_rdata),
       .rf_hist_list_a_minmax_rdata                        (i_hqm_system_mem_rf_hist_list_a_minmax_rdata),
       .rf_hist_list_a_ptr_rdata                           (i_hqm_system_mem_rf_hist_list_a_ptr_rdata),
       .rf_hist_list_minmax_rdata                          (i_hqm_system_mem_rf_hist_list_minmax_rdata),
       .rf_hist_list_ptr_rdata                             (i_hqm_system_mem_rf_hist_list_ptr_rdata),
       .rf_ibcpl_data_fifo_rdata                           (i_hqm_system_mem_rf_ibcpl_data_fifo_rdata),
       .rf_ibcpl_hdr_fifo_rdata                            (i_hqm_system_mem_rf_ibcpl_hdr_fifo_rdata),
       .rf_ldb_cq_depth_rdata                              (i_hqm_system_mem_rf_ldb_cq_depth_rdata),
       .rf_ldb_cq_intr_thresh_rdata                        (i_hqm_system_mem_rf_ldb_cq_intr_thresh_rdata),
       .rf_ldb_cq_on_off_threshold_rdata                   (i_hqm_system_mem_rf_ldb_cq_on_off_threshold_rdata),
       .rf_ldb_cq_token_depth_select_rdata                 (i_hqm_system_mem_rf_ldb_cq_token_depth_select_rdata),
       .rf_ldb_cq_wptr_rdata                               (i_hqm_system_mem_rf_ldb_cq_wptr_rdata),
       .rf_ldb_rply_req_fifo_mem_rdata                     (i_hqm_system_mem_rf_ldb_rply_req_fifo_mem_rdata),
       .rf_ldb_token_rtn_fifo_mem_rdata                    (i_hqm_list_sel_mem_rf_ldb_token_rtn_fifo_mem_rdata),
       .rf_ldb_wb0_rdata                                   (i_hqm_system_mem_rf_ldb_wb0_rdata),
       .rf_ldb_wb1_rdata                                   (i_hqm_system_mem_rf_ldb_wb1_rdata),
       .rf_ldb_wb2_rdata                                   (i_hqm_system_mem_rf_ldb_wb2_rdata),
       .rf_ll_enq_cnt_r_bin0_dup0_rdata                    (i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin0_dup0_rdata),
       .rf_ll_enq_cnt_r_bin0_dup1_rdata                    (i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin0_dup1_rdata),
       .rf_ll_enq_cnt_r_bin0_dup2_rdata                    (i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin0_dup2_rdata),
       .rf_ll_enq_cnt_r_bin0_dup3_rdata                    (i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin0_dup3_rdata),
       .rf_ll_enq_cnt_r_bin1_dup0_rdata                    (i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin1_dup0_rdata),
       .rf_ll_enq_cnt_r_bin1_dup1_rdata                    (i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin1_dup1_rdata),
       .rf_ll_enq_cnt_r_bin1_dup2_rdata                    (i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin1_dup2_rdata),
       .rf_ll_enq_cnt_r_bin1_dup3_rdata                    (i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin1_dup3_rdata),
       .rf_ll_enq_cnt_r_bin2_dup0_rdata                    (i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin2_dup0_rdata),
       .rf_ll_enq_cnt_r_bin2_dup1_rdata                    (i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin2_dup1_rdata),
       .rf_ll_enq_cnt_r_bin2_dup2_rdata                    (i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin2_dup2_rdata),
       .rf_ll_enq_cnt_r_bin2_dup3_rdata                    (i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin2_dup3_rdata),
       .rf_ll_enq_cnt_r_bin3_dup0_rdata                    (i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin3_dup0_rdata),
       .rf_ll_enq_cnt_r_bin3_dup1_rdata                    (i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin3_dup1_rdata),
       .rf_ll_enq_cnt_r_bin3_dup2_rdata                    (i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin3_dup2_rdata),
       .rf_ll_enq_cnt_r_bin3_dup3_rdata                    (i_hqm_list_sel_mem_rf_ll_enq_cnt_r_bin3_dup3_rdata),
       .rf_ll_enq_cnt_s_bin0_rdata                         (i_hqm_list_sel_mem_rf_ll_enq_cnt_s_bin0_rdata),
       .rf_ll_enq_cnt_s_bin1_rdata                         (i_hqm_list_sel_mem_rf_ll_enq_cnt_s_bin1_rdata),
       .rf_ll_enq_cnt_s_bin2_rdata                         (i_hqm_list_sel_mem_rf_ll_enq_cnt_s_bin2_rdata),
       .rf_ll_enq_cnt_s_bin3_rdata                         (i_hqm_list_sel_mem_rf_ll_enq_cnt_s_bin3_rdata),
       .rf_ll_rdylst_hp_bin0_rdata                         (i_hqm_list_sel_mem_rf_ll_rdylst_hp_bin0_rdata),
       .rf_ll_rdylst_hp_bin1_rdata                         (i_hqm_list_sel_mem_rf_ll_rdylst_hp_bin1_rdata),
       .rf_ll_rdylst_hp_bin2_rdata                         (i_hqm_list_sel_mem_rf_ll_rdylst_hp_bin2_rdata),
       .rf_ll_rdylst_hp_bin3_rdata                         (i_hqm_list_sel_mem_rf_ll_rdylst_hp_bin3_rdata),
       .rf_ll_rdylst_hpnxt_bin0_rdata                      (i_hqm_list_sel_mem_rf_ll_rdylst_hpnxt_bin0_rdata),
       .rf_ll_rdylst_hpnxt_bin1_rdata                      (i_hqm_list_sel_mem_rf_ll_rdylst_hpnxt_bin1_rdata),
       .rf_ll_rdylst_hpnxt_bin2_rdata                      (i_hqm_list_sel_mem_rf_ll_rdylst_hpnxt_bin2_rdata),
       .rf_ll_rdylst_hpnxt_bin3_rdata                      (i_hqm_list_sel_mem_rf_ll_rdylst_hpnxt_bin3_rdata),
       .rf_ll_rdylst_tp_bin0_rdata                         (i_hqm_list_sel_mem_rf_ll_rdylst_tp_bin0_rdata),
       .rf_ll_rdylst_tp_bin1_rdata                         (i_hqm_list_sel_mem_rf_ll_rdylst_tp_bin1_rdata),
       .rf_ll_rdylst_tp_bin2_rdata                         (i_hqm_list_sel_mem_rf_ll_rdylst_tp_bin2_rdata),
       .rf_ll_rdylst_tp_bin3_rdata                         (i_hqm_list_sel_mem_rf_ll_rdylst_tp_bin3_rdata),
       .rf_ll_rlst_cnt_rdata                               (i_hqm_list_sel_mem_rf_ll_rlst_cnt_rdata),
       .rf_ll_sch_cnt_dup0_rdata                           (i_hqm_list_sel_mem_rf_ll_sch_cnt_dup0_rdata),
       .rf_ll_sch_cnt_dup1_rdata                           (i_hqm_list_sel_mem_rf_ll_sch_cnt_dup1_rdata),
       .rf_ll_sch_cnt_dup2_rdata                           (i_hqm_list_sel_mem_rf_ll_sch_cnt_dup2_rdata),
       .rf_ll_sch_cnt_dup3_rdata                           (i_hqm_list_sel_mem_rf_ll_sch_cnt_dup3_rdata),
       .rf_ll_schlst_hp_bin0_rdata                         (i_hqm_list_sel_mem_rf_ll_schlst_hp_bin0_rdata),
       .rf_ll_schlst_hp_bin1_rdata                         (i_hqm_list_sel_mem_rf_ll_schlst_hp_bin1_rdata),
       .rf_ll_schlst_hp_bin2_rdata                         (i_hqm_list_sel_mem_rf_ll_schlst_hp_bin2_rdata),
       .rf_ll_schlst_hp_bin3_rdata                         (i_hqm_list_sel_mem_rf_ll_schlst_hp_bin3_rdata),
       .rf_ll_schlst_hpnxt_bin0_rdata                      (i_hqm_list_sel_mem_rf_ll_schlst_hpnxt_bin0_rdata),
       .rf_ll_schlst_hpnxt_bin1_rdata                      (i_hqm_list_sel_mem_rf_ll_schlst_hpnxt_bin1_rdata),
       .rf_ll_schlst_hpnxt_bin2_rdata                      (i_hqm_list_sel_mem_rf_ll_schlst_hpnxt_bin2_rdata),
       .rf_ll_schlst_hpnxt_bin3_rdata                      (i_hqm_list_sel_mem_rf_ll_schlst_hpnxt_bin3_rdata),
       .rf_ll_schlst_tp_bin0_rdata                         (i_hqm_list_sel_mem_rf_ll_schlst_tp_bin0_rdata),
       .rf_ll_schlst_tp_bin1_rdata                         (i_hqm_list_sel_mem_rf_ll_schlst_tp_bin1_rdata),
       .rf_ll_schlst_tp_bin2_rdata                         (i_hqm_list_sel_mem_rf_ll_schlst_tp_bin2_rdata),
       .rf_ll_schlst_tp_bin3_rdata                         (i_hqm_list_sel_mem_rf_ll_schlst_tp_bin3_rdata),
       .rf_ll_schlst_tpprv_bin0_rdata                      (i_hqm_list_sel_mem_rf_ll_schlst_tpprv_bin0_rdata),
       .rf_ll_schlst_tpprv_bin1_rdata                      (i_hqm_list_sel_mem_rf_ll_schlst_tpprv_bin1_rdata),
       .rf_ll_schlst_tpprv_bin2_rdata                      (i_hqm_list_sel_mem_rf_ll_schlst_tpprv_bin2_rdata),
       .rf_ll_schlst_tpprv_bin3_rdata                      (i_hqm_list_sel_mem_rf_ll_schlst_tpprv_bin3_rdata),
       .rf_ll_slst_cnt_rdata                               (i_hqm_list_sel_mem_rf_ll_slst_cnt_rdata),
       .rf_lsp_dp_sch_dir_rdata                            (i_hqm_qed_mem_rf_lsp_dp_sch_dir_rdata),
       .rf_lsp_dp_sch_rorply_rdata                         (i_hqm_qed_mem_rf_lsp_dp_sch_rorply_rdata),
       .rf_lsp_nalb_sch_atq_rdata                          (i_hqm_qed_mem_rf_lsp_nalb_sch_atq_rdata),
       .rf_lsp_nalb_sch_rorply_rdata                       (i_hqm_qed_mem_rf_lsp_nalb_sch_rorply_rdata),
       .rf_lsp_nalb_sch_unoord_rdata                       (i_hqm_qed_mem_rf_lsp_nalb_sch_unoord_rdata),
       .rf_lsp_reordercmp_fifo_mem_rdata                   (i_hqm_system_mem_rf_lsp_reordercmp_fifo_mem_rdata),
       .rf_lut_dir_cq2vf_pf_ro_rdata                       (i_hqm_system_mem_rf_lut_dir_cq2vf_pf_ro_rdata),
       .rf_lut_dir_cq_addr_l_rdata                         (i_hqm_system_mem_rf_lut_dir_cq_addr_l_rdata),
       .rf_lut_dir_cq_addr_u_rdata                         (i_hqm_system_mem_rf_lut_dir_cq_addr_u_rdata),
       .rf_lut_dir_cq_ai_addr_l_rdata                      (i_hqm_system_mem_rf_lut_dir_cq_ai_addr_l_rdata),
       .rf_lut_dir_cq_ai_addr_u_rdata                      (i_hqm_system_mem_rf_lut_dir_cq_ai_addr_u_rdata),
       .rf_lut_dir_cq_ai_data_rdata                        (i_hqm_system_mem_rf_lut_dir_cq_ai_data_rdata),
       .rf_lut_dir_cq_isr_rdata                            (i_hqm_system_mem_rf_lut_dir_cq_isr_rdata),
       .rf_lut_dir_cq_pasid_rdata                          (i_hqm_system_mem_rf_lut_dir_cq_pasid_rdata),
       .rf_lut_dir_pp2vas_rdata                            (i_hqm_system_mem_rf_lut_dir_pp2vas_rdata),
       .rf_lut_dir_pp_v_rdata                              (i_hqm_system_mem_rf_lut_dir_pp_v_rdata),
       .rf_lut_dir_vasqid_v_rdata                          (i_hqm_system_mem_rf_lut_dir_vasqid_v_rdata),
       .rf_lut_ldb_cq2vf_pf_ro_rdata                       (i_hqm_system_mem_rf_lut_ldb_cq2vf_pf_ro_rdata),
       .rf_lut_ldb_cq_addr_l_rdata                         (i_hqm_system_mem_rf_lut_ldb_cq_addr_l_rdata),
       .rf_lut_ldb_cq_addr_u_rdata                         (i_hqm_system_mem_rf_lut_ldb_cq_addr_u_rdata),
       .rf_lut_ldb_cq_ai_addr_l_rdata                      (i_hqm_system_mem_rf_lut_ldb_cq_ai_addr_l_rdata),
       .rf_lut_ldb_cq_ai_addr_u_rdata                      (i_hqm_system_mem_rf_lut_ldb_cq_ai_addr_u_rdata),
       .rf_lut_ldb_cq_ai_data_rdata                        (i_hqm_system_mem_rf_lut_ldb_cq_ai_data_rdata),
       .rf_lut_ldb_cq_isr_rdata                            (i_hqm_system_mem_rf_lut_ldb_cq_isr_rdata),
       .rf_lut_ldb_cq_pasid_rdata                          (i_hqm_system_mem_rf_lut_ldb_cq_pasid_rdata),
       .rf_lut_ldb_pp2vas_rdata                            (i_hqm_system_mem_rf_lut_ldb_pp2vas_rdata),
       .rf_lut_ldb_qid2vqid_rdata                          (i_hqm_system_mem_rf_lut_ldb_qid2vqid_rdata),
       .rf_lut_ldb_vasqid_v_rdata                          (i_hqm_system_mem_rf_lut_ldb_vasqid_v_rdata),
       .rf_lut_vf_dir_vpp2pp_rdata                         (i_hqm_system_mem_rf_lut_vf_dir_vpp2pp_rdata),
       .rf_lut_vf_dir_vpp_v_rdata                          (i_hqm_system_mem_rf_lut_vf_dir_vpp_v_rdata),
       .rf_lut_vf_dir_vqid2qid_rdata                       (i_hqm_system_mem_rf_lut_vf_dir_vqid2qid_rdata),
       .rf_lut_vf_dir_vqid_v_rdata                         (i_hqm_system_mem_rf_lut_vf_dir_vqid_v_rdata),
       .rf_lut_vf_ldb_vpp2pp_rdata                         (i_hqm_system_mem_rf_lut_vf_ldb_vpp2pp_rdata),
       .rf_lut_vf_ldb_vpp_v_rdata                          (i_hqm_system_mem_rf_lut_vf_ldb_vpp_v_rdata),
       .rf_lut_vf_ldb_vqid2qid_rdata                       (i_hqm_system_mem_rf_lut_vf_ldb_vqid2qid_rdata),
       .rf_lut_vf_ldb_vqid_v_rdata                         (i_hqm_system_mem_rf_lut_vf_ldb_vqid_v_rdata),
       .rf_msix_tbl_word0_rdata                            (i_hqm_system_mem_rf_msix_tbl_word0_rdata),
       .rf_msix_tbl_word1_rdata                            (i_hqm_system_mem_rf_msix_tbl_word1_rdata),
       .rf_msix_tbl_word2_rdata                            (i_hqm_system_mem_rf_msix_tbl_word2_rdata),
       .rf_mstr_ll_data0_rdata                             (i_hqm_system_mem_rf_mstr_ll_data0_rdata),
       .rf_mstr_ll_data1_rdata                             (i_hqm_system_mem_rf_mstr_ll_data1_rdata),
       .rf_mstr_ll_data2_rdata                             (i_hqm_system_mem_rf_mstr_ll_data2_rdata),
       .rf_mstr_ll_data3_rdata                             (i_hqm_system_mem_rf_mstr_ll_data3_rdata),
       .rf_mstr_ll_hdr_rdata                               (i_hqm_system_mem_rf_mstr_ll_hdr_rdata),
       .rf_mstr_ll_hpa_rdata                               (i_hqm_system_mem_rf_mstr_ll_hpa_rdata),
       .rf_nalb_cmp_fifo_mem_rdata                         (i_hqm_list_sel_mem_rf_nalb_cmp_fifo_mem_rdata),
       .rf_nalb_cnt_rdata                                  (i_hqm_qed_mem_rf_nalb_cnt_rdata),
       .rf_nalb_hp_rdata                                   (i_hqm_qed_mem_rf_nalb_hp_rdata),
       .rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_rdata          (i_hqm_list_sel_mem_rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_rdata),
       .rf_nalb_lsp_enq_rorply_rdata                       (i_hqm_qed_mem_rf_nalb_lsp_enq_rorply_rdata),
       .rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_rdata      (i_hqm_list_sel_mem_rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_rdata),
       .rf_nalb_lsp_enq_unoord_rdata                       (i_hqm_qed_mem_rf_nalb_lsp_enq_unoord_rdata),
       .rf_nalb_qed_rdata                                  (i_hqm_qed_mem_rf_nalb_qed_rdata),
       .rf_nalb_replay_cnt_rdata                           (i_hqm_qed_mem_rf_nalb_replay_cnt_rdata),
       .rf_nalb_replay_hp_rdata                            (i_hqm_qed_mem_rf_nalb_replay_hp_rdata),
       .rf_nalb_replay_tp_rdata                            (i_hqm_qed_mem_rf_nalb_replay_tp_rdata),
       .rf_nalb_rofrag_cnt_rdata                           (i_hqm_qed_mem_rf_nalb_rofrag_cnt_rdata),
       .rf_nalb_rofrag_hp_rdata                            (i_hqm_qed_mem_rf_nalb_rofrag_hp_rdata),
       .rf_nalb_rofrag_tp_rdata                            (i_hqm_qed_mem_rf_nalb_rofrag_tp_rdata),
       .rf_nalb_sel_nalb_fifo_mem_rdata                    (i_hqm_list_sel_mem_rf_nalb_sel_nalb_fifo_mem_rdata),
       .rf_nalb_tp_rdata                                   (i_hqm_qed_mem_rf_nalb_tp_rdata),
       .rf_ord_qid_sn_map_rdata                            (i_hqm_system_mem_rf_ord_qid_sn_map_rdata),
       .rf_ord_qid_sn_rdata                                (i_hqm_system_mem_rf_ord_qid_sn_rdata),
       .rf_outbound_hcw_fifo_mem_rdata                     (i_hqm_system_mem_rf_outbound_hcw_fifo_mem_rdata),
       .rf_qed_chp_sch_data_rdata                          (i_hqm_qed_mem_rf_qed_chp_sch_data_rdata),
       .rf_qed_chp_sch_flid_ret_rx_sync_mem_rdata          (i_hqm_system_mem_rf_qed_chp_sch_flid_ret_rx_sync_mem_rdata),
       .rf_qed_chp_sch_rx_sync_mem_rdata                   (i_hqm_system_mem_rf_qed_chp_sch_rx_sync_mem_rdata),
       .rf_qed_lsp_deq_fifo_mem_rdata                      (i_hqm_list_sel_mem_rf_qed_lsp_deq_fifo_mem_rdata),
       .rf_qed_to_cq_fifo_mem_rdata                        (i_hqm_system_mem_rf_qed_to_cq_fifo_mem_rdata),
       .rf_qid_aqed_active_count_mem_rdata                 (i_hqm_list_sel_mem_rf_qid_aqed_active_count_mem_rdata),
       .rf_qid_atm_active_mem_rdata                        (i_hqm_list_sel_mem_rf_qid_atm_active_mem_rdata),
       .rf_qid_atm_tot_enq_cnt_mem_rdata                   (i_hqm_list_sel_mem_rf_qid_atm_tot_enq_cnt_mem_rdata),
       .rf_qid_atq_enqueue_count_mem_rdata                 (i_hqm_list_sel_mem_rf_qid_atq_enqueue_count_mem_rdata),
       .rf_qid_dir_max_depth_mem_rdata                     (i_hqm_list_sel_mem_rf_qid_dir_max_depth_mem_rdata),
       .rf_qid_dir_replay_count_mem_rdata                  (i_hqm_list_sel_mem_rf_qid_dir_replay_count_mem_rdata),
       .rf_qid_dir_tot_enq_cnt_mem_rdata                   (i_hqm_list_sel_mem_rf_qid_dir_tot_enq_cnt_mem_rdata),
       .rf_qid_ldb_enqueue_count_mem_rdata                 (i_hqm_list_sel_mem_rf_qid_ldb_enqueue_count_mem_rdata),
       .rf_qid_ldb_inflight_count_mem_rdata                (i_hqm_list_sel_mem_rf_qid_ldb_inflight_count_mem_rdata),
       .rf_qid_ldb_replay_count_mem_rdata                  (i_hqm_list_sel_mem_rf_qid_ldb_replay_count_mem_rdata),
       .rf_qid_naldb_max_depth_mem_rdata                   (i_hqm_list_sel_mem_rf_qid_naldb_max_depth_mem_rdata),
       .rf_qid_naldb_tot_enq_cnt_mem_rdata                 (i_hqm_list_sel_mem_rf_qid_naldb_tot_enq_cnt_mem_rdata),
       .rf_qid_rdylst_clamp_rdata                          (i_hqm_list_sel_mem_rf_qid_rdylst_clamp_rdata),
       .rf_reord_cnt_mem_rdata                             (i_hqm_system_mem_rf_reord_cnt_mem_rdata),
       .rf_reord_dirhp_mem_rdata                           (i_hqm_system_mem_rf_reord_dirhp_mem_rdata),
       .rf_reord_dirtp_mem_rdata                           (i_hqm_system_mem_rf_reord_dirtp_mem_rdata),
       .rf_reord_lbhp_mem_rdata                            (i_hqm_system_mem_rf_reord_lbhp_mem_rdata),
       .rf_reord_lbtp_mem_rdata                            (i_hqm_system_mem_rf_reord_lbtp_mem_rdata),
       .rf_reord_st_mem_rdata                              (i_hqm_system_mem_rf_reord_st_mem_rdata),
       .rf_ri_tlq_fifo_npdata_rdata                        (i_hqm_system_mem_rf_ri_tlq_fifo_npdata_rdata),
       .rf_ri_tlq_fifo_nphdr_rdata                         (i_hqm_system_mem_rf_ri_tlq_fifo_nphdr_rdata),
       .rf_ri_tlq_fifo_pdata_rdata                         (i_hqm_system_mem_rf_ri_tlq_fifo_pdata_rdata),
       .rf_ri_tlq_fifo_phdr_rdata                          (i_hqm_system_mem_rf_ri_tlq_fifo_phdr_rdata),
       .rf_rop_chp_rop_hcw_fifo_mem_rdata                  (i_hqm_system_mem_rf_rop_chp_rop_hcw_fifo_mem_rdata),
       .rf_rop_dp_enq_dir_rdata                            (i_hqm_qed_mem_rf_rop_dp_enq_dir_rdata),
       .rf_rop_dp_enq_ro_rdata                             (i_hqm_qed_mem_rf_rop_dp_enq_ro_rdata),
       .rf_rop_lsp_reordercmp_rx_sync_fifo_mem_rdata       (i_hqm_list_sel_mem_rf_rop_lsp_reordercmp_rx_sync_fifo_mem_rdata),
       .rf_rop_nalb_enq_ro_rdata                           (i_hqm_qed_mem_rf_rop_nalb_enq_ro_rdata),
       .rf_rop_nalb_enq_unoord_rdata                       (i_hqm_qed_mem_rf_rop_nalb_enq_unoord_rdata),
       .rf_rx_sync_dp_dqed_data_rdata                      (i_hqm_qed_mem_rf_rx_sync_dp_dqed_data_rdata),
       .rf_rx_sync_lsp_dp_sch_dir_rdata                    (i_hqm_qed_mem_rf_rx_sync_lsp_dp_sch_dir_rdata),
       .rf_rx_sync_lsp_dp_sch_rorply_rdata                 (i_hqm_qed_mem_rf_rx_sync_lsp_dp_sch_rorply_rdata),
       .rf_rx_sync_lsp_nalb_sch_atq_rdata                  (i_hqm_qed_mem_rf_rx_sync_lsp_nalb_sch_atq_rdata),
       .rf_rx_sync_lsp_nalb_sch_rorply_rdata               (i_hqm_qed_mem_rf_rx_sync_lsp_nalb_sch_rorply_rdata),
       .rf_rx_sync_lsp_nalb_sch_unoord_rdata               (i_hqm_qed_mem_rf_rx_sync_lsp_nalb_sch_unoord_rdata),
       .rf_rx_sync_nalb_qed_data_rdata                     (i_hqm_qed_mem_rf_rx_sync_nalb_qed_data_rdata),
       .rf_rx_sync_qed_aqed_enq_rdata                      (i_hqm_list_sel_mem_rf_rx_sync_qed_aqed_enq_rdata),
       .rf_rx_sync_rop_dp_enq_rdata                        (i_hqm_qed_mem_rf_rx_sync_rop_dp_enq_rdata),
       .rf_rx_sync_rop_nalb_enq_rdata                      (i_hqm_qed_mem_rf_rx_sync_rop_nalb_enq_rdata),
       .rf_rx_sync_rop_qed_dqed_enq_rdata                  (i_hqm_qed_mem_rf_rx_sync_rop_qed_dqed_enq_rdata),
       .rf_sch_out_fifo_rdata                              (i_hqm_system_mem_rf_sch_out_fifo_rdata),
       .rf_scrbd_mem_rdata                                 (i_hqm_system_mem_rf_scrbd_mem_rdata),
       .rf_send_atm_to_cq_rx_sync_fifo_mem_rdata           (i_hqm_list_sel_mem_rf_send_atm_to_cq_rx_sync_fifo_mem_rdata),
       .rf_sn0_order_shft_mem_rdata                        (i_hqm_system_mem_rf_sn0_order_shft_mem_rdata),
       .rf_sn1_order_shft_mem_rdata                        (i_hqm_system_mem_rf_sn1_order_shft_mem_rdata),
       .rf_sn_complete_fifo_mem_rdata                      (i_hqm_system_mem_rf_sn_complete_fifo_mem_rdata),
       .rf_sn_ordered_fifo_mem_rdata                       (i_hqm_system_mem_rf_sn_ordered_fifo_mem_rdata),
       .rf_threshold_r_pipe_dir_mem_rdata                  (i_hqm_system_mem_rf_threshold_r_pipe_dir_mem_rdata),
       .rf_threshold_r_pipe_ldb_mem_rdata                  (i_hqm_system_mem_rf_threshold_r_pipe_ldb_mem_rdata),
       .rf_tlb_data0_4k_rdata                              (i_hqm_system_mem_rf_tlb_data0_4k_rdata),
       .rf_tlb_data1_4k_rdata                              (i_hqm_system_mem_rf_tlb_data1_4k_rdata),
       .rf_tlb_data2_4k_rdata                              (i_hqm_system_mem_rf_tlb_data2_4k_rdata),
       .rf_tlb_data3_4k_rdata                              (i_hqm_system_mem_rf_tlb_data3_4k_rdata),
       .rf_tlb_data4_4k_rdata                              (i_hqm_system_mem_rf_tlb_data4_4k_rdata),
       .rf_tlb_data5_4k_rdata                              (i_hqm_system_mem_rf_tlb_data5_4k_rdata),
       .rf_tlb_data6_4k_rdata                              (i_hqm_system_mem_rf_tlb_data6_4k_rdata),
       .rf_tlb_data7_4k_rdata                              (i_hqm_system_mem_rf_tlb_data7_4k_rdata),
       .rf_tlb_tag0_4k_rdata                               (i_hqm_system_mem_rf_tlb_tag0_4k_rdata),
       .rf_tlb_tag1_4k_rdata                               (i_hqm_system_mem_rf_tlb_tag1_4k_rdata),
       .rf_tlb_tag2_4k_rdata                               (i_hqm_system_mem_rf_tlb_tag2_4k_rdata),
       .rf_tlb_tag3_4k_rdata                               (i_hqm_system_mem_rf_tlb_tag3_4k_rdata),
       .rf_tlb_tag4_4k_rdata                               (i_hqm_system_mem_rf_tlb_tag4_4k_rdata),
       .rf_tlb_tag5_4k_rdata                               (i_hqm_system_mem_rf_tlb_tag5_4k_rdata),
       .rf_tlb_tag6_4k_rdata                               (i_hqm_system_mem_rf_tlb_tag6_4k_rdata),
       .rf_tlb_tag7_4k_rdata                               (i_hqm_system_mem_rf_tlb_tag7_4k_rdata),
       .rf_uno_atm_cmp_fifo_mem_rdata                      (i_hqm_list_sel_mem_rf_uno_atm_cmp_fifo_mem_rdata),
       .sr_aqed_freelist_rdata                             (i_hqm_list_sel_mem_sr_aqed_freelist_rdata),
       .sr_aqed_ll_qe_hpnxt_rdata                          (i_hqm_list_sel_mem_sr_aqed_ll_qe_hpnxt_rdata),
       .sr_aqed_rdata                                      (i_hqm_list_sel_mem_sr_aqed_rdata),
       .sr_dir_nxthp_rdata                                 (i_hqm_qed_mem_sr_dir_nxthp_rdata),
       .sr_freelist_0_rdata                                (i_hqm_system_mem_sr_freelist_0_rdata),
       .sr_freelist_1_rdata                                (i_hqm_system_mem_sr_freelist_1_rdata),
       .sr_freelist_2_rdata                                (i_hqm_system_mem_sr_freelist_2_rdata),
       .sr_freelist_3_rdata                                (i_hqm_system_mem_sr_freelist_3_rdata),
       .sr_freelist_4_rdata                                (i_hqm_system_mem_sr_freelist_4_rdata),
       .sr_freelist_5_rdata                                (i_hqm_system_mem_sr_freelist_5_rdata),
       .sr_freelist_6_rdata                                (i_hqm_system_mem_sr_freelist_6_rdata),
       .sr_freelist_7_rdata                                (i_hqm_system_mem_sr_freelist_7_rdata),
       .sr_hist_list_a_rdata                               (i_hqm_system_mem_sr_hist_list_a_rdata),
       .sr_hist_list_rdata                                 (i_hqm_system_mem_sr_hist_list_rdata),
       .sr_nalb_nxthp_rdata                                (i_hqm_qed_mem_sr_nalb_nxthp_rdata),
       .sr_qed_0_rdata                                     (i_hqm_qed_mem_sr_qed_0_rdata),
       .sr_qed_1_rdata                                     (i_hqm_qed_mem_sr_qed_1_rdata),
       .sr_qed_2_rdata                                     (i_hqm_qed_mem_sr_qed_2_rdata),
       .sr_qed_3_rdata                                     (i_hqm_qed_mem_sr_qed_3_rdata),
       .sr_qed_4_rdata                                     (i_hqm_qed_mem_sr_qed_4_rdata),
       .sr_qed_5_rdata                                     (i_hqm_qed_mem_sr_qed_5_rdata),
       .sr_qed_6_rdata                                     (i_hqm_qed_mem_sr_qed_6_rdata),
       .sr_qed_7_rdata                                     (i_hqm_qed_mem_sr_qed_7_rdata),
       .sr_rob_mem_rdata                                   (i_hqm_system_mem_sr_rob_mem_rdata),
       .bcam_AW_bcam_2048x26_cclk                          (i_hqm_sip_bcam_AW_bcam_2048x26_cclk),
       .bcam_AW_bcam_2048x26_cdata                         (i_hqm_sip_bcam_AW_bcam_2048x26_cdata),
       .bcam_AW_bcam_2048x26_ce                            (i_hqm_sip_bcam_AW_bcam_2048x26_ce),
       .bcam_AW_bcam_2048x26_dfx_clk                       (i_hqm_sip_bcam_AW_bcam_2048x26_dfx_clk),
       .bcam_AW_bcam_2048x26_raddr                         (i_hqm_sip_bcam_AW_bcam_2048x26_raddr),
       .bcam_AW_bcam_2048x26_rclk                          (i_hqm_sip_bcam_AW_bcam_2048x26_rclk),
       .bcam_AW_bcam_2048x26_re                            (i_hqm_sip_bcam_AW_bcam_2048x26_re),
       .bcam_AW_bcam_2048x26_waddr                         (i_hqm_sip_bcam_AW_bcam_2048x26_waddr),
       .bcam_AW_bcam_2048x26_wclk                          (i_hqm_sip_bcam_AW_bcam_2048x26_wclk),
       .bcam_AW_bcam_2048x26_wdata                         (i_hqm_sip_bcam_AW_bcam_2048x26_wdata),
       .bcam_AW_bcam_2048x26_we                            (i_hqm_sip_bcam_AW_bcam_2048x26_we),
       .hqm_pwrgood_rst_b                                  (i_hqm_sip_hqm_pwrgood_rst_b),
       .par_mem_pgcb_fet_en_b                              (i_hqm_sip_par_mem_pgcb_fet_en_b),
       .pgcb_isol_en                                       (i_hqm_sip_pgcb_isol_en),
       .pgcb_isol_en_b                                     (i_hqm_sip_pgcb_isol_en_b),
       .rf_alarm_vf_synd0_raddr                            (i_hqm_sip_rf_alarm_vf_synd0_raddr),
       .rf_alarm_vf_synd0_rclk                             (i_hqm_sip_rf_alarm_vf_synd0_rclk),
       .rf_alarm_vf_synd0_rclk_rst_n                       (i_hqm_sip_rf_alarm_vf_synd0_rclk_rst_n),
       .rf_alarm_vf_synd0_re                               (i_hqm_sip_rf_alarm_vf_synd0_re),
       .rf_alarm_vf_synd0_waddr                            (i_hqm_sip_rf_alarm_vf_synd0_waddr),
       .rf_alarm_vf_synd0_wclk                             (i_hqm_sip_rf_alarm_vf_synd0_wclk),
       .rf_alarm_vf_synd0_wclk_rst_n                       (i_hqm_sip_rf_alarm_vf_synd0_wclk_rst_n),
       .rf_alarm_vf_synd0_wdata                            (i_hqm_sip_rf_alarm_vf_synd0_wdata),
       .rf_alarm_vf_synd0_we                               (i_hqm_sip_rf_alarm_vf_synd0_we),
       .rf_alarm_vf_synd1_raddr                            (i_hqm_sip_rf_alarm_vf_synd1_raddr),
       .rf_alarm_vf_synd1_rclk                             (i_hqm_sip_rf_alarm_vf_synd1_rclk),
       .rf_alarm_vf_synd1_rclk_rst_n                       (i_hqm_sip_rf_alarm_vf_synd1_rclk_rst_n),
       .rf_alarm_vf_synd1_re                               (i_hqm_sip_rf_alarm_vf_synd1_re),
       .rf_alarm_vf_synd1_waddr                            (i_hqm_sip_rf_alarm_vf_synd1_waddr),
       .rf_alarm_vf_synd1_wclk                             (i_hqm_sip_rf_alarm_vf_synd1_wclk),
       .rf_alarm_vf_synd1_wclk_rst_n                       (i_hqm_sip_rf_alarm_vf_synd1_wclk_rst_n),
       .rf_alarm_vf_synd1_wdata                            (i_hqm_sip_rf_alarm_vf_synd1_wdata),
       .rf_alarm_vf_synd1_we                               (i_hqm_sip_rf_alarm_vf_synd1_we),
       .rf_alarm_vf_synd2_raddr                            (i_hqm_sip_rf_alarm_vf_synd2_raddr),
       .rf_alarm_vf_synd2_rclk                             (i_hqm_sip_rf_alarm_vf_synd2_rclk),
       .rf_alarm_vf_synd2_rclk_rst_n                       (i_hqm_sip_rf_alarm_vf_synd2_rclk_rst_n),
       .rf_alarm_vf_synd2_re                               (i_hqm_sip_rf_alarm_vf_synd2_re),
       .rf_alarm_vf_synd2_waddr                            (i_hqm_sip_rf_alarm_vf_synd2_waddr),
       .rf_alarm_vf_synd2_wclk                             (i_hqm_sip_rf_alarm_vf_synd2_wclk),
       .rf_alarm_vf_synd2_wclk_rst_n                       (i_hqm_sip_rf_alarm_vf_synd2_wclk_rst_n),
       .rf_alarm_vf_synd2_wdata                            (i_hqm_sip_rf_alarm_vf_synd2_wdata),
       .rf_alarm_vf_synd2_we                               (i_hqm_sip_rf_alarm_vf_synd2_we),
       .rf_aqed_chp_sch_rx_sync_mem_raddr                  (i_hqm_sip_rf_aqed_chp_sch_rx_sync_mem_raddr),
       .rf_aqed_chp_sch_rx_sync_mem_rclk                   (i_hqm_sip_rf_aqed_chp_sch_rx_sync_mem_rclk),
       .rf_aqed_chp_sch_rx_sync_mem_rclk_rst_n             (i_hqm_sip_rf_aqed_chp_sch_rx_sync_mem_rclk_rst_n),
       .rf_aqed_chp_sch_rx_sync_mem_re                     (i_hqm_sip_rf_aqed_chp_sch_rx_sync_mem_re),
       .rf_aqed_chp_sch_rx_sync_mem_waddr                  (i_hqm_sip_rf_aqed_chp_sch_rx_sync_mem_waddr),
       .rf_aqed_chp_sch_rx_sync_mem_wclk                   (i_hqm_sip_rf_aqed_chp_sch_rx_sync_mem_wclk),
       .rf_aqed_chp_sch_rx_sync_mem_wclk_rst_n             (i_hqm_sip_rf_aqed_chp_sch_rx_sync_mem_wclk_rst_n),
       .rf_aqed_chp_sch_rx_sync_mem_wdata                  (i_hqm_sip_rf_aqed_chp_sch_rx_sync_mem_wdata),
       .rf_aqed_chp_sch_rx_sync_mem_we                     (i_hqm_sip_rf_aqed_chp_sch_rx_sync_mem_we),
       .rf_aqed_fid_cnt_raddr                              (i_hqm_sip_rf_aqed_fid_cnt_raddr),
       .rf_aqed_fid_cnt_rclk                               (i_hqm_sip_rf_aqed_fid_cnt_rclk),
       .rf_aqed_fid_cnt_rclk_rst_n                         (i_hqm_sip_rf_aqed_fid_cnt_rclk_rst_n),
       .rf_aqed_fid_cnt_re                                 (i_hqm_sip_rf_aqed_fid_cnt_re),
       .rf_aqed_fid_cnt_waddr                              (i_hqm_sip_rf_aqed_fid_cnt_waddr),
       .rf_aqed_fid_cnt_wclk                               (i_hqm_sip_rf_aqed_fid_cnt_wclk),
       .rf_aqed_fid_cnt_wclk_rst_n                         (i_hqm_sip_rf_aqed_fid_cnt_wclk_rst_n),
       .rf_aqed_fid_cnt_wdata                              (i_hqm_sip_rf_aqed_fid_cnt_wdata),
       .rf_aqed_fid_cnt_we                                 (i_hqm_sip_rf_aqed_fid_cnt_we),
       .rf_aqed_fifo_ap_aqed_raddr                         (i_hqm_sip_rf_aqed_fifo_ap_aqed_raddr),
       .rf_aqed_fifo_ap_aqed_rclk                          (i_hqm_sip_rf_aqed_fifo_ap_aqed_rclk),
       .rf_aqed_fifo_ap_aqed_rclk_rst_n                    (i_hqm_sip_rf_aqed_fifo_ap_aqed_rclk_rst_n),
       .rf_aqed_fifo_ap_aqed_re                            (i_hqm_sip_rf_aqed_fifo_ap_aqed_re),
       .rf_aqed_fifo_ap_aqed_waddr                         (i_hqm_sip_rf_aqed_fifo_ap_aqed_waddr),
       .rf_aqed_fifo_ap_aqed_wclk                          (i_hqm_sip_rf_aqed_fifo_ap_aqed_wclk),
       .rf_aqed_fifo_ap_aqed_wclk_rst_n                    (i_hqm_sip_rf_aqed_fifo_ap_aqed_wclk_rst_n),
       .rf_aqed_fifo_ap_aqed_wdata                         (i_hqm_sip_rf_aqed_fifo_ap_aqed_wdata),
       .rf_aqed_fifo_ap_aqed_we                            (i_hqm_sip_rf_aqed_fifo_ap_aqed_we),
       .rf_aqed_fifo_aqed_ap_enq_raddr                     (i_hqm_sip_rf_aqed_fifo_aqed_ap_enq_raddr),
       .rf_aqed_fifo_aqed_ap_enq_rclk                      (i_hqm_sip_rf_aqed_fifo_aqed_ap_enq_rclk),
       .rf_aqed_fifo_aqed_ap_enq_rclk_rst_n                (i_hqm_sip_rf_aqed_fifo_aqed_ap_enq_rclk_rst_n),
       .rf_aqed_fifo_aqed_ap_enq_re                        (i_hqm_sip_rf_aqed_fifo_aqed_ap_enq_re),
       .rf_aqed_fifo_aqed_ap_enq_waddr                     (i_hqm_sip_rf_aqed_fifo_aqed_ap_enq_waddr),
       .rf_aqed_fifo_aqed_ap_enq_wclk                      (i_hqm_sip_rf_aqed_fifo_aqed_ap_enq_wclk),
       .rf_aqed_fifo_aqed_ap_enq_wclk_rst_n                (i_hqm_sip_rf_aqed_fifo_aqed_ap_enq_wclk_rst_n),
       .rf_aqed_fifo_aqed_ap_enq_wdata                     (i_hqm_sip_rf_aqed_fifo_aqed_ap_enq_wdata),
       .rf_aqed_fifo_aqed_ap_enq_we                        (i_hqm_sip_rf_aqed_fifo_aqed_ap_enq_we),
       .rf_aqed_fifo_aqed_chp_sch_raddr                    (i_hqm_sip_rf_aqed_fifo_aqed_chp_sch_raddr),
       .rf_aqed_fifo_aqed_chp_sch_rclk                     (i_hqm_sip_rf_aqed_fifo_aqed_chp_sch_rclk),
       .rf_aqed_fifo_aqed_chp_sch_rclk_rst_n               (i_hqm_sip_rf_aqed_fifo_aqed_chp_sch_rclk_rst_n),
       .rf_aqed_fifo_aqed_chp_sch_re                       (i_hqm_sip_rf_aqed_fifo_aqed_chp_sch_re),
       .rf_aqed_fifo_aqed_chp_sch_waddr                    (i_hqm_sip_rf_aqed_fifo_aqed_chp_sch_waddr),
       .rf_aqed_fifo_aqed_chp_sch_wclk                     (i_hqm_sip_rf_aqed_fifo_aqed_chp_sch_wclk),
       .rf_aqed_fifo_aqed_chp_sch_wclk_rst_n               (i_hqm_sip_rf_aqed_fifo_aqed_chp_sch_wclk_rst_n),
       .rf_aqed_fifo_aqed_chp_sch_wdata                    (i_hqm_sip_rf_aqed_fifo_aqed_chp_sch_wdata),
       .rf_aqed_fifo_aqed_chp_sch_we                       (i_hqm_sip_rf_aqed_fifo_aqed_chp_sch_we),
       .rf_aqed_fifo_freelist_return_raddr                 (i_hqm_sip_rf_aqed_fifo_freelist_return_raddr),
       .rf_aqed_fifo_freelist_return_rclk                  (i_hqm_sip_rf_aqed_fifo_freelist_return_rclk),
       .rf_aqed_fifo_freelist_return_rclk_rst_n            (i_hqm_sip_rf_aqed_fifo_freelist_return_rclk_rst_n),
       .rf_aqed_fifo_freelist_return_re                    (i_hqm_sip_rf_aqed_fifo_freelist_return_re),
       .rf_aqed_fifo_freelist_return_waddr                 (i_hqm_sip_rf_aqed_fifo_freelist_return_waddr),
       .rf_aqed_fifo_freelist_return_wclk                  (i_hqm_sip_rf_aqed_fifo_freelist_return_wclk),
       .rf_aqed_fifo_freelist_return_wclk_rst_n            (i_hqm_sip_rf_aqed_fifo_freelist_return_wclk_rst_n),
       .rf_aqed_fifo_freelist_return_wdata                 (i_hqm_sip_rf_aqed_fifo_freelist_return_wdata),
       .rf_aqed_fifo_freelist_return_we                    (i_hqm_sip_rf_aqed_fifo_freelist_return_we),
       .rf_aqed_fifo_lsp_aqed_cmp_raddr                    (i_hqm_sip_rf_aqed_fifo_lsp_aqed_cmp_raddr),
       .rf_aqed_fifo_lsp_aqed_cmp_rclk                     (i_hqm_sip_rf_aqed_fifo_lsp_aqed_cmp_rclk),
       .rf_aqed_fifo_lsp_aqed_cmp_rclk_rst_n               (i_hqm_sip_rf_aqed_fifo_lsp_aqed_cmp_rclk_rst_n),
       .rf_aqed_fifo_lsp_aqed_cmp_re                       (i_hqm_sip_rf_aqed_fifo_lsp_aqed_cmp_re),
       .rf_aqed_fifo_lsp_aqed_cmp_waddr                    (i_hqm_sip_rf_aqed_fifo_lsp_aqed_cmp_waddr),
       .rf_aqed_fifo_lsp_aqed_cmp_wclk                     (i_hqm_sip_rf_aqed_fifo_lsp_aqed_cmp_wclk),
       .rf_aqed_fifo_lsp_aqed_cmp_wclk_rst_n               (i_hqm_sip_rf_aqed_fifo_lsp_aqed_cmp_wclk_rst_n),
       .rf_aqed_fifo_lsp_aqed_cmp_wdata                    (i_hqm_sip_rf_aqed_fifo_lsp_aqed_cmp_wdata),
       .rf_aqed_fifo_lsp_aqed_cmp_we                       (i_hqm_sip_rf_aqed_fifo_lsp_aqed_cmp_we),
       .rf_aqed_fifo_qed_aqed_enq_fid_raddr                (i_hqm_sip_rf_aqed_fifo_qed_aqed_enq_fid_raddr),
       .rf_aqed_fifo_qed_aqed_enq_fid_rclk                 (i_hqm_sip_rf_aqed_fifo_qed_aqed_enq_fid_rclk),
       .rf_aqed_fifo_qed_aqed_enq_fid_rclk_rst_n           (i_hqm_sip_rf_aqed_fifo_qed_aqed_enq_fid_rclk_rst_n),
       .rf_aqed_fifo_qed_aqed_enq_fid_re                   (i_hqm_sip_rf_aqed_fifo_qed_aqed_enq_fid_re),
       .rf_aqed_fifo_qed_aqed_enq_fid_waddr                (i_hqm_sip_rf_aqed_fifo_qed_aqed_enq_fid_waddr),
       .rf_aqed_fifo_qed_aqed_enq_fid_wclk                 (i_hqm_sip_rf_aqed_fifo_qed_aqed_enq_fid_wclk),
       .rf_aqed_fifo_qed_aqed_enq_fid_wclk_rst_n           (i_hqm_sip_rf_aqed_fifo_qed_aqed_enq_fid_wclk_rst_n),
       .rf_aqed_fifo_qed_aqed_enq_fid_wdata                (i_hqm_sip_rf_aqed_fifo_qed_aqed_enq_fid_wdata),
       .rf_aqed_fifo_qed_aqed_enq_fid_we                   (i_hqm_sip_rf_aqed_fifo_qed_aqed_enq_fid_we),
       .rf_aqed_fifo_qed_aqed_enq_raddr                    (i_hqm_sip_rf_aqed_fifo_qed_aqed_enq_raddr),
       .rf_aqed_fifo_qed_aqed_enq_rclk                     (i_hqm_sip_rf_aqed_fifo_qed_aqed_enq_rclk),
       .rf_aqed_fifo_qed_aqed_enq_rclk_rst_n               (i_hqm_sip_rf_aqed_fifo_qed_aqed_enq_rclk_rst_n),
       .rf_aqed_fifo_qed_aqed_enq_re                       (i_hqm_sip_rf_aqed_fifo_qed_aqed_enq_re),
       .rf_aqed_fifo_qed_aqed_enq_waddr                    (i_hqm_sip_rf_aqed_fifo_qed_aqed_enq_waddr),
       .rf_aqed_fifo_qed_aqed_enq_wclk                     (i_hqm_sip_rf_aqed_fifo_qed_aqed_enq_wclk),
       .rf_aqed_fifo_qed_aqed_enq_wclk_rst_n               (i_hqm_sip_rf_aqed_fifo_qed_aqed_enq_wclk_rst_n),
       .rf_aqed_fifo_qed_aqed_enq_wdata                    (i_hqm_sip_rf_aqed_fifo_qed_aqed_enq_wdata),
       .rf_aqed_fifo_qed_aqed_enq_we                       (i_hqm_sip_rf_aqed_fifo_qed_aqed_enq_we),
       .rf_aqed_ll_cnt_pri0_raddr                          (i_hqm_sip_rf_aqed_ll_cnt_pri0_raddr),
       .rf_aqed_ll_cnt_pri0_rclk                           (i_hqm_sip_rf_aqed_ll_cnt_pri0_rclk),
       .rf_aqed_ll_cnt_pri0_rclk_rst_n                     (i_hqm_sip_rf_aqed_ll_cnt_pri0_rclk_rst_n),
       .rf_aqed_ll_cnt_pri0_re                             (i_hqm_sip_rf_aqed_ll_cnt_pri0_re),
       .rf_aqed_ll_cnt_pri0_waddr                          (i_hqm_sip_rf_aqed_ll_cnt_pri0_waddr),
       .rf_aqed_ll_cnt_pri0_wclk                           (i_hqm_sip_rf_aqed_ll_cnt_pri0_wclk),
       .rf_aqed_ll_cnt_pri0_wclk_rst_n                     (i_hqm_sip_rf_aqed_ll_cnt_pri0_wclk_rst_n),
       .rf_aqed_ll_cnt_pri0_wdata                          (i_hqm_sip_rf_aqed_ll_cnt_pri0_wdata),
       .rf_aqed_ll_cnt_pri0_we                             (i_hqm_sip_rf_aqed_ll_cnt_pri0_we),
       .rf_aqed_ll_cnt_pri1_raddr                          (i_hqm_sip_rf_aqed_ll_cnt_pri1_raddr),
       .rf_aqed_ll_cnt_pri1_rclk                           (i_hqm_sip_rf_aqed_ll_cnt_pri1_rclk),
       .rf_aqed_ll_cnt_pri1_rclk_rst_n                     (i_hqm_sip_rf_aqed_ll_cnt_pri1_rclk_rst_n),
       .rf_aqed_ll_cnt_pri1_re                             (i_hqm_sip_rf_aqed_ll_cnt_pri1_re),
       .rf_aqed_ll_cnt_pri1_waddr                          (i_hqm_sip_rf_aqed_ll_cnt_pri1_waddr),
       .rf_aqed_ll_cnt_pri1_wclk                           (i_hqm_sip_rf_aqed_ll_cnt_pri1_wclk),
       .rf_aqed_ll_cnt_pri1_wclk_rst_n                     (i_hqm_sip_rf_aqed_ll_cnt_pri1_wclk_rst_n),
       .rf_aqed_ll_cnt_pri1_wdata                          (i_hqm_sip_rf_aqed_ll_cnt_pri1_wdata),
       .rf_aqed_ll_cnt_pri1_we                             (i_hqm_sip_rf_aqed_ll_cnt_pri1_we),
       .rf_aqed_ll_cnt_pri2_raddr                          (i_hqm_sip_rf_aqed_ll_cnt_pri2_raddr),
       .rf_aqed_ll_cnt_pri2_rclk                           (i_hqm_sip_rf_aqed_ll_cnt_pri2_rclk),
       .rf_aqed_ll_cnt_pri2_rclk_rst_n                     (i_hqm_sip_rf_aqed_ll_cnt_pri2_rclk_rst_n),
       .rf_aqed_ll_cnt_pri2_re                             (i_hqm_sip_rf_aqed_ll_cnt_pri2_re),
       .rf_aqed_ll_cnt_pri2_waddr                          (i_hqm_sip_rf_aqed_ll_cnt_pri2_waddr),
       .rf_aqed_ll_cnt_pri2_wclk                           (i_hqm_sip_rf_aqed_ll_cnt_pri2_wclk),
       .rf_aqed_ll_cnt_pri2_wclk_rst_n                     (i_hqm_sip_rf_aqed_ll_cnt_pri2_wclk_rst_n),
       .rf_aqed_ll_cnt_pri2_wdata                          (i_hqm_sip_rf_aqed_ll_cnt_pri2_wdata),
       .rf_aqed_ll_cnt_pri2_we                             (i_hqm_sip_rf_aqed_ll_cnt_pri2_we),
       .rf_aqed_ll_cnt_pri3_raddr                          (i_hqm_sip_rf_aqed_ll_cnt_pri3_raddr),
       .rf_aqed_ll_cnt_pri3_rclk                           (i_hqm_sip_rf_aqed_ll_cnt_pri3_rclk),
       .rf_aqed_ll_cnt_pri3_rclk_rst_n                     (i_hqm_sip_rf_aqed_ll_cnt_pri3_rclk_rst_n),
       .rf_aqed_ll_cnt_pri3_re                             (i_hqm_sip_rf_aqed_ll_cnt_pri3_re),
       .rf_aqed_ll_cnt_pri3_waddr                          (i_hqm_sip_rf_aqed_ll_cnt_pri3_waddr),
       .rf_aqed_ll_cnt_pri3_wclk                           (i_hqm_sip_rf_aqed_ll_cnt_pri3_wclk),
       .rf_aqed_ll_cnt_pri3_wclk_rst_n                     (i_hqm_sip_rf_aqed_ll_cnt_pri3_wclk_rst_n),
       .rf_aqed_ll_cnt_pri3_wdata                          (i_hqm_sip_rf_aqed_ll_cnt_pri3_wdata),
       .rf_aqed_ll_cnt_pri3_we                             (i_hqm_sip_rf_aqed_ll_cnt_pri3_we),
       .rf_aqed_ll_qe_hp_pri0_raddr                        (i_hqm_sip_rf_aqed_ll_qe_hp_pri0_raddr),
       .rf_aqed_ll_qe_hp_pri0_rclk                         (i_hqm_sip_rf_aqed_ll_qe_hp_pri0_rclk),
       .rf_aqed_ll_qe_hp_pri0_rclk_rst_n                   (i_hqm_sip_rf_aqed_ll_qe_hp_pri0_rclk_rst_n),
       .rf_aqed_ll_qe_hp_pri0_re                           (i_hqm_sip_rf_aqed_ll_qe_hp_pri0_re),
       .rf_aqed_ll_qe_hp_pri0_waddr                        (i_hqm_sip_rf_aqed_ll_qe_hp_pri0_waddr),
       .rf_aqed_ll_qe_hp_pri0_wclk                         (i_hqm_sip_rf_aqed_ll_qe_hp_pri0_wclk),
       .rf_aqed_ll_qe_hp_pri0_wclk_rst_n                   (i_hqm_sip_rf_aqed_ll_qe_hp_pri0_wclk_rst_n),
       .rf_aqed_ll_qe_hp_pri0_wdata                        (i_hqm_sip_rf_aqed_ll_qe_hp_pri0_wdata),
       .rf_aqed_ll_qe_hp_pri0_we                           (i_hqm_sip_rf_aqed_ll_qe_hp_pri0_we),
       .rf_aqed_ll_qe_hp_pri1_raddr                        (i_hqm_sip_rf_aqed_ll_qe_hp_pri1_raddr),
       .rf_aqed_ll_qe_hp_pri1_rclk                         (i_hqm_sip_rf_aqed_ll_qe_hp_pri1_rclk),
       .rf_aqed_ll_qe_hp_pri1_rclk_rst_n                   (i_hqm_sip_rf_aqed_ll_qe_hp_pri1_rclk_rst_n),
       .rf_aqed_ll_qe_hp_pri1_re                           (i_hqm_sip_rf_aqed_ll_qe_hp_pri1_re),
       .rf_aqed_ll_qe_hp_pri1_waddr                        (i_hqm_sip_rf_aqed_ll_qe_hp_pri1_waddr),
       .rf_aqed_ll_qe_hp_pri1_wclk                         (i_hqm_sip_rf_aqed_ll_qe_hp_pri1_wclk),
       .rf_aqed_ll_qe_hp_pri1_wclk_rst_n                   (i_hqm_sip_rf_aqed_ll_qe_hp_pri1_wclk_rst_n),
       .rf_aqed_ll_qe_hp_pri1_wdata                        (i_hqm_sip_rf_aqed_ll_qe_hp_pri1_wdata),
       .rf_aqed_ll_qe_hp_pri1_we                           (i_hqm_sip_rf_aqed_ll_qe_hp_pri1_we),
       .rf_aqed_ll_qe_hp_pri2_raddr                        (i_hqm_sip_rf_aqed_ll_qe_hp_pri2_raddr),
       .rf_aqed_ll_qe_hp_pri2_rclk                         (i_hqm_sip_rf_aqed_ll_qe_hp_pri2_rclk),
       .rf_aqed_ll_qe_hp_pri2_rclk_rst_n                   (i_hqm_sip_rf_aqed_ll_qe_hp_pri2_rclk_rst_n),
       .rf_aqed_ll_qe_hp_pri2_re                           (i_hqm_sip_rf_aqed_ll_qe_hp_pri2_re),
       .rf_aqed_ll_qe_hp_pri2_waddr                        (i_hqm_sip_rf_aqed_ll_qe_hp_pri2_waddr),
       .rf_aqed_ll_qe_hp_pri2_wclk                         (i_hqm_sip_rf_aqed_ll_qe_hp_pri2_wclk),
       .rf_aqed_ll_qe_hp_pri2_wclk_rst_n                   (i_hqm_sip_rf_aqed_ll_qe_hp_pri2_wclk_rst_n),
       .rf_aqed_ll_qe_hp_pri2_wdata                        (i_hqm_sip_rf_aqed_ll_qe_hp_pri2_wdata),
       .rf_aqed_ll_qe_hp_pri2_we                           (i_hqm_sip_rf_aqed_ll_qe_hp_pri2_we),
       .rf_aqed_ll_qe_hp_pri3_raddr                        (i_hqm_sip_rf_aqed_ll_qe_hp_pri3_raddr),
       .rf_aqed_ll_qe_hp_pri3_rclk                         (i_hqm_sip_rf_aqed_ll_qe_hp_pri3_rclk),
       .rf_aqed_ll_qe_hp_pri3_rclk_rst_n                   (i_hqm_sip_rf_aqed_ll_qe_hp_pri3_rclk_rst_n),
       .rf_aqed_ll_qe_hp_pri3_re                           (i_hqm_sip_rf_aqed_ll_qe_hp_pri3_re),
       .rf_aqed_ll_qe_hp_pri3_waddr                        (i_hqm_sip_rf_aqed_ll_qe_hp_pri3_waddr),
       .rf_aqed_ll_qe_hp_pri3_wclk                         (i_hqm_sip_rf_aqed_ll_qe_hp_pri3_wclk),
       .rf_aqed_ll_qe_hp_pri3_wclk_rst_n                   (i_hqm_sip_rf_aqed_ll_qe_hp_pri3_wclk_rst_n),
       .rf_aqed_ll_qe_hp_pri3_wdata                        (i_hqm_sip_rf_aqed_ll_qe_hp_pri3_wdata),
       .rf_aqed_ll_qe_hp_pri3_we                           (i_hqm_sip_rf_aqed_ll_qe_hp_pri3_we),
       .rf_aqed_ll_qe_tp_pri0_raddr                        (i_hqm_sip_rf_aqed_ll_qe_tp_pri0_raddr),
       .rf_aqed_ll_qe_tp_pri0_rclk                         (i_hqm_sip_rf_aqed_ll_qe_tp_pri0_rclk),
       .rf_aqed_ll_qe_tp_pri0_rclk_rst_n                   (i_hqm_sip_rf_aqed_ll_qe_tp_pri0_rclk_rst_n),
       .rf_aqed_ll_qe_tp_pri0_re                           (i_hqm_sip_rf_aqed_ll_qe_tp_pri0_re),
       .rf_aqed_ll_qe_tp_pri0_waddr                        (i_hqm_sip_rf_aqed_ll_qe_tp_pri0_waddr),
       .rf_aqed_ll_qe_tp_pri0_wclk                         (i_hqm_sip_rf_aqed_ll_qe_tp_pri0_wclk),
       .rf_aqed_ll_qe_tp_pri0_wclk_rst_n                   (i_hqm_sip_rf_aqed_ll_qe_tp_pri0_wclk_rst_n),
       .rf_aqed_ll_qe_tp_pri0_wdata                        (i_hqm_sip_rf_aqed_ll_qe_tp_pri0_wdata),
       .rf_aqed_ll_qe_tp_pri0_we                           (i_hqm_sip_rf_aqed_ll_qe_tp_pri0_we),
       .rf_aqed_ll_qe_tp_pri1_raddr                        (i_hqm_sip_rf_aqed_ll_qe_tp_pri1_raddr),
       .rf_aqed_ll_qe_tp_pri1_rclk                         (i_hqm_sip_rf_aqed_ll_qe_tp_pri1_rclk),
       .rf_aqed_ll_qe_tp_pri1_rclk_rst_n                   (i_hqm_sip_rf_aqed_ll_qe_tp_pri1_rclk_rst_n),
       .rf_aqed_ll_qe_tp_pri1_re                           (i_hqm_sip_rf_aqed_ll_qe_tp_pri1_re),
       .rf_aqed_ll_qe_tp_pri1_waddr                        (i_hqm_sip_rf_aqed_ll_qe_tp_pri1_waddr),
       .rf_aqed_ll_qe_tp_pri1_wclk                         (i_hqm_sip_rf_aqed_ll_qe_tp_pri1_wclk),
       .rf_aqed_ll_qe_tp_pri1_wclk_rst_n                   (i_hqm_sip_rf_aqed_ll_qe_tp_pri1_wclk_rst_n),
       .rf_aqed_ll_qe_tp_pri1_wdata                        (i_hqm_sip_rf_aqed_ll_qe_tp_pri1_wdata),
       .rf_aqed_ll_qe_tp_pri1_we                           (i_hqm_sip_rf_aqed_ll_qe_tp_pri1_we),
       .rf_aqed_ll_qe_tp_pri2_raddr                        (i_hqm_sip_rf_aqed_ll_qe_tp_pri2_raddr),
       .rf_aqed_ll_qe_tp_pri2_rclk                         (i_hqm_sip_rf_aqed_ll_qe_tp_pri2_rclk),
       .rf_aqed_ll_qe_tp_pri2_rclk_rst_n                   (i_hqm_sip_rf_aqed_ll_qe_tp_pri2_rclk_rst_n),
       .rf_aqed_ll_qe_tp_pri2_re                           (i_hqm_sip_rf_aqed_ll_qe_tp_pri2_re),
       .rf_aqed_ll_qe_tp_pri2_waddr                        (i_hqm_sip_rf_aqed_ll_qe_tp_pri2_waddr),
       .rf_aqed_ll_qe_tp_pri2_wclk                         (i_hqm_sip_rf_aqed_ll_qe_tp_pri2_wclk),
       .rf_aqed_ll_qe_tp_pri2_wclk_rst_n                   (i_hqm_sip_rf_aqed_ll_qe_tp_pri2_wclk_rst_n),
       .rf_aqed_ll_qe_tp_pri2_wdata                        (i_hqm_sip_rf_aqed_ll_qe_tp_pri2_wdata),
       .rf_aqed_ll_qe_tp_pri2_we                           (i_hqm_sip_rf_aqed_ll_qe_tp_pri2_we),
       .rf_aqed_ll_qe_tp_pri3_raddr                        (i_hqm_sip_rf_aqed_ll_qe_tp_pri3_raddr),
       .rf_aqed_ll_qe_tp_pri3_rclk                         (i_hqm_sip_rf_aqed_ll_qe_tp_pri3_rclk),
       .rf_aqed_ll_qe_tp_pri3_rclk_rst_n                   (i_hqm_sip_rf_aqed_ll_qe_tp_pri3_rclk_rst_n),
       .rf_aqed_ll_qe_tp_pri3_re                           (i_hqm_sip_rf_aqed_ll_qe_tp_pri3_re),
       .rf_aqed_ll_qe_tp_pri3_waddr                        (i_hqm_sip_rf_aqed_ll_qe_tp_pri3_waddr),
       .rf_aqed_ll_qe_tp_pri3_wclk                         (i_hqm_sip_rf_aqed_ll_qe_tp_pri3_wclk),
       .rf_aqed_ll_qe_tp_pri3_wclk_rst_n                   (i_hqm_sip_rf_aqed_ll_qe_tp_pri3_wclk_rst_n),
       .rf_aqed_ll_qe_tp_pri3_wdata                        (i_hqm_sip_rf_aqed_ll_qe_tp_pri3_wdata),
       .rf_aqed_ll_qe_tp_pri3_we                           (i_hqm_sip_rf_aqed_ll_qe_tp_pri3_we),
       .rf_aqed_lsp_deq_fifo_mem_raddr                     (i_hqm_sip_rf_aqed_lsp_deq_fifo_mem_raddr),
       .rf_aqed_lsp_deq_fifo_mem_rclk                      (i_hqm_sip_rf_aqed_lsp_deq_fifo_mem_rclk),
       .rf_aqed_lsp_deq_fifo_mem_rclk_rst_n                (i_hqm_sip_rf_aqed_lsp_deq_fifo_mem_rclk_rst_n),
       .rf_aqed_lsp_deq_fifo_mem_re                        (i_hqm_sip_rf_aqed_lsp_deq_fifo_mem_re),
       .rf_aqed_lsp_deq_fifo_mem_waddr                     (i_hqm_sip_rf_aqed_lsp_deq_fifo_mem_waddr),
       .rf_aqed_lsp_deq_fifo_mem_wclk                      (i_hqm_sip_rf_aqed_lsp_deq_fifo_mem_wclk),
       .rf_aqed_lsp_deq_fifo_mem_wclk_rst_n                (i_hqm_sip_rf_aqed_lsp_deq_fifo_mem_wclk_rst_n),
       .rf_aqed_lsp_deq_fifo_mem_wdata                     (i_hqm_sip_rf_aqed_lsp_deq_fifo_mem_wdata),
       .rf_aqed_lsp_deq_fifo_mem_we                        (i_hqm_sip_rf_aqed_lsp_deq_fifo_mem_we),
       .rf_aqed_qid2cqidix_raddr                           (i_hqm_sip_rf_aqed_qid2cqidix_raddr),
       .rf_aqed_qid2cqidix_rclk                            (i_hqm_sip_rf_aqed_qid2cqidix_rclk),
       .rf_aqed_qid2cqidix_rclk_rst_n                      (i_hqm_sip_rf_aqed_qid2cqidix_rclk_rst_n),
       .rf_aqed_qid2cqidix_re                              (i_hqm_sip_rf_aqed_qid2cqidix_re),
       .rf_aqed_qid2cqidix_waddr                           (i_hqm_sip_rf_aqed_qid2cqidix_waddr),
       .rf_aqed_qid2cqidix_wclk                            (i_hqm_sip_rf_aqed_qid2cqidix_wclk),
       .rf_aqed_qid2cqidix_wclk_rst_n                      (i_hqm_sip_rf_aqed_qid2cqidix_wclk_rst_n),
       .rf_aqed_qid2cqidix_wdata                           (i_hqm_sip_rf_aqed_qid2cqidix_wdata),
       .rf_aqed_qid2cqidix_we                              (i_hqm_sip_rf_aqed_qid2cqidix_we),
       .rf_aqed_qid_cnt_raddr                              (i_hqm_sip_rf_aqed_qid_cnt_raddr),
       .rf_aqed_qid_cnt_rclk                               (i_hqm_sip_rf_aqed_qid_cnt_rclk),
       .rf_aqed_qid_cnt_rclk_rst_n                         (i_hqm_sip_rf_aqed_qid_cnt_rclk_rst_n),
       .rf_aqed_qid_cnt_re                                 (i_hqm_sip_rf_aqed_qid_cnt_re),
       .rf_aqed_qid_cnt_waddr                              (i_hqm_sip_rf_aqed_qid_cnt_waddr),
       .rf_aqed_qid_cnt_wclk                               (i_hqm_sip_rf_aqed_qid_cnt_wclk),
       .rf_aqed_qid_cnt_wclk_rst_n                         (i_hqm_sip_rf_aqed_qid_cnt_wclk_rst_n),
       .rf_aqed_qid_cnt_wdata                              (i_hqm_sip_rf_aqed_qid_cnt_wdata),
       .rf_aqed_qid_cnt_we                                 (i_hqm_sip_rf_aqed_qid_cnt_we),
       .rf_aqed_qid_fid_limit_raddr                        (i_hqm_sip_rf_aqed_qid_fid_limit_raddr),
       .rf_aqed_qid_fid_limit_rclk                         (i_hqm_sip_rf_aqed_qid_fid_limit_rclk),
       .rf_aqed_qid_fid_limit_rclk_rst_n                   (i_hqm_sip_rf_aqed_qid_fid_limit_rclk_rst_n),
       .rf_aqed_qid_fid_limit_re                           (i_hqm_sip_rf_aqed_qid_fid_limit_re),
       .rf_aqed_qid_fid_limit_waddr                        (i_hqm_sip_rf_aqed_qid_fid_limit_waddr),
       .rf_aqed_qid_fid_limit_wclk                         (i_hqm_sip_rf_aqed_qid_fid_limit_wclk),
       .rf_aqed_qid_fid_limit_wclk_rst_n                   (i_hqm_sip_rf_aqed_qid_fid_limit_wclk_rst_n),
       .rf_aqed_qid_fid_limit_wdata                        (i_hqm_sip_rf_aqed_qid_fid_limit_wdata),
       .rf_aqed_qid_fid_limit_we                           (i_hqm_sip_rf_aqed_qid_fid_limit_we),
       .rf_atm_cmp_fifo_mem_raddr                          (i_hqm_sip_rf_atm_cmp_fifo_mem_raddr),
       .rf_atm_cmp_fifo_mem_rclk                           (i_hqm_sip_rf_atm_cmp_fifo_mem_rclk),
       .rf_atm_cmp_fifo_mem_rclk_rst_n                     (i_hqm_sip_rf_atm_cmp_fifo_mem_rclk_rst_n),
       .rf_atm_cmp_fifo_mem_re                             (i_hqm_sip_rf_atm_cmp_fifo_mem_re),
       .rf_atm_cmp_fifo_mem_waddr                          (i_hqm_sip_rf_atm_cmp_fifo_mem_waddr),
       .rf_atm_cmp_fifo_mem_wclk                           (i_hqm_sip_rf_atm_cmp_fifo_mem_wclk),
       .rf_atm_cmp_fifo_mem_wclk_rst_n                     (i_hqm_sip_rf_atm_cmp_fifo_mem_wclk_rst_n),
       .rf_atm_cmp_fifo_mem_wdata                          (i_hqm_sip_rf_atm_cmp_fifo_mem_wdata),
       .rf_atm_cmp_fifo_mem_we                             (i_hqm_sip_rf_atm_cmp_fifo_mem_we),
       .rf_atm_fifo_ap_aqed_raddr                          (i_hqm_sip_rf_atm_fifo_ap_aqed_raddr),
       .rf_atm_fifo_ap_aqed_rclk                           (i_hqm_sip_rf_atm_fifo_ap_aqed_rclk),
       .rf_atm_fifo_ap_aqed_rclk_rst_n                     (i_hqm_sip_rf_atm_fifo_ap_aqed_rclk_rst_n),
       .rf_atm_fifo_ap_aqed_re                             (i_hqm_sip_rf_atm_fifo_ap_aqed_re),
       .rf_atm_fifo_ap_aqed_waddr                          (i_hqm_sip_rf_atm_fifo_ap_aqed_waddr),
       .rf_atm_fifo_ap_aqed_wclk                           (i_hqm_sip_rf_atm_fifo_ap_aqed_wclk),
       .rf_atm_fifo_ap_aqed_wclk_rst_n                     (i_hqm_sip_rf_atm_fifo_ap_aqed_wclk_rst_n),
       .rf_atm_fifo_ap_aqed_wdata                          (i_hqm_sip_rf_atm_fifo_ap_aqed_wdata),
       .rf_atm_fifo_ap_aqed_we                             (i_hqm_sip_rf_atm_fifo_ap_aqed_we),
       .rf_atm_fifo_aqed_ap_enq_raddr                      (i_hqm_sip_rf_atm_fifo_aqed_ap_enq_raddr),
       .rf_atm_fifo_aqed_ap_enq_rclk                       (i_hqm_sip_rf_atm_fifo_aqed_ap_enq_rclk),
       .rf_atm_fifo_aqed_ap_enq_rclk_rst_n                 (i_hqm_sip_rf_atm_fifo_aqed_ap_enq_rclk_rst_n),
       .rf_atm_fifo_aqed_ap_enq_re                         (i_hqm_sip_rf_atm_fifo_aqed_ap_enq_re),
       .rf_atm_fifo_aqed_ap_enq_waddr                      (i_hqm_sip_rf_atm_fifo_aqed_ap_enq_waddr),
       .rf_atm_fifo_aqed_ap_enq_wclk                       (i_hqm_sip_rf_atm_fifo_aqed_ap_enq_wclk),
       .rf_atm_fifo_aqed_ap_enq_wclk_rst_n                 (i_hqm_sip_rf_atm_fifo_aqed_ap_enq_wclk_rst_n),
       .rf_atm_fifo_aqed_ap_enq_wdata                      (i_hqm_sip_rf_atm_fifo_aqed_ap_enq_wdata),
       .rf_atm_fifo_aqed_ap_enq_we                         (i_hqm_sip_rf_atm_fifo_aqed_ap_enq_we),
       .rf_atq_cnt_raddr                                   (i_hqm_sip_rf_atq_cnt_raddr),
       .rf_atq_cnt_rclk                                    (i_hqm_sip_rf_atq_cnt_rclk),
       .rf_atq_cnt_rclk_rst_n                              (i_hqm_sip_rf_atq_cnt_rclk_rst_n),
       .rf_atq_cnt_re                                      (i_hqm_sip_rf_atq_cnt_re),
       .rf_atq_cnt_waddr                                   (i_hqm_sip_rf_atq_cnt_waddr),
       .rf_atq_cnt_wclk                                    (i_hqm_sip_rf_atq_cnt_wclk),
       .rf_atq_cnt_wclk_rst_n                              (i_hqm_sip_rf_atq_cnt_wclk_rst_n),
       .rf_atq_cnt_wdata                                   (i_hqm_sip_rf_atq_cnt_wdata),
       .rf_atq_cnt_we                                      (i_hqm_sip_rf_atq_cnt_we),
       .rf_atq_hp_raddr                                    (i_hqm_sip_rf_atq_hp_raddr),
       .rf_atq_hp_rclk                                     (i_hqm_sip_rf_atq_hp_rclk),
       .rf_atq_hp_rclk_rst_n                               (i_hqm_sip_rf_atq_hp_rclk_rst_n),
       .rf_atq_hp_re                                       (i_hqm_sip_rf_atq_hp_re),
       .rf_atq_hp_waddr                                    (i_hqm_sip_rf_atq_hp_waddr),
       .rf_atq_hp_wclk                                     (i_hqm_sip_rf_atq_hp_wclk),
       .rf_atq_hp_wclk_rst_n                               (i_hqm_sip_rf_atq_hp_wclk_rst_n),
       .rf_atq_hp_wdata                                    (i_hqm_sip_rf_atq_hp_wdata),
       .rf_atq_hp_we                                       (i_hqm_sip_rf_atq_hp_we),
       .rf_atq_tp_raddr                                    (i_hqm_sip_rf_atq_tp_raddr),
       .rf_atq_tp_rclk                                     (i_hqm_sip_rf_atq_tp_rclk),
       .rf_atq_tp_rclk_rst_n                               (i_hqm_sip_rf_atq_tp_rclk_rst_n),
       .rf_atq_tp_re                                       (i_hqm_sip_rf_atq_tp_re),
       .rf_atq_tp_waddr                                    (i_hqm_sip_rf_atq_tp_waddr),
       .rf_atq_tp_wclk                                     (i_hqm_sip_rf_atq_tp_wclk),
       .rf_atq_tp_wclk_rst_n                               (i_hqm_sip_rf_atq_tp_wclk_rst_n),
       .rf_atq_tp_wdata                                    (i_hqm_sip_rf_atq_tp_wdata),
       .rf_atq_tp_we                                       (i_hqm_sip_rf_atq_tp_we),
       .rf_cfg_atm_qid_dpth_thrsh_mem_raddr                (i_hqm_sip_rf_cfg_atm_qid_dpth_thrsh_mem_raddr),
       .rf_cfg_atm_qid_dpth_thrsh_mem_rclk                 (i_hqm_sip_rf_cfg_atm_qid_dpth_thrsh_mem_rclk),
       .rf_cfg_atm_qid_dpth_thrsh_mem_rclk_rst_n           (i_hqm_sip_rf_cfg_atm_qid_dpth_thrsh_mem_rclk_rst_n),
       .rf_cfg_atm_qid_dpth_thrsh_mem_re                   (i_hqm_sip_rf_cfg_atm_qid_dpth_thrsh_mem_re),
       .rf_cfg_atm_qid_dpth_thrsh_mem_waddr                (i_hqm_sip_rf_cfg_atm_qid_dpth_thrsh_mem_waddr),
       .rf_cfg_atm_qid_dpth_thrsh_mem_wclk                 (i_hqm_sip_rf_cfg_atm_qid_dpth_thrsh_mem_wclk),
       .rf_cfg_atm_qid_dpth_thrsh_mem_wclk_rst_n           (i_hqm_sip_rf_cfg_atm_qid_dpth_thrsh_mem_wclk_rst_n),
       .rf_cfg_atm_qid_dpth_thrsh_mem_wdata                (i_hqm_sip_rf_cfg_atm_qid_dpth_thrsh_mem_wdata),
       .rf_cfg_atm_qid_dpth_thrsh_mem_we                   (i_hqm_sip_rf_cfg_atm_qid_dpth_thrsh_mem_we),
       .rf_cfg_cq2priov_mem_raddr                          (i_hqm_sip_rf_cfg_cq2priov_mem_raddr),
       .rf_cfg_cq2priov_mem_rclk                           (i_hqm_sip_rf_cfg_cq2priov_mem_rclk),
       .rf_cfg_cq2priov_mem_rclk_rst_n                     (i_hqm_sip_rf_cfg_cq2priov_mem_rclk_rst_n),
       .rf_cfg_cq2priov_mem_re                             (i_hqm_sip_rf_cfg_cq2priov_mem_re),
       .rf_cfg_cq2priov_mem_waddr                          (i_hqm_sip_rf_cfg_cq2priov_mem_waddr),
       .rf_cfg_cq2priov_mem_wclk                           (i_hqm_sip_rf_cfg_cq2priov_mem_wclk),
       .rf_cfg_cq2priov_mem_wclk_rst_n                     (i_hqm_sip_rf_cfg_cq2priov_mem_wclk_rst_n),
       .rf_cfg_cq2priov_mem_wdata                          (i_hqm_sip_rf_cfg_cq2priov_mem_wdata),
       .rf_cfg_cq2priov_mem_we                             (i_hqm_sip_rf_cfg_cq2priov_mem_we),
       .rf_cfg_cq2priov_odd_mem_raddr                      (i_hqm_sip_rf_cfg_cq2priov_odd_mem_raddr),
       .rf_cfg_cq2priov_odd_mem_rclk                       (i_hqm_sip_rf_cfg_cq2priov_odd_mem_rclk),
       .rf_cfg_cq2priov_odd_mem_rclk_rst_n                 (i_hqm_sip_rf_cfg_cq2priov_odd_mem_rclk_rst_n),
       .rf_cfg_cq2priov_odd_mem_re                         (i_hqm_sip_rf_cfg_cq2priov_odd_mem_re),
       .rf_cfg_cq2priov_odd_mem_waddr                      (i_hqm_sip_rf_cfg_cq2priov_odd_mem_waddr),
       .rf_cfg_cq2priov_odd_mem_wclk                       (i_hqm_sip_rf_cfg_cq2priov_odd_mem_wclk),
       .rf_cfg_cq2priov_odd_mem_wclk_rst_n                 (i_hqm_sip_rf_cfg_cq2priov_odd_mem_wclk_rst_n),
       .rf_cfg_cq2priov_odd_mem_wdata                      (i_hqm_sip_rf_cfg_cq2priov_odd_mem_wdata),
       .rf_cfg_cq2priov_odd_mem_we                         (i_hqm_sip_rf_cfg_cq2priov_odd_mem_we),
       .rf_cfg_cq2qid_0_mem_raddr                          (i_hqm_sip_rf_cfg_cq2qid_0_mem_raddr),
       .rf_cfg_cq2qid_0_mem_rclk                           (i_hqm_sip_rf_cfg_cq2qid_0_mem_rclk),
       .rf_cfg_cq2qid_0_mem_rclk_rst_n                     (i_hqm_sip_rf_cfg_cq2qid_0_mem_rclk_rst_n),
       .rf_cfg_cq2qid_0_mem_re                             (i_hqm_sip_rf_cfg_cq2qid_0_mem_re),
       .rf_cfg_cq2qid_0_mem_waddr                          (i_hqm_sip_rf_cfg_cq2qid_0_mem_waddr),
       .rf_cfg_cq2qid_0_mem_wclk                           (i_hqm_sip_rf_cfg_cq2qid_0_mem_wclk),
       .rf_cfg_cq2qid_0_mem_wclk_rst_n                     (i_hqm_sip_rf_cfg_cq2qid_0_mem_wclk_rst_n),
       .rf_cfg_cq2qid_0_mem_wdata                          (i_hqm_sip_rf_cfg_cq2qid_0_mem_wdata),
       .rf_cfg_cq2qid_0_mem_we                             (i_hqm_sip_rf_cfg_cq2qid_0_mem_we),
       .rf_cfg_cq2qid_0_odd_mem_raddr                      (i_hqm_sip_rf_cfg_cq2qid_0_odd_mem_raddr),
       .rf_cfg_cq2qid_0_odd_mem_rclk                       (i_hqm_sip_rf_cfg_cq2qid_0_odd_mem_rclk),
       .rf_cfg_cq2qid_0_odd_mem_rclk_rst_n                 (i_hqm_sip_rf_cfg_cq2qid_0_odd_mem_rclk_rst_n),
       .rf_cfg_cq2qid_0_odd_mem_re                         (i_hqm_sip_rf_cfg_cq2qid_0_odd_mem_re),
       .rf_cfg_cq2qid_0_odd_mem_waddr                      (i_hqm_sip_rf_cfg_cq2qid_0_odd_mem_waddr),
       .rf_cfg_cq2qid_0_odd_mem_wclk                       (i_hqm_sip_rf_cfg_cq2qid_0_odd_mem_wclk),
       .rf_cfg_cq2qid_0_odd_mem_wclk_rst_n                 (i_hqm_sip_rf_cfg_cq2qid_0_odd_mem_wclk_rst_n),
       .rf_cfg_cq2qid_0_odd_mem_wdata                      (i_hqm_sip_rf_cfg_cq2qid_0_odd_mem_wdata),
       .rf_cfg_cq2qid_0_odd_mem_we                         (i_hqm_sip_rf_cfg_cq2qid_0_odd_mem_we),
       .rf_cfg_cq2qid_1_mem_raddr                          (i_hqm_sip_rf_cfg_cq2qid_1_mem_raddr),
       .rf_cfg_cq2qid_1_mem_rclk                           (i_hqm_sip_rf_cfg_cq2qid_1_mem_rclk),
       .rf_cfg_cq2qid_1_mem_rclk_rst_n                     (i_hqm_sip_rf_cfg_cq2qid_1_mem_rclk_rst_n),
       .rf_cfg_cq2qid_1_mem_re                             (i_hqm_sip_rf_cfg_cq2qid_1_mem_re),
       .rf_cfg_cq2qid_1_mem_waddr                          (i_hqm_sip_rf_cfg_cq2qid_1_mem_waddr),
       .rf_cfg_cq2qid_1_mem_wclk                           (i_hqm_sip_rf_cfg_cq2qid_1_mem_wclk),
       .rf_cfg_cq2qid_1_mem_wclk_rst_n                     (i_hqm_sip_rf_cfg_cq2qid_1_mem_wclk_rst_n),
       .rf_cfg_cq2qid_1_mem_wdata                          (i_hqm_sip_rf_cfg_cq2qid_1_mem_wdata),
       .rf_cfg_cq2qid_1_mem_we                             (i_hqm_sip_rf_cfg_cq2qid_1_mem_we),
       .rf_cfg_cq2qid_1_odd_mem_raddr                      (i_hqm_sip_rf_cfg_cq2qid_1_odd_mem_raddr),
       .rf_cfg_cq2qid_1_odd_mem_rclk                       (i_hqm_sip_rf_cfg_cq2qid_1_odd_mem_rclk),
       .rf_cfg_cq2qid_1_odd_mem_rclk_rst_n                 (i_hqm_sip_rf_cfg_cq2qid_1_odd_mem_rclk_rst_n),
       .rf_cfg_cq2qid_1_odd_mem_re                         (i_hqm_sip_rf_cfg_cq2qid_1_odd_mem_re),
       .rf_cfg_cq2qid_1_odd_mem_waddr                      (i_hqm_sip_rf_cfg_cq2qid_1_odd_mem_waddr),
       .rf_cfg_cq2qid_1_odd_mem_wclk                       (i_hqm_sip_rf_cfg_cq2qid_1_odd_mem_wclk),
       .rf_cfg_cq2qid_1_odd_mem_wclk_rst_n                 (i_hqm_sip_rf_cfg_cq2qid_1_odd_mem_wclk_rst_n),
       .rf_cfg_cq2qid_1_odd_mem_wdata                      (i_hqm_sip_rf_cfg_cq2qid_1_odd_mem_wdata),
       .rf_cfg_cq2qid_1_odd_mem_we                         (i_hqm_sip_rf_cfg_cq2qid_1_odd_mem_we),
       .rf_cfg_cq_ldb_inflight_limit_mem_raddr             (i_hqm_sip_rf_cfg_cq_ldb_inflight_limit_mem_raddr),
       .rf_cfg_cq_ldb_inflight_limit_mem_rclk              (i_hqm_sip_rf_cfg_cq_ldb_inflight_limit_mem_rclk),
       .rf_cfg_cq_ldb_inflight_limit_mem_rclk_rst_n        (i_hqm_sip_rf_cfg_cq_ldb_inflight_limit_mem_rclk_rst_n),
       .rf_cfg_cq_ldb_inflight_limit_mem_re                (i_hqm_sip_rf_cfg_cq_ldb_inflight_limit_mem_re),
       .rf_cfg_cq_ldb_inflight_limit_mem_waddr             (i_hqm_sip_rf_cfg_cq_ldb_inflight_limit_mem_waddr),
       .rf_cfg_cq_ldb_inflight_limit_mem_wclk              (i_hqm_sip_rf_cfg_cq_ldb_inflight_limit_mem_wclk),
       .rf_cfg_cq_ldb_inflight_limit_mem_wclk_rst_n        (i_hqm_sip_rf_cfg_cq_ldb_inflight_limit_mem_wclk_rst_n),
       .rf_cfg_cq_ldb_inflight_limit_mem_wdata             (i_hqm_sip_rf_cfg_cq_ldb_inflight_limit_mem_wdata),
       .rf_cfg_cq_ldb_inflight_limit_mem_we                (i_hqm_sip_rf_cfg_cq_ldb_inflight_limit_mem_we),
       .rf_cfg_cq_ldb_inflight_threshold_mem_raddr         (i_hqm_sip_rf_cfg_cq_ldb_inflight_threshold_mem_raddr),
       .rf_cfg_cq_ldb_inflight_threshold_mem_rclk          (i_hqm_sip_rf_cfg_cq_ldb_inflight_threshold_mem_rclk),
       .rf_cfg_cq_ldb_inflight_threshold_mem_rclk_rst_n    (i_hqm_sip_rf_cfg_cq_ldb_inflight_threshold_mem_rclk_rst_n),
       .rf_cfg_cq_ldb_inflight_threshold_mem_re            (i_hqm_sip_rf_cfg_cq_ldb_inflight_threshold_mem_re),
       .rf_cfg_cq_ldb_inflight_threshold_mem_waddr         (i_hqm_sip_rf_cfg_cq_ldb_inflight_threshold_mem_waddr),
       .rf_cfg_cq_ldb_inflight_threshold_mem_wclk          (i_hqm_sip_rf_cfg_cq_ldb_inflight_threshold_mem_wclk),
       .rf_cfg_cq_ldb_inflight_threshold_mem_wclk_rst_n    (i_hqm_sip_rf_cfg_cq_ldb_inflight_threshold_mem_wclk_rst_n),
       .rf_cfg_cq_ldb_inflight_threshold_mem_wdata         (i_hqm_sip_rf_cfg_cq_ldb_inflight_threshold_mem_wdata),
       .rf_cfg_cq_ldb_inflight_threshold_mem_we            (i_hqm_sip_rf_cfg_cq_ldb_inflight_threshold_mem_we),
       .rf_cfg_cq_ldb_token_depth_select_mem_raddr         (i_hqm_sip_rf_cfg_cq_ldb_token_depth_select_mem_raddr),
       .rf_cfg_cq_ldb_token_depth_select_mem_rclk          (i_hqm_sip_rf_cfg_cq_ldb_token_depth_select_mem_rclk),
       .rf_cfg_cq_ldb_token_depth_select_mem_rclk_rst_n    (i_hqm_sip_rf_cfg_cq_ldb_token_depth_select_mem_rclk_rst_n),
       .rf_cfg_cq_ldb_token_depth_select_mem_re            (i_hqm_sip_rf_cfg_cq_ldb_token_depth_select_mem_re),
       .rf_cfg_cq_ldb_token_depth_select_mem_waddr         (i_hqm_sip_rf_cfg_cq_ldb_token_depth_select_mem_waddr),
       .rf_cfg_cq_ldb_token_depth_select_mem_wclk          (i_hqm_sip_rf_cfg_cq_ldb_token_depth_select_mem_wclk),
       .rf_cfg_cq_ldb_token_depth_select_mem_wclk_rst_n    (i_hqm_sip_rf_cfg_cq_ldb_token_depth_select_mem_wclk_rst_n),
       .rf_cfg_cq_ldb_token_depth_select_mem_wdata         (i_hqm_sip_rf_cfg_cq_ldb_token_depth_select_mem_wdata),
       .rf_cfg_cq_ldb_token_depth_select_mem_we            (i_hqm_sip_rf_cfg_cq_ldb_token_depth_select_mem_we),
       .rf_cfg_cq_ldb_wu_limit_mem_raddr                   (i_hqm_sip_rf_cfg_cq_ldb_wu_limit_mem_raddr),
       .rf_cfg_cq_ldb_wu_limit_mem_rclk                    (i_hqm_sip_rf_cfg_cq_ldb_wu_limit_mem_rclk),
       .rf_cfg_cq_ldb_wu_limit_mem_rclk_rst_n              (i_hqm_sip_rf_cfg_cq_ldb_wu_limit_mem_rclk_rst_n),
       .rf_cfg_cq_ldb_wu_limit_mem_re                      (i_hqm_sip_rf_cfg_cq_ldb_wu_limit_mem_re),
       .rf_cfg_cq_ldb_wu_limit_mem_waddr                   (i_hqm_sip_rf_cfg_cq_ldb_wu_limit_mem_waddr),
       .rf_cfg_cq_ldb_wu_limit_mem_wclk                    (i_hqm_sip_rf_cfg_cq_ldb_wu_limit_mem_wclk),
       .rf_cfg_cq_ldb_wu_limit_mem_wclk_rst_n              (i_hqm_sip_rf_cfg_cq_ldb_wu_limit_mem_wclk_rst_n),
       .rf_cfg_cq_ldb_wu_limit_mem_wdata                   (i_hqm_sip_rf_cfg_cq_ldb_wu_limit_mem_wdata),
       .rf_cfg_cq_ldb_wu_limit_mem_we                      (i_hqm_sip_rf_cfg_cq_ldb_wu_limit_mem_we),
       .rf_cfg_dir_qid_dpth_thrsh_mem_raddr                (i_hqm_sip_rf_cfg_dir_qid_dpth_thrsh_mem_raddr),
       .rf_cfg_dir_qid_dpth_thrsh_mem_rclk                 (i_hqm_sip_rf_cfg_dir_qid_dpth_thrsh_mem_rclk),
       .rf_cfg_dir_qid_dpth_thrsh_mem_rclk_rst_n           (i_hqm_sip_rf_cfg_dir_qid_dpth_thrsh_mem_rclk_rst_n),
       .rf_cfg_dir_qid_dpth_thrsh_mem_re                   (i_hqm_sip_rf_cfg_dir_qid_dpth_thrsh_mem_re),
       .rf_cfg_dir_qid_dpth_thrsh_mem_waddr                (i_hqm_sip_rf_cfg_dir_qid_dpth_thrsh_mem_waddr),
       .rf_cfg_dir_qid_dpth_thrsh_mem_wclk                 (i_hqm_sip_rf_cfg_dir_qid_dpth_thrsh_mem_wclk),
       .rf_cfg_dir_qid_dpth_thrsh_mem_wclk_rst_n           (i_hqm_sip_rf_cfg_dir_qid_dpth_thrsh_mem_wclk_rst_n),
       .rf_cfg_dir_qid_dpth_thrsh_mem_wdata                (i_hqm_sip_rf_cfg_dir_qid_dpth_thrsh_mem_wdata),
       .rf_cfg_dir_qid_dpth_thrsh_mem_we                   (i_hqm_sip_rf_cfg_dir_qid_dpth_thrsh_mem_we),
       .rf_cfg_nalb_qid_dpth_thrsh_mem_raddr               (i_hqm_sip_rf_cfg_nalb_qid_dpth_thrsh_mem_raddr),
       .rf_cfg_nalb_qid_dpth_thrsh_mem_rclk                (i_hqm_sip_rf_cfg_nalb_qid_dpth_thrsh_mem_rclk),
       .rf_cfg_nalb_qid_dpth_thrsh_mem_rclk_rst_n          (i_hqm_sip_rf_cfg_nalb_qid_dpth_thrsh_mem_rclk_rst_n),
       .rf_cfg_nalb_qid_dpth_thrsh_mem_re                  (i_hqm_sip_rf_cfg_nalb_qid_dpth_thrsh_mem_re),
       .rf_cfg_nalb_qid_dpth_thrsh_mem_waddr               (i_hqm_sip_rf_cfg_nalb_qid_dpth_thrsh_mem_waddr),
       .rf_cfg_nalb_qid_dpth_thrsh_mem_wclk                (i_hqm_sip_rf_cfg_nalb_qid_dpth_thrsh_mem_wclk),
       .rf_cfg_nalb_qid_dpth_thrsh_mem_wclk_rst_n          (i_hqm_sip_rf_cfg_nalb_qid_dpth_thrsh_mem_wclk_rst_n),
       .rf_cfg_nalb_qid_dpth_thrsh_mem_wdata               (i_hqm_sip_rf_cfg_nalb_qid_dpth_thrsh_mem_wdata),
       .rf_cfg_nalb_qid_dpth_thrsh_mem_we                  (i_hqm_sip_rf_cfg_nalb_qid_dpth_thrsh_mem_we),
       .rf_cfg_qid_aqed_active_limit_mem_raddr             (i_hqm_sip_rf_cfg_qid_aqed_active_limit_mem_raddr),
       .rf_cfg_qid_aqed_active_limit_mem_rclk              (i_hqm_sip_rf_cfg_qid_aqed_active_limit_mem_rclk),
       .rf_cfg_qid_aqed_active_limit_mem_rclk_rst_n        (i_hqm_sip_rf_cfg_qid_aqed_active_limit_mem_rclk_rst_n),
       .rf_cfg_qid_aqed_active_limit_mem_re                (i_hqm_sip_rf_cfg_qid_aqed_active_limit_mem_re),
       .rf_cfg_qid_aqed_active_limit_mem_waddr             (i_hqm_sip_rf_cfg_qid_aqed_active_limit_mem_waddr),
       .rf_cfg_qid_aqed_active_limit_mem_wclk              (i_hqm_sip_rf_cfg_qid_aqed_active_limit_mem_wclk),
       .rf_cfg_qid_aqed_active_limit_mem_wclk_rst_n        (i_hqm_sip_rf_cfg_qid_aqed_active_limit_mem_wclk_rst_n),
       .rf_cfg_qid_aqed_active_limit_mem_wdata             (i_hqm_sip_rf_cfg_qid_aqed_active_limit_mem_wdata),
       .rf_cfg_qid_aqed_active_limit_mem_we                (i_hqm_sip_rf_cfg_qid_aqed_active_limit_mem_we),
       .rf_cfg_qid_ldb_inflight_limit_mem_raddr            (i_hqm_sip_rf_cfg_qid_ldb_inflight_limit_mem_raddr),
       .rf_cfg_qid_ldb_inflight_limit_mem_rclk             (i_hqm_sip_rf_cfg_qid_ldb_inflight_limit_mem_rclk),
       .rf_cfg_qid_ldb_inflight_limit_mem_rclk_rst_n       (i_hqm_sip_rf_cfg_qid_ldb_inflight_limit_mem_rclk_rst_n),
       .rf_cfg_qid_ldb_inflight_limit_mem_re               (i_hqm_sip_rf_cfg_qid_ldb_inflight_limit_mem_re),
       .rf_cfg_qid_ldb_inflight_limit_mem_waddr            (i_hqm_sip_rf_cfg_qid_ldb_inflight_limit_mem_waddr),
       .rf_cfg_qid_ldb_inflight_limit_mem_wclk             (i_hqm_sip_rf_cfg_qid_ldb_inflight_limit_mem_wclk),
       .rf_cfg_qid_ldb_inflight_limit_mem_wclk_rst_n       (i_hqm_sip_rf_cfg_qid_ldb_inflight_limit_mem_wclk_rst_n),
       .rf_cfg_qid_ldb_inflight_limit_mem_wdata            (i_hqm_sip_rf_cfg_qid_ldb_inflight_limit_mem_wdata),
       .rf_cfg_qid_ldb_inflight_limit_mem_we               (i_hqm_sip_rf_cfg_qid_ldb_inflight_limit_mem_we),
       .rf_cfg_qid_ldb_qid2cqidix2_mem_raddr               (i_hqm_sip_rf_cfg_qid_ldb_qid2cqidix2_mem_raddr),
       .rf_cfg_qid_ldb_qid2cqidix2_mem_rclk                (i_hqm_sip_rf_cfg_qid_ldb_qid2cqidix2_mem_rclk),
       .rf_cfg_qid_ldb_qid2cqidix2_mem_rclk_rst_n          (i_hqm_sip_rf_cfg_qid_ldb_qid2cqidix2_mem_rclk_rst_n),
       .rf_cfg_qid_ldb_qid2cqidix2_mem_re                  (i_hqm_sip_rf_cfg_qid_ldb_qid2cqidix2_mem_re),
       .rf_cfg_qid_ldb_qid2cqidix2_mem_waddr               (i_hqm_sip_rf_cfg_qid_ldb_qid2cqidix2_mem_waddr),
       .rf_cfg_qid_ldb_qid2cqidix2_mem_wclk                (i_hqm_sip_rf_cfg_qid_ldb_qid2cqidix2_mem_wclk),
       .rf_cfg_qid_ldb_qid2cqidix2_mem_wclk_rst_n          (i_hqm_sip_rf_cfg_qid_ldb_qid2cqidix2_mem_wclk_rst_n),
       .rf_cfg_qid_ldb_qid2cqidix2_mem_wdata               (i_hqm_sip_rf_cfg_qid_ldb_qid2cqidix2_mem_wdata),
       .rf_cfg_qid_ldb_qid2cqidix2_mem_we                  (i_hqm_sip_rf_cfg_qid_ldb_qid2cqidix2_mem_we),
       .rf_cfg_qid_ldb_qid2cqidix_mem_raddr                (i_hqm_sip_rf_cfg_qid_ldb_qid2cqidix_mem_raddr),
       .rf_cfg_qid_ldb_qid2cqidix_mem_rclk                 (i_hqm_sip_rf_cfg_qid_ldb_qid2cqidix_mem_rclk),
       .rf_cfg_qid_ldb_qid2cqidix_mem_rclk_rst_n           (i_hqm_sip_rf_cfg_qid_ldb_qid2cqidix_mem_rclk_rst_n),
       .rf_cfg_qid_ldb_qid2cqidix_mem_re                   (i_hqm_sip_rf_cfg_qid_ldb_qid2cqidix_mem_re),
       .rf_cfg_qid_ldb_qid2cqidix_mem_waddr                (i_hqm_sip_rf_cfg_qid_ldb_qid2cqidix_mem_waddr),
       .rf_cfg_qid_ldb_qid2cqidix_mem_wclk                 (i_hqm_sip_rf_cfg_qid_ldb_qid2cqidix_mem_wclk),
       .rf_cfg_qid_ldb_qid2cqidix_mem_wclk_rst_n           (i_hqm_sip_rf_cfg_qid_ldb_qid2cqidix_mem_wclk_rst_n),
       .rf_cfg_qid_ldb_qid2cqidix_mem_wdata                (i_hqm_sip_rf_cfg_qid_ldb_qid2cqidix_mem_wdata),
       .rf_cfg_qid_ldb_qid2cqidix_mem_we                   (i_hqm_sip_rf_cfg_qid_ldb_qid2cqidix_mem_we),
       .rf_chp_chp_rop_hcw_fifo_mem_raddr                  (i_hqm_sip_rf_chp_chp_rop_hcw_fifo_mem_raddr),
       .rf_chp_chp_rop_hcw_fifo_mem_rclk                   (i_hqm_sip_rf_chp_chp_rop_hcw_fifo_mem_rclk),
       .rf_chp_chp_rop_hcw_fifo_mem_rclk_rst_n             (i_hqm_sip_rf_chp_chp_rop_hcw_fifo_mem_rclk_rst_n),
       .rf_chp_chp_rop_hcw_fifo_mem_re                     (i_hqm_sip_rf_chp_chp_rop_hcw_fifo_mem_re),
       .rf_chp_chp_rop_hcw_fifo_mem_waddr                  (i_hqm_sip_rf_chp_chp_rop_hcw_fifo_mem_waddr),
       .rf_chp_chp_rop_hcw_fifo_mem_wclk                   (i_hqm_sip_rf_chp_chp_rop_hcw_fifo_mem_wclk),
       .rf_chp_chp_rop_hcw_fifo_mem_wclk_rst_n             (i_hqm_sip_rf_chp_chp_rop_hcw_fifo_mem_wclk_rst_n),
       .rf_chp_chp_rop_hcw_fifo_mem_wdata                  (i_hqm_sip_rf_chp_chp_rop_hcw_fifo_mem_wdata),
       .rf_chp_chp_rop_hcw_fifo_mem_we                     (i_hqm_sip_rf_chp_chp_rop_hcw_fifo_mem_we),
       .rf_chp_lsp_ap_cmp_fifo_mem_raddr                   (i_hqm_sip_rf_chp_lsp_ap_cmp_fifo_mem_raddr),
       .rf_chp_lsp_ap_cmp_fifo_mem_rclk                    (i_hqm_sip_rf_chp_lsp_ap_cmp_fifo_mem_rclk),
       .rf_chp_lsp_ap_cmp_fifo_mem_rclk_rst_n              (i_hqm_sip_rf_chp_lsp_ap_cmp_fifo_mem_rclk_rst_n),
       .rf_chp_lsp_ap_cmp_fifo_mem_re                      (i_hqm_sip_rf_chp_lsp_ap_cmp_fifo_mem_re),
       .rf_chp_lsp_ap_cmp_fifo_mem_waddr                   (i_hqm_sip_rf_chp_lsp_ap_cmp_fifo_mem_waddr),
       .rf_chp_lsp_ap_cmp_fifo_mem_wclk                    (i_hqm_sip_rf_chp_lsp_ap_cmp_fifo_mem_wclk),
       .rf_chp_lsp_ap_cmp_fifo_mem_wclk_rst_n              (i_hqm_sip_rf_chp_lsp_ap_cmp_fifo_mem_wclk_rst_n),
       .rf_chp_lsp_ap_cmp_fifo_mem_wdata                   (i_hqm_sip_rf_chp_lsp_ap_cmp_fifo_mem_wdata),
       .rf_chp_lsp_ap_cmp_fifo_mem_we                      (i_hqm_sip_rf_chp_lsp_ap_cmp_fifo_mem_we),
       .rf_chp_lsp_cmp_rx_sync_fifo_mem_raddr              (i_hqm_sip_rf_chp_lsp_cmp_rx_sync_fifo_mem_raddr),
       .rf_chp_lsp_cmp_rx_sync_fifo_mem_rclk               (i_hqm_sip_rf_chp_lsp_cmp_rx_sync_fifo_mem_rclk),
       .rf_chp_lsp_cmp_rx_sync_fifo_mem_rclk_rst_n         (i_hqm_sip_rf_chp_lsp_cmp_rx_sync_fifo_mem_rclk_rst_n),
       .rf_chp_lsp_cmp_rx_sync_fifo_mem_re                 (i_hqm_sip_rf_chp_lsp_cmp_rx_sync_fifo_mem_re),
       .rf_chp_lsp_cmp_rx_sync_fifo_mem_waddr              (i_hqm_sip_rf_chp_lsp_cmp_rx_sync_fifo_mem_waddr),
       .rf_chp_lsp_cmp_rx_sync_fifo_mem_wclk               (i_hqm_sip_rf_chp_lsp_cmp_rx_sync_fifo_mem_wclk),
       .rf_chp_lsp_cmp_rx_sync_fifo_mem_wclk_rst_n         (i_hqm_sip_rf_chp_lsp_cmp_rx_sync_fifo_mem_wclk_rst_n),
       .rf_chp_lsp_cmp_rx_sync_fifo_mem_wdata              (i_hqm_sip_rf_chp_lsp_cmp_rx_sync_fifo_mem_wdata),
       .rf_chp_lsp_cmp_rx_sync_fifo_mem_we                 (i_hqm_sip_rf_chp_lsp_cmp_rx_sync_fifo_mem_we),
       .rf_chp_lsp_tok_fifo_mem_raddr                      (i_hqm_sip_rf_chp_lsp_tok_fifo_mem_raddr),
       .rf_chp_lsp_tok_fifo_mem_rclk                       (i_hqm_sip_rf_chp_lsp_tok_fifo_mem_rclk),
       .rf_chp_lsp_tok_fifo_mem_rclk_rst_n                 (i_hqm_sip_rf_chp_lsp_tok_fifo_mem_rclk_rst_n),
       .rf_chp_lsp_tok_fifo_mem_re                         (i_hqm_sip_rf_chp_lsp_tok_fifo_mem_re),
       .rf_chp_lsp_tok_fifo_mem_waddr                      (i_hqm_sip_rf_chp_lsp_tok_fifo_mem_waddr),
       .rf_chp_lsp_tok_fifo_mem_wclk                       (i_hqm_sip_rf_chp_lsp_tok_fifo_mem_wclk),
       .rf_chp_lsp_tok_fifo_mem_wclk_rst_n                 (i_hqm_sip_rf_chp_lsp_tok_fifo_mem_wclk_rst_n),
       .rf_chp_lsp_tok_fifo_mem_wdata                      (i_hqm_sip_rf_chp_lsp_tok_fifo_mem_wdata),
       .rf_chp_lsp_tok_fifo_mem_we                         (i_hqm_sip_rf_chp_lsp_tok_fifo_mem_we),
       .rf_chp_lsp_token_rx_sync_fifo_mem_raddr            (i_hqm_sip_rf_chp_lsp_token_rx_sync_fifo_mem_raddr),
       .rf_chp_lsp_token_rx_sync_fifo_mem_rclk             (i_hqm_sip_rf_chp_lsp_token_rx_sync_fifo_mem_rclk),
       .rf_chp_lsp_token_rx_sync_fifo_mem_rclk_rst_n       (i_hqm_sip_rf_chp_lsp_token_rx_sync_fifo_mem_rclk_rst_n),
       .rf_chp_lsp_token_rx_sync_fifo_mem_re               (i_hqm_sip_rf_chp_lsp_token_rx_sync_fifo_mem_re),
       .rf_chp_lsp_token_rx_sync_fifo_mem_waddr            (i_hqm_sip_rf_chp_lsp_token_rx_sync_fifo_mem_waddr),
       .rf_chp_lsp_token_rx_sync_fifo_mem_wclk             (i_hqm_sip_rf_chp_lsp_token_rx_sync_fifo_mem_wclk),
       .rf_chp_lsp_token_rx_sync_fifo_mem_wclk_rst_n       (i_hqm_sip_rf_chp_lsp_token_rx_sync_fifo_mem_wclk_rst_n),
       .rf_chp_lsp_token_rx_sync_fifo_mem_wdata            (i_hqm_sip_rf_chp_lsp_token_rx_sync_fifo_mem_wdata),
       .rf_chp_lsp_token_rx_sync_fifo_mem_we               (i_hqm_sip_rf_chp_lsp_token_rx_sync_fifo_mem_we),
       .rf_chp_sys_tx_fifo_mem_raddr                       (i_hqm_sip_rf_chp_sys_tx_fifo_mem_raddr),
       .rf_chp_sys_tx_fifo_mem_rclk                        (i_hqm_sip_rf_chp_sys_tx_fifo_mem_rclk),
       .rf_chp_sys_tx_fifo_mem_rclk_rst_n                  (i_hqm_sip_rf_chp_sys_tx_fifo_mem_rclk_rst_n),
       .rf_chp_sys_tx_fifo_mem_re                          (i_hqm_sip_rf_chp_sys_tx_fifo_mem_re),
       .rf_chp_sys_tx_fifo_mem_waddr                       (i_hqm_sip_rf_chp_sys_tx_fifo_mem_waddr),
       .rf_chp_sys_tx_fifo_mem_wclk                        (i_hqm_sip_rf_chp_sys_tx_fifo_mem_wclk),
       .rf_chp_sys_tx_fifo_mem_wclk_rst_n                  (i_hqm_sip_rf_chp_sys_tx_fifo_mem_wclk_rst_n),
       .rf_chp_sys_tx_fifo_mem_wdata                       (i_hqm_sip_rf_chp_sys_tx_fifo_mem_wdata),
       .rf_chp_sys_tx_fifo_mem_we                          (i_hqm_sip_rf_chp_sys_tx_fifo_mem_we),
       .rf_cmp_id_chk_enbl_mem_raddr                       (i_hqm_sip_rf_cmp_id_chk_enbl_mem_raddr),
       .rf_cmp_id_chk_enbl_mem_rclk                        (i_hqm_sip_rf_cmp_id_chk_enbl_mem_rclk),
       .rf_cmp_id_chk_enbl_mem_rclk_rst_n                  (i_hqm_sip_rf_cmp_id_chk_enbl_mem_rclk_rst_n),
       .rf_cmp_id_chk_enbl_mem_re                          (i_hqm_sip_rf_cmp_id_chk_enbl_mem_re),
       .rf_cmp_id_chk_enbl_mem_waddr                       (i_hqm_sip_rf_cmp_id_chk_enbl_mem_waddr),
       .rf_cmp_id_chk_enbl_mem_wclk                        (i_hqm_sip_rf_cmp_id_chk_enbl_mem_wclk),
       .rf_cmp_id_chk_enbl_mem_wclk_rst_n                  (i_hqm_sip_rf_cmp_id_chk_enbl_mem_wclk_rst_n),
       .rf_cmp_id_chk_enbl_mem_wdata                       (i_hqm_sip_rf_cmp_id_chk_enbl_mem_wdata),
       .rf_cmp_id_chk_enbl_mem_we                          (i_hqm_sip_rf_cmp_id_chk_enbl_mem_we),
       .rf_count_rmw_pipe_dir_mem_raddr                    (i_hqm_sip_rf_count_rmw_pipe_dir_mem_raddr),
       .rf_count_rmw_pipe_dir_mem_rclk                     (i_hqm_sip_rf_count_rmw_pipe_dir_mem_rclk),
       .rf_count_rmw_pipe_dir_mem_rclk_rst_n               (i_hqm_sip_rf_count_rmw_pipe_dir_mem_rclk_rst_n),
       .rf_count_rmw_pipe_dir_mem_re                       (i_hqm_sip_rf_count_rmw_pipe_dir_mem_re),
       .rf_count_rmw_pipe_dir_mem_waddr                    (i_hqm_sip_rf_count_rmw_pipe_dir_mem_waddr),
       .rf_count_rmw_pipe_dir_mem_wclk                     (i_hqm_sip_rf_count_rmw_pipe_dir_mem_wclk),
       .rf_count_rmw_pipe_dir_mem_wclk_rst_n               (i_hqm_sip_rf_count_rmw_pipe_dir_mem_wclk_rst_n),
       .rf_count_rmw_pipe_dir_mem_wdata                    (i_hqm_sip_rf_count_rmw_pipe_dir_mem_wdata),
       .rf_count_rmw_pipe_dir_mem_we                       (i_hqm_sip_rf_count_rmw_pipe_dir_mem_we),
       .rf_count_rmw_pipe_ldb_mem_raddr                    (i_hqm_sip_rf_count_rmw_pipe_ldb_mem_raddr),
       .rf_count_rmw_pipe_ldb_mem_rclk                     (i_hqm_sip_rf_count_rmw_pipe_ldb_mem_rclk),
       .rf_count_rmw_pipe_ldb_mem_rclk_rst_n               (i_hqm_sip_rf_count_rmw_pipe_ldb_mem_rclk_rst_n),
       .rf_count_rmw_pipe_ldb_mem_re                       (i_hqm_sip_rf_count_rmw_pipe_ldb_mem_re),
       .rf_count_rmw_pipe_ldb_mem_waddr                    (i_hqm_sip_rf_count_rmw_pipe_ldb_mem_waddr),
       .rf_count_rmw_pipe_ldb_mem_wclk                     (i_hqm_sip_rf_count_rmw_pipe_ldb_mem_wclk),
       .rf_count_rmw_pipe_ldb_mem_wclk_rst_n               (i_hqm_sip_rf_count_rmw_pipe_ldb_mem_wclk_rst_n),
       .rf_count_rmw_pipe_ldb_mem_wdata                    (i_hqm_sip_rf_count_rmw_pipe_ldb_mem_wdata),
       .rf_count_rmw_pipe_ldb_mem_we                       (i_hqm_sip_rf_count_rmw_pipe_ldb_mem_we),
       .rf_count_rmw_pipe_wd_dir_mem_raddr                 (i_hqm_sip_rf_count_rmw_pipe_wd_dir_mem_raddr),
       .rf_count_rmw_pipe_wd_dir_mem_rclk                  (i_hqm_sip_rf_count_rmw_pipe_wd_dir_mem_rclk),
       .rf_count_rmw_pipe_wd_dir_mem_rclk_rst_n            (i_hqm_sip_rf_count_rmw_pipe_wd_dir_mem_rclk_rst_n),
       .rf_count_rmw_pipe_wd_dir_mem_re                    (i_hqm_sip_rf_count_rmw_pipe_wd_dir_mem_re),
       .rf_count_rmw_pipe_wd_dir_mem_waddr                 (i_hqm_sip_rf_count_rmw_pipe_wd_dir_mem_waddr),
       .rf_count_rmw_pipe_wd_dir_mem_wclk                  (i_hqm_sip_rf_count_rmw_pipe_wd_dir_mem_wclk),
       .rf_count_rmw_pipe_wd_dir_mem_wclk_rst_n            (i_hqm_sip_rf_count_rmw_pipe_wd_dir_mem_wclk_rst_n),
       .rf_count_rmw_pipe_wd_dir_mem_wdata                 (i_hqm_sip_rf_count_rmw_pipe_wd_dir_mem_wdata),
       .rf_count_rmw_pipe_wd_dir_mem_we                    (i_hqm_sip_rf_count_rmw_pipe_wd_dir_mem_we),
       .rf_count_rmw_pipe_wd_ldb_mem_raddr                 (i_hqm_sip_rf_count_rmw_pipe_wd_ldb_mem_raddr),
       .rf_count_rmw_pipe_wd_ldb_mem_rclk                  (i_hqm_sip_rf_count_rmw_pipe_wd_ldb_mem_rclk),
       .rf_count_rmw_pipe_wd_ldb_mem_rclk_rst_n            (i_hqm_sip_rf_count_rmw_pipe_wd_ldb_mem_rclk_rst_n),
       .rf_count_rmw_pipe_wd_ldb_mem_re                    (i_hqm_sip_rf_count_rmw_pipe_wd_ldb_mem_re),
       .rf_count_rmw_pipe_wd_ldb_mem_waddr                 (i_hqm_sip_rf_count_rmw_pipe_wd_ldb_mem_waddr),
       .rf_count_rmw_pipe_wd_ldb_mem_wclk                  (i_hqm_sip_rf_count_rmw_pipe_wd_ldb_mem_wclk),
       .rf_count_rmw_pipe_wd_ldb_mem_wclk_rst_n            (i_hqm_sip_rf_count_rmw_pipe_wd_ldb_mem_wclk_rst_n),
       .rf_count_rmw_pipe_wd_ldb_mem_wdata                 (i_hqm_sip_rf_count_rmw_pipe_wd_ldb_mem_wdata),
       .rf_count_rmw_pipe_wd_ldb_mem_we                    (i_hqm_sip_rf_count_rmw_pipe_wd_ldb_mem_we),
       .rf_cq_atm_pri_arbindex_mem_raddr                   (i_hqm_sip_rf_cq_atm_pri_arbindex_mem_raddr),
       .rf_cq_atm_pri_arbindex_mem_rclk                    (i_hqm_sip_rf_cq_atm_pri_arbindex_mem_rclk),
       .rf_cq_atm_pri_arbindex_mem_rclk_rst_n              (i_hqm_sip_rf_cq_atm_pri_arbindex_mem_rclk_rst_n),
       .rf_cq_atm_pri_arbindex_mem_re                      (i_hqm_sip_rf_cq_atm_pri_arbindex_mem_re),
       .rf_cq_atm_pri_arbindex_mem_waddr                   (i_hqm_sip_rf_cq_atm_pri_arbindex_mem_waddr),
       .rf_cq_atm_pri_arbindex_mem_wclk                    (i_hqm_sip_rf_cq_atm_pri_arbindex_mem_wclk),
       .rf_cq_atm_pri_arbindex_mem_wclk_rst_n              (i_hqm_sip_rf_cq_atm_pri_arbindex_mem_wclk_rst_n),
       .rf_cq_atm_pri_arbindex_mem_wdata                   (i_hqm_sip_rf_cq_atm_pri_arbindex_mem_wdata),
       .rf_cq_atm_pri_arbindex_mem_we                      (i_hqm_sip_rf_cq_atm_pri_arbindex_mem_we),
       .rf_cq_dir_tot_sch_cnt_mem_raddr                    (i_hqm_sip_rf_cq_dir_tot_sch_cnt_mem_raddr),
       .rf_cq_dir_tot_sch_cnt_mem_rclk                     (i_hqm_sip_rf_cq_dir_tot_sch_cnt_mem_rclk),
       .rf_cq_dir_tot_sch_cnt_mem_rclk_rst_n               (i_hqm_sip_rf_cq_dir_tot_sch_cnt_mem_rclk_rst_n),
       .rf_cq_dir_tot_sch_cnt_mem_re                       (i_hqm_sip_rf_cq_dir_tot_sch_cnt_mem_re),
       .rf_cq_dir_tot_sch_cnt_mem_waddr                    (i_hqm_sip_rf_cq_dir_tot_sch_cnt_mem_waddr),
       .rf_cq_dir_tot_sch_cnt_mem_wclk                     (i_hqm_sip_rf_cq_dir_tot_sch_cnt_mem_wclk),
       .rf_cq_dir_tot_sch_cnt_mem_wclk_rst_n               (i_hqm_sip_rf_cq_dir_tot_sch_cnt_mem_wclk_rst_n),
       .rf_cq_dir_tot_sch_cnt_mem_wdata                    (i_hqm_sip_rf_cq_dir_tot_sch_cnt_mem_wdata),
       .rf_cq_dir_tot_sch_cnt_mem_we                       (i_hqm_sip_rf_cq_dir_tot_sch_cnt_mem_we),
       .rf_cq_ldb_inflight_count_mem_raddr                 (i_hqm_sip_rf_cq_ldb_inflight_count_mem_raddr),
       .rf_cq_ldb_inflight_count_mem_rclk                  (i_hqm_sip_rf_cq_ldb_inflight_count_mem_rclk),
       .rf_cq_ldb_inflight_count_mem_rclk_rst_n            (i_hqm_sip_rf_cq_ldb_inflight_count_mem_rclk_rst_n),
       .rf_cq_ldb_inflight_count_mem_re                    (i_hqm_sip_rf_cq_ldb_inflight_count_mem_re),
       .rf_cq_ldb_inflight_count_mem_waddr                 (i_hqm_sip_rf_cq_ldb_inflight_count_mem_waddr),
       .rf_cq_ldb_inflight_count_mem_wclk                  (i_hqm_sip_rf_cq_ldb_inflight_count_mem_wclk),
       .rf_cq_ldb_inflight_count_mem_wclk_rst_n            (i_hqm_sip_rf_cq_ldb_inflight_count_mem_wclk_rst_n),
       .rf_cq_ldb_inflight_count_mem_wdata                 (i_hqm_sip_rf_cq_ldb_inflight_count_mem_wdata),
       .rf_cq_ldb_inflight_count_mem_we                    (i_hqm_sip_rf_cq_ldb_inflight_count_mem_we),
       .rf_cq_ldb_token_count_mem_raddr                    (i_hqm_sip_rf_cq_ldb_token_count_mem_raddr),
       .rf_cq_ldb_token_count_mem_rclk                     (i_hqm_sip_rf_cq_ldb_token_count_mem_rclk),
       .rf_cq_ldb_token_count_mem_rclk_rst_n               (i_hqm_sip_rf_cq_ldb_token_count_mem_rclk_rst_n),
       .rf_cq_ldb_token_count_mem_re                       (i_hqm_sip_rf_cq_ldb_token_count_mem_re),
       .rf_cq_ldb_token_count_mem_waddr                    (i_hqm_sip_rf_cq_ldb_token_count_mem_waddr),
       .rf_cq_ldb_token_count_mem_wclk                     (i_hqm_sip_rf_cq_ldb_token_count_mem_wclk),
       .rf_cq_ldb_token_count_mem_wclk_rst_n               (i_hqm_sip_rf_cq_ldb_token_count_mem_wclk_rst_n),
       .rf_cq_ldb_token_count_mem_wdata                    (i_hqm_sip_rf_cq_ldb_token_count_mem_wdata),
       .rf_cq_ldb_token_count_mem_we                       (i_hqm_sip_rf_cq_ldb_token_count_mem_we),
       .rf_cq_ldb_tot_sch_cnt_mem_raddr                    (i_hqm_sip_rf_cq_ldb_tot_sch_cnt_mem_raddr),
       .rf_cq_ldb_tot_sch_cnt_mem_rclk                     (i_hqm_sip_rf_cq_ldb_tot_sch_cnt_mem_rclk),
       .rf_cq_ldb_tot_sch_cnt_mem_rclk_rst_n               (i_hqm_sip_rf_cq_ldb_tot_sch_cnt_mem_rclk_rst_n),
       .rf_cq_ldb_tot_sch_cnt_mem_re                       (i_hqm_sip_rf_cq_ldb_tot_sch_cnt_mem_re),
       .rf_cq_ldb_tot_sch_cnt_mem_waddr                    (i_hqm_sip_rf_cq_ldb_tot_sch_cnt_mem_waddr),
       .rf_cq_ldb_tot_sch_cnt_mem_wclk                     (i_hqm_sip_rf_cq_ldb_tot_sch_cnt_mem_wclk),
       .rf_cq_ldb_tot_sch_cnt_mem_wclk_rst_n               (i_hqm_sip_rf_cq_ldb_tot_sch_cnt_mem_wclk_rst_n),
       .rf_cq_ldb_tot_sch_cnt_mem_wdata                    (i_hqm_sip_rf_cq_ldb_tot_sch_cnt_mem_wdata),
       .rf_cq_ldb_tot_sch_cnt_mem_we                       (i_hqm_sip_rf_cq_ldb_tot_sch_cnt_mem_we),
       .rf_cq_ldb_wu_count_mem_raddr                       (i_hqm_sip_rf_cq_ldb_wu_count_mem_raddr),
       .rf_cq_ldb_wu_count_mem_rclk                        (i_hqm_sip_rf_cq_ldb_wu_count_mem_rclk),
       .rf_cq_ldb_wu_count_mem_rclk_rst_n                  (i_hqm_sip_rf_cq_ldb_wu_count_mem_rclk_rst_n),
       .rf_cq_ldb_wu_count_mem_re                          (i_hqm_sip_rf_cq_ldb_wu_count_mem_re),
       .rf_cq_ldb_wu_count_mem_waddr                       (i_hqm_sip_rf_cq_ldb_wu_count_mem_waddr),
       .rf_cq_ldb_wu_count_mem_wclk                        (i_hqm_sip_rf_cq_ldb_wu_count_mem_wclk),
       .rf_cq_ldb_wu_count_mem_wclk_rst_n                  (i_hqm_sip_rf_cq_ldb_wu_count_mem_wclk_rst_n),
       .rf_cq_ldb_wu_count_mem_wdata                       (i_hqm_sip_rf_cq_ldb_wu_count_mem_wdata),
       .rf_cq_ldb_wu_count_mem_we                          (i_hqm_sip_rf_cq_ldb_wu_count_mem_we),
       .rf_cq_nalb_pri_arbindex_mem_raddr                  (i_hqm_sip_rf_cq_nalb_pri_arbindex_mem_raddr),
       .rf_cq_nalb_pri_arbindex_mem_rclk                   (i_hqm_sip_rf_cq_nalb_pri_arbindex_mem_rclk),
       .rf_cq_nalb_pri_arbindex_mem_rclk_rst_n             (i_hqm_sip_rf_cq_nalb_pri_arbindex_mem_rclk_rst_n),
       .rf_cq_nalb_pri_arbindex_mem_re                     (i_hqm_sip_rf_cq_nalb_pri_arbindex_mem_re),
       .rf_cq_nalb_pri_arbindex_mem_waddr                  (i_hqm_sip_rf_cq_nalb_pri_arbindex_mem_waddr),
       .rf_cq_nalb_pri_arbindex_mem_wclk                   (i_hqm_sip_rf_cq_nalb_pri_arbindex_mem_wclk),
       .rf_cq_nalb_pri_arbindex_mem_wclk_rst_n             (i_hqm_sip_rf_cq_nalb_pri_arbindex_mem_wclk_rst_n),
       .rf_cq_nalb_pri_arbindex_mem_wdata                  (i_hqm_sip_rf_cq_nalb_pri_arbindex_mem_wdata),
       .rf_cq_nalb_pri_arbindex_mem_we                     (i_hqm_sip_rf_cq_nalb_pri_arbindex_mem_we),
       .rf_dir_cnt_raddr                                   (i_hqm_sip_rf_dir_cnt_raddr),
       .rf_dir_cnt_rclk                                    (i_hqm_sip_rf_dir_cnt_rclk),
       .rf_dir_cnt_rclk_rst_n                              (i_hqm_sip_rf_dir_cnt_rclk_rst_n),
       .rf_dir_cnt_re                                      (i_hqm_sip_rf_dir_cnt_re),
       .rf_dir_cnt_waddr                                   (i_hqm_sip_rf_dir_cnt_waddr),
       .rf_dir_cnt_wclk                                    (i_hqm_sip_rf_dir_cnt_wclk),
       .rf_dir_cnt_wclk_rst_n                              (i_hqm_sip_rf_dir_cnt_wclk_rst_n),
       .rf_dir_cnt_wdata                                   (i_hqm_sip_rf_dir_cnt_wdata),
       .rf_dir_cnt_we                                      (i_hqm_sip_rf_dir_cnt_we),
       .rf_dir_cq_depth_raddr                              (i_hqm_sip_rf_dir_cq_depth_raddr),
       .rf_dir_cq_depth_rclk                               (i_hqm_sip_rf_dir_cq_depth_rclk),
       .rf_dir_cq_depth_rclk_rst_n                         (i_hqm_sip_rf_dir_cq_depth_rclk_rst_n),
       .rf_dir_cq_depth_re                                 (i_hqm_sip_rf_dir_cq_depth_re),
       .rf_dir_cq_depth_waddr                              (i_hqm_sip_rf_dir_cq_depth_waddr),
       .rf_dir_cq_depth_wclk                               (i_hqm_sip_rf_dir_cq_depth_wclk),
       .rf_dir_cq_depth_wclk_rst_n                         (i_hqm_sip_rf_dir_cq_depth_wclk_rst_n),
       .rf_dir_cq_depth_wdata                              (i_hqm_sip_rf_dir_cq_depth_wdata),
       .rf_dir_cq_depth_we                                 (i_hqm_sip_rf_dir_cq_depth_we),
       .rf_dir_cq_intr_thresh_raddr                        (i_hqm_sip_rf_dir_cq_intr_thresh_raddr),
       .rf_dir_cq_intr_thresh_rclk                         (i_hqm_sip_rf_dir_cq_intr_thresh_rclk),
       .rf_dir_cq_intr_thresh_rclk_rst_n                   (i_hqm_sip_rf_dir_cq_intr_thresh_rclk_rst_n),
       .rf_dir_cq_intr_thresh_re                           (i_hqm_sip_rf_dir_cq_intr_thresh_re),
       .rf_dir_cq_intr_thresh_waddr                        (i_hqm_sip_rf_dir_cq_intr_thresh_waddr),
       .rf_dir_cq_intr_thresh_wclk                         (i_hqm_sip_rf_dir_cq_intr_thresh_wclk),
       .rf_dir_cq_intr_thresh_wclk_rst_n                   (i_hqm_sip_rf_dir_cq_intr_thresh_wclk_rst_n),
       .rf_dir_cq_intr_thresh_wdata                        (i_hqm_sip_rf_dir_cq_intr_thresh_wdata),
       .rf_dir_cq_intr_thresh_we                           (i_hqm_sip_rf_dir_cq_intr_thresh_we),
       .rf_dir_cq_token_depth_select_raddr                 (i_hqm_sip_rf_dir_cq_token_depth_select_raddr),
       .rf_dir_cq_token_depth_select_rclk                  (i_hqm_sip_rf_dir_cq_token_depth_select_rclk),
       .rf_dir_cq_token_depth_select_rclk_rst_n            (i_hqm_sip_rf_dir_cq_token_depth_select_rclk_rst_n),
       .rf_dir_cq_token_depth_select_re                    (i_hqm_sip_rf_dir_cq_token_depth_select_re),
       .rf_dir_cq_token_depth_select_waddr                 (i_hqm_sip_rf_dir_cq_token_depth_select_waddr),
       .rf_dir_cq_token_depth_select_wclk                  (i_hqm_sip_rf_dir_cq_token_depth_select_wclk),
       .rf_dir_cq_token_depth_select_wclk_rst_n            (i_hqm_sip_rf_dir_cq_token_depth_select_wclk_rst_n),
       .rf_dir_cq_token_depth_select_wdata                 (i_hqm_sip_rf_dir_cq_token_depth_select_wdata),
       .rf_dir_cq_token_depth_select_we                    (i_hqm_sip_rf_dir_cq_token_depth_select_we),
       .rf_dir_cq_wptr_raddr                               (i_hqm_sip_rf_dir_cq_wptr_raddr),
       .rf_dir_cq_wptr_rclk                                (i_hqm_sip_rf_dir_cq_wptr_rclk),
       .rf_dir_cq_wptr_rclk_rst_n                          (i_hqm_sip_rf_dir_cq_wptr_rclk_rst_n),
       .rf_dir_cq_wptr_re                                  (i_hqm_sip_rf_dir_cq_wptr_re),
       .rf_dir_cq_wptr_waddr                               (i_hqm_sip_rf_dir_cq_wptr_waddr),
       .rf_dir_cq_wptr_wclk                                (i_hqm_sip_rf_dir_cq_wptr_wclk),
       .rf_dir_cq_wptr_wclk_rst_n                          (i_hqm_sip_rf_dir_cq_wptr_wclk_rst_n),
       .rf_dir_cq_wptr_wdata                               (i_hqm_sip_rf_dir_cq_wptr_wdata),
       .rf_dir_cq_wptr_we                                  (i_hqm_sip_rf_dir_cq_wptr_we),
       .rf_dir_enq_cnt_mem_raddr                           (i_hqm_sip_rf_dir_enq_cnt_mem_raddr),
       .rf_dir_enq_cnt_mem_rclk                            (i_hqm_sip_rf_dir_enq_cnt_mem_rclk),
       .rf_dir_enq_cnt_mem_rclk_rst_n                      (i_hqm_sip_rf_dir_enq_cnt_mem_rclk_rst_n),
       .rf_dir_enq_cnt_mem_re                              (i_hqm_sip_rf_dir_enq_cnt_mem_re),
       .rf_dir_enq_cnt_mem_waddr                           (i_hqm_sip_rf_dir_enq_cnt_mem_waddr),
       .rf_dir_enq_cnt_mem_wclk                            (i_hqm_sip_rf_dir_enq_cnt_mem_wclk),
       .rf_dir_enq_cnt_mem_wclk_rst_n                      (i_hqm_sip_rf_dir_enq_cnt_mem_wclk_rst_n),
       .rf_dir_enq_cnt_mem_wdata                           (i_hqm_sip_rf_dir_enq_cnt_mem_wdata),
       .rf_dir_enq_cnt_mem_we                              (i_hqm_sip_rf_dir_enq_cnt_mem_we),
       .rf_dir_hp_raddr                                    (i_hqm_sip_rf_dir_hp_raddr),
       .rf_dir_hp_rclk                                     (i_hqm_sip_rf_dir_hp_rclk),
       .rf_dir_hp_rclk_rst_n                               (i_hqm_sip_rf_dir_hp_rclk_rst_n),
       .rf_dir_hp_re                                       (i_hqm_sip_rf_dir_hp_re),
       .rf_dir_hp_waddr                                    (i_hqm_sip_rf_dir_hp_waddr),
       .rf_dir_hp_wclk                                     (i_hqm_sip_rf_dir_hp_wclk),
       .rf_dir_hp_wclk_rst_n                               (i_hqm_sip_rf_dir_hp_wclk_rst_n),
       .rf_dir_hp_wdata                                    (i_hqm_sip_rf_dir_hp_wdata),
       .rf_dir_hp_we                                       (i_hqm_sip_rf_dir_hp_we),
       .rf_dir_replay_cnt_raddr                            (i_hqm_sip_rf_dir_replay_cnt_raddr),
       .rf_dir_replay_cnt_rclk                             (i_hqm_sip_rf_dir_replay_cnt_rclk),
       .rf_dir_replay_cnt_rclk_rst_n                       (i_hqm_sip_rf_dir_replay_cnt_rclk_rst_n),
       .rf_dir_replay_cnt_re                               (i_hqm_sip_rf_dir_replay_cnt_re),
       .rf_dir_replay_cnt_waddr                            (i_hqm_sip_rf_dir_replay_cnt_waddr),
       .rf_dir_replay_cnt_wclk                             (i_hqm_sip_rf_dir_replay_cnt_wclk),
       .rf_dir_replay_cnt_wclk_rst_n                       (i_hqm_sip_rf_dir_replay_cnt_wclk_rst_n),
       .rf_dir_replay_cnt_wdata                            (i_hqm_sip_rf_dir_replay_cnt_wdata),
       .rf_dir_replay_cnt_we                               (i_hqm_sip_rf_dir_replay_cnt_we),
       .rf_dir_replay_hp_raddr                             (i_hqm_sip_rf_dir_replay_hp_raddr),
       .rf_dir_replay_hp_rclk                              (i_hqm_sip_rf_dir_replay_hp_rclk),
       .rf_dir_replay_hp_rclk_rst_n                        (i_hqm_sip_rf_dir_replay_hp_rclk_rst_n),
       .rf_dir_replay_hp_re                                (i_hqm_sip_rf_dir_replay_hp_re),
       .rf_dir_replay_hp_waddr                             (i_hqm_sip_rf_dir_replay_hp_waddr),
       .rf_dir_replay_hp_wclk                              (i_hqm_sip_rf_dir_replay_hp_wclk),
       .rf_dir_replay_hp_wclk_rst_n                        (i_hqm_sip_rf_dir_replay_hp_wclk_rst_n),
       .rf_dir_replay_hp_wdata                             (i_hqm_sip_rf_dir_replay_hp_wdata),
       .rf_dir_replay_hp_we                                (i_hqm_sip_rf_dir_replay_hp_we),
       .rf_dir_replay_tp_raddr                             (i_hqm_sip_rf_dir_replay_tp_raddr),
       .rf_dir_replay_tp_rclk                              (i_hqm_sip_rf_dir_replay_tp_rclk),
       .rf_dir_replay_tp_rclk_rst_n                        (i_hqm_sip_rf_dir_replay_tp_rclk_rst_n),
       .rf_dir_replay_tp_re                                (i_hqm_sip_rf_dir_replay_tp_re),
       .rf_dir_replay_tp_waddr                             (i_hqm_sip_rf_dir_replay_tp_waddr),
       .rf_dir_replay_tp_wclk                              (i_hqm_sip_rf_dir_replay_tp_wclk),
       .rf_dir_replay_tp_wclk_rst_n                        (i_hqm_sip_rf_dir_replay_tp_wclk_rst_n),
       .rf_dir_replay_tp_wdata                             (i_hqm_sip_rf_dir_replay_tp_wdata),
       .rf_dir_replay_tp_we                                (i_hqm_sip_rf_dir_replay_tp_we),
       .rf_dir_rofrag_cnt_raddr                            (i_hqm_sip_rf_dir_rofrag_cnt_raddr),
       .rf_dir_rofrag_cnt_rclk                             (i_hqm_sip_rf_dir_rofrag_cnt_rclk),
       .rf_dir_rofrag_cnt_rclk_rst_n                       (i_hqm_sip_rf_dir_rofrag_cnt_rclk_rst_n),
       .rf_dir_rofrag_cnt_re                               (i_hqm_sip_rf_dir_rofrag_cnt_re),
       .rf_dir_rofrag_cnt_waddr                            (i_hqm_sip_rf_dir_rofrag_cnt_waddr),
       .rf_dir_rofrag_cnt_wclk                             (i_hqm_sip_rf_dir_rofrag_cnt_wclk),
       .rf_dir_rofrag_cnt_wclk_rst_n                       (i_hqm_sip_rf_dir_rofrag_cnt_wclk_rst_n),
       .rf_dir_rofrag_cnt_wdata                            (i_hqm_sip_rf_dir_rofrag_cnt_wdata),
       .rf_dir_rofrag_cnt_we                               (i_hqm_sip_rf_dir_rofrag_cnt_we),
       .rf_dir_rofrag_hp_raddr                             (i_hqm_sip_rf_dir_rofrag_hp_raddr),
       .rf_dir_rofrag_hp_rclk                              (i_hqm_sip_rf_dir_rofrag_hp_rclk),
       .rf_dir_rofrag_hp_rclk_rst_n                        (i_hqm_sip_rf_dir_rofrag_hp_rclk_rst_n),
       .rf_dir_rofrag_hp_re                                (i_hqm_sip_rf_dir_rofrag_hp_re),
       .rf_dir_rofrag_hp_waddr                             (i_hqm_sip_rf_dir_rofrag_hp_waddr),
       .rf_dir_rofrag_hp_wclk                              (i_hqm_sip_rf_dir_rofrag_hp_wclk),
       .rf_dir_rofrag_hp_wclk_rst_n                        (i_hqm_sip_rf_dir_rofrag_hp_wclk_rst_n),
       .rf_dir_rofrag_hp_wdata                             (i_hqm_sip_rf_dir_rofrag_hp_wdata),
       .rf_dir_rofrag_hp_we                                (i_hqm_sip_rf_dir_rofrag_hp_we),
       .rf_dir_rofrag_tp_raddr                             (i_hqm_sip_rf_dir_rofrag_tp_raddr),
       .rf_dir_rofrag_tp_rclk                              (i_hqm_sip_rf_dir_rofrag_tp_rclk),
       .rf_dir_rofrag_tp_rclk_rst_n                        (i_hqm_sip_rf_dir_rofrag_tp_rclk_rst_n),
       .rf_dir_rofrag_tp_re                                (i_hqm_sip_rf_dir_rofrag_tp_re),
       .rf_dir_rofrag_tp_waddr                             (i_hqm_sip_rf_dir_rofrag_tp_waddr),
       .rf_dir_rofrag_tp_wclk                              (i_hqm_sip_rf_dir_rofrag_tp_wclk),
       .rf_dir_rofrag_tp_wclk_rst_n                        (i_hqm_sip_rf_dir_rofrag_tp_wclk_rst_n),
       .rf_dir_rofrag_tp_wdata                             (i_hqm_sip_rf_dir_rofrag_tp_wdata),
       .rf_dir_rofrag_tp_we                                (i_hqm_sip_rf_dir_rofrag_tp_we),
       .rf_dir_rply_req_fifo_mem_raddr                     (i_hqm_sip_rf_dir_rply_req_fifo_mem_raddr),
       .rf_dir_rply_req_fifo_mem_rclk                      (i_hqm_sip_rf_dir_rply_req_fifo_mem_rclk),
       .rf_dir_rply_req_fifo_mem_rclk_rst_n                (i_hqm_sip_rf_dir_rply_req_fifo_mem_rclk_rst_n),
       .rf_dir_rply_req_fifo_mem_re                        (i_hqm_sip_rf_dir_rply_req_fifo_mem_re),
       .rf_dir_rply_req_fifo_mem_waddr                     (i_hqm_sip_rf_dir_rply_req_fifo_mem_waddr),
       .rf_dir_rply_req_fifo_mem_wclk                      (i_hqm_sip_rf_dir_rply_req_fifo_mem_wclk),
       .rf_dir_rply_req_fifo_mem_wclk_rst_n                (i_hqm_sip_rf_dir_rply_req_fifo_mem_wclk_rst_n),
       .rf_dir_rply_req_fifo_mem_wdata                     (i_hqm_sip_rf_dir_rply_req_fifo_mem_wdata),
       .rf_dir_rply_req_fifo_mem_we                        (i_hqm_sip_rf_dir_rply_req_fifo_mem_we),
       .rf_dir_tok_cnt_mem_raddr                           (i_hqm_sip_rf_dir_tok_cnt_mem_raddr),
       .rf_dir_tok_cnt_mem_rclk                            (i_hqm_sip_rf_dir_tok_cnt_mem_rclk),
       .rf_dir_tok_cnt_mem_rclk_rst_n                      (i_hqm_sip_rf_dir_tok_cnt_mem_rclk_rst_n),
       .rf_dir_tok_cnt_mem_re                              (i_hqm_sip_rf_dir_tok_cnt_mem_re),
       .rf_dir_tok_cnt_mem_waddr                           (i_hqm_sip_rf_dir_tok_cnt_mem_waddr),
       .rf_dir_tok_cnt_mem_wclk                            (i_hqm_sip_rf_dir_tok_cnt_mem_wclk),
       .rf_dir_tok_cnt_mem_wclk_rst_n                      (i_hqm_sip_rf_dir_tok_cnt_mem_wclk_rst_n),
       .rf_dir_tok_cnt_mem_wdata                           (i_hqm_sip_rf_dir_tok_cnt_mem_wdata),
       .rf_dir_tok_cnt_mem_we                              (i_hqm_sip_rf_dir_tok_cnt_mem_we),
       .rf_dir_tok_lim_mem_raddr                           (i_hqm_sip_rf_dir_tok_lim_mem_raddr),
       .rf_dir_tok_lim_mem_rclk                            (i_hqm_sip_rf_dir_tok_lim_mem_rclk),
       .rf_dir_tok_lim_mem_rclk_rst_n                      (i_hqm_sip_rf_dir_tok_lim_mem_rclk_rst_n),
       .rf_dir_tok_lim_mem_re                              (i_hqm_sip_rf_dir_tok_lim_mem_re),
       .rf_dir_tok_lim_mem_waddr                           (i_hqm_sip_rf_dir_tok_lim_mem_waddr),
       .rf_dir_tok_lim_mem_wclk                            (i_hqm_sip_rf_dir_tok_lim_mem_wclk),
       .rf_dir_tok_lim_mem_wclk_rst_n                      (i_hqm_sip_rf_dir_tok_lim_mem_wclk_rst_n),
       .rf_dir_tok_lim_mem_wdata                           (i_hqm_sip_rf_dir_tok_lim_mem_wdata),
       .rf_dir_tok_lim_mem_we                              (i_hqm_sip_rf_dir_tok_lim_mem_we),
       .rf_dir_tp_raddr                                    (i_hqm_sip_rf_dir_tp_raddr),
       .rf_dir_tp_rclk                                     (i_hqm_sip_rf_dir_tp_rclk),
       .rf_dir_tp_rclk_rst_n                               (i_hqm_sip_rf_dir_tp_rclk_rst_n),
       .rf_dir_tp_re                                       (i_hqm_sip_rf_dir_tp_re),
       .rf_dir_tp_waddr                                    (i_hqm_sip_rf_dir_tp_waddr),
       .rf_dir_tp_wclk                                     (i_hqm_sip_rf_dir_tp_wclk),
       .rf_dir_tp_wclk_rst_n                               (i_hqm_sip_rf_dir_tp_wclk_rst_n),
       .rf_dir_tp_wdata                                    (i_hqm_sip_rf_dir_tp_wdata),
       .rf_dir_tp_we                                       (i_hqm_sip_rf_dir_tp_we),
       .rf_dir_wb0_raddr                                   (i_hqm_sip_rf_dir_wb0_raddr),
       .rf_dir_wb0_rclk                                    (i_hqm_sip_rf_dir_wb0_rclk),
       .rf_dir_wb0_rclk_rst_n                              (i_hqm_sip_rf_dir_wb0_rclk_rst_n),
       .rf_dir_wb0_re                                      (i_hqm_sip_rf_dir_wb0_re),
       .rf_dir_wb0_waddr                                   (i_hqm_sip_rf_dir_wb0_waddr),
       .rf_dir_wb0_wclk                                    (i_hqm_sip_rf_dir_wb0_wclk),
       .rf_dir_wb0_wclk_rst_n                              (i_hqm_sip_rf_dir_wb0_wclk_rst_n),
       .rf_dir_wb0_wdata                                   (i_hqm_sip_rf_dir_wb0_wdata),
       .rf_dir_wb0_we                                      (i_hqm_sip_rf_dir_wb0_we),
       .rf_dir_wb1_raddr                                   (i_hqm_sip_rf_dir_wb1_raddr),
       .rf_dir_wb1_rclk                                    (i_hqm_sip_rf_dir_wb1_rclk),
       .rf_dir_wb1_rclk_rst_n                              (i_hqm_sip_rf_dir_wb1_rclk_rst_n),
       .rf_dir_wb1_re                                      (i_hqm_sip_rf_dir_wb1_re),
       .rf_dir_wb1_waddr                                   (i_hqm_sip_rf_dir_wb1_waddr),
       .rf_dir_wb1_wclk                                    (i_hqm_sip_rf_dir_wb1_wclk),
       .rf_dir_wb1_wclk_rst_n                              (i_hqm_sip_rf_dir_wb1_wclk_rst_n),
       .rf_dir_wb1_wdata                                   (i_hqm_sip_rf_dir_wb1_wdata),
       .rf_dir_wb1_we                                      (i_hqm_sip_rf_dir_wb1_we),
       .rf_dir_wb2_raddr                                   (i_hqm_sip_rf_dir_wb2_raddr),
       .rf_dir_wb2_rclk                                    (i_hqm_sip_rf_dir_wb2_rclk),
       .rf_dir_wb2_rclk_rst_n                              (i_hqm_sip_rf_dir_wb2_rclk_rst_n),
       .rf_dir_wb2_re                                      (i_hqm_sip_rf_dir_wb2_re),
       .rf_dir_wb2_waddr                                   (i_hqm_sip_rf_dir_wb2_waddr),
       .rf_dir_wb2_wclk                                    (i_hqm_sip_rf_dir_wb2_wclk),
       .rf_dir_wb2_wclk_rst_n                              (i_hqm_sip_rf_dir_wb2_wclk_rst_n),
       .rf_dir_wb2_wdata                                   (i_hqm_sip_rf_dir_wb2_wdata),
       .rf_dir_wb2_we                                      (i_hqm_sip_rf_dir_wb2_we),
       .rf_dp_dqed_raddr                                   (i_hqm_sip_rf_dp_dqed_raddr),
       .rf_dp_dqed_rclk                                    (i_hqm_sip_rf_dp_dqed_rclk),
       .rf_dp_dqed_rclk_rst_n                              (i_hqm_sip_rf_dp_dqed_rclk_rst_n),
       .rf_dp_dqed_re                                      (i_hqm_sip_rf_dp_dqed_re),
       .rf_dp_dqed_waddr                                   (i_hqm_sip_rf_dp_dqed_waddr),
       .rf_dp_dqed_wclk                                    (i_hqm_sip_rf_dp_dqed_wclk),
       .rf_dp_dqed_wclk_rst_n                              (i_hqm_sip_rf_dp_dqed_wclk_rst_n),
       .rf_dp_dqed_wdata                                   (i_hqm_sip_rf_dp_dqed_wdata),
       .rf_dp_dqed_we                                      (i_hqm_sip_rf_dp_dqed_we),
       .rf_dp_lsp_enq_dir_raddr                            (i_hqm_sip_rf_dp_lsp_enq_dir_raddr),
       .rf_dp_lsp_enq_dir_rclk                             (i_hqm_sip_rf_dp_lsp_enq_dir_rclk),
       .rf_dp_lsp_enq_dir_rclk_rst_n                       (i_hqm_sip_rf_dp_lsp_enq_dir_rclk_rst_n),
       .rf_dp_lsp_enq_dir_re                               (i_hqm_sip_rf_dp_lsp_enq_dir_re),
       .rf_dp_lsp_enq_dir_rx_sync_fifo_mem_raddr           (i_hqm_sip_rf_dp_lsp_enq_dir_rx_sync_fifo_mem_raddr),
       .rf_dp_lsp_enq_dir_rx_sync_fifo_mem_rclk            (i_hqm_sip_rf_dp_lsp_enq_dir_rx_sync_fifo_mem_rclk),
       .rf_dp_lsp_enq_dir_rx_sync_fifo_mem_rclk_rst_n      (i_hqm_sip_rf_dp_lsp_enq_dir_rx_sync_fifo_mem_rclk_rst_n),
       .rf_dp_lsp_enq_dir_rx_sync_fifo_mem_re              (i_hqm_sip_rf_dp_lsp_enq_dir_rx_sync_fifo_mem_re),
       .rf_dp_lsp_enq_dir_rx_sync_fifo_mem_waddr           (i_hqm_sip_rf_dp_lsp_enq_dir_rx_sync_fifo_mem_waddr),
       .rf_dp_lsp_enq_dir_rx_sync_fifo_mem_wclk            (i_hqm_sip_rf_dp_lsp_enq_dir_rx_sync_fifo_mem_wclk),
       .rf_dp_lsp_enq_dir_rx_sync_fifo_mem_wclk_rst_n      (i_hqm_sip_rf_dp_lsp_enq_dir_rx_sync_fifo_mem_wclk_rst_n),
       .rf_dp_lsp_enq_dir_rx_sync_fifo_mem_wdata           (i_hqm_sip_rf_dp_lsp_enq_dir_rx_sync_fifo_mem_wdata),
       .rf_dp_lsp_enq_dir_rx_sync_fifo_mem_we              (i_hqm_sip_rf_dp_lsp_enq_dir_rx_sync_fifo_mem_we),
       .rf_dp_lsp_enq_dir_waddr                            (i_hqm_sip_rf_dp_lsp_enq_dir_waddr),
       .rf_dp_lsp_enq_dir_wclk                             (i_hqm_sip_rf_dp_lsp_enq_dir_wclk),
       .rf_dp_lsp_enq_dir_wclk_rst_n                       (i_hqm_sip_rf_dp_lsp_enq_dir_wclk_rst_n),
       .rf_dp_lsp_enq_dir_wdata                            (i_hqm_sip_rf_dp_lsp_enq_dir_wdata),
       .rf_dp_lsp_enq_dir_we                               (i_hqm_sip_rf_dp_lsp_enq_dir_we),
       .rf_dp_lsp_enq_rorply_raddr                         (i_hqm_sip_rf_dp_lsp_enq_rorply_raddr),
       .rf_dp_lsp_enq_rorply_rclk                          (i_hqm_sip_rf_dp_lsp_enq_rorply_rclk),
       .rf_dp_lsp_enq_rorply_rclk_rst_n                    (i_hqm_sip_rf_dp_lsp_enq_rorply_rclk_rst_n),
       .rf_dp_lsp_enq_rorply_re                            (i_hqm_sip_rf_dp_lsp_enq_rorply_re),
       .rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_raddr        (i_hqm_sip_rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_raddr),
       .rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_rclk         (i_hqm_sip_rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_rclk),
       .rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_rclk_rst_n   (i_hqm_sip_rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_rclk_rst_n),
       .rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_re           (i_hqm_sip_rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_re),
       .rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_waddr        (i_hqm_sip_rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_waddr),
       .rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_wclk         (i_hqm_sip_rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_wclk),
       .rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_wclk_rst_n   (i_hqm_sip_rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_wclk_rst_n),
       .rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_wdata        (i_hqm_sip_rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_wdata),
       .rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_we           (i_hqm_sip_rf_dp_lsp_enq_rorply_rx_sync_fifo_mem_we),
       .rf_dp_lsp_enq_rorply_waddr                         (i_hqm_sip_rf_dp_lsp_enq_rorply_waddr),
       .rf_dp_lsp_enq_rorply_wclk                          (i_hqm_sip_rf_dp_lsp_enq_rorply_wclk),
       .rf_dp_lsp_enq_rorply_wclk_rst_n                    (i_hqm_sip_rf_dp_lsp_enq_rorply_wclk_rst_n),
       .rf_dp_lsp_enq_rorply_wdata                         (i_hqm_sip_rf_dp_lsp_enq_rorply_wdata),
       .rf_dp_lsp_enq_rorply_we                            (i_hqm_sip_rf_dp_lsp_enq_rorply_we),
       .rf_enq_nalb_fifo_mem_raddr                         (i_hqm_sip_rf_enq_nalb_fifo_mem_raddr),
       .rf_enq_nalb_fifo_mem_rclk                          (i_hqm_sip_rf_enq_nalb_fifo_mem_rclk),
       .rf_enq_nalb_fifo_mem_rclk_rst_n                    (i_hqm_sip_rf_enq_nalb_fifo_mem_rclk_rst_n),
       .rf_enq_nalb_fifo_mem_re                            (i_hqm_sip_rf_enq_nalb_fifo_mem_re),
       .rf_enq_nalb_fifo_mem_waddr                         (i_hqm_sip_rf_enq_nalb_fifo_mem_waddr),
       .rf_enq_nalb_fifo_mem_wclk                          (i_hqm_sip_rf_enq_nalb_fifo_mem_wclk),
       .rf_enq_nalb_fifo_mem_wclk_rst_n                    (i_hqm_sip_rf_enq_nalb_fifo_mem_wclk_rst_n),
       .rf_enq_nalb_fifo_mem_wdata                         (i_hqm_sip_rf_enq_nalb_fifo_mem_wdata),
       .rf_enq_nalb_fifo_mem_we                            (i_hqm_sip_rf_enq_nalb_fifo_mem_we),
       .rf_fid2cqqidix_raddr                               (i_hqm_sip_rf_fid2cqqidix_raddr),
       .rf_fid2cqqidix_rclk                                (i_hqm_sip_rf_fid2cqqidix_rclk),
       .rf_fid2cqqidix_rclk_rst_n                          (i_hqm_sip_rf_fid2cqqidix_rclk_rst_n),
       .rf_fid2cqqidix_re                                  (i_hqm_sip_rf_fid2cqqidix_re),
       .rf_fid2cqqidix_waddr                               (i_hqm_sip_rf_fid2cqqidix_waddr),
       .rf_fid2cqqidix_wclk                                (i_hqm_sip_rf_fid2cqqidix_wclk),
       .rf_fid2cqqidix_wclk_rst_n                          (i_hqm_sip_rf_fid2cqqidix_wclk_rst_n),
       .rf_fid2cqqidix_wdata                               (i_hqm_sip_rf_fid2cqqidix_wdata),
       .rf_fid2cqqidix_we                                  (i_hqm_sip_rf_fid2cqqidix_we),
       .rf_hcw_enq_fifo_raddr                              (i_hqm_sip_rf_hcw_enq_fifo_raddr),
       .rf_hcw_enq_fifo_rclk                               (i_hqm_sip_rf_hcw_enq_fifo_rclk),
       .rf_hcw_enq_fifo_rclk_rst_n                         (i_hqm_sip_rf_hcw_enq_fifo_rclk_rst_n),
       .rf_hcw_enq_fifo_re                                 (i_hqm_sip_rf_hcw_enq_fifo_re),
       .rf_hcw_enq_fifo_waddr                              (i_hqm_sip_rf_hcw_enq_fifo_waddr),
       .rf_hcw_enq_fifo_wclk                               (i_hqm_sip_rf_hcw_enq_fifo_wclk),
       .rf_hcw_enq_fifo_wclk_rst_n                         (i_hqm_sip_rf_hcw_enq_fifo_wclk_rst_n),
       .rf_hcw_enq_fifo_wdata                              (i_hqm_sip_rf_hcw_enq_fifo_wdata),
       .rf_hcw_enq_fifo_we                                 (i_hqm_sip_rf_hcw_enq_fifo_we),
       .rf_hcw_enq_w_rx_sync_mem_raddr                     (i_hqm_sip_rf_hcw_enq_w_rx_sync_mem_raddr),
       .rf_hcw_enq_w_rx_sync_mem_rclk                      (i_hqm_sip_rf_hcw_enq_w_rx_sync_mem_rclk),
       .rf_hcw_enq_w_rx_sync_mem_rclk_rst_n                (i_hqm_sip_rf_hcw_enq_w_rx_sync_mem_rclk_rst_n),
       .rf_hcw_enq_w_rx_sync_mem_re                        (i_hqm_sip_rf_hcw_enq_w_rx_sync_mem_re),
       .rf_hcw_enq_w_rx_sync_mem_waddr                     (i_hqm_sip_rf_hcw_enq_w_rx_sync_mem_waddr),
       .rf_hcw_enq_w_rx_sync_mem_wclk                      (i_hqm_sip_rf_hcw_enq_w_rx_sync_mem_wclk),
       .rf_hcw_enq_w_rx_sync_mem_wclk_rst_n                (i_hqm_sip_rf_hcw_enq_w_rx_sync_mem_wclk_rst_n),
       .rf_hcw_enq_w_rx_sync_mem_wdata                     (i_hqm_sip_rf_hcw_enq_w_rx_sync_mem_wdata),
       .rf_hcw_enq_w_rx_sync_mem_we                        (i_hqm_sip_rf_hcw_enq_w_rx_sync_mem_we),
       .rf_hist_list_a_minmax_raddr                        (i_hqm_sip_rf_hist_list_a_minmax_raddr),
       .rf_hist_list_a_minmax_rclk                         (i_hqm_sip_rf_hist_list_a_minmax_rclk),
       .rf_hist_list_a_minmax_rclk_rst_n                   (i_hqm_sip_rf_hist_list_a_minmax_rclk_rst_n),
       .rf_hist_list_a_minmax_re                           (i_hqm_sip_rf_hist_list_a_minmax_re),
       .rf_hist_list_a_minmax_waddr                        (i_hqm_sip_rf_hist_list_a_minmax_waddr),
       .rf_hist_list_a_minmax_wclk                         (i_hqm_sip_rf_hist_list_a_minmax_wclk),
       .rf_hist_list_a_minmax_wclk_rst_n                   (i_hqm_sip_rf_hist_list_a_minmax_wclk_rst_n),
       .rf_hist_list_a_minmax_wdata                        (i_hqm_sip_rf_hist_list_a_minmax_wdata),
       .rf_hist_list_a_minmax_we                           (i_hqm_sip_rf_hist_list_a_minmax_we),
       .rf_hist_list_a_ptr_raddr                           (i_hqm_sip_rf_hist_list_a_ptr_raddr),
       .rf_hist_list_a_ptr_rclk                            (i_hqm_sip_rf_hist_list_a_ptr_rclk),
       .rf_hist_list_a_ptr_rclk_rst_n                      (i_hqm_sip_rf_hist_list_a_ptr_rclk_rst_n),
       .rf_hist_list_a_ptr_re                              (i_hqm_sip_rf_hist_list_a_ptr_re),
       .rf_hist_list_a_ptr_waddr                           (i_hqm_sip_rf_hist_list_a_ptr_waddr),
       .rf_hist_list_a_ptr_wclk                            (i_hqm_sip_rf_hist_list_a_ptr_wclk),
       .rf_hist_list_a_ptr_wclk_rst_n                      (i_hqm_sip_rf_hist_list_a_ptr_wclk_rst_n),
       .rf_hist_list_a_ptr_wdata                           (i_hqm_sip_rf_hist_list_a_ptr_wdata),
       .rf_hist_list_a_ptr_we                              (i_hqm_sip_rf_hist_list_a_ptr_we),
       .rf_hist_list_minmax_raddr                          (i_hqm_sip_rf_hist_list_minmax_raddr),
       .rf_hist_list_minmax_rclk                           (i_hqm_sip_rf_hist_list_minmax_rclk),
       .rf_hist_list_minmax_rclk_rst_n                     (i_hqm_sip_rf_hist_list_minmax_rclk_rst_n),
       .rf_hist_list_minmax_re                             (i_hqm_sip_rf_hist_list_minmax_re),
       .rf_hist_list_minmax_waddr                          (i_hqm_sip_rf_hist_list_minmax_waddr),
       .rf_hist_list_minmax_wclk                           (i_hqm_sip_rf_hist_list_minmax_wclk),
       .rf_hist_list_minmax_wclk_rst_n                     (i_hqm_sip_rf_hist_list_minmax_wclk_rst_n),
       .rf_hist_list_minmax_wdata                          (i_hqm_sip_rf_hist_list_minmax_wdata),
       .rf_hist_list_minmax_we                             (i_hqm_sip_rf_hist_list_minmax_we),
       .rf_hist_list_ptr_raddr                             (i_hqm_sip_rf_hist_list_ptr_raddr),
       .rf_hist_list_ptr_rclk                              (i_hqm_sip_rf_hist_list_ptr_rclk),
       .rf_hist_list_ptr_rclk_rst_n                        (i_hqm_sip_rf_hist_list_ptr_rclk_rst_n),
       .rf_hist_list_ptr_re                                (i_hqm_sip_rf_hist_list_ptr_re),
       .rf_hist_list_ptr_waddr                             (i_hqm_sip_rf_hist_list_ptr_waddr),
       .rf_hist_list_ptr_wclk                              (i_hqm_sip_rf_hist_list_ptr_wclk),
       .rf_hist_list_ptr_wclk_rst_n                        (i_hqm_sip_rf_hist_list_ptr_wclk_rst_n),
       .rf_hist_list_ptr_wdata                             (i_hqm_sip_rf_hist_list_ptr_wdata),
       .rf_hist_list_ptr_we                                (i_hqm_sip_rf_hist_list_ptr_we),
       .rf_ibcpl_data_fifo_raddr                           (i_hqm_sip_rf_ibcpl_data_fifo_raddr),
       .rf_ibcpl_data_fifo_rclk                            (i_hqm_sip_rf_ibcpl_data_fifo_rclk),
       .rf_ibcpl_data_fifo_rclk_rst_n                      (i_hqm_sip_rf_ibcpl_data_fifo_rclk_rst_n),
       .rf_ibcpl_data_fifo_re                              (i_hqm_sip_rf_ibcpl_data_fifo_re),
       .rf_ibcpl_data_fifo_waddr                           (i_hqm_sip_rf_ibcpl_data_fifo_waddr),
       .rf_ibcpl_data_fifo_wclk                            (i_hqm_sip_rf_ibcpl_data_fifo_wclk),
       .rf_ibcpl_data_fifo_wclk_rst_n                      (i_hqm_sip_rf_ibcpl_data_fifo_wclk_rst_n),
       .rf_ibcpl_data_fifo_wdata                           (i_hqm_sip_rf_ibcpl_data_fifo_wdata),
       .rf_ibcpl_data_fifo_we                              (i_hqm_sip_rf_ibcpl_data_fifo_we),
       .rf_ibcpl_hdr_fifo_raddr                            (i_hqm_sip_rf_ibcpl_hdr_fifo_raddr),
       .rf_ibcpl_hdr_fifo_rclk                             (i_hqm_sip_rf_ibcpl_hdr_fifo_rclk),
       .rf_ibcpl_hdr_fifo_rclk_rst_n                       (i_hqm_sip_rf_ibcpl_hdr_fifo_rclk_rst_n),
       .rf_ibcpl_hdr_fifo_re                               (i_hqm_sip_rf_ibcpl_hdr_fifo_re),
       .rf_ibcpl_hdr_fifo_waddr                            (i_hqm_sip_rf_ibcpl_hdr_fifo_waddr),
       .rf_ibcpl_hdr_fifo_wclk                             (i_hqm_sip_rf_ibcpl_hdr_fifo_wclk),
       .rf_ibcpl_hdr_fifo_wclk_rst_n                       (i_hqm_sip_rf_ibcpl_hdr_fifo_wclk_rst_n),
       .rf_ibcpl_hdr_fifo_wdata                            (i_hqm_sip_rf_ibcpl_hdr_fifo_wdata),
       .rf_ibcpl_hdr_fifo_we                               (i_hqm_sip_rf_ibcpl_hdr_fifo_we),
       .rf_ldb_cq_depth_raddr                              (i_hqm_sip_rf_ldb_cq_depth_raddr),
       .rf_ldb_cq_depth_rclk                               (i_hqm_sip_rf_ldb_cq_depth_rclk),
       .rf_ldb_cq_depth_rclk_rst_n                         (i_hqm_sip_rf_ldb_cq_depth_rclk_rst_n),
       .rf_ldb_cq_depth_re                                 (i_hqm_sip_rf_ldb_cq_depth_re),
       .rf_ldb_cq_depth_waddr                              (i_hqm_sip_rf_ldb_cq_depth_waddr),
       .rf_ldb_cq_depth_wclk                               (i_hqm_sip_rf_ldb_cq_depth_wclk),
       .rf_ldb_cq_depth_wclk_rst_n                         (i_hqm_sip_rf_ldb_cq_depth_wclk_rst_n),
       .rf_ldb_cq_depth_wdata                              (i_hqm_sip_rf_ldb_cq_depth_wdata),
       .rf_ldb_cq_depth_we                                 (i_hqm_sip_rf_ldb_cq_depth_we),
       .rf_ldb_cq_intr_thresh_raddr                        (i_hqm_sip_rf_ldb_cq_intr_thresh_raddr),
       .rf_ldb_cq_intr_thresh_rclk                         (i_hqm_sip_rf_ldb_cq_intr_thresh_rclk),
       .rf_ldb_cq_intr_thresh_rclk_rst_n                   (i_hqm_sip_rf_ldb_cq_intr_thresh_rclk_rst_n),
       .rf_ldb_cq_intr_thresh_re                           (i_hqm_sip_rf_ldb_cq_intr_thresh_re),
       .rf_ldb_cq_intr_thresh_waddr                        (i_hqm_sip_rf_ldb_cq_intr_thresh_waddr),
       .rf_ldb_cq_intr_thresh_wclk                         (i_hqm_sip_rf_ldb_cq_intr_thresh_wclk),
       .rf_ldb_cq_intr_thresh_wclk_rst_n                   (i_hqm_sip_rf_ldb_cq_intr_thresh_wclk_rst_n),
       .rf_ldb_cq_intr_thresh_wdata                        (i_hqm_sip_rf_ldb_cq_intr_thresh_wdata),
       .rf_ldb_cq_intr_thresh_we                           (i_hqm_sip_rf_ldb_cq_intr_thresh_we),
       .rf_ldb_cq_on_off_threshold_raddr                   (i_hqm_sip_rf_ldb_cq_on_off_threshold_raddr),
       .rf_ldb_cq_on_off_threshold_rclk                    (i_hqm_sip_rf_ldb_cq_on_off_threshold_rclk),
       .rf_ldb_cq_on_off_threshold_rclk_rst_n              (i_hqm_sip_rf_ldb_cq_on_off_threshold_rclk_rst_n),
       .rf_ldb_cq_on_off_threshold_re                      (i_hqm_sip_rf_ldb_cq_on_off_threshold_re),
       .rf_ldb_cq_on_off_threshold_waddr                   (i_hqm_sip_rf_ldb_cq_on_off_threshold_waddr),
       .rf_ldb_cq_on_off_threshold_wclk                    (i_hqm_sip_rf_ldb_cq_on_off_threshold_wclk),
       .rf_ldb_cq_on_off_threshold_wclk_rst_n              (i_hqm_sip_rf_ldb_cq_on_off_threshold_wclk_rst_n),
       .rf_ldb_cq_on_off_threshold_wdata                   (i_hqm_sip_rf_ldb_cq_on_off_threshold_wdata),
       .rf_ldb_cq_on_off_threshold_we                      (i_hqm_sip_rf_ldb_cq_on_off_threshold_we),
       .rf_ldb_cq_token_depth_select_raddr                 (i_hqm_sip_rf_ldb_cq_token_depth_select_raddr),
       .rf_ldb_cq_token_depth_select_rclk                  (i_hqm_sip_rf_ldb_cq_token_depth_select_rclk),
       .rf_ldb_cq_token_depth_select_rclk_rst_n            (i_hqm_sip_rf_ldb_cq_token_depth_select_rclk_rst_n),
       .rf_ldb_cq_token_depth_select_re                    (i_hqm_sip_rf_ldb_cq_token_depth_select_re),
       .rf_ldb_cq_token_depth_select_waddr                 (i_hqm_sip_rf_ldb_cq_token_depth_select_waddr),
       .rf_ldb_cq_token_depth_select_wclk                  (i_hqm_sip_rf_ldb_cq_token_depth_select_wclk),
       .rf_ldb_cq_token_depth_select_wclk_rst_n            (i_hqm_sip_rf_ldb_cq_token_depth_select_wclk_rst_n),
       .rf_ldb_cq_token_depth_select_wdata                 (i_hqm_sip_rf_ldb_cq_token_depth_select_wdata),
       .rf_ldb_cq_token_depth_select_we                    (i_hqm_sip_rf_ldb_cq_token_depth_select_we),
       .rf_ldb_cq_wptr_raddr                               (i_hqm_sip_rf_ldb_cq_wptr_raddr),
       .rf_ldb_cq_wptr_rclk                                (i_hqm_sip_rf_ldb_cq_wptr_rclk),
       .rf_ldb_cq_wptr_rclk_rst_n                          (i_hqm_sip_rf_ldb_cq_wptr_rclk_rst_n),
       .rf_ldb_cq_wptr_re                                  (i_hqm_sip_rf_ldb_cq_wptr_re),
       .rf_ldb_cq_wptr_waddr                               (i_hqm_sip_rf_ldb_cq_wptr_waddr),
       .rf_ldb_cq_wptr_wclk                                (i_hqm_sip_rf_ldb_cq_wptr_wclk),
       .rf_ldb_cq_wptr_wclk_rst_n                          (i_hqm_sip_rf_ldb_cq_wptr_wclk_rst_n),
       .rf_ldb_cq_wptr_wdata                               (i_hqm_sip_rf_ldb_cq_wptr_wdata),
       .rf_ldb_cq_wptr_we                                  (i_hqm_sip_rf_ldb_cq_wptr_we),
       .rf_ldb_rply_req_fifo_mem_raddr                     (i_hqm_sip_rf_ldb_rply_req_fifo_mem_raddr),
       .rf_ldb_rply_req_fifo_mem_rclk                      (i_hqm_sip_rf_ldb_rply_req_fifo_mem_rclk),
       .rf_ldb_rply_req_fifo_mem_rclk_rst_n                (i_hqm_sip_rf_ldb_rply_req_fifo_mem_rclk_rst_n),
       .rf_ldb_rply_req_fifo_mem_re                        (i_hqm_sip_rf_ldb_rply_req_fifo_mem_re),
       .rf_ldb_rply_req_fifo_mem_waddr                     (i_hqm_sip_rf_ldb_rply_req_fifo_mem_waddr),
       .rf_ldb_rply_req_fifo_mem_wclk                      (i_hqm_sip_rf_ldb_rply_req_fifo_mem_wclk),
       .rf_ldb_rply_req_fifo_mem_wclk_rst_n                (i_hqm_sip_rf_ldb_rply_req_fifo_mem_wclk_rst_n),
       .rf_ldb_rply_req_fifo_mem_wdata                     (i_hqm_sip_rf_ldb_rply_req_fifo_mem_wdata),
       .rf_ldb_rply_req_fifo_mem_we                        (i_hqm_sip_rf_ldb_rply_req_fifo_mem_we),
       .rf_ldb_token_rtn_fifo_mem_raddr                    (i_hqm_sip_rf_ldb_token_rtn_fifo_mem_raddr),
       .rf_ldb_token_rtn_fifo_mem_rclk                     (i_hqm_sip_rf_ldb_token_rtn_fifo_mem_rclk),
       .rf_ldb_token_rtn_fifo_mem_rclk_rst_n               (i_hqm_sip_rf_ldb_token_rtn_fifo_mem_rclk_rst_n),
       .rf_ldb_token_rtn_fifo_mem_re                       (i_hqm_sip_rf_ldb_token_rtn_fifo_mem_re),
       .rf_ldb_token_rtn_fifo_mem_waddr                    (i_hqm_sip_rf_ldb_token_rtn_fifo_mem_waddr),
       .rf_ldb_token_rtn_fifo_mem_wclk                     (i_hqm_sip_rf_ldb_token_rtn_fifo_mem_wclk),
       .rf_ldb_token_rtn_fifo_mem_wclk_rst_n               (i_hqm_sip_rf_ldb_token_rtn_fifo_mem_wclk_rst_n),
       .rf_ldb_token_rtn_fifo_mem_wdata                    (i_hqm_sip_rf_ldb_token_rtn_fifo_mem_wdata),
       .rf_ldb_token_rtn_fifo_mem_we                       (i_hqm_sip_rf_ldb_token_rtn_fifo_mem_we),
       .rf_ldb_wb0_raddr                                   (i_hqm_sip_rf_ldb_wb0_raddr),
       .rf_ldb_wb0_rclk                                    (i_hqm_sip_rf_ldb_wb0_rclk),
       .rf_ldb_wb0_rclk_rst_n                              (i_hqm_sip_rf_ldb_wb0_rclk_rst_n),
       .rf_ldb_wb0_re                                      (i_hqm_sip_rf_ldb_wb0_re),
       .rf_ldb_wb0_waddr                                   (i_hqm_sip_rf_ldb_wb0_waddr),
       .rf_ldb_wb0_wclk                                    (i_hqm_sip_rf_ldb_wb0_wclk),
       .rf_ldb_wb0_wclk_rst_n                              (i_hqm_sip_rf_ldb_wb0_wclk_rst_n),
       .rf_ldb_wb0_wdata                                   (i_hqm_sip_rf_ldb_wb0_wdata),
       .rf_ldb_wb0_we                                      (i_hqm_sip_rf_ldb_wb0_we),
       .rf_ldb_wb1_raddr                                   (i_hqm_sip_rf_ldb_wb1_raddr),
       .rf_ldb_wb1_rclk                                    (i_hqm_sip_rf_ldb_wb1_rclk),
       .rf_ldb_wb1_rclk_rst_n                              (i_hqm_sip_rf_ldb_wb1_rclk_rst_n),
       .rf_ldb_wb1_re                                      (i_hqm_sip_rf_ldb_wb1_re),
       .rf_ldb_wb1_waddr                                   (i_hqm_sip_rf_ldb_wb1_waddr),
       .rf_ldb_wb1_wclk                                    (i_hqm_sip_rf_ldb_wb1_wclk),
       .rf_ldb_wb1_wclk_rst_n                              (i_hqm_sip_rf_ldb_wb1_wclk_rst_n),
       .rf_ldb_wb1_wdata                                   (i_hqm_sip_rf_ldb_wb1_wdata),
       .rf_ldb_wb1_we                                      (i_hqm_sip_rf_ldb_wb1_we),
       .rf_ldb_wb2_raddr                                   (i_hqm_sip_rf_ldb_wb2_raddr),
       .rf_ldb_wb2_rclk                                    (i_hqm_sip_rf_ldb_wb2_rclk),
       .rf_ldb_wb2_rclk_rst_n                              (i_hqm_sip_rf_ldb_wb2_rclk_rst_n),
       .rf_ldb_wb2_re                                      (i_hqm_sip_rf_ldb_wb2_re),
       .rf_ldb_wb2_waddr                                   (i_hqm_sip_rf_ldb_wb2_waddr),
       .rf_ldb_wb2_wclk                                    (i_hqm_sip_rf_ldb_wb2_wclk),
       .rf_ldb_wb2_wclk_rst_n                              (i_hqm_sip_rf_ldb_wb2_wclk_rst_n),
       .rf_ldb_wb2_wdata                                   (i_hqm_sip_rf_ldb_wb2_wdata),
       .rf_ldb_wb2_we                                      (i_hqm_sip_rf_ldb_wb2_we),
       .rf_ll_enq_cnt_r_bin0_dup0_raddr                    (i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup0_raddr),
       .rf_ll_enq_cnt_r_bin0_dup0_rclk                     (i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup0_rclk),
       .rf_ll_enq_cnt_r_bin0_dup0_rclk_rst_n               (i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup0_rclk_rst_n),
       .rf_ll_enq_cnt_r_bin0_dup0_re                       (i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup0_re),
       .rf_ll_enq_cnt_r_bin0_dup0_waddr                    (i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup0_waddr),
       .rf_ll_enq_cnt_r_bin0_dup0_wclk                     (i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup0_wclk),
       .rf_ll_enq_cnt_r_bin0_dup0_wclk_rst_n               (i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup0_wclk_rst_n),
       .rf_ll_enq_cnt_r_bin0_dup0_wdata                    (i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup0_wdata),
       .rf_ll_enq_cnt_r_bin0_dup0_we                       (i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup0_we),
       .rf_ll_enq_cnt_r_bin0_dup1_raddr                    (i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup1_raddr),
       .rf_ll_enq_cnt_r_bin0_dup1_rclk                     (i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup1_rclk),
       .rf_ll_enq_cnt_r_bin0_dup1_rclk_rst_n               (i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup1_rclk_rst_n),
       .rf_ll_enq_cnt_r_bin0_dup1_re                       (i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup1_re),
       .rf_ll_enq_cnt_r_bin0_dup1_waddr                    (i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup1_waddr),
       .rf_ll_enq_cnt_r_bin0_dup1_wclk                     (i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup1_wclk),
       .rf_ll_enq_cnt_r_bin0_dup1_wclk_rst_n               (i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup1_wclk_rst_n),
       .rf_ll_enq_cnt_r_bin0_dup1_wdata                    (i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup1_wdata),
       .rf_ll_enq_cnt_r_bin0_dup1_we                       (i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup1_we),
       .rf_ll_enq_cnt_r_bin0_dup2_raddr                    (i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup2_raddr),
       .rf_ll_enq_cnt_r_bin0_dup2_rclk                     (i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup2_rclk),
       .rf_ll_enq_cnt_r_bin0_dup2_rclk_rst_n               (i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup2_rclk_rst_n),
       .rf_ll_enq_cnt_r_bin0_dup2_re                       (i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup2_re),
       .rf_ll_enq_cnt_r_bin0_dup2_waddr                    (i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup2_waddr),
       .rf_ll_enq_cnt_r_bin0_dup2_wclk                     (i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup2_wclk),
       .rf_ll_enq_cnt_r_bin0_dup2_wclk_rst_n               (i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup2_wclk_rst_n),
       .rf_ll_enq_cnt_r_bin0_dup2_wdata                    (i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup2_wdata),
       .rf_ll_enq_cnt_r_bin0_dup2_we                       (i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup2_we),
       .rf_ll_enq_cnt_r_bin0_dup3_raddr                    (i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup3_raddr),
       .rf_ll_enq_cnt_r_bin0_dup3_rclk                     (i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup3_rclk),
       .rf_ll_enq_cnt_r_bin0_dup3_rclk_rst_n               (i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup3_rclk_rst_n),
       .rf_ll_enq_cnt_r_bin0_dup3_re                       (i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup3_re),
       .rf_ll_enq_cnt_r_bin0_dup3_waddr                    (i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup3_waddr),
       .rf_ll_enq_cnt_r_bin0_dup3_wclk                     (i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup3_wclk),
       .rf_ll_enq_cnt_r_bin0_dup3_wclk_rst_n               (i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup3_wclk_rst_n),
       .rf_ll_enq_cnt_r_bin0_dup3_wdata                    (i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup3_wdata),
       .rf_ll_enq_cnt_r_bin0_dup3_we                       (i_hqm_sip_rf_ll_enq_cnt_r_bin0_dup3_we),
       .rf_ll_enq_cnt_r_bin1_dup0_raddr                    (i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup0_raddr),
       .rf_ll_enq_cnt_r_bin1_dup0_rclk                     (i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup0_rclk),
       .rf_ll_enq_cnt_r_bin1_dup0_rclk_rst_n               (i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup0_rclk_rst_n),
       .rf_ll_enq_cnt_r_bin1_dup0_re                       (i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup0_re),
       .rf_ll_enq_cnt_r_bin1_dup0_waddr                    (i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup0_waddr),
       .rf_ll_enq_cnt_r_bin1_dup0_wclk                     (i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup0_wclk),
       .rf_ll_enq_cnt_r_bin1_dup0_wclk_rst_n               (i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup0_wclk_rst_n),
       .rf_ll_enq_cnt_r_bin1_dup0_wdata                    (i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup0_wdata),
       .rf_ll_enq_cnt_r_bin1_dup0_we                       (i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup0_we),
       .rf_ll_enq_cnt_r_bin1_dup1_raddr                    (i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup1_raddr),
       .rf_ll_enq_cnt_r_bin1_dup1_rclk                     (i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup1_rclk),
       .rf_ll_enq_cnt_r_bin1_dup1_rclk_rst_n               (i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup1_rclk_rst_n),
       .rf_ll_enq_cnt_r_bin1_dup1_re                       (i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup1_re),
       .rf_ll_enq_cnt_r_bin1_dup1_waddr                    (i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup1_waddr),
       .rf_ll_enq_cnt_r_bin1_dup1_wclk                     (i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup1_wclk),
       .rf_ll_enq_cnt_r_bin1_dup1_wclk_rst_n               (i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup1_wclk_rst_n),
       .rf_ll_enq_cnt_r_bin1_dup1_wdata                    (i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup1_wdata),
       .rf_ll_enq_cnt_r_bin1_dup1_we                       (i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup1_we),
       .rf_ll_enq_cnt_r_bin1_dup2_raddr                    (i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup2_raddr),
       .rf_ll_enq_cnt_r_bin1_dup2_rclk                     (i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup2_rclk),
       .rf_ll_enq_cnt_r_bin1_dup2_rclk_rst_n               (i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup2_rclk_rst_n),
       .rf_ll_enq_cnt_r_bin1_dup2_re                       (i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup2_re),
       .rf_ll_enq_cnt_r_bin1_dup2_waddr                    (i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup2_waddr),
       .rf_ll_enq_cnt_r_bin1_dup2_wclk                     (i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup2_wclk),
       .rf_ll_enq_cnt_r_bin1_dup2_wclk_rst_n               (i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup2_wclk_rst_n),
       .rf_ll_enq_cnt_r_bin1_dup2_wdata                    (i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup2_wdata),
       .rf_ll_enq_cnt_r_bin1_dup2_we                       (i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup2_we),
       .rf_ll_enq_cnt_r_bin1_dup3_raddr                    (i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup3_raddr),
       .rf_ll_enq_cnt_r_bin1_dup3_rclk                     (i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup3_rclk),
       .rf_ll_enq_cnt_r_bin1_dup3_rclk_rst_n               (i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup3_rclk_rst_n),
       .rf_ll_enq_cnt_r_bin1_dup3_re                       (i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup3_re),
       .rf_ll_enq_cnt_r_bin1_dup3_waddr                    (i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup3_waddr),
       .rf_ll_enq_cnt_r_bin1_dup3_wclk                     (i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup3_wclk),
       .rf_ll_enq_cnt_r_bin1_dup3_wclk_rst_n               (i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup3_wclk_rst_n),
       .rf_ll_enq_cnt_r_bin1_dup3_wdata                    (i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup3_wdata),
       .rf_ll_enq_cnt_r_bin1_dup3_we                       (i_hqm_sip_rf_ll_enq_cnt_r_bin1_dup3_we),
       .rf_ll_enq_cnt_r_bin2_dup0_raddr                    (i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup0_raddr),
       .rf_ll_enq_cnt_r_bin2_dup0_rclk                     (i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup0_rclk),
       .rf_ll_enq_cnt_r_bin2_dup0_rclk_rst_n               (i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup0_rclk_rst_n),
       .rf_ll_enq_cnt_r_bin2_dup0_re                       (i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup0_re),
       .rf_ll_enq_cnt_r_bin2_dup0_waddr                    (i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup0_waddr),
       .rf_ll_enq_cnt_r_bin2_dup0_wclk                     (i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup0_wclk),
       .rf_ll_enq_cnt_r_bin2_dup0_wclk_rst_n               (i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup0_wclk_rst_n),
       .rf_ll_enq_cnt_r_bin2_dup0_wdata                    (i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup0_wdata),
       .rf_ll_enq_cnt_r_bin2_dup0_we                       (i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup0_we),
       .rf_ll_enq_cnt_r_bin2_dup1_raddr                    (i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup1_raddr),
       .rf_ll_enq_cnt_r_bin2_dup1_rclk                     (i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup1_rclk),
       .rf_ll_enq_cnt_r_bin2_dup1_rclk_rst_n               (i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup1_rclk_rst_n),
       .rf_ll_enq_cnt_r_bin2_dup1_re                       (i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup1_re),
       .rf_ll_enq_cnt_r_bin2_dup1_waddr                    (i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup1_waddr),
       .rf_ll_enq_cnt_r_bin2_dup1_wclk                     (i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup1_wclk),
       .rf_ll_enq_cnt_r_bin2_dup1_wclk_rst_n               (i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup1_wclk_rst_n),
       .rf_ll_enq_cnt_r_bin2_dup1_wdata                    (i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup1_wdata),
       .rf_ll_enq_cnt_r_bin2_dup1_we                       (i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup1_we),
       .rf_ll_enq_cnt_r_bin2_dup2_raddr                    (i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup2_raddr),
       .rf_ll_enq_cnt_r_bin2_dup2_rclk                     (i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup2_rclk),
       .rf_ll_enq_cnt_r_bin2_dup2_rclk_rst_n               (i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup2_rclk_rst_n),
       .rf_ll_enq_cnt_r_bin2_dup2_re                       (i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup2_re),
       .rf_ll_enq_cnt_r_bin2_dup2_waddr                    (i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup2_waddr),
       .rf_ll_enq_cnt_r_bin2_dup2_wclk                     (i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup2_wclk),
       .rf_ll_enq_cnt_r_bin2_dup2_wclk_rst_n               (i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup2_wclk_rst_n),
       .rf_ll_enq_cnt_r_bin2_dup2_wdata                    (i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup2_wdata),
       .rf_ll_enq_cnt_r_bin2_dup2_we                       (i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup2_we),
       .rf_ll_enq_cnt_r_bin2_dup3_raddr                    (i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup3_raddr),
       .rf_ll_enq_cnt_r_bin2_dup3_rclk                     (i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup3_rclk),
       .rf_ll_enq_cnt_r_bin2_dup3_rclk_rst_n               (i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup3_rclk_rst_n),
       .rf_ll_enq_cnt_r_bin2_dup3_re                       (i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup3_re),
       .rf_ll_enq_cnt_r_bin2_dup3_waddr                    (i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup3_waddr),
       .rf_ll_enq_cnt_r_bin2_dup3_wclk                     (i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup3_wclk),
       .rf_ll_enq_cnt_r_bin2_dup3_wclk_rst_n               (i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup3_wclk_rst_n),
       .rf_ll_enq_cnt_r_bin2_dup3_wdata                    (i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup3_wdata),
       .rf_ll_enq_cnt_r_bin2_dup3_we                       (i_hqm_sip_rf_ll_enq_cnt_r_bin2_dup3_we),
       .rf_ll_enq_cnt_r_bin3_dup0_raddr                    (i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup0_raddr),
       .rf_ll_enq_cnt_r_bin3_dup0_rclk                     (i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup0_rclk),
       .rf_ll_enq_cnt_r_bin3_dup0_rclk_rst_n               (i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup0_rclk_rst_n),
       .rf_ll_enq_cnt_r_bin3_dup0_re                       (i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup0_re),
       .rf_ll_enq_cnt_r_bin3_dup0_waddr                    (i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup0_waddr),
       .rf_ll_enq_cnt_r_bin3_dup0_wclk                     (i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup0_wclk),
       .rf_ll_enq_cnt_r_bin3_dup0_wclk_rst_n               (i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup0_wclk_rst_n),
       .rf_ll_enq_cnt_r_bin3_dup0_wdata                    (i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup0_wdata),
       .rf_ll_enq_cnt_r_bin3_dup0_we                       (i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup0_we),
       .rf_ll_enq_cnt_r_bin3_dup1_raddr                    (i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup1_raddr),
       .rf_ll_enq_cnt_r_bin3_dup1_rclk                     (i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup1_rclk),
       .rf_ll_enq_cnt_r_bin3_dup1_rclk_rst_n               (i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup1_rclk_rst_n),
       .rf_ll_enq_cnt_r_bin3_dup1_re                       (i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup1_re),
       .rf_ll_enq_cnt_r_bin3_dup1_waddr                    (i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup1_waddr),
       .rf_ll_enq_cnt_r_bin3_dup1_wclk                     (i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup1_wclk),
       .rf_ll_enq_cnt_r_bin3_dup1_wclk_rst_n               (i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup1_wclk_rst_n),
       .rf_ll_enq_cnt_r_bin3_dup1_wdata                    (i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup1_wdata),
       .rf_ll_enq_cnt_r_bin3_dup1_we                       (i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup1_we),
       .rf_ll_enq_cnt_r_bin3_dup2_raddr                    (i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup2_raddr),
       .rf_ll_enq_cnt_r_bin3_dup2_rclk                     (i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup2_rclk),
       .rf_ll_enq_cnt_r_bin3_dup2_rclk_rst_n               (i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup2_rclk_rst_n),
       .rf_ll_enq_cnt_r_bin3_dup2_re                       (i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup2_re),
       .rf_ll_enq_cnt_r_bin3_dup2_waddr                    (i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup2_waddr),
       .rf_ll_enq_cnt_r_bin3_dup2_wclk                     (i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup2_wclk),
       .rf_ll_enq_cnt_r_bin3_dup2_wclk_rst_n               (i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup2_wclk_rst_n),
       .rf_ll_enq_cnt_r_bin3_dup2_wdata                    (i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup2_wdata),
       .rf_ll_enq_cnt_r_bin3_dup2_we                       (i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup2_we),
       .rf_ll_enq_cnt_r_bin3_dup3_raddr                    (i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup3_raddr),
       .rf_ll_enq_cnt_r_bin3_dup3_rclk                     (i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup3_rclk),
       .rf_ll_enq_cnt_r_bin3_dup3_rclk_rst_n               (i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup3_rclk_rst_n),
       .rf_ll_enq_cnt_r_bin3_dup3_re                       (i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup3_re),
       .rf_ll_enq_cnt_r_bin3_dup3_waddr                    (i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup3_waddr),
       .rf_ll_enq_cnt_r_bin3_dup3_wclk                     (i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup3_wclk),
       .rf_ll_enq_cnt_r_bin3_dup3_wclk_rst_n               (i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup3_wclk_rst_n),
       .rf_ll_enq_cnt_r_bin3_dup3_wdata                    (i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup3_wdata),
       .rf_ll_enq_cnt_r_bin3_dup3_we                       (i_hqm_sip_rf_ll_enq_cnt_r_bin3_dup3_we),
       .rf_ll_enq_cnt_s_bin0_raddr                         (i_hqm_sip_rf_ll_enq_cnt_s_bin0_raddr),
       .rf_ll_enq_cnt_s_bin0_rclk                          (i_hqm_sip_rf_ll_enq_cnt_s_bin0_rclk),
       .rf_ll_enq_cnt_s_bin0_rclk_rst_n                    (i_hqm_sip_rf_ll_enq_cnt_s_bin0_rclk_rst_n),
       .rf_ll_enq_cnt_s_bin0_re                            (i_hqm_sip_rf_ll_enq_cnt_s_bin0_re),
       .rf_ll_enq_cnt_s_bin0_waddr                         (i_hqm_sip_rf_ll_enq_cnt_s_bin0_waddr),
       .rf_ll_enq_cnt_s_bin0_wclk                          (i_hqm_sip_rf_ll_enq_cnt_s_bin0_wclk),
       .rf_ll_enq_cnt_s_bin0_wclk_rst_n                    (i_hqm_sip_rf_ll_enq_cnt_s_bin0_wclk_rst_n),
       .rf_ll_enq_cnt_s_bin0_wdata                         (i_hqm_sip_rf_ll_enq_cnt_s_bin0_wdata),
       .rf_ll_enq_cnt_s_bin0_we                            (i_hqm_sip_rf_ll_enq_cnt_s_bin0_we),
       .rf_ll_enq_cnt_s_bin1_raddr                         (i_hqm_sip_rf_ll_enq_cnt_s_bin1_raddr),
       .rf_ll_enq_cnt_s_bin1_rclk                          (i_hqm_sip_rf_ll_enq_cnt_s_bin1_rclk),
       .rf_ll_enq_cnt_s_bin1_rclk_rst_n                    (i_hqm_sip_rf_ll_enq_cnt_s_bin1_rclk_rst_n),
       .rf_ll_enq_cnt_s_bin1_re                            (i_hqm_sip_rf_ll_enq_cnt_s_bin1_re),
       .rf_ll_enq_cnt_s_bin1_waddr                         (i_hqm_sip_rf_ll_enq_cnt_s_bin1_waddr),
       .rf_ll_enq_cnt_s_bin1_wclk                          (i_hqm_sip_rf_ll_enq_cnt_s_bin1_wclk),
       .rf_ll_enq_cnt_s_bin1_wclk_rst_n                    (i_hqm_sip_rf_ll_enq_cnt_s_bin1_wclk_rst_n),
       .rf_ll_enq_cnt_s_bin1_wdata                         (i_hqm_sip_rf_ll_enq_cnt_s_bin1_wdata),
       .rf_ll_enq_cnt_s_bin1_we                            (i_hqm_sip_rf_ll_enq_cnt_s_bin1_we),
       .rf_ll_enq_cnt_s_bin2_raddr                         (i_hqm_sip_rf_ll_enq_cnt_s_bin2_raddr),
       .rf_ll_enq_cnt_s_bin2_rclk                          (i_hqm_sip_rf_ll_enq_cnt_s_bin2_rclk),
       .rf_ll_enq_cnt_s_bin2_rclk_rst_n                    (i_hqm_sip_rf_ll_enq_cnt_s_bin2_rclk_rst_n),
       .rf_ll_enq_cnt_s_bin2_re                            (i_hqm_sip_rf_ll_enq_cnt_s_bin2_re),
       .rf_ll_enq_cnt_s_bin2_waddr                         (i_hqm_sip_rf_ll_enq_cnt_s_bin2_waddr),
       .rf_ll_enq_cnt_s_bin2_wclk                          (i_hqm_sip_rf_ll_enq_cnt_s_bin2_wclk),
       .rf_ll_enq_cnt_s_bin2_wclk_rst_n                    (i_hqm_sip_rf_ll_enq_cnt_s_bin2_wclk_rst_n),
       .rf_ll_enq_cnt_s_bin2_wdata                         (i_hqm_sip_rf_ll_enq_cnt_s_bin2_wdata),
       .rf_ll_enq_cnt_s_bin2_we                            (i_hqm_sip_rf_ll_enq_cnt_s_bin2_we),
       .rf_ll_enq_cnt_s_bin3_raddr                         (i_hqm_sip_rf_ll_enq_cnt_s_bin3_raddr),
       .rf_ll_enq_cnt_s_bin3_rclk                          (i_hqm_sip_rf_ll_enq_cnt_s_bin3_rclk),
       .rf_ll_enq_cnt_s_bin3_rclk_rst_n                    (i_hqm_sip_rf_ll_enq_cnt_s_bin3_rclk_rst_n),
       .rf_ll_enq_cnt_s_bin3_re                            (i_hqm_sip_rf_ll_enq_cnt_s_bin3_re),
       .rf_ll_enq_cnt_s_bin3_waddr                         (i_hqm_sip_rf_ll_enq_cnt_s_bin3_waddr),
       .rf_ll_enq_cnt_s_bin3_wclk                          (i_hqm_sip_rf_ll_enq_cnt_s_bin3_wclk),
       .rf_ll_enq_cnt_s_bin3_wclk_rst_n                    (i_hqm_sip_rf_ll_enq_cnt_s_bin3_wclk_rst_n),
       .rf_ll_enq_cnt_s_bin3_wdata                         (i_hqm_sip_rf_ll_enq_cnt_s_bin3_wdata),
       .rf_ll_enq_cnt_s_bin3_we                            (i_hqm_sip_rf_ll_enq_cnt_s_bin3_we),
       .rf_ll_rdylst_hp_bin0_raddr                         (i_hqm_sip_rf_ll_rdylst_hp_bin0_raddr),
       .rf_ll_rdylst_hp_bin0_rclk                          (i_hqm_sip_rf_ll_rdylst_hp_bin0_rclk),
       .rf_ll_rdylst_hp_bin0_rclk_rst_n                    (i_hqm_sip_rf_ll_rdylst_hp_bin0_rclk_rst_n),
       .rf_ll_rdylst_hp_bin0_re                            (i_hqm_sip_rf_ll_rdylst_hp_bin0_re),
       .rf_ll_rdylst_hp_bin0_waddr                         (i_hqm_sip_rf_ll_rdylst_hp_bin0_waddr),
       .rf_ll_rdylst_hp_bin0_wclk                          (i_hqm_sip_rf_ll_rdylst_hp_bin0_wclk),
       .rf_ll_rdylst_hp_bin0_wclk_rst_n                    (i_hqm_sip_rf_ll_rdylst_hp_bin0_wclk_rst_n),
       .rf_ll_rdylst_hp_bin0_wdata                         (i_hqm_sip_rf_ll_rdylst_hp_bin0_wdata),
       .rf_ll_rdylst_hp_bin0_we                            (i_hqm_sip_rf_ll_rdylst_hp_bin0_we),
       .rf_ll_rdylst_hp_bin1_raddr                         (i_hqm_sip_rf_ll_rdylst_hp_bin1_raddr),
       .rf_ll_rdylst_hp_bin1_rclk                          (i_hqm_sip_rf_ll_rdylst_hp_bin1_rclk),
       .rf_ll_rdylst_hp_bin1_rclk_rst_n                    (i_hqm_sip_rf_ll_rdylst_hp_bin1_rclk_rst_n),
       .rf_ll_rdylst_hp_bin1_re                            (i_hqm_sip_rf_ll_rdylst_hp_bin1_re),
       .rf_ll_rdylst_hp_bin1_waddr                         (i_hqm_sip_rf_ll_rdylst_hp_bin1_waddr),
       .rf_ll_rdylst_hp_bin1_wclk                          (i_hqm_sip_rf_ll_rdylst_hp_bin1_wclk),
       .rf_ll_rdylst_hp_bin1_wclk_rst_n                    (i_hqm_sip_rf_ll_rdylst_hp_bin1_wclk_rst_n),
       .rf_ll_rdylst_hp_bin1_wdata                         (i_hqm_sip_rf_ll_rdylst_hp_bin1_wdata),
       .rf_ll_rdylst_hp_bin1_we                            (i_hqm_sip_rf_ll_rdylst_hp_bin1_we),
       .rf_ll_rdylst_hp_bin2_raddr                         (i_hqm_sip_rf_ll_rdylst_hp_bin2_raddr),
       .rf_ll_rdylst_hp_bin2_rclk                          (i_hqm_sip_rf_ll_rdylst_hp_bin2_rclk),
       .rf_ll_rdylst_hp_bin2_rclk_rst_n                    (i_hqm_sip_rf_ll_rdylst_hp_bin2_rclk_rst_n),
       .rf_ll_rdylst_hp_bin2_re                            (i_hqm_sip_rf_ll_rdylst_hp_bin2_re),
       .rf_ll_rdylst_hp_bin2_waddr                         (i_hqm_sip_rf_ll_rdylst_hp_bin2_waddr),
       .rf_ll_rdylst_hp_bin2_wclk                          (i_hqm_sip_rf_ll_rdylst_hp_bin2_wclk),
       .rf_ll_rdylst_hp_bin2_wclk_rst_n                    (i_hqm_sip_rf_ll_rdylst_hp_bin2_wclk_rst_n),
       .rf_ll_rdylst_hp_bin2_wdata                         (i_hqm_sip_rf_ll_rdylst_hp_bin2_wdata),
       .rf_ll_rdylst_hp_bin2_we                            (i_hqm_sip_rf_ll_rdylst_hp_bin2_we),
       .rf_ll_rdylst_hp_bin3_raddr                         (i_hqm_sip_rf_ll_rdylst_hp_bin3_raddr),
       .rf_ll_rdylst_hp_bin3_rclk                          (i_hqm_sip_rf_ll_rdylst_hp_bin3_rclk),
       .rf_ll_rdylst_hp_bin3_rclk_rst_n                    (i_hqm_sip_rf_ll_rdylst_hp_bin3_rclk_rst_n),
       .rf_ll_rdylst_hp_bin3_re                            (i_hqm_sip_rf_ll_rdylst_hp_bin3_re),
       .rf_ll_rdylst_hp_bin3_waddr                         (i_hqm_sip_rf_ll_rdylst_hp_bin3_waddr),
       .rf_ll_rdylst_hp_bin3_wclk                          (i_hqm_sip_rf_ll_rdylst_hp_bin3_wclk),
       .rf_ll_rdylst_hp_bin3_wclk_rst_n                    (i_hqm_sip_rf_ll_rdylst_hp_bin3_wclk_rst_n),
       .rf_ll_rdylst_hp_bin3_wdata                         (i_hqm_sip_rf_ll_rdylst_hp_bin3_wdata),
       .rf_ll_rdylst_hp_bin3_we                            (i_hqm_sip_rf_ll_rdylst_hp_bin3_we),
       .rf_ll_rdylst_hpnxt_bin0_raddr                      (i_hqm_sip_rf_ll_rdylst_hpnxt_bin0_raddr),
       .rf_ll_rdylst_hpnxt_bin0_rclk                       (i_hqm_sip_rf_ll_rdylst_hpnxt_bin0_rclk),
       .rf_ll_rdylst_hpnxt_bin0_rclk_rst_n                 (i_hqm_sip_rf_ll_rdylst_hpnxt_bin0_rclk_rst_n),
       .rf_ll_rdylst_hpnxt_bin0_re                         (i_hqm_sip_rf_ll_rdylst_hpnxt_bin0_re),
       .rf_ll_rdylst_hpnxt_bin0_waddr                      (i_hqm_sip_rf_ll_rdylst_hpnxt_bin0_waddr),
       .rf_ll_rdylst_hpnxt_bin0_wclk                       (i_hqm_sip_rf_ll_rdylst_hpnxt_bin0_wclk),
       .rf_ll_rdylst_hpnxt_bin0_wclk_rst_n                 (i_hqm_sip_rf_ll_rdylst_hpnxt_bin0_wclk_rst_n),
       .rf_ll_rdylst_hpnxt_bin0_wdata                      (i_hqm_sip_rf_ll_rdylst_hpnxt_bin0_wdata),
       .rf_ll_rdylst_hpnxt_bin0_we                         (i_hqm_sip_rf_ll_rdylst_hpnxt_bin0_we),
       .rf_ll_rdylst_hpnxt_bin1_raddr                      (i_hqm_sip_rf_ll_rdylst_hpnxt_bin1_raddr),
       .rf_ll_rdylst_hpnxt_bin1_rclk                       (i_hqm_sip_rf_ll_rdylst_hpnxt_bin1_rclk),
       .rf_ll_rdylst_hpnxt_bin1_rclk_rst_n                 (i_hqm_sip_rf_ll_rdylst_hpnxt_bin1_rclk_rst_n),
       .rf_ll_rdylst_hpnxt_bin1_re                         (i_hqm_sip_rf_ll_rdylst_hpnxt_bin1_re),
       .rf_ll_rdylst_hpnxt_bin1_waddr                      (i_hqm_sip_rf_ll_rdylst_hpnxt_bin1_waddr),
       .rf_ll_rdylst_hpnxt_bin1_wclk                       (i_hqm_sip_rf_ll_rdylst_hpnxt_bin1_wclk),
       .rf_ll_rdylst_hpnxt_bin1_wclk_rst_n                 (i_hqm_sip_rf_ll_rdylst_hpnxt_bin1_wclk_rst_n),
       .rf_ll_rdylst_hpnxt_bin1_wdata                      (i_hqm_sip_rf_ll_rdylst_hpnxt_bin1_wdata),
       .rf_ll_rdylst_hpnxt_bin1_we                         (i_hqm_sip_rf_ll_rdylst_hpnxt_bin1_we),
       .rf_ll_rdylst_hpnxt_bin2_raddr                      (i_hqm_sip_rf_ll_rdylst_hpnxt_bin2_raddr),
       .rf_ll_rdylst_hpnxt_bin2_rclk                       (i_hqm_sip_rf_ll_rdylst_hpnxt_bin2_rclk),
       .rf_ll_rdylst_hpnxt_bin2_rclk_rst_n                 (i_hqm_sip_rf_ll_rdylst_hpnxt_bin2_rclk_rst_n),
       .rf_ll_rdylst_hpnxt_bin2_re                         (i_hqm_sip_rf_ll_rdylst_hpnxt_bin2_re),
       .rf_ll_rdylst_hpnxt_bin2_waddr                      (i_hqm_sip_rf_ll_rdylst_hpnxt_bin2_waddr),
       .rf_ll_rdylst_hpnxt_bin2_wclk                       (i_hqm_sip_rf_ll_rdylst_hpnxt_bin2_wclk),
       .rf_ll_rdylst_hpnxt_bin2_wclk_rst_n                 (i_hqm_sip_rf_ll_rdylst_hpnxt_bin2_wclk_rst_n),
       .rf_ll_rdylst_hpnxt_bin2_wdata                      (i_hqm_sip_rf_ll_rdylst_hpnxt_bin2_wdata),
       .rf_ll_rdylst_hpnxt_bin2_we                         (i_hqm_sip_rf_ll_rdylst_hpnxt_bin2_we),
       .rf_ll_rdylst_hpnxt_bin3_raddr                      (i_hqm_sip_rf_ll_rdylst_hpnxt_bin3_raddr),
       .rf_ll_rdylst_hpnxt_bin3_rclk                       (i_hqm_sip_rf_ll_rdylst_hpnxt_bin3_rclk),
       .rf_ll_rdylst_hpnxt_bin3_rclk_rst_n                 (i_hqm_sip_rf_ll_rdylst_hpnxt_bin3_rclk_rst_n),
       .rf_ll_rdylst_hpnxt_bin3_re                         (i_hqm_sip_rf_ll_rdylst_hpnxt_bin3_re),
       .rf_ll_rdylst_hpnxt_bin3_waddr                      (i_hqm_sip_rf_ll_rdylst_hpnxt_bin3_waddr),
       .rf_ll_rdylst_hpnxt_bin3_wclk                       (i_hqm_sip_rf_ll_rdylst_hpnxt_bin3_wclk),
       .rf_ll_rdylst_hpnxt_bin3_wclk_rst_n                 (i_hqm_sip_rf_ll_rdylst_hpnxt_bin3_wclk_rst_n),
       .rf_ll_rdylst_hpnxt_bin3_wdata                      (i_hqm_sip_rf_ll_rdylst_hpnxt_bin3_wdata),
       .rf_ll_rdylst_hpnxt_bin3_we                         (i_hqm_sip_rf_ll_rdylst_hpnxt_bin3_we),
       .rf_ll_rdylst_tp_bin0_raddr                         (i_hqm_sip_rf_ll_rdylst_tp_bin0_raddr),
       .rf_ll_rdylst_tp_bin0_rclk                          (i_hqm_sip_rf_ll_rdylst_tp_bin0_rclk),
       .rf_ll_rdylst_tp_bin0_rclk_rst_n                    (i_hqm_sip_rf_ll_rdylst_tp_bin0_rclk_rst_n),
       .rf_ll_rdylst_tp_bin0_re                            (i_hqm_sip_rf_ll_rdylst_tp_bin0_re),
       .rf_ll_rdylst_tp_bin0_waddr                         (i_hqm_sip_rf_ll_rdylst_tp_bin0_waddr),
       .rf_ll_rdylst_tp_bin0_wclk                          (i_hqm_sip_rf_ll_rdylst_tp_bin0_wclk),
       .rf_ll_rdylst_tp_bin0_wclk_rst_n                    (i_hqm_sip_rf_ll_rdylst_tp_bin0_wclk_rst_n),
       .rf_ll_rdylst_tp_bin0_wdata                         (i_hqm_sip_rf_ll_rdylst_tp_bin0_wdata),
       .rf_ll_rdylst_tp_bin0_we                            (i_hqm_sip_rf_ll_rdylst_tp_bin0_we),
       .rf_ll_rdylst_tp_bin1_raddr                         (i_hqm_sip_rf_ll_rdylst_tp_bin1_raddr),
       .rf_ll_rdylst_tp_bin1_rclk                          (i_hqm_sip_rf_ll_rdylst_tp_bin1_rclk),
       .rf_ll_rdylst_tp_bin1_rclk_rst_n                    (i_hqm_sip_rf_ll_rdylst_tp_bin1_rclk_rst_n),
       .rf_ll_rdylst_tp_bin1_re                            (i_hqm_sip_rf_ll_rdylst_tp_bin1_re),
       .rf_ll_rdylst_tp_bin1_waddr                         (i_hqm_sip_rf_ll_rdylst_tp_bin1_waddr),
       .rf_ll_rdylst_tp_bin1_wclk                          (i_hqm_sip_rf_ll_rdylst_tp_bin1_wclk),
       .rf_ll_rdylst_tp_bin1_wclk_rst_n                    (i_hqm_sip_rf_ll_rdylst_tp_bin1_wclk_rst_n),
       .rf_ll_rdylst_tp_bin1_wdata                         (i_hqm_sip_rf_ll_rdylst_tp_bin1_wdata),
       .rf_ll_rdylst_tp_bin1_we                            (i_hqm_sip_rf_ll_rdylst_tp_bin1_we),
       .rf_ll_rdylst_tp_bin2_raddr                         (i_hqm_sip_rf_ll_rdylst_tp_bin2_raddr),
       .rf_ll_rdylst_tp_bin2_rclk                          (i_hqm_sip_rf_ll_rdylst_tp_bin2_rclk),
       .rf_ll_rdylst_tp_bin2_rclk_rst_n                    (i_hqm_sip_rf_ll_rdylst_tp_bin2_rclk_rst_n),
       .rf_ll_rdylst_tp_bin2_re                            (i_hqm_sip_rf_ll_rdylst_tp_bin2_re),
       .rf_ll_rdylst_tp_bin2_waddr                         (i_hqm_sip_rf_ll_rdylst_tp_bin2_waddr),
       .rf_ll_rdylst_tp_bin2_wclk                          (i_hqm_sip_rf_ll_rdylst_tp_bin2_wclk),
       .rf_ll_rdylst_tp_bin2_wclk_rst_n                    (i_hqm_sip_rf_ll_rdylst_tp_bin2_wclk_rst_n),
       .rf_ll_rdylst_tp_bin2_wdata                         (i_hqm_sip_rf_ll_rdylst_tp_bin2_wdata),
       .rf_ll_rdylst_tp_bin2_we                            (i_hqm_sip_rf_ll_rdylst_tp_bin2_we),
       .rf_ll_rdylst_tp_bin3_raddr                         (i_hqm_sip_rf_ll_rdylst_tp_bin3_raddr),
       .rf_ll_rdylst_tp_bin3_rclk                          (i_hqm_sip_rf_ll_rdylst_tp_bin3_rclk),
       .rf_ll_rdylst_tp_bin3_rclk_rst_n                    (i_hqm_sip_rf_ll_rdylst_tp_bin3_rclk_rst_n),
       .rf_ll_rdylst_tp_bin3_re                            (i_hqm_sip_rf_ll_rdylst_tp_bin3_re),
       .rf_ll_rdylst_tp_bin3_waddr                         (i_hqm_sip_rf_ll_rdylst_tp_bin3_waddr),
       .rf_ll_rdylst_tp_bin3_wclk                          (i_hqm_sip_rf_ll_rdylst_tp_bin3_wclk),
       .rf_ll_rdylst_tp_bin3_wclk_rst_n                    (i_hqm_sip_rf_ll_rdylst_tp_bin3_wclk_rst_n),
       .rf_ll_rdylst_tp_bin3_wdata                         (i_hqm_sip_rf_ll_rdylst_tp_bin3_wdata),
       .rf_ll_rdylst_tp_bin3_we                            (i_hqm_sip_rf_ll_rdylst_tp_bin3_we),
       .rf_ll_rlst_cnt_raddr                               (i_hqm_sip_rf_ll_rlst_cnt_raddr),
       .rf_ll_rlst_cnt_rclk                                (i_hqm_sip_rf_ll_rlst_cnt_rclk),
       .rf_ll_rlst_cnt_rclk_rst_n                          (i_hqm_sip_rf_ll_rlst_cnt_rclk_rst_n),
       .rf_ll_rlst_cnt_re                                  (i_hqm_sip_rf_ll_rlst_cnt_re),
       .rf_ll_rlst_cnt_waddr                               (i_hqm_sip_rf_ll_rlst_cnt_waddr),
       .rf_ll_rlst_cnt_wclk                                (i_hqm_sip_rf_ll_rlst_cnt_wclk),
       .rf_ll_rlst_cnt_wclk_rst_n                          (i_hqm_sip_rf_ll_rlst_cnt_wclk_rst_n),
       .rf_ll_rlst_cnt_wdata                               (i_hqm_sip_rf_ll_rlst_cnt_wdata),
       .rf_ll_rlst_cnt_we                                  (i_hqm_sip_rf_ll_rlst_cnt_we),
       .rf_ll_sch_cnt_dup0_raddr                           (i_hqm_sip_rf_ll_sch_cnt_dup0_raddr),
       .rf_ll_sch_cnt_dup0_rclk                            (i_hqm_sip_rf_ll_sch_cnt_dup0_rclk),
       .rf_ll_sch_cnt_dup0_rclk_rst_n                      (i_hqm_sip_rf_ll_sch_cnt_dup0_rclk_rst_n),
       .rf_ll_sch_cnt_dup0_re                              (i_hqm_sip_rf_ll_sch_cnt_dup0_re),
       .rf_ll_sch_cnt_dup0_waddr                           (i_hqm_sip_rf_ll_sch_cnt_dup0_waddr),
       .rf_ll_sch_cnt_dup0_wclk                            (i_hqm_sip_rf_ll_sch_cnt_dup0_wclk),
       .rf_ll_sch_cnt_dup0_wclk_rst_n                      (i_hqm_sip_rf_ll_sch_cnt_dup0_wclk_rst_n),
       .rf_ll_sch_cnt_dup0_wdata                           (i_hqm_sip_rf_ll_sch_cnt_dup0_wdata),
       .rf_ll_sch_cnt_dup0_we                              (i_hqm_sip_rf_ll_sch_cnt_dup0_we),
       .rf_ll_sch_cnt_dup1_raddr                           (i_hqm_sip_rf_ll_sch_cnt_dup1_raddr),
       .rf_ll_sch_cnt_dup1_rclk                            (i_hqm_sip_rf_ll_sch_cnt_dup1_rclk),
       .rf_ll_sch_cnt_dup1_rclk_rst_n                      (i_hqm_sip_rf_ll_sch_cnt_dup1_rclk_rst_n),
       .rf_ll_sch_cnt_dup1_re                              (i_hqm_sip_rf_ll_sch_cnt_dup1_re),
       .rf_ll_sch_cnt_dup1_waddr                           (i_hqm_sip_rf_ll_sch_cnt_dup1_waddr),
       .rf_ll_sch_cnt_dup1_wclk                            (i_hqm_sip_rf_ll_sch_cnt_dup1_wclk),
       .rf_ll_sch_cnt_dup1_wclk_rst_n                      (i_hqm_sip_rf_ll_sch_cnt_dup1_wclk_rst_n),
       .rf_ll_sch_cnt_dup1_wdata                           (i_hqm_sip_rf_ll_sch_cnt_dup1_wdata),
       .rf_ll_sch_cnt_dup1_we                              (i_hqm_sip_rf_ll_sch_cnt_dup1_we),
       .rf_ll_sch_cnt_dup2_raddr                           (i_hqm_sip_rf_ll_sch_cnt_dup2_raddr),
       .rf_ll_sch_cnt_dup2_rclk                            (i_hqm_sip_rf_ll_sch_cnt_dup2_rclk),
       .rf_ll_sch_cnt_dup2_rclk_rst_n                      (i_hqm_sip_rf_ll_sch_cnt_dup2_rclk_rst_n),
       .rf_ll_sch_cnt_dup2_re                              (i_hqm_sip_rf_ll_sch_cnt_dup2_re),
       .rf_ll_sch_cnt_dup2_waddr                           (i_hqm_sip_rf_ll_sch_cnt_dup2_waddr),
       .rf_ll_sch_cnt_dup2_wclk                            (i_hqm_sip_rf_ll_sch_cnt_dup2_wclk),
       .rf_ll_sch_cnt_dup2_wclk_rst_n                      (i_hqm_sip_rf_ll_sch_cnt_dup2_wclk_rst_n),
       .rf_ll_sch_cnt_dup2_wdata                           (i_hqm_sip_rf_ll_sch_cnt_dup2_wdata),
       .rf_ll_sch_cnt_dup2_we                              (i_hqm_sip_rf_ll_sch_cnt_dup2_we),
       .rf_ll_sch_cnt_dup3_raddr                           (i_hqm_sip_rf_ll_sch_cnt_dup3_raddr),
       .rf_ll_sch_cnt_dup3_rclk                            (i_hqm_sip_rf_ll_sch_cnt_dup3_rclk),
       .rf_ll_sch_cnt_dup3_rclk_rst_n                      (i_hqm_sip_rf_ll_sch_cnt_dup3_rclk_rst_n),
       .rf_ll_sch_cnt_dup3_re                              (i_hqm_sip_rf_ll_sch_cnt_dup3_re),
       .rf_ll_sch_cnt_dup3_waddr                           (i_hqm_sip_rf_ll_sch_cnt_dup3_waddr),
       .rf_ll_sch_cnt_dup3_wclk                            (i_hqm_sip_rf_ll_sch_cnt_dup3_wclk),
       .rf_ll_sch_cnt_dup3_wclk_rst_n                      (i_hqm_sip_rf_ll_sch_cnt_dup3_wclk_rst_n),
       .rf_ll_sch_cnt_dup3_wdata                           (i_hqm_sip_rf_ll_sch_cnt_dup3_wdata),
       .rf_ll_sch_cnt_dup3_we                              (i_hqm_sip_rf_ll_sch_cnt_dup3_we),
       .rf_ll_schlst_hp_bin0_raddr                         (i_hqm_sip_rf_ll_schlst_hp_bin0_raddr),
       .rf_ll_schlst_hp_bin0_rclk                          (i_hqm_sip_rf_ll_schlst_hp_bin0_rclk),
       .rf_ll_schlst_hp_bin0_rclk_rst_n                    (i_hqm_sip_rf_ll_schlst_hp_bin0_rclk_rst_n),
       .rf_ll_schlst_hp_bin0_re                            (i_hqm_sip_rf_ll_schlst_hp_bin0_re),
       .rf_ll_schlst_hp_bin0_waddr                         (i_hqm_sip_rf_ll_schlst_hp_bin0_waddr),
       .rf_ll_schlst_hp_bin0_wclk                          (i_hqm_sip_rf_ll_schlst_hp_bin0_wclk),
       .rf_ll_schlst_hp_bin0_wclk_rst_n                    (i_hqm_sip_rf_ll_schlst_hp_bin0_wclk_rst_n),
       .rf_ll_schlst_hp_bin0_wdata                         (i_hqm_sip_rf_ll_schlst_hp_bin0_wdata),
       .rf_ll_schlst_hp_bin0_we                            (i_hqm_sip_rf_ll_schlst_hp_bin0_we),
       .rf_ll_schlst_hp_bin1_raddr                         (i_hqm_sip_rf_ll_schlst_hp_bin1_raddr),
       .rf_ll_schlst_hp_bin1_rclk                          (i_hqm_sip_rf_ll_schlst_hp_bin1_rclk),
       .rf_ll_schlst_hp_bin1_rclk_rst_n                    (i_hqm_sip_rf_ll_schlst_hp_bin1_rclk_rst_n),
       .rf_ll_schlst_hp_bin1_re                            (i_hqm_sip_rf_ll_schlst_hp_bin1_re),
       .rf_ll_schlst_hp_bin1_waddr                         (i_hqm_sip_rf_ll_schlst_hp_bin1_waddr),
       .rf_ll_schlst_hp_bin1_wclk                          (i_hqm_sip_rf_ll_schlst_hp_bin1_wclk),
       .rf_ll_schlst_hp_bin1_wclk_rst_n                    (i_hqm_sip_rf_ll_schlst_hp_bin1_wclk_rst_n),
       .rf_ll_schlst_hp_bin1_wdata                         (i_hqm_sip_rf_ll_schlst_hp_bin1_wdata),
       .rf_ll_schlst_hp_bin1_we                            (i_hqm_sip_rf_ll_schlst_hp_bin1_we),
       .rf_ll_schlst_hp_bin2_raddr                         (i_hqm_sip_rf_ll_schlst_hp_bin2_raddr),
       .rf_ll_schlst_hp_bin2_rclk                          (i_hqm_sip_rf_ll_schlst_hp_bin2_rclk),
       .rf_ll_schlst_hp_bin2_rclk_rst_n                    (i_hqm_sip_rf_ll_schlst_hp_bin2_rclk_rst_n),
       .rf_ll_schlst_hp_bin2_re                            (i_hqm_sip_rf_ll_schlst_hp_bin2_re),
       .rf_ll_schlst_hp_bin2_waddr                         (i_hqm_sip_rf_ll_schlst_hp_bin2_waddr),
       .rf_ll_schlst_hp_bin2_wclk                          (i_hqm_sip_rf_ll_schlst_hp_bin2_wclk),
       .rf_ll_schlst_hp_bin2_wclk_rst_n                    (i_hqm_sip_rf_ll_schlst_hp_bin2_wclk_rst_n),
       .rf_ll_schlst_hp_bin2_wdata                         (i_hqm_sip_rf_ll_schlst_hp_bin2_wdata),
       .rf_ll_schlst_hp_bin2_we                            (i_hqm_sip_rf_ll_schlst_hp_bin2_we),
       .rf_ll_schlst_hp_bin3_raddr                         (i_hqm_sip_rf_ll_schlst_hp_bin3_raddr),
       .rf_ll_schlst_hp_bin3_rclk                          (i_hqm_sip_rf_ll_schlst_hp_bin3_rclk),
       .rf_ll_schlst_hp_bin3_rclk_rst_n                    (i_hqm_sip_rf_ll_schlst_hp_bin3_rclk_rst_n),
       .rf_ll_schlst_hp_bin3_re                            (i_hqm_sip_rf_ll_schlst_hp_bin3_re),
       .rf_ll_schlst_hp_bin3_waddr                         (i_hqm_sip_rf_ll_schlst_hp_bin3_waddr),
       .rf_ll_schlst_hp_bin3_wclk                          (i_hqm_sip_rf_ll_schlst_hp_bin3_wclk),
       .rf_ll_schlst_hp_bin3_wclk_rst_n                    (i_hqm_sip_rf_ll_schlst_hp_bin3_wclk_rst_n),
       .rf_ll_schlst_hp_bin3_wdata                         (i_hqm_sip_rf_ll_schlst_hp_bin3_wdata),
       .rf_ll_schlst_hp_bin3_we                            (i_hqm_sip_rf_ll_schlst_hp_bin3_we),
       .rf_ll_schlst_hpnxt_bin0_raddr                      (i_hqm_sip_rf_ll_schlst_hpnxt_bin0_raddr),
       .rf_ll_schlst_hpnxt_bin0_rclk                       (i_hqm_sip_rf_ll_schlst_hpnxt_bin0_rclk),
       .rf_ll_schlst_hpnxt_bin0_rclk_rst_n                 (i_hqm_sip_rf_ll_schlst_hpnxt_bin0_rclk_rst_n),
       .rf_ll_schlst_hpnxt_bin0_re                         (i_hqm_sip_rf_ll_schlst_hpnxt_bin0_re),
       .rf_ll_schlst_hpnxt_bin0_waddr                      (i_hqm_sip_rf_ll_schlst_hpnxt_bin0_waddr),
       .rf_ll_schlst_hpnxt_bin0_wclk                       (i_hqm_sip_rf_ll_schlst_hpnxt_bin0_wclk),
       .rf_ll_schlst_hpnxt_bin0_wclk_rst_n                 (i_hqm_sip_rf_ll_schlst_hpnxt_bin0_wclk_rst_n),
       .rf_ll_schlst_hpnxt_bin0_wdata                      (i_hqm_sip_rf_ll_schlst_hpnxt_bin0_wdata),
       .rf_ll_schlst_hpnxt_bin0_we                         (i_hqm_sip_rf_ll_schlst_hpnxt_bin0_we),
       .rf_ll_schlst_hpnxt_bin1_raddr                      (i_hqm_sip_rf_ll_schlst_hpnxt_bin1_raddr),
       .rf_ll_schlst_hpnxt_bin1_rclk                       (i_hqm_sip_rf_ll_schlst_hpnxt_bin1_rclk),
       .rf_ll_schlst_hpnxt_bin1_rclk_rst_n                 (i_hqm_sip_rf_ll_schlst_hpnxt_bin1_rclk_rst_n),
       .rf_ll_schlst_hpnxt_bin1_re                         (i_hqm_sip_rf_ll_schlst_hpnxt_bin1_re),
       .rf_ll_schlst_hpnxt_bin1_waddr                      (i_hqm_sip_rf_ll_schlst_hpnxt_bin1_waddr),
       .rf_ll_schlst_hpnxt_bin1_wclk                       (i_hqm_sip_rf_ll_schlst_hpnxt_bin1_wclk),
       .rf_ll_schlst_hpnxt_bin1_wclk_rst_n                 (i_hqm_sip_rf_ll_schlst_hpnxt_bin1_wclk_rst_n),
       .rf_ll_schlst_hpnxt_bin1_wdata                      (i_hqm_sip_rf_ll_schlst_hpnxt_bin1_wdata),
       .rf_ll_schlst_hpnxt_bin1_we                         (i_hqm_sip_rf_ll_schlst_hpnxt_bin1_we),
       .rf_ll_schlst_hpnxt_bin2_raddr                      (i_hqm_sip_rf_ll_schlst_hpnxt_bin2_raddr),
       .rf_ll_schlst_hpnxt_bin2_rclk                       (i_hqm_sip_rf_ll_schlst_hpnxt_bin2_rclk),
       .rf_ll_schlst_hpnxt_bin2_rclk_rst_n                 (i_hqm_sip_rf_ll_schlst_hpnxt_bin2_rclk_rst_n),
       .rf_ll_schlst_hpnxt_bin2_re                         (i_hqm_sip_rf_ll_schlst_hpnxt_bin2_re),
       .rf_ll_schlst_hpnxt_bin2_waddr                      (i_hqm_sip_rf_ll_schlst_hpnxt_bin2_waddr),
       .rf_ll_schlst_hpnxt_bin2_wclk                       (i_hqm_sip_rf_ll_schlst_hpnxt_bin2_wclk),
       .rf_ll_schlst_hpnxt_bin2_wclk_rst_n                 (i_hqm_sip_rf_ll_schlst_hpnxt_bin2_wclk_rst_n),
       .rf_ll_schlst_hpnxt_bin2_wdata                      (i_hqm_sip_rf_ll_schlst_hpnxt_bin2_wdata),
       .rf_ll_schlst_hpnxt_bin2_we                         (i_hqm_sip_rf_ll_schlst_hpnxt_bin2_we),
       .rf_ll_schlst_hpnxt_bin3_raddr                      (i_hqm_sip_rf_ll_schlst_hpnxt_bin3_raddr),
       .rf_ll_schlst_hpnxt_bin3_rclk                       (i_hqm_sip_rf_ll_schlst_hpnxt_bin3_rclk),
       .rf_ll_schlst_hpnxt_bin3_rclk_rst_n                 (i_hqm_sip_rf_ll_schlst_hpnxt_bin3_rclk_rst_n),
       .rf_ll_schlst_hpnxt_bin3_re                         (i_hqm_sip_rf_ll_schlst_hpnxt_bin3_re),
       .rf_ll_schlst_hpnxt_bin3_waddr                      (i_hqm_sip_rf_ll_schlst_hpnxt_bin3_waddr),
       .rf_ll_schlst_hpnxt_bin3_wclk                       (i_hqm_sip_rf_ll_schlst_hpnxt_bin3_wclk),
       .rf_ll_schlst_hpnxt_bin3_wclk_rst_n                 (i_hqm_sip_rf_ll_schlst_hpnxt_bin3_wclk_rst_n),
       .rf_ll_schlst_hpnxt_bin3_wdata                      (i_hqm_sip_rf_ll_schlst_hpnxt_bin3_wdata),
       .rf_ll_schlst_hpnxt_bin3_we                         (i_hqm_sip_rf_ll_schlst_hpnxt_bin3_we),
       .rf_ll_schlst_tp_bin0_raddr                         (i_hqm_sip_rf_ll_schlst_tp_bin0_raddr),
       .rf_ll_schlst_tp_bin0_rclk                          (i_hqm_sip_rf_ll_schlst_tp_bin0_rclk),
       .rf_ll_schlst_tp_bin0_rclk_rst_n                    (i_hqm_sip_rf_ll_schlst_tp_bin0_rclk_rst_n),
       .rf_ll_schlst_tp_bin0_re                            (i_hqm_sip_rf_ll_schlst_tp_bin0_re),
       .rf_ll_schlst_tp_bin0_waddr                         (i_hqm_sip_rf_ll_schlst_tp_bin0_waddr),
       .rf_ll_schlst_tp_bin0_wclk                          (i_hqm_sip_rf_ll_schlst_tp_bin0_wclk),
       .rf_ll_schlst_tp_bin0_wclk_rst_n                    (i_hqm_sip_rf_ll_schlst_tp_bin0_wclk_rst_n),
       .rf_ll_schlst_tp_bin0_wdata                         (i_hqm_sip_rf_ll_schlst_tp_bin0_wdata),
       .rf_ll_schlst_tp_bin0_we                            (i_hqm_sip_rf_ll_schlst_tp_bin0_we),
       .rf_ll_schlst_tp_bin1_raddr                         (i_hqm_sip_rf_ll_schlst_tp_bin1_raddr),
       .rf_ll_schlst_tp_bin1_rclk                          (i_hqm_sip_rf_ll_schlst_tp_bin1_rclk),
       .rf_ll_schlst_tp_bin1_rclk_rst_n                    (i_hqm_sip_rf_ll_schlst_tp_bin1_rclk_rst_n),
       .rf_ll_schlst_tp_bin1_re                            (i_hqm_sip_rf_ll_schlst_tp_bin1_re),
       .rf_ll_schlst_tp_bin1_waddr                         (i_hqm_sip_rf_ll_schlst_tp_bin1_waddr),
       .rf_ll_schlst_tp_bin1_wclk                          (i_hqm_sip_rf_ll_schlst_tp_bin1_wclk),
       .rf_ll_schlst_tp_bin1_wclk_rst_n                    (i_hqm_sip_rf_ll_schlst_tp_bin1_wclk_rst_n),
       .rf_ll_schlst_tp_bin1_wdata                         (i_hqm_sip_rf_ll_schlst_tp_bin1_wdata),
       .rf_ll_schlst_tp_bin1_we                            (i_hqm_sip_rf_ll_schlst_tp_bin1_we),
       .rf_ll_schlst_tp_bin2_raddr                         (i_hqm_sip_rf_ll_schlst_tp_bin2_raddr),
       .rf_ll_schlst_tp_bin2_rclk                          (i_hqm_sip_rf_ll_schlst_tp_bin2_rclk),
       .rf_ll_schlst_tp_bin2_rclk_rst_n                    (i_hqm_sip_rf_ll_schlst_tp_bin2_rclk_rst_n),
       .rf_ll_schlst_tp_bin2_re                            (i_hqm_sip_rf_ll_schlst_tp_bin2_re),
       .rf_ll_schlst_tp_bin2_waddr                         (i_hqm_sip_rf_ll_schlst_tp_bin2_waddr),
       .rf_ll_schlst_tp_bin2_wclk                          (i_hqm_sip_rf_ll_schlst_tp_bin2_wclk),
       .rf_ll_schlst_tp_bin2_wclk_rst_n                    (i_hqm_sip_rf_ll_schlst_tp_bin2_wclk_rst_n),
       .rf_ll_schlst_tp_bin2_wdata                         (i_hqm_sip_rf_ll_schlst_tp_bin2_wdata),
       .rf_ll_schlst_tp_bin2_we                            (i_hqm_sip_rf_ll_schlst_tp_bin2_we),
       .rf_ll_schlst_tp_bin3_raddr                         (i_hqm_sip_rf_ll_schlst_tp_bin3_raddr),
       .rf_ll_schlst_tp_bin3_rclk                          (i_hqm_sip_rf_ll_schlst_tp_bin3_rclk),
       .rf_ll_schlst_tp_bin3_rclk_rst_n                    (i_hqm_sip_rf_ll_schlst_tp_bin3_rclk_rst_n),
       .rf_ll_schlst_tp_bin3_re                            (i_hqm_sip_rf_ll_schlst_tp_bin3_re),
       .rf_ll_schlst_tp_bin3_waddr                         (i_hqm_sip_rf_ll_schlst_tp_bin3_waddr),
       .rf_ll_schlst_tp_bin3_wclk                          (i_hqm_sip_rf_ll_schlst_tp_bin3_wclk),
       .rf_ll_schlst_tp_bin3_wclk_rst_n                    (i_hqm_sip_rf_ll_schlst_tp_bin3_wclk_rst_n),
       .rf_ll_schlst_tp_bin3_wdata                         (i_hqm_sip_rf_ll_schlst_tp_bin3_wdata),
       .rf_ll_schlst_tp_bin3_we                            (i_hqm_sip_rf_ll_schlst_tp_bin3_we),
       .rf_ll_schlst_tpprv_bin0_raddr                      (i_hqm_sip_rf_ll_schlst_tpprv_bin0_raddr),
       .rf_ll_schlst_tpprv_bin0_rclk                       (i_hqm_sip_rf_ll_schlst_tpprv_bin0_rclk),
       .rf_ll_schlst_tpprv_bin0_rclk_rst_n                 (i_hqm_sip_rf_ll_schlst_tpprv_bin0_rclk_rst_n),
       .rf_ll_schlst_tpprv_bin0_re                         (i_hqm_sip_rf_ll_schlst_tpprv_bin0_re),
       .rf_ll_schlst_tpprv_bin0_waddr                      (i_hqm_sip_rf_ll_schlst_tpprv_bin0_waddr),
       .rf_ll_schlst_tpprv_bin0_wclk                       (i_hqm_sip_rf_ll_schlst_tpprv_bin0_wclk),
       .rf_ll_schlst_tpprv_bin0_wclk_rst_n                 (i_hqm_sip_rf_ll_schlst_tpprv_bin0_wclk_rst_n),
       .rf_ll_schlst_tpprv_bin0_wdata                      (i_hqm_sip_rf_ll_schlst_tpprv_bin0_wdata),
       .rf_ll_schlst_tpprv_bin0_we                         (i_hqm_sip_rf_ll_schlst_tpprv_bin0_we),
       .rf_ll_schlst_tpprv_bin1_raddr                      (i_hqm_sip_rf_ll_schlst_tpprv_bin1_raddr),
       .rf_ll_schlst_tpprv_bin1_rclk                       (i_hqm_sip_rf_ll_schlst_tpprv_bin1_rclk),
       .rf_ll_schlst_tpprv_bin1_rclk_rst_n                 (i_hqm_sip_rf_ll_schlst_tpprv_bin1_rclk_rst_n),
       .rf_ll_schlst_tpprv_bin1_re                         (i_hqm_sip_rf_ll_schlst_tpprv_bin1_re),
       .rf_ll_schlst_tpprv_bin1_waddr                      (i_hqm_sip_rf_ll_schlst_tpprv_bin1_waddr),
       .rf_ll_schlst_tpprv_bin1_wclk                       (i_hqm_sip_rf_ll_schlst_tpprv_bin1_wclk),
       .rf_ll_schlst_tpprv_bin1_wclk_rst_n                 (i_hqm_sip_rf_ll_schlst_tpprv_bin1_wclk_rst_n),
       .rf_ll_schlst_tpprv_bin1_wdata                      (i_hqm_sip_rf_ll_schlst_tpprv_bin1_wdata),
       .rf_ll_schlst_tpprv_bin1_we                         (i_hqm_sip_rf_ll_schlst_tpprv_bin1_we),
       .rf_ll_schlst_tpprv_bin2_raddr                      (i_hqm_sip_rf_ll_schlst_tpprv_bin2_raddr),
       .rf_ll_schlst_tpprv_bin2_rclk                       (i_hqm_sip_rf_ll_schlst_tpprv_bin2_rclk),
       .rf_ll_schlst_tpprv_bin2_rclk_rst_n                 (i_hqm_sip_rf_ll_schlst_tpprv_bin2_rclk_rst_n),
       .rf_ll_schlst_tpprv_bin2_re                         (i_hqm_sip_rf_ll_schlst_tpprv_bin2_re),
       .rf_ll_schlst_tpprv_bin2_waddr                      (i_hqm_sip_rf_ll_schlst_tpprv_bin2_waddr),
       .rf_ll_schlst_tpprv_bin2_wclk                       (i_hqm_sip_rf_ll_schlst_tpprv_bin2_wclk),
       .rf_ll_schlst_tpprv_bin2_wclk_rst_n                 (i_hqm_sip_rf_ll_schlst_tpprv_bin2_wclk_rst_n),
       .rf_ll_schlst_tpprv_bin2_wdata                      (i_hqm_sip_rf_ll_schlst_tpprv_bin2_wdata),
       .rf_ll_schlst_tpprv_bin2_we                         (i_hqm_sip_rf_ll_schlst_tpprv_bin2_we),
       .rf_ll_schlst_tpprv_bin3_raddr                      (i_hqm_sip_rf_ll_schlst_tpprv_bin3_raddr),
       .rf_ll_schlst_tpprv_bin3_rclk                       (i_hqm_sip_rf_ll_schlst_tpprv_bin3_rclk),
       .rf_ll_schlst_tpprv_bin3_rclk_rst_n                 (i_hqm_sip_rf_ll_schlst_tpprv_bin3_rclk_rst_n),
       .rf_ll_schlst_tpprv_bin3_re                         (i_hqm_sip_rf_ll_schlst_tpprv_bin3_re),
       .rf_ll_schlst_tpprv_bin3_waddr                      (i_hqm_sip_rf_ll_schlst_tpprv_bin3_waddr),
       .rf_ll_schlst_tpprv_bin3_wclk                       (i_hqm_sip_rf_ll_schlst_tpprv_bin3_wclk),
       .rf_ll_schlst_tpprv_bin3_wclk_rst_n                 (i_hqm_sip_rf_ll_schlst_tpprv_bin3_wclk_rst_n),
       .rf_ll_schlst_tpprv_bin3_wdata                      (i_hqm_sip_rf_ll_schlst_tpprv_bin3_wdata),
       .rf_ll_schlst_tpprv_bin3_we                         (i_hqm_sip_rf_ll_schlst_tpprv_bin3_we),
       .rf_ll_slst_cnt_raddr                               (i_hqm_sip_rf_ll_slst_cnt_raddr),
       .rf_ll_slst_cnt_rclk                                (i_hqm_sip_rf_ll_slst_cnt_rclk),
       .rf_ll_slst_cnt_rclk_rst_n                          (i_hqm_sip_rf_ll_slst_cnt_rclk_rst_n),
       .rf_ll_slst_cnt_re                                  (i_hqm_sip_rf_ll_slst_cnt_re),
       .rf_ll_slst_cnt_waddr                               (i_hqm_sip_rf_ll_slst_cnt_waddr),
       .rf_ll_slst_cnt_wclk                                (i_hqm_sip_rf_ll_slst_cnt_wclk),
       .rf_ll_slst_cnt_wclk_rst_n                          (i_hqm_sip_rf_ll_slst_cnt_wclk_rst_n),
       .rf_ll_slst_cnt_wdata                               (i_hqm_sip_rf_ll_slst_cnt_wdata),
       .rf_ll_slst_cnt_we                                  (i_hqm_sip_rf_ll_slst_cnt_we),
       .rf_lsp_dp_sch_dir_raddr                            (i_hqm_sip_rf_lsp_dp_sch_dir_raddr),
       .rf_lsp_dp_sch_dir_rclk                             (i_hqm_sip_rf_lsp_dp_sch_dir_rclk),
       .rf_lsp_dp_sch_dir_rclk_rst_n                       (i_hqm_sip_rf_lsp_dp_sch_dir_rclk_rst_n),
       .rf_lsp_dp_sch_dir_re                               (i_hqm_sip_rf_lsp_dp_sch_dir_re),
       .rf_lsp_dp_sch_dir_waddr                            (i_hqm_sip_rf_lsp_dp_sch_dir_waddr),
       .rf_lsp_dp_sch_dir_wclk                             (i_hqm_sip_rf_lsp_dp_sch_dir_wclk),
       .rf_lsp_dp_sch_dir_wclk_rst_n                       (i_hqm_sip_rf_lsp_dp_sch_dir_wclk_rst_n),
       .rf_lsp_dp_sch_dir_wdata                            (i_hqm_sip_rf_lsp_dp_sch_dir_wdata),
       .rf_lsp_dp_sch_dir_we                               (i_hqm_sip_rf_lsp_dp_sch_dir_we),
       .rf_lsp_dp_sch_rorply_raddr                         (i_hqm_sip_rf_lsp_dp_sch_rorply_raddr),
       .rf_lsp_dp_sch_rorply_rclk                          (i_hqm_sip_rf_lsp_dp_sch_rorply_rclk),
       .rf_lsp_dp_sch_rorply_rclk_rst_n                    (i_hqm_sip_rf_lsp_dp_sch_rorply_rclk_rst_n),
       .rf_lsp_dp_sch_rorply_re                            (i_hqm_sip_rf_lsp_dp_sch_rorply_re),
       .rf_lsp_dp_sch_rorply_waddr                         (i_hqm_sip_rf_lsp_dp_sch_rorply_waddr),
       .rf_lsp_dp_sch_rorply_wclk                          (i_hqm_sip_rf_lsp_dp_sch_rorply_wclk),
       .rf_lsp_dp_sch_rorply_wclk_rst_n                    (i_hqm_sip_rf_lsp_dp_sch_rorply_wclk_rst_n),
       .rf_lsp_dp_sch_rorply_wdata                         (i_hqm_sip_rf_lsp_dp_sch_rorply_wdata),
       .rf_lsp_dp_sch_rorply_we                            (i_hqm_sip_rf_lsp_dp_sch_rorply_we),
       .rf_lsp_nalb_sch_atq_raddr                          (i_hqm_sip_rf_lsp_nalb_sch_atq_raddr),
       .rf_lsp_nalb_sch_atq_rclk                           (i_hqm_sip_rf_lsp_nalb_sch_atq_rclk),
       .rf_lsp_nalb_sch_atq_rclk_rst_n                     (i_hqm_sip_rf_lsp_nalb_sch_atq_rclk_rst_n),
       .rf_lsp_nalb_sch_atq_re                             (i_hqm_sip_rf_lsp_nalb_sch_atq_re),
       .rf_lsp_nalb_sch_atq_waddr                          (i_hqm_sip_rf_lsp_nalb_sch_atq_waddr),
       .rf_lsp_nalb_sch_atq_wclk                           (i_hqm_sip_rf_lsp_nalb_sch_atq_wclk),
       .rf_lsp_nalb_sch_atq_wclk_rst_n                     (i_hqm_sip_rf_lsp_nalb_sch_atq_wclk_rst_n),
       .rf_lsp_nalb_sch_atq_wdata                          (i_hqm_sip_rf_lsp_nalb_sch_atq_wdata),
       .rf_lsp_nalb_sch_atq_we                             (i_hqm_sip_rf_lsp_nalb_sch_atq_we),
       .rf_lsp_nalb_sch_rorply_raddr                       (i_hqm_sip_rf_lsp_nalb_sch_rorply_raddr),
       .rf_lsp_nalb_sch_rorply_rclk                        (i_hqm_sip_rf_lsp_nalb_sch_rorply_rclk),
       .rf_lsp_nalb_sch_rorply_rclk_rst_n                  (i_hqm_sip_rf_lsp_nalb_sch_rorply_rclk_rst_n),
       .rf_lsp_nalb_sch_rorply_re                          (i_hqm_sip_rf_lsp_nalb_sch_rorply_re),
       .rf_lsp_nalb_sch_rorply_waddr                       (i_hqm_sip_rf_lsp_nalb_sch_rorply_waddr),
       .rf_lsp_nalb_sch_rorply_wclk                        (i_hqm_sip_rf_lsp_nalb_sch_rorply_wclk),
       .rf_lsp_nalb_sch_rorply_wclk_rst_n                  (i_hqm_sip_rf_lsp_nalb_sch_rorply_wclk_rst_n),
       .rf_lsp_nalb_sch_rorply_wdata                       (i_hqm_sip_rf_lsp_nalb_sch_rorply_wdata),
       .rf_lsp_nalb_sch_rorply_we                          (i_hqm_sip_rf_lsp_nalb_sch_rorply_we),
       .rf_lsp_nalb_sch_unoord_raddr                       (i_hqm_sip_rf_lsp_nalb_sch_unoord_raddr),
       .rf_lsp_nalb_sch_unoord_rclk                        (i_hqm_sip_rf_lsp_nalb_sch_unoord_rclk),
       .rf_lsp_nalb_sch_unoord_rclk_rst_n                  (i_hqm_sip_rf_lsp_nalb_sch_unoord_rclk_rst_n),
       .rf_lsp_nalb_sch_unoord_re                          (i_hqm_sip_rf_lsp_nalb_sch_unoord_re),
       .rf_lsp_nalb_sch_unoord_waddr                       (i_hqm_sip_rf_lsp_nalb_sch_unoord_waddr),
       .rf_lsp_nalb_sch_unoord_wclk                        (i_hqm_sip_rf_lsp_nalb_sch_unoord_wclk),
       .rf_lsp_nalb_sch_unoord_wclk_rst_n                  (i_hqm_sip_rf_lsp_nalb_sch_unoord_wclk_rst_n),
       .rf_lsp_nalb_sch_unoord_wdata                       (i_hqm_sip_rf_lsp_nalb_sch_unoord_wdata),
       .rf_lsp_nalb_sch_unoord_we                          (i_hqm_sip_rf_lsp_nalb_sch_unoord_we),
       .rf_lsp_reordercmp_fifo_mem_raddr                   (i_hqm_sip_rf_lsp_reordercmp_fifo_mem_raddr),
       .rf_lsp_reordercmp_fifo_mem_rclk                    (i_hqm_sip_rf_lsp_reordercmp_fifo_mem_rclk),
       .rf_lsp_reordercmp_fifo_mem_rclk_rst_n              (i_hqm_sip_rf_lsp_reordercmp_fifo_mem_rclk_rst_n),
       .rf_lsp_reordercmp_fifo_mem_re                      (i_hqm_sip_rf_lsp_reordercmp_fifo_mem_re),
       .rf_lsp_reordercmp_fifo_mem_waddr                   (i_hqm_sip_rf_lsp_reordercmp_fifo_mem_waddr),
       .rf_lsp_reordercmp_fifo_mem_wclk                    (i_hqm_sip_rf_lsp_reordercmp_fifo_mem_wclk),
       .rf_lsp_reordercmp_fifo_mem_wclk_rst_n              (i_hqm_sip_rf_lsp_reordercmp_fifo_mem_wclk_rst_n),
       .rf_lsp_reordercmp_fifo_mem_wdata                   (i_hqm_sip_rf_lsp_reordercmp_fifo_mem_wdata),
       .rf_lsp_reordercmp_fifo_mem_we                      (i_hqm_sip_rf_lsp_reordercmp_fifo_mem_we),
       .rf_lut_dir_cq2vf_pf_ro_raddr                       (i_hqm_sip_rf_lut_dir_cq2vf_pf_ro_raddr),
       .rf_lut_dir_cq2vf_pf_ro_rclk                        (i_hqm_sip_rf_lut_dir_cq2vf_pf_ro_rclk),
       .rf_lut_dir_cq2vf_pf_ro_rclk_rst_n                  (i_hqm_sip_rf_lut_dir_cq2vf_pf_ro_rclk_rst_n),
       .rf_lut_dir_cq2vf_pf_ro_re                          (i_hqm_sip_rf_lut_dir_cq2vf_pf_ro_re),
       .rf_lut_dir_cq2vf_pf_ro_waddr                       (i_hqm_sip_rf_lut_dir_cq2vf_pf_ro_waddr),
       .rf_lut_dir_cq2vf_pf_ro_wclk                        (i_hqm_sip_rf_lut_dir_cq2vf_pf_ro_wclk),
       .rf_lut_dir_cq2vf_pf_ro_wclk_rst_n                  (i_hqm_sip_rf_lut_dir_cq2vf_pf_ro_wclk_rst_n),
       .rf_lut_dir_cq2vf_pf_ro_wdata                       (i_hqm_sip_rf_lut_dir_cq2vf_pf_ro_wdata),
       .rf_lut_dir_cq2vf_pf_ro_we                          (i_hqm_sip_rf_lut_dir_cq2vf_pf_ro_we),
       .rf_lut_dir_cq_addr_l_raddr                         (i_hqm_sip_rf_lut_dir_cq_addr_l_raddr),
       .rf_lut_dir_cq_addr_l_rclk                          (i_hqm_sip_rf_lut_dir_cq_addr_l_rclk),
       .rf_lut_dir_cq_addr_l_rclk_rst_n                    (i_hqm_sip_rf_lut_dir_cq_addr_l_rclk_rst_n),
       .rf_lut_dir_cq_addr_l_re                            (i_hqm_sip_rf_lut_dir_cq_addr_l_re),
       .rf_lut_dir_cq_addr_l_waddr                         (i_hqm_sip_rf_lut_dir_cq_addr_l_waddr),
       .rf_lut_dir_cq_addr_l_wclk                          (i_hqm_sip_rf_lut_dir_cq_addr_l_wclk),
       .rf_lut_dir_cq_addr_l_wclk_rst_n                    (i_hqm_sip_rf_lut_dir_cq_addr_l_wclk_rst_n),
       .rf_lut_dir_cq_addr_l_wdata                         (i_hqm_sip_rf_lut_dir_cq_addr_l_wdata),
       .rf_lut_dir_cq_addr_l_we                            (i_hqm_sip_rf_lut_dir_cq_addr_l_we),
       .rf_lut_dir_cq_addr_u_raddr                         (i_hqm_sip_rf_lut_dir_cq_addr_u_raddr),
       .rf_lut_dir_cq_addr_u_rclk                          (i_hqm_sip_rf_lut_dir_cq_addr_u_rclk),
       .rf_lut_dir_cq_addr_u_rclk_rst_n                    (i_hqm_sip_rf_lut_dir_cq_addr_u_rclk_rst_n),
       .rf_lut_dir_cq_addr_u_re                            (i_hqm_sip_rf_lut_dir_cq_addr_u_re),
       .rf_lut_dir_cq_addr_u_waddr                         (i_hqm_sip_rf_lut_dir_cq_addr_u_waddr),
       .rf_lut_dir_cq_addr_u_wclk                          (i_hqm_sip_rf_lut_dir_cq_addr_u_wclk),
       .rf_lut_dir_cq_addr_u_wclk_rst_n                    (i_hqm_sip_rf_lut_dir_cq_addr_u_wclk_rst_n),
       .rf_lut_dir_cq_addr_u_wdata                         (i_hqm_sip_rf_lut_dir_cq_addr_u_wdata),
       .rf_lut_dir_cq_addr_u_we                            (i_hqm_sip_rf_lut_dir_cq_addr_u_we),
       .rf_lut_dir_cq_ai_addr_l_raddr                      (i_hqm_sip_rf_lut_dir_cq_ai_addr_l_raddr),
       .rf_lut_dir_cq_ai_addr_l_rclk                       (i_hqm_sip_rf_lut_dir_cq_ai_addr_l_rclk),
       .rf_lut_dir_cq_ai_addr_l_rclk_rst_n                 (i_hqm_sip_rf_lut_dir_cq_ai_addr_l_rclk_rst_n),
       .rf_lut_dir_cq_ai_addr_l_re                         (i_hqm_sip_rf_lut_dir_cq_ai_addr_l_re),
       .rf_lut_dir_cq_ai_addr_l_waddr                      (i_hqm_sip_rf_lut_dir_cq_ai_addr_l_waddr),
       .rf_lut_dir_cq_ai_addr_l_wclk                       (i_hqm_sip_rf_lut_dir_cq_ai_addr_l_wclk),
       .rf_lut_dir_cq_ai_addr_l_wclk_rst_n                 (i_hqm_sip_rf_lut_dir_cq_ai_addr_l_wclk_rst_n),
       .rf_lut_dir_cq_ai_addr_l_wdata                      (i_hqm_sip_rf_lut_dir_cq_ai_addr_l_wdata),
       .rf_lut_dir_cq_ai_addr_l_we                         (i_hqm_sip_rf_lut_dir_cq_ai_addr_l_we),
       .rf_lut_dir_cq_ai_addr_u_raddr                      (i_hqm_sip_rf_lut_dir_cq_ai_addr_u_raddr),
       .rf_lut_dir_cq_ai_addr_u_rclk                       (i_hqm_sip_rf_lut_dir_cq_ai_addr_u_rclk),
       .rf_lut_dir_cq_ai_addr_u_rclk_rst_n                 (i_hqm_sip_rf_lut_dir_cq_ai_addr_u_rclk_rst_n),
       .rf_lut_dir_cq_ai_addr_u_re                         (i_hqm_sip_rf_lut_dir_cq_ai_addr_u_re),
       .rf_lut_dir_cq_ai_addr_u_waddr                      (i_hqm_sip_rf_lut_dir_cq_ai_addr_u_waddr),
       .rf_lut_dir_cq_ai_addr_u_wclk                       (i_hqm_sip_rf_lut_dir_cq_ai_addr_u_wclk),
       .rf_lut_dir_cq_ai_addr_u_wclk_rst_n                 (i_hqm_sip_rf_lut_dir_cq_ai_addr_u_wclk_rst_n),
       .rf_lut_dir_cq_ai_addr_u_wdata                      (i_hqm_sip_rf_lut_dir_cq_ai_addr_u_wdata),
       .rf_lut_dir_cq_ai_addr_u_we                         (i_hqm_sip_rf_lut_dir_cq_ai_addr_u_we),
       .rf_lut_dir_cq_ai_data_raddr                        (i_hqm_sip_rf_lut_dir_cq_ai_data_raddr),
       .rf_lut_dir_cq_ai_data_rclk                         (i_hqm_sip_rf_lut_dir_cq_ai_data_rclk),
       .rf_lut_dir_cq_ai_data_rclk_rst_n                   (i_hqm_sip_rf_lut_dir_cq_ai_data_rclk_rst_n),
       .rf_lut_dir_cq_ai_data_re                           (i_hqm_sip_rf_lut_dir_cq_ai_data_re),
       .rf_lut_dir_cq_ai_data_waddr                        (i_hqm_sip_rf_lut_dir_cq_ai_data_waddr),
       .rf_lut_dir_cq_ai_data_wclk                         (i_hqm_sip_rf_lut_dir_cq_ai_data_wclk),
       .rf_lut_dir_cq_ai_data_wclk_rst_n                   (i_hqm_sip_rf_lut_dir_cq_ai_data_wclk_rst_n),
       .rf_lut_dir_cq_ai_data_wdata                        (i_hqm_sip_rf_lut_dir_cq_ai_data_wdata),
       .rf_lut_dir_cq_ai_data_we                           (i_hqm_sip_rf_lut_dir_cq_ai_data_we),
       .rf_lut_dir_cq_isr_raddr                            (i_hqm_sip_rf_lut_dir_cq_isr_raddr),
       .rf_lut_dir_cq_isr_rclk                             (i_hqm_sip_rf_lut_dir_cq_isr_rclk),
       .rf_lut_dir_cq_isr_rclk_rst_n                       (i_hqm_sip_rf_lut_dir_cq_isr_rclk_rst_n),
       .rf_lut_dir_cq_isr_re                               (i_hqm_sip_rf_lut_dir_cq_isr_re),
       .rf_lut_dir_cq_isr_waddr                            (i_hqm_sip_rf_lut_dir_cq_isr_waddr),
       .rf_lut_dir_cq_isr_wclk                             (i_hqm_sip_rf_lut_dir_cq_isr_wclk),
       .rf_lut_dir_cq_isr_wclk_rst_n                       (i_hqm_sip_rf_lut_dir_cq_isr_wclk_rst_n),
       .rf_lut_dir_cq_isr_wdata                            (i_hqm_sip_rf_lut_dir_cq_isr_wdata),
       .rf_lut_dir_cq_isr_we                               (i_hqm_sip_rf_lut_dir_cq_isr_we),
       .rf_lut_dir_cq_pasid_raddr                          (i_hqm_sip_rf_lut_dir_cq_pasid_raddr),
       .rf_lut_dir_cq_pasid_rclk                           (i_hqm_sip_rf_lut_dir_cq_pasid_rclk),
       .rf_lut_dir_cq_pasid_rclk_rst_n                     (i_hqm_sip_rf_lut_dir_cq_pasid_rclk_rst_n),
       .rf_lut_dir_cq_pasid_re                             (i_hqm_sip_rf_lut_dir_cq_pasid_re),
       .rf_lut_dir_cq_pasid_waddr                          (i_hqm_sip_rf_lut_dir_cq_pasid_waddr),
       .rf_lut_dir_cq_pasid_wclk                           (i_hqm_sip_rf_lut_dir_cq_pasid_wclk),
       .rf_lut_dir_cq_pasid_wclk_rst_n                     (i_hqm_sip_rf_lut_dir_cq_pasid_wclk_rst_n),
       .rf_lut_dir_cq_pasid_wdata                          (i_hqm_sip_rf_lut_dir_cq_pasid_wdata),
       .rf_lut_dir_cq_pasid_we                             (i_hqm_sip_rf_lut_dir_cq_pasid_we),
       .rf_lut_dir_pp2vas_raddr                            (i_hqm_sip_rf_lut_dir_pp2vas_raddr),
       .rf_lut_dir_pp2vas_rclk                             (i_hqm_sip_rf_lut_dir_pp2vas_rclk),
       .rf_lut_dir_pp2vas_rclk_rst_n                       (i_hqm_sip_rf_lut_dir_pp2vas_rclk_rst_n),
       .rf_lut_dir_pp2vas_re                               (i_hqm_sip_rf_lut_dir_pp2vas_re),
       .rf_lut_dir_pp2vas_waddr                            (i_hqm_sip_rf_lut_dir_pp2vas_waddr),
       .rf_lut_dir_pp2vas_wclk                             (i_hqm_sip_rf_lut_dir_pp2vas_wclk),
       .rf_lut_dir_pp2vas_wclk_rst_n                       (i_hqm_sip_rf_lut_dir_pp2vas_wclk_rst_n),
       .rf_lut_dir_pp2vas_wdata                            (i_hqm_sip_rf_lut_dir_pp2vas_wdata),
       .rf_lut_dir_pp2vas_we                               (i_hqm_sip_rf_lut_dir_pp2vas_we),
       .rf_lut_dir_pp_v_raddr                              (i_hqm_sip_rf_lut_dir_pp_v_raddr),
       .rf_lut_dir_pp_v_rclk                               (i_hqm_sip_rf_lut_dir_pp_v_rclk),
       .rf_lut_dir_pp_v_rclk_rst_n                         (i_hqm_sip_rf_lut_dir_pp_v_rclk_rst_n),
       .rf_lut_dir_pp_v_re                                 (i_hqm_sip_rf_lut_dir_pp_v_re),
       .rf_lut_dir_pp_v_waddr                              (i_hqm_sip_rf_lut_dir_pp_v_waddr),
       .rf_lut_dir_pp_v_wclk                               (i_hqm_sip_rf_lut_dir_pp_v_wclk),
       .rf_lut_dir_pp_v_wclk_rst_n                         (i_hqm_sip_rf_lut_dir_pp_v_wclk_rst_n),
       .rf_lut_dir_pp_v_wdata                              (i_hqm_sip_rf_lut_dir_pp_v_wdata),
       .rf_lut_dir_pp_v_we                                 (i_hqm_sip_rf_lut_dir_pp_v_we),
       .rf_lut_dir_vasqid_v_raddr                          (i_hqm_sip_rf_lut_dir_vasqid_v_raddr),
       .rf_lut_dir_vasqid_v_rclk                           (i_hqm_sip_rf_lut_dir_vasqid_v_rclk),
       .rf_lut_dir_vasqid_v_rclk_rst_n                     (i_hqm_sip_rf_lut_dir_vasqid_v_rclk_rst_n),
       .rf_lut_dir_vasqid_v_re                             (i_hqm_sip_rf_lut_dir_vasqid_v_re),
       .rf_lut_dir_vasqid_v_waddr                          (i_hqm_sip_rf_lut_dir_vasqid_v_waddr),
       .rf_lut_dir_vasqid_v_wclk                           (i_hqm_sip_rf_lut_dir_vasqid_v_wclk),
       .rf_lut_dir_vasqid_v_wclk_rst_n                     (i_hqm_sip_rf_lut_dir_vasqid_v_wclk_rst_n),
       .rf_lut_dir_vasqid_v_wdata                          (i_hqm_sip_rf_lut_dir_vasqid_v_wdata),
       .rf_lut_dir_vasqid_v_we                             (i_hqm_sip_rf_lut_dir_vasqid_v_we),
       .rf_lut_ldb_cq2vf_pf_ro_raddr                       (i_hqm_sip_rf_lut_ldb_cq2vf_pf_ro_raddr),
       .rf_lut_ldb_cq2vf_pf_ro_rclk                        (i_hqm_sip_rf_lut_ldb_cq2vf_pf_ro_rclk),
       .rf_lut_ldb_cq2vf_pf_ro_rclk_rst_n                  (i_hqm_sip_rf_lut_ldb_cq2vf_pf_ro_rclk_rst_n),
       .rf_lut_ldb_cq2vf_pf_ro_re                          (i_hqm_sip_rf_lut_ldb_cq2vf_pf_ro_re),
       .rf_lut_ldb_cq2vf_pf_ro_waddr                       (i_hqm_sip_rf_lut_ldb_cq2vf_pf_ro_waddr),
       .rf_lut_ldb_cq2vf_pf_ro_wclk                        (i_hqm_sip_rf_lut_ldb_cq2vf_pf_ro_wclk),
       .rf_lut_ldb_cq2vf_pf_ro_wclk_rst_n                  (i_hqm_sip_rf_lut_ldb_cq2vf_pf_ro_wclk_rst_n),
       .rf_lut_ldb_cq2vf_pf_ro_wdata                       (i_hqm_sip_rf_lut_ldb_cq2vf_pf_ro_wdata),
       .rf_lut_ldb_cq2vf_pf_ro_we                          (i_hqm_sip_rf_lut_ldb_cq2vf_pf_ro_we),
       .rf_lut_ldb_cq_addr_l_raddr                         (i_hqm_sip_rf_lut_ldb_cq_addr_l_raddr),
       .rf_lut_ldb_cq_addr_l_rclk                          (i_hqm_sip_rf_lut_ldb_cq_addr_l_rclk),
       .rf_lut_ldb_cq_addr_l_rclk_rst_n                    (i_hqm_sip_rf_lut_ldb_cq_addr_l_rclk_rst_n),
       .rf_lut_ldb_cq_addr_l_re                            (i_hqm_sip_rf_lut_ldb_cq_addr_l_re),
       .rf_lut_ldb_cq_addr_l_waddr                         (i_hqm_sip_rf_lut_ldb_cq_addr_l_waddr),
       .rf_lut_ldb_cq_addr_l_wclk                          (i_hqm_sip_rf_lut_ldb_cq_addr_l_wclk),
       .rf_lut_ldb_cq_addr_l_wclk_rst_n                    (i_hqm_sip_rf_lut_ldb_cq_addr_l_wclk_rst_n),
       .rf_lut_ldb_cq_addr_l_wdata                         (i_hqm_sip_rf_lut_ldb_cq_addr_l_wdata),
       .rf_lut_ldb_cq_addr_l_we                            (i_hqm_sip_rf_lut_ldb_cq_addr_l_we),
       .rf_lut_ldb_cq_addr_u_raddr                         (i_hqm_sip_rf_lut_ldb_cq_addr_u_raddr),
       .rf_lut_ldb_cq_addr_u_rclk                          (i_hqm_sip_rf_lut_ldb_cq_addr_u_rclk),
       .rf_lut_ldb_cq_addr_u_rclk_rst_n                    (i_hqm_sip_rf_lut_ldb_cq_addr_u_rclk_rst_n),
       .rf_lut_ldb_cq_addr_u_re                            (i_hqm_sip_rf_lut_ldb_cq_addr_u_re),
       .rf_lut_ldb_cq_addr_u_waddr                         (i_hqm_sip_rf_lut_ldb_cq_addr_u_waddr),
       .rf_lut_ldb_cq_addr_u_wclk                          (i_hqm_sip_rf_lut_ldb_cq_addr_u_wclk),
       .rf_lut_ldb_cq_addr_u_wclk_rst_n                    (i_hqm_sip_rf_lut_ldb_cq_addr_u_wclk_rst_n),
       .rf_lut_ldb_cq_addr_u_wdata                         (i_hqm_sip_rf_lut_ldb_cq_addr_u_wdata),
       .rf_lut_ldb_cq_addr_u_we                            (i_hqm_sip_rf_lut_ldb_cq_addr_u_we),
       .rf_lut_ldb_cq_ai_addr_l_raddr                      (i_hqm_sip_rf_lut_ldb_cq_ai_addr_l_raddr),
       .rf_lut_ldb_cq_ai_addr_l_rclk                       (i_hqm_sip_rf_lut_ldb_cq_ai_addr_l_rclk),
       .rf_lut_ldb_cq_ai_addr_l_rclk_rst_n                 (i_hqm_sip_rf_lut_ldb_cq_ai_addr_l_rclk_rst_n),
       .rf_lut_ldb_cq_ai_addr_l_re                         (i_hqm_sip_rf_lut_ldb_cq_ai_addr_l_re),
       .rf_lut_ldb_cq_ai_addr_l_waddr                      (i_hqm_sip_rf_lut_ldb_cq_ai_addr_l_waddr),
       .rf_lut_ldb_cq_ai_addr_l_wclk                       (i_hqm_sip_rf_lut_ldb_cq_ai_addr_l_wclk),
       .rf_lut_ldb_cq_ai_addr_l_wclk_rst_n                 (i_hqm_sip_rf_lut_ldb_cq_ai_addr_l_wclk_rst_n),
       .rf_lut_ldb_cq_ai_addr_l_wdata                      (i_hqm_sip_rf_lut_ldb_cq_ai_addr_l_wdata),
       .rf_lut_ldb_cq_ai_addr_l_we                         (i_hqm_sip_rf_lut_ldb_cq_ai_addr_l_we),
       .rf_lut_ldb_cq_ai_addr_u_raddr                      (i_hqm_sip_rf_lut_ldb_cq_ai_addr_u_raddr),
       .rf_lut_ldb_cq_ai_addr_u_rclk                       (i_hqm_sip_rf_lut_ldb_cq_ai_addr_u_rclk),
       .rf_lut_ldb_cq_ai_addr_u_rclk_rst_n                 (i_hqm_sip_rf_lut_ldb_cq_ai_addr_u_rclk_rst_n),
       .rf_lut_ldb_cq_ai_addr_u_re                         (i_hqm_sip_rf_lut_ldb_cq_ai_addr_u_re),
       .rf_lut_ldb_cq_ai_addr_u_waddr                      (i_hqm_sip_rf_lut_ldb_cq_ai_addr_u_waddr),
       .rf_lut_ldb_cq_ai_addr_u_wclk                       (i_hqm_sip_rf_lut_ldb_cq_ai_addr_u_wclk),
       .rf_lut_ldb_cq_ai_addr_u_wclk_rst_n                 (i_hqm_sip_rf_lut_ldb_cq_ai_addr_u_wclk_rst_n),
       .rf_lut_ldb_cq_ai_addr_u_wdata                      (i_hqm_sip_rf_lut_ldb_cq_ai_addr_u_wdata),
       .rf_lut_ldb_cq_ai_addr_u_we                         (i_hqm_sip_rf_lut_ldb_cq_ai_addr_u_we),
       .rf_lut_ldb_cq_ai_data_raddr                        (i_hqm_sip_rf_lut_ldb_cq_ai_data_raddr),
       .rf_lut_ldb_cq_ai_data_rclk                         (i_hqm_sip_rf_lut_ldb_cq_ai_data_rclk),
       .rf_lut_ldb_cq_ai_data_rclk_rst_n                   (i_hqm_sip_rf_lut_ldb_cq_ai_data_rclk_rst_n),
       .rf_lut_ldb_cq_ai_data_re                           (i_hqm_sip_rf_lut_ldb_cq_ai_data_re),
       .rf_lut_ldb_cq_ai_data_waddr                        (i_hqm_sip_rf_lut_ldb_cq_ai_data_waddr),
       .rf_lut_ldb_cq_ai_data_wclk                         (i_hqm_sip_rf_lut_ldb_cq_ai_data_wclk),
       .rf_lut_ldb_cq_ai_data_wclk_rst_n                   (i_hqm_sip_rf_lut_ldb_cq_ai_data_wclk_rst_n),
       .rf_lut_ldb_cq_ai_data_wdata                        (i_hqm_sip_rf_lut_ldb_cq_ai_data_wdata),
       .rf_lut_ldb_cq_ai_data_we                           (i_hqm_sip_rf_lut_ldb_cq_ai_data_we),
       .rf_lut_ldb_cq_isr_raddr                            (i_hqm_sip_rf_lut_ldb_cq_isr_raddr),
       .rf_lut_ldb_cq_isr_rclk                             (i_hqm_sip_rf_lut_ldb_cq_isr_rclk),
       .rf_lut_ldb_cq_isr_rclk_rst_n                       (i_hqm_sip_rf_lut_ldb_cq_isr_rclk_rst_n),
       .rf_lut_ldb_cq_isr_re                               (i_hqm_sip_rf_lut_ldb_cq_isr_re),
       .rf_lut_ldb_cq_isr_waddr                            (i_hqm_sip_rf_lut_ldb_cq_isr_waddr),
       .rf_lut_ldb_cq_isr_wclk                             (i_hqm_sip_rf_lut_ldb_cq_isr_wclk),
       .rf_lut_ldb_cq_isr_wclk_rst_n                       (i_hqm_sip_rf_lut_ldb_cq_isr_wclk_rst_n),
       .rf_lut_ldb_cq_isr_wdata                            (i_hqm_sip_rf_lut_ldb_cq_isr_wdata),
       .rf_lut_ldb_cq_isr_we                               (i_hqm_sip_rf_lut_ldb_cq_isr_we),
       .rf_lut_ldb_cq_pasid_raddr                          (i_hqm_sip_rf_lut_ldb_cq_pasid_raddr),
       .rf_lut_ldb_cq_pasid_rclk                           (i_hqm_sip_rf_lut_ldb_cq_pasid_rclk),
       .rf_lut_ldb_cq_pasid_rclk_rst_n                     (i_hqm_sip_rf_lut_ldb_cq_pasid_rclk_rst_n),
       .rf_lut_ldb_cq_pasid_re                             (i_hqm_sip_rf_lut_ldb_cq_pasid_re),
       .rf_lut_ldb_cq_pasid_waddr                          (i_hqm_sip_rf_lut_ldb_cq_pasid_waddr),
       .rf_lut_ldb_cq_pasid_wclk                           (i_hqm_sip_rf_lut_ldb_cq_pasid_wclk),
       .rf_lut_ldb_cq_pasid_wclk_rst_n                     (i_hqm_sip_rf_lut_ldb_cq_pasid_wclk_rst_n),
       .rf_lut_ldb_cq_pasid_wdata                          (i_hqm_sip_rf_lut_ldb_cq_pasid_wdata),
       .rf_lut_ldb_cq_pasid_we                             (i_hqm_sip_rf_lut_ldb_cq_pasid_we),
       .rf_lut_ldb_pp2vas_raddr                            (i_hqm_sip_rf_lut_ldb_pp2vas_raddr),
       .rf_lut_ldb_pp2vas_rclk                             (i_hqm_sip_rf_lut_ldb_pp2vas_rclk),
       .rf_lut_ldb_pp2vas_rclk_rst_n                       (i_hqm_sip_rf_lut_ldb_pp2vas_rclk_rst_n),
       .rf_lut_ldb_pp2vas_re                               (i_hqm_sip_rf_lut_ldb_pp2vas_re),
       .rf_lut_ldb_pp2vas_waddr                            (i_hqm_sip_rf_lut_ldb_pp2vas_waddr),
       .rf_lut_ldb_pp2vas_wclk                             (i_hqm_sip_rf_lut_ldb_pp2vas_wclk),
       .rf_lut_ldb_pp2vas_wclk_rst_n                       (i_hqm_sip_rf_lut_ldb_pp2vas_wclk_rst_n),
       .rf_lut_ldb_pp2vas_wdata                            (i_hqm_sip_rf_lut_ldb_pp2vas_wdata),
       .rf_lut_ldb_pp2vas_we                               (i_hqm_sip_rf_lut_ldb_pp2vas_we),
       .rf_lut_ldb_qid2vqid_raddr                          (i_hqm_sip_rf_lut_ldb_qid2vqid_raddr),
       .rf_lut_ldb_qid2vqid_rclk                           (i_hqm_sip_rf_lut_ldb_qid2vqid_rclk),
       .rf_lut_ldb_qid2vqid_rclk_rst_n                     (i_hqm_sip_rf_lut_ldb_qid2vqid_rclk_rst_n),
       .rf_lut_ldb_qid2vqid_re                             (i_hqm_sip_rf_lut_ldb_qid2vqid_re),
       .rf_lut_ldb_qid2vqid_waddr                          (i_hqm_sip_rf_lut_ldb_qid2vqid_waddr),
       .rf_lut_ldb_qid2vqid_wclk                           (i_hqm_sip_rf_lut_ldb_qid2vqid_wclk),
       .rf_lut_ldb_qid2vqid_wclk_rst_n                     (i_hqm_sip_rf_lut_ldb_qid2vqid_wclk_rst_n),
       .rf_lut_ldb_qid2vqid_wdata                          (i_hqm_sip_rf_lut_ldb_qid2vqid_wdata),
       .rf_lut_ldb_qid2vqid_we                             (i_hqm_sip_rf_lut_ldb_qid2vqid_we),
       .rf_lut_ldb_vasqid_v_raddr                          (i_hqm_sip_rf_lut_ldb_vasqid_v_raddr),
       .rf_lut_ldb_vasqid_v_rclk                           (i_hqm_sip_rf_lut_ldb_vasqid_v_rclk),
       .rf_lut_ldb_vasqid_v_rclk_rst_n                     (i_hqm_sip_rf_lut_ldb_vasqid_v_rclk_rst_n),
       .rf_lut_ldb_vasqid_v_re                             (i_hqm_sip_rf_lut_ldb_vasqid_v_re),
       .rf_lut_ldb_vasqid_v_waddr                          (i_hqm_sip_rf_lut_ldb_vasqid_v_waddr),
       .rf_lut_ldb_vasqid_v_wclk                           (i_hqm_sip_rf_lut_ldb_vasqid_v_wclk),
       .rf_lut_ldb_vasqid_v_wclk_rst_n                     (i_hqm_sip_rf_lut_ldb_vasqid_v_wclk_rst_n),
       .rf_lut_ldb_vasqid_v_wdata                          (i_hqm_sip_rf_lut_ldb_vasqid_v_wdata),
       .rf_lut_ldb_vasqid_v_we                             (i_hqm_sip_rf_lut_ldb_vasqid_v_we),
       .rf_lut_vf_dir_vpp2pp_raddr                         (i_hqm_sip_rf_lut_vf_dir_vpp2pp_raddr),
       .rf_lut_vf_dir_vpp2pp_rclk                          (i_hqm_sip_rf_lut_vf_dir_vpp2pp_rclk),
       .rf_lut_vf_dir_vpp2pp_rclk_rst_n                    (i_hqm_sip_rf_lut_vf_dir_vpp2pp_rclk_rst_n),
       .rf_lut_vf_dir_vpp2pp_re                            (i_hqm_sip_rf_lut_vf_dir_vpp2pp_re),
       .rf_lut_vf_dir_vpp2pp_waddr                         (i_hqm_sip_rf_lut_vf_dir_vpp2pp_waddr),
       .rf_lut_vf_dir_vpp2pp_wclk                          (i_hqm_sip_rf_lut_vf_dir_vpp2pp_wclk),
       .rf_lut_vf_dir_vpp2pp_wclk_rst_n                    (i_hqm_sip_rf_lut_vf_dir_vpp2pp_wclk_rst_n),
       .rf_lut_vf_dir_vpp2pp_wdata                         (i_hqm_sip_rf_lut_vf_dir_vpp2pp_wdata),
       .rf_lut_vf_dir_vpp2pp_we                            (i_hqm_sip_rf_lut_vf_dir_vpp2pp_we),
       .rf_lut_vf_dir_vpp_v_raddr                          (i_hqm_sip_rf_lut_vf_dir_vpp_v_raddr),
       .rf_lut_vf_dir_vpp_v_rclk                           (i_hqm_sip_rf_lut_vf_dir_vpp_v_rclk),
       .rf_lut_vf_dir_vpp_v_rclk_rst_n                     (i_hqm_sip_rf_lut_vf_dir_vpp_v_rclk_rst_n),
       .rf_lut_vf_dir_vpp_v_re                             (i_hqm_sip_rf_lut_vf_dir_vpp_v_re),
       .rf_lut_vf_dir_vpp_v_waddr                          (i_hqm_sip_rf_lut_vf_dir_vpp_v_waddr),
       .rf_lut_vf_dir_vpp_v_wclk                           (i_hqm_sip_rf_lut_vf_dir_vpp_v_wclk),
       .rf_lut_vf_dir_vpp_v_wclk_rst_n                     (i_hqm_sip_rf_lut_vf_dir_vpp_v_wclk_rst_n),
       .rf_lut_vf_dir_vpp_v_wdata                          (i_hqm_sip_rf_lut_vf_dir_vpp_v_wdata),
       .rf_lut_vf_dir_vpp_v_we                             (i_hqm_sip_rf_lut_vf_dir_vpp_v_we),
       .rf_lut_vf_dir_vqid2qid_raddr                       (i_hqm_sip_rf_lut_vf_dir_vqid2qid_raddr),
       .rf_lut_vf_dir_vqid2qid_rclk                        (i_hqm_sip_rf_lut_vf_dir_vqid2qid_rclk),
       .rf_lut_vf_dir_vqid2qid_rclk_rst_n                  (i_hqm_sip_rf_lut_vf_dir_vqid2qid_rclk_rst_n),
       .rf_lut_vf_dir_vqid2qid_re                          (i_hqm_sip_rf_lut_vf_dir_vqid2qid_re),
       .rf_lut_vf_dir_vqid2qid_waddr                       (i_hqm_sip_rf_lut_vf_dir_vqid2qid_waddr),
       .rf_lut_vf_dir_vqid2qid_wclk                        (i_hqm_sip_rf_lut_vf_dir_vqid2qid_wclk),
       .rf_lut_vf_dir_vqid2qid_wclk_rst_n                  (i_hqm_sip_rf_lut_vf_dir_vqid2qid_wclk_rst_n),
       .rf_lut_vf_dir_vqid2qid_wdata                       (i_hqm_sip_rf_lut_vf_dir_vqid2qid_wdata),
       .rf_lut_vf_dir_vqid2qid_we                          (i_hqm_sip_rf_lut_vf_dir_vqid2qid_we),
       .rf_lut_vf_dir_vqid_v_raddr                         (i_hqm_sip_rf_lut_vf_dir_vqid_v_raddr),
       .rf_lut_vf_dir_vqid_v_rclk                          (i_hqm_sip_rf_lut_vf_dir_vqid_v_rclk),
       .rf_lut_vf_dir_vqid_v_rclk_rst_n                    (i_hqm_sip_rf_lut_vf_dir_vqid_v_rclk_rst_n),
       .rf_lut_vf_dir_vqid_v_re                            (i_hqm_sip_rf_lut_vf_dir_vqid_v_re),
       .rf_lut_vf_dir_vqid_v_waddr                         (i_hqm_sip_rf_lut_vf_dir_vqid_v_waddr),
       .rf_lut_vf_dir_vqid_v_wclk                          (i_hqm_sip_rf_lut_vf_dir_vqid_v_wclk),
       .rf_lut_vf_dir_vqid_v_wclk_rst_n                    (i_hqm_sip_rf_lut_vf_dir_vqid_v_wclk_rst_n),
       .rf_lut_vf_dir_vqid_v_wdata                         (i_hqm_sip_rf_lut_vf_dir_vqid_v_wdata),
       .rf_lut_vf_dir_vqid_v_we                            (i_hqm_sip_rf_lut_vf_dir_vqid_v_we),
       .rf_lut_vf_ldb_vpp2pp_raddr                         (i_hqm_sip_rf_lut_vf_ldb_vpp2pp_raddr),
       .rf_lut_vf_ldb_vpp2pp_rclk                          (i_hqm_sip_rf_lut_vf_ldb_vpp2pp_rclk),
       .rf_lut_vf_ldb_vpp2pp_rclk_rst_n                    (i_hqm_sip_rf_lut_vf_ldb_vpp2pp_rclk_rst_n),
       .rf_lut_vf_ldb_vpp2pp_re                            (i_hqm_sip_rf_lut_vf_ldb_vpp2pp_re),
       .rf_lut_vf_ldb_vpp2pp_waddr                         (i_hqm_sip_rf_lut_vf_ldb_vpp2pp_waddr),
       .rf_lut_vf_ldb_vpp2pp_wclk                          (i_hqm_sip_rf_lut_vf_ldb_vpp2pp_wclk),
       .rf_lut_vf_ldb_vpp2pp_wclk_rst_n                    (i_hqm_sip_rf_lut_vf_ldb_vpp2pp_wclk_rst_n),
       .rf_lut_vf_ldb_vpp2pp_wdata                         (i_hqm_sip_rf_lut_vf_ldb_vpp2pp_wdata),
       .rf_lut_vf_ldb_vpp2pp_we                            (i_hqm_sip_rf_lut_vf_ldb_vpp2pp_we),
       .rf_lut_vf_ldb_vpp_v_raddr                          (i_hqm_sip_rf_lut_vf_ldb_vpp_v_raddr),
       .rf_lut_vf_ldb_vpp_v_rclk                           (i_hqm_sip_rf_lut_vf_ldb_vpp_v_rclk),
       .rf_lut_vf_ldb_vpp_v_rclk_rst_n                     (i_hqm_sip_rf_lut_vf_ldb_vpp_v_rclk_rst_n),
       .rf_lut_vf_ldb_vpp_v_re                             (i_hqm_sip_rf_lut_vf_ldb_vpp_v_re),
       .rf_lut_vf_ldb_vpp_v_waddr                          (i_hqm_sip_rf_lut_vf_ldb_vpp_v_waddr),
       .rf_lut_vf_ldb_vpp_v_wclk                           (i_hqm_sip_rf_lut_vf_ldb_vpp_v_wclk),
       .rf_lut_vf_ldb_vpp_v_wclk_rst_n                     (i_hqm_sip_rf_lut_vf_ldb_vpp_v_wclk_rst_n),
       .rf_lut_vf_ldb_vpp_v_wdata                          (i_hqm_sip_rf_lut_vf_ldb_vpp_v_wdata),
       .rf_lut_vf_ldb_vpp_v_we                             (i_hqm_sip_rf_lut_vf_ldb_vpp_v_we),
       .rf_lut_vf_ldb_vqid2qid_raddr                       (i_hqm_sip_rf_lut_vf_ldb_vqid2qid_raddr),
       .rf_lut_vf_ldb_vqid2qid_rclk                        (i_hqm_sip_rf_lut_vf_ldb_vqid2qid_rclk),
       .rf_lut_vf_ldb_vqid2qid_rclk_rst_n                  (i_hqm_sip_rf_lut_vf_ldb_vqid2qid_rclk_rst_n),
       .rf_lut_vf_ldb_vqid2qid_re                          (i_hqm_sip_rf_lut_vf_ldb_vqid2qid_re),
       .rf_lut_vf_ldb_vqid2qid_waddr                       (i_hqm_sip_rf_lut_vf_ldb_vqid2qid_waddr),
       .rf_lut_vf_ldb_vqid2qid_wclk                        (i_hqm_sip_rf_lut_vf_ldb_vqid2qid_wclk),
       .rf_lut_vf_ldb_vqid2qid_wclk_rst_n                  (i_hqm_sip_rf_lut_vf_ldb_vqid2qid_wclk_rst_n),
       .rf_lut_vf_ldb_vqid2qid_wdata                       (i_hqm_sip_rf_lut_vf_ldb_vqid2qid_wdata),
       .rf_lut_vf_ldb_vqid2qid_we                          (i_hqm_sip_rf_lut_vf_ldb_vqid2qid_we),
       .rf_lut_vf_ldb_vqid_v_raddr                         (i_hqm_sip_rf_lut_vf_ldb_vqid_v_raddr),
       .rf_lut_vf_ldb_vqid_v_rclk                          (i_hqm_sip_rf_lut_vf_ldb_vqid_v_rclk),
       .rf_lut_vf_ldb_vqid_v_rclk_rst_n                    (i_hqm_sip_rf_lut_vf_ldb_vqid_v_rclk_rst_n),
       .rf_lut_vf_ldb_vqid_v_re                            (i_hqm_sip_rf_lut_vf_ldb_vqid_v_re),
       .rf_lut_vf_ldb_vqid_v_waddr                         (i_hqm_sip_rf_lut_vf_ldb_vqid_v_waddr),
       .rf_lut_vf_ldb_vqid_v_wclk                          (i_hqm_sip_rf_lut_vf_ldb_vqid_v_wclk),
       .rf_lut_vf_ldb_vqid_v_wclk_rst_n                    (i_hqm_sip_rf_lut_vf_ldb_vqid_v_wclk_rst_n),
       .rf_lut_vf_ldb_vqid_v_wdata                         (i_hqm_sip_rf_lut_vf_ldb_vqid_v_wdata),
       .rf_lut_vf_ldb_vqid_v_we                            (i_hqm_sip_rf_lut_vf_ldb_vqid_v_we),
       .rf_msix_tbl_word0_raddr                            (i_hqm_sip_rf_msix_tbl_word0_raddr),
       .rf_msix_tbl_word0_rclk                             (i_hqm_sip_rf_msix_tbl_word0_rclk),
       .rf_msix_tbl_word0_rclk_rst_n                       (i_hqm_sip_rf_msix_tbl_word0_rclk_rst_n),
       .rf_msix_tbl_word0_re                               (i_hqm_sip_rf_msix_tbl_word0_re),
       .rf_msix_tbl_word0_waddr                            (i_hqm_sip_rf_msix_tbl_word0_waddr),
       .rf_msix_tbl_word0_wclk                             (i_hqm_sip_rf_msix_tbl_word0_wclk),
       .rf_msix_tbl_word0_wclk_rst_n                       (i_hqm_sip_rf_msix_tbl_word0_wclk_rst_n),
       .rf_msix_tbl_word0_wdata                            (i_hqm_sip_rf_msix_tbl_word0_wdata),
       .rf_msix_tbl_word0_we                               (i_hqm_sip_rf_msix_tbl_word0_we),
       .rf_msix_tbl_word1_raddr                            (i_hqm_sip_rf_msix_tbl_word1_raddr),
       .rf_msix_tbl_word1_rclk                             (i_hqm_sip_rf_msix_tbl_word1_rclk),
       .rf_msix_tbl_word1_rclk_rst_n                       (i_hqm_sip_rf_msix_tbl_word1_rclk_rst_n),
       .rf_msix_tbl_word1_re                               (i_hqm_sip_rf_msix_tbl_word1_re),
       .rf_msix_tbl_word1_waddr                            (i_hqm_sip_rf_msix_tbl_word1_waddr),
       .rf_msix_tbl_word1_wclk                             (i_hqm_sip_rf_msix_tbl_word1_wclk),
       .rf_msix_tbl_word1_wclk_rst_n                       (i_hqm_sip_rf_msix_tbl_word1_wclk_rst_n),
       .rf_msix_tbl_word1_wdata                            (i_hqm_sip_rf_msix_tbl_word1_wdata),
       .rf_msix_tbl_word1_we                               (i_hqm_sip_rf_msix_tbl_word1_we),
       .rf_msix_tbl_word2_raddr                            (i_hqm_sip_rf_msix_tbl_word2_raddr),
       .rf_msix_tbl_word2_rclk                             (i_hqm_sip_rf_msix_tbl_word2_rclk),
       .rf_msix_tbl_word2_rclk_rst_n                       (i_hqm_sip_rf_msix_tbl_word2_rclk_rst_n),
       .rf_msix_tbl_word2_re                               (i_hqm_sip_rf_msix_tbl_word2_re),
       .rf_msix_tbl_word2_waddr                            (i_hqm_sip_rf_msix_tbl_word2_waddr),
       .rf_msix_tbl_word2_wclk                             (i_hqm_sip_rf_msix_tbl_word2_wclk),
       .rf_msix_tbl_word2_wclk_rst_n                       (i_hqm_sip_rf_msix_tbl_word2_wclk_rst_n),
       .rf_msix_tbl_word2_wdata                            (i_hqm_sip_rf_msix_tbl_word2_wdata),
       .rf_msix_tbl_word2_we                               (i_hqm_sip_rf_msix_tbl_word2_we),
       .rf_mstr_ll_data0_raddr                             (i_hqm_sip_rf_mstr_ll_data0_raddr),
       .rf_mstr_ll_data0_rclk                              (i_hqm_sip_rf_mstr_ll_data0_rclk),
       .rf_mstr_ll_data0_rclk_rst_n                        (i_hqm_sip_rf_mstr_ll_data0_rclk_rst_n),
       .rf_mstr_ll_data0_re                                (i_hqm_sip_rf_mstr_ll_data0_re),
       .rf_mstr_ll_data0_waddr                             (i_hqm_sip_rf_mstr_ll_data0_waddr),
       .rf_mstr_ll_data0_wclk                              (i_hqm_sip_rf_mstr_ll_data0_wclk),
       .rf_mstr_ll_data0_wclk_rst_n                        (i_hqm_sip_rf_mstr_ll_data0_wclk_rst_n),
       .rf_mstr_ll_data0_wdata                             (i_hqm_sip_rf_mstr_ll_data0_wdata),
       .rf_mstr_ll_data0_we                                (i_hqm_sip_rf_mstr_ll_data0_we),
       .rf_mstr_ll_data1_raddr                             (i_hqm_sip_rf_mstr_ll_data1_raddr),
       .rf_mstr_ll_data1_rclk                              (i_hqm_sip_rf_mstr_ll_data1_rclk),
       .rf_mstr_ll_data1_rclk_rst_n                        (i_hqm_sip_rf_mstr_ll_data1_rclk_rst_n),
       .rf_mstr_ll_data1_re                                (i_hqm_sip_rf_mstr_ll_data1_re),
       .rf_mstr_ll_data1_waddr                             (i_hqm_sip_rf_mstr_ll_data1_waddr),
       .rf_mstr_ll_data1_wclk                              (i_hqm_sip_rf_mstr_ll_data1_wclk),
       .rf_mstr_ll_data1_wclk_rst_n                        (i_hqm_sip_rf_mstr_ll_data1_wclk_rst_n),
       .rf_mstr_ll_data1_wdata                             (i_hqm_sip_rf_mstr_ll_data1_wdata),
       .rf_mstr_ll_data1_we                                (i_hqm_sip_rf_mstr_ll_data1_we),
       .rf_mstr_ll_data2_raddr                             (i_hqm_sip_rf_mstr_ll_data2_raddr),
       .rf_mstr_ll_data2_rclk                              (i_hqm_sip_rf_mstr_ll_data2_rclk),
       .rf_mstr_ll_data2_rclk_rst_n                        (i_hqm_sip_rf_mstr_ll_data2_rclk_rst_n),
       .rf_mstr_ll_data2_re                                (i_hqm_sip_rf_mstr_ll_data2_re),
       .rf_mstr_ll_data2_waddr                             (i_hqm_sip_rf_mstr_ll_data2_waddr),
       .rf_mstr_ll_data2_wclk                              (i_hqm_sip_rf_mstr_ll_data2_wclk),
       .rf_mstr_ll_data2_wclk_rst_n                        (i_hqm_sip_rf_mstr_ll_data2_wclk_rst_n),
       .rf_mstr_ll_data2_wdata                             (i_hqm_sip_rf_mstr_ll_data2_wdata),
       .rf_mstr_ll_data2_we                                (i_hqm_sip_rf_mstr_ll_data2_we),
       .rf_mstr_ll_data3_raddr                             (i_hqm_sip_rf_mstr_ll_data3_raddr),
       .rf_mstr_ll_data3_rclk                              (i_hqm_sip_rf_mstr_ll_data3_rclk),
       .rf_mstr_ll_data3_rclk_rst_n                        (i_hqm_sip_rf_mstr_ll_data3_rclk_rst_n),
       .rf_mstr_ll_data3_re                                (i_hqm_sip_rf_mstr_ll_data3_re),
       .rf_mstr_ll_data3_waddr                             (i_hqm_sip_rf_mstr_ll_data3_waddr),
       .rf_mstr_ll_data3_wclk                              (i_hqm_sip_rf_mstr_ll_data3_wclk),
       .rf_mstr_ll_data3_wclk_rst_n                        (i_hqm_sip_rf_mstr_ll_data3_wclk_rst_n),
       .rf_mstr_ll_data3_wdata                             (i_hqm_sip_rf_mstr_ll_data3_wdata),
       .rf_mstr_ll_data3_we                                (i_hqm_sip_rf_mstr_ll_data3_we),
       .rf_mstr_ll_hdr_raddr                               (i_hqm_sip_rf_mstr_ll_hdr_raddr),
       .rf_mstr_ll_hdr_rclk                                (i_hqm_sip_rf_mstr_ll_hdr_rclk),
       .rf_mstr_ll_hdr_rclk_rst_n                          (i_hqm_sip_rf_mstr_ll_hdr_rclk_rst_n),
       .rf_mstr_ll_hdr_re                                  (i_hqm_sip_rf_mstr_ll_hdr_re),
       .rf_mstr_ll_hdr_waddr                               (i_hqm_sip_rf_mstr_ll_hdr_waddr),
       .rf_mstr_ll_hdr_wclk                                (i_hqm_sip_rf_mstr_ll_hdr_wclk),
       .rf_mstr_ll_hdr_wclk_rst_n                          (i_hqm_sip_rf_mstr_ll_hdr_wclk_rst_n),
       .rf_mstr_ll_hdr_wdata                               (i_hqm_sip_rf_mstr_ll_hdr_wdata),
       .rf_mstr_ll_hdr_we                                  (i_hqm_sip_rf_mstr_ll_hdr_we),
       .rf_mstr_ll_hpa_raddr                               (i_hqm_sip_rf_mstr_ll_hpa_raddr),
       .rf_mstr_ll_hpa_rclk                                (i_hqm_sip_rf_mstr_ll_hpa_rclk),
       .rf_mstr_ll_hpa_rclk_rst_n                          (i_hqm_sip_rf_mstr_ll_hpa_rclk_rst_n),
       .rf_mstr_ll_hpa_re                                  (i_hqm_sip_rf_mstr_ll_hpa_re),
       .rf_mstr_ll_hpa_waddr                               (i_hqm_sip_rf_mstr_ll_hpa_waddr),
       .rf_mstr_ll_hpa_wclk                                (i_hqm_sip_rf_mstr_ll_hpa_wclk),
       .rf_mstr_ll_hpa_wclk_rst_n                          (i_hqm_sip_rf_mstr_ll_hpa_wclk_rst_n),
       .rf_mstr_ll_hpa_wdata                               (i_hqm_sip_rf_mstr_ll_hpa_wdata),
       .rf_mstr_ll_hpa_we                                  (i_hqm_sip_rf_mstr_ll_hpa_we),
       .rf_nalb_cmp_fifo_mem_raddr                         (i_hqm_sip_rf_nalb_cmp_fifo_mem_raddr),
       .rf_nalb_cmp_fifo_mem_rclk                          (i_hqm_sip_rf_nalb_cmp_fifo_mem_rclk),
       .rf_nalb_cmp_fifo_mem_rclk_rst_n                    (i_hqm_sip_rf_nalb_cmp_fifo_mem_rclk_rst_n),
       .rf_nalb_cmp_fifo_mem_re                            (i_hqm_sip_rf_nalb_cmp_fifo_mem_re),
       .rf_nalb_cmp_fifo_mem_waddr                         (i_hqm_sip_rf_nalb_cmp_fifo_mem_waddr),
       .rf_nalb_cmp_fifo_mem_wclk                          (i_hqm_sip_rf_nalb_cmp_fifo_mem_wclk),
       .rf_nalb_cmp_fifo_mem_wclk_rst_n                    (i_hqm_sip_rf_nalb_cmp_fifo_mem_wclk_rst_n),
       .rf_nalb_cmp_fifo_mem_wdata                         (i_hqm_sip_rf_nalb_cmp_fifo_mem_wdata),
       .rf_nalb_cmp_fifo_mem_we                            (i_hqm_sip_rf_nalb_cmp_fifo_mem_we),
       .rf_nalb_cnt_raddr                                  (i_hqm_sip_rf_nalb_cnt_raddr),
       .rf_nalb_cnt_rclk                                   (i_hqm_sip_rf_nalb_cnt_rclk),
       .rf_nalb_cnt_rclk_rst_n                             (i_hqm_sip_rf_nalb_cnt_rclk_rst_n),
       .rf_nalb_cnt_re                                     (i_hqm_sip_rf_nalb_cnt_re),
       .rf_nalb_cnt_waddr                                  (i_hqm_sip_rf_nalb_cnt_waddr),
       .rf_nalb_cnt_wclk                                   (i_hqm_sip_rf_nalb_cnt_wclk),
       .rf_nalb_cnt_wclk_rst_n                             (i_hqm_sip_rf_nalb_cnt_wclk_rst_n),
       .rf_nalb_cnt_wdata                                  (i_hqm_sip_rf_nalb_cnt_wdata),
       .rf_nalb_cnt_we                                     (i_hqm_sip_rf_nalb_cnt_we),
       .rf_nalb_hp_raddr                                   (i_hqm_sip_rf_nalb_hp_raddr),
       .rf_nalb_hp_rclk                                    (i_hqm_sip_rf_nalb_hp_rclk),
       .rf_nalb_hp_rclk_rst_n                              (i_hqm_sip_rf_nalb_hp_rclk_rst_n),
       .rf_nalb_hp_re                                      (i_hqm_sip_rf_nalb_hp_re),
       .rf_nalb_hp_waddr                                   (i_hqm_sip_rf_nalb_hp_waddr),
       .rf_nalb_hp_wclk                                    (i_hqm_sip_rf_nalb_hp_wclk),
       .rf_nalb_hp_wclk_rst_n                              (i_hqm_sip_rf_nalb_hp_wclk_rst_n),
       .rf_nalb_hp_wdata                                   (i_hqm_sip_rf_nalb_hp_wdata),
       .rf_nalb_hp_we                                      (i_hqm_sip_rf_nalb_hp_we),
       .rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_raddr          (i_hqm_sip_rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_raddr),
       .rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_rclk           (i_hqm_sip_rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_rclk),
       .rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_rclk_rst_n     (i_hqm_sip_rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_rclk_rst_n),
       .rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_re             (i_hqm_sip_rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_re),
       .rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_waddr          (i_hqm_sip_rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_waddr),
       .rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_wclk           (i_hqm_sip_rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_wclk),
       .rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_wclk_rst_n     (i_hqm_sip_rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_wclk_rst_n),
       .rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_wdata          (i_hqm_sip_rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_wdata),
       .rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_we             (i_hqm_sip_rf_nalb_lsp_enq_lb_rx_sync_fifo_mem_we),
       .rf_nalb_lsp_enq_rorply_raddr                       (i_hqm_sip_rf_nalb_lsp_enq_rorply_raddr),
       .rf_nalb_lsp_enq_rorply_rclk                        (i_hqm_sip_rf_nalb_lsp_enq_rorply_rclk),
       .rf_nalb_lsp_enq_rorply_rclk_rst_n                  (i_hqm_sip_rf_nalb_lsp_enq_rorply_rclk_rst_n),
       .rf_nalb_lsp_enq_rorply_re                          (i_hqm_sip_rf_nalb_lsp_enq_rorply_re),
       .rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_raddr      (i_hqm_sip_rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_raddr),
       .rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_rclk       (i_hqm_sip_rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_rclk),
       .rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_rclk_rst_n (i_hqm_sip_rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_rclk_rst_n),
       .rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_re         (i_hqm_sip_rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_re),
       .rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_waddr      (i_hqm_sip_rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_waddr),
       .rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_wclk       (i_hqm_sip_rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_wclk),
       .rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_wclk_rst_n (i_hqm_sip_rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_wclk_rst_n),
       .rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_wdata      (i_hqm_sip_rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_wdata),
       .rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_we         (i_hqm_sip_rf_nalb_lsp_enq_rorply_rx_sync_fifo_mem_we),
       .rf_nalb_lsp_enq_rorply_waddr                       (i_hqm_sip_rf_nalb_lsp_enq_rorply_waddr),
       .rf_nalb_lsp_enq_rorply_wclk                        (i_hqm_sip_rf_nalb_lsp_enq_rorply_wclk),
       .rf_nalb_lsp_enq_rorply_wclk_rst_n                  (i_hqm_sip_rf_nalb_lsp_enq_rorply_wclk_rst_n),
       .rf_nalb_lsp_enq_rorply_wdata                       (i_hqm_sip_rf_nalb_lsp_enq_rorply_wdata),
       .rf_nalb_lsp_enq_rorply_we                          (i_hqm_sip_rf_nalb_lsp_enq_rorply_we),
       .rf_nalb_lsp_enq_unoord_raddr                       (i_hqm_sip_rf_nalb_lsp_enq_unoord_raddr),
       .rf_nalb_lsp_enq_unoord_rclk                        (i_hqm_sip_rf_nalb_lsp_enq_unoord_rclk),
       .rf_nalb_lsp_enq_unoord_rclk_rst_n                  (i_hqm_sip_rf_nalb_lsp_enq_unoord_rclk_rst_n),
       .rf_nalb_lsp_enq_unoord_re                          (i_hqm_sip_rf_nalb_lsp_enq_unoord_re),
       .rf_nalb_lsp_enq_unoord_waddr                       (i_hqm_sip_rf_nalb_lsp_enq_unoord_waddr),
       .rf_nalb_lsp_enq_unoord_wclk                        (i_hqm_sip_rf_nalb_lsp_enq_unoord_wclk),
       .rf_nalb_lsp_enq_unoord_wclk_rst_n                  (i_hqm_sip_rf_nalb_lsp_enq_unoord_wclk_rst_n),
       .rf_nalb_lsp_enq_unoord_wdata                       (i_hqm_sip_rf_nalb_lsp_enq_unoord_wdata),
       .rf_nalb_lsp_enq_unoord_we                          (i_hqm_sip_rf_nalb_lsp_enq_unoord_we),
       .rf_nalb_qed_raddr                                  (i_hqm_sip_rf_nalb_qed_raddr),
       .rf_nalb_qed_rclk                                   (i_hqm_sip_rf_nalb_qed_rclk),
       .rf_nalb_qed_rclk_rst_n                             (i_hqm_sip_rf_nalb_qed_rclk_rst_n),
       .rf_nalb_qed_re                                     (i_hqm_sip_rf_nalb_qed_re),
       .rf_nalb_qed_waddr                                  (i_hqm_sip_rf_nalb_qed_waddr),
       .rf_nalb_qed_wclk                                   (i_hqm_sip_rf_nalb_qed_wclk),
       .rf_nalb_qed_wclk_rst_n                             (i_hqm_sip_rf_nalb_qed_wclk_rst_n),
       .rf_nalb_qed_wdata                                  (i_hqm_sip_rf_nalb_qed_wdata),
       .rf_nalb_qed_we                                     (i_hqm_sip_rf_nalb_qed_we),
       .rf_nalb_replay_cnt_raddr                           (i_hqm_sip_rf_nalb_replay_cnt_raddr),
       .rf_nalb_replay_cnt_rclk                            (i_hqm_sip_rf_nalb_replay_cnt_rclk),
       .rf_nalb_replay_cnt_rclk_rst_n                      (i_hqm_sip_rf_nalb_replay_cnt_rclk_rst_n),
       .rf_nalb_replay_cnt_re                              (i_hqm_sip_rf_nalb_replay_cnt_re),
       .rf_nalb_replay_cnt_waddr                           (i_hqm_sip_rf_nalb_replay_cnt_waddr),
       .rf_nalb_replay_cnt_wclk                            (i_hqm_sip_rf_nalb_replay_cnt_wclk),
       .rf_nalb_replay_cnt_wclk_rst_n                      (i_hqm_sip_rf_nalb_replay_cnt_wclk_rst_n),
       .rf_nalb_replay_cnt_wdata                           (i_hqm_sip_rf_nalb_replay_cnt_wdata),
       .rf_nalb_replay_cnt_we                              (i_hqm_sip_rf_nalb_replay_cnt_we),
       .rf_nalb_replay_hp_raddr                            (i_hqm_sip_rf_nalb_replay_hp_raddr),
       .rf_nalb_replay_hp_rclk                             (i_hqm_sip_rf_nalb_replay_hp_rclk),
       .rf_nalb_replay_hp_rclk_rst_n                       (i_hqm_sip_rf_nalb_replay_hp_rclk_rst_n),
       .rf_nalb_replay_hp_re                               (i_hqm_sip_rf_nalb_replay_hp_re),
       .rf_nalb_replay_hp_waddr                            (i_hqm_sip_rf_nalb_replay_hp_waddr),
       .rf_nalb_replay_hp_wclk                             (i_hqm_sip_rf_nalb_replay_hp_wclk),
       .rf_nalb_replay_hp_wclk_rst_n                       (i_hqm_sip_rf_nalb_replay_hp_wclk_rst_n),
       .rf_nalb_replay_hp_wdata                            (i_hqm_sip_rf_nalb_replay_hp_wdata),
       .rf_nalb_replay_hp_we                               (i_hqm_sip_rf_nalb_replay_hp_we),
       .rf_nalb_replay_tp_raddr                            (i_hqm_sip_rf_nalb_replay_tp_raddr),
       .rf_nalb_replay_tp_rclk                             (i_hqm_sip_rf_nalb_replay_tp_rclk),
       .rf_nalb_replay_tp_rclk_rst_n                       (i_hqm_sip_rf_nalb_replay_tp_rclk_rst_n),
       .rf_nalb_replay_tp_re                               (i_hqm_sip_rf_nalb_replay_tp_re),
       .rf_nalb_replay_tp_waddr                            (i_hqm_sip_rf_nalb_replay_tp_waddr),
       .rf_nalb_replay_tp_wclk                             (i_hqm_sip_rf_nalb_replay_tp_wclk),
       .rf_nalb_replay_tp_wclk_rst_n                       (i_hqm_sip_rf_nalb_replay_tp_wclk_rst_n),
       .rf_nalb_replay_tp_wdata                            (i_hqm_sip_rf_nalb_replay_tp_wdata),
       .rf_nalb_replay_tp_we                               (i_hqm_sip_rf_nalb_replay_tp_we),
       .rf_nalb_rofrag_cnt_raddr                           (i_hqm_sip_rf_nalb_rofrag_cnt_raddr),
       .rf_nalb_rofrag_cnt_rclk                            (i_hqm_sip_rf_nalb_rofrag_cnt_rclk),
       .rf_nalb_rofrag_cnt_rclk_rst_n                      (i_hqm_sip_rf_nalb_rofrag_cnt_rclk_rst_n),
       .rf_nalb_rofrag_cnt_re                              (i_hqm_sip_rf_nalb_rofrag_cnt_re),
       .rf_nalb_rofrag_cnt_waddr                           (i_hqm_sip_rf_nalb_rofrag_cnt_waddr),
       .rf_nalb_rofrag_cnt_wclk                            (i_hqm_sip_rf_nalb_rofrag_cnt_wclk),
       .rf_nalb_rofrag_cnt_wclk_rst_n                      (i_hqm_sip_rf_nalb_rofrag_cnt_wclk_rst_n),
       .rf_nalb_rofrag_cnt_wdata                           (i_hqm_sip_rf_nalb_rofrag_cnt_wdata),
       .rf_nalb_rofrag_cnt_we                              (i_hqm_sip_rf_nalb_rofrag_cnt_we),
       .rf_nalb_rofrag_hp_raddr                            (i_hqm_sip_rf_nalb_rofrag_hp_raddr),
       .rf_nalb_rofrag_hp_rclk                             (i_hqm_sip_rf_nalb_rofrag_hp_rclk),
       .rf_nalb_rofrag_hp_rclk_rst_n                       (i_hqm_sip_rf_nalb_rofrag_hp_rclk_rst_n),
       .rf_nalb_rofrag_hp_re                               (i_hqm_sip_rf_nalb_rofrag_hp_re),
       .rf_nalb_rofrag_hp_waddr                            (i_hqm_sip_rf_nalb_rofrag_hp_waddr),
       .rf_nalb_rofrag_hp_wclk                             (i_hqm_sip_rf_nalb_rofrag_hp_wclk),
       .rf_nalb_rofrag_hp_wclk_rst_n                       (i_hqm_sip_rf_nalb_rofrag_hp_wclk_rst_n),
       .rf_nalb_rofrag_hp_wdata                            (i_hqm_sip_rf_nalb_rofrag_hp_wdata),
       .rf_nalb_rofrag_hp_we                               (i_hqm_sip_rf_nalb_rofrag_hp_we),
       .rf_nalb_rofrag_tp_raddr                            (i_hqm_sip_rf_nalb_rofrag_tp_raddr),
       .rf_nalb_rofrag_tp_rclk                             (i_hqm_sip_rf_nalb_rofrag_tp_rclk),
       .rf_nalb_rofrag_tp_rclk_rst_n                       (i_hqm_sip_rf_nalb_rofrag_tp_rclk_rst_n),
       .rf_nalb_rofrag_tp_re                               (i_hqm_sip_rf_nalb_rofrag_tp_re),
       .rf_nalb_rofrag_tp_waddr                            (i_hqm_sip_rf_nalb_rofrag_tp_waddr),
       .rf_nalb_rofrag_tp_wclk                             (i_hqm_sip_rf_nalb_rofrag_tp_wclk),
       .rf_nalb_rofrag_tp_wclk_rst_n                       (i_hqm_sip_rf_nalb_rofrag_tp_wclk_rst_n),
       .rf_nalb_rofrag_tp_wdata                            (i_hqm_sip_rf_nalb_rofrag_tp_wdata),
       .rf_nalb_rofrag_tp_we                               (i_hqm_sip_rf_nalb_rofrag_tp_we),
       .rf_nalb_sel_nalb_fifo_mem_raddr                    (i_hqm_sip_rf_nalb_sel_nalb_fifo_mem_raddr),
       .rf_nalb_sel_nalb_fifo_mem_rclk                     (i_hqm_sip_rf_nalb_sel_nalb_fifo_mem_rclk),
       .rf_nalb_sel_nalb_fifo_mem_rclk_rst_n               (i_hqm_sip_rf_nalb_sel_nalb_fifo_mem_rclk_rst_n),
       .rf_nalb_sel_nalb_fifo_mem_re                       (i_hqm_sip_rf_nalb_sel_nalb_fifo_mem_re),
       .rf_nalb_sel_nalb_fifo_mem_waddr                    (i_hqm_sip_rf_nalb_sel_nalb_fifo_mem_waddr),
       .rf_nalb_sel_nalb_fifo_mem_wclk                     (i_hqm_sip_rf_nalb_sel_nalb_fifo_mem_wclk),
       .rf_nalb_sel_nalb_fifo_mem_wclk_rst_n               (i_hqm_sip_rf_nalb_sel_nalb_fifo_mem_wclk_rst_n),
       .rf_nalb_sel_nalb_fifo_mem_wdata                    (i_hqm_sip_rf_nalb_sel_nalb_fifo_mem_wdata),
       .rf_nalb_sel_nalb_fifo_mem_we                       (i_hqm_sip_rf_nalb_sel_nalb_fifo_mem_we),
       .rf_nalb_tp_raddr                                   (i_hqm_sip_rf_nalb_tp_raddr),
       .rf_nalb_tp_rclk                                    (i_hqm_sip_rf_nalb_tp_rclk),
       .rf_nalb_tp_rclk_rst_n                              (i_hqm_sip_rf_nalb_tp_rclk_rst_n),
       .rf_nalb_tp_re                                      (i_hqm_sip_rf_nalb_tp_re),
       .rf_nalb_tp_waddr                                   (i_hqm_sip_rf_nalb_tp_waddr),
       .rf_nalb_tp_wclk                                    (i_hqm_sip_rf_nalb_tp_wclk),
       .rf_nalb_tp_wclk_rst_n                              (i_hqm_sip_rf_nalb_tp_wclk_rst_n),
       .rf_nalb_tp_wdata                                   (i_hqm_sip_rf_nalb_tp_wdata),
       .rf_nalb_tp_we                                      (i_hqm_sip_rf_nalb_tp_we),
       .rf_ord_qid_sn_map_raddr                            (i_hqm_sip_rf_ord_qid_sn_map_raddr),
       .rf_ord_qid_sn_map_rclk                             (i_hqm_sip_rf_ord_qid_sn_map_rclk),
       .rf_ord_qid_sn_map_rclk_rst_n                       (i_hqm_sip_rf_ord_qid_sn_map_rclk_rst_n),
       .rf_ord_qid_sn_map_re                               (i_hqm_sip_rf_ord_qid_sn_map_re),
       .rf_ord_qid_sn_map_waddr                            (i_hqm_sip_rf_ord_qid_sn_map_waddr),
       .rf_ord_qid_sn_map_wclk                             (i_hqm_sip_rf_ord_qid_sn_map_wclk),
       .rf_ord_qid_sn_map_wclk_rst_n                       (i_hqm_sip_rf_ord_qid_sn_map_wclk_rst_n),
       .rf_ord_qid_sn_map_wdata                            (i_hqm_sip_rf_ord_qid_sn_map_wdata),
       .rf_ord_qid_sn_map_we                               (i_hqm_sip_rf_ord_qid_sn_map_we),
       .rf_ord_qid_sn_raddr                                (i_hqm_sip_rf_ord_qid_sn_raddr),
       .rf_ord_qid_sn_rclk                                 (i_hqm_sip_rf_ord_qid_sn_rclk),
       .rf_ord_qid_sn_rclk_rst_n                           (i_hqm_sip_rf_ord_qid_sn_rclk_rst_n),
       .rf_ord_qid_sn_re                                   (i_hqm_sip_rf_ord_qid_sn_re),
       .rf_ord_qid_sn_waddr                                (i_hqm_sip_rf_ord_qid_sn_waddr),
       .rf_ord_qid_sn_wclk                                 (i_hqm_sip_rf_ord_qid_sn_wclk),
       .rf_ord_qid_sn_wclk_rst_n                           (i_hqm_sip_rf_ord_qid_sn_wclk_rst_n),
       .rf_ord_qid_sn_wdata                                (i_hqm_sip_rf_ord_qid_sn_wdata),
       .rf_ord_qid_sn_we                                   (i_hqm_sip_rf_ord_qid_sn_we),
       .rf_outbound_hcw_fifo_mem_raddr                     (i_hqm_sip_rf_outbound_hcw_fifo_mem_raddr),
       .rf_outbound_hcw_fifo_mem_rclk                      (i_hqm_sip_rf_outbound_hcw_fifo_mem_rclk),
       .rf_outbound_hcw_fifo_mem_rclk_rst_n                (i_hqm_sip_rf_outbound_hcw_fifo_mem_rclk_rst_n),
       .rf_outbound_hcw_fifo_mem_re                        (i_hqm_sip_rf_outbound_hcw_fifo_mem_re),
       .rf_outbound_hcw_fifo_mem_waddr                     (i_hqm_sip_rf_outbound_hcw_fifo_mem_waddr),
       .rf_outbound_hcw_fifo_mem_wclk                      (i_hqm_sip_rf_outbound_hcw_fifo_mem_wclk),
       .rf_outbound_hcw_fifo_mem_wclk_rst_n                (i_hqm_sip_rf_outbound_hcw_fifo_mem_wclk_rst_n),
       .rf_outbound_hcw_fifo_mem_wdata                     (i_hqm_sip_rf_outbound_hcw_fifo_mem_wdata),
       .rf_outbound_hcw_fifo_mem_we                        (i_hqm_sip_rf_outbound_hcw_fifo_mem_we),
       .rf_qed_chp_sch_data_raddr                          (i_hqm_sip_rf_qed_chp_sch_data_raddr),
       .rf_qed_chp_sch_data_rclk                           (i_hqm_sip_rf_qed_chp_sch_data_rclk),
       .rf_qed_chp_sch_data_rclk_rst_n                     (i_hqm_sip_rf_qed_chp_sch_data_rclk_rst_n),
       .rf_qed_chp_sch_data_re                             (i_hqm_sip_rf_qed_chp_sch_data_re),
       .rf_qed_chp_sch_data_waddr                          (i_hqm_sip_rf_qed_chp_sch_data_waddr),
       .rf_qed_chp_sch_data_wclk                           (i_hqm_sip_rf_qed_chp_sch_data_wclk),
       .rf_qed_chp_sch_data_wclk_rst_n                     (i_hqm_sip_rf_qed_chp_sch_data_wclk_rst_n),
       .rf_qed_chp_sch_data_wdata                          (i_hqm_sip_rf_qed_chp_sch_data_wdata),
       .rf_qed_chp_sch_data_we                             (i_hqm_sip_rf_qed_chp_sch_data_we),
       .rf_qed_chp_sch_flid_ret_rx_sync_mem_raddr          (i_hqm_sip_rf_qed_chp_sch_flid_ret_rx_sync_mem_raddr),
       .rf_qed_chp_sch_flid_ret_rx_sync_mem_rclk           (i_hqm_sip_rf_qed_chp_sch_flid_ret_rx_sync_mem_rclk),
       .rf_qed_chp_sch_flid_ret_rx_sync_mem_rclk_rst_n     (i_hqm_sip_rf_qed_chp_sch_flid_ret_rx_sync_mem_rclk_rst_n),
       .rf_qed_chp_sch_flid_ret_rx_sync_mem_re             (i_hqm_sip_rf_qed_chp_sch_flid_ret_rx_sync_mem_re),
       .rf_qed_chp_sch_flid_ret_rx_sync_mem_waddr          (i_hqm_sip_rf_qed_chp_sch_flid_ret_rx_sync_mem_waddr),
       .rf_qed_chp_sch_flid_ret_rx_sync_mem_wclk           (i_hqm_sip_rf_qed_chp_sch_flid_ret_rx_sync_mem_wclk),
       .rf_qed_chp_sch_flid_ret_rx_sync_mem_wclk_rst_n     (i_hqm_sip_rf_qed_chp_sch_flid_ret_rx_sync_mem_wclk_rst_n),
       .rf_qed_chp_sch_flid_ret_rx_sync_mem_wdata          (i_hqm_sip_rf_qed_chp_sch_flid_ret_rx_sync_mem_wdata),
       .rf_qed_chp_sch_flid_ret_rx_sync_mem_we             (i_hqm_sip_rf_qed_chp_sch_flid_ret_rx_sync_mem_we),
       .rf_qed_chp_sch_rx_sync_mem_raddr                   (i_hqm_sip_rf_qed_chp_sch_rx_sync_mem_raddr),
       .rf_qed_chp_sch_rx_sync_mem_rclk                    (i_hqm_sip_rf_qed_chp_sch_rx_sync_mem_rclk),
       .rf_qed_chp_sch_rx_sync_mem_rclk_rst_n              (i_hqm_sip_rf_qed_chp_sch_rx_sync_mem_rclk_rst_n),
       .rf_qed_chp_sch_rx_sync_mem_re                      (i_hqm_sip_rf_qed_chp_sch_rx_sync_mem_re),
       .rf_qed_chp_sch_rx_sync_mem_waddr                   (i_hqm_sip_rf_qed_chp_sch_rx_sync_mem_waddr),
       .rf_qed_chp_sch_rx_sync_mem_wclk                    (i_hqm_sip_rf_qed_chp_sch_rx_sync_mem_wclk),
       .rf_qed_chp_sch_rx_sync_mem_wclk_rst_n              (i_hqm_sip_rf_qed_chp_sch_rx_sync_mem_wclk_rst_n),
       .rf_qed_chp_sch_rx_sync_mem_wdata                   (i_hqm_sip_rf_qed_chp_sch_rx_sync_mem_wdata),
       .rf_qed_chp_sch_rx_sync_mem_we                      (i_hqm_sip_rf_qed_chp_sch_rx_sync_mem_we),
       .rf_qed_lsp_deq_fifo_mem_raddr                      (i_hqm_sip_rf_qed_lsp_deq_fifo_mem_raddr),
       .rf_qed_lsp_deq_fifo_mem_rclk                       (i_hqm_sip_rf_qed_lsp_deq_fifo_mem_rclk),
       .rf_qed_lsp_deq_fifo_mem_rclk_rst_n                 (i_hqm_sip_rf_qed_lsp_deq_fifo_mem_rclk_rst_n),
       .rf_qed_lsp_deq_fifo_mem_re                         (i_hqm_sip_rf_qed_lsp_deq_fifo_mem_re),
       .rf_qed_lsp_deq_fifo_mem_waddr                      (i_hqm_sip_rf_qed_lsp_deq_fifo_mem_waddr),
       .rf_qed_lsp_deq_fifo_mem_wclk                       (i_hqm_sip_rf_qed_lsp_deq_fifo_mem_wclk),
       .rf_qed_lsp_deq_fifo_mem_wclk_rst_n                 (i_hqm_sip_rf_qed_lsp_deq_fifo_mem_wclk_rst_n),
       .rf_qed_lsp_deq_fifo_mem_wdata                      (i_hqm_sip_rf_qed_lsp_deq_fifo_mem_wdata),
       .rf_qed_lsp_deq_fifo_mem_we                         (i_hqm_sip_rf_qed_lsp_deq_fifo_mem_we),
       .rf_qed_to_cq_fifo_mem_raddr                        (i_hqm_sip_rf_qed_to_cq_fifo_mem_raddr),
       .rf_qed_to_cq_fifo_mem_rclk                         (i_hqm_sip_rf_qed_to_cq_fifo_mem_rclk),
       .rf_qed_to_cq_fifo_mem_rclk_rst_n                   (i_hqm_sip_rf_qed_to_cq_fifo_mem_rclk_rst_n),
       .rf_qed_to_cq_fifo_mem_re                           (i_hqm_sip_rf_qed_to_cq_fifo_mem_re),
       .rf_qed_to_cq_fifo_mem_waddr                        (i_hqm_sip_rf_qed_to_cq_fifo_mem_waddr),
       .rf_qed_to_cq_fifo_mem_wclk                         (i_hqm_sip_rf_qed_to_cq_fifo_mem_wclk),
       .rf_qed_to_cq_fifo_mem_wclk_rst_n                   (i_hqm_sip_rf_qed_to_cq_fifo_mem_wclk_rst_n),
       .rf_qed_to_cq_fifo_mem_wdata                        (i_hqm_sip_rf_qed_to_cq_fifo_mem_wdata),
       .rf_qed_to_cq_fifo_mem_we                           (i_hqm_sip_rf_qed_to_cq_fifo_mem_we),
       .rf_qid_aqed_active_count_mem_raddr                 (i_hqm_sip_rf_qid_aqed_active_count_mem_raddr),
       .rf_qid_aqed_active_count_mem_rclk                  (i_hqm_sip_rf_qid_aqed_active_count_mem_rclk),
       .rf_qid_aqed_active_count_mem_rclk_rst_n            (i_hqm_sip_rf_qid_aqed_active_count_mem_rclk_rst_n),
       .rf_qid_aqed_active_count_mem_re                    (i_hqm_sip_rf_qid_aqed_active_count_mem_re),
       .rf_qid_aqed_active_count_mem_waddr                 (i_hqm_sip_rf_qid_aqed_active_count_mem_waddr),
       .rf_qid_aqed_active_count_mem_wclk                  (i_hqm_sip_rf_qid_aqed_active_count_mem_wclk),
       .rf_qid_aqed_active_count_mem_wclk_rst_n            (i_hqm_sip_rf_qid_aqed_active_count_mem_wclk_rst_n),
       .rf_qid_aqed_active_count_mem_wdata                 (i_hqm_sip_rf_qid_aqed_active_count_mem_wdata),
       .rf_qid_aqed_active_count_mem_we                    (i_hqm_sip_rf_qid_aqed_active_count_mem_we),
       .rf_qid_atm_active_mem_raddr                        (i_hqm_sip_rf_qid_atm_active_mem_raddr),
       .rf_qid_atm_active_mem_rclk                         (i_hqm_sip_rf_qid_atm_active_mem_rclk),
       .rf_qid_atm_active_mem_rclk_rst_n                   (i_hqm_sip_rf_qid_atm_active_mem_rclk_rst_n),
       .rf_qid_atm_active_mem_re                           (i_hqm_sip_rf_qid_atm_active_mem_re),
       .rf_qid_atm_active_mem_waddr                        (i_hqm_sip_rf_qid_atm_active_mem_waddr),
       .rf_qid_atm_active_mem_wclk                         (i_hqm_sip_rf_qid_atm_active_mem_wclk),
       .rf_qid_atm_active_mem_wclk_rst_n                   (i_hqm_sip_rf_qid_atm_active_mem_wclk_rst_n),
       .rf_qid_atm_active_mem_wdata                        (i_hqm_sip_rf_qid_atm_active_mem_wdata),
       .rf_qid_atm_active_mem_we                           (i_hqm_sip_rf_qid_atm_active_mem_we),
       .rf_qid_atm_tot_enq_cnt_mem_raddr                   (i_hqm_sip_rf_qid_atm_tot_enq_cnt_mem_raddr),
       .rf_qid_atm_tot_enq_cnt_mem_rclk                    (i_hqm_sip_rf_qid_atm_tot_enq_cnt_mem_rclk),
       .rf_qid_atm_tot_enq_cnt_mem_rclk_rst_n              (i_hqm_sip_rf_qid_atm_tot_enq_cnt_mem_rclk_rst_n),
       .rf_qid_atm_tot_enq_cnt_mem_re                      (i_hqm_sip_rf_qid_atm_tot_enq_cnt_mem_re),
       .rf_qid_atm_tot_enq_cnt_mem_waddr                   (i_hqm_sip_rf_qid_atm_tot_enq_cnt_mem_waddr),
       .rf_qid_atm_tot_enq_cnt_mem_wclk                    (i_hqm_sip_rf_qid_atm_tot_enq_cnt_mem_wclk),
       .rf_qid_atm_tot_enq_cnt_mem_wclk_rst_n              (i_hqm_sip_rf_qid_atm_tot_enq_cnt_mem_wclk_rst_n),
       .rf_qid_atm_tot_enq_cnt_mem_wdata                   (i_hqm_sip_rf_qid_atm_tot_enq_cnt_mem_wdata),
       .rf_qid_atm_tot_enq_cnt_mem_we                      (i_hqm_sip_rf_qid_atm_tot_enq_cnt_mem_we),
       .rf_qid_atq_enqueue_count_mem_raddr                 (i_hqm_sip_rf_qid_atq_enqueue_count_mem_raddr),
       .rf_qid_atq_enqueue_count_mem_rclk                  (i_hqm_sip_rf_qid_atq_enqueue_count_mem_rclk),
       .rf_qid_atq_enqueue_count_mem_rclk_rst_n            (i_hqm_sip_rf_qid_atq_enqueue_count_mem_rclk_rst_n),
       .rf_qid_atq_enqueue_count_mem_re                    (i_hqm_sip_rf_qid_atq_enqueue_count_mem_re),
       .rf_qid_atq_enqueue_count_mem_waddr                 (i_hqm_sip_rf_qid_atq_enqueue_count_mem_waddr),
       .rf_qid_atq_enqueue_count_mem_wclk                  (i_hqm_sip_rf_qid_atq_enqueue_count_mem_wclk),
       .rf_qid_atq_enqueue_count_mem_wclk_rst_n            (i_hqm_sip_rf_qid_atq_enqueue_count_mem_wclk_rst_n),
       .rf_qid_atq_enqueue_count_mem_wdata                 (i_hqm_sip_rf_qid_atq_enqueue_count_mem_wdata),
       .rf_qid_atq_enqueue_count_mem_we                    (i_hqm_sip_rf_qid_atq_enqueue_count_mem_we),
       .rf_qid_dir_max_depth_mem_raddr                     (i_hqm_sip_rf_qid_dir_max_depth_mem_raddr),
       .rf_qid_dir_max_depth_mem_rclk                      (i_hqm_sip_rf_qid_dir_max_depth_mem_rclk),
       .rf_qid_dir_max_depth_mem_rclk_rst_n                (i_hqm_sip_rf_qid_dir_max_depth_mem_rclk_rst_n),
       .rf_qid_dir_max_depth_mem_re                        (i_hqm_sip_rf_qid_dir_max_depth_mem_re),
       .rf_qid_dir_max_depth_mem_waddr                     (i_hqm_sip_rf_qid_dir_max_depth_mem_waddr),
       .rf_qid_dir_max_depth_mem_wclk                      (i_hqm_sip_rf_qid_dir_max_depth_mem_wclk),
       .rf_qid_dir_max_depth_mem_wclk_rst_n                (i_hqm_sip_rf_qid_dir_max_depth_mem_wclk_rst_n),
       .rf_qid_dir_max_depth_mem_wdata                     (i_hqm_sip_rf_qid_dir_max_depth_mem_wdata),
       .rf_qid_dir_max_depth_mem_we                        (i_hqm_sip_rf_qid_dir_max_depth_mem_we),
       .rf_qid_dir_replay_count_mem_raddr                  (i_hqm_sip_rf_qid_dir_replay_count_mem_raddr),
       .rf_qid_dir_replay_count_mem_rclk                   (i_hqm_sip_rf_qid_dir_replay_count_mem_rclk),
       .rf_qid_dir_replay_count_mem_rclk_rst_n             (i_hqm_sip_rf_qid_dir_replay_count_mem_rclk_rst_n),
       .rf_qid_dir_replay_count_mem_re                     (i_hqm_sip_rf_qid_dir_replay_count_mem_re),
       .rf_qid_dir_replay_count_mem_waddr                  (i_hqm_sip_rf_qid_dir_replay_count_mem_waddr),
       .rf_qid_dir_replay_count_mem_wclk                   (i_hqm_sip_rf_qid_dir_replay_count_mem_wclk),
       .rf_qid_dir_replay_count_mem_wclk_rst_n             (i_hqm_sip_rf_qid_dir_replay_count_mem_wclk_rst_n),
       .rf_qid_dir_replay_count_mem_wdata                  (i_hqm_sip_rf_qid_dir_replay_count_mem_wdata),
       .rf_qid_dir_replay_count_mem_we                     (i_hqm_sip_rf_qid_dir_replay_count_mem_we),
       .rf_qid_dir_tot_enq_cnt_mem_raddr                   (i_hqm_sip_rf_qid_dir_tot_enq_cnt_mem_raddr),
       .rf_qid_dir_tot_enq_cnt_mem_rclk                    (i_hqm_sip_rf_qid_dir_tot_enq_cnt_mem_rclk),
       .rf_qid_dir_tot_enq_cnt_mem_rclk_rst_n              (i_hqm_sip_rf_qid_dir_tot_enq_cnt_mem_rclk_rst_n),
       .rf_qid_dir_tot_enq_cnt_mem_re                      (i_hqm_sip_rf_qid_dir_tot_enq_cnt_mem_re),
       .rf_qid_dir_tot_enq_cnt_mem_waddr                   (i_hqm_sip_rf_qid_dir_tot_enq_cnt_mem_waddr),
       .rf_qid_dir_tot_enq_cnt_mem_wclk                    (i_hqm_sip_rf_qid_dir_tot_enq_cnt_mem_wclk),
       .rf_qid_dir_tot_enq_cnt_mem_wclk_rst_n              (i_hqm_sip_rf_qid_dir_tot_enq_cnt_mem_wclk_rst_n),
       .rf_qid_dir_tot_enq_cnt_mem_wdata                   (i_hqm_sip_rf_qid_dir_tot_enq_cnt_mem_wdata),
       .rf_qid_dir_tot_enq_cnt_mem_we                      (i_hqm_sip_rf_qid_dir_tot_enq_cnt_mem_we),
       .rf_qid_ldb_enqueue_count_mem_raddr                 (i_hqm_sip_rf_qid_ldb_enqueue_count_mem_raddr),
       .rf_qid_ldb_enqueue_count_mem_rclk                  (i_hqm_sip_rf_qid_ldb_enqueue_count_mem_rclk),
       .rf_qid_ldb_enqueue_count_mem_rclk_rst_n            (i_hqm_sip_rf_qid_ldb_enqueue_count_mem_rclk_rst_n),
       .rf_qid_ldb_enqueue_count_mem_re                    (i_hqm_sip_rf_qid_ldb_enqueue_count_mem_re),
       .rf_qid_ldb_enqueue_count_mem_waddr                 (i_hqm_sip_rf_qid_ldb_enqueue_count_mem_waddr),
       .rf_qid_ldb_enqueue_count_mem_wclk                  (i_hqm_sip_rf_qid_ldb_enqueue_count_mem_wclk),
       .rf_qid_ldb_enqueue_count_mem_wclk_rst_n            (i_hqm_sip_rf_qid_ldb_enqueue_count_mem_wclk_rst_n),
       .rf_qid_ldb_enqueue_count_mem_wdata                 (i_hqm_sip_rf_qid_ldb_enqueue_count_mem_wdata),
       .rf_qid_ldb_enqueue_count_mem_we                    (i_hqm_sip_rf_qid_ldb_enqueue_count_mem_we),
       .rf_qid_ldb_inflight_count_mem_raddr                (i_hqm_sip_rf_qid_ldb_inflight_count_mem_raddr),
       .rf_qid_ldb_inflight_count_mem_rclk                 (i_hqm_sip_rf_qid_ldb_inflight_count_mem_rclk),
       .rf_qid_ldb_inflight_count_mem_rclk_rst_n           (i_hqm_sip_rf_qid_ldb_inflight_count_mem_rclk_rst_n),
       .rf_qid_ldb_inflight_count_mem_re                   (i_hqm_sip_rf_qid_ldb_inflight_count_mem_re),
       .rf_qid_ldb_inflight_count_mem_waddr                (i_hqm_sip_rf_qid_ldb_inflight_count_mem_waddr),
       .rf_qid_ldb_inflight_count_mem_wclk                 (i_hqm_sip_rf_qid_ldb_inflight_count_mem_wclk),
       .rf_qid_ldb_inflight_count_mem_wclk_rst_n           (i_hqm_sip_rf_qid_ldb_inflight_count_mem_wclk_rst_n),
       .rf_qid_ldb_inflight_count_mem_wdata                (i_hqm_sip_rf_qid_ldb_inflight_count_mem_wdata),
       .rf_qid_ldb_inflight_count_mem_we                   (i_hqm_sip_rf_qid_ldb_inflight_count_mem_we),
       .rf_qid_ldb_replay_count_mem_raddr                  (i_hqm_sip_rf_qid_ldb_replay_count_mem_raddr),
       .rf_qid_ldb_replay_count_mem_rclk                   (i_hqm_sip_rf_qid_ldb_replay_count_mem_rclk),
       .rf_qid_ldb_replay_count_mem_rclk_rst_n             (i_hqm_sip_rf_qid_ldb_replay_count_mem_rclk_rst_n),
       .rf_qid_ldb_replay_count_mem_re                     (i_hqm_sip_rf_qid_ldb_replay_count_mem_re),
       .rf_qid_ldb_replay_count_mem_waddr                  (i_hqm_sip_rf_qid_ldb_replay_count_mem_waddr),
       .rf_qid_ldb_replay_count_mem_wclk                   (i_hqm_sip_rf_qid_ldb_replay_count_mem_wclk),
       .rf_qid_ldb_replay_count_mem_wclk_rst_n             (i_hqm_sip_rf_qid_ldb_replay_count_mem_wclk_rst_n),
       .rf_qid_ldb_replay_count_mem_wdata                  (i_hqm_sip_rf_qid_ldb_replay_count_mem_wdata),
       .rf_qid_ldb_replay_count_mem_we                     (i_hqm_sip_rf_qid_ldb_replay_count_mem_we),
       .rf_qid_naldb_max_depth_mem_raddr                   (i_hqm_sip_rf_qid_naldb_max_depth_mem_raddr),
       .rf_qid_naldb_max_depth_mem_rclk                    (i_hqm_sip_rf_qid_naldb_max_depth_mem_rclk),
       .rf_qid_naldb_max_depth_mem_rclk_rst_n              (i_hqm_sip_rf_qid_naldb_max_depth_mem_rclk_rst_n),
       .rf_qid_naldb_max_depth_mem_re                      (i_hqm_sip_rf_qid_naldb_max_depth_mem_re),
       .rf_qid_naldb_max_depth_mem_waddr                   (i_hqm_sip_rf_qid_naldb_max_depth_mem_waddr),
       .rf_qid_naldb_max_depth_mem_wclk                    (i_hqm_sip_rf_qid_naldb_max_depth_mem_wclk),
       .rf_qid_naldb_max_depth_mem_wclk_rst_n              (i_hqm_sip_rf_qid_naldb_max_depth_mem_wclk_rst_n),
       .rf_qid_naldb_max_depth_mem_wdata                   (i_hqm_sip_rf_qid_naldb_max_depth_mem_wdata),
       .rf_qid_naldb_max_depth_mem_we                      (i_hqm_sip_rf_qid_naldb_max_depth_mem_we),
       .rf_qid_naldb_tot_enq_cnt_mem_raddr                 (i_hqm_sip_rf_qid_naldb_tot_enq_cnt_mem_raddr),
       .rf_qid_naldb_tot_enq_cnt_mem_rclk                  (i_hqm_sip_rf_qid_naldb_tot_enq_cnt_mem_rclk),
       .rf_qid_naldb_tot_enq_cnt_mem_rclk_rst_n            (i_hqm_sip_rf_qid_naldb_tot_enq_cnt_mem_rclk_rst_n),
       .rf_qid_naldb_tot_enq_cnt_mem_re                    (i_hqm_sip_rf_qid_naldb_tot_enq_cnt_mem_re),
       .rf_qid_naldb_tot_enq_cnt_mem_waddr                 (i_hqm_sip_rf_qid_naldb_tot_enq_cnt_mem_waddr),
       .rf_qid_naldb_tot_enq_cnt_mem_wclk                  (i_hqm_sip_rf_qid_naldb_tot_enq_cnt_mem_wclk),
       .rf_qid_naldb_tot_enq_cnt_mem_wclk_rst_n            (i_hqm_sip_rf_qid_naldb_tot_enq_cnt_mem_wclk_rst_n),
       .rf_qid_naldb_tot_enq_cnt_mem_wdata                 (i_hqm_sip_rf_qid_naldb_tot_enq_cnt_mem_wdata),
       .rf_qid_naldb_tot_enq_cnt_mem_we                    (i_hqm_sip_rf_qid_naldb_tot_enq_cnt_mem_we),
       .rf_qid_rdylst_clamp_raddr                          (i_hqm_sip_rf_qid_rdylst_clamp_raddr),
       .rf_qid_rdylst_clamp_rclk                           (i_hqm_sip_rf_qid_rdylst_clamp_rclk),
       .rf_qid_rdylst_clamp_rclk_rst_n                     (i_hqm_sip_rf_qid_rdylst_clamp_rclk_rst_n),
       .rf_qid_rdylst_clamp_re                             (i_hqm_sip_rf_qid_rdylst_clamp_re),
       .rf_qid_rdylst_clamp_waddr                          (i_hqm_sip_rf_qid_rdylst_clamp_waddr),
       .rf_qid_rdylst_clamp_wclk                           (i_hqm_sip_rf_qid_rdylst_clamp_wclk),
       .rf_qid_rdylst_clamp_wclk_rst_n                     (i_hqm_sip_rf_qid_rdylst_clamp_wclk_rst_n),
       .rf_qid_rdylst_clamp_wdata                          (i_hqm_sip_rf_qid_rdylst_clamp_wdata),
       .rf_qid_rdylst_clamp_we                             (i_hqm_sip_rf_qid_rdylst_clamp_we),
       .rf_reord_cnt_mem_raddr                             (i_hqm_sip_rf_reord_cnt_mem_raddr),
       .rf_reord_cnt_mem_rclk                              (i_hqm_sip_rf_reord_cnt_mem_rclk),
       .rf_reord_cnt_mem_rclk_rst_n                        (i_hqm_sip_rf_reord_cnt_mem_rclk_rst_n),
       .rf_reord_cnt_mem_re                                (i_hqm_sip_rf_reord_cnt_mem_re),
       .rf_reord_cnt_mem_waddr                             (i_hqm_sip_rf_reord_cnt_mem_waddr),
       .rf_reord_cnt_mem_wclk                              (i_hqm_sip_rf_reord_cnt_mem_wclk),
       .rf_reord_cnt_mem_wclk_rst_n                        (i_hqm_sip_rf_reord_cnt_mem_wclk_rst_n),
       .rf_reord_cnt_mem_wdata                             (i_hqm_sip_rf_reord_cnt_mem_wdata),
       .rf_reord_cnt_mem_we                                (i_hqm_sip_rf_reord_cnt_mem_we),
       .rf_reord_dirhp_mem_raddr                           (i_hqm_sip_rf_reord_dirhp_mem_raddr),
       .rf_reord_dirhp_mem_rclk                            (i_hqm_sip_rf_reord_dirhp_mem_rclk),
       .rf_reord_dirhp_mem_rclk_rst_n                      (i_hqm_sip_rf_reord_dirhp_mem_rclk_rst_n),
       .rf_reord_dirhp_mem_re                              (i_hqm_sip_rf_reord_dirhp_mem_re),
       .rf_reord_dirhp_mem_waddr                           (i_hqm_sip_rf_reord_dirhp_mem_waddr),
       .rf_reord_dirhp_mem_wclk                            (i_hqm_sip_rf_reord_dirhp_mem_wclk),
       .rf_reord_dirhp_mem_wclk_rst_n                      (i_hqm_sip_rf_reord_dirhp_mem_wclk_rst_n),
       .rf_reord_dirhp_mem_wdata                           (i_hqm_sip_rf_reord_dirhp_mem_wdata),
       .rf_reord_dirhp_mem_we                              (i_hqm_sip_rf_reord_dirhp_mem_we),
       .rf_reord_dirtp_mem_raddr                           (i_hqm_sip_rf_reord_dirtp_mem_raddr),
       .rf_reord_dirtp_mem_rclk                            (i_hqm_sip_rf_reord_dirtp_mem_rclk),
       .rf_reord_dirtp_mem_rclk_rst_n                      (i_hqm_sip_rf_reord_dirtp_mem_rclk_rst_n),
       .rf_reord_dirtp_mem_re                              (i_hqm_sip_rf_reord_dirtp_mem_re),
       .rf_reord_dirtp_mem_waddr                           (i_hqm_sip_rf_reord_dirtp_mem_waddr),
       .rf_reord_dirtp_mem_wclk                            (i_hqm_sip_rf_reord_dirtp_mem_wclk),
       .rf_reord_dirtp_mem_wclk_rst_n                      (i_hqm_sip_rf_reord_dirtp_mem_wclk_rst_n),
       .rf_reord_dirtp_mem_wdata                           (i_hqm_sip_rf_reord_dirtp_mem_wdata),
       .rf_reord_dirtp_mem_we                              (i_hqm_sip_rf_reord_dirtp_mem_we),
       .rf_reord_lbhp_mem_raddr                            (i_hqm_sip_rf_reord_lbhp_mem_raddr),
       .rf_reord_lbhp_mem_rclk                             (i_hqm_sip_rf_reord_lbhp_mem_rclk),
       .rf_reord_lbhp_mem_rclk_rst_n                       (i_hqm_sip_rf_reord_lbhp_mem_rclk_rst_n),
       .rf_reord_lbhp_mem_re                               (i_hqm_sip_rf_reord_lbhp_mem_re),
       .rf_reord_lbhp_mem_waddr                            (i_hqm_sip_rf_reord_lbhp_mem_waddr),
       .rf_reord_lbhp_mem_wclk                             (i_hqm_sip_rf_reord_lbhp_mem_wclk),
       .rf_reord_lbhp_mem_wclk_rst_n                       (i_hqm_sip_rf_reord_lbhp_mem_wclk_rst_n),
       .rf_reord_lbhp_mem_wdata                            (i_hqm_sip_rf_reord_lbhp_mem_wdata),
       .rf_reord_lbhp_mem_we                               (i_hqm_sip_rf_reord_lbhp_mem_we),
       .rf_reord_lbtp_mem_raddr                            (i_hqm_sip_rf_reord_lbtp_mem_raddr),
       .rf_reord_lbtp_mem_rclk                             (i_hqm_sip_rf_reord_lbtp_mem_rclk),
       .rf_reord_lbtp_mem_rclk_rst_n                       (i_hqm_sip_rf_reord_lbtp_mem_rclk_rst_n),
       .rf_reord_lbtp_mem_re                               (i_hqm_sip_rf_reord_lbtp_mem_re),
       .rf_reord_lbtp_mem_waddr                            (i_hqm_sip_rf_reord_lbtp_mem_waddr),
       .rf_reord_lbtp_mem_wclk                             (i_hqm_sip_rf_reord_lbtp_mem_wclk),
       .rf_reord_lbtp_mem_wclk_rst_n                       (i_hqm_sip_rf_reord_lbtp_mem_wclk_rst_n),
       .rf_reord_lbtp_mem_wdata                            (i_hqm_sip_rf_reord_lbtp_mem_wdata),
       .rf_reord_lbtp_mem_we                               (i_hqm_sip_rf_reord_lbtp_mem_we),
       .rf_reord_st_mem_raddr                              (i_hqm_sip_rf_reord_st_mem_raddr),
       .rf_reord_st_mem_rclk                               (i_hqm_sip_rf_reord_st_mem_rclk),
       .rf_reord_st_mem_rclk_rst_n                         (i_hqm_sip_rf_reord_st_mem_rclk_rst_n),
       .rf_reord_st_mem_re                                 (i_hqm_sip_rf_reord_st_mem_re),
       .rf_reord_st_mem_waddr                              (i_hqm_sip_rf_reord_st_mem_waddr),
       .rf_reord_st_mem_wclk                               (i_hqm_sip_rf_reord_st_mem_wclk),
       .rf_reord_st_mem_wclk_rst_n                         (i_hqm_sip_rf_reord_st_mem_wclk_rst_n),
       .rf_reord_st_mem_wdata                              (i_hqm_sip_rf_reord_st_mem_wdata),
       .rf_reord_st_mem_we                                 (i_hqm_sip_rf_reord_st_mem_we),
       .rf_ri_tlq_fifo_npdata_raddr                        (i_hqm_sip_rf_ri_tlq_fifo_npdata_raddr),
       .rf_ri_tlq_fifo_npdata_rclk                         (i_hqm_sip_rf_ri_tlq_fifo_npdata_rclk),
       .rf_ri_tlq_fifo_npdata_rclk_rst_n                   (i_hqm_sip_rf_ri_tlq_fifo_npdata_rclk_rst_n),
       .rf_ri_tlq_fifo_npdata_re                           (i_hqm_sip_rf_ri_tlq_fifo_npdata_re),
       .rf_ri_tlq_fifo_npdata_waddr                        (i_hqm_sip_rf_ri_tlq_fifo_npdata_waddr),
       .rf_ri_tlq_fifo_npdata_wclk                         (i_hqm_sip_rf_ri_tlq_fifo_npdata_wclk),
       .rf_ri_tlq_fifo_npdata_wclk_rst_n                   (i_hqm_sip_rf_ri_tlq_fifo_npdata_wclk_rst_n),
       .rf_ri_tlq_fifo_npdata_wdata                        (i_hqm_sip_rf_ri_tlq_fifo_npdata_wdata),
       .rf_ri_tlq_fifo_npdata_we                           (i_hqm_sip_rf_ri_tlq_fifo_npdata_we),
       .rf_ri_tlq_fifo_nphdr_raddr                         (i_hqm_sip_rf_ri_tlq_fifo_nphdr_raddr),
       .rf_ri_tlq_fifo_nphdr_rclk                          (i_hqm_sip_rf_ri_tlq_fifo_nphdr_rclk),
       .rf_ri_tlq_fifo_nphdr_rclk_rst_n                    (i_hqm_sip_rf_ri_tlq_fifo_nphdr_rclk_rst_n),
       .rf_ri_tlq_fifo_nphdr_re                            (i_hqm_sip_rf_ri_tlq_fifo_nphdr_re),
       .rf_ri_tlq_fifo_nphdr_waddr                         (i_hqm_sip_rf_ri_tlq_fifo_nphdr_waddr),
       .rf_ri_tlq_fifo_nphdr_wclk                          (i_hqm_sip_rf_ri_tlq_fifo_nphdr_wclk),
       .rf_ri_tlq_fifo_nphdr_wclk_rst_n                    (i_hqm_sip_rf_ri_tlq_fifo_nphdr_wclk_rst_n),
       .rf_ri_tlq_fifo_nphdr_wdata                         (i_hqm_sip_rf_ri_tlq_fifo_nphdr_wdata),
       .rf_ri_tlq_fifo_nphdr_we                            (i_hqm_sip_rf_ri_tlq_fifo_nphdr_we),
       .rf_ri_tlq_fifo_pdata_raddr                         (i_hqm_sip_rf_ri_tlq_fifo_pdata_raddr),
       .rf_ri_tlq_fifo_pdata_rclk                          (i_hqm_sip_rf_ri_tlq_fifo_pdata_rclk),
       .rf_ri_tlq_fifo_pdata_rclk_rst_n                    (i_hqm_sip_rf_ri_tlq_fifo_pdata_rclk_rst_n),
       .rf_ri_tlq_fifo_pdata_re                            (i_hqm_sip_rf_ri_tlq_fifo_pdata_re),
       .rf_ri_tlq_fifo_pdata_waddr                         (i_hqm_sip_rf_ri_tlq_fifo_pdata_waddr),
       .rf_ri_tlq_fifo_pdata_wclk                          (i_hqm_sip_rf_ri_tlq_fifo_pdata_wclk),
       .rf_ri_tlq_fifo_pdata_wclk_rst_n                    (i_hqm_sip_rf_ri_tlq_fifo_pdata_wclk_rst_n),
       .rf_ri_tlq_fifo_pdata_wdata                         (i_hqm_sip_rf_ri_tlq_fifo_pdata_wdata),
       .rf_ri_tlq_fifo_pdata_we                            (i_hqm_sip_rf_ri_tlq_fifo_pdata_we),
       .rf_ri_tlq_fifo_phdr_raddr                          (i_hqm_sip_rf_ri_tlq_fifo_phdr_raddr),
       .rf_ri_tlq_fifo_phdr_rclk                           (i_hqm_sip_rf_ri_tlq_fifo_phdr_rclk),
       .rf_ri_tlq_fifo_phdr_rclk_rst_n                     (i_hqm_sip_rf_ri_tlq_fifo_phdr_rclk_rst_n),
       .rf_ri_tlq_fifo_phdr_re                             (i_hqm_sip_rf_ri_tlq_fifo_phdr_re),
       .rf_ri_tlq_fifo_phdr_waddr                          (i_hqm_sip_rf_ri_tlq_fifo_phdr_waddr),
       .rf_ri_tlq_fifo_phdr_wclk                           (i_hqm_sip_rf_ri_tlq_fifo_phdr_wclk),
       .rf_ri_tlq_fifo_phdr_wclk_rst_n                     (i_hqm_sip_rf_ri_tlq_fifo_phdr_wclk_rst_n),
       .rf_ri_tlq_fifo_phdr_wdata                          (i_hqm_sip_rf_ri_tlq_fifo_phdr_wdata),
       .rf_ri_tlq_fifo_phdr_we                             (i_hqm_sip_rf_ri_tlq_fifo_phdr_we),
       .rf_rop_chp_rop_hcw_fifo_mem_raddr                  (i_hqm_sip_rf_rop_chp_rop_hcw_fifo_mem_raddr),
       .rf_rop_chp_rop_hcw_fifo_mem_rclk                   (i_hqm_sip_rf_rop_chp_rop_hcw_fifo_mem_rclk),
       .rf_rop_chp_rop_hcw_fifo_mem_rclk_rst_n             (i_hqm_sip_rf_rop_chp_rop_hcw_fifo_mem_rclk_rst_n),
       .rf_rop_chp_rop_hcw_fifo_mem_re                     (i_hqm_sip_rf_rop_chp_rop_hcw_fifo_mem_re),
       .rf_rop_chp_rop_hcw_fifo_mem_waddr                  (i_hqm_sip_rf_rop_chp_rop_hcw_fifo_mem_waddr),
       .rf_rop_chp_rop_hcw_fifo_mem_wclk                   (i_hqm_sip_rf_rop_chp_rop_hcw_fifo_mem_wclk),
       .rf_rop_chp_rop_hcw_fifo_mem_wclk_rst_n             (i_hqm_sip_rf_rop_chp_rop_hcw_fifo_mem_wclk_rst_n),
       .rf_rop_chp_rop_hcw_fifo_mem_wdata                  (i_hqm_sip_rf_rop_chp_rop_hcw_fifo_mem_wdata),
       .rf_rop_chp_rop_hcw_fifo_mem_we                     (i_hqm_sip_rf_rop_chp_rop_hcw_fifo_mem_we),
       .rf_rop_dp_enq_dir_raddr                            (i_hqm_sip_rf_rop_dp_enq_dir_raddr),
       .rf_rop_dp_enq_dir_rclk                             (i_hqm_sip_rf_rop_dp_enq_dir_rclk),
       .rf_rop_dp_enq_dir_rclk_rst_n                       (i_hqm_sip_rf_rop_dp_enq_dir_rclk_rst_n),
       .rf_rop_dp_enq_dir_re                               (i_hqm_sip_rf_rop_dp_enq_dir_re),
       .rf_rop_dp_enq_dir_waddr                            (i_hqm_sip_rf_rop_dp_enq_dir_waddr),
       .rf_rop_dp_enq_dir_wclk                             (i_hqm_sip_rf_rop_dp_enq_dir_wclk),
       .rf_rop_dp_enq_dir_wclk_rst_n                       (i_hqm_sip_rf_rop_dp_enq_dir_wclk_rst_n),
       .rf_rop_dp_enq_dir_wdata                            (i_hqm_sip_rf_rop_dp_enq_dir_wdata),
       .rf_rop_dp_enq_dir_we                               (i_hqm_sip_rf_rop_dp_enq_dir_we),
       .rf_rop_dp_enq_ro_raddr                             (i_hqm_sip_rf_rop_dp_enq_ro_raddr),
       .rf_rop_dp_enq_ro_rclk                              (i_hqm_sip_rf_rop_dp_enq_ro_rclk),
       .rf_rop_dp_enq_ro_rclk_rst_n                        (i_hqm_sip_rf_rop_dp_enq_ro_rclk_rst_n),
       .rf_rop_dp_enq_ro_re                                (i_hqm_sip_rf_rop_dp_enq_ro_re),
       .rf_rop_dp_enq_ro_waddr                             (i_hqm_sip_rf_rop_dp_enq_ro_waddr),
       .rf_rop_dp_enq_ro_wclk                              (i_hqm_sip_rf_rop_dp_enq_ro_wclk),
       .rf_rop_dp_enq_ro_wclk_rst_n                        (i_hqm_sip_rf_rop_dp_enq_ro_wclk_rst_n),
       .rf_rop_dp_enq_ro_wdata                             (i_hqm_sip_rf_rop_dp_enq_ro_wdata),
       .rf_rop_dp_enq_ro_we                                (i_hqm_sip_rf_rop_dp_enq_ro_we),
       .rf_rop_lsp_reordercmp_rx_sync_fifo_mem_raddr       (i_hqm_sip_rf_rop_lsp_reordercmp_rx_sync_fifo_mem_raddr),
       .rf_rop_lsp_reordercmp_rx_sync_fifo_mem_rclk        (i_hqm_sip_rf_rop_lsp_reordercmp_rx_sync_fifo_mem_rclk),
       .rf_rop_lsp_reordercmp_rx_sync_fifo_mem_rclk_rst_n  (i_hqm_sip_rf_rop_lsp_reordercmp_rx_sync_fifo_mem_rclk_rst_n),
       .rf_rop_lsp_reordercmp_rx_sync_fifo_mem_re          (i_hqm_sip_rf_rop_lsp_reordercmp_rx_sync_fifo_mem_re),
       .rf_rop_lsp_reordercmp_rx_sync_fifo_mem_waddr       (i_hqm_sip_rf_rop_lsp_reordercmp_rx_sync_fifo_mem_waddr),
       .rf_rop_lsp_reordercmp_rx_sync_fifo_mem_wclk        (i_hqm_sip_rf_rop_lsp_reordercmp_rx_sync_fifo_mem_wclk),
       .rf_rop_lsp_reordercmp_rx_sync_fifo_mem_wclk_rst_n  (i_hqm_sip_rf_rop_lsp_reordercmp_rx_sync_fifo_mem_wclk_rst_n),
       .rf_rop_lsp_reordercmp_rx_sync_fifo_mem_wdata       (i_hqm_sip_rf_rop_lsp_reordercmp_rx_sync_fifo_mem_wdata),
       .rf_rop_lsp_reordercmp_rx_sync_fifo_mem_we          (i_hqm_sip_rf_rop_lsp_reordercmp_rx_sync_fifo_mem_we),
       .rf_rop_nalb_enq_ro_raddr                           (i_hqm_sip_rf_rop_nalb_enq_ro_raddr),
       .rf_rop_nalb_enq_ro_rclk                            (i_hqm_sip_rf_rop_nalb_enq_ro_rclk),
       .rf_rop_nalb_enq_ro_rclk_rst_n                      (i_hqm_sip_rf_rop_nalb_enq_ro_rclk_rst_n),
       .rf_rop_nalb_enq_ro_re                              (i_hqm_sip_rf_rop_nalb_enq_ro_re),
       .rf_rop_nalb_enq_ro_waddr                           (i_hqm_sip_rf_rop_nalb_enq_ro_waddr),
       .rf_rop_nalb_enq_ro_wclk                            (i_hqm_sip_rf_rop_nalb_enq_ro_wclk),
       .rf_rop_nalb_enq_ro_wclk_rst_n                      (i_hqm_sip_rf_rop_nalb_enq_ro_wclk_rst_n),
       .rf_rop_nalb_enq_ro_wdata                           (i_hqm_sip_rf_rop_nalb_enq_ro_wdata),
       .rf_rop_nalb_enq_ro_we                              (i_hqm_sip_rf_rop_nalb_enq_ro_we),
       .rf_rop_nalb_enq_unoord_raddr                       (i_hqm_sip_rf_rop_nalb_enq_unoord_raddr),
       .rf_rop_nalb_enq_unoord_rclk                        (i_hqm_sip_rf_rop_nalb_enq_unoord_rclk),
       .rf_rop_nalb_enq_unoord_rclk_rst_n                  (i_hqm_sip_rf_rop_nalb_enq_unoord_rclk_rst_n),
       .rf_rop_nalb_enq_unoord_re                          (i_hqm_sip_rf_rop_nalb_enq_unoord_re),
       .rf_rop_nalb_enq_unoord_waddr                       (i_hqm_sip_rf_rop_nalb_enq_unoord_waddr),
       .rf_rop_nalb_enq_unoord_wclk                        (i_hqm_sip_rf_rop_nalb_enq_unoord_wclk),
       .rf_rop_nalb_enq_unoord_wclk_rst_n                  (i_hqm_sip_rf_rop_nalb_enq_unoord_wclk_rst_n),
       .rf_rop_nalb_enq_unoord_wdata                       (i_hqm_sip_rf_rop_nalb_enq_unoord_wdata),
       .rf_rop_nalb_enq_unoord_we                          (i_hqm_sip_rf_rop_nalb_enq_unoord_we),
       .rf_rx_sync_dp_dqed_data_raddr                      (i_hqm_sip_rf_rx_sync_dp_dqed_data_raddr),
       .rf_rx_sync_dp_dqed_data_rclk                       (i_hqm_sip_rf_rx_sync_dp_dqed_data_rclk),
       .rf_rx_sync_dp_dqed_data_rclk_rst_n                 (i_hqm_sip_rf_rx_sync_dp_dqed_data_rclk_rst_n),
       .rf_rx_sync_dp_dqed_data_re                         (i_hqm_sip_rf_rx_sync_dp_dqed_data_re),
       .rf_rx_sync_dp_dqed_data_waddr                      (i_hqm_sip_rf_rx_sync_dp_dqed_data_waddr),
       .rf_rx_sync_dp_dqed_data_wclk                       (i_hqm_sip_rf_rx_sync_dp_dqed_data_wclk),
       .rf_rx_sync_dp_dqed_data_wclk_rst_n                 (i_hqm_sip_rf_rx_sync_dp_dqed_data_wclk_rst_n),
       .rf_rx_sync_dp_dqed_data_wdata                      (i_hqm_sip_rf_rx_sync_dp_dqed_data_wdata),
       .rf_rx_sync_dp_dqed_data_we                         (i_hqm_sip_rf_rx_sync_dp_dqed_data_we),
       .rf_rx_sync_lsp_dp_sch_dir_raddr                    (i_hqm_sip_rf_rx_sync_lsp_dp_sch_dir_raddr),
       .rf_rx_sync_lsp_dp_sch_dir_rclk                     (i_hqm_sip_rf_rx_sync_lsp_dp_sch_dir_rclk),
       .rf_rx_sync_lsp_dp_sch_dir_rclk_rst_n               (i_hqm_sip_rf_rx_sync_lsp_dp_sch_dir_rclk_rst_n),
       .rf_rx_sync_lsp_dp_sch_dir_re                       (i_hqm_sip_rf_rx_sync_lsp_dp_sch_dir_re),
       .rf_rx_sync_lsp_dp_sch_dir_waddr                    (i_hqm_sip_rf_rx_sync_lsp_dp_sch_dir_waddr),
       .rf_rx_sync_lsp_dp_sch_dir_wclk                     (i_hqm_sip_rf_rx_sync_lsp_dp_sch_dir_wclk),
       .rf_rx_sync_lsp_dp_sch_dir_wclk_rst_n               (i_hqm_sip_rf_rx_sync_lsp_dp_sch_dir_wclk_rst_n),
       .rf_rx_sync_lsp_dp_sch_dir_wdata                    (i_hqm_sip_rf_rx_sync_lsp_dp_sch_dir_wdata),
       .rf_rx_sync_lsp_dp_sch_dir_we                       (i_hqm_sip_rf_rx_sync_lsp_dp_sch_dir_we),
       .rf_rx_sync_lsp_dp_sch_rorply_raddr                 (i_hqm_sip_rf_rx_sync_lsp_dp_sch_rorply_raddr),
       .rf_rx_sync_lsp_dp_sch_rorply_rclk                  (i_hqm_sip_rf_rx_sync_lsp_dp_sch_rorply_rclk),
       .rf_rx_sync_lsp_dp_sch_rorply_rclk_rst_n            (i_hqm_sip_rf_rx_sync_lsp_dp_sch_rorply_rclk_rst_n),
       .rf_rx_sync_lsp_dp_sch_rorply_re                    (i_hqm_sip_rf_rx_sync_lsp_dp_sch_rorply_re),
       .rf_rx_sync_lsp_dp_sch_rorply_waddr                 (i_hqm_sip_rf_rx_sync_lsp_dp_sch_rorply_waddr),
       .rf_rx_sync_lsp_dp_sch_rorply_wclk                  (i_hqm_sip_rf_rx_sync_lsp_dp_sch_rorply_wclk),
       .rf_rx_sync_lsp_dp_sch_rorply_wclk_rst_n            (i_hqm_sip_rf_rx_sync_lsp_dp_sch_rorply_wclk_rst_n),
       .rf_rx_sync_lsp_dp_sch_rorply_wdata                 (i_hqm_sip_rf_rx_sync_lsp_dp_sch_rorply_wdata),
       .rf_rx_sync_lsp_dp_sch_rorply_we                    (i_hqm_sip_rf_rx_sync_lsp_dp_sch_rorply_we),
       .rf_rx_sync_lsp_nalb_sch_atq_raddr                  (i_hqm_sip_rf_rx_sync_lsp_nalb_sch_atq_raddr),
       .rf_rx_sync_lsp_nalb_sch_atq_rclk                   (i_hqm_sip_rf_rx_sync_lsp_nalb_sch_atq_rclk),
       .rf_rx_sync_lsp_nalb_sch_atq_rclk_rst_n             (i_hqm_sip_rf_rx_sync_lsp_nalb_sch_atq_rclk_rst_n),
       .rf_rx_sync_lsp_nalb_sch_atq_re                     (i_hqm_sip_rf_rx_sync_lsp_nalb_sch_atq_re),
       .rf_rx_sync_lsp_nalb_sch_atq_waddr                  (i_hqm_sip_rf_rx_sync_lsp_nalb_sch_atq_waddr),
       .rf_rx_sync_lsp_nalb_sch_atq_wclk                   (i_hqm_sip_rf_rx_sync_lsp_nalb_sch_atq_wclk),
       .rf_rx_sync_lsp_nalb_sch_atq_wclk_rst_n             (i_hqm_sip_rf_rx_sync_lsp_nalb_sch_atq_wclk_rst_n),
       .rf_rx_sync_lsp_nalb_sch_atq_wdata                  (i_hqm_sip_rf_rx_sync_lsp_nalb_sch_atq_wdata),
       .rf_rx_sync_lsp_nalb_sch_atq_we                     (i_hqm_sip_rf_rx_sync_lsp_nalb_sch_atq_we),
       .rf_rx_sync_lsp_nalb_sch_rorply_raddr               (i_hqm_sip_rf_rx_sync_lsp_nalb_sch_rorply_raddr),
       .rf_rx_sync_lsp_nalb_sch_rorply_rclk                (i_hqm_sip_rf_rx_sync_lsp_nalb_sch_rorply_rclk),
       .rf_rx_sync_lsp_nalb_sch_rorply_rclk_rst_n          (i_hqm_sip_rf_rx_sync_lsp_nalb_sch_rorply_rclk_rst_n),
       .rf_rx_sync_lsp_nalb_sch_rorply_re                  (i_hqm_sip_rf_rx_sync_lsp_nalb_sch_rorply_re),
       .rf_rx_sync_lsp_nalb_sch_rorply_waddr               (i_hqm_sip_rf_rx_sync_lsp_nalb_sch_rorply_waddr),
       .rf_rx_sync_lsp_nalb_sch_rorply_wclk                (i_hqm_sip_rf_rx_sync_lsp_nalb_sch_rorply_wclk),
       .rf_rx_sync_lsp_nalb_sch_rorply_wclk_rst_n          (i_hqm_sip_rf_rx_sync_lsp_nalb_sch_rorply_wclk_rst_n),
       .rf_rx_sync_lsp_nalb_sch_rorply_wdata               (i_hqm_sip_rf_rx_sync_lsp_nalb_sch_rorply_wdata),
       .rf_rx_sync_lsp_nalb_sch_rorply_we                  (i_hqm_sip_rf_rx_sync_lsp_nalb_sch_rorply_we),
       .rf_rx_sync_lsp_nalb_sch_unoord_raddr               (i_hqm_sip_rf_rx_sync_lsp_nalb_sch_unoord_raddr),
       .rf_rx_sync_lsp_nalb_sch_unoord_rclk                (i_hqm_sip_rf_rx_sync_lsp_nalb_sch_unoord_rclk),
       .rf_rx_sync_lsp_nalb_sch_unoord_rclk_rst_n          (i_hqm_sip_rf_rx_sync_lsp_nalb_sch_unoord_rclk_rst_n),
       .rf_rx_sync_lsp_nalb_sch_unoord_re                  (i_hqm_sip_rf_rx_sync_lsp_nalb_sch_unoord_re),
       .rf_rx_sync_lsp_nalb_sch_unoord_waddr               (i_hqm_sip_rf_rx_sync_lsp_nalb_sch_unoord_waddr),
       .rf_rx_sync_lsp_nalb_sch_unoord_wclk                (i_hqm_sip_rf_rx_sync_lsp_nalb_sch_unoord_wclk),
       .rf_rx_sync_lsp_nalb_sch_unoord_wclk_rst_n          (i_hqm_sip_rf_rx_sync_lsp_nalb_sch_unoord_wclk_rst_n),
       .rf_rx_sync_lsp_nalb_sch_unoord_wdata               (i_hqm_sip_rf_rx_sync_lsp_nalb_sch_unoord_wdata),
       .rf_rx_sync_lsp_nalb_sch_unoord_we                  (i_hqm_sip_rf_rx_sync_lsp_nalb_sch_unoord_we),
       .rf_rx_sync_nalb_qed_data_raddr                     (i_hqm_sip_rf_rx_sync_nalb_qed_data_raddr),
       .rf_rx_sync_nalb_qed_data_rclk                      (i_hqm_sip_rf_rx_sync_nalb_qed_data_rclk),
       .rf_rx_sync_nalb_qed_data_rclk_rst_n                (i_hqm_sip_rf_rx_sync_nalb_qed_data_rclk_rst_n),
       .rf_rx_sync_nalb_qed_data_re                        (i_hqm_sip_rf_rx_sync_nalb_qed_data_re),
       .rf_rx_sync_nalb_qed_data_waddr                     (i_hqm_sip_rf_rx_sync_nalb_qed_data_waddr),
       .rf_rx_sync_nalb_qed_data_wclk                      (i_hqm_sip_rf_rx_sync_nalb_qed_data_wclk),
       .rf_rx_sync_nalb_qed_data_wclk_rst_n                (i_hqm_sip_rf_rx_sync_nalb_qed_data_wclk_rst_n),
       .rf_rx_sync_nalb_qed_data_wdata                     (i_hqm_sip_rf_rx_sync_nalb_qed_data_wdata),
       .rf_rx_sync_nalb_qed_data_we                        (i_hqm_sip_rf_rx_sync_nalb_qed_data_we),
       .rf_rx_sync_qed_aqed_enq_raddr                      (i_hqm_sip_rf_rx_sync_qed_aqed_enq_raddr),
       .rf_rx_sync_qed_aqed_enq_rclk                       (i_hqm_sip_rf_rx_sync_qed_aqed_enq_rclk),
       .rf_rx_sync_qed_aqed_enq_rclk_rst_n                 (i_hqm_sip_rf_rx_sync_qed_aqed_enq_rclk_rst_n),
       .rf_rx_sync_qed_aqed_enq_re                         (i_hqm_sip_rf_rx_sync_qed_aqed_enq_re),
       .rf_rx_sync_qed_aqed_enq_waddr                      (i_hqm_sip_rf_rx_sync_qed_aqed_enq_waddr),
       .rf_rx_sync_qed_aqed_enq_wclk                       (i_hqm_sip_rf_rx_sync_qed_aqed_enq_wclk),
       .rf_rx_sync_qed_aqed_enq_wclk_rst_n                 (i_hqm_sip_rf_rx_sync_qed_aqed_enq_wclk_rst_n),
       .rf_rx_sync_qed_aqed_enq_wdata                      (i_hqm_sip_rf_rx_sync_qed_aqed_enq_wdata),
       .rf_rx_sync_qed_aqed_enq_we                         (i_hqm_sip_rf_rx_sync_qed_aqed_enq_we),
       .rf_rx_sync_rop_dp_enq_raddr                        (i_hqm_sip_rf_rx_sync_rop_dp_enq_raddr),
       .rf_rx_sync_rop_dp_enq_rclk                         (i_hqm_sip_rf_rx_sync_rop_dp_enq_rclk),
       .rf_rx_sync_rop_dp_enq_rclk_rst_n                   (i_hqm_sip_rf_rx_sync_rop_dp_enq_rclk_rst_n),
       .rf_rx_sync_rop_dp_enq_re                           (i_hqm_sip_rf_rx_sync_rop_dp_enq_re),
       .rf_rx_sync_rop_dp_enq_waddr                        (i_hqm_sip_rf_rx_sync_rop_dp_enq_waddr),
       .rf_rx_sync_rop_dp_enq_wclk                         (i_hqm_sip_rf_rx_sync_rop_dp_enq_wclk),
       .rf_rx_sync_rop_dp_enq_wclk_rst_n                   (i_hqm_sip_rf_rx_sync_rop_dp_enq_wclk_rst_n),
       .rf_rx_sync_rop_dp_enq_wdata                        (i_hqm_sip_rf_rx_sync_rop_dp_enq_wdata),
       .rf_rx_sync_rop_dp_enq_we                           (i_hqm_sip_rf_rx_sync_rop_dp_enq_we),
       .rf_rx_sync_rop_nalb_enq_raddr                      (i_hqm_sip_rf_rx_sync_rop_nalb_enq_raddr),
       .rf_rx_sync_rop_nalb_enq_rclk                       (i_hqm_sip_rf_rx_sync_rop_nalb_enq_rclk),
       .rf_rx_sync_rop_nalb_enq_rclk_rst_n                 (i_hqm_sip_rf_rx_sync_rop_nalb_enq_rclk_rst_n),
       .rf_rx_sync_rop_nalb_enq_re                         (i_hqm_sip_rf_rx_sync_rop_nalb_enq_re),
       .rf_rx_sync_rop_nalb_enq_waddr                      (i_hqm_sip_rf_rx_sync_rop_nalb_enq_waddr),
       .rf_rx_sync_rop_nalb_enq_wclk                       (i_hqm_sip_rf_rx_sync_rop_nalb_enq_wclk),
       .rf_rx_sync_rop_nalb_enq_wclk_rst_n                 (i_hqm_sip_rf_rx_sync_rop_nalb_enq_wclk_rst_n),
       .rf_rx_sync_rop_nalb_enq_wdata                      (i_hqm_sip_rf_rx_sync_rop_nalb_enq_wdata),
       .rf_rx_sync_rop_nalb_enq_we                         (i_hqm_sip_rf_rx_sync_rop_nalb_enq_we),
       .rf_rx_sync_rop_qed_dqed_enq_raddr                  (i_hqm_sip_rf_rx_sync_rop_qed_dqed_enq_raddr),
       .rf_rx_sync_rop_qed_dqed_enq_rclk                   (i_hqm_sip_rf_rx_sync_rop_qed_dqed_enq_rclk),
       .rf_rx_sync_rop_qed_dqed_enq_rclk_rst_n             (i_hqm_sip_rf_rx_sync_rop_qed_dqed_enq_rclk_rst_n),
       .rf_rx_sync_rop_qed_dqed_enq_re                     (i_hqm_sip_rf_rx_sync_rop_qed_dqed_enq_re),
       .rf_rx_sync_rop_qed_dqed_enq_waddr                  (i_hqm_sip_rf_rx_sync_rop_qed_dqed_enq_waddr),
       .rf_rx_sync_rop_qed_dqed_enq_wclk                   (i_hqm_sip_rf_rx_sync_rop_qed_dqed_enq_wclk),
       .rf_rx_sync_rop_qed_dqed_enq_wclk_rst_n             (i_hqm_sip_rf_rx_sync_rop_qed_dqed_enq_wclk_rst_n),
       .rf_rx_sync_rop_qed_dqed_enq_wdata                  (i_hqm_sip_rf_rx_sync_rop_qed_dqed_enq_wdata),
       .rf_rx_sync_rop_qed_dqed_enq_we                     (i_hqm_sip_rf_rx_sync_rop_qed_dqed_enq_we),
       .rf_sch_out_fifo_raddr                              (i_hqm_sip_rf_sch_out_fifo_raddr),
       .rf_sch_out_fifo_rclk                               (i_hqm_sip_rf_sch_out_fifo_rclk),
       .rf_sch_out_fifo_rclk_rst_n                         (i_hqm_sip_rf_sch_out_fifo_rclk_rst_n),
       .rf_sch_out_fifo_re                                 (i_hqm_sip_rf_sch_out_fifo_re),
       .rf_sch_out_fifo_waddr                              (i_hqm_sip_rf_sch_out_fifo_waddr),
       .rf_sch_out_fifo_wclk                               (i_hqm_sip_rf_sch_out_fifo_wclk),
       .rf_sch_out_fifo_wclk_rst_n                         (i_hqm_sip_rf_sch_out_fifo_wclk_rst_n),
       .rf_sch_out_fifo_wdata                              (i_hqm_sip_rf_sch_out_fifo_wdata),
       .rf_sch_out_fifo_we                                 (i_hqm_sip_rf_sch_out_fifo_we),
       .rf_scrbd_mem_raddr                                 (i_hqm_sip_rf_scrbd_mem_raddr),
       .rf_scrbd_mem_rclk                                  (i_hqm_sip_rf_scrbd_mem_rclk),
       .rf_scrbd_mem_rclk_rst_n                            (i_hqm_sip_rf_scrbd_mem_rclk_rst_n),
       .rf_scrbd_mem_re                                    (i_hqm_sip_rf_scrbd_mem_re),
       .rf_scrbd_mem_waddr                                 (i_hqm_sip_rf_scrbd_mem_waddr),
       .rf_scrbd_mem_wclk                                  (i_hqm_sip_rf_scrbd_mem_wclk),
       .rf_scrbd_mem_wclk_rst_n                            (i_hqm_sip_rf_scrbd_mem_wclk_rst_n),
       .rf_scrbd_mem_wdata                                 (i_hqm_sip_rf_scrbd_mem_wdata),
       .rf_scrbd_mem_we                                    (i_hqm_sip_rf_scrbd_mem_we),
       .rf_send_atm_to_cq_rx_sync_fifo_mem_raddr           (i_hqm_sip_rf_send_atm_to_cq_rx_sync_fifo_mem_raddr),
       .rf_send_atm_to_cq_rx_sync_fifo_mem_rclk            (i_hqm_sip_rf_send_atm_to_cq_rx_sync_fifo_mem_rclk),
       .rf_send_atm_to_cq_rx_sync_fifo_mem_rclk_rst_n      (i_hqm_sip_rf_send_atm_to_cq_rx_sync_fifo_mem_rclk_rst_n),
       .rf_send_atm_to_cq_rx_sync_fifo_mem_re              (i_hqm_sip_rf_send_atm_to_cq_rx_sync_fifo_mem_re),
       .rf_send_atm_to_cq_rx_sync_fifo_mem_waddr           (i_hqm_sip_rf_send_atm_to_cq_rx_sync_fifo_mem_waddr),
       .rf_send_atm_to_cq_rx_sync_fifo_mem_wclk            (i_hqm_sip_rf_send_atm_to_cq_rx_sync_fifo_mem_wclk),
       .rf_send_atm_to_cq_rx_sync_fifo_mem_wclk_rst_n      (i_hqm_sip_rf_send_atm_to_cq_rx_sync_fifo_mem_wclk_rst_n),
       .rf_send_atm_to_cq_rx_sync_fifo_mem_wdata           (i_hqm_sip_rf_send_atm_to_cq_rx_sync_fifo_mem_wdata),
       .rf_send_atm_to_cq_rx_sync_fifo_mem_we              (i_hqm_sip_rf_send_atm_to_cq_rx_sync_fifo_mem_we),
       .rf_sn0_order_shft_mem_raddr                        (i_hqm_sip_rf_sn0_order_shft_mem_raddr),
       .rf_sn0_order_shft_mem_rclk                         (i_hqm_sip_rf_sn0_order_shft_mem_rclk),
       .rf_sn0_order_shft_mem_rclk_rst_n                   (i_hqm_sip_rf_sn0_order_shft_mem_rclk_rst_n),
       .rf_sn0_order_shft_mem_re                           (i_hqm_sip_rf_sn0_order_shft_mem_re),
       .rf_sn0_order_shft_mem_waddr                        (i_hqm_sip_rf_sn0_order_shft_mem_waddr),
       .rf_sn0_order_shft_mem_wclk                         (i_hqm_sip_rf_sn0_order_shft_mem_wclk),
       .rf_sn0_order_shft_mem_wclk_rst_n                   (i_hqm_sip_rf_sn0_order_shft_mem_wclk_rst_n),
       .rf_sn0_order_shft_mem_wdata                        (i_hqm_sip_rf_sn0_order_shft_mem_wdata),
       .rf_sn0_order_shft_mem_we                           (i_hqm_sip_rf_sn0_order_shft_mem_we),
       .rf_sn1_order_shft_mem_raddr                        (i_hqm_sip_rf_sn1_order_shft_mem_raddr),
       .rf_sn1_order_shft_mem_rclk                         (i_hqm_sip_rf_sn1_order_shft_mem_rclk),
       .rf_sn1_order_shft_mem_rclk_rst_n                   (i_hqm_sip_rf_sn1_order_shft_mem_rclk_rst_n),
       .rf_sn1_order_shft_mem_re                           (i_hqm_sip_rf_sn1_order_shft_mem_re),
       .rf_sn1_order_shft_mem_waddr                        (i_hqm_sip_rf_sn1_order_shft_mem_waddr),
       .rf_sn1_order_shft_mem_wclk                         (i_hqm_sip_rf_sn1_order_shft_mem_wclk),
       .rf_sn1_order_shft_mem_wclk_rst_n                   (i_hqm_sip_rf_sn1_order_shft_mem_wclk_rst_n),
       .rf_sn1_order_shft_mem_wdata                        (i_hqm_sip_rf_sn1_order_shft_mem_wdata),
       .rf_sn1_order_shft_mem_we                           (i_hqm_sip_rf_sn1_order_shft_mem_we),
       .rf_sn_complete_fifo_mem_raddr                      (i_hqm_sip_rf_sn_complete_fifo_mem_raddr),
       .rf_sn_complete_fifo_mem_rclk                       (i_hqm_sip_rf_sn_complete_fifo_mem_rclk),
       .rf_sn_complete_fifo_mem_rclk_rst_n                 (i_hqm_sip_rf_sn_complete_fifo_mem_rclk_rst_n),
       .rf_sn_complete_fifo_mem_re                         (i_hqm_sip_rf_sn_complete_fifo_mem_re),
       .rf_sn_complete_fifo_mem_waddr                      (i_hqm_sip_rf_sn_complete_fifo_mem_waddr),
       .rf_sn_complete_fifo_mem_wclk                       (i_hqm_sip_rf_sn_complete_fifo_mem_wclk),
       .rf_sn_complete_fifo_mem_wclk_rst_n                 (i_hqm_sip_rf_sn_complete_fifo_mem_wclk_rst_n),
       .rf_sn_complete_fifo_mem_wdata                      (i_hqm_sip_rf_sn_complete_fifo_mem_wdata),
       .rf_sn_complete_fifo_mem_we                         (i_hqm_sip_rf_sn_complete_fifo_mem_we),
       .rf_sn_ordered_fifo_mem_raddr                       (i_hqm_sip_rf_sn_ordered_fifo_mem_raddr),
       .rf_sn_ordered_fifo_mem_rclk                        (i_hqm_sip_rf_sn_ordered_fifo_mem_rclk),
       .rf_sn_ordered_fifo_mem_rclk_rst_n                  (i_hqm_sip_rf_sn_ordered_fifo_mem_rclk_rst_n),
       .rf_sn_ordered_fifo_mem_re                          (i_hqm_sip_rf_sn_ordered_fifo_mem_re),
       .rf_sn_ordered_fifo_mem_waddr                       (i_hqm_sip_rf_sn_ordered_fifo_mem_waddr),
       .rf_sn_ordered_fifo_mem_wclk                        (i_hqm_sip_rf_sn_ordered_fifo_mem_wclk),
       .rf_sn_ordered_fifo_mem_wclk_rst_n                  (i_hqm_sip_rf_sn_ordered_fifo_mem_wclk_rst_n),
       .rf_sn_ordered_fifo_mem_wdata                       (i_hqm_sip_rf_sn_ordered_fifo_mem_wdata),
       .rf_sn_ordered_fifo_mem_we                          (i_hqm_sip_rf_sn_ordered_fifo_mem_we),
       .rf_threshold_r_pipe_dir_mem_raddr                  (i_hqm_sip_rf_threshold_r_pipe_dir_mem_raddr),
       .rf_threshold_r_pipe_dir_mem_rclk                   (i_hqm_sip_rf_threshold_r_pipe_dir_mem_rclk),
       .rf_threshold_r_pipe_dir_mem_rclk_rst_n             (i_hqm_sip_rf_threshold_r_pipe_dir_mem_rclk_rst_n),
       .rf_threshold_r_pipe_dir_mem_re                     (i_hqm_sip_rf_threshold_r_pipe_dir_mem_re),
       .rf_threshold_r_pipe_dir_mem_waddr                  (i_hqm_sip_rf_threshold_r_pipe_dir_mem_waddr),
       .rf_threshold_r_pipe_dir_mem_wclk                   (i_hqm_sip_rf_threshold_r_pipe_dir_mem_wclk),
       .rf_threshold_r_pipe_dir_mem_wclk_rst_n             (i_hqm_sip_rf_threshold_r_pipe_dir_mem_wclk_rst_n),
       .rf_threshold_r_pipe_dir_mem_wdata                  (i_hqm_sip_rf_threshold_r_pipe_dir_mem_wdata),
       .rf_threshold_r_pipe_dir_mem_we                     (i_hqm_sip_rf_threshold_r_pipe_dir_mem_we),
       .rf_threshold_r_pipe_ldb_mem_raddr                  (i_hqm_sip_rf_threshold_r_pipe_ldb_mem_raddr),
       .rf_threshold_r_pipe_ldb_mem_rclk                   (i_hqm_sip_rf_threshold_r_pipe_ldb_mem_rclk),
       .rf_threshold_r_pipe_ldb_mem_rclk_rst_n             (i_hqm_sip_rf_threshold_r_pipe_ldb_mem_rclk_rst_n),
       .rf_threshold_r_pipe_ldb_mem_re                     (i_hqm_sip_rf_threshold_r_pipe_ldb_mem_re),
       .rf_threshold_r_pipe_ldb_mem_waddr                  (i_hqm_sip_rf_threshold_r_pipe_ldb_mem_waddr),
       .rf_threshold_r_pipe_ldb_mem_wclk                   (i_hqm_sip_rf_threshold_r_pipe_ldb_mem_wclk),
       .rf_threshold_r_pipe_ldb_mem_wclk_rst_n             (i_hqm_sip_rf_threshold_r_pipe_ldb_mem_wclk_rst_n),
       .rf_threshold_r_pipe_ldb_mem_wdata                  (i_hqm_sip_rf_threshold_r_pipe_ldb_mem_wdata),
       .rf_threshold_r_pipe_ldb_mem_we                     (i_hqm_sip_rf_threshold_r_pipe_ldb_mem_we),
       .rf_tlb_data0_4k_raddr                              (i_hqm_sip_rf_tlb_data0_4k_raddr),
       .rf_tlb_data0_4k_rclk                               (i_hqm_sip_rf_tlb_data0_4k_rclk),
       .rf_tlb_data0_4k_rclk_rst_n                         (i_hqm_sip_rf_tlb_data0_4k_rclk_rst_n),
       .rf_tlb_data0_4k_re                                 (i_hqm_sip_rf_tlb_data0_4k_re),
       .rf_tlb_data0_4k_waddr                              (i_hqm_sip_rf_tlb_data0_4k_waddr),
       .rf_tlb_data0_4k_wclk                               (i_hqm_sip_rf_tlb_data0_4k_wclk),
       .rf_tlb_data0_4k_wclk_rst_n                         (i_hqm_sip_rf_tlb_data0_4k_wclk_rst_n),
       .rf_tlb_data0_4k_wdata                              (i_hqm_sip_rf_tlb_data0_4k_wdata),
       .rf_tlb_data0_4k_we                                 (i_hqm_sip_rf_tlb_data0_4k_we),
       .rf_tlb_data1_4k_raddr                              (i_hqm_sip_rf_tlb_data1_4k_raddr),
       .rf_tlb_data1_4k_rclk                               (i_hqm_sip_rf_tlb_data1_4k_rclk),
       .rf_tlb_data1_4k_rclk_rst_n                         (i_hqm_sip_rf_tlb_data1_4k_rclk_rst_n),
       .rf_tlb_data1_4k_re                                 (i_hqm_sip_rf_tlb_data1_4k_re),
       .rf_tlb_data1_4k_waddr                              (i_hqm_sip_rf_tlb_data1_4k_waddr),
       .rf_tlb_data1_4k_wclk                               (i_hqm_sip_rf_tlb_data1_4k_wclk),
       .rf_tlb_data1_4k_wclk_rst_n                         (i_hqm_sip_rf_tlb_data1_4k_wclk_rst_n),
       .rf_tlb_data1_4k_wdata                              (i_hqm_sip_rf_tlb_data1_4k_wdata),
       .rf_tlb_data1_4k_we                                 (i_hqm_sip_rf_tlb_data1_4k_we),
       .rf_tlb_data2_4k_raddr                              (i_hqm_sip_rf_tlb_data2_4k_raddr),
       .rf_tlb_data2_4k_rclk                               (i_hqm_sip_rf_tlb_data2_4k_rclk),
       .rf_tlb_data2_4k_rclk_rst_n                         (i_hqm_sip_rf_tlb_data2_4k_rclk_rst_n),
       .rf_tlb_data2_4k_re                                 (i_hqm_sip_rf_tlb_data2_4k_re),
       .rf_tlb_data2_4k_waddr                              (i_hqm_sip_rf_tlb_data2_4k_waddr),
       .rf_tlb_data2_4k_wclk                               (i_hqm_sip_rf_tlb_data2_4k_wclk),
       .rf_tlb_data2_4k_wclk_rst_n                         (i_hqm_sip_rf_tlb_data2_4k_wclk_rst_n),
       .rf_tlb_data2_4k_wdata                              (i_hqm_sip_rf_tlb_data2_4k_wdata),
       .rf_tlb_data2_4k_we                                 (i_hqm_sip_rf_tlb_data2_4k_we),
       .rf_tlb_data3_4k_raddr                              (i_hqm_sip_rf_tlb_data3_4k_raddr),
       .rf_tlb_data3_4k_rclk                               (i_hqm_sip_rf_tlb_data3_4k_rclk),
       .rf_tlb_data3_4k_rclk_rst_n                         (i_hqm_sip_rf_tlb_data3_4k_rclk_rst_n),
       .rf_tlb_data3_4k_re                                 (i_hqm_sip_rf_tlb_data3_4k_re),
       .rf_tlb_data3_4k_waddr                              (i_hqm_sip_rf_tlb_data3_4k_waddr),
       .rf_tlb_data3_4k_wclk                               (i_hqm_sip_rf_tlb_data3_4k_wclk),
       .rf_tlb_data3_4k_wclk_rst_n                         (i_hqm_sip_rf_tlb_data3_4k_wclk_rst_n),
       .rf_tlb_data3_4k_wdata                              (i_hqm_sip_rf_tlb_data3_4k_wdata),
       .rf_tlb_data3_4k_we                                 (i_hqm_sip_rf_tlb_data3_4k_we),
       .rf_tlb_data4_4k_raddr                              (i_hqm_sip_rf_tlb_data4_4k_raddr),
       .rf_tlb_data4_4k_rclk                               (i_hqm_sip_rf_tlb_data4_4k_rclk),
       .rf_tlb_data4_4k_rclk_rst_n                         (i_hqm_sip_rf_tlb_data4_4k_rclk_rst_n),
       .rf_tlb_data4_4k_re                                 (i_hqm_sip_rf_tlb_data4_4k_re),
       .rf_tlb_data4_4k_waddr                              (i_hqm_sip_rf_tlb_data4_4k_waddr),
       .rf_tlb_data4_4k_wclk                               (i_hqm_sip_rf_tlb_data4_4k_wclk),
       .rf_tlb_data4_4k_wclk_rst_n                         (i_hqm_sip_rf_tlb_data4_4k_wclk_rst_n),
       .rf_tlb_data4_4k_wdata                              (i_hqm_sip_rf_tlb_data4_4k_wdata),
       .rf_tlb_data4_4k_we                                 (i_hqm_sip_rf_tlb_data4_4k_we),
       .rf_tlb_data5_4k_raddr                              (i_hqm_sip_rf_tlb_data5_4k_raddr),
       .rf_tlb_data5_4k_rclk                               (i_hqm_sip_rf_tlb_data5_4k_rclk),
       .rf_tlb_data5_4k_rclk_rst_n                         (i_hqm_sip_rf_tlb_data5_4k_rclk_rst_n),
       .rf_tlb_data5_4k_re                                 (i_hqm_sip_rf_tlb_data5_4k_re),
       .rf_tlb_data5_4k_waddr                              (i_hqm_sip_rf_tlb_data5_4k_waddr),
       .rf_tlb_data5_4k_wclk                               (i_hqm_sip_rf_tlb_data5_4k_wclk),
       .rf_tlb_data5_4k_wclk_rst_n                         (i_hqm_sip_rf_tlb_data5_4k_wclk_rst_n),
       .rf_tlb_data5_4k_wdata                              (i_hqm_sip_rf_tlb_data5_4k_wdata),
       .rf_tlb_data5_4k_we                                 (i_hqm_sip_rf_tlb_data5_4k_we),
       .rf_tlb_data6_4k_raddr                              (i_hqm_sip_rf_tlb_data6_4k_raddr),
       .rf_tlb_data6_4k_rclk                               (i_hqm_sip_rf_tlb_data6_4k_rclk),
       .rf_tlb_data6_4k_rclk_rst_n                         (i_hqm_sip_rf_tlb_data6_4k_rclk_rst_n),
       .rf_tlb_data6_4k_re                                 (i_hqm_sip_rf_tlb_data6_4k_re),
       .rf_tlb_data6_4k_waddr                              (i_hqm_sip_rf_tlb_data6_4k_waddr),
       .rf_tlb_data6_4k_wclk                               (i_hqm_sip_rf_tlb_data6_4k_wclk),
       .rf_tlb_data6_4k_wclk_rst_n                         (i_hqm_sip_rf_tlb_data6_4k_wclk_rst_n),
       .rf_tlb_data6_4k_wdata                              (i_hqm_sip_rf_tlb_data6_4k_wdata),
       .rf_tlb_data6_4k_we                                 (i_hqm_sip_rf_tlb_data6_4k_we),
       .rf_tlb_data7_4k_raddr                              (i_hqm_sip_rf_tlb_data7_4k_raddr),
       .rf_tlb_data7_4k_rclk                               (i_hqm_sip_rf_tlb_data7_4k_rclk),
       .rf_tlb_data7_4k_rclk_rst_n                         (i_hqm_sip_rf_tlb_data7_4k_rclk_rst_n),
       .rf_tlb_data7_4k_re                                 (i_hqm_sip_rf_tlb_data7_4k_re),
       .rf_tlb_data7_4k_waddr                              (i_hqm_sip_rf_tlb_data7_4k_waddr),
       .rf_tlb_data7_4k_wclk                               (i_hqm_sip_rf_tlb_data7_4k_wclk),
       .rf_tlb_data7_4k_wclk_rst_n                         (i_hqm_sip_rf_tlb_data7_4k_wclk_rst_n),
       .rf_tlb_data7_4k_wdata                              (i_hqm_sip_rf_tlb_data7_4k_wdata),
       .rf_tlb_data7_4k_we                                 (i_hqm_sip_rf_tlb_data7_4k_we),
       .rf_tlb_tag0_4k_raddr                               (i_hqm_sip_rf_tlb_tag0_4k_raddr),
       .rf_tlb_tag0_4k_rclk                                (i_hqm_sip_rf_tlb_tag0_4k_rclk),
       .rf_tlb_tag0_4k_rclk_rst_n                          (i_hqm_sip_rf_tlb_tag0_4k_rclk_rst_n),
       .rf_tlb_tag0_4k_re                                  (i_hqm_sip_rf_tlb_tag0_4k_re),
       .rf_tlb_tag0_4k_waddr                               (i_hqm_sip_rf_tlb_tag0_4k_waddr),
       .rf_tlb_tag0_4k_wclk                                (i_hqm_sip_rf_tlb_tag0_4k_wclk),
       .rf_tlb_tag0_4k_wclk_rst_n                          (i_hqm_sip_rf_tlb_tag0_4k_wclk_rst_n),
       .rf_tlb_tag0_4k_wdata                               (i_hqm_sip_rf_tlb_tag0_4k_wdata),
       .rf_tlb_tag0_4k_we                                  (i_hqm_sip_rf_tlb_tag0_4k_we),
       .rf_tlb_tag1_4k_raddr                               (i_hqm_sip_rf_tlb_tag1_4k_raddr),
       .rf_tlb_tag1_4k_rclk                                (i_hqm_sip_rf_tlb_tag1_4k_rclk),
       .rf_tlb_tag1_4k_rclk_rst_n                          (i_hqm_sip_rf_tlb_tag1_4k_rclk_rst_n),
       .rf_tlb_tag1_4k_re                                  (i_hqm_sip_rf_tlb_tag1_4k_re),
       .rf_tlb_tag1_4k_waddr                               (i_hqm_sip_rf_tlb_tag1_4k_waddr),
       .rf_tlb_tag1_4k_wclk                                (i_hqm_sip_rf_tlb_tag1_4k_wclk),
       .rf_tlb_tag1_4k_wclk_rst_n                          (i_hqm_sip_rf_tlb_tag1_4k_wclk_rst_n),
       .rf_tlb_tag1_4k_wdata                               (i_hqm_sip_rf_tlb_tag1_4k_wdata),
       .rf_tlb_tag1_4k_we                                  (i_hqm_sip_rf_tlb_tag1_4k_we),
       .rf_tlb_tag2_4k_raddr                               (i_hqm_sip_rf_tlb_tag2_4k_raddr),
       .rf_tlb_tag2_4k_rclk                                (i_hqm_sip_rf_tlb_tag2_4k_rclk),
       .rf_tlb_tag2_4k_rclk_rst_n                          (i_hqm_sip_rf_tlb_tag2_4k_rclk_rst_n),
       .rf_tlb_tag2_4k_re                                  (i_hqm_sip_rf_tlb_tag2_4k_re),
       .rf_tlb_tag2_4k_waddr                               (i_hqm_sip_rf_tlb_tag2_4k_waddr),
       .rf_tlb_tag2_4k_wclk                                (i_hqm_sip_rf_tlb_tag2_4k_wclk),
       .rf_tlb_tag2_4k_wclk_rst_n                          (i_hqm_sip_rf_tlb_tag2_4k_wclk_rst_n),
       .rf_tlb_tag2_4k_wdata                               (i_hqm_sip_rf_tlb_tag2_4k_wdata),
       .rf_tlb_tag2_4k_we                                  (i_hqm_sip_rf_tlb_tag2_4k_we),
       .rf_tlb_tag3_4k_raddr                               (i_hqm_sip_rf_tlb_tag3_4k_raddr),
       .rf_tlb_tag3_4k_rclk                                (i_hqm_sip_rf_tlb_tag3_4k_rclk),
       .rf_tlb_tag3_4k_rclk_rst_n                          (i_hqm_sip_rf_tlb_tag3_4k_rclk_rst_n),
       .rf_tlb_tag3_4k_re                                  (i_hqm_sip_rf_tlb_tag3_4k_re),
       .rf_tlb_tag3_4k_waddr                               (i_hqm_sip_rf_tlb_tag3_4k_waddr),
       .rf_tlb_tag3_4k_wclk                                (i_hqm_sip_rf_tlb_tag3_4k_wclk),
       .rf_tlb_tag3_4k_wclk_rst_n                          (i_hqm_sip_rf_tlb_tag3_4k_wclk_rst_n),
       .rf_tlb_tag3_4k_wdata                               (i_hqm_sip_rf_tlb_tag3_4k_wdata),
       .rf_tlb_tag3_4k_we                                  (i_hqm_sip_rf_tlb_tag3_4k_we),
       .rf_tlb_tag4_4k_raddr                               (i_hqm_sip_rf_tlb_tag4_4k_raddr),
       .rf_tlb_tag4_4k_rclk                                (i_hqm_sip_rf_tlb_tag4_4k_rclk),
       .rf_tlb_tag4_4k_rclk_rst_n                          (i_hqm_sip_rf_tlb_tag4_4k_rclk_rst_n),
       .rf_tlb_tag4_4k_re                                  (i_hqm_sip_rf_tlb_tag4_4k_re),
       .rf_tlb_tag4_4k_waddr                               (i_hqm_sip_rf_tlb_tag4_4k_waddr),
       .rf_tlb_tag4_4k_wclk                                (i_hqm_sip_rf_tlb_tag4_4k_wclk),
       .rf_tlb_tag4_4k_wclk_rst_n                          (i_hqm_sip_rf_tlb_tag4_4k_wclk_rst_n),
       .rf_tlb_tag4_4k_wdata                               (i_hqm_sip_rf_tlb_tag4_4k_wdata),
       .rf_tlb_tag4_4k_we                                  (i_hqm_sip_rf_tlb_tag4_4k_we),
       .rf_tlb_tag5_4k_raddr                               (i_hqm_sip_rf_tlb_tag5_4k_raddr),
       .rf_tlb_tag5_4k_rclk                                (i_hqm_sip_rf_tlb_tag5_4k_rclk),
       .rf_tlb_tag5_4k_rclk_rst_n                          (i_hqm_sip_rf_tlb_tag5_4k_rclk_rst_n),
       .rf_tlb_tag5_4k_re                                  (i_hqm_sip_rf_tlb_tag5_4k_re),
       .rf_tlb_tag5_4k_waddr                               (i_hqm_sip_rf_tlb_tag5_4k_waddr),
       .rf_tlb_tag5_4k_wclk                                (i_hqm_sip_rf_tlb_tag5_4k_wclk),
       .rf_tlb_tag5_4k_wclk_rst_n                          (i_hqm_sip_rf_tlb_tag5_4k_wclk_rst_n),
       .rf_tlb_tag5_4k_wdata                               (i_hqm_sip_rf_tlb_tag5_4k_wdata),
       .rf_tlb_tag5_4k_we                                  (i_hqm_sip_rf_tlb_tag5_4k_we),
       .rf_tlb_tag6_4k_raddr                               (i_hqm_sip_rf_tlb_tag6_4k_raddr),
       .rf_tlb_tag6_4k_rclk                                (i_hqm_sip_rf_tlb_tag6_4k_rclk),
       .rf_tlb_tag6_4k_rclk_rst_n                          (i_hqm_sip_rf_tlb_tag6_4k_rclk_rst_n),
       .rf_tlb_tag6_4k_re                                  (i_hqm_sip_rf_tlb_tag6_4k_re),
       .rf_tlb_tag6_4k_waddr                               (i_hqm_sip_rf_tlb_tag6_4k_waddr),
       .rf_tlb_tag6_4k_wclk                                (i_hqm_sip_rf_tlb_tag6_4k_wclk),
       .rf_tlb_tag6_4k_wclk_rst_n                          (i_hqm_sip_rf_tlb_tag6_4k_wclk_rst_n),
       .rf_tlb_tag6_4k_wdata                               (i_hqm_sip_rf_tlb_tag6_4k_wdata),
       .rf_tlb_tag6_4k_we                                  (i_hqm_sip_rf_tlb_tag6_4k_we),
       .rf_tlb_tag7_4k_raddr                               (i_hqm_sip_rf_tlb_tag7_4k_raddr),
       .rf_tlb_tag7_4k_rclk                                (i_hqm_sip_rf_tlb_tag7_4k_rclk),
       .rf_tlb_tag7_4k_rclk_rst_n                          (i_hqm_sip_rf_tlb_tag7_4k_rclk_rst_n),
       .rf_tlb_tag7_4k_re                                  (i_hqm_sip_rf_tlb_tag7_4k_re),
       .rf_tlb_tag7_4k_waddr                               (i_hqm_sip_rf_tlb_tag7_4k_waddr),
       .rf_tlb_tag7_4k_wclk                                (i_hqm_sip_rf_tlb_tag7_4k_wclk),
       .rf_tlb_tag7_4k_wclk_rst_n                          (i_hqm_sip_rf_tlb_tag7_4k_wclk_rst_n),
       .rf_tlb_tag7_4k_wdata                               (i_hqm_sip_rf_tlb_tag7_4k_wdata),
       .rf_tlb_tag7_4k_we                                  (i_hqm_sip_rf_tlb_tag7_4k_we),
       .rf_uno_atm_cmp_fifo_mem_raddr                      (i_hqm_sip_rf_uno_atm_cmp_fifo_mem_raddr),
       .rf_uno_atm_cmp_fifo_mem_rclk                       (i_hqm_sip_rf_uno_atm_cmp_fifo_mem_rclk),
       .rf_uno_atm_cmp_fifo_mem_rclk_rst_n                 (i_hqm_sip_rf_uno_atm_cmp_fifo_mem_rclk_rst_n),
       .rf_uno_atm_cmp_fifo_mem_re                         (i_hqm_sip_rf_uno_atm_cmp_fifo_mem_re),
       .rf_uno_atm_cmp_fifo_mem_waddr                      (i_hqm_sip_rf_uno_atm_cmp_fifo_mem_waddr),
       .rf_uno_atm_cmp_fifo_mem_wclk                       (i_hqm_sip_rf_uno_atm_cmp_fifo_mem_wclk),
       .rf_uno_atm_cmp_fifo_mem_wclk_rst_n                 (i_hqm_sip_rf_uno_atm_cmp_fifo_mem_wclk_rst_n),
       .rf_uno_atm_cmp_fifo_mem_wdata                      (i_hqm_sip_rf_uno_atm_cmp_fifo_mem_wdata),
       .rf_uno_atm_cmp_fifo_mem_we                         (i_hqm_sip_rf_uno_atm_cmp_fifo_mem_we),
       .sr_aqed_addr                                       (i_hqm_sip_sr_aqed_addr),
       .sr_aqed_clk                                        (i_hqm_sip_sr_aqed_clk),
       .sr_aqed_clk_rst_n                                  (i_hqm_sip_sr_aqed_clk_rst_n),
       .sr_aqed_freelist_addr                              (i_hqm_sip_sr_aqed_freelist_addr),
       .sr_aqed_freelist_clk                               (i_hqm_sip_sr_aqed_freelist_clk),
       .sr_aqed_freelist_clk_rst_n                         (i_hqm_sip_sr_aqed_freelist_clk_rst_n),
       .sr_aqed_freelist_re                                (i_hqm_sip_sr_aqed_freelist_re),
       .sr_aqed_freelist_wdata                             (i_hqm_sip_sr_aqed_freelist_wdata),
       .sr_aqed_freelist_we                                (i_hqm_sip_sr_aqed_freelist_we),
       .sr_aqed_ll_qe_hpnxt_addr                           (i_hqm_sip_sr_aqed_ll_qe_hpnxt_addr),
       .sr_aqed_ll_qe_hpnxt_clk                            (i_hqm_sip_sr_aqed_ll_qe_hpnxt_clk),
       .sr_aqed_ll_qe_hpnxt_clk_rst_n                      (i_hqm_sip_sr_aqed_ll_qe_hpnxt_clk_rst_n),
       .sr_aqed_ll_qe_hpnxt_re                             (i_hqm_sip_sr_aqed_ll_qe_hpnxt_re),
       .sr_aqed_ll_qe_hpnxt_wdata                          (i_hqm_sip_sr_aqed_ll_qe_hpnxt_wdata),
       .sr_aqed_ll_qe_hpnxt_we                             (i_hqm_sip_sr_aqed_ll_qe_hpnxt_we),
       .sr_aqed_re                                         (i_hqm_sip_sr_aqed_re),
       .sr_aqed_wdata                                      (i_hqm_sip_sr_aqed_wdata),
       .sr_aqed_we                                         (i_hqm_sip_sr_aqed_we),
       .sr_dir_nxthp_addr                                  (i_hqm_sip_sr_dir_nxthp_addr),
       .sr_dir_nxthp_clk                                   (i_hqm_sip_sr_dir_nxthp_clk),
       .sr_dir_nxthp_clk_rst_n                             (i_hqm_sip_sr_dir_nxthp_clk_rst_n),
       .sr_dir_nxthp_re                                    (i_hqm_sip_sr_dir_nxthp_re),
       .sr_dir_nxthp_wdata                                 (i_hqm_sip_sr_dir_nxthp_wdata),
       .sr_dir_nxthp_we                                    (i_hqm_sip_sr_dir_nxthp_we),
       .sr_freelist_0_addr                                 (i_hqm_sip_sr_freelist_0_addr),
       .sr_freelist_0_clk                                  (i_hqm_sip_sr_freelist_0_clk),
       .sr_freelist_0_clk_rst_n                            (i_hqm_sip_sr_freelist_0_clk_rst_n),
       .sr_freelist_0_re                                   (i_hqm_sip_sr_freelist_0_re),
       .sr_freelist_0_wdata                                (i_hqm_sip_sr_freelist_0_wdata),
       .sr_freelist_0_we                                   (i_hqm_sip_sr_freelist_0_we),
       .sr_freelist_1_addr                                 (i_hqm_sip_sr_freelist_1_addr),
       .sr_freelist_1_clk                                  (i_hqm_sip_sr_freelist_1_clk),
       .sr_freelist_1_clk_rst_n                            (i_hqm_sip_sr_freelist_1_clk_rst_n),
       .sr_freelist_1_re                                   (i_hqm_sip_sr_freelist_1_re),
       .sr_freelist_1_wdata                                (i_hqm_sip_sr_freelist_1_wdata),
       .sr_freelist_1_we                                   (i_hqm_sip_sr_freelist_1_we),
       .sr_freelist_2_addr                                 (i_hqm_sip_sr_freelist_2_addr),
       .sr_freelist_2_clk                                  (i_hqm_sip_sr_freelist_2_clk),
       .sr_freelist_2_clk_rst_n                            (i_hqm_sip_sr_freelist_2_clk_rst_n),
       .sr_freelist_2_re                                   (i_hqm_sip_sr_freelist_2_re),
       .sr_freelist_2_wdata                                (i_hqm_sip_sr_freelist_2_wdata),
       .sr_freelist_2_we                                   (i_hqm_sip_sr_freelist_2_we),
       .sr_freelist_3_addr                                 (i_hqm_sip_sr_freelist_3_addr),
       .sr_freelist_3_clk                                  (i_hqm_sip_sr_freelist_3_clk),
       .sr_freelist_3_clk_rst_n                            (i_hqm_sip_sr_freelist_3_clk_rst_n),
       .sr_freelist_3_re                                   (i_hqm_sip_sr_freelist_3_re),
       .sr_freelist_3_wdata                                (i_hqm_sip_sr_freelist_3_wdata),
       .sr_freelist_3_we                                   (i_hqm_sip_sr_freelist_3_we),
       .sr_freelist_4_addr                                 (i_hqm_sip_sr_freelist_4_addr),
       .sr_freelist_4_clk                                  (i_hqm_sip_sr_freelist_4_clk),
       .sr_freelist_4_clk_rst_n                            (i_hqm_sip_sr_freelist_4_clk_rst_n),
       .sr_freelist_4_re                                   (i_hqm_sip_sr_freelist_4_re),
       .sr_freelist_4_wdata                                (i_hqm_sip_sr_freelist_4_wdata),
       .sr_freelist_4_we                                   (i_hqm_sip_sr_freelist_4_we),
       .sr_freelist_5_addr                                 (i_hqm_sip_sr_freelist_5_addr),
       .sr_freelist_5_clk                                  (i_hqm_sip_sr_freelist_5_clk),
       .sr_freelist_5_clk_rst_n                            (i_hqm_sip_sr_freelist_5_clk_rst_n),
       .sr_freelist_5_re                                   (i_hqm_sip_sr_freelist_5_re),
       .sr_freelist_5_wdata                                (i_hqm_sip_sr_freelist_5_wdata),
       .sr_freelist_5_we                                   (i_hqm_sip_sr_freelist_5_we),
       .sr_freelist_6_addr                                 (i_hqm_sip_sr_freelist_6_addr),
       .sr_freelist_6_clk                                  (i_hqm_sip_sr_freelist_6_clk),
       .sr_freelist_6_clk_rst_n                            (i_hqm_sip_sr_freelist_6_clk_rst_n),
       .sr_freelist_6_re                                   (i_hqm_sip_sr_freelist_6_re),
       .sr_freelist_6_wdata                                (i_hqm_sip_sr_freelist_6_wdata),
       .sr_freelist_6_we                                   (i_hqm_sip_sr_freelist_6_we),
       .sr_freelist_7_addr                                 (i_hqm_sip_sr_freelist_7_addr),
       .sr_freelist_7_clk                                  (i_hqm_sip_sr_freelist_7_clk),
       .sr_freelist_7_clk_rst_n                            (i_hqm_sip_sr_freelist_7_clk_rst_n),
       .sr_freelist_7_re                                   (i_hqm_sip_sr_freelist_7_re),
       .sr_freelist_7_wdata                                (i_hqm_sip_sr_freelist_7_wdata),
       .sr_freelist_7_we                                   (i_hqm_sip_sr_freelist_7_we),
       .sr_hist_list_a_addr                                (i_hqm_sip_sr_hist_list_a_addr),
       .sr_hist_list_a_clk                                 (i_hqm_sip_sr_hist_list_a_clk),
       .sr_hist_list_a_clk_rst_n                           (i_hqm_sip_sr_hist_list_a_clk_rst_n),
       .sr_hist_list_a_re                                  (i_hqm_sip_sr_hist_list_a_re),
       .sr_hist_list_a_wdata                               (i_hqm_sip_sr_hist_list_a_wdata),
       .sr_hist_list_a_we                                  (i_hqm_sip_sr_hist_list_a_we),
       .sr_hist_list_addr                                  (i_hqm_sip_sr_hist_list_addr),
       .sr_hist_list_clk                                   (i_hqm_sip_sr_hist_list_clk),
       .sr_hist_list_clk_rst_n                             (i_hqm_sip_sr_hist_list_clk_rst_n),
       .sr_hist_list_re                                    (i_hqm_sip_sr_hist_list_re),
       .sr_hist_list_wdata                                 (i_hqm_sip_sr_hist_list_wdata),
       .sr_hist_list_we                                    (i_hqm_sip_sr_hist_list_we),
       .sr_nalb_nxthp_addr                                 (i_hqm_sip_sr_nalb_nxthp_addr),
       .sr_nalb_nxthp_clk                                  (i_hqm_sip_sr_nalb_nxthp_clk),
       .sr_nalb_nxthp_clk_rst_n                            (i_hqm_sip_sr_nalb_nxthp_clk_rst_n),
       .sr_nalb_nxthp_re                                   (i_hqm_sip_sr_nalb_nxthp_re),
       .sr_nalb_nxthp_wdata                                (i_hqm_sip_sr_nalb_nxthp_wdata),
       .sr_nalb_nxthp_we                                   (i_hqm_sip_sr_nalb_nxthp_we),
       .sr_qed_0_addr                                      (i_hqm_sip_sr_qed_0_addr),
       .sr_qed_0_clk                                       (i_hqm_sip_sr_qed_0_clk),
       .sr_qed_0_clk_rst_n                                 (i_hqm_sip_sr_qed_0_clk_rst_n),
       .sr_qed_0_re                                        (i_hqm_sip_sr_qed_0_re),
       .sr_qed_0_wdata                                     (i_hqm_sip_sr_qed_0_wdata),
       .sr_qed_0_we                                        (i_hqm_sip_sr_qed_0_we),
       .sr_qed_1_addr                                      (i_hqm_sip_sr_qed_1_addr),
       .sr_qed_1_clk                                       (i_hqm_sip_sr_qed_1_clk),
       .sr_qed_1_clk_rst_n                                 (i_hqm_sip_sr_qed_1_clk_rst_n),
       .sr_qed_1_re                                        (i_hqm_sip_sr_qed_1_re),
       .sr_qed_1_wdata                                     (i_hqm_sip_sr_qed_1_wdata),
       .sr_qed_1_we                                        (i_hqm_sip_sr_qed_1_we),
       .sr_qed_2_addr                                      (i_hqm_sip_sr_qed_2_addr),
       .sr_qed_2_clk                                       (i_hqm_sip_sr_qed_2_clk),
       .sr_qed_2_clk_rst_n                                 (i_hqm_sip_sr_qed_2_clk_rst_n),
       .sr_qed_2_re                                        (i_hqm_sip_sr_qed_2_re),
       .sr_qed_2_wdata                                     (i_hqm_sip_sr_qed_2_wdata),
       .sr_qed_2_we                                        (i_hqm_sip_sr_qed_2_we),
       .sr_qed_3_addr                                      (i_hqm_sip_sr_qed_3_addr),
       .sr_qed_3_clk                                       (i_hqm_sip_sr_qed_3_clk),
       .sr_qed_3_clk_rst_n                                 (i_hqm_sip_sr_qed_3_clk_rst_n),
       .sr_qed_3_re                                        (i_hqm_sip_sr_qed_3_re),
       .sr_qed_3_wdata                                     (i_hqm_sip_sr_qed_3_wdata),
       .sr_qed_3_we                                        (i_hqm_sip_sr_qed_3_we),
       .sr_qed_4_addr                                      (i_hqm_sip_sr_qed_4_addr),
       .sr_qed_4_clk                                       (i_hqm_sip_sr_qed_4_clk),
       .sr_qed_4_clk_rst_n                                 (i_hqm_sip_sr_qed_4_clk_rst_n),
       .sr_qed_4_re                                        (i_hqm_sip_sr_qed_4_re),
       .sr_qed_4_wdata                                     (i_hqm_sip_sr_qed_4_wdata),
       .sr_qed_4_we                                        (i_hqm_sip_sr_qed_4_we),
       .sr_qed_5_addr                                      (i_hqm_sip_sr_qed_5_addr),
       .sr_qed_5_clk                                       (i_hqm_sip_sr_qed_5_clk),
       .sr_qed_5_clk_rst_n                                 (i_hqm_sip_sr_qed_5_clk_rst_n),
       .sr_qed_5_re                                        (i_hqm_sip_sr_qed_5_re),
       .sr_qed_5_wdata                                     (i_hqm_sip_sr_qed_5_wdata),
       .sr_qed_5_we                                        (i_hqm_sip_sr_qed_5_we),
       .sr_qed_6_addr                                      (i_hqm_sip_sr_qed_6_addr),
       .sr_qed_6_clk                                       (i_hqm_sip_sr_qed_6_clk),
       .sr_qed_6_clk_rst_n                                 (i_hqm_sip_sr_qed_6_clk_rst_n),
       .sr_qed_6_re                                        (i_hqm_sip_sr_qed_6_re),
       .sr_qed_6_wdata                                     (i_hqm_sip_sr_qed_6_wdata),
       .sr_qed_6_we                                        (i_hqm_sip_sr_qed_6_we),
       .sr_qed_7_addr                                      (i_hqm_sip_sr_qed_7_addr),
       .sr_qed_7_clk                                       (i_hqm_sip_sr_qed_7_clk),
       .sr_qed_7_clk_rst_n                                 (i_hqm_sip_sr_qed_7_clk_rst_n),
       .sr_qed_7_re                                        (i_hqm_sip_sr_qed_7_re),
       .sr_qed_7_wdata                                     (i_hqm_sip_sr_qed_7_wdata),
       .sr_qed_7_we                                        (i_hqm_sip_sr_qed_7_we),
       .sr_rob_mem_addr                                    (i_hqm_sip_sr_rob_mem_addr),
       .sr_rob_mem_clk                                     (i_hqm_sip_sr_rob_mem_clk),
       .sr_rob_mem_clk_rst_n                               (i_hqm_sip_sr_rob_mem_clk_rst_n),
       .sr_rob_mem_re                                      (i_hqm_sip_sr_rob_mem_re),
       .sr_rob_mem_wdata                                   (i_hqm_sip_sr_rob_mem_wdata),
       .sr_rob_mem_we                                      (i_hqm_sip_sr_rob_mem_we));

   hqm_system_mem i_hqm_system_mem
      (.rf_alarm_vf_synd0_wclk                               (i_hqm_sip_rf_alarm_vf_synd0_wclk),
       .rf_alarm_vf_synd0_wclk_rst_n                         (i_hqm_sip_rf_alarm_vf_synd0_wclk_rst_n),
       .rf_alarm_vf_synd0_we                                 (i_hqm_sip_rf_alarm_vf_synd0_we),
       .rf_alarm_vf_synd0_waddr                              (i_hqm_sip_rf_alarm_vf_synd0_waddr),
       .rf_alarm_vf_synd0_wdata                              (i_hqm_sip_rf_alarm_vf_synd0_wdata),
       .rf_alarm_vf_synd0_rclk                               (i_hqm_sip_rf_alarm_vf_synd0_rclk),
       .rf_alarm_vf_synd0_rclk_rst_n                         (i_hqm_sip_rf_alarm_vf_synd0_rclk_rst_n),
       .rf_alarm_vf_synd0_re                                 (i_hqm_sip_rf_alarm_vf_synd0_re),
       .rf_alarm_vf_synd0_raddr                              (i_hqm_sip_rf_alarm_vf_synd0_raddr),
       .rf_alarm_vf_synd0_rdata                              (i_hqm_system_mem_rf_alarm_vf_synd0_rdata),
       .rf_alarm_vf_synd0_isol_en                            (i_hqm_sip_pgcb_isol_en),
       .rf_alarm_vf_synd0_pwr_enable_b_in                    (i_hqm_system_mem_sr_rob_mem_pwr_enable_b_out),
       .rf_alarm_vf_synd0_pwr_enable_b_out                   (i_hqm_system_mem_rf_alarm_vf_synd0_pwr_enable_b_out),
       .rf_alarm_vf_synd1_wclk                               (i_hqm_sip_rf_alarm_vf_synd1_wclk),
       .rf_alarm_vf_synd1_wclk_rst_n                         (i_hqm_sip_rf_alarm_vf_synd1_wclk_rst_n),
       .rf_alarm_vf_synd1_we                                 (i_hqm_sip_rf_alarm_vf_synd1_we),
       .rf_alarm_vf_synd1_waddr                              (i_hqm_sip_rf_alarm_vf_synd1_waddr),
       .rf_alarm_vf_synd1_wdata                              (i_hqm_sip_rf_alarm_vf_synd1_wdata),
       .rf_alarm_vf_synd1_rclk                               (i_hqm_sip_rf_alarm_vf_synd1_rclk),
       .rf_alarm_vf_synd1_rclk_rst_n                         (i_hqm_sip_rf_alarm_vf_synd1_rclk_rst_n),
       .rf_alarm_vf_synd1_re                                 (i_hqm_sip_rf_alarm_vf_synd1_re),
       .rf_alarm_vf_synd1_raddr                              (i_hqm_sip_rf_alarm_vf_synd1_raddr),
       .rf_alarm_vf_synd1_rdata                              (i_hqm_system_mem_rf_alarm_vf_synd1_rdata),
       .rf_alarm_vf_synd1_isol_en                            (i_hqm_sip_pgcb_isol_en),
       .rf_alarm_vf_synd1_pwr_enable_b_in                    (i_hqm_system_mem_rf_alarm_vf_synd0_pwr_enable_b_out),
       .rf_alarm_vf_synd1_pwr_enable_b_out                   (i_hqm_system_mem_rf_alarm_vf_synd1_pwr_enable_b_out),
       .rf_alarm_vf_synd2_wclk                               (i_hqm_sip_rf_alarm_vf_synd2_wclk),
       .rf_alarm_vf_synd2_wclk_rst_n                         (i_hqm_sip_rf_alarm_vf_synd2_wclk_rst_n),
       .rf_alarm_vf_synd2_we                                 (i_hqm_sip_rf_alarm_vf_synd2_we),
       .rf_alarm_vf_synd2_waddr                              (i_hqm_sip_rf_alarm_vf_synd2_waddr),
       .rf_alarm_vf_synd2_wdata                              (i_hqm_sip_rf_alarm_vf_synd2_wdata),
       .rf_alarm_vf_synd2_rclk                               (i_hqm_sip_rf_alarm_vf_synd2_rclk),
       .rf_alarm_vf_synd2_rclk_rst_n                         (i_hqm_sip_rf_alarm_vf_synd2_rclk_rst_n),
       .rf_alarm_vf_synd2_re                                 (i_hqm_sip_rf_alarm_vf_synd2_re),
       .rf_alarm_vf_synd2_raddr                              (i_hqm_sip_rf_alarm_vf_synd2_raddr),
       .rf_alarm_vf_synd2_rdata                              (i_hqm_system_mem_rf_alarm_vf_synd2_rdata),
       .rf_alarm_vf_synd2_isol_en                            (i_hqm_sip_pgcb_isol_en),
       .rf_alarm_vf_synd2_pwr_enable_b_in                    (i_hqm_system_mem_rf_alarm_vf_synd1_pwr_enable_b_out),
       .rf_alarm_vf_synd2_pwr_enable_b_out                   (i_hqm_system_mem_rf_alarm_vf_synd2_pwr_enable_b_out),
       .rf_aqed_chp_sch_rx_sync_mem_wclk                     (i_hqm_sip_rf_aqed_chp_sch_rx_sync_mem_wclk),
       .rf_aqed_chp_sch_rx_sync_mem_wclk_rst_n               (i_hqm_sip_rf_aqed_chp_sch_rx_sync_mem_wclk_rst_n),
       .rf_aqed_chp_sch_rx_sync_mem_we                       (i_hqm_sip_rf_aqed_chp_sch_rx_sync_mem_we),
       .rf_aqed_chp_sch_rx_sync_mem_waddr                    (i_hqm_sip_rf_aqed_chp_sch_rx_sync_mem_waddr),
       .rf_aqed_chp_sch_rx_sync_mem_wdata                    (i_hqm_sip_rf_aqed_chp_sch_rx_sync_mem_wdata),
       .rf_aqed_chp_sch_rx_sync_mem_rclk                     (i_hqm_sip_rf_aqed_chp_sch_rx_sync_mem_rclk),
       .rf_aqed_chp_sch_rx_sync_mem_rclk_rst_n               (i_hqm_sip_rf_aqed_chp_sch_rx_sync_mem_rclk_rst_n),
       .rf_aqed_chp_sch_rx_sync_mem_re                       (i_hqm_sip_rf_aqed_chp_sch_rx_sync_mem_re),
       .rf_aqed_chp_sch_rx_sync_mem_raddr                    (i_hqm_sip_rf_aqed_chp_sch_rx_sync_mem_raddr),
       .rf_aqed_chp_sch_rx_sync_mem_rdata                    (i_hqm_system_mem_rf_aqed_chp_sch_rx_sync_mem_rdata),
       .rf_aqed_chp_sch_rx_sync_mem_isol_en                  (i_hqm_sip_pgcb_isol_en),
       .rf_aqed_chp_sch_rx_sync_mem_pwr_enable_b_in          (i_hqm_system_mem_rf_alarm_vf_synd2_pwr_enable_b_out),
       .rf_aqed_chp_sch_rx_sync_mem_pwr_enable_b_out         (i_hqm_system_mem_rf_aqed_chp_sch_rx_sync_mem_pwr_enable_b_out),
       .rf_chp_chp_rop_hcw_fifo_mem_wclk                     (i_hqm_sip_rf_chp_chp_rop_hcw_fifo_mem_wclk),
       .rf_chp_chp_rop_hcw_fifo_mem_wclk_rst_n               (i_hqm_sip_rf_chp_chp_rop_hcw_fifo_mem_wclk_rst_n),
       .rf_chp_chp_rop_hcw_fifo_mem_we                       (i_hqm_sip_rf_chp_chp_rop_hcw_fifo_mem_we),
       .rf_chp_chp_rop_hcw_fifo_mem_waddr                    (i_hqm_sip_rf_chp_chp_rop_hcw_fifo_mem_waddr),
       .rf_chp_chp_rop_hcw_fifo_mem_wdata                    (i_hqm_sip_rf_chp_chp_rop_hcw_fifo_mem_wdata),
       .rf_chp_chp_rop_hcw_fifo_mem_rclk                     (i_hqm_sip_rf_chp_chp_rop_hcw_fifo_mem_rclk),
       .rf_chp_chp_rop_hcw_fifo_mem_rclk_rst_n               (i_hqm_sip_rf_chp_chp_rop_hcw_fifo_mem_rclk_rst_n),
       .rf_chp_chp_rop_hcw_fifo_mem_re                       (i_hqm_sip_rf_chp_chp_rop_hcw_fifo_mem_re),
       .rf_chp_chp_rop_hcw_fifo_mem_raddr                    (i_hqm_sip_rf_chp_chp_rop_hcw_fifo_mem_raddr),
       .rf_chp_chp_rop_hcw_fifo_mem_rdata                    (i_hqm_system_mem_rf_chp_chp_rop_hcw_fifo_mem_rdata),
       .rf_chp_chp_rop_hcw_fifo_mem_isol_en                  (i_hqm_sip_pgcb_isol_en),
       .rf_chp_chp_rop_hcw_fifo_mem_pwr_enable_b_in          (i_hqm_system_mem_rf_aqed_chp_sch_rx_sync_mem_pwr_enable_b_out),
       .rf_chp_chp_rop_hcw_fifo_mem_pwr_enable_b_out         (i_hqm_system_mem_rf_chp_chp_rop_hcw_fifo_mem_pwr_enable_b_out),
       .rf_chp_lsp_ap_cmp_fifo_mem_wclk                      (i_hqm_sip_rf_chp_lsp_ap_cmp_fifo_mem_wclk),
       .rf_chp_lsp_ap_cmp_fifo_mem_wclk_rst_n                (i_hqm_sip_rf_chp_lsp_ap_cmp_fifo_mem_wclk_rst_n),
       .rf_chp_lsp_ap_cmp_fifo_mem_we                        (i_hqm_sip_rf_chp_lsp_ap_cmp_fifo_mem_we),
       .rf_chp_lsp_ap_cmp_fifo_mem_waddr                     (i_hqm_sip_rf_chp_lsp_ap_cmp_fifo_mem_waddr),
       .rf_chp_lsp_ap_cmp_fifo_mem_wdata                     (i_hqm_sip_rf_chp_lsp_ap_cmp_fifo_mem_wdata),
       .rf_chp_lsp_ap_cmp_fifo_mem_rclk                      (i_hqm_sip_rf_chp_lsp_ap_cmp_fifo_mem_rclk),
       .rf_chp_lsp_ap_cmp_fifo_mem_rclk_rst_n                (i_hqm_sip_rf_chp_lsp_ap_cmp_fifo_mem_rclk_rst_n),
       .rf_chp_lsp_ap_cmp_fifo_mem_re                        (i_hqm_sip_rf_chp_lsp_ap_cmp_fifo_mem_re),
       .rf_chp_lsp_ap_cmp_fifo_mem_raddr                     (i_hqm_sip_rf_chp_lsp_ap_cmp_fifo_mem_raddr),
       .rf_chp_lsp_ap_cmp_fifo_mem_rdata                     (i_hqm_system_mem_rf_chp_lsp_ap_cmp_fifo_mem_rdata),
       .rf_chp_lsp_ap_cmp_fifo_mem_isol_en                   (i_hqm_sip_pgcb_isol_en),
       .rf_chp_lsp_ap_cmp_fifo_mem_pwr_enable_b_in           (i_hqm_system_mem_rf_chp_chp_rop_hcw_fifo_mem_pwr_enable_b_out),
       .rf_chp_lsp_ap_cmp_fifo_mem_pwr_enable_b_out          (i_hqm_system_mem_rf_chp_lsp_ap_cmp_fifo_mem_pwr_enable_b_out),
       .rf_chp_lsp_tok_fifo_mem_wclk                         (i_hqm_sip_rf_chp_lsp_tok_fifo_mem_wclk),
       .rf_chp_lsp_tok_fifo_mem_wclk_rst_n                   (i_hqm_sip_rf_chp_lsp_tok_fifo_mem_wclk_rst_n),
       .rf_chp_lsp_tok_fifo_mem_we                           (i_hqm_sip_rf_chp_lsp_tok_fifo_mem_we),
       .rf_chp_lsp_tok_fifo_mem_waddr                        (i_hqm_sip_rf_chp_lsp_tok_fifo_mem_waddr),
       .rf_chp_lsp_tok_fifo_mem_wdata                        (i_hqm_sip_rf_chp_lsp_tok_fifo_mem_wdata),
       .rf_chp_lsp_tok_fifo_mem_rclk                         (i_hqm_sip_rf_chp_lsp_tok_fifo_mem_rclk),
       .rf_chp_lsp_tok_fifo_mem_rclk_rst_n                   (i_hqm_sip_rf_chp_lsp_tok_fifo_mem_rclk_rst_n),
       .rf_chp_lsp_tok_fifo_mem_re                           (i_hqm_sip_rf_chp_lsp_tok_fifo_mem_re),
       .rf_chp_lsp_tok_fifo_mem_raddr                        (i_hqm_sip_rf_chp_lsp_tok_fifo_mem_raddr),
       .rf_chp_lsp_tok_fifo_mem_rdata                        (i_hqm_system_mem_rf_chp_lsp_tok_fifo_mem_rdata),
       .rf_chp_lsp_tok_fifo_mem_isol_en                      (i_hqm_sip_pgcb_isol_en),
       .rf_chp_lsp_tok_fifo_mem_pwr_enable_b_in              (i_hqm_system_mem_rf_chp_lsp_ap_cmp_fifo_mem_pwr_enable_b_out),
       .rf_chp_lsp_tok_fifo_mem_pwr_enable_b_out             (i_hqm_system_mem_rf_chp_lsp_tok_fifo_mem_pwr_enable_b_out),
       .rf_chp_sys_tx_fifo_mem_wclk                          (i_hqm_sip_rf_chp_sys_tx_fifo_mem_wclk),
       .rf_chp_sys_tx_fifo_mem_wclk_rst_n                    (i_hqm_sip_rf_chp_sys_tx_fifo_mem_wclk_rst_n),
       .rf_chp_sys_tx_fifo_mem_we                            (i_hqm_sip_rf_chp_sys_tx_fifo_mem_we),
       .rf_chp_sys_tx_fifo_mem_waddr                         (i_hqm_sip_rf_chp_sys_tx_fifo_mem_waddr),
       .rf_chp_sys_tx_fifo_mem_wdata                         (i_hqm_sip_rf_chp_sys_tx_fifo_mem_wdata),
       .rf_chp_sys_tx_fifo_mem_rclk                          (i_hqm_sip_rf_chp_sys_tx_fifo_mem_rclk),
       .rf_chp_sys_tx_fifo_mem_rclk_rst_n                    (i_hqm_sip_rf_chp_sys_tx_fifo_mem_rclk_rst_n),
       .rf_chp_sys_tx_fifo_mem_re                            (i_hqm_sip_rf_chp_sys_tx_fifo_mem_re),
       .rf_chp_sys_tx_fifo_mem_raddr                         (i_hqm_sip_rf_chp_sys_tx_fifo_mem_raddr),
       .rf_chp_sys_tx_fifo_mem_rdata                         (i_hqm_system_mem_rf_chp_sys_tx_fifo_mem_rdata),
       .rf_chp_sys_tx_fifo_mem_isol_en                       (i_hqm_sip_pgcb_isol_en),
       .rf_chp_sys_tx_fifo_mem_pwr_enable_b_in               (i_hqm_system_mem_rf_chp_lsp_tok_fifo_mem_pwr_enable_b_out),
       .rf_chp_sys_tx_fifo_mem_pwr_enable_b_out              (i_hqm_system_mem_rf_chp_sys_tx_fifo_mem_pwr_enable_b_out),
       .rf_cmp_id_chk_enbl_mem_wclk                          (i_hqm_sip_rf_cmp_id_chk_enbl_mem_wclk),
       .rf_cmp_id_chk_enbl_mem_wclk_rst_n                    (i_hqm_sip_rf_cmp_id_chk_enbl_mem_wclk_rst_n),
       .rf_cmp_id_chk_enbl_mem_we                            (i_hqm_sip_rf_cmp_id_chk_enbl_mem_we),
       .rf_cmp_id_chk_enbl_mem_waddr                         (i_hqm_sip_rf_cmp_id_chk_enbl_mem_waddr),
       .rf_cmp_id_chk_enbl_mem_wdata                         (i_hqm_sip_rf_cmp_id_chk_enbl_mem_wdata),
       .rf_cmp_id_chk_enbl_mem_rclk                          (i_hqm_sip_rf_cmp_id_chk_enbl_mem_rclk),
       .rf_cmp_id_chk_enbl_mem_rclk_rst_n                    (i_hqm_sip_rf_cmp_id_chk_enbl_mem_rclk_rst_n),
       .rf_cmp_id_chk_enbl_mem_re                            (i_hqm_sip_rf_cmp_id_chk_enbl_mem_re),
       .rf_cmp_id_chk_enbl_mem_raddr                         (i_hqm_sip_rf_cmp_id_chk_enbl_mem_raddr),
       .rf_cmp_id_chk_enbl_mem_rdata                         (i_hqm_system_mem_rf_cmp_id_chk_enbl_mem_rdata),
       .rf_cmp_id_chk_enbl_mem_isol_en                       (i_hqm_sip_pgcb_isol_en),
       .rf_cmp_id_chk_enbl_mem_pwr_enable_b_in               (i_hqm_system_mem_rf_chp_sys_tx_fifo_mem_pwr_enable_b_out),
       .rf_cmp_id_chk_enbl_mem_pwr_enable_b_out              (i_hqm_system_mem_rf_cmp_id_chk_enbl_mem_pwr_enable_b_out),
       .rf_count_rmw_pipe_dir_mem_wclk                       (i_hqm_sip_rf_count_rmw_pipe_dir_mem_wclk),
       .rf_count_rmw_pipe_dir_mem_wclk_rst_n                 (i_hqm_sip_rf_count_rmw_pipe_dir_mem_wclk_rst_n),
       .rf_count_rmw_pipe_dir_mem_we                         (i_hqm_sip_rf_count_rmw_pipe_dir_mem_we),
       .rf_count_rmw_pipe_dir_mem_waddr                      (i_hqm_sip_rf_count_rmw_pipe_dir_mem_waddr),
       .rf_count_rmw_pipe_dir_mem_wdata                      (i_hqm_sip_rf_count_rmw_pipe_dir_mem_wdata),
       .rf_count_rmw_pipe_dir_mem_rclk                       (i_hqm_sip_rf_count_rmw_pipe_dir_mem_rclk),
       .rf_count_rmw_pipe_dir_mem_rclk_rst_n                 (i_hqm_sip_rf_count_rmw_pipe_dir_mem_rclk_rst_n),
       .rf_count_rmw_pipe_dir_mem_re                         (i_hqm_sip_rf_count_rmw_pipe_dir_mem_re),
       .rf_count_rmw_pipe_dir_mem_raddr                      (i_hqm_sip_rf_count_rmw_pipe_dir_mem_raddr),
       .rf_count_rmw_pipe_dir_mem_rdata                      (i_hqm_system_mem_rf_count_rmw_pipe_dir_mem_rdata),
       .rf_count_rmw_pipe_dir_mem_isol_en                    (i_hqm_sip_pgcb_isol_en),
       .rf_count_rmw_pipe_dir_mem_pwr_enable_b_in            (i_hqm_system_mem_rf_cmp_id_chk_enbl_mem_pwr_enable_b_out),
       .rf_count_rmw_pipe_dir_mem_pwr_enable_b_out           (i_hqm_system_mem_rf_count_rmw_pipe_dir_mem_pwr_enable_b_out),
       .rf_count_rmw_pipe_ldb_mem_wclk                       (i_hqm_sip_rf_count_rmw_pipe_ldb_mem_wclk),
       .rf_count_rmw_pipe_ldb_mem_wclk_rst_n                 (i_hqm_sip_rf_count_rmw_pipe_ldb_mem_wclk_rst_n),
       .rf_count_rmw_pipe_ldb_mem_we                         (i_hqm_sip_rf_count_rmw_pipe_ldb_mem_we),
       .rf_count_rmw_pipe_ldb_mem_waddr                      (i_hqm_sip_rf_count_rmw_pipe_ldb_mem_waddr),
       .rf_count_rmw_pipe_ldb_mem_wdata                      (i_hqm_sip_rf_count_rmw_pipe_ldb_mem_wdata),
       .rf_count_rmw_pipe_ldb_mem_rclk                       (i_hqm_sip_rf_count_rmw_pipe_ldb_mem_rclk),
       .rf_count_rmw_pipe_ldb_mem_rclk_rst_n                 (i_hqm_sip_rf_count_rmw_pipe_ldb_mem_rclk_rst_n),
       .rf_count_rmw_pipe_ldb_mem_re                         (i_hqm_sip_rf_count_rmw_pipe_ldb_mem_re),
       .rf_count_rmw_pipe_ldb_mem_raddr                      (i_hqm_sip_rf_count_rmw_pipe_ldb_mem_raddr),
       .rf_count_rmw_pipe_ldb_mem_rdata                      (i_hqm_system_mem_rf_count_rmw_pipe_ldb_mem_rdata),
       .rf_count_rmw_pipe_ldb_mem_isol_en                    (i_hqm_sip_pgcb_isol_en),
       .rf_count_rmw_pipe_ldb_mem_pwr_enable_b_in            (i_hqm_system_mem_rf_count_rmw_pipe_dir_mem_pwr_enable_b_out),
       .rf_count_rmw_pipe_ldb_mem_pwr_enable_b_out           (i_hqm_system_mem_rf_count_rmw_pipe_ldb_mem_pwr_enable_b_out),
       .rf_dir_cq_depth_wclk                                 (i_hqm_sip_rf_dir_cq_depth_wclk),
       .rf_dir_cq_depth_wclk_rst_n                           (i_hqm_sip_rf_dir_cq_depth_wclk_rst_n),
       .rf_dir_cq_depth_we                                   (i_hqm_sip_rf_dir_cq_depth_we),
       .rf_dir_cq_depth_waddr                                (i_hqm_sip_rf_dir_cq_depth_waddr),
       .rf_dir_cq_depth_wdata                                (i_hqm_sip_rf_dir_cq_depth_wdata),
       .rf_dir_cq_depth_rclk                                 (i_hqm_sip_rf_dir_cq_depth_rclk),
       .rf_dir_cq_depth_rclk_rst_n                           (i_hqm_sip_rf_dir_cq_depth_rclk_rst_n),
       .rf_dir_cq_depth_re                                   (i_hqm_sip_rf_dir_cq_depth_re),
       .rf_dir_cq_depth_raddr                                (i_hqm_sip_rf_dir_cq_depth_raddr),
       .rf_dir_cq_depth_rdata                                (i_hqm_system_mem_rf_dir_cq_depth_rdata),
       .rf_dir_cq_depth_isol_en                              (i_hqm_sip_pgcb_isol_en),
       .rf_dir_cq_depth_pwr_enable_b_in                      (i_hqm_system_mem_rf_count_rmw_pipe_wd_ldb_mem_pwr_enable_b_out),
       .rf_dir_cq_depth_pwr_enable_b_out                     (i_hqm_system_mem_rf_dir_cq_depth_pwr_enable_b_out),
       .rf_dir_cq_intr_thresh_wclk                           (i_hqm_sip_rf_dir_cq_intr_thresh_wclk),
       .rf_dir_cq_intr_thresh_wclk_rst_n                     (i_hqm_sip_rf_dir_cq_intr_thresh_wclk_rst_n),
       .rf_dir_cq_intr_thresh_we                             (i_hqm_sip_rf_dir_cq_intr_thresh_we),
       .rf_dir_cq_intr_thresh_waddr                          (i_hqm_sip_rf_dir_cq_intr_thresh_waddr),
       .rf_dir_cq_intr_thresh_wdata                          (i_hqm_sip_rf_dir_cq_intr_thresh_wdata),
       .rf_dir_cq_intr_thresh_rclk                           (i_hqm_sip_rf_dir_cq_intr_thresh_rclk),
       .rf_dir_cq_intr_thresh_rclk_rst_n                     (i_hqm_sip_rf_dir_cq_intr_thresh_rclk_rst_n),
       .rf_dir_cq_intr_thresh_re                             (i_hqm_sip_rf_dir_cq_intr_thresh_re),
       .rf_dir_cq_intr_thresh_raddr                          (i_hqm_sip_rf_dir_cq_intr_thresh_raddr),
       .rf_dir_cq_intr_thresh_rdata                          (i_hqm_system_mem_rf_dir_cq_intr_thresh_rdata),
       .rf_dir_cq_intr_thresh_isol_en                        (i_hqm_sip_pgcb_isol_en),
       .rf_dir_cq_intr_thresh_pwr_enable_b_in                (i_hqm_system_mem_rf_dir_cq_depth_pwr_enable_b_out),
       .rf_dir_cq_intr_thresh_pwr_enable_b_out               (i_hqm_system_mem_rf_dir_cq_intr_thresh_pwr_enable_b_out),
       .rf_dir_cq_token_depth_select_wclk                    (i_hqm_sip_rf_dir_cq_token_depth_select_wclk),
       .rf_dir_cq_token_depth_select_wclk_rst_n              (i_hqm_sip_rf_dir_cq_token_depth_select_wclk_rst_n),
       .rf_dir_cq_token_depth_select_we                      (i_hqm_sip_rf_dir_cq_token_depth_select_we),
       .rf_dir_cq_token_depth_select_waddr                   (i_hqm_sip_rf_dir_cq_token_depth_select_waddr),
       .rf_dir_cq_token_depth_select_wdata                   (i_hqm_sip_rf_dir_cq_token_depth_select_wdata),
       .rf_dir_cq_token_depth_select_rclk                    (i_hqm_sip_rf_dir_cq_token_depth_select_rclk),
       .rf_dir_cq_token_depth_select_rclk_rst_n              (i_hqm_sip_rf_dir_cq_token_depth_select_rclk_rst_n),
       .rf_dir_cq_token_depth_select_re                      (i_hqm_sip_rf_dir_cq_token_depth_select_re),
       .rf_dir_cq_token_depth_select_raddr                   (i_hqm_sip_rf_dir_cq_token_depth_select_raddr),
       .rf_dir_cq_token_depth_select_rdata                   (i_hqm_system_mem_rf_dir_cq_token_depth_select_rdata),
       .rf_dir_cq_token_depth_select_isol_en                 (i_hqm_sip_pgcb_isol_en),
       .rf_dir_cq_token_depth_select_pwr_enable_b_in         (i_hqm_system_mem_rf_dir_cq_intr_thresh_pwr_enable_b_out),
       .rf_dir_cq_token_depth_select_pwr_enable_b_out        (i_hqm_system_mem_rf_dir_cq_token_depth_select_pwr_enable_b_out),
       .rf_dir_cq_wptr_wclk                                  (i_hqm_sip_rf_dir_cq_wptr_wclk),
       .rf_dir_cq_wptr_wclk_rst_n                            (i_hqm_sip_rf_dir_cq_wptr_wclk_rst_n),
       .rf_dir_cq_wptr_we                                    (i_hqm_sip_rf_dir_cq_wptr_we),
       .rf_dir_cq_wptr_waddr                                 (i_hqm_sip_rf_dir_cq_wptr_waddr),
       .rf_dir_cq_wptr_wdata                                 (i_hqm_sip_rf_dir_cq_wptr_wdata),
       .rf_dir_cq_wptr_rclk                                  (i_hqm_sip_rf_dir_cq_wptr_rclk),
       .rf_dir_cq_wptr_rclk_rst_n                            (i_hqm_sip_rf_dir_cq_wptr_rclk_rst_n),
       .rf_dir_cq_wptr_re                                    (i_hqm_sip_rf_dir_cq_wptr_re),
       .rf_dir_cq_wptr_raddr                                 (i_hqm_sip_rf_dir_cq_wptr_raddr),
       .rf_dir_cq_wptr_rdata                                 (i_hqm_system_mem_rf_dir_cq_wptr_rdata),
       .rf_dir_cq_wptr_isol_en                               (i_hqm_sip_pgcb_isol_en),
       .rf_dir_cq_wptr_pwr_enable_b_in                       (i_hqm_system_mem_rf_dir_cq_token_depth_select_pwr_enable_b_out),
       .rf_dir_cq_wptr_pwr_enable_b_out                      (i_hqm_system_mem_rf_dir_cq_wptr_pwr_enable_b_out),
       .rf_dir_rply_req_fifo_mem_wclk                        (i_hqm_sip_rf_dir_rply_req_fifo_mem_wclk),
       .rf_dir_rply_req_fifo_mem_wclk_rst_n                  (i_hqm_sip_rf_dir_rply_req_fifo_mem_wclk_rst_n),
       .rf_dir_rply_req_fifo_mem_we                          (i_hqm_sip_rf_dir_rply_req_fifo_mem_we),
       .rf_dir_rply_req_fifo_mem_waddr                       (i_hqm_sip_rf_dir_rply_req_fifo_mem_waddr),
       .rf_dir_rply_req_fifo_mem_wdata                       (i_hqm_sip_rf_dir_rply_req_fifo_mem_wdata),
       .rf_dir_rply_req_fifo_mem_rclk                        (i_hqm_sip_rf_dir_rply_req_fifo_mem_rclk),
       .rf_dir_rply_req_fifo_mem_rclk_rst_n                  (i_hqm_sip_rf_dir_rply_req_fifo_mem_rclk_rst_n),
       .rf_dir_rply_req_fifo_mem_re                          (i_hqm_sip_rf_dir_rply_req_fifo_mem_re),
       .rf_dir_rply_req_fifo_mem_raddr                       (i_hqm_sip_rf_dir_rply_req_fifo_mem_raddr),
       .rf_dir_rply_req_fifo_mem_rdata                       (i_hqm_system_mem_rf_dir_rply_req_fifo_mem_rdata),
       .rf_dir_rply_req_fifo_mem_isol_en                     (i_hqm_sip_pgcb_isol_en),
       .rf_dir_rply_req_fifo_mem_pwr_enable_b_in             (i_hqm_system_mem_rf_dir_cq_wptr_pwr_enable_b_out),
       .rf_dir_rply_req_fifo_mem_pwr_enable_b_out            (i_hqm_system_mem_rf_dir_rply_req_fifo_mem_pwr_enable_b_out),
       .rf_dir_wb0_wclk                                      (i_hqm_sip_rf_dir_wb0_wclk),
       .rf_dir_wb0_wclk_rst_n                                (i_hqm_sip_rf_dir_wb0_wclk_rst_n),
       .rf_dir_wb0_we                                        (i_hqm_sip_rf_dir_wb0_we),
       .rf_dir_wb0_waddr                                     (i_hqm_sip_rf_dir_wb0_waddr),
       .rf_dir_wb0_wdata                                     (i_hqm_sip_rf_dir_wb0_wdata),
       .rf_dir_wb0_rclk                                      (i_hqm_sip_rf_dir_wb0_rclk),
       .rf_dir_wb0_rclk_rst_n                                (i_hqm_sip_rf_dir_wb0_rclk_rst_n),
       .rf_dir_wb0_re                                        (i_hqm_sip_rf_dir_wb0_re),
       .rf_dir_wb0_raddr                                     (i_hqm_sip_rf_dir_wb0_raddr),
       .rf_dir_wb0_rdata                                     (i_hqm_system_mem_rf_dir_wb0_rdata),
       .rf_dir_wb0_isol_en                                   (i_hqm_sip_pgcb_isol_en),
       .rf_dir_wb0_pwr_enable_b_in                           (i_hqm_system_mem_rf_dir_rply_req_fifo_mem_pwr_enable_b_out),
       .rf_dir_wb0_pwr_enable_b_out                          (i_hqm_system_mem_rf_dir_wb0_pwr_enable_b_out),
       .rf_dir_wb1_wclk                                      (i_hqm_sip_rf_dir_wb1_wclk),
       .rf_dir_wb1_wclk_rst_n                                (i_hqm_sip_rf_dir_wb1_wclk_rst_n),
       .rf_dir_wb1_we                                        (i_hqm_sip_rf_dir_wb1_we),
       .rf_dir_wb1_waddr                                     (i_hqm_sip_rf_dir_wb1_waddr),
       .rf_dir_wb1_wdata                                     (i_hqm_sip_rf_dir_wb1_wdata),
       .rf_dir_wb1_rclk                                      (i_hqm_sip_rf_dir_wb1_rclk),
       .rf_dir_wb1_rclk_rst_n                                (i_hqm_sip_rf_dir_wb1_rclk_rst_n),
       .rf_dir_wb1_re                                        (i_hqm_sip_rf_dir_wb1_re),
       .rf_dir_wb1_raddr                                     (i_hqm_sip_rf_dir_wb1_raddr),
       .rf_dir_wb1_rdata                                     (i_hqm_system_mem_rf_dir_wb1_rdata),
       .rf_dir_wb1_isol_en                                   (i_hqm_sip_pgcb_isol_en),
       .rf_dir_wb1_pwr_enable_b_in                           (i_hqm_system_mem_rf_dir_wb0_pwr_enable_b_out),
       .rf_dir_wb1_pwr_enable_b_out                          (i_hqm_system_mem_rf_dir_wb1_pwr_enable_b_out),
       .rf_dir_wb2_wclk                                      (i_hqm_sip_rf_dir_wb2_wclk),
       .rf_dir_wb2_wclk_rst_n                                (i_hqm_sip_rf_dir_wb2_wclk_rst_n),
       .rf_dir_wb2_we                                        (i_hqm_sip_rf_dir_wb2_we),
       .rf_dir_wb2_waddr                                     (i_hqm_sip_rf_dir_wb2_waddr),
       .rf_dir_wb2_wdata                                     (i_hqm_sip_rf_dir_wb2_wdata),
       .rf_dir_wb2_rclk                                      (i_hqm_sip_rf_dir_wb2_rclk),
       .rf_dir_wb2_rclk_rst_n                                (i_hqm_sip_rf_dir_wb2_rclk_rst_n),
       .rf_dir_wb2_re                                        (i_hqm_sip_rf_dir_wb2_re),
       .rf_dir_wb2_raddr                                     (i_hqm_sip_rf_dir_wb2_raddr),
       .rf_dir_wb2_rdata                                     (i_hqm_system_mem_rf_dir_wb2_rdata),
       .rf_dir_wb2_isol_en                                   (i_hqm_sip_pgcb_isol_en),
       .rf_dir_wb2_pwr_enable_b_in                           (i_hqm_system_mem_rf_dir_wb1_pwr_enable_b_out),
       .rf_dir_wb2_pwr_enable_b_out                          (i_hqm_system_mem_rf_dir_wb2_pwr_enable_b_out),
       .rf_hcw_enq_w_rx_sync_mem_wclk                        (i_hqm_sip_rf_hcw_enq_w_rx_sync_mem_wclk),
       .rf_hcw_enq_w_rx_sync_mem_wclk_rst_n                  (i_hqm_sip_rf_hcw_enq_w_rx_sync_mem_wclk_rst_n),
       .rf_hcw_enq_w_rx_sync_mem_we                          (i_hqm_sip_rf_hcw_enq_w_rx_sync_mem_we),
       .rf_hcw_enq_w_rx_sync_mem_waddr                       (i_hqm_sip_rf_hcw_enq_w_rx_sync_mem_waddr),
       .rf_hcw_enq_w_rx_sync_mem_wdata                       (i_hqm_sip_rf_hcw_enq_w_rx_sync_mem_wdata),
       .rf_hcw_enq_w_rx_sync_mem_rclk                        (i_hqm_sip_rf_hcw_enq_w_rx_sync_mem_rclk),
       .rf_hcw_enq_w_rx_sync_mem_rclk_rst_n                  (i_hqm_sip_rf_hcw_enq_w_rx_sync_mem_rclk_rst_n),
       .rf_hcw_enq_w_rx_sync_mem_re                          (i_hqm_sip_rf_hcw_enq_w_rx_sync_mem_re),
       .rf_hcw_enq_w_rx_sync_mem_raddr                       (i_hqm_sip_rf_hcw_enq_w_rx_sync_mem_raddr),
       .rf_hcw_enq_w_rx_sync_mem_rdata                       (i_hqm_system_mem_rf_hcw_enq_w_rx_sync_mem_rdata),
       .rf_hcw_enq_w_rx_sync_mem_isol_en                     (i_hqm_sip_pgcb_isol_en),
       .rf_hcw_enq_w_rx_sync_mem_pwr_enable_b_in             (i_hqm_system_mem_rf_hcw_enq_fifo_pwr_enable_b_out),
       .rf_hcw_enq_w_rx_sync_mem_pwr_enable_b_out            (i_hqm_system_mem_rf_hcw_enq_w_rx_sync_mem_pwr_enable_b_out),
       .rf_hist_list_a_minmax_wclk                           (i_hqm_sip_rf_hist_list_a_minmax_wclk),
       .rf_hist_list_a_minmax_wclk_rst_n                     (i_hqm_sip_rf_hist_list_a_minmax_wclk_rst_n),
       .rf_hist_list_a_minmax_we                             (i_hqm_sip_rf_hist_list_a_minmax_we),
       .rf_hist_list_a_minmax_waddr                          (i_hqm_sip_rf_hist_list_a_minmax_waddr),
       .rf_hist_list_a_minmax_wdata                          (i_hqm_sip_rf_hist_list_a_minmax_wdata),
       .rf_hist_list_a_minmax_rclk                           (i_hqm_sip_rf_hist_list_a_minmax_rclk),
       .rf_hist_list_a_minmax_rclk_rst_n                     (i_hqm_sip_rf_hist_list_a_minmax_rclk_rst_n),
       .rf_hist_list_a_minmax_re                             (i_hqm_sip_rf_hist_list_a_minmax_re),
       .rf_hist_list_a_minmax_raddr                          (i_hqm_sip_rf_hist_list_a_minmax_raddr),
       .rf_hist_list_a_minmax_rdata                          (i_hqm_system_mem_rf_hist_list_a_minmax_rdata),
       .rf_hist_list_a_minmax_isol_en                        (i_hqm_sip_pgcb_isol_en),
       .rf_hist_list_a_minmax_pwr_enable_b_in                (i_hqm_system_mem_rf_hcw_enq_w_rx_sync_mem_pwr_enable_b_out),
       .rf_hist_list_a_minmax_pwr_enable_b_out               (i_hqm_system_mem_rf_hist_list_a_minmax_pwr_enable_b_out),
       .rf_hist_list_a_ptr_wclk                              (i_hqm_sip_rf_hist_list_a_ptr_wclk),
       .rf_hist_list_a_ptr_wclk_rst_n                        (i_hqm_sip_rf_hist_list_a_ptr_wclk_rst_n),
       .rf_hist_list_a_ptr_we                                (i_hqm_sip_rf_hist_list_a_ptr_we),
       .rf_hist_list_a_ptr_waddr                             (i_hqm_sip_rf_hist_list_a_ptr_waddr),
       .rf_hist_list_a_ptr_wdata                             (i_hqm_sip_rf_hist_list_a_ptr_wdata),
       .rf_hist_list_a_ptr_rclk                              (i_hqm_sip_rf_hist_list_a_ptr_rclk),
       .rf_hist_list_a_ptr_rclk_rst_n                        (i_hqm_sip_rf_hist_list_a_ptr_rclk_rst_n),
       .rf_hist_list_a_ptr_re                                (i_hqm_sip_rf_hist_list_a_ptr_re),
       .rf_hist_list_a_ptr_raddr                             (i_hqm_sip_rf_hist_list_a_ptr_raddr),
       .rf_hist_list_a_ptr_rdata                             (i_hqm_system_mem_rf_hist_list_a_ptr_rdata),
       .rf_hist_list_a_ptr_isol_en                           (i_hqm_sip_pgcb_isol_en),
       .rf_hist_list_a_ptr_pwr_enable_b_in                   (i_hqm_system_mem_rf_hist_list_a_minmax_pwr_enable_b_out),
       .rf_hist_list_a_ptr_pwr_enable_b_out                  (i_hqm_system_mem_rf_hist_list_a_ptr_pwr_enable_b_out),
       .rf_hist_list_minmax_wclk                             (i_hqm_sip_rf_hist_list_minmax_wclk),
       .rf_hist_list_minmax_wclk_rst_n                       (i_hqm_sip_rf_hist_list_minmax_wclk_rst_n),
       .rf_hist_list_minmax_we                               (i_hqm_sip_rf_hist_list_minmax_we),
       .rf_hist_list_minmax_waddr                            (i_hqm_sip_rf_hist_list_minmax_waddr),
       .rf_hist_list_minmax_wdata                            (i_hqm_sip_rf_hist_list_minmax_wdata),
       .rf_hist_list_minmax_rclk                             (i_hqm_sip_rf_hist_list_minmax_rclk),
       .rf_hist_list_minmax_rclk_rst_n                       (i_hqm_sip_rf_hist_list_minmax_rclk_rst_n),
       .rf_hist_list_minmax_re                               (i_hqm_sip_rf_hist_list_minmax_re),
       .rf_hist_list_minmax_raddr                            (i_hqm_sip_rf_hist_list_minmax_raddr),
       .rf_hist_list_minmax_rdata                            (i_hqm_system_mem_rf_hist_list_minmax_rdata),
       .rf_hist_list_minmax_isol_en                          (i_hqm_sip_pgcb_isol_en),
       .rf_hist_list_minmax_pwr_enable_b_in                  (i_hqm_system_mem_rf_hist_list_a_ptr_pwr_enable_b_out),
       .rf_hist_list_minmax_pwr_enable_b_out                 (i_hqm_system_mem_rf_hist_list_minmax_pwr_enable_b_out),
       .rf_hist_list_ptr_wclk                                (i_hqm_sip_rf_hist_list_ptr_wclk),
       .rf_hist_list_ptr_wclk_rst_n                          (i_hqm_sip_rf_hist_list_ptr_wclk_rst_n),
       .rf_hist_list_ptr_we                                  (i_hqm_sip_rf_hist_list_ptr_we),
       .rf_hist_list_ptr_waddr                               (i_hqm_sip_rf_hist_list_ptr_waddr),
       .rf_hist_list_ptr_wdata                               (i_hqm_sip_rf_hist_list_ptr_wdata),
       .rf_hist_list_ptr_rclk                                (i_hqm_sip_rf_hist_list_ptr_rclk),
       .rf_hist_list_ptr_rclk_rst_n                          (i_hqm_sip_rf_hist_list_ptr_rclk_rst_n),
       .rf_hist_list_ptr_re                                  (i_hqm_sip_rf_hist_list_ptr_re),
       .rf_hist_list_ptr_raddr                               (i_hqm_sip_rf_hist_list_ptr_raddr),
       .rf_hist_list_ptr_rdata                               (i_hqm_system_mem_rf_hist_list_ptr_rdata),
       .rf_hist_list_ptr_isol_en                             (i_hqm_sip_pgcb_isol_en),
       .rf_hist_list_ptr_pwr_enable_b_in                     (i_hqm_system_mem_rf_hist_list_minmax_pwr_enable_b_out),
       .rf_hist_list_ptr_pwr_enable_b_out                    (i_hqm_system_mem_rf_hist_list_ptr_pwr_enable_b_out),
       .rf_ldb_cq_depth_wclk                                 (i_hqm_sip_rf_ldb_cq_depth_wclk),
       .rf_ldb_cq_depth_wclk_rst_n                           (i_hqm_sip_rf_ldb_cq_depth_wclk_rst_n),
       .rf_ldb_cq_depth_we                                   (i_hqm_sip_rf_ldb_cq_depth_we),
       .rf_ldb_cq_depth_waddr                                (i_hqm_sip_rf_ldb_cq_depth_waddr),
       .rf_ldb_cq_depth_wdata                                (i_hqm_sip_rf_ldb_cq_depth_wdata),
       .rf_ldb_cq_depth_rclk                                 (i_hqm_sip_rf_ldb_cq_depth_rclk),
       .rf_ldb_cq_depth_rclk_rst_n                           (i_hqm_sip_rf_ldb_cq_depth_rclk_rst_n),
       .rf_ldb_cq_depth_re                                   (i_hqm_sip_rf_ldb_cq_depth_re),
       .rf_ldb_cq_depth_raddr                                (i_hqm_sip_rf_ldb_cq_depth_raddr),
       .rf_ldb_cq_depth_rdata                                (i_hqm_system_mem_rf_ldb_cq_depth_rdata),
       .rf_ldb_cq_depth_isol_en                              (i_hqm_sip_pgcb_isol_en),
       .rf_ldb_cq_depth_pwr_enable_b_in                      (i_hqm_system_mem_rf_hist_list_ptr_pwr_enable_b_out),
       .rf_ldb_cq_depth_pwr_enable_b_out                     (i_hqm_system_mem_rf_ldb_cq_depth_pwr_enable_b_out),
       .rf_ldb_cq_intr_thresh_wclk                           (i_hqm_sip_rf_ldb_cq_intr_thresh_wclk),
       .rf_ldb_cq_intr_thresh_wclk_rst_n                     (i_hqm_sip_rf_ldb_cq_intr_thresh_wclk_rst_n),
       .rf_ldb_cq_intr_thresh_we                             (i_hqm_sip_rf_ldb_cq_intr_thresh_we),
       .rf_ldb_cq_intr_thresh_waddr                          (i_hqm_sip_rf_ldb_cq_intr_thresh_waddr),
       .rf_ldb_cq_intr_thresh_wdata                          (i_hqm_sip_rf_ldb_cq_intr_thresh_wdata),
       .rf_ldb_cq_intr_thresh_rclk                           (i_hqm_sip_rf_ldb_cq_intr_thresh_rclk),
       .rf_ldb_cq_intr_thresh_rclk_rst_n                     (i_hqm_sip_rf_ldb_cq_intr_thresh_rclk_rst_n),
       .rf_ldb_cq_intr_thresh_re                             (i_hqm_sip_rf_ldb_cq_intr_thresh_re),
       .rf_ldb_cq_intr_thresh_raddr                          (i_hqm_sip_rf_ldb_cq_intr_thresh_raddr),
       .rf_ldb_cq_intr_thresh_rdata                          (i_hqm_system_mem_rf_ldb_cq_intr_thresh_rdata),
       .rf_ldb_cq_intr_thresh_isol_en                        (i_hqm_sip_pgcb_isol_en),
       .rf_ldb_cq_intr_thresh_pwr_enable_b_in                (i_hqm_system_mem_rf_ldb_cq_depth_pwr_enable_b_out),
       .rf_ldb_cq_intr_thresh_pwr_enable_b_out               (i_hqm_system_mem_rf_ldb_cq_intr_thresh_pwr_enable_b_out),
       .rf_ldb_cq_on_off_threshold_wclk                      (i_hqm_sip_rf_ldb_cq_on_off_threshold_wclk),
       .rf_ldb_cq_on_off_threshold_wclk_rst_n                (i_hqm_sip_rf_ldb_cq_on_off_threshold_wclk_rst_n),
       .rf_ldb_cq_on_off_threshold_we                        (i_hqm_sip_rf_ldb_cq_on_off_threshold_we),
       .rf_ldb_cq_on_off_threshold_waddr                     (i_hqm_sip_rf_ldb_cq_on_off_threshold_waddr),
       .rf_ldb_cq_on_off_threshold_wdata                     (i_hqm_sip_rf_ldb_cq_on_off_threshold_wdata),
       .rf_ldb_cq_on_off_threshold_rclk                      (i_hqm_sip_rf_ldb_cq_on_off_threshold_rclk),
       .rf_ldb_cq_on_off_threshold_rclk_rst_n                (i_hqm_sip_rf_ldb_cq_on_off_threshold_rclk_rst_n),
       .rf_ldb_cq_on_off_threshold_re                        (i_hqm_sip_rf_ldb_cq_on_off_threshold_re),
       .rf_ldb_cq_on_off_threshold_raddr                     (i_hqm_sip_rf_ldb_cq_on_off_threshold_raddr),
       .rf_ldb_cq_on_off_threshold_rdata                     (i_hqm_system_mem_rf_ldb_cq_on_off_threshold_rdata),
       .rf_ldb_cq_on_off_threshold_isol_en                   (i_hqm_sip_pgcb_isol_en),
       .rf_ldb_cq_on_off_threshold_pwr_enable_b_in           (i_hqm_system_mem_rf_ldb_cq_intr_thresh_pwr_enable_b_out),
       .rf_ldb_cq_on_off_threshold_pwr_enable_b_out          (i_hqm_system_mem_rf_ldb_cq_on_off_threshold_pwr_enable_b_out),
       .rf_ldb_cq_token_depth_select_wclk                    (i_hqm_sip_rf_ldb_cq_token_depth_select_wclk),
       .rf_ldb_cq_token_depth_select_wclk_rst_n              (i_hqm_sip_rf_ldb_cq_token_depth_select_wclk_rst_n),
       .rf_ldb_cq_token_depth_select_we                      (i_hqm_sip_rf_ldb_cq_token_depth_select_we),
       .rf_ldb_cq_token_depth_select_waddr                   (i_hqm_sip_rf_ldb_cq_token_depth_select_waddr),
       .rf_ldb_cq_token_depth_select_wdata                   (i_hqm_sip_rf_ldb_cq_token_depth_select_wdata),
       .rf_ldb_cq_token_depth_select_rclk                    (i_hqm_sip_rf_ldb_cq_token_depth_select_rclk),
       .rf_ldb_cq_token_depth_select_rclk_rst_n              (i_hqm_sip_rf_ldb_cq_token_depth_select_rclk_rst_n),
       .rf_ldb_cq_token_depth_select_re                      (i_hqm_sip_rf_ldb_cq_token_depth_select_re),
       .rf_ldb_cq_token_depth_select_raddr                   (i_hqm_sip_rf_ldb_cq_token_depth_select_raddr),
       .rf_ldb_cq_token_depth_select_rdata                   (i_hqm_system_mem_rf_ldb_cq_token_depth_select_rdata),
       .rf_ldb_cq_token_depth_select_isol_en                 (i_hqm_sip_pgcb_isol_en),
       .rf_ldb_cq_token_depth_select_pwr_enable_b_in         (i_hqm_system_mem_rf_ldb_cq_on_off_threshold_pwr_enable_b_out),
       .rf_ldb_cq_token_depth_select_pwr_enable_b_out        (i_hqm_system_mem_rf_ldb_cq_token_depth_select_pwr_enable_b_out),
       .rf_ldb_cq_wptr_wclk                                  (i_hqm_sip_rf_ldb_cq_wptr_wclk),
       .rf_ldb_cq_wptr_wclk_rst_n                            (i_hqm_sip_rf_ldb_cq_wptr_wclk_rst_n),
       .rf_ldb_cq_wptr_we                                    (i_hqm_sip_rf_ldb_cq_wptr_we),
       .rf_ldb_cq_wptr_waddr                                 (i_hqm_sip_rf_ldb_cq_wptr_waddr),
       .rf_ldb_cq_wptr_wdata                                 (i_hqm_sip_rf_ldb_cq_wptr_wdata),
       .rf_ldb_cq_wptr_rclk                                  (i_hqm_sip_rf_ldb_cq_wptr_rclk),
       .rf_ldb_cq_wptr_rclk_rst_n                            (i_hqm_sip_rf_ldb_cq_wptr_rclk_rst_n),
       .rf_ldb_cq_wptr_re                                    (i_hqm_sip_rf_ldb_cq_wptr_re),
       .rf_ldb_cq_wptr_raddr                                 (i_hqm_sip_rf_ldb_cq_wptr_raddr),
       .rf_ldb_cq_wptr_rdata                                 (i_hqm_system_mem_rf_ldb_cq_wptr_rdata),
       .rf_ldb_cq_wptr_isol_en                               (i_hqm_sip_pgcb_isol_en),
       .rf_ldb_cq_wptr_pwr_enable_b_in                       (i_hqm_system_mem_rf_ldb_cq_token_depth_select_pwr_enable_b_out),
       .rf_ldb_cq_wptr_pwr_enable_b_out                      (i_hqm_system_mem_rf_ldb_cq_wptr_pwr_enable_b_out),
       .rf_ldb_rply_req_fifo_mem_wclk                        (i_hqm_sip_rf_ldb_rply_req_fifo_mem_wclk),
       .rf_ldb_rply_req_fifo_mem_wclk_rst_n                  (i_hqm_sip_rf_ldb_rply_req_fifo_mem_wclk_rst_n),
       .rf_ldb_rply_req_fifo_mem_we                          (i_hqm_sip_rf_ldb_rply_req_fifo_mem_we),
       .rf_ldb_rply_req_fifo_mem_waddr                       (i_hqm_sip_rf_ldb_rply_req_fifo_mem_waddr),
       .rf_ldb_rply_req_fifo_mem_wdata                       (i_hqm_sip_rf_ldb_rply_req_fifo_mem_wdata),
       .rf_ldb_rply_req_fifo_mem_rclk                        (i_hqm_sip_rf_ldb_rply_req_fifo_mem_rclk),
       .rf_ldb_rply_req_fifo_mem_rclk_rst_n                  (i_hqm_sip_rf_ldb_rply_req_fifo_mem_rclk_rst_n),
       .rf_ldb_rply_req_fifo_mem_re                          (i_hqm_sip_rf_ldb_rply_req_fifo_mem_re),
       .rf_ldb_rply_req_fifo_mem_raddr                       (i_hqm_sip_rf_ldb_rply_req_fifo_mem_raddr),
       .rf_ldb_rply_req_fifo_mem_rdata                       (i_hqm_system_mem_rf_ldb_rply_req_fifo_mem_rdata),
       .rf_ldb_rply_req_fifo_mem_isol_en                     (i_hqm_sip_pgcb_isol_en),
       .rf_ldb_rply_req_fifo_mem_pwr_enable_b_in             (i_hqm_system_mem_rf_ldb_cq_wptr_pwr_enable_b_out),
       .rf_ldb_rply_req_fifo_mem_pwr_enable_b_out            (i_hqm_system_mem_rf_ldb_rply_req_fifo_mem_pwr_enable_b_out),
       .rf_ldb_wb0_wclk                                      (i_hqm_sip_rf_ldb_wb0_wclk),
       .rf_ldb_wb0_wclk_rst_n                                (i_hqm_sip_rf_ldb_wb0_wclk_rst_n),
       .rf_ldb_wb0_we                                        (i_hqm_sip_rf_ldb_wb0_we),
       .rf_ldb_wb0_waddr                                     (i_hqm_sip_rf_ldb_wb0_waddr),
       .rf_ldb_wb0_wdata                                     (i_hqm_sip_rf_ldb_wb0_wdata),
       .rf_ldb_wb0_rclk                                      (i_hqm_sip_rf_ldb_wb0_rclk),
       .rf_ldb_wb0_rclk_rst_n                                (i_hqm_sip_rf_ldb_wb0_rclk_rst_n),
       .rf_ldb_wb0_re                                        (i_hqm_sip_rf_ldb_wb0_re),
       .rf_ldb_wb0_raddr                                     (i_hqm_sip_rf_ldb_wb0_raddr),
       .rf_ldb_wb0_rdata                                     (i_hqm_system_mem_rf_ldb_wb0_rdata),
       .rf_ldb_wb0_isol_en                                   (i_hqm_sip_pgcb_isol_en),
       .rf_ldb_wb0_pwr_enable_b_in                           (i_hqm_system_mem_rf_ldb_rply_req_fifo_mem_pwr_enable_b_out),
       .rf_ldb_wb0_pwr_enable_b_out                          (i_hqm_system_mem_rf_ldb_wb0_pwr_enable_b_out),
       .rf_ldb_wb1_wclk                                      (i_hqm_sip_rf_ldb_wb1_wclk),
       .rf_ldb_wb1_wclk_rst_n                                (i_hqm_sip_rf_ldb_wb1_wclk_rst_n),
       .rf_ldb_wb1_we                                        (i_hqm_sip_rf_ldb_wb1_we),
       .rf_ldb_wb1_waddr                                     (i_hqm_sip_rf_ldb_wb1_waddr),
       .rf_ldb_wb1_wdata                                     (i_hqm_sip_rf_ldb_wb1_wdata),
       .rf_ldb_wb1_rclk                                      (i_hqm_sip_rf_ldb_wb1_rclk),
       .rf_ldb_wb1_rclk_rst_n                                (i_hqm_sip_rf_ldb_wb1_rclk_rst_n),
       .rf_ldb_wb1_re                                        (i_hqm_sip_rf_ldb_wb1_re),
       .rf_ldb_wb1_raddr                                     (i_hqm_sip_rf_ldb_wb1_raddr),
       .rf_ldb_wb1_rdata                                     (i_hqm_system_mem_rf_ldb_wb1_rdata),
       .rf_ldb_wb1_isol_en                                   (i_hqm_sip_pgcb_isol_en),
       .rf_ldb_wb1_pwr_enable_b_in                           (i_hqm_system_mem_rf_ldb_wb0_pwr_enable_b_out),
       .rf_ldb_wb1_pwr_enable_b_out                          (i_hqm_system_mem_rf_ldb_wb1_pwr_enable_b_out),
       .rf_ldb_wb2_wclk                                      (i_hqm_sip_rf_ldb_wb2_wclk),
       .rf_ldb_wb2_wclk_rst_n                                (i_hqm_sip_rf_ldb_wb2_wclk_rst_n),
       .rf_ldb_wb2_we                                        (i_hqm_sip_rf_ldb_wb2_we),
       .rf_ldb_wb2_waddr                                     (i_hqm_sip_rf_ldb_wb2_waddr),
       .rf_ldb_wb2_wdata                                     (i_hqm_sip_rf_ldb_wb2_wdata),
       .rf_ldb_wb2_rclk                                      (i_hqm_sip_rf_ldb_wb2_rclk),
       .rf_ldb_wb2_rclk_rst_n                                (i_hqm_sip_rf_ldb_wb2_rclk_rst_n),
       .rf_ldb_wb2_re                                        (i_hqm_sip_rf_ldb_wb2_re),
       .rf_ldb_wb2_raddr                                     (i_hqm_sip_rf_ldb_wb2_raddr),
       .rf_ldb_wb2_rdata                                     (i_hqm_system_mem_rf_ldb_wb2_rdata),
       .rf_ldb_wb2_isol_en                                   (i_hqm_sip_pgcb_isol_en),
       .rf_ldb_wb2_pwr_enable_b_in                           (i_hqm_system_mem_rf_ldb_wb1_pwr_enable_b_out),
       .rf_ldb_wb2_pwr_enable_b_out                          (i_hqm_system_mem_rf_ldb_wb2_pwr_enable_b_out),
       .rf_lsp_reordercmp_fifo_mem_wclk                      (i_hqm_sip_rf_lsp_reordercmp_fifo_mem_wclk),
       .rf_lsp_reordercmp_fifo_mem_wclk_rst_n                (i_hqm_sip_rf_lsp_reordercmp_fifo_mem_wclk_rst_n),
       .rf_lsp_reordercmp_fifo_mem_we                        (i_hqm_sip_rf_lsp_reordercmp_fifo_mem_we),
       .rf_lsp_reordercmp_fifo_mem_waddr                     (i_hqm_sip_rf_lsp_reordercmp_fifo_mem_waddr),
       .rf_lsp_reordercmp_fifo_mem_wdata                     (i_hqm_sip_rf_lsp_reordercmp_fifo_mem_wdata),
       .rf_lsp_reordercmp_fifo_mem_rclk                      (i_hqm_sip_rf_lsp_reordercmp_fifo_mem_rclk),
       .rf_lsp_reordercmp_fifo_mem_rclk_rst_n                (i_hqm_sip_rf_lsp_reordercmp_fifo_mem_rclk_rst_n),
       .rf_lsp_reordercmp_fifo_mem_re                        (i_hqm_sip_rf_lsp_reordercmp_fifo_mem_re),
       .rf_lsp_reordercmp_fifo_mem_raddr                     (i_hqm_sip_rf_lsp_reordercmp_fifo_mem_raddr),
       .rf_lsp_reordercmp_fifo_mem_rdata                     (i_hqm_system_mem_rf_lsp_reordercmp_fifo_mem_rdata),
       .rf_lsp_reordercmp_fifo_mem_isol_en                   (i_hqm_sip_pgcb_isol_en),
       .rf_lsp_reordercmp_fifo_mem_pwr_enable_b_in           (i_hqm_system_mem_rf_ldb_wb2_pwr_enable_b_out),
       .rf_lsp_reordercmp_fifo_mem_pwr_enable_b_out          (i_hqm_system_mem_rf_lsp_reordercmp_fifo_mem_pwr_enable_b_out),
       .rf_lut_dir_cq2vf_pf_ro_wclk                          (i_hqm_sip_rf_lut_dir_cq2vf_pf_ro_wclk),
       .rf_lut_dir_cq2vf_pf_ro_wclk_rst_n                    (i_hqm_sip_rf_lut_dir_cq2vf_pf_ro_wclk_rst_n),
       .rf_lut_dir_cq2vf_pf_ro_we                            (i_hqm_sip_rf_lut_dir_cq2vf_pf_ro_we),
       .rf_lut_dir_cq2vf_pf_ro_waddr                         (i_hqm_sip_rf_lut_dir_cq2vf_pf_ro_waddr),
       .rf_lut_dir_cq2vf_pf_ro_wdata                         (i_hqm_sip_rf_lut_dir_cq2vf_pf_ro_wdata),
       .rf_lut_dir_cq2vf_pf_ro_rclk                          (i_hqm_sip_rf_lut_dir_cq2vf_pf_ro_rclk),
       .rf_lut_dir_cq2vf_pf_ro_rclk_rst_n                    (i_hqm_sip_rf_lut_dir_cq2vf_pf_ro_rclk_rst_n),
       .rf_lut_dir_cq2vf_pf_ro_re                            (i_hqm_sip_rf_lut_dir_cq2vf_pf_ro_re),
       .rf_lut_dir_cq2vf_pf_ro_raddr                         (i_hqm_sip_rf_lut_dir_cq2vf_pf_ro_raddr),
       .rf_lut_dir_cq2vf_pf_ro_rdata                         (i_hqm_system_mem_rf_lut_dir_cq2vf_pf_ro_rdata),
       .rf_lut_dir_cq2vf_pf_ro_isol_en                       (i_hqm_sip_pgcb_isol_en),
       .rf_lut_dir_cq2vf_pf_ro_pwr_enable_b_in               (i_hqm_system_mem_rf_lsp_reordercmp_fifo_mem_pwr_enable_b_out),
       .rf_lut_dir_cq2vf_pf_ro_pwr_enable_b_out              (i_hqm_system_mem_rf_lut_dir_cq2vf_pf_ro_pwr_enable_b_out),
       .rf_lut_dir_cq_addr_l_wclk                            (i_hqm_sip_rf_lut_dir_cq_addr_l_wclk),
       .rf_lut_dir_cq_addr_l_wclk_rst_n                      (i_hqm_sip_rf_lut_dir_cq_addr_l_wclk_rst_n),
       .rf_lut_dir_cq_addr_l_we                              (i_hqm_sip_rf_lut_dir_cq_addr_l_we),
       .rf_lut_dir_cq_addr_l_waddr                           (i_hqm_sip_rf_lut_dir_cq_addr_l_waddr),
       .rf_lut_dir_cq_addr_l_wdata                           (i_hqm_sip_rf_lut_dir_cq_addr_l_wdata),
       .rf_lut_dir_cq_addr_l_rclk                            (i_hqm_sip_rf_lut_dir_cq_addr_l_rclk),
       .rf_lut_dir_cq_addr_l_rclk_rst_n                      (i_hqm_sip_rf_lut_dir_cq_addr_l_rclk_rst_n),
       .rf_lut_dir_cq_addr_l_re                              (i_hqm_sip_rf_lut_dir_cq_addr_l_re),
       .rf_lut_dir_cq_addr_l_raddr                           (i_hqm_sip_rf_lut_dir_cq_addr_l_raddr),
       .rf_lut_dir_cq_addr_l_rdata                           (i_hqm_system_mem_rf_lut_dir_cq_addr_l_rdata),
       .rf_lut_dir_cq_addr_l_isol_en                         (i_hqm_sip_pgcb_isol_en),
       .rf_lut_dir_cq_addr_l_pwr_enable_b_in                 (i_hqm_system_mem_rf_lut_dir_cq2vf_pf_ro_pwr_enable_b_out),
       .rf_lut_dir_cq_addr_l_pwr_enable_b_out                (i_hqm_system_mem_rf_lut_dir_cq_addr_l_pwr_enable_b_out),
       .rf_lut_dir_cq_addr_u_wclk                            (i_hqm_sip_rf_lut_dir_cq_addr_u_wclk),
       .rf_lut_dir_cq_addr_u_wclk_rst_n                      (i_hqm_sip_rf_lut_dir_cq_addr_u_wclk_rst_n),
       .rf_lut_dir_cq_addr_u_we                              (i_hqm_sip_rf_lut_dir_cq_addr_u_we),
       .rf_lut_dir_cq_addr_u_waddr                           (i_hqm_sip_rf_lut_dir_cq_addr_u_waddr),
       .rf_lut_dir_cq_addr_u_wdata                           (i_hqm_sip_rf_lut_dir_cq_addr_u_wdata),
       .rf_lut_dir_cq_addr_u_rclk                            (i_hqm_sip_rf_lut_dir_cq_addr_u_rclk),
       .rf_lut_dir_cq_addr_u_rclk_rst_n                      (i_hqm_sip_rf_lut_dir_cq_addr_u_rclk_rst_n),
       .rf_lut_dir_cq_addr_u_re                              (i_hqm_sip_rf_lut_dir_cq_addr_u_re),
       .rf_lut_dir_cq_addr_u_raddr                           (i_hqm_sip_rf_lut_dir_cq_addr_u_raddr),
       .rf_lut_dir_cq_addr_u_rdata                           (i_hqm_system_mem_rf_lut_dir_cq_addr_u_rdata),
       .rf_lut_dir_cq_addr_u_isol_en                         (i_hqm_sip_pgcb_isol_en),
       .rf_lut_dir_cq_addr_u_pwr_enable_b_in                 (i_hqm_system_mem_rf_lut_dir_cq_addr_l_pwr_enable_b_out),
       .rf_lut_dir_cq_addr_u_pwr_enable_b_out                (i_hqm_system_mem_rf_lut_dir_cq_addr_u_pwr_enable_b_out),
       .rf_lut_dir_cq_ai_addr_l_wclk                         (i_hqm_sip_rf_lut_dir_cq_ai_addr_l_wclk),
       .rf_lut_dir_cq_ai_addr_l_wclk_rst_n                   (i_hqm_sip_rf_lut_dir_cq_ai_addr_l_wclk_rst_n),
       .rf_lut_dir_cq_ai_addr_l_we                           (i_hqm_sip_rf_lut_dir_cq_ai_addr_l_we),
       .rf_lut_dir_cq_ai_addr_l_waddr                        (i_hqm_sip_rf_lut_dir_cq_ai_addr_l_waddr),
       .rf_lut_dir_cq_ai_addr_l_wdata                        (i_hqm_sip_rf_lut_dir_cq_ai_addr_l_wdata),
       .rf_lut_dir_cq_ai_addr_l_rclk                         (i_hqm_sip_rf_lut_dir_cq_ai_addr_l_rclk),
       .rf_lut_dir_cq_ai_addr_l_rclk_rst_n                   (i_hqm_sip_rf_lut_dir_cq_ai_addr_l_rclk_rst_n),
       .rf_lut_dir_cq_ai_addr_l_re                           (i_hqm_sip_rf_lut_dir_cq_ai_addr_l_re),
       .rf_lut_dir_cq_ai_addr_l_raddr                        (i_hqm_sip_rf_lut_dir_cq_ai_addr_l_raddr),
       .rf_lut_dir_cq_ai_addr_l_rdata                        (i_hqm_system_mem_rf_lut_dir_cq_ai_addr_l_rdata),
       .rf_lut_dir_cq_ai_addr_l_isol_en                      (i_hqm_sip_pgcb_isol_en),
       .rf_lut_dir_cq_ai_addr_l_pwr_enable_b_in              (i_hqm_system_mem_rf_lut_dir_cq_addr_u_pwr_enable_b_out),
       .rf_lut_dir_cq_ai_addr_l_pwr_enable_b_out             (i_hqm_system_mem_rf_lut_dir_cq_ai_addr_l_pwr_enable_b_out),
       .rf_lut_dir_cq_ai_addr_u_wclk                         (i_hqm_sip_rf_lut_dir_cq_ai_addr_u_wclk),
       .rf_lut_dir_cq_ai_addr_u_wclk_rst_n                   (i_hqm_sip_rf_lut_dir_cq_ai_addr_u_wclk_rst_n),
       .rf_lut_dir_cq_ai_addr_u_we                           (i_hqm_sip_rf_lut_dir_cq_ai_addr_u_we),
       .rf_lut_dir_cq_ai_addr_u_waddr                        (i_hqm_sip_rf_lut_dir_cq_ai_addr_u_waddr),
       .rf_lut_dir_cq_ai_addr_u_wdata                        (i_hqm_sip_rf_lut_dir_cq_ai_addr_u_wdata),
       .rf_lut_dir_cq_ai_addr_u_rclk                         (i_hqm_sip_rf_lut_dir_cq_ai_addr_u_rclk),
       .rf_lut_dir_cq_ai_addr_u_rclk_rst_n                   (i_hqm_sip_rf_lut_dir_cq_ai_addr_u_rclk_rst_n),
       .rf_lut_dir_cq_ai_addr_u_re                           (i_hqm_sip_rf_lut_dir_cq_ai_addr_u_re),
       .rf_lut_dir_cq_ai_addr_u_raddr                        (i_hqm_sip_rf_lut_dir_cq_ai_addr_u_raddr),
       .rf_lut_dir_cq_ai_addr_u_rdata                        (i_hqm_system_mem_rf_lut_dir_cq_ai_addr_u_rdata),
       .rf_lut_dir_cq_ai_addr_u_isol_en                      (i_hqm_sip_pgcb_isol_en),
       .rf_lut_dir_cq_ai_addr_u_pwr_enable_b_in              (i_hqm_system_mem_rf_lut_dir_cq_ai_addr_l_pwr_enable_b_out),
       .rf_lut_dir_cq_ai_addr_u_pwr_enable_b_out             (i_hqm_system_mem_rf_lut_dir_cq_ai_addr_u_pwr_enable_b_out),
       .rf_lut_dir_cq_ai_data_wclk                           (i_hqm_sip_rf_lut_dir_cq_ai_data_wclk),
       .rf_lut_dir_cq_ai_data_wclk_rst_n                     (i_hqm_sip_rf_lut_dir_cq_ai_data_wclk_rst_n),
       .rf_lut_dir_cq_ai_data_we                             (i_hqm_sip_rf_lut_dir_cq_ai_data_we),
       .rf_lut_dir_cq_ai_data_waddr                          (i_hqm_sip_rf_lut_dir_cq_ai_data_waddr),
       .rf_lut_dir_cq_ai_data_wdata                          (i_hqm_sip_rf_lut_dir_cq_ai_data_wdata),
       .rf_lut_dir_cq_ai_data_rclk                           (i_hqm_sip_rf_lut_dir_cq_ai_data_rclk),
       .rf_lut_dir_cq_ai_data_rclk_rst_n                     (i_hqm_sip_rf_lut_dir_cq_ai_data_rclk_rst_n),
       .rf_lut_dir_cq_ai_data_re                             (i_hqm_sip_rf_lut_dir_cq_ai_data_re),
       .rf_lut_dir_cq_ai_data_raddr                          (i_hqm_sip_rf_lut_dir_cq_ai_data_raddr),
       .rf_lut_dir_cq_ai_data_rdata                          (i_hqm_system_mem_rf_lut_dir_cq_ai_data_rdata),
       .rf_lut_dir_cq_ai_data_isol_en                        (i_hqm_sip_pgcb_isol_en),
       .rf_lut_dir_cq_ai_data_pwr_enable_b_in                (i_hqm_system_mem_rf_lut_dir_cq_ai_addr_u_pwr_enable_b_out),
       .rf_lut_dir_cq_ai_data_pwr_enable_b_out               (i_hqm_system_mem_rf_lut_dir_cq_ai_data_pwr_enable_b_out),
       .rf_lut_dir_cq_isr_wclk                               (i_hqm_sip_rf_lut_dir_cq_isr_wclk),
       .rf_lut_dir_cq_isr_wclk_rst_n                         (i_hqm_sip_rf_lut_dir_cq_isr_wclk_rst_n),
       .rf_lut_dir_cq_isr_we                                 (i_hqm_sip_rf_lut_dir_cq_isr_we),
       .rf_lut_dir_cq_isr_waddr                              (i_hqm_sip_rf_lut_dir_cq_isr_waddr),
       .rf_lut_dir_cq_isr_wdata                              (i_hqm_sip_rf_lut_dir_cq_isr_wdata),
       .rf_lut_dir_cq_isr_rclk                               (i_hqm_sip_rf_lut_dir_cq_isr_rclk),
       .rf_lut_dir_cq_isr_rclk_rst_n                         (i_hqm_sip_rf_lut_dir_cq_isr_rclk_rst_n),
       .rf_lut_dir_cq_isr_re                                 (i_hqm_sip_rf_lut_dir_cq_isr_re),
       .rf_lut_dir_cq_isr_raddr                              (i_hqm_sip_rf_lut_dir_cq_isr_raddr),
       .rf_lut_dir_cq_isr_rdata                              (i_hqm_system_mem_rf_lut_dir_cq_isr_rdata),
       .rf_lut_dir_cq_isr_isol_en                            (i_hqm_sip_pgcb_isol_en),
       .rf_lut_dir_cq_isr_pwr_enable_b_in                    (i_hqm_system_mem_rf_lut_dir_cq_ai_data_pwr_enable_b_out),
       .rf_lut_dir_cq_isr_pwr_enable_b_out                   (i_hqm_system_mem_rf_lut_dir_cq_isr_pwr_enable_b_out),
       .rf_lut_dir_cq_pasid_wclk                             (i_hqm_sip_rf_lut_dir_cq_pasid_wclk),
       .rf_lut_dir_cq_pasid_wclk_rst_n                       (i_hqm_sip_rf_lut_dir_cq_pasid_wclk_rst_n),
       .rf_lut_dir_cq_pasid_we                               (i_hqm_sip_rf_lut_dir_cq_pasid_we),
       .rf_lut_dir_cq_pasid_waddr                            (i_hqm_sip_rf_lut_dir_cq_pasid_waddr),
       .rf_lut_dir_cq_pasid_wdata                            (i_hqm_sip_rf_lut_dir_cq_pasid_wdata),
       .rf_lut_dir_cq_pasid_rclk                             (i_hqm_sip_rf_lut_dir_cq_pasid_rclk),
       .rf_lut_dir_cq_pasid_rclk_rst_n                       (i_hqm_sip_rf_lut_dir_cq_pasid_rclk_rst_n),
       .rf_lut_dir_cq_pasid_re                               (i_hqm_sip_rf_lut_dir_cq_pasid_re),
       .rf_lut_dir_cq_pasid_raddr                            (i_hqm_sip_rf_lut_dir_cq_pasid_raddr),
       .rf_lut_dir_cq_pasid_rdata                            (i_hqm_system_mem_rf_lut_dir_cq_pasid_rdata),
       .rf_lut_dir_cq_pasid_isol_en                          (i_hqm_sip_pgcb_isol_en),
       .rf_lut_dir_cq_pasid_pwr_enable_b_in                  (i_hqm_system_mem_rf_lut_dir_cq_isr_pwr_enable_b_out),
       .rf_lut_dir_cq_pasid_pwr_enable_b_out                 (i_hqm_system_mem_rf_lut_dir_cq_pasid_pwr_enable_b_out),
       .rf_lut_dir_pp2vas_wclk                               (i_hqm_sip_rf_lut_dir_pp2vas_wclk),
       .rf_lut_dir_pp2vas_wclk_rst_n                         (i_hqm_sip_rf_lut_dir_pp2vas_wclk_rst_n),
       .rf_lut_dir_pp2vas_we                                 (i_hqm_sip_rf_lut_dir_pp2vas_we),
       .rf_lut_dir_pp2vas_waddr                              (i_hqm_sip_rf_lut_dir_pp2vas_waddr),
       .rf_lut_dir_pp2vas_wdata                              (i_hqm_sip_rf_lut_dir_pp2vas_wdata),
       .rf_lut_dir_pp2vas_rclk                               (i_hqm_sip_rf_lut_dir_pp2vas_rclk),
       .rf_lut_dir_pp2vas_rclk_rst_n                         (i_hqm_sip_rf_lut_dir_pp2vas_rclk_rst_n),
       .rf_lut_dir_pp2vas_re                                 (i_hqm_sip_rf_lut_dir_pp2vas_re),
       .rf_lut_dir_pp2vas_raddr                              (i_hqm_sip_rf_lut_dir_pp2vas_raddr),
       .rf_lut_dir_pp2vas_rdata                              (i_hqm_system_mem_rf_lut_dir_pp2vas_rdata),
       .rf_lut_dir_pp2vas_isol_en                            (i_hqm_sip_pgcb_isol_en),
       .rf_lut_dir_pp2vas_pwr_enable_b_in                    (i_hqm_system_mem_rf_lut_dir_cq_pasid_pwr_enable_b_out),
       .rf_lut_dir_pp2vas_pwr_enable_b_out                   (i_hqm_system_mem_rf_lut_dir_pp2vas_pwr_enable_b_out),
       .rf_lut_dir_pp_v_wclk                                 (i_hqm_sip_rf_lut_dir_pp_v_wclk),
       .rf_lut_dir_pp_v_wclk_rst_n                           (i_hqm_sip_rf_lut_dir_pp_v_wclk_rst_n),
       .rf_lut_dir_pp_v_we                                   (i_hqm_sip_rf_lut_dir_pp_v_we),
       .rf_lut_dir_pp_v_waddr                                (i_hqm_sip_rf_lut_dir_pp_v_waddr),
       .rf_lut_dir_pp_v_wdata                                (i_hqm_sip_rf_lut_dir_pp_v_wdata),
       .rf_lut_dir_pp_v_rclk                                 (i_hqm_sip_rf_lut_dir_pp_v_rclk),
       .rf_lut_dir_pp_v_rclk_rst_n                           (i_hqm_sip_rf_lut_dir_pp_v_rclk_rst_n),
       .rf_lut_dir_pp_v_re                                   (i_hqm_sip_rf_lut_dir_pp_v_re),
       .rf_lut_dir_pp_v_raddr                                (i_hqm_sip_rf_lut_dir_pp_v_raddr),
       .rf_lut_dir_pp_v_rdata                                (i_hqm_system_mem_rf_lut_dir_pp_v_rdata),
       .rf_lut_dir_pp_v_isol_en                              (i_hqm_sip_pgcb_isol_en),
       .rf_lut_dir_pp_v_pwr_enable_b_in                      (i_hqm_system_mem_rf_lut_dir_pp2vas_pwr_enable_b_out),
       .rf_lut_dir_pp_v_pwr_enable_b_out                     (i_hqm_system_mem_rf_lut_dir_pp_v_pwr_enable_b_out),
       .rf_lut_dir_vasqid_v_wclk                             (i_hqm_sip_rf_lut_dir_vasqid_v_wclk),
       .rf_lut_dir_vasqid_v_wclk_rst_n                       (i_hqm_sip_rf_lut_dir_vasqid_v_wclk_rst_n),
       .rf_lut_dir_vasqid_v_we                               (i_hqm_sip_rf_lut_dir_vasqid_v_we),
       .rf_lut_dir_vasqid_v_waddr                            (i_hqm_sip_rf_lut_dir_vasqid_v_waddr),
       .rf_lut_dir_vasqid_v_wdata                            (i_hqm_sip_rf_lut_dir_vasqid_v_wdata),
       .rf_lut_dir_vasqid_v_rclk                             (i_hqm_sip_rf_lut_dir_vasqid_v_rclk),
       .rf_lut_dir_vasqid_v_rclk_rst_n                       (i_hqm_sip_rf_lut_dir_vasqid_v_rclk_rst_n),
       .rf_lut_dir_vasqid_v_re                               (i_hqm_sip_rf_lut_dir_vasqid_v_re),
       .rf_lut_dir_vasqid_v_raddr                            (i_hqm_sip_rf_lut_dir_vasqid_v_raddr),
       .rf_lut_dir_vasqid_v_rdata                            (i_hqm_system_mem_rf_lut_dir_vasqid_v_rdata),
       .rf_lut_dir_vasqid_v_isol_en                          (i_hqm_sip_pgcb_isol_en),
       .rf_lut_dir_vasqid_v_pwr_enable_b_in                  (i_hqm_system_mem_rf_lut_dir_pp_v_pwr_enable_b_out),
       .rf_lut_dir_vasqid_v_pwr_enable_b_out                 (i_hqm_system_mem_rf_lut_dir_vasqid_v_pwr_enable_b_out),
       .rf_lut_ldb_cq2vf_pf_ro_wclk                          (i_hqm_sip_rf_lut_ldb_cq2vf_pf_ro_wclk),
       .rf_lut_ldb_cq2vf_pf_ro_wclk_rst_n                    (i_hqm_sip_rf_lut_ldb_cq2vf_pf_ro_wclk_rst_n),
       .rf_lut_ldb_cq2vf_pf_ro_we                            (i_hqm_sip_rf_lut_ldb_cq2vf_pf_ro_we),
       .rf_lut_ldb_cq2vf_pf_ro_waddr                         (i_hqm_sip_rf_lut_ldb_cq2vf_pf_ro_waddr),
       .rf_lut_ldb_cq2vf_pf_ro_wdata                         (i_hqm_sip_rf_lut_ldb_cq2vf_pf_ro_wdata),
       .rf_lut_ldb_cq2vf_pf_ro_rclk                          (i_hqm_sip_rf_lut_ldb_cq2vf_pf_ro_rclk),
       .rf_lut_ldb_cq2vf_pf_ro_rclk_rst_n                    (i_hqm_sip_rf_lut_ldb_cq2vf_pf_ro_rclk_rst_n),
       .rf_lut_ldb_cq2vf_pf_ro_re                            (i_hqm_sip_rf_lut_ldb_cq2vf_pf_ro_re),
       .rf_lut_ldb_cq2vf_pf_ro_raddr                         (i_hqm_sip_rf_lut_ldb_cq2vf_pf_ro_raddr),
       .rf_lut_ldb_cq2vf_pf_ro_rdata                         (i_hqm_system_mem_rf_lut_ldb_cq2vf_pf_ro_rdata),
       .rf_lut_ldb_cq2vf_pf_ro_isol_en                       (i_hqm_sip_pgcb_isol_en),
       .rf_lut_ldb_cq2vf_pf_ro_pwr_enable_b_in               (i_hqm_system_mem_rf_lut_dir_vasqid_v_pwr_enable_b_out),
       .rf_lut_ldb_cq2vf_pf_ro_pwr_enable_b_out              (i_hqm_system_mem_rf_lut_ldb_cq2vf_pf_ro_pwr_enable_b_out),
       .rf_lut_ldb_cq_addr_l_wclk                            (i_hqm_sip_rf_lut_ldb_cq_addr_l_wclk),
       .rf_lut_ldb_cq_addr_l_wclk_rst_n                      (i_hqm_sip_rf_lut_ldb_cq_addr_l_wclk_rst_n),
       .rf_lut_ldb_cq_addr_l_we                              (i_hqm_sip_rf_lut_ldb_cq_addr_l_we),
       .rf_lut_ldb_cq_addr_l_waddr                           (i_hqm_sip_rf_lut_ldb_cq_addr_l_waddr),
       .rf_lut_ldb_cq_addr_l_wdata                           (i_hqm_sip_rf_lut_ldb_cq_addr_l_wdata),
       .rf_lut_ldb_cq_addr_l_rclk                            (i_hqm_sip_rf_lut_ldb_cq_addr_l_rclk),
       .rf_lut_ldb_cq_addr_l_rclk_rst_n                      (i_hqm_sip_rf_lut_ldb_cq_addr_l_rclk_rst_n),
       .rf_lut_ldb_cq_addr_l_re                              (i_hqm_sip_rf_lut_ldb_cq_addr_l_re),
       .rf_lut_ldb_cq_addr_l_raddr                           (i_hqm_sip_rf_lut_ldb_cq_addr_l_raddr),
       .rf_lut_ldb_cq_addr_l_rdata                           (i_hqm_system_mem_rf_lut_ldb_cq_addr_l_rdata),
       .rf_lut_ldb_cq_addr_l_isol_en                         (i_hqm_sip_pgcb_isol_en),
       .rf_lut_ldb_cq_addr_l_pwr_enable_b_in                 (i_hqm_system_mem_rf_lut_ldb_cq2vf_pf_ro_pwr_enable_b_out),
       .rf_lut_ldb_cq_addr_l_pwr_enable_b_out                (i_hqm_system_mem_rf_lut_ldb_cq_addr_l_pwr_enable_b_out),
       .rf_lut_ldb_cq_addr_u_wclk                            (i_hqm_sip_rf_lut_ldb_cq_addr_u_wclk),
       .rf_lut_ldb_cq_addr_u_wclk_rst_n                      (i_hqm_sip_rf_lut_ldb_cq_addr_u_wclk_rst_n),
       .rf_lut_ldb_cq_addr_u_we                              (i_hqm_sip_rf_lut_ldb_cq_addr_u_we),
       .rf_lut_ldb_cq_addr_u_waddr                           (i_hqm_sip_rf_lut_ldb_cq_addr_u_waddr),
       .rf_lut_ldb_cq_addr_u_wdata                           (i_hqm_sip_rf_lut_ldb_cq_addr_u_wdata),
       .rf_lut_ldb_cq_addr_u_rclk                            (i_hqm_sip_rf_lut_ldb_cq_addr_u_rclk),
       .rf_lut_ldb_cq_addr_u_rclk_rst_n                      (i_hqm_sip_rf_lut_ldb_cq_addr_u_rclk_rst_n),
       .rf_lut_ldb_cq_addr_u_re                              (i_hqm_sip_rf_lut_ldb_cq_addr_u_re),
       .rf_lut_ldb_cq_addr_u_raddr                           (i_hqm_sip_rf_lut_ldb_cq_addr_u_raddr),
       .rf_lut_ldb_cq_addr_u_rdata                           (i_hqm_system_mem_rf_lut_ldb_cq_addr_u_rdata),
       .rf_lut_ldb_cq_addr_u_isol_en                         (i_hqm_sip_pgcb_isol_en),
       .rf_lut_ldb_cq_addr_u_pwr_enable_b_in                 (i_hqm_system_mem_rf_lut_ldb_cq_addr_l_pwr_enable_b_out),
       .rf_lut_ldb_cq_addr_u_pwr_enable_b_out                (i_hqm_system_mem_rf_lut_ldb_cq_addr_u_pwr_enable_b_out),
       .rf_lut_ldb_cq_ai_addr_l_wclk                         (i_hqm_sip_rf_lut_ldb_cq_ai_addr_l_wclk),
       .rf_lut_ldb_cq_ai_addr_l_wclk_rst_n                   (i_hqm_sip_rf_lut_ldb_cq_ai_addr_l_wclk_rst_n),
       .rf_lut_ldb_cq_ai_addr_l_we                           (i_hqm_sip_rf_lut_ldb_cq_ai_addr_l_we),
       .rf_lut_ldb_cq_ai_addr_l_waddr                        (i_hqm_sip_rf_lut_ldb_cq_ai_addr_l_waddr),
       .rf_lut_ldb_cq_ai_addr_l_wdata                        (i_hqm_sip_rf_lut_ldb_cq_ai_addr_l_wdata),
       .rf_lut_ldb_cq_ai_addr_l_rclk                         (i_hqm_sip_rf_lut_ldb_cq_ai_addr_l_rclk),
       .rf_lut_ldb_cq_ai_addr_l_rclk_rst_n                   (i_hqm_sip_rf_lut_ldb_cq_ai_addr_l_rclk_rst_n),
       .rf_lut_ldb_cq_ai_addr_l_re                           (i_hqm_sip_rf_lut_ldb_cq_ai_addr_l_re),
       .rf_lut_ldb_cq_ai_addr_l_raddr                        (i_hqm_sip_rf_lut_ldb_cq_ai_addr_l_raddr),
       .rf_lut_ldb_cq_ai_addr_l_rdata                        (i_hqm_system_mem_rf_lut_ldb_cq_ai_addr_l_rdata),
       .rf_lut_ldb_cq_ai_addr_l_isol_en                      (i_hqm_sip_pgcb_isol_en),
       .rf_lut_ldb_cq_ai_addr_l_pwr_enable_b_in              (i_hqm_system_mem_rf_lut_ldb_cq_addr_u_pwr_enable_b_out),
       .rf_lut_ldb_cq_ai_addr_l_pwr_enable_b_out             (i_hqm_system_mem_rf_lut_ldb_cq_ai_addr_l_pwr_enable_b_out),
       .rf_lut_ldb_cq_ai_addr_u_wclk                         (i_hqm_sip_rf_lut_ldb_cq_ai_addr_u_wclk),
       .rf_lut_ldb_cq_ai_addr_u_wclk_rst_n                   (i_hqm_sip_rf_lut_ldb_cq_ai_addr_u_wclk_rst_n),
       .rf_lut_ldb_cq_ai_addr_u_we                           (i_hqm_sip_rf_lut_ldb_cq_ai_addr_u_we),
       .rf_lut_ldb_cq_ai_addr_u_waddr                        (i_hqm_sip_rf_lut_ldb_cq_ai_addr_u_waddr),
       .rf_lut_ldb_cq_ai_addr_u_wdata                        (i_hqm_sip_rf_lut_ldb_cq_ai_addr_u_wdata),
       .rf_lut_ldb_cq_ai_addr_u_rclk                         (i_hqm_sip_rf_lut_ldb_cq_ai_addr_u_rclk),
       .rf_lut_ldb_cq_ai_addr_u_rclk_rst_n                   (i_hqm_sip_rf_lut_ldb_cq_ai_addr_u_rclk_rst_n),
       .rf_lut_ldb_cq_ai_addr_u_re                           (i_hqm_sip_rf_lut_ldb_cq_ai_addr_u_re),
       .rf_lut_ldb_cq_ai_addr_u_raddr                        (i_hqm_sip_rf_lut_ldb_cq_ai_addr_u_raddr),
       .rf_lut_ldb_cq_ai_addr_u_rdata                        (i_hqm_system_mem_rf_lut_ldb_cq_ai_addr_u_rdata),
       .rf_lut_ldb_cq_ai_addr_u_isol_en                      (i_hqm_sip_pgcb_isol_en),
       .rf_lut_ldb_cq_ai_addr_u_pwr_enable_b_in              (i_hqm_system_mem_rf_lut_ldb_cq_ai_addr_l_pwr_enable_b_out),
       .rf_lut_ldb_cq_ai_addr_u_pwr_enable_b_out             (i_hqm_system_mem_rf_lut_ldb_cq_ai_addr_u_pwr_enable_b_out),
       .rf_lut_ldb_cq_ai_data_wclk                           (i_hqm_sip_rf_lut_ldb_cq_ai_data_wclk),
       .rf_lut_ldb_cq_ai_data_wclk_rst_n                     (i_hqm_sip_rf_lut_ldb_cq_ai_data_wclk_rst_n),
       .rf_lut_ldb_cq_ai_data_we                             (i_hqm_sip_rf_lut_ldb_cq_ai_data_we),
       .rf_lut_ldb_cq_ai_data_waddr                          (i_hqm_sip_rf_lut_ldb_cq_ai_data_waddr),
       .rf_lut_ldb_cq_ai_data_wdata                          (i_hqm_sip_rf_lut_ldb_cq_ai_data_wdata),
       .rf_lut_ldb_cq_ai_data_rclk                           (i_hqm_sip_rf_lut_ldb_cq_ai_data_rclk),
       .rf_lut_ldb_cq_ai_data_rclk_rst_n                     (i_hqm_sip_rf_lut_ldb_cq_ai_data_rclk_rst_n),
       .rf_lut_ldb_cq_ai_data_re                             (i_hqm_sip_rf_lut_ldb_cq_ai_data_re),
       .rf_lut_ldb_cq_ai_data_raddr                          (i_hqm_sip_rf_lut_ldb_cq_ai_data_raddr),
       .rf_lut_ldb_cq_ai_data_rdata                          (i_hqm_system_mem_rf_lut_ldb_cq_ai_data_rdata),
       .rf_lut_ldb_cq_ai_data_isol_en                        (i_hqm_sip_pgcb_isol_en),
       .rf_lut_ldb_cq_ai_data_pwr_enable_b_in                (i_hqm_system_mem_rf_lut_ldb_cq_ai_addr_u_pwr_enable_b_out),
       .rf_lut_ldb_cq_ai_data_pwr_enable_b_out               (i_hqm_system_mem_rf_lut_ldb_cq_ai_data_pwr_enable_b_out),
       .rf_lut_ldb_cq_isr_wclk                               (i_hqm_sip_rf_lut_ldb_cq_isr_wclk),
       .rf_lut_ldb_cq_isr_wclk_rst_n                         (i_hqm_sip_rf_lut_ldb_cq_isr_wclk_rst_n),
       .rf_lut_ldb_cq_isr_we                                 (i_hqm_sip_rf_lut_ldb_cq_isr_we),
       .rf_lut_ldb_cq_isr_waddr                              (i_hqm_sip_rf_lut_ldb_cq_isr_waddr),
       .rf_lut_ldb_cq_isr_wdata                              (i_hqm_sip_rf_lut_ldb_cq_isr_wdata),
       .rf_lut_ldb_cq_isr_rclk                               (i_hqm_sip_rf_lut_ldb_cq_isr_rclk),
       .rf_lut_ldb_cq_isr_rclk_rst_n                         (i_hqm_sip_rf_lut_ldb_cq_isr_rclk_rst_n),
       .rf_lut_ldb_cq_isr_re                                 (i_hqm_sip_rf_lut_ldb_cq_isr_re),
       .rf_lut_ldb_cq_isr_raddr                              (i_hqm_sip_rf_lut_ldb_cq_isr_raddr),
       .rf_lut_ldb_cq_isr_rdata                              (i_hqm_system_mem_rf_lut_ldb_cq_isr_rdata),
       .rf_lut_ldb_cq_isr_isol_en                            (i_hqm_sip_pgcb_isol_en),
       .rf_lut_ldb_cq_isr_pwr_enable_b_in                    (i_hqm_system_mem_rf_lut_ldb_cq_ai_data_pwr_enable_b_out),
       .rf_lut_ldb_cq_isr_pwr_enable_b_out                   (i_hqm_system_mem_rf_lut_ldb_cq_isr_pwr_enable_b_out),
       .rf_lut_ldb_cq_pasid_wclk                             (i_hqm_sip_rf_lut_ldb_cq_pasid_wclk),
       .rf_lut_ldb_cq_pasid_wclk_rst_n                       (i_hqm_sip_rf_lut_ldb_cq_pasid_wclk_rst_n),
       .rf_lut_ldb_cq_pasid_we                               (i_hqm_sip_rf_lut_ldb_cq_pasid_we),
       .rf_lut_ldb_cq_pasid_waddr                            (i_hqm_sip_rf_lut_ldb_cq_pasid_waddr),
       .rf_lut_ldb_cq_pasid_wdata                            (i_hqm_sip_rf_lut_ldb_cq_pasid_wdata),
       .rf_lut_ldb_cq_pasid_rclk                             (i_hqm_sip_rf_lut_ldb_cq_pasid_rclk),
       .rf_lut_ldb_cq_pasid_rclk_rst_n                       (i_hqm_sip_rf_lut_ldb_cq_pasid_rclk_rst_n),
       .rf_lut_ldb_cq_pasid_re                               (i_hqm_sip_rf_lut_ldb_cq_pasid_re),
       .rf_lut_ldb_cq_pasid_raddr                            (i_hqm_sip_rf_lut_ldb_cq_pasid_raddr),
       .rf_lut_ldb_cq_pasid_rdata                            (i_hqm_system_mem_rf_lut_ldb_cq_pasid_rdata),
       .rf_lut_ldb_cq_pasid_isol_en                          (i_hqm_sip_pgcb_isol_en),
       .rf_lut_ldb_cq_pasid_pwr_enable_b_in                  (i_hqm_system_mem_rf_lut_ldb_cq_isr_pwr_enable_b_out),
       .rf_lut_ldb_cq_pasid_pwr_enable_b_out                 (i_hqm_system_mem_rf_lut_ldb_cq_pasid_pwr_enable_b_out),
       .rf_lut_ldb_pp2vas_wclk                               (i_hqm_sip_rf_lut_ldb_pp2vas_wclk),
       .rf_lut_ldb_pp2vas_wclk_rst_n                         (i_hqm_sip_rf_lut_ldb_pp2vas_wclk_rst_n),
       .rf_lut_ldb_pp2vas_we                                 (i_hqm_sip_rf_lut_ldb_pp2vas_we),
       .rf_lut_ldb_pp2vas_waddr                              (i_hqm_sip_rf_lut_ldb_pp2vas_waddr),
       .rf_lut_ldb_pp2vas_wdata                              (i_hqm_sip_rf_lut_ldb_pp2vas_wdata),
       .rf_lut_ldb_pp2vas_rclk                               (i_hqm_sip_rf_lut_ldb_pp2vas_rclk),
       .rf_lut_ldb_pp2vas_rclk_rst_n                         (i_hqm_sip_rf_lut_ldb_pp2vas_rclk_rst_n),
       .rf_lut_ldb_pp2vas_re                                 (i_hqm_sip_rf_lut_ldb_pp2vas_re),
       .rf_lut_ldb_pp2vas_raddr                              (i_hqm_sip_rf_lut_ldb_pp2vas_raddr),
       .rf_lut_ldb_pp2vas_rdata                              (i_hqm_system_mem_rf_lut_ldb_pp2vas_rdata),
       .rf_lut_ldb_pp2vas_isol_en                            (i_hqm_sip_pgcb_isol_en),
       .rf_lut_ldb_pp2vas_pwr_enable_b_in                    (i_hqm_system_mem_rf_lut_ldb_cq_pasid_pwr_enable_b_out),
       .rf_lut_ldb_pp2vas_pwr_enable_b_out                   (i_hqm_system_mem_rf_lut_ldb_pp2vas_pwr_enable_b_out),
       .rf_lut_ldb_qid2vqid_wclk                             (i_hqm_sip_rf_lut_ldb_qid2vqid_wclk),
       .rf_lut_ldb_qid2vqid_wclk_rst_n                       (i_hqm_sip_rf_lut_ldb_qid2vqid_wclk_rst_n),
       .rf_lut_ldb_qid2vqid_we                               (i_hqm_sip_rf_lut_ldb_qid2vqid_we),
       .rf_lut_ldb_qid2vqid_waddr                            (i_hqm_sip_rf_lut_ldb_qid2vqid_waddr),
       .rf_lut_ldb_qid2vqid_wdata                            (i_hqm_sip_rf_lut_ldb_qid2vqid_wdata),
       .rf_lut_ldb_qid2vqid_rclk                             (i_hqm_sip_rf_lut_ldb_qid2vqid_rclk),
       .rf_lut_ldb_qid2vqid_rclk_rst_n                       (i_hqm_sip_rf_lut_ldb_qid2vqid_rclk_rst_n),
       .rf_lut_ldb_qid2vqid_re                               (i_hqm_sip_rf_lut_ldb_qid2vqid_re),
       .rf_lut_ldb_qid2vqid_raddr                            (i_hqm_sip_rf_lut_ldb_qid2vqid_raddr),
       .rf_lut_ldb_qid2vqid_rdata                            (i_hqm_system_mem_rf_lut_ldb_qid2vqid_rdata),
       .rf_lut_ldb_qid2vqid_isol_en                          (i_hqm_sip_pgcb_isol_en),
       .rf_lut_ldb_qid2vqid_pwr_enable_b_in                  (i_hqm_system_mem_rf_lut_ldb_pp2vas_pwr_enable_b_out),
       .rf_lut_ldb_qid2vqid_pwr_enable_b_out                 (i_hqm_system_mem_rf_lut_ldb_qid2vqid_pwr_enable_b_out),
       .rf_lut_ldb_vasqid_v_wclk                             (i_hqm_sip_rf_lut_ldb_vasqid_v_wclk),
       .rf_lut_ldb_vasqid_v_wclk_rst_n                       (i_hqm_sip_rf_lut_ldb_vasqid_v_wclk_rst_n),
       .rf_lut_ldb_vasqid_v_we                               (i_hqm_sip_rf_lut_ldb_vasqid_v_we),
       .rf_lut_ldb_vasqid_v_waddr                            (i_hqm_sip_rf_lut_ldb_vasqid_v_waddr),
       .rf_lut_ldb_vasqid_v_wdata                            (i_hqm_sip_rf_lut_ldb_vasqid_v_wdata),
       .rf_lut_ldb_vasqid_v_rclk                             (i_hqm_sip_rf_lut_ldb_vasqid_v_rclk),
       .rf_lut_ldb_vasqid_v_rclk_rst_n                       (i_hqm_sip_rf_lut_ldb_vasqid_v_rclk_rst_n),
       .rf_lut_ldb_vasqid_v_re                               (i_hqm_sip_rf_lut_ldb_vasqid_v_re),
       .rf_lut_ldb_vasqid_v_raddr                            (i_hqm_sip_rf_lut_ldb_vasqid_v_raddr),
       .rf_lut_ldb_vasqid_v_rdata                            (i_hqm_system_mem_rf_lut_ldb_vasqid_v_rdata),
       .rf_lut_ldb_vasqid_v_isol_en                          (i_hqm_sip_pgcb_isol_en),
       .rf_lut_ldb_vasqid_v_pwr_enable_b_in                  (i_hqm_system_mem_rf_lut_ldb_qid2vqid_pwr_enable_b_out),
       .rf_lut_ldb_vasqid_v_pwr_enable_b_out                 (i_hqm_system_mem_rf_lut_ldb_vasqid_v_pwr_enable_b_out),
       .rf_lut_vf_dir_vpp2pp_wclk                            (i_hqm_sip_rf_lut_vf_dir_vpp2pp_wclk),
       .rf_lut_vf_dir_vpp2pp_wclk_rst_n                      (i_hqm_sip_rf_lut_vf_dir_vpp2pp_wclk_rst_n),
       .rf_lut_vf_dir_vpp2pp_we                              (i_hqm_sip_rf_lut_vf_dir_vpp2pp_we),
       .rf_lut_vf_dir_vpp2pp_waddr                           (i_hqm_sip_rf_lut_vf_dir_vpp2pp_waddr),
       .rf_lut_vf_dir_vpp2pp_wdata                           (i_hqm_sip_rf_lut_vf_dir_vpp2pp_wdata),
       .rf_lut_vf_dir_vpp2pp_rclk                            (i_hqm_sip_rf_lut_vf_dir_vpp2pp_rclk),
       .rf_lut_vf_dir_vpp2pp_rclk_rst_n                      (i_hqm_sip_rf_lut_vf_dir_vpp2pp_rclk_rst_n),
       .rf_lut_vf_dir_vpp2pp_re                              (i_hqm_sip_rf_lut_vf_dir_vpp2pp_re),
       .rf_lut_vf_dir_vpp2pp_raddr                           (i_hqm_sip_rf_lut_vf_dir_vpp2pp_raddr),
       .rf_lut_vf_dir_vpp2pp_rdata                           (i_hqm_system_mem_rf_lut_vf_dir_vpp2pp_rdata),
       .rf_lut_vf_dir_vpp2pp_isol_en                         (i_hqm_sip_pgcb_isol_en),
       .rf_lut_vf_dir_vpp2pp_pwr_enable_b_in                 (i_hqm_system_mem_rf_lut_ldb_vasqid_v_pwr_enable_b_out),
       .rf_lut_vf_dir_vpp2pp_pwr_enable_b_out                (i_hqm_system_mem_rf_lut_vf_dir_vpp2pp_pwr_enable_b_out),
       .rf_lut_vf_dir_vpp_v_wclk                             (i_hqm_sip_rf_lut_vf_dir_vpp_v_wclk),
       .rf_lut_vf_dir_vpp_v_wclk_rst_n                       (i_hqm_sip_rf_lut_vf_dir_vpp_v_wclk_rst_n),
       .rf_lut_vf_dir_vpp_v_we                               (i_hqm_sip_rf_lut_vf_dir_vpp_v_we),
       .rf_lut_vf_dir_vpp_v_waddr                            (i_hqm_sip_rf_lut_vf_dir_vpp_v_waddr),
       .rf_lut_vf_dir_vpp_v_wdata                            (i_hqm_sip_rf_lut_vf_dir_vpp_v_wdata),
       .rf_lut_vf_dir_vpp_v_rclk                             (i_hqm_sip_rf_lut_vf_dir_vpp_v_rclk),
       .rf_lut_vf_dir_vpp_v_rclk_rst_n                       (i_hqm_sip_rf_lut_vf_dir_vpp_v_rclk_rst_n),
       .rf_lut_vf_dir_vpp_v_re                               (i_hqm_sip_rf_lut_vf_dir_vpp_v_re),
       .rf_lut_vf_dir_vpp_v_raddr                            (i_hqm_sip_rf_lut_vf_dir_vpp_v_raddr),
       .rf_lut_vf_dir_vpp_v_rdata                            (i_hqm_system_mem_rf_lut_vf_dir_vpp_v_rdata),
       .rf_lut_vf_dir_vpp_v_isol_en                          (i_hqm_sip_pgcb_isol_en),
       .rf_lut_vf_dir_vpp_v_pwr_enable_b_in                  (i_hqm_system_mem_rf_lut_vf_dir_vpp2pp_pwr_enable_b_out),
       .rf_lut_vf_dir_vpp_v_pwr_enable_b_out                 (i_hqm_system_mem_rf_lut_vf_dir_vpp_v_pwr_enable_b_out),
       .rf_lut_vf_dir_vqid2qid_wclk                          (i_hqm_sip_rf_lut_vf_dir_vqid2qid_wclk),
       .rf_lut_vf_dir_vqid2qid_wclk_rst_n                    (i_hqm_sip_rf_lut_vf_dir_vqid2qid_wclk_rst_n),
       .rf_lut_vf_dir_vqid2qid_we                            (i_hqm_sip_rf_lut_vf_dir_vqid2qid_we),
       .rf_lut_vf_dir_vqid2qid_waddr                         (i_hqm_sip_rf_lut_vf_dir_vqid2qid_waddr),
       .rf_lut_vf_dir_vqid2qid_wdata                         (i_hqm_sip_rf_lut_vf_dir_vqid2qid_wdata),
       .rf_lut_vf_dir_vqid2qid_rclk                          (i_hqm_sip_rf_lut_vf_dir_vqid2qid_rclk),
       .rf_lut_vf_dir_vqid2qid_rclk_rst_n                    (i_hqm_sip_rf_lut_vf_dir_vqid2qid_rclk_rst_n),
       .rf_lut_vf_dir_vqid2qid_re                            (i_hqm_sip_rf_lut_vf_dir_vqid2qid_re),
       .rf_lut_vf_dir_vqid2qid_raddr                         (i_hqm_sip_rf_lut_vf_dir_vqid2qid_raddr),
       .rf_lut_vf_dir_vqid2qid_rdata                         (i_hqm_system_mem_rf_lut_vf_dir_vqid2qid_rdata),
       .rf_lut_vf_dir_vqid2qid_isol_en                       (i_hqm_sip_pgcb_isol_en),
       .rf_lut_vf_dir_vqid2qid_pwr_enable_b_in               (i_hqm_system_mem_rf_lut_vf_dir_vpp_v_pwr_enable_b_out),
       .rf_lut_vf_dir_vqid2qid_pwr_enable_b_out              (i_hqm_system_mem_rf_lut_vf_dir_vqid2qid_pwr_enable_b_out),
       .rf_lut_vf_dir_vqid_v_wclk                            (i_hqm_sip_rf_lut_vf_dir_vqid_v_wclk),
       .rf_lut_vf_dir_vqid_v_wclk_rst_n                      (i_hqm_sip_rf_lut_vf_dir_vqid_v_wclk_rst_n),
       .rf_lut_vf_dir_vqid_v_we                              (i_hqm_sip_rf_lut_vf_dir_vqid_v_we),
       .rf_lut_vf_dir_vqid_v_waddr                           (i_hqm_sip_rf_lut_vf_dir_vqid_v_waddr),
       .rf_lut_vf_dir_vqid_v_wdata                           (i_hqm_sip_rf_lut_vf_dir_vqid_v_wdata),
       .rf_lut_vf_dir_vqid_v_rclk                            (i_hqm_sip_rf_lut_vf_dir_vqid_v_rclk),
       .rf_lut_vf_dir_vqid_v_rclk_rst_n                      (i_hqm_sip_rf_lut_vf_dir_vqid_v_rclk_rst_n),
       .rf_lut_vf_dir_vqid_v_re                              (i_hqm_sip_rf_lut_vf_dir_vqid_v_re),
       .rf_lut_vf_dir_vqid_v_raddr                           (i_hqm_sip_rf_lut_vf_dir_vqid_v_raddr),
       .rf_lut_vf_dir_vqid_v_rdata                           (i_hqm_system_mem_rf_lut_vf_dir_vqid_v_rdata),
       .rf_lut_vf_dir_vqid_v_isol_en                         (i_hqm_sip_pgcb_isol_en),
       .rf_lut_vf_dir_vqid_v_pwr_enable_b_in                 (i_hqm_system_mem_rf_lut_vf_dir_vqid2qid_pwr_enable_b_out),
       .rf_lut_vf_dir_vqid_v_pwr_enable_b_out                (i_hqm_system_mem_rf_lut_vf_dir_vqid_v_pwr_enable_b_out),
       .rf_lut_vf_ldb_vpp2pp_wclk                            (i_hqm_sip_rf_lut_vf_ldb_vpp2pp_wclk),
       .rf_lut_vf_ldb_vpp2pp_wclk_rst_n                      (i_hqm_sip_rf_lut_vf_ldb_vpp2pp_wclk_rst_n),
       .rf_lut_vf_ldb_vpp2pp_we                              (i_hqm_sip_rf_lut_vf_ldb_vpp2pp_we),
       .rf_lut_vf_ldb_vpp2pp_waddr                           (i_hqm_sip_rf_lut_vf_ldb_vpp2pp_waddr),
       .rf_lut_vf_ldb_vpp2pp_wdata                           (i_hqm_sip_rf_lut_vf_ldb_vpp2pp_wdata),
       .rf_lut_vf_ldb_vpp2pp_rclk                            (i_hqm_sip_rf_lut_vf_ldb_vpp2pp_rclk),
       .rf_lut_vf_ldb_vpp2pp_rclk_rst_n                      (i_hqm_sip_rf_lut_vf_ldb_vpp2pp_rclk_rst_n),
       .rf_lut_vf_ldb_vpp2pp_re                              (i_hqm_sip_rf_lut_vf_ldb_vpp2pp_re),
       .rf_lut_vf_ldb_vpp2pp_raddr                           (i_hqm_sip_rf_lut_vf_ldb_vpp2pp_raddr),
       .rf_lut_vf_ldb_vpp2pp_rdata                           (i_hqm_system_mem_rf_lut_vf_ldb_vpp2pp_rdata),
       .rf_lut_vf_ldb_vpp2pp_isol_en                         (i_hqm_sip_pgcb_isol_en),
       .rf_lut_vf_ldb_vpp2pp_pwr_enable_b_in                 (i_hqm_system_mem_rf_lut_vf_dir_vqid_v_pwr_enable_b_out),
       .rf_lut_vf_ldb_vpp2pp_pwr_enable_b_out                (i_hqm_system_mem_rf_lut_vf_ldb_vpp2pp_pwr_enable_b_out),
       .rf_lut_vf_ldb_vpp_v_wclk                             (i_hqm_sip_rf_lut_vf_ldb_vpp_v_wclk),
       .rf_lut_vf_ldb_vpp_v_wclk_rst_n                       (i_hqm_sip_rf_lut_vf_ldb_vpp_v_wclk_rst_n),
       .rf_lut_vf_ldb_vpp_v_we                               (i_hqm_sip_rf_lut_vf_ldb_vpp_v_we),
       .rf_lut_vf_ldb_vpp_v_waddr                            (i_hqm_sip_rf_lut_vf_ldb_vpp_v_waddr),
       .rf_lut_vf_ldb_vpp_v_wdata                            (i_hqm_sip_rf_lut_vf_ldb_vpp_v_wdata),
       .rf_lut_vf_ldb_vpp_v_rclk                             (i_hqm_sip_rf_lut_vf_ldb_vpp_v_rclk),
       .rf_lut_vf_ldb_vpp_v_rclk_rst_n                       (i_hqm_sip_rf_lut_vf_ldb_vpp_v_rclk_rst_n),
       .rf_lut_vf_ldb_vpp_v_re                               (i_hqm_sip_rf_lut_vf_ldb_vpp_v_re),
       .rf_lut_vf_ldb_vpp_v_raddr                            (i_hqm_sip_rf_lut_vf_ldb_vpp_v_raddr),
       .rf_lut_vf_ldb_vpp_v_rdata                            (i_hqm_system_mem_rf_lut_vf_ldb_vpp_v_rdata),
       .rf_lut_vf_ldb_vpp_v_isol_en                          (i_hqm_sip_pgcb_isol_en),
       .rf_lut_vf_ldb_vpp_v_pwr_enable_b_in                  (i_hqm_system_mem_rf_lut_vf_ldb_vpp2pp_pwr_enable_b_out),
       .rf_lut_vf_ldb_vpp_v_pwr_enable_b_out                 (i_hqm_system_mem_rf_lut_vf_ldb_vpp_v_pwr_enable_b_out),
       .rf_lut_vf_ldb_vqid2qid_wclk                          (i_hqm_sip_rf_lut_vf_ldb_vqid2qid_wclk),
       .rf_lut_vf_ldb_vqid2qid_wclk_rst_n                    (i_hqm_sip_rf_lut_vf_ldb_vqid2qid_wclk_rst_n),
       .rf_lut_vf_ldb_vqid2qid_we                            (i_hqm_sip_rf_lut_vf_ldb_vqid2qid_we),
       .rf_lut_vf_ldb_vqid2qid_waddr                         (i_hqm_sip_rf_lut_vf_ldb_vqid2qid_waddr),
       .rf_lut_vf_ldb_vqid2qid_wdata                         (i_hqm_sip_rf_lut_vf_ldb_vqid2qid_wdata),
       .rf_lut_vf_ldb_vqid2qid_rclk                          (i_hqm_sip_rf_lut_vf_ldb_vqid2qid_rclk),
       .rf_lut_vf_ldb_vqid2qid_rclk_rst_n                    (i_hqm_sip_rf_lut_vf_ldb_vqid2qid_rclk_rst_n),
       .rf_lut_vf_ldb_vqid2qid_re                            (i_hqm_sip_rf_lut_vf_ldb_vqid2qid_re),
       .rf_lut_vf_ldb_vqid2qid_raddr                         (i_hqm_sip_rf_lut_vf_ldb_vqid2qid_raddr),
       .rf_lut_vf_ldb_vqid2qid_rdata                         (i_hqm_system_mem_rf_lut_vf_ldb_vqid2qid_rdata),
       .rf_lut_vf_ldb_vqid2qid_isol_en                       (i_hqm_sip_pgcb_isol_en),
       .rf_lut_vf_ldb_vqid2qid_pwr_enable_b_in               (i_hqm_system_mem_rf_lut_vf_ldb_vpp_v_pwr_enable_b_out),
       .rf_lut_vf_ldb_vqid2qid_pwr_enable_b_out              (i_hqm_system_mem_rf_lut_vf_ldb_vqid2qid_pwr_enable_b_out),
       .rf_lut_vf_ldb_vqid_v_wclk                            (i_hqm_sip_rf_lut_vf_ldb_vqid_v_wclk),
       .rf_lut_vf_ldb_vqid_v_wclk_rst_n                      (i_hqm_sip_rf_lut_vf_ldb_vqid_v_wclk_rst_n),
       .rf_lut_vf_ldb_vqid_v_we                              (i_hqm_sip_rf_lut_vf_ldb_vqid_v_we),
       .rf_lut_vf_ldb_vqid_v_waddr                           (i_hqm_sip_rf_lut_vf_ldb_vqid_v_waddr),
       .rf_lut_vf_ldb_vqid_v_wdata                           (i_hqm_sip_rf_lut_vf_ldb_vqid_v_wdata),
       .rf_lut_vf_ldb_vqid_v_rclk                            (i_hqm_sip_rf_lut_vf_ldb_vqid_v_rclk),
       .rf_lut_vf_ldb_vqid_v_rclk_rst_n                      (i_hqm_sip_rf_lut_vf_ldb_vqid_v_rclk_rst_n),
       .rf_lut_vf_ldb_vqid_v_re                              (i_hqm_sip_rf_lut_vf_ldb_vqid_v_re),
       .rf_lut_vf_ldb_vqid_v_raddr                           (i_hqm_sip_rf_lut_vf_ldb_vqid_v_raddr),
       .rf_lut_vf_ldb_vqid_v_rdata                           (i_hqm_system_mem_rf_lut_vf_ldb_vqid_v_rdata),
       .rf_lut_vf_ldb_vqid_v_isol_en                         (i_hqm_sip_pgcb_isol_en),
       .rf_lut_vf_ldb_vqid_v_pwr_enable_b_in                 (i_hqm_system_mem_rf_lut_vf_ldb_vqid2qid_pwr_enable_b_out),
       .rf_lut_vf_ldb_vqid_v_pwr_enable_b_out                (i_hqm_system_mem_rf_lut_vf_ldb_vqid_v_pwr_enable_b_out),
       .rf_msix_tbl_word0_wclk                               (i_hqm_sip_rf_msix_tbl_word0_wclk),
       .rf_msix_tbl_word0_wclk_rst_n                         (i_hqm_sip_rf_msix_tbl_word0_wclk_rst_n),
       .rf_msix_tbl_word0_we                                 (i_hqm_sip_rf_msix_tbl_word0_we),
       .rf_msix_tbl_word0_waddr                              (i_hqm_sip_rf_msix_tbl_word0_waddr),
       .rf_msix_tbl_word0_wdata                              (i_hqm_sip_rf_msix_tbl_word0_wdata),
       .rf_msix_tbl_word0_rclk                               (i_hqm_sip_rf_msix_tbl_word0_rclk),
       .rf_msix_tbl_word0_rclk_rst_n                         (i_hqm_sip_rf_msix_tbl_word0_rclk_rst_n),
       .rf_msix_tbl_word0_re                                 (i_hqm_sip_rf_msix_tbl_word0_re),
       .rf_msix_tbl_word0_raddr                              (i_hqm_sip_rf_msix_tbl_word0_raddr),
       .rf_msix_tbl_word0_rdata                              (i_hqm_system_mem_rf_msix_tbl_word0_rdata),
       .rf_msix_tbl_word0_isol_en                            (i_hqm_sip_pgcb_isol_en),
       .rf_msix_tbl_word0_pwr_enable_b_in                    (i_hqm_system_mem_rf_lut_vf_ldb_vqid_v_pwr_enable_b_out),
       .rf_msix_tbl_word0_pwr_enable_b_out                   (i_hqm_system_mem_rf_msix_tbl_word0_pwr_enable_b_out),
       .rf_msix_tbl_word1_wclk                               (i_hqm_sip_rf_msix_tbl_word1_wclk),
       .rf_msix_tbl_word1_wclk_rst_n                         (i_hqm_sip_rf_msix_tbl_word1_wclk_rst_n),
       .rf_msix_tbl_word1_we                                 (i_hqm_sip_rf_msix_tbl_word1_we),
       .rf_msix_tbl_word1_waddr                              (i_hqm_sip_rf_msix_tbl_word1_waddr),
       .rf_msix_tbl_word1_wdata                              (i_hqm_sip_rf_msix_tbl_word1_wdata),
       .rf_msix_tbl_word1_rclk                               (i_hqm_sip_rf_msix_tbl_word1_rclk),
       .rf_msix_tbl_word1_rclk_rst_n                         (i_hqm_sip_rf_msix_tbl_word1_rclk_rst_n),
       .rf_msix_tbl_word1_re                                 (i_hqm_sip_rf_msix_tbl_word1_re),
       .rf_msix_tbl_word1_raddr                              (i_hqm_sip_rf_msix_tbl_word1_raddr),
       .rf_msix_tbl_word1_rdata                              (i_hqm_system_mem_rf_msix_tbl_word1_rdata),
       .rf_msix_tbl_word1_isol_en                            (i_hqm_sip_pgcb_isol_en),
       .rf_msix_tbl_word1_pwr_enable_b_in                    (i_hqm_system_mem_rf_msix_tbl_word0_pwr_enable_b_out),
       .rf_msix_tbl_word1_pwr_enable_b_out                   (i_hqm_system_mem_rf_msix_tbl_word1_pwr_enable_b_out),
       .rf_msix_tbl_word2_wclk                               (i_hqm_sip_rf_msix_tbl_word2_wclk),
       .rf_msix_tbl_word2_wclk_rst_n                         (i_hqm_sip_rf_msix_tbl_word2_wclk_rst_n),
       .rf_msix_tbl_word2_we                                 (i_hqm_sip_rf_msix_tbl_word2_we),
       .rf_msix_tbl_word2_waddr                              (i_hqm_sip_rf_msix_tbl_word2_waddr),
       .rf_msix_tbl_word2_wdata                              (i_hqm_sip_rf_msix_tbl_word2_wdata),
       .rf_msix_tbl_word2_rclk                               (i_hqm_sip_rf_msix_tbl_word2_rclk),
       .rf_msix_tbl_word2_rclk_rst_n                         (i_hqm_sip_rf_msix_tbl_word2_rclk_rst_n),
       .rf_msix_tbl_word2_re                                 (i_hqm_sip_rf_msix_tbl_word2_re),
       .rf_msix_tbl_word2_raddr                              (i_hqm_sip_rf_msix_tbl_word2_raddr),
       .rf_msix_tbl_word2_rdata                              (i_hqm_system_mem_rf_msix_tbl_word2_rdata),
       .rf_msix_tbl_word2_isol_en                            (i_hqm_sip_pgcb_isol_en),
       .rf_msix_tbl_word2_pwr_enable_b_in                    (i_hqm_system_mem_rf_msix_tbl_word1_pwr_enable_b_out),
       .rf_msix_tbl_word2_pwr_enable_b_out                   (i_hqm_system_mem_rf_msix_tbl_word2_pwr_enable_b_out),
       .rf_ord_qid_sn_wclk                                   (i_hqm_sip_rf_ord_qid_sn_wclk),
       .rf_ord_qid_sn_wclk_rst_n                             (i_hqm_sip_rf_ord_qid_sn_wclk_rst_n),
       .rf_ord_qid_sn_we                                     (i_hqm_sip_rf_ord_qid_sn_we),
       .rf_ord_qid_sn_waddr                                  (i_hqm_sip_rf_ord_qid_sn_waddr),
       .rf_ord_qid_sn_wdata                                  (i_hqm_sip_rf_ord_qid_sn_wdata),
       .rf_ord_qid_sn_rclk                                   (i_hqm_sip_rf_ord_qid_sn_rclk),
       .rf_ord_qid_sn_rclk_rst_n                             (i_hqm_sip_rf_ord_qid_sn_rclk_rst_n),
       .rf_ord_qid_sn_re                                     (i_hqm_sip_rf_ord_qid_sn_re),
       .rf_ord_qid_sn_raddr                                  (i_hqm_sip_rf_ord_qid_sn_raddr),
       .rf_ord_qid_sn_rdata                                  (i_hqm_system_mem_rf_ord_qid_sn_rdata),
       .rf_ord_qid_sn_isol_en                                (i_hqm_sip_pgcb_isol_en),
       .rf_ord_qid_sn_pwr_enable_b_in                        (i_hqm_system_mem_rf_msix_tbl_word2_pwr_enable_b_out),
       .rf_ord_qid_sn_pwr_enable_b_out                       (i_hqm_system_mem_rf_ord_qid_sn_pwr_enable_b_out),
       .rf_ord_qid_sn_map_wclk                               (i_hqm_sip_rf_ord_qid_sn_map_wclk),
       .rf_ord_qid_sn_map_wclk_rst_n                         (i_hqm_sip_rf_ord_qid_sn_map_wclk_rst_n),
       .rf_ord_qid_sn_map_we                                 (i_hqm_sip_rf_ord_qid_sn_map_we),
       .rf_ord_qid_sn_map_waddr                              (i_hqm_sip_rf_ord_qid_sn_map_waddr),
       .rf_ord_qid_sn_map_wdata                              (i_hqm_sip_rf_ord_qid_sn_map_wdata),
       .rf_ord_qid_sn_map_rclk                               (i_hqm_sip_rf_ord_qid_sn_map_rclk),
       .rf_ord_qid_sn_map_rclk_rst_n                         (i_hqm_sip_rf_ord_qid_sn_map_rclk_rst_n),
       .rf_ord_qid_sn_map_re                                 (i_hqm_sip_rf_ord_qid_sn_map_re),
       .rf_ord_qid_sn_map_raddr                              (i_hqm_sip_rf_ord_qid_sn_map_raddr),
       .rf_ord_qid_sn_map_rdata                              (i_hqm_system_mem_rf_ord_qid_sn_map_rdata),
       .rf_ord_qid_sn_map_isol_en                            (i_hqm_sip_pgcb_isol_en),
       .rf_ord_qid_sn_map_pwr_enable_b_in                    (i_hqm_system_mem_rf_ord_qid_sn_pwr_enable_b_out),
       .rf_ord_qid_sn_map_pwr_enable_b_out                   (i_hqm_system_mem_rf_ord_qid_sn_map_pwr_enable_b_out),
       .rf_outbound_hcw_fifo_mem_wclk                        (i_hqm_sip_rf_outbound_hcw_fifo_mem_wclk),
       .rf_outbound_hcw_fifo_mem_wclk_rst_n                  (i_hqm_sip_rf_outbound_hcw_fifo_mem_wclk_rst_n),
       .rf_outbound_hcw_fifo_mem_we                          (i_hqm_sip_rf_outbound_hcw_fifo_mem_we),
       .rf_outbound_hcw_fifo_mem_waddr                       (i_hqm_sip_rf_outbound_hcw_fifo_mem_waddr),
       .rf_outbound_hcw_fifo_mem_wdata                       (i_hqm_sip_rf_outbound_hcw_fifo_mem_wdata),
       .rf_outbound_hcw_fifo_mem_rclk                        (i_hqm_sip_rf_outbound_hcw_fifo_mem_rclk),
       .rf_outbound_hcw_fifo_mem_rclk_rst_n                  (i_hqm_sip_rf_outbound_hcw_fifo_mem_rclk_rst_n),
       .rf_outbound_hcw_fifo_mem_re                          (i_hqm_sip_rf_outbound_hcw_fifo_mem_re),
       .rf_outbound_hcw_fifo_mem_raddr                       (i_hqm_sip_rf_outbound_hcw_fifo_mem_raddr),
       .rf_outbound_hcw_fifo_mem_rdata                       (i_hqm_system_mem_rf_outbound_hcw_fifo_mem_rdata),
       .rf_outbound_hcw_fifo_mem_isol_en                     (i_hqm_sip_pgcb_isol_en),
       .rf_outbound_hcw_fifo_mem_pwr_enable_b_in             (i_hqm_system_mem_rf_ord_qid_sn_map_pwr_enable_b_out),
       .rf_outbound_hcw_fifo_mem_pwr_enable_b_out            (i_hqm_system_mem_rf_outbound_hcw_fifo_mem_pwr_enable_b_out),
       .rf_qed_chp_sch_flid_ret_rx_sync_mem_wclk             (i_hqm_sip_rf_qed_chp_sch_flid_ret_rx_sync_mem_wclk),
       .rf_qed_chp_sch_flid_ret_rx_sync_mem_wclk_rst_n       (i_hqm_sip_rf_qed_chp_sch_flid_ret_rx_sync_mem_wclk_rst_n),
       .rf_qed_chp_sch_flid_ret_rx_sync_mem_we               (i_hqm_sip_rf_qed_chp_sch_flid_ret_rx_sync_mem_we),
       .rf_qed_chp_sch_flid_ret_rx_sync_mem_waddr            (i_hqm_sip_rf_qed_chp_sch_flid_ret_rx_sync_mem_waddr),
       .rf_qed_chp_sch_flid_ret_rx_sync_mem_wdata            (i_hqm_sip_rf_qed_chp_sch_flid_ret_rx_sync_mem_wdata),
       .rf_qed_chp_sch_flid_ret_rx_sync_mem_rclk             (i_hqm_sip_rf_qed_chp_sch_flid_ret_rx_sync_mem_rclk),
       .rf_qed_chp_sch_flid_ret_rx_sync_mem_rclk_rst_n       (i_hqm_sip_rf_qed_chp_sch_flid_ret_rx_sync_mem_rclk_rst_n),
       .rf_qed_chp_sch_flid_ret_rx_sync_mem_re               (i_hqm_sip_rf_qed_chp_sch_flid_ret_rx_sync_mem_re),
       .rf_qed_chp_sch_flid_ret_rx_sync_mem_raddr            (i_hqm_sip_rf_qed_chp_sch_flid_ret_rx_sync_mem_raddr),
       .rf_qed_chp_sch_flid_ret_rx_sync_mem_rdata            (i_hqm_system_mem_rf_qed_chp_sch_flid_ret_rx_sync_mem_rdata),
       .rf_qed_chp_sch_flid_ret_rx_sync_mem_isol_en          (i_hqm_sip_pgcb_isol_en),
       .rf_qed_chp_sch_flid_ret_rx_sync_mem_pwr_enable_b_in  (i_hqm_system_mem_rf_outbound_hcw_fifo_mem_pwr_enable_b_out),
       .rf_qed_chp_sch_flid_ret_rx_sync_mem_pwr_enable_b_out (i_hqm_system_mem_rf_qed_chp_sch_flid_ret_rx_sync_mem_pwr_enable_b_out),
       .rf_qed_chp_sch_rx_sync_mem_wclk                      (i_hqm_sip_rf_qed_chp_sch_rx_sync_mem_wclk),
       .rf_qed_chp_sch_rx_sync_mem_wclk_rst_n                (i_hqm_sip_rf_qed_chp_sch_rx_sync_mem_wclk_rst_n),
       .rf_qed_chp_sch_rx_sync_mem_we                        (i_hqm_sip_rf_qed_chp_sch_rx_sync_mem_we),
       .rf_qed_chp_sch_rx_sync_mem_waddr                     (i_hqm_sip_rf_qed_chp_sch_rx_sync_mem_waddr),
       .rf_qed_chp_sch_rx_sync_mem_wdata                     (i_hqm_sip_rf_qed_chp_sch_rx_sync_mem_wdata),
       .rf_qed_chp_sch_rx_sync_mem_rclk                      (i_hqm_sip_rf_qed_chp_sch_rx_sync_mem_rclk),
       .rf_qed_chp_sch_rx_sync_mem_rclk_rst_n                (i_hqm_sip_rf_qed_chp_sch_rx_sync_mem_rclk_rst_n),
       .rf_qed_chp_sch_rx_sync_mem_re                        (i_hqm_sip_rf_qed_chp_sch_rx_sync_mem_re),
       .rf_qed_chp_sch_rx_sync_mem_raddr                     (i_hqm_sip_rf_qed_chp_sch_rx_sync_mem_raddr),
       .rf_qed_chp_sch_rx_sync_mem_rdata                     (i_hqm_system_mem_rf_qed_chp_sch_rx_sync_mem_rdata),
       .rf_qed_chp_sch_rx_sync_mem_isol_en                   (i_hqm_sip_pgcb_isol_en),
       .rf_qed_chp_sch_rx_sync_mem_pwr_enable_b_in           (i_hqm_system_mem_rf_qed_chp_sch_flid_ret_rx_sync_mem_pwr_enable_b_out),
       .rf_qed_chp_sch_rx_sync_mem_pwr_enable_b_out          (i_hqm_system_mem_rf_qed_chp_sch_rx_sync_mem_pwr_enable_b_out),
       .rf_qed_to_cq_fifo_mem_wclk                           (i_hqm_sip_rf_qed_to_cq_fifo_mem_wclk),
       .rf_qed_to_cq_fifo_mem_wclk_rst_n                     (i_hqm_sip_rf_qed_to_cq_fifo_mem_wclk_rst_n),
       .rf_qed_to_cq_fifo_mem_we                             (i_hqm_sip_rf_qed_to_cq_fifo_mem_we),
       .rf_qed_to_cq_fifo_mem_waddr                          (i_hqm_sip_rf_qed_to_cq_fifo_mem_waddr),
       .rf_qed_to_cq_fifo_mem_wdata                          (i_hqm_sip_rf_qed_to_cq_fifo_mem_wdata),
       .rf_qed_to_cq_fifo_mem_rclk                           (i_hqm_sip_rf_qed_to_cq_fifo_mem_rclk),
       .rf_qed_to_cq_fifo_mem_rclk_rst_n                     (i_hqm_sip_rf_qed_to_cq_fifo_mem_rclk_rst_n),
       .rf_qed_to_cq_fifo_mem_re                             (i_hqm_sip_rf_qed_to_cq_fifo_mem_re),
       .rf_qed_to_cq_fifo_mem_raddr                          (i_hqm_sip_rf_qed_to_cq_fifo_mem_raddr),
       .rf_qed_to_cq_fifo_mem_rdata                          (i_hqm_system_mem_rf_qed_to_cq_fifo_mem_rdata),
       .rf_qed_to_cq_fifo_mem_isol_en                        (i_hqm_sip_pgcb_isol_en),
       .rf_qed_to_cq_fifo_mem_pwr_enable_b_in                (i_hqm_system_mem_rf_qed_chp_sch_rx_sync_mem_pwr_enable_b_out),
       .rf_qed_to_cq_fifo_mem_pwr_enable_b_out               (i_hqm_system_mem_rf_qed_to_cq_fifo_mem_pwr_enable_b_out),
       .rf_reord_cnt_mem_wclk                                (i_hqm_sip_rf_reord_cnt_mem_wclk),
       .rf_reord_cnt_mem_wclk_rst_n                          (i_hqm_sip_rf_reord_cnt_mem_wclk_rst_n),
       .rf_reord_cnt_mem_we                                  (i_hqm_sip_rf_reord_cnt_mem_we),
       .rf_reord_cnt_mem_waddr                               (i_hqm_sip_rf_reord_cnt_mem_waddr),
       .rf_reord_cnt_mem_wdata                               (i_hqm_sip_rf_reord_cnt_mem_wdata),
       .rf_reord_cnt_mem_rclk                                (i_hqm_sip_rf_reord_cnt_mem_rclk),
       .rf_reord_cnt_mem_rclk_rst_n                          (i_hqm_sip_rf_reord_cnt_mem_rclk_rst_n),
       .rf_reord_cnt_mem_re                                  (i_hqm_sip_rf_reord_cnt_mem_re),
       .rf_reord_cnt_mem_raddr                               (i_hqm_sip_rf_reord_cnt_mem_raddr),
       .rf_reord_cnt_mem_rdata                               (i_hqm_system_mem_rf_reord_cnt_mem_rdata),
       .rf_reord_cnt_mem_isol_en                             (i_hqm_sip_pgcb_isol_en),
       .rf_reord_cnt_mem_pwr_enable_b_in                     (i_hqm_system_mem_rf_qed_to_cq_fifo_mem_pwr_enable_b_out),
       .rf_reord_cnt_mem_pwr_enable_b_out                    (i_hqm_system_mem_rf_reord_cnt_mem_pwr_enable_b_out),
       .rf_reord_dirhp_mem_wclk                              (i_hqm_sip_rf_reord_dirhp_mem_wclk),
       .rf_reord_dirhp_mem_wclk_rst_n                        (i_hqm_sip_rf_reord_dirhp_mem_wclk_rst_n),
       .rf_reord_dirhp_mem_we                                (i_hqm_sip_rf_reord_dirhp_mem_we),
       .rf_reord_dirhp_mem_waddr                             (i_hqm_sip_rf_reord_dirhp_mem_waddr),
       .rf_reord_dirhp_mem_wdata                             (i_hqm_sip_rf_reord_dirhp_mem_wdata),
       .rf_reord_dirhp_mem_rclk                              (i_hqm_sip_rf_reord_dirhp_mem_rclk),
       .rf_reord_dirhp_mem_rclk_rst_n                        (i_hqm_sip_rf_reord_dirhp_mem_rclk_rst_n),
       .rf_reord_dirhp_mem_re                                (i_hqm_sip_rf_reord_dirhp_mem_re),
       .rf_reord_dirhp_mem_raddr                             (i_hqm_sip_rf_reord_dirhp_mem_raddr),
       .rf_reord_dirhp_mem_rdata                             (i_hqm_system_mem_rf_reord_dirhp_mem_rdata),
       .rf_reord_dirhp_mem_isol_en                           (i_hqm_sip_pgcb_isol_en),
       .rf_reord_dirhp_mem_pwr_enable_b_in                   (i_hqm_system_mem_rf_reord_cnt_mem_pwr_enable_b_out),
       .rf_reord_dirhp_mem_pwr_enable_b_out                  (i_hqm_system_mem_rf_reord_dirhp_mem_pwr_enable_b_out),
       .rf_reord_dirtp_mem_wclk                              (i_hqm_sip_rf_reord_dirtp_mem_wclk),
       .rf_reord_dirtp_mem_wclk_rst_n                        (i_hqm_sip_rf_reord_dirtp_mem_wclk_rst_n),
       .rf_reord_dirtp_mem_we                                (i_hqm_sip_rf_reord_dirtp_mem_we),
       .rf_reord_dirtp_mem_waddr                             (i_hqm_sip_rf_reord_dirtp_mem_waddr),
       .rf_reord_dirtp_mem_wdata                             (i_hqm_sip_rf_reord_dirtp_mem_wdata),
       .rf_reord_dirtp_mem_rclk                              (i_hqm_sip_rf_reord_dirtp_mem_rclk),
       .rf_reord_dirtp_mem_rclk_rst_n                        (i_hqm_sip_rf_reord_dirtp_mem_rclk_rst_n),
       .rf_reord_dirtp_mem_re                                (i_hqm_sip_rf_reord_dirtp_mem_re),
       .rf_reord_dirtp_mem_raddr                             (i_hqm_sip_rf_reord_dirtp_mem_raddr),
       .rf_reord_dirtp_mem_rdata                             (i_hqm_system_mem_rf_reord_dirtp_mem_rdata),
       .rf_reord_dirtp_mem_isol_en                           (i_hqm_sip_pgcb_isol_en),
       .rf_reord_dirtp_mem_pwr_enable_b_in                   (i_hqm_system_mem_rf_reord_dirhp_mem_pwr_enable_b_out),
       .rf_reord_dirtp_mem_pwr_enable_b_out                  (i_hqm_system_mem_rf_reord_dirtp_mem_pwr_enable_b_out),
       .rf_reord_lbhp_mem_wclk                               (i_hqm_sip_rf_reord_lbhp_mem_wclk),
       .rf_reord_lbhp_mem_wclk_rst_n                         (i_hqm_sip_rf_reord_lbhp_mem_wclk_rst_n),
       .rf_reord_lbhp_mem_we                                 (i_hqm_sip_rf_reord_lbhp_mem_we),
       .rf_reord_lbhp_mem_waddr                              (i_hqm_sip_rf_reord_lbhp_mem_waddr),
       .rf_reord_lbhp_mem_wdata                              (i_hqm_sip_rf_reord_lbhp_mem_wdata),
       .rf_reord_lbhp_mem_rclk                               (i_hqm_sip_rf_reord_lbhp_mem_rclk),
       .rf_reord_lbhp_mem_rclk_rst_n                         (i_hqm_sip_rf_reord_lbhp_mem_rclk_rst_n),
       .rf_reord_lbhp_mem_re                                 (i_hqm_sip_rf_reord_lbhp_mem_re),
       .rf_reord_lbhp_mem_raddr                              (i_hqm_sip_rf_reord_lbhp_mem_raddr),
       .rf_reord_lbhp_mem_rdata                              (i_hqm_system_mem_rf_reord_lbhp_mem_rdata),
       .rf_reord_lbhp_mem_isol_en                            (i_hqm_sip_pgcb_isol_en),
       .rf_reord_lbhp_mem_pwr_enable_b_in                    (i_hqm_system_mem_rf_reord_dirtp_mem_pwr_enable_b_out),
       .rf_reord_lbhp_mem_pwr_enable_b_out                   (i_hqm_system_mem_rf_reord_lbhp_mem_pwr_enable_b_out),
       .rf_reord_lbtp_mem_wclk                               (i_hqm_sip_rf_reord_lbtp_mem_wclk),
       .rf_reord_lbtp_mem_wclk_rst_n                         (i_hqm_sip_rf_reord_lbtp_mem_wclk_rst_n),
       .rf_reord_lbtp_mem_we                                 (i_hqm_sip_rf_reord_lbtp_mem_we),
       .rf_reord_lbtp_mem_waddr                              (i_hqm_sip_rf_reord_lbtp_mem_waddr),
       .rf_reord_lbtp_mem_wdata                              (i_hqm_sip_rf_reord_lbtp_mem_wdata),
       .rf_reord_lbtp_mem_rclk                               (i_hqm_sip_rf_reord_lbtp_mem_rclk),
       .rf_reord_lbtp_mem_rclk_rst_n                         (i_hqm_sip_rf_reord_lbtp_mem_rclk_rst_n),
       .rf_reord_lbtp_mem_re                                 (i_hqm_sip_rf_reord_lbtp_mem_re),
       .rf_reord_lbtp_mem_raddr                              (i_hqm_sip_rf_reord_lbtp_mem_raddr),
       .rf_reord_lbtp_mem_rdata                              (i_hqm_system_mem_rf_reord_lbtp_mem_rdata),
       .rf_reord_lbtp_mem_isol_en                            (i_hqm_sip_pgcb_isol_en),
       .rf_reord_lbtp_mem_pwr_enable_b_in                    (i_hqm_system_mem_rf_reord_lbhp_mem_pwr_enable_b_out),
       .rf_reord_lbtp_mem_pwr_enable_b_out                   (i_hqm_system_mem_rf_reord_lbtp_mem_pwr_enable_b_out),
       .rf_reord_st_mem_wclk                                 (i_hqm_sip_rf_reord_st_mem_wclk),
       .rf_reord_st_mem_wclk_rst_n                           (i_hqm_sip_rf_reord_st_mem_wclk_rst_n),
       .rf_reord_st_mem_we                                   (i_hqm_sip_rf_reord_st_mem_we),
       .rf_reord_st_mem_waddr                                (i_hqm_sip_rf_reord_st_mem_waddr),
       .rf_reord_st_mem_wdata                                (i_hqm_sip_rf_reord_st_mem_wdata),
       .rf_reord_st_mem_rclk                                 (i_hqm_sip_rf_reord_st_mem_rclk),
       .rf_reord_st_mem_rclk_rst_n                           (i_hqm_sip_rf_reord_st_mem_rclk_rst_n),
       .rf_reord_st_mem_re                                   (i_hqm_sip_rf_reord_st_mem_re),
       .rf_reord_st_mem_raddr                                (i_hqm_sip_rf_reord_st_mem_raddr),
       .rf_reord_st_mem_rdata                                (i_hqm_system_mem_rf_reord_st_mem_rdata),
       .rf_reord_st_mem_isol_en                              (i_hqm_sip_pgcb_isol_en),
       .rf_reord_st_mem_pwr_enable_b_in                      (i_hqm_system_mem_rf_reord_lbtp_mem_pwr_enable_b_out),
       .rf_reord_st_mem_pwr_enable_b_out                     (i_hqm_system_mem_rf_reord_st_mem_pwr_enable_b_out),
       .rf_rop_chp_rop_hcw_fifo_mem_wclk                     (i_hqm_sip_rf_rop_chp_rop_hcw_fifo_mem_wclk),
       .rf_rop_chp_rop_hcw_fifo_mem_wclk_rst_n               (i_hqm_sip_rf_rop_chp_rop_hcw_fifo_mem_wclk_rst_n),
       .rf_rop_chp_rop_hcw_fifo_mem_we                       (i_hqm_sip_rf_rop_chp_rop_hcw_fifo_mem_we),
       .rf_rop_chp_rop_hcw_fifo_mem_waddr                    (i_hqm_sip_rf_rop_chp_rop_hcw_fifo_mem_waddr),
       .rf_rop_chp_rop_hcw_fifo_mem_wdata                    (i_hqm_sip_rf_rop_chp_rop_hcw_fifo_mem_wdata),
       .rf_rop_chp_rop_hcw_fifo_mem_rclk                     (i_hqm_sip_rf_rop_chp_rop_hcw_fifo_mem_rclk),
       .rf_rop_chp_rop_hcw_fifo_mem_rclk_rst_n               (i_hqm_sip_rf_rop_chp_rop_hcw_fifo_mem_rclk_rst_n),
       .rf_rop_chp_rop_hcw_fifo_mem_re                       (i_hqm_sip_rf_rop_chp_rop_hcw_fifo_mem_re),
       .rf_rop_chp_rop_hcw_fifo_mem_raddr                    (i_hqm_sip_rf_rop_chp_rop_hcw_fifo_mem_raddr),
       .rf_rop_chp_rop_hcw_fifo_mem_rdata                    (i_hqm_system_mem_rf_rop_chp_rop_hcw_fifo_mem_rdata),
       .rf_rop_chp_rop_hcw_fifo_mem_isol_en                  (i_hqm_sip_pgcb_isol_en),
       .rf_rop_chp_rop_hcw_fifo_mem_pwr_enable_b_in          (i_hqm_system_mem_rf_reord_st_mem_pwr_enable_b_out),
       .rf_rop_chp_rop_hcw_fifo_mem_pwr_enable_b_out         (i_hqm_system_mem_rf_rop_chp_rop_hcw_fifo_mem_pwr_enable_b_out),
       .rf_sch_out_fifo_wclk                                 (i_hqm_sip_rf_sch_out_fifo_wclk),
       .rf_sch_out_fifo_wclk_rst_n                           (i_hqm_sip_rf_sch_out_fifo_wclk_rst_n),
       .rf_sch_out_fifo_we                                   (i_hqm_sip_rf_sch_out_fifo_we),
       .rf_sch_out_fifo_waddr                                (i_hqm_sip_rf_sch_out_fifo_waddr),
       .rf_sch_out_fifo_wdata                                (i_hqm_sip_rf_sch_out_fifo_wdata),
       .rf_sch_out_fifo_rclk                                 (i_hqm_sip_rf_sch_out_fifo_rclk),
       .rf_sch_out_fifo_rclk_rst_n                           (i_hqm_sip_rf_sch_out_fifo_rclk_rst_n),
       .rf_sch_out_fifo_re                                   (i_hqm_sip_rf_sch_out_fifo_re),
       .rf_sch_out_fifo_raddr                                (i_hqm_sip_rf_sch_out_fifo_raddr),
       .rf_sch_out_fifo_rdata                                (i_hqm_system_mem_rf_sch_out_fifo_rdata),
       .rf_sch_out_fifo_isol_en                              (i_hqm_sip_pgcb_isol_en),
       .rf_sch_out_fifo_pwr_enable_b_in                      (i_hqm_system_mem_rf_rop_chp_rop_hcw_fifo_mem_pwr_enable_b_out),
       .rf_sch_out_fifo_pwr_enable_b_out                     (i_hqm_system_mem_rf_sch_out_fifo_pwr_enable_b_out),
       .rf_sn0_order_shft_mem_wclk                           (i_hqm_sip_rf_sn0_order_shft_mem_wclk),
       .rf_sn0_order_shft_mem_wclk_rst_n                     (i_hqm_sip_rf_sn0_order_shft_mem_wclk_rst_n),
       .rf_sn0_order_shft_mem_we                             (i_hqm_sip_rf_sn0_order_shft_mem_we),
       .rf_sn0_order_shft_mem_waddr                          (i_hqm_sip_rf_sn0_order_shft_mem_waddr),
       .rf_sn0_order_shft_mem_wdata                          (i_hqm_sip_rf_sn0_order_shft_mem_wdata),
       .rf_sn0_order_shft_mem_rclk                           (i_hqm_sip_rf_sn0_order_shft_mem_rclk),
       .rf_sn0_order_shft_mem_rclk_rst_n                     (i_hqm_sip_rf_sn0_order_shft_mem_rclk_rst_n),
       .rf_sn0_order_shft_mem_re                             (i_hqm_sip_rf_sn0_order_shft_mem_re),
       .rf_sn0_order_shft_mem_raddr                          (i_hqm_sip_rf_sn0_order_shft_mem_raddr),
       .rf_sn0_order_shft_mem_rdata                          (i_hqm_system_mem_rf_sn0_order_shft_mem_rdata),
       .rf_sn0_order_shft_mem_isol_en                        (i_hqm_sip_pgcb_isol_en),
       .rf_sn0_order_shft_mem_pwr_enable_b_in                (i_hqm_system_mem_rf_sch_out_fifo_pwr_enable_b_out),
       .rf_sn0_order_shft_mem_pwr_enable_b_out               (i_hqm_system_mem_rf_sn0_order_shft_mem_pwr_enable_b_out),
       .rf_sn1_order_shft_mem_wclk                           (i_hqm_sip_rf_sn1_order_shft_mem_wclk),
       .rf_sn1_order_shft_mem_wclk_rst_n                     (i_hqm_sip_rf_sn1_order_shft_mem_wclk_rst_n),
       .rf_sn1_order_shft_mem_we                             (i_hqm_sip_rf_sn1_order_shft_mem_we),
       .rf_sn1_order_shft_mem_waddr                          (i_hqm_sip_rf_sn1_order_shft_mem_waddr),
       .rf_sn1_order_shft_mem_wdata                          (i_hqm_sip_rf_sn1_order_shft_mem_wdata),
       .rf_sn1_order_shft_mem_rclk                           (i_hqm_sip_rf_sn1_order_shft_mem_rclk),
       .rf_sn1_order_shft_mem_rclk_rst_n                     (i_hqm_sip_rf_sn1_order_shft_mem_rclk_rst_n),
       .rf_sn1_order_shft_mem_re                             (i_hqm_sip_rf_sn1_order_shft_mem_re),
       .rf_sn1_order_shft_mem_raddr                          (i_hqm_sip_rf_sn1_order_shft_mem_raddr),
       .rf_sn1_order_shft_mem_rdata                          (i_hqm_system_mem_rf_sn1_order_shft_mem_rdata),
       .rf_sn1_order_shft_mem_isol_en                        (i_hqm_sip_pgcb_isol_en),
       .rf_sn1_order_shft_mem_pwr_enable_b_in                (i_hqm_system_mem_rf_sn0_order_shft_mem_pwr_enable_b_out),
       .rf_sn1_order_shft_mem_pwr_enable_b_out               (i_hqm_system_mem_rf_sn1_order_shft_mem_pwr_enable_b_out),
       .rf_sn_complete_fifo_mem_wclk                         (i_hqm_sip_rf_sn_complete_fifo_mem_wclk),
       .rf_sn_complete_fifo_mem_wclk_rst_n                   (i_hqm_sip_rf_sn_complete_fifo_mem_wclk_rst_n),
       .rf_sn_complete_fifo_mem_we                           (i_hqm_sip_rf_sn_complete_fifo_mem_we),
       .rf_sn_complete_fifo_mem_waddr                        (i_hqm_sip_rf_sn_complete_fifo_mem_waddr),
       .rf_sn_complete_fifo_mem_wdata                        (i_hqm_sip_rf_sn_complete_fifo_mem_wdata),
       .rf_sn_complete_fifo_mem_rclk                         (i_hqm_sip_rf_sn_complete_fifo_mem_rclk),
       .rf_sn_complete_fifo_mem_rclk_rst_n                   (i_hqm_sip_rf_sn_complete_fifo_mem_rclk_rst_n),
       .rf_sn_complete_fifo_mem_re                           (i_hqm_sip_rf_sn_complete_fifo_mem_re),
       .rf_sn_complete_fifo_mem_raddr                        (i_hqm_sip_rf_sn_complete_fifo_mem_raddr),
       .rf_sn_complete_fifo_mem_rdata                        (i_hqm_system_mem_rf_sn_complete_fifo_mem_rdata),
       .rf_sn_complete_fifo_mem_isol_en                      (i_hqm_sip_pgcb_isol_en),
       .rf_sn_complete_fifo_mem_pwr_enable_b_in              (i_hqm_system_mem_rf_sn1_order_shft_mem_pwr_enable_b_out),
       .rf_sn_complete_fifo_mem_pwr_enable_b_out             (i_hqm_system_mem_rf_sn_complete_fifo_mem_pwr_enable_b_out),
       .rf_sn_ordered_fifo_mem_wclk                          (i_hqm_sip_rf_sn_ordered_fifo_mem_wclk),
       .rf_sn_ordered_fifo_mem_wclk_rst_n                    (i_hqm_sip_rf_sn_ordered_fifo_mem_wclk_rst_n),
       .rf_sn_ordered_fifo_mem_we                            (i_hqm_sip_rf_sn_ordered_fifo_mem_we),
       .rf_sn_ordered_fifo_mem_waddr                         (i_hqm_sip_rf_sn_ordered_fifo_mem_waddr),
       .rf_sn_ordered_fifo_mem_wdata                         (i_hqm_sip_rf_sn_ordered_fifo_mem_wdata),
       .rf_sn_ordered_fifo_mem_rclk                          (i_hqm_sip_rf_sn_ordered_fifo_mem_rclk),
       .rf_sn_ordered_fifo_mem_rclk_rst_n                    (i_hqm_sip_rf_sn_ordered_fifo_mem_rclk_rst_n),
       .rf_sn_ordered_fifo_mem_re                            (i_hqm_sip_rf_sn_ordered_fifo_mem_re),
       .rf_sn_ordered_fifo_mem_raddr                         (i_hqm_sip_rf_sn_ordered_fifo_mem_raddr),
       .rf_sn_ordered_fifo_mem_rdata                         (i_hqm_system_mem_rf_sn_ordered_fifo_mem_rdata),
       .rf_sn_ordered_fifo_mem_isol_en                       (i_hqm_sip_pgcb_isol_en),
       .rf_sn_ordered_fifo_mem_pwr_enable_b_in               (i_hqm_system_mem_rf_sn_complete_fifo_mem_pwr_enable_b_out),
       .rf_sn_ordered_fifo_mem_pwr_enable_b_out              (i_hqm_system_mem_rf_sn_ordered_fifo_mem_pwr_enable_b_out),
       .rf_threshold_r_pipe_dir_mem_wclk                     (i_hqm_sip_rf_threshold_r_pipe_dir_mem_wclk),
       .rf_threshold_r_pipe_dir_mem_wclk_rst_n               (i_hqm_sip_rf_threshold_r_pipe_dir_mem_wclk_rst_n),
       .rf_threshold_r_pipe_dir_mem_we                       (i_hqm_sip_rf_threshold_r_pipe_dir_mem_we),
       .rf_threshold_r_pipe_dir_mem_waddr                    (i_hqm_sip_rf_threshold_r_pipe_dir_mem_waddr),
       .rf_threshold_r_pipe_dir_mem_wdata                    (i_hqm_sip_rf_threshold_r_pipe_dir_mem_wdata),
       .rf_threshold_r_pipe_dir_mem_rclk                     (i_hqm_sip_rf_threshold_r_pipe_dir_mem_rclk),
       .rf_threshold_r_pipe_dir_mem_rclk_rst_n               (i_hqm_sip_rf_threshold_r_pipe_dir_mem_rclk_rst_n),
       .rf_threshold_r_pipe_dir_mem_re                       (i_hqm_sip_rf_threshold_r_pipe_dir_mem_re),
       .rf_threshold_r_pipe_dir_mem_raddr                    (i_hqm_sip_rf_threshold_r_pipe_dir_mem_raddr),
       .rf_threshold_r_pipe_dir_mem_rdata                    (i_hqm_system_mem_rf_threshold_r_pipe_dir_mem_rdata),
       .rf_threshold_r_pipe_dir_mem_isol_en                  (i_hqm_sip_pgcb_isol_en),
       .rf_threshold_r_pipe_dir_mem_pwr_enable_b_in          (i_hqm_system_mem_rf_sn_ordered_fifo_mem_pwr_enable_b_out),
       .rf_threshold_r_pipe_dir_mem_pwr_enable_b_out         (i_hqm_system_mem_rf_threshold_r_pipe_dir_mem_pwr_enable_b_out),
       .rf_threshold_r_pipe_ldb_mem_wclk                     (i_hqm_sip_rf_threshold_r_pipe_ldb_mem_wclk),
       .rf_threshold_r_pipe_ldb_mem_wclk_rst_n               (i_hqm_sip_rf_threshold_r_pipe_ldb_mem_wclk_rst_n),
       .rf_threshold_r_pipe_ldb_mem_we                       (i_hqm_sip_rf_threshold_r_pipe_ldb_mem_we),
       .rf_threshold_r_pipe_ldb_mem_waddr                    (i_hqm_sip_rf_threshold_r_pipe_ldb_mem_waddr),
       .rf_threshold_r_pipe_ldb_mem_wdata                    (i_hqm_sip_rf_threshold_r_pipe_ldb_mem_wdata),
       .rf_threshold_r_pipe_ldb_mem_rclk                     (i_hqm_sip_rf_threshold_r_pipe_ldb_mem_rclk),
       .rf_threshold_r_pipe_ldb_mem_rclk_rst_n               (i_hqm_sip_rf_threshold_r_pipe_ldb_mem_rclk_rst_n),
       .rf_threshold_r_pipe_ldb_mem_re                       (i_hqm_sip_rf_threshold_r_pipe_ldb_mem_re),
       .rf_threshold_r_pipe_ldb_mem_raddr                    (i_hqm_sip_rf_threshold_r_pipe_ldb_mem_raddr),
       .rf_threshold_r_pipe_ldb_mem_rdata                    (i_hqm_system_mem_rf_threshold_r_pipe_ldb_mem_rdata),
       .rf_threshold_r_pipe_ldb_mem_isol_en                  (i_hqm_sip_pgcb_isol_en),
       .rf_threshold_r_pipe_ldb_mem_pwr_enable_b_in          (i_hqm_system_mem_rf_threshold_r_pipe_dir_mem_pwr_enable_b_out),
       .rf_threshold_r_pipe_ldb_mem_pwr_enable_b_out         (i_hqm_system_mem_rf_threshold_r_pipe_ldb_mem_pwr_enable_b_out),
       .sr_freelist_0_clk                                    (i_hqm_sip_sr_freelist_0_clk),
       .sr_freelist_0_clk_rst_n                              (i_hqm_sip_sr_freelist_0_clk_rst_n),
       .sr_freelist_0_addr                                   (i_hqm_sip_sr_freelist_0_addr),
       .sr_freelist_0_we                                     (i_hqm_sip_sr_freelist_0_we),
       .sr_freelist_0_wdata                                  (i_hqm_sip_sr_freelist_0_wdata),
       .sr_freelist_0_re                                     (i_hqm_sip_sr_freelist_0_re),
       .sr_freelist_0_rdata                                  (i_hqm_system_mem_sr_freelist_0_rdata),
       .sr_freelist_0_isol_en                                (i_hqm_sip_pgcb_isol_en),
       .sr_freelist_0_pwr_enable_b_in                        (i_hqm_qed_mem_rf_rx_sync_rop_qed_dqed_enq_pwr_enable_b_out),
       .sr_freelist_0_pwr_enable_b_out                       (i_hqm_system_mem_sr_freelist_0_pwr_enable_b_out),
       .sr_freelist_1_clk                                    (i_hqm_sip_sr_freelist_1_clk),
       .sr_freelist_1_clk_rst_n                              (i_hqm_sip_sr_freelist_1_clk_rst_n),
       .sr_freelist_1_addr                                   (i_hqm_sip_sr_freelist_1_addr),
       .sr_freelist_1_we                                     (i_hqm_sip_sr_freelist_1_we),
       .sr_freelist_1_wdata                                  (i_hqm_sip_sr_freelist_1_wdata),
       .sr_freelist_1_re                                     (i_hqm_sip_sr_freelist_1_re),
       .sr_freelist_1_rdata                                  (i_hqm_system_mem_sr_freelist_1_rdata),
       .sr_freelist_1_isol_en                                (i_hqm_sip_pgcb_isol_en),
       .sr_freelist_1_pwr_enable_b_in                        (i_hqm_system_mem_sr_freelist_0_pwr_enable_b_out),
       .sr_freelist_1_pwr_enable_b_out                       (i_hqm_system_mem_sr_freelist_1_pwr_enable_b_out),
       .sr_freelist_2_clk                                    (i_hqm_sip_sr_freelist_2_clk),
       .sr_freelist_2_clk_rst_n                              (i_hqm_sip_sr_freelist_2_clk_rst_n),
       .sr_freelist_2_addr                                   (i_hqm_sip_sr_freelist_2_addr),
       .sr_freelist_2_we                                     (i_hqm_sip_sr_freelist_2_we),
       .sr_freelist_2_wdata                                  (i_hqm_sip_sr_freelist_2_wdata),
       .sr_freelist_2_re                                     (i_hqm_sip_sr_freelist_2_re),
       .sr_freelist_2_rdata                                  (i_hqm_system_mem_sr_freelist_2_rdata),
       .sr_freelist_2_isol_en                                (i_hqm_sip_pgcb_isol_en),
       .sr_freelist_2_pwr_enable_b_in                        (i_hqm_system_mem_sr_freelist_1_pwr_enable_b_out),
       .sr_freelist_2_pwr_enable_b_out                       (i_hqm_system_mem_sr_freelist_2_pwr_enable_b_out),
       .sr_freelist_3_clk                                    (i_hqm_sip_sr_freelist_3_clk),
       .sr_freelist_3_clk_rst_n                              (i_hqm_sip_sr_freelist_3_clk_rst_n),
       .sr_freelist_3_addr                                   (i_hqm_sip_sr_freelist_3_addr),
       .sr_freelist_3_we                                     (i_hqm_sip_sr_freelist_3_we),
       .sr_freelist_3_wdata                                  (i_hqm_sip_sr_freelist_3_wdata),
       .sr_freelist_3_re                                     (i_hqm_sip_sr_freelist_3_re),
       .sr_freelist_3_rdata                                  (i_hqm_system_mem_sr_freelist_3_rdata),
       .sr_freelist_3_isol_en                                (i_hqm_sip_pgcb_isol_en),
       .sr_freelist_3_pwr_enable_b_in                        (i_hqm_system_mem_sr_freelist_2_pwr_enable_b_out),
       .sr_freelist_3_pwr_enable_b_out                       (i_hqm_system_mem_sr_freelist_3_pwr_enable_b_out),
       .sr_freelist_4_clk                                    (i_hqm_sip_sr_freelist_4_clk),
       .sr_freelist_4_clk_rst_n                              (i_hqm_sip_sr_freelist_4_clk_rst_n),
       .sr_freelist_4_addr                                   (i_hqm_sip_sr_freelist_4_addr),
       .sr_freelist_4_we                                     (i_hqm_sip_sr_freelist_4_we),
       .sr_freelist_4_wdata                                  (i_hqm_sip_sr_freelist_4_wdata),
       .sr_freelist_4_re                                     (i_hqm_sip_sr_freelist_4_re),
       .sr_freelist_4_rdata                                  (i_hqm_system_mem_sr_freelist_4_rdata),
       .sr_freelist_4_isol_en                                (i_hqm_sip_pgcb_isol_en),
       .sr_freelist_4_pwr_enable_b_in                        (i_hqm_system_mem_sr_freelist_3_pwr_enable_b_out),
       .sr_freelist_4_pwr_enable_b_out                       (i_hqm_system_mem_sr_freelist_4_pwr_enable_b_out),
       .sr_freelist_5_clk                                    (i_hqm_sip_sr_freelist_5_clk),
       .sr_freelist_5_clk_rst_n                              (i_hqm_sip_sr_freelist_5_clk_rst_n),
       .sr_freelist_5_addr                                   (i_hqm_sip_sr_freelist_5_addr),
       .sr_freelist_5_we                                     (i_hqm_sip_sr_freelist_5_we),
       .sr_freelist_5_wdata                                  (i_hqm_sip_sr_freelist_5_wdata),
       .sr_freelist_5_re                                     (i_hqm_sip_sr_freelist_5_re),
       .sr_freelist_5_rdata                                  (i_hqm_system_mem_sr_freelist_5_rdata),
       .sr_freelist_5_isol_en                                (i_hqm_sip_pgcb_isol_en),
       .sr_freelist_5_pwr_enable_b_in                        (i_hqm_system_mem_sr_freelist_4_pwr_enable_b_out),
       .sr_freelist_5_pwr_enable_b_out                       (i_hqm_system_mem_sr_freelist_5_pwr_enable_b_out),
       .sr_freelist_6_clk                                    (i_hqm_sip_sr_freelist_6_clk),
       .sr_freelist_6_clk_rst_n                              (i_hqm_sip_sr_freelist_6_clk_rst_n),
       .sr_freelist_6_addr                                   (i_hqm_sip_sr_freelist_6_addr),
       .sr_freelist_6_we                                     (i_hqm_sip_sr_freelist_6_we),
       .sr_freelist_6_wdata                                  (i_hqm_sip_sr_freelist_6_wdata),
       .sr_freelist_6_re                                     (i_hqm_sip_sr_freelist_6_re),
       .sr_freelist_6_rdata                                  (i_hqm_system_mem_sr_freelist_6_rdata),
       .sr_freelist_6_isol_en                                (i_hqm_sip_pgcb_isol_en),
       .sr_freelist_6_pwr_enable_b_in                        (i_hqm_system_mem_sr_freelist_5_pwr_enable_b_out),
       .sr_freelist_6_pwr_enable_b_out                       (i_hqm_system_mem_sr_freelist_6_pwr_enable_b_out),
       .sr_freelist_7_clk                                    (i_hqm_sip_sr_freelist_7_clk),
       .sr_freelist_7_clk_rst_n                              (i_hqm_sip_sr_freelist_7_clk_rst_n),
       .sr_freelist_7_addr                                   (i_hqm_sip_sr_freelist_7_addr),
       .sr_freelist_7_we                                     (i_hqm_sip_sr_freelist_7_we),
       .sr_freelist_7_wdata                                  (i_hqm_sip_sr_freelist_7_wdata),
       .sr_freelist_7_re                                     (i_hqm_sip_sr_freelist_7_re),
       .sr_freelist_7_rdata                                  (i_hqm_system_mem_sr_freelist_7_rdata),
       .sr_freelist_7_isol_en                                (i_hqm_sip_pgcb_isol_en),
       .sr_freelist_7_pwr_enable_b_in                        (i_hqm_system_mem_sr_freelist_6_pwr_enable_b_out),
       .sr_freelist_7_pwr_enable_b_out                       (i_hqm_system_mem_sr_freelist_7_pwr_enable_b_out),
       .sr_hist_list_clk                                     (i_hqm_sip_sr_hist_list_clk),
       .sr_hist_list_clk_rst_n                               (i_hqm_sip_sr_hist_list_clk_rst_n),
       .sr_hist_list_addr                                    (i_hqm_sip_sr_hist_list_addr),
       .sr_hist_list_we                                      (i_hqm_sip_sr_hist_list_we),
       .sr_hist_list_wdata                                   (i_hqm_sip_sr_hist_list_wdata),
       .sr_hist_list_re                                      (i_hqm_sip_sr_hist_list_re),
       .sr_hist_list_rdata                                   (i_hqm_system_mem_sr_hist_list_rdata),
       .sr_hist_list_isol_en                                 (i_hqm_sip_pgcb_isol_en),
       .sr_hist_list_pwr_enable_b_in                         (i_hqm_system_mem_sr_freelist_7_pwr_enable_b_out),
       .sr_hist_list_pwr_enable_b_out                        (i_hqm_system_mem_sr_hist_list_pwr_enable_b_out),
       .sr_hist_list_a_clk                                   (i_hqm_sip_sr_hist_list_a_clk),
       .sr_hist_list_a_clk_rst_n                             (i_hqm_sip_sr_hist_list_a_clk_rst_n),
       .sr_hist_list_a_addr                                  (i_hqm_sip_sr_hist_list_a_addr),
       .sr_hist_list_a_we                                    (i_hqm_sip_sr_hist_list_a_we),
       .sr_hist_list_a_wdata                                 (i_hqm_sip_sr_hist_list_a_wdata),
       .sr_hist_list_a_re                                    (i_hqm_sip_sr_hist_list_a_re),
       .sr_hist_list_a_rdata                                 (i_hqm_system_mem_sr_hist_list_a_rdata),
       .sr_hist_list_a_isol_en                               (i_hqm_sip_pgcb_isol_en),
       .sr_hist_list_a_pwr_enable_b_in                       (i_hqm_system_mem_sr_hist_list_pwr_enable_b_out),
       .sr_hist_list_a_pwr_enable_b_out                      (i_hqm_system_mem_sr_hist_list_a_pwr_enable_b_out),
       .sr_rob_mem_clk                                       (i_hqm_sip_sr_rob_mem_clk),
       .sr_rob_mem_clk_rst_n                                 (i_hqm_sip_sr_rob_mem_clk_rst_n),
       .sr_rob_mem_addr                                      (i_hqm_sip_sr_rob_mem_addr),
       .sr_rob_mem_we                                        (i_hqm_sip_sr_rob_mem_we),
       .sr_rob_mem_wdata                                     (i_hqm_sip_sr_rob_mem_wdata),
       .sr_rob_mem_re                                        (i_hqm_sip_sr_rob_mem_re),
       .sr_rob_mem_rdata                                     (i_hqm_system_mem_sr_rob_mem_rdata),
       .sr_rob_mem_isol_en                                   (i_hqm_sip_pgcb_isol_en),
       .sr_rob_mem_pwr_enable_b_in                           (i_hqm_system_mem_sr_hist_list_a_pwr_enable_b_out),
       .sr_rob_mem_pwr_enable_b_out                          (i_hqm_system_mem_sr_rob_mem_pwr_enable_b_out),
       .rf_count_rmw_pipe_wd_dir_mem_wclk                    (i_hqm_sip_rf_count_rmw_pipe_wd_dir_mem_wclk),
       .rf_count_rmw_pipe_wd_dir_mem_wclk_rst_n              (i_hqm_sip_rf_count_rmw_pipe_wd_dir_mem_wclk_rst_n),
       .rf_count_rmw_pipe_wd_dir_mem_we                      (i_hqm_sip_rf_count_rmw_pipe_wd_dir_mem_we),
       .rf_count_rmw_pipe_wd_dir_mem_waddr                   (i_hqm_sip_rf_count_rmw_pipe_wd_dir_mem_waddr),
       .rf_count_rmw_pipe_wd_dir_mem_wdata                   (i_hqm_sip_rf_count_rmw_pipe_wd_dir_mem_wdata),
       .rf_count_rmw_pipe_wd_dir_mem_rclk                    (i_hqm_sip_rf_count_rmw_pipe_wd_dir_mem_rclk),
       .rf_count_rmw_pipe_wd_dir_mem_rclk_rst_n              (i_hqm_sip_rf_count_rmw_pipe_wd_dir_mem_rclk_rst_n),
       .rf_count_rmw_pipe_wd_dir_mem_re                      (i_hqm_sip_rf_count_rmw_pipe_wd_dir_mem_re),
       .rf_count_rmw_pipe_wd_dir_mem_raddr                   (i_hqm_sip_rf_count_rmw_pipe_wd_dir_mem_raddr),
       .rf_count_rmw_pipe_wd_dir_mem_rdata                   (i_hqm_system_mem_rf_count_rmw_pipe_wd_dir_mem_rdata),
       .rf_count_rmw_pipe_wd_dir_mem_isol_en                 (i_hqm_sip_pgcb_isol_en),
       .rf_count_rmw_pipe_wd_dir_mem_pwr_enable_b_in         (i_hqm_system_mem_rf_count_rmw_pipe_ldb_mem_pwr_enable_b_out),
       .rf_count_rmw_pipe_wd_dir_mem_pwr_enable_b_out        (i_hqm_system_mem_rf_count_rmw_pipe_wd_dir_mem_pwr_enable_b_out),
       .rf_count_rmw_pipe_wd_ldb_mem_wclk                    (i_hqm_sip_rf_count_rmw_pipe_wd_ldb_mem_wclk),
       .rf_count_rmw_pipe_wd_ldb_mem_wclk_rst_n              (i_hqm_sip_rf_count_rmw_pipe_wd_ldb_mem_wclk_rst_n),
       .rf_count_rmw_pipe_wd_ldb_mem_we                      (i_hqm_sip_rf_count_rmw_pipe_wd_ldb_mem_we),
       .rf_count_rmw_pipe_wd_ldb_mem_waddr                   (i_hqm_sip_rf_count_rmw_pipe_wd_ldb_mem_waddr),
       .rf_count_rmw_pipe_wd_ldb_mem_wdata                   (i_hqm_sip_rf_count_rmw_pipe_wd_ldb_mem_wdata),
       .rf_count_rmw_pipe_wd_ldb_mem_rclk                    (i_hqm_sip_rf_count_rmw_pipe_wd_ldb_mem_rclk),
       .rf_count_rmw_pipe_wd_ldb_mem_rclk_rst_n              (i_hqm_sip_rf_count_rmw_pipe_wd_ldb_mem_rclk_rst_n),
       .rf_count_rmw_pipe_wd_ldb_mem_re                      (i_hqm_sip_rf_count_rmw_pipe_wd_ldb_mem_re),
       .rf_count_rmw_pipe_wd_ldb_mem_raddr                   (i_hqm_sip_rf_count_rmw_pipe_wd_ldb_mem_raddr),
       .rf_count_rmw_pipe_wd_ldb_mem_rdata                   (i_hqm_system_mem_rf_count_rmw_pipe_wd_ldb_mem_rdata),
       .rf_count_rmw_pipe_wd_ldb_mem_isol_en                 (i_hqm_sip_pgcb_isol_en),
       .rf_count_rmw_pipe_wd_ldb_mem_pwr_enable_b_in         (i_hqm_system_mem_rf_count_rmw_pipe_wd_dir_mem_pwr_enable_b_out),
       .rf_count_rmw_pipe_wd_ldb_mem_pwr_enable_b_out        (i_hqm_system_mem_rf_count_rmw_pipe_wd_ldb_mem_pwr_enable_b_out),
       .rf_ibcpl_data_fifo_wclk                              (i_hqm_sip_rf_ibcpl_data_fifo_wclk),
       .rf_ibcpl_data_fifo_wclk_rst_n                        (i_hqm_sip_rf_ibcpl_data_fifo_wclk_rst_n),
       .rf_ibcpl_data_fifo_we                                (i_hqm_sip_rf_ibcpl_data_fifo_we),
       .rf_ibcpl_data_fifo_waddr                             (i_hqm_sip_rf_ibcpl_data_fifo_waddr),
       .rf_ibcpl_data_fifo_wdata                             (i_hqm_sip_rf_ibcpl_data_fifo_wdata),
       .rf_ibcpl_data_fifo_rclk                              (i_hqm_sip_rf_ibcpl_data_fifo_rclk),
       .rf_ibcpl_data_fifo_rclk_rst_n                        (i_hqm_sip_rf_ibcpl_data_fifo_rclk_rst_n),
       .rf_ibcpl_data_fifo_re                                (i_hqm_sip_rf_ibcpl_data_fifo_re),
       .rf_ibcpl_data_fifo_raddr                             (i_hqm_sip_rf_ibcpl_data_fifo_raddr),
       .rf_ibcpl_data_fifo_rdata                             (i_hqm_system_mem_rf_ibcpl_data_fifo_rdata),
       .rf_ibcpl_hdr_fifo_wclk                               (i_hqm_sip_rf_ibcpl_hdr_fifo_wclk),
       .rf_ibcpl_hdr_fifo_wclk_rst_n                         (i_hqm_sip_rf_ibcpl_hdr_fifo_wclk_rst_n),
       .rf_ibcpl_hdr_fifo_we                                 (i_hqm_sip_rf_ibcpl_hdr_fifo_we),
       .rf_ibcpl_hdr_fifo_waddr                              (i_hqm_sip_rf_ibcpl_hdr_fifo_waddr),
       .rf_ibcpl_hdr_fifo_wdata                              (i_hqm_sip_rf_ibcpl_hdr_fifo_wdata),
       .rf_ibcpl_hdr_fifo_rclk                               (i_hqm_sip_rf_ibcpl_hdr_fifo_rclk),
       .rf_ibcpl_hdr_fifo_rclk_rst_n                         (i_hqm_sip_rf_ibcpl_hdr_fifo_rclk_rst_n),
       .rf_ibcpl_hdr_fifo_re                                 (i_hqm_sip_rf_ibcpl_hdr_fifo_re),
       .rf_ibcpl_hdr_fifo_raddr                              (i_hqm_sip_rf_ibcpl_hdr_fifo_raddr),
       .rf_ibcpl_hdr_fifo_rdata                              (i_hqm_system_mem_rf_ibcpl_hdr_fifo_rdata),
       .rf_mstr_ll_data0_wclk                                (i_hqm_sip_rf_mstr_ll_data0_wclk),
       .rf_mstr_ll_data0_wclk_rst_n                          (i_hqm_sip_rf_mstr_ll_data0_wclk_rst_n),
       .rf_mstr_ll_data0_we                                  (i_hqm_sip_rf_mstr_ll_data0_we),
       .rf_mstr_ll_data0_waddr                               (i_hqm_sip_rf_mstr_ll_data0_waddr),
       .rf_mstr_ll_data0_wdata                               (i_hqm_sip_rf_mstr_ll_data0_wdata),
       .rf_mstr_ll_data0_rclk                                (i_hqm_sip_rf_mstr_ll_data0_rclk),
       .rf_mstr_ll_data0_rclk_rst_n                          (i_hqm_sip_rf_mstr_ll_data0_rclk_rst_n),
       .rf_mstr_ll_data0_re                                  (i_hqm_sip_rf_mstr_ll_data0_re),
       .rf_mstr_ll_data0_raddr                               (i_hqm_sip_rf_mstr_ll_data0_raddr),
       .rf_mstr_ll_data0_rdata                               (i_hqm_system_mem_rf_mstr_ll_data0_rdata),
       .rf_mstr_ll_data1_wclk                                (i_hqm_sip_rf_mstr_ll_data1_wclk),
       .rf_mstr_ll_data1_wclk_rst_n                          (i_hqm_sip_rf_mstr_ll_data1_wclk_rst_n),
       .rf_mstr_ll_data1_we                                  (i_hqm_sip_rf_mstr_ll_data1_we),
       .rf_mstr_ll_data1_waddr                               (i_hqm_sip_rf_mstr_ll_data1_waddr),
       .rf_mstr_ll_data1_wdata                               (i_hqm_sip_rf_mstr_ll_data1_wdata),
       .rf_mstr_ll_data1_rclk                                (i_hqm_sip_rf_mstr_ll_data1_rclk),
       .rf_mstr_ll_data1_rclk_rst_n                          (i_hqm_sip_rf_mstr_ll_data1_rclk_rst_n),
       .rf_mstr_ll_data1_re                                  (i_hqm_sip_rf_mstr_ll_data1_re),
       .rf_mstr_ll_data1_raddr                               (i_hqm_sip_rf_mstr_ll_data1_raddr),
       .rf_mstr_ll_data1_rdata                               (i_hqm_system_mem_rf_mstr_ll_data1_rdata),
       .rf_mstr_ll_data2_wclk                                (i_hqm_sip_rf_mstr_ll_data2_wclk),
       .rf_mstr_ll_data2_wclk_rst_n                          (i_hqm_sip_rf_mstr_ll_data2_wclk_rst_n),
       .rf_mstr_ll_data2_we                                  (i_hqm_sip_rf_mstr_ll_data2_we),
       .rf_mstr_ll_data2_waddr                               (i_hqm_sip_rf_mstr_ll_data2_waddr),
       .rf_mstr_ll_data2_wdata                               (i_hqm_sip_rf_mstr_ll_data2_wdata),
       .rf_mstr_ll_data2_rclk                                (i_hqm_sip_rf_mstr_ll_data2_rclk),
       .rf_mstr_ll_data2_rclk_rst_n                          (i_hqm_sip_rf_mstr_ll_data2_rclk_rst_n),
       .rf_mstr_ll_data2_re                                  (i_hqm_sip_rf_mstr_ll_data2_re),
       .rf_mstr_ll_data2_raddr                               (i_hqm_sip_rf_mstr_ll_data2_raddr),
       .rf_mstr_ll_data2_rdata                               (i_hqm_system_mem_rf_mstr_ll_data2_rdata),
       .rf_mstr_ll_data3_wclk                                (i_hqm_sip_rf_mstr_ll_data3_wclk),
       .rf_mstr_ll_data3_wclk_rst_n                          (i_hqm_sip_rf_mstr_ll_data3_wclk_rst_n),
       .rf_mstr_ll_data3_we                                  (i_hqm_sip_rf_mstr_ll_data3_we),
       .rf_mstr_ll_data3_waddr                               (i_hqm_sip_rf_mstr_ll_data3_waddr),
       .rf_mstr_ll_data3_wdata                               (i_hqm_sip_rf_mstr_ll_data3_wdata),
       .rf_mstr_ll_data3_rclk                                (i_hqm_sip_rf_mstr_ll_data3_rclk),
       .rf_mstr_ll_data3_rclk_rst_n                          (i_hqm_sip_rf_mstr_ll_data3_rclk_rst_n),
       .rf_mstr_ll_data3_re                                  (i_hqm_sip_rf_mstr_ll_data3_re),
       .rf_mstr_ll_data3_raddr                               (i_hqm_sip_rf_mstr_ll_data3_raddr),
       .rf_mstr_ll_data3_rdata                               (i_hqm_system_mem_rf_mstr_ll_data3_rdata),
       .rf_mstr_ll_hdr_wclk                                  (i_hqm_sip_rf_mstr_ll_hdr_wclk),
       .rf_mstr_ll_hdr_wclk_rst_n                            (i_hqm_sip_rf_mstr_ll_hdr_wclk_rst_n),
       .rf_mstr_ll_hdr_we                                    (i_hqm_sip_rf_mstr_ll_hdr_we),
       .rf_mstr_ll_hdr_waddr                                 (i_hqm_sip_rf_mstr_ll_hdr_waddr),
       .rf_mstr_ll_hdr_wdata                                 (i_hqm_sip_rf_mstr_ll_hdr_wdata),
       .rf_mstr_ll_hdr_rclk                                  (i_hqm_sip_rf_mstr_ll_hdr_rclk),
       .rf_mstr_ll_hdr_rclk_rst_n                            (i_hqm_sip_rf_mstr_ll_hdr_rclk_rst_n),
       .rf_mstr_ll_hdr_re                                    (i_hqm_sip_rf_mstr_ll_hdr_re),
       .rf_mstr_ll_hdr_raddr                                 (i_hqm_sip_rf_mstr_ll_hdr_raddr),
       .rf_mstr_ll_hdr_rdata                                 (i_hqm_system_mem_rf_mstr_ll_hdr_rdata),
       .rf_mstr_ll_hpa_wclk                                  (i_hqm_sip_rf_mstr_ll_hpa_wclk),
       .rf_mstr_ll_hpa_wclk_rst_n                            (i_hqm_sip_rf_mstr_ll_hpa_wclk_rst_n),
       .rf_mstr_ll_hpa_we                                    (i_hqm_sip_rf_mstr_ll_hpa_we),
       .rf_mstr_ll_hpa_waddr                                 (i_hqm_sip_rf_mstr_ll_hpa_waddr),
       .rf_mstr_ll_hpa_wdata                                 (i_hqm_sip_rf_mstr_ll_hpa_wdata),
       .rf_mstr_ll_hpa_rclk                                  (i_hqm_sip_rf_mstr_ll_hpa_rclk),
       .rf_mstr_ll_hpa_rclk_rst_n                            (i_hqm_sip_rf_mstr_ll_hpa_rclk_rst_n),
       .rf_mstr_ll_hpa_re                                    (i_hqm_sip_rf_mstr_ll_hpa_re),
       .rf_mstr_ll_hpa_raddr                                 (i_hqm_sip_rf_mstr_ll_hpa_raddr),
       .rf_mstr_ll_hpa_rdata                                 (i_hqm_system_mem_rf_mstr_ll_hpa_rdata),
       .rf_ri_tlq_fifo_npdata_wclk                           (i_hqm_sip_rf_ri_tlq_fifo_npdata_wclk),
       .rf_ri_tlq_fifo_npdata_wclk_rst_n                     (i_hqm_sip_rf_ri_tlq_fifo_npdata_wclk_rst_n),
       .rf_ri_tlq_fifo_npdata_we                             (i_hqm_sip_rf_ri_tlq_fifo_npdata_we),
       .rf_ri_tlq_fifo_npdata_waddr                          (i_hqm_sip_rf_ri_tlq_fifo_npdata_waddr),
       .rf_ri_tlq_fifo_npdata_wdata                          (i_hqm_sip_rf_ri_tlq_fifo_npdata_wdata),
       .rf_ri_tlq_fifo_npdata_rclk                           (i_hqm_sip_rf_ri_tlq_fifo_npdata_rclk),
       .rf_ri_tlq_fifo_npdata_rclk_rst_n                     (i_hqm_sip_rf_ri_tlq_fifo_npdata_rclk_rst_n),
       .rf_ri_tlq_fifo_npdata_re                             (i_hqm_sip_rf_ri_tlq_fifo_npdata_re),
       .rf_ri_tlq_fifo_npdata_raddr                          (i_hqm_sip_rf_ri_tlq_fifo_npdata_raddr),
       .rf_ri_tlq_fifo_npdata_rdata                          (i_hqm_system_mem_rf_ri_tlq_fifo_npdata_rdata),
       .rf_ri_tlq_fifo_nphdr_wclk                            (i_hqm_sip_rf_ri_tlq_fifo_nphdr_wclk),
       .rf_ri_tlq_fifo_nphdr_wclk_rst_n                      (i_hqm_sip_rf_ri_tlq_fifo_nphdr_wclk_rst_n),
       .rf_ri_tlq_fifo_nphdr_we                              (i_hqm_sip_rf_ri_tlq_fifo_nphdr_we),
       .rf_ri_tlq_fifo_nphdr_waddr                           (i_hqm_sip_rf_ri_tlq_fifo_nphdr_waddr),
       .rf_ri_tlq_fifo_nphdr_wdata                           (i_hqm_sip_rf_ri_tlq_fifo_nphdr_wdata),
       .rf_ri_tlq_fifo_nphdr_rclk                            (i_hqm_sip_rf_ri_tlq_fifo_nphdr_rclk),
       .rf_ri_tlq_fifo_nphdr_rclk_rst_n                      (i_hqm_sip_rf_ri_tlq_fifo_nphdr_rclk_rst_n),
       .rf_ri_tlq_fifo_nphdr_re                              (i_hqm_sip_rf_ri_tlq_fifo_nphdr_re),
       .rf_ri_tlq_fifo_nphdr_raddr                           (i_hqm_sip_rf_ri_tlq_fifo_nphdr_raddr),
       .rf_ri_tlq_fifo_nphdr_rdata                           (i_hqm_system_mem_rf_ri_tlq_fifo_nphdr_rdata),
       .rf_ri_tlq_fifo_pdata_wclk                            (i_hqm_sip_rf_ri_tlq_fifo_pdata_wclk),
       .rf_ri_tlq_fifo_pdata_wclk_rst_n                      (i_hqm_sip_rf_ri_tlq_fifo_pdata_wclk_rst_n),
       .rf_ri_tlq_fifo_pdata_we                              (i_hqm_sip_rf_ri_tlq_fifo_pdata_we),
       .rf_ri_tlq_fifo_pdata_waddr                           (i_hqm_sip_rf_ri_tlq_fifo_pdata_waddr),
       .rf_ri_tlq_fifo_pdata_wdata                           (i_hqm_sip_rf_ri_tlq_fifo_pdata_wdata),
       .rf_ri_tlq_fifo_pdata_rclk                            (i_hqm_sip_rf_ri_tlq_fifo_pdata_rclk),
       .rf_ri_tlq_fifo_pdata_rclk_rst_n                      (i_hqm_sip_rf_ri_tlq_fifo_pdata_rclk_rst_n),
       .rf_ri_tlq_fifo_pdata_re                              (i_hqm_sip_rf_ri_tlq_fifo_pdata_re),
       .rf_ri_tlq_fifo_pdata_raddr                           (i_hqm_sip_rf_ri_tlq_fifo_pdata_raddr),
       .rf_ri_tlq_fifo_pdata_rdata                           (i_hqm_system_mem_rf_ri_tlq_fifo_pdata_rdata),
       .rf_ri_tlq_fifo_phdr_wclk                             (i_hqm_sip_rf_ri_tlq_fifo_phdr_wclk),
       .rf_ri_tlq_fifo_phdr_wclk_rst_n                       (i_hqm_sip_rf_ri_tlq_fifo_phdr_wclk_rst_n),
       .rf_ri_tlq_fifo_phdr_we                               (i_hqm_sip_rf_ri_tlq_fifo_phdr_we),
       .rf_ri_tlq_fifo_phdr_waddr                            (i_hqm_sip_rf_ri_tlq_fifo_phdr_waddr),
       .rf_ri_tlq_fifo_phdr_wdata                            (i_hqm_sip_rf_ri_tlq_fifo_phdr_wdata),
       .rf_ri_tlq_fifo_phdr_rclk                             (i_hqm_sip_rf_ri_tlq_fifo_phdr_rclk),
       .rf_ri_tlq_fifo_phdr_rclk_rst_n                       (i_hqm_sip_rf_ri_tlq_fifo_phdr_rclk_rst_n),
       .rf_ri_tlq_fifo_phdr_re                               (i_hqm_sip_rf_ri_tlq_fifo_phdr_re),
       .rf_ri_tlq_fifo_phdr_raddr                            (i_hqm_sip_rf_ri_tlq_fifo_phdr_raddr),
       .rf_ri_tlq_fifo_phdr_rdata                            (i_hqm_system_mem_rf_ri_tlq_fifo_phdr_rdata),
       .rf_scrbd_mem_wclk                                    (i_hqm_sip_rf_scrbd_mem_wclk),
       .rf_scrbd_mem_wclk_rst_n                              (i_hqm_sip_rf_scrbd_mem_wclk_rst_n),
       .rf_scrbd_mem_we                                      (i_hqm_sip_rf_scrbd_mem_we),
       .rf_scrbd_mem_waddr                                   (i_hqm_sip_rf_scrbd_mem_waddr),
       .rf_scrbd_mem_wdata                                   (i_hqm_sip_rf_scrbd_mem_wdata),
       .rf_scrbd_mem_rclk                                    (i_hqm_sip_rf_scrbd_mem_rclk),
       .rf_scrbd_mem_rclk_rst_n                              (i_hqm_sip_rf_scrbd_mem_rclk_rst_n),
       .rf_scrbd_mem_re                                      (i_hqm_sip_rf_scrbd_mem_re),
       .rf_scrbd_mem_raddr                                   (i_hqm_sip_rf_scrbd_mem_raddr),
       .rf_scrbd_mem_rdata                                   (i_hqm_system_mem_rf_scrbd_mem_rdata),
       .rf_tlb_data0_4k_wclk                                 (i_hqm_sip_rf_tlb_data0_4k_wclk),
       .rf_tlb_data0_4k_wclk_rst_n                           (i_hqm_sip_rf_tlb_data0_4k_wclk_rst_n),
       .rf_tlb_data0_4k_we                                   (i_hqm_sip_rf_tlb_data0_4k_we),
       .rf_tlb_data0_4k_waddr                                (i_hqm_sip_rf_tlb_data0_4k_waddr),
       .rf_tlb_data0_4k_wdata                                (i_hqm_sip_rf_tlb_data0_4k_wdata),
       .rf_tlb_data0_4k_rclk                                 (i_hqm_sip_rf_tlb_data0_4k_rclk),
       .rf_tlb_data0_4k_rclk_rst_n                           (i_hqm_sip_rf_tlb_data0_4k_rclk_rst_n),
       .rf_tlb_data0_4k_re                                   (i_hqm_sip_rf_tlb_data0_4k_re),
       .rf_tlb_data0_4k_raddr                                (i_hqm_sip_rf_tlb_data0_4k_raddr),
       .rf_tlb_data0_4k_rdata                                (i_hqm_system_mem_rf_tlb_data0_4k_rdata),
       .rf_tlb_data1_4k_wclk                                 (i_hqm_sip_rf_tlb_data1_4k_wclk),
       .rf_tlb_data1_4k_wclk_rst_n                           (i_hqm_sip_rf_tlb_data1_4k_wclk_rst_n),
       .rf_tlb_data1_4k_we                                   (i_hqm_sip_rf_tlb_data1_4k_we),
       .rf_tlb_data1_4k_waddr                                (i_hqm_sip_rf_tlb_data1_4k_waddr),
       .rf_tlb_data1_4k_wdata                                (i_hqm_sip_rf_tlb_data1_4k_wdata),
       .rf_tlb_data1_4k_rclk                                 (i_hqm_sip_rf_tlb_data1_4k_rclk),
       .rf_tlb_data1_4k_rclk_rst_n                           (i_hqm_sip_rf_tlb_data1_4k_rclk_rst_n),
       .rf_tlb_data1_4k_re                                   (i_hqm_sip_rf_tlb_data1_4k_re),
       .rf_tlb_data1_4k_raddr                                (i_hqm_sip_rf_tlb_data1_4k_raddr),
       .rf_tlb_data1_4k_rdata                                (i_hqm_system_mem_rf_tlb_data1_4k_rdata),
       .rf_tlb_data2_4k_wclk                                 (i_hqm_sip_rf_tlb_data2_4k_wclk),
       .rf_tlb_data2_4k_wclk_rst_n                           (i_hqm_sip_rf_tlb_data2_4k_wclk_rst_n),
       .rf_tlb_data2_4k_we                                   (i_hqm_sip_rf_tlb_data2_4k_we),
       .rf_tlb_data2_4k_waddr                                (i_hqm_sip_rf_tlb_data2_4k_waddr),
       .rf_tlb_data2_4k_wdata                                (i_hqm_sip_rf_tlb_data2_4k_wdata),
       .rf_tlb_data2_4k_rclk                                 (i_hqm_sip_rf_tlb_data2_4k_rclk),
       .rf_tlb_data2_4k_rclk_rst_n                           (i_hqm_sip_rf_tlb_data2_4k_rclk_rst_n),
       .rf_tlb_data2_4k_re                                   (i_hqm_sip_rf_tlb_data2_4k_re),
       .rf_tlb_data2_4k_raddr                                (i_hqm_sip_rf_tlb_data2_4k_raddr),
       .rf_tlb_data2_4k_rdata                                (i_hqm_system_mem_rf_tlb_data2_4k_rdata),
       .rf_tlb_data3_4k_wclk                                 (i_hqm_sip_rf_tlb_data3_4k_wclk),
       .rf_tlb_data3_4k_wclk_rst_n                           (i_hqm_sip_rf_tlb_data3_4k_wclk_rst_n),
       .rf_tlb_data3_4k_we                                   (i_hqm_sip_rf_tlb_data3_4k_we),
       .rf_tlb_data3_4k_waddr                                (i_hqm_sip_rf_tlb_data3_4k_waddr),
       .rf_tlb_data3_4k_wdata                                (i_hqm_sip_rf_tlb_data3_4k_wdata),
       .rf_tlb_data3_4k_rclk                                 (i_hqm_sip_rf_tlb_data3_4k_rclk),
       .rf_tlb_data3_4k_rclk_rst_n                           (i_hqm_sip_rf_tlb_data3_4k_rclk_rst_n),
       .rf_tlb_data3_4k_re                                   (i_hqm_sip_rf_tlb_data3_4k_re),
       .rf_tlb_data3_4k_raddr                                (i_hqm_sip_rf_tlb_data3_4k_raddr),
       .rf_tlb_data3_4k_rdata                                (i_hqm_system_mem_rf_tlb_data3_4k_rdata),
       .rf_tlb_data4_4k_wclk                                 (i_hqm_sip_rf_tlb_data4_4k_wclk),
       .rf_tlb_data4_4k_wclk_rst_n                           (i_hqm_sip_rf_tlb_data4_4k_wclk_rst_n),
       .rf_tlb_data4_4k_we                                   (i_hqm_sip_rf_tlb_data4_4k_we),
       .rf_tlb_data4_4k_waddr                                (i_hqm_sip_rf_tlb_data4_4k_waddr),
       .rf_tlb_data4_4k_wdata                                (i_hqm_sip_rf_tlb_data4_4k_wdata),
       .rf_tlb_data4_4k_rclk                                 (i_hqm_sip_rf_tlb_data4_4k_rclk),
       .rf_tlb_data4_4k_rclk_rst_n                           (i_hqm_sip_rf_tlb_data4_4k_rclk_rst_n),
       .rf_tlb_data4_4k_re                                   (i_hqm_sip_rf_tlb_data4_4k_re),
       .rf_tlb_data4_4k_raddr                                (i_hqm_sip_rf_tlb_data4_4k_raddr),
       .rf_tlb_data4_4k_rdata                                (i_hqm_system_mem_rf_tlb_data4_4k_rdata),
       .rf_tlb_data5_4k_wclk                                 (i_hqm_sip_rf_tlb_data5_4k_wclk),
       .rf_tlb_data5_4k_wclk_rst_n                           (i_hqm_sip_rf_tlb_data5_4k_wclk_rst_n),
       .rf_tlb_data5_4k_we                                   (i_hqm_sip_rf_tlb_data5_4k_we),
       .rf_tlb_data5_4k_waddr                                (i_hqm_sip_rf_tlb_data5_4k_waddr),
       .rf_tlb_data5_4k_wdata                                (i_hqm_sip_rf_tlb_data5_4k_wdata),
       .rf_tlb_data5_4k_rclk                                 (i_hqm_sip_rf_tlb_data5_4k_rclk),
       .rf_tlb_data5_4k_rclk_rst_n                           (i_hqm_sip_rf_tlb_data5_4k_rclk_rst_n),
       .rf_tlb_data5_4k_re                                   (i_hqm_sip_rf_tlb_data5_4k_re),
       .rf_tlb_data5_4k_raddr                                (i_hqm_sip_rf_tlb_data5_4k_raddr),
       .rf_tlb_data5_4k_rdata                                (i_hqm_system_mem_rf_tlb_data5_4k_rdata),
       .rf_tlb_data6_4k_wclk                                 (i_hqm_sip_rf_tlb_data6_4k_wclk),
       .rf_tlb_data6_4k_wclk_rst_n                           (i_hqm_sip_rf_tlb_data6_4k_wclk_rst_n),
       .rf_tlb_data6_4k_we                                   (i_hqm_sip_rf_tlb_data6_4k_we),
       .rf_tlb_data6_4k_waddr                                (i_hqm_sip_rf_tlb_data6_4k_waddr),
       .rf_tlb_data6_4k_wdata                                (i_hqm_sip_rf_tlb_data6_4k_wdata),
       .rf_tlb_data6_4k_rclk                                 (i_hqm_sip_rf_tlb_data6_4k_rclk),
       .rf_tlb_data6_4k_rclk_rst_n                           (i_hqm_sip_rf_tlb_data6_4k_rclk_rst_n),
       .rf_tlb_data6_4k_re                                   (i_hqm_sip_rf_tlb_data6_4k_re),
       .rf_tlb_data6_4k_raddr                                (i_hqm_sip_rf_tlb_data6_4k_raddr),
       .rf_tlb_data6_4k_rdata                                (i_hqm_system_mem_rf_tlb_data6_4k_rdata),
       .rf_tlb_data7_4k_wclk                                 (i_hqm_sip_rf_tlb_data7_4k_wclk),
       .rf_tlb_data7_4k_wclk_rst_n                           (i_hqm_sip_rf_tlb_data7_4k_wclk_rst_n),
       .rf_tlb_data7_4k_we                                   (i_hqm_sip_rf_tlb_data7_4k_we),
       .rf_tlb_data7_4k_waddr                                (i_hqm_sip_rf_tlb_data7_4k_waddr),
       .rf_tlb_data7_4k_wdata                                (i_hqm_sip_rf_tlb_data7_4k_wdata),
       .rf_tlb_data7_4k_rclk                                 (i_hqm_sip_rf_tlb_data7_4k_rclk),
       .rf_tlb_data7_4k_rclk_rst_n                           (i_hqm_sip_rf_tlb_data7_4k_rclk_rst_n),
       .rf_tlb_data7_4k_re                                   (i_hqm_sip_rf_tlb_data7_4k_re),
       .rf_tlb_data7_4k_raddr                                (i_hqm_sip_rf_tlb_data7_4k_raddr),
       .rf_tlb_data7_4k_rdata                                (i_hqm_system_mem_rf_tlb_data7_4k_rdata),
       .rf_tlb_tag0_4k_wclk                                  (i_hqm_sip_rf_tlb_tag0_4k_wclk),
       .rf_tlb_tag0_4k_wclk_rst_n                            (i_hqm_sip_rf_tlb_tag0_4k_wclk_rst_n),
       .rf_tlb_tag0_4k_we                                    (i_hqm_sip_rf_tlb_tag0_4k_we),
       .rf_tlb_tag0_4k_waddr                                 (i_hqm_sip_rf_tlb_tag0_4k_waddr),
       .rf_tlb_tag0_4k_wdata                                 (i_hqm_sip_rf_tlb_tag0_4k_wdata),
       .rf_tlb_tag0_4k_rclk                                  (i_hqm_sip_rf_tlb_tag0_4k_rclk),
       .rf_tlb_tag0_4k_rclk_rst_n                            (i_hqm_sip_rf_tlb_tag0_4k_rclk_rst_n),
       .rf_tlb_tag0_4k_re                                    (i_hqm_sip_rf_tlb_tag0_4k_re),
       .rf_tlb_tag0_4k_raddr                                 (i_hqm_sip_rf_tlb_tag0_4k_raddr),
       .rf_tlb_tag0_4k_rdata                                 (i_hqm_system_mem_rf_tlb_tag0_4k_rdata),
       .rf_tlb_tag1_4k_wclk                                  (i_hqm_sip_rf_tlb_tag1_4k_wclk),
       .rf_tlb_tag1_4k_wclk_rst_n                            (i_hqm_sip_rf_tlb_tag1_4k_wclk_rst_n),
       .rf_tlb_tag1_4k_we                                    (i_hqm_sip_rf_tlb_tag1_4k_we),
       .rf_tlb_tag1_4k_waddr                                 (i_hqm_sip_rf_tlb_tag1_4k_waddr),
       .rf_tlb_tag1_4k_wdata                                 (i_hqm_sip_rf_tlb_tag1_4k_wdata),
       .rf_tlb_tag1_4k_rclk                                  (i_hqm_sip_rf_tlb_tag1_4k_rclk),
       .rf_tlb_tag1_4k_rclk_rst_n                            (i_hqm_sip_rf_tlb_tag1_4k_rclk_rst_n),
       .rf_tlb_tag1_4k_re                                    (i_hqm_sip_rf_tlb_tag1_4k_re),
       .rf_tlb_tag1_4k_raddr                                 (i_hqm_sip_rf_tlb_tag1_4k_raddr),
       .rf_tlb_tag1_4k_rdata                                 (i_hqm_system_mem_rf_tlb_tag1_4k_rdata),
       .rf_tlb_tag2_4k_wclk                                  (i_hqm_sip_rf_tlb_tag2_4k_wclk),
       .rf_tlb_tag2_4k_wclk_rst_n                            (i_hqm_sip_rf_tlb_tag2_4k_wclk_rst_n),
       .rf_tlb_tag2_4k_we                                    (i_hqm_sip_rf_tlb_tag2_4k_we),
       .rf_tlb_tag2_4k_waddr                                 (i_hqm_sip_rf_tlb_tag2_4k_waddr),
       .rf_tlb_tag2_4k_wdata                                 (i_hqm_sip_rf_tlb_tag2_4k_wdata),
       .rf_tlb_tag2_4k_rclk                                  (i_hqm_sip_rf_tlb_tag2_4k_rclk),
       .rf_tlb_tag2_4k_rclk_rst_n                            (i_hqm_sip_rf_tlb_tag2_4k_rclk_rst_n),
       .rf_tlb_tag2_4k_re                                    (i_hqm_sip_rf_tlb_tag2_4k_re),
       .rf_tlb_tag2_4k_raddr                                 (i_hqm_sip_rf_tlb_tag2_4k_raddr),
       .rf_tlb_tag2_4k_rdata                                 (i_hqm_system_mem_rf_tlb_tag2_4k_rdata),
       .rf_tlb_tag3_4k_wclk                                  (i_hqm_sip_rf_tlb_tag3_4k_wclk),
       .rf_tlb_tag3_4k_wclk_rst_n                            (i_hqm_sip_rf_tlb_tag3_4k_wclk_rst_n),
       .rf_tlb_tag3_4k_we                                    (i_hqm_sip_rf_tlb_tag3_4k_we),
       .rf_tlb_tag3_4k_waddr                                 (i_hqm_sip_rf_tlb_tag3_4k_waddr),
       .rf_tlb_tag3_4k_wdata                                 (i_hqm_sip_rf_tlb_tag3_4k_wdata),
       .rf_tlb_tag3_4k_rclk                                  (i_hqm_sip_rf_tlb_tag3_4k_rclk),
       .rf_tlb_tag3_4k_rclk_rst_n                            (i_hqm_sip_rf_tlb_tag3_4k_rclk_rst_n),
       .rf_tlb_tag3_4k_re                                    (i_hqm_sip_rf_tlb_tag3_4k_re),
       .rf_tlb_tag3_4k_raddr                                 (i_hqm_sip_rf_tlb_tag3_4k_raddr),
       .rf_tlb_tag3_4k_rdata                                 (i_hqm_system_mem_rf_tlb_tag3_4k_rdata),
       .rf_tlb_tag4_4k_wclk                                  (i_hqm_sip_rf_tlb_tag4_4k_wclk),
       .rf_tlb_tag4_4k_wclk_rst_n                            (i_hqm_sip_rf_tlb_tag4_4k_wclk_rst_n),
       .rf_tlb_tag4_4k_we                                    (i_hqm_sip_rf_tlb_tag4_4k_we),
       .rf_tlb_tag4_4k_waddr                                 (i_hqm_sip_rf_tlb_tag4_4k_waddr),
       .rf_tlb_tag4_4k_wdata                                 (i_hqm_sip_rf_tlb_tag4_4k_wdata),
       .rf_tlb_tag4_4k_rclk                                  (i_hqm_sip_rf_tlb_tag4_4k_rclk),
       .rf_tlb_tag4_4k_rclk_rst_n                            (i_hqm_sip_rf_tlb_tag4_4k_rclk_rst_n),
       .rf_tlb_tag4_4k_re                                    (i_hqm_sip_rf_tlb_tag4_4k_re),
       .rf_tlb_tag4_4k_raddr                                 (i_hqm_sip_rf_tlb_tag4_4k_raddr),
       .rf_tlb_tag4_4k_rdata                                 (i_hqm_system_mem_rf_tlb_tag4_4k_rdata),
       .rf_tlb_tag5_4k_wclk                                  (i_hqm_sip_rf_tlb_tag5_4k_wclk),
       .rf_tlb_tag5_4k_wclk_rst_n                            (i_hqm_sip_rf_tlb_tag5_4k_wclk_rst_n),
       .rf_tlb_tag5_4k_we                                    (i_hqm_sip_rf_tlb_tag5_4k_we),
       .rf_tlb_tag5_4k_waddr                                 (i_hqm_sip_rf_tlb_tag5_4k_waddr),
       .rf_tlb_tag5_4k_wdata                                 (i_hqm_sip_rf_tlb_tag5_4k_wdata),
       .rf_tlb_tag5_4k_rclk                                  (i_hqm_sip_rf_tlb_tag5_4k_rclk),
       .rf_tlb_tag5_4k_rclk_rst_n                            (i_hqm_sip_rf_tlb_tag5_4k_rclk_rst_n),
       .rf_tlb_tag5_4k_re                                    (i_hqm_sip_rf_tlb_tag5_4k_re),
       .rf_tlb_tag5_4k_raddr                                 (i_hqm_sip_rf_tlb_tag5_4k_raddr),
       .rf_tlb_tag5_4k_rdata                                 (i_hqm_system_mem_rf_tlb_tag5_4k_rdata),
       .rf_tlb_tag6_4k_wclk                                  (i_hqm_sip_rf_tlb_tag6_4k_wclk),
       .rf_tlb_tag6_4k_wclk_rst_n                            (i_hqm_sip_rf_tlb_tag6_4k_wclk_rst_n),
       .rf_tlb_tag6_4k_we                                    (i_hqm_sip_rf_tlb_tag6_4k_we),
       .rf_tlb_tag6_4k_waddr                                 (i_hqm_sip_rf_tlb_tag6_4k_waddr),
       .rf_tlb_tag6_4k_wdata                                 (i_hqm_sip_rf_tlb_tag6_4k_wdata),
       .rf_tlb_tag6_4k_rclk                                  (i_hqm_sip_rf_tlb_tag6_4k_rclk),
       .rf_tlb_tag6_4k_rclk_rst_n                            (i_hqm_sip_rf_tlb_tag6_4k_rclk_rst_n),
       .rf_tlb_tag6_4k_re                                    (i_hqm_sip_rf_tlb_tag6_4k_re),
       .rf_tlb_tag6_4k_raddr                                 (i_hqm_sip_rf_tlb_tag6_4k_raddr),
       .rf_tlb_tag6_4k_rdata                                 (i_hqm_system_mem_rf_tlb_tag6_4k_rdata),
       .rf_tlb_tag7_4k_wclk                                  (i_hqm_sip_rf_tlb_tag7_4k_wclk),
       .rf_tlb_tag7_4k_wclk_rst_n                            (i_hqm_sip_rf_tlb_tag7_4k_wclk_rst_n),
       .rf_tlb_tag7_4k_we                                    (i_hqm_sip_rf_tlb_tag7_4k_we),
       .rf_tlb_tag7_4k_waddr                                 (i_hqm_sip_rf_tlb_tag7_4k_waddr),
       .rf_tlb_tag7_4k_wdata                                 (i_hqm_sip_rf_tlb_tag7_4k_wdata),
       .rf_tlb_tag7_4k_rclk                                  (i_hqm_sip_rf_tlb_tag7_4k_rclk),
       .rf_tlb_tag7_4k_rclk_rst_n                            (i_hqm_sip_rf_tlb_tag7_4k_rclk_rst_n),
       .rf_tlb_tag7_4k_re                                    (i_hqm_sip_rf_tlb_tag7_4k_re),
       .rf_tlb_tag7_4k_raddr                                 (i_hqm_sip_rf_tlb_tag7_4k_raddr),
       .rf_tlb_tag7_4k_rdata                                 (i_hqm_system_mem_rf_tlb_tag7_4k_rdata),
       .rf_hcw_enq_fifo_wclk                                 (i_hqm_sip_rf_hcw_enq_fifo_wclk),
       .rf_hcw_enq_fifo_wclk_rst_n                           (i_hqm_sip_rf_hcw_enq_fifo_wclk_rst_n),
       .rf_hcw_enq_fifo_we                                   (i_hqm_sip_rf_hcw_enq_fifo_we),
       .rf_hcw_enq_fifo_waddr                                (i_hqm_sip_rf_hcw_enq_fifo_waddr),
       .rf_hcw_enq_fifo_wdata                                (i_hqm_sip_rf_hcw_enq_fifo_wdata),
       .rf_hcw_enq_fifo_rclk                                 (i_hqm_sip_rf_hcw_enq_fifo_rclk),
       .rf_hcw_enq_fifo_rclk_rst_n                           (i_hqm_sip_rf_hcw_enq_fifo_rclk_rst_n),
       .rf_hcw_enq_fifo_re                                   (i_hqm_sip_rf_hcw_enq_fifo_re),
       .rf_hcw_enq_fifo_raddr                                (i_hqm_sip_rf_hcw_enq_fifo_raddr),
       .rf_hcw_enq_fifo_rdata                                (i_hqm_system_mem_rf_hcw_enq_fifo_rdata),
       .rf_hcw_enq_fifo_isol_en                              (i_hqm_sip_pgcb_isol_en),
       .rf_hcw_enq_fifo_pwr_enable_b_in                      (i_hqm_system_mem_rf_dir_wb2_pwr_enable_b_out),
       .rf_hcw_enq_fifo_pwr_enable_b_out                     (i_hqm_system_mem_rf_hcw_enq_fifo_pwr_enable_b_out),
       .hqm_pwrgood_rst_b                                    (i_hqm_sip_hqm_pwrgood_rst_b),
       .powergood_rst_b,
       .fscan_byprst_b,
       .fscan_clkungate,
       .fscan_rstbypen);

`endif // INTEL_HIDE_INTEGRATION



endmodule
