#!/usr/intel/pkgs/perl/5.14.1/bin/perl

use strict;
use warnings;
use Getopt::Long qw(:config auto_help);
use File::Basename;
use Cwd;
use Cwd 'abs_path';
use Scalar::Util qw(looks_like_number);
use POSIX;

my $config             = "";
GetOptions ('config=s'              => \$config,
           ) or POSIX::_exit(-1);

my $regression_list = "$ENV{'IP_ROOT'}/ace/iosf_sbc_rtr_full.list";

#my ($diff_opts_file, $files_hash_ref) = @_;
   chdir "$ENV{'IP_ROOT'}/verif/bfm/sideband_vc/tb/common" or die;
   system "mkdir jem_manual_gen";
   system "$ENV{'JEM'}/bin/jemsw -o ./jem_manual_gen -- -mtm $ENV{'IP_ROOT'}/verif/bfm/sideband_vc/tb/common/iosfsbm_rtl_tlm_common_pkg.sv iosf_sb_hw_monitor.sv +incdir+$ENV{'IP_ROOT'}/verif/bfm/sideband_vc/tb/common/ +incdir+$ENV{'SAOLA_HOME'}/verilog +incdir+$ENV{'OVM_HOME'}/src +incdir+$ENV{'JEM'}/jem_rt +define+SLA_EXTERNAL_RTL_TLM_IMPL +define+USE_SLA_RTL_TLM";
   chdir "jem_manual_gen" or die;
   system "cp -rp $ENV{'IP_ROOT'}/verif/tb/jem.f $ENV{'IP_ROOT'}/verif/bfm/sideband_vc/tb/common/jem_manual_gen/.";
   my $cmd = "g++ -shared -fPIC -g -o libtlmgen_iosfsb_ml.so jem_tlm_dut.cpp jem_tlm_replay_ml.cpp -D JEM_ML -I . -I $ENV{'MLTE_PATH'}//comm/cdns_uvm_ml/ml/backplane/ -I $ENV{'MLTE_PATH'}//comm/connectors/ -I $ENV{'JEM'}/jem_ml_rt -I $ENV{'JEM'}/jem_rt -Wl,-rpath,$ENV{'JEM'}/lib -Wl,-rpath-link,$ENV{'JEM'}/lib -Wl,--disable-new-dtag";
   system("$cmd");

   chdir "$ENV{'IP_ROOT'}/scripts/iosf_sb_replay" or die;
	open(F, $regression_list) or die;
	my @lines = <F>;
	close(F);
	foreach my $line (@lines) {
		#$line = _trimmed($line);

		# Ignoring empty lines and commented-out lines
		if ($line eq "" || $line =~ /^#/ || $line =~ /testlist/ || $line =~ /\);/ || $line =~ /_pg/ ) {
			next;
		} 
	my ($testname,$seed_count,$seed) = split(/:/,$line);
	printf ("Testname is %s\n", $testname);

	$cmd = "run_te_replay $testname $ENV{IP_ROOT}/verif/results_jem_dump $config";
	system("$cmd");
	if ( $? == -1 )
	{
		print "command failed: $!\n";
	}
	else
	{
		printf "command successful with value %d", $? >> 8;
	}

	}

