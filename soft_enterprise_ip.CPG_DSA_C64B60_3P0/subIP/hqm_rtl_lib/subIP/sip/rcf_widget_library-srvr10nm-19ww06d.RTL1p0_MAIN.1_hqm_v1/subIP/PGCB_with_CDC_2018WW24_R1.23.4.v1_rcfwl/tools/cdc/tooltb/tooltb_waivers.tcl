#-----------------------------------------------------------------------
# Intel Proprietary -- Copyright 2012 Intel -- All rights reserved
#-----------------------------------------------------------------------
# Description: Unit CDC waivers file.
#-----------------------------------------------------------------------

#Example:
#cdc report crossing -scheme <scheme_name> -from {<tx_signal>} -to {<rx_signal>} -tx_clock <tx_clock_name> -rx_clock <rx_clock_name> -severity waived

cdc report crossing -rx_clock CDC_CLK -through *cfg_clkgate_disabled -severity waived -scheme redundant -module ClockDomainController
cdc report crossing -rx_clock CDC_CLK -through *cfg_clkgate_disabled -severity waived -scheme redundant -module tooltb_pgd_off 
cdc report crossing -rx_clock CDC_CLK -through *cfg_clkgate_disabled -severity waived -scheme redundant -module tooltb
