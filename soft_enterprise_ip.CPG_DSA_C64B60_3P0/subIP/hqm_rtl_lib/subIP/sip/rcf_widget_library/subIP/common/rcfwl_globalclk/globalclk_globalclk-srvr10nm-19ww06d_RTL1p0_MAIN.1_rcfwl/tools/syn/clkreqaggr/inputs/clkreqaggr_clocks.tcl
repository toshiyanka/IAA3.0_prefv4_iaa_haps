create_clock -name gclk -period 2500 -waveform {0 1250} [get_ports iclk ]
set_ideal_network [get_ports iclk]

