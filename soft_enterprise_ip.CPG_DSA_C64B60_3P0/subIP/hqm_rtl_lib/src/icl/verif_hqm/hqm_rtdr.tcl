# Begin_DVE_Session_Save_Info
# DVE full session
# Saved on Fri Mar 12 07:27:03 2021
# Designs open: 1
#   V1: target/patterns/dump.vpd
# Toplevel windows open: 2
# 	TopLevel.1
# 	TopLevel.2
#   Source.1: hqm_hqm_basic_tap_tests_v_ctl
#   Wave.1: 62 signals
#   Group count = 7
#   Group IOSFSB_ISM signal count = 10
#   Group IOSFSB_ISM outputs signal count = 20
#   Group TAPCONFIG signal count = 10
#   Group TAPCONFIG outputs signal count = 8
#   Group TAPTRIGGER signal count = 10
#   Group TAPTRIGGER outputs signal count = 5
#   Group TAPTRIGGER mask functional load signal count = 4
# End_DVE_Session_Save_Info

# DVE version: P-2019.06-SP2-2_Full64
# DVE build date: Mar  3 2020 20:42:54


#<Session mode="Full" path="/nfs/sc/disks/sdg74_3369/users/jamescle/debug-wave4/tools/icl/verif_hqm/hqm_rtdr.tcl" type="Debug">

gui_set_loading_session_type Post
gui_continuetime_set

# Close design
if { [gui_sim_state -check active] } {
    gui_sim_terminate
}
gui_close_db -all
gui_expr_clear_all

# Close all windows
gui_close_window -type Console
gui_close_window -type Wave
gui_close_window -type Source
gui_close_window -type Schematic
gui_close_window -type Data
gui_close_window -type DriverLoad
gui_close_window -type List
gui_close_window -type Memory
gui_close_window -type HSPane
gui_close_window -type DLPane
gui_close_window -type Assertion
gui_close_window -type CovHier
gui_close_window -type CoverageTable
gui_close_window -type CoverageMap
gui_close_window -type CovDetail
gui_close_window -type Local
gui_close_window -type Stack
gui_close_window -type Watch
gui_close_window -type Group
gui_close_window -type Transaction



# Application preferences
gui_set_pref_value -key app_default_font -value {Helvetica,10,-1,5,50,0,0,0,0,0}
gui_src_preferences -tabstop 8 -maxbits 24 -windownumber 1
#<WindowLayout>

# DVE top-level session


# Create and position top-level window: TopLevel.1

if {![gui_exist_window -window TopLevel.1]} {
    set TopLevel.1 [ gui_create_window -type TopLevel \
       -icon $::env(DVE)/auxx/gui/images/toolbars/dvewin.xpm] 
} else { 
    set TopLevel.1 TopLevel.1
}
gui_show_window -window ${TopLevel.1} -show_state normal -rect {{414 193} {2169 1240}}

# ToolBar settings
gui_set_toolbar_attributes -toolbar {TimeOperations} -dock_state top
gui_set_toolbar_attributes -toolbar {TimeOperations} -offset 0
gui_show_toolbar -toolbar {TimeOperations}
gui_hide_toolbar -toolbar {&File}
gui_set_toolbar_attributes -toolbar {&Edit} -dock_state top
gui_set_toolbar_attributes -toolbar {&Edit} -offset 0
gui_show_toolbar -toolbar {&Edit}
gui_hide_toolbar -toolbar {CopyPaste}
gui_set_toolbar_attributes -toolbar {&Trace} -dock_state top
gui_set_toolbar_attributes -toolbar {&Trace} -offset 0
gui_show_toolbar -toolbar {&Trace}
gui_hide_toolbar -toolbar {TraceInstance}
gui_hide_toolbar -toolbar {BackTrace}
gui_set_toolbar_attributes -toolbar {&Scope} -dock_state top
gui_set_toolbar_attributes -toolbar {&Scope} -offset 0
gui_show_toolbar -toolbar {&Scope}
gui_set_toolbar_attributes -toolbar {&Window} -dock_state top
gui_set_toolbar_attributes -toolbar {&Window} -offset 0
gui_show_toolbar -toolbar {&Window}
gui_set_toolbar_attributes -toolbar {Signal} -dock_state top
gui_set_toolbar_attributes -toolbar {Signal} -offset 0
gui_show_toolbar -toolbar {Signal}
gui_set_toolbar_attributes -toolbar {Zoom} -dock_state top
gui_set_toolbar_attributes -toolbar {Zoom} -offset 0
gui_show_toolbar -toolbar {Zoom}
gui_set_toolbar_attributes -toolbar {Zoom And Pan History} -dock_state top
gui_set_toolbar_attributes -toolbar {Zoom And Pan History} -offset 0
gui_show_toolbar -toolbar {Zoom And Pan History}
gui_set_toolbar_attributes -toolbar {Grid} -dock_state top
gui_set_toolbar_attributes -toolbar {Grid} -offset 0
gui_show_toolbar -toolbar {Grid}
gui_hide_toolbar -toolbar {Simulator}
gui_hide_toolbar -toolbar {Interactive Rewind}
gui_hide_toolbar -toolbar {Testbench}

# End ToolBar settings

# Docked window settings
set Console.1 [gui_create_window -type Console -parent ${TopLevel.1} -dock_state bottom -dock_on_new_line true -dock_extent 105]
gui_set_window_pref_key -window ${Console.1} -key dock_width -value_type integer -value 1758
gui_set_window_pref_key -window ${Console.1} -key dock_height -value_type integer -value 105
gui_set_window_pref_key -window ${Console.1} -key dock_offset -value_type integer -value 0
gui_update_layout -id ${Console.1} {{left 0} {top 0} {width 1755} {height 105} {dock_state bottom} {dock_on_new_line true}}
#### Start - Readjusting docked view's offset / size
set dockAreaList { top left right bottom }
foreach dockArea $dockAreaList {
  set viewList [gui_ekki_get_window_ids -active_parent -dock_area $dockArea]
  foreach view $viewList {
      if {[lsearch -exact [gui_get_window_pref_keys -window $view] dock_width] != -1} {
        set dockWidth [gui_get_window_pref_value -window $view -key dock_width]
        set dockHeight [gui_get_window_pref_value -window $view -key dock_height]
        set offset [gui_get_window_pref_value -window $view -key dock_offset]
        if { [string equal "top" $dockArea] || [string equal "bottom" $dockArea]} {
          gui_set_window_attributes -window $view -dock_offset $offset -width $dockWidth
        } else {
          gui_set_window_attributes -window $view -dock_offset $offset -height $dockHeight
        }
      }
  }
}
#### End - Readjusting docked view's offset / size
gui_sync_global -id ${TopLevel.1} -option true

# MDI window settings
set HSPane.1 [gui_create_window -type {HSPane}  -parent ${TopLevel.1}]
if {[gui_get_shared_view -id ${HSPane.1} -type Hier] == {}} {
        set Hier.1 [gui_share_window -id ${HSPane.1} -type Hier]
} else {
        set Hier.1  [gui_get_shared_view -id ${HSPane.1} -type Hier]
}

gui_show_window -window ${HSPane.1} -show_state normal -rect {{0 0} {874 818}}
gui_update_layout -id ${HSPane.1} {{left 0} {top 0} {width 879} {height 843} {show_state normal} {dock_state undocked} {dock_on_new_line false} {child_hier_colhier 517} {child_hier_coltype 354} {child_hier_colpd 0} {child_hier_col1 0} {child_hier_col2 1} {child_hier_col3 -1}}
set DLPane.1 [gui_create_window -type {DLPane}  -parent ${TopLevel.1}]
if {[gui_get_shared_view -id ${DLPane.1} -type Data] == {}} {
        set Data.1 [gui_share_window -id ${DLPane.1} -type Data]
} else {
        set Data.1  [gui_get_shared_view -id ${DLPane.1} -type Data]
}

gui_show_window -window ${DLPane.1} -show_state normal -rect {{0 0} {874 399}}
gui_update_layout -id ${DLPane.1} {{left 873} {top 0} {width 879} {height 424} {show_state normal} {dock_state undocked} {dock_on_new_line false} {child_data_colvariable 458} {child_data_colvalue 193} {child_data_coltype 221} {child_data_col1 0} {child_data_col2 1} {child_data_col3 2}}
set Source.1 [gui_create_window -type {Source}  -parent ${TopLevel.1}]
gui_show_window -window ${Source.1} -show_state normal -rect {{0 0} {874 399}}
gui_update_layout -id ${Source.1} {{left 873} {top 419} {width 879} {height 424} {show_state normal} {dock_state undocked} {dock_on_new_line false}}

# End MDI window settings


# Create and position top-level window: TopLevel.2

if {![gui_exist_window -window TopLevel.2]} {
    set TopLevel.2 [ gui_create_window -type TopLevel \
       -icon $::env(DVE)/auxx/gui/images/toolbars/dvewin.xpm] 
} else { 
    set TopLevel.2 TopLevel.2
}
gui_show_window -window ${TopLevel.2} -show_state normal -rect {{268 169} {2019 1141}}

# ToolBar settings
gui_set_toolbar_attributes -toolbar {TimeOperations} -dock_state top
gui_set_toolbar_attributes -toolbar {TimeOperations} -offset 0
gui_show_toolbar -toolbar {TimeOperations}
gui_hide_toolbar -toolbar {&File}
gui_set_toolbar_attributes -toolbar {&Edit} -dock_state top
gui_set_toolbar_attributes -toolbar {&Edit} -offset 0
gui_show_toolbar -toolbar {&Edit}
gui_hide_toolbar -toolbar {CopyPaste}
gui_set_toolbar_attributes -toolbar {&Trace} -dock_state top
gui_set_toolbar_attributes -toolbar {&Trace} -offset 0
gui_show_toolbar -toolbar {&Trace}
gui_hide_toolbar -toolbar {TraceInstance}
gui_hide_toolbar -toolbar {BackTrace}
gui_set_toolbar_attributes -toolbar {&Scope} -dock_state top
gui_set_toolbar_attributes -toolbar {&Scope} -offset 0
gui_show_toolbar -toolbar {&Scope}
gui_set_toolbar_attributes -toolbar {&Window} -dock_state top
gui_set_toolbar_attributes -toolbar {&Window} -offset 0
gui_show_toolbar -toolbar {&Window}
gui_set_toolbar_attributes -toolbar {Signal} -dock_state top
gui_set_toolbar_attributes -toolbar {Signal} -offset 0
gui_show_toolbar -toolbar {Signal}
gui_set_toolbar_attributes -toolbar {Zoom} -dock_state top
gui_set_toolbar_attributes -toolbar {Zoom} -offset 0
gui_show_toolbar -toolbar {Zoom}
gui_set_toolbar_attributes -toolbar {Zoom And Pan History} -dock_state top
gui_set_toolbar_attributes -toolbar {Zoom And Pan History} -offset 0
gui_show_toolbar -toolbar {Zoom And Pan History}
gui_set_toolbar_attributes -toolbar {Grid} -dock_state top
gui_set_toolbar_attributes -toolbar {Grid} -offset 0
gui_show_toolbar -toolbar {Grid}
gui_hide_toolbar -toolbar {Simulator}
gui_hide_toolbar -toolbar {Interactive Rewind}
gui_hide_toolbar -toolbar {Testbench}

# End ToolBar settings

# Docked window settings
gui_sync_global -id ${TopLevel.2} -option true

# MDI window settings
set Wave.1 [gui_create_window -type {Wave}  -parent ${TopLevel.2}]
gui_show_window -window ${Wave.1} -show_state maximized
gui_update_layout -id ${Wave.1} {{show_state maximized} {dock_state undocked} {dock_on_new_line false} {child_wave_left 508} {child_wave_right 1238} {child_wave_colname 252} {child_wave_colvalue 252} {child_wave_col1 0} {child_wave_col2 1}}

# End MDI window settings

gui_set_env TOPLEVELS::TARGET_FRAME(Source) ${TopLevel.1}
gui_set_env TOPLEVELS::TARGET_FRAME(Schematic) ${TopLevel.1}
gui_set_env TOPLEVELS::TARGET_FRAME(PathSchematic) ${TopLevel.1}
gui_set_env TOPLEVELS::TARGET_FRAME(Wave) none
gui_set_env TOPLEVELS::TARGET_FRAME(List) ${TopLevel.1}
gui_set_env TOPLEVELS::TARGET_FRAME(Memory) ${TopLevel.1}
gui_set_env TOPLEVELS::TARGET_FRAME(DriverLoad) none
gui_update_statusbar_target_frame ${TopLevel.1}
gui_update_statusbar_target_frame ${TopLevel.2}

#</WindowLayout>

#<Database>

# DVE Open design session: 

if { ![gui_is_db_opened -db {target/patterns/dump.vpd}] } {
	gui_open_db -design V1 -file target/patterns/dump.vpd -nosource
}
gui_set_precision 1ps
gui_set_time_units 1ps
#</Database>

# DVE Global setting session: 


# Global: Bus
gui_bus_create -name EXP:FSCAN_TRIGGER_MASK_PM0 {{hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_master.i_hqm_master_core.i_hqm_pm_unit.fscan_trigger_mask[19]} {hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_master.i_hqm_master_core.i_hqm_pm_unit.fscan_trigger_mask[18]} {hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_master.i_hqm_master_core.i_hqm_pm_unit.fscan_trigger_mask[17]} {hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_master.i_hqm_master_core.i_hqm_pm_unit.fscan_trigger_mask[16]} {hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_master.i_hqm_master_core.i_hqm_pm_unit.fscan_trigger_mask[15]} {hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_master.i_hqm_master_core.i_hqm_pm_unit.fscan_trigger_mask[14]} {hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_master.i_hqm_master_core.i_hqm_pm_unit.fscan_trigger_mask[13]} {hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_master.i_hqm_master_core.i_hqm_pm_unit.fscan_trigger_mask[12]} {hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_master.i_hqm_master_core.i_hqm_pm_unit.fscan_trigger_mask[11]} {hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_master.i_hqm_master_core.i_hqm_pm_unit.fscan_trigger_mask[10]}}
gui_bus_create -name EXP:FSCAN_TRIGGER_MASK_PM1 {{hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_master.i_hqm_master_core.i_hqm_pm_unit.fscan_trigger_mask[29]} {hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_master.i_hqm_master_core.i_hqm_pm_unit.fscan_trigger_mask[28]} {hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_master.i_hqm_master_core.i_hqm_pm_unit.fscan_trigger_mask[27]} {hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_master.i_hqm_master_core.i_hqm_pm_unit.fscan_trigger_mask[26]} {hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_master.i_hqm_master_core.i_hqm_pm_unit.fscan_trigger_mask[25]} {hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_master.i_hqm_master_core.i_hqm_pm_unit.fscan_trigger_mask[24]} {hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_master.i_hqm_master_core.i_hqm_pm_unit.fscan_trigger_mask[23]} {hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_master.i_hqm_master_core.i_hqm_pm_unit.fscan_trigger_mask[22]} {hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_master.i_hqm_master_core.i_hqm_pm_unit.fscan_trigger_mask[21]} {hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_master.i_hqm_master_core.i_hqm_pm_unit.fscan_trigger_mask[20]}}
gui_bus_create -name EXP:VIEWPIN_muxsel_bit0 {{hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_AW_viewpin_mux.mux_sel[2]} {hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_AW_viewpin_mux.mux_sel[1]} {hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_AW_viewpin_mux.mux_sel[0]}}
gui_bus_create -name EXP:VIEWPIN_muxsel_bit1 {{hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_AW_viewpin_mux.mux_sel[5]} {hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_AW_viewpin_mux.mux_sel[4]} {hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_AW_viewpin_mux.mux_sel[3]}}
gui_bus_create -name EXP:FSCAN_TRIGGER_MASK_IOSF {{hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_master.i_hqm_master_core.i_hqm_pm_unit.fscan_trigger_mask[9]} {hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_master.i_hqm_master_core.i_hqm_pm_unit.fscan_trigger_mask[8]} {hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_master.i_hqm_master_core.i_hqm_pm_unit.fscan_trigger_mask[7]} {hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_master.i_hqm_master_core.i_hqm_pm_unit.fscan_trigger_mask[6]} {hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_master.i_hqm_master_core.i_hqm_pm_unit.fscan_trigger_mask[5]} {hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_master.i_hqm_master_core.i_hqm_pm_unit.fscan_trigger_mask[4]} {hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_master.i_hqm_master_core.i_hqm_pm_unit.fscan_trigger_mask[3]} {hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_master.i_hqm_master_core.i_hqm_pm_unit.fscan_trigger_mask[2]} {hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_master.i_hqm_master_core.i_hqm_pm_unit.fscan_trigger_mask[1]} {hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_master.i_hqm_master_core.i_hqm_pm_unit.fscan_trigger_mask[0]}}

# Global: Expressions

# Global: Signal Time Shift

# Global: Signal Compare

# Global: Signal Groups
gui_load_child_values {hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_rtdr_tapconfig}
gui_load_child_values {hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_master.i_hqm_master_core.i_hqm_pm_unit}
gui_load_child_values {hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_iosf.i_hqm_iosf_core.i_hqm_iosfsb_core.i_hqm_sbebase}
gui_load_child_values {hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_rtdr_taptrigger}
gui_load_child_values {hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_AW_viewpin_mux}
gui_load_child_values {hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_iosf.i_hqm_iosf_core.i_hqm_iosf_infra_core.i_hqm_iosf_cdcs.i_side_cdc}
gui_load_child_values {hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap}
gui_load_child_values {hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_iosf.i_hqm_iosf_core.i_hqm_iosf_infra_core.i_hqm_iosf_cdcs.i_prim_cdc}
gui_load_child_values {hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_rtdr_iosfsb_ism}
gui_load_child_values {hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_iosf.i_hqm_iosf_core.i_hqm_iosf_infra_core.i_hqm_iosf_gcgu}


set _session_group_5 IOSFSB_ISM
gui_sg_create "$_session_group_5"
set IOSFSB_ISM "$_session_group_5"

gui_sg_addsignal -group "$_session_group_5" { hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.rtdr_iosfsb_ism_trst_b hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.rtdr_iosfsb_ism_tck hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.rtdr_iosfsb_ism_irdec hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.rtdr_iosfsb_ism_shiftdr hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.rtdr_iosfsb_ism_updatedr hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.rtdr_iosfsb_ism_capturedr hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.rtdr_iosfsb_ism_tdi hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.rtdr_iosfsb_ism_tdo hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_rtdr_iosfsb_ism.rtdr_f hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_rtdr_iosfsb_ism.rtdr_upd_f }

set _session_group_6 {IOSFSB_ISM outputs}
gui_sg_create "$_session_group_6"
set {IOSFSB_ISM outputs} "$_session_group_6"

gui_sg_addsignal -group "$_session_group_6" { hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_iosf.i_hqm_iosf_core.i_hqm_iosfsb_core.i_hqm_sbebase.jta_force_idle hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_iosf.i_hqm_iosf_core.i_hqm_iosfsb_core.i_hqm_sbebase.jta_force_notidle hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_iosf.i_hqm_iosf_core.i_hqm_iosfsb_core.i_hqm_sbebase.jta_force_creditreq }
gui_sg_addsignal -group "$_session_group_6" { Divider } -divider
gui_sg_addsignal -group "$_session_group_6" { hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_iosf.i_hqm_iosf_core.i_hqm_iosf_infra_core.i_hqm_iosf_cdcs.i_side_cdc.fismdfx_force_clkreq hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_iosf.i_hqm_iosf_core.i_hqm_iosfsb_core.i_hqm_sbebase.jta_force_clkreq }
gui_sg_addsignal -group "$_session_group_6" { Divider } -divider
gui_sg_addsignal -group "$_session_group_6" { hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_iosf.i_hqm_iosf_core.i_hqm_iosfsb_core.i_hqm_sbebase.jta_clkgate_ovrd hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_iosf.i_hqm_iosf_core.i_hqm_iosf_infra_core.i_hqm_iosf_gcgu.force_idle hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_iosf.i_hqm_iosf_core.i_hqm_iosf_infra_core.i_hqm_iosf_gcgu.force_notidle hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_iosf.i_hqm_iosf_core.i_hqm_iosf_infra_core.i_hqm_iosf_gcgu.force_creditreq }
gui_sg_addsignal -group "$_session_group_6" { Divider } -divider
gui_sg_addsignal -group "$_session_group_6" { hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_iosf.i_hqm_iosf_core.i_hqm_iosf_infra_core.i_hqm_iosf_cdcs.i_prim_cdc.fismdfx_force_clkreq hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_iosf.i_hqm_iosf_core.i_hqm_iosf_infra_core.i_hqm_iosf_gcgu.force_clkreq hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_master.i_hqm_master_core.i_hqm_pm_unit.cdc_hqm_jta_force_clkreq }
gui_sg_addsignal -group "$_session_group_6" { Divider } -divider
gui_sg_addsignal -group "$_session_group_6" { hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_iosf.i_hqm_iosf_core.i_hqm_iosf_infra_core.i_hqm_iosf_cdcs.i_prim_cdc.fismdfx_clkgate_ovrd hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_master.i_hqm_master_core.i_hqm_pm_unit.cdc_hqm_jta_clkgate_ovrd }
gui_sg_addsignal -group "$_session_group_6" { Divider } -divider
gui_sg_addsignal -group "$_session_group_6" { hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_iosf.i_hqm_iosf_core.i_hqm_iosf_infra_core.i_hqm_iosf_cdcs.i_side_cdc.fismdfx_clkgate_ovrd }

set _session_group_7 TAPCONFIG
gui_sg_create "$_session_group_7"
set TAPCONFIG "$_session_group_7"

gui_sg_addsignal -group "$_session_group_7" { hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.rtdr_tapconfig_trst_b hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.rtdr_tapconfig_tck hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.rtdr_tapconfig_irdec hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.rtdr_tapconfig_shiftdr hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.rtdr_tapconfig_updatedr hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.rtdr_tapconfig_capturedr hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.rtdr_tapconfig_tdi hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.rtdr_tapconfig_tdo hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_rtdr_tapconfig.rtdr_f hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_rtdr_tapconfig.rtdr_upd_f }

set _session_group_8 {TAPCONFIG outputs}
gui_sg_create "$_session_group_8"
set {TAPCONFIG outputs} "$_session_group_8"

gui_sg_addsignal -group "$_session_group_8" { hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_master.i_hqm_master_core.i_hqm_pm_unit.hw_reset_force_pwr_on hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_AW_viewpin_mux.mux_sel EXP:VIEWPIN_muxsel_bit1 EXP:VIEWPIN_muxsel_bit0 hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_master.i_hqm_master_core.i_hqm_pm_unit.fscan_fet_en_sel hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_master.i_hqm_master_core.i_hqm_pm_unit.fscan_fet_on hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_master.i_hqm_master_core.i_hqm_pm_unit.i_hqm_pgcbunit.fdfx_pgcb_ovr hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_master.i_hqm_master_core.i_hqm_pm_unit.i_hqm_pgcbunit.fdfx_pgcb_bypass }

set _session_group_9 TAPTRIGGER
gui_sg_create "$_session_group_9"
set TAPTRIGGER "$_session_group_9"

gui_sg_addsignal -group "$_session_group_9" { hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.rtdr_taptrigger_trst_b hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.rtdr_taptrigger_tck hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.rtdr_taptrigger_irdec hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.rtdr_taptrigger_shiftdr hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.rtdr_taptrigger_updatedr hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.rtdr_taptrigger_capturedr hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.rtdr_taptrigger_tdi hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.rtdr_taptrigger_tdo hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_rtdr_taptrigger.rtdr_f hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_rtdr_taptrigger.rtdr_upd_f }

set _session_group_10 {TAPTRIGGER outputs}
gui_sg_create "$_session_group_10"
set {TAPTRIGGER outputs} "$_session_group_10"

gui_sg_addsignal -group "$_session_group_10" { hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_master.i_hqm_master_core.i_hqm_pm_unit.fscan_trigger_mask_v hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_master.i_hqm_master_core.i_hqm_pm_unit.fscan_trigger_mask EXP:FSCAN_TRIGGER_MASK_PM0 EXP:FSCAN_TRIGGER_MASK_PM1 EXP:FSCAN_TRIGGER_MASK_IOSF }

set _session_group_11 {TAPTRIGGER mask functional load}
gui_sg_create "$_session_group_11"
set {TAPTRIGGER mask functional load} "$_session_group_11"

gui_sg_addsignal -group "$_session_group_11" { hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_master.i_hqm_master_core.i_hqm_pm_unit.aon_clk hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_master.i_hqm_master_core.i_hqm_pm_unit.fscan_trigger_mask_aon_f hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_master.i_hqm_master_core.i_hqm_pm_unit.fscan_trigger_mask_load hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_master.i_hqm_master_core.i_hqm_pm_unit.side_rst_b_aon_sync }

# Global: Highlighting

# Global: Stack
gui_change_stack_mode -mode list

# Post database loading setting...

# Restore C1 time
gui_set_time -C1_only 41780822



# Save global setting...

# Wave/List view global setting
gui_cov_show_value -switch false

# Close all empty TopLevel windows
foreach __top [gui_ekki_get_window_ids -type TopLevel] {
    if { [llength [gui_ekki_get_window_ids -parent $__top]] == 0} {
        gui_close_window -window $__top
    }
}
gui_set_loading_session_type noSession
# DVE View/pane content session: 


# Hier 'Hier.1'
gui_show_window -window ${Hier.1}
gui_list_set_filter -id ${Hier.1} -list { {Package 1} {All 0} {Process 1} {VirtPowSwitch 0} {UnnamedProcess 1} {UDP 0} {Function 1} {Block 1} {SrsnAndSpaCell 0} {OVA Unit 1} {LeafScCell 1} {LeafVlgCell 1} {Interface 1} {LeafVhdCell 1} {$unit 1} {NamedBlock 1} {Task 1} {VlgPackage 1} {ClassDef 1} {VirtIsoCell 0} }
gui_list_set_filter -id ${Hier.1} -text {*}
gui_hier_list_init -id ${Hier.1}
gui_change_design -id ${Hier.1} -design V1
catch {gui_list_expand -id ${Hier.1} hqm_hqm_basic_tap_tests_v_ctl}
catch {gui_list_expand -id ${Hier.1} hqm_hqm_basic_tap_tests_v_ctl.hqm_inst}
catch {gui_list_expand -id ${Hier.1} hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system}
catch {gui_list_expand -id ${Hier.1} hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap}
catch {gui_list_expand -id ${Hier.1} hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_master}
catch {gui_list_expand -id ${Hier.1} hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_master.i_hqm_master_core}
catch {gui_list_select -id ${Hier.1} {hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_master.i_hqm_master_core.i_hqm_pm_unit}}
gui_view_scroll -id ${Hier.1} -vertical -set 300
gui_view_scroll -id ${Hier.1} -horizontal -set 0

# Data 'Data.1'
gui_list_set_filter -id ${Data.1} -list { {Buffer 1} {Input 1} {Others 1} {Linkage 1} {Output 1} {LowPower 1} {Parameter 1} {All 1} {Aggregate 1} {LibBaseMember 1} {Event 1} {Assertion 1} {Constant 1} {Interface 1} {BaseMembers 1} {Signal 1} {$unit 1} {Inout 1} {Variable 1} }
gui_list_set_filter -id ${Data.1} -text {*}
gui_list_show_data -id ${Data.1} {hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_master.i_hqm_master_core.i_hqm_pm_unit}
gui_show_window -window ${Data.1}
catch { gui_list_select -id ${Data.1} {hqm_hqm_basic_tap_tests_v_ctl.hqm_inst.par_hqm_system.hqm_system_aon_wrap.i_hqm_master.i_hqm_master_core.i_hqm_pm_unit.side_rst_b_aon_sync }}
gui_view_scroll -id ${Data.1} -vertical -set 2913
gui_view_scroll -id ${Data.1} -horizontal -set 0
gui_view_scroll -id ${Hier.1} -vertical -set 300
gui_view_scroll -id ${Hier.1} -horizontal -set 0

# Source 'Source.1'
gui_src_value_annotate -id ${Source.1} -switch false
gui_set_env TOGGLE::VALUEANNOTATE 0
gui_open_source -id ${Source.1}  -replace -active hqm_hqm_basic_tap_tests_v_ctl target/patterns/hqm_basic_tap_tests.v
gui_view_scroll -id ${Source.1} -vertical -set 252
gui_src_set_reusable -id ${Source.1}

# View 'Wave.1'
gui_wv_sync -id ${Wave.1} -switch false
set groupExD [gui_get_pref_value -category Wave -key exclusiveSG]
gui_set_pref_value -category Wave -key exclusiveSG -value {false}
set origWaveHeight [gui_get_pref_value -category Wave -key waveRowHeight]
gui_list_set_height -id Wave -height 25
set origGroupCreationState [gui_list_create_group_when_add -wave]
gui_list_create_group_when_add -wave -disable
gui_marker_set_ref -id ${Wave.1}  C1
gui_wv_zoom_timerange -id ${Wave.1} 0 49020002
gui_list_add_group -id ${Wave.1} -after {New Group} {IOSFSB_ISM}
gui_list_add_group -id ${Wave.1} -after {New Group} {{IOSFSB_ISM outputs}}
gui_list_add_group -id ${Wave.1} -after {New Group} {TAPCONFIG}
gui_list_add_group -id ${Wave.1} -after {New Group} {{TAPCONFIG outputs}}
gui_list_add_group -id ${Wave.1} -after {New Group} {TAPTRIGGER}
gui_list_add_group -id ${Wave.1} -after {New Group} {{TAPTRIGGER outputs}}
gui_list_add_group -id ${Wave.1} -after {New Group} {{TAPTRIGGER mask functional load}}
gui_list_collapse -id ${Wave.1} {TAPTRIGGER mask functional load}
gui_list_select -id ${Wave.1} {EXP:FSCAN_TRIGGER_MASK_IOSF }
gui_seek_criteria -id ${Wave.1} {Any Edge}



gui_set_env TOGGLE::DEFAULT_WAVE_WINDOW ${Wave.1}
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
gui_list_set_insertion_bar  -id ${Wave.1} -group {TAPTRIGGER outputs}  -item EXP:FSCAN_TRIGGER_MASK_IOSF -position below

gui_marker_move -id ${Wave.1} {C1} 41780822
gui_view_scroll -id ${Wave.1} -vertical -set 0
gui_show_grid -id ${Wave.1} -enable false
# Restore toplevel window zorder
# The toplevel window could be closed if it has no view/pane
if {[gui_exist_window -window ${TopLevel.1}]} {
	gui_set_active_window -window ${TopLevel.1}
	gui_set_active_window -window ${DLPane.1}
}
if {[gui_exist_window -window ${TopLevel.2}]} {
	gui_set_active_window -window ${TopLevel.2}
	gui_set_active_window -window ${Wave.1}
}
#</Session>

