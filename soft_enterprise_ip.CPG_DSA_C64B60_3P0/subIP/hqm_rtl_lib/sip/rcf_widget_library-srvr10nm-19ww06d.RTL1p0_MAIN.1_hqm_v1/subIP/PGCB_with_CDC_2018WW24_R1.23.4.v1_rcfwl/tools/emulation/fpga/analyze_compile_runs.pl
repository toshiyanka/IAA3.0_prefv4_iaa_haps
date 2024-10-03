#!/usr/intel/bin/perl
#This script is to parse the status.log file which is created by the FPGA flow
use strict;
use warnings;
use lib "$ENV{'EMUL_TOOLS_DIR'}/fpga/";
use ef_lib;
use synplicity;
use Cwd;
  
my @args = @ARGV;
my $debug = 0; #To determine the DEBUG messages to display

my $ERR_UNKNOWN = "UNKNOWN ERROR, please refer to Synplicity doc.";

#
#  Get command line arguments :
#     
#
my $compile_chk_log= $args[0]; 
our $log = $args[1]; 

my $timestamp = localtime;
$timestamp =~ s/\s/_/g;

printf(STDOUT "LOG : Analyze_compile_run Start : $timestamp\n");
open (LOG, ">$main::log") || die "Could not create log file $main::log. $!\n"; close LOG;



my @log_str;                                                            # 
my $ReturnStatus = 0;
 
my %lib_info;     # Contains info on errors indexed by lib name
my %status_lib;   # Contains library names indexed by compile status code
my %lib_status;   # Contains compile status code indexed by library names 

# initialize hash of array's with empty array.
for (keys %synplicity::status_code ){
   $status_lib{$_} = [];
}
# for each (lib name, exit status) pair of entries in the STAT file
ef_lib::printl("$timestamp\n", $main::log);
ef_lib::printl("#################################################################\n", $main::log);
ef_lib::printl("\n", $main::log);
ef_lib::printl("\tCHECK_FPGA flow results :\n", $main::log);
ef_lib::printl("\n", $main::log);
ef_lib::printl("#################################################################\n", $main::log);
ef_lib::printl("\n", $main::log);
ef_lib::printl("Reporting number of errors and first error for each lib:\n", $main::log);

&ProcessCompileLog();
&GenerateErrorReport();

open (LOG, ">>$main::log") || die "Could not open log file $main::log. $!\n";
print LOG @log_str;
close(LOG);

printf(STDOUT "Return status : $ReturnStatus\n");
printf(STDOUT "LOG : THE END\n");

exit $ReturnStatus;



sub ProcessCompileLog(){
   # The file status.log contains two lines for each compiled library : (lib name, exit status)
   open (STAT, "<$compile_chk_log") || die ("Could not open compile_chk_log file $compile_chk_log $!\n");
   my @Log_status = <STAT>;   # Read all entries from the status file into an array.
   close(STAT);
   
   
   my $exit_status;
   my $lib_name;
   while (scalar(@Log_status)>0){
      $lib_name = shift @Log_status;                                      # read the lib name from the report file
      chomp $lib_name;
      my $tmp = shift @Log_status;                                        # read the exit status from the report file
      chomp $tmp;
      ($tmp, $exit_status) = split(/=/, $tmp);
      while ((scalar(@Log_status)>0)&& ($Log_status[0]=~ /exit status.*/)){
         shift @Log_status;
      }#while ((scalar(@Log_status)>0)&& ($Log_status[0]=~ /exit status.*/)){
      if ($exit_status>=0){
      &ProcessLib($lib_name);
      }
      push(@{$status_lib{$exit_status}}, $lib_name);                       #
      $lib_status{$lib_name} = $exit_status;
   }#while (scalar(@Log_status)>0){
}


sub ProcessLib($){
   my $lib_name = shift;
   ef_lib::printl("Processing lib $lib_name\n",$main::log);
   my $SRR_filename;                                                    # Synplicity report file : [$lib_name]_rev.srr
   my $dir = getcwd;
   $SRR_filename = $dir."/".$lib_name."_rev/".$lib_name.".srr";
   open (SRR, "grep  '\@E[:\||]' $SRR_filename |")                           # Filter for error messages only, pipe the report file thru 'grep  "\@E[:\||]", equal to "@E:" or "@E|"
      || die ("Could not open $lib_name SRR file $SRR_filename $!\n");
   my @All_E = <SRR>;                                                   # Read all error lines into an array.
   my $All_E_cnt = $#All_E;                                             # Determine total numer of errors.
   my %E_num;                                                      # Prepare empty hash to store a count for each error type
   
   my $E_Code;
   my $E_Msg;    
   my $E_First_Code;
   my $E_First_Msg;    
   my @Err_split;
   my $E_0;
   ef_lib::printl(sprintf("Error count : %d\n", $All_E_cnt+1),$main::log);
   if ($All_E_cnt >=0){
      $E_0 = $All_E[0];
      chomp $E_0;
      if (($E_0 =~ /$@E\|(.*)/)==1){                                    # deal with error msg "@E|...."
          $E_First_Code = "ERR??";
          $E_First_Msg = $1;
      }else{#if (($E_0 =~ /$@E\|(.*)/)==1){                             # deal with error msg "@E: CODE : ...."
          @Err_split = split(':', $E_0, 3);                         # Store error type and error msg for first error in report file
          $E_First_Code = $Err_split[1];
          $E_First_Code =~ s/\s//g;
          $E_First_Msg = $Err_split[2];
      }#if (($E_0 =~ /$@E\|(.*)/)==1){
      $E_num{$E_First_Code} = 1;
      foreach my$E (@All_E){                                            # for each error detect error type and increment error type count
         chomp $E ;
         if (($E =~ /$@E\|(.*)/)==1){                                    # deal with error msg "@E|...."
             $E_Code = "ERR??";
             $E_Msg = $1;
         }else{ #if (($E =~ /$@E\|(.*)/)==1){                            # deal with error msg "@E: CODE : ...."
             @Err_split = split(':', $E, 3);                         # Store error type and error msg for first error in report file
             $E_Code = $Err_split[1];
             $E_Code =~ s/\s//g;
             $E_Msg = $Err_split[2];
         }#if (($E =~ /$@E\|(.*)/)==1){ 
         
         if (defined ($E_num{$E_Code})== 1){
            $E_num{$E_Code}++;
         }else{#if (defined ($E_num{$E_Code})== 1){
            $E_num{$E_Code} = 1;
         }#if (defined ($E_num{$E_Code})== 1){
      }

      ef_lib::printl("First error code : $E_First_Code\n",$main::log);
      ef_lib::printl("First error msg : $E_First_Msg\n",$main::log);
      my $Err_arr_ref = [];
      $lib_info{$lib_name}  = [$E_First_Code, $E_First_Msg, $Err_arr_ref, $SRR_filename] ;       #prepare the error context info for this lib : $E_First_Code, $E_First_Msg, @[error count, error type], SRR file name
      foreach my $key (sort { $E_num{$b} <=> $E_num{$a} } keys %E_num) {
         if (defined($E_num{$key})==1){
            push( @$Err_arr_ref, ($E_num{$key}, $key));
         }#if (defined($E_num{$key})==1){
      }#foreach my $key (sort { $E_num{$b} <=> $E_num{$a} } keys %E_num) {
   }
}

#
#  Write out error info extracted from report
#
sub GenerateErrorReport(){
   ef_lib::printl("\n\nGenerating error report.\n",$main::log);
   ef_lib::printl("Reports are grouped by Synplify return status.\n",$main::log);
   my $E_Code;
   my $E_Code_Cnt;
   for (sort {$b <=> $a} keys %synplicity::status_code){                                # write out report analisys sorted on the exit status code of each compile 25...>0
      my $E_Code = $_;                                                     # Exit status code
      my $E_Code_Cnt= (@{$status_lib{$E_Code}});                           # Exit status code count
      if ($E_Code_Cnt>0){                                                  # Dont report on exit status which didnt occur in any of the compiles
         push(@log_str, sprintf( "\n%s\t: %2d\n", $synplicity::status_code{$E_Code}, $E_Code_Cnt));  # write name of each error to @log_str for later printing
         foreach  (sort @{$status_lib{$E_Code}}){
            my $name = $_;
            chomp $name;
            if ($E_Code > 0){                                       # Dont report error status on compile with exite status "OK" (0)
               if (defined($lib_info{$name})==1){
                  push(@log_str, sprintf( "\t%s\n\t%s\n", $name, $lib_info{$name}[3]));                     # write name of each lib to @log_str for later printing
               }else{
                  push(@log_str, sprintf( "\t%s\n", $name));                     # write name of each lib to @log_str for later printing
               }
               $ReturnStatus = 1;
               if (defined($lib_info{$name}[0])){
                     my $i=0;
                     while (defined($lib_info{$name}[2][$i])){
                        my $Err_str ;
                        if (defined($synplicity::error_code{$lib_info{$name}[2][$i+1]})==1){
                           $Err_str  = $synplicity::error_code{$lib_info{$name}[2][$i+1]};
                        }else{
                           $Err_str  = $ERR_UNKNOWN; 
                        }
                        if  ($E_Code > 0){                                       # Dont report error status on compile with exite status "OK" (0)
                           push(@log_str, sprintf( "%8d : %6s %s \n", $lib_info{$name}[2][$i], $lib_info{$name}[2][$i+1], $Err_str));
                        }
                        $i++; $i++;
                     }#while (defined($lib_info{$name}[2][$i])){
               }else{#if (defined($lib_info{$name}[0])){
                  push(@log_str, sprintf( "\t : no errors.\n"));                     # indicate : no errors
               }#if (defined($lib_info{$name}[0])){
            }else{# if ($E_Code > 0){
                push(@log_str, sprintf( "\t%s\n", $name)); 
            }# if ($E_Code != 0){
         }#foreach  (sort @{$status_lib{$E_Code}}){
      }#if ($E_Code_Cnt>0){
   }
}#sub GenerateErrorReport(){
