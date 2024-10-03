create_clock -name clk_in -period 2496 -waveform {0 1248} [get_ports clk_in ]
set_ideal_network [get_ports clk_in]

