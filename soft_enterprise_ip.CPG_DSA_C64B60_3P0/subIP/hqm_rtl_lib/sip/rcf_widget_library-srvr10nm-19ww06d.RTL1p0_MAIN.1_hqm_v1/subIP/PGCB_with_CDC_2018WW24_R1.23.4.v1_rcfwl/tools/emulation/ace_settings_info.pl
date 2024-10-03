#!/usr/intel/bin/perl
#
#  ace_settings_info.pl :
#     Arguments : setup file name.
#     This script executes the ace command ace -sh EMULATION.
#     The output is captured and from the output all ace -emul_* variables values are captured.
#     All variables wich have an assigned value will be written to a tcsh script to be sourced :
#     Example : 
#             #!/bin/tcsh
#             setenv EMUL_TOP cpu_lib.cpu
#             setenv EMUL_ENABLE_FILTER 1
#             setenv EMUL_CFG ace/emulation/emul_build_soc.cfg
#             setenv EMUL_FILTER Emulation
#
#     The filename of this script is ARGV[0].
#




use strict;
use Env;


my $StartTimeStamp = localtime();  # Program start

# Verbosity level definitions :
my $VERBOSE = 0;
my $ERROR = 1;
my $WARNING = 2;
my $INFO = 3;


my $debug = $WARNING; # Determines the DEBUG message level to display. printl with debug_level<= debug will be printed.



my $ace_cmd;
my @ace_response;
my $ace_response_line_cnt;

$ace_cmd = "ace -sh EMULATION";
@ace_response = `$ace_cmd`;
$ace_response_line_cnt = scalar(@ace_response);


my $setup_filename = $ARGV[0];
if (defined($setup_filename)!=1) {
   $setup_filename = "/tmp/emul_setup.tcsh";
}
open (SETUP, ">$setup_filename") || die "Could not create project file $setup_filename $!\n";
print SETUP "#!/bin/tcsh\n";

my $reponse_line_nr = 0;
while ($reponse_line_nr < $ace_response_line_cnt){
   my $line = $ace_response[$reponse_line_nr];
   chomp $line;
   $line =~ s/\e\[\d+(?>(;\d+)*)m//g;
   if ($line =~ m/\s+(-emul_\S+)\s+.*/ ){
      my $emul_id    = $line;
      my $emul_value = $line;
      $emul_id =~ s/\s+-(emul_\S+)\s+.*/$1/;
      $emul_id =~ s/(\S+)\|\S+.*/$1/;
#      $emul_value =~ s/\s+-emul_\S+\s+.+\(default\:\s+(\S+)\).*\s+.*/$1/;
      $emul_value =~ s/.*\(default:\s+(\S+)\).*/$1/;
      if (($emul_value ne $line) && ($emul_value !~ m/<.+>/ )){
         printf(STDOUT "option : $emul_id\t=> $emul_value\n");
         printf(STDOUT "\n");

         $emul_id = uc($emul_id);
         print SETUP "setenv $emul_id $emul_value\n";
         if ($emul_id eq "EMUL_MODEL"){
            print SETUP "setenv EMUL_METADATA_FILENAME M:$emul_value.ace_metadata.pl\n"
         }
      }
   }
   $reponse_line_nr++;

}

close PRJ;
