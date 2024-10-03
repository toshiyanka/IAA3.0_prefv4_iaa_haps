#######################################################
### Created by : swho1
### Date     : Tue Nov 24 14:56:33 2015
### Using    : speckle2sdc
#######################################################

## Basic header
##set_units -time ps -resistance kOhm -capacitance fF -voltage V -current mA
##set_operating_conditions typical_1.00 -library e05_ln_p1274_2x0r1_tttt_v065_t100_max
set_max_transition 93 [current_design]
set_max_fanout 50 [current_design]

#----- Start of port: clk_in ------------------------------
if { [sizeof_collection [get_ports -quiet {clk_in}]] > 0 } {
  set_annotated_transition -max -rise 50 [get_ports {clk_in}]
  set_annotated_transition -min -rise 25 [get_ports {clk_in}]
  set_annotated_transition -max -fall 50 [get_ports {clk_in}]
  set_annotated_transition -min -fall 25 [get_ports {clk_in}]
  set_max_capacitance 50 [get_ports {clk_in}]
  set_driving_cell -lib_cell ec0bfn000al1n08x5 [get_ports {clk_in}]
} else {
  puts "Error: Port clk_in does not exist"
}
#----- End of port: clk_in ------------------------------

#----- Start of port: rst_b ------------------------------
if { [sizeof_collection [get_ports -quiet {rst_b}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock clk_in  221 [get_ports {rst_b}]
  set_input_delay -add_delay -max -fall -clock clk_in  221 [get_ports {rst_b}]
  set_input_delay -add_delay -min -rise -clock clk_in  37.3 [get_ports {rst_b}]
  set_input_delay -add_delay -min -fall -clock clk_in  37.3 [get_ports {rst_b}]
  set_annotated_transition -max -rise 50 [get_ports {rst_b}]
  set_annotated_transition -min -rise 25 [get_ports {rst_b}]
  set_annotated_transition -max -fall 50 [get_ports {rst_b}]
  set_annotated_transition -min -fall 25 [get_ports {rst_b}]
  set_max_capacitance 50 [get_ports {rst_b}]
  set_driving_cell -lib_cell ec0bfn000al1n08x5 [get_ports {rst_b}]
} else {
  puts "Error: Port rst_b does not exist"
}
#----- End of port: rst_b ------------------------------

#----- Start of port: fscan_rstbyp_sel ------------------------------
if { [sizeof_collection [get_ports -quiet {fscan_rstbyp_sel}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock clk_in  221 [get_ports {fscan_rstbyp_sel}]
  set_input_delay -add_delay -max -fall -clock clk_in  221 [get_ports {fscan_rstbyp_sel}]
  set_input_delay -add_delay -min -rise -clock clk_in  37.3 [get_ports {fscan_rstbyp_sel}]
  set_input_delay -add_delay -min -fall -clock clk_in  37.3 [get_ports {fscan_rstbyp_sel}]
  set_annotated_transition -max -rise 50 [get_ports {fscan_rstbyp_sel}]
  set_annotated_transition -min -rise 25 [get_ports {fscan_rstbyp_sel}]
  set_annotated_transition -max -fall 50 [get_ports {fscan_rstbyp_sel}]
  set_annotated_transition -min -fall 25 [get_ports {fscan_rstbyp_sel}]
  set_max_capacitance 50 [get_ports {fscan_rstbyp_sel}]
  set_driving_cell -lib_cell ec0bfn000al1n08x5 [get_ports {fscan_rstbyp_sel}]
} else {
  puts "Error: Port fscan_rstbyp_sel does not exist"
}
#----- End of port: fscan_rstbyp_sel ------------------------------

#----- Start of port: fscan_byprst_b ------------------------------
if { [sizeof_collection [get_ports -quiet {fscan_byprst_b}]] > 0 } {
  set_input_delay -add_delay -max -rise -clock clk_in  221 [get_ports {fscan_byprst_b}]
  set_input_delay -add_delay -max -fall -clock clk_in  221 [get_ports {fscan_byprst_b}]
  set_input_delay -add_delay -min -rise -clock clk_in  37.3 [get_ports {fscan_byprst_b}]
  set_input_delay -add_delay -min -fall -clock clk_in  37.3 [get_ports {fscan_byprst_b}]
  set_annotated_transition -max -rise 50 [get_ports {fscan_byprst_b}]
  set_annotated_transition -min -rise 25 [get_ports {fscan_byprst_b}]
  set_annotated_transition -max -fall 50 [get_ports {fscan_byprst_b}]
  set_annotated_transition -min -fall 25 [get_ports {fscan_byprst_b}]
  set_max_capacitance 50 [get_ports {fscan_byprst_b}]
  set_driving_cell -lib_cell ec0bfn000al1n08x5 [get_ports {fscan_byprst_b}]
} else {
  puts "Error: Port fscan_byprst_b does not exist"
}
#----- End of port: fscan_byprst_b ------------------------------

#----- Start of port: synced_rst_b ------------------------------
if { [sizeof_collection [get_ports -quiet {synced_rst_b}]] > 0 } {
  set_max_transition 50 [get_ports {synced_rst_b}]
  set_output_delay -add_delay -max -rise -clock clk_in  121 [get_ports {synced_rst_b}]
  set_output_delay -add_delay -max -fall -clock clk_in  121 [get_ports {synced_rst_b}]
  set_output_delay -add_delay -min -rise -clock clk_in  22.1 [get_ports {synced_rst_b}]
  set_output_delay -add_delay -min -fall -clock clk_in  22.1 [get_ports {synced_rst_b}]
  set_load -max 10 [get_ports {synced_rst_b}]
  set_load -min 5 [get_ports {synced_rst_b}]
  set_max_capacitance 10 [get_ports {synced_rst_b}]
} else {
  puts "Error: Port synced_rst_b does not exist"
}
#----- End of port: synced_rst_b ------------------------------

