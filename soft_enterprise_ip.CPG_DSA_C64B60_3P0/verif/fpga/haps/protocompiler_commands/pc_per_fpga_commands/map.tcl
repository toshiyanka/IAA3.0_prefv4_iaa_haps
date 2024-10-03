source $env(TARGET_DIR)/protocompiler_commands/$env(FPGA_MODULE)_synth_db_load.tcl

#ANK source $env(TARGET_DIR)/protocompiler_commands/options.tcl
source $env(TARGET_DIR)/protocompiler_commands/options_$env(FPGA_MODULE).tcl

if {[info exists ::env(ENABLE_CDPL)] && $env(ENABLE_CDPL) == 1 && [file exists $env(TARGET_DIR)/vendor_distrib_src/cdpl_hostfile_HapsMap.txt]} {
    set env(CDPL_FPGA_HOST) [file normalize $env(TARGET_DIR)/vendor_distrib_src/cdpl_hostfile_HapsMap.txt]
}

database set_state {pre_map}

if {[catch { run map -out map} err ]} {
    puts "@E map stage failed for $env(FPGA_MODULE) FPGA"
    export report -path $env(TARGET_DIR)/rtl_diag/ -all
    exit [error $err]
}

export report -path $env(TARGET_DIR)/rtl_diag/ -all
export vivado -path $env(TARGET_DIR)/db_individual_fpga/$env(FPGA_MODULE)/vivado_srs

source $env(TARGET_DIR)/protocompiler_commands/synth_db_close.tcl
