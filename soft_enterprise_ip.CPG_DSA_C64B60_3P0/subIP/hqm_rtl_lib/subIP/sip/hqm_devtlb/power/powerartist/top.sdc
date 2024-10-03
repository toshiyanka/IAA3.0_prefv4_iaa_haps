set PERIOD 1 ;# 1 ns clock period -> 1000 MHz max
set INPUT_DELAY 0.1
set OUTPUT_DELAY 0.1
set CLOCK_LATENCY 0.15
set MIN_TO_DELAY 0.1
set MAX_TRANSITION 0.05

# Clock constraints
create_clock -name "clk" -period $PERIOD [get_port clk]
#set_clock_latency $CLOCK_LATENCY [get_clocks soc_clk]
# Set soc_clk uncertainity (jitter/skew): maximum time difference between two pins on # a chip receiving the same clk signal
#set_clock_uncertainty 0.3 [get_clocks soc_clk]
# Set soc_clk transition: time for clk to go 0->1 or 1->0
#set_clock_transition 0.4 [get_clocks soc_clk]
SetClockGatingStyle -clock_cell_attribute latch_posedge_precontrol -min_bit_width 3 -min_bit_width_ecg 6


# Clock constraints
#create_clock -name "soc_clk2" -period $PERIOD [get_port soc_clk2]
#set_clock_latency $CLOCK_LATENCY [get_clocks soc_clk2]
# Set soc_clk uncertainity (jitter/skew): maximum time difference between two pins on # a chip receiving the same clk signal
#set_clock_uncertainty 0.3 [get_clocks soc_clk2]
# Set soc_clk transition: time for clk to go 0->1 or 1->0
#set_clock_transition 0.4 [get_clocks soc_clk2]


# Clock constraints
#create_clock -name "soc_clk3" -period $PERIOD [get_port soc_clk3]
#set_clock_latency $CLOCK_LATENCY [get_clocks soc_clk3]
# Set soc_clk uncertainity (jitter/skew): maximum time difference between two pins on # a chip receiving the same clk sig
#set_clock_uncertainty 0.3 [get_clocks soc_clk3]
# Set soc_clk transition: time for clk to go 0->1 or 1->0
#set_clock_transition 0.4 [get_clocks soc_clk3]


