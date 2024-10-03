set_max_transition 93 [current_design]
set_max_fanout 50 [current_design]

if { [sizeof_collection [get_ports -quiet {x12clk_in}]] > 0 } {
  set_annotated_transition -max -rise 50 [get_ports {x12clk_in}]
  set_annotated_transition -min -rise 25 [get_ports {x12clk_in}]
  set_annotated_transition -max -fall 50 [get_ports {x12clk_in}]
  set_annotated_transition -min -fall 25 [get_ports {x12clk_in}]
  set_max_capacitance 50 [get_ports {x12clk_in}]
  set_driving_cell -lib_cell ec0bfn000ac1n08x5  [get_ports {x12clk_in}]
} else {
  puts "Error: Port x12clk_in does not exist"
}
if { [sizeof_collection [get_ports -quiet {ck_crystal_in}]] > 0 } {
  set_annotated_transition -max -rise 50 [get_ports {ck_crystal_in}]
  set_annotated_transition -min -rise 25 [get_ports {ck_crystal_in}]
  set_annotated_transition -max -fall 50 [get_ports {ck_crystal_in}]
  set_annotated_transition -min -fall 25 [get_ports {ck_crystal_in}]
  set_max_capacitance 50 [get_ports {ck_crystal_in}]
  set_driving_cell -lib_cell ec0bfn000ac1n08x5  [get_ports {ck_crystal_in}]
} else {
  puts "Error: Port  ck_crystal_in does not exist"
}
if { [sizeof_collection [get_ports -quiet {x12clksync_in}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock x12clk_in  221 [get_ports {x12clksync_in}]
  set_input_delay -add_delay -max -fall -clock x12clk_in  221 [get_ports {x12clksync_in}]
  set_input_delay -add_delay -min -rise -clock x12clk_in  37.3 [get_ports {x12clksync_in}]
  set_input_delay -add_delay -min -fall -clock x12clk_in  37.3 [get_ports {x12clksync_in}]
  set_annotated_transition -max -rise 50 [get_ports {x12clksync_in}]
  set_annotated_transition -min -rise 25 [get_ports {x12clksync_in}]
  set_annotated_transition -max -fall 50 [get_ports {x12clksync_in}]
  set_annotated_transition -min -fall 25 [get_ports {x12clksync_in}]
  set_max_capacitance 50 [get_ports {x12clksync_in}]
  set_driving_cell -lib_cell ec0bfn000ac1n08x5  [get_ports {x12clksync_in}]
} else {
  puts "Error: Port x12clksync_in does not exist"
}

if { [sizeof_collection [get_ports -quiet {x12clk_out}]] > 0 } {
  set_max_transition 50 [get_ports {x12clk_out}]
  set_output_delay -add_delay -max -rise -clock x12clk_in  121 [get_ports {x12clk_out}]
  set_output_delay -add_delay -max -fall -clock x12clk_in  121 [get_ports {x12clk_out}]
  set_output_delay -add_delay -min -rise -clock x12clk_in  22.1 [get_ports {x12clk_out}]
  set_output_delay -add_delay -min -fall -clock x12clk_in  22.1 [get_ports {x12clk_out}]
  set_load -max 10 [get_ports {x12clk_out}]
  set_load -min 5 [get_ports {x12clk_out}]
  set_max_capacitance 10 [get_ports {x12clk_out}] 
} else {
  puts "Error: Port x12clk_out does not exist"
}

if { [sizeof_collection [get_ports -quiet {x12clk_sync_out}]] > 0 } {
  set_max_transition 50 [get_ports {x12clk_sync_out}]
  set_output_delay -add_delay -max -rise -clock x12clk_in  121 [get_ports {x12clk_sync_out}]
  set_output_delay -add_delay -max -fall -clock x12clk_in  121 [get_ports {x12clk_sync_out}]
  set_output_delay -add_delay -min -rise -clock x12clk_in  22.1 [get_ports {x12clk_sync_out}]
  set_output_delay -add_delay -min -fall -clock x12clk_in  22.1 [get_ports {x12clk_sync_out}]
  set_load -max 10 [get_ports {x12clk_sync_out}]
  set_load -min 5 [get_ports {x12clk_sync_out}]
  set_max_capacitance 10 [get_ports {x12clk_sync_out}]
} else {
  puts "Error: Port x12clk_sync_out does not exist"
}

if { [sizeof_collection [get_ports -quiet {x4clk_sync_out}]] > 0 } {
  set_max_transition 50 [get_ports {x4clk_sync_out}]
  set_output_delay -add_delay -max -rise -clock x12clk_in  121 [get_ports {x4clk_sync_out}]
  set_output_delay -add_delay -max -fall -clock x12clk_in  121 [get_ports {x4clk_sync_out}]
  set_output_delay -add_delay -min -rise -clock x12clk_in  22.1 [get_ports {x4clk_sync_out}]
  set_output_delay -add_delay -min -fall -clock x12clk_in  22.1 [get_ports {x4clk_sync_out}]
  set_load -max 10 [get_ports {x4clk_sync_out}]
  set_load -min 5 [get_ports {x4clk_sync_out}]
  set_max_capacitance 10 [get_ports {x4clk_sync_out}]
} else {
  puts "Error: Port x4clk_sync_out does not exist"
}

if { [sizeof_collection [get_ports -quiet {x4clk_out}]] > 0 } {
  set_max_transition 50 [get_ports {x4clk_out}]
  set_output_delay -add_delay -max -rise -clock x12clk_in  121 [get_ports {x4clk_out}]
  set_output_delay -add_delay -max -fall -clock x12clk_in  121 [get_ports {x4clk_out}]
  set_output_delay -add_delay -min -rise -clock x12clk_in  22.1 [get_ports {x4clk_out}]
  set_output_delay -add_delay -min -fall -clock x12clk_in  22.1 [get_ports {x4clk_out}]
  set_load -max 10 [get_ports {x4clk_out}]
  set_load -min 5 [get_ports {x4clk_out}]
  set_max_capacitance 10 [get_ports {x4clk_out}]
} else {
  puts "Error: Port x4clk_out does not exist"
}

if { [sizeof_collection [get_ports -quiet {x3clk_sync_out}]] > 0 } {
  set_max_transition 50 [get_ports {x3clk_sync_out}]
  set_output_delay -add_delay -max -rise -clock x12clk_in  121 [get_ports {x3clk_sync_out}]
  set_output_delay -add_delay -max -fall -clock x12clk_in  121 [get_ports {x3clk_sync_out}]
  set_output_delay -add_delay -min -rise -clock x12clk_in  22.1 [get_ports {x3clk_sync_out}]
  set_output_delay -add_delay -min -fall -clock x12clk_in  22.1 [get_ports {x3clk_sync_out}]
  set_load -max 10 [get_ports {x3clk_sync_out}]
  set_load -min 5 [get_ports {x3clk_sync_out}]
  set_max_capacitance 10 [get_ports {x3clk_sync_out}]
} else {
  puts "Error: Port x3clk_sync_out does not exist"
}
if { [sizeof_collection [get_ports -quiet {x3clk_out}]] > 0 } {
  set_max_transition 50 [get_ports {x3clk_out}]
  set_output_delay -add_delay -max -rise -clock x12clk_in 121 [get_ports {x3clk_out}]
  set_output_delay -add_delay -max -fall -clock x12clk_in  121 [get_ports {x3clk_out}]
  set_output_delay -add_delay -min -rise -clock x12clk_in  22.1 [get_ports {x3clk_out}]
  set_output_delay -add_delay -min -fall -clock x12clk_in  22.1 [get_ports {x3clk_out}]
  set_load -max 10 [get_ports {x3clk_out}]
  set_load -min 5 [get_ports {x3clk_out}]
  set_max_capacitance 10 [get_ports {x3clk_out}]
} else {
  puts "Error: Port x3clk_out does not exist"
}

if { [sizeof_collection [get_ports -quiet {ckpll_ref_clk_out}]] > 0 } {
  set_max_transition 50 [get_ports {ckpll_ref_clk_out}]
  set_output_delay -add_delay -max -rise -clock x12clk_in  121 [get_ports {ckpll_ref_clk_out}]
  set_output_delay -add_delay -max -fall -clock x12clk_in  121 [get_ports {ckpll_ref_clk_out}]
  set_output_delay -add_delay -min -rise -clock x12clk_in  22.1 [get_ports {ckpll_ref_clk_out}]
  set_output_delay -add_delay -min -fall -clock x12clk_in  22.1 [get_ports {ckpll_ref_clk_out}]
  set_load -max 10 [get_ports {ckpll_ref_clk_out}]
  set_load -min 5 [get_ports {ckpll_ref_clk_out}]
  set_max_capacitance 10 [get_ports {ckpll_ref_clk_out}]
} else {
  puts "Error: Port ckpll_ref_clk_out does not exist"
}

if { [sizeof_collection [get_ports -quiet {ckpll_ref_sync_out}]] > 0 } {
  set_max_transition 50 [get_ports {ckpll_ref_sync_out}]
  set_output_delay -add_delay -max -rise -clock x12clk_in  121 [get_ports {ckpll_ref_sync_out}]
  set_output_delay -add_delay -max -fall -clock x12clk_in  121 [get_ports {ckpll_ref_sync_out}]
  set_output_delay -add_delay -min -rise -clock x12clk_in  22.1 [get_ports {ckpll_ref_sync_out}]
  set_output_delay -add_delay -min -fall -clock x12clk_in  22.1 [get_ports {ckpll_ref_sync_out}]
  set_load -max 10 [get_ports {ckpll_ref_sync_out}]
  set_load -min 5 [get_ports {ckpll_ref_sync_out}]
  set_max_capacitance 10 [get_ports {ckpll_ref_sync_out}]
} else {
  puts "Error: Port ckpll_ref_sync_out does not exist"
}

if { [sizeof_collection [get_ports -quiet {ck_crystal_out}]] > 0 } {
  set_max_transition 50 [get_ports {ck_crystal_out}]
  set_output_delay -add_delay -max -rise -clock ck_crystal_in  121 [get_ports {ck_crystal_out}]
  set_output_delay -add_delay -max -fall -clock ck_crystal_in  121 [get_ports {ck_crystal_out}]
  set_output_delay -add_delay -min -rise -clock ck_crystal_in  22.1 [get_ports {ck_crystal_out}]
  set_output_delay -add_delay -min -fall -clock ck_crystal_in  22.1 [get_ports {ck_crystal_out}]
  set_load -max 10 [get_ports {ck_crystal_out}]
  set_load -min 5 [get_ports {ck_crystal_out}]
  set_max_capacitance 10 [get_ports {ck_crystal_out}] 
} else {
  puts "Error: Port ck_crystal_out does not exist"
}
