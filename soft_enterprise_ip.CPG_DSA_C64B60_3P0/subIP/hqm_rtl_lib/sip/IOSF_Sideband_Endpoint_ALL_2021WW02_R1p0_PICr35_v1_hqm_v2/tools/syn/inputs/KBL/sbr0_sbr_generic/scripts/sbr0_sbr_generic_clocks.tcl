# Setting up the clock sbr_clk with frequency of 10.000ns
set clk_period      [expr 10.000 * $SBR_CLK_GUARDBAND * $G_NS]
set clk_waveform    [list 0 [expr $clk_period * 0.5]]
set clk_uncertainty [expr $clk_period * $SBR_CLK_UNCER_RATIO]
set clk_transition  [expr $SBR_CLK_TRANS * $G_NS]

create_clock -period  $clk_period [get_ports sbr_clk] -waveform $clk_waveform
#set_clock_transition  $clk_transition  [get_clocks sbr_clk]
set_clock_uncertainty $clk_uncertainty [get_clocks sbr_clk]

set pgcb_tck {pgcb_tck}
set clk_period        [expr $PGCB_TCK_FREQ * $SBR_CLK_GUARDBAND * $G_NS]
set clk_waveform      [list 0 [expr $clk_period * 0.5]]
set clk_uncertainty   [expr $clk_period * $SBR_CLK_UNCER_RATIO]
set clk_transition    [expr $SBR_CLK_TRANS * $G_NS]
 
create_clock          -period $clk_period [get_ports $pgcb_tck] -waveform $clk_waveform
set_clock_uncertainty $clk_uncertainty [get_clocks $pgcb_tck]
 
