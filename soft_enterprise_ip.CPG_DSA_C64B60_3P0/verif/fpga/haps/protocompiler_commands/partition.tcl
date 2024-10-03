source $env(TARGET_DIR)/protocompiler_commands/database_load.tcl
source $env(TARGET_DIR)/protocompiler_commands/options.tcl

# Explicitly set cdpl to 0 because as per Synopsys, the partition stage cannot be distributed.
option set cdpl 0

database set_state {pre_partition}

if {[catch { run partition -fdc "$env(FDC_FILE)" -pcf "$env(PCF_FILE)" -clock_gate_replication 1 -effort high -report_timing_paths 1024 -optimization_priority multi_hop_path -feedthrough_reduction high -report_unconstrained ports -out partition} err ]} {
    puts "@E partition stage failed"
    export report -path $env(TARGET_DIR)/rtl_diag/ -all
    exit [error $err]
}


export report -path $env(TARGET_DIR)/rtl_diag/ -all

source $env(TARGET_DIR)/protocompiler_commands/database_close.tcl

