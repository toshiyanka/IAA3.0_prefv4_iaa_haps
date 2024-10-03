source $env(TARGET_DIR)/protocompiler_commands/$env(FPGA_MODULE)_synth_db_load.tcl
source $env(TARGET_DIR)/protocompiler_commands/options.tcl

# synth_compile is very lightweight (takes only 1-2 mins to execute) and passing the CDPL host file
# to this stage might result in the job waiting in queue for longer than the execution time. So
# Synopsys recommended against passing CDPL host file to synth_compile because of the low ROI.
option set cdpl 0

if {[catch { run compile -srclist $env(TARGET_DIR)/db_individual_fpga/$env(FPGA_MODULE)/src_srs.txt -top_module "TraceBuildLib.$env(FPGA_MODULE)" -cdclist $env(TARGET_DIR)/db_individual_fpga/$env(FPGA_MODULE)/cdc_files.txt -out synth_compile} err ]} {
    puts "@E synth_compile stage failed for $env(FPGA_MODULE) FPGA"
    export report -path $env(TARGET_DIR)/rtl_diag/ -all
    exit [error $err]
}

export report -path $env(TARGET_DIR)/rtl_diag/ -all

source $env(TARGET_DIR)/protocompiler_commands/synth_db_close.tcl
