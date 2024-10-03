## This .sig file is intended to be used for automatic VISA insertion
## within the ClockDomainController module and does not necessarily describe the 
## cdc_visa output signal.  For the definition of cdc_visa, please
## refer to the integration guide.
##
## Please use the $translate_path or `transclude VISA directives when
## including these files files to specify the correct hierarchies.

clk=/ClockDomainController/clock

$signal_path=/ClockDomainController/u_CdcMainClock
pg_disabled
not_idle
ism_wake
current_state
timer_expired
do_force_pgate
gclock_req
gclock_enable
clkreq_hold
gclock_active

$fill_lane


clk=/ClockDomainController/pgcb_clk

$signal_path=/ClockDomainController/u_CdcPgcbClock
pwrgate_ready
unlock_domain_pg
assert_clkreq_pg
domain_pok_pg
force_ready_pg
locked_pg



