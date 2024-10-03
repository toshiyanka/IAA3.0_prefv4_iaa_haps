set sdc_version 2.0
# Create Clock with fixed cycle time
set clk_period 10000
## You can set the clk_period via an argument later on if you want to enhance
set_units -time ps -resistance kOhm -capacitance fF -voltage V -current mA
set_max_transition 65 [current_design]
set_ideal_network [get_ports *reset*]
#set clk_ports [add_to_collection [get_ports *clk*] [get_cells *ckgrid*]]
set clk_ports [filter_collection [add_to_collection [get_ports *clk*] [get_cells *ckgrid*]] "port_direction==in"]
foreach clk_pin $clk_ports {
  set_ideal_network [get_ports $clk_pin]
  create_clock [get_object_name $clk_pin]  -period $clk_period  -waveform "0 [expr $clk_period/2]"
}
