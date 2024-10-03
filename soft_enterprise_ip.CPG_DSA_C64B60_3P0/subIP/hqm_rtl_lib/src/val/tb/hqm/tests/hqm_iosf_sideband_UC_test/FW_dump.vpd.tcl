# Begin_DVE_Session_Save_Info
# DVE view(Hier.1 ) session
# Saved on Tue Sep 20 07:49:24 2016
# Designs open: 1
#   V1: dump.vpd
# Toplevel windows open: 2
# 	TopLevel.1
# 	TopLevel.2
# End_DVE_Session_Save_Info

# DVE version: J-2014.12-1_Full64
# DVE build date: Jan 20 2015 23:31:41


#<Session mode="View" path="/nfs/site/disks/axx_0046/users/amlawand/hqm_ww37a/verif/tb/hqm/tests/hqm_iosf_sideband_UC_test/FW_dump.vpd.tcl" type="Debug">

#<Database>

# DVE Open design session: 

if { ![gui_is_db_opened -db {dump.vpd}] } {
	gui_open_db -design V1 -file dump.vpd -nosource
}
gui_set_precision 10fs
gui_set_time_units 10fs
#</Database>

# DVE View/pane content session: 


# Hier 'Hier.1'
if { [expr {[gui_ck_how_many_open_in_toplevel Hier] > 0}] } {
	set Hier.1 [lindex [gui_get_window_ids -type Hier -active_parent] 0]
} else {
	gui_open_window Hier
set Hier.1 [ gui_get_current_window -view ]
}
set selectedCount [gui_list_get_selected -id ${Hier.1} -count]
if {$selectedCount != 0} {
   set selected [lindex [lindex [gui_list_get_selected -id ${Hier.1} -first] 0] 0]
   gui_list_select -id ${Hier.1}  -current_item_name fsdb_dump_module -current_item_type Scope  $selected 
}
gui_show_window -window ${Hier.1}
gui_list_set_filter -id ${Hier.1} -list { {Package 1} {All 0} {Process 1} {VirtPowSwitch 0} {UnnamedProcess 1} {UDP 0} {Function 1} {Block 1} {SrsnAndSpaCell 0} {OVA Unit 1} {LeafScCell 1} {LeafVlgCell 1} {Interface 1} {LeafVhdCell 1} {$unit 1} {NamedBlock 1} {Task 1} {VlgPackage 1} {ClassDef 1} {VirtIsoCell 0} }
gui_list_set_filter -id ${Hier.1} -text {*}
gui_change_design -id ${Hier.1} -design V1
catch {gui_list_select -id ${Hier.1} {fsdb_dump_module}}
gui_view_scroll -id ${Hier.1} -vertical -set 0
gui_view_scroll -id ${Hier.1} -horizontal -set 0
#</Session>

