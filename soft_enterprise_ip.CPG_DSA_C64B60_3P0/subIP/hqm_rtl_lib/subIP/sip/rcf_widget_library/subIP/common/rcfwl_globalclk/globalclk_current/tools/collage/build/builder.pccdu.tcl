###########################################################################
# IP info settings
###########################################################################
##

set ::collage_ip_info::ip_name "pccdu"
set ::collage_ip_info::ip_top_module_name "rcfwl_gclk_pccdu"
set ::collage_ip_info::ip_version "1.0"
set ::collage_ip_info::ip_intent_sp ""
set ::collage_ip_info::ip_rtl_inc_dirs "$::env(MODEL_ROOT)/src/rtl/clkdist"

set ::collage_ip_info::ip_input_language SystemVerilog
set ::collage_ip_info::ip_input_files $::env(MODEL_ROOT)/src/rtl/clkdist/rcfwl_gclk_pccdu.sv

set ::collage_ip_info::ip_plugin_dir "" ; # Directories - space separated list - with tcl plugin files
set ::collage_ip_info::ip_ifc_def_hook "pccdu_create_ifc_instances" ; # Set this to procedure to add IP interfaces - defined below

######################################################################
# Procedure to create IP interfaces
######################################################################
proc pccdu_create_ifc_instances {} {

###  set ifc_inst_name "pccdu_dop_in_intf"
###  create_interface_instance $ifc_inst_name -type consumer \
###      -interface 10NMCLK::DOP::IN -version 0.4 \
###      -associationformat "*%s"

###  set_interface_parameter_attribute -instance $ifc_inst_name      NUM_OF_GRID_PRI_CLKS  InterfaceLink        NUM_OF_GRID_PRI_CLKS
###  set_interface_parameter_attribute -instance $ifc_inst_name      NUM_OF_GRID_PRI_CLKS  ParamValueFromDesign 1

###  set_interface_port_attribute -instance $ifc_inst_name DOP_PRECLK_GRID InterfaceLink     fdop_preclk_grid
  
  
###  set open_params { }
###  set open_ports {}
###  collage_set_open_interface -ifc_inst_name $ifc_inst_name -parameters $open_params -ports $open_ports

###  set port_map {
###  }

###  collage_set_interface_link -ifc_inst_name $ifc_inst_name -ports $port_map

###  set ifc_inst_name "pccdu_dop_out_intf"
###  create_interface_instance $ifc_inst_name -type provider \
###      -interface 10NMCLK::DOP::OUT -version 0.4 \
###      -associationformat "*%s"

###  set_interface_parameter_attribute -instance $ifc_inst_name      NUM_OF_GRID_PRI_CLKS  InterfaceLink        NUM_OF_GRID_PRI_CLKS
###  set_interface_parameter_attribute -instance $ifc_inst_name      NUM_OF_GRID_PRI_CLKS  ParamValueFromDesign 1
###  set_interface_parameter_attribute -instance $ifc_inst_name      NUM_OF_GRID_SEC_CLKS  InterfaceLink        NUM_OF_GRID_SCC_CLKS
###  set_interface_parameter_attribute -instance $ifc_inst_name      NUM_OF_GRID_SEC_CLKS  ParamValueFromDesign 1

 ### set_interface_port_attribute -instance $ifc_inst_name DOP_POSTCLK InterfaceLink      adop_postclk
###  set_interface_port_attribute -instance $ifc_inst_name DOP_POSTCLK_FREE InterfaceLink adop_postclk_free

###  set_interface_port_attribute -instance $ifc_inst_name SCAN_CLK InterfaceLink         fdop_scan_clk
###  set_interface_port_attribute -instance $ifc_inst_name SCAN_DOP_CLKEN InterfaceLink   fscan_dop_clken
###  set_interface_port_attribute -instance $ifc_inst_name DOP_PRECLK_DIV_SYNC  InterfaceLink      fdop_preclk_div_sync

###  set open_params { }
###  set open_ports {}
###  collage_set_open_interface -ifc_inst_name $ifc_inst_name -parameters $open_params -ports $open_ports

 ### set port_map {
###  }

 ### collage_set_interface_link -ifc_inst_name $ifc_inst_name -ports $port_map

  return
}

######################################################################
# Lines below are generic and should not include design specific info
######################################################################
###collage_add_ifc_def_files -files $::env(SDG_INTERFACE_DEFS)/10nm_clock_interface.0.4.tcl

collage_simple_build_flow -exit -copy_corekit
