package ToolData;

use strict;
use warnings;
use vars
  qw(%ToolConfig_tools
     $RTL_PROJ_TOOLS
   );

######################################################################
# Gk Scripts
######################################################################
$ToolConfig_tools{gkutils} = {
  VERSION => '15.33.1',
  PATH    => "$RTL_PROJ_TOOLS/gatekeeper_utils/&get_tool_version()",
};

1;
