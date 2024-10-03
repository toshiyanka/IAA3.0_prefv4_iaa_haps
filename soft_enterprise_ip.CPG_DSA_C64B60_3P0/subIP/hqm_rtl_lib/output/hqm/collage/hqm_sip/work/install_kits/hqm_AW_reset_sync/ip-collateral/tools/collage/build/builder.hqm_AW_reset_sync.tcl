#======================#
# START OF CATCH BLOCK #
#======================#
if { [catch {
#======================#

###########################################################################
# IP info settings
###########################################################################

set ::use_vcs_parser 1
set ::collage_ip_info::ip_name "hqm_AW_reset_sync"
set ::collage_ip_info::ip_top_module_name "hqm_AW_reset_sync"
set ::collage_ip_info::ip_version "0.0"
set ::collage_ip_info::ip_intent_sp ""
set ::collage_ip_info::ip_input_files "$::env(WORKAREA)/subIP/sip/AW/src/rtl/hqm_AW_reset_sync.sv"
set ::collage_ip_info::ip_input_language SystemVerilog
set ::collage_ip_info::ip_rtl_inc_dirs "$::env(WORKAREA)/subIP/sip/AW/src/rtl"

set ::collage_ip_info::ip_plugin_dir "" ; # Directories - space separated list - with tcl plugin files
set ::collage_ip_info::ip_plugin_dirs "" ;
set ::collage_ip_info::ip_ifc_def_hook "ip_create_ifc_instances" ; # Set this to procedure to add IP interfaces - defined below

######################################################################
# Procedure to create IP interfaces
######################################################################
proc ip_create_ifc_instances {} {
   return
}

######################################################################
# Create workspace (see help for options)
######################################################################
collage_create_workspace -replace

######################################################################
# Run the build flow (see help for options)
######################################################################
collage_simple_build_flow -exit -copy_corekit -dont_create_ws -disable_ipxact

#====================#
# END OF CATCH BLOCK #
#====================#
} ] } {
   puts stderr "\n\nERROR (Code = ${::errorCode}):\n${::errorInfo}\n"
   exit 1
}
#====================#
