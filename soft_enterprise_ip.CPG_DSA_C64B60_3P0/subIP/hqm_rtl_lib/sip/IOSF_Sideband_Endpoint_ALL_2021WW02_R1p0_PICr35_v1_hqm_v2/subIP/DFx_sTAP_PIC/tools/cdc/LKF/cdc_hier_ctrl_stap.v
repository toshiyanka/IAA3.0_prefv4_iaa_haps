// Generated from target/stap/TGPLP/aceroot/results/tests/cdc_test_stap_hdmRUN/hcdc_stap.hierdb

module stap_ctrl;


//# INPUT PORTS
// 0in set_constant fdfx_earlyboot_exit 1'b1 -module stap
// 0in set_cdc_clock fdfx_policy_update  -group grp_policy_update -module stap
// 0in set_cdc_port_domain fdfx_powergood -async -module stap
// 0in set_cdc_signal -stable fdfx_secure_policy -module stap
// 0in set_cdc_port_domain ftap_pwrdomain_rst_b -clock ftap_tck -module stap
// 0in set_cdc_signal -stable ftap_slvidcode -module stap
// 0in set_cdc_clock ftap_tck  -group grp_ftap_tck -module stap
// 0in set_cdc_port_domain ftap_tdi -clock ftap_tck -module stap
// 0in set_cdc_port_domain ftap_tms -clock ftap_tck -module stap
// 0in set_cdc_port_domain ftap_trst_b -clock ftap_tck -module stap
// 0in set_cdc_clock ftapsslv_tck  -group grp_ftapsslv_tck -module stap
// 0in set_cdc_port_domain ftapsslv_tdi -clock ftapsslv_tck -module stap
// 0in set_cdc_port_domain ftapsslv_tms -clock ftapsslv_tck -module stap
// 0in set_cdc_port_domain ftapsslv_trst_b -clock ftapsslv_tck -module stap
// 0in set_cdc_port_domain rtdr_tap_tdo -clock ftap_tck -module stap
// 0in set_cdc_port_domain sn_awtap_wso -clock ftap_tck -module stap
// 0in set_cdc_port_domain sntapnw_atap_tdo -clock ftap_tck -module stap
// 0in set_cdc_port_domain sntapnw_atap_tdo2 -clock ftapsslv_tck -module stap
// 0in set_cdc_port_domain sntapnw_atap_tdo2_en -clock ftapsslv_tck -module stap
// 0in set_cdc_port_domain sntapnw_atap_tdo_en -clock ftap_tck -module stap
// 0in set_cdc_port_domain stap_abscan_tdo -clock ftap_tck -module stap
// 0in set_constant stap_isol_en_b 1'b1 -module stap
// 0in set_cdc_port_domain tdr_data_in -clock ftap_tck -module stap

//# OUTPUT PORTS
// 0in set_cdc_port_domain atap_tdo -clock ftap_tck -module stap
// 0in set_cdc_port_domain atap_tdoen -clock ftap_tck -module stap
// 0in set_cdc_port_domain atapsslv_tdo -combo_path sntapnw_atap_tdo2 -module stap
// 0in set_cdc_port_domain atapsslv_tdoen -combo_path sntapnw_atap_tdo2_en -module stap
// 0in set_constant sftapnw_ftap_enabletap 1'b0 -module stap
// 0in set_constant sftapnw_ftap_enabletdo 1'b0 -module stap
// 0in set_constant sftapnw_ftap_secsel 1'b0 -module stap
// 0in set_constant sn_fwtap_capturewr 1'b0 -module stap
// 0in set_constant sn_fwtap_rti 1'b0 -module stap
// 0in set_constant sn_fwtap_selectwir 1'b0 -module stap
// 0in set_constant sn_fwtap_shiftwr 1'b0 -module stap
// 0in set_constant sn_fwtap_updatewr 1'b0 -module stap
// 0in set_constant sn_fwtap_wrck 1'b0 -module stap
// 0in set_constant sn_fwtap_wrst_b 1'b1 -module stap
// 0in set_constant sn_fwtap_wsi 1'b1 -module stap
// 0in set_constant sntapnw_ftap_tck 1'b0 -module stap
// 0in set_cdc_clock sntapnw_ftap_tck2  -group grp_ftapsslv_tck -module stap
// 0in set_constant sntapnw_ftap_tdi 1'b0 -module stap
// 0in set_cdc_port_domain sntapnw_ftap_tdi2 -combo_path ftapsslv_tdi -module stap
// 0in set_constant sntapnw_ftap_tms 1'b1 -module stap
// 0in set_cdc_port_domain sntapnw_ftap_tms2 -combo_path ftapsslv_tms -module stap
// 0in set_cdc_port_domain sntapnw_ftap_trst2_b -combo_path ftapsslv_trst_b -module stap
// 0in set_constant sntapnw_ftap_trst_b 1'b1 -module stap
// 0in set_constant stap_fbscan_capturedr 1'b0 -module stap
// 0in set_constant stap_fbscan_chainen 1'b0 -module stap
// 0in set_constant stap_fbscan_d6actestsig_b 1'b1 -module stap
// 0in set_constant stap_fbscan_d6init 1'b0 -module stap
// 0in set_constant stap_fbscan_d6select 1'b0 -module stap
// 0in set_constant stap_fbscan_extogen 1'b0 -module stap
// 0in set_constant stap_fbscan_extogsig_b 1'b1 -module stap
// 0in set_constant stap_fbscan_highz 1'b0 -module stap
// 0in set_constant stap_fbscan_intest_mode 1'b0 -module stap
// 0in set_constant stap_fbscan_mode 1'b0 -module stap
// 0in set_constant stap_fbscan_runbist_en 1'b0 -module stap
// 0in set_constant stap_fbscan_shiftdr 1'b0 -module stap
// 0in set_constant stap_fbscan_tck 1'b0 -module stap
// 0in set_constant stap_fbscan_updatedr 1'b0 -module stap
// 0in set_constant stap_fbscan_updatedr_clk 1'b0 -module stap
// 0in set_cdc_port_domain stap_fsm_tlrs -clock ftap_tck -module stap
// 0in set_constant tap_rtdr_capture 1'b0 -module stap
// 0in set_constant tap_rtdr_irdec 1'b0 -module stap
// 0in set_constant tap_rtdr_powergood 1'b1 -module stap
// 0in set_constant tap_rtdr_prog_rst_b 1'b1 -module stap
// 0in set_constant tap_rtdr_rti 1'b0 -module stap
// 0in set_constant tap_rtdr_selectir 1'b0 -module stap
// 0in set_constant tap_rtdr_shift 1'b0 -module stap
// 0in set_cdc_clock tap_rtdr_tck  -group grp_ftap_tck -module stap
// 0in set_constant tap_rtdr_tdi 1'b1 -module stap
// 0in set_constant tap_rtdr_update 1'b0 -module stap
// 0in set_constant tdr_data_out 1'b0 -module stap

endmodule
