set G_NS 1000

##Reference Clock Periods
set ref_clk_period [expr 10 * $G_NS]

##Delay Factors
set MUL_FACTOR1 0.40
set MUL_FACTOR2 0.40
set MUL_FACTOR3 0.40

##Congression of Ports
set dfxsecure_plugin_ports {dfxsecure_feature_en visa_all_dis visa_customer_dis}

create_clock -name ref_clk -period $ref_clk_period 
if {($synopsys_program_name == "pt_shell")} {
##Setting Input and Output delays
##Relative to Reference Clock
#Input delays
set_input_delay [expr $MUL_FACTOR1 * $ref_clk_period] [filter_collection [get_ports *] "direction == in"] -clock ref_clk
set_input_delay [expr $MUL_FACTOR1 * $ref_clk_period] [get_ports fdfx_powergood] -clock ref_clk
set_input_delay [expr $MUL_FACTOR3 * $ref_clk_period] [filter_collection [get_ports fdfx_earlyboot_exit] "direction == in"] -clock ref_clk
} else {
##Output Delays
set_output_delay [expr $MUL_FACTOR2 * $ref_clk_period] [filter_collection [get_ports *] "direction == out"] -clock ref_clk
set_output_delay [expr $MUL_FACTOR2 * $ref_clk_period] [filter_collection [get_ports $dfxsecure_plugin_ports] "direction == out"] -clock ref_clk
}
