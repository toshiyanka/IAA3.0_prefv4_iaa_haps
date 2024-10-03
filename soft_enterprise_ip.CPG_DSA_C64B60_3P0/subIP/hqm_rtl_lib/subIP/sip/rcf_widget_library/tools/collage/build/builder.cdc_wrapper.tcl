###########################################################################
# IP info settings
###########################################################################

set ::collage_ip_info::ip_name "cdc_wrapper"
set ::collage_ip_info::ip_top_module_name "hqm_rcfwl_cdc_wrapper"
set ::collage_ip_info::ip_version "1.0"
set ::collage_ip_info::ip_intent_sp ""
set ::collage_ip_info::ip_rtl_inc_dirs "$::env(MODEL_ROOT)/src/rtl/widgets"
set ::collage_ip_info::ip_input_language SystemVerilog
set ::collage_ip_info::ip_input_files $::env(MODEL_ROOT)/src/rtl/widgets/hqm_rcfwl_cdc_wrapper.sv

set ::collage_ip_info::ip_plugin_dir "" ; # Directories - space separated list - with tcl plugin files
set ::collage_ip_info::ip_ifc_def_hook "cdc_wrapper_create_ifc_instances" ; # Set this to procedure to add IP interfaces - defined below

######################################################################
# Procedure to create IP interfaces
######################################################################
proc cdc_wrapper_create_ifc_instances {} {

    #### clocks for caliber
    collage_create_ip_clock -pin pgcg_clk -clk_type FUNC_CLK -clk_max_freq 400 -clk_min_freq 400 -reference_clock_name x4clk
    collage_create_ip_clock -pin clock -clk_type FUNC_CLK -clk_max_freq 1200 -clk_min_freq 1200 -reference_clock_name x12clk

##########################
# IOSF-Sideband interfaces
##########################
#  set instance [create_interface_instance ism_agent \
#               -interface IOSF::SB::ISM \
#               -type      consumer \
#               -associationformat "%s" \
#               ]

# set instance [create_interface_instance ism_fabric \
#               -interface IOSF::SB::ISM \
#               -type      consumer \
#               -associationformat "%s" \
#               ]

#  set instance [create_interface_instance pok \
#               -interface IOSF::SB::Pok \
#               -type      consumer \
#               -associationformat "%s" \
#               ]

##########################
# IOSF DFX VISA interface
##########################
#  set instance [create_interface_instance ism_agent \
#               -interface IOSF::DFX::ISM \
#               -type      consumer \
#               -associationformat "%s" \
#               ]

#  set instance [create_interface_instance ism_fabric \
#               -interface IOSF::DFX::ISM \
#               -type      consumer \
#               -associationformat "%s" \
#               ]

set instance [create_interface_instance dfx_visa_x4_lane0 \
              -interface IOSF::DFX::VISA \
              -type      consumer \
              -associationformat "%s" \
              ]

set_interface_parameter_attribute -instance $instance VISA_LANE_WIDTH Value 8
set_interface_parameter_attribute -instance $instance VISA_LANE_WIDTH InterfaceLink "<open>"
set_interface_port_attribute -instance $instance VISA_CLK InterfaceLink "avisa_strb_clk_pgcb_clk"
set_interface_port_attribute -instance $instance VISA_DBG_LANE InterfaceLink "avisa_debug_data_pgcb_clk[7:0]"

set instance [create_interface_instance dfx_visa_x12_lane0 \
              -interface IOSF::DFX::VISA \
              -type      consumer \
              -associationformat "%s" \
              ]

set_interface_parameter_attribute -instance $instance VISA_LANE_WIDTH Value 8
set_interface_parameter_attribute -instance $instance VISA_LANE_WIDTH InterfaceLink "<open>"
set_interface_port_attribute -instance $instance VISA_CLK InterfaceLink "avisa_strb_clk_clock[0]"
set_interface_port_attribute -instance $instance VISA_DBG_LANE InterfaceLink "avisa_debug_data_clk[7:0]"

set instance [create_interface_instance dfx_visa_x12_lane1 \
              -interface IOSF::DFX::VISA \
              -type      consumer \
              -associationformat "%s" \
              ]

set_interface_parameter_attribute -instance $instance VISA_LANE_WIDTH Value 8
set_interface_parameter_attribute -instance $instance VISA_LANE_WIDTH InterfaceLink "<open>"
set_interface_port_attribute -instance $instance VISA_CLK InterfaceLink "avisa_strb_clk_clock[1]"
set_interface_port_attribute -instance $instance VISA_DBG_LANE InterfaceLink "avisa_debug_data_clk[15:8]"



 set instance [create_interface_instance dfx_visa_cfg \
                -interface IOSF::DFX::VISA_CFG \
                -type      consumer \
                -associationformat "%s" \
              ]

set_interface_port_attribute -instance $instance VISA_SERSTB InterfaceLink "fvisa_serstrb"
set_interface_port_attribute -instance $instance VISA_FRAME InterfaceLink "fvisa_frame"
set_interface_port_attribute -instance $instance VISA_SERDATA InterfaceLink "fvisa_serdata"

###################################################################
# scan interface
###################################################################
set ifc_inst_name "dfx_scan"
set instance [create_interface_instance $ifc_inst_name \
              -type consumer \
              -interface IOSF::DFX::SCAN \
              -associationformat "%s" ]

#set_interface_parameter_attribute -instance $instance NUM_RSTBYPEN InterfaceLink "RST + 1"
#set_interface_parameter_attribute -instance $instance NUM_RSTBYPEN ParamValueFromDesign 1

#set_interface_parameter_attribute -instance $instance NUM_BYPRST_B InterfaceLink "RST + 1"
#set_interface_parameter_attribute -instance $instance NUM_BYPRST_B ParamValueFromDesign 1
set_interface_parameter_attribute -instance $instance NUM_RSTBYPEN Value 2
set_interface_parameter_attribute -instance $instance NUM_BYPRST_B Value 2

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

  #######################################
  # IOSF DFX DFX Secure Plugin interface
  #######################################

  set instance [create_interface_instance dfx_secure_plugin \
                -interface IOSF::DFX::DFXSECURE_PLUGIN \
                -type      consumer \
                -associationformat "%s" \
                ]

  set_interface_port_attribute $instance DFX_SECURE_POLICY InterfaceLink "fdfx_secure_policy"
  set_interface_port_attribute $instance EARLYBOOT_EXIT InterfaceLink "fdfx_earlyboot_exit"
  set_interface_port_attribute $instance POLICY_UPDATE InterfaceLink "fdfx_policy_update"


  return
}

######################################################################
# Lines below are generic and should not include design specific info
######################################################################
collage_add_ifc_def_files -files \
"$::env(COLLAGE_INTF_DEF)/rtl_interface_defs/iosf_dfx/iosf_dfx_visa_interface.tcl \
 $::env(COLLAGE_INTF_DEF)/rtl_interface_defs/iosf_dfx/iosf_dfx_scan_interface.2.2.tcl \
 $::env(COLLAGE_INTF_DEF)/rtl_interface_defs/iosf_dfx/iosf_dfx_dfxsecure_plugin_interface.tcl"

collage_simple_build_flow -exit -copy_corekit
