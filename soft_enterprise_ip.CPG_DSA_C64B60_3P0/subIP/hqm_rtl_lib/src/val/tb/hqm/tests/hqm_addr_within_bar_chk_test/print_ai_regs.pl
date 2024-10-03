#!/usr/bin/perl -w
use strict;
use warnings;

my $num_cq = 63;
my $in_file = sprintf("hqm_ai_reglist_full");
open (FILE,">$in_file");

foreach my $idx (0..$num_cq)   { 
    print FILE "chk_in_bar hqm_system_csr.LDB_CQ_ISR[$idx]\n"; 
    print FILE "chk_in_bar hqm_system_csr.LDB_CQ_ISR[$idx]\n"; 
    print FILE "chk_in_bar hqm_system_csr.LDB_CQ_ISR[$idx]\n"; 
    print FILE "chk_in_bar hqm_system_csr.LDB_CQ_ISR[$idx]\n"; 
}

# foreach my $idx (0..$num_vdev) { print FILE "hqm_system_csr.LDB_CQ_ISR[$idx]"; }

close (FILE) or die "Not able to close the file: $in_file \n\n";
