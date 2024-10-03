## synthesis contraints start from here

##False Paths
set_false_path -from [get_ports ftap_tdi] -to [get_ports atapsslv_tdo]
set_false_path -from [get_ports ftapsslv_tdi] -to [get_ports atap_tdo]

set_false_path -from [get_ports fdfx_earlyboot_exit]
set_false_path -from [get_ports fdfx_powergood]
##Max Delay Constraints
set_max_delay [expr 0.5 * $ftap_tck_period] -from [get_ports ftap_tdi] -to [get_ports atap_tdo]
set_max_delay [expr 0.5 * $ftap_tck_period] -from [get_ports ftapsslv_tdi] -to [get_ports atapsslv_tdo]
