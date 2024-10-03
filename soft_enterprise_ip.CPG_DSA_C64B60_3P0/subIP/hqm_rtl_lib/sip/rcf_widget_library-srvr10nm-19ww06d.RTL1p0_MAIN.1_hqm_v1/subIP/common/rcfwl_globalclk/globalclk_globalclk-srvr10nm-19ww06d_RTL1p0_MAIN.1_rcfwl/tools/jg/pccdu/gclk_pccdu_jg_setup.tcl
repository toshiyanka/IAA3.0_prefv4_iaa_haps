## Start from scratch whenever reloading file 
clear -all 

## Include Intel libs & set up standard env 
include "$env(IJL_ROOT)/intel_jg_lib.tcl" 
###setenv IJL_SVA_LIB_PATH /nfs/site/eda/tools/dt/sva_lib/8.1/linux_2.6.16_x86-64/SVA_LIB

ijl_set_standard_intel_env 


## Set top level module for verification 
set top gclk_pccdu
set MODEL_ROOT /nfs/sc/disks/sdg74_0279/kcorrell/globalclk
set TOP_FILE /nfs/sc/disks/sdg74_0279/kcorrell/globalclk/src/rtl/clkdist/gclk_pccdu.sv

## There are additional analyze commands in this TCL file commented out by default.
## You may find your module includes files from an additional library and that you need
## to uncomment one of the target libraries in this file.  At first, try leaving everything
## commented out for performance reasons.
include gclk_pccdu_aux_analyze.tcl

########################################################
## Below is the main analyze command for your module by
## itself with no additional includes.
##
## This module is part of target root ''
########################################################

set RTL_TARGET $MODEL_ROOT/target/globalclk/vcs_4value/gclk_pccdu_rtl_lib
ijl_analyze  +define+CORE0123 +define+CTECH_LIB_META_ON +define+EMULATION +define+FPV +define+FPV_RESTRICT +define+IMPH_VTDTRK_REDUCED_FPV_ON +define+INSTANTIATE_HIERDUMP +define+NO_FPV_VTDTRK_COVER +define+NO_FPV_VTDTRK_REF_COVER +define+NO_VTDTRK_ADDRESS_DEF_ASSERT +define+PKG0 +define+SVA_LIB_SVA2009 +define+ULT +define+VAL4 +define+VCS -extended_string_directive_end  +incdir+/nfs/site/eda/tools/dt/sva_lib/8.1/linux_2.6.16_x86-64/SVA_LIB  +incdir+src +libext+.vs+.v+.vr+.sv+.vh $TOP_FILE  -f $RTL_TARGET/vlog_rtlincdirs.f -f $RTL_TARGET/vlog_rtllibdirs.f $MODEL_ROOT/tools/jg/pccdu/gclk_pccdu_fv.sv /nfs/site/eda/tools/dt/sva_lib/8.1/linux_2.6.16_x86-64/SVA_LIB/intel_checkers.vs -extended_string_directive_end


##check_xprop -init_control true -sequential

set elab_cmd " elaborate -top $top -latchHandling -extended_string_directive_end -x_handling -enable_unnamed_generate_naming " 
eval $elab_cmd 

set_max_trace_length 0


## You will need these lines or something simliar to define your clock and reset signals before doing any sort of proof
## These can be done interactive in JG if you prefer

clock fdop_preclk_grid
reset fvmod.rst
## reset -expression ~your_rst_signal_name_b
## reset -expression your_rst_signal_name  (alternative just for clarity)
