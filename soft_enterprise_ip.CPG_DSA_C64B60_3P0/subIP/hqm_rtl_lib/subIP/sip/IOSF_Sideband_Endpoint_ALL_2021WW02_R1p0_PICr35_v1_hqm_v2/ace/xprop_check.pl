#!/usr/intel/bin/perl -w
#use strict;
#use warnings;

# Check makefiles/vcs/makeLogs/IosfSbEpTestbench__ELAB_MODELS__vcs.log (for EP) if this is being run or not
my $xprop_file  = $ARGV[0];
my $xprop_scope = $ARGV[1];
my $scope;
my $error=0;

# split and uniquify -m2e arg since it may show up as:
#   <model>,<model>,<model> no idea why this happens but
#   it should be redundant same model
my @tmp = &uniq(split(',',$xprop_scope));
$xprop_scope = shift @tmp;

print "Executing ace/xprop_check.pl $xprop_file $xprop_scope\n";

if( !defined( $ENV{HDK_EXEC} ) )
{
    $xprop_file =~ s/$ENV{VCS_VER}//;
}

# Check for RTR or EP
if ( ( !defined ($ENV{ONECFG_scope})) && (!defined ($ENV{ACE_PROJECT})) )
{
    print "ONECFG_scope and ACE_PROJECT is not set\n";
    print "They should be either IOSF_SBC_EP or IOSF_SBC_RTR\n";
    $error = 1;
} elsif ( ($ENV{ONECFG_scope} eq "IOSF_SBC_EP") || ($ENV{ACE_PROJECT} eq "IOSF_SBC_EP") )
{
    $scope = $xprop_scope;
} elsif ( ($ENV{ONECFG_scope} eq "IOSF_SBC_RTR") || ($ENV{ACE_PROJECT} eq "IOSF_SBC_RTR") )
{
    $scope = $xprop_scope;
}

# Append model name to get final xprop file name
$xprop_file .= "$scope/xprop.log";
printf( "XPROP TARGET: %s\n", $xprop_file );

open ($fh, "<", $xprop_file) or die "Couldnt open xprop.log file";

while ($line = <$fh>) {
	chomp $line;
## match string for xprop violation
## Check for the "NO" error word in the xprop.log file only for the "source/rtl" files. For RTR, xprop is checked for all TB files in which xprop checks dont make sense.
## These are the waived ones - there should be a HSD for each of these     
	if ($line =~ m/sbcclkgaterst.*commaassign/) { #HSD: 1408257549 (pds ticket)
        next;
    }
	elsif ($line =~ m/source\/rtl(.*)NO/) {
        print "XPROP Failure!!\n";
        print "Error '$line' found in $xprop_file Fix it!!\n";
        $error = 1;
    }

}
close $fh;
if ($error) {
    exit 99;
}
else {
    exit 0;
}

sub uniq (@) {
    my %seen = ();
    grep { not $seen{$_}++ } @_;
}	
