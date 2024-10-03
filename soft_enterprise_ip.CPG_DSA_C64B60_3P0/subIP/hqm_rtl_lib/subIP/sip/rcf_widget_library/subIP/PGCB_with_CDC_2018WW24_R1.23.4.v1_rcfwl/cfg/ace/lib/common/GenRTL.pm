#-*-perl-*-
##-----------------------------------------------
## Need help?
##   Use Intelpedia:    https://intelpedia.intel.com/Ace_Simulation_Environment
##   Use AceUsersGuide: http://nsec.ch.intel.com/cad_nfs/ace/doc/AceUsersGuide.pdf 
##
## Find ACE bugs?
##   File HSD to: 
##-----------------------------------------------
## AceUserGuide: Chapter 6.5 


#--------------------------------------------------------------------------------
package common::GenRTL;
use strict;
use FileHandle;
use Carp;
require "dumpvar.pl";

use Utilities::ProgramTools qw(check_args test_eval deepcopy);
use Utilities::Print;
use Utilities::System qw(Exit Mkpath execute_cmd);
use Data::Dumper;
use Ace::Query qw(get_rtl_dump);


use vars qw(@ISA @EXPORT_OK);
use Ace::GenericScrag qw($CWD add_cmd);
use Ace::WorkModules::HDL;
use Ace::WorkModules::GenerateRTL;
use File::Basename;
use Sys::Hostname;

require Exporter;
@ISA = qw(Exporter Ace::WorkModules::HDL Ace::GenericScrag Ace::WorkModules::GenerateRTL);

use vars qw(%params);

#-------------------------------------------------------------------------------
# MEMBER Functions
#--------------------------------------------------------------------------------
sub new {
  my ($class, %args) = @_;
  check_args( \%args,
	      -valid    => [qw(* -debug)],
	      -require  => [qw()], # look at parent for the required args
	    );

  my $self = $class->SUPER::new(%args);


  return $self;
}
#-------------------------------------------------------------------------------
# The following are member functions that MUST be supplied by the workmodule
#-------------------------------------------------------------------------------
# Switch for the various MODELSIM scrags
#-------------------------------------------------------------------------------
sub create_scrag {
  my ($self, %args) = @_;

  $_ = $args{-name};
  #--------------------------------------------------------- 

  SWITCH: {
    /^generate_rtl$/ && do { return $self->run_gen_rtl(%args); };
    $self->_unknown_ace_command_error($_);
  }
}
#-------------------------------------------------------------------------------
# Implements run_gen_rtl
#-------------------------------------------------------------------------------
sub run_gen_rtl {
  # Look in the parents 'create_scrag' list of possible arguments
  my ($self, %args) = @_;
  my $enable_generation = ($self->get_option(-enable_generate_rtl) and  $self->get_option(-generate_rtl)) ;
  my $enable_chefit = $self->get_option(-chefit);
  my $enable_visainsert = $self->get_option(-visa_insert);
  my $visainsert_xml  = $self->get_option(-visa_modules_xml);
  my $visa_hier_map = $self->get_option(-visa_hier_map); 
  my $debug_mode    = $self->get_option(-codegen_debug);

  if ($enable_generation) {
    print "===> " . ref($self) . " : Running Code Generation Flow\n";
    # -----------------------------------------------------------
    # Grab a search path if needed
    my $spaths 		= $self->{_udf_man}->get_search_paths_ref();
    my $cur_scope 	= $self->get_scope();
    my $demo 		= $self->get_option(-demo);
    my $quiet 		= $self->get_option(-quiet) unless ($demo); 
    my $clean 		= $self->get_option(-delete_generate_results);
  
    # -----------------------------------------------------------
    # Grab a reference to a UDF.  The UDF catagory is defined in the
    # UDF objects constuctor
    # -----------------------------------------------------------
    my $hdlspec		= $self->{_udf_man}->get_udf_ref(-catagory=>"HDLSpec");
    my $genRTL		= $self->{_udf_man}->get_udf_ref(-catagory=>"GenRTL");
    my $config 		= $genRTL->get_config(-scope=>$cur_scope);

    # -----------------------------------------------------------
    # Find library to generate RTL for
    # -----------------------------------------------------------
    my $genlibname; 
    foreach my $libname ( keys %{$hdlspec->{_datahash}{$cur_scope}{libs}} ) {
       if ($hdlspec->{_datahash}{$cur_scope}{libs}{$libname}{-generated}) {
        $genlibname =  $libname;
       }
    }
    # -----------------------------------------------------------
    # Dest dir is in expected to be in results dir
    # -----------------------------------------------------------
    my $pwa_dir 	= $self->get_option(-eng) . "/" . $self->get_option(-pwa);

     foreach my $gen_cfg (keys %{$config} ) {
            my $dest_dir 	= "$pwa_dir/" . $gen_cfg;
            unless ($config->{$gen_cfg}{enable_config}) {
                  print "===> " . ref($self) . " : '$gen_cfg' code generation disabled\n";
                  next;
            } else {
                  print "===> " . ref($self) . " : generating '$gen_cfg' RTL code \n";

            }

	    ## /tmp cahche for the model building
            ## replace $dest_dir as link dir
            my $pid = $$;
            my $random_temp_dir = sprintf("/tmp/codegen_%s_%s_%s",hostname,$pid,rand($pid)+rand());

            my $gen_dir = dirname $dest_dir; 
            `mkdir -p $gen_dir`;
            `mkdir -p $random_temp_dir`;
             print "Using local tmp to cache : $random_temp_dir\n";
            `rm -rf $dest_dir`;
            `ln -sf $random_temp_dir $dest_dir`;
         
            # -----------------------------------------------------------
            # Clean if directed...
            # -----------------------------------------------------------
            if ($clean && ! $demo) { `rm -Rf $dest_dir/*`; }
        
            # -----------------------------------------------------------
            # find the script and makefile
            # -----------------------------------------------------------
            my $script 		= $spaths->find_executable($config->{$gen_cfg}{script}, $cur_scope);
            
            my $model	 	= $config->{$gen_cfg}{model};

            {	  
		  ## prepare all the visa insert files at the final destination
                  ## this does not depends on -visa_insert switch
                  my $visa_preprocess_script = sprintf("%s/bin/common/%s",$pwa_dir,"visait_preprocess.pl");
		  my $visa_preprocess_cmd = sprintf("%s -model_root %s -visait_output_path %s -clt %s -module_xml %s",
				$visa_preprocess_script,
				$pwa_dir,
			        $dest_dir."/visait",
                                $cur_scope,	
                                $visainsert_xml,
			);

			if($visa_hier_map){
				$visa_preprocess_cmd .= " -hier_map $visa_hier_map "; 
	
			}

		  my $rtn = execute_cmd($visa_preprocess_cmd, -runscript=>$visa_preprocess_cmd, -quiet=>$quiet, -demo=>$demo);
            }

            my $data_makepar            = $self->get_paths_to_units(
                                        -gen_libmap => "$genlibname : $dest_dir" ,
                                        -model => $model,
                                        -work_dir => $dest_dir,
                                        -out_file => $config->{$gen_cfg}{rtlpathfile}
                                  );

            # -----------------------------------------------------------
            # Build the command/s to run the ACTUAL code gen flow
            # -----------------------------------------------------------
            my $cmd             = "cd $dest_dir; $script  -rtlpathfile " . $config->{$gen_cfg}{rtlpathfile};

            if( $enable_visainsert ){
		$cmd .= " -visa_insert ";
            }
 
            if($enable_chefit){
		$cmd .= "  -chefit ";
	    }  

            if($debug_mode){
                 if($debug_mode == "1"){
                   $cmd .= " -debug_prompt  ";
                 }elsif($debug_mode == "2"){
                   $cmd .= " -debug_makepar  ";
                 }
            }

	    ## add in pipe and tee 	
 
            $cmd .= " 2>&1 |";

            # Execute the command in realtime!!!
            open( CODEGEN, $cmd ) or die;
            my $debug_log_file = "$dest_dir/CodeGeneration_debug.log ";
            open (DEBUGLOG , "> $debug_log_file ") or die;
            while(<CODEGEN>){
			print DEBUGLOG $_; 
			print $_;
            }
            close CODEGEN;
            my $rtn = $? >> 8;
            close DEBUGLOG;
            
            ## copy back from /tmp cache
            print "copy back from tmp '$random_temp_dir' to '$dest_dir'\n";
            `rm -f $dest_dir`;
            `cp -rf $random_temp_dir $dest_dir`;
            `rm -rf $random_temp_dir`;

            print "===> " . ref($self) . "::run_gen_rtl RC = $rtn\n";           
            print "Generated:  $dest_dir\n";
            print "Log file: $debug_log_file\n";  
            Exit $rtn, "ERROR: RTL Generation Failed\n" if ($rtn);
    }
  }
  else {
    print "===> " . ref($self) . " : Skipping code generation - -enable_generate_rtl is 0\n";
  }
  
  # Return FAKE empty fragment
  return "";
}

#--------------------------------------------------------------------------------
# Assumes that the HDL lives with the code
#--------------------------------------------------------------------------------
sub get_paths_to_units {
  my ($self, %args) = @_;
  check_args( \%args,
        -valid    => [qw()],
        -require  => [qw(-gen_libmap -model -work_dir -out_file)], # look at parent for the required args
  );
  
  my $data = $self->get_filtered_rtl_data(-model=>$args{-model}, -filter=>'CodeGenInput', -include_prereqs=>0);
  
  ## print Data::Dumper->Dump([$data], ["*data"]);
  my @out_data;
  
  #my $units = $args{-units};
  #foreach my $unit (@{$units}) {
  foreach my $unit (@{$data->{-data}{-entities_order}}) {
    if (defined $data->{-data}{$unit} && defined $data->{-data}{$unit}{-hdl_spec_src_files}) {
      my $found = 0;
      my @defining_hdls = grep m#.*/\S+\.hdl$#, @{$data->{-data}{$unit}{-hdl_spec_src_files}};
#      if (scalar @defining_hdls > 1) {
#        Exit 1, "GenRTL : Library $unit has more than one .hdl defining it, which will cause the code generation to crash and burn and hurt real bad. :( \nAborting.\n";
#      }
      if (scalar @defining_hdls == 0) {
        my $msg = "GenRTL : Library $unit seems to have NO .hdls defining it. This is a sign of something really wrong, since every library must be defined in SOME .hdl.\n";
        $msg .= "We suggest you start debug by running % ace -rtl $unit\nGood luck!\n";
        Exit 1, $msg;
      }

      my $unit_paths = ""; 
      foreach (@defining_hdls) { # yes, support multiple
        /(.*)\/\S+\.hdl$/;
        my $pathtoit = $1;
        $unit_paths .= $pathtoit.";";
      }
      $unit_paths =~ s/;$//g;
      push @out_data, "${unit} : $unit_paths";      

    }
  }
	##print Data::Dumper->Dump([\@out_data], ["*out_data"]);

  unless (-d $args{-work_dir}) {
    `mkdir -p $args{-work_dir}`;
  }
  my $outfile = "$args{-work_dir}/$args{-out_file}"; 
  my $fh = new FileHandle("> $outfile");
  if (defined $fh) {
    foreach (@out_data) {
      print $fh "$_\n";
    }
    print $fh "$args{-gen_libmap}\n";
      $fh->close;
  }
  else {
    my $msg = ref($self) . ": Couldn't open file '$outfile' for writing - $!\n";
    Exit 1, "ERROR: $msg";
  }
  return $data;
}
#--------------------------------------------------------------------------------


1;

