create_clock -name clk_in -period 832 -waveform {0 416} [get_ports clk_in ]
set_ideal_network [get_ports clk_in ]

