################################################
##TEST SETUP
## Specify IN_TIMEINCREMENT this is relative to the TB clock period
##  a large number will force the sstress ignals for (IN_TIMEINCREMENT)/(TB clock period) cycles
##  The advantage of a large number is a lower impact to test run time.
##  The advantage to a smaller number is more precision to forcring stress,
##  In general 3-5x the clock period is a good value
## Specify IN_TIMESTART - IN_TIMEEND
##  This will apply strss only in this time range during testing. To improve run time performance only apply stress when needed, IN_TIMESTART will advance (past initial CFG) and agitate will be executed for IN_TIMEEND 
## Specify IN_TRIGGER
##  This will poll an internal counter IN_TRIGGER_COUNTER to start agitation (after IN_TIMESTART). IN_TRIGGER_DONE specify the numbre of times to pool and disable agitate when no change
## Specify IN_MODIFY_RAND, IN_MODIFY_PTR_MULT, IN_MODIFY_VALID_KEEP_MIN and IN_MODIFY_VALID_KEEP_MAX
##  This will randomize the specified number probablities in this test. This provides additional random behavior in regression.
##  - IN_MODIFY_RAND specifies the number of bin values which will be changed to a random value.
##  - IN_MODIFY_PTR_MULT multiplied by the number of agitate signals specifies the number of times the script will randomize the starting point of a randomly selected agitate signal.
##  - IN_MODIFY_VALID_KEEP_MIN and IN_MODIFY_VALID_KEEP_MAX specify a range of values for the number of agitate signals to keep in the agitation list.  The remaining number of agitate signals will be randomly selected and removed.

##DISPLAY ARG & ENV
puts ">>>>>tcl     : $argv0"
puts ">>>>>arg cnt : $argc "
catch { puts ">>>>>args    : $argv" }
foreach index [array names env] { puts ">>>>>env var : $index : $env($index)" }

##RANDOM SEED
set tmp [expr rand()]
set IN_SEED [expr (1 + (int (10000000 * $tmp)))]
set IN_SEED $argv
set IN_SEED [regsub {.*.ntb_random_seed\=} $IN_SEED ""]
set IN_SEED [regsub { .*} $IN_SEED ""];

##dump -file dump.$IN_SEED.vpd -type vpd
set tmp [expr srand($IN_SEED)]

##TIME SIGNALS
set IN_TIMEINCREMENT "15ns"
set IN_TIMESTART "25000ns"
set IN_TIMEEND   "95000ns"
##TRIGGER SIGNALS
set IN_TRIGGER_COUNTER "hqm_tb_top.u_hqm.par_hqm_system.hqm_system_gated_wrap.i_hqm_credit_hist_pipe.i_hqm_credit_hist_pipe_core.hcw_enq_w_req_valid"
set IN_TRIGGER_DONE "200"

##RANDOMIZE SIGNALS
set IN_MODIFY_RAND "25"
set IN_MODIFY_PTR_MULT  "3"
set IN_MODIFY_VALID_KEEP_MIN "20"
set IN_MODIFY_VALID_KEEP_MAX "120"

##AGITATE TYPE SIGNALS
set AGITATE_interfaceready "1"
set AGITATE_fifoafull "0"
set AGITATE_fifoempty "0"
set AGITATE_arbv "0"
set AGITATE_pipehold "0"
set AGITATE_dbready "0"
set AGITATE_credits "0"
set AGITATE_random "0"
set AGITATE_chp "0"
set AGITATE_lsp_chicken "0"
set AGITATE_rop "0"
set AGITATE_sch "0"
set AGITATE_enq "0"
set AGITATE_cmp "0"
set AGITATE_tok "0"
set AGITATE_sys "0"

##RANDOMIZE TIMEFORCE MIN & MAX 
set in 0;
set IN_MODIFY_TIMEFORCE_MIN($in) "10ns" ; set IN_MODIFY_TIMEFORCE_MAX($in) "20ns" ; set in [expr $in + 1];
set IN_MODIFY_TIMEFORCE_MIN($in) "10ns" ; set IN_MODIFY_TIMEFORCE_MAX($in) "20ns" ; set in [expr $in + 1];
set IN_MODIFY_TIMEFORCE_MIN($in) "10ns" ; set IN_MODIFY_TIMEFORCE_MAX($in) "20ns" ; set in [expr $in + 1];

set IN_MODIFY_TIMEFORCE_MIN($in) "15ns" ; set IN_MODIFY_TIMEFORCE_MAX($in) "50ns" ; set in [expr $in + 1];
set IN_MODIFY_TIMEFORCE_MIN($in) "15ns" ; set IN_MODIFY_TIMEFORCE_MAX($in) "50ns" ; set in [expr $in + 1];
set IN_MODIFY_TIMEFORCE_MIN($in) "15ns" ; set IN_MODIFY_TIMEFORCE_MAX($in) "50ns" ; set in [expr $in + 1];
set IN_MODIFY_TIMEFORCE_MIN($in) "15ns" ; set IN_MODIFY_TIMEFORCE_MAX($in) "50ns" ; set in [expr $in + 1];
set IN_MODIFY_TIMEFORCE_MIN($in) "15ns" ; set IN_MODIFY_TIMEFORCE_MAX($in) "50ns" ; set in [expr $in + 1];
set IN_MODIFY_TIMEFORCE_MIN($in) "15ns" ; set IN_MODIFY_TIMEFORCE_MAX($in) "50ns" ; set in [expr $in + 1];
set IN_MODIFY_TIMEFORCE_MIN($in) "15ns" ; set IN_MODIFY_TIMEFORCE_MAX($in) "50ns" ; set in [expr $in + 1];
set IN_MODIFY_TIMEFORCE_MIN($in) "15ns" ; set IN_MODIFY_TIMEFORCE_MAX($in) "50ns" ; set in [expr $in + 1];

set IN_MODIFY_TIMEFORCE_MIN($in) "25ns" ; set IN_MODIFY_TIMEFORCE_MAX($in) "100ns" ; set in [expr $in + 1];
set IN_MODIFY_TIMEFORCE_MIN($in) "25ns" ; set IN_MODIFY_TIMEFORCE_MAX($in) "100ns" ; set in [expr $in + 1];

set IN_MODIFY_TIMEFORCE_MIN($in) "40ns" ; set IN_MODIFY_TIMEFORCE_MAX($in) "40ns" ; set in [expr $in + 1];

set tmp [expr rand()]
set rand [expr (int ($in * $tmp))]
set MODIFY_TIMEFORCE_MIN $IN_MODIFY_TIMEFORCE_MIN($rand)
set MODIFY_TIMEFORCE_MAX $IN_MODIFY_TIMEFORCE_MAX($rand)



################################################
##STRESS SIGNALS
## Specify stress signal and how to stress
##  IN_NET should specify a logical signal which can be stressed. should specify a input to a flop to avoid clock alignment issues.
##  IN_VALUE should specify how to stress the net, ex ready is 0, afull is 1, bp is 1.
##  IN_RAND & IN_PTR should specify the stress structure.
##    IN_RAND is a list which is evaluated every IN_TIMEINCREMENT. 
##    IN_PTR specifies where to start processing IN_RAND list of probablilites.
set in 0;
#############################################################################################################


##interface
if {$AGITATE_interfaceready == 1} {
set IN_NET($in) "hqm_tb_top.u_hqm.par_hqm_system.hqm_system_gated_wrap.i_hqm_system.i_hqm_system_core.i_hqm_system_alarm.i_cwd_alarm_rx_sync.i_hqm_AW_rx_sync_core.in_ready"; set IN_VALUE($in) 0;set IN_RAND($in) {000 000 000 000 000 000 000 000 000 000 000 000 005 040 100 040 005 000 000 000 000 000 000 000 000 000 000 000 000};set IN_PTR($in) 0;set IN_TIMEFORCE_MIN($in) $MODIFY_TIMEFORCE_MIN;set IN_TIMEFORCE_MAX($in) $MODIFY_TIMEFORCE_MAX;set in [expr $in + 1];
set IN_NET($in) "hqm_tb_top.u_hqm.par_hqm_system.hqm_system_gated_wrap.i_hqm_system.i_hqm_system_core.i_hqm_system_egress.i_hcw_sched_rx_sync.i_hqm_AW_rx_sync_core.in_ready"; set IN_VALUE($in) 0;set IN_RAND($in) {000 000 000 000 000 000 000 000 000 000 000 000 005 040 100 040 005 000 000 000 000 000 000 000 000 000 000 000 000};set IN_PTR($in) 0;set IN_TIMEFORCE_MIN($in) $MODIFY_TIMEFORCE_MIN;set IN_TIMEFORCE_MAX($in) $MODIFY_TIMEFORCE_MAX;set in [expr $in + 1];
set IN_NET($in) "hqm_tb_top.u_hqm.par_hqm_system.hqm_system_gated_wrap.i_hqm_credit_hist_pipe.i_hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_ingress.i_hcw_enq_w_rx_sync.i_hqm_AW_rx_sync_core.in_ready"; set IN_VALUE($in) 0;set IN_RAND($in) {000 000 000 000 000 000 000 000 000 000 000 000 005 040 100 040 005 000 000 000 000 000 000 000 000 000 000 000 000};set IN_PTR($in) 0;set IN_TIMEFORCE_MIN($in) $MODIFY_TIMEFORCE_MIN;set IN_TIMEFORCE_MAX($in) $MODIFY_TIMEFORCE_MAX;set in [expr $in + 1];
set IN_NET($in) "hqm_tb_top.u_hqm.par_hqm_system.hqm_system_gated_wrap.i_hqm_credit_hist_pipe.i_hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_ingress.i_qed_chp_sch_rx_sync.i_hqm_AW_rx_sync_core.in_ready"; set IN_VALUE($in) 0;set IN_RAND($in) {000 000 000 000 000 000 000 000 000 000 000 000 005 040 100 040 005 000 000 000 000 000 000 000 000 000 000 000 000};set IN_PTR($in) 0;set IN_TIMEFORCE_MIN($in) $MODIFY_TIMEFORCE_MIN;set IN_TIMEFORCE_MAX($in) $MODIFY_TIMEFORCE_MAX;set in [expr $in + 1];
set IN_NET($in) "hqm_tb_top.u_hqm.par_hqm_system.hqm_system_gated_wrap.i_hqm_credit_hist_pipe.i_hqm_credit_hist_pipe_core.i_hqm_credit_hist_pipe_ingress.i_aqed_chp_sch_rx_sync.i_hqm_AW_rx_sync_core.in_ready"; set IN_VALUE($in) 0;set IN_RAND($in) {000 000 000 000 000 000 000 000 000 000 000 000 005 040 100 040 005 000 000 000 000 000 000 000 000 000 000 000 000};set IN_PTR($in) 0;set IN_TIMEFORCE_MIN($in) $MODIFY_TIMEFORCE_MIN;set IN_TIMEFORCE_MAX($in) $MODIFY_TIMEFORCE_MAX;set in [expr $in + 1];
set IN_NET($in) "hqm_tb_top.u_hqm.par_hqm_qed_pipe.hqm_qed_pipe_gated_wrap.i_hqm_qed_pipe.i_hqm_qed_pipe_core.i_hqm_dir_pipe_core.i_rx_sync_rop_dp_enq.i_hqm_AW_rx_sync_core.in_ready"; set IN_VALUE($in) 0;set IN_RAND($in) {000 000 000 000 000 000 000 000 000 000 000 000 005 040 100 040 005 000 000 000 000 000 000 000 000 000 000 000 000};set IN_PTR($in) 0;set IN_TIMEFORCE_MIN($in) $MODIFY_TIMEFORCE_MIN;set IN_TIMEFORCE_MAX($in) $MODIFY_TIMEFORCE_MAX;set in [expr $in + 1];
set IN_NET($in) "hqm_tb_top.u_hqm.par_hqm_qed_pipe.hqm_qed_pipe_gated_wrap.i_hqm_qed_pipe.i_hqm_qed_pipe_core.i_hqm_dir_pipe_core.i_rx_sync_lsp_dp_sch_rorply.i_hqm_AW_rx_sync_core.in_ready"; set IN_VALUE($in) 0;set IN_RAND($in) {000 000 000 000 000 000 000 000 000 000 000 000 005 040 100 040 005 000 000 000 000 000 000 000 000 000 000 000 000};set IN_PTR($in) 0;set IN_TIMEFORCE_MIN($in) $MODIFY_TIMEFORCE_MIN;set IN_TIMEFORCE_MAX($in) $MODIFY_TIMEFORCE_MAX;set in [expr $in + 1];
set IN_NET($in) "hqm_tb_top.u_hqm.par_hqm_qed_pipe.hqm_qed_pipe_gated_wrap.i_hqm_qed_pipe.i_hqm_qed_pipe_core.i_hqm_dir_pipe_core.i_rx_sync_lsp_dp_sch_dir.i_hqm_AW_rx_sync_core.in_ready"; set IN_VALUE($in) 0;set IN_RAND($in) {000 000 000 000 000 000 000 000 000 000 000 000 005 040 100 040 005 000 000 000 000 000 000 000 000 000 000 000 000};set IN_PTR($in) 0;set IN_TIMEFORCE_MIN($in) $MODIFY_TIMEFORCE_MIN;set IN_TIMEFORCE_MAX($in) $MODIFY_TIMEFORCE_MAX;set in [expr $in + 1];
set IN_NET($in) "hqm_tb_top.u_hqm.par_hqm_list_sel_pipe.hqm_list_sel_pipe_gated_wrap.i_hqm_list_sel_pipe.i_hqm_list_sel_pipe_core.i_hqm_AW_rx_sync_send_atm_to_cq.i_hqm_AW_rx_sync_core.in_ready"; set IN_VALUE($in) 0;set IN_RAND($in) {000 000 000 000 000 000 000 000 000 000 000 000 005 040 100 040 005 000 000 000 000 000 000 000 000 000 000 000 000};set IN_PTR($in) 0;set IN_TIMEFORCE_MIN($in) $MODIFY_TIMEFORCE_MIN;set IN_TIMEFORCE_MAX($in) $MODIFY_TIMEFORCE_MAX;set in [expr $in + 1];
set IN_NET($in) "hqm_tb_top.u_hqm.par_hqm_list_sel_pipe.hqm_list_sel_pipe_gated_wrap.i_hqm_list_sel_pipe.i_hqm_list_sel_pipe_core.i_hqm_AW_rx_sync_rop_lsp_reordercmp.i_hqm_AW_rx_sync_core.in_ready"; set IN_VALUE($in) 0;set IN_RAND($in) {000 000 000 000 000 000 000 000 000 000 000 000 005 040 100 040 005 000 000 000 000 000 000 000 000 000 000 000 000};set IN_PTR($in) 0;set IN_TIMEFORCE_MIN($in) $MODIFY_TIMEFORCE_MIN;set IN_TIMEFORCE_MAX($in) $MODIFY_TIMEFORCE_MAX;set in [expr $in + 1];
set IN_NET($in) "hqm_tb_top.u_hqm.par_hqm_list_sel_pipe.hqm_list_sel_pipe_gated_wrap.i_hqm_list_sel_pipe.i_hqm_list_sel_pipe_core.i_hqm_AW_rx_sync_nalb_lsp_enq_rorply.i_hqm_AW_rx_sync_core.in_ready"; set IN_VALUE($in) 0;set IN_RAND($in) {000 000 000 000 000 000 000 000 000 000 000 000 005 040 100 040 005 000 000 000 000 000 000 000 000 000 000 000 000};set IN_PTR($in) 0;set IN_TIMEFORCE_MIN($in) $MODIFY_TIMEFORCE_MIN;set IN_TIMEFORCE_MAX($in) $MODIFY_TIMEFORCE_MAX;set in [expr $in + 1];
set IN_NET($in) "hqm_tb_top.u_hqm.par_hqm_list_sel_pipe.hqm_list_sel_pipe_gated_wrap.i_hqm_list_sel_pipe.i_hqm_list_sel_pipe_core.i_hqm_AW_rx_sync_nalb_lsp_enq_lb.i_hqm_AW_rx_sync_core.in_ready"; set IN_VALUE($in) 0;set IN_RAND($in) {000 000 000 000 000 000 000 000 000 000 000 000 005 040 100 040 005 000 000 000 000 000 000 000 000 000 000 000 000};set IN_PTR($in) 0;set IN_TIMEFORCE_MIN($in) $MODIFY_TIMEFORCE_MIN;set IN_TIMEFORCE_MAX($in) $MODIFY_TIMEFORCE_MAX;set in [expr $in + 1];
set IN_NET($in) "hqm_tb_top.u_hqm.par_hqm_list_sel_pipe.hqm_list_sel_pipe_gated_wrap.i_hqm_list_sel_pipe.i_hqm_list_sel_pipe_core.i_hqm_AW_rx_sync_dp_lsp_enq_rorply.i_hqm_AW_rx_sync_core.in_ready"; set IN_VALUE($in) 0;set IN_RAND($in) {000 000 000 000 000 000 000 000 000 000 000 000 005 040 100 040 005 000 000 000 000 000 000 000 000 000 000 000 000};set IN_PTR($in) 0;set IN_TIMEFORCE_MIN($in) $MODIFY_TIMEFORCE_MIN;set IN_TIMEFORCE_MAX($in) $MODIFY_TIMEFORCE_MAX;set in [expr $in + 1];
set IN_NET($in) "hqm_tb_top.u_hqm.par_hqm_list_sel_pipe.hqm_list_sel_pipe_gated_wrap.i_hqm_list_sel_pipe.i_hqm_list_sel_pipe_core.i_hqm_AW_rx_sync_dp_lsp_enq_dir.i_hqm_AW_rx_sync_core.in_ready"; set IN_VALUE($in) 0;set IN_RAND($in) {000 000 000 000 000 000 000 000 000 000 000 000 005 040 100 040 005 000 000 000 000 000 000 000 000 000 000 000 000};set IN_PTR($in) 0;set IN_TIMEFORCE_MIN($in) $MODIFY_TIMEFORCE_MIN;set IN_TIMEFORCE_MAX($in) $MODIFY_TIMEFORCE_MAX;set in [expr $in + 1];
set IN_NET($in) "hqm_tb_top.u_hqm.par_hqm_list_sel_pipe.hqm_list_sel_pipe_gated_wrap.i_hqm_list_sel_pipe.i_hqm_list_sel_pipe_core.i_hqm_AW_rx_sync_chp_lsp_token.i_hqm_AW_rx_sync_core.in_ready"; set IN_VALUE($in) 0;set IN_RAND($in) {000 000 000 000 000 000 000 000 000 000 000 000 005 040 100 040 005 000 000 000 000 000 000 000 000 000 000 000 000};set IN_PTR($in) 0;set IN_TIMEFORCE_MIN($in) $MODIFY_TIMEFORCE_MIN;set IN_TIMEFORCE_MAX($in) $MODIFY_TIMEFORCE_MAX;set in [expr $in + 1];
set IN_NET($in) "hqm_tb_top.u_hqm.par_hqm_list_sel_pipe.hqm_list_sel_pipe_gated_wrap.i_hqm_list_sel_pipe.i_hqm_list_sel_pipe_core.i_hqm_AW_rx_sync_chp_lsp_cmp.i_hqm_AW_rx_sync_core.in_ready"; set IN_VALUE($in) 0;set IN_RAND($in) {000 000 000 000 000 000 000 000 000 000 000 000 005 040 100 040 005 000 000 000 000 000 000 000 000 000 000 000 000};set IN_PTR($in) 0;set IN_TIMEFORCE_MIN($in) $MODIFY_TIMEFORCE_MIN;set IN_TIMEFORCE_MAX($in) $MODIFY_TIMEFORCE_MAX;set in [expr $in + 1];
set IN_NET($in) "hqm_tb_top.u_hqm.par_hqm_qed_pipe.hqm_qed_pipe_gated_wrap.i_hqm_qed_pipe.i_hqm_qed_pipe_core.i_hqm_nalb_pipe_core.i_rx_sync_rop_nalb_enq.i_hqm_AW_rx_sync_core.in_ready"; set IN_VALUE($in) 0;set IN_RAND($in) {000 000 000 000 000 000 000 000 000 000 000 000 005 040 100 040 005 000 000 000 000 000 000 000 000 000 000 000 000};set IN_PTR($in) 0;set IN_TIMEFORCE_MIN($in) $MODIFY_TIMEFORCE_MIN;set IN_TIMEFORCE_MAX($in) $MODIFY_TIMEFORCE_MAX;set in [expr $in + 1];
set IN_NET($in) "hqm_tb_top.u_hqm.par_hqm_qed_pipe.hqm_qed_pipe_gated_wrap.i_hqm_qed_pipe.i_hqm_qed_pipe_core.i_hqm_nalb_pipe_core.i_rx_sync_lsp_nalb_sch_unoord.i_hqm_AW_rx_sync_core.in_ready"; set IN_VALUE($in) 0;set IN_RAND($in) {000 000 000 000 000 000 000 000 000 000 000 000 005 040 100 040 005 000 000 000 000 000 000 000 000 000 000 000 000};set IN_PTR($in) 0;set IN_TIMEFORCE_MIN($in) $MODIFY_TIMEFORCE_MIN;set IN_TIMEFORCE_MAX($in) $MODIFY_TIMEFORCE_MAX;set in [expr $in + 1];
set IN_NET($in) "hqm_tb_top.u_hqm.par_hqm_qed_pipe.hqm_qed_pipe_gated_wrap.i_hqm_qed_pipe.i_hqm_qed_pipe_core.i_hqm_nalb_pipe_core.i_rx_sync_lsp_nalb_sch_rorply.i_hqm_AW_rx_sync_core.in_ready"; set IN_VALUE($in) 0;set IN_RAND($in) {000 000 000 000 000 000 000 000 000 000 000 000 005 040 100 040 005 000 000 000 000 000 000 000 000 000 000 000 000};set IN_PTR($in) 0;set IN_TIMEFORCE_MIN($in) $MODIFY_TIMEFORCE_MIN;set IN_TIMEFORCE_MAX($in) $MODIFY_TIMEFORCE_MAX;set in [expr $in + 1];
set IN_NET($in) "hqm_tb_top.u_hqm.par_hqm_qed_pipe.hqm_qed_pipe_gated_wrap.i_hqm_qed_pipe.i_hqm_qed_pipe_core.i_hqm_nalb_pipe_core.i_rx_sync_lsp_nalb_sch_atq.i_hqm_AW_rx_sync_core.in_ready"; set IN_VALUE($in) 0;set IN_RAND($in) {000 000 000 000 000 000 000 000 000 000 000 000 005 040 100 040 005 000 000 000 000 000 000 000 000 000 000 000 000};set IN_PTR($in) 0;set IN_TIMEFORCE_MIN($in) $MODIFY_TIMEFORCE_MIN;set IN_TIMEFORCE_MAX($in) $MODIFY_TIMEFORCE_MAX;set in [expr $in + 1];
set IN_NET($in) "hqm_tb_top.u_hqm.par_hqm_qed_pipe.hqm_qed_pipe_gated_wrap.i_hqm_qed_pipe.i_hqm_qed_pipe_core.i_hqm_nalb_pipe_core.i_rx_sync_rop_nalb_enq.i_hqm_AW_rx_sync_core.in_ready"; set IN_VALUE($in) 0;set IN_RAND($in) {000 000 000 000 000 000 000 000 000 000 000 000 005 040 100 040 005 000 000 000 000 000 000 000 000 000 000 000 000};set IN_PTR($in) 0;set IN_TIMEFORCE_MIN($in) $MODIFY_TIMEFORCE_MIN;set IN_TIMEFORCE_MAX($in) $MODIFY_TIMEFORCE_MAX;set in [expr $in + 1];
set IN_NET($in) "hqm_tb_top.u_hqm.par_hqm_qed_pipe.hqm_qed_pipe_gated_wrap.i_hqm_qed_pipe.i_hqm_qed_pipe_core.i_hqm_nalb_pipe_core.i_rx_sync_lsp_nalb_sch_unoord.i_hqm_AW_rx_sync_core.in_ready"; set IN_VALUE($in) 0;set IN_RAND($in) {000 000 000 000 000 000 000 000 000 000 000 000 005 040 100 040 005 000 000 000 000 000 000 000 000 000 000 000 000};set IN_PTR($in) 0;set IN_TIMEFORCE_MIN($in) $MODIFY_TIMEFORCE_MIN;set IN_TIMEFORCE_MAX($in) $MODIFY_TIMEFORCE_MAX;set in [expr $in + 1];
set IN_NET($in) "hqm_tb_top.u_hqm.par_hqm_qed_pipe.hqm_qed_pipe_gated_wrap.i_hqm_qed_pipe.i_hqm_qed_pipe_core.i_hqm_nalb_pipe_core.i_rx_sync_lsp_nalb_sch_rorply.i_hqm_AW_rx_sync_core.in_ready"; set IN_VALUE($in) 0;set IN_RAND($in) {000 000 000 000 000 000 000 000 000 000 000 000 005 040 100 040 005 000 000 000 000 000 000 000 000 000 000 000 000};set IN_PTR($in) 0;set IN_TIMEFORCE_MIN($in) $MODIFY_TIMEFORCE_MIN;set IN_TIMEFORCE_MAX($in) $MODIFY_TIMEFORCE_MAX;set in [expr $in + 1];
set IN_NET($in) "hqm_tb_top.u_hqm.par_hqm_qed_pipe.hqm_qed_pipe_gated_wrap.i_hqm_qed_pipe.i_hqm_qed_pipe_core.i_hqm_nalb_pipe_core.i_rx_sync_lsp_nalb_sch_atq.i_hqm_AW_rx_sync_core.in_ready"; set IN_VALUE($in) 0;set IN_RAND($in) {000 000 000 000 000 000 000 000 000 000 000 000 005 040 100 040 005 000 000 000 000 000 000 000 000 000 000 000 000};set IN_PTR($in) 0;set IN_TIMEFORCE_MIN($in) $MODIFY_TIMEFORCE_MIN;set IN_TIMEFORCE_MAX($in) $MODIFY_TIMEFORCE_MAX;set in [expr $in + 1];
set IN_NET($in) "hqm_tb_top.u_hqm.par_hqm_system.hqm_system_gated_wrap.i_hqm_reorder_pipe.i_hqm_reorder_pipe_core.i_hqm_reorder_pipe_func.i_chp_rop_hcw_db.in_ready_nxt"; set IN_VALUE($in) 0;set IN_RAND($in) {000 000 000 000 000 000 000 000 000 000 000 000 005 040 100 040 005 000 000 000 000 000 000 000 000 000 000 000 000};set IN_PTR($in) 0;set IN_TIMEFORCE_MIN($in) $MODIFY_TIMEFORCE_MIN;set IN_TIMEFORCE_MAX($in) $MODIFY_TIMEFORCE_MAX;set in [expr $in + 1];
set IN_NET($in) "hqm_tb_top.u_hqm.par_hqm_list_sel_pipe.hqm_list_sel_pipe_gated_wrap.i_hqm_aqed_pipe.i_hqm_aqed_pipe_core.i_rx_sync_qed_aqed_enq.i_hqm_AW_rx_sync_core.in_ready"; set IN_VALUE($in) 0;set IN_RAND($in) {000 000 000 000 000 000 000 000 000 000 000 000 005 040 100 040 005 000 000 000 000 000 000 000 000 000 000 000 000};set IN_PTR($in) 0;set IN_TIMEFORCE_MIN($in) $MODIFY_TIMEFORCE_MIN;set IN_TIMEFORCE_MAX($in) $MODIFY_TIMEFORCE_MAX;set in [expr $in + 1];
set IN_NET($in) "hqm_tb_top.u_hqm.par_hqm_list_sel_pipe.hqm_list_sel_pipe_gated_wrap.i_hqm_aqed_pipe.i_hqm_aqed_pipe_core.i_db_ap_aqed_data.in_ready_nxt"; set IN_VALUE($in) 0;set IN_RAND($in) {000 000 000 000 000 000 000 000 000 000 000 000 005 040 100 040 005 000 000 000 000 000 000 000 000 000 000 000 000};set IN_PTR($in) 0;set IN_TIMEFORCE_MIN($in) $MODIFY_TIMEFORCE_MIN;set IN_TIMEFORCE_MAX($in) $MODIFY_TIMEFORCE_MAX;set in [expr $in + 1];
set IN_NET($in) "hqm_tb_top.u_hqm.par_hqm_list_sel_pipe.hqm_list_sel_pipe_gated_wrap.i_hqm_aqed_pipe.i_hqm_aqed_pipe_core.i_db_lsp_aqed_cmp.in_ready_nxt"; set IN_VALUE($in) 0;set IN_RAND($in) {000 000 000 000 000 000 000 000 000 000 000 000 005 040 100 040 005 000 000 000 000 000 000 000 000 000 000 000 000};set IN_PTR($in) 0;set IN_TIMEFORCE_MIN($in) $MODIFY_TIMEFORCE_MIN;set IN_TIMEFORCE_MAX($in) $MODIFY_TIMEFORCE_MAX;set in [expr $in + 1];
set IN_NET($in) "hqm_tb_top.u_hqm.par_hqm_list_sel_pipe.hqm_list_sel_pipe_gated_wrap.i_hqm_list_sel_pipe.i_hqm_list_sel_pipe_core.i_hqm_lsp_atm_pipe.i_db_aqed_ap_enq_data.in_ready_nxt"; set IN_VALUE($in) 0;set IN_RAND($in) {000 000 000 000 000 000 000 000 000 000 000 000 005 040 100 040 005 000 000 000 000 000 000 000 000 000 000 000 000};set IN_PTR($in) 0;set IN_TIMEFORCE_MIN($in) $MODIFY_TIMEFORCE_MIN;set IN_TIMEFORCE_MAX($in) $MODIFY_TIMEFORCE_MAX;set in [expr $in + 1];
set IN_NET($in) "hqm_tb_top.u_hqm.par_hqm_list_sel_pipe.hqm_list_sel_pipe_gated_wrap.i_hqm_list_sel_pipe.i_hqm_list_sel_pipe_core.i_hqm_lsp_atm_pipe.i_db_lsp_ap_atm_data.in_ready_nxt"; set IN_VALUE($in) 0;set IN_RAND($in) {000 000 000 000 000 000 000 000 000 000 000 000 005 040 100 040 005 000 000 000 000 000 000 000 000 000 000 000 000};set IN_PTR($in) 0;set IN_TIMEFORCE_MIN($in) $MODIFY_TIMEFORCE_MIN;set IN_TIMEFORCE_MAX($in) $MODIFY_TIMEFORCE_MAX;set in [expr $in + 1];
}

##FIFOAFULL
if {$AGITATE_fifoafull == 1} {
}

##FIFOEMPTY
if {$AGITATE_fifoempty == 1} {
}

##ARB
if {$AGITATE_arbv == 1} {
}

##pipeline hold
if {$AGITATE_pipehold == 1} {
}

##db ready
if {$AGITATE_dbready == 1} {
}

##credits
if {$AGITATE_credits == 1} {
}

##RANDOM
if {$AGITATE_random == 1} {
}

##CHP
if {$AGITATE_chp == 1} {
}

##LSP
if {$AGITATE_lsp_chicken == 1} {
}

##ROP
if {$AGITATE_rop == 1} {
}

##SYSTEM
if {$AGITATE_sch == 1} {
}

if {$AGITATE_enq == 1} {
}

if {$AGITATE_cmp == 1} {
}

if {$AGITATE_tok == 1} {
}

if {$AGITATE_sys == 1} {
set IN_NET($in) "hqm_tb_top.u_hqm.par_hqm_system.hqm_system_gated_wrap.i_hqm_system.i_hqm_system_core.i_hqm_system_alarm.i_hqm_alarm_rx_sync.i_hqm_AW_rx_sync_core.g_wreg1.fifo_pop_data_v"; set IN_VALUE($in) 0;set IN_RAND($in) {000 000 000 000 000 000 000 000 000 000 000 000 005 040 100 040 005 000 000 000 000 000 000 000 000 000 000 000 000};set IN_PTR($in) 0;set IN_TIMEFORCE_MIN($in) $MODIFY_TIMEFORCE_MIN;set IN_TIMEFORCE_MAX($in) $MODIFY_TIMEFORCE_MAX;set in [expr $in + 1];
set IN_NET($in) "hqm_tb_top.u_hqm.par_hqm_system.hqm_system_gated_wrap.i_hqm_system.i_hqm_system_core.i_hqm_system_alarm.i_sif_alarm_fifo.pop_data_v"; set IN_VALUE($in) 0;set IN_RAND($in) {000 000 000 000 000 000 000 000 000 000 000 000 005 040 100 040 005 000 000 000 000 000 000 000 000 000 000 000 000};set IN_PTR($in) 0;set IN_TIMEFORCE_MIN($in) $MODIFY_TIMEFORCE_MIN;set IN_TIMEFORCE_MAX($in) $MODIFY_TIMEFORCE_MAX;set in [expr $in + 1];
set IN_NET($in) "hqm_tb_top.u_hqm.par_hqm_system.hqm_system_gated_wrap.i_hqm_system.i_hqm_system_core.i_hqm_system_ingress.i_hcw_enq_fifo.pop_data_v"; set IN_VALUE($in) 0;set IN_RAND($in) {000 000 000 000 000 000 000 000 000 000 000 000 005 040 100 040 005 000 000 000 000 000 000 000 000 000 000 000 000};set IN_PTR($in) 0;set IN_TIMEFORCE_MIN($in) $MODIFY_TIMEFORCE_MIN;set IN_TIMEFORCE_MAX($in) $MODIFY_TIMEFORCE_MAX;set in [expr $in + 1];
set IN_NET($in) "hqm_tb_top.u_hqm.par_hqm_system.hqm_system_gated_wrap.i_hqm_system.i_hqm_system_core.i_hqm_system_write_buffer.i_sch_out_fifo.pop_data_v"; set IN_VALUE($in) 0;set IN_RAND($in) {000 000 000 000 000 000 000 000 000 000 000 000 005 040 100 040 005 000 000 000 000 000 000 000 000 000 000 000 000};set IN_PTR($in) 0;set IN_TIMEFORCE_MIN($in) $MODIFY_TIMEFORCE_MIN;set IN_TIMEFORCE_MAX($in) $MODIFY_TIMEFORCE_MAX;set in [expr $in + 1];
set IN_NET($in) "hqm_tb_top.u_hqm.par_hqm_system.hqm_system_gated_wrap.i_hqm_system.i_hqm_system_core.i_hqm_system_egress.i_hcw_sched_db.in_ready_nxt"; set IN_VALUE($in) 0;set IN_RAND($in) {000 000 000 000 000 000 000 000 000 000 000 000 005 040 100 040 005 000 000 000 000 000 000 000 000 000 000 000 000};set IN_PTR($in) 0;set IN_TIMEFORCE_MIN($in) $MODIFY_TIMEFORCE_MIN;set IN_TIMEFORCE_MAX($in) $MODIFY_TIMEFORCE_MAX;set in [expr $in + 1];
}










################################################
##optionally randomize entries of the RANDOM ARRAY
##  to provide additional regression randomization

#### RANDOM delete entries
if {$IN_MODIFY_VALID_KEEP_MAX > $in} {
  set IN_MODIFY_VALID_KEEP_MAX $in;
}
if {$IN_MODIFY_VALID_KEEP_MAX < $IN_MODIFY_VALID_KEEP_MIN} {
  set IN_MODIFY_VALID_KEEP_MIN $IN_MODIFY_VALID_KEEP_MAX;
}
set tmp [expr rand()] ; set IN_MODIFY_VALID [expr ($in - ( $IN_MODIFY_VALID_KEEP_MIN + (int ( (($IN_MODIFY_VALID_KEEP_MAX - $IN_MODIFY_VALID_KEEP_MIN) + 1) * $tmp ))))]

for {set X 0} {$X<$IN_MODIFY_VALID} {incr X} {
  if {$in > 1} {
  set tmp [expr rand()] ; set rand1 [expr (0 + (int ($in * $tmp)))]
  puts " IN_MODIFY_VALID $X $rand1 $in"
  set rand2 0;
  for {set Y 0} {$Y<$in} {incr Y} {
    if  {$Y == $rand1} {
      set rand2 1;
    } else {
      set rand3 [expr $Y - $rand2]
      set IN_NET($rand3) $IN_NET($Y)
      set IN_VALUE($rand3) $IN_VALUE($Y)
      set IN_RAND($rand3) $IN_RAND($Y)
      set IN_PTR($rand3) $IN_PTR($Y)
      set IN_TIMEFORCE_MIN($rand3) $IN_TIMEFORCE_MIN($Y)
      set IN_TIMEFORCE_MAX($rand3) $IN_TIMEFORCE_MAX($Y)
    }
  }
  set in [expr $in - 1]
  }
}
#### RANDOM modify the probabilities
for {set X 0} {$X<$IN_MODIFY_RAND} {incr X} {
  if {$in > 1} {
  set tmp [expr rand()] ; set rand1 [expr (0 + (int ($in * $tmp)))]
  set tmp [expr rand()] ; set rand2 [expr (0 + (int ([llength $IN_RAND($rand1)] * $tmp)))]
  set tmp [expr rand()] ; set rand3 [expr (1 + (int (100 * $tmp)))]
  puts " IN_MODIFY_RAND $X $rand1 $rand2 $rand3"
  set IN_RAND($rand1) [lreplace $IN_RAND($rand1) $rand2 $rand2 $rand3]
  }
}
#### RANDOM change starting random probability
set IN_MODIFY_PTR [expr (0 + (int ($in * $IN_MODIFY_PTR_MULT)))];
for {set X 0} {$X<$IN_MODIFY_PTR} {incr X} {
  if {$in > 1} {
  set tmp [expr rand()] ; set rand1 [expr (0 + (int ($in * $tmp)))]
  set tmp [expr rand()] ; set rand2 [expr (0 + (int ([llength $IN_RAND($rand1)] * $tmp)))]
  puts " IN_MODIFY_PTR $X $rand1 $rand2"
  set IN_PTR($rand1) $rand2
  }
}
################################################
### PRINT agitate script in log
puts "EXTRACT set IN_SEED \"$IN_SEED\" "
puts "EXTRACT dump -file dump.$IN_SEED.vpd -type vpd "
puts "EXTRACT set tmp \[expr srand(\$IN_SEED)\] "
puts "EXTRACT set IN_TIMEINCREMENT \"$IN_TIMEINCREMENT\" "
puts "EXTRACT set IN_TIMESTART  \"$IN_TIMESTART\" "
puts "EXTRACT set IN_TIMEEND   \"$IN_TIMEEND\" "
set X_IN_TRIGGER_COUNTER $IN_TRIGGER_COUNTER
set X_IN_TRIGGER_COUNTER [regsub {\[} $X_IN_TRIGGER_COUNTER {\\[}];
set X_IN_TRIGGER_COUNTER [regsub {\]} $X_IN_TRIGGER_COUNTER {\\]}];
puts "EXTRACT set IN_TRIGGER_COUNTER \"$X_IN_TRIGGER_COUNTER\" "
puts "EXTRACT set IN_TRIGGER_DONE \"$IN_TRIGGER_DONE\" "
puts "EXTRACT set IN_MODIFY_VALID_KEEP_MIN \"$IN_MODIFY_VALID_KEEP_MIN\" "
puts "EXTRACT set IN_MODIFY_VALID_KEEP_MAX \"$IN_MODIFY_VALID_KEEP_MAX\" "
puts "EXTRACT set IN_MODIFY_VALID \"$IN_MODIFY_VALID\" "
puts "EXTRACT set IN_MODIFY_RAND \"$IN_MODIFY_RAND\" "
puts "EXTRACT set IN_MODIFY_PTR_MULT  \"$IN_MODIFY_PTR_MULT\" "
puts "EXTRACT set IN_MODIFY_PTR  \"$IN_MODIFY_PTR\" "
puts "EXTRACT set MODIFY_TIMEFORCE_MIN \"$MODIFY_TIMEFORCE_MIN\" "
puts "EXTRACT set MODIFY_TIMEFORCE_MAX \"$MODIFY_TIMEFORCE_MAX\" "
puts "EXTRACT set AGITATE_interfaceready \"$AGITATE_interfaceready\" "
puts "EXTRACT set AGITATE_fifoafull \"$AGITATE_fifoafull\" "
puts "EXTRACT set AGITATE_fifoempty \"$AGITATE_fifoempty\" "
puts "EXTRACT set AGITATE_arbv \"$AGITATE_arbv\" "
puts "EXTRACT set AGITATE_pipehold \"$AGITATE_pipehold\" "
puts "EXTRACT set AGITATE_dbready \"$AGITATE_dbready\" "
puts "EXTRACT set AGITATE_credits \"$AGITATE_credits\" "
puts "EXTRACT set AGITATE_random \"$AGITATE_random\" "
puts "EXTRACT set AGITATE_chp \"$AGITATE_chp\" "
puts "EXTRACT set AGITATE_lsp_chicken \"$AGITATE_lsp_chicken\" "
puts "EXTRACT set AGITATE_rop \"$AGITATE_rop\" "
puts "EXTRACT set AGITATE_sch \"$AGITATE_sch\" "
puts "EXTRACT set AGITATE_enq \"$AGITATE_enq\" "
puts "EXTRACT set AGITATE_cmp \"$AGITATE_cmp\" "
puts "EXTRACT set AGITATE_tok \"$AGITATE_tok\" "
puts "EXTRACT set AGITATE_sys \"$AGITATE_sys\" "
puts "EXTRACT ############################ STRESS SCRIPT ############################";
puts "EXTRACT set in 0;"
puts "EXTRACT #"
for {set X 0} {$X<$in} {incr X} {
set X_IN_NET $IN_NET($X)
set X_IN_NET [regsub {\[} $X_IN_NET {\\[}];
set X_IN_NET [regsub {\]} $X_IN_NET {\\]}];
puts "EXTRACT set IN_NET(\$in) \"$X_IN_NET\"\; set IN_VALUE(\$in) \"$IN_VALUE($X)\"\; set IN_RAND(\$in) \"$IN_RAND($X)\"\; set IN_PTR(\$in) \"$IN_PTR($X)\"\; set in \[expr \$in + 1\]\; set IN_TIMEFORCE_MIN(\$in) \"$IN_TIMEFORCE_MIN($X)\";set IN_TIMEFORCE_MAX(\$in) \"$IN_TIMEFORCE_MAX($X)\";  ";
}
puts "EXTRACT ######################### replace with EXTRACT from log up to here in agitate.tcl #########################"



























################################################
## RUN THE STRESS 
set TIME 0;
puts ">>>>>INITIAL UCLI STRESS AGITATE  $TIME"
run 2ps
run $IN_TIMESTART
set TIME [expr 0 + [regsub ns $IN_TIMESTART ""]];

# wait for trigger events
puts ">>>>>TRIGGER  UCLI STRESS AGITATE  $TIME"
set TRIGGER 1
while {$TRIGGER==1} {
   set tmp [get $IN_TRIGGER_COUNTER -radix decimal];
   set TRIGGER [string match $tmp 0];
   run $IN_TIMEINCREMENT
   set TIME [expr $TIME + [regsub ns $IN_TIMEINCREMENT ""]];
}
set tmp [expr [regsub ns $IN_TIMEEND ""] + $TIME ]
set IN_TIMEEND "${tmp}ns"

# Start stress agitate signals
set CNT 0
set GO [expr $IN_TRIGGER_DONE]
set DONE 0
puts ">>>>>STARTING UCLI STRESS AGITATE  $TIME  $GO of $IN_TRIGGER_DONE "
while {$GO>=1} {
  if {$CNT==0} {puts ">>>>>RUNNING  UCLI STRESS AGITATE  $TIME  $GO of $IN_TRIGGER_DONE "; set CNT 500; } else { set CNT [expr $CNT -1]  ; }

  set tmp [get $IN_TRIGGER_COUNTER -radix decimal];
  if {[string match $tmp 0]} {set GO [expr $GO - 1] } else {set GO [expr $IN_TRIGGER_DONE];}

  for {set X 0} {$X<$in} {incr X} {
    set tmp [expr rand()]
    set IN_TIMEFORCE_RANGE [expr [regsub ns $IN_TIMEFORCE_MAX($X) ""] -[regsub ns $IN_TIMEFORCE_MIN($X) ""] ]
    set rand [expr (0 + (int ($IN_TIMEFORCE_RANGE * $tmp)))]
    set IN_TIMEFORCE_CANCEL [expr [regsub ns $IN_TIMEFORCE_MIN($X) ""] + $rand]
    set IN_TIMEFORCE_CANCEL "${IN_TIMEFORCE_CANCEL}ns"

    set tmp [expr rand()]
    set rand [expr (1 + (int (100 * $tmp)))]
    set IN_PTR($X) [expr $IN_PTR($X) + 1]
    if {$IN_PTR($X) >= [llength $IN_RAND($X)]} {set IN_PTR($X) 0}
    set tmp [lindex $IN_RAND($X) $IN_PTR($X)]
    set tmp [regsub  -all {^[0]*} $tmp ""]
    if {[string match $tmp ""]} {set tmp 0}
    if {[expr $rand <= $tmp]} {
      for {set Y 0} {$Y<[llength $IN_NET($X)]} {incr Y} {
        set X_IN_NET [lindex $IN_NET($X) $Y]
        set X_IN_VALUE [lindex $IN_VALUE($X) $Y]
        if {[catch {force $X_IN_NET $X_IN_VALUE -cancel $IN_TIMEFORCE_CANCEL}]} {puts "CATCH force 2 $X $X_IN_NET $X_IN_VALUE"}
      }
    }
  }
  set TIME [expr $TIME + [regsub ns $IN_TIMEINCREMENT ""]];
  if {$TIME >[regsub ns $IN_TIMEEND ""]} {set GO 0}
  run $IN_TIMEINCREMENT
}
for {set X 0} {$X<$in} {incr X} {
      for {set Y 0} {$Y<[llength $IN_NET($X)]} {incr Y} {
        set X_IN_NET [lindex $IN_NET($X) $Y]
        set X_IN_VALUE [lindex $IN_VALUE($X) $Y]
        if {[catch {release $X_IN_NET}]} {puts "CATCH release $X $X_IN_NET"}
      }
}
puts ">>>>>STOPPING UCLI STRESS AGITATE  $TIME  $GO of $IN_TRIGGER_DONE "
run



