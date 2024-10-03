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
   );

$ToolConfig_ips{jtagbfm} = {   
    PATH  => "&get_tool_path(jtagbfm)",
    VERSION => "&get_tool_version(jtagbfm)",
    ENV     => {
    },
    OTHER   => {
        ## SDG <scope>_IPToolData vars
        SEARCH_PATHS   => [
	    "&get_tool_path()/cfg/xvm",
            "&get_tool_path()",
        ],
        SUB_SCOPES => [qw(ovm uvm xvm)],
        ## XHDK74 <scope>_IPToolData vars 
        ip_name => 'jtagbfm', ## name expected to be in the ipconfig hash 
        DO_NOT_ALLOW_UNIQUIFY => 1, ## IPs which must ALWAYS be global, such as ovm
        required_env_vars => "&get_tool_env_var()",
        ti_env_pkgs => [ 'jtagbfm_val_lib', ], ## these are the val packages that are provided (especially what the customer is intended to import)
        ti_ifcs     => [ ], ## interfaces provided by this scope (what the customer is intended to instantiate)
        ti_modules  => [ ], # top-level val modules provided by this scope (what the customer is intended to instantiate)
        top_modules => [ ], ## top-level design modules provided by this scope (what the customer is intended to instantiate)
        ace => {
            IMPORT_INTO_SIP_SHARED_LIB => 'jtagbfm_val_lib', ## package name expected to be imported/present in sip_shared_lib
            reuse_search_paths => ["&get_tool_var(,SEARCH_PATHS)"],
            integ_udf_file => 'cfg/ace/jtagbfm/jtagbfm_integ.udf',
            hdl_udf_file => 'cfg/ace/jtagbfm/jtagbfm_hdl.udf',
            export_model => 'jtagbfm', ## name of the model that xvm is providing with export section
            reuse_lib_paths => [], ## does this map to SDG LIB_PATH?
            subscopes => ["&get_tool_var(,SUB_SCOPES)"],
        },
        library => { val => { lib_name => 'jtagbfm_val_lib', }, }, 
    },
};

1;
