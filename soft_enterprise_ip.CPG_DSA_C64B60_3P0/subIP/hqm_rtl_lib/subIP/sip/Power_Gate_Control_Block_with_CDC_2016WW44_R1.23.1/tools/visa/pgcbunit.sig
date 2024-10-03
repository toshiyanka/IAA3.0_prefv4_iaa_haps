## This .sig file is intended to be used for automatic VISA insertion
## within the pgcbunit module and does not necessarily describe the 
## pgcb_visa output signal.  For the definition of pgcb_visa, please
## refer to the integration guide.
##
## Please use the $translate_path or `transclude VISA directives when
## including these files files to specify the correct hierarchies.

clk=/hqm_pgcbunit/clk

$signal_path=/hqm_pgcbunit/i_pgcbfsm1
pgcb_ps[4:0]
ip_pgcb_pg_rdy_req_b
sync_pmc_pgcb_pg_ack_b
sync_pmc_pgcb_restore_b
int_pg_type[1:0]
int_sleep_en
int_isollatch_en

$fill_lane


clk=/hqm_pgcbunit/pgcb_tck

$signal_path=/hqm_pgcbunit/i_pgcbdfxovr1
dfxseq_ps[2:0]
