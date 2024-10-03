create_clock -name x12clk -period 2496 -waveform {0 1248} [get_ports x12clk ]
set_ideal_network [get_ports x12clk]
create_clock -name agentclk -period 2496 -waveform {0 1248} [get_ports agentclk ]
set_ideal_network [get_ports agentclk]
