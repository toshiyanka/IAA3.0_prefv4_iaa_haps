#======================#
# START OF CATCH BLOCK #
#======================#
if { [catch {
#======================#

###########################################################################
# IP info settings
###########################################################################

set ::use_vcs_parser 1
set ::collage_ip_info::ip_name "hqm_visa"
set ::collage_ip_info::ip_top_module_name "hqm_visa"
set ::collage_ip_info::ip_version "0.0"
set ::collage_ip_info::ip_intent_sp ""
set ::collage_ip_info::ip_input_files "\
    $::env(WORKAREA)/src/rtl/hqm_pkg.sv \
    $::env(WORKAREA)/src/rtl/hqm_system_visa_probe.sv \
    $::env(WORKAREA)/src/rtl/hqm_core_visa_block.sv \
    $::env(WORKAREA)/src/rtl/hqm_visa.sv \
"
set ::collage_ip_info::ip_input_language SystemVerilog
set ::collage_ip_info::ip_rtl_inc_dirs "\
    $::env(WORKAREA)/src/rtl \
    $::env(WORKAREA)/src/rtl/visa/include \
"

set ::collage_ip_info::ip_plugin_dir "" ; # Directories - space separated list - with tcl plugin files
set ::collage_ip_info::ip_plugin_dirs "" ;
set ::collage_ip_info::ip_ifc_def_hook "ip_create_ifc_instances" ; # Set this to procedure to add IP interfaces - defined below

    set port_map {}
    set open_params {}
    set open_ports {}
######################################################################
# Procedure to create IP interfaces
######################################################################
proc ip_create_ifc_instances {} {

    ############################################
    #DTF::Clock (for DVP)
    ############################################
    set ifc_inst_name "dvp_dtf_clock"

    create_interface_instance $ifc_inst_name \
        -type consumer \
        -interface "DTF::Clock" \
        -version "1.4_r1.2__v1.4_r1.2" \
        -associationformat "%s"

    set port_map    {}
    set open_params {}
    set open_ports  {}

    ############################################
    #DTF::Reset (for DVP)
    ############################################
    set ifc_inst_name "dvp_dtf_reset"

    create_interface_instance $ifc_inst_name \
        -type consumer \
        -interface "DTF::Reset" \
        -version "1.4_r1.2__v1.4_r1.2" \
        -associationformat "%s"

    set port_map    {}
    set open_params {}
    set open_ports  {}

    ############################################
    #DTF::Signals (for DVP)
    ############################################
    set ifc_inst_name "dvp_dtf"

    create_interface_instance $ifc_inst_name \
        -type provider \
        -interface "DTF::Signals" \
        -version "1.4_r1.2__v1.4_r1.2" \
        -associationformat ""

    set_interface_parameter_attribute -instance $ifc_inst_name DTF_DATA_WIDTH       Value                   64
    set_interface_parameter_attribute -instance $ifc_inst_name DTF_HEADER_WIDTH     Value                   25
    set_interface_parameter_attribute -instance $ifc_inst_name DTF_PG_INTERFACE     Value                   0
    set_interface_parameter_attribute -instance $ifc_inst_name DTF_ISO_INTERFACE    Value                   0

    set_interface_parameter_attribute -instance $ifc_inst_name DTF_DATA_WIDTH       InterfaceLink           HQM_DTF_DATA_WIDTH
    set_interface_parameter_attribute -instance $ifc_inst_name DTF_HEADER_WIDTH     InterfaceLink           HQM_DTF_HEADER_WIDTH

    set_interface_parameter_attribute -instance $ifc_inst_name DTF_DATA_WIDTH       ParamValueFromDesign    true
    set_interface_parameter_attribute -instance $ifc_inst_name DTF_HEADER_WIDTH     ParamValueFromDesign    true

    set_parameter_attribute                                    HQM_DTF_DATA_WIDTH   Value                   64
    set_parameter_attribute                                    HQM_DTF_HEADER_WIDTH Value                   25

    set port_map    {
        fdtf_upstream_active_in     fdtf_upstream_active
        fdtf_upstream_credit_in     fdtf_upstream_credit
        fdtf_upstream_sync_in       fdtf_upstream_sync
        adtf_dnstream_data_out      adtf_dnstream_data
        adtf_dnstream_header_out    adtf_dnstream_header
        adtf_dnstream_valid_out     adtf_dnstream_valid
    }
    set open_params {}
    set open_ports  {}

    collage_set_interface_link -ifc_inst_name $ifc_inst_name -ports $port_map

    ############################################
    #DTF::Misc (for DVP)
    ############################################
    set ifc_inst_name "dvp_dtf_misc"

    create_interface_instance $ifc_inst_name \
        -type provider \
        -interface "DTF::Misc" \
        -version "1.4_r1.2__v1.4_r1.2" \
        -associationformat "%s"

    set_interface_parameter_attribute -instance $ifc_inst_name DTF_DATA_WIDTH       Value                   64
    set_interface_parameter_attribute -instance $ifc_inst_name DTF_HEADER_WIDTH     Value                   25
    set_interface_parameter_attribute -instance $ifc_inst_name DTF_PG_INTERFACE     Value                   0
    set_interface_parameter_attribute -instance $ifc_inst_name DTF_ISO_INTERFACE    Value                   0

    set port_map    {
        fdtf_packetizer_cid_N       fdtf_packetizer_cid
        fdtf_packetizer_mid_N       fdtf_packetizer_mid
    }
    set open_params {}
    set open_ports  {
        adtf_rst_out_b
        fdtf_iso_b
        fdtf_pg_empty_in
    }

    collage_set_open_interface -ifc_inst_name $ifc_inst_name -ports $open_ports -parameters $open_params
    collage_set_interface_link -ifc_inst_name $ifc_inst_name -ports $port_map

    ############################################
    #APB4 (for DVP)
    ############################################
    set ifc_inst_name "dvp_apb4"

    create_interface_instance $ifc_inst_name \
        -type consumer \
        -interface "APB4" \
        -version "2.0_r1.0__vC_r1.0" \
        -associationformat "dvp_%s"

    set_interface_parameter_attribute -instance $ifc_inst_name PADDR_WIDTH   Value  32
    set_interface_parameter_attribute -instance $ifc_inst_name PDATA_WIDTH   Value  32
    set_interface_parameter_attribute -instance $ifc_inst_name PSEL_WIDTH    Value  1

    set port_map    {
        PSELx           dvp_psel
    }
    set open_params {}
    set open_ports  {}

    collage_set_interface_link -ifc_inst_name $ifc_inst_name -ports $port_map

    ############################################
    #CTF::Signals (for DVP)
    ############################################
    set ifc_inst_name "dvp_ctf"

    create_interface_instance $ifc_inst_name \
        -type consumer \
        -interface "CTF::Signals" \
        -version "1.0_r1.1__v1.0_r1.1" \
        -associationformat "*%s"

    set_interface_parameter_attribute -instance $ifc_inst_name TRIGFABWIDTH         Value                   4
    set_interface_parameter_attribute -instance $ifc_inst_name TRIGFABWIDTH         InterfaceLink           HQM_TRIGFABWIDTH
    set_interface_parameter_attribute -instance $ifc_inst_name TRIGFABWIDTH         ParamValueFromDesign    true
    set_parameter_attribute                                    HQM_TRIGFABWIDTH     Value                   4

    set port_map    {}
    set open_params {}
    set open_ports  {}

    ############################################
    #IOSF::DFX::DSP_INSIDE (for DVP dfx_secureplugin)
    ############################################
    set ifc_inst_name "dvp_dsp_inside"

    create_interface_instance $ifc_inst_name \
        -type consumer \
        -interface "IOSF::DFX::DSP_INSIDE" \
        -version "2.0_r1.2__v2.0_r1.2" \
        -associationformat ""

    set_interface_parameter_attribute -instance $ifc_inst_name DFX_SECURE_WIDTH     Value                   8

    set port_map    {
        DEBUG_CAPABILITIES_ENABLING         fdfx_debug_cap
        DEBUG_CAPABILITIES_ENABLING_VALID   fdfx_debug_cap_valid
        DFX_SECURE_POLICY                   fdfx_security_policy
        EARLYBOOT_EXIT                      fdfx_earlyboot_debug_exit
        POLICY_UPDATE                       fdfx_policy_update
    }
    set open_params {}
    set open_ports  {}

    collage_set_interface_link -ifc_inst_name $ifc_inst_name -ports $port_map

    return
}

######################################################################
#/p/hdk/rtl/cad/x86-64_linux30/intel/bus_interface_defs/0.07/IOSF__DFX__RTDR/v1.5/coretools/iosf_dfx_rtdr_interface.v1.5_r1.1.tcl
collage_add_ifc_def_files -files "\
    $::env(HQM_COLLAGE_INTF_DEF_PATH)/DTF/v1.4/coretools/dtf_signals_interface.v1.4_r1.2.tcl \
    $::env(HQM_COLLAGE_INTF_DEF_PATH)/DTF/v1.4/coretools/dtf_clock_interface.v1.4_r1.2.tcl \
    $::env(HQM_COLLAGE_INTF_DEF_PATH)/DTF/v1.4/coretools/dtf_reset_interface.v1.4_r1.2.tcl \
    $::env(HQM_COLLAGE_INTF_DEF_PATH)/DTF/v1.4/coretools/dtf_misc_interface.v1.4_r1.2.tcl \
    $::env(HQM_COLLAGE_INTF_DEF_PATH)/CTF/v1.0/coretools/ctf_signals_interface.v1.0_r1.1.tcl \
    $::env(HQM_COLLAGE_INTF_DEF_PATH)/APB4/vC/coretools/apb4_interface.vC_r1.0.tcl \
    $::env(HQM_COLLAGE_INTF_DEF_PATH)/IOSF__DFX__DSP/v2.0/coretools/iosf_dfx_dsp_inside_interface.v2.0_r1.2.tcl \
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
