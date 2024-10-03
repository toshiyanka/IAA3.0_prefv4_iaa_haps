#!/usr/intel/bin/perl

@top20 = (
    '1.2.a', 
    '1.10.a',
    '2.309.a',
    '4.265',
    '7.99',
    '10.104.a',
    '12.124',
    '12.276.a',
    '12.293',
    '12.294.a',
    '15.9.a',
    '15.133',
    '18.300.a',
    '19.191',
    '20.196',
    '20.215',
    '20.343',
    '21.243.a',
    '21.245.a',
    '24.306',
    );

$num_rules = 0;
$pass = 0;

if ( $#ARGV > -1 ) {
    $filename = $ARGV[0];
} else {
    $filename = "SDGDFDAgentDebugLogic_results.dat";
}

open ( INFILE, "$filename" ) or die;
while ( <INFILE> ) {

    if ( /^(\d+\.\d+\.\w).*([PASFIL]{4}\s*[OVERIDN]*)$/ ) {
	$current_rule = $1;
	$current_status = $2;
	
	foreach $rule ( @top20 ) {
	    if ( $rule eq $current_rule ) {
		print;

		$num_rules++;

		if ( $current_status =~ "^PASS" ) {
		    $pass++;
		}
	    }
	}

    }
}
close ( INFILE );

print "\n$pass of $num_rules PASS\n";
