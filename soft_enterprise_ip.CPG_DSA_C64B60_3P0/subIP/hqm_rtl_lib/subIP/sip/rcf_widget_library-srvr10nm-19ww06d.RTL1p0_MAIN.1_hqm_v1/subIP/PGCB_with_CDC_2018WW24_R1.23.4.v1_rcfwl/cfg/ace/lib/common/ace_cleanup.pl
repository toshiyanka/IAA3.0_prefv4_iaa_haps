#!/usr/intel/pkgs/perl/5.8.7/bin/perl
#--------------------------------------------------------------------------------
# INTEL CONFIDENTIAL
#
# Copyright (June 2005)2 (May 2008)3 Intel Corporation All Rights Reserved. 
# The source code contained or described herein and all documents related to the
# source code ("Material") are owned by Intel Corporation or its suppliers or
# licensors. Title to the Material remains with Intel Corporation or its
# suppliers and licensors. The Material contains trade secrets and proprietary
# and confidential information of Intel or its suppliers and licensors. The
# Material is protected by worldwide copyright and trade secret laws and treaty
# provisions. No part of the Material may be used, copied, reproduced, modified,
# published, uploaded, posted, transmitted, distributed, or disclosed in any way
# without Intels prior express written permission.
#
# No license under any patent, copyright, trade secret or other intellectual
# property right is granted to or conferred upon you by disclosure or delivery
# of the Materials, either expressly, by implication, inducement, estoppel or
# otherwise. Any license under such intellectual property rights must be express
# and approved by Intel in writing.
#
#--------------------------------------------------------------------------------
#--------------------------------------------------------------------------------
# $Author: vromaso $
# $Date: 2011/02/02 02:05:38 $
# $Revision: 1.15 $
# $Source: /nfs/ace/CVS/ace/bin/ace_cleanup.pl,v $
#
# Copied from boerne
#
# cleanup.pl
#  This script takes an input configuration file which defines whether
#  to delete or zip files in the current directory.  Pass/fail status
#  is determined by the presence of a <passfile> or <failfile> file
#  in the current directory.
#
#  Type 'cleanup.pl -h' for usage information 
#
########################################################################
use strict;

# ******************************************************************************
# [DCV] OK to use Cwd:  Runtime use, Not recorded 
# ******************************************************************************
use Cwd;                 # &cwd = returns current working dir

use vars qw(%CONFIG);

### Define variables
my $scriptError = "cleanup.pl-ERROR:";
my $scriptWarning = "cleanup.pl-Warning:";
my $passfile = "postsim.pass";
my $failfile = "postsim.fail";
my $verbose;
my $cwd = &cwd;
my $patfile;
my $mode;
my $debug;
my $verbose;
my $expect_postmortem;
use Data::Dumper;


### Get command line options
if (! @ARGV) {
  &print_help;
}
while (@ARGV) {
  my $arg = shift;
  if ($arg =~ /-h/) {
    &print_help;
  }
  elsif ($arg =~ /-pp/) {
    $patfile = shift;
  }
  elsif ($arg =~ /-mode/) {
    $mode = shift;
  }
  elsif ($arg =~ /-print_sample_cfg/) {
    &print_sample_cfg;
  }
  elsif ($arg =~ /-expect_postmortem/) {
    $passfile = "postmortem.pass";
    $failfile = "postmortem.fail";    
  }
  elsif ($arg =~ /-debug/) {
    $debug = 1;
  }
}

print "$scriptWarning No config file specified, directory untouched.\n" if ($patfile eq "");

## read in config file
my $contents = "";
open (CFG, "$patfile") || die "Failed to open $patfile file!\n";
while (<CFG>) {
  $contents .= $_;
}
close(CFG);
eval $contents;
if ($@) {
  die "$scriptError BAD Syntax in file '$patfile':\n\t $@";
}

$verbose = ($CONFIG{-verbose} ==1)? 1 : $debug;

# Grab files in current working directory
opendir(CURDIR, $cwd) || die "$scriptError Unable to open and read directory for file cleanup.\n";
my @files = grep (!/^\.\.?$/, readdir(CURDIR));
closedir(CURDIR);
my $status;
if (-e "$cwd/$passfile") {
  $status = "Pass";
}
elsif (-e "$cwd/$failfile") {
  $status = "Fail";
}
elsif (-e "EXIT_CLEANUP") {
  $status = "Fail";
}
else {
  exit (0);
} 

#Verbose Data
if ($verbose) {
  print "===> Cleanup Pattern Data\n";
	print (Data::Dumper->Dump([$CONFIG{NeverTouch}], ["*CONFIG{NeverTouch}"])) ;
	print (Data::Dumper->Dump([$CONFIG{Modes}{$mode}{$status}], ["*CONFIG{Modes}{$mode}{$status}"])) ;
  print "===>\n";
}
# %link_files contains all link files and files under linked folders
my %link_files;
if ($CONFIG{-exclude_dirs_with_links} eq '1') {
# Added -maxdepth 1 to limit link search to <test run>/<tid>, so ace_cleanup 
# should not traverse directories below first level.
  for (`find . -maxdepth 1 -type l`) {
    chomp;
    my @link_data = split /\//;
    $link_files{@link_data[1]} = 1;
  }
}


my @task_order = (@{$CONFIG{-task_order}}[0] =~ /\S+/)
                            ? @{$CONFIG{-task_order}} 
                            : qw(DoNotTouch GZip Delete);





foreach (@files) {
  my $done = 0;
  next if ( ($link_files{$_} eq 1)and($CONFIG{-exclude_dirs_with_links} eq 1) );

  ## Never Touch (for any mode or status)
  foreach my $regex (@{ $CONFIG{NeverTouch} }) {
    if (eval $regex) {
      print "==> FILE: $_ - NEVER TOUCH, \n" if ($verbose) ;
      $done = 1;
      last;
    }
  }
  foreach my $task (@task_order){
     unless ($done) {
        $done = &{ \&$task } ($_,  @{ $CONFIG{Modes}{$mode}{$status}{$task} });
        print "==> FILE: $_ - $task\n" if ($done and $verbose) ;
     }
  }
  print "==> FILE: $_ - NO PATTERN\n" if (! $done and $verbose) ;
}

sub DoNotTouch {
  my ($file, @regexp_arr) = @_;
  foreach my $regex (@regexp_arr) {
    if (eval $regex) {
      return 1
    }
  }
}

sub Delete {
  my ($file, @regexp_arr) = @_;
    foreach my $regex (@regexp_arr) {
      if (eval $regex) {
	if($file =~ /perl_coverage/) {
	  print "==> FILE: $file - Ignoring perl coverage directories ...\n";
    return 1
	}
	elsif($file =~ /vnavigator/) {
	  print "==> FILE: $file - Ignoring vnavigator directories ...\n";
    return 1
	}
	else {
          system("rm -rf $file");
	}
        return 1
      }
    }
}

sub GZip {
  my ($file, @regexp_arr) = @_;
    foreach my $regex (@regexp_arr) {
      if (eval $regex) {
        my $zip_cmd =  ($CONFIG{-zip_cmd} =~ /\S+/)
                            ? $CONFIG{-zip_cmd}
                            : "gzip -rf --best $file";
        $zip_cmd =~ s/\$file/$file/g;
        system("$zip_cmd");
        return 1;
      }
    }
}

sub print_help {
  print <<EOF;
   
 Usage: $0 -cfg <cfgfile>
    Optional:
    -h                 Print this help
    -pp <pattern file> Use this pattern file to determine how to clean up
    -mode <mode>       Use this <mode> from within the <pattern file>
    -print_sample_cfg  Print a sample config file to STDOUT
 
EOF
exit;
}

sub print_sample_cfg {
  print <<EOF;
# -*-perl-*- for Emacs
{
################################################################################
# Note: All regular expressions must be placed with single quotes '/example/i' 
#  instead of double quotes "/example/i"
################################################################################
%CONFIG = (

   ## Optional: -exclude_dirs_with_links will exclude all files/directories with links
   #-exclude_dirs_with_links => "1",
   
   ## Optional: -task_order changes the execution order for 'Gzip', 'Delete' and 'DoNotTouch' functions.
   #-task_order => ['DoNotTouch', 'Delete', 'Gzip',  ],
  
   ## Optional: -verbose cause verbose data to be printed out
   # -verbose => 1,  

   ## Optional: specify zip command to use (gzip, bzip2). The \\\$file is ace_cleanup.pl perl variable for file name.
   # -zip_cmd => "find \\\$file -type f | xargs bzip2 -f ",
 
   ## No files matching this list of regular expression are ever touched 
   ##  regardless of mode or status
   NeverTouch => [
                 '/postsim\\\.(log|pass|fail)/',
                 ],

   Modes => {
   
      ## This mode is intended to be used for interactive and command line jobs
      "local" => {
         ## Following is true for passing tests (postsim.pass present)
         Pass => {
            ## The lists have the following precedence: DoNotTouch, GZip, Delete
            DoNotTouch => [
                          '/.mcov\$/',
                          ],
            GZip       => [
                          '/.*/',  ## everything else
                          ],          
            Delete     => [
                          ],        
            },      

         ## Following is true for failing tests (postsim.fail present)
         Fail => {
            DoNotTouch => [
                          '/.mcov\$/',
                          ],
            GZip       => [
                          ],
            Delete     => [
                          ],                   
            },
         },
         
      ## This mode is intended for netbatch jobs
      "batch" => {
         ## Following is true for passing tests (postsim.pass present)
         Pass => {
            ## The lists have the following precedence: DoNotTouch, GZip, Delete
            DoNotTouch => [
                          '/.mcov\$/',
                          ],
            GZip       => [
                          ],          
            Delete     => [
                          '/.*/',  ## everything else
                          ],        
            },      

         ## Following is true for failing tests (postsim.fail present)
         Fail => {
            DoNotTouch => [
                          '/.mcov\$/',
                          ],
            GZip       => [
                          '/.out\$/',
                          '/log\$/',
                          ],
            Delete     => [
                          ],                   
            },
         },
      },
      
   );
};
EOF
exit;
} 

##############################################################################
# Revision 1.3  2005/01/11 22:04:51  erendon
# not zipping mcov files
#
# Revision 1.2  2004/11/29 20:32:16  akona
# import_1.2_init
#
# Revision 1.1.1.1  2004/11/29 20:31:54  akona
# "import from A0 a0v21_02 plus current"
#
# Revision 1.2  2003/05/16 19:48:49  jazuhn
# cleanup script modified to take a new argument -mode so that only a single
# config file has to be specified (since the entire path to the config file
# must be given.)
#
# Revision 1.1  2003/05/16 15:48:40  jazuhn
# Initial checkin of common cleanup script.
#
