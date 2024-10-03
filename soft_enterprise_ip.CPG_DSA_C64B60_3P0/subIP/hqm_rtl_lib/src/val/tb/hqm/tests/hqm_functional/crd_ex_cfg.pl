################################################################################
## -- To generate crd_ex_cfg.cft
################################################################################

use strict;
use warnings;

my $num_vas       = 32;
my $num_ldb_ports = 64;
my $num_dir_ports = 64;
my $num_ldb_qids  = 32;
my $num_dir_qids  = 64;

my $out_file = "crd_ex_cfg.cft";
open(my $OUT, ">$out_file") or die "Cannot open $out_file;$!\n";

print $OUT "## -- Setup LUTs used by HCWs\n";
print $OUT "#mem_update ## -- initialize memories to hqm_cfg defaults using backdoor access\n";

print $OUT "cfg_begin\n";
print $OUT "   msix_alarm 0 enable=0x1 addr=0xaaa5555aaaa5555 data=0xaaaa5555\n";

print $OUT "\n   ## -- DIR QIDs\n";
for(my $qid=0 ; $qid < $num_dir_qids; $qid++) {
    print $OUT "   dir qid $qid\n";
}

print $OUT "\n   ## -- LDB QIDs\n";
for(my $qid=0 ; $qid < $num_ldb_qids; $qid++) {

    print $OUT "   ldb qid $qid";
    if ($qid % 4 == 2) {
        print $OUT " fid_cfg_v=1\n";
    } else {
        print $OUT "\n";
    }
}

print $OUT "\n   ## -- VAS configuration\n";
for(my $vas=0 ; $vas < $num_vas; $vas++) {
    
    my $ldb_qid;
    my $next_ldb_qid;

    $ldb_qid      = 2 * $vas;
    $next_ldb_qid = 2 * $vas + 1;
    print $OUT "   vas $vas credit_cnt=0x80 dir_qidv$ldb_qid=1 dir_qidv$next_ldb_qid=1 ldb_qidv$vas=1\n";
}

print $OUT "\n   ## -- DIR Ports configuration\n";
for(my $port=0 ; $port < $num_dir_ports; $port++) {

    my $vas = int($port/2);

    print $OUT "   dir pp $port vas=$vas\n";
    print $OUT "   dir cq $port gpa=sm cq_depth=128\n";
}

print $OUT "\n   ## -- LDB Ports configration\n";
for(my $port=0; $port < $num_ldb_ports; $port++) {

    my $qid = int($port/2);
    my $vas = int($port/2);

    print $OUT "   ldb pp $port vas=$vas\n";
    print $OUT "   ldb cq $port gpa=sm cq_depth=128 qidv0=1 qidix0=$qid\n";
}

print $OUT "\ncfg_end";
    
