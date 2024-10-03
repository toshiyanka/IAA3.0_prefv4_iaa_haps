# scale factor for library to convert undimensioned constraints, 
# implicitly defined in ns, to library units.
set G_NS 1

# ns period of the side_clk and agent_clk inputs to the endpoint
set EP_SIDE_CLK_PERIOD  10.0
set EP_AGENT_CLK_PERIOD 10.0
set EP_CLK_UNCER_RATIO 0.05

# Guardband (reduce) clock period by this ratio
# i.e. real period = target period * EP_CLK_GUARDBAND
set EP_CLK_GUARDBAND 0.80

#source $::env(MODEL_ROOT)/tools/fishtail/inputs/p1274/sbendpoint/scripts/proj_override_file.cfg 
set clk_period      [expr $EP_SIDE_CLK_PERIOD * $G_NS * $EP_CLK_GUARDBAND]
set clk_waveform    [list 0 [expr $clk_period * 0.5]]
set clk_uncertainty [expr $clk_period * $EP_CLK_UNCER_RATIO]

create_clock -period $clk_period [get_ports side_clk]  -waveform $clk_waveform -name side_clk
set_clock_uncertainty $clk_uncertainty [get_clocks side_clk]

set clk_period      [expr $EP_AGENT_CLK_PERIOD * $G_NS * $EP_CLK_GUARDBAND]
set clk_waveform    [list 0 [expr $clk_period * 0.5]]
set clk_uncertainty [expr $clk_period * $EP_CLK_UNCER_RATIO]

create_clock -period $clk_period [get_ports agent_clk] -waveform $clk_waveform -name agent_clk
set_clock_uncertainty $clk_uncertainty [get_clocks agent_clk]
