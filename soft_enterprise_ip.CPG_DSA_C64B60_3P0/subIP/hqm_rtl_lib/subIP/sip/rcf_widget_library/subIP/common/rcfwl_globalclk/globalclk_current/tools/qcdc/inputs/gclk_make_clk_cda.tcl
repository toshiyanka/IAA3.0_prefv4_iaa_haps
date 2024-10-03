# Caution: clocks that are not grouped are considered as synchronous.
# Impact:  QuestaCDC does not report crossings as violations.

# Define clocks
netlist clock {CkLcpXPNB} -period 832 -waveform {0 416} -group lcp
