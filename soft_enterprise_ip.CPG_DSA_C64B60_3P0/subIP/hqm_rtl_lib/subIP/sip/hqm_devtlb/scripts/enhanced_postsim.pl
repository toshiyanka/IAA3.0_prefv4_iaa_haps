#!/usr/intel/bin/perl -w
# ------------------------------------------------------------------------------
#
#  enhanced_postsim.pl
#
#  Adds more info to the ACE postsim.log file
#     * Environment Name
#     * Environment Type
#     * Seed (in HEX)
#     * Simulation Time
#     * Run Model
#     * Library size of model
#     * Is model a released model?
#
# ------------------------------------------------------------------------------

use strict;

use File::Basename;
use Getopt::Long;
use Cwd 'abs_path';

# ------------------------------------------------------------------------------
# Declare variables
# ------------------------------------------------------------------------------
my $postsim       = "postsim.log";
my $postsimTemp   = "postsim.log.temp";
my @dfxTestCategories = qw(
    bscan
    dfx
    fuse
    hip
    hvm
    idv
    j2sb
    jtag
    lkmr
    mbist
    pdp
    pins
    pll
    pwrm
    scan
    secur
    tam
    visa
);
my @regularTestCategories = qw(
    addr
    boot
    cfg
    clock
    coh
    dec
    err
    lnk
    perf
    phy
    pm
    reset
    sec
    txn
),

# Required arguments
my $acemodel    = undef;
my $envtype     = undef;
my $hsdenv      = undef;
my $hsdproject  = undef;
my $hsdsku      = undef;
my $project     = undef;
my $relpath     = undef;
my $testname    = undef;
my $hsddsn      = undef;

# Optional arguments
my $debug       = undef;
my $envname     = undef;
my $resultspath = undef;
my $runmodel    = undef;
my $run_mode    = "UNKNOWN";
my $testseed    = undef;

GetOptions(
    'acemodel=s'    => \$acemodel,
    'envname=s'     => \$envname,
    'envtype=s'     => \$envtype,
    'hsddsn=s'      => \$hsddsn,
    'hsdenv=s'      => \$hsdenv,
    'hsdproject=s'  => \$hsdproject,
    'hsdsku=s'      => \$hsdsku,
    'project=s'     => \$project,
    'relpath=s'     => \$relpath,
    'resultspath=s' => \$resultspath,
    'runmodel=s'    => \$runmodel,
    'run_mode=s'    => \$run_mode,
    'testname=s'    => \$testname,
    'testseed=s'    => \$testseed,
    'debug'         => \$debug,
);

if ($debug) {
    print("Dumping all passed in arguments:\n");
    print("  ACE model             : $acemodel\n")    if (defined $acemodel);
    print("  Env name              : $envname\n")     if (defined $envname);
    print("  Env type              : $envtype\n")     if (defined $envtype);
    print("  HSD DSN               : $hsddsn\n")      if (defined $hsddsn);
    print("  HSD environment       : $hsdenv\n")      if (defined $hsdenv);
    print("  HSD project           : $hsdproject\n")  if (defined $hsdproject);
    print("  HSD sku               : $hsdsku\n")      if (defined $hsdsku);
    print("  Project/UNIX group    : $project\n")     if (defined $project);
    print("  Release path          : $relpath\n")     if (defined $relpath);
    print("  Results path          : $resultspath\n") if (defined $resultspath);
    print("  Simulation model path : $runmodel\n")    if (defined $runmodel);
    print("  Simulation run mode   : $run_mode\n")    if (defined $run_mode);
    print("  Test name             : $testname\n")    if (defined $testname);
    print("  Test seed             : $testseed\n")    if (defined $testseed);
}

# ------------------------------------------------------------------------------
# Error checks
# ------------------------------------------------------------------------------
if (!defined $acemodel) {
    die("Error: The ACE model name (-acemodel) is not specified.\n");
}
if (!defined $envtype) {
    die("Error: The environment type (-envtype) is not specified.\n");
}
if (!defined $hsddsn) {
    die("Error: The HSD DSN (-hsddsn) is not specified.\n");
}
if (!defined $hsdenv) {
    die("Error: The HSD environment name (-hsdenv) is not specified.\n");
}
if (!defined $hsdproject and !defined $hsdsku) {
    die("Error: The HSD project name (-hsdproject) and HSD sku name (-hsdsku) is not specified.\n");
}
if (defined $hsdproject and defined $hsdsku) {
    die("Error: The HSD project name (-hsdproject) and HSD sku name (-hsdsku) cannot both be specified.\n");
}
if (!defined $project) {
    die("Error: The project name (-project) is not specified.\n");
}
if (!defined $relpath) {
    die("Error: The release path (-relpath) is not specified.\n");
}
# Unfortunately, this check can't be used for now because of the way we pass in
#   the release path for environments that use symbolic links in their release
#   area.
#elsif (!(-d $relpath)) {
#    die("Error: The release path specified ($relpath) does not exist.\n");
#}
if (defined $resultspath and !(-d $resultspath)) {
    die("Error: The specified results path ($resultspath) does not exist.\n");
}
if (!defined $testname) {
    die("Error: The test name (-testname) is not specified.\n");
}

# ------------------------------------------------------------------------------
# Setup - since not all environments use ACE_PROJECT_HOME, we allow those to
#   specify the path to the build manually from the command line. It is also
#   possible that the ACE_PROJECT variable may not correctly reflect the
#   environment name so that can be specified on the command line as well.
# ------------------------------------------------------------------------------
if (!defined $envname) {
    $envname = $ENV{ACE_PROJECT};
}
if (!defined $resultspath) {
    $resultspath = "$ENV{ACE_PROJECT_HOME}/results"
}
my $logicalrunmodelpath;
if (!defined $runmodel) {
    chomp($logicalrunmodelpath = $ENV{ACE_PROJECT_HOME});
} else {
    chomp($logicalrunmodelpath = $runmodel);
}

if (-e "$ENV{ACE_PROJECT_HOME}/results/real_path_for_cama") {
    $logicalrunmodelpath = abs_path("$ENV{ACE_PROJECT_HOME}/results/real_path_for_cama");
    chomp($logicalrunmodelpath = $logicalrunmodelpath);
}
chomp(my $physicalrunmodelpath = `/usr/intel/bin/realpath $logicalrunmodelpath`);

# ------------------------------------------------------------------------------
# Finding the simulation time from <testname>.log. Extra logic is to make sure
#   we use the most recent <testname>.log file if there are multiples like
#   <testname>.remote.log
# ------------------------------------------------------------------------------
my $testtime = `ls -1tr jestr.log | xargs grep -h "^Time: " | tail -1 | perl -ne '/Time: (.+)/ && print \$1'`;

# ------------------------------------------------------------------------------
# Finding the seed value from <testname>.log. Extra logic is to make sure we use
#   the most recent <testname>.log file if there are multiples like
#   <testname>.remote.log
# This is only run if the testseed isn't passed in on the command line
# ------------------------------------------------------------------------------
if (!defined $testseed) {
    $testseed = `ls -1tr $testname*.log | xargs grep -h "ntb_random_seed" | tail -1 | perl -ne '/ntb_random_seed=(\\d+)/ && print \$1'`;
    $testseed = uc(sprintf("%u", $testseed));
}

# ------------------------------------------------------------------------------
# Determining the disk usage footprint from vcs_lib
# ------------------------------------------------------------------------------
chomp(my $diskusage = `du -sm $resultspath | awk '{print \$1}'`);

# ------------------------------------------------------------------------------
# Determining if the model is an official release by checking if our current
#   path is matched to a physical or logical path to the release area.
# ------------------------------------------------------------------------------
my $releasedmodel = 0;

      my $logicalReleasePath  = $relpath;
chomp(my $physicalReleasePath = `/usr/intel/bin/realpath $relpath`);

if ((-e $physicalReleasePath) && ($physicalrunmodelpath =~ /^$physicalReleasePath/)) {
    $releasedmodel = 1;
}

if (($logicalrunmodelpath =~ /^$logicalReleasePath/)) {
    $releasedmodel = 1;
}

# ------------------------------------------------------------------------------
# Determining test environment type - I'd like to remove this logic as it
#   doesn't make sense to me why a KLV test can't be a DFX test based on this
#   structure. KLV vs CLV should be a different field to the test category.
# For VTE environments, the test category is typically the midddle field in the
#   test name so we extract that and compare it against the hardcoded list.
# ------------------------------------------------------------------------------
my @testcategory = split(/_/, $testname);
if ($envtype eq "CLV") {
    $envtype = "Other";
    if (grep /$testcategory[1]/, @dfxTestCategories) {
        $envtype = "DFX";
    } elsif (grep /$testcategory[1]/, @regularTestCategories) {
        $envtype = "CLV";
    }
}

my $dfxtest = 0;
if (grep /$testcategory[1]/, @dfxTestCategories) {
    $dfxtest = "1";
}
if (!grep /$testcategory[1]/, @regularTestCategories) {
    $testcategory[1] = "Other";
}

# ------------------------------------------------------------------------------
# Appending data to postsim.log
# ------------------------------------------------------------------------------
chomp(my $cpuinfocpufamily = `/bin/cat /proc/cpuinfo | grep family               | tail -1      | awk '{print \$4}'`);
chomp(my $cpuinfomodel     = `/bin/cat /proc/cpuinfo | grep model | grep -v name | tail -1      | awk '{print \$3}'`);
chomp(my $cpuinfomodelname = `/bin/cat /proc/cpuinfo | grep "model name"         | tail -1      | perl -ne '/model name.+: (.+)/ && print \$1'`);
chomp(my $cpuinfostepping  = `/bin/cat /proc/cpuinfo | grep stepping             | tail -1      | awk '{print \$3}'`);
chomp(my $cpuinfocpumhz    = `/bin/cat /proc/cpuinfo | grep "cpu MHz"            | tail -1      | awk '{print \$4}'`);
chomp(my $cpuinfocachesize = `/bin/cat /proc/cpuinfo | grep "cache size"         | tail -1      | perl -ne '/cache size.+: (.+)/ && print \$1'`);
chomp(my $cpuinfosiblings  = `/bin/cat /proc/cpuinfo | grep "siblings"           | tail -1      | awk '{print \$3}'`);
chomp(my $cpuinfocores     = `/bin/cat /proc/cpuinfo | grep cores                | tail -1      | awk '{print \$4}'`);
chomp(my $meminfomemtotal  = `/bin/cat /proc/meminfo | grep MemTotal             | tail -1      | perl -ne '/MemTotal:\\s+(.+)/ && print \$1'`);

my $sectionFlag = 0;

print("Updating $postsim with derived data fields...\n");

open(INFILE, "$postsim")       or die("Error: Can't open $postsim.\n");
open(OUTFILE,"> $postsimTemp") or die("Error: Can't open $postsimTemp for writing.\n");

while (<INFILE>) {
     if (/\[Test Summary\]/) {
       $sectionFlag =1;
     }
     # if we've arrived at the point in the file where we should print our new stuff:
     if ($sectionFlag && /======================/) {
        #print our new sections
        print OUTFILE " -NEW SECTION datafields added by " . basename($0) . "-\n";
        print OUTFILE "  cpuinfo model name    : $cpuinfomodelname\n";
        print OUTFILE "  cpuinfo cpu MHz       : $cpuinfocpumhz\n";
        print OUTFILE "  cpuinfo cache size    : $cpuinfocachesize\n";
        print OUTFILE "  cpuinfo cores         : $cpuinfocores\n";
        print OUTFILE "  cpuinfo siblings      : $cpuinfosiblings\n";
        print OUTFILE "  cpuinfo cpu family    : $cpuinfocpufamily\n";
        print OUTFILE "  cpuinfo model         : $cpuinfomodel\n";
        print OUTFILE "  cpuinfo stepping      : $cpuinfostepping\n";
        print OUTFILE "  meminfo MemTotal      : $meminfomemtotal\n";
        print OUTFILE "  Seed Radix            : decimal\n";
        print OUTFILE "  Master Seed           : $testseed\n";
        print OUTFILE "  Simulation Time       : $testtime\n";
        print OUTFILE "  Run Model             : $logicalrunmodelpath\n";
        if ( exists $ENV{VCS_VER} ) {
            print OUTFILE "  VCS VER               : $ENV{VCS_VER}\n";
        } elsif ( exists $ENV{VCSMX_VER} ) {
            print OUTFILE "  VCS VER               : $ENV{VCSMX_VER}\n";
        } elsif ( exists $ENV{VCS_VERSION} ) {
            print OUTFILE "  VCS VER               : $ENV{VCS_VERSION}\n";
        } else {
            print OUTFILE "  VCS VER               : unknown\n";
        }
        print OUTFILE "  VCS LIB Disk Usage(MB): $diskusage\n";
        print OUTFILE "  Ran on Released Model : $releasedmodel\n";
        print OUTFILE "  Env name              : $envname\n";
        print OUTFILE "  Env type              : $envtype\n";
        print OUTFILE "  Project/UNIX group    : $project\n";
        print OUTFILE "  ACE Model             : $acemodel\n";
        print OUTFILE "  run mode              : $run_mode\n";
        print OUTFILE "  HSD DSN               : $hsddsn\n";
        print OUTFILE "  HSD environment       : $hsdenv\n";
        print OUTFILE "  HSD project           : $hsdproject\n" if (defined $hsdproject);
        print OUTFILE "  HSD sku               : $hsdsku\n"     if (defined $hsdsku);
        print OUTFILE "  Test category         : $testcategory[1]\n";
        print OUTFILE "  DFX test              : $dfxtest\n";
        $sectionFlag = 0;
     }
     print OUTFILE $_;
}

close INFILE;
close OUTFILE;

if (system("mv -f $postsimTemp $postsim")) {
    die("Error: Failed to update $postsim: $?\n");
}
