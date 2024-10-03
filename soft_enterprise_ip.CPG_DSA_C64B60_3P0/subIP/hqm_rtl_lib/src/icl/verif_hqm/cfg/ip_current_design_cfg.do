# This configuration should be applied after design is elaborated
# (after check_design_rules)

# Functional IP Clocks - ports and frequencies/periods

# Following clocks can exist in RTL only
# Defined as async clocks
#add_clocks RTL_port_clk1 -period 100ns
#add_clocks RTL_port_clk2 -period 500ns

# Defining additional IP ScanInterfaces

#add_icl_scan_interfaces {TAP BISR}
#set_icl_scan_interface_ports -name TAP  -ports { JTAG_jtag_pri_source_FTAP_TCK JTAG_jtag_pri_source_FTAP_TDI JTAG_jtag_pri_source_ATAP_TDO JTAG_jtag_pri_source_FTAP_TMS JTAG_jtag_pri_source_FTAP_TRST_B}
#set_icl_scan_interface_ports -name BISR -ports { bisr_si_pd bisr_clk_pd bisr_shift_en_pd bisr_so_pd}

