# Begin_DVE_Session_Save_Info
# DVE view(Wave.1 ) session
# Saved on Fri Aug 26 01:54:13 2016
# Toplevel windows open: 2
# 	TopLevel.1
# 	TopLevel.2
#   Wave.1: 9 signals
# End_DVE_Session_Save_Info

# DVE version: J-2014.12-1_Full64
# DVE build date: Jan 20 2015 23:31:41


#<Session mode="View" path="/nfs/site/disks/axx_0046/users/amlawand/hqm_ww35c/verif/tb/hqm/tests/hqm_iosf_sideband_test/session.dump.vpd.tcl" type="Debug">

#<Database>

gui_set_time_units 10fs
#</Database>

# DVE View/pane content session: 

# Begin_DVE_Session_Save_Info (Wave.1)
# DVE wave signals session
# Saved on Fri Aug 26 01:54:13 2016
# 9 signals
# End_DVE_Session_Save_Info

# DVE version: J-2014.12-1_Full64
# DVE build date: Jan 20 2015 23:31:41


#Add ncecessay scopes

gui_set_time_units 10fs

set _wave_session_group_1 Group1
if {[gui_sg_is_group -name "$_wave_session_group_1"]} {
    set _wave_session_group_1 [gui_sg_generate_new_name]
}
set Group1 "$_wave_session_group_1"

gui_sg_addsignal -group "$_wave_session_group_1" { {V1:hqm_tb_top.u_hqm.side_clk} {V1:hqm_tb_top.u_hqm.gpsb_mpcput} {V1:hqm_tb_top.u_hqm.gpsb_mnpput} {V1:hqm_tb_top.u_hqm.gpsb_meom} {V1:hqm_tb_top.u_hqm.gpsb_mpayload} {V1:hqm_tb_top.u_hqm.gpsb_tpcput} {V1:hqm_tb_top.u_hqm.gpsb_tnpput} {V1:hqm_tb_top.u_hqm.gpsb_teom} {V1:hqm_tb_top.u_hqm.gpsb_tpayload} }
if {![info exists useOldWindow]} { 
	set useOldWindow true
}
if {$useOldWindow && [string first "Wave" [gui_get_current_window -view]]==0} { 
	set Wave.1 [gui_get_current_window -view] 
} else {
	set Wave.1 [lindex [gui_get_window_ids -type Wave] 0]
if {[string first "Wave" ${Wave.1}]!=0} {
gui_open_window Wave
set Wave.1 [ gui_get_current_window -view ]
}
}

set groupExD [gui_get_pref_value -category Wave -key exclusiveSG]
gui_set_pref_value -category Wave -key exclusiveSG -value {false}
set origWaveHeight [gui_get_pref_value -category Wave -key waveRowHeight]
gui_list_set_height -id Wave -height 25
set origGroupCreationState [gui_list_create_group_when_add -wave]
gui_list_create_group_when_add -wave -disable
gui_marker_set_ref -id ${Wave.1}  C1
gui_wv_zoom_timerange -id ${Wave.1} 601270276 615728724
gui_list_add_group -id ${Wave.1} -after {New Group} [list ${Group1}]
gui_list_select -id ${Wave.1} {hqm_tb_top.u_hqm.gpsb_mpayload }
gui_seek_criteria -id ${Wave.1} {Any Edge}


gui_set_pref_value -category Wave -key exclusiveSG -value $groupExD
gui_list_set_height -id Wave -height $origWaveHeight
if {$origGroupCreationState} {
	gui_list_create_group_when_add -wave -enable
}
if { $groupExD } {
 gui_msg_report -code DVWW028
}
gui_list_set_filter -id ${Wave.1} -list { {Buffer 1} {Input 1} {Others 1} {Linkage 1} {Output 1} {Parameter 1} {All 1} {Aggregate 1} {LibBaseMember 1} {Event 1} {Assertion 1} {Constant 1} {Interface 1} {BaseMembers 1} {Signal 1} {$unit 1} {Inout 1} {Variable 1} }
gui_list_set_filter -id ${Wave.1} -text {*}
gui_list_set_insertion_bar  -id ${Wave.1} -group ${Group1}  -item {hqm_tb_top.u_hqm.gpsb_mpayload[7:0]} -position below

gui_marker_move -id ${Wave.1} {C1} 0
gui_view_scroll -id ${Wave.1} -vertical -set 0
gui_show_grid -id ${Wave.1} -enable false
#</Session>

