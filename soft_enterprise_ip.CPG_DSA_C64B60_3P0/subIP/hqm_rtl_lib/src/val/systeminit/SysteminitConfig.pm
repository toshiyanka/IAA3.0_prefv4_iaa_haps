package SysteminitConfig;

use strict;
use warnings;
use Exporter;

our @ISA = qw(Exporter);
our @EXPORT = qw($ovm_path $configdb_sv_path $configdb_so_path $systeminit_path $dut_cfg_path $gcc_path @incdirs @incfiles);

##################################################
### Add project specific paths below this line ###
##################################################

my $tbtools_path = "$ENV{WORKAREA}/subip/vip/tbtools";
my $tbtools_rel_path = "$tbtools_path/results/sles11_x86_64_gcc4.7.2/deb/rel";

our $ovm_path = "$ENV{WORKAREA}/subip/vip/ovm";
our $configdb_sv_path = "$tbtools_rel_path/sv";
our $configdb_so_path = "$tbtools_rel_path/lib";
our $systeminit_path = "$tbtools_rel_path/sv/systeminit";

# Systeminit paths
my $topo_sysinit_path    = "$ENV{WORKAREA}/subip/vip/projcfg/cfg/systeminit";
my $hqm_sysinit_path     = "$ENV{WORKAREA}/src/val/systeminit";

# Dut Cfg paths
my $topo_dutcfg_path = "$ENV{WORKAREA}/subip/vip/projcfg/cfg/dut_cfg";
my $hqm_dutcfg_path  = "$ENV{WORKAREA}/src/val/dut_cfg";
our $dut_cfg_path    = "${hqm_dutcfg_path}:${topo_dutcfg_path}";


# Include dirs
our @incdirs = (
  `find -L ${hqm_sysinit_path} -type d`,
  `find -L ${topo_sysinit_path} -type d`,
  "${configdb_sv_path}",
);
chomp @incdirs;

# Include files
our @incfiles = (
  "${configdb_sv_path}/ten_nm_msg_utils.sv",
  "${topo_sysinit_path}/base_picker_pkg.svh",
  "${hqm_sysinit_path}/hqm/hqm_picker_pkg.svh",
  "${hqm_sysinit_path}/top/systeminit_lib.inc",
);

######################################
# These are optional for most projects
######################################

our $gcc_path = "/usr/intel/pkgs/gcc/7.3.0";

1;
