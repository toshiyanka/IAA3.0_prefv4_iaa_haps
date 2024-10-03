#!/usr/bin/perl

use strict;
use warnings;

for(my $vas = 0 ; $vas < 1; $vas++) {

    my $file = "vas$vas"."_dir_crd_ex_hcw.cft";
    
    my $drop_cnt       = 4;
    my $dir_credit_cnt = 4096;
    
    my $total_num_dir_ports = 64;
    
    open(my $file_ptr, ">$file") or die "Cannot open $file;$!";

    print $file_ptr "################################################################################\n";
    print $file_ptr "## -- To verify the entire range of dir/ldb credits associated with a VAS$vas\n";
    print $file_ptr "## -- Scenario :\n";
    print $file_ptr "## --    $dir_credit_cnt HCWs to DIR QID from DIR Ports\n";
    print $file_ptr "## --       $drop_cnt HCWs to DIR QID from DIR Ports (Expected Drop)\n";
    print $file_ptr "## --       $drop_cnt HCWs to LDB QID from DIR Ports (Expected Drop)\n";
    print $file_ptr "################################################################################\n";

    print $file_ptr "\n## -- Disable the DIR CQs for scheduling HCWs";

    for (my $dir_port = 0; $dir_port < $total_num_dir_ports; $dir_port++) {

        print $file_ptr "\nwr list_sel_pipe.cfg_cq_dir_disable[$dir_port].disabled 0x1\n";
        print $file_ptr "rd list_sel_pipe.cfg_cq_dir_disable[$dir_port].disabled 0x1\n";
    
    }
    
    for (my $dir_port = 0; $dir_port < $total_num_dir_ports; $dir_port++) {

        my $num_qe = $dir_credit_cnt/$total_num_dir_ports;

        print $file_ptr "\n## -- Sending $num_qe HCWs to DIR QID$dir_port from DIR Port $dir_port\n";
        for (my $idx = 0; $idx < ($dir_credit_cnt/$total_num_dir_ports); $idx++) {
            print $file_ptr "HCW DIR:$dir_port qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=1 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=$dir_port dsi=0x302\n";
        }
    }

    for (my $dir_port = 0; $dir_port < $total_num_dir_ports; $dir_port++) {

        my $qe_cnt = int($dir_credit_cnt/$total_num_dir_ports);

        print $file_ptr "\n## -- Polling whether all QEs are present in QID storage for DIR QID $dir_port\n";
        my $hex_val = sprintf("%x", $qe_cnt); 
        print $file_ptr "poll list_sel_pipe.cfg_qid_dir_enqueue_count[$dir_port] 0x$hex_val 0xffffffff 1000 20\n";
    }
    
    for (my $dir_port = 0; $dir_port < $total_num_dir_ports; $dir_port++) {

        my $num_qe = $drop_cnt;
        print $file_ptr "\n## -- Sending $num_qe HCWs to DIR QID$dir_port from DIR Port $dir_port (ingress drop)\n";
        for (my $idx = 0; $idx < ($drop_cnt); $idx++) {
            print $file_ptr "HCW DIR:$dir_port qe_valid=1 qe_orsp=0 qe_uhl=0 cq_pop=0 meas=1 lockid=0x303 msgtype=0 qpri=0 qtype=dir qid=$dir_port dsi=0x302 ingress_drop=1\n";
        }
    }

    print $file_ptr "\nIDLE 10000\n";

    print $file_ptr "\n## -- Enable the DIR CQs for scheduling HCWs";

    for (my $dir_port = 0; $dir_port < $total_num_dir_ports; $dir_port++) {

        print $file_ptr "\nwr list_sel_pipe.cfg_cq_dir_disable[$dir_port].disabled 0x0\n";
        print $file_ptr "rd list_sel_pipe.cfg_cq_dir_disable[$dir_port].disabled 0x0\n";
    
    }
    
    for (my $dir_port = 0; $dir_port < $total_num_dir_ports; $dir_port++) {
       
       my $hex_val = sprintf("%X", int($dir_credit_cnt/$total_num_dir_ports)); 

       print $file_ptr "\n## -- Wait for all the DIR HCWs to be scheduled for DIR Port $dir_port\n";
       print $file_ptr "poll list_sel_pipe.cfg_cq_dir_tot_sch_cntl[$dir_port] 0x$hex_val 0xffffffff 1000 20\n";
       print $file_ptr "poll list_sel_pipe.cfg_cq_dir_tot_sch_cnth[$dir_port] 0x0   0xffffffff 1000 20\n";

       my $tok_return = sprintf("%X", int(($dir_credit_cnt/$total_num_dir_ports) - 1));

       print $file_ptr "\n## -- Return 0x$hex_val tokens using BAT_T for DIR Port $dir_port\n";
       print $file_ptr "HCW DIR:$dir_port qe_valid=0 qe_orsp=0 qe_uhl=0 cq_pop=1 meas=0 lockid=0x$tok_return msgtype=0 qpri=0 qtype=dir qid=0 dsi=0x302\n";
    }
    
    print $file_ptr "\n## -- Check the drop count value\n";
    my $drop_cnt_val = ($drop_cnt *  $total_num_dir_ports);
    my $val = sprintf("%X", $drop_cnt_val);
    print $file_ptr "rd credit_hist_pipe.cfg_counter_chp_error_drop_l 0x$val 0xffffffff\n";
    print $file_ptr "rd credit_hist_pipe.cfg_counter_chp_error_drop_h 0x0 0xffffffff\n";

}
