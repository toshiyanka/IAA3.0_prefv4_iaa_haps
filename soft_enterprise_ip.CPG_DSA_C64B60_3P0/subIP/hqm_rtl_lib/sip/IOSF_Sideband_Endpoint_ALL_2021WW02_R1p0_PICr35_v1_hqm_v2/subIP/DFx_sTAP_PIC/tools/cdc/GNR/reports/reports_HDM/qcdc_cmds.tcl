configure license queue on
# do /nfs/iind/disks/dteg_disk008/users/badithya/ReferenceDrops/dteg-stap/target/stap/ICL/aceroot/qcdc_da.tcl
# do /p/hdk/rtl/proj_tools/cdc/master/v20160303/prototype/cdc_global.tcl
cdc report scheme bus_dff_sync_combo_clock -severity caution
cdc report scheme dff_sync_combo_clk -severity caution
cdc report scheme reconvergence_bus -severity violation
cdc report scheme reconvergence_mixed -severity violation
cdc reconvergence on
cdc preference -filtered_report
cdc preference hier -ctrl_file_models
cdc synchronizer dff -min 2 -max 5
netlist constant propagation -enable
cdc report scheme two_dff -severity violation
cdc report scheme bus_two_dff -severity violation
cdc report scheme single_source_reconvergence -severity caution
cdc report scheme pulse_sync -severity violation
cdc report scheme two_dff_phase -severity violation
cdc report scheme bus_two_dff_phase -severity violation
cdc report scheme shift_reg -severity violation
cdc report scheme async_reset -severity violation
cdc report scheme four_latch -severity violation
cdc report scheme bus_four_latch -severity violation
cdc preference hier -conflict_check
configure license queue on
cdc dmux -check off -scheme partial_dmux
cdc preference -fifo_scheme
cdc preference -handshake_scheme
cdc preference -enable_internal_resets
cdc preference reconvergence -bit_recon
cdc preference reconvergence -depth 2
# do /p/hdk/rtl/proj_tools/cdc/master/v20160303/prototype/ppill.tcl
# end do /p/hdk/rtl/proj_tools/cdc/master/v20160303/prototype/ppill.tcl
# end do /p/hdk/rtl/proj_tools/cdc/master/v20160303/prototype/cdc_global.tcl
# do /p/hdk/rtl/proj_tools/cdc/master/v20161111/prototype/p1274/cdc_global_waivers.tcl
cdc report crossing -scheme two_dff -through d -to o1 -severity waived -module ec0fmn202al1n04x5 -comment This is an approved synchronizer cell
cdc report crossing -scheme two_dff -through d -to o1 -severity waived -module e05fmw203al1d* -comment This is an approved synchronizer cell
cdc report crossing -scheme two_dff -through d -to o1 -severity waived -module e05fmw20cal1d03x5 -comment This is an approved synchronizer cell
cdc report crossing -scheme two_dff -through d -to o1 -severity waived -module e05fmw20can1d03x5 -comment This is an approved synchronizer cell
cdc report crossing -scheme two_dff -through d -to o1 -severity waived -module ec0fmw203al2n04x5 -comment This is an approved synchronizer cell
cdc report crossing -scheme two_dff -through d -to o1 -severity waived -module ec0fmw20cal2n04x5 -comment This is an approved synchronizer cell
cdc report crossing -scheme two_dff -through d -to o1 -severity waived -module ec0fmw203an2n04x5 -comment This is an approved synchronizer cell
cdc report crossing -scheme two_dff -through d -to o1 -severity waived -module ec0fmw20can2n04x5 -comment This is an approved synchronizer cell
cdc report crossing -scheme two_dff -through d -to o1 -severity waived -module e05fmw203a*1d* -comment This is an approved synchronizer cell
cdc report crossing -scheme two_dff -through d -to o1 -severity waived -module ec0fmw203an1n04x5 -comment This is an approved synchronizer cell
cdc report crossing -scheme two_dff -through d -to o1 -severity waived -module e05fmn203al1d06x5 -comment This is an approved synchronizer cell
cdc report crossing -scheme two_dff -through d -to o1 -severity waived -module ec0fmn202an1d08x5 -comment This is an approved synchronizer cell
cdc report crossing -scheme two_dff -through d -to o1 -severity waived -module e05fmn203an* -comment This is an approved synchronizer cell
cdc report crossing -scheme two_dff -through d -to n10 -severity waived -module fmn202_func -comment This is an approved synchronizer cell
cdc report crossing -scheme two_dff -through d -to ec0fmw*0*a*0*x5_behav_inst.n10 -severity waived -module ec0fmw*0*a*0*x5 -comment This is an approved synchronizer cell
cdc report crossing -scheme pulse_sync -through d -to ec0fmw*0*a*0*x5_behav_inst.n10 -severity waived -module ec0fmw*0*a*0*x5 -comment This is an approved synchronizer cell
cdc report crossing -scheme async_reset -through rb -to ec0fmw*0*a*0*x5_behav_inst.n10 -severity waived -module ec0fmw*0*a*0*x5 -comment This is an approved synchronizer cell
cdc report crossing -scheme async_reset -through psb -to ec0fmw*0*a*0*x5_behav_inst.n10 -severity waived -module ec0fmw*0*a*0*x5 -comment This is an approved synchronizer cell
cdc report crossing -scheme async_reset -through rb -to ec0fmw*0*a*0*x5_inst.n10 -severity waived -module ec0fmw*0*a*0*x5 -comment This is an approved synchronizer cell
cdc report crossing -scheme async_reset -through psb -to ec0fmw*0*a*0*x5_inst.n10 -severity waived -module ec0fmw*0*a*0*x5 -comment This is an approved synchronizer cell
cdc report crossing -scheme two_dff -through d -to ec0fmw*0*a*0*x5_inst.n10 -severity waived -module ec0fmw*0*a*0*x5 -comment This is an approved synchronizer cell
cdc report crossing -scheme pulse_sync -through d -to ec0fmw*0*a*0*x5_inst.n10 -severity waived -module ec0fmw*0*a*0*x5 -comment This is an approved synchronizer cell
cdc report crossing -scheme two_dff -through d -to n10 -severity waived -module ec0fmw*0*a*0*x5 -comment This is an approved synchronizer cell
cdc report crossing -scheme pulse_sync -through d -to n10 -severity waived -module ec0fmw*0*a*0*x5 -comment This is an approved synchronizer cell
cdc report crossing -scheme async_reset -through rb -to n10 -severity waived -module ec0fmw*0*a*0*x5 -comment This is an approved synchronizer cell
cdc report crossing -scheme async_reset -through psb -to n10 -severity waived -module ec0fmw*0*a*0*x5 -comment This is an approved synchronizer cell
cdc report crossing -scheme async_reset -through rb -to o1 -severity waived -module e05fmw203al1d* -comment This is an approved synchronizer cell
cdc report crossing -scheme async_reset -through psb -to o1 -severity waived -module e05fmw20cal1d03x5 -comment This is an approved synchronizer cell
cdc report crossing -scheme async_reset -through psb -to o1 -severity waived -module e05fmw20can1d03x5 -comment This is an approved synchronizer cell
cdc report crossing -scheme async_reset -through rb -to o1 -severity waived -module e05fmw203a*1d* -comment This is an approved synchronizer cell
cdc report crossing -scheme pulse_sync -through d -to o1 -severity waived -module e05fmw*0*a*0*x5 -comment This is an approved synchronizer cell
cdc report crossing -scheme pulse_sync -through d -to o1 -severity waived -module e05fmn*0*a*0*x5 -comment This is an approved synchronizer cell
# end do /p/hdk/rtl/proj_tools/cdc/master/v20161111/prototype/p1274/cdc_global_waivers.tcl
# do /nfs/iind/disks/dteg_disk008/users/badithya/ReferenceDrops/dteg-stap/target/stap/ICL/aceroot//tools/cdc/constraints/stap_ctrl.tcl
cdc preference reconvergence -depth 2
cdc preference -detect_pure_latch_clock
cdc preference -filtered_report
netlist clock ftap_tck -period 10 -group grp_ftap_tck -module stap
netlist clock ftapsslv_tck -period 5 -group grp_ftapsslv_tck -module stap
netlist clock sntapnw_ftap_tck -period 10 -group grp_ftap_tck -module stap
netlist clock sntapnw_ftap_tck2 -period 5 -group grp_ftapsslv_tck -module stap
netlist clock stap_fbscan_tck -period 10 -group grp_ftap_tck -module stap
netlist clock fdfx_policy_update -period 10 -group grp_policy_update -module stap
netlist clock fdfx_earlyboot_exit -period 10 -group grp_policy_update -module stap
netlist port domain ftap_trst_b -clock ftap_tck -module stap
netlist port domain ftapsslv_trst_b -clock ftapsslv_tck -module stap
netlist port domain fdfx_powergood -async -module stap
netlist port domain sntapnw_ftap_trst_b -clock ftap_tck -module stap
netlist port domain sn_fwtap_wrst_b -clock ftap_tck -module stap
netlist port domain tap_rtdr_powergood -async -module stap
cdc signal ftap_slvidcode* -stable -module stap
cdc signal fdfx_secure_policy* -stable -module stap
cdc signal dfxsecure_feature_en* -stable -module stap
cdc signal visa_all_dis* -stable -module stap
cdc signal visa_customer_dis* -stable -module stap
netlist port domain ftap_tms -clock ftap_tck -module stap
netlist port domain ftap_tdi -clock ftap_tck -module stap
netlist port domain tdr_data_in* -clock ftap_tck -module stap
netlist port domain sntapnw_atap_tdo -clock ftap_tck -module stap
netlist port domain sntapnw_atap_tdo_en -clock ftap_tck -module stap
netlist port domain ftapsslv_tms -clock ftapsslv_tck -module stap
netlist port domain ftapsslv_tdi -clock ftapsslv_tck -module stap
netlist port domain sntapnw_atap_tdo2 -clock ftapsslv_tck -module stap
netlist port domain sntapnw_atap_tdo2_en* -clock ftapsslv_tck -module stap
netlist port domain sn_awtap_wso* -clock ftap_tck -module stap
netlist port domain stap_fbscan_tdo -clock ftap_tck -module stap
netlist port domain rtdr_tap_tdo* -clock ftap_tck -module stap
netlist port domain tdr_data_out* -clock ftap_tck -module stap
netlist port domain sftapnw_ftap_secsel* -clock ftap_tck -module stap
netlist port domain sftapnw_ftap_enabletdo* -clock ftap_tck -module stap
netlist port domain sftapnw_ftap_enabletap* -clock ftap_tck -module stap
netlist port domain sntapnw_ftap_tms -clock ftap_tck -module stap
netlist port domain sntapnw_ftap_tdi -clock ftap_tck -module stap
netlist port domain sn_fwtap_wrck -clock ftap_tck -module stap
netlist port domain sn_fwtap_capturewr -clock ftap_tck -module stap
netlist port domain sn_fwtap_shiftwr -clock ftap_tck -module stap
netlist port domain sn_fwtap_updatewr -clock ftap_tck -module stap
netlist port domain sn_fwtap_rti -clock ftap_tck -module stap
netlist port domain sn_fwtap_selectwir -clock ftap_tck -module stap
netlist port domain sn_fwtap_wsi* -clock ftap_tck -module stap
netlist port domain stap_fbscan_capturedr -clock stap_fbscan_tck -module stap
netlist port domain stap_fbscan_shiftdr -clock stap_fbscan_tck -module stap
netlist port domain stap_fbscan_updatedr -clock stap_fbscan_tck -module stap
netlist port domain stap_fbscan_updatedr_clk -clock stap_fbscan_tck -module stap
netlist port domain stap_fbscan_runbist_en -clock stap_fbscan_tck -module stap
netlist port domain stap_fbscan_highz -clock stap_fbscan_tck -module stap
netlist port domain stap_fbscan_extogen -clock stap_fbscan_tck -module stap
netlist port domain stap_fbscan_chainen -clock stap_fbscan_tck -module stap
netlist port domain stap_fbscan_mode -clock stap_fbscan_tck -module stap
netlist port domain stap_fbscan_extogsig_b -clock stap_fbscan_tck -module stap
netlist port domain stap_fbscan_d6init -clock stap_fbscan_tck -module stap
netlist port domain stap_fbscan_d6actestsig_b -clock stap_fbscan_tck -module stap
netlist port domain stap_fbscan_d6select -clock stap_fbscan_tck -module stap
netlist port domain tap_rtdr_tdi -clock ftap_tck -module stap
netlist port domain tap_rtdr_capture -clock ftap_tck -module stap
netlist port domain tap_rtdr_shift -clock ftap_tck -module stap
netlist port domain tap_rtdr_update -clock ftap_tck -module stap
netlist port domain { tap_rtdr_irdec[1] } -clock ftap_tck -module stap
netlist port domain tap_rtdr_selectir -clock ftap_tck -module stap
netlist port domain tap_rtdr_rti -clock ftap_tck -module stap
# end do /nfs/iind/disks/dteg_disk008/users/badithya/ReferenceDrops/dteg-stap/target/stap/ICL/aceroot//tools/cdc/constraints/stap_ctrl.tcl
# do /nfs/iind/disks/dteg_disk008/users/badithya/ReferenceDrops/dteg-stap/target/stap/ICL/aceroot//tools/cdc/constraints/stap_waiver_ctrl.tcl
cdc report crossing -scheme no_sync -from fdfx_powergood -to tap_rtdr_powergood -module stap -severity waived
cdc promote crossing -scheme no_sync -from fdfx_powergood -to tap_rtdr_powergood -module stap -promotion off
cdc report crossing -scheme no_sync -from fdfx_powergood -to *dfxsecure_feature_lch* -module stap -severity waived
cdc report crossing -scheme async_reset_no_sync -module stap -severity waived
cdc promote crossing -scheme async_reset_no_sync -module stap -promotion off
# end do /nfs/iind/disks/dteg_disk008/users/badithya/ReferenceDrops/dteg-stap/target/stap/ICL/aceroot//tools/cdc/constraints/stap_waiver_ctrl.tcl
cdc run -work stap_cdc_lib -L work -L stap_cdc_testlib -L stap_cdc_lib -d stap -hcdc
cdc generate crossings /nfs/iind/disks/dteg_disk008/users/badithya/ReferenceDrops/dteg-stap/target/stap/ICL/aceroot//results/tests/cdc_test_stap_hdmRUN/Violation_Details.rpt
cdc generate tree -reset /nfs/iind/disks/dteg_disk008/users/badithya/ReferenceDrops/dteg-stap/target/stap/ICL/aceroot//results/tests/cdc_test_stap_hdmRUN/Reset_Details.rpt
cdc generate tree -clock /nfs/iind/disks/dteg_disk008/users/badithya/ReferenceDrops/dteg-stap/target/stap/ICL/aceroot//results/tests/cdc_test_stap_hdmRUN/Clock_Details.rpt
# end do /nfs/iind/disks/dteg_disk008/users/badithya/ReferenceDrops/dteg-stap/target/stap/ICL/aceroot/qcdc_da.tcl
