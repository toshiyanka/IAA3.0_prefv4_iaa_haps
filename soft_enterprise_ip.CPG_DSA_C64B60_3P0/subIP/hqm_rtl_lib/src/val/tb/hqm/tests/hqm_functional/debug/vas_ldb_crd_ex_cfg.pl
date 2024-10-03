#!/usr/bin/perl

use strict;
use warnings;

for(my $vas = 0 ; $vas < 1; $vas++) {

    my $file = "vas$vas"."_ldb_crd_ex_cfg.cft";

    my $ldb_credit_cnt = 8192;
    
    my $total_num_ldb_ports = 64;
    
    open(my $file_ptr, ">$file") or die "Cannot open $file;$!";
    
    print $file_ptr "## -- Setup LUTs used by HCWs\n";
    print $file_ptr "#mem_update      # initialize memories to hqm_cfg defaults using backdoor access\n";
    print $file_ptr "\n";
    
    print $file_ptr "cfg_begin\n";

    print $file_ptr "\n";

    print $file_ptr "\n";
    for (my $ldb_port = 0; $ldb_port < ($total_num_ldb_ports/2); $ldb_port++) {
        print $file_ptr "ldb qid $ldb_port qid_ldb_inflight_limit=512\n";
    }

    print $file_ptr "\n";
    my $ldb_credit_hex_val = sprintf("%X", $ldb_credit_cnt);
    print $file_ptr "vas 0 credit_cnt=0x$ldb_credit_hex_val ";
    for (my $ldb_port = 0; $ldb_port < ($total_num_ldb_ports/2); $ldb_port++) {
        print $file_ptr "ldb_qidv$ldb_port=1 ";
    }
    
    print $file_ptr "\n\n";
    
    print $file_ptr "\n";
    for (my $ldb_port = 0; $ldb_port < $total_num_ldb_ports; $ldb_port++) {

        my $hist_list_limit = 1023;
        my $hist_list_base  = 0; 

        print $file_ptr "ldb pp $ldb_port vas=0\n";
        print $file_ptr "ldb cq $ldb_port gpa=sm cq_depth=1024 cq_ldb_inflight_limit=512 hist_list_base=$hist_list_base hist_list_limit=$hist_list_limit";
        if ( !($ldb_port%2) ) {
            my $qid = int($ldb_port/2);
            print $file_ptr " qidv0=1 qidix0=$qid\n";
        } else {
            print $file_ptr "\n";
        }
    } 
    print $file_ptr "\ncfg_end";
}
