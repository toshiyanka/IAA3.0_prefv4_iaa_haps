#-*-perl-*-
#--------------------------------------------------------------------------------
package common::GetPaths;
use strict;
use FileHandle;
use Carp;
use Storable qw(dclone);
use sort 'stable';
require "dumpvar.pl";

use Utilities::ProgramTools qw(check_args test_eval set_difference safe_dclone);
use Utilities::Print;
use Utilities::System qw(Exit Mkpath);
use Data::Dumper;
use File::Basename;
use Ace::Misc;
use Ace::Graph;

use vars qw(@ISA @EXPORT_OK);
use Ace::GenericScrag qw($CWD add_cmd);
use Ace::WorkModules::HDL;
use Ace::AceRC;

require Exporter;
@ISA = qw(Exporter Ace::WorkModules::HDL Ace::GenericScrag);

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
    /^getpaths$/ && do { return $self->run_get_paths(%args); };
    $self->_unknown_ace_command_error($_);
  }
}
#-------------------------------------------------------------------------------
# implement run_build_dvt
#-------------------------------------------------------------------------------
sub run_get_paths {
  my ($self, %args) = @_;
  my $scope             = $self->get_scope();
#  my ($libs, $testsets) = $self->populate_library_hash($scope);
  my $designDB          = $self->get_designDB();
  $designDB->create_default_modelviews(-resolve => 1, -exit_on_error => 1);
  my $spechash          = $designDB->get_modelview($Ace::DesignDB::COMPILE_VIEW);
  my $libs              = $spechash->{resolved}{libs};
  my $testsets          = $spechash->{resolved}{testsets};
  my @liblist           = Ace::Misc::alphabetize($libs, '-dependent_libs');
  my @testsetlist       = Ace::Misc::alphabetize($testsets, '-dependent_libs') if (defined $testsets);
  my $global_vlog_opts  = $self->get_option('-vlog_opts');
#  my $global_vcom_opts  = $self->get_option('-vcom_opts');
  my $results_dir       = $self->get_option(-getpaths_outdir);
  my %libhash;
#  my $filelist_f_path   = "$results_dir/dvt/filelist_f";
  my $fragment = "";

  if (!defined $results_dir || $results_dir eq "") {
    $results_dir = $self->get_option(-results);
  }
print STDERR "\n\n\n\$results_dir = >$results_dir<\n\n\n\n";
  Mkpath("$results_dir", 0775) unless -d $results_dir;
  unless (-d $results_dir) {
    Exit 1, "$results_dir directory is not created\n";
  }
  get_all_lib_files($libs, \@liblist);
  get_all_lib_files($testsets, \@testsetlist);
  gen_output(%args);
#  create_all_libs_filelist_f(%args);
#  execute_dvt(%args);

  sub get_all_lib_files {
    my ($libs_hash, $liblist_array) = @_;
    my @liblist = @{$liblist_array};
    foreach my $l (@liblist) {
      my $libspec = $libs_hash->{$l};
      my $libname = $l;
      my $enable_sublibs = $self->get_option(-enable_sub_libraries);
      my $has_sublibs = $self->_has_sublibs($libspec);
      if ($enable_sublibs && $has_sublibs) {
        foreach my $sublib (@{$$libspec{-sub_libs}}) {
          if (defined $$libspec{-sub_lib_hash}{$sublib}) {
            get_lib_files(
                                         -libname=>$libname,
                                         -sublibname=>$sublib,
                                         -libspec=>$$libspec{-sub_lib_hash}{$sublib},
                                         -libs_hash => $libs_hash,
                                        );
          }
        }
        get_lib_files(
                                     -libname=>$libname,
                                     -sublibname=>$libname,
                                     -libspec=>$libspec,
                                     -libs_hash => $libs_hash,
                                    );
      } else {  
        get_lib_files(
                                     -libname=>$libname,
                                     -sublibname=>$libname,
                                     -libspec=>$libspec,
                                     -libs_hash => $libs_hash,
                                    );
      }
    }
  }

  sub get_lib_files {
    my (%args) = @_;
    check_args( \%args,
            -require  => [qw(-libname -sublibname -libspec -libs_hash)],
          );
    my ($libname, $sublibname, $libspec) = ($args{-libname}, $args{-sublibname}, $args{-libspec});
    my $libs_hash = $args{-libs_hash};
    my $is_sublib;
    if ($libname ne $sublibname) {
      $is_sublib = 1;
      $libname = $sublibname;
    }
    else {
      $is_sublib = 0;
    }
    if (exists $$libspec{-vlog_files} && scalar(@{$$libspec{-vlog_files}})>0 ) {
      @{$libhash{$libname}{vlog_incdirs}} = map($self->find_dir($_), @{$$libspec{-vlog_incdirs}});
      @{$libhash{$libname}{vlog_files}} = map($self->find_file($_), @{$$libspec{-vlog_files}});
      unless ($is_sublib) {
        @{$libhash{$libname}{dependent_libs}} = map("${_}", @{$$libspec{-dependent_libs}});
      }
      if (defined $$libspec{-vlog_opts}) {
        foreach my $vlogopt (@{$$libspec{-vlog_opts}}) {
          if ($vlogopt =~ /\+incdir\+(\S+)/) {
            my @incdir = split(/\+/,$1);
            foreach my $dir (@incdir) {
              chomp $dir;
              push @{$libhash{$libname}{vlog_incdirs}}, $dir;
            }
          }
        }
      }
      if (defined $global_vlog_opts) {
        foreach my $vlogopt (@{$global_vlog_opts}) {
          if ($vlogopt =~ /\+incdir\+(\S+)/) {
            my @incdir = split(/\+/,$1);
            foreach my $dir (@incdir) {
              chomp $dir;
              push @{$libhash{$libname}{vlog_incdirs}}, $dir;
            }
          }
        }
      }
    }
    if (exists $$libspec{-vhdl_files} && scalar(@{$$libspec{-vhdl_files}})>0 ) {
      @{$libhash{$libname}{vhdl_files}} = map($self->find_file($_), @{$$libspec{-vhdl_files}});
#      if (defined $$libspec{-vcom_opts} || defined $global_vcom_opts) {
#        push @{$libhash{$libname}{vcom_opts}}, @{$$libspec{-vcom_opts}} if defined $$libspec{-vcom_opts};
#        push @{$libhash{$libname}{vcom_opts}}, @{$global_vcom_opts} if defined $global_vcom_opts;
#      }
    }
#&dumpHash("libhash", \%libhash, "libhash");
  }

  sub gen_output {
    my (%args) = @_;
    &dumpHash("$results_dir/$scope.libhash", \%libhash, "libhash");
  }

#  sub create_all_libs_filelist_f {
#    my (%args) = @_;
#    my $lib_filelist_f = "$filelist_f_path/$scope.f";
#    open FH, ">$lib_filelist_f" or die "could not open $lib_filelist_f";
#    print FH "+dvt_keyword_set+1800-2009\n";
#    foreach my $lib (keys %libhash) {
#      if (exists $libhash{$lib}{vlog_opts} && scalar @{$libhash{$lib}{vlog_opts}} > 0 && exists $libhash{$lib}{vlog_files} && scalar @{$libhash{$lib}{vlog_files}} > 0) {
#        my %encountered = ();
#        foreach my $vlogopt (@{$libhash{$lib}{vlog_opts}}) {
#          chomp $vlogopt;
#          $vlogopt =~ s/\\<vcs\\>//g;
#          print FH " $vlogopt" if (!exists $encountered{$vlogopt});
#          $encountered{$vlogopt} = 1;
#        }
#        if (exists $libhash{$lib}{vlog_incdirs} && scalar @{$libhash{$lib}{vlog_incdirs}} > 0) {
#          foreach my $vlogincdir (@{$libhash{$lib}{vlog_incdirs}}) {
#            chomp $vlogincdir;
#            print FH " +incdir+$vlogincdir" if (!exists $encountered{$vlogincdir});
#            $encountered{$vlogincdir} = 1;
#          }
#        }
#        foreach my $vlogfile (@{$libhash{$lib}{vlog_files}}) {
#          chomp $vlogfile;
#          print FH " $vlogfile";
#        }
#        print FH "\n";
#      }
#      if (exists $libhash{$lib}{vhdl_files} && scalar @{$libhash{$lib}{vhdl_files}} > 0) {
#        my %encountered = ();
#        if (exists $libhash{$lib}{vcom_opts} && scalar @{$libhash{$lib}{vcom_opts}} > 0) {
#          foreach my $vcomopt (@{$libhash{$lib}{vcom_opts}}) {
#            chomp $vcomopt;
#            print FH " $vcomopt" if (!exists $encountered{$vcomopt});
#            $encountered{$vcomopt} = 1;
#          }
#        }
#        foreach my $vhdlfile (@{$libhash{$lib}{vhdl_files}}) {
#          chomp $vhdlfile;
#          print FH " $vhdlfile" if (!exists $encountered{$vhdlfile});
#          $encountered{$vhdlfile} = 1;
#        }
#        print FH "\n";
#      }
#    }
#    if (-z "$lib_filelist_f") {
#      `rm -f $lib_filelist_f`;
#    }
#    close FH;
#  }

#  sub execute_dvt {
#    my (%args) = @_;
#    my $dvtworkspace = "$results_dir/dvt/workspace";
#    my $dvtproject = "$results_dir/dvt/project";
#    my $lib_filelist_f = "$filelist_f_path/$scope.f";
#    my $dvtcommand = "$ENV{DVT_HOME}/bin/dvt_cli.sh -workspace $dvtworkspace createSVProject $dvtproject -force -f $lib_filelist_f";
#    Mkpath("$dvtworkspace", 0775) unless -d $dvtworkspace;
#    unless (-d $dvtworkspace) {
#      Exit 1, "$dvtworkspace directory is not created\n";
#    }
#    Mkpath("$dvtproject", 0775) unless -d $dvtproject;
#    unless (-d $dvtproject) {
#      Exit 1, "$dvtproject directory is not created\n";
#    }
#    `$dvtcommand`;
#  }
  return $fragment;
}
#-------------------------------------------------------------------------------
sub _has_sublibs {
  my ($self, $libspec) = @_;
  my $enable_sublibs    = $self->get_option(-enable_sub_libraries);

  my $has_sublibs = 0;
  if ($enable_sublibs) {
    $has_sublibs = ($libspec->{-has_sublibs});
  }
  return $has_sublibs;
}
#-------------------------------------------------------------------------------
# Populates $self->{libs} with the libs used by models
#-------------------------------------------------------------------------------
sub populate_library_hash {
    my ($self, $scope) = @_;
    my $hdlspec = $self->{_udf_man}->get_udf_ref(-catagory=>"HDLSpec");
        
    my $lib_hash = $hdlspec->get_libs_by_model($scope);
    my $testset_hash = $hdlspec->get_testsets_by_model($scope);
    my $models_to_compile = $self->get_models_to_compile($scope);
    
    # Assume we compile libraries for ALL models for now
    # Build list of libraries
    my %libs = %{$self->_get_libs_in_models_to_compile($lib_hash, $models_to_compile)};
    my %testsets = %{$self->_get_libs_in_models_to_compile($testset_hash, $models_to_compile)};
  
    my $hdl_libs = $hdlspec->get_libs($scope);
    #print Data::Dumper->Dump([$hdl_libs], ["*hdl_libs"]);
  
    my $enable_sub_libraries = $self->get_option(-enable_sub_libraries);
    sub _populate_library_hash {
      my ($type, $lib_hash) = @_;
      my @liblist = keys %{$lib_hash};     # all libraries used in at least one model
      my $hdl_libs = $hdlspec->get_libs($scope); # all libs defined for the scope
      # If a lib used in a model is not defined, warn
      my @all_defined_libs = keys %{$hdl_libs};
      my @undefined_libs = set_difference(\@liblist, \@all_defined_libs);
      aprint "\n===> WARNING: libraries '@undefined_libs' are not defined, but used in models.\n\n" if scalar @undefined_libs;
    
      # may need to sort lib list to handle any VHDL dependencies...
      foreach my $lib (@liblist) {
        my $lib_scope;
        $lib_scope = (exists $$hdl_libs{$lib}{-scope}) ? $hdl_libs->{$lib}{-scope} : $scope; 
        aprint "expand_lib ------> lib $lib, in scope $lib_scope\n" if ($main::DEBUG);

        ## TODO: Figure out what to do with passing _options to this function....
        my $xlib = $hdlspec->get_expanded_lib(-lib => $lib,
                                              -lib_spec => $hdl_libs->{$lib},
                                              -scope => $lib_scope,
                                              -srcScope => $hdl_libs->{$lib}{-srcScope},
                                              -options => $self->get_global_options_obj()->get_raw_data(),
                                              -hdl_libs => $hdl_libs,
                                              );
        $self->{$type}{$lib} = $xlib;
      }
    }
    _populate_library_hash('libs', \%libs);
    _populate_library_hash('testsets', \%testsets) if ($self->get_option(-enable_testsets));

    #aprint "===> ", Data::Dumper->Dump([$hdlspec->{_expanded_libs}], ["*EXPANDED_LIBS"]);
    #aprint "==> ", Data::Dumper->Dump([$self->{'libs'}], ["*lib_hash"]); Exit;

    return ($self->{libs}, $self->{testsets});
}
#-------------------------------------------------------------------------------
sub _get_libs_in_models_to_compile {
  my ($self, $hash, $models_to_compile) = @_;
  my %libs;
  
  # Assume we compile libraries for ALL models for now
  # Build list of libraries
  my %libs;
  foreach my $model (%{$hash}) {
    next unless (grep $_ eq $model, @{$models_to_compile});
    foreach my $lib (@{$hash->{$model}}) {
      $libs{$lib} = 1;
    } 
  }
  
  return \%libs; 
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
