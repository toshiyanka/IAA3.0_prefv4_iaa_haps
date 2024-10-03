set max_delay_ratio 0.75

set_false_path -from [get_clocks side_clk] -to [get_clocks agent_clk]
set_false_path -from [get_clocks agent_clk] -to [get_clocks side_clk]

set side_clk_period  [get_attribute [get_clocks side_clk]  period]
set agent_clk_period [get_attribute [get_clocks agent_clk] period]
    
set_max_delay [expr $side_clk_period  * $max_delay_ratio] -from [get_clocks agent_clk] -to [get_clocks side_clk]
set_max_delay [expr $agent_clk_period * $max_delay_ratio] -from [get_clocks side_clk]  -to [get_clocks agent_clk]
