create_clock -name x12clk_in -period 2496 -waveform {0 1248} [get_ports x12clk_in ]
set_ideal_network [get_ports x12clk_in]

create_clock -name ck_crystal_in -period 40000 -waveform {0 20000} [get_ports ck_crystal_in ]
set_ideal_network [get_ports x12clk_in]
#if {[sizeof_collection [get_pins div9/div_dop/i_iclk_clkdiv/div.odd_divisor.negclk_reg/Q1]] > 0 } {

#create_generated_clock -name x3clk -divide_by 9  -source [get_clocks x12clk_in] [get_pins div9/div_dop/i_iclk_clkdiv/div.odd_divisor.negclk_reg/Q1] 
#create_generated_clock -name x1clk -divide_by 12 -source [get_clocks x12clk_in] [get_pins div12/div_dop/i_iclk_clkdiv/div.posclk_reg/Q] 

#}
#create_clock -name x1clk -period 7200 -waveform {0 3600} [get_net div12.i_iclk_clkdiv.clkdiv]
#set_ideal_network [get_pin div12.i_iclk_clkdiv.clkdiv]

#create_clock -name x3clk -period 5840  -waveform {0 2920} [get_net div9.i_iclk_clkdiv.clkdiv]
#set_ideal_network [get_pin div9.i_iclk_clkdiv.clkdiv]

#create_clock -name x4clk -period 1752 -waveform {0 876} [get_net div3.i_iclk_clkdiv.clkdiv]
#set_ideal_network [get_pin div3.i_iclk_clkdiv.clkdiv]

#if {[sizeof_collection [get_pins div9/div_dop.i_iclk_clkdiv/div.posclk_reg/Q ]] > 0 } {
#create_generated_clock -name x1clk -divide_by 12 -source [get_clocks x12clk_in] [get_pins div12/div_dop.i_iclk_clkdiv/div.posclk_reg/Q]
#create_generated_clock -name x3clk -divide_by 9  -source [get_clocks x12clk_in] [get_pins div9/div_dop.i_iclk_clkdiv/div.posclk_reg/Q]
#}

#if { [sizeof_collection [get_pins -of_objects div9.div_dop.i_iclk_clkdiv.div.posclk_reg -filter "direction==out" ]] > 0 } {
#create_generated_clock -name x1clk -divide_by 12 -source x12clk_in [get_pins -of_objects div12.div_dop.i_iclk_clkdiv.div.posclk_reg -filter "direction==out"]
#create_generated_clock -name x3clk -divide_by 9  -source x12clk_in [get_pins -of_objects div9.div_dop.i_iclk_clkdiv.div.posclk_reg -filter "direction==out"]
#create_generated_clock -name x4clk_free -divide_by 3  -source x12clk_in [get_pins -of_objects  div3.div3_dop.i_ctech_lib_clk_dop_div3.ctech_lib_clk_dop_div3.ctech_lib_dcszo3 -filter "direction==out"]

#}
##if { [sizeof_collection [get_pins -of_objects  div3.div3_dop.i_ctech_lib_clk_dop_div3.ctech_lib_clk_dop_div3.ctech_lib_clk_dop_div3_dcszo1 -filter "direction==out" ]] > 0 } {
#create_generated_clock -name x1clk -divide_by 12 -source x12clk_in [get_pins -of_objects div12.div_dop.i_iclk_clkdiv.div.posclk_reg -filter "direction==out"]
#create_generated_clock -name x3clk -divide_by 9  -source x12clk_in [get_pins -of_objects div9.div_dop.i_iclk_clkdiv.div.posclk_reg -filter "direction==out"]
##create_generated_clock -name x4clk_free -divide_by 3  -source x12clk_in [get_pins -of_objects div3.div3_dop.i_ctech_lib_clk_dop_div3.ctech_lib_clk_dop_div3.ctech_lib_clk_dop_div3_dcszo1  -filter "direction==out"]

##}
