#!/usr/bin/perl

use strict;
use warnings;
use Cwd;

my ($mem_trim_spec_path, $mem_trim_connect_op_path) = @ARGV;

if(not defined $mem_trim_spec_path) {
  usage();
  die "Mem trim spec file path needed !!! \n\n";
}

if(not defined $mem_trim_connect_op_path) {
  usage();
  die "Mem trim connect op path needed, to know where to create the connection output file !!! \n\n";
}

open(IP_FILE, $mem_trim_spec_path); 

open(OP_FILE, ">$mem_trim_connect_op_path/hqm_mem_trim_fuse_ip_op_populated_array.svh") or die "Couldn't open file hqm_mem_trim_fuse_ip_op_populated_array.svh";

while(<IP_FILE>) {
   my @split_args = split(' ',$_);
   my $first_character = substr($_, 0, 1);
   if($first_character eq '#') {
      print "Not processing below line as it starts with comment '#': \n$_";
   }
   elsif(@split_args == 2) {
      $split_args[0] =~ s/\//\./g;
      $split_args[1] =~ s/\//\./g;
      print OP_FILE "mem_trim_fuse_ip_bit_q.push_back(\"hqm_tb_top.u_hqm/$split_args[0]\");\n";
      print OP_FILE "mem_trim_fuse_op_bit_q.push_back(\"hqm_tb_top.u_hqm.$split_args[1]\");\n";
   }
   else {
      die "On splitting below line within file '$mem_trim_spec_path' the number of variables is not 2. It is @split_args. \n$_"
   }
}

close(IP_FILE);
close(OP_FILE);

success();

sub usage{
   print "\n\n------------------------------------------------------------------------------------\n\n";
   print "Call this script to generate connectivity array queues path for hqm_mem_trim_intf connectivity checks\n";
   print "gen_mem_trim_ip_op.pl <hqm_mem_trim_spec_path> <hqm_mem_trim_connect_op_path>";
   print "\n\n------------------------------------------------------------------------------------\n\n";
}

sub success{
   print "\n\n------------------------------------------------------------------------------------\n\n";
   print "Success !!\n";
   print "Created file 'hqm_mem_trim_fuse_ip_op_populated_array.svh' in $mem_trim_connect_op_path/";
   print "\n\n------------------------------------------------------------------------------------\n\n";
}

