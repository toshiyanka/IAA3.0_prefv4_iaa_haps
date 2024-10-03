######################################################################
# This file is intended to store IP information in a reusable manner.
# It is intended for use both by development and customer teams, 
# to contour the information needed to enable efficient IP handoff.
######################################################################
package ToolData;
use strict;
use warnings;


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
if (defined $ToolData::ToolConfig_tools{ipconfig}{SUB_TOOLS}{ccu_vc}{VERSION} && 
            $ToolData::ToolConfig_tools{ipconfig}{OTHER}{OVERRIDES_FIRST}) {
    $version = $ToolData::ToolConfig_tools{ipconfig}{SUB_TOOLS}{ccu_vc}{VERSION};
    $dirname = $ToolData::ToolConfig_tools{ipconfig}{SUB_TOOLS}{ccu_vc}{PATH};
} else {
    $dirname = File::Basename::dirname(File::Basename::dirname(__FILE__));
    $dirname = Cwd::abs_path($dirname); 
    chomp($dirname); 
    $version = File::Basename::basename($dirname);     
}

$ToolConfig_ips{ccu_vc} = {   
    PATH  => $dirname, 
    VERSION => $version, 
    ENV     => {
#        ACE_RC => "$dirname/cfg/ace/ccu_vc.acerc",
    },
    OTHER   => {
        ## SDG <scope>_IPToolData vars
        SEARCH_PATHS   => [
            "&get_tool_path()",
        ],
        SUB_SCOPES => [qw(ovm saola sipmanager IOSF_SVC)],
        ## XHDK74 <scope>_IPToolData vars 
        ip_name => 'ccu_vc', ## name expected to be in the ipconfig hash 
        DO_NOT_ALLOW_UNIQUIFY => 1, ## IPs which must ALWAYS be global, such as ovm
        required_env_vars => "&get_env_var()",
        ti_env_pkgs => [ 'ccu_vc_val_lib' ], ## these are the val packages that are provided (especially what the customer is intended to import)
        ti_ifcs     => [ ], ## interfaces provided by this scope (what the customer is intended to instantiate)
        ti_modules  => [ ], # top-level val modules provided by this scope (what the customer is intended to instantiate)
        top_modules => [ ], ## top-level design modules provided by this scope (what the customer is intended to instantiate)
        ace => {
            IMPORT_INTO_SIP_SHARED_LIB => 'ccu_vc_val_lib', ## package name expected to be imported/present in sip_shared_lib
            reuse_search_paths => ["&get_tool_var(,SEARCH_PATHS)"],
            integ_udf_file => 'cfg/ace/ccu_vc/ccu_vc_integ.udf',
            hdl_udf_file => 'cfg/ace/ccu_vc/ccu_vc_hdl.udf',
            export_model => 'ccu_vc', ## name of the model that ovm is providing with export section
            reuse_lib_paths => [], ## does this map to SDG LIB_PATH?
            subscopes => ["&get_tool_var(,SUB_SCOPES)"],
        },
        library => { val => { lib_name => 'ccu_vc_val_lib', }, }, 
    },
};

#Below code for compatibility with TGL style ToolConfig_ips
if (!defined $ToolData::ToolConfig_tools{ipconfig}{SUB_TOOLS}{ccu_vc}) {
    $ToolConfig_tools{ipconfig}{SUB_TOOLS}{ccu_vc}{PATH} = $ToolConfig_ips{ccu_vc}{PATH};
    $ToolConfig_tools{ipconfig}{SUB_TOOLS}{ccu_vc}{VERSION} = $ToolConfig_ips{ccu_vc}{VERSION};
    $ToolConfig_tools{ipconfig}{SUB_TOOLS}{ccu_vc}{ENV} = $ToolConfig_ips{ccu_vc}{ENV};
}

1;
