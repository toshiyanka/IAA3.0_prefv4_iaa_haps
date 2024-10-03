# This is the tcl script for Jasper run.  To invoke, cd fsm;make
# You can run any valid Jasper tcl cmd in this script.
# By default, all properties are run matching a regexp pattern in the property names using the code below.
# Please feel free to change the following lines below and write what you want.


idrive_clk
idrive_rst

set_prove_time_limit 600s

foreach fsm [ishow_fsm_names] { ishow_state $fsm }
#foreach fsm [ishow_fsm_names] { ishow_arc $fsm }
ireport_tasks_result
