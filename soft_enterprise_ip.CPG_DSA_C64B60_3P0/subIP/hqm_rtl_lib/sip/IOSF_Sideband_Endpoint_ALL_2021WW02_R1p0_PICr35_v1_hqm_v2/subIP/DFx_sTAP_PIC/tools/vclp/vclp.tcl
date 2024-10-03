

#########################################################################################
# Ace auto-generated VCLP Tcl file for elab and LP Lint
# For 'vc_static_shell' tool
# RUN_DIR: /nfs/iind/disks/dteg_disk008/users/badithya/Spyglass/dteg-stap/target/stap/ADP/aceroot/results/tests/vclp_stap
# Applied filters: Synthesis
# MODEL: stap_vclp_model
# TEST:  stap
######################################################################################### 

set START_TIME [date]

# pre_elab_app_var
set_app_var sh_continue_on_error true
set_app_var enable_verdi_debug true
set_app_var enable_new_filter_logic true
set_app_var sh_command_log_file logs/vcst_command.log

# pre_elab_opts
set search_path "."
set link_library ""
lappend search_path /p/kits/intel/p1273/p1273_14.2.1/stdcells/d04/default/latest/lib/wn
lappend link_library d04_ls_wn_1273_1x1r3_tttt_v075_to_v075_t70_max.ldb
lappend search_path /p/kits/intel/p1273/p1273_14.2.1/stdcells/d04/default/latest/lib/ln
lappend link_library d04_ls_ln_1273_1x1r3_tttt_v075_to_v075_t70_max.ldb
lappend search_path /p/kits/intel/p1273/p1273_14.2.1/stdcells/d04/default/latest/lib/nn
lappend link_library d04_ls_nn_1273_1x1r3_tttt_v075_to_v075_t70_max.ldb
lappend search_path /p/kits/intel/p1273/p1273_14.2.1/stdcells/d04/default/latest/lib/wn
lappend link_library d04_wn_1273_1x1r3_rfff_v075_t70_max.ldb
lappend search_path /p/kits/intel/p1273/p1273_14.2.1/stdcells/d04/default/latest/lib/ln
lappend link_library d04_ln_1273_1x1r3_rfff_v075_t70_max.ldb
lappend search_path /p/kits/intel/p1273/p1273_14.2.1/stdcells/d04/default/latest/lib/nn
lappend link_library d04_nn_1273_1x1r3_rfff_v075_t70_max.ldb

# -vclp_exe_opts
# Load library map file
source inputs/libmaps/vclp_libs.map_stap_vclp_model

# -vclp_converged_elab_opts
source /p/hdk/rtl/proj_tools/vc_methodology_lp/master/1.01.03.18ww08/fe/options/elaborate.tcl 

# Actual elab commands
elaborate -verbose   -vcs " -liblist_work -liblist_nocelldiff  " stap -library stap_rtl_lib
report_blackbox > reports/blackbox.rpt
report_link > reports/elaborate.rpt

# pre_readupf_opts

# Actual read_upf commands
read_upf /nfs/iind/disks/dteg_disk008/users/badithya/Spyglass/dteg-stap/target/stap/ADP/aceroot/tools/upf/upf_2.0/stap.upf -dumpupf
report_read -verbose > reports/read_upf.rpt

# -vclp_converged_rulesets 
 
source /p/hdk/rtl/proj_tools/vc_methodology_lp/master/1.01.03.18ww08/fe/rules/power_verif_noninstr-mixed.tcl 

# pre_check_opts

# Actual LP Lint check commands
#Check is enabled through ivar. It will be run UNLESS methodology override is explicitly set to NOT ENABLE
if {![info exists G_VCLP_ENABLE_CHECK_LP_UPF] || $G_VCLP_ENABLE_CHECK_LP_UPF} {
puts "Running check_lp for upf stage"
check_lp -stage upf  -family {all} 
}
#Check is enabled through ivar. It will be run UNLESS methodology override is explicitly set to NOT ENABLE
if {[info exists G_VCLP_ENABLE_CHECK_LP_DESIGN] && $G_VCLP_ENABLE_CHECK_LP_DESIGN} {
puts "Running check_lp for design stage"
check_lp -stage design  -family {all} 
}
#Check is enabled through ivar. It will be run UNLESS methodology override is explicitly set to NOT ENABLE
if {[info exists G_VCLP_ENABLE_CHECK_LP_PG] && $G_VCLP_ENABLE_CHECK_LP_PG} {
puts "Running check_lp for pg stage"
check_lp -stage pg  -family {all} 
}

# Generate LP Lint reports
compress_lp -disable_all
report_lp -verbose -file reports/uncompressed.rpt -limit 0
report_lp -only_waived -verbose -file reports/waived_uncompressed.rpt -limit 0
compress_lp -enable_all
report_lp -verbose -file reports/compressed.rpt
report_lp -only_waived -verbose -file reports/waived_compressed.rpt
set WARNING_COUNT 0
set ERROR_COUNT 0
set WARNING_VIOLATION 0
set ERROR_VIOLATION 0

# -vclp_converged_reports 
 
source /p/hdk/rtl/proj_tools/vc_methodology_lp/master/1.01.03.18ww08/fe/options/report.tcl 
foreach tag [get_violation_tags] {
        set info [get_tag_info $tag]
        set sev   [lindex $info 1]
        if { $sev eq {error} } { 
            set count [lindex $info 5]
            set count [expr { $count - [lindex $info 6] } ]
            incr ERROR_VIOLATION $count     
        }
        if { $sev eq {warning} } { 
            set count [lindex $info 5]
            set count [expr { $count - [lindex $info 6] } ]
            incr WARNING_VIOLATION $count     
        }
}



# Saving VCLP session
if { $ERROR_VIOLATION } {
compress_lp -disable_all
generate_crossovers
save_session -session logs/vclp_final_session
}

# Finish-up
compress_lp -disable_all
report_lp
set WARNING_COUNT [expr { $WARNING_COUNT + [get_message_info -warning_count] } ]
set ERROR_COUNT  [expr { $ERROR_COUNT + [get_message_info -error_count] } ]
set FINISH_TIME [date]
puts "VCST_ERROR_COUNT               -   $ERROR_COUNT"
puts "VCST_WARNING_COUNT             -   $WARNING_COUNT"
puts "VCST_ERROR_VIOLATION_COUNT     -   $ERROR_VIOLATION"
puts "VCST_WARNING_VIOLATION_COUNT   -   $WARNING_VIOLATION"
puts "VCST_START TIME                -   $START_TIME"
puts "VCST_FINISH TIME               -   $FINISH_TIME"
puts "VCLP CHECK COMPLETED"

