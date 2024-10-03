package ToolData;
use strict;
use warnings;

######################################################################
# NOTE: Use these variables instead of $ENV when possible
# Try to use &get_env_var(VARIABLE_NAME) in hash string entries otherwise
# Also, please use variables instead of raw absolute paths.
# Add needed variables in this list from baselin_tools/GeneralVars.pm
######################################################################
use vars
    qw(%ToolConfig_ips
       %ToolConfig_tools
       $MODEL_ROOT
       $IP_MODELS
       $IP_RELEASES
       $RTL_PROJ_TOOLS
    );


##Use BEGIN block here or this entry won't be resolved before a "use" of the lib
BEGIN {
$ToolConfig_tools{iptooldataextras} =
{
        VERSION => "16.37.02",
        PATH    => "$ENV{RTL_PROJ_TOOLS}/IPToolDataExtras/shdk74/16.37.02",
};
}

use lib $ToolConfig_tools{iptooldataextras}{PATH};
use IPToolDataExtras qw(import_files get_version_from_path do_with_warn);


$ToolConfig_tools{ipconfig} = {
    PATH => "$MODEL_ROOT",
    VERSION => 'n/a',
    OTHER => {
        ACERC => {
                 ENABLE_AUTO_POP_DEP_LIBS => "0",
                 ENABLE_RECURSIVE_DEP_LIBS => "0",
        },
        IMPORT  => ["cfg/rcfwl_IPToolData.pm",],
        UDF_MAP => { 
            default => {
                         'UDF' => [#"&get_tool_path(ipconfig/ctech)/ace/CTECH_hdl.udf",
                                   #"&get_tool_path(ipconfig/ctech_exp)/ace/CTECH_EXP_hdl.udf",
                                   #"&get_tool_path(ipconfig/sdg_ctech)/ace/SDG_CTECH_hdl.udf",
                                   "$MODEL_ROOT/cfg/rcfwl.udf",],
                         'SCOPE' => 'hqm_rcfwl',
            },
        },
    },
    SUB_TOOLS => \%ToolConfig_ips,
};

IPToolDataExtras::import_files("ipconfig",\%ToolConfig_tools);

$ToolConfig_ips{hqm_rcfwl}{ENV} = {
        ACE_PROJECT_HOME => "&get_tool_path()",
        COLLAGE_NEW_TB   => "1",
        COLLAGE_IP_REPORTS => "&get_tool_path()/target/collage/ip_kits",
        CTECH_VERSION => "&get_tool_version(ipconfig/ctech)",
        CTECH_LIB_NAME   => "CTECH_v_rtl_lib",
        CTECH_CDC_LIB_NAME  => "CTECH_v_rtl_lib",
        CTECH_EXP_VERSION => "&get_tool_version(ipconfig/ctech_exp)",
        CTECH_EXP_LIB_NAME => "CTECH_EXP_v_rtl_lib",
        CTECH_EXP_STDCELL_VERSION => "&get_tool_var(ipconfig/ctech_exp, CTECH_EXP_STDCELL_VERSION)",
        GLOBAL_CTECH_VER => "&get_tool_path(ipconfig/ctech)",
        STD_ROOT_EC0     =>  "/p/hdk/cad/stdcells/ec0/15ww46.5_ec0_f.1.cnl.sdg.mig",
        DISABLE_VCS_STAGE_CACHING => "1",
        ACE_TOPSCOPE_SUBLIBDEF_OVR => "1",
        VISAROOT => "&get_tool_path(visait)",
        VISA_RTL => "&get_tool_path(visait)/rtl",
};

push (@{$ToolConfig_ips{hqm_rcfwl}{OTHER}{SEARCH_PATHS}}, (
    "&get_tool_path(ipconfig/ctech)",
    "&get_tool_path(ipconfig/sdg_ctech)",
    "&get_tool_path(ipconfig/ctech_exp)",
    "&get_tool_path(spyglass_cdc/spyglass)",
    ));

## nkharwad: Following needs for Collage file and Trex respectively
$ToolConfig_ips{hqm_rcfwl}{ENV}{PM10NM_ROOT}           =  "&get_tool_path()";

push (@{$ToolConfig_ips{hqm_rcfwl}{OTHER}{SUB_SCOPES}}, (
         "&get_tool_var(ipconfig/tfm_vi_tb, SUB_SCOPES)",
         "baseline_tools",
#         "&get_tool_var(ipconfig/hqm_rcfwl_val, SUB_SCOPES)",
#         "IOSF_SVC",
#         "projcfg",      
#         "mem_decoder",
#         "addr_utils",
#         "init_utils",
#         "fsdb_utils", 
#         "iosfsb_connector",
#         "iosfsb_mnode",
));

my $ctechpath = "/p/hdk/cad/ctech/c3v18ww45a_hdk153";
$ToolConfig_ips{ctech} = {
    PATH => $ctechpath,
    VERSION => &get_version_from_path($ctechpath),
    OTHER => {
        IMPORT => ["cfg/CTECH_IPToolData.pm",],
        SEARCH_PATHS => [
            "&get_tool_path()",
            "&get_tool_path()/ace/",
        ],
        lintra_waiver_dirs => [ "tools/lintra/", ],
        lintra_waiver_files => [ "common_lintra.waiv", ],
    },
};

IPToolDataExtras::import_files("ctech",\%ToolConfig_ips);
push (@{$ToolData::ToolConfig_ips{hqm_rcfwl}{OTHER}{SUB_SCOPES}}, 'CTECH');
$ToolConfig_ips{CTECH}{OTHER}{SEARCH_PATHS} =  ["&get_tool_path()"]; # note the all-caps version. This is needed until defined in converged ctech release of cfg/CTECH_IPToolData.pm

# CTECH expansion lib
my $ctechexppath = "/p/hdk/cad/ctech/ctech_exp_c3v19ww04f_hdk153_sdg";
$ToolConfig_ips{ctech_exp} = {
    PATH => $ctechexppath,
    VERSION => &get_version_from_path($ctechexppath),
    OTHER => {
        IMPORT => ["cfg/CTECH_EXP_IPToolData.pm", ],
        SEARCH_PATHS => [
            "&get_tool_path()",
            "&get_tool_path()/ace/",
        ],
        lintra_waiver_dirs => [ "tools/lintra/", ],
        lintra_waiver_files => [ "common_lintra.waiv", ],
    },
};
IPToolDataExtras::import_files("ctech_exp",\%ToolConfig_ips);
push (@{$ToolData::ToolConfig_ips{hqm_rcfwl}{OTHER}{SUB_SCOPES}}, 'CTECH_EXP');
#$ToolConfig_ips{CTECH_EXP}{OTHER}{SEARCH_PATHS} =  ["&get_tool_path()"];



1;
