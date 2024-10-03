# -*-mode: cperl; cperl-indent-level: 4; cperl-indent-parens-as-block: t; -*- # # vim: noai:ts=4 : sw=4 : filetype=perl
# vim: noai:ts=4 : sw=4 : filetype=perl

package ToolData;
use strict;
use warnings;
use File::Basename;
my $dirname = dirname(dirname(__FILE__));
$dirname = `/usr/intel/bin/realpath $dirname`;
chomp($dirname);

use IPToolDataExtras qw(import_files get_version_from_path);


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




$ToolConfig_ips{rcfwl_globalclk} = {
    PATH    => "$dirname",
    VERSION => &get_version_from_path($dirname),
    ENV     => {
    },
    #VERSION => "",
    OTHER   => {
        IMPORT => ["subIP/ip74xdiv9or12_current/cfg/ip74xdiv9or12_IPToolData.pm" ,],
        SUBSCOPES_ARE_DIRTY => 1,
	SEARCH_PATHS   => [
	    "&get_tool_path()",
	    "&get_tool_path()/src/rtl/clkdist",
        "&get_tool_path()/src/rtl/clkreqaggr",
	"&get_tool_path()/src/rtl/clk_rcb_lcb",
	##"&get_tool_path()/subIP/ip74xdiv9or12/ip74xdiv9or12_current",
	"&get_tool_path(ipconfig/ctech)",
        "&get_tool_path(ipconfig/ctech_exp)",
	],
	SUB_SCOPES  => ["ip74xdiv9or12",
          ],
	 TEST_PATTERNS => [ 
			   "target/globalclk",
			   "verif/tests/",
                            "verif/tests/static_checks", ],
 
    },
};

$ToolConfig_ips{rcfwl_globalclk}{OTHER}{COREKIT_PATH}   = [ "target/collage/ip_kits",
                                                "tools/collage/ip_kits",];

$ToolConfig_ips{rcfwl_globalclk}->{OTHER}->{lintra_waiver_dirs}  =  [     "tools/lint/waivers/pccdu",
                                                             "tools/lint/waivers/pclkdist",
                                                             "tools/lint/waivers/psyncdist",
                                                             "tools/lint/waivers/clkreqaggr",
                                                             "tools/lint/waivers/divsync_gen",
							     "tools/lint/waivers/psocsyncdist",
                                                             "tools/lint/waivers/psocclkdist",
                                                             "tools/lint/waivers/refclkdist",
                                                             "tools/lint/waivers/clkdist_mux",
							     "tools/lint/waivers/mesh_clkdist",
                                                             "tools/lint/waivers/clkdist_repeater",
							     "tools/lint/waivers/glitchfree_clkmux",
							     "tools/lint/waivers/clkdist_clkmux",
							     "tools/lint/waivers/rcb_lcb",
							     ];

$ToolConfig_ips{rcfwl_globalclk}->{OTHER}->{lintra_waiver_files} =  [ "*_w.xml"];
import_files("rcfwl_globalclk", \%ToolConfig_ips); 


1;    
