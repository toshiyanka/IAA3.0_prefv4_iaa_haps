
set verify_generated_clocks 1
set read_sva_assertions 1
set prefer_libs_over_rtl 1
set block_level_analysis 1
set vhdl_relax_lrm_parse 1
set incdirs_are_file_list_specific 1
set turbo 1;                                       # enable multiprocessor support
set verify_generated_clocks 1;                     # enable the verification of generated clocks
set show_combinational_pins_in_failure_stimulus 1; # in verification, determines if the Failure Stimulus should show combinational pins
set skip_gc_alignment_verification 1;              # in verification, determines if alignment between generated clocks should be verified
set skip_min_delay_verification 1;                 # in verification, determines if set_min_delay commands should be verified
set skip_max_delay_verification 1;                 # in verification, determines if set_max_delay commands should be verified
### default settings:
#set additional_register_pin_names {};              # determines extra register pin names recognized in mapping constraints
#set block_level_analysis 0;                        # set this to 1 for block-level and mid-level runs; for SOC-level runs, set this to 0
#set case_analysis_propagate_through_icg 0;         # affects how constants propagate thru ICGs
#set case_analysis_sequential_propagation 0;        # determines whether constants propagate thru sequential elements
#set clock_is_data 0;                               # when 1, RTL is used to determine the waveform on a net on which a generated clock is created; when 0, the specified generated clock waveform is used to determine the waveform on a net on which a generated clock is created
#set convert_y_to_v 0;                              # in parsing RTL, treat all files inside -y directories as if they had been specified using -v
#set dc_compat 1;                                   # do not use DC-compatibility mode when parsing RTL
#set expand_bits 0;                                 # determines if bit-blasting should occur in mapping constraints
#set flattened_hierarchy_separator {_} ;            # specifies the name of a non-standard hierarchy separator in mapping constraints to a netlist
#set generate_all_assertions 0;                     # generate assertions for all failing exceptions
#set identify_sync_cells 0;                         # determines if a synchronizer cell should be automatically detected in verification
#set incdirs_are_file_list_specific 0;              # in a hierarchical file list, determines if incdirs and defines should be considered specific to a library
#set list_all_fails 1;                              # determines if all failing paths should be reported for a failing timing exception during verification
#set max_fails_per_crossing 1000;                   # limits the number of failing paths that are reported per clock crossing in verification
#set max_parallel_processes 4;                      # determines the number of parallel processes allowed when turbo is 1
#set max_passes_per_crossing 1000;                  # limits the number of passing paths that are reported per clock crossing in verification
#set prefer_libs_over_rtl 0;                        # if file list contains both an RTL and Liberty model for a module, determines that the Liberty model should be used instead of RTL
#set read_sva_assertions 0;                         # in exception verification, determines if SVAs embedded in the RTL should be read
#set refocus_case_insensitive 1;                    # in mapping, determines if constraints should be considered case-insensitive
#set report_modes 0;                                # report dominant modes in the design
#set scope_includes_to_file 0;                      # keeps the contents of included RTL files in scope after compiling a System Verilog file
#set show_clock_pins_in_failure_stimulus 0;         # in verification, determines if the Failure Stimulus should show clock pins
#set skip_cross_clock_check 0;                      # determines what type of verification to use for fast-to-slow and slow-to-fast mcps
#set skip_file_sort 0;                              # determines if the file list should be automatically sorted
#set skip_lib_clocks 0;                             # determines if generated clocks defined inside of Liberty models should be read
#set skip_metastable_verification 1;                # determines if verification of metastable endpoints should be performed
#set standard_cell_wrapper {};                      # module names of wrappers around standard cells
#set sv_version 2005;                               # determines System Verilog version to use; possible values are 2005 and 2009
#set timing_disable_recovery_removal_checks 0;      # determines if timing checks on asynchronous set and reset pins of standard cells should be disabled
#set v2k_extensions {};                             # file extensions for System Verilog files; only needed if design contains both Verlog and System Verilog and they must be compiled separately 
#set verify_async_reset_paths 0;                    # determines if paths through asynchronous resets are verified
#set verify_delays_as_mcps 1;                       # in verification, determines if set_min_delay and set_max_delays should be verified as mcp or false paths
#set write_compiled_libraries 0;                    # write compiled libraries for later reuse
