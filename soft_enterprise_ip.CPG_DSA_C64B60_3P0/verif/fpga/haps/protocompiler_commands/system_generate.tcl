source $env(TARGET_DIR)/protocompiler_commands/database_load.tcl

source $env(TARGET_DIR)/protocompiler_commands/options.tcl

if {[info exists ::env(ENABLE_CDPL)] && $env(ENABLE_CDPL) == 1 && [file exists $env(TARGET_DIR)/vendor_distrib_src/cdpl_hostfile_HapsSystemGenerate.txt]} {
    set env(CDPL_FPGA_HOST) [file normalize $env(TARGET_DIR)/vendor_distrib_src/cdpl_hostfile_HapsSystemGenerate.txt]
}

database set_state {system_route}

if {[catch { run system_generate -path $env(TARGET_DIR)/db_individual_fpga -fdc "$env(FDC_FILE)" -verilog 0 -database 1 -out system_generate} err ]} {
    puts "@E system_generate stage failed"
    export report -path $env(TARGET_DIR)/rtl_diag/ -all
    exit [error $err]
}


export report -path $env(TARGET_DIR)/rtl_diag/ -all

source $env(TARGET_DIR)/protocompiler_commands/database_close.tcl

