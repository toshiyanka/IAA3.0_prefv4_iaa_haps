`ifndef __VISA_IT__
`ifndef INTEL_GLOBAL_VISA_DISABLE

(* inserted_by="VISA IT",
   sig_file="/nfs/site/disks/sdg74_3369/users/stepollo/hqm-srvr10nm-wave4-visa2/tools/visa/hqm_visa_mux3.sig",
   visa_it_version="4.3.19",
   probe_ranges_for_src_clk_0="[7:0] /* /hqm/par_hqm_system/hqm_system_aon_wrap/i_hqm_visa/i_hqm_visa_mux3/pgcb_clk */" *)
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
    .lane_out(avisa_dbgbus3_vcfn),
    .visa_unit_id(9'b0)
);

(* inserted_by="VISA IT",
   sig_file="/nfs/site/disks/sdg74_3369/users/stepollo/hqm-srvr10nm-wave4-visa2/tools/visa/hqm_visa_mux3.sig",
   visa_it_version="4.3.19",
   probe_ranges_for_src_clk_0="[11:0][25:16][34:32] /* /hqm/par_hqm_system/hqm_system_aon_wrap/i_hqm_visa/i_hqm_visa_mux3/pgcb_clk */" *)
hqm_visa_unit_mux_cro_s #(
    .SCAN_CLK_INDEX(0),
    .BLACKBOX_MASK(32'b0),
    .NUM_OUTPUT_LANES(1),
    .BUGCOMPAT_MIN_PROTECTION_LATCH(0),
    .NUM_INPUT_CLKS(1),
    .CUST_VIS_TOP_LANE(0),
    .NUM_INPUT_LANES(5),
    .OEM_VIS_TOP_LANE(0),
    .PATGEN_TYPE(1),
    .USE_CLKMUX(0),
    .USE_MIN_PROTECTION_LATCH(0),
    .HAS_DATA_PATH_RESET(1),
    .DESERIALIZER_MASK({32'b10000000100000111, 32'b1110001}),
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
    .visa_unit_id(fvisa_startid3_vcfn)
);

(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux3[ 4: 0]            = pgcbunit_visa_probe.pgcb_ps[4:0]                                                 ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux3[ 5: 5]            = pgcbunit_visa_probe.sync_pmc_pgcb_restore_b                                      ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux3[ 6: 6]            = pgcbunit_visa_probe.sync_pmc_pgcb_pg_ack_b                                       ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux3[ 7: 7]            = pgcbunit_visa_probe.ip_pgcb_pg_rdy_req_b                                         ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux3[ 9: 8]            = pgcbunit_visa_probe.int_pg_type[1:0]                                             ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux3[10:10]            = pgcbunit_visa_probe.int_isollatch_en                                             ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux3[11:11]            = pgcbunit_visa_probe.int_sleep_en                                                 ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux3[15:12]            = cdc_visa_probe.cdc_spare[3:0]                                                    ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux3[16:16]            = cdc_visa_probe.locked_pg                                                         ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux3[17:17]            = cdc_visa_probe.force_ready_pg                                                    ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux3[18:18]            = cdc_visa_probe.domain_pok_pg                                                     ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux3[19:19]            = cdc_visa_probe.assert_clkreq_pg                                                  ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux3[20:20]            = cdc_visa_probe.unlock_domain_pg                                                  ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux3[21:21]            = cdc_visa_probe.pwrgate_ready                                                     ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux3[24:22]            = dfxseq_ps[2:0]                                                                   ;
(* inserted_by="VISA IT" *) assign visaRt_serial_cfg_in_local                   = {fvisa_serdata_vcfn,fvisa_frame_vcfn,fvisa_serstb_vcfn}                          ;
(* inserted_by="VISA IT" *) assign visaSrcClk_i_hqm_visa_mux_top_vcfn[0]        = pgcb_clk                                                                         ;
(* inserted_by="VISA IT" *) assign visaSrcClk_i_hqm_visa_repeater_vcfn[0]       = pgcb_clk                                                                         ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[0][4:0]} = visaPrbsFrom_hqm_visa_mux3[4:0] /* pgcbunit_visa_probe.pgcb_ps[4:0] */           ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[0][5]}   = visaPrbsFrom_hqm_visa_mux3[5:5] /* pgcbunit_visa_probe.sync_pmc_pgcb_restore_b */;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[0][6]}   = visaPrbsFrom_hqm_visa_mux3[6:6] /* pgcbunit_visa_probe.sync_pmc_pgcb_pg_ack_b */ ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[0][7]}   = visaPrbsFrom_hqm_visa_mux3[7:7] /* pgcbunit_visa_probe.ip_pgcb_pg_rdy_req_b */   ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[1][1:0]} = visaPrbsFrom_hqm_visa_mux3[9:8] /* pgcbunit_visa_probe.int_pg_type[1:0] */       ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[1][2]}   = visaPrbsFrom_hqm_visa_mux3[10:10] /* pgcbunit_visa_probe.int_isollatch_en */     ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[1][3]}   = visaPrbsFrom_hqm_visa_mux3[11:11] /* pgcbunit_visa_probe.int_sleep_en */         ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[1][7:4]} = 4'b0 /* filler */                                                                ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[2][3:0]} = visaPrbsFrom_hqm_visa_mux3[15:12] /* cdc_visa_probe.cdc_spare[3:0] */            ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[2][4]}   = visaPrbsFrom_hqm_visa_mux3[16:16] /* cdc_visa_probe.locked_pg */                 ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[2][5]}   = visaPrbsFrom_hqm_visa_mux3[17:17] /* cdc_visa_probe.force_ready_pg */            ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[2][6]}   = visaPrbsFrom_hqm_visa_mux3[18:18] /* cdc_visa_probe.domain_pok_pg */             ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[2][7]}   = visaPrbsFrom_hqm_visa_mux3[19:19] /* cdc_visa_probe.assert_clkreq_pg */          ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[3][0]}   = visaPrbsFrom_hqm_visa_mux3[20:20] /* cdc_visa_probe.unlock_domain_pg */          ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[3][1]}   = visaPrbsFrom_hqm_visa_mux3[21:21] /* cdc_visa_probe.pwrgate_ready */             ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[3][7:2]} = 6'b0 /* filler */                                                                ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[4][2:0]} = visaPrbsFrom_hqm_visa_mux3[24:22] /* dfxseq_ps[2:0] */                           ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[4][7:3]} = 5'b0 /* filler */                                                                ;



`endif // INTEL_GLOBAL_VISA_DISABLE
`endif // __VISA_IT__
