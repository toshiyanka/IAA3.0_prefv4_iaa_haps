set max_async_delay_ratio      2.0
set max_doublesync_delay_ratio 1.0
set sbr_fixed_timing_speedfix "$env(WARD)/syn/outputs/SBR_fixed_timing_speedfix.tcl"

list clocks_list  sbr_clk
lappend clocks_list pgcb_tck

if { [file exists ${sbr_fixed_timing_speedfix}] } {
   sh rm ${sbr_fixed_timing_speedfix}
}

foreach tx_clk {$clocks_list} {
  foreach rx_clk {$clocks_list} {
    if {$tx_clk != $rx_clk} {
#      set_false_path -from $tx_clk -to $rx_clk
      set tx_period [get_attribute [get_clocks $tx_clk] period]
      set rx_period [get_attribute [get_clocks $rx_clk] period]

      # Set the clock period to be from the fast clock to the slow clock to be delay_ratio * receiving clock
      echo "set_max_delay \[expr ${rx_period} * ${max_async_delay_ratio}\] -from \[get_clocks ${tx_clk}\] -to \[get_clocks ${rx_clk}\]" >> ${sbr_fixed_timing_speedfix}
      echo "===> Setting timing from clock ${tx_clk} to ${rx_clk} to be ${rx_period} * ${max_async_delay_ratio}"
    }
  }
}

# Time all the paths from tx_clk to rx_clk to be 1 * rx_clk on the way to a doublesync cell
set doublesync_collection [get_cells * -hier -filter "ref_name =~ *sbc*doublesync* && is_hierarchical == true"]
foreach_in_collection doublesync_inst ${doublesync_collection} {
   set doublesync_name [get_object_name ${doublesync_inst}]
   set doublesync_dpin [get_pins ${doublesync_name}/d]
   set doublesync_timing_paths [get_timing_paths -to $doublesync_dpin]
   if { [sizeof_collection ${doubleysync_timing_paths}] > 0 } {
      foreach_in_collection starting_pin ${doublesync_timing_paths} {
         set starting_clk [get_object_name [get_attribute ${starting_pin} startpoint_clock]]
         if { ${starting_clk} != "" } {
            set starting_period [get_attribute [get_clocks ${starting_clk}] period]
            echo "set_max_delay \[expr ${starting_period} * ${max_doublesync_delay_ratio}\] -from \[get_clocks ${starting_clk}\] -through \[get_pins \[get_object_name ${doublesync_dpin}\]\]" >> ${sbr_fixed_timing_speedfix}
            echo "===> Setting timing for instance ${doublesync_name} to have a max_delay of ${starting_period}"
         }
      }
   }
}

rdt_source_if_exists ${sbr_fixed_timing_speedfix}
# Setting input/output delays of clock domain sbr_clk
#set clk_period [get_attribute [get_clock sbr_clk] period]
#set_input_delay  -clock [get_clock sbr_clk] [expr $clk_period * $SBR_INPUT_DELAY]  [remove_from_collection [all_inputs] [all_clocks]]
#set_output_delay -clock [get_clock sbr_clk] [expr $clk_period * $SBR_OUTPUT_DELAY] [all_outputs]

