#!/usr/intel/bin/perl
#This script is to parse the metadata file and to create the projects required for each of the entities mentioned in the metadata file
#The current switches handled/used are:
#   -entities_order #This script uses the entities_order to find out the number of projects to create i.e. one for each entity
use strict;
use warnings;
use lib "$ENV{'EMUL_TOOLS_DIR'}/fpga/";

# use Data::Dump qw(dump);
# use Data::Dumper;
# 
# $Data::Dumper::Terse = 1;
# $Data::Dumper::Quotekeys  = 1;
# $Data::Dumper::Indent = 1;
# $Data::Dumper::Purity = 1;
# $Data::Dumper::Sortkeys = 1;

use ef_lib;
use fpga_flow;


our $USER = "UNKNOWN_USER";
if (defined($ENV{'USER'})==1){
   $USER = $ENV{'USER'};
}else{
   $USER = "UNKNOWN_USER";
}
our $EMUL_USE_NETBATCH;
if (defined($ENV{'EMUL_USE_NETBATCH'})==1){
   $EMUL_USE_NETBATCH  = $ENV{'EMUL_USE_NETBATCH'};
}else{
   $EMUL_USE_NETBATCH  = 0;
}

our $EMUL_MAX_JOB_CNT;
if (defined($ENV{'EMUL_MAX_JOB_CNT'})==1){
   $EMUL_MAX_JOB_CNT  = $ENV{'EMUL_MAX_JOB_CNT'};
}else{
   $EMUL_MAX_JOB_CNT = 5;
}


my @args = @ARGV;
our  $debug = 0; #To determine the DEBUG messages to display
our $log = $ENV{'EMUL_RESULTS_DIR'}."/CHECK_FPGA/create_multi_lib_synplify_projects.log"; 
open (LOG, ">$main::log") || die "Could not create log file $main::log. $!\n"; 
close LOG;


my $metadata_file = $args[0];
our $top_module = $args[1];
my $reconfig_file = $args[2];

our $deep = 0;
our @dependecy = ();
our $project_cnt = 0;
our @hierarchicle_view;


our $cmd_str;
#printf(STDOUT "RECONFIG : $reconfig_file\n");
ef_lib::printl("SYNT_FPGA : $metadata_file\n",$main::log);
ef_lib::printl("SYNT_FPGA : $top_module\n",$main::log);
ef_lib::printl("SYNT_FPGA : $reconfig_file\n",$main::log);
require $metadata_file;
require $reconfig_file;

our %dump;
our %reconfig;
our $hierarchy_out = {};

our $restart_filename;
our $restart_id =0;
our $reconfig_proto_filename;
our $reconfig_proto_enable =0;
our $reconfig_proto = {};

our $start_from_top=0;
our $jobkillscript = $ENV{'EMUL_RESULTS_DIR'}."/CHECK_FPGA/jobkillscript.tcsh";

our $prj_dir = $ENV{'EMUL_RESULTS_DIR'}."/CHECK_FPGA/projects/";

our $all_projects_info={};
our %restart;


if (defined($main::jobkillscript)){
   &ef_lib::printl("LOG : Job kill script $main::jobkillscript\n",$main::log);
   open (LOG, ">$main::jobkillscript") || die "Could not create job kill script $main::jobkillscript. $!\n"; 
   close LOG;
   `chmod 750 $main::jobkillscript`;
}else{
   &ef_lib::printl("LOG : status file not defined, using default : status.log.\n",$main::log);
}

my $synplify_premier=ef_lib::which_synplify_premier();

our $config_opt;
if (defined($main::reconfig{'-config_opt'})==1){
   $main::config_opt = $main::reconfig{'-config_opt'};
   if (defined($main::config_opt->{'-write_reconfig_proto'})==1){
      $main::reconfig_proto_filename =  $main::config_opt->{'-write_reconfig_proto'};  
      $main::reconfig_proto_enable = 1;
   }
   if (defined($main::config_opt->{'-start_from_top'})==1){
      $main::start_from_top =  $main::config_opt->{'-start_from_top'};  
   }
   if (defined($config_opt->{'-synplify_premier'})==1){
      $synplify_premier =  $config_opt->{'-synplify_premier'};  
   }
}

&fpga_flow::ProcessMetadata($top_module, $metadata_file, $all_projects_info, \%reconfig, \%dump);
if ($main::reconfig_proto_enable){
   &fpga_flow::dump_hash("reconfig", $main::reconfig_proto, $main::reconfig_proto_filename);
}
&main::WriteMultiLibPrj($all_projects_info, $prj_dir);
&fpga_flow::dump_hash("restart", $main::all_projects_info, $ENV{'EMUL_RESULTS_DIR'}."/STATE0.pm");

&ef_lib::printl("LOG : DONE.\n",$main::log);
exit 0;


#
#  WriteMultiLibPrj

sub WriteMultiLibPrj($$){
   my $all_projects_info   = shift;
   my $prj_dir             = shift;
   my @lib_list = keys %{$all_projects_info};
   my $lib_name;
   my $prj_filename;
   my $prj_logname;
   my $prj_Src_filename;
   my $prj_OptsPaths_filename;
   my $prj_LibMap_filename;
   my $prj_impl;

   my $prj_src_files= [];
#   $prj_dir = $ENV{'EMUL_RESULTS_DIR'}."/SYNTH_FPGA/projects";
   foreach $lib_name (@lib_list){
      my $project_info  = $all_projects_info->{$lib_name};
      if (defined($project_info->{'-non_empty_project'}) == 1){
         if(not(-d $prj_dir)) {
            mkdir $prj_dir;
         }
         my $timestamp = localtime;
         $timestamp =~ s/\s/_/g;
         $prj_filename           = $prj_dir."/".$lib_name.".prj";
         $prj_logname            = $prj_dir."/".$lib_name."_NBsub.log";
         $prj_Src_filename       = $prj_dir."/".$lib_name."_SrcFiles.tcl";
         $prj_LibMap_filename    = $prj_dir."/".$lib_name.".map";
         $prj_impl               = $lib_name."_default";
         my $prj_content= [];
         my $prj_cmds= [];

         WriteSrcAndLibMapFiles($project_info, $lib_name, $prj_Src_filename, $prj_LibMap_filename);
         push (@{$prj_src_files}, $prj_Src_filename);
      }
   }
   my $prj_content= [];
   my $prj_param_def= [];
   my $prj_link_def= [];
   my $prj_cmds_param_link_top= [];
   @{$prj_cmds_param_link_top} = (@{$prj_param_def}, @{$prj_link_def});
   CreateSynplifyProject($main::top_module, $prj_impl, $prj_src_files, $prj_OptsPaths_filename, $prj_content, $prj_cmds_param_link_top);
   open (PRJ, ">$prj_filename") || ef_lib::mydie ("Could not create project file $prj_filename $!\n", $main::log);
   print PRJ @{$prj_content};
   close PRJ;
}# sub WriteMultiLibPrj($$){

sub WriteSrcAndLibMapFiles($$$$){
   my $project_info           = shift;
   my $lib_name               = shift;
   my $prj_Src_filename       = shift;
   my $prj_LibMap_filename    = shift;

   my @prj_Src= ();
   my @prj_OptsPaths= ();
   my @prj_LibMap= ();

   fpga_flow::CreateSynplifyProjectsSrcFiles($lib_name, $project_info, \@prj_Src);
   open (FH, ">$prj_Src_filename") || ef_lib::mydie ("Could not create project file $prj_Src_filename $!\n", $main::log);
   print FH "########################################\n";
   print FH "#   Project source files \n";
   print FH "########################################\n";
   print FH @prj_Src;
   close FH;

   fpga_flow::CreateSynplifyLibMap($lib_name, $project_info, \@prj_LibMap);
   open (FH, ">$prj_LibMap_filename") || ef_lib::mydie ("Could not create project file $prj_LibMap_filename $!\n", $log);
   print FH "########################################\n";
   print FH "#   Lib Map : \n";
   print FH "########################################\n";
   print FH @prj_LibMap;
   close FH;


}# WriteSrcAndLibMapFiles

#sub CreateSynplifyProject($$$$$$$){
sub CreateSynplifyProject($$$$$$){
   my $prj                    = shift;
   my $prj_impl               = shift;
   my $prj_src_filename_arr_p = shift;
   my $prj_OptsPaths_filename = shift;
   my $prj_content            = shift;
   my $prj_cmds               = shift;

   push (@{$prj_content}, "########################################\n");
   push (@{$prj_content}, "#   Project $prj \n");
   push (@{$prj_content}, "########################################\n");
   push (@{$prj_content}, "#source files : \n");
   my $prj_Src_filename ;
   foreach $prj_Src_filename (@{$prj_src_filename_arr_p}){
      push (@{$prj_content}, "source $prj_Src_filename\n");
   }
   push (@{$prj_content}, "########################################\n");
   push (@{$prj_content}, "#   Project implementation \n");
   push (@{$prj_content}, "########################################\n");
   push (@{$prj_content}, "#implementation: $prj_impl\n");
   push (@{$prj_content}, "impl -add $prj_impl -type fpga\n");
   push (@{$prj_content}, "#design plan options\n");
   push (@{$prj_content}, "set_option -top_module \"".$main::top_module."\"\n");

   push (@{$prj_content}, "source $ENV{'EMUL_CFG_DIR'}/fpga/defaul_impl.tcl\n");
#   push (@{$prj_content}, "source $prj_OptsPaths_filename\n");

   foreach my $l (@{$prj_cmds}){
      push (@{$prj_content}, $l);
   }
   push (@{$prj_content}, "#set result format/file last\n");
   push (@{$prj_content}, "impl -active $prj_impl\n");
   push (@{$prj_content}, "\n");
   push (@{$prj_content}, "########################################\n");

}

sub DumpDiscoveredInfo($$){
   my $all_projects_info   = shift;
   my $filename            = shift;

   my %tmp_hash;

   foreach my $lib_name (keys %{$all_projects_info}){
      if (defined($all_projects_info->{$lib_name}{'-FoundTopLevels'})==1){
         foreach my $module (keys %{$all_projects_info->{$lib_name}{'-FoundTopLevels'}}){
#            push(@{$tmp_hash{$lib_name}{'-module_list'}}, $module);
            if (defined(@{$all_projects_info->{$lib_name}{'-FoundTopLevels'}{$module}})==1){
               foreach my $par_def (@{$all_projects_info->{$lib_name}{'-FoundTopLevels'}{$module}}){
                  $tmp_hash{$lib_name}{$module}= $par_def;
               }
            }else{
               $tmp_hash{$lib_name}{$module}= [];
            }
         }
      }
   }
   fpga_flow::dump_hash("reconfig", \%tmp_hash, $filename);
}

