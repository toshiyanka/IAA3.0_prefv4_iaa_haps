source $env(TARGET_DIR)/protocompiler_commands/database_load.tcl
source $env(TARGET_DIR)/protocompiler_commands/options.tcl

if {[info exists ::env(ENABLE_CDPL)] && $env(ENABLE_CDPL) == 1 && [file exists $env(TARGET_DIR)/vendor_distrib_src/cdpl_hostfile_HapsPreInstrument.txt]} {
    set env(CDPL_FPGA_HOST) $env(TARGET_DIR)/vendor_distrib_src/cdpl_hostfile_HapsPreInstrument.txt
}

if {[info exists ::env(UNIFIED_COMPILE)] && [string compare $env(UNIFIED_COMPILE) ""] != 0} {
# support for haps_uc 2.0
    launch uc -utf project.utf -ucdb vcs_output.db -v $env(UNIFIED_COMPILE)
    if {[catch { run pre_instrument -ucdb vcs_output.db -out pre_instrument} err ]} {
        puts "@E pre_instrument stage failed"
        export report -path $env(TARGET_DIR)/rtl_diag/ -all
        exit [error $err]
    }
} else {
# support for haps_legacy
    if {[catch { run pre_instrument -srclist $env(ANALYZE_INPUTS)/rtl_sources.pfl -top_module $env(top_module_names) -lmf $env(ANALYZE_INPUTS)/project.lmf  -hdl_define {__USELIBGROUPORDER__ __SYN_COMPATIBLE_INCLUDEPATH__} -out pre_instrument} err ]} {
        puts "@E pre_instrument stage failed"
        export report -path $env(TARGET_DIR)/rtl_diag/ -all
        exit [error $err]
    }
}

export report -path $env(TARGET_DIR)/rtl_diag/ -all

source $env(TARGET_DIR)/protocompiler_commands/database_close.tcl
