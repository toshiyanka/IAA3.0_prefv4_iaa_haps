#### PGCBCG Reference Design Waivers ####
#-----------------------------------------------------------------------
# Intel Proprietary -- Copyright 2012 Intel -- All rights reserved
#-----------------------------------------------------------------------
# Description: Unit CDC waivers file.
#-----------------------------------------------------------------------

#### PGCBCG Reference Design Waivers ####

# CDC clkacks are combined before feeding double_sync, hysteresis in the PCGU will filter any clocks where a '0' is synchronized erroneously
cdc report crossing -scheme combo_logic -through *iosf_cdc_clkack -through *i_pgcb_ctech_doublesync_idle_event.d -rx_clock PGCB_CLK -severity waived -module pgcbcg 

# CDC gclock_ack's are combined before feeding double_sync, hysteresis in the PCGU will filter any clocks where a '0' is synchronized erroneously
cdc report crossing -scheme combo_logic -through *iosf_cdc_gclock_ack_async* -through *i_pgcb_ctech_doublesync_idle_event.d -severity waived -module pgcbcg 

# Async signals feed into the visa bus, this waiver might be needed depending on the clock of the pgcb_visa
cdc report crossing -scheme no_sync -through visa_bus -severity waived -module pgcbcg 

