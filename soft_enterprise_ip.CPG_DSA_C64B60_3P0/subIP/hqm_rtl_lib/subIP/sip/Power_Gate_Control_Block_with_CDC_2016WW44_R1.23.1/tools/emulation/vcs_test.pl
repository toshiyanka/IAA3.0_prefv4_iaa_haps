#!/usr/intel/bin/perl



use strict;
use warnings;
use Env;
use File::Spec;
use Data::Dump qw(dump);
use Data::Dumper;
use UNIVERSAL;
use File::Basename;
use Data::Dump qw(dump);
use Data::Dumper;

$Data::Dumper::Terse = 1;
$Data::Dumper::Quotekeys  = 1;
$Data::Dumper::Indent = 1;
$Data::Dumper::Purity = 1;
$Data::Dumper::Sortkeys = 1;

my $StartTimeStamp = localtime();  # Program start

# Verbosity level definitions :
my $VERBOSE = 0;
my $ERROR = 1;
my $WARNING = 2;
my $INFO = 3;


my $debug = $WARNING; # Determines the DEBUG message level to display. printl with debug_level<= debug will be printed.

my $ResultsDir = $ARGV[0];
# Log file initialisation output file : /tmp/clean_metadata.log
my $log = $ResultsDir."/vcs_test.log";
open (LOG, ">$log") || die "Could not create log file $log. $!\n";      # Exsisting log file will be overwriten
close LOG;
&printl("Start time : $StartTimeStamp\n",$log, $VERBOSE);


sub dump_hash($$$){
  my $var_name = shift;
  my $ref = shift;
  my $filename = shift;

   my $h;
   open($h, ">", $filename) or die "cannot open < $filename : $!";
   my $Str = Dumper($ref);
   my @Lines = split(/\n/, $Str);
   my $timestamp = localtime;
   $timestamp =~ s/\s/_/g;
   print $h  "# $timestamp\n";
   print $h  "\%$var_name = (\n";
   for(my $i=1; $i<$#Lines; $i++){ 
      print $h  "$Lines[$i]\n";
   }
   print $h  ");\n";
   close($h);

}


sub read_file($){
my $f_filename = shift;

   $f_filename =~ s/\$(\w+)/$ENV{$1}/g;
   open (FILE, "<$f_filename") || die "Could not open -f file $f_filename. $!\n";
   my $return_lst;
   while (<FILE>){
      my $arg_lst;
      $arg_lst = &split_vlogan_args($_);
      push(@{$return_lst}, @{$arg_lst});
   }
   return $return_lst;
}


sub split_vlogan_args($) {
   my $opt     = shift;
   my @opt_lst;
   my $return_lst;
   (@opt_lst) = split(' ', $opt);
   my $opt_cnt = scalar(@opt_lst);
   for (my $i=0; $i<$opt_cnt; $i++){
      my $opt_result = $opt_lst[$i];
#      print ("$i : $opt_result\n");
      if ($i+1<$opt_cnt){
         my $leading_char = substr($opt_lst[$i+1], 0, 1);
         if (($leading_char ne '-') & ($leading_char ne '+')){
            if($opt_result =~ /^\-f(.*)?$/) {
               $i++;
               &printl("push -f : $opt_lst[$i]\n",$log, $VERBOSE);
               my $f_lst = read_file($opt_lst[$i]);
               push(@{$return_lst}, @{$f_lst});
            }else{
               $opt_result =$opt_result." ".$opt_lst[$i+1];
               $i++;
               push(@{$return_lst}, $opt_result);
               &printl("push : $opt_result\n",$log, $VERBOSE);
            }
         }else{
            push(@{$return_lst}, $opt_result);
            &printl("push +-: $opt_result\n",$log, $VERBOSE);
         } 
      }else{
          push(@{$return_lst}, $opt_result);
          &printl("push last : $opt_result\n",$log, $VERBOSE);
      }
    }

   return $return_lst;
}


sub Read_VCS_vlogan_log($){
my $log_filename= shift;

   open (VCSLOG, "<$log_filename") || die "Could not create log file $log_filename. $!\n";
   my $return_lst;
   my $EndRead = 0;
   while ($EndRead== 0){
      my $line;
      if ($line = <VCSLOG>){
         chomp $line;
         if ($line =~ /^vlogan\s+-work.*/){
#            &printl("cmd : $line\n",$log, $VERBOSE);
            $line =~ s/vlogan(.+)/$1/;
            my $arg_lst;
            $arg_lst = split_vlogan_args($line);
            push(@{$return_lst}, @{$arg_lst});
#             my $arg;
#             foreach $arg ( @$arg_lst) {
#                &printl("ARG : $arg\n",$log, $VERBOSE);
#             }
         }
      }else{
         $EndRead = 1;
      }
   }
   close(VCSLOG);
   return $return_lst;
}

sub Read_VCS_vhdlan_log($){
my $log_filename= shift;

   open (VCSLOG, "<$log_filename") || die "Could not create log file $log_filename. $!\n";
   my $return_lst;
   my $EndRead = 0;
   while ($EndRead== 0){
      my $line;
      if ($line = <VCSLOG>){
         chomp $line;
         if ($line =~ /^vhdlan\s+-work.*/){
#            &printl("cmd : $line\n",$log, $VERBOSE);
            $line =~ s/vhdlan(.+)/$1/;
            my $arg_lst;
            $arg_lst = split_vlogan_args($line);
            push(@{$return_lst}, @{$arg_lst});
#             my $arg;
#             foreach $arg ( @$arg_lst) {
#                &printl("ARG : $arg\n",$log, $VERBOSE);
#             }
         }
      }else{
         $EndRead = 1;
      }
   }
   close(VCSLOG);
   return $return_lst;
}

my $ls_cmd = "ls -1 $ResultsDir/makefiles/makeLogs/*_ace_vlogan.pl*.log";
&printl("SEARCHING : $ls_cmd\n",$log, $VERBOSE);
my @log_list;
@log_list = `$ls_cmd`;
my $dp;
my $log_filename;
foreach $log_filename (@log_list){
   chomp $log_filename;
   my ($volume,$directories,$file);
   ($volume,$directories,$file) =File::Spec->splitpath( $log_filename );

   &printl("FOUND : $log_filename\n",$log, $VERBOSE);
#sip_shared_lib_S_xlnx_v7_lib_ace_vlogan.pl_2014_0506_1533.log
   my $lib_name = $file;
   my $time_stamp = $file;
   $lib_name =~ s/(.+)_ace_vlogan.pl(.*).log/$1/;
   $time_stamp =~ s/(.+)_ace_vlogan.pl(.*).log/$2/;
   my $arg_lst = Read_VCS_vlogan_log($log_filename);
   $dp->{$lib_name}{'timestamp'} = $time_stamp;
   $dp->{$lib_name}{'command_line'} = $arg_lst;
#    my $arg;
#    &printl("FOUND : $lib_name\n",$log, $VERBOSE);
# 
# 
#    &printl("FOUND : $time_stamp\n",$log, $VERBOSE);
#    foreach $arg ( @$arg_lst) {
#       &printl("ARG : $arg\n",$log, $VERBOSE);
#    }
}
$ls_cmd = "ls -1 $ResultsDir/makefiles/makeLogs/*_ace_vhdlan.pl*.log";
&printl("SEARCHING : $ls_cmd\n",$log, $VERBOSE);
@log_list = `$ls_cmd`;
foreach $log_filename (@log_list){
   chomp $log_filename;
   my ($volume,$directories,$file);
   ($volume,$directories,$file) =File::Spec->splitpath( $log_filename );

   &printl("FOUND : $log_filename\n",$log, $VERBOSE);
#sip_shared_lib_S_xlnx_v7_lib_ace_vlogan.pl_2014_0506_1533.log
   my $lib_name = $file;
   my $time_stamp = $file;
   $lib_name =~ s/(.+)_ace_vhdlan.pl(.*).log/$1/;
   $time_stamp =~ s/(.+)_ace_vhdlan.pl(.*).log/$2/;
   my $arg_lst = Read_VCS_vhdlan_log($log_filename);
   $dp->{$lib_name}{'timestamp'} = $time_stamp;
   $dp->{$lib_name}{'command_line'} = $arg_lst;
#    my $arg;
#    &printl("FOUND : $lib_name\n",$log, $VERBOSE);
# 
# 
#    &printl("FOUND : $time_stamp\n",$log, $VERBOSE);
#    foreach $arg ( @$arg_lst) {
#       &printl("ARG : $arg\n",$log, $VERBOSE);
#    }
}
dump_hash("reconfig", $dp, "test.pm");

#
#  printl :  print to log, opens/closes the log file for each access.
#
sub printl($$$) {
   my $msg = shift;
   my $log = shift;
   my $debug_level = shift;
   
   if ($debug_level<=$debug){
      open (LOG, ">>$log") || die "Could not open log file $log $msg. $!\n";
      print LOG "$msg";
      close LOG;
   }
   return;
}
# b 73 (($Hierarchy[0] eq 'psf_rtl_lib')&&($key eq '-vlog_incdirs'))
