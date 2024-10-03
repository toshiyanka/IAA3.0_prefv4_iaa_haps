###########################################################################
# IP info settings
###########################################################################
##

set ::collage_ip_info::ip_name "ccdu_clkdist"
set ::collage_ip_info::ip_top_module_name "ccdu_clkdist"
set ::collage_ip_info::ip_version "1.0"
set ::collage_ip_info::ip_intent_sp ""
set ::collage_ip_info::ip_rtl_inc_dirs "$::env(MODEL_ROOT)/src/rtl/clkdist"

set ::collage_ip_info::ip_input_language SystemVerilog
set ::collage_ip_info::ip_input_files $::env(MODEL_ROOT)/src/rtl/clkdist/ccdu_clkdist.sv

set ::collage_ip_info::ip_plugin_dir "" ; # Directories - space separated list - with tcl plugin files
set ::collage_ip_info::ip_ifc_def_hook "ccdu_clkdist_create_ifc_instances" ; # Set this to procedure to add IP interfaces - defined below

######################################################################
# Procedure to create IP interfaces
######################################################################
proc ccdu_clkdist_create_ifc_instances {} {

  set ifc_inst_name "ccdu_dop_in_intf"
  create_interface_instance $ifc_inst_name -type consumer \
      -interface 10NMCLK::DOP::IN -version 0.3 \
      -associationformat "*%s"

  ##set_interface_parameter_attribute -instance $ifc_inst_name   <interface_param>  InterfaceLink       <rtl_param> 

  ##set_interface_parameter_attribute -instance $ifc_inst_name <interfface_parm>      ParamValueFromDesign 1

  set_interface_port_attribute -instance $ifc_inst_name DOP_PRECLK_GRID InterfaceLink     fdop_preclk_grid
  set_interface_port_attribute -instance $ifc_inst_name X1CLK_IN InterfaceLink            x1clk_in
  set_interface_port_attribute -instance $ifc_inst_name X3CLK_IN InterfaceLink            x3clk_in
  set_interface_port_attribute -instance $ifc_inst_name X4CLK_IN InterfaceLink            x4clk_in
  
  
  set open_params { }
  set open_ports {}
  collage_set_open_interface -ifc_inst_name $ifc_inst_name -parameters $open_params -ports $open_ports

  set port_map {
  }

  collage_set_interface_link -ifc_inst_name $ifc_inst_name -ports $port_map

  set ifc_inst_name "ccdu_dop_out_intf"
  create_interface_instance $ifc_inst_name -type provider \
      -interface 10NMCLK::DOP::OUT -version 0.3 \
      -associationformat "*%s"

  ##set_interface_parameter_attribute -instance $ifc_inst_name   <interface_param>  InterfaceLink       <rtl_param> 

  ##set_interface_parameter_attribute -instance $ifc_inst_name <interfface_parm>      ParamValueFromDesign 1
  set_interface_parameter_attribute -instance $ifc_inst_name      NUM_OF_GRID_SCC_CLKS  InterfaceLink        NUM_OF_GRID_SCC_CLKS
  set_interface_parameter_attribute -instance $ifc_inst_name      NUM_OF_GRID_SCC_CLKS  ParamValueFromDesign 1

  set_interface_port_attribute -instance $ifc_inst_name DOP_POSTCLK InterfaceLink      adop_postclk
  set_interface_port_attribute -instance $ifc_inst_name DOP_POSTCLK_FREE InterfaceLink adop_postclk_free
  set_interface_port_attribute -instance $ifc_inst_name DOP_PRECLK_GRID_SYNC InterfaceLink adop_preclk_grid_sync

  set_interface_port_attribute -instance $ifc_inst_name SCAN_CLK InterfaceLink         fscan_clk
  set_interface_port_attribute -instance $ifc_inst_name SCAN_DOP_CLKEN InterfaceLink   fscan_dop_clken
  set_interface_port_attribute -instance $ifc_inst_name DOP_PRECLK_DIV_SYNC  InterfaceLink      fdop_preclk_div_sync

  set_interface_port_attribute -instance $ifc_inst_name X1CLK_OUT InterfaceLink        x1clk_out
  set_interface_port_attribute -instance $ifc_inst_name X3CLK_OUT InterfaceLink        x3clk_out
  set_interface_port_attribute -instance $ifc_inst_name X4CLK_OUT InterfaceLink        x4clk_out
  

  set open_params { }
  set open_ports {}
  collage_set_open_interface -ifc_inst_name $ifc_inst_name -parameters $open_params -ports $open_ports

  set port_map {
  }

  collage_set_interface_link -ifc_inst_name $ifc_inst_name -ports $port_map

  return
}

######################################################################
# Lines below are generic and should not include design specific info
######################################################################
# collage_add_ifc_def_files -files "iosf_interface.1.0.1.tcl"
collage_add_ifc_def_files -files $::env(SDG_INTERFACE_DEFS)/10nm_clock_interface.0.3.tcl

collage_simple_build_flow -exit -copy_corekit
