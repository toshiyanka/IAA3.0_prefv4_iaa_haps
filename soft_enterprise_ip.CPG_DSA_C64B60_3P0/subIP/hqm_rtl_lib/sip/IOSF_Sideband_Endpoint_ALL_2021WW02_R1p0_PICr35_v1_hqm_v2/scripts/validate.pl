#!/usr/intel/bin/perl -w
#
# Author: Mick Ortwein
# Intel Corporation
# 08/18/2011
#

use strict;
use warnings;
use SIP::SBN::API;

my $API = new SIP::SBN::API($ARGV[0]);

#$API->readParams();

$API->validate();

# The rest of your API calls start here.

exit(0);
