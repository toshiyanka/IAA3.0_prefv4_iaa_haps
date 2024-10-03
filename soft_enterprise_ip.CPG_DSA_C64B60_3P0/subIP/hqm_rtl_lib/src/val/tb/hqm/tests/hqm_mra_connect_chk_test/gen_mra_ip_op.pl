#!/usr/bin/perl

use strict;
use warnings;
use Cwd;

my ($mra_spec_path, $mra_connect_op_path) = @ARGV;

if(not defined $mra_spec_path) {
  usage();
  die "MRA spec file path needed !!! \n\n";
}

if(not defined $mra_connect_op_path) {
  usage();
  die "MRA connect op path needed, to know where to create the connection output file !!! \n\n";
}

open(IP_FILE, $mra_spec_path); 

open(OP_FILE, ">$mra_connect_op_path/hqm_mra_ip_op_populated_array.svh") or die "Couldn't open file hqm_mra_ip_op_populated_array.svh";

while(<IP_FILE>) {
   my @split_args = split(' ',$_);

   $split_args[1] =~ s/\//\./g;
   if(@split_args == 2) {
      print OP_FILE "mra_ip_bit_q.push_back(\"hqm_tb_top.u_hqm.$split_args[0]\");\n";
      print OP_FILE "mra_op_bit_q.push_back(\"hqm_tb_top.u_hqm.$split_args[1]\");\n";
   }
   else {
      die "On splitting below line within file '$mra_spec_path' the number of variables is not 2. It is @split_args. \n$_"
   }
}

close(IP_FILE);
close(OP_FILE);

success();

sub usage{
   print "\n\n------------------------------------------------------------------------------------\n\n";
   print "Call this script to generate connectivity array queues path for hqm_mra_intf connectivity checks\n";
   print "gen_mra_ip_op.pl <hqm_mra_spec_path> <hqm_mra_connect_op_path>";
   print "\n\n------------------------------------------------------------------------------------\n\n";
}

sub success{
   print "\n\n------------------------------------------------------------------------------------\n\n";
   print "Success !!\n";
   print "Created file 'hqm_mra_ip_op_populated_array.svh' in $mra_connect_op_path/";
   print "\n\n------------------------------------------------------------------------------------\n\n";
}

