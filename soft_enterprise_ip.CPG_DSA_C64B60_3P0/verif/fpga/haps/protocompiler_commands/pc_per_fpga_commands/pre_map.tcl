source $env(TARGET_DIR)/protocompiler_commands/$env(FPGA_MODULE)_synth_db_load.tcl

source $env(TARGET_DIR)/protocompiler_commands/options_$env(FPGA_MODULE).tcl
#ANK source $env(TARGET_DIR)/protocompiler_commands/options.tcl

if {[info exists ::env(ENABLE_CDPL)] && $env(ENABLE_CDPL) == 1 && [file exists $env(TARGET_DIR)/vendor_distrib_src/cdpl_hostfile_HapsPreMap.txt]} {
    set env(CDPL_FPGA_HOST) [file normalize $env(TARGET_DIR)/vendor_distrib_src/cdpl_hostfile_HapsPreMap.txt]
}

database set_state {synth_compile}

if {[catch { run pre_map -fdclist $env(TARGET_DIR)/db_individual_fpga/$env(FPGA_MODULE)/fdc_files.txt -out pre_map} err ]} {
    puts "@E pre_map stage failed for $env(FPGA_MODULE) FPGA"
    export report -path $env(TARGET_DIR)/rtl_diag/ -all
    exit [error $err]
}

export report -path $env(TARGET_DIR)/rtl_diag/ -all

source $env(TARGET_DIR)/protocompiler_commands/synth_db_close.tcl
