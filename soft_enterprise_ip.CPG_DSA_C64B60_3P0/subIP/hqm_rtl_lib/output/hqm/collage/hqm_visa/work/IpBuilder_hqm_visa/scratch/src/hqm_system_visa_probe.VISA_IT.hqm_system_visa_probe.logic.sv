`ifndef __VISA_IT__
`ifndef INTEL_GLOBAL_VISA_DISABLE

(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_system_visa_probe[ 0: 0] = hqm_system_visa_struct.sys_ingress_idle         ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_system_visa_probe[ 1: 1] = hqm_system_visa_struct.sys_egress_idle          ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_system_visa_probe[ 2: 2] = hqm_system_visa_struct.sys_wbuf_idle            ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_system_visa_probe[ 3: 3] = hqm_system_visa_struct.sys_cfg_idle             ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_system_visa_probe[ 4: 4] = hqm_system_visa_struct.sys_alarm_idle           ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_system_visa_probe[ 5: 5] = hqm_system_visa_struct.hqm_unit_idle_q_and      ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_system_visa_probe[ 6: 6] = hqm_system_visa_struct.hqm_idle_q               ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_system_visa_probe[ 7: 7] = hqm_system_visa_struct.hqm_idle_q2              ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_system_visa_probe[ 9: 8] = hqm_system_visa_struct.msi_msix_w_data_1_0[1:0] ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_system_visa_probe[13:10] = hqm_system_visa_struct.msi_msix_w_vf[3:0]       ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_system_visa_probe[14:14] = hqm_system_visa_struct.msi_msix_w_is_pf         ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_system_visa_probe[15:15] = hqm_system_visa_struct.msi_msix_w_v             ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_system_visa_probe[21:16] = hqm_system_visa_struct.ingress_alarm_aid[5:0]   ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_system_visa_probe[22:22] = hqm_system_visa_struct.ingress_alarm_v          ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_system_visa_probe[23:23] = hqm_system_visa_struct.ingress_alarm_v2         ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_system_visa_probe[27:24] = hqm_system_visa_struct.ingress_alarm_vf[3:0]    ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_system_visa_probe[28:28] = hqm_system_visa_struct.ingress_alarm_is_pf      ;
(* inserted_by="VISA IT" *) assign visaPrbsFrom_hqm_system_visa_probe[29:29] = hqm_system_visa_struct.ingress_alarm_is_ldb_port;
(* inserted_by="VISA IT" *) assign visaRt_probe_from_i_hqm_system_visa_probe = visaPrbsFrom_hqm_system_visa_probe              ;



`endif // INTEL_GLOBAL_VISA_DISABLE
`endif // __VISA_IT__
