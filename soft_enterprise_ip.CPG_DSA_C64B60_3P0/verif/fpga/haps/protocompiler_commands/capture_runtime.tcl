source $env(TARGET_DIR)/protocompiler_commands/database_load.tcl
source $env(TARGET_DIR)/protocompiler_commands/options.tcl
source /p/hdk/rtl/proj_dbin/cds/synopsys/protocompiler_utils/common/runtime_capture_1.0.tcl

capture_runtime -vivado_dir vivado_srs
export report -path $env(TARGET_DIR)/rtl_diag/ -all

source $env(TARGET_DIR)/protocompiler_commands/database_close.tcl
