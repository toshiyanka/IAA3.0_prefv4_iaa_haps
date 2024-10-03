#!/usr/intel/bin/perl5.26.1

package PinnedBranches;

use warnings;
use strict;

use Exporter;
our @ISA = 'Exporter';
our @EXPORT = qw($pinned_branches);

our $pinned_branches = [qw(lnl-a0 vte-test)];

1;
