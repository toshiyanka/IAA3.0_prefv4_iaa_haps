source $env(TARGET_DIR)/protocompiler_commands/database_load.tcl
source $env(TARGET_DIR)/protocompiler_commands/options.tcl

if {[info exists ::env(ENABLE_CDPL)] && $env(ENABLE_CDPL) == 1 && [file exists $env(TARGET_DIR)/vendor_distrib_src/cdpl_hostfile_HapsPrePartition.txt]} {
    set env(CDPL_FPGA_HOST) [file normalize $env(TARGET_DIR)/vendor_distrib_src/cdpl_hostfile_HapsPrePartition.txt]
}

database set_state {compile}

if {[info exists ::env(NLP)] && $env(NLP) == 1} {
    if {[catch { run pre_partition -tss "$env(TSS_FILE)" -fdc "$env(FDC_FILE)"  -upf "$env(UPF_FILE)" -out pre_partition} err ]} {
        puts "@E pre_partition stage failed"
        export report -path $env(TARGET_DIR)/rtl_diag/ -all
        exit [error $err]
    }
} else {
    if {[catch { run pre_partition -tss "$env(TSS_FILE)" -fdc "$env(FDC_FILE)"  -out pre_partition} err ]} {
        puts "@E pre_partition stage failed"
        export report -path $env(TARGET_DIR)/rtl_diag/ -all
        exit [error $err]
    }
}

if {[info exists ::env(AREA_ESTIMATION)] && $env(AREA_ESTIMATION) == 1} {
    if {[file exists $env(TARGET_DIR)/protocompiler_commands/area_estimation.tcl ]} {
        puts "Sourcing Area_estimation.tcl"
        source $env(TARGET_DIR)/protocompiler_commands/area_estimation.tcl
    }
}

export report -path $env(TARGET_DIR)/rtl_diag/ -all

source $env(TARGET_DIR)/protocompiler_commands/database_close.tcl
