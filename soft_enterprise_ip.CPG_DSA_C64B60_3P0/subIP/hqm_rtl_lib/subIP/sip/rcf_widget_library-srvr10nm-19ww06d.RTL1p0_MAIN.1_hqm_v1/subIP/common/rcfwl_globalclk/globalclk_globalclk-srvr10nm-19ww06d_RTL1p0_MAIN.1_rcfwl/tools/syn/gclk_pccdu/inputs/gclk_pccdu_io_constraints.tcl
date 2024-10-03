set_max_transition 93 [current_design]
set_max_fanout 50 [current_design]

if { [sizeof_collection [get_ports -quiet {fdop_preclk_grid[0]}]] > 0 } {
  set_annotated_transition -max -rise 50 [get_ports {fdop_preclk_grid[0]}]
  set_annotated_transition -min -rise 25 [get_ports {fdop_preclk_grid[0]}]
  set_annotated_transition -max -fall 50 [get_ports {fdop_preclk_grid[0]}]
  set_annotated_transition -min -fall 25 [get_ports {fdop_preclk_grid[0]}]
  set_max_capacitance 50 [get_ports {fdop_preclk_grid[0]}]
  set_driving_cell -lib_cell ec0bfn000ac1n08x5  [get_ports {fdop_preclk_grid[0]}]
} else {
  puts "Error: Port fdop_preclk_grid[0] does not exist"
}

if { [sizeof_collection [get_ports -quiet {fdop_preclk_grid[1]}]] > 0 } {
  set_annotated_transition -max -rise 50 [get_ports {fdop_preclk_grid[1]}]
  set_annotated_transition -min -rise 25 [get_ports {fdop_preclk_grid[1]}]
  set_annotated_transition -max -fall 50 [get_ports {fdop_preclk_grid[1]}]
  set_annotated_transition -min -fall 25 [get_ports {fdop_preclk_grid[1]}]
  set_max_capacitance 50 [get_ports {fdop_preclk_grid[1]}]
  set_driving_cell -lib_cell ec0bfn000ac1n08x5  [get_ports {fdop_preclk_grid[1]}]
} else {
  puts "Error: Port fdop_preclk_grid[1] does not exist"
}

if { [sizeof_collection [get_ports -quiet {fdop_preclk_grid[2]}]] > 0 } {
  set_annotated_transition -max -rise 50 [get_ports {fdop_preclk_grid[2]}]
  set_annotated_transition -min -rise 25 [get_ports {fdop_preclk_grid[2]}]
  set_annotated_transition -max -fall 50 [get_ports {fdop_preclk_grid[2]}]
  set_annotated_transition -min -fall 25 [get_ports {fdop_preclk_grid[2]}]
  set_max_capacitance 50 [get_ports {fdop_preclk_grid[2]}]
  set_driving_cell -lib_cell ec0bfn000ac1n08x5  [get_ports {fdop_preclk_grid[2]}]
} else {
  puts "Error: Port fdop_preclk_grid[2] does not exist"
}

if { [sizeof_collection [get_ports -quiet {fscan_preclk_div_sync[2]}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock fdop_preclk_grid[2]  221 [get_ports {fscan_preclk_div_sync[2]}]
  set_input_delay -add_delay -max -fall -clock fdop_preclk_grid[2]  221 [get_ports {fscan_preclk_div_sync[2]}]
  set_input_delay -add_delay -min -rise -clock fdop_preclk_grid[2]  37.3 [get_ports {fscan_preclk_div_sync[2]}]
  set_input_delay -add_delay -min -fall -clock fdop_preclk_grid[2]  37.3 [get_ports {fscan_preclk_div_sync[2]}]
  set_annotated_transition -max -rise 50 [get_ports {fscan_preclk_div_sync[2]}]
  set_annotated_transition -min -rise 25 [get_ports {fscan_preclk_div_sync[2]}]
  set_annotated_transition -max -fall 50 [get_ports {fscan_preclk_div_sync[2]}]
  set_annotated_transition -min -fall 25 [get_ports {fscan_preclk_div_sync[2]}]
  set_max_capacitance 50 [get_ports {fscan_preclk_div_sync[2]}]
  set_driving_cell -lib_cell ec0bfn000ac1n08x5  [get_ports {fscan_preclk_div_sync[2]}]
} else {
  puts "Error: Port fscan_preclk_div_sync[2] does not exist"
}

if { [sizeof_collection [get_ports -quiet {fscan_preclk_div_sync[1]}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock fdop_preclk_grid[1]  221 [get_ports {fscan_preclk_div_sync[1]}]
  set_input_delay -add_delay -max -fall -clock fdop_preclk_grid[1]  221 [get_ports {fscan_preclk_div_sync[1]}]
  set_input_delay -add_delay -min -rise -clock fdop_preclk_grid[1]  37.3 [get_ports {fscan_preclk_div_sync[1]}]
  set_input_delay -add_delay -min -fall -clock fdop_preclk_grid[1]  37.3 [get_ports {fscan_preclk_div_sync[1]}]
  set_annotated_transition -max -rise 50 [get_ports {fscan_preclk_div_sync[1]}]
  set_annotated_transition -min -rise 25 [get_ports {fscan_preclk_div_sync[1]}]
  set_annotated_transition -max -fall 50 [get_ports {fscan_preclk_div_sync[1]}]
  set_annotated_transition -min -fall 25 [get_ports {fscan_preclk_div_sync[1]}]
  set_max_capacitance 50 [get_ports {fscan_preclk_div_sync[1]}]
  set_driving_cell -lib_cell ec0bfn000ac1n08x5  [get_ports {fscan_preclk_div_sync[1]}]
} else {
  puts "Error: Port fscan_preclk_div_sync[1] does not exist"
}

if { [sizeof_collection [get_ports -quiet {fscan_preclk_div_sync[0]}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock fdop_preclk_grid[0]  221 [get_ports {fscan_preclk_div_sync[0]}]
  set_input_delay -add_delay -max -fall -clock fdop_preclk_grid[0]  221 [get_ports {fscan_preclk_div_sync[0]}]
  set_input_delay -add_delay -min -rise -clock fdop_preclk_grid[0]  37.3 [get_ports {fscan_preclk_div_sync[0]}]
  set_input_delay -add_delay -min -fall -clock fdop_preclk_grid[0]  37.3 [get_ports {fscan_preclk_div_sync[0]}]
  set_annotated_transition -max -rise 50 [get_ports {fscan_preclk_div_sync[0]}]
  set_annotated_transition -min -rise 25 [get_ports {fscan_preclk_div_sync[0]}]
  set_annotated_transition -max -fall 50 [get_ports {fscan_preclk_div_sync[0]}]
  set_annotated_transition -min -fall 25 [get_ports {fscan_preclk_div_sync[0]}]
  set_max_capacitance 50 [get_ports {fscan_preclk_div_sync[0]}]
  set_driving_cell -lib_cell ec0bfn000ac1n08x5  [get_ports {fscan_preclk_div_sync[0]}]
} else {
  puts "Error: Port fscan_preclk_div_sync[0] does not exist"
}

if { [sizeof_collection [get_ports -quiet {fscan_dop_shift_dis[5]}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock fdop_preclk_grid[2]  221 [get_ports {fscan_dop_shift_dis[5]}]
  set_input_delay -add_delay -max -fall -clock fdop_preclk_grid[2]  221 [get_ports {fscan_dop_shift_dis[5]}]
  set_input_delay -add_delay -min -rise -clock fdop_preclk_grid[2]  37.3 [get_ports {fscan_dop_shift_dis[5]}]
  set_input_delay -add_delay -min -fall -clock fdop_preclk_grid[2]  37.3 [get_ports {fscan_dop_shift_dis[5]}]
  set_annotated_transition -max -rise 50 [get_ports {fscan_dop_shift_dis[5]}]
  set_annotated_transition -min -rise 25 [get_ports {fscan_dop_shift_dis[5]}]
  set_annotated_transition -max -fall 50 [get_ports {fscan_dop_shift_dis[5]}]
  set_annotated_transition -min -fall 25 [get_ports {fscan_dop_shift_dis[5]}]
  set_max_capacitance 50 [get_ports {fscan_dop_shift_dis[5]}]
  set_driving_cell -lib_cell ec0bfn000ac1n08x5  [get_ports {fscan_dop_shift_dis[5]}]
} else {
  puts "Error: Port fscan_dop_shift_dis[5] does not exist"
}

if { [sizeof_collection [get_ports -quiet {fscan_dop_shift_dis[4]}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock fdop_preclk_grid[1]  221 [get_ports {fscan_dop_shift_dis[4]}]
  set_input_delay -add_delay -max -fall -clock fdop_preclk_grid[1]  221 [get_ports {fscan_dop_shift_dis[4]}]
  set_input_delay -add_delay -min -rise -clock fdop_preclk_grid[1]  37.3 [get_ports {fscan_dop_shift_dis[4]}]
  set_input_delay -add_delay -min -fall -clock fdop_preclk_grid[1]  37.3 [get_ports {fscan_dop_shift_dis[4]}]
  set_annotated_transition -max -rise 50 [get_ports {fscan_dop_shift_dis[4]}]
  set_annotated_transition -min -rise 25 [get_ports {fscan_dop_shift_dis[4]}]
  set_annotated_transition -max -fall 50 [get_ports {fscan_dop_shift_dis[4]}]
  set_annotated_transition -min -fall 25 [get_ports {fscan_dop_shift_dis[4]}]
  set_max_capacitance 50 [get_ports {fscan_dop_shift_dis[4]}]
  set_driving_cell -lib_cell ec0bfn000ac1n08x5  [get_ports {fscan_dop_shift_dis[4]}]
} else {
  puts "Error: Port fscan_dop_shift_dis[4] does not exist"
}
if { [sizeof_collection [get_ports -quiet {fscan_dop_shift_dis[3]}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock fdop_preclk_grid[1]  221 [get_ports {fscan_dop_shift_dis[3]}]
  set_input_delay -add_delay -max -fall -clock fdop_preclk_grid[1]  221 [get_ports {fscan_dop_shift_dis[3]}]
  set_input_delay -add_delay -min -rise -clock fdop_preclk_grid[1]  37.3 [get_ports {fscan_dop_shift_dis[3]}]
  set_input_delay -add_delay -min -fall -clock fdop_preclk_grid[1]  37.3 [get_ports {fscan_dop_shift_dis[3]}]
  set_annotated_transition -max -rise 50 [get_ports {fscan_dop_shift_dis[3]}]
  set_annotated_transition -min -rise 25 [get_ports {fscan_dop_shift_dis[3]}]
  set_annotated_transition -max -fall 50 [get_ports {fscan_dop_shift_dis[3]}]
  set_annotated_transition -min -fall 25 [get_ports {fscan_dop_shift_dis[3]}]
  set_max_capacitance 50 [get_ports {fscan_dop_shift_dis[3]}]
  set_driving_cell -lib_cell ec0bfn000ac1n08x5  [get_ports {fscan_dop_shift_dis[3]}]
} else {
  puts "Error: Port fscan_dop_shift_dis[3] does not exist"
}
if { [sizeof_collection [get_ports -quiet {fscan_dop_shift_dis[2]}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock fdop_preclk_grid[0]  221 [get_ports {fscan_dop_shift_dis[2]}]
  set_input_delay -add_delay -max -fall -clock fdop_preclk_grid[0]  221 [get_ports {fscan_dop_shift_dis[2]}]
  set_input_delay -add_delay -min -rise -clock fdop_preclk_grid[0]  37.3 [get_ports {fscan_dop_shift_dis[2]}]
  set_input_delay -add_delay -min -fall -clock fdop_preclk_grid[0]  37.3 [get_ports {fscan_dop_shift_dis[2]}]
  set_annotated_transition -max -rise 50 [get_ports {fscan_dop_shift_dis[2]}]
  set_annotated_transition -min -rise 25 [get_ports {fscan_dop_shift_dis[2]}]
  set_annotated_transition -max -fall 50 [get_ports {fscan_dop_shift_dis[2]}]
  set_annotated_transition -min -fall 25 [get_ports {fscan_dop_shift_dis[2]}]
  set_max_capacitance 50 [get_ports {fscan_dop_shift_dis[2]}]
  set_driving_cell -lib_cell ec0bfn000ac1n08x5  [get_ports {fscan_dop_shift_dis[2]}]
} else {
  puts "Error: Port fscan_dop_shift_dis[2] does not exist"
}
if { [sizeof_collection [get_ports -quiet {fscan_dop_shift_dis[1]}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock fdop_preclk_grid[0]  221 [get_ports {fscan_dop_shift_dis[1]}]
  set_input_delay -add_delay -max -fall -clock fdop_preclk_grid[0]  221 [get_ports {fscan_dop_shift_dis[1]}]
  set_input_delay -add_delay -min -rise -clock fdop_preclk_grid[0]  37.3 [get_ports {fscan_dop_shift_dis[1]}]
  set_input_delay -add_delay -min -fall -clock fdop_preclk_grid[0]  37.3 [get_ports {fscan_dop_shift_dis[1]}]
  set_annotated_transition -max -rise 50 [get_ports {fscan_dop_shift_dis[1]}]
  set_annotated_transition -min -rise 25 [get_ports {fscan_dop_shift_dis[1]}]
  set_annotated_transition -max -fall 50 [get_ports {fscan_dop_shift_dis[1]}]
  set_annotated_transition -min -fall 25 [get_ports {fscan_dop_shift_dis[1]}]
  set_max_capacitance 50 [get_ports {fscan_dop_shift_dis[1]}]
  set_driving_cell -lib_cell ec0bfn000ac1n08x5  [get_ports {fscan_dop_shift_dis[1]}]
} else {
  puts "Error: Port fscan_dop_shift_dis[1] does not exist"
}
if { [sizeof_collection [get_ports -quiet {fscan_dop_shift_dis[0]}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock fdop_preclk_grid[0]  221 [get_ports {fscan_dop_shift_dis[0]}]
  set_input_delay -add_delay -max -fall -clock fdop_preclk_grid[0]  221 [get_ports {fscan_dop_shift_dis[0]}]
  set_input_delay -add_delay -min -rise -clock fdop_preclk_grid[0]  37.3 [get_ports {fscan_dop_shift_dis[0]}]
  set_input_delay -add_delay -min -fall -clock fdop_preclk_grid[0]  37.3 [get_ports {fscan_dop_shift_dis[0]}]
  set_annotated_transition -max -rise 50 [get_ports {fscan_dop_shift_dis[0]}]
  set_annotated_transition -min -rise 25 [get_ports {fscan_dop_shift_dis[0]}]
  set_annotated_transition -max -fall 50 [get_ports {fscan_dop_shift_dis[0]}]
  set_annotated_transition -min -fall 25 [get_ports {fscan_dop_shift_dis[0]}]
  set_max_capacitance 50 [get_ports {fscan_dop_shift_dis[0]}]
  set_driving_cell -lib_cell ec0bfn000ac1n08x5  [get_ports {fscan_dop_shift_dis[0]}]
} else {
  puts "Error: Port fscan_dop_shift_dis[1] does not exist"
}
if { [sizeof_collection [get_ports -quiet {fscan_dop_clken[5]}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock fdop_preclk_grid[2]  221 [get_ports {fscan_dop_clken[5]}]
  set_input_delay -add_delay -max -fall -clock fdop_preclk_grid[2]  221 [get_ports {fscan_dop_clken[5]}]
  set_input_delay -add_delay -min -rise -clock fdop_preclk_grid[2]  37.3 [get_ports {fscan_dop_clken[5]}]
  set_input_delay -add_delay -min -fall -clock fdop_preclk_grid[2]  37.3 [get_ports {fscan_dop_clken[5]}]
  set_annotated_transition -max -rise 50 [get_ports {fscan_dop_clken[5]}]
  set_annotated_transition -min -rise 25 [get_ports {fscan_dop_clken[5]}]
  set_annotated_transition -max -fall 50 [get_ports {fscan_dop_clken[5]}]
  set_annotated_transition -min -fall 25 [get_ports {fscan_dop_clken[5]}]
  set_max_capacitance 50 [get_ports {fscan_dop_clken[5]}]
  set_driving_cell -lib_cell ec0bfn000ac1n08x5  [get_ports {fscan_dop_clken[5]}]
} else {
  puts "Error: Port fscan_dop_clken[5] does not exist"
}

if { [sizeof_collection [get_ports -quiet {fscan_dop_clken[4]}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock fdop_preclk_grid[1]  221 [get_ports {fscan_dop_clken[4]}]
  set_input_delay -add_delay -max -fall -clock fdop_preclk_grid[1]  221 [get_ports {fscan_dop_clken[4]}]
  set_input_delay -add_delay -min -rise -clock fdop_preclk_grid[1]  37.3 [get_ports {fscan_dop_clken[4]}]
  set_input_delay -add_delay -min -fall -clock fdop_preclk_grid[1]  37.3 [get_ports {fscan_dop_clken[4]}]
  set_annotated_transition -max -rise 50 [get_ports {fscan_dop_clken[4]}]
  set_annotated_transition -min -rise 25 [get_ports {fscan_dop_clken[4]}]
  set_annotated_transition -max -fall 50 [get_ports {fscan_dop_clken[4]}]
  set_annotated_transition -min -fall 25 [get_ports {fscan_dop_clken[4]}]
  set_max_capacitance 50 [get_ports {fscan_dop_clken[4]}]
  set_driving_cell -lib_cell ec0bfn000ac1n08x5  [get_ports {fscan_dop_clken[4]}]
} else {
  puts "Error: Port fscan_dop_clken[4] does not exist"
}

if { [sizeof_collection [get_ports -quiet {fscan_dop_clken[3]}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock fdop_preclk_grid[1]  221 [get_ports {fscan_dop_clken[3]}]
  set_input_delay -add_delay -max -fall -clock fdop_preclk_grid[1]  221 [get_ports {fscan_dop_clken[3]}]
  set_input_delay -add_delay -min -rise -clock fdop_preclk_grid[1]  37.3 [get_ports {fscan_dop_clken[3]}]
  set_input_delay -add_delay -min -fall -clock fdop_preclk_grid[1]  37.3 [get_ports {fscan_dop_clken[3]}]
  set_annotated_transition -max -rise 50 [get_ports {fscan_dop_clken[3]}]
  set_annotated_transition -min -rise 25 [get_ports {fscan_dop_clken[3]}]
  set_annotated_transition -max -fall 50 [get_ports {fscan_dop_clken[3]}]
  set_annotated_transition -min -fall 25 [get_ports {fscan_dop_clken[3]}]
  set_max_capacitance 50 [get_ports {fscan_dop_clken[3]}]
  set_driving_cell -lib_cell ec0bfn000ac1n08x5  [get_ports {fscan_dop_clken[3]}]
} else {
  puts "Error: Port fscan_dop_clken[3] does not exist"
}

if { [sizeof_collection [get_ports -quiet {fscan_dop_clken[2]}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock fdop_preclk_grid[0]  221 [get_ports {fscan_dop_clken[2]}]
  set_input_delay -add_delay -max -fall -clock fdop_preclk_grid[0]  221 [get_ports {fscan_dop_clken[2]}]
  set_input_delay -add_delay -min -rise -clock fdop_preclk_grid[0]  37.3 [get_ports {fscan_dop_clken[2]}]
  set_input_delay -add_delay -min -fall -clock fdop_preclk_grid[0]  37.3 [get_ports {fscan_dop_clken[2]}]
  set_annotated_transition -max -rise 50 [get_ports {fscan_dop_clken[2]}]
  set_annotated_transition -min -rise 25 [get_ports {fscan_dop_clken[2]}]
  set_annotated_transition -max -fall 50 [get_ports {fscan_dop_clken[2]}]
  set_annotated_transition -min -fall 25 [get_ports {fscan_dop_clken[2]}]
  set_max_capacitance 50 [get_ports {fscan_dop_clken[2]}]
  set_driving_cell -lib_cell ec0bfn000ac1n08x5  [get_ports {fscan_dop_clken[2]}]
} else {
  puts "Error: Port fscan_dop_clken[2] does not exist"
}
if { [sizeof_collection [get_ports -quiet {fscan_dop_clken[1]}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock fdop_preclk_grid[0]  221 [get_ports {fscan_dop_clken[1]}]
  set_input_delay -add_delay -max -fall -clock fdop_preclk_grid[0]  221 [get_ports {fscan_dop_clken[1]}]
  set_input_delay -add_delay -min -rise -clock fdop_preclk_grid[0]  37.3 [get_ports {fscan_dop_clken[1]}]
  set_input_delay -add_delay -min -fall -clock fdop_preclk_grid[0]  37.3 [get_ports {fscan_dop_clken[1]}]
  set_annotated_transition -max -rise 50 [get_ports {fscan_dop_clken[1]}]
  set_annotated_transition -min -rise 25 [get_ports {fscan_dop_clken[1]}]
  set_annotated_transition -max -fall 50 [get_ports {fscan_dop_clken[1]}]
  set_annotated_transition -min -fall 25 [get_ports {fscan_dop_clken[1]}]
  set_max_capacitance 50 [get_ports {fscan_dop_clken[1]}]
  set_driving_cell -lib_cell ec0bfn000ac1n08x5  [get_ports {fscan_dop_clken[1]}]
} else {
  puts "Error: Port fscan_dop_clken[1] does not exist"
}
if { [sizeof_collection [get_ports -quiet {fscan_dop_clken[0]}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock fdop_preclk_grid[0]  221 [get_ports {fscan_dop_clken[0]}]
  set_input_delay -add_delay -max -fall -clock fdop_preclk_grid[0]  221 [get_ports {fscan_dop_clken[0]}]
  set_input_delay -add_delay -min -rise -clock fdop_preclk_grid[0]  37.3 [get_ports {fscan_dop_clken[0]}]
  set_input_delay -add_delay -min -fall -clock fdop_preclk_grid[0]  37.3 [get_ports {fscan_dop_clken[0]}]
  set_annotated_transition -max -rise 50 [get_ports {fscan_dop_clken[0]}]
  set_annotated_transition -min -rise 25 [get_ports {fscan_dop_clken[0]}]
  set_annotated_transition -max -fall 50 [get_ports {fscan_dop_clken[0]}]
  set_annotated_transition -min -fall 25 [get_ports {fscan_dop_clken[0]}]
  set_max_capacitance 50 [get_ports {fscan_dop_clken[0]}]
  set_driving_cell -lib_cell ec0bfn000ac1n08x5  [get_ports {fscan_dop_clken[0]}]
} else {
  puts "Error: Port fscan_dop_clken[0] does not exist"
}

if { [sizeof_collection [get_ports -quiet {adop_postclk[5]}]] > 0 } {
  set_max_transition 50 [get_ports {adop_postclk[5]}]
  set_output_delay -add_delay -max -rise -clock fdop_preclk_grid[2]  121 [get_ports {adop_postclk[5]}]
  set_output_delay -add_delay -max -fall -clock fdop_preclk_grid[2]  121 [get_ports {adop_postclk[5]}]
  set_output_delay -add_delay -min -rise -clock fdop_preclk_grid[2]  22.1 [get_ports {adop_postclk[5]}]
  set_output_delay -add_delay -min -fall -clock fdop_preclk_grid[2]  22.1 [get_ports {adop_postclk[5]}]
  set_load -max 10 [get_ports {adop_postclk[5]}]
  set_load -min 5 [get_ports {adop_postclk[5]}]
  set_max_capacitance 10 [get_ports {adop_postclk[5]}] 
} else {
  puts "Error: Port adop_postclk[5] does not exist"
}

if { [sizeof_collection [get_ports -quiet {adop_postclk[4]}]] > 0 } {
  set_max_transition 50 [get_ports {adop_postclk[4]}]
  set_output_delay -add_delay -max -rise -clock fdop_preclk_grid[1]  121 [get_ports {adop_postclk[4]}]
  set_output_delay -add_delay -max -fall -clock fdop_preclk_grid[1]  121 [get_ports {adop_postclk[4]}]
  set_output_delay -add_delay -min -rise -clock fdop_preclk_grid[1]  22.1 [get_ports {adop_postclk[4]}]
  set_output_delay -add_delay -min -fall -clock fdop_preclk_grid[1]  22.1 [get_ports {adop_postclk[4]}]
  set_load -max 10 [get_ports {adop_postclk[4]}]
  set_load -min 5 [get_ports {adop_postclk[4]}]
  set_max_capacitance 10 [get_ports {adop_postclk[4]}] 
} else {
  puts "Error: Port adop_postclk[4] does not exist"
}
if { [sizeof_collection [get_ports -quiet {adop_postclk[3]}]] > 0 } {
  set_max_transition 50 [get_ports {adop_postclk[3]}]
  set_output_delay -add_delay -max -rise -clock fdop_preclk_grid[1]  121 [get_ports {adop_postclk[3]}]
  set_output_delay -add_delay -max -fall -clock fdop_preclk_grid[1]  121 [get_ports {adop_postclk[3]}]
  set_output_delay -add_delay -min -rise -clock fdop_preclk_grid[1]  22.1 [get_ports {adop_postclk[3]}]
  set_output_delay -add_delay -min -fall -clock fdop_preclk_grid[1]  22.1 [get_ports {adop_postclk[3]}]
  set_load -max 10 [get_ports {adop_postclk[3]}]
  set_load -min 5 [get_ports {adop_postclk[3]}]
  set_max_capacitance 10 [get_ports {adop_postclk[3]}] 
} else {
  puts "Error: Port adop_postclk[3] does not exist"
}
if { [sizeof_collection [get_ports -quiet {adop_postclk[2]}]] > 0 } {
  set_max_transition 50 [get_ports {adop_postclk[2]}]
  set_output_delay -add_delay -max -rise -clock fdop_preclk_grid[0]  121 [get_ports {adop_postclk[2]}]
  set_output_delay -add_delay -max -fall -clock fdop_preclk_grid[0]  121 [get_ports {adop_postclk[2]}]
  set_output_delay -add_delay -min -rise -clock fdop_preclk_grid[0]  22.1 [get_ports {adop_postclk[2]}]
  set_output_delay -add_delay -min -fall -clock fdop_preclk_grid[0]  22.1 [get_ports {adop_postclk[2]}]
  set_load -max 10 [get_ports {adop_postclk[2]}]
  set_load -min 5 [get_ports {adop_postclk[2]}]
  set_max_capacitance 10 [get_ports {adop_postclk[2]}] 
} else {
  puts "Error: Port adop_postclk[2] does not exist"
}

if { [sizeof_collection [get_ports -quiet {adop_postclk[1]}]] > 0 } {
  set_max_transition 50 [get_ports {adop_postclk[1]}]
  set_output_delay -add_delay -max -rise -clock fdop_preclk_grid[0]  121 [get_ports {adop_postclk[1]}]
  set_output_delay -add_delay -max -fall -clock fdop_preclk_grid[0]  121 [get_ports {adop_postclk[1]}]
  set_output_delay -add_delay -min -rise -clock fdop_preclk_grid[0]  22.1 [get_ports {adop_postclk[1]}]
  set_output_delay -add_delay -min -fall -clock fdop_preclk_grid[0]  22.1 [get_ports {adop_postclk[1]}]
  set_load -max 10 [get_ports {adop_postclk[1]}]
  set_load -min 5 [get_ports {adop_postclk[1]}]
  set_max_capacitance 10 [get_ports {adop_postclk[1]}] 
} else {
  puts "Error: Port adop_postclk[1] does not exist"
}

if { [sizeof_collection [get_ports -quiet {adop_postclk[0]}]] > 0 } {
  set_max_transition 50 [get_ports {adop_postclk[0]}]
  set_output_delay -add_delay -max -rise -clock fdop_preclk_grid[2]  121 [get_ports {adop_postclk[0]}]
  set_output_delay -add_delay -max -fall -clock fdop_preclk_grid[2]  121 [get_ports {adop_postclk[0]}]
  set_output_delay -add_delay -min -rise -clock fdop_preclk_grid[2]  22.1 [get_ports {adop_postclk[0]}]
  set_output_delay -add_delay -min -fall -clock fdop_preclk_grid[2]  22.1 [get_ports {adop_postclk[0]}]
  set_load -max 10 [get_ports {adop_postclk[0]}]
  set_load -min 5 [get_ports {adop_postclk[0]}]
  set_max_capacitance 10 [get_ports {adop_postclk[0]}] 
} else {
  puts "Error: Port adop_postclk[0] does not exist"
}
if { [sizeof_collection [get_ports -quiet {adop_postclk_free[5]}]] > 0 } {
  set_max_transition 50 [get_ports {adop_postclk_free[5]}]
  set_output_delay -add_delay -max -rise -clock fdop_preclk_grid[2]  121 [get_ports {adop_postclk_free[5]}]
  set_output_delay -add_delay -max -fall -clock fdop_preclk_grid[2]  121 [get_ports {adop_postclk_free[5]}]
  set_output_delay -add_delay -min -rise -clock fdop_preclk_grid[2]  22.1 [get_ports {adop_postclk_free[5]}]
  set_output_delay -add_delay -min -fall -clock fdop_preclk_grid[2]  22.1 [get_ports {adop_postclk_free[5]}]
  set_load -max 10 [get_ports {adop_postclk_free[5]}]
  set_load -min 5 [get_ports {adop_postclk_free[5]}]
  set_max_capacitance 10 [get_ports {adop_postclk_free[5]}] 
} else {
  puts "Error: Port adop_postclk_free[5] does not exist"
}

if { [sizeof_collection [get_ports -quiet {adop_postclk_free[4]}]] > 0 } {
  set_max_transition 50 [get_ports {adop_postclk_free[4]}]
  set_output_delay -add_delay -max -rise -clock fdop_preclk_grid[1]  121 [get_ports {adop_postclk_free[4]}]
  set_output_delay -add_delay -max -fall -clock fdop_preclk_grid[1]  121 [get_ports {adop_postclk_free[4]}]
  set_output_delay -add_delay -min -rise -clock fdop_preclk_grid[1]  22.1 [get_ports {adop_postclk_free[4]}]
  set_output_delay -add_delay -min -fall -clock fdop_preclk_grid[1]  22.1 [get_ports {adop_postclk_free[4]}]
  set_load -max 10 [get_ports {adop_postclk_free[4]}]
  set_load -min 5 [get_ports {adop_postclk_free[4]}]
  set_max_capacitance 10 [get_ports {adop_postclk_free[4]}] 
} else {
  puts "Error: Port adop_postclk_free[2] does not exist"
}
if { [sizeof_collection [get_ports -quiet {adop_postclk_free[3]}]] > 0 } {
  set_max_transition 50 [get_ports {adop_postclk_free[3]}]
  set_output_delay -add_delay -max -rise -clock fdop_preclk_grid[1]  121 [get_ports {adop_postclk_free[3]}]
  set_output_delay -add_delay -max -fall -clock fdop_preclk_grid[1]  121 [get_ports {adop_postclk_free[3]}]
  set_output_delay -add_delay -min -rise -clock fdop_preclk_grid[1]  22.1 [get_ports {adop_postclk_free[3]}]
  set_output_delay -add_delay -min -fall -clock fdop_preclk_grid[1]  22.1 [get_ports {adop_postclk_free[3]}]
  set_load -max 10 [get_ports {adop_postclk_free[3]}]
  set_load -min 5 [get_ports {adop_postclk_free[3]}]
  set_max_capacitance 10 [get_ports {adop_postclk_free[3]}] 
} else {
  puts "Error: Port adop_postclk_free[2] does not exist"
}
if { [sizeof_collection [get_ports -quiet {adop_postclk_free[2]}]] > 0 } {
  set_max_transition 50 [get_ports {adop_postclk_free[2]}]
  set_output_delay -add_delay -max -rise -clock fdop_preclk_grid[0]  121 [get_ports {adop_postclk_free[2]}]
  set_output_delay -add_delay -max -fall -clock fdop_preclk_grid[0]  121 [get_ports {adop_postclk_free[2]}]
  set_output_delay -add_delay -min -rise -clock fdop_preclk_grid[0]  22.1 [get_ports {adop_postclk_free[2]}]
  set_output_delay -add_delay -min -fall -clock fdop_preclk_grid[0]  22.1 [get_ports {adop_postclk_free[2]}]
  set_load -max 10 [get_ports {adop_postclk_free[2]}]
  set_load -min 5 [get_ports {adop_postclk_free[2]}]
  set_max_capacitance 10 [get_ports {adop_postclk_free[2]}] 
} else {
  puts "Error: Port adop_postclk_free[2] does not exist"
}
if { [sizeof_collection [get_ports -quiet {adop_postclk_free[1]}]] > 0 } {
  set_max_transition 50 [get_ports {adop_postclk_free[1]}]
  set_output_delay -add_delay -max -rise -clock fdop_preclk_grid[0]  121 [get_ports {adop_postclk_free[1]}]
  set_output_delay -add_delay -max -fall -clock fdop_preclk_grid[0]  121 [get_ports {adop_postclk_free[1]}]
  set_output_delay -add_delay -min -rise -clock fdop_preclk_grid[0]  22.1 [get_ports {adop_postclk_free[1]}]
  set_output_delay -add_delay -min -fall -clock fdop_preclk_grid[0]  22.1 [get_ports {adop_postclk_free[1]}]
  set_load -max 10 [get_ports {adop_postclk_free[1]}]
  set_load -min 5 [get_ports {adop_postclk_free[1]}]
  set_max_capacitance 10 [get_ports {adop_postclk_free[1]}] 
} else {
  puts "Error: Port adop_postclk_free[1] does not exist"
}

if { [sizeof_collection [get_ports -quiet {adop_postclk_free[0]}]] > 0 } {
  set_max_transition 50 [get_ports {adop_postclk_free[0]}]
  set_output_delay -add_delay -max -rise -clock fdop_preclk_grid[0]  121 [get_ports {adop_postclk_free[0]}]
  set_output_delay -add_delay -max -fall -clock fdop_preclk_grid[0]  121 [get_ports {adop_postclk_free[0]}]
  set_output_delay -add_delay -min -rise -clock fdop_preclk_grid[0]  22.1 [get_ports {adop_postclk_free[0]}]
  set_output_delay -add_delay -min -fall -clock fdop_preclk_grid[0]  22.1 [get_ports {adop_postclk_free[0]}]
  set_load -max 10 [get_ports {adop_postclk_free[0]}]
  set_load -min 5 [get_ports {adop_postclk_free[0]}]
  set_max_capacitance 10 [get_ports {adop_postclk_free[0]}] 
} else {
  puts "Error: Port adop_postclk_free[0] does not exist"
}

if { [sizeof_collection [get_ports -quiet {adop_postclk_nonscan}]] > 0 } {
  set_max_transition 50 [get_ports {adop_postclk_nonscan}]
  set_output_delay -add_delay -max -rise -clock fdop_preclk_grid[0]  121 [get_ports {adop_postclk_nonscan}]
  set_output_delay -add_delay -max -fall -clock fdop_preclk_grid[0]  121 [get_ports {adop_postclk_nonscan}]
  set_output_delay -add_delay -min -rise -clock fdop_preclk_grid[0]  22.1 [get_ports {adop_postclk_nonscan}]
  set_output_delay -add_delay -min -fall -clock fdop_preclk_grid[0]  22.1 [get_ports {adop_postclk_nonscan}]
  set_load -max 10 [get_ports {adop_postclk_nonscan}]
  set_load -min 5 [get_ports {adop_postclk_nonscan}]
  set_max_capacitance 10 [get_ports {adop_postclk_nonscan}] 
} else {
  puts "Error: Port adop_postclk_nonscan does not exist"
}


if { [sizeof_collection [get_ports -quiet {fpm_dop_clken[5]}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock fdop_preclk_grid[2]  221 [get_ports {fpm_dop_clken[5]}]
  set_input_delay -add_delay -max -fall -clock fdop_preclk_grid[2]  221 [get_ports {fpm_dop_clken[5]}]
  set_input_delay -add_delay -min -rise -clock fdop_preclk_grid[2]  37.3 [get_ports {fpm_dop_clken[5]}]
  set_input_delay -add_delay -min -fall -clock fdop_preclk_grid[2]  37.3 [get_ports {fpm_dop_clken[5]}]
  set_annotated_transition -max -rise 50 [get_ports {fpm_dop_clken[5]}]
  set_annotated_transition -min -rise 25 [get_ports {fpm_dop_clken[5]}]
  set_annotated_transition -max -fall 50 [get_ports {fpm_dop_clken[5]}]
  set_annotated_transition -min -fall 25 [get_ports {fpm_dop_clken[5]}]
  set_max_capacitance 50 [get_ports {fpm_dop_clken[5]}]
  set_driving_cell -lib_cell ec0bfn000ac1n08x5  [get_ports {fpm_dop_clken[5]}]
} else {
  puts "Error: Port fpm_dop_clken[5] does not exist"
}

if { [sizeof_collection [get_ports -quiet {fpm_dop_clken[4]}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock fdop_preclk_grid[1]  221 [get_ports {fpm_dop_clken[4]}]
  set_input_delay -add_delay -max -fall -clock fdop_preclk_grid[1]  221 [get_ports {fpm_dop_clken[4]}]
  set_input_delay -add_delay -min -rise -clock fdop_preclk_grid[1]  37.3 [get_ports {fpm_dop_clken[4]}]
  set_input_delay -add_delay -min -fall -clock fdop_preclk_grid[1]  37.3 [get_ports {fpm_dop_clken[4]}]
  set_annotated_transition -max -rise 50 [get_ports {fpm_dop_clken[4]}]
  set_annotated_transition -min -rise 25 [get_ports {fpm_dop_clken[4]}]
  set_annotated_transition -max -fall 50 [get_ports {fpm_dop_clken[4]}]
  set_annotated_transition -min -fall 25 [get_ports {fpm_dop_clken[4]}]
  set_max_capacitance 50 [get_ports {fpm_dop_clken[4]}]
  set_driving_cell -lib_cell ec0bfn000ac1n08x5  [get_ports {fpm_dop_clken[4]}]
} else {
  puts "Error: Port fpm_dop_clken[4] does not exist"
}

if { [sizeof_collection [get_ports -quiet {fpm_dop_clken[3]}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock fdop_preclk_grid[1]  221 [get_ports {fpm_dop_clken[3]}]
  set_input_delay -add_delay -max -fall -clock fdop_preclk_grid[1]  221 [get_ports {fpm_dop_clken[3]}]
  set_input_delay -add_delay -min -rise -clock fdop_preclk_grid[1]  37.3 [get_ports {fpm_dop_clken[3]}]
  set_input_delay -add_delay -min -fall -clock fdop_preclk_grid[1]  37.3 [get_ports {fpm_dop_clken[3]}]
  set_annotated_transition -max -rise 50 [get_ports {fpm_dop_clken[3]}]
  set_annotated_transition -min -rise 25 [get_ports {fpm_dop_clken[3]}]
  set_annotated_transition -max -fall 50 [get_ports {fpm_dop_clken[3]}]
  set_annotated_transition -min -fall 25 [get_ports {fpm_dop_clken[3]}]
  set_max_capacitance 50 [get_ports {fpm_dop_clken[3]}]
  set_driving_cell -lib_cell ec0bfn000ac1n08x5  [get_ports {fpm_dop_clken[3]}]
} else {
  puts "Error: Port fpm_dop_clken[3] does not exist"
}

if { [sizeof_collection [get_ports -quiet {fpm_dop_clken[2]}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock fdop_preclk_grid[0]  221 [get_ports {fpm_dop_clken[2]}]
  set_input_delay -add_delay -max -fall -clock fdop_preclk_grid[0]  221 [get_ports {fpm_dop_clken[2]}]
  set_input_delay -add_delay -min -rise -clock fdop_preclk_grid[0]  37.3 [get_ports {fpm_dop_clken[2]}]
  set_input_delay -add_delay -min -fall -clock fdop_preclk_grid[0]  37.3 [get_ports {fpm_dop_clken[2]}]
  set_annotated_transition -max -rise 50 [get_ports {fpm_dop_clken[2]}]
  set_annotated_transition -min -rise 25 [get_ports {fpm_dop_clken[2]}]
  set_annotated_transition -max -fall 50 [get_ports {fpm_dop_clken[2]}]
  set_annotated_transition -min -fall 25 [get_ports {fpm_dop_clken[2]}]
  set_max_capacitance 50 [get_ports {fpm_dop_clken[2]}]
  set_driving_cell -lib_cell ec0bfn000ac1n08x5  [get_ports {fpm_dop_clken[2]}]
} else {
  puts "Error: Port fpm_dop_clken[2] does not exist"
}
if { [sizeof_collection [get_ports -quiet {fpm_dop_clken[1]}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock fdop_preclk_grid[0]  221 [get_ports {fpm_dop_clken[1]}]
  set_input_delay -add_delay -max -fall -clock fdop_preclk_grid[0]  221 [get_ports {fpm_dop_clken[1]}]
  set_input_delay -add_delay -min -rise -clock fdop_preclk_grid[0]  37.3 [get_ports {fpm_dop_clken[1]}]
  set_input_delay -add_delay -min -fall -clock fdop_preclk_grid[0]  37.3 [get_ports {fpm_dop_clken[1]}]
  set_annotated_transition -max -rise 50 [get_ports {fpm_dop_clken[1]}]
  set_annotated_transition -min -rise 25 [get_ports {fpm_dop_clken[1]}]
  set_annotated_transition -max -fall 50 [get_ports {fpm_dop_clken[1]}]
  set_annotated_transition -min -fall 25 [get_ports {fpm_dop_clken[1]}]
  set_max_capacitance 50 [get_ports {fpm_dop_clken[1]}]
  set_driving_cell -lib_cell ec0bfn000ac1n08x5  [get_ports {fpm_dop_clken[1]}]
} else {
  puts "Error: Port fpm_dop_clken[1] does not exist"
}
if { [sizeof_collection [get_ports -quiet {fpm_dop_clken[0]}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock fdop_preclk_grid[0]  221 [get_ports {fpm_dop_clken[0]}]
  set_input_delay -add_delay -max -fall -clock fdop_preclk_grid[0]  221 [get_ports {fpm_dop_clken[0]}]
  set_input_delay -add_delay -min -rise -clock fdop_preclk_grid[0]  37.3 [get_ports {fpm_dop_clken[0]}]
  set_input_delay -add_delay -min -fall -clock fdop_preclk_grid[0]  37.3 [get_ports {fpm_dop_clken[0]}]
  set_annotated_transition -max -rise 50 [get_ports {fpm_dop_clken[0]}]
  set_annotated_transition -min -rise 25 [get_ports {fpm_dop_clken[0]}]
  set_annotated_transition -max -fall 50 [get_ports {fpm_dop_clken[0]}]
  set_annotated_transition -min -fall 25 [get_ports {fpm_dop_clken[0]}]
  set_max_capacitance 50 [get_ports {fpm_dop_clken[0]}]
  set_driving_cell -lib_cell ec0bfn000ac1n08x5  [get_ports {fpm_dop_clken[0]}]
} else {
  puts "Error: Port fpm_dop_clken[0] does not exist"
}
if { [sizeof_collection [get_ports -quiet {fpm_preclk_div_sync[2]}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock fdop_preclk_grid[2]  221 [get_ports {fpm_preclk_div_sync[2]}]
  set_input_delay -add_delay -max -fall -clock fdop_preclk_grid[2]  221 [get_ports {fpm_preclk_div_sync[2]}]
  set_input_delay -add_delay -min -rise -clock fdop_preclk_grid[2]  37.3 [get_ports {fpm_preclk_div_sync[2]}]
  set_input_delay -add_delay -min -fall -clock fdop_preclk_grid[2]  37.3 [get_ports {fpm_preclk_div_sync[2]}]
  set_annotated_transition -max -rise 50 [get_ports {fpm_preclk_div_sync[2]}]
  set_annotated_transition -min -rise 25 [get_ports {fpm_preclk_div_sync[2]}]
  set_annotated_transition -max -fall 50 [get_ports {fpm_preclk_div_sync[2]}]
  set_annotated_transition -min -fall 25 [get_ports {fpm_preclk_div_sync[2]}]
  set_max_capacitance 50 [get_ports {fpm_preclk_div_sync[2]}]
  set_driving_cell -lib_cell ec0bfn000ac1n08x5  [get_ports {fpm_preclk_div_sync[2]}]
} else {
  puts "Error: Port fpm_preclk_div_sync[2] does not exist"
}

if { [sizeof_collection [get_ports -quiet {fpm_preclk_div_sync[1]}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock fdop_preclk_grid[1]  221 [get_ports {fpm_preclk_div_sync[1]}]
  set_input_delay -add_delay -max -fall -clock fdop_preclk_grid[1]  221 [get_ports {fpm_preclk_div_sync[1]}]
  set_input_delay -add_delay -min -rise -clock fdop_preclk_grid[1]  37.3 [get_ports {fpm_preclk_div_sync[1]}]
  set_input_delay -add_delay -min -fall -clock fdop_preclk_grid[1]  37.3 [get_ports {fpm_preclk_div_sync[1]}]
  set_annotated_transition -max -rise 50 [get_ports {fpm_preclk_div_sync[1]}]
  set_annotated_transition -min -rise 25 [get_ports {fpm_preclk_div_sync[1]}]
  set_annotated_transition -max -fall 50 [get_ports {fpm_preclk_div_sync[1]}]
  set_annotated_transition -min -fall 25 [get_ports {fpm_preclk_div_sync[1]}]
  set_max_capacitance 50 [get_ports {fpm_preclk_div_sync[1]}]
  set_driving_cell -lib_cell ec0bfn000ac1n08x5  [get_ports {fpm_preclk_div_sync[1]}]
} else {
  puts "Error: Port fpm_preclk_div_sync[1] does not exist"
}

if { [sizeof_collection [get_ports -quiet {fpm_preclk_div_sync[0]}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock fdop_preclk_grid[0]  221 [get_ports {fpm_preclk_div_sync[0]}]
  set_input_delay -add_delay -max -fall -clock fdop_preclk_grid[0]  221 [get_ports {fpm_preclk_div_sync[0]}]
  set_input_delay -add_delay -min -rise -clock fdop_preclk_grid[0]  37.3 [get_ports {fpm_preclk_div_sync[0]}]
  set_input_delay -add_delay -min -fall -clock fdop_preclk_grid[0]  37.3 [get_ports {fpm_preclk_div_sync[0]}]
  set_annotated_transition -max -rise 50 [get_ports {fpm_preclk_div_sync[0]}]
  set_annotated_transition -min -rise 25 [get_ports {fpm_preclk_div_sync[0]}]
  set_annotated_transition -max -fall 50 [get_ports {fpm_preclk_div_sync[0]}]
  set_annotated_transition -min -fall 25 [get_ports {fpm_preclk_div_sync[0]}]
  set_max_capacitance 50 [get_ports {fpm_preclk_div_sync[0]}]
  set_driving_cell -lib_cell ec0bfn000ac1n08x5  [get_ports {fpm_preclk_div_sync[0]}]
} else {
  puts "Error: Port fpm_preclk_div_sync[0] does not exist"
}
if { [sizeof_collection [get_ports -quiet {fscan_mode}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock fdop_preclk_grid[0]  221 [get_ports {fscan_mode}]
  set_input_delay -add_delay -max -fall -clock fdop_preclk_grid[0]  221 [get_ports {fscan_mode}]
  set_input_delay -add_delay -min -rise -clock fdop_preclk_grid[0]  37.3 [get_ports {fscan_mode}]
  set_input_delay -add_delay -min -fall -clock fdop_preclk_grid[0]  37.3 [get_ports {fscan_mode}]
  set_annotated_transition -max -rise 50 [get_ports {fscan_mode}]
  set_annotated_transition -min -rise 25 [get_ports {fscan_mode}]
  set_annotated_transition -max -fall 50 [get_ports {fscan_mode}]
  set_annotated_transition -min -fall 25 [get_ports {fscan_mode}]
  set_max_capacitance 50 [get_ports {fscan_mode}]
  set_driving_cell -lib_cell ec0bfn000ac1n08x5  [get_ports {fscan_mode}]
} else {
  puts "Error: Port fscan_mode does not exist"
}
if { [sizeof_collection [get_ports -quiet {fscan_rpt_clk}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock fscan_rpt_clk  221 [get_ports {fscan_rpt_clk}]
  set_input_delay -add_delay -max -fall -clock fscan_rpt_clk  221 [get_ports {fscan_rpt_clk}]
  set_input_delay -add_delay -min -rise -clock fscan_rpt_clk  37.3 [get_ports {fscan_rpt_clk}]
  set_input_delay -add_delay -min -fall -clock fscan_rpt_clk  37.3 [get_ports {fscan_rpt_clk}]
  set_annotated_transition -max -rise 50 [get_ports {fscan_rpt_clk}]
  set_annotated_transition -min -rise 25 [get_ports {fscan_rpt_clk}]
  set_annotated_transition -max -fall 50 [get_ports {fscan_rpt_clk}]
  set_annotated_transition -min -fall 25 [get_ports {fscan_rpt_clk}]
  set_max_capacitance 50 [get_ports {fscan_rpt_clk}]
  set_driving_cell -lib_cell ec0bfn000ac1n08x5  [get_ports {fscan_rpt_clk}]
} else {
  puts "Error: Port fscan_rpt_clk does not exist"
}
