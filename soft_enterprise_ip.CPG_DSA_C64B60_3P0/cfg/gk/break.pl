#!/usr/intel/bin/perl

use strict;
use warnings;

my $about = <<EOMSG;
This is a way to compare before and after task lists generated from GkUtils.cfg

The problem with comparing monolithic text dumps is that when tasks are added
the gk-utils dumper might output existing tasks in a completely different order
than previously.  When this happens, diff/meld is useless for comparisons.

To get around the re-ordering problem, this script breaks each named task into
as separate file.  Since a task may be repeated for different events, the files
are nested under event directories.  Since we wish to compare before & after,
the event directories are further nested, under user-chosen names.

Example Usage Flow
    ./break.pl BEFORE < OUTPUT_FROM_GK_UTILS
    (edit GkUtils.cfg)
    ./break.pl AFTER  < OUTPUT_FROM_GK_UTILS
    meld BEFORE AFTER

The tasks will be found in the files named like:
    {BEFORE,AFTER}/{filter,integrate,release}/*
EOMSG

my @accumulator;
my $nonce = shift @ARGV || die;
my $task;
my $name;

sub start {
    @accumulator = ();
    $name = undef;
}

sub stop {
    die "Name not defined\nContext:\n@accumulator" unless $name;
    qx|mkdir -p $nonce/$task|;
    open FH, '>', "$nonce/$task/$name";
print FH <<EOMSG;
$task/$name

@accumulator
EOMSG
    close FH;
}

while(<>) {
    $task = $1 if m|==== (.*) ==== \(|;
    &start()   if m|<anon>|;
    push @accumulator, $_;
    &stop()    if m|</anon>|;
    $name = $1 if m|<NAME>(.*)</NAME>|;
}
