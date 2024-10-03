create_clock -name x12clk_in -period 2496 -waveform {0 1248} [get_ports x12clk_in ]
set_ideal_network [get_ports x12clk_in]

