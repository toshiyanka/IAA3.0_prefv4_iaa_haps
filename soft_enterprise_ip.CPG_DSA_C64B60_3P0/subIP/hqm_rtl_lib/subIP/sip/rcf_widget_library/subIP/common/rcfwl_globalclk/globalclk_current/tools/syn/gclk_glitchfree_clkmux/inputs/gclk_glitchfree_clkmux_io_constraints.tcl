set_max_transition 93 [current_design]
set_max_fanout 50 [current_design]

if { [sizeof_collection [get_ports -quiet {agentclk}]] > 0 } {
  set_annotated_transition -max -rise 50 [get_ports {agentclk}]
  set_annotated_transition -min -rise 25 [get_ports {agentclk}]
  set_annotated_transition -max -fall 50 [get_ports {agentclk}]
  set_annotated_transition -min -fall 25 [get_ports {agentclk}]
  set_max_capacitance 50 [get_ports {agentclk}]
  set_driving_cell -lib_cell ec0bfn000ac1n08x5 [get_ports {agentclk}]
} else {
  puts "Error: Port x12clk_in does not exist"
}

if { [sizeof_collection [get_ports -quiet {x12clk}]] > 0 } {
  set_annotated_transition -max -rise 50 [get_ports {x12clk}]
  set_annotated_transition -min -rise 25 [get_ports {x12clk}]
  set_annotated_transition -max -fall 50 [get_ports {x12clk}]
  set_annotated_transition -min -fall 25 [get_ports {x12clk}]
  set_max_capacitance 50 [get_ports {x12clk}]
  set_driving_cell -lib_cell ec0bfn000ac1n08x5 [get_ports {x12clk}]
} else {
  puts "Error: Port x12clk_in does not exist"
}
if { [sizeof_collection [get_ports -quiet {x12clk_sync}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock x12clk 221 [get_ports {x12clk_sync}]
  set_input_delay -add_delay -max -fall -clock x12clk  221 [get_ports {x12clk_sync}]
  set_input_delay -add_delay -min -rise -clock x12clk  37.3 [get_ports {x12clk_sync}]
  set_input_delay -add_delay -min -fall -clock x12clk  37.3 [get_ports {x12clk_sync}]
  set_annotated_transition -max -rise 50 [get_ports {x12clk_sync}]
  set_annotated_transition -min -rise 25 [get_ports {x12clk_sync}]
  set_annotated_transition -max -fall 50 [get_ports {x12clk_sync}]
  set_annotated_transition -min -fall 25 [get_ports {x12clk_sync}]
  set_max_capacitance 50 [get_ports {x12clk_sync}]
  set_driving_cell -lib_cell ec0bfn000ac1n08x5 [get_ports {x12clk_sync}]
} else {
  puts "Error: Port x12clk_sync does not exist"
}


if { [sizeof_collection [get_ports -quiet {agentclk_sync}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock agentclk 221 [get_ports {agentclk_sync}]
  set_input_delay -add_delay -max -fall -clock agentclk  221 [get_ports {agentclk_sync}]
  set_input_delay -add_delay -min -rise -clock agentclk  37.3 [get_ports {agentclk_sync}]
  set_input_delay -add_delay -min -fall -clock agentclk  37.3 [get_ports {agentclk_sync}]
  set_annotated_transition -max -rise 50 [get_ports {agentclk_sync}]
  set_annotated_transition -min -rise 25 [get_ports {agentclk_sync}]
  set_annotated_transition -max -fall 50 [get_ports {agentclk_sync}]
  set_annotated_transition -min -fall 25 [get_ports {agentclk_sync}]
  set_max_capacitance 50 [get_ports {agentclk_sync}]
  set_driving_cell -lib_cell ec0bfn000ac1n08x5 [get_ports {agentclk_sync}]
} else {
  puts "Error: Port agentclk_sync does not exist"
}

if { [sizeof_collection [get_ports -quiet {iso_b}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock x12clk 221 [get_ports {iso_b}]
  set_input_delay -add_delay -max -fall -clock x12clk  221 [get_ports {iso_b}]
  set_input_delay -add_delay -min -rise -clock x12clk  37.3 [get_ports {iso_b}]
  set_input_delay -add_delay -min -fall -clock x12clk  37.3 [get_ports {iso_b}]
  set_annotated_transition -max -rise 50 [get_ports {iso_b}]
  set_annotated_transition -min -rise 25 [get_ports {iso_b}]
  set_annotated_transition -max -fall 50 [get_ports {iso_b}]
  set_annotated_transition -min -fall 25 [get_ports {iso_b}]
  set_max_capacitance 50 [get_ports {iso_b}]
  set_driving_cell -lib_cell ec0bfn000ac1n08x5 [get_ports {iso_b}]
} else {
  puts "Error: Port iso_b does not exist"
}

if { [sizeof_collection [get_ports -quiet {sync_out}]] > 0 } {
  set_max_transition 50 [get_ports {sync_out}]
  set_output_delay -add_delay -max -rise -clock x12clk 121 [get_ports {sync_out}]
  set_output_delay -add_delay -max -fall -clock x12clk 121 [get_ports {sync_out}]
  set_output_delay -add_delay -min -rise -clock x12clk  22.1 [get_ports {sync_out}]
  set_output_delay -add_delay -min -fall -clock x12clk 22.1 [get_ports {sync_out}]
  set_load -max 10 [get_ports {sync_out}]
  set_load -min 5 [get_ports {sync_out}]
  set_max_capacitance 10 [get_ports {sync_out}] 
} else {
  puts "Error: Port sync_out does not exist"
}

if { [sizeof_collection [get_ports -quiet {clk_out}]] > 0 } {
  set_max_transition 50 [get_ports {clk_out}]
  set_output_delay -add_delay -max -rise -clock x12clk 121 [get_ports {clk_out}]
  set_output_delay -add_delay -max -fall -clock x12clk  121 [get_ports {clk_out}]
  set_output_delay -add_delay -min -rise -clock x12clk  22.1 [get_ports {clk_out}]
  set_output_delay -add_delay -min -fall -clock x12clk  22.1 [get_ports {clk_out}]
  set_load -max 10 [get_ports {clk_out}]
  set_load -min 5 [get_ports {clk_out}]
  set_max_capacitance 10 [get_ports {clk_out}] 
} else {
  puts "Error: Port clk_out does not exist"
}




