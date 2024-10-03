#{{{ - Nonscan Section

# DFT GLOBAL: JTAG is test only logic and should not be scanned.
set_scan_element false [get_cells -quiet -hier -filter full_name=~*_WTAP_*]
set_scan_element false [get_cells -quiet -hier -filter ref_name=~*_WTAP_*]

# DFT GLOBAL: MBIST logic is test only logic and should not be scanned. It is assumed that manufacturing will run MBIST tests which will cover logic.
set_scan_element false [get_cells -quiet -hier -filter full_name=~*_bist_wrapper_*]
set_scan_element false [get_cells -quiet -hier -filter ref_name=~*_bist_wrapper_*]

# DFT GLOBAL: MBIST logic is test only logic and should not be scanned. It is assumed that manufacturing will run MBIST tests which will cover logic.
set_scan_element false [get_cells -quiet -hier -filter full_name=~*_mbist_*]
set_scan_element false [get_cells -quiet -hier -filter ref_name=~*_mbist_*]

# DFT GLOBAL: Registers tagged with *_no_scan* are architecturally planned non-scan testable logic and should not be scanned.
set_scan_element false [get_cells -quiet -hier -filter full_name=~*_no_scan*]
set_scan_element false [get_cells -quiet -hier -filter ref_name=~*_no_scan*]

# DFT GLOBAL: Registers tagged with *_nonscan* are architecturally planned non-scan testable logic and should not be scanned.
set_scan_element false [get_cells -quiet -hier -filter full_name=~*_nonscan*]
set_scan_element false [get_cells -quiet -hier -filter ref_name=~*_nonscan*]

# DFT GLOBAL: Registers tagged with *_noscan* are architecturally planned non-scan testable logic and should not be scanned.
set_scan_element false [get_cells -quiet -hier -filter full_name=~*_noscan*]
set_scan_element false [get_cells -quiet -hier -filter ref_name=~*_noscan*]

# DFT GLOBAL: JTAG is test only logic and should not be scanned.
set_scan_element false [get_cells -quiet -hier -filter full_name=~*_stap_*]
set_scan_element false [get_cells -quiet -hier -filter ref_name=~*_stap_*]

# DFT GLOBAL: JTAG is test only logic and should not be scanned.
set_scan_element false [get_cells -quiet -hier -filter full_name=~*_tap_*]
set_scan_element false [get_cells -quiet -hier -filter ref_name=~*_tap_*]

# DFT GLOBAL: VISA is test only logic and should not be scanned. It is assumed that manufacturing will run VISA patgen test to cover logic.
set_scan_element false [get_cells -quiet -hier -filter full_name=~*_visa]
set_scan_element false [get_cells -quiet -hier -filter ref_name=~*_visa]

# DFT GLOBAL: VISA is test only logic and should not be scanned. It is assumed that manufacturing will run VISA patgen test to cover logic.
set_scan_element false [get_cells -quiet -hier -filter full_name=~*_visa_*]
set_scan_element false [get_cells -quiet -hier -filter ref_name=~*_visa_*]

# DFT GLOBAL: Registers tagged with *pgcbdfxovr* are architecturally planned non-scan testable logic and should not be scanned.
set_scan_element false [get_cells -quiet -hier -filter full_name=~*pgcbdfxovr*]
set_scan_element false [get_cells -quiet -hier -filter ref_name=~*pgcbdfxovr*]

#}}} - End Nonscan Section

