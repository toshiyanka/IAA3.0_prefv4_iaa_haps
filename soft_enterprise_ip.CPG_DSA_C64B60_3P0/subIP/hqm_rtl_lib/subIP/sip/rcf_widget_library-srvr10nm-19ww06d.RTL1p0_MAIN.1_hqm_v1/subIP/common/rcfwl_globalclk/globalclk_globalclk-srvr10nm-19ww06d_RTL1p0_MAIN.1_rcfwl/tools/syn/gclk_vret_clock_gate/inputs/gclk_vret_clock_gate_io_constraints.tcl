set_max_transition 93 [current_design]
set_max_fanout 50 [current_design]



if { [sizeof_collection [get_ports -quiet {clk_in}]] > 0 } {
  set_annotated_transition -max -rise 50 [get_ports {clk_in}]
  set_annotated_transition -min -rise 25 [get_ports {clk_in}]
  set_annotated_transition -max -fall 50 [get_ports {clk_in}]
  set_annotated_transition -min -fall 25 [get_ports {clk_in}]
  set_max_capacitance 50 [get_ports {clk_in}]
  set_driving_cell -lib_cell ec0bfn000ac1n08x5 [get_ports {clk_in}]
} else {
  puts "Error: Port clk_in_in does not exist"
}
if { [sizeof_collection [get_ports -quiet {fscan_mode}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock clk_in 221 [get_ports {fscan_mode}]
  set_input_delay -add_delay -max -fall -clock clk_in  221 [get_ports {fscan_mode}]
  set_input_delay -add_delay -min -rise -clock clk_in  37.3 [get_ports {fscan_mode}]
  set_input_delay -add_delay -min -fall -clock clk_in  37.3 [get_ports {fscan_mode}]
  set_annotated_transition -max -rise 50 [get_ports {fscan_mode}]
  set_annotated_transition -min -rise 25 [get_ports {fscan_mode}]
  set_annotated_transition -max -fall 50 [get_ports {fscan_mode}]
  set_annotated_transition -min -fall 25 [get_ports {fscan_mode}]
  set_max_capacitance 50 [get_ports {fscan_mode}]
  set_driving_cell -lib_cell ec0bfn000ac1n08x5 [get_ports {fscan_mode}]
} else {
  puts "Error: Port fscan_mode does not exist"
}




if { [sizeof_collection [get_ports -quiet {vret_iso_b}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock clk_in 221 [get_ports {vret_iso_b}]
  set_input_delay -add_delay -max -fall -clock clk_in  221 [get_ports {vret_iso_b}]
  set_input_delay -add_delay -min -rise -clock clk_in  37.3 [get_ports {vret_iso_b}]
  set_input_delay -add_delay -min -fall -clock clk_in  37.3 [get_ports {vret_iso_b}]
  set_annotated_transition -max -rise 50 [get_ports {vret_iso_b}]
  set_annotated_transition -min -rise 25 [get_ports {vret_iso_b}]
  set_annotated_transition -max -fall 50 [get_ports {vret_iso_b}]
  set_annotated_transition -min -fall 25 [get_ports {vret_iso_b}]
  set_max_capacitance 50 [get_ports {vret_iso_b}]
  set_driving_cell -lib_cell ec0bfn000ac1n08x5 [get_ports {vret_iso_b}]
} else {
  puts "Error: Port vret_iso_b does not exist"
}


if { [sizeof_collection [get_ports -quiet {clk_out}]] > 0 } {
  set_max_transition 50 [get_ports {clk_out}]
  set_output_delay -add_delay -max -rise -clock clk_in 121 [get_ports {clk_out}]
  set_output_delay -add_delay -max -fall -clock clk_in  121 [get_ports {clk_out}]
  set_output_delay -add_delay -min -rise -clock clk_in  22.1 [get_ports {clk_out}]
  set_output_delay -add_delay -min -fall -clock clk_in  22.1 [get_ports {clk_out}]
  set_load -max 10 [get_ports {clk_out}]
  set_load -min 5 [get_ports {clk_out}]
  set_max_capacitance 10 [get_ports {clk_out}] 
} else {
  puts "Error: Port clk_out does not exist"
}




