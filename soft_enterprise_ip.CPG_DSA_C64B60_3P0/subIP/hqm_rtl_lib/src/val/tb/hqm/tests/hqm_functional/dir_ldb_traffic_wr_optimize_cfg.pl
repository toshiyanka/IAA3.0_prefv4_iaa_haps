#!/user/perl

use strict;
use warnings;

my $wr_file = "dir_ldb_traffic_wr_optimize_cfg.cft";
open(my $OUT, ">$wr_file") or die "Cannot open $wr_file for writing;$!\n";

print $OUT "#mem_update\n";
print $OUT "\ncfg_begin\n";
for (my $i=0; $i < 21; $i+=4) {

    my $it_inc = ($i / 4);

    printf $OUT "\n";
    printf $OUT "   ldb qid %0d\n", ( $i + $it_inc);
    printf $OUT "   ldb qid %0d \n" , ($i + 1 + $it_inc); 
    printf $OUT "   ldb qid %0d \n" , ($i + 2 + $it_inc); 
    printf $OUT "   ldb qid %0d \n" , ($i + 3 + $it_inc); 
    printf $OUT "\n";
    printf $OUT "   dir qid %0d \n",  ($i + 4 + $it_inc);
    printf $OUT "\n";
    printf $OUT "   vas VAS%0d:* credit_cnt=100 ldb_qidv%0d=1 ldb_qidv%0d=1 ldb_qidv%0d=1 ldb_qidv%0d=1 dir_qidv%0d=1\n", ($i / 4), ($i + $it_inc), ($i + 1 + $it_inc), ($i + 2 + $it_inc), ($i + 3 + $it_inc), ($i + 4 + $it_inc);
    printf $OUT "\n";
    printf $OUT "   ldb pp %0d vas=VAS%0d\n", ($i + $it_inc), ($i/4);
    printf $OUT "   ldb cq %0d gpa=sm qidv0=1 qidix0=%0d\n", ($i + $it_inc), ($i + $it_inc);
    printf $OUT "   ldb pp %0d vas=VAS%0d\n", ( $i + 1 + $it_inc), ($i/4);
    printf $OUT "   ldb cq %0d gpa=sm qidv0=1 qidix0=%0d\n", ($i + 1 + $it_inc), ($i + 1 + $it_inc);
    printf $OUT "   ldb pp %0d vas=VAS%0d\n", ( $i + 2 + $it_inc), ($i/4);
    printf $OUT "   ldb cq %0d gpa=sm qidv0=1 qidix0=%0d\n", ($i + 2 + $it_inc), ($i + 2 + $it_inc);
    printf $OUT "   ldb pp %0d vas=VAS%0d\n", ( $i + 3 + $it_inc), ($i/4);
    printf $OUT "   ldb cq %0d gpa=sm qidv0=1 qidix0=%0d\n", ($i + 3 + $it_inc), ($i + 3 + $it_inc);
    printf $OUT "\n";
    printf $OUT "   dir pp %0d vas=VAS%0d\n", ($i + $it_inc), ($i/4);
    printf $OUT "   dir cq %0d gpa=sm\n", ( $i + $it_inc);
    printf $OUT "   dir pp %0d vas=VAS%0d\n", ($i + 1 + $it_inc), ($i/4);
    printf $OUT "   dir cq %0d gpa=sm\n", ($i + 1 +$it_inc);
    printf $OUT "   dir pp %0d vas=VAS%0d\n", ($i + 2 + $it_inc), ($i/4);
    printf $OUT "   dir cq %0d gpa=sm\n", ($i + 2 + $it_inc);
    printf $OUT "   dir pp %0d vas=VAS%0d\n", ($i + 3 + $it_inc), ($i/4);
    printf $OUT "   dir cq %0d gpa=sm\n", ($i + 3 + $it_inc);
    printf $OUT "   dir pp %0d vas=VAS%0d\n", ($i + 4 + $it_inc), ($i/4);
    printf $OUT "   dir cq %0d gpa=sm cq_depth=1024\n", ($i + 4 + $it_inc);
}
print $OUT "\ncfg_end\n";
print $OUT "\nrd hqm_pf_cfg_i.vendor_id";

