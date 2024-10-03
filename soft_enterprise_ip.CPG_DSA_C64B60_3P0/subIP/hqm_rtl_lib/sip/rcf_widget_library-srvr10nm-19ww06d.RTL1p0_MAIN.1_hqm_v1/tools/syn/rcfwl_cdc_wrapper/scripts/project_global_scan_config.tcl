###########################################################################################

# DFX Handler Name  :  
if {[getvar -quiet G_DFX_HANDLER_INSTANCE_NAME] ne ""} {
    if {[getvar -quiet G_DFX_DEFAULT_PARTITION] ne ""} {
       setvar G_DFX_HANDLER_INSTANCE_NAME [getvar -quiet G_DFX_DEFAULT_PARTITION]
    }
    set scan_hier [get_object_name [get_cells -hier [getvar G_DFX_HANDLER_INSTANCE_NAME]]]
} else {
    set scan_hier [get_object_name [get_cells -hier -filter "ref_name =~ [getvar G_DFX_HANDLER_DESIGN_NAME]"]]
}

#Updating Wrapper Exclude Instance List
if {[getvar -quiet G_DFX_COREWRAPPER_EXCLUDE_INSTANCE] eq "" } {
    setvar G_DFX_COREWRAPPER_EXCLUDE_INSTANCE [getvar -quiet G_DFX_NONSCAN_INSTANCES]
} else {
    foreach exclude_inst [getvar -quiet G_DFX_NONSCAN_INSTANCES] {
        lappend G_DFX_COREWRAPPER_EXCLUDE_INSTANCE $exclude_inst
    }
}       
 
#Updating Wrapper Exclude Instance List
if {[getvar -quiet G_DFX_NONSCAN_DESIGNS] != "" } {
    foreach design [getvar -quiet G_DFX_NONSCAN_DESIGNS] {
       set design_list [get_designs -quiet $design]
       if {[sizeof_collection $design_list] == 1 } {
	   set des_name [get_object_name $design_list]
	   if {[sizeof_collection [get_cells -hierarchical * -filter "ref_name =~ $des_name"]] == 1} {
               lappend G_DFX_COREWRAPPER_EXCLUDE_INSTANCE [get_object_name [get_cells -hierarchical * -filter "ref_name =~ $des_name"]]
               rdt_print_info "the exclude list now has new element [get_obj [get_cells -hierarchical * -filter "ref_name =~ $des_name"]]"
	   } elseif {[sizeof_collection [get_cells -hierarchical * -filter "ref_name =~ $des_name"]] > 1} {
               foreach_in_collection inst [get_cells -hierarchical * -filter "ref_name =~ ddrclk"] { 
                  lappend G_DFX_COREWRAPPER_EXCLUDE_INSTANCE [get_obj $inst] 
               }       
           }
       } elseif {[sizeof_collection $design_list] > 1 } {
	   foreach_in_collection subdesign $design_list {            
	      set des_name [get_object_name $subdesign]
	      if {[sizeof_collection [get_cells -hierarchical * -filter "ref_name =~ $des_name"]] > 0} {
	         foreach_in_collection new_des_name [get_cells -hierarchical * -filter "ref_name =~ $des_name"] {
		    lappend G_DFX_COREWRAPPER_EXCLUDE_INSTANCE [get_obj $new_des_name]
		    rdt_print_info "the exclude list now has new element [get_obj $new_des_name]"
		 }
              } 
	   }
       }
   }
}

# DFX Handler scan in pins
if {[sizeof_collection [get_pins -quiet $scan_hier/sss_edt?_scanchains_bgn*]] > 0 } {
    setvar G_DFX_HANDLER_SCAN_IN_PINS "sss_edt?_scanchains_bgn*"
} elseif {[sizeof_collection [get_pins -quiet $scan_hier/scanchains_si_bgn*]] > 0} {
    setvar G_DFX_HANDLER_SCAN_IN_PINS "scanchains_si_bgn*"
} elseif {[getvar -quiet G_SCAN_IN_PORTS] ne ""} {
    setvar G_DFX_HANDLER_SCAN_IN_PINS "[getvar -quiet G_SCAN_IN_PORTS]"
} elseif {[sizeof_collection [get_ports -quiet -nocase *fscan*sdi* -filter "full_name !~ *FEEDTHRU*" ]] > 0 } {
    setvar G_DFX_HANDLER_SCAN_IN_PINS "*fscan*sdi*"
} else {
    rdt_print_error "Scan in/out ports do not match standard naming methodology! Provide pattern G_SCAN_IN_PORTS and G_SCAN_OUT_PORTS variables."
}


# DFX Handler scan out pins
if {[sizeof_collection [get_pins -quiet $scan_hier/sss_edt?_scanchains_end*]] > 0 } { 
    setvar G_DFX_HANDLER_SCAN_OUT_PINS "sss_edt?_scanchains_end*"
} elseif {[sizeof_collection [get_pins -quiet $scan_hier/scanchains_so_end*]] > 0} {
    setvar G_DFX_HANDLER_SCAN_OUT_PINS "scanchains_so_end*"
} elseif {[getvar -quiet G_SCAN_OUT_PORTS] ne ""} {
    setvar G_DFX_HANDLER_SCAN_OUT_PINS "[getvar G_SCAN_OUT_PORTS]"
} elseif {[sizeof_collection [get_ports -quiet -nocase *ascan*sdo* -filter "full_name !~ *FEEDTHRU*" ]] > 0 } {
    setvar G_DFX_HANDLER_SCAN_OUT_PINS "*ascan*sdo*"
} else {
    rdt_print_error "Scan in/out ports do not match standard naming methodology! Provide pattern G_SCAN_IN_PORTS and G_SCAN_OUT_PORTS variables."
}

# DFX Handler Scan Enable pins
if {[sizeof_collection [get_pins -quiet $scan_hier/sss_clstr_fscan_shiften]] > 0} {
    setvar G_DFX_HANDLER_SCAN_ENABLE_PIN "*sss_clstr_fscan_shiften*"
} elseif {[sizeof_collection [get_pins -quiet $scan_hier/fscan_core_shiften]] > 0} {
    setvar G_DFX_HANDLER_SCAN_ENABLE_PIN "*fscan_core_shiften "
} elseif {[sizeof_collection [get_pins -quiet $scan_hier/fscan_shiften]] > 0} {
    setvar G_DFX_HANDLER_SCAN_ENABLE_PIN "*fscan_shiften "
} elseif {[sizeof_collection [get_ports -quiet -nocase *fscan_shiften*]] > 0} {
    setvar G_DFX_HANDLER_SCAN_ENABLE_PIN "*fscan_shiften* "
} elseif {[sizeof_collection [get_ports -quiet -nocase *fscanshiften*]] > 0} {
    setvar G_DFX_HANDLER_SCAN_ENABLE_PIN "*fscanshiften*"
} elseif {[get_designs -hier -quiet *lssd_scan_subsystem*] > 0} {
    setvar G_DFX_HANDLER_SCAN_ENABLE_PIN ""
} else {
    rdt_print_error "No ports matched DFx regular expression *fscan_shiften*. A signal with name 'fscan_shiften' is required for scan insertion."
}

# DFX Handler SLOS enable pins   
if {[getvar -quiet G_SLOS_FLOW] == 1} {
   if {[sizeof_collection [get_pins -quiet $scan_hier/sss_clstr_fscan_slos_en]] > 0} {
       setvar G_DFX_HANDLER_SLOS_EN "*sss_clstr_fscan_slos_en*"
   } elseif {[sizeof_collection [get_pins -quiet $scan_hier/fscan_slos_en]] > 0} {
       setvar G_DFX_HANDLER_SLOS_EN "*fscan_slos_en"
   } elseif {[sizeof_collection [get_ports -nocase -quiet *fscan_slos_en* -filter "port_direction == in"]] > 0} {
       setvar G_DFX_HANDLER_SLOS_EN [lindex [get_obj [get_ports -nocase *fscan_slos_en* -filter "port_direction == in"]] 0]
   } else {
       rdt_print_error "No ports matched DFx regular expression *fscan_slos_en*. A signal with name 'fscan_slos_en' is required for scan insertion SLOS flow."
   }  
}

# Corewrapper pins 
if {[getvar -quiet G_COREWRAPPER_FLOW] == 1} {
    if {[sizeof_collection [get_pins -quiet $scan_hier/sss_clstr_fscan_pi_seal_en]] > 0} {
        setvar G_COREWRAPPER_INPUT_DED_CAPTURE "*sss_clstr_fscan_pi_seal_en*"
    } elseif {[sizeof_collection [get_pins -quiet $scan_hier/fscan_input_wrp_capen]] > 0} {
        setvar G_COREWRAPPER_INPUT_DED_CAPTURE "*fscan_input_wrp_capen*"
    } elseif {[sizeof_collection [get_pins -quiet $scan_hier/i_ult_bscu/i_bscu/i_buf_fscan_o_level_2_in_ded_capt_en?i_ctech_lib_buf?ctech_lib_buf_dcszo*/o ]] > 0} {
        setvar G_COREWRAPPER_INPUT_DED_CAPTURE "i_ult_bscu/i_bscu/i_buf_fscan_o_level_2_in_ded_capt_en?i_ctech_lib_buf?ctech_lib_buf_dcszo*/o"
    } elseif {[sizeof_collection [get_ports -quiet -nocase *fscan_pi_seal_en* -filter "port_direction == in"]] > 0} {
        setvar G_COREWRAPPER_INPUT_DED_CAPTURE [get_obj [get_ports -nocase *fscan_pi_seal_en* -filter "port_direction == in"]]
    } else {
        rdt_print_error "No ports matched DFx regular expression *fscan_pi_seal_en. A signal with name 'fscan_pi_seal_en' is required for scan insertion corewrapper flow."
    }

    if {[sizeof_collection [get_pins -quiet $scan_hier/sss_clstr_fscan_seal_shiften]] > 0} {
        setvar G_COREWRAPPER_IN_SHIFTEN "*sss_clstr_fscan_seal_shiften*"
    } elseif {[sizeof_collection [get_pins -quiet $scan_hier/fscan_input_wrp_shiften]] > 0} {
        setvar G_COREWRAPPER_IN_SHIFTEN "*fscan_input_wrp_shiften*"
    } elseif {[sizeof_collection [get_pins -quiet $scan_hier/i_ult_bscu/i_bscu/i_buf_fscan_o_level_2_in_shift_en?i_ctech_lib_buf?ctech_lib_buf_dcszo*/o ]] > 0} {
        setvar G_COREWRAPPER_IN_SHIFTEN "i_ult_bscu/i_bscu/i_buf_fscan_o_level_2_in_shift_en?i_ctech_lib_buf?ctech_lib_buf_dcszo*/o"
    } elseif {[sizeof_collection [get_ports -quiet -nocase *fscan_seal_shiften* -filter "port_direction == in"]] > 0} {
        setvar G_COREWRAPPER_IN_SHIFTEN [get_obj [get_ports -nocase *fscan_seal_shiften* -filter "port_direction == in"]]
    } else {
        rdt_print_error "No ports matched DFx regular expression *fscan_seal_shiften*. A signal with name 'fscan_seal_shiften' is required for scan insertion corewrapper flow"
    }
}

if {[getvar -quiet G_COREWRAPPER_FLOW] == 1} {
   if {[getvar -quiet G_COREWRAPPER_OUTPUTS] == 1} {
       if {[sizeof_collection [get_pins -quiet $scan_hier/sss_clstr_fscan_pi_seal_en]] > 0} {
           setvar G_COREWRAPPER_OUTPUT_DED_CAPTURE "*sss_clstr_fscan_pi_seal_en*"
       } elseif {[sizeof_collection [get_pins -quiet $scan_hier/fscan_output_wrp_capen]] > 0} {
           setvar G_COREWRAPPER_OUTPUT_DED_CAPTURE "*fscan_output_wrp_capen*"
       } elseif {[sizeof_collection [get_pins -quiet $scan_hier/i_ult_bscu/i_bscu/i_buf_fscan_o_level_2_out_ded_capt_en?i_ctech_lib_buf?ctech_lib_buf_dcszo*/o ]] > 0} {
           setvar G_COREWRAPPER_OUTPUT_DED_CAPTURE "i_ult_bscu/i_bscu/i_buf_fscan_o_level_2_out_ded_capt_en?i_ctech_lib_buf?ctech_lib_buf_dcszo*/o"
       } elseif {[sizeof_collection [get_ports -nocase -quiet *fscan_pi_seal_en* -filter "port_direction == in"]] > 0} {
           setvar G_COREWRAPPER_OUTPUT_DED_CAPTURE [get_obj [get_ports -nocase *fscan_pi_seal_en* -filter "port_direction == in"]]
       } else {
           rdt_print_error "No ports matched DFx regular expression *fscan_pi_seal_en. A signal with name 'fscan_pi_seal_en' is required for scan insertion output corewrapper flow."
       }

       if {[sizeof_collection [get_pins -quiet $scan_hier/sss_clstr_fscan_seal_shiften]] > 0} {
           setvar G_COREWRAPPER_OUT_SHIFTEN "*sss_clstr_fscan_seal_shiften*"
       } elseif {[sizeof_collection [get_pins -quiet $scan_hier/fscan_output_wrp_shiften]] > 0} {
           setvar G_COREWRAPPER_OUT_SHIFTEN "*fscan_output_wrp_shiften*"
       } elseif {[sizeof_collection [get_pins -quiet $scan_hier/i_ult_bscu/i_bscu/i_buf_fscan_o_level_2_out_shift_en?i_ctech_lib_buf?ctech_lib_buf_dcszo*/o ]] > 0} {
           setvar G_COREWRAPPER_OUT_SHIFTEN "i_ult_bscu/i_bscu/i_buf_fscan_o_level_2_out_shift_en?i_ctech_lib_buf?ctech_lib_buf_dcszo*/o"
       } elseif {[sizeof_collection [get_ports -nocase -quiet *fscan_seal_shiften* -filter "port_direction == in"]] > 0} {
           setvar G_COREWRAPPER_OUT_SHIFTEN [get_obj [get_ports -nocase *fscan_seal_shiften* -filter "port_direction == in"]]
       } else {
           rdt_print_error "No ports matched DFx regular expression *fscan_seal_shiften*. A signal with name 'fscan_seal_shiften' is required for scan insertion output corewrapper flow"
       }
   }
}

set_dft_drc_configuration  -internal_pins enable


if {[getvar -quiet G_SCAN_LATCHES] == 1} {
    ####### Keep an eye out for these, if fscan_clkungate is not driving these then they'll still end up in the scan chain #########
    ####### Set LCB output signals to Constant 1 #########
    echo "Attempting to apply DFx constraints on pins/ports matching expression *CkLcbXPN*"
    if {[sizeof_collection [get_pins -quiet -of_objects [get_cells -hier *LatLcbEn*] -filter "pin_direction==out"]] > 0} {
        foreach_in_collection pin [get_pins -of_objects [get_cells -hier *LatLcbEn*] -filter "pin_direction==out"] {
            set pinname [get_object_name $pin]
            echo "Setting DFx constant of 1 on pin $pinname"
            #set_dft_signal -view existing_dft -hookup_pin [get_pins $pinname ] -type constant -active_state 1 
            set_test_assume 1 [get_pins $pinname ]
        }
    }
}

###enhancement
if {[getvar -quiet G_DFX_TERMINAL_LOCKUP] eq 1 } {
    set_scan_configuration -insert_terminal_lockup true -add_test_retiming_flops begin_and_end
}

if {[getvar -quiet G_PIPELINE_SCAN_DATA] ne "" } {
    if {[getvar -quiet G_PIPELINE_SCAN_DATA] eq 1} {
        set_dft_configuration -scan enable -pipeline_scan_data enable
    } else {
        set_dft_configuration -scan enable
    }
} else {
    set_dft_configuration -scan enable
}

##
if {[sizeof_collection [get_designs -quiet -hier *scan_subsystem*]] > 0 } {
    if {[getvar -quiet G_IGNORE_DFX_HANDLER_VAR_FOR_DRC] eq "" } {
        setvar G_IGNORE_DFX_HANDLER_VAR_FOR_DRC 0
        setvar G_IGNORE_DFX_HANDLER_VAR 0
    }
    setvar G_DFX_DEFINE_SCAN_PATH 0
    setvar G_DFX_ADDITIONAL_TEST_MODE_PIN "*fscan_clkungate"

} elseif {[sizeof_collection [get_designs -quiet -hier *ult_scan_ctlr*]] > 0 } {
    if {[getvar -quiet G_IGNORE_DFX_HANDLER_VAR_FOR_DRC] eq "" } {
        setvar G_IGNORE_DFX_HANDLER_VAR_FOR_DRC 0
        setvar G_IGNORE_DFX_HANDLER_VAR 0
    }
    setvar G_DFX_DEFINE_SCAN_PATH 0
    setvar G_DFX_ADDITIONAL_TEST_MODE_PIN "*fscan_clkungate"
} else {
    if {[getvar -quiet G_IGNORE_DFX_HANDLER_VAR_FOR_DRC] eq "" } {
        setvar G_IGNORE_DFX_HANDLER_VAR_FOR_DRC 1
        setvar G_IGNORE_DFX_HANDLER_VAR 1
    }
    #setvar G_DFX_DEFINE_SCAN_PATH 1
    #setvar G_DFX_ADDITIONAL_TEST_MODE_PIN "*fscan_clkungate*"
}

# DFX Handler Additional testmode pins
if {[sizeof_collection [get_pins -quiet $scan_hier/sss_clstr_fscan_clkungate]] > 0} {
    setvar G_DFX_ADDITIONAL_TEST_MODE_PIN "*sss_clstr_fscan_clkungate "
} elseif {[sizeof_collection [get_pins -quiet $scan_hier/fscan_clkungate]] > 0} {
    setvar G_DFX_ADDITIONAL_TEST_MODE_PIN "*fscan_clkungate"
} elseif {[sizeof_collection [get_ports -nocase -quiet *fscan_clkungate* -filter "full_name !~ *fscan_clkungate_syn* && port_direction == in"]] > 0} {
    setvar G_DFX_ADDITIONAL_TEST_MODE_PIN [get_object_name [get_ports -nocase *fscan_clkungate* -filter "full_name !~ *fscan_clkungate_syn* && port_direction == in"]] 
} elseif {[sizeof_collection [get_ports -nocase -quiet *fscanclkungate*]] > 0} {
    setvar G_DFX_ADDITIONAL_TEST_MODE_PIN "*fscanclkungate* "
} else {
    rdt_print_error "No ports matched DFx regular expression *fscan_clkungate*. A signal with name 'fscan_clkungate' is required for scan insertion."
}

# DFX Handler testmode pins
if {[sizeof_collection [get_pins -quiet $scan_hier/sss_clstr_fscan_clkungate_syn]] > 0} {
    setvar G_DFX_HANDLER_TEST_MODE_PIN "*sss_clstr_fscan_clkungate_syn "
} elseif {[sizeof_collection [get_pins -quiet $scan_hier/fscan_clkungate_syn]] > 0} {
    setvar G_DFX_HANDLER_TEST_MODE_PIN "*fscan_clkungate_syn"
} elseif {[sizeof_collection [get_ports -nocase -quiet *fscan_clkungate_syn*]] > 0} {
    setvar G_DFX_HANDLER_TEST_MODE_PIN "*fscan_clkungate_syn* "
} elseif {[sizeof_collection [get_ports -nocase -quiet *fscanclkungate*syn*]] > 0} {
    setvar G_DFX_HANDLER_TEST_MODE_PIN "*fscanclkungate*syn* "
} elseif {[getvar -quiet G_SKIP_CHECKS_ON_SIP] ne 1} {
    rdt_print_error "No ports matched DFx regular expression *fscan_clkungate_syn*. A signal with name 'fscan_clkungate_syn' is required for scan insertion."
}

if {[getvar -quiet G_DFT_CREATE_DFX_PINS_PER_PD] == 1} {
    setvar G_DFX_HANDLER_TEST_MODE_PIN "*fscan_clkungate_syn* "
}

## merge latches and flops into one chain
if {[getvar -quiet G_SCAN_LATCHES] ne 1 || [getvar -quiet G_MERGE_LATCHES_AND_FLOPS] eq 1} {
    if {[getvar -quiet G_MERGE_LATCHES_AND_FLOPS] eq 1} {
        setvar G_SCAN_LATCHES 0
    }
}

#This will send an informative email to DFT with a pointer to the current directory
set whoami [exec whoami]
set fdate [exec date]
set loc_pwd [exec pwd]
set mail_list "jonathan.hill@intel.com michelle.v.vallabhanath@intel.com nikita.muttreja@intel.com timothy.yuan@intel.com"
exec echo "A run through the HDK Scan Insertion has started at $loc_pwd by $whoami on $fdate" | mail $mail_list -s "HDK Scan Insertion Run at $loc_pwd by $whoami on $fdate"

# Settings for LV_TM and LV_WRSTN on bist tap hierarchy
set all_bist_designs ""
set bist_design ""
if {[sizeof_collection [get_designs -quiet -hier *sdg_dfx_bist_tap*]] > 0 } {
    set all_bist_designs [get_designs -hier *sdg_dfx_bist_tap*]
}

foreach_in_collection bist_design $all_bist_designs {
    set bist_hier ""
    if {$bist_design ne ""} {
        if {[sizeof_collection [get_cells -quiet -hier -filter ref_name==[get_object_name $bist_design]]] > 0 } {
            set bist_hier [get_object_name [get_cells -hier -filter ref_name==[get_object_name $bist_design]]]
        }
    }
    #DFT:LV_TM
    if {[sizeof_collection [get_pins -quiet $bist_hier/*LV_TM*]] > 0} {
        lappend G_DFX_HANDLER_CONSTANT_HIGH_PINS " [get_object_name [get_pins $bist_hier/*LV_TM*]]"
    }
    #DFT:LV_WRSTN
    if {[sizeof_collection [get_pins -quiet $bist_hier/*LV_WRSTN*]] > 0} {
        lappend G_DFX_HANDLER_CONSTANT_HIGH_PINS " [get_object_name [get_pins $bist_hier/*LV_WRSTN*]] "
    }
}

# Turn off SLOS and Corewrapping when we're in LSSD
if {[get_designs -hier -quiet *lssd_scan_subsystem*] > 0} {
    setvar G_SLOS_FLOW 0
    setvar G_COREWRAPPER_FLOW 0
}

# If CMS BAM is included, add the following to prevent these violations
# Test model for core cms has internal pins and cannot be used for hierarchical integration. (TESTXG-68)
set bam_list [::file::identify_bams_in_design]
if {$bam_list ne "" && [getvar -quiet G_DESIGN_NAME] != "llcsfp"} {
    rdt_print_info "Setting test_allow_internal_pins_in_hierarchical_flow to true due to usage of BAMs.  Adding BAMs to non-scan instances list"
    rdt_print_info "BAMs getting set to non-scan: $bam_list"
    set test_allow_internal_pins_in_hierarchical_flow true
    foreach bam $bam_list {
       lappend G_DFX_NONSCAN_INSTANCES $bam
    }
} else {
    rdt_print_info "no BAMs used, or we're in LLCSFP"

}


### dft netlist checker ######
setvar G_RULE_WAIVERS(7) "i_ult_atpgproxy.*genpxy.*sp.*i_ctech_clk_gate_and_te_pclk"
setvar G_DFX_CONSIDER_RETIME_LATCH 1
setvar G_DFT_CDU_BLOCKS "[get_object_name [get_cells -hierarchical -filter "ref_name =~ [getvar G_DFX_HANDLER_DESIGN_NAME]"]]*"
setvar G_RULE_WAIVERS(5) "edt_decompressor_i/edt_scan_in\\\\[0] \
                          edt_decompressor_i/edt_scan_in\\\\[1]" 

setvar G_RULE_WAIVERS(6) "edt_compactor_i/edt_scan_out\\\\[0] \
                          edt_compactor_i/edt_scan_out\\\\[1]" 
setvar G_RULE_WAIVERS(9) "i_ult_clkctl.*ctech_lib_msff_async_rstb_scan_dcszo \
                          i_ult_parctl.*ctech_lib_msff_async_rstb_scan_dcszo \
                          i_ult_atpgproxy.*ctech_lib_msff_async_rstb_scan_dcszo "

setvar G_RULE_WAIVERS(10) "i_ult_clkctl.*ctech_lib_msff_async_rstb_scan_dcszo \
                           i_ult_parctl.*ctech_lib_msff_async_rstb_scan_dcszo \
                           i_ult_atpgproxy.*ctech_lib_msff_async_rstb_scan_dcszo "

### Set clock pin names to leaf cells if physical DOPs exist
set dop_inst ""
set dop_in_bam 0
foreach dop [getvar -quiet G_DOP_REF_NAME] { 
   if {[sizeof [get_cells -quiet -hier * -filter "ref_name =~ $dop"]] > 0} {
       if {[llength $bam_list] > 0} {
	   foreach_in_collection dop_cell [get_cells -hier * -filter "full_name !~ *nonscan* && full_name !~ *noscan* && full_name !~ *no_scan* && ref_name =~ $dop"] {
	       set hname [get_hier_name $dop_cell]
	       set dop_in_bam 0
               set cell_name [get_object_name $dop_cell]
	       foreach bam $bam_list {
		   if {[regexp $bam $cell_name] > 0} {
		       set dop_in_bam 1
		       #echo $dop_in_bam
                        rdt_print_warn "Dop $dop_in_bam exists in BAM!"
		   }
	       }
               if { [ sizeof_collection [ filter [ all_fanin -to $cell_name/scanclk -startpoints_only -only_cells -flat ] {@ref_name == "**logic_0**"} ] ] == 1  } {
                    set dop_in_bam 1
                    rdt_print_warn "DOP $cell_name has scanclk pin tied to GND!"
               }
	       if {$dop_in_bam < 1} {
		   lappend dop_inst $dop_cell		   
	       }
	   }
       } else {
           foreach_in_collection dop_cell [get_cells -hier * -filter "full_name !~ *nonscan* && full_name !~ *noscan* && full_name !~ *no_scan* && ref_name =~ $dop"] {
                set cell_name [get_object_name $dop_cell]
                if { [ sizeof_collection [ filter [ all_fanin -to $cell_name/scanclk -startpoints_only -only_cells -flat ] {@ref_name == "**logic_0**"} ] ] == 1 } {
                    rdt_print_warn "DOP $cell_name has scanclk pin tied to GND!"
                } else {
                    lappend dop_inst $dop_cell
                }                 
           }
      } 
   }
}


if {$dop_inst ne "" } {
   setvar G_DFT_CCDU_PATTERN ""
   setvar G_COREWRAPPER_CLOCK ""

   foreach_in_collection dp $dop_inst {
      lappend G_DFT_CCDU_PATTERN [get_obj $dp]
      lappend G_COREWRAPPER_CLOCK [get_obj [get_pins [get_obj $dp]/clkout]]
  }
  setvar G_DFT_CCDU_PIN_PATTERN "clkout"

} else {
  setvar G_DFT_CCDU_PATTERN "*ccdu*"
  setvar G_DFT_CCDU_PIN_PATTERN "*adop_postclk*"
  setvar G_COREWRAPPER_CLOCK "*/*adop_postclk*"
}

# Trial for parmmchas for dft_coverage crash due to */i_stf_scan_clstr_agent/no_cda.i_sss_stf_nocda/syn_1/o getting optimized out
if {[sizeof_collection [get_pins -quiet $scan_hier/*postclk -filter "pin_direction == out" ]] > 0 } {
    if {[all_fanout -from [get_pins -quiet $scan_hier/*postclk] -endpoints_only -flat] > 0} {
        setvar G_DFX_HANDLER_CLOCK2FLOP_PINS      "*fscan*scanclk* \
                                           dfh_ip_fscan_func_clk* \
                                           scan_clk_dclk \
                                           scan_clk_dclk_div_4 \
                                           *postclk* "
        set func_cda_pins [get_pins -quiet [all_fanout -from [get_pins $scan_hier/*postclk*] -flat -trace_arcs all] -filter full_name=~*ctech_lib_sdg_programmable_delay_clk_buf*/clkout]
        if {[sizeof_collection $func_cda_pins] > 0} {
            append_var G_DFX_HANDLER_CLOCK2FLOP_PINS " [get_object_name $func_cda_pins]"
            setvar G_COREWRAPPER_CLOCK [get_object_name $func_cda_pins]
        } else {
            append_var G_DFX_HANDLER_CLOCK2FLOP_PINS " *postclk*"
            setvar G_COREWRAPPER_CLOCK "*postclk*"
        }
    } else {
        setvar G_DFX_HANDLER_CLOCK2FLOP_PINS      "*fscan*scanclk* \
                                           dfh_ip_fscan_func_clk* \
                                           scan_clk_dclk \
                                           scan_clk_dclk_div_4 "
    }
} else {

    setvar G_DFX_HANDLER_CLOCK2FLOP_PINS "*fscan*scanclk* \
                                          dfh_ip_fscan_func_clk* \
                                          scan_clk_dclk \
                                          scan_clk_dclk_div_4 "
}

###make G_SCAN_CLOCKS compatible with G_DFX_HANDLER_CLOCK2FLOP_PINS###
foreach clk [getvar -quiet G_SCAN_CLOCKS] {
   append_var G_DFX_HANDLER_CLOCK2FLOP_PINS $clk
}


### Exclude the repeater flops for the clken, divsync, scan_apply, and clk_halt coming in and going out of the SSS
if {[sizeof_collection [get_pins -quiet $scan_hier/*fpm_clk_en*]] > 0} {
    if {[sizeof_collection [filter_collection [all_fanin -startpoints_only -flat -only_cells -to [lindex [get_object_name [get_pins -quiet $scan_hier/*fpm_clk_en*]] 0]] "is_sequential == true"]] > 0} {
        foreach_in_collection cell [filter_collection [all_fanin -startpoints_only -flat -only_cells -to [lindex [get_object_name [get_pins -quiet $scan_hier/*fpm_clk_en*]] 0]] "is_sequential == true"] {
            set rpt_flops [regsub -all {[0-9]} [get_object_name $cell] "*"] 
            lappend G_DFX_NONSCAN_INSTANCES $rpt_flops
        }
    }
}


if {[sizeof_collection [get_pins -quiet $scan_hier/*adop_preclk_div_sync*]] > 0} {
    if {[sizeof_collection [filter_collection [all_fanout -endpoints_only -flat -only_cells -from [lindex [get_object_name [get_pins -quiet $scan_hier/*adop_preclk_div_sync*]] 0]] "is_sequential == true"]] > 0} {
        foreach_in_collection cell [filter_collection [all_fanout -endpoints_only -flat -only_cells -from [lindex [get_object_name [get_pins -quiet $scan_hier/*adop_preclk_div_sync*]] 0]] "is_sequential == true"] {
            set rpt_flops [regsub -all {[0-9]} [get_object_name $cell] "*"] 
            lappend G_DFX_NONSCAN_INSTANCES $rpt_flops
        }
    }
}


if {[sizeof_collection [get_pins -quiet $scan_hier/*ascan_dop_clken*]] > 0} {
    if {[sizeof_collection [filter_collection [all_fanout -endpoints_only -flat -only_cells -from [lindex [get_object_name [get_pins -quiet $scan_hier/*ascan_dop_clken*]] 0]] "is_sequential == true"]] > 0} {
        foreach_in_collection cell [filter_collection [all_fanout -endpoints_only -flat -only_cells -from [lindex [get_object_name [get_pins -quiet $scan_hier/*ascan_dop_clken*]] 0]] "is_sequential == true"] {
            set rpt_flops [regsub -all {[0-9]} [get_object_name $cell] "*"] 
            lappend G_DFX_NONSCAN_INSTANCES $rpt_flops
        }
    }
}

if {[sizeof_collection [get_pins -quiet $scan_hier/*fpm_preclk_div_sync*]] > 0} {
    if {[sizeof_collection [filter_collection [all_fanin -startpoints_only -flat -only_cells -to [lindex [get_object_name [get_pins -quiet $scan_hier/*fpm_preclk_div_sync*]] 0]] "is_sequential == true"]] > 0} {
        foreach_in_collection cell [filter_collection [all_fanin -startpoints_only -flat -only_cells -to [lindex [get_object_name [get_pins -quiet $scan_hier/*fpm_preclk_div_sync*]] 0]] "is_sequential == true"] {
            set rpt_flops [regsub -all {[0-9]} [get_object_name $cell] "*"]
            lappend G_DFX_NONSCAN_INSTANCES $rpt_flops
        } 
    }
}

#### Excluding scan_apply repeaters going into the SSS (Jonathan Hill, 10/23/17)
if {[sizeof_collection [get_pins -quiet $scan_hier/*scan_apply*]] >0} {
    if {[sizeof_collection [filter_collection [all_fanin -startpoints_only -flat -only_cells -to [lindex [get_object_name [get_pins -quiet $scan_hier/*scan_apply*]] 0]] "is_sequential == true"]] > 0} {
        foreach_in_collection cell [filter_collection [all_fanin -startpoints_only -flat -only_cells -to [lindex [get_object_name [get_pins -quiet $scan_hier/*scan_apply*]] 0]] "is_sequential == true"] {
            set rpt_flops [regsub -all {[0-9]} [get_object_name $cell] "*"]
            lappend G_DFX_NONSCAN_INSTANCES $rpt_flops
        }
    }
}

#### Excluding clk_halt repeaters going into the SSS (Jonathan Hill, 10/23/17)
if {[sizeof_collection [get_pins -quiet $scan_hier/*clk_halt*]] > 0} {
    if {[sizeof_collection [filter_collection [all_fanin -startpoints_only -flat -only_cells -to [lindex [get_object_name [get_pins -quiet $scan_hier/*clk_halt*]] 0]] "is_sequential == true"]] > 0} {
        foreach_in_collection cell [filter_collection [all_fanin -startpoints_only -flat -only_cells -to [lindex [get_object_name [get_pins -quiet $scan_hier/*clk_halt*]] 0]] "is_sequential == true"] {
            set rpt_flops [regsub -all {[0-9]} [get_object_name $cell] "*"]
            lappend G_DFX_NONSCAN_INSTANCES $rpt_flops
        }
    }
}

