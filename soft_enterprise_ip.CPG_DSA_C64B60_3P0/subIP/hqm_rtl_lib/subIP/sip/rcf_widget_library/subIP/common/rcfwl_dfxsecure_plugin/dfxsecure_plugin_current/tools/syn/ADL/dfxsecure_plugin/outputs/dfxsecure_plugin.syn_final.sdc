###################################################################

# Created by write_sdc on Thu Jan 17 23:38:53 2019

###################################################################
set sdc_version 2.0

set_units -time ps -resistance kOhm -capacitance fF -voltage V -current mA
set_operating_conditions typical_1.00 -library e05_ln_p1274d7_tttt_v065_to_v065_t100_max
create_clock -name ref_clk  -period 10000  -waveform {0 5000}
group_path -name FEED_THROUGH  -from [list [get_ports fdfx_powergood] [get_ports {fdfx_secure_policy[3]}] [get_ports {fdfx_secure_policy[2]}] [get_ports {fdfx_secure_policy[1]}] [get_ports {fdfx_secure_policy[0]}] [get_ports fdfx_earlyboot_exit] [get_ports fdfx_policy_update] [get_ports {sb_policy_ovr_value[2]}] [get_ports {sb_policy_ovr_value[1]}] [get_ports {sb_policy_ovr_value[0]}] [get_ports {oem_secure_policy[3]}] [get_ports {oem_secure_policy[2]}] [get_ports {oem_secure_policy[1]}] [get_ports {oem_secure_policy[0]}]]  -to [list [get_ports {dfxsecure_feature_en[0]}] [get_ports visa_all_dis] [get_ports visa_customer_dis]]
group_path -name INPUT_PATHS  -from [list [get_ports fdfx_powergood] [get_ports {fdfx_secure_policy[3]}] [get_ports {fdfx_secure_policy[2]}] [get_ports {fdfx_secure_policy[1]}] [get_ports {fdfx_secure_policy[0]}] [get_ports fdfx_earlyboot_exit] [get_ports fdfx_policy_update] [get_ports {sb_policy_ovr_value[2]}] [get_ports {sb_policy_ovr_value[1]}] [get_ports {sb_policy_ovr_value[0]}] [get_ports {oem_secure_policy[3]}] [get_ports {oem_secure_policy[2]}] [get_ports {oem_secure_policy[1]}] [get_ports {oem_secure_policy[0]}]]
group_path -name OUTPUT_PATHS  -to [list [get_ports {dfxsecure_feature_en[0]}] [get_ports visa_all_dis] [get_ports visa_customer_dis]]
set_output_delay -clock ref_clk  4000  [get_ports {dfxsecure_feature_en[0]}]
set_output_delay -clock ref_clk  4000  [get_ports visa_all_dis]
set_output_delay -clock ref_clk  4000  [get_ports visa_customer_dis]
