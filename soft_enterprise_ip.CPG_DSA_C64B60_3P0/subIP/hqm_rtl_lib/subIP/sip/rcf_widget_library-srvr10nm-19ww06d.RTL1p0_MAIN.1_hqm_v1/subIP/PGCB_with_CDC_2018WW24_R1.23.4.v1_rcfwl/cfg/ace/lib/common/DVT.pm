#-*-perl-*-
#--------------------------------------------------------------------------------
package DVT;
#use strict;
use FileHandle;
use Carp;
use Storable qw(dclone);
use sort 'stable';
require "dumpvar.pl";

use Utilities::ProgramTools qw(check_args test_eval set_difference safe_dclone);
use Utilities::Print;
use Utilities::System qw(Exit Mkpath);
use Data::Dumper;
use Mail::Mailer qw(sendmail);
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
	      -require  => [qw(-udf_manager)], # look at parent
	    );

  my $self = $class->SUPER::new(%args);
  my $udf_manager = $args{-udf_manager};
  $self->{_hdlspec} = $udf_manager->get_udf_ref(-catagory=>"HDLSpec");
  $self->{_searchpaths} = $udf_manager->get_search_paths_ref();
  
  return $self;
}
#-------------------------------------------------------------------------------
sub create_scrag {
  my ($self, %args) = @_;
  $_ = $args{-name};
  SWITCH: {
    /^dvt$/ && do { return $self->run_build_dvt(%args); };
    $self->_unknown_ace_command_error($_);
  }
}
#-------------------------------------------------------------------------------
# implement run_build_dvt
#-------------------------------------------------------------------------------
sub run_build_dvt {
  if ($ENV{COLUMNS} ne "" && $ENV{COLUMNS} >= 90) {
  } else {
    $ENV{COLUMNS} = "90";
  }
  my $banner_str = `banner 'CSME DVT.pm'`;
  print "$banner_str";

  my ($self, %args)            = @_;
  my $scope                    = $self->get_scope();
  my $models_ref               = $self->{_hdlspec}->get_libs_by_model($scope);
  my $default_model            = $self->get_option(-model);
  my $dvtcfgfile               = $self->get_option(-dvtcfg);
  my $results_dir              = $self->get_option(-results);
  my $dvtdemo                  = $self->get_option(-dvtdemo);
  my $dvtclean                 = $self->get_option(-dvtclean);
  my $dvtrefresh               = $self->get_option(-dvtrefresh); $dvtrefresh = 0 if ($dvtclean);
  my $eclipsecache             = "/tmp/$ENV{USER}/dvt_eclipsespace";
  my $dvtworkspace             = "$results_dir/dvt/workspace";
  my $dvtproject               = "$results_dir/dvt/${scope}-$ENV{ACE_PWA_DIR}";
  my $sandboxlink              = "$dvtproject/$ENV{ACE_PWA_DIR}";
  my $model_root;
  &read_dvtcfg;
  my @dvtdirs                  = (
                                  "$eclipsecache",
                                  "$dvtworkspace",
                                  "$dvtproject",
                                  "$dvtproject/.dvt",
                                 );
  my @search_path;
  my $search_paths             = $self->{_searchpaths};
  my $incdir_fulldepth         = $self->get_option(-use_incdir_fulldepth_searchpath);
  my @test_vlog_opts           = $self->get_array_option('-test_vlog_opts', -scope => $scope);
  my @test_vlog_incdirs        = $self->get_array_option('-test_vlog_incdirs', -scope => $scope);
  my $global_vlog_opts         = $self->get_option(-vlog_opts);
  my $global_vcom_opts         = $self->get_option(-vcom_opts);
  my @merged_test_vlog_opts;
  my @merged_test_vlog_incdirs;
  my $testcase_globals;
  my $enable_sublibs           = $self->get_option(-enable_sub_libraries);
  my $designDB                 = $self->get_designDB();
  $designDB->create_default_modelviews(-resolve => 1, -exit_on_error => 1);
  my $data;
  my $spechash                 = $designDB->get_modelview($Ace::DesignDB::COMPILE_VIEW);
  my $libs                     = $spechash->{resolved}{libs};
  my $testsets                 = $spechash->{resolved}{testsets};
  my @liblist                  = Ace::Misc::alphabetize($libs, '-dependent_libs');
  my @testsetlist              = Ace::Misc::alphabetize($testsets, '-dependent_libs') if (defined $testsets);
  my @libs_in_order;
  my $libs_in_order_tmp;
  my %sublibOf;
  my %libhash;
  my $build_config_xml         = "$dvtproject/.dvt/build.config.xml";
  my $expandlib = "";
  my $rebuild                  = 0;
  my $dvtcommand;
  my $fragment                 = "";
  my $date                     = `date`; chomp $date;
  my $DAemail                  = 'chong.lim.lee@intel.com';
  my $whoami                   = `whoami`; chomp $whoami;

  if ($ENV{MODEL_ROOT} ne "" && -e $ENV{MODEL_ROOT}) {
    $model_root = $ENV{MODEL_ROOT};
  } elsif ($ENV{IP_ROOT} ne "" && -e $ENV{IP_ROOT}) {
    $model_root = $ENV{IP_ROOT};
  } else {
    die "\nDVT.pm: ERROR: \$MODEL_ROOT or \$IP_ROOT are invalid\n\n";
  }

  &sendMail($DAemail, "$whoami is using DVT.pm at ## $date ##");
  &exec_dvtclean if ($dvtclean);
  &make_dvtdirs;
  &get_search_paths;
  &expand_all_libs_sub_libs($libs, \@liblist);
  &expand_all_libs_sub_libs($testsets, \@testsetlist);
  # loop through each model
  foreach my $model_name (keys %{$models_ref}) {
    my $skip_model = 0;
    if (exists $dvtcfg{-exclude_models} && scalar @{$dvtcfg{-exclude_models}} > 0) {
      foreach my $exclude_model (@{$dvtcfg{-exclude_models}}) {
        $exclude_model =~ s/\s//g;
        if ($exclude_model eq $model_name) {
          $skip_model = 1;
          last;
        }
      }
    }
    next if ($skip_model);
    @merged_test_vlog_opts       = ();
    @merged_test_vlog_incdirs    = ();
    $testcase_globals            = $self->{_hdlspec}->get_testcase_globals_from_model($model_name, $scope);
    $data                        = $designDB->get_dump_rtl( -entity => "$model_name", -include_prereqs => "1",);
    @libs_in_order               = @{$$data{-data}{-entities_order}};
    &update_libs_in_order;
    %libhash                     = ();
    &get_test_vlog_opts;
    &get_test_vlog_incdirs;
    &get_all_libs_compile_options($libs, \@liblist);
    &get_all_libs_compile_options($testsets, \@testsetlist);
    if (!-e "$dvtproject/.dvt/$model_name.build" || $dvtrefresh) {
      $rebuild = 1 if (!$dvtrefresh);
      &create_model_dot_build("$dvtproject/.dvt/$model_name.build");
      if ($model_name eq $default_model) {
        if (-e "$build_config_xml") {
          `rm -f $build_config_xml`;
          Exit 1, "\nDVT.pm: ERROR: Unable to remove existing $build_config_xml\n\n" if (-e $build_config_xml);
        }
        open FH, ">$build_config_xml" or die "\nDVT.pm: ERROR: Could not open $build_config_xml for write\n\n";
        print FH <<BUILD_CONFIG_XML;
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<build-config version="1">
  <current-build-name>$model_name</current-build-name>
</build-config>
BUILD_CONFIG_XML
        close FH;
      }
    }
    &create_dvt_command($rebuild);
  }
  Exit 0, "\nDVT.pm: INFO: Refresh of $dvtproject/.dvt completed\n\n" if ($dvtrefresh);
  `rm -f $sandboxlink` if (-l "$sandboxlink");
  `ln -s $model_root $sandboxlink`;
  &execute_dvt;
  return $fragment;

  #-------------------------------------------------------------------------------
  # read in dvtcfg perl hash
  #-------------------------------------------------------------------------------
  sub read_dvtcfg {
    if (defined $dvtcfgfile && -e $dvtcfgfile) {
      print "\nDVT.pm: INFO: Reading in $dvtcfgfile\n";
      &loadHash("$dvtcfgfile");
      $eclipsecache = $dvtcfg{-eclipsespace} if (exists $dvtcfg{-eclipsespace} && $dvtcfg{-eclipsespace} ne "");
      $dvtworkspace = $dvtcfg{-workspace} if (exists $dvtcfg{-workspace} && $dvtcfg{-workspace} ne "");
    } else {
      Exit 1, "\nDVT.pm: ERROR: Config file for DVT.pm not found! Please define it using -dvtcfg option. Exiting...\n\n";
    }
  }

  #-------------------------------------------------------------------------------
  # send an email to DA
  #-------------------------------------------------------------------------------
  sub sendMail {
    my ($mailTo,$subject,$msg,$contentType) = @_;
    my $mail = Mail::Mailer->new('sendmail') or die "\nDVT.pm: ERROR: Could not create a mail object\n\n";
    if (!defined $contentType) {
      $contentType = "text/plain";
    }
    my $mail_headers = {
      'Content-Type' => "$contentType",
      To => [ "$mailTo"],
      Cc => [ ""],
      Subject => "$subject",
    };
    $mail->open( $mail_headers );
    $mail->print($msg);
    $mail->close();
  }

  #-------------------------------------------------------------------------------
  # clean up DVT output directory(s)
  #-------------------------------------------------------------------------------
  sub exec_dvtclean {
    print "\nDVT.pm: INFO: -dvtclean is defined, existing DVT output directory(s) will be removed\n";
    foreach my $dir (@dvtdirs) {
      next if ($dir eq "$eclipsecache");
      `rm -fr $dir` if (-d $dir);
      Exit 1, "\nDVT.pm: ERROR: Unable to remove $dir\n\n" if (-d $dir);
    }
  }

  #-------------------------------------------------------------------------------
  # make DVT output directory(s)
  #-------------------------------------------------------------------------------
  sub make_dvtdirs {
    print "\nDVT.pm: INFO: Making DVT output directory(s)\n";
    foreach my $dir (@dvtdirs) {
      Mkpath($dir, 0775) unless -d $dir;
      Exit 1, "\nDVT.pm: ERROR: $dir directory is not created\n\n" unless (-d $dir);
    }
  }

  #-------------------------------------------------------------------------------
  # get all search path in current ace scope
  #-------------------------------------------------------------------------------
  sub get_search_paths {
    foreach my $type (keys %{$search_paths}) {
      next if ($type !~ /_expanded_search_paths/);
      foreach my $scp (keys %{${$search_paths}{$type}}) {
        next if ($scp ne "$scope");
        foreach my $sptype (keys %{${$search_paths}{$type}{$scp}}) {
          next if ($sptype ne "ROOT");
          push @search_path, @{${$search_paths}{$type}{$scp}{$sptype}};
        }
      }
    }
  }

  #-------------------------------------------------------------------------------
  # expand sub_libs for all library in @libs_in_order
  #-------------------------------------------------------------------------------
  sub update_libs_in_order {
    $expandlib = "";
    foreach my $lib (@libs_in_order) {
      $expandlib .= " $lib";
      &expand_lib($lib);
    }
    $expandlib =~ s/^\s*//g;
    @libs_in_order = ();
    @libs_in_order = split(/ /, $expandlib);
  }

  #-------------------------------------------------------------------------------
  # get all test_vlog_opts
  #-------------------------------------------------------------------------------
  sub get_test_vlog_opts {
    push @merged_test_vlog_opts, @{${$testcase_globals}{"-test_vlog_opts"}};
    push @merged_test_vlog_opts, @test_vlog_opts;
  }

  #-------------------------------------------------------------------------------
  # get all test_vlog_incdirs
  #-------------------------------------------------------------------------------
  sub get_test_vlog_incdirs {
    foreach my $dir (@{${$testcase_globals}{"-test_vlog_incdirs"}}, @test_vlog_incdirs) {
      if ($dir !~ /^\//) {
        foreach my $sp (@search_path) {
          if (-e "$sp/$dir") {
            push (@merged_test_vlog_incdirs, "$sp/$dir");
            last if (!$incdir_fulldepth);
          } else {
            next;
          }
        }
      } else {
        push (@merged_test_vlog_incdirs, $dir);
      }
    }
  }

  #-------------------------------------------------------------------------------
  # expand sub_libs for all library
  #-------------------------------------------------------------------------------
  sub expand_all_libs_sub_libs {
    my ($libs_hash, $liblist_array) = @_;
    foreach my $libname (@{$liblist_array}) {
      &expand_lib_sub_libs($libs_hash, $libname);
    }
  }

  #-------------------------------------------------------------------------------
  # expand sub_libs for library
  #-------------------------------------------------------------------------------
  sub expand_lib_sub_libs {
    my ($libs_hash, $libname) = @_;
    my $libspec = $libs_hash->{$libname};
    my $has_sublibs = $self->_has_sublibs($libspec);
    if ($has_sublibs && $enable_sublibs) {
      foreach my $sublib (@{$$libspec{-sub_libs}}) {
        push @{$sublibOf{$libname}}, $sublib if (defined $$libspec{-sub_lib_hash}{$sublib});
        &expand_lib_sub_libs($libs_hash, $sublib);
      }
    }
  }

  #-------------------------------------------------------------------------------
  # get all library compile options
  #-------------------------------------------------------------------------------
  sub get_all_libs_compile_options {
    my ($libs_hash, $liblist_array) = @_;
    foreach my $libname (@{$liblist_array}) {
      my $skip = 1;
      foreach my $i (@libs_in_order) {
        if ($libname eq $i) {
          $skip = 0;
          last;
        }
      }
      next if ($skip);
      my $libspec = $libs_hash->{$libname};
      get_lib_compile_options(
                              -libname=>$libname,
                              -libspec=>$libspec,
                              -libs_hash => $libs_hash,
      );
      if (exists $sublibOf{$libname} && scalar @{$sublibOf{$libname}} > 0) {
        foreach my $sublib (@{$sublibOf{$libname}}) {
          get_lib_compile_options(
                                  -libname=>$sublib,
                                  -libspec=>$$libspec{-sub_lib_hash}{$sublib},
                                  -libs_hash => $libs_hash,
          );
        }
      }
    }
  }

  #-------------------------------------------------------------------------------
  # get individual library compile options
  #-------------------------------------------------------------------------------
  sub get_lib_compile_options {
    my (%args) = @_;
    check_args(\%args, -require => [qw(-libname -libspec -libs_hash)],);
    my ($libname, $libspec, $libs_hash) = ($args{-libname}, $args{-libspec}, $args{-libs_hash});
    if (exists $$libspec{-vlog_files} && scalar(@{$$libspec{-vlog_files}}) > 0) {
      @{$libhash{$libname}{vlog_files}} = map($self->find_file($_), @{$$libspec{-vlog_files}});
      @{$libhash{$libname}{vlog_incdirs}} = map($self->find_dir($_), @{$$libspec{-vlog_incdirs}});
      @{$libhash{$libname}{vlog_lib_dirs}} = map($self->find_dir($_), @{$$libspec{-vlog_lib_dirs}});
      @{$libhash{$libname}{vlog_lib_files}} = map($self->find_file($_), @{$$libspec{-vlog_lib_files}});
      if (defined $$libspec{-vlog_opts} || defined $global_vlog_opts) {
        push @{$libhash{$libname}{vlog_opts}}, @{$$libspec{-vlog_opts}} if defined $$libspec{-vlog_opts};
        push @{$libhash{$libname}{vlog_opts}}, @{$global_vlog_opts} if defined $global_vlog_opts;
      }
    }
    if (exists $$libspec{-vhdl_files} && scalar(@{$$libspec{-vhdl_files}}) > 0) {
      @{$libhash{$libname}{vhdl_files}} = map($self->find_file($_), @{$$libspec{-vhdl_files}});
      if (defined $$libspec{-vcom_opts} || defined $global_vcom_opts) {
        push @{$libhash{$libname}{vcom_opts}}, @{$$libspec{-vcom_opts}} if defined $$libspec{-vcom_opts};
        push @{$libhash{$libname}{vcom_opts}}, @{$global_vcom_opts} if defined $global_vcom_opts;
      }
    }
  }

  #-------------------------------------------------------------------------------
  # create dot build file for each model
  #-------------------------------------------------------------------------------
  sub create_model_dot_build {
    my $dot_build = shift;
    print "\nDVT.pm: INFO: Generating $dot_build\n";
    open FH, ">$dot_build" or die "\nDVT.pm: ERROR: Could not open $dot_build for write\n\n";
    if (exists $dvtcfg{-build_preinclude} && scalar @{$dvtcfg{-build_preinclude}} > 0) {
      print FH "##build_preinclude\n";
      foreach my $pre (@{$dvtcfg{-build_preinclude}}) {
        print FH "$pre\n";
      }
      print FH "\n";
    }
    foreach my $lib (@libs_in_order) {
      if (exists $libhash{$lib}{vlog_opts} && scalar @{$libhash{$lib}{vlog_opts}} > 0 && exists $libhash{$lib}{vlog_files} && scalar @{$libhash{$lib}{vlog_files}} > 0) {
        print FH "##$lib vlog\n";
        print FH "+dvt_init+vcs.vlogan\n";
        my %encountered = ();
        my %encountered1 = ();
        $expandlib = "";
        foreach my $vlogopt (@{$libhash{$lib}{vlog_opts}}) {
          chomp $vlogopt;
          $vlogopt =~ s/\\<vcs\\>//g;
          if ($vlogopt =~ /\-liblist\s+(\S+)/) {
            my $lib = $1;
            &expand_lib($lib);
            $expandlib =~ s/ / -liblist /g; $expandlib =~ s/^\s*//;
            $vlogopt =~ s/\-liblist\s+(\S+)/$expandlib/ if ($expandlib ne "");
          }
          next if ($vlogopt eq "");
          print FH "$vlogopt\n" if (!exists $encountered{$vlogopt});
          $encountered{$vlogopt} = 1;
        }
        if (exists $libhash{$lib}{vlog_incdirs} && scalar @{$libhash{$lib}{vlog_incdirs}} > 0) {
          foreach my $vlogincdir (@{$libhash{$lib}{vlog_incdirs}}) {
            chomp $vlogincdir;
            print FH "+incdir+$vlogincdir\n" if (!exists $encountered{$vlogincdir});
            $encountered{$vlogincdir} = 1;
          }
        }
        if (exists $libhash{$lib}{vlog_lib_dirs} && scalar @{$libhash{$lib}{vlog_lib_dirs}} > 0) {
          foreach my $vloglibdir (@{$libhash{$lib}{vlog_lib_dirs}}) {
            chomp $vloglibdir;
            print FH "-y $vloglibdir\n" if (!exists $encountered1{$vloglibdir});
            $encountered1{$vloglibdir} = 1;
          }
        }
        if (exists $libhash{$lib}{vlog_lib_files} && scalar @{$libhash{$lib}{vlog_lib_files}} > 0) {
          foreach my $vloglibfile (@{$libhash{$lib}{vlog_lib_files}}) {
            chomp $vloglibfile;
            print FH "-v $vloglibfile\n" if (!exists $encountered1{$vloglibfile});
            $encountered1{$vloglibfile} = 1;
          }
        }
        print FH "-liblist $lib\n";
        foreach my $vlogfile (@{$libhash{$lib}{vlog_files}}) {
          chomp $vlogfile;
          print FH "$vlogfile\n";
        }
        print FH "\n";
      }
      if (exists $libhash{$lib}{vhdl_files} && scalar @{$libhash{$lib}{vhdl_files}} > 0) {
        print FH "##$lib vhdl\n";
        print FH "+dvt_init+vcs.vhdlan\n";
        my %encountered = ();
        if (exists $libhash{$lib}{vcom_opts} && scalar @{$libhash{$lib}{vcom_opts}} > 0) {
          foreach my $vcomopt (@{$libhash{$lib}{vcom_opts}}) {
            chomp $vcomopt;
            next if ($vcomopt eq "");
            print FH "$vcomopt\n" if (!exists $encountered{$vcomopt});
            $encountered{$vcomopt} = 1;
          }
        }
        foreach my $vhdlfile (@{$libhash{$lib}{vhdl_files}}) {
          chomp $vhdlfile;
          print FH "$vhdlfile\n" if (!exists $encountered{$vhdlfile});
          $encountered{$vhdlfile} = 1;
        }
        print FH "\n";
      }
    }
    # include -build_postinclude
    if (exists $dvtcfg{-build_postinclude} && scalar @{$dvtcfg{-build_postinclude}} > 0) {
      print FH "\n##build_postinclude\n";
      foreach my $post (@{$dvtcfg{-build_postinclude}}) {
        print FH "$post\n";
      }
    } else {
    # if no -build_postinclude then include -testpackage
      # include all of the tests
      my %encountered = ();
      print FH "##tests vlog\n";
      print FH "+dvt_init+vcs.vlogan\n";
      foreach my $vlogopt (@merged_test_vlog_opts) {
        chomp $vlogopt;
        $vlogopt =~ s/\\<vcs\\>//g;
        next if ($vlogopt eq "");
        print FH "$vlogopt\n" if (!exists $encountered{$vlogopt});
        $encountered{$vlogopt} = 1;
      }
      foreach my $vlogincdir (@merged_test_vlog_incdirs) {
        chomp $vlogincdir;
        print FH "+incdir+$vlogincdir\n" if (!exists $encountered{$vlogincdir});
        $encountered{$vlogincdir} = 1;
      }
      if (exists $dvtcfg{-testpackage} && scalar @{$dvtcfg{-testpackage}} > 0) {
        foreach my $pkg (@{$dvtcfg{-testpackage}}) {
          print FH "$pkg\n";
        }
      } else {
        print FH "-sverilog\n";
        print FH "$ENV{ACE_PWA_DIR}/verif/tests/**/*.sv*\n";
      }
    }
    close FH;
    if (-z "$dot_build") {
      Exit 1, "\nDVT.pm: ERROR! $dot_build generated is empty! Exiting...\n\n";
    }
  }

  #-------------------------------------------------------------------------------
  # expand the library thus to have all sub_libs in vcs -lib_list option
  #-------------------------------------------------------------------------------
  sub expand_lib {
    my $lib = shift;
    if (exists $sublibOf{$lib} && scalar @{$sublibOf{$lib}} > 0) {
      foreach my $sublib (@{$sublibOf{$lib}}) {
        $expandlib .= " $sublib";
        &expand_lib($sublib);
      }
    }
  }

  #-------------------------------------------------------------------------------
  # construct dvt_cli.sh command line
  #-------------------------------------------------------------------------------
  sub create_dvt_command {
    my $redo = shift;
    if ($redo) {
      $dvtcommand = "dvt_cli.sh";
      $dvtcommand .= " -eclipsespace $eclipsecache";
      $dvtcommand .= " -workspace $dvtworkspace";
      $dvtcommand .= " createProject $dvtproject";
      if (exists $dvtcfg{-options} && scalar @{$dvtcfg{-options}} > 0) {
        foreach my $opt (@{$dvtcfg{-options}}) {
          $dvtcommand .= " $opt";
        }
      }
      if (exists $dvtcfg{-exclude}) {
        if (exists $dvtcfg{-exclude}{-name} && scalar @{$dvtcfg{-exclude}{-name}} > 0) {
          foreach my $name (@{$dvtcfg{-exclude}{-name}}) {
            $dvtcommand .= " -exclude name=$name";
          }
        }
        if (exists $dvtcfg{-exclude}{-projectRelativePath} && scalar @{$dvtcfg{-exclude}{-projectRelativePath}} > 0) {
          foreach my $path (@{$dvtcfg{-exclude}{-projectRelativePath}}) {
            $dvtcommand .= " -exclude projectRelativePath=$path";
          }
        }
      }
      if (exists $dvtcfg{-map}) {
        foreach my $link (keys %{$dvtcfg{-map}}) {
          $dvtcommand .= " -map $link $dvtcfg{-map}{$link}";
        }
      }
    } else {
      $dvtcommand = "dvt_cli.sh";
      $dvtcommand .= " -eclipsespace $eclipsecache";
      $dvtcommand .= " -workspace $dvtworkspace";
    }
  }

  #-------------------------------------------------------------------------------
  # execute the constructed dvt command line
  #-------------------------------------------------------------------------------
  sub execute_dvt {
    print "\nDVT.pm: INFO: Running dvt command...\n";
    print "$dvtcommand\n\n";
    if (!$dvtdemo) {
      my $rc = system("$dvtcommand");
#      if ($rc) {
#        print "DVT.pm: DVT exit with non-zero exit code!\n";
#      }
    } else {
      print "\nDVT.pm: INFO: -dvtdemo is defined, dvt will not be run. Exiting...\n\n";
    }
  }
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
# To load HASH information from file of HASH structure, &loadHash(<infile>);
#-------------------------------------------------------------------------------
sub loadHash {
        my $inFile = shift;
        undef $/;
        open (SFILE, "$inFile") || die "ERROR! Cannot open $inFile for read!",__LINE__;
        my $var = <SFILE>;
        close SFILE;
        eval($var);
        $/ = "\n"; 
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
