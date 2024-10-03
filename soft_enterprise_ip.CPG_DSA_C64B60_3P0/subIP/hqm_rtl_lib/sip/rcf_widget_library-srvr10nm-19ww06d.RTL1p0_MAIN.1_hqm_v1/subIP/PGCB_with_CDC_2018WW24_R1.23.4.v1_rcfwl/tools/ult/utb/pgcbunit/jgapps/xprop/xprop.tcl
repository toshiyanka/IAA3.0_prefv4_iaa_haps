# This is the tcl script for Jasper run.  To invoke, cd xprop;make
# You can run any valid Jasper tcl cmd in this script.
# By default, all properties are run matching a regexp pattern in the property names using the code below.
# Please feel free to change the following lines below and write what you want.


idrive_clk
idrive_rst

catch {task -remove XPROP};
task -create XPROP -set;
set_xprop_use_bbox_outputs off -task XPROP;
set_xprop_use_internal_undriven on -task XPROP
set_xprop_use_inputs off -task XPROP
set_xprop_use_stopats off -task XPROP
set_xprop_use_reset_state on -task XPROP
set_xprop_use_x_assignments on -task XPROP
set_xprop_use_low_power off -task XPROP
check_xprop -create -bbox_inputs -task XPROP
check_xprop -create -clocks_and_resets -task XPROP
check_xprop -create -control -task XPROP
check_xprop -create -data -task XPROP
check_xprop -create -outputs -task XPROP
check_xprop -create -flops_with_reset_pin -task XPROP
check_xprop -create -flops_with_reset_value -task XPROP
check_xprop -prove -task XPROP  -no_decompose -time_limit 600
ireport_tasks_result
