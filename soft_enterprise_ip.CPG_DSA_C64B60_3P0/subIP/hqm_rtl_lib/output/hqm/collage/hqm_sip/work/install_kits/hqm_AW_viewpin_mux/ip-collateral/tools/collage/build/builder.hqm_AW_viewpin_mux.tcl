#======================#
# START OF CATCH BLOCK #
#======================#
if { [catch {
#======================#

###########################################################################
# IP info settings
###########################################################################

set ::use_vcs_parser 1
set ::collage_ip_info::ip_name "hqm_AW_viewpin_mux"
set ::collage_ip_info::ip_top_module_name "hqm_AW_viewpin_mux"
set ::collage_ip_info::ip_version "0.0"
set ::collage_ip_info::ip_intent_sp ""
set ::collage_ip_info::ip_input_files "$::env(WORKAREA)/subIP/sip/AW/src/rtl/hqm_AW_viewpin_mux.sv"
set ::collage_ip_info::ip_input_language SystemVerilog
set ::collage_ip_info::ip_rtl_inc_dirs "$::env(WORKAREA)/subIP/sip/AW/src/rtl"

set ::collage_ip_info::ip_plugin_dir "" ; # Directories - space separated list - with tcl plugin files
set ::collage_ip_info::ip_plugin_dirs "" ;
set ::collage_ip_info::ip_ifc_def_hook "ip_create_ifc_instances" ; # Set this to procedure to add IP interfaces - defined below

######################################################################
# Procedure to create IP interfaces
######################################################################
proc ip_create_ifc_instances {} {

    ##################################################
    # digital viewpins
    ##################################################
    set ifc_inst_name "viewpins_dig"

    create_interface_instance $ifc_inst_name \
        -interface "ViewPin" \
        -type consumer \
        -version "1.0_r1.2__v1.0_r1.2" \
        -associationformat ""

    set port_map {
        dig_view_out_0          mux_out[0]
        dig_view_out_1          mux_out[1]
    }
    set open_params {}
    set open_ports  {
        ana_view_out_0
        ana_view_out_1
    }

    collage_set_open_interface -ifc_inst_name $ifc_inst_name -ports $open_ports -parameters $open_params
    collage_set_interface_link -ifc_inst_name $ifc_inst_name -ports $port_map

    return
}

######################################################################
#/p/hdk/rtl/cad/x86-64_linux30/intel/bus_interface_defs/0.07/IOSF__DFX__RTDR/v1.5/coretools/iosf_dfx_rtdr_interface.v1.5_r1.1.tcl
collage_add_ifc_def_files -files "\
    $::env(HQM_COLLAGE_INTF_DEF_PATH)/ViewPin/v1.0/coretools/viewpin_interface.v1.0_r1.2.tcl \
"

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
