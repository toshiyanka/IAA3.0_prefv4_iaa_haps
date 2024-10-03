#======================#
# START OF CATCH BLOCK #
#======================#
if { [catch {
#======================#

proc hqm_respect_pragma {infile outfile} {

 set ifile [open $infile r]
 set data  [read $ifile]
 close $ifile
 set lines [split $data \n]
 set ofile [open $outfile w]
 set p 1
 foreach line $lines {
  if {[regexp -all {collage\-pragma translate_off} $line]} {set p 0}
  if {$p} {puts $ofile $line}
  if {[regexp -all {collage\-pragma translate_on}  $line]} {set p 1}
 }
 close $ofile
}

set hqm_respect_pragma_dir /tmp/$::env(USER)/hqm_respect_pragma/[pid]
file mkdir $hqm_respect_pragma_dir

hqm_respect_pragma $::env(WORKAREA)/src/rtl/hqm_master.sv   $hqm_respect_pragma_dir/hqm_master.sv
hqm_respect_pragma $::env(WORKAREA)/src/rtl/hqm_core_pkg.sv $hqm_respect_pragma_dir/hqm_core_pkg.sv

###########################################################################
# IP info settings
###########################################################################

set ::use_vcs_parser 1
set ::collage_ip_info::ip_name "hqm_master"
set ::collage_ip_info::ip_top_module_name "hqm_master"
set ::collage_ip_info::ip_version "0.0"
set ::collage_ip_info::ip_intent_sp ""
set ::collage_ip_info::ip_input_files "\
    $::env(WORKAREA)/subIP/sip/AW/src/rtl/hqm_AW_pkg.sv \
    $::env(WORKAREA)/src/rtl/hqm_pkg.sv \
    $hqm_respect_pragma_dir/hqm_core_pkg.sv \
    $hqm_respect_pragma_dir/hqm_master.sv \
"
set ::collage_ip_info::ip_input_language SystemVerilog
set ::collage_ip_info::ip_rtl_inc_dirs "$::env(WORKAREA)/src/rtl"

set ::collage_ip_info::ip_plugin_dir "" ; # Directories - space separated list - with tcl plugin files
set ::collage_ip_info::ip_plugin_dirs "" ;
set ::collage_ip_info::ip_ifc_def_hook "ip_create_ifc_instances" ; # Set this to procedure to add IP interfaces - defined below

######################################################################
# Procedure to create IP interfaces
######################################################################
proc ip_create_ifc_instances {} {

    ############################################
    #IOSF::DFX::SCAN::Reset
    ############################################
    set ifc_inst_name "scan_reset"

    create_interface_instance $ifc_inst_name \
        -type consumer \
        -interface "IOSF::DFX::SCAN::Reset" \
        -version "2.4_r1.4__v2.4_r1.4" \
        -associationformat "%s"

    set port_map    {}
    set open_params {}
    set open_ports  {}

    return
}

collage_add_ifc_def_files -files "\
    $::env(HQM_COLLAGE_INTF_DEF_PATH)/IOSF__DFX__SCAN/v2.4/coretools/iosf_dfx_scan_reset_interface.v2.4_r1.4.tcl \
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
