################################################################################
#  Intel Top Secret
################################################################################
#  Copyright (C) 2009, Intel Corporation.  All rights reserved.
#
#  This is the property of Intel Corporation and may only be utilized
#  pursuant to a written Restricted Use Nondisclosure Agreement
#  with Intel Corporation.  It may not be used, reproduced, or
#  disclosed to others except in accordance with the terms and 
#  conditions of such agreement.
################################################################################
# Script: reports_utils.tcl
#
# Description: This file contains report related procedures which are commom 
#              to syn and apr flows.
#
################################################################################
# Script generates qor reports for ICC mw cel.

######
################################################################################


proc rdt_get_percent_cell_net_delay {args} {
    parse_proc_arguments -args $args results
    set total_cell_delay 0
    set total_net_delay 0
    set got_net 0
    set debug 0

    if {[info exists results(-debug)]} {set debug 1}
    if {[info exists results(-rt_options)] && $results(-rt_options) != ""} {
        set cmd "report_timing -nosplit -input_pins -nets $results(-rt_options)"
    } else {
        set cmd "report_timing -nosplit -input_pins -nets -max_paths 25"
    }

    if {[info exists results(-timing_rpt)]} {
        if {![file exists $results(-timing_rpt)]} {
            puts "-E- Timing report '$results(-timing_rpt)' does not exist"
        }
        redirect -variable rpt {sh cat $results(-timing_rpt)}
    } else {
        redirect -variable rpt {eval $cmd}
    }
    puts "-I- Writing report for % cell and net delays using command: $cmd"
    puts "Startpoint, Endpoint, Slack, Cell Delay, % Cell Delay, Net Delay, % Net Delay"
    foreach line [split $rpt \n] {
        if {[regexp {^\s+slack\s+\S+\s+(\S+)\s*$} $line "" slack]} {
            if {$debug} {puts "slack = $slack"}
            if {[expr $total_cell_delay+$total_net_delay] == "0"} {
                # This is for a rare case where startpoint is directly connected to an endpoint and hence no net/cell delay in path
                set p_total_cell_delay 0
                set p_total_net_delay 0
            } else {
                set p_total_cell_delay [expr 100 * [expr $total_cell_delay/($total_cell_delay+$total_net_delay)]]
                set p_total_net_delay [expr 100 * [expr $total_net_delay/($total_cell_delay+$total_net_delay)]]
            }
            puts "$startpoint, $endpoint, $slack, $total_cell_delay, [format %.2f $p_total_cell_delay] %, $total_net_delay, [format %.2f $p_total_net_delay] %" 
            set total_cell_delay 0
            set total_net_delay 0
            continue
        }

        if {[regexp {^\s+Startpoint:\s+(\S+)} $line "" startpoint]} {
            if {$debug} {puts "startpoint: $startpoint"}
            continue
        }
        if {[regexp {^\s+Endpoint:\s+(\S+)} $line "" endpoint]} {
            if {$debug} {puts "endpoint: $endpoint"}
            continue
        }
        if {[regexp {^\s+Path Group:\s+(\S+)$} $line "" pathgroup]} {
            if {$debug} {puts "pathgroup: $pathgroup"}
            continue
        }
        if {[regexp {^\s+\S+\s+\(net\)\s+} $line]} {
            if {$debug} {#puts "got net on $line"}
                set got_net 1
                continue
            }
            if {$got_net == 1 && [regexp {^\s+\S+\s+\(\S+\)\s+(\S+)\s+} $line "" net_delay]} {
                if {$debug} {puts "got net delay = $net_delay, $line"}
                set total_net_delay [expr $total_net_delay + $net_delay]
                set got_net 0
                continue
            }
            if {$got_net == 0 && [regexp {^\s+\S+\s+\(\S+\)\s+(\S+)\s+} $line "" cell_delay]} {
                if {$debug} {puts "got cell delay = $cell_delay, $line"}
                set total_cell_delay [expr $total_cell_delay + $cell_delay]
                continue
            }
        }
    }
    define_proc_attributes rdt_get_percent_cell_net_delay \
        -info "Prints percentage of cell/net delays in a path" \
        -define_args {
            {-rt_options "Options to use for report_timing command in addition to -nosplit -input_pins -nets" report_timing_options string optional}
            {-timing_rpt "Using this timing report instead of proc doing a report timing" timing_report string optional}
            {-debug "Writes messages to debug code" "" boolean optional}
        }


    proc rdt_back2back_cells {args} {
        parse_proc_arguments -args $args results
        if {[info exists results(-pattern)] && $results(-pattern) != ""} {
            set pattern $results(-pattern)
        } elseif {[info exists results(-buffer)]} {
            set pattern "ref_name=~ [getvar G_BUFFER_PATTERN]"
        } elseif {[info exists results(-inverter)]} {
            set pattern "ref_name=~ [getvar G_INVERTER_PATTERN]"
        } else {
            puts "-E- No pattern specified, Example of usage are: 
                                                        To get back to back inverters: dc_shell>        rdt_back2back_cells \"ref_name=~ [getvar G_INVERTER_PATTERN] \"
                                                        To get back to back buffers:     dc_shell>      rdt_back2back_cells \"ref_name=~ [getvar G_BUFFER_PATTERN] \"
                "
            return
        }

        puts "-I- Printing back 2 back cells for patter: $pattern"
        puts "driver_pin, driver_ref_name, reciever_pin, reciever_ref_name, slack"
        foreach_in_collection pin [get_pins -filter "pin_direction==out" -of_objects [get_cells -hierarchical * -filter $pattern]] {
            set driver_pin [get_object_name $pin]
            set driver_cell [file dirname $driver_pin]
            set driver_ref_name [get_attribute $driver_cell ref_name]

            set reciever_list [filter_collection [all_fanout -from $driver_pin -levels 1 -flat -only_cells] $pattern]
            if {[sizeof_collection $reciever_list] == 2} {
                foreach_in_collection reciever $reciever_list {
                    set reciever_cell [get_object_name $reciever]
                    if {$driver_cell != $reciever_cell} {
                        set reciever_pin [get_object_name [get_pins -of_objects $reciever_cell -filter "pin_direction==in"]]
                        set reciever_ref_name [get_attribute $reciever_cell ref_name]
                        set slack [get_attribute [get_timing_paths -max_paths 1 -nworst 1 -delay_type max -through $reciever_pin] slack]
                        puts "$driver_pin, $driver_ref_name, $reciever_pin, $reciever_ref_name, $slack"
                    }
                }
            }
        }
    }

    define_proc_attributes rdt_back2back_cells \
        -info "Prints cells of same type connected back to back (output of one feeding input of other of same type)" \
        -define_args {
            {-pattern "Pattern to look for" cell_pattern string optional}
            {-buffer "Prints buffer report" "" boolean optional}
            {-inverter "Prints inverter report" "" boolean optional}
        }

    # procedure get_logic_levels takes in the output of "get_timing_path"
    proc rdt_get_logic_levels {args} {
        parse_proc_arguments -args $args results
        if {[info exists results(-paths)] && $results(-paths) != ""} {
            set paths $results(-paths)
        } elseif {[info exists results(-gtp_options)] && $results(-gtp_options) != ""} {
            set paths [eval get_timing_paths $results(-gtp_options)]
        } else {
            set paths [get_timing_paths -max_paths 25]
        }
        puts "\nPrining logic levels per start/end point\n"
        puts "Startpoint, Endpoint, # of logic cells, slack"
        puts "============================================="
        foreach_in_collection path $paths {
            set slack [get_attribute $path slack]
            set startpoint [get_object_name [get_attribute $path startpoint]]
            set endpoint [get_object_name [get_attribute $path endpoint]]
            set points [get_attribute $path points]
            set cells {}
            foreach_in_collection point $points {
                set obj [get_attribute $point object]
                set obj_class [get_attribute $obj object_class]
                set dir [get_attribute $obj direction]
                if {$dir == "in" && $obj_class == "pin" } {
                    set cells [add_to_collection $cells [get_cells -of_object $obj -filter "@is_combinational == true"]]
                }
            }
            puts "$startpoint, $endpoint, [sizeof_collection $cells], $slack"
        }
    }

    define_proc_attributes rdt_get_logic_levels \
        -info "Prints logic levels in a start/end point pair" \
        -define_args {
            {-paths "output of get_timing_paths command" timing_paths string optional}
            {-gtp_options "options to be used by get_timing_paths command" get_timing_path_options string optional}
        }
    

    # Procedure rdt_flop_latch_info reports the following:
    # 1) Number of flops and latches
    # 2) For each clock, reports flops and latches on it
    # 3) Reports flops and latches that do not have a clock on them
    proc rdt_flop_latch_info {args} {
        parse_proc_arguments -args $args val

        suppress_message { TIM-111 TIM-134 }

        set all_flops [all_registers -edge_triggered]
        if {[getvar -quiet G_CLOCK_CELL_LIST] ne ""} {

    foreach _clk_cell [getvar G_CLOCK_CELL_LIST] {

        set all_flops [remove_from_collection $all_flops [filter_collection $all_flops "ref_name =~ $_clk_cell"]]

    }

   } else {

         set all_flops [remove_from_collection $all_flops [filter_collection $all_flops "ref_name =~ ???c* || ref_name =~ ???g* "]]

    }
        set all_flops [remove_from_collection $all_flops [filter_collection $all_flops "ref_name =~ b1?cmx2* || ref_name =~ *gmx2* || ref_name =~ *cmbn* || ref_name =~ *cmn*"]]
        

        set all_latches [all_registers -level_sensitive]

        redirect /dev/null {set _current_design [current_design]}
        puts "#--------------------------|-------------"
        puts "# Design is [get_object_name $_current_design]"
        puts "#--------------------------|-------------"
        puts "#   Number of flops                |      [sizeof_collection $all_flops]"
        puts "#   Number of latches              |      [sizeof_collection $all_latches]"
        puts "#--------------------------|-------------"
        puts "\n"

        puts "#---------------------------------------"
        puts "#   Clock            Number of flops/latches"
        puts "#---------------------------------------"
        foreach_in_collection clk_des [all_clocks] {
            set curr_clk [get_object_name $clk_des]
			set clk_source [get_object_name [get_attribute [get_clocks -quiet $curr_clk] sources]]

            if { $clk_source == "" } { continue }

			set clocked_regs [filter_collection [all_fanout -from $clk_source -flat -only_cells -endpoint] "is_hierarchical == false"]
            set clocked_regs [remove_from_collection $clocked_regs [filter_collection $clocked_regs "ref_name =~ b1?cmx2* || ref_name =~ *gmx2* || ref_name =~ f05cmbn*"]]
            set number_of_flops [sizeof_collection $clocked_regs]
            if {$number_of_flops > 0} {
                puts "#  $curr_clk               $number_of_flops  "
            }
        }
        puts "\n"

        set des_clks [all_clocks]
        foreach_in_collection clk_des $des_clks {
            set curr_clk [get_object_name $clk_des]
			set clk_source [get_object_name [get_attribute [get_clocks -quiet $curr_clk] sources]]

            if { $clk_source == "" } { continue }

			set clocked_regs [filter_collection [all_fanout -from $clk_source -flat -only_cells -endpoint] "is_hierarchical == false"]
            set clocked_regs [remove_from_collection $clocked_regs [filter_collection $clocked_regs "ref_name =~ b1?cmx2* || ref_name =~ *gmx2* || ref_name =~ f05cmbn*"]]

            set latches_on_clock [all_registers -level_sensitive -clock $curr_clk]

            set flops_on_clock [remove_from_collection $clocked_regs $latches_on_clock]

            set all_flops [remove_from_collection $all_flops $flops_on_clock]
            set all_latches [remove_from_collection $all_latches $latches_on_clock]

            if {[sizeof_collection      $flops_on_clock] > 0} {
                puts "# Total number of Flops on the clock $curr_clk are: [sizeof_collection $flops_on_clock]"
                puts "# Flops on the clock $curr_clk are:"
                puts "# ------------------------------------------"
                puts "set flops_of_clk($curr_clk) {"
                foreach_in_collection flop_on_clock $flops_on_clock {
                    puts "      [get_object_name $flop_on_clock]"
                }
                puts "}"
                puts "\n" 
            }

            if {[sizeof_collection      $latches_on_clock] > 0} {
                puts "# Total number of Latches on the clock $curr_clk are: [sizeof_collection $latches_on_clock]"
                puts "# Latches on the clock $curr_clk are:"
                puts "# ------------------------------------------"
                puts "set latches_of_clk($curr_clk) {"
                foreach_in_collection latch_on_clock $latches_on_clock {
                    puts "      [get_object_name $latch_on_clock]"
                }
                puts "}"
                puts "\n"
            }
        }

        if {[sizeof_collection $all_latches] > 0} {
            puts "# Total number of Latches not on the clock lines are: [sizeof_collection $all_latches]"
            puts "# Latches not on the clock lines are:"
            puts "# ------------------------------------------------"
            puts "set latches_on_comb_logic {"
            foreach_in_collection comb_latch $all_latches {
                puts "  [get_object_name $comb_latch]"
            }
            puts "}"
            puts "\n"
        } else {
            puts "# All latches are on some clocks"
        }
        if {[sizeof_collection $all_flops] > 0} {
            puts "# Total number of Flops not on the clock lines are: [sizeof_collection $all_flops]"
            puts "# Flops not on the clock lines are:"
            puts "# ------------------------------------------------"
            puts "set flops_on_comb_logic {"
            foreach_in_collection comb_flop $all_flops {
                puts "  [get_object_name $comb_flop]"
            }
            puts "}"
            puts "\n"
        } else {
            puts "# All flops are on some clocks"
        }
        
        unsuppress_message { TIM-111 TIM-134 }
   
    }
    define_proc_attributes rdt_flop_latch_info \
        -info "Procedure to report lacthes and flops in the design" \
        -define_args {\
                      }

    proc T_sel2list { args } {
        global synopsys_program_name

        set sel [lindex $args 0]
        if {[info exists synopsys_program_name] && $synopsys_program_name != ""} {
            if {[llength $sel] == 1} {
                if {[string match "_sel*" $sel] == 1} {
                    set return_val ""
                    foreach_in_collection ss $sel {
                        lappend return_val [get_object_name $ss]
                    }
                    return $return_val
                } else {
                    return $sel
                }
            } else {
                return $sel
            }
        } else {
            puts "-W- This procedure will only work from within Synopsys tools"
            return $args
        }
    }


    proc rdt_check_port_timing {args} {
        parse_proc_arguments -args $args val
        global synopsys_program_name
        suppress_message {UID-16 UID-17}
        set in_ports_without_delay [remove_from_collection [all_inputs] [all_inputs -edge_triggered]]
        set in_ports_without_delay [remove_from_collection $in_ports_without_delay [all_inputs -level_sensitive]]
        redirect /dev/null {set hfn_ports [get_ports {scan_en tlu_scantestmode iscantm}]}
        if {($synopsys_program_name == "dc_shell")} {
            set hfn_ports [add_to_collection $hfn_ports [get_ports -filter "@is_clock==true"]]
            set hfn_ports [add_to_collection $hfn_ports [get_ports -filter "@is_reset==true"]]
            set in_ports_without_delay [remove_from_collection $in_ports_without_delay $hfn_ports]
        }
        foreach_in_collection clk [all_clocks] {
            set in_ports_without_delay [remove_from_collection $in_ports_without_delay [get_attribute $clk sources]]
        }

        set op_ports_without_delay [remove_from_collection [all_outputs] [all_outputs -edge_triggered]]
        set op_ports_without_delay [remove_from_collection $op_ports_without_delay [all_outputs -level_sensitive]]
        set no_in_ports_without_delay [sizeof_collection $in_ports_without_delay]
        set no_op_ports_without_delay [sizeof_collection $op_ports_without_delay]

        puts "\n"
        puts "There are $no_in_ports_without_delay input ports that are not constrained"
        puts "There are $no_op_ports_without_delay output that are not constrained"
        puts "\n"

        if {$no_in_ports_without_delay > 0} {
            puts "\n"
            puts "Following are the input ports that are not constrained"
            puts "------------------------------------------------------"
            foreach_in_collection prt $in_ports_without_delay {
                puts "[T_sel2list $prt]"
            }
        }
        if {$no_op_ports_without_delay > 0} {
            puts "\n"
            puts "Following are the output ports that are not constrained"
            puts "-------------------------------------------------------"
            foreach_in_collection prt $op_ports_without_delay {
                puts "[T_sel2list $prt]"
            }
        }
        unsuppress_message {UID-16 UID-17}
    }
    define_proc_attributes rdt_check_port_timing \
        -info "Reports ports that are not constrained" \
        -define_args {
        }

    proc rdt_write_connect_supply_net {args} {
        parse_proc_arguments -args $args results

        if {[info exists results]} {
            if {[llength $results(cell_list)] == "0"} {
                puts "# -E- cell list provided is empty"
                return
            }
            set cell_list $results(cell_list)
        } else {
            #set cell_list [get_object_name [all_isolation_cells]]
            set cell_list [get_object_name [get_always_on_logic -cells]]
        }

        puts "# Total of [llength $cell_list] cells"
        foreach cell $cell_list {
            if {[sizeof_collection [get_cells $cell]]} {
                set pg_pins [remove_from_collection [get_pins -all $cell/*] [get_pins $cell/*]]
                foreach_in_collection pg_pin $pg_pins {
                    set pg_pin [get_object_name $pg_pin]
                    set supply_net [get_attribute $pg_pin net_name]
                    puts "connect_supply_net $supply_net -ports $pg_pin"
                }
            }
        }
    }

    define_proc_attributes rdt_write_connect_supply_net \
        -info "Writes connect_supply_net statements for pg pins of AON logic in design" \
        -define_args {
            {cell_list "List of cells" cell_list string optional}
        }

######################################################################################
#
# Procedure rdt_print_histogram_report
#
# Description: Print violator and timing range histographs per timing group
#
######################################################################################
proc rdt_path_graph { args } {

   redirect /dev/null { set rcs_string {$Id: path_graph.proc,v 1.10 2000/02/28 15:29:30 tobrien Exp tobrien $} }

   set results(-bin_width)  -1.03
   set results(-y_axis) 30
   set results(-x_axis) 60
   set results(-path_collection) ""
   set results(-title) "Histogram"
   set results(-type) "slack"
   set results(-skip_data_save) false

   parse_proc_arguments -arg $args results

   set bin_width_force $results(-bin_width)
   set y_axis $results(-y_axis)
   set x_axis $results(-x_axis)
   set title $results(-title)
   set type $results(-type)
   set skip_data_save $results(-skip_data_save)
   set path_collection $results(-path_collection)

   set y_label [list P A T H " " C O U N T]
   set slack_list ""

   #-- if no path specified,
   if { $path_collection == "" } {
      rdt_print_warn "No path_collection specified for rdt_path_graph "
      return
   } else {
   #-- establish data and write to reload file
      foreach_in_collection pth $path_collection {
         lappend slack_list [get_attribute $pth $type]
      }
   }
   set sorted_slack [lsort -real $slack_list]
   set npaths [llength $slack_list]
   set worst_slk [lindex $sorted_slack 0]
   set best_slk [lindex $sorted_slack [expr $npaths - 1]]
   ###echo "best slack was $best_slk"
   if { $worst_slk < 0 } {
       set slk_width [expr $best_slk - $worst_slk]
   } else {
       set slk_width [expr $best_slk]
   }
   if { $best_slk < 0 } {
      echo "WARNING: All values of $type are negative. Forcing bins to 0.5."
      set bin_width_force 10
   } else {
      set bin_width [expr 2 * $slk_width/$x_axis]
   }
   ###echo "bin width is $bin_width after slk_width of $slk_width and x_axis of $x_axis"
   if { $bin_width_force > 0 } {
       set bin_width $bin_width_force
   }
   if { $bin_width == 0 } {
       rdt_print_info "Bin width is too small to create histogram for this path group"
       return
   }

   set right_bin [expr round(($best_slk)/$bin_width) + 1]
   if { $worst_slk < 0 } {
       set left_bin [expr round($worst_slk/$bin_width) - 1]
   } else {
       set left_bin 0
   }
   set total_bins [expr  $right_bin - $left_bin]

   #-- Initialize bin array
   for {set i $left_bin} { $i < [expr $right_bin + 1] } { incr i } {
      set bin($i) 0
   }
   set max_y 0.0
   set TNS 0
   set num_violators 0
   foreach slk $sorted_slack {
       set bin_num [expr round(($slk)/$bin_width)]
       if { $bin_num == 0 && $slk < 0 } {
           set bin_num -1
       }
       incr bin($bin_num)
       if { $bin($bin_num) > $max_y } {
              set max_y $bin($bin_num)
       }
       #-- track TNS and Number of violators
       if { $slk < 0 } {
          incr num_violators
          set TNS [expr $TNS + $slk]
       }
   }
   #-- fixes a subtle behavior with integers
   set y_axis_float [expr $y_axis + 0.000001]
   set y_norm [format "%6.2f" [expr $max_y/$y_axis_float]]
   ########################################
   # create a histogram of the data       #
   ########################################
   # echo "Max y is $max_y and yaxis is $y_axis and y_norm is $y_norm"
   # echo "y norm is $y_norm"
   ###echo ""
   ###echo ""
   echo "Histogram:  $title"
   ###echo ""
   echo "$npaths total paths"
   echo "$num_violators violating paths"
   echo "[format "%4.2f" $TNS] total negative slack"
   echo ""
   set row ""
   for {set b $left_bin} { $b < $right_bin } { incr b } {
     if { $b == 0 } {
           set dchar "|"
     } else {
        set dchar " "
     }
     lappend row $dchar
   }
   #-- down each row
   set n 0
   for {set y [expr $y_axis + 1] } { $y >= 0 } { incr y -1 } {
     if { $y < [expr $y_axis/2] } {
       set ychar [lindex $y_label $n]
       incr n
     } else {
       set ychar " "
     }
     #-- across each column
     for {set b $left_bin} { $b < $right_bin } { incr b } {
        set thresh [expr round($y_norm * $y)]
        set idx [expr $b - $left_bin]
        # echo "bin $b has count $bin($b) comparing to $thresh and index $idx (y is $y and ynorm is $y_norm)"
        if { $bin($b) > $thresh } {
          set row [lreplace $row $idx $idx "*"]
        }

     }
     #-- end col
     echo [format " %1s  %04s  %s" $ychar [expr $thresh + 1] [join $row]]
   }
   #-- end row
   ####################################
   # format the base of the histogram
   ####################################
   set base ""
   set base2 ""
   set d2 "  "
   for { set k 0 } { $k < $total_bins } { incr k } {
      if { $k == [expr -$left_bin] } {
          set d1 "+-"
          set d2 "0 "
      } else {
          set d1 "--"
          set d2 "  "
      }
      set base $base$d1
      set base2 $base2$d2
   }
   set worst_slk_out [format "%3.2f" $worst_slk]
   set base_seg2 "[format "%3.2f" $best_slk]"
   set base_length [expr 2 * $total_bins]
   if { $worst_slk > 0  } {
       set worst_slk_bin [expr 2 * round($worst_slk/$bin_width)]
       set base_seg1 "[string range $base2 0 [expr $worst_slk_bin - 2]][\
                       format "%3.2f" $worst_slk][string range $base2 \
                      [expr 6 + $worst_slk_bin ] [expr $base_length - 4 ]]"
    } else {
       set base_seg1 "[format "%3.2f" $worst_slk][string range $base2 5 [\
                      expr [string length $base2] - 5]]"
    }
    echo "          $base"
    echo "          $base_seg1$base_seg2"
    echo [format "          %-*s PATH [string toupper $type]"  $total_bins " "]

}

 define_proc_attributes rdt_path_graph -info "generate a text histogram" \
     -define_args \
    {
      { -path_collection "timing path collection "
        "collection" string optional }
      { -type "graph slack or arrival (def is slack)" "attr"
         one_of_string {optional value_help {values {arrival slack}}} }
      { -title "title of histogram" "title"
         string optional }
      { -skip_data_save "omit the dump of the data for later runs" ""
         boolean optional }
      { -bin_width "force each bins width (overides x_axis)" "width"
         float optional }
      { -x_axis "the width of the x-axis in characters. default is 60" "width"
         int optional }
      { -y_axis "the height of the y-axis in characters. default is 30."  "y_axis"
         int optional }
}


proc rdt_report_violations {args} {

   parse_proc_arguments -args $args result

   if {[info exist result(-type)]} {
      set del_type $result(-type)
   } else {
      set del_type setup
   }

   if {[info exist result(-bins)]} {
      set bin_cnt $result(-bins)
   } else {
      set bin_cnt 5
   }

   ## Set the max number of bins
   set max_bin_limit   10

   if {[expr ${bin_cnt} < 1] | [expr ${bin_cnt} > ${max_bin_limit}]} {
      rdt_print_info "\nError: Invaild count specified for bins. Give a value from 1 to 10 only."
      rdt_print_info "Info: Proceeding reporting with default bin count of 5.\n"
      set bin_cnt 5
   }

   if {[info exist result(-group)]} {
      set pthgrp [get_object_name [get_path_groups -quiet $result(-group)]]
   } else {
      set pthgrp "doitforall"
   }

   if {${pthgrp} == ""} {
      rdt_print_info "\nError: Invalid path-group name specified. '$result(-group)' is not a valid path group."
      rdt_print_info "Info: Proceeding with reporting for all path groups. \n"
      set pthgrp "doitforall"
   }

   ## Call proc to display report header
   ###make_header

   ## Setup for main script
   if { ${del_type} == "setup" } {
      redirect -var rpt_vlt {report_constraint -all_violators -max_delay -nosplit -sig 5}
      set str "max_delay/setup"
   } elseif { ${del_type} == "hold" } {
      redirect -var rpt_vlt {report_constraint -all_violators -min_delay -nosplit -sig 5}
      set str "min_delay/hold"
   }
   set new_clk_grp 0
   set strt 0
   set vcnt 0
   set all_vclk_grp ""

   ## Greps all the violating path groups and create unique
   ## lists containing violation numbers for them.
   ## list name : list_'path_roup_name'
   ## All these lists are sored in a parent list "all_vclk_grp"
   foreach i [split $rpt_vlt "\n"] {

      if {[regexp "\\s+${str}" $i]} {
         set new_clk_grp 1
         set strt 0
         set pgrp 0
         regexp "\\s+${str} \\(\'\(\\S+\)\' group\\)" $i match clk_nam
         lappend all_vclk_grp list_${clk_nam}
      } elseif {$new_clk_grp} {
         if {[regexp "\\--+" $i]} {
            set new_clk_grp 0
            set strt 1
         }
      } elseif {$strt} {
         if {[regexp "\\s+\\S" $i]} {
            regexp "\\s+\\S+\\s+\\S+\\s+\\S+ \[rf\]\\s+\(\\S+\)" $i match slack
            lappend list_${clk_nam} $slack
         }
      }

   }

   ## Group display control section
   if {${pthgrp} == "doitforall"} {
      set all_vclk_grp ${all_vclk_grp}
   } else {
      set op           [lsearch ${all_vclk_grp} "list_${pthgrp}"]
      if {$op >= 0} {
         set all_vclk_grp "list_${pthgrp}"
      } else {
         rdt_print_info "Specified path group '${pthgrp}' does not have any '${del_type}' violations.\n"
         set all_vclk_grp ""
      }
   }

   ## Graph Display Section
   set vclk_grp_cnt [llength ${all_vclk_grp}]

   if {${vclk_grp_cnt} > 0} {

      ## Loop to parse through parent list "all_vclk_grp"
      for {set i 0} {$i < ${vclk_grp_cnt}} {incr i} {
         set clk_grp     [lindex ${all_vclk_grp} $i]
         set clk_grp_nam [string trim ${clk_grp} list_]
         set vltrs_lst   [set [lindex ${all_vclk_grp} $i]]
         ## Call proc to display graph for this path group
         make_graph $clk_grp_nam $vltrs_lst ${bin_cnt}
      }

   }

}

## proc to aid header proc
proc max_violating_path_group_count {} {
   redirect -var rpt_vlt {report_constraint -all_violators -max_delay -nosplit -sig 5}
   set cnt         [regexp -all "max_delay/setup" $rpt_vlt]
   return $cnt
}

## proc to aid header proc
proc min_violating_path_group_count {} {
   redirect -var rpt_vlt {report_constraint -all_violators -min_delay -nosplit -sig 5}
   set cnt         [regexp -all "min_delay/hold" $rpt_vlt]
   return $cnt
}

## proc to aid header proc
proc max_delay_violation_count {} {
   redirect -var rpt_vlt {report_constraint -all_violators -max_delay -nosplit -sig 5}
   set cnt         [regexp -all "VIOLATED" $rpt_vlt]
   return $cnt
}

## proc to aid header proc
proc min_delay_violation_count {} {
   redirect -var rpt_vlt {report_constraint -all_violators -min_delay -nosplit -sig 5}
   set cnt         [regexp -all "VIOLATED" $rpt_vlt]
   return $cnt
}


## proc for generating header and some additional information
proc make_header {} {

   set pth_grp     [get_path_groups *]
   set des_nam     [current_design_name]
   set pgrp_nm     [sizeof ${pth_grp}]
   set ver         [get_version]
   set Mgrp_nm     [max_violating_path_group_count]
   set mgrp_nm     [min_violating_path_group_count]
   set M_v_cnt     [max_delay_violation_count]
   set m_v_cnt     [min_delay_violation_count]

}

## proc to aid graph proc
proc in_range {s e lst} {
   set       cnt 0
   foreach i $lst {
      if {[expr $i >= $e] && [expr $i < $s]} {
      incr cnt
      }
   }
   return $cnt
}

## proc to aid graph proc
proc get_step_size {wns bcnt} {
   set stp_size    [expr ${wns}/${bcnt}]
   return ${stp_size}
}

## proc for creating graph
proc make_graph {grp_nam lst bcnt} {

   set clk_grp_nam ${grp_nam}
   set vltrs_lst   $lst
   set bins        $bcnt
   set violtrs     [llength ${vltrs_lst}]
   set max_vltr    [lindex  ${vltrs_lst} 0]
   set min_vltr    [lindex  ${vltrs_lst} [expr $violtrs - 1]]

   ## Determine step size (range) for the histogram bars
   set stp_size    [get_step_size ${max_vltr} $bins]
   for {set i 1} {$i < $bins} {incr i} {
      set bar${i}     [expr ${stp_size} * ${i}]
   }

   ## number of violating paths in each bar (step)
   set btot        0
   for {set i 1} {$i < $bins} {incr i} {
      set bv${i}      [in_range [expr ($i - 1) * ${stp_size}] [expr $i * ${stp_size}] $vltrs_lst]
      set btot        [expr $btot + [set bv${i}]]
   }
   set bv${bins}   [expr $violtrs - ($btot)]

   ## this portion ensures that bars across the path groups are not very irregular
   ## it will ensure that maximum bar length is always of 50 '*' and all the other
   ## bars are sized relatively
   set bltmp       ""
   for {set i 1} {$i <= $bins} {incr i} {
      lappend bltmp   [set bv${i}]
   }
   set blst        [lsort -dec -integer ${bltmp}]
   set bmax        [lindex $blst 0]
   set blen        [expr 50.0/${bmax}]

   ## length of bar "number of '*'"
   for {set i 1} {$i <= $bins} {incr i} {
      set tmp         [set bv${i}]
      set b${i}       [expr  round((${tmp} * $blen))]
   }

   echo "*************************************"
   echo "Path Group Name   : ${clk_grp_nam}"
   echo "*************************************\n"
   echo "Total Violations  : $violtrs"
   echo "Worst Violator    : $max_vltr"
   echo "Graph Data:"
   echo "==================================================="
   for {set i 1} {$i < $bins} {incr i} {
      puts "Violation Range for Bar ${i} : [format %.6f [expr ($i - 1) * ${stp_size}]] to  [format %.6f [expr $i * ${stp_size}]] "
   }
   puts "Violation Range for Bar ${bins} : > [format %.6f [expr (${bins} - 1) * ${stp_size}]] "
   echo "===================================================\n"

   echo "Histogram of violations on '${clk_grp_nam}' (bins = ${bins})"
   echo "| (% of WNS)         (violations) -->"
   echo "V"
   for {set i 1} {$i < $bins} {incr i} {
      if { $i == 1} {
         echo " [expr ($i - 1) * round(100/${bins})]-[expr $i * round(100/${bins})]% : [string repeat * [set b${i}]] ([set bv${i}])"
      } else {
         echo "[expr ($i - 1) * round(100/${bins})]-[expr $i * round(100/${bins})]% : [string repeat * [set b${i}]] ([set bv${i}])"
      }
   }

   echo " > [expr ($bins - 1) * round(100/${bins})]% : [string repeat * [set b${bins}]] ([set bv${bins}])"
   echo "\n\n"
}

define_proc_attributes rdt_report_violations \
    -info "Display design violations (setup or hold) in histogram (classified as per path-groups)" \
    -hide_body \
    -define_arg { \
     {-type  "Specify the violation type to be reported (default: setup)" "delay_type" one_of_string {optional value_help {values {setup

hold}}}}
     {-bins  "Specify the number of bins for histogram (default: 5)" "bin count (1-10)" int optional}
     {-group "Specify the path group for reporting (default: all)" "path_group" string optional}
     }


   proc rdt_print_histogram_report {args} {
        parse_proc_arguments -args $args results

        if {[info exists results(-bins)] && ($results(-bins) != "" || $results(-bins) != 0) && $results(-bins) <= 10 } {
            set bins [expr int($results(-bins))]
        } else {
            set bins 10
        }

        if {[info exists results(-slack_min)] && ($results(-slack_min) != "" || $results(-slack_min) != 0)} {
            set slack_min $results(-slack_min)
        } else {
            set slack_min [lindex [get_attribute [get_timing_paths] slack] 0]
            if {$slack_min=="" || $slack_min=="INFINITY"}  {
                puts "-E- Design is unconstrainted, no histogram report will be generated"
                return
            }
            set slack_min_list [lsort -real [get_attribute [get_timing_paths] slack]]
            set slack_min [expr int(floor([lindex $slack_min_list 0]))]
        }

        if {[info exists results(-slack_max)] && ($results(-slack_max) != "" || $results(-slack_max) != 0)} {
            set slack_max $results(-slack_max)
        } else {
            set slack_max 100
        }

        set path_groups ""
        if {[info exists results(-path_groups)] && $results(-path_groups) != ""} {
            set path_groups $results(-path_groups)
        } else {
            foreach_in_collection path_group [get_path_groups] {
                set path_group [get_object_name $path_group]
                if {[regexp {\*} $path_group]} {continue}
                lappend path_groups $path_group
            }
        }

        if {[info exists results(-gtp_options)] && $results(-gtp_options) != ""} {
            set gtp_options $results(-gtp_options)
        } else {
            set gtp_options "-max_paths 1000000"
        }
        ###set gtp_options [concat $gtp_options -group \"$path_groups\" ]

        puts "\nTiming Histogram using command: rdt_print_histogram_report -bins $bins -slack_min $slack_min -slack_max $slack_max -gtp_options \"$gtp_options\"\n\n"

        suppress_message CMD-041

        foreach _pg $path_groups {
            rdt_report_violations -bins $bins -type setup -group $_pg
            set _gtpo [concat $gtp_options -group $_pg -slack_lesser_than $slack_max -slack_greater_than $slack_min ]
            set paths [eval [concat "get_timing_paths " $_gtpo ]]
            rdt_path_graph -path $paths -title "$_pg Group Timing for Specified Slack Min/Max Range"
        }

        unsuppress_message CMD-041
    }



    define_proc_attributes rdt_print_histogram_report \
        -info "Print histogram of timing paths" \
        -define_args {
            {-slack_min "Minimum slack (default is wns of design)" "" float optional}
            {-slack_max "Maximum slack (default is 100)" "" float optional}
            {-bins        "Number of bins (default is 10)" "" string optional}
            {-gtp_options "Options to use for get_timing_paths (default is -max_paths 1000) " "" string optional}
            {-path_groups "Path groups to do histograms for (default is all path groups) " "" string optional}
        }
 
######################## End proc rdt_print_histogram_report #########################

############ Generate sequential count report broken down by desing and fub.

proc print_all_fubs_seq_stats {step_name} {
        set file_name "./outputs/[getvar G_DESIGN_NAME].${step_name}.all_fubs_seq_stat.rpt"
        if {[file exists $file_name]} {sh rm -f $file_name}
        set file_id [open $file_name "w"]
        set hier_pattern [hier_pattern_for_querying_all_fubs]
        set all_fub_names [get_attr [get_cells ${hier_pattern} -filter "is_hierarchical == true"] full_name]
        set fub "[getvar G_DESIGN_NAME]"
        puts "Printing seq stat for fub ${fub} in $file_name"
        set cells [get_cells -hier *]
        print_seq_stats $fub $file_id $cells
        foreach fub $all_fub_names {
                puts "Printing seq stat for fub ${fub} in $file_name"
                print_fub_seq_stats ${fub} $file_id
        }
        set fub "others"
        set cells [get_cells *]
        puts "Printing seq stat for fub ${fub} in $file_name"
        print_seq_stats $fub $file_id $cells
        close $file_id
}

proc print_seq_stats {fub FILE_NAME cells_coll} {
   set all_seq [get_cells ${cells_coll} -hier -filter "is_hierarchical == false && is_sequential == true && ((ref_name =~ bl0l* && ref_name !~ bl0lbc* ) || ref_name =~ bl0f*)"   ]
   set all_flops [get_cells ${cells_coll} -hier -filter "is_hierarchical == false && is_sequential == true && ref_name =~ bl0f*"]
   set all_latches [get_cells ${cells_coll} -hier -filter "is_hierarchical == false && is_sequential == true && (ref_name =~ bl0l* && ref_name !~ bl0lbc* )"   ]

   set all_scan_latches [get_cells -hier $all_latches -filter "ref_name =~ ?????x* || ref_name =~ ?????v* || ref_name =~ ?????e* || ref_name =~ ?????z*"]
   set all_non_scan_latches [remove_from_collection [get_cells $all_latches] [get_cells $all_scan_latches ]]
   set all_scan_vec_latches [get_cells -hier $all_scan_latches -filter "ref_name =~ ????2*"]
   set all_non_scan_vec_latches [get_cells -hier $all_non_scan_latches -filter "ref_name =~ ????2*"]
   set all_scan_novec_latches [remove_from_collection [get_cells $all_scan_latches] [get_cells $all_scan_vec_latches]]
   set all_non_scan_novec_latches [remove_from_collection [get_cells $all_non_scan_latches] [get_cells $all_non_scan_vec_latches]]

   set all_scan_flops [get_cells -hier $all_flops -filter "ref_name =~ ?????v* || ref_name =~ ?????x* || ref_name =~ ?????e* || ref_name =~ ?????z*"]
   set all_non_scan_flops [remove_from_collection [get_cells $all_flops] [get_cells $all_scan_flops ]]
   set all_scan_vec_flops [get_cells -hier $all_scan_flops -filter "ref_name =~ ????2*"]
   set all_non_scan_vec_flops [get_cells -hier $all_non_scan_flops -filter "ref_name =~ ????2*"]
   set all_scan_novec_flops [remove_from_collection [get_cells $all_scan_flops] [get_cells $all_scan_vec_flops]]
   set all_non_scan_novec_flops [remove_from_collection [get_cells $all_non_scan_flops] [get_cells $all_non_scan_vec_flops]]

        puts $FILE_NAME "$fub"
        puts $FILE_NAME "<type> : <num_of_cells_of_type> : <percentage>"
   foreach type "all_seq all_flops all_latches all_scan_latches all_scan_vec_latches all_scan_novec_latches all_non_scan_latches all_non_scan_vec_latches all_non_scan_novec_latches all_scan_flops all_scan_vec_flops all_scan_novec_flops all_non_scan_flops all_non_scan_vec_flops all_non_scan_novec_flops" {
                set cells [get_cells [set $type]]
                if {[sizeof_coll $all_seq] > 0 } {
                        puts $FILE_NAME "\t$type : [sizeof_coll [get_cells $cells]] : [expr  [expr [sizeof_coll [get_cells $cells]] * 100.00 ] / [sizeof $all_seq]]"
                } else {
                        puts $FILE_NAME "\t$type : [sizeof_coll [get_cells $cells]] : NA"
                }
   }
}

proc print_fub_seq_stats {fub FILE_NAME} {

   set all_seq [get_cells -quiet ${fub}/* -filter "is_hierarchical == false && is_sequential == true && ((ref_name =~ bl0l* && ref_name !~ bl0lbc* ) || ref_name =~ bl0f*)"   ]
   set all_flops [get_cells -quiet ${fub}/* -filter "is_hierarchical == false && is_sequential == true && ref_name =~ bl0f*"]
   set all_latches [get_cells -quiet ${fub}/* -filter "is_hierarchical == false && is_sequential == true && (ref_name =~ bl0l* && ref_name !~ bl0lbc* )"   ]

   set all_scan_latches [get_cells $all_latches -filter "ref_name =~ ?????x* || ref_name =~ ?????v* || ref_name =~ ?????e* || ref_name =~ ?????z*"]
   set all_non_scan_latches [remove_from_collection [get_cells $all_latches] [get_cells $all_scan_latches ]]
   set all_scan_vec_latches [get_cells $all_scan_latches -filter "ref_name =~ ????2*"]
   set all_non_scan_vec_latches [get_cells $all_non_scan_latches -filter "ref_name =~ ????2*"]
   set all_scan_novec_latches [remove_from_collection [get_cells $all_scan_latches] [get_cells $all_scan_vec_latches]]
   set all_non_scan_novec_latches [remove_from_collection [get_cells $all_non_scan_latches] [get_cells $all_non_scan_vec_latches]]

   set all_scan_flops [get_cells $all_flops -filter "ref_name =~ ?????v* || ref_name =~ ?????x* || ref_name =~ ?????e* || ref_name =~ ?????z*"]
   set all_non_scan_flops [remove_from_collection [get_cells $all_flops] [get_cells $all_scan_flops ]]
   set all_scan_vec_flops [get_cells $all_scan_flops -filter "ref_name =~ ????2*"]
   set all_non_scan_vec_flops [get_cells $all_non_scan_flops -filter "ref_name =~ ????2*"]
   set all_scan_novec_flops [remove_from_collection [get_cells $all_scan_flops] [get_cells $all_scan_vec_flops]]
   set all_non_scan_novec_flops [remove_from_collection [get_cells $all_non_scan_flops] [get_cells $all_non_scan_vec_flops]]

        puts $FILE_NAME "[get_attr $fub name] : $fub"
        puts $FILE_NAME "<type> : <num_of_cells_of_type> : <percentage>"
   foreach type "all_seq all_flops all_latches all_scan_latches all_scan_vec_latches all_scan_novec_latches all_non_scan_latches all_non_scan_vec_latches all_non_scan_novec_latches all_scan_flops all_scan_vec_flops all_scan_novec_flops all_non_scan_flops all_non_scan_vec_flops all_non_scan_novec_flops" {
                set cells [get_cells [set $type]]
                if {[sizeof_coll $all_seq] > 0 } {
                        puts $FILE_NAME "\t$type : [sizeof_coll [get_cells $cells]] : [expr  [expr [sizeof_coll [get_cells $cells]] * 100.00 ] / [sizeof $all_seq]]"
                } else {
                        puts $FILE_NAME "\t$type : [sizeof_coll [get_cells $cells]] : NA"
                }
   }
}
 
###############################################################################################
