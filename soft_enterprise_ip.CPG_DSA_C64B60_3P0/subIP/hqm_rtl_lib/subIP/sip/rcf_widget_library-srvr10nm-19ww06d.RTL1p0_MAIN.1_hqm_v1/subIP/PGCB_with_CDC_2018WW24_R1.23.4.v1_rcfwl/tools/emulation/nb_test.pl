#!/usr/intel/bin/perl
#This script will test netbatch
use strict;
use warnings;
use lib "$ENV{'EMUL_TOOLS_DIR'}/fpga/";


use ef_lib;
use fpga_flow;

our %hierarchy;
# Log file initialisation output file : /tmp/clean_metadata.log
our $log = $ENV{'EMUL_RESULTS_DIR'}."/nb_test.log"; 
open (LOG, ">$log") || die "Could not create log file $log. $!\n";      # Exsisting log file will be overwriten
close LOG;

our $jobkillscript = $ENV{'EMUL_RESULTS_DIR'}."nb_test_jobkillscript.tcsh";
if (defined($jobkillscript)){
   &ef_lib::printl("NB_TEST : Job kill script $jobkillscript\n",$main::log);
   open (LOG, ">$jobkillscript") || die "Could not create job kill script $jobkillscript. $!\n"; 
   close LOG;
   `chmod 750 $jobkillscript`;
}else{
   &ef_lib::printl("LOG : jobkillscript file not defined, exiting.\n",$main::log);
   exit -1;
}

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



sub SubmitJob($$){
my $Job_cmd = shift;
my $Job_name = shift;
 
   my $prj_log_name;
   my $results = [];
   
   $prj_log_name = $Job_name.".log";
   @{$hierarchy{$Job_name}{'-job_cmd'}} = $Job_cmd;
   my $NB_cmd = "nbjob run --log-file $prj_log_name $Job_cmd";
#      Your job has been queued (JobID 1485860309, Class SUSE, Queue fm_vp, Slot /CSG/All/SIP/psf)
   @{$results} = `$NB_cmd`;
   if ($results->[0] =~ /^Your job has been queued.*/){
      @{$hierarchy{$Job_name}{'-job_submission'}}= $results->[0];
      my $JobID = $results->[0];
      $JobID =~ s/^Your job has been queued \(JobID (\d+), Class .*/$1/;
      chomp $JobID;
      ef_lib::printl(sprintf("Submitting netbatch job : $Job_name/$Job_cmd\n"), $main::log);
      $hierarchy{$Job_name}{'-job_id'}= $JobID;
      $hierarchy{$Job_name}{'-job_status'}= "queued";
      $hierarchy{'-job_que'}{$JobID}{'-Job_name'}= $Job_name;
      $hierarchy{'-job_que'}{$JobID}{'-job_status'}= "queued";
      $hierarchy{'-job_que'}{$JobID}{'-job_log_file'}= $prj_log_name;
      ef_lib::printl(sprintf("# $NB_cmd\n" ), $main::jobkillscript); 
      ef_lib::printl(sprintf("nbjob remove %d\n", $JobID ), $main::jobkillscript); 
      
   }else{#if ($results->[0] =~ /^Your job has been queued.*/){
      ef_lib::printl(sprintf("Submitting netbatch job : $Job_cmd\n"), $main::log);
      ef_lib::printl(sprintf("Unexpected job start output : "), $main::log);
      print @{$results} ;
      @{$hierarchy{$Job_cmd}{'-job_status'}}="FAILED";
   }# if ($results->[0] =~ /^Your job has been queued.*/){
}#SubmitJob

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
      my $StatusCheckDelay = 1; #Delay between status check update loops
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
            my $nbstatus_cmd = "nbstatus jobs --hi 3d \"user=='$USER'\" | uniq | grep ".$job_id;
            my $nbstatus_results = [];
            @{$nbstatus_results} = `$nbstatus_cmd`;
            if (defined($nbstatus_results->[0])){                                            # if nbstatus returned a respons for this ID the job has terminated
               my @words;
               @words = split(/\s+/, $nbstatus_results->[0] );                               # split nbstatus and store the status into the hash $hierarchy{$lib_name}{$top_name}
               my $Job_name = $hierarchy{'-job_que'}{$job_id}{'-Job_name'};
               $hierarchy{$Job_name}{'-job_status'} ="complete";
               $hierarchy{$Job_name}{'-job_log_file'} =$hierarchy{'-job_que'}{$job_id}{'-job_log_file'};
               my $log_file = $hierarchy{'-job_que'}{$job_id}{'-job_log_file'};
               ef_lib::printl(sprintf("\nNetbatch job finished : %d/%s\n", $job_id, @{$hierarchy{$Job_name}{'-job_cmd'}}), $main::log);
               ef_lib::printl(sprintf("@{$nbstatus_results}\n"), $main::log);
               open (LOG, "<$log_file") || die "Could not open log file $log_file. $!\n";    
               @{$hierarchy{$Job_name}{'-job_log'}}= <LOG>;                       # Store the jobs log file into $hierarchy{$lib_name}{$top_name}{'-job_log'}
   
               delete $hierarchy{'-job_que'}{$job_id};
            }else{#(defined($nbstatus_results->[0])){
               ef_lib::printl(".", $main::log); 
            }#(defined($nbstatus_results->[0])){
         }  # foreach my $job_id (keys $hierarchy{'-job_que'}) {
         if (($StatusCheckLoopCnt%(1*60/$StatusCheckDelay))==0){
            my $JobCnt = 0;
            foreach my $job_id (keys %{$hierarchy{'-job_que'}}) {                                  # for each qued job request nbstatus
               my $Job_name = $hierarchy{'-job_que'}{$job_id}{'-Job_name'};
               my $nbqstat_cmd = "nbqstat | grep ".$job_id;
               my $nbqstat_results  = [];
               @{$nbqstat_results} = `$nbqstat_cmd`;
               $JobCnt++;
               ef_lib::printl(sprintf("\nNetbatch job status : %d/%s\n", $job_id, $Job_name), $main::log);
#               ef_lib::printl(sprintf("@{$nbqstat_results}\n"), $main::log);
            }
            $StatusCheckLoopCnt=0;
            ef_lib::printl(sprintf("Active job count : %d\n", $JobCnt), $main::log);
         }
         ef_lib::printl("/", $main::log); 
      }#   while ((keys $hierarchy{'-job_que'})>0) {
   
      ef_lib::printl("\nQue empty\n", $main::log);
   }# if (defined($hierarchy{'-job_que'}){
   ef_lib::printl("\nDONE\n", $main::log);
}# sub WaitForCompletionOfQuedJobs(){

my $Job_cmd = "sleep ";
my $Job_name = "job_";
 
my $i = 1;
SubmitJob($Job_cmd.10*$i,  $Job_name.$i);
$i++;
SubmitJob($Job_cmd.10*$i,  $Job_name.$i);
$i++;
SubmitJob($Job_cmd.10*$i,  $Job_name.$i);
$i++;
WaitForCompletionOfQuedJobs();
