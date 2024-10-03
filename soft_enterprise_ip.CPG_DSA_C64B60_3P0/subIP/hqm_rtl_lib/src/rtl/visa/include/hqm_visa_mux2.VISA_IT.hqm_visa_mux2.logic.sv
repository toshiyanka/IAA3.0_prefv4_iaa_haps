`ifndef __VISA_IT__
`ifndef INTEL_GLOBAL_VISA_DISABLE

(* inserted_by="VISA IT",
   sig_file="/nfs/site/disks/sdg74_3369/users/stepollo/hqm-srvr10nm-wave4-visa2/tools/visa/hqm_visa_mux2.sig",
   visa_it_version="4.3.19",
   probe_ranges_for_src_clk_0="[7:0] /* /hqm/par_hqm_system/hqm_system_aon_wrap/i_hqm_visa/i_hqm_visa_mux2/side_clk */" *)
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
    .lane_out(avisa_dbgbus2_vcfn),
    .visa_unit_id(9'b0)
);

(* inserted_by="VISA IT",
   sig_file="/nfs/site/disks/sdg74_3369/users/stepollo/hqm-srvr10nm-wave4-visa2/tools/visa/hqm_visa_mux2.sig",
   visa_it_version="4.3.19",
   probe_ranges_for_src_clk_0="[29:0] /* /hqm/par_hqm_system/hqm_system_aon_wrap/i_hqm_visa/i_hqm_visa_mux2/side_clk */" *)
hqm_visa_unit_mux_cro_s #(
    .SCAN_CLK_INDEX(0),
    .BLACKBOX_MASK(32'b0),
    .NUM_OUTPUT_LANES(1),
    .BUGCOMPAT_MIN_PROTECTION_LATCH(0),
    .NUM_INPUT_CLKS(1),
    .CUST_VIS_TOP_LANE(0),
    .NUM_INPUT_LANES(4),
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
    .visa_unit_id(fvisa_startid2_vcfn)
);

(* inserted_by="VISA IT" *) assign visaRt_serial_cfg_in_local                   = {fvisa_serdata_vcfn,fvisa_frame_vcfn,fvisa_serstb_vcfn}                                                         ;
(* inserted_by="VISA IT" *) assign visaSrcClk_i_hqm_visa_mux_top_vcfn[0]        = side_clk                                                                                                        ;
(* inserted_by="VISA IT" *) assign visaSrcClk_i_hqm_visa_repeater_vcfn[0]       = side_clk                                                                                                        ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[0][2:0]} = visaPrbsTo_i_hqm_visa_mux_top_vcfn[2:0] /* hqm_master_visa_lane_0.master_ctl_OVERRIDE_CLK_SWITCH_CONTROL[2:0] */;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[0][4:3]} = visaPrbsTo_i_hqm_visa_mux_top_vcfn[4:3] /* hqm_master_visa_lane_0.master_ctl_OVERRIDE_PMSM_PGCB_REQ_B[1:0] */   ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[0][7:5]} = visaPrbsTo_i_hqm_visa_mux_top_vcfn[7:5] /* hqm_master_visa_lane_0.master_ctl_OVERRIDE_PM_CFG_CONTROL[2:0] */    ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[1][0]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn[8:8] /* hqm_master_visa_lane_0.master_ctl_OVERRIDE_CLK_GATE */               ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[1][1]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn[9:9] /* hqm_master_visa_lane_0.master_ctl_PWRGATE_PMC_WAKE */                ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[1][3:2]} = visaPrbsTo_i_hqm_visa_mux_top_vcfn[11:10] /* hqm_master_visa_lane_0.master_ctl_OVERRIDE_FET_EN_B[1:0] */        ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[1][5:4]} = visaPrbsTo_i_hqm_visa_mux_top_vcfn[13:12] /* hqm_master_visa_lane_0.master_ctl_OVERRIDE_PMC_PGCB_ACK_B[1:0] */  ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[1][6]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn[14:14] /* hqm_master_visa_lane_0.wd_clkreq */                                ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[1][7]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn[15:15] /* hqm_master_visa_lane_0.hqm_cfg_master_clkreq_b */                  ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[2][0]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn[16:16] /* hqm_master_visa_lane_0.side_rst_b */                               ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[2][1]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn[17:17] /* hqm_master_visa_lane_0.prim_gated_rst_b */                         ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[2][2]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn[18:18] /* hqm_master_visa_lane_0.hqm_gated_rst_b */                          ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[2][3]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn[19:19] /* hqm_master_visa_lane_0.hqm_clk_rptr_rst_b */                       ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[2][4]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn[20:20] /* hqm_master_visa_lane_0.hqm_pwrgood_rst_b */                        ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[2][5]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn[21:21] /* hqm_master_visa_lane_0.prochot */                                  ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[2][6]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn[22:22] /* hqm_master_visa_lane_0.pgcb_isol_en_b */                           ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[2][7]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn[23:23] /* hqm_master_visa_lane_0.pgcb_isol_en */                             ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[3][0]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn[24:24] /* hqm_master_visa_lane_0.pgcb_fet_en_b */                            ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[3][1]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn[25:25] /* hqm_master_visa_lane_0.pgcb_fet_en_ack_b */                        ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[3][2]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn[26:26] /* hqm_master_visa_lane_0.pgcb_fet_en_ack_b_sys */                    ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[3][3]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn[27:27] /* hqm_master_visa_lane_0.pgcb_fet_en_ack_b_qed */                    ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[3][4]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn[28:28] /* hqm_master_visa_lane_0.cdc_hqm_jta_force_clkreq */                 ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[3][5]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn[29:29] /* hqm_master_visa_lane_0.cdc_hqm_jta_clkgate_ovrd */                 ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[3][7:6]} = 2'b0 /* filler */                                                                                               ;



`endif // INTEL_GLOBAL_VISA_DISABLE
`endif // __VISA_IT__
