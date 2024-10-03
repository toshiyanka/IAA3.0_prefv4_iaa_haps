
//- Questa CDC Version 10.4f_5 linux_x86_64 26 May 2017

//-----------------------------------------------------------------
// CDC Hierarchical Control File
// Created Wed Jul 24 10:03:28 2019
//-----------------------------------------------------------------

module stap_ctrl; // Hierarchical CDC warning: Do not change the module name

// INPUT PORTS

// 0in set_cdc_clock ftap_tck -group grp_ftap_tck -module stap
// Reason for -clock: User specified
// 0in set_cdc_port_domain ftap_tms -clock ftap_tck -module stap
// Reason for -clock: User specified
// 0in set_cdc_port_domain ftap_trst_b -clock ftap_tck -module stap
// Reason for -clock: User specified
// 0in set_cdc_port_domain ftap_tdi -clock ftap_tck -module stap
// 0in set_cdc_signal -stable ftap_slvidcode -module stap 
// Reason for -async: User specified
// 0in set_cdc_port_domain fdfx_powergood -async -module stap 
// Reason for -clock: User specified
// 0in set_cdc_port_domain tdr_data_in -clock ftap_tck -module stap
// 0in set_cdc_signal -stable fdfx_secure_policy -module stap 
// 0in set_constant fdfx_earlyboot_exit -module stap 1'b1
// 0in set_cdc_clock fdfx_policy_update -group grp_policy_update -module stap
// Reason for -clock: User specified
// 0in set_cdc_port_domain sntapnw_atap_tdo -clock ftap_tck -module stap
// Reason for -clock: User specified
// 0in set_cdc_port_domain sntapnw_atap_tdo_en -clock ftap_tck -module stap
// 0in set_cdc_clock ftapsslv_tck -group grp_ftapsslv_tck -module stap
// Reason for -clock: User specified
// 0in set_cdc_port_domain ftapsslv_tms -clock ftapsslv_tck -module stap
// Reason for -clock: User specified
// 0in set_cdc_port_domain ftapsslv_trst_b -clock ftapsslv_tck -module stap
// Reason for -clock: User specified
// 0in set_cdc_port_domain ftapsslv_tdi -clock ftapsslv_tck -module stap
// Reason for -clock: User specified
// 0in set_cdc_port_domain sntapnw_atap_tdo2 -clock ftapsslv_tck -module stap
// Reason for -clock: User specified
// 0in set_cdc_port_domain sntapnw_atap_tdo2_en -clock ftapsslv_tck -module stap
// Reason for -clock: User specified
// 0in set_cdc_port_domain sn_awtap_wso -clock ftap_tck -module stap
// Reason for -clock: User specified
// 0in set_cdc_port_domain stap_abscan_tdo -clock ftap_tck -module stap
// Reason for -clock: User specified
// 0in set_cdc_port_domain ftap_pwrdomain_rst_b -clock ftap_tck -module stap
// Reason for -clock: User specified
// 0in set_cdc_port_domain rtdr_tap_tdo -clock ftap_tck -module stap
// 0in set_constant stap_isol_en_b -module stap 1'b1


// OUTPUT PORTS

// INFERRED_CONFLICT: Port atap_tdo is ignored because it is unconnected in the module stap
//  INFERRED_CONFLICT: 0in set_cdc_port_domain atap_tdo -ignore -module stap 
// Reason for -clock: User specified
// 0in set_cdc_port_domain atap_tdo -clock ftap_tck -module stap
// Reason for -clock: User specified
// 0in set_cdc_port_domain atap_tdoen -clock ftap_tck -module stap
// 0in set_constant tdr_data_out -module stap 1'b0
// 0in set_constant sftapnw_ftap_secsel -module stap 1'b0
// 0in set_constant sftapnw_ftap_enabletdo -module stap 1'b0
// 0in set_constant sftapnw_ftap_enabletap -module stap 1'b0
// 0in set_constant sntapnw_ftap_tck -module stap 1'b0
// 0in set_constant sntapnw_ftap_tms -module stap 1'b1
// 0in set_constant sntapnw_ftap_trst_b -module stap 1'b1
// 0in set_constant sntapnw_ftap_tdi -module stap 1'b0
// 0in set_cdc_port_domain atapsslv_tdo  -combo_path  sntapnw_atap_tdo2 -module stap 
// 0in set_cdc_port_domain atapsslv_tdoen  -combo_path  sntapnw_atap_tdo2_en -module stap 
// 0in set_cdc_clock sntapnw_ftap_tck2 -group grp_ftapsslv_tck -module stap
// 0in set_cdc_port_domain sntapnw_ftap_tms2  -combo_path  ftapsslv_tms -module stap 
// 0in set_cdc_port_domain sntapnw_ftap_trst2_b  -combo_path  ftapsslv_trst_b -module stap 
// 0in set_cdc_port_domain sntapnw_ftap_tdi2  -combo_path  ftapsslv_tdi -module stap 
// 0in set_constant sn_fwtap_wrck -module stap 1'b0
// 0in set_constant sn_fwtap_wrst_b -module stap 1'b1
// 0in set_constant sn_fwtap_capturewr -module stap 1'b0
// 0in set_constant sn_fwtap_shiftwr -module stap 1'b0
// 0in set_constant sn_fwtap_updatewr -module stap 1'b0
// 0in set_constant sn_fwtap_rti -module stap 1'b0
// 0in set_constant sn_fwtap_selectwir -module stap 1'b0
// 0in set_constant sn_fwtap_wsi -module stap 1'b1
// 0in set_constant stap_fbscan_tck -module stap 1'b0
// 0in set_constant stap_fbscan_capturedr -module stap 1'b0
// 0in set_constant stap_fbscan_shiftdr -module stap 1'b0
// 0in set_constant stap_fbscan_updatedr -module stap 1'b0
// 0in set_constant stap_fbscan_updatedr_clk -module stap 1'b0
// 0in set_constant stap_fbscan_runbist_en -module stap 1'b0
// 0in set_constant stap_fbscan_highz -module stap 1'b0
// 0in set_constant stap_fbscan_extogen -module stap 1'b0
// 0in set_constant stap_fbscan_intest_mode -module stap 1'b0
// 0in set_constant stap_fbscan_chainen -module stap 1'b0
// 0in set_constant stap_fbscan_mode -module stap 1'b0
// 0in set_constant stap_fbscan_extogsig_b -module stap 1'b1
// 0in set_cdc_port_domain stap_fsm_tlrs -clock ftap_tck -module stap 
// 0in set_constant stap_fbscan_d6init -module stap 1'b0
// 0in set_constant stap_fbscan_d6actestsig_b -module stap 1'b1
// 0in set_constant stap_fbscan_d6select -module stap 1'b0
// 0in set_constant tap_rtdr_irdec -module stap 1'b0
// 0in set_constant tap_rtdr_prog_rst_b -module stap 1'b1
// 0in set_constant tap_rtdr_tdi -module stap 1'b1
// 0in set_constant tap_rtdr_capture -module stap 1'b0
// 0in set_constant tap_rtdr_shift -module stap 1'b0
// 0in set_constant tap_rtdr_update -module stap 1'b0
// 0in set_cdc_clock tap_rtdr_tck -group grp_ftap_tck -module stap
// 0in set_constant tap_rtdr_powergood -module stap 1'b1
// 0in set_constant tap_rtdr_selectir -module stap 1'b0
// 0in set_constant tap_rtdr_rti -module stap 1'b0
endmodule
