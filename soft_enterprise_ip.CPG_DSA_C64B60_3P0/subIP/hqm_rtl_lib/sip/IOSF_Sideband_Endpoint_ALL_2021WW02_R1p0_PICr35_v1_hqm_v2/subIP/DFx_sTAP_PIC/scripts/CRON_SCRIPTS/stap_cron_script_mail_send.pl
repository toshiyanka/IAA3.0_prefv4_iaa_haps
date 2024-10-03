
#!/usr/intel/pkgs/perl/5.14.1/bin/perl 

#********************************************************************************************************************************************************************
# INTEL CONFIDENTIAL
# Copyright 2017 Intel Corporation All Rights Reserved.

# The source code contained or described herein and all documents related to the source code (Material) are owned by Intel Corporation or its suppliers or licensors. 
# Title to the Material remains with Intel Corporation or its suppliers and licensors. 
# The Material contains trade secrets and proprietary and confidential Information of Intel or its suppliers and licensors. 
# The Material is protected by worldwide copyright and trade secret laws and treaty provisions. 
# No part of the Material may be used, copied, reproduced, modified, published, uploaded, posted,transmitted, distributed, or disclosed 
# in any way without Intel's prior express written permission.

# No license under any patent, copyright, trade secret or other intellectual property right is granted to or conferred upon you by disclosure or
# delivery of the Materials, either expressly, by implication, inducement,estoppel or otherwise. Any license under such 
# intellectual property rights must be express and approved by Intel in writing.

# Collateral Description:
# %header_collateral%

# Source organization:
# %header_organization%

# Support Information:
# %header_support%

# Revision:
# %header_tag%

#Module dfxagg_core :  Core Top level file

#**********************************************************************************************************************************************************************
# Name of the file : _cron_script.pl
# Author of file   : Srikanth Goud P
# Descripton       : This is a perl script developed for running using a cron job.
#                    It pulls a new stap repository, Runs dfx_configIP.pl script the runs customer specific regressions and mails the report to mailids listed in cron_mail.list
# Dependencies     : script.sh file and cron_mail.list are necessory files and should be in the same directory.
# Date of creation : Nov 28 2017
#***********************************************************************************************************************************************************************
use FindBin qw($Bin);
use Getopt::Long;
sub print_help {
    print qq(
    Script         :  stap_cron_script.pl
    Description    :  This is a perl script developed for running using a cron job.
    Dependencies   :  script.sh file and cron_mail.list are necessory files and should be in the same directory.
    Options        :
                      -Help|help|h                 : Print this message
                      -cron_ip_name=s              : Takes name of the IP
                      -cron_path=s                 : Regression disk path
                      -cron_mail_list=s            : Mailing list to send report
                      -regress_command_file=s      : File that contains compile ,regression and other commands if required );

    
    exit (0);
} 


		&GetOptions ( 	
                     'h|help|Help'             =>    \&print_help,
                     'cron_ip_name=s'          =>    \my $cron_ip_name,
                     'cron_path=s'             =>    \my $cron_path,
                     'cron_mail_list=s'        =>    \my $cron_mail_list,
                     'regress_command_file=s'  =>    \my $regress_command_file,
                     'cust=s'                  =>	  \my $cust,
                     );
#Stores current directory
$script_directory=$Bin;

#Setting Defaults
unless($cron_ip_name)
{
   $cron_ip_name="stap";
}
unless($cron_path)
{
   $cron_path="/nfs/iind/disks/dteg_disk002/users/TAP_CRON/STAP_CRON";
}
unless($cron_mail_list)
{
   $cron_mail_list = "$script_directory/cron_mail.list"; 
}
unless($cust)
{
   $cust= "ADL";
}

#Encoding Directory Name based on run time and IP name
#$cron_user_name=$ENV{"USER"};
#$cron_ip_path=$cron_path."/".$cron_user_name;
#$ip=uc $cron_ip_name;
##`rm -rf $cron_ip_path/stap*`;
#$nowtime = localtime ;
#if ($nowtime =~ /(\S+)\s+(\S+)\s+(\S+)/) {
#   $nowdate = $ip."_".$1." ".$2." ".$3;
#};
#if ($nowtime =~ /(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)/) {
#   $dirName = $ip."_".$1."_".$3."_".$2."_".$5;
#};
#my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =localtime(time);
#$dirName = $dirName."_".$hour."_".$min;
#$IP_ROOT="$cron_ip_path/$dirName/dteg-$cron_ip_name"; 
$IP_ROOT="/nfs/iind/disks/dteg_disk002/users/TAP_CRON/STAP_CRON/snaray6x/STAP_Wed_8_May_2019_11_17/dteg-stap"; 
#$nowtime = localtime ;
#if ($nowtime =~ /(\S+)\s+(\S+)\s+(\S+)/) {
#   $nowdate = $1." ".$2." ".$3;
#};

$ENV{IP_ROOT}= $IP_ROOT;
`setenv IP_ROOT $IP_ROOT`;
`source /p/hdk/rtl/hdk.rc -cfg sip`;
system("source /p/hdk/rtl/hdk.rc -cfg sip");

#Running The script that compiles and runs regression
system( "/usr/intel/bin/tcsh", "$script_directory/script.sh","$cron_ip_path/$dirName","$cust");
$cust_UC = uc $cust;

`find $IP_ROOT/target/stap/ -name "pass.list" > $IP_ROOT/pass_list`;
`find $IP_ROOT/target/stap/ -name "fail.list" > $IP_ROOT/fail_list`;
`find $IP_ROOT/target/stap/ -name "unknown.list" > $IP_ROOT/unknown_list`;

$pass=0;
$fail=0;
$unknown=0;
$seed=1;
open(PASS , "<$IP_ROOT/pass_list");
open(FAIL , "<$IP_ROOT/fail_list");
open(UNKNOWN , "<$IP_ROOT/unknown_list");

while(my $line =<PASS>)
{
chomp($line);
$pass+=`grep \\\\-test\\ \\=\\>\\ \\\" $line | wc -l`;
}
while(my $line =<FAIL>)
{
chomp($line);
$fail+=`grep \\\\-test\\ \\=\\>\\ \\\" $line | wc -l`;
}
while(my $line =<UNKNOWN>)
{
chomp($line);
$unknown+=`grep \\\\-test\\ \\=\\>\\ \\\" $line | wc -l`;
}
$seed = $pass+$fail+$unknown;

if($seed ne $pass)
{
`cp $IP_ROOT/fail_list $IP_ROOT/fail_list.txt`;
}

$pass_rate = sprintf("%.2f",(($pass/$seed)*100));
$sha = `tail -1 .git/logs/HEAD | awk '{print \$2}'`;

#$coverage = `head -21 $ENV{IP_ROOT}/target/*/*/*/*/AllCov/dashboard.txt | tail -9`;
#print STATUS "$coverage";
`find $IP_ROOT/target/stap/ADL/*/aceroot/ -name "postsim.fail" | xargs grep -A 3 "Error Summary" | awk '/Error Summary/{n=NR} NR > n+2 {print}' | uniq >> $IP_ROOT/ovm_errors_with_failing_tests.txt`;

#Preparing mail body
open(STATUS, ">$IP_ROOT/CRON_STATUS.log") or die "Could not open file \n";
print STATUS "\n\nNote: This is an auto generated mail from $ip IP  cron regression . . . . \n\n";
$ip_root = `echo $IP_ROOT`;
print STATUS "THE CRON PATH\n";
print STATUS "\n$ip_root\n";
print STATUS "\n\nOVERALL REGRESSION STATUS: $pass_rate % PASS \n\n\n";
print STATUS "\n ------------------------------------------------------------------------------------------ \n";
print STATUS "              $ip IP $cust CRON REGRESSION STATUS as on ".`date`;
print STATUS "\n ------------------------------------------------------------------------------------------ \n";


   print "\n The cron job has been completed";  
   print STATUS "      TOTAL_TESTS          PASS           FAIL                                          \n"; 
  
   print STATUS "\n ------------------------------------------------------------------------------------------ \n";
   print STATUS "   \ \ \ \ \ $seed                         $pass                     $fail                     \n";
   print STATUS "\n ------------------------------------------------------------------------------------------ \n";
print STATUS "\n\n---------------------------------------\n";

#print STATUS "\n \nCOVERAGE REPORT:";
#print STATUS "\n \n $coverage";

#print STATUS "\n \nCoverage report path ";
#print STATUS "\n \n file://inecsamba.iind.intel.com$IP_ROOT/AllCov/hierarchy.html";

print STATUS "\n\n---------------------------------------\n";

print STATUS "\n\n\nIf any failure, please see the attached fail_list.txt for failure list...\n\n" if($fail > 0);
print STATUS "Refer $IP_ROOT/target/stap/$cust_UC/*/aceroot/*/results/tests/ Directory for Logs";
print STATUS "\n\n-------------\n";
print STATUS "\n\n Sha id = $sha\n";
print STATUS "Thanks...\n";
print STATUS "$ENV{USER}\n";
close(STATUS);
$ip=uc $cron_ip_name;

#Open mail list
open (MAIL_LIST, "<$cron_mail_list") or die "Could not open $cron_mail_list\n";
@members = <MAIL_LIST>;
foreach(@members) {
   chomp;
   $mail_id = $mail_id.$_ . ",";
}

#mail Subject
$subject = $ip. " $cust configuration Cron regression status:  $pass_rate % PASS  ";
$nowtime = localtime ;
#Send mail
if($fail)
{
$mail_cmd = "mail $mail_id -s \"$subject on $nowdate\" -a  $IP_ROOT/fail_list.txt <  $IP_ROOT/CRON_STATUS.log";
}
else{
$mail_cmd = "mail $mail_id -s \"$subject on $nowdate\"  <  $IP_ROOT/CRON_STATUS.log";
}
print "\n Sending mail \n $mail_cmd \n please wait...";
$rslt = system ($mail_cmd);   
print "\n Sent mail \n";
#`find $cron_ip_path -maxdepth 1 ! -mtime -2 -exec rm -rf {} \\;`;
print "\nInfo: Deleted..";

exit(0); 
