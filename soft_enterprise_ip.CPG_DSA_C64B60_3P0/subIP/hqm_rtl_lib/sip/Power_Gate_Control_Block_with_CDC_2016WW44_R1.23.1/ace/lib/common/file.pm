#!/usr/intel/bin/perl
#
# Local Copy Commands
#############################################
package file;
use Exporter ();
use FileHandle;
use File::Copy;
use File::Find;
@ISA    = qw(Exporter);
@EXPORT = qw(FindFile copyFile copyFileQuiet appendFile moveFile 
	     makeFile delFile makePath copyDir copyDirRec cleanDir
	     cleanDirRec unzipDirRec listDir status fatal HandleCtrlC relPath findYoungestFile storePlatformInfo);

sub HandleCtrlC{
	local $RUNCMD = shift @_;
	$SIG{INT} = 'DEFAULT';
	warn "\n\n$RUNCMD:Hmmmmmmm! Ctrl-C asserted!\n\n\n";
	exit(0);
}
sub copyFile {
    local($file1, $file2) = @_;
    local($mode);
    local($val);
    if ($file1 eq $file2) {
	&fatal("Can't copy $file1 onto itself");
    }
    &delFile($file2);
    $val = copy($file1, $file2);
    &fatal("Copy of $file1 to $file2 failed") if ($val =~ /0/);
    chmod 0777, $file2;
}

sub copyFileQuiet {
    local($file1, $file2) = @_;
    local($mode);
    local($val);
    return if ($file1 eq $file2);
    &delFile($file2);
    $val = copy($file1, $file2);
    &fatal("Copy of $file1 to $file2 failed") if ($val =~ /0/);
    chmod 0777, $file2;
}

sub appendFile {
    local($file1, $file2) = @_;
    open(F1,$file1) or &fatal("Can't open $file1 as source.");
    open(F2,">> $file2") or &fatal("Can't open $file2 as destination.");
    autoflush F2 1;
    print F2 <F1>;
    close(F1);
    close(F2);
}

sub moveFile {
    local($file1, $file2) = @_;
    if (-l $file1) {
        &copyFile($file1, $file2);
        &delFile($file1);
    }
    elsif (-e $file1) {
	move($file1, $file2);
    }
    return;
}

sub makeFile {
    local $file1 = shift (@_);
    unless (-e $file1) {
	open(TEMP,">$file1");
	close(TEMP);
    }
    return;
}

sub delFile {
    local $file1 = shift (@_);
    if (-e($file1)) {
	chmod 0777, $file1;
	unlink $file1;
    }
    return;
}

sub copyDir {
    local($dir1, $dir2) = @_;
    local($file);
    &fatal("Can't open $dir1 as source.") unless (-e $dir1);
    mkdir $dir2, 0770 unless (-e $dir2);
    local(@files) = &listDir($dir1);
    while (@files) {
	$file = shift @files;
	next if ($file =~ /^\./);
	next if (-d "$dir1/$file");
	&copyFile("$dir1/$file","$dir2/$file");
    }
    return;
}

sub copyDirRec {
    local($dir1, $dir2) = @_;
    local($file);
    return unless (-e $dir1);
    mkdir $dir2, 0777 unless (-e $dir2);
    local(@files) = &listDir($dir1);
    while (@files) {
        $file = shift @files;
        next if ($file =~ /runsim_log/);
        if (-l "$dir1/$file") {
            $link = readlink("$dir1/$file");
            symlink($link,"$dir2/$file");
            next;
        }
        if (-d "$dir1/$file") {
            &copyDirRec("$dir1/$file","$dir2/$file");
            next;
        }
        &copyFileQuiet("$dir1/$file","$dir2/$file");
    }
    return;
}

sub cleanDir {
    local($dir) = shift @_;
    local(@files) = &listDir($dir);
    while (@files) {
	$file = shift @files;
	# don't delete regression log file
	next if ($file =~ /runsim_log/);
	next if (-d "$dir/$file");
	&delFile("$dir/$file");
    }
    return;
}

sub cleanDirRec {
    local($dir) = shift @_;
    local(@files) = &listDir($dir);
    while (@files) {
        $file = shift @files;
        if (-l "$dir/$file"){
            unlink "$dir/$file";
            next;
        }
        if (-d "$dir/$file"){
            &cleanDirRec("$dir/$file");
            next;
        }
        &delFile("$dir/$file");
    }
    return;
}

sub unzipDirRec {
    local($dir) = shift @_;
    local(@files) = &listDir($dir);
    while (@files) {
        $file = shift @files;
        if (-l "$dir/$file"){
            next;
        }
        if (-d "$dir/$file"){
            &unzipDirRec("$dir/$file");
            next;
        }
        system("gunzip $dir/$file");
    }
    return;
}

sub listDir {
    local($dir) = shift @_;
    opendir DIR, $dir;
    local(@files) = grep !/^\.\.?$/, readdir DIR;
    closedir DIR;
    return(@files);
}

sub makePath {
    local($path) = shift @_;
    local(@data) = split /\//,$path;
    shift @data;
    local($bpath) = "/";
    $bpath .= shift @data;
    return(0) unless (-e $bpath);
    while (@data) {
	$bpath .= "/";
	$bpath .= shift @data;
	mkdir $bpath, 0777 unless (-e $bpath);
    }
    return(0) unless (-e $bpath);
    return(1);
}

sub FindFile {
    local($dir) = shift @_;
    local($filex) = shift @_;
    opendir DIR, $dir;
    local(@files) = grep /$filex/, readdir DIR;
    closedir DIR;
    return(@files);
}

###########################
### calcualte the relative path between two objects
sub relPath {
    my $srcpath = shift @_;
    my $dstpath = shift @_;
    my $relpath = "";
    my @sp = split /\//, $srcpath;
    my @dp = split /\//, $dstpath;
    # remove common path elements
    while ($sp[0] eq $dp[0]) {
	shift @sp;
	shift @dp;
    }
    # go up to common point
    while (@sp) {
	shift @sp;
	$relpath .= "../";
    }
    # go down to end point
    while (@dp) {
	$relpath .= shift @dp;
	$relpath .= "/" if (@dp);
    }
    return ($relpath);
}
	    

######################################
#  regression status file management
sub status {
    $stat = shift (@_);
    my $hname = "";
    open (HOSTTYPE, "/usr/intel/bin/hosttype |") || &fatal("Can't identify host.");
    $hosttype = <HOSTTYPE>;
    close (HOSTTYPE);

    ($os, $osrev, $mfg, $mdl, $type, $hname) = split (/\s+/, $hosttype); 
    if ($os) {
       if ($hname !~ /\w+/) {
          ($os, $osrev, $mdl, $type, $hname) = split (/\s+/, $hosttype);
       }
    }

    $nb_jobid_stat = "";
    if (defined $ENV{__NB_JOBID}) {
       $nb_jobid_stat = $ENV{__NB_JOBID};
    }

    if ((($main::sim eq "bat") || ($main::sim eq "no")) && ($main::statfile ne "")) {
	open(STATFILE, ">$main::statfile");
	print STATFILE "$stat $hname $nb_jobid_stat";
	close(STATFILE);
	print "$main::RUNCMD:### STATUS REPORT:  $stat\n";
    }
    return();
}

sub fatal {
    $error = shift (@_);
    print "$main::RUNCMD:  $error\n";
    &status("$error");
    print "$main::RUNCMD:  Quitting.\n";
    exit (-1);
}


sub findYoungestFile {
    my $dir = shift (@_);
 
    my @files = ();
    my $modified = -1;
    my $checkfile = ""; 
    find(sub {
        my $m = -M $File::Find::name;
    
        if ($m == $modified) {
            $checkfile = $File::Find::name;
	    if (-f $checkfile) {
	        push @files, $checkfile;
	    }
        } elsif ($modified == -1 || $m < $modified) {
            $checkfile = $File::Find::name;
            if (-f $checkfile) {
        	@files = $checkfile;
        	$modified = $m;
	    }
        }
    }, $dir);
 
    return(@files);
}

sub storePlatformInfo {

   $platlogname = shift @_;

   open ENVLOG, ">${platlogname}_env.log";


   print ENVLOG "ENVIRONMENT SETUP VALUES\n";
   print ENVLOG "===========================\n";
   $rc = `env`;

   print ENVLOG "$rc";

   print ENVLOG "\n\nDISK SPACE USAGE\n";
   print ENVLOG "===========================\n";

   my $run_dir_l = `pwd`;         # get the full path of run_dir
   chomp($run_dir_l);

   if ($run_dir_l =~ /^\/afs/) {
      print ENVLOG "$RUNCMD: regress is on AFS, printing token info ...\n";
      system("tokens");
      $dfcommand = "fs lq $run_dir_l";
   }
   elsif ($os eq "hpux") {
      $dfcommand = "df -k $run_dir_l";
   }
   else {
      $dfcommand = "df $run_dir_l";
   }

   $output = `$dfcommand 2>errout`;

   open(ERR, "./errout");
   while (<ERR>) {
      if (/invalid|No\s*such\s*file/i) {           # ran fs cmd on nfs, switch to df
         if ($os eq "hpux") {
            $output = `df -k $run_dir_l`;
         }
         else {
            $output = `df $run_dir_l`;
         }
      }
   }
   close(ERR);
   system("rm errout");

   if (($output =~ /filesystem/i) && ($output =~ /AFS/i)) {    # ran df cmd on afs, switch to fs
      $output = `fs lq $run_dir_l`;
   }

   print ENVLOG "$output \n";
   $output =~ /(\d+)\s*%/;
   print ENVLOG "File system: $1% full\n";

   print ENVLOG "\n\nSYSTEM TYPE\n";
   print ENVLOG "===========================\n";

   my $sysinfo = `uname -a`;

   print ENVLOG "$sysinfo";

   close ENVLOG;

}

