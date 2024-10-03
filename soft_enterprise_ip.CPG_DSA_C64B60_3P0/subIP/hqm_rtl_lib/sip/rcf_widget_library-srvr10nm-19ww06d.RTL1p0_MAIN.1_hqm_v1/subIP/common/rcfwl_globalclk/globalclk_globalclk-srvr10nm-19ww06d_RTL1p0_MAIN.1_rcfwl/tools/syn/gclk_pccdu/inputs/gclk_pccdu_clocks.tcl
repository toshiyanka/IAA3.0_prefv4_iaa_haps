create_clock -name fdop_preclk_grid[2] -period 2496 -waveform {0 1248} [get_ports fdop_preclk_grid[2] ]
set_ideal_network [get_ports fdop_preclk_grid[2]]

create_clock -name fdop_preclk_grid[1] -period 2496 -waveform {0 1248} [get_ports fdop_preclk_grid[1] ]
set_ideal_network [get_ports fdop_preclk_grid[2]]

create_clock -name fdop_preclk_grid[0] -period 2496 -waveform {0 1248} [get_ports fdop_preclk_grid[0] ]
set_ideal_network [get_ports fdop_preclk_grid[2]]

create_clock -name fscan_rpt_clk -period 4992 -waveform {0 2496} [get_ports fscan_rpt_clk]
set_ideal_network [get_ports fscan_rpt_clk]

#create_clock -name fdop_scan_clk[0] -period 4992 -waveform {0 2496} [get_ports fdop_scan_clk[0]]
#set_ideal_network [get_ports fdop_scan_clk[0]]
#create_clock -name fdop_scan_clk[1] -period 4992 -waveform {0 2496} [get_ports fdop_scan_clk[1]]
#set_ideal_network [get_ports fdop_scan_clk[1]]
#create_clock -name fdop_scan_clk[2] -period 4992 -waveform {0 2496} [get_ports fdop_scan_clk[2]]
##set_ideal_network [get_ports fdop_scan_clk[2]]
#create_clock -name fdop_scan_clk[3] -period 4992 -waveform {0 2496} [get_ports fdop_scan_clk[3]]
#set_ideal_network [get_ports fdop_scan_clk[3]]
#create_clock -name fdop_scan_clk[4] -period 4992 -waveform {0 2496} [get_ports fdop_scan_clk[4]]
##set_ideal_network [get_ports fdop_scan_clk[4]]
#create_clock -name fdop_scan_clk[5] -period 4992 -waveform {0 2496} [get_ports fdop_scan_clk[5]]
#set_ideal_network [get_ports fdop_scan_clk[5]]

#create_clock -name x6clk -period 416 -waveform {0 208} [get_pin dop_loop_gated[1].dop_div.gated_clkdist_dop_div/i_iclk_clkdiv/clkdiv]
#create_clock -name x6clk -period 416 -waveform {0 208} [get_net dop_loop_gated_1.dop_div.gated_clkdist_dop_div.i_iclk_clkdiv.clkdiv]
#set_ideal_network [get_pin dop_loop_gated[1].dop_div.gated_clkdist_dop_div/i_iclk_clkdiv/clkdiv]

#create_clock -name x3clk -period 5840  -waveform {0 2920} [get_net dop_loop_gated_2.dop_div.gated_clkdist_dop_div.i_iclk_clkdiv.clkdiv]
#create_clock -name x3clk -period 5840  -waveform {0 2920} [get_pin dop_loop_gated[2].dop_div.gated_clkdist_dop_div/i_iclk_clkdiv/clkdiv]
#set_ideal_network [get_pin dop_loop_gated[2].dop_div.gated_clkdist_dop_div/i_iclk_clkdiv/clkdiv]

#create_clock -name x6clk -period 416 -waveform {0 208} [get_net dop_loop_gated_4.dop_div.gated_clkdist_dop_div.i_iclk_clkdiv.clkdiv]
#create_clock -name x6clk -period 416 -waveform {0 208} [get_pin dop_loop_gated[4].dop_div.gated_clkdist_dop_div/i_iclk_clkdiv/clkdiv]
#set_ideal_network [get_pin dop_loop_gated[4].dop_div.gated_clkdist_dop_div/i_iclk_clkdiv/clkdiv]
###if { [sizeof_collection [get_pins -of_objects i_gclk_pccdu_dop_wrapper.dop_loop_gated_1.dop_div.gated_clkdist_dop_div.div2_dop.i_ctech_lib_clk_dop_div2.ctech_lib_clk_dop_div2.ctech_lib_clk_dop_div2_dcszo1 -filter "direction==out" ]] > 0 } {
####create_generated_clock -name x6clk_0_free -divide_by 2 -source  fdop_preclk_grid[0] [get_pins -of_objects i_gclk_pccdu_dop_wrapper.dop_loop_gated_1.dop_div.gated_clkdist_dop_div.div2_dop.i_ctech_lib_clk_dop_div2.ctech_lib_clk_dop_div2.ctech_lib_clk_dop_div2_dcszo1 -filter "direction==out"]
####create_generated_clock -name x3clk_free -divide_by 4  -source  fdop_preclk_grid[0] [get_pins -of_objects  i_gclk_pccdu_dop_wrapper.dop_loop_gated_2.dop_div.gated_clkdist_dop_div.div4_dop.i_ctech_lib_clk_dop_div4.ctech_lib_clk_dop_div2or4.ctech_lib_clk_dop_div2or4_dcszo1 -filter "direction==out"]
####create_generated_clock -name x6clk_1_free -divide_by 2 -source  fdop_preclk_grid[1] [get_pins -of_objects  i_gclk_pccdu_dop_wrapper.dop_loop_gated_4.dop_div.gated_clkdist_dop_div.div2_dop.i_ctech_lib_clk_dop_div2.ctech_lib_clk_dop_div2.ctech_lib_clk_dop_div2_dcszo1 -filter "direction==out"]

####}

#if { [sizeof_collection [get_pins -of_objects i_gclk_pccdu_dop_wrapper.dop_loop_free_0.free_clkdist_dop.div1_dop.i_ctech_lib_clk_dop_div1.ctech_lib_clk_dop_div1.ctech_lib_clk_dop_div1_dcszo1 -filter "direction==in" ]] > 0 } {
#create_generated_clock -name fscan_clk_0 -divide_by 1 -source  fdop_scan_clk[0] [get_pins -of_objects  i_gclk_pccdu_dop_wrapper.dop_loop_free_0.free_clkdist_dop.div1_dop.i_ctech_lib_clk_dop_div1.ctech_lib_clk_dop_div1.ctech_lib_clk_dop_div1_dcszo1 -filter "direction==in"]
#create_generated_clock -name fscan_clk_1 -divide_by 1 -source  fdop_scan_clk[3] [get_pins -of_objects  i_gclk_pccdu_dop_wrapper.dop_loop_free_1.free_clkdist_dop.div1_dop.i_ctech_lib_clk_dop_div1.ctech_lib_clk_dop_div1.ctech_lib_clk_dop_div1_dcszo1 -filter "direction==in"]
#create_generated_clock -name fscan_clk_2 -divide_by 1 -source  fdop_scan_clk[5] [get_pins -of_objects  i_gclk_pccdu_dop_wrapper.dop_loop_free_2.free_clkdist_dop.div1_dop.i_ctech_lib_clk_dop_div1.ctech_lib_clk_dop_div1.ctech_lib_clk_dop_div1_dcszo1  -filter "direction==in"]
#}
