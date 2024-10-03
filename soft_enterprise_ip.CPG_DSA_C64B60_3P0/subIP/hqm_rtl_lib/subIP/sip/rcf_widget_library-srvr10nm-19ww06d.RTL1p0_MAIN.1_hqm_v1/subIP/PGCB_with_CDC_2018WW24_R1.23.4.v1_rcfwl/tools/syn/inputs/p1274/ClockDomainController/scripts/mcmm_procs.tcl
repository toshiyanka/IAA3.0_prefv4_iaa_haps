#
# MCMM related utilities
#

##########################################################################
# Procedure   :    rdt_create_scenarios
#
# Script:  mcmm_procs.tcl
# Description: Create scenarios 
#                   set operating conditions per scenario.
#                   if icc_shell, set tlu tables.
# Inputs      :    Using scenario_mgmnt class for:
#                      list of scenarios
#                      default scenario (current_scenario at the end)
#                      operating conditions of each scenario.
#                         G_var in use by scenario_mgmnt:
#                           G_MCMM_SCENARIOS        - overrides list of scenarios
#                           G_MCMM_PRIMARY_SCENARIO - current_scenario at the end.
#                      operating conditions:
#                           G_ANALYSIS_TYPE - operating_conditions analysis_type
#                           G_MCMM_MAX_OPCON($scenario) - max op_cond, optional, overrides G_MAX_OPCON
#                           G_MCMM_MAX_LIBRARY($scenario) - optional, max library having max op_cond defined.
#                           G_MCMM_MIN_OPCON($scenario) - min op_cond, optional, overrides G_MIN_OPCON
#                           G_MCMM_MIN_LIBRARY($scenario) - optional, min library having min op_cond defined.
#               G_ACTIVE_SCENARIOS - for subset active scenarios, if not set, all scenarios are active.
#
#               TLU related
#                  G_FILL_EMUL_FLOW & G_MAX_TLUPLUS_EMUL_FILE
#                  G_MAX_TLUPLUS_FILE - serve for both min and max tluplus (is it correct?)
#                  G_TLUPLUS_MAP_FILE
#                  
#               
# Returns     : TCL_OK on success
#
# Note        : all_active flag make all scenarios active (ignoring G_ACTIVE_SCENARIOS).
##########################################################################

proc rdt_create_scenarios { args } {
    set arg(-all_active) 0
    set arg(-remove_existing_scenarios) 0
    parse_proc_arguments -args $args arg

    if {[getvar -quiet G_MCMM] != 1} {
        rdt_print_info "in order to run in MCMM mode setvar G_MCMM 1, current run is not in MCMM mode."
        return TCL_OK
    }

    # sourcing MCMM variable setup file.
    rdt_source_if_exists mcmm_config.tcl -require

    # building scenario_mgmnt object
    set inst [::scenario_mgmnt::Instance]

    if { $arg(-remove_existing_scenarios) && ([rdt_get_current_scenario] ne "") } {
        remove_scenario -all
    }

    set cur_scenarios [all_scenarios]
    if {[llength $cur_scenarios] > 0} {
        set_active_scenarios $cur_scenarios
    }

    foreach scenario [$inst getScenarios] {
        if {[lsearch $cur_scenarios $scenario] < 0} {
            create_scenario $scenario
        }
        set cmd [$inst getScenarioOperatingConditionCommand $scenario]
        rdt_print_info "Setting operating conditions for $scenario by \"$cmd\""
        eval $cmd
        ## Setting tluplus file also for DC, when openning library defined with no scenario, when defining a scenario it get lost.
        if {[getvar G_FILL_EMUL_FLOW] == 1} {
            set_tlu_plus_files -max_tluplus [getvar G_MAX_TLUPLUS_FILE] -min_tluplus [getvar G_MAX_TLUPLUS_FILE] \
                -tech2itf_map [getvar G_TLUPLUS_MAP_FILE] \
                -max_emulation_tluplus [getvar G_MAX_TLUPLUS_EMUL_FILE] -min_emulation_tluplus [getvar G_MAX_TLUPLUS_EMUL_FILE]
        } else {
            set_tlu_plus_files -max_tluplus [getvar G_MAX_TLUPLUS_FILE] -min_tluplus [getvar G_MAX_TLUPLUS_FILE] \
                -tech2itf_map [getvar G_TLUPLUS_MAP_FILE]
        }
        ## Setting scenario options 
        set cmd [$inst getScenarioOptions $scenario]
        rdt_print_info "Setting scenario option: \"$cmd\"" 
        eval $cmd 
    }

    if {(! $arg(-all_active)) && [getvar -quiet G_ACTIVE_SCENARIOS] ne ""} {
        set_active_scenarios [getvar G_ACTIVE_SCENARIOS]
    }
    current_scenario [$inst getDefaultScenario]
    return TCL_OK
} ;# rdt_create_scenarios

if [info exists synopsys_program_name] {
    define_proc_attributes rdt_create_scenarios \
        -info "create scenarios according to G_MCMM_SCENARIOS, G_MCMM_PRIMARY_SCENARIO, G_ACTIVE_SCENARIOS." \
        -define_args {
            { -remove_existing_scenarios "start with removing existing scenarios" "" boolean optional}
            { -all_active "leave all scenarios active regardless G_ACTIVE_SCENARIOS setvar" "" boolean optional}
        }
}


##########################################################################
# Procedure   :    rdt_get_current_scenario
#
# Script:  mcmm_procs.tcl
#
# Description:     Returns current scenario
#
# Inputs      :    current_scenario returns value via redirect ...
#
# Returns     :    current scenario name (or empty string if no scenario).
#
# Note        :    
##########################################################################

proc rdt_get_current_scenario { args } { 
    parse_proc_arguments -args $args arg

    set ret ""
    if {[info commands current_scenario] == "current_scenario"} {
        redirect -variable xyz {current_scenario}
        regexp {Current scenario is:\s+(\S+)} $xyz _ ret
    }
    return $ret
}

if [info exists synopsys_program_name] {
    define_proc_attributes rdt_get_current_scenario \
        -info "returns current scenario or empty string if no scenario." \
        -define_args {
        }
}

##########################################################################
# Procedure   :    rdt_run_for_all_scenarios
#
# Script:  mcmm_procs.tcl
#
# Description:     Run given op for all scenarios.
#                  If no scenario defined, error out.
#
# Inputs      :    op - scenario dependent operation to run for all scenarios.
#
# Returns     :    none
#
# Note        :    
##########################################################################

proc rdt_run_for_all_scenarios { op } {
    parse_proc_arguments -args $op arg

    set all [all_scenarios]
    set active     [all_active_scenarios]
    set non_active [lminus $all $active]

    set origin_current_scenario [rdt_get_current_scenario]
    if { $origin_current_scenario eq "" } {
        rdt_print_error "no scenario define, \"rdt_run_for_all_scenarios $args\" will error out"
        error "rdt_run_for_all_scenarios: no scenario defined, should not reach this point."
    }

    set need_set_active 0
    if { [llength $non_active] > 0 } {
        set need_set_active 1
        set_active_scenarios [all_scenarios]
    }
    set orig_search_path   [get_app_var search_path]
    set orig_g_search_path [getvar G_SCRIPTS_SEARCH_PATH]

    # foreach scenario, set search_path and G_SCRIPTS_SEARCH_PATH, set current scenario, call operatin with -scenario $scenario
    foreach scenario $all {
        current_scenario $scenario
        set add_path [list]
        foreach sp [getvar -quiet G_MCMM_CONSTRAINT_SEARCH_PATH($scenario)] {
            lappend add_path [file normalize $sp]
        }
        setvar G_SCRIPTS_SEARCH_PATH [concat $add_path $orig_g_search_path]
        set_app_var search_path [concat $add_path $orig_search_path]
        set cmd "$op -scenario $scenario"
        rdt_print_info "about to eval \"$cmd\""
        eval $cmd
    }

    if { $need_set_active } {
        set_active_scenarios $active
    }
    current_scenario $origin_current_scenario
    set_app_var search_path      $orig_search_path
    setvar G_SCRIPTS_SEARCH_PATH $orig_g_search_path
} ;# rdt_run_for_all_scenarios

if [info exists synopsys_program_name] {
    define_proc_attributes rdt_run_for_all_scenarios \
        -info "foreach scenario, setting search path and calling given operation with -scenario \$scenario." \
        -define_args {
            {op "operation to run under each scenario" op string required}
        }
}

proc rdt_scenario_constraints { args } {
    parse_proc_arguments -args $args arg

    set all [all_scenarios]
    set active     [all_active_scenarios]
    set non_active [lminus $all $active]

    set need_set_active 0
    if { [llength $non_active] > 0 } {
        set need_set_active 1
        set_active_scenarios [all_scenarios]
    }

    set origin_current_scenario [rdt_get_current_scenario]
    if { $origin_current_scenario ne "" } {
        rdt_print_info "Executing rdt_scenario_constraints"
        foreach scenario [all_active_scenarios] {
            rdt_print_info "Set timing constraints for $scenario scenario" 
        
            ## Call procedure to source timing constraints
            rdt_timing_constraints -scenario $scenario 
            rdt_mbist_constraints  -scenario $scenario
            rdt_lbist_constraints  -scenario $scenario


            ### Loading Visa specific timing constraints
            rdt_constrain_visa_logic -scenario $scenario

            ## load clock stamping for ctmesh if exists
            if {[getvar -quiet G_RDT_PROJECT_TYPE] eq "core"} {
                set status [rdt_source_if_exists [getvar G_DESIGN_NAME].${scenario}.stamp_clock_network.sdc]
                if {$status == 0} {
                    stamp_clock_network -scenario $scenario -sdc_file \
                        ./outputs/[getvar G_DESIGN_NAME].${scenario}.stamp_clock_network.sdc 
                }
            }
            if { [get_app_var synopsys_program_name] eq "icc_shell" } {
                apr_create_path_groups -scenario $scenario
            } else {
                syn_create_path_groups -scenario $scenario
            }
    
     
            ## Set up the voltage for the scenario. 
            if { [getvar -quiet G_UPF] == 1 } { 
                set cmd "set_voltage [getvar G_MCMM_VOLTAGE_MAP($scenario,default)] -object_list *"
                rdt_print_info "evaluating \"$cmd\""
                eval $cmd

                ## Loading scenario set_voltage file which set voltage for different supply net. 
                setvar G_SCENARIO $scenario  
                rdt_source_if_exists [getvar {G_DESIGN_NAME}]_set_voltage.tcl 
            } 

            if { ([get_app_var synopsys_program_name] eq "icc_shell") && ([getvar G_TIMING_DERATE] == 1) } {

                ## Setting timing derate for clock and data path cells in MCMM 
                ## user has to set G_TIMING_DERATE variable to 1 to account the derating factors
                ## The default factors are defined in default_config.tcl.

                apr_timing_derate -scenario $scenario
        
            } 
        } 

        if { [get_app_var synopsys_program_name] eq "icc_shell" } {
            ## Setting clock treek options
            set option_str [list] 
            if { [getvar -quiet -names G_MCMM_CLOCK_TREE_OPTIONS] ne "" && [getvar -names G_MCMM_CLOCK_TREE_OPTIONS] ne "" } { 
                foreach opt [getvar -names G_MCMM_CLOCK_TREE_OPTIONS] {
                    append option_str "-${opt} \"[getvar G_MCMM_CLOCK_TREE_OPTIONS($opt)]\" "
                } 
            
                if { $option_str ne "" } { 
                    set cmd "set_clock_tree_options $option_str" 
                    rdt_print_info "Set clock tree options: $cmd"
                    eval $cmd 
                } 
            } 
        }
    } else { 
        rdt_print_info " no scenario is not defined, rdt_scenario_constraints do nothing."
    } 
} ;# rdt_scenario_constraints

if [info exists synopsys_program_name] {
    define_proc_attributes rdt_scenario_constraints \
        -info "set constraints per each scenario including rdt_timing_constraints, rdt_mbist_constraints, rdt_lbist_constraints, rdt_constrain_visa_logic, and more." \
        -define_args {
        }
}

##########################################################################
# Procedure   :    rdt_set_voltage
#
# Script:  mcmm_procs.tcl
#
# Description:     * Run set voltage commands considering MCMM.
#                  * In case scenarios are defined, run via rdt_run_for_all_scenarios wrapper.
#                  * Expecting [getvar {G_DESIGN_NAME}]_set_voltage.tcl under scenario dependent 
#                    area to be sourced for set_voltage lines in UPF file.
#
# Inputs      :     G_UPF, G_MCMM_VOLTAGE_MAP, G_MAX_VOLTAGE_MAP, [getvar {G_DESIGN_NAME}]_set_voltage.tcl
#
# Returns     :     TCL_OK
#
# Note        :     Does nothing if (G_UPF != 1)
##########################################################################

proc rdt_set_voltage { args } {
    parse_proc_arguments -args $args arg
    if { [getvar -quiet G_UPF] != 1 } { 
        # nothing to do, no upf run.
		return TCL_OK
	}
	set cur_scenario [rdt_get_current_scenario]
	if {(! [info exists arg(-scenario)]) && ($cur_scenario ne "")} {
	    rdt_run_for_all_scenarios rdt_set_voltage
	} elseif {[info exists arg(-scenario)]} {
		set scenario $arg(-scenario)
		current_scenario $scenario
	    ## Set up the voltage for the scenario. 
        set cmd "set_voltage [getvar G_MCMM_VOLTAGE_MAP($scenario,default)] -object_list *"
        rdt_print_info "evaluating \"$cmd\""
        eval $cmd

        ## Loading scenario set_voltage file which set voltage for different supply net. 
        setvar G_SCENARIO $scenario  
        rdt_source_if_exists [getvar {G_DESIGN_NAME}]_set_voltage.tcl 
		current_scenario $cur_scenario
	} else { ;# no scenario
        # Setting voltage after sourcing upf file
        if {[getvar -quiet -names G_MAX_VOLTAGE_MAP] != "" } {
            rdt_print_info "Setting up UPF voltage value per power domain using set_voltage command"
            set_voltage [getvar G_MAX_VOLTAGE_MAP(default)] -object_list *
            foreach _supply_net [getvar -names G_MAX_VOLTAGE_MAP] {
	            if {$_supply_net != "default"} {
	                set_voltage [getvar G_MAX_VOLTAGE_MAP($_supply_net)] -object_list $_supply_net
                }	
            }
        } else {
            rdt_print_info " G_MAX_VOLTAGE_MAP() is not defined. Ignore setting up voltage for power domain"
        }
	}
	return TCL_OK
}

if [info exists synopsys_program_name] {
    define_proc_attributes rdt_set_voltage \
        -info "set voltage per each scenario ..." \
        -define_args {
            { -scenario "run for scenario" scenario string optional}
        }
}

##########################################################################
# Procedure   :    rdt_get_default_scenario
#
# Script:  mcmm_procs.tcl
#
# Description:     * Call 
#
# Inputs      :     
#
# Returns     :     Default scenario by spec.
#
# Note        :     
##########################################################################

proc rdt_get_default_scenario { args } {
    parse_proc_arguments -args $args arg

    set inst [::scenario_mgmnt::Instance]
	return [$inst getDefaultScenario]
} ;# rdt_get_default_scenario

if [info exists synopsys_program_name] {
    define_proc_attributes rdt_get_default_scenario \
        -info "returns default scenario name (by spec)" \
        -define_args {
        }
}

