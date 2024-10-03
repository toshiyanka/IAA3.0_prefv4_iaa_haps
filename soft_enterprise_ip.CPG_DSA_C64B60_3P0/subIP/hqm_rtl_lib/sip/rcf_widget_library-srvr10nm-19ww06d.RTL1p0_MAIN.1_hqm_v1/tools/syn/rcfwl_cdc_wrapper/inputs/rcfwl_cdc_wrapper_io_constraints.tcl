#######################################################
### Created by : swho1
### Date     : Tue Nov 24 14:59:03 2015
### Using    : speckle2sdc
#######################################################

## Basic header
##set_units -time ps -resistance kOhm -capacitance fF -voltage V -current mA
##set_operating_conditions typical_1.00 -library e05_ln_p1274_2x0r1_tttt_v065_t100_max
set_max_transition 93 [current_design]
set_max_fanout 50 [current_design]

#----- Start of port: pgcb_clk ------------------------------
if { [sizeof_collection [get_ports -quiet {pgcb_clk}]] > 0 } {
  set_annotated_transition -max -rise 50 [get_ports {pgcb_clk}]
  set_annotated_transition -min -rise 25 [get_ports {pgcb_clk}]
  set_annotated_transition -max -fall 50 [get_ports {pgcb_clk}]
  set_annotated_transition -min -fall 25 [get_ports {pgcb_clk}]
  set_max_capacitance 50 [get_ports {pgcb_clk}]
  set_driving_cell -lib_cell ec0bfn000al1n08x5 [get_ports {pgcb_clk}]
} else {
  puts "Error: Port pgcb_clk does not exist"
}
#----- End of port: pgcb_clk ------------------------------

#----- Start of port: pgcb_rst_b ------------------------------
if { [sizeof_collection [get_ports -quiet {pgcb_rst_b}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock clock  221 [get_ports {pgcb_rst_b}]
  set_input_delay -add_delay -max -fall -clock clock  221 [get_ports {pgcb_rst_b}]
  set_input_delay -add_delay -min -rise -clock clock  37.3 [get_ports {pgcb_rst_b}]
  set_input_delay -add_delay -min -fall -clock clock  37.3 [get_ports {pgcb_rst_b}]
  set_annotated_transition -max -rise 50 [get_ports {pgcb_rst_b}]
  set_annotated_transition -min -rise 25 [get_ports {pgcb_rst_b}]
  set_annotated_transition -max -fall 50 [get_ports {pgcb_rst_b}]
  set_annotated_transition -min -fall 25 [get_ports {pgcb_rst_b}]
  set_max_capacitance 50 [get_ports {pgcb_rst_b}]
  set_driving_cell -lib_cell ec0bfn000al1n08x5 [get_ports {pgcb_rst_b}]
} else {
  puts "Error: Port pgcb_rst_b does not exist"
}
#----- End of port: pgcb_rst_b ------------------------------

#----- Start of port: clock ------------------------------
if { [sizeof_collection [get_ports -quiet {clock}]] > 0 } {
  set_annotated_transition -max -rise 50 [get_ports {clock}]
  set_annotated_transition -min -rise 25 [get_ports {clock}]
  set_annotated_transition -max -fall 50 [get_ports {clock}]
  set_annotated_transition -min -fall 25 [get_ports {clock}]
  set_max_capacitance 50 [get_ports {clock}]
  set_driving_cell -lib_cell ec0bfn000al1n08x5 [get_ports {clock}]
} else {
  puts "Error: Port clock does not exist"
}
#----- End of port: clock ------------------------------

#----- Start of port: reset_b ------------------------------
#if { [sizeof_collection [get_ports -quiet {reset_b}]] > 0 } {
#  set_input_delay -add_delay -max -rise -clock clock  221 [get_ports {reset_b}]
#  set_input_delay -add_delay -max -fall -clock clock  221 [get_ports {reset_b}]
#  set_input_delay -add_delay -min -rise -clock clock  37.3 [get_ports {reset_b}]
#  set_input_delay -add_delay -min -fall -clock clock  37.3 [get_ports {reset_b}]
#  set_annotated_transition -max -rise 50 [get_ports {reset_b}]
#  set_annotated_transition -min -rise 25 [get_ports {reset_b}]
#  set_annotated_transition -max -fall 50 [get_ports {reset_b}]
#  set_annotated_transition -min -fall 25 [get_ports {reset_b}]
#  set_max_capacitance 50 [get_ports {reset_b}]
#  set_driving_cell -lib_cell ec0bfn000al1n08x5 [get_ports {reset_b}]
#} else {
#  puts "Error: Port reset_b does not exist"
#}
#----- End of port: reset_b ------------------------------

#----- Start of port: reset_sync_b ------------------------------
#if { [sizeof_collection [get_ports -quiet {reset_sync_b}]] > 0 } {
#  set_max_transition 50 [get_ports {reset_sync_b}]
#  set_output_delay -add_delay -max -rise -clock clock  121 [get_ports {reset_sync_b}]
#  set_output_delay -add_delay -max -fall -clock clock  121 [get_ports {reset_sync_b}]
#  set_output_delay -add_delay -min -rise -clock clock  22.1 [get_ports {reset_sync_b}]
#  set_output_delay -add_delay -min -fall -clock clock  22.1 [get_ports {reset_sync_b}]
#  set_load -max 10 [get_ports {reset_sync_b}]
#  set_load -min 5 [get_ports {reset_sync_b}]
#  set_max_capacitance 10 [get_ports {reset_sync_b}]
#} else {
#  puts "Error: Port reset_sync_b does not exist"
#}
##----- End of port: reset_sync_b ------------------------------
#
#----- Start of port: clkreq ------------------------------
if { [sizeof_collection [get_ports -quiet {clkreq}]] > 0 } {
  set_max_transition 50 [get_ports {clkreq}]
  set_output_delay -add_delay -max -rise -clock clock  121 [get_ports {clkreq}]
  set_output_delay -add_delay -max -fall -clock clock  121 [get_ports {clkreq}]
  set_output_delay -add_delay -min -rise -clock clock  22.1 [get_ports {clkreq}]
  set_output_delay -add_delay -min -fall -clock clock  22.1 [get_ports {clkreq}]
  set_load -max 10 [get_ports {clkreq}]
  set_load -min 5 [get_ports {clkreq}]
  set_max_capacitance 10 [get_ports {clkreq}]
} else {
  puts "Error: Port clkreq does not exist"
}
#----- End of port: clkreq ------------------------------

#----- Start of port: clkack ------------------------------
if { [sizeof_collection [get_ports -quiet {clkack}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock clock  221 [get_ports {clkack}]
  set_input_delay -add_delay -max -fall -clock clock  221 [get_ports {clkack}]
  set_input_delay -add_delay -min -rise -clock clock  37.3 [get_ports {clkack}]
  set_input_delay -add_delay -min -fall -clock clock  37.3 [get_ports {clkack}]
  set_annotated_transition -max -rise 50 [get_ports {clkack}]
  set_annotated_transition -min -rise 25 [get_ports {clkack}]
  set_annotated_transition -max -fall 50 [get_ports {clkack}]
  set_annotated_transition -min -fall 25 [get_ports {clkack}]
  set_max_capacitance 50 [get_ports {clkack}]
  set_driving_cell -lib_cell ec0bfn000al1n08x5 [get_ports {clkack}]
} else {
  puts "Error: Port clkack does not exist"
}
#----- End of port: clkack ------------------------------

#----- Start of port: pok_reset_b ------------------------------
if { [sizeof_collection [get_ports -quiet {pok_reset_b}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock clock  221 [get_ports {pok_reset_b}]
  set_input_delay -add_delay -max -fall -clock clock  221 [get_ports {pok_reset_b}]
  set_input_delay -add_delay -min -rise -clock clock  37.3 [get_ports {pok_reset_b}]
  set_input_delay -add_delay -min -fall -clock clock  37.3 [get_ports {pok_reset_b}]
  set_annotated_transition -max -rise 50 [get_ports {pok_reset_b}]
  set_annotated_transition -min -rise 25 [get_ports {pok_reset_b}]
  set_annotated_transition -max -fall 50 [get_ports {pok_reset_b}]
  set_annotated_transition -min -fall 25 [get_ports {pok_reset_b}]
  set_max_capacitance 50 [get_ports {pok_reset_b}]
  set_driving_cell -lib_cell ec0bfn000al1n08x5 [get_ports {pok_reset_b}]
} else {
  puts "Error: Port pok_reset_b does not exist"
}
#----- End of port: pok_reset_b ------------------------------

#----- Start of port: pok ------------------------------
if { [sizeof_collection [get_ports -quiet {pok}]] > 0 } {
  set_max_transition 50 [get_ports {pok}]
  set_output_delay -add_delay -max -rise -clock clock  121 [get_ports {pok}]
  set_output_delay -add_delay -max -fall -clock clock  121 [get_ports {pok}]
  set_output_delay -add_delay -min -rise -clock clock  22.1 [get_ports {pok}]
  set_output_delay -add_delay -min -fall -clock clock  22.1 [get_ports {pok}]
  set_load -max 10 [get_ports {pok}]
  set_load -min 5 [get_ports {pok}]
  set_max_capacitance 10 [get_ports {pok}]
} else {
  puts "Error: Port pok does not exist"
}
#----- End of port: pok ------------------------------

#----- Start of port: gclock_req_async ------------------------------
if { [sizeof_collection [get_ports -quiet {gclock_req_async}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock clock  221 [get_ports {gclock_req_async}]
  set_input_delay -add_delay -max -fall -clock clock  221 [get_ports {gclock_req_async}]
  set_input_delay -add_delay -min -rise -clock clock  37.3 [get_ports {gclock_req_async}]
  set_input_delay -add_delay -min -fall -clock clock  37.3 [get_ports {gclock_req_async}]
  set_annotated_transition -max -rise 50 [get_ports {gclock_req_async}]
  set_annotated_transition -min -rise 25 [get_ports {gclock_req_async}]
  set_annotated_transition -max -fall 50 [get_ports {gclock_req_async}]
  set_annotated_transition -min -fall 25 [get_ports {gclock_req_async}]
  set_max_capacitance 50 [get_ports {gclock_req_async}]
  set_driving_cell -lib_cell ec0bfn000al1n08x5 [get_ports {gclock_req_async}]
} else {
  puts "Error: Port gclock_req_async does not exist"
}
#----- End of port: gclock_req_async ------------------------------

#----- Start of port: gclk_async_ack_synced ------------------------------
if { [sizeof_collection [get_ports -quiet {gclk_async_ack_synced}]] > 0 } {
  set_max_transition 50 [get_ports {gclk_async_ack_synced}]
  set_output_delay -add_delay -max -rise -clock clock  121 [get_ports {gclk_async_ack_synced}]
  set_output_delay -add_delay -max -fall -clock clock  121 [get_ports {gclk_async_ack_synced}]
  set_output_delay -add_delay -min -rise -clock clock  22.1 [get_ports {gclk_async_ack_synced}]
  set_output_delay -add_delay -min -fall -clock clock  22.1 [get_ports {gclk_async_ack_synced}]
  set_load -max 10 [get_ports {gclk_async_ack_synced}]
  set_load -min 5 [get_ports {gclk_async_ack_synced}]
  set_max_capacitance 10 [get_ports {gclk_async_ack_synced}]
} else {
  puts "Error: Port gclk_async_ack_synced does not exist"
}
#----- End of port: gclk_async_ack_synced ------------------------------

#----- Start of port: ism_fabric[2] ------------------------------
if { [sizeof_collection [get_ports -quiet {ism_fabric[2]}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock clock  221 [get_ports {ism_fabric[2]}]
  set_input_delay -add_delay -max -fall -clock clock  221 [get_ports {ism_fabric[2]}]
  set_input_delay -add_delay -min -rise -clock clock  37.3 [get_ports {ism_fabric[2]}]
  set_input_delay -add_delay -min -fall -clock clock  37.3 [get_ports {ism_fabric[2]}]
  set_annotated_transition -max -rise 50 [get_ports {ism_fabric[2]}]
  set_annotated_transition -min -rise 25 [get_ports {ism_fabric[2]}]
  set_annotated_transition -max -fall 50 [get_ports {ism_fabric[2]}]
  set_annotated_transition -min -fall 25 [get_ports {ism_fabric[2]}]
  set_max_capacitance 50 [get_ports {ism_fabric[2]}]
  set_driving_cell -lib_cell ec0bfn000al1n08x5 [get_ports {ism_fabric[2]}]
} else {
  puts "Error: Port ism_fabric[2] does not exist"
}
#----- End of port: ism_fabric[2] ------------------------------

#----- Start of port: ism_fabric[1] ------------------------------
if { [sizeof_collection [get_ports -quiet {ism_fabric[1]}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock clock  221 [get_ports {ism_fabric[1]}]
  set_input_delay -add_delay -max -fall -clock clock  221 [get_ports {ism_fabric[1]}]
  set_input_delay -add_delay -min -rise -clock clock  37.3 [get_ports {ism_fabric[1]}]
  set_input_delay -add_delay -min -fall -clock clock  37.3 [get_ports {ism_fabric[1]}]
  set_annotated_transition -max -rise 50 [get_ports {ism_fabric[1]}]
  set_annotated_transition -min -rise 25 [get_ports {ism_fabric[1]}]
  set_annotated_transition -max -fall 50 [get_ports {ism_fabric[1]}]
  set_annotated_transition -min -fall 25 [get_ports {ism_fabric[1]}]
  set_max_capacitance 50 [get_ports {ism_fabric[1]}]
  set_driving_cell -lib_cell ec0bfn000al1n08x5 [get_ports {ism_fabric[1]}]
} else {
  puts "Error: Port ism_fabric[1] does not exist"
}
#----- End of port: ism_fabric[1] ------------------------------

#----- Start of port: ism_fabric[0] ------------------------------
if { [sizeof_collection [get_ports -quiet {ism_fabric[0]}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock clock  221 [get_ports {ism_fabric[0]}]
  set_input_delay -add_delay -max -fall -clock clock  221 [get_ports {ism_fabric[0]}]
  set_input_delay -add_delay -min -rise -clock clock  37.3 [get_ports {ism_fabric[0]}]
  set_input_delay -add_delay -min -fall -clock clock  37.3 [get_ports {ism_fabric[0]}]
  set_annotated_transition -max -rise 50 [get_ports {ism_fabric[0]}]
  set_annotated_transition -min -rise 25 [get_ports {ism_fabric[0]}]
  set_annotated_transition -max -fall 50 [get_ports {ism_fabric[0]}]
  set_annotated_transition -min -fall 25 [get_ports {ism_fabric[0]}]
  set_max_capacitance 50 [get_ports {ism_fabric[0]}]
  set_driving_cell -lib_cell ec0bfn000al1n08x5 [get_ports {ism_fabric[0]}]
} else {
  puts "Error: Port ism_fabric[0] does not exist"
}
#----- End of port: ism_fabric[0] ------------------------------

#----- Start of port: ism_agent[2] ------------------------------
if { [sizeof_collection [get_ports -quiet {ism_agent[2]}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock clock  221 [get_ports {ism_agent[2]}]
  set_input_delay -add_delay -max -fall -clock clock  221 [get_ports {ism_agent[2]}]
  set_input_delay -add_delay -min -rise -clock clock  37.3 [get_ports {ism_agent[2]}]
  set_input_delay -add_delay -min -fall -clock clock  37.3 [get_ports {ism_agent[2]}]
  set_annotated_transition -max -rise 50 [get_ports {ism_agent[2]}]
  set_annotated_transition -min -rise 25 [get_ports {ism_agent[2]}]
  set_annotated_transition -max -fall 50 [get_ports {ism_agent[2]}]
  set_annotated_transition -min -fall 25 [get_ports {ism_agent[2]}]
  set_max_capacitance 50 [get_ports {ism_agent[2]}]
  set_driving_cell -lib_cell ec0bfn000al1n08x5 [get_ports {ism_agent[2]}]
} else {
  puts "Error: Port ism_agent[2] does not exist"
}
#----- End of port: ism_agent[2] ------------------------------

#----- Start of port: ism_agent[1] ------------------------------
if { [sizeof_collection [get_ports -quiet {ism_agent[1]}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock clock  221 [get_ports {ism_agent[1]}]
  set_input_delay -add_delay -max -fall -clock clock  221 [get_ports {ism_agent[1]}]
  set_input_delay -add_delay -min -rise -clock clock  37.3 [get_ports {ism_agent[1]}]
  set_input_delay -add_delay -min -fall -clock clock  37.3 [get_ports {ism_agent[1]}]
  set_annotated_transition -max -rise 50 [get_ports {ism_agent[1]}]
  set_annotated_transition -min -rise 25 [get_ports {ism_agent[1]}]
  set_annotated_transition -max -fall 50 [get_ports {ism_agent[1]}]
  set_annotated_transition -min -fall 25 [get_ports {ism_agent[1]}]
  set_max_capacitance 50 [get_ports {ism_agent[1]}]
  set_driving_cell -lib_cell ec0bfn000al1n08x5 [get_ports {ism_agent[1]}]
} else {
  puts "Error: Port ism_agent[1] does not exist"
}
#----- End of port: ism_agent[1] ------------------------------

#----- Start of port: ism_agent[0] ------------------------------
if { [sizeof_collection [get_ports -quiet {ism_agent[0]}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock clock  221 [get_ports {ism_agent[0]}]
  set_input_delay -add_delay -max -fall -clock clock  221 [get_ports {ism_agent[0]}]
  set_input_delay -add_delay -min -rise -clock clock  37.3 [get_ports {ism_agent[0]}]
  set_input_delay -add_delay -min -fall -clock clock  37.3 [get_ports {ism_agent[0]}]
  set_annotated_transition -max -rise 50 [get_ports {ism_agent[0]}]
  set_annotated_transition -min -rise 25 [get_ports {ism_agent[0]}]
  set_annotated_transition -max -fall 50 [get_ports {ism_agent[0]}]
  set_annotated_transition -min -fall 25 [get_ports {ism_agent[0]}]
  set_max_capacitance 50 [get_ports {ism_agent[0]}]
  set_driving_cell -lib_cell ec0bfn000al1n08x5 [get_ports {ism_agent[0]}]
} else {
  puts "Error: Port ism_agent[0] does not exist"
}
#----- End of port: ism_agent[0] ------------------------------

#----- Start of port: ism_lock_b ------------------------------
if { [sizeof_collection [get_ports -quiet {ism_lock_b}]] > 0 } {
  set_max_transition 50 [get_ports {ism_lock_b}]
  set_output_delay -add_delay -max -rise -clock clock  121 [get_ports {ism_lock_b}]
  set_output_delay -add_delay -max -fall -clock clock  121 [get_ports {ism_lock_b}]
  set_output_delay -add_delay -min -rise -clock clock  22.1 [get_ports {ism_lock_b}]
  set_output_delay -add_delay -min -fall -clock clock  22.1 [get_ports {ism_lock_b}]
  set_load -max 10 [get_ports {ism_lock_b}]
  set_load -min 5 [get_ports {ism_lock_b}]
  set_max_capacitance 10 [get_ports {ism_lock_b}]
} else {
  puts "Error: Port ism_lock_b does not exist"
}
#----- End of port: ism_lock_b ------------------------------

#----- Start of port: cfg_clkgate_disabled ------------------------------
if { [sizeof_collection [get_ports -quiet {cfg_clkgate_disabled}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock clock  221 [get_ports {cfg_clkgate_disabled}]
  set_input_delay -add_delay -max -fall -clock clock  221 [get_ports {cfg_clkgate_disabled}]
  set_input_delay -add_delay -min -rise -clock clock  37.3 [get_ports {cfg_clkgate_disabled}]
  set_input_delay -add_delay -min -fall -clock clock  37.3 [get_ports {cfg_clkgate_disabled}]
  set_annotated_transition -max -rise 50 [get_ports {cfg_clkgate_disabled}]
  set_annotated_transition -min -rise 25 [get_ports {cfg_clkgate_disabled}]
  set_annotated_transition -max -fall 50 [get_ports {cfg_clkgate_disabled}]
  set_annotated_transition -min -fall 25 [get_ports {cfg_clkgate_disabled}]
  set_max_capacitance 50 [get_ports {cfg_clkgate_disabled}]
  set_driving_cell -lib_cell ec0bfn000al1n08x5 [get_ports {cfg_clkgate_disabled}]
} else {
  puts "Error: Port cfg_clkgate_disabled does not exist"
}
#----- End of port: cfg_clkgate_disabled ------------------------------

#----- Start of port: cfg_clkreq_ctl_disabled ------------------------------
if { [sizeof_collection [get_ports -quiet {cfg_clkreq_ctl_disabled}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock clock  221 [get_ports {cfg_clkreq_ctl_disabled}]
  set_input_delay -add_delay -max -fall -clock clock  221 [get_ports {cfg_clkreq_ctl_disabled}]
  set_input_delay -add_delay -min -rise -clock clock  37.3 [get_ports {cfg_clkreq_ctl_disabled}]
  set_input_delay -add_delay -min -fall -clock clock  37.3 [get_ports {cfg_clkreq_ctl_disabled}]
  set_annotated_transition -max -rise 50 [get_ports {cfg_clkreq_ctl_disabled}]
  set_annotated_transition -min -rise 25 [get_ports {cfg_clkreq_ctl_disabled}]
  set_annotated_transition -max -fall 50 [get_ports {cfg_clkreq_ctl_disabled}]
  set_annotated_transition -min -fall 25 [get_ports {cfg_clkreq_ctl_disabled}]
  set_max_capacitance 50 [get_ports {cfg_clkreq_ctl_disabled}]
  set_driving_cell -lib_cell ec0bfn000al1n08x5 [get_ports {cfg_clkreq_ctl_disabled}]
} else {
  puts "Error: Port cfg_clkreq_ctl_disabled does not exist"
}
#----- End of port: cfg_clkreq_ctl_disabled ------------------------------

#----- Start of port: cfg_clkgate_holdoff[3] ------------------------------
if { [sizeof_collection [get_ports -quiet {cfg_clkgate_holdoff[3]}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock clock  221 [get_ports {cfg_clkgate_holdoff[3]}]
  set_input_delay -add_delay -max -fall -clock clock  221 [get_ports {cfg_clkgate_holdoff[3]}]
  set_input_delay -add_delay -min -rise -clock clock  37.3 [get_ports {cfg_clkgate_holdoff[3]}]
  set_input_delay -add_delay -min -fall -clock clock  37.3 [get_ports {cfg_clkgate_holdoff[3]}]
  set_annotated_transition -max -rise 50 [get_ports {cfg_clkgate_holdoff[3]}]
  set_annotated_transition -min -rise 25 [get_ports {cfg_clkgate_holdoff[3]}]
  set_annotated_transition -max -fall 50 [get_ports {cfg_clkgate_holdoff[3]}]
  set_annotated_transition -min -fall 25 [get_ports {cfg_clkgate_holdoff[3]}]
  set_max_capacitance 50 [get_ports {cfg_clkgate_holdoff[3]}]
  set_driving_cell -lib_cell ec0bfn000al1n08x5 [get_ports {cfg_clkgate_holdoff[3]}]
} else {
  puts "Error: Port cfg_clkgate_holdoff[3] does not exist"
}
#----- End of port: cfg_clkgate_holdoff[3] ------------------------------

#----- Start of port: cfg_clkgate_holdoff[2] ------------------------------
if { [sizeof_collection [get_ports -quiet {cfg_clkgate_holdoff[2]}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock clock  221 [get_ports {cfg_clkgate_holdoff[2]}]
  set_input_delay -add_delay -max -fall -clock clock  221 [get_ports {cfg_clkgate_holdoff[2]}]
  set_input_delay -add_delay -min -rise -clock clock  37.3 [get_ports {cfg_clkgate_holdoff[2]}]
  set_input_delay -add_delay -min -fall -clock clock  37.3 [get_ports {cfg_clkgate_holdoff[2]}]
  set_annotated_transition -max -rise 50 [get_ports {cfg_clkgate_holdoff[2]}]
  set_annotated_transition -min -rise 25 [get_ports {cfg_clkgate_holdoff[2]}]
  set_annotated_transition -max -fall 50 [get_ports {cfg_clkgate_holdoff[2]}]
  set_annotated_transition -min -fall 25 [get_ports {cfg_clkgate_holdoff[2]}]
  set_max_capacitance 50 [get_ports {cfg_clkgate_holdoff[2]}]
  set_driving_cell -lib_cell ec0bfn000al1n08x5 [get_ports {cfg_clkgate_holdoff[2]}]
} else {
  puts "Error: Port cfg_clkgate_holdoff[2] does not exist"
}
#----- End of port: cfg_clkgate_holdoff[2] ------------------------------

#----- Start of port: cfg_clkgate_holdoff[1] ------------------------------
if { [sizeof_collection [get_ports -quiet {cfg_clkgate_holdoff[1]}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock clock  221 [get_ports {cfg_clkgate_holdoff[1]}]
  set_input_delay -add_delay -max -fall -clock clock  221 [get_ports {cfg_clkgate_holdoff[1]}]
  set_input_delay -add_delay -min -rise -clock clock  37.3 [get_ports {cfg_clkgate_holdoff[1]}]
  set_input_delay -add_delay -min -fall -clock clock  37.3 [get_ports {cfg_clkgate_holdoff[1]}]
  set_annotated_transition -max -rise 50 [get_ports {cfg_clkgate_holdoff[1]}]
  set_annotated_transition -min -rise 25 [get_ports {cfg_clkgate_holdoff[1]}]
  set_annotated_transition -max -fall 50 [get_ports {cfg_clkgate_holdoff[1]}]
  set_annotated_transition -min -fall 25 [get_ports {cfg_clkgate_holdoff[1]}]
  set_max_capacitance 50 [get_ports {cfg_clkgate_holdoff[1]}]
  set_driving_cell -lib_cell ec0bfn000al1n08x5 [get_ports {cfg_clkgate_holdoff[1]}]
} else {
  puts "Error: Port cfg_clkgate_holdoff[1] does not exist"
}
#----- End of port: cfg_clkgate_holdoff[1] ------------------------------

#----- Start of port: cfg_clkgate_holdoff[0] ------------------------------
if { [sizeof_collection [get_ports -quiet {cfg_clkgate_holdoff[0]}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock clock  221 [get_ports {cfg_clkgate_holdoff[0]}]
  set_input_delay -add_delay -max -fall -clock clock  221 [get_ports {cfg_clkgate_holdoff[0]}]
  set_input_delay -add_delay -min -rise -clock clock  37.3 [get_ports {cfg_clkgate_holdoff[0]}]
  set_input_delay -add_delay -min -fall -clock clock  37.3 [get_ports {cfg_clkgate_holdoff[0]}]
  set_annotated_transition -max -rise 50 [get_ports {cfg_clkgate_holdoff[0]}]
  set_annotated_transition -min -rise 25 [get_ports {cfg_clkgate_holdoff[0]}]
  set_annotated_transition -max -fall 50 [get_ports {cfg_clkgate_holdoff[0]}]
  set_annotated_transition -min -fall 25 [get_ports {cfg_clkgate_holdoff[0]}]
  set_max_capacitance 50 [get_ports {cfg_clkgate_holdoff[0]}]
  set_driving_cell -lib_cell ec0bfn000al1n08x5 [get_ports {cfg_clkgate_holdoff[0]}]
} else {
  puts "Error: Port cfg_clkgate_holdoff[0] does not exist"
}
#----- End of port: cfg_clkgate_holdoff[0] ------------------------------

#----- Start of port: cfg_pwrgate_holdoff[3] ------------------------------
if { [sizeof_collection [get_ports -quiet {cfg_pwrgate_holdoff[3]}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock clock  221 [get_ports {cfg_pwrgate_holdoff[3]}]
  set_input_delay -add_delay -max -fall -clock clock  221 [get_ports {cfg_pwrgate_holdoff[3]}]
  set_input_delay -add_delay -min -rise -clock clock  37.3 [get_ports {cfg_pwrgate_holdoff[3]}]
  set_input_delay -add_delay -min -fall -clock clock  37.3 [get_ports {cfg_pwrgate_holdoff[3]}]
  set_annotated_transition -max -rise 50 [get_ports {cfg_pwrgate_holdoff[3]}]
  set_annotated_transition -min -rise 25 [get_ports {cfg_pwrgate_holdoff[3]}]
  set_annotated_transition -max -fall 50 [get_ports {cfg_pwrgate_holdoff[3]}]
  set_annotated_transition -min -fall 25 [get_ports {cfg_pwrgate_holdoff[3]}]
  set_max_capacitance 50 [get_ports {cfg_pwrgate_holdoff[3]}]
  set_driving_cell -lib_cell ec0bfn000al1n08x5 [get_ports {cfg_pwrgate_holdoff[3]}]
} else {
  puts "Error: Port cfg_pwrgate_holdoff[3] does not exist"
}
#----- End of port: cfg_pwrgate_holdoff[3] ------------------------------

#----- Start of port: cfg_pwrgate_holdoff[2] ------------------------------
if { [sizeof_collection [get_ports -quiet {cfg_pwrgate_holdoff[2]}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock clock  221 [get_ports {cfg_pwrgate_holdoff[2]}]
  set_input_delay -add_delay -max -fall -clock clock  221 [get_ports {cfg_pwrgate_holdoff[2]}]
  set_input_delay -add_delay -min -rise -clock clock  37.3 [get_ports {cfg_pwrgate_holdoff[2]}]
  set_input_delay -add_delay -min -fall -clock clock  37.3 [get_ports {cfg_pwrgate_holdoff[2]}]
  set_annotated_transition -max -rise 50 [get_ports {cfg_pwrgate_holdoff[2]}]
  set_annotated_transition -min -rise 25 [get_ports {cfg_pwrgate_holdoff[2]}]
  set_annotated_transition -max -fall 50 [get_ports {cfg_pwrgate_holdoff[2]}]
  set_annotated_transition -min -fall 25 [get_ports {cfg_pwrgate_holdoff[2]}]
  set_max_capacitance 50 [get_ports {cfg_pwrgate_holdoff[2]}]
  set_driving_cell -lib_cell ec0bfn000al1n08x5 [get_ports {cfg_pwrgate_holdoff[2]}]
} else {
  puts "Error: Port cfg_pwrgate_holdoff[2] does not exist"
}
#----- End of port: cfg_pwrgate_holdoff[2] ------------------------------

#----- Start of port: cfg_pwrgate_holdoff[1] ------------------------------
if { [sizeof_collection [get_ports -quiet {cfg_pwrgate_holdoff[1]}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock clock  221 [get_ports {cfg_pwrgate_holdoff[1]}]
  set_input_delay -add_delay -max -fall -clock clock  221 [get_ports {cfg_pwrgate_holdoff[1]}]
  set_input_delay -add_delay -min -rise -clock clock  37.3 [get_ports {cfg_pwrgate_holdoff[1]}]
  set_input_delay -add_delay -min -fall -clock clock  37.3 [get_ports {cfg_pwrgate_holdoff[1]}]
  set_annotated_transition -max -rise 50 [get_ports {cfg_pwrgate_holdoff[1]}]
  set_annotated_transition -min -rise 25 [get_ports {cfg_pwrgate_holdoff[1]}]
  set_annotated_transition -max -fall 50 [get_ports {cfg_pwrgate_holdoff[1]}]
  set_annotated_transition -min -fall 25 [get_ports {cfg_pwrgate_holdoff[1]}]
  set_max_capacitance 50 [get_ports {cfg_pwrgate_holdoff[1]}]
  set_driving_cell -lib_cell ec0bfn000al1n08x5 [get_ports {cfg_pwrgate_holdoff[1]}]
} else {
  puts "Error: Port cfg_pwrgate_holdoff[1] does not exist"
}
#----- End of port: cfg_pwrgate_holdoff[1] ------------------------------

#----- Start of port: cfg_pwrgate_holdoff[0] ------------------------------
if { [sizeof_collection [get_ports -quiet {cfg_pwrgate_holdoff[0]}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock clock  221 [get_ports {cfg_pwrgate_holdoff[0]}]
  set_input_delay -add_delay -max -fall -clock clock  221 [get_ports {cfg_pwrgate_holdoff[0]}]
  set_input_delay -add_delay -min -rise -clock clock  37.3 [get_ports {cfg_pwrgate_holdoff[0]}]
  set_input_delay -add_delay -min -fall -clock clock  37.3 [get_ports {cfg_pwrgate_holdoff[0]}]
  set_annotated_transition -max -rise 50 [get_ports {cfg_pwrgate_holdoff[0]}]
  set_annotated_transition -min -rise 25 [get_ports {cfg_pwrgate_holdoff[0]}]
  set_annotated_transition -max -fall 50 [get_ports {cfg_pwrgate_holdoff[0]}]
  set_annotated_transition -min -fall 25 [get_ports {cfg_pwrgate_holdoff[0]}]
  set_max_capacitance 50 [get_ports {cfg_pwrgate_holdoff[0]}]
  set_driving_cell -lib_cell ec0bfn000al1n08x5 [get_ports {cfg_pwrgate_holdoff[0]}]
} else {
  puts "Error: Port cfg_pwrgate_holdoff[0] does not exist"
}
#----- End of port: cfg_pwrgate_holdoff[0] ------------------------------

#----- Start of port: cfg_clkreq_off_holdoff[3] ------------------------------
if { [sizeof_collection [get_ports -quiet {cfg_clkreq_off_holdoff[3]}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock clock  221 [get_ports {cfg_clkreq_off_holdoff[3]}]
  set_input_delay -add_delay -max -fall -clock clock  221 [get_ports {cfg_clkreq_off_holdoff[3]}]
  set_input_delay -add_delay -min -rise -clock clock  37.3 [get_ports {cfg_clkreq_off_holdoff[3]}]
  set_input_delay -add_delay -min -fall -clock clock  37.3 [get_ports {cfg_clkreq_off_holdoff[3]}]
  set_annotated_transition -max -rise 50 [get_ports {cfg_clkreq_off_holdoff[3]}]
  set_annotated_transition -min -rise 25 [get_ports {cfg_clkreq_off_holdoff[3]}]
  set_annotated_transition -max -fall 50 [get_ports {cfg_clkreq_off_holdoff[3]}]
  set_annotated_transition -min -fall 25 [get_ports {cfg_clkreq_off_holdoff[3]}]
  set_max_capacitance 50 [get_ports {cfg_clkreq_off_holdoff[3]}]
  set_driving_cell -lib_cell ec0bfn000al1n08x5 [get_ports {cfg_clkreq_off_holdoff[3]}]
} else {
  puts "Error: Port cfg_clkreq_off_holdoff[3] does not exist"
}
#----- End of port: cfg_clkreq_off_holdoff[3] ------------------------------

#----- Start of port: cfg_clkreq_off_holdoff[2] ------------------------------
if { [sizeof_collection [get_ports -quiet {cfg_clkreq_off_holdoff[2]}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock clock  221 [get_ports {cfg_clkreq_off_holdoff[2]}]
  set_input_delay -add_delay -max -fall -clock clock  221 [get_ports {cfg_clkreq_off_holdoff[2]}]
  set_input_delay -add_delay -min -rise -clock clock  37.3 [get_ports {cfg_clkreq_off_holdoff[2]}]
  set_input_delay -add_delay -min -fall -clock clock  37.3 [get_ports {cfg_clkreq_off_holdoff[2]}]
  set_annotated_transition -max -rise 50 [get_ports {cfg_clkreq_off_holdoff[2]}]
  set_annotated_transition -min -rise 25 [get_ports {cfg_clkreq_off_holdoff[2]}]
  set_annotated_transition -max -fall 50 [get_ports {cfg_clkreq_off_holdoff[2]}]
  set_annotated_transition -min -fall 25 [get_ports {cfg_clkreq_off_holdoff[2]}]
  set_max_capacitance 50 [get_ports {cfg_clkreq_off_holdoff[2]}]
  set_driving_cell -lib_cell ec0bfn000al1n08x5 [get_ports {cfg_clkreq_off_holdoff[2]}]
} else {
  puts "Error: Port cfg_clkreq_off_holdoff[2] does not exist"
}
#----- End of port: cfg_clkreq_off_holdoff[2] ------------------------------

#----- Start of port: cfg_clkreq_off_holdoff[1] ------------------------------
if { [sizeof_collection [get_ports -quiet {cfg_clkreq_off_holdoff[1]}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock clock  221 [get_ports {cfg_clkreq_off_holdoff[1]}]
  set_input_delay -add_delay -max -fall -clock clock  221 [get_ports {cfg_clkreq_off_holdoff[1]}]
  set_input_delay -add_delay -min -rise -clock clock  37.3 [get_ports {cfg_clkreq_off_holdoff[1]}]
  set_input_delay -add_delay -min -fall -clock clock  37.3 [get_ports {cfg_clkreq_off_holdoff[1]}]
  set_annotated_transition -max -rise 50 [get_ports {cfg_clkreq_off_holdoff[1]}]
  set_annotated_transition -min -rise 25 [get_ports {cfg_clkreq_off_holdoff[1]}]
  set_annotated_transition -max -fall 50 [get_ports {cfg_clkreq_off_holdoff[1]}]
  set_annotated_transition -min -fall 25 [get_ports {cfg_clkreq_off_holdoff[1]}]
  set_max_capacitance 50 [get_ports {cfg_clkreq_off_holdoff[1]}]
  set_driving_cell -lib_cell ec0bfn000al1n08x5 [get_ports {cfg_clkreq_off_holdoff[1]}]
} else {
  puts "Error: Port cfg_clkreq_off_holdoff[1] does not exist"
}
#----- End of port: cfg_clkreq_off_holdoff[1] ------------------------------

#----- Start of port: cfg_clkreq_off_holdoff[0] ------------------------------
if { [sizeof_collection [get_ports -quiet {cfg_clkreq_off_holdoff[0]}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock clock  221 [get_ports {cfg_clkreq_off_holdoff[0]}]
  set_input_delay -add_delay -max -fall -clock clock  221 [get_ports {cfg_clkreq_off_holdoff[0]}]
  set_input_delay -add_delay -min -rise -clock clock  37.3 [get_ports {cfg_clkreq_off_holdoff[0]}]
  set_input_delay -add_delay -min -fall -clock clock  37.3 [get_ports {cfg_clkreq_off_holdoff[0]}]
  set_annotated_transition -max -rise 50 [get_ports {cfg_clkreq_off_holdoff[0]}]
  set_annotated_transition -min -rise 25 [get_ports {cfg_clkreq_off_holdoff[0]}]
  set_annotated_transition -max -fall 50 [get_ports {cfg_clkreq_off_holdoff[0]}]
  set_annotated_transition -min -fall 25 [get_ports {cfg_clkreq_off_holdoff[0]}]
  set_max_capacitance 50 [get_ports {cfg_clkreq_off_holdoff[0]}]
  set_driving_cell -lib_cell ec0bfn000al1n08x5 [get_ports {cfg_clkreq_off_holdoff[0]}]
} else {
  puts "Error: Port cfg_clkreq_off_holdoff[0] does not exist"
}
#----- End of port: cfg_clkreq_off_holdoff[0] ------------------------------

#----- Start of port: cfg_clkreq_syncoff_holdoff[3] ------------------------------
if { [sizeof_collection [get_ports -quiet {cfg_clkreq_syncoff_holdoff[3]}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock clock  221 [get_ports {cfg_clkreq_syncoff_holdoff[3]}]
  set_input_delay -add_delay -max -fall -clock clock  221 [get_ports {cfg_clkreq_syncoff_holdoff[3]}]
  set_input_delay -add_delay -min -rise -clock clock  37.3 [get_ports {cfg_clkreq_syncoff_holdoff[3]}]
  set_input_delay -add_delay -min -fall -clock clock  37.3 [get_ports {cfg_clkreq_syncoff_holdoff[3]}]
  set_annotated_transition -max -rise 50 [get_ports {cfg_clkreq_syncoff_holdoff[3]}]
  set_annotated_transition -min -rise 25 [get_ports {cfg_clkreq_syncoff_holdoff[3]}]
  set_annotated_transition -max -fall 50 [get_ports {cfg_clkreq_syncoff_holdoff[3]}]
  set_annotated_transition -min -fall 25 [get_ports {cfg_clkreq_syncoff_holdoff[3]}]
  set_max_capacitance 50 [get_ports {cfg_clkreq_syncoff_holdoff[3]}]
  set_driving_cell -lib_cell ec0bfn000al1n08x5 [get_ports {cfg_clkreq_syncoff_holdoff[3]}]
} else {
  puts "Error: Port cfg_clkreq_syncoff_holdoff[3] does not exist"
}
#----- End of port: cfg_clkreq_syncoff_holdoff[3] ------------------------------

#----- Start of port: cfg_clkreq_syncoff_holdoff[2] ------------------------------
if { [sizeof_collection [get_ports -quiet {cfg_clkreq_syncoff_holdoff[2]}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock clock  221 [get_ports {cfg_clkreq_syncoff_holdoff[2]}]
  set_input_delay -add_delay -max -fall -clock clock  221 [get_ports {cfg_clkreq_syncoff_holdoff[2]}]
  set_input_delay -add_delay -min -rise -clock clock  37.3 [get_ports {cfg_clkreq_syncoff_holdoff[2]}]
  set_input_delay -add_delay -min -fall -clock clock  37.3 [get_ports {cfg_clkreq_syncoff_holdoff[2]}]
  set_annotated_transition -max -rise 50 [get_ports {cfg_clkreq_syncoff_holdoff[2]}]
  set_annotated_transition -min -rise 25 [get_ports {cfg_clkreq_syncoff_holdoff[2]}]
  set_annotated_transition -max -fall 50 [get_ports {cfg_clkreq_syncoff_holdoff[2]}]
  set_annotated_transition -min -fall 25 [get_ports {cfg_clkreq_syncoff_holdoff[2]}]
  set_max_capacitance 50 [get_ports {cfg_clkreq_syncoff_holdoff[2]}]
  set_driving_cell -lib_cell ec0bfn000al1n08x5 [get_ports {cfg_clkreq_syncoff_holdoff[2]}]
} else {
  puts "Error: Port cfg_clkreq_syncoff_holdoff[2] does not exist"
}
#----- End of port: cfg_clkreq_syncoff_holdoff[2] ------------------------------

#----- Start of port: cfg_clkreq_syncoff_holdoff[1] ------------------------------
if { [sizeof_collection [get_ports -quiet {cfg_clkreq_syncoff_holdoff[1]}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock clock  221 [get_ports {cfg_clkreq_syncoff_holdoff[1]}]
  set_input_delay -add_delay -max -fall -clock clock  221 [get_ports {cfg_clkreq_syncoff_holdoff[1]}]
  set_input_delay -add_delay -min -rise -clock clock  37.3 [get_ports {cfg_clkreq_syncoff_holdoff[1]}]
  set_input_delay -add_delay -min -fall -clock clock  37.3 [get_ports {cfg_clkreq_syncoff_holdoff[1]}]
  set_annotated_transition -max -rise 50 [get_ports {cfg_clkreq_syncoff_holdoff[1]}]
  set_annotated_transition -min -rise 25 [get_ports {cfg_clkreq_syncoff_holdoff[1]}]
  set_annotated_transition -max -fall 50 [get_ports {cfg_clkreq_syncoff_holdoff[1]}]
  set_annotated_transition -min -fall 25 [get_ports {cfg_clkreq_syncoff_holdoff[1]}]
  set_max_capacitance 50 [get_ports {cfg_clkreq_syncoff_holdoff[1]}]
  set_driving_cell -lib_cell ec0bfn000al1n08x5 [get_ports {cfg_clkreq_syncoff_holdoff[1]}]
} else {
  puts "Error: Port cfg_clkreq_syncoff_holdoff[1] does not exist"
}
#----- End of port: cfg_clkreq_syncoff_holdoff[1] ------------------------------

#----- Start of port: cfg_clkreq_syncoff_holdoff[0] ------------------------------
if { [sizeof_collection [get_ports -quiet {cfg_clkreq_syncoff_holdoff[0]}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock clock  221 [get_ports {cfg_clkreq_syncoff_holdoff[0]}]
  set_input_delay -add_delay -max -fall -clock clock  221 [get_ports {cfg_clkreq_syncoff_holdoff[0]}]
  set_input_delay -add_delay -min -rise -clock clock  37.3 [get_ports {cfg_clkreq_syncoff_holdoff[0]}]
  set_input_delay -add_delay -min -fall -clock clock  37.3 [get_ports {cfg_clkreq_syncoff_holdoff[0]}]
  set_annotated_transition -max -rise 50 [get_ports {cfg_clkreq_syncoff_holdoff[0]}]
  set_annotated_transition -min -rise 25 [get_ports {cfg_clkreq_syncoff_holdoff[0]}]
  set_annotated_transition -max -fall 50 [get_ports {cfg_clkreq_syncoff_holdoff[0]}]
  set_annotated_transition -min -fall 25 [get_ports {cfg_clkreq_syncoff_holdoff[0]}]
  set_max_capacitance 50 [get_ports {cfg_clkreq_syncoff_holdoff[0]}]
  set_driving_cell -lib_cell ec0bfn000al1n08x5 [get_ports {cfg_clkreq_syncoff_holdoff[0]}]
} else {
  puts "Error: Port cfg_clkreq_syncoff_holdoff[0] does not exist"
}
#----- End of port: cfg_clkreq_syncoff_holdoff[0] ------------------------------

#----- Start of port: forcepgpok_pok ------------------------------
if { [sizeof_collection [get_ports -quiet {forcepgpok_pok}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock clock  221 [get_ports {forcepgpok_pok}]
  set_input_delay -add_delay -max -fall -clock clock  221 [get_ports {forcepgpok_pok}]
  set_input_delay -add_delay -min -rise -clock clock  37.3 [get_ports {forcepgpok_pok}]
  set_input_delay -add_delay -min -fall -clock clock  37.3 [get_ports {forcepgpok_pok}]
  set_annotated_transition -max -rise 50 [get_ports {forcepgpok_pok}]
  set_annotated_transition -min -rise 25 [get_ports {forcepgpok_pok}]
  set_annotated_transition -max -fall 50 [get_ports {forcepgpok_pok}]
  set_annotated_transition -min -fall 25 [get_ports {forcepgpok_pok}]
  set_max_capacitance 50 [get_ports {forcepgpok_pok}]
  set_driving_cell -lib_cell ec0bfn000al1n08x5 [get_ports {forcepgpok_pok}]
} else {
  puts "Error: Port forcepgpok_pok does not exist"
}
#----- End of port: forcepgpok_pok ------------------------------

#----- Start of port: forcepgpok_pgreq ------------------------------
if { [sizeof_collection [get_ports -quiet {forcepgpok_pgreq}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock clock  221 [get_ports {forcepgpok_pgreq}]
  set_input_delay -add_delay -max -fall -clock clock  221 [get_ports {forcepgpok_pgreq}]
  set_input_delay -add_delay -min -rise -clock clock  37.3 [get_ports {forcepgpok_pgreq}]
  set_input_delay -add_delay -min -fall -clock clock  37.3 [get_ports {forcepgpok_pgreq}]
  set_annotated_transition -max -rise 50 [get_ports {forcepgpok_pgreq}]
  set_annotated_transition -min -rise 25 [get_ports {forcepgpok_pgreq}]
  set_annotated_transition -max -fall 50 [get_ports {forcepgpok_pgreq}]
  set_annotated_transition -min -fall 25 [get_ports {forcepgpok_pgreq}]
  set_max_capacitance 50 [get_ports {forcepgpok_pgreq}]
  set_driving_cell -lib_cell ec0bfn000al1n08x5 [get_ports {forcepgpok_pgreq}]
} else {
  puts "Error: Port forcepgpok_pgreq does not exist"
}
#----- End of port: forcepgpok_pgreq ------------------------------

#----- Start of port: ip_pg_wake ------------------------------
if { [sizeof_collection [get_ports -quiet {ip_pg_wake}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock clock  221 [get_ports {ip_pg_wake}]
  set_input_delay -add_delay -max -fall -clock clock  221 [get_ports {ip_pg_wake}]
  set_input_delay -add_delay -min -rise -clock clock  37.3 [get_ports {ip_pg_wake}]
  set_input_delay -add_delay -min -fall -clock clock  37.3 [get_ports {ip_pg_wake}]
  set_annotated_transition -max -rise 50 [get_ports {ip_pg_wake}]
  set_annotated_transition -min -rise 25 [get_ports {ip_pg_wake}]
  set_annotated_transition -max -fall 50 [get_ports {ip_pg_wake}]
  set_annotated_transition -min -fall 25 [get_ports {ip_pg_wake}]
  set_max_capacitance 50 [get_ports {ip_pg_wake}]
  set_driving_cell -lib_cell ec0bfn000al1n08x5 [get_ports {ip_pg_wake}]
} else {
  puts "Error: Port ip_pg_wake does not exist"
}
#----- End of port: ip_pg_wake ------------------------------

#----- Start of port: fismdfx_force_clkreq ------------------------------
if { [sizeof_collection [get_ports -quiet {fismdfx_force_clkreq}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock clock  221 [get_ports {fismdfx_force_clkreq}]
  set_input_delay -add_delay -max -fall -clock clock  221 [get_ports {fismdfx_force_clkreq}]
  set_input_delay -add_delay -min -rise -clock clock  37.3 [get_ports {fismdfx_force_clkreq}]
  set_input_delay -add_delay -min -fall -clock clock  37.3 [get_ports {fismdfx_force_clkreq}]
  set_annotated_transition -max -rise 50 [get_ports {fismdfx_force_clkreq}]
  set_annotated_transition -min -rise 25 [get_ports {fismdfx_force_clkreq}]
  set_annotated_transition -max -fall 50 [get_ports {fismdfx_force_clkreq}]
  set_annotated_transition -min -fall 25 [get_ports {fismdfx_force_clkreq}]
  set_max_capacitance 50 [get_ports {fismdfx_force_clkreq}]
  set_driving_cell -lib_cell ec0bfn000al1n08x5 [get_ports {fismdfx_force_clkreq}]
} else {
  puts "Error: Port fismdfx_force_clkreq does not exist"
}
#----- End of port: fismdfx_force_clkreq ------------------------------

#----- Start of port: fscan_byprst_b[3] ------------------------------
#if { [sizeof_collection [get_ports -quiet {fscan_byprst_b[3]}]] > 0 } {
#  set_input_delay -add_delay -max -rise -clock clock  221 [get_ports {fscan_byprst_b[3]}]
#  set_input_delay -add_delay -max -fall -clock clock  221 [get_ports {fscan_byprst_b[3]}]
#  set_input_delay -add_delay -min -rise -clock clock  37.3 [get_ports {fscan_byprst_b[3]}]
#  set_input_delay -add_delay -min -fall -clock clock  37.3 [get_ports {fscan_byprst_b[3]}]
#  set_annotated_transition -max -rise 50 [get_ports {fscan_byprst_b[3]}]
#  set_annotated_transition -min -rise 25 [get_ports {fscan_byprst_b[3]}]
#  set_annotated_transition -max -fall 50 [get_ports {fscan_byprst_b[3]}]
#  set_annotated_transition -min -fall 25 [get_ports {fscan_byprst_b[3]}]
#  set_max_capacitance 50 [get_ports {fscan_byprst_b[3]}]
#  set_driving_cell -lib_cell ec0bfn000al1n08x5 [get_ports {fscan_byprst_b[3]}]
#} else {
#  puts "Error: Port fscan_byprst_b[3] does not exist"
#}
#----- End of port: fscan_byprst_b[3] ------------------------------

#----- Start of port: fscan_byprst_b[2] ------------------------------
#if { [sizeof_collection [get_ports -quiet {fscan_byprst_b[2]}]] > 0 } {
#  set_input_delay -add_delay -max -rise -clock clock  221 [get_ports {fscan_byprst_b[2]}]
#  set_input_delay -add_delay -max -fall -clock clock  221 [get_ports {fscan_byprst_b[2]}]
#  set_input_delay -add_delay -min -rise -clock clock  37.3 [get_ports {fscan_byprst_b[2]}]
#  set_input_delay -add_delay -min -fall -clock clock  37.3 [get_ports {fscan_byprst_b[2]}]
#  set_annotated_transition -max -rise 50 [get_ports {fscan_byprst_b[2]}]
#  set_annotated_transition -min -rise 25 [get_ports {fscan_byprst_b[2]}]
#  set_annotated_transition -max -fall 50 [get_ports {fscan_byprst_b[2]}]
#  set_annotated_transition -min -fall 25 [get_ports {fscan_byprst_b[2]}]
#  set_max_capacitance 50 [get_ports {fscan_byprst_b[2]}]
#  set_driving_cell -lib_cell ec0bfn000al1n08x5 [get_ports {fscan_byprst_b[2]}]
#} else {
#  puts "Error: Port fscan_byprst_b[2] does not exist"
#}
#----- End of port: fscan_byprst_b[2] ------------------------------

#----- Start of port: fscan_byprst_b[1] ------------------------------
if { [sizeof_collection [get_ports -quiet {fscan_byprst_b[1]}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock clock  221 [get_ports {fscan_byprst_b[1]}]
  set_input_delay -add_delay -max -fall -clock clock  221 [get_ports {fscan_byprst_b[1]}]
  set_input_delay -add_delay -min -rise -clock clock  37.3 [get_ports {fscan_byprst_b[1]}]
  set_input_delay -add_delay -min -fall -clock clock  37.3 [get_ports {fscan_byprst_b[1]}]
  set_annotated_transition -max -rise 50 [get_ports {fscan_byprst_b[1]}]
  set_annotated_transition -min -rise 25 [get_ports {fscan_byprst_b[1]}]
  set_annotated_transition -max -fall 50 [get_ports {fscan_byprst_b[1]}]
  set_annotated_transition -min -fall 25 [get_ports {fscan_byprst_b[1]}]
  set_max_capacitance 50 [get_ports {fscan_byprst_b[1]}]
  set_driving_cell -lib_cell ec0bfn000al1n08x5 [get_ports {fscan_byprst_b[1]}]
} else {
  puts "Error: Port fscan_byprst_b[1] does not exist"
}
#----- End of port: fscan_byprst_b[1] ------------------------------

#----- Start of port: fscan_byprst_b[0] ------------------------------
if { [sizeof_collection [get_ports -quiet {fscan_byprst_b[0]}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock clock  221 [get_ports {fscan_byprst_b[0]}]
  set_input_delay -add_delay -max -fall -clock clock  221 [get_ports {fscan_byprst_b[0]}]
  set_input_delay -add_delay -min -rise -clock clock  37.3 [get_ports {fscan_byprst_b[0]}]
  set_input_delay -add_delay -min -fall -clock clock  37.3 [get_ports {fscan_byprst_b[0]}]
  set_annotated_transition -max -rise 50 [get_ports {fscan_byprst_b[0]}]
  set_annotated_transition -min -rise 25 [get_ports {fscan_byprst_b[0]}]
  set_annotated_transition -max -fall 50 [get_ports {fscan_byprst_b[0]}]
  set_annotated_transition -min -fall 25 [get_ports {fscan_byprst_b[0]}]
  set_max_capacitance 50 [get_ports {fscan_byprst_b[0]}]
  set_driving_cell -lib_cell ec0bfn000al1n08x5 [get_ports {fscan_byprst_b[0]}]
} else {
  puts "Error: Port fscan_byprst_b[0] does not exist"
}
#----- End of port: fscan_byprst_b[0] ------------------------------

#----- Start of port: fscan_rstbypen[3] ------------------------------
#if { [sizeof_collection [get_ports -quiet {fscan_rstbypen[3]}]] > 0 } {
#  set_input_delay -add_delay -max -rise -clock clock  221 [get_ports {fscan_rstbypen[3]}]
#  set_input_delay -add_delay -max -fall -clock clock  221 [get_ports {fscan_rstbypen[3]}]
#  set_input_delay -add_delay -min -rise -clock clock  37.3 [get_ports {fscan_rstbypen[3]}]
#  set_input_delay -add_delay -min -fall -clock clock  37.3 [get_ports {fscan_rstbypen[3]}]
#  set_annotated_transition -max -rise 50 [get_ports {fscan_rstbypen[3]}]
#  set_annotated_transition -min -rise 25 [get_ports {fscan_rstbypen[3]}]
#  set_annotated_transition -max -fall 50 [get_ports {fscan_rstbypen[3]}]
#  set_annotated_transition -min -fall 25 [get_ports {fscan_rstbypen[3]}]
#  set_max_capacitance 50 [get_ports {fscan_rstbypen[3]}]
#  set_driving_cell -lib_cell ec0bfn000al1n08x5 [get_ports {fscan_rstbypen[3]}]
#} else {
#  puts "Error: Port fscan_rstbypen[3] does not exist"
#}
#----- End of port: fscan_rstbypen[3] ------------------------------

#----- Start of port: fscan_rstbypen[2] ------------------------------
#if { [sizeof_collection [get_ports -quiet {fscan_rstbypen[2]}]] > 0 } {
#  set_input_delay -add_delay -max -rise -clock clock  221 [get_ports {fscan_rstbypen[2]}]
#  set_input_delay -add_delay -max -fall -clock clock  221 [get_ports {fscan_rstbypen[2]}]
#  set_input_delay -add_delay -min -rise -clock clock  37.3 [get_ports {fscan_rstbypen[2]}]
#  set_input_delay -add_delay -min -fall -clock clock  37.3 [get_ports {fscan_rstbypen[2]}]
#  set_annotated_transition -max -rise 50 [get_ports {fscan_rstbypen[2]}]
#  set_annotated_transition -min -rise 25 [get_ports {fscan_rstbypen[2]}]
#  set_annotated_transition -max -fall 50 [get_ports {fscan_rstbypen[2]}]
#  set_annotated_transition -min -fall 25 [get_ports {fscan_rstbypen[2]}]
#  set_max_capacitance 50 [get_ports {fscan_rstbypen[2]}]
#  set_driving_cell -lib_cell ec0bfn000al1n08x5 [get_ports {fscan_rstbypen[2]}]
#} else {
#  puts "Error: Port fscan_rstbypen[2] does not exist"
#}
#----- End of port: fscan_rstbypen[2] ------------------------------

#----- Start of port: fscan_rstbypen[1] ------------------------------
if { [sizeof_collection [get_ports -quiet {fscan_rstbypen[1]}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock clock  221 [get_ports {fscan_rstbypen[1]}]
  set_input_delay -add_delay -max -fall -clock clock  221 [get_ports {fscan_rstbypen[1]}]
  set_input_delay -add_delay -min -rise -clock clock  37.3 [get_ports {fscan_rstbypen[1]}]
  set_input_delay -add_delay -min -fall -clock clock  37.3 [get_ports {fscan_rstbypen[1]}]
  set_annotated_transition -max -rise 50 [get_ports {fscan_rstbypen[1]}]
  set_annotated_transition -min -rise 25 [get_ports {fscan_rstbypen[1]}]
  set_annotated_transition -max -fall 50 [get_ports {fscan_rstbypen[1]}]
  set_annotated_transition -min -fall 25 [get_ports {fscan_rstbypen[1]}]
  set_max_capacitance 50 [get_ports {fscan_rstbypen[1]}]
  set_driving_cell -lib_cell ec0bfn000al1n08x5 [get_ports {fscan_rstbypen[1]}]
} else {
  puts "Error: Port fscan_rstbypen[1] does not exist"
}
#----- End of port: fscan_rstbypen[1] ------------------------------

#----- Start of port: fscan_rstbypen[0] ------------------------------
if { [sizeof_collection [get_ports -quiet {fscan_rstbypen[0]}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock clock  221 [get_ports {fscan_rstbypen[0]}]
  set_input_delay -add_delay -max -fall -clock clock  221 [get_ports {fscan_rstbypen[0]}]
  set_input_delay -add_delay -min -rise -clock clock  37.3 [get_ports {fscan_rstbypen[0]}]
  set_input_delay -add_delay -min -fall -clock clock  37.3 [get_ports {fscan_rstbypen[0]}]
  set_annotated_transition -max -rise 50 [get_ports {fscan_rstbypen[0]}]
  set_annotated_transition -min -rise 25 [get_ports {fscan_rstbypen[0]}]
  set_annotated_transition -max -fall 50 [get_ports {fscan_rstbypen[0]}]
  set_annotated_transition -min -fall 25 [get_ports {fscan_rstbypen[0]}]
  set_max_capacitance 50 [get_ports {fscan_rstbypen[0]}]
  set_driving_cell -lib_cell ec0bfn000al1n08x5 [get_ports {fscan_rstbypen[0]}]
} else {
  puts "Error: Port fscan_rstbypen[0] does not exist"
}
#----- End of port: fscan_rstbypen[0] ------------------------------
if { [sizeof_collection [get_ports -quiet {fscan_shiften}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock clock  221 [get_ports {fscan_shiften}]
  set_input_delay -add_delay -max -fall -clock clock  221 [get_ports {fscan_shiften}]
  set_input_delay -add_delay -min -rise -clock clock  37.3 [get_ports {fscan_shiften}]
  set_input_delay -add_delay -min -fall -clock clock  37.3 [get_ports {fscan_shiften}]
  set_annotated_transition -max -rise 50 [get_ports {fscan_shiften}]
  set_annotated_transition -min -rise 25 [get_ports {fscan_shiften}]
  set_annotated_transition -max -fall 50 [get_ports {fscan_shiften}]
  set_annotated_transition -min -fall 25 [get_ports {fscan_shiften}]
  set_max_capacitance 50 [get_ports {fscan_shiften}]
  set_driving_cell -lib_cell ec0bfn000al1n08x5 [get_ports {fscan_shiften}]
} else {
  puts "Error: Port fscan_shiften does not exist"
}
if { [sizeof_collection [get_ports -quiet {fscan_latchopen}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock clock  221 [get_ports {fscan_latchopen}]
  set_input_delay -add_delay -max -fall -clock clock  221 [get_ports {fscan_latchopen}]
  set_input_delay -add_delay -min -rise -clock clock  37.3 [get_ports {fscan_latchopen}]
  set_input_delay -add_delay -min -fall -clock clock  37.3 [get_ports {fscan_latchopen}]
  set_annotated_transition -max -rise 50 [get_ports {fscan_latchopen}]
  set_annotated_transition -min -rise 25 [get_ports {fscan_latchopen}]
  set_annotated_transition -max -fall 50 [get_ports {fscan_latchopen}]
  set_annotated_transition -min -fall 25 [get_ports {fscan_latchopen}]
  set_max_capacitance 50 [get_ports {fscan_latchopen}]
  set_driving_cell -lib_cell ec0bfn000al1n08x5 [get_ports {fscan_latchopen}]
} else {
  puts "Error: Port fscan_latchopen does not exist"
}
if { [sizeof_collection [get_ports -quiet {fscan_latchclosed_b}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock clock  221 [get_ports {fscan_latchclosed_b}]
  set_input_delay -add_delay -max -fall -clock clock  221 [get_ports {fscan_latchclosed_b}]
  set_input_delay -add_delay -min -rise -clock clock  37.3 [get_ports {fscan_latchclosed_b}]
  set_input_delay -add_delay -min -fall -clock clock  37.3 [get_ports {fscan_latchclosed_b}]
  set_annotated_transition -max -rise 50 [get_ports {fscan_latchclosed_b}]
  set_annotated_transition -min -rise 25 [get_ports {fscan_latchclosed_b}]
  set_annotated_transition -max -fall 50 [get_ports {fscan_latchclosed_b}]
  set_annotated_transition -min -fall 25 [get_ports {fscan_latchclosed_b}]
  set_max_capacitance 50 [get_ports {fscan_latchclosed_b}]
  set_driving_cell -lib_cell ec0bfn000al1n08x5 [get_ports {fscan_latchclosed_b}]
} else {
  puts "Error: Port fscan_latchclosed_b does not exist"
}
if { [sizeof_collection [get_ports -quiet {fscan_clkungate}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock clock  221 [get_ports {fscan_clkungate}]
  set_input_delay -add_delay -max -fall -clock clock  221 [get_ports {fscan_clkungate}]
  set_input_delay -add_delay -min -rise -clock clock  37.3 [get_ports {fscan_clkungate}]
  set_input_delay -add_delay -min -fall -clock clock  37.3 [get_ports {fscan_clkungate}]
  set_annotated_transition -max -rise 50 [get_ports {fscan_clkungate}]
  set_annotated_transition -min -rise 25 [get_ports {fscan_clkungate}]
  set_annotated_transition -max -fall 50 [get_ports {fscan_clkungate}]
  set_annotated_transition -min -fall 25 [get_ports {fscan_clkungate}]
  set_max_capacitance 50 [get_ports {fscan_clkungate}]
  set_driving_cell -lib_cell ec0bfn000al1n08x5 [get_ports {fscan_clkungate}]
} else {
  puts "Error: Port fscan_clkungate does not exist"
}
if { [sizeof_collection [get_ports -quiet {fscan_clkungate_syn}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock clock  221 [get_ports {fscan_clkungate_syn}]
  set_input_delay -add_delay -max -fall -clock clock  221 [get_ports {fscan_clkungate_syn}]
  set_input_delay -add_delay -min -rise -clock clock  37.3 [get_ports {fscan_clkungate_syn}]
  set_input_delay -add_delay -min -fall -clock clock  37.3 [get_ports {fscan_clkungate_syn}]
  set_annotated_transition -max -rise 50 [get_ports {fscan_clkungate_syn}]
  set_annotated_transition -min -rise 25 [get_ports {fscan_clkungate_syn}]
  set_annotated_transition -max -fall 50 [get_ports {fscan_clkungate_syn}]
  set_annotated_transition -min -fall 25 [get_ports {fscan_clkungate_syn}]
  set_max_capacitance 50 [get_ports {fscan_clkungate_syn}]
  set_driving_cell -lib_cell ec0bfn000al1n08x5 [get_ports {fscan_clkungate_syn}]
} else {
  puts "Error: Port fscan_clkungate_syn does not exist"
}
if { [sizeof_collection [get_ports -quiet {fscan_mode}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock clock  221 [get_ports {fscan_mode}]
  set_input_delay -add_delay -max -fall -clock clock  221 [get_ports {fscan_mode}]
  set_input_delay -add_delay -min -rise -clock clock  37.3 [get_ports {fscan_mode}]
  set_input_delay -add_delay -min -fall -clock clock  37.3 [get_ports {fscan_mode}]
  set_annotated_transition -max -rise 50 [get_ports {fscan_mode}]
  set_annotated_transition -min -rise 25 [get_ports {fscan_mode}]
  set_annotated_transition -max -fall 50 [get_ports {fscan_mode}]
  set_annotated_transition -min -fall 25 [get_ports {fscan_mode}]
  set_max_capacitance 50 [get_ports {fscan_mode}]
  set_driving_cell -lib_cell ec0bfn000al1n08x5 [get_ports {fscan_mode}]
} else {
  puts "Error: Port fscan_mode does not exist"
}
if { [sizeof_collection [get_ports -quiet {fscan_sdi}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock clock  221 [get_ports {fscan_sdi}]
  set_input_delay -add_delay -max -fall -clock clock  221 [get_ports {fscan_sdi}]
  set_input_delay -add_delay -min -rise -clock clock  37.3 [get_ports {fscan_sdi}]
  set_input_delay -add_delay -min -fall -clock clock  37.3 [get_ports {fscan_sdi}]
  set_annotated_transition -max -rise 50 [get_ports {fscan_sdi}]
  set_annotated_transition -min -rise 25 [get_ports {fscan_sdi}]
  set_annotated_transition -max -fall 50 [get_ports {fscan_sdi}]
  set_annotated_transition -min -fall 25 [get_ports {fscan_sdi}]
  set_max_capacitance 50 [get_ports {fscan_sdi}]
  set_driving_cell -lib_cell ec0bfn000al1n08x5 [get_ports {fscan_sdi}]
} else {
  puts "Error: Port fscan_sdi does not exist"
}

if { [sizeof_collection [get_ports -quiet ascan_sdo]] > 0 } {
    set_max_transition 50 [get_ports ascan_sdo]
    set_output_delay -add_delay -max -rise -clock clock  121 [get_ports ascan_sdo]
    set_output_delay -add_delay -max -fall -clock clock  121 [get_ports ascan_sdo]
    set_output_delay -add_delay -min -rise -clock clock  22.1 [get_ports ascan_sdo]
    set_output_delay -add_delay -min -fall -clock clock  22.1 [get_ports ascan_sdo]
    set_load -max 10 [get_ports ascan_sdo]
    set_load -min 5 [get_ports ascan_sdo]
    set_max_capacitance 10 [get_ports ascan_sdo]
} else {
    puts "Error: Port ascan_sdo does not exist"
}


#----- Start of port: avisa_debug_data_clk ------------------------------
for {set i 0} {$i < 16} {incr i 1} {
    if { [sizeof_collection [get_ports -quiet avisa_debug_data_clk[$i]]] > 0 } {
        set_max_transition 50 [get_ports avisa_debug_data_clk[$i]]
        set_output_delay -add_delay -max -rise -clock clock  121 [get_ports avisa_debug_data_clk[$i]]
        set_output_delay -add_delay -max -fall -clock clock  121 [get_ports avisa_debug_data_clk[$i]]
        set_output_delay -add_delay -min -rise -clock clock  22.1 [get_ports avisa_debug_data_clk[$i]]
        set_output_delay -add_delay -min -fall -clock clock  22.1 [get_ports avisa_debug_data_clk[$i]]
        set_load -max 10 [get_ports avisa_debug_data_clk[$i]]
        set_load -min 5 [get_ports avisa_debug_data_clk[$i]]
        set_max_capacitance 10 [get_ports avisa_debug_data_clk[$i]]
    } else {
        puts "Error: Port avisa_debug_data_clk[$i] does not exist"
    }
}
#----- End of port: avisa_debug_data_clk ------------------------------
for {set i 0} {$i < 2} {incr i 1} {
    if { [sizeof_collection [get_ports -quiet avisa_strb_clk_clock[$i]]] > 0 } {
        set_max_transition 50 [get_ports avisa_strb_clk_clock[$i]]
        set_output_delay -add_delay -max -rise -clock clock  121 [get_ports avisa_strb_clk_clock[$i]]
        set_output_delay -add_delay -max -fall -clock clock  121 [get_ports avisa_strb_clk_clock[$i]]
        set_output_delay -add_delay -min -rise -clock clock  22.1 [get_ports avisa_strb_clk_clock[$i]]
        set_output_delay -add_delay -min -fall -clock clock  22.1 [get_ports avisa_strb_clk_clock[$i]]
        set_load -max 10 [get_ports avisa_strb_clk_clock[$i]]
        set_load -min 5 [get_ports avisa_strb_clk_clock[$i]]
        set_max_capacitance 10 [get_ports avisa_strb_clk_clock[$i]]
    } else {
        puts "Error: Port avisa_strb_clk_clock[$i] does not exist"
    }
}

#----- Start of port: avisa_debug_data_pgcb_clk ------------------------------
for {set i 0} {$i < 8} {incr i 1} {
    if { [sizeof_collection [get_ports -quiet avisa_debug_data_pgcb_clk[$i]]] > 0 } {
        set_max_transition 50 [get_ports avisa_debug_data_pgcb_clk[$i]]
        set_output_delay -add_delay -max -rise -clock clock  121 [get_ports avisa_debug_data_pgcb_clk[$i]]
        set_output_delay -add_delay -max -fall -clock clock  121 [get_ports avisa_debug_data_pgcb_clk[$i]]
        set_output_delay -add_delay -min -rise -clock clock  22.1 [get_ports avisa_debug_data_pgcb_clk[$i]]
        set_output_delay -add_delay -min -fall -clock clock  22.1 [get_ports avisa_debug_data_pgcb_clk[$i]]
        set_load -max 10 [get_ports avisa_debug_data_pgcb_clk[$i]]
        set_load -min 5 [get_ports avisa_debug_data_pgcb_clk[$i]]
        set_max_capacitance 10 [get_ports avisa_debug_data_pgcb_clk[$i]]
    } else {
        puts "Error: Port avisa_debug_data_pgcb_clk[$i] does not exist"
    }
}
#----- End of port: avisa_debug_data_pgcb_clk ------------------------------

#----- Start of port: avisa_strb_clk_pgcb_clk ------------------------------
#for {set i 0} {$i < 4} {incr i 1} {
    if { [sizeof_collection [get_ports -quiet {avisa_strb_clk_pgcb_clk}]] > 0 } {
        set_max_transition 50 [get_ports {avisa_strb_clk_pgcb_clk}]
        set_output_delay -add_delay -max -rise -clock clock  121 [get_ports {avisa_strb_clk_pgcb_clk}]
        set_output_delay -add_delay -max -fall -clock clock  121 [get_ports {avisa_strb_clk_pgcb_clk}]
        set_output_delay -add_delay -min -rise -clock clock  22.1 [get_ports {avisa_strb_clk_pgcb_clk}]
        set_output_delay -add_delay -min -fall -clock clock  22.1 [get_ports {avisa_strb_clk_pgcb_clk}]
        set_load -max 10 [get_ports {avisa_strb_clk_pgcb_clk}]
        set_load -min 5 [get_ports {avisa_strb_clk_pgcb_clk}]
        set_max_capacitance 10 [get_ports {avisa_strb_clk_pgcb_clk}]
    } else {
        puts "Error: Port avisa_strb_clk_pgcb_clk does not exist"
    }
#}
#----- End of port: avisa_strb_clk_pgcb_clk ------------------------------

#----- Start of port: fglobal_visa_start_id_pgcb_clk ------------------------------
if { [sizeof_collection [get_ports -quiet {fglobal_visa_start_id_pgcb_clk}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock pgcb_clk  221 [get_ports {fglobal_visa_start_id_pgcb_clk}]
  set_input_delay -add_delay -max -fall -clock pgcb_clk  221 [get_ports {fglobal_visa_start_id_pgcb_clk}]
  set_input_delay -add_delay -min -rise -clock pgcb_clk  37.3 [get_ports {fglobal_visa_start_id_pgcb_clk}]
  set_input_delay -add_delay -min -fall -clock pgcb_clk  37.3 [get_ports {fglobal_visa_start_id_pgcb_clk}]
  set_annotated_transition -max -rise 50 [get_ports {fglobal_visa_start_id_pgcb_clk}]
  set_annotated_transition -min -rise 25 [get_ports {fglobal_visa_start_id_pgcb_clk}]
  set_annotated_transition -max -fall 50 [get_ports {fglobal_visa_start_id_pgcb_clk}]
  set_annotated_transition -min -fall 25 [get_ports {fglobal_visa_start_id_pgcb_clk}]
  set_max_capacitance 50 [get_ports {fglobal_visa_start_id_pgcb_clk}]
  set_driving_cell -lib_cell ec0bfn000al1n08x5 [get_ports {fglobal_visa_start_id_pgcb_clk}]
} else {
  puts "Error: Port fglobal_visa_start_id_pgcb_clk does not exist"
}
#----- End of port: fglobal_visa_start_id_pgcb_clk ------------------------------

#----- Start of port: fglobal_visa_start_id_clk ------------------------------
if { [sizeof_collection [get_ports -quiet {fglobal_visa_start_id_clk}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock clock  221 [get_ports {fglobal_visa_start_id_clk}]
  set_input_delay -add_delay -max -fall -clock clock  221 [get_ports {fglobal_visa_start_id_clk}]
  set_input_delay -add_delay -min -rise -clock clock  37.3 [get_ports {fglobal_visa_start_id_clk}]
  set_input_delay -add_delay -min -fall -clock clock  37.3 [get_ports {fglobal_visa_start_id_clk}]
  set_annotated_transition -max -rise 50 [get_ports {fglobal_visa_start_id_clk}]
  set_annotated_transition -min -rise 25 [get_ports {fglobal_visa_start_id_clk}]
  set_annotated_transition -max -fall 50 [get_ports {fglobal_visa_start_id_clk}]
  set_annotated_transition -min -fall 25 [get_ports {fglobal_visa_start_id_clk}]
  set_max_capacitance 50 [get_ports {fglobal_visa_start_id_clk}]
  set_driving_cell -lib_cell ec0bfn000al1n08x5 [get_ports {fglobal_visa_start_id_clk}]
} else {
  puts "Error: Port fglobal_visa_start_id_clk does not exist"
}
#----- End of port: fglobal_visa_start_id_clk ------------------------------

#----- Start of port: fvisa_serstrb ------------------------------
if { [sizeof_collection [get_ports -quiet {fvisa_serstrb}]] > 0 } {
  set_annotated_transition -max -rise 50 [get_ports {fvisa_serstrb}]
  set_annotated_transition -min -rise 25 [get_ports {fvisa_serstrb}]
  set_annotated_transition -max -fall 50 [get_ports {fvisa_serstrb}]
  set_annotated_transition -min -fall 25 [get_ports {fvisa_serstrb}]
  set_max_capacitance 50 [get_ports {fvisa_serstrb}]
  set_driving_cell -lib_cell ec0bfn000al1n08x5 [get_ports {fvisa_serstrb}]
} else {
  puts "Error: Port fvisa_serstrb does not exist"
}
#----- End of port: fvisa_serstrb ------------------------------

#----- Start of port: fvisa_frame ------------------------------
if { [sizeof_collection [get_ports -quiet {fvisa_frame}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock clock  221 [get_ports {fvisa_frame}]
  set_input_delay -add_delay -max -fall -clock clock  221 [get_ports {fvisa_frame}]
  set_input_delay -add_delay -min -rise -clock clock  37.3 [get_ports {fvisa_frame}]
  set_input_delay -add_delay -min -fall -clock clock  37.3 [get_ports {fvisa_frame}]
  set_annotated_transition -max -rise 50 [get_ports {fvisa_frame}]
  set_annotated_transition -min -rise 25 [get_ports {fvisa_frame}]
  set_annotated_transition -max -fall 50 [get_ports {fvisa_frame}]
  set_annotated_transition -min -fall 25 [get_ports {fvisa_frame}]
  set_max_capacitance 50 [get_ports {fvisa_frame}]
  set_driving_cell -lib_cell ec0bfn000al1n08x5 [get_ports {fvisa_frame}]
} else {
  puts "Error: Port fvisa_frame does not exist"
}
#----- End of port: fvisa_frame ------------------------------

#----- Start of port: fvisa_serdata ------------------------------
if { [sizeof_collection [get_ports -quiet {fvisa_serdata}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock clock  221 [get_ports {fvisa_serdata}]
  set_input_delay -add_delay -max -fall -clock clock  221 [get_ports {fvisa_serdata}]
  set_input_delay -add_delay -min -rise -clock clock  37.3 [get_ports {fvisa_serdata}]
  set_input_delay -add_delay -min -fall -clock clock  37.3 [get_ports {fvisa_serdata}]
  set_annotated_transition -max -rise 50 [get_ports {fvisa_serdata}]
  set_annotated_transition -min -rise 25 [get_ports {fvisa_serdata}]
  set_annotated_transition -max -fall 50 [get_ports {fvisa_serdata}]
  set_annotated_transition -min -fall 25 [get_ports {fvisa_serdata}]
  set_max_capacitance 50 [get_ports {fvisa_serdata}]
  set_driving_cell -lib_cell ec0bfn000al1n08x5 [get_ports {fvisa_serdata}]
} else {
  puts "Error: Port fvisa_serdata does not exist"
}
#----- End of port: fvisa_serdata ------------------------------

#----- Start of port: fdfx_secure_policy ------------------------------
for {set i 0} {$i < 4} {incr i 1} {
    if { [sizeof_collection [get_ports -quiet fdfx_secure_policy[$i]]] > 0 } {
        set_input_delay -add_delay -max -rise -clock policy_update  416 [get_ports fdfx_secure_policy[$i]]
        set_annotated_transition -max -rise 50 [get_ports fdfx_secure_policy[$i]]
        set_input_delay -add_delay -max -fall -clock policy_update  416 [get_ports fdfx_secure_policy[$i]]
        set_annotated_transition -max -fall 50 [get_ports fdfx_secure_policy[$i]]
        set_input_delay -add_delay -min -rise -clock policy_update  50.0 [get_ports fdfx_secure_policy[$i]]
        set_annotated_transition -min -rise 37.5 [get_ports fdfx_secure_policy[$i]]
        set_input_delay -add_delay -min -fall -clock policy_update  50.0 [get_ports fdfx_secure_policy[$i]]
        set_annotated_transition -min -fall 37.5 [get_ports fdfx_secure_policy[$i]]
        set_max_capacitance 50 [get_ports fdfx_secure_policy[$i]]
    } else {
        puts "Error: Port fdfx_secure_policy[$i] does not exist"
    }
}
#----- End of port: fdfx_secure_policy ------------------------------

#----- Start of port: oem_secure_policy ------------------------------
for {set i 0} {$i < 4} {incr i 1} {
    if { [sizeof_collection [get_ports -quiet oem_secure_policy[$i]]] > 0 } {
        set_input_delay -add_delay -max -rise -clock policy_update  465 [get_ports oem_secure_policy[$i]]
        set_annotated_transition -max -rise 50 [get_ports oem_secure_policy[$i]]
        set_input_delay -add_delay -max -fall -clock policy_update  465 [get_ports oem_secure_policy[$i]]
        set_annotated_transition -max -fall 50 [get_ports oem_secure_policy[$i]]
        set_input_delay -add_delay -min -rise -clock policy_update  50.0 [get_ports oem_secure_policy[$i]]
        set_annotated_transition -min -rise 37.5 [get_ports oem_secure_policy[$i]]
        set_input_delay -add_delay -min -fall -clock policy_update  50.0 [get_ports oem_secure_policy[$i]]
        set_annotated_transition -min -fall 37.5 [get_ports oem_secure_policy[$i]]
        set_max_capacitance 50 [get_ports oem_secure_policy[$i]]
    } else {
        puts "Error: Port oem_secure_policy[$i] does not exist"
    }
}
#----- End of port: oem_secure_policy ------------------------------


#----- Start of port: fdfx_earlyboot_exit ------------------------------
if { [sizeof_collection [get_ports -quiet {fdfx_earlyboot_exit}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock clock  465 [get_ports {fdfx_earlyboot_exit}]
  set_annotated_transition -max -rise 50 [get_ports {fdfx_earlyboot_exit}]
  set_input_delay -add_delay -max -fall -clock clock  465 [get_ports {fdfx_earlyboot_exit}]
  set_annotated_transition -max -fall 50 [get_ports {fdfx_earlyboot_exit}]
  set_input_delay -add_delay -min -rise -clock clock  50.0 [get_ports {fdfx_earlyboot_exit}]
  set_annotated_transition -min -rise 37.5 [get_ports {fdfx_earlyboot_exit}]
  set_input_delay -add_delay -min -fall -clock clock  50.0 [get_ports {fdfx_earlyboot_exit}]
  set_annotated_transition -min -fall 37.5 [get_ports {fdfx_earlyboot_exit}]
#  set_driving_cell -lib_cell ec0bfn000al1n08x5 [get_ports {fdfx_earlyboot_exit}]
  set_max_capacitance 50 [get_ports {fdfx_earlyboot_exit}]
} else {
  puts "Error: Port fdfx_earlyboot_exit does not exist"
}
#----- End of port: fdfx_earlyboot_exit ------------------------------

#----- Start of port: fdfx_powergood ------------------------------
if { [sizeof_collection [get_ports -quiet {fdfx_powergood}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock clock  465 [get_ports {fdfx_powergood}]
  set_annotated_transition -max -rise 50 [get_ports {fdfx_powergood}]
  set_input_delay -add_delay -max -fall -clock clock  465 [get_ports {fdfx_powergood}]
  set_annotated_transition -max -fall 50 [get_ports {fdfx_powergood}]
  set_input_delay -add_delay -min -rise -clock clock  50.0 [get_ports {fdfx_powergood}]
  set_annotated_transition -min -rise 37.5 [get_ports {fdfx_powergood}]
  set_input_delay -add_delay -min -fall -clock clock  50.0 [get_ports {fdfx_powergood}]
  set_annotated_transition -min -fall 37.5 [get_ports {fdfx_powergood}]
#  set_driving_cell -lib_cell ec0bfn000al1n08x5 [get_ports {fdfx_powergood}]
  set_max_capacitance 50 [get_ports {fdfx_powergood}]
} else {
  puts "Error: Port fdfx_powergood does not exist"
}
#----- End of port: fdfx_policy_update ------------------------------
#----- Start of port: fdfx_policy_update ------------------------------
if { [sizeof_collection [get_ports -quiet {fdfx_policy_update}]] > 0 } {
  set_annotated_transition -max -rise 50 [get_ports {fdfx_policy_update}]
  set_annotated_transition -max -fall 50 [get_ports {fdfx_policy_update}]
  set_annotated_transition -min -rise 37.5 [get_ports {fdfx_policy_update}]
  set_annotated_transition -min -fall 37.5 [get_ports {fdfx_policy_update}]
  set_driving_cell -lib_cell ec0bfn000al1n08x5 [get_ports {fdfx_policy_update}]
  set_max_capacitance 50 [get_ports {fdfx_policy_update}]
} else {
  puts "Error: Port fdfx_policy_update does not exist"
}
#----- End of port: fdfx_policy_update ------------------------------
