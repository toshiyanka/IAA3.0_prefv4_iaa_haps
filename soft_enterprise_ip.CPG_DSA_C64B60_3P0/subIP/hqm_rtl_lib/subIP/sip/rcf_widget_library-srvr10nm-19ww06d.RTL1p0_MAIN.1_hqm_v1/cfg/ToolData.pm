package ToolData;

use strict;
use warnings;

use Exporter ();
our @ISA    = qw(Exporter);
our @EXPORT = qw(
    %ToolConfig_int
    %general_vars
    %ToolConfig_tools
    %ToolConfig_ips
);
use vars qw( %onecfg );

######################################################################
#
# ToolConfig_tools hash stores data about tools need by the RTL
# simulation environment.
#
# If a tool version changes, please change the corresponding entry in
# this file.
#
#    **** All tool and subtool names must be lowercase. ****
#
######################################################################
our %ToolConfig_tools = ();
our %ToolConfig_int = ();
our %ToolConfig_ips = ();

######################################################################
#
# Baseline Tools
# GeneralVars contains common variable settings and general_vars setup
# BaselineToolData contains common tool settings
#
# IMPORTANT: PLEASE READ:
# https://securewiki.ith.intel.com/display/P17X/10nmBuildFlowReleases
# CAREFULLY BEFORE UPDATING THIS.
#
# Failure to do so may result in build failures.
#
######################################################################
$ToolConfig_tools{baseline_tools} = {
    VERSION => "19.05.01_w3",
    # TFM PIPELINE OVERRIDE !!!! DO NOT TOUCH !!!!!
    PATH    =>$ENV{BASELINE_TOOLS_PATH_OVERRIDE} || "$ENV{RTL_PROJ_TOOLS}/baseline_tools/$ENV{CFG_PROJECT}/&get_tool_version()",
};

$ToolConfig_tools{iptooldataextras} = {
     VERSION => "16.37.02",
     PATH    => "/p/hdk/rtl/proj_tools/IPToolDataExtras/shdk74/16.37.02",

};
######################################################################
# VAL_TOOL_CONTOUR
######################################################################
$ToolConfig_tools{srvr_vc_contour} = {
     VERSION => "srvr_vc_contour-srvr10nm-19-vc04-0-19ww06a",
     PATH => "$ENV{IP_MODELS}/srvr_vc_contour/&get_tool_version()",
};

######################################################################
#
# OneConfig
# This must be on cfg/ToolData.pm for the bootstrapping to operate
#   correctly
#
######################################################################
$ToolConfig_tools{onecfg} = {
    VERSION => '1.02.07',
    PATH    => "$ENV{RTL_PROJ_TOOLS}/onecfg/master/&get_tool_version()",
    OTHER   => {
        IMPORTS => [
            "&get_tool_path(baseline_tools)/GeneralVars.pm",
            "&get_tool_path(baseline_tools)/BaselineToolData.pm",
            "&get_tool_path(srvr_vc_contour)/cfg/srvr_vc_contour_10nmwave3_IPToolData.pm",
        ],
    },
};

######################################################################
# Netbatch config
######################################################################
$ToolConfig_tools{netbatch_config} = {
   VERSION    => "latest_SLES11",
   PATH       => "$ENV{RTL_PROJ_TOOLS}/netbatch_config/$ENV{CFG_PROJECT}/&get_tool_version()",
};

######################################################################
#
# OneCfg 'facets'
#
# All 'facets' and their possible values must be declared here
# Specifically, all possible dut names must be enumberated
#
######################################################################
$onecfg{Facet} = {
  values => {
    dut => [qw(
        rcfwl
    )],
    project => [qw(
        srvr10nm
    )],
    lintra_mode => [qw(
        svtb
        lint
        openlatch
        flg
    )],
                    ## Start of changes needed for Spyglass CDC
                   spyglass_mode => [qw(
                           lint
                           lp
                           cdc
                   )],
                    ## End of Spyglass CDC changes
  }
};

######################################################################
#
# general_vars hash stores general tool data which doesn't belong to
# any specific tool. These variables are used internally in the
# flow and are not set in the Unix environment.
#
# Hash entries that are arrays need to be declared as:
#   $general_vars{<entry>} = [ <item1>,<item2> ];
#
######################################################################
our %general_vars = ();

$general_vars{tooldatas} = [
    qw(
        RTLToolData.pm
        IPToolData.pm
        GkToolData.pm
      ),
];

## Netbatch Updates
require "/p/hdk/rtl/proj_tools/netbatch_config/shdk74/$ToolConfig_tools{netbatch_config}{VERSION}/NetbatchConfigs.pm";
$general_vars{nbqslot} = NetbatchConfigs::get_qslot();
$general_vars{nbpool} = NetbatchConfigs::get_pool();

1;
