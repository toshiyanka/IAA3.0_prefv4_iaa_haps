#!/usr/intel/bin/perl
######################################################################
# Description:
#   This module is called by testlib.pm for common functions shared
#   between different levels of validation. 
######################################################################

package common;
use Exporter ();
@ISA    = qw(Exporter);
@EXPORT = qw(
    writeAsyncSeedFile
    addInfo
    FormatAssnReport
    create_find_cdb_scrag
    hack_pcov_file
);
@EXPORT_OK = qw(get_ww);

#-------------------------------------------------------------------------------
# Also sets shell variable cdb_switch
#-------------------------------------------------------------------------------
sub create_find_cdb_scrag {
    my (%args) = @_;
    my ($cdb_ivar, $switch, $ext) = ($args{-cdb_ivar}, $args{-cmdline_switch}, $args{-extension});
    my $fragment;
    
    my $get_cdb;
    if ($cdb_ivar) {
      $get_cdb = "cdb_switch=' $switch $cdb_ivar'\n";
    }
    else {      
      $get_cdb = "cdb_switch=\n";
      $get_cdb .= "list_of_cdbs=`/bin/ls | grep '.$ext\$'`\n";
      $get_cdb .= "for cdb in \$list_of_cdbs; do\n";
      $get_cdb .= "	cdb_switch=\"\$cdb_switch $switch \$cdb\"\n";
      $get_cdb .= "done\n";
    }
    
    $fragment .= <<EOS;

# Find all coverage dbs and create cmd-line for them
$get_cdb
EOS
    
    return $fragment;
    
}
#-------------------------------------------------------------------------------


sub new {
    my($class) = @_;
    my($test) = {};
    bless($test, $class);
    return($test);
}

sub FormatAssnReport {
    
    my (%args) = @_;
    my($indir, $infile, $outdir, $outfile, $zipout, $rmindir, $testname) = @args{'-rpt_dir', '-rpt', '-outdir', '-outfile', '-zipout', '-rmindir', '-testname'};
    my($input_file, $line_orig, @f, @rpt, $i, @l, $status, $output_file);

    $indir =~ s/\s+//g;
    $infile =~ s/\s+//g;
    $outdir =~ s/\s+//g;
    $outfile =~ s/\s+//g;
 
    $input_file = "${indir}/${infile}";
    $output_file = "${outdir}/${outfile}";
 
    (-d "$indir") or return "$indir does not exist.";
    (-f "$input_file" ) or return "${indir}/${infile} does not exist";
 
    ($input_file =~ /\.gz$/ ) ? open(SIMASNRPT,"gzip -dcf $input_file |") || return "$input_file: $!" : open(SIMASNRPT,"<$input_file") || return "$input_file: $!";
 
    while(<SIMASNRPT>) {
	chomp;
	$line_orig = $_;
	s/\s+\././g; #HSD 556388 - Assertion Name that has a space not showing up in the report
	@f = split(/\s+/, $_);
	next unless ($#f == 6);
	next if ($f[0] =~ /^\s*\d+/);
 
	if (( $f[1] =~ /\d+/ ) && ( $f[2] =~ /\d+/ ) && ( $f[3] =~ /\d+/ ) && ( $f[4] =~ /\d+/ ) && ( $f[5] =~ /\d+/ ) && ( $f[6] =~ /\d+/ ) ) {
	    @l = split(/\s+/, $line_orig);
	    for($i=0;$i<6;$i++) { pop(@l); }
	    if ( $f[5] > 0 ) {
                $status = "FAIL";
            }
            elsif ( $f[6] > 0 ) {
              $status = "INCOMPLETE";
            }
            elsif ( $f[4] > 0 ) {
              $status = "PASS";
            }
            else {
              $status = "FALSEPASS";
            }
            push(@rpt, sprintf("%s,%s,%d,%d,%d,%d,%d,%d", join(" ",@l), $status, $f[4], $f[5], $f[6], $f[3], $f[2], $f[1]));
	}
    }
    if ( $#rpt > 0 ) {
        system("mkdir -p $outdir");
        open(ASNRPTOUT, "> $output_file") or die "Could not open $output_file for writing, $!";
        print ASNRPTOUT "Name,Status,Pass,Fail,Incomplete,Attempts,Severity,Category\n";
        map { print ASNRPTOUT "$_\n" } @rpt;
        close ASNRPTOUT;
        
        my (@asndata) = `/p/cse/avc/models/abv/asn_bin/latest/printasn $output_file`;
        
        $asn_rec = new TestInfo;

        foreach $line(@asndata)
        {
                
            @fields = split (/,/,$line);

            my(@countarr);
            push(@countarr,$fields[2],$fields[3],$fields[4]);

            my $count = join (":",@countarr);
            
            $asn_rec->{@fields[0]}->{$testname}->{"R"} = $counter;
            $asn_rec->{@fields[0]}->{$testname}->{"C"} = $count;
            if($fields[1] =~ /\s+PASS/i)
            {
                $asn_rec->{@fields[0]}->{$testname}->{"S"} = "P";
            }elsif($fields[1] =~ /FAIL/i)
            {
                $asn_rec->{@fields[0]}->{$testname}->{"S"} = "F";
            }elsif($fields[1] =~ /INCOMPLETE/i)
            {
                $asn_rec->{@fields[0]}->{$testname}->{"S"} = "I";
            }elsif($fields[1] =~ /FALSEPASS/i)
            {
                $asn_rec->{@fields[0]}->{$testname}->{"S"} = "U";
            }
        }
        
        $asn_rec->{$counter} = $runcmd;
        $counter++;
        &writeDB("${outdir}/${testname}.tinfo",$asn_rec);
        system ("gzip -q -f ${outdir}/${testname}.tinfo"); 
        system("chmod 775 ${outdir}/${testname}.tinfo.gz");

        $zipout and system("gzip -f $output_file");
    }
    else {
       print "Did not find any assertion result data in file : $input_file";
    }
    
   
    
    return 0;
}


sub writeDB {
   my($file, $data) = @_;
   
   use lib ("/p/cse/avc/models/abv/asn_bin/latest");
   use Storable qw( nstore_fd retrieve );
   use Fcntl;
   
   my $SIG;

   foreach $key ( "INT" , "QUIT" , "STOP" , "TERM" , "KILL" ) { $SIG{$key}  = "IGNORE"; }
   sysopen (DB , "$file" , O_CREAT|O_TRUNC|O_WRONLY , 0664 ) || return 1; # 1 means could not open
   eval { nstore_fd $data, *DB };
   $@ and return 2; # 2 means could not write
   close DB;
   
   return 0;
}

#-------------------------------------------------------------------------------
sub writeAsyncSeedFile {
    
    my ($asyncseed, $run_dir, $src_dir) = @_;
    my $asyncinfo    = "";

    # setup the seed files for async sync
    if ( $asyncseed ne 'none' ) {
        if( !(defined $asyncseed) or $asyncseed =~ /rand(om)?(\d?)/ ) {
            my $hi = 0x7FFFFFFF;
            $hi = $2 if $2;
            if (defined($testlib::global_seed)) {
              $asyncseed = sprintf "%d", $testlib::global_seed;
              print "ASYNCSEED: Using Global seed $asyncseed\n";
	      $asyncinfo = "$asyncseed (using global seed)";
            } else {
              $asyncseed = int(rand $hi);
              print "ASYNCSEED: Picking random seed $asyncseed\n";
	      $asyncinfo = "$asyncseed (picking random seed)";
            }
	} else {
	  $asyncinfo = "$asyncseed (commandline specified seed)";
        }
        print "NOTE: Setting random async syncronizer seed to $asyncseed\n";
        open SEED, ">$run_dir/asyncseed" or &fatal("subroutine writeAsyncSeedFile: Can't open $run_dir/asyncseed for writing: $!\n");
        print SEED "$asyncseed\n";
        close SEED;
    } else {
        if( -e "$src_dir/asyncseed" and !(defined $asyncseed and $asyncseed eq 'none') ) {
            print "NOTE: Using test supplied random async syncronizer seed\n";
            &copyFile( "$src_dir/asyncseed", "$run_dir/asyncseed" );
			$asyncseed = `cat $run_dir/asyncseed`;
			$asyncinfo = "$asyncseed (seedfile)";
        } else {
            print "NOTE: Disabling random async syncronizers\n";
            # disable random async testing
            open SEED, ">$run_dir/asyncseed" or &fatal("subroutine writeAsyncSeedFile: Can't open $run_dir/asyncseed for writing: $!\n");
            print SEED "-1\n";
            close SEED;
			$asyncinfo = "-1 (async synchronizers are disabled)";
        }
    }
	&addInfo("$run_dir/info", "ASYNC_SYNCZR SEED", $asyncinfo);
}
#-------------------------------------------------------------------------------
sub addInfo {

        my ($filename, $key, $value) = @_;

        $line =~ s/\n//g;
        open(info, ">> $filename") || &fatal("subroutine addInfo: Can't open $filename: $!\n");
        print info "$key;;$value\n";
        close(info);
}

#-------------------------------------------------------------------------------
=pod
get_ww($date, $strip)
Returns work week that contains the input date, in format yyWWww, where yy = last
2 digits of year, and ww is the work week, e.g. 08WW23
If $date is undef (or omitted) returns current work week as determined by UNIX utility workweek.
Input: $date   date in format mm/dd/yy
       $strip  if 1, return work week in format yyww (without the WW)
Output: work week in format yyWWww
=cut
#-------------------------------------------------------------------------------------
sub get_ww {
   my ($date, $strip) = @_;
   my $ww = $strip?`workweek -f '%IY%02IW' $date`:`workweek -f '%IYWW%02IW' $date`;
   $ww =~ s/^\d\d//;
   chomp $ww;
   return $ww;
}
#-------------------------------------------------------------------------------
# HSD 773814 : SPI need hack to merge coverage from SV test and cc test
sub hack_pcov_file {
    my (%args) = @_;
    my ($path, $file, $original_text, $replace_text) = @args{'-path', '-file', '-original_text', '-replace_text'};
    open(READFILE, "gzip -dcf $path/$file |") or print "$! ($path/$file) \n";
    open(WRITEFILE, "> $path/temp.pcov") or print "$! ($path/temp.pcov)\n";

    while (<READFILE>) {
            $line = $_;
            $line =~ s/$original_text/$replace_text/g;
            print WRITEFILE $line;
    }

    close(READFILE);
    close(WRITEFILE);

    `gzip $path/temp.pcov`;
    `mv $path/temp.pcov.gz $path/$file`;


}
1;
