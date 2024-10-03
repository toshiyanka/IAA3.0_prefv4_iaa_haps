###########################################################################
# IP info settings
###########################################################################

set ::collage_ip_info::ip_name "ip_disable"
set ::collage_ip_info::ip_top_module_name "hqm_rcfwl_ip_disable"
set ::collage_ip_info::ip_version "1.0"
set ::collage_ip_info::ip_intent_sp ""
set ::collage_ip_info::ip_rtl_inc_dirs "$::env(MODEL_ROOT)/src/rtl/widgets"
set ::collage_ip_info::ip_input_language SystemVerilog
set ::collage_ip_info::ip_input_files $::env(MODEL_ROOT)/src/rtl/widgets/hqm_rcfwl_ip_disable.sv

set ::collage_ip_info::ip_plugin_dir "" ; # Directories - space separated list - with tcl plugin files
set ::collage_ip_info::ip_ifc_def_hook "ip_disable_create_ifc_instances" ; # Set this to procedure to add IP interfaces - defined below

proc ip_disable_create_ifc_instances {} {

  return
}

######################################################################
# Lines below are generic and should not include design specific info
######################################################################

collage_simple_build_flow -exit -copy_corekit
