#!/usr/bin/perl

use strict;
use warnings;

for(my $vas = 0 ; $vas < 32; $vas++) {

    my $file = "vas$vas"."_crd_ex_cfg.cft";

    my $credit_cnt = 4096 + 8192;
    
    my $total_num_ldb_ports = 64;
    my $total_num_dir_ports = 64;
    
    open(my $file_ptr, ">$file") or die "Cannot open $file;$!";
    
    print $file_ptr "## -- Setup LUTs used by HCWs\n";
    print $file_ptr "#mem_update      # initialize memories to hqm_cfg defaults using backdoor access\n";
    print $file_ptr "\n";
    
    print $file_ptr "cfg_begin\n";

    print $file_ptr "\n";

    print $file_ptr "msix_alarm 0 enable=0x1 addr=0xaaaa5555aaaa5555 data=0xaaaa5555\n";
    print $file_ptr "\n";

    for (my $dir_port = 0; $dir_port < $total_num_dir_ports; $dir_port++) {
        print $file_ptr "dir qid $dir_port\n";
    }
    
    print $file_ptr "\n";
    for (my $ldb_port = 0; $ldb_port < ($total_num_ldb_ports/2); $ldb_port++) {
        print $file_ptr "ldb qid $ldb_port qid_ldb_inflight_limit=512\n";
    }

    print $file_ptr "\n";
    my $credit_hex_val = sprintf("%X", $credit_cnt);
    print $file_ptr "vas $vas credit_cnt=0x$credit_hex_val ";
    for (my $dir_port = 0; $dir_port < $total_num_dir_ports; $dir_port++) {
        print $file_ptr "dir_qidv$dir_port=1 ";
    }
    for (my $ldb_port = 0; $ldb_port < ($total_num_ldb_ports/2); $ldb_port++) {
        print $file_ptr "ldb_qidv$ldb_port=1 ";
    }
    
    print $file_ptr "\n\n";
    for (my $dir_port = 0; $dir_port < $total_num_dir_ports; $dir_port++) {
        print $file_ptr "dir pp $dir_port vas=$vas\n";
        print $file_ptr "dir cq $dir_port gpa=sm cq_depth=128\n";
    } 
    
    print $file_ptr "\n";
    for (my $ldb_port = 0; $ldb_port < $total_num_ldb_ports; $ldb_port++) {

        my $hist_list_limit = 1023;
        my $hist_list_base  = 0; 

        print $file_ptr "ldb pp $ldb_port vas=$vas\n";
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
