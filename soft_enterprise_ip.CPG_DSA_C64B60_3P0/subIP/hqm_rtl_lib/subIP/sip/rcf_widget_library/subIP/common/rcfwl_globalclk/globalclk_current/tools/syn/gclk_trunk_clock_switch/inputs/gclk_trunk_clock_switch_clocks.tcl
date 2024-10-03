create_clock -name clk_in -period 744 -waveform {0 372} [get_ports clk_in ]
set_ideal_network [get_ports clk_in]

###create_generated_clock -add -name x6clk -master_clock clk_in -divide_by 2  -source [get_pins i_ctech_lib_glbdrvdclk/ctech_lib_glbdrvdclk_dcszo/clkin] [get_pins i_ctech_lib_glbdrvdclk/ctech_lib_glbdrvdclk_dcszo/NX]
#create_generated_clock -add -name x6clk -master_clock clk_in -divide_by 2  -source [get_pins i_gclk_ctech_lib_glbdrvdclk/i_ctech_lib_glbdrvdclk/ctech_lib_glbdrvdclk_dcszo/clkin] [get_pins i_gclk_ctech_lib_glbdrvdclk/i_ctech_lib_glbdrvdclk/ctech_lib_glbdrvdclk_dcszo/NX]
create_generated_clock -add -name x6clk -master_clock clk_in -divide_by 2  -source [get_ports clk_in] [get_pins -quiet {i_gclk_ctech_lib_glbdrvdclk/i_ctech_lib_glbdrvdclk/ctech_lib_glbdrvdclk_dcszo/NX i_gclk_ctech_lib_glbdrvdclk.i_ctech_lib_glbdrvdclk.ctech_lib_glbdrvdclk_dcszo/NX}]
