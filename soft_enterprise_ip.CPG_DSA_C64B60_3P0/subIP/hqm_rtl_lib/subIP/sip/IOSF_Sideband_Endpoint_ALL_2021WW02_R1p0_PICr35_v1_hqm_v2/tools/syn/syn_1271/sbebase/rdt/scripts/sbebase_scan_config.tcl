
##########################################################################################
# Hookup testports - User needs to specify existing port/pin through G_DFT_TESTMODE_PORTS
# in block_setup.tcl.  This port is where all the .te pin of ICG will be hooked up to
# if port is not specified, DC will create either new test_se or test_cgtm port.
# P_hookup_test_port


# DFT Configuration - PRESET as default can be overwrite by user's scan configuration file.
set_dft_insertion_configuration -preserve_design_name true
set_dft_insertion_configuration -synthesis_optimization none -unscan true

# Must reidentify CG cells for proper test port connection in netlist flow -RR
# identify_clock_gating

#Setting to enable internal pins such as clock, scan-enable to be specified as DFT signals.
set_dft_drc_configuration -clock_gating_init_cycles 4 -internal_pins enable

# set_scan_configuration -clock_mixing mix_clocks
# set_scan_configuration -insert_terminal_lockup true -add_lockup true

# We are not doing at-speed SCAN only normal scan with fixed clock frequency
set_scan_configuration -style multiplexed_flip_flop -max_length 200 -add_lockup false -clock_mixing no_mix -replace false -voltage_mixing false -power_domain_mixing false

# Remove latches from being used for scan-chain. latch is transparent in scan
set_scan_element false [all_registers -level_sensitive]
 
set_dft_signal -port [get_ports {fscan_shiften}]   -view existing_dft -type ScanEnable  -active_state 1 -view spec

#Setting all endpiont design clocks and resets
set_dft_signal -port [get_ports {fscan_byprst_b side_rst_b}] -view existing_dft -type Reset     -active_state 0
set_dft_signal -port [get_ports {side_clk}]                  -view existing_dft -type ScanClock -timing [list 45 55]

if {[sizeof_collection [get_cells {gen_async_blk1_sync_rstb}]] > 0} {
   set_dft_signal -port [get_ports {agent_clk}]             -view existing_dft -type ScanClock -timing [list 45 55]
   puts "Sideband Endpoint is in Async Mode, using agent_clk for scan clock insertion"
}

set_dft_signal -port [get_ports {fscan_clkungate    }] -view existing_dft -type TestMode -active_state 1
set_dft_signal -port [get_ports {fscan_clkungate_syn}] -view existing_dft -type TestMode -active_state 1
set_dft_signal -port [get_ports {fscan_mode         }] -view existing_dft -type TestMode -active_state 1

set_dft_signal -port [get_ports {fscan_rstbypen     }] -view existing_dft -type Constant -active_state 1
set_dft_signal -port [get_ports {fscan_latchopen    }] -view existing_dft -type Constant -active_state 1
set_dft_signal -port [get_ports {fscan_latchclosed_b}] -view existing_dft -type Constant -active_state 0

## IDEAL NETWORK
set_ideal_network [get_ports {fscan_clkungate fscan_clkungate_syn fscan_mode}]
set_ideal_network [get_ports {fscan_shiften}]

## Setting nonscannable reg/latch
set_scan_element false [get_cells -hier *noscan*]

###############################################################################
# Creates a test protocol based on user specification.
# This command creates a test protocol for the current design based on
# user specifications issued prior to running this command. Such specifications
# are made using commands such as set_dft_signal.
###############################################################################

create_test_protocol

#write_test_protocol -o $G_REPORTS_DIR/sbebase.scan_test.spf

# set scan ready state
set_scan_state test_ready
