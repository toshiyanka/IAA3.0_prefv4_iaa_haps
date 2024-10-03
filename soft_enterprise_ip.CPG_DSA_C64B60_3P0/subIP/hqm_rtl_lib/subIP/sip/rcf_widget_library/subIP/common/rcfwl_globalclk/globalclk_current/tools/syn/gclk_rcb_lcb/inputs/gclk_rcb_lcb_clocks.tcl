create_clock -name clk -period 2496 -waveform {0 1248} [get_ports clk]
set_ideal_network [get_ports clk]

