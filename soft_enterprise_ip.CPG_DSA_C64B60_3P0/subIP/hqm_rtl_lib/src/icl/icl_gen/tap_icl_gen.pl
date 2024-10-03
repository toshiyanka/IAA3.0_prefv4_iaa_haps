#!/usr/intel/pkgs/perl/5.14.1/bin/perl

#//------------------------------------------------------------------------------
#//  INTEL CONFIDENTIAL
#//
#//  Copyright 2020 Intel Corporation All Rights Reserved.
#//
#//  The source code contained or described herein and all documents related
#//  to the source code (Material) are owned by Intel Corporation or its
#//  suppliers or licensors. Title to the Material remains with Intel
#//  Corporation or its suppliers and licensors. The Material contains trade
#//  secrets and proprietary and confidential information of Intel or its
#//  suppliers and licensors. The Material is protected by worldwide copyright
#//  and trade secret laws and treaty provisions. No part of the Material may
#//  be used, copied, reproduced, modified, published, uploaded, posted,
#//  transmitted, distributed, or disclosed in any way without Intel's prior
#//  express written permission.
#//
#//  No license under any patent, copyright, trade secret or other intellectual
#//  property right is granted to or conferred upon you by disclosure or
#//  delivery of the Materials, either expressly, by implication, inducement,
#//  estoppel or otherwise. Any license under such intellectual property rights
#//  must be express and approved by Intel in writing.
#//
#//  Collateral Description:
#//  DTEG DUVE-M (TAP RDL2ICL)
#//
#//  Source organization:
#//  DTEG Engineering Group (DTEG)
#//
#//  Support Information:
#//  HSD: https://hsdes.intel.com/appstore/article/#/dft_services.bugeco/create
#//
#//  Revision:
#//  DUVE_M_2021WW05_R1.0
#//
#//  tap_icl_gen.pl : script to convert TAP RDL to ICL (IEEE 1687)
#//
#//------------------------------------------------------------------------------
#//----------------------------------------------------------------------
#// Intel Proprietary -- Copyright 2020 Intel -- All rights reserved
#//----------------------------------------------------------------------
#//
#//    FILENAME    : tap_icl_gen.pl
#//    DESIGNER    : Igor V Molchanov
#//    PROJECT     : DUVE-M
#//
#//    PURPOSE     : generate ICL from the provided TAP RDL
#//    DESCRIPTION : 
#
# Usage: tap_icl_gen.pl [-debug <level>] [-I <path>] -rdl <rdlfile> -type <comp_type> -name <comp_name> -inst <inst_name>
#
# Options:
#     -input   <rdlfile> Process from <infile.rdl>, default is stdin
#     -type  <rdl_type>  RDL component type to extract: addrmap|regfile|reg|field
#     -name  <comp_name> RDL component name to extract
#     -inst  <inst_name> RDL instance name to extract (in the specified component)
#     -rdl               Generate RDL (case insensitive)
#     -icl               Generate ICL (case insensitive)
#     -hdr   <iclfile>   ICL header file which defines top level module name, ports, etc
#     -arch   <value>    TAP netwrork architecture (hierarchical/taplink/universal)
#     -prefix  <value>   ICL only: uniquification prefix
#     -suffix  <value>   ICL only: uniquification suffix
#     -delimiter <value> ICL only: delimiter to assemble "unique" definition names
#     -I     <path>      Search path for `include RDL files
#     -U     <path>      Search path for `include UDP file
#     -mode  <mode>      'pp' - RDL preprocessing only 
#                        'icl_pp' - ICL header file preprocess only and save to specified output file (*.icl.pp by default)
#     -param     "NAME=VALUE"    User-specified RDL parameter override; Use multiple times as needed
#                                 e.g. -param "STF_PID_SIZE=12" -param "STF_NUM_OF_PAIRS=4"
#     -icl_param <name>           User-specified RDL parameter which should be kept as a parameter in ICL; Use multiple times as needed
#                                 Only parameters for register field width are supported.
#     -nocomments|comments      delete RDL comments (default) | keep RDL comments (for 'pp' mode only)
#     -out_dir   NAME           Directory name for the generated output files
#     -out_file  NAME           Base file name (no extension) for the generated collateral
#     -log       FILE           Output log file name
#     -debug     LEVEL          Enabling of detailed log file
#                                  - LEVEL = 1 or 2
#      -ignore|noignore          Ignore some errors if ignore specified (noignore - default)
#
### =================================================================

use strict;
use warnings;
use feature qw/say state/;
 
use File::Basename;
use Getopt::Long;
use Data::Dumper;
use Storable 'dclone';
#use bignum;
#use Math::BigInt lib => 'Calc';
#use Math::BigInt lib => 'GMP';

use lib "/usr/intel/pkgs/perl/5.14.1/lib64/module/r3";
#use Capture::Tiny qw/capture_stdout/;

my $gVersion = "1.0";

# Include path for any Perl modules used in the RDL
# FIXME: Should make this a command line arg
my $inclib = ".";

my $prog;
my $prog_dir;

# pointer to Perl executable
my $gPerlCmd = "/usr/bin/perl -w -I$inclib";
my $gEchoCmd = "cat -u";

my $gUdpFilePath = '';
my $gUdpFileName = '';
my $gOutDir      = 'output';
my $gOutName     = '';
my $gDesignType  = 'unknown';
my $gOutRdl      = 0;
my $gOutIcl      = 1;
my $text_indent  = '   ';

# overall tool invocations
my $registry = system("/usr/intel/bin/dts_register -tool=TAP_ICL_GEN -version=$gVersion");
# RDL2ICL invocations
$registry = system("/usr/intel/bin/dts_register -tool=TAP_ICL_GEN -version=$gVersion -feature=RDL2ICL");

# program name 
chop ($prog = `basename $0`);

if ( -l __FILE__ ) {
   $prog_dir = dirname(readlink(__FILE__));
} else {
   $prog_dir = dirname(__FILE__);
}

# print usage string and exit
sub Usage
{
# current implementation uses negation
#         -comments 0|1       0 = delete RDL comments (default), 1 = keep RDL comments
    print STDERR <<_END_USAGE_;
    
    Usage: $prog [-rdl <file.rdl>][ -type <addrmap|regfile|reg|field>][ -name <def_name>][ -I <path>][ -U <path>][ -mode <mode>][ -debug 1|2]

    Options:
         -input     FILE           RDL file name (read from STDIN, if unspecified)
         -type      TYPE           RDL definition type to extract, one of addrmap|regfile|reg|field
         -name      NAME           RDL definition name to extract, no upper level overrides applied
         -inst      NAME           RDL instance to extract in the specified definition, including overrides if exist
         -rdl                      Generate RDL output (case insensitive)
         -icl                      Generate ICL output (case insensitive)
         -hdr       FILE           ICL header file which defines top module names, ports/scaninterfaces, etc
         -arch      VALUE          ICL only: TAP network architecture (hierarchical/default/, taplink, universal)
         -prefix    VALUE          ICL only: uniquification prefix
         -suffix    VALUE          ICL only: uniquification suffix
         -delimiter VALUE          ICL only: uniquification delimiter
         -I         PATH           Colon-separated search path for included RDL files 
         -U         PATH           RDL UDP file search path (current folder first then \$NEBULON_DIR if unspecified)
                                     Can be specified as a single colon-serapated list or
                                     using the -I switch multiple times
                                     e.g. -I path1:path2:path3 -I path4 -I path5:path6
         -mode      MODE           Reader modes:
                                     'pp' - RDL preprocess only and save to specified output file (*.rdl.pp by default)
                                     'icl_pp' - ICL header file preprocess only and save to specified output file (*.icl.pp by default)
                                     'qc' - quality checking only
         -param     "NAME=VALUE"     User-specified RDL parameter override; Use multiple times as needed
                                     e.g. -param "STF_PID_SIZE=12" -param "STF_NUM_OF_PAIRS=4"
         -icl_param  NAME            User-specified RDL parameter which should be kept as a parameter in ICL; Use multiple times as needed
                                     Only parameters for register field width are supported.
         -nocomments|comments      delete RDL comments (default) | keep RDL comments (for 'pp' mode only)
         -out_dir   NAME           Directory name for the generated output files
         -out_file  NAME           Base file name (no extension) for the generated collateral
         -log       FILE           Output log file name
         -debug     LEVEL          Enabling of detailed log file
                                     - LEVEL = 1 or 2
         -ignore|noignore          Ignore some errors if ignore specified (noignore - default)

    Example:
        # read from specified file
        $prog -inp cltap.rdl -type reg -name TAP_IR

        # TAP RDL to ICL translation
        $prog -inp ip.rdl  -icl -hdr top_hdr.icl -pre ip -suf v1

        # process from STDIN
        cat cltap.rdl | $prog

_END_USAGE_

    exit( 1 );
}

my $gRdlFile        = '-';      # default: read from STDIN
my $gIclHdrFile     = '';       # default: no file
my $gRdlCompType    = '';       # default: not defined
my $gRdlCompName    = '';       # default: not defined
my $gRdlInstName    = '';       # default: not defined
my $gMode           = '';       # default: not defined
my @gRdlSearchPaths = ('.');    # default: no RDL search path
my %gRtlParams      = ();       # default: no RTL params
my @gIclParams      = ();       # default: no RTL params
my $gKeepComments   = 0;        # default: delete RDL comments
my $gDebugFlag      = 0;        # default: no debug messages
my $gIgnoreErrors   = 0;        # default: not ignoring critical errors
my $gUniq_Prefix    = '';       # default: empty
my $gUniq_Suffix    = '';       # default: empty
my $gUniq_Delimiter = '_';      # default: '_'
my $gTapArch        = 'hier';       # default: empty
GetOptions (
    "input|file=s"  => \$gRdlFile,
    "hdr=s"       => \$gIclHdrFile,
    "type=s"      => \$gRdlCompType,
    "name=s"      => \$gRdlCompName,
    "inst=s"      => \$gRdlInstName,
    "arch=s"      => \$gTapArch,
    "rdl!"        => \$gOutRdl,
    "icl!"        => \$gOutIcl,
    "prefix=s"    => \$gUniq_Prefix,
    "suffix=s"    => \$gUniq_Suffix,
    "delimiter=s" => \$gUniq_Delimiter,
    "U=s"         => \$gUdpFilePath,
    "I=s"         => \@gRdlSearchPaths,
    "out_dir=s"   => \$gOutDir,
    "out_file=s"  => \$gOutName,
    "mode=s"      => \$gMode,
    "param=s"     => \%gRtlParams,
    "icl_param=s" => \@gIclParams,
    #"comments=i"  => \$gKeepComments, # option can be or negated or use argument
    "comments!"   => \$gKeepComments,
    "debug=i"     => \$gDebugFlag,
    "ignore!"     => \$gIgnoreErrors,
    "help|man"    => sub { Usage() },
) or die "-E- Unable to parse command line options.\n";

# Collect the RDL search path, and also add the location of the RDL file
@gRdlSearchPaths = split (/:/, join (':', @gRdlSearchPaths));
push @gRdlSearchPaths, dirname($gRdlFile);

# UDP file search path
if ($gUdpFilePath eq '') {
   if (exists $ENV{'NEBULON_DIR'}) {
      $gUdpFilePath = $ENV{'NEBULON_DIR'} . "/include";
   } else {
      $gUdpFilePath = "$prog_dir/udp";
   }
}

# We also push the RDL include path into the Perl search path, in case there 
# are some .pm files that get included into the RDLs.
foreach my $path (@gRdlSearchPaths) {
    push @INC, $path;
}

if (length($gRdlCompType) && !grep( /^$gRdlCompType$/, ('addrmap','regfile','reg','field'))) {
  die "-E- Incorrect specified component type '$gRdlCompType'\n";
}

if ((length($gRdlCompType) && !length($gRdlCompName)) || 
    (!length($gRdlCompType) && length($gRdlCompName))) {
  die "-E- Both '-type' and '-name' options are required\n";
}

# Global RDL top related variables
my $gTopType = 'field';
my $gTopName = '';
my $gIclName = '';
my $gTopPath = '';
my $gTopInst = '';
my $gFoundComp = 0;
my $gFoundInst = 0;
my $gRdlTop = 0;

my $gTapLink = ( grep( /^$gTapArch/i, ('taplink','universal')));
my $gTapHier = ( grep( /^$gTapArch/i, ('hierarchical','universal')));

if ( !($gTapLink || $gTapHier)) {
   die "-E- Not supported Tap architecture '$gTapArch'\n";
}

# RDL Top mode
if (!length($gRdlCompType) && !length($gRdlCompName)) {
  $gRdlTop = 1;
}

# Other global variable
# FIXME follow naming convention
my $comp_type = "";    # current component type
my $current_path = ''; # current component path
my $address = 0;       # next available address in the current component
my %found_comps;       # cache of found instance definitions

# Databases
my %comp_db;  # definitions
my %inst_db;  # instances and overrides

my %param_comp_db; # RDL/ICL parameters comp_db
my %param_inst_db; # RDL/ICL parameters inst_db

my %icl_comp_db; # icl module definitions

my $gIclModulePath = "";

my %icl_params;                # icl parameter hash
my $icl_active_params_all = 0; # indicates delta mode for all parameters for current param_mode run
my %icl_active_params;         # icl parameter(s) for applying to current param_mode run
my $icl_active_param = "";      # current active parameter when $icl_params_params_all == 0

foreach my $param (@gIclParams) {
   if (exists $gRtlParams{$param}) {
      die "-E- Parameter $param is used in both -param and -icl_param arguments - it can be used just in one!";
   }
   $icl_params{$param} = undef;
}

# Process the RDL file
my $code = "no warnings;\nno strict;\n";
$code   .= preprocess_file($gRdlFile,0);

# Variable to capture eval (print) output
my $output_pp;
#my $out;

if ($gDebugFlag && $gMode eq "pp") { # FIXME
    print $code;
} elsif ($gMode eq "pp") {
    #open($out, ">&STDOUT") or die;
    #open ($out, '>', "perl_print_msg.txt") or die "Could not open file 'perl_print_msg.txt' $!";;
    eval $code;
    #close $out;
    ($@) and die "-E- Caught error [$@] in code\n\n";
} else {
    # FIXME replace print to STDOUT by print to HANDLE to 
    # distinguish form prints in the used .pm files
    open(my $out_file_handle, '>', \$output_pp) or die;
    my $old_file_handle = select $out_file_handle;
    # Not using STDOUT for print in eval code results
    # in HUGE performance impact!
    #open($out, '>', \$output_pp) or die;
    #open ($out, '>', "perl_print_msg.txt") or die "Could not open file 'perl_print_msg.txt' $!";;
    eval $code;
    select $old_file_handle;
    close $out_file_handle;
    #close $out;
    ($@) and die "-E- Caught error [$@] in code\n\n";
}
print "\n\n";

foreach my $param (getUnusedParams()) {
    warn "-W- Specified RTL parameter '$param = $gRtlParams{$param}' was not used in RDL!\n";
}

my $parameterized_icl = 0;
foreach my $param (@gIclParams) {
   if (!defined $icl_params{$param}) {
      warn "-W- Specified ICL parameter '$param' was not used in RDL!\n";
      delete $icl_params{$param};
   } else {
      $parameterized_icl = 1;
   }
}

exit ( 0 ) if ($gMode eq "pp");

# re-init to process by main parser code
$gUdpFileName = '';

process_rdl($output_pp,0);

if ($parameterized_icl) {
   print "-I- Processing RDL based on requested ICL parameters\n";
   $icl_active_params_all = 0;
   my @param_list = keys %icl_params;
   foreach my $param (@param_list) {
      print "-I-  > ICL parameter: $param\n";
      %icl_active_params = ();
      $icl_active_params{$param} = 1;
      $icl_active_param = $param;
      $code = "no warnings;\nno strict;\n";
      # FIXME eliminate re-reading of RDL (if critical)
      $code   .= preprocess_file($gRdlFile,$parameterized_icl);
      open(my $out_file_handle, '>', \$output_pp) or die;
      my $old_file_handle = select $out_file_handle;
      eval $code;
      select $old_file_handle;
      close $out_file_handle;
      ($@) and die "-E- [param_mode] Caught error [$@] in code\n\n";
      process_rdl($output_pp,$parameterized_icl);
   }
   if (scalar(@param_list) > 1) {
      # Applying delta to all parameters simultaneously
      $icl_active_params_all = 1;
      $icl_active_param = "all";
      %icl_active_params = ();
      foreach my $param (keys %icl_params) {
         $icl_active_params{$param} = 1;
      }
      print "-I-  > All parameters simultaneously\n";
      $code = "no warnings;\nno strict;\n";
      # FIXME eliminate re-reading of RDL (if critical)
      $code   .= preprocess_file($gRdlFile,$parameterized_icl);
      open(my $out_file_handle, '>', \$output_pp) or die;
      my $old_file_handle = select $out_file_handle;
      eval $code;
      select $old_file_handle;
      close $out_file_handle;
      ($@) and die "-E- [param_mode] Caught error [$@] in code\n\n";
      process_rdl($output_pp,$parameterized_icl);
   }
}

# FIXME # For Ravishankar ->
# FIXME # Start Front-End processing here

if (!$gFoundComp) {
   $gTopPath = find_top();
   $gTopName = $comp_db{$gTopPath}{name};
}
print "-I- Design type: $gDesignType, Design Top: $gTopType $gTopName (path '$gTopPath')\n";

if (length($gRdlInstName)) {
   my $ipath = "$gTopPath.$gRdlInstName";
   die "-E- Specified instance '$gRdlInstName' doesn't exist in component '$gTopName'\n" if (!exists $inst_db{$ipath});
   $gTopInst = $ipath;
   print "-I- RDL instance to extract: '$gTopInst'\n";
}

# This method is expected to be run before RDL writer
check_all_fields();

if ($gDebugFlag && ($gMode eq "icl_pp")) {
   print "\n###### DEBUG: COMPONENTS #####\n";
   print Dumper (\%comp_db);
   print "\n###### DEBUG: INSTANCES #####\n";
   print Dumper (\%inst_db);
   print "\n###### DEBUG: ICL PARAMETERS #####\n";
   print Dumper (\%icl_params);
   print "\n###### DEBUG: PARAMETERIZED INSTANCES #####\n";
   print Dumper (\%param_inst_db);
   #print "###### FOUND COMPONENTS#####\n";
   #print Dumper (\%found_comps);
   #print "###### UDP hash #####\n";
   #print print_udp_hash();
}

my $use_hdr_file = ($gIclHdrFile ne "");
my $icl_code = "";
if ($use_hdr_file) {
   $icl_code .= preprocess_icl($gIclHdrFile);
   if ($gDebugFlag && $gMode eq "icl_pp") {
      print $icl_code;
   }
   exit ( 0 ) if ($gMode eq "icl_pp");
   $current_path = '';
   process_icl($icl_code);
}

my %included_files;     # to track which include files were created already
my %included_defs;      # to track which addrmap/reg definitions were printed out to the included file

my %ovrd_hash;
my %id_cnt_hash;
my %def_mi_hash;
my %def_mi_hash_tmp;
my %printed_non_mi_defs_hash;

unless(-e $gOutDir or mkdir($gOutDir,0750)) {
   die "-E- Unable to create $gOutDir\n";
}

my $add_prefix = ($gUniq_Prefix ne "");
my $add_suffix = ($gUniq_Suffix ne "");

my $ofile;

if ($gOutIcl) {

   my $new_top_name = $gIclName;

   my $out_file_name = ($gOutName eq "") ? "$gOutDir/${new_top_name}.icl" : "$gOutDir/${gOutName}.icl";
   open ($ofile, '>', $out_file_name) or die "Can't create '$out_file_name': $!";

   # FIXME? No uniquification of top level module!
   $new_top_name = icl_add_prefix_suffix($new_top_name);

   icl_map_interfaces() if ($use_hdr_file);
   icl_process_params();

   if ($gDebugFlag) {
      print "\n###### DEBUG: COMPONENTS - FINAL #####\n";
      print Dumper (\%comp_db);
      print "\n###### DEBUG: INSTANCES - FINAL #####\n";
      print Dumper (\%inst_db);
      print ("###### DEBUG: ICL Comp DB #####\n");
      print Dumper (\%icl_comp_db);
      print "\n###### DEBUG: ICL PARAMETERS #####\n";
      print Dumper (\%icl_params);
      #print "\n###### DEBUG: PARAMETERIZED COMPONENTS #####\n";
      #print Dumper (\%param_comp_db);
      print "\n###### DEBUG: PARAMETERIZED INSTANCES #####\n";
      print Dumper (\%param_inst_db);
   }

   icl_print_top($gTopPath, "", $ofile, $gTopName, $new_top_name);
   close ($ofile);

   if ($gDebugFlag) {
      print "\n###### DEBUG: PARAMETERIZED COMPONENTS #####\n";
      print Dumper (\%param_comp_db);
   }

}
if ($gOutRdl) {

   my $new_top_name = $gTopName;
   $new_top_name = icl_add_prefix_suffix($new_top_name);

   my $out_file_name = ($gOutName eq "") ? "$gOutDir/${new_top_name}.rdl" : "$gOutDir/${gOutName}.rdl";
   open ($ofile, '>', $out_file_name) or die "Can't create '$out_file_name': $!";

   # use "" prefix for top inst path
   print_comp($gTopPath, "", $ofile, $gTopName,0,0);
   close ($ofile);
}

# Print warning if any unused property overrides
print_unused_overrides();

exit( 0 );

### =================================================================
### Pre-process the provided icl file

sub preprocess_icl
{
   my $file   = shift @_;
   my $lineno = 0;
   my $output = '';

   open(my $fh, $file) or die "Can't read '$file': $!";
       my $input = do { local $/; <$fh> }; # slurp whole file
   close($fh);

   # remove \r and all single-/multi-line comments
   # reformat RDL to simplify processing
   # FIXME \r can also terminate single line comments
   $input =~ s/\r//g;
   $input = remove_icl_comments($input,0) unless ($gKeepComments && $gMode eq "icl_pp");

   #return $output;
   return $input;
}

### Pre-process the provided txt file ($file == '-' is STDIN)

# RDL lines can have embedded Perl between <% and %>
# * Perl variable:
#   CHAIN<%=$chain_num%>_EN [<%=$lsb%>:<%=$lsb++%>] = 1'h0;
#
# * Single line code: 
#   <% my $lsb = 0;%>
#
# * Multi-line code:
#   <%
#     if ($TAP_UDP) {
#     } else {
#       $TAP_UDP = 1;
#     }
#   %>

sub preprocess_file
{
   my $file         = shift;
   my $param_mode   = shift;

   my $lineno = 0;
   my $output = '';

   open(my $fh, $file) or die "Can't read '$file': $!";
       my $input = do { local $/; <$fh> }; # slurp whole file
   close($fh);

   # remove \r and all single-/multi-line comments
   # reformat RDL to simplify processing
   # FIXME \r can also terminate single line comments
   $input =~ s/\r//g;
   $input = remove_comments($input,0) unless ($gKeepComments && $gMode eq "pp");

   while ($input =~ /(.*?)<%/sgc) {
      # process any RDL lines before the first/next <%
      $output  .= verilog_pp($1,$param_mode) if length($1);

      # process the Perl code between <% ... %>
      # keep \n as a part of the processed text
      $input   =~ /(.*?)%>/sgc or die "couldn't find %>";
      my $code = $1;
      # support of <%=<expression>;%>
      #$code    =~ s/^=([^;]+)(.*)/print \$out ($1);/;   # print Perl variables
      $code    =~ s/^=([^;]+)(.*)/print($1);/;   # print Perl variables
      die "-E- Incorrect assignment <%=$1;$2%>" if defined $2 && $2 =~ /[^\s;]/;

      # Replace RTL parameters
      # FIXME: This allows computed parameters to be replaced as well, which shouldn't be allowed
      #        $STF_PID_SIZE    = 8;
      #        $SB_STF_PID_SIZE = $STF_PID_SIZE;
      #        $STF_SIZE_SB     = 512; 
      #        $NUMBITS_SB      = ($STF_SIZE_SB==32)?5:6;
      # Search and replace "^$var = val;"
      #                 or ";$var = val;"
      # FIXME parameter as a part of .pm file isn't supported
      # to fix that, we need to replace where the parameter is used
      #$output  =~ s/(?<=[^;])\s*\$([a-zA-Z]\w*)\s*=\s*([^\s;]+)\s*;/"\$$1 = ".getParamValue($1,$2).";"/sge;
      $code  =~ s/\$([a-zA-Z]\w*)\s*=(?!=)([^;]+);/"\$$1 = ".getParamValue($param_mode,$1,$2).";"/sge;
      $output .= "$code";
   }

   # process any RDL lines after the last %>
   # pos($var): offset of where the last "m//g" search for $var ended
   my $str  = substr $input, pos($input) // 0;
   $output .= verilog_pp($str,$param_mode) if length($str);

   return $output;
}

# verilog_pp: Processes a chunk of RDL lines (no embedded Perl!)
# Handles Verilog directives.
# - Supported:
#     `include "file_name"
#
# - Not supported:
#   `define macro_name [ (argument, ...) ] text
#   `undef macro_name
#   `ifdef macro_name | `ifndef macro_name
#     verilog_code
#   [ `elsif macro_name
#     verilog_code ]
#   [ `else
#     verilog_code ]
#   `endif
sub verilog_pp
{
    # supporting \n in the beginning and in the end of the input string
    my $str = shift;
    my $param_mode = shift;

    my $first_nl = $str =~ /^\n/;
    my $last_nl = $str =~ /\n$/;
    my @lines  = split /\n/, $str;
    my $output = '';
    # careful handling of full and partial empty lines
    my $empty_line = 0;
    my $empty_line_str = 0;

    #$output .= "print \$out \"\\n\";\n" if $first_nl;
    $output .= "print \"\\n\";\n" if $first_nl;

    foreach my $line (@lines) {
        #$line =~ s/\r//sg;
        #next if ($line =~ /^\s*$/);
        if ($line =~ /^\s*$/) {
           # empty line compression
           $empty_line_str = $line;
           $empty_line = 1;
           next;
        } elsif ($empty_line) {
           #$output .= "print \$out \"\\n\";\n";
           $output .= "print \"\\n\";\n";
           $empty_line = 0;
        }

        if ($line =~ /^\s*\`include\s+\"([^\"]+?)\"/) {
            my $found = 0;
            my $file  = $1;
            if ($file =~ /_udp\.rdl/) {
              # UDP file handling
              next if $gUdpFileName eq $file;
              if ($gUdpFileName eq "") {
                 $gUdpFileName = $file;
              } else {
                 die "-E- Multiple UDP files: $gUdpFileName, $file\n\n"
              }
            } else {
              foreach my $path (@gRdlSearchPaths) {
                if (-e "$path/$file") {
                    #$output .= "print \$out \"\n// RDLPP: start include file: $path/$file\n\";\n";
                    $output .= "print \"\n// RDLPP: start include file: $path/$file\n\";\n";
                    $output .= preprocess_file ("$path/$file",$param_mode);
                    #$output .= "print \$out \"\n// RDLPP: end include file: $path/$file\n\n\";\n";
                    $output .= "print \"\n// RDLPP: end include file: $path/$file\n\n\";\n";
                    $found = 1;
                    last;
                }
              }
            }
            # Print include for not existing RDL file of for the first *_udp.rdl file
            #($found) or $output .= "print \$out \"" . escapeQuotes($line) . "\n\"\n;\n";
            ($found) or $output .= "print \"" . escapeQuotes($line) . "\n\"\n;\n";
            #($found) or die "Couldn't locate $file in search path '@gRdlSearchPaths'\n\n";
        }
        else {
            #$line .= "\n" if ($line =~ /\";/);
            #$output .= "print \"" . escapeQuotes($line) . "\n\";\n";
            #$output .= "print \$out \"" . escapeQuotes(escapeSpecial($line)) . "\\n\";\n";
            $output .= "print \"" . escapeQuotes(escapeSpecial($line)) . "\\n\";\n";
        }
    }

    if ($empty_line) {
       #$output .= "print \$out \"" . $empty_line_str . "\";\n";
       $output .= "print \"" . $empty_line_str . "\";\n";
    }

    # Remove the final \n so that the output doesn't look weird
    # i.e. change:
    #    field_RW foo [
    #    26];
    # to:
    #    field_RW foo [26];
    $output =~ s/\\n\";\n$/\";\n/ if not $last_nl;
    return $output;
}

### =================================================================

# Simple quoting of strings
sub perlstr { 
    return Data::Dumper->new([''.shift])->Terse(1)->Indent(0)->Useqq(1)->Dump 
}

sub escapeQuotes
{
    my $str = shift;
    $str =~ s/\"/\\\"/g;
    return $str;
}

sub escapeSpecial
{
    my $str = shift;
    $str =~ s/\\/\\\\/g;
    $str =~ s/\@/\\\@/g;
    return $str;
}

### =================================================================

# RTL parameter handling
{
    my %_unused_params = ();
    
    sub _init_unused_params {
        %_unused_params = map { $_ => 1 } (keys %gRtlParams);
    }

    sub getParamValue {
        my $param_mode  = shift;
        my $name  = shift;
        my $value = shift // "";

        _init_unused_params() unless (scalar %_unused_params);

        if (exists $gRtlParams{$name}) {
            $_unused_params{$name} = 0;
            return $gRtlParams{$name};
        } elsif (exists $icl_params{$name}) {
            if ($param_mode) {
               if (exists $icl_active_params{$name}) {
                  return $icl_params{$name}{delta_1};
               } else {
                  return $icl_params{$name}{default};
               }
            } else {
               my $num_value = $value;
               $num_value =~ s/\s//g;
               $icl_params{$name} = {};
               # convert oct/hex/bin Perl number to decimal
               if ($num_value =~ /^0(\d+|x[0-9a-fA-F]+|b[01]+)$/) {
                  my $num_value_tmp = oct($num_value);
                  $icl_params{$name}{default} = $num_value_tmp;
                  $icl_params{$name}{delta_1} = $num_value_tmp + 1;
               } elsif ($num_value =~ /^-?\d+$/) {
                  $icl_params{$name}{default} = $num_value + 0;
                  $icl_params{$name}{delta_1} = $num_value + 1;
               } else {
                  die "-E- ICL parameter $name doesn't look like Perl integer number in RDL ($value)\n";
               }
            }
        }
        return $value;
    }

    sub getUnusedParams {
        return (grep { $_unused_params{$_} == 1 } (keys %_unused_params));
    }
}

### =================================================================
### Process the provided ICL file
### Not supported:
### TBD

sub process_icl
{
   my $input      = shift;

   print ("-I- Processing ICL header file...\n");

   # remove \r and all single-/multi-line comments
   # reformat RDL to simplify processing
   $input =~ s/\r//g;
   #my $code = remove_comments($input,0);

   my @lines  = split /\n/, $input;

   my $multi_line_string = 0;
   my $inst_attr_path  = '';
   my $attr_name  = '';

   my $inside_block  = 0;
   my $block_type    = '';
   my $block_subtype = '';
   my $block_name    = '';
   my $block_str    = '';

   # all comments are removed already
   # simplifying regex based on known rdl_formatting
   foreach my $line (@lines) {

      if ($multi_line_string) {
         if ($line =~ /(.*?)(?!\\)\"\s*;/) { # " marks the end of multi-line string 
            $multi_line_string = 0;
         } else {
         }
      } elsif ($inside_block) {
         if ($line =~ /(.*?)}/) { # } marks the end of multi-line block
            $block_str .= $1;
            icl_process_block($block_type,$block_subtype,$block_name,$block_str);
            $inside_block = 0;
            $block_type = '';
            $block_subtype = '';
            $block_str = '';
        } else {
            $block_str .= $line;
         }
      } elsif ($line !~ /\S+/) {
         # empty line
      } elsif ($line =~ /^\s*}\s*/) {

      } elsif ($line =~ /^\s*Module\s+(\w+)\s+{(.*)/) {
         ####################################
         # new definition scope, $1 - type, $3 - name, $2 - escaped
         my $comp_name = $1;
         print ("-I- Found ICL module '$comp_name'\n");
         if ($comp_name ne $gTopName) {
           warn "-W- Mismatch between RDL definition name and module name in ICL header file - using $comp_name from the ICL file (RDL name: $gTopName)\n";
         }
         $current_path = icl_create_comp($comp_name,$current_path);
         $gIclName = $comp_name;

      } elsif ($line =~ /^\s*(\w+)Port\s+(.*);/) {
         ##########################################################
         if ($1 eq "Input") {next;}
         $block_type = "port";
         $block_subtype = $1;
         $block_subtype .= "Port";
         $block_name = $2;
         $block_name =~ s/\s+//g;
         #print ("-I- New ICL Port $block_subtype : $block_name\n");
         $icl_comp_db{$current_path}{port}{$block_subtype}{$block_name} = {};
         my $sig_width = 1;
         if ($block_name =~ /\[\s*(\d+)\s*:\s*(\d+)/) {
            $sig_width = abs($1 - $2 + 1);
         }
         $icl_comp_db{$current_path}{port}{$block_subtype}{$block_name}{width} = $sig_width;

      } elsif ($line =~ /^\s*(\w+)Port\s+(.*){/) {
         ##########################################################
         if ($1 eq "Input") {next;}
         $inside_block = 1;
         $block_type = "port";
         $block_subtype = $1;
         $block_subtype .= "Port";
         $block_name = $2;
         $block_name =~ s/\s+//g;
         #print ("-I- New ICL Port $block_subtype : $block_name\n");
         $icl_comp_db{$current_path}{port}{$block_subtype}{$block_name} = {};
         my $sig_width = 1;
         if ($block_name =~ /\[\s*(\d+)\s*:\s*(\d+)/) {
            $sig_width = abs($1 - $2 + 1);
         }
         $icl_comp_db{$current_path}{port}{$block_subtype}{$block_name}{width} = $sig_width;

      } elsif ($line =~ /^\s*ScanInterface\s+(\w+)\s*{/) {
         ##########################################################
         $inside_block = 1;
         $block_name = $1;
         $block_type = "interface";
         $block_subtype = '';
         #print ("-I- New ICL ScanInterface $block_name\n");
         $icl_comp_db{$current_path}{interface}{$block_name}{ports} = {};

      } elsif ($line =~ /^\s*Enum\s+(\w+)\s*{/) {
         ##########################################################
         $inside_block = 1;
         $block_name = $1;
         $block_type = "enum";
         $block_subtype = '';
         #print ("-I- New ICL ScanInterface $block_name\n");
         $icl_comp_db{$current_path}{enum}{$block_name} = {};

      } else {

         #die "-E- Not recognized/not supported construct: $line\n";
      }

      #$line_cnt++;
   }
}

sub icl_process_block
{
   my $block_type = shift;
   my $block_subtype = shift;
   my $block_name = shift;
   my $code = shift;
   
   $code =~ s/\n//g;
   $code =~ s/\r//g;
   my @lines  = split /;/, $code;

   my $is_port = ($block_type eq "port");
   my $is_interface = ($block_type eq "interface");
   my $is_enum = ($block_type eq "enum");

   foreach my $line (@lines) {
      if ($line =~ /^\s*Attribute\s+(\w+)\s*=\s*(.*)\s*/) {
         if ($is_port) {
            my $attr = $1;
            my $value = $2;
            $value =~ s/"//g;
            if ($attr eq "intel_signal_type") {
               $icl_comp_db{$current_path}{$block_type}{$block_subtype}{$block_name}{intel_type} = $value;
            } else {
               $icl_comp_db{$current_path}{$block_type}{$block_subtype}{$block_name}{attr}{$attr} = $value;
            }
         } else {
            die "-E- Unexpected Attribute inside $block_subtype $block_name block\n";
         }
      } elsif ($is_enum && ($line =~ /^\s*(\w+)\s*=\s*(.+)/)) {
         my $id = $1;
         my $value = $2;
         if (is_icl_number($value)) {
            $icl_comp_db{$current_path}{$block_type}{$block_name}{$id} = $value;
         } else {
            die "-E- Not supported ICL number format $value in Enum definition (line: '$line')\n";
         }
      } elsif ($line =~ /^\s*(\w+)\s+(.*)/) {
         my $keyword = $1;
         my $value = $2;
         if ($value =~ /^(\"[^"]*\")(.*)$/) {
            if ($2 =~ /\S/) {
               die "-E- Unexpected string assignment in line '$line'\n";
            }
            $value = $1;
         } else {
            $value =~ s/\s+//g;
         }
         if ($is_port) {
            if (grep {/^$keyword$/} ('Source','Enable','RefEnum','DefaultLoadValue','ActivePolarity','DifferentialInvOf',
                                 'FreqMultiplier','FreqDivider','DifferentialInvOf','Period')) {
               $icl_comp_db{$current_path}{$block_type}{$block_subtype}{$block_name}{$keyword} = $value;
            } else {
               die "-E- Unexpected keyword $keyword inside $block_subtype $block_name block\n";
            }
         } elsif ($is_interface) {
            if ($keyword eq "Port") {
               $icl_comp_db{$current_path}{$block_type}{$block_name}{ports}{$value} = "";
            } else {
               die "-E- Unexpected keyword $keyword inside interface $block_name block\n";
            }
         } else {
            # TBD
         }
         
      } else {
         #Ignore for now
      }
   }
}

# icl_map_interfaces links ICL interface/port information with TAP/register data
# Assumptions
# - ScanInterface definition can exist or not
#   It is not required if specified top module has just single TAP interface
#   If don't exist, interface entry will be auto-created/populated by the script
# - Naming convention: 
#     c_<target tap/register> for client interfaces
#     h_<id> for host interfaces
#     If only single target exists, naming convention will be ignored

sub icl_map_interfaces
{
   my @icl_modules = keys %icl_comp_db;
   my $num_icl_modules = scalar(@icl_modules);

   if ($num_icl_modules > 1) {
      die "-E- ICL header file can have only one module definition!\n";
   } elsif ($num_icl_modules == 0) {
      die "-E- ICL header file has no module definition\n";
   }
   $gIclModulePath = $icl_modules[0];

   # to propagate path info, check if reg_only addrmap exists
   my $def_path = $gTopPath;
   my $reg_only_dpath = "";
   my $reg_only_inst_exists = 0;
   foreach my $inst (@{$comp_db{$def_path}{ilist}}) {
      my $ipath     = "$def_path.$inst";
      my $cpath     = $inst_db{$ipath}{cpath};
      my $comp_type = $comp_db{$cpath}{type};
      if (($comp_type eq "reg") || ($comp_type eq "regfile")) {
         last;
      } elsif ($comp_db{$cpath}{type} eq "addrmap") {
        $reg_only_inst_exists = (icl_get_attr('TapType', $cpath, ".$inst", 1, 1, 0) eq "\"reg_only\"");
        if ($reg_only_inst_exists) {
           $reg_only_dpath = $inst_db{"$def_path.$inst"}{cpath};
           last;
        }
      }
   }

   # mapping
   foreach my $port_type (keys %{$icl_comp_db{$gIclModulePath}{port}}) {
      my $is_tap_port      = (grep {/^$port_type$/} ('TMSPort','ToTMSPort'));
      my $is_scan_port     = (grep {/^$port_type$/} ('SelectPort','ShiftEnPort','ToSelectPort','ToShiftEnPort'));
      my $is_client_port   = (grep {/^$port_type$/} ('TMSPort','SelectPort','ShiftEnPort'));
      my $is_host_port     = (grep {/^$port_type$/} ('ToTMSPort',,'ToSelectPort','ToShiftEnPort'));
      my $not_scan_type    = (grep {/^$port_type$/} ('DataInPort',,'DataOutPort','ClockPort','ToClockPort','ToIRSelectPort','AddressPort','WriteEnPort','ReadEnPort'));
      my $serial_data_type = (grep {/^$port_type$/} ('ScanInPort',,'ScanOutPort'));
      my $select_type      = (grep {/^$port_type$/} ('SelectPort',,'ToSelectPort'));
      my $data_in_type     = ($port_type eq 'DataInPort');
      my $reset_type       = ($port_type eq 'ResetPort'); #'ToResetPort'
      my $data_out_type    = ($port_type eq 'DataOutPort');
      # Sanity check
      foreach my $intf (keys %{$icl_comp_db{$gIclModulePath}{interface}}) {
         foreach my $port_name (keys %{$icl_comp_db{$gIclModulePath}{interface}{$intf}{ports}}) {
            my $found = 0;
            foreach my $port_type (keys %{$icl_comp_db{$gIclModulePath}{port}}) {
               if (exists $icl_comp_db{$gIclModulePath}{port}{$port_type}{$port_name}) {
                  $found = 1;
               }
            }
            if (!$found) {
               die "-E- ICL header, ScanInterface $intf: definition of port $port_name does not exist\n";
            }
         }
      }
      foreach my $port_name (keys %{$icl_comp_db{$gIclModulePath}{port}{$port_type}}) {
         # ScanInterface mapping
         foreach my $intf (keys %{$icl_comp_db{$gIclModulePath}{interface}}) {
           if (exists $icl_comp_db{$gIclModulePath}{interface}{$intf}{ports}{$port_name}) {
              if ($not_scan_type) {
                 die "-E- ICL header, ScanInterface $intf: port $port_name of type $port_type cannot be part of ScanInterface\n";
              }
              if (exists $icl_comp_db{$gIclModulePath}{interface}{$intf}{map}{$port_type}) {
                 if (!$serial_data_type && !$select_type) {
                    my $conflicting_name = $icl_comp_db{$gIclModulePath}{interface}{$intf}{map}{$port_type};
                    die "-E- ICL header, ScanInterface $intf: port $port_name of type $port_type specified already ($conflicting_name)\n";
                 }
              } else {
                 if ($serial_data_type || $select_type) {
                    $icl_comp_db{$gIclModulePath}{interface}{$intf}{map}{$port_type} = ();
                 }
              }
              $icl_comp_db{$gIclModulePath}{interface}{$intf}{ports}{$port_name} = $port_type;
              if ($serial_data_type || $select_type) {
                 push @{$icl_comp_db{$gIclModulePath}{interface}{$intf}{map}{$port_type}}, $port_name;
              } else {
                 $icl_comp_db{$gIclModulePath}{interface}{$intf}{map}{$port_type} = $port_name;
              }
              $icl_comp_db{$gIclModulePath}{port}{$port_type}{$port_name}{intf} = $intf;
              if ($is_tap_port || $is_scan_port) {
                 if (!exists $icl_comp_db{$gIclModulePath}{interface}{$intf}{is_tap}) {
                    $icl_comp_db{$gIclModulePath}{interface}{$intf}{is_tap} = $is_tap_port;
                 } elsif ($icl_comp_db{$gIclModulePath}{interface}{$intf}{is_tap} && $is_scan_port) {
                    die "-E- ICL header, ScanInterface $intf: port $port_name of type $port_type contradicts with interface type 'TAP'\n";
                 } elsif (!$icl_comp_db{$gIclModulePath}{interface}{$intf}{is_tap} && $is_tap_port) {
                    die "-E- ICL header, ScanInterface $intf: port $port_name of type $port_type contradicts with interface type 'Scan'\n";
                 }
              }
              if ($is_client_port || $is_host_port) {
                 if (!exists $icl_comp_db{$gIclModulePath}{interface}{$intf}{is_client}) {
                    $icl_comp_db{$gIclModulePath}{interface}{$intf}{is_client} = $is_client_port;
                 } elsif ($icl_comp_db{$gIclModulePath}{interface}{$intf}{is_client} && $is_host_port) {
                    die "-E- ICL header, ScanInterface $intf: port $port_name of type $port_type contradicts with interface type 'Client'\n";
                 } elsif (!$icl_comp_db{$gIclModulePath}{interface}{$intf}{is_client} && $is_client_port) {
                    die "-E- ICL header, ScanInterface $intf: port $port_name of type $port_type contradicts with interface type 'Host'\n";
                 }
              }
           }
         } # foreach scan interface
         # try to categorize based on signal name
         my $category;
         my $sub_category;
         if ($data_in_type || $data_out_type) {
            if ($data_in_type && !exists $icl_comp_db{$gIclModulePath}{port}{$port_type}{$port_name}{intel_type}) {
               print("-I- Autocategorizing port $port_type $port_name...\n");
               if (($port_name =~ /secur.*policy/i) && ($icl_comp_db{$gIclModulePath}{port}{$port_type}{$port_name}{width} == 4)) {
                  $category = "secure_policy";
                  print("-I- Autocategorized port $port_type $port_name as '$category' signal\n");
                  $icl_comp_db{$gIclModulePath}{port}{$port_type}{$port_name}{intel_type} = $category;
               } elsif (($port_name =~ /slvid/i) && ($icl_comp_db{$gIclModulePath}{port}{$port_type}{$port_name}{width} == 32)) {
                  $category = "slvidcode";
                  print("-I- Autocategorized port $port_type $port_name as '$category' signal\n");
                  $icl_comp_db{$gIclModulePath}{port}{$port_type}{$port_name}{intel_type} = $category;
               } else {
                  print("-I- Autocategorization failed\n");
               }
            }
            if (exists $icl_comp_db{$gIclModulePath}{port}{$port_type}{$port_name}{attr}{intel_tdr_dest}) {
               my $path = $icl_comp_db{$gIclModulePath}{port}{$port_type}{$port_name}{attr}{intel_tdr_dest};
               my $port_msb = 0;
               my $port_lsb = 0;
               my $port_base = "";
               my $dest_msb = 0;
               my $dest_lsb = 0;
               my $dest_base = "";
               my $dest_range = "";
               if ($port_name =~ /(\S+)\[(\d+):(\d+)\]/) {
                  $port_base = $1;
                  $port_msb  = $2;
                  $port_lsb  = $3;
               }
               if ($path =~ /(\S+)\s*\[\s*(\d+)\s*:\s*(\d+)\s*\]/) {
                  die "-E- Data Port target cannot contain bit range ($path)\n";
                  $dest_base = $1;
                  $dest_msb  = $2;
                  $dest_lsb  = $3;
                  $dest_range  = "[$dest_msb:$dest_lsb]";
               } elsif ($path =~ /(\S+)\s*\[\s*(\d+)\s*\]/) {
                  die "-E- Data Port target cannot contain bit range ($path)\n";
                  $dest_base = $1;
                  $dest_msb  = $2;
                  $dest_lsb  = $2;
               } else {
                  $dest_base = $path;
               }
               if (!exists $icl_comp_db{$gIclModulePath}{data_ports}{$dest_base}) {
                  $icl_comp_db{$gIclModulePath}{data_ports}{$dest_base} = {};
               }
               if (!exists $icl_comp_db{$gIclModulePath}{data_ports}{$dest_base}{$port_type}) {
                  $icl_comp_db{$gIclModulePath}{data_ports}{$dest_base}{$port_type} = {};
               }
               $icl_comp_db{$gIclModulePath}{data_ports}{$dest_base}{$port_type}{$dest_range} = $port_name;
               my @inst_hier_list  = split /\./, $dest_base;
               my $hier_level = 0;
               my $inst_port_name_tmp = $dest_base;
               my $inst_port_name = "";
               my $inst_port_conn = $port_name;
               my $inst_dpath = "$def_path";
               my $current_path = "";
               my $is_found = 0;
               my $dest_port_msb = $port_msb-$port_lsb;
               my $bit_range = "[$dest_port_msb:0]";
               foreach my $sub_path (@inst_hier_list) {
                  $current_path .= ($hier_level) ? ".$sub_path" : "$sub_path" ;
                  if ($inst_port_name_tmp =~ /\w+\.(.*)/) {
                     $inst_port_name_tmp = $1;
                     ($inst_port_name = $inst_port_name_tmp) =~ s/\./__/g;
                  } else {
                     $inst_port_name = "";
                     $inst_port_name_tmp = "";
                  }
                  my $ipath = "";
                  if (exists $inst_db{"$inst_dpath.$sub_path"}) {
                     $ipath = "$inst_dpath.$sub_path";
                  } elsif ($reg_only_inst_exists && !$hier_level &&
                     exists $inst_db{"$reg_only_dpath.$sub_path"}) {
                     $comp_db{$reg_only_dpath}{$port_type}{$port_name} = {};
                     $comp_db{$reg_only_dpath}{$port_type}{$port_name}{dest} = $sub_path;
                     $comp_db{$reg_only_dpath}{$port_type}{$port_name}{name} = $port_name;
                     $comp_db{$reg_only_dpath}{$port_type}{$port_name}{conn} = $inst_port_name;
                     $ipath = "$reg_only_dpath.$sub_path";
                  } else {
                    warn "-W- Interface mapping: cannot find target instance '$current_path' for $port_type $port_name (full target path '$dest_base')\n";
                    $is_found = 0;
                    last;
                  }
                  if ($hier_level) {
                     $comp_db{$inst_dpath}{$port_type}{$port_name}{dest} = $sub_path;
                     $comp_db{$inst_dpath}{$port_type}{$port_name}{conn} = $inst_port_name;
                  }
                  $is_found = 1;
                  if (!exists $inst_db{$ipath}{$port_type}) {
                     $inst_db{$ipath}{$port_type} = {};
                  }
                  $inst_db{$ipath}{$port_type}{$port_name} = {};
                  $inst_db{$ipath}{$port_type}{$port_name}{name} = $inst_port_name;
                  $inst_db{$ipath}{$port_type}{$port_name}{conn} = $inst_port_conn;
                  $inst_dpath = $inst_db{$ipath}{cpath};
                  if (!exists $comp_db{$inst_dpath}{$port_type}) {
                     $comp_db{$inst_dpath}{$port_type} = {};
                  }
                  if (!exists $comp_db{$inst_dpath}{$port_type}{$port_name}) {
                     $comp_db{$inst_dpath}{$port_type}{$port_name} = {};
                  }
                  $comp_db{$inst_dpath}{$port_type}{$port_name}{name} = $inst_port_name . $bit_range;
                  $comp_db{$inst_dpath}{$port_type}{$port_name}{dest} = "";
                  $inst_port_conn = $inst_port_name;
                  $hier_level++;
               }
               if ($is_found) {
                  $icl_comp_db{$gIclModulePath}{port}{$port_type}{$port_name}{assigned_to} = "$dest_base";
               }
            }
         }

         if ($reset_type) {
            my $active_polarity = 1;
            if (exists $icl_comp_db{$gIclModulePath}{port}{$port_type}{$port_name}{ActivePolarity}) {
               my $polarity = $icl_comp_db{$gIclModulePath}{port}{$port_type}{$port_name}{ActivePolarity};
               if ($polarity eq "0") {
                  $active_polarity = 0;
               } elsif ($polarity ne "1") {
                  die "-E- Incorrect ActivePolarity value '$polarity' of ResetPort $port_name\n";
               }
            }
            if (exists $icl_comp_db{$gIclModulePath}{port}{$port_type}{$port_name}{intel_type}) {
               my $category_tmp = $icl_comp_db{$gIclModulePath}{port}{$port_type}{$port_name}{intel_type};
               if ($category_tmp =~ /^p.*w.*rgood_*(\w*)$/i) {
                  $category     = "powergood";
                  $sub_category = lc($1);
               } elsif ($category_tmp =~ /^tlr$/i) {
                  $category = "tlr";
                  $sub_category = "";
               } else {
                  $category     = $category_tmp;
                  $sub_category = "";
               }
            } else {
               print("-I- Autocategorizing port $port_type $port_name...\n");
               if ($port_name =~ /p.*w.*rgood_*(\w*)/i) {
                  $category     = "powergood";
                  $sub_category = lc($1);
                  print("-I- Autocategorized port $port_type $port_name as '$category' signal\n");
                  $icl_comp_db{$gIclModulePath}{port}{$port_type}{$port_name}{intel_type} = $category;
               } elsif ($port_name =~ /ijtag_r.*s.*t/i) {
                  $category = "tlr";
                  $sub_category = "";
                  print("-I- Autocategorized port $port_type $port_name as '$category' signal\n");
                  $icl_comp_db{$gIclModulePath}{port}{$port_type}{$port_name}{intel_type} = $category;
               } else {
                  $category = "unknown";
                  $sub_category = $port_name;
                  print("-I- Not categorized port $port_type $port_name\n");
                  $icl_comp_db{$gIclModulePath}{port}{$port_type}{$port_name}{intel_type} = $category;
               }
            }
            if (defined $category) {
               if (!exists $icl_comp_db{$gIclModulePath}{reset_ports}{$category}) {
                  $icl_comp_db{$gIclModulePath}{reset_ports}{$category} = {};
               }
               if (!exists $icl_comp_db{$gIclModulePath}{reset_ports}{$category}{$sub_category}) {
                  $icl_comp_db{$gIclModulePath}{reset_ports}{$category}{$sub_category}{port_name} = $port_name;
                  $icl_comp_db{$gIclModulePath}{reset_ports}{$category}{$sub_category}{polarity}  = $active_polarity;
               } else {
                  my $another_port = $icl_comp_db{$gIclModulePath}{reset_ports}{$category}{$sub_category}{port_name};
                  die "-E- ResetPort $port_name with type '$category' and subtype '$sub_category' conflicts with similar port '$another_port'\n";
               }
            }
         }
      } # foreach port name
   }

   # check scan interfaces
   foreach my $intf (keys %{$icl_comp_db{$gIclModulePath}{interface}}) {
      if (!exists $icl_comp_db{$gIclModulePath}{interface}{$intf}{is_tap}) {
         die "-E- ICL header, ScanInterface $intf: type cannot be identified\n";
      }
   }
   
   # supporting :
   #   top addrmap with regular TAP(s)
   #   top addrmap with reg_only "TAP" wrapper
   #   TAP definition addrmap (inst name -> TapInstName)
   #   "TAP" reg_only wrapper with chains & registers
   # FIXME: move to the different location?
   my $top_type = $comp_db{$gTopPath}{type};
   if ($top_type ne "addrmap") {
     die "-E- Top level definition must be addrmap (current '$gTopPath' is $top_type)\n";
   }
   my $top_name = $comp_db{$gTopPath}{name};
   
   # Top level is TAP
   if (check_is_tap($gTopPath)) {
      if (icl_get_attr('TapType', $gTopPath, "", 1, 1, 0) eq "\"reg_only\"") {
         print("-I- Design top: '$gTopPath' is a reg_only wrapper\n");
         # each register must have individual Client/Scan ScanInterface
         map_reg_only($gTopPath); # $def_path

      } else { # single regular TAP

         my $top_inst = icl_get_attr('TapInstName', $gTopPath, "", 1, 1, 0);
         $top_inst =~ s/\"//g ;
         if ($top_inst eq "") {
            $top_inst = "tap";
         }
         print("-I- Design top: '$gTopPath' is a single regular TAP '$top_inst'\n");
         # Single TAP must have single Client/TAP ScanInterface
         # If only one ScanInterface in ICL header file - no need to use c_<> convention
         map_tap_inst($gTopPath,$top_inst,1,0,1); # $isnt_path, $name, $is_top, is_inst, $is_single

      }
   } else { # top level wrapper with TAP/registers
      
      my @tap_inst_list = ();
      foreach my $inst (@{$comp_db{$gTopPath}{ilist}}) {
         my $ipath = "$gTopPath.$inst";
         my $cpath = $inst_db{$ipath}{cpath};
         my $fpath = ".$inst";
         if (check_is_tap($cpath)) {
            if (icl_get_attr('TapType', $cpath, $fpath, 1, 1, 0) eq "\"reg_only\"") {
               print("-I- Processing instances in design top: reg_only wrapper '$inst', addrmap '$cpath'\n");
               # each register must have individual Client/Scan ScanInterface
               map_reg_only($cpath); # $def_path

            } else {
               push @tap_inst_list,$inst;
            }
         } else {
            die "-E- Top level '$gTopPath' cannot have non-TAP instance '$inst' (definition '$cpath')\n";
         }
      } # foreach

      # Process TAP instances
      my $is_single_tap = (scalar(@tap_inst_list) == 1);
      foreach my $inst (@tap_inst_list) {
         my $ipath = "$gTopPath.$inst";
         my $cpath = $inst_db{$ipath}{cpath};
         print("-I- Processing TAP instance '$inst' (definition '$cpath')\n");
         map_tap_inst($ipath,$inst,0,1,$is_single_tap); # $isnt_path, $name, $is_top, $is_inst, $is_single
      } # foreach
   }
}

sub map_tap_inst {

   my $inst_path    = shift;
   my $name         = shift;
   my $is_top       = shift;
   my $is_inst      = shift;
   my $is_single    = shift;

   my $status = assign_client_intf($inst_path,$name,$is_inst,1,$is_single); # def_name, inst_name, is_inst, is_tap, is_single
   map_port($inst_path,"ScanInPort",$is_top);
   map_port($inst_path,"ScanOutPort",$is_top);
   map_port($inst_path,"TMSPort",$is_top);
}

sub map_reg_only {

   my $def_path     = shift;

   my @inst_list = @{$comp_db{$def_path}{ilist}};
   if (!scalar(@inst_list)) {
      die "-E- Reg_only definition '$def_path' has no register/chain instances\n";
   }
   my @not_assigned_regs = ();
   foreach my $inst (@inst_list) {
      my $ipath = "$def_path.$inst";
      my $cpath = $inst_db{$ipath}{cpath};
      if ($comp_db{$cpath}{name} eq "TAP_IR") {next;}
      my $status = assign_client_intf($ipath,$inst,1,0,0); # def_name, inst_name, is_inst, is_tap, is_single
      if (!$status) {
         push @not_assigned_regs, $inst;
      }
   }
   # search for single interface which satisfies all remaining registers 
   if (scalar(@not_assigned_regs) > 0) {
      my $assigned_intf = "";
      foreach my $intf (keys %{$icl_comp_db{$gIclModulePath}{interface}}) {
         if (exists $icl_comp_db{$gIclModulePath}{interface}{$intf}{assigned_to}) {next;}
         my $is_correct_interface = check_tap_intf($intf, 0, 1, 0); #name, is_tap, is_client, die_if_error
         if ($is_correct_interface) {
            if ($assigned_intf eq "") {
               $assigned_intf = $intf;
            } else {
               die "-E- Muliple interface options $assigned_intf and $intf exist for shared interface of registers {@not_assigned_regs}\n";
            }
         }
      }
      if ($assigned_intf ne "") {
         foreach my $inst (@not_assigned_regs) {
            my $ipath = "$def_path.$inst";
            $inst_db{$ipath}{intf} = $assigned_intf;
            $inst_db{$ipath}{shared_intf} = 1;
            print("-I- Linked shared interface $assigned_intf with instance '$inst'\n");
         }
      } else {
         warn "-W- No option found for shared interface of registers {@not_assigned_regs} - will use default names\n";
      }
   }

   # Finally, assign ports to individual reg/chain instances
   foreach my $inst (@inst_list) {
      my $ipath = "$def_path.$inst";
      my $cpath = $inst_db{$ipath}{cpath};
      if ($comp_db{$cpath}{name} eq "TAP_IR") {next;}
      map_port($ipath,"ScanInPort",0);
      map_port($ipath,"ScanOutPort",0);
      map_port($ipath,"SelectPort",0);
   }
}

# map TOP level <Func>Port to the corresponding instance or top definition
sub map_port {

   my $ipath     = shift;
   my $port_type = shift;
   my $is_top    = shift;

   my $inst = "";
   my $path = "";
   my $comp_type = "";
   if ($is_top) {
      $path = \$comp_db{$ipath};
      $inst = $$path -> {name};
      $comp_type = "TOP definition";
   } else {
      $path = \$inst_db{$ipath};
      $inst = $$path -> {iname};
      $comp_type = "INSTANCE";
   }

   # process only assigned interfaces
   if (exists $$path -> {intf}) {
      my $intf = $$path -> {intf};
      if (exists $icl_comp_db{$gIclModulePath}{interface}{$intf}{map}{$port_type}) {
         my $is_assigned_port = 0;
         my $assigned_port_name = "";
         if (grep {/^$port_type$/} ('ScanInPort','ScanOutPort','SelectPort')) {
            foreach my $port_name (@{$icl_comp_db{$gIclModulePath}{interface}{$intf}{map}{$port_type}}) {
               if (exists $icl_comp_db{$gIclModulePath}{port}{$port_type}{$port_name}{attr}{intel_tdr_dest}) {
                  if ($icl_comp_db{$gIclModulePath}{port}{$port_type}{$port_name}{attr}{intel_tdr_dest} eq $inst) {
                     if (!$is_assigned_port) {
                        $$path -> {$port_type} = $port_name;
                        print("-I- $comp_type $inst: assigned port $port_type $port_name (ScanInterface $intf)\n");
                        $is_assigned_port = 1;
                        $assigned_port_name = $port_name;
                     } else {
                        die "-E- $comp_type $inst: Conflicting assignment of ScanInPort $port_name and $assigned_port_name (ScanInterface $intf)\n";
                     }
                  }
               }
            }
            #if ($is_assigned_port) {next;};
            if ($is_assigned_port) {return;};
            if (scalar(@{$icl_comp_db{$gIclModulePath}{interface}{$intf}{map}{$port_type}}) == 1) {
               my $port_name = $icl_comp_db{$gIclModulePath}{interface}{$intf}{map}{$port_type}[0];
               $$path -> {$port_type} = $port_name;
               print("-I- $comp_type $inst: assigned port $port_type $port_name (ScanInterface $intf)\n");
            } else {
               die "-E- Multiple $port_type choices exist for $comp_type $inst (assigned ScanInterface $intf)\n";
            }
         } elsif ($port_type eq "TMSPort") {
            my $port_name = $icl_comp_db{$gIclModulePath}{interface}{$intf}{map}{$port_type};
            $$path -> {$port_type} = $port_name;
            print("-I- $comp_type $inst: assigned port $port_type $port_name (ScanInterface $intf)\n");
         } else {
            # other port types
         }
      } elsif (($port_type eq "SelectPort") && (exists $icl_comp_db{$gIclModulePath}{port}{$port_type})) {
         my $is_assigned_port = 0;
         my $assigned_port_name = "";
         foreach my $port_name (keys %{$icl_comp_db{$gIclModulePath}{port}{$port_type}}) {
            if (exists $icl_comp_db{$gIclModulePath}{port}{$port_type}{$port_name}{attr}{intel_tdr_dest}) {
               if ($icl_comp_db{$gIclModulePath}{port}{$port_type}{$port_name}{attr}{intel_tdr_dest} eq $inst) {
                  if (!$is_assigned_port) {
                     $$path -> {$port_type} = $port_name;
                     print("-I- $comp_type $inst: assigned port $port_type $port_name (not a part of any ScanInterface)\n");
                     $is_assigned_port = 1;
                     $assigned_port_name = $port_name;
                  } else {
                     die "-E- $comp_type $inst: Conflicting assignment of SelectPort $port_name and $assigned_port_name (not a part of any ScanInterface)\n";
                  }
               }
            }
         }
         if ($is_assigned_port) {return;};
         my @key_list = keys %{$icl_comp_db{$gIclModulePath}{port}{$port_type}};
         if (scalar(@key_list) == 1) {
            my $port_name = $key_list[0];
            $$path -> {$port_type} = $port_name;
            print("-I- $comp_type $inst: assigned port $port_type $port_name (not a part of any ScanInterface)\n");
         } else {
            die "-E- Multiple $port_type choices exist for $comp_type $inst (not a part of any ScanInterface)\n";
         }
      } elsif (($port_type eq "SelectPort") && (exists $icl_comp_db{$gIclModulePath}{port}{DataInPort})) {
         foreach my $port_name (keys %{$icl_comp_db{$gIclModulePath}{port}{DataInPort}}) {
            if (exists $icl_comp_db{$gIclModulePath}{port}{DataInPort}{$port_name}{RefEnum}) {
               my $enum_name = $icl_comp_db{$gIclModulePath}{port}{DataInPort}{$port_name}{RefEnum};
               if (exists $icl_comp_db{$gIclModulePath}{enum}{$enum_name}) {
                  foreach my $enum_id (keys %{$icl_comp_db{$gIclModulePath}{enum}{$enum_name}}) {
                     if ($enum_id eq $inst) {
                        my $enum_value = $icl_comp_db{$gIclModulePath}{enum}{$enum_name}{$enum_id};
                        print("-I- $comp_type $inst: assigned port DataInPort $port_name (RefEnum $enum_name, enum_id:$enum_id, enum_value:$enum_value\n");
                        $$path -> {select_DataInPort} = $port_name;
                        $$path -> {select_enum_value} = $enum_value;
                     }
                  }
               } else {
                  die "-E- DataInPort $port_name uses RefEnum $enum_name but corresponding Enum definition does not exist\n";
               }
            }
         }
      } elsif (($port_type eq "TMSPort") && (exists $icl_comp_db{$gIclModulePath}{port}{$port_type})) {
         my $is_assigned_port = 0;
         my $assigned_port_name = "";
         foreach my $port_name (keys %{$icl_comp_db{$gIclModulePath}{port}{$port_type}}) {
            if ($icl_comp_db{$gIclModulePath}{port}{$port_type}{$port_name}{attr}{intel_tdr_dest} eq $inst) {
               if (!$is_assigned_port) {
                  $$path -> {$port_type} = $port_name;
                  print("-I- $comp_type $inst: assigned port $port_type $port_name (not a part of any ScanInterface)\n");
                  $is_assigned_port = 1;
                  $assigned_port_name = $port_name;
               } else {
                  die "-E- $comp_type $inst: Conflicting assignment of SelectPort $port_name and $assigned_port_name (not a part of any ScanInterface)\n";
               }
            }
         }
         if ($is_assigned_port) {return;};
         my @key_list = keys %{$icl_comp_db{$gIclModulePath}{port}{$port_type}};
         if (scalar(@key_list) == 1) {
            my $port_name = $key_list[0];
            $$path -> {$port_type} = $port_name;
            print("-I- $comp_type $inst: assigned port $port_type $port_name (not a part of any ScanInterface)\n");
         } else {
            die "-E- Multiple $port_type choices exist for $comp_type $inst (not a part of any ScanInterface)\n";
         }
      } else {
         warn "-E- No port of type $port_type exists for $comp_type $inst (assigned ScanInterface $intf)\n";
# IM FIXME temp         die "-E- No port of type $port_type exists for $comp_type $inst (assigned ScanInterface $intf)\n";
      }
   } else {
      die "-E- No assigned ScanInterface exists for $comp_type $inst\n";
   }
}

sub check_tap_intf {
   my $intf_name    = shift;
   my $is_tap       = shift;
   my $is_client    = shift;
   my $die_if_error = shift;
   my $is_ok = 1;

   my $is_tap_exp = $icl_comp_db{$gIclModulePath}{interface}{$intf_name}{is_tap};
   if ($is_tap != $is_tap_exp) {
      my $intf_type     = ($is_tap)? "TAP" : "Scan";
      my $intf_type_exp = ($is_tap_exp)? "TAP" : "Scan";
      if ($die_if_error) {
         die "-E- Incorrect interface type: expected '$intf_type_exp', provided '$intf_type'\n";
      }
      $is_ok = 0;
   }
   my $is_client_exp = $icl_comp_db{$gIclModulePath}{interface}{$intf_name}{is_client};
   if ($is_client != $is_client_exp) {
      my $intf_type     = ($is_client)? "Client" : "Host";
      my $intf_type_exp = ($is_client_exp)? "Client" : "Host";
      if ($die_if_error) {
         die "-E- Incorrect interface type: expected '$intf_type_exp', provided '$intf_type'\n";
      }
      $is_ok = 0;
   }
   return $is_ok;
}

sub assign_host_intf {

   my $path      = shift;

   foreach my $intf (keys %{$icl_comp_db{$gIclModulePath}{interface}}) {
      if (check_tap_intf($intf, 0, 0, 0)) { #name, is_tap, is_client die_if_error
         if ($intf =~ /^h_(\w+)$/) {
            my $reg_ipath = "$path.$1";
            if (exists $inst_db{$reg_ipath}) {
               print ("-I- Found RTDR register $reg_ipath with exported host interface $intf\n");
               $inst_db{$reg_ipath}{host_intf} = $intf;
            } else {
               warn "-W- ICL header file has host scan interface $intf which targets not existing register $reg_ipath\n";
            }
         } else {
            warn "-W- ICL header file has host scan interface $intf which name is not following naming convention and will be ignored\n";
         }
      }
   }
}

sub assign_client_intf {
   my $path      = shift;
   my $name      = shift;
   my $is_inst   = shift;
   my $is_tap    = shift;
   my $is_single = shift;

   if (exists $icl_comp_db{$gIclModulePath}{interface}{"c_$name"}) {
      print("-I- Linked interface c_$name with instance '$name'\n");
      my $is_correct_interface = check_tap_intf("c_$name", $is_tap, 1, 1); #name, is_tap, is_client die_if_error
      if ($is_inst) {
         $inst_db{$path}{intf} = "c_$name";
      } else {
         $comp_db{$path}{intf} = "c_$name";
      }
      $icl_comp_db{$gIclModulePath}{interface}{"c_$name"}{assigned_to} = $path;
      return 1;
   }
   if ($is_single) {
      my $assigned_intf = "";
      foreach my $intf (keys %{$icl_comp_db{$gIclModulePath}{interface}}) {
         my $is_correct_interface = check_tap_intf($intf, $is_tap, 1, 0); #name, is_tap, is_client, die_if_error
         if ($is_correct_interface) {
            if ($assigned_intf eq "") {
               if ($is_inst) {
                  $inst_db{$path}{intf} = "$intf";
               } else {
                  $comp_db{$path}{intf} = "$intf";
               }
               $icl_comp_db{$gIclModulePath}{interface}{$intf}{assigned_to} = $path;
               $assigned_intf = $intf;
            } else {
               die "-E- Muliple interface options $assigned_intf and $intf exist for instance $name with path $path (is_inst=$is_inst, is_tap=$is_tap, is_single=$is_single)\n";
            }
        }
      }
      if ($assigned_intf eq "") {
         my $type = ($is_inst) ? "instance" : "definition";
         warn "-W- No TAP interface found for $type '$name' (path: '$path')\n";
         warn "-W- Using default interface port names\n";
         return 0;
      }
      return 1;
   }
}

# icl_process_params complete population of param_* databases

sub icl_process_params
{
   foreach my $ipath (keys %param_inst_db) {
      my $parent_def_path = $comp_db{$inst_db{$ipath}{cpath}}{parent};
      do {
         if (!exists $param_comp_db{$parent_def_path}) {
            $param_comp_db{$parent_def_path} = {};
            $param_comp_db{$parent_def_path}{param} = {};
            $param_comp_db{$parent_def_path}{lparam_list} = ();
            $comp_db{$parent_def_path}{param} = 1;
         }
         foreach my $param (keys %{$param_inst_db{$ipath}{delta_1}}) {
            if (!exists $param_comp_db{$parent_def_path}{param}{$param}) {
               $param_comp_db{$parent_def_path}{param}{$param} = $icl_params{$param}{default};
            }
         }
         $parent_def_path = $comp_db{$parent_def_path}{parent};
      } while ($parent_def_path ne '');
   }
}

sub icl_create_comp
{
   my $comp_name = shift;
   my $current_path = shift;
   
   #my $comp_full_name = $comp_type . "_" . $comp_name;
   my $previous_path = $current_path;
   # comp path <comp1>.<comp2> uniquely identifies each definition in RDL
   $current_path .= ".$comp_name";
   
   die "-E- Component $comp_name already exists in the scope '$previous_path'.\n" if (exists $icl_comp_db{$current_path});

   my $icl_comp_tmp = {};
   $icl_comp_tmp->{name} = $comp_name;
   $icl_comp_tmp->{port} = {};
   $icl_comp_tmp->{interface} = {};
   $icl_comp_tmp->{enum} = {};
   $icl_comp_tmp->{used_enum_defs} = {};
   $icl_comp_tmp->{printed_enum_defs} = {};
   $icl_comp_tmp->{printed_ports} = {};
   $icl_comp_tmp->{reset_ports} = {};
   $icl_comp_tmp->{data_ports} = {};

   $icl_comp_db{$current_path} = $icl_comp_tmp;

   return $current_path;

}


### =================================================================
### Process the provided RDL file ($file == '-' is STDIN)
### Not supported:
### All Verilog preprocessor directive excluding `include
### Perl preprocessing

sub process_rdl
{
   my $input      = shift;
   my $param_mode = shift;

   my $line_cnt  = 0;     # line counter
   my $ainst_cnt = 0;     # anonymous instance counter

   # remove \r and all single-/multi-line comments
   # reformat RDL to simplify processing
   $input =~ s/\r//g;
   my $code = remove_comments($input,0);

   my @lines  = split /\n/, $code;

   my $multi_line_string = 0;
   my $inst_attr_path  = '';
   my $attr_name  = '';

   # all comments are removed already
   # simplifying regex based on known rdl_formatting
   foreach my $line (@lines) {

      if ($multi_line_string) {
         if ($line =~ /(.*?)(?!\\)\"\s*;/) { # " marks the end of multi-line string 
            $$inst_attr_path -> {$attr_name} .= "\n" . $1 if !$param_mode;
            $multi_line_string = 0;
         } else {
            $$inst_attr_path -> {$attr_name} .= "\n" . $line if !$param_mode;
         }
      } elsif ($line !~ /\S+/) {
         # empty line
      } elsif ($line =~ /^\s*}\s*([^;]*?);/) {
         #####################################
         # return from definition/instance scope
         # check current component: instance or definition?
         #print ("-I- Leaving scope $current_path\n");
         my $str = $1;
         my $is_inst = $comp_db{$current_path}{is_inst};
         my $inst_type  = $comp_db{$current_path}{type}; # FIXME
         my $def_path = $current_path;
         $current_path = $comp_db{$current_path}{parent};
         if (exists $comp_db{$current_path}) {
            $address = $comp_db{$current_path}{addr_idx};
            $comp_type = $comp_db{$current_path}{type};
         } else {
            $address = 0;
            $comp_type = '';
         }
         if ($is_inst) {
            #instance - extract & assign name, array size, reset/address value (if exists)
            if ($str =~ /^(\\?)(\w+)(.*)/) { # $2 - inst name
               check_rdl_keyword($2,$1);
               if ($param_mode) {
                  my $inst_path = "$current_path.$2";
                  # sanity checks
                  if (!exists $inst_db{$inst_path}) {
                     die "-E- [param_mode] Something wrong: instance $inst_path doesn't exist in the original RDL\n";
                  } elsif ($inst_db{$inst_path}{cpath} ne $def_path) {
                     my $orig_def_path = $inst_db{$inst_path}{cpath};
                     die "-E- [param_mode] Something wrong: instance $inst_path refers to different component $def_path (original component: $orig_def_path)\n";
                  }
                  $address = extract_inst_attr($3,$inst_type,$2,$inst_path,$address,$param_mode); # no ';'
               } else {
                  my $inst_path = create_inst("",$2,$current_path,$def_path,$1); # no ';'
                  $address = extract_inst_attr($3,$inst_type,$2,$inst_path,$address,$param_mode); # no ';'
                  $comp_db{$current_path}{addr_idx} = $address;
               }
            } else {
               die "-E- Incorrect anonymous instantiation format '$line'\n";
            }
         } else {
            #definition
            die "-E- Not supported end of definition scope '$1'\n" if ($1 ne "");
         }
         %found_comps = ();

      } elsif ($line =~ /^\s*(\w+)\s+(\\?)(\w+)\s*{(.*)/) {
         ####################################
         # new definition scope, $1 - type, $3 - name, $2 - escaped
         my $comp_name = $3;
         my $parent_comp_type = $comp_type;
         $comp_type = $1;
         $address = 0; # start new address scope
         check_rdl_keyword($comp_name,$2);
         if ($param_mode) {
            $current_path .= ".$comp_name";
            # sanity checks
            if (!exists $comp_db{$current_path}) {
               die "-E- [param_mode] Something wrong: component $current_path doesn't exist in the original RDL\n";
            }
         } else {
            check_comp_type($comp_type,$parent_comp_type,$current_path);
            $current_path = create_comp($comp_type,$comp_name,$current_path,0,$2);
            print ("-I- New component $comp_type : $comp_name, path $current_path\n");
         }
      } elsif ($line =~ /^\s*(external\s+|internal\s+)?(\w+)\s*{(.*)/) {
         # FIXME check performance impact of internal|external
         ##########################################################
         # new anonymous instance/definition scope, $1 - type
         my $parent_comp_type = $comp_type;
         $comp_type = $2;
         $address=0;
         # FIXME using '__' for auto-created names (instead of '-')
         if ($param_mode) {
            $current_path .= ".i__$ainst_cnt";
            # sanity checks
            if (!exists $comp_db{$current_path}) {
               die "-E- [param_mode] Something wrong: component $current_path doesn't exist in the original RDL\n";
            }
         } else {
            check_comp_type($comp_type,$parent_comp_type,$current_path);
            $current_path = create_comp($comp_type,"i__$ainst_cnt",$current_path,1,'');
            print ("-I- New anonymous instance $comp_type : i__$ainst_cnt, path $current_path\n");
         }
         $ainst_cnt++;

      } elsif ($line =~ /^\s*(\w+)\s*=\s*(.*)/) {
         ####################################
         # property assignment, $1 - name
         # multi-line string detection
         $attr_name  = $1;
         my $attr_value = $2;
         my $assign_type = "assign";
         my $attr_type  = get_chk_property_type($attr_name,$comp_type,$assign_type);
         if ($param_mode) {
            $multi_line_string = is_multiline($attr_name,$attr_value,$attr_type);
         } else {
            die  "-E- Duplicated assignment for property '$attr_name'.\n" if (!$gIgnoreErrors && exists $comp_db{$current_path}{attr}{$attr_name});
            warn "-W- Duplicated assignment for property '$attr_name'.\n" if (exists $comp_db{$current_path}{attr}{$attr_name});
            $inst_attr_path = \$comp_db{$current_path}{attr};
            $multi_line_string = extract_value($attr_name,$attr_value,$attr_type,$inst_attr_path);
            # delete default value at field level if exists
            if ($comp_type eq "field" && exists $comp_db{$current_path}{default}) {
               delete $comp_db{$current_path}{default}{$attr_name} if (exists $comp_db{$current_path}{default}{$attr_name});
            }
         }
      } elsif ($line =~ /^\s*default\s+(\w+)\s*=\s*(.*)/) {
         ###########################################
         # default property assignment, $1 - name
         # multi-line string detection
         # no checking on property location - default is allowed at any component type
         $attr_name = $1;
         my $attr_value = $2;
         my $assign_type = "default";
         my $attr_type  = get_chk_property_type($attr_name,$comp_type,$assign_type);
         if ($param_mode) {
            $multi_line_string = is_multiline($attr_name,$attr_value,$attr_type);
         } else {
            # No duplication check - the last default wins (Nebulon behavior)
            $inst_attr_path = \$comp_db{$current_path}{default};
            $multi_line_string = extract_value($attr_name,$attr_value,$attr_type,$inst_attr_path);
         }

      } elsif ($line =~ /^\s*(\S+)\s*->\s*(\w+)\s*=\s*(.*)/) {
        ############################################
         # instance property assignment, $1 - instance, $2 - property name
         # multi-line string detection
         $attr_name = $2;
         my $attr_path = $1;
         my $attr_value = $3;
         my $assign_type = "dynamic";
         my $attr_type  = get_chk_property_type($attr_name,$comp_type,$assign_type);
         if ($param_mode) {
            $multi_line_string = is_multiline($attr_name,$attr_value,$attr_type);
         } else {
            my $inst_path = find_inst_path($attr_path, $current_path);
            die "-E- Duplicated dynamic assignment for property '$attr_name'.\n" if (exists $comp_db{$current_path}{ovrd}{$attr_path}{$attr_name});
            # FIXME do we need to store definition target?
            #$comp_db{$current_path}{ovrd}{$attr_path}{$attr_name}{ipath} = $inst_path;
            $inst_attr_path = \$comp_db{$current_path}{ovrd}{$attr_path};
            $multi_line_string = extract_value($attr_name,$attr_value,$attr_type,$inst_attr_path);
         }

      } elsif ($line =~ /^\s*(\w+)\s*;/) {
        ####################################
         # boolean property assignment, $1 - name
         # boolean properties only, setting to true
         $attr_name = $1;
         my $assign_type = "assign";
         my $attr_value = "true;";
         my $attr_type  = get_chk_property_type($attr_name,$comp_type,$assign_type);
         if ($param_mode) {
            $multi_line_string = is_multiline($attr_name,$attr_value,$attr_type);
         } else {
            die "-E- incorrect use of property '$attr_name'\n" if ($attr_type ne 'b');
            $inst_attr_path = \$comp_db{$current_path}{attr};
            $multi_line_string = extract_value($attr_name,$attr_value,$attr_type,$inst_attr_path);
         }

      } elsif ($line =~ /^\s*(external\s+|internal\s+)?(\\?)(\w+)\s+(\\?)(\w+)\s*(.*);/) {
         ##############################################
         # instance - single & array, $3 - definition name, $5 - inst name
         # $6 - array/range and/or end of statement
         my $comp_name = $3;
         my $inst_name = $5;

         check_rdl_keyword($3,$2);
         check_rdl_keyword($5,$4);

         if ($param_mode) {
            my $inst_path = "$current_path.$inst_name";
            # sanity checks
            if (!exists $inst_db{$inst_path}) {
               die "-E- [param_mode] Something wrong: instance $inst_path doesn't exist in the original RDL\n";
            }
            my $def_path   = $inst_db{$inst_path}{cpath};
            my $found_type = $comp_db{$def_path}{type};
            $address = extract_inst_attr($6,$found_type,$inst_name,$inst_path,$address,$param_mode); # no ';'
         } else {
            my $def_path = find_comp($comp_name,$current_path,$param_mode);
            my $found_type = $comp_db{$def_path}{type};

            check_comp_type($found_type,$comp_type,$current_path);
            my $inst_path = create_inst($comp_name,$inst_name,$current_path,$def_path,$4); # no ';'
            $address = extract_inst_attr($6,$found_type,$inst_name,$inst_path,$address,$param_mode); # no ';'
            $comp_db{$current_path}{addr_idx} = $address;
         }

      } elsif ($line =~ /^\s*alias\s+(\\?)(\w+)\s+(\\?)(\w+)\s+(\\?)(\w+)\s*;/) {
          die "-E- Register aliasing isn't supported: $line\n";

      } else {
         if ($line =~ /^\s*`include\s+\"(\S+)\"/) { #`
            process_included_file ($1);
         } else {
            die "-E- RDL: Not recognized/not supported construct: $line\n";
         }
      }

      $line_cnt++;
   }
}

sub create_comp
{
   my $comp_type = shift;
   my $comp_name = shift;
   my $current_path = shift;
   my $is_inst = shift;
   my $escaped_id = shift;
   
   #my $comp_full_name = $comp_type . "_" . $comp_name;
   my $previous_path = $current_path;
   # comp path <comp1>.<comp2> uniquely identifies each definition in RDL
   $current_path .= ".$comp_name";
   
   die "-E- Component $comp_name already exists in the scope '$previous_path'.\n" if (exists $comp_db{$current_path});

   my $comp_tmp = {};
   $comp_tmp->{type} = $comp_type;
   $comp_tmp->{name} = $comp_name;
   $comp_tmp->{parent} = $previous_path;
   $comp_tmp->{is_inst} = $is_inst;
   $comp_tmp->{level} = 1 if ($comp_type eq "addrmap" || $comp_type eq "regfile");
   #$comp_tmp->{attr} = {};
   
   if ($comp_type ne "field") { #no need at field level
      $comp_tmp->{ilist} = ();
      $comp_tmp->{addr_idx} = 0;
   }

   # propagate only useful defaults
   if (length($previous_path)) { # skip empty path
      if (exists $comp_db{$previous_path}{default}) {
         foreach my $attr (keys %{$comp_db{$previous_path}{default}}) {
            if (is_propagate_default($attr, $comp_db{$previous_path}{type})) {
               my $default_value = $comp_db{$previous_path}{default}{$attr};
               #print "Propagating $attr = $default_value for $comp_type $comp_name \n";
               $comp_tmp->{default} -> {$attr} = $default_value;
            }
         }
      }
   }

   $comp_tmp->{esc} = 1 if ($escaped_id eq "\\"); 

   $comp_db{$current_path} = $comp_tmp;

   # Check for specified RDL top
   if ($gRdlTop) { # searching for Top RDL definition
      if ($previous_path eq "") { #considering only top level definitions
         $gTopType = $comp_type if (grep {/^$comp_type$/} get_parent_def_types($gTopType));
      }
   } elsif ($comp_type eq $gRdlCompType && $comp_name eq $gRdlCompName) {
      die "-E- Duplicated definition of specified top component $comp_type '$comp_name'\n" if ($gFoundComp);
      $gFoundComp = 1;
      $gTopType = $comp_type;
      $gTopName = $comp_name;
      $gTopPath = $current_path;
   }

   return $current_path;

}

sub create_inst
{
   my $comp_name = shift;
   my $inst_name = shift;
   my $current_path = shift;
   my $def_path = shift;
   my $escaped_id = shift;

   my $inst_path = "$current_path.$inst_name";

   die "-E- Instance $inst_name already exists in the scope '$current_path'.\n" if (exists $inst_db{$inst_path});
   
   # FIXME revisit which data we need to store
   my $inst_tmp = {};
   $inst_tmp->{comp} = $comp_name; #definition name
   $inst_tmp->{iname} = $inst_name;
   $inst_tmp->{cpath} = $def_path;
   #$inst_tmp->{ipath} = $current_path; # parent component path
   $inst_tmp->{esc} = 1 if ($escaped_id eq "\\"); 

   # FIXME
   #$inst_tmp->{attr} = {}; #overrides
   
   $inst_db{$inst_path} = $inst_tmp;
   push (@{$comp_db{$current_path}{ilist}}, $inst_name);
   return $inst_path;

}

sub print_debug
{
   my $idx = shift;
   print "DEBUG $idx: created!\n" if (exists $comp_db{""});
}

sub find_inst_path
{
   my $attr_path = shift;
   my $current_path = shift;
   my $inst_path = '';
   my @apath = split /\./, $attr_path;
   my $cpath = $current_path;
   my $ipath;
   foreach $ipath (@apath) {
      $inst_path = "$cpath.$ipath";
      die "-E- Instance '$ipath' doesn't exist in component '$cpath' (inst db)\n" unless exists $inst_db{$inst_path};
      $cpath = $inst_db{$inst_path}{cpath};
   }
   
   return $inst_path;
}

sub check_inst_path 
{
   my $inst_path = shift;
   die "-E- Instance '$inst_path' doesn't exist\n" unless exists $inst_db{$inst_path};
}

sub find_comp {
   my $comp_name = shift;
   my $current_path = shift;

   #print ("-I- Searching component $comp_name, path '$current_path'\n");
   # use found hash just for one level!
   if (exists $found_comps{$comp_name}) {
      #print ("INFO: Found previously!\n");
      return $found_comps{$comp_name};
   }
   # find the definition in current or upper scopes
   
   my $try_path;
   my @try_paths = split /\./, $current_path;
   while (@try_paths) {
      $try_path = join(".", @try_paths) . ".$comp_name";
      #print ("-I- Checking path $try_path\n");
      if (exists $comp_db{$try_path}) {
         $found_comps{$comp_name} = $try_path;
         #print ("-I- Found!\n");
         # mark if top definition found
         $comp_db{$try_path}{child} = 1 if (scalar(@try_paths) == 1);
         return $try_path ;
      }
      pop(@try_paths);
   }
   die "-E- definition '$comp_name' not found (path '$current_path')\n";
}

sub find_top 
{
   my @comp_list = (grep {($comp_db{$_}{parent} eq "")&&($comp_db{$_}{type} eq $gTopType)&&(!exists $comp_db{$_}{child})} (keys %comp_db));
   my $level = 0;
   my @tops = ();
   # simplified
   # FIXME: do we really need level compare?
   # only if there are 'unused' addrmaps/regfiles
   foreach my $comp (@comp_list) {
      if ($comp_db{$comp}{level} > $level) {
         $level = $comp_db{$comp}{level};
         @tops = ();
         push(@tops,$comp);
      } elsif ($comp_db{$comp}{level} = $level) {
         push(@tops,$comp);
      }
   }
   if (scalar(@tops) == 0) {
      die "-E- no top component found\n";
   } elsif (scalar(@tops) > 1) {
      die "-E- more than one top component found: @tops\n";
   } else {
      return $tops[0];
   } 
}


sub extract_inst_attr 
{
   my $str        = shift;
   my $inst_type  = shift;
   my $inst_name  = shift;
   my $inst_path  = shift;
   my $addr       = shift;
   my $param_mode = shift;

   my $ary_size = 1;
   my $next_addr = 0; #next available address
   my $addr_multiplier = 1;
   my $reg_width;

   if ($str =~ /^\s*\[(.+)\]\s*(.*)/) {
      $ary_size  = extract_array_size($1,$inst_type,$inst_path, $addr, $param_mode);
      # field specific check of $ary_size vs. fieldwidth
      if ($inst_type eq "field" && 
          exists $comp_db{($inst_db{$inst_path}{cpath})}{attr}{fieldwidth}) {
         # FIXME not supporting fieldwidth for param_mode for now
         my $field_width = $comp_db{($inst_db{$inst_path}{cpath})}{attr}{fieldwidth};
         die "-E- Width mismatch for field array $inst_name\[$ary_size\] - field definition has fieldwidth=$field_width.\n" if ($field_width != $ary_size);
      }
      $str = $2;
   } elsif ($inst_type eq "field") { # single instance
      if (exists $comp_db{($inst_db{$inst_path}{cpath})}{attr}{fieldwidth}) {
         # FIXME not supporting fieldwidth for param_mode for now
         # field specific processing of fieldwidth if no array specified
         $ary_size = $comp_db{($inst_db{$inst_path}{cpath})}{attr}{fieldwidth};
      }
      if (!$param_mode) {
         $inst_db{$inst_path}{msb} = $addr + $ary_size - 1;
         $inst_db{$inst_path}{lsb} = $addr;
         $inst_db{$inst_path}{width} = $ary_size;
      }
   }
   if ($str =~ /^=\s*(.*)/) {
      #note string format to support big numbers
      my $reset_val = extract_num_value_hex_str($1,$ary_size);
      if ($inst_type eq "field") {
         if ($param_mode) {
            if ($inst_db{$inst_path}{reset} ne $reset_val) {
               die "-E- [param_mode] parameterization of field reset isn't supported (instance $inst_path)\n";
            }
         } else {
            $inst_db{$inst_path}{reset} = $reset_val;
         }
      } else {
         die "-E- Reset value can't be specified for $inst_type component.\n";
      }
   } elsif ($str =~ /^(@|\+=|%=)\s*(.+)/) {
      # FIXME revisit
      die "-E- Address can't be specified for $inst_type component ($inst_path)\n" if ($inst_type ne "reg" && $inst_type ne "regfile");
      my $comp_path = $inst_db{$inst_path}{cpath};
      if (exists  $comp_db{$comp_path}{attr}{regwidth}) {
         $reg_width = $comp_db{$comp_path}{attr}{regwidth};
      } else {
         die "-E- Not specified regwidth for instance $inst_name ($inst_path) (component '$comp_path')\n";
      }
      die "-E- incorrect register width $reg_width\n" if (2**length(sprintf("%b",$reg_width-1))!=$reg_width || $reg_width<8);
      $addr_multiplier = $reg_width/8;
      
      while ($str =~ /^(@|\+=|%=)\s*([^@+=%\s]+)\s*(.*)/) {
         $str = $3;
         if ($1 eq "@") {
            $addr  = extract_address($2,$1,$inst_type,0);
         } elsif ($1 eq "+=") {
            $inst_db{$inst_path}{addr_inc} = extract_address($2,$1,$inst_type,0);
         } elsif ($1 eq "%=") {
            $inst_db{$inst_path}{addr_align} = extract_address($2,$1,$inst_type,0);
         } else {
            die "-E- Incorrect address format '$str' ($inst_path)\n";
         }
      }
      die "-E- Not supported address spec '$str' ($inst_path)\n" unless ($str =~ /^\s*$/);
      # extracted address or start address
      $inst_db{$inst_path}{addr} = $addr if !$param_mode;
   } elsif ($str =~ /^\s*$/) {
      # no reset/address values
      # Ordering info for registers and regfiles
      if ($inst_type eq "reg" || $inst_type eq "regfile") {
         $inst_db{$inst_path}{addr} = $addr if !$param_mode;
      }
   } else {
      die "-E- Unrecognized instance array/address/reset properties '$str'\n";
   }
   $next_addr = $addr + $ary_size*$addr_multiplier;
   return $next_addr;
}

# return 1 for multi-line string
sub extract_value {
  my $attr_name = shift;
  my $attr_value = shift;
  my $attr_type  = shift;
  my $inst_apath  = shift;

  # FIXME: original processing kept '"' a a part of string values
  # all values stored as strings
  if ($attr_type eq "s") { #string
      # simplifying based on pre-processing
      #print "=> $attr_name = $attr_value\n";
      my $attr_value_1 = $attr_value;
      $attr_value =~ s/\\\"//g; # remove all \"
      if ($attr_value =~ /^\"(.*?)\"(.*)/) {
         #my $default = get_property_default($attr_name);
         #print "Attr: $attr_name = '$1' (default: '$default', path '$$attr_path')\n";
         $attr_value_1 =~ s/^\"//; # first "
         $attr_value_1 =~ s/\"[^\"]*$//; # last "
         my $skip = 0;
         if (check_property_default($attr_name)) {
            $skip = 1 if (is_compress_attr($attr_name) && (get_property_default($attr_name) eq $attr_value_1));
         }
         $$inst_apath -> {$attr_name} = $attr_value_1 unless ($skip);
      } elsif ($attr_value =~ /^\"(.*)/) {
         #multi-line isn't default
         $attr_value_1 =~ s/^\"//; # first "
         $$inst_apath -> {$attr_name} = $attr_value_1;
         return 1; #multi-line
      } else {
         die "-E- incorrect string format for property $attr_name: '$attr_value'\n";
      }
  } elsif ($attr_type eq "n" | $attr_type eq "nx") { #number
      if ($attr_value =~ /^(\S+?)\s*;(.*)/) {
         my $value = extract_num_value($1,0);
         my $skip = 0;
         if (check_property_default($attr_name)) {
            $skip = 1 if (is_compress_attr($attr_name) && (get_property_default($attr_name) == $value));
         }
         $$inst_apath -> {$attr_name} = $value unless ($skip);
      } else {
         die "-E- incorrect number format for property $attr_name: '$attr_value'\n";
      }
  } elsif ($attr_type eq "nb") { #big number - reset value
      if ($attr_value =~ /^(\S+?)\s*;(.*)/) {
         my $value = extract_num_value_hex_str($1,0);
         $$inst_apath -> {$attr_name} = $value; # always assign
      } else {
         die "-E- incorrect number format for property $attr_name: '$attr_value'\n";
      }
  } elsif ($attr_type eq "b") { #boolean
      if ($attr_value =~ /^(true|false)\s*;(.*)/) {
         my $value = ($1 eq "true") ? 1 : 0;
         my $skip = 0;
         if (check_property_default($attr_name)) {
            $skip = 1 if (is_compress_attr($attr_name) && (get_property_default($attr_name) eq $1));
         }
         $$inst_apath -> {$attr_name} = $value unless ($skip);
      } else {
         die "-E- incorrect boolean format for property $attr_name: '$attr_value'\n";
      }
  } elsif ($attr_type eq "r") { #reference
      if ($attr_value =~ /^(\S+)\s*;(.*)/) {
         die "-E- reference value isn't supported ('$attr_value')\n";
      } else {
         die "-E- incorrect reference format '$attr_value'\n";
      }
  } elsif ($attr_type eq "k") { #keyword
      if ($attr_value =~ /^(\w+)\s*;(.*)/) {
         die "-E- SystemRDL keyword value isn't supported ('$attr_value')\n";
      } else {
         die "-E- incorrect SystemRDL keyword value format '$attr_value'\n";
      }
  } else {
     die "-E- Not supported property data type '$attr_type'\n";
  }
  return 0; # single line
}

# return 1 for multi-line string (simplified sub extract_value)
sub is_multiline {
  my $attr_name  = shift;
  my $attr_value = shift;
  my $attr_type  = shift;

  # FIXME: original processing kept '"' as a part of string values
  # all values stored as strings
  if ($attr_type eq "s") { #string
      # simplifying based on pre-processing
      $attr_value =~ s/\\\"//g; # remove all \"
      if ($attr_value =~ /^\"(.*?)\"(.*)/) {
      } elsif ($attr_value =~ /^\"(.*)/) {
         #multi-line isn't default
         return 1; #multi-line
      } else {
         die "-E- incorrect string format for property $attr_name: '$attr_value'\n";
      }
  }
  return 0; # single line
}

sub extract_array_size {
   my $str        = shift;
   my $inst_type  = shift;
   my $inst_path  = shift;
   my $offset     = shift;
   my $param_mode = shift;

   my $size = 0;
   my $is_field = ($inst_type eq "field");
   if ($str =~ /^\s*(\d+)\s*:\s*(\d+)\s*$/) {
      $size = ($1 - $2 + 1);
      die "-E- Non-zero lsb array range value for instance type $inst_type ($inst_path, param_mode:$param_mode)\n" if (!$is_field && ($2 + 0)!= 0);
      if ($param_mode) {
         if ($is_field) {
            my $lsb_p = ($2 + 0);
            my $width_delta = $size - $inst_db{$inst_path}{width};
            my $delta_mode = ($icl_active_params_all)? "delta_all" : "delta_1";
            if ($width_delta != 0) {
               $inst_db{$inst_path}{param} = 1;
               if (!exists $param_inst_db{$inst_path}) {
                  $param_inst_db{$inst_path} = {};
               }
               if (!exists $param_inst_db{$inst_path}{$delta_mode}) {
                  $param_inst_db{$inst_path}{$delta_mode} = {};
               }
               if (!exists $param_inst_db{$inst_path}{$delta_mode}{$icl_active_param}) {
                  $param_inst_db{$inst_path}{$delta_mode}{$icl_active_param} = {};
               }
               $param_inst_db{$inst_path}{$delta_mode}{$icl_active_param}{width_delta} = $width_delta;
            }
            my $lsb_delta = $lsb_p - $inst_db{$inst_path}{lsb};
            if ($lsb_delta != 0) {
               $inst_db{$inst_path}{param} = 1;
               if (!exists $param_inst_db{$inst_path}) {
                  $param_inst_db{$inst_path} = {};
               }
               if (!exists $param_inst_db{$inst_path}{$delta_mode}) {
                  $param_inst_db{$inst_path}{$delta_mode} = {};
               }
               if (!exists $param_inst_db{$inst_path}{$delta_mode}{$icl_active_param}) {
                  $param_inst_db{$inst_path}{$delta_mode}{$icl_active_param} = {};
               }
               $param_inst_db{$inst_path}{$delta_mode}{$icl_active_param}{lsb_delta} = $lsb_delta;
            }
         } else {
            if ($inst_db{$inst_path}{width} != $size) {
               die "-E- [param_mode] Parameterization of width isn't supported for instance $inst_path of type $inst_type\n";
            }
         }
      } else {
         $inst_db{$inst_path}{width} = $size;
         if ($is_field) {
            $inst_db{$inst_path}{msb} = ($1 + 0);
            $inst_db{$inst_path}{lsb} = ($2 + 0);
         }
      }
   } elsif ($str =~ /^\s*(\d+)\s*$/) {
      $size = ($1 + 0);
      if ($param_mode) {
         if ($is_field) {
            my $width_delta = $size - $inst_db{$inst_path}{width};
            my $delta_mode = ($icl_active_params_all)? "delta_all" : "delta_1";
            if ($width_delta != 0) {
               $inst_db{$inst_path}{param} = 1;
               if (!exists $param_inst_db{$inst_path}) {
                  $param_inst_db{$inst_path} = {};
               }
               if (!exists $param_inst_db{$inst_path}{$delta_mode}) {
                  $param_inst_db{$inst_path}{$delta_mode} = {};
               }
               if (!exists $param_inst_db{$inst_path}{$delta_mode}{$icl_active_param}) {
                  $param_inst_db{$inst_path}{$delta_mode}{$icl_active_param} = {};
               }
               $param_inst_db{$inst_path}{$delta_mode}{$icl_active_param}{width_delta} = $width_delta;
            }
         } else {
            if ($inst_db{$inst_path}{width} != $size) {
               die "-E- [param_mode] Parameterization of width isn't supported for instance $inst_path of type $inst_type\n";
            }
         }
      } else {
         $inst_db{$inst_path}{width} = $size;
         if ($is_field) {
            $inst_db{$inst_path}{msb} = $offset+$size-1;
            $inst_db{$inst_path}{lsb} = $offset;
         }
      }
   } else {
      die "-E- incorrect format for instance array '$str': $!\n";
   }
   # FIXME 'field' vs. 'f'
   #die "-E- Array of $inst_type components isn't supported ('$inst_path'): $!" if ($size > 1 && $inst_type ne "field");
   return $size;  
}

sub extract_address {
   my $str = shift;
   my $expr_type = shift; # @, +=, %=
   my $inst_type = shift;
   my $start_addr = shift; # first available address
   my $addr = 0;
   $addr = extract_num_value($str,0);
   die "-E- Addr_alloc for $inst_type components isn't supported: $!" if ($inst_type eq "field");
   return $addr;  
}

sub extract_num_value {
   # return string value for now
   my $num_str = shift;
   my $req_width = shift;
   my $num_val = 0;
   my $width_val = 0; #required min width for the specified value
   my $width_num = 0; #Verilog style number width
   if ($num_str =~ /^\s*(\S+)\s*$/) {
      $num_str = $1;
      $num_str =~ s/_//g;
      if ($num_str =~ /^(\d+)'([bBdDoOhH])(\w+)$/) { # Verilog style
         $width_num = $1 + 0;
         $num_str = $3;
         my $format = $2;
         $num_str =~ s/^0+//; # eliminate leading 0's
         # process value depending on radix
         if ($num_str =~ /^$/) { # special processing of 0 value
            $num_val = 0;
         # process value depending on radix
         } elsif ($format eq "b" or $format eq "B") { # Verilog style binary
            $num_val = oct("0b" . $num_str);
         } elsif ($format eq "d" or $format eq "D") { # Verilog style decimal
            $num_val = $num_str + 0;
         } elsif ($format eq "h" or $format eq "H") { # Verilog style hex
            $num_val = hex($num_str);
         } elsif ($format eq "o" or $format eq "O") { # Verilog style octal
            $num_val = oct($num_str);
         } else {
            die "-E- Incorrect Verilog number format '$num_str'\n";
         }
         $width_val = length(sprintf("%b",$num_val));
         die "-E- Verilog number - specified width $width_num isn't enough, must be at least $width_val\n" if ($width_val > $width_num);
         warn "-W- Required width $req_width and specified value width $width_num mismatch ('$current_path')\n" if ($req_width > 0 && $req_width != $width_num);
         die "-E- Required width $req_width and specified value width $width_num mismatch ('$current_path')\n" if ($req_width > 0 && $req_width > $width_num && !$gIgnoreErrors);
      } elsif ($num_str =~ /^0[xX]([0-9a-fA-F]+)$/) {
         $num_val = hex($1);
      } elsif ($num_str =~ /^(\d+)$/) {
         $num_val = $1 + 0;;
      } else {
         # FIXME improve messaging
         die "-E- Incorrect number format '$num_str'\n";
      }
   } else {
      die "-E- Incorrect number format '$num_str'\n";
   }
   return $num_val;
}

# similar to extract_num_value, but returns hex string
# it supports big int numbers in binary and hex formats
sub extract_num_value_hex_str {
   # return string value for now
   my $num_str = shift;
   my $req_width = shift;
   my $num_val = '';
   my $width_val = 0; #required min width for the specified value
   my $width_num = 0; #Verilog style number width
   if ($num_str =~ /^\s*(\S+)\s*$/) {
      $num_str = $1;
      $num_str =~ s/_//g;
      if ($num_str =~ /^(\d+)'([bBdDoOhH])(\w+)$/) { # Verilog style
         $width_num = $1 + 0;
         my $format = $2;
         $num_str = $3;
         $num_str =~ s/^0+//; # eliminate leading 0's
         # process value depending on radix
         if ($num_str =~ /^$/) { # special processing of 0 value
            $num_val = '0'; # no 0x prefix
            $width_val = 1;
         } elsif ($format eq "b" or $format eq "B") { # Verilog style binary
            $width_val = length($num_str);
            if ($width_val < 33) {
               $num_val = sprintf("%x", oct("0b" . $num_str)); # no 0x prefix
            } else { # $len > 32
               my $offset = -32;
               while ($width_val + $offset > 0) {
                  my $str = substr($num_str,$offset,32);
                  $num_val = sprintf("%x", oct("0b" . $str)) . $num_val;
                  $offset -= 32;
               }
               $num_val = sprintf("%x", oct("0b" . substr($num_str,0,$width_val + $offset + 32))) . $num_val; # no 0x prefix
            }
         } elsif ($format eq "d" or $format eq "D") { # Verilog style decimal
            # not supporting decimal beyond 32b for now
            my $value = $num_str + 0;
            die "-E- Too big decimal number '$num_str' - only 32b values are supported\n" if ($value > 0xffffffff);
            $num_val = sprintf("%x", $value); # no 0x prefix
            $width_val = length(sprintf("%b",$value));
         } elsif ($format eq "h" or $format eq "H") { # Verilog style hex
            $num_val = lc($num_str); # no 0x prefix
            $width_val = 4*(length($num_str) - 1) + length(sprintf("%b", hex(substr($num_str,0,1))));
         } elsif ($format eq "o" or $format eq "O") { # Verilog style octal
            # not supporting octal beyond 32b for now
            my $value = oct($num_str);
            die "-E- Too big octal number '$num_str' - only 32b values are supported\n" if ($value > 0xffffffff);
            $num_val = sprintf("%x", $value); # no 0x prefix
            $width_val = length(sprintf("%b",$value));
         } else {
            die "-E- Incorrect Verilog number format\n";
         }
         die "-E- Verilog number - specified width $width_num isn't enough, must be at least $width_val\n" if ($width_val > $width_num);
         warn "-W- Required width $req_width and specified value width $width_num mismatch ('$current_path')\n" if ($req_width > 0 && $req_width != $width_num);
         die "-E- Required width $req_width and specified value width $width_num mismatch ('$current_path')\n" if ($req_width > 0 && $req_width > $width_num && !$gIgnoreErrors);
      } elsif ($num_str =~ /^0[xX]([0-9a-fA-F]+)$/) {
         $num_str = $1;
         $num_str =~ s/^0+//; # eliminate leading 0's
         $num_val = (length($num_str)) ? lc($num_str) : "0"; # no 0x prefix
         $width_val = (length($num_str)) ? 4*(length($num_str) - 1) + length(sprintf("%b", hex(substr($num_str,0,1)))) : 1;
      } elsif ($num_str =~ /^(\d+)$/) {
         # not supporting decimal beyond 32b for now
         my $value = $1 + 0;
         die "-E- Too big decimal number '$num_str' - only 32b values are supported\n" if ($value > 0xffffffff);
         $num_val = sprintf("%x", $value); # no 0x prefix
         $width_val = length(sprintf("%b",$value));
      } else {
         # FIXME improve messaging
         die "-E- Incorrect number format '$num_str'\n";
      }
   } else {
      die "-E- Incorrect number format '$num_str'\n";
   }
   return $num_val;
}

sub check_all_fields
{
   my @reg_comp_list = (grep { $comp_db{$_}{type} eq "reg" } (keys %comp_db));
   print "-I- Processing register fields...\n";
   foreach my $reg (@reg_comp_list) {
      my $reg_width = 0;
      my $tap_design = ($gDesignType eq 'tap');
      my $stf_design = ($gDesignType eq 'stf');
      my $width_udp = ($tap_design) ? "TapTotalNumRegBits" : ($stf_design) ? "StfRegWidth" : "regwidth";

      $reg_width = $comp_db{$reg}{attr}{$width_udp} if (exists $comp_db{$reg}{attr}{$width_udp});

      die "-E- Register $reg doesn't have fields\n" if (!scalar(@{$comp_db{$reg}{ilist}}));

      # sort ilist of fields from lsb to msb (lower lsb first)
      my @sorted_fields = sort { $inst_db{"$reg.$a"}{lsb} <=> $inst_db{"$reg.$b"}{lsb} } @{$comp_db{$reg}{ilist}};
      $comp_db{$reg}{ilist} = \@sorted_fields;

      my $msb = -1;

      foreach my $field (@sorted_fields) {
         if ($tap_design || $stf_design) {
            die "-E- Register $reg: incorrect lsb of field $reg.$field\n" if ($inst_db{"$reg.$field"}{lsb} != $msb + 1);
         } else {
            die "-E- Register $reg: incorrect lsb of field $reg.$field\n" if ($inst_db{"$reg.$field"}{lsb} < $msb + 1);
         }
         $msb = $inst_db{"$reg.$field"}{msb}; 
      }
      my $total_field_width = $msb + 1;
      if ($reg_width > 0) {
         if ($tap_design | $stf_design) {
            die "-E- Register '$reg': incorrect width $width_udp = $reg_width, it should be $total_field_width\n" if (!$gIgnoreErrors && $reg_width != $total_field_width);
            warn "-W- Register '$reg': incorrect width $width_udp = $reg_width, it should be $total_field_width\n" if ($reg_width != $total_field_width);
         } else {
            die "-E- Register '$reg': incorrect width $width_udp = $reg_width, it should be at least $total_field_width\n" if (!$gIgnoreErrors && $reg_width < $total_field_width);
            warn "-W- Register '$reg': incorrect width $width_udp = $reg_width, it should be at least $total_field_width\n" if ($reg_width < $total_field_width);
         }
      } else {
         if ($tap_design) {
            warn "-W- Register '$reg': Assigning not specified $width_udp = $total_field_width\n";
            $comp_db{$reg}{attr}{$width_udp} = $total_field_width;
         } else {
            die "-E- Register '$reg': incorrect width $reg_width, it should be at least $width_udp = $total_field_width\n" if (!$gIgnoreErrors);
            warn "-W- Register '$reg': incorrect width $reg_width, it should be at least $width_udp = $total_field_width\n";
         }
      }
      
      # TAP only
      if ($tap_design) {
         my $reg_shift_length = 0;
         $reg_shift_length = $comp_db{$reg}{attr}{TapShiftRegLength} if (exists $comp_db{$reg}{attr}{TapShiftRegLength});

         if ($reg_shift_length > 0) {
            if ($reg_shift_length > $total_field_width) {
               die "-E- Register '$reg': incorrect shift length TapShiftRegLength = $reg_shift_length, it cannot be greater than TapTotalNumRegBits = $total_field_width\n" if (!$gIgnoreErrors);
               warn "-W- Register '$reg': incorrect shift length TapShiftRegLength = $reg_shift_length, it cannot be greater than TapTotalNumRegBits = $total_field_width\n";
            }
            if ($reg_shift_length != $total_field_width) {
               warn "-W- Register '$reg': Not equal TapTotalNumRegBits and TapShiftRegLength ($total_field_width vs. $reg_shift_length)\n";
            }
         } else {
            warn "-W- Register '$reg': Assigning not specified TapShiftRegLength = $total_field_width (TapTotalNumRegBits)\n";
            $comp_db{$reg}{attr}{TapShiftRegLength} = $total_field_width;
         }
      }
      # TAP & STF, regwidth
      if ($tap_design || $stf_design) {
         my $req_regwidth = calc_regwidth($total_field_width);
         if (exists $comp_db{$reg}{attr}{regwidth}) {
            my $spec_regwidth = $comp_db{$reg}{attr}{regwidth};
            if ($req_regwidth > $spec_regwidth) {
               die "-E- Register '$reg': incorrect regwidth = $spec_regwidth (must be $req_regwidth)\n";
            } elsif ($req_regwidth != $spec_regwidth) {
               warn "-W- Register '$reg': Updating regwidth = $req_regwidth (original: $spec_regwidth)\n";
               $comp_db{$reg}{attr}{regwidth} = $req_regwidth;
            }
         } else {
            warn "-W- Register '$reg': Updating regwidth = $req_regwidth (original: not specified)\n";
            $comp_db{$reg}{attr}{regwidth} = $req_regwidth;
         }
      }
   }
}

sub calc_regwidth
{
   my $size = shift;
   return (($size > 8) ? (2**length(sprintf("%b",$size - 1))) : 8 );
}

# already sorted for TAP regfiles
# No need to re-sort for CR if no advanced addressing assignment mechanisms are used
#
sub update_all_regfiles
{
   my @rf_comp_list = (grep { $comp_db{$_}{type} eq "regfile" } (keys %comp_db));
   print "-I- Processing regfiles...\n";
   foreach my $rf (@rf_comp_list) {
      my @sorted_regs = sort { $inst_db{"$rf.$a"}{addr} <=> $inst_db{"$rf.$b"}{addr} } @{$comp_db{$rf}{ilist}};
      $comp_db{$rf}{ilist} = \@sorted_regs;
   }
}

sub process_included_file
{
   my $file      = shift;
   my $found = 0;

   print ("-I- Processing file '$file'\n");

   if ($file =~ /^(\S+)_udp\.rdl/) {
     # UDP file handling
     return if $gUdpFileName eq $file;
     if ($gUdpFileName eq "") {
        my $prefix = $1;
        $gUdpFileName = $file;
        $gDesignType = 'tap'  if ($prefix =~ /^tap/);
        $gDesignType = 'stf'  if ($prefix =~ /^stf/);
        $gDesignType = 'cr'   if ($prefix =~ /^lib/);
        $gDesignType = 'scan' if ($prefix =~ /^scan/);
        $gDesignType = 'fuse' if ($prefix =~ /^fuse/);
     } else {
        die "-E- Multiple UDP files: $gUdpFileName, $file\n\n"
     }
     if (-e "./$file") {
        print ("-I- Using local UDP file '$file'\n");
        process_udp_file("./$file");
        $found = 1;
     } elsif ($gUdpFilePath ne ''){
        if (-e "$gUdpFilePath/$file") {
           print ("-I- Using UDP file '$gUdpFilePath/$file'\n");
           process_udp_file("$gUdpFilePath/$file");
           $found = 1;
        }
     }
     ($found) or die "Couldn't find UDP $file'\n\n";
   } else {
     die "-E- Not expected included rdl file $file'\n\n";
   }
}
# remove_icl_comments
# eliminates both single-line(//) and multi-line (/*...*/) comments,
# taking into account that these comment identifiers can be a part of string values.
# Strings with '\"' are also handled
# FIXME: '\r' also terminates single-line comment

sub remove_icl_comments
{
   my $input = shift;
   my $output = '';
   my $mode     = ''; # current mode: 'ml_comment', 'sl_comment', 'str'
   my $nxt_mode = ''; # next mode: '//','/*','*/','="','"'

   while ($input =~ /(.*?)(\/\*|\*\/|\/\/|=(?!=)\s*\"|(?<!\\)\")/sgc) {
      my $s = $1; # current sub-string
      $nxt_mode = $2;
      if ($mode eq 'sl_comment') {
         # continue skipping if no '\n'
         next unless ($s =~ /^.*?\n(.*)$/s);
         $s = $1;
         $mode = '';
      }
      if ($mode eq "") {
         $output .= format_icl($s,$mode,$nxt_mode);
         if ($nxt_mode eq "//") { # single-line comment
           $mode = 'sl_comment';
         } elsif ($nxt_mode eq "/*") { # multi-line comment
           $mode = 'ml_comment';
         } elsif ($nxt_mode eq "*/") { # end of multi-line comment
            die "-E- Missing start of multi-line comment /* .. */.\n";
         } elsif ($nxt_mode eq "\"") { # start|end of some string
            die "-E- unexpected quotes '\"' ($s)\n";
         } else { # start of string value
           $mode = 'str';
           $output .= "= \"";
         }
      } elsif ($mode eq 'ml_comment') {
         $mode = '' if ($nxt_mode eq "*/");
      } elsif ($mode eq 'str') {
         $output .= format_icl($s,$mode,$nxt_mode) . $nxt_mode;
         $mode = '' if ($nxt_mode eq "\"");
      }
   }

   # add any remaining ICL lines after the last match
   # pos($var): offset of where the last "m//g" search for $var ended
   my $str  = substr $input, pos($input) // 0;
   
   # $nxt_mode indicates the last match
   if ($nxt_mode eq "/*") {
      die "-E- Not complete multi-line comment.\n";
   }
   if ($nxt_mode =~ /=/) {
      die "-E- Not complete string value.\n";
   }
   
   if ($nxt_mode eq "//") {
      #$str =~ s/(.*?)\n//s; # FIXME
      $str =~ s/(.*?)$//m;
   }

   $output .= format_icl($str,'','') if length($str);
   $output =~ s/\n\s+/\n/g;

   return $output;
}
# format_icl
# result:
#  - one statement per line, based on ';'
#  - one line per value assignment '<property> = <value>;'
#  - '<definition> [<name>] {' on the same line
#  - remove extra spaces and indents

sub format_icl
{
   my $str = shift;
   my $mode = shift;
   my $nxt_mode = shift;
   
   if ($mode eq "") {
      $str =~ s/[ \t]+/ /sg;
      $str =~ s/\s*;[;\s]*/;\n/sg;
      $str =~ s/\s*=\s*/ = /sg;
      $str =~ s/\s*\{\s*/ \{\n/sg;
      $str =~ s/\s*\}\s*/\n}\n/sg;
      #$str =~ s/\} ;/};/sg; # new
      $str =~ s/\n[ ]+/\n/sg;
      #$str =~ s/^\s+(?=\S)//sg;
   } elsif ($mode eq 'str') {
      # keep '\n' for now
      $str =~ s/[ \t]+/ /sg;
   }
   return $str;
}

# remove_comments
# eliminates both single-line(//) and multi-line (/*...*/) comments,
# taking into account that these comment identifiers can be a part of string values.
# Strings with '\"' are also handled
# FIXME: '\r' also terminates single-line comment

sub remove_comments
{
   my $input = shift;
   my $remove_perl = shift;
   my $output = '';
   my $mode     = ''; # current mode: 'ml_comment', 'sl_comment', 'str', 'incl', 'perl'
   my $nxt_mode = ''; # next mode: '//','/*','*/','="','"'

   $input =~ s/<%.*?%>//sg if $remove_perl;

   while ($input =~ /(.*?)(\/\*|\*\/|\/\/|=(?!=)\s*\"|(?<!\\)\"|<%|%>)/sgc) {
      my $s = $1; # current sub-string
      $nxt_mode = $2;
      if ($mode eq 'sl_comment') {
         # continue skipping if no '\n'
         next unless ($s =~ /^.*?\n(.*)$/s);
         $s = $1;
         $mode = '';
      }
      if ($mode eq "") {
         $output .= format_rdl($s,$mode,$nxt_mode);
         if ($nxt_mode eq "//") { # single-line comment
           $mode = 'sl_comment';
         } elsif ($nxt_mode eq "/*") { # multi-line comment
           $mode = 'ml_comment';
         } elsif ($nxt_mode eq "*/") { # end of multi-line comment
            die "-E- Missing start of multi-line comment /* .. */.\n";
         } elsif ($nxt_mode eq "\"") { # start|end of some string
            if ($s =~ /`include\s+/) {
               $mode = 'incl';
            } else {
               die "-E- unexpected quotes '\"' ($s)\n";
            }
         } elsif ($nxt_mode eq "<%") { # start of Perl block
               $mode = 'perl';
               $output .= "<%";
         } else { # start of string value
           $mode = 'str';
           $output .= "= \"";
         }
      } elsif ($mode eq 'ml_comment') {
         $mode = '' if ($nxt_mode eq "*/");
      } elsif ($mode eq 'perl') {
         $output .= format_rdl($s,$mode,$nxt_mode) . $nxt_mode;
         $mode = '' if ($nxt_mode eq "%>");
      } elsif ($mode eq 'str') {
         $output .= format_rdl($s,$mode,$nxt_mode) . $nxt_mode;
         $mode = '' if ($nxt_mode eq "\"");
      } elsif ($mode eq 'incl') {
         if ($nxt_mode eq "\"") {
            if ($s =~ /^\S+$/) { # end of file include (file name)
               $mode = '';
               $output .= "\"" . $s . "\"\n";
            } else {
               die "-E- incorrect Verilog include syntax - file name.\n";
            }
         } else {
            die "-E- incorrect Verilog include syntax\n";
         }
      }
   }

   # add any remaining RDL lines after the last match
   # pos($var): offset of where the last "m//g" search for $var ended
   my $str  = substr $input, pos($input) // 0;
   
   # $nxt_mode indicates the last match
   if ($nxt_mode eq "/*") {
      die "-E- Not complete multi-line comment.\n";
   }
   if ($nxt_mode =~ /=/) {
      die "-E- Not complete string value.\n";
   }
   
   if ($nxt_mode eq "//") {
      #$str =~ s/(.*?)\n//s; # FIXME
      $str =~ s/(.*?)$//m;
   }

   $output .= format_rdl($str,'','') if length($str);

   return $output;
}

# format_rdl
# result:
#  - one statement per line, based on ';'
#  - one line per value assignment '<property> = <value>;'
#  - one line per dynamic value assignment '<instance> -> <property>;'
#  - '<definition> [<name>] {' on the same line
#  - '} <..>; on the same line (different line than declaration start)
#  - remove extra spaces and indents

sub format_rdl
{
   my $str = shift;
   my $mode = shift;
   my $nxt_mode = shift;
   
   if ($mode eq "") {
      $str =~ s/[ \t]+/ /sg;
      $str =~ s/\s*;[;\s]*/;\n/sg;
      $str =~ s/\s*(?![=+%])=\s*/ = /sg;
      $str =~ s/\s*->\s*/ -> /sg;
      $str =~ s/\s*\{\s*/ \{\n/sg;
      $str =~ s/\s*\}\s*([^;]*?);\s*/\n} $1;\n/sg;
      $str =~ s/\} ;/};/sg; # new
      $str =~ s/\n[ ]+/\n/sg;
      #$str =~ s/^\s+(?=\S)//sg;
   } elsif ($mode eq 'str') {
      # keep '\n' for now
      $str =~ s/[ \t]+/ /sg;
   } elsif ($mode eq 'perl') {
      #special processing for unary +/-
      $str =~ s/\s+([-+]+)/$1/sg;
   }
   return $str;
}

### =================================================================
# Properties access API

### =================================================================
# ICL Writer API
# General ICL structure
#
# design_top.icl
#   including all TAP modules (orig addrmap) definitions
#   Module top {
#     <inst TAP>
#   };
#
# tap.icl
# Module TAP {
#    <TAP properties: parameters & attributes>
#    <base ICL code for TAP>
#    <register instances>
# }
#    <register definitions>

# print header
# print def start
# print main properties
# print properties with non-default values and IMPORTANT properties with default values
# print req'ed defs from current scope into the SEPARATE file
# FIXME: print additional req'ed defs from scope above
#   - Current scope has priority over the top to eliminate conflicts
#   - addrmap definition: print to <def_name>_def.icl file
#   - regfile/register definitions: print to same file
#   - field definitions: flatten into the reg definition (anonymous instances)
# print all instances from low address to high
# flatten all overrides
# print def end
# If printing TOP addrmap, print read_icl for all required files to dofile
#    print each TAP addrmap to the different file

# find MI instances and populate MI & uniquification database
sub icl_process_mi
{
   my $def_path       = shift;
   my $full_inst_path = shift; # full relative path from the specified top instance
   my $mi_hash_ptr    = shift;

   foreach my $inst (@{$comp_db{$def_path}{ilist}}) {
      my $ipath = "$def_path.$inst";
      my $cpath =$inst_db{$ipath}{cpath};
      my $is_reg = ($comp_db{$cpath}{type} eq "reg");
      next if ($is_reg && ($comp_db{$cpath}{name} eq "TAP_IR"));
      if (exists $def_mi_hash{$cpath}) {
         #$mi_hash{$inst} = "$cpath";
      } elsif (exists $def_mi_hash_tmp{$cpath}) {
         #$mi_hash{$inst} = "$cpath";
         $def_mi_hash{$cpath} = 1;
      } else {
         # store inst name of first definition instantiation 
         $def_mi_hash_tmp{$cpath} = 1;
      }
   }

   # Find all MI which need to be flattened due to overrides referencing properties inside
   # add '_idx' suffix to the hash value, identifying new updated definition name
   # pessimistic - not analyzing which attributes are overridden and by which values
   #foreach my $inst (keys %mi_hash) {
   foreach my $inst (@{$comp_db{$def_path}{ilist}}) {
      my $ipath = "$def_path.$inst";
      my $cpath = $inst_db{$ipath}{cpath};
      my $is_reg = ($comp_db{$cpath}{type} eq "reg");
      next if ($is_reg && ($comp_db{$cpath}{name} eq "TAP_IR"));
      if (exists $def_mi_hash{$cpath}) { # MI definition
         my $ifpath = "$full_inst_path.$inst";
         my @matching_overrides = grep { /^${ifpath}$|^${ifpath}\./} (keys %ovrd_hash);
         foreach my $ovrd (@matching_overrides) {
            next if (exists $mi_hash_ptr -> {$inst});
            foreach my $attr (sort keys %{$ovrd_hash{$ovrd}{$def_path}}) {
               next if (!is_icl_def_attr($attr));
               my $def_name = $inst_db{$ipath}{comp};
               my $id;
               # <def_orig>_0 is the first with overridden "definition" attributes
               if (!exists $id_cnt_hash{$cpath}) {
                  $id = 0;
               } else {
                  $id = $id_cnt_hash{$cpath} + 1;
               }
               $id_cnt_hash{$cpath} = $id;
               $mi_hash_ptr -> {$inst} = "${def_name}__$id";
               print ("-I- MI instance with dynamic override for attribute $attr will be flattened (definition: $def_name, inst_path: $ifpath, new definition: ${def_name}__$id)\n");
            }
         }
      }
   }
}

# populate override hash for all instances of the current component
sub icl_populate_ovrd_hash
{
   my $def_path       = shift;
   my $full_inst_path = shift; # full relative path from the specified top instance

   if (exists $comp_db{$def_path}{ovrd}) {
      foreach my $ovrd_path (keys %{$comp_db{$def_path}{ovrd}}) {
         my $full_path = "$full_inst_path.$ovrd_path";
         #override for instance properties can exist at multiple locations/levels
         # but it must be just one for the specific property type
         foreach my $attr (keys %{$comp_db{$def_path}{ovrd}{$ovrd_path}}) {
            my $value = $comp_db{$def_path}{ovrd}{$ovrd_path}{$attr};
            $ovrd_hash{$full_path}{$def_path}{$attr} = $value;
         }
      }
   }
}

sub check_is_tap
{
   my $def_path  = shift;
   my $is_tap = 0;
   if ($comp_db{$def_path}{type} eq "addrmap") {
      foreach my $inst (@{$comp_db{$def_path}{ilist}}) {
         my $ipath = "${def_path}.$inst";
         my $cpath = $inst_db{$ipath}{cpath};
         my $inst_type = $comp_db{$cpath}{type};
         if (($inst_type eq "reg") || ($inst_type eq "regfile")) {
            $is_tap = 1;
            last;
         }
      }
   }
   return $is_tap;
}

sub check_is_regx
{
   my $def_path  = shift;
   return (($comp_db{$def_path}{type} eq "reg") || ($comp_db{$def_path}{type} eq "regfile"));
}

# final formatting of (const + [ax + by + cz ...]) formula
sub format_linear_formula
{
   my $const_member          = shift; # number
   my $param_members         = shift; # "ax + by + cz ..." string
   my $negative_first_member = shift; # for $param_members

   if ($const_member > 0) {
      if ($negative_first_member) {
         return "$const_member - $param_members";
      } else {
         return "$const_member + $param_members";
      }

   } elsif ($const_member == 0) {
      if ($negative_first_member) {
         return "-$param_members";
      } else {
         return $param_members;
      }

   } else { # negative $const_member
      if ($negative_first_member) {
         return "$const_member - $param_members";
      } else {
         my $const_member_abs = abs($const_member);
         return "$param_members - $const_member_abs";
      }
   }
}

# formatting of [ax + by + cz ...] members
sub format_param_members
{
   my $K             = shift; # new member - linear coefficient (a, b, c...)
   my $param         = shift; # new member - parameter (x, y, z...)
   my $first_member  = shift;
   # passed by reference ($_[0])
   #   $param_members # current param string
   # passed by reference ($_[1])
   #   $negative_first_member

   my $negative_first_member = 0;

   if ($K == 1) {
      if ($first_member) {
         $_[0] .= "\$$param";
      } else {
         $_[0] .= " + \$$param";
      }

   } elsif ($K > 0) {
      if ($first_member) {
         $_[0] .= "$K*\$$param";
      } else {
         $_[0] .= " + $K*\$$param";
      }

   } elsif ($K < 0) {
      my $K_abs = abs($K);
      if ($first_member) {
         $_[0] .= "$K_abs*\$$param";
         $negative_first_member = 1;
      } else {
         $_[0] .= " - $K_abs*\$$param";
      }

   } else {
      die "-E- [param_mode] Something wrong: K cannot be 0 (parameter:$param)\n";
   }

   $_[1] = $negative_first_member;
}

# Process parameter data for register/field sizes
# Should be used @ top and/or addrmap level(s)
sub icl_process_reg_param
{
   my $def_path       = shift;
   my $param_hash_ptr = shift;

   # ordered based on parameter usage for field width, lsb first
   my @all_param_list;

   if (!exists $param_comp_db{$def_path}) {
      return;
   }

   if (exists $param_comp_db{$def_path}{processed}) {
      return;
   }

   # from 0 to msb (ilist is already sorted as needed by check_all_fields())
   my @sorted_fields_lsb_first = @{$comp_db{$def_path}{ilist}};

   # Hash of found parameter and related MSB coefficients (cumulative for the current field)
   my %found_param;
   my $is_parameterized = 0;
   
   # P - parameters
   # W = Wdefault - Sum(Kf*Pfdefault) + Sum(Kf*Pf)

   my $inst_path_prev      = "";
   my $p_formula_msb_prev  = "";
   my $param_name_msb_prev = "";
   my $const_msb_prev = 0;
   my $Sum_Kmsb_prev  = 0;
   my $negative_first_member = 0;

   foreach my $f (@sorted_fields_lsb_first) {

      my $inst_path = "$def_path.$f";

      my $const_w   = $inst_db{$inst_path}{width};
      my $const_lsb = $inst_db{$inst_path}{lsb};
      my $const_msb = $inst_db{$inst_path}{msb};

      my $Sum_Kw_x_P_string   = ""; # width, all parameters, current field [string]
      my $Sum_Kmsb_x_P_string = ""; # msb,   all parameters, current field [string]

      my $Sum_Kw   = 0; # for sanity checks
      my $Sum_Kmsb = 0; # for sanity checks

      my $width_is_parameterized = 0;

      my $formula_lsb = "$const_lsb";

      # lsb=msb_prev+1, $negative_first_member is from previous msb
      if ($is_parameterized) {
         $const_lsb   = $const_msb_prev + 1;
         $formula_lsb = format_linear_formula($const_lsb,$p_formula_msb_prev,$negative_first_member);

         $param_hash_ptr -> {$inst_path} = {};

         my $field_lsb_param_name = uc($f) . "_LSB";
         $param_hash_ptr -> {$inst_path} -> {lsb_param} = $field_lsb_param_name;
         push @{$param_comp_db{$def_path}{lparam_list}}, "$field_lsb_param_name = $formula_lsb";

         #print ("DEBUG: Field $f, lsb formula $formula_lsb\n");
         if (exists $param_inst_db{$inst_path}{delta_all}{all}{lsb_delta}) {
            my $delta_all = $param_inst_db{$inst_path}{delta_all}{all}{lsb_delta};
            if ($delta_all != $Sum_Kmsb_prev) {
               die "-E- [param_mode] Sanity check failed for lsb of field $f (expected delta:$delta_all, calculated:$Sum_Kmsb_prev)\n";
            }
         }
      }

      # width parameterization
      $negative_first_member = 0;
      if (exists $param_inst_db{$inst_path}) {
         $is_parameterized = 1;
         if (!exists $param_hash_ptr -> {$inst_path}) {
            $param_hash_ptr -> {$inst_path} = {};
         }

         my $first_member = 1;
         foreach my $param (sort keys %{$param_inst_db{$inst_path}{delta_1}}) {
            if (exists $param_inst_db{$inst_path}{delta_1}{$param}{width_delta}) {
               # field width depends on that parameter
               $width_is_parameterized = 1;

               my $Pd_i  = $icl_params{$param}{default};
               my $Kw_i  = $param_inst_db{$inst_path}{delta_1}{$param}{width_delta};
               $const_w -= ($Kw_i * $Pd_i);
               $Sum_Kw  += $Kw_i; # for sanity check
               format_param_members($Kw_i,$param,$first_member,$Sum_Kw_x_P_string,$negative_first_member);

               if (!exists $found_param{$param}) {
                  $found_param{$param} = $Kw_i;
                  push @all_param_list, $param;
               } else {
                  $found_param{$param} += $Kw_i;
               }
               $first_member = 0;
            } else {
               if (!exists $found_param{$param}) {
                  die "-E- [param_mode] Something wrong: LSB of field $f depends on parameter $param but it is not used for previous (lower lsb) fields\n";
               }
            }
         }
      }
      if ($is_parameterized) {
         # width
         if ($width_is_parameterized) {

           my $formula_width = format_linear_formula($const_w,$Sum_Kw_x_P_string,$negative_first_member);
           my $field_width_param_name = uc($f) . "_SIZE";
           $param_hash_ptr -> {$inst_path} -> {width_param} = $field_width_param_name;
           push @{$param_comp_db{$def_path}{lparam_list}}, "$field_width_param_name = $formula_width";

           # sanity check
           #print ("DEBUG: Field $f, width formula $formula_width\n");
           my $delta_all = $param_inst_db{$inst_path}{delta_all}{all}{width_delta};
           if ($delta_all != $Sum_Kw) {
              die "-E- [param_mode] Sanity check failed for width of field $f (expected delta:$delta_all, calculated:$Sum_Kw)\n";
           }
         }

         # msb parameterization
         # delta_msb = delta_lsb + delta_width
         $negative_first_member = 0;
         my $first_member = 1;
         foreach my $param (@all_param_list) {
            my $Pd_i  = $icl_params{$param}{default};
            my $Kmsb_i = $found_param{$param};
            $const_msb -= ($Kmsb_i * $Pd_i);
            $Sum_Kmsb  += $Kmsb_i; # for sanity check
            format_param_members($Kmsb_i,$param,$first_member,$Sum_Kmsb_x_P_string,$negative_first_member);
            $first_member = 0;
         }

         my $formula_msb = format_linear_formula($const_msb,$Sum_Kmsb_x_P_string,$negative_first_member);
         my $field_msb_param_name = uc($f) . "_MSB";
         $param_hash_ptr -> {$inst_path} -> {msb_param} = $field_msb_param_name;
         push @{$param_comp_db{$def_path}{lparam_list}}, "$field_msb_param_name = $formula_msb";

         # sanity check
         #print ("DEBUG: Field $f, msb formula $formula_msb\n");
         if (exists $param_inst_db{$inst_path}{delta_all}{all}{msb_delta}) {
            my $delta_all = $param_inst_db{$inst_path}{delta_all}{all}{msb_delta};
            if ($delta_all != $Sum_Kmsb) {
               die "-E- [param_mode] Sanity check failed for msb of field $f (expected delta:$delta_all, calculated:$Sum_Kmsb)\n";
            }
         }
         # for next lsb
         $const_msb_prev      = $const_msb;
         $p_formula_msb_prev  = $Sum_Kmsb_x_P_string;
         $Sum_Kmsb_prev       = $Sum_Kmsb;
         $param_name_msb_prev = $field_msb_param_name;
      }
      $inst_path_prev = $inst_path;
   }
   # register width/msb
   if ($is_parameterized) {
      my $const_reg_width = $const_msb_prev + 1;
      my $formula_reg_width = format_linear_formula($const_reg_width,$p_formula_msb_prev,$negative_first_member);
      #print ("DEBUG: Register $fdef_path width=$formula_reg_width (definition:$def_path)\n");
      $param_comp_db{$def_path}{reg_msb_param_name} = $param_name_msb_prev;
      $param_comp_db{$def_path}{reg_width_formula}  = $formula_reg_width;
   }
   $param_comp_db{$def_path}{processed}  = 1;
}

# return register reset (binary string, no size/radix) and CaptureSource values (string)
# Assuming that ScanRegiser name is DR
sub get_reg_rc_values
{
   my $def_path       = shift;
   my $full_inst_path = shift;
   my $param_hash_ptr = shift;
   # reset value $_[0]
   # capture_source value $_[1]

   my $param_mode = 0;

   # initialize param hash for given register
   if (exists $param_comp_db{$def_path}) {
      $param_mode = 1;
   }

   # from msb to 0
   my @sorted_fields = reverse @{$comp_db{$def_path}{ilist}};

   my $capture_source  = "";

   my $prev_is_x     = 1;
   my $prev_is_ro    = 0;
   my $prev_is_ext   = 0;
   my $prev_is_param = 0;
   my $x_width       = 0;
   my $prev_rd_lsb   = 0;
   my $ro_width      = 0;
   my $ro_value      = "";

   my $prev_rd_lsb_str = "";

   my $first_cycle   = 1;

   my $is_ext_capture_src = 0;

   # DataInPort at REGISTER level
   if (exists $comp_db{$def_path}{DataInPort}) {
      foreach my $port_name (sort keys %{$comp_db{$def_path}{DataInPort}}) {
         my $dest = $comp_db{$def_path}{DataInPort}{$port_name}{dest};
         if ($dest eq "") {
            # Port vs. DR width is checked in the upper function
            #if (!$ext_capture_src) {
               $is_ext_capture_src = 1;
            #} else {
            #   # FIXME support different ports for different registers (MI)
            #   die "-E- Register '$def_path' has multiple CaptureSources\n";
            #}
         }
      }
   }

   my $reset_bin_value = "";
   my $reset_bin_value_tmp = "";
   my $reset_width_cnt = 0;
   my $prev_field_parameterized = 0;
   # process from msb to lsb
   foreach my $f (@sorted_fields) {
      
      my $inst_path = "$def_path.$f";
      my $fipath    = "$full_inst_path.$f";
      my $cpath     = $inst_db{$inst_path}{cpath};

      my $width;
      my $lsb;
      my $msb;

      # width/lsb/msb values & checks
      if (exists $inst_db{$inst_path}{width}) {
         $width = $inst_db{$inst_path}{width};
         if ($width <= 0) {
            die "-E- Field width must be a positive number ($inst_path)\n";
         }
      } else {
         die "-E- Field width isn't defined ($inst_path)\n";
      }
      if (exists $inst_db{$inst_path}{lsb}) {
         $lsb = $inst_db{$inst_path}{lsb};
      } else {
         die "-E- Field lsb isn't defined ($inst_path)\n";
      }
      if (exists $inst_db{$inst_path}{msb}) {
         $msb = $inst_db{$inst_path}{msb};
         if ($msb < $lsb) {
            die "-E- Field msb $msb cannot be less than lsb $lsb ($inst_path)\n";
         }
      } else {
         die "-E- Field msb isn't defined ($inst_path)\n";
      }

      # to support parameterization
      my $width_str = "$width";
      my $lsb_str   = "$lsb";
      my $msb_str   = "$msb";

      my $field_width_is_parameterized = exists $param_hash_ptr -> {$inst_path} -> {width_param};

      my $field_reset_value_hex = hex(get_field_reset_value($cpath,$inst_path,$fipath));
      # bin value is sized based on field width - used for CaptureSource calculation
      my $field_reset_bin_str   = sprintf('%0*b', $width, $field_reset_value_hex);

      # process reset value
      my $bin_value = "";
      if ($field_width_is_parameterized) {
         $width_str = "\$" . $param_hash_ptr -> {$inst_path} -> {width_param};
         if (icl_get_attr('TapFieldIsNoInit', $cpath, $fipath, 1, 1, 0) eq 'true') { # no reset value
            $bin_value = "x";
         } else { # reset 
            # "compressed" bin value
            # FIXME sprintf vs. regexp string replacement instead?
            #$bin_value = sprintf('%b', $field_reset_value_hex);
            $bin_value = $field_reset_bin_str;
            $bin_value =~ s/^0+([01])/$1/;
         }
         $bin_value = "${width_str}'b$bin_value";
         if ($reset_bin_value ne "") {
            $reset_bin_value .= ",";
         }
         if ($prev_field_parameterized || $first_cycle) {
            $reset_bin_value .= $bin_value;
         } else {
            # "compress" value
            $reset_bin_value_tmp =~ s/^0+([01])/$1/;
            $reset_bin_value_tmp =~ s/^x+([x])/$1/;
            $reset_bin_value .= "${reset_width_cnt}'b$reset_bin_value_tmp,$bin_value";
         }
         $reset_width_cnt = 0;
         $reset_bin_value_tmp = "";
         $prev_field_parameterized = 1;
      } else {
         if (icl_get_attr('TapFieldIsNoInit', $cpath, $fipath, 1, 1, 0) eq 'true') { # no reset value
            $bin_value = "x" x $width;
         } else { # reset 
            # sized value
            $bin_value = $field_reset_bin_str;
         }
         $reset_width_cnt += $width;
         $reset_bin_value_tmp .= $bin_value;
         $prev_field_parameterized = 0;
         if ($lsb == 0) {
            if ($reset_bin_value ne "") {
               $reset_bin_value .= ",";
            }
            # "compress" value
            $reset_bin_value_tmp =~ s/^0+([01])/$1/;
            $reset_bin_value_tmp =~ s/^x+([x])/$1/;
            $reset_bin_value .= "${reset_width_cnt}'b$reset_bin_value_tmp";
         }
      }

      # process capture source
      my $access_type = icl_get_attr('AccessType', $cpath, $fipath, 1, 1, 0);
      my $is_ext_field_capture_src = 0;
      # DataInPort at FIELD level
      if (exists $comp_db{$cpath}{DataInPort}) {
         foreach my $port_name (sort keys %{$comp_db{$cpath}{DataInPort}}) {
            # FIXME
            $is_ext_field_capture_src = 1;
            # Port width check
            my $port_width = 1;
            if ($port_name =~ /\[(\d+):(\d+)\]/) {
               $port_width = $1 - $2 + 1;
            }
            if ($width != $port_width) {
               die "-E- Port/Target Register field width mismatch (port $port_name: $port_width, register field $cpath: $width)\n";
            }
         }
      }

      if ($is_ext_field_capture_src) {

         if ($field_width_is_parameterized) {
            die "-E- External CaptureSource for parameterized fields isn't supported ($inst_path)\n";
         }

         if ($prev_is_x) {
            if ($x_width) {
               $capture_source .= "${x_width}'bx,";
               $x_width = 0;
            }
         } elsif ($prev_rd_lsb > 0) {
            $capture_source .= "$prev_rd_lsb],";
         } elsif ($prev_is_ro) {
            $ro_value =~ s/^0+([01])/$1/;
            $capture_source .= "${ro_width}'b$ro_value,";
            $ro_width = 0;
            $ro_value = "";
         }
         # $prev_is_ext & $prev_is_param - supported (',' is added in the end of $capture_source)
         $capture_source .= "tdr_in_$f";
         if ($lsb != 0) {
            $capture_source .= ",";
         }
         $prev_rd_lsb   = 0;
         $prev_is_x     = 0;
         $prev_is_ro    = 0;
         $prev_is_param = 0;
         $prev_is_ext   = 1;

      } else {
         
         my $lsb_is_parameterized = 0;
         my $msb_is_parameterized = 0;

         if ($param_mode) {
            if (exists $param_hash_ptr -> {$inst_path} -> {lsb_param}) {
               $lsb_str = "\$" . $param_hash_ptr -> {$inst_path} -> {lsb_param};
               $lsb_is_parameterized = 1;
            }
            if (exists $param_hash_ptr -> {$inst_path} -> {msb_param}) {
               $msb_str = "\$" . $param_hash_ptr -> {$inst_path} -> {msb_param};
               $msb_is_parameterized = 1;
            }
         }

         if (($access_type eq "\"RW\"") || ($access_type eq "\"Rsvd\"")) {
            # msb processing
            if ($prev_is_x) {
               if ($x_width) {
                  $capture_source .= "${x_width}'bx,";
                  $x_width = 0;
               }
               $capture_source .= "DR[$msb_str:";
            } elsif ($prev_is_ro) {
               $ro_value =~ s/^0+([01])/$1/;
               $capture_source .= "${ro_width}'b$ro_value,";
               $ro_width = 0;
               $ro_value = "";
               $capture_source .= "DR[$msb_str:";
            } elsif ($prev_is_ext) {
               # ',' was added already!
               $capture_source .= "DR[$msb_str:";
            } elsif ($prev_is_param && ($prev_rd_lsb == 0)) {
               # previous member isn't RW-able
               # ',' was added already!
               $capture_source .= "DR[$msb_str:";
            }
            # lsb processing
            if ($lsb == 0) {
               $capture_source .= "0]";
            } else {
               $prev_rd_lsb_str = $lsb_str;
               $prev_rd_lsb     = $lsb;
            }
            $prev_is_param = $lsb_is_parameterized;
            $prev_is_x  = 0;
            $prev_is_ro = 0;

         } else { # non-RW types

           if ($field_width_is_parameterized) {
             # complete previous member
             if ($prev_is_x) {
               if ($x_width > 0) {
                  $capture_source .= "${x_width}'bx,";
               }
             } elsif ($prev_rd_lsb > 0) {
               $capture_source .= "$prev_rd_lsb_str],";
             } elsif ($prev_is_ro) {
               $ro_value =~ s/^0+([01])/$1/;
               $capture_source .= "${ro_width}'b$ro_value,";
               $ro_width = 0;
               $ro_value = "";
             }
           }

           if (($access_type eq "\"RW/V\"") || ($access_type eq "\"RO/V\"") || ($access_type eq "\"WO\"") || 
                ($access_type eq "\"DUMMY\"") || ($access_type eq "\"Dummy\"") || ($access_type eq "\"dummy\"")) {

             if ($field_width_is_parameterized) {
               $capture_source .= "${width_str}'bx";
               if ($lsb != 0) {
                  $capture_source .= ",";
               }
               $x_width     = 0;
               $prev_is_x   = 0;
               $prev_rd_lsb = 0;
               $ro_width    = 0;
               $prev_is_param = 1;

             } else {

               if ($prev_is_x) {
                 $x_width += $width;
               } elsif ($prev_rd_lsb > 0) {
                 $capture_source .= "$prev_rd_lsb_str],";
                 $x_width = $width;
               } elsif ($prev_is_ro) {
                 $ro_value =~ s/^0+([01])/$1/;
                 $capture_source .= "${ro_width}'b$ro_value,";
                 $ro_width = 0;
                 $ro_value = "";
                 $x_width = $width;
               } elsif ($prev_is_ext) {
                 $x_width = $width;
               } elsif ($prev_is_param) {
                 $x_width = $width;
               } else {
                 die "-E- AccessType processing error for field $cpath ($fipath)\n";
               } 
               if ($lsb == 0) {
                 $capture_source .= "${x_width}'bx";
               }
               $prev_rd_lsb = 0;
               $prev_is_x   = 1;
               $prev_is_ro  = 0;
               $prev_is_param = 0;
             } 

           } elsif ($access_type eq "\"RO\"") {

             if ($field_width_is_parameterized) {
               $ro_value = $field_reset_bin_str;
               $ro_value =~ s/^0+([01])/$1/;
               $capture_source .= "${width_str}'b$ro_value";
               if ($lsb != 0) {
                  $capture_source .= ",";
               }
               $ro_width    = 0;
               $ro_value    = "";

               $x_width     = 0;
               $prev_is_x   = 0;
               $prev_rd_lsb = 0;
               $prev_is_param = 1;

             } else {

               if ($prev_is_ro) {
                 $ro_value .= $field_reset_bin_str;
                 $ro_width += $width;
               } else {
                 if ($prev_is_x) {
                   if ($x_width) {
                     $capture_source .= "${x_width}'bx,";
                     $x_width = 0;
                   }
                 } elsif ($prev_rd_lsb > 0) {
                   $capture_source .= "$prev_rd_lsb_str],";
                 } elsif ($prev_is_ext) {
                 } elsif ($prev_is_param) {
                 } else {
                    die "-E- AccessType processing error for field $cpath ($fipath)\n";
                 }
                 $ro_value = $field_reset_bin_str;
                 $ro_width = $width;
               }
               if ($lsb == 0) {
                 $ro_value =~ s/^0+([01])/$1/;
                 $capture_source .= "${ro_width}'b$ro_value";
               }

               $prev_rd_lsb = 0;
               $prev_is_x   = 0;
               $prev_is_ro  = 1;
             }
           } else {
            die "-E- Incorrect AccessType $access_type for field $cpath ($fipath)\n";
           }
         }
      }
      $first_cycle = 0;
   } # foreach field

   if ($is_ext_capture_src) {
     $capture_source = "tdr_in";
   }
   
   $_[0] = $reset_bin_value;
   $_[1] = $capture_source;
}

# returns field reset value in hex. Also checks for duplicated overrides
sub get_field_reset_value
{
   my $cpath     = shift;
   my $inst_path = shift;
   my $fipath    = shift;

   my $value = "0"; #default

   if (exists $ovrd_hash{$fipath}) {
      my %all_overrides;
      foreach my $ovrd_def_path (keys %{$ovrd_hash{$fipath}}) {
         foreach my $attr (keys %{$ovrd_hash{$fipath}{$ovrd_def_path}}) {
            if (exists $all_overrides{$attr}) {
               die "-E- Duplicated override of property '$attr' for instance '$fipath'\n";
            } elsif ($attr eq "reset") {
               $value = $ovrd_hash{$fipath}{$ovrd_def_path}{$attr};
               delete $ovrd_hash{$fipath}{$ovrd_def_path}{$attr};
               $all_overrides{$attr} = 1;
            }
         }
      }
   } elsif (exists $inst_db{$inst_path}{reset}) {
      $value = $inst_db{$inst_path}{reset};
   } elsif (exists $comp_db{$cpath}{attr}{reset}) {
      $value = $comp_db{$cpath}{attr}{reset};
   } elsif (exists $comp_db{$cpath}{default}{reset}) {
      $value = $comp_db{$cpath}{default}{reset}; # FIXME check hex format
   }
   return $value;
}

sub assign_port_name
{
   my $intf_id    = shift;
   my $port_group = shift;
   my $port_type  = shift;

   my $assigned_already = 0;
   my $status = 0;

   # 3rd argument is variable to assign - $_[0] after two sifts
   my $found_match = 0;
   my $matched_port_name;

   # assigning Intel-specific ports - reset, security, etc
   #  - take the first found with the matching functionality
   # FIXME: add check for conflicting definitions?
   if (($port_group ne "tap") && ($port_group ne "scan")) {
      foreach my $port_name (keys %{$icl_comp_db{$gIclModulePath}{port}{$port_type}}) {
         if (exists $icl_comp_db{$gIclModulePath}{port}{$port_type}{$port_name}{intel_type}) {
            if ($icl_comp_db{$gIclModulePath}{port}{$port_type}{$port_name}{intel_type} eq $port_group) {
               print("-I- Mapping port $port_type $port_name based on intel signal type '$port_group')\n");
               $found_match = 1;
               $matched_port_name = $port_name;
               last;
            }
         }
      }
   }

   # FIXME review
   if ((defined $intf_id) && exists $icl_comp_db{$gIclModulePath}{interface}{$intf_id}) {
      if (exists $icl_comp_db{$gIclModulePath}{interface}{$intf_id}{map}{$port_type}) {
         my $port_name = "";
         # FIXME: returning the first element in the list for Scan In/Out ports
         if (($port_type eq "ScanInPort") || ($port_type eq "ScanOutPort")) {
            $port_name = $icl_comp_db{$gIclModulePath}{interface}{$intf_id}{map}{$port_type}[0];
         } else {
            $port_name = $icl_comp_db{$gIclModulePath}{interface}{$intf_id}{map}{$port_type};
         }
         $_[0] = $port_name;
         $status = 1;
         if (exists $icl_comp_db{$gIclModulePath}{port}{$port_type}{$port_name}{assigned}) {
            $assigned_already = 1;
         } else {
            $icl_comp_db{$gIclModulePath}{port}{$port_type}{$port_name}{assigned} = 1;
         }
      }
   }
   if (!$status && exists $icl_comp_db{$gIclModulePath}{port}{$port_type}) {
      if ($found_match) {
         if (exists $icl_comp_db{$gIclModulePath}{port}{$port_type}{$matched_port_name}) {
            $_[0] = $matched_port_name;
            $status = 1;
            if (exists $icl_comp_db{$gIclModulePath}{port}{$port_type}{$matched_port_name}{assigned}) {
               $assigned_already = 1;
            } else {
               $icl_comp_db{$gIclModulePath}{port}{$port_type}{$matched_port_name}{assigned} = 1;
            }
         }
      } else {
         my @port_names = keys %{$icl_comp_db{$gIclModulePath}{port}{$port_type}};
         if ((scalar(@port_names) == 1) && (grep {/^$port_group$/} ('tap','scan','powergood','tlr'))) { # single port/allowed matched based on single option
            my $port_name = $port_names[0];
            # FIXME: duplicated check (another one is in the end of the procedure) ?
            if (exists $icl_comp_db{$gIclModulePath}{port}{$port_type}{$port_name}{assigned}) {
               # ports with single allowed assignment
               if (grep {/^$port_type$/} ('SelectPort','ToSelectPort','ToTMSPort','ToTCKPort','ToTRSTPort',
                                         'ToResetPort','ToClockPort','DataOutPort','ToIRSelectPort')) {
                  die "-E- Port assignment conflict for $port_type $port_name\n";
               } elsif (grep {/^$port_type$/} ('ResetPort', 'ToResetPort') ) {
                  print("-I- No certain criteria for mapping: not assigned port for port type $port_type (interface $intf_id, group $port_group), skipping assignment and will use default name if needed\n");
                  return 0;
               }
            }
            print("-I- Assigning port $port_type $port_name based on port type (no mapping in ScanInterface)\n");
            $_[0] = $port_name;
            $status = 1;
            if (exists $icl_comp_db{$gIclModulePath}{port}{$port_type}{$port_name}{assigned}) {
               $assigned_already = 1;
            } else {
               $icl_comp_db{$gIclModulePath}{port}{$port_type}{$port_name}{assigned} = 1;
            }
         } elsif (grep {/^$port_type$/} ('TCKPort','TRSTPort')) {
            $_[0] = $port_names[0];
            $icl_comp_db{$gIclModulePath}{port}{$port_type}{$port_names[0]}{assigned} = 1;
            $status = 1;
         } else {
            print("-I- No certain criteria for mapping port type $port_type (group $port_group), skipping assignment and will use default name if needed\n");
         }
      }
   } elsif (!$status) {
      warn "-W- No option exists for port type $port_type (group $port_group), will use default name if needed\n";
   }
   if ($assigned_already) {
      if ((grep {/^$port_type$/} ('ScanOutPort','DataOutPort','SelectPort')) ||
         ($port_type =~ /^To/)) {
         die "-E- Not allowed multiple mappings for port(s) of type ScanOutPort, DataOutPort, SelectPort, To*Port\n";
      }
   }
   return $status;
}

sub icl_print_header
{
   my $ofile    = shift;
   my $current_time = localtime();
   print $ofile ("// ICL  : generated by tap_icl_gen.pl version $gVersion\n");
   print $ofile ("// TIME : $current_time\n\n");
}

# FIXME print in order
sub icl_print_attr
{
   my $def_path       = shift;
   my $full_inst_path = shift;
   my $ofile          = shift;
   my $e_indent       = shift;
   my $apply_ovrd     = shift;
   my $is_inst        = shift;
   my $is_top         = shift;

   my @attr_list    = sort {get_property_group($a) <=> get_property_group($b)} keys %{$comp_db{$def_path}{attr}};
   my @default_list = sort {get_property_group($a) <=> get_property_group($b)} keys %{$comp_db{$def_path}{default}};
   my $comp_type = $comp_db{$def_path}{type};
   my @ovrd_list = ();
   my %printed_attr = ();
   my $indent = ($e_indent) ? "${text_indent}${text_indent}" : $text_indent;
   $indent = "${text_indent}$indent" if ($comp_type eq "field");

   # $apply_ovrd indicates that definition isn't MI and all existing overrides
   # can be pushed to the definition level
   if (exists $ovrd_hash{$full_inst_path} && $apply_ovrd) {
      #my $print_ovrd_comment = 1;
      my %all_overrides;
      foreach my $ovrd_def_path (keys %{$ovrd_hash{$full_inst_path}}) {
         foreach my $attr (sort keys %{$ovrd_hash{$full_inst_path}{$ovrd_def_path}}) {
            #print("-DEBUG- (INST=$is_inst) Overridden inst . def path:attribute: $full_inst_path . $ovrd_def_path : $attr");
            if (exists $all_overrides{$attr}) {
               die "-E- Duplicated override of property '$attr' for instance '$full_inst_path'\n";
            # FIXME
            #} elsif ($attr ne "reset" && !is_inst_ovrd_attr($attr)) {
            } elsif ($attr ne "reset") {
               #if ($print_ovrd_comment) {
               #   print $ofile ("${indent}// overrides:\n");
               #   $print_ovrd_comment = 0;
               #}
               # FIXME: not sorted for now
               # FIXME: ICL RegOpcode
               # Print: Attribute intel_<attr> = "reg description";
               # FIXME: replace with hash
               #if (grep {/^$attr$/} (@icl_attr_list)) {
               if ((is_icl_def_attr($attr) && !$is_inst) || 
                  (is_icl_inst_attr($attr) && $is_inst)) {
                  my $str_value = icl_transform_value($attr,$ovrd_hash{$full_inst_path}{$ovrd_def_path}{$attr});
                  print $ofile ("${indent}Attribute intel_${attr} = $str_value;\n");
                  delete $ovrd_hash{$full_inst_path}{$ovrd_def_path}{$attr};
                  $printed_attr{$attr} = 1;
                  #print(", value: $str_value\n");
               } else {
                  #print(" - not printed out\n");
               }
            }
            $all_overrides{$attr} = 1;
         }
      }
      #if (! $print_ovrd_comment) {
      #   print $ofile ("${indent}// end of overrides\n");
      #}
   }

   foreach my $attr (@attr_list) {
      next if (exists $printed_attr{$attr});
      next if is_not_print_attr($attr);
      #if (grep {/^$attr$/} (@icl_attr_list)) {
      # FIXME
      #print("-DEBUG- (INST=$is_inst) Definition attribute inst . def path:attribute: $full_inst_path . $def_path : $attr");
      if ((!$is_inst && is_icl_def_attr($attr)) || 
         (($is_inst || $is_top) && is_icl_inst_attr($attr))) {
         my $str_value = icl_transform_value($attr,$comp_db{$def_path}{attr}{$attr});
         print $ofile ("${indent}Attribute intel_${attr} = $str_value;\n");
         #print(", value: $str_value\n");
         $printed_attr{$attr} = 1;
      } else {
         #print(" - not printed out\n");
      }
   }

   foreach my $attr (@default_list) {
      next if (exists $printed_attr{$attr});
      next if (is_not_print_attr($attr));
      next if (! is_comp_attr($comp_type, $attr));
      #if (grep {/^$attr$/} (@icl_attr_list)) {
      #print("-DEBUG- (INST=$is_inst) Default attribute inst . def path:attribute: $full_inst_path . $def_path : $attr");
      if ((!$is_inst && is_icl_def_attr($attr)) || 
         ($is_inst && is_icl_inst_attr($attr))) {
         my $str_value = icl_transform_value($attr,$comp_db{$def_path}{default}{$attr});
         print $ofile ("${indent}Attribute intel_${attr} = $str_value;\n");
         #print(", value: $str_value\n");
      } else {
         #print(" - not printed out\n");
      }
      $printed_attr{$attr} = 1;
   }
}

sub icl_get_attr
{
   my $attr_name      = shift;
   my $def_path       = shift;
   my $full_inst_path = shift;
   my $allow_default  = shift;
   my $apply_ovrd     = shift;
   my $no_error       = shift;

   my $comp_type = $comp_db{$def_path}{type};

   if (!is_comp_attr($comp_type, $attr_name)) {
     die "-E- Attribute '$attr_name' cannot be specified for instance '$full_inst_path' of type $comp_type (definition: $def_path)\n";
   }

   my $ovrd_applied = 0;

   # $apply_ovrd indicates that definition isn't MI and all existing overrides
   # can be pushed to the definition level
   if (exists $ovrd_hash{$full_inst_path} && $apply_ovrd) {
      my $value;
      foreach my $ovrd_def_path (keys %{$ovrd_hash{$full_inst_path}}) {
         if (exists $ovrd_hash{$full_inst_path}{$ovrd_def_path}{$attr_name}) {
            if ($ovrd_applied) {
               die "-E- Duplicated override of property '$attr_name' for instance '$full_inst_path'\n";
            } elsif ($attr_name ne "reset") {
               $value = $ovrd_hash{$full_inst_path}{$ovrd_def_path}{$attr_name};
               $ovrd_applied = 1;
            }
         }
      }
      return icl_transform_value($attr_name,$value) if ($ovrd_applied);
   }

   if (exists $comp_db{$def_path}{attr}{$attr_name}) {
      return icl_transform_value($attr_name,$comp_db{$def_path}{attr}{$attr_name});
   }

   if ($allow_default) {
      if (exists $comp_db{$def_path}{default}{$attr_name}) {  
         return icl_transform_value($attr_name,$comp_db{$def_path}{default}{$attr_name});
      } elsif (check_property_default($attr_name)) {
         if (get_property_type($attr_name) eq 'b') { #boolean
            return get_property_default($attr_name);
         } else {
            return icl_transform_value($attr_name, get_property_default($attr_name));
         }
      }
   }

   if ($no_error) {
      return "";
   } else {
      die "-E- No value found for attribute '$attr_name' for instance '$full_inst_path'\n";
   }
}

### =================================================================
# Writer API
# General RDL structure
#
# design_top.rdl
#   including all addrmap definitions
#   addrmap top {
#     <inst TAP>
#     <TAP inst overrides (if any)>
#   };
#
# tap.rdl
# addrmap TAP {
#    <TAP properties>
#    <register definitions>
#    <register instances>
#    <register overrides (if any)>
# }
# <register definitions>: reg | regfile

# FIXME: differentiate between printing definition and instance definition with overrides

# print header
# print def start
# print main properties
# print properties with non-default values
#   - If any, inst level properties as a separate block
# print req'ed defs from current scope
# print additional req'ed defs from scope above
#   - Current scope has priority over the top to eliminate conflicts
#   - addrmap definition: print to separate <def_name>_def.rdl file
#   - regfile/register definitions: print to separate <def_name>_def_regs.rdl file
#   - field definitions: flatten into the reg definition (anonymous instances)
# print all instances from low address to high
# print all overrides (FIXME: support push-down)
# print def end
# If printing TOP addrmap, include all files with TAP addrmap definitions;
#    print each TAP addrmap to the different file
sub print_comp
{
   my $def_path  = shift;
   my $full_inst_path = shift; # full relative path from the specified top instance
   my $ofile     = shift;
   my $base_name = shift;
   my $same_file = shift;
   my $apply_ovrd = shift;

   my $comp_type = $comp_db{$def_path}{type};

   if ($gDesignType ne "tap" && $gDesignType ne "stf") {
      die "-E- RDL writer isn't implemented for '$gDesignType' yet\n";
   }
   if ($comp_type eq "addrmap") {
      %included_defs = ();
   } 
   my $extra_indent = ($comp_type ne "regfile" && $same_file);
   # local for that specific definition
   my %mi_hash;
   my %def_hash;
   
   # populate global override db
   if (exists $comp_db{$def_path}{ovrd}) {
      foreach my $ovrd_path (keys %{$comp_db{$def_path}{ovrd}}) {
         my $full_path = "$full_inst_path.$ovrd_path";
         #override for instance properties can exist at multiple locations/levels
         # but it must be just one for the specific property type
         foreach my $attr (keys %{$comp_db{$def_path}{ovrd}{$ovrd_path}}) {
            my $value = $comp_db{$def_path}{ovrd}{$ovrd_path}{$attr};
            $ovrd_hash{$full_path}{$def_path}{$attr} = $value;
         }
      }
   }

   # populate local MI db
   foreach my $inst (@{$comp_db{$def_path}{ilist}}) {
      my $ipath = "$def_path.$inst";
      my $def_name =$inst_db{$ipath}{comp};
      if (exists $def_hash{$def_name}) {
         $mi_hash{$inst} = 1;
      } else {
         $def_hash{$def_name} = 1;
      }
   }
   
   # print reg definitions for MI instances inside regfile
   if ($comp_type eq "regfile" && $same_file) {
      my $is_printed = 0;
      foreach my $reg_inst (keys %mi_hash) {
         my $ipath = "$def_path.$reg_inst";
         my $def_name =$inst_db{$ipath}{comp};
         if (! exists $included_defs{$def_name}) {
            print_comp($inst_db{$ipath}{cpath},$full_inst_path,$ofile, $base_name,0, 0);
            $included_defs{$def_name} = 1;
            $is_printed = 1;
         }
      }
      if ($is_printed) { #FIXME
         print $ofile ("//---------------------------\n");
      }
   }
   
   if ($full_inst_path eq "") {
      print_header($ofile);
      my $udp_file;
      if ($gDesignType eq "tap") {
         $udp_file = "tap_udp.rdl";
      } elsif ($gDesignType eq "stf") {
         $udp_file = "stf_udp.rdl";
      } else {
         die "-E- Writing of $gDesignType isn't supported yet\n";
      }
      print $ofile ("`include \"$udp_file\"\n\n");
   }; 

   print_start_comp($def_path, $ofile,$extra_indent);
   # attr override in that definition from upper level/addrmap if 
   #   no MI && property isn't in %inst_ovrd_properties list
   # if overridden, delete the "used" entry in %ovrd_hash
   print_attr($def_path, $full_inst_path, $ofile,$extra_indent,$apply_ovrd);
   # push down any overrides from that level if it is regfile, reg, field
   #  - for addrmap, push down only properties not in %inst_ovrd_properties list
   print_inst($def_path, $full_inst_path, $ofile,$base_name,$same_file,\%mi_hash);
   print_end_comp($def_path, $ofile,$extra_indent);
}

# used to print fields and non-MI registers inside regfiles
sub print_anonymous_inst
{
   my $def_path  = shift;
   my $inst_path = shift;
   my $full_inst_path = shift; # full relative path from the specified top instance
   my $ofile     = shift;
   my $extra_indent = shift;
   my $apply_ovrd = shift;
   my $comp_type = $comp_db{$def_path}{type};

   # local for that specific definition
   my %mi_hash;
   my %def_hash;
   
   # populate global override db
   if (exists $comp_db{$def_path}{ovrd}) {
      foreach my $ovrd_path (keys %{$comp_db{$def_path}{ovrd}}) {
         my $full_path = "$full_inst_path.$ovrd_path";
         #override for instance properties can exists from multiple locations/levels
         # but it must be just one for the specific property
         foreach my $attr (keys %{$comp_db{$def_path}{ovrd}{$ovrd_path}}) {
            my $value = $comp_db{$def_path}{ovrd}{$ovrd_path}{$attr};
            $ovrd_hash{$full_path}{$def_path}{$attr} = $value;
         }
      }
   }

   # populate local MI db
   foreach my $inst (@{$comp_db{$def_path}{ilist}}) {
      my $ipath = "$def_path.$inst";
      my $def_name =$inst_db{$ipath}{comp};
      if (exists $def_hash{$def_name}) {
         $mi_hash{$inst} = 1;
      } else {
         $def_hash{$def_name} = 1;
      }
   }

   print_start_icomp($def_path, $ofile,$extra_indent);
   # attr override in that instance from upper level/addrmap if 
   #   no MI of upper level definition && property isn't in @inst_ovrd_properties list
   # if overridden, delete the "used" entry in %ovrd_hash
   print_attr($def_path, $full_inst_path, $ofile,$extra_indent,$apply_ovrd);
   # push down any overrides from that level if it is regfile, reg, field
   #  - print_anonymous_inst isn't expected to be used for addrmap
   print_inst($def_path, $full_inst_path, $ofile,"",$extra_indent,\%mi_hash);
   print_end_icomp($inst_path, $full_inst_path, $ofile,$extra_indent);
}

sub icl_uniquify_def_name
{
   my $def_name    = shift;
   my $inst_name   = shift;
   my $base_name   = shift;
   my $mi_hash_ptr = shift;

   my $inst_def_name = "$base_name$gUniq_Delimiter";

   if (exists $mi_hash_ptr -> {$inst_name}) {
      $inst_def_name .= $mi_hash_ptr -> {$inst_name};
   } else {
      $inst_def_name .= $def_name;
   }
   return $inst_def_name;
}

sub icl_add_prefix_suffix
{
   my $inst_def_name   = shift;

   $inst_def_name = "${gUniq_Prefix}_$inst_def_name" if ($add_prefix);
   $inst_def_name = "${inst_def_name}_$gUniq_Suffix" if ($add_suffix);

   return $inst_def_name;
}

sub icl_print_top
{
   my $def_path       = shift;
   my $full_inst_path = shift; # full relative path from the specified top instance
   my $ofile          = shift;
   my $base_name      = shift;
   my $new_def_name   = shift;

   if ($gDesignType ne "tap") {
      die "-E- ICL writer does not support '$gDesignType'\n";
   }

   my $comp_type = $comp_db{$def_path}{type};
   if ($comp_type ne "addrmap") {
      die "-E- Top level component $def_path is not an addrmap (actual type: $comp_type)\n";
   }

   %included_defs = ();

   # local for that specific definition!
   my %mi_hash;
   
   # populate global override db
   icl_populate_ovrd_hash($def_path,$full_inst_path);

   # populate MI db and mark instances/definitions which require uniquification
   icl_process_mi($def_path,$full_inst_path,\%mi_hash);

   my $is_reg_only   = 0;
   my $reg_only_inst = "";

   my $is_tap_addrmap   = 0;
   my $is_top_addrmap   = 0;
   my @tap_addrmap_list = ();

   my $security_exists         = 0;
   my $security_unlock         = 0;
   my $security_red_exists     = 0;
   my $security_orange_exists  = 0;
   my $security_green_exists   = 0;
   my %taps_with_security  = ();
   my %taps_with_slvidcode = ();

   my $pwrgood_id = "";

   # check if $inst reg or regfile to identify current component as tap
   # populate security and reset info
   foreach my $inst (@{$comp_db{$def_path}{ilist}}) {
      my $ipath     = "$def_path.$inst";
      my $cpath     = $inst_db{$ipath}{cpath};
      my $fpath     = ".$inst";
      my $def_name  = $inst_db{$ipath}{comp};
      my $comp_type = $comp_db{$cpath}{type};
      if (($comp_type eq "reg") || ($comp_type eq "regfile")) {
        my $is_reg_only_tmp = 0;
        if ($is_top_addrmap) {
           die "-E- TOP addrmap definition cannot have instance of other type than addrmap (type: $comp_type, parent addrmap: $def_path, instance $inst)\n";
        } elsif (!$is_tap_addrmap) {
           $is_reg_only = (icl_get_attr('TapType', $def_path, "", 1, 1, 0) eq "\"reg_only\"");
           $is_reg_only_tmp = $is_reg_only;
           my $def_type = ($is_reg_only) ? "reg_only" : "TAP" ;
           print ("-I- Found $def_type definition $def_path\n");
           $is_tap_addrmap = 1;
           if (!$is_reg_only) {
              $comp_db{$def_path}{trst} = 1;
           }
        }
        if (!$security_exists && !$is_reg_only) {
           # Enable security interface only if red|orange opcodes exists
           my $opcode_security = icl_get_attr('TapOpcodeSecurityLevel', $cpath, ".$inst", 1, 1, 0);
           if ($opcode_security =~ /SECURE_RED/) {
              $security_exists = 1;
              $security_red_exists = 1;
           } elsif ($opcode_security =~ /SECURE_ORANGE/) {
              $security_exists = 1;
              $security_orange_exists = 1;
           } elsif ($opcode_security =~ /SECURE_GREEN/) {
              # FIXME: not setting $security_exists -
              #    no need for security logic in ICL
              $security_green_exists = 1;
           }
        }
        if ($comp_type eq "regfile") {
           # Check if regfile is IJTAG chain
           my $is_ijtag_1 = (icl_get_attr('TapRegType', $cpath, ".$inst", 1, 1, 1) eq "\"IJTAG\"");
           my $is_ijtag_2 = 0;
           my $sib_reg_inst = "";
           # populate global override db for that instance
           icl_populate_ovrd_hash($cpath,$fpath);
           foreach my $sub_inst (@{$comp_db{$cpath}{ilist}}) {
              my $sub_ipath     = "$cpath.$sub_inst";
              my $sub_cpath     = $inst_db{$sub_ipath}{cpath};
              my $sub_fpath     = "$fpath.$sub_inst";
              my $sub_def_name  = $inst_db{$sub_ipath}{comp};
              my $sub_comp_type = $comp_db{$sub_cpath}{type};
              if ($sub_comp_type ne "reg") {
                die "-E- Regfile component can have only instances of reg (regfile: $cpath, instance $sub_inst, instance_type $sub_comp_type)\n";
              }

              # Populate powergood/tlr/trst info based on data in RDL
              populate_reset_info($ipath, $sub_ipath, $sub_fpath, 0, $is_reg_only_tmp);

              # Check if regfile has SIB bits
              if (icl_get_attr('TapRegType', $sub_cpath, $sub_fpath, 1, 1, 1) eq "\"SIB\"") {
                 $is_ijtag_2 = 1;
                 $sib_reg_inst = $sub_inst;
              }

           }
           if ($is_ijtag_1) {
              if ($is_ijtag_2) {
                 $inst_db{$ipath}{is_ijtag} = 1;
                 if (!exists $inst_db{$ipath}{tlr}) {
                    $inst_db{$ipath}{tlr} = 1;
                 }
                 if (!exists $comp_db{$cpath}{tlr}) {
                    $comp_db{$cpath}{tlr} = 1;
                 }
              } else {
                 die "-E- Regfile component with TapRegType == \"IJTAG\" must have at least one reg with TapRegType == \"SIB\" (regfile: '$cpath')\n";
              }
           } else {
              if ($is_ijtag_2) {
                 die "-E- Regfile component with TapRegType != \"IJTAG\" cannot have reg with TapRegType == \"SIB\" (regfile: '$cpath', reg '$sib_reg_inst')\n";
              }
           }
           # propagate reset info to the upper (top) level
           foreach my $pwr_id (keys %{$inst_db{$ipath}{pwrgood_id}}) {
              if (!exists $comp_db{$def_path}{pwrgood_id}) {
                 $comp_db{$def_path}{pwrgood_id} = {};
              }
              if (!exists $comp_db{$def_path}{pwrgood_id}{$pwr_id}) {
                 $comp_db{$def_path}{pwrgood_id}{$pwr_id} = {};
              }
           }
           if (exists $inst_db{$ipath}{tlr} &&
                 !exists $comp_db{$def_path}{tlr}) {
              $comp_db{$def_path}{tlr} = 1;
           }
           if (exists $inst_db{$ipath}{trst} &&
                 !exists $comp_db{$def_path}{trst}) {
              $comp_db{$def_path}{trst} = 1;
           }
        } else { #reg
           if ($comp_db{$cpath}{name} ne "TAP_IR") {
              # Populate powergood/tlr/trst info based on data in RDL
              populate_reset_info($def_path, $ipath, $fpath, 1, $is_reg_only_tmp);
           }

        }
      } elsif ($comp_db{$cpath}{type} eq "addrmap") {
        print ("-I- Found TOP definition $def_path\n") if (!$is_top_addrmap);
        if ($is_tap_addrmap) {
           die "-E- TOP addrmap definition cannot have instances of both registers/regfiles and addrmaps  (addrmap: $def_path, instance $inst)\n";
        }
        $is_top_addrmap = 1;

        my $is_reg_only_inst = (icl_get_attr('TapType', $cpath, ".$inst", 1, 1, 0) eq "\"reg_only\"");
        if ($is_reg_only && $is_reg_only_inst) {
           die "-E- Only one reg_only addrmap instance is supported (conflicting instances '$reg_only_inst', '$inst')\n";
        } elsif ($is_reg_only_inst) {
           $is_reg_only = 1;
           $reg_only_inst = $inst;
        } else {
           push @tap_addrmap_list, $inst;
           # Mark that TRST port is required
           $inst_db{$ipath}{trst} = 1;
           if (!exists $comp_db{$def_path}{trst}) {
              $comp_db{$def_path}{trst} = 1;
           }
        }

        # populate global override db for that instance (for TAPs and reg_only levels)
        icl_populate_ovrd_hash($cpath,$fpath);

        #check if component instance is parameterized
        # propagate parameters to the top level if necessary
        if (exists $param_comp_db{$cpath}) {
           if (!exists $param_comp_db{$def_path}) {
              $param_comp_db{$def_path} = {};
           }
           if (!exists $param_comp_db{$def_path}{param}) {
              $param_comp_db{$def_path}{param} = {};
           }
           my @param_list = keys %{$param_comp_db{$cpath}{param}};
           foreach my $param (@param_list) {
              if (!exists $param_comp_db{$def_path}{param}{$param}) {
                 $param_comp_db{$def_path}{param}{$param} = $param_comp_db{$cpath}{param}{$param};
              }
           }
        }

        # Check if some TAP register has RED or ORANGE security
        foreach my $sub_inst (@{$comp_db{$cpath}{ilist}}) {
           my $sub_ipath     = "$cpath.$sub_inst";
           my $sub_cpath     = $inst_db{$sub_ipath}{cpath};
           my $sub_fpath     = "$fpath.$sub_inst";
           my $sub_def_name  = $inst_db{$sub_ipath}{comp};
           my $sub_comp_type = $comp_db{$sub_cpath}{type};
           if ($sub_comp_type eq "addrmap") {
              die "-E- More than two levels of addrmap hierarchy are not supported\n";
           }
           if ($is_reg_only_inst && (exists  $inst_db{"$def_path.$sub_inst"})) {
              die "-E- Register instance name $sub_inst conflicts with TAP instance name\n";
           }

           # FIXME no support SIB level security for now
           if (!$is_reg_only_inst && !exists $taps_with_security{$inst}) {
              my $opcode_security = icl_get_attr('TapOpcodeSecurityLevel', $sub_cpath, $sub_fpath, 1, 1, 0);
              if ($opcode_security =~ /SECURE_RED/) {
                 $security_exists = 1;
                 $taps_with_security{$inst} = 0;
                 $security_red_exists = 1;
              } elsif ($opcode_security =~ /SECURE_ORANGE/) {
                 $security_exists = 1;
                 $taps_with_security{$inst} = 0;
                 $security_orange_exists = 1;
              } elsif ($opcode_security =~ /SECURE_GREEN/) {
                 # FIXME: (revisit) not setting $security_exists -
                 #    no need for security logic in ICL
                 $security_green_exists = 1;
              }
           }
           if ($sub_comp_type eq "regfile") {
              # Check if regfile is IJTAG chain
              my $is_ijtag_1 = (icl_get_attr('TapRegType', $cpath, ".$inst", 1, 1, 1) eq "\"IJTAG\"");
              my $is_ijtag_2 = 0;
              my $sib_reg_inst = "";
              # populate global override db for that instance
              icl_populate_ovrd_hash($sub_cpath,$sub_fpath);
              foreach my $sub2_inst (@{$comp_db{$sub_cpath}{ilist}}) {
                 my $sub2_ipath     = "$sub_cpath.$sub2_inst";
                 my $sub2_cpath     = $inst_db{$sub2_ipath}{cpath};
                 my $sub2_fpath     = "$sub_fpath.$sub2_inst";
                 my $sub2_def_name  = $inst_db{$sub2_ipath}{comp};
                 my $sub2_comp_type = $comp_db{$sub2_cpath}{type};
                 if ($sub2_comp_type ne "reg") {
                   die "-E- Regfile component can have only instances of reg (regfile: $sub_cpath, instance $sub2_inst, instance_type $sub2_comp_type)\n";
                 }

                 # Populate powergood/tlr/trst info based on data in RDL
                 populate_reset_info($sub_ipath, $sub2_ipath, $sub2_fpath, 0, 0);

                 # Check if regfile has SIB bits
                 if (icl_get_attr('TapRegType', $sub2_cpath, $sub2_fpath, 1, 1, 1) eq "\"SIB\"") {
                    $is_ijtag_2 = 1;
                    $sib_reg_inst = $sub2_inst;
                 }
              }
              if ($is_ijtag_1) {
                 if ($is_ijtag_2) {
                    $inst_db{$sub_ipath}{is_ijtag} = 1;
                    if (!exists $inst_db{$sub_ipath}{tlr}) {
                       $inst_db{$sub_ipath}{tlr} = 1;
                    }
                    if (!exists $comp_db{$sub_cpath}{tlr}) {
                       $comp_db{$sub_ipath}{tlr} = 1;
                    }
                 } else {
                    die "-E- Regfile component with TapRegType == \"IJTAG\" must have at least one reg with TapRegType == \"SIB\" (regfile: '$sub_cpath')\n";
                 }
              } else {
                 if ($is_ijtag_2) {
                    die "-E- Regfile component with TapRegType != \"IJTAG\" cannot have reg with TapRegType == \"SIB\" (regfile: '$sub_cpath', reg '$sib_reg_inst')\n";
                 }
              }
              foreach my $pwr_id (keys %{$inst_db{$sub_ipath}{pwrgood_id}}) {
                 if (!exists $inst_db{$ipath}{pwrgood_id}) {
                    $inst_db{$ipath}{pwrgood_id} = {};
                 }
                 if (!exists $comp_db{$cpath}{pwrgood_id}) {
                    $comp_db{$cpath}{pwrgood_id} = {};
                 }
                 if (!exists $inst_db{$ipath}{pwrgood_id}{$pwr_id}) {
                    $inst_db{$ipath}{pwrgood_id}{$pwr_id} = 1;
                 }
                 if (!exists $comp_db{$cpath}{pwrgood_id}{$pwr_id}) {
                    $comp_db{$cpath}{pwrgood_id}{$pwr_id} = {};
                 }
              }
              if (exists $inst_db{$sub_ipath}{tlr} &&
                    !exists $inst_db{$ipath}{tlr}) {
                 $inst_db{$ipath}{tlr} = 1;
              }
              if (exists $inst_db{$ipath}{tlr} &&
                    !exists $comp_db{$cpath}{tlr}) {
                 $comp_db{$cpath}{tlr} = 1;
              }
              if (exists $inst_db{$sub_ipath}{trst} &&
                    !exists $inst_db{$ipath}{trst}) {
                 $inst_db{$ipath}{trst} = 1;
              }
              if (exists $inst_db{$ipath}{trst} &&
                    !exists $comp_db{$cpath}{trst}) {
                 $comp_db{$cpath}{trst} = 1;
              }
           } else {

              if ($comp_db{$sub_cpath}{name} ne "TAP_IR") {
                 # Populate powergood/tlr/trst info based on data in RDL
                 populate_reset_info($ipath, $sub_ipath, $sub_fpath, 0, 0);
              }
           }
        }
        foreach my $pwr_id (keys %{$inst_db{$ipath}{pwrgood_id}}) {
           if (!exists $comp_db{$def_path}{pwrgood_id}) {
              $comp_db{$def_path}{pwrgood_id} = {};
           }
           if (!exists $comp_db{$def_path}{pwrgood_id}{$pwr_id}) {
              $comp_db{$def_path}{pwrgood_id}{$pwr_id} = {};
           }
        }
        if (exists $inst_db{$ipath}{tlr} &&
              !exists $comp_db{$def_path}{tlr}) {
           $comp_db{$def_path}{tlr} = 1;
        }
        if (exists $inst_db{$ipath}{trst} &&
              !exists $comp_db{$def_path}{trst}) {
           $comp_db{$def_path}{trst} = 1;
        }
      }
   } #foreach inst

   #logical to physical reset port mapping
   $icl_comp_db{$gIclModulePath}{reset_mapping} = {};
   if (exists $comp_db{$def_path}{pwrgood_id}) {
      my @pwr_id_list_to_map = ();
      my $port_name     = "";
      my $port_polarity = "";
      $icl_comp_db{$gIclModulePath}{reset_mapping}{pwrgood_id} = {};
      foreach my $pwr_id (keys %{$comp_db{$def_path}{pwrgood_id}}) {
         if (exists $icl_comp_db{$gIclModulePath}{reset_ports}{powergood}{$pwr_id}) {
            # FIXME
            $port_name     = $icl_comp_db{$gIclModulePath}{reset_ports}{powergood}{$pwr_id}{port_name};
            $port_polarity = $icl_comp_db{$gIclModulePath}{reset_ports}{powergood}{$pwr_id}{polarity};
            $icl_comp_db{$gIclModulePath}{reset_mapping}{pwrgood_id}{$pwr_id}{port_name} = $port_name;
            $icl_comp_db{$gIclModulePath}{reset_mapping}{pwrgood_id}{$pwr_id}{polarity}  = $port_polarity;
            $icl_comp_db{$gIclModulePath}{reset_ports}{powergood}{$pwr_id}{id} = $pwr_id;
            print ("-I- Logical powergood reset '$pwr_id' is assigned to the port '$port_name' (active polarity '$port_polarity')\n");
         } else {
            push @pwr_id_list_to_map, $pwr_id;
         }
      }
      my $num_to_map = scalar(@pwr_id_list_to_map);
      if ($num_to_map == 1) {
         my $pwr_id     = $pwr_id_list_to_map[0];
         my @not_used_reset_ports = (grep {!exists $icl_comp_db{$gIclModulePath}{reset_ports}{powergood}{$_}{id}} (keys %{$icl_comp_db{$gIclModulePath}{reset_ports}{powergood}}));
         my $num_of_not_used_reset_ports = scalar(@not_used_reset_ports);
         if ($num_of_not_used_reset_ports == 1) {
            my $pwr_id_phy = $not_used_reset_ports[0];
            $port_name     = $icl_comp_db{$gIclModulePath}{reset_ports}{powergood}{$pwr_id_phy}{port_name};
            $port_polarity = $icl_comp_db{$gIclModulePath}{reset_ports}{powergood}{$pwr_id_phy}{polarity};
            $icl_comp_db{$gIclModulePath}{reset_mapping}{pwrgood_id}{$pwr_id}{port_name} = $port_name;
            $icl_comp_db{$gIclModulePath}{reset_mapping}{pwrgood_id}{$pwr_id}{polarity}  = $port_polarity;
            $icl_comp_db{$gIclModulePath}{reset_ports}{powergood}{$pwr_id_phy}{id} = $pwr_id;
            print ("-I- Logical powergood reset '$pwr_id' is assigned to the port '$port_name' (active polarity '$port_polarity', id:'$pwr_id_phy')\n");
         } elsif ($num_of_not_used_reset_ports == 0) {
            @not_used_reset_ports = keys %{$icl_comp_db{$gIclModulePath}{reset_ports}{unknown}};
            if (scalar(@not_used_reset_ports) == 1) {
               $port_name     = $not_used_reset_ports[0];
               $port_polarity = $icl_comp_db{$gIclModulePath}{reset_ports}{unknown}{$port_name}{polarity};
               #FIXME
               $icl_comp_db{$gIclModulePath}{reset_mapping}{pwrgood_id}{$pwr_id}{port_name}   = $port_name;
               $icl_comp_db{$gIclModulePath}{reset_mapping}{pwrgood_id}{$pwr_id}{polarity}    = $port_polarity;
               $icl_comp_db{$gIclModulePath}{reset_ports}{unknown}{$port_name}{id} = $pwr_id;
               print ("-I- Logical powergood reset '$pwr_id' is assigned to the port '$port_name' (active polarity '$port_polarity', not categorized)\n");
            } else {
               die "-E- Cannot map RDL powergood reset '$pwr_id' to the ResetPort in the ICL header file\n";
            }
         } else {
            die "-E- Cannot map RDL powergood reset '$pwr_id' to the ResetPort in the ICL header file\n";
         }
     } elsif ($num_to_map != 0) {
       die "-E- Cannot map RDL powergood resets @pwr_id_list_to_map to the ResetPorts in the ICL header file\n";
     }
   } else {
      warn "-W- RDL defines no powergood resets\n";
   }

   if (exists $comp_db{$def_path}{tlr}) {
      # Expect single "marked"/detected TLR reset at top level (only for top-level RTDRs)
      $icl_comp_db{$gIclModulePath}{reset_mapping}{tlr} = {};
      if (exists $icl_comp_db{$gIclModulePath}{reset_ports}{tlr}) {
         # FIXME
         my $port_name     = $icl_comp_db{$gIclModulePath}{reset_ports}{tlr}{""}{port_name};
         my $port_polarity = $icl_comp_db{$gIclModulePath}{reset_ports}{tlr}{""}{polarity};
         $icl_comp_db{$gIclModulePath}{reset_mapping}{tlr}{port_name} = $port_name;
         $icl_comp_db{$gIclModulePath}{reset_mapping}{tlr}{polarity}  = $port_polarity;
         print ("-I- Logical TLR reset is assigned to the port '$port_name' (active polarity '$port_polarity')\n");
      } else {
         die "-E- Cannot map RDL TLR reset to the ResetPort in the ICL header file\n";
      }
   }

   if (exists $comp_db{$def_path}{trst}) {
      # Can be multiple TRST signals if per client ScanInterface of TAP
      # Only single can be marked as 'trst'
      my $port_name = "";
      $icl_comp_db{$gIclModulePath}{reset_mapping}{trst} = {};
      if (exists $icl_comp_db{$gIclModulePath}{reset_ports}{trst}) {
         # FIXME
         $port_name = $icl_comp_db{$gIclModulePath}{reset_ports}{trst}{""}{port_name};
      } elsif (exists $icl_comp_db{$gIclModulePath}{port}{TRSTPort}) {
         my @trst_ports = (keys %{$icl_comp_db{$gIclModulePath}{port}{TRSTPort}});
         if (exists $icl_comp_db{$gIclModulePath}{interface}) {
            # FIXME take first not used interface or the first in the list
            # FIXME assing TRST ports to TAP based on ScanInterface mapping if exists
            my $found = 0;
            foreach my $port (@trst_ports) {
               my $used = 0;
               foreach my $intf (keys %{$icl_comp_db{$gIclModulePath}{interface}}) {
                  if (exists $icl_comp_db{$gIclModulePath}{interface}{$intf}{ports}{$port}) {
                     $used = 1;
                     last;
                  }
               }
               if (!$used) {
                  $port_name = $port;
                  $found = 1;
                  last;
               }
            }
            if (!$found) {
               $port_name = $trst_ports[0];
            }
         } else {
            # FIXME take the first port
            my @trst_ports = (keys %{$icl_comp_db{$gIclModulePath}{port}{TRSTPort}});
            my $port_name = $trst_ports[0];
         }
         $icl_comp_db{$gIclModulePath}{reset_mapping}{trst}{port_name} = $port_name;
         print ("-I- Logical TRST reset is assigned to the port '$port_name'\n");
      } else {
         die "-E- Cannot map RDL TRST reset to the TRSTPort in the ICL header file (port does not exist)\n";
      }
   }

   #FIXME
   #print ("DEBUG - FInal databases\n");
   #print Dumper (\%inst_db);
   #print Dumper (\%comp_db);
   #print Dumper (\%icl_comp_db);

   my $is_single_tap_inst = (!$is_reg_only) && (scalar(@tap_addrmap_list) == 1);
   my $is_top_level = ($full_inst_path eq "");

   if ($is_top_level) {
      icl_print_header($ofile);
   }

   if ($is_tap_addrmap && $is_reg_only) {
      print $ofile ("\nModule $gIclName {\n\n");
      icl_print_param($def_path,$ofile);
      icl_print_reg_only($def_path,$full_inst_path,$ofile,$base_name,$new_def_name,$is_top_level);

   } elsif ($is_tap_addrmap) {
      icl_print_tap($def_path,$full_inst_path,$ofile,$base_name,$new_def_name,$is_top_level,$security_exists,$security_unlock);

   } elsif ($is_single_tap_inst) {
      # FIXME: for now, use top level attributes only if TOP has multiple TAP components
      my $inst = $tap_addrmap_list[0];
      my $ipath = "$def_path.$inst";
      my $dpath = $inst_db{$ipath}{cpath};
      my $fpath = "$full_inst_path.$inst";
      # FIXME: For now, just copy instance level interface assignments to the definition 
      if (exists $inst_db{$ipath}{intf}) {
         $comp_db{$dpath}{intf} = $inst_db{$ipath}{intf};
      }
      if (exists $inst_db{$ipath}{ScanInPort}) {
         $comp_db{$dpath}{ScanInPort} = $inst_db{$ipath}{ScanInPort};
      }
      if (exists $inst_db{$ipath}{ScanOutPort}) {
         $comp_db{$dpath}{ScanOutPort} = $inst_db{$ipath}{ScanOutPort};
      }
      if (exists $inst_db{$ipath}{TMSPort}) {
         $comp_db{$dpath}{TMSPort} = $inst_db{$ipath}{TMSPort};
      }
      icl_print_tap($dpath,$fpath,$ofile,$base_name,$new_def_name,$is_top_level,$security_exists,$security_unlock);

   } else {

      #my $trst_exists = (scalar(@tap_addrmap_list) > 0);
      # FIXME: use {reset_mapping} instead?
      my $trst_exists     = (exists $comp_db{$def_path}{trst});
      my $tlr_exists      = (exists $comp_db{$def_path}{tlr});
      my $pwrgood_exists  = (exists $comp_db{$def_path}{pwrgood_id});

      print $ofile ("\nModule $gIclName {\n\n");

      icl_print_param($def_path,$ofile);

      icl_print_attr($def_path, $full_inst_path, $ofile,0,1,0,$is_top_level);

      my $tdi_name_default         = "Tdi";
      my $tdo_name_default         = "Tdo";
      my $tms_name_default         = "Tms";
      my $trst_name_default        = "Trstb";
      my $tclk_name_default        = "Tclk";
      my $pwrgood_name_default     = "fdfx_powergood";
      my $security_name_default    = "fdfx_secure_policy[3:0]";
      my $slvidcode_name_default   = "ftap_slvidcode[31:0]";
      my $tlr_name_default         = "ijtag_reset_b";
#      my $taplink_sel_name_default = "Taplink_ir_sel";
      
      my $tdi_name          = "";
      my $tdo_name          = "";
      my $tms_name          = "";
      my $trst_name         = $trst_name_default;
      my $tclk_name         = $tclk_name_default;
      my $pwrgood_name      = $pwrgood_name_default;
      my $tlr_name          = $tlr_name_default;
      my $security_name     = $security_name_default;
      my $slvidcode_name    = $slvidcode_name_default;
      my $security_red_name     = "";
      my $security_orange_name  = "";
      my $security_green_name   = "";
#      my $taplink_sel_name  = $taplink_sel_name_default;
      
      my $intf_id = "";
      my $assigned;
      my $slvidcode_exists = 0;

      $assigned = assign_port_name($intf_id,"tap","TCKPort",$tclk_name);
      print ("-I- Top TCLK port assigned to '$tclk_name'\n");

      if ($trst_exists) {
         # FIXME
         if (exists $icl_comp_db{$gIclModulePath}{reset_mapping}{trst}) {
            $trst_name = $icl_comp_db{$gIclModulePath}{reset_mapping}{trst}{port_name};
         } else {
            my $assigned = assign_port_name($intf_id,"tap","TRSTPort",$trst_name);
            if (!$assigned) {
               die "-E- Something wrong, TRSTPort does not exist in the ICL header file\n";
            }
         }
         print ("-I- Top TRSTb port assigned to '$trst_name'\n");
      }

      if ($tlr_exists) {
         # FIXME
         if (exists $icl_comp_db{$gIclModulePath}{reset_mapping}{tlr}) {
            $tlr_name = $icl_comp_db{$gIclModulePath}{reset_mapping}{tlr}{port_name};
         } else {
            my $assigned = assign_port_name($intf_id,"tlr","ResetPort",$tlr_name);
            if (!$assigned) {
               die "-E- Something wrong, TLR ResetPort does not exist in the ICL header file\n";
            }
         }
         print ("-I- Top TLR reset port assigned to '$tlr_name'\n");
      }

      if ($pwrgood_exists) {
         if (exists $icl_comp_db{$gIclModulePath}{reset_mapping}{pwrgood_id}{""}) {
            $pwrgood_name = $icl_comp_db{$gIclModulePath}{reset_mapping}{pwrgood_id}{""}{port_name};
         } else {
            # FIXME take the first available
            my @pwrgood_id_list = keys %{$icl_comp_db{$gIclModulePath}{reset_mapping}{pwrgood_id}};
            my $pwr_id = $pwrgood_id_list[0];
            $pwrgood_name = $icl_comp_db{$gIclModulePath}{reset_mapping}{pwrgood_id}{$pwr_id}{port_name};
            #my $assigned = assign_port_name($intf_id,"powergood","ResetPort",$pwrgood_name);
            #if (!$assigned) {
            #   die "-E- Something wrong, Powergood ResetPort does not exist in the ICL header file\n";
            #}
         }
         print ("-I- Top DFx Powergood port assigned to '$pwrgood_name'\n");
      }

      if ($security_exists) {
         $assigned = assign_port_name($intf_id,"secure_policy","DataInPort",$security_name);
         if ($assigned) {
            print ("-I- Top TAP Security port assigned to '$security_name'\n");
         }
         my $assigned_unlock;
         $assigned_unlock = assign_port_name($intf_id,"secure_red","DataInPort",$security_red_name);
         if ($assigned_unlock) {
            print ("-I- Top TAP RED unlock port assigned to '$security_red_name'\n");
            if ($assigned) {
               die "-E- Secure Policy port $security_name and RED unlock port $security_red_name cannot coexist\n";
            }
            $security_unlock = 1;
         } else {
            if ($security_red_exists && !$assigned) {
               die "-E- RED secure policy is used but no RED unlock or Secure Policy port found\n";
            }
         }
         $assigned_unlock = assign_port_name($intf_id,"secure_orange","DataInPort",$security_orange_name);
         if ($assigned_unlock) {
            print ("-I- Top TAP ORANGE unlock port assigned to '$security_orange_name'\n");
            if ($assigned) {
               die "-E- Secure Policy port $security_name and ORANGE unlock port $security_orange_name cannot coexist\n";
            }
            $security_unlock = 1;
         } else {
            if ($security_orange_exists && !$assigned) {
               die "-E- ORANGE secure policy is used but no ORANGE unlock or Secure Policy port found\n";
            }
         }
         $assigned_unlock = assign_port_name($intf_id,"secure_green","DataInPort",$security_green_name);
         if ($assigned_unlock) {
            print ("-I- Top TAP GREEN unlock port assigned to '$security_green_name'\n");
            if ($assigned) {
               die "-E- Secure Policy port $security_name and GREEN unlock port $security_green_name cannot coexist\n";
            }
         }
      }

      # FIXME
      $assigned = assign_port_name($intf_id,"slvidcode","DataInPort",$slvidcode_name);
      if ($assigned) {
          print ("-I- Top TAP SLVIDCODE strap port assigned to '$slvidcode_name'\n");
          $slvidcode_exists = 1;
      } else {
         print ("-I- No top TAP SLVIDCODE strap port exists\n");
      }

      print $ofile ("${text_indent}// Common TAP interfaces\n");
      print $ofile ("${text_indent}// All ports in ICL must match corresponding RTL module port names\n\n");


      my $port_def_block = icl_get_port_properties("TCKPort",$tclk_name,1,1);
      
      print $ofile ("${text_indent}TCKPort       $tclk_name$port_def_block\n");
      $icl_comp_db{$gIclModulePath}{printed_ports}{$tclk_name} = 1;

      if ($trst_exists) {
         $port_def_block = icl_get_port_properties("TRSTPort",$trst_name,1,1);
         print $ofile ("${text_indent}TRSTPort      $trst_name$port_def_block\n");
         $icl_comp_db{$gIclModulePath}{printed_ports}{$trst_name} = 1;
      }

      #my $tap_reset_name = "";
      #my $pwrgood_polarity = "0";

      #print $ofile ("\n${text_indent}// fdfx_pwrgood: port & powergood reset generator\n");
      #print $ofile ("${text_indent}//  NOTE: using DataInPort @ top level\n");
      #print $ofile ("${text_indent}DataInPort    $pwrgood_name { DefaultLoadValue 1'b1; }\n");
      #print $ofile ("\n${text_indent}DataMux trstb_or_pwrgood SelectedBy $pwrgood_name {\n");
      #print $ofile ("${text_indent}   1'b0 : 1'b0;\n");
      #print $ofile ("${text_indent}   1'b1 : $trst_name;\n");
      #print $ofile ("${text_indent}}\n");

      if ($pwrgood_exists) {
         print $ofile ("\n${text_indent}// DFx powergood/reset ports\n");
         foreach my $pwr_id (keys %{$icl_comp_db{$gIclModulePath}{reset_mapping}{pwrgood_id}}) {
           my $pwrgood_port = $icl_comp_db{$gIclModulePath}{reset_mapping}{pwrgood_id}{$pwr_id}{port_name};
           if (!exists $icl_comp_db{$gIclModulePath}{printed_ports}{$pwrgood_port}) {
              $port_def_block  = icl_get_port_active_polarity("ResetPort",$pwrgood_port);
              $port_def_block .= icl_get_port_properties("ResetPort",$pwrgood_port,0,1);
              print $ofile ("${text_indent}ResetPort     $pwrgood_port {$port_def_block}\n");
              $icl_comp_db{$gIclModulePath}{printed_ports}{$pwrgood_port} = 1;
           }
         }
      }

      if ($security_exists) {
         if ($security_unlock) {
            print $ofile ("\n");
            if ($security_red_name ne "") {
               $port_def_block = icl_get_port_properties("DataInPort",$security_red_name,0,1);
               print $ofile ("${text_indent}DataInPort     $security_red_name$port_def_block\n");
               $icl_comp_db{$gIclModulePath}{printed_ports}{$security_red_name} = 1;
            }
            if ($security_orange_name ne "") {
               $port_def_block = icl_get_port_properties("DataInPort",$security_orange_name,0,1);
               print $ofile ("${text_indent}DataInPort     $security_orange_name$port_def_block\n");
               $icl_comp_db{$gIclModulePath}{printed_ports}{$security_orange_name} = 1;
            }
         } else {
            icl_print_secure_ports($security_name,$ofile);
            $icl_comp_db{$gIclModulePath}{printed_ports}{$security_name} = 1;
         }
      }

      if (scalar(@tap_addrmap_list)) {
         print $ofile ("\n${text_indent}// Individual TAP interfaces and instances\n");
      }
   
      my $out_fname_inc = "";
      my $out_name_inc = "";
      my $ofile_inc;
      my $inc_type = "";
   
      foreach my $inst (sort @tap_addrmap_list) {
   
         my $ipath = "$def_path.$inst";
         my $dpath = $inst_db{$ipath}{cpath};
         my $fpath = "$full_inst_path.$inst";
   
         my $comp_type = $comp_db{$dpath}{type};
   
         my $def_name =$inst_db{$ipath}{comp};
         # support anonymous reg instances
         $def_name =$inst_db{$ipath}{iname} if ($def_name eq "");
         my $inst_def_name       = icl_uniquify_def_name($def_name,$inst,$base_name,\%mi_hash);
         my $final_inst_def_name = icl_add_prefix_suffix($inst_def_name);
   
         my $tap_with_security = (exists $taps_with_security{$inst});

         #print $ofile ("\n");
   
         my $out_name_inc = "${final_inst_def_name}";
         if (!exists $included_files{$out_name_inc}) {
            my $out_fname_inc_a = "$gOutDir/${out_name_inc}.icl";
            $included_files{$out_name_inc} = 1;
      
            open ($ofile_inc, '>', $out_fname_inc_a) or die "Can't create '$out_fname_inc': $!";
            icl_print_header($ofile_inc);
   
            icl_print_tap($dpath,$fpath,$ofile_inc,$inst_def_name,$final_inst_def_name,0,$tap_with_security,$security_unlock);
   
            close ($ofile_inc);
         } else { # eliminate non-used override warnings from non-printed MI (reused) definitions
            $printed_non_mi_defs_hash{$dpath} = 1;
         }
   
         print $ofile ("${text_indent}//---------------------------\n\n");

         if (exists $inst_db{$ipath}{ScanInPort}) {
            $tdi_name = $inst_db{$ipath}{ScanInPort};
            if (!exists $icl_comp_db{$gIclModulePath}{printed_ports}{$tdi_name}) {
               $port_def_block = icl_get_port_properties("ScanInPort",$tdi_name,1,0);
               print $ofile ("${text_indent}ScanInPort    $tdi_name$port_def_block\n");
               $icl_comp_db{$gIclModulePath}{printed_ports}{$tdi_name} = 1;
            }
         } else {
            $tdi_name = "${tdi_name_default}_${inst}";
            print $ofile ("${text_indent}ScanInPort    $tdi_name; // WARNING: using DEFAULT name (no port map info)\n");
         }

         if (exists $inst_db{$ipath}{ScanOutPort}) {
            $tdo_name = "$inst_db{$ipath}{ScanOutPort}";
            if (!exists $icl_comp_db{$gIclModulePath}{printed_ports}{$tdo_name}) {
               $port_def_block = icl_get_port_properties("ScanOutPort",$tdo_name,0,0);
               print $ofile ("${text_indent}ScanOutPort   $tdo_name { Source $inst.Tdo;$port_def_block}\n");
               $icl_comp_db{$gIclModulePath}{printed_ports}{$tdo_name} = 1;
            }
         } else {
            $tdo_name = "${tdo_name_default}_${inst}";
            print $ofile ("${text_indent}ScanOutPort   $tdo_name { Source $inst.Tdo; } // WARNING: using DEFAULT name (no port map info)\n");
         }

         if (exists $inst_db{$ipath}{TMSPort}) {
            $tms_name = $inst_db{$ipath}{TMSPort};
            if (!exists $icl_comp_db{$gIclModulePath}{printed_ports}{$tms_name}) {
               $port_def_block = icl_get_port_properties("TMSPort",$tms_name,1,0);
               print $ofile ("${text_indent}TMSPort       $tms_name$port_def_block\n");
               $icl_comp_db{$gIclModulePath}{printed_ports}{$tms_name} = 1;
            }
         } else {
            $tms_name = "${tms_name_default}_${inst}";
            print $ofile ("${text_indent}TMSPort       $tms_name; // WARNING: using DEFAULT name (no port map info)\n");
         }

         my $intf_name = "";
         if (exists $inst_db{$ipath}{intf}) {
            $intf_name = $inst_db{$ipath}{intf};
         } else {
            # FIXME existence check
            $intf_name = "c_${inst}";
         }

         print $ofile ("\n${text_indent}ScanInterface $intf_name {\n");
         print $ofile ("${text_indent}   Port   $tdi_name;\n");
         print $ofile ("${text_indent}   Port   $tdo_name;\n");
         print $ofile ("${text_indent}   Port   $tms_name;\n");
         print $ofile ("${text_indent}}\n\n");
      
         if (exists $inst_db{$ipath}{DataInPort}) {
            foreach my $port_name (sort keys %{$inst_db{$ipath}{DataInPort}}) {
               if (!exists $icl_comp_db{$gIclModulePath}{port}{DataInPort}{$port_name}{assigned_to}) {next;}
               $port_def_block = icl_get_port_properties("DataInPort",$port_name,1,0);
               #my $test_block = ";";
               #if (exists $icl_comp_db{$gIclModulePath}{port}{DataInPort}{$port_name}{DefaultLoadValue}) {
               #   my $value = $icl_comp_db{$gIclModulePath}{port}{DataInPort}{$port_name}{DefaultLoadValue};
               #   $test_block = " {DefaultLoadValue $value; }";
               #}
               #print $ofile ("${text_indent}DataInPort     $port_name$test_block\n");
               print $ofile ("${text_indent}DataInPort     $port_name$port_def_block\n");
               $icl_comp_db{$gIclModulePath}{printed_ports}{$port_name} = 1;
            }
            print $ofile ("\n");
         }

         if (exists $inst_db{$ipath}{DataOutPort}) {
            foreach my $port_name (sort keys %{$inst_db{$ipath}{DataOutPort}}) {
               if (!exists $icl_comp_db{$gIclModulePath}{port}{DataOutPort}{$port_name}{assigned_to}) {next;}
               $port_def_block  = icl_get_port_enable("DataOutPort",$port_name);
               $port_def_block .= icl_get_port_properties("DataOutPort",$port_name,0,0);
               my $pname = $inst_db{$ipath}{DataOutPort}{$port_name}{name};
               print $ofile ("${text_indent}DataOutPort    $port_name { Source $inst.tdr_out_$pname;$port_def_block}\n");
               if (exists $icl_comp_db{$gIclModulePath}{port}{DataOutPort}{$port_name}) {
                  if (!exists $icl_comp_db{$gIclModulePath}{printed_ports}{$port_name}) {
                     $icl_comp_db{$gIclModulePath}{printed_ports}{$port_name} = 1;
                  } else {
                     die "-E- Something wrong, definition for top level port $port_name was printed already\n";
                  }
               }
               $icl_comp_db{$gIclModulePath}{printed_ports}{$port_name} = 1;
            }
            print $ofile ("\n");
         }

         print $ofile ("${text_indent}Instance $inst Of $final_inst_def_name {\n");

         icl_print_inst_param($dpath, $ofile);
   
         icl_print_attr($dpath, $fpath, $ofile,1,1,1,1);# $extra_indent
   
         print $ofile ("${text_indent}   InputPort   Tdi                = $tdi_name;\n");
         print $ofile ("${text_indent}   InputPort   Tms                = $tms_name;\n");
         print $ofile ("${text_indent}   InputPort   Trstb              = $trst_name;\n");
         print $ofile ("${text_indent}   InputPort   Tclk               = $tclk_name;\n");
         # FIXME review/improve
         if (exists $inst_db{$ipath}{pwrgood_id}) {
            foreach my $pwr_id (keys %{$inst_db{$ipath}{pwrgood_id}}) {
               my $port_suffix = ($pwr_id eq "") ? "" : "_$pwr_id";
               if (exists $icl_comp_db{$gIclModulePath}{reset_mapping}{pwrgood_id}{$pwr_id}) {
                  my $pwr_port_name     = $icl_comp_db{$gIclModulePath}{reset_mapping}{pwrgood_id}{$pwr_id}{port_name};
                  my $pwr_port_polarity = $icl_comp_db{$gIclModulePath}{reset_mapping}{pwrgood_id}{$pwr_id}{polarity};
                  my $sig_polarity = ($pwr_port_polarity == 1) ? "~" : "";
                  print $ofile ("${text_indent}   InputPort   fdfx_powergood$port_suffix     = $sig_polarity$pwr_port_name;\n");
               } else {
                  die "-E- TAP $inst: powergood ResetPort with ID '$pwr_id' does not exists\n";
               }
            }
         }

         if ($tap_with_security) {
            if ($security_unlock) {
               my $red_unlock_signal    = ($security_red_name ne "")    ? $security_red_name    : "1'b0";
               my $orange_unlock_signal = ($security_orange_name ne "") ? $security_orange_name : "1'b0";
               my $green_unlock_signal  = ($security_green_name ne "")  ? $security_green_name  : "1'b0";
               print $ofile ("${text_indent}   InputPort   dfxsecure_feature_en = $security_red_name, $security_orange_name, $security_green_name;\n");
            } else {
               print $ofile ("${text_indent}   InputPort   fdfx_secure_policy = $security_name;\n");
            }
         }
         if (exists $inst_db{$ipath}{DataInPort}) {
            foreach my $port_name (sort keys %{$inst_db{$ipath}{DataInPort}}) {
               if (!exists $icl_comp_db{$gIclModulePath}{port}{DataInPort}{$port_name}{assigned_to}) {next;}
               my $pname = $inst_db{$ipath}{DataInPort}{$port_name}{name};
               print $ofile ("${text_indent}   InputPort   tdr_in_$pname = $port_name;\n");
            }
         }
         print $ofile ("${text_indent}}\n");
      }

      if ($is_reg_only) {
         print $ofile ("\n${text_indent}//---------------------------\n");
         print $ofile ("${text_indent}// Individual Registers and Chains\n");
         print $ofile ("${text_indent}//---------------------------\n");
         # FIXME: $new_def_name isn't required anymore
         icl_print_reg_only($inst_db{"$def_path.$reg_only_inst"}{cpath},"$full_inst_path.$reg_only_inst",$ofile,$base_name,$new_def_name,$is_top_level);
      } else {
         # FIXME: check $new_def_name
         print $ofile ("} // end of $new_def_name\n\n");
      }

   }
}

# extract and populate reset info for the given register
sub populate_reset_info
{
   my $parent_ipath = shift;
   my $ipath        = shift;
   my $fpath        = shift;
   my $top_level    = shift;
   my $reg_only     = shift;

   my $parent_cpath = ($top_level) ? $parent_ipath : $inst_db{$parent_ipath}{cpath};
   my $cpath        = $inst_db{$ipath}{cpath};

   my $reset_type = icl_get_attr('TapRegResetType', $cpath, $fpath, 1, 1, 1);
   my $trst_type = ($reg_only) ? "tlr" : "trst";

   if ($reset_type =~ /TLR/) {
      $inst_db{$ipath}{tlr} = 1;
      if (!exists $comp_db{$parent_cpath}{$trst_type}) {
              $comp_db{$parent_cpath}{$trst_type} = 1;
      }
      if (!$top_level) {
         if (!exists $inst_db{$parent_ipath}{$trst_type}) {
            $inst_db{$parent_ipath}{$trst_type} = 1;
         }
      }
   } elsif ($reset_type =~ /TRST/) {
      $inst_db{$ipath}{trst} = 1;
      # FIXME: If register is marked as TRST, marking it as TLR for now
      if (!exists $comp_db{$parent_cpath}{$trst_type}) {
         $comp_db{$parent_cpath}{$trst_type} = 1;
      }
      if (!$top_level) {
         if (!exists $inst_db{$parent_ipath}{$trst_type}) {
            $inst_db{$parent_ipath}{$trst_type} = 1;
         }
      }
   } elsif ($reset_type =~ /PWRGOOD_*(\w*)/) {
      my $pwrgood_id = lc($1);
      $inst_db{$ipath}{pwrgood_id} = $pwrgood_id;
      if (!exists $comp_db{$parent_cpath}{pwrgood_id}) {
         $comp_db{$parent_cpath}{pwrgood_id} = {};
      }
      if (!exists $comp_db{$parent_cpath}{pwrgood_id}{$pwrgood_id}) {
         $comp_db{$parent_cpath}{pwrgood_id}{$pwrgood_id} = 1;
      }
      if (!$top_level) {
         if (!exists $inst_db{$parent_ipath}{pwrgood_id}) {
            $inst_db{$parent_ipath}{pwrgood_id} = {};
         }
         if (!exists $inst_db{$parent_ipath}{pwrgood_id}{$pwrgood_id}) {
            $inst_db{$parent_ipath}{pwrgood_id}{$pwrgood_id} = 1;
         }
      }
   } else {
      # FIXME assume that reset is required
      my $pwrgood_id = "";
      $inst_db{$ipath}{pwrgood_id} = $pwrgood_id;
      if (!exists $comp_db{$parent_cpath}{pwrgood_id}) {
         $comp_db{$parent_cpath}{pwrgood_id} = {};
      }
      if (!exists $comp_db{$parent_cpath}{pwrgood_id}{$pwrgood_id}) {
         $comp_db{$parent_cpath}{pwrgood_id}{$pwrgood_id} = 1;
      }
      if (!$top_level) {
         if (!exists $inst_db{$parent_ipath}{pwrgood_id}) {
            $inst_db{$parent_ipath}{pwrgood_id} = {};
         }
         if (!exists $inst_db{$parent_ipath}{pwrgood_id}{$pwrgood_id}) {
            $inst_db{$parent_ipath}{pwrgood_id}{$pwrgood_id} = 1;
         }
      }
   }
}

# pirnt ICL definition for TAP
sub icl_print_secure_ports
{
   my $port_name       = shift;
   my $ofile           = shift;

    print $ofile ("\n${text_indent}// DFx Secure Interface\n");
    print $ofile ("${text_indent}//Note: fdfx_earlyboot_exit/fdfx_policy_update are not required to be modeled in ICL\n");

    my $refenum = icl_get_port_refenum("DataInPort",$port_name);

    if ($refenum ne "") {

       my $port_def_block = icl_get_port_properties("DataInPort",$port_name,1,0);
       print $ofile ("${text_indent}DataInPort    $port_name$port_def_block\n\n");
       icl_print_enum($refenum,$ofile);

    } else {

       my $port_def_block = icl_get_port_properties("DataInPort",$port_name,0,0);

       print $ofile ("${text_indent}DataInPort    $port_name { RefEnum TAP_SECURITY;$port_def_block}\n");
   
       print $ofile ("\n${text_indent}Enum TAP_SECURITY {\n");
       print $ofile ("${text_indent}   SECURITY_LOCKED      = 4'h0;\n");
       print $ofile ("${text_indent}   FUNCTIONALITY_LOCKED = 4'h1;\n");
       print $ofile ("${text_indent}   SECURITY_UNLOCKED    = 4'h2;\n");
       print $ofile ("${text_indent}   RESERVED             = 4'h3;\n");
       print $ofile ("${text_indent}   INTEL_UNLOCKED       = 4'h4;\n");
       print $ofile ("${text_indent}   OEM_UNLOCKED         = 4'h5;\n");
       print $ofile ("${text_indent}   ENDEBUG_UNLOCKED     = 4'h6;\n");
       print $ofile ("${text_indent}   INFRARED_UNLOCKED    = 4'h7;\n");
       print $ofile ("${text_indent}   DRAM_DEBUG_UNLOCKED  = 4'h8;\n");
       print $ofile ("${text_indent}   FUSA_UNLOCKED        = 4'h9;\n");
       print $ofile ("${text_indent}   USER4_UNLOCKED       = 4'ha;\n");
       print $ofile ("${text_indent}   USER5_UNLOCKED       = 4'hb;\n");
       print $ofile ("${text_indent}   USER6_UNLOCKED       = 4'hc;\n");
       print $ofile ("${text_indent}   USER7_UNLOCKED       = 4'hd;\n");
       print $ofile ("${text_indent}   USER8_UNLOCKED       = 4'he;\n");
       print $ofile ("${text_indent}   PART_DISABLED        = 4'hf;\n");
       print $ofile ("${text_indent}}\n");
    }
}

# pirnt ICL definition for TAP
sub icl_print_tap
{
   my $def_path       = shift;
   my $full_inst_path = shift; # full relative path from the specified top instance
   my $ofile          = shift;
   my $base_name      = shift;
   my $new_def_name   = shift;
   my $is_top_level   = shift;
   my $security_exists = shift;
   my $security_unlock = shift; # argument is used only for NOT top level tap

   my $comp_type = $comp_db{$def_path}{type};
   if ($comp_type ne "addrmap") {
      die "-E- Instance $full_inst_path is not an addrmap (actual type: $comp_type)\n";
   }

   %included_defs = ();

   # local for that specific definition!
   my %mi_hash;
   my %reg_param_hash;
   my @reg_list;
   my %reg_hash;
   my @reg_defs_to_print = ();
   my @regfile_defs_to_print = ();
   my @rtdr_list = ();
   
   # populate global override db
   # FIXME check if it is required
   #icl_populate_ovrd_hash($def_path,$full_inst_path);

   # populate MI db and mark instances/definitions which require uniquification
   icl_process_mi($def_path,$full_inst_path,\%mi_hash);

   # If Single/Top level TAP, check for existence of exported host interfaces for RTDRs
   if ($is_top_level) {
      assign_host_intf($def_path);
   }

   # populate info about each TAP opcode/register
   my $ir_reset_bin_value;
   my $ir_reset_opcode;
   
   my $security_red_exists    = 0;
   my $security_orange_exists = 0;
   my $security_green_exists  = 0;

   foreach my $inst (@{$comp_db{$def_path}{ilist}}) {
      my $ipath     = "$def_path.$inst";
      my $cpath     = $inst_db{$ipath}{cpath};
      my $fpath     = "$full_inst_path.$inst";
      if ($comp_db{$cpath}{type} eq "reg") {
        # Skip TAP IR but extract reset & capture values
        icl_process_reg_param($cpath,\%reg_param_hash);
        my $reg_width_is_parameterized = 0;
        if (exists $param_comp_db{$cpath}) {
           $reg_width_is_parameterized = exists $param_comp_db{$cpath}{reg_width_formula};
        }
        if ($comp_db{$cpath}{name} eq "TAP_IR") {
           if ($reg_width_is_parameterized) {
              die "-E- RDL: parameterized TAP_IR isn't supported\n";
           }
           my $capture_source;
           my %param_hash; # not used for IR
           get_reg_rc_values($cpath,$fpath,\%reg_param_hash,$ir_reset_bin_value,$capture_source);
           $reg_hash{TAP_IR}{size} = icl_get_attr('TapShiftRegLength', $cpath, $fpath, 0, 1, 0);
           next;
        }
        if (exists $inst_db{$ipath}{host_intf}) {
           $reg_hash{$inst}{size} = "\"RTDR\"";
           $reg_hash{$inst}{is_rtdr} = 1;
           push @rtdr_list, $inst;
        } else {
           if (icl_get_attr('TapDrIsFixedSize', $cpath, $fpath, 1, 1, 0) eq 'true') { # fixed size reg
              if ($reg_width_is_parameterized) {
                 $reg_hash{$inst}{size} = $param_comp_db{$cpath}{reg_width_formula};
              } else {
                 $reg_hash{$inst}{size} = icl_get_attr('TapShiftRegLength', $cpath, $fpath, 0, 1, 0);
              }
           } else { # variable size reg
              $reg_hash{$inst}{size} = "\"VARIABLE\"";
           }
        }
      } elsif ($comp_db{$cpath}{type} eq "regfile") {
         # FIXME: check if it is variable size or not
         if (exists $inst_db{$ipath}{host_intf}) {
            $reg_hash{$inst}{size} = "\"RTDR\"";
            $reg_hash{$inst}{is_rtdr} = 1;
            push @rtdr_list, $inst;
         } else {
            $reg_hash{$inst}{size} = "\"VARIABLE\"";
         }
      } else {
         my $comp_type = $comp_db{$cpath}{type};
         die "-E- TAP definition cannot have instance of $comp_type (TAP %def_path, instance $inst))\n";
      }

      push @reg_list, $inst;
      
      my $reg_inst_name = $inst_db{$ipath}{iname};
      my $opcode = icl_get_attr('RegOpcode', $cpath, $fpath, 0, 1, 0);
      $opcode =~ s/'h//;
      $reg_hash{$inst}{opcode} = $opcode;
      $reg_hash{$inst}{name}   = $reg_inst_name;

      my $reg_security = icl_get_attr('TapOpcodeSecurityLevel', $cpath, $fpath, 0, 1, 1);
      if ($reg_security =~ /SECURE_RED/) {
         $security_red_exists = 1;
      } elsif ($reg_security =~ /SECURE_ORANGE/) {
         $security_orange_exists = 1;
      } elsif ($reg_security =~ /SECURE_GREEN/) {
         # FIXME: not setting $security_exists -
         #    no need for security logic in ICL
         $security_green_exists = 1;
      }
      # FIXME processing of not-populated security
      if ($reg_security eq "") {$reg_security = "SECURE_GREEN";}
      $reg_hash{$inst}{security}       = $reg_security;
      $reg_security =~ s/SECURE_//;
      $reg_security =~ s/\"//g;
      $reg_hash{$inst}{security_short} = $reg_security;

   } #foreach inst
   
   # FIXME sort @reg_list (based on opcode or reg inst name????)

   # find IR reset opcode
   my $ir_opcode_found = 0;
   $ir_reset_bin_value =~ s/^\d+'b//;
   if ($ir_reset_bin_value eq "") { # FIXME
      die "-E- No TAP IR/its reset info found for TAP $def_path\n";
   } else {
      foreach my $reg (keys %reg_hash) {
         next if ($reg eq "TAP_IR");
         my $op = $reg_hash{$reg}{opcode};
         if (oct( "0b$ir_reset_bin_value") == hex($op)) {
            $reg_hash{TAP_IR}{reset_opcode} = "\$${reg}_OPCODE";
            $ir_opcode_found = 1;
            last;
         }
      }
   }
   if (!$ir_opcode_found) {
      my $ir_hex = sprintf("%x", oct( "0b$ir_reset_bin_value"));
      die "-E- No defined opcode found which matches TAP IR reset (0x$ir_hex) for TAP $def_path\n";
   }
   my $ir_capture_value = icl_get_attr('TapIrCaptureValue', $def_path, $full_inst_path, 0, 1, 1); # default, override, no_error
   if ($ir_capture_value ne "") {
      $reg_hash{TAP_IR}{capture_value} = $ir_capture_value;
   }

   # sorted reg list based on opcodes, from min to max
   my @sorted_reg_list  = sort { hex($reg_hash{$a}{opcode}) <=> hex($reg_hash{$b}{opcode}) } @reg_list;
   my @sorted_rtdr_list = sort { hex($reg_hash{$a}{opcode}) <=> hex($reg_hash{$b}{opcode}) } @rtdr_list;
  
   my $module_name = ($is_top_level) ? $gIclName : $new_def_name;
   print $ofile ("\nModule $module_name {\n\n");

   icl_print_param($def_path, $ofile);

   icl_print_attr($def_path, $full_inst_path, $ofile,0,1,0,$is_top_level);

   my $indent = $text_indent;

   # FIXME
   #if ($gTapLink) {
   #   print $ofile ("${indent}//--------------------------------------------------------------------------------\n");
   #   print $ofile ("${indent}//Parameters (overridable)\n");
   #   print $ofile ("${indent}Parameter TAPLINK_MODE = 1\'b0;\n");
   #}

   # FIXME remove ovfd flag ?
   my $ir_length_str = icl_get_attr('TapIrLength', $def_path, $full_inst_path, 0, 1, 1); # attr name, def path, full_inst_path, allow_default, apply_overrides, no_error
   my $ir_length;
   if ($ir_length_str ne "") {
      $ir_length = int($ir_length_str);
      my $ir_size = int($reg_hash{TAP_IR}{size});
      if ($ir_length != $ir_size) {
         die "-E- TAP IR has different size specified in TapIrLength and in TAP_IR register definition(TAP: $def_path, $ir_length vs. $ir_size)\n";
      }
   } else {
      $ir_length = int($reg_hash{TAP_IR}{size});
   }
   if ($ir_length < 2) {
      die "-E- TAP IR size cannot be less than 2 (TAP: $def_path, size: $ir_length)\n";
   }

   my $tdi_name_default         = "Tdi";
   my $tdo_name_default         = "Tdo";
   my $tms_name_default         = "Tms";
   my $trst_name_default        = "Trstb";
   my $tclk_name_default        = "Tclk";
   my $pwrgood_name_default     = "fdfx_powergood";
   my $security_name_default    = "fdfx_secure_policy[3:0]";
   my $slvidcode_name_default   = "ftap_slvidcode[31:0]";
   #my $taplink_sel_name_default = "Taplink_ir_sel";

   my $tdi_name          = $tdi_name_default;
   my $tdo_name          = $tdo_name_default;
   my $tms_name          = $tms_name_default;
   my $trst_name         = $trst_name_default;
   my $tclk_name         = $tclk_name_default;
   my $pwrgood_name      = $pwrgood_name_default;
   my $security_name     = $security_name_default;
   my $security_red_name     = "";
   my $security_orange_name  = "";
   my $security_green_name   = "";
   my $slvidcode_name    = $slvidcode_name_default;
   #my $taplink_sel_name  = $taplink_sel_name_default;
   
   my $intf_id;
   my $assigned;
   my $default_name = "";
   if (exists $comp_db{$def_path}{intf}) {
      $intf_id = $comp_db{$def_path}{intf};
      if (exists $comp_db{$def_path}{ScanInPort}) {
         $tdi_name = $comp_db{$def_path}{ScanInPort};
         $default_name = "";
      } else {
         # FIXME check if it is required
         $assigned = assign_port_name($intf_id,"tap","ScanInPort",$tdi_name);
         $default_name = ($assigned) ? "" : "DEFAULT_NAME";
      }
      print ("-I- TAP module $module_name, TDI port: $default_name '$tdi_name' (ScanInterface '$intf_id')\n");
      if (exists $comp_db{$def_path}{ScanOutPort}) {
         $tdo_name = $comp_db{$def_path}{ScanOutPort};
         $default_name = "";
      } else {
         # FIXME check if it is required
         $assigned = assign_port_name($intf_id,"tap","ScanOutPort",$tdo_name);
         $default_name = ($assigned) ? "" : "DEFAULT_NAME";
      }
      print ("-I- TAP module $module_name, TDO port: $default_name '$tdo_name' (ScanInterface '$intf_id')\n");
      if (exists $comp_db{$def_path}{TMSPort}) {
         $tms_name = $comp_db{$def_path}{TMSPort};
         $default_name = "";
      } else {
         # FIXME check if it is required
         $assigned = assign_port_name($intf_id,"tap","TMSPort",$tms_name);
         $default_name = ($assigned) ? "" : "DEFAULT_NAME";
      }
      print ("-I- TAP module $module_name, TMS port: $default_name '$tms_name' (ScanInterface '$intf_id')\n");
   } else {
      $assigned = assign_port_name($intf_id,"tap","ScanInPort",$tdi_name);
      $default_name = ($assigned) ? "" : "DEFAULT_NAME";
      print ("-I- TAP module $module_name, TDI port assigned to $default_name '$tdi_name' (No assigned ScanInterface)\n");
      $assigned = assign_port_name($intf_id,"tap","ScanOutPort",$tdo_name);
      $default_name = ($assigned) ? "" : "DEFAULT_NAME";
      print ("-I- TAP module $module_name: TDO port assigned to $default_name '$tdo_name' (No assigned ScanInterface)\n");
      $assigned = assign_port_name($intf_id,"tap","TMSPort",$tms_name);
      $default_name = ($assigned) ? "" : "DEFAULT_NAME";
      print ("-I- TAP module $module_name: TDO port assigned to $default_name '$tms_name' (No assigned ScanInterface)\n");
   }
   
   my $slvidcode_exists = 0;
   my $pwrgood_exists = (exists $comp_db{$def_path}{pwrgood_id}) && scalar(%{$comp_db{$def_path}{pwrgood_id}});

   if ($is_top_level) { # use names from ICL header file
      if (exists $comp_db{$def_path}{intf}) {

         $assigned = assign_port_name($intf_id,"tap","TRSTPort",$trst_name);
         print ("-I- Top TRSTb port assigned to '$trst_name'\n");

         $assigned = assign_port_name($intf_id,"tap","TCKPort",$tclk_name);
         print ("-I- Top TCLK port assigned to '$tclk_name'\n");

         $assigned = assign_port_name($intf_id,"slvidcode","DataInPort",$slvidcode_name);
         if ($assigned) {
             print ("-I- Top TAP SLVIDCODE strap port assigned to '$slvidcode_name'\n");
             $slvidcode_exists = 1;
         } else {
            print ("-I- No top TAP SLVIDCODE strap port exists\n");
         }
      } else { # use standard/default names
      }

#      if ($pwrgood_exists) {
#         # Use power domain IDs
#      # FIXME
#      } elsif (exists $comp_db{$def_path}{intf}) {
#
#         $assigned = assign_port_name($intf_id,"powergood","ResetPort",$pwrgood_name);
#         if ($assigned) {
#            print ("-I- Top DFx Powergood port assigned to '$pwrgood_name'\n");
#            $pwrgood_exists = 1;
#         } else {
#            print ("-W- No top DFx Powergood port exists\n");
#            print ("-W- All TAP registers will use TRSTb for reset\n");
#            $pwrgood_name = $trst_name;
#         }
#      }

      if ($security_exists && exists $comp_db{$def_path}{intf}) {
         $assigned = assign_port_name($intf_id,"secure_policy","DataInPort",$security_name);
         if ($assigned) {
            print ("-I- Top TAP Security port assigned to '$security_name'\n");
         }
         my $assigned_unlock;
         $assigned_unlock = assign_port_name($intf_id,"secure_red","DataInPort",$security_red_name);
         if ($assigned_unlock) {
            print ("-I- Top TAP RED unlock port assigned to '$security_red_name'\n");
            if ($assigned) {
               die "-E- Secure Policy port $security_name and RED unlock port $security_red_name cannot coexist\n";
            }
            $security_unlock = 1;
         } else {
            if ($security_red_exists && !$assigned) {
               die "-E- RED secure policy is used but no RED unlock or Secure Policy port found\n";
            }
         }
         $assigned_unlock = assign_port_name($intf_id,"secure_orange","DataInPort",$security_orange_name);
         if ($assigned_unlock) {
            print ("-I- Top TAP ORANGE unlock port assigned to '$security_orange_name'\n");
            if ($assigned) {
               die "-E- Secure Policy port $security_name and ORANGE unlock port $security_orange_name cannot coexist\n";
            }
            $security_unlock = 1;
         } else {
            if ($security_orange_exists && !$assigned) {
               die "-E- ORANGE secure policy is used but no ORANGE unlock or Secure Policy port found\n";
            }
         }
         $assigned_unlock = assign_port_name($intf_id,"secure_green","DataInPort",$security_green_name);
         if ($assigned_unlock) {
            print ("-I- Top TAP GREEN unlock port assigned to '$security_green_name'\n");
            if ($assigned) {
               die "-E- Secure Policy port $security_name and GREEN unlock port $security_green_name cannot coexist\n";
            }
         }
      }
   } else { # use standard/default names
   }

   if (!defined $intf_id) {
      $intf_id = "c_tap";
   }
   
   print $ofile ("\n${indent}//--------------------------------------------------------------------------------\n");
   print $ofile ("${indent}//Local Parameters\n");
   print $ofile ("${indent}Parameter IR_SIZE = $ir_length;\n\n");
   if ($security_exists) {
      print $ofile ("${indent}LocalParameter RED     = 2'b11;\n");
      print $ofile ("${indent}LocalParameter ORANGE  = 2'bx1;\n");
      print $ofile ("${indent}LocalParameter GREEN   = 2'bxx;\n");
   }

   print $ofile ("\n${indent}//--------------------------------------------------------------------------------\n");
   print $ofile ("${indent}//TAP Opcodes\n");
   foreach my $reg (@sorted_reg_list) {
      my $opcode = $reg_hash{$reg}{opcode};
      print $ofile ("${indent}LocalParameter ${reg}_OPCODE = 'h${opcode};\n");
   }

   print $ofile ("\n${indent}//--------------------------------------------------------------------------------\n");
   print $ofile ("${indent}//TAP DR Sizes\n");
   foreach my $reg (@sorted_reg_list) {
      my $reg_size = $reg_hash{$reg}{size};
      print $ofile ("${indent}LocalParameter ${reg}_DR_SIZE = $reg_size;\n");
   }

   if ($security_exists) {
      print $ofile ("\n${indent}//--------------------------------------------------------------------------------\n");
      print $ofile ("${indent}//TAP DR Security Levels\n");
      foreach my $reg (@sorted_reg_list) {
         my $reg_security = $reg_hash{$reg}{security_short};
         print $ofile ("${indent}LocalParameter ${reg}_SECURITY = \$$reg_security;\n");
      }
   }

   print $ofile ("\n${indent}//--------------------------------------------------------------------------------\n");
   print $ofile ("${indent}//OPCODE Enum\n");
   print $ofile ("${indent}Enum TAP_INSTRUCTIONS {\n");
   foreach my $reg (@sorted_reg_list) {
      print $ofile ("${indent}   ${reg} = \$${reg}_OPCODE;\n");
   }
   print $ofile ("${indent}}\n");

   print $ofile ("\n${indent}//--------------------------------------------------------------------------------\n");
   print $ofile ("${indent}// TAP ports & interfaces\n");
   print $ofile ("${indent}// All ports in ICL must match corresponding RTL module port names\n\n");

   my $port_def_block = icl_get_port_properties("ScanInPort",$tdi_name,1,1);
   print $ofile ("${indent}ScanInPort    $tdi_name$port_def_block\n");

   $port_def_block = icl_get_port_properties("ScanOutPort",$tdo_name,0,1);
   print $ofile ("${indent}ScanOutPort   $tdo_name { Source tdo_mux;$port_def_block}\n");

   $port_def_block = icl_get_port_properties("TMSPort",$tms_name,1,1);
   print $ofile ("${indent}TMSPort       $tms_name$port_def_block\n");

   $port_def_block = icl_get_port_properties("TRSTPort",$trst_name,1,1);
   print $ofile ("${indent}TRSTPort      $trst_name$port_def_block\n");

   $port_def_block = icl_get_port_properties("TCKPort",$tclk_name,1,1);
   print $ofile ("${indent}TCKPort       $tclk_name$port_def_block\n");

   if ($is_top_level) {
    if (exists $icl_comp_db{$gIclModulePath}{port}{ScanInPort}{$tdi_name}) {
       if (!exists $icl_comp_db{$gIclModulePath}{printed_ports}{$tdi_name}) {
          $icl_comp_db{$gIclModulePath}{printed_ports}{$tdi_name} = 1;
       } else {
          die "-E- Something wrong, definition for top level port $tdi_name was printed already\n";
       }
    }
    if (exists $icl_comp_db{$gIclModulePath}{port}{ScanOutPort}{$tdo_name}) {
       if (!exists $icl_comp_db{$gIclModulePath}{printed_ports}{$tdo_name}) {
          $icl_comp_db{$gIclModulePath}{printed_ports}{$tdo_name} = 1;
       } else {
          die "-E- Something wrong, definition for top level port $tdo_name was printed already\n";
       }
    }
    if (exists $icl_comp_db{$gIclModulePath}{port}{TRSTPort}{$trst_name}) {
       if (!exists $icl_comp_db{$gIclModulePath}{printed_ports}{$trst_name}) {
          $icl_comp_db{$gIclModulePath}{printed_ports}{$trst_name} = 1;
       } else {
          die "-E- Something wrong, definition for top level port $trst_name was printed already\n";
       }
    }
    if (exists $icl_comp_db{$gIclModulePath}{port}{TCKPort}{$tclk_name}) {
       if (!exists $icl_comp_db{$gIclModulePath}{printed_ports}{$tclk_name}) {
          $icl_comp_db{$gIclModulePath}{printed_ports}{$tclk_name} = 1;
       } else {
          die "-E- Something wrong, definition for top level port $tclk_name was printed already\n";
       }
    }
    if (exists $icl_comp_db{$gIclModulePath}{port}{TMSPort}{$tms_name}) {
       if (!exists $icl_comp_db{$gIclModulePath}{printed_ports}{$tms_name}) {
          $icl_comp_db{$gIclModulePath}{printed_ports}{$tms_name} = 1;
       } else {
          die "-E- Something wrong, definition for top level port $tms_name was printed already\n";
       }
    }
   }

   # FIXME

   if ($pwrgood_exists) {

      print $ofile ("\n${indent}// DFx powergood/reset ports\n");

      foreach my $pwr_id (keys %{$comp_db{$def_path}{pwrgood_id}}) {
         if ($is_top_level) {
            if (!exists $icl_comp_db{$gIclModulePath}{reset_mapping}{pwrgood_id}{$pwr_id}) {
               die "-E- Something wrong, powergood port with ID '$pwr_id' does not exist in the ICL header file (TAP $def_path)\n";
            }
            my $pwrgood_port     = $icl_comp_db{$gIclModulePath}{reset_ports}{powergood}{$pwr_id}{port_name}; 
            my $pwrgood_polarity = $icl_comp_db{$gIclModulePath}{reset_ports}{powergood}{$pwr_id}{polarity}; 
            if (!exists $icl_comp_db{$gIclModulePath}{printed_ports}{$pwrgood_port}) {
               $port_def_block = icl_get_port_properties("ResetPort",$pwrgood_port,0,0);
               print $ofile ("${indent}ResetPort      $pwrgood_port { ActivePolarity $pwrgood_polarity;$port_def_block}\n");
               $icl_comp_db{$gIclModulePath}{printed_ports}{$pwrgood_port} = 1;
            }
         } else {
            my $port_suffix = ($pwr_id eq "") ? "" : "_$pwr_id";
            print $ofile ("${indent}ResetPort      $pwrgood_name_default$port_suffix { ActivePolarity 0;}\n");
         }
      }
   }

   if ($security_exists) {
      #print $ofile ("\n${indent}// DFx Secure Plugin - simplified: no latch, fdfx_earlyboot_exit, fdfx_policy_update\n");
      #print $ofile ("${indent}DataInPort     $security_name;\n");
      # FIXME $test_indent
      if ($security_unlock) {
         print $ofile ("\n");
         if ($is_top_level) {
            if ($security_red_name ne "") {

               $port_def_block = icl_get_port_properties("DataInPort",$security_red_name,1,0);

               print $ofile ("${text_indent}DataInPort     $security_red_name$port_def_block\n");
               if (exists $icl_comp_db{$gIclModulePath}{port}{DataInPort}{$security_red_name}) {
                  if (!exists $icl_comp_db{$gIclModulePath}{printed_ports}{$security_red_name}) {
                     $icl_comp_db{$gIclModulePath}{printed_ports}{$security_red_name} = 1;
                  } else {
                     die "-E- Something wrong, definition for top level port $security_red_name was printed already\n";
                  }
               }
            }
            if ($security_orange_name ne "") {

               $port_def_block = icl_get_port_properties("DataInPort",$security_orange_name,1,0);

               print $ofile ("${text_indent}DataInPort     $security_orange_name$port_def_block\n");
               if (exists $icl_comp_db{$gIclModulePath}{port}{DataInPort}{$security_orange_name}) {
                  if (!exists $icl_comp_db{$gIclModulePath}{printed_ports}{$security_orange_name}) {
                     $icl_comp_db{$gIclModulePath}{printed_ports}{$security_orange_name} = 1;
                  } else {
                     die "-E- Something wrong, definition for top level port $security_orange_name was printed already\n";
                  }
               }
            }
         } else {
            print $ofile ("${text_indent}DataInPort    dfxsecure_feature_en[2:0];\n");
         }
      } else {
         icl_print_secure_ports($security_name,$ofile);
         if ($is_top_level && exists $icl_comp_db{$gIclModulePath}{port}{DataInPort}{$security_name}) {
            if (!exists $icl_comp_db{$gIclModulePath}{printed_ports}{$security_name}) {
               $icl_comp_db{$gIclModulePath}{printed_ports}{$security_name} = 1;
            } else {
               die "-E- Something wrong, definition for top level port $security_name was printed already\n";
            }
         }
      }
   }

   print $ofile ("\n${indent}// Client TAP/JTAG interface\n");
   print $ofile ("${indent}ScanInterface $intf_id {\n");
   print $ofile ("${indent}   Port   $tdi_name;\n");
   print $ofile ("${indent}   Port   $tdo_name;\n");
   print $ofile ("${indent}   Port   $tms_name;\n");
   print $ofile ("${indent}}\n");

   if ( $gTapLink ) {
      print $ofile ("\n${indent}\n// Taplink interface\n");
      print $ofile ("${indent}SelectPort    Taplink_ir_sel;\n");
      print $ofile ("\n${indent}ScanInterface c_tl {\n");
      print $ofile ("${indent}  Port   $tdi_name;\n");
      print $ofile ("${indent}  Port   $tdo_name;\n");
      print $ofile ("${indent}  Port   Taplink_ir_sel;\n");
      print $ofile ("${indent}}\n");
   }

   if (scalar(@sorted_rtdr_list)) {
      print $ofile ("\n${indent}// Host RTDR interfaces\n");
      foreach my $inst (@sorted_rtdr_list) {

         my $ipath = "$def_path.$inst";
         my $dpath = $inst_db{$ipath}{cpath};
         my $fpath = "$full_inst_path.$inst";

         my $si_port = "";
         my $so_port = "";
         my $sel_port = "";
         my %printed_scaninteface_ports = ();

         my $intf = $inst_db{$ipath}{host_intf};

         print $ofile ("${indent}// --------------------\n");
         print $ofile ("${indent}// RTDR $inst\n\n");

         if (exists $icl_comp_db{$gIclModulePath}{interface}{$intf}{map}{ScanInPort}) {
            if (scalar(@{$icl_comp_db{$gIclModulePath}{interface}{$intf}{map}{ScanInPort}}) != 1) {
                die "-E- Host scan interface $intf must have one ScanInPort port\n";
            }
            my $port_name = $icl_comp_db{$gIclModulePath}{interface}{$intf}{map}{ScanInPort}[0];
            $si_port = $port_name;
            if (!exists $icl_comp_db{$gIclModulePath}{printed_ports}{$port_name}) {

               $port_def_block = icl_get_port_properties("ScanInPort",$port_name,1,0);

               print $ofile ("${indent}ScanInPort   \t$port_name$port_def_block\n");
               $icl_comp_db{$gIclModulePath}{printed_ports}{$port_name} = 1;
            }
         } else {
            die "-E- Host scan interface $intf must have ScanInPort port\n";
         }

         $reg_hash{$inst}{si_port} = $si_port;

         if (exists $icl_comp_db{$gIclModulePath}{interface}{$intf}{map}{ScanOutPort}) {
            my $port_num = scalar(@{$icl_comp_db{$gIclModulePath}{interface}{$intf}{map}{ScanOutPort}});
            if ($port_num > 1) {
                die "-E- Host scan interface $intf can have not more than one ScanOutPort port\n";
            }
            my $port_name = $icl_comp_db{$gIclModulePath}{interface}{$intf}{map}{ScanOutPort}[0];
            $so_port = $port_name;
            if (!exists $icl_comp_db{$gIclModulePath}{printed_ports}{$port_name}) {

               $port_def_block  = icl_get_port_properties("ScanOutPort",$port_name,0,0);
               my $port_source  = icl_get_port_source("ScanOutPort",$port_name);
               $port_def_block .= ($port_source eq "") ? " Source $tdi_name;" : $port_source;
               $port_def_block .= icl_get_port_source("ScanOutPort",$port_name);

               print $ofile ("${indent}ScanOutPort   \t$port_name {$port_def_block}\n");
               $icl_comp_db{$gIclModulePath}{printed_ports}{$port_name} = 1;
            }
            #FIXME print source and other attributes if available
         }

         if (exists $icl_comp_db{$gIclModulePath}{interface}{$intf}{map}{ToSelectPort}) {
            if (scalar(@{$icl_comp_db{$gIclModulePath}{interface}{$intf}{map}{ToSelectPort}}) != 1) {
                die "-E- Host scan interface $intf must have only one ToSelectPort port\n";
            }
            my $port_name = $icl_comp_db{$gIclModulePath}{interface}{$intf}{map}{ToSelectPort}[0];
            $sel_port = $port_name;
            if (!exists $icl_comp_db{$gIclModulePath}{printed_ports}{$port_name}) {

               $port_def_block = icl_get_port_properties("ToSelectPort",$port_name,0,0);

               print $ofile ("${indent}ToSelectPort   \t$port_name { Source sel_$inst;$port_def_block}\n");
               $icl_comp_db{$gIclModulePath}{printed_ports}{$port_name} = 1;
            }
         } else {
            die "-E- Host scan interface $intf must have ToSelectPort port\n";
         }

         foreach my $port_name (keys %{$icl_comp_db{$gIclModulePath}{interface}{$intf}{ports}}) {
            if (!exists $icl_comp_db{$gIclModulePath}{printed_ports}{$port_name}) {
               my $port_type = $icl_comp_db{$gIclModulePath}{interface}{$intf}{ports}{$port_name};

               $port_def_block  = icl_get_port_source($port_type,$port_name);
               $port_def_block .= icl_get_port_active_polarity($port_type,$port_name);
               $port_def_block .= icl_get_port_properties($port_type,$port_name,0,0);

               # Terminate the block
               $port_def_block = ($port_def_block eq "") ? ";" : " {$port_def_block}";

               print $ofile ("${indent}$port_type   \t$port_name$port_def_block\n");
               $icl_comp_db{$gIclModulePath}{printed_ports}{$port_name} = 1;
            }
         }

         print $ofile ("\n${indent}ScanInterface $intf {\n");
         print $ofile ("${indent}   Port   $si_port;\n");
         print $ofile ("${indent}   Port   $so_port;\n");
         print $ofile ("${indent}   Port   $sel_port;\n");
         foreach my $port_name (keys %{$icl_comp_db{$gIclModulePath}{interface}{$intf}{ports}}) {
            if (($port_name ne $si_port) &&
               ($port_name ne $so_port) &&
               ($port_name ne $sel_port)) {
               print $ofile ("${indent}   Port   $port_name;\n");
            }
         }
         icl_print_attr($dpath, $fpath, $ofile,1,1,1,0);
         print $ofile ("${indent}}\n");
      }
   }

   print $ofile ("\n${indent}//--------------------------------------------------------------------------------\n");
   print $ofile ("${indent}// Base TAP logic\n");
   print $ofile ("${indent}//--------------------------------------------------------------------------------\n\n");
   print $ofile ("${indent}// TaP FSM\n");
   print $ofile ("${indent}Instance fsm Of iclgen_intel_tap_fsm {\n");
   print $ofile ("${indent}  InputPort   tck   = $tclk_name;\n");
   print $ofile ("${indent}  InputPort   tms   = $tms_name;\n");
   print $ofile ("${indent}  InputPort   trstb = $trst_name;\n");
   print $ofile ("${indent}}\n");

   if ($security_exists) {
      if ($security_unlock) {
         if ($is_top_level) {
            my $red_name    = ($security_red_name ne "")    ?  $security_red_name    : "1'b0";
            my $orange_name = ($security_orange_name ne "") ?  $security_orange_name : "1'b0";
            print $ofile ("\n${indent}LogicSignal   unlock_red {\n");
            print $ofile ("${indent}    $red_name;\n");
            print $ofile ("${indent}}\n\n");
            print $ofile ("${indent}LogicSignal   unlock_orange_or_red {\n");
            print $ofile ("${indent}    $red_name | $orange_name;\n");
            print $ofile ("${indent}}\n");
         } else {
            print $ofile ("\n${indent}LogicSignal   unlock_red {\n");
            print $ofile ("${indent}   dfxsecure_feature_en[2];\n");
            print $ofile ("${indent}}\n\n");
            print $ofile ("${indent}LogicSignal   unlock_orange_or_red {\n");
            print $ofile ("${indent}   dfxsecure_feature_en[2] | dfxsecure_feature_en[1];\n");
            print $ofile ("${indent}}\n");
         }
      } else {
         print $ofile ("\n${indent}// Intel TAP security\n");
         print $ofile ("${indent}Instance security Of iclgen_intel_dfxsecure_plugin {\n");
         print $ofile ("${indent}   InputPort   fdfx_secure_policy = $security_name;\n");
         print $ofile ("${indent}}\n\n");
         print $ofile ("${indent}LogicSignal   unlock_red {\n");
         print $ofile ("${indent}   security.dfxsecure_feature_en[2];\n");
         print $ofile ("${indent}}\n\n");
         print $ofile ("${indent}LogicSignal   unlock_orange_or_red {\n");
         print $ofile ("${indent}   security.dfxsecure_feature_en[2] | security.dfxsecure_feature_en[1];\n");
         print $ofile ("${indent}}\n");
      }
   }

   $ir_reset_opcode  = $reg_hash{TAP_IR}{reset_opcode};
   print $ofile ("\n${indent}// TAP IR\n");
   print $ofile ("${indent}Instance IR Of iclgen_intel_tap_ir {\n");
   print $ofile ("${indent}  Parameter   IR_SIZE        = \$IR_SIZE;\n");
   print $ofile ("${indent}  Parameter   IR_RESET_VALUE = $ir_reset_opcode;\n");
   # FIXME: make IR read value X for now
   print $ofile ("${indent}  Parameter   IR_CAPTURE_SRC = 'hx;\n");

   if (exists $reg_hash{TAP_IR}{capture_value}) {
      my $ir_capture_value = $reg_hash{TAP_IR}{capture_value};
      print $ofile ("${indent}  Attribute   intel_TapIrCaptureValue = $ir_capture_value;\n");
   }
      
   print $ofile ("${indent}  InputPort    si             = $tdi_name;\n");
   print $ofile ("${indent}  InputPort    rst            = fsm.tlr;\n");
   print $ofile ("${indent}}\n");
   print $ofile ("${indent}Alias IR[\$IR_SIZE-1:0] = IR.IR { RefEnum TAP_INSTRUCTIONS; }\n");

   print $ofile ("\n${indent}//TAP TDR selection & TDO muxing\n");
   print $ofile ("${indent}ScanMux tdo_mux SelectedBy fsm.irsel {\n");
   print $ofile ("${indent}   1'b0:    dr_mux;\n");
   print $ofile ("${indent}   1'b1:    IR.so;\n");
   print $ofile ("${indent}}\n");

   #print $ofile ("\n${indent}ScanMux ir_mux_tl SelectedBy Taplink_ir_sel {\n");
   #print $ofile ("${indent}   1'b0:    dr_mux;\n");
   #print $ofile ("${indent}   1'b1:    IR.so;\n");
   #print $ofile ("${indent}}\n");

   #FIXME
   #print $ofile ("\n${indent}ScanMux tdo_mux SelectedBy \$TAPLINK_MODE {\n");
   #print $ofile ("\n${indent}ScanMux tdo_mux SelectedBy 1'b0 {\n");
   #print $ofile ("${indent}   1'b0:    ir_mux;\n");
   ##print $ofile ("${indent}   1'b1:    ir_mux_tl;\n");
   #print $ofile ("${indent}   1'b1:    1'b0;\n");
   #print $ofile ("${indent}}\n");

   if ($security_exists) {
      print $ofile ("\n${indent}ScanMux dr_mux SelectedBy IR.tir_out, unlock_red, unlock_orange_or_red {\n");
      foreach my $reg (@sorted_reg_list) {
         if (exists $reg_hash{$reg}{is_rtdr}) {
            my $si_port = $reg_hash{$reg}{si_port};
            print $ofile ("${indent}   \$${reg}_OPCODE, \$${reg}_SECURITY: $si_port;\n");
         } else {
            print $ofile ("${indent}   \$${reg}_OPCODE, \$${reg}_SECURITY: ${reg}.so;\n");
         }
      }
      print $ofile ("${indent}   'bx, \$GREEN: BYPASS_RSVD.so;\n");
   } else {
      print $ofile ("\n${indent}ScanMux dr_mux SelectedBy IR.tir_out {\n");
      foreach my $reg (@sorted_reg_list) {
         if (exists $reg_hash{$reg}{is_rtdr}) {
            my $si_port = $reg_hash{$reg}{si_port};
            print $ofile ("${indent}   \$${reg}_OPCODE: $si_port;\n");
         } else {
            print $ofile ("${indent}   \$${reg}_OPCODE: ${reg}.so;\n");
         }
      }
      print $ofile ("${indent}   'bx: BYPASS_RSVD.so;\n");
   }
   print $ofile ("${indent}}\n");

   print $ofile ("\n${indent}//--------------------------------------------------------------------------------\n");
   print $ofile ("${indent}// TaP TDRs\n");

   print $ofile ("\n${indent}// BYPASS for reserved opcodes\n");
   print $ofile ("${indent}Instance BYPASS_RSVD Of iclgen_intel_bypass_rsvd_reg {\n");
   print $ofile ("${indent}  Attribute   intel_TapOpcodeSecurityLevel = \"SECURE_GREEN\";\n");
   print $ofile ("${indent}  InputPort   si  = $tdi_name;\n");
   print $ofile ("${indent}}\n");

   foreach my $inst (@sorted_reg_list) {

      my $ipath = "$def_path.$inst";
      my $dpath = $inst_db{$ipath}{cpath};
      my $fpath = "$full_inst_path.$inst";

      my $def_name =$inst_db{$ipath}{comp};
      # support anonymous reg instances
      $def_name =$inst_db{$ipath}{iname} if ($def_name eq "");
      my $inst_def_name       = icl_uniquify_def_name($def_name,$inst,$base_name,\%mi_hash);
      my $final_inst_def_name = icl_add_prefix_suffix($inst_def_name);
      $inst_db{$ipath}{new_def_name} = $final_inst_def_name;

      my $comp_type = $comp_db{$dpath}{type};
      my $is_reg     = ($comp_type eq "reg");
      my $is_regfile = ($comp_type eq "regfile");

      #my $is_rtdr = (exists $inst_db{$ipath}{host_intf});
      my $is_rtdr = (exists $reg_hash{$inst}{is_rtdr});

      print $ofile ("\n${indent}//---------------------------\n");

      my $is_exported_data_in_port = 0;    

      if (exists $inst_db{$ipath}{DataInPort}) {
         foreach my $port_name (sort keys %{$inst_db{$ipath}{DataInPort}}) {
            if (!exists $icl_comp_db{$gIclModulePath}{port}{DataInPort}{$port_name}{assigned_to}) {next;}
            if ($is_rtdr) {
               warn "-W- Register $inst is RTDR - exported DataInPort $port_name will be ignored\n";
               next;
            }
            if ($is_top_level) {
               #my $test_block = ";";
               #if (exists $icl_comp_db{$gIclModulePath}{port}{DataInPort}{$port_name}{DefaultLoadValue}) {
               #   my $value = $icl_comp_db{$gIclModulePath}{port}{DataInPort}{$port_name}{DefaultLoadValue};
               #   $test_block = " {DefaultLoadValue $value; }";
               #}
               $port_def_block = icl_get_port_properties("DataInPort",$port_name,1,0);
               print $ofile ("${indent}DataInPort     $port_name$port_def_block\n");
               if (exists $icl_comp_db{$gIclModulePath}{port}{DataInPort}{$port_name}) {
                  if (!exists $icl_comp_db{$gIclModulePath}{printed_ports}{$port_name}) {
                     $icl_comp_db{$gIclModulePath}{printed_ports}{$port_name} = 1;
                  } else {
                     die "-E- Something wrong, definition for top level port $port_name was printed already\n";
                  }
               }
            } else {
               my $pname = $comp_db{$def_path}{DataInPort}{$port_name}{name};
               print $ofile ("${indent}DataInPort     tdr_in_$pname;\n");
            }
            $is_exported_data_in_port = 1;
         }
         print $ofile ("\n");
      }

      if (exists $inst_db{$ipath}{DataOutPort}) {
         foreach my $port_name (sort keys %{$inst_db{$ipath}{DataOutPort}}) {
            if (!exists $icl_comp_db{$gIclModulePath}{port}{DataOutPort}{$port_name}{assigned_to}) {next;}
            if ($is_rtdr) {
               warn "-W- Register $inst is RTDR - exported DataOutPort $port_name will be ignored\n";
               next;
            }
            if ($is_top_level) {
               my $pname = $inst_db{$ipath}{DataOutPort}{$port_name}{name};
               $port_def_block  = icl_get_port_enable("DataOutPort",$port_name);
               $port_def_block .= icl_get_port_properties("DataOutPort",$port_name,0,0);
               print $ofile ("${indent}DataOutPort    $port_name { Source $inst.tdr_out_$pname;$port_def_block}\n");
               if (exists $icl_comp_db{$gIclModulePath}{port}{DataOutPort}{$port_name}) {
                  if (!exists $icl_comp_db{$gIclModulePath}{printed_ports}{$port_name}) {
                     $icl_comp_db{$gIclModulePath}{printed_ports}{$port_name} = 1;
                  } else {
                     die "-E- Something wrong, definition for top level port $port_name was printed already\n";
                  }
               }
            } else {
               my $pname = $comp_db{$def_path}{DataOutPort}{$port_name}{name};
               my $dest = $comp_db{$def_path}{DataOutPort}{$port_name}{dest};
               my $conn = $comp_db{$def_path}{DataOutPort}{$port_name}{conn};
               my $tdr_out_name = ($conn eq "") ? "tdr_out" : "tdr_out_$conn" ;
               print $ofile ("${indent}DataOutPort    tdr_out_$pname { Source $dest.$tdr_out_name;}\n");
            }
         }
         print $ofile ("\n");
      }

      if ($is_rtdr) {

         print $ofile ("${indent}// RTDR $inst: Select signal\n");

         if ($security_exists) {
            print $ofile ("\n${indent}DataMux sel_$inst SelectedBy IR.tir_out, unlock_red, unlock_orange_or_red {\n");
            print $ofile ("${indent}   \$${inst}_OPCODE, \$${inst}_SECURITY: 1'b1;\n");
            print $ofile ("${indent}   'bx, \$GREEN: 1'b0;\n");
            print $ofile ("${indent}}\n");
         } else {
            print $ofile ("\n${indent}DataMux sel_$inst SelectedBy IR.tir_out {\n");
            print $ofile ("${indent}   \$${inst}_OPCODE: 1'b1;\n");
            print $ofile ("${indent}   'bx: 1'b0;\n");
            print $ofile ("${indent}}\n");
         }
         
      } elsif ($is_reg) {

         my $is_ext_slvidcode = ($slvidcode_exists && ($inst =~ /slvidcode/i)) && !$is_exported_data_in_port;

         #FIXME
         if ($is_ext_slvidcode) {
            print $ofile ("\n${indent}// SLVIDCODE strap\n");
            if ($is_top_level && exists $icl_comp_db{$gIclModulePath}{port}{DataInPort}{$slvidcode_name}) {
               $port_def_block = icl_get_port_properties("DataInPort",$slvidcode_name,1,0);
               print $ofile ("${indent}DataInPort     $slvidcode_name$port_def_block\n\n");
               if (!exists $icl_comp_db{$gIclModulePath}{printed_ports}{$slvidcode_name}) {
                  $icl_comp_db{$gIclModulePath}{printed_ports}{$slvidcode_name} = 1;
               } else {
                  die "-E- Something wrong, definition for top level port $slvidcode_name was printed already\n";
               }
            } else {
               print $ofile ("${indent}DataInPort     $slvidcode_name;\n\n");
            }

            print $ofile ("${indent}Instance $inst Of iclgen_intel_slvidcode_strap_reg {\n");
            if (exists $param_comp_db{$dpath}) {
               die "-E- SLVIDCODE $ipath is parameterized - cannot use EXT flow\n";
            }
         } else {
            print $ofile ("${indent}Instance $inst Of $final_inst_def_name {\n");
         }
         icl_print_inst_param($dpath, $ofile);
         icl_print_attr($dpath, $fpath, $ofile,1,1,1,0);
         print $ofile ("${indent}   InputPort   si = $tdi_name;\n");
         # FIXME generic support of reet connection
         if ($is_ext_slvidcode) {
            print $ofile ("${indent}   InputPort   ftap_slvidcode = $slvidcode_name;\n");
         } else {
            if (exists $inst_db{$ipath}{trst} || exists $inst_db{$ipath}{tlr}) {
               print $ofile ("${indent}   InputPort   rstn = ~fsm.tlr;\n");
            } elsif (exists $inst_db{$ipath}{pwrgood_id}) {
               my $pwr_id       = $inst_db{$ipath}{pwrgood_id};
               if ($is_top_level) {
                  my $pwrgood_port     = $icl_comp_db{$gIclModulePath}{reset_mapping}{pwrgood_id}{$pwr_id}{port_name};
                  my $pwrgood_polarity = $icl_comp_db{$gIclModulePath}{reset_mapping}{pwrgood_id}{$pwr_id}{polarity};
                  my $sig_polarity = ($pwrgood_polarity == 0) ? "" : "~";
                  print $ofile ("${indent}   InputPort   rstn = $sig_polarity$pwrgood_port;\n");
               } else {
                  my $pwr_suffix = ($pwr_id eq "") ? "" : "_$pwr_id";
                  print $ofile ("${indent}   InputPort   rstn = $pwrgood_name_default$pwr_suffix;\n");
               }
            } else {
               die "-E- Register $ipath (definition $dpath) doesn't have reset\n";
               #print $ofile ("${indent}   InputPort   rstn = $pwrgood_name;\n"); # FIXME add reset type
            }
         }
         if (exists $inst_db{$ipath}{DataInPort}) {
            foreach my $port_name (sort keys %{$inst_db{$ipath}{DataInPort}}) {
               my $pname = $inst_db{$ipath}{DataInPort}{$port_name}{name};
               my $conn = $inst_db{$ipath}{DataInPort}{$port_name}{conn};
               my $tdr_in_name = ($pname eq "") ? "tdr_in" : "tdr_in_$pname" ;
               if ($is_top_level) {
                  print $ofile ("${indent}   InputPort   $tdr_in_name = $port_name;\n");
               } else {
                  print $ofile ("${indent}   InputPort   $tdr_in_name = tdr_in_$conn;\n");
               }
            }
         }
         print $ofile ("${indent}}\n");
         if ($reg_hash{$inst}{size} ne "\"VARIABLE\"") {
            print $ofile ("${indent}Alias ${inst}[\$${inst}_DR_SIZE-1:0] = ${inst}.DR;\n");
         }
         if (!$is_ext_slvidcode) {
          if (! exists $included_defs{$final_inst_def_name}) {
            push @reg_defs_to_print, $inst;
            $included_defs{$final_inst_def_name} = 1;
          } else { # eliminate non-used override warnings from non-printed MI (reused) definitions
             $printed_non_mi_defs_hash{$dpath} = 1;
          }
         }
      } elsif ($is_regfile) {
         print $ofile ("${indent}Instance $inst Of $final_inst_def_name {\n");
         icl_print_inst_param($dpath, $ofile);
         icl_print_attr($dpath, $fpath, $ofile,1,1,1,0);
         print $ofile ("${indent}   InputPort   si = $tdi_name;\n");
         if (exists $inst_db{$ipath}{trst} || exists $inst_db{$ipath}{tlr}) {
            print $ofile ("${indent}   InputPort   ijtag_reset_b = ~fsm.tlr;\n");
         }
         if (exists $inst_db{$ipath}{pwrgood_id}) {
            foreach my $pwr_id (keys %{$inst_db{$ipath}{pwrgood_id}}) {
               if ($is_top_level) {
                  my $pwrgood_port     = $icl_comp_db{$gIclModulePath}{reset_mapping}{pwrgood_id}{$pwr_id}{port_name};
                  my $pwrgood_polarity = $icl_comp_db{$gIclModulePath}{reset_mapping}{pwrgood_id}{$pwr_id}{polarity};
                  my $sig_polarity = ($pwrgood_polarity == 0) ? "" : "~";
                  print $ofile ("${indent}   InputPort   rstn = $sig_polarity$pwrgood_port;\n");
               } else {
                  my $pwr_suffix = ($pwr_id eq "") ? "" : "_$pwr_id";
                  print $ofile ("${indent}   InputPort   rstn$pwr_suffix = $pwrgood_name_default$pwr_suffix;\n");
               }
            }
         }

         if (exists $inst_db{$ipath}{DataInPort}) {
            foreach my $port_name (sort keys %{$inst_db{$ipath}{DataInPort}}) {
               my $pname = $inst_db{$ipath}{DataInPort}{$port_name}{name};
               my $conn = $inst_db{$ipath}{DataInPort}{$port_name}{conn};
               if ($is_top_level) {
                  print $ofile ("${indent}   InputPort   tdr_in_$pname = $port_name;\n");
               } else {
                  print $ofile ("${indent}   InputPort   tdr_in_$pname = tdr_in_$conn;\n");
               }
            }
         }

         print $ofile ("${indent}}\n");
         if (! exists $included_defs{$final_inst_def_name}) {
            push @regfile_defs_to_print, $inst;
            $included_defs{$final_inst_def_name} = 1;
         } else { # eliminate non-used override warnings from non-printed MI (reused) definitions
            $printed_non_mi_defs_hash{$dpath} = 1;
         }
      } else {
         die "-E- Definition $def_path cannot instantiate component of type $comp_type (instance: $inst)\n";
      }
   } #foreach

   if ($is_top_level) {
      icl_print_extra_ports($ofile);
   }

   print $ofile ("} // end of $new_def_name\n\n");

   print $ofile ("\n// Chain Definitions\n");

   foreach my $inst (@regfile_defs_to_print) {
      my $ipath  = "$def_path.$inst";
      my $dpath  = $inst_db{$ipath}{cpath};
      my $fpath  = "$full_inst_path.$inst";
      my $new_def_name = $inst_db{$ipath}{new_def_name};

      print $ofile ("//---------------------------\n");
      icl_print_regfile($dpath,$fpath,$base_name,$ofile,$new_def_name);
   }
   print $ofile ("\n// Register Definitions\n");

   foreach my $inst (@reg_defs_to_print) {
      my $ipath  = "$def_path.$inst";
      my $dpath  = $inst_db{$ipath}{cpath};
      my $fpath  = "$full_inst_path.$inst";
      my $new_def_name = $inst_db{$ipath}{new_def_name};

      print $ofile ("//---------------------------\n");
      icl_print_reg($dpath,$fpath,$new_def_name,$ofile,\%reg_param_hash);
   }
}

# pirnt ICL definition for IP with no TAP (with TDRs/IJTAG only)
sub icl_print_reg_only
{
   my $def_path       = shift;
   my $full_inst_path = shift; # full relative path from the specified top instance
   my $ofile          = shift;
   my $base_name      = shift;
   my $new_def_name   = shift;
   my $is_top_level   = shift;

   my $comp_type = $comp_db{$def_path}{type};
   if ($comp_type ne "addrmap") {
      die "-E- Instance $full_inst_path is not an addrmap (actual type: $comp_type)\n";
   }

   %included_defs = ();

   # local for that specific definition!
   my %mi_hash;
   my %reg_param_hash;
   my @reg_list;
   my %reg_hash;
   my @reg_defs_to_print = ();
   my @regfile_defs_to_print = ();
   
   # FIXME check if it is required
   # populate global override db
   #icl_populate_ovrd_hash($def_path,$full_inst_path);

   # populate MI db and mark instances/definitions which require uniquification
   icl_process_mi($def_path,$full_inst_path,\%mi_hash);

   # populate info about each TAP opcode/register
   foreach my $inst (@{$comp_db{$def_path}{ilist}}) {
      my $ipath     = "$def_path.$inst";
      my $cpath     = $inst_db{$ipath}{cpath};
      my $fpath     = "$full_inst_path.$inst";
      if ($comp_db{$cpath}{type} eq "reg") {
        icl_process_reg_param($cpath,\%reg_param_hash);
        my $reg_width_is_parameterized = 0;
        if (exists $param_comp_db{$cpath}) {
           $reg_width_is_parameterized = exists $param_comp_db{$cpath}{reg_width_formula};
        }
        if ($comp_db{$cpath}{name} eq "TAP_IR") {
           warn "-W- Skipping TAP_IR definition/instance in the reg_only addrmap $def_path\n";
           next;
        }
        if (icl_get_attr('TapDrIsFixedSize', $cpath, $fpath, 1, 1, 0) eq 'true') { # fixed size reg
           if ($reg_width_is_parameterized) {
              $reg_hash{$inst}{size} = $param_comp_db{$cpath}{reg_width_formula};
           } else {
              $reg_hash{$inst}{size} = icl_get_attr('TapShiftRegLength', $cpath, $fpath, 0, 1, 0);
           }
        } else { # variable size reg
           $reg_hash{$inst}{size} = "\"VARIABLE\"";
        }
      } elsif ($comp_db{$cpath}{type} eq "regfile") {
         # FIXME: check if it is variable size or not
         $reg_hash{$inst}{size} = "\"VARIABLE\"";
      } else {
         my $comp_type = $comp_db{$cpath}{type};
         die "-E- reg_only wrapper definition cannot have instance of $comp_type (wrapper %def_path, instance $inst))\n";
      }

      push @reg_list, $inst;
      
      my $reg_inst_name = $inst_db{$ipath}{iname};
      $reg_hash{$inst}{name}   = $reg_inst_name;

      # FIXME: handling security info
      my $reg_security = icl_get_attr('TapOpcodeSecurityLevel', $cpath, $fpath, 0, 1, 1);
      if ($reg_security eq "") {$reg_security = "SECURE_GREEN";}
      $reg_hash{$inst}{security}       = $reg_security;
      $reg_security =~ s/SECURE_//;
      $reg_security =~ s/\"//g;
      $reg_hash{$inst}{security_short} = $reg_security;

   } #foreach inst
   
   # sorted reg list based on opcodes, from min to max
   my @sorted_reg_list = sort { lc($reg_hash{$a}{name}) cmp lc($reg_hash{$b}{name}) } @reg_list;
  
#   if ($is_top_level) {
#      print $ofile ("\nModule $gIclName {\n\n");
#   } else {
#      print $ofile ("\nModule $new_def_name {\n\n");
#   }

   icl_print_attr($def_path, $full_inst_path, $ofile,0,1,0,$is_top_level);

   my $indent = $text_indent;

   my $si_name_default          = "Si";
   my $so_name_default          = "So";
   my $sel_name_default         = "Select";

   my $capture_name_default     = "CaptureEn";
   my $shift_name_default       = "ShiftEn";
   my $update_name_default      = "UpdateEn";

   my $pwrgood_name_default     = "fdfx_powergood";
   my $trst_name_default        = "ijtag_rst_b";
   my $tclk_name_default        = "Tclk";

   my $pwrgood_name     = $pwrgood_name_default;
   my $trst_name        = $trst_name_default;
   my $tclk_name        = $tclk_name_default;

   my $intf_id = "";
   my $assigned;

   my $trst_exists    = (exists $comp_db{$def_path}{tlr}) || (exists $comp_db{$def_path}{trst});
   my $pwrgood_exists = (exists $comp_db{$def_path}{pwrgood_id}) && scalar(%{$comp_db{$def_path}{pwrgood_id}});
   my $trst_polarity = 0;

   if ($is_top_level) { # use names from ICL header file
      $assigned = assign_port_name($intf_id,"tap","TCKPort",$tclk_name);
      print ("-I- Top TCLK port assigned to '$tclk_name'\n");
   } else { # use standard/default names
   }

if ($is_top_level) { # use names from ICL header file

#      if ($pwrgood_id_exists) {
#         # Use power domain IDs
#         print ("-I- Top level RTDR registers: DFx powergood/reset connections use IDs in the ICL and RDL files\n");
#      # FIXME
#      } else {
#
#         $assigned = assign_port_name($intf_id,"powergood","ResetPort",$pwrgood_name);
#         if ($assigned) {
#            print ("-I- Top level RTDR registers: use DFx powergood port '$pwrgood_name'\n");
#            $pwrgood_exists = 1;
#         } else {
#         # FIXME
#            print ("-W- Top level RTDR registers: no top DFx Powergood port exists - will use the default name\n");
#         }
#      }

      #FIXME
      if ($trst_exists) {
         # FIXME use TLR for reg_only
         if (exists $icl_comp_db{$gIclModulePath}{reset_mapping}{tlr}) {
            $trst_name     = $icl_comp_db{$gIclModulePath}{reset_mapping}{tlr}{port_name};
            $trst_polarity = $icl_comp_db{$gIclModulePath}{reset_mapping}{tlr}{polarity};
         } else {
            my $assigned = assign_port_name($intf_id,"tlr","ResetPort",$trst_name);
            if (!$assigned) {
               die "-E- Something wrong, TLR ResetPort does not exist in the ICL header file\n";
            }
         }
         print ("-I- Top TRSTb/TLR port assigned to '$trst_name'\n");
      }

   } else { # use standard/default names
   }

   print $ofile ("\n${indent}//--------------------------------------------------------------------------------\n");
   print $ofile ("${indent}//TAP DR Sizes\n");
   foreach my $reg (@sorted_reg_list) {
      my $reg_size = $reg_hash{$reg}{size};
      print $ofile ("${indent}LocalParameter ${reg}_DR_SIZE = $reg_size;\n");
   }

   print $ofile ("\n${indent}//--------------------------------------------------------------------------------\n");
   print $ofile ("${indent}// Common RTDR/IJTAG ports\n");
   print $ofile ("${indent}// All ports in ICL must match corresponding RTL module port names\n\n");

   my $port_def_block = "";

   if (!exists $icl_comp_db{$gIclModulePath}{printed_ports}{$tclk_name}) {
      $port_def_block = icl_get_port_properties("TCKPort",$tclk_name,1,0);
      print $ofile ("${indent}TCKPort       $tclk_name$port_def_block\n\n");
      $icl_comp_db{$gIclModulePath}{printed_ports}{$tclk_name} = 1;
   }

   if ($trst_exists) {
      if (!exists $icl_comp_db{$gIclModulePath}{printed_ports}{$trst_name}) {
         print $ofile ("${indent}// TLR reset\n");
         $port_def_block  = icl_get_port_active_polarity("ResetPort",$trst_name);
         $port_def_block .= icl_get_port_properties("ResetPort",$trst_name,0,0);
         print $ofile ("${indent}ResetPort     $trst_name {$port_def_block}\n\n");
         $icl_comp_db{$gIclModulePath}{printed_ports}{$trst_name} = 1;
      }
   }

   if ($pwrgood_exists) {

      my $fdfx_pwrgood_comment_printed = 0;
      foreach my $pwr_id (keys %{$comp_db{$def_path}{pwrgood_id}}) {
         if (!exists $icl_comp_db{$gIclModulePath}{reset_mapping}{pwrgood_id}{$pwr_id}) {
            die "-E- Something wrong, powergood port with ID '$pwr_id' does not exist in the ICL header file (component: $def_path)\n";
         }
         my $pwrgood_port     = $icl_comp_db{$gIclModulePath}{reset_mapping}{pwrgood_id}{$pwr_id}{port_name}; 
         my $pwrgood_polarity = $icl_comp_db{$gIclModulePath}{reset_mapping}{pwrgood_id}{$pwr_id}{polarity}; 
         if (!exists $icl_comp_db{$gIclModulePath}{printed_ports}{$pwrgood_port}) {
            if (!$fdfx_pwrgood_comment_printed) {
                print $ofile ("${indent}// DFx powergood/reset ports\n");
                $fdfx_pwrgood_comment_printed = 1;
            }
            $port_def_block = icl_get_port_properties("ResetPort",$pwrgood_port,0,0);
            print $ofile ("${indent}ResetPort     $pwrgood_port { ActivePolarity $pwrgood_polarity;$port_def_block}\n");
            $icl_comp_db{$gIclModulePath}{printed_ports}{$pwrgood_port} = 1;
         }
      }
      if ($fdfx_pwrgood_comment_printed) {
         print $ofile ("\n");
      }
   }

   # FIXME print only assigned ports?
   my $printed_rtdr_ports = 0;
   foreach my $port_type (sort keys %{$icl_comp_db{$gIclModulePath}{port}}) {
      if (grep {/^$port_type$/} ('ShiftEnPort','CaptureEnPort','UpdateEnPort')) {
         foreach my $port_name (sort keys %{$icl_comp_db{$gIclModulePath}{port}{$port_type}}) {
            if (!exists $icl_comp_db{$gIclModulePath}{port}{$port_type}{$port_name}{intf}) {
               if (!exists $icl_comp_db{$gIclModulePath}{printed_ports}{$port_name}) {

                  $port_def_block  = icl_get_port_source($port_type,$port_name);
                  $port_def_block .= icl_get_port_properties($port_type,$port_name,0,0);

                  # Terminate the block
                  $port_def_block = ($port_def_block eq "") ? ";" : " {$port_def_block}";

                  print $ofile ("${indent}$port_type   \t$port_name$port_def_block\n");
                  $icl_comp_db{$gIclModulePath}{printed_ports}{$port_name} = 1;
                  $printed_rtdr_ports = 1;
               }
            }
         }
      } elsif (grep {/^$port_type$/} ('SelectPort')) {
         foreach my $port_name (sort keys %{$icl_comp_db{$gIclModulePath}{port}{$port_type}}) {
            if (!exists $icl_comp_db{$gIclModulePath}{port}{$port_type}{$port_name}{intf}) {
               if (!exists $icl_comp_db{$gIclModulePath}{printed_ports}{$port_name}) {

                  $port_def_block  = icl_get_port_source($port_type,$port_name);
                  $port_def_block .= icl_get_port_properties($port_type,$port_name,0,0);

                  # Terminate the block
                  $port_def_block = ($port_def_block eq "") ? ";" : " {$port_def_block}";

                  print $ofile ("${indent}$port_type   \t$port_name$port_def_block\n");
                  $icl_comp_db{$gIclModulePath}{printed_ports}{$port_name} = 1;
                  $printed_rtdr_ports = 1;
               }
            }
         }
      }
   }
   print $ofile ("\n") if ($printed_rtdr_ports);

   print $ofile ("${indent}//--------------------------------------------------------------------------------\n");
   print $ofile ("${indent}// TaP TDRs and ScanInterfaces\n");
   print $ofile ("${indent}//--------------------------------------------------------------------------------\n\n");

   my %printed_ports = ();
   my $shared_intf = "";
   my $printed_shared_intf = 0;
   my @shared_intf_reg_list = ();
   my $shared_intf_select_datain = "";

   # FIXME refactor the duplicated code
   foreach my $inst (@sorted_reg_list) {
      my $ipath = "$def_path.$inst";
      my $dpath = $inst_db{$ipath}{cpath};

      my $intf = "";
      if (exists $inst_db{$ipath}{intf}) {
         $intf = $inst_db{$ipath}{intf};
      }

      if (exists $inst_db{$ipath}{shared_intf}) {
         if ($inst_db{$ipath}{shared_intf}) {
            if ($shared_intf eq "") {
               $shared_intf = $intf;
            } elsif ($shared_intf ne $intf) {
               die "-E- Register $inst ($dpath): conflicting shared interfaces $shared_intf and $intf\n";
            }
            if (exists $inst_db{$ipath}{select_DataInPort}) {
               my $select_datain = $inst_db{$ipath}{select_DataInPort};
               if ($shared_intf_select_datain eq "") {
                  $shared_intf_select_datain = $select_datain;
               } elsif ($shared_intf_select_datain ne $select_datain) {
                  die "-E- Register $inst ($dpath): conflicting Select DataInPort for shared inteface ($select_datain vs. $shared_intf_select_datain)\n";
               }
            }
            push @shared_intf_reg_list, $inst;
         }
      }
   }
   my $num_of_shared_regs = scalar(@shared_intf_reg_list);

   foreach my $inst (@sorted_reg_list) {

      my $ipath = "$def_path.$inst";
      my $dpath = $inst_db{$ipath}{cpath};
      my $fpath = "$full_inst_path.$inst";

      my $def_name =$inst_db{$ipath}{comp};
      # support anonymous reg instances
      $def_name =$inst_db{$ipath}{iname} if ($def_name eq "");
      my $inst_def_name       = icl_uniquify_def_name($def_name,$inst,$base_name,\%mi_hash);
      my $final_inst_def_name = icl_add_prefix_suffix($inst_def_name);
      $inst_db{$ipath}{new_def_name} = $final_inst_def_name;
 
      my $intf = "";
      if (exists $inst_db{$ipath}{intf}) {
         $intf = $inst_db{$ipath}{intf};
      }

      my $is_shared_intf = 0;

      # FIXME duplicated code
      if (exists $inst_db{$ipath}{shared_intf}) {
         if ($inst_db{$ipath}{shared_intf}) {
            if ($shared_intf eq "") {
               $shared_intf = $intf;
            } elsif ($shared_intf ne $intf) {
               die "-E- Register $inst ($dpath): conflicting shared interfaces $shared_intf and $intf\n";
            }
            #push @shared_intf_reg_list, $inst;
            $is_shared_intf = 1;
         }
      }

      if ($intf eq "") {
         # Print using default names
         # FIXME: check name collisions?

         if (!exists $inst_db{$ipath}{ScanInPort}) {
            $inst_db{$ipath}{ScanInPort} = "${si_name_default}_$inst";
         } else {
            my $port_name = $inst_db{$ipath}{ScanInPort};
            die "-E- Register $inst with no ScanInterface has ScanInPort assignment $port_name\n";
         }

         if (!exists $inst_db{$ipath}{ScanOutPort}) {
            $inst_db{$ipath}{ScanOutPort} = "${so_name_default}_$inst";
         } else {
            my $port_name = $inst_db{$ipath}{ScanOutPort};
            die "-E- Register $inst with no ScanInterface has ScanOutPort assignment $port_name\n";
         }

         if (!exists $inst_db{$ipath}{SelectPort}) {
            $inst_db{$ipath}{SelectPort} = "${sel_name_default}_$inst";
         } else {
            my $port_name = $inst_db{$ipath}{SelectPort};
            die "-E- Register $inst with no ScanInterface has SelectPort assignment $port_name\n";
         }

         print $ofile ("${indent}ScanInPort    ${si_name_default}_$inst;\n");
         print $ofile ("${indent}ScanOutPort   ${so_name_default}_$inst { Source $inst.so; }\n");
         print $ofile ("${indent}SelectPort    ${sel_name_default}_$inst;\n");

         print $ofile ("${indent}ScanInterface c_default_$inst {\n"); 
         print $ofile ("${indent}   Port   ${si_name_default}_$inst;\n");
         print $ofile ("${indent}   Port   ${so_name_default}_$inst;\n"); 
         print $ofile ("${indent}   Port   ${sel_name_default}_$inst;\n");
         print $ofile ("${indent}}\n");

      } else {
         # FIXME: use shared_interface instead?
         my @port_list = ();
         if (exists $icl_comp_db{$gIclModulePath}{interface}{$intf}) {
            # FIXME: improve sort?
            my @not_sorted_port_list = (keys %{$icl_comp_db{$gIclModulePath}{interface}{$intf}{ports}});
            @port_list = sort { $icl_comp_db{$gIclModulePath}{interface}{$intf}{ports}{$a} cmp $icl_comp_db{$gIclModulePath}{interface}{$intf}{ports}{$b} } @not_sorted_port_list;
         } else {
            die "-E- Register $inst ($dpath): assigned ScanInterface $intf does not exists\n";
         }

         foreach my $port_name (@port_list) {
            my $port_type = $icl_comp_db{$gIclModulePath}{interface}{$intf}{ports}{$port_name};
            if (!exists $printed_ports{$port_name}) {
               if ($port_type eq "ScanOutPort") {
                  if (!exists $icl_comp_db{$gIclModulePath}{printed_ports}{$port_name}) {
                     $port_def_block  = icl_get_port_enable($port_type,$port_name);
                     $port_def_block .= icl_get_port_properties($port_type,$port_name,0,0);
                     my $source = ($is_shared_intf && ($num_of_shared_regs > 1)) ? "so_mux" : "$inst.so";
                     print $ofile ("${indent}$port_type\t $port_name { Source $source;$port_def_block}\n");
                     $icl_comp_db{$gIclModulePath}{printed_ports}{$port_name} = 1;
                  } else {
                     die "-E- ScanOutPort $port_name definition was printed already (definition: $def_path, reg instance $inst)\n";
                  }
               } else {
                  if (!exists $icl_comp_db{$gIclModulePath}{printed_ports}{$port_name}) {

                     $port_def_block  = icl_get_port_active_polarity($port_type,$port_name);
                     $port_def_block .= icl_get_port_properties($port_type,$port_name,0,0);

                     # Terminate the block
                     $port_def_block = ($port_def_block eq "") ? ";" : " {$port_def_block}";

                     print $ofile ("${indent}$port_type\t $port_name$port_def_block\n");
                     $icl_comp_db{$gIclModulePath}{printed_ports}{$port_name} = 1;
                  }
               }
               $printed_ports{$port_name}  = 1;
            }
         }

         if (!$is_shared_intf || !$printed_shared_intf) {
            print $ofile ("\n${indent}ScanInterface $intf {\n");
            foreach my $port_name (@port_list) {
               print $ofile ("${indent}   Port   $port_name;\n");
            }
            print $ofile ("${indent}}\n\n");
            if ($is_shared_intf) {$printed_shared_intf = 1;}
         }
      }

      # reg_only is alwasys top level
      if (exists $inst_db{$ipath}{DataInPort}) {
         foreach my $port_name (sort keys %{$inst_db{$ipath}{DataInPort}}) {
            if (!exists $icl_comp_db{$gIclModulePath}{port}{DataInPort}{$port_name}{assigned_to}) {next;}
            $port_def_block = icl_get_port_properties("DataInPort",$port_name,1,0);
            #my $test_block = ";";
            #if (exists $icl_comp_db{$gIclModulePath}{port}{DataInPort}{$port_name}{DefaultLoadValue}) {
            #   my $value = $icl_comp_db{$gIclModulePath}{port}{DataInPort}{$port_name}{DefaultLoadValue};
            #   $test_block = " {DefaultLoadValue $value; }";
            #}
            print $ofile ("${indent}DataInPort     $port_name$port_def_block\n");
            if (exists $icl_comp_db{$gIclModulePath}{port}{DataInPort}{$port_name}) {
               if (!exists $icl_comp_db{$gIclModulePath}{printed_ports}{$port_name}) {
                  $icl_comp_db{$gIclModulePath}{printed_ports}{$port_name} = 1;
               } else {
                  die "-E- Something wrong, definition for top level port $port_name was printed already\n";
               }
            }
         }
         print $ofile ("\n");
      }

      if (exists $inst_db{$ipath}{select_DataInPort}) {
         my $select_din_port = $inst_db{$ipath}{select_DataInPort};
         #my $enum_name = $icl_comp_db{$gIclModulePath}{port}{DataInPort}{$select_din_port}{RefEnum};
         my $enum_name = icl_get_port_refenum("DataInPort",$select_din_port);
         if (!exists $icl_comp_db{$gIclModulePath}{printed_enum_defs}{$enum_name}) {
            icl_print_enum($enum_name,$ofile);
            #print $ofile ("${indent}Enum   $enum_name {\n");
            ## ? FIXME sort using assigned value (independently on format)
            #foreach my $enum_item (sort keys %{$icl_comp_db{$gIclModulePath}{enum}{$enum_name}}) {
            #   my $enum_value = $icl_comp_db{$gIclModulePath}{enum}{$enum_name}{$enum_item};
            #   print $ofile ("${indent}   $enum_item = $enum_value;\n");
            #}
            #print $ofile ("${indent}}\n\n");
            print $ofile ("\n");
            $icl_comp_db{$gIclModulePath}{printed_enum_defs}{$enum_name} = 1;
         }
         if (!exists $icl_comp_db{$gIclModulePath}{printed_ports}{$select_din_port}) {
            $port_def_block = icl_get_port_properties("DataInPort",$select_din_port,1,0);
            print $ofile ("${indent}DataInPort   \t$select_din_port$port_def_block\n\n");
            $icl_comp_db{$gIclModulePath}{printed_ports}{$select_din_port} = 1;
         }
      }

      if (exists $inst_db{$ipath}{DataOutPort}) {
         foreach my $port_name (sort keys %{$inst_db{$ipath}{DataOutPort}}) {
            if (!exists $icl_comp_db{$gIclModulePath}{port}{DataOutPort}{$port_name}{assigned_to}) {next;}
            my $pname = $inst_db{$ipath}{DataOutPort}{$port_name}{name};
            my $tdr_out_name = ($pname eq "") ? "tdr_out" : "tdr_out_$pname" ;

            $port_def_block  = icl_get_port_enable("DataOutPort",$port_name);
            $port_def_block .= icl_get_port_properties("DataOutPort",$port_name,0,0);

            print $ofile ("${indent}DataOutPort    $port_name { Source $inst.$tdr_out_name;$port_def_block}\n");
            if (exists $icl_comp_db{$gIclModulePath}{port}{DataOutPort}{$port_name}) {
               if (!exists $icl_comp_db{$gIclModulePath}{printed_ports}{$port_name}) {
                  $icl_comp_db{$gIclModulePath}{printed_ports}{$port_name} = 1;
               } else {
                  die "-E- Something wrong, definition for top level port $port_name was printed already\n";
               }
            }
         }
         print $ofile ("\n");
      }

      my $comp_type = $comp_db{$dpath}{type};
      my $is_reg     = ($comp_type eq "reg");
      my $is_regfile = ($comp_type eq "regfile");
      if (!$is_reg && !$is_regfile) {
         die "-E- Definition $def_path cannot instantiate component of type $comp_type (instance: $inst)\n";
      }

      print $ofile ("${indent}Instance $inst Of $final_inst_def_name {\n");
      icl_print_inst_param($dpath, $ofile);
      icl_print_attr($dpath, $fpath, $ofile,1,1,1,0);
      print $ofile ("${indent}   InputPort   si = $inst_db{$ipath}{ScanInPort};\n");

      if ($is_reg) {
         if (exists $inst_db{$ipath}{trst} || exists $inst_db{$ipath}{tlr}) {
            my $sig_polarity = ($trst_polarity == 0) ? "" : "~";
            print $ofile ("${indent}   InputPort   rstn = $sig_polarity$trst_name;\n");
         } elsif (exists $inst_db{$ipath}{pwrgood_id}) {
            my $pwr_id = $inst_db{$ipath}{pwrgood_id};
            my $pwrgood_port     = $icl_comp_db{$gIclModulePath}{reset_mapping}{pwrgood_id}{$pwr_id}{port_name};
            my $pwrgood_polarity = $icl_comp_db{$gIclModulePath}{reset_mapping}{pwrgood_id}{$pwr_id}{polarity};
            my $sig_polarity = ($pwrgood_polarity == 0) ? "" : "~";
            print $ofile ("${indent}   InputPort   rstn = $sig_polarity$pwrgood_port;\n");
         } else {
            # FIXME polarity?
            die "-E- Register $ipath (definition $dpath) does not have reset\n";
            #print $ofile ("${indent}   InputPort   rstn = $pwrgood_name;\n");
         }

      } else { #regfile
         if (exists $inst_db{$ipath}{trst} || exists $inst_db{$ipath}{tlr}) {
            my $sig_polarity = ($trst_polarity == 0) ? "" : "~";
            print $ofile ("${indent}   InputPort   ijtag_reset_b = $sig_polarity$trst_name;\n");
         }
         if (exists $inst_db{$ipath}{pwrgood_id}) {
            foreach my $pwr_id (keys %{$inst_db{$ipath}{pwrgood_id}}) {
               #FIXME
               my $pwrgood_port     = $icl_comp_db{$gIclModulePath}{reset_mapping}{pwrgood_id}{$pwr_id}{port_name};
               my $pwrgood_polarity = $icl_comp_db{$gIclModulePath}{reset_mapping}{pwrgood_id}{$pwr_id}{polarity};
               my $sig_polarity = ($pwrgood_polarity == 0) ? "" : "~";
               my $pwr_suffix = ($pwr_id eq "") ? "" : "_$pwr_id" ;
               print $ofile ("${indent}   InputPort   rstn$pwr_suffix = $sig_polarity$pwrgood_port;\n");
            }
         }
      }
      if (exists $inst_db{$ipath}{DataInPort}) {
         foreach my $port_name (sort keys %{$inst_db{$ipath}{DataInPort}}) {
            my $pname = $inst_db{$ipath}{DataInPort}{$port_name}{name};
            my $conn = $inst_db{$ipath}{DataInPort}{$port_name}{conn};
            my $tdr_in_name = ($pname eq "") ? "tdr_in" : "tdr_in_$pname" ;
            #if ($is_top_level) {
               print $ofile ("${indent}   InputPort   $tdr_in_name = $port_name;\n");
            #} else {
            #   print $ofile ("${indent}   InputPort   $tdr_in_name = $conn;\n");
            #}
         }
      }
      print $ofile ("${indent}}\n");
      if ($reg_hash{$inst}{size} ne "\"VARIABLE\"") {
         print $ofile ("${indent}Alias ${inst}[\$${inst}_DR_SIZE-1:0] = ${inst}.DR;\n");
      }
      print $ofile ("\n${indent}//---------------------------\n\n");
      if (! exists $included_defs{$final_inst_def_name}) {
        if ($is_reg) {
           push @reg_defs_to_print, $inst;
        } else {
           push @regfile_defs_to_print, $inst;
        }
        $included_defs{$final_inst_def_name} = 1;
      } else { # eliminate non-used override warnings from non-printed MI (reused) definitions
        $printed_non_mi_defs_hash{$dpath} = 1;
      }
   }

   if ($shared_intf ne "" && ($num_of_shared_regs > 1)) {
      print $ofile ("\n${indent}ScanMux so_mux SelectedBy\n");
      if ($shared_intf_select_datain eq "") {
         # Fully decoded selects
         # FIXME existence checks
         my $i = 0;
         foreach my $inst (@shared_intf_reg_list) {
            my $ipath = "$def_path.$inst";
            print $ofile (",\n") if ($i);
            print $ofile ("${indent}   $inst_db{$ipath}{SelectPort}");
            $i += 1;
         }
         print $ofile ("\n${indent}{\n");
         $i = 0;
         foreach my $inst (@shared_intf_reg_list) {
            my $idx = "";
            for (my $j=0; $j < $num_of_shared_regs; $j++) {
              if ($i == $j) {
                 $idx .= "1";
              } else {
                 $idx .= "0";
              }
            }
            print $ofile ("${indent}   'b$idx : $inst.so;\n");
            $i += 1;
         }
      } else {
         # Encoded selects
         print $ofile ("${indent}   $shared_intf_select_datain\n");
         print $ofile ("${indent}{\n");
         foreach my $inst (@shared_intf_reg_list) {
            my $ipath = "$def_path.$inst";
            print $ofile ("${indent}   $inst_db{$ipath}{select_enum_value} : $inst.so;\n");
         }
      }
      print $ofile ("${indent}}\n");
   }

   icl_print_extra_ports($ofile);

   #print $ofile ("} // end of $new_def_name\n\n");
   print $ofile ("} // end of $gIclName\n\n");

   if (scalar(@regfile_defs_to_print)) {

      print $ofile ("\n// Chain Definitions\n");
   
      foreach my $inst (@regfile_defs_to_print) {
         my $ipath  = "$def_path.$inst";
         my $dpath  = $inst_db{$ipath}{cpath};
         my $fpath  = "$full_inst_path.$inst";
         my $new_def_name = $inst_db{$ipath}{new_def_name};
   
         print $ofile ("//---------------------------\n");
         icl_print_regfile($dpath,$fpath,$base_name,$ofile,$new_def_name);
      }
   }

   if (scalar(@reg_defs_to_print)) {

      print $ofile ("\n// Register Definitions\n");
   
      foreach my $inst (@reg_defs_to_print) {
         my $ipath  = "$def_path.$inst";
         my $dpath  = $inst_db{$ipath}{cpath};
         my $fpath  = "$full_inst_path.$inst";
         my $new_def_name = $inst_db{$ipath}{new_def_name};
   
         print $ofile ("//---------------------------\n");
         icl_print_reg($dpath,$fpath,$new_def_name,$ofile,\%reg_param_hash);
      }
   }
}

# used to print PARAMETER statements in the Module definition
sub icl_print_param
{
   my $def_path       = shift;
   my $ofile          = shift;
   if (exists $param_comp_db{$def_path}) {
      my @param_list = sort keys %{$param_comp_db{$def_path}{param}};
      print $ofile ("${text_indent}// Parameters\n");
      foreach my $param (@param_list) {
         print $ofile ("${text_indent}Parameter $param = $param_comp_db{$def_path}{param}{$param};\n");
      }
      print $ofile ("\n");
      if (exists $param_comp_db{$def_path}{lparam_list}) {
         foreach my $lparam (@{$param_comp_db{$def_path}{lparam_list}}) {
            print $ofile ("${text_indent}LocalParameter $lparam;\n");
         }
         print $ofile ("\n");
      }
   }
}

# used to print PARAMETER statements in the Module definition
sub icl_print_inst_param
{
   my $def_path       = shift;
   my $ofile          = shift;
   if (exists $param_comp_db{$def_path}) {
      my @param_list = sort keys %{$param_comp_db{$def_path}{param}};
      foreach my $param (@param_list) {
         print $ofile ("${text_indent}   Parameter $param = \$$param;\n");
      }
   }
}

# used to print ports from the header file, which are not involved into the ICL model behavior
sub icl_print_extra_ports
{
   my $ofile          = shift;
   my @not_printed_ports = ();
   my @not_printed_enums = ();
   foreach my $port_type (sort keys %{$icl_comp_db{$gIclModulePath}{port}}) {
#      my $port_to_comment = (grep {/^$port_type$/} ('ToTMSPort','ScanInPort','ScanOutPort','DataOutPort',
#                'ToSelectPort','ToShiftEnPort','ToCaptureEnPort','ToUpdateEnPort',
#                'ToClockPort','ToTCKPort','ToResetPort','ToTRSTPort','ToIRSelectPort'));
      my $port_to_comment = 0;
      my $comment = ($port_to_comment) ? "//" : "";
      foreach my $port_name (sort keys %{$icl_comp_db{$gIclModulePath}{port}{$port_type}}) {
         if (!exists $icl_comp_db{$gIclModulePath}{printed_ports}{$port_name}) {
            my $port_def = "";
            $port_def .= icl_get_port_source($port_type,$port_name);
            $port_def .= icl_get_port_enable($port_type,$port_name);
            $port_def .= icl_get_port_properties($port_type,$port_name,0,0);
            my $refenum = icl_get_port_refenum($port_type,$port_name);
            if ($refenum ne "") {
               if (!exists $icl_comp_db{$gIclModulePath}{printed_enum_defs}{$refenum}) {
                  push @not_printed_enums, $refenum;
               }
            }
#            foreach my $item (sort keys %{$icl_comp_db{$gIclModulePath}{port}{$port_type}{$port_name}}) {
#               if (($item eq "width") || ($item eq "intf") || ($item eq "intel_type") || ($item eq "assigned") || ($item eq "Source")) {next;}
#               if ($item eq "attr") {
#                  foreach my $attr (sort keys %{$icl_comp_db{$gIclModulePath}{port}{$port_type}{$port_name}{attr}}) {
#                     if ($attr =~ /^intel_/) {next;}
#                     my $attr_value = $icl_comp_db{$gIclModulePath}{port}{$port_type}{$port_name}{attr}{$attr};
#                     $port_def .= " Attribute $attr = \"$attr_value\";";
#                  }
#               } else {
#                  my $item_value = $icl_comp_db{$gIclModulePath}{port}{$port_type}{$port_name}{$item};
#                  $port_def .= " $item $item_value;";
#                  if ($item eq "RefEnum") {
#                     if (!exists $icl_comp_db{$gIclModulePath}{printed_enum_defs}{$item_value}) {
#                        push @not_printed_enums, $item_value;
#                     }
#                  }
#               }
#            }
            $port_def = ($port_def ne "") ? " {$port_def}" : ";";
            push @not_printed_ports, "$comment $port_type   $port_name$port_def";
         }
      }
   }
   if (scalar(@not_printed_ports)) {
      print $ofile ("\n${text_indent}// Other Ports (not used)\n");
      print $ofile ("${text_indent}// -----------------------\n");
      foreach my $port_def (@not_printed_ports) {
         print $ofile ("${text_indent}$port_def\n");
      }
      if (scalar(@not_printed_enums)) {
         foreach my $enum_name (@not_printed_enums) {
            print $ofile ("\n");
            icl_print_enum($enum_name,$ofile);
            #print $ofile ("\n${text_indent}Enum   $enum_name {\n");
            ## ? FIXME sort using assigned value (independently on format)
            #foreach my $enum_item (sort keys %{$icl_comp_db{$gIclModulePath}{enum}{$enum_name}}) {
            #   my $enum_value = $icl_comp_db{$gIclModulePath}{enum}{$enum_name}{$enum_item};
            #   print $ofile ("${text_indent}   $enum_item = $enum_value;\n");
            #}
            #print $ofile ("${text_indent}}\n");
         }
      }
      print $ofile ("\n");
   }
}

# returns string of port properties, excluding
#     Source, Enable, ActivePolarity, Intel-specific Attributes
sub icl_get_port_properties
{
   my $port_type    = shift;
   my $port_name    = shift;
   my $terminate    = shift;
   my $no_error     = shift;

   if (!exists $icl_comp_db{$gIclModulePath}{port}{$port_type}{$port_name}) {
      if ($no_error) {
         if ($terminate) {
            return ";";
         } else {
            return "";
         }
      } else {
         die "-E- $port_type port '$port_name' does not exist\n";
      }
   }
   my $port_def = "";
   foreach my $item (sort keys %{$icl_comp_db{$gIclModulePath}{port}{$port_type}{$port_name}}) {
      if (($item eq "width") || ($item eq "intf") || ($item eq "intel_type") || ($item eq "assigned") ||  ($item eq "assigned_to") || ($item eq "Source") || ($item eq "Enable") || ($item eq "ActivePolarity")) {next;}
      if ($item eq "attr") {
         foreach my $attr (sort keys %{$icl_comp_db{$gIclModulePath}{port}{$port_type}{$port_name}{attr}}) {
            if ($attr =~ /^intel_/) {next;}
            my $attr_value = $icl_comp_db{$gIclModulePath}{port}{$port_type}{$port_name}{attr}{$attr};
            $port_def .= " Attribute $attr = \"$attr_value\";";
         }
      } else {
         my $item_value = $icl_comp_db{$gIclModulePath}{port}{$port_type}{$port_name}{$item};
         $port_def .= " $item $item_value;";
      }
   }
   if ($terminate) {
      $port_def = ($port_def ne "") ? " {$port_def}" : ";";
   }
   return $port_def;
}

# returns string with Source spec of the port
# if it references constant or compatible existing port
sub icl_get_port_source
{
   my $port_type = shift;
   my $port_name = shift;

   my $str = "";
   if (exists $icl_comp_db{$gIclModulePath}{port}{$port_type}{$port_name}{Source}) {
      my $source = $icl_comp_db{$gIclModulePath}{port}{$port_type}{$port_name}{Source};
      my $is_valid = 0;
      if (is_icl_number($source)) {
         $is_valid = 1;
      } else {
         my $source_non_inv = $source;
         $source_non_inv =~ s/~//g;
         my @valid_src_port_types = icl_get_valid_source_port_type($port_type);
         foreach my $src_port_type (@valid_src_port_types) {
            if (exists $icl_comp_db{$gIclModulePath}{port}{$src_port_type}) {
               if (exists $icl_comp_db{$gIclModulePath}{port}{$src_port_type}{$source}) {
                  $is_valid = 1;
                  last;
               }
            }
         }
      }
      if ($is_valid) {
         $str = " Source $source;";
      }
   }
   return $str;
}

# returns string with Enable spec of the port
# if it references constant or compatible existing port
sub icl_get_port_enable
{
   my $port_type = shift;
   my $port_name = shift;

   my $str = "";
   if (exists $icl_comp_db{$gIclModulePath}{port}{$port_type}{$port_name}{Enable}) {
      my $enable = $icl_comp_db{$gIclModulePath}{port}{$port_type}{$port_name}{Enable};
      my $is_valid = 0;
      if (is_icl_number($enable)) {
         $is_valid = 1;
      } else {
         my $enable_non_inv = $enable;
         $enable_non_inv =~ s/~//g;
         my @valid_src_port_types = ("DataInPort","SelectPort");
         foreach my $src_port_type (@valid_src_port_types) {
            if (exists $icl_comp_db{$gIclModulePath}{port}{$src_port_type}) {
               if (exists $icl_comp_db{$gIclModulePath}{port}{$src_port_type}{$enable}) {
                  $is_valid = 1;
                  last;
               }
            }
         }
      }
      if ($is_valid) {
         $str = " Enable $enable;";
      }
   }
   return $str;
}

# returns string with ActivePolarity spec of the port
sub icl_get_port_active_polarity
{
   my $port_type = shift;
   my $port_name = shift;

   if (exists $icl_comp_db{$gIclModulePath}{port}{$port_type}{$port_name}{ActivePolarity}) {
      my $value = $icl_comp_db{$gIclModulePath}{port}{$port_type}{$port_name}{ActivePolarity};
      if (($value eq "0") || ($value eq "1")) {
         return " ActivePolarity $value;";
      } else {
         die "-E- Incorrect ActivePolarity value '$value' of $port_type port $port_name\n";
      }
   }
   return "";
}

# returns refenum id of the port if it exists
sub icl_get_port_refenum
{
   my $port_type = shift;
   my $port_name = shift;

   if (exists $icl_comp_db{$gIclModulePath}{port}{$port_type}{$port_name}{RefEnum}) {
      my $value = $icl_comp_db{$gIclModulePath}{port}{$port_type}{$port_name}{RefEnum};
      return $value;
   }
   return "";
}

sub icl_print_enum
{
   my $enum_name = shift;
   my $ofile     = shift;

   print $ofile ("${text_indent}Enum   $enum_name {\n");
   # ? FIXME sort using assigned value (independently on format)
   foreach my $enum_item (sort keys %{$icl_comp_db{$gIclModulePath}{enum}{$enum_name}}) {
      my $enum_value = $icl_comp_db{$gIclModulePath}{enum}{$enum_name}{$enum_item};
      print $ofile ("${text_indent}   $enum_item = $enum_value;\n");
   }
   print $ofile ("${text_indent}}\n");
}

# returns an array of compatible port types for the specified port type with Source
sub icl_get_valid_source_port_type {
   my $port_type = shift;
   if ($port_type eq "ScanOutPort")     {return ["ScanInPort"];}
   if ($port_type eq "DataOutPort")     {return ["DataInPort","SelectPort"];}
   if ($port_type eq "ToSelectPort")    {return ["SelectPort","DataInPort"];}
   if ($port_type eq "ToShiftEnPort")   {return ["ShiftEnPort"];}
   if ($port_type eq "ToCaptureEnPort") {return ["CaptureEnPort"];}
   if ($port_type eq "ToUpdateEnPort")  {return ["UpdateEnPort"];}
   if ($port_type eq "ToResetPort")     {return ["ResetPort"];}
   if ($port_type eq "ToTMSPort")       {return ["TMSPort"];}
   if ($port_type eq "ToClockPort")     {return ["ClockPort"];}
   if ($port_type eq "ToTRSTPort")      {return ["TRSTPort"];}
   return [];
}

# used to print regfile (ijtag/chain) definition
sub icl_print_regfile
{
   my $def_path       = shift;
   my $full_inst_path = shift; # full relative path from the specified top instance
   my $base_name      = shift;
   my $ofile          = shift;
   my $new_def_name   = shift;

   my $comp_type = $comp_db{$def_path}{type};
   if ($comp_type ne "regfile") {
      die "-E- Instance $full_inst_path is not a regfile/chain (actual type: $comp_type)\n";
   }

   my $indent = $text_indent;

   my %mi_hash;
   my %reg_param_hash;
   my %reg_hash;
   my @reg_defs_to_print = ();
   my @reg_inst_print_order = ();
   
   # populate global override db
   #icl_populate_ovrd_hash($def_path,$full_inst_path);

   # populate MI db and mark instances/definitions which require uniquification
   icl_process_mi($def_path,$full_inst_path, \%mi_hash);

   # from max to 0 
   my @sorted_inst_list = sort { $inst_db{"$def_path.$b"}{addr} <=> $inst_db{"$def_path.$a"}{addr} } @{$comp_db{$def_path}{ilist}};

   # FIXME better implementation of grep
   my @low_level_regs = grep {defined $comp_db{$def_path}{ovrd}{$_}{TapSibRef} && $comp_db{$def_path}{ovrd}{$_}{TapSibRef} ne ""} (keys %{$comp_db{$def_path}{ovrd}});
   my @top_level_sibs = ();
   foreach my $inst (@{$comp_db{$def_path}{ilist}}) {
      if (!grep {/^$inst$/} (@low_level_regs)) {
         push @top_level_sibs, $inst;
      }
   }

   my @level_inst_list = @top_level_sibs;
   my $level = 1;
   my %sib_inst_hash;
   my %inst_sib_hash;

   # print IJTAG/chain definition
   while (@sorted_inst_list) {

      my @next_level_regs = ();
      my @processed_inst_list = ();
      my $prev_so_driver = "si";
      # from si to so
      my $parent_sib = "";

      foreach my $inst (@sorted_inst_list) {

         my $ipath = "$def_path.$inst";
         my $dpath = $inst_db{$ipath}{cpath};
         my $fpath = "$full_inst_path.$inst";

         my $comp_type = $comp_db{$dpath}{type};
         if($comp_type ne "reg") {
            die "-E- Incorrect component type $comp_type (instance $inst) in IJTAG regfile $def_path\n";
         }

         if (grep {/^$inst$/} @level_inst_list) {

            if (exists $inst_sib_hash{$inst}) {
               if ($inst_sib_hash{$inst} ne $parent_sib) {
                  $parent_sib = $inst_sib_hash{$inst};
                  $prev_so_driver = "$parent_sib.inst_si";
               }
            }

            my @next_level_regs_tmp = grep {(defined $comp_db{$def_path}{ovrd}{$_}{TapSibRef}) && ($comp_db{$def_path}{ovrd}{$_}{TapSibRef} eq $inst)} (keys %{$comp_db{$def_path}{ovrd}});
            my $is_sib = (scalar(@next_level_regs_tmp) > 0);
            push @next_level_regs, @next_level_regs_tmp;

            foreach my $nxt_inst (@next_level_regs_tmp ) {
               $inst_sib_hash{$nxt_inst} = $inst;
            }

            # from 0 to max
            my @sorted_next_level_regs_tmp = sort { $inst_db{"$def_path.$a"}{addr} <=> $inst_db{"$def_path.$b"}{addr} } @next_level_regs_tmp;
            my $inst_so_driver;
            if (@sorted_next_level_regs_tmp > 0) { # subchain
               $inst_so_driver = $sorted_next_level_regs_tmp[0] . ".so";
            } 

            $reg_hash{$inst}{si} = $prev_so_driver;

            if ($is_sib) {
               $reg_hash{$inst}{inst_so} = $inst_so_driver;
            }

            $prev_so_driver = "$inst.so";

            push @reg_inst_print_order, $inst;
   
            $reg_hash{$inst}{level} = $level;

            #populate dr_size & param info
            icl_process_reg_param($dpath,\%reg_param_hash);
            my $reg_width_is_parameterized = 0;
            if (exists $param_comp_db{$dpath}) {
               $reg_width_is_parameterized = exists $param_comp_db{$dpath}{reg_width_formula};
            }
            if (icl_get_attr('TapDrIsFixedSize', $dpath, $fpath, 1, 1, 0) eq 'true') { # fixed size reg
               if ($reg_width_is_parameterized) {
                  $reg_hash{$inst}{size} = $param_comp_db{$dpath}{reg_width_formula};
               } else {
                  $reg_hash{$inst}{size} = icl_get_attr('TapShiftRegLength', $dpath, $fpath, 0, 1, 0);
               }
            } else { # variable size reg
               $reg_hash{$inst}{size} = "\"VARIABLE\"";
            }

         } else {
            push @processed_inst_list, $inst;
         } # grep

      } #foreach

      if (scalar(@processed_inst_list) < scalar(@sorted_inst_list)) {
         @sorted_inst_list = @processed_inst_list;
      } else {
         die "-E- Cannot process IJTAG regfile $def_path - incorrect hierarchy spec\n";
      }

      @level_inst_list = @next_level_regs;
      $level += 1;
   } #while

   print $ofile ("Module $new_def_name {\n\n");

   icl_print_param($def_path, $ofile);

   icl_print_attr($def_path, $full_inst_path, $ofile,0,1,0,0);
   
   print $ofile ("\n${indent}//--------------------------------------------------------------------------------\n");
   print $ofile ("${indent}//Local Parameters\n\n");
   print $ofile ("${indent}//TAP DR Sizes\n");
   foreach my $reg (@reg_inst_print_order) {
      if (!exists $reg_hash{$reg}{inst_so}) { # not sib
         my $reg_size = $reg_hash{$reg}{size};
         print $ofile ("${indent}LocalParameter ${reg}_DR_SIZE = $reg_size;\n");
      }
   }

   # FIXME Legacy implementation, could use data from the chain tracing above
   my $so_driver;
   my @so_driver_l = grep {$inst_db{"$def_path.$_"}{addr} == 0} @{$comp_db{$def_path}{ilist}};
   if (scalar(@so_driver_l) == 1) {
      $so_driver = $so_driver_l[0];
      #print ("-I- IJTAG chain $def_path: found .so driver $so_driver\n");
   } else {
      die "-E- No or more than one .so driver exists in the regfile (ijtag cahin) $def_path\n";
   }

   print $ofile ("\n${indent}ScanInPort    si;\n");
   print $ofile ("${indent}ScanOutPort   so   { Source $so_driver.so;}\n");
   print $ofile ("${indent}SelectPort    sel;\n");

   if (exists $comp_db{$def_path}{trst} || exists $comp_db{$def_path}{tlr}) {
      print $ofile ("${indent}ResetPort     ijtag_reset_b { ActivePolarity 0; }\n");
   }

   if (exists $comp_db{$def_path}{pwrgood_id}) {
      foreach my $pwr_id (keys %{$comp_db{$def_path}{pwrgood_id}}) {
         my $suffix = ($pwr_id eq "") ? "" : "_$pwr_id" ;
         print $ofile ("${indent}ResetPort     rstn$suffix { ActivePolarity 0;}\n");
      }
   } else {
      print $ofile ("${indent}ResetPort     rstn { ActivePolarity 0;}\n");
   }

   if (exists $comp_db{$def_path}{DataInPort}) {
      foreach my $port_name (sort keys %{$comp_db{$def_path}{DataInPort}}) {
         if (!exists $icl_comp_db{$gIclModulePath}{port}{DataInPort}{$port_name}{assigned_to}) {next;}
         my $pname = $comp_db{$def_path}{DataInPort}{$port_name}{name};
         print $ofile ("${indent}DataInPort    tdr_in_$pname;\n");
      }
   }

   if (exists $comp_db{$def_path}{DataOutPort}) {
      foreach my $port_name (sort keys %{$comp_db{$def_path}{DataOutPort}}) {
         if (!exists $icl_comp_db{$gIclModulePath}{port}{DataOutPort}{$port_name}{assigned_to}) {next;}
         my $pname = $comp_db{$def_path}{DataOutPort}{$port_name}{name};
         my $dest = $comp_db{$def_path}{DataOutPort}{$port_name}{dest};
         my $conn = $comp_db{$def_path}{DataOutPort}{$port_name}{conn};
         my $tdr_out_name = ($conn eq "") ? "tdr_out" : "tdr_out_$conn";
         print $ofile ("${indent}DataOutPort    tdr_out_$pname { Source $dest.$tdr_out_name;}\n");
      }
   }
   print $ofile ("\n");

   $level = 0;

   foreach my $inst (@reg_inst_print_order) {

      my $ipath = "$def_path.$inst";
      my $dpath = $inst_db{$ipath}{cpath};
      my $fpath = "$full_inst_path.$inst";

      my $def_name =$inst_db{$ipath}{comp};
      # support anonymous reg instances
      $def_name =$inst_db{$ipath}{iname} if ($def_name eq "");
      my $inst_def_name       = icl_uniquify_def_name($def_name,$inst,$base_name,\%mi_hash);
      my $final_inst_def_name = icl_add_prefix_suffix($inst_def_name);
      $inst_db{$ipath}{new_def_name} = $final_inst_def_name;

      my $reg_level = $reg_hash{$inst}{level};
      
      if ($reg_level != $level) {
         $level += 1;
         if ($reg_level != $level) {
            die "-E- Register level error (reg_level=$reg_level, next_level=$level)\n";
         }
         print $ofile ("${text_indent}//--------------------------------------------\n");
         print $ofile ("${text_indent}// Chain hierarchy level: $level (TDI->TDO/si->so)\n");
      }

      print $ofile ("${text_indent}//---------------------------\n");

      my $is_sib = exists $reg_hash{$inst}{inst_so};
      my $si     = $reg_hash{$inst}{si};

      if ($is_sib) { # sib
         my $inst_so = $reg_hash{$inst}{inst_so};
         print $ofile ("${text_indent}Instance $inst Of iclgen_intel_ijtag_sib {\n");
         icl_print_attr($dpath, $fpath, $ofile,1,1,1,0);# $extra_indent
         print $ofile ("${text_indent}   InputPort   si = $si;\n");
         print $ofile ("${text_indent}   InputPort   inst_so = $inst_so;\n");
         print $ofile ("${text_indent}   InputPort   rstn = ijtag_reset_b;\n");
         print $ofile ("${text_indent}}\n");
      } else { #reg
         print $ofile ("${text_indent}Instance $inst Of $final_inst_def_name {\n");
         icl_print_inst_param($dpath, $ofile);
         icl_print_attr($dpath, $fpath, $ofile,1,1,1,0);# $extra_indent
         #print $ofile ("${text_indent}   InputPort si = $inst_sib_hash{$inst}.inst_si;\n");
         print $ofile ("${text_indent}   InputPort   si = $si;\n");

         if (exists  $inst_db{$ipath}{tlr} || exists  $inst_db{$ipath}{trst}) {
            print $ofile ("${text_indent}   InputPort   rstn = ijtag_reset_b;\n");
         } elsif (exists  $inst_db{$ipath}{pwrgood_id}) {
            my $pwr_id = $inst_db{$ipath}{pwrgood_id};
            my $suffix = ($pwr_id eq "") ? "" : "_$pwr_id" ;
            print $ofile ("${text_indent}   InputPort   rstn = rstn$suffix;\n");
         } else {
            # FIXME rstn always exists by default for now
            die "-E- Register $ipath (definition $dpath) has no reset\n";
            #print $ofile ("${text_indent}   InputPort   rstn = rstn;\n");
         }

         if (exists $inst_db{$ipath}{DataInPort}) {
            foreach my $port_name (sort keys %{$inst_db{$ipath}{DataInPort}}) {
               my $pname = $inst_db{$ipath}{DataInPort}{$port_name}{name};
               my $conn  = $inst_db{$ipath}{DataInPort}{$port_name}{conn};
               my $tdr_in_name = ($pname eq "") ? "tdr_in" : "tdr_in_$pname" ;
               print $ofile ("${text_indent}   InputPort   $tdr_in_name = tdr_in_$conn;\n");
            }
         }
         print $ofile ("${text_indent}}\n");
         if ($reg_hash{$inst}{size} ne "\"VARIABLE\"") {
            print $ofile ("${text_indent}Alias ${inst}[\$${inst}_DR_SIZE-1:0] = ${inst}.DR;\n");
         }

         if (!$is_sib) {
            if (! exists $included_defs{$final_inst_def_name}) {
               push @reg_defs_to_print, $inst;
               $included_defs{$final_inst_def_name} = 1;
            } else { # eliminate non-used override warnings from non-printed MI (reused) definitions
               $printed_non_mi_defs_hash{$dpath} = 1;
            }
         }
      }
   }

   print $ofile ("} // end of $new_def_name\n\n");

   print $ofile ("\n// Register definitions of chain $new_def_name\n");
   foreach my $inst (@reg_defs_to_print) {
      my $ipath = "$def_path.$inst";
      my $dpath = $inst_db{$ipath}{cpath};
      my $fpath = "$full_inst_path.$inst";
      my $new_def_name = $inst_db{$ipath}{new_def_name};
      print $ofile ("//---------------------------\n");
      icl_print_reg($dpath,$fpath,$new_def_name,$ofile,\%reg_param_hash);
   }
}

# used to print reg definition
sub icl_print_reg
{
   my $def_path       = shift;
   my $full_inst_path = shift; # full relative path from the specified top instance
   my $final_def_name = shift;
   my $ofile          = shift;
   my $param_hash_ptr = shift;

   my $comp_type = $comp_db{$def_path}{type};
   if ($comp_type ne "reg") {
      die "-E- Instance $full_inst_path is not a reg (actual type: $comp_type)\n";
   }

   my $indent = $text_indent;

   my $is_parameterized = exists $param_comp_db{$def_path};

   # populate global override hash of the current component
   icl_populate_ovrd_hash($def_path,$full_inst_path);

   # populate Parameter/LocalParameter hash
   #my %param_hash;
   #icl_process_reg_param($def_path,$param_hash_ptr);

   print $ofile ("Module $final_def_name {\n\n");

   if ($is_parameterized) {
      icl_print_param($def_path, $ofile);
   }

   icl_print_attr($def_path, $full_inst_path, $ofile,0,1,0,0);

   # get reset and capture values
   my $reset_bin_value;
   my $capture_source;
   get_reg_rc_values($def_path,$full_inst_path,$param_hash_ptr,$reset_bin_value,$capture_source);

   my $dr_width = $comp_db{$def_path}{attr}{TapShiftRegLength};
   my $dr_msb   = $dr_width - 1;

   my $is_black_box = (icl_get_attr('TapDrIsFixedSize', $def_path, $full_inst_path, 1, 1, 0) eq 'false');
   if ($is_black_box) {
       warn "-W- Found BlackBox register $full_inst_path (definition $def_path)\n";
   }

   # template
   #    Port definitions
   #    Register instance
   print $ofile ("\n${text_indent}ScanInPort    si;\n");
   if ($is_black_box) {
      print $ofile ("${text_indent}ScanOutPort   so;\n");
   } else {
      print $ofile ("${text_indent}ScanOutPort   so   { Source DR[0];}\n");
   }
   print $ofile ("${text_indent}ResetPort     rstn { ActivePolarity 0;}\n");
   print $ofile ("${text_indent}SelectPort    sel;\n\n");

   if ($is_black_box) {
      print $ofile ("${text_indent}ScanInterface c_bb {\n");
      print $ofile ("${text_indent}   Port si;\n");
      print $ofile ("${text_indent}   Port so;\n");
      print $ofile ("${text_indent}   Port sel;\n");
      print $ofile ("${text_indent}   DefaultLoadValue $reset_bin_value;\n");
      print $ofile ("${text_indent}}\n");
      print $ofile ("} // end of $final_def_name\n\n");
      return;
   }

   my $exported_input = 0;
   if (exists $comp_db{$def_path}{DataInPort}) {
      foreach my $port_name (sort keys %{$comp_db{$def_path}{DataInPort}}) {
         if (!exists $icl_comp_db{$gIclModulePath}{port}{DataInPort}{$port_name}{assigned_to}) {next;}
         my $pname = $comp_db{$def_path}{DataInPort}{$port_name}{name};
         my $dest = $comp_db{$def_path}{DataInPort}{$port_name}{dest};
         my $tdr_in_name = ($dest eq "") ? "tdr_in$pname" : "tdr_in_$pname" ;
         print $ofile ("${text_indent}DataInPort    $tdr_in_name;\n");
         $exported_input = 1;
      }
      print $ofile ("\n");
   }

   if (exists $comp_db{$def_path}{DataOutPort}) {
      foreach my $port_name (sort keys %{$comp_db{$def_path}{DataOutPort}}) {
         if (!exists $icl_comp_db{$gIclModulePath}{port}{DataOutPort}{$port_name}{assigned_to}) {next;}
         my $pname = $comp_db{$def_path}{DataOutPort}{$port_name}{name};
         my $dest = $comp_db{$def_path}{DataOutPort}{$port_name}{dest};
         my $port_width = 1;
         if ($port_name =~ /\[(\d+):(\d+)\]/) {
            $port_width = $1 - $2 + 1;
         }
         if ($dest eq "") {
            # Target: full DR
            if ($dr_width != $port_width) {
               die "-E- Port/Target Register width mismatch (port $port_name: $port_width, register $def_path: $dr_width)\n";
            }
            print $ofile ("${text_indent}DataOutPort    tdr_out$pname { Source DR;}\n");
         } else {
            print $ofile ("${text_indent}DataOutPort    tdr_out_$pname { Source $dest;}\n");
         }
      }
      print $ofile ("\n");
   }

   # FIXME: implement strict selection of sLVIDCODE register
   my $slvidcode_port_name = "";
   if (!$exported_input && $full_inst_path =~ /slvidcode/i) {
      my @slvidcode_port_candidate_list = ();
      foreach my $port_name (keys %{$icl_comp_db{$gIclModulePath}{port}{DataInPort}}) {
         if (exists $icl_comp_db{$gIclModulePath}{port}{DataInPort}{$port_name}{intel_type}) {
            if ($icl_comp_db{$gIclModulePath}{port}{DataInPort}{$port_name}{intel_type} eq "slvidcode") {
               if ($slvidcode_port_name eq "") {
                  $slvidcode_port_name = $port_name;
               } else {
                  die "-E- Multiple slvidcode ports $slvidcode_port_name and $port_name exist for register $full_inst_path (definition: $def_path)\n";
               }
            } elsif ($port_name =~ /(.*)slvidcode(.*)/i) {
               print("-I- Found slvidcode port candidate $port_name\n");
               push @slvidcode_port_candidate_list, $port_name;
            }
         } elsif ($port_name =~ /(.*)slvidcode(.*)/i) {
            print("-I- Found slvidcode port candidate $port_name\n");
            push @slvidcode_port_candidate_list, $port_name;
         } else {
            # skip
         }
      }
      if ($slvidcode_port_name eq "") {
         my $candidates_num = scalar @slvidcode_port_candidate_list;
         if ($candidates_num == 1) {
            $slvidcode_port_name = pop @slvidcode_port_candidate_list;
            print("-I- Using found $slvidcode_port_name candidate as SLVIDCODE port for register $full_inst_path (definition: $def_path)\n");
         } elsif ($candidates_num > 1) {
            print("-W- Found multiple candidates for SLVIDCODE port for register $full_inst_path (definition: $def_path)\n");
            print("-W- Not implementing ICL port, using reset value instead\n");
         }
      }
   }

   my $dr_msb_str = ($is_parameterized) ? "\$$param_comp_db{$def_path}{reg_msb_param_name}" : "$dr_msb";
  
   print $ofile ("${text_indent}ScanRegister DR[${dr_msb_str}:0] {\n");
   print $ofile ("${text_indent}   ScanInSource   si;\n");
   print $ofile ("${text_indent}   ResetValue     $reset_bin_value;\n");
   print $ofile ("${text_indent}   CaptureSource  $capture_source;\n");
   print $ofile ("${text_indent}}\n");

   foreach my $field (@{$comp_db{$def_path}{ilist}}) {
      my $ipath = "$def_path.$field";
      my $dpath = $inst_db{$ipath}{cpath};
      my $fpath = "$full_inst_path.$field";
      icl_print_field($dpath,$ipath,$fpath,$ofile,$param_hash_ptr);
   }
   print $ofile ("} // end of $final_def_name\n\n");
}


# used to print fields/aliases & field attributes inside register definition
sub icl_print_field
{
   my $def_path       = shift;
   my $inst_path      = shift;
   my $full_inst_path = shift; # full relative path from the specified top instance
   my $ofile          = shift;
   my $param_hash_ptr = shift;

   my $comp_type = $comp_db{$def_path}{type};

   if ($comp_type ne "field") {
      die "-E- Instance $full_inst_path is not a field (actual type: $comp_type)\n";
   }

   my $is_parameterized = exists $param_inst_db{$inst_path};

   # template
   # Alias <field_name> = DR[msb:lsb] {
   #   Attribute <field_attr1> = <value1>; 
   #   Attribute <field_attr2> = <value2>; 
   #}

   my $comp_name = $inst_db{$inst_path}{comp};
   my $comp_path = $inst_db{$inst_path}{cpath};
   my $INST_comp_type = $comp_db{$comp_path}{type}; # FIXME
   my $indent = $text_indent;
   my $inst_name = $inst_db{$inst_path}{iname};

   my $suffix = "";
   my $comment = "";

   my $value = "0"; # default
   my $width;
   my $lsb;
   my $msb;
   if (exists $inst_db{$inst_path}{width}) {
      $width = $inst_db{$inst_path}{width};
      if ($width <= 0) {
         die "-E- Field width must be a positive number\n";
      }
   } else {
      die "-E- Field width isn't defined\n";
   }
   if (exists $inst_db{$inst_path}{lsb}) {
      $lsb = $inst_db{$inst_path}{lsb};
   } else {
      die "-E- Field lsb isn't defined\n";
   }
   if (exists $inst_db{$inst_path}{msb}) {
      $msb = $inst_db{$inst_path}{msb};
      if ($msb < $lsb) {
         die "-E- Field msb $msb cannot be less than lsb $lsb\n";
      }
   } else {
      die "-E- Field msb isn't defined\n";
   }
   if (exists $ovrd_hash{$full_inst_path}) {
      my %all_overrides;
      foreach my $ovrd_def_path (keys %{$ovrd_hash{$full_inst_path}}) {
         foreach my $attr (keys %{$ovrd_hash{$full_inst_path}{$ovrd_def_path}}) {
            if (exists $all_overrides{$attr}) {
               die "-E- Duplicated override of property '$attr' for instance '$full_inst_path'\n";
            } elsif ($attr eq "reset") {
               # FIXME - part of DR CaptureSource
               $value = $ovrd_hash{$full_inst_path}{$ovrd_def_path}{$attr};
               delete $ovrd_hash{$full_inst_path}{$ovrd_def_path}{$attr};
               $all_overrides{$attr} = 1;
            }
         }
         
      }
      $comment = " overridden";
   } elsif (exists $inst_db{$inst_path}{reset}) {
      $value = $inst_db{$inst_path}{reset};
   } elsif (exists $comp_db{$comp_path}{attr}{reset}) {
      $value = $comp_db{$comp_path}{attr}{reset};
   } elsif (exists $comp_db{$comp_path}{default}{reset}) {
      $value = $comp_db{$comp_path}{default}{reset}; # FIXME check hex format
   }
   my $alias_msb = $width - 1;
   
   my $lsb_str       = "$lsb";
   my $msb_str       = "$msb";
   my $alias_msb_str = "$alias_msb";

   if ($is_parameterized) {
      if (exists $param_hash_ptr -> {$inst_path} -> {lsb_param}) {
         $lsb_str = "\$" . $param_hash_ptr -> {$inst_path} -> {lsb_param};
      }
      if (exists $param_hash_ptr -> {$inst_path} -> {msb_param}) {
         $msb_str = "\$" . $param_hash_ptr -> {$inst_path} -> {msb_param};
      }
      if (exists $param_hash_ptr -> {$inst_path} -> {width_param}) {
         $alias_msb_str = "\$" . $param_hash_ptr -> {$inst_path} -> {width_param} . "-1";
      }
   }

   # FIxME: original //$comment
   $suffix = "[$alias_msb_str:0] = DR[$msb_str:$lsb_str]";

   #$inst_name = "\\$inst_name" if (is_rdl_keyword($inst_name));
   if ($inst_name eq "DR") {
      warn "-W- Name of field $full_inst_path (definition $def_path) conflicts with predefined name DR of full register - renaming it to 'dr'\n";
      $inst_name = "dr";
   }
   if (exists $comp_db{$def_path}{DataInPort}) {
      foreach my $port_name (sort keys %{$comp_db{$def_path}{DataInPort}}) {
         my $port_width = 1;
         if ($port_name =~ /\[(\d+):(\d+)\]/) {
            $port_width = $1 - $2 + 1;
         }
         if ($width != $port_width) {
            die "-E- Port/Target Register Field width mismatch (port $port_name: $port_width, register field $def_path: $width)\n";
         }
      }
   }
   if (exists $comp_db{$def_path}{DataOutPort}) {
      foreach my $port_name (sort keys %{$comp_db{$def_path}{DataOutPort}}) {
         my $port_width = 1;
         if ($port_name =~ /\[(\d+):(\d+)\]/) {
            $port_width = $1 - $2 + 1;
         }
         if ($width != $port_width) {
            die "-E- Port/Target Register Field width mismatch (port $port_name: $port_width, register field $def_path: $width)\n";
         }
      }
   }
   
   print $ofile ("${indent}Alias ${inst_name}$suffix {\n");
   icl_print_attr($def_path, $full_inst_path, $ofile,0,1,0,0);#FIXME is_inst
   print $ofile ("${indent}}\n");
}

sub print_header
{
   my $ofile    = shift;
   my $current_time = localtime();
   print $ofile ("// RDL  : generated by tap_icl_gen.pl\n");
   print $ofile ("// TIME : $current_time\n\n");
}

sub print_start_comp
{
   my $def_path = shift;
   my $ofile    = shift;
   my $e_indent = shift;
   my $comp_type = $comp_db{$def_path}{type};
   my $comp_name = $comp_db{$def_path}{name};
   my $indent = ($e_indent) ? $text_indent : "";
   $comp_name = "\\$comp_name" if (is_rdl_keyword($comp_name));
   print $ofile ("${indent}$comp_type $comp_name {\n");
}

sub print_end_comp
{
   my $def_path = shift;
   my $ofile    = shift;
   my $e_indent = shift;
   my $comp_type = $comp_db{$def_path}{type};
   my $comp_name = $comp_db{$def_path}{name};
   my $indent = ($e_indent) ? $text_indent : "";
   print $ofile ("${indent}}; // end of $comp_type $comp_name\n\n");
}

sub print_start_icomp
{
   my $def_path = shift;
   my $ofile    = shift;
   my $e_indent = shift;
   my $comp_type = $comp_db{$def_path}{type};
   my $indent = ($e_indent) ? $text_indent : "";
   my $suffix = "";
   $indent = "${text_indent}$indent" if ($comp_type eq "field");
   if (! $comp_db{$def_path}{is_inst}) {
      my $comp_name = $comp_db{$def_path}{name};
      $suffix .= " // definition: $comp_name";
   }
   print $ofile ("${indent}$comp_type {$suffix\n");
}

sub print_end_icomp
{
   my $inst_path = shift;
   my $full_inst_path = shift; # full relative path from the specified top instance
   my $ofile    = shift;
   my $e_indent = shift;
   my $inst_name = $inst_db{$inst_path}{iname};
   my $comp_name = $inst_db{$inst_path}{comp};
   my $comp_path = $inst_db{$inst_path}{cpath};
   my $comp_type = $comp_db{$comp_path}{type};
   my $indent = ($e_indent) ? $text_indent : "";
   $indent = "${text_indent}$indent" if ($comp_type eq "field");
   my $suffix = "";
   if ($comp_type eq "field") {
      my $value = "0"; # default
      my $width;
      my $lsb;
      my $msb;
      if (exists $inst_db{$inst_path}{width}) {
         $width = $inst_db{$inst_path}{width};
         if ($width <= 0) {
            die "-E- Field width must be a positive number\n";
         }
      } else {
         die "-E- Field width isn't defined\n";
      }
      if (exists $inst_db{$inst_path}{lsb}) {
         $lsb = $inst_db{$inst_path}{lsb};
      } else {
         die "-E- Field lsb isn't defined\n";
      }
      if (exists $inst_db{$inst_path}{msb}) {
         $msb = $inst_db{$inst_path}{msb};
         if ($msb < $lsb) {
            die "-E- Field msb $msb cannot be less than lsb $lsb\n";
         }
      } else {
         die "-E- Field msb isn't defined\n";
      }
      my $comment = "";
      if (exists $ovrd_hash{$full_inst_path}) {
         my %all_overrides;
         foreach my $ovrd_def_path (keys %{$ovrd_hash{$full_inst_path}}) {
            foreach my $attr (keys %{$ovrd_hash{$full_inst_path}{$ovrd_def_path}}) {
               if (exists $all_overrides{$attr}) {
                  die "-E- Duplicated override of property '$attr' for instance '$full_inst_path'\n";
               } elsif ($attr eq "reset") {
                  $value = $ovrd_hash{$full_inst_path}{$ovrd_def_path}{$attr};
                  delete $ovrd_hash{$full_inst_path}{$ovrd_def_path}{$attr};
                  $all_overrides{$attr} = 1;
               }
            }
            
         }
         $comment = " overridden";
      } elsif (exists $inst_db{$inst_path}{reset}) {
         $value = $inst_db{$inst_path}{reset};
      } elsif (exists $comp_db{$comp_path}{attr}{reset}) {
         $value = $comp_db{$comp_path}{attr}{reset};
      } elsif (exists $comp_db{$comp_path}{default}{reset}) {
         $value = $comp_db{$comp_path}{default}{reset}; # FIXME check hex format
      }
      $suffix = " [$width] = ${width}'h$value; // [$msb:$lsb]$comment";
   }
   else {
      $suffix = ";";
      if (! $comp_db{$comp_path}{is_inst}) {
         $suffix .= " // definition: $comp_name";
      }
   }
   $inst_name = "\\$inst_name" if (is_rdl_keyword($inst_name));
   print $ofile ("${indent}} ${inst_name}$suffix\n");
}

# FIXME print in order
sub print_attr
{
   my $def_path  = shift;
   my $full_inst_path = shift;
   my $ofile     = shift;
   my $e_indent = shift;
   my $apply_ovrd = shift;
   my @attr_list    = sort {get_property_group($a) <=> get_property_group($b)} keys %{$comp_db{$def_path}{attr}};
   my @default_list = sort {get_property_group($a) <=> get_property_group($b)} keys %{$comp_db{$def_path}{default}};
   my $comp_type = $comp_db{$def_path}{type};
   my @ovrd_list = ();
   my %printed_attr = ();
   my $indent = ($e_indent) ? "${text_indent}${text_indent}" : $text_indent;
   $indent = "${text_indent}$indent" if ($comp_type eq "field");

   # $apply_ovrd indicates that definition isn't MI and all existing overrides
   # can be pushed to the definition level
   if (exists $ovrd_hash{$full_inst_path} && $apply_ovrd) {
      my $print_ovrd_comment = 1;
      my %all_overrides;
      foreach my $ovrd_def_path (keys %{$ovrd_hash{$full_inst_path}}) {
         foreach my $attr (sort keys %{$ovrd_hash{$full_inst_path}{$ovrd_def_path}}) {
            if (exists $all_overrides{$attr}) {
               die "-E- Duplicated override of property '$attr' for instance '$full_inst_path'\n";
            } elsif ($attr ne "reset" && !is_inst_ovrd_attr($attr)) {
               if ($print_ovrd_comment) {
                  print $ofile ("${indent}// overrides:\n");
                  $print_ovrd_comment = 0;
               }
               # FIXME: not sorted for now
               my $str_value = transform_value($attr,$ovrd_hash{$full_inst_path}{$ovrd_def_path}{$attr});
               print $ofile ("${indent}${attr} = $str_value;\n");
               delete $ovrd_hash{$full_inst_path}{$ovrd_def_path}{$attr};
               $printed_attr{$attr} = 1;
            }
            $all_overrides{$attr} = 1;
         }
      }
      if (! $print_ovrd_comment) {
         print $ofile ("${indent}// end of overrides\n\n");
      }
   }

   foreach my $attr (@attr_list) {
      next if (exists $printed_attr{$attr});
      next if is_not_print_attr($attr);
      my $str_value = transform_value($attr,$comp_db{$def_path}{attr}{$attr});
      print $ofile ("${indent}${attr} = $str_value;\n");
      $printed_attr{$attr} = 1;
   }

   foreach my $attr (@default_list) {
      next if (exists $printed_attr{$attr});
      next if (is_not_print_attr($attr));
      next if (! is_comp_attr($comp_type, $attr));
      my $str_value = transform_value($attr,$comp_db{$def_path}{default}{$attr});
      print $ofile ("${indent}${attr} = $str_value; // default\n");
      $printed_attr{$attr} = 1;
   }
}

# not supporting 'nb' type for reset values for now - printed explicitly
sub transform_value {
   my $attr = shift;
   my $value = shift;
   my $attr_type = get_property_type($attr);
   if ($attr_type eq "s") {
      return ("\"$value\"");
   } elsif ($attr_type eq "nx") {
      return (sprintf("0x%x",$value));
   } elsif ($attr_type eq "n") {
      return (sprintf("%d",$value));
   } elsif ($attr_type eq "b") {
      if ($value == 0) {
         return ("false");
      } elsif ($value == 1) {
         return ("true");
      } else {
         die "-E- RDL WRITER: Not supported DB bool value $value\n";
      }
   } else {
      die "-E- RDL WRITER: Not supported property type '$attr_type'\n";
   }
}

sub icl_transform_value {
   my $attr = shift;
   my $value = shift;
   my $attr_type = get_property_type($attr);
   if ($attr_type eq "s") {
      # FIXME: to workaround Tessent ICL28 limitation
      # Neet to file TS bug!
      $value =~ s/^\s*\n//g;
      $value =~ s/\n\s*$//g;
      $value =~ s/\n/\",\n         \"/g;
      return ("\"$value\"");
   } elsif ($attr_type eq "nx") {
      return (sprintf("'h%x",$value));
   } elsif ($attr_type eq "n") {
      return (sprintf("%d",$value));
   } elsif ($attr_type eq "b") {
      if ($value == 0) {
         return ("false");
      } elsif ($value == 1) {
         return ("true");
      } else {
         die "-E- ICL WRITER: Not supported DB bool value $value\n";
      }
   } else {
      die "-E- RDL WRITER: Not supported property type '$attr_type'\n";
   }
}

sub print_ovrd {
   my $inst = shift;
   my $def_path = shift;
   my $full_inst_path = shift;
   my $ofile = shift;
   my $e_indent = shift;
   my $indent = ($e_indent) ? "${text_indent}${text_indent}${text_indent}" : "${text_indent}${text_indent}";

   if (exists $comp_db{$def_path}{ovrd}) {
      my %all_overrides;
      foreach my $ovrd_path (sort keys %{$comp_db{$def_path}{ovrd}}) {
         my @inst_path  = split /\./, $ovrd_path;
         if ($inst_path[0] eq $inst) {
            foreach my $attr (sort keys %{$comp_db{$def_path}{ovrd}{$ovrd_path}}) {
               my $fpath = "$full_inst_path.$ovrd_path";
               if (exists $ovrd_hash{$fpath}{$def_path}{$attr}) {
                  if (exists $all_overrides{$attr}) {
                     die "-E- Duplicated override of property '$attr' for instance '$full_inst_path'\n";
                  } else {
                     my $str_value;
                     if ($attr eq "reset") {
                        my $value = $comp_db{$def_path}{ovrd}{$ovrd_path}{$attr};
                        # target field inst path
                        my $inst_path = find_inst_path($ovrd_path, $def_path);
                        my $width;
                        if (exists $inst_db{$inst_path}{width}) {
                           $width = $inst_db{$inst_path}{width};
                           if ($width <= 0) {
                              die "-E- Field width must be a positive number\n";
                           }
                        } else {
                           die "-E- Field width isn't defined\n";
                        }
                        $str_value = "${width}'h$value";
                     } else {
                        $str_value = transform_value($attr,$comp_db{$def_path}{ovrd}{$ovrd_path}{$attr});
                     }
                     print $ofile ("${indent}$ovrd_path -> ${attr} = $str_value;\n");
                     delete $ovrd_hash{$fpath}{$def_path}{$attr};
                     $all_overrides{$attr} = 1;
                  }
               }
            }
         } 
      }
   }
}

# Use anonymous instance format for fields
# Instantiate definitions for registers, regfiles and addrmaps
#    - use MI definitins inside regfile
sub print_inst
{
   my $def_path  = shift;
   my $full_inst_path  = shift;
   my $ofile     = shift;
   my $base_name = shift;
   my $same_file = shift;
   my $mi_hash_ptr = shift;
   my $out_fname_inc = "";
   my $out_name_inc = "";
   my $ofile_inc;
   my $inc_type = "";
   my $indent = ($same_file) ? "${text_indent}${text_indent}" : $text_indent;
   foreach my $inst (@{$comp_db{$def_path}{ilist}}) {
      #print "DEBUG: $inst $same_file\n";
      my $ipath = "$def_path.$inst";
      my $fpath = "$full_inst_path.$inst";
      my $comp_type = $comp_db{$inst_db{$ipath}{cpath}}{type};
      my $def_name =$inst_db{$ipath}{comp};
      my $apply_ovrd =  (! exists $$mi_hash_ptr{$inst});
      print $ofile ("\n");
      if ($comp_type eq "field") {
         print_anonymous_inst($inst_db{$ipath}{cpath},$ipath,$fpath,$ofile, $same_file, $apply_ovrd);
         print_ovrd($inst, $def_path, $full_inst_path,$ofile, 0);
      } elsif($comp_type eq "reg") {
          $out_name_inc = "${base_name}_regs";
          if ($inc_type eq "") {
             if (! $same_file) {
                print $ofile ("${text_indent}`include \"$out_name_inc.rdl\"\n\n");
             }
             $inc_type = "reg";
          } elsif ($inc_type ne "reg") {
             die "-E- Definition can't instantiate children of $inc_type and reg types\n";
          }
          if ($same_file) { # part of regfile
             print $ofile ("${text_indent}//---------------------------\n");
             if (exists $included_defs{$def_name}) {
                print $ofile ("${text_indent}${def_name} $inst;\n");
                print_ovrd($inst, $def_path, $full_inst_path,$ofile, 0);
             } else {
                print_anonymous_inst($inst_db{$ipath}{cpath},$ipath,$fpath,$ofile, $same_file, $apply_ovrd);
                print_ovrd($inst, $def_path, $full_inst_path,$ofile, 0);
             }
          } else {
             if (!exists $included_files{$out_name_inc}) {
                $out_fname_inc = "$gOutDir/${out_name_inc}.rdl";
                open ($ofile_inc, '>', $out_fname_inc) or die "Can't create '$out_fname_inc': $!";
                print_header($ofile_inc);
                $included_files{$out_name_inc} = 1;
             }
             if (! exists $included_defs{$def_name}) {
                print $ofile_inc ("//---------------------------\n");
                print_comp($inst_db{$ipath}{cpath},$fpath,$ofile_inc, $base_name,$same_file, $apply_ovrd);
                $included_defs{$def_name} = 1;
             }
             print $ofile ("${text_indent}${def_name} $inst;\n");
             print_ovrd($inst, $def_path, $full_inst_path,$ofile, 0);
          }
      } elsif($comp_type eq "regfile") {
          if ($same_file) {
             die "-E- Nested regfile isn't supported\n";
          }
          $out_name_inc = "${base_name}_regs";
          if ($inc_type eq "") {
             print $ofile ("${text_indent}`include \"$out_name_inc.rdl\"\n\n");
             $inc_type = "reg";
          } elsif ($inc_type ne "reg") {
             die "-E- Definition can't instantiate children of $inc_type and regfile types\n";
          }
          if (!exists $included_files{$out_name_inc}) {
             $out_fname_inc = "$gOutDir/${out_name_inc}.rdl";
             open ($ofile_inc, '>', $out_fname_inc) or die "Can't create '$out_fname_inc': $!";
             print_header($ofile_inc);
             $included_files{$out_name_inc} = 1;
          }
          print $ofile_inc ("//---------------------------\n");
          if (! exists $included_defs{$def_name}) {
             print_comp($inst_db{$ipath}{cpath},$fpath,$ofile_inc, $base_name,1, $apply_ovrd);
             $included_defs{$def_name} = 1;
          }
          print $ofile ("${text_indent}${def_name} $inst;\n");
          print_ovrd($inst, $def_path, $full_inst_path,$ofile, 0);
      } elsif($comp_type eq "addrmap") {
          if ($inc_type eq "") {
             $inc_type = "addrmap";
          } elsif ($inc_type ne "addrmap") {
             die "-E- Definition can't instantiate children of $inc_type and reg types\n";
          }
          my $out_name_inc = "${def_name}";
          if (!exists $included_files{$out_name_inc}) {
             my $out_fname_inc_a = "$gOutDir/${out_name_inc}.rdl";
             # Print include for addrmap definition to the top file
             print $ofile ("${text_indent}`include \"$out_name_inc.rdl\"\n\n");
             $included_files{$out_name_inc} = 1;

             open ($ofile_inc, '>', $out_fname_inc_a) or die "Can't create '$out_fname_inc': $!";
             print_header($ofile_inc);
             print_comp($inst_db{$ipath}{cpath},$fpath,$ofile_inc, $out_name_inc,0, $apply_ovrd);
             close ($ofile_inc);
          }
          print $ofile ("${text_indent}${def_name} $inst;\n");
          print_ovrd($inst, $def_path, $full_inst_path,$ofile, $same_file);
      } else {
         die "-E- Unknown component type '$comp_type'\n";
      }
   }
   if ($out_fname_inc ne "" && !$same_file) {
      close ($ofile_inc);
   };
}

sub print_unused_overrides
{
   foreach my $full_path (keys %ovrd_hash) {
      foreach my $def_path (keys %{$ovrd_hash{$full_path}}) {
         foreach my $attr (keys %{$ovrd_hash{$full_path}{$def_path}}) {
            if (!exists $printed_non_mi_defs_hash{$def_path}) {
               my $value = $ovrd_hash{$full_path}{$def_path}{$attr};
               warn "-W- Unused property override '$attr = $value' (target instance '$full_path', source definition '$def_path')\n";
            }
         }
      }
   }
}

sub get_addrmaps
{
}


sub get_regs
{
}

sub get_fields
{
}

sub write_field
{
   my $field_path = shift;
   my $code = "";
   
   $code .= "field {\n";
   #$code .= print_field_attr($field_path);
   
   $code .= "};";

   return $code;
}

### =================================================================
{ # anonymous block 

# udp hash with default RDL properties
my %udp_hash;
my %udp_propagate;

my @rdl_comp_types; # ('addrmap','regfile','reg','field','signal','enum');
my @rdl_data_types; # ('string','number','boolean','ref');
my %parent_def_types;
my %parent_inst_types;
my %comp_type_endociding; # = (a => 'addrmap', rf => 'regfile', r => 'reg', f => 'field');
my %rdl_keywords;
my %not_allowed_attr;
my %dont_print_attr;
my $init = 0;
my %inst_ovrd_properties;
my %dont_compress_properties;

my %icl_inst_properties;
my %icl_def_properties;

sub print_udp_hash
{
   print "####### DEBUG: UDP HASH ##########\n";
   print Dumper (\%udp_hash);
   print "####### DEBUG: UDP PROPAGATE ##########\n";
   print Dumper (\%udp_propagate);
}

# FIXME check hash impementation
# FIXME improve error logging
sub check_comp_type 
{
   my $type = shift;
   my $parent_type = shift;
   my $parent_path = shift;

   # FIXME assume TAP RDL if no UDP file loaded yet
   if ($gUdpFileName eq "") {
      warn "-W- Input RDL not loaded feature-specific udp.rdl file, using tap_udp.rdl by default\n";
      process_included_file ("tap_udp.rdl");
   }
   
   die "-E- Unknown RDL component type '$type'\n" unless (grep {/^$type$/} (@rdl_comp_types));
   die "-E- Component type '$type' isn't supported\n" if ($type eq "enum" || $type eq "signal");
   # Update level info
   if (exists $comp_db{$parent_path}) {
      while ($comp_db{$parent_path}{type} eq $type) {
         $comp_db{$parent_path}{level} += 1;
         $parent_path = $comp_db{$parent_path}{parent};
         last if (!length($parent_path)); # skip empty path
      }
   }
   #die "-E- Component of type '$type' can't be defined in component of type '$parent_type'\n" unless (exists $parent_def_types{$type}{$parent_type});
} 

sub check_property
{
   my $name = shift;
   my $parent_type = shift;
   die "-E- Property '$name' can't be used inside '$parent_type' scope ($current_path)\n" unless (exists $udp_hash{$name}{$parent_type});
} 

sub check_rdl_keyword
{
   my $id = shift;
   my $escaped_id = shift;
   die "-E- Identifier '$id' is a reserved SystemRDL keyword - '\\$id' should be used instead.\n" if (exists $rdl_keywords{$id} && ($escaped_id ne "\\"));
   die "-E- Escaped identifier '\\$id' cannot be used if this isn't reserved SystemRDL keyword - '$id' should be used instead.\n" if (!exists $rdl_keywords{$id} && ($escaped_id eq "\\"));
}

sub is_rdl_keyword
{
   my $id = shift;
   return (exists $rdl_keywords{$id});
}

sub is_not_print_attr
{
   my $id = shift;
   return (exists $dont_print_attr{$id});
}

sub check_allowed_attr
{
   my $name = shift;
   die "-E- Unrecognized property '$name'.\n" if (!exists $udp_hash{$name});
   die "-E- Attribute '$name' isn't supported.\n" if (exists $not_allowed_attr{$name});
}

sub get_chk_property_type
{
   # property existence checking is already done
   my $name = shift;
   my $parent_type = shift;
   my $assign_type = shift;
   # FIXME skip condition
   check_allowed_attr($name);
   check_property($name,$parent_type) if ($assign_type eq "assign");
   return $udp_hash{$name}{type};
}

sub get_property_type
{
   # property existence checking is already done
   my $name = shift;
   return $udp_hash{$name}{type};
}

sub get_property_group
{
   my $name = shift;
   return $udp_hash{$name}{group};
}

sub get_property_default
{
   # property existence checking is already done
   my $name = shift;
   return $udp_hash{$name}{default};
}

sub is_comp_attr
{
   my $comp_type = shift;
   my $name = shift;
   return (exists $udp_hash{$name}{$comp_type});
}

sub check_property_default
{
   # property existence checking is already done
   my $name = shift;
   return (exists $udp_hash{$name}{default});
}

sub get_parent_def_types
{
   my $type = shift;
   return (keys %{$parent_def_types{$type}});
}

sub is_propagate_default
{
   my $name = shift;
   my $level = shift;
   return ($udp_propagate{$name}{$level} > 0);
}

# standard RDL properties
sub init_udp_hash 
{
   @rdl_comp_types = ('addrmap','regfile','reg','field','signal','enum');
   @rdl_data_types = ('string','number','boolean','ref');

   # child -> parent allowed definition types
   %parent_def_types = (
      enum    => {root => 1, addrmap => 1, regfile => 1, reg => 1, field => 1},
      field   => {root => 1, addrmap => 1, regfile => 1, reg => 1},
      reg     => {root => 1, addrmap => 1, regfile => 1},
      regfile => {root => 1, addrmap => 1, regfile => 1},
      addrmap => {root => 1, addrmap => 1},
   );

   # child -> parent allowed instance types
   %parent_inst_types = (
      field   => {reg => 1},
      reg     => {addrmap => 1, regfile => 1},
      regfile => {addrmap => 1, regfile => 1},
      addrmap => {addrmap => 1},
   );

   # standard SystemRDL properties
   # Types:
   #    's'           - string
   #    'n'/'nx'/'nb' - number / hex / big hex string
   #    'b'           - boolean
   #    'r'           - reference
   #    'k'           - keyword (not in the standard)
   $udp_hash{name}{type}   = 's'; #string
   $udp_hash{name}{default} = '';
   $udp_hash{desc}{type}   = 's'; #string
   $udp_hash{desc}{default} = '';
   foreach my $comp (@rdl_comp_types) {
      $udp_hash{name}{$comp} = 1;
      $udp_hash{desc}{$comp} = 1;
   }

   $udp_hash{lsb0}{type}    = 'b'; #boolean
   $udp_hash{lsb0}{default} = 1; # using 1|0 instead of true|false
   $udp_hash{lsb0}{addrmap} = 1;

   $udp_hash{bridge}{type}    = 'b'; #boolean
   $udp_hash{bridge}{default} = 0;
   $udp_hash{bridge}{addrmap} = 1;

   $udp_hash{alignment}{type}    = 'n'; #number
   $udp_hash{alignment}{default} = 0; # not assigned
   $udp_hash{alignment}{addrmap} = 1;
   $udp_hash{alignment}{regfile} = 1;

   $udp_hash{regwidth}{type}    = 'n'; #number
   $udp_hash{regwidth}{default} = 0; # it is 32, but using 0 to enforce a requirement to specify it
   $udp_hash{regwidth}{reg}     = 1;

   $udp_hash{accesswidth}{type}    = 'n'; #number
   $udp_hash{accesswidth}{default} = 0; # using 0 for now
   $udp_hash{accesswidth}{reg}     = 1;

   $udp_hash{fieldwidth}{type}    = 'n'; #number
   $udp_hash{fieldwidth}{default} = 1;
   $udp_hash{fieldwidth}{field}   = 1;

   $udp_hash{reset}{type}    = 'nb'; #big number (use hex string format for output)
   $udp_hash{reset}{default} = 0;
   $udp_hash{reset}{field}   = 1;

   $udp_hash{encode}{type}    = 'e'; #enum
   $udp_hash{encode}{default} = '';
   $udp_hash{encode}{field}   = 1;
    
   $udp_hash{shared}{type}    = 'b'; #enum
   $udp_hash{shared}{default} = 'false';
   $udp_hash{shared}{reg}     = 1;
    
   %rdl_keywords = map { $_ => 1 } ( qw(
      accesswidth activehigh activelow addressing addrmap
      alias alignment all anded arbiter
      async bigendian bothedge bridge clock
      compact counter cpuif_reset decr decrsaturate
      decrthreshold decrvalue decrwidth default desc
      dontcompare donttest enable encode enum
      errextbus external false field field_reset
      fieldwidth fullalign halt haltenable haltmask
      hw hwclr hwenable hwmask hwset
      incr incrvalue incrwidth internal intr
      level littleendian lsb0 mask msb0
      na name negedge next nonsticky
      ored overflow posedge precedence property
      r rclr reg regalign regfile
      regwidth reset resetsignal rset rsvdset
      rsvdsetX rw saturate shared sharedextbus
      signal signalwidth singlepulse sticky stickybit
      sw swacc swmod swwe swwel
      sync threshold true underflow w
      we wel woclr woset wr xored )
   );

   %not_allowed_attr = map { $_ => 1 } ( qw(
      msb0 )
   );

   %dont_print_attr = map { $_ => 1 } ( qw(
      fieldwidth
      reset
      )
   );
}

# FIXME: move to separate file
sub update_udp_hash 
{
   # note: reset is marked as nb (big number) and uses hex string
   my @hex_properties = qw(
       TapIdCodeOpcode
       TapIdCodeValue
       TapSlvIdCodeOpcode
       TapSlvIdCodeValue
       TapIrCaptureValue
       TapNetworkMasterID
       TapNetworkID
       RegOpcode
       TapLinkLocalBaseAddress
       TapLinkGlobalBaseAddress
       TapLinkNwipAddress
       TapLinkIrExtAddress
       TapLinkCltapTdrEndOpcode
       StfPID
       StfNetworkID
   );

   my @required_properties_addrmap = qw(
       name
       desc
       TapInstName
       TapSecurityLevel
       TapIrLength
       StfAgtName
       StfPID
       StfOrder
   );
   my @required_properties_regfile = qw(
       name
       desc
       RegOpcode
       TapOpcodeSecurityLevel
       TapRegName
   );
   my @required_properties_reg = qw(
       name
       desc
       regwidth
       TapTotalNumRegBits
       TapShiftRegLength
       RegOpcode
       TapOpcodeSecurityLevel
       TapRegSecurity
       TapRegName
       StfRegWidth
   );
   my @required_properties_field = qw(
       name
       desc
       AccessType
   );
   my @required_properties_inst = qw(
       TapInstName
       TapSecurityLevel
       RegOpcode
       TapOpcodeSecurityLevel
       TapRegSecurity
       TapRegName
       TapNetworkID
       TapParentName
       TapParentPortIndex
       TapLinkLocalBaseAddress
       TapLinkGlobalBaseAddress
       TapLinkGlobalBaseAddressName
       TapLinkNwipAddress
       TapLinkNwipLevel
       TapLinkIrExtAddrIsUsed
       TapLinkIrExtAddress
       TapSibRef
       TapIpDefHier
       TapIpInstHier
       TapRegIndex
       TapRegEnable
       TapFieldEnable
       StfAgtName
       StfPID
       StfOrder
       StfNetworkID
       StfParent
   );
   
   # integration properties, which are expected 
   # to be overridden from addrmap level
   %inst_ovrd_properties = map { $_ => 1 } ( qw(
       TapInstName
       TapSecurityLevel
       TapNetworkID
       TapParentName
       TapParentPortIndex
       TapLinkLocalBaseAddress
       TapLinkGlobalBaseAddress
       TapLinkGlobalBaseAddressName
       TapLinkNwipAddress
       TapLinkNwipLevel
       TapLinkIrExtAddrIsUsed
       TapLinkIrExtSize
       TapLinkIrExtAddress
       TapLinkPreIrDelay
       TapLinkPreDrDelay
       TapLinkPostIrDelay
       TapLinkPostDrDelay
       TapSlvIdCodeValue
       TapNumTapPorts
       TapNumLinkPorts
       RegOpcode
       TapOpcodeSecurityLevel
       StfAgtName
       StfPID
       StfOrder
       StfNetworkID
       StfParent
       AliasAddress
       StfInpRpt
       StfOutRpt
      )
   );
   
   %dont_compress_properties = map { $_ => 1 } ( qw(
       TapIrCaptureValue
       RegOpcode
       desc
       TapParentPortIndex
      )
   );

   # icl instance level attributes 
   # FIXME: revisit the list
   %icl_inst_properties = map { $_ => 1 } ( qw(
       TapSecurityLevel
       TapLinkLocalBaseAddress
       TapLinkGlobalBaseAddress
       TapLinkGlobalBaseAddressName
       TapLinkNwipAddress
       RegOpcode
       TapOpcodeSecurityLevel
       TapRegSecurity
       TapSibRef
       TapRegResetType
      )
   );

   # icl definition level attributes (can include instance lefel properties)
   # If some attribue is instance level but exists in the definition and definition is the top - keep it!
   # FIXME: revisit the list
   # 11/19/20: removed TapRegResetType
   %icl_def_properties = map { $_ => 1 } ( qw(
       TapSecurityLevel
       AccessType
       desc
       TapCollateralVisibility
      )
   );
   
   foreach my $p (@hex_properties) {
      if (exists $udp_hash{$p}) {
         if ($udp_hash{$p}{type} eq "n") {
            $udp_hash{$p}{type} = "nx";
         } else {
            die "-E- Cannot apply hex type to property '$p' - it isn't a number\n";
         }
      }
   }
   my @all_required_properties = ();
   push @all_required_properties,@required_properties_addrmap;
   push @all_required_properties,@required_properties_regfile;
   push @all_required_properties,@required_properties_reg;
   push @all_required_properties,@required_properties_field;
   foreach my $p (@all_required_properties) {
      if (exists $udp_hash{$p}) {
         $udp_hash{$p}{required} = 1;
      }
   }
   
   # populate propagate info for default values
   foreach my $udp (keys %udp_hash) {
      my $propagate = 0;
      foreach my $comp ("field","reg","regfile","addrmap") {
         $udp_propagate{$udp}{$comp} = $propagate;
         if (exists $udp_hash{$udp}{$comp}) {
            $propagate = 1;
         } 
      }
   }

   # Printing priorities/groups
   # 0     - first (name)
   # 1     - (desc)
   # 2     - (size)
   # 2     - (access)
   # 3..n  - next
   # undef - last

   # init default group 100 for printing priorities
   foreach my $attr (keys %udp_hash) {
      #if (! exists $udp_hash{$attr}{group}) {
         $udp_hash{$attr}{group} = 100;
      #}
   }

   # standard properties
   $udp_hash{name}{group}        = 0;
   $udp_hash{desc}{group}        = 1;
   $udp_hash{bridge}{group}      = 1;
   $udp_hash{regwidth}{group}    = 2;
   $udp_hash{accesswidth}{group} = 2;
   $udp_hash{fieldwidth}{group}  = 2;
   $udp_hash{alignment}{group}   = 3;
   
   # feature specific UDPs
   # names
   my @group_0 = qw(
      TapInstName
      TapNetworkArch
      TapRegName
      TapIpRegName
      TapIpDefHier
      TapIpInstHier
      StfAgtName
   );
   populate_group(\@group_0,0);
   
   # size/access
   my @group_2 = qw(
      TapShiftRegLength
      TapTotalNumRegBits
      TapIrLength
      TapTdoAlignDepth
      TapLinkCltapTdrEndOpcode
      StfRegWidth
   );
   populate_group(\@group_2,2);
   
   # address
   my @group_3 = qw(
      RegOpcode
      TapLinkLocalBaseAddress
      TapLinkGlobalBaseAddress
      TapLinkGlobalBaseAddressName
      TapLinkNwipAddress
      StfPID
      StfOpcode
   );
   populate_group(\@group_3,3);
   
   # security
   my @group_4 = qw(
      TapSecurityLevel
      TapOpcodeSecurityLevel
      TapRegSecurity
   );
   populate_group(\@group_4,4);

   # type
   my @group_5 = qw(
      TapType
      TapRegType
      AccessType
      StfAgtType
      StfRegType
      StfFieldType
   );
   populate_group(\@group_5,5);

   # parent
   my @group_6 = qw(
      TapParentName
      TapParentPortIndex
      TapSibRef
      StfParent 
   );
   populate_group(\@group_6,6);

   # level
   my @group_7 = qw(
      TapLinkNwipLevel
      TapRegIndex
      StfOrder
      StfNetworkID
   );
   populate_group(\@group_7,7);

}

sub populate_group
{
   my $group_ptr = shift;
   my $group_value = shift;
   foreach my $attr (@$group_ptr) {
      $udp_hash{$attr}{group} = $group_value;
   }
}

sub is_inst_ovrd_attr {
 my $attr = shift;
 return (exists $inst_ovrd_properties{$attr});
}

sub is_icl_inst_attr {
 my $attr = shift;
 return (exists $icl_inst_properties{$attr});
}

sub is_compress_attr {
 my $attr = shift;
 return (!exists $dont_compress_properties{$attr});
}

sub is_icl_def_attr {
 my $attr = shift;
 return (exists $icl_def_properties{$attr});
}

sub is_icl_number {
 my $value = shift;
 if ($value =~ /^(\d*)'(\w)\s*(\w+)$/) {
    my $size = $1;
    my $base = $2;
    my $val  = $3;
    if (($size ne "") && ($size !~ /^([0-9]+)$/)) {
       # simplified pattern above
       die "-E- Not supported SIZE of ICL sized number: $size (number: $value)";
    }
    if ($base =~ /^[dD]$/) {
       if ($val !~ /^([0-9_xX]+)$/) {
          # simplified pattern above
          die "-E- Not supported value of ICL sized decimal number: $val (number: $value)";
       }
    } elsif ($base =~ /^[bB]$/) {
       if ($val !~ /^([01_xX]+)$/) {
          # simplified pattern above
          die "-E- Not supported value of ICL sized binary number: $val (number: $value)";
       }
    } elsif ($base =~ /^[hH]$/) {
       if ($val !~ /^([0-9a-fA-F_xX]+)$/) {
          # simplified pattern above
          die "-E- Not supported value of ICL sized hex number: $val (number: $value)";
       }
    } else {
       die "-E- Not supported base of ICL sized number: $base (number: $value)";
    }
 } elsif ($value =~ /^([0-9_xX]+)$/) {
    # simplified pattern above
 } else {
    return 0;
 }
 if ($value =~ /[xX]/) {
    # number with unknown
    return 2;
 } else {
    return 1;
 }
}

# process_udp_file
# populates internal UDP hash
sub process_udp_file
{
   my $file      = shift;

   init_udp_hash();
   
   open(my $fh, $file) or die "Can't read '$file': $!";
   my $input = do { local $/; <$fh> }; # slurp whole file
   close($fh);

   # remove \r and all single-/multi-line comments
   # reformat RDL to simplify processing
   $input =~ s/\r//g;
   my @lines  = split /\n/, remove_comments($input,1);

   # assuming that all comments are removed already
   # simplifying regex based on rdl_formatting
   # format spec:
   # property <name> {
   #     component = <type1|..|typeN>; # types: field, reg, regfile, addrmap, or all.
   #     type = <number|;              # string, number, boolean, or ref
   #     default = 0;                  # optional
   # };

   my $inside_def = 0;
   my $name = '';
   my $comp = '';
   my $type = '';
   my $default = undef;
   foreach (@lines) {
      if (/^\s*property\s+(\w+)\s*\{/) {
         $inside_def = 1;
         $name = $1;
         die "-E- duplicated property definition $1 in UDP file $file\n" if (exists $udp_hash{$name});
      } elsif (/^\s*component\s*=\s*([^;]+?);/) {
         $comp = $1;
         die "-E- '$_' outside of property definition\n" unless ($inside_def);
      } elsif (/^\s*type\s*=\s*(\w+)\s*;/) {
         $type = $1;
         die "-E- '$_' outside of property definition\n" unless ($inside_def);
      } elsif (/^\s*default\s*=\s*([^;]+?)\s*;/) {
         ($default = $1) =~ s/\"//g;
         die "-E- '$_' outside of property definition\n" unless ($inside_def);
      } elsif (/^\s*\}\s*;/) {
         die "-E- '$_' outside of property definition\n" unless ($inside_def);
         die "-E- missing 'component' value in property definition '$name'\n" if ($comp eq '');
         die "-E- missing 'type' value in property definition '$name'\n" if ($type eq '');
         # create new %udp_hash entry
         $comp =~ s/\s+//g;
         my @comps = split /\|/, $comp;
         die "-E- unknown type '$type' in UDP property definition '$name'\n" unless (grep {/^$type$/} (@rdl_data_types));
         $udp_hash{$name}{'type'}    = substr ($type,0,1); #keep just s,b,n,r
         $udp_hash{$name}{'default'} = $default if (defined $default);
         foreach my $c (@comps) {
            if ($c eq "all") {
               foreach my $ca (@rdl_comp_types) {
                  $udp_hash{$name}{$ca} = 1;
               }
            } else {
               die "-E- unknown component '$c' in UDP property definition '$name'\n" unless (grep {/^$c$/} (@rdl_comp_types));
               $udp_hash{$name}{$c} = 1;
            }
         }
         $name = $comp = $type = $default = '';
         $inside_def = 0;
         $default = undef;
      } elsif (/^\s*$/) {
      } else {
         die "-E- Can't parse UDP file $file - unrecognized string '$_'\n";
      }
   }

   #print Dumper (\%udp_hash);

   update_udp_hash();
   
}


}
### =================================================================

