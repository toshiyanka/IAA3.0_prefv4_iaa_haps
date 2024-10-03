###Clean up G_SCRIPTS_SEARCH_PATH in case it has any lists in it instead of just strings###
set tmp_search_path [list]
foreach checkpath [getvar G_SCRIPTS_SEARCH_PATH] {
    if {[llength $checkpath] == 1} {
        lappend tmp_search_path $checkpath
    } else {
        foreach path_in_list $checkpath {
            if {[llength $path_in_list] == 1} {
                lappend tmp_search_path $path_in_list
            } else {
                foreach path_deep_in_list $path_in_list {
                    if {[llength $path_deep_in_list] == 1} {
                        lappend tmp_search_path $path_deep_in_list
                    } else {
                        puts "-E- G_SCRIPTS_SEARCH_PATH has too many levels of nested lists inside it....should just be a list of directories!"
                    }
                }
            }
        }
    }
}
setvar G_SCRIPTS_SEARCH_PATH $tmp_search_path
lappend_var G_SCRIPTS_SEARCH_PATH $env(WARD)/clk_cfg

# enable uniquification
set G_ENABLE_UNIQUIFIED 1

# remove extra reports
foreach stage [array names G_SYN_REPORTS] {
  set G_SYN_REPORTS($stage) [lminus $G_SYN_REPORTS($stage) caliber ]
  set G_SYN_REPORTS($stage) [lminus $G_SYN_REPORTS($stage) back2back_inverters ]
  set G_SYN_REPORTS($stage) [lminus $G_SYN_REPORTS($stage) back2back_buffers ]
  set G_SYN_REPORTS($stage) [lminus $G_SYN_REPORTS($stage) missing_clock_sources ]
}

lappend G_SYN_REPORTS(syn_final) check_mv_design

set G_NON_POWER_SAIF 0
set G_SAIF_ENABLE 0
set G_RUNNING_PAR 0
set G_INSERT_CLOCK_GATING 0
set G_SKIP [list saif constraints.syn_power_constraints compile.syn_power_constraints syn_final.syn_power_constraints]
set G_SPG_FLOW 0
set G_CONGESTION_OPTIMIZE 0
set G_DATAPATH_DESIGN 0
set G_LVT 0

# need below line because DC cannot map all flops and fails
set G_SCAN_REPLACE_FLOPS 1
set G_INSERT_SCAN 1
set G_INSERT_CLOCK_GATING 0

set G_SYN_REPORTS(dont_use) ""
set G_SYN_REPORTS(saif) ""
set G_SYN_REPORTS(uniquify) ""
set G_SYN_REPORTS(floorplan) ""
set G_SYN_REPORTS(upf) ""
set G_SYN_REPORTS(constraints) ""
set G_SYN_REPORTS(compile) ""

set G_SYN_OUTPUTS(import_design) "ddc verilog"
set G_SYN_OUTPUTS(dont_use) ""
set G_SYN_OUTPUTS(saif) ""
set G_SYN_OUTPUTS(uniquify) "ddc verilog"
set G_SYN_OUTPUTS(floorplan) ""
set G_SYN_OUTPUTS(upf) ""
set G_SYN_OUTPUTS(constraints) ""
set G_SYN_OUTPUTS(compile) "verilog"

# turn off or on UPF
if {[file exists $env(WARD)/collateral/rtl/$G_DESIGN_NAME.upf]} {
   set G_UPF 1
   set G_UPF_FILE $env(WARD)/collateral/rtl/$G_DESIGN_NAME.upf
} else {
   set G_UPF 0
   lappend G_SKIP upf
}

# some old WA
if {[string equal $G_LIBRARY_TYPE b14.5] } {
   set G_POWER_SWITCH_CELL_PATT "b14pwb*"
   set G_POWER_SWITCH_CELL "b14pwb0ldx10"
   set G_POWER_SWITCH_LIB_PINA_IN($G_POWER_SWITCH_CELL) "a"
   set G_POWER_SWITCH_LIB_PINA_OUT($G_POWER_SWITCH_CELL) "o"
}

# Generate Visa Constraints Only for Units
   # Constraint Generation Options
   set G_VISA_GEN_CLOCK_STAMPING 0
   set G_VISA_GEN_CLOCK_CONSTRAINTS 1
   # Constraint Application Options
   set G_VISA_APPLY_CLOCK_STAMPING 0
   set G_VISA_APPLY_CLOCK_CONSTRAINTS 1

#suppress warning that was filling up logs after clk collateral change
suppress_message UID-95

#  WA from 1015239764
set hdlin_keep_default_parameter_values false

