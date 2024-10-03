package ToolData;

use strict;
use warnings;
use vars
  qw(%ToolConfig_tools
     $CFG_PROJECT
     $RTL_PROJ_TOOLS
   );

######################################################################
# Gk Scripts
######################################################################
$ToolConfig_tools{gkutils} = {
  VERSION => '1.01.16',
  PATH    => "$RTL_PROJ_TOOLS/gatekeeper_utils/&get_tool_version()",
};

$ToolConfig_tools{gkhooks} = {
  VERSION => '1.01.12',
  PATH    => "$RTL_PROJ_TOOLS/gatekeeper_hooks/$CFG_PROJECT/&get_tool_version()",
};

1;
