package ToolData;
use Clone qw(clone);
## TEMPORARY BUILDMAN TOOL OVERRIDES
##   These tool versions have been patched to address reported build slowness.
##   These overrides MUST be removed when upgrading to the next buildman
##   release -- contact TFM with any questions
##$ToolConfig_tools{flowbee_buildman}{VERSION} = "master/2.00.00.beta20.p1";
##$ToolConfig_tools{flowbee_buildman}{SUB_TOOLS}{onecfg}{VERSION} = "master/2.00.00.beta19.p2";
## END TEMPORARY BUILDMAN TOOL OVERRIDES

#$ToolConfig_tools{interface_defs}->{VERSION} = 'v15ww16a';
$ToolConfig_tools{upf_config} = {
   VERSION => 'v18ww21e',
   PATH => "$RTL_PROJ_TOOLS/upf_config/sdg74/&get_tool_version()",
};

#$ToolConfig_tools{febe_sdg_configs}{SUB_TOOLS}{be_setup_milestone}{VERSION} = "SDG74_I74A0P08G1074P2_16WW33_HF8";

#$ToolConfig_tools{pcuiogen}->{VERSION} = '16.08.01';
#$ToolConfig_tools{jem}{VERSION} = "16.2.0_64";
#$ToolConfig_tools{collage}->{VERSION} = '3.17';
#$ToolConfig_tools{chassis}->{VERSION} = '3.17';
$ToolConfig_tools{collage}->{PATH} = "/p/com/eda/intel/collage/&get_tool_version()";
$ToolConfig_tools{collage}->{ENV}->{COLLAGE_CHASSIS_BOOTSTRAP} = "/p/com/eda/intel/collage/&get_tool_version(collage)/utils/chassis_bootstrap.tcl",

#$ToolConfig_tools{chassis}->{PATH} = "&get_tool_path(collage)";
#$ToolConfig_tools{vlog_utils}->{VERSION} = '16.44.01';
##$ToolConfig_tools{collage_intf_def} = {
#   VERSION  => "2.6.2",
#   PATH     => "/p/com/eda/intel/collage_intf_def/&get_tool_version()",
 #  ENV      => {
#                COLLAGE_INTF_DEF => "&get_tool_path()",
 #               },
#};

#$ToolConfig_tools{collage}->{SUB_TOOLS}->{collage_intf_def} = "&get_tool('collage_intf_def')";
#################################################################################################################
## lintra overrides
##
##$ToolConfig_tools{lintra}->{VERSION} = '14.4p31_shOpt64';
##$ToolConfig_tools{lintra}->{ENV}->{LINTRARULES} = '/p/hdk/rtl/cad/x86-64_linux26/intel/lintra-rules/1.07.01.14_4';
##$ToolConfig_tools{lintra}->{OTHER}->{configFile} = [
##    "&get_tool_env_var(lintra, LINTRARULES)/cfg/LintraSoCConfig_WF.xml",
####    "&get_tool_path('lintra_utils')/config/IPDS_LintraVGroupsConfigcfg.cfg",
 ##   "&get_tool_path('lintra_utils')/config/tmp_off.cfg",
##    ];
##$ToolConfig_tools{lintra_utils}->{VERSION} = '15.03.12';
##
#################################################################################################################

#Hacks to get FLG_lintra and quick_syn to work
#$ToolConfig_tools{lintra}->{OTHER}->{FLG_liraStdArgs} = " +define+LINT_ON+SIM +define+SVA_OFF +define+NO_PWR_PINS -dv -mdr or -nbm"  ;

# temporary saola overrides- until tbtools 15ww04a is used
#$ToolConfig_ips{saola}->{PATH} = "/p/com/eda/intel/saola/v20140417p6";
#push @{$ToolConfig_ips{saola}->{OTHER}->{SEARCH_PATHS}}, "&get_tool_path(ipconfig/tfm_vi_tb)/results/sles10_x86_64_gcc4.2.2/deb/rel/ace";
#$ToolConfig_ips{tfm_vi_tb}->{OTHER}->{'ELABARGS'} = "-LDFLAGS \"-L&get_env_var(SAOLA_HOME)/libs/Linux_x86_64 -L&get_env_var(TFM_VI_REL_ROOT)/lib -Wl,-rpath=&get_env_var(SAOLA_HOME)/libs/Linux_x86_64:&get_env_var(TFM_VI_REL_ROOT)/lib -lsla -L&get_env_var(SYSTEMC_HOME)/libs/sles10_x86_64_gcc&get_tool_version(gcc)/deb\"";


$ToolConfig_tools{flowbee}{OTHER}{default_dut} = "globalclk";
$ToolConfig_tools{runtools}{OTHER}{default_dut} = "globalclk";


#$ToolConfig_tools{collage}->{SUB_TOOLS}->{collage_utils}->{VERSION}='15.03.05';
#$ToolConfig_tools{collage_utils}->{VERSION}='15.03.05';

$ToolConfig_tools{pciuiogen}->{VERSION}='16.08.01';
#$ToolConfig_tools{zircon}->{VERSION}='2.08.13';


# Ace variables required for rtldebug only, update with appropriate dut name
#if (defined $ENV{RTLDEBUG}) {
#  $ToolConfig_tools{ace}{VERSION} = "2.03.02";
#  $ToolConfig_tools{ace}{ENV}{ACE_PROJECT} = "globalclk";
#}
$general_vars{ARCH_SLES}             = 'sles11';
$general_vars{ARCH_SLES_HW}          = 'sles11';
#$ToolConfig_tools{vlog_utils}->{VERSION} = 'v15ww20c';
$ToolConfig_tools{boost}{PATH} = "$RTL_CAD_ROOT/boost/1.58.0";
$ToolConfig_tools{boost}{VERSION} = "1.58.0";
#$ToolConfig_tools{emubuild}->{VERSION} = '2.2.5';





#$ToolConfig_tools{vcs}->{VERSION} = 'J-2014.12-SP3-6-T0129';
#$ToolConfig_tools{verdi}->{VERSION} = 'J-2014.12-SP3-6-B-1';
#$ToolConfig_tools{febe3}{VERSION} = "3.0.08.P3";
#$ToolConfig_tools{febe3}->{ENV}->{FE2BE_ROOT} = "/nfs/sc/disks/sdg74_0877/wprepask/dts_cds_fedv-febe.wpr.3.0.08.P3_beta";
#$ToolConfig_tools{febe3}->{PATH} = "/nfs/sc/disks/sdg74_0877/wprepask/dts_cds_fedv-febe.wpr.3.0.08.P3_beta"; 
#$ToolConfig_tools{febe3}->{VERSION} = "3.0.08.P5";
$ToolConfig_tools{febe_sdg_configs}{OTHER}{enable_2_stage_FLG} = '1';
$ToolConfig_tools{febe_sdg_configs}{OTHER}{ip_is_multi_top} = '1';
#$ToolConfig_tools{verdi}{VERSION} = "L-2016.06-SP1-1-T1102";
#$ToolConfig_tools{vcs}{VERSION} = "L-2016.06-SP1-1-T1020";
#$ToolConfig_tools{vcs}{OTHER}{TSETUP_IP_VERSIONS} = {$ToolConfig_tools{vcs}{VERSION} => "$RTL_CAD_ROOT/synopsys/vcsmx/$ToolConfig_tools{vcs}{VERSION}"};
#$ToolConfig_tools{vcs}{ENV}{SNPS_SIM_BC_CONFIG_FILE} = "$MODEL_ROOT/cfg/synopsys_bc.setup";
#$ToolConfig_tools{vcsmx} = clone($ToolConfig_tools{vcs});

$ToolConfig_tools{visait}->{VERSION} = "4.2.7";
$ToolConfig_tools{visait}->{OTHER}->{'VISA_MODULE_XML_PATH'} = "&get_tool_path()/etc";
#$ToolConfig_tools{coretools}->{VERSION} = 'K-2015.06-SP7';
#Auto-rm $ToolConfig_tools{espf} = {
#Auto-rm     VERSION => 'eng.2016.ww48a',
#Auto-rm     PATH => "/p/hdk/cad/spf/&get_tool_version()",
#Auto-rm };
#Auto-rm $ToolConfig_tools{espfmodel} = {
#Auto-rm     VERSION => 'eng.2016.ww27a',
#Auto-rm     PATH => "/p/hdk/cad/spf/&get_tool_version()",
#Auto-rm };
#$ToolConfig_tools{chassis_dft_val_global} = {
#    VERSION => 'v17ww01c',
#    PATH => "$ENV{IP_RELEASES}/chassis_dft_val_global/&get_tool_version()",
#};
# version 16.47.01_buildman overloads filer/ causes environment slowness
#$ToolConfig_tools{stage_hip_listgen}{PATH} = "$RTL_PROJ_TOOLS/srvr10nm_flows/16.45.01_buildman";

#FEBE master 3.2.06 -narunsel
#$ToolConfig_tools{febe3}->{VERSION} = "3.2.06",
#$ToolConfig_tools{febe3}->{OTHER}->{update_table_pkg} = "$RTL_PROJ_DBIN/febe_utils/febe_sdg_configs_temp/UpdateFEBETable.pm" ;
#$ToolConfig_tools{febe3}->{OTHER}->{project_settings} = ["$RTL_PROJ_DBIN/febe_utils/febe_sdg_configs_temp/dc_config.cfg", "$MODEL_ROOT/tools/febe/inputs/common/dc_config.cfg",];
#$ToolConfig_tools{"stage_hip_listgen"}->{OTHER}->{modules} = "$RTL_PROJ_DBIN/febe_utils/febe_sdg_configs_temp/hip_listgen.pm";
#$ToolConfig_tools{spyglass_cdc}->{VERSION} = "1.00.08";
#$ToolConfig_tools{spyglass_cdc}->{SUB_TOOLS}->{cdclint}->{VERSION} = "17.25.1";
#$ToolConfig_tools{spyglass_cdc}->{SUB_TOOLS}->{spyglass}->{VERSION} = "L2016.06-SP2_Jan23";
$ToolConfig_tools{spyglass_cdc}->{SUB_TOOLS}->{spyglass}->{ENV}->{SPYGLASS_LD_PRELOAD} = "&get_tool_path()/SPYGLASS_HOME/lib/libsgjemalloc-Linux4.so";

######### FEBE Wave 3 enablement
$ToolConfig_tools{febe_sdg_configs}{SUB_TOOLS}{be_setup_milestone}{VERSION} = "SDG74_TFM3_SPRSPXCCA0P10_74P13_DK154P7";
$ToolConfig_tools{febe_sdg_configs}{OTHER}{enable_2_stage_FLG} = '1';
$ToolConfig_tools{febe_sdg_configs}{OTHER}{use_2stage_FLG_for_DC} = '1';



#####################################################################
#BEGIN VCS 2017 Tooling Migration
######################################################################
$ToolConfig_tools{verdi}{VERSION} = 'N-2017.12';
$ToolConfig_tools{vcs}{VERSION} = 'N-2017.12';
##$ToolConfig_tools{vcs}{ENV}{SNPS_SIM_BC_CONFIG_FILE} = "$ENV{MODEL_ROOT}/cfg/synopsys_bc.setup"; ##if needed
$ToolConfig_tools{vcs}{OTHER}{TSETUP_IP_VERSIONS} = {$ToolConfig_tools{vcs}{VERSION} => "$RTL_CAD_ROOT/synopsys/vcsmx/$ToolConfig_tools{vcs}{VERSION}"};
$ToolConfig_tools{vcsmx} = clone($ToolConfig_tools{vcs});
######################################################################
#END VCS 2017 Tooling Migration
######################################################################

#########################################
#SGLINT
#########################################
push @{$ToolConfig_tools{flowbee_buildman}->{OTHER}->{modules}}, "&get_tool_var(stage_sglint_createlib,modules)"; ## only until BLT makes sglint a default stage
$ToolConfig_tools{spyglass_lint}->{ENV}->{SGLINT_MODEL_ROOT} = "$ENV{MODEL_ROOT}";   ### needed by HDK compile project file
$ToolConfig_tools{spyglass_lint}->{VERSION} = "1.05.08.18ww11";  ## only until BLT has required latest versions
$ToolConfig_tools{spyglass_lint}->{SUB_TOOLS}->{spyglass}->{VERSION} = "M2017.03-SP2-5";

#adding for VCLP initial deployment ## remove once BLT as required changes as default
 push @{$ToolConfig_tools{flowbee_buildman}->{OTHER}->{modules}}, "&get_tool_var(stage_vclp_createlib,modules)";


1;
