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

set ::collage_ip_info::ip_top_module_name rcfwl_dfxsecure_plugin
set ::collage_ip_info::ip_name rcfwl_dfxsecure_plugin
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

set ::collage_ip_info::ip_input_files "$_model_root_/source/rtl/dfxsecure_plugin/${_ip_name_}.sv"

set ::collage_ip_info::ip_plugin_dir "" ; # Directories - space separated list - with tcl plugin files
set ::collage_ip_info::ip_ifc_def_hook "dfxsecure_plugin_create_ifc_instances" ; # Set this to procedure to add IP interfaces - defined below
set ::collage_ip_info::ip_plugin_dirs "" ; 


######################################################################
# Interface instantiations
######################################################################
proc dfxsecure_plugin_create_ifc_instances {} {

  set ip_name $::collage_ip_info::ip_name

  ##################################################
  # 
  # IOSF DFX DFx Security Plugin
  # 
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

#  if {[array size ${ip_name}_${ifc_inst_name}] > 0} {
#    foreach p [array names ${ip_name}_${ifc_inst_name}] {
#      set_interface_port_attribute -instance $ifc_inst_name $p InterfaceLink [set [subst ${ip_name}_${ifc_inst_name}]($p)]
#    }
#  }

  # Temporary hack
  #set_port_attribute {fscan_mode} IfUnconnected export ; # Intentionally marked open (will generate X's / logic_dc as these are inputs)
  #set_port_attribute {fscan_func_preclk} IfUnconnected export
  #set_port_attribute fscan_clkstop IfUnconnected export
  #set_port_attribute {fscan_clkinven} IfUnconnected export
  #set_port_attribute {fscan_bypclk} IfUnconnected export
  #set_port_attribute {fscan_bypclken} IfUnconnected export
  #set_port_attribute {ascan_cdo} IfUnconnected export
  #set_port_attribute {ascan_func_postclk} IfUnconnected export

  return
}

######################################################################
# Lines below are generic and should not include design specific info
######################################################################
collage_add_ifc_def_files -files $::env(COLLAGE_INTF_DEF)/rtl_interface_defs/iosf_dfx/iosf_dfx_dfxsecure_plugin_interface.tcl
collage_simple_build_flow -exit -copy_corekit -copy_corekit_dir $::env(MODEL_ROOT)/tools/collage/coreKit/
