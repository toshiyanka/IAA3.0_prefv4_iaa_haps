create_clock -name iclk -period 2496 -waveform {0 1248} [get_ports iclk ]
set_ideal_network [get_ports iclk]

