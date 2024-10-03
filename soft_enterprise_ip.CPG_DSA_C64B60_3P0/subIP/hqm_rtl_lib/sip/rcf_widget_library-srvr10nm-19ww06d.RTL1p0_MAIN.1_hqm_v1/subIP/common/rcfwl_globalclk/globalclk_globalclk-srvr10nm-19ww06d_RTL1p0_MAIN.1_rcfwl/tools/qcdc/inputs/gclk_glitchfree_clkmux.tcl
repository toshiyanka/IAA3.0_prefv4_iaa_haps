# Caution: clocks that are not grouped are considered as synchronous.
# Impact:  QuestaCDC does not report crossings as violations.

# Define clocks
# netlist clock cpu_clk_in -period 50
#netlist clock { clock} -period 832 -waveform {0 416}
netlist clock {agentclk} -period 2496 -waveform {0 1248} -group Groupagentclk
netlist clock {x12clk} -period 832 -waveform {0 416} -group Groupx12clk
##netlist reset {iso_b} -active_low -async

netlist port domain { agentclk_sync } -clock { Groupagentclk }
netlist port domain { x12clk_sync } -clock { Groupx12clk}

netlist constant iso_b 1'b1
netlist constant agntclk_ff2 1'b1 -module rcfwl_gclk_glitchfree_clkmux
netlist constant agntclk_ff3 1'b1 -module rcfwl_gclk_glitchfree_clkmux
netlist constant x12clk_ff2 1'b1 -module rcfwl_gclk_glitchfree_clkmux
netlist constant x12clk_ff3 1'b1 -module rcfwl_gclk_glitchfree_clkmux
# Define constants
# netlist constant scan_mode 1'b0

# Define Port Clock Domain - optional
# netlist port domain { input_signal } -clock { cpu_clk_in }

# Define Blackbox
#netlist blackbox rcfwl_ClockDomainController

# Set CDC Analysis constraints
# cdc reconvergence -depth 1 -divergence_depth 1
# cdc preference -fifo_scheme -handshake_scheme
# Waivers
# cdc report scheme dmux -severity evaluation
# cdc report crossing -from siga -to sigb -severity waived
# cdc report crossing -severity caution -module A -from sig
# cdc report crossing -severity waived -module A

cdc report scheme bus_dff_sync_combo_clock -severity caution
cdc report scheme dff_sync_combo_clk -severity caution
cdc report scheme reconvergence_bus -severity violation
cdc report scheme reconvergence_mixed -severity violation
cdc reconvergence on 
cdc preference -enable_internal_resets -fifo_scheme -filtered_report -handshake_scheme
cdc preference hier -ctrl_file_models -conflict_check
cdc synchronizer dff -min 2 -max 5
netlist constant propagation -enable
cdc report scheme two_dff -severity violation
cdc report scheme bus_two_dff -severity violation
cdc report scheme single_source_reconvergence -severity caution
cdc report scheme pulse_sync -severity violation
cdc report scheme two_dff_phase -severity violation
cdc report scheme bus_two_dff_phase -severity violation
cdc report scheme shift_reg -severity violation
cdc report scheme async_reset -severity violation
cdc report scheme four_latch -severity violation
cdc report scheme bus_four_latch -severity violation

# cdc report item -scheme combo_logic -from {i_x12clk_ctech_lib_doublesync_rstb.ctech_lib_doublesync_rstb.sync[1]} -to {i_agtclk_ctech_lib_doublesync_rstb.ctech_lib_doublesync_rstb.sync[0]} -tx_clock Groupx12clk -rx_clock Groupagentclk -module rcfwl_gclk_glitchfree_clkmux -status waived
cdc report crossing -scheme combo_logic -from {i_agtclk_ctech_lib_doublesync_rstb.ctech_lib_doublesync_rstb.sync[1]} -to {i_x12clk_ctech_lib_doublesync_rstb.ctech_lib_doublesync_rstb.sync[0]} -tx_clock Groupagentclk -rx_clock Groupx12clk -module rcfwl_gclk_glitchfree_clkmux -severity waived -message {this is syncronized with double sync}
cdc report crossing -scheme combo_logic -from agtclk_ff2 -to {x12clk_ctech_lib_doublesync_rstb.ctech_lib_doublesync_rstb.sync[0]} -tx_clock Groupagentclk -rx_clock Groupx12clk -module rcfwl_gclk_glitchfree_clkmux -severity waived -message {There is a double sync flop to syncronize the input into agentclk domain}
cdc report crossing -scheme combo_logic -from x12clk_ff2 -to {i_agtclk_ctech_lib_doublesync_rstb.ctech_lib_doublesync_rstb.sync[0]} -tx_clock Groupx12clk -rx_clock Groupagentclk -module rcfwl_gclk_glitchfree_clkmux -severity waived -message {this is a double sync to syncronize input signal into agent clk domain}
cdc report crossing -scheme combo_logic -from x12clk_ff2 -to {agtclk_ctech_lib_doublesync_rstb.ctech_lib_doublesync_rstb.sync[0]} -tx_clock Groupx12clk -rx_clock Groupagentclk -module rcfwl_gclk_glitchfree_clkmux -severity waived -message {This is double sync to syncronize input into x12clk domain}
cdc report crossing -scheme combo_logic -from {i_x12clk_ctech_lib_doublesync_rstb.ctech_lib_doublesync_rstb.sync[1]} -to {i_agtclk_ctech_lib_doublesync_rstb.ctech_lib_doublesync_rstb.sync[0]} -tx_clock Groupx12clk -rx_clock Groupagentclk -module rcfwl_gclk_glitchfree_clkmux -severity waived -message {coming input signal is syncronized in agent clk domain}
cdc report crossing -scheme shift_reg  -from x12clk_ff2 -to {agtclk_ctech_lib_doublesync_rstb.ctech_lib_doublesync_rstb.sync[0]} -tx_clock Groupx12clk -rx_clock Groupagentclk -module rcfwl_gclk_glitchfree_clkmux -severity waived -message {This is double sync to syncronize  shift input into x12clk domain}
