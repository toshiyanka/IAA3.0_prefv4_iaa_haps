#!/usr/bin/env perl

use Getopt::Long qw(GetOptions);
use Math::BigFloat lib => 'Calc';

my $help;
my $rundir = "";
my $detail;
my @acerunfiles;
my $emptyfiles;
my %result;
my %resid;

my $col_1 = 15;
my $col_n = 8;

GetOptions( 'help|h+'       => \$help,
            'rundir=s'      => \$rundir,
            'verbose|v+'    => \$verbose) || die ("\nError in command line args\n\n");

if($help){
    print("
                -rundir      (M): regression dir path
                -v | verbose (O): Print verbose report
                -h | -help   (O): Prints this help message\n\n");
exit(0);
}
    
    die("\nError Mandatory opt 'rundir' is empty.\n\n") if($rundir eq "");

    die("\nError rundir does not exists <%s>\n\n", $rundir) if!(-e $rundir);

@acerunfiles = `find $rundir -name 'acerun.log*'`;

    die("\nError no logfile found pls check run path <%s>\n\n", $rundir) if($#acerunfiles == -1);

foreach my $acerunfile (sort @acerunfiles){
    chomp($acerunfile);
    my @strs = `zgrep 'DIR QPRI.*Average Latency' $acerunfile`;
#    my @strs = `zgrep 'CQ.*Average Latency' $acerunfile`;
    my $cq_cnt = 0;
    my $throughput = Math::BigFloat->new(0,3);
    if($#strs >= 0){
        foreach my $str (@strs){
            chomp($str);
            if($str =~ m/DIR QPRI(.*)Throughput\s*=\s*(\w*\.\w*)\s*ns.*/){
#            if($str =~ m/CQ\s*(0x\w*).*Throughput\s*=\s*(\w*\.\w*)\s*ns.*/){
                my $thrpt   = Math::BigFloat->new($2,3);
                $throughput = $throughput + $thrpt;
                $cq_cnt ++;
            } else {
                printf("\nError Unknown format <%s>\n\n", $str);
            }
        }
        my $tname;
        my $testid;
        if($acerunfile =~ m/.*\/hcw_perf_dm_test1_(\w*)_(\w*)\/acerun.log.*/){
            $tname = $1;
            $testid = $2;
        } elsif($acerunfile =~ m/.*\/hcw_perf_dm_test1_(\w*)\/acerun.log.*/){
            $tname = $1;
            $testid = "ZeroDly";
        } else{
                printf("\nError Unknown test name format <%s>\n\n", $acerunfile);
        }
        my $ave_TP = Math::BigFloat->new(($throughput / $cq_cnt),3);
#        printf("Test Name: <%s> ID <%s> Average Throughput <%4.2f> ns/HCW \n", $tname, $testid, $ave_TP);
        $col_1 = (length($tname) > $col_1) ? (length($tname) + 3) : $col_1;
        $result{$tname}{$testid} = $ave_TP;
        $resid{$testid} = 1;
        
    } else {
        push(@emptyfiles, $acerunfile);
    }   
}

my $str = fmtprnt(sprintf("  Test Name "), $col_1);
foreach my $tid (sort keys %resid){
    $str .= fmtprnt(sprintf("%0s",$tid), $col_n);
}
print "\n$str\n";

foreach my $tstname (sort keys %result){
    $str = fmtprnt(sprintf(" %0s",$tstname), $col_1);
    foreach my $tid (sort keys %resid){
        if(exists($result{$tstname}{$tid})){
            $str .=  fmtprnt(sprintf("%4.2f",$result{$tstname}{$tid}), $col_n);
        } else {
            $str .= fmtprnt("xxx.xx", $col_n);
        }
    }
    $str .= "\n";
    print "$str";
}
    print "\n";

sub fmtprnt(){
    my ($str, $len) = @_;
    my $slen = length($str);
    my $space = ($len > $slen) ? $len - $slen : 0;
    my $fstr = $str;
    for(my $i = 0; $i <= $space; $i++){
        $fstr .= " ";
    }
    $fstr .= "|";
    return $fstr;
}

