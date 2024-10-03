# Caution: clocks that are not grouped are considered as synchronous.
# Impact:  QuestaCDC does not report crossings as violations.

# Define clocks
# netlist clock cpu_clk_in -period 50
#netlist clock { clock} -period 832 -waveform {0 416}
netlist clock {clk1} -period 2496 -waveform {0 1248} -group clk1
netlist clock {clk2} -period 832 -waveform {0 416} -group clk2
#netlist reset {rst_b} -active_low -async

# Define constants
netlist constant sel 1'b0

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
