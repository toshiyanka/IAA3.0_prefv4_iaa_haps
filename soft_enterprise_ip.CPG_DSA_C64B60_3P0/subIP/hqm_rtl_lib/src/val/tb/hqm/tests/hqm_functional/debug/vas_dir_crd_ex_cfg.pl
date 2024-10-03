#!/usr/bin/perl

use strict;
use warnings;

for(my $vas = 0 ; $vas < 1; $vas++) {

    my $file = "vas$vas"."_dir_crd_ex_cfg.cft";

    my $credit_cnt = 4096;
    
    my $total_num_dir_ports = 64;
    
    open(my $file_ptr, ">$file") or die "Cannot open $file;$!";
    
    print $file_ptr "## -- Setup LUTs used by HCWs\n";
    print $file_ptr "#mem_update      # initialize memories to hqm_cfg defaults using backdoor access\n";
    print $file_ptr "\n";
    
    print $file_ptr "cfg_begin\n";

    print $file_ptr "\n";

    for (my $dir_port = 0; $dir_port < $total_num_dir_ports; $dir_port++) {
        print $file_ptr "dir qid $dir_port\n";
    }
    
    print $file_ptr "\n";
    my $credit_hex_val = sprintf("%X", $credit_cnt);
    print $file_ptr "vas 0 credit_cnt=0x$credit_hex_val ";
    for (my $dir_port = 0; $dir_port < $total_num_dir_ports; $dir_port++) {
        print $file_ptr "dir_qidv$dir_port=1 ";
    }
    
    print $file_ptr "\n\n";
    for (my $dir_port = 0; $dir_port < $total_num_dir_ports; $dir_port++) {
        print $file_ptr "dir pp $dir_port vas=0\n";
        print $file_ptr "dir cq $dir_port gpa=sm cq_depth=128\n";
    } 
    
    print $file_ptr "\n";
    print $file_ptr "\ncfg_end";
}
