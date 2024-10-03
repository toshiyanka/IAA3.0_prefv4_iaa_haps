## This .sig file is intended to be used for automatic VISA insertion
## within the pgcbunit module and does not necessarily describe the 
## pgcb_visa output signal.  For the definition of pgcb_visa, please
## refer to the integration guide.
##
## Please use the $translate_path or `transclude VISA directives when
## including these files files to specify the correct hierarchies.

clk=/pgcbunit/clk

$signal_path=/pgcbunit/i_pgcbfsm1
pgcb_ps
ip_pgcb_pg_rdy_req_b
sync_pmc_pgcb_pg_ack_b
sync_pmc_pgcb_restore_b
int_pg_type
int_sleep_en
int_isollatch_en

$fill_lane


clk=/pgcbunit/pgcb_tck

$signal_path=/pgcbunit/i_pgcbdfxovr1
dfxseq_ps


