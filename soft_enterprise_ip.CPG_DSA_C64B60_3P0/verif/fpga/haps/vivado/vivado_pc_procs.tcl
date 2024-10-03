set check_hstdm_missing_constraints  "1"
set hstdm_missing_constraints_xdc "hstdm_missing_constraints.xdc"
### If "report_hstdm_missing_constraints" runs for too long, 
### try lowering the default max_paths value below; e.g., by a factor of 2
set hstdm_missing_constraints_max_paths 10000
### If "report_hstdm_missing_constraints" is not finding all the missing constraints,
### increase the nworst value; e.g., in increments of 3.  Runtime may increase.
set hstdm_missing_constraints_nworst 1
### By default, "report_hstdm_missing_constraints" chooses delay values based on levels of logic.
### To relax these values, change the delay margin value below to a positive value
set hstdm_missing_constraints_delay 0
set pdelay_info_tcl "pdelay_info.tcl"
set pdelay_reports "pdelay_reports"
set write_bitstream_enable  "1"
set write_post_par_verilog  "0"
set XdcOutputFile	"import_dcp.xdc"
set DlyOutputFile	"import_dcp.dly"
### Max distance used during optimization and distance calculation
set MAX_DISTANCE 10000000
### Disconnect DAPs and reconnect them after placement (set to true if dap_info.tcl is found)
set DAP_RECONNECTION false
### Name of dap_info_file as exported from protocompiler
set dap_info_file dap_info.tcl
### Force setting DONT_TOUCH on complete design for SLR-aware debug
set FORCE_SAD_DONT_TOUCH false
### Measure and output runtime data about SLR-aware debug
set SAD_ANALYSIS true
### Primitives that shall not be disconnected during SLR_AWARE_DEBUG (REGEX)
set SAD_BLOCKREGEX "CARRY|MUXF|BRAM|DSP|CASCADE"
### Maximum number of SLR crossings
set SAD_MAX_SLR 23040
### Global var to remember if post_route dcp was already written
set post_route_written false

# if StrategyMode is fast_turn_around, Emulation Mode will be invoked
puts "StrategyMode is ${StrategyMode}"
switch -- $StrategyMode {
    "custom" {
        set opt_design_flags    "-directive Explore"
        set place_design_flags  "-directive AltSpreadLogic_high"
        set route_design_flags  "-directive AlternateCLBRouting" 
    }
    "timing_qor" {
        set opt_design_flags    "-directive Explore"
        set place_design_flags  "-directive Explore"
        set route_design_flags  "-directive Explore"
    }
    
    "fast_turn_around" {
        set opt_design_flags    "-directive RuntimeOptimized"
        set place_design_flags  "-directive RuntimeOptimized"
        set route_design_flags  "-directive RuntimeOptimized"
    }
    "custom_run" {
        set opt_design_flags    "custom_opt_design_flags"
        set place_design_flags  "custom_place_design_flags"
        set route_design_flags  "custom_route_design_flags"
    }
    default {
        set opt_design_flags    ""
        set place_design_flags  ""
        set route_design_flags  ""
    }
}

set_property target_part ${PartName} [current_fileset -constrset]
set_property design_mode GateLvl [current_fileset]
### Turn off a restriction on the number of clock objects allowed in a list for create_*clock commands
###catch {set_param sta.maxSourcesPerClock -1}
### Suppresses warning about multiple objects in a clock list
catch {set_msg_config -id {Constraints 18-633} -suppress}
### Suppresses warning about changing SEVERITY below
catch {set_msg_config -id {Vivado 12-4430} -suppress}
### Demotes error to warning about GTGREFCLK_ACTIVE inserted for multiview instrumentation
catch {set_property SEVERITY {warning} [get_drc_checks REQP-46]}
catch {set_property SEVERITY {warning} [get_drc_checks REQP-56]}
### Demotes error to warning message about RXTX_BITSLICE for HSTDM
catch {set_property SEVERITY {Warning} [get_drc_checks REQP-1932]}
catch {set_property SEVERITY {Warning} [get_drc_checks PDRC-194]}
# Param as WorkAround to Avoid ShapeBuilder issue observed
catch {set_param physynth.psipEnableEquRewire 0}
# Param to Disable PSIP in placer to avoid issues observed
catch {set_param physynth.enableInPlacer 0} 
# Param to use ILP Based assignment to resolve SLL congestion issues
catch {set_param route.sllAssign.doILPBasedSllAssignment 1} 
# Param to avoid doing powe-opt
catch {set_param logicopt.enablePowerLopt 0}
## Error out if FPGA fails to route, instead of giving Critical Warning and going ahead with Compile
set_msg_config -id "Route 35-162" -new_severity "ERROR"
set_msg_config -id "Route 35-54" -new_severity "ERROR"

#Adding additional steps to modify read_xdc and link_design due to Vivado Buffer constraint issue (Xilinx CR-981618) with Vivado version 201[7|8].[1|2|2.1|3|3.1|4]
# Rename 
if {[regexp {^201[7-8]\.[1-4].*} [version -short]]} {
    set XdcList {}
    catch {rename read_xdc read_xdc_vivado}
    catch {rename link_design link_design_vivado}
    proc read_xdc { xdc } {
        global XdcList
        puts "Appending $xdc to xdclist"
        lappend XdcList $xdc
    }
    proc link_design { args } {
        global XdcList
        puts "Evaluating link_design"
        eval link_design_vivado $args
        puts "Reading xdc $XdcList"
        read_xdc_vivado $XdcList
        puts "Restoring original commands"
        rename read_xdc ""
        rename link_design ""
        rename read_xdc_vivado read_xdc
        rename link_design_vivado link_design
        set XdcList {}
    }
}

# DRC for HAPS system
if {[file exists "haps_drc_vivado.tcl"]} {
    source -notrace haps_drc_vivado.tcl
    # HSTDM internal timing DRC is default on.
    # To disable these DRC, uncomment following two lines.
    # catch {set_property IS_ENABLED 0 [get_drc_checks {HATDM-1}]}
    # catch {set_property IS_ENABLED 0 [get_drc_checks {HATDM-2}]}
}

if { ${SllOptVivadoEnable} == 1 && ${DeviceName} != "XCVU440" } {
    puts "\[PC_FPGA\] - INFO : SLL-TDM Enabled for the compile"
    set_param place.tdm.enable 1
    set_param place.tdm.zebu.excludeHC 0
    catch {set_param place.tdm.ctm.enable 1}
    if { ${SllOptConstrained} == 1} {
        set_param place.tdm.applyTimingConstraints 0
    }
    set_param place.tdm.generic.MaxRatio $SllOptMaxRatio

    #percentage of the budget that can be taken for TDM-logic alone. higher the number, larger the muxes.
    set_param place.tdm.FastDomainPercOfBudget $SllOptTdmDlyAllowed
    #place.tdm.zebu.avoidTDMDifferentClocks by default value is 1, 0 will make CDC paths TDMable
    if {[catch {set_param place.tdm.zebu.avoidTDMDifferentClocks 1} err]} {
        puts "WARNING: SLL TDM is not disabled between different clocks(primary and derived): $err"
    }    
    if {[catch {set_param place.tdm.markedBRAM 1} err]} {
        puts "WARNING: SLL TDM is not enabled on BRAM paths: $err"
    }
    if {[catch {set_param place.tdm.markedDSP 1} err]} {
        puts "WARNING: SLL TDM is not enabled on DSP paths: $err"
    }
    if { ${SllOptMultipleTdm} == 1  } {
        set_param place.tdm.allowMultipleTDMonPath 1 
    }
    if {[file exists run_clockgen_flow.tcl]} {
	catch {set_param place.tdm.zebu.avoidTDMDifferentClocks 0}
	catch {set_param place.tdm.allowMultipleTDMonPath 1}
    }	

}

if { ${SllOptDebug} == 1 } {
    set_param place.tdm.verbose 1
    set_param place.tdm.zebu.msgs 1
    set_param place.tdm.debug.dumpOutInclusionFiles 1
    set_param place.tdm.debug.dumpOutInclusionFiles.includedNetcutsFileName IncludedNetcuts.txt
    set_param place.tdm.debug.dumpOutInclusionFiles.excludedNetcutsFileName excludedNetcuts.txt
    set_param place.tdm.debug.dumpOutInclusionFiles.includedPotentialNetcutsFileName includedPotentialNetcuts.txt
    set_param place.tdm.debug.dumpOutInclusionFiles.excludedPotentialNetcutsFileName excludedPotentialNetcuts.txt
}

#if { ${StrategyMode} == "fast_turn_around" && ${DeviceName} == "XCVU19P" } {
#  set EmulationMode "1"
#  set_param place.emulationMode 1
#  set_param route.emulationMode 1
#  puts "\[PC_FPGA\] - INFO : Vivado will be running in Emulation mode as User has given fast_turn_around StrategyMode"
#  set opt_design_flags    ""
#  set place_design_flags  ""
#  set route_design_flags  ""
#}

#################################################
###     SOURCE OPTION FILES IF THEY EXISTS ###
#################################################
proc hVivado_source_system_ip_option_files {} {
    global DesignName
    global DeviceName
    global PackageName
    global SpeedGrade
    global hapstype
    global env

    if { [file exists umr3_pcie_options.tcl] } {
        puts "Adding UMRBus 3.0 PCIe IP"
            source umr3_pcie_options.tcl
    }
    if { [file exists haps80d_options.tcl] } {
        puts "Adding System IP FIFO for 32bit UMRBus 2.0"
        source haps80d_options.tcl
    }
    if {[file exists haps_ip.tcl]} {
        set hapstype ""
        switch ${DeviceName} {
            "XCVU440" {
                set hapstype "haps8x"
            }
            "XCVU19P" {
                set hapstype "hapsaxd"
            }
            "XCVU3P" {
                set hapstype "hapsaxd"
            }
	    "XCVP1802" {
		set hapstype "haps1802"
	    }
            default {
                set hapstype "notype"
            }
        }
        set argv [list $hapstype ${DeviceName} ${PackageName} ${SpeedGrade} ${DesignName}]
        set argc [llength $argv]
        set argv0 haps_ip.tcl
        if {$hapstype != "notype"} {
            source $argv0
        }
    }
}

proc hVivado_source_clockgen_option_files {} {
    global DesignName
    global DeviceName
    global PackageName
    global SpeedGrade
    global hapstype
    global env
    set CorrectClockDistances "0"
    if { [info exists ::env(VIVADO_CORRECT_CLOCK_DISTANCES) ] } {
    	set CorrectClockDistances "1"
	}


    if {[file exists run_clockgen_flow.tcl]} {
        set hapstype ""
        switch ${DeviceName} {
            "XCVU440" {
                set hapstype "haps8x"
            }
            "XCVU19P" {
                set hapstype "hapsaxd"
            }
            "XCVU3P" {
                set hapstype "hapsaxd"
            }
            default {
                set hapstype "notype"
            }
        }
    }
    if {[file exists run_clockgen_flow.tcl]} {
        set argv [list $hapstype ${DeviceName} ${PackageName} ${SpeedGrade} ${DesignName} $CorrectClockDistances]
        set argc [llength $argv]
        set argv0 ${DesignName}_hapsip/${hapstype}/haps_clockgen/haps_clockgen.tcl
        if {$hapstype != "notype"} {
            source $argv0
        }
    }
}

#global VivadoOptionFiles
#global env
#foreach parOptionFile $VivadoOptionFiles {
#	if {[file exists $parOptionFile]} {
#		source $parOptionFile
#	}
#}

proc compress_output_file fn {
    global CompressOutputs
    if { ! ${CompressOutputs} } {
        return
    }
    if [ catch { exec gzip ${fn} } msg ] {
        puts "Note: compression of ${fn} failed: $msg"
    } else {
        file rename ${fn}.gz ${fn}
    }
}


proc hVivado_read_netlist {} {
    global env
    global InputMode
    global DesignName
    global TopModule

    if {${InputMode} == "EDIF"} {
        set_property edif_top_file ${DesignName}.edf [current_fileset]
        if {[file exists ${DesignName}.edf]} { 
            read_edif ${DesignName}.edf 
        }
        if {${TopModule} == ""} { 
           set TopModule [find_top]
        }
        if {[file exists ${DesignName}_edif.xdc]} {
            read_xdc ${DesignName}_edif.xdc 
        }
    } 

    if {${InputMode} == "VM"} {
        if {[file exists ${DesignName}.vm]} { 
            read_verilog ${DesignName}.vm 
        }
        if {${TopModule} == ""} { 
           set TopModule [lindex [find_top] 0]
        }
        if {[file exists ${DesignName}.xdc]} { 
            read_xdc ${DesignName}.xdc 
        }
        set_property top ${TopModule} [current_fileset]
    }

    if {[file exists "dtd_ddr3_ht3_constr.tcl"]} {
        source -notrace dtd_ddr3_ht3_constr.tcl
    }

}

proc hVivado_get_cpu-mem_status { phase } {
  set LoadFactor 0
  global LoadFactor_List 
  set rc [ catch { info hostname } value ] 
  if { $rc == 1 } { set host  NA } else { set host $value }
  set rc [ catch { exec cat /proc/cpuinfo | grep -c -w processor} value ]
  if { $rc == 1 } { set nb_proc  NA } else { set nb_proc $value }
  set rc [ catch { exec top -b -n 1 |  grep "load average" | sed "s/.*average://" } value_temp ]
  if { $rc == 1 } { 
        set current_load1 NA
        set current_load2 NA 
        set current_load3 NA
  } else {
        set value [string map {, " "} $value_temp]
        set current_load1 [lindex $value 0]
        set current_load2 [lindex $value 1]
        set current_load3 [lindex $value 2]
  }
  set rc [ catch { exec cat /proc/meminfo | grep MemFree } value ]
  if { $rc == 1 } { set mem_free NA } else { set mem_free [ expr [lindex $value 1] / 1024 / 1024] }
  puts "##  phase:$phase  -  Host: $host  -  MemFree: $mem_free GB  -  LoadAverage (5s|5min|15min / NBcpu): $current_load1|$current_load2|$current_load3 / $nb_proc "
}

proc hVivado_SLL_debug { phase } {
    global DesignName
    set spb_start 0
    set spb_total 0
    set spb_invalid 0
    set spb_fixed 0
    set spb_unconstrained 0
    set spb_pblock_unmatch 0
    set spb_hier_invalid 0
    set hier_total 0
    set leaf_total 0
    set leaf_slr_match 0
    set leaf_slr_unmatch 0
    set leaf_no_slr 0
    set leaf_no_pblock 0
    set leaf_pblock_unmatch 0
    set time_start [clock seconds]
    set xdcFile [open ${DesignName}_edif.xdc r]
    puts "$phase:start reading ${DesignName}_edif.xdc"
    while { [gets $xdcFile line] >= 0 } {
      if { [string match "# SLR assignment*" $line] } {
        set spb_start 1
      }
      if { [string match "add_cells_to_pblock slr*" $line] && $spb_start == 1 } {
        # first read the cell info from .xdc
        set spb_pblock_setting [lindex [split $line " " ] 1]
        set spb_slr_setting [string range $spb_pblock_setting 3 [expr [string length $spb_pblock_setting] - 1] ]
        set cell [lindex [split $line " " ] 3]
        set cell [string range $cell 0 [expr [string length $cell] - 2] ]
        incr spb_total
        
        #set spb_cell [get_cells $cell ] #this is not working for \[ and \]
        #set spb_cell [get_cells -regexp -hierarchical -filter " NAME == $cell " ] #== not working for \[ and \]
        set spb_cell [get_cells -regexp -hierarchical -filter " NAME =~ $cell " ]
        if { [llength $spb_cell] == 0 } {
          if { $spb_invalid < 10 } {
            puts "invalid spb_cell:$cell"
            # will also print by vivado: WARNING: [Vivado 12-180] No cells matched ...
          }
          incr spb_invalid
          continue
        }
        
        set spb_pblock_actual [get_property PBLOCK $spb_cell]
        set spb_dont_touch [get_property DONT_TOUCH $spb_cell]
        if { $spb_pblock_actual == "" } {
          if { $spb_dont_touch == "" } {
            if { $spb_unconstrained < 10 } {
              puts "unconstrained spb_cell:$cell"
            }
            incr spb_unconstrained
          } else {
            incr spb_fixed
          }  
        } elseif { $spb_pblock_actual != $spb_pblock_setting } {
          if { $spb_pblock_unmatch < 10 } {
            puts "unmatch spb_cell:$cell, spb_pblock_actual:$spb_pblock_actual, spb_pblock_setting:$spb_pblock_setting"
          }
          incr spb_pblock_unmatch
        }
        
        set leaf_list []
        set is_leaf [get_property IS_PRIMITIVE $spb_cell]
        if { $is_leaf == 1 } {
          set leaf_list $spb_cell
        } else {
          # only consider the top level hier cell
          #if { [llength [split $cell "/"]] == 1 } {
          #  incr spb_top_hier
          #}
          
          incr hier_total
          # get all the leaf cells under it
          set leaf_list [get_cells -regexp -hierarchical -filter " NAME =~ $cell.* && IS_PRIMITIVE==1 "]
          if { [llength $leaf_list] == 0 } {
            if { $spb_hier_invalid < 10 } {
              puts "spb_hier_invalid:$cell"
            }
            incr spb_hier_invalid
            continue
          }
        }
        
        #puts "hier cell:$cell in spb_slr_setting:$spb_slr_setting has [llength $leaf_list] leaf cells traversing under them"
        set leaf_total [expr $leaf_total + [llength $leaf_list]]
        foreach leaf_cell $leaf_list {
          #set leaf_slr [get_property SLR $leaf_cell] # no necessary have such property
          set leaf_slr [get_property SLR_INDEX $leaf_cell]
          set leaf_ref [get_property REF_NAME $leaf_cell]
          if { $leaf_slr == $spb_slr_setting } {
            incr leaf_slr_match
          } elseif { $leaf_ref == "VCC" || $leaf_ref == "GND" } {
            # ignore VCC and GND
            incr leaf_total -1
            continue
          } elseif { $leaf_slr == "" } {
            if { $leaf_no_slr < 5 } {
              puts "no slr: $leaf_cell"
            }
            incr leaf_no_slr 
          } else {
            if { $leaf_slr_unmatch < 5 } {
              puts "unmatch slr leaf_cell:$leaf_cell (leaf_ref:$leaf_ref) spb_slr_setting:$spb_slr_setting leaf_slr_actual:$leaf_slr"
            }
            incr leaf_slr_unmatch
          }
          
          set leaf_pblock [get_property PBLOCK $leaf_cell]
          if { $leaf_pblock == "" } {
            #if { $leaf_ref != "VCC" && $leaf_ref != "GND" } {
              if { $leaf_no_pblock < 5 } {
                puts "unconstrained leaf_cell:$leaf_cell, leaf_ref:$leaf_ref"
              }
              incr leaf_no_pblock
            #}
          } elseif { $leaf_pblock != $spb_pblock_setting } {
            if { $leaf_pblock_unmatch < 5 } {
              puts "unmatch_pblock leaf_cell:$leaf_cell (leaf_ref:$leaf_ref) spb_pblock_setting:$spb_pblock_setting leaf_pblock:$leaf_pblock"
            }
            incr leaf_pblock_unmatch
          }
          
          #puts "leaf_cell:$leaf_cell spb_slr_setting:$spb_slr_setting leaf_slr:$leaf_slr"
        }
      
      }
      
    }
    close $xdcFile
    
    # checking all the cells under netlist
    set all_top_hier_unconstrained 0
    set all_top_hier_cell [get_cells * -filter { NAME !~ sysip_inst* && IS_PRIMITIVE==0 } ]
    set all_top_hier [llength $all_top_hier_cell]
    foreach hier_cell $all_top_hier_cell {
      set pblock [get_property PBLOCK $hier_cell]
      if { $pblock == "" } {
        incr all_top_hier_unconstrained
        if { $all_top_hier_unconstrained < 100 } {
          set hier_ref [get_property REF_NAME $hier_cell]
          puts "all_top_hier_unconstrained cell:$hier_cell (hier_ref:$hier_ref)"
        }
      }
    }
    
    set all_leaf_cell [get_cells -hierarchical  * -filter { NAME !~ sysip_inst* && IS_PRIMITIVE==1 && REF_NAME != VCC && REF_NAME != GND && REF_NAME !~ IBUF* && REF_NAME !~ OBUF* && REF_NAME !~ IOBUF* && REF_NAME !~ BUFG*} ]
    set all_leaf [llength $all_leaf_cell]
    set all_leaf_unconstrained 0
    foreach leaf_cell $all_leaf_cell {
      set pblock [get_property PBLOCK $leaf_cell]
      if { $pblock == "" } {
        incr all_leaf_unconstrained
        if { $all_leaf_unconstrained < 100 } {
          set leaf_ref [get_property REF_NAME $leaf_cell]
          puts "all_leaf_unconstrained cell:$leaf_cell (leaf_ref:$leaf_ref)"
        }
      }
    }
    
    set debug_time [ expr ([clock seconds] - $time_start) / 60]
    puts "SLL_debug_$phase summary: debug_time(min):$debug_time spb_total:$spb_total spb_invalid_cell:$spb_invalid spb_hier_invalid:$spb_hier_invalid spb_unconstrained:$spb_unconstrained spb_pblock_unmatch:$spb_pblock_unmatch spb_fixed:$spb_fixed"
    puts "hier_total:$hier_total leaf_total:$leaf_total leaf_slr_match:$leaf_slr_match leaf_slr_unmatch:$leaf_slr_unmatch leaf_no_slr:$leaf_no_slr leaf_no_pblock:$leaf_no_pblock leaf_pblock_unmatch:$leaf_pblock_unmatch"
    puts "all_top_hier:$all_top_hier all_top_hier_unconstrained:$all_top_hier_unconstrained all_leaf:$all_leaf all_leaf_unconstrained:$all_leaf_unconstrained"
}

proc hVivado_link_design { } {
    global TopModule
    global PostLinkDCP
    global vivado_fast_tat_mode
    global env
    link_design -top ${TopModule}
    if { (${PostLinkDCP} == 1)  || (${vivado_fast_tat_mode} == 0)} {
        write_checkpoint -include_params -force post_link.dcp
    }
    
    #validate the constrained cells under soft pblocks
    if { [info exists ::env(afp_do_die_assign_soft_debug)] } {
      hVivado_SLL_debug
    }
}

proc hVivado_post_link_design_proc {} {
    global check_hstdm_missing_constraints
    global hstdm_missing_constraints_max_paths
    global hstdm_missing_constraints_nworst
    global hstdm_missing_constraints_delay
    global hstdm_missing_constraints_xdc
    global Disable_Check_HSTDM_Missing_Constraints
    global check_HSTDM_Missing_Constraints_post_PAR
    global DesignName
    global env
    global DeviceName
    global SllOptVivadoEnable
    global SllOptConstrained
    global SllOptFastClkPrd

#read constraints for XPM modules.
    if {[file exists "xpm_constraints.tcl"]} {
        source xpm_constraints.tcl
    }

    if {[file exists "xpm_constraints_vm.tcl"]} {
        source xpm_constraints_vm.tcl
    }

    if {[file exists "clock_groups.tcl"]} {
        source -notrace clock_groups.tcl
    }
# check missing constraints between user and hstdm
    if {(${Disable_Check_HSTDM_Missing_Constraints}) == "0" && (${check_HSTDM_Missing_Constraints_post_PAR} == 0) } {
        if {$check_hstdm_missing_constraints} {
            puts "Checking HSTDM missing constraints!"
            catch {report_hstdm_missing_constraints -xdc ${hstdm_missing_constraints_xdc} -max_paths ${hstdm_missing_constraints_max_paths} -nworst ${hstdm_missing_constraints_nworst} -delay ${hstdm_missing_constraints_delay}}
        }
        if {[file exists ${hstdm_missing_constraints_xdc}]} {
            puts "Adding  ${hstdm_missing_constraints_xdc} to the design"
            read_xdc ${hstdm_missing_constraints_xdc} 
        }
    }
# load hstdm placement constraints
    if {[file exists "run_hstdm_loc.xdc"]} {
        if {[file exists "run_hstdm_loc_pre.tcl"]} { 
            source -notrace run_hstdm_loc_pre.tcl
        }
        if {[info exists ::env(hstdm_exclude_placement)]} {
            set hstdm_exclude_placement_val "$::env(hstdm_exclude_placement)"
        } else {
            set hstdm_exclude_placement_val 0
        }
        set fp_hstdm [open "run_hstdm_exc_pla_var.xdc" w]
        puts $fp_hstdm "set hstdm_exclude_placement_value $hstdm_exclude_placement_val"
        close $fp_hstdm
        read_xdc run_hstdm_exc_pla_var.xdc
        read_xdc run_hstdm_loc.xdc
    }
# load mgtdm gen2 constraints.
    if {[file exists run_mgtdm_loc.xdc]} {
        read_xdc run_mgtdm_loc.xdc
    }
#    if { (${SllOptVivadoEnable} == 1) && (${SllOptConstrained} == 1) && [file exists "vivado_sll_opt_proxy.xdc"]} {
#        read_xdc vivado_sll_opt_proxy.xdc
#    }
    if { (${SllOptVivadoEnable} == 1) && (${DeviceName} != "XCVU440") } {
        set infraClkMMCM [get_cells "sysip_inst/bsa19_system_ip_u/haps_sysip_infra_clocks_inst/haps_sysip_infra_clocks_mmcm/mmcme4_adv_inst"]          
        if { [llength $infraClkMMCM] == 0} {
          puts "ERROR: MMCM Cell for InfraClks not found. SLL TDM cannot be used."
          exit
        }
        set_property CLKOUT0_DIVIDE_F $SllOptFastClkPrd $infraClkMMCM
        set setPrd [get_property CLKOUT0_DIVIDE_F  $infraClkMMCM]
        puts "Setting SLL FastClk period to $setPrd"
    }

#SAVE VIVADO PROJECT
#save_project_as -force ${DesignName}
#save_constraints -force
#save_constraints_as ${DesignName}_vivado
#set_property constrset ${DesignName}_vivado [get_runs impl_1]
}

proc hVivado_opt_design { } {
    global PostOptDCP
    global vivado_fast_tat_mode
    global opt_design_flags
    global env
    catch {set_property DONT_TOUCH TRUE [get_nets -of_objects [get_cells -hier *cfglut* -filter {REF_NAME =~ *SRLC32E*}]]}
    eval opt_design $opt_design_flags
    if { (${PostOptDCP} == 1) || (${vivado_fast_tat_mode} == 0)} {
        write_checkpoint -include_params -force post_opt.dcp
    }
}

proc hVivado_post_opt_design_proc { } {
    global TopModule
    global Flow
    global DesignName
    global Weight_Clock_Group_Path
#FOR LATCH CONVERSION FLOW 
    if {[file exists ${TopModule}_proxy.xdc]} {
        puts "Adding ${TopModule}_proxy.xdc to the design"
        read_xdc ${TopModule}_proxy.xdc
    }
#FOR INCREMENTAL FLOW    
    puts "Flow is ${Flow}"
    if {${Flow} == "Incremental" || ${Flow} == "Incremental_debug"} {
#Use DCP from previous P&R run for Incremental Flow
        if {[file exists "${DesignName}.dcp"]} {
            puts "Using ${DesignName}.dcp for Incremental Place and Route" 
            read_checkpoint -incremental ${DesignName}.dcp
            report_incremental_reuse
        } else {
            puts "${DesignName}.dcp does not exist. Running Place and Route" 
        }
    }
#Setting weight on hstdm_tx* and hstdm_rx* clock path groups.This will set the priority for these groups, thus helping with timing; these path groups are processed first during placement, routing and physical optimization
    if {${Weight_Clock_Group_Path} == 1} {
        puts "Setting weight on hstdm_tx* and hstdm_rx* clock path groups"
        group_path -name [get_clocks hstdm_tx*] -weight 2
        group_path -name [get_clocks hstdm_rx*] -weight 2
    }
}

proc hVivado_post_place_reports {} {
    global DesignName
    global vivado_fast_tat_mode
#Generate timing report after placement
    if {${vivado_fast_tat_mode} == 0} {
        report_timing_summary -setup -nworst 3 -max_paths 3 -file ${DesignName}_post_place_timing_summary.txt
        report_timing_summary -hold  -nworst 3 -max_paths 3 -file ${DesignName}_post_place_timing_summary_Min.txt
#Generate area report after placement
        report_utilization -file area.txt
    }
}

proc hVivado_disable_sysmon {} {
    global DeviceName
    global serialize_report_drc
### On HAPS-80/80D connectors J4 and J11 (pins A[8] and A[9]) are dual purpose pins connected to I2C_SCL and I2C_SDA on slave SLRs (SLR0 and SLR2)
### Disable SYSMON prevents I2C functionality on these pins from getting activated and corrupting input signal due to pulldown
### Xilinx recommends adding a disable SYSMONE1 
### https://www.xilinx.com/support/answers/65957.html   :  AR# 65957
### https://www.xilinx.com/support/answers/71744.html   :  AR# 71744
    if { $DeviceName == "XCVU440" } {
        puts "Disabling SYSMONE for $DeviceName"
        create_cell -reference SYSMONE1 haps_dummy_sysmone_SLR0
        create_cell -reference SYSMONE1 haps_dummy_sysmone_SLR2
        place_cell haps_dummy_sysmone_SLR0 SYSMONE1_X0Y0/SYSMONE1
        place_cell haps_dummy_sysmone_SLR2 SYSMONE1_X0Y2/SYSMONE1
        set_property INIT_42 16'h0003 [get_cells haps_dummy_sysmone_SLR0]
        set_property INIT_42 16'h0003 [get_cells haps_dummy_sysmone_SLR2]
        set_property INIT_74 16'h8000 [get_cells haps_dummy_sysmone_SLR2]
        set_property INIT_74 16'h8000 [get_cells haps_dummy_sysmone_SLR0]
#Supress wrong DRC Critical Warning on SYSMON when SYSMON are disabled for VU400 device after running report_drc
        if {${serialize_report_drc} == "1"} {
            report_drc -checks HAUMR-1
            report_drc -checks HAUMR-2
            report_drc -checks HATDM-1
            report_drc -checks HATDM-2
            report_drc -checks HATDM-3
            report_drc -checks HATDM-4
            report_drc -checks HADRC-1
            create_waiver -of_objects [get_drc_violations {RPBF-6#1}] -description {SYSMON has been disabled; this CW should be suppressed}
        } else {
            report_drc
            create_waiver -of_objects [get_drc_violations {RPBF-6#1}] -description {SYSMON has been disabled; this CW should be suppressed}
        }
    }
}

#Evaluate options and run place_design in Multi-Machine MPF
proc hVivado_place_design_mm_mpf {} {
    global env
    global vivado_fast_tat_mode
    global MultiMachineMPF
    global place_design_flags
    global RouterOnlyMPF
    global PC_REMOTE_SUBMIT_CMD
    global PC_REMOTE_KILL_CMD
    # Dump all non-Default params for debugging
    report_param -non_default -file non_default_params.rpt 
    if {${MultiMachineMPF} == "1" && (${RouterOnlyMPF} == 1)} {
        puts "\[PC_FPGA\] - INFO : Vivado place_design runs in Standard mode"
        set val [catch {eval place_design } err]
        if { (${val} == 1)  && (${vivado_fast_tat_mode} == 0)} {
                puts $err
                write_checkpoint -include_params -force post_place.dcp
                exit_pwd place
        }
    } elseif {${MultiMachineMPF} == "1" && (${RouterOnlyMPF} == 0)} {
        set_param general.multiMachineCommand  "$PC_REMOTE_SUBMIT_CMD"
        set_param general.multiMachineKillCommand "$PC_REMOTE_KILL_CMD"
    	puts "\[PC_FPGA\] - INFO : Vivado place_design runs in Multi Machine MPF mode"
    	set val [catch {eval place_design -multiprocess $place_design_flags} err]
    	if { (${val} == 1)  && (${vivado_fast_tat_mode} == 0)} {
           puts $err
           write_checkpoint -include_params -force post_place.dcp
           exit_pwd place
         }
    }
}

#Evaluate options and run route_design in Multi-Machine MPF
proc hVivado_route_design_mm_mpf {} {
    global env
    global MultiMachineMPF
    global RouterOnlyMPF
    global route_design_flags
    global PC_REMOTE_SUBMIT_CMD
    global PC_REMOTE_KILL_CMD
    set_param route.mpf.childRuntimeLimit  600
    if {${MultiMachineMPF} == 1 } {
        set_param general.multiMachineCommand  "$PC_REMOTE_SUBMIT_CMD"
        set_param general.multiMachineKillCommand "$PC_REMOTE_KILL_CMD"
    }
    puts "\[PC_FPGA\] - INFO : Vivado route_design runs in Multi Machine MPF mode"
    set val [catch {eval route_design -multiprocess $route_design_flags} err]
    if { $val == 1 } {
        exit_pwd route
        puts $err
        if [catch {get_msg_config -id {Route 35-567}}] {
            puts "\[PC_FPGA\] - ERR : Allowed default time limit of 600 minutes reached for child process, try running Vivado in router only MPF flow by  setting ENV variable, VIVADO_ENABLE_ROUTER_ONLY_MPF or run place_design with appropriate directive other than MPF directive of -multiprocess and run route_design with MPF directive of -multiprocess"  
        }
    }
    puts "route_design completed"
}
#Evaluate options and run place_design
proc hVivado_place_design { } {
    global env
    global PostPlaceDCP
    global vivado_fast_tat_mode
    global StrategyMode
    global DeviceName
    global place_design_flags
    global SingleMachineMPF
    global MultiMachineMPF
    global EmulationMode
    global RouterOnlyMPF

    if {[regexp {^201[7-8]\.[1-4].*} [version -short]]} {
        set val [catch {eval place_design -no_bufg_opt $place_design_flags } err]
        puts ""
        return
    }

    if {${MultiMachineMPF} == 1} {
        hVivado_place_design_mm_mpf 
    } else {

        if { ${SingleMachineMPF} == 1 } {
            if { ${RouterOnlyMPF} == 0 } {
                if { $EmulationMode == 1 } {
                    puts "\[PC_FPGA\] - INFO : Vivado place_design runs in Single Machine MPF Emulation mode"
                } else {
                    puts "\[PC_FPGA\] - INFO : Vivado place_design runs in Single Machine MPF mode"
                }
                if { ${DeviceName} == "XCVU19P" } {
                    puts "\[PC_FPGA\] - INFO : Vivado params selectable: Multithreading value = 16 for SINGLE MPF XCVU19P device"
                } elseif { ${DeviceName} == "XCVU440" } {
                    puts "\[PC_FPGA\] - INFO : Vivado params selectable: Multithreading value = 12 for SINGLE MPF XCVU440 device"
                }
                set val [catch {eval place_design -multiprocess $place_design_flags } err]
            } elseif { (${RouterOnlyMPF} == 1) } {
                puts "\[PC_FPGA\] - INFO : Vivado place_design runs in Standard mode"
                set val [catch {eval place_design $place_design_flags} err]
            }
        }
        if { (${SingleMachineMPF} == 0) && (${EmulationMode} == 1)} {
            puts "\[PC_FPGA\] - INFO : Vivado place_design runs in Emulation mode"
            set val [catch {eval place_design -timing_summary} err]
        }
        if { (${SingleMachineMPF} == 0) && (${EmulationMode} == 0)} {
            puts "\[PC_FPGA\] - INFO : Vivado place_design runs in $StrategyMode mode" 
            set val [catch {eval place_design $place_design_flags } err]
        }
        if { (${val} == 1) && (${vivado_fast_tat_mode} == 0)} {
            puts $err
            write_checkpoint -include_params -force post_place.dcp
            exit_pwd place
        }
    }
    if {(${PostPlaceDCP} == 1)  && (${vivado_fast_tat_mode} == 0)} {
        write_checkpoint -include_params -force post_place.dcp
    }
    
    #validate the constrained cells under soft pblocks
    if { [info exists ::env(afp_do_die_assign_soft_debug)] } {
      hVivado_SLL_debug
    }
}

proc hVivado_post_place_design_proc {} {
    global env
    hVivado_post_place_reports
}
#Run post place phys_opt design
proc hVivado_phys_opt_design { } {
    global env
    set val [catch {eval phys_opt_design } err]
}   
#Run post place phys_opt hold fix design         
proc hVivado_phys_opt_design_holdfix { } {
    global env
    set val [catch {eval phys_opt_design -hold_fix } err]
} 
#Run post place phys_opt Explorewithhold fix design if ENV VIVADO_PHYSOPT_EXPLOREWITHHOLDFIX is set for aggressive explore hold fix        
proc hVivado_phys_opt_design_exploreholdfix { } {
    global env
    set val [catch {eval phys_opt_design -directive ExploreWithHoldFix } err]
}
#Using phys_opt_design for setup and holdfix if -ve slack after placement
proc hVivado_post_place_phys_opt_design { } {
    global env
    global vivado_fast_tat_mode
    global PostPhysOptDCP
    global Physopt_slack_threshold_setup_lowerlimit
    global Physopt_slack_threshold_setup_upperlimit
    global Physopt_slack_threshold_hold_lowerlimit
    global Physopt_slack_threshold_hold_upperlimit
    global vivado_phyopt_explore_with_hold_fix
    global disable_post_place_phys_opt_setup
    global disable_post_place_phys_opt_hold
    global disable_post_place_phys_opt
    global disable_post_route_phys_opt


    if { (${Physopt_slack_threshold_setup_lowerlimit} <0.00) } {
        set phys_opt_sl_setup_lowerlimit $Physopt_slack_threshold_setup_lowerlimit
    } else {
        set phys_opt_sl_setup_lowerlimit -0.8
    } 
    if { (${Physopt_slack_threshold_setup_upperlimit} <0.00) } {
        set phys_opt_sl_setup_upperlimit $Physopt_slack_threshold_setup_upperlimit
    } else {
        set phys_opt_sl_setup_upperlimit -8.0
    }
    if {(${disable_post_place_phys_opt_setup} == 0) && (${disable_post_place_phys_opt} == 0)} {
        set slc [get_property SLACK [get_timing_path -delay_type max]]
        if {$slc >= $phys_opt_sl_setup_lowerlimit} {
            puts "INFO : Slack $slc is better than $phys_opt_sl_setup_lowerlimit, so no need to run phys_opt_design"
        } elseif {$slc <=$phys_opt_sl_setup_upperlimit} {
            puts "INFO : Slack $slc is worse than $phys_opt_sl_setup_upperlimit, please check design and constraints,running post place set up fix may cause huge runtime impact, not running post place setup fix"
        } else {
            puts "INFO : Slack $slc is worse than $phys_opt_sl_setup_lowerlimit and better than $phys_opt_sl_setup_upperlimit , so running phys_opt_design to see if it improves timing"
            hVivado_phys_opt_design
        }
    }
    if {(${vivado_phyopt_explore_with_hold_fix} == 1)} {
        set slc_hold_exp [get_property SLACK [get_timing_path -delay_type min]]
        if {$slc_hold_exp >=0.000}  {
            puts "INFO : Hold Slack is $slc_hold_exp, Design met hold timing requirements"
        } else {
            puts "INFO : Hold Slack is $slc_hold_exp, running post place explore with hold fix to see if it improves/fixes hold timing"
                hVivado_phys_opt_design_exploreholdfix
        } 
    }   

    if {(${vivado_phyopt_explore_with_hold_fix} == 0)} {              
        if { (${Physopt_slack_threshold_hold_lowerlimit} <0.00) } {
            set phys_opt_sl_hold_lowerlimit $Physopt_slack_threshold_hold_lowerlimit
        } else {
            set phys_opt_sl_hold_lowerlimit -0.5
        } 
        if { (${Physopt_slack_threshold_hold_upperlimit} <0.00) } {
            set phys_opt_sl_hold_upperlimit $Physopt_slack_threshold_hold_upperlimit
        } else {
            set phys_opt_sl_hold_upperlimit -1.5
        }
        if {(${disable_post_place_phys_opt_hold} == 0) && (${disable_post_place_phys_opt} == 0)} {   
            set slc_hold [get_property SLACK [get_timing_path -delay_type min]]
            if {$slc_hold >= $phys_opt_sl_hold_lowerlimit} {
                puts "INFO : Slack $slc_hold is better than $phys_opt_sl_hold_lowerlimit, so no need to run phys_opt_design_holdfix"
            } elseif {$slc_hold <=$phys_opt_sl_hold_upperlimit} {
                puts "INFO : Slack $slc_hold is worse than $phys_opt_sl_hold_upperlimit, please check design and constraints,running post place hold fix may cause huge runtime impact, not running post place hold fix"
            } else {
                puts "INFO : Slack $slc_hold is worse than $phys_opt_sl_hold_lowerlimit and better than $phys_opt_sl_hold_upperlimit , so running phys_opt_design to see if it improves hold timing"
                hVivado_phys_opt_design_holdfix
            }
        }
    }
    if { (${PostPhysOptDCP} == 1)  && (${vivado_fast_tat_mode} == 0)} {
        write_checkpoint -include_params -force post_phys_opt.dcp
    }   
}

#===========================================================================================
#Using phys_opt_design for hold fix if -ve slack after router
#===========================================================================================
proc hVivado_post_route_phys_opt_design_hold { } {
    global env
    global vivado_phyopt_explore_with_hold_fix
    global disable_post_route_phys_opt_setup
    global disable_post_route_phys_opt_hold
    global disable_post_route_phys_opt
    global slc_hold_exp

    if {(${vivado_phyopt_explore_with_hold_fix} == 1)} {
        set slc_hold_exp [get_property SLACK [get_timing_path -delay_type min]]
            if {$slc_hold_exp >=0.000}  {
                puts "INFO : Hold Slack is $slc_hold_exp, Design met hold timing requirements"
            } else {
                puts "INFO : Hold Slack is $slc_hold_exp, running post route explore with hold fix to see if it improves/fixes hold timing"
                hVivado_phys_opt_design_exploreholdfix
            }
        }
    if {(${vivado_phyopt_explore_with_hold_fix} == 0)} {         
        if {(${disable_post_route_phys_opt_hold} == 0) && (${disable_post_route_phys_opt} == 0)} { 
            set slc_hold [get_property SLACK [get_timing_path -delay_type min]]
            if {$slc_hold >=0.000}  {
                puts "INFO : Hold Slack is $slc_hold, Design met hold timing requirements"
            } else {
                puts "INFO : Hold Slack is $slc_hold, running post route hold fix to see if it improves/fixes hold timing"
                hVivado_phys_opt_design_holdfix
            }
        }
    }
}

proc hVivado_post_phys_opt_design_proc { } {

}

#Evaluate options and run route_design
proc hVivado_route_design { } {
    global env
    global StrategyMode
    global DeviceName
    global route_design_flags
    global SingleMachineMPF
    global MultiMachineMPF
    global EmulationMode
    global RouterOnlyMPF
    set_param route.mpf.childRuntimeLimit  600
    if {${MultiMachineMPF} == 1} {
        hVivado_route_design_mm_mpf
    } else {
        set route_flags {}
        if { $SingleMachineMPF == 1 } {
            if { ${EmulationMode} == 1 } {
                puts "\[PC_FPGA\] - INFO : Vivado route_design runs in Single Machine MPF Emulation mode"
            } else {
                puts "\[PC_FPGA\] - INFO : Vivado route_design runs in Single Machine MPF mode"
            }
            if { $DeviceName == "XCVU19P" } {
                puts "\[PC_FPGA\] - INFO : Vivado params selectable: Multithreading value = 16 for SINGLE MPF XCVU19P device"
            } elseif { $DeviceName == "XCVU440" } {
                puts "\[PC_FPGA\] - INFO : Vivado params selectable: Multithreading value = 12 for SINGLE MPF XCVU440 device"
            }
            lappend route_flags -multiprocess {*}$route_design_flags
        } else {
            if { ${EmulationMode} == 0 } {
                puts "\[PC_FPGA\] - INFO : Vivado route_design runs in $StrategyMode mode"
                lappend route_flags {*}$route_design_flags
            } else {
                puts "\[PC_FPGA\] - INFO : Vivado route_design runs in Emulation mode"
            }
        }
        set val [catch {eval route_design $route_flags } err]
        if { $val == 1 } {
            exit_pwd route
            puts $err
            if [catch {get_msg_config -id {Route 35-567}}] {
                puts "\[PC_FPGA\] - ERR : Allowed default time limit of 600 minutes reached for child process, try running Vivado in router only MPF flow by  setting ENV variable, VIVADO_ENABLE_ROUTER_ONLY_MPF or run place_design with appropriate directive other than MPF directive of -multiprocess and run route_design with MPF directive of -multiprocess"  
            }
        }
        puts "route_design completed"
    }
}

proc hVivado_get_route_status {} {
    global DesignName
	global post_route_written
    puts "\[PC_FPGA\] - INFO : Checking router status"
    set file_name "./report_route_status.rpt"
    report_route_status -file  $file_name
    set file_r [open $file_name r]
    seek $file_r 0
    set net_logical  NA
    set net_routable NA
    set net_error    NA
    set net_error_1    NA

    while { [gets $file_r line] >= 0 } {
        #puts $line
        if { [string match "*logical nets*"  $line] }  { set net_logical [lindex $line 5 ] }
        if { [string match "*routable nets*" $line] }  { set net_routable [lindex $line 5 ] }
        if { [string match "*routing errors*" $line] } { set net_error   [lindex $line 7 ] }
        if { [string match "unrouted nets*" $line] } { set net_error_1   [lindex $line 5 ] }
    }
    puts "   |- $net_routable routable nets / $net_logical Total nets"
    puts "   |- $net_error nets in errors"
    puts "   |- $net_error_1 nets in errors"
    close $file_r
    if { ($net_error != "NA" && $net_error > 0)  || ($net_error_1 != "NA" && $net_error_1 > 0 ) } {
	puts "\[PC_FPGA\] - ERROR : Found unrouted/partial routed nets. Writing dcp file and Exiting Vivado"
        write_checkpoint -include_params -force ${DesignName}.dcp
	set post_route_written true
        exit 1
	}
} 


proc hVivado_post_route_design_proc {} {
    global env
	global post_route_written
    hVivado_post_route_phys_opt_design_hold
    hVivado_post_route_reports 
    hVivado_generate_mmi_file

	# write post_route dcp if not already done (because of routing errors)
	if {! $post_route_written} {
		write_checkpoint -include_params -force post_route.dcp
	}
}

proc hVivado_check_if_pin_in_tdm {pin} {
    set pattern1 {Reg_TdmGrp_[\d]+_R[\d]+_fSLR[\d]+_tSLR[\d]+_lutTx[\d]+.*}
    set pattern2 {Counter_[\d]+_Ratio_[\d]+_Id_[\d]+_from[\d]+_tx[\d]+_.*}
    set cell [get_cells -of_objects $pin]
    #puts "Checking $cell $pattern1 $pattern2"
    if { [regexp $pattern1 $cell] } {
        #puts "pattern 1 match"
        return 1
    } elseif { [regexp $pattern2 $cell] } {
        #puts "pattern 2 match"
        return 1
    } else {
       #puts "no match"
        return 0
    }
}

proc hVivado_write_tdm_map_file {filename} {
    set fp [open $filename w]
    set grpIndices {}
    foreach tdmGroup  [get_cells Reg_TdmGrp_*_R*_fSLR*_tSLR*_tx -filter {REF_NAME == FDRE}] {
        set xx [split $tdmGroup _]
        lappend grpIndices [lindex $xx 2] 
    }
    set grpIndices [lsort -integer $grpIndices]
    foreach grpIdx $grpIndices {

        #for testing    
        #if {$grpIdx != 10} { 
        #     continue
        #}

        set grpTxReg [get_cells Reg_TdmGrp_${grpIdx}_R*_fSLR*_tSLR*_tx -filter {REF_NAME == FDRE}]
        set xx [split $grpTxReg "R_"]
        set tdmRatio [lindex $xx 5]
        set txLuts [lsort -dictionary [get_cells Reg_TdmGrp_${grpIdx}_R*_fSLR*_tSLR*_lutTx* -filter {PRIMITIVE_SUBGROUP == LUT}]]
        set txLines {}
        set rxLines {}
        puts $fp "TDM GRP ${grpIdx} Ratio: ${tdmRatio} \{"
        foreach txLut  $txLuts {
            set lutInputs [get_pins -of_objects [get_cells $txLut] -filter {DIRECTION == IN}]
            foreach lutInput  $lutInputs {
                set txNet [get_nets -of_objects $lutInput]
                set txPin [get_pins -leaf -of_objects [get_nets $txNet] -filter {DIRECTION == OUT}]
                if {[hVivado_check_if_pin_in_tdm $txPin] == 1} {
                    continue
                }
                set lineIdx  [llength $txLines]
                set rxNet [get_nets Reg_RxNet_TdmGrp_${grpIdx}_R${tdmRatio}_fSLR*_tSLR*_${lineIdx}]
                lappend txLines {$txNet $txPin}
                lappend rxLines $rxNet
                puts $fp "     $txPin --> [get_nets -of_objects $txPin] --> $rxNet"
            }
        }
        if {$tdmRatio != [llength $txLines]} {
            puts "ERROR: no of lines([llength $txLines]) does not match the ratio($tdmRatio) of the TDM for $grpTxReg."
        }
        puts $fp "\}"
    }
    close $fp
}

proc hVivado_post_route_reports {} {
    global vivado_fast_tat_mode
    global DesignName
    global SllOptVivadoEnable
    global DeviceName
    global SllOptDebugFlow
    global SllOptConstrained

    if { (${SllOptVivadoEnable} == 1) && (${DeviceName} != "XCVU440") } {
        if { ${SllOptDebugFlow} == 1 } {
            hVivado_write_tdm_map_file ${DesignName}_sllopt_map.txt
        }
        # It was not constrained before PnR. Read the constaints only for timing sign off
        #if { (${SllOptConstrained} != 1) } {
        #    read_xdc vivado_sll_opt_proxy.xdc
        #}
        set sllTdmFastClk [get_clocks -include_generated_clocks [get_property TDM_ZEBU_FAST_CLK_NAME [current_design]]]
        report_timing -from $sllTdmFastClk -to $sllTdmFastClk -nworst 3 -max_paths 3 -delay_type min_max -sort_by group -file ${DesignName}_sllopt.txt
        set rc [catch {exec grep -c VIOLATED ${DesignName}_sllopt.txt} grep_out]
        if {$rc == 0} {
            puts "ERROR: Bit file not generated because the design fails SLL timing requirements. Turn off VIVADO_SLL_TDM_ENABLE and try again."
            exit 1
        }
        #report_timing -setup -from $sllTdmFastClk -nworst 3 -max_paths 3 -file ${DesignName}_sllopt.txt -append
        #report_timing -setup -to $sllTdmFastClk -nworst 3 -max_paths 3 -file ${DesignName}_sllopt.txt -append
        #set rc [catch {exec grep -c VIOLATED ${DesignName}_sllopt.txt} grep_out]
        #if {$rc == 0} {
        #    puts "CRITICAL WARNING: Possible timing violations in the DUT clocks because of SLL optimizations. Bit files will be generated, but the design" 
        #    puts "might fail at runtime when clock frequencies are not adjusted. Refer to ${DesignName}_sllopt.txt for more details"
        #}
    }
    if {${vivado_fast_tat_mode} == 0} {
        puts "Generating post router reports"
        report_timing_summary -setup -nworst 3 -max_paths 3 -file ${DesignName}_timing_summary.txt
        report_timing_summary -hold  -nworst 3 -max_paths 3 -file ${DesignName}_timing_summary_Min.txt
        report_clock_utilization -verbose -file clock_utilization.txt
        report_io -file pinloc.txt
        report_drc -file post_route_drc.txt
        report_clock_interaction -file ${DesignName}_clock_interaction.rpt
    }
}

proc hVivado_hstdm_postroute {} {
    if {[file exists "run_hstdm_postroute.tcl"]} { 
        source -notrace run_hstdm_postroute.tcl
    }
}

proc hVivado_generate_routed_dcp {} {
    global DesignName
    global vivado_fast_tat_mode
    global RouterDcpDisable
    if { ${RouterDcpDisable} != "1"} {
        if { ${vivado_fast_tat_mode} == "0"} {
            puts "Writing routed design checkpoint"
            write_checkpoint -include_params -force ${DesignName}.dcp
        }
    }
}

proc hVivado_pdelay_reports {} {
    global pdelay_info_tcl
    global pdelay_reports
    global env
    if {[catch {report_haps_pdelay -pdelay_info ${pdelay_info_tcl} -pdelay_reports ${pdelay_reports}} err]} {
        puts "WARNING: error during generating pdelay reports: $err"
    }
}

proc hVivado_generate_ioreg_report {} {
    global DesignName
    global env
    if {[lsearch [tclapp::list_apps] xilinx::ultrafast] == -1} {
        if [catch {tclapp::install ultrafast} err] {
            puts "WARNING: Could not install ultrafast: $err"
        }
    }
    if [catch {xilinx::ultrafast::report_io_reg -file ${DesignName}_io_reg.rpt} err] {
        puts "WARNING: Could not create ${DesignName}_io_reg.rpt: $err"
    }
}

proc hVivado_generate_xdc_sdf_verilog_files {} {
    global DesignName
    global XdcOutputFile
    global DlyOutputFile
    global write_post_par_verilog
    global VerdiMode
    global env
    global generateBackAnnotationFiles
    if {${generateBackAnnotationFiles} != "0"} {
       write_xdc -no_fixed_only -constraints valid -exclude_timing -force ${XdcOutputFile}
       #compress_output_file ${XdcOutputFile}
       write_sdf -force -mode sta -quiet ${DlyOutputFile}
       #compress_output_file ${DlyOutputFile}
    }
    if { ${write_post_par_verilog} == 1 || ${VerdiMode} == 1 } {
        write_verilog -force ${DesignName}_post_par.vm
    }
}

proc hVivado_generate_mmi_file {} {
    global DesignName
    global env
#Writing mmi file if MGTDM present
    if {[file exists run_mgtdm_loc.xdc]} {
        write_mem_info -force ${DesignName}.mmi 
    }
}

proc hVivado_bitstream_configuration {} {
    global DeviceName
    global PrepareReadback
#set_property BITSTREAM.General.UnconstrainedPins {Allow} [current_design]
    set_property CFGBVS GND [current_design]
    set_property CONFIG_VOLTAGE 1.8 [current_design]
    if { (${DeviceName} == "XCKU040") || (${DeviceName} == "XCVU440") || (${DeviceName} == "XCVU3P") || (${DeviceName} == "XCVU19P") } {
        set_property BITSTREAM.CONFIG.OVERTEMPSHUTDOWN {Enable} [current_design]
    } elseif { (${DeviceName} == "XCVP1802") } {
    } else {
        set_property BITSTREAM.CONFIG.OVERTEMPPOWERDOWN {Enable} [current_design]
    }
    set_property BITSTREAM.CONFIG.USR_ACCESS [get_haps_bitstream_identification] [current_design]
    set_property BITSTREAM.GENERAL.COMPRESS {True} [current_design]
    if {${PrepareReadback} == 1} {
        set_property BITSTREAM.CONFIG.PERSIST {Yes} [current_design]
        set_property CONFIG_MODE {S_SELECTMAP} [current_design]
    } elseif {${PrepareReadback} == 2} {
        if {${DeviceName} != "XCVU440" && ${DeviceName} != "XCVU19P"} {
            # assume it is a Virtex 7 device "XC7V2000T"
            set_property BITSTREAM.CONFIG.PERSIST {Yes} [current_design]
            set_property CONFIG_MODE {S_SELECTMAP} [current_design]
        }
    }
}
###################################################
###     Set Bitstream-specific properties       ###
###################################################

### proc to generate logic location file for XCVU440 that is used by readback ###
proc write_readback_logic_location_file {filename part} {
    global DesignName
    set fp [open $filename w]
    puts $fp "PART [string tolower $part] [get_property BITSTREAM.CONFIG.USR_ACCESS [current_design]] $DesignName"
    array set validTil [list BRAM 1 CLEL_L 1 CLEL_R 1 CLE_M 1 CLE_M_R 1 CLEM 1 CLEM_R 1]
    foreach {pattern lut} {PRIMITIVE_GROUP==REGISTER 0 PRIMITIVE_GROUP==BLOCKRAM 0 PRIMITIVE_TYPE=~CLB.LUTRAM.* 1 PRIMITIVE_TYPE=~CLB.SRL.* 1} {
        if {$lut==1} {
            continue
        }
        foreach c [get_cells -hier -filter $pattern] {
            set bel [get_property BEL $c]
            set loc [get_property LOC $c]
            if {![regexp {^([A-Z_]+)_X([0-9]+)Y([0-9]+)} [get_tiles -of_objects $loc] tmp til x y]} {
                continue
            }
            set bel_e [lindex [split $bel .] 1]
            if {![info exists validTil($til)]} {
                continue
            }
            if {$lut==1} {
                if {![regexp {^([A-H])[1-6]LUT} $bel_e tmp l]} {
                    continue
                }
                set bel_e LUT$l
            }

            puts -nonewline $fp "$til $x $y $bel_e $c"
            if {$til=="BRAM"} {
                puts $fp " $loc"
            } else {
                puts $fp ""
            }
        }
    }
    close $fp
}

### Create ident-string to be used as BITSTREAM.CONFIG.USR_ACCESS ###
proc get_haps_bitstream_identification {} {
    set bitstream_identification 0
    set number_of_bits_timestamp 20
    set version_string [version -short]
    set version_valid 0
    set version_year 0
    set version_number1 0
    set version_number2 0
    # version year ranges from 2016 to 2047
    set version_year_base 2016
    set version_year_max [expr {$version_year_base+(1<<5)-1}]
    if {[regexp {^(20[0-9][0-9])\.([1-7])} $version_string dummy version_year version_number1]} {
        #
    } elseif {[regexp {^(20[0-9][0-9])\.([1-7])\.([1-7])} $version_string dummy version_year version_number1 version_number2]} {
        #
    }
    if {$version_year>=$version_year_base && $version_year<=$version_year_max} {
        set version_valid 1
        set version_year [expr {$version_year-$version_year_base}]
    }
    set bitstream_pnr_version [expr {($version_number2) + ($version_number1<<3) + ($version_year<<6) + ($version_valid<<11)}]
    set bitstream_identification [expr {$bitstream_pnr_version<<$number_of_bits_timestamp}]
    # resolution is 15 minutes
    set clock_unit 900
    # timestamp ranges from 2018 Jan 1 GMT to 2047 Nov 27 GMT
    set clock_seconds_base [clock scan "2018 Jan 1 00:00:00 GMT" -format "%Y %b %d %T %Z"]
    set clock_seconds_max [expr {$clock_seconds_base+$clock_unit*((1<<$number_of_bits_timestamp)-1)}]
    set current_seconds [clock seconds]
    if {$current_seconds>=$clock_seconds_base && $current_seconds<=$clock_seconds_max} {
        set bitsteam_timestamp [expr {($current_seconds-$clock_seconds_base)/$clock_unit}]
        incr bitstream_identification $bitsteam_timestamp
    }
    return [format "%#010x" $bitstream_identification]
}

proc hVivado_generate_bitstream {} {
    global write_bitstream_enable
    global DeviceName
    global DesignName
    global env

    hVivado_bitstream_configuration

    if {${write_bitstream_enable} == 1} {
        ### Xilinx recommends to turn off multi-threading for write_bitstream 
        if {[regexp {^2016\.[123].*} [version -short]]} {
            set_param bitgen.maxThreads 1 
        }

        if { (${DeviceName} == "XCVU440") || (${DeviceName} == "XCVU19P") || (${DeviceName} == "XCVU3P")} {
            write_readback_logic_location_file ${DesignName}.ll ${DeviceName}
            write_bitstream -force ${DesignName}.bit
        } elseif { (${DeviceName} == "XCVP1802") } {
	    write_readback_logic_location_file ${DesignName}.ll ${DeviceName}
	    write_device_image -force ${DesignName}.pdi
	} else {
            write_bitstream -logic_location_file -force ${DesignName}.bit       
        }
    }
}

proc hVivado_post_bitstream_update_mgtdm_data {} {
    global update_mgtdm_data_file
#############################################################
###     #Merging bit file with MGTDM data    ###
#############################################################
    if {[file exists run_mgtdm_loc.xdc]} {
        if {[file exists $update_mgtdm_data_file]} {
            source $update_mgtdm_data_file
        }  
    }
}

proc hVivado_post_bitstream_proc {} {
    global env
    global vivado_fast_tat_mode
    if {${vivado_fast_tat_mode} == 0} {
        hVivado_pdelay_reports
        hVivado_generate_ioreg_report
    }
    hVivado_generate_xdc_sdf_verilog_files
    hVivado_post_bitstream_update_mgtdm_data
#If some env to tcl switch control is set, call this below proc
#hVivado_get_path_delay
    global DesignName
# running queries in tcl file to get path delay
    set pimXdcFile "${DesignName}_pim.xdc"
    if {[file exists $pimXdcFile]} {
        puts "Adding $pimXdcFile to the design"
        read_xdc $pimXdcFile
    }
    set QueryFile "${DesignName}_query.tcl"
    set OrigQueryFile "../${DesignName}_srs/map/m0/${QueryFile}"
    if {[file exists $QueryFile] == 1} {
        source $QueryFile
    } elseif {[file exists $OrigQueryFile] == 1} {
        source $OrigQueryFile
    }
    hVivado_generate_routed_dcp
   if {[file exists ${DesignName}.vm]} {
    catch {exec gzip ${DesignName}.vm}
   }
}
###############################################################################
#####     #Proc for Copying required files in sindbad mode compile   ###
################################################################################
proc hVivado_copy_parff_files {} {
    global DesignName
    global write_bitstream_enable
    # the variables for setting thresholds
    global min_slack_timing_exit max_slack_timing_exit

    if { ([file exists ../.parff]) } {
        # Succcess Criterion
        if { [info exists ::env(VIVADO_PARFF_USER_CRITERION)] } {
            # call the proc
            set return_status [hVivado_parff_custom_selection $min_slack_timing_exit $max_slack_timing_exit]
            # Return Status should be of the form done / design path
        } else {
            # default behaviour is to check for first time
            set return_status [hVivado_parff_default_selection]
        }
        lassign $return_status val
        set path [pwd]

        if { $val == 0 } {
            set vivadoDir [file tail $path]
            if { [regexp {vivado([0-9]*)_.*} $vivadoDir - success_recipe] >0 } {
                exec touch ../../.Success
                file copy -force ../recipe${success_recipe}.txt ../../success.recipe
                puts "Copying files from Succesful recipe"
                catch {
                    file delete -force ../../vivado_srs
                    file mkdir ../../vivado_srs
                }
                foreach f [glob -directory ./ -nocomplain *] {
                    file delete -force ../../vivado_srs/[file tail $f]
                    file copy -force $f ../../vivado_srs/[file tail $f]
                }
                file delete -force  ../../${DesignName}_srs ../../${DesignName}_srs_reports
                file copy -force ../${DesignName}_srs ../${DesignName}_srs_reports ../../
                exec touch ../../.ready
                puts "Finished Copying files from Succesful recipe"
            }
        }
    } else {
        set status 1
        if { [info exists write_bitstream_enable] && $write_bitstream_enable == 1 && [file exists ${DesignName}.bit] == 0 } {
            # bitstream is not generated
            set status 0 
        }
        if { $status } {
            exec touch ../.mainOK
        }
    }
}
################################################################################
# hVivado_parff_default_selection : the default selection method provided
# Returns : 0 on pass/1 on fail
################################################################################
proc hVivado_parff_default_selection { } {
    if { ([file exists ../../.Success]) } {
        puts "Succesful recipe already Found and copied back!!"
        return [list 1 ]
    } else {
        # this is the successful one
        return [list 0 ]
    }
}
################################################################################
# hVivado_parff_custom_selection : the custom selection method provided
#                   Will check against min and max slack timings to get the criterion
#                   User can rewrite this proc to have a custom proc
# Returns : 0 on pass/ 1 on fail
################################################################################
proc hVivado_parff_custom_selection {args} {
    global slc_hold_exp
    lassign $args min_slack_timing_exit max_slack_timing_exit
    if { [file exists ../../.Success] } {
        puts "Successful recipe already found and copied back!!"
        return [list 1]
    } else {
        if { ![info exists slc_hold_exp] } {
            set slc_hold_exp [get_property SLACK [get_timing_path -delay_type min]] ;# hold
        }
        set slc_setup [get_property SLACK [get_timing_path -delay_type max]] ;# setup
        if { $slc_hold_exp > $min_slack_timing_exit &&
             $slc_setup    > $max_slack_timing_exit } {
             return [list 0]
         } else {
             return [list 1]
         }
    }
}


###############################################################################
###        Disconnect all DAPs from user design                             ###
###    do not disconnect dummy nets (this belongs to preserved signals)     ###
###############################################################################
proc hVivado_disconnect_ip {} {
    global dap_groups dap_groups ;#dap groups as read in from dap_info_file
    global sig_group sig_group ;#signal groups as read in from dap_info_file
    global dap_connections_old dap_connections_old ;#Original connections of dap_dPin<->user net output
    global dap_groups_nets dap_groups_nets ;#lookup group --> list of dap_dPins
    global dap_groups_dap dap_groups_dap ;#lookup group --> list of driverPins from 
    global driverPins_net driverPins_net ;#lookup driverPins --> driving net, this net is later used to connect the driver pin to its new dap_dPin
    global pinPairs pinPairs
    global dap_dummys dap_dummys
    global dap_net_groups dap_net_groups ;#lookup table (array) net-driverpin --> dap-group
    global dap_dPins_used_original dap_dPins_used_original ;#List of all dap_dPins used in original design (to be used later in reconnectIP to detect dangling dPins)
    global dap_info_file dap_info_file
    global dap_indices dap_indices
    global DAP_RECONNECTION DAP_RECONNECTION
    global SAD_ANALYSIS SAD_ANALYSIS
    global SAD_BLOCKREGEX SAD_BLOCKREGEX

    array set dap_net_groups {}
    array set dap_groups_dap {}
    array set dap_groups_nets {}
    array set dap_indices {}
    set driver_nets [list]
    set dap_connections_old {}
    set dap_dPins_used_original {}
    set dap_dummys {}
    unset -nocomplain dap_groups_nets
    unset -nocomplain pinPairs
    set time_start [clock seconds]

    if {$SAD_ANALYSIS} {
        puts "*********** Disconnecting daps...."
    }

    if {[file exists $dap_info_file] == 1} {
        source $dap_info_file
    }

    if {[array exists dap_groups] == 0} {
        # No dap_info file was found --> return and leave dap-connections unchanged
        set DAP_RECONNECTION false
        return
    } else {
        set DAP_RECONNECTION true
    }


    foreach group [array names dap_groups] {
        set dap_inst_serialized_vector [serialize_vector [lindex $dap_groups($group) 0] ]
        set dap_dPinNames [list]

        foreach dap_inst $dap_inst_serialized_vector {
            lappend dap_dPinNames [lindex ${dap_inst} 0]/D
        }
        set dap_dPins [get_pins $dap_dPinNames]
        set dap_nets [get_nets -of $dap_dPins]


        foreach dap_inst $dap_inst_serialized_vector {
            set dap_dPinName [lindex ${dap_inst} 0]/D
            set dap_dPin [get_pins $dap_dPinName]
            if {$dap_dPin eq ""} {
                continue
            }
            # Append $dap_dPin with index and iicename into lookuptable
            # Content: dap_indices("name of pin")-->{index iicename}
            set dap_indices($dap_dPin) [list [lindex $dap_inst 1] [lindex $dap_groups($group) 1]]

            set dap_net [get_nets -of $dap_dPin]
            if {$dap_net eq ""} {
                continue
            } 

            set driverPin [get_pins -leaf -of_objects  $dap_net -filter {(DIRECTION == "OUT")}]
            set driver_net [get_nets -of $driverPin]
            set driver_primitive [get_property PRIMITIVE_TYPE [get_cells -of_objects $driverPin]]
            # puts "Primitive of driver from: $dap_dPin is: $driver_primitive"

            # Ignore DAPs that are connected to primitives on block list
            if {[regexp -indices $SAD_BLOCKREGEX $driver_primitive] > 0} {
                continue
            }

            set driver_type [get_property TYPE $driver_net]
            lappend dap_groups_dap($group) $dap_dPin ;#add all dap pins, even dummys

            if { $driver_type eq "GROUND" } {
                # The dap_dPin is probably a dummy input, because it's connected to GND
                lappend dap_dummys $dap_dPin
                    continue
            }

            set_property DONT_TOUCH false $dap_net
            lappend dap_dPins_used_original $dap_dPin

            lappend pinPairs($group) $driverPin $dap_dPin
            lappend dap_connections_old $dap_dPin $driverPin
            lappend dap_groups_nets($group) $driverPin
            set driverPins_net($driverPin) $driver_net

            set dap_net_groups($driverPin) $group
        }
    }


    if {[llength $dap_connections_old] == 0 || [llength $dap_dPins_used_original] == 0   } {
        # No pins or connections were found --> SLR-aware debug not possible
        # Reason might be wrong mdiclink-register names
        puts "SLR-aware debug not possible, no debug access points found."
        set DAP_RECONNECTION false
    } else {
        set_property DONT_TOUCH false [get_cells -of $dap_dPins_used_original]
        
        # Disconnect all dap_dPins that were originally used (except the ones that are connected to primitives on block list)
        disconnect_net -objects $dap_dPins_used_original
        # Connect all disconnected daps to GND to avoid warnings during placement
        create_cell -reference GND pcGNDCellhVivado_disconnect_IP
        create_net pcGNDNethVivado_disconnect_IP
        connect_net -hier -net pcGNDNethVivado_disconnect_IP -objects [get_pins pcGNDCellhVivado_disconnect_IP/G]
        connect_net -hier -net pcGNDNethVivado_disconnect_IP -objects $dap_dPins_used_original
        set_property DONT_TOUCH true [get_cells -of $dap_dPins_used_original]
        set_property DONT_TOUCH true [get_cells -of $dap_connections_old];
        set all_used_nets [get_nets -of_objects [get_pins $dap_connections_old]]
        set_property DONT_TOUCH true $all_used_nets

    } 

    set time_end [ expr [clock seconds] - $time_start]
    if {$SAD_ANALYSIS} {
        puts "*********** Disconnecting daps took $time_end seconds."
    }

};#End of proc hVivado_disconnect_IP

###############################################################################
###        Reconnect instrumented nets to debugIP                           ###
###############################################################################
proc hVivado_reconnect_ip {} {
    global dap_connections_old dap_connections_old
    global dap_connections_new dap_connections_new
    global dap_connections_suc dap_connections_suc ;# List of connections that were successfully made. Should contain part or all entries from dap_connections_new
    global positions positions
    global dap_dummys dap_dummys
    global dap_dPins_used_original dap_dPins_used_original
    global dap_dPins_remaining dap_dPins_remaining
    global driverPins_net driverPins_net
    global dap_pairs dap_pairs ;# pairs of old dap_dPin/ new dap_dPin
    global DAP_RECONNECTION DAP_RECONNECTION
    global SAD_ANALYSIS SAD_ANALYSIS
    global FORCE_SAD_DONT_TOUCH FORCE_SAD_DONT_TOUCH
    global SAD_MAX_SLR SAD_MAX_SLR
    set SLR_COUNT 4 ;# Number of SLRs used, assuming dap_dPins are distributed over all available SLRs
    set dap_dPins_remaining {}
    set dap_pairs {}
    set time_start [clock seconds]

    if {!$DAP_RECONNECTION} {
        # dap reconnection is not used
        return
    } 

# Get positions of dap pins and user net driver pins
    get_dap_net_positions

# Save necessary data for later debugging and external optimization
    store_slr_aware_data

# Find optimal connection between user nets and dap inputs to avoid SLR crossings
    #optimize_dap_net_Connections ;# Use this function to optimize "internal" within current vivado run
    optimize_dap_net_Connections_external ;# This functions uses an external tcl-shell to run optimization, it is much faster then vivado tcl-shell
    set resultFilename "slr_aware_debug_results.tcl"
    source $resultFilename ;# Import results from external optimization

#If dap_dPins_used_original is empty, create it from dap_connections_old
    if { [info exists dap_dPins_used_original] == 0 ||  [llength $dap_dPins_used_original] == 0} {
        foreach {dPin input} $dap_connections_old {
            lappend dap_dPins_remaining $dPin
        }
    } else {
        set dap_dPins_remaining $dap_dPins_used_original
    }


    set dap_connection_suc {}

    if {$FORCE_SAD_DONT_TOUCH} {
        # Remove dont touch for all nets and cells
        set tmp_nets [get_nets -hierarchical -filter DONT_TOUCH]
        if {[llength $tmp_nets] > 0} {
            set_property DONT_TOUCH FALSE $tmp_nets
        }
        set tmp_cells [get_cells -hierarchical -filter DONT_TOUCH ]
        if {[llength $tmp_cells] > 0} {
            set_property DONT_TOUCH FALSE $tmp_cells
        }
    }

# Check if connections were optimized, otherwise use original connections
    if {[info exists dap_connections_new ] == 0 } {
        # connect all driver pins to original dap pins
        set dap_connections_new $dap_connections_old
    }

    set all_used_driver_pins [list ]
    set all_used_dap_pins [list ]
    foreach {dap_pin driver_pin} $dap_connections_old {
        lappend all_used_driver_pins $driver_pin
        lappend all_used_dap_pins $dap_pin
    }
    foreach {dap_pin driver_pin} $dap_connections_new {
        lappend all_used_driver_pins $driver_pin
        lappend all_used_dap_pins $dap_pin
    }
    set all_used_driver_pins [lsort -unique $all_used_driver_pins]
    set all_used_dap_pins [lsort -unique $all_used_dap_pins]
    # puts "all_used_driver_pins: $all_used_driver_pins"
    # puts "all_used_dap_pins: $all_used_dap_pins"

    set all_used_pins [list ]
    lappend all_used_pins {*}$all_used_driver_pins
    lappend all_used_pins {*}$all_used_dap_pins
    set all_used_pins [get_pins $all_used_pins]
    set all_used_nets [get_nets -of_objects $all_used_pins]

    set all_used_nets [get_nets -segments $all_used_nets]

    if {!($FORCE_SAD_DONT_TOUCH)} {
        if {[llength $all_used_nets] > 0 } {
            # puts "setting DONT_TOUCH for: $all_used_nets"
            set_property DONT_TOUCH FALSE $all_used_nets
            set all_used_cells [get_cells -of_objects $all_used_nets]
            # puts "Setting dont_touch for cells:$all_used_cells"
            set_property DONT_TOUCH FALSE $all_used_cells
        }
    }
    set dap_dNets_remaining $all_used_nets ;#Remaining nets that are not reused --> will be checked for driverlessness and removed if needed
    set dap_dPins $all_used_dap_pins
    set dap_dPins_remaining $all_used_dap_pins ;#Remaining pins (begin with list of all dap_dPins ever used), unsused pins will be connected to GND at the end


    puts "Disconnecting [llength $dap_dPins] (all) dap_dPins"
    set time_start_0 [clock seconds]
    disconnect_net -objects $dap_dPins
    set time_end [ expr [clock seconds] - $time_start_0]
    puts "*********** Disconnecting dap_dPins took $time_end seconds."

    set reconnections [list ]



    set time_start_1 [clock seconds]

    # Reconnect all daps to user nets
    foreach {dap_dPin driverPin} $dap_connections_new {
        # Driver pins from dummy-inputs (used for reserved daps) are not listed in positions-array as they are GND
        # These pins did not get disconnected and are ignored here
        if { [info exists positions($driverPin)] == 0 } {
            continue
        }

        set driverNet $driverPins_net($driverPin)

        if {$driverNet == ""} {
            puts "Cannot connect $driverPin   -- $dap_dPin"
            continue
        }


        # Remove used dPins from list of remaining original pins 
        # --> remaining pins will be connected to GND
        set idx [lsearch -exact $dap_dPins_remaining $dap_dPin]
        if {$idx >= 0} {
            set dap_dPins_remaining [lreplace $dap_dPins_remaining $idx $idx]
        }

        lappend reconnections $driverNet $dap_dPin

        #lookup driverpin in connections_old --> get dap_dPin
        set idx [lsearch -exact $dap_connections_old $driverPin]
        if {$idx > 0} {
            set idx0 [expr $idx - 1]
            set dap_dPin_old [lindex $dap_connections_old $idx0]
            lappend dap_pairs $dap_dPin_old $dap_dPin
        }


    }


    # Join list of reconnections and reconnect all pins at once
    set reconnections [join $reconnections]
    if {[catch {[connect_net -hier -net_object_list $reconnections]} error]} {
       puts "Warning: Could not connect some debug nets."
       puts $error
    }


    foreach {dap_net} $dap_dNets_remaining {
        set driverPin [get_pins -leaf -of_objects  $dap_net -filter {(DIRECTION == "OUT")}]
        if {$driverPin == ""} {
            # Remove from old list of remaining nets
            set idx [lsearch -exact $dap_dNets_remaining $dap_net]
            if {$idx >= 0} {
                set dap_dNets_remaining [lreplace $dap_dNets_remaining $idx $idx]
            }
        } else {

        }
    }
    

    set GND_net [lindex [get_nets pcGNDNethVivado_disconnect_IP] 0]
	
    if {[llength $dap_dPins_remaining] >= 1 } {
    	puts "Connecting remaining dap_dPins to GND"
    	connect_net -hier -net pcGNDNethVivado_disconnect_IP -objects $dap_dPins_remaining
	} else {
		puts "No dap_dPins left to be connected to GND."	
	}

	set time_end [ expr [clock seconds] - $time_start_1]
	puts "*********** Reconnecting dap_dPins took $time_end seconds."


    set dap_connections_suc $dap_connections_new ;# Assume all connections are successful

    # Export list of old vs. new connections of dap<->user nets
    export_new_dap_connections dap_connection_new.txt

    # Print time consumed if needed
    set time_end [ expr [clock seconds] - $time_start]
    if {$SAD_ANALYSIS} {

        if {[info exists slr_crossings_critical] !=0 } {
            puts "Instrumentation introduces these SLR crossings:"
            for {set i 0} {$i < $SLR_COUNT} {incr i} {
                puts "Outgoing connections from SLR$i: $slr_crossings_critical(OUT$i)"
                puts "Incomming connections to SLR$i: $slr_crossings_critical(IN$i)"
                
                for {set j 0} {$j < $SLR_COUNT} {incr j} {
                    if {$i != $j && $slr_crossings($i,$j) > 0} {
                        puts "Crossing from $i -> $j: $slr_crossings($i,$j)"
                    }
                }
            }
        }

        puts "*********** Optimizing and Reconnecting daps took $time_end seconds."
    }

    set too_many_crossings false
    if {[info exists slr_crossings_critical] !=0 } {
        for {set i 0} {$i < $SLR_COUNT} {incr i} {
            if {$SAD_MAX_SLR <= $slr_crossings_critical(OUT$i)} {
                puts "Error: Too many outgoing connections from SLR$i: $slr_crossings_critical(OUT$i)"
                set too_many_crossings true   
            }
            if {$SAD_MAX_SLR <= $slr_crossings_critical(IN$i)} {
                puts "Error: Too many incomming connections to SLR$i: $slr_crossings_critical(IN$i)"
                set too_many_crossings true
            }
        }
        # print additional slr crossing information in case of problems
        if {$too_many_crossings} {
            for {set i 0} {$i < $SLR_COUNT} {incr i} {                
                for {set j 0} {$j < $SLR_COUNT} {incr j} {
                    if {$i != $j && $slr_crossings($i,$j) > 0} {
                        puts "Crossing from $i -> $j: $slr_crossings($i,$j)"
                    }
                }
            }
        }
    }

    # Error out in case of too many slr crossings
    if {$too_many_crossings} {
        # Place design again
        puts "Warning: Placing design again with -directive Explore to reduce SLR crossings."
        place_design -unplace

        global place_design_flags
        set tmp_place_design_flags $place_design_flags
        set place_design_flags  "-directive Explore"
        hVivado_place_design
        set place_design_flags $tmp_place_design_flags
        # exit_pwd "SLR_AWARE_DEBUG: Reconnection"
    }
}

###############################################################################
###     Call optimize_dap_net_Connections in an external process     		###
###############################################################################
proc optimize_dap_net_Connections_external {} {
    global SAD_ANALYSIS SAD_ANALYSIS
    set time_start [clock seconds]
    set filename "optimize_external.tcl"
    set dirname "slr_aware_dir"
    set resultFilename "../slr_aware_debug_results.tcl"

    #mkdir
    file mkdir $dirname
    #create file
    set outfile [open [file join $dirname $filename] w]

    #fill file with commands
    puts $outfile "#Some dummy variables and procs"
    puts $outfile "set StrategyMode fast"
    puts $outfile "set PartName TESTPART"
    puts $outfile "set SllOptVivadoEnable 0"
    puts $outfile "set SllOptDebug 0"
    puts $outfile "proc current_fileset {args} { return DUMMY }"
    puts $outfile "proc set_property {p1 p2 p3} {}"
    puts $outfile "proc set_msg_config {args} {}"
    puts $outfile "proc version {args} {}"
    puts $outfile "#source scriptfiles"
    puts $outfile {source "../vivado_pc_procs.tcl"}
    puts $outfile {source "..\/slr\_aware\_debug\_data.tcl"}
    puts $outfile "#optimize connections"
    puts $outfile "optimize_dap_net_Connections"
    puts $outfile "#write back optimized connection data"
    puts $outfile "store_slr_aware_data $resultFilename"
    puts $outfile "#exit 0"
    close $outfile

    #call process
    cd $dirname
    exec tclsh $filename

    # Import results from external optimization
    source $resultFilename
    cd ..

    # Delete optidir and contents


    set time_end [ expr [clock seconds] - $time_start]
    if {$SAD_ANALYSIS} {
        puts "*********** Optimizing debug connections with external script took $time_end seconds."
    } else {
        file delete -force $dirname
    }
}

###############################################################################
###            Get positions of DAP and instrumented nets                   ###
###              to be used for optimized reconnection                      ###
###############################################################################
proc get_dap_net_positions {} {
    global dap_connections_old dap_connections_old
    global positions positions
    global dap_dummys dap_dummys
    global SAD_ANALYSIS SAD_ANALYSIS
    unset -nocomplain positions
    array set positions {}
    set all_used_pins $dap_connections_old
    set time_start [clock seconds]

    if {[info exists dap_dummys] != 0 } { 
        lappend all_used_pins $dap_dummys
    } 
    set all_used_pins [join $all_used_pins]

    #iterate over each dap and net and store coordinates & SLR in positions array
    foreach {pin} $all_used_pins {
        set foundPin [get_pins $pin]
        if { $foundPin eq ""} {
            continue
        } 
        set cell [lindex [get_cells -of_objects $foundPin] 0]
        if { $cell eq ""} {
            continue
        }
        set loc [get_property LOC $cell]
        if {$loc eq ""} {
            # probably thats a GND, it will not be added to positions-array
            continue
        }
        if {![regexp {^([A-Z_]+)_X([0-9]+)Y([0-9]+)} [get_tiles -of_objects $loc] tmp til x y]} {
            continue
        }

        set slr_string [get_slrs -of_objects $cell]
        set slr 0;#Default value
        if { $slr_string ne "" } {
            if {[regexp {^SLR([0-4])} $slr_string tmp s]} {
                set slr $s
            }
        }

        set positions($pin) {}
        lappend positions($pin) $x $y $slr
    }
    
    set time_end [ expr [clock seconds] - $time_start]
    if {$SAD_ANALYSIS} {
        puts "*********** Getting positions took $time_end seconds."
    }
}

###############################################################################
###     Calculate the optimal reconnection of DAP and instrumented nets     ###
###############################################################################
proc optimize_dap_net_Connections {} {
    global dap_connections_old dap_connections_old
    global dap_connections_new dap_connections_new
    global positions positions
    global dap_groups_nets dap_groups_nets
    global dap_groups_dap dap_groups_dap
    global MAX_DISTANCE MAX_DISTANCE
    global SAD_ANALYSIS SAD_ANALYSIS
    global slr_crossings slr_crossings
    global slr_crossings_critical slr_crossings_critical
    set SLR_DISTANCE_FACTOR 10
    set speedup 2 ;# Speedup factor to increase increment while searching appropriated dap input pin (must be lower than SLR_COUNT)
    set SLR_COUNT 4 ;# Number of SLRs used, assuming dap_dPins are distributed over all available SLRs
    array set slr_crossings {} ;# store all SLR crossings introduced by optimized connection of instrumentation (indices: 0,0/0,1/0,2/1,0/...)
    array set slr_crossings_critical {} ;#  store all critical SLR crossings introduced by optimized connection of instrumentation (indices: IN0/OUT0/IN1/...)
    
    for {set i 0} {$i < $SLR_COUNT} {incr i} {
        for {set j 0} {$j < $SLR_COUNT} {incr j} {
            set slr_crossings($i,$j) 0
        }
        set slr_crossings_critical(IN$i) 0
        set slr_crossings_critical(OUT$i) 0
    }
    
    set time_start [clock seconds]

    if {$speedup > $SLR_COUNT} {
        puts "WARNING: speedup factor must not be greater than number of SLRs."
    }



    # For each group: check all driver pins and find nearest dap_pin --> add the found pairing to dap_connections_new
    foreach group [array names dap_groups_nets] {

        set driver_pins $dap_groups_nets($group)
        set dap_pins $dap_groups_dap($group)

        foreach driver_pin $driver_pins {
            # find dap with smallest distance
            set distance $MAX_DISTANCE
            set tmp_dap_pin [lindex $dap_pins 0] ;# use first dap as default
            set tmp_dap_pin_index 0
            set dap_pins_length [llength $dap_pins]

            set dap_incr [expr $dap_pins_length * $speedup / $SLR_COUNT]

            if {($dap_incr >= $dap_pins_length) || ($dap_incr == 0)} {
                set dap_incr 1
            }

            # init slr numbers to be used for slr crossing calculation
            set slr0 0
            set slr1 0

            for {set index 0} {$index < $dap_pins_length} {incr index $dap_incr} {
                set dap_pin [lindex $dap_pins $index]
                if {$dap_pin == "" } {
                    continue
                }

                set code [catch {
                    set position0 $positions($driver_pin)
                    set position1 $positions($dap_pin)
                    } result]

                if {$code == 0} {
                    set x0 [lindex $position0 0]
                    set y0 [lindex $position0 1]
                    set slr0 [lindex $position0 2]

                    set x1 [lindex $position1 0]
                    set y1 [lindex $position1 1]
                    set slr1 [lindex $position1 2]

                    set current_distance [expr { (($x0 - $x1)*($x0 - $x1) + ($y0 - $y1)*($y0 - $y1)) * (($slr0 - $slr1) * ($slr0 - $slr1) * $SLR_DISTANCE_FACTOR)} ]
                } else {
                    set current_distance  $MAX_DISTANCE
                }
                
                if { $current_distance < $distance} {
                    set distance $current_distance
                    set tmp_dap_pin $dap_pin
                    set tmp_dap_pin_index $index
                }
            }
            # tmp_dap_pin should contain name of nearest dap_pin now

            # puts "connecting $tmp_dap_pin to $driver_pin with distance $distance"

            # set this connection in dap_connections_new
            lappend dap_connections_new $tmp_dap_pin $driver_pin

            # increment SLR crossing
            incr slr_crossings($slr0,$slr1)
            if {$slr0 != $slr1} {
                incr slr_crossings_critical(OUT$slr0)
                incr slr_crossings_critical(IN$slr1)
            }


            # remove used dap_pin from temporary list of dap_pins
            ##set dap_pins [lsearch -inline -all -not -exact $dap_pins $tmp_dap_pin]
            set dap_pins [lreplace $dap_pins $tmp_dap_pin_index $tmp_dap_pin_index]
        }
    }

    set time_end [ expr [clock seconds] - $time_start]
    if {$SAD_ANALYSIS} {
        puts "Instrumentation introduces these SLR crossings:"
        for {set i 0} {$i < $SLR_COUNT} {incr i} {
            puts "Outgoing connections from SLR$i: $slr_crossings_critical(OUT$i)"
            puts "Incomming connections to SLR$i: $slr_crossings_critical(IN$i)"
            
            for {set j 0} {$j < $SLR_COUNT} {incr j} {
                if {$i != $j} {
                    puts "Crossing from $i -> $j: $slr_crossings($i,$j)"
                }
            }
        }
        
#        puts "SLR-Crossings(get): [array get slr_crossings]"
        puts "*********** Optimization took $time_end seconds."
    }
}

###############################################################################
###       Store all needed data for SLR_AWARE_DEBUG                         ###
###       This is useful for later debugging of optimization algorithm      ###
###############################################################################
proc store_slr_aware_data { {filename "slr_aware_debug_data.tcl"} } {
    global dap_connections_old dap_connections_old
    global dap_connections_new dap_connections_new
    global positions positions
    global dap_groups_nets dap_groups_nets
    global dap_groups_dap dap_groups_dap
    global driverPins_net driverPins_net
    global dap_connections_suc dap_connections_suc
    global dap_dummys dap_dummys
    global dap_dPins_used_original dap_dPins_used_original
    global dap_dPins_remaining dap_dPins_remaining
    global dap_pairs dap_pairs
    global dap_indices dap_indices
    global MAX_DISTANCE MAX_DISTANCE
    global SAD_ANALYSIS SAD_ANALYSIS
    global slr_crossings slr_crossings
    global slr_crossings_critical slr_crossings_critical

    set time_start [clock seconds]  
    
    set outfile [open $filename w]


    if {[info exists dap_connections_old] != 0} {
        write_list_to_channel $outfile dap_connections_old $dap_connections_old
    }

    if {[info exists dap_connections_new] != 0} {
        write_list_to_channel $outfile dap_connections_new $dap_connections_new
    }

    if {[info exists dap_connections_suc] != 0} {
        write_list_to_channel $outfile dap_connections_suc $dap_connections_suc
    }
    
    if {[info exists dap_dummys] !=0} {
        write_list_to_channel $outfile dap_dummys $dap_dummys
    }

    if {[info exists dap_dPins_used_original] !=0} {
        write_list_to_channel $outfile dap_dPins_used_original $dap_dPins_used_original
    }

    if {[info exists dap_dPins_remaining] != 0} {
        write_list_to_channel $outfile dap_dPins_remaining $dap_dPins_remaining
    }

    if {[info exists dap_pairs] != 0} {
        write_list_to_channel $outfile dap_pairs $dap_pairs
    }

    if {[info exists positions] !=0} {
        write_array_to_channel $outfile positions
    }

    if {[info exists dap_groups_nets] !=0} {
        write_array_to_channel $outfile dap_groups_nets
    }

    if {[info exists dap_groups_dap] !=0} {
        write_array_to_channel $outfile dap_groups_dap
    }

	if {[info exists driverPins_net] != 0} {
		write_array_to_channel $outfile driverPins_net
	}
    
    if {[info exists dap_indices] !=0} {
        write_array_to_channel $outfile dap_indices
    }

    if {[info exists slr_crossings] !=0} {
        write_array_to_channel $outfile slr_crossings
    }

    if {[info exists slr_crossings_critical] !=0} {
        write_array_to_channel $outfile slr_crossings_critical
    }

    puts $outfile "set MAX_DISTANCE $MAX_DISTANCE"
    close $outfile
    set time_end [ expr [clock seconds] - $time_start]
    if {$SAD_ANALYSIS} {
        puts "*********** Writing opti-data to file took $time_end seconds."
    }

}

###############################################################################
###              Write a list of strings into a stream, like an opened file ###
###############################################################################
proc write_list_to_channel {channel name var} {
    puts -nonewline $channel "set $name \{"
    foreach {value} $var {
        puts -nonewline $channel $value
        puts -nonewline $channel " "
    }
    puts $channel "\}"
}

###############################################################################
###              Write an array into a stream, like an opened file          ###
###############################################################################
proc write_array_to_channel {channel varname} {
    upvar $varname array_variable
    set arraynames [array names array_variable]

    puts -nonewline $channel "array set $varname \{"
    foreach name_value $arraynames {
    puts -nonewline $channel "$name_value \{"
    foreach {value} $array_variable($name_value) {
        puts -nonewline $channel $value
        puts -nonewline $channel " "
    }
        puts -nonewline $channel "\} "
    }
    puts $channel "\}"
}


###############################################################################
###              Return euklid distance * slrFactor                         ###
###         For pins on same slr it returns euklid distance                 ###
###         For pins on different slrs the euklid distance is multiplied    ###
###                        to add some kind of penalty for SLR-crossings    ###
###############################################################################
proc get_distance {x0 y0 slr0 x1 y1 slr1} {
    set SLR_DISTANCE_FACTOR 1000
    set distance [expr { ($x0 - $x1)*($x0 - $x1) + ($y0 - $y1)*($y0 - $y1)} ]
    set slrOffset [ expr abs([expr [expr {$slr0 - $slr1}] * $SLR_DISTANCE_FACTOR]) ]
    set slrOffset [::tcl::mathfunc::max $slrOffset 1]
    set distance [expr {$distance * $slrOffset} ]
    return $distance
}


###############################################################################
###    Wrapper to get the distance of two pins, based on x,y,slr            ###
###    as stored in positions var                                           ###
###    This proc accepts pin names as input.                                ###
###############################################################################
proc get_pin_distance {pin0 pin1} {
    global positions positions
    global MAX_DISTANCE MAX_DISTANCE

    if {[info exists positions($pin0)] == 0 || [info exists positions($pin1)] == 0} {
        # puts "One of the given pins ($pin0 or $pin1) is not found in positions array."
        return $MAX_DISTANCE
    }


    set position0 $positions($pin0)
    set position1 $positions($pin1)

    set x0 [lindex $position0 0]
    set y0 [lindex $position0 1]
    set slr0 [lindex $position0 2]

    set x1 [lindex $position1 0]
    set y1 [lindex $position1 1]
    set slr1 [lindex $position1 2]

    return [get_distance $x0 $y0 $slr0 $x1 $y1 $slr1 ]
}


###############################################################################
###            Export list of new connections to given file                 ###
###############################################################################
proc export_new_dap_connections {filename} {
    global dap_connections_suc dap_connections_suc
    global dap_connections_old dap_connections_old
    global dap_pairs dap_pairs
    global dap_indices dap_indices
    global SAD_ANALYSIS SAD_ANALYSIS
    set count_newconnection 0
    set count_oldconnection 0
    set time_start [clock seconds]

    # delete file and create new
    file delete -force $filename

    set fp [open $filename "w"]

    # Output pairs of oldIndex:newIndex:iiceName
    foreach {dap_dPin_old dap_dPin} $dap_pairs {
        #puts "searching dap_dPin_old: $dap_dPin_old and dap_dPin: $dap_dPin"
        set oldIndex [lindex $dap_indices($dap_dPin_old) 0]
        set iiceName [lindex $dap_indices($dap_dPin_old) 1]
        set newIndex [lindex $dap_indices($dap_dPin) 0]
        puts $fp "$oldIndex $newIndex $iiceName"

        if {$oldIndex eq $newIndex} {
            continue
            #set count_oldconnection [expr $count_oldconnection + 1]
        } else {
            set count_newconnection [expr $count_newconnection + 1]

        }
    }
    close $fp

    if {$SAD_ANALYSIS} { 
        set sum [expr $count_newconnection + $count_oldconnection]
        puts "*********** SLR-aware debug changed $count_newconnection of $sum connections."
        set time_end [ expr [clock seconds] - $time_start]
        puts "*********** Writing new dap connections to file took $time_end seconds."
    
    }
}

###############################################################################
### return driver pin that "belongs" to dap pin according to given list     ###
###  basically a wrapper for lsearch                                        ###
###############################################################################
proc get_driverPin_of_dapPin {dap_dPin connection_list} {
    set idx [lsearch -all -exact $connection_list $dap_dPin]
    if {$idx >= 0} {
        return [lindex $connection_list [expr $idx + 1]]
    } else {
        puts "dap_dPin: $dap_dPin not found in connection list"
        return ""
    }
}


###############################################################################
#####     Serialize vectorized names (used for mdiclinkregisters)           ###
###############################################################################
proc serialize_vector {in} {
    set out {}
    foreach i $in {
        if [regexp {(.*)\[([0-9]+)\:([0-9]+)\]$} $i a b c d] {
            if {$c > $d} {
                for {set i $d} {$i <= $c} {incr i} {
                    lappend out [list "$b\[$i\]" $i]
                }
            } else {
                for {set i $c} {$i <= $d} {incr i} {
                    lappend out [list "$b\[$i\]" $i]
                }
            }
        } else {
            lappend out $i;# this case is not used here, otherwise needs special handling in caller
        }
    }
    return $out
}

###############################################################################
#####     HSTDM Connectivity reporting for SLL TDM Analysis                 ###
###############################################################################
proc haps_hstdm_connectivity {} {
    proc compare_list {list1 list2} {
        set intersection ""
        set union ""
        set only_l1 ""
        set only_l2 ""
        set list1 [ lsort -unique $list1 ]
        set list2 [ lsort -unique $list2 ]
        foreach el $list1 {
            set l1($el) 1
        }

        foreach el $list2 {
            if { [ info exists l1($el) ] } {
                incr l1($el)
            } else {
                set l2($el) 1
            }
        }
        #### GET THE UNION ####
        set union [ concat [ array names l1 ] [ array names l2 ] ]
        #### GET THE INTERSECTION ####
        foreach ky [ array names l1 ] {
            if { $l1($ky) > 1 } {
                lappend intersection $ky
            } else {
                lappend only_l1 $ky
            }
        }
        #### GET THE DIFFERENCE ####
        set only_l2 [ array names l2 ]
        return [ list $union $intersection $only_l1 $only_l2 ]
    }

    proc create_slr_pblock { slr } {
        # Create SLR-level pblocks
        set SLR [get_slr $slr]
        regexp {X(\d*)Y(\d*)} [lindex [lsort -dictionary [get_clock_regions -of $SLR ]] 0] - Xmin Ymin
        regexp {X(\d*)Y(\d*)} [lindex [lsort -dictionary [get_clock_regions -of $SLR ]] end] - Xmax Ymax
        # For safety, delete ghosts pblocks before
        create_pblock -quiet pblock_${SLR}
        resize_pblock -quiet pblock_${SLR} -add "CLOCKREGION_X${Xmin}Y${Ymin}:CLOCKREGION_X${Xmax}Y${Ymax}"
        puts "AP::Info Creating pblock: pblock_${SLR} := CLOCKREGION_X${Xmin}Y${Ymin}:CLOCKREGION_X${Xmax}Y${Ymax}"
    }

    ## Recieve in  to fpga
    ## get_cells cpm_rcv*
    set dataOut [get_cells *HSTDM*/*data_out* -filter "REF_NAME=~FD* && IS_FIXED" ]
    ## Sending out of fpga
    ## get_cells cpm_snd*
    set dataIn [get_cells *HSTDM*/*data_in* -filter "REF_NAME=~FD* && IS_FIXED" ]
    ## Generate reporting file
    set FH [open hstdm_summary.rpt {w}]
    ## Filter on D pin and Q pin 
    foreach slr [get_slrs] {
        set cpmRcv($slr) [filter $dataOut SLR_INDEX==[get_property SLR_INDEX $slr]]
        set cpmSnd($slr) [filter $dataIn SLR_INDEX==[get_property SLR_INDEX $slr]]
        puts " -I- Found HSTDM cpm rcv cells in $slr : [llength $cpmRcv($slr)]"
        puts $FH " -I- Found HSTDM cpm rcv cells in $slr : [llength $cpmRcv($slr)]"
        puts " -I- Found HSTDM cpm snd cells in $slr : [llength $cpmSnd($slr)]"
        puts $FH " -I- Found HSTDM cpm snd cells in $slr : [llength $cpmSnd($slr)]"
        set allFanOutFromDataOut($slr) [all_fanout -only_cells -flat [get_pins -filter DIRECTION==OUT -of_objects  $cpmRcv($slr) ]]
        set allFanInToDataIn($slr) [all_fanin -only_cells -flat [get_pins -filter DIRECTION==IN -of_objects  $cpmSnd($slr) ]]
    }

    set allSlrs [get_slrs]
    set tb [xilinx::designutils::prettyTable]
    set title "Common Cells Fanout from\nInput TDM -> Fanin of Output TDM"
    set title1 "Common Cells Fanout from Input TDM"
    set title2 "Common Cells Fanin to Output TDM"
    set tb1 [xilinx::designutils::prettyTable]
    set tb2 [xilinx::designutils::prettyTable]
    set header [list "From \\ To"]
    foreach slr $allSlrs {
        set row ""
        set row1 ""
        set row2 ""
        lappend row $slr
        lappend row1 $slr
        lappend row2 $slr
        lappend header $slr
        foreach sl $allSlrs {
            set slrX($slr:$sl) [lindex [compare_list $allFanOutFromDataOut($slr) $allFanInToDataIn($sl)] 1]
            set slrXFanout($slr:$sl) [lindex [compare_list $allFanOutFromDataOut($slr) $allFanOutFromDataOut($sl)] 1]
            set slrXFanin($slr:$sl) [lindex [compare_list $allFanInToDataIn($slr) $allFanInToDataIn($sl)] 1]
            lappend row [llength $slrX($slr:$sl)]
            lappend row1 [llength $slrXFanout($slr:$sl)]
            lappend row2 [llength $slrXFanin($slr:$sl)]
        }
        $tb addrow $row
        $tb1 addrow $row1
        $tb2 addrow $row2
    }
    $tb header "$header"
    $tb1 header "$header"
    $tb2 header "$header"
    $tb title "$title"
    $tb1 title "$title1"
    $tb2 title "$title2"
    puts $FH "\n"
    puts $FH [$tb print]
    puts $FH [$tb1 print]
    puts $FH [$tb2 print]

    #$tb export -file hstdm_output.rpt
    #$tb1 export -append -file hstdm_output.rpt
    #$tb2 export -append -file hstdm_output.rpt
    close $FH

    if {0} {
        foreach slr [get_slrs] {
            create_slr_pblock $slr
            add_cells_to_pblock pblock_$slr [get_cells [list $allFanOutFromDataOut($slr) $allFanInToDataIn($slr)]]
        }
    }
}
################################################################################################
######       HSTDM Connectivity reporting for SLL TDM Details & RAMB Connectivity           ###
################################################################################################
proc haps_hstdm_connectivity_details {} {
    set VERSION {2021.04.23}
    set VERBOSE 1

    set SLRS_FROM [get_slrs]
    set SLRS_TO [get_slrs]

    # set SLRS_FROM [get_slrs SLR3]
    # set SLRS_TO [get_slrs SLR0]

    set ::TDM_FILTERING_PBLOCK_PATTERN {}
    set ::TDM_FILTERING_FIXED_PATTERN {IS_PRIMITIVE && REF_NAME=~FD* && ((NAME=~*HSTDM*/*data_out*) || (NAME=~*HSTDM*/*data_in*))}
    # set ::TDM_FILTERING_FIXED_PATTERN {IS_PRIMITIVE && REF_NAME=~FD*}
    set ::TDM_PBLOCK_PATTERN {^$}

    set_param tcl.collectionResultDisplayLimit -1

    if {$VERBOSE} { puts " -I- START report_tdm.tcl ($VERSION)" }
    set start [clock seconds]

    if {[info var ::USER_TDM_FILTERING_PBLOCK_PATTERN] != {}} {
        set ::TDM_FILTERING_PBLOCK_PATTERN $::USER_TDM_FILTERING_PBLOCK_PATTERN
        puts " -I- USER_TDM_FILTERING_PBLOCK_PATTERN=$::TDM_FILTERING_PBLOCK_PATTERN"
    }
    if {[info var ::USER_TDM_FILTERING_FIXED_PATTERN] != {}} {
        set ::TDM_FILTERING_FIXED_PATTERN $::USER_TDM_FILTERING_FIXED_PATTERN
        puts " -I- USER_TDM_FILTERING_FIXED_PATTERN=$::TDM_FILTERING_FIXED_PATTERN"
    }
    if {[info var ::USER_TDM_PBLOCK_PATTERN] != {}} {
        set ::TDM_PBLOCK_PATTERN $::USER_TDM_PBLOCK_PATTERN
        puts " -I- USER_TDM_PBLOCK_PATTERN=$::TDM_PBLOCK_PATTERN"
    }

    proc getFrequencyDistribution {L} {
        catch {unset arr}
        set res [list]
        foreach el $L {
            if {![info exists arr($el)]} { set arr($el) 0 }
            incr arr($el)
        }
        foreach {el num} [array get arr] {
            lappend res [list $el $num]
        }
        set res [lsort -decreasing -real -index 1 [lsort -increasing -dictionary -index 0 $res]]
        return $res
    }

    # Proc to convert pblock to the SLR it belongs
    proc pblock2slr {pblock} {
        set pbs [get_pblocks -quiet $pblock]
        if {$pbs == {}} {
            return {}
        }
        set slrs [list]
        foreach pb $pbs {
            set range [get_property -quiet GRID_RANGES $pb]
            if {$range == {}} {
                continue
            }
            regsub -all {CLOCKREGION_} $range {} range
            # TODO: expand the range to cover pblocks crossing multiple SLRs
            regsub -all { } $range {:} range
            foreach elm [split $range :] {
                set slr {}
                switch -regexp -nocase -- $elm {
                    {^X[0-9]+Y[0-9]+$} {
                        set slr [get_slrs -quiet -of [get_clock_region -quiet $elm]]
                    }
                    {^SLICE_.+$} {
                        set slr [get_slrs -quiet -of [get_sites -quiet $elm]]
                    }
                    {^.+_X[0-9]+Y[0-9]+$} {
                        set slr [get_slrs -quiet -of [get_sites -quiet $elm]]
                    }
                    default {
                        puts " -E- pblock $pb: $elm"
                    }
                }
                if {$slr != {}} {
                    lappend slrs $slr
                }
            }
        }
        return [lsort -unique $slrs]
    }

    proc get_cells_of_pblock {pblock} {
        global TDM_FILTERING_PBLOCK_PATTERN
        set pblock [get_pblocks -quiet $pblock]
        if {$pblock == {}} {
            return [list]
        }
        set cells [filter [get_cells -quiet -of $pblock] $::TDM_FILTERING_PBLOCK_PATTERN ] ; llength $cells
        foreach hier [filter -quiet [get_cells -quiet -of $pblock] {!IS_PRIMITIVE}] {
        set tmpCells [get_cells -hier -filter "IS_PRIMITIVE && (NAME=~$hier/*)"]
            set fcells [filter -quiet $tmpCells $::TDM_FILTERING_PBLOCK_PATTERN]
            if {[llength $fcells]} {
                set cells [concat $cells $fcells]
            }
        }
        set cells [get_cells -quiet [lsort -unique $cells]]
            return $cells
    }

    ##################################################################
    # Build the list of HSTDM cells
    ##################################################################
    if {1} {
        if {$VERBOSE} { puts " -I- Searching for HSTDM logic" }
        catch {unset tdm}
        foreach slr [get_slrs] { set tdm($slr) [list] }
        foreach pblock [get_pblocks -quiet] {
            if {![regexp $::TDM_PBLOCK_PATTERN $pblock]} {
                if {$VERBOSE} { puts " -I- Skipping pblock $pblock (TDM_PBLOCK_PATTERN=$::TDM_PBLOCK_PATTERN)" }
                continue
            }
            # Get the SLR of the pblock
            set slr [pblock2slr $pblock]
            # If the SLR cannot be detected, then skip the current pblock
            if {$slr == {}} { continue }
            set cells [get_cells_of_pblock $pblock] ; llength $cells
            if {$VERBOSE} { puts " -I- Processing $pblock ([llength $cells] cells) ($slr)" }
            # Save the list of HSTDM cells for this SLR
            set tdm($slr) [concat $tdm($slr) $cells]
        }
        set fixed [get_cells -quiet -hier -filter {IS_FIXED && IS_PRIMITIVE}] ; llength $fixed
        set cells [filter -quiet $fixed $::TDM_FILTERING_FIXED_PATTERN]
        if {$VERBOSE} { puts " -I- Processing pre-placed HSTDM cells ([llength $cells] cells)" }
        foreach cell $cells {
            set slr [get_slrs -quiet -of $cell]
            lappend tdm($slr) $cell
        }
        foreach slr [get_slrs] { set tdm($slr) [get_cells -quiet [lsort -unique $tdm($slr)]] }
        foreach slr [get_slrs] { if {$VERBOSE} { puts " -I- HSTDM cells for $slr: [llength $tdm($slr)]" } }
    }

    ##################################################################
    # Build the information for HSTDM->TDM paths
    ##################################################################
    if {1} {
        if {$VERBOSE} { puts " -I- Searching for HSTDM->HSTDM paths" }
        catch {unset tdm2tdm}
        set start [clock seconds]
        foreach from $SLRS_FROM {
            foreach to $SLRS_TO {
                set tdm2tdm($from:$to) 0
                set tdm2tdm($from:$to:paths) [list]
                set tdm2tdm($from:$to:paths:zero) [list]
                set tdm2tdm($from:$to:paths:combo) [list]
                set tdm2tdm($from:$to:paths) [list]
                set tdm2tdm($from:$to:sps) [list]
                set tdm2tdm($from:$to:eps) [list]
                set tdm2tdm($from:$to:zero) 0
                set tdm2tdm($from:$to:zero:sps) [list]
                set tdm2tdm($from:$to:zero:eps) [list]
                set tdm2tdm($from:$to:combo) 0
                set tdm2tdm($from:$to:combo:sps) [list]
                set tdm2tdm($from:$to:combo:eps) [list]
                if {([llength $tdm($from)] == 0) || ([llength $tdm($to)] == 0)} {
                    continue
                }
                set stop [clock seconds]
                if {$VERBOSE} { puts " -I- runtime: [expr $stop - $start] seconds" }
                set paths [get_timing_paths -quiet -from $tdm($from) -to $tdm($to) -nworst 1 -unique_pins -max 100000] ; llength $paths
                set tdm2tdm($from:$to:paths) $paths
                #       set tdmpaths($from:$to) $paths
                if {$VERBOSE} { puts " -I- HSTDM $from -> $to : [llength $paths] paths" }
                #       set paths [filter $paths {EXCEPTION=={}}]
                if {[llength $paths] == 0} {
                #         puts " -I- $from -> $to : <none>"
                    continue
                }

                # Process the paths with no logic level
                set fpaths [filter -quiet $paths {LOGIC_LEVELS==0}]
                if {[llength $fpaths]} {
                    if {$VERBOSE} { puts " -I-     Paths with 0 logic levels: [llength $fpaths] paths" }
                    # Get the list of startpoints/endpoints
                    set sps [filter [get_property -quiet STARTPOINT_PIN $fpaths] {CLASS==pin}]; llength $sps
                    set eps [filter [get_property -quiet ENDPOINT_PIN $fpaths] {CLASS==pin}] ; llength $eps
                    foreach path $fpaths {
                    #           lappend tdmpaths($from:$to:zero) $path
                        lappend tdm2tdm($from:$to:paths:zero) $paths
                        incr tdm2tdm($from:$to)
                        incr tdm2tdm($from:$to:zero)
                    }
                    # Keep tracks of the startpoints/endpoints
                    set tdm2tdm($from:$to:zero:sps) $sps
                    set tdm2tdm($from:$to:zero:eps) $eps
                }

                # Process the paths with combinational logic
                set fpaths [filter -quiet $paths {LOGIC_LEVELS>=1}]
                if {[llength $fpaths]} {
                    if {$VERBOSE} { puts " -I-     Paths with combinational logic: [llength $fpaths] paths" }
                    # Get the list of startpoints/endpoints
                    set sps [filter [get_property -quiet STARTPOINT_PIN $fpaths] {CLASS==pin}]; llength $sps
                    set eps [filter [get_property -quiet ENDPOINT_PIN $fpaths] {CLASS==pin}] ; llength $eps
                    set fanin [get_cells -quiet -of [filter -quiet [all_fanin -quiet -flat $eps -startpoints_only] {CLASS==pin}]] ; llength $fanin
                    foreach cell $fanin {
                        if {[lsearch -exact $tdm($from) $cell] != -1} {
                            # Startpoint belong to SLR $from
                            #             lappend tdmpaths($from:$to:combo) $cell
                            incr tdm2tdm($from:$to)
                            incr tdm2tdm($from:$to:combo)
                            # Keep tracks of the startpoints
                            lappend tdm2tdm($from:$to:combo:sps) $cell
                        }
                    }
                    # Keep tracks of the endpoints
                    set tdm2tdm($from:$to:combo:eps) $eps
                    foreach path $fpaths {
                        lappend tdm2tdm($from:$to:paths:combo) $paths
                        #           lappend tdmpaths($from:$to:combo) $path
                    }
                }
                # Keep trscks of the startpoints/endpoints
                set tdm2tdm($from:$to:sps) [lsort -unique [concat $tdm2tdm($from:$to:zero:sps) $tdm2tdm($from:$to:combo:sps)]]
                set tdm2tdm($from:$to:eps) [lsort -unique [concat $tdm2tdm($from:$to:zero:eps) $tdm2tdm($from:$to:combo:eps)]]
                #       report_timing -of [lrange $paths 0 99] -name ${from}_${to}
            }
        }
        set stop [clock seconds]
        if {$VERBOSE} { puts " -I- runtime: [expr $stop - $start] seconds" }
    }

    ##################################################################
    # Build the information for the HSTDM -> SEQUENTIAL -> HSTDM paths
    ##################################################################
    if {1} {
        if {$VERBOSE} { puts " -I- Searching for HSTDM->SEQUENTIAL->TDM paths" }
        catch {unset pipe}
        #   foreach from [get_slrs] {}
        foreach from $SLRS_FROM {
        #     foreach to [get_slrs] {}
            foreach to $SLRS_TO {
                #      if {$from == $to} {
                #        set pipe{$from:$to} [list]
                #        set pipe{$from:$to} [list]
                #        continue
                #      }
                set pipe{$from:$to} [list]
                set pipe($from:$to:sps) [list]
                set pipe($from:$to:eps) [list]
                set fanout [filter -quiet [all_fanout -quiet -only_cells -flat [get_pins -quiet -filter {DIRECTION==OUT && IS_CONNECTED} -of_objects $tdm($from)]] {IS_PRIMITIVE && IS_SEQUENTIAL}] ; llength $fanout
                set fanin [filter -quiet [all_fanin -quiet -only_cells -flat [get_pins -filter {DIRECTION==IN && IS_CONNECTED && !IS_CLOCK && !IS_TIED} -of_objects $tdm($to)]] {IS_PRIMITIVE && IS_SEQUENTIAL}] ; llength $fanin
                set pipeline [list]
                if {1} {
                    if {[llength $fanout] > [llength $fanin]} {
                        # Switch $fanin and $fanoujt to improve runtime for the next 'foreach cell $fanin {...}'
                        foreach {fanin fanout} [list $fanout $fanin] { break }
                    }
                    catch {unset tmp}
                    foreach fo $fanout {
                        set tmp($fo) 1
                    }
                    foreach cell $fanin {
                        # Only consider cells that belong to both the fanout and fanin
                        if {[info exist tmp($cell)]} {
                            if {([lsearch -exact $tdm($from) $cell] == -1) && ([lsearch -exact $tdm($to) $cell] == -1)} {
                            # Register common to the fanin/fanout and that is not HSTDM logic => 1st level of pipeline between HSTDMs
                                lappend pipeline $cell
                            }
                        }
                    }
                }
                # Too slow ... use the code above instead
                if {0} {
                    foreach cell [lsort -unique [concat $fanout $fanin]] {
                        if {([lsearch -exact $fanout $cell] == -1) || ([lsearch -exact $fanin $cell] == -1)} {
                            # Skip cells that do not belong to both the fanout and fanin
                            continue
                        }
                        if {([lsearch -exact $tdm($from) $cell] == -1) && ([lsearch -exact $tdm($to) $cell] == -1)} {
                            # Register common to the fanin/fanout and that is not HSTDM logic => 1st level of pipeline between HSTDMs
                            lappend pipeline $cell
                        }
                    }
                }
                set pipe($from:$to) $pipeline
                if {[llength $pipeline]} {
                    # If some pipeline registers are found, we need to find the startpoints inside the SLR $from and endpoints inside SLR $to
                    if {$VERBOSE} { puts " -I- $from -> $to: found [llength $pipeline] pipelined registers ([lsort -unique [get_property -quiet REF_NAME $pipeline]])" }
                    set stop [clock seconds]
                    if {$VERBOSE} { puts " -I- runtime: [expr $stop - $start] seconds" }
                    set fanout [filter -quiet [all_fanout -quiet -only_cells -flat [get_pins -quiet -filter {DIRECTION==OUT && IS_CONNECTED} -of_objects $pipeline]] {IS_PRIMITIVE && IS_SEQUENTIAL}]
                    set fanin [filter -quiet [all_fanin -quiet -only_cells -flat [get_pins -filter {DIRECTION==IN && IS_CONNECTED && !IS_CLOCK && !IS_TIED} -of_objects $pipeline]] {IS_PRIMITIVE && IS_SEQUENTIAL}]
                    set sps [list]
                    if {1} {
                        catch {unset tmp}
                        foreach cell $tdm($from) {
                            set tmp($cell) 1
                        }
                        foreach cell $fanin {
                            if {[info exist tmp($cell)]} {
                                lappend sps $cell
                            }
                        }
                    }
                    # Too slow ... use the code above instead
                    if {0} {
                        foreach cell $fanin {
                            if {[lsearch -exact $tdm($from) $cell] != -1} {
                                lappend sps $cell
                            }
                        }
                    }
                    if {$VERBOSE} { puts " -I-     Number of startpoints from $from: [llength $sps] (([lsort -unique [get_property -quiet REF_NAME $sps]]))" }
                    set eps [list]


                    if {1} {
                        catch {unset tmp}
                        foreach cell $tdm($to) {
                            set tmp($cell) 1
                        }
                        foreach cell $fanout {
                            if {[info exist tmp($cell)]} {
                                lappend eps $cell
                            }
                        }
                    }
                    # Too slow ... use the code above instead
                    if {0} {
                        foreach cell $fanout {
                            if {[lsearch -exact $tdm($to) $cell] != -1} {
                                lappend eps $cell
                            }
                        }
                    }
                    if {$VERBOSE} { puts " -I-     Number of endpoints to $to: [llength $eps] (([lsort -unique [get_property -quiet REF_NAME $eps]]))" }
                    set pipe($from:$to) [list $sps $pipeline $eps]
                    set pipe($from:$to:sps) $sps
                    set pipe($from:$to:eps) $eps
                } else {
                    set pipe($from:$to) [list]
                    set pipe($from:$to:eps) [list]
                    set pipe($from:$to:sps) [list]
                }
            }
        }
    }

    ##################################################################
    # Build the information for the HSTDM -> RAM paths
    ##################################################################
    if {1} {
        if {$VERBOSE} { puts " -I- Searching for HSTDM->RAM paths" }
        # set brams [get_cells -hier -filter REF_NAME=~RAMB*] ; llength $brams
        set allrams [get_cells -hier -filter {REF_NAME=~RAMB* || REF_NAME=~URAM*}] ; llength $allrams
        # Input pins
        set ipins [get_pins -of $allrams -filter {DIRECTION==IN && IS_CONNECTED && !IS_TIED && !IS_CLOCK}] ; llength $ipins
        # Output pins
        set opins [get_pins -of $allrams -filter {DIRECTION==OUT && IS_CONNECTED}] ; llength $opins
        catch {unset tdm2rams}
        set tdm2rams(-) [list]
        foreach slr [get_slrs] {
            if {[llength $tdm($slr)] == 0} {
                set tdm2rams(${slr}:tdm) [list]
                # RAM cells
                set tdm2rams(${slr}:rams) [list]
                # RAM pins
                set tdm2rams(${slr}:pins) [list]
                continue
            }
            set fanin [filter -quiet [all_fanin -quiet -startpoints_only -only_cells -flat $ipins] {IS_PRIMITIVE && IS_SEQUENTIAL}] ; llength $fanin
            set sps [list]
            catch {unset tmp}
            foreach cell $tdm($slr) {
                set tmp($cell) 1
            }
            foreach cell $fanin {
                if {[info exist tmp($cell)]} {
                    lappend sps $cell
                }
            }
            # Need to find the exact number of RAM pins that are reached from the HSTDM cells
            set fanout [all_fanout -quiet -endpoints_only -flat [get_pins -quiet -filter {DIRECTION==OUT && IS_CONNECTED} -of_objects $sps]] ; llength $fanout
            set eps [list]
            catch {unset tmp}
            foreach pin $ipins {
                set tmp($pin) 1
            }
            foreach pin $fanout {
                if {[info exist tmp($pin)]} {
                    lappend eps $pin
                }
            }
            set tdm2rams(${slr}:tdm) [lsort -unique $sps]
            set tdm2rams(${slr}:rams) [lsort -unique [get_cells -quiet -of $eps]]
            set tdm2rams(${slr}:pins) [lsort -unique $eps]
            # All the processed rams
            set tdm2rams(-) [concat $tdm2rams(-) $tdm2rams(${slr}:rams)]
            if {$VERBOSE} { puts " -I- Processing $slr ([llength $tdm2rams(${slr}:tdm)] HSTDM cells) ([llength $tdm2rams(${slr}:rams)] RAMB/URAM cells)) ([llength $tdm2rams(${slr}:pins)] RAMB/URAM pins)" }
        }
        set tdm2rams(-) [lsort -dictionary -unique [get_cells -quiet $tdm2rams(-)]]
        if {$VERBOSE} { puts " -I- HSTDM->RAM: number of unique RAMs: [llength $tdm2rams(-)]" }
        set stop [clock seconds]
        if {$VERBOSE} { puts " -I- runtime: [expr $stop - $start] seconds" }
    }

    ##################################################################
    # Build the information for the RAM -> HSTDM paths
    ##################################################################
    if {1} {
        if {$VERBOSE} { puts " -I- Searching for RAM->TDM paths" }
        # set brams [get_cells -hier -filter REF_NAME=~RAMB*] ; llength $brams
        set allrams [get_cells -hier -filter {REF_NAME=~RAMB* || REF_NAME=~URAM*}] ; llength $allrams
        # Input pins
        set ipins [get_pins -of $allrams -filter {DIRECTION==IN && IS_CONNECTED && !IS_TIED && !IS_CLOCK}] ; llength $ipins
        # Output pins
        set opins [get_pins -of $allrams -filter {DIRECTION==OUT && IS_CONNECTED}] ; llength $opins
        catch {unset rams2tdm}
        set rams2tdm(-) [list]
        foreach slr [get_slrs] {
            if {[llength $tdm($slr)] == 0} {
                set rams2tdm(${slr}:tdm) [list]
                # RAM cells
                set rams2tdm(${slr}:rams) [list]
                # RAM pins
                set rams2tdm(${slr}:pins) [list]
                continue
            }
            set fanout [all_fanout -quiet -endpoints_only -flat $opins] ; llength $fanout
            set eps [list]
            catch {unset tmp}
            foreach cell $tdm($slr) {
                set tmp($cell) 1
            }
            foreach pin $fanout cell [get_property -quiet PARENT_CELL $fanout] {
                if {[info exist tmp($cell)]} {
                    lappend eps $pin
                }
            }
            # Need to find the exact number of RAM pins that are reached from the HSTDM cells
            set fanin [filter -quiet [all_fanin -quiet -flat $eps] {DIRECTION==OUT && (REF_NAME=~RAMB* || REF_NAME=~URAM*)}] ; llength $fanin
            set sps [list]
            catch {unset tmp}
            foreach cell $allrams {
                set tmp($cell) 1
            }
            foreach pin $fanin cell [get_property -quiet PARENT_CELL $fanin] {
                if {[info exist tmp($cell)]} {
                    #         lappend sps $cell
                    lappend sps $pin
                }
            }
            set rams2tdm(${slr}:tdm) [lsort -unique [get_cells -quiet -of $eps]]
                set rams2tdm(${slr}:rams) [lsort -unique [get_cells -quiet -of $sps]]
                set rams2tdm(${slr}:pins) [lsort -unique $sps]
                # All the processed rams
                set rams2tdm(-) [concat $rams2tdm(-) $rams2tdm(${slr}:rams)]
                if {$VERBOSE} { puts " -I- Processing $slr ([llength $rams2tdm(${slr}:rams)] RAMB/URAM cells)) ([llength $rams2tdm(${slr}:pins)] RAMB/URAM pins) ([llength $rams2tdm(${slr}:tdm)] HSTDM cells)" }
        }
        set rams2tdm(-) [lsort -dictionary -unique [get_cells -quiet $rams2tdm(-)]]
        if {$VERBOSE} { puts " -I- RAM->TDM: number of unique RAMs: [llength $rams2tdm(-)]" }
        set stop [clock seconds]
        if {$VERBOSE} { puts " -I- runtime: [expr $stop - $start] seconds" }
    }

    ##################################################################
    # Report the HSTDM -> HSTDM connectivity
    ##################################################################
    set FH [open tdm_summary.rpt {w}]
    foreach slr [get_slrs] { if {$VERBOSE} { puts $FH " -I- HSTDM cells for $slr: [llength $tdm($slr)]" } }
    if {[llength [get_slrs]] == 3} {
        # VU440: create fake entries to avoid missing elements inside the array for some of the reporting code
        foreach slr [get_slrs] {
            set tdm2tdm(SLR3:${slr}:sps) {}
            set tdm2tdm(SLR3:${slr}:eps) {}
            set tdm2tdm(${slr}:SLR3:sps) {}
            set tdm2tdm(${slr}:SLR3:eps) {}
            set pipe(SLR3:${slr}:sps) {}
            set pipe(SLR3:${slr}:eps) {}
            set pipe(${slr}:SLR3:sps) {}
            set pipe(${slr}:SLR3:eps) {}
        }
    }
    close $FH

    if {1} {
        set tbl [tclapp::xilinx::designutils::prettyTable]
        set tbl_all [tclapp::xilinx::designutils::prettyTable]
        set tbl_zero [tclapp::xilinx::designutils::prettyTable]
        set tbl_combo [tclapp::xilinx::designutils::prettyTable]
        # $tbl creatematrix [expr [llength [get_slrs]] +1] [llength [get_slrs]]  {-}
        # $tbl header [list {FROM \ TO} {SLR3} {SLR2} {SLR1} {SLR0} ]
        $tbl header [list {FROM \ TO} {SLR3} {SLR2} {SLR1} {SLR0} ]
        $tbl_all header [$tbl header] ; $tbl_all title "HSTDM -> HSTDM\n<startpoints>/<endpoints>"
        $tbl_zero header [$tbl header] ; $tbl_zero title "HSTDM -> HSTDM with zero logic level\n<startpoints>/<endpoints>"
        $tbl_combo header [$tbl header] ; $tbl_combo title "HSTDM -> HSTDM with combo logic\n<startpoints>/<endpoints>"
        set content_all [list]
        set content_zero [list]
        set content_combo [list]
        foreach from [lsort -decreasing [get_slrs]] {
            set row_all [list $from]
            set row_zero [list $from]
            set row_combo [list $from]
            foreach to [lsort -decreasing [get_slrs]] {
                if {$from == $to} {
                    lappend row_all {-}
                    lappend row_zero {-}
                    lappend row_combo {-}
                    continue
                }
                if {[info exist tdm2tdm($from:$to)]} {
                    #         lappend row_all $tdm2tdm($from:$to)
                    lappend row_all [format {%s/%s} $tdm2tdm($from:$to) [llength $tdm2tdm($from:$to:eps)] ]
                } else {
                    lappend row_all 0
                }
                if {[info exist tdm2tdm($from:$to:zero)]} {
                    #         lappend row_zero $tdm2tdm($from:$to:zero)
                    lappend row_zero [format {%s/%s} $tdm2tdm($from:$to:zero) [llength $tdm2tdm($from:$to:zero:eps)] ]
                } else {
                    lappend row_zero 0
                }
                if {[info exist tdm2tdm($from:$to:combo)]} {
                    #         lappend row_combo $tdm2tdm($from:$to:combo)
                    lappend row_combo [format {%s/%s} $tdm2tdm($from:$to:combo) [llength $tdm2tdm($from:$to:combo:eps)] ]
                } else {
                    lappend row_combo 0
                }
            }
            lappend content_all $row_all
            lappend content_zero $row_zero
            lappend content_combo $row_combo
        }
        $tbl settable $content_all
        $tbl_all settable $content_all
        $tbl_zero settable $content_zero
        $tbl_combo settable $content_combo
        #   puts [$tbl print]
        #   puts [$tbl_zero print -indent 2 -next_to [$tbl_combo print -indent 2 -next_to [$tbl_all print -indent 2 ]]]
        puts "\n1. HSTDM -> HSTDM Connectivity Matrix"
        puts "---------------------------------------"
        puts [$tbl_all print]
        puts "\n    1.1. HSTDM -> HSTDM Connectivity Matrix (paths with some combo logic)"
        puts "    ---------------------------------------------------------------------"
        puts [$tbl_combo print -indent 4]
        puts "\n    1.2. HSTDM -> HSTDM Connectivity Matrix (paths with 0 logic level)"
        puts "    ------------------------------------------------------------------"
        puts [$tbl_zero print -indent 4]

        # Generate some reporting files
        set FH [open tdm_summary.rpt {a}]
        puts $FH "\n1. HSTDM -> HSTDM Connectivity Matrix"
        puts $FH "---------------------------------------"
        puts $FH [$tbl_all print]
        puts $FH "\n    1.1. HSTDM -> HSTDM Connectivity Matrix (paths with some combo logic)"
        puts $FH "    ---------------------------------------------------------------------"
        puts $FH [$tbl_combo print -indent 4]
        puts $FH "\n    1.2. HSTDM -> HSTDM Connectivity Matrix (paths with 0 logic level)"
        puts $FH "    ------------------------------------------------------------------"
        puts $FH [$tbl_zero print -indent 4]
        #   puts " -I- Generated file [file normalize tdm_summary.rpt]"
        close $FH
    }

    ##################################################################
    # Report the HSTDM -> SEQUENTIAL -> HSTDM connectivity
    ##################################################################
    if {1} {
        puts "\n2. HSTDM -> SEQUENTIAL -> HSTDM Connectivity Matrix"
        puts "-----------------------------------------------------"
        set tbl [tclapp::xilinx::designutils::prettyTable]
        $tbl header [list {FROM \ TO} {SLR3} {SLR2} {SLR1} {SLR0} ]
        $tbl title "HSTDM -> SEQUENTIAL -> HSTDM\n<startpoints>/<endpoints>"
        set content [list]
        foreach from [lsort -decreasing [get_slrs]] {
            set row [list $from]
                foreach to [lsort -decreasing [get_slrs]] {
                    if {$from == $to} {
                        lappend row {-}
                        continue
                    }
                    if {[info exist pipe($from:$to)]} {
                        set sps {} ; set regs {} ; set eps {}
                        foreach {sps regs eps} $pipe($from:$to) { break }
                        lappend row [format {%s / %s} [llength $sps] [llength $eps] ]
                    } else {
                        lappend row {-/-}
                    }
                }
            lappend content $row
        }
        $tbl settable $content
        puts [$tbl print]

        # Generate some reporting files
        set FH [open tdm_summary.rpt {a}]
        puts $FH "\n2. HSTDM -> SEQUENTIAL -> HSTDM Connectivity Matrix"
        puts $FH "-----------------------------------------------------"
        puts $FH [$tbl print]

        set tbl [tclapp::xilinx::designutils::prettyTable]
        $tbl header [list {FROM \ TO} {SLR3} {SLR2} {SLR1} {SLR0} ]
        $tbl title "HSTDM -> SEQUENTIAL -> HSTDM\n<startpoints>/<sequential>/<endpoints>"
        set content [list]
        foreach from [lsort -decreasing [get_slrs]] {
            set row [list $from]
            foreach to [lsort -decreasing [get_slrs]] {
                if {$from == $to} {
                    lappend row {-}
                    continue
                }
                if {[info exist pipe($from:$to)]} {
                    set sps {} ; set regs {} ; set eps {}
                    foreach {sps regs eps} $pipe($from:$to) { break }
                    lappend row [format {%s / %s / %s} [llength $sps] [llength $regs] [llength $eps] ]
                    } else {
                        lappend row {-/-/-}
                    }
                }
            lappend content $row
        }
        $tbl settable $content
        puts [$tbl print -indent 4]
        puts $FH [$tbl print -indent 4]
        #   puts " -I- Generated file [file normalize tdm_summary.rpt]"
        close $FH
    }

    ##################################################################
    # Report the inter-SLR connectivity summary
    ##################################################################
    if {1} {
        puts "\n3. Inter-SLR Connectivity Matrix"
        puts "--------------------------------"
        set tbl [tclapp::xilinx::designutils::prettyTable]
        $tbl header [list {} {TDM} {TDM} ]
        $tbl title "Inter-SLR Connectivity Matrix\nHSTDM -> HSTDM"
        set SLR3_SLR2_sp [lsort -unique [concat $tdm2tdm(SLR3:SLR2:sps) $tdm2tdm(SLR3:SLR1:sps) $tdm2tdm(SLR3:SLR0:sps) ] ]
        set SLR3_SLR2_ep [lsort -unique [concat $tdm2tdm(SLR3:SLR2:eps) $tdm2tdm(SLR3:SLR1:eps) $tdm2tdm(SLR3:SLR0:eps) ] ]
        set SLR2_SLR3_sp [lsort -unique [concat $tdm2tdm(SLR2:SLR3:sps) $tdm2tdm(SLR1:SLR3:sps) $tdm2tdm(SLR0:SLR3:sps) ] ]
        set SLR2_SLR3_ep [lsort -unique [concat $tdm2tdm(SLR2:SLR3:eps) $tdm2tdm(SLR1:SLR3:eps) $tdm2tdm(SLR0:SLR3:eps) ] ]
        if {[llength [get_slrs]] == 4} {
            # VU19P
            $tbl addrow [list {SLR3 <-> SLR2} [llength [lsort -unique [concat $SLR3_SLR2_sp $SLR2_SLR3_ep]]] [llength [lsort -unique [concat $SLR3_SLR2_ep $SLR2_SLR3_sp] ]]]
            $tbl addrow [list {  SLR3 -> SLR2} [llength $SLR3_SLR2_sp] [llength $SLR3_SLR2_ep] ]
            $tbl addrow [list {  SLR3 <- SLR2} [llength $SLR2_SLR3_ep] [llength $SLR2_SLR3_sp] ]
        }
        #  $tbl addrow [list {SLR3 <-> SLR2} [llength [lsort -unique [concat $SLR3_SLR2_sp $SLR2_SLR3_ep]]] [llength [lsort -unique [concat $SLR3_SLR2_ep $SLR2_SLR3_sp] ]]]
        #  $tbl addrow [list {  SLR3 -> SLR2} [llength $SLR3_SLR2_sp] [llength $SLR3_SLR2_ep] ]
        #  $tbl addrow [list {  SLR3 <- SLR2} [llength $SLR2_SLR3_ep] [llength $SLR2_SLR3_sp] ]
        ##   $tbl addrow [list {  SLR2 -> SLR3} [llength $SLR2_SLR3_sp] [llength $SLR2_SLR3_ep] ]
        $tbl separator
        set SLR2_SLR1_sp [lsort -unique [concat $tdm2tdm(SLR2:SLR1:sps) $tdm2tdm(SLR2:SLR0:sps) $tdm2tdm(SLR3:SLR1:sps) $tdm2tdm(SLR3:SLR0:sps) ] ]
        set SLR2_SLR1_ep [lsort -unique [concat $tdm2tdm(SLR2:SLR1:eps) $tdm2tdm(SLR2:SLR0:eps) $tdm2tdm(SLR3:SLR1:eps) $tdm2tdm(SLR3:SLR0:eps) ] ]
        set SLR1_SLR2_sp [lsort -unique [concat $tdm2tdm(SLR1:SLR2:sps) $tdm2tdm(SLR1:SLR3:sps) $tdm2tdm(SLR0:SLR2:sps) $tdm2tdm(SLR0:SLR3:sps) ] ]
        set SLR1_SLR2_ep [lsort -unique [concat $tdm2tdm(SLR1:SLR2:eps) $tdm2tdm(SLR1:SLR3:eps) $tdm2tdm(SLR0:SLR2:eps) $tdm2tdm(SLR0:SLR3:eps) ] ]
        $tbl addrow [list {SLR2 <-> SLR1} [llength [lsort -unique [concat $SLR2_SLR1_sp $SLR1_SLR2_ep]]] [llength [lsort -unique [concat $SLR2_SLR1_ep $SLR1_SLR2_sp]]] ]
        $tbl addrow [list {  SLR2 -> SLR1} [llength $SLR2_SLR1_sp] [llength $SLR2_SLR1_ep] ]
        $tbl addrow [list {  SLR2 <- SLR1} [llength $SLR1_SLR2_ep] [llength $SLR1_SLR2_sp] ]
        #   $tbl addrow [list {  SLR1 -> SLR2} [llength $SLR1_SLR2_sp] [llength $SLR1_SLR2_ep] ]
        $tbl separator
        set SLR1_SLR0_sp [lsort -unique [concat $tdm2tdm(SLR1:SLR0:sps) $tdm2tdm(SLR2:SLR0:sps) $tdm2tdm(SLR3:SLR0:sps) ] ]
        set SLR1_SLR0_ep [lsort -unique [concat $tdm2tdm(SLR1:SLR0:eps) $tdm2tdm(SLR2:SLR0:eps) $tdm2tdm(SLR3:SLR0:eps) ] ]
        set SLR0_SLR1_sp [lsort -unique [concat $tdm2tdm(SLR0:SLR1:sps) $tdm2tdm(SLR0:SLR2:sps) $tdm2tdm(SLR0:SLR3:sps) ] ]
        set SLR0_SLR1_ep [lsort -unique [concat $tdm2tdm(SLR0:SLR1:eps) $tdm2tdm(SLR0:SLR2:eps) $tdm2tdm(SLR0:SLR3:eps) ] ]
        $tbl addrow [list {SLR1 <-> SLR0} [llength [lsort -unique [concat $SLR1_SLR0_sp $SLR0_SLR1_ep]]] [llength [lsort -unique [concat $SLR1_SLR0_ep $SLR0_SLR1_sp]]] ]
        $tbl addrow [list {  SLR1 -> SLR0} [llength $SLR1_SLR0_sp] [llength $SLR1_SLR0_ep] ]
        $tbl addrow [list {  SLR1 <- SLR0} [llength $SLR0_SLR1_ep] [llength $SLR0_SLR1_sp] ]
        #   $tbl addrow [list {  SLR0 -> SLR1} [llength $SLR0_SLR1_sp] [llength $SLR0_SLR1_ep] ]
        puts [$tbl print]

        # Generate some reporting files
        set FH [open tdm_summary.rpt {a}]
        puts $FH "\n3. Inter-SLR Connectivity Matrix"
        puts $FH "--------------------------------"
        puts $FH [$tbl print]
        close $FH
    }

    if {1} {
        #   puts "\n5. Inter-SLR Connectivity Matrix"
        #   puts "--------------------------------"
        set tbl [tclapp::xilinx::designutils::prettyTable]
        $tbl header [list {} {TDM} {TDM} ]
        $tbl title "Inter-SLR Connectivity Matrix\nHSTDM->SEQUENTIAL->HSTDM"
        set SLR3_SLR2_sp [lsort -unique [concat $pipe(SLR3:SLR2:sps) $pipe(SLR3:SLR1:sps) $pipe(SLR3:SLR0:sps) ] ]
        set SLR3_SLR2_ep [lsort -unique [concat $pipe(SLR3:SLR2:eps) $pipe(SLR3:SLR1:eps) $pipe(SLR3:SLR0:eps) ] ]
        set SLR2_SLR3_sp [lsort -unique [concat $pipe(SLR2:SLR3:sps) $pipe(SLR1:SLR3:sps) $pipe(SLR0:SLR3:sps) ] ]
        set SLR2_SLR3_ep [lsort -unique [concat $pipe(SLR2:SLR3:eps) $pipe(SLR1:SLR3:eps) $pipe(SLR0:SLR3:eps) ] ]
        if {[llength [get_slrs]] == 4} {
            # VU19P
            $tbl addrow [list {SLR3 <-> SLR2} [llength [lsort -unique [concat $SLR3_SLR2_sp $SLR2_SLR3_ep]]] [llength [lsort -unique [concat $SLR3_SLR2_ep $SLR2_SLR3_sp] ]]]
            $tbl addrow [list {  SLR3 -> SLR2} [llength $SLR3_SLR2_sp] [llength $SLR3_SLR2_ep] ]
            $tbl addrow [list {  SLR3 <- SLR2} [llength $SLR2_SLR3_ep] [llength $SLR2_SLR3_sp] ]
        }
        #   $tbl addrow [list {SLR3 <-> SLR2} [llength [lsort -unique [concat $SLR3_SLR2_sp $SLR2_SLR3_ep]]] [llength [lsort -unique [concat $SLR3_SLR2_ep $SLR2_SLR3_sp] ]]]
        #   $tbl addrow [list {  SLR3 -> SLR2} [llength $SLR3_SLR2_sp] [llength $SLR3_SLR2_ep] ]
        #   $tbl addrow [list {  SLR3 <- SLR2} [llength $SLR2_SLR3_ep] [llength $SLR2_SLR3_sp] ]
        # #   $tbl addrow [list {  SLR2 -> SLR3} [llength $SLR2_SLR3_sp] [llength $SLR2_SLR3_ep] ]
        $tbl separator
        set SLR2_SLR1_sp [lsort -unique [concat $pipe(SLR2:SLR1:sps) $pipe(SLR2:SLR0:sps) $pipe(SLR3:SLR1:sps) $pipe(SLR3:SLR0:sps) ] ]
        set SLR2_SLR1_ep [lsort -unique [concat $pipe(SLR2:SLR1:eps) $pipe(SLR2:SLR0:eps) $pipe(SLR3:SLR1:eps) $pipe(SLR3:SLR0:eps) ] ]
        set SLR1_SLR2_sp [lsort -unique [concat $pipe(SLR1:SLR2:sps) $pipe(SLR1:SLR3:sps) $pipe(SLR0:SLR2:sps) $pipe(SLR0:SLR3:sps) ] ]
        set SLR1_SLR2_ep [lsort -unique [concat $pipe(SLR1:SLR2:eps) $pipe(SLR1:SLR3:eps) $pipe(SLR0:SLR2:eps) $pipe(SLR0:SLR3:eps) ] ]
        $tbl addrow [list {SLR2 <-> SLR1} [llength [lsort -unique [concat $SLR2_SLR1_sp $SLR1_SLR2_ep]]] [llength [lsort -unique [concat $SLR2_SLR1_ep $SLR1_SLR2_sp]]] ]
        $tbl addrow [list {  SLR2 -> SLR1} [llength $SLR2_SLR1_sp] [llength $SLR2_SLR1_ep] ]
        $tbl addrow [list {  SLR2 <- SLR1} [llength $SLR1_SLR2_ep] [llength $SLR1_SLR2_sp] ]
        #   $tbl addrow [list {  SLR1 -> SLR2} [llength $SLR1_SLR2_sp] [llength $SLR1_SLR2_ep] ]
        $tbl separator
        set SLR1_SLR0_sp [lsort -unique [concat $pipe(SLR1:SLR0:sps) $pipe(SLR2:SLR0:sps) $pipe(SLR3:SLR0:sps) ] ]
        set SLR1_SLR0_ep [lsort -unique [concat $pipe(SLR1:SLR0:eps) $pipe(SLR2:SLR0:eps) $pipe(SLR3:SLR0:eps) ] ]
        set SLR0_SLR1_sp [lsort -unique [concat $pipe(SLR0:SLR1:sps) $pipe(SLR0:SLR2:sps) $pipe(SLR0:SLR3:sps) ] ]
        set SLR0_SLR1_ep [lsort -unique [concat $pipe(SLR0:SLR1:eps) $pipe(SLR0:SLR2:eps) $pipe(SLR0:SLR3:eps) ] ]
        $tbl addrow [list {SLR1 <-> SLR0} [llength [lsort -unique [concat $SLR1_SLR0_sp $SLR0_SLR1_ep]]] [llength [lsort -unique [concat $SLR1_SLR0_ep $SLR0_SLR1_sp]]] ]
        $tbl addrow [list {  SLR1 -> SLR0} [llength $SLR1_SLR0_sp] [llength $SLR1_SLR0_ep] ]
        $tbl addrow [list {  SLR1 <- SLR0} [llength $SLR0_SLR1_ep] [llength $SLR0_SLR1_sp] ]
        #   $tbl addrow [list {  SLR0 -> SLR1} [llength $SLR0_SLR1_sp] [llength $SLR0_SLR1_ep] ]
        puts [$tbl print]

        # Generate some reporting files
        set FH [open tdm_summary.rpt {a}]
        #   puts $FH "\n5. Inter-SLR Connectivity Matrix"
        #   puts $FH "--------------------------------"
        puts $FH [$tbl print]
        close $FH
    }

    if {1} {
        #   puts "\n5. Inter-SLR Connectivity Matrix"
        #   puts "--------------------------------"
        set tbl [tclapp::xilinx::designutils::prettyTable]
        $tbl header [list {} {TDM} {TDM} ]
        $tbl title "Inter-SLR Connectivity Matrix\nTOTAL: HSTDM -> HSTDM + HSTDM->SEQUENTIAL->HSTDM"
        set SLR3_SLR2_sp [lsort -unique [concat $tdm2tdm(SLR3:SLR2:sps) $tdm2tdm(SLR3:SLR1:sps) $tdm2tdm(SLR3:SLR0:sps) $pipe(SLR3:SLR2:sps) $pipe(SLR3:SLR1:sps) $pipe(SLR3:SLR0:sps) ] ]
        set SLR3_SLR2_ep [lsort -unique [concat $tdm2tdm(SLR3:SLR2:eps) $tdm2tdm(SLR3:SLR1:eps) $tdm2tdm(SLR3:SLR0:eps) $pipe(SLR3:SLR2:eps) $pipe(SLR3:SLR1:eps) $pipe(SLR3:SLR0:eps) ] ]
        set SLR2_SLR3_sp [lsort -unique [concat $tdm2tdm(SLR2:SLR3:sps) $tdm2tdm(SLR1:SLR3:sps) $tdm2tdm(SLR0:SLR3:sps) $pipe(SLR2:SLR3:sps) $pipe(SLR1:SLR3:sps) $pipe(SLR0:SLR3:sps) ] ]
        set SLR2_SLR3_ep [lsort -unique [concat $tdm2tdm(SLR2:SLR3:eps) $tdm2tdm(SLR1:SLR3:eps) $tdm2tdm(SLR0:SLR3:eps) $pipe(SLR2:SLR3:eps) $pipe(SLR1:SLR3:eps) $pipe(SLR0:SLR3:eps) ] ]
        if {[llength [get_slrs]] == 4} {
            # VU19P
            $tbl addrow [list {SLR3 <-> SLR2} [llength [lsort -unique [concat $SLR3_SLR2_sp $SLR2_SLR3_ep]]] [llength [lsort -unique [concat $SLR3_SLR2_ep $SLR2_SLR3_sp] ]]]
            $tbl addrow [list {  SLR3 -> SLR2} [llength $SLR3_SLR2_sp] [llength $SLR3_SLR2_ep] ]
            $tbl addrow [list {  SLR3 <- SLR2} [llength $SLR2_SLR3_ep] [llength $SLR2_SLR3_sp] ]
        }
        #   $tbl addrow [list {SLR3 <-> SLR2} [llength [lsort -unique [concat $SLR3_SLR2_sp $SLR2_SLR3_ep]]] [llength [lsort -unique [concat $SLR3_SLR2_ep $SLR2_SLR3_sp] ]]]
        #   $tbl addrow [list {  SLR3 -> SLR2} [llength $SLR3_SLR2_sp] [llength $SLR3_SLR2_ep] ]
        #   $tbl addrow [list {  SLR3 <- SLR2} [llength $SLR2_SLR3_ep] [llength $SLR2_SLR3_sp] ]
        # #   $tbl addrow [list {  SLR2 -> SLR3} [llength $SLR2_SLR3_sp] [llength $SLR2_SLR3_ep] ]
        $tbl separator
        set SLR2_SLR1_sp [lsort -unique [concat $tdm2tdm(SLR2:SLR1:sps) $tdm2tdm(SLR2:SLR0:sps) $tdm2tdm(SLR3:SLR1:sps) $tdm2tdm(SLR3:SLR0:sps) $pipe(SLR2:SLR1:sps) $pipe(SLR2:SLR0:sps) $pipe(SLR3:SLR1:sps) $pipe(SLR3:SLR0:sps) ] ]
        set SLR2_SLR1_ep [lsort -unique [concat $tdm2tdm(SLR2:SLR1:eps) $tdm2tdm(SLR2:SLR0:eps) $tdm2tdm(SLR3:SLR1:eps) $tdm2tdm(SLR3:SLR0:eps) $pipe(SLR2:SLR1:eps) $pipe(SLR2:SLR0:eps) $pipe(SLR3:SLR1:eps) $pipe(SLR3:SLR0:eps) ] ]
        set SLR1_SLR2_sp [lsort -unique [concat $tdm2tdm(SLR1:SLR2:sps) $tdm2tdm(SLR1:SLR3:sps) $tdm2tdm(SLR0:SLR2:sps) $tdm2tdm(SLR0:SLR3:sps) $pipe(SLR1:SLR2:sps) $pipe(SLR1:SLR3:sps) $pipe(SLR0:SLR2:sps) $pipe(SLR0:SLR3:sps) ] ]
        set SLR1_SLR2_ep [lsort -unique [concat $tdm2tdm(SLR1:SLR2:eps) $tdm2tdm(SLR1:SLR3:eps) $tdm2tdm(SLR0:SLR2:eps) $tdm2tdm(SLR0:SLR3:eps) $pipe(SLR1:SLR2:eps) $pipe(SLR1:SLR3:eps) $pipe(SLR0:SLR2:eps) $pipe(SLR0:SLR3:eps) ] ]
        $tbl addrow [list {SLR2 <-> SLR1} [llength [lsort -unique [concat $SLR2_SLR1_sp $SLR1_SLR2_ep]]] [llength [lsort -unique [concat $SLR2_SLR1_ep $SLR1_SLR2_sp]]] ]
        $tbl addrow [list {  SLR2 -> SLR1} [llength $SLR2_SLR1_sp] [llength $SLR2_SLR1_ep] ]
        $tbl addrow [list {  SLR2 <- SLR1} [llength $SLR1_SLR2_ep] [llength $SLR1_SLR2_sp] ]
        #   $tbl addrow [list {  SLR1 -> SLR2} [llength $SLR1_SLR2_sp] [llength $SLR1_SLR2_ep] ]
        $tbl separator
        set SLR1_SLR0_sp [lsort -unique [concat $tdm2tdm(SLR1:SLR0:sps) $tdm2tdm(SLR2:SLR0:sps) $tdm2tdm(SLR3:SLR0:sps) $pipe(SLR1:SLR0:sps) $pipe(SLR2:SLR0:sps) $pipe(SLR3:SLR0:sps) ] ]
        set SLR1_SLR0_ep [lsort -unique [concat $tdm2tdm(SLR1:SLR0:eps) $tdm2tdm(SLR2:SLR0:eps) $tdm2tdm(SLR3:SLR0:eps) $pipe(SLR1:SLR0:eps) $pipe(SLR2:SLR0:eps) $pipe(SLR3:SLR0:eps) ] ]
        set SLR0_SLR1_sp [lsort -unique [concat $tdm2tdm(SLR0:SLR1:sps) $tdm2tdm(SLR0:SLR2:sps) $tdm2tdm(SLR0:SLR3:sps) $pipe(SLR0:SLR1:sps) $pipe(SLR0:SLR2:sps) $pipe(SLR0:SLR3:sps) ] ]
        set SLR0_SLR1_ep [lsort -unique [concat $tdm2tdm(SLR0:SLR1:eps) $tdm2tdm(SLR0:SLR2:eps) $tdm2tdm(SLR0:SLR3:eps) $pipe(SLR0:SLR1:eps) $pipe(SLR0:SLR2:eps) $pipe(SLR0:SLR3:eps) ] ]
        $tbl addrow [list {SLR1 <-> SLR0} [llength [lsort -unique [concat $SLR1_SLR0_sp $SLR0_SLR1_ep]]] [llength [lsort -unique [concat $SLR1_SLR0_ep $SLR0_SLR1_sp]]] ]
        $tbl addrow [list {  SLR1 -> SLR0} [llength $SLR1_SLR0_sp] [llength $SLR1_SLR0_ep] ]
        $tbl addrow [list {  SLR1 <- SLR0} [llength $SLR0_SLR1_ep] [llength $SLR0_SLR1_sp] ]
        #   $tbl addrow [list {  SLR0 -> SLR1} [llength $SLR0_SLR1_sp] [llength $SLR0_SLR1_ep] ]
        puts [$tbl print]

        # Generate some reporting files
        set FH [open tdm_summary.rpt {a}]
        #   puts $FH "\n5. Inter-SLR Connectivity Matrix"
        #   puts $FH "--------------------------------"
        puts $FH [$tbl print]
        close $FH
    }

    ##################################################################
    # Report the HSTDM -> RAM connectivity matrix
    ##################################################################
    if {1} {
        puts "\n4. HSTDM -> RAM Connectivity Matrix"
        puts "------------------------------------"
        set tbl [tclapp::xilinx::designutils::prettyTable]
        $tbl header [list {SLR} {TDM} {RAM Cells} {RAM Pins} {RAM Types}]
        $tbl title "HSTDM -> RAM"
        set tdmCells [list]
        set ramCells [list]
        set ramPins [list]
        foreach slr [lsort -decreasing [get_slrs]] {
            set row [list $slr [llength $tdm2rams(${slr}:tdm)] [llength $tdm2rams(${slr}:rams)] [llength $tdm2rams(${slr}:pins)] [lsort -unique [get_property -quiet REF_NAME $tdm2rams(${slr}:rams)]] ]
            set tdmCells [concat $tdmCells $tdm2rams(${slr}:tdm)]
            set ramCells [concat $ramCells $tdm2rams(${slr}:rams)]
            set ramPins [concat $ramPins $tdm2rams(${slr}:pins)]
            $tbl addrow $row
        }
        $tbl separator
        $tbl addrow [list {Total (unique)} [llength [lsort -unique $tdmCells]] [llength [lsort -unique $ramCells]] [llength [lsort -unique $ramPins]] {} ]
        if {[llength [lsort -unique $ramCells]] == 0} {
            puts "No path"
        } else {
            puts [$tbl print]
        }

        # Generate some reporting files
        set FH [open tdm_summary.rpt {a}]
        puts $FH "\n4. HSTDM -> RAM Connectivity Matrix"
        puts $FH "------------------------------------"
        if {[llength [lsort -unique $ramCells]] == 0} {
            puts $FH "No path"
        } else {
            puts $FH [$tbl print]
        }
    close $FH
    }

    ##################################################################
    # Report the HSTDM -> RAM connectivity summary
    ##################################################################
    if {1} {
        puts "\n5. HSTDM -> RAM Connectivity Summary"
            puts "-------------------------------------"

            set FH [open tdm_summary.rpt {a}]
            puts $FH "\n5. HSTDM -> RAM Connectivity Summary"
            puts $FH "-------------------------------------"

            catch { unset db }
        foreach slr [lsort -decreasing [get_slrs]] {
            if {[info exist tdm2rams(${slr}:pins)]} {
                foreach pin $tdm2rams(${slr}:pins) {
                    lappend db([get_property -quiet PARENT_CELL $pin]) $slr
                }
            }
        }

        if {[llength [array name db]] == 0} {
            puts "No path"
                puts $FH "No path"
        } else {

            foreach cell [array name db] {
                # E.g:
                # <ram1>   {SLR3 83} {SLR1 72} {SLR2 72} {SLR0 70}
                # <ram2>   {SLR3 19} {SLR1 8} {SLR2 8} {SLR0 7}
                # <ram3>   {SLR3 83} {SLR1 72} {SLR2 72} {SLR0 69}
                # <ram4>   {SLR0 3}
                #       puts "$cell \t [getFrequencyDistribution $db($cell)]"
            }

            set tbl [tclapp::xilinx::designutils::prettyTable]
            $tbl header [list {SLRs} {RAM Cells}]
            $tbl title "HSTDM -> RAM\nSummary Table"
            catch { unset db2 }
            foreach cell [array name db] {
                #   puts "<cell:$db($cell)>"
                incr db2([lsort -unique $db($cell)])
            }
            foreach key [array name db2] {
                #       puts "$key \t $db2($key)"
                $tbl addrow [list $key $db2($key)]
            }
            $tbl sort -integer -1
            puts [$tbl print]
            puts $FH [$tbl print]

            set tbl [tclapp::xilinx::designutils::prettyTable]
            $tbl header [list {SLRs} {RAM Cells} {RAM Pins} {Total RAM Pins} ]
            $tbl title "HSTDM -> RAM\nDetailed Table"
            catch { unset db2 }
            foreach cell [array name db] {
                # E.g:
                # db2({SLR0 3})                                = 1
                # db2({SLR3 19} {SLR1 8} {SLR2 8} {SLR0 7})    = 1
                # db2({SLR3 83} {SLR1 72} {SLR2 72} {SLR0 69}) = 1
                # db2({SLR3 83} {SLR1 72} {SLR2 72} {SLR0 70}) = 6
                incr db2([getFrequencyDistribution $db($cell)])
            }
            foreach key [array name db2] {
                #       puts "$key \t $db2($key)"
                set count 0
                # E.g: {SLR3 83} {SLR1 72} {SLR2 72} {SLR0 70}
                foreach el $key {
                    foreach {slr num} $el { break }
                    if {[catch { incr count $num } errorstring]} {
                        puts " -E- $errorstring"
                    }
                }
                $tbl addrow [list $key $db2($key) $count [expr $db2($key) * $count] ]
            }
            $tbl sort -integer -1
            puts [$tbl print]
            puts $FH [$tbl print]

        }

        # Close file
        close $FH
    }

    ##################################################################
    # Report the RAM -> HSTDM connectivity matrix
    ##################################################################
    if {1} {
        puts "\n6. RAM -> HSTDM Connectivity Matrix"
        puts "------------------------------------"
        set tbl [tclapp::xilinx::designutils::prettyTable]
        $tbl header [list {SLR} {RAM Cells} {RAM Pins} {TDM} {RAM Types}]
        $tbl title "IO RAM -> HSTDM"
        set tdmCells [list]
        set ramCells [list]
        set ramPins [list]
        foreach slr [lsort -decreasing [get_slrs]] {
            set row [list $slr [llength $rams2tdm(${slr}:rams)] [llength $rams2tdm(${slr}:pins)] [llength $rams2tdm(${slr}:tdm)] [lsort -unique [get_property -quiet REF_NAME $rams2tdm(${slr}:rams)]] ]
            set tdmCells [concat $tdmCells $rams2tdm(${slr}:tdm)]
            set ramCells [concat $ramCells $rams2tdm(${slr}:rams)]
            set ramPins [concat $ramPins $rams2tdm(${slr}:pins)]
            $tbl addrow $row
        }
        $tbl separator
        $tbl addrow [list {Total (unique)} [llength [lsort -unique $ramCells]] [llength [lsort -unique $ramPins]] [llength [lsort -unique $tdmCells]] {} ]
        if {[llength [lsort -unique $ramCells]] == 0} {
            puts "No path"
        } else {
            puts [$tbl print]
        }

        # Generate some reporting files
        set FH [open tdm_summary.rpt {a}]
        puts $FH "\n6. RAM -> HSTDM Connectivity Matrix"
        puts $FH "------------------------------------"
        if {[llength [lsort -unique $ramCells]] == 0} {
            puts $FH "No path"
        } else {
            puts $FH [$tbl print]
        }
        close $FH
    }

    ##################################################################
    # Report the RAM -> HSTDM connectivity summary
    ##################################################################
    if {1} {
        puts "\n7. RAM -> HSTDM Connectivity Summary"
        puts "-------------------------------------"

        set FH [open tdm_summary.rpt {a}]
        puts $FH "\n7. RAM -> HSTDM Connectivity Summary"
        puts $FH "-------------------------------------"

        catch { unset db }
        foreach slr [lsort -decreasing [get_slrs]] {
            if {[info exist rams2tdm(${slr}:pins)]} {
                foreach pin $rams2tdm(${slr}:pins) {
                    lappend db([get_property -quiet PARENT_CELL $pin]) $slr
                }
            }
        }

        if {[llength [array name db]] == 0} {
            puts "No path"
            puts $FH "No path"
        } else {

            foreach cell [array name db] {
                # E.g:
                # <ram1>   {SLR3 83} {SLR1 72} {SLR2 72} {SLR0 70}
                # <ram2>   {SLR3 19} {SLR1 8} {SLR2 8} {SLR0 7}
                # <ram3>   {SLR3 83} {SLR1 72} {SLR2 72} {SLR0 69}
                # <ram4>   {SLR0 3}
                #       puts "$cell \t [getFrequencyDistribution $db($cell)]"
            }

            set tbl [tclapp::xilinx::designutils::prettyTable]
            $tbl header [list {SLRs} {RAM Cells}]
            $tbl title "RAM -> HSTDM\nSummary Table"
            catch { unset db2 }
            foreach cell [array name db] {
                #   puts "<cell:$db($cell)>"
                incr db2([lsort -unique $db($cell)])
            }
            foreach key [array name db2] {
                #       puts "$key \t $db2($key)"
                $tbl addrow [list $key $db2($key)]
            }
            $tbl sort -integer -1
            puts [$tbl print]
            puts $FH [$tbl print]

            set tbl [tclapp::xilinx::designutils::prettyTable]
            $tbl header [list {SLRs} {RAM Cells} {RAM Pins} {Total RAM Pins} ]
            $tbl title "RAM -> HSTDM\nDetailed Table"
            catch { unset db2 }
            foreach cell [array name db] {
                # E.g:
                # db2({SLR0 3})                                = 1
                # db2({SLR3 19} {SLR1 8} {SLR2 8} {SLR0 7})    = 1
                # db2({SLR3 83} {SLR1 72} {SLR2 72} {SLR0 69}) = 1
                # db2({SLR3 83} {SLR1 72} {SLR2 72} {SLR0 70}) = 6
                incr db2([getFrequencyDistribution $db($cell)])
            }
            foreach key [array name db2] {
                #       puts "$key \t $db2($key)"
                set count 0
                # E.g: {SLR3 83} {SLR1 72} {SLR2 72} {SLR0 70}
                foreach el $key {
                    foreach {slr num} $el { break }
                    if {[catch { incr count $num } errorstring]} {
                        puts " -E- $errorstring"
                    }
                }
                $tbl addrow [list $key $db2($key) $count [expr $db2($key) * $count] ]
            }
            $tbl sort -integer -1
            puts [$tbl print]
            puts $FH [$tbl print]

        }

        # Close file
        close $FH
    }

    puts "\n -I- Generated file [file normalize tdm_summary.rpt]"

    set stop [clock seconds]
    if {$VERBOSE} { puts " -I- Total runtime (report_tdm.tcl): [expr $stop - $start] seconds" }

    if {$VERBOSE} { puts " -I- STOP report_tdm.tcl" }
}
###############################################################################
######     SLL-TDM Timing Signoff using Vivado tcl                          ###
###############################################################################
proc reportTDMTiming {{corners "Slow"} {dlyTypes "max"} {margin 10.0} {T 10.0}} {

    set debug 0

    #  1. create group of TMD inputs per index
    #  2. run timing analysis to each group of TDM inputs to get the datapath delay
    #     + get source clock delay to clock pin of startpoint and stor in array
    #  3. run timing analysis from each group of TDM output FD (RX): N*N max paths, with N nworst per endpoint, with unique pins
    #     + store datapath delay + delay to endpoint clock pin
    #     + do analysis for TDM outputs not covered during first timer call (could be compile time intensive)
    #  4. add up delays. For max analysis, TDM delay is (ratio+1)*T. For min analysis, TDM delay is T, where T is the fast clock period (10ns default)
    #     + adjust TDM delay for multi SLR TDM
    
    catch {unset tdmInDelay}; catch {unset tdmInClock}
    array set sllTDMStats {}

    # Step #1
    puts "\nInfo - Step #1 - [clock format [clock seconds]]"
    set tdmInLUTs [get_cells Reg_TdmGrp_*_R*_fSLR*_tSLR*_lutTx*]
    puts "Info - Analyzing [llength $tdmInLUTs] TDM input LUTs"
    set nbTdmInputs 0
    foreach cell $tdmInLUTs {
        if {![regexp {^Reg_TdmGrp_(\d+)_R(\d+)_fSLR(\d)_tSLR(\d)_lutTx(\d+)} [get_property NAME $cell] foo tdmId tdmRatio fromSLR toSLR lutIndex]} {
            puts "Error - Invalid name pattern #1 - $cell"; return
        }
        set lutIndex [expr $lutIndex * 2]
        foreach lutIn {0 1} {
            set tdmInputIndex [expr $lutIndex + $lutIn]
            if {$tdmInputIndex >= $tdmRatio} { continue }
            lappend tdmInputs($tdmInputIndex) [get_property NAME $cell]/I[expr $lutIn * 2]
            incr nbTdmInputs
            if {$tdmInputIndex == 0} { lappend sllTDMStats(fromSLR${fromSLR}_toSLR${toSLR}_tdmRatio${tdmRatio}) $tdmId }
        }
    }
    puts "Info - Found $nbTdmInputs TDM inputs"
    foreach k [lsort [array names sllTDMStats]] {
        puts [format "Info - %4s %s SLL TDMs" [llength [lsort -unique $sllTDMStats($k)]] $k]
    }
    # Step #2
    puts "\nInfo - Step #2 - [clock format [clock seconds]]"
    foreach corner $corners {
        foreach dlyType $dlyTypes {
            foreach tdmInputIndex [lsort -increasing -integer [array names tdmInputs]] {
                puts "Info - reporting [llength $tdmInputs($tdmInputIndex)] paths to TDM inputs index $tdmInputIndex in ${corner}_${dlyType}"
                foreach path [get_timing_paths -quiet -through [get_pins $tdmInputs($tdmInputIndex)] -max_paths [llength $tdmInputs($tdmInputIndex)] -corner $corner -delay_type $dlyType] {
                    set sp [get_property STARTPOINT_PIN $path]
                    set ep [get_property ENDPOINT_PIN $path]
                    set dp [get_property DATAPATH_DELAY $path]
                    if {![regexp {^Reg_TdmGrp_(\d+)_R(\d+)_fSLR\d_tSLR\d_tx/D} [get_property NAME $ep] foo tdmId tdmRatio]} {
                        puts "Error - Invalid name pattern #2 - $ep"; return
                    }
                    set key ${corner}_${dlyType}_TDM${tdmId}_R${tdmRatio}_I${tdmInputIndex}
                    set tdmInDelay($key) $dp
                    set tdmInClock($key) [get_property STARTPOINT_CLOCK $path]
                    set tdmInClockPeriod($key) [get_property -quiet PERIOD [get_property STARTPOINT_CLOCK $path]]
                }
            }
        }
    }
    # Step #3
    puts "\nInfo - Step #3 - [clock format [clock seconds]]"
    set rxTdmGrps [get_cells Reg_TdmGrp_*_R*_fSLR*_tSLR*_rx_0]
    foreach corner $corners {
        foreach dlyType $dlyTypes {
            puts "Info - Analyzing [llength $rxTdmGrps] TDM output groups in ${corner}_${dlyType}"
            set j 0
            set rxFDNoCovered ""
            set violations(${corner}_${dlyType}) ""
            foreach grp $rxTdmGrps {
                if {![regexp {^Reg_TdmGrp_(\d+)_R(\d+)_fSLR(\d)_tSLR(\d)_rx_0} [get_property NAME $grp] foo tdmId tdmRatio fromSLR toSLR]} {
                    puts "Error - Invalid name pattern #3 - $grp"; return
                }
                set key TDM${tdmId}_R${tdmRatio}
                set tdmCycles($key) [expr abs($fromSLR - $toSLR)]
                set maxPaths [expr $tdmRatio * $tdmRatio]
                set sps [get_pins Reg_TdmGrp_${tdmId}_R${tdmRatio}_fSLR${fromSLR}_tSLR${toSLR}_rx_*/C]
                set paths [getWorstPathPerStartpoint $sps $corner $dlyType]
                if {$debug} {
                    #puts "Debug: $tdmRatio - [llength $paths] paths"
                    puts " - ratio: $tdmRatio - paths: [llength $paths]"
                }
                for {set i 0} {$i < $tdmRatio} {incr i} {
                    incr j
                    set pathi [filter $paths STARTPOINT_PIN==Reg_TdmGrp_${tdmId}_R${tdmRatio}_fSLR${fromSLR}_tSLR${toSLR}_rx_${i}/C]
                    if {$pathi == {}} {
                        puts "Critical: no path for startpoint - Reg_TdmGrp_${tdmId}_R${tdmRatio}_fSLR${fromSLR}_tSLR${toSLR}_rx_${i}/C"
                            lappend rxFDNoCovered "Reg_TdmGrp_${tdmId}_R${tdmRatio}_fSLR${fromSLR}_tSLR${toSLR}_rx_${i}/C"
                            continue
                    }
                    set key ${corner}_${dlyType}_TDM${tdmId}_R${tdmRatio}_I${i}
                    set tdmOutClock($key) [get_property ENDPOINT_CLOCK $pathi]
                    set tdmOutClockPeriod($key) [get_property -quiet PERIOD [get_property ENDPOINT_CLOCK $pathi]]
                    if {$dlyType == "max"} {
                        set tdmOutDelay($key) [get_property DATAPATH_DELAY $pathi]
                        set tdmDelay($key) [format "%.3f" [expr $tdmInDelay($key) + ($tdmRatio + $tdmCycles(TDM${tdmId}_R${tdmRatio})) * $T + $tdmOutDelay($key)]]
                        set pathReq [get_property -quiet -min PERIOD [concat $tdmInClockPeriod($key) $tdmOutClockPeriod($key)]]
                        set slack [format "%.3f" [expr $pathReq - $tdmDelay($key) - $margin]]
                        if {$pathReq != "" && $slack < 0} {
                            lappend violations(${corner}_${dlyType}) $key
                            if {1} { puts "Warning - $key has less than ${margin}ns margin: $pathReq - $tdmDelay($key) - $margin = $slack" }
                        }
                        if {[expr $j % 1000] == "0"} {
                            puts "Debug: TDM path $j - [clock format [clock seconds]]"
                            puts "Debug:   $key : $tdmInDelay($key) + ($tdmRatio + $tdmCycles(TDM${tdmId}_R${tdmRatio})) * $T + $tdmOutDelay($key) = $tdmDelay($key)"
                            puts "Debug:     from clock = $tdmInClock($key) ($tdmInClockPeriod($key)ns)"
                            puts "Debug:       to clock = $tdmOutClock($key) ($tdmOutClockPeriod($key)ns)"
                        }
                    } else {
                        set tdmOutDelay($key) [get_property DATAPATH_DELAY $pathi]
                        set tdmDelay($key) [format "%.3f" [expr $tdmInDelay($key) + $tdmCycles(TDM${tdmId}_R${tdmRatio}) * $T + $tdmOutDelay($key)]]
                        set slack [format "%.3f" [expr $tdmDelay($key) - $margin]]
                        if {$slack < 0} {
                            lappend violations(${corner}_${dlyType}) $key
                            if {1} { puts "Warning - $key has less than ${margin}ns margin: $tdmDelay($key) - $margin = $slack" }
                        }
                        if {[expr $j % 1000] == "0"} {
                            puts "Debug: TDM path $j - [clock format [clock seconds]]"
                            puts "Debug:   $key : $tdmInDelay($key) + $tdmCycles(TDM${tdmId}_R${tdmRatio}) * $T + $tdmOutDelay($key) = $tdmDelay($key)"
                            puts "Debug:     from clock = $tdmInClock($key) ($tdmInClockPeriod($key)ns)"
                            puts "Debug:       to clock = $tdmOutClock($key) ($tdmOutClockPeriod($key)ns)"
                        }
                    }
                }
            }
            puts "Info - [llength $rxFDNoCovered] TDM outputs not reported (${corner}_${dlyType})"
        }
    }
    # Step #3
    puts "\nInfo - Step #4 - [clock format [clock seconds]]"
    if {[info exist violations]} {
        foreach {k v} [array get violations] {
            puts "Summary: SLL TDMs in $k have [llength $v] paths with less than ${margin}ns margin"
        }
    }
}

proc getWorstPathPerStartpoint {sps corner dlyType} {
    set debug 0
    set N [llength $sps]
    set MP [expr $N * $N]
    set L 0
    set NW $N
    set result {}
    if {$debug} { puts -nonewline "Debug: " }
    while {[llength $result] < $N && $L < $N} {
        set spNoEp ""
        #set paths [get_timing_paths -quiet -from $sps -max_paths $MP -nworst $NW -unique_pins -corner $corner -delay_type $dlyType]
        set paths [get_timing_paths -quiet -from $sps -max_paths $MP -nworst 1 -unique_pins -corner $corner -delay_type $dlyType]
        if {$debug} { puts -nonewline " $L" }
        foreach sp $sps {
            set pathi [filter $paths STARTPOINT_PIN==[get_property NAME $sp]]
            if {$pathi == {}} { lappend spNoEp $sp; continue }
            lappend result [lindex $pathi 0]
        }
        incr L
        set NW [llength $spNoEp]
        set MP [expr $NW * $NW]
        set sps $spNoEp
    }
    return $result
}

proc hVivado_generate_sllTdm_analysis {} {
    global GenerateSLLTDMReport
    global TimingSignOffSllTDM
    global TimingSignOffSllTDMCTM
    global DesignName
    global DeviceName
    global SllOptVivadoEnable
    if { (${GenerateSLLTDMReport} == 1) } {
        catch {haps_hstdm_connectivity}
        catch {haps_hstdm_connectivity_details}
    }
    if { (${TimingSignOffSllTDM} == 1) } {
        catch {reportTDMTiming {Slow} {max} 0.000 10.000}
    }
    if { (${SllOptVivadoEnable} == 1) && (${DeviceName} != "XCVU440")  } {
        update_timing
        report_timing_summary -setup -nworst 3 -max_paths 3 -file ${DesignName}_timing_summary_CTM.txt
        report_timing_summary -hold  -nworst 3 -max_paths 3 -file ${DesignName}_timing_summary_Min_CTM.txt
    }
}

proc exit_pwd { phase } {
    puts ""
    puts "\[PC_FPGA\] - ERROR : ***************************************************"
    puts "\[PC_FPGA\] - ERROR : ********* ERROR in $phase phase  ************"
    puts "\[PC_FPGA\] - ERROR : ***************************************************"
    puts "\[PC_FPGA\] - ERROR : Vivado compilation flow stopped at $phase phase"
    puts ""
    set file_name "./report_design_analysis_congestion.rpt"
    set file_name1 "./report_design_analysis_complexity.rpt"
    write_checkpoint -include_params -force dcp_KO_in_$phase\.dcp
    report_utilization
    report_design_analysis -congestion -file $file_name
    report_design_analysis -complexity -file $file_name1
    exit
} 

proc hVivado_reportMissingDPOs {} {
  global check_hstdm_missing_constraints
  global hstdm_missing_constraints_max_paths
  global hstdm_missing_constraints_nworst
  global hstdm_missing_constraints_delay
  global hstdm_missing_constraints_xdc
  global check_HSTDM_Missing_Constraints_post_PAR
  global env
  if { (${check_HSTDM_Missing_Constraints_post_PAR} == 1) } {
    puts "Checking HSTDM missing constraints post PAR implementation!"
    catch {report_hstdm_missing_constraints -xdc ${hstdm_missing_constraints_xdc} -max_paths ${hstdm_missing_constraints_max_paths} -nworst ${hstdm_missing_constraints_nworst} -delay ${hstdm_missing_constraints_delay}}
  }
}

