set_max_transition 93 [current_design]
set_max_fanout 50 [current_design]

if { [sizeof_collection [get_ports -quiet {iclk}]] > 0 } {
  set_annotated_transition -max -rise 50 [get_ports {iclk}]
  set_annotated_transition -min -rise 25 [get_ports {iclk}]
  set_annotated_transition -max -fall 50 [get_ports {iclk}]
  set_annotated_transition -min -fall 25 [get_ports {iclk}]
  set_max_capacitance 50 [get_ports {iclk}]
  set_driving_cell -lib_cell ec0bfn000ac1n08x5 [get_ports {iclk}]
} else {
  puts "Error: Port iclk does not exist"
}

if { [sizeof_collection [get_ports -quiet {rst_b}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock iclk  221 [get_ports {rst_b}]
  set_input_delay -add_delay -max -fall -clock iclk  221 [get_ports {rst_b}]
  set_input_delay -add_delay -min -rise -clock iclk  37.3 [get_ports {rst_b}]
  set_input_delay -add_delay -min -fall -clock iclk  37.3 [get_ports {rst_b}]
  set_annotated_transition -max -rise 50 [get_ports {rst_b}]
  set_annotated_transition -min -rise 25 [get_ports {rst_b}]
  set_annotated_transition -max -fall 50 [get_ports {rst_b}]
  set_annotated_transition -min -fall 25 [get_ports {rst_b}]
  set_max_capacitance 50 [get_ports {rst_b}]
  set_driving_cell -lib_cell ec0bfn000ac1n08x5 [get_ports {rst_b}]
} else {
  puts "Error: Port rst_b does not exist"
}


if { [sizeof_collection [get_ports -quiet {oclkmreq}]] > 0 } {
  set_max_transition 50 [get_ports {oclkmreq}]
  set_output_delay -add_delay -max -rise -clock iclk  121 [get_ports {oclkmreq}]
  set_output_delay -add_delay -max -fall -clock iclk  121 [get_ports {oclkmreq}]
  set_output_delay -add_delay -min -rise -clock iclk  22.1 [get_ports {oclkmreq}]
  set_output_delay -add_delay -min -fall -clock iclk  22.1 [get_ports {oclkmreq}]
  set_load -max 10 [get_ports {oclkmreq}]
  set_load -min 5 [get_ports {oclkmreq}]
  set_max_capacitance 10 [get_ports {oclkmreq}]
} else {
  puts "Error: Port oclkmreq does not exist"
}


if { [sizeof_collection [get_ports -quiet {iclkmack}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock iclk  221 [get_ports {iclkmack}]
  set_input_delay -add_delay -max -fall -clock iclk  221 [get_ports {iclkmack}]
  set_input_delay -add_delay -min -rise -clock iclk  37.3 [get_ports {iclkmack}]
  set_input_delay -add_delay -min -fall -clock iclk  37.3 [get_ports {iclkmack}]
  set_annotated_transition -max -rise 50 [get_ports {iclkmack}]
  set_annotated_transition -min -rise 25 [get_ports {iclkmack}]
  set_annotated_transition -max -fall 50 [get_ports {iclkmack}]
  set_annotated_transition -min -fall 25 [get_ports {iclkmack}]
  set_max_capacitance 50 [get_ports {iclkmack}]
  set_driving_cell -lib_cell ec0bfn000ac1n08x5 [get_ports {iclkmack}]
} else {
  puts "Error: Port iclkmack does not exist"
}

if { [sizeof_collection [get_ports -quiet {iclkreq[1]}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock iclk  221 [get_ports {iclkreq[1]}]
  set_input_delay -add_delay -max -fall -clock iclk  221 [get_ports {iclkreq[1]}]
  set_input_delay -add_delay -min -rise -clock iclk  37.3 [get_ports {iclkreq[1]}]
  set_input_delay -add_delay -min -fall -clock iclk  37.3 [get_ports {iclkreq[1]}]
  set_annotated_transition -max -rise 50 [get_ports {iclkreq[1]}]
  set_annotated_transition -min -rise 25 [get_ports {iclkreq[1]}]
  set_annotated_transition -max -fall 50 [get_ports {iclkreq[1]}]
  set_annotated_transition -min -fall 25 [get_ports {iclkreq[1]}]
  set_max_capacitance 50 [get_ports {iclkreq[1]}]
  set_driving_cell -lib_cell ec0bfn000ac1n08x5 [get_ports {iclkreq[1]}]
} else {
  puts "Error: Port iclkreq[1] does not exist"
}

if { [sizeof_collection [get_ports -quiet {iclkreq[0]}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock iclk  221 [get_ports {iclkreq[0]}]
  set_input_delay -add_delay -max -fall -clock iclk  221 [get_ports {iclkreq[0]}]
  set_input_delay -add_delay -min -rise -clock iclk  37.3 [get_ports {iclkreq[0]}]
  set_input_delay -add_delay -min -fall -clock iclk  37.3 [get_ports {iclkreq[0]}]
  set_annotated_transition -max -rise 50 [get_ports {iclkreq[0]}]
  set_annotated_transition -min -rise 25 [get_ports {iclkreq[0]}]
  set_annotated_transition -max -fall 50 [get_ports {iclkreq[0]}]
  set_annotated_transition -min -fall 25 [get_ports {iclkreq[0]}]
  set_max_capacitance 50 [get_ports {iclkreq[0]}]
  set_driving_cell -lib_cell ec0bfn000ac1n08x5 [get_ports {iclkreq[0]}]
} else {
  puts "Error: Port iclkreq[0] does not exist"
}

if { [sizeof_collection [get_ports -quiet {oclkack[0]}]] > 0 } {
  set_max_transition 50 [get_ports {oclkack[0]}]
  set_output_delay -add_delay -max -rise -clock iclk  121 [get_ports {oclkack[0]}]
  set_output_delay -add_delay -max -fall -clock iclk  121 [get_ports {oclkack[0]}]
  set_output_delay -add_delay -min -rise -clock iclk  22.1 [get_ports {oclkack[0]}]
  set_output_delay -add_delay -min -fall -clock iclk  22.1 [get_ports {oclkack[0]}]
  set_load -max 10 [get_ports {oclkack[0]}]
  set_load -min 5 [get_ports {oclkack[0]}]
  set_max_capacitance 10 [get_ports {oclkack[0]}] 
} else {
  puts "Error: Port oclkack[0] does not exist"
}
if { [sizeof_collection [get_ports -quiet {oclkack[1]}]] > 0 } {
  set_max_transition 50 [get_ports {oclkack[1]}]
  set_output_delay -add_delay -max -rise -clock iclk  121 [get_ports {oclkack[1]}]
  set_output_delay -add_delay -max -fall -clock iclk  121 [get_ports {oclkack[1]}]
  set_output_delay -add_delay -min -rise -clock iclk  22.1 [get_ports {oclkack[1]}]
  set_output_delay -add_delay -min -fall -clock iclk  22.1 [get_ports {oclkack[1]}]
  set_load -max 10 [get_ports {oclkack[1]}]
  set_load -min 5 [get_ports {oclkack[1]}]
  set_max_capacitance 10 [get_ports {oclkack[1]}]
 } else {
  puts "Error: Port oclkack[0] does not exist"
}


