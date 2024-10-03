CHECKSUM: "1356046203 1152059208"
covergroup hqm_tb_top.iosf_sbc_fabric_if::vr_sbc_0217_agent
	coveritem "idle_sm_state"
		ANNOTATION: " No credit re-init. Can be excluded "
		bins "ip_active_req_2_credit_req"
CHECKSUM: "1465246732 3246996596"
covergroup hqm_tb_top.iosf_sbc_fabric_if::vr_sbc_0224_tnpput_ism_fabric
	coveritem "cross_tnpput_ism"
		ANNOTATION: " The hqm doesn?t generate NP transactions other than the fuse pull request, so the NP crosses can be excluded "
		bins {{"fabric_idle_nak"}, {"tnpput_1"}}
CHECKSUM: "2125972385 719047204"
covergroup hqm_tb_top.iosf_sbc_fabric_if::vr_sbc_0219_fabric
	coveritem "idle_sm_state"
		ANNOTATION: " No credit re-init. Can be excluded "
		bins "fabric_active_req_2_credit_req"
CHECKSUM: "2740339606 1005202798"
covergroup hqm_tb_top.iosf_sbc_fabric_if::master_vr_sbc_0144
	coveritem "mpc_credit"
		ANNOTATION: " As per Steve's comments, Max_to_zero requires credit reinit so can be excluded "
		bins "mpc_crd_max_to_zero"
CHECKSUM: "3023041333 1602064674"
covergroup hqm_tb_top.iosf_sbc_fabric_if::master_vr_sbc_0143
	coveritem "mnp_credit"
		ANNOTATION: " As per Steve's comments, Max_to_zero requires credit reinit so can be excluded "
		bins "mnp_crd_max_to_zero"
CHECKSUM: "381675568 3665634484"
covergroup hqm_tb_top.iosf_sbc_fabric_if::vr_sbc_0224_tnpcup_ism_fabric
	coveritem "cross_tnpcup_ism"
		bins {{"fabric_idle_nak"}, {"tnpcup_1"}}, {{"fabric_active_req"}, {"tnpcup_1"}}
CHECKSUM: "776140346 3617237279"
covergroup hqm_tb_top.iosf_sbc_fabric_if::vr_sbc_0225_powergating
	coveritem "cross_fbrc_ism_pok"
		bins "fbrc_credit_req_pok0"
		ANNOTATION: " The uncovered bins are cross between  side_pok = 0 and all the ISM states. When side_pok is 0, I believe ISM will be at IDLE state only. So these crosses  between other states and side_pok_0 can be excluded.   "
		bins {{"fabric_credit_ack"}, {"side_pok_0"}}, {{"fabric_credit_init","fabric_idle_nak"}, {"side_pok_0"}}
	coveritem "cross_agnt_ism_pok"
		bins {{"ip_credit_req","ip_credit_done","ip_credit_init","ip_active_req"}, {"side_pok_0"}}, {{"ip_idle_req","ip_active"}, {"side_pok_0"}}
CHECKSUM: "1329418915 801936016"
covergroup iosfsbm_cm::xaction_cov::vr_sbc_0196
	coveritem "msg_w_data"
		bins "op_syncstartcmd", "op_pci_pm", "op_pm_rsp", "op_pm_dmd"
	coveritem "simple_msg"
		ANNOTATION: " These opcodes are not supported by HQM V2 "
		bins "op_deassert_intd", "op_deassert_intc", "op_deassert_intb", "op_deassert_inta", "op_assert_intd", "op_assert_intc", "op_assert_intb", "op_assert_inta"
CHECKSUM: "1425693351 2325287371"
ANNOTATION: " As per Steve's comments, we can exclude CGs related to bcast/mcast "
covergroup iosfsbm_cm::xaction_cov::vr_sbc_0303
CHECKSUM: "1632935735 406857317"
covergroup iosfsbm_cm::xaction_cov::vr_sbc_0195
	coveritem "cmpd_access"
		ANNOTATION: " Completion with dw = 2/3 not supported "
		bins {{"op_cmpd"}, {"dw_2"}}
CHECKSUM: "1869598669 3471597456"
ANNOTATION: " As per Steve's comment, we can exclude loopback transaction "
covergroup iosfsbm_cm::xaction_cov::vr_sbc_0305
CHECKSUM: "2182433168 2177586801"
covergroup iosfsbm_cm::xaction_cov::vr_sbc_0194
	coveritem "rsp"
		ANNOTATION: " These responses are not supported by HQM V2 "
		bins "rsp_mcastmixed", "rsp_powereddown"
	coveritem "all"
		bins {{"op_cmp"}, {"rsp_mcastmixed","rsp_powereddown"}}
CHECKSUM: "2273710137 2164388735"
covergroup iosfsbm_cm::xaction_cov::vr_sbc_0184
	coveritem "all_fid"
		ANNOTATION: " These are unsupported commands and FIDs for these commands needn't be covered. "
		bins {{"op_iowr"}, {"FID_C1h_FFh","FID_81h_C0h","FID_41h_80h"}}, {{"op_iord"}, {"FID_C1h_FFh","FID_81h_C0h","FID_41h_80h"}}
CHECKSUM: "3106722225 3650012541"
covergroup iosfsbm_cm::xaction_cov::vr_sbc_0161
	coveritem "not_supported"
		ANNOTATION: " These responses are not supported by HQM. 
Can be excluded
 "
		bins {{"op_cmp"}, {"rsp_mcastmixed","rsp_powereddown"}}
CHECKSUM: "3283035438 772344267"
covergroup iosfsbm_cm::xaction_cov::vr_sbc_0197_gt_083spec
	ANNOTATION: " These opcodes are not supported by HQM V2 "
	coveritem "simple_msg"
	coveritem "simple_msg_all"
CHECKSUM: "3283035438 772344267"
covergroup "iosfsbm_cm.vrf_0197_gt_083spec_iosf_sbc_fabric_if_RX"
	coveritem "simple_msg", "simple_msg_all"
CHECKSUM: "3283035438 772344267"
covergroup "iosfsbm_cm.vrf_0197_gt_083spec_iosf_sbc_fabric_if_TX"
	coveritem "simple_msg", "simple_msg_all"
CHECKSUM: "3538996314 1697403266"
covergroup iosfsbm_cm::xaction_cov::vr_sbc_0309_a
CHECKSUM: "3706015297 2410469074"
covergroup iosfsbm_cm::xaction_cov::vr_sbc_0169
	coveritem "all_types"
		bins "op_deassert_intd", "op_deassert_intc", "op_deassert_intb", "op_deassert_inta", "op_assert_intd", "op_assert_intc", "op_assert_intb", "op_assert_inta", "op_pci_pm", "op_pm_rsp", "op_pm_dmd", "op_bulk_wr", "op_bulk_rd"
CHECKSUM: "486302997 3282253198"
ANNOTATION: " As per Steve's comments, we can exclude CGs related to bcast/mcast "
covergroup iosfsbm_cm::xaction_cov::vr_sbc_0309_b
CHECKSUM: "643867216 1246570355"
covergroup iosfsbm_cm::xaction_cov::vr_sbc_0198_gt_083spec
	coveritem "msg_w_data"
		bins "op_pci_pm", "op_pmon", "op_mca", "op_pm_rsp", "op_pm_dmd"
	coveritem "msg_w_data_all"
		ANNOTATION: " These opcodes are not supported by HQM V2 "
		bins {{"p"}, {"op_pci_pm","op_pmon","op_mca","op_pm_rsp","op_pm_dmd"}}
CHECKSUM: "1356046203 1152059208"
covergroup hqm_tb_top.iosf_sbc_fabric_if::vr_sbc_0217_agent
	coveritem "idle_sm_state"
		ANNOTATION: " No credit re-init. Can be excluded "
		bins "ip_active_req_2_credit_req"
CHECKSUM: "1465246732 3246996596"
covergroup hqm_tb_top.iosf_sbc_fabric_if::vr_sbc_0224_tnpput_ism_fabric
	coveritem "cross_tnpput_ism"
		ANNOTATION: " The hqm doesn?t generate NP transactions other than the fuse pull request, so the NP crosses can be excluded "
		bins {{"fabric_idle_nak"}, {"tnpput_1"}}
CHECKSUM: "2125972385 719047204"
covergroup hqm_tb_top.iosf_sbc_fabric_if::vr_sbc_0219_fabric
	coveritem "idle_sm_state"
		ANNOTATION: " No credit re-init. Can be excluded "
		bins "fabric_active_req_2_credit_req"
CHECKSUM: "2740339606 1005202798"
covergroup hqm_tb_top.iosf_sbc_fabric_if::master_vr_sbc_0144
	coveritem "mpc_credit"
		ANNOTATION: " As per Steve's comments, Max_to_zero requires credit reinit so can be excluded "
		bins "mpc_crd_max_to_zero"
CHECKSUM: "3023041333 1602064674"
covergroup hqm_tb_top.iosf_sbc_fabric_if::master_vr_sbc_0143
	coveritem "mnp_credit"
		ANNOTATION: " As per Steve's comments, Max_to_zero requires credit reinit so can be excluded "
		bins "mnp_crd_max_to_zero"
CHECKSUM: "381675568 3665634484"
covergroup hqm_tb_top.iosf_sbc_fabric_if::vr_sbc_0224_tnpcup_ism_fabric
	coveritem "cross_tnpcup_ism"
		bins {{"fabric_idle_nak"}, {"tnpcup_1"}}, {{"fabric_active_req"}, {"tnpcup_1"}}
CHECKSUM: "776140346 3617237279"
covergroup hqm_tb_top.iosf_sbc_fabric_if::vr_sbc_0225_powergating
	coveritem "cross_fbrc_ism_pok"
		bins "fbrc_active_req_pok0", "fbrc_credit_req_pok0"
		ANNOTATION: " The uncovered bins are cross between  side_pok = 0 and all the ISM states. When side_pok is 0, I believe ISM will be at IDLE state only. So these crosses  between other states and side_pok_0 can be excluded.   "
		bins {{"fabric_credit_ack"}, {"side_pok_0"}}, {{"fabric_credit_init","fabric_idle_nak"}, {"side_pok_0"}}
	coveritem "cross_agnt_ism_pok"
		bins {{"ip_credit_req","ip_credit_done","ip_credit_init","ip_active_req"}, {"side_pok_0"}}, {{"ip_idle_req","ip_active"}, {"side_pok_0"}}
CHECKSUM: "1329418915 801936016"
covergroup iosfsbm_cm::xaction_cov::vr_sbc_0196
	coveritem "msg_w_data"
		bins "op_syncstartcmd", "op_pci_pm", "op_pm_rsp", "op_pm_dmd"
	coveritem "simple_msg"
		ANNOTATION: " These opcodes are not supported by HQM V2 "
		bins "op_deassert_intd", "op_deassert_intc", "op_deassert_intb", "op_deassert_inta", "op_assert_intd", "op_assert_intc", "op_assert_intb", "op_assert_inta"
CHECKSUM: "1425693351 2325287371"
ANNOTATION: " As per Steve's comments, we can exclude CGs related to bcast/mcast "
covergroup iosfsbm_cm::xaction_cov::vr_sbc_0303
CHECKSUM: "1632935735 406857317"
covergroup iosfsbm_cm::xaction_cov::vr_sbc_0195
	coveritem "cmpd_access"
		ANNOTATION: " Completion with dw = 2/3 not supported "
		bins {{"op_cmpd"}, {"dw_2"}}
CHECKSUM: "1869598669 3471597456"
ANNOTATION: " As per Steve's comment, we can exclude loopback transaction "
covergroup iosfsbm_cm::xaction_cov::vr_sbc_0305
CHECKSUM: "2182433168 2177586801"
covergroup iosfsbm_cm::xaction_cov::vr_sbc_0194
	coveritem "rsp"
		ANNOTATION: " These responses are not supported by HQM V2 "
		bins "rsp_mcastmixed", "rsp_powereddown"
	coveritem "all"
		bins {{"op_cmp"}, {"rsp_mcastmixed","rsp_powereddown"}}
CHECKSUM: "2273710137 2164388735"
covergroup iosfsbm_cm::xaction_cov::vr_sbc_0184
	coveritem "all_fid"
		ANNOTATION: " These are unsupported commands and FIDs for these commands needn't be covered. "
		bins {{"op_iowr"}, {"FID_C1h_FFh","FID_81h_C0h","FID_41h_80h"}}, {{"op_iord"}, {"FID_C1h_FFh","FID_81h_C0h","FID_41h_80h"}}
CHECKSUM: "3106722225 3650012541"
covergroup iosfsbm_cm::xaction_cov::vr_sbc_0161
	coveritem "not_supported"
		ANNOTATION: " These responses are not supported by HQM. 
Can be excluded
 "
		bins {{"op_cmp"}, {"rsp_mcastmixed","rsp_powereddown"}}
CHECKSUM: "3283035438 772344267"
covergroup iosfsbm_cm::xaction_cov::vr_sbc_0197_gt_083spec
	ANNOTATION: " These opcodes are not supported by HQM V2 "
	coveritem "simple_msg"
	coveritem "simple_msg_all"
CHECKSUM: "3283035438 772344267"
covergroup "iosfsbm_cm.vrf_0197_gt_083spec_iosf_sbc_fabric_if_RX"
	coveritem "simple_msg", "simple_msg_all"
CHECKSUM: "3283035438 772344267"
covergroup "iosfsbm_cm.vrf_0197_gt_083spec_iosf_sbc_fabric_if_TX"
	coveritem "simple_msg", "simple_msg_all"
CHECKSUM: "3538996314 1697403266"
covergroup iosfsbm_cm::xaction_cov::vr_sbc_0309_a
CHECKSUM: "3706015297 2410469074"
covergroup iosfsbm_cm::xaction_cov::vr_sbc_0169
	coveritem "all_types"
		bins "op_deassert_intd", "op_deassert_intc", "op_deassert_intb", "op_deassert_inta", "op_assert_intd", "op_assert_intc", "op_assert_intb", "op_assert_inta", "op_pci_pm", "op_pm_rsp", "op_pm_dmd", "op_bulk_wr", "op_bulk_rd"
CHECKSUM: "486302997 3282253198"
ANNOTATION: " As per Steve's comments, we can exclude CGs related to bcast/mcast "
covergroup iosfsbm_cm::xaction_cov::vr_sbc_0309_b
CHECKSUM: "643867216 1246570355"
covergroup iosfsbm_cm::xaction_cov::vr_sbc_0198_gt_083spec
	coveritem "msg_w_data"
		bins "op_pci_pm", "op_pmon", "op_mca", "op_pm_rsp", "op_pm_dmd"
	coveritem "msg_w_data_all"
		ANNOTATION: " These opcodes are not supported by HQM V2 "
		bins {{"p"}, {"op_pci_pm","op_pmon","op_mca","op_pm_rsp","op_pm_dmd"}}
