set importWaivers 1
# Caution: clocks that are not grouped are considered as synchronous.
# Impact:  QuestaCDC does not report crossings as violations. 

# Define clocks 
# netlist clock cpu_clk_in -period 50 
##VISA

# Define constants 
# netlist constant scan_mode 1'b0 

# Define Port Clock Domain - optional 


# Define Blackbox 

## hier parameters

# Set CDC Analysis constraints 
# cdc reconvergence -depth 1 -divergence_depth 1 
# cdc preference -fifo_scheme -handshake_scheme  
cdc reconvergence

#waivers
#  cdc report crossing -scheme async_reset -module rcfwl_cdc_wrapper -severity waived -message {all cases the recieving module is a ctech doublesync cell}
#  cdc report crossing -scheme shift_reg -module rcfwl_cdc_wrapper -severity waived -message {all cases the recieving module is a ctech doublesync cell}
