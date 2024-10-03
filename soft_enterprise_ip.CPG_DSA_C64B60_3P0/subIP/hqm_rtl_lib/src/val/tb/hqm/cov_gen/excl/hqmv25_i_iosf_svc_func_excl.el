//==================================================
// This file contains the Excluded objects
// Generated By User: araghuw
// Format Version: 2
// Date: Wed Apr 15 03:30:58 2020
// ExclMode: default
//==================================================
CHECKSUM: "1212695230 203734115"
covergroup hqm_tb_top.iosf_sbc_fabric_if::target_vr_sbc_0145
	coveritem "tnpput"
		ANNOTATION: "bcast mcast is not supported by HQMV25"
		bins "tnpput_1"
	coveritem "cross_tnpcup_tnpput"
		bins {{"tnpcup_1","tnpcup_0"}, {"tnpput_1"}}
CHECKSUM: "1356046203 1152059208"
covergroup hqm_tb_top.iosf_sbc_fabric_if::vr_sbc_0217_agent
	coveritem "idle_sm_state"
		ANNOTATION: "No credit-reinit in HQMV25"
		bins "ip_active_req_2_credit_req"
CHECKSUM: "1465246732 3246996596"
covergroup hqm_tb_top.iosf_sbc_fabric_if::vr_sbc_0224_tnpput_ism_fabric
	coveritem "tnpput"
		ANNOTATION: "No NP request issued by HQM."
		bins "tnpput_1"
	coveritem "cross_tnpput_ism"
		bins {{"fabric_idle_nak","fabric_active","fabric_active_req"}, {"tnpput_1"}}
CHECKSUM: "2125972385 719047204"
covergroup hqm_tb_top.iosf_sbc_fabric_if::vr_sbc_0219_fabric
	coveritem "idle_sm_state"
		ANNOTATION: "No credit re-init for HQMV25"
		bins "fabric_active_req_2_credit_req"
CHECKSUM: "2740339606 1005202798"
covergroup hqm_tb_top.iosf_sbc_fabric_if::master_vr_sbc_0144
	coveritem "mpc_credit"
		ANNOTATION: "Per input from Steve, to be excluded"
		bins "mpc_crd_one_to_one"
CHECKSUM: "2804009800 3186147321"
covergroup hqm_tb_top.iosf_sbc_fabric_if::vr_sbc_0221_mpccup_ism_agent
	coveritem "cross_mpccup_ism"
		ANNOTATION: "Per input from Steve, to be excluded"
		bins {{"ip_credit_done"}, {"mpccup_1"}}, {{"ip_idle_req"}, {"mpccup_1"}}
CHECKSUM: "3023041333 1602064674"
covergroup hqm_tb_top.iosf_sbc_fabric_if::master_vr_sbc_0143
	coveritem "mnp_credit"
		ANNOTATION: "Per input from Steve, to be excluded"
		bins "mnp_crd_one_to_one"
CHECKSUM: "3475055202 726173007"
covergroup hqm_tb_top.iosf_sbc_fabric_if::vr_sbc_0224_tpccup_ism_fabric
	coveritem "cross_tpccup_ism"
		ANNOTATION: "Per input from Steve, to be excluded"
		bins {{"fabric_active_req"}, {"tpccup_1"}}
CHECKSUM: "3533388925 1289559554"
covergroup hqm_tb_top.iosf_sbc_fabric_if::vr_sbc_0221_mnpcup_ism_agent
	coveritem "cross_mnpcup_ism"
		ANNOTATION: "Per input from Steve, to be excluded"
		bins {{"ip_credit_done"}, {"mnpcup_1"}}, {{"ip_idle_req"}, {"mnpcup_1"}}
CHECKSUM: "381675568 3665634484"
covergroup hqm_tb_top.iosf_sbc_fabric_if::vr_sbc_0224_tnpcup_ism_fabric
	coveritem "cross_tnpcup_ism"
		ANNOTATION: "Per input from Steve, to be excluded"
		bins {{"fabric_idle_nak","fabric_active","fabric_active_req"}, {"tnpcup_1"}}
CHECKSUM: "1329418915 3488828302"
covergroup SIP_SHARED_LIB.iosfsbm_cm::xaction_cov::vr_sbc_0196
	coveritem "msg_w_data"
		ANNOTATION: "Invalid commands for HQM V25"
		bins "op_syncstartcmd", "op_pci_pm", "op_pm_dmd"
	coveritem "simple_msg"
		ANNOTATION: "Invalid commands for HQM V25"
		bins "op_deassert_intd", "op_deassert_intc", "op_deassert_intb", "op_deassert_inta", "op_assert_intd", "op_assert_intc", "op_assert_intb", "op_assert_inta"
CHECKSUM: "1425693351 2325287371"
covergroup SIP_SHARED_LIB.iosfsbm_cm::xaction_cov::vr_sbc_0303
CHECKSUM: "1590107805 3507179088"
covergroup SIP_SHARED_LIB.iosfsbm_cm::xaction_cov::vr_sbc_0137
	coveritem "PID"
		bins "PID_C0_FD", "PID_80_BF", "PID_40_7F"
CHECKSUM: "1632935735 406857317"
covergroup SIP_SHARED_LIB.iosfsbm_cm::xaction_cov::vr_sbc_0195
	coveritem "cmpd_access"
	coveritem "length"
		ANNOTATION: "Invalid commands for HQM V25"
		bins "dw_2"
CHECKSUM: "1632935735 406857317"
covergroup "SIP_SHARED_LIB.iosfsbm_cm.vrf_0195_iosf_sbc_fabric_if_RX"
	coveritem "cmpd_access"
CHECKSUM: "1632935735 406857317"
covergroup "SIP_SHARED_LIB.iosfsbm_cm.vrf_0195_iosf_sbc_fabric_if_TX"
	coveritem "cmpd_access"
CHECKSUM: "1869598669 3471597456"
covergroup SIP_SHARED_LIB.iosfsbm_cm::xaction_cov::vr_sbc_0305
CHECKSUM: "2536721822 2654288729"
covergroup SIP_SHARED_LIB.iosfsbm_cm::xaction_cov::vr_sbc_0198_spec1_2
	coveritem "msg_w_data"
		ANNOTATION: "Invalid commands for HQM V25"
		bins "op_qos_rsp", "op_qos_dmd", "op_sleep_rsp", "op_sleep_req", "op_pm_rsp"
	coveritem "msg_w_data_all"
		bins {{"p"}, {"op_qos_rsp","op_qos_dmd","op_sleep_rsp","op_sleep_req","op_pm_rsp"}}
CHECKSUM: "273088897 1310446483"
covergroup SIP_SHARED_LIB.iosfsbm_cm::xaction_cov::vr_sbc_0190
	coveritem "write"
		bins {{"op_crwr","op_cfgwr","op_iowr","op_mwr"}, {"dw_3"}}
CHECKSUM: "273088897 1310446483"
covergroup "SIP_SHARED_LIB.iosfsbm_cm.vrf_0190_iosf_sbc_fabric_if_RX"
	coveritem "write"
		ANNOTATION: "Invalid commands for HQM V25"
		bins {{"op_crwr","op_cfgwr","op_iowr","op_mwr"}, {"dw_3"}}
CHECKSUM: "2761486639 1489323996"
covergroup SIP_SHARED_LIB.iosfsbm_cm::xaction_cov::vr_sbc_0216
CHECKSUM: "3538996314 1697403266"
covergroup SIP_SHARED_LIB.iosfsbm_cm::xaction_cov::vr_sbc_0309_a
	coveritem "posted_bcast_xaction"
	coveritem "nonposted_bcast_xaction"
		ANNOTATION: "BCAST not supported"
		bins "nonposted_gt_one_bcast"
CHECKSUM: "3538996314 1697403266"
covergroup "SIP_SHARED_LIB.iosfsbm_cm.vrf_0309_a_iosf_sbc_fabric_if_RX"
	coveritem "posted_bcast_xaction"
	coveritem "nonposted_bcast_xaction"
		ANNOTATION: "BCAST not supported"
		bins "nonposted_gt_one_bcast"
CHECKSUM: "3538996314 1697403266"
covergroup "SIP_SHARED_LIB.iosfsbm_cm.vrf_0309_a_iosf_sbc_fabric_if_TX"
	coveritem "posted_bcast_xaction"
CHECKSUM: "3706015297 100285273"
covergroup SIP_SHARED_LIB.iosfsbm_cm::xaction_cov::vr_sbc_0169
	coveritem "all_types"
		ANNOTATION: "Invalid commands for HQM V25"
		bins "op_deassert_intd", "op_deassert_intc", "op_deassert_intb", "op_deassert_inta", "op_assert_intd", "op_assert_intc", "op_assert_intb", "op_assert_inta", "op_pci_pm", "op_pm_dmd", "op_bulk_wr", "op_bulk_rd"
CHECKSUM: "3706015297 100285273"
covergroup "SIP_SHARED_LIB.iosfsbm_cm.vrf_0169_iosf_sbc_fabric_if_RX"
	coveritem "all_types"
		ANNOTATION: "Invalid commands for HQM V25"
		bins "op_pci_error"
CHECKSUM: "3706015297 100285273"
covergroup "SIP_SHARED_LIB.iosfsbm_cm.vrf_0169_iosf_sbc_fabric_if_TX"
	coveritem "all_types"
		bins "op_pm_req", "op_crwr", "op_cfgwr", "op_iowr", "op_mwr", "op_crrd", "op_cfgrd", "op_iord", "op_mrd"
CHECKSUM: "3983045735 3680622888"
covergroup SIP_SHARED_LIB.iosfsbm_cm::xaction_cov::vr_sbc_0183
	coveritem "all_fbe"
		ANNOTATION: "bcast mcast is not supported by HQMV25"
		bins {{"op_cfgwr"}, {auto[5]}}
CHECKSUM: "3983045735 3680622888"
covergroup "SIP_SHARED_LIB.iosfsbm_cm.vrf_0183_iosf_sbc_fabric_if_RX"
	coveritem "all_fbe"
		ANNOTATION: "Invalid commands for HQM V25"
		bins {{"op_cfgwr"}, {auto[5]}}
CHECKSUM: "486302997 3282253198"
covergroup SIP_SHARED_LIB.iosfsbm_cm::xaction_cov::vr_sbc_0309_b
	coveritem "posted_mcast_xaction"
	coveritem "nonposted_mcast_xaction"
		ANNOTATION: "MCAST not supported"
		bins "nonposted_gt_one_mcast"
CHECKSUM: "486302997 3282253198"
covergroup "SIP_SHARED_LIB.iosfsbm_cm.vrf_0309_b_iosf_sbc_fabric_if_RX"
	coveritem "posted_mcast_xaction"
CHECKSUM: "486302997 3282253198"
covergroup "SIP_SHARED_LIB.iosfsbm_cm.vrf_0309_b_iosf_sbc_fabric_if_TX"
	coveritem "posted_mcast_xaction"
CHECKSUM: "2182433168 2177586801"
covergroup SIP_SHARED_LIB.iosfsbm_cm::xaction_cov::vr_sbc_0194
	coveritem "all"
		bins {{"op_cmp"}, {"rsp_powereddown"}}
CHECKSUM: "3106722225 3650012541"
covergroup SIP_SHARED_LIB.iosfsbm_cm::xaction_cov::vr_sbc_0161
	coveritem "not_supported"
		bins {{"op_cmp"}, {"rsp_powereddown"}}
