create_clock -name x12clk -period 832 -waveform {0 416} [get_ports fdop_preclk_grid ]
set_ideal_network [get_ports fdop_preclk_grid]

