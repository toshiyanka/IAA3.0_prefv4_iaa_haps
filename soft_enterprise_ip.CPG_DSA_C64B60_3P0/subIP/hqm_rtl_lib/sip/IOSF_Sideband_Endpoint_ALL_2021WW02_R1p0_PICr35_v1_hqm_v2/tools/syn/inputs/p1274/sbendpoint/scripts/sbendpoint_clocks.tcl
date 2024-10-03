source $::env(MODEL_ROOT)/tools/fishtail/inputs/p1274/sbendpoint/scripts/proj_override_file.cfg 
set clk_period      [expr $EP_SIDE_CLK_PERIOD * $G_NS * $EP_CLK_GUARDBAND]
set clk_waveform    [list 0 [expr $clk_period * 0.5]]

create_clock -period $clk_period [get_ports side_clk]  -waveform $clk_waveform -name side_clk

set clk_period      [expr $EP_AGENT_CLK_PERIOD * $G_NS * $EP_CLK_GUARDBAND]
set clk_waveform    [list 0 [expr $clk_period * 0.5]]

create_clock -period $clk_period [get_ports agent_clk] -waveform $clk_waveform -name agent_clk
