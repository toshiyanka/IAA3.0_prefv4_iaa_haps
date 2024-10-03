#-*-perl-*-

package common::QuestaCDC_TCL;
#package Ace::WorkModules::StaticChecks::QuestaCDC;
use strict;
use FileHandle;
use Carp;
use Switch;
require "dumpvar.pl";

use Utilities::ProgramTools qw(check_args test_eval deepcopy);
use Utilities::Print;

use Utilities::System qw(Exit Mkpath);
use Data::Dumper;
use File::Basename;


use vars qw(@ISA @EXPORT_OK);
use Ace::GenericScrag qw($CWD add_cmd);
use Ace::WorkModules::HDL;
use Ace::DesignDB;

use Intel::WorkWeek qw(:all);
use vars qw($hdl_spec %super);

require Exporter;
@ISA = qw(Exporter Ace::WorkModules::HDL Ace::GenericScrag );

use vars qw(%params);

use vars qw($SIM_START_TAG $SIM_END_TAG $SAFE_TO_PARSE_TAG);
$SIM_START_TAG     = 'ACE SIM OUTPUT START';
$SIM_END_TAG       = 'ACE SIM OUTPUT END';
$SAFE_TO_PARSE_TAG = 'ACE SAFE TO PARSE';

#-------------------------------------------------------------------------------
# MEMBER Functions
#--------------------------------------------------------------------------------

sub new {
    my ($class, %args) = @_;
    check_args( \%args,
		-valid    => [qw(* -debug)],
		-require  => [qw()], # look at parent
	);
    my ($intelyear, $intelww) = intelww(localtime(time));
    $intelyear =~ s/.*(\d\d)$/$1/;
    my $self = $class->SUPER::new(%args);
    if ($self->get_option(-exec_cdc) and $self->get_option(-exec_test) ) {
         Exit 1, "ERROR: the '-exec_cdc and '-exec_test' can't be executed on single commandline\n";
    }

    return $self;
}
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
# Switch for the various MODELSIM scrags
#-------------------------------------------------------------------------------
sub create_scrag {
  my ($self, %args) = @_;
  $_ = $args{-name};
  
  SWITCH: {
##    /^exec_cdc/ && do {
    /^static_check/ && do {
	my $exectest_scrag;
	$exectest_scrag .= $self->_create_cdc_scrag(%args);
	return $exectest_scrag;
    };
    $self->_unknown_ace_command_error($_);
  }
}
#-------------------------------------------------------------------------------

sub _create_cdc_scrag {
  my ($self, %args) = @_;
  my ($cur_scope, $top_scope, $base_scope) = ($args{-cur_scope}, $args{-top_scope}, Ace::UDF::get_base_scope());
  my $zin_scrag = "echo \"# $SIM_START_TAG\"\n";
  
  return $zin_scrag unless ($self->get_array_option(-static_check_tools, -convert2string=>1 ) =~ /cdc/);

  my @zin_opts = $self->get_array_option('-zin_opts');
  my @zin_common_ctrl_files = $self->get_array_option('-zin_ctrl_files');
  my @zin_check_results_files = $self->get_array_option('-zin_check_results_files');
  my $zin_top = $self->get_option('-zin_top');
  my ($lib_name, $top_name) = split /\./, $zin_top;
  

#print "OLD ZIN_COMMON_CTRL_FILES are @zin_common_ctrl_files \n";
   foreach (@zin_common_ctrl_files) { 
	   $_ = $_ . ';' ;
				    };	
#print "NEW ZIN_COMMON_CTRL_FILES are @zin_common_ctrl_files \n";

  my $zin_run_type = $self->get_option('-zin_run_type');
  my $testname = $args{-test_data}->{$cur_scope}{name};
  my $testrun_dir   = $args{-test_data}->{$base_scope}{workdir} .'/'. $args{-test_data}->{$cur_scope}{testrun_dir};
  my $testsource_dir = $args{-test_data}->{$cur_scope}{path};

  #print Data::Dumper->Dump([$args{-test_data}] );
  my $model = $self->get_option(-model);
  my $designDB = $self->get_designDB();
  my $model_hash = $designDB->get_model_spec($model);
  
  my $zin_cmd = "$self->{_timer} " . "qcdc ";
     $zin_cmd .= join ' ', @zin_opts;


  my $my_dofiles = ' do ' . join ' do   ', @zin_common_ctrl_files if ($#zin_common_ctrl_files ne -1) ;
  my $my_libs = " -L ${top_scope}_cdc_testlib -L " . join ' -L ', @{$model_hash->{'libs'}} if ($self->get_option('-enable_liblist_elab_order')) ;
     print "MY LIBS ARE $my_libs \n";
     print "MY DO FILES ARE $my_dofiles \n";


  my $file_exists = $CWD . '/qcdc_da.tcl';	
	
     if ( -e  $file_exists ) {
	 print "MY file exists : $file_exists \n";
	 print "MOVING EXISTING FILE \n";
	 system("mv $file_exists $file_exists.old");
	}	

     open(FH, "+>>qcdc_da.tcl");
     print FH "$my_dofiles ";
     print FH "cdc run ";
     print FH "-work $lib_name -L work "; #modified, added -L work on this line
     print FH "$my_libs ";
     print FH " -d $top_name ";
     print FH " $zin_run_type ";
     print FH " \; cdc generate crossings   $testrun_dir/Violation_Details.rpt ";
     print FH " \; cdc generate tree -reset $testrun_dir/Reset_Details.rpt ";
     print FH " \; cdc generate tree -clock $testrun_dir/Clock_Details.rpt ";
     close (FH);

     print"MY TEST RUN dir is $testrun_dir \n";
     print"MY TEST SOURCE dir is $testsource_dir \n";
     print"MY CURRENT dir is $CWD \n";

     $zin_cmd .= ' -do ' . $CWD . '/qcdc_da.tcl';

     #$zin_cmd .= " -ctrl $testrun_dir/${testname}_ctrl.v"  if (-e "$testsource_dir/${testname}_ctrl.v") ;
     #$zin_cmd .= " -ctrl $testrun_dir/${testname}_ctrl.sv" if (-e "$testsource_dir/${testname}_ctrl.sv") ;
     ##$zin_cmd .= " \${CTRL_FILES_ARGS}";  ## these ctrl files are getting figgured out by 0in -cmd lib2v command
     #$zin_cmd  .= '"' ;
     #$zin_cmd .= " exit 0\;\" ";	
     #$zin_cmd .= " exit\" ";	

     $zin_scrag .= $self->set_ini_var('cdc', undef, "_$model");
     $zin_scrag .= "\nMODELSIM=\$CDC_MODELSIM_INI\n\n";
     $zin_scrag .= "export MODELSIM\n";

     $zin_scrag .= $self->_create_cdcrun_dir(%args);
     $zin_scrag .= Ace::GenericScrag::set_envvar("ACE_${cur_scope}_RUN_DIR" , $testrun_dir );
     $zin_scrag .= Ace::GenericScrag::chdir("\$ACE_${cur_scope}_RUN_DIR");

     $zin_scrag .= $self->_create_lib2v_scrag(%args);
     $zin_scrag .= $self->_create_cdc_testlib_scrag(%args);
     
     $zin_scrag .= Ace::GenericScrag::add_cmd("ZIN_CMD",  "$zin_cmd");
     
     $zin_scrag .= Ace::GenericScrag::set_envvar("COLUMNS", 200, "banner size = 200");
     foreach my $check_file (@zin_check_results_files) {
          $zin_scrag .= "banner '$check_file'\n";
          $zin_scrag .= "echo 'START $check_file DATA'\n";
					#$zin_scrag .= Ace::GenericScrag::add_cmd("CAT_CHECK_FILE__$check_file",  "cat \$ACE_${cur_scope}_RUN_DIR/$check_file ");
          $zin_scrag .= Ace::GenericScrag::add_cmd("CAT_CHECK_FILE__$check_file",  "sed 's\/^\/${check_file}:  \/'  \$ACE_${cur_scope}_RUN_DIR/$check_file ");
          $zin_scrag .= "echo 'END $check_file DATA'\n";
     }
     
     $zin_scrag .= <<EOS;

echo "# CDC EXECUTION DONE"
echo 'RUN AREA = $testrun_dir'

EOS
  return $zin_scrag;
}

#KD-------------------------------------------------------------------------------



#sub _create_cdc_scrag {
#  my ($self, %args) = @_;
#  my ($cur_scope, $top_scope, $base_scope) = ($args{-cur_scope}, $args{-top_scope}, Ace::UDF::get_base_scope());
#  my $zin_scrag = "echo \"# $SIM_START_TAG\"\n";
  
#  return $zin_scrag unless ($self->get_array_option(-static_check_tools, -convert2string=>1 ) =~ /cdc/);

#  my @zin_opts = $self->get_array_option('-zin_opts');
#  my @zin_common_ctrl_files = $self->get_array_option('-zin_ctrl_files');
#  my @zin_check_results_files = $self->get_array_option('-zin_check_results_files');
#  my $zin_top = $self->get_option('-zin_top');
#  my ($lib_name, $top_name) = split /\./, $zin_top;
  

#  my $zin_run_type = $self->get_option('-zin_run_type');
#  my $testname = $args{-test_data}->{$cur_scope}{name};
#  my $testrun_dir   = $args{-test_data}->{$base_scope}{workdir} .'/'. $args{-test_data}->{$cur_scope}{testrun_dir};
#  my $testsource_dir = $args{-test_data}->{$cur_scope}{path};

  #print Data::Dumper->Dump([$args{-test_data}] );
#  my $model = $self->get_option(-model);
#  my $designDB = $self->get_designDB();
#  my $model_hash = $designDB->get_model_spec($model);
  
#  my $zin_cmd = "$self->{_timer} " . "0in ";
#     $zin_cmd .= join ' ', @zin_opts;
#     $zin_cmd .= " $zin_run_type ";
#     $zin_cmd .= " -work $lib_name ";
#     $zin_cmd .= " -L ${top_scope}_cdc_testlib -L " . join ' -L ', @{$model_hash->{'libs'}} if ($self->get_option('-enable_liblist_elab_order')) ;
#     $zin_cmd .= " -d $top_name ";
#     $zin_cmd .= ' -ctrl ' . join ' -ctrl ', @zin_common_ctrl_files if ($#zin_common_ctrl_files ne -1) ;
#     $zin_cmd .= " -ctrl $testrun_dir/${testname}_ctrl.v"  if (-e "$testsource_dir/${testname}_ctrl.v") ;
#     $zin_cmd .= " -ctrl $testrun_dir/${testname}_ctrl.sv" if (-e "$testsource_dir/${testname}_ctrl.sv") ;
#     $zin_cmd .= " \${CTRL_FILES_ARGS}";  ## these ctrl files are getting figgured out by 0in -cmd lib2v command

#     $zin_scrag .= $self->set_ini_var('cdc', undef, "_$model");
#     $zin_scrag .= "\nMODELSIM=\$CDC_MODELSIM_INI\n\n";
#     $zin_scrag .= "export MODELSIM\n";

#     $zin_scrag .= $self->_create_cdcrun_dir(%args);
#     $zin_scrag .= Ace::GenericScrag::set_envvar("ACE_${cur_scope}_RUN_DIR" , $testrun_dir );
#     $zin_scrag .= Ace::GenericScrag::chdir("\$ACE_${cur_scope}_RUN_DIR");

#     $zin_scrag .= $self->_create_lib2v_scrag(%args);
#     $zin_scrag .= $self->_create_cdc_testlib_scrag(%args);
     
#     $zin_scrag .= Ace::GenericScrag::add_cmd("ZIN_CMD",  "$zin_cmd");
     
#     $zin_scrag .= Ace::GenericScrag::set_envvar("COLUMNS", 200, "banner size = 200");
#     foreach my $check_file (@zin_check_results_files) {
#          $zin_scrag .= "banner '$check_file'\n";
#          $zin_scrag .= "echo 'START $check_file DATA'\n";
					#$zin_scrag .= Ace::GenericScrag::add_cmd("CAT_CHECK_FILE__$check_file",  "cat \$ACE_${cur_scope}_RUN_DIR/$check_file ");
 #         $zin_scrag .= Ace::GenericScrag::add_cmd("CAT_CHECK_FILE__$check_file",  "sed 's\/^\/${check_file}:  \/'  \$ACE_${cur_scope}_RUN_DIR/$check_file ");
 #         $zin_scrag .= "echo 'END $check_file DATA'\n";
 #    }
     
 #    $zin_scrag .= <<EOS;

#echo "# CDC EXECUTION DONE"
#echo 'RUN AREA = $testrun_dir'

#EOS
#  return $zin_scrag;
#}


sub _create_cdc_testlib_scrag {
  my ($self, %args) = @_;
  my ($cur_scope, $top_scope, $base_scope) = ($args{-cur_scope}, $args{-top_scope}, Ace::UDF::get_base_scope());
   my $testrun_dir   = $args{-test_data}->{$base_scope}{workdir} .'/'. $args{-test_data}->{$cur_scope}{testrun_dir};
   my $vlog_opts         = $self->get_array_option('-test_vlog_opts', -scope => $cur_scope, -convert2string=>1);
   my @vlog_inc_dirs     = $self->get_array_option('-test_vlog_incdirs', -scope => $cur_scope);
   my $vlog_inc_dirs 	= join " ", map($self->find_dir($_, $cur_scope), @vlog_inc_dirs) if (scalar @vlog_inc_dirs);
   #
   my @vlog_lib_dirs     = $self->get_array_option('-test_vlog_lib_dirs', -scope => $cur_scope);
   my $vlog_lib_dirs 	= join " ", map($self->find_dir($_, $cur_scope), @vlog_lib_dirs) if (scalar @vlog_lib_dirs);
   #
   my $vlog_additional_test_files = "\"\$VERL_FILES " . $self->get_array_option('-test_vlog_files', -scope => $cur_scope, -convert2string=>1) ."\"";

  my $test_data           = $args{-test_data};
  my $target		= $self->get_option('-test_build_target', -scope=>$cur_scope);
  my $makefile 		= $self->get_option('-test_make_file', -scope=>$cur_scope);
  my $basemakefile      = $self->get_option('-test_base_make_file', -scope=>$cur_scope);
  my $compiler          = 'cdc';
  my $make_opts         = $self->get_array_option('-test_make_opts', -scope => $cur_scope, -convert2string=>1);
  my $custom_opts       = join " ", @{$args{-custom_make_options}} if (defined $args{-custom_make_options} && scalar @{$args{-custom_make_options}});
  my $dependent_libs 	= $self->get_array_option('-test_dependent_libs', -scope=>$cur_scope, -convert2string=>1);
  my $test_src_name     = "$args{-test_data}->{$cur_scope}{name}";
  
      
    # gmake command
    my $build_cmd	= "gmake -f $makefile ".
                          "BASE_MAKE_FILE=$basemakefile ".
                          "IGNORE_CHAR='' ".
                          "RTL_COMPILER=$compiler " .
                          "TESTCASE=$test_data->{$cur_scope}{test} " .
                          "TESTSRC=$test_src_name " .
			  "TESTSCOPE=$cur_scope " .
                          "VLIB_TOOL=$self->{_hdl_compiler_info}{$compiler}{-vlibTool} " .
                          "VLOG_TOOL=$self->{_hdl_compiler_info}{$compiler}{-vlogTool} " .
                          "VLOG_LIB_KW=$self->{_hdl_compiler_info}{$compiler}{-vlogLibKeyword} " . 
                          "VLOG_OPTS=\'$vlog_opts\' " .
                          "ELAB_OPTS=\'\' " . 
                          "VCS_OPTS=\'\' ".
                          "VLOG_INC_DIRS='$vlog_inc_dirs' " .
			  "VLOG_LIB_DIRS='$vlog_lib_dirs' ".
                          my $vcs_macros .
			  "MAKELOGS=$self->{_makeLogs} " .
			  "OTHER_VLOG_FILES=$vlog_additional_test_files " .
			  "DEPENDENT_LIBS='$dependent_libs' ".
                          "HDL_LIBS_DIR='$self->{_libdirs}{$compiler}' " .
			  "WORKDIR=\'$testrun_dir\' ".
                          #"\"\$RUN_TIME_CMDLINE_OPTS\" " . # options whose value is determined at run-time by the runscript
                          "$custom_opts " .   # added by custom TestBuilder::-custom_make_options
                          "$make_opts " .     # added by ivar -test_make_opts 
                          "$target ";

    my   $fragment .= Ace::GenericScrag::add_cmd("COMPILE_${cur_scope}_cdd_HDL_TEST", $build_cmd);
  
  return $fragment;

}


sub _create_lib2v_scrag {
  my ($self, %args) = @_;
  my ($cur_scope, $top_scope, $base_scope) = ($args{-cur_scope}, $args{-top_scope}, Ace::UDF::get_base_scope());
  my $zin_scrag;
  my @zin_libs_files = $self->get_array_option('-zin_libs_files');
  my $zin_libs_files = $self->get_array_option('-zin_libs_files', -scope => $cur_scope, -convert2string=>1);
  my $test_src_name     = "$args{-test_data}->{$cur_scope}{name}";

 
  foreach my $libs_file (@zin_libs_files) {
     $zin_scrag .= "\n#  ----------------------------------------------- \n";
     $zin_scrag .= "#  Processing LIBS file: \n";
     $zin_scrag .= Ace::GenericScrag::add_cmd("ZIN_LIBSFILE",  "0in -od \$ACE_${cur_scope}_RUN_DIR -cmd lib2v -lib $libs_file");
    
  }
   
   if ($zin_libs_files =~ /\S+/) {
        $zin_scrag .= <<EOS;

##---------------------------------------------------------------------------------
## CDC FIND-LOOP to locate VERILOG and CNTRL files generaged by '0in -cmd lib2v'       

verilog_files_arr=(`find \$ACE_${cur_scope}_RUN_DIR/0in_lib_vlog -name "*.v"`)
ctrl_files=()
verl_files=()

for i in "\${verilog_files_arr[\@]}"
do
    if [[ \$i = *ctrl* ]]; then
       ctrl_files=( "\${ctrl_files[\@]}"  "-ctrl \$i " )
    else
       verl_files=( "\${verl_files[\@]}"  "\$i " )
    fi

done

## temporary work-around to force test-compile
if [[-e "${test_src_name}.v" ]]; then
  echo " >> use test supplied  ${test_src_name}.v ";
elif [[ -e "${test_src_name}.sv" ]]; then
  echo " >> use test supplied  ${test_src_name}.sv ";
else
  touch dummy.v
  ln -sf dummy.v ${test_src_name}.v
fi

CTRL_FILES_ARGS="\${ctrl_files[\@]}"
VERL_FILES=" \${verl_files[\@]}"

##---------------------------------------------------------------------------------
EOS

    }

 return $zin_scrag; 
}



sub _create_cdcrun_dir {
      my ($self, %args) = @_;
  my $fragment;

  my ($cur_scope, $top_scope, $base_scope) = ($args{-cur_scope}, $args{-top_scope}, Ace::UDF::get_base_scope());

  my $pre_clean           = $self->get_option('-pre_clean_test');
  my $make_testdir_script = $self->get_option('-make_testdir_script', -scope=>$cur_scope);
  my $checksize           = $self->get_option('-test_source_checksize');

  my $test_data           = $args{-test_data};
  my $testsrc_dir         = $test_data->{$cur_scope}{path};
  my $workdir             = $test_data->{$base_scope}{workdir};
  my $testrun_dir         = $test_data->{$cur_scope}{testrun_dir};
  my $test_subdir         = $self->get_option(-test_subdir);

  #my (@test_run_copy_files, @test_run_link_files, @test_run_copy_dirs, @test_run_link_dirs, @test_run_touch_dirs, @test_run_touch_files);
  #
  #@test_run_link_dirs =   map($self->find_dir($_), $self->get_array_option('-test_run_link_dirs', -scope=>$cur_scope));
  #@test_run_link_files =  map($self->find_file($_), $self->get_array_option('-test_run_link_files', -scope=>$cur_scope));
  #
  #@test_run_touch_dirs =  map($_, $self->get_array_option('-test_run_touch_dirs', -scope=>$cur_scope));
  #@test_run_touch_files = map($_, $self->get_array_option('-test_run_touch_files', -scope=>$cur_scope));
  #
  #@test_run_copy_files =  map($self->find_file($_), $self->get_array_option('-test_run_copy_files', -scope=>$cur_scope));

  $fragment .= $self->build_testdir_cmd(
                                        -tid            => $test_data->{$base_scope}{"tid"},
                                        -testdir        => $testsrc_dir,
                                        -destdir        => $workdir,
                                        -subdir         => $testrun_dir,
                                        -clean          => $pre_clean,
                                        -copy_not_link  => $self->get_option('-test_source_copy_not_link'),
                                        -args           => $self->get_option('-make_testdir_script_args', -scope=>$cur_scope),
                                        -make_testdir_script => $make_testdir_script,
                                        -checksize      => $checksize,
                                        #-link_files     => \@test_run_link_files,
                                        #-copy_files     => \@test_run_copy_files,
                                        #-link_dirs      => \@test_run_link_dirs,
                                        #-copy_dirs      => \@test_run_copy_dirs,
                                        #-touch_dirs     => \@test_run_touch_dirs,
                                        #-touch_files    => \@test_run_touch_files,
                                        -site_indep_path_policy => $main::SITE_INDEPENDENT_POLICY,
                                        );

  return $fragment;

}

#--------------------------------------------------------------------------------
1;
