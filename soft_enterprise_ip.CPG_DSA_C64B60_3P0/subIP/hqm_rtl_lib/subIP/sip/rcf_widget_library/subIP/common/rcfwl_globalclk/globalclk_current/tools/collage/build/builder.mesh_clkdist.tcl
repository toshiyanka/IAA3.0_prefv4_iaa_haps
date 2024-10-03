###########################################################################
# IP info settings
###########################################################################

set ::collage_ip_info::ip_name "mesh_clkdist"
set ::collage_ip_info::ip_top_module_name "rcfwl_gclk_mesh_clkdist"
set ::collage_ip_info::ip_version "1.0"
set ::collage_ip_info::ip_intent_sp ""
set ::collage_ip_info::ip_rtl_inc_dirs "$::env(MODEL_ROOT)/src/rtl/clkdist"

set ::collage_ip_info::ip_input_language SystemVerilog
set ::collage_ip_info::ip_input_files $::env(MODEL_ROOT)/src/rtl/clkdist/rcfwl_gclk_mesh_clkdist.v

set ::collage_ip_info::ip_plugin_dir "" ; # Directories - space separated list - with tcl plugin files
set ::collage_ip_info::ip_ifc_def_hook "mesh_clkdist_create_ifc_instances" ; # Set this to procedure to add IP interfaces - defined below

######################################################################
# Procedure to create IP interfaces
######################################################################
proc mesh_clkdist_create_ifc_instances {} {

  collage_create_ip_clock -port "clkspine_in" -clk_type FUNC_CLK -clk_max_freq 100 -clk_min_freq 100 -reference_clock_name clkspine_in
  collage_create_ip_clock -port "ckpredop" -clk_type FUNC_CLK -clk_max_freq 100 -clk_min_freq 100 -master_clock_source_pin clkspine_in -master_clock_reference_name clkspine_in -reference_clock_name ckpredop

  return
}

######################################################################
# Lines below are generic and should not include design specific info
######################################################################
# collage_add_ifc_def_files -files "iosf_interface.1.0.1.tcl"

collage_simple_build_flow -exit -copy_corekit
