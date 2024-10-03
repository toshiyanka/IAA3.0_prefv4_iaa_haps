######################################################################
# This file is intended to store IP information in a reusable manner.
# It is intended for use both by development and customer teams, 
# to contour the information needed to enable efficient IP handoff.
######################################################################
package ToolData;
use strict;
use warnings;

use IPToolDataExtras();


######################################################################
# NOTE: Use these variables instead of $ENV when possible
# Try to use &get_tool_env_var(ipconfig/tfm_vi_tb,VARIABLE_NAME) in hash string entries otherwise
# Also, please use variables instead of raw absolute paths.
# Add needed variables in this list from baselin_tools/GeneralVars.pm
######################################################################
use vars
  qw(%ToolConfig_ips
     %ToolConfig_tools
     %general_vars
     $MODEL_ROOT
     $IP_MODELS
     $IP_RELEASES
     $RTL_PROJ_TOOLS
     $RTL_CAD_ROOT
     $CAD_ROOT
   );
 
# for SDG compatability  
if(!defined($RTL_CAD_ROOT) && defined($CAD_ROOT)) {
    $RTL_CAD_ROOT = $CAD_ROOT; 
}

#To handle different approaches to ToolData and overrides (some override after setting; 
#   others preset the overrides), we must check for the pre-existence of an override
my $dirname;
my $version;
if (defined $ToolData::ToolConfig_tools{ipconfig}{SUB_TOOLS}{jtagbfm}{VERSION} && 
            $ToolData::ToolConfig_tools{ipconfig}{OTHER}{OVERRIDES_FIRST}) {
    $version = $ToolData::ToolConfig_tools{ipconfig}{SUB_TOOLS}{jtagbfm}{VERSION};
    $dirname = $ToolData::ToolConfig_tools{ipconfig}{SUB_TOOLS}{jtagbfm}{PATH};
} else {
    $dirname = File::Basename::dirname(File::Basename::dirname(__FILE__));
    $dirname = Cwd::abs_path($dirname); 
    chomp($dirname); 
    $version = File::Basename::basename($dirname);
}

#Whether it exists or not, we want it consistent in ToolConfig_tools and ToolConfig_ips
$ToolData::ToolConfig_tools{"jtagbfm"}{VERSION} = $version;
$ToolData::ToolConfig_tools{"jtagbfm"}{PATH} = $dirname;

if(defined($ENV{ONECFG_tb_mode})) {
    #Intended usage models:
    if      ($ENV{ONECFG_tb_mode} eq "ovm") {
	IPToolDataExtras::do_with_warn("$dirname/cfg/ovm/cfg/jtagbfm_IPToolData.pm");
    } elsif ($ENV{ONECFG_tb_mode} eq "uvm") {
        IPToolDataExtras::do_with_warn("$dirname/cfg/uvm/cfg/jtagbfm_IPToolData.pm");
    } elsif ($ENV{ONECFG_tb_mode} eq "xvm") {
        IPToolDataExtras::do_with_warn("$dirname/cfg/xvm/cfg/jtagbfm_IPToolData.pm");
    } elsif ($ENV{ONECFG_tb_mode} eq "none") {
        IPToolDataExtras::do_with_warn("$dirname/cfg/none/cfg/jtagbfm_IPToolData.pm");#user in charge of the +define+*VM settings
    } else {
        IPToolDataExtras::do_with_warn("$dirname/cfg/ovm/cfg/jtagbfm_IPToolData.pm");
        # otherwise this is an unintended usage model, and we give the default: ovm.  Typically, though, you should not end up here because currently the only allowed values for tb_mode are ovm, uvm, xvm, and none.
    }
} else { #User has not specified a tb mode. The "none" (specified) mode will make sure all
         #of the collaterals are there, ready to be used, but will not activate the defines
         #that make them take effect. This allows the user to modulate their defines via
         #local-ivars or some other such means
    IPToolDataExtras::do_with_warn("$dirname/cfg/none/cfg/jtagbfm_IPToolData.pm");
}

$ToolConfig_ips{jtagbfm}{PATH} = $dirname;
$ToolConfig_ips{jtagbfm}{VERSION} = $version;

#Below code for compatibility with TGL style ToolConfig_ips
if (!defined $ToolData::ToolConfig_tools{ipconfig}{SUB_TOOLS}{jtagbfm}) {
    $ToolConfig_tools{ipconfig}{SUB_TOOLS}{jtagbfm}{PATH} = $ToolConfig_ips{jtagbfm}{PATH};
    $ToolConfig_tools{ipconfig}{SUB_TOOLS}{jtagbfm}{VERSION} = $ToolConfig_ips{jtagbfm}{VERSION};
    $ToolConfig_tools{ipconfig}{SUB_TOOLS}{jtagbfm}{ENV} = $ToolConfig_ips{jtagbfm}{ENV};
}

1;
