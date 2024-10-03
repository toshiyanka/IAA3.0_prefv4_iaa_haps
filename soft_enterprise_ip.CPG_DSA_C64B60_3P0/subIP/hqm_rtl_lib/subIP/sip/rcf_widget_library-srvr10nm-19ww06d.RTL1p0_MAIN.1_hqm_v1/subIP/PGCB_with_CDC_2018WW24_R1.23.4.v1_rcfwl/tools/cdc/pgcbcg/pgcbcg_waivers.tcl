#-----------------------------------------------------------------------
# Intel Proprietary -- Copyright 2012 Intel -- All rights reserved
#-----------------------------------------------------------------------
# Description: Unit CDC waivers file.
#-----------------------------------------------------------------------

#Example:
#cdc report crossing -scheme <scheme_name> -from {<tx_signal>} -to {<rx_signal>} -tx_clock <tx_clock_name> -rx_clock <rx_clock_name> -severity waived

#### PCGU Waivers ####
# pmc_ip_wake goes directly to clkreq output for IP-Inaccessible wake
# per-implementation, can only cause a glitch free transition on clkreq and will stay asserted until
# clkreq is driven by synchronous logic
cdc report crossing -scheme no_sync -through async_pmc_ip_wake -through pgcb_clkreq -severity waived -module pcgu 

# Only relevant if setting DEF_PWRON to '1':
# defon_flag goes directly to clkreq output for cold boot wake will stay asserted until
# clkreq is driven by synchronous logic to avoid glitches
cdc report crossing -scheme no_sync -tx_clock PGCB_CLK -from defon_flag -through pgcb_clkreq -severity waived -module pcgu 

# The following mask terms will not cause transitions on clkreq as it will be driven from another
# another path when they assert/deassert
cdc report crossing -scheme no_sync -tx_clock PGCB_CLK -from mask_pmc_wake -through pgcb_clkreq -severity waived -module pcgu 
cdc report crossing -scheme no_sync -tx_clock PGCB_CLK -from mask_acc_wake -through pgcb_clkreq -severity waived -module pcgu

# clkreq_sustain is takes over driving pgcb_clkreq when the clock starts running, and will cause
# synchronous deassertion of clkreq, all of which will be glitch free
cdc report crossing -scheme no_sync -tx_clock PGCB_CLK -from clkreq_sustain -through pgcb_clkreq -severity waived -module pcgu

# Path from acc_wake_flop to pgcb_clkreq, will not cause glitches on pgcb_clkreq 
cdc report crossing -scheme no_sync -tx_clock PGCB_CLK -from acc_wake_flop -through pgcb_clkreq -severity waived -module pcgu

# Path from async_pmc_ip_wake to doublesync has combi logic, pmc_wake is mostly static and is well behaved,
# if it asserts it will stay asserted until it has been synchronized and by the time it deasserts it should be masked off
cdc report crossing -scheme combo_logic -through async_pmc_ip_wake -through i_pgcb_ctech_doublesync_pmc_wake.d -severity waived -module pcgu


#### PCGU_AWW Waivers ####
# PCGU async set circuit, combi logic on the clr_b term of the 2 doublesyncs used to set the flops
cdc report crossing -through async_wake_source_b -through i_pgcb_ctech_doublesync_async_wake_*.clr_b -rx_clock PGCB_CLK -module pcgu_aww -severity waived


