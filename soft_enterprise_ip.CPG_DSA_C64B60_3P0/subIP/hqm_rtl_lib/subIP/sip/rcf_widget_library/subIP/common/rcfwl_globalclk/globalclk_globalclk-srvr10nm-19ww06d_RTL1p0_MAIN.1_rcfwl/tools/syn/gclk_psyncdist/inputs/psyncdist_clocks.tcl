create_clock -name x12clk -period 832 -waveform {0 416} [get_ports x12clk_in ]
set_ideal_network [get_ports x12clk_in ]

