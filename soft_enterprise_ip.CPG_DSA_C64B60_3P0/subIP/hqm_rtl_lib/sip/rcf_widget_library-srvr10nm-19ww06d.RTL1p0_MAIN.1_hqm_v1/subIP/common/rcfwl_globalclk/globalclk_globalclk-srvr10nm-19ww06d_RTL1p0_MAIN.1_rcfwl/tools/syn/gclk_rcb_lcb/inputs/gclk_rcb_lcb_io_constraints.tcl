set_max_transition 93 [current_design]
set_max_fanout 50 [current_design]

if { [sizeof_collection [get_ports -quiet {clk}]] > 0 } {
  set_annotated_transition -max -rise 50 [get_ports {clk}]
  set_annotated_transition -min -rise 25 [get_ports {clk}]
  set_annotated_transition -max -fall 50 [get_ports {clk}]
  set_annotated_transition -min -fall 25 [get_ports {clk}]
  set_max_capacitance 50 [get_ports {clk}]
  set_driving_cell -lib_cell ec0bfn000ac1n08x5 [get_ports {clk}]
} else {
  puts "Error: Port clk does not exist"
}



if { [sizeof_collection [get_ports -quiet {clkout}]] > 0 } {
  set_max_transition 50 [get_ports {clkout}]
  set_output_delay -add_delay -max -rise -clock clk  121 [get_ports {clkout}]
  set_output_delay -add_delay -max -fall -clock clk 121 [get_ports {clkout}]
  set_output_delay -add_delay -min -rise -clock clk  22.1 [get_ports {clkout}]
  set_output_delay -add_delay -min -fall -clock clk  22.1 [get_ports {clkout}]
  set_load -max 10 [get_ports {clkout}]
  set_load -min 5 [get_ports {clkout}]
  set_max_capacitance 10 [get_ports {clkout}]
} else {
  puts "Error: Port clkout does not exist"
}



