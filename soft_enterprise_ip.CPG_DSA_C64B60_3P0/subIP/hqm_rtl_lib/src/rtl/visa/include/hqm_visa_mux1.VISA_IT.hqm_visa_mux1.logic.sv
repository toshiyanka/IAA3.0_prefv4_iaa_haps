`ifndef __VISA_IT__
`ifndef INTEL_GLOBAL_VISA_DISABLE

(* inserted_by="VISA IT",
   sig_file="/nfs/site/disks/sdg74_3369/users/stepollo/hqm-srvr10nm-wave4-visa2/tools/visa/hqm_visa_mux1.sig",
   visa_it_version="4.3.19",
   probe_ranges_for_src_clk_0="[7:0] /* /hqm/par_hqm_system/hqm_system_aon_wrap/i_hqm_visa/i_hqm_visa_mux1/hqm_fullrate_clk */" *)
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
    .lane_out(avisa_dbgbus1_vcfn),
    .visa_unit_id(9'b0)
);

(* inserted_by="VISA IT",
   sig_file="/nfs/site/disks/sdg74_3369/users/stepollo/hqm-srvr10nm-wave4-visa2/tools/visa/hqm_visa_mux1.sig",
   visa_it_version="4.3.19",
   probe_ranges_for_src_clk_0="[29:0][44:32][50:48][93:56][107:96][125:112][133:128][141:136][150:144][156:152][171:160][182:176][190:184][198:192][206:200][221:208][230:224][233:232][249:240] /* /hqm/par_hqm_system/hqm_system_aon_wrap/i_hqm_visa/i_hqm_visa_mux1/hqm_fullrate_clk */" *)
hqm_visa_unit_mux_cro_s #(
    .SCAN_CLK_INDEX(0),
    .BLACKBOX_MASK(32'b0),
    .NUM_OUTPUT_LANES(1),
    .BUGCOMPAT_MIN_PROTECTION_LATCH(0),
    .NUM_INPUT_CLKS(1),
    .CUST_VIS_TOP_LANE(0),
    .NUM_INPUT_LANES(32),
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
    .visa_unit_id(fvisa_startid1_vcfn)
);

(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux1[ 3: 0]             = cdc_visa_probe.current_state[3:0]                                                                 ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux1[ 4: 4]             = cdc_visa_probe.gclock_active                                                                      ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux1[ 5: 5]             = cdc_visa_probe.clkreq_hold                                                                        ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux1[ 6: 6]             = cdc_visa_probe.gclock_enable                                                                      ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux1[ 7: 7]             = cdc_visa_probe.gclock_req                                                                         ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux1[ 8: 8]             = cdc_visa_probe.do_force_pgate                                                                     ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux1[ 9: 9]             = cdc_visa_probe.timer_expired                                                                      ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux1[10:10]             = cdc_visa_probe.ism_wake                                                                           ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux1[11:11]             = cdc_visa_probe.not_idle                                                                           ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_visa_mux1[12:12]             = cdc_visa_probe.pg_disabled                                                                        ;
(* inserted_by="VISA IT" *) assign visaRt_serial_cfg_in_local                    = {fvisa_serdata_vcfn,fvisa_frame_vcfn,fvisa_serstb_vcfn}                                           ;
(* inserted_by="VISA IT" *) assign visaSrcClk_i_hqm_visa_mux_top_vcfn[0]         = hqm_fullrate_clk                                                                                  ;
(* inserted_by="VISA IT" *) assign visaSrcClk_i_hqm_visa_repeater_vcfn[0]        = hqm_fullrate_clk                                                                                  ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 0][0]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn[0:0] /* hqm_system_visa_struct.sys_ingress_idle */             ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 0][1]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn[1:1] /* hqm_system_visa_struct.sys_egress_idle */              ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 0][2]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn[2:2] /* hqm_system_visa_struct.sys_wbuf_idle */                ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 0][3]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn[3:3] /* hqm_system_visa_struct.sys_cfg_idle */                 ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 0][4]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn[4:4] /* hqm_system_visa_struct.sys_alarm_idle */               ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 0][5]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn[5:5] /* hqm_system_visa_struct.hqm_unit_idle_q_and */          ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 0][6]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn[6:6] /* hqm_system_visa_struct.hqm_idle_q */                   ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 0][7]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn[7:7] /* hqm_system_visa_struct.hqm_idle_q2 */                  ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 1][1:0]} = visaPrbsTo_i_hqm_visa_mux_top_vcfn[9:8] /* hqm_system_visa_struct.msi_msix_w_data_1_0[1:0] */     ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 1][5:2]} = visaPrbsTo_i_hqm_visa_mux_top_vcfn[13:10] /* hqm_system_visa_struct.msi_msix_w_vf[3:0] */         ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 1][6]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn[14:14] /* hqm_system_visa_struct.msi_msix_w_is_pf */           ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 1][7]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn[15:15] /* hqm_system_visa_struct.msi_msix_w_v */               ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 2][5:0]} = visaPrbsTo_i_hqm_visa_mux_top_vcfn[21:16] /* hqm_system_visa_struct.ingress_alarm_aid[5:0] */     ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 2][6]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn[22:22] /* hqm_system_visa_struct.ingress_alarm_v */            ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 2][7]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn[23:23] /* hqm_system_visa_struct.ingress_alarm_v2 */           ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 3][3:0]} = visaPrbsTo_i_hqm_visa_mux_top_vcfn[27:24] /* hqm_system_visa_struct.ingress_alarm_vf[3:0] */      ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 3][4]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn[28:28] /* hqm_system_visa_struct.ingress_alarm_is_pf */        ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 3][5]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn[29:29] /* hqm_system_visa_struct.ingress_alarm_is_ldb_port */  ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 3][7:6]} = 2'b0 /* filler */                                                                                 ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 4][3:0]} = visaPrbsFrom_hqm_visa_mux1[3:0] /* cdc_visa_probe.current_state[3:0] */                           ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 4][4]}   = visaPrbsFrom_hqm_visa_mux1[4:4] /* cdc_visa_probe.gclock_active */                                ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 4][5]}   = visaPrbsFrom_hqm_visa_mux1[5:5] /* cdc_visa_probe.clkreq_hold */                                  ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 4][6]}   = visaPrbsFrom_hqm_visa_mux1[6:6] /* cdc_visa_probe.gclock_enable */                                ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 4][7]}   = visaPrbsFrom_hqm_visa_mux1[7:7] /* cdc_visa_probe.gclock_req */                                   ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 5][0]}   = visaPrbsFrom_hqm_visa_mux1[8:8] /* cdc_visa_probe.do_force_pgate */                               ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 5][1]}   = visaPrbsFrom_hqm_visa_mux1[9:9] /* cdc_visa_probe.timer_expired */                                ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 5][2]}   = visaPrbsFrom_hqm_visa_mux1[10:10] /* cdc_visa_probe.ism_wake */                                   ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 5][3]}   = visaPrbsFrom_hqm_visa_mux1[11:11] /* cdc_visa_probe.not_idle */                                   ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 5][4]}   = visaPrbsFrom_hqm_visa_mux1[12:12] /* cdc_visa_probe.pg_disabled */                                ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 5][7:5]} = 3'b0 /* filler */                                                                                 ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 6][0]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[0:0] /* visa_capture_reg_f.core_gated_rst_b */               ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 6][1]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[1:1] /* visa_capture_reg_f.constant_one */                   ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 6][2]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[2:2] /* visa_capture_reg_f.rop_qed_force_clockon */          ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 6][7:3]} = 5'b0 /* filler */                                                                                 ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 7][0]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[3:3] /* visa_capture_reg_f.prim_clk_enable */                ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 7][1]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[4:4] /* visa_capture_reg_f.hqm_clk_enable */                 ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 7][2]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[5:5] /* visa_capture_reg_f.hqm_clk_throttle */               ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 7][3]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[6:6] /* visa_capture_reg_f.hqm_gclock_enable */              ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 7][4]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[7:7] /* visa_capture_reg_f.hqm_cdc_clk_enable */             ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 7][5]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[8:8] /* visa_capture_reg_f.hqm_gated_local_override */       ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 7][6]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[9:9] /* visa_capture_reg_f.hqm_flr_prep */                   ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 7][7]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[10:10] /* visa_capture_reg_f.pm_ip_clk_halt_b_2_rpt_0_iosf */;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 8][0]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[0:0] /* visa_capture_reg_f.core_gated_rst_b */               ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 8][1]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[11:11] /* visa_capture_reg_f.hqm_alarm_ready */              ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 8][2]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[12:12] /* visa_capture_reg_f.hqm_alarm_v */                  ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 8][3]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[13:13] /* visa_capture_reg_f.hqm_unit_pipeidle */            ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 8][4]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[14:14] /* visa_capture_reg_f.hqm_unit_idle */                ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 8][5]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[15:15] /* visa_capture_reg_f.hqm_proc_reset_done */          ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 8][6]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[16:16] /* visa_capture_reg_f.sys_unit_idle */                ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 8][7]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[17:17] /* visa_capture_reg_f.sys_reset_done */               ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 9][0]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[18:18] /* visa_capture_reg_f.aqed_unit_pipeidle */           ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 9][1]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[19:19] /* visa_capture_reg_f.qed_unit_pipeidle */            ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 9][2]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[20:20] /* visa_capture_reg_f.dp_unit_pipeidle */             ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 9][3]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[21:21] /* visa_capture_reg_f.ap_unit_pipeidle */             ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 9][4]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[22:22] /* visa_capture_reg_f.nalb_unit_pipeidle */           ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 9][5]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[23:23] /* visa_capture_reg_f.lsp_unit_pipeidle */            ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 9][6]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[24:24] /* visa_capture_reg_f.rop_unit_pipeidle */            ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[ 9][7]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[25:25] /* visa_capture_reg_f.chp_unit_pipeidle */            ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[10][0]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[26:26] /* visa_capture_reg_f.aqed_unit_idle */               ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[10][1]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[27:27] /* visa_capture_reg_f.qed_unit_idle */                ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[10][2]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[28:28] /* visa_capture_reg_f.dp_unit_idle */                 ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[10][3]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[29:29] /* visa_capture_reg_f.ap_unit_idle */                 ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[10][4]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[30:30] /* visa_capture_reg_f.nalb_unit_idle */               ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[10][5]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[31:31] /* visa_capture_reg_f.lsp_unit_idle */                ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[10][6]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[32:32] /* visa_capture_reg_f.rop_unit_idle */                ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[10][7]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[33:33] /* visa_capture_reg_f.chp_unit_idle */                ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[11][0]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[34:34] /* visa_capture_reg_f.sys_hqm_proc_clk_en */          ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[11][1]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[35:35] /* visa_capture_reg_f.nalb_hqm_proc_clk_en */         ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[11][2]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[36:36] /* visa_capture_reg_f.dp_hqm_proc_clk_en */           ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[11][3]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[37:37] /* visa_capture_reg_f.qed_hqm_proc_clk_en */          ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[11][4]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[38:38] /* visa_capture_reg_f.lsp_hqm_proc_clk_en */          ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[11][5]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[39:39] /* visa_capture_reg_f.chp_hqm_proc_clk_en */          ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[11][7:6]} = 2'b0 /* filler */                                                                                 ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[12][0]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[40:40] /* visa_capture_reg_f.aqed_reset_done */              ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[12][1]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[41:41] /* visa_capture_reg_f.qed_reset_done */               ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[12][2]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[42:42] /* visa_capture_reg_f.dp_reset_done */                ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[12][3]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[43:43] /* visa_capture_reg_f.ap_reset_done */                ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[12][4]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[44:44] /* visa_capture_reg_f.nalb_reset_done */              ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[12][5]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[45:45] /* visa_capture_reg_f.lsp_reset_done */               ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[12][6]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[46:46] /* visa_capture_reg_f.rop_reset_done */               ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[12][7]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[47:47] /* visa_capture_reg_f.chp_reset_done */               ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[13][0]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[48:48] /* visa_capture_reg_f.cwdi_interrupt_w_req_ready */   ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[13][1]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[49:49] /* visa_capture_reg_f.cwdi_interrupt_w_req_valid */   ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[13][2]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[50:50] /* visa_capture_reg_f.interrupt_w_req_ready */        ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[13][3]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[51:51] /* visa_capture_reg_f.interrupt_w_req_valid */        ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[13][7:4]} = 4'b0 /* filler */                                                                                 ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[14][0]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[52:52] /* visa_capture_reg_f.aqed_chp_sch_ready */           ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[14][1]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[53:53] /* visa_capture_reg_f.aqed_chp_sch_v */               ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[14][2]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[54:54] /* visa_capture_reg_f.aqed_ap_enq_ready */            ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[14][3]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[55:55] /* visa_capture_reg_f.aqed_ap_enq_v */                ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[14][4]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[56:56] /* visa_capture_reg_f.aqed_lsp_sch_ready */           ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[14][5]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[57:57] /* visa_capture_reg_f.aqed_lsp_sch_v */               ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[14][6]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[58:58] /* visa_capture_reg_f.qed_aqed_enq_ready */           ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[14][7]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[59:59] /* visa_capture_reg_f.qed_aqed_enq_v */               ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[15][0]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[60:60] /* visa_capture_reg_f.qed_chp_sch_ready */            ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[15][1]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[61:61] /* visa_capture_reg_f.qed_chp_sch_v */                ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[15][2]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[62:62] /* visa_capture_reg_f.ap_aqed_ready */                ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[15][3]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[63:63] /* visa_capture_reg_f.ap_aqed_v */                    ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[15][4]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[64:64] /* visa_capture_reg_f.dp_lsp_enq_dir_ready */         ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[15][5]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[65:65] /* visa_capture_reg_f.dp_lsp_enq_dir_v */             ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[15][7:6]} = 2'b0 /* filler */                                                                                 ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[16][0]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[66:66] /* visa_capture_reg_f.nalb_lsp_enq_lb_ready */        ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[16][1]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[67:67] /* visa_capture_reg_f.nalb_lsp_enq_lb_v */            ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[16][2]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[68:68] /* visa_capture_reg_f.lsp_nalb_sch_atq_ready */       ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[16][3]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[69:69] /* visa_capture_reg_f.lsp_nalb_sch_atq_v */           ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[16][4]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[70:70] /* visa_capture_reg_f.lsp_dp_sch_rorply_ready */      ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[16][5]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[71:71] /* visa_capture_reg_f.lsp_dp_sch_rorply_v */          ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[16][7:6]} = 2'b0 /* filler */                                                                                 ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[17][0]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[72:72] /* visa_capture_reg_f.lsp_nalb_sch_rorply_ready */    ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[17][1]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[73:73] /* visa_capture_reg_f.lsp_nalb_sch_rorply_v */        ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[17][2]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[74:74] /* visa_capture_reg_f.lsp_dp_sch_dir_ready */         ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[17][3]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[75:75] /* visa_capture_reg_f.lsp_dp_sch_dir_v */             ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[17][4]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[76:76] /* visa_capture_reg_f.lsp_nalb_sch_unoord_ready */    ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[17][5]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[77:77] /* visa_capture_reg_f.lsp_nalb_sch_unoord_v */        ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[17][7:6]} = 2'b0 /* filler */                                                                                 ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[18][0]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[78:78] /* visa_capture_reg_f.rop_dqed_enq_ready */           ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[18][1]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[79:79] /* visa_capture_reg_f.rop_qed_enq_ready */            ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[18][2]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[80:80] /* visa_capture_reg_f.rop_qed_dqed_enq_v */           ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[18][3]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[81:81] /* visa_capture_reg_f.rop_nalb_enq_ready */           ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[18][4]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[82:82] /* visa_capture_reg_f.rop_nalb_enq_v */               ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[18][5]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[83:83] /* visa_capture_reg_f.rop_dp_enq_ready */             ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[18][6]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[84:84] /* visa_capture_reg_f.rop_dp_enq_v */                 ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[18][7]}   = 1'b0 /* filler */                                                                                 ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[19][0]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[85:85] /* visa_capture_reg_f.chp_lsp_token_ready */          ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[19][1]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[86:86] /* visa_capture_reg_f.chp_lsp_token_v */              ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[19][2]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[87:87] /* visa_capture_reg_f.chp_lsp_cmp_ready */            ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[19][3]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[88:88] /* visa_capture_reg_f.chp_lsp_cmp_v */                ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[19][4]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[89:89] /* visa_capture_reg_f.chp_lsp_cmp_data */             ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[19][7:5]} = 3'b0 /* filler */                                                                                 ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[20][0]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[90:90] /* visa_capture_reg_f.chp_rop_hcw_ready */            ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[20][1]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[91:91] /* visa_capture_reg_f.chp_rop_hcw_v */                ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[20][2]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[92:92] /* visa_capture_reg_f.hcw_enq_w_req_ready */          ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[20][3]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[93:93] /* visa_capture_reg_f.hcw_enq_w_req_valid */          ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[20][4]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[94:94] /* visa_capture_reg_f.hcw_sched_w_req_ready */        ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[20][5]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[95:95] /* visa_capture_reg_f.hcw_sched_w_req_valid */        ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[20][6]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[96:96] /* visa_capture_reg_f.rop_lsp_reordercmp_ready */     ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[20][7]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[97:97] /* visa_capture_reg_f.rop_lsp_reordercmp_v */         ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[21][0]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[98:98] /* visa_capture_reg_f.dp_lsp_enq_rorply_ready */      ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[21][1]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[99:99] /* visa_capture_reg_f.dp_lsp_enq_rorply_v */          ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[21][2]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[100:100] /* visa_capture_reg_f.nalb_lsp_enq_rorply_ready */  ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[21][3]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[101:101] /* visa_capture_reg_f.nalb_lsp_enq_rorply_v */      ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[21][7:4]} = 4'b0 /* filler */                                                                                 ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[22][0]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[102:102] /* visa_capture_reg_f.aqed_cfg_req_down_write */    ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[22][1]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[103:103] /* visa_capture_reg_f.aqed_cfg_req_down_read */     ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[22][3:2]} = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[105:104] /* visa_capture_reg_f.aqed_cfg_req_down[1:0] */     ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[22][4]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[106:106] /* visa_capture_reg_f.aqed_cfg_rsp_down_ack */      ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[22][6:5]} = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[108:107] /* visa_capture_reg_f.aqed_cfg_rsp_down[1:0] */     ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[22][7]}   = 1'b0 /* filler */                                                                                 ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[23][0]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[109:109] /* visa_capture_reg_f.qed_cfg_req_down_write */     ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[23][1]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[110:110] /* visa_capture_reg_f.qed_cfg_req_down_read */      ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[23][3:2]} = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[112:111] /* visa_capture_reg_f.qed_cfg_req_down[1:0] */      ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[23][4]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[113:113] /* visa_capture_reg_f.qed_cfg_rsp_down_ack */       ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[23][6:5]} = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[115:114] /* visa_capture_reg_f.qed_cfg_rsp_down[1:0] */      ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[23][7]}   = 1'b0 /* filler */                                                                                 ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[24][0]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[116:116] /* visa_capture_reg_f.ap_cfg_req_down_write */      ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[24][1]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[117:117] /* visa_capture_reg_f.ap_cfg_req_down_read */       ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[24][3:2]} = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[119:118] /* visa_capture_reg_f.ap_cfg_req_down[1:0] */       ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[24][4]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[120:120] /* visa_capture_reg_f.ap_cfg_rsp_down_ack */        ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[24][6:5]} = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[122:121] /* visa_capture_reg_f.ap_cfg_rsp_down[1:0] */       ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[24][7]}   = 1'b0 /* filler */                                                                                 ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[25][0]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[123:123] /* visa_capture_reg_f.lsp_cfg_req_down_write */     ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[25][1]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[124:124] /* visa_capture_reg_f.lsp_cfg_req_down_read */      ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[25][3:2]} = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[126:125] /* visa_capture_reg_f.lsp_cfg_req_down[1:0] */      ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[25][4]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[127:127] /* visa_capture_reg_f.lsp_cfg_rsp_down_ack */       ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[25][6:5]} = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[129:128] /* visa_capture_reg_f.lsp_cfg_rsp_down[1:0] */      ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[25][7]}   = 1'b0 /* filler */                                                                                 ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[26][0]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[130:130] /* visa_capture_reg_f.rop_cfg_req_down_write */     ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[26][1]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[131:131] /* visa_capture_reg_f.rop_cfg_req_down_read */      ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[26][3:2]} = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[133:132] /* visa_capture_reg_f.rop_cfg_req_down[1:0] */      ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[26][4]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[134:134] /* visa_capture_reg_f.rop_cfg_rsp_down_ack */       ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[26][6:5]} = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[136:135] /* visa_capture_reg_f.rop_cfg_rsp_down[1:0] */      ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[26][7]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[137:137] /* visa_capture_reg_f.chp_cfg_req_down_write */     ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[27][0]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[138:138] /* visa_capture_reg_f.chp_cfg_req_down_read */      ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[27][2:1]} = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[140:139] /* visa_capture_reg_f.chp_cfg_req_down[1:0] */      ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[27][3]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[141:141] /* visa_capture_reg_f.chp_cfg_rsp_down_ack */       ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[27][5:4]} = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[143:142] /* visa_capture_reg_f.chp_cfg_rsp_down[1:0] */      ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[27][7:6]} = 2'b0 /* filler */                                                                                 ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[28][0]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[144:144] /* visa_capture_reg_f.mstr_cfg_req_down_write */    ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[28][1]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[145:145] /* visa_capture_reg_f.mstr_cfg_req_down_read */     ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[28][3:2]} = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[147:146] /* visa_capture_reg_f.mstr_cfg_req_down[1:0] */     ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[28][4]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[148:148] /* visa_capture_reg_f.mstr_cfg_rsp_down_ack */      ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[28][6:5]} = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[150:149] /* visa_capture_reg_f.mstr_cfg_rsp_down[1:0] */     ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[28][7]}   = 1'b0 /* filler */                                                                                 ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[29][0]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[151:151] /* visa_capture_reg_f.aqed_lsp_deq_v */             ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[29][1]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[152:152] /* visa_capture_reg_f.qed_lsp_deq_v */              ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[29][7:2]} = 6'b0 /* filler */                                                                                 ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[30][0]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[153:153] /* visa_capture_reg_f.rop_alarm_up_ready */         ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[30][1]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[154:154] /* visa_capture_reg_f.qed_alarm_down_v */           ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[30][2]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[155:155] /* visa_capture_reg_f.ap_alarm_up_ready */          ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[30][3]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[156:156] /* visa_capture_reg_f.aqed_alarm_down_v */          ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[30][4]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[157:157] /* visa_capture_reg_f.ap_alarm_down_ready */        ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[30][5]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[158:158] /* visa_capture_reg_f.ap_alarm_down_v */            ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[30][6]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[159:159] /* visa_capture_reg_f.lsp_alarm_down_ready */       ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[30][7]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[160:160] /* visa_capture_reg_f.lsp_alarm_down_v */           ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[31][0]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[161:161] /* visa_capture_reg_f.rop_alarm_down_ready */       ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[31][1]}   = visaPrbsTo_i_hqm_visa_mux_top_vcfn_1[162:162] /* visa_capture_reg_f.rop_alarm_down_v */           ;
(* inserted_by="VISA IT" *) assign {visaLaneIn_i_hqm_visa_mux_top_vcfn[31][7:2]} = 6'b0 /* filler */                                                                                 ;



`endif // INTEL_GLOBAL_VISA_DISABLE
`endif // __VISA_IT__
