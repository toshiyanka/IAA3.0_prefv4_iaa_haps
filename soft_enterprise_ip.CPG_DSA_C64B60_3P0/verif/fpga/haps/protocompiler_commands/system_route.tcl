source $env(TARGET_DIR)/protocompiler_commands/database_load.tcl
source $env(TARGET_DIR)/protocompiler_commands/options.tcl

# Explicitly set cdpl to 0 because as per Synopsys, the system_route stage cannot be distributed.
option set cdpl 0

database set_state {partition}

if {[catch { run system_route -fdc " $env(FDC_FILE) " -pcf " $env(PCF_FILE) " -effort high -estimate_timing 1 -out system_route} err ]} {
    puts "@E system_route stage failed"
    export report -path $env(TARGET_DIR)/rtl_diag/ -all
    exit [error $err]
}

export report -path $env(TARGET_DIR)/rtl_diag/ -all

source $env(TARGET_DIR)/protocompiler_commands/database_close.tcl
