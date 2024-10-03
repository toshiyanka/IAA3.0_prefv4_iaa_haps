#-*-perl-*-
#--------------------------------------------------------------------------------
package common::PowerEst;
use strict;
use FileHandle;
use Carp;
require "dumpvar.pl";

use Utilities::ProgramTools qw(check_args test_eval deepcopy);
use Utilities::Print;
use Utilities::System qw(Exit execute_cmd);
use Sys::Hostname;
use Data::Dumper;

use vars qw(@ISA @EXPORT_OK);
use Ace::GenericScrag qw($CWD add_cmd);
use Ace::WorkModules::HDL;
use Ace::WorkModules::GenerateRTL;

require Exporter;
@ISA = qw(Exporter Ace::WorkModules::GenerateRTL);

## CPEF ENVIRONMENT SETTING #########
unless (defined $ENV{MODEL_ROOT})	{
	$ENV{MODEL_ROOT} = $ENV{IP_ROOT};
}
## CPEF_SYN_SFO
my $CPEF_SYN_SFO;
my $LOCAL_SYN_SFO;
my $LOCAL_PWR_SFO;
my $smallCPEF_SYN_PROJECT;

unless ($ENV{CPEF_SYN_SFO}) {
	if ((defined $ENV{CPEF_UPF_EN}) && ($ENV{CPEF_UPF_EN} == "1"))      {
	    $CPEF_SYN_SFO = "/p/sip/syn/scripts/$ENV{CPEF_SYN_PROJECT}/$ENV{CPEF_SYN_MILESTONE}/override_upf.tcl";
	    $LOCAL_SYN_SFO = "$ENV{MODEL_ROOT}/tools/cpef/override_upf.tcl";
	}else{
	    $CPEF_SYN_SFO = "/p/sip/syn/scripts/$ENV{CPEF_SYN_PROJECT}/$ENV{CPEF_SYN_MILESTONE}/override.tcl";
	    $LOCAL_SYN_SFO = "$ENV{MODEL_ROOT}/tools/cpef/override.tcl";
	}
	if (-e $LOCAL_SYN_SFO)	{
	    $ENV{CPEF_SYN_SFO} = "$CPEF_SYN_SFO\;$LOCAL_SYN_SFO";
	}else{       
	    $ENV{CPEF_SYN_SFO} = "$CPEF_SYN_SFO";
	}
}
print "CPEF_SYN_SFO == $ENV{CPEF_SYN_SFO}\n";
## CPEF_PWR_SFO
$smallCPEF_SYN_PROJECT = $ENV{CPEF_SYN_PROJECT};
$smallCPEF_SYN_PROJECT =~ tr/A-Z/a-z/;
my $LOCAL_PWR_SFO = "$ENV{MODEL_ROOT}/tools/cpef/cpef_pwr_sfo";
unless (defined $ENV{CPEF_PWR_SFO}){
    if (-e $LOCAL_PWR_SFO)	{
  	$ENV{CPEF_PWR_SFO} = "$LOCAL_PWR_SFO";
    }else{
        $ENV{CPEF_PWR_SFO} = "/p/cse/asic/CPEF/2.0_SIP/cpef_pwr_sfo.$smallCPEF_SYN_PROJECT.$ENV{CPEF_SYN_MILESTONE}";
    }
}
print "CPEF_PWR_SFO == $ENV{CPEF_PWR_SFO}\n";
#####################################
## OTHERS   MOVE TO LINE   798
#if ((defined $ENV{ACE_RTL_SIM}) && ($ENV{ACE_RTL_SIM} eq "vcs" ))      {
#    delete $ENV{ACE_RTL_SIM};
#}
#####################################

#--------------------------------------------------------------------------------
sub new {
  my ($class, %args) = @_;
  check_args( \%args,
	      -valid    => [qw(* -debug)],
	      -require  => [qw()], # look at parent
	    );

  my $self = $class->SUPER::new(%args);

  
  return $self;
}
#-------------------------------------------------------------------------------
sub create_scrag {
  my ($self, %args) = @_;
  $_ = $args{-name};
  SWITCH: {
    /^power$/ && do { return $self->run_pwr_est(%args); };
    $self->_unknown_ace_command_error($_);
  }
}
#-------------------------------------------------------------------------------
# implement run_pwr_est
#-------------------------------------------------------------------------------
sub run_pwr_est {
  my ($self, %args) = @_;
  # if -power defined in ace command line
  if ($self->get_option(-power)) {
    print "===> " . ref($self) . " : Running RTL power estimation\n";
    chomp (my $time_stamp = `/bin/date +%Y%m%d_%H%M%S`);
    $ENV{CPEF_HOSTNAME}  = hostname; ## js
    my $cluster          = $self->{_cur_scope};
    my $model_root       = $self->get_option(-eng) . "/" . $self->get_option(-pwa);
    my $model            = $self->get_option(-model);
    my $config           = $self->get_option(-cfg);
    my $seed             = $self->get_option(-seed);
    my $testname         = $self->get_option(-test);
    my $testname1        = $testname; $testname1 =~ s/\:.*$//g;
    my $testname2        = $testname1; $testname2 =~ s/^.*\///;
    my $testlist         = $self->get_option(-testlist);
    my $results_dir      = $self->get_option(-results);
    my $sp               = $self->{_udf_man}->get_search_paths_ref();
    my $compile_dir      = $self->get_option(-model_compile_results_dir);
    my $vcs_ver          = `show_setup -v | sed 's/(eng)//'`; chomp $vcs_ver; $vcs_ver .= "_$ENV{VCS_TARGET_ARCH}";
    my $ini_file         = "$compile_dir/vcs_lib/$vcs_ver/synopsys_sim.setup_$model";
    my $nonb             = $self->get_option("-local");
    my $debug_indicator  = $self->get_option("-debug_indicator");
    my $skip_elab        = $self->get_option("-skip_elab");
    my $syn_dir          = $self->get_option(-syn_dir);
    my $pre_sim          = $self->get_option(-pre_sim);
    my $scenario         = $self->get_option(-scenario);
    my $ref_milestone    = $self->get_option(-ref_milestone);
    my $pvt              = $self->get_option(-pvt);
    my $include_mda      = $self->get_option(-include_mda);
    my @do_files_vcs     = $self->get_array_option(-user_do_files_vcs);
    my @input_units      = $self->get_array_option(-unit);
    my $cpefTop          = $self->get_option(-cpefTop);
    my $cpefDCversion    = $self->get_option(-cpefDCversion);
    my $cpefPTversion    = $self->get_option(-cpefPTversion);
    my $cpefSYNlibtype   = $self->get_option(-cpefSYNlibtype);
    my $cpefSYNlibprefix = $self->get_option(-cpefSYNlibprefix);
    my $cpefSYNlibvoltage= $self->get_option(-cpefSYNlibvoltage);
    my $cpefSYNprocess   = $self->get_option(-cpefSYNprocess);
    my $cpefSoCproject   = $self->get_option(-cpefSoCproject);
    my $whoami           = $ENV{LOGNAME};
    my $cpefdo           = "";
    my $syn_path         = "";
    my %unit;
    my %udf_units;
    my $nbpool;
    my $nbqslot;
    my $tool_dir         = "$model_root/tools/cpef";
    my $modules_list     = "$tool_dir/modules.list";
    my %sub_of;
    my $default_syn_dir  = "$results_dir/power/run_${time_stamp}/synthesis/$model/cfg$config";
    my $uls_saif = "$results_dir/power/run_${time_stamp}/uls.saif";
    my $unit_hier = "$results_dir/power/run_${time_stamp}/unit.hier";
    if ($pre_sim ne "") {
      $uls_saif = "$pre_sim/uls.saif";
      $unit_hier = "$pre_sim/unit.hier";
    }
    if (scalar @do_files_vcs > 0 && $testname =~ /\:cpefdo\_(\S+)$/) {
      $cpefdo = $1;
      $testname =~ s/\:cpefdo\_.*$//;
    }

    # quit if $CPEF_BIN is not set
    if (!defined $ENV{CPEF_BIN}) {
      print "===> " . ref($self) . " : ERROR: \$CPEF_BIN is not set\n";
      Exit 1;
    } else {
      print "===> " . ref($self) . " : INFO: \$CPEF_BIN - $ENV{CPEF_BIN}\n";
    }

    $ENV{REGGIE_CONF}="$ENV{REGGIE_HOME}/conf/reggie.cfg.cpef";
	#$ENV{REGGIE_CONF}="$ENV{IP_ROOT}/tools/cpef/reggie.cfg.cpef";
    print "===> " . ref($self) . " : INFO: \$REGGIE_CONF - $ENV{REGGIE_CONF}\n";

    # save all valid design module names defined in tools/cpef/modules.list, so it is easier to reference
    if (-e "$modules_list" && !-z "$modules_list") {
      my @modules_list = `cat $modules_list`;
      foreach my $line (@modules_list) {
        $line =~ s/\s//g;
        $line =~ s/\#.*$//;
        next if ($line =~ /^$/);
        $udf_units{$line} = 1;
      }
      if (scalar %udf_units < 1)  {
        print "===> " . ref($self) . " : ERROR: No valid design defined in $modules_list\n";
        Exit 1;
      }
    } else {
      # quit if $modules_list not found
      print "===> " . ref($self) . " : ERROR: $modules_list not found\n";
      Exit 1;
    }

    if ($cluster eq "fc") {
      undef $ENV{NB_WASH_ENABLED};
      undef $ENV{NB_WASH_GROUPS};
    }
 
    # find out $CPEF_SYN_MILESTONE that needed to define unit-level synthesis milestone
    if (!defined $ENV{CPEF_SYN_MILESTONE}) {
      print "===> " . ref($self) . " : ERROR: \$CPEF_SYN_MILESTONE is not set\n";
      Exit 1;
    } else {
      print "===> " . ref($self) . " : INFO: ULS Milestone - $ENV{CPEF_SYN_MILESTONE}\n";
    }
    # find out $NBPOOL and $NBQSLOT that needed to create NBFM taskfile, quit if $NBPOOL is not defined
    if (defined $ENV{NBPOOL}) {
      $nbpool = $ENV{NBPOOL};
    } elsif (defined $ENV{EC_SITE}) {
      if ($ENV{EC_SITE} eq "fm") { 
        #$nbpool = "CSE_VirtualPool_nb6";
        $nbpool = "fm_vp"; #EC Update: FM: switch to NBPOOL = fm_vp, as CSE_VitualPool_nb6 will eventually go away - and also fm_vp has new/better hardware
      } elsif ($ENV{EC_SITE} eq "png") {
        $nbpool = "DPG_SuSe";
      } elsif ($ENV{EC_SITE} eq "hd") { 
        $nbpool = "hd_sles";
      } else {
        print "===> " . ref($self) . " : ERROR: \$EC_SITE must be either fm, png, or hd\n";
        Exit 1;
      }
    } else {
      print "===> " . ref($self) . " : ERROR: \$EC_SITE is not set\n";
      Exit 1;
    }
    if (defined $ENV{NBQSLOT}) {
      $nbqslot = $ENV{NBQSLOT};
    } else {
      print "===> " . ref($self) . " : ERROR: \$NBQSLOT is not set\n";
      Exit 1;
    }
    # print cluster and RTL model info
    print "===> " . ref($self) . " : INFO: Cluster - $cluster\n";
    print "===> " . ref($self) . " : INFO: RTL model - $model\n";
    # if ini file exists, assume model is already built, else build it
    if (!-e "$ini_file" || -z "$ini_file") {
      print "===> " . ref($self) . " : INFO: RTL model $model is not ready($ini_file not found), running 'ace -g -c' to build it\n"; 
      `ace -g -c >& /dev/null`;
      if ($? != 0) {
        print "===> " . ref($self) . " : ERROR: RTL model building fail\n";
        Exit 1;
      }
    }
    # print config and testname/testlist info
    print "===> " . ref($self) . " : INFO: Config - cfg$config\n";
    if ($testname ne "") {
      print "===> " . ref($self) . " : INFO: Power test - $testname\n";
    }
    if (defined $testlist) {
      my $tl_num = scalar @{$self->get_option(-testlist)};
      print "===> " . ref($self) . " : INFO: $tl_num Power testlist(s) - @{$self->get_option(-testlist)}\n";
    }
    # print seed info
    if ($seed ne "") {
      print "===> " . ref($self) . " : INFO: Seed - $seed\n";
    }

    # Big Brother
    if (-e "/p/sip/utils/lib") {
      push(@INC, "/p/sip/utils/lib");
      require("BB.pl");
      my $toolname = "CPEF";
      my $logfile = "/p/ccgda/GENERAL/BB/tool_usage.log";
      my $tool_rev = "Revision:SPT1.0";
      unless (-e $logfile) {
        `touch $logfile`;
        `chmod 777 $logfile`;
      }
      &BB::log($logfile, $toolname, $tool_rev);
    }
##################################################################################################################
# need a different method to identify released model here
##################################################################################################################
#    # check if current sandbox is released model and update $ref_milestone if needed
#    chomp (my $real_model_root = `realpath $model_root`);
#    chomp (my $real_rel_model_root = `realpath $ENV{PROJ}/val/release/$ENV{ACE_PROJECT}/$ENV{ACE_PWA_DIR}`);
#    # if current sandbox is released model
#    if ($real_model_root eq $real_rel_model_root || $debug_indicator) {
#      # set default value for milestone if it is undefined
#      if ($ref_milestone eq "") {
#        $ref_milestone = "NA";
#      }
#    # clear the milestone set if current sandbox is not released model
#    } else {
#      $ref_milestone = "";
#    }
##################################################################################################################

    # create power estimation run output directories
    if (-d "$results_dir/power/run_${time_stamp}") {
      print "===> " . ref($self) . " : WARNING: $results_dir/power/run_${time_stamp} already exists, it will be removed\n";
      `rm -fr $results_dir/power/run_${time_stamp}`;
    }
    `mkdir -p -m 2750 $results_dir/power/run_${time_stamp}/synthesis`;
    `mkdir -p -m 2750 $results_dir/power/run_${time_stamp}/ptpx`;
    # setenv $CPEF_RESULTS_DIR thus it can be used by runsim_postsim_checks.pl
    $ENV{CPEF_RESULTS_DIR} = "$results_dir";
    # if there are user-defined RTL units - @input_units, check if those are valid RTL units
    if (scalar @input_units > 0) {
      foreach my $u (@input_units) {
        if (exists $udf_units{$u}) {
          # skip IO unit as they are non-synthesizable
          if ($u =~ /\_io$/ || $u =~ /\_blk$/ || $u eq "usbhsip_afe") {
            print "===> " . ref($self) . " : INFO: Skip IO unit $u\n";
            next;
          }
          # remember $u as valid RTL unit
          $unit{$u}{valid} = 1;
          print "===> " . ref($self) . " : INFO: Power estimation will be run on $u\n";
          if (-e "$tool_dir/$u.units.list" && !-z "$tool_dir/$u.units.list") {
            my @tmp = `cat $tool_dir/$u.units.list`;
            foreach my $s (@tmp) {
              chomp $s;
              $s =~ s/\s//g;
              next if ($s eq "");
              push @{$sub_of{$u}}, $s;
            }
          }
          next;
        } else {
          print "===> " . ref($self) . " : WARNING: Skipping $u as it is not a valid design defined in $modules_list\n";
        }
      }
    # automatically include all RTL unit by default - using %udf_units, if user doesn't define any
    } else {
      print "===> " . ref($self) . " : INFO: Power estimation will be run on all design(s) defined in $modules_list\n";
      foreach my $u (keys %udf_units) {
        # skip IO unit as they are non-synthesizable
        next if ($u =~ /\_io$/ || $u =~ /\_blk$/ || $u eq "usbhsip_afe");
        # remember $u as valid RTL unit
        $unit{$u}{valid} = 1;
        if (-e "$tool_dir/$u.units.list" && !-z "$tool_dir/$u.units.list") {
          my @tmp = `cat $tool_dir/$u.units.list`;
          foreach my $s (@tmp) {
            chomp $s;
            $s =~ s/\s//g;
            $s =~ s/\#\#.*$//;
            next if ($s eq "");
            push @{$sub_of{$u}}, $s;
          }
        }
      }
    }
    # quit if there is no valid RTL unit to run
    if (keys %unit < 1) {
      print "===> " . ref($self) . " : ERROR: No valid RTL unit defined for power estimation\n";
      Exit 1;
    }
    # if -skip_elab is undefined, do a dummy elab on $model to dump out saif file for synthesis
    if (!$skip_elab || (!-e "$uls_saif" && !-e "$uls_saif.gz") || !-e "$unit_hier") {
      $uls_saif = "$results_dir/power/run_${time_stamp}/uls.saif";
      $unit_hier = "$results_dir/power/run_${time_stamp}/unit.hier";
      my $dump_saif_do = "$results_dir/power/run_${time_stamp}/dump_saif.do";
      my @rtllist;
      open(DO, ">$dump_saif_do") || die "Cannot open $dump_saif_do for write\n",__LINE__;
      print DO "config onerror {\n";
      print DO "  puts \"Exiting due to error in executing do file...\";\n";
      print DO "  exit;\n";
      print DO "}\n";
#      print DO "scope top_tb_ent.ichuut\n" if ($cluster eq "fc");
      # find the hier for each $u_top, this is needed for uls
      foreach my $u_top (keys %unit) {
        print DO "set SEARCH_HIER [search -module $u_top -depth 9]\n";
        print DO "set SEARCH_HIER1 [regsub -all {\\{(\\S+)\\}} \$SEARCH_HIER {\\1}]\n";
        print DO "set SEARCH_HIER1_SPLIT {}\n";
        print DO "set SEARCH_HIER1_SPLIT [split \$SEARCH_HIER1 \"\\n\"]\n";
        print DO "set count 0\n";
        print DO "foreach i \$SEARCH_HIER1_SPLIT {\n";
        print DO "  redirect -append -file $results_dir/power/run_${time_stamp}/printhier.do {echo \"call {\\\$PrintHier(\\\"\$i\\\",\\\"$results_dir/power/run_${time_stamp}/$u_top.rtllist\$count\\\")}\"}\n";
        if (exists $sub_of{$u_top} && scalar @{$sub_of{$u_top}} > 0) {
          foreach my $sub (@{$sub_of{$u_top}}) {
            print DO "  set SEARCH_SUB_HIER [search -scope \$i -module $sub -depth 6]\n";
            print DO "  set SEARCH_SUB_HIER1 [regsub -all {\\{(\\S+)\\}} \$SEARCH_SUB_HIER {\\1}]\n";
            print DO "  set SEARCH_SUB_HIER1_SPLIT {}\n";
            print DO "  set SEARCH_SUB_HIER1_SPLIT [split \$SEARCH_SUB_HIER1 \"\\n\"]\n";
            print DO "  foreach j \$SEARCH_SUB_HIER1_SPLIT {\n";
            print DO "    set j1 [regsub -all {\\.} \$j {/}]\n";
            print DO "    redirect -append -file $results_dir/power/run_${time_stamp}/$u_top.instances.list\$count {echo \"\$j1\"}\n";
            print DO "  }\n";
          }
        }
        print DO "  inc count\n";
        print DO "}\n";
        print DO "set SEARCH_HIER2 [regsub -all {\\.} \$SEARCH_HIER {/}]\n";
        print DO "set SEARCH_HIER3 [regsub -all {\\{(\\S+)\\}} \$SEARCH_HIER2 {\\1}]\n";
        print DO "set SEARCH_HIER3_SPLIT [split \$SEARCH_HIER3 \"\\n\"]\n";
        print DO "foreach i \$SEARCH_HIER3_SPLIT {\n";
        print DO "  redirect -append -file $results_dir/power/run_${time_stamp}/unit.hier {echo \"$u_top:\$i\"}\n";
        print DO "}\n";
      }
      print DO "scope \$SEARCH_HIER1\n" if ($cluster eq "chap");
      print DO "do $results_dir/power/run_${time_stamp}/printhier.do\n";
#      if ($cluster eq "spi") {
#        print DO "set SEARCH_TOP [search -module flash -depth 3]\n";
#      } elsif ($cluster eq "fc") {
#        print DO "scope pch_tb\n";
#        print DO "set SEARCH_TOP [search -module pch -depth 3]\n";
#      } else {
        print DO "set SEARCH_TOP [search -module $cpefTop -depth 3]\n";
#      }
      if ($cluster eq "chap") {
        print DO "dump -depth 0 -aggregates -add \$SEARCH_HIER\n";
      } else {
        print DO "dump -depth 0 -aggregates -add \$SEARCH_TOP\n";
      }
      print DO "run 1 ps\n";
      print DO "exit\n";
      close DO;
#      my $ace_elab_cmd = "ace -nocleanup -m $model -cfg $config -t $testname -results $results_dir/power/run_${time_stamp}/vcsmx_elab -x -do $dump_saif_do";
      my $ace_elab_cmd = "ace -nocleanup -m $model -cfg $config -t $testname -results $results_dir/power/run_${time_stamp}/vcsmx_elab -x -simv_args_first \"-ucli -i $dump_saif_do \" -tid_use_custom_name $testname2";
      print "===> " . ref($self) . " : INFO: Running '$ace_elab_cmd' to create saif file for synthesis\n";
      `$ace_elab_cmd`;
      # delay 5 secs to make sure all writing to NFS disk is done
      sleep 5;
      foreach my $u_top (keys %unit) {
        my @list = ();
        my @list = `/bin/ls $results_dir/power/run_${time_stamp}/$u_top.rtllist*`;
        push @rtllist, @list;
      }
      my $rtllist_not_found = 0;
      foreach my $rtllist (@rtllist) {
        chomp $rtllist;
        if (!-e "$rtllist") {
          $rtllist_not_found = 1;
          print "===> " . ref($self) . " : ERROR: $rtllist is not exists\n";
        }
      }
      Exit 1 if ($rtllist_not_found);
      my %FILES_ID;
      my %FILES_PATH;
      my %INCFILES_ID;
      my @FILES;                      #my %FILES;   js
      my %INCLUDED_FILES;
      my @TOTALFILES;                  #my %TOTALFILES;   js
      my $dve_debug_db;
      my @dve_debug_db = `find $results_dir/power/run_${time_stamp}/vcsmx_elab -type f -name 'dve_debug.db*'`;
      if (scalar @dve_debug_db < 1) {
        @dve_debug_db = `find $compile_dir/vcs_lib/$vcs_ver/models/$model/${model}.simv.daidir -type f -name 'dve_debug.db*'`;
      }
      foreach my $db (@dve_debug_db) {
        next if ($db =~ /\/AN\.DB\//);
        chomp $db;
        if ($db =~ /\.gz$/) {
          `gunzip -f $db`;
          $dve_debug_db = $db;
          $dve_debug_db =~ s/\.gz$//;
        } else {
          $dve_debug_db = $db;
        }
      }
      # if dve_debug.db file not found
      if ($dve_debug_db eq "" || !-e "$dve_debug_db") {
        print "===> " . ref($self) . " : ERROR: Unable to find dve_debug.db from directory $results_dir/power/run_${time_stamp}/vcsmx_elab\n";
        Exit 1;
      # if dve_debug.db file generated
      } else {
        open (DVE, "<$dve_debug_db") || die "Cannot open $dve_debug_db for read\n", __LINE__;
        while (<DVE>) {
          if (/<file fid=\"(\d+?)\" path=\"(.*?)\"/) {
            $FILES_ID{$2} = $1;
            $FILES_PATH{$1} = $2;
          } elsif (/<incfile fid=\"(\d+?)\" lineno=\"(\d+?)\" includeID=\"(\d+?)\"/) {
            $INCFILES_ID{$1}{$2}{$3} = 1;
          }
        }
        close DVE;
      }
      sub get_included_file_core {
        my $id = shift;
        if (exists $INCFILES_ID{$id}) {
          foreach my $incline_id (sort {$a <=> $b} keys %{$INCFILES_ID{$id}}) {
            foreach my $incfile_id (sort {$a <=> $b} keys %{$INCFILES_ID{$id}{$incline_id}}) {
              my $incfile_path = $FILES_PATH{$incfile_id};
              if (!exists $INCLUDED_FILES{$incfile_path}) {
                $INCLUDED_FILES{$incfile_path} = 1;
#                $TOTALFILES{$FILES_PATH{$incfile_id}} = 1;
                my $fid = $FILES_ID{$incfile_path};
                &get_included_file_core($fid);
              }
            }
          }
        }
      }
      foreach my $rtllist (@rtllist) {
        @FILES = ();                 #%FILES = ();    js
        %INCLUDED_FILES = ();
        @TOTALFILES = ();             #%TOTALFILES = ();
        my %FINAL = ();
        open(LIST, "$rtllist") || die "Cannot open $rtllist for read\n",__LINE__;
        while (<LIST>) {
          next if (/^#/);
          next if (/^\s*$/);
          /^.*?\s+\S+\s+(\S+)\s*$/;
          push (@FILES, $1);           #$FILES{$1} = 1;     js
        }
        close LIST;
        foreach my $file ( @FILES ) {        #foreach my $file (sort keys %FILES) {     js
          my $id = $FILES_ID{$file};
          &get_included_file_core($id);
          push (@TOTALFILES, $file);                  #$TOTALFILES{$file} = 1;     js
        }
        open(LIST, ">$rtllist.new") || die "Cannot open $rtllist.new for write\n",__LINE__;
        print LIST "#module files\n";
        my $topname = $rtllist;
        $topname =~ s/^.*\///;
        $topname =~ s/\.rtllist.*$//;
          if (-e "$model_root/tools/syn/$topname.custom.comm") {              ## js
             my @custom = `cat $model_root/tools/syn/$topname.custom.comm`;
             foreach my $f (@custom) {
               $f =~ s/\s//g;
               $f =~ s/\#.*$//;
               $f =~ s/\$model_root/$ENV{MODEL_ROOT}/;
	       $f =~ s/\$MODEL_ROOT/$ENV{MODEL_ROOT}/;
               $f =~ s/\$ip_root/$ENV{MODEL_ROOT}/;		## JS
               $f =~ s/\$IP_ROOT/$ENV{MODEL_ROOT}/;
               unless ($f =~ m/^\/(.*)/)        {
                        $f =~ s/(.*)/$ENV{MODEL_ROOT}\/$1/;
               }						## JS
               next if ($f eq "");
               print LIST "$f\n";
             }
         }                                                                     ## js
        foreach my $file ( @TOTALFILES ) {         #foreach my $file (sort keys %TOTALFILES) {      js
          $file =~ s'/nfs/fm/disks/fm_cse_02908/sip'/p/lpt/val/sip';
          $file =~ /\/([^\/]+)$/;
          my $filename = $1;
          if (!exists $FINAL{$filename}) {
            print LIST "$file\n";
          }
          push @{$FINAL{$filename}}, $file;
        }
#        my $topname = $rtllist;
#        $topname =~ s/^.*\///;
#        $topname =~ s/\.rtllist.*$//;
#        if (-e "$model_root/tools/syn/$topname.custom.comm") {
#          my @custom = `cat $model_root/tools/syn/$topname.custom.comm`;
#          foreach my $f (@custom) {
#            $f =~ s/\s//g;
#            $f =~ s/\#.*$//;
#	    $f =~ s/\$model_root/$ENV{MODEL_ROOT}/;
#            next if ($f eq "");
#            print LIST "$f\n";
#          }
#        }
        print LIST "#include files\n";
        foreach my $file (sort keys %INCLUDED_FILES) {
          $file =~ s'/nfs/fm/disks/fm_cse_02908/sip'/p/lpt/val/sip';
          $file =~ /\/([^\/]+)$/;
          my $filename = $1;
          if (!exists $FINAL{$filename}) {
            print LIST "$file\n";
          }
          push @{$FINAL{$filename}}, $file;
        }
        close LIST;
        `mv -f $rtllist.new $rtllist`;
      }
      # get the vpd created and convert it to saif file for synthesis
      my $dump_vpd = `find $results_dir/power/run_${time_stamp}/vcsmx_elab -type f -name 'inter.vpd'`;
      chomp $dump_vpd;
      # if vpd file not found
      if ($dump_vpd eq "") {
        print "===> " . ref($self) . " : ERROR: Unable to find inter.vpd from dummy elab directory $results_dir/power/run_${time_stamp}/vcsmx_elab\n";
        Exit 1;
      # if vpd file generated
      } else {
        if ($include_mda == 0) {
          print "===> " . ref($self) . " : INFO: Running \"vcd2saif -input tmp -pipe 'vpd2vcd -xlrm $dump_vpd tmp' -output $uls_saif\" to generate saif file for synthesis\n";
          `vcd2saif -input tmp -pipe 'vpd2vcd -xlrm $dump_vpd tmp' -output $uls_saif >& /dev/null`;
        } else {
          print "===> " . ref($self) . " : INFO: Running \"vcd2saif -input tmp -pipe 'vpd2vcd -xlrm +includemda +splitpacked $dump_vpd tmp' -output $uls_saif\" to generate saif file for synthesis\n";
          `vcd2saif -input tmp -pipe 'vpd2vcd -xlrm +includemda +splitpacked $dump_vpd tmp' -output $uls_saif >& /dev/null`;
        }
        if ($? != 0) {
          print "===> " . ref($self) . " : ERROR: vcd2saif failed\n";
          Exit 1;
        }
      }
      # remove the dummy elab directory and dump do file
      `rm -fr $results_dir/power/run_${time_stamp}/vcsmx_elab`;
#      `rm -f $dump_saif_do printhier.do`;
      # zip the generated saif file
      `gzip $uls_saif`;
      $uls_saif = "$uls_saif.gz";
    } else {
      print "===> " . ref($self) . " : INFO: Skip creating saif file for synthesis\n";
      if (-e "$uls_saif") {
        print "===> " . ref($self) . " : INFO: Using $uls_saif for synthesis\n";
      } elsif (-e "$uls_saif.gz") {
        print "===> " . ref($self) . " : INFO: Using $uls_saif.gz for synthesis\n";
        $uls_saif = "$uls_saif.gz";
      } else {
        print "===> " . ref($self) . " : ERROR: Unable to locate $uls_saif for unit-level synthesis\n";
        Exit 1;
      }
    }
    # if there is user-defined synthesis directory, check if RTL unit synthesis directory is valid
    if ($syn_dir ne "") {
      # check if user-defined synthesis directory is valid
      $syn_path = $sp->find_directory(
        -dir  => $syn_dir,
        -scope => $cluster,
        -exit_on_failure => 1,
        -exit_msg => "ERROR: Unable to locate -syn_dir '$syn_dir'",
      );
      # now go through each unit to check if the netlist is available, get the synthesis com file for those RTL unit that needed to be synthesized
      foreach my $u_top (keys %unit) {
        my @u_top_hier = ();
        my $num = 0;
        @u_top_hier = `grep -P "^$u_top:" $unit_hier`;
        $num = scalar @u_top_hier;
        if ($num < 1) {
           print "===> " . ref($self) . " : ERROR: $u_top not found in $unit_hier\n";
           Exit 1;
        } else {
          my $i;
          for ($i = 0; $i < $num; $i++) {
            my $u_topi = "$u_top$i";
            my $u_hier = $u_top_hier[$i];
            chomp $u_hier;
            $u_hier =~ s/\s*//g;
            $u_hier =~ s/^.*\://;
            $u_hier =~ s/\//\./g;
            # update %unit with respective synthesis path
            $unit{$u_top}{$u_topi}{syn_dir} = "$syn_path/$u_top/$u_top$i";
            $unit{$u_top}{$u_topi}{ptpx} = 0;
            # check if each RTL unit top module is synthesized
            my ($verify_syn_dir, $check_syn_err) = &verify_syn_dir($u_top, "$syn_path/$u_top/$u_top$i");
            # if $u_top netlist is valid
            if ($verify_syn_dir == 0) {
              print "===> " . ref($self) . " : INFO: $u_top $i synthesized netlist found, skipping synthesis on $u_top $i\n";
              $unit{$u_top}{$u_topi}{synthesis} = 1;
            # if $u_top netlist is not valid
            } else {
              print "===> " . ref($self) . " : INFO: $u_top $i synthesized netlist not found, $u_top $i will be synthesized\n";
              $unit{$u_top}{$u_topi}{synthesis} = 0;
              $unit{$u_top}{$u_topi}{syn_dir} = "$default_syn_dir/$u_top/$u_top$i";
              if (-e "$unit{$u_top}{$u_topi}{syn_dir}") {
                `rm -fr $unit{$u_top}{$u_topi}{syn_dir}`;
              }
              # mkdir synthesis directory for $u_top$i
              my $syn_dir = $unit{$u_top}{$u_topi}{syn_dir};
              `mkdir -p -m 2750 $syn_dir`;
              # check and get the path of synthesis com file
              my $com_file = "";
              $com_file = &check_com_file($self, $u_top, $syn_dir, $uls_saif, "$results_dir/power/run_${time_stamp}", $i, $u_hier);
              # don't synthesis $u_top if its synthesis com file is not available
              if ($com_file eq "") {
                $unit{$u_top}{$u_topi}{synthesis} = 1 if ($com_file eq "");
                print "===> " . ref($self) . " : ERROR: Synthesis COM file for $u_top $i not found\n";
                Exit 1;
              } else {
                $unit{$u_top}{$u_topi}{com_file} = $com_file;
              }
              my $utophier = $u_top_hier[$i];
              chomp $utophier;
              $utophier =~ s/^$u_top\://;
              $utophier =~ s///g;
              $unit{$u_top}{$u_topi}{hier} = $utophier;
            }
          }
        }
      }
    } else {
      # create synthesis directory at default location in sandbox
      my $syn_dir = $default_syn_dir;
      `rm -fr $syn_dir` if (-e "$syn_dir");
      `mkdir -p -m 2750 $syn_dir`;
      print "===> " . ref($self) . " : INFO: mkdir synthesis directory $syn_dir\n";
      # go through each unit in %unit to update its synthesis info
      foreach my $u_top (keys %unit) {
        my @u_top_hier = ();
        my $num = 0;
        @u_top_hier = `grep -P "^$u_top:" $unit_hier`;
        $num = scalar @u_top_hier;
        if ($num < 1) {
          print "===> " . ref($self) . " : ERROR: $u_top not found in $unit_hier\n";
          Exit 1;
        } else {
          my $i;
          for ($i = 0; $i < $num; $i++) {
            my $u_topi = "$u_top$i";
            my $u_hier = $u_top_hier[$i];
            chomp $u_hier;
            $u_hier =~ s/\s*//g;
            $u_hier =~ s/^.*\://;
            #$u_hier =~ s/\//\./g; #separator should be "/" in comm file
            # update %unit with respective synthesis path
            $unit{$u_top}{$u_topi}{syn_dir} = "$syn_dir/$u_top/$u_top$i";
            $unit{$u_top}{$u_topi}{ptpx} = 0;
            $unit{$u_top}{$u_topi}{synthesis} = 0;
            if (-e "$unit{$u_top}{$u_topi}{syn_dir}") {
              `rm -fr $unit{$u_top}{$u_topi}{syn_dir}`;
            }
            # mkdir synthesis directory for $u_top$i
            my $syndir = $unit{$u_top}{$u_topi}{syn_dir};
            `mkdir -p -m 2750 $syndir`;
            # check and get the path of synthesis com file
            my $com_file = "";
            $com_file = &check_com_file($self, $u_top, $syndir, $uls_saif, "$results_dir/power/run_${time_stamp}", $i, $u_hier);
            # don't synthesis $u_top if its synthesis com file is not available
            if ($com_file eq "") {
              $unit{$u_top}{$u_topi}{synthesis} = 1 if ($com_file eq "");
              print "===> " . ref($self) . " : ERROR: Synthesis COM file for $u_top $i not found\n";
              Exit 1;
            } else {
              $unit{$u_top}{$u_topi}{com_file} = $com_file;
            }
            my $utophier = $u_top_hier[$i];
            chomp $utophier;
            $utophier =~ s/^$u_top\://;
            $utophier =~ s///g;
            $unit{$u_top}{$u_topi}{hier} = $utophier;
          }
        }
      }
    }
    # make use of acereg -cjf to create simulation tasks, then add it into main power taskfile later
    my @acereg_cjf = ();
    my @acereg_tasks = ();
    my @acereg_cmds;
    my $acereg_cmd;
    # if user define testlist
    if (defined $testlist && scalar @{$self->get_option(-testlist)} > 0) {
      foreach my $tl (@{$self->get_option(-testlist)}) {
        $acereg_cmd = "acereg -cjf -power_en $time_stamp -m $model -cfg $config -tl $tl -x -results $results_dir";
        $acereg_cmd .= " -seed $seed" if ($seed ne "");
        push @acereg_cmds, $acereg_cmd;
      }
    # if user define single test only
    } else {
      if ($cpefdo ne "") {
        $acereg_cmd = "acereg -cjf -power_en $time_stamp -m $model -cfg $config -t $testname -x -results $results_dir -nocleanup -tid_use_custom_name $testname2 -user_do_files_vcs $cpefdo";
      } else {
        $acereg_cmd = "acereg -cjf -power_en $time_stamp -m $model -cfg $config -t $testname -x -results $results_dir -nocleanup -tid_use_custom_name $testname2";
      }
      $acereg_cmd .= " -seed $seed" if ($seed ne "");
      push @acereg_cmds, $acereg_cmd;
    }
    # go through each acereg command saved earlier
    foreach my $ac (@acereg_cmds) {
      my $acereg_taskfile = "";
      my $acereg_jobsfile = "";
      my $acereg_envsfile = "";
      my %acereg_env = ();
      # running each acereg command
      print "===> " . ref($self) . " : INFO: Running '$ac' to generate simulation taskfile\n";
      @acereg_cjf = `$ac`;
      # go through acereg messages to get Task File, Jobs File, and Env Setup File
      foreach my $line (@acereg_cjf) {
        if ($line =~ /\s*Creating NBFM Task File\s*\'(\S+)\'/) {
          $acereg_taskfile = $1;
        } elsif ($line =~ /\s*Creating NBFM Jobs File\s*\'(\S+)\'/) {
          $acereg_jobsfile = $1;
        } elsif ($line =~ /\s*Creating Environment Setup File\s*\'(\S+)\'/) {
          $acereg_envsfile = $1;
        } else {
          next;
        }
      }
      # open jobs file and update its ace command with -results, thus it will be pointing to power run directory
      if ($acereg_jobsfile ne "") {
        open(ACEREGJOB, "<$acereg_jobsfile") || die "Cannot open $acereg_jobsfile for read\n",__LINE__;
        open(ACEREGJOBNEW, ">$acereg_jobsfile.new") || die "Cannot open $acereg_jobsfile.new for read\n",__LINE__;
        while (<ACEREGJOB>) {
          if (/^\s*nbjob\s+run\s+/) {
            s/$/ -results $results_dir\/power\/run_$time_stamp/;
          }
          print ACEREGJOBNEW "$_";
        }
        close ACEREGJOB;
        close ACEREGJOBNEW;
        `mv $acereg_jobsfile.new $acereg_jobsfile`;
      # quit if jobs file not found
      } else {
        print "===> " . ref($self) . " : ERROR: Unable to get Acereg NBFM Jobs File\n";
        Exit 1;
      }
      # get all env variables required by acereg and save it in %acereg_env, it will be used to update task file later
      if ($acereg_envsfile ne "") {
        open(ACEREGENV, "<$acereg_envsfile") || die "Cannot open $acereg_envsfile for read\n",__LINE__;
        while (<ACEREGENV>) {
          if (/^\s*setenv\s+(\S+)\s+(\S+)\s*$/) {
            $acereg_env{$1} = $2;
          }
        }
        close ACEREGENV;
      # quit if env setup file not found
      } else {
        print "===> " . ref($self) . " : ERROR: Unable to get Acereg Environment Setup File\n";
        Exit 1;
      }
      # open tasks file and replace all env variables with contents of %acereg_env
      if ($acereg_taskfile ne "") {
        open(ACEREGTASK, "<$acereg_taskfile") || die "Cannot open $acereg_taskfile for read\n",__LINE__;
        while (<ACEREGTASK>) {
          if (/\$\{(\S+)\}/) {
            my $evar = $1;
            if (exists $acereg_env{$evar} && $acereg_env{$evar} ne "") {
              s/\$\{\S+\}/$acereg_env{$evar}/;
            } else {
              print "===> " . ref($self) . " : ERROR: Env variable '$evar' is not defined in Acereg Environment Setup File\n";
              Exit 1;
            }
          }
          # no need to define separate WorkArea for RTL simulation
          next if (/^\s*WorkArea\s+\S+$/);
          # save all the tasks thus can be integrated into power taskfile later
          push @acereg_tasks, $_;
        }
        close ACEREGTASK;
      # quit if tasks file not found
      } else {
        print "===> " . ref($self) . " : ERROR: Unable to get Acereg NBFM Task File\n";
      }
    }
##### JS  fix UPF issue in DC
#	if ((defined $ENV{ACE_RTL_SIM}) && ($ENV{ACE_RTL_SIM} eq "vcs" ))      {
#	    delete $ENV{ACE_RTL_SIM};
#	}
####
    # create NBFM task file for power estimation flow
    my @tasks;
    my @syn_tasks;
    my $taskfile = "$results_dir/power/run_${time_stamp}/power.taskfile";
    open(TASK, ">$taskfile") || die "Cannot open $taskfile for write\n",__LINE__;
    print TASK "Task power_${whoami}_${time_stamp} {\n";
    print TASK "  SubmissionArgs --exec-limits 23h:24h\n";
    print TASK "  WorkArea $results_dir/power/run_$time_stamp\n";
    print TASK "  Queue $nbpool {\n";
    print TASK "    Qslot $nbqslot\n";
    print TASK "  }\n";
    # print RTL simulation section, if -pre_sim is undefined and there is is need to run simulation
    if ($pre_sim eq "") {
      # print simulation tasks that saved earlier into power taskfile
      foreach my $line (@acereg_tasks) {
        print TASK "  $line";
        if ($line =~ /^\s*Task\s+(\S+)\s*$/) {
          # save the taskname thus it can be used to set dependency later
          push @tasks, "$1";
        }
      }
    }
    # print RTL synthesis section
    foreach my $u_top (keys %unit) {
      foreach my $u_topi (keys %{$unit{$u_top}}) {
        if ($u_topi eq "valid") {
          delete $unit{$u_top}{$u_topi};
          next;
        }
        if ($unit{$u_top}{$u_topi}{synthesis} == 0) {
          my $u_top_upf = "";
          if (-e "$model_root/tools/upf/cpef/${u_top}.upf") {
            $u_top_upf = "$model_root/tools/upf/cpef/${u_top}.upf";
          }
          # each synthesis is assigned as one task
          print TASK "  Task Synthesis_${whoami}_${time_stamp}_${model}_$u_topi {\n";
          print TASK "    Jobs {\n";
          print TASK "      nbjob run u_syn_on_nb.pl $u_top /netbatch/syn_${whoami}_run_${time_stamp}/$u_topi $pvt $cpefDCversion $unit{$u_top}{$u_topi}{com_file} $unit{$u_top}{$u_topi}{hier} $unit{$u_top}{$u_topi}{syn_dir} $u_top_upf\n";
          print TASK "    }\n";
          print TASK "  }\n";
          # save the taskname thus it can be used to set dependency later
          push @syn_tasks, "Synthesis_${whoami}_${time_stamp}_${model}_$u_topi";
        }
      }
    }
    # print check_synthesis_output section
    print TASK "  Task check_synthesis_output_${whoami}_${time_stamp} {\n";
    # print all the dependent synthesis tasks that must be completed before running check_synthesis_output
    foreach my $st (@syn_tasks) {
      print TASK "    DependsOn $st\[OnComplete\]\n";
    }
    print TASK "    Jobs {\n";
    print TASK "      nbjob run check_synthesis_output $results_dir/power/run_${time_stamp}\n";
    print TASK "    }\n";
    print TASK "  }\n";
    # save the taskname thus it can be used to set dependency later
    push @tasks, "check_synthesis_output_${whoami}_${time_stamp}";
    # print PTPX section
    print TASK "  Task PTPX_${whoami}_${time_stamp} {\n";
    # print all the dependent tasks that must be completed before running PTPX
    foreach my $t (@tasks) {
      print TASK "    DependsOn $t\[OnComplete\]\n";
    }
    print TASK "    Jobs {\n";
    my $local_run_ptpx_cmd = "nbjob run run_ptpx.pl -power_dir $results_dir/power/run_$time_stamp -pvt $pvt -pt_ver $cpefPTversion -syn_lib_prefix $cpefSYNlibprefix -ip_name $cluster -vt_type $cpefSYNprocess -soc_proj $cpefSoCproject -lib_type $cpefSYNlibtype"; 
    # if -pre_sim defined, get the simulation path info from defined location
    if ($pre_sim ne "") {
      $local_run_ptpx_cmd .= " -pre_sim $pre_sim";
    }
    # if $ref_milestone defined, include -ref_milestone in command line
    if ($ref_milestone ne "") {
      $local_run_ptpx_cmd .= " -ref_milestone $ref_milestone";
    }
    print TASK "      $local_run_ptpx_cmd\n";
    print TASK "    }\n";
    print TASK "  }\n";
#    # print CGE section
#    print TASK "  Task CGE_${whoami}_${time_stamp} {\n";
#    # print all the dependent tasks that must be completed before running CGE
#    foreach my $t (@tasks) {
#      print TASK "    DependsOn $t\[OnComplete\]\n";
#    }
#    print TASK "    Jobs {\n";
#    my $local_run_cge_cmd = "nbjob run run_cge.pl -power_dir $results_dir/power/run_$time_stamp -pvt $pvt";
#    if ($ref_milestone ne "") {
#      $local_run_cge_cmd .= " -ref_milestone $ref_milestone";
#    }
#    # if -pre_sim defined, get the simulation path info from defined location
#    if ($pre_sim ne "") {
#      $local_run_cge_cmd .= " -pre_sim $pre_sim";
#    }
#    print TASK "      $local_run_cge_cmd\n";
#    print TASK "    }\n";
#    print TASK "  }\n";
    print TASK "}\n";
    close TASK;
    # check if each test has the required power do file, there is no point to run the flow if do file is not ready
    print "===> " . ref($self) . " : INFO: Checking power do file in each test source directory\n";
    my $test_dir;
    # if user define testlist
    if (defined $testlist && scalar @{$self->get_option(-testlist)} > 0) {
      my $ace_dump_testlist = "";
      # go through each testlist
      foreach my $tl (@{$self->get_option(-testlist)}) {
        my $dump_list = "";
        # running ace -dump_testlist command to dump the test info into @testlist array file
        $ace_dump_testlist = `ace -dump_testlist -tl $tl`;
        # get the path of @testlist array file
	if ($ace_dump_testlist =~ /\s*Dumping testlist to dump file\s*\'(\S+)\'/) {
          $dump_list = $1;
        # quit if @testlist array file not available
        } else {
          print "===> " . ref($self) . " : ERROR: Unable to dump testlist $tl into dump file\n";
          Exit 1;
        }
        # read in the @testlist array file generated
        our @testlist = ();
        require "$dump_list";
        # get number of tests
        my $num_of_test = scalar @testlist;
        # loop through each test using for loop
        for (my $i = 0; $i < $num_of_test; $i++) {
          foreach my $clt (keys %{$testlist[$i]}) {
            foreach my $f (keys %{$testlist[$i]{$clt}}) {
              # -test has partial path of test source directory
              if ($f eq "-test") {
                $test_dir = ${$testlist[$i]{$clt}}{$f};
                # get rid of the unwanted seed number in partial path
                $test_dir =~ s/\:.*$//g;
                # find the actual full path of test source directory, quit if cannot be found
                $test_dir = $sp->find_directory(
                  -dir  => $test_dir,
                  -scope => $cluster,
                  -type => 'tests',
                  -exit_on_failure => 1,
                  -exit_msg => "ERROR: Unable to locate test directory '$test_dir'",
                );
                # quit if required do file not exists
                if (!-e "$test_dir/power_cfg$config.do") {
                  print "===> " . ref($self) . " : ERROR: power_cfg$config.do not found under $test_dir\n";
                  Exit 1;
                }
              }
            }
          }
        }
      }
    # if user define single test only
    } else {
      # find the actual full path of test source directory, quit if cannot be found
      $test_dir = $sp->find_directory(
        -dir  => $testname1,
        -scope => $cluster,
        -type => 'tests',
        -exit_on_failure => 1,
        -exit_msg => "ERROR: Unable to locate test directory '$testname1'",
      );
      # quit if required do file not exists
      if (!-e "$test_dir/power_cfg$config.do") {
        print "===> " . ref($self) . " : ERROR: power_cfg$config.do not found under $test_dir\n";
        Exit 1;
      }
    }
    # dump %unit hash for run_ptpx.pl use
    &dumpHash("$results_dir/power/run_${time_stamp}/unit.hash", \%unit, "unit");
    # if -nonb defined, run everything on local machine in sequent
    if ($nonb) {
      # if -pre_sim undefined, run simulation
      if ($pre_sim eq "") {
        my $ace_cmd;
        print "===> " . ref($self) . " : INFO: Running test in sequent - -local is 1\n";
        # if user define testlist, run ace -tl
        if (defined $testlist && scalar @{$self->get_option(-testlist)} > 0) {
          $ace_cmd = "ace -power_en $time_stamp -x -m $model -cfg $config -results $results_dir/power/run_${time_stamp} -tl \"";
          foreach my $tl (@{$self->get_option(-testlist)}) {
            $ace_cmd .= " $tl";
          }
          $ace_cmd .= " \"";
          $ace_cmd .= " -seed $seed" if ($seed ne "");
        # if user define single test only, run ace -t
        } else {
          if ($cpefdo ne "") {
            $ace_cmd = "ace -power_en $time_stamp -x -m $model -cfg $config -results $results_dir/power/run_${time_stamp} -t $testname -tid_use_custom_name $testname2 -user_do_files_vcs $cpefdo";
          } else {
            $ace_cmd = "ace -power_en $time_stamp -x -m $model -cfg $config -results $results_dir/power/run_${time_stamp} -t $testname -tid_use_custom_name $testname2";
          }
          $ace_cmd .= " -seed $seed" if ($seed ne "");
        }
        print "===> " . ref($self) . " : INFO: $ace_cmd\n";
        `$ace_cmd`;
        # quit if error found in simulation
        if ($? != 0) {
          print "===> " . ref($self) . " : ERROR: Error(s) found in RTL simulation\n";
          Exit 1;
        }
      }
      # run unit-level synthesis
      print "===> " . ref($self) . " : INFO: Running unit-level synthesis in sequent - -local is 1\n";
      foreach my $u_top (keys %unit) {
        foreach my $u_topi (keys %{$unit{$u_top}}) {
          if ($u_topi eq "valid") {
            delete $unit{$u_top}{$u_topi};
            next;
          }
          if ($unit{$u_top}{$u_topi}{synthesis} == 0) {
            my $u_top_upf = "";
            if (-e "$model_root/tools/upf/cpef/${u_top}.upf") {
              $u_top_upf = "-upf_file $model_root/tools/upf/cpef/${u_top}.upf";
            }
            print "===> " . ref($self) . " : INFO: $ENV{REGGIE_HOME}/bin/reggie -b $u_top -r /netbatch/syn_${whoami}_run_${time_stamp}/$u_topi -mod syn,quick_apr -nco -local -lab $pvt -tv designcompiler:$cpefDCversion -comfile $unit{$u_top}{$u_topi}{com_file} -inst $unit{$u_top}{$u_topi}{hier} -syn_dir $unit{$u_top}{$u_topi}{syn_dir} $u_top_upf -sfo $ENV{CPEF_SYN_SFO} \n"  ;
            `rm -fr /netbatch/syn_${whoami}_run_${time_stamp}/$u_topi` if (-d "/netbatch/syn_${whoami}_run_${time_stamp}/$u_topi");
            `mkdir -p -m 2750 /netbatch/syn_${whoami}_run_${time_stamp}/$u_topi`;
            `$ENV{REGGIE_HOME}/bin/reggie -b $u_top -r /netbatch/syn_${whoami}_run_${time_stamp}/$u_topi -sfo "syn:$ENV{CPEF_SYN_SFO}" -mod syn,quick_apr -nco -local -lab $pvt -tv designcompiler:$cpefDCversion -comfile $unit{$u_top}{$u_topi}{com_file} -inst $unit{$u_top}{$u_topi}{hier} -syn_dir $unit{$u_top}{$u_topi}{syn_dir} $u_top_upf`;
          }
        }
      }
      # run PTPX
      # delay 10 secs to make sure all writing to NFS disk is done
      sleep 10;
      print "===> " . ref($self) . " : INFO: Running PTPX in sequent - -local is 1\n";
      my $ptpx_cmd = "run_ptpx.pl -power_dir $results_dir/power/run_$time_stamp -pvt $pvt -pt_ver $cpefPTversion -syn_lib_prefix $cpefSYNlibprefix -ip_name $cluster -vt_type $cpefSYNprocess -soc_proj $cpefSoCproject -lib_type $cpefSYNlibtype -nonb"; 
      # if -pre_sim defined, get the simulation path info from defined location
      if ($pre_sim ne "") {
        $ptpx_cmd .= " -pre_sim $pre_sim";
      }
      # if $ref_milestone defined, include -ref_milestone in command line
      if ($ref_milestone ne "") {
        $ptpx_cmd .= " -ref_milestone $ref_milestone";
      }
      # run run_ptpx.pl script on local machine
      print "===> " . ref($self) . " : INFO: $ptpx_cmd\n";
      `$ptpx_cmd`;
#      print "===> " . ref($self) . " : INFO: Running CGE in sequent - -local is 1\n";
#      my $cge_cmd = "run_cge.pl -power_dir $results_dir/power/run_$time_stamp -pvt $pvt -nonb";
#      if ($ref_milestone ne "") {
#        $cge_cmd .= " -ref_milestone $ref_milestone";
#      }
#      # if -pre_sim defined, get the simulation path info from defined location
#      if ($pre_sim ne "") {
#        $cge_cmd .= " -pre_sim $pre_sim";
#      }
#      # run run_cge.pl script on local machine
#      print "===> " . ref($self) . " : INFO: $cge_cmd\n";
#      `$cge_cmd`;
    # if -local is undefined, by default call NBFM command to run all tasks on NB
    } else {
      my $nbcmd = "";
      print "===> " . ref($self) . " : INFO: Running all tasks on NB\n";
      # use nbfeeder list to check if there is any active feeder running
      my @nbfeeder_list = `nbfeeder list`;
      # if active feeder found
      if (scalar @nbfeeder_list > 0) {
        my $nbfeeder_host = $ENV{HOSTNAME};
        my $current_host = $nbfeeder_host;
        $current_host =~ s/\..*$//;
        foreach my $f (@nbfeeder_list) {
          # only look for active feeder
          if ($f =~ /\s*(\S+)\:(\d+)\s*\[alive\]\s*/) {
            my $nbfeeder_list_host = $1;
            my $nbfeeder_port = $2;
            # run nbtask command instead if active feeder found on current machine
            if ($nbfeeder_list_host eq $current_host) {
              $nbcmd = "nbtask load --target $nbfeeder_host:$nbfeeder_port $taskfile";
              last;
            }
          }
        }
      }
      # by default run nbfeeder command if no active feeder found
      #$nbcmd = "nbfeeder start --task $taskfile --terminate-on-finish --task-refresh-interval 10 --update-frequency 60" if ($nbcmd eq "");
      $nbcmd = "nbfeeder start --task $taskfile --task-refresh-interval 10 --update-frequency 60" if ($nbcmd eq "");
      print "===> " . ref($self) . " : INFO: $nbcmd\n";
      `$nbcmd`;
      # if error found while running nbfeeder, quit and remove the power run directory created
      if ($? != 0) {
        print "===> " . ref($self) . " : ERROR: nb command exit with error, jobs are not submitted\n";
        chdir("$model_root") || die "Cannot chdir to $model_root\n",__LINE__;
#        `rm -fr $results_dir/power/run_${time_stamp}`;
        Exit 1;
      }
    }
  #-------------------------------------------------------------------------------
  # to check the unit-level synthesis com file and update it accordingly
  #-------------------------------------------------------------------------------
  sub check_com_file {
    my $self = shift;
    my $u_top = shift;
    my $u_syn_dir = shift;
    my $uls_saif = shift;
    my $power_dir = shift;
    my $num = shift;
    my $u_hier = shift;
    my $u_topi = "$u_top$num";
    my $u_com_file = "$model_root/tools/cpef/com/$u_top.comm";
    my $u_clk_file = "$model_root/tools/cpef/clock/$u_top.clkdef.default.sdc";
    my $u_tcon_file = "$model_root/tools/cpef/tcon/$u_top.tcon.default.sdc";
    if ($scenario ne "" && -e "$model_root/tools/cpef/clock/$u_top.clkdef.${scenario}.sdc") {
      # look for scenario synthesis clock file
      $u_clk_file = "$model_root/tools/cpef/clock/$u_top.clkdef.${scenario}.sdc";
      print "===> " . ref($self) . " : INFO: Using $scenario clock file for $u_top : $u_clk_file\n";
    } else {
      # look for default synthesis clock file
      if (!-e $u_clk_file) {
        print "===> " . ref($self) . " : WARNING: No default clock file found for $u_top\n";
      } else {
        print "===> " . ref($self) . " : INFO: Using default clock file for $u_top\n";
      }
    }
    if ($scenario ne "" && -e "$model_root/tools/cpef/tcon/$u_top.tcon.${scenario}.sdc") {
      # look for scenario synthesis tcon file
      $u_tcon_file = "$model_root/tools/cpef/tcon/$u_top.tcon.${scenario}.sdc";
      print "===> " . ref($self) . " : INFO: Using $scenario tcon file for $u_top : $u_tcon_file\n";
    } else {
      # look for default synthesis tcon file
      if (!-e $u_tcon_file) {
        print "===> " . ref($self) . " : WARNING: No default tcon file found for $u_top\n";
      } else {
        print "===> " . ref($self) . " : INFO: Using default tcon file for $u_top\n";
      }
    }
    # look for default synthesis com file
    if (!-e $u_com_file || -z $u_com_file) {
      print "===> " . ref($self) . " : WARNING: No default com file found for $u_top, will create one on the fly\n";
      # look for rtllist, quit if not found
      my $path_list;
      if ($pre_sim ne "" && -e "$pre_sim/$u_top.rtllist$num") {
        $path_list = "$pre_sim/$u_top.rtllist$num";
      } elsif (-e "$power_dir/$u_top.rtllist$num") {
        $path_list = "$power_dir/$u_top.rtllist$num";
      } else {
        print "===> " . ref($self) . " : ERROR: rtllist not found, skip creating com file for $u_top\n";
        return "";
      }
      # if rtllist found
      my @path_list = `cat $path_list`;
      # create synthesis com file on the fly
      open(OUT, ">$u_syn_dir/$u_top.$num.comm") || die "Cannot open $u_syn_dir/$u_top.$num.comm for write\n",__LINE__;
      print OUT "IP Name:         $cluster\n";
      print OUT "Design name:     $u_top\n";
      print OUT "Instance name:   $u_hier\n";
      print OUT "DC_VERSION:      $cpefDCversion\n";
      print OUT "LIBRARY_NAME:    $cpefSYNlibtype\n";
      print OUT "LIBRARY_VOLTAGE: $cpefSYNlibvoltage\n";
      print OUT "VT_TYPE:         $cpefSYNprocess\n";
      print OUT "Clock file:      ";
      # print and copy the clock file if it is available
      if (-e $u_clk_file) {
        `cp $u_clk_file $u_syn_dir/$u_top.clkdef.sdc`;
        print OUT "$u_syn_dir/$u_top.clkdef.sdc\n";
      } else {
        print OUT "\n";
      }
      print OUT "Constraint file: ";
      my @constraint_list = ();
      # include $uls_saif as constraint files
      push @constraint_list, $uls_saif if (-e "$uls_saif");
      # include and copy the tcon file if it is available
      if (-e $u_tcon_file) {
        `cp $u_tcon_file $u_syn_dir/$u_top.tcon.sdc`;
        push @constraint_list, "$u_syn_dir/$u_top.tcon.sdc";
      }
      if (scalar @constraint_list < 1) {
        print OUT "\n";
      } elsif (scalar @constraint_list == 1) {
        print OUT "$constraint_list[0]\n";
      } else {
        foreach my $cons (@constraint_list) {
          print OUT "$cons";
          print OUT ";" if ($cons ne $constraint_list[-1]);
        }
        print OUT "\n";
      }
      print OUT "\n++RTL_list\n";
      # print all the paths in get_paths.list into synthesis com file, under ++Lib_list
      foreach my $p (@path_list) {
        chomp $p;
        # skip the testbench rtl path
        #next if ($p =~ /$ENV{MODEL_ROOT}\/rtl\/$cluster\/[^\/]+clt$/ || $p =~ /$ENV{MODEL_ROOT}\/rtl\/$cluster\/[^\/]+clt_sv$/);
        #next if ($p =~ /$ENV{MODEL_ROOT}\/rtl\/([^\/]+)\/([^\/]+)/ && $1 ne "design_libs" && $1 eq "$cluster" && $2 ne "$unit" && ($cluster ne "usb3fe" && $p !~ /xhci_fl/));
        #next if ($p =~ /$ENV{MODEL_ROOT}\/rtl\/([^\/]+)\/[^\/]+/ && $1 ne "design_libs" && $1 ne "$cluster");
        #next if ($p =~ /\/sbcl\/|\/usbphy_sbcl\/|\/usbhsip_afe\/|\/usb2_schima\/|ich_bga_trk|ucest_udest_trk|usbe_trackers|\/DW.*|\/linktrk\//);
        next if ($p =~ /\/usbhsip_afe\/|\/usb2_schima\/|ich_bga_trk|ucest_udest_trk|usbe_trackers|\/DW.*|\/linktrk\//);
        #next if ($p =~ /\/xbuf_lib\// && $p !~ /\/xbuf_lib\/rtl\/[a-z]/);
        next if ($p =~ /\/hip\/ckts\// && $p !~ /pchmem_lpt/ && $p !~ /\/drng_nhm_macros\.sv/);
        next if ($p =~ /\/verif\//); # YY
        # skip the avc paths
        #if ($p !~ /\/avc\// && ($p =~ /design_libs/ || $p =~ /\/hip\/ckts\// || $p =~ /$ENV{MODEL_ROOT}\/rtl\// || $p =~ /$ENV{SIP_ROOT}\//)) {
        #  print OUT "\@${p}\n";
        #}
        print OUT "$p\n";
      }
      print OUT "$model_root/verif/cfg_env/common/include/sv_macros.sv\n" if (-e "$model_root/verif/cfg_env/common/include/sv_macros.sv");
	#  workaround manually add missing RTL
      close OUT;
      return "$u_syn_dir/$u_top.$num.comm";
    # if default synthesis com file found, update it
    } else {
      open(IN, "<$u_com_file") || die "Cannot open $u_com_file for read\n",__LINE__;
      open(OUT, ">$u_syn_dir/$u_top.$num.comm") || die "Cannot open $u_syn_dir/$u_top.$num.comm for write\n",__LINE__;
      my $constraint_found = 0;
      my $constraint_files = "";
      my @valid_cons_files = ();
      my @cons_files = ();
      my $clock_file_found = 0;
      my $clock_file_files = "";
      my @valid_clks_files = ();
      my @clks_files = ();
      while (my $line = <IN>) {
        chomp $line;
        # check the constraint defined in default synthesis com file
        if ($line =~ /^\s*Constraint file\s*\:/) {
          $constraint_files = $line;
          $constraint_files =~ s/^\s*Constraint file\s*\://g;
          $constraint_files =~ s/\s*//g;
          if ($constraint_files ne "") {
            @cons_files = split(/\;/, $constraint_files);
            foreach my $cons (@cons_files) {
              # check if the constraint file is valid
              if (!-e $cons) {
                print "===> " . ref($self) . " : WARNING: $cons is not accessible\n";
              # increase constraint file count if it is valid
              } else {
                $constraint_found++;
                push @valid_cons_files, $cons;
              }
            }
          }
          push @valid_cons_files, $uls_saif if (-e "$uls_saif");
          # if no constraint file defined in default synthesis com file
          if ($constraint_found == 0) {
            # copy and adding in tcon file if any
            if (-e $u_tcon_file) {
              print "===> " . ref($self) . " : INFO: Adding in $u_tcon_file into $u_com_file as constraint file\n";
              `cp $u_tcon_file $u_syn_dir/$u_top.tcon.sdc`;
              push @valid_cons_files, "$u_syn_dir/$u_top.tcon.sdc";
            } else {
              print "===> " . ref($self) . " : WARNING: No constraint file found for $u_top, synthesis will proceed without any constraint\n";
            }
          }
          print OUT "Constraint file :";
          foreach my $cons (@valid_cons_files) {
            print OUT "$cons";
            print OUT ";" if ($cons ne $valid_cons_files[-1]);
          }
          next;
        } elsif ($line =~ /^\s*Clock file\s*\:/) {
          $clock_file_files = $line;
          $clock_file_files =~ s/^\s*Clock file\s*\://g;
          $clock_file_files =~ s/\s*//g;
          if ($clock_file_files ne "") {
            @clks_files = split(/\;/, $clock_file_files);
            foreach my $clks (@clks_files) {
              # check if the clock file is valid
              if (!-e $clks) {
                print "===> " . ref($self) . " : WARNING: $clks is not accessible\n";
              # increase clock file count if it is valid
              } else {
                $clock_file_found++;
                push @valid_clks_files, $clks;
              }
            }
          }
          # if no clock file defined in default synthesis com file
          if ($clock_file_found == 0) {
            # copy and adding in clock file if any
            if (-e $u_clk_file) {
              print "===> " . ref($self) . " : INFO: Adding in $u_clk_file into $u_com_file as constraint file\n";
              `cp $u_clk_file $u_syn_dir/$u_top.clkdef.sdc`;
              push @valid_clks_files, "$u_syn_dir/$u_top.clkdef.sdc";
            } else {
              print "===> " . ref($self) . " : WARNING: No constraint file found for $u_top, synthesis will proceed without any constraint\n";
            }
          }
          print OUT "Clock file :";
          foreach my $clks (@valid_clks_files) {
            print OUT "$clks";
            print OUT ";" if ($clks ne $valid_clks_files[-1]);
          }
          next;
        } else {
          print OUT "$line\n";
        }
      }
      close IN;
      close OUT;
      return "$u_syn_dir/$u_top.$num.comm";
    }
  }
  # if -power is not defined
  } else {
    print "===> " . ref($self) . " : INFO: Skipping power estimation - -power is 0\n";
  }
  Exit;
  return "";
}
#-------------------------------------------------------------------------------
# check if the synthesis dir valid for RTL unit
#-------------------------------------------------------------------------------
sub verify_syn_dir {
  my $u_top = shift;
  my $syn_dir = shift;
  my $status = 0;
  my $syn_err = 0;
  # return status 1 if netlist not found
  if (!-e "$syn_dir/outputs/${u_top}.syn_final.vg") {   ## ${u_top}.unit_syn.vg
    $status = 1;
  }
  if (-e "$syn_dir/logs/dc.log") {    ## ${u_top}.unit_syn.log
    # return syn_err 1 if error found in synthesis log file
    my @syn_err = `grep Error $syn_dir/logs/dc.log`;
    if (scalar @syn_err > 0) {
      $syn_err = 1;
    }
  # return status 2 if synthesis log file not found
  } else {
    $syn_err = 2;
  }
  return ($status, $syn_err);
}
#-------------------------------------------------------------------------------
# to dump HASH information into file in HASH structure, &dumpHash(<outfile>, \%<hashname>, "<hashname>");
#-------------------------------------------------------------------------------
sub dumpHash {
  my $outfile = shift;
  my $hash = shift;
  my $hashname = shift;
  open(DUMP, ">$outfile") || die "Can't write to $outfile!",__LINE__;
  print DUMP Data::Dumper->Dumpxs([\%{$hash}], ["*$hashname"]);
  close(DUMP);
}
#-------------------------------------------------------------------------------
sub pre_sim_run_hook {
  my ($self, %args) = @_;
  my ($cur_scope, $top_scope, $base_scope) = ($args{-cur_scope}, $args{-top_scope}, Ace::UDF::get_base_scope());
  my $test_data = $args{-test_data};
  my $tid = $test_data->{$base_scope}{tid};

  my $fragment = '';
  if ($self->get_option(-enable_pre_sim_run_hook)) {
    $fragment .= "echo ===========================================\n";
    $fragment .= "echo  Running pre_sim_run_hook\n";
    $fragment .= "echo ===========================================\n";
    # -----------------------------------------------------------------
    # Put your code here...
    
#    # -----------------------------------------
#    # Example code to set LD_LIBRARY_PATH env
#    # -----------------------------------------
#    my $simulator = $self->get_option(-simulator);
#    my $os = Ace::OSData->get_os();
#    my $cpu;
#    my $fsb_bfm_lib;  # Location of FSB-SO fil
#  
#    if ($ENV{VCS_TARGET_ARCH} eq 'suse64') {
#      $cpu = "x86_64";
#      $fsb_bfm_lib = "$self->{_libdirs}{$simulator}/pnw_core_bfm_lib/$os/$cpu:$ENV{SOC_ROOT}/ip_libs/pnw_core_bfm/libs_64";  # Location of FSB-SO fil
#    }
#    elsif ($ENV{VCS_TARGET_ARCH} eq 'suse32') {
#      $cpu = "i686";
#      $fsb_bfm_lib = "$self->{_libdirs}{$simulator}/pnw_core_bfm_lib/$os/$cpu:$ENV{SOC_ROOT}/ip_libs/pnw_core_bfm/libs";  # Location of FSB-SO fil
#    }
#    else {
#      print "\n====ERROR: slsmem is not supported on this platform $ENV{VCS_TARGET_ARCH}====\n";
#      exit 1; 
#    }
#
#    my $slsmem = "$self->{_libdirs}{$simulator}/slsmem/$os/$cpu";  # Location of libslsmem.so
#    my $wmt_chk = "$self->{_libdirs}{$simulator}/wmt_chk/$os/$cpu";  # Location of libWMT_checker.so
#    $fragment .= Ace::GenericScrag::set_envvar("LD_LIBRARY_PATH", "${slsmem}:${wmt_chk}:${fsb_bfm_lib}:$ENV{LD_LIBRARY_PATH}");
#    
#    # -----------------------------------------
#    # Example code to create some files in the run directory
#    # -----------------------------------------
#    $fragment 	.= <<EOS;
#
## -----------------------------------------------------------
#rm -f vsim_log
#rm -f TRK_*.out
#echo cp $ENV{SOC_ROOT}/ip_libs/pnw_core_bfm/sahara.cfg .
#echo "'>>Touching DDR2 Output Files'"
#mkdir memory_in
#echo mv dram_mem1.in memory_in/dram_mem.in
##checkrc COPY_DRAM_MEM
#touch memory_in/eccerr_data.in
#touch memory_in/odts_data_a.in
#touch memory_in/odts_data_b.in
#mkdir memory_out
#echo "'>>Done touching DDR2 Output Files'"
#EOS
   
    # -----------------------------------------------------------------
    # End of your code
    # -----------------------------------------------------------------
    $fragment .= "echo ===========================================\n";
    $fragment .= "echo Finished pre_sim_run_hook\n";
    $fragment .= "echo ===========================================\n";
  }
  return $fragment;
}
#-------------------------------------------------------------------------------
sub post_sim_run_hook {
  my ($self, %args) = @_;
  my ($cur_scope, $top_scope, $base_scope) = ($args{-cur_scope}, $args{-top_scope}, Ace::UDF::get_base_scope());
  my $test_data = $args{-test_data};
  my $tid = $test_data->{$base_scope}{tid};

  my $fragment = '';
  if ($self->get_option(-enable_post_sim_run_hook)) {
    $fragment .= "echo ===========================================\n";
    $fragment .= "echo  Running post_sim_run_hook\n";
    $fragment .= "echo ===========================================\n";
    # -----------------------------------------------------------------
    # Put your code here...

    ## ---------------------------------------------------
    ## Call poulsbo testcheck routines
    ## ---------------------------------------------------
    #my $workdir		= $test_data->{$base_scope}{workdir};
    #my $testrun_dir       = $test_data->{$cur_scope}{testrun_dir};
    #my $log               = $args{-logfile};
    #
    #my $testlib_libdir = $self->find_dir("testlib", $cur_scope);
    #my $checker_script = $self->find_executable("bin/svnorthc_testcheck.pl", $cur_scope);
    #my $cmd = "perl -I$testlib_libdir $checker_script $workdir/$testrun_dir $testrun_dir";
    #$fragment .= "ln -s $log vsim_log\n";
    #$fragment .= Ace::GenericScrag::add_cmd("NORTH_CHECKER", $cmd);

    # -----------------------------------------------------------------
    # End of your code
    # -----------------------------------------------------------------
    $fragment .= "echo ===========================================\n";
    $fragment .= "echo Finished post_sim_run_hook\n";
    $fragment .= "echo ===========================================\n";
  }
  return $fragment;
}
#-------------------------------------------------------------------------------
1;
