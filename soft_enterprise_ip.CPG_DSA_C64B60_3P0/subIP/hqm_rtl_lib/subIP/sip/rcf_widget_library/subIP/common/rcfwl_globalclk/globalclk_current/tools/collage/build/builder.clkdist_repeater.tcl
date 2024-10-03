###########################################################################
# IP info settings
###########################################################################

set ::collage_ip_info::ip_name "clkdist_repeater"
set ::collage_ip_info::ip_top_module_name "rcfwl_gclk_clkdist_repeater"
set ::collage_ip_info::ip_version "1.0"
set ::collage_ip_info::ip_intent_sp ""
set ::collage_ip_info::ip_rtl_inc_dirs "$::env(MODEL_ROOT)/src/rtl/clkdist"

set ::collage_ip_info::ip_input_language SystemVerilog
set ::collage_ip_info::ip_input_files $::env(MODEL_ROOT)/src/rtl/clkdist/rcfwl_gclk_clkdist_repeater.sv

set ::collage_ip_info::ip_plugin_dir "" ; # Directories - space separated list - with tcl plugin files
set ::collage_ip_info::ip_ifc_def_hook "clkdist_repeater_create_ifc_instances" ; # Set this to procedure to add IP interfaces - defined below

######################################################################
# Procedure to create IP interfaces
######################################################################
proc clkdist_repeater_create_ifc_instances {} {

  return
}

######################################################################
# Lines below are generic and should not include design specific info
######################################################################
# collage_add_ifc_def_files -files "iosf_interface.1.0.1.tcl"

collage_simple_build_flow -exit -copy_corekit
