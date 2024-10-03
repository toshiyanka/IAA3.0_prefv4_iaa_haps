#!/usr/bin/perl
use strict;
use warnings;
use XML::Simple;
use Data::Dumper;

## This script is required by gen_hqm_regs to generate the Hash of cfg targets used in FPGAs

my $xml = $ARGV[0];
my $test_data = XMLin($xml, keyattr => { regfile => 'regfilename', reg => 'regname' },
                            forcearray => 1);
print Dumper($test_data);
#my $data = eval(Dumper($test_data));
#my $q = Dumper($test_data);
#$q =~ s{\A\$VAR\d+\s*=\s*}{};
#my $w = eval $q;
#print "$test_data->{pubdate} \n";
#print "$w->{pubdate} \n";
