#!/usr/intel/bin/perl -w
## collect all  the failing test information in an array
#On per user basis, go to the result directory and grep for TEST RESULT to get failing signature
#Collect the data per user basis, and post it in an email.
 
use strict;
use warnings;
use DateTime;

#my $Tomail = "amit.biswal\@intel.com sharat.chauhan\@intel.com vijay.agarwal\@intel.com neeraj.shete\@intel.com an.yan\@intel.com diwakar.suvvari\@intel.com rajendra.shekhawat\@intel.com amol.raghuwanshi\@intel.com richard.byrne\@intel.com ";
my $Tomail = " vijay.agarwal\@intel.com "; 
##my $Ccmail = "william.burroughs\@intel.com nikhil.tambekar\@intel.com krishna.bhandi\@intel.com michael.betker\@intel.com";




my $dt=DateTime->now(time_zone=>"local");

my $todate = $dt->mdy;
my $ww = $dt->week_number;

my $fromdate = $dt->subtract(weeks => 1);

$fromdate = $fromdate->mdy;


print $fromdate . "\n";
print $todate . "\n";


if (! exists ($ENV{'VALID_ROOT'})) {
    die "You must be in a HDK environment to use gen_regr_report.pl.\n";
}


my @fail_rep = `/p/hdk/rtl/cad/x86-64_linux30/dt/granite_atr/2.1.1p1/bin/hsql -db te_ncsg \"select testrun_owner, gridl,result_directory,test_name,status from teststat where status ='Fail' and (stepping = 'wave4' or stepping = 'wave3' or stepping = 'hqm-a0')  and team = 'hqm' and date_run > '$fromdate 00:00:00'  and date_run < '$todate 20:00:00'\" `;

my @fail_rep_arr = sort @fail_rep;

#anyan hqm_sc1_prod-hqm_core_reg_jtc_6-171027211644 /nfs/sc/disks/axx_0101/valid/granite_10nm/hqm_sc1_prod/hqm-srvr10nm-17ww43d/hqm_core_reg_jtc_6/hqmcore_trfs000_S10P81050500.126220883 hqmcore_trfs000 fail

my $count=0;
my $report_str = "";

$report_str .= "================================================\n";
foreach my $ftest (@fail_rep_arr) {
    $count++;
    chomp $ftest;
    my ($user,$gridl,$run_path,$test,$res) = split(/\s/,$ftest);
    #print "NMT#$user,$gridl,$run_path,$test,$res \n";
    
    my $fail_sig = `zgrep -m 1 "TEST RESULT" $run_path/*.rpt.gz`;
    $fail_sig =~ s/TEST RESULT://;
    chomp $fail_sig;
    chomp $gridl;
    
    (my $tl) = ($gridl =~ /hqm_sc1_prod-(\w+)-(\d+)$/);
    if ($tl =~ /hqmv2_/) { #NMT:: Exclude hqmv2 results.
    $report_str .= "================================================\n";
    $report_str .= "$count|$user|$tl|$test|\"$fail_sig\"|$run_path|\n\n";
    $report_str .= "================================================\n";
    }
    ## print "HQMV25 Failures\n"
    elsif ($tl =~ /hqmv25_/) { #NMT:: Exclude hqmv2 results.
    $report_str .= "================================================\n";
    $report_str .= "$count|$user|$tl|$test|\"$fail_sig\"|$run_path|\n\n\n";
    $report_str .= "================================================\n";
    }
    ##{$report_str .= "=======       HQMV1B0 Failures          =========\n"; }
    else {
    $report_str .= "================================================\n";
    $report_str .= "$count|$user|$tl|$test|\"$fail_sig\"|$run_path|\n";
    $report_str .= "================================================\n";
    }

}

$report_str .= "================================================\n";

#print $report_str;


eval {
    use Mail::Mailer;
    my $mailprog = Mail::Mailer->new('sendmail');
    my $sub      = "Regression report hqm_sc1_prod WW($ww)";
    my %headers  = (
        'To'      => $Tomail,
       ## 'Cc'      => $Ccmail,   
        'Subject' => "$sub",
        );
    $mailprog->open(\%headers);
    print $mailprog "$report_str";
    $mailprog->close();
};



