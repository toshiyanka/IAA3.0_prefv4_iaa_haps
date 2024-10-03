## The source of this file unsupported/export/data/xml
## It is then replicated by dynamo and runConfig(scripts/qa)

# DFT Configuration
set_dft_insertion_configuration -preserve_design_name true -synthesis_optimization none -unscan true
set_dft_drc_configuration -clock_gating_init_cycles 4 -internal_pins enable
set_scan_configuration -style multiplexed_flip_flop
set_scan_configuration -max_length 200
set_scan_configuration -clock_mixing no_mix
set_scan_configuration -insert_terminal_lockup true -add_lockup false
set_scan_configuration -replace false
set_scan_configuration -create_dedicated_scan_out_ports false

set dfx_scan_enable    [get_ports {fscan_shiften}]
set dfx_scan_test_mode [get_ports {fscan_clkungate_syn}]
set dfx_scan_clocks    [get_ports { sbr_clk}]
set dfx_scan_resets [ \
   get_ports {\
      fdfx_rst_b \
      sbr_rst_b \
   } \
]
set dfx_scan_constant_1s [ \
   get_ports { \
      fscan_latchopen \
      fscan_clkungate \
      fscan_clkungate_syn \
      fscan_mode \
      fscan_byplatrst_b \
   } \
]
set dfx_scan_constant_0s [ \
   get_ports {\
      fscan_latchclosed_b \
   } \
]

foreach_in_collection clock $dfx_scan_clocks {
   set_dft_signal -view existing_dft -type ScanClock -timing {45 55} -port $clock
}

foreach_in_collection reset_b $dfx_scan_resets {
   set_dft_signal -view existing_dft -type Reset -active_state 0 -port $reset_b
}

foreach_in_collection constant_1 $dfx_scan_constant_1s {
   set_dft_signal -view existing_dft -type Constant -active_state 1 -port $constant_1
}

foreach_in_collection constant_0 $dfx_scan_constant_0s {
   set_dft_signal -view existing_dft -type Constant -active_state 0 -port $constant_0
}

if { [regexp "/" $dfx_scan_enable] == 1 } {
  set_dft_signal -view spec -type ScanEnable -active_state 1 -hookup_pin $dfx_scan_enable
} elseif { $dfx_scan_enable != "" } {
  set_dft_signal -view spec -type ScanEnable -active_state 1 -port $dfx_scan_enable
}

if { [regexp "/" $dfx_scan_test_mode] == 1 } {
  set_dft_signal -view spec -type TestMode -active_state 1 -hookup_pin $dfx_scan_test_mode
} elseif { $dfx_scan_test_mode != "" } {
  set_dft_signal -view spec -type TestMode -active_state 1 -port $dfx_scan_test_mode
}


# Scratch pad to find out the presence of fscan_byprst_b. If left hanging will ruin ATPG.
set insert_sbrccfroot_sbr_generic_scan 0
set insert_sbrccfroot_sbr_generic_scan [expr {$insert_sbrccfroot_sbr_generic_scan + 1}]

if {${insert_sbrccfroot_sbr_generic_scan} > 0} {
   set_dft_signal -view existing_dft -port [get_ports {fscan_byprst_b}] -type Reset -active_state 0
   set_dft_signal -view existing_dft -port [get_ports {fscan_rstbypen}] -type Constant -active_state 1
   puts "Sideband Router is has reset bypass inserted"
}


## Setting nonscannable reg/latch
set_scan_element false [all_registers -level_sensitive]
set_scan_element false [get_cells -hier *noscan*]
#set_scan_element false [get_cells -hier *latch*]
#set_scan_element false [get_designs *stap*]
#set_scan_element false [get_designs *visa*]
#set_scan_element false [get_designs *jtag*]


###############################################################################
# Creates a test protocol based on user specification.
# This command creates a test protocol for the current design based on
# user specifications issued prior to running this command. Such specifications
# are made using commands such as set_dft_signal.
###############################################################################

create_test_protocol

# set scan ready state
set_scan_state test_ready
