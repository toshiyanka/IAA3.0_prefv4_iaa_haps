###########################################################################
# IP info settings
###########################################################################

set ::collage_ip_info::ip_name "dft_reset_sync"
set ::collage_ip_info::ip_top_module_name "hqm_rcfwl_dft_reset_sync"
set ::collage_ip_info::ip_version "1.0"
set ::collage_ip_info::ip_intent_sp ""
set ::collage_ip_info::ip_rtl_inc_dirs "$::env(MODEL_ROOT)/src/rtl/widgets"
set ::collage_ip_info::ip_input_language SystemVerilog
set ::collage_ip_info::ip_input_files $::env(MODEL_ROOT)/src/rtl/widgets/hqm_rcfwl_dft_reset_sync.sv

set ::collage_ip_info::ip_plugin_dir "" ; # Directories - space separated list - with tcl plugin files
set ::collage_ip_info::ip_ifc_def_hook "dft_reset_sync_create_ifc_instances" ; # Set this to procedure to add IP interfaces - defined below

######################################################################
# Procedure to create IP interfaces
######################################################################
proc dft_reset_sync_create_ifc_instances {} {

    collage_create_ip_clock -pin clk_in -clk_type FUNC_CLK -clk_max_freq 1200 -clk_min_freq 1200 -reference_clock_name x12clk
###################################################################
# scan interface
###################################################################
set ifc_inst_name "dfx_scan"
set instance [create_interface_instance $ifc_inst_name \
              -type consumer \
              -interface IOSF::DFX::SCAN \
              -associationformat "%s" ]

set_interface_parameter_attribute -instance $instance NUM_RSTBYPEN Value 1 
set_interface_parameter_attribute -instance $instance NUM_BYPRST_B Value 1

set_interface_port_attribute -instance $instance FSCAN_RSTBYPEN InterfaceLink "fscan_rstbyp_sel"
set_interface_port_attribute -instance $instance FSCAN_BYPRST_B InterfaceLink "fscan_byprst_b"


  set open_ports {ASCAN_SDO \
                  FSCAN_BYPLATRST_B \
                  FSCAN_CLKGENCTRL \
                  FSCAN_CLKGENCTRLEN \
                  FSCAN_MODE_ATSPEED \
                  FSCAN_RAM_AWT_MODE \
                  FSCAN_RAM_AWT_REN \
                  FSCAN_RAM_AWT_WEN \
                  FSCAN_RAM_BYPSEL \
                  FSCAN_RAM_ODIS_B \
                  FSCAN_RAM_RDDIS_B \
                  FSCAN_RAM_WRDIS_B \
                  FSCAN_RET_CTRL \
                  FSCAN_SDI \
                  }

  set open_params {NUM_BYPLATRST_B \
                   NUM_CLKGENCTRL \
                   NUM_CLKGENCTRLEN \
                   NUM_RAM_AWT_MODE \
                   NUM_RAM_AWT_REN \
                   NUM_RAM_AWT_WEN \
                   NUM_RAM_BYPSEL \
                   NUM_RAM_ODIS_B \
                   NUM_SDI \
                   NUM_SDO \
                   SCAN_INDEX \
                   SCAN_PREFIX \
                   }

  collage_set_open_interface -ifc_inst_name $ifc_inst_name -ports $open_ports -parameters $open_params

  return
}

######################################################################
# Lines below are generic and should not include design specific info
######################################################################
collage_add_ifc_def_files -files \
"$::env(COLLAGE_INTF_DEF)/rtl_interface_defs/iosf_dfx/iosf_dfx_scan_interface.2.2.tcl"

collage_simple_build_flow -exit -copy_corekit
