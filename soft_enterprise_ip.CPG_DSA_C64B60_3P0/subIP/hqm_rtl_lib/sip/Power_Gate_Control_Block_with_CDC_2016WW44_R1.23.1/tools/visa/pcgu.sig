## This .sig file is intended to be used for automatic VISA insertion
## within the PCGU module and does not necessarily describe the 
## pcgu_visa output signal.  For the definition of pcgu_visa, please
## refer to the integration guide.
##
## Please use the $translate_path or `transclude VISA directives when
## including these files files to specify the correct hierarchies.

clk=/pcgu/pgcb_clk

$signal_path=/pcgu
clkreqseqsm_ps
tmr
pgcb_clkreq       #async -- best to observe in Bypass Mode
sync_gate
async_wake_b
clkack_syn
clkreq_sustain
acc_wake_assert   #async -- best to observe in Bypass Mode
pmc_wake_assert   #async -- best to observe in Bypass Mode
defon_flag
acc_wake_flop     #async -- best to observe in Bypass Mode


