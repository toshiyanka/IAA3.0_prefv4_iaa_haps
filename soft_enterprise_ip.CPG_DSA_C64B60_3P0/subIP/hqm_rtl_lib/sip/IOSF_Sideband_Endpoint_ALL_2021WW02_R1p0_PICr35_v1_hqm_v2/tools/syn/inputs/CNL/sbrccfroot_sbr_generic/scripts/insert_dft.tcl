################################################################################
# Intel Confidential
################################################################################
# Copyright (C) 2014, Intel Corporation.  All rights reserved.
#
# This is the property of Intel Corporation and may only be utilized
# pursuant to a written Restricted Use Nondisclosure Agreement
# with Intel Corporation.  It may not be used, reproduced, or
# disclosed to others except in accordance with the terms and
# conditions of such agreement.
################################################################################
# Description
# This procedures are used to enable scan-chain insertion in DC.
# The flow is based on the VLV/TNG DFT architecture and naming convention
#
# This flow relies on the sets of G_DFX_* variables to enable scan configuration
# generation. It is important that the settings for these G_DFX_* variables are
# correct. 
#
# Flow uses G_DFX_NONSCAN_<DESIGNS|INSTANCES> to determine which units to be 
# considered as scan vs. nonscan domains. Nonscan domains are those containing 
# flops which are not considered for scan-stitching. Examples of nonscan domains
# are clock or reset units. 
#    NOTE: It is important to set these G_DFX_NONSCAN_* variables prior to compile
#          stage. This is where DC will swap regular flops to scan-flops.
#          By setting these variables, DC will not swap flops in
#          nonscan domains to save area.
#
# This flow supports design/partition with single or multiple dfx controller/handlers
#
#
# In multiple dfx controllers where each dfx-controller is responsible for driving
# scan-chains within its own sub-domain (sub-domain can be defined as units or within
# power domain). DFTC must be configured to use dft_partition flow.  In other words,
# each subdomain must be configured together with its own dfx-controller. In addition,
# ICG's te hookup will not be done automatically. Flow uses set_dft_connect command
# to explicitly tell DFTC on which icg to hook up to specified TestMode signal.   
#
#    NOTE: In dft_partition flow, all units must be explicitly assigned to either scan
#          or non-scan domains. 
#
# In single dfx controller, flow will perform icg hookup and scan-stitching automatically.
#
#
# Limitation in handling multiple power domains
# ---------------------------------------------
# In multiple power domains design, each power domain is required to have its own
# dfx controller/handler.
#
# There are some cases where one dfx controller drives multiple domains. This flow
# can not handle this scenario and user is required to come up with custom scan
# configuration file
# 
# Owners: Vrpradeep Bharadwaj, Taimei DeZeeuw

#################################################################################
# DFT Compiler Optimization Section
#################################################################################
# It is recommended that top-level test ports be defined as a part of the
# RTL design and included in the netlist for floorplanning.


proc syn_insert_dft {args} {
   global env
   global search_path
   global power_cg_auto_identify

   # Skip scan-insertion when G_INSERT_SCAN = 0
   if { [getvar -quiet G_INSERT_SCAN] == 0 } {
       rdt_print_info "Skipping insert_dft stage as  G_INSERT_SCAN is set to 0"
       return TCL_OK

   }

   if {[info exists env(WARD)] && $env(WARD) ne "" && [lsearch -exact $search_path $env(WARD)/collateral/dft] == "-1"} {
       rdt_print_info "Adding $env(WARD)/collateral/dft to search_path"
       lappend search_path $env(WARD)/collateral/dft
       lappend_var G_SCRIPTS_SEARCH_PATH $env(WARD)/collateral/dft
   }

   # Scan related collateral files
   set scan_coll_file_list [list override_setup scan_waivers]
   foreach sfile $scan_coll_file_list {
      set filename [getvar G_DESIGN_NAME]_${sfile}.tcl
      rdt_print_info "Sourcing scan collateral file: $filename"
      rdt_source_if_exists $filename
   }

   # Pseudo Clocks for glitchfree Mux Outputs
   set gMuxes [get_cells -quiet -hierarchical *glitchfree_mux*]
   if { [sizeof_collection $gMuxes] > 0 } {
      rdt_print_info "Defining pseudo clocks for DFT-C at the glitchfree mux outputs"
      foreach_in_collection m $gMuxes {
         set muxout [get_pins [get_attribute [get_pins [get_attribute $m full_name]/clk_out] full_name]]
         if { [sizeof_collection $muxout] > 0 } {
            rdt_print_info "set_dft_signal -view existing -type ScanClock -timing \[list 45 55\] -hookup_pin [get_object_name $muxout]"
            set_dft_signal -view existing -type ScanClock -timing [list 45 55] -hookup_pin $muxout
         }
      }
   }


   syn_dft_pre_setup

   syn_dft_hookup_icg_test_mode

   syn_dft_config_generation


   #################################################################################################
   # Remove dont_touch on lower units so insert-DFT can modify (i.e. scan-stitch) inside unit level.
   rdt_print_info "Removing dont-touch attribute from all units to enable scan-chain inserting within units"

   set dont_touch_design_list [get_designs * -filter "@dont_touch == true"]
   set dont_touch_instance_list [get_cells -hier * -filter "@dont_touch == true"]

   if { [sizeof_collection $dont_touch_design_list] > 0 } {
      remove_attribute -quiet $dont_touch_design_list dont_touch
   }
   if { [sizeof_collection $dont_touch_instance_list] > 0 } {
      remove_attribute -quiet $dont_touch_instance_list dont_touch
   }
   

   ########################################################################################
   # Reading scan configuration file setting

   set config_file [rdt_source_if_exists -display [getvar {G_DESIGN_NAME}]_scan_config.tcl]
   if { [file exists $config_file] } {
       rdt_print_info "Sourcing user's existing scan configuration file '$config_file'"
       source $config_file

   } elseif { [file exists ".[getvar {G_DESIGN_NAME}]_scan_config.tcl"] } {
       rdt_print_info "Sourcing auto-generated scan configuration file '.[getvar {G_DESIGN_NAME}]_scan_config.tcl'"
       source .[getvar {G_DESIGN_NAME}]_scan_config.tcl

       # copy snaphot of the auto-generated scan config to report area for review
       file copy -force .[getvar {G_DESIGN_NAME}]_scan_config.tcl ./reports/[getvar {G_DESIGN_NAME}].insert_dft.scan_config.rpt

   }

   set_app_var power_cg_auto_identify true
   syn_dft_exclude_hookup_icg_in_nonscan_domains

   # Apply Scan Spec 
   create_test_protocol
   
   
   rdt_print_info "Generating scan related reports prior running scan-insertion"
   #syn_reports pre_dft 
   # vbharadw: pre_dft is not a seperate stage. Renaming the reports to make it noble flow compliant: HSD#5515904
   syn_dft_generate_pre_dft_reports insert_dft 
   syn_outputs pre_dft 
   set_scan_element false [filter [all_registers] {testdb_test_cell_violated == true} ]
   if { [sizeof_collection [get_cells * -hierarchical -filter "scan_element == false"]] > 0 } {
      set_scan_configuration -exclude_elements [get_cells * -hierarchical -filter "scan_element == false"]
}

   if { [getvar -quiet G_STOP_AFTER_PRE_DFT_FOR_DEBUG] == 1 } {
      print_fatal "Returning to tool prompt for DFT_DRC debug as G_STOP_AFTER_PRE_DFT_FOR_DEBUG is set to 1"
    } 
   
   rdt_print_info "Starting scan-chain insertion through insert_dft....."
   insert_dft
   

   rdt_print_info "Setting back 'dont_touch' attribute to designs which already have 'dont_touch' attribute prior to insert_dft stage"
   if { [sizeof_collection $dont_touch_design_list] != 0 } {
      set_attribute [join $dont_touch_design_list] dont_touch true
   }
   if { [sizeof_collection $dont_touch_instance_list] != 0 } {
      set_attribute [join $dont_touch_instance_list] dont_touch true
   }
   
   # setting ideal network on scan-related signals to prevent buffer insertion 
   syn_dft_disable_scan_drc
   

   if { [getvar -quiet G_DFX_FIX_ICG_HOOKUP] == 1 } {
      rdt_print_info "Fixing icg/te hooking up to port 'test_cgtm'"
      syn_dft_fix_icg_hookup
      
   }

   #Fix isolation startegy post scan stitching
   fix_iso_strategy_for_scan

}


####################################################################################################
# This prodecure is to setup commmon DFX constraints prior to running actual scan insertion
#   re-setup clock-gating attribute and loading in ctl model for all synch. cells
#   enable/disable constant flops from being used for scan-stitching
# return a list of design/instances with dont_touch attribute
####################################################################################################
proc syn_dft_pre_setup { args } {


   if { [getvar -quiet G_INSERT_SCAN] == 0 } {
       return TCL_OK
   }

   rdt_print_info "Explicitly attaching all ctl model for sync cells to allow sync cells on scan-chains"
   syn_read_ctl_model


   # Redefine clockgating attribute. Needed when performing scan-insertion on loaded DDC
   rdt_print_info "Explicitly running syn_clock_gating to apply clock-gating attribute when loading in ddc."
   rdt_print_info "This is because ddc does not store clock-gating attribute"
   syn_clock_gating


   ####################################
   # Remove temp file
   file delete -force .[getvar {G_DESIGN_NAME}]_scan_config.tcl


   #################################################################################################
   # enable constant flops to be part of the scan-chains to improve coverage
   if { [getvar G_DFX_ALLOW_CONSTANT_FLOPS_ON_CHAIN] == 1 } {
      rdt_print_info "Enable constant flops to be part of scan-chains."
      #vbharadw: Maintain backward compatibility with older versions (clean up soon)
      if { [get_app_var sh_product_version] < "H-2013.03-SP2" } {
          set_dft_drc_rules -warning {TEST-504} 
          set_dft_drc_rules -warning {TEST-505} 
      } else {
          set_dft_drc_rules -allow {TEST-504}
          set_dft_drc_rules -allow {TEST-505}
      } 

   }
   
   if {[getvar -quiet G_VECTOR_FLOP] == "1"} {
      rdt_print_info "Enable scan-insertion on vector flops"
      set_scan_configuration -preserve_multibit_segment false
   }
   

   return TCL_OK

}

############################################################################################################
# This proc setup the proper connection of ICG'te pin to their respective dfx_handler's testmode signal
# using set_dft_connect. The actual icg hookup will be done during scan-stitching when executing insert_dft 
# This proc is executed only when design is using dft_partition mode to handle multiple dfx-handlers.
############################################################################################################
proc syn_dft_hookup_icg_test_mode { args } {


   global product_version

   set icg_in_nonscan_designs "" 

   if { [getvar -quiet G_INSERT_SCAN] == 0 } {
      return TCL_OK

   }

   # Case of single dfx_handler per partition
   if { [llength [getvar -quiet -names G_DFX_HANDLER_MAP]] < 2 } {
       return TCL_OK

   }


   rdt_print_info "Setting up to hookup ICG's te pins to its respective TestMode signal."

   # Setting to enable internal pins mode so that  clock, scan-enable can be specified on internal pins
   set cmd "set_dft_drc_configuration -clock_gating_init_cycles 4 -internal_pins enable"
   rdt_print_info "$cmd"
   eval $cmd

   set cmd "set_dft_insertion_configuration -preserve_design_name true -unscan true"
   rdt_print_info "$cmd"
   eval $cmd

   if { [regexp {^no_mix$|^mix_edges$|^mix_clocks$|^mix_clocks_not_edges$} [getvar G_SCAN_MIX_CLOCKS]] } {
      set cmd "set_scan_configuration -clock_mixing [getvar G_SCAN_MIX_CLOCKS]"
      rdt_print_info "$cmd"
      eval $cmd
   } else {
      if { [getvar G_SCAN_MIX_CLOCKS] eq 1 } {
          set cmd "set_scan_configuration -clock_mixing mix_clocks"
          rdt_print_info "$cmd"
          eval $cmd
      } else {
          rdt_print_warn "G_SCAN_MIX_CLOCKS: [getvar G_SCAN_MIX_CLOCKS] is not a valid option. Allowed options are no_mix|mix_edges|mix_clocks|mix_clocks_not_edges"
          rdt_print_info "Using default: no_mix"
          set cmd "set_scan_configuration -clock_mixing no_mix"
          rdt_print_info "$cmd"
          eval $cmd
      }
   } 

   set cmd "set_scan_configuration -insert_terminal_lockup true -add_lockup true"
   rdt_print_info "$cmd"
   eval $cmd

   # Categorize ICG's in scan and non-scan domains
   set all_icg [get_cells -hier -filter "is_icg == true && clock_gating_integrated_cell =~ latch*"]
   set icg_in_nonscan_designs [syn_dft_get_icgs_in_nonscan_domains]
   set icg_in_scan_designs [remove_from_collection $all_icg $icg_in_nonscan_designs]



   # Collect and categorize all icg's associated with specific dfx_handler
   foreach dfx_inst [getvar -names G_DFX_HANDLER_MAP] {

      set icg_map($dfx_inst) ""
      set icg_coll ""

      foreach inst [getvar G_DFX_HANDLER_MAP($dfx_inst)] {
         append_to_collection icg_coll [filter_collection $icg_in_scan_designs "@full_name =~ ${inst}/*"]
      }

      # only consider icg with default connection to constant (te = 1'b0)
      foreach_in_collection icg_cell $icg_coll {
         set te_pin  [get_pins -of_objects $icg_cell -filter "pin_name =~ te"]
         set ep [remove_from_collection [all_fanin -to [get_pins $te_pin] -flat -level 1] [get_pins $te_pin]]
         if { [sizeof_collection $ep] == 1 && [regexp {\*\*logic_0*} [get_object_name $ep]] } {
            lappend icg_map($dfx_inst) [file dirname [get_object_name $icg_cell]]
         }

      }
      
      # Collect TestMode signal associated with specific dfx_handler
      set dfx_test_mode_map($dfx_inst) [syn_dft_get_pin $dfx_inst [getvar G_DFX_HANDLER_TEST_MODE_PIN]]
   
   }




   # Setting set_dft_signal for testmode connection to icg
   foreach dfx_inst [getvar -names G_DFX_HANDLER_MAP] {

      if { [info exist icg_map($dfx_inst)] && [llength $icg_map($dfx_inst)] == 0 } {
          rdt_print_info "There is no ICG associated with dfx_handler '$dfx_inst'"
          continue

      }

      if { [info exists dfx_test_mode_map($dfx_inst)] } {
         if { [regexp "/" $dfx_test_mode_map($dfx_inst) ] == 1 } {
            set cmd "set_dft_signal -view spec -hookup_pin \[get_pins $dfx_test_mode_map($dfx_inst) \] -type TestMode -usage clock_gating"

         } else {
            set cmd "set_dft_signal -view spec -port \[get_ports $dfx_test_mode_map($dfx_inst) \] -type TestMode -usage clock_gating"

         }

         rdt_print_info "$cmd"
         eval $cmd

      }

   }

   # Setting set_dft_connect to connect testmode icg
   foreach dfx_inst [getvar -names G_DFX_HANDLER_MAP] {

      if { [info exists icg_map($dfx_inst)] && [llength $icg_map($dfx_inst)] > 0 } {
         set icg [join $icg_map($dfx_inst)]
         regsub -all "\{|\}" $icg ""  icg
         set cmd "set_dft_connect $dfx_inst -type clock_gating_control -source $dfx_test_mode_map($dfx_inst) -target  [list $icg ] "
         rdt_print_info "$cmd"
         eval $cmd

      }

   }

   return TCL_OK

}

####################################################################################################
# This procedure attempts to auto-generating scan configuration setting prior to performing
# scan-stitching. The auto-generation happens when user's scan configuration is not available.
# It uses naming convention based on G_DFX_* variables to extract scan signals.
# This is written based on VLV/TNG scan architecture.
#
proc syn_dft_config_generation {args} {

   global product_version
   set dfx_handler_inst ""


   ########################################################################
   # Skipping when G_INSERT_SCAN = 0
   if { [getvar -quiet G_INSERT_SCAN] == 0 } {
       return TCL_OK

   }

   ##############################################################################
   # sourcing in user's configuration custom file if exists
   set config_file [rdt_source_if_exists -display [getvar {G_DESIGN_NAME}]_scan_config.tcl]
   if { [file exists $config_file] } {

      rdt_print_info "Detect existing user's scan configuration file '$config_file'"
      return TCL_OK
   
   # Attempt to extract DFX Specification from design (based on VLV DFX architecture)
   } else {

      rdt_print_info "No existing user's scan configuration file detected"
      rdt_print_info "Attempt to auto-generating scan configuration setting based on G_DFX_* variable settings"

      # Sanity check for dfx_handler 
      redirect /dev/null  { set dfx_handler_inst [get_object_name [get_cells -hierarchical -filter ref_name=~[getvar G_DFX_HANDLER_DESIGN_NAME]]] }

      if { $dfx_handler_inst == "" && [llength [getvar  -quiet -names G_DFX_HANDLER_MAP]] == 0 } {
         rdt_print_error "Skipping scan-chain insertion. Cannot detect existing dfx_handler module. Check G_DFX_HANDLER_DESIGN_NAME"
         rdt_print_error "    Resetting G_INSERT_SCAN to 0 to disable dft-related outputs/reports."
         setvar G_INSERT_SCAN 0
         return TCL_OK

      # Check to make sure that G_DFX_HANDLER_MAP exists when multiple dfx_handlers were detected
      } elseif { [llength $dfx_handler_inst] > 1 && [llength [getvar -quiet -names  G_DFX_HANDLER_MAP]] == 0 } {
         rdt_print_warn "Detecting multiple dfx_handler '$dfx_handler_inst', but there is no G_DFX_HANDLER_MAP() defined"
         rdt_print_warn "Skipping insert_dft. Resetting G_INSERT_SCAN to 0 to disable dft-related reports"
         setvar G_INSERT_SCAN 0
         return TCL_OK

      } elseif { [llength $dfx_handler_inst] == 1 && [llength [getvar -quiet -names G_DFX_HANDLER_MAP]] == 0 } {
          rdt_print_info "Detecting one dfx_handler instance '$dfx_handler_inst'"
          setvar G_DFX_HANDLER_MAP($dfx_handler_inst) [getvar G_DESIGN_NAME]

      }

         
      rdt_print_info "Generating .[getvar {G_DESIGN_NAME}]_scan_config.tcl file."
      set scan_cfg_fp [open .[getvar {G_DESIGN_NAME}]_scan_config.tcl w]


      set i 1
      foreach handler [getvar -names G_DFX_HANDLER_MAP] {

         if { [get_object_name [get_cells -quiet $handler]] == "" } {
             rdt_print_info "-E- Cannot find dfx_handler '$handler' defined in G_DFX_HANDLER_MAP"
             continue

         # detect single dfx-handler per partition, skip define_dft_partition
         } elseif { [getvar G_DFX_HANDLER_MAP(${handler})] == [getvar G_DESIGN_NAME] } {
             syn_dft_extract_scan_signals $scan_cfg_fp $handler
             puts $scan_cfg_fp "rdt_source_if_exists additional_dft_scan_config.tcl"
             continue
                      
         } else {
            puts $scan_cfg_fp "define_dft_partition dfx_partition_${i} -include \[list [getvar G_DFX_HANDLER_MAP(${handler})] \]"
            puts $scan_cfg_fp "current_dft_partition dfx_partition_${i}"

         }

         syn_dft_extract_scan_signals $scan_cfg_fp $handler
         puts $scan_cfg_fp "rdt_source_if_exists additional_dft_scan_config.tcl"
         incr i

      }


      close $scan_cfg_fp

   } 

}




###########################################################################################
# This proc takes in 2 arguments (file_fp dfx_handler_inst)
# return dfx_scan_enable and dfx_scan_test_mode signals
#
proc syn_dft_extract_scan_signals { args } {


   global product_version

   set scan_cfg_fp  [lindex $args 0]
   set dfx_handler_inst [lindex $args 1]

   set dfx_scan_in_orig ""
   set dfx_scan_out_orig "" 
   set dfx_scan_constant_0 ""
   set dfx_scan_constant_1 "" 
   set dfx_resets_0 "" 
   set dfx_resets_1 "" 
   set dfx_clocks "" 
   set dfx_scan_enable ""
   set dfx_scan_test_mode ""
   set dfx_existing_scan_test_mode ""

   # filter and only consider icg in scan-domain to test-mode connection
   set icg_in_nonscan_designs "" 
   set icg_in_nonscan_designs [syn_dft_get_icgs_in_nonscan_domains]
   
   ################################################################################
   # COLLECTING DFX SIGNALS FROM DESIGN
   ################################################################################
 
   foreach pin [getvar G_DFX_HANDLER_SCAN_IN_PINS]  { set dfx_scan_in_orig "$dfx_scan_in_orig [syn_dft_get_pin $dfx_handler_inst $pin]" }
   foreach pin [getvar G_DFX_HANDLER_SCAN_OUT_PINS]  { set dfx_scan_out_orig "$dfx_scan_out_orig [syn_dft_get_pin $dfx_handler_inst $pin]" }
  
   # HIP-aware scan handling
   set hip_list [::file::identify_hips_in_design]
   rdt_print_info "List of the hips in this design: $hip_list"
   set dfx_scan_out ""
   set dfx_scan_in "" 
   if { [llength $hip_list] > 0 } {
       foreach dfx_si_name $dfx_scan_in_orig {
           set fo_cell [all_fanout -from $dfx_si_name -flat -endpoints_only -only_cells -trace_arcs all]
           if { [sizeof_collection $fo_cell] == 1 } {
               set fo_cell_name [get_object_name $fo_cell]
               set fo_ref_name [get_attribute $fo_cell ref_name]
               if { [lsearch $hip_list $fo_ref_name] > -1 } {
                   rdt_print_info "$dfx_si_name is already connected to HIP instance $fo_cell_name. Skipping this pin for insert_dft"
               } else {
                   rdt_print_error "$dfx_si_name is connected to a non-HIP endpoint, check connectivity"
               }
           } else {
               if { [lsearch -exact $dfx_scan_in $dfx_si_name] < 0 } {
                   lappend dfx_scan_in $dfx_si_name
               }
           }
       }
       foreach dfx_so_name $dfx_scan_out_orig {      
           set fi_cell [all_fanin -to $dfx_so_name -flat -startpoints_only -only_cells -trace_arcs all]  
           set fi_ref_name [get_attribute $fi_cell ref_name]
           if { [sizeof_collection $fi_cell] == 1 && ![regexp {^\*\**logic_0\*\*$} $fi_ref_name] } {
                set fi_cell_name [get_object_name $fi_cell]
                if { [lsearch $hip_list $fi_ref_name] > -1 } {
                    rdt_print_info "$dfx_so_name is already connected to HIP instance $fi_cell_name. Skipping this pin for insert_dft" 
                } else {
                    rdt_print_error "$dfx_so_name is connected to a non-HIP endpoint, check connectivity"
                }
            } else { 
                if { [lsearch -exact $dfx_scan_out $dfx_so_name] < 0 } {
                    lappend dfx_scan_out $dfx_so_name
                }
            }
        }
    } else {
        set dfx_scan_in $dfx_scan_in_orig
        set dfx_scan_out $dfx_scan_out_orig
    } 
               

   # Search for constant signals
   foreach pin [getvar G_DFX_HANDLER_CONSTANT_HIGH_PINS] { set dfx_scan_constant_1 "$dfx_scan_constant_1 [syn_dft_get_pin $dfx_handler_inst $pin]" }
   foreach pin [getvar G_DFX_HANDLER_CONSTANT_LOW_PINS]  { set dfx_scan_constant_0 "$dfx_scan_constant_0 [syn_dft_get_pin $dfx_handler_inst $pin]" }

   # Search for clocks controlling Flops to be in scan-chains, skip scan-chain insertion if no clocks detected
   foreach pin [getvar G_DFX_HANDLER_CLOCK2FLOP_PINS] { set dfx_clocks "$dfx_clocks [syn_dft_get_pin $dfx_handler_inst $pin]" }
   
   # Search for reset signal
   foreach pin [getvar G_DFX_HANDLER_RESET2FLOP_LOW_PINS]   { set dfx_resets_0 "$dfx_resets_0 [syn_dft_get_pin $dfx_handler_inst $pin]" }
   foreach pin [getvar G_DFX_HANDLER_RESET2FLOP_HIGH_PINS] { set dfx_resets_1 "$dfx_resets_1 [syn_dft_get_pin $dfx_handler_inst $pin]" }

   # Search for scan-enable signal
   set dfx_scan_enable [syn_dft_get_pin $dfx_handler_inst [getvar G_DFX_HANDLER_SCAN_ENABLE_PIN]]
   lappend dfx_scan_enable_list $dfx_scan_enable

   # Search for test-mode signal
   set dfx_scan_test_mode [syn_dft_get_pin $dfx_handler_inst [getvar G_DFX_HANDLER_TEST_MODE_PIN]]
   lappend dfx_scan_test_mode_list $dfx_scan_test_mode

   # Search for additional existing test-mode signal
   set dfx_existing_scan_test_mode [syn_dft_get_pin $dfx_handler_inst [getvar G_DFX_ADDITIONAL_TEST_MODE_PIN]]
   lappend dfx_scan_test_mode_list $dfx_existing_scan_test_mode

   # DFT Configuration - PRESET as default can be overwrite by user's scan 
   puts $scan_cfg_fp "set_dft_insertion_configuration -preserve_design_name true -unscan true"

   # Setting to enable internal pins such as clock, scan-enable to be specified
   puts $scan_cfg_fp "set_dft_drc_configuration -clock_gating_init_cycles 4 -internal_pins enable"
     
   # We are not doing at-speed SCAN only normal scan with fixed clock frequency
   puts $scan_cfg_fp "set_scan_configuration -style [getvar G_SCAN_STYLE]"
   if { [regexp {^no_mix$|^mix_edges$|^mix_clocks$|^mix_clocks_not_edges$} [getvar G_SCAN_MIX_CLOCKS]] } {
      puts $scan_cfg_fp "set_scan_configuration -clock_mixing [getvar G_SCAN_MIX_CLOCKS]"
   } else {
      if { [getvar G_SCAN_MIX_CLOCKS] eq 1 } {
          puts $scan_cfg_fp "set_scan_configuration -clock_mixing mix_clocks"
      } else {
          rdt_print_warn "G_SCAN_MIX_CLOCKS: [getvar G_SCAN_MIX_CLOCKS] is not a valid option. Allowed options are no_mix|mix_edges|mix_clocks|mix_clocks_not_edges"
          rdt_print_info "Using default: no_mix"
          puts $scan_cfg_fp "set_scan_configuration -clock_mixing no_mix"
      }
   } 
   puts $scan_cfg_fp "set_scan_configuration -replace false"
   puts $scan_cfg_fp "set_scan_configuration -create_dedicated_scan_out_ports false"
   puts $scan_cfg_fp "set_scan_configuration -chain_count [llength $dfx_scan_in]"
   puts $scan_cfg_fp "set_scan_configuration -insert_terminal_lockup true -add_lockup true"
   puts $scan_cfg_fp "set_scan_configuration -add_lockup true"
   puts $scan_cfg_fp "set_scan_configuration -reuse_mv_cells false" 

   # exclude non-scan design instances. prevent scanenable signal hooking up to flops' ss pin in non-scan design
   set exclude_inst_list [syn_dft_get_nonscan_domains]
   if { $exclude_inst_list != "" } {
      puts $scan_cfg_fp "set_scan_configuration -exclude  \{ $exclude_inst_list \}"
   }

   if {[getvar -quiet G_VECTOR_FLOP] == "1"} {
      puts $scan_cfg_fp "set_scan_configuration -preserve_multibit_segment false"
   }

   if {[getvar -quiet  G_SCAN_LATCH_INSERT] != "1"} {
      # Remove latches from being used for scan-chain. latch is transparent in scan
      puts $scan_cfg_fp "set_scan_element false \[all_registers -level_sensitive\]"
   }

   # Define scan enable
   if { [regexp "/" $dfx_scan_enable] == 1 } {
      puts $scan_cfg_fp "set_dft_signal -view spec -type ScanEnable -active_state 1 -hookup_pin \[get_pins $dfx_scan_enable \]"
 
   } elseif { $dfx_scan_enable != "" } {
      if { [get_attribute -quiet $dfx_scan_enable port_direction] == "in" } {
         puts $scan_cfg_fp "set_dft_signal -view spec -type ScanEnable -active_state 1 -port \[get_ports $dfx_scan_enable \]"
      }

   }

   # Define scan test-mode. for one dfx-handler, define as spec. For multiple dfx-handler, define as existing
   if { [llength [getvar -quiet -names G_DFX_HANDLER_MAP]] < 2 } {

      if { [regexp "/" $dfx_scan_test_mode] == 1 } {
         puts $scan_cfg_fp "set_dft_signal -view spec -type TestMode  -active_state 1 -hookup_pin \[get_pins $dfx_scan_test_mode \]"

      } elseif { $dfx_scan_test_mode != "" } {
         if { [get_attribute -quiet $dfx_scan_test_mode port_direction] == "in" } {
            puts $scan_cfg_fp "set_dft_signal -view spec -type TestMode  -active_state 1 -port \[get_ports $dfx_scan_test_mode \]"
         }
      }

   } else {
      if { [regexp "/" $dfx_scan_test_mode] == 1 } {
         puts $scan_cfg_fp "set_dft_signal -view existing -type TestMode -active_state 1 -hookup_pin \[get_pins $dfx_scan_test_mode \]"

      } elseif { $dfx_scan_test_mode != "" } {
         if { [get_attribute -quiet $dfx_scan_test_mode port_direction] == "in" } {
            puts $scan_cfg_fp "set_dft_signal -view existing -type TestMode -active_state 1 -port \[get_ports $dfx_scan_test_mode \]"
         }

      }

   }

   # Define additional scan test-mode as existing based on the G_DFX_ADDITIONAL_TEST_MODE_PIN setting
   if { [regexp "/" $dfx_existing_scan_test_mode] == 1 } {
      puts $scan_cfg_fp "set_dft_signal -view existing -type TestMode  -active_state 1 -hookup_pin \[get_pins $dfx_existing_scan_test_mode \]"

   } elseif { $dfx_existing_scan_test_mode != "" } {

      if { [get_attribute -quiet $dfx_existing_scan_test_mode port_direction] == "in" } {
         puts $scan_cfg_fp "set_dft_signal -view existing -type TestMode  -active_state 1 -port \[get_ports $dfx_existing_scan_test_mode \]"

      }

   }

   # Define PGCB signals :: Requirement from BXT
   syn_dft_generate_pgcb_dfx_constraints $scan_cfg_fp  

   # Define scan clocks
   foreach pin  $dfx_clocks {
      if { [regexp "/" $pin] == 1 } {
         puts $scan_cfg_fp "set_dft_signal -view existing -type ScanClock -timing \[list 45 55\] -hookup_pin \[get_pins $pin \]"

      } else {
         if { [get_attribute -quiet $pin port_direction] == "in" } {
            puts $scan_cfg_fp "set_dft_signal -view existing -type ScanClock -timing \[list 45 55\] -port \[get_ports $pin \]"
         }

      }

   }

   # Define scan reset 
   foreach pin $dfx_resets_1 {
      if { [regexp "/" $pin] == 1 } {
         puts $scan_cfg_fp "set_dft_signal -view existing -type Constant -active_state 1 -hookup_pin \[get_pins $pin \]"

      } else {
         if { [get_attribute -quiet $pin port_direction] == "in" } {
            puts $scan_cfg_fp "set_dft_signal -view existing -type Constant -active_state 1 -port \[get_ports $pin \]"
         }

      }

   }
   foreach pin $dfx_resets_0 {
      if { [regexp "/" $pin] == 1 } {
         puts $scan_cfg_fp "set_dft_signal -view existing -type Constant -active_state 0 -hookup_pin \[get_pins $pin \]"

      } else {
         if { [get_attribute -quiet $pin port_direction] == "in" } {
            puts $scan_cfg_fp "set_dft_signal -view existing -type Constant -active_state 0 -port \[get_ports $pin \]"
         }

      }

   }

   # Define scan constant 1
   foreach pin $dfx_scan_constant_1 {
      if { [regexp "/" $pin] == 1 } {
         puts $scan_cfg_fp "set_dft_signal -view existing -type Constant -active_state 1 -hookup_pin \[get_pins $pin \]"

      } else {
         if { [get_attribute -quiet $pin port_direction] == "in" } {
            puts $scan_cfg_fp "set_dft_signal -view existing -type Constant -active_state 1 -port \[get_ports $pin \]"
         }
      }

   }

   # Define scan constant 0
   foreach pin $dfx_scan_constant_0 {
      if { [regexp "/" $pin] == 1 } {
         puts $scan_cfg_fp "set_dft_signal -view existing -type Constant -active_state 0 -hookup_pin \[get_pins $pin \]"

      } else {
         if { [get_attribute -quiet $pin port_direction] == "in" } {
         	puts $scan_cfg_fp "set_dft_signal -view existing -type Constant -active_state 0 -port \[get_ports $pin \]"
         }

      }

   }

   # Define scan_in connection
   foreach scan_in_pin $dfx_scan_in {
      if { [regexp "/" $scan_in_pin] == 1 } {
         puts $scan_cfg_fp "set_dft_signal -view spec -type ScanDataIn -hookup_pin \[get_pins $scan_in_pin \]"

      } else {
         puts $scan_cfg_fp "set_dft_signal -view spec -type ScanDataIn -port \[get_ports $scan_in_pin \]"

      }
   }


   # Define scan_out connection
   foreach scan_out_pin $dfx_scan_out {
      if { [regexp "/" $scan_out_pin] == 1 } {
         puts $scan_cfg_fp "set_dft_signal -view spec -type ScanDataOut -hookup_pin \[get_pins $scan_out_pin \]"

      } else {
         puts $scan_cfg_fp "set_dft_signal -view spec -type ScanDataOut -port \[get_ports $scan_out_pin \]"

      }

   }

   # Pair up sorted scan_in andn scan_out ports
   set sorted_dfx_scan_out [lsort -u $dfx_scan_out]
   set sorted_dfx_scan_in [lsort -u $dfx_scan_in] 
   if { [llength $sorted_dfx_scan_out] != [llength $sorted_dfx_scan_in] } {
       rdt_print_error "Scan out ([llength $sorted_dfx_scan_out]) and Scan in ([llength $sorted_dfx_scan_in]) count does not match... Check your design!"
   }  
   set index 0
   foreach scan_in_pin $sorted_dfx_scan_in {
       set scan_out_pin [lindex $sorted_dfx_scan_out $index]
       set indx "s${index}"
       if { [regexp {\[([0-9]+)\]$} $scan_in_pin match ind1] && [regexp {\[([0-9]+)\]$} $scan_out_pin match ind2] } {
           if {$ind1 == $ind2} {
               set indx $ind1
           }
       }
       puts $scan_cfg_fp "set_scan_path -view spec -scan_data_in $scan_in_pin -scan_data_out $scan_out_pin scan_chain_$indx"
       incr index
   }  

   return TCL_OK

}

#############################################################################################################
# Setting ideal network on se/tm signals to prevent compile-incr from inserting buf/inv on large fanout nets
proc syn_dft_disable_scan_drc {args} {

   set dfx_scan_se_tm_list ""


   # Extracting scan enable and scan testmode
   redirect /dev/null  {set dfx_handler_inst_list [get_object_name [get_cells -hierarchical -filter ref_name=~[getvar G_DFX_HANDLER_DESIGN_NAME] ]] }
   if { [llength  [getvar -quiet -names G_DFX_HANDLER_MAP]] != 0 } {
      redirect /dev/null { set dfx_handler_inst_list [concat $dfx_handler_inst_list [getvar -names G_DFX_HANDLER_MAP]] }
   }

   foreach dfx_handler_inst $dfx_handler_inst_list {

         set dfx_scan_enable [syn_dft_get_pin $dfx_handler_inst [getvar G_DFX_HANDLER_SCAN_ENABLE_PIN]]
         lappend dfx_scan_se_tm_list $dfx_scan_enable

         set dfx_scan_test_mode [syn_dft_get_pin $dfx_handler_inst [getvar G_DFX_HANDLER_TEST_MODE_PIN]]
         lappend dfx_scan_se_tm_list $dfx_scan_test_mode

   }


   rdt_print_info "Setting ideal network on scan-enable and scan-test-mode signals to prevent buffer-tree insertion."
   set_auto_disable_drc_nets -scan true
   foreach pin [join $dfx_scan_se_tm_list ] {
   
      if { [regexp "/" $pin] == 1 } {
         set drv_list [all_fanin -to $pin -flat -level 1]
         foreach drv_pin [get_object_name $drv_list] {
            if { [regexp "/" $drv_pin] == 1 } {
               set drv_cell [file dirname $drv_pin]
               if { [get_attribute $drv_cell is_hierarchical] == "false" && [get_attribute $drv_pin pin_direction] == "out" } {
                  rdt_print_info "Setting ideal on pin $drv_pin"
                  set_ideal_network [get_pins $drv_pin]
               }
            } else {
               rdt_print_info "Setting ideal on port $drv_pin"
               set_ideal_network [get_ports $drv_pin]
   
            }
         }
      } elseif { $pin != "" } {
         rdt_print_info "Setting ideal on port $pin"
         set_ideal_network [get_ports $pin]
   
      }
   
   } 

}


###############################################################################################
# This proc takes in 2 args (instance_name and its associated pin-name
#   
proc syn_dft_get_pin { instance_name pins } {

      suppress_message {UID-95}

      set pin_name "" 
      set pin_list {}


      if { [sizeof_collection [set pin_list [get_pins $instance_name/$pins ]]] > 0 } {
         foreach_in_collection pin $pin_list { set pin_name "$pin_name [get_object_name $pin]" }

      } elseif { ([regexp "/" $pins] == 1) && [sizeof_collection [set pin_list [get_pins $pins ]]] > 0 } {
         foreach_in_collection pin $pin_list { set pin_name "$pin_name [get_object_name $pin]" }

      } elseif { [sizeof_collection [set pin_list [get_ports $pins ]]] > 0 } {
         foreach_in_collection pin $pin_list { set pin_name "$pin_name [get_object_name $pin]" }
         
      }

      unsuppress_message {UID-95}

      return $pin_name

}


##################################################################################################
# This proc extracts all ICG belonging to nonscan domain. nonscan domains are those defined in
# G_DFX_NONSCAN_<DESIGNS|INSTANCES> 
#
proc syn_dft_get_icgs_in_nonscan_domains {args} {


   global product_version

   set icg_in_nonscan_designs ""
   set all_icg [get_cells -hier -filter "is_icg == true && clock_gating_integrated_cell =~ latch*"]
	
   # Collect all non-scan instances/desgns defined by users 
   set nonscan_user_list [syn_dft_get_nonscan_domains]

   # Collect all icg from non-scan design/instance list defined by user
   foreach inst $nonscan_user_list {
      set icg_in_nonscan_designs [add_to_collection $icg_in_nonscan_designs [filter_collection $all_icg "full_name =~ $inst/*"]]
   }

   return $icg_in_nonscan_designs


}


###############################################################################################
# Return the list of nonscan domain defined by user using G_DFX_NONSCAN_<DESIGNS|INSTANCES>

proc syn_dft_get_nonscan_domains {args} {


   set nonscan_inst_list ""

   if { [getvar -quiet G_DFX_NONSCAN_DESIGNS] != "" } {
      foreach design [getvar G_DFX_NONSCAN_DESIGNS] {
         set design_list [get_designs -quiet $design]

         if { [sizeof_collection $design_list] > 0 } {

            foreach_in_collection subdesign $design_list {            
               set des_name [get_object_name $subdesign]
               lappend nonscan_inst_list [get_object_name [get_cells -hier * -filter "ref_name =~ $des_name"]]
            }
         }
      }
   }

   if { [getvar -quiet G_DFX_NONSCAN_INSTANCES] != "" } {

      foreach inst [getvar G_DFX_NONSCAN_INSTANCES] {
         set inst_list [get_cells * -hier -filter "full_name =~ $inst"]

         if { [sizeof_collection $inst_list] > 0 } {

            foreach_in_collection cell $inst_list {
               lappend nonscan_inst_list [get_object_name $cell]

            }
         }
      }
   }
   
   # shchoi2: adding scan_false cells where we read CTL models - otherwise, they will end up connecting ss to scan_enable
   # vbharadw: Check newer version and follow up with Synopsys
   if { [getvar -quiet G_CTL_SEARCH_PATH] == "" } {
       rdt_print_warn "Cannot find G_CTL_SEARCH_PATH variable setting. Not able to attach CTL cells to exclude list for set_scan_configuration"
   } else {
       foreach ctl_dir [getvar G_CTL_SEARCH_PATH] {
           foreach ctl_file [glob -nocomplain ${ctl_dir}/*.ctl] {
               set ctl_cell_name [file root [file tail $ctl_file]]
               set ctl_cell_map($ctl_cell_name) "$ctl_file"
           }
       }
       if {[array size ctl_cell_map] > 0 }  {
           rdt_print_info "Adding false scan_element CTL cells to nonsan_inst_list"
           set sync_pattern ""
           foreach ctl_cell [array names ctl_cell_map] {
               set sync_pattern "$sync_pattern ref_name == $ctl_cell ||"
           }
           regsub { \|\|$} $sync_pattern "" sync_pattern
           foreach cell [get_object_name [get_cells  * -hier -quiet -filter "scan_element==false && ($sync_pattern)" ]] {
               if {[lsearch -exact $nonscan_inst_list $cell] < 0} {
                   lappend nonscan_inst_list $cell
               }
           }
       }   
   }

   set nonscan_inst_list [lsort -u $nonscan_inst_list]
   set nonscan_inst_list2 [list]
   foreach e $nonscan_inst_list {
      set found 0
      set e2 $e
      while {[regexp {/} $e2]==1} {
          set e2 [regsub {(.*)/.*} $e2 {\1}]
          if {[lsearch -exact $nonscan_inst_list $e2]>0} {set found 1; break}
      }
      if {$found==0} {lappend nonscan_inst_list2 $e}
   }
   return $nonscan_inst_list2

}

proc syn_dft_exclude_hookup_icg_in_nonscan_domains {args} {


   set icg_nonscan_list {}

   rdt_print_info "Excluding ICG/te in nonscan domain from hooking up to TestMode signal"

   set nonscan_user_list [syn_dft_get_nonscan_domains]
   set_scan_element false $nonscan_user_list

   set icg_in_nonscan_designs [syn_dft_get_icgs_in_nonscan_domains]

   # Setting set_dft_clock_gating_configuration to exclude icg in non-scan domain from hooking up to TestMode signal
   if { [sizeof_collection $icg_in_nonscan_designs] > 0 } {
      foreach_in_collection icg $icg_in_nonscan_designs {
         set icg_cell [get_object_name $icg]
         set icg_parent [file dirname $icg_cell]
         if {[getvar -quiet DFT_VERBOSE_LEVEL] == 2} {
             rdt_print_info "set_dft_clock_gating_configuration -exclude $icg_parent"
             set_dft_clock_gating_configuration -exclude $icg_parent
         } else {
             redirect -var tmp {set_dft_clock_gating_configuration -exclude $icg_parent}
             if {[regexp {Discarded} $tmp]} {
                rdt_print_info "Discarded: set_dft_clock_gating_configuration -exclude $icg_parent"
             }
         }
      }

   }
 
   return TCL_OK

}

# This proc is to fix icg/te hookup to test_cgtm. It disconnects ICG/te from test_cgtm and reconnect those ICG/te
# back to 1'b0. 'test_cgtm' is expected to be floating and should be removed when generating final verilog netlist.
# Some of the ICG in non-scan domains cannot be excluded by DFTC through set_dft_clock_gating_configuration -exclude
# DFTC creates port 'test_cgtm' and hook those ICGs up to the newly created port.
# This issue is seen only when we are in dft_partition mode (used when partition has multiple dfx-handlers).
proc syn_dft_fix_icg_hookup {} {


   if { [sizeof_collection [get_ports -quiet test_cgtm]] == 0 } {
      rdt_print_info "No 'test_cgtm' port exists. No need to post-fix icg/te hookup"
	  return TCL_OK

   }

   set icg_in_nonscan_designs [syn_dft_get_icgs_in_nonscan_domains]
   set icg_cgtm [all_fanout -flat -level 1 -only -from test_cgtm ]
   set icg_cannot_fix_collection [remove_from_collection $icg_cgtm $icg_in_nonscan_designs]

   if { [sizeof_collection $icg_cannot_fix_collection] > 0 } {

      rdt_print_error "Detecting some ICG's in scan-domain hooking up to test_cgtm."
      rdt_print_error "Those ICG's should connect to its respective TestMode signal. Debug is needed."
	  rdt_print_error "[get_object_name $icg_cannot_fix_collection]"
	  rdt_print_error "Abort icg hookup fixing..."
	  return TCL_OK

   } else {

      rdt_print_info "Fixing ICG/te hookup for some ICG's in nonscan domains"

      # loop through all icg and rehook up to 1'b0 
      foreach_in_collection icg $icg_cgtm {

         set icg_name [get_object_name $icg]

		 rdt_print_info "\tFixing ICG: $icg_name"

         # disconnect icg/te pins from test-mode signal
         set te_pin [get_pins -quiet $icg_name/te]
		 set te_net [get_nets -quiet -of_obj $te_pin]
		 disconnect_net $te_net $te_pin

	     set icg_parent [file dirname $icg_name]

         # creating new vss cells to hook icg/te to
		 if { [set vss_cell [get_object_name [get_cells -quiet $icg_parent/U_GND]]] == "" } {
		 	create_cell -logic 0 $icg_parent/U_GND
			set vss_cell "$icg_parent/U_GND"

         }
		 set vss_net [get_object_name [get_nets -of_obj [get_pins $vss_cell/*]]]

         # connect icg/te to vss
		 connect_net $vss_net $te_pin

	  }

   }

   return TCL_OK

}
################################################################################
# Intel Confidential
################################################################################
# Copyright (C) 2014, Intel Corporation.  All rights reserved.
#
# This is the property of Intel Corporation and may only be utilized
# pursuant to a written Restricted Use Nondisclosure Agreement
# with Intel Corporation.  It may not be used, reproduced, or
# disclosed to others except in accordance with the terms and
# conditions of such agreement.
################################################################################
# Description
# This procedures are used to enable scan-chain insertion in DC.
# The flow is based on the VLV DFT architecture and naming convention
#


#################################################################################
# DFT Compiler Optimization Section
#################################################################################
# It is recommended that top-level test ports be defined as a part of the
# RTL design and included in the netlist for floorplanning.

proc syn_dft_get_pin_core { pins {dir in} } {

      global dfx_handler_inst

      suppress_message {UID-95}

      set pin_name "" 
      set pin_list {}

      set pin_dir $dir
      set port_dir $dir

      if {$dir == "drv"} {
         set pin_dir out
         set port_dir in
      } elseif {$dir == "ld"} {
         set pin_dir in
         set port_dir out
      }

      if {![info exists dfx_handler_inst]} { set dfx_handler_inst "" }

      if { [sizeof_collection [set pin_list [get_pins $dfx_handler_inst/$pins -filter "pin_direction == $pin_dir"]]] > 0 } {
         foreach_in_collection pin $pin_list { set pin_name "$pin_name [get_object_name $pin]" }

      } elseif { ([regexp "/" $pins] == 1) && [sizeof_collection [set pin_list [get_pins $pins -filter "pin_direction == $pin_dir"]]] > 0 } {
         foreach_in_collection pin $pin_list { set pin_name "$pin_name [get_object_name $pin]" }

      } elseif { [sizeof_collection [set pin_list [get_ports $pins -filter "pin_direction == $port_dir"]]] > 0 } {
         foreach_in_collection pin $pin_list { set pin_name "$pin_name [get_object_name $pin]" }
         
      }

      unsuppress_message {UID-95}

      return $pin_name

}


proc syn_dft_get_scan_blocks {} {

   if {[getvar G_DFX_SUB_BLOCK_METHOD] ne 1} {
      return [getvar G_DESIGN_NAME]
   }


   set scan_block_list {}
   if {[get_attribute [get_designs -quiet [getvar G_DESIGN_NAME]] insert_scan_block_list] != ""} {
      set insert_scan_block_list [get_attribute [get_designs [getvar G_DESIGN_NAME]] insert_scan_block_list] 
   } else {
      set insert_scan_block_list ""
   }

   if {[getvar G_INSERT_SCAN_BLOCK_INST_LIST] != ""} {
      foreach block_inst [getvar G_INSERT_SCAN_BLOCK_INST_LIST] {
         lappend scan_block_list [get_attribute [get_cells -hier $block_inst] ref_name]
      }
   } elseif {[getvar G_INSERT_SCAN_BLOCK_LIST] != ""} {
      set scan_block_list [getvar G_INSERT_SCAN_BLOCK_LIST]
   } elseif {$insert_scan_block_list != ""} {
      set scan_block_list ""
      foreach des $insert_scan_block_list {
      	foreach inst [get_cells -hier -filter "ref_name==$des" -quiet] {
	   set inst_name [get_object_name $inst]
	   if {[sizeof_collection [get_pins $inst_name/[getvar G_DFX_HANDLER_SCAN_IN_PINS] -quiet]]==0} {continue}
	   if {[sizeof_collection [get_pins $inst_name/[getvar G_DFX_HANDLER_SCAN_OUT_PINS] -quiet]]==0} {continue}
	   lappend scan_block_list $des
	}
      }
      set scan_block_list [lsort -u $scan_block_list]
   } else {
      #default
      set scan_block_list [getvar G_DESIGN_NAME]
   }

   #removing SDP designs from scan insertion list
   if {[getvar -quiet G_IMPORT_SDP_LIST] ne ""} {
      set scan_block_list [lminus -exact $scan_block_list [getvar G_IMPORT_SDP_LIST]]

   }

   #removing the RF blocks from scan replacement
   set scan_block_list [lminus -exact $scan_block_list [get_attribute [get_cells -quiet -hier * -filter "is_rf_block == true"] ref_name]]

   #removing dont scan blocks from the scan insertion list
   if {[getvar -quiet G_DONT_INSERT_SCAN_BLOCK_LIST] ne ""} {
      set scan_block_list [lminus -exact $scan_block_list [getvar G_DONT_INSERT_SCAN_BLOCK_LIST]]
   }

   rdt_print_info "scan block list = $scan_block_list"
    
   return $scan_block_list

}


proc syn_dft_config_generation_core { block exclude_inst_list } {

   #Define global variables



   # Initialize variables
   global dfx_handler_inst ""
   set dfx_scan_in ""
   set dfx_scan_out "" 
   set dfx_scan_constant_0 ""
   set dfx_scan_constant_1 "" 
   set dfx_resets_0 "" 
   set dfx_resets_1 "" 
   set dfx_clocks "" 
   set dfx_aclocks ""
   set dfx_bclocks ""
   set dfx_scan_enable ""
   set dfx_scan_test_mode ""

   ################################################################################
   # COLLECTING DFX SIGNALS FROM DESIGN
   ################################################################################
      
   # Search for DFX_HANDLER designs
   #redirect /dev/null  { set dfx_handler_inst [get_object_name [get_cells -hierarchical -filter ref_name=~[getvar G_DFX_HANDLER_DESIGN_NAME] ]] }
   redirect /dev/null  { set dfx_handler_inst [get_object_name [get_cells -hierarchical -filter name=~[getvar G_DFX_HANDLER_DESIGN_NAME]]] }

   # First version: to require to enable the checks due to problems found during MCORE testing
   if { [getvar -quiet G_DFX_HANDLER_ENABLE_CHECK] == 1} {
      if { $dfx_handler_inst == "" } {
         rdt_print_info "-E- Skipping scan-chain insertion. Cannot detect existing dfx_handler module. Check G_DFX_HANDLER_DESIGN_NAME"
         rdt_print_info "    Resetting G_INSERT_SCAN to 0 to disable dft-related outputs/reports."
         setvar G_INSERT_SCAN 0
         return 0

      } elseif { [llength $dfx_handler_inst] > 1 } {
         rdt_print_info "-E- Skipping scan-chain insertion. Detect multiple dfx_handler module. Check G_DFX_HANDLER_DESIGN_NAME"
         rdt_print_info "    Resetting G_INSERT_SCAN to 0 to disable dft-related outputs/reports."
         setvar G_INSERT_SCAN 0
         return 0
      }
   }

   # Search and use for scan-in and scan-out from DFX_HANDLER
   foreach pin [getvar G_DFX_HANDLER_SCAN_IN_PINS]  { set dfx_scan_in "$dfx_scan_in [syn_dft_get_pin_core $pin]" }
   foreach pin [getvar G_DFX_HANDLER_SCAN_OUT_PINS]  { set dfx_scan_out "$dfx_scan_out [syn_dft_get_pin_core $pin out]" }
   
   # Search for constant signals
   foreach pin [getvar G_DFX_HANDLER_CONSTANT_HIGH_PINS] { set dfx_scan_constant_1 "$dfx_scan_constant_1 [syn_dft_get_pin_core $pin drv]" }
   foreach pin [getvar G_DFX_HANDLER_CONSTANT_LOW_PINS]  { set dfx_scan_constant_0 "$dfx_scan_constant_0 [syn_dft_get_pin_core $pin drv]" }
   
   # Search for clocks controlling Flops to be in scan-chains, skip scan-chain insertion if no clocks detected
   foreach pin [getvar G_DFX_HANDLER_CLOCK2FLOP_PINS] { set dfx_clocks "$dfx_clocks [syn_dft_get_pin_core $pin drv]" }

   if {[getvar -quiet G_DFX_HANDLER_ACLOCK2FLOP_PINS] ne ""} {
      foreach pin [getvar G_DFX_HANDLER_ACLOCK2FLOP_PINS] { set dfx_aclocks "$dfx_aclocks [syn_dft_get_pin_core $pin drv]" }
   }
   if {[getvar -quiet G_DFX_HANDLER_BCLOCK2FLOP_PINS] ne ""} {
      foreach pin [getvar G_DFX_HANDLER_BCLOCK2FLOP_PINS] { set dfx_bclocks "$dfx_bclocks [syn_dft_get_pin_core $pin drv]" }
   }
      
   # Search for reset signal
   foreach pin [getvar G_DFX_HANDLER_RESET2FLOP_LOW_PINS]   { set dfx_resets_0 "$dfx_resets_0 [syn_dft_get_pin_core $pin drv]" }
   foreach pin [getvar G_DFX_HANDLER_RESET2FLOP_HIGH_PINS] { set dfx_resets_1 "$dfx_resets_1 [syn_dft_get_pin_core $pin drv]" }
   
   # Search for scan-enable signal
   set dfx_scan_enable [syn_dft_get_pin_core [getvar G_DFX_HANDLER_SCAN_ENABLE_PIN]]
   
   # Search for test-mode signal
   set dfx_scan_test_mode [syn_dft_get_pin_core [getvar G_DFX_HANDLER_TEST_MODE_PIN]]


   # Create the patterns to match dmimic cells
   if {[getvar -quiet G_SCAN_ENABLE_DMIMIC] == 1} {
      set dmimic_cell_patterns [syn_dft_list_to_filter_pattern @ref_name or [getvar G_DMIMIC_CELL_PATTERNS]]
   }

   
   ############################################################################
   # Generate SCAN_CONFIG report file based on the collected information
   ############################################################################
   rdt_print_info "Generating .${block}.insert_dft.scan_config.tcl file."
   
   redirect [getvar {G_REPORTS_DIR}]/${block}.insert_dft.scan_config.tcl {
      
   if {[getvar -quiet G_SCAN_TEST_SIMULATION_LIBRARY] ne ""} { 
      if {![catch {set sim_library [glob [getvar {G_SCAN_TEST_SIMULATION_LIBRARY}]/*.v]}]} {
         puts "set test_simulation_library \[list $sim_library \]\n"
      }
   } else {
      rdt_print_warn "Scan Stitching may not occur properly without test simulation library being set.  Ensure that functionality for rcb and lcb cells are defined in your library or create a test simulation library and point to the directory with the verilog models with the G_SCAN_TEST_SIMULATION_LIBRARY variable"
   }

      # Setting the test clocks defaults
      puts "set test_default_period 100.00"
      puts "set test_default_delay 5.00"
      puts "set test_default_bidir_delay 5.00"
      puts "set test_default_strobe 40.00"
      puts "set test_default_strobe_width 0.00"
      puts ""

      # DFT Configuration - PRESET as default can be overwrite by user's scan 
      puts "set_dft_insertion_configuration -preserve_design_name true -synthesis_optimization none -unscan false"

      # Setting to enable internal pins such as clock, scan-enable to be specified
      puts "set_dft_drc_configuration -clock_gating_init_cycles 4 -internal_pins enable"

      # We are not doing at-speed SCAN only normal scan with fixed clock frequency
      puts "set_scan_configuration -style [getvar G_SCAN_STYLE]"
      if { [regexp {^no_mix$|^mix_edges$|^mix_clocks$|^mix_clocks_not_edges$} [getvar G_SCAN_MIX_CLOCKS]] } {
         puts "set_scan_configuration -clock_mixing [getvar G_SCAN_MIX_CLOCKS]"
      } else {
         if { [getvar G_SCAN_MIX_CLOCKS] eq 1 } {
             puts "set_scan_configuration -clock_mixing mix_clocks"
         } else {
             rdt_print_warn "G_SCAN_MIX_CLOCKS: [getvar G_SCAN_MIX_CLOCKS] is not a valid option. Allowed options are no_mix|mix_edges|mix_clocks|mix_clocks_not_edges"
             rdt_print_info "Using default: no_mix"
             puts "set_scan_configuration -clock_mixing no_mix"
         }
      }
      if {[getvar -quiet G_SCAN_INSERT_TERMINAL_LOCKUP] eq "" || [getvar G_SCAN_INSERT_TERMINAL_LOCKUP] eq 1} {
         puts "set_scan_configuration -insert_terminal_lockup true -add_lockup true"
      }
      puts "set_scan_configuration -replace false"
      if {[getvar -quiet G_SCAN_CREATE_DEDICATED_SO_PORTS] eq "" || [getvar G_SCAN_CREATE_DEDICATED_SO_PORTS] eq 1} {
         puts "set_scan_configuration -create_dedicated_scan_out_ports true"
      }
      puts "set_scan_configuration -chain_count [llength $dfx_scan_in]"

      if {[getvar -quiet G_VECTOR_FLOP] == "1"} {
         puts "set_scan_configuration -preserve_multibit_segment false"
      }
      # Remove latches from being used for scan-chain. latch is transparent in scan
      if {[getvar -quiet G_SCAN_LATCHES] eq "" || [getvar G_SCAN_LATCHES] eq 0} {
         puts "set_scan_element false \[all_registers -level_sensitive\]"
      }

      # exclude non-scan design instances. prevent scanenable signal hooking up to flops' ss pin in non-scan design
      if { $exclude_inst_list != "" } {
         puts "set_scan_configuration -exclude \{ $exclude_inst_list \}"
      }

      # set scan ready state
      puts "set_scan_state test_ready\n"

      # Define scan enable
      if { [regexp "/" $dfx_scan_enable] == 1 } {
         puts "set_dft_signal -view spec -type ScanEnable -active_state 1 -hookup_pin \[get_pins $dfx_scan_enable \]"

      } elseif { $dfx_scan_enable != "" } {
         puts "set_dft_signal -view spec -type ScanEnable -active_state 1 -port \[get_ports $dfx_scan_enable \]"

      }

      # Define scan testmode 
      puts "\n# Scan Testmode Signal: $dfx_handler_inst/[getvar G_DFX_HANDLER_TEST_MODE_PIN]"
      if { [regexp "/" $dfx_scan_test_mode] == 1 } {
         puts "set_dft_signal -view spec -type TestMode -active_state 1 -hookup_pin \[get_pins $dfx_scan_test_mode \]"

      } elseif { $dfx_scan_test_mode != "" } {
         puts "set_dft_signal -view spec -type TestMode -active_state 1 -port \[get_ports $dfx_scan_test_mode \]"

      }

      # Define scan clocks
      foreach pin  $dfx_clocks {
         if { [regexp "/" $pin] == 1 } {
            puts "set_dft_signal -view existing -type MasterClock -timing \[list 45 55\] -hookup_pin \[get_pins $pin \]"

         } else {
            puts "set_dft_signal -view existing -type MasterClock -timing \[list 45 55\] -port \[get_ports $pin \]"

         }

      }


      # Define scan a clocks
      foreach pin  $dfx_aclocks {
         if { [regexp "/" $pin] == 1 } {
            puts "set_dft_signal -view existing -type ScanMasterClock -timing \{45 55\} -hookup_pin \[get_pins $pin \]"
            puts "set_dft_signal -view spec -type ScanMasterClock -hookup_pin \[get_pins $pin \]"

         } else {
            puts "set_dft_signal -view existing -type ScanMasterClock -timing \{45 55\} -port \[get_ports $pin \]"
            puts "set_dft_signal -view spec -type ScanMasterClock -port \[get_ports $pin \]"

         }

      }

      # Define scan b clocks
      foreach pin  $dfx_bclocks {
         if { [regexp "/" $pin] == 1 } {
            puts "set_dft_signal -view existing -type ScanSlaveClock -timing \{55 65\} -hookup_pin \[get_pins $pin \]"
            puts "set_dft_signal -view spec -type ScanSlaveClock -hookup_pin \[get_pins $pin \]"

         } else {
            puts "set_dft_signal -view existing -type ScanSlaveClock -timing \{55 65\} -port \[get_ports $pin \]"
            puts "set_dft_signal -view spec -type ScanSlaveClock -port \[get_ports $pin \]"

         }

      }

      # Define scan reset 
      foreach pin $dfx_resets_1 {
         if { [regexp "/" $pin] == 1 } {
            puts "set_dft_signal -view existing -type Reset -active_state 1 -hookup_pin \[get_pins $pin \]"

         } else {
            puts "set_dft_signal -view existing -type Reset -active_state 1 -port \[get_ports $pin \]"

         }

      }
      foreach pin $dfx_resets_0 {
         if { [regexp "/" $pin] == 1 } {
            puts "set_dft_signal -view existing -type Reset -active_state 0 -hookup_pin \[get_pins $pin \]"

         } else {
            puts "set_dft_signal -view existing -type Reset -active_state 0 -port \[get_ports $pin \]"

         }

      }


      # Define scan constant 1
      foreach pin $dfx_scan_constant_1 {
         if { [regexp "/" $pin] == 1 } {
            puts "set_dft_signal -view existing -type Constant -active_state 1 -hookup_pin \[get_pins $pin \]"

         } else {
            puts "set_dft_signal -view existing -type Constant -active_state 1 -port \[get_ports $pin \]"
         }

      }

      # Define scan constant 0
      foreach pin $dfx_scan_constant_0 {
         if { [regexp "/" $pin] == 1 } {
            puts "set_dft_signal -view existing -type Constant -active_state 0 -hookup_pin \[get_pins $pin \]"

         } else {
            puts "set_dft_signal -view existing -type Constant -active_state 0 -port \[get_ports $pin \]"

         }

      }

      # Define scan_in connection
      foreach scan_in_pin $dfx_scan_in {
         if { [regexp "/" $scan_in_pin] == 1 } {
            puts "set_dft_signal -view spec -type ScanDataIn -hookup_pin \[get_pins $scan_in_pin \]"

         } else {
            puts "set_dft_signal -view spec -type ScanDataIn -port \[get_ports $scan_in_pin \]"

         }
      }


      # Define scan_out connection
      foreach scan_out_pin $dfx_scan_out {
         if { [regexp "/" $scan_out_pin] == 1 } {
            puts "set_dft_signal -view spec -type ScanDataOut -hookup_pin \[get_pins $scan_out_pin \]"

         } else {
            puts "set_dft_signal -view spec -type ScanDataOut -port \[get_ports $scan_out_pin \]"

         }

      }

      if {[getvar -quiet G_SCAN_ENABLE_DMIMIC] == 1} {
         puts "set_dft_clock_gating_pin \[get_cells -hier -filter \"$dmimic_cell_patterns\"\] -control_signal ScanEnable -pin_name [getvar G_DMIMIC_CELL_SE_PIN]"
      }

      # Apply Scan Spec 
      puts "create_test_protocol"

      # set scan ready state
      #puts "set_scan_state test_ready"


   }

   # Sourcing the DFX specification
   source [getvar {G_REPORTS_DIR}]/${block}.insert_dft.scan_config.tcl


   rdt_print_info "Setting ideal network on scan-enable and scan-test-mode signals to prevent buffer-tree insertion."

   set_auto_disable_drc_nets -scan true
   foreach pin [list $dfx_scan_enable $dfx_scan_test_mode] {

      if { [regexp "/" $pin] == 1 } {
         set drv_list [all_fanin -to $pin -flat -level 1]
         foreach drv_pin [get_object_name $drv_list] {
            if { [regexp "/" $drv_pin] == 1 } {
               set drv_cell [file dirname $drv_pin]
               if { [get_attribute $drv_cell is_hierarchical] == "false" && [get_attribute $drv_pin pin_direction] == "out" } {
                  rdt_print_info "Setting ideal on pin $drv_pin"
                  set_ideal_network [get_pins $drv_pin]
               }
            } else {
               rdt_print_info "Setting ideal on port $drv_pin"
               set_ideal_network [get_ports $drv_pin]

            }
         }

      } elseif { $pin != "" } {
         rdt_print_info "Setting ideal on port $pin"
         set_ideal_network [get_ports $pin]

      }

   }

}

# Proc to combine the sub hier block into the partition scandef from GLM
proc syn_dft_combined_sub_block_scandef_generation {scan_block_list} {
   
   current_design [getvar G_DESIGN_NAME]

   set total_scan_chains 0
   catch {unset block_si_port_array}
   array set block_si_port_array {}
   catch {unset block_so_port_array}
   array set block_so_port_array {}

   catch {unset scan_block_inst_array}
   array set scan_block_inst_array {}
   foreach scan_block $scan_block_list {
      set scan_block_inst_array($scan_block) [get_attribute [get_cells -hier -filter "ref_name == $scan_block"] full_name]
   }

   foreach scan_block $scan_block_list {
      current_design $scan_block
      set total_scan_chains [expr $total_scan_chains + [get_scan_chains]]
      set cell_prefix "$scan_block_inst_array($scan_block)"

      set chain_names [lsort -inte [get_scan_chains_by_name]]

      foreach chain_name $chain_names {
         set scan_cells [syn_dft_get_scan_cells_of_chain $chain_name]
         set first_cell_array($scan_block,$chain_name) "$cell_prefix/[get_object_name [index_collection $scan_cells 0]]"

         set full_si_pinname [get_pins -quiet -of [index_collection $scan_cells 0]                                -filter {signal_type =~ test_scan_in*}]
         set full_so_pinname [get_pins -quiet -of [index_collection $scan_cells [expr [sizeof $scan_cells] - 1]]  -filter {signal_type =~ test_scan_out*}]

         if {$full_si_pinname == ""} {
            set full_si_pinname [get_pins -quiet -of [index_collection $scan_cells 0]                                 -filter {pin_name == si}]
         }
         if {$full_so_pinname == ""} {
            set full_so_pinname [get_pins -quiet  -of [index_collection $scan_cells [expr [sizeof $scan_cells] - 1]]  -filter "pin_name == so"]
         }
         set scancell_si [get_object_name [filter_collection [all_fanin  -flat -to   $full_si_pinname ] {set_dft_signal == 2}]]
         set scancell_so [get_object_name [filter_collection [all_fanout -flat -from $full_so_pinname ] {set_dft_signal == 2}]]

         set block_si_port_array($scan_block,$chain_name) "$cell_prefix/$scancell_si"
         set block_so_port_array($scan_block,$chain_name) "$cell_prefix/$scancell_so"
      }
   }

   catch {unset scan_chain_start_array}
   array set scan_chain_start_array {}
   catch {unset scan_chain_end_array}
   array set scan_chain_end_array {}

   current_design [getvar G_DESIGN_NAME]
   foreach chain_name [array names block_si_port_array] {
      rdt_print_info "Start point for chain $chain_name; tracing from $block_si_port_array($chain_name)"
      set scan_chain_start_array($chain_name) [get_object_name [filter_collection [all_fanout -flat -from [get_ports $block_si_port_array($chain_name)] -levels 1 ] "pin_direction == out"]]
      rdt_print_info "End point for chain $chain_name; tracing from $block_so_port_array($chain_name)"
      set scan_chain_end_array($chain_name) [get_object_name [filter_collection [all_fanin -flat -to [get_ports $block_so_port_array($chain_name)] -levels 1] "pin_direction == in"]]
   }

   current_design [getvar G_DESIGN_NAME]

   redirect [getvar G_OUTPUTS_DIR]/[getvar {G_DESIGN_NAME}].scandef {
      puts "VERSION 5.5 ;"
      puts "NAMESCASESENSITIVE ON ;"
      puts "DIVIDERCHAR \"/\" ;"
      puts "BUSBITCHARS \"\[\]\" ;"
      puts "DESIGN [getvar G_DESIGN_NAME] ;\n"
      puts "SCANCHAINS $total_scan_chains ;\n"
   }

   set chain_number 1
   foreach scan_block $scan_block_list {
      rdt_print_info "Working on block $scan_block"
      current_design $scan_block
      set cell_prefix "$scan_block_inst_array($scan_block)"
      foreach chain_name [lsort -inte [get_scan_chains_by_name]] {
         rdt_print_info "Working on chain $chain_name"
         redirect -append [getvar G_OUTPUTS_DIR]/[getvar {G_DESIGN_NAME}].scandef {
            #puts "- $chain_number"
            puts "- ${scan_block}_${chain_name}"

            set start_cell_pin_str "$scan_chain_start_array($scan_block,$chain_name)"
            set start_cell [string range $start_cell_pin_str 0 [expr [string last "/" $start_cell_pin_str] - 1]]
            set start_pin [string range $start_cell_pin_str [expr [string last "/" $start_cell_pin_str] + 1] end]
            puts "+ START $start_cell $start_pin"

            set index 0
            set scan_cells [syn_dft_get_scan_cells_of_chain $chain_name]
            while {$index < [sizeof_collection $scan_cells]} {
               if {$index == 0} {
                  set prefix "+ FLOATING"
               } else {
                  set prefix "          "
               }
               set scan_cell_name "${cell_prefix}/[get_object_name [index_collection $scan_cells $index]]"
               
               set scan_cell_si [get_attribute -quiet [get_pins -quiet -of [index_collection $scan_cells $index] -filter "signal_type =~ test_scan_in*"] name]
               set scan_cell_so [get_attribute -quiet [get_pins -quiet -of [index_collection $scan_cells $index] -filter "signal_type =~ test_scan_out*"] name]
               if {$scan_cell_si == ""} {
                  set scan_cell_si [get_attribute [get_pins -of [index_collection $scan_cells $index] -filter "pin_name==si"] name]
               }
               if {$scan_cell_so == ""} {
                  set scan_cell_so [get_attribute [get_pins -of [index_collection $scan_cells $index] -filter "pin_name==so"] name]
               }
               puts "$prefix $scan_cell_name ( IN $scan_cell_si ) ( OUT $scan_cell_so )"

               incr index
            }
            puts "+ PARTITION iscan_chain_${scan_block}"

            set end_cell_pin_str "$scan_chain_end_array($scan_block,$chain_name)"
            set end_cell [string range $end_cell_pin_str 0 [expr [string last "/" $end_cell_pin_str] - 1]]
            set end_pin [string range $end_cell_pin_str [expr [string last "/" $end_cell_pin_str] + 1] end]
            puts "+ STOP $end_cell $end_pin ;\n"
         }

         incr chain_number
      }
   }

   redirect -append [getvar G_OUTPUTS_DIR]/[getvar {G_DESIGN_NAME}].scandef {
      puts "END SCANCHAINS\n"
      puts "END DESIGN"
   }

   current_design [getvar G_DESIGN_NAME]

}


proc syn_dft_get_scan_cells_of_chain {chain_name} {
    
    redirect -variable myscanpath {report_scan_path -view existing_dft -cell $chain_name}
    
    set myscantemp [split $myscanpath "\n"]
    set headerfound 0
    set beautyline 0
    set readcell 0
    set myscanlist {}
    foreach scantemp $myscantemp {
        if {[string match Scan_path* $scantemp]} {
            set headerfound 1
            continue
        }
        if {$headerfound == 1 } {
            set beautyline 1
            set headerfound 0
            continue
        }
        if {$beautyline == 1} {
            set line [regexp -inline -all -- {\S+} $scantemp ]
            if {[lindex $line 2] == 0} {
            set myscancell [string trim [lindex $line 3] ]
            regsub -all {\/.*} $myscancell "" myscancell
            append_to_collection myscanlist [get_cells $myscancell]
            }
            set beautyline 0
            set readcell 1
            continue
        }
        if {$readcell == 1 } {
            set line [regexp -inline -all -- {\S+} $scantemp ]
            if {[string is integer [string trim [lindex $line 0] ] ]} {
            set myscancell  [string trim [lindex $line 1]]
            regsub -all {\/.*} $myscancell "" myscancell
            append_to_collection myscanlist [get_cells $myscancell]
            }
        }
    }
    return $myscanlist
    
}



proc syn_dft_buffer_scan_ports { scan_block } {

   #Adding buffer si that it can be used as the start of scan chain
   set dfx_scan_in ""
   set hdlin_presto_net_name_prefix "n"
   foreach pin [getvar G_DFX_HANDLER_SCAN_IN_PINS]  {
      append dfx_scan_in [syn_dft_get_pin_core $pin]
   }

   set i 0
   set si_buf ""
   foreach_in_collection p [get_ports $dfx_scan_in] {
      append_to_collection si_buf [insert_buffer -new_net_names "n_${scan_block}_dft_si_isolate_${i}_buf" -new_cell_names "${scan_block}_dft_si_isolate_${i}_buf_dcszo" $p [getvar G_BUF_MASTER] ]
      incr i
   }
   if {[sizeof_collection $si_buf]} {
      set_size_only $si_buf true
   }

   #Adding buffer so that it can be used to drive the UTC logic
   set dfx_scan_out ""
   foreach pin [getvar G_DFX_HANDLER_SCAN_OUT_PINS]  {
      append dfx_scan_out [syn_dft_get_pin_core $pin out]
   }

   set i 0
   set so_buf ""
   set inv_pttrn ""
   foreach inv_type [getvar G_INV_MASTER_TYPE] {
      append inv_pttrn "ref_name =~ ${inv_type} || "
   }

   set inv_pttrn [lreplace $inv_pttrn end end]     
   foreach_in_collection p [get_ports $dfx_scan_out] {
      if {[getvar -quiet G_FIX_SCAN_CHAIN_INVERSION] == 1} {
         set inv_in_scan_chain_to_be_removed [get_cells [all_fanin -to $p -only_cells] -filter "(${inv_pttrn})"]
         if {[sizeof_coll $inv_in_scan_chain_to_be_removed] > 0 && [expr [sizeof_coll $inv_in_scan_chain_to_be_removed] % 2] != 0} {
            set inv_in_scan_chain_to_be_removed_name [get_attribute [get_cells $inv_in_scan_chain_to_be_removed] full_name]
            set dang_inv_nets ""
            foreach each_inv_in_scan_chain_to_be_removed_name "$inv_in_scan_chain_to_be_removed_name" {
               set each_inv_in_scan_chain_to_be_removed [get_cells $each_inv_in_scan_chain_to_be_removed_name]
               set out_net [get_nets -of [get_pins -of $each_inv_in_scan_chain_to_be_removed -filter "pin_direction == out"]] 
               set in_net [get_nets -of [get_pins -of $each_inv_in_scan_chain_to_be_removed -filter "pin_direction == in"]]
               append_to_collection dang_inv_nets [get_nets $out_net]
               if {[sizeof_coll [get_ports -of [get_nets $out_net]]] > 0} {
                  disconnect_net [get_nets $out_net] [get_ports $p]
                  connect_net [get_nets $in_net] [get_ports $p] 
                  
               } else {
                  set pin_of_out_net [remove_from_collection [get_pins -of [get_nets $out_net]] [get_pins -of $each_inv_in_scan_chain_to_be_removed -filter "pin_direction == out"]]
                  disconnect_net [get_nets $out_net] [get_pins $pin_of_out_net]
                  connect_net [get_nets $in_net] [get_pins $pin_of_out_net]

               }
               ::rdt::print_info "Removing the inverter [get_attribute $each_inv_in_scan_chain_to_be_removed full_name] connected to [get_attribute [get_ports $p] full_name] pin since it is causing scan chain polarity change"
               remove_cell $each_inv_in_scan_chain_to_be_removed 
            }
            set rm_dang_inv_nets ""
            foreach_in_collection net [get_nets $dang_inv_nets] {   
               if {[sizeof_coll [get_pins -of $net]] == 0} {
                  append_to_coll rm_dang_inv_nets [get_nets $net]
               }
            }
            if {[sizeof_coll $rm_dang_inv_nets]} {
               remove_net $rm_dang_inv_nets
            }
         }
      }
      append_to_collection so_buf [insert_buffer -new_net_names "n_${scan_block}_dft_so_isolate_${i}_buf" -new_cell_names "${scan_block}_dft_so_isolate_${i}_buf_dcszo" $p [getvar G_BUF_MASTER] ]
      incr i
   }
   if {[sizeof_collection $so_buf]} {
      set_size_only $so_buf true
   }
}


proc syn_dft_list_to_filter_pattern { attr op elems } {
   set retVal ""
   foreach pat $elems {
      set retVal "$retVal $op ${attr} =~ $pat"
   }
   set retVal [regsub " $op " $retVal ""]

   return $retVal
}


proc syn_dft_clone_lcb_helper {hier lcb_obj dmimic_equivalent src_net} {

   #helper variables
   global _dmimic_flop_reconnect_count
   global _dmimic_flop_reconnect_cells
   global _lcb_clone_cell_array
   global _lcb_mark_for_deletion

   #Create the list of dmimic patterns
   set dmimic_cell_patterns [syn_dft_list_to_filter_pattern @ref_name or [getvar G_DMIMIC_CELL_PATTERNS]]

   #Figure out the lcb obj name
   set lcb_obj_name [get_object_name $lcb_obj]
   set lcb_obj_ref_name [string range [get_attribute $lcb_obj ref_name] 0 7]

   #Figure out the lcb out net
   set lcb_out_net [get_nets -quiet -of [get_pins -of $lcb_obj -filter "pin_direction == out"]]
   set lcb_out_net_name [get_object_name $lcb_out_net]
   
   set dmimic_lcb_out_net ""

   #Check if there are dmimic cells in this LCB.
   #If there are dmimic cells then clone or else don't
   set lcb_not_cloned 1
   set dmimic_cells [filter_collection [all_fanout -only_cells -endpoints_only -from [get_pins -of $lcb_obj -filter "pin_direction == out"]] $dmimic_cell_patterns]

   rdt_print_info "Number of dmimic cells under LCB: $lcb_obj_name is [sizeof $dmimic_cells]"
   if {[sizeof $dmimic_cells] == 0} {
      rdt_print_info "No need to clone"
      set lcb_not_cloned 1
      #return
   } else {

      rdt_print_info "Cloning LCB $lcb_obj_name"
      set lcb_lib_name [lindex [split [get_attribute [get_lib_cells -of [get_cells $lcb_obj]] full_name] "/"] 0]
      set lcb_not_cloned 0

      set dmimic_lcb_obj_name "${lcb_obj_name}_dmimic"
      if {$dmimic_equivalent} {
         set dmimic_lcb_obj_ref_name "[getvar G_DMIMIC_LCB_MAP($lcb_obj_ref_name)]"
      } else {
         set dmimic_lcb_obj_ref_name [get_attribute $lcb_obj ref_name]
      }
      rdt_print_info "Creating LCB dmimic clone: $dmimic_lcb_obj_name $dmimic_lcb_obj_ref_name"
      create_cell $dmimic_lcb_obj_name [get_lib_cell $lcb_lib_name/$dmimic_lcb_obj_ref_name]
      set dmimic_lcb_obj [get_cells $dmimic_lcb_obj_name]
      
      set _lcb_clone_cell_array("${hier}$lcb_obj_name") "${hier}$dmimic_lcb_obj_name"

      #create the new net
      set dmimic_lcb_out_net_name "${lcb_out_net_name}_dmimic"
      create_net $dmimic_lcb_out_net_name
      set dmimic_lcb_out_net [get_nets $dmimic_lcb_out_net_name]

      #Iterate through all the input pins of original cell and connect it to the new cell
      foreach_in_collection lcb_obj_pin [get_pins -of $lcb_obj -filter "pin_direction == in"] {
         set lcb_obj_pin_name [get_attribute $lcb_obj_pin name]
         if {$dmimic_equivalent} {
            set dmimc_lcb_obj_pin_name [getvar G_DMIMIC_LCB_PIN_MAP($lcb_obj_ref_name,$lcb_obj_pin_name)]
         } else {
            set dmimc_lcb_obj_pin_name $lcb_obj_pin_name
         }
         connect_net [get_nets -of $lcb_obj_pin] [get_pins -of $dmimic_lcb_obj -filter "name == $dmimc_lcb_obj_pin_name"]

      }

      #create and connect the dmimic bclk
      if {$dmimic_equivalent} {
         if {[sizeof [get_nets iscan_dmimic_bclk]] == 0} {
            create_net iscan_dmimic_bclk
            connect_net [get_nets iscan_dmimic_bclk] [get_pins [getvar G_DMIMIC_BCLK_SOURCE]]
         }
         connect_net [get_nets iscan_dmimic_bclk] [get_pins -of $dmimic_lcb_obj -filter "name == [getvar G_DMIMIC_LCB_PIN_MAP($lcb_obj_ref_name,clkb)]"]
      } elseif {[string first "bfc" $lcb_obj_ref_name] > -1} {
         disconnect_net [get_nets -of [get_pins -of $dmimic_lcb_obj -filter "pin_direction == in"]] [get_pins -of $dmimic_lcb_obj -filter "pin_direction == in"]
         connect_net $src_net [get_pins -of $dmimic_lcb_obj -filter "pin_direction == in"]
      } else {
         rdt_print_warn "LCB Clone: I don't think this should happen"
      }

      #connect the new net to the dmimic lcb
      connect_net $dmimic_lcb_out_net [get_pins -of $dmimic_lcb_obj -filter "pin_direction == out"]
      
   }
   
   #Create the switch command that will be used in the foreach loop
   set dmimic_cell_patterns ""
   foreach pat [getvar G_DMIMIC_CELL_PATTERNS] {
      set dmimic_cell_patterns "$dmimic_cell_patterns - $pat"
   }
   set dmimic_cell_patterns [regsub " - " $dmimic_cell_patterns ""]

   set switch_cmd "
    switch -glob \$load_cell_ref_name {
        *bfc* {
            syn_dft_clone_lcb_helper \$hier \[get_cells -of \$load_pin\] $lcb_not_cloned \$dmimic_lcb_out_net
        }
        $dmimic_cell_patterns {
            incr _dmimic_flop_reconnect_count
            set _dmimic_flop_reconnect_cells \[add_to_coll \$_dmimic_flop_reconnect_cells \$load_cell \]
            disconnect_net \$lcb_out_net \$load_pin
            connect_net \$dmimic_lcb_out_net \$load_pin
        }
        default { continue }
    }"

   #Iterate through all cells connected directly to this cell
   foreach_in_collection load_pin [get_pins -of $lcb_out_net -filter "pin_direction == in"] {
      set load_cell [get_cells -of $load_pin]
      set load_cell_ref_name [get_attribute $load_cell ref_name]
      
      #puts "$switch_cmd"
      eval $switch_cmd
   }
   
   #Check the load on the lcb, if zero remove both lcb and net
   set lcb_load_pins [get_pins -of $lcb_out_net]
   puts "Pin load on $lcb_obj_name: [sizeof $lcb_load_pins]"
   foreach lcb_load_pin [get_object_name $lcb_load_pins] {
      set lcb_load_cell [get_object_name [get_cells -of [get_pins $lcb_load_pin]]]
      if {[lsearch -exact $_lcb_mark_for_deletion "${hier}${lcb_load_cell}"] != -1} {
         set lcb_load_pins [remove_from_collection $lcb_load_pins [get_pins $lcb_load_pin]]
      }
   }
   puts "Pin load on $lcb_obj_name after filtering to be deleted cells is: [sizeof $lcb_load_pins]"
   if {[sizeof $lcb_load_pins] <= 1} {
      rdt_print_info "marking lcb: $lcb_obj_name for deletion and removing net: $lcb_out_net_name"
      if {[sizeof $lcb_out_net] > 0} {remove_net $lcb_out_net}
      lappend _lcb_mark_for_deletion "${hier}$lcb_obj_name"
      #remove_cell $lcb_obj
   }
   
   rdt_print_info "Done with cloning LCB $lcb_obj_name"

}


proc syn_dft_clone_lcb {} {

   ### Declare all G_* variables as global

   if { [getvar G_SCAN_ENABLE_DMIMIC] ne 1} {
      #nothing to do
      return
   }

   #variables shared by the helper
   global _dmimic_flop_reconnect_count
   global _dmimic_flop_reconnect_cells
   global _lcb_clone_cell_array
   global _lcb_mark_for_deletion


   unset -nocomplain _lcb_clone_cell_array
   array set _lcb_clone_cell_array {}
   set _lcb_mark_for_deletion ""

   set scan_block_list [syn_dft_get_scan_blocks]

   unset -nocomplain scan_block_array
   array set scan_block_array {}
   foreach scan_block $scan_block_list {
      set scan_block_array($scan_block) [get_attribute [get_cells -hier -quiet -filter "ref_name == $scan_block"] full_name]
   }

   foreach scan_block $scan_block_list {

      rdt_print_info "Cloning LCB for design $scan_block"

      if { [sizeof_collection [get_designs -quiet $scan_block]]} {
	  current_design $scan_block
      } else {
	  rdt_print_error "$scan_block does not exist in design"
      }	  

      #Find the total number of dmimic flops in the design    
      set dmimic_cell_patterns [syn_dft_list_to_filter_pattern @ref_name or [getvar G_DMIMIC_CELL_PATTERNS]]

      set dmimic_flop_count [sizeof [get_cells -filter $dmimic_cell_patterns]]

      rdt_print_info "Total number of dmimic flops: $dmimic_flop_count"

      #Clone the LCB for dmimic b-clk connection
      # Figure out the block clock inputs
      set input_clk ""
      foreach pin [getvar G_DFX_HANDLER_CLOCK2FLOP_PINS] {
         set input_clk "$input_clk [syn_dft_get_pin_core $pin]"
      }

      # Figure out the block RCBs
      set rcb_output_pins ""
      foreach pin $input_clk {
         set rcb_output_pins "$rcb_output_pins [get_object_name [get_pins -of [filter_collection [all_fanout -from $pin -only] [syn_dft_list_to_filter_pattern @ref_name or [getvar G_RCB_PATTERN]]] -filter {pin_direction == out}]]"
      }

      # Fugure out block first level LCBs
      set lcb_coll ""
      foreach rcb_output_pin $rcb_output_pins {
         # TODO: ?????c* hardcoded cell naming
         set lcb_coll [add_to_collection -unique $lcb_coll [filter_collection [all_fanout -only_cells -levels 1 -endpoints_only -from $rcb_output_pin] "ref_name =~ ?????c*"]]
      }

      set _dmimic_flop_reconnect_count 0
      set _dmimic_flop_reconnect_cells ""

      set hier "$scan_block_array($scan_block)/"
      foreach_in_collection lcb $lcb_coll {
         syn_dft_clone_lcb_helper $hier $lcb 1 ""
      }

      rdt_print_info "Number of dmimics that were reconnected: $_dmimic_flop_reconnect_count"

      if {$dmimic_flop_count != $_dmimic_flop_reconnect_count} {
         set dmimic_not_reconnected_cells [remove_from_coll [get_cells -filter $dmimic_cell_patterns] $_dmimic_flop_reconnect_cells]
         rdt_print_error "All dmimic flops have not been re-connected: $scan_block\n\Number of dmimic flops in design: $dmimic_flop_count\n\Number of dmimic flops reconnected: $_dmimic_flop_reconnect_count\n\Number of dmimic flops not reconnected: [sizeof $dmimic_not_reconnected_cells]\n\Dmimic flops not reconnected: [get_object_name $dmimic_not_reconnected_cells]"
      }

   }

   current_design [getvar G_DESIGN_NAME]

   foreach key [array names _lcb_clone_cell_array] {
      set lcb_obj [get_cells $key]
      set dmimic_lcb_obj [get_cells $_lcb_clone_cell_array($key)]
      set x_loc [get_attribute $lcb_obj mpc_loc_x]
      set y_loc [get_attribute $lcb_obj mpc_loc_y]
      if { $x_loc == "" || $y_loc == "" } {
         rdt_print_warn "Cell location not found for LCB: $key"
      } else {
         set_cell_location -coordinates [list [expr $x_loc/1000] [expr $y_loc/1000]] $dmimic_lcb_obj
      }
   }

   # Deleting cells marked for deletion
   rdt_print_info "Deleting cells marked for deletion"
   remove_cell [get_cells $_lcb_mark_for_deletion]

   #restamping clock network
   rdt_print_info "Restamping clock network as dmimic clocks clones where introduced."
   rdt_source_if_exists stamp_clocks.tcl
   stamp_clock_network -sdc_file [getvar G_OUTPUTS_DIR]/[getvar {G_DESIGN_NAME}].stamp_clock_network.sdc
   source [getvar G_OUTPUTS_DIR]/[getvar {G_DESIGN_NAME}].stamp_clock_network.sdc

   update_timing

   unset -nocomplain _dmimic_flop_reconnect_count
   unset -nocomplain _dmimic_flop_reconnect_cells
   unset -nocomplain _lcb_clone_cell_array
   unset -nocomplain _lcb_mark_for_deletion

}



proc syn_insert_dft_core {args} {
   global env
   global search_path

   if {[info exists env(WARD)] && $env(WARD) ne "" && [lsearch -exact $search_path $env(WARD)/collateral/dft] == "-1"} {
       rdt_print_info "Adding $env(WARD)/collateral/dft to search_path"
       lappend search_path $env(WARD)/collateral/dft
       lappend_var G_SCRIPTS_SEARCH_PATH $env(WARD)/collateral/dft
   }

   if { [getvar -quiet G_INSERT_SCAN] == 0 } {
       rdt_print_info "Skipping insert_dft stage as  G_INSERT_SCAN is set to 0"
       return

   }

   #MCORE
   #rdt_print_info "Explicitly run syn_clock_gating to apply clock-gating attribute when loading in ddc."
   #rdt_print_info "This is because ddc does not store clock-gating attribute"
   #syn_clock_gating

   #MCORE
   #rdt_print_info "Explicitly attaching all ctl model for sync cells to allow sync cells on scan-chains"
   #syn_read_ctl_model



   # Initialize variables
   global dfx_handler_inst ""

   set exclude_inst_list ""

   set top [current_design_name]
   if {$top ne [getvar G_DESIGN_NAME]} {
      rdt_print_error "Current design $top is not [getvar G_DESIGN_NAME]"
      return
   }

   #################################################################################################
   # Remove dont_touch on lower units so insert-DFT can modify (i.e. scan-stitch) inside unit level.
   rdt_print_info "Removing dont-touch from all designs in the unit before inserting scan-chain"

   set dont_touch_design_list [get_designs * -filter "@dont_touch == true"]
   set dont_touch_instance_list [get_cells -hier * -filter "@dont_touch == true && @is_hierarchical==true"]

   if { [sizeof_collection $dont_touch_design_list] > 0 } {
      remove_attribute -quiet $dont_touch_design_list dont_touch
   }
   if { [sizeof_collection $dont_touch_instance_list] > 0 } {
      remove_attribute -quiet $dont_touch_instance_list dont_touch
   }
   
   #################################################################################################
   # enable constant flops to be part of the scan-chains
   
   if { [getvar G_DFX_ALLOW_CONSTANT_FLOPS_ON_CHAIN] == 1 } {
   
      rdt_print_info "Enable constant flops to be part of scan-chains."
      set_dft_drc_rules -warning {TEST-504} 
      set_dft_drc_rules -warning {TEST-505} 

   }
   
   # Collecting non-scan designs
   if { [getvar -quiet G_DFX_NONSCAN_DESIGNS] != "" } {
      foreach design [getvar G_DFX_NONSCAN_DESIGNS] {
         set design_list [get_designs -quiet $design]
         if { [sizeof_collection $design_list] == 1 } {
            lappend exclude_inst_list [get_object_name [get_cells -hier * -filter "ref_name =~ $design"]]

         } elseif { [sizeof_collection $design_list] > 1 } {
            foreach_in_collection subdesign $design_list {            
               set des_name [get_object_name $subdesign]
               lappend exclude_inst_list [get_object_name [get_cells -hier * -filter "ref_name =~ $des_name"]]
            }
         }
      }
   }

   if { [getvar -quiet G_DFX_NONSCAN_INSTANCES] != "" } {

      foreach inst [getvar G_DFX_NONSCAN_INSTANCES] {
         set nonscan_reg [filter_collection [all_registers -edge] "full_name =~ $inst && is_hierarchical == false"]
         if { [sizeof_collection $nonscan_reg] > 0 } {
            foreach_in_collection reg $nonscan_reg {
               lappend exclude_inst_list [get_object_name $reg]
            }
         }
      }
   }

   
   
   # exclude non-scan design instances. prevent scanenable signal hooking up to flops' ss pin in non-scan design
   if { $exclude_inst_list != "" } {
      rdt_print_info "Setting set_scan_configuration -exclude on $exclude_inst_list"
      set_scan_configuration -exclude  $exclude_inst_list 
   }
   if {[getvar -quiet G_VECTOR_FLOP] == "1"} {
      set_scan_configuration -preserve_multibit_segment false
   }

   if {[getvar -quiet G_SCAN_ENABLE_DMIMIC] == 1} {
      file delete -force  [getvar {G_REPORTS_DIR}]/[getvar {G_DESIGN_NAME}].scan_clk.rename.txt
   }


   set dft_config_gen_failed 0
   foreach scan_block [syn_dft_get_scan_blocks] {

      rdt_print_info "Scan Stitching design $scan_block"

      if {$scan_block ne [current_design_name]} {
         current_design $scan_block
      }

      #Change all the rcb sizes to a single drive strength so that we can attach a simulation model to it.
      if {[getvar -quiet G_SCAN_ENABLE_DMIMIC] == 1} {
         set org_hdlin_presto_net_name_prefix $::hdlin_presto_net_name_prefix
         set ::hdlin_presto_net_name_prefix "iscan_net_"
         foreach key [getvar -names G_DMIMIC_RCB_DEF_DRV_MAP] {
            set dmimic_rcb_ref_name [get_attribute [index_collection [get_lib_cell */[getvar G_DMIMIC_RCB_DEF_DRV_MAP($key)]] 0] name]
            foreach_in_collection dmimic_rcb_cell_name [get_cells -filter "ref_name =~ ${key}*"] { 
               set dmimic_rcb_lib_name [lindex [split [get_attribute [get_lib_cells -of [get_cells $dmimic_rcb_cell_name]] full_name] "/"] 0]
               rdt_print_info "Sizing rcb [get_attribute [get_cells $dmimic_rcb_cell_name] full_name] from [get_attribute [get_cells $dmimic_rcb_cell_name] ref_name] to ${dmimic_rcb_ref_name}"
               size_cell [get_cells $dmimic_rcb_cell_name] [get_lib_cells ${dmimic_rcb_lib_name}/${dmimic_rcb_ref_name}]
            }
         }
      }

      ##############################################################################
      # sourcing in user's configuration custom file if exists
      set config_file [rdt_source_if_exists -display ${scan_block}.insert_dft.scan_config.tcl]
      if { [file exists $config_file] } {

         rdt_print_info "Sourcing existing user's scan configuration file '$config_file'"
         source $config_file
   
      } else {
         # Attempt to extract DFX Specification from design (based on VLV DFX architecture)
            
          if {[syn_dft_config_generation_core $scan_block $exclude_inst_list] == 0} {
              set dft_config_gen_failed 1
              break
          }
      }


      #############################################################################
      # DFT Scan Chain Insertion
      #############################################################################
      rdt_print_info "Generating scan related reports for $scan_block prior running scan-insertion"
      preview_dft -show all -verbose > [getvar {G_REPORTS_DIR}]/${scan_block}.insert_dft.preview_dft
      dft_drc -verbose > [getvar {G_REPORTS_DIR}]/${scan_block}.insert_dft.dft_drc

      if { [getvar -quiet G_STOP_AFTER_PRE_DFT_FOR_DEBUG] == 1 } {
         print_fatal "Returning to tool prompt for DFT_DRC debug as G_STOP_AFTER_PRE_DFT_FOR_DEBUG is set to 1"
      } 
   
      rdt_print_info "Starting scan-chain insertion through insert_dft....."
      insert_dft

      if {[getvar -quiet G_SCAN_ENABLE_DMIMIC] == 1} {
         redirect -append -file [getvar {G_REPORTS_DIR}]/[getvar {G_DESIGN_NAME}].scan_clk.rename.txt {
            if { [sizeof [get_pins [getvar G_DFX_HANDLER_ACLOCK2FLOP_PINS]]] == 1 } {
               set clk_net [get_nets -of [get_pins [getvar G_DFX_HANDLER_ACLOCK2FLOP_PINS]]]
               if {[sizeof $clk_net] > 0} { puts "$scan_block net [get_attribute $clk_net name] aclk" }
            }

            if { [sizeof [get_pins [getvar G_DFX_HANDLER_BCLOCK2FLOP_PINS]]] == 1 } {
               set clk_net [get_nets -of [get_pins [getvar G_DFX_HANDLER_BCLOCK2FLOP_PINS]]]
               if {[sizeof $clk_net] > 0} { puts "$scan_block net [get_attribute $clk_net name] bclk" }
            }
         }
      }
      syn_dft_buffer_scan_ports $scan_block

      if {[info exists org_hdlin_presto_net_name_prefix]} {
         set ::hdlin_presto_net_name_prefix $org_hdlin_presto_net_name_prefix
         unset org_hdlin_presto_net_name_prefix
      }
      
   }


   current_design [getvar G_DESIGN_NAME]


   if {[getvar -quiet G_DFX_SUB_BLOCK_METHOD] == 1 && !$dft_config_gen_failed} {
      rdt_print_info "Generating [getvar G_OUTPUTS_DIR]/[getvar {G_DESIGN_NAME}].scandef file from sub-blocks"
      set scan_block_list [syn_dft_get_scan_blocks]
      syn_dft_combined_sub_block_scandef_generation $scan_block_list
      check_scan_def -file [getvar G_OUTPUTS_DIR]/[getvar {G_DESIGN_NAME}].scandef
      read_scan_def [getvar G_OUTPUTS_DIR]/[getvar {G_DESIGN_NAME}].scandef
   }

   
   if {[getvar -quiet G_SCAN_ENABLE_DMIMIC] == 1} {

      change_names -names_file [getvar {G_REPORTS_DIR}]/[getvar {G_DESIGN_NAME}].scan_clk.rename.txt -verbose -hier

      # Set ideal network on nets connected to se pin
      set_ideal_network [get_nets -of [get_pins -hier -quiet */[getvar G_DMIMIC_CELL_SE_PIN]]]
   }

   rdt_print_info "Setting back 'dont_touch' attribute to designs which already have 'dont_touch' attribute prior to insert_dft stage"
   if { [sizeof_collection $dont_touch_design_list] > 0 } {
      set_attribute $dont_touch_design_list dont_touch true
   }
   if { [sizeof_collection $dont_touch_instance_list] > 0 } {
      set_attribute $dont_touch_instance_list dont_touch true
   }
   
   #MCORE
   # Reporting out all flops not being used as part of the chain
   #syn_report_nonscan_flops


}


##################################################################################
# Procedure : syn_dft_generate_pgcb_dfx_constraints
# Details   : Generate PGCB DFX constraints for sleep, isolation signal overrides 
# Inputs    : Following variables need to be defined by the project (below example from BXT)
# set G_DFX_PGCB_UNIT                    "pgcbunit"
# set G_DFX_PGCB_OVR_CELL                "dfxval_*_b_reg"
# set G_DFX_PGCB_CONSTANT_LOW            "fdfx_pgcb_ovr \
# set G_DFX_PGCB_CONSTANT_HIGH           "fdfx_pgcb_bypass"
# set G_DFX_PGCB_TEST_MODE               "fscan_mode"
# set G_DFX_PGCB_OVR_UNIT                "pgcbdfxovr"
# set G_DFX_PGCB_OVR_CONSTANT_HIGH       "dfxovr_isol_en_b"
# set G_DFX_PGCB_OVR_CONSTANT_LOW        "dfxovr_sleep"
# set G_DFX_PGCB_OVR_SLEEP_REG_CONSTANT_LOW             "dfxval_sleep_reg"
# scan configuration file pointer
# Outputs   : Generates DFX overrides for pgcb modules/signals
###################################################################################

proc syn_dft_generate_pgcb_dfx_constraints { args } {  
 
    set scan_cfg_fp  [lindex $args 0]
    
    # DFX constraints on PGCB unit 
    if {[getvar -quiet G_DFX_PGCB_UNIT] eq "" } {
        rdt_print_warn "G_DFX_PGCB_UNIT is not defined, dfx constraints for PGCB signals are not generated"
    } else {
        rdt_print_info "Generating DFX constraints for PGCB signals"
        foreach pgcb_name [getvar G_DFX_PGCB_UNIT] {
            set pgcb_cells [get_cells -quiet -hierarchical -filter ref_name=~*${pgcb_name}*]
            if {[sizeof_collection $pgcb_cells] == 0} {
                rdt_print_warn "Nothing matched pattern *${pgcb_name}*"
            } else {
               foreach_in_collection cell $pgcb_cells {
                   set cell_name [get_object_name $cell]
                   rdt_print_info "Applying PGCB DFT overrides on PGCB unit $cell_name"
                   if {[getvar -quiet G_DFX_PGCB_TEST_MODE] ne ""} {
                       foreach pgcb_tp [getvar G_DFX_PGCB_TEST_MODE] {
                           if {[sizeof_collection [get_pins -quiet ${cell_name}/${pgcb_tp}]] ==1} {
                               puts $scan_cfg_fp "set_dft_signal -view existing_dft -type TestMode -active_state 1 -hookup_pin \[get_pins ${cell_name}/${pgcb_tp}\]"
                           } else {
                               rdt_print_warn "${cell_name}/${pgcb_tp} does not exist, not generating DFT constraints for this pin"
                           } 
                       }
                   } else {
                       rdt_print_warn "G_DFX_PGCB_TEST_MODE is either not defined/empty, not generating related DFX constraints"
                   }
                   if {[getvar -quiet G_DFX_PGCB_CONSTANT_HIGH] ne "" } {
                       foreach pgcb_high [getvar G_DFX_PGCB_CONSTANT_HIGH] {
                           if {[sizeof_collection [get_pins ${cell_name}/${pgcb_high}]] ==1} { 
                               puts $scan_cfg_fp "set_dft_signal -view existing_dft -type Constant -active_state 1 -hookup_pin \[get_pins ${cell_name}/${pgcb_high}\]"
                           } else {
                               rdt_print_warn "${cell_name}/${pgcb_high} does not exist, not generating DFT constraints for this pin"
                           } 
                       }
                   } else {
                       rdt_print_warn "G_DFX_PGCB_CONSTANT_HIGH is either not defined/empty, not generating related DFX constraints"
                   }
                   if {[getvar -quiet G_DFX_PGCB_CONSTANT_LOW] ne ""} {
                        foreach pgcb_low [getvar G_DFX_PGCB_CONSTANT_LOW] {
                            if {[sizeof_collection [get_pins ${cell_name}/${pgcb_low}]] ==1} {
                                puts $scan_cfg_fp "set_dft_signal -view existing_dft -type Constant -active_state 0 -hookup_pin \[get_pins ${cell_name}/${pgcb_low}\]"
                            } else {
                               rdt_print_warn "${cell_name}/${pgcb_low} does not exist, not generating DFT constraints for this pin"
                            }
                        }
                   } else {
                       rdt_print_warn "G_DFX_PGCB_CONSTANT_LOW is either not defined/empty, not generating related DFX constraints"
                   }    
                }
            }
        }
    }
  
    # DFX constraints on PGCB_OVR_CELL 
    if {[getvar -quiet G_DFX_PGCB_OVR_CELL] ne ""} { 
        set pgcb_ovr_hier_name [getvar G_DFX_PGCB_OVR_CELL]
        set v_pgcb_ovr_b_col [filter_collection [get_pins -of_objects [get_cells -hierarchical $pgcb_ovr_hier_name]] "pin_direction == out" ]
        if {[sizeof_collection $v_pgcb_ovr_b_col] >= 1} {
            foreach_in_collection v_pgcb_ovr_b $v_pgcb_ovr_b_col {
                set v_pgcb_ovr_b_name [get_object_name $v_pgcb_ovr_b]
                set v_pgcb_ovr_b_cell_name [get_object_name [get_cells -of_objects $v_pgcb_ovr_b]]
                if {[lsearch -exact [getvar -quiet G_DFX_PGCB_OVR_CELL_IGNORE] $v_pgcb_ovr_b_cell_name] >= 0} { continue }
                rdt_print_info "Applying PGCB DFT overrides on DFXVAL register output $v_pgcb_ovr_b_name"
                puts  $scan_cfg_fp "set_dft_signal -view existing_dft -hookup_pin \[get_pins $v_pgcb_ovr_b_name \] -type TestMode -active_state 1"
            }
        }
    }  

    # DFX constraints on PGCB_OVR_UNIT
    if {[getvar -quiet G_DFX_PGCB_OVR_UNIT] eq "" } {
        rdt_print_warn "G_DFX_PGCB_OVR_UNIT is not defined, dfx constraints for PGCB OVR signals are not generated"
    } else {
        rdt_print_info "Generating DFX constraints for PGCB OVR signals"
        foreach pgcb_ovr_unit [getvar G_DFX_PGCB_OVR_UNIT] {
            set pgcb_ovr_cells [get_cells -quiet -hierarchical -filter ref_name=~*$pgcb_ovr_unit*] 
            if {[sizeof_collection $pgcb_ovr_cells] == 0} {
                rdt_print_warn "Nothing matched pattern *$pgcb_ovr_unit*"
            } else {
                foreach_in_collection cell $pgcb_ovr_cells {
                    set cell_name [get_object_name $cell]
                    rdt_print_info "Applying PGCB DFT overrides on PGCB OVR unit $cell_name"
                    if {[getvar -quiet G_DFX_PGCB_OVR_CONSTANT_HIGH] ne ""} {
                        foreach pgcb_high [getvar G_DFX_PGCB_OVR_CONSTANT_HIGH] {
                            if {[sizeof_collection [get_pins -quiet ${cell_name}/${pgcb_high}]] == 1} {
                                puts $scan_cfg_fp "set_dft_signal -view existing_dft -type Constant -active_state 1 -hookup_pin \[get_pins ${cell_name}/${pgcb_high}\]"
                            } else {
                                rdt_print_warn "${cell_name}/${pgcb_high} does not exist, not generating related DFX constraints on this pin"   
                            }
                        }
                    } else {
                        rdt_print_warn "G_DFX_PGCB_OVR_CONSTANT_HIGH is either not defined/empty, not generating related DFX constraints"
                    }
                    if {[getvar -quiet G_DFX_PGCB_OVR_CONSTANT_LOW] ne "" } {
                        foreach pgcb_low [getvar G_DFX_PGCB_OVR_CONSTANT_LOW] {    
                            if {[sizeof_collection [get_pins ${cell_name}/${pgcb_low}]] == 1} {
                                puts $scan_cfg_fp "set_dft_signal -view existing_dft -type Constant -active_state 0 -hookup_pin \[get_pins ${cell_name}/${pgcb_low}\]"
                            } else {
                                rdt_print_warn "${cell_name}/${pgcb_low} does not exist, not generating related DFX constraints on this pin"
                            }  
                        }
                    } else {
                        rdt_print_warn "G_DFX_PGCB_OVR_CONSTANT_LOW is either not defined/empty, not generating related DFXints on this pin"
                    }
                    if {[getvar -quiet G_DFX_PGCB_OVR_SLEEP_REG_CONSTANT_LOW] ne ""} {
                        set pgcb_sleep_reg_o [filter_collection [get_pins -of_objects [get_cells -quiet  ${cell_name}/[getvar G_DFX_PGCB_OVR_SLEEP_REG_CONSTANT_LOW]]] "pin_direction == out" ]
                        if {[sizeof_collection $pgcb_sleep_reg_o] == 1} {
                            set pgcb_sleep_reg_o_name [get_object_name $pgcb_sleep_reg_o]
                            set pgcb_sleep_reg_cell_name [get_object_name [get_cells -of_objects $pgcb_sleep_reg_o]]
                            if {[lsearch -exact [getvar -quiet G_DFX_PGCB_OVR_CELL_IGNORE] $pgcb_sleep_reg_cell_name] >= 0} { continue }
                            rdt_print_info "Applying PGCB DFT overrides on DFXVAL SLEEP register output $pgcb_sleep_reg_o_name"
                            puts $scan_cfg_fp "set_dft_signal -view existing_dft -hookup_pin \[get_pins $pgcb_sleep_reg_o_name \] -type Constant -active_state 0"
                        } else {
                            rdt_print_warn "${cell_name}/[getvar G_DFX_PGCB_OVR_SLEEP_REG_CONSTANT_LOW] does not exist, not generating DFX constraints on this pin"
                        }
                    } else {
                        rdt_print_warn "G_DFX_PGCB_OVR_SLEEP_REG_CONSTANT_LOW is either not defined/empty, not generating related DFX constraints"
                    }
                }
            }
        }
    }
}
 
####################################################################
# Proc: syn_dft_generate_pre_dft_reports
# Description: Generate pre_dft reports 
# Input: 
####################################################################
proc syn_dft_generate_pre_dft_reports {{trimmed_stage_name default}} {
   
    foreach report [getvar -quiet G_SYN_REPORTS(pre_dft)] { 
        switch -exact -- $report {
            dft_drc {
                if { [info procs syn_read_ctl_model] != "" } {
                    rdt_print_info "Attaching CTL models for sync. cells"
                    syn_read_ctl_model
                } else {
                    rdt_print_warn "Cannot find proc syn_read_ctl_model to attach the CTL model for sync cells. dft_drc might have S1 blockages on sync cells"
                }
                set cmd "dft_drc -verbose > [getvar G_REPORTS_DIR]/[getvar G_DESIGN_NAME].${trimmed_stage_name}.pre_dft_drc"
                rdt_print_info "Writing report $cmd"
                eval $cmd
                if {[getvar -quiet STRICT_CHECK_DFT_DRC] == 1} { 
                    rdt_print_info "Checking for errors in dft_drc report ... set STRICT_CHECK_DFT_DRC to 0 to skip the check"
                    if {[file::grep [getvar CHECK_TEST_PATTERNS] [getvar G_REPORTS_DIR]/[getvar G_DESIGN_NAME].${trimmed_stage_name}.pre_dft_drc] != ""} {
                       rdt_print_warn "DRC report has FATAL failure. Fix the DRCs reported in [getvar G_REPORTS_DIR]/[getvar G_DESIGN_NAME].${trimmed_stage_name}.pre_dft_drc and re-run insert_dft"
                    }
                }
            }
            preview_dft {
               if {[getvar -quiet G_INSERT_SCAN] == "1"} {
                  set cmd "preview_dft -show all -verbose > [getvar G_REPORTS_DIR]/[getvar G_DESIGN_NAME].${trimmed_stage_name}.pre_dft_preview_dft"
                  rdt_print_info "Writing report $cmd"
                  eval $cmd
               } else {
                  rdt_print_info " G_INSERT_SCAN is not set or set to 0, not writing report for preview_dft command"
               }
            }
            scan_configuration {
               if {[getvar -quiet G_INSERT_SCAN] == "1"} {
                   set cmd "report_scan_configuration > [getvar G_REPORTS_DIR]/[getvar G_DESIGN_NAME].${trimmed_stage_name}.pre_scan_configuration"
                   rdt_print_info "Writing report $cmd"
                   eval $cmd
               }
            }
            dft_insertion_configuration {
               if {[getvar -quiet G_INSERT_SCAN] == "1"} {
                   set cmd "report_dft_insertion_configuration > [getvar G_REPORTS_DIR]/[getvar G_DESIGN_NAME].${trimmed_stage_name}.pre_dft_insertion_configuration"
                   rdt_print_info "Writing report $cmd"
                   eval $cmd
               }
            }
            existing_dft_signal {
                if {[getvar -quiet G_INSERT_SCAN] == "1"} {
                  set cmd "report_dft_signal -view existing_dft > [getvar G_REPORTS_DIR]/[getvar G_DESIGN_NAME].${trimmed_stage_name}.pre_dft_signal"
                  rdt_print_info "Writing report $cmd"
                  eval $cmd
               }
            }
            default {
               rdt_print_warn "Report '$report' not configured for pre_dft"
            }
        }
    }

}

##################################################################################################
# Procedure  : syn_insert_dft_high_speed
# Description: This is placeholder for insert_dft to meet high speed requirements for 10nm 
#              and above. Following featured will be added to the proc:
#              1) Border Sealing
#              2) SLOS
#              3) Segregated scan chain per DOP
#              4) Scan latches      
#              5) Different chain per:
#                 a) clock domain
#                 b) power domain
#                 c) negedge and posedge flops
#                 d) scan latches
#              6) New RTL non scan Macros
# Owner      : Co-developed by CNL-SDG-CDS
# -----------------------------------------------------------------------------------------------
# Revision updates:
# WW30.1 - Created placeholder for insert_dft high speed (vbharadw)
##################################################################################################
proc syn_insert_dft_high_speed {args} {
   global env
   global search_path
   global power_cg_auto_identify

   # Skip scan-insertion when G_INSERT_SCAN = 0
   if { [getvar -quiet G_INSERT_SCAN] == 0 } {
       rdt_print_info "Skipping insert_dft stage as  G_INSERT_SCAN is set to 0"
       return TCL_OK

   }

   if {[info exists env(WARD)] && $env(WARD) ne "" && [lsearch -exact $search_path $env(WARD)/collateral/dft] == "-1"} {
       rdt_print_info "Adding $env(WARD)/collateral/dft to search_path"
       lappend search_path $env(WARD)/collateral/dft
       lappend_var G_SCRIPTS_SEARCH_PATH $env(WARD)/collateral/dft
   }

   # Scan related collateral files
   set scan_coll_file_list [list override_setup scan_waivers]
   foreach sfile $scan_coll_file_list {
      set filename [getvar G_DESIGN_NAME]_${sfile}.tcl
      rdt_print_info "Sourcing scan collateral file: $filename"
      rdt_source_if_exists $filename
   }

   # Pseudo Clocks for glitchfree Mux Outputs
   set gMuxes [get_cells -quiet -hierarchical *glitchfree_mux*]
   if { [sizeof_collection $gMuxes] > 0 } {
      rdt_print_info "Defining pseudo clocks for DFT-C at the glitchfree mux outputs"
      foreach_in_collection m $gMuxes {
         set muxout [get_pins [get_attribute [get_pins [get_attribute $m full_name]/clk_out] full_name]]
         if { [sizeof_collection $muxout] > 0 } {
            rdt_print_info "set_dft_signal -view existing -type ScanClock -timing \[list 45 55\] -hookup_pin [get_object_name $muxout]"
            set_dft_signal -view existing -type ScanClock -timing [list 45 55] -hookup_pin $muxout
         }
      }
   }


   syn_dft_pre_setup

   syn_dft_hookup_icg_test_mode

   syn_dft_config_generation


   #################################################################################################
   # Remove dont_touch on lower units so insert-DFT can modify (i.e. scan-stitch) inside unit level.
   rdt_print_info "Removing dont-touch attribute from all units to enable scan-chain inserting within units"

   set dont_touch_design_list [get_designs * -filter "@dont_touch == true"]
   set dont_touch_instance_list [get_cells -hier * -filter "@dont_touch == true"]

   if { [sizeof_collection $dont_touch_design_list] > 0 } {
      remove_attribute -quiet $dont_touch_design_list dont_touch
   }
   if { [sizeof_collection $dont_touch_instance_list] > 0 } {
      remove_attribute -quiet $dont_touch_instance_list dont_touch
   }
   

   ########################################################################################
   # Reading scan configuration file setting

   set config_file [rdt_source_if_exists -display [getvar {G_DESIGN_NAME}]_scan_config.tcl]
   if { [file exists $config_file] } {
       rdt_print_info "Sourcing user's existing scan configuration file '$config_file'"
       source $config_file

   } elseif { [file exists ".[getvar {G_DESIGN_NAME}]_scan_config.tcl"] } {
       rdt_print_info "Sourcing auto-generated scan configuration file '.[getvar {G_DESIGN_NAME}]_scan_config.tcl'"
       source .[getvar {G_DESIGN_NAME}]_scan_config.tcl

       # copy snaphot of the auto-generated scan config to report area for review
       file copy -force .[getvar {G_DESIGN_NAME}]_scan_config.tcl ./reports/[getvar {G_DESIGN_NAME}].insert_dft.scan_config.rpt

   }

   set_app_var power_cg_auto_identify true
   syn_dft_exclude_hookup_icg_in_nonscan_domains

   # Apply Scan Spec 
   create_test_protocol
   
   
   rdt_print_info "Generating scan related reports prior running scan-insertion"
   #syn_reports pre_dft 
   # vbharadw: pre_dft is not a seperate stage. Renaming the reports to make it noble flow compliant: HSD#5515904
   syn_dft_generate_pre_dft_reports insert_dft 
   syn_outputs pre_dft 
  
   if { [getvar -quiet G_STOP_AFTER_PRE_DFT_FOR_DEBUG] == 1 } {
      print_fatal "Returning to tool prompt for DFT_DRC debug as G_STOP_AFTER_PRE_DFT_FOR_DEBUG is set to 1"
    } 
   
   rdt_print_info "Starting scan-chain insertion through insert_dft....."
   insert_dft
   

   rdt_print_info "Setting back 'dont_touch' attribute to designs which already have 'dont_touch' attribute prior to insert_dft stage"
   if { [sizeof_collection $dont_touch_design_list] != 0 } {
      set_attribute [join $dont_touch_design_list] dont_touch true
   }
   if { [sizeof_collection $dont_touch_instance_list] != 0 } {
      set_attribute [join $dont_touch_instance_list] dont_touch true
   }
   
   # setting ideal network on scan-related signals to prevent buffer insertion 
   syn_dft_disable_scan_drc
   

   if { [getvar -quiet G_DFX_FIX_ICG_HOOKUP] == 1 } {
      rdt_print_info "Fixing icg/te hooking up to port 'test_cgtm'"
      syn_dft_fix_icg_hookup
      
   }

   #Fix isolation startegy post scan stitching
   fix_iso_strategy_for_scan

}

