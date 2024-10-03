option set debug_dumpvars 1
option set advanced_synthesis 0
option set allow_duplicate_modules 0
option set auto_constrain_io 0
option set auto_export_reports 1
option set auto_infer_blackbox 1 
option set automatic_compile_point 0
option set beta_vfeatures 1 
option set beta_vhfeatures 1
option set bindandforce 1 
option set cdpl 0
option set compiler_compatible 0
option set compress_netlist_for_vivado 1
option set continue_on_error 1
option set dc_root /p/hdk/rtl/cad/x86-64_linux26/synopsys/designcompiler/O-2018.06-SP5 
option set design_flow partition
option set disable_io_insertion 0
option set distributed_compile 0 
option set distributed_synthesis 1
option set dw_foundation 1 
option set dw_minpower 0
option set dw_stop_on_nolic 1
option set enable_clock_tree_extraction 1
#ANK pre_packing disabled for FPGA D
option set enable_prepacking 0 
option set enable_upf_1_0_applies_to_default_outputs 0
option set fast_synthesis 0
option set fix_gated_and_generated_clocks 1
option set force_async_genclk_conv 1
option set hier_verification auto
option set hier_verification_percent 0
option set incremental_synthesis 0
option set latchram 0 
option set libext {}
option set looplimit 8000
option set max_parallel_jobs 8 
option set max_parallel_par_explorer 8
option set maxfan 100000
option set merge_inferred_clocks 1
option set multi_file_compilation_unit 1
option set no_constraint_check 0
option set no_sequential_opt 0
option set optimize_ngc 1
option set pipe 1
option set prepare_readback 0
option set resolve_multiple_driver 0  
option set resource_sharing 1
option set retiming 0
option set rw_check_on_ram 1
option set speed_grade -1-c
option set support_implicit_init_netlist 0
option set supporttypedflt 0
option set symbolic_fsm_compiler 1
option set synthesis_onoff_pragma 1
option set synthesis_strategy advanced 
#ANK option set synthesis_strategy routability 
option set upf_iso_filter_elements_with_applies_to enable
option set upf_verbose 0
option set verification_mode 0
option set vhdl2008 0
option set view_report_on_error 0
option set vlog_std sysv
option set write_verilog 0 
option set distributed_global_opt 0
message_override -warning DE107



if {[string compare $env(HARDWARE) HAPS-100] == 0} {
# Put HAPS-100 specific options here
    option set dw_minpower 0
    option set dw_stop_on_nolic 0
    option set beta_vfeatures 0
    option set beta_vhfeatures 0
}

if { $env(ENABLE_CDPL) == 1 }  {
# distributed_compile needs to be set to 1 if cdpl has to be enabled.
    option set cdpl 1
    option set distributed_compile 1

    if { $env(CDPL_DISTRIBUTED_SYNTHESIS) == 1 }  {
        option set distributed_synthesis 1
    }

    set env(CDPL_LOGDIR) $env(LOG_DIR)/CDPL_LOGS
}

# User provided configuration options
# source <project-specific-option.tcl>
