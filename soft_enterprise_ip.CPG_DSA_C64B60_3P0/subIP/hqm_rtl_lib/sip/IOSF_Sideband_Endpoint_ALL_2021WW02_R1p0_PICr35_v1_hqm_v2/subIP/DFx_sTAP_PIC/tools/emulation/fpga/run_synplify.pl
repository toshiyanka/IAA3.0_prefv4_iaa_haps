#!/usr/intel/bin/perl
use strict;
use warnings;
use Getopt::Long;
use lib "$ENV{'EMUL_TOOLS_DIR'}/fpga/";

use ef_lib;

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

my $synplify_premier= ef_lib::which_synplify_premier();
# Command line options : 
our $control_file;
our $status_file = "status.log";
our $jobkillscript = $ENV{'EMUL_RESULTS_DIR'}."/CHECK_FPGA/jobkillscript.tcsh";
our $log = $ENV{'EMUL_RESULTS_DIR'}."/CHECK_FPGA/run_synplify_projects.log"; 
GetOptions(
   'control=s'=> \$control_file, 
   'status=s'=> \$status_file, 
   'jobkillscript=s' =>\$main::jobkillscript,
   'log=s' =>\$main::log
   );

# Check if all files can be access
open (LOG, ">$main::log") || die "Could not create log file $main::log. $!\n"; 
close LOG;
if (defined($control_file)){
   &ef_lib::printl("RUN_SYNPLIFY : Control input file $control_file\n",$main::log);
   open (CTRL, "<$control_file") || die "Could not open control file $control_file. $!\n"; 
   close CTRL;
}else{
   &ef_lib::printl("ERR : control file not defined.",$main::log);
}
if (defined($status_file)){
   &ef_lib::printl("RUN_SYNPLIFY : Status output file $status_file\n",$main::log);
   open (LOG, ">$status_file") || die "Could not create status file $status_file. $!\n"; 
   close LOG;
}else{
   $status_file = "status.log";
   &ef_lib::printl("LOG : status file not defined, using default : status.log.\n",$main::log);
}

if (defined($jobkillscript)){
   &ef_lib::printl("RUN_SYNPLIFY : Job kill script $jobkillscript\n",$main::log);
   open (LOG, ">$jobkillscript") || die "Could not create job kill script $jobkillscript. $!\n"; 
   close LOG;
   `chmod 750 $jobkillscript`;
}else{
   &ef_lib::printl("LOG : status file not defined, using default : status.log.\n",$main::log);
}

my $debug = 0; #To determine the DEBUG messages to display


require $control_file;
our %hierarchy;



&CompileAllLibs();
&WaitForCompletionOfQuedJobs();
&WriteAllStatus();
exit 0;

sub WriteAllStatus(){
   foreach my $db_key (keys %hierarchy) {
      if ($db_key !~ "\-.+"){
   #      printf(STDOUT "Lib : %s\n", $db_key);
         if (defined(@{$hierarchy{$db_key}{'-top'}})){
            foreach my $top (@{$hierarchy{$db_key}{'-top'}}){
               &WritePrjStatus($db_key, $top);
            }#foreach my $top (@{$hierarchy{$db_key}{'-top'}}){
         }else{#if (defined(@{$hierarchy{$db_key}{'-top'}})){
            &WritePrjStatus($db_key, "");
         }#if (defined(@{$hierarchy{$db_key}{'-top'}})){
      }#if ($db_key !~ "\-.+"){
   
   }#foreach my $db_key (keys %hierarchy) {
}
sub WritePrjStatus($$){
   my $lib_name = shift;
   my $top_name = shift;
   my $prj_name;
   if ($top_name ne ""){
      $prj_name = $lib_name."_".$top_name;
   }else{
      $prj_name = $lib_name;
      $top_name= "NoTop";
   }#if (defined($top_name)){
   
   my $job_status = $hierarchy{$lib_name}{$top_name}{'-job_status'};
   if ($job_status eq "FAILED"){
      &ef_lib::printl("$prj_name\n",$status_file);
      &ef_lib::printl("exit status=-99\n",$status_file);
   }else{
      foreach my $line (@{$hierarchy{$lib_name}{$top_name}{'-job_log'}}){
         if ($line =~ /exit status.*/){
            &ef_lib::printl("$prj_name\n",$status_file);
            &ef_lib::printl($line,$status_file);
            return 0;
         }
      }
      &ef_lib::printl("$prj_name\n",$status_file);
      &ef_lib::printl("exit status=-98\n",$status_file);
   }
}
#
#
#  Start all jobs :
#     For each library in %hierarchy
#        For each top_module listed
#           Start a Synplicity_premier compile : "lib_name"_"top_name".
#        If no top_module is defined
#           Start a Synplicity_premier compile : "lib_name".
##
sub CompileAllLibs(){
   foreach my $db_key (keys %hierarchy) {
      if ($db_key !~ "\-.+"){
   #      printf(STDOUT "Lib : %s\n", $db_key);
         if (defined(@{$hierarchy{$db_key}{'-top'}})){
            foreach my $top (@{$hierarchy{$db_key}{'-top'}}){
               &CompileLib($db_key, $top);
            }#foreach my $top (@{$hierarchy{$db_key}{'-top'}}){
         }else{#if (defined(@{$hierarchy{$db_key}{'-top'}})){
            my $top;
            &CompileLib($db_key, $top);
         }#if (defined(@{$hierarchy{$db_key}{'-top'}})){
      }#if ($db_key !~ "\-.+"){
   
   }#foreach my $db_key (keys %hierarchy) {
}# sub StartAllJobs(){

#
#
#  CompileLib($lib_name, $top_name):
#     For each top_module listed
#        Start a Synplicity_premier compile : "lib_name"_"top_name".
#     If no top_module is defined
#        Start a Synplicity_premier compile : "lib_name".
#
sub CompileLib($$){
my $lib_name = shift;
my $top_name = shift;
   
   
   my $JobCmd;
   my $prj_name;
   my $prj_log_name;
   my $results = [];
   
   if (defined($top_name)){
      $prj_name = $lib_name."_".$top_name.".prj";
      $prj_log_name = $lib_name."_".$top_name.".log";
   }else{
      $prj_name = $lib_name.".prj";
      $prj_log_name = $lib_name.".log";
      $top_name= "NoTop";
   }#if (defined($top_name)){
#   ef_lib::printl(sprintf("Lib/top : %s/%s\n", $lib_name, $top_name), $main::log);
   $JobCmd = "$synplify_premier ".$prj_name." -compile -batch -license_wait| tee $prj_log_name";
#    my $delay = int(rand(30));
#    $JobCmd = "tmp_job $delay";
   @{$hierarchy{$lib_name}{$top_name}{'-job_cmd'}} = $JobCmd;
   if ($EMUL_USE_NETBATCH) {
      ef_lib::wait_until_job_limit_not_reached($main::EMUL_MAX_JOB_CNT);
      my $NB_cmd = "nbjob run --log-file $prj_log_name $JobCmd";
#      Your job has been queued (JobID 1485860309, Class SUSE, Queue fm_vp, Slot /CSG/All/SIP/psf)
      @{$results} = `$NB_cmd`;
      if ($results->[0] =~ /^Your job has been queued.*/){
         @{$hierarchy{$lib_name}{$top_name}{'-job_submission'}}= $results->[0];
         my $JobID = $results->[0];
         $JobID =~ s/^Your job has been queued \(JobID (\d+), Class .*/$1/;
         chomp $JobID;
         ef_lib::printl(sprintf("Submitting netbatch job : $JobID/$JobCmd\n"), $main::log);
         $hierarchy{$lib_name}{$top_name}{'-job_id'}= $JobID;
         $hierarchy{$lib_name}{$top_name}{'-job_status'}= "queued";
         $hierarchy{'-job_que'}{$JobID}{'-lib_name'}= $lib_name;
         $hierarchy{'-job_que'}{$JobID}{'-top_name'}= $top_name;
         $hierarchy{'-job_que'}{$JobID}{'-job_status'}= "queued";
         $hierarchy{'-job_que'}{$JobID}{'-job_log_file'}= $prj_log_name;
         ef_lib::printl(sprintf("# $NB_cmd\n" ), $main::jobkillscript); 
         ef_lib::printl(sprintf("nbjob remove %d\n", $JobID ), $main::jobkillscript); 
         
      }else{#if ($results->[0] =~ /^Your job has been queued.*/){
         ef_lib::printl(sprintf("Submitting netbatch job : $JobCmd\n"), $main::log);
         ef_lib::printl(sprintf("Unexpected job start output : "), $main::log);
         print @{$results} ;
         @{$hierarchy{$lib_name}{$top_name}{'-job_status'}}="FAILED";
      }# if ($results->[0] =~ /^Your job has been queued.*/){
   }else{#    if ($EMUL_USE_NETBATCH) {
      ef_lib::printl(sprintf("Start interactive job : $JobCmd\n"), $main::log);
      @{$results} = `$JobCmd`;
      ef_lib::printl(sprintf(print "Completed interactive job : $JobCmd\n"), $main::log);
      @{$hierarchy{$lib_name}{$top_name}{'-job_status'}}="complete";
      @{$hierarchy{$lib_name}{$top_name}{'-job_log'}}=@{$results};
   }#    if ($EMUL_USE_NETBATCH) {
}#StartJob


#
#  WaitForCompletionOfQuedJobs() :
#     If jobs are submitted thru netbatch then the job information is stored in the $hierarchy{'-job_que'}
#     Each job's status is requested 
#
sub WaitForCompletionOfQuedJobs(){
   my $job_cnt;
   if (defined($hierarchy{'-job_que'})) {                                                    # if there are any jobs qued
      my $timestamp = localtime;
      my $prev_job_cnt = scalar(keys %{$hierarchy{'-job_que'}});
      ef_lib::printl(sprintf("\nNumber of jobs remaining in que : %d (%s)\n", $prev_job_cnt, $timestamp), $main::log);
      
      my $StatusCheckLoopCnt= 0;                                                             # Provide periodic status update 
      my $StatusCheckDelay = 5; #Delay between status check update loops
      while ((keys %{$hierarchy{'-job_que'}})>0) {                                              # keep checking job status until no jobs remaining
         $StatusCheckLoopCnt++;
         $job_cnt = scalar(keys %{$hierarchy{'-job_que'}});
         if ($prev_job_cnt > $job_cnt){                                                      # If the number of qued jobs status show current count
            my $timestamp = localtime;
            ef_lib::printl(sprintf("\nNumber of jobs remaining in que : %d (%s)\n", $job_cnt, $timestamp), $main::log);
         }
         $prev_job_cnt = $job_cnt;
         foreach my $job_id (keys %{$hierarchy{'-job_que'}}) {                                  # for each qued job request nbstatus
   #         printf(STDOUT "Que status : %d\n", $job_id);
            my $nbstatus_cmd = "nbstatus jobs --hi 3d \"user=='$main::USER'\" | uniq | grep ".$job_id;
            my $nbstatus_results = [];
            @{$nbstatus_results} = `$nbstatus_cmd`;
            if (defined($nbstatus_results->[0])){                                            # if nbstatus returned a respons for this ID the job has terminated
               my @words;
               @words = split(/\s+/, $nbstatus_results->[0] );                               # split nbstatus and store the status into the hash $hierarchy{$lib_name}{$top_name}
               my $lib_name = $hierarchy{'-job_que'}{$job_id}{'-lib_name'};
               my $top_name = $hierarchy{'-job_que'}{$job_id}{'-top_name'};
               $hierarchy{$lib_name}{$top_name}{'-job_status'} ="complete";
               $hierarchy{$lib_name}{$top_name}{'-job_log_file'} =$hierarchy{'-job_que'}{$job_id}{'-job_log_file'};
               my $log_file = $hierarchy{'-job_que'}{$job_id}{'-job_log_file'};
               ef_lib::printl(sprintf("\nNetbatch job finished : %d/%s\n", $job_id, @{$hierarchy{$lib_name}{$top_name}{'-job_cmd'}}), $main::log);
               ef_lib::printl(sprintf("@{$nbstatus_results}\n"), $main::log);
               open (LOG, "<$log_file") || die "Could not open log file $log_file. $!\n";    
               @{$hierarchy{$lib_name}{$top_name}{'-job_log'}}= <LOG>;                       # Store the jobs log file into $hierarchy{$lib_name}{$top_name}{'-job_log'}
   
               delete $hierarchy{'-job_que'}{$job_id};
            }else{#(defined($nbstatus_results->[0])){
               ef_lib::printl(".", $main::log); 
            }#(defined($nbstatus_results->[0])){
         }  # foreach my $job_id (keys $hierarchy{'-job_que'}) {
         if (($StatusCheckLoopCnt%(1*60/$StatusCheckDelay))==0){
            my $JobCnt = 0;
            foreach my $job_id (keys %{$hierarchy{'-job_que'}}) {                                  # for each qued job request nbstatus
               my $lib_name = $hierarchy{'-job_que'}{$job_id}{'-lib_name'};
               my $top_name = $hierarchy{'-job_que'}{$job_id}{'-top_name'};
               my $nbqstat_cmd = "nbqstat | grep ".$job_id;
               my $nbqstat_results  = [];
               @{$nbqstat_results} = `$nbqstat_cmd`;
               $JobCnt++;
               ef_lib::printl(sprintf("\nNetbatch job status : %d/%s/%s\n", $job_id, $lib_name, $top_name), $main::log);
#               ef_lib::printl(sprintf("@{$nbqstat_results}\n"), $main::log);
            }
            $StatusCheckLoopCnt=0;
            ef_lib::printl(sprintf("Active job count : %d\n", $JobCnt), $main::log);
         }
         sleep $StatusCheckDelay;
      }#   while ((keys $hierarchy{'-job_que'})>0) {
   
      ef_lib::printl("\nQue empty\n", $main::log);
   }# if (defined($hierarchy{'-job_que'}){
   ef_lib::printl("\nDONE\n", $main::log);
}# sub WaitForCompletionOfQuedJobs(){


