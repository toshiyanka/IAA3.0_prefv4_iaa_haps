# -*-mode: cperl; cperl-indent-level: 4; cperl-indent-parens-as-block: t; -*- # # vim: noai:ts=4 : sw=4 : filetype=perl
# vim: noai:ts=4 : sw=4 : filetype=perl

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
        IMPORT  => [ #"subIP/ip74xdiv9or12_17ww23a/cfg/ip74xdiv9or12_IPToolData.pm" ,
	             "cfg/globalclk_IPToolData.pm"
	                  ],
        UDF_MAP => {
            default => {
                'UDF' => ["&get_tool_path(ipconfig/ctech)/ace/CTECH_hdl.udf",
			  "&get_tool_path(ipconfig/ctech_exp)/ace/CTECH_EXP_hdl.udf",
			  "$MODEL_ROOT/cfg/globalclk.udf",],
                'SCOPE' => 'rcfwl_globalclk',
            },
        },
    },
    SUB_TOOLS =>  \%ToolConfig_ips,
};

IPToolDataExtras::import_files("ipconfig",\%ToolConfig_tools);

push (@{$ToolConfig_ips{rcfwl_globalclk}{OTHER}{SUB_SCOPES}}, (
    "&get_tool_var(ipconfig/tfm_vi_tb, SUB_SCOPES)",
    "baseline_tools",
    "ip74xdiv9or12",
));


$ToolConfig_ips{rcfwl_globalclk}{ENV} = {

    ACE_PROJECT_HOME => "&get_tool_path()",
    COLLAGE_NEW_TB => "1",
    CTECH_VERSION => "&get_tool_version(ipconfig/ctech)",
    CTECH_LIB_NAME   => "CTECH_v_rtl_lib", ### afcebuls -- temporary WA for chassis enabling sublibs
#    CTECH_LIB_PATH   => "&get_tool_path(ipconfig/ctech)",
      CTECH_EXP_VERSION => "&get_tool_version(ipconfig/ctech_exp)",
      CTECH_EXP_LIB_NAME => "CTECH_EXP_v_rtl_lib",
    SDG_CTECH_LIB_NAME => "SDG_CTECH_v_rtl_lib",
#    GLOBAL_CTECH_VER => "&get_tool_path(ipconfig/ctech)",
    ACE_TOPSCOPE_SUBLIBDEF_OVR => "1",
    DISABLE_VCS_STAGE_CACHING => "1",
};
push (@{$ToolConfig_ips{rcfwl_globalclk}{OTHER}{SEARCH_PATHS}}, (
    "&get_tool_path(ipconfig/ctech)",
    "&get_tool_path(ipconfig/sdg_ctech)",
    "&get_tool_path(ipconfig/ctech_exp)",
    ));

my $ctechexppath = "/p/hdk/cad/ctech/ctech_exp_c3v19ww04f_hdk153_sdg";
 # CTECH expansion lib
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
push (@{$ToolData::ToolConfig_ips{rcfwl_globalclk}{OTHER}{SUB_SCOPES}}, 'CTECH');
$ToolConfig_ips{CTECH}{OTHER}{SEARCH_PATHS} =  ["&get_tool_path()"]; # note the all-caps version. This is needed until defined in converged ctech release of cfg/CTECH_IPToolData.pm

$ToolConfig_ips{sdg_ctech} = {
    PATH => "/p/hdk/pu_tu/prd/sdg_ctech/&get_tool_version()",
    VERSION => "17.02.003",
    OTHER => {
        SEARCH_PATHS => [
             "&get_tool_path()",
             "&get_tool_path()/ace/",
        ],
    },
};
# $ToolConfig_ips{ip74xdiv9or12} = {
   
#     PATH => "&get_tool_path(ipconfig/rcfwl_globalclk)/subIP/ip74xdiv9or12/&get_tool_version()",
 #    VERSION => "ip74xdiv9or12_current",
#    ENV => {
#        ARRAY_MACRO => "&get_tool_path()",
#    },

#     OTHER => {
#         INC_PATH => "&get_tool_path()",
#         SEARCH_PATHS   => [
#             "&get_tool_path()",
# 	    "&get_tool_path()/cfg",
#            ],
#     },
# };

$ToolConfig_ips{ipglbdrvby9or12pp60} = {
    PATH => "/nfs/site/disks/sdg74.noble-linktree.1/proj_arch/noa/ipglbdrvby9or12pp60/ip_handoff_noa/",
    VERSION => "SDGW3IPA0P05RTL2IFC2V2",
     ENV     => {
                 ipglbdrvby9or12pp60_HIP_ROOT => "&get_tool_path()",
           },
};

IPToolDataExtras::import_files("ctech_exp",\%ToolConfig_ips);
push (@{$ToolData::ToolConfig_ips{rcfwl_globalclk}{OTHER}{SUB_SCOPES}}, 'CTECH_EXP');
#$ToolConfig_ips{CTECH_EXP}{OTHER}{SEARCH_PATHS} =  ["&get_tool_path()"];
