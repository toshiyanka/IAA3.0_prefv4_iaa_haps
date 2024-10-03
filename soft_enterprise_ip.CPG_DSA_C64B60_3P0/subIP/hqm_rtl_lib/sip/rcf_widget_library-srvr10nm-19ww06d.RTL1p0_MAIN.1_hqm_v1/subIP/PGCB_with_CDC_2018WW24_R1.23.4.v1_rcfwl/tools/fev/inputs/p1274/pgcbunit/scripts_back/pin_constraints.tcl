#Scan Related Pin Constraints
vpx add pin const 0 test_se -all -rev
vpx add pin const 1 test_sei -all -rev
vpx add pin const 1 test_sea -all -rev
vpx add pin const 0 test_si* -all -rev
vpx add pin const 1 test_seia -all -rev
vpx add ignore output test_so* -all -rev

vpx add pin const 0 *fscan_shiften         -all -both
vpx add pin const 0 *fscan_mode            -all -both
vpx add pin const 0 *fscan_clkungate       -all -both
vpx add pin const 0 *fscan_clkungate_syn   -all -both
vpx add pin const 0 *fscan_latchopen       -all -both
vpx add pin const 0 *fscan_rstbypen*       -all -both
#This is assumed to be bubbled enable pin , if there is a inverter , this has to be tied to zero & not one , else you might see non-eq
vpx add pin const 1 *fscan_latchclosed_b   -all -both
vpx add pin const 1 *fscan_byprst_b*       -all -both
vpx add pin const 1 *fscan_byplatrst_b*    -all -both
#vpx add pin const 0 *fdfx_pgcb_bypass     -all -both

#RAM Pin constraints
#This is assumed to be bubbled enable pin , if there is a inverter , this has to be tied to zero & not one , else you might see non-eq
#vpx add pin constraints 1 *fscan_ram_odis_b                -both
#vpx add pin constraints 1 *fscan_ram_rddis_b               -both
#vpx add pin constraints 1 *fscan_ram_wrdis_b               -both
#vpx add pin constraints 0 *fscan_ram_awt_mode              -both
#vpx add pin constraints 0 *fscan_ram_awt_ren               -both
#vpx add pin constraints 0 *fscan_ram_awt_wen               -both
#vpx add pin constraints 0 *fscan_ram_bypsel                -both
#vpx add tied signals 0  {*non_iosf_cdc_gclock_req_async*} -net -module *drng_pgcbcg_inst* -golden
#vpx add tied signals 0  {*non_iosf_cdc_gclock_ack_async*} -net -module *drng_pgcbcg_inst* -golden
