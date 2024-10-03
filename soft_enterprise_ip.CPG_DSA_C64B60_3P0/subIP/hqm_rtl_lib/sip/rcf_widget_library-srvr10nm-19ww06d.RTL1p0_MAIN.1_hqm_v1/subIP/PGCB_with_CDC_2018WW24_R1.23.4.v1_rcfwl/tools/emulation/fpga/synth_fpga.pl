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
our $log = $ENV{'EMUL_RESULTS_DIR'}."/SYNTH_FPGA/synth_fpga.log"; 
open (LOG, ">$main::log") || die "Could not create log file $main::log. $!\n"; 
close LOG;


my $metadata_file = $args[0];
my $top_module = $args[1];
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
our $discover_proto_filename;
our $discover_proto_enable =0;
our $reconfig_proto_filename;
our $reconfig_proto_enable =0;
our $reconfig_proto = {};

our $start_from_top=0;
our $jobkillscript = $ENV{'EMUL_RESULTS_DIR'}."/SYNTH_FPGA/jobkillscript.tcsh";

our $prj_dir = $ENV{'EMUL_RESULTS_DIR'}."/SYNTH_FPGA/projects/";

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
   if (defined($main::config_opt->{'-restart'})==1){
      $main::restart_filename =  $main::config_opt->{'-restart'}; 
   }
   if (defined($main::config_opt->{'-restart_id'})==1){
      $main::restart_id =  $main::config_opt->{'-restart_id'};
   }
   if (defined($main::config_opt->{'-write_reconfig_proto'})==1){
      $main::reconfig_proto_filename =  $main::config_opt->{'-write_reconfig_proto'};  
      $main::reconfig_proto_enable = 1;
   }
   if (defined($main::config_opt->{'-write_discover_proto'})==1){
      $main::discover_proto_filename =  $main::config_opt->{'-write_discover_proto'};  
      $main::discover_proto_enable = 1;
   }
   if (defined($main::config_opt->{'-start_from_top'})==1){
      $main::start_from_top =  $main::config_opt->{'-start_from_top'};  
   }
   if (defined($config_opt->{'-synplify_premier'})==1){
      $synplify_premier =  $config_opt->{'-synplify_premier'};  
   }
}

if ($main::restart_id==0){
   &fpga_flow::ProcessMetadata($top_module, $metadata_file, $all_projects_info, \%reconfig, \%dump);
   if ($main::reconfig_proto_enable){
      &fpga_flow::dump_hash("reconfig", $main::reconfig_proto, $main::reconfig_proto_filename);
   }
   &main::PrepareSrcAndOptsPathsFiles($all_projects_info, $prj_dir);
   &main::GetTopLevelDefinitions($all_projects_info, $prj_dir);
   &fpga_flow::dump_hash("restart", $main::all_projects_info, $ENV{'EMUL_RESULTS_DIR'}."/STATE0.pm");
   if ($main::discover_proto_enable){&main::DumpDiscoveredInfo($main::all_projects_info, $main::discover_proto_filename);}
}else{
   &ef_lib::printl("LOG : Restarting from $main::restart_filename.\n",$main::log);

   require $main::restart_filename;
   $all_projects_info = \%restart;
   &ef_lib::printl("LOG : Loaded $main::restart_filename.\n",$main::log);

}


if ($main::restart_id<=1){

   &ef_lib::printl("LOG : Start project generation.\n",$main::log);
   my $prj_top_lib = $main::reconfig{'-top'};
   my $prj_top_module = $all_projects_info->{$prj_top_lib}{'-top'}[0];
   
   my $TopPrjbasename = &main::BuildToplevel("T", $prj_dir, $prj_top_lib, $prj_top_module, $all_projects_info, []);
   &fpga_flow::dump_hash("restart", $main::all_projects_info, $ENV{'EMUL_RESULTS_DIR'}."/STATE1.pm");
   
}




&ef_lib::printl("LOG : DONE.\n",$main::log);
exit 0;

sub BuildToplevel($$$$$){
   my $prj_prefix          = shift;
   my $prj_dir             = shift;
   my $lib_name            = shift;
   my $module_name         = shift;
   my $all_projects_info   = shift;
   my $Parameter_ref       = shift;

   &ef_lib::printl("LOG : BuildToplevel starting at $lib_name.$module_name.\n",$main::log);

   my $project_info  = $all_projects_info->{$lib_name};
   my $prj_filename;
   my $prj_logname;
   my $prj_Src_filename;
   my $prj_OptsPaths_filename;
   my $prj_impl;
   my $prj_basename;
   my $prj_final_filename;
   my $prj_link_def = [];
#   $prj_dir = $ENV{'EMUL_RESULTS_DIR'}."/SYNTH_FPGA/projects";
   $prj_basename           = $prj_prefix."_".$lib_name;
   $prj_filename           = $prj_dir.$prj_basename.".prj";
   $prj_final_filename     = $prj_dir."F_".$prj_basename.".prj";
   $prj_logname            = $prj_dir.$prj_basename.".log";
   $prj_Src_filename       = $prj_dir."F_".$prj_basename."_SrcFiles.tcl";
   $prj_OptsPaths_filename = $prj_dir."F_".$prj_basename."_OptsPaths.tcl";
   $prj_impl               = $prj_basename."_default";


   WriteSrcAndOptsPathsFiles($project_info, $lib_name, $prj_Src_filename, $prj_OptsPaths_filename);
   $project_info->{'-NB_run'}{'-prj_filename'} = $prj_filename;
   $project_info->{'-NB_run'}{'-prj_Src_filename'} = $prj_Src_filename;
   $project_info->{'-NB_run'}{'-prj_OptsPaths_filename'} = $prj_OptsPaths_filename;
   $project_info->{'-NB_run'}{'-prj_impl'} = $prj_impl;

#############################################
   my $prj_param_def= [];
   if (defined($Parameter_ref)==1){
      foreach my $Param (@{$Parameter_ref}){
         push (@{$prj_param_def}, 'set_option -hdl_param -set {'.$Param->[0].'='.$Param->[1].'}'."\n");
      }
   }
   my $prj_content= [];
   my $prj_cmds_param_link_top= [];
   @{$prj_cmds_param_link_top} = (@{$prj_param_def}, @{$prj_link_def});
#   CreateSynplifyProject($lib_name, $prj_impl, $prj_Src_filename, $prj_OptsPaths_filename, $prj_content, $prj_param_def, $prj_link_def);
   CreateSynplifyProject($lib_name, $prj_impl, $prj_Src_filename, $prj_OptsPaths_filename, $prj_content, $prj_cmds_param_link_top);
   open (PRJ, ">$prj_filename") || ef_lib::mydie ("Could not create project file $prj_filename $!\n", $main::log);
   print PRJ @{$prj_content};
   close PRJ;
#############################################

   my $prj_cmds= [];
   my $GetBBModuleList_filename = "$ENV{'EMUL_TOOLS_DIR'}/fpga/GetBBModuleList.tcl";


   push (@{$prj_cmds}, 'set top_module "'.$module_name.'"'."\n");
   push (@{$prj_cmds}, 'set lib_name "'.$lib_name.'"'."\n");
   push (@{$prj_cmds}, 'set prj_basename "'.$prj_basename.'"'."\n");
   push (@{$prj_cmds}, 'source "'.$GetBBModuleList_filename.'"'."\n");

   my $GetBBModuleList_cmd_filename = $prj_dir."/".$prj_basename."_GetBBModuleList.tcl";
   open (PRJ, ">$GetBBModuleList_cmd_filename") || ef_lib::mydie ("Could not create project file $GetBBModuleList_cmd_filename $!\n", $main::log);
   print PRJ @{$prj_cmds};
   close PRJ;

   my $JobCmd = "$synplify_premier ".$project_info->{'-NB_run'}{'-prj_filename'}." -batch -license_wait -tcl $GetBBModuleList_cmd_filename| tee $prj_logname";
   $project_info->{'-NB_run'}{'-blackbox_detect'}{'-JobCmd'} = $JobCmd;
   $project_info->{'-NB_run'}{'-blackbox_detect'}{'-prj_logname'} = $prj_logname;
   &NBEnque('-blackbox_detect', $lib_name, $prj_dir, $project_info->{'-NB_run'}{'-blackbox_detect'}, $all_projects_info);
   ef_lib::printl("LOG : Waiting for Jobs in que to complete.\n", $main::log);
   WaitForJobsQueCompletion('-blackbox_detect', $all_projects_info);
   ef_lib::printl("LOG : Checking return status for each job.\n", $main::log);
   ef_lib::printl("LOG : $prj_basename : ".$project_info->{'-NB_run'}{'-blackbox_detect'}{'-job_status'}."\n", $main::log);
   foreach my $line (@{$project_info->{'-NB_run'}{'-blackbox_detect'}{'-job_log'}}){
      if ($line =~ /log file.*/){
         my $SRR_filename = $line;
         $SRR_filename =~ s/log_file:"(.+")/$1/;
         $project_info->{'-NB_run'}{'-blackbox_detect'}{'-SRR_filename'} = $SRR_filename;
         ef_lib::printl("LOG : SRR_filename $SRR_filename\n", $main::log);
      }
      if($line =~ /exit status.*/){
         my $exit_status = $line;
         $exit_status =~ s/exit status=(\d+)/$1/;
         $project_info->{'-NB_run'}{'-blackbox_detect'}{'-exit_status'} = $exit_status;
         ef_lib::printl("LOG : exit_status $exit_status\n", $main::log);
         if ($exit_status == 0){
            my $BB_lst_filename = "projects/".$prj_basename."_".$module_name."_BlackBoxDetect.lst";
            open (BB_LST, "<$BB_lst_filename") || ef_lib::mydie ("ERR : Could not open file $BB_lst_filename $!\n", $main::log);
            my $header = <BB_LST>;
            if ($header =~ m/Object Name\s+orig_inst_of.*/){
               my @lst_arr;
               @lst_arr = <BB_LST>;
               close(BB_LST);
               foreach $line (@lst_arr){
                  chomp $line;
                  if ($line =~ m/{i\:(\S+)}.*\"(\S+)\".*/){
                     my $BB_instance_name = $line;
                     my $BB_module_name   = $line;
                     $BB_instance_name =~ s/{i\:(\S+)}.*\"(\S+)\".*/$1/;
                     $BB_module_name =~ s/{i\:(\S+)}.*\"(\S+)\".*/$2/;
                     if (&main::IgnoreBB($lib_name, $module_name, $BB_module_name)==0){
                        ef_lib::printl("LOG : BlackBox detect : $BB_instance_name/$BB_module_name\n", $main::log);
                        my $BB_resolution = ResolveBB($lib_name, $BB_module_name);
                        if (defined($BB_resolution)==1){
                           $project_info->{'-sub_projects'}{$BB_instance_name} = $BB_resolution;
                        }
                     }else{
                        ef_lib::printl("LOG : BlackBox ignored : $BB_instance_name/$BB_module_name\n", $main::log);
                     }
                  }else{
                     ef_lib::printl("LOG : BlackBox list skipping :>$line<\n", $main::log);
                  }
               }
            }else{
               ef_lib::printl("ERR : BlackBox detect list header error : >$header<\n", $main::log);
               exit -1;
            }
         }else{
            ef_lib::printl("ERR : BlackBox detect run BAD exit_status $exit_status\n", $main::log);
            ef_lib::printl("ERR : See SRR file :  $prj_logname\n", $main::log);
            exit -1;
         }
      }
   }
   ReportResolution($lib_name, $project_info);
   my $SubPrjCnt = 0;
   foreach my $BB_instance_name (keys %{$project_info->{'-sub_projects'}}){
      my $BB_resolution_cnt = scalar(@{$project_info->{'-sub_projects'}{$BB_instance_name}});
      if ($BB_resolution_cnt==1){
         $SubPrjCnt++;
         my $SubPrj = $project_info->{'-sub_projects'}{$BB_instance_name}[0];
         my $SubPrj_lib = $SubPrj->{'-lib_name'};
         my $SubPrj_module = $SubPrj->{'-module_name'};
         my $SubPrj_module_name  = $SubPrj_module;
         # from instance name from full path instance name ($SubPrj_module_name="asd.qwe.zxc" => extract "zxc")
         if (($SubPrj_module_name=~ s/.*\.(\S+)/$1/)!=1){
            $SubPrj_module_name  = $SubPrj_module;
         }
         my $SubPrj_Prefix = $prj_prefix.'s'.$SubPrjCnt;
         my $SubPrj_ParamDef = $all_projects_info->{$SubPrj_lib}{'-FoundTopLevels'}{$SubPrj_lib.".".$SubPrj_module} ;
         my $SubPrjInfo_ref = &main::BuildToplevel($SubPrj_Prefix, $prj_dir, $SubPrj_lib, $SubPrj_module_name, $all_projects_info, $SubPrj_ParamDef);



# # Link Map
# define_link i:Ts2_fuse_unit_lib -name F_Ts2s1_sbendpoint_lib|Ts2s1_sbendpoint_lib_default
# define_link -run_type top_down -name F_Ts2s1_sbendpoint_lib|Ts2s1_sbendpoint_lib_default
# 
# #design plan options
# 
# # Project Libraries
# project -insert "./F_Ts2s1_sbendpoint_lib.prj"
         my $link_cmd;
         $link_cmd = sprintf('define_link "i:%s" -name %s|%s', $prj_basename, "F_".$SubPrjInfo_ref->{'-prj_base_name'}, $SubPrjInfo_ref->{'-prj_impl'})."\n";
         ef_lib::printl("LOG : $link_cmd\n", $main::log);
         push(@{$prj_link_def},$link_cmd); 
         push(@{$SubPrj->{'-prj_link_subprj'}},$link_cmd); 
         $link_cmd = sprintf('define_link -run_type top_down -name %s|%s', "F_".$SubPrjInfo_ref->{'-prj_base_name'}, $SubPrjInfo_ref->{'-prj_impl'})."\n";
         ef_lib::printl("LOG : $link_cmd\n", $main::log);
         push(@{$prj_link_def},$link_cmd); 
         push(@{$SubPrj->{'-prj_link_subprj'}},$link_cmd); 
         
         $link_cmd = sprintf('project -insert "%s"',$SubPrjInfo_ref->{'-prj_filename'})."\n";
         ef_lib::printl("LOG : $link_cmd\n", $main::log);
         push(@{$prj_link_def},$link_cmd); 
         push(@{$SubPrj->{'-prj_link_subprj'}},$link_cmd); 
#          $SubPrj->{'-insert_prj_cmd'} = $insert_prj_cmd;
#          ef_lib::printl("LOG : $insert_prj_cmd\n", $main::log);
#          push(@{$prj_link_def},$insert_prj_cmd); 
#"define_link "i:inst1" -name proj1_1|rev_1"
#project  -propagate  params

      }#if ($BB_resolution_cnt==1){
   }# foreach my $BB_instance_name (keys %{$project_info->{'-sub_projects'}}){
   my $prj_F_content= [];
   $prj_cmds_param_link_top= [];
   @{$prj_cmds_param_link_top} = (@{$prj_param_def}, @{$prj_link_def});
   push(@{$prj_cmds_param_link_top}, "set_option -top_module $lib_name.$module_name\n");
#   set_option -top_module $file_line
#   CreateSynplifyProject($lib_name, $prj_impl, $prj_Src_filename, $prj_OptsPaths_filename, $prj_F_content, $prj_param_def, $prj_link_def);
   CreateSynplifyProject($lib_name, $prj_impl, $prj_Src_filename, $prj_OptsPaths_filename, $prj_F_content, $prj_cmds_param_link_top);
   open (PRJ, ">$prj_final_filename") || ef_lib::mydie ("Could not create project file $prj_final_filename $!\n", $main::log);
   print PRJ @{$prj_F_content};
   close PRJ;
   ef_lib::printl("LOG : Written project $prj_final_filename.\n",$main::log);
   my $ReturnHash = {};
   $ReturnHash->{'-prj_filename'} =$prj_final_filename;
   $ReturnHash->{'-prj_base_name'} =$prj_basename;
   $ReturnHash->{'-prj_impl'} =$prj_impl;
   ef_lib::printl("##############################################################\n", $main::log);
   ef_lib::printl("LOG : BuildToplevel completed $lib_name.$module_name.\n",$main::log);
   ef_lib::printl("##############################################################\n", $main::log);
   return $ReturnHash;
}

sub ReportResolution($$){
   my $lib_name      = shift;
   my $project_info  = shift;

   my @undefined_log;
   my @unresolved_log;
   my @resolved_log;
   my $undefined_cnt    = 0;
   my $unresolved_cnt   = 0;
   my $resolved_cnt     = 0;
   foreach my $BB_instance_name (keys %{$project_info->{'-sub_projects'}}){
      my $BB_lib_name;
      my $BB_module_name;
      my $BB_resolution_cnt = scalar(@{$project_info->{'-sub_projects'}{$BB_instance_name}});
      if ($BB_resolution_cnt>1){
         push(@unresolved_log, "LOG : $BB_instance_name => found $BB_resolution_cnt options : \n");
#          foreach my $Res_p (@{$project_info->{'-sub_projects'}{$BB_instance_name}}){
#             my $R_lib = $Res_p->[0];
#             my $R_module = $Res_p->[1];
#             push(@unresolved_log, "LOG : \t Lib : $R_lib Module : $R_module\n");
         foreach my $SubPrj (@{$project_info->{'-sub_projects'}{$BB_instance_name}}){
         my $SubPrj_lib = $SubPrj->{'-lib_name'};
         my $SubPrj_module = $SubPrj->{'-module_name'};
            push(@unresolved_log, "LOG : \t Lib : $SubPrj_lib Module : $SubPrj_module\n");
         }  
         $unresolved_cnt++;
      }elsif ($BB_resolution_cnt==1){
         my $SubPrj = $project_info->{'-sub_projects'}{$BB_instance_name}[0];
         my $SubPrj_lib = $SubPrj->{'-lib_name'};
         my $SubPrj_module = $SubPrj->{'-module_name'};
         push(@resolved_log, "LOG : $BB_instance_name\t\t\t Lib= $SubPrj_lib Module= $SubPrj_module\n");
         $resolved_cnt++;
      }else{
         push(@undefined_log, "LOG : NOT DEFINED $BB_instance_name =>  \n");
         $undefined_cnt++;
      }
   }
   ef_lib::printl("LOG : SubProject  list for $lib_name\n", $main::log);
   ef_lib::printl("\n", $main::log);
   ef_lib::printl("LOG : \tRESOLVED\n", $main::log);
   ef_lib::printa(\@resolved_log, $main::log);
   ef_lib::printl("\n", $main::log);
   ef_lib::printl("LOG : \tUNRESOLVED : \n", $main::log);
   ef_lib::printa(\@unresolved_log, $main::log);
   ef_lib::printl("\n", $main::log);
   ef_lib::printl("LOG : \tUNDEFINED : \n", $main::log);
   ef_lib::printa(\@undefined_log, $main::log);
   ef_lib::printl("\n", $main::log);
   ef_lib::printl("##############################################################\n", $main::log);
   ef_lib::printl("LOG : \tRESOLVED : $resolved_cnt\tUNRESOLVED : $unresolved_cnt\tUNDEFINED : $undefined_cnt\n", $main::log);
   ef_lib::printl("##############################################################\n", $main::log);
}

#
#  GetTopLevelDefinitions
#     Find all potential top modules in each lib.
#     Run synplify_premier with the GetModuleList.tcl script
#     Results are written into the file $prj_dir.$lib_name.'_TopLevelDetect.lst'
#     Result file contains the module name, parameters and default parameter values.
#     The results file is read, parsed and stored in project info hash  
#          {lib_name}{'-FoundTopLevels'}{
#             'module_X' => [
#                [param_XA, Value_XA],
#                [param_XB, Value_XB],
#             ],
#             'module_Y' => [
#                [param_YA, Value_YA],
#                [param_YB, Value_YB],
#             ],
#          }
#
sub GetTopLevelDefinitions($$){
   my $all_projects_info   = shift;
   my $prj_dir             = shift;
   my @lib_list = keys %{$all_projects_info};
   my $lib_name;
   my $prj_filename;
   my $prj_logname;
   my $prj_Src_filename;
   my $prj_OptsPaths_filename;
   my $prj_impl;
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
         $prj_OptsPaths_filename = $prj_dir."/".$lib_name."_OptsPaths.tcl";
         $prj_impl               = $lib_name."_default";
         my $prj_content= [];
         my $prj_cmds= [];

         WriteSrcAndOptsPathsFiles($project_info, $lib_name, $prj_Src_filename, $prj_OptsPaths_filename);
         $project_info->{'-NB_run'}{'-prj_filename'} = $prj_filename;
         $project_info->{'-NB_run'}{'-prj_Src_filename'} = $prj_Src_filename;
         $project_info->{'-NB_run'}{'-prj_OptsPaths_filename'} = $prj_OptsPaths_filename;
         $project_info->{'-NB_run'}{'-prj_impl'} = $prj_impl;

         my $prj_param_def= [];
         my $prj_link_def= [];
         my $prj_cmds_param_link_top= [];
         @{$prj_cmds_param_link_top} = (@{$prj_param_def}, @{$prj_link_def});
#         CreateSynplifyProject($lib_name, $prj_impl, $prj_Src_filename, $prj_OptsPaths_filename, $prj_content, $prj_param_def, $prj_link_def);
         CreateSynplifyProject($lib_name, $prj_impl, $prj_Src_filename, $prj_OptsPaths_filename, $prj_content, $prj_cmds_param_link_top);
         open (PRJ, ">$prj_filename") || ef_lib::mydie ("Could not create project file $prj_filename $!\n", $main::log);
         print PRJ @{$prj_content};
         close PRJ;

         $project_info->{'-NB_run'}{'-toplevel_detect'}{'-prj_impl'} = $lib_name."_TopLevelDetect";

         my $GetModuleList_filename = "$ENV{'EMUL_TOOLS_DIR'}/fpga/GetModuleList.tcl";
         push (@{$prj_cmds}, 'set base_name "'.$lib_name.'"'."\n");
         push (@{$prj_cmds}, 'source "'.$GetModuleList_filename.'"'."\n");

         my $TopLevelDetect_cmd_filename = $prj_dir."/".$lib_name."_TopLevelDetect.tcl";
         open (PRJ, ">$TopLevelDetect_cmd_filename") || ef_lib::mydie ("Could not create project file $TopLevelDetect_cmd_filename $!\n", $main::log);
         print PRJ @{$prj_cmds};
         close PRJ;
         my $JobCmd = "$synplify_premier ".$project_info->{'-NB_run'}{'-prj_filename'}." -batch -license_wait -tcl $TopLevelDetect_cmd_filename| tee $prj_logname";
         $project_info->{'-NB_run'}{'-toplevel_detect'}{'-JobCmd'} = $JobCmd;
         $project_info->{'-NB_run'}{'-toplevel_detect'}{'-prj_logname'} = $prj_logname;
         &NBEnque('-toplevel_detect', $lib_name, $prj_dir, $project_info->{'-NB_run'}{'-toplevel_detect'}, $all_projects_info);
      }
   }
   ef_lib::printl("LOG : Waiting for Jobs in que to complete.\n", $main::log);
   WaitForJobsQueCompletion('-toplevel_detect', $all_projects_info);
   ef_lib::printl("LOG : Checking return status for each job.\n", $main::log);
   foreach $lib_name (@lib_list){
      my $project_info  = $all_projects_info->{$lib_name};
      if (defined($project_info->{'-non_empty_project'}) == 1){
         ef_lib::printl("LOG : $lib_name : ".$project_info->{'-NB_run'}{'-toplevel_detect'}{'-job_status'}."\n", $main::log);
         foreach my $line (@{$project_info->{'-NB_run'}{'-toplevel_detect'}{'-job_log'}}){
            if ($line =~ /log file.*/){
               my $SRR_filename = $line;
               $SRR_filename =~ s/log_file:"(.+")/$1/;
               $project_info->{'-NB_run'}{'-toplevel_detect'}{'-SRR_filename'} = $SRR_filename;
               ef_lib::printl("LOG : SRR_filename $SRR_filename\n", $main::log);
            }
            if($line =~ /exit status.*/){
               my $exit_status = $line;
               $exit_status =~ s/exit status=(\d+)/$1/;
               $project_info->{'-NB_run'}{'-toplevel_detect'}{'-exit_status'} = $exit_status;
               ef_lib::printl("LOG : exit_status $exit_status\n", $main::log);
               if ($exit_status == 25){
#                  my $TopmoduleListFileName = $ENV{'EMUL_RESULTS_DIR'}.'/SYNTH_FPGA/projects/'.$lib_name.'_TopLevelDetect.lst';
                  my $TopmoduleListFileName = $prj_dir.$lib_name.'_TopLevelDetect.lst';
                  open (LST, "<$TopmoduleListFileName") || ef_lib::mydie ("Could not open file $TopmoduleListFileName $!\n", $main::log);
                  my $lst_arr = [];
                  @{$lst_arr} = <LST>;
                  $project_info->{'-NB_run'}{'-toplevel_detect'}{'-TopLevelList'}= $lst_arr;
                  close(LST);
                  foreach my $module_discr (@{$lst_arr}){
                     chomp($module_discr);
                     if (($module_discr =~ /.+\..+\s+/)==1){
                        my $module_name;
                        my @param_arr;
                        ($module_name, @param_arr) = split(/\s/, $module_discr);
                        if (scalar(@param_arr)>0){
                           my $i;
                           while (scalar(@param_arr)>0){
                              my $param_id   = shift(@param_arr);
                              my $param_val  = shift(@param_arr);
                              push(@{$project_info->{'-FoundTopLevels'}{$module_name}}, [$param_id, $param_val]);
                           }
                        }else{
                           $project_info->{'-FoundTopLevels'}{$module_name} = [];
                        }
                     }
                  }
               }else{
                  ef_lib::printl("ERR : BAD exit_status $exit_status\n", $main::log);
                  exit -1;
               }
            }
         }
      }
      delete $all_projects_info->{$lib_name}{'-NB_run'};
   }
   foreach $lib_name (@lib_list){
      my $project_info  = $all_projects_info->{$lib_name};
      $project_info = $all_projects_info->{$lib_name};
      if (defined($project_info->{'-non_empty_project'}) == 1){
         ef_lib::printl("LOG : Module list for $lib_name\n", $main::log);
         foreach my $module(keys % {$project_info->{'-FoundTopLevels'}}){
            ef_lib::printl("LOG : \t$module\n", $main::log);
            foreach my $param_info (@{$project_info->{'-FoundTopLevels'}{$module}}){
               my $param = $param_info->[0];
               my $value = $param_info->[1];
               ef_lib::printl("LOG : \t\t$param : $value\n", $main::log);
            }
         }
      }
      ef_lib::printl("\n", $main::log);
   }
   delete $all_projects_info->{'-job_que'};
}# sub GetTopLevelDefinitions($$){

#
#  ResolveBB :
#     Search for the black box module name in the -FoundTopLevels lists
#     Ignore any match in the lib that originated the request
#     Results will be returned in an array of anonymous HASH reference's
#       [
#          {'-lib_name' => 'X_lib', '-module_name' => '$BB_module_name'}
#          {'-lib_name' => 'Y_lib', '-module_name' => '$BB_module_name'}
#          {'-lib_name' => 'Z_lib', '-module_name' => '$BB_module_name'}
#       ]
#     
#
sub ResolveBB($$){
my $Originating_Lib = shift;
my $BB_module_name = shift;

   my $lib_name;
   my $resolution_ref = [];
   foreach my $lib_name (keys %{$all_projects_info}){
      if ($Originating_Lib ne $lib_name){
         if (defined($all_projects_info->{$lib_name}{'-FoundTopLevels'})==1){
            foreach my $module (keys %{$all_projects_info->{$lib_name}{'-FoundTopLevels'}}){
               my $lib_name = $module;
               my $module_name   = $module;
               $lib_name =~ s/(\S+)\.(\S+).*/$1/;
               $module_name =~ s/(\S+)\.(\S+).*/$2/;
               if ($module_name eq $BB_module_name ){
                  ef_lib::printl("LOG : ResolveBB == $BB_module_name $module\n", $main::log);
                  my $result_ref = {};
                  $result_ref->{'-lib_name'} =  $lib_name;
                  $result_ref->{'-module_name'} =  $module_name;
                  push(@{$resolution_ref}, $result_ref);
               }else{
   #               ef_lib::printl("LOG : ResolveBB <> $BB_module_name $module\n", $main::log);
               }
            }
         }
      }
   }

   return $resolution_ref;
}# sub ResolveBB($$){

#
#  Check if the BlackBox module should be ignored
#     The module_name is checked against 
#        - the global -config_opt/-ignore_BB list
#        - the library specific -config_opt/-ignore_BB list
#  
#
sub IgnoreBB($$$){
my $lib_name      = shift;
my $module_name      = shift;
my $BB_module_name   = shift;

   if (defined($main::reconfig{'-config_opt'}{'-ignore_BB'}{$BB_module_name})==1){
      return 1;
   }
   if (defined($main::reconfig{$lib_name}{'-config_opt'}{'-ignore_BB'}{$BB_module_name})==1){
      return 1;
   }
   return 0;
}
#
#  WaitForJobsQueCompletion() :
#     If jobs are submitted thru netbatch then the job information is stored in the $hierarchy{'-job_que'}
#     Each job's status is requested 
# #
sub WaitForJobsQueCompletion($$){
   my $Id = shift;
   my $all_projects_info = shift;

   my $Que_info = $all_projects_info->{'-job_que'}{$Id};
   my $job_cnt;
   my $lib_name;
   my $top_name;
   if (defined($Que_info)) {                                                    # if there are any jobs qued
      my $timestamp = localtime;
      my $prev_job_cnt = scalar(keys %{$Que_info});
      ef_lib::printl(sprintf("\nLOG : Number of jobs remaining in que : %d (%s)\n", $prev_job_cnt, $timestamp), $main::log);
      
      my $StatusCheckLoopCnt= 0;                                                             # Provide periodic status update 
      my $StatusCheckDelay = 5; #Delay between status check update loops
      while ((keys %{$Que_info})>0) {                                              # keep checking job status until no jobs remaining
         $StatusCheckLoopCnt++;
         $job_cnt = scalar(keys %{$Que_info});
         if ($prev_job_cnt > $job_cnt){                                                      # If the number of qued jobs status show current count
            my $timestamp = localtime;
            ef_lib::printl(sprintf("\nLOG : Number of jobs remaining in que : %d (%s)\n", $job_cnt, $timestamp), $main::log);
         }
         $prev_job_cnt = $job_cnt;
         foreach my $job_id (keys %{$Que_info}) {                                  # for each qued job request nbstatus
   #         printf(STDOUT "Que status : %d\n", $job_id);
            my $nbstatus_cmd = "nbstatus jobs --hi 3d \"user=='".$main::USER."'\" | uniq | grep ".$job_id;
            my $nbstatus_results = [];
            @{$nbstatus_results} = `$nbstatus_cmd`;
            if (defined($nbstatus_results->[0])){                                            # if nbstatus returned a respons for this ID the job has terminated
               my @words;
               @words = split(/\s+/, $nbstatus_results->[0] );                               # split nbstatus and store the status into the hash $hierarchy{$lib_name}{$top_name}
               $lib_name = $Que_info->{$job_id}{'-lib_name'};
               $top_name = $Que_info->{$job_id}{'-top_name'};
               $all_projects_info->{$lib_name}{'-NB_run'}{$Id}{'-job_status'}="complete";
               $all_projects_info->{$lib_name}{'-NB_run'}{$Id}{'-job_log_file'}=$Que_info->{$job_id}{'-job_log_file'};
#               $job_info->{'-job_status'} ="complete";
#                $hierarchy{$lib_name}{$top_name}{'-job_log_file'} =$Que_info->{$job_id}{'-job_log_file'};
                my $log_file = $all_projects_info->{$lib_name}{'-NB_run'}{$Id}{'-job_log_file'};
                ef_lib::printl(sprintf("\nLOG : Netbatch job finished : %d/%s\n", $job_id, $all_projects_info->{$lib_name}{'-NB_run'}{$Id}{'-JobCmd'}), $main::log);
                ef_lib::printl(sprintf("LOG : @{$nbstatus_results}\n"), $main::log);
                open (LOG, "<$log_file") || die "Could not open log file $log_file. $!\n";    
                 my $log_arr = [];
                  @{$log_arr} = <LOG>;
                $all_projects_info->{$lib_name}{'-NB_run'}{$Id}{'-job_log'}= $log_arr;
                close(LOG);
#                @{$hierarchy{$lib_name}{$top_name}{'-job_log'}}= <LOG>;                       # Store the jobs log file into $hierarchy{$lib_name}{$top_name}{'-job_log'}
 
#$all_projects_info->{'-job_que'}{$job_id}{'-job_info_ref'}  

               delete $Que_info->{$job_id};
            }else{#(defined($nbstatus_results->[0])){
               ef_lib::printl(".", $main::log);
            }#(defined($nbstatus_results->[0])){
         }  # foreach my $job_id (keys $hierarchy{'-job_que'}) {
         sleep $StatusCheckDelay;
      }#   while ((keys $hierarchy{'-job_que'})>0) {
   
      ef_lib::printl("\nLOG : Que empty\n", $main::log);
   }# if (defined($hierarchy{'-job_que'}){
   ef_lib::printl("\nLOG : DONE\n", $main::log);
}# sub WaitForJobsQueCompletion(){


sub NBEnque($$$$){
   my $Id = shift;
   my $lib_name = shift;
   my $prj_dir = shift;
   my $job_info = shift;
   my $all_projects_info = shift;

   my $project_info = $all_projects_info->{$lib_name};
   my $results = [];
   my $JobCmd = $job_info->{'-JobCmd'};
   if ($main::EMUL_USE_NETBATCH==1) {
      ef_lib::wait_until_job_limit_not_reached($main::EMUL_MAX_JOB_CNT);
      my $prj_log_name = $prj_dir."/".$lib_name."_".$Id."_NBlog.log";
      my $NB_cmd = "nbjob run --log-file $prj_log_name $JobCmd";
#      Your job has been queued (JobID 1485860309, Class SUSE, Queue fm_vp, Slot /CSG/All/SIP/psf)
      @{$results} = `$NB_cmd`;
      if ($results->[0] =~ /^Your job has been queued.*/){
         $job_info->{'-job_submission'}= $results->[0];
         my $JobID = $results->[0];
         $JobID =~ s/^Your job has been queued \(JobID (\d+), Class .*/$1/;
         chomp $JobID;
         ef_lib::printl(sprintf("LOG : Submitting netbatch job : $JobID/$JobCmd\n"), $main::log);
         $job_info->{'-job_id'}= $JobID;
         $job_info->{'-job_status'}= "queued";
         $all_projects_info->{'-job_que'}{$Id}{$JobID}{'-lib_name'}= $lib_name;
         $all_projects_info->{'-job_que'}{$Id}{$JobID}{'-job_status'}= "queued";
         $all_projects_info->{'-job_que'}{$Id}{$JobID}{'-job_log_file'}= $prj_log_name;
         $all_projects_info->{'-job_que'}{$Id}{$JobID}{'-job_info_ref'}= $job_info;
         ef_lib::printl(sprintf("# $NB_cmd\n" ), $main::jobkillscript); 
         ef_lib::printl(sprintf("nbjob remove %d\n", $JobID ), $main::jobkillscript); 
         
      }else{#if ($results->[0] =~ /^Your job has been queued.*/){
         ef_lib::printl(sprintf("LOG : Submitting netbatch job : $JobCmd\n"), $main::log);
         ef_lib::printl(sprintf("LOG : Unexpected job start output : "), $main::log);
         print @{$results} ;
         $project_info->{'-NB_run'}{$Id}{'-job_status'}="FAILED";
      }# if ($results->[0] =~ /^Your job has been queued.*/){
   }else{#    if ($main::EMUL_USE_NETBATCH==1) {
      ef_lib::printl(sprintf("LOG : Start interactive job : $JobCmd\n"), $main::log);
      @{$results} = `$JobCmd`;
      ef_lib::printl(sprintf(print "LOG : Completed interactive job : $JobCmd\n"), $main::log);
      $job_info->{'-job_status'}="complete";
      $job_info->{'-job_log'}=$results;
   }#    if ($main::EMUL_USE_NETBATCH==1) {
}

sub PrepareSrcAndOptsPathsFiles($$){
   my $all_projects_info   = shift;
   my $prj_dir             = shift;
   my @lib_list = keys %{$all_projects_info};
   my $lib_name;

   foreach $lib_name (@lib_list){
      my $project_info  = $all_projects_info->{$lib_name};
      if (defined($project_info->{'-non_empty_project'}) == 1){
#         $prj_dir = $ENV{'EMUL_RESULTS_DIR'}."/SYNTH_FPGA/projects";
         if(not(-d $prj_dir)) {
            mkdir $prj_dir;
         }
         my $prj_filename           = $prj_dir."/".$lib_name.".prj";
         my $prj_Src_filename       = $prj_dir."/".$lib_name."_SrcFiles.tcl";
         my $prj_OptsPaths_filename = $prj_dir."/".$lib_name."_OptsPaths.tcl";
         my $prj_impl               = $lib_name."_toplevel_detect";
         my $prj_content= [];
         my $prj_cmds= [];

         WriteSrcAndOptsPathsFiles($project_info, $lib_name, $prj_Src_filename, $prj_OptsPaths_filename);
      }
   }
}

sub WriteSrcAndOptsPathsFiles($$$$){
   my $project_info           = shift;
   my $lib_name               = shift;
   my $prj_Src_filename       = shift;
   my $prj_OptsPaths_filename = shift;

   my @prj_Src= ();
   my @prj_OptsPaths= ();

   fpga_flow::CreateSynplifyProjectsSrcFiles($lib_name, $project_info, \@prj_Src);
   open (FH, ">$prj_Src_filename") || ef_lib::mydie ("Could not create project file $prj_Src_filename $!\n", $main::log);
   print FH "########################################\n";
   print FH "#   Project source files \n";
   print FH "########################################\n";
   print FH @prj_Src;
   close FH;

   fpga_flow::CreateSynplifyImplOptsPaths($lib_name, $project_info, \@prj_OptsPaths);
   open (FH, ">$prj_OptsPaths_filename") || ef_lib::mydie ("Could not create project file $prj_OptsPaths_filename $!\n", $main::log);
   print FH "########################################\n";
   print FH "#   Project Options and paths \n";
   print FH "########################################\n";
   print FH @prj_OptsPaths;
   close FH;

}

#sub CreateSynplifyProject($$$$$$$){
sub CreateSynplifyProject($$$$$$){
   my $prj                    = shift;
   my $prj_impl               = shift;
   my $prj_Src_filename       = shift;
   my $prj_OptsPaths_filename = shift;
   my $prj_content            = shift;
#    my $prj_param              = shift;
#    my $prj_link               = shift;
   my $prj_cmds              = shift;

   push (@{$prj_content}, "########################################\n");
   push (@{$prj_content}, "#   Project $prj \n");
   push (@{$prj_content}, "########################################\n");
   push (@{$prj_content}, "source $prj_Src_filename\n");
   push (@{$prj_content}, "########################################\n");
   push (@{$prj_content}, "#   Project implementation \n");
   push (@{$prj_content}, "########################################\n");
   push (@{$prj_content}, "#implementation: $prj_impl\n");
   push (@{$prj_content}, "impl -add $prj_impl -type fpga\n");
   push (@{$prj_content}, "#design plan options\n");
   push (@{$prj_content}, "source $ENV{'EMUL_CFG_DIR'}/fpga/defaul_impl.tcl\n");
   push (@{$prj_content}, "source $prj_OptsPaths_filename\n");
#    foreach my $l (@{$prj_param}){
#       push (@{$prj_content}, $l);
#    }
#    foreach my $l (@{$prj_link}){
#       push (@{$prj_content}, $l);
#    }
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

