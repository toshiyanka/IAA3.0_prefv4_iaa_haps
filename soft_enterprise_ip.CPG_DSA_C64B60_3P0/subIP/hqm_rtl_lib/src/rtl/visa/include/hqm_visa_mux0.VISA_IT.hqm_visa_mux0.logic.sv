`ifndef __VISA_IT__
`ifndef INTEL_GLOBAL_VISA_DISABLE

(* inserted_by="VISA IT",
   sig_file="/nfs/site/disks/sdg74_3369/users/stepollo/hqm-srvr10nm-wave4-visa2/tools/visa/hqm_visa_mux0.sig",
   visa_it_version="4.3.19",
   probe_ranges_for_src_clk_0="[7:0] /* /hqm/par_hqm_system/hqm_system_aon_wrap/i_hqm_visa/i_hqm_visa_mux0/prim_freerun_clk */" *)
hqm_visa_repeater_s #(
    .HAS_CENTERING(0),
    .BLACKBOX_MASK(32'b0),
    .GRIDDED_CLOCK(1),
    .USE_NEGEDGE(0),
    .NUM_FEEDER_OUTPUT_LANES(1),
    .NUM_FEEDER_XBAR_LANES(0),
    .NUM_FEEDER_NON_XBAR_ROUTED_LANES(0),
    .HAS_CONFIG_BUS_REPEATER(0),
    .USE_MIN_PROTECTION_LATCH(0)
) i_hqm_visa_repeater_vcfn (
    .lane_in(visaRt_lane_out_from_i_hqm_visa_mux_top_vcfn),
    .ss_clk_out(),
    .serial_cfg_in(visaRt_serial_cfg_in_local),
    .bypass_cr_in(visaRt_bypass_cr_out_from_i_hqm_visa_mux_top_vcfn),
    .serial_cfg_out(visaRt_serial_cfg_in_from_i_hqm_visa_repeater_vcfn),
    .reg_start_index(5'b0),
    .src_clk(visaSrcClk_i_hqm_visa_repeater_vcfn),
    .bypass_cr_out(),
    .fscan_mode(fscan_mode),
    .visa_resetb(powergood_rst_b),
    .lane_out(avisa_dbgbus0_vcfn),
    .visa_unit_id(9'b0)
);

(* inserted_by="VISA IT",
   sig_file="/nfs/site/disks/sdg74_3369/users/stepollo/hqm-srvr10nm-wave4-visa2/tools/visa/hqm_visa_mux0.sig",
   visa_it_version="4.3.19",
   probe_ranges_for_src_clk_0="[57:0][375:64] /* /hqm/par_hqm_system/hqm_system_aon_wrap/i_hqm_visa/i_hqm_visa_mux0/prim_freerun_clk */" *)
hqm_visa_unit_mux_cro_s #(
    .SCAN_CLK_INDEX(0),
    .BLACKBOX_MASK(32'b0),
    .NUM_OUTPUT_LANES(1),
    .BUGCOMPAT_MIN_PROTECTION_LATCH(0),
    .NUM_INPUT_CLKS(1),
    .CUST_VIS_TOP_LANE(0),
    .NUM_INPUT_LANES(47),
    .OEM_VIS_TOP_LANE(0),
    .PATGEN_TYPE(1),
    .USE_CLKMUX(0),
    .USE_MIN_PROTECTION_LATCH(0),
    .HAS_DATA_PATH_RESET(1),
    .DESERIALIZER_MASK({32'b10000000100111111, 32'b1110001}),
    .ENABLE_ON_LANE_SELECT(0),
    .PATGEN_SERIAL_CLK(0),
    .NUM_XBAR_LANES(0)
) i_hqm_visa_mux_top_vcfn (
    .lane_in(visaLaneIn_i_hqm_visa_mux_top_vcfn),
    .ss_clk_out(),
    .xbar_out(),
    .serial_cfg_in(visaRt_serial_cfg_in_from_i_hqm_visa_repeater_vcfn),
    .serial_cfg_out(),
    .reg_start_index(5'd0),
    .bypass_cr_out(visaRt_bypass_cr_out_from_i_hqm_visa_mux_top_vcfn),
    .src_clk(visaSrcClk_i_hqm_visa_mux_top_vcfn),
    .customer_disable(visa_customer_dis),
    .fscan_mode(fscan_mode),
    .xbar_ss_clk_out(),
    .visa_enabled(),
    .all_disable(visa_all_dis),
    .visa_resetb(powergood_rst_b),
    .lane_out(visaRt_lane_out_from_i_hqm_visa_mux_top_vcfn),
    .visa_unit_id(fvisa_startid0_vcfn)
);

(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[  0:  0]           = hqm_sif_visa_struct.trn_phdr_deq_wl                                                                ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[  1:  1]           = hqm_sif_visa_struct.trn_cmplh_deq_wl                                                               ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[  2:  2]           = hqm_sif_visa_struct.trn_pderr_rxl                                                                  ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[  3:  3]           = hqm_sif_visa_struct.trn_pdata_valid_rl                                                             ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[  4:  4]           = hqm_sif_visa_struct.trn_ph_valid_rl                                                                ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[  5:  5]           = hqm_sif_visa_struct.trn_ioq_valid_rl                                                               ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[  6:  6]           = hqm_sif_visa_struct.trn_ioq_p_rl                                                                   ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[  7:  7]           = hqm_sif_visa_struct.trn_ioq_cmpl_rl                                                                ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[ 12:  8]           = hqm_sif_visa_struct.trn_nxtstate_wxl[4:0]                                                          ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[ 14: 13]           = hqm_sif_visa_struct.trn_trans_type_rxl[1:0]                                                        ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[ 15: 15]           = hqm_sif_visa_struct.trn_p_tlp_avail_wl                                                             ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[ 16: 16]           = hqm_sif_visa_struct.trn_ti_obcmpl_ack_rl2                                                          ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[ 17: 17]           = hqm_sif_visa_struct.trn_ri_obcmpl_req_rl2                                                          ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[ 18: 18]           = hqm_sif_visa_struct.trn_cmpl_req_rl                                                                ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[ 19: 19]           = hqm_sif_visa_struct.trn_p_req_wl                                                                   ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[ 20: 20]           = hqm_sif_visa_struct.trn_msi_write                                                                  ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[ 21: 21]           = hqm_sif_visa_struct.trn_msix_write                                                                 ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[ 22: 22]           = hqm_sif_visa_struct.trn_ims_write                                                                  ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[ 26: 23]           = hqm_sif_visa_struct.trn_msi_vf[3:0]                                                                ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[ 27: 27]           = hqm_sif_visa_struct.phdr_rxl_pasidtlp_22                                                           ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[ 28: 28]           = hqm_sif_visa_struct.ph_trigger                                                                     ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[ 29: 29]           = hqm_sif_visa_struct.ti_idle_q                                                                      ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[ 30: 30]           = hqm_sif_visa_struct.ti_iosfp_push_wl                                                               ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[ 31: 31]           = hqm_sif_visa_struct.ti_rsprepack_vote_rp                                                           ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[ 32: 32]           = hqm_sif_visa_struct.ri_iosfp_quiesce_rp                                                            ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[ 33: 33]           = hqm_sif_visa_struct.reqsrv_send_msg                                                                ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[ 34: 34]           = hqm_sif_visa_struct.csr_pasid_enable                                                               ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[ 35: 35]           = hqm_sif_visa_struct.ri_idle_q                                                                      ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[ 36: 36]           = hqm_sif_visa_struct.cds_cfg_wr_sai_ok                                                              ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[ 37: 37]           = hqm_sif_visa_struct.cds_cfg_wr_sai_error                                                           ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[ 38: 38]           = hqm_sif_visa_struct.cds_cfg_wr_ur                                                                  ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[ 39: 39]           = hqm_sif_visa_struct.cds_mmio_wr_sai_ok                                                             ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[ 40: 40]           = hqm_sif_visa_struct.cds_mmio_wr_sai_error                                                          ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[ 41: 41]           = hqm_sif_visa_struct.cds_csr_rd_timeout_error                                                       ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[ 42: 42]           = hqm_sif_visa_struct.cds_csr_rd_sai_error                                                           ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[ 43: 43]           = hqm_sif_visa_struct.cds_csr_rd_ur                                                                  ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[ 44: 44]           = hqm_sif_visa_struct.cds_cbd_decode_val_0                                                           ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[ 45: 45]           = hqm_sif_visa_struct.cds_bar_decode_err_wp                                                          ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[ 46: 46]           = hqm_sif_visa_struct.cds_cbd_csr_pf_bar_hit                                                         ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[ 47: 47]           = hqm_sif_visa_struct.cds_cbd_func_vf_rgn_hit_0                                                      ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[ 48: 48]           = hqm_sif_visa_struct.cds_cbd_csr_pf_rgn_hit_0                                                       ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[ 49: 49]           = hqm_sif_visa_struct.cds_cbd_func_pf_rgn_hit_0                                                      ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[ 50: 50]           = hqm_sif_visa_struct.cds_cbd_func_vf_bar_hit_0                                                      ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[ 51: 51]           = hqm_sif_visa_struct.cds_cbd_func_pf_bar_hit_0                                                      ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[ 52: 52]           = hqm_sif_visa_struct.cds_addr_val                                                                   ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[ 53: 53]           = hqm_sif_visa_struct.cds_cbd_csr_pf_rgn_hit_1                                                       ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[ 57: 54]           = hqm_sif_visa_struct.csr_req_q_csr_func_vf_num[3:0]                                                 ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[ 58: 58]           = hqm_sif_visa_struct.csr_req_q_csr_func_vf_mem_mapped                                               ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[ 59: 59]           = hqm_sif_visa_struct.csr_req_q_csr_func_pf_mem_mapped                                               ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[ 60: 60]           = hqm_sif_visa_struct.csr_req_q_csr_ext_mem_mapped                                                   ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[ 61: 61]           = hqm_sif_visa_struct.csr_req_q_csr_mem_mapped                                                       ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[ 62: 62]           = hqm_sif_visa_struct.csr_pf0_req_data_0                                                             ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[ 63: 63]           = hqm_sif_visa_struct.csr_pf0_req_opcode_0                                                           ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[ 64: 64]           = hqm_sif_visa_struct.csr_pf0_req_valid                                                              ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[ 65: 65]           = hqm_sif_visa_struct.csr_pf0_ack_write_valid                                                        ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[ 66: 66]           = hqm_sif_visa_struct.csr_pf0_ack_read_valid                                                         ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[ 67: 67]           = hqm_sif_visa_struct.csr_pf0_ack_write_miss                                                         ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[ 68: 68]           = hqm_sif_visa_struct.csr_pf0_ack_read_miss                                                          ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[ 69: 69]           = hqm_sif_visa_struct.csr_pf0_ack_sai_successfull                                                    ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[ 70: 70]           = hqm_sif_visa_struct.csr_int_mmio_req_data_0                                                        ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[ 71: 71]           = hqm_sif_visa_struct.csr_int_mmio_req_opcode_0                                                      ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[ 72: 72]           = hqm_sif_visa_struct.csr_int_mmio_req_valid                                                         ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[ 73: 73]           = hqm_sif_visa_struct.csr_int_mmio_ack_write_valid                                                   ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[ 74: 74]           = hqm_sif_visa_struct.csr_int_mmio_ack_read_valid                                                    ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[ 75: 75]           = hqm_sif_visa_struct.csr_int_mmio_ack_write_miss                                                    ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[ 76: 76]           = hqm_sif_visa_struct.csr_int_mmio_ack_read_miss                                                     ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[ 77: 77]           = hqm_sif_visa_struct.csr_int_mmio_ack_sai_successfull                                               ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[ 78: 78]           = hqm_sif_visa_struct.csr_ext_mmio_req_data_0                                                        ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[ 79: 79]           = hqm_sif_visa_struct.csr_ext_mmio_req_opcode_0                                                      ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[ 80: 80]           = hqm_sif_visa_struct.csr_ext_mmio_req_valid                                                         ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[ 81: 81]           = hqm_sif_visa_struct.csr_ext_mmio_ack_write_valid                                                   ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[ 82: 82]           = hqm_sif_visa_struct.csr_ext_mmio_ack_read_valid                                                    ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[ 83: 83]           = hqm_sif_visa_struct.csr_ext_mmio_ack_write_miss                                                    ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[ 84: 84]           = hqm_sif_visa_struct.csr_ext_mmio_ack_read_miss                                                     ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[ 85: 85]           = hqm_sif_visa_struct.csr_ext_mmio_ack_sai_successfull                                               ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[ 88: 86]           = hqm_sif_visa_struct.obc_ri_obcmpl_hdr_rxl_cs[2:0]                                                  ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[ 91: 89]           = hqm_sif_visa_struct.obc_ri_obcmpl_hdr_rxl_tc[2:0]                                                  ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[ 92: 92]           = hqm_sif_visa_struct.obc_ri_obcmpl_hdr_rxl_ep                                                       ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[ 93: 93]           = hqm_sif_visa_struct.obc_ri_obcmpl_req_rl                                                           ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[ 95: 94]           = hqm_sif_visa_struct.tlq_ioq_data_rxp[1:0]                                                          ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[ 96: 96]           = hqm_sif_visa_struct.tlq_ioqval_wp                                                                  ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[ 97: 97]           = hqm_sif_visa_struct.tlq_ioq_pop                                                                    ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[ 98: 98]           = hqm_sif_visa_struct.tlq_ioq_hdr_push_in                                                            ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[ 99: 99]           = hqm_sif_visa_struct.tlq_ioq_fifo_full                                                              ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[100:100]           = hqm_sif_visa_struct.tlq_npdataval_wp                                                               ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[101:101]           = hqm_sif_visa_struct.tlq_tlq_pdataval_wp                                                            ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[108:102]           = hqm_sif_visa_struct.rxq_pcie_cmd[6:0]                                                              ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[109:109]           = hqm_sif_visa_struct.rxq_ti_iosfp_push_wi                                                           ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[110:110]           = hqm_sif_visa_struct.cpldata_rxq_fifo_push                                                          ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[111:111]           = hqm_sif_visa_struct.cplhdr_rxq_fifo_push                                                           ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[112:112]           = hqm_sif_visa_struct.pdata_rxq_fifo_push                                                            ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[113:113]           = hqm_sif_visa_struct.phdr_rxq_fifo_push                                                             ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[114:114]           = hqm_sif_visa_struct.ioq_rxq_fifo_push                                                              ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[115:115]           = hqm_sif_visa_struct.phdr_rxq_fifo_perr_q                                                           ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[116:116]           = hqm_sif_visa_struct.rxq_ti_iosfp_ifc_wxi_endp                                                      ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[117:117]           = hqm_sif_visa_struct.rxq_ti_iosfp_ifc_wxi_stp                                                       ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[118:118]           = hqm_sif_visa_struct.cpldata_rxq_fifo_pop                                                           ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[119:119]           = hqm_sif_visa_struct.cplhdr_rxq_fifo_pop                                                            ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[120:120]           = hqm_sif_visa_struct.pdata_rxq_fifo_pop                                                             ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[121:121]           = hqm_sif_visa_struct.phdr_rxq_fifo_pop                                                              ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[122:122]           = hqm_sif_visa_struct.ioq_rxq_fifo_pop                                                               ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[123:123]           = hqm_sif_visa_struct.cplhdr_rxq_fifo_perr_q                                                         ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[124:124]           = hqm_sif_visa_struct.rxq_ri_iosfp_quiesce_rp                                                        ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[125:125]           = hqm_sif_visa_struct.rxq_ti_rsprepack_vote_rp_q                                                     ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[130:126]           = hqm_sif_visa_struct.mstr_iosf_ep_poison_wr_func_rxl[4:0]                                           ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[131:131]           = hqm_sif_visa_struct.mstr_iosf_ep_poison_wr_sent_rl                                                 ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[132:132]           = hqm_sif_visa_struct.mstr_iosfp_ri_rxq_rsprepack_vote_ri                                            ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[133:133]           = hqm_sif_visa_struct.mstr_iosfp_ti_rxq_rdy                                                          ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[134:134]           = hqm_sif_visa_struct.mstr_iosf_req_put                                                              ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[136:135]           = hqm_sif_visa_struct.mstr_iosf_req_rtype[1:0]                                                       ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[137:137]           = hqm_sif_visa_struct.mstr_iosf_gnt_q_gnt                                                            ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[139:138]           = hqm_sif_visa_struct.mstr_iosf_gnt_q_rtype[1:0]                                                     ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[141:140]           = hqm_sif_visa_struct.mstr_iosf_gnt_q_gtype[1:0]                                                     ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[143:142]           = hqm_sif_visa_struct.mstr_hfifo_rd[1:0]                                                             ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[145:144]           = hqm_sif_visa_struct.mstr_dfifo_rd[1:0]                                                             ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[146:146]           = hqm_sif_visa_struct.mstr_dfifo_rd_gt4dw                                                            ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[149:147]           = hqm_sif_visa_struct.mstr_prim_ism_agent[2:0]                                                       ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[151:150]           = hqm_sif_visa_struct.mstr_req_fifo_fully[1:0]                                                       ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[153:152]           = hqm_sif_visa_struct.mstr_req_fifo_empty[1:0]                                                       ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[155:154]           = hqm_sif_visa_struct.mstr_iosf_gnt_q_dec[1:0]                                                       ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[157:156]           = hqm_sif_visa_struct.mstr_rxq_hdr_avail[1:0]                                                        ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[162:158]           = hqm_sif_visa_struct.mstr_hfifo_data_type[4:0]                                                      ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[164:163]           = hqm_sif_visa_struct.mstr_hfifo_data_fmt[1:0]                                                       ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[165:165]           = hqm_sif_visa_struct.mstr_idle                                                                      ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[170:166]           = hqm_sif_visa_struct.mstr_iosf_req_credits_p[4:0]                                                   ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[171:171]           = hqm_sif_visa_struct.mstr_data_out_valid_q                                                          ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[173:172]           = hqm_sif_visa_struct.mstr_iosf_req_dlen_1_0[1:0]                                                    ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[178:174]           = hqm_sif_visa_struct.mstr_iosf_req_credits_cpl[4:0]                                                 ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[181:179]           = hqm_sif_visa_struct.mstr_iosf_req_dlen_4_2[2:0]                                                    ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[186:182]           = hqm_sif_visa_struct.mstr_iosf_cmd_ctype[4:0]                                                       ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[188:187]           = hqm_sif_visa_struct.mstr_iosf_cmd_cfmt[1:0]                                                        ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[189:189]           = hqm_sif_visa_struct.mstr_iosf_gnt_q_gnt2                                                           ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[190:190]           = hqm_sif_visa_struct.mstr_iosf_cmd_ctd                                                              ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[192:191]           = hqm_sif_visa_struct.mstr_iosf_cmd_cat[1:0]                                                         ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[193:193]           = hqm_sif_visa_struct.mstr_iosf_cmd_cido                                                             ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[194:194]           = hqm_sif_visa_struct.mstr_iosf_cmd_cns                                                              ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[195:195]           = hqm_sif_visa_struct.mstr_iosf_cmd_cro                                                              ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[196:196]           = hqm_sif_visa_struct.mstr_iosf_cmd_cep                                                              ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[197:197]           = hqm_sif_visa_struct.mstr_iosf_cmd_cth                                                              ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[205:198]           = hqm_sif_visa_struct.mstr_iosf_cmd_clength_7_0[7:0]                                                 ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[221:206]           = hqm_sif_visa_struct.mstr_iosf_cmd_crqid[15:0]                                                      ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[229:222]           = hqm_sif_visa_struct.mstr_iosf_cmd_ctag[7:0]                                                        ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[233:230]           = hqm_sif_visa_struct.mstr_iosf_cmd_cfbe[3:0]                                                        ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[237:234]           = hqm_sif_visa_struct.mstr_iosf_cmd_clbe[3:0]                                                        ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[269:238]           = hqm_sif_visa_struct.mstr_iosf_cmd_caddress_31_0[31:0]                                              ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[273:270]           = hqm_sif_visa_struct.iosf_tgt_port_present[3:0]                                                     ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[274:274]           = hqm_sif_visa_struct.iosf_tgt_zero                                                                  ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[275:275]           = hqm_sif_visa_struct.iosf_tgt_credit_init                                                           ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[276:276]           = hqm_sif_visa_struct.iosf_tgt_rst_complete                                                          ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[277:277]           = hqm_sif_visa_struct.iosf_tgt_crdtinit_in_progress                                                  ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[287:278]           = hqm_sif_visa_struct.iosf_tgt_data_count_ff[9:0]                                                    ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[288:288]           = hqm_sif_visa_struct.iosf_tgt_has_data                                                              ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[290:289]           = hqm_sif_visa_struct.iosf_tgt_cmd_tfmt[1:0]                                                         ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[291:291]           = hqm_sif_visa_struct.iosf_tgt_cput_cmd_put                                                          ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[293:292]           = hqm_sif_visa_struct.iosf_tgt_cput_cmd_rtype[1:0]                                                   ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[294:294]           = hqm_sif_visa_struct.iosf_tgt_idle                                                                  ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[298:295]           = hqm_sif_visa_struct.iosf_tgt_dec_type[3:0]                                                         ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[301:299]           = hqm_sif_visa_struct.iosf_tgt_dec_bits[2:0]                                                         ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[302:302]           = hqm_sif_visa_struct.sys_cfgm_idle                                                                  ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[303:303]           = hqm_sif_visa_struct.sys_ti_idle                                                                    ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[304:304]           = hqm_sif_visa_struct.sys_ri_idle                                                                    ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[305:305]           = hqm_sif_visa_struct.sys_tgt_idle                                                                   ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[306:306]           = hqm_sif_visa_struct.sys_mstr_idle                                                                  ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[307:307]           = hqm_sif_visa_struct.hqm_idle_q                                                                     ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[308:308]           = hqm_sif_visa_struct.prim_clkack_sync                                                               ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[309:309]           = hqm_sif_visa_struct.prim_clkreq_sync                                                               ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[310:310]           = hqm_sif_visa_struct.prim_clk_enable_sys                                                            ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[311:311]           = hqm_sif_visa_struct.prim_clk_enable                                                                ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[312:312]           = hqm_sif_visa_struct.prim_gated_rst_b_sync                                                          ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[313:313]           = hqm_sif_visa_struct.sw_trigger                                                                     ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[315:314]           = hqm_sif_visa_struct.ps[1:0]                                                                        ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[316:316]           = hqm_sif_visa_struct.pf0_fsm_rst                                                                    ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[317:317]           = hqm_sif_visa_struct.flr                                                                            ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[318:318]           = hqm_sif_visa_struct.flr_cmp_sent_q                                                                 ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[319:319]           = hqm_sif_visa_struct.flr_txn_sent_q                                                                 ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[320:320]           = hqm_sif_visa_struct.ps_cmp_sent_ack                                                                ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[321:321]           = hqm_sif_visa_struct.ps_cmp_sent_q                                                                  ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[322:322]           = hqm_sif_visa_struct.ps_txn_sent_q                                                                  ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[323:323]           = hqm_sif_visa_struct.bme_or_mem_wr                                                                  ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[324:324]           = hqm_sif_visa_struct.flr_pending                                                                    ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[325:325]           = hqm_sif_visa_struct.flr_treatment                                                                  ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[326:326]           = hqm_sif_visa_struct.flr_function0                                                                  ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[327:327]           = hqm_sif_visa_struct.ps_d0_to_d3                                                                    ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[328:328]           = hqm_sif_visa_struct.flr_triggered                                                                  ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[329:329]           = hqm_sif_visa_struct.prim_clk_enable_cdc                                                            ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[330:330]           = hqm_sif_visa_struct.flr_clk_enable_system                                                          ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[331:331]           = hqm_sif_visa_struct.flr_clk_enable                                                                 ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[332:332]           = hqm_sif_visa_struct.flr_triggered_wl                                                               ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[333:333]           = hqm_sif_visa_struct.flr_cmp_sent                                                                   ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[334:334]           = hqm_pmsm_visa_probe.spare                                                                          ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[335:335]           = hqm_pmsm_visa_probe.cfg_pm_status_pgcb_fet_en_b                                                    ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[336:336]           = hqm_pmsm_visa_probe.cfg_pm_status_pmc_pgcb_fet_en_b                                                ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[337:337]           = hqm_pmsm_visa_probe.cfg_pm_status_pmc_pgcb_pg_ack_b                                                ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[338:338]           = hqm_pmsm_visa_probe.cfg_pm_status_pgcb_pmc_pg_req_b                                                ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[339:339]           = hqm_pmsm_visa_probe.cfg_pm_status_PMSM_PGCB_REQ_B                                                  ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[340:340]           = hqm_pmsm_visa_probe.cfg_pm_status_PGCB_HQM_PG_RDY_ACK_B                                            ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[341:341]           = hqm_pmsm_visa_probe.cfg_pm_status_PGCB_HQM_IDLE                                                    ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[344:342]           = hqm_pmsm_visa_probe.prdata_2_0[2:0]                                                                ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[345:345]           = hqm_pmsm_visa_probe.pready                                                                         ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[349:346]           = hqm_pmsm_visa_probe.paddr_31_28[3:0]                                                               ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[350:350]           = hqm_pmsm_visa_probe.pwrite                                                                         ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[351:351]           = hqm_pmsm_visa_probe.penable                                                                        ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[352:352]           = hqm_pmsm_visa_probe.pgcb_hqm_idle                                                                  ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[353:353]           = hqm_pmsm_visa_probe.not_hqm_in_d3                                                                  ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[354:354]           = hqm_pmsm_visa_probe.hqm_in_d3                                                                      ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[355:355]           = hqm_pmsm_visa_probe.go_off                                                                         ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[356:356]           = hqm_pmsm_visa_probe.go_on                                                                          ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[357:357]           = hqm_pmsm_visa_probe.pmsm_shields_up                                                                ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[358:358]           = hqm_pmsm_visa_probe.pm_fsm_d0tod3_ok                                                               ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[359:359]           = hqm_pmsm_visa_probe.pm_fsm_d3tod0_ok                                                               ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[360:360]           = hqm_pmsm_visa_probe.pmsm_pgcb_req_b                                                                ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux0[365:361]           = hqm_pmsm_visa_probe.PMSM[4:0]                                                                      ;
(* inserted_by="VISA IT" *) assign visaRt_serial_cfg_in_local                    = {fvisa_serdata_vcfn,fvisa_frame_vcfn,fvisa_serstb_vcfn}                                            ;
(* inserted_by="VISA IT" *) assign visaSrcClk_i_hqm_visa_mux_top_vcfn[0]         = prim_freerun_clk                                                                                   ;
(* inserted_by="VISA IT" *) assign visaSrcClk_i_hqm_visa_repeater_vcfn[0]        = prim_freerun_clk                                                                                   ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 0][0]}   = visaPrbsFrom_hqm_visa_mux0[0:0] /* hqm_sif_visa_struct.trn_phdr_deq_wl */                          ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 0][1]}   = visaPrbsFrom_hqm_visa_mux0[1:1] /* hqm_sif_visa_struct.trn_cmplh_deq_wl */                         ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 0][2]}   = visaPrbsFrom_hqm_visa_mux0[2:2] /* hqm_sif_visa_struct.trn_pderr_rxl */                            ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 0][3]}   = visaPrbsFrom_hqm_visa_mux0[3:3] /* hqm_sif_visa_struct.trn_pdata_valid_rl */                       ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 0][4]}   = visaPrbsFrom_hqm_visa_mux0[4:4] /* hqm_sif_visa_struct.trn_ph_valid_rl */                          ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 0][5]}   = visaPrbsFrom_hqm_visa_mux0[5:5] /* hqm_sif_visa_struct.trn_ioq_valid_rl */                         ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 0][6]}   = visaPrbsFrom_hqm_visa_mux0[6:6] /* hqm_sif_visa_struct.trn_ioq_p_rl */                             ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 0][7]}   = visaPrbsFrom_hqm_visa_mux0[7:7] /* hqm_sif_visa_struct.trn_ioq_cmpl_rl */                          ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 1][4:0]} = visaPrbsFrom_hqm_visa_mux0[12:8] /* hqm_sif_visa_struct.trn_nxtstate_wxl[4:0] */                   ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 1][6:5]} = visaPrbsFrom_hqm_visa_mux0[14:13] /* hqm_sif_visa_struct.trn_trans_type_rxl[1:0] */                ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 1][7]}   = visaPrbsFrom_hqm_visa_mux0[15:15] /* hqm_sif_visa_struct.trn_p_tlp_avail_wl */                     ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 2][0]}   = visaPrbsFrom_hqm_visa_mux0[16:16] /* hqm_sif_visa_struct.trn_ti_obcmpl_ack_rl2 */                  ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 2][1]}   = visaPrbsFrom_hqm_visa_mux0[17:17] /* hqm_sif_visa_struct.trn_ri_obcmpl_req_rl2 */                  ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 2][2]}   = visaPrbsFrom_hqm_visa_mux0[18:18] /* hqm_sif_visa_struct.trn_cmpl_req_rl */                        ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 2][3]}   = visaPrbsFrom_hqm_visa_mux0[19:19] /* hqm_sif_visa_struct.trn_p_req_wl */                           ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 2][4]}   = visaPrbsFrom_hqm_visa_mux0[20:20] /* hqm_sif_visa_struct.trn_msi_write */                          ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 2][5]}   = visaPrbsFrom_hqm_visa_mux0[21:21] /* hqm_sif_visa_struct.trn_msix_write */                         ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 2][6]}   = visaPrbsFrom_hqm_visa_mux0[22:22] /* hqm_sif_visa_struct.trn_ims_write */                          ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 2][7]}   = visaPrbsFrom_hqm_visa_mux0[4:4] /* hqm_sif_visa_struct.trn_ph_valid_rl */                          ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 3][0]}   = visaPrbsFrom_hqm_visa_mux0[5:5] /* hqm_sif_visa_struct.trn_ioq_valid_rl */                         ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 3][1]}   = visaPrbsFrom_hqm_visa_mux0[6:6] /* hqm_sif_visa_struct.trn_ioq_p_rl */                             ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 3][2]}   = visaPrbsFrom_hqm_visa_mux0[20:20] /* hqm_sif_visa_struct.trn_msi_write */                          ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 3][6:3]} = visaPrbsFrom_hqm_visa_mux0[26:23] /* hqm_sif_visa_struct.trn_msi_vf[3:0] */                        ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 3][7]}   = visaPrbsFrom_hqm_visa_mux0[27:27] /* hqm_sif_visa_struct.phdr_rxl_pasidtlp_22 */                   ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 4][0]}   = visaPrbsFrom_hqm_visa_mux0[28:28] /* hqm_sif_visa_struct.ph_trigger */                             ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 4][1]}   = visaPrbsFrom_hqm_visa_mux0[29:29] /* hqm_sif_visa_struct.ti_idle_q */                              ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 4][2]}   = visaPrbsFrom_hqm_visa_mux0[30:30] /* hqm_sif_visa_struct.ti_iosfp_push_wl */                       ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 4][3]}   = visaPrbsFrom_hqm_visa_mux0[31:31] /* hqm_sif_visa_struct.ti_rsprepack_vote_rp */                   ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 4][4]}   = visaPrbsFrom_hqm_visa_mux0[32:32] /* hqm_sif_visa_struct.ri_iosfp_quiesce_rp */                    ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 4][5]}   = visaPrbsFrom_hqm_visa_mux0[33:33] /* hqm_sif_visa_struct.reqsrv_send_msg */                        ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 4][6]}   = visaPrbsFrom_hqm_visa_mux0[34:34] /* hqm_sif_visa_struct.csr_pasid_enable */                       ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 4][7]}   = visaPrbsFrom_hqm_visa_mux0[35:35] /* hqm_sif_visa_struct.ri_idle_q */                              ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 5][0]}   = visaPrbsFrom_hqm_visa_mux0[36:36] /* hqm_sif_visa_struct.cds_cfg_wr_sai_ok */                      ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 5][1]}   = visaPrbsFrom_hqm_visa_mux0[37:37] /* hqm_sif_visa_struct.cds_cfg_wr_sai_error */                   ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 5][2]}   = visaPrbsFrom_hqm_visa_mux0[38:38] /* hqm_sif_visa_struct.cds_cfg_wr_ur */                          ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 5][3]}   = visaPrbsFrom_hqm_visa_mux0[39:39] /* hqm_sif_visa_struct.cds_mmio_wr_sai_ok */                     ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 5][4]}   = visaPrbsFrom_hqm_visa_mux0[40:40] /* hqm_sif_visa_struct.cds_mmio_wr_sai_error */                  ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 5][5]}   = visaPrbsFrom_hqm_visa_mux0[41:41] /* hqm_sif_visa_struct.cds_csr_rd_timeout_error */               ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 5][6]}   = visaPrbsFrom_hqm_visa_mux0[42:42] /* hqm_sif_visa_struct.cds_csr_rd_sai_error */                   ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 5][7]}   = visaPrbsFrom_hqm_visa_mux0[43:43] /* hqm_sif_visa_struct.cds_csr_rd_ur */                          ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 6][0]}   = visaPrbsFrom_hqm_visa_mux0[44:44] /* hqm_sif_visa_struct.cds_cbd_decode_val_0 */                   ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 6][1]}   = visaPrbsFrom_hqm_visa_mux0[45:45] /* hqm_sif_visa_struct.cds_bar_decode_err_wp */                  ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 6][2]}   = visaPrbsFrom_hqm_visa_mux0[46:46] /* hqm_sif_visa_struct.cds_cbd_csr_pf_bar_hit */                 ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 6][3]}   = visaPrbsFrom_hqm_visa_mux0[47:47] /* hqm_sif_visa_struct.cds_cbd_func_vf_rgn_hit_0 */              ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 6][4]}   = visaPrbsFrom_hqm_visa_mux0[48:48] /* hqm_sif_visa_struct.cds_cbd_csr_pf_rgn_hit_0 */               ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 6][5]}   = visaPrbsFrom_hqm_visa_mux0[49:49] /* hqm_sif_visa_struct.cds_cbd_func_pf_rgn_hit_0 */              ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 6][6]}   = visaPrbsFrom_hqm_visa_mux0[50:50] /* hqm_sif_visa_struct.cds_cbd_func_vf_bar_hit_0 */              ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 6][7]}   = visaPrbsFrom_hqm_visa_mux0[51:51] /* hqm_sif_visa_struct.cds_cbd_func_pf_bar_hit_0 */              ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 7][0]}   = visaPrbsFrom_hqm_visa_mux0[52:52] /* hqm_sif_visa_struct.cds_addr_val */                           ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 7][1]}   = visaPrbsFrom_hqm_visa_mux0[53:53] /* hqm_sif_visa_struct.cds_cbd_csr_pf_rgn_hit_1 */               ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 7][7:2]} = 6'b0 /* filler */                                                                                  ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 8][3:0]} = visaPrbsFrom_hqm_visa_mux0[57:54] /* hqm_sif_visa_struct.csr_req_q_csr_func_vf_num[3:0] */         ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 8][4]}   = visaPrbsFrom_hqm_visa_mux0[58:58] /* hqm_sif_visa_struct.csr_req_q_csr_func_vf_mem_mapped */       ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 8][5]}   = visaPrbsFrom_hqm_visa_mux0[59:59] /* hqm_sif_visa_struct.csr_req_q_csr_func_pf_mem_mapped */       ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 8][6]}   = visaPrbsFrom_hqm_visa_mux0[60:60] /* hqm_sif_visa_struct.csr_req_q_csr_ext_mem_mapped */           ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 8][7]}   = visaPrbsFrom_hqm_visa_mux0[61:61] /* hqm_sif_visa_struct.csr_req_q_csr_mem_mapped */               ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 9][0]}   = visaPrbsFrom_hqm_visa_mux0[62:62] /* hqm_sif_visa_struct.csr_pf0_req_data_0 */                     ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 9][1]}   = visaPrbsFrom_hqm_visa_mux0[63:63] /* hqm_sif_visa_struct.csr_pf0_req_opcode_0 */                   ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 9][2]}   = visaPrbsFrom_hqm_visa_mux0[64:64] /* hqm_sif_visa_struct.csr_pf0_req_valid */                      ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 9][3]}   = visaPrbsFrom_hqm_visa_mux0[65:65] /* hqm_sif_visa_struct.csr_pf0_ack_write_valid */                ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 9][4]}   = visaPrbsFrom_hqm_visa_mux0[66:66] /* hqm_sif_visa_struct.csr_pf0_ack_read_valid */                 ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 9][5]}   = visaPrbsFrom_hqm_visa_mux0[67:67] /* hqm_sif_visa_struct.csr_pf0_ack_write_miss */                 ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 9][6]}   = visaPrbsFrom_hqm_visa_mux0[68:68] /* hqm_sif_visa_struct.csr_pf0_ack_read_miss */                  ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 9][7]}   = visaPrbsFrom_hqm_visa_mux0[69:69] /* hqm_sif_visa_struct.csr_pf0_ack_sai_successfull */            ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[10][0]}   = visaPrbsFrom_hqm_visa_mux0[70:70] /* hqm_sif_visa_struct.csr_int_mmio_req_data_0 */                ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[10][1]}   = visaPrbsFrom_hqm_visa_mux0[71:71] /* hqm_sif_visa_struct.csr_int_mmio_req_opcode_0 */              ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[10][2]}   = visaPrbsFrom_hqm_visa_mux0[72:72] /* hqm_sif_visa_struct.csr_int_mmio_req_valid */                 ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[10][3]}   = visaPrbsFrom_hqm_visa_mux0[73:73] /* hqm_sif_visa_struct.csr_int_mmio_ack_write_valid */           ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[10][4]}   = visaPrbsFrom_hqm_visa_mux0[74:74] /* hqm_sif_visa_struct.csr_int_mmio_ack_read_valid */            ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[10][5]}   = visaPrbsFrom_hqm_visa_mux0[75:75] /* hqm_sif_visa_struct.csr_int_mmio_ack_write_miss */            ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[10][6]}   = visaPrbsFrom_hqm_visa_mux0[76:76] /* hqm_sif_visa_struct.csr_int_mmio_ack_read_miss */             ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[10][7]}   = visaPrbsFrom_hqm_visa_mux0[77:77] /* hqm_sif_visa_struct.csr_int_mmio_ack_sai_successfull */       ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[11][0]}   = visaPrbsFrom_hqm_visa_mux0[78:78] /* hqm_sif_visa_struct.csr_ext_mmio_req_data_0 */                ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[11][1]}   = visaPrbsFrom_hqm_visa_mux0[79:79] /* hqm_sif_visa_struct.csr_ext_mmio_req_opcode_0 */              ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[11][2]}   = visaPrbsFrom_hqm_visa_mux0[80:80] /* hqm_sif_visa_struct.csr_ext_mmio_req_valid */                 ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[11][3]}   = visaPrbsFrom_hqm_visa_mux0[81:81] /* hqm_sif_visa_struct.csr_ext_mmio_ack_write_valid */           ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[11][4]}   = visaPrbsFrom_hqm_visa_mux0[82:82] /* hqm_sif_visa_struct.csr_ext_mmio_ack_read_valid */            ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[11][5]}   = visaPrbsFrom_hqm_visa_mux0[83:83] /* hqm_sif_visa_struct.csr_ext_mmio_ack_write_miss */            ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[11][6]}   = visaPrbsFrom_hqm_visa_mux0[84:84] /* hqm_sif_visa_struct.csr_ext_mmio_ack_read_miss */             ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[11][7]}   = visaPrbsFrom_hqm_visa_mux0[85:85] /* hqm_sif_visa_struct.csr_ext_mmio_ack_sai_successfull */       ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[12][2:0]} = visaPrbsFrom_hqm_visa_mux0[88:86] /* hqm_sif_visa_struct.obc_ri_obcmpl_hdr_rxl_cs[2:0] */          ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[12][5:3]} = visaPrbsFrom_hqm_visa_mux0[91:89] /* hqm_sif_visa_struct.obc_ri_obcmpl_hdr_rxl_tc[2:0] */          ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[12][6]}   = visaPrbsFrom_hqm_visa_mux0[92:92] /* hqm_sif_visa_struct.obc_ri_obcmpl_hdr_rxl_ep */               ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[12][7]}   = visaPrbsFrom_hqm_visa_mux0[93:93] /* hqm_sif_visa_struct.obc_ri_obcmpl_req_rl */                   ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[13][1:0]} = visaPrbsFrom_hqm_visa_mux0[95:94] /* hqm_sif_visa_struct.tlq_ioq_data_rxp[1:0] */                  ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[13][2]}   = visaPrbsFrom_hqm_visa_mux0[96:96] /* hqm_sif_visa_struct.tlq_ioqval_wp */                          ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[13][3]}   = visaPrbsFrom_hqm_visa_mux0[97:97] /* hqm_sif_visa_struct.tlq_ioq_pop */                            ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[13][4]}   = visaPrbsFrom_hqm_visa_mux0[98:98] /* hqm_sif_visa_struct.tlq_ioq_hdr_push_in */                    ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[13][5]}   = visaPrbsFrom_hqm_visa_mux0[99:99] /* hqm_sif_visa_struct.tlq_ioq_fifo_full */                      ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[13][6]}   = visaPrbsFrom_hqm_visa_mux0[100:100] /* hqm_sif_visa_struct.tlq_npdataval_wp */                     ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[13][7]}   = visaPrbsFrom_hqm_visa_mux0[101:101] /* hqm_sif_visa_struct.tlq_tlq_pdataval_wp */                  ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[14][6:0]} = visaPrbsFrom_hqm_visa_mux0[108:102] /* hqm_sif_visa_struct.rxq_pcie_cmd[6:0] */                    ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[14][7]}   = visaPrbsFrom_hqm_visa_mux0[109:109] /* hqm_sif_visa_struct.rxq_ti_iosfp_push_wi */                 ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[15][0]}   = visaPrbsFrom_hqm_visa_mux0[110:110] /* hqm_sif_visa_struct.cpldata_rxq_fifo_push */                ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[15][1]}   = visaPrbsFrom_hqm_visa_mux0[111:111] /* hqm_sif_visa_struct.cplhdr_rxq_fifo_push */                 ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[15][2]}   = visaPrbsFrom_hqm_visa_mux0[112:112] /* hqm_sif_visa_struct.pdata_rxq_fifo_push */                  ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[15][3]}   = visaPrbsFrom_hqm_visa_mux0[113:113] /* hqm_sif_visa_struct.phdr_rxq_fifo_push */                   ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[15][4]}   = visaPrbsFrom_hqm_visa_mux0[114:114] /* hqm_sif_visa_struct.ioq_rxq_fifo_push */                    ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[15][5]}   = visaPrbsFrom_hqm_visa_mux0[115:115] /* hqm_sif_visa_struct.phdr_rxq_fifo_perr_q */                 ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[15][6]}   = visaPrbsFrom_hqm_visa_mux0[116:116] /* hqm_sif_visa_struct.rxq_ti_iosfp_ifc_wxi_endp */            ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[15][7]}   = visaPrbsFrom_hqm_visa_mux0[117:117] /* hqm_sif_visa_struct.rxq_ti_iosfp_ifc_wxi_stp */             ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[16][0]}   = visaPrbsFrom_hqm_visa_mux0[118:118] /* hqm_sif_visa_struct.cpldata_rxq_fifo_pop */                 ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[16][1]}   = visaPrbsFrom_hqm_visa_mux0[119:119] /* hqm_sif_visa_struct.cplhdr_rxq_fifo_pop */                  ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[16][2]}   = visaPrbsFrom_hqm_visa_mux0[120:120] /* hqm_sif_visa_struct.pdata_rxq_fifo_pop */                   ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[16][3]}   = visaPrbsFrom_hqm_visa_mux0[121:121] /* hqm_sif_visa_struct.phdr_rxq_fifo_pop */                    ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[16][4]}   = visaPrbsFrom_hqm_visa_mux0[122:122] /* hqm_sif_visa_struct.ioq_rxq_fifo_pop */                     ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[16][5]}   = visaPrbsFrom_hqm_visa_mux0[123:123] /* hqm_sif_visa_struct.cplhdr_rxq_fifo_perr_q */               ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[16][6]}   = visaPrbsFrom_hqm_visa_mux0[124:124] /* hqm_sif_visa_struct.rxq_ri_iosfp_quiesce_rp */              ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[16][7]}   = visaPrbsFrom_hqm_visa_mux0[125:125] /* hqm_sif_visa_struct.rxq_ti_rsprepack_vote_rp_q */           ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[17][4:0]} = visaPrbsFrom_hqm_visa_mux0[130:126] /* hqm_sif_visa_struct.mstr_iosf_ep_poison_wr_func_rxl[4:0] */ ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[17][5]}   = visaPrbsFrom_hqm_visa_mux0[131:131] /* hqm_sif_visa_struct.mstr_iosf_ep_poison_wr_sent_rl */       ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[17][6]}   = visaPrbsFrom_hqm_visa_mux0[132:132] /* hqm_sif_visa_struct.mstr_iosfp_ri_rxq_rsprepack_vote_ri */  ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[17][7]}   = visaPrbsFrom_hqm_visa_mux0[133:133] /* hqm_sif_visa_struct.mstr_iosfp_ti_rxq_rdy */                ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[18][0]}   = visaPrbsFrom_hqm_visa_mux0[134:134] /* hqm_sif_visa_struct.mstr_iosf_req_put */                    ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[18][2:1]} = visaPrbsFrom_hqm_visa_mux0[136:135] /* hqm_sif_visa_struct.mstr_iosf_req_rtype[1:0] */             ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[18][3]}   = visaPrbsFrom_hqm_visa_mux0[137:137] /* hqm_sif_visa_struct.mstr_iosf_gnt_q_gnt */                  ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[18][5:4]} = visaPrbsFrom_hqm_visa_mux0[139:138] /* hqm_sif_visa_struct.mstr_iosf_gnt_q_rtype[1:0] */           ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[18][7:6]} = visaPrbsFrom_hqm_visa_mux0[141:140] /* hqm_sif_visa_struct.mstr_iosf_gnt_q_gtype[1:0] */           ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[19][1:0]} = visaPrbsFrom_hqm_visa_mux0[143:142] /* hqm_sif_visa_struct.mstr_hfifo_rd[1:0] */                   ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[19][3:2]} = visaPrbsFrom_hqm_visa_mux0[145:144] /* hqm_sif_visa_struct.mstr_dfifo_rd[1:0] */                   ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[19][4]}   = visaPrbsFrom_hqm_visa_mux0[146:146] /* hqm_sif_visa_struct.mstr_dfifo_rd_gt4dw */                  ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[19][7:5]} = visaPrbsFrom_hqm_visa_mux0[149:147] /* hqm_sif_visa_struct.mstr_prim_ism_agent[2:0] */             ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[20][1:0]} = visaPrbsFrom_hqm_visa_mux0[151:150] /* hqm_sif_visa_struct.mstr_req_fifo_fully[1:0] */             ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[20][3:2]} = visaPrbsFrom_hqm_visa_mux0[153:152] /* hqm_sif_visa_struct.mstr_req_fifo_empty[1:0] */             ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[20][5:4]} = visaPrbsFrom_hqm_visa_mux0[155:154] /* hqm_sif_visa_struct.mstr_iosf_gnt_q_dec[1:0] */             ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[20][7:6]} = visaPrbsFrom_hqm_visa_mux0[157:156] /* hqm_sif_visa_struct.mstr_rxq_hdr_avail[1:0] */              ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[21][4:0]} = visaPrbsFrom_hqm_visa_mux0[162:158] /* hqm_sif_visa_struct.mstr_hfifo_data_type[4:0] */            ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[21][6:5]} = visaPrbsFrom_hqm_visa_mux0[164:163] /* hqm_sif_visa_struct.mstr_hfifo_data_fmt[1:0] */             ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[21][7]}   = visaPrbsFrom_hqm_visa_mux0[165:165] /* hqm_sif_visa_struct.mstr_idle */                            ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[22][4:0]} = visaPrbsFrom_hqm_visa_mux0[170:166] /* hqm_sif_visa_struct.mstr_iosf_req_credits_p[4:0] */         ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[22][5]}   = visaPrbsFrom_hqm_visa_mux0[171:171] /* hqm_sif_visa_struct.mstr_data_out_valid_q */                ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[22][7:6]} = visaPrbsFrom_hqm_visa_mux0[173:172] /* hqm_sif_visa_struct.mstr_iosf_req_dlen_1_0[1:0] */          ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[23][4:0]} = visaPrbsFrom_hqm_visa_mux0[178:174] /* hqm_sif_visa_struct.mstr_iosf_req_credits_cpl[4:0] */       ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[23][7:5]} = visaPrbsFrom_hqm_visa_mux0[181:179] /* hqm_sif_visa_struct.mstr_iosf_req_dlen_4_2[2:0] */          ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[24][4:0]} = visaPrbsFrom_hqm_visa_mux0[186:182] /* hqm_sif_visa_struct.mstr_iosf_cmd_ctype[4:0] */             ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[24][6:5]} = visaPrbsFrom_hqm_visa_mux0[188:187] /* hqm_sif_visa_struct.mstr_iosf_cmd_cfmt[1:0] */              ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[24][7]}   = visaPrbsFrom_hqm_visa_mux0[189:189] /* hqm_sif_visa_struct.mstr_iosf_gnt_q_gnt2 */                 ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[25][0]}   = visaPrbsFrom_hqm_visa_mux0[190:190] /* hqm_sif_visa_struct.mstr_iosf_cmd_ctd */                    ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[25][2:1]} = visaPrbsFrom_hqm_visa_mux0[192:191] /* hqm_sif_visa_struct.mstr_iosf_cmd_cat[1:0] */               ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[25][3]}   = visaPrbsFrom_hqm_visa_mux0[193:193] /* hqm_sif_visa_struct.mstr_iosf_cmd_cido */                   ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[25][4]}   = visaPrbsFrom_hqm_visa_mux0[194:194] /* hqm_sif_visa_struct.mstr_iosf_cmd_cns */                    ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[25][5]}   = visaPrbsFrom_hqm_visa_mux0[195:195] /* hqm_sif_visa_struct.mstr_iosf_cmd_cro */                    ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[25][6]}   = visaPrbsFrom_hqm_visa_mux0[196:196] /* hqm_sif_visa_struct.mstr_iosf_cmd_cep */                    ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[25][7]}   = visaPrbsFrom_hqm_visa_mux0[197:197] /* hqm_sif_visa_struct.mstr_iosf_cmd_cth */                    ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[26][7:0]} = visaPrbsFrom_hqm_visa_mux0[205:198] /* hqm_sif_visa_struct.mstr_iosf_cmd_clength_7_0[7:0] */       ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[28:27]}   = visaPrbsFrom_hqm_visa_mux0[221:206] /* hqm_sif_visa_struct.mstr_iosf_cmd_crqid[15:0] */            ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[29][7:0]} = visaPrbsFrom_hqm_visa_mux0[229:222] /* hqm_sif_visa_struct.mstr_iosf_cmd_ctag[7:0] */              ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[30][3:0]} = visaPrbsFrom_hqm_visa_mux0[233:230] /* hqm_sif_visa_struct.mstr_iosf_cmd_cfbe[3:0] */              ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[30][7:4]} = visaPrbsFrom_hqm_visa_mux0[237:234] /* hqm_sif_visa_struct.mstr_iosf_cmd_clbe[3:0] */              ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[34:31]}   = visaPrbsFrom_hqm_visa_mux0[269:238] /* hqm_sif_visa_struct.mstr_iosf_cmd_caddress_31_0[31:0] */    ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[35][3:0]} = visaPrbsFrom_hqm_visa_mux0[273:270] /* hqm_sif_visa_struct.iosf_tgt_port_present[3:0] */           ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[35][4]}   = visaPrbsFrom_hqm_visa_mux0[274:274] /* hqm_sif_visa_struct.iosf_tgt_zero */                        ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[35][5]}   = visaPrbsFrom_hqm_visa_mux0[275:275] /* hqm_sif_visa_struct.iosf_tgt_credit_init */                 ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[35][6]}   = visaPrbsFrom_hqm_visa_mux0[276:276] /* hqm_sif_visa_struct.iosf_tgt_rst_complete */                ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[35][7]}   = visaPrbsFrom_hqm_visa_mux0[277:277] /* hqm_sif_visa_struct.iosf_tgt_crdtinit_in_progress */        ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[37][1:0],
                                    visaLaneIn_i_hqm_visa_mux_top_vcfn[36]} = visaPrbsFrom_hqm_visa_mux0[287:278] /* hqm_sif_visa_struct.iosf_tgt_data_count_ff[9:0] */               ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[37][2]}   = visaPrbsFrom_hqm_visa_mux0[288:288] /* hqm_sif_visa_struct.iosf_tgt_has_data */                    ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[37][4:3]} = visaPrbsFrom_hqm_visa_mux0[290:289] /* hqm_sif_visa_struct.iosf_tgt_cmd_tfmt[1:0] */               ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[37][5]}   = visaPrbsFrom_hqm_visa_mux0[291:291] /* hqm_sif_visa_struct.iosf_tgt_cput_cmd_put */                ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[37][7:6]} = visaPrbsFrom_hqm_visa_mux0[293:292] /* hqm_sif_visa_struct.iosf_tgt_cput_cmd_rtype[1:0] */         ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[38][0]}   = visaPrbsFrom_hqm_visa_mux0[294:294] /* hqm_sif_visa_struct.iosf_tgt_idle */                        ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[38][4:1]} = visaPrbsFrom_hqm_visa_mux0[298:295] /* hqm_sif_visa_struct.iosf_tgt_dec_type[3:0] */               ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[38][7:5]} = visaPrbsFrom_hqm_visa_mux0[301:299] /* hqm_sif_visa_struct.iosf_tgt_dec_bits[2:0] */               ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[39][0]}   = visaPrbsFrom_hqm_visa_mux0[302:302] /* hqm_sif_visa_struct.sys_cfgm_idle */                        ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[39][1]}   = visaPrbsFrom_hqm_visa_mux0[303:303] /* hqm_sif_visa_struct.sys_ti_idle */                          ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[39][2]}   = visaPrbsFrom_hqm_visa_mux0[304:304] /* hqm_sif_visa_struct.sys_ri_idle */                          ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[39][3]}   = visaPrbsFrom_hqm_visa_mux0[305:305] /* hqm_sif_visa_struct.sys_tgt_idle */                         ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[39][4]}   = visaPrbsFrom_hqm_visa_mux0[306:306] /* hqm_sif_visa_struct.sys_mstr_idle */                        ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[39][5]}   = visaPrbsFrom_hqm_visa_mux0[307:307] /* hqm_sif_visa_struct.hqm_idle_q */                           ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[39][6]}   = visaPrbsFrom_hqm_visa_mux0[308:308] /* hqm_sif_visa_struct.prim_clkack_sync */                     ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[39][7]}   = visaPrbsFrom_hqm_visa_mux0[309:309] /* hqm_sif_visa_struct.prim_clkreq_sync */                     ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[40][0]}   = visaPrbsFrom_hqm_visa_mux0[310:310] /* hqm_sif_visa_struct.prim_clk_enable_sys */                  ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[40][1]}   = visaPrbsFrom_hqm_visa_mux0[311:311] /* hqm_sif_visa_struct.prim_clk_enable */                      ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[40][2]}   = visaPrbsFrom_hqm_visa_mux0[312:312] /* hqm_sif_visa_struct.prim_gated_rst_b_sync */                ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[40][3]}   = visaPrbsFrom_hqm_visa_mux0[313:313] /* hqm_sif_visa_struct.sw_trigger */                           ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[40][5:4]} = visaPrbsFrom_hqm_visa_mux0[315:314] /* hqm_sif_visa_struct.ps[1:0] */                              ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[40][6]}   = visaPrbsFrom_hqm_visa_mux0[316:316] /* hqm_sif_visa_struct.pf0_fsm_rst */                          ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[40][7]}   = visaPrbsFrom_hqm_visa_mux0[317:317] /* hqm_sif_visa_struct.flr */                                  ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[41][0]}   = visaPrbsFrom_hqm_visa_mux0[318:318] /* hqm_sif_visa_struct.flr_cmp_sent_q */                       ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[41][1]}   = visaPrbsFrom_hqm_visa_mux0[319:319] /* hqm_sif_visa_struct.flr_txn_sent_q */                       ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[41][2]}   = visaPrbsFrom_hqm_visa_mux0[320:320] /* hqm_sif_visa_struct.ps_cmp_sent_ack */                      ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[41][3]}   = visaPrbsFrom_hqm_visa_mux0[321:321] /* hqm_sif_visa_struct.ps_cmp_sent_q */                        ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[41][4]}   = visaPrbsFrom_hqm_visa_mux0[322:322] /* hqm_sif_visa_struct.ps_txn_sent_q */                        ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[41][5]}   = visaPrbsFrom_hqm_visa_mux0[323:323] /* hqm_sif_visa_struct.bme_or_mem_wr */                        ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[41][6]}   = visaPrbsFrom_hqm_visa_mux0[324:324] /* hqm_sif_visa_struct.flr_pending */                          ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[41][7]}   = visaPrbsFrom_hqm_visa_mux0[325:325] /* hqm_sif_visa_struct.flr_treatment */                        ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[42][0]}   = visaPrbsFrom_hqm_visa_mux0[326:326] /* hqm_sif_visa_struct.flr_function0 */                        ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[42][1]}   = visaPrbsFrom_hqm_visa_mux0[327:327] /* hqm_sif_visa_struct.ps_d0_to_d3 */                          ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[42][2]}   = visaPrbsFrom_hqm_visa_mux0[328:328] /* hqm_sif_visa_struct.flr_triggered */                        ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[42][3]}   = visaPrbsFrom_hqm_visa_mux0[329:329] /* hqm_sif_visa_struct.prim_clk_enable_cdc */                  ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[42][4]}   = visaPrbsFrom_hqm_visa_mux0[330:330] /* hqm_sif_visa_struct.flr_clk_enable_system */                ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[42][5]}   = visaPrbsFrom_hqm_visa_mux0[331:331] /* hqm_sif_visa_struct.flr_clk_enable */                       ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[42][6]}   = visaPrbsFrom_hqm_visa_mux0[332:332] /* hqm_sif_visa_struct.flr_triggered_wl */                     ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[42][7]}   = visaPrbsFrom_hqm_visa_mux0[333:333] /* hqm_sif_visa_struct.flr_cmp_sent */                         ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[43][0]}   = visaPrbsFrom_hqm_visa_mux0[334:334] /* hqm_pmsm_visa_probe.spare */                                ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[43][1]}   = visaPrbsFrom_hqm_visa_mux0[335:335] /* hqm_pmsm_visa_probe.cfg_pm_status_pgcb_fet_en_b */          ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[43][2]}   = visaPrbsFrom_hqm_visa_mux0[336:336] /* hqm_pmsm_visa_probe.cfg_pm_status_pmc_pgcb_fet_en_b */      ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[43][3]}   = visaPrbsFrom_hqm_visa_mux0[337:337] /* hqm_pmsm_visa_probe.cfg_pm_status_pmc_pgcb_pg_ack_b */      ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[43][4]}   = visaPrbsFrom_hqm_visa_mux0[338:338] /* hqm_pmsm_visa_probe.cfg_pm_status_pgcb_pmc_pg_req_b */      ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[43][5]}   = visaPrbsFrom_hqm_visa_mux0[339:339] /* hqm_pmsm_visa_probe.cfg_pm_status_PMSM_PGCB_REQ_B */        ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[43][6]}   = visaPrbsFrom_hqm_visa_mux0[340:340] /* hqm_pmsm_visa_probe.cfg_pm_status_PGCB_HQM_PG_RDY_ACK_B */  ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[43][7]}   = visaPrbsFrom_hqm_visa_mux0[341:341] /* hqm_pmsm_visa_probe.cfg_pm_status_PGCB_HQM_IDLE */          ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[44][2:0]} = visaPrbsFrom_hqm_visa_mux0[344:342] /* hqm_pmsm_visa_probe.prdata_2_0[2:0] */                      ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[44][3]}   = visaPrbsFrom_hqm_visa_mux0[345:345] /* hqm_pmsm_visa_probe.pready */                               ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[44][7:4]} = visaPrbsFrom_hqm_visa_mux0[349:346] /* hqm_pmsm_visa_probe.paddr_31_28[3:0] */                     ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[45][0]}   = visaPrbsFrom_hqm_visa_mux0[350:350] /* hqm_pmsm_visa_probe.pwrite */                               ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[45][1]}   = visaPrbsFrom_hqm_visa_mux0[351:351] /* hqm_pmsm_visa_probe.penable */                              ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[45][2]}   = visaPrbsFrom_hqm_visa_mux0[352:352] /* hqm_pmsm_visa_probe.pgcb_hqm_idle */                        ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[45][3]}   = visaPrbsFrom_hqm_visa_mux0[353:353] /* hqm_pmsm_visa_probe.not_hqm_in_d3 */                        ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[45][4]}   = visaPrbsFrom_hqm_visa_mux0[354:354] /* hqm_pmsm_visa_probe.hqm_in_d3 */                            ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[45][5]}   = visaPrbsFrom_hqm_visa_mux0[355:355] /* hqm_pmsm_visa_probe.go_off */                               ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[45][6]}   = visaPrbsFrom_hqm_visa_mux0[356:356] /* hqm_pmsm_visa_probe.go_on */                                ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[45][7]}   = visaPrbsFrom_hqm_visa_mux0[357:357] /* hqm_pmsm_visa_probe.pmsm_shields_up */                      ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[46][0]}   = visaPrbsFrom_hqm_visa_mux0[358:358] /* hqm_pmsm_visa_probe.pm_fsm_d0tod3_ok */                     ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[46][1]}   = visaPrbsFrom_hqm_visa_mux0[359:359] /* hqm_pmsm_visa_probe.pm_fsm_d3tod0_ok */                     ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[46][2]}   = visaPrbsFrom_hqm_visa_mux0[360:360] /* hqm_pmsm_visa_probe.pmsm_pgcb_req_b */                      ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[46][7:3]} = visaPrbsFrom_hqm_visa_mux0[365:361] /* hqm_pmsm_visa_probe.PMSM[4:0] */                            ;



`endif // INTEL_GLOBAL_VISA_DISABLE
`endif // __VISA_IT__
