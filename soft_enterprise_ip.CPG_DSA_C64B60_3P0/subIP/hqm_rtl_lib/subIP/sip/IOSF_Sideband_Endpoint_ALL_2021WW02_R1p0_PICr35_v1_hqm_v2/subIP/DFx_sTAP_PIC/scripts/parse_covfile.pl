#!/usr/intel/bin/perl

# Parse VCS Coverage file
#-----------------------------------------------------------------
# Intel Proprietary -- Copyright 2016 Intel -- All rights reserved
#-----------------------------------------------------------------
# Author       : Nilesh Panchal
# Date Created : 12/04/2007
#-----------------------------------------------------------------
# Description:
# This script parses text format VCS coverage report file and report percentage coverage
# based on number of bins got hit
#-----------------------------------------------------------------
eval 'exec /usr/intel/bin/perl -S $0 ${1+"$@"}'
    if 0;              # Not running under some shell
use strict;            # Try to be a good Perl programmer
#use diagnostics;       # Discuss errors in detail
use English;           # Avoid cryptic Perl variables
use File::Basename;    # Use the file name parser
use Getopt::Long;      # Manage cmd line arguments.
$OUTPUT_AUTOFLUSH = 1; # Force writes
my $this_script   =    basename ($PROGRAM_NAME, "\.pl");
# =====================================================================
# SUBROUTINE NAME:  PrintHelp
# IO_LIST:          none
# DESCRIPTION:      prints the help splash screen for the script
# =====================================================================
sub PrintHelp {
    $this_script = basename ($PROGRAM_NAME);
    print <<EOM;
Usage:  $this_script <options>
    options
    -d[ir] coverage dir        : Directory where Coverage report files are stored
    -h[elp]                    : Display this message.

Description: Parses grpinfo.txt file(text format of coverage report) and reports total number of bins, bins hit, coverage for each covergroup, also reports average coverage numbers

EOM
} #end PrintHelp()
# -------------------------------------------------------------------
# Prototype subroutines -- they are at the end.
# -------------------------------------------------------------------
sub PrintDebug ($);
sub Printreport;
sub PrintReportHash;

# =====================================================================
# SUBROUTINE NAME:  PrintDebug
# IO_LIST:          input a string to print
# DESCRIPTION:      prints a string with DEBUG: prefix
# =====================================================================
sub PrintDebug ($) {
  print "DEBUG: $_[0]";
} # end PrintDebug

# -------------------------------------------------------------------
# Get options from the command line -- use GetOptions package.
# -------------------------------------------------------------------
# main(); -- This is where the script begins doing something.
my $optHelp;
my $optDir;
my $dbg = 0;
&PrintDebug ("1: \$#ARGV=$#ARGV \@ARGV=@ARGV\n") if ($dbg);
my $ok = &GetOptions (
    "dir=s"    => \$optDir,
    "help"      => \$optHelp );

# Print usage help and exit if -h or if GetOptions has a problem
if ($optHelp || !$ok) {
    PrintHelp(); exit 1;
}
# -------------------------------------------------------------------
# Get file_list from command line
# -------------------------------------------------------------------
if(!defined $optDir ) {
    &PrintHelp(); exit 1;
}

my $grpinfo_file;
my $cmd;
my $idx = 0;
my @cov_lines = ();
my @total_bins_l = ();
my @covered_bins_l = ();
my @cov_groups = ();
my $total_bins = 0;
my $covered_bins = 0;
my $got_bins = 0;
my $got_grp;
my %covhash = ();
my $covgroup;
my @bins_l;

$grpinfo_file = "$optDir"."/"."grpinfo.txt";
&PrintDebug ("2: grp info file = $grpinfo_file\n") if ($dbg);


if(! -e $grpinfo_file) {
    print "File $grpinfo_file not found"; exit 1;
}
$cmd = "egrep \"Variables|Crosses|Summary for Group\" $grpinfo_file | grep -v \"Crosses for Group\" | grep -v \"Variables for Group\"";
@cov_lines = `$cmd`;
&PrintDebug ("3: grep result  = @cov_lines\n") if ($dbg);
$idx = 0;
while( $idx <= $#cov_lines) {
    #$got_grp = 0;
    &PrintDebug ("3A: Parsing $idx line : $cov_lines[$idx] \n") if ($dbg);
    if($cov_lines[$idx] =~ /Summary\s+for\s+Group\s+(.*)/i) {
        #push (@cov_groups, $1);
        $got_grp = 1;
        $idx++;
        $covgroup = $1;
    }
    if( $got_grp && $cov_lines[$idx] =~ /.*Variables\s+(\d+)\s+(\d+)\s+(\d+)/i ) { #get variables bins
        $total_bins = $total_bins + $1;
        $covered_bins = $covered_bins + $3;
        $got_bins = 1;
        $idx++;
    }
    if($got_grp && $cov_lines[$idx] =~ /.*Crosses\s+(\d+)\s+(\d+)\s+(\d+)/i ) { #get crosses if any bins
        $total_bins = $total_bins + $1;
        $covered_bins = $covered_bins + $3;
        $got_bins = 1;
        $idx++;
    }
    if($got_bins && $got_grp) {
            #push (@cov_groups, $covgroup);
            #push (@total_bins_l, $total_bins);
            #push (@covered_bins_l, $covered_bins);

            @bins_l = ();
            push (@bins_l, $total_bins);
            push (@bins_l, $covered_bins);
            $covhash{$covgroup} = [@bins_l];
            $total_bins = 0; $covered_bins = 0; $got_bins = 0;$got_grp = 0;
      }
}

&PrintDebug ("4: Groups Array  = @cov_groups\n") if ($dbg);
&PrintDebug ("5: Bins Total Array  = @total_bins_l\n") if ($dbg);
&PrintDebug ("5: Bins Covered Array  = @covered_bins_l\n") if ($dbg);

&PrintReportHash;

sub PrintReport {
    my $space = "                                                               ";
    my $line  = "---------------------------------------------------------------------------------------";
    my $total_cov = "+++ Total Coverage =  ";
    my $idx1;
    my $final_bins = 0;
    my $final_bins_hit = 0;
    my $final_cov;
    my $total_grps = 0;

    print "\n";
    print " CoverGroup Name                                                          Total Bins   Bins Covered  % Coverage\n";
    print " ---------------                                                          ----------   ------------  ---------\n";
    #print substr ($space, 0, 34), "CoverGroup Name      Total Bins  % Coverage\n";

    for($idx1=0; $idx1 <= $#cov_groups; $idx1++) {
        my $per_str = sprintf( "%.2f", ($covered_bins_l[$idx1] /  $total_bins_l[$idx1]) * 100);
        my $grpname   = substr ($cov_groups[$idx1], 0, 75);
        my $bin_str   = substr ($total_bins_l[$idx1], 0, 4);
        my $bin_cov_str   = substr ($covered_bins_l[$idx1], 0, 4);
        printf " %-75s  %-10s  %-5s  %10s\n", $grpname, $bin_str, $bin_cov_str, $per_str;
        $final_bins = $final_bins + $total_bins_l[$idx1];
        $final_bins_hit = $final_bins_hit + $covered_bins_l[$idx1];
        $total_grps++;
    }

    #print final numbers
    my $per_avg = sprintf( "%.2f", ($final_bins_hit /  $final_bins) * 100);
    print "\n";
    print " -----------------------------------------------------------             ----------   ------------  ---------\n";
    printf " %0s %-65s  %-10s  %-5s  %10s\n", "Total ->  " ,$total_grps, $final_bins, $final_bins_hit,$per_avg;
}

sub PrintReportHash {
    my $space = "                                                               ";
    my $line  = "---------------------------------------------------------------------------------------";
    my $total_cov = "+++ Total Coverage =  ";
    my $idx1;
    my $final_bins = 0;
    my $final_bins_hit = 0;
    my $final_cov;
    my $total_grps = 0;
    my $grp_name;

    print "\n\n";
    print "--------------------------------------------------------------------------------------------------------\n";
    print "                         C O V E R A G E         R E P O R T\n";
    print "--------------------------------------------------------------------------------------------------------\n\n";
    print " CoverGroup Name                                                          Total Bins   Bins Covered  % Coverage\n";
    print " ---------------                                                          ----------   ------------  ---------\n";
    for $grp_name ( sort (keys (%covhash)) ) {
        print "$grp_name : $covhash{$grp_name}[0] ,, $covhash{$grp_name}[1] \n" if $dbg;
        my $per_str = sprintf( "%.2f", ($covhash{$grp_name}[1] /  $covhash{$grp_name}[0]) * 100);
        my $grpname   = substr ($grp_name, 0, 75);
        my $bin_str   = substr ($covhash{$grp_name}[0], 0, 4);
        my $bin_cov_str   = substr ($covhash{$grp_name}[1], 0, 4);
        printf " %-75s  %-10s  %-5s  %10s\n", $grpname, $bin_str, $bin_cov_str, $per_str;
        $final_bins = $final_bins + $covhash{$grp_name}[0];
        $final_bins_hit = $final_bins_hit + $covhash{$grp_name}[1];
        $total_grps++;
    }

    #print final numbers
    my $per_avg = sprintf( "%.2f", ($final_bins_hit /  $final_bins) * 100);
    print "\n";
    print " -----------------------------------------------------------             ----------   ------------  ---------\n";
    printf " %0s %-65s  %-10s  %-5s  %10s\n", "Total ->  " ,$total_grps, $final_bins, $final_bins_hit,$per_avg;
}

exit 0;

