#!/usr/bin/env perl

# run in /nfs/sc/disks/sdg74_0842/users/jhasting/regression/regression/hqm_scope /



$ERROR{$error} = "Failed to obtain license";$error++;
$ERROR{$error} = "Dumping VCS Annotated Stack";$error++;
$ERROR{$error} = "NON-ZERO return code";$error++;
$ERROR{$error} = "EXEC_STATUS SYSTEMINIT 1";$error++;


$LOGBOOK{$logbook} = "TEST RESULT:  acerun timed out";$logbook++;

$DEBUG=0;
$NODEBUG=0;

@DIR = grep { -d } glob "*"; 
foreach $_dir (@DIR) {
chdir $_dir;
@SUBDIR = grep { -d } glob "*";                        
foreach $_subdir (@SUBDIR) {
if ($_subdir eq "LOGS") {next;}
chdir $_subdir;
$PRINT="";
$FAIL=1;

`gzip *Ace*.log 2>>/dev/null`;
`cp *Ace*.gz junk.gz 2>>/dev/null`;
`rm junk  2>>/dev/null`;
if (-e "junk.gz") {
`gunzip junk.gz`;
open INPUT, "<junk";
while (<INPUT>) {
chomp;
foreach $_error ( sort {$a <=> $b} keys %ERROR ) {
if ($_ =~ /$ERROR{$_error}/) {
$PRINT="${PRINT}acelog:     $ERROR{$_error}  ";$FAIL=0;
}
}
}
close INPUT ;

`gzip logbook.log 2>>/dev/null`;
`cp logbook.log.gz logbook.log.junk.gz 2>>/dev/null`;
`rm logbook.log.junk  2>>/dev/null`;
if (-e "logbook.log.junk.gz") {
`gunzip logbook.log.junk.gz`;
open INPUT, "<logbook.log.junk";
while (<INPUT>) {
foreach $_error ( sort {$a <=> $b} keys %LOGBOOK ) {
if ($_ =~ /$LOGBOOK{$_error}/) {
$PRINT="${PRINT}logbook:    $LOGBOOK{$_error}  ";$FAIL=0;
}
}
}
close INPUT ;
} else {
$PRINT="${PRINT}incomplete: No logbook log file";$FAIL=0;
}
} else {
$PRINT="${PRINT}incomplete: No Ace log file";$FAIL=0;
}
`rm junk  2>>/dev/null`;
`rm logbook.log.junk  2>>/dev/null`;
if ($FAIL == 1) {$PRINT="failed:     ***** NEED TO DEBUG ***** "; $DEBUG++; } else {$NODEBUG++;}
printf "%-155s $PRINT\n","$_dir/$_subdir";
chdir "..";
}
chdir "..";
}
print "SUMMARY DEBUG:$DEBUG NODEBUG:$NODEBUG\n";

