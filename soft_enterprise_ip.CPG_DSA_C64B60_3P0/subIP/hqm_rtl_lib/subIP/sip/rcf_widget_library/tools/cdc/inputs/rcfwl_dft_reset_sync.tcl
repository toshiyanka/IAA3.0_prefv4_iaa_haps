set importWaivers 1
# Caution: clocks that are not grouped are considered as synchronous.
# Impact:  QuestaCDC does not report crossings as violations. 

# Define clocks 
# netlist clock cpu_clk_in -period 50 
netlist clock { clk_in } -period 832 -add -waveform { 0 416 }

# Define constants 
# netlist constant scan_mode 1'b0 
#netlist constant fscan_rstbyp_sel 1'b0
netlist constant fscan_rstbyp_sel 0
#netlist constant fscan_byprst_b 0

# Define Port Clock Domain - optional 
# netlist port domain { input_signal } -clock { cpu_clk_in } 
netlist port domain rst_b -input -async

# Define Blackbox 
# netlist blackbox myk 

# Set CDC Analysis constraints 
# cdc reconvergence -depth 1 -divergence_depth 1 
# cdc preference -fifo_scheme -handshake_scheme  


# Waivers 
# cdc report scheme dmux -severity evaluation 
# cdc report crossing -from siga -to sigb -severity waived 
# cdc report crossing -severity caution -module A -from sig 
# cdc report crossing -severity waived -module A 
##STRAP=0
#cdc report crossing -scheme async_reset -from rst_b -to rst_sync_deassert.dsync.ctech_lib_synccell.sync -rx_clock clk_in -module rcfwl_dft_reset_sync -severity waived -message {fscan bypass}
##STRAP=1
#cdc report crossing -scheme shift_reg -from rst_b -to {rst_sync_all.dsync.ctech_lib_doublesync.sync[0]} -rx_clock clk_in -module rcfwl_dft_reset_sync -severity waived