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

my @args = @ARGV;
our  $debug = 0; #To determine the DEBUG messages to display
our $log = $ENV{'EMUL_RESULTS_DIR'}."/CHECK_FPGA/create_synplify_projects.log"; 
open (LOG, ">$log") || die "Could not create log file $log. $!\n"; 
close LOG;

my @template;
my $metadata_file = $args[0];
my $top_module = $args[1];
my $reconfig_file = $args[2];

my $deep = 0;
my @dependecy = ();
my $project_cnt = 0;
my @hierarchicle_view;


my $cmd_str;
#printf(STDOUT "RECONFIG : $reconfig_file\n");
ef_lib::printl("CREATE_SYNPLIFY_PROJECT : metadata_file  $metadata_file\n",$log);
ef_lib::printl("CREATE_SYNPLIFY_PROJECT : top_module     $top_module\n",$log);
ef_lib::printl("CREATE_SYNPLIFY_PROJECT : reconfig_file  $reconfig_file\n",$log);
require $metadata_file;
require $reconfig_file;

our %dump;
our %reconfig;
our $hierarchy_out = {};

our $reconfig_proto_filename;
our $reconfig_proto_enable =0;
our $reconfig_proto = {};

our $start_from_top=0;

our $all_projects_info={};

my $synplify_premier= ef_lib::which_synplify_premier();
my $config_opt;
if (defined($reconfig{'-config_opt'})==1){
   $config_opt = $reconfig{'-config_opt'};
   if (defined($config_opt->{'-write_reconfig_proto'})==1){
      $reconfig_proto_filename =  $config_opt->{'-write_reconfig_proto'};  
      $reconfig_proto_enable = 1;
   }
   if (defined($config_opt->{'-start_from_top'})==1){
      $start_from_top =  $config_opt->{'-start_from_top'};  
   }
   if (defined($config_opt->{'-synplify_premier'})==1){
      $synplify_premier =  $config_opt->{'-synplify_premier'};  
   }
}

#&Main();
&fpga_flow::ProcessMetadata($top_module, $metadata_file, $all_projects_info, \%reconfig, \%dump);
#&ProcessMetadata($top_module, $metadata_file, $all_projects_info, \%reconfig, \%dump);
&Write_hierarchy_out();
&WriteAllSynplifyProjects();
#&WriteBluePearlTcl();
if ($reconfig_proto_enable){
   &fpga_flow::dump_hash("reconfig", $reconfig_proto, $reconfig_proto_filename);
}



sub WriteBluePearlTcl(){

   my $prj_lib_name;
   my $project_info;
   my $prj_dir;
   # Create script to run check on all libraries.
   my $prj_index = 0;
   #writing out the project/flow file use for synplify pro
   ef_lib::printl("Start Creating of BPS tcl scripts\n",$log);
   foreach my $prj (keys %$main::all_projects_info) {
      my $Set_v2k= 0;
      my $Set_sverilog= 0;
      $project_info = $main::all_projects_info->{$prj};
      if (defined($project_info->{'-non_empty_project'}) == 1){
         $prj_dir = $ENV{'EMUL_RESULTS_DIR'}."/CHECK_FPGA/projects";
         $prj_lib_name = $prj;
         if(not(-d $prj_dir)) {
            mkdir $prj_dir;
         }
         my $tcl_file = $prj_dir."/BPS_".$prj.".tcl";
         my $log_file = $prj_dir."/BPS_".$prj.".log";
         $prj_index++;

         open (TCL, ">$tcl_file") || ef_lib::mydie ("Could not create project file $tcl_file $!\n", $log);
         ef_lib::printl("Bleu Pearl Tcl script for $prj - $tcl_file\n",$log);
         my $hierarchy = $project_info->{'-hierarchy'}; 
         print TCL "#hierarchy $hierarchy \n";
         #Adding verilog files to the project


         foreach my $opt (@{$project_info->{'vlog_opts'}->{'vlog_opts_other'}}){
            if ($opt eq '+v2k'){
               $Set_v2k= 1;
            }elsif ($opt eq '-sverilog'){
               $Set_sverilog= 0;
            }
         }

         print TCL "#Adding Verilog files\n";
         my $vlog_files_arr            = $project_info->{'vlog_files'};
         my $verilog_lanuage = "VERILOG_1995";
         if ($Set_sverilog==1){
            $verilog_lanuage = "SYS_VERILOG";
         }elsif ($Set_v2k==1){
            $verilog_lanuage = "VERILOG_2001";
         }
         foreach my $file_name (@{$vlog_files_arr}) {
            $cmd_str = sprintf("BPS::add_input_files -library  $prj_lib_name  -language $verilog_lanuage { $file_name }\n");
            print TCL $cmd_str;
         }
         print TCL "\n\n";

         print TCL "#Adding Sverilog files\n";
   #      foreach my $svfile (@{$project_info->{'svlog_files'}}) {
   #         print TCL "add_file -verilog -vlog_std sysv -lib $prj_lib_name \"$svfile\"\n";
   #      }
         my $svlog_files_arr            = $project_info->{'svlog_files'};
         foreach my $file_name (@{$svlog_files_arr}) {
            $cmd_str = sprintf("BPS::add_input_files -library  $prj_lib_name  -language SYS_VERILOG { $file_name }\n");
            print TCL $cmd_str;
         }
         print TCL "\n\n";

         #Adding vhdl files to the project
         print TCL "#Adding VHDL files\n";
         foreach my $file_name (@{$project_info->{'vhdl_files'}}) {
            $cmd_str = sprintf("BPS::add_input_files -library  $prj_lib_name   { $file_name }\n");
            print TCL $cmd_str;
         }
         print TCL "\n\n";

         #Adding verilog inc dirs
         if ((defined(@{$project_info->{'vlog_incdirs'}})==1) && (scalar(@{$project_info->{'vlog_incdirs'}})>0)){
            print TCL "#Adding verilog inc dirs\n";
            $cmd_str = sprintf("BPS::set_option -veri_include_dirs { ");
            print TCL $cmd_str;
            foreach my $dir_name (@{$project_info->{'vlog_incdirs'}}) {
               $cmd_str = sprintf("$dir_name ");
               print TCL $cmd_str;
            }
            $cmd_str = sprintf("}\n");
            print TCL $cmd_str;
            print TCL "\n";
         }

         #Adding verilog lib dirs
         if ((defined(@{$project_info->{'vlog_lib_dirs'}})==1) && (scalar(@{$project_info->{'vlog_lib_dirs'}})>0)){
            print TCL "#Adding verilog lib dirs\n";
            $cmd_str = sprintf("BPS::set_option -veri_lib_dirs { ");
            print TCL $cmd_str;
            foreach my $dir_name (@{$project_info->{'vlog_lib_dirs'}}) {
               $cmd_str = sprintf("$dir_name ");
               print TCL $cmd_str;
            }
            $cmd_str = sprintf("}\n");
            print TCL $cmd_str;
            print TCL "\n";
         }
         if (defined($project_info->{'-top'})==1){
            my $top_module = $project_info->{'-top'}[0];
            print TCL "# Top module identified : \n";
            print TCL "BPS::set_option -root_module $top_module\n";
         }else{
            print TCL "# No top module identified\n";
         }
         print TCL "\n";

         print TCL "#Adding Read in Option\n";
         print TCL "BPS::set_option -veri_cu_mode MFCU\n";
         print TCL "BPS::set_option -auto_create_black_boxes\n";
         print TCL "\n";

#         print TCL "BPS::set_message_severity VERI-1137 -severity=Warning\n"; 
#         print TCL "BPS::set_message_severity VERI-1372 -severity=Warning \n";
         if (defined($reconfig{'-BluePearlOpts'})==1){
            if (defined($reconfig{'-BluePearlOpts'}{'-set_message_severity'})==1){
               print TCL "#Global change severity of E-VERI-xxx to Warning\n";
               foreach my $msg (keys  %{$reconfig{'-BluePearlOpts'}{'-set_message_severity'}}) {
                  my $msg_level = $reconfig{'-BluePearlOpts'}{'-set_message_severity'}{$msg};
                  print TCL "BPS::set_message_severity $msg -severity=$msg_level\n";                   
               }
            }
         }
         if (defined($project_info->{'-BluePearlOpts'})==1){
            if (defined($project_info->{'-BluePearlOpts'}{'-set_message_severity'})==1){
               print TCL "#Library specific change severity of E-VERI-xxx to Warning\n";
               foreach my $msg (keys  %{$project_info->{'-BluePearlOpts'}{'-set_message_severity'}}) {
                  my $msg_level = $project_info->{'-BluePearlOpts'}{'-set_message_severity'}{$msg};
                  print TCL "BPS::set_message_severity $msg -severity=$msg_level\n";                   
               }
            }
         }
         print TCL "\n";

         print TCL "BPS::set_check_enabled {*} -enabled false\n";
         print TCL "BPS::set_option -output_dir Results_$prj\n";
         print TCL " if { [catch BPS::run] } {\n";
         print TCL "    puts stderr \"ERR: BPS::run\n\"\n";
         print TCL "    exit 1\n";
         print TCL "}\n";
         print TCL "exit\n";
         close TCL;
      }

   }
}

sub WriteSingleSynplifyProject($$$$$){
   my $project_info  = shift;
   my $prj_dir       = shift;
   my $prj           = shift;
   my $lib_name           = shift;
   my $top_name           = shift;

   my $prj_lib_name     = $prj;
   my $prj_file         = $prj_dir."/".$prj.".prj";
   my $log_file         = $prj_dir."/".$prj.".log";
   my $prj_Src_filename = $prj_dir."/".$lib_name."_SrcFiles.tcl";
   my $prj_OptsPaths_filename = $prj_dir."/".$lib_name."_OptsPaths.tcl";
   my $prj_LibMap_filename = $prj_dir."/".$lib_name.".map";
#      print CHK "rm -rf ".$prj."rev\n";

   my @prj_Src= ();
   my @prj_OptsPaths= ();
   my @prj_LibMap= ();
   my @prj_Impl= ();

   fpga_flow::CreateSynplifyProjectsSrcFiles($lib_name, $project_info, \@prj_Src);
   open (FH, ">$prj_Src_filename") || ef_lib::mydie ("Could not create project file $prj_Src_filename $!\n", $log);
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

   fpga_flow::CreateSynplifyImplOptsPaths($lib_name, $project_info, \@prj_OptsPaths);
   open (FH, ">$prj_OptsPaths_filename") || ef_lib::mydie ("Could not create project file $prj_OptsPaths_filename $!\n", $log);
   print FH "########################################\n";
   print FH "#   Project Options and paths \n";
   print FH "########################################\n";
   print FH @prj_OptsPaths;
   close FH;

   fpga_flow::WriteSynplifyImpl($prj, $project_info, \@prj_Impl);
   open (PRJ, ">$prj_file") || ef_lib::mydie ("Could not create project file $prj_file $!\n", $log);
   ef_lib::printl("project file for $prj - $prj_file\n",$log);
   print PRJ "########################################\n";
   print PRJ "#   Project $prj \n";
   print PRJ "########################################\n";
   print PRJ "source $prj_Src_filename\n";
   print PRJ "########################################\n";
   print PRJ "#   Project implementation \n";
   print PRJ "########################################\n";
   print PRJ "#implementation: \"$prj"; print PRJ "_rev\"\n";
   print PRJ "impl -add $prj"; print PRJ "_rev -type fpga\n";
   print PRJ "\n";
   print PRJ "project -result_file \"./$prj"; print PRJ "_rev/$prj"; print PRJ ".edf\"\n";
   print PRJ "\n";
   print PRJ "#design plan options\n";
   if ($top_name ne ""){
      print PRJ "\n".'set_option -top_module "'.$lib_name.'.'.$top_name.'"'."\n";
   }
   print PRJ "source $ENV{'EMUL_CFG_DIR'}/fpga/defaul_impl.tcl\n";
   print PRJ "source $prj_OptsPaths_filename\n";
   print PRJ "#set result format/file last\n";
   print PRJ "impl -active \"$prj"; print PRJ "_rev\"\n";
   print PRJ "\n";
   print PRJ "########################################\n";
   close PRJ;
}

sub WriteAllSynplifyProjects(){

   my $compile_chk_log = '../compile_chk.log';
   my $project_info;
   my $prj_dir;
   # Create script to run check on all libraries.
   my $compile_chk_file = "compile_chk.tcsh";
   open (CHK, ">$compile_chk_file") || ef_lib::mydie ("Could not create file compile script $compile_chk_file $!\n", $log);
   print CHK "rm -f $compile_chk_log\n";
   my $prj_index = 0;
   #writing out the project/flow file use for synplify pro
   ef_lib::printl("Start Creating of Projects\n",$log);
   foreach my $prj (keys %$main::all_projects_info) {
      $project_info = $main::all_projects_info->{$prj};
      if (defined($project_info->{'-non_empty_project'}) == 1){
         $prj_dir = $ENV{'EMUL_RESULTS_DIR'}."/CHECK_FPGA/projects";
         if(not(-d $prj_dir)) {
            mkdir $prj_dir;
         }
         my $top_lst = [];
         if (defined($project_info->{'-top'} )){
            $top_lst= $project_info->{'-top'};
         }else{
            $top_lst->[0] = "";
         }
         foreach my $top_name (@{$top_lst}){
            $prj_index++;
            my $prj_name;
            if ($top_name eq ""){
               $prj_name = $prj;
            }else{
               $prj_name = $prj."_".$top_name;
            }
            printf(CHK "echo %d /%d\n", $prj_index, $project_cnt);
            printf(CHK "echo ".$prj_name."\n");
            printf(CHK "echo $prj_name >> $compile_chk_log\n");
            printf(CHK "$synplify_premier  $prj_name.prj -compile -batch | tee $prj_name.log | grep \"exit status\" >> $compile_chk_log\n");

            WriteSingleSynplifyProject($project_info, $prj_dir, $prj_name, $prj, $top_name);
         }
      }
   }
   close CHK;
   ef_lib::printl(sprintf("\nCreated in %s, %d projects.\n", $compile_chk_file, $project_cnt),$log);
}


sub Write_hierarchy_out(){

   my $project_info;
   my $prj_dir;
   # Create script to run check on all libraries.
   my $prj_index = 0;
   my $sub_libs = ();
   if ((defined ($reconfig{'-top'})==1)) {
      $hierarchy_out->{'-top'} = $reconfig{'-top'};
   }else{
      $hierarchy_out->{'-top'} = "NoTop";
   }
   foreach my $prj (keys %$main::all_projects_info) {
       if (defined($main::all_projects_info->{$prj}{'-non_empty_project'}) == 1){

        if ($hierarchy_out->{'-top'} ne $prj){
                push (@{$sub_libs}, $prj);
        }
        if (defined($reconfig{$prj}{'-top'} )){
                $hierarchy_out->{$prj}{'-top'} = $reconfig{$prj}{'-top'};
        }else{
                $hierarchy_out->{$prj}{'-top'} =  undef;
        }
      }
   }
   $hierarchy_out->{'-sub_libs'} = $sub_libs;


   &fpga_flow::dump_hash("hierarchy", $hierarchy_out, "Hin_0_hierarchy.txt");
}
