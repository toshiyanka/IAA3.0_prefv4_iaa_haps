# mode:cperl; cperl-indent-level 4; cperl-indent-parens-as-block t;# # vim: noai:ts=4 : sw=4 : filetype=perl
# vim: noai:ts=4 : sw=4 : filetype=perl
package ToolData;
use strict;
use warnings;
use File::Basename;
my $dirname = dirname(dirname(__FILE__));
$dirname = `/usr/intel/bin/realpath $dirname`;
chomp($dirname);

use IPToolDataExtras qw(import_files
                        get_version_from_path);  # technically not needed since it's used in the parent file.

######################################################################
# NOTE: Use these variables instead of $ENV when possible
# Try to use &get_env_var(VARIABLE_NAME) in hash string entries otherwise
# Also, please use variables instead of raw absolute paths.
# Add needed variables in this list from baselin_tools/GeneralVars.pm
######################################################################
use vars qw(%ToolConfig_ips
     %ToolConfig_tools
     $MODEL_ROOT
     $IP_MODELS
     $IP_RELEASES
     $RTL_PROJ_TOOLS
);

$ToolConfig_ips{hqm_rcfwl} = {
    PATH    => "$dirname",
    VERSION => &get_version_from_path($dirname),
    ENV     => {    },
    OTHER   => {
        IMPORT => [],
        LIBS => [
            "&get_tool_path()/cfg/ace/lib",
        ],
        SEARCH_PATHS   => [
            "&get_tool_path()",
            "&get_tool_path(ipconfig/ctech)",
            "&get_tool_path(ipconfig/ctech_exp)",
            "&get_tool_path()/subIP/Power_Gate_Control_Block",
            "&get_tool_path()/subIP/common/rcfwl_dfxsecure_plugin/dfxsecure_plugin_current",
#            "&get_tool_path()/subIP/IOSF_Sideband_Endpoint",
#            "&get_tool_path()/subIP/sbr_gpsb/ipgen_output/gpsb_fabric/gpsb_cnxde_hcc_base",
            "&get_tool_path()/subIP/common/rcfwl_globalclk/globalclk_current",
            "&get_tool_path()/src/rtl/widgets",
            "&get_tool_path()/target",
                
    ],
         SUB_SCOPES => [],
#        SUB_SCOPES => ["rcfwl_val",],
         SYSTEMINIT_PATH     => "&get_tool_path()/cfg/systeminit" ,
     DUT_CFG_PATH        => "&get_tool_path()/cfg/dut_cfg" ,
     TEST_PATTERNS => [
                "target/rcfwl",
                "trex_test", 
                "verif/tests/static_checks",],
},

        

};

$ToolConfig_ips{rcfwl_val} = {
        PATH    => "$dirname",
    VERSION => &get_version_from_path($dirname),
    OTHER   => {
                IMPORT => [],
        LIBS  => [ 
            "&get_tool_path()/cfg/ace/lib",
           ],
        SEARCH_PATHS => [
        ],
        SUB_SCOPES  => [
        ],
         SYSTEMINIT_PATH => "&get_tool_path()/cfg/systeminit",
     DUT_CFG_PATH => "&get_tool_path()/cfg/dut_cfg",
    },
         
};

$ToolConfig_ips{hqm_rcfwl}->{OTHER}->{lintra_waiver_dirs}  =  [ "tools/lint/waivers/cdc_wrapper/perm", 
                                                            "tools/lint/waivers/dft_reset_sync/perm", 
                                                            "tools/lint/waivers/ip_disable/perm",
                                                            "tools/lint/waivers/fuse_hip_glue/perm",                                                                                                                     
                                                                                                                            ];

$ToolConfig_ips{hqm_rcfwl}->{OTHER}->{lintra_waiver_files} =  [ "*_w.xml"];
#import_files("rcfwl",\%ToolConfig_ips);

1;

   


