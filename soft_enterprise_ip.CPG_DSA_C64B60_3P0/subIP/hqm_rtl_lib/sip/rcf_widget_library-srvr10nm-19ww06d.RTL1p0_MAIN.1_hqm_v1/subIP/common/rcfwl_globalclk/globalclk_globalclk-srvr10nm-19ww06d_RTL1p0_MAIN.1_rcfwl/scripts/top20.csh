#!/usr/intel/bin/perl

@top20 = (
    '1.2.a', 
    '1.10.a',
    '1.16.a',
    '7.99.a',
    '7.308.a',
    '12.55.a',
    '12.124.b',
    '12.275.b',
    '12.293.b',
    '13.306.a',
    '11.263.a',
    '15.9.a',
    '15.135.a',
    '19.191.a',
    '20.215.b',
    '20.231.a',
    '20.343.a',
    '21.243.a',
    '21.245.a',
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
