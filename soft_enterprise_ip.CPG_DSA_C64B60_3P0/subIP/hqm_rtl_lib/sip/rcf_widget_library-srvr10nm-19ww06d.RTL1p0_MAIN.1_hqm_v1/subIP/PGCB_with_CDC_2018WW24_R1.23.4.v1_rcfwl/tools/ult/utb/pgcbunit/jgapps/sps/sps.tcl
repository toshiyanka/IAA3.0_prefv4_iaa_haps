# This is the tcl script for Jasper run.  To invoke, cd sps;make
# You can run any valid Jasper tcl cmd in this script.
# By default, all properties are run matching a regexp pattern in the property names using the code below.
# Please feel free to change the following lines below and write what you want.


idrive_clk
idrive_rst

check_sps -init
check_sps -extract
check_sps -export -silent -type assert -type assume -type cover -class unclassified
set_prove_time_limit 300s

iprove_tasks "<SPS"
ireport_tasks_result "<SPS"
