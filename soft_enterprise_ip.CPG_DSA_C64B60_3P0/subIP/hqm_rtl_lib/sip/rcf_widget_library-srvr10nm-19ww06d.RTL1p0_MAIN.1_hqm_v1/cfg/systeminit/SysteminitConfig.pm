package SysteminitConfig;

use strict;
use warnings;
use Exporter;
use ToolConfig;

our @ISA = qw(Exporter);
our @EXPORT = qw($ovm_path $configdb_sv_path $configdb_so_path $systeminit_path $dut_cfg_path $gcc_path @incdirs @incfiles);

##################################################
### Add project specific paths below this line ###
##################################################

# Tool paths
our $gcc_path = ToolConfig::get_tool_path('gcc');
our $ovm_path = ToolConfig::get_tool_env_var('ipconfig/ovm','OVM_HOME');
#our $ovm_path = qw($ENV{OVM_HOME});
my  $tbtools_rel_path = ToolConfig::get_tool_env_var('ipconfig/tfm_vi_tb','TFM_VI_REL_ROOT');
our $configdb_sv_path = ToolConfig::get_tool_env_var('ipconfig/tfm_vi_tb','TFM_VI_SV_INCLUDES');
our $configdb_so_path = ToolConfig::get_tool_env_var('ipconfig/tfm_vi_tb','TFM_VI_SO_INCLUDES');
our $systeminit_path = "$tbtools_rel_path/sv/systeminit";

# Systeminit paths
my $topo_sysinit_path = ToolConfig::get_tool_var('ipconfig/projcfg','SYSTEMINIT_PATH');
my $rcfwl_sysinit_path = ToolConfig::get_tool_var('ipconfig/hqm_rcfwl','SYSTEMINIT_PATH');

# Dut Cfg paths
my $topo_dutcfg_path = ToolConfig::get_tool_var('ipconfig/projcfg','DUT_CFG_PATH');
my $rcfwl_dutcfg_path = ToolConfig::get_tool_var('ipconfig/hqm_rcfwl','DUT_CFG_PATH');
our $dut_cfg_path = "${rcfwl_dutcfg_path}/top:${topo_dutcfg_path}";

# Include dirs
our @incdirs = (
  `find -L ${rcfwl_sysinit_path} -type d`,
  `find -L ${topo_sysinit_path} -type d`,
  "${configdb_sv_path}",
);
chomp @incdirs;

# Include files
our @incfiles = (
  "${configdb_sv_path}/ten_nm_msg_utils.sv",
  "${topo_sysinit_path}/base_picker_pkg.svh",
  "${rcfwl_sysinit_path}/rcfwl/rcfwl_picker_pkg.svh",
  "${rcfwl_sysinit_path}/top/systeminit_lib.inc",
);

1;

