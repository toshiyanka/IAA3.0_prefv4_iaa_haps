# Caution: clocks that are not grouped are considered as synchronous.
# Impact:  QuestaCDC does not report crossings as violations.

# Define clocks
# netlist clock cpu_clk_in -period 50
netlist clock { clk_free_in} -period 832 -waveform {0 416} -group clk

hier parameter INPUT_SYNC_GCLK_BEFORE_GAL_SYNC	-ignore
hier parameter OUTPUT_SYNC_GCLK_BEFORE_X_SYNC	-ignore
hier parameter NO_CLKEN_SYNC	-ignore

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
