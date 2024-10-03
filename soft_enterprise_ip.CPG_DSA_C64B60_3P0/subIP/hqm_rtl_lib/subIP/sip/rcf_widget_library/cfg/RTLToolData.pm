package ToolData;
use vars qw($MODEL_ROOT);
use Clone qw(clone);

# Buildman override for multi-gen IP repos only
# Automatically populate "-1c -dut <dutName> -1c-" value with
# "-dut <dutName>" value. Prevents multiple duts from running
# under a single buildman command; multiple buildman commands
# can be executed in parallel if multi-dut flags enabled
$ToolConfig_tools{buildman}{OTHER}{single_dut} = 1; 
$ToolConfig_tools{collage}->{PATH} = "/p/com/eda/intel/collage/&get_tool_version()";
$ToolConfig_tools{collage}->{ENV}->{COLLAGE_CHASSIS_BOOTSTRAP} = "/p/com/eda/intel/collage/&get_tool_version(collage)/utils/chassis_bootstrap.tcl",
$ToolConfig_tools{collage}->{SUB_TOOLS}->{collage_intf_def} = "&get_tool('collage_intf_def')";

$ToolConfig_tools{upf_config} = {
   VERSION => 'v18ww21e',
   PATH => "$RTL_PROJ_TOOLS/upf_config/sdg74/&get_tool_version()",
};

$ToolConfig_tools{febe_sdg_configs}->{OTHER}->{enable_2_stage_FLG} = '1';
$ToolConfig_tools{febe_sdg_configs}->{OTHER}->{use_2stage_FLG_for_DC} = '1';
$ToolConfig_tools{febe_sdg_configs}->{OTHER}->{ip_is_multi_top} = '1';
#$ToolConfig_tools{febe_sdg_configs}{SUB_TOOLS}{be_setup_milestone}{VERSION} = "SPRSPXCCA0P05";
$ToolConfig_tools{febe_sdg_configs}{SUB_TOOLS}{be_setup_milestone}{VERSION} = "SDG74_TFM3_SPRSPXCCA0P10_74P13_P10DK154P0";
$ToolConfig_tools{febe3}{ENV}{MALLOC_CHECK_} = 0;

$ToolConfig_tools{flowbee}->{OTHER}->{default_dut} = "rcfwl";
$ToolConfig_tools{runtools}->{OTHER}->{default_dut} = "rcfwl";

#$ToolConfig_tools{questaCDC}{ENV}{CTECH_CDC_LIB_NAME} = "CTECH_p1274_ec0_ln_rtl_lib";

######################################################################
#BEGIN gczajkow GCC472 SLES11 VCS2016 VERDI2016 Tooling Migration
######################################################################
$ToolConfig_tools{vcs}{ENV}{SNPS_SIM_BC_CONFIG_FILE} = "$ENV{MODEL_ROOT}/cfg/synopsys_bc.setup";
#$ToolConfig_tools{vcs}->{VERSION} = 'N-2017.12';
#$ToolConfig_tools{verdi}->{VERSION} = 'N-2017.12';
#$ToolConfig_tools{vcs}{OTHER}{TSETUP_IP_VERSIONS} = {"N-2017.12" => "$RTL_CAD_ROOT/synopsys/vcsmx/N-2017.12"};
######################################################################
#END gczajkow GCC472 SLES11 VCS2016 VERDI2016 Tooling Migration
######################################################################

######################################################################
#BEGIN gczajkow Valgrind, GDB, OVM Debug
######################################################################
$ToolConfig_tools{acerun}{OTHER}{NO_DOUBLE_LOGGING} = 1;
$ToolConfig_tools{runtools}{OTHER}{ace_root_dir} = "aceroot";
$ToolConfig_tools{runtools}{OTHER}{additional_error_parse_script} = "&get_tool_path(sdg_runtools)/additional_error_parse_script.pl";
$ToolConfig_tools{runtools}{OTHER}{system_fails_filenames} = "&get_tool_path(sdg_runtools)/system_fails:&get_tool_path(runtools)/system_fails";
$ToolConfig_tools{runtools}{ENV}{ACERUNRUN_TIMEOUT} = (defined $ENV{ACERUNRUN_TIMEOUT}) ? $ENV{ACERUNRUN_TIMEOUT} : 3600;
$ToolConfig_tools{runtools}{ENV}{MAX_HANGS} = 1;
######################################################################
#END gczajkow Valgrind, GDB, OVM Debug
######################################################################

$ToolConfig_tools{visait}->{VERSION} = '4.2.7';
$ToolConfig_tools{visaflow}->{VERSION} = '4.3.5';
$ToolConfig_tools{visait}->{OTHER}->{'hqm_VISA_MODULE_XML_PATH'} = "&get_tool_path()/etc";
#$ToolConfig_tools{coretools}->{VERSION} = 'K-2015.06-SP7';

######################################################################
#VCLP
######################################################################
push @{$ToolConfig_tools{flowbee_buildman}->{OTHER}->{modules}}, "&get_tool_var(stage_vclp_createlib,modules)";

######################################################################
#SGLINT
######################################################################
push @{$ToolConfig_tools{flowbee_buildman}->{OTHER}->{modules}}, "&get_tool_var(stage_sglint_createlib,modules)"; ## only until BLT makes sglint a default stage
$ToolConfig_tools{spyglass_lint}->{ENV}->{SGLINT_MODEL_ROOT} = "$ENV{MODEL_ROOT}"; ### needed by HDK compile project file

$ToolConfig_tools{spyglass_lint}->{VERSION} = "1.05.08.18ww11";## only until BLT has required latest versions
$ToolConfig_tools{spyglass_lint}->{SUB_TOOLS}->{spyglass}->{VERSION} = "M2017.03-SP2-5";
 
1;
