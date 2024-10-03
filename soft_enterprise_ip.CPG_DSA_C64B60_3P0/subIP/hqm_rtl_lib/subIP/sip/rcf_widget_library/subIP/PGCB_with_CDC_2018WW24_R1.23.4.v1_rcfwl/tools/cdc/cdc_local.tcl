#====================================================================================
#
# Check Clock domain crossings through latches are done correctly in PV modelling.
# https://hsdes.intel.com/home/default.html#article?id=1604087113
#
# Issues:
#
# 1. QuestaCDC does not report crossings to or from latches when the latch clock pin is not driven by a declared clock.
# 2. QuestaCDC infers clocks from flop clock pins, but not from latch clocks.
# 3. Signals that pass through a latch from one clock domain to another are not reported as cross clock violations with current tool settings if the latch enable is not a clock.
#====================================================================================
cdc preference  -detect_pure_latch_clock



#cdc report scheme two_dff -severity violation
#cdc report scheme single_source_reconvergence -severity caution  

