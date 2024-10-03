##------------------------------------------------------------------------------
##
##  INTEL CONFIDENTIAL
##
##  Copyright 2010 Intel Corporation All Rights Reserved.
##
##  The source code contained or described herein and all documents related
##  to the source code (Material) are owned by Intel Corporation or its 
##  suppliers or licensors. Title to the Material remains with Intel
##  Corporation or its suppliers and licensors. The Material contains trade
##  secrets and proprietary and confidential information of Intel or its 
##  suppliers and licensors. The Material is protected by worldwide copyright
##  and trade secret laws and treaty provisions. No part of the Material may 
##  be used, copied, reproduced, modified, published, uploaded, posted,
##  transmitted, distributed, or disclosed in any way without Intel's prior
##  express written permission.
##
##  No license under any patent, copyright, trade secret or other intellectual
##  property right is granted to or conferred upon you by disclosure or
##  delivery of the Materials, either expressly, by implication, inducement,
##  estoppel or otherwise. Any license under such intellectual property rights
##  must be express and approved by Intel in writing.
##
##------------------------------------------------------------------------------


###########################################################################
# 
###########################################################################

set ::collage_ip_info::ip_top_module_name stap
set ::collage_ip_info::ip_name stap
##set ::collage_ip_info::ip_version "ip-stap-12ww06.2-v1.5"

set _ip_name_ $::collage_ip_info::ip_top_module_name
#set _model_root_ $env(FC_DFX_ROOT)/external_ip/$_ip_name_/$::collage_ip_info::ip_version
set _model_root_ $env(MODEL_ROOT)

set ::collage_ip_info::ip_intent_sp ""

#set ::collage_ip_info::ip_rtl_inc_dirs "$env(FC_DFX_ROOT)/collage/temp_include \ 
#                                        $_model_root_/source/rtl/include \
#                                        $_model_root_/source/rtl/include/assertions"

set ::collage_ip_info::ip_rtl_inc_dirs "$_model_root_/source/rtl/include"
                                        #$_model_root_/source/rtl/include/assertions"

set ::collage_ip_info::ip_input_language SystemVerilog

set ::collage_ip_info::ip_input_files "$_model_root_/source/rtl/stap/${_ip_name_}.sv"

set ::collage_ip_info::ip_plugin_dir "" ; # Directories - space separated list - with tcl plugin files
set ::collage_ip_info::ip_ifc_def_hook "stap_create_ifc_instances" ; # Set this to procedure to add IP interfaces - defined below
set ::collage_ip_info::ip_plugin_dirs "" ; 


######################################################################
# Interface instantiations
######################################################################
proc stap_create_ifc_instances {} {

  set ip_name $::collage_ip_info::ip_name

  ##################################################
  # 
  # IOSF DFX (JTAG Primary & Secondary)
  # 
  ##################################################
  set ifc_inst_name "jtag_pri"
  set instance [create_interface_instance $ifc_inst_name \
		    -type consumer -interface IOSF::DFX::JTAG -version 1.0 -associationformat "%s"] ;

  set ifc_inst_name "jtag_sec"
  set instance [create_interface_instance $ifc_inst_name \
		    -used "@STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK>0" \
		    -type consumer -interface IOSF::DFX::JTAG -version 1.0 -associationformat "%s"] ;
  set port_map {
    FTAP_TDI  ftapsslv_tdi 
    FTAP_TMS  ftapsslv_tms 
    FTAP_TCK  ftapsslv_tck 
    FTAP_TRST_B  ftapsslv_trst_b
    ATAP_TDO  atapsslv_tdo 
    ATAP_TDOEN  atapsslv_tdoen 
  }

  set param_map {}
  collage_set_interface_link -ifc_inst_name $ifc_inst_name -ports $port_map -parameters $param_map

  ##################################################
  # 
  # IOSF DFX (JTAG Primary & Secondary to TAPNetwork)
  # 
  ##################################################
  set ifc_inst_name "tapnw_pri"
  set instance [create_interface_instance $ifc_inst_name \
		    -used "@STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK>0" \
		    -type provider -interface IOSF::DFX::TAPNW -version 1.4] ;


  # stap has multiple TDOEN, how do we deal with it?
  # input  logic [(STAP_NUMBER_OF_TAPS - 1):0] sntapnw_atap_tdo_en,
  set port_map {
    TDI  sntapnw_ftap_tdi 
    TMS  sntapnw_ftap_tms 
    TCK  sntapnw_ftap_tck 
    TRST_B  sntapnw_ftap_trst_b
    TDO  sntapnw_atap_tdo
    TDOEN  sntapnw_atap_tdo_en[0]
  }

  set param_map {}
  collage_set_interface_link -ifc_inst_name $ifc_inst_name -ports $port_map -parameters $param_map

  set ifc_inst_name "tapnw_sec"
  set instance [create_interface_instance $ifc_inst_name \
		    -used "@STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK>0" \
		    -type provider -interface IOSF::DFX::TAPNW -version 1.4] ;

  # stap has multiple TDOEN, how do we deal with it?
  # input  logic [(STAP_NUMBER_OF_TAPS - 1):0] sntapnw_atap_tdo2_en,
  set port_map {
    TDI  sntapnw_ftap_tdi2
    TMS  sntapnw_ftap_tms2
    TCK  sntapnw_ftap_tck2
    TRST_B  sntapnw_ftap_trst2_b
    TDO  sntapnw_atap_tdo2
    TDOEN  sntapnw_atap_tdo2_en[0]
  }

  set param_map {}
  collage_set_interface_link -ifc_inst_name $ifc_inst_name -ports $port_map -parameters $param_map

  ##################################################
  # 
  # IOSF DFX Control Signals to 0.7 TAPNetwork
  # 
  ##################################################
  set ifc_inst_name "tapnw_ctrl"
  set instance [create_interface_instance $ifc_inst_name \
   	    -used "@STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK>0" \
   	    -type provider -interface IOSF::DFX::TAPNW_CTRL -version 1.4 -associationformat "sftapnw_%s"] ;

  set_interface_parameter_attribute -instance $ifc_inst_name NUMBER_OF_TAPS InterfaceLink STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK_NZ
  set_interface_parameter_attribute -instance $ifc_inst_name NUMBER_OF_TAPS ParamValueFromDesign true

  ##################################################
  # Remote Test Data Register
  ##################################################
  set ifc_inst_name "rtdr"
  set instance [create_interface_instance $ifc_inst_name \
   	    -used "@STAP_RTDR_IS_BUSSED && @STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS>0" \
   	    -type provider -interface IOSF::DFX::RTDR -version 1.5 -associationformat "tap_%s"] ;

  ##set_interface_parameter_attribute -instance $ifc_inst_name SYNC_TCK InterfaceLink STAP_ENABLE_SYNCHRONIZER_FOR_REMOTE_TDR
  ##set_interface_parameter_attribute -instance $ifc_inst_name SYNC_TCK ParamValueFromDesign true

  set_interface_port_attribute -instance $ifc_inst_name RTDR_TDO InterfaceLink rtdr_tap_tdo\[@SlotNumber\]
  set_interface_port_attribute -instance $ifc_inst_name RTDR_TDI InterfaceLink tap_rtdr_tdi\[@SlotNumber\]
  set_interface_port_attribute -instance $ifc_inst_name RTDR_CAPTURE InterfaceLink tap_rtdr_capture\[@SlotNumber\]
  set_interface_port_attribute -instance $ifc_inst_name RTDR_SHIFT InterfaceLink tap_rtdr_shift\[@SlotNumber\]
  set_interface_port_attribute -instance $ifc_inst_name RTDR_UPDATE InterfaceLink tap_rtdr_update\[@SlotNumber\]
  set_interface_port_attribute -instance $ifc_inst_name RTDR_IRDEC InterfaceLink tap_rtdr_irdec\[@SlotNumber\]

  set port_map {}
  set param_map {}
  collage_set_interface_link -ifc_inst_name $ifc_inst_name -ports $port_map -parameters $param_map

  set rtdr_open_ports {REMOTE_TCK}
  collage_set_open_interface -ifc_inst_name $ifc_inst_name -ports $rtdr_open_ports

  set ifc_inst_name "rtdr_ctrl"
  set instance [create_interface_instance $ifc_inst_name \
   	    -used "@STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS>0" \
   	    -type provider -interface IOSF::DFX::RTDR_CTRL -version 1.5 -associationformat "tap_%s"] ;

  set_interface_port_attribute -instance $ifc_inst_name RTDR_POWERGOOD_RST_B InterfaceLink tap_rtdr_powergood
  set_interface_port_attribute -instance $ifc_inst_name RTDR_PROG_RST_B InterfaceLink tap_rtdr_prog_rst_b\[@SlotNumber\]
  set_interface_port_attribute -instance $ifc_inst_name RTDR_SELECTIR InterfaceLink tap_rtdr_selectir
  set_interface_port_attribute -instance $ifc_inst_name RTDR_RTI InterfaceLink tap_rtdr_rti

  set port_map {}
  set param_map {}
  collage_set_interface_link -ifc_inst_name $ifc_inst_name -ports $port_map -parameters $param_map

  if {[sizeof_collection [find_item -quiet -type port tap_rtdr_tck]] != 0} {
    set_interface_port_attribute -instance $ifc_inst_name TAP_TCK InterfaceLink tap_rtdr_tck
  } else {
    set rtdr_open_ports {TAP_TCK}
    collage_set_open_interface -ifc_inst_name $ifc_inst_name -ports $rtdr_open_ports
  }

  set ifc_inst_name "rtdr_bussed_0"
  set instance [create_interface_instance $ifc_inst_name \
   	    -used "!@STAP_RTDR_IS_BUSSED && @STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS>0" \
   	    -type provider -interface IOSF::DFX::RTDR_BUSSED_0 -version 1.5 -associationformat "tap_%s"] ;

  ##set_interface_parameter_attribute -instance $ifc_inst_name SYNC_TCK InterfaceLink STAP_ENABLE_SYNCHRONIZER_FOR_REMOTE_TDR
  ##set_interface_parameter_attribute -instance $ifc_inst_name SYNC_TCK ParamValueFromDesign true

  set_interface_port_attribute -instance $ifc_inst_name RTDR_TDO InterfaceLink rtdr_tap_tdo\[@SlotNumber\]
  set_interface_port_attribute -instance $ifc_inst_name RTDR_TDI InterfaceLink tap_rtdr_tdi
  set_interface_port_attribute -instance $ifc_inst_name RTDR_CAPTURE InterfaceLink tap_rtdr_capture
  set_interface_port_attribute -instance $ifc_inst_name RTDR_SHIFT InterfaceLink tap_rtdr_shift
  set_interface_port_attribute -instance $ifc_inst_name RTDR_UPDATE InterfaceLink tap_rtdr_update
  set_interface_port_attribute -instance $ifc_inst_name RTDR_IRDEC InterfaceLink tap_rtdr_irdec\[@SlotNumber\]

  set port_map {}
  set param_map {}
  collage_set_interface_link -ifc_inst_name $ifc_inst_name -ports $port_map -parameters $param_map

  set rtdr_open_ports {REMOTE_TCK}
  collage_set_open_interface -ifc_inst_name $ifc_inst_name -ports $rtdr_open_ports


  ##################################################
  # 
  # IOSF DFX Boundary Scan
  # 
  ##################################################
  set ifc_inst_name "bscan_stap"
  set instance [create_interface_instance $ifc_inst_name \
                    -type provider -interface IOSF::DFX::BSCAN -version 1.5 -associationformat "%s"] ;


  ######################################################################################
  # Port to logical interface mapping
  ######################################################################################
  set bscan_port_map {
    FBSCAN_CAPTUREDR      stap_fbscan_capturedr
    FBSCAN_CHAINEN        stap_fbscan_chainen
    FBSCAN_D6ACTESTSIG_B  stap_fbscan_d6actestsig_b
    FBSCAN_D6INIT         stap_fbscan_d6init
    FBSCAN_D6SELECT       stap_fbscan_d6select
    FBSCAN_EXTOGEN        stap_fbscan_extogen
    FBSCAN_INTEST_MODE    stap_fbscan_intest_mode
    FBSCAN_EXTOGSIG_B     stap_fbscan_extogsig_b
    FBSCAN_HIGHZ          stap_fbscan_highz
    FBSCAN_MODE           stap_fbscan_mode
    FBSCAN_SHIFTDR        stap_fbscan_shiftdr
    FBSCAN_TCK            stap_fbscan_tck
    FBSCAN_UPDATEDR       stap_fbscan_updatedr
    FBSCAN_UPDATEDR_CLK   stap_fbscan_updatedr_clk
    RUNBIST_EN            stap_fbscan_runbist_en
  }
  #set bscan_port_map {}
  collage_set_interface_link -ifc_inst_name $ifc_inst_name -ports $bscan_port_map

  ######################################################################################
  # Open ports (optional interface ports not on design)
  ######################################################################################
  set bscan_open_ports {}
  set bscan_open_parameters {}
  collage_set_open_interface -ifc_inst_name $ifc_inst_name -ports $bscan_open_ports -parameters $bscan_open_parameters

  ##################################################
  # WTAP Interface
  ##################################################
  set ifc_inst_name "wtap"
  set instance [create_interface_instance $ifc_inst_name \
		    -used "@STAP_NUMBER_OF_WTAPS_IN_NETWORK>0" \
		    -type provider -interface IOSF::DFX::WTAP -version 1.4 -associationformat "sn_%s"] ;

  set_interface_port_attribute -instance $ifc_inst_name AWTAP_WSO InterfaceLink sn_awtap_wso\[@SlotNumber\]
  set_interface_port_attribute -instance $ifc_inst_name FWTAP_WSI InterfaceLink sn_fwtap_wsi\[@SlotNumber\]
  set_interface_port_attribute -instance $ifc_inst_name FWTAP_WRCK InterfaceLink sn_fwtap_wrck
  set_interface_port_attribute -instance $ifc_inst_name FWTAP_WRST_B InterfaceLink sn_fwtap_wrst_b
  set_interface_port_attribute -instance $ifc_inst_name FWTAP_CAPTUREWR InterfaceLink sn_fwtap_capturewr
  set_interface_port_attribute -instance $ifc_inst_name FWTAP_SHIFTWR InterfaceLink sn_fwtap_shiftwr
  set_interface_port_attribute -instance $ifc_inst_name FWTAP_UPDATEWR InterfaceLink sn_fwtap_updatewr
  set_interface_port_attribute -instance $ifc_inst_name FWTAP_RTI InterfaceLink sn_fwtap_rti
  set_interface_port_attribute -instance $ifc_inst_name FWTAP_SELECTWIR InterfaceLink sn_fwtap_selectwir

  set port_map {}
  set param_map {}
  collage_set_interface_link -ifc_inst_name $ifc_inst_name -ports $port_map -parameters $param_map
 
  ##################################################
  # DFx Secure plugin Interface
  ##################################################
  
  set ifc_inst_name "iosf_dfx_dfxsecure_plugin"
  set instance [create_interface_instance $ifc_inst_name \
		    -type consumer -interface IOSF::DFX::DFXSECURE_PLUGIN -version 1.0 -associationformat "%s"] ;
  set dfxsecure_plugin_port_map {
                       DFX_SECURE_POLICY           fdfx_secure_policy
                       EARLYBOOT_EXIT              fdfx_earlyboot_exit
                       POLICY_UPDATE               fdfx_policy_update
					    }

  collage_set_interface_link -ifc_inst_name $ifc_inst_name -ports $dfxsecure_plugin_port_map

  ###########################################################
  # Parameter attributes to control verilog output
  ###########################################################
  #set_parameter_attribute STAP_INSTRUCTION_FOR_DATA_REGISTERS SegmentSize 8
  #set_parameter_attribute STAP_INSTRUCTION_FOR_DATA_REGISTERS SegmentBase h

  #set_parameter_attribute STAP_SIZE_OF_EACH_TEST_DATA_REGISTER SegmentSize 16
  #set_parameter_attribute STAP_SIZE_OF_EACH_TEST_DATA_REGISTER SegmentBase d

  #set_parameter_attribute STAP_MSB_VALUES_OF_TEST_DATA_REGISTERS SegmentSize 16
  #set_parameter_attribute STAP_MSB_VALUES_OF_TEST_DATA_REGISTERS SegmentBase d

  #set_parameter_attribute STAP_LSB_VALUES_OF_TEST_DATA_REGISTERS SegmentSize 16
  #set_parameter_attribute STAP_LSB_VALUES_OF_TEST_DATA_REGISTERS SegmentBase h

  #set_parameter_attribute STAP_RESET_VALUES_OF_TEST_DATA_REGISTERS SegmentSize 32
  #set_parameter_attribute STAP_RESET_VALUES_OF_TEST_DATA_REGISTERS SegmentBase h

  # Following ports to be exported out of the subsytem for appropriate connectivity at SoC level
  #set_port_attribute ftap_slvidcode IfUnconnected export
  #set_port_attribute {fdfx_powergood} IfUnconnected export

  # Default tie-off for ports that are not required to be used
  # In hierarchical mode, only bit 0 of the bus is utilized, rest should be tied to ground
  set_port_attribute sntapnw_atap_tdo_en IfUnconnected zero

  return
}

######################################################################
# Lines below are generic and should not include design specific info
######################################################################
collage_add_ifc_def_files -files $::env(COLLAGE_INTF_DEF)/rtl_interface_defs/iosf_dfx/iosf_dfx_interface.tcl
collage_add_ifc_def_files -files $::env(COLLAGE_INTF_DEF)/rtl_interface_defs/iosf_dfx/iosf_dfx_tapnw_interface.1.4.tcl
collage_add_ifc_def_files -files $::env(COLLAGE_INTF_DEF)/rtl_interface_defs/iosf_dfx/iosf_dfx_wtap_interface.tcl
collage_add_ifc_def_files -files $::env(COLLAGE_INTF_DEF)/rtl_interface_defs/iosf_dfx/iosf_dfx_rtdr_interface.1.5.tcl
collage_add_ifc_def_files -files $::env(COLLAGE_INTF_DEF)/rtl_interface_defs/iosf_dfx/iosf_dfx_rtdr_bussed_0_interface.1.5.tcl
collage_add_ifc_def_files -files $::env(COLLAGE_INTF_DEF)/rtl_interface_defs/iosf_dfx/iosf_dfx_bscan_interface.1.5.tcl
collage_add_ifc_def_files -files $::env(COLLAGE_INTF_DEF)/rtl_interface_defs/iosf_dfx/iosf_dfx_dfxsecure_plugin_interface.tcl
#collage_create_workspace 
#create_workspace -ipxact
#collage_simple_build_flow -gen_ipxact_xml
collage_simple_build_flow -exit -copy_corekit -copy_corekit_dir $::env(MODEL_ROOT)/tools/collage/coreKit/
