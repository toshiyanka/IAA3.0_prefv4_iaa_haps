#!/usr/bin/perl

use strict;
use warnings;

for(my $vas = 0 ; $vas < 1; $vas++) {

    my $file = "vas$vas"."_ldb_crd_ex_hcw.cft";
    
    my $drop_cnt       = 4;
    my $ldb_credit_cnt = 8192;
    
    my $total_num_ldb_ports = 64;
    
    open(my $file_ptr, ">$file") or die "Cannot open $file;$!";

    print $file_ptr "################################################################################\n";
    print $file_ptr "## -- To verify the entire range of ldb credits associated with a VAS$vas\n";
    print $file_ptr "## -- Scenario :\n";
    print $file_ptr "## --    $ldb_credit_cnt HCWs to LDB QID from LDB Ports\n";
    print $file_ptr "## --       $drop_cnt HCWs to DIR QID from DIR Ports (Expected Drop)\n";
    print $file_ptr "## --       $drop_cnt HCWs to LDB QID from DIR Ports (Expected Drop)\n";
    print $file_ptr "################################################################################\n";

    print $file_ptr "\n## -- Disable the LDB CQs for scheduling HCWs";

    for (my $ldb_port = 0; $ldb_port < $total_num_ldb_ports; $ldb_port++) {

        print $file_ptr "\nwr list_sel_pipe.cfg_cq_ldb_disable[$ldb_port].disabled 0x1\n";
        print $file_ptr "rd list_sel_pipe.cfg_cq_ldb_disable[$ldb_port].disabled 0x1\n";
    
    }
    
    for (my $ldb_port = 0; $ldb_port < $total_num_ldb_ports; $ldb_port++) {

        my $num_qe = $ldb_credit_cnt/$total_num_ldb_ports;
        my $qid    = int($ldb_port/2);

        print $file_ptr "\n## -- Sending $num_qe HCWs to LDB QID$ldb_port from LDB Port $ldb_port\n";
        for (my $idx = 0; $idx < ($ldb_credit_cnt/$total_num_ldb_ports); $idx++) {
            print $file_ptr "HCW LDB:$ldb_port qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=1 lockid=0x303 msgtype=0 qpri=0 qtype=uno qid=$qid dsi=0x302\n";
        }
    }

    for (my $ldb_port = 0; $ldb_port < ($total_num_ldb_ports/2); $ldb_port+=2) {
        print $file_ptr "\n## -- Polling whether all QEs are present in QID storage for LDB QID $ldb_port\n";
        my $hex_val = sprintf("%X", ( ($ldb_credit_cnt/$total_num_ldb_ports) * 2)); 
        print $file_ptr "poll list_sel_pipe.cfg_qid_ldb_enqueue_count[$ldb_port] 0x$hex_val 0xffffffff 1000 200\n";
    }
    
    for (my $ldb_port = 0; $ldb_port < $total_num_ldb_ports; $ldb_port++) {

        my $num_qe = $drop_cnt;
        my $qid    = int($ldb_port/2);

        print $file_ptr "\n## -- Sending $num_qe HCWs to LDB QID$ldb_port from LDB Port $ldb_port (ingress_drop)\n";
        for (my $idx = 0; $idx < ($drop_cnt); $idx++) {
            print $file_ptr "HCW LDB:$ldb_port qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=1 lockid=0x303 msgtype=0 qpri=0 qtype=uno qid=$qid dsi=0x302 ingress_drop=1\n";
        }
    }

    print $file_ptr "\nIDLE 10000\n";

    print $file_ptr "\n## -- Enable the LDB CQs for scheduling HCWs";

    for (my $ldb_port = 0; $ldb_port < $total_num_ldb_ports; $ldb_port+=2) {

        print $file_ptr "\nwr list_sel_pipe.cfg_cq_ldb_disable[$ldb_port].disabled 0x0\n";
        print $file_ptr "rd list_sel_pipe.cfg_cq_ldb_disable[$ldb_port].disabled 0x0\n";
    
        my $num_qe  = (($ldb_credit_cnt/$total_num_ldb_ports) * 2);
        my $hex_val = sprintf("%X", $num_qe); 

        print $file_ptr "\n## -- Wait for all the LDB HCWs to be scheduled for LDB Port $ldb_port\n";
        print $file_ptr "poll_sch ldb:$ldb_port 0x$hex_val 0xffffffff 1000 200\n";

        my $tok_return = sprintf("%X", ($num_qe - 1));

        print $file_ptr "\n## -- Return $hex_val tokens using BAT_T for LDB Port $ldb_port\n";
        print $file_ptr "HCW LDB:$ldb_port qe_valid=0 qe_orsp=0 qe_uhl=0 cq_pop=1 meas=0 lockid=0x$tok_return msgtype=0 qpri=0 qtype=uno qid=0 dsi=0x302\n";
        print $file_ptr "\n## -- Return $hex_val completions using COMP for LDB Port $ldb_port\n";
        for (my $cmpl_idx = 0; $cmpl_idx < $num_qe; $cmpl_idx++) {
            print $file_ptr "HCW LDB:$ldb_port qe_valid=0 qe_orsp=0 qe_uhl=1 cq_pop=0 meas=0 lockid=0x0 msgtype=0 qpri=0 qtype=uno qid=0 dsi=0x302\n";
        }
    }

    print $file_ptr "\n## -- Check the drop count value\n";
    my $drop_cnt_val = ($drop_cnt * $total_num_ldb_ports);
    my $val = sprintf("%X", $drop_cnt_val);
    print $file_ptr "rd credit_hist_pipe.cfg_counter_chp_error_drop_l 0x$val 0xffffffff\n";
    print $file_ptr "rd credit_hist_pipe.cfg_counter_chp_error_drop_h 0x0 0xffffffff\n";

}
