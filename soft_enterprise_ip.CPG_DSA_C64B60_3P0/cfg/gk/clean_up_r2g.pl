#!/usr/intel/bin/perl

use strict;
use warnings;

use Cwd;
use File::Basename;
use Getopt::Long;

my $default = {
    act     => 0,
    du      => 1,
    days    => 21,
    glob    => '/nfs/site/disks/cct_link_00001/release/dsa-eip/*/output/R2G'
};
my $opt  = $default;
my $self = basename($0);
my $help = <<EOMSG;
$self

Purpose
  To clean up large files from releases that are not needed to support regressions

Arguments

 -days NUMBER
    Only remove paths older than this value.
    Days can be decimal, eg 5.3
    default: $default->{days}
 -glob PATH_WITH_WILDCARD
    default: $default->{glob}
 -[no]du
    Run `du` on each candidate and print the result.
    This is slowish and unnecessary, but it's not noticed when run as part of
    a release, and it's nice to have the results in the log files afterwards.
 -[no]act
    The script will not clean old files without this flag specified

Background

  Historically we've kept all (or most) simv's that might be needed to debug
  open failures.  Doing so shortens debug time since the debugger need not
  recompile.  The cost to do so is low, as they take little space.
  Unfortunately the presence of R2G flows complicates things as its output
  is more than 7 times the size, and only needed briefly.
EOMSG

sub opt {
    &GetOptions(
       "help"   => sub { print $help; exit; },
       "days=s" => \$opt->{days},
       "glob=s" => \$opt->{glob},
        "act!"  => \$opt->{act},
         "du!"  => \$opt->{du},
    );
}

sub override {
    my $override = '/nfs/site/disks/home_user/gkcct/override/clean_up_r2g.dsa.pm';
    if (-e $override) {
        print "Override file found at: $override\n";
        our $days;
        our $act;
        eval {
            do $override;
        };

        if (defined $act) {
            print "Using override value for 'act' with value $act\n";
            $opt->{act} = $act
        } else {
            print "No override found for 'act'\n";
        }

        if (defined $days) {
            print "Using override value of $days for number of days to keep\n";
            $opt->{days} = $days
        } else {
            print "No override found for 'days'\n";
        }

    } else {
        print "No override file found at: $override\n";
    }
}

sub main {
    &opt();
    &override();
    foreach my $path (glob $opt->{glob}) {
        print qx|du -sh $path| if $opt->{du};
        next if -M $path < $opt->{days};
        my $dir = dirname($path);
        if ($opt->{act}) {
            print "Doing...\n";
        } else {
            print "Would do (if 'act' were enabled)\n";
        }
        foreach my $cmd (
            qq|chmod    u+w $dir|,
            qq|chmod -R u+w $path|,
            qq|rm -rf $path|,
            qq|chmod    u-w $dir|,
        ){
            print "\t$cmd\n";
            qx|$cmd| if $opt->{act};
        }
    }
}

&main();
