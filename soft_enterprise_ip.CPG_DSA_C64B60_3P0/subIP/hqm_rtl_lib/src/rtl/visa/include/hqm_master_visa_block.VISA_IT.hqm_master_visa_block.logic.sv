`ifndef __VISA_IT__
`ifndef INTEL_GLOBAL_VISA_DISABLE

(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_master_visa_block[ 2: 0] = hqm_master_visa_lane_0.master_ctl_OVERRIDE_CLK_SWITCH_CONTROL[2:0];
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_master_visa_block[ 4: 3] = hqm_master_visa_lane_0.master_ctl_OVERRIDE_PMSM_PGCB_REQ_B[1:0]   ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_master_visa_block[ 7: 5] = hqm_master_visa_lane_0.master_ctl_OVERRIDE_PM_CFG_CONTROL[2:0]    ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_master_visa_block[ 8: 8] = hqm_master_visa_lane_0.master_ctl_OVERRIDE_CLK_GATE               ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_master_visa_block[ 9: 9] = hqm_master_visa_lane_0.master_ctl_PWRGATE_PMC_WAKE                ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_master_visa_block[11:10] = hqm_master_visa_lane_0.master_ctl_OVERRIDE_FET_EN_B[1:0]          ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_master_visa_block[13:12] = hqm_master_visa_lane_0.master_ctl_OVERRIDE_PMC_PGCB_ACK_B[1:0]    ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_master_visa_block[14:14] = hqm_master_visa_lane_0.wd_clkreq                                  ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_master_visa_block[15:15] = hqm_master_visa_lane_0.hqm_cfg_master_clkreq_b                    ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_master_visa_block[16:16] = hqm_master_visa_lane_0.side_rst_b                                 ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_master_visa_block[17:17] = hqm_master_visa_lane_0.prim_gated_rst_b                           ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_master_visa_block[18:18] = hqm_master_visa_lane_0.hqm_gated_rst_b                            ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_master_visa_block[19:19] = hqm_master_visa_lane_0.hqm_clk_rptr_rst_b                         ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_master_visa_block[20:20] = hqm_master_visa_lane_0.hqm_pwrgood_rst_b                          ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_master_visa_block[21:21] = hqm_master_visa_lane_0.prochot                                    ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_master_visa_block[22:22] = hqm_master_visa_lane_0.pgcb_isol_en_b                             ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_master_visa_block[23:23] = hqm_master_visa_lane_0.pgcb_isol_en                               ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_master_visa_block[24:24] = hqm_master_visa_lane_0.pgcb_fet_en_b                              ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_master_visa_block[25:25] = hqm_master_visa_lane_0.pgcb_fet_en_ack_b                          ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_master_visa_block[26:26] = hqm_master_visa_lane_0.pgcb_fet_en_ack_b_sys                      ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_master_visa_block[27:27] = hqm_master_visa_lane_0.pgcb_fet_en_ack_b_qed                      ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_master_visa_block[28:28] = hqm_master_visa_lane_0.cdc_hqm_jta_force_clkreq                   ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_master_visa_block[29:29] = hqm_master_visa_lane_0.cdc_hqm_jta_clkgate_ovrd                   ;
(* inserted_by="VISA IT" *) assign visaRt_probe_from_i_hqm_master_visa_block = visaPrbsFrom_hqm_master_visa_block                                ;



`endif // INTEL_GLOBAL_VISA_DISABLE
`endif // __VISA_IT__
