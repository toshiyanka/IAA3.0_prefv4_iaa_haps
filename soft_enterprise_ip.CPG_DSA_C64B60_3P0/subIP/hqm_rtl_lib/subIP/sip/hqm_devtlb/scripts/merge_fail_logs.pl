#!/usr/intel/bin/perl 

use strict;
use warnings;

my @files   = <*.out>;    # Get all the .out files
my @results = ();         # Store the results of the grep

foreach my $file ( @files ) {
    @results = map { "$file: $_" } `grep -Pi "error|OVM_FATAL|failed at" $file`;
    print @results if ( $#results >= 0 );
}

print "\n# merge_fail_logs.pl DONE\n";
