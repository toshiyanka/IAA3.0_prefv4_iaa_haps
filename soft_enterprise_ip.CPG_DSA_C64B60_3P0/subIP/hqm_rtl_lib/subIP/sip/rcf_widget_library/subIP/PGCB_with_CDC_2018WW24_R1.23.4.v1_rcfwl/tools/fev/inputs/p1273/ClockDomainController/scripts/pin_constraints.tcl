#These are test pins to be disabled
vpx add pin constraints 0 test_si*  -module *  -rev
vpx add pin constraints 1 test_sei*  -module *  -rev
vpx add ignored outputs test_so*  -module *  -rev

#Scan Related Pin Constraints 
vpx add pin constraints 0 *fscan_shiften              -both
vpx add pin constraints 0 *fscan_mode                 -both
vpx add pin constraints 0 *fscan_clkungate            -both
vpx add pin constraints 0 *fscan_clkungate_syn        -both
vpx add pin constraints 0 *fscan_latchopen            -both
vpx add pin constraints 0 *fscan_rstbypen*            -both
#This is assumed to be bubbled enable pin , if there is a inverter , this has to be tied to zero & not one , else you might see non-eq
vpx add pin constraints 1 *fscan_latchclosed_b        -both
vpx add pin constraints 1 *fscan_byprst_b*            -both
 
#This is assumed to be bubbled enable pin , if there is a inverter , this has to be tied to zero & not one , else you might see non-eq
vpx add pin constraints 0 *fscan_ram_bypsel                -both
