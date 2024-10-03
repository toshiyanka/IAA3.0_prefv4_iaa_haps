#!/usr/intel/bin/perl

use strict;
use warnings;
use Getopt::Long qw(:config auto_help);
use Pod::Usage;
use Cwd "abs_path";



#-------------------------------------------------------------------------------
# Get command line options.
#-------------------------------------------------------------------------------

my $config   = "";
my $src_rtl  = "";
my $dst_rtl  = "";

GetOptions (
            'config=s'              => \$config,
            'src_rtl=s'             => \$src_rtl,
            'dst_rtl=s'             => \$dst_rtl,
            ) or pod2usage(-verbose => 1);


#-------------------------------------------------------------------------------
# Check for valid command line options.
#-------------------------------------------------------------------------------

if ($config eq "") {
   print "setRTLparams -E- Configuration required\n";
   exit(-1);
}

if ($src_rtl eq "") {
   print "setRTLparams -E- Source RTL file required\n";
   exit(-1);
}

if ($dst_rtl eq "") {
   print "setRTLparams -E- Destination RTL file required\n";
   exit(-1);
}


unless (-e $src_rtl) {
   print "setRTLparams -E- Source RTL file ($src_rtl) not found\n";
   exit(-1);
}


unless (-e $config) {
   print "setRTLparams -E- Configuation file ($config) not found\n";
   exit(-1);
}



#-------------------------------------------------------------------------------
# Read the CSV and remember the parameters.
#-------------------------------------------------------------------------------
open (CSV, "$config") or die "setRTLparams -E- cannot open $config -- $!\n";


my %param_hash;
while (my $line = <CSV>) {

   if ($line =~/^PARAM,([\w_]+),(\w+)\s*$/) {
      $param_hash{$1} = $2;
   }
}

close CSV;


#-------------------------------------------------------------------------------
# Open the source RTL and the destination RTL file.
#-------------------------------------------------------------------------------
open (IN,  "$src_rtl")  or die "setRTLparams -E- cannot open input RTL $src_rtl -- $!\n";
open (OUT, ">$dst_rtl") or die "setRTLparams -E- cannot open output RTL $dst_rtl -- $!\n";



while (my $line = <IN>) {

   my $parameter_updated = 0;
   foreach my $param (keys %param_hash) {
      if ($line =~ /(\s*parameter\s+$param+\s+=\s*)\w+([\s,]+.*)/) {
         print OUT "$1$param_hash{$param}$2\n";
         $parameter_updated = 1;
      } 
   }
   if ($parameter_updated == 0) {
      print OUT "$line";
   }

}

close (IN);
close (OUT);



