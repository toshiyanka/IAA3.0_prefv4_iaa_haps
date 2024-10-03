##Delay Factors
set MUL_FACTOR1 0.60
set MUL_FACTOR2 0.30
#set MUL_FACTOR2 0.30
set MUL_FACTOR3 0.70

##Congression of Ports
set stap_ports {atap_tdo atap_tdoen sntapnw_ftap_tdi sn_fwtap_shiftwr* sn_fwtap_capturewr* sftapnw_ftap_enabletdo* stap_fbscan_mode* stap_fbscan_capturedr* sftapnw_ftap_enabletap* tdr_data_out* sn_fwtap_wsi* tap_rtdr_tdi* tap_rtdr_shift*}

##Setting Input and Output delays
##Relative to Primary Clock
#Input delays
set_input_delay [expr $MUL_FACTOR1 * $ftap_tck_period] [filter_collection [get_ports *] "pin_direction == in"] -clock $TAP_CLK 
set_input_delay 0 [get_ports $TAP_CLK ] -clock $TAP_CLK 
set_input_delay [expr $MUL_FACTOR1 * $ftap_tck_period] [get_ports fdfx_powergood] -clock $TAP_CLK 
#set_input_delay [expr $MUL_FACTOR2 * $ftap_tck_period] [get_ports fdfx_powergood] -clock $TAP_CLK 

##Output Delays
set_output_delay [expr $MUL_FACTOR2 * $ftap_tck_period] [filter_collection [get_ports *] "pin_direction == out"] -clock $TAP_CLK 
#set_output_delay [expr $MUL_FACTOR1 * $ftap_tck_period] [filter_collection [get_ports *] "pin_direction == out"] -clock $TAP_CLK 
set_output_delay [expr $MUL_FACTOR2 * $ftap_tck_period] [filter_collection [get_ports $stap_ports] "pin_direction == out"] -clock $TAP_CLK 
set_output_delay [expr $MUL_FACTOR2 * $ftap_tck_period] [get_ports stap_fbscan_d6init ] -clock $TAP_CLK 
set_output_delay [expr $MUL_FACTOR2 * $ftap_tck_period] [get_ports tap_rtdr_tck] -clock $TAP_CLK 
set_output_delay [expr $MUL_FACTOR2 * $ftap_tck_period] [get_ports sn_fwtap_wrck] -clock $TAP_CLK 
set_output_delay [expr $MUL_FACTOR2 * $ftap_tck_period] [get_ports sntapnw_ftap_tck] -clock $TAP_CLK 
set_output_delay [expr $MUL_FACTOR2 * $ftap_tck_period] [filter_collection [get_ports stap_fbscan_*] "@pin_direction == out"] -clock $TAP_CLK 

##Setting Input and Output delays
##Relative to Secondary Clock
#Input delays
set_input_delay [expr $MUL_FACTOR1 * $ftapsslv_tck_period] [filter_collection [get_ports *] "pin_direction == in"] -clock $TAP_SSLVCLK
set_input_delay 0 [get_ports $TAP_SSLVCLK] -clock $TAP_SSLVCLK
set_input_delay [expr $MUL_FACTOR1 * $ftapsslv_tck_period] [get_ports fdfx_powergood] -clock $TAP_SSLVCLK
set_input_delay [expr $MUL_FACTOR2 * $ftapsslv_tck_period] [get_ports ftap_trst_b] -clock $TAP_SSLVCLK

##Output Delays
set_output_delay [expr $MUL_FACTOR2 * $ftapsslv_tck_period] [filter_collection [get_ports *] "pin_direction == out"] -clock $TAP_SSLVCLK
#set_output_delay [expr $MUL_FACTOR1 * $ftapsslv_tck_period] [filter_collection [get_ports *] "pin_direction == out"] -clock $TAP_SSLVCLK
set_output_delay [expr $MUL_FACTOR2 * $ftapsslv_tck_period] [filter_collection [get_ports $stap_ports] "pin_direction == out"] -clock $TAP_SSLVCLK
set_output_delay [expr $MUL_FACTOR2 * $ftapsslv_tck_period] [get_ports stap_fbscan_d6init ] -clock $TAP_SSLVCLK
set_output_delay [expr $MUL_FACTOR2 * $ftapsslv_tck_period] [get_ports tap_rtdr_tck] -clock $TAP_SSLVCLK
set_output_delay [expr $MUL_FACTOR2 * $ftapsslv_tck_period] [get_ports sn_fwtap_wrck] -clock $TAP_SSLVCLK
set_output_delay [expr $MUL_FACTOR2 * $ftapsslv_tck_period] [get_ports sntapnw_ftap_tck] -clock $TAP_SSLVCLK
set_output_delay [expr $MUL_FACTOR2 * $ftapsslv_tck_period] [filter_collection [get_ports stap_fbscan_*] "@pin_direction == out"] -clock $TAP_SSLVCLK
