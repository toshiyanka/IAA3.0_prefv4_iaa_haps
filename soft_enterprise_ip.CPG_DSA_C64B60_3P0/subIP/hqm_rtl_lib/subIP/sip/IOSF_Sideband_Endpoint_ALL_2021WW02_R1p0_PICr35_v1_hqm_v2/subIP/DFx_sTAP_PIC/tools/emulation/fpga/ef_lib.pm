package ef_lib;
use strict;
use warnings;


##########Common subroutines###########
sub printa ($$){
	my $msg = shift;
	my $log = shift;
	if (defined($log)!=1){
	  print '$log not defined\n';
	  print_trace_info();
	  exit -1;
	}
	foreach my $l (@{$msg}){
	  ef_lib::printl($l, $log);
	}
	return;
}#sub printa {

sub printl ($$){
	my $msg = shift;
	my $log = shift;
	if (defined($log)!=1){
	  print '$log not defined\n';
	  print_trace_info();
	}
	if (defined($msg)!=1){
	  print '$msg not defined\n';
	  print_trace_info();
	}
	open (LOG, ">>$log") || die "Could not open log file $log $msg $!\n";
	print LOG "$msg";
	print STDOUT "$msg";
	close LOG;
	return;
}#sub printl {

sub mydie ($$){
	my $msg = shift;
	my $log = shift;
	&printl($msg,$log);
	exit;
}#sub mydie {


sub print_trace_info(){
    my $cnt = 5;
    my  ($package, $filename, $line,  $subroutine);
    my $i;
    my $str;
    for ($i=0; $i<=$cnt; $i++){ 
        ($package, $filename, $line,  $subroutine) = caller($i);
        if ((defined $package )!=1) {
            return;
        }
        if (defined $package){
            if ($i!=0) {
                $str = sprintf( "called from %s at line %d in %s\n", $subroutine, $line, $filename);
            }else{
                $str = sprintf( "at line %d in %s\n", $line, $filename);
            }
            print $str;
        }
        if ($subroutine =~ m/main\:\:/ ) {
            return;
        }
    }
}

sub which_synplify_premier(){
   my $which_cmd = "which synplify_premier";
   my $cmd = `$which_cmd`;
   chomp $cmd;
   return $cmd;
}

sub wait_until_job_limit_not_reached($){
   my $max_job_cnt = shift;
   if ($max_job_cnt>0){
      my $CurrentJob_wc; 
      do {
         $CurrentJob_wc = `nbqstat | grep $ENV{'USER'} | wc -l`;
         chomp $CurrentJob_wc;
         ef_lib::printl(sprintf("$CurrentJob_wc"), $main::log);
      } while ($CurrentJob_wc >= $max_job_cnt);
      ef_lib::printl(sprintf("\n"), $main::log);
   }
}
1;