# mode:cperl; cperl-indent-level 4; cperl-indent-parens-as-block t;# # vim: noai:ts=4 : sw=4 : filetype=perl
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
use vars qw(
     %ToolConfig_ips
     %ToolConfig_tools
     $MODEL_ROOT
     $IP_MODELS
     $IP_RELEASES
     $RTL_PROJ_TOOLS
);

$ToolConfig_ips{ctech} = {
    PATH => "/p/hdk/cad/ctech/&get_tool_version()",
    VERSION => "v15ww43c",
    OTHER => {
        SEARCH_PATHS => [
             "&get_tool_path()",
             "&get_tool_path()/ace",
        ],
    },
};

$ToolConfig_ips{ctech_exp} = {
    PATH => "/p/hdk/cad/ctech/&get_tool_version()",
    VERSION => "ctech_exp_sdg_v15ww45b",
    OTHER => {
        SEARCH_PATHS => [
             "&get_tool_path()",
             "&get_tool_path()/ace",
        ],
    },
};

$ToolConfig_ips{sdg_ctech} = {
    PATH => "/p/hdk/pu_tu/prd/sdg_ctech/&get_tool_version()",
    VERSION => "15.02.22",
    OTHER => {
        SEARCH_PATHS => [
            "&get_tool_path()",
            "&get_tool_path()/ace/",
        ],
    },
};

$ToolConfig_ips{globalclk} = {
    PATH => "$IP_RELEASES/globalclk/&get_tool_version()",
    VERSION => "globalclk-srvr10nm-15ww50d_0p5",
    OTHER   => {
        SEARCH_PATHS   => [
            "&get_tool_path()",
            "&get_tool_path(ipconfig/ctech)",
            "&get_tool_path(ipconfig/ctech_exp)",
            "&get_tool_path(ipconfig/sdg_ctech)",
        ],
    },
};

$ToolConfig_ips{ovm} = {
    PATH    => "$RTL_CAD_ROOT/ovm/ovm/&get_tool_version()",
    VERSION => "2.1.2_2_ml",
    ENV     => {
                 OVM_HOME      => "&get_tool_path()",
                 OVM_INCLUDES  => "&get_tool_path()/src",
               },
    OTHER   => {
                 SEARCH_PATHS   => [
                                     "&get_tool_path()",
                                   ],
               },
};

$ToolConfig_ips{saola} = {
    PATH    => "$RTL_CAD_ROOT/intel/saola/&get_tool_version()",
    VERSION => "v20150417p5",
    ENV     => {
                 saola_ROOT => "&get_tool_path()",
                 SAOLA_HOME => "&get_tool_path()",
                 SAOLA_INCLUDES => "&get_tool_path()/verilog",
               },
    OTHER   => {
                 SEARCH_PATHS   => [
                                     "&get_tool_path()",
                                   ],
                 SRC_PATHS      => "&get_tool_path()/cpp",
               },
};

$ToolConfig_tools{ipconfig} = {
    VERSION => 'n/a',
    OTHER => {
        UDF_MAP => {

           'AW' => {
               'UDF' => [
                    "&get_tool_path(ipconfig/ctech)/ace/CTECH_hdl.udf",
                    "&get_tool_path(ipconfig/ctech_exp)/ace/CTECH_EXP_hdl.udf",
                    "&get_tool_path(ipconfig/sdg_ctech)/ace/SDG_CTECH_hdl.udf",
                    "$MODEL_ROOT/cfg/AW.udf",
               ],
               'SCOPE' => 'AW',
           },
        },
    },
    SUB_TOOLS => \%ToolConfig_ips,
};

$ToolConfig_ips{AW} = {
    PATH  => "$MODEL_ROOT",
    ENV   => {
        CTECH_LIB_NAME             => "CTECH_v_rtl_lib",
        CTECH_EXP_LIB_NAME         => "CTECH_EXP_v_rtl_lib",
        SDG_CTECH_LIB_NAME         => "SDG_CTECH_v_rtl_lib",
        GLOBAL_CTECH_VER           => "&get_tool_path(ipconfig/ctech)",
        ACE_TOPSCOPE_SUBLIBDEF_OVR => "1",
    },
    VERSION => "",
    OTHER   => {
        SEARCH_PATHS => [
            "&get_tool_path()",
            "&get_tool_path()/cfg",
            "&get_tool_path()/src/rtl",
            "&get_tool_path(ipconfig/ctech)",
            "&get_tool_path(ipconfig/ctech_exp)",
            "&get_tool_path(ipconfig/sdg_ctech)",
        ],
        SUB_SCOPES => [
            "baseline_tools",
            "ovm",
            "saola",
            "globalclk",
            "hqm_array_macro_module",
            "tfm_array_macro_module",
            "hqm_ssa_macro_module",
        ],
        lintra_waiver_dirs => [
            "&get_tool_path(ipconfig/ctech)/tools/lintra",
        ],
        lintra_waiver_files => [
            "common_lintra.waiv",
        ],
    },
};

$ToolConfig_ips{legacy_lib} = {
    PATH => "$IP_MODELS/legacy_library/&get_tool_version()",
    VERSION => "v14ww39a",
    ENV => {
        LEGACY_LIB => "&get_tool_path()",
    },
    OTHER => {
        INC_PATH => "&get_tool_path()/source",
    },
};

$ToolConfig_ips{hqm_array_macro_module} = {
    PATH  => "${MODEL_ROOT}/../../hip/hqm_array_macro_module",
    VERSION => "",
    ENV => {
        ACE_PROJECT_HOME           => "&get_tool_path()",
        CTECH_LIB_NAME             => "CTECH_v_rtl_lib",
        ACE_TOPSCOPE_SUBLIBDEF_OVR => "1",
        MODEL_SCOPE                => "hqm_array_macro_module",
    },
    OTHER => {
        SEARCH_PATHS => [
            "&get_tool_path()",
            "&get_tool_path()/cfg",
            "&get_tool_path(ipconfig/ctech)",
        ],
    },
};

$ToolConfig_ips{tfm_array_macro_module} = {
    PATH  => "${MODEL_ROOT}/../../hip/tfm_array_macro_module",
    VERSION => "",
    ENV => {
        ACE_PROJECT_HOME           => "&get_tool_path()",
        CTECH_LIB_NAME             => "CTECH_v_rtl_lib",
        ACE_TOPSCOPE_SUBLIBDEF_OVR => "1",
        MODEL_SCOPE                => "tfm_array_macro_module",
    },
    OTHER => {
        SEARCH_PATHS => [
            "&get_tool_path()",
            "&get_tool_path()/cfg",
            "&get_tool_path(ipconfig/ctech)",
        ],
    },
};

$ToolConfig_ips{hqm_ssa_macro_module} = {
    PATH  => "${MODEL_ROOT}/../../hip/hqm_ssa_macro_module",
    VERSION => "",
    ENV => {
        ACE_PROJECT_HOME           => "&get_tool_path()",
        CTECH_LIB_NAME             => "CTECH_v_rtl_lib",
        ACE_TOPSCOPE_SUBLIBDEF_OVR => "1",
        MODEL_SCOPE                => "hqm_ssa_macro_module",
    },
    OTHER => {
        SEARCH_PATHS => [
            "&get_tool_path()",
            "&get_tool_path()/cfg",
            "&get_tool_path(ipconfig/ctech)",
        ],
    },
};

