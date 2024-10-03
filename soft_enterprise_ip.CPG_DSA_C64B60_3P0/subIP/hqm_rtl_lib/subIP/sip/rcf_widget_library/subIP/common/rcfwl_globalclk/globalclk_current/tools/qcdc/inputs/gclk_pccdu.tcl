# Caution: clocks that are not grouped are considered as synchronous.
# Impact:  QuestaCDC does not report crossings as violations.

# Define clocks
# netlist clock cpu_clk_in -period 50
netlist clock { fdop_preclk_grid} -period 832 -waveform {0 416} -group fdop_preclk_grid
netlist clock { fdop_scan_clk} -period 832 -waveform {0 416} -group fdop_scan_clk
netlist clock { adop_postclk* }  -group fdop_preclk_grid
#netlist clock {pgcb_clk} -period 2496 -waveform {0 1248}

# Define constants
# netlist constant scan_mode 1'b0
##netlist constant fscan_dop_clken 1'b1
netlist constant {fscan_dop_clken[5:0]} 6'b111111 
netlist constant {fdop_scan_clk[5:0]}   6'b000000 

hier parameter NUM_OF_GRID_PRI_CLKS -ignore
hier parameter NUM_OF_GRID_SCC_CLKS -ignore
hier parameter GRID_SCC_PRICLK_MATRIX -ignore
hier parameter GRID_SCC_DIVISOR_MATRIX -ignore
hier parameter NUM_OF_GRID_NONSCAN_CLKS -ignore
hier parameter GRID_NONSCAN_DIVISOR_MATRIX -ignore
hier parameter PRICLK_MATRIX -ignore
hier parameter DIVISOR_MATRIX -ignore
hier parameter NS_DIVISOR_MATRIX -ignore
hier parameter GRID_NONSCAN_PRICLK_MATRIX -ignore 
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
