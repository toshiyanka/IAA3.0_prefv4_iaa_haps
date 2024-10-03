#!/usr/intel/pkgs/perl/5.14.1/bin/perl

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

### =================================================================
#
# File:         tap_icl_gen.pl
# Revision:     $Header$
# Description:  Script to parse RDL file 
# Authors:      Igor Molchanov, DTEG
#  rdlpp.pl     Pankaj Pant
# Created:      Tue July 31 2018
#
# (c) Copyright 2018, Intel Corporation, all rights reserved.
#
### =================================================================
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
#     -mode  <mode>      'pp' - preprocessing ony 
#     -ignore            Ignore some RDL errors 
#     -debug <level>     Debug mode - write generated Perl code to stdout 
#     Output is written to stdout
#
### =================================================================
#
# Synopsys:
#
#
### =================================================================

my $gVersion = "0.1";

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
my $gDesignType  = 'unknown';
my $gOutRdl      = 0;
my $gOutIcl      = 0;
my $text_indent  = '   ';

my $registry = system("/usr/intel/bin/dts_register -tool=SPEC2COV -version=xxxxwwxx");

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
                                  'pp' - preprocess only and save to specified output file (*.rdl.pp by default)
                                  'icl_pp' - ICL header file preprocess only and save to specified output file (*.icl.pp by default)
                                  'qc' - quality checking only
         -param     "NAME=VALUE"   User specified RTL parameter override; Use multiple times as needed
                               e.g. -param "STF_PID_SIZE=12" -param "STF_NUM_OF_PAIRS=4"
         -nocomments|comments  delete RDL comments (default) | keep RDL comments (for 'pp' mode only)
         -out_dir   NAME         Directory name for output RDL
         -log       FILE           Output log file name
         -debug     LEVEL          Print processed RDL instead of running through Perl evaluation
                               - LEVEL = 1 or 2
         -ignore|noignore      Ignore some errors if ignore specified (noignore - default)

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
    "mode=s"      => \$gMode,
    "param=s"     => \%gRtlParams,
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
my $line_cnt = 0;      # line counter
my $ainst_cnt = 0;     # anonymous instance counter
my $comp_type = "";    # current component type
my $current_path = ''; # current component path
my $address = 0;       # next available address in the current component
my %found_comps;       # cache of found instance definitions

# Databases
my %comp_db; # definitions
my %inst_db; # instances and overrides

my %icl_comp_db; # icl module definitions
my $gIclModulePath;

# Process the RDL file
my $code = "no warnings;\nno strict;\n";
if ($gRdlFile ne 'xlsm') {
$code   .= preprocess_file($gRdlFile);
}
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

exit ( 0 ) if ($gMode eq "pp");

# re-init to process by main parser code
$gUdpFileName = '';

if ($gRdlFile eq 'xlsm') {
#######################################################################################
############################ FRONT END CODE ENDS AT THIS POINT ########################
#######################################################################################

my $line = "`include \"tap_udp.rdl\"";
if ($line =~ /^\s*`include\s+\"(\S+)\"/) { #`
            process_included_file ($1);
         } else {
            die "-E- Not recognized/not supported construct: $line\n";
         }


#The package is used to maintain the data order in hash
use Tie::IxHash;

#Load the path for xslx package
BEGIN {
push(@INC,"/p/hdk/rtl/cad/x86-64_linux26/dteg/excel_packages/2019ww48");
}

#Excel packages
use Spreadsheet::XLSX;
use Excel::Writer::XLSX;

use List::MoreUtils qw(first_index); #index of the array

#definfing the workbook and the input top tap
my $workbook = 'ICL_Generation_Tool.xlsm';

#defining local hash to load excel data into it
my %tapDef;            #IP definition
tie %tapDef, 'Tie::IxHash';

my %regDef;             #TDR Definition
tie %regDef, 'Tie::IxHash';

my %regHash;            #List of all TDR
tie %regHash, 'Tie::IxHash';

my %chainrec;            #List of all TDR
tie %chainrec, 'Tie::IxHash';


#define local variables
my $arrayRow = 0;
my $inst_int = 1;

my @regDef_array;
my @reg_opcode;

my @tapRegDef_array;
my @tapReg_opcode;
my @tapReg_desc;
my $regwidth_real = 0;
my $register_size = 0; 
my $tap_name = "";

my $ir_size_real = "";
my $ir_size = "";
my $ir_reset = "";

my $genDesc = 'na'; #defines the current operation
my $cu1 = '';  #holds the excel cell value
my $sib_created = 0;

################################################################################
######### USER INPUT - Do not display below fields as attribute ################
################################################################################
my @tapDef_remove = ('IR reset value');
my @tapField_remove = ('Definition','Register Name');
my @regDef_remove = ('RegOpcode');
my @field_remove = ('Reset Value','Field Width','Radix','Range','Field Name');
################################################################################

################################################################################
############################# USER INPUTS FOR RENAME ###########################
#defining hash for diplay of correct variable name else code will display 
#same field name as in xlsx, modify default if the changes is common to 
#ip/reg/field, modify overrides if required renaming
################################################################################

#default_rename
sub default_rename {

   my %dispDef = (
      "Name"            => "name",  
      "Description"     => "desc", 
      "Register size"  => "regwidth",
      "TAP reset type"  => "TapRegResetType",
      "Register type"   => "TapRegType",
      "Field name"      => "name",
      "Field width"     => "FieldWidth",
      "Access"          => "AccessType",
      "Reset value"     => "ResetValue",
      "Security"        => "TapSecurityLevel",
      "TapSecurityLevel" => "TapOpcodeSecurityLevel",
      "Chain type"      => "TapRegType",
      "TDR"             => "TDR",
      "Instance Name"   => "Instance Name",
      "Parent"          => "TapRef",
      "Opcode Value (hex)"     => "RegOpcode",
      "TAP name"        => "name",
      "TAP Description" => "desc",
      "description (optional)" => 'desc',
      "TAP type"        => "TapType",
      "This is a Vendor TAP"  => "VendorTap",
      "TAP definition name" => "name",
      "TDR Name"            => "name",
      "TAP instance name"   => "TapInstName",
      "IR Size"    => "TapIrLength",
      "TAP Security"  => "TapSecurityLevel",
      "IR capture value" => "TapIrCaptureValue",
      "Tap Type"   => "TapType",
   );
   
   return %dispDef;
}

#ip_def rename
sub ip_rename {
   my %dispDef = @_;
   $dispDef{"Security"} = "TapSecurityLevel";
return %dispDef;

}

#TDR rename
sub reg_rename {
   my %dispDef = @_;
   $dispDef{"Security"} = "TapOpcodeSecurityLevel";
return %dispDef;

}

#field rename
sub field_rename {
   my %dispDef = @_;
   #$dispDef{"Security"} = "TapOpcodeSecurityLevel";
return %dispDef;
}


sub top_rename {
   my %dispDef = @_;
   $dispDef{"Instance"} = "Instance";
   $dispDef{"Definition"} = "Definition";
   $dispDef{"Security"} = "Security";
   $dispDef{"TDI"} = "ScanInPort";
   $dispDef{"TDO"} = "ScanOutPort";
   $dispDef{"TMS"} = "TMSPort";
   $dispDef{"TRSTb"} = "TRSTPort";
   $dispDef{"TCLK"} = "TCKPort";
   $dispDef{"Description"} = "Description";
   $dispDef{"NA"} = "NA";

   $dispDef{"SI"} = "ScanInPort";
   $dispDef{"SO"} = "ScanOutPort";
   $dispDef{"SELECT"} = "ToSelectPort";
   $dispDef{"IJTAG_RESET"} = "ResetPort";
   $dispDef{"CAPTURE"} = "CaptureEnPort";
   $dispDef{"SHIFT"} = "ShiftEnPort";
   $dispDef{"UPDATE"} = "UpdateEnPort";
   $dispDef{"MODE_SEL"} = "DataInPort";

return %dispDef;

}


my %dispDef = default_rename(); #loads the alias name
my @fields; #loads fields of each TDR

my $fileName = $workbook;
$workbook = Spreadsheet::XLSX-> new ($fileName);

########################################################################
###Extract parameter sheet data ########################################
my $parameterSheet = $workbook -> Worksheet("Parameters");
   
   my $pre_cell = $parameterSheet -> {Cells} [5] [1];
   my $pre_cu = $pre_cell -> {Val};
   if((defined $pre_cu) and ($gUniq_Prefix eq '')) {
      $gUniq_Prefix = $pre_cu;
   }

   my $suf_cell = $parameterSheet -> {Cells} [6] [1];
   my $suf_cu = $suf_cell -> {Val};
   if((defined $suf_cu) and ($gUniq_Suffix eq '')) {
      $gUniq_Suffix = $suf_cu;
   }

   my $icl_cell = $parameterSheet -> {Cells} [7] [1];
   my $icl_cu = $icl_cell -> {Val};
   if(defined $icl_cu) {
      if($icl_cu eq 'Yes'){
         $gOutIcl = 1;
      }
   }

   my $rdl_cell = $parameterSheet -> {Cells} [8] [1];
   my $rdl_cu = $rdl_cell -> {Val};
   if(defined $rdl_cu) {
      if($rdl_cu eq 'Yes'){
         $gOutRdl = 1;
      }
   }

#########################################################################
#########################################################################

#check if the required sheets are found in xlsx
#load the worksheet
foreach my $xlsmsheet_check ('Registers','TAPs'){
   my $sheetName_check= $xlsmsheet_check;
   my $TDRSheet_check = $workbook -> Worksheet($sheetName_check);

   #store maximum rows of excel sheet 
   my $MaxRow_check= $TDRSheet_check -> {MaxRow};

   if(not(defined($MaxRow_check))){
      print "\n-E- Sheet $xlsmsheet_check not found.\n";
      exit;
   }
}

foreach my $xlsmsheet ('Registers','TAPs'){

   #load the worksheet
   my $sheetName = $xlsmsheet;
   my $TDRSheet = $workbook -> Worksheet($sheetName);

   #store minimum and maximum rows of excel for looping, count starts from 0
   my $MinRow=$TDRSheet -> {MinRow};
   my $MinCol=$TDRSheet -> {MinCol};
   my $MaxRow= $TDRSheet -> {MaxRow};
   my $MaxCol=$TDRSheet -> {MaxCol};
   
   $MaxRow = $MaxRow+1; #To make use of the empty end of the line

   #loop over each row of the excel
   foreach my $row ($MinRow ..  $MaxRow) {

      #fetch the column 1 of each row cu1
      my $cell1 = $TDRSheet -> {Cells} [$row] [0];
      $cu1 = $cell1 -> {Val};

      if((not(defined $cu1)) and ($genDesc ne 'field_def') and ($genDesc ne 'tap_field_def') ){
         $genDesc = 'na';
      }

      if(defined $cu1) {
         if($cu1 eq "Register"){
            #extract size of the register
            my $next_row = $row + 1;
            my $cellrw =  $TDRSheet -> {Cells} [$next_row] [3];
            $register_size = $cellrw -> {Val};
         }
         #setting up the $genDesc if we are at IP definition
         if($cu1 eq "Parameter"){
            $genDesc = 'tap_def';
            #extract tap name
            my $prev_row = $row - 1;
            my $cellTapName =  $TDRSheet -> {Cells} [$prev_row] [0];
            $tap_name = $cellTapName -> {Val};

            #override for IP definition
            %dispDef = default_rename();
            %dispDef = ip_rename(%dispDef);
         }

         #setting up the $genDesc if we are at TDR definition
         elsif ($cu1 eq "TDR Definition"){
            $genDesc = 'reg_def';
      
            %dispDef = default_rename();
            %dispDef = reg_rename(%dispDef);
         }

         #setting up the $genDesc if we are at TDR fields
         elsif ($cu1 eq "Field Name"){
            if(defined $register_size) {
               $regwidth_real = $register_size;
               $register_size = ($regwidth_real + 7) &(-8);
               $regDef{'regwidth'} = $register_size;
            }
            $genDesc = 'field_def';
            $arrayRow = 0;
            #override for fields
            %dispDef = default_rename();
            %dispDef = field_rename(%dispDef);

         }
         elsif ($cu1 eq "Register Name" ){
            $genDesc = 'tap_field_def';
            $arrayRow = 0;
            #override for fields
            %dispDef = default_rename();
            %dispDef = field_rename(%dispDef);
         }
      }#end of genDesc setup

      #Loading the IP definition data into tapDef hash
      if(($genDesc eq 'tap_def') and ($cu1 ne "Parameter") ) {

         #fetching the value from cell column 2
         my $cell2 = $TDRSheet -> {Cells} [$row] [1];
         my $cu2 = $cell2 -> {Val};

         #convert any yes/no answers to 1/' ' (not required)
         if(defined $cu2){
            if($cu2 eq 'yes') {
               $cu2 = 1;
            }
            elsif($cu2 eq 'no') {
               $cu2 = " ";
            }
            #security redefined
            elsif($cu2 eq 'RED') {
               $cu2 = "SECURE_RED";
            }
            elsif($cu2 eq 'ORANGE') {
               $cu2 = "SECURE_ORANGE";
            }
            elsif($cu2 eq 'GREEN') {
               $cu2 = "SECURE_GREEN";
            }

            #the if avoids the keys with blank values $cu2
            if(not($cu2 =~ /^ *$/)) {
      
               if(exists $dispDef{$cu1}){
                  #store the key -value
                  $tapDef{$dispDef{$cu1}} = $cu2;
               }
               else {
                  #store the key -value
                  $tapDef{$cu1} = $cu2;
               }
            }
         }
      } #ends of loading tapDef with Ip definition from excel

      #begin to extract TDR register datato hash regdef
      elsif($genDesc eq 'reg_def' and $cu1 ne "TDR Definition" ) {
     
         #fetching the value from cell column 2
         my $cell2 = $TDRSheet -> {Cells} [$row] [1];
         my $cu2 = $cell2 -> {Val};

         if(not(defined $cu2)){
            $cu2 = '';
         }

         #convert any yes/no answers to 1/'' (not required)
         if($cu2 eq 'yes') {
            $cu2 = 1;
         }
         elsif($cu2 eq 'no') {
            $cu2 = " ";
         }
         elsif($cu2 eq 'RED') {
            $cu2 = "SECURE_RED";
         }
         elsif($cu2 eq 'ORANGE') {
            $cu2 = "SECURE_ORANGE";
         }
         elsif($cu2 eq 'GREEN') {
            $cu2 = "SECURE_GREEN";
         }
     
         #the if avoids the keys with blank values $cu2      
         if(not($cu2 =~ /^ *$/)) {
   
            if(exists $dispDef{$cu1}){
               #store the key -value
               $regDef{$dispDef{$cu1}} = $cu2;
            }
            else {
               #store the key -value
               $regDef{$cu1} = $cu2;
            } 
         }

      } # this ends the loading of regdef hash 


      # This begins extraction of the field values into 2 dimentional fields array
      elsif(($genDesc eq 'field_def') or ($genDesc eq 'tap_field_def') ){
      
         #the if makes sures we are not fetching blank values 
         if(defined $cu1) {

            foreach my $col ($MinCol ..  $MaxCol) {
               my $newcell = $TDRSheet -> {Cells} [$row] [$col];
               my $cu2 = $newcell -> {Val};

               if(defined $cu2) {
                  #checking if its first row, then they are field names
                  if($arrayRow == 0) {
                     if(exists $dispDef{$cu2}){
                        # rename the $cu2
                        $cu2 = $dispDef{$cu2};
                        $fields[$arrayRow][$col] = $cu2;
                     }
                     else {
                        $fields[$arrayRow][$col] = $cu2;
                     }
                  }

                  else {
                     if($cu2 eq 'RED') {
                        $cu2 = "SECURE_RED";
                     }
                     elsif($cu2 eq 'ORANGE') {
                        $cu2 = "SECURE_ORANGE";
                     }
                     elsif($cu2 eq 'GREEN') {
                        $cu2 = "SECURE_GREEN";
                     }                     
                     $fields[$arrayRow][$col] = $cu2;
                  }
               }   
            }
            $arrayRow = $arrayRow+1;
         }
      } # this ends the field definition array
   create_reg_def_hash();
   create_tap_def_hash();
   }#all rows scanned
   #reset all variables for next loop
    %tapDef = () ;                 
    %regDef = () ;              
    %regHash = () ;             
     
    $arrayRow = 0;
    $inst_int = 1;
   
    @regDef_array = () ;
    @reg_opcode = () ;
   
    @tapRegDef_array= () ;
    @tapReg_opcode= () ;
    @tapReg_desc= () ;
    $regwidth_real = 0;
    $register_size = 0; 
    $tap_name = "";
   
    $ir_size_real = "";
    $ir_size = "";
    $ir_reset = "";
   
    $genDesc = 'na'; 
    $cu1 = '';  
} #end of forloop scaning Registers and tap's sheet
create_ir_def_hash ();


###########################################################################
####################### CHAIN DATA EXTRACTION #############################
my $sheetName_chain = 'Chains';
my $TDRSheet_chain = $workbook -> Worksheet($sheetName_chain);

#store minimum and maximum rows of excel for looping, count starts from 0
my $MinRow_chain=$TDRSheet_chain -> {MinRow};
my $MinCol_chain=$TDRSheet_chain -> {MinCol};
my $MaxRow_chain= $TDRSheet_chain -> {MaxRow};
my $MaxCol_chain=$TDRSheet_chain -> {MaxCol};

#local variables
my $load_field_array = 0;
my $chain_name = '';
my @chainfields;
my $chainrow = 0;

if(defined $MaxRow_chain){
   $MaxRow_chain = $MaxRow_chain+1; #To make use of the empty end of the line
   #loop over each row of the excel
   foreach my $row_chain ($MinRow_chain ..  $MaxRow_chain) {
      #fetch the column 1 of each row cu1
      my $cellchain = $TDRSheet_chain -> {Cells} [$row_chain] [0];
      my $cuchain = $cellchain -> {Val};
   
      if(not(defined $cuchain)){
         $cuchain = '';
      }
   
      if($cuchain eq 'si(MSB)'){
         $load_field_array = 1;
         my $cellchainname = $TDRSheet_chain -> {Cells} [$row_chain-1] [0];
         my $cuchainname = $cellchainname -> {Val};
         if(not(defined $cuchainname)){
            $cuchainname = '';
         }
         else {
            $chain_name = $cuchainname;
         }
      }
      elsif($cuchain eq 'so(LSB)'){
         $chainrec{$chain_name} = 'RTDR';
         foreach my $chain_rec (@chainfields) {
            if(@$chain_rec[1] ne 'NA'){
               $chainrec{$chain_name} = 'IJTAG';
               last;
            }
         }
         chain_hash_update ();
         $load_field_array = 0;
         $chainrow = 0; #for next chain reintialize
         @chainfields = ();
      }
   
      if(($cuchain ne 'si(MSB)') and ($load_field_array == 1)){
         foreach my $col ($MinCol_chain ..  $MaxCol_chain) {
            my $newchainfield = $TDRSheet_chain -> {Cells} [$row_chain] [$col];
            my $cuchainfield = $newchainfield -> {Val};
   
            if(not(defined $cuchainfield)){
               $cuchainfield = 'NA';
            }
               $chainfields[$chainrow][$col] = $cuchainfield;
         } #this loads the 2 dimentional array chain data 
               $chainrow = $chainrow + 1;         
      }
   }
}
else {
   print "\n-W- The Chains sheet is not found.\n";
}

###############################################################################################
#####################Code for ICL header file #################################################
#if(1 eq 2) {
my $sheetName_top = 'TOP';
my $TDRSheet_top = $workbook -> Worksheet($sheetName_top);

#store minimum and maximum rows of excel for looping, count starts from 0
my $MinRow_top=$TDRSheet_top -> {MinRow};
my $MinCol_top=$TDRSheet_top -> {MinCol};
my $MaxRow_top= $TDRSheet_top -> {MaxRow};
my $MaxCol_top=$TDRSheet_top -> {MaxCol};

#local variables
#my $load_field_array = 0;
#my $chain_name = '';
#my @chainfields;
#my $chainrow = 0;

#local variables
my $top_sheet_found = 0;

my @tap_instance;
my @jtag_rtdr_instance;
my @other_ctrl;

my $tap_instance_found = 0;
my $jtag_rtdr_instance_found = 0;
my $other_ctrl_found = 0;
my $toprow = 0;
my %dispTop = top_rename();

if(defined $MaxRow_top){
   $MaxRow_top = $MaxRow_top+1; #To make use of the empty end of the line
   $top_sheet_found = 1;
   #loop over each row of the excel my %dispTop = top_rename();
   foreach my $row_top ($MinRow_top ..  $MaxRow_top) {
      #fetch the column 1 of each row cu1
      my $celltop = $TDRSheet_top -> {Cells} [$row_top] [0];
      my $cutop = $celltop -> {Val};
   
      #my %dispTop = top_rename();

      if(not(defined $cutop)){
         $cutop = '';
      }

      #print "$cutop\n" ;

      if($cutop eq 'TAP Instances &amp; Ports'){
         #print "I entered at right palce";
         $tap_instance_found = 1;
         $jtag_rtdr_instance_found = 0;
         $other_ctrl_found = 0;
      }
      elsif($cutop eq 'IJTAG/RTDR Instances &amp; Ports'){
         #print "i am in";
         $jtag_rtdr_instance_found = 1;
         $tap_instance_found = 0;
         $other_ctrl_found = 0;
      }
      elsif($cutop eq 'Other Control Ports'){
         $other_ctrl_found = 1;
         $tap_instance_found = 0;
         $jtag_rtdr_instance_found = 0;
      }
      elsif($cutop eq ''){
         $tap_instance_found = 0;
         $jtag_rtdr_instance_found = 0;
         $other_ctrl_found = 0;
         $toprow = 0;
      }
      

      if(($cutop ne 'TAP Instances &amp; Ports') and ($tap_instance_found == 1)){
         #print "i am in";
         foreach my $col ($MinCol_top ..  $MaxCol_top) {
            my $newtopfield = $TDRSheet_top -> {Cells} [$row_top] [$col];
            my $cutopfield = $newtopfield -> {Val};
   
            if(not(defined $cutopfield)){
               $cutopfield = 'NA';
            }
               $tap_instance[$toprow][$col] = $cutopfield;
         } #this loads the 2 dimentional array chain data 
         $toprow = $toprow + 1;         
      }
     
      if(($cutop ne 'IJTAG/RTDR Instances &amp; Ports') and ($jtag_rtdr_instance_found == 1)){
         #print "i am in";
         foreach my $col ($MinCol_top ..  $MaxCol_top) {
            my $newtopfield = $TDRSheet_top -> {Cells} [$row_top] [$col];
            my $cutopfield = $newtopfield -> {Val};
   
            if(not(defined $cutopfield)){
               $cutopfield = 'NA';
            }
               $jtag_rtdr_instance[$toprow][$col] = $cutopfield;
         } #this loads the 2 dimentional array chain data 
         $toprow = $toprow + 1;         
      }

      if(($cutop ne 'Other Control Ports') and ($other_ctrl_found == 1)){
         foreach my $col ($MinCol_top ..  $MaxCol_top) {
            my $newtopfield = $TDRSheet_top -> {Cells} [$row_top] [$col];
            my $cutopfield = $newtopfield -> {Val};
   
            if(not(defined $cutopfield)){
               $cutopfield = 'NA';
            }
               $other_ctrl[$toprow][$col] = $cutopfield;
         } #this loads the 2 dimentional array chain data 
         $toprow = $toprow + 1;         
      }

   }
}

else {
   print "\n-W- The TOP sheet is not found.\n";
}


#Processing the data to convert to hash
#local variable
my $table_row_location = 0;
my $parent_key_top = ".".$gRdlCompName;
#empty hash
my %empty_db;

if($top_sheet_found == 1){
   #processing of the @tap_instances 
   #get the row loc
   #print "i am in";
   my $row_inc = 0; 
   foreach my $row (@tap_instance){
      if(@$row[1] eq $gRdlCompName){
         $table_row_location = $row_inc;
      }
      $row_inc = $row_inc + 1; 
   }
   
   if($table_row_location == 0) {
      print "The TOP sheet could not find definition $gRdlCompName in table \"TAP Instances & Ports\" ";
      exit;
   }
   
   my $col_inc = 0; 
   foreach my $row (@{$tap_instance[$table_row_location]}){
      
      if(($dispTop{$tap_instance[0][$col_inc]} eq 'TMSPort') and ($tap_instance[$table_row_location][$col_inc] ne 'NA')) {
         $icl_comp_db{$parent_key_top}{'interface'}{$tap_instance[$table_row_location][0]}{'map'}{'TMSPort'} = $tap_instance[$table_row_location][$col_inc];
         $icl_comp_db{$parent_key_top}{'interface'}{$tap_instance[$table_row_location][0]}{'ports'}{$tap_instance[$table_row_location][$col_inc]} = 0;     
         undef %empty_db;
         my %empty_db;
         $icl_comp_db{$parent_key_top}{'port'}{'TMSPort'}{$tap_instance[$table_row_location][$col_inc]} = \%empty_db;
      }

     if(($dispTop{$tap_instance[0][$col_inc]} eq 'ScanOutPort') and ($tap_instance[$table_row_location][$col_inc] ne 'NA')) {
         $icl_comp_db{$parent_key_top}{'interface'}{$tap_instance[$table_row_location][0]}{'map'}{'ScanOutPort'} = $tap_instance[$table_row_location][$col_inc];
         $icl_comp_db{$parent_key_top}{'interface'}{$tap_instance[$table_row_location][0]}{'ports'}{$tap_instance[$table_row_location][$col_inc]} = 0;     
         $icl_comp_db{$parent_key_top}{'port'}{'ScanOutPort'}{$tap_instance[$table_row_location][$col_inc]}{'source'} = $gRdlCompName;
      }

     if(($dispTop{$tap_instance[0][$col_inc]} eq 'ScanInPort') and ($tap_instance[$table_row_location][$col_inc] ne 'NA')) {
         $icl_comp_db{$parent_key_top}{'interface'}{$tap_instance[$table_row_location][0]}{'map'}{'ScanInPort'} = $tap_instance[$table_row_location][$col_inc];
         $icl_comp_db{$parent_key_top}{'interface'}{$tap_instance[$table_row_location][0]}{'ports'}{$tap_instance[$table_row_location][$col_inc]} = 0;
         undef %empty_db;
         my %empty_db;     
         $icl_comp_db{$parent_key_top}{'port'}{'ScanInPort'}{$tap_instance[$table_row_location][$col_inc]} = \%empty_db;         
      }

     if(($dispTop{$tap_instance[0][$col_inc]} eq 'TRSTPort') and ($tap_instance[$table_row_location][$col_inc] ne 'NA')) { 
         undef %empty_db;
         my %empty_db;
         $icl_comp_db{$parent_key_top}{'port'}{'TRSTPort'}{$tap_instance[$table_row_location][$col_inc]} = \%empty_db;         
      }

     if(($dispTop{$tap_instance[0][$col_inc]} eq 'TCKPort') and ($tap_instance[$table_row_location][$col_inc] ne 'NA')) { 
         undef %empty_db;
         my %empty_db;
         $icl_comp_db{$parent_key_top}{'port'}{'TCKPort'}{$tap_instance[$table_row_location][$col_inc]} = \%empty_db;         
      }
      $col_inc = $col_inc + 1;
   }
   $icl_comp_db{$parent_key_top}{'interface'}{$tap_instance[$table_row_location][0]}{'is_tap'} = 1;
   $icl_comp_db{$parent_key_top}{'interface'}{$tap_instance[$table_row_location][0]}{'is_client'} = 1;     
   
   
#processing IJTAG/RTDR
#local_var
my $row_table_count = 0;
my $col_table_count = 0;
foreach my $row (@jtag_rtdr_instance){
   #print "dragon ra";
   #print "$row_table_count";
   if($row_table_count ne 0){
      #print "dragon entered";
      foreach my $col (@$row) {
         #print"$dispTop{$jtag_rtdr_instance[0][$col_table_count]}\n";
         if(($dispTop{$jtag_rtdr_instance[0][$col_table_count]} eq "ScanInPort") and ($jtag_rtdr_instance[$row_table_count][$col_table_count] ne 'NA') ){
         $icl_comp_db{$parent_key_top}{'interface'}{$jtag_rtdr_instance[$row_table_count][0]}{'map'}{'ScanInPort'} = $jtag_rtdr_instance[$row_table_count][$col_table_count];
         $icl_comp_db{$parent_key_top}{'interface'}{$jtag_rtdr_instance[$row_table_count][0]}{'ports'}{$jtag_rtdr_instance[$row_table_count][$col_table_count]} = 0;
         undef %empty_db;
         my %empty_db;     
         $icl_comp_db{$parent_key_top}{'port'}{'ScanInPort'}{$jtag_rtdr_instance[$row_table_count][$col_table_count]} = \%empty_db;  
         }

         if(($dispTop{$jtag_rtdr_instance[0][$col_table_count]} eq "ScanOutPort") and($jtag_rtdr_instance[$row_table_count][$col_table_count] ne 'NA') ){
         $icl_comp_db{$parent_key_top}{'interface'}{$jtag_rtdr_instance[$row_table_count][0]}{'map'}{'ScanOutPort'} = $jtag_rtdr_instance[$row_table_count][$col_table_count];
         $icl_comp_db{$parent_key_top}{'interface'}{$jtag_rtdr_instance[$row_table_count][0]}{'ports'}{$jtag_rtdr_instance[$row_table_count][$col_table_count]} = 0;
         undef %empty_db;
         my %empty_db;     
         $icl_comp_db{$parent_key_top}{'port'}{'ScanOutPort'}{$jtag_rtdr_instance[$row_table_count][$col_table_count]}{'Source'} = lc($chainrec{$jtag_rtdr_instance[$row_table_count][1]})."[0]";  
         }

         if(($dispTop{$jtag_rtdr_instance[0][$col_table_count]} eq "ToSelectPort") and($jtag_rtdr_instance[$row_table_count][$col_table_count] ne 'NA') ){
         $icl_comp_db{$parent_key_top}{'interface'}{$jtag_rtdr_instance[$row_table_count][0]}{'map'}{'ToSelectPort'} = $jtag_rtdr_instance[$row_table_count][$col_table_count];
         $icl_comp_db{$parent_key_top}{'interface'}{$jtag_rtdr_instance[$row_table_count][0]}{'ports'}{$jtag_rtdr_instance[$row_table_count][$col_table_count]} = 0;
         undef %empty_db;
         my %empty_db;     
         $icl_comp_db{$parent_key_top}{'port'}{'ToSelectPort'}{$jtag_rtdr_instance[$row_table_count][$col_table_count]}{'Source'} = lc($chainrec{$jtag_rtdr_instance[$row_table_count][1]});  
         }

#rest ports:
     if(($dispTop{$jtag_rtdr_instance[0][$col_table_count]} eq 'ResetPort') and ($jtag_rtdr_instance[$row_table_count][$col_table_count] ne 'NA')) { 
         undef %empty_db;
         my %empty_db;
         $icl_comp_db{$parent_key_top}{'port'}{'ResetPort'}{$jtag_rtdr_instance[$row_table_count][$col_table_count]} = \%empty_db;         
      }

     if(($dispTop{$jtag_rtdr_instance[0][$col_table_count]} eq 'CaptureEnPort') and ($jtag_rtdr_instance[$row_table_count][$col_table_count] ne 'NA')) { 
         undef %empty_db;
         my %empty_db;
         $icl_comp_db{$parent_key_top}{'port'}{'CaptureEnPort'}{$jtag_rtdr_instance[$row_table_count][$col_table_count]} = \%empty_db;         
      }
         
     if(($dispTop{$jtag_rtdr_instance[0][$col_table_count]} eq 'ShiftEnPort') and ($jtag_rtdr_instance[$row_table_count][$col_table_count] ne 'NA')) { 
         undef %empty_db;
         my %empty_db;
         $icl_comp_db{$parent_key_top}{'port'}{'ShiftEnPort'}{$jtag_rtdr_instance[$row_table_count][$col_table_count]} = \%empty_db;         
      }

   if(($dispTop{$jtag_rtdr_instance[0][$col_table_count]} eq 'UpdateEnPort') and ($jtag_rtdr_instance[$row_table_count][$col_table_count] ne 'NA')) { 
         undef %empty_db;
         my %empty_db;
         $icl_comp_db{$parent_key_top}{'port'}{'UpdateEnPort'}{$jtag_rtdr_instance[$row_table_count][$col_table_count]} = \%empty_db;         
      }

   if(($dispTop{$jtag_rtdr_instance[0][$col_table_count]} eq 'DataInPort') and ($jtag_rtdr_instance[$row_table_count][$col_table_count] ne 'NA')) { 
         #undef %empty_db;
         #my %empty_db;
         $icl_comp_db{$parent_key_top}{'port'}{'DataInPort'}{$jtag_rtdr_instance[$row_table_count][0]}{'intel_type'} = $jtag_rtdr_instance[$row_table_count][$col_table_count];         
      }

         $col_table_count = $col_table_count +1;
      }
   }
   $icl_comp_db{$parent_key_top}{'interface'}{$jtag_rtdr_instance[$row_table_count][0]}{'is_tap'} = 0;
   $icl_comp_db{$parent_key_top}{'interface'}{$jtag_rtdr_instance[$row_table_count][0]}{'is_client'} = 0;

   $row_table_count = $row_table_count + 1;

 }

#print "i reached";
# $row_table_count = $row_table_count + 1;
 #print "$row_table_count";

#porcessing other control ports
   $row_table_count = 0;
   $col_table_count = 0;
   foreach my $row (@other_ctrl){
      if($row_table_count ne 0){
         if($other_ctrl[$row_table_count][0] ne 'NA' and $other_ctrl[$row_table_count][1] ne 'NA' and $other_ctrl[$row_table_count][2] ne 'NA' and $other_ctrl[$row_table_count][3] ne 'NA'){
            my $width_cal = $other_ctrl[$row_table_count][2] - 1;
            my $width_cal1 = "[".$width_cal.":0]" ;
            $icl_comp_db{$parent_key_top}{'port'}{$other_ctrl[$row_table_count][0]}{$other_ctrl[$row_table_count][1]}{$width_cal1}{'intel_type'}= $other_ctrl[$row_table_count][3];
         }
      }
      $row_table_count = $row_table_count +1;
   }

}

#}
###############################################################################################




sub chain_hash_update {
   #loading the hash
   my $chain_super_parent = "";
   my $chain_reg_child = $chain_name;
   my $chain_parent_key = ".".$chain_reg_child;

   $comp_db{$chain_parent_key}{'parent'} = $chain_super_parent;

   #developing ovrd hash
   my %chain_ovrd;
   my $sibtype = '';
   my $chainrowcount = 0;
   my $chain_reg_desc = 'NA';
   my @tap_inlist1 = ();
   my @tap_inlist = ();
   my $sib_found = 0;
   my @even_set = ();
   my $chainfield_size =  @{ $chainfields[1] };
   for (my $i=1; $i < $chainfield_size; $i++) {
      if ($i % 2 == 0) {
         push @even_set, $i; 
      }
   }
   #print "size: @even_set";
   foreach my $row (@chainfields){
      if(@$row[0] ne 'NA'){
         push @tap_inlist1, @$row[0];
      }            

   foreach my $sib_check (@even_set){
      if(@$row[$sib_check] ne 'NA'){
         $sib_found = 1;
         push @tap_inlist1, @$row[$sib_check];
         if ((@$row[$sib_check+1] eq 'sib_std') or (@$row[$sib_check+1] eq 'sib_with_rpt') ){
            $sibtype = 'TapSibRef';
         }
         else {
            $sibtype = @$row[$sib_check+1];
         }
         $chain_ovrd{$chainfields[$chainrowcount-1][$sib_check-2]}{$sibtype} = @$row[$sib_check];
         my $regdescfromsub = get_desc($chainfields[$chainrowcount-1][$sib_check-2]);
         if($regdescfromsub ne 'NA'){
            $chain_ovrd{$chainfields[$chainrowcount-1][$sib_check-2]}{'desc'} = $regdescfromsub;
         }
      }
   }
      $chainrowcount = $chainrowcount+1;
   }

   sub uniq {
    my %seen;
    grep !$seen{$_}++, @_;
   }
   
   @tap_inlist = uniq(@tap_inlist1);
   
   $comp_db{$chain_parent_key}{'ovrd'} = \%chain_ovrd;
   $comp_db{$chain_parent_key}{'is_inst'} = 0;
   $comp_db{$chain_parent_key}{'name'} = $chain_reg_child;
   $comp_db{$chain_parent_key}{'child'} = 1;

   #extracting description from TAP sheet for the chain
   my $sheetName_tap = 'TAPs';
   my $TDRSheet_tap = $workbook -> Worksheet($sheetName_tap);
         
   #store minimum and maximum rows of excel for looping, count starts from 0
   my $MinRow_tap=$TDRSheet_tap -> {MinRow};
   my $MinCol_tap=$TDRSheet_tap -> {MinCol};
   my $MaxRow_tap= $TDRSheet_tap -> {MaxRow};
   my $MaxCol_tap=$TDRSheet_tap -> {MaxCol};
   $MaxRow_tap = $MaxRow_tap+1; #To make use of the empty end of the line
   
   my $tap_found = 0;
   my $tap_fields_found = 0; 
   foreach my $row_tap ($MinRow_tap ..  $MaxRow_tap) {        
      #fetch the column 1 of each row cu1
      my $cellchaindesc = $TDRSheet_tap -> {Cells} [$row_tap] [0];
      my $cuchaindesc = $cellchaindesc -> {Val};
      if(defined $cuchaindesc) {
         if($cuchaindesc eq $gRdlCompName){
            $tap_found = 1;
         }
      }
      if($tap_found == 1){
         if($cuchaindesc eq 'Register Name'){
            $tap_found = 0;
            $tap_fields_found = 1;
         }
      }
      if($tap_fields_found == 1){
         my $cellchaindesc1 = $TDRSheet_tap -> {Cells} [$row_tap] [3];
         my $cuchaindesc1 = $cellchaindesc1 -> {Val};
         
         if(not(defined($cuchaindesc1))){
            $tap_found = 0;
            last;
         }

         if($cuchaindesc1 eq $chain_reg_child){
            my $cellchaindesc2 = $TDRSheet_tap -> {Cells} [$row_tap] [4];
            my $cuchaindesc2 = $cellchaindesc2 -> {Val};
            
            if (defined($cuchaindesc2)){
               $chain_reg_desc = $cuchaindesc2;
            }
         }
      }
   }

   $comp_db{$chain_parent_key}{'attr'}{'TapRegType'} = $chainrec{$chain_name};
   if($chain_reg_desc ne 'NA'){
      $comp_db{$chain_parent_key}{'attr'}{'desc'} = $chain_reg_desc;
   }
   $comp_db{$chain_parent_key}{'level'} = 1;
   $comp_db{$chain_parent_key}{'type'} = 'regfile';
   $comp_db{$chain_parent_key}{'ilist'} = [];
   foreach my $tap_newlist (@tap_inlist){
      push $comp_db{$chain_parent_key}{'ilist'}, $tap_newlist;
   }
   $comp_db{$chain_parent_key}{'addr_idx'} = @tap_inlist;
   
   my %sib_redefine;
   $sib_redefine{'sib_std'} = 'sib_def';
   #filling inst_db hash
   foreach my $row (@chainfields){  
      if (@$row[0] ne 'NA'){
         my $chain_parent_key_i_i = $chain_parent_key.'.'.@$row[0];
         $inst_db{$chain_parent_key_i_i}{'comp'} = @$row[1];
         $inst_db{$chain_parent_key_i_i}{'iname'} = @$row[0];
         $inst_db{$chain_parent_key_i_i}{'cpath'} = '.'.@$row[1];
         $inst_db{$chain_parent_key_i_i}{'addr'} = first_index { $_ eq @$row[0] } @tap_inlist;
      }

      foreach my $sib_check (@even_set){
         if (@$row[$sib_check] ne 'NA'){
            my $chain_parent_key_i_i = $chain_parent_key.'.'.@$row[$sib_check];
            $inst_db{$chain_parent_key_i_i}{'comp'} = $sib_redefine{@$row[$sib_check+1]};
            $inst_db{$chain_parent_key_i_i}{'iname'} = @$row[$sib_check];
            $inst_db{$chain_parent_key_i_i}{'cpath'} = '.'.$sib_redefine{@$row[$sib_check+1]};
            $inst_db{$chain_parent_key_i_i}{'addr'} = first_index { $_ eq @$row[$sib_check] } @tap_inlist;
         }
      }

   }

#if sib found, add sib like a tdr, hardcoded
if(($sib_found == 1) and  ($sib_created == 0)) { 

my $obj_inst = ".sib_def.i__".$inst_int; 

$comp_db{'.sib_def'}{'parent'} = '';
$comp_db{'.sib_def'}{'is_inst'} = 0;
$comp_db{'.sib_def'}{'name'} = 'sib_def';
$comp_db{'.sib_def'}{'child'} = 1;
$comp_db{'.sib_def'}{'attr'}{'TapShiftRegLength'} = 1;
$comp_db{'.sib_def'}{'attr'}{'desc'} = 'Segment Insertion Bit';
$comp_db{'.sib_def'}{'attr'}{'name'} = 'SIB';
$comp_db{'.sib_def'}{'attr'}{'regwidth'} = 8;
$comp_db{'.sib_def'}{'attr'}{'TapRegType'} = 'SIB';
$comp_db{'.sib_def'}{'attr'}{'TapTotalNumRegBits'} = 1;
$comp_db{'.sib_def'}{'type'} = 'reg';
my @sib_field = ('sib');
$comp_db{'.sib_def'}{'ilist'} =\@sib_field;
$comp_db{'.sib_def'}{'addr_idx'} = 1;
$comp_db{$obj_inst}{'parent'} = '.sib_def';
$comp_db{$obj_inst}{'is_inst'} = 1;
$comp_db{$obj_inst}{'name'} = 'i__'.$inst_int;
$comp_db{$obj_inst}{'type'} = 'field';
$comp_db{$obj_inst}{'attr'}{'desc'} = 'sib_field';
$comp_db{$obj_inst}{'attr'}{'AccessType'} = 'RW';

$inst_db{'.sib_def.sib'}{'width'} = 1;
$inst_db{'.sib_def.sib'}{'comp'} = '';
$inst_db{'.sib_def.sib'}{'reset'} = 0;
$inst_db{'.sib_def.sib'}{'lsb'} = 0;
$inst_db{'.sib_def.sib'}{'msb'} = 0;
$inst_db{'.sib_def.sib'}{'iname'} = 'sib';
$inst_db{'.sib_def.sib'}{'cpath'} = '.sib_def.i__'.$inst_int;

#%comp_db = (
#             '.sib_def' => { 
#                          'parent' => '',
#                          'is_inst' => 0,
#                          'name' => 'sib_def',
#                          'child' => 1,
#                          'attr' => {
#                                      'TapShiftRegLength' => 1,
#                                      'desc' => 'Segment Insertion Bit',
#                                      'name' => 'SIB',
#                                      'regwidth' => 8,
#                                      'TapRegType' => 'SIB',
#                                      'TapTotalNumRegBits' => 1
#                                    },
#                          'type' => 'reg',
#                          'ilist' => [
#                                       'sib'
#                                     ],
#                          'addr_idx' => 1
#                        },
#          $obj_inst => {
#                               'parent' => '.sib_def',
#                               'is_inst' => 1,
#                               'name' => 'i__'.$inst_int,
#                               'type' => 'field',
#                               'attr' => {
#                                           'desc' => 'sib field',
#                                           'AccessType' => 'RW'
#                                         }
#                             }
#      );
#
#%inst_db = (          '.sib_def.sib' => {
#                              'width' => '1',
#                              'comp' => '',
#                              'reset' => '0',
#                              'lsb' => 0,
#                              'msb' => 0,
#                              'iname' => 'sib',
#                              'cpath' => '.sib_def.i__'.$inst_int
#                            }
#);
 $sib_created = 1;
 $inst_int = $inst_int +1;
}
}

######################### PRINT OUTPUT HASH #####################
##print "\n###### comp_db #####\n";
##print Dumper (\%comp_db);
#print "\n###### ARRAY list #####\n";
#print Dumper \@inlist;
##print "\n###### inst_db #####\n";
##print Dumper (\%inst_db);
##print "\n###### icl_comp_db #####\n";
#print Dumper (\%icl_comp_db);
#print "\n###### tap_instance #####\n";
#print Dumper (\@jtag_rtdr_instance);

##################################################################


####sub to get desc for IJTAG override from tap sheet ############
sub get_desc {
   my ($reg_name_input) = @_;
   my $reg_name_desc = 'NA';
   my $sheetName_regdesc = 'TAPs';
   my $TDRSheet_regdesc = $workbook -> Worksheet($sheetName_regdesc);

   #store minimum and maximum rows of excel for looping, count starts from 0
   my $MinRow_regdesc=$TDRSheet_regdesc -> {MinRow};
   my $MinCol_regdesc=$TDRSheet_regdesc -> {MinCol};
   my $MaxRow_regdesc= $TDRSheet_regdesc -> {MaxRow};
   my $MaxCol_regdesc=$TDRSheet_regdesc -> {MaxCol};
   $MaxRow_regdesc = $MaxRow_regdesc+1; #To make use of the empty end of the line
   
   my $tap_found_regdesc = 0;
   my $tap_fields_found_regdesc = 0;
   foreach my $rowdesc ($MinRow_regdesc ..  $MaxRow_regdesc) {        
      #fetch the column 1 of each row cu1
      my $cellchaindesc_regdesc = $TDRSheet_regdesc -> {Cells} [$rowdesc] [0];
      my $cuchaindesc_regdesc = $cellchaindesc_regdesc -> {Val};
      if(defined $cuchaindesc_regdesc) {
         if($cuchaindesc_regdesc eq $gRdlCompName){
            $tap_found_regdesc = 1;
         }
      }
      if(($tap_found_regdesc == 1) and (defined($cuchaindesc_regdesc))){
         if($cuchaindesc_regdesc eq $reg_name_input){
         my $cellchaindesc_regdesc_output = $TDRSheet_regdesc -> {Cells} [$rowdesc] [4];
         my $cuchaindesc_regdesc_output = $cellchaindesc_regdesc_output -> {Val};

            if(defined($cuchaindesc_regdesc_output)){
               $reg_name_desc = $cuchaindesc_regdesc_output;
            }
         last;
        }
      }
   }
   return $reg_name_desc;
}


######################################################################### 
##################logic to include TAP_IR################################

sub create_ir_def_hash {

   my $super_parent = "";
   my $parent_key = "."."TAP_IR";
   ##loading %comp_db
   $comp_db{$parent_key}{'parent'} = $super_parent;
   $comp_db{$parent_key}{'is_inst'} = 0;
   $comp_db{$parent_key}{'name'} = 'TAP_IR';
   $comp_db{$parent_key}{'child'} = 1;
   
   #scanning the excel TAPs for IR data
   my $ir_size_found = 0;
   my $opcode_name_found = 0;
   
   
   my $sheetName_regir = 'TAPs';
   my $TDRSheet_regir = $workbook -> Worksheet($sheetName_regir);
   
   #store minimum and maximum rows of excel for looping, count starts from 0
   my $MinRow_regir=$TDRSheet_regir -> {MinRow};
   my $MinCol_regir=$TDRSheet_regir -> {MinCol};
   my $MaxRow_regir= $TDRSheet_regir -> {MaxRow};
   my $MaxCol_regir=$TDRSheet_regir -> {MaxCol};
   $MaxRow_regir = $MaxRow_regir+1; #To make use of the empty end of the line
   
   
   foreach my $row ($MinRow_regir ..  $MaxRow_regir) {
   
      #fetch the column 1 of each row cu1
      my $cellir = $TDRSheet_regir -> {Cells} [$row] [0];
      my $cuir = $cellir -> {Val};
      if(defined $cuir) {
         if($cuir eq $gRdlCompName){
            my $cellirsize = $TDRSheet_regir -> {Cells} [$row+3] [1];
            my $cuirsize = $cellirsize -> {Val};
   
            if(not(defined $cuirsize)){
               $cuirsize = 0;
            }
            $ir_size_real = $cuirsize;
            $ir_size = ($ir_size_real + 7) &(-8);
   
            my $cellirreset = $TDRSheet_regir -> {Cells} [$row+4] [1];
            my $cuirreset = $cellirreset -> {Val};
          
            if(not(defined $cuirreset)){
               $cuirreset = 0;
            }
   
            $ir_reset = $cuirreset;        
            $ir_size_found = 1;
         }
         if($ir_size_found == 1 and $cuir eq "Register Name"){
            $opcode_name_found = 1;
            $ir_size_found = 0;     
         }
         elsif($opcode_name_found == 1){
          
            if(not(defined $cuir)){
               $cuir = '';
            }
   
            push @tapRegDef_array, $cuir;
          
            my $celliropcode = $TDRSheet_regir -> {Cells} [$row] [1];
            my $cuiropcode = $celliropcode -> {Val};
            if(not(defined $cuiropcode)){
             $cuiropcode = '';
            }
            push @tapReg_opcode, $cuiropcode;
            my $cellirdesc = $TDRSheet_regir -> {Cells} [$row] [4];
            my $cuirdesc = $cellirdesc -> {Val};
            if(not(defined $cuirdesc)){
               $cuirdesc = '';
            }
   
            push @tapReg_desc, $cuirdesc;
         }
         
      }
      else {
         $opcode_name_found = 0;
      }
   }
   $comp_db{$parent_key}{'attr'}{'TapShiftRegLength'} = $ir_size;
   $comp_db{$parent_key}{'attr'}{'desc'} = "The TAP IR Opcodes";
   $comp_db{$parent_key}{'attr'}{'name'} = "TAP IR";
   $comp_db{$parent_key}{'attr'}{'regwidth'} = $ir_size;
   $comp_db{$parent_key}{'attr'}{'TapTotalNumRegBits'} = $ir_size;
   $comp_db{$parent_key}{'type'} = 'reg';
   my @ilist_a;
   push  @ilist_a, 'TAP_IR';
   $comp_db{$parent_key}{'ilist'} = \@ilist_a;
   $comp_db{$parent_key}{'addr_idx'} = 8;
   
   my $parent_key_i = $parent_key.'.i__0';
   $comp_db{$parent_key_i}{'parent'} = $parent_key;
   $comp_db{$parent_key_i}{'is_inst'} = 1;
   $comp_db{$parent_key_i}{'name'} = 'i__0';
   $comp_db{$parent_key_i}{'type'} = 'field';
   
   my $IR_string = "Supported OpCodes\n";
   
   my $reg_count = 0;
   
   for my $eachreg (@tapRegDef_array) {
      my $opcode_len = length($tapReg_opcode[$reg_count]) * 4;
      $IR_string = $IR_string."            [br] $opcode_len\'h $tapReg_opcode[$reg_count]: $eachreg [br] $tapReg_desc[$reg_count]\n";
      $reg_count = $reg_count+1;
   }
   #$IR_string = $IR_string;
   $comp_db{$parent_key_i}{'attr'}{'desc'} =$IR_string;
   $comp_db{$parent_key_i}{'attr'}{'name'} = 'TAP_IR';
   $comp_db{$parent_key_i}{'attr'}{'AccessType'} = 'RW';
   
   #loading inst_db for TAP_IR
   my $parent_key_i_i = $parent_key.".TAP_IR";
   $inst_db{$parent_key_i_i}{'width'} = $ir_size;
   $inst_db{$parent_key_i_i}{'comp'} = '';
   $inst_db{$parent_key_i_i}{'reset'} = $ir_reset ;
   $inst_db{$parent_key_i_i}{'lsb'} = 0;
   $inst_db{$parent_key_i_i}{'msb'} = $ir_size-1;
   $inst_db{$parent_key_i_i}{'iname'} = 'TAP_IR';
   $inst_db{$parent_key_i_i}{'cpath'} = $parent_key_i;
}

sub create_reg_def_hash {

  if((not(defined $cu1))) {

   #The code should run for only after each TDR definition complete
   if(($genDesc eq 'field_def')) {
      my $super_parent = "";
      my $reg_child = $regDef{'name'};
      my $parent_key = ".".$reg_child;

      my %regDef_attr;
      tie %regDef_attr, 'Tie::IxHash';

      $regDef_attr{'TapShiftRegLength'} = $regwidth_real;
      foreach my $key (keys %regDef){
            my $value = $regDef{$key};
            $regDef_attr{$key} = $value;
      }
      $regDef_attr{'TapTotalNumRegBits'} = $regwidth_real;

      foreach my $key (@regDef_remove) {
         delete($regDef_attr{$key});
      }

      #loading %comp_db
      $comp_db{$parent_key}{'parent'} = $super_parent;
      $comp_db{$parent_key}{'is_inst'} = 0;
      $comp_db{$parent_key}{'name'} = $reg_child;
      $comp_db{$parent_key}{'child'} = 1;
      $comp_db{$parent_key}{'attr'} = \%regDef_attr;
      $comp_db{$parent_key}{'type'} = 'reg';
      #get the field list
      my @inlist = ();
      foreach my $row (@fields){  
         if(@$row[0] ne 'Field Name') {
            push @inlist, @$row[0];
         }
      }
      $comp_db{$parent_key}{'ilist'} = [];
      foreach my $newlist (@inlist){
         push $comp_db{$parent_key}{'ilist'}, $newlist;
      }
      $comp_db{$parent_key}{'addr_idx'} = $regwidth_real ;

      #creating comp_db for the fields
      my $regsize =  $regwidth_real;
      my $rowcount = 0 ; 
      foreach my $row (@fields){  
         if (@$row[0] ne 'Field Name'){
      
            my $parent_key_i = $parent_key.'.i__'.$inst_int;
            $comp_db{$parent_key_i}{'parent'} = $parent_key;
            $comp_db{$parent_key_i}{'is_inst'} = 1;
            $comp_db{$parent_key_i}{'name'} = 'i__'.$inst_int;   
            $comp_db{$parent_key_i}{'type'} = 'field';
            my $count = 0; 

            my %field_remove_temp = map { $_ => 1 } @field_remove;
            foreach my $col (@$row){
                  if((not(exists($field_remove_temp{$fields[0][$count]}))) && (defined $col) && (not($col =~ /^ *$/))){
                        $comp_db{$parent_key_i}{'attr'}{$fields[0][$count]} = $col;
                  }
                  $count = $count+1;
            }

            #filling inst_db hash
            my $parent_key_i_i = $parent_key.'.'.@$row[0];
            my $count_inst = 0;
            my $reset_field = 0;
            my $fieldwidth_field = 0;
            foreach my $col (@$row){
               if($fields[0][$count_inst] eq 'Reset Value') {
                  if($fields[$rowcount][$count_inst+1] eq 'Dec'){
                     $reset_field = sprintf("%x", $col);
                  }
                  elsif($fields[$rowcount][$count_inst+1] eq 'Bin'){
                     $reset_field = sprintf("%x", oct("0b$col"));    
                  }                                 
                  else{
                     $reset_field = lc($col);
                  }
               }
               elsif ($fields[0][$count_inst] eq 'Field Width') {
                   $fieldwidth_field = $col;
               }
               $count_inst = $count_inst+1;
            }
            $inst_db{$parent_key_i_i}{'width'} = $fieldwidth_field;
            $inst_db{$parent_key_i_i}{'comp'} = '';
            $inst_db{$parent_key_i_i}{'reset'} = $reset_field;

            my $maxsize = $regsize -1;
            my $minsize = $regsize - $fieldwidth_field;
            $regsize = $minsize;  
        
            $inst_db{$parent_key_i_i}{'lsb'} = $minsize;
            $inst_db{$parent_key_i_i}{'msb'} = $maxsize; 
            $inst_db{$parent_key_i_i}{'iname'} =@$row[0] ; 
            $inst_db{$parent_key_i_i}{'cpath'} =$parent_key_i; 

            $inst_int =$inst_int+1;
            $rowcount = $rowcount+1;
         }
      }
      

      #clear hash and variables for next register
      #save the reg_def in an array before clear
      my $reg_name = $regDef{'name'};
      push @regDef_array, $reg_name;
      push @reg_opcode, $regDef{'RegOpcode'};
      %regDef = ();
      @fields = ();
      @inlist = ();
      $arrayRow = 0;
      $genDesc = 'na';       
   }  
  }
}

##################################################################
##################################################################

sub create_tap_def_hash {

  if((not(defined $cu1))) {

   #The code should run for only after each TAP definition complete
   if(($genDesc eq 'tap_field_def')) {
      my $super_parent = "";
      my $parent_key = ".".$tap_name;

      my %tap_regDef_attr;
      tie %tap_regDef_attr, 'Tie::IxHash';

      foreach my $key (keys %tapDef) {
            my $value = $tapDef{$key};
            $tap_regDef_attr{$key} = $value;
      }

      foreach my $key (@tapDef_remove) {
         delete($tap_regDef_attr{$key});
      }

      #loading %comp_db
      $comp_db{$parent_key}{'parent'} = $super_parent;
      $comp_db{$parent_key}{'is_inst'} = 0;
      $comp_db{$parent_key}{'name'} = $tap_name;
      if($tap_name ne $gRdlCompName){
      $comp_db{$parent_key}{'child'} = 1;
      }
      $comp_db{$parent_key}{'attr'} = \%tap_regDef_attr;
      $comp_db{$parent_key}{'level'} = 1;
      $comp_db{$parent_key}{'type'} = 'addrmap';

      #get the field list
      my @inlist = ();
      push @inlist,"TAP_IR";
      foreach my $row (@fields) {  
            if(@$row[0] ne 'Register Name') {
               push @inlist, @$row[0];
            }
      }
      $comp_db{$parent_key}{'ilist'} = [];
      foreach my $newlist (@inlist) {
            push $comp_db{$parent_key}{'ilist'}, $newlist;
      }
      $comp_db{$parent_key}{'addr_idx'} = @inlist;
 
      my %tapField_remove_hash = map { $_ => 1 } @tapField_remove;
      foreach my $row (@fields){  
         if (@$row[0] ne 'Register Name'){
            my $count = 0;
            foreach my $col (@$row){
               if(not(exists($tapField_remove_hash{$fields[0][$count]}))){
                  if(exists ($dispDef{$fields[0][$count]})){
               $comp_db{$parent_key}{'ovrd'}{@$row[0]}{$dispDef{$fields[0][$count]}} = $col;
                  }
                  else {
                     $comp_db{$parent_key}{'ovrd'}{@$row[0]}{$fields[0][$count]} = $col;
                  }
               }
               $count = $count+1;
            }
      

            #filling inst_db hash
            my $parent_key_i_i = $parent_key.'.'.@$row[0];
            $inst_db{$parent_key_i_i}{'comp'} = @$row[3];
            $inst_db{$parent_key_i_i}{'iname'} = @$row[0];
            $inst_db{$parent_key_i_i}{'cpath'} = '.'.@$row[3];
            $inst_db{$parent_key_i_i}{'addr'} = first_index { $_ eq @$row[0] } @inlist;
         }
      }
      
      #filling inst_db hash for TAP_IR
      my $parent_key_i_i = $parent_key.'.'.'TAP_IR';
      $inst_db{$parent_key_i_i}{'comp'} = 'TAP_IR';
      $inst_db{$parent_key_i_i}{'iname'} = 'TAP_IR';
      $inst_db{$parent_key_i_i}{'cpath'} = '.'.'TAP_IR';
      $inst_db{$parent_key_i_i}{'addr'} = first_index { $_ eq 'TAP_IR' } @inlist;

      #clear hash and variables for next register
      #save the reg_def in an array before clear
      %tapDef = ();
      @fields = ();
      @inlist = ();
      $arrayRow = 0;
      $genDesc = 'na';

   }
  }
}
$gTopType = $gRdlCompType; # 'addrmap';
#$gDesignType = 'tap';


######################################################################################
############################ FRONT END CODE ENDS AT THIS POINT #######################
######################################################################################
}
else {
process_rdl($output_pp);
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
   print "\n###### COMPONENTS #####\n";
   print Dumper (\%comp_db);
   print "\n###### INSTANCES #####\n";
   print Dumper (\%inst_db);
   #print "###### FOUND #####\n";
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

unless(-e $gOutDir or mkdir($gOutDir,0750)) {
   die "-E- Unable to create $gOutDir\n";
}

my $add_prefix = ($gUniq_Prefix ne "");
my $add_suffix = ($gUniq_Suffix ne "");

my $ofile;

if ($gOutIcl) {

   my $new_top_name = $gIclName;

   if($gRdlFile eq 'xlsm') {
       $new_top_name = $gRdlCompName;
   }
   
   my $out_file_name = "$gOutDir/${new_top_name}.icl";
   #print "ravish: $out_file_name";
   open ($ofile, '>', $out_file_name) or die "Can't create '$out_file_name': $!";

   # FIXME? No uniquification of top level module!
   #print "Ravishankar_before: $new_top_name\n" ;
   $new_top_name = icl_add_prefix_suffix($new_top_name);
   #ravishankar edits for testing
   #$use_hdr_file = 1;
   ##################
   icl_map_interfaces() if ($use_hdr_file);

   if ($gDebugFlag) {
      print "\n###### COMPONENTS - FINAL #####\n";
      print Dumper (\%comp_db);
      print "\n###### INSTANCES - FINAL #####\n";
      print Dumper (\%inst_db);
      print ("###### ICL Comp DB #####\n");
      print Dumper (\%icl_comp_db);
   }
   #my $ravishtest = 'test';
   #$ravishtest = icl_add_prefix_suffix($ravishtest);
   #print"ravishankar test: $ravishtest\n";
   #print "Ravishankar_after: $new_top_name\n" ;
   #print "Ravishankarfile:$new_top_name"; 
   #$new_top_name = 'ip_test_v1';
   icl_print_top($gTopPath, "", $ofile, $gTopName, $new_top_name);
   close ($ofile);

}
if ($gOutRdl) {

   my $new_top_name = $gTopName;
   $new_top_name = icl_add_prefix_suffix($new_top_name);

   my $out_file_name = "$gOutDir/${new_top_name}.rdl";
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
   $input = remove_comments($input,0) unless ($gKeepComments && $gMode eq "pp");

   while ($input =~ /(.*?)<%/sgc) {
      # process any RDL lines before the first/next <%
      $output  .= verilog_pp($1) if length($1);

      # process the Perl code between <% ... %>
      # keep \n as a part of the processed text
      $input   =~ /(.*?)%>/sgc or die "couldn't find %>";
      my $code = $1;
      # support of <%=<expression>;%>
      #$code    =~ s/^=([^;]+)(.*)/print \$out ($1);/;   # print Perl variables
      $code    =~ s/^=([^;]+)(.*)/print($1);/;   # print Perl variables
      die "-E- Incorrect assignment <%=$1;$2%>" if defined $2 && $2 =~ /[^\s;]/;

      # Replace RTL parameters
      # FIXME: This allows computed paramters to be replaced as well, which shouldn't be allowed
      #        $STF_PID_SIZE    = 8;
      #        $SB_STF_PID_SIZE = $STF_PID_SIZE;
      #        $STF_SIZE_SB     = 512; 
      #        $NUMBITS_SB      = ($STF_SIZE_SB==32)?5:6;
      # Search and replace "^$var = val;"
      #                 or ";$var = val;"
      # FIXME parameter as a part of .pm file isn't supported
      # to fix that, we need to replace where the parameter is used
      #$output  =~ s/(?<=[^;])\s*\$([a-zA-Z]\w*)\s*=\s*([^\s;]+)\s*;/"\$$1 = ".getParamValue($1,$2).";"/sge;
      $code  =~ s/\$([a-zA-Z]\w*)\s*=(?!=)([^;]+);/"\$$1 = ".getParamValue($1,$2).";"/sge;
      $output .= "$code";
   }

   # process any RDL lines after the last %>
   # pos($var): offset of where the last "m//g" search for $var ended
   my $str  = substr $input, pos($input) // 0;
   $output .= verilog_pp($str) if length($str);

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
    my $keep_formatting = shift;

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
                    $output .= preprocess_file ("$path/$file");
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

    sub getParamValue
    {
        my $name  = shift;
        my $value = shift // "";

        _init_unused_params() unless (scalar %_unused_params);

        if (exists $gRtlParams{$name}) {
            $_unused_params{$name} = 0;
            return $gRtlParams{$name};
        }
        else {
            return $value;
        }
    }

    sub getUnusedParams
    {
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
         if ($line =~ /(.*?)(?!\\)\"\s*;/) { # " marks the end of mulit-line string 
            $multi_line_string = 0;
         } else {
         }
      } elsif ($inside_block) {
         if ($line =~ /(.*?)}/) { # } marks the end of mulit-line block
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
           warn "-W- Mismatch between RDL defintion name and maodule name in ICL header file - using $comp_name from the ICL file (RDL name: $gTopName)\n";
         }
         $current_path = icl_create_comp($comp_name,$current_path);
         $gIclName = $comp_name;

      } elsif ($line =~ /^\s*(\w+)Port\s+(.*);/) {
         ##########################################################
         $block_type = "port";
         $block_subtype = $1;
         $block_subtype .= "Port";
         $block_name = $2;
         $block_name =~ s/\s+//g;
         #print ("-I- New ICL Port $block_subtype : $block_name\n");
         $icl_comp_db{$current_path}{port}{$block_subtype}{$block_name} = {};

      } elsif ($line =~ /^\s*(\w+)Port\s+(.*){/) {
         ##########################################################
         $inside_block = 1;
         $block_type = "port";
         $block_subtype = $1;
         $block_subtype .= "Port";
         $block_name = $2;
         $block_name =~ s/\s+//g;
         #print ("-I- New ICL Port $block_subtype : $block_name\n");
         $icl_comp_db{$current_path}{port}{$block_subtype}{$block_name} = {};

      } elsif ($line =~ /^\s*ScanInterface\s+(\w+)\s*{/) {
         ##########################################################
         $inside_block = 1;
         $block_name = $1;
         $block_type = "interface";
         $block_subtype = '';
         #print ("-I- New ICL ScanInterface $block_name\n");
         $icl_comp_db{$current_path}{interface}{$block_name}{ports} = {};

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

#   if ($is_interface) {
#      my $id;
#      if ($block_name =~ /^c_(\w+)/) {
#         $id = $1;
#         #$icl_comp_db{$current_path}{$block_type}{$block_name}{is_client} = 1;
#      } elsif ($block_name =~ /^h_(\w+)/) {
#         $id = $1;
#         #$icl_comp_db{$current_path}{$block_type}{$block_name}{is_client} = 0;
#      } else { #unknown/unmapped
#         $id = $block_name;
#         #$icl_comp_db{$current_path}{$block_type}{$block_name}{is_client} = 2;
#      }
#      $icl_comp_db{$current_path}{$block_type}{$block_name}{id} = $1;
#   }

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
               $icl_comp_db{$current_path}{$block_type}{$block_name}{ports}{$value} = 0;
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
# - ScanInterface defintion can exist or not
#   It is not required if specified top module has just single TAP interface
#   If don't exist, interface entry will be auto-created/populated by the script
# - Naming convention: 
#     c_<target tap/register> for client interfaces
#     h_<id> for host interfaces
#     If only single target exists, nameing convention will be ignored

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

   # mapping
   foreach my $port_type (keys %{$icl_comp_db{$gIclModulePath}{port}}) {
      my $is_tap_port     = (grep {/^$port_type$/} ('TMSPort','ToTMSPort'));
      my $is_scan_port    = (grep {/^$port_type$/} ('SelectPort','ShiftEnPort','ToSelectPort','ToShiftEnPort'));
      my $is_client_port  = (grep {/^$port_type$/} ('TMSPort','SelectPort','ShiftEnPort'));
      my $is_host_port    = (grep {/^$port_type$/} ('ToTMSPort',,'ToSelectPort','ToShiftEnPort'));
      my $not_scan_type   = (grep {/^$port_type$/} ('DataInPort',,'DataOutPort','ClockPort','ToClockPort','ToIRSelectPort','AddressPort','WriteEnPort','ReadEnPort'));
      my $reset_type      = (grep {/^$port_type$/} ('ResetPort',,'ToResetPort'));
      my $data_in_type    = ($port_type eq 'DataInPort');
      foreach my $port_name (keys %{$icl_comp_db{$gIclModulePath}{port}{$port_type}}) {
         # ScanInterface mapping
         foreach my $intf (keys %{$icl_comp_db{$gIclModulePath}{interface}}) {
           if (exists $icl_comp_db{$gIclModulePath}{interface}{$intf}{ports}{$port_name}) {
              if (exists $icl_comp_db{$gIclModulePath}{interface}{$intf}{map}{$port_type}) {
                 my $conflicting_name = $icl_comp_db{$gIclModulePath}{interface}{$intf}{map}{$port_type};
                 die "-E- ICL header, ScanInterface $intf: port $port_name of type $port_type specified already ($conflicting_name)\n";
              }
              if ($not_scan_type) {
                 die "-E- ICL header, ScanInterface $intf: port $port_name of type $port_type cannot be part of ScanInterface\n";
              }
              $icl_comp_db{$gIclModulePath}{interface}{$intf}{map}{$port_type} = $port_name;
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
         if ($reset_type || $data_in_type) {
            my $category;
            if (!exists $icl_comp_db{$gIclModulePath}{port}{$port_type}{$port_name}{intel_type}) {
               print("-I- Autocategorizing port $port_type $port_name...\n");
               if ($port_name =~ /secur.*policy/i) {
                  $category = "security";
                  print("-I- Autocategorized port $port_type $port_name as '$category' signal\n");
                  $icl_comp_db{$gIclModulePath}{port}{$port_type}{$port_name}{intel_type} = $category;
               } elsif ($port_name =~ /p.*w.*rgood/i) {
                  $category = "powergood";
                  print("-I- Autocategorized port $port_type $port_name as '$category' signal\n");
                  $icl_comp_db{$gIclModulePath}{port}{$port_type}{$port_name}{intel_type} = $category;
               } elsif ($port_name =~ /ijtag_r.*s.*t/i) {
                  $category = "tlr_reset";
                  print("-I- Autocategorized port $port_type $port_name as '$category' signal\n");
                  $icl_comp_db{$gIclModulePath}{port}{$port_type}{$port_name}{intel_type} = $category;
               } elsif ($port_name =~ /slvid/i) {
                  $category = "slvidcode";
                  print("-I- Autocategorized port $port_type $port_name as '$category' signal\n");
                  $icl_comp_db{$gIclModulePath}{port}{$port_type}{$port_name}{intel_type} = $category;
               }
            }
         }
      } # foreach port name
   }

   # check scan interfaces$
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
         my @inst_list = @{$comp_db{$gTopPath}{ilist}};
         if (!scalar(@inst_list)) {
            die "-E- Top '$gTopPath' has no register/chain instances\n";
         }
         foreach my $inst (@inst_list) {
            my $ipath = "$gTopPath.$inst";
            my $cpath = $inst_db{$ipath}{cpath};
            assign_client_intf($ipath,$inst,1,0,0); # def_name, inst_name, is_inst, is_tap, is_single
         }
      } else { # single regular TAP
         my $top_inst = icl_get_attr('TapInstName', $gTopPath, "", 1, 1, 0);
         $top_inst =~ s/\"//g ;
         if ($top_inst eq "") {
            $top_inst = "tap";
         }
         print("-I- Design top: '$gTopPath' is regular TAP '$top_inst'\n");
         # Single TAP must have single Client/TAP ScanInterface
         # If only one ScanInterface in ICL header file - no need to use c_<> convention
         assign_client_intf($gTopPath,$top_inst,0,1,1); # def_name, inst_name, is_inst, is_tap, is_single
      }
   } else { # top level wrapper with TAP/registers
      foreach my $inst (@{$comp_db{$gTopPath}{ilist}}) {
         my $ipath = "$gTopPath.$inst";
         my $cpath = $inst_db{$ipath}{cpath};
         my $fpath = ".$inst";
         if (check_is_tap($cpath)) {
            if (icl_get_attr('TapType', $cpath, $fpath, 1, 1, 0) eq "\"reg_only\"") {
               print("-I- Processing instances in design top: reg_only wrapper '$inst', addrmap '$cpath'\n");
               # each register must have individual Client/Scan ScanInterface
               my @r_inst_list = @{$comp_db{$cpath}{ilist}};
               if (!scalar(@r_inst_list)) {
                  die "-E- $cpath has no register/chain instances\n";
               }
               foreach my $r_inst (@r_inst_list) {
                  my $r_ipath = "$cpath.$r_inst";
                  my $r_cpath = $inst_db{$r_ipath}{cpath};
                  assign_client_intf($r_ipath,$r_inst,1,0,0);  # def_name, inst_name, is_inst, is_tap, is_single
               }
            } else {
               print("-I- Processing instances in design top: TAP '$inst' (definition '$cpath')\n");
               # Each TAP must have single Client/TAP ScanInterface
               assign_client_intf($ipath,$inst,1,1,0); # def_name, inst_name, is_inst, is_tap, is_single
            }
         } else {
            die "-E- Top level '$gTopPath' cannot have non-TAP instance '$inst' (definition '$cpath')\n";
         }
      } # foreach
   }
}

sub check_tap_intf {
   my $intf_name = shift;
   my $is_tap    = shift;
   my $is_client = shift;

   my $is_tap_exp = $icl_comp_db{$gIclModulePath}{interface}{$intf_name}{is_tap};
   if ($is_tap != $is_tap_exp) {
      my $intf_type     = ($is_tap)? "TAP" : "Scan";
      my $intf_type_exp = ($is_tap_exp)? "TAP" : "Scan";
      die "-E- Incorrect interface type: expected '$intf_type_exp', provided '$intf_type'\n";
   }
   my $is_client_exp = $icl_comp_db{$gIclModulePath}{interface}{$intf_name}{is_client};
   if ($is_client != $is_client_exp) {
      my $intf_type     = ($is_client)? "Client" : "Host";
      my $intf_type_exp = ($is_client_exp)? "Client" : "Host";
      die "-E- Incorrect interface type: expected '$intf_type_exp', provided '$intf_type'\n";
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
      check_tap_intf("c_$name", $is_tap, 1); #name, is_tap, is_client
      if ($is_inst) {
         $inst_db{$path}{intf} = "c_$name";
      } else {
         $comp_db{$path}{intf} = "c_$name";
      }
      return;
   }
   if ($is_single) {
      my @intf_list = keys %{$icl_comp_db{$gIclModulePath}{interface}};
      my $intf_num = scalar(@intf_list);
      if ($intf_num == 1) {
         my $intf_name0 = $intf_list[0];
         check_tap_intf($intf_name0, $is_tap, 1); #name, is_tap, is_client
         if ($is_inst) {
            $inst_db{$path}{intf} = "$intf_name0";
         } else {
            $comp_db{$path}{intf} = "$intf_name0";
         }
         return;
      } elsif ($intf_num == 0) {
         my $type = ($is_inst) ? "instance" : "definition";
         warn "-W- No TAP interface found for $type '$name' (path: '$path')\n";
         warn "-W- Using default interface port names\n";
      } else {
         my $type = ($is_inst) ? "instance" : "definition";
         warn "-W- More than one interface found for $type '$name' (path: '$path')\n";
         warn "-W- Using default interface port names\n";
      }
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

   $icl_comp_db{$current_path} = $icl_comp_tmp;

   return $current_path;

}


### =================================================================
### Process the provided RDL file ($file == '-' is STDIN)
### Not supported:
### All Verilog preprocessor derictive excluding `include
### Perl preprocessing

sub process_rdl
{
   my $input      = shift;

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
         if ($line =~ /(.*?)(?!\\)\"\s*;/) { # " marks the end of mulit-line string 
            $$inst_attr_path -> {$attr_name} .= "\n" . $1;
            $multi_line_string = 0;
         } else {
            $$inst_attr_path -> {$attr_name} .= "\n" . $line;
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
               my $inst_path = create_inst("",$2,$current_path,$def_path,$1); # no ';'
               $address = extract_inst_attr($3,$inst_type,$2,$inst_path,$address); # no ';'
               $comp_db{$current_path}{addr_idx} = $address;
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
         check_rdl_keyword($comp_name,$2);
         check_comp_type($comp_type,$parent_comp_type,$current_path);
         $address = 0; # start new address scope
         $current_path = create_comp($comp_type,$comp_name,$current_path,0,$2);
         print ("-I- New component $comp_type : $comp_name, path $current_path\n");

      } elsif ($line =~ /^\s*(external\s+|internal\s+)?(\w+)\s*{(.*)/) {
         # FIXME check performance impact of internal|external
         ##########################################################
         # new anonymous instance/definition scope, $1 - type
         my $parent_comp_type = $comp_type;
         $comp_type = $2;
         check_comp_type($comp_type,$parent_comp_type,$current_path);
         $address=0;
         # FIXME using '__' for auto-created names (instead of '-')
         $current_path = create_comp($comp_type,"i__$ainst_cnt",$current_path,1,'');
         print ("-I- New anonymous instance $comp_type : i__$ainst_cnt, path $current_path\n");
         $ainst_cnt++;

      } elsif ($line =~ /^\s*(\w+)\s*=\s*(.*)/) {
         ####################################
         # property assignment, $1 - name
         # multi-line string detection
         $attr_name  = $1;
         my $attr_value = $2;
         my $assign_type = "assign";
         my $attr_type  = get_chk_property_type($attr_name,$comp_type,$assign_type);
           die "-E- Duplicated assignment for property '$attr_name'.\n" if (!$gIgnoreErrors && exists $comp_db{$current_path}{attr}{$attr_name});
           warn "-W- Duplicated assignment for property '$attr_name'.\n" if (exists $comp_db{$current_path}{attr}{$attr_name});
         $inst_attr_path = \$comp_db{$current_path}{attr};
         $multi_line_string = extract_value($attr_name,$attr_value,$attr_type,$inst_attr_path);
         # delete default value at field level if exists
         if ($comp_type eq "field" && exists $comp_db{$current_path}{default}) {
            delete $comp_db{$current_path}{default}{$attr_name} if (exists $comp_db{$current_path}{default}{$attr_name});
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
         # No duplication check - the last default wins (Nebulon behavior)
         $inst_attr_path = \$comp_db{$current_path}{default};
         $multi_line_string = extract_value($attr_name,$attr_value,$attr_type,$inst_attr_path);

      } elsif ($line =~ /^\s*(\S+)\s*->\s*(\w+)\s*=\s*(.*)/) {
        ############################################
         # instance property assignment, $1 - instance, $2 - property name
         # multi-line string detection
         $attr_name = $2;
         my $attr_path = $1;
         my $attr_value = $3;
         my $assign_type = "dynamic";
         my $inst_path = find_inst_path($attr_path, $current_path);
         my $attr_type  = get_chk_property_type($attr_name,$comp_type,$assign_type);
           die "-E- Duplicated dynamic assignment for property '$attr_name'.\n" if (exists $comp_db{$current_path}{ovrd}{$attr_path}{$attr_name});
         # FIXME do we need to store definition target?
         #$comp_db{$current_path}{ovrd}{$attr_path}{$attr_name}{ipath} = $inst_path;
         $inst_attr_path = \$comp_db{$current_path}{ovrd}{$attr_path};
         $multi_line_string = extract_value($attr_name,$attr_value,$attr_type,$inst_attr_path);

      } elsif ($line =~ /^\s*(\w+)\s*;/) {
        ####################################
         # boolean property assignment, $1 - name
         # boolean properties only, setting to true
         $attr_name = $1;
         my $assign_type = "assign";
         my $attr_value = "true;";
         my $attr_type  = get_chk_property_type($attr_name,$comp_type,$assign_type);
           die "-E- incorrect use of property '$attr_name'\n" if ($attr_type ne 'b');
         $inst_attr_path = \$comp_db{$current_path}{attr};
         $multi_line_string = extract_value($attr_name,$attr_value,$attr_type,$inst_attr_path);

      } elsif ($line =~ /^\s*(external\s+|internal\s+)?(\\?)(\w+)\s+(\\?)(\w+)\s*(.*);/) {
         ##############################################
         # instance - single & array, $1 - definition name, $2 - inst name
         # $3 - array/range and/or end of statement
         my $comp_name = $3;
         my $inst_name = $5;

         check_rdl_keyword($3,$2);
         check_rdl_keyword($5,$4);

         my $def_path = find_comp($comp_name,$current_path);
         my $found_type = $comp_db{$def_path}{type};

         check_comp_type($found_type,$comp_type,$current_path);
         my $inst_path = create_inst($comp_name,$inst_name,$current_path,$def_path,$4); # no ';'
         $address = extract_inst_attr($6,$found_type,$inst_name,$inst_path,$address); # no ';'
         $comp_db{$current_path}{addr_idx} = $address;

      } elsif ($line =~ /^\s*alias\s+(\\?)(\w+)\s+(\\?)(\w+)\s+(\\?)(\w+)\s*;/) {
          die "-E- Register aliasing isn't supported: $line\n";

      } else {
         if ($line =~ /^\s*`include\s+\"(\S+)\"/) { #`
            process_included_file ($1);
         } else {
            die "-E- Not recognized/not supported construct: $line\n";
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
   my $str = shift;
   my $inst_type = shift;
   my $inst_name = shift;
   my $inst_path = shift;
   my $addr = shift;
   my $ary_size = 1;
   my $next_addr = 0; #next available address
   my $addr_multiplier = 1;
   my $reg_width;

   if ($str =~ /^\s*\[(.+)\]\s*(.*)/) {
      $ary_size  = extract_array_size($1,$inst_type,$inst_path, $addr);
      # field specific check of $ary_size vs. fieldwidth
      if ($inst_type eq "field" && 
          exists $comp_db{($inst_db{$inst_path}{cpath})}{attr}{fieldwidth}) {
         my $field_width = $comp_db{($inst_db{$inst_path}{cpath})}{attr}{fieldwidth};
         die "-E- Width mismatch for field array $inst_name\[$ary_size\] - field definition has fieldwidth=$field_width.\n" if ($field_width != $ary_size);
      }
      $str = $2;
   } elsif ($inst_type eq "field") { # single instance
      if (exists $comp_db{($inst_db{$inst_path}{cpath})}{attr}{fieldwidth}) {
         # field specific processing of fieldwidth if no array specified
         $ary_size = $comp_db{($inst_db{$inst_path}{cpath})}{attr}{fieldwidth};
      }
      $inst_db{$inst_path}{msb} = $addr + $ary_size - 1;
      $inst_db{$inst_path}{lsb} = $addr;
      $inst_db{$inst_path}{width} = $ary_size;
   }
   if ($str =~ /^=\s*(.*)/) {
      #note string format to support big numbers
      my $reset_val = extract_num_value_hex_str($1,$ary_size);
      if ($inst_type eq "field") {
         $inst_db{$inst_path}{reset} = $reset_val;
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
      $inst_db{$inst_path}{addr} = $addr;
   } elsif ($str =~ /^\s*$/) {
      # no reset/address values
      # Ordering info for registers and regfiles
      if ($inst_type eq "reg" || $inst_type eq "regfile") {
         $inst_db{$inst_path}{addr} = $addr;
      }
   } else {
      die "-E- unregocnized instance array/address/reset properties '$str'\n";
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

  # Fixme: original processing kept '"' a a part of string values
  # all values stored as strings
  if ($attr_type eq "s") { #string
      # simplifying based on pre-processing
      #print "=> $attr_name = $attr_value\n";
      if ($attr_value =~ /^\"(.*?)(?!\\)\"(.*)/) {
         #my $default = get_property_default($attr_name);
         #print "Attr: $attr_name = '$1' (default: '$default', path '$$attr_path')\n";
         my $skip = 0;
         if (check_property_default($attr_name)) {
            $skip = 1 if (is_compress_attr($attr_name) && (get_property_default($attr_name) eq $1));
         }
         $$inst_apath -> {$attr_name} = $1 unless ($skip);
      } elsif ($attr_value =~ /^\"(.*)/) {
         #multi-line isn't default
         $$inst_apath -> {$attr_name} = $1;
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

sub extract_array_size {
   my $str = shift;
   my $inst_type = shift;
   my $inst_path = shift;
   my $offset = shift;
   my $size = 0;
   my $is_field = ($inst_type eq "field");
   if ($str =~ /^\s*(\d+)\s*:\s*(\d+)\s*$/) {
      $size = ($1 - $2 + 1);
      die "-E- Non-zero lsb array range value for instance type $inst_type ($inst_path)\n" if (!$is_field && ($2 + 0)!= 0);
      $inst_db{$inst_path}{width} = $size;
      if ($is_field) {
         $inst_db{$inst_path}{msb} = ($1 + 0);
         $inst_db{$inst_path}{lsb} = ($2 + 0);
      }
   } elsif ($str =~ /^\s*(\d+)\s*$/) {
      $size = ($1 + 0);
      $inst_db{$inst_path}{width} = $size;
      if ($is_field) {
         $inst_db{$inst_path}{msb} = $offset+$size-1;
         $inst_db{$inst_path}{lsb} = $offset;
      }
   } else {
      die "-E- incorrect format for instnce array '$str': $!\n";
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
   my $mode     = ''; # curent mode: 'ml_comment', 'sl_comment', 'str'
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

   # add any remainin ICL lines after the last match
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
#  - one line per value asignment '<property> = <value>;'
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
   my $mode     = ''; # curent mode: 'ml_comment', 'sl_comment', 'str', 'incl', 'perl'
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

   # add any remainin RDL lines after the last match
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
#  - one line per value asignment '<property> = <value>;'
#  - one line per dynamic value asignment '<instance> -> <property>;'
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
# print main propeties
# print properties with non-default values and IMPORTANT properties with default values
# print req'ed defs from current scope into the SEPARATE file
# FIXME: print additional req'ed defs from scope above
#   - Current scope has priority over the top to eliminate conflicts
#   - addrmap definiton: print to <def_name>_def.icl file
#   - regfile/register definitons: print to same file
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
         # store inst name of first defintion instantion 
         $def_mi_hash_tmp{$cpath} = 1;
      }
   }

   # Find all MI which need to be flattened due to overrides referncing properties inside
   # add '_idx' suffix to the hash value, identifying new updated definition name
   # pessimistic - not analyzing which attributes are overriden and by which values
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
               # <def_orig>_0 is the first with overriden "definition" attributes
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


# return register reset (binary string, no size/radix) and CaptureSource valus (string)
# Assuming that ScanRegiser name is DR
sub get_reg_rc_values
{
   my $def_path       = shift;
   my $full_inst_path = shift;
   # reset value $_[0]
   # capture_source value $_[1]

   # from msb to 0
   my @sorted_fields = sort { $inst_db{"$def_path.$b"}{lsb} <=> $inst_db{"$def_path.$a"}{lsb} } @{$comp_db{$def_path}{ilist}};
   my $reg_msb;
   my $reset_bin_value = "";
   my $capture_source  = "";

   my $prev_is_x   = 1;
   my $prev_is_ro  = 0;
   my $x_width     = 0;
   my $ro_width    = 0;
   my $prev_rd_lsb = 0;
   my $first_cycle = 1;

   foreach my $f (@sorted_fields) {
      
      my $inst_path = "$def_path.$f";
      my $fipath    = "$full_inst_path.$f";
      my $cpath     = $inst_db{$inst_path}{cpath};
      my $value     = "0"; # default

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

      if ($first_cycle) {
         $reg_msb = $msb;
         $first_cycle = 0;
      }
      my $bin_value;
      if (icl_get_attr('TapFieldIsNoInit', $cpath, $fipath, 1, 1, 0) eq 'true') { # no reset value
         $bin_value = "";
         for (my $i=0; $i < $width; $i++) {
           $bin_value .= "x";
         }
      } else { # reset 
         if (exists $ovrd_hash{$fipath}) {
            my %all_overrides;
            foreach my $ovrd_def_path (keys %{$ovrd_hash{$fipath}}) {
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
         } elsif (exists $inst_db{$inst_path}{reset}) {
            $value = $inst_db{$inst_path}{reset};
         } elsif (exists $comp_db{$cpath}{attr}{reset}) {
            $value = $comp_db{$cpath}{attr}{reset};
         } elsif (exists $comp_db{$cpath}{default}{reset}) {
            $value = $comp_db{$cpath}{default}{reset}; # FIXME check hex format
         }
         my $hex_value = hex($value);
         $bin_value = sprintf('%0*b', $width, $hex_value);
      }
      $reset_bin_value .= $bin_value;

      my $access_type = icl_get_attr('AccessType', $cpath, $fipath, 1, 1, 0);
      if (($access_type eq "\"RW\"") || ($access_type eq "\"Rsvd\"")) {
         if ($prev_is_x) {
            if ($x_width) {
               $capture_source .= "${x_width}'bx,";
               $x_width = 0;
            }
            $capture_source .= "DR[$msb:";
            if ($lsb == 0) {
               $capture_source .= "0]";
            } else {
               $prev_rd_lsb = $lsb;
            }
         } elsif ($prev_is_ro) {
            my $ro_value = substr($reset_bin_value,($reg_msb - $msb - $ro_width),$ro_width);
            $capture_source .= "${ro_width}'b$ro_value,";
            $ro_width = 0;
            $capture_source .= "DR[$msb:";
            if ($lsb == 0) {
               $capture_source .= "0]";
            } else {
               $prev_rd_lsb = $lsb;
            }
         } else {
            if ($lsb == 0) {
               $capture_source .= "0]";
            } else {
               $prev_rd_lsb = $lsb;
            }
         }
         $prev_is_x  = 0;
         $prev_is_ro = 0;
      } elsif (($access_type eq "\"RW/V\"") || ($access_type eq "\"RO/V\"") || ($access_type eq "\"WO\"") || 
             ($access_type eq "\"DUMMY\"") || ($access_type eq "\"Dummy\"") || ($access_type eq "\"dummy\"")) {
         if ($prev_is_x) {
            $x_width += $width;
            if ($lsb == 0) {
               $capture_source .= "${x_width}'bx";
            }
         } elsif ($prev_rd_lsb > 0) {
            $capture_source .= "$prev_rd_lsb],";
            $x_width = $width;
            if ($lsb == 0) {
               $capture_source .= "${x_width}'bx";
            }
         } elsif ($prev_is_ro) {
            my $ro_value = substr($reset_bin_value,($reg_msb - $msb - $ro_width),$ro_width);
            $capture_source .= "${ro_width}'b$ro_value,";
            $ro_width = 0;
            $x_width = $width;
            if ($lsb == 0) {
               $capture_source .= "${x_width}'bx";
            }
         } else {
            die "-E- AccessType processing error for field $cpath ($fipath)\n";
         }
         $prev_rd_lsb = 0;
         $prev_is_x   = 1;
         $prev_is_ro  = 0;
      } elsif ($access_type eq "\"RO\"") {
         if ($prev_is_x) {
            if ($x_width) {
               $capture_source .= "${x_width}'bx,";
               $x_width = 0;
            }
            if ($lsb == 0) {
               my $ro_value = substr($reset_bin_value,($reg_msb - $msb),$width);
               $capture_source .= "${width}'b$ro_value";
            }
            $ro_width = $width;
         } elsif ($prev_rd_lsb > 0) {
            $capture_source .= "$prev_rd_lsb],";
            if ($lsb == 0) {
               my $ro_value = substr($reset_bin_value,($reg_msb - $msb),$width);
               $capture_source .= "${width}'b$ro_value";
            }
            $ro_width = $width;
         } elsif ($prev_is_ro) {
            if ($lsb == 0) {
               my $full_ro_width = $ro_width + $width;
               my $ro_value = substr($reset_bin_value,($reg_msb - $msb - $ro_width),$full_ro_width);
               $capture_source .= "${full_ro_width}'b$ro_value";
            }
            $ro_width += $width;
         } else {
            die "-E- AccessType processing error for field $cpath ($fipath)\n";
         }
         $prev_rd_lsb = 0;
         $prev_is_x   = 0;
         $prev_is_ro  = 1;
      } else {
         die "-E- Incorrect AccessType $access_type for field $cpath ($fipath)\n";
      }
   } # foreach field
   
   $_[0] = $reset_bin_value;
   $_[1] = $capture_source;
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

   if (exists $icl_comp_db{$gIclModulePath}{interface}{$intf_id}{map}{$port_type}) {
      my $port_name = $icl_comp_db{$gIclModulePath}{interface}{$intf_id}{map}{$port_type};
      $_[0] = $port_name;
      $status = 1;
      if (exists $icl_comp_db{$gIclModulePath}{port}{$port_type}{$port_name}{assigned}) {
         $assigned_already = 1;
      } else {
         $icl_comp_db{$gIclModulePath}{port}{$port_type}{$port_name}{assigned} = 1;
      }
   } elsif (exists $icl_comp_db{$gIclModulePath}{port}{$port_type}) {
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
         my @pot_names = keys %{$icl_comp_db{$gIclModulePath}{port}{$port_type}};
         if ((scalar(@pot_names) == 1) && (grep {/^$port_group$/} ('tap','scan','powergood','tlr_reset'))) { # single port/allowed matched based on single option
            my $port_name = $pot_names[0];
            if (exists $icl_comp_db{$gIclModulePath}{port}{$port_type}{$port_name}{assigned}) {
               # ports with single allowed assignment
               if (grep {/^$port_type$/} ('SelectPort','ToSelectPort','ToTMSPort','ToTCKPort','ToTRSTPort',
                                         'ToResetPort','ToClockPort','DataOutPort','ToIRSelectPort')) {
                  die "-E- Port assignment conflict for $port_type $port_name\n";
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
         } else {
            warn "-W- No certain criteria for mapping port type $port_type (interface $intf_id, group $port_group), skipping assignment and will use default name if needed\n";
         }
      }
   } else {
      warn "-W- No option exists for port type $port_type (interface $intf_id, group $port_group), will use default name if needed\n";
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
            #print("-DEBUG- (INST=$is_inst) Overriden inst . def path:attribute: $full_inst_path . $ovrd_def_path : $attr");
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
      #print("-DEBUG- (INST=$is_inst) Definiton attribute inst . def path:attribute: $full_inst_path . $def_path : $attr");
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
# print main propeties
# print properties with non-default values
#   - If any, inst level properties as a separate block
# print req'ed defs from current scope
# print additional req'ed defs from scope above
#   - Current scope has priority over the top to eliminate conflicts
#   - addrmap definiton: print to separate <def_name>_def.rdl file
#   - regfile/register definitons: print to separate <def_name>_def_regs.rdl file
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
   # if overriden, delete the "used" entry in %ovrd_hash
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
   # if overriden, delete the "used" entry in %ovrd_hash
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
      die "-E- Toop level component $def_path is not an addrmap (actual type: $comp_type)\n";
   }

   %included_defs = ();

   # local for that specific definition!
   my %mi_hash;
   
   # populate global override db
   icl_populate_ovrd_hash($def_path,$full_inst_path);

   # populate MI db and mark instances/deifnitions which require uniquification
   icl_process_mi($def_path,$full_inst_path,\%mi_hash);

   my $is_tap = 0;
   # check if $inst reg or regfile to identify current component as tap
   foreach my $inst (@{$comp_db{$def_path}{ilist}}) {
      my $ipath     = "$def_path.$inst";
      my $cpath     = $inst_db{$ipath}{cpath};
      if (($comp_db{$cpath}{type} eq "reg") || ($comp_db{$cpath}{type} eq "regfile")) {
        print ("-I- Found TAP $def_path\n") if (!$is_tap);
        $is_tap = 1;
      }
   } #foreach inst

   my $is_top_level = ($full_inst_path eq "");
   if ($is_top_level) {
      icl_print_header($ofile);
   }; 

   if ($is_tap) {
      icl_print_tap($def_path,$full_inst_path,$ofile,$base_name,$new_def_name,$is_top_level);

   } else {

      print $ofile ("\nModule $gIclName {\n\n");

      icl_print_attr($def_path, $full_inst_path, $ofile,0,1,0,$is_top_level);

      my $tdi_name_default         = "Tdi";
      my $tdo_name_default         = "Tdo";
      my $tms_name_default         = "Tms";
      my $trst_name_default        = "Trstb";
      my $tclk_name_default        = "Tclk";
      my $pwrgood_name_default     = "fdfx_powergood";
      my $security_name_default    = "fdfx_secure_policy[3:0]";
      my $slvidcode_name_default   = "ftap_slvidcode[31:0]";
      my $taplink_sel_name_default = "Taplink_ir_sel";
      
      my $tdi_name          = $tdi_name_default;
      my $tdo_name          = $tdo_name_default;
      my $tms_name          = $tms_name_default;
      my $trst_name         = $trst_name_default;
      my $tclk_name         = $tclk_name_default;
      my $pwrgood_name      = $pwrgood_name_default;
      my $security_name     = $security_name_default;
      my $slvidcode_name    = $slvidcode_name_default;
      my $taplink_sel_name  = $taplink_sel_name_default;
      
      my $intf_id;
      my $assigned;
      my $pwrgood_exists = 0;
      my $security_exists = 0;
      my $slvidcode_exists = 0;

      if (exists $comp_db{$def_path}{intf}) {
         $intf_id = $comp_db{$def_path}{intf};
         $assigned = assign_port_name($intf_id,"tap","ScanInPort",$tdi_name);
         print ("-I- Top TDI port assigned to '$tdi_name' (ScanInterface '$intf_id')\n");
         $assigned = assign_port_name($intf_id,"tap","ScanOutPort",$tdo_name);
         print ("-I- Top TDO port assigned to '$tdo_name' (ScanInterface '$intf_id')\n");
         $assigned = assign_port_name($intf_id,"tap","TMSPort",$tms_name);
         print ("-I- Top TMS port assigned to '$tms_name' (ScanInterface '$intf_id')\n");
         $assigned = assign_port_name($intf_id,"tap","TRSTPort",$trst_name);
         print ("-I- Top TRSTb port assigned to '$trst_name'\n");
         $assigned = assign_port_name($intf_id,"tap","TCKPort",$tclk_name);
         print ("-I- Top TCLK port assigned to '$tclk_name'\n");
         $assigned = assign_port_name($intf_id,"powergood","ResetPort",$pwrgood_name);
         if ($assigned) {
            print ("-I- Top DFx Powergood port assigned to '$pwrgood_name'\n");
            $pwrgood_exists = 1;
         } else {
            print ("-W- No top DFx Powergood port exists\n");
            print ("-W- All TAP registers will use TRSTb for reset\n");
         }
         $assigned = assign_port_name($intf_id,"security","DataInPort",$security_name);
         if ($assigned) {
             print ("-I- Top TAP Security port assigned to '$security_name'\n");
             $security_exists = 1;
         } else {
            print ("-W- No top TAP Security port exists\n");
         }
         $assigned = assign_port_name($intf_id,"slvidcode","DataInPort",$slvidcode_name);
         if ($assigned) {
             print ("-I- Top TAP SLVIDCODE strap port assigned to '$slvidcode_name'\n");
             $slvidcode_exists = 1;
         } else {
            print ("-I- No top TAP SLVIDCODE strap port exists\n");
         }
      } else { # use standard/default names
      }
   
      if (undef $intf_id) {
         $intf_id = "tap";
      }
      print $ofile ("\n${text_indent}// FIXME: preliminary implementation, not completed yet!\n");
      
      print $ofile ("\n${text_indent}// Common TAP interfaces\n");
      print $ofile ("${text_indent}TRSTPort    $trst_name;\n");
      print $ofile ("${text_indent}TCKPort     $tclk_name;\n");

      if ($pwrgood_exists) {
         print $ofile ("\n${text_indent}// fdfx_pwrgood: port & powergood reset generator\n");
         print $ofile ("${text_indent}//  NOTE: using DataInPort @ top level\n");
         print $ofile ("${text_indent}DataInPort    $pwrgood_name { DefaultLoadValue 1'b1; }\n");

         print $ofile ("\n${text_indent}DataMux trstb_or_pwrgood SelectedBy $pwrgood_name {\n");
         print $ofile ("${text_indent}   1'b0 : 1'b0;\n");
         print $ofile ("${text_indent}   1'b1 : $trst_name;\n");
         print $ofile ("${text_indent}}\n");
      }

      if ($security_exists) {
         print $ofile ("\n${text_indent}// DFx Secure Plugin - simplified: no latch, fdfx_earlyboot_exit, fdfx_policy_update\n");
         print $ofile ("${text_indent}DataInPort    $security_name;\n");
         print $ofile ("${text_indent}//DataInPort    fdfx_earlyboot_exit;\n");
         print $ofile ("${text_indent}//DataInPort    fdfx_policy_update;\n");

         print $ofile ("\n${text_indent}Enum TAP_SECURITY {\n");
         print $ofile ("${text_indent}   SECURITY_LOCKED      = 4'h0;\n");
         print $ofile ("${text_indent}   FUNCTIONALITY_LOCKED = 4'h1;\n");
         print $ofile ("${text_indent}   SECURITY_UNLOCKED    = 4'h2;\n");
         print $ofile ("${text_indent}   RESERVED             = 4'h3;\n");
         print $ofile ("${text_indent}   INTEL_UNLOCKED       = 4'h4;\n");
         print $ofile ("${text_indent}   OEM_UNLOCKED         = 4'h5;\n");
         print $ofile ("${text_indent}   REVOKED              = 4'h6;\n");
         print $ofile ("${text_indent}   USER1_UNLOCKED       = 4'h7;\n");
         print $ofile ("${text_indent}   USER2_UNLOCKED       = 4'h8;\n");
         print $ofile ("${text_indent}   USER3_UNLOCKED       = 4'h9;\n");
         print $ofile ("${text_indent}   USER4_UNLOCKED       = 4'ha;\n");
         print $ofile ("${text_indent}   USER5_UNLOCKED       = 4'hb;\n");
         print $ofile ("${text_indent}   USER6_UNLOCKED       = 4'hc;\n");
         print $ofile ("${text_indent}   USER7_UNLOCKED       = 4'hd;\n");
         print $ofile ("${text_indent}   USER8_UNLOCKED       = 4'he;\n");
         print $ofile ("${text_indent}   PART_DISABLED        = 4'hf;\n");
         print $ofile ("${text_indent}}\n");
      }

      print $ofile ("\n${text_indent}// Individual TAP instances\n");

      #my $base_name       = shift;
      #my $same_file       = shift;
   
      my $out_fname_inc = "";
      my $out_name_inc = "";
      my $ofile_inc;
      my $inc_type = "";
   
      foreach my $inst (@{$comp_db{$def_path}{ilist}}) {
   
         my $ipath = "$def_path.$inst";
         my $dpath = $inst_db{$ipath}{cpath};
         my $fpath = "$full_inst_path.$inst";
   
         my $comp_type = $comp_db{$dpath}{type};
   
         my $def_name =$inst_db{$ipath}{comp};
         my $inst_def_name       = icl_uniquify_def_name($def_name,$inst,$base_name,\%mi_hash);
         my $final_inst_def_name = icl_add_prefix_suffix($inst_def_name);
   
         print $ofile ("\n");
   
         my $out_name_inc = "${final_inst_def_name}";
         if (!exists $included_files{$out_name_inc}) {
            my $out_fname_inc_a = "$gOutDir/${out_name_inc}.icl";
            $included_files{$out_name_inc} = 1;
      
            open ($ofile_inc, '>', $out_fname_inc_a) or die "Can't create '$out_fname_inc': $!";
            icl_print_header($ofile_inc);
   
            icl_print_tap($dpath,$fpath,$ofile_inc,$inst_def_name,$final_inst_def_name,0);
   
            close ($ofile_inc);
         }
   
         print $ofile ("${text_indent}//---------------------------\n");
         print $ofile ("${text_indent}ScanInPort    Tdi_${inst};\n");
         print $ofile ("${text_indent}ScanOutPort   Tdo_${inst} { Source ${inst}.Tdo;}\n");
         print $ofile ("${text_indent}TMSPort       Tms_${inst};\n\n");
      
         print $ofile ("${text_indent}ScanInterface c_${inst} {\n");
         print $ofile ("${text_indent}   Port Tdi_${inst};\n");
         print $ofile ("${text_indent}   Port Tdo_${inst};\n");
         print $ofile ("${text_indent}   Port Tms_${inst};\n");
         print $ofile ("${text_indent}}\n");
      
         print $ofile ("\n${text_indent}Instance $inst Of $final_inst_def_name {\n");
   
         icl_print_attr($dpath, $fpath, $ofile,1,1,1,1);# $extra_indent
   
         print $ofile ("${text_indent}   InputPort Tdi                = Tdi_${inst};\n");
         print $ofile ("${text_indent}   InputPort Tms                = Tms_${inst};\n");
         print $ofile ("${text_indent}   InputPort Trstb              = $trst_name;\n");
         print $ofile ("${text_indent}   InputPort Tclk               = $tclk_name;\n");
         print $ofile ("${text_indent}   InputPort fdfx_powergood     = trstb_or_pwrgood\n");
         if ($security_exists) {
            print $ofile ("${text_indent}   InputPort fdfx_secure_policy = ;\n");
         }
         print $ofile ("${text_indent}}\n");
      }
   
      print $ofile ("} // end of $new_def_name\n\n");

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

   my $comp_type = $comp_db{$def_path}{type};
   if ($comp_type ne "addrmap") {
      die "-E- Instance $full_inst_path is not an addrmap (actual type: $comp_type)\n";
   }

   %included_defs = ();

   # local for that specific definition!
   my %mi_hash;
   my @reg_list;
   my %reg_hash;
   my @reg_defs_to_print = ();
   my @regfile_defs_to_print = ();
   
   # populate global override db
   icl_populate_ovrd_hash($def_path,$full_inst_path);

   # populate MI db and mark instances/deifnitions which require uniquification
   icl_process_mi($def_path,$full_inst_path,\%mi_hash);

   # populate info about echa TAP opcode/register
   my $ir_reset_bin_value;
   my $ir_reset_opcode;
   foreach my $inst (@{$comp_db{$def_path}{ilist}}) {
      my $ipath     = "$def_path.$inst";
      my $cpath     = $inst_db{$ipath}{cpath};
      my $fpath     = "$full_inst_path.$inst";
      if ($comp_db{$cpath}{type} eq "reg") {
        # Skip TAP IR but extract reset & capture values
        if ($comp_db{$cpath}{name} eq "TAP_IR") {
           my $capture_source;
           get_reg_rc_values($cpath,$fpath,$ir_reset_bin_value,$capture_source);
           $reg_hash{TAP_IR}{size} = icl_get_attr('TapShiftRegLength', $cpath, $fpath, 0, 1, 0);
           next;
        }
        if (icl_get_attr('TapDrIsFixedSize', $cpath, $fpath, 1, 1, 0) eq 'true') { # fixed size reg
           $reg_hash{$inst}{size} = icl_get_attr('TapShiftRegLength', $cpath, $fpath, 0, 1, 0);
        } else { # variable size reg
           $reg_hash{$inst}{size} = "\"VARIABLE\"";
        }
      } elsif ($comp_db{$cpath}{type} eq "regfile") {
         $reg_hash{$inst}{size} = "\"VARIABLE\"";
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

      my $reg_security = icl_get_attr('TapOpcodeSecurityLevel', $cpath, $fpath, 0, 1, 0);
      $reg_hash{$inst}{security}       = $reg_security;
      $reg_security =~ s/SECURE_//;
      $reg_security =~ s/\"//g;
      $reg_hash{$inst}{security_short} = $reg_security;

   } #foreach inst
   
   # FIXME sort @reg_list (based on opcode or reg inst name????)

   # find IR reset opcode
   my $ir_opcode_found = 0;
   if ($ir_reset_bin_value eq "") {
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
      die "-E- No defined opcode found which matches TAP IR reset (0x$ir_hex)\n";
   }
   my $ir_capture_value = icl_get_attr('TapIrCaptureValue', $def_path, $full_inst_path, 0, 1, 1); # default, override, no_error
   if ($ir_capture_value ne "") {
      $reg_hash{TAP_IR}{capture_value} = $ir_capture_value;
   }

   # sorted reg list based on opcodes, from min to max
   my @sorted_reg_list = sort { hex($reg_hash{$a}{opcode}) <=> hex($reg_hash{$b}{opcode}) } @reg_list;
  
   if ($is_top_level) {
      print $ofile ("\nModule $gIclName {\n\n");
   } else {
      print $ofile ("\nModule $new_def_name {\n\n");
   }

   icl_print_attr($def_path, $full_inst_path, $ofile,0,1,0,$is_top_level);

   my $indent = $text_indent;

   if ($gTapLink) {
      print $ofile ("${indent}//--------------------------------------------------------------------------------\n");
      print $ofile ("${indent}//Parameters (overridable)\n");
      print $ofile ("${indent}Parameter TAPLINK_MODE = 1\'b0;\n");
   }

   # FIXME remove ovfd flag
   my $ir_length_str = icl_get_attr('TapIrLength', $def_path, $full_inst_path, 0, 1, 1);
   my $ir_length;
   if ($ir_length_str ne "") {
      $ir_length = int($ir_length_str);
      my $ir_size = int($reg_hash{TAP_IR}{size});
      if ($ir_length != $ir_size) {
         die "-E- TAP IR has different size specified in TapIrLength and in TAP_IR register definiton(TAP: $def_path, $ir_length vs. $ir_size)\n";
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
   my $taplink_sel_name_default = "Taplink_ir_sel";
   
   my $tdi_name          = $tdi_name_default;
   my $tdo_name          = $tdo_name_default;
   my $tms_name          = $tms_name_default;
   my $trst_name         = $trst_name_default;
   my $tclk_name         = $tclk_name_default;
   my $pwrgood_name      = $pwrgood_name_default;
   my $security_name     = $security_name_default;
   my $slvidcode_name    = $slvidcode_name_default;
   my $taplink_sel_name  = $taplink_sel_name_default;
   
   my $intf_id;
   my $assigned;
   my $pwrgood_exists = 0;
   my $security_exists = 0;
   my $slvidcode_exists = 0;

   if ($is_top_level) { # use names from ICL header file
      if (exists $comp_db{$def_path}{intf}) {
         $intf_id = $comp_db{$def_path}{intf};
         $assigned = assign_port_name($intf_id,"tap","ScanInPort",$tdi_name);
         print ("-I- Top TDI port assigned to '$tdi_name' (ScanInterface '$intf_id')\n");
         $assigned = assign_port_name($intf_id,"tap","ScanOutPort",$tdo_name);
         print ("-I- Top TDO port assigned to '$tdo_name' (ScanInterface '$intf_id')\n");
         $assigned = assign_port_name($intf_id,"tap","TMSPort",$tms_name);
         print ("-I- Top TMS port assigned to '$tms_name' (ScanInterface '$intf_id')\n");
         $assigned = assign_port_name($intf_id,"tap","TRSTPort",$trst_name);
         print ("-I- Top TRSTb port assigned to '$trst_name'\n");
         $assigned = assign_port_name($intf_id,"tap","TCKPort",$tclk_name);
         print ("-I- Top TCLK port assigned to '$tclk_name'\n");
         $assigned = assign_port_name($intf_id,"powergood","ResetPort",$pwrgood_name);
         if ($assigned) {
            print ("-I- Top DFx Powergood port assigned to '$pwrgood_name'\n");
            $pwrgood_exists = 1;
         } else {
            print ("-W- No top DFx Powergood port exists\n");
            print ("-W- All TAP registers will use TRSTb for reset\n");
            $pwrgood_name = $trst_name;
         }
         $assigned = assign_port_name($intf_id,"security","DataInPort",$security_name);
         if ($assigned) {
             print ("-I- Top TAP Security port assigned to '$security_name'\n");
             $security_exists = 1;
         } else {
            print ("-W- No top TAP Security port exists\n");
         }
         $assigned = assign_port_name($intf_id,"slvidcode","DataInPort",$slvidcode_name);
         if ($assigned) {
             print ("-I- Top TAP SLVIDCODE strap port assigned to '$slvidcode_name'\n");
             $slvidcode_exists = 1;
         } else {
            print ("-I- No top TAP SLVIDCODE strap port exists\n");
         }
      } else { # use standard/default names
      }
   } else { # use standard/default names
   }

   if (!defined $intf_id) {
      $intf_id = "c_tap";
   }
   
   print $ofile ("\n${indent}//--------------------------------------------------------------------------------\n");
   print $ofile ("${indent}//Local Parameters\n");
   print $ofile ("${indent}LocalParameter IR_SIZE = $ir_length;\n\n");
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
      print $ofile ("${indent}//TAP DR Securities\n");
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
   print $ofile ("${indent}//TAP ports & interfaces\n");
   print $ofile ("${indent}//All TAP ports in ICL must match RTL module port names\n");

   print $ofile ("${indent}ScanInPort     $tdi_name;\n");
   print $ofile ("${indent}ScanOutPort    $tdo_name { Source tdo_mux;} // Final TDO\n");
   print $ofile ("${indent}TRSTPort       $trst_name;\n");
   print $ofile ("${indent}TCKPort        $tclk_name;\n");
   print $ofile ("\n${indent}// Standard JTAG interface\n");
   print $ofile ("${indent}TMSPort        $tms_name;\n");

   if ($pwrgood_exists) {
      print $ofile ("\n${indent}// fdfx_pwrgood\n");
      print $ofile ("${indent}ResetPort      $pwrgood_name { ActivePolarity 0;}\n");
   }

   if ($security_exists) {
      print $ofile ("\n${indent}// DFx Secure Plugin - simplified: no latch, fdfx_earlyboot_exit, fdfx_policy_update\n");
      print $ofile ("${indent}DataInPort     $security_name;\n");
   }

   #FIXME
   if ($slvidcode_exists) {
      print $ofile ("\n${indent}// SLVIDCODE strap\n");
      print $ofile ("${indent}DataInPort     $slvidcode_name;\n");
   }

   print $ofile ("\n${indent}// Client TAP/JTAG interface\n");
   print $ofile ("${indent}ScanInterface $intf_id {\n");
   print $ofile ("${indent}   Port $tdi_name;\n");
   print $ofile ("${indent}   Port $tdo_name;\n");
   print $ofile ("${indent}   Port $tms_name;\n");
   print $ofile ("${indent}}\n");

   if ( $gTapLink ) {
      print $ofile ("\n${indent}\n// Taplink interface\n");
      print $ofile ("${indent}SelectPort    Taplink_ir_sel;\n");
      print $ofile ("\n${indent}ScanInterface c_tl {\n");
      print $ofile ("${indent}  Port $tdi_name;\n");
      print $ofile ("${indent}  Port $tdo_name;\n");
      print $ofile ("${indent}  Port Taplink_ir_sel;\n");
      print $ofile ("${indent}}\n");
   }

   print $ofile ("\n${indent}//--------------------------------------------------------------------------------\n");
   print $ofile ("${indent}// Base TAP logic\n");

   print $ofile ("\n${indent}//--------------------------------------------------------------------------------\n");
   print $ofile ("${indent}// TaP FSM\n");
   print $ofile ("${indent}Instance fsm Of intel_tap_fsm {\n");
   print $ofile ("${indent}  InputPort    tck   = $tclk_name;\n");
   print $ofile ("${indent}  InputPort    tms   = $tms_name;\n");
   print $ofile ("${indent}  InputPort    trstb = $trst_name;\n");
   print $ofile ("${indent}}\n");

   if ($security_exists) {
      print $ofile ("\n${indent}// Intel TAP security\n");
      print $ofile ("${indent}Instance security Of intel_dfxsecure_plugin {\n");
      print $ofile ("${indent}   InputPort fdfx_secure_policy = $security_name;\n");
      print $ofile ("${indent}}\n");
   }

   $ir_reset_opcode  = $reg_hash{TAP_IR}{reset_opcode};
   print $ofile ("\n${indent}// TAP IR\n");
   print $ofile ("${indent}Instance IR Of intel_tap_ir {\n");
   print $ofile ("${indent}  Parameter    IR_SIZE        = \$IR_SIZE;\n");
   print $ofile ("${indent}  Parameter    IR_RESET_VALUE = $ir_reset_opcode;\n");
   # FIXME: make IR read value X for now
   print $ofile ("${indent}  Parameter    IR_CAPTURE_SRC = 'hx;\n");

   if (exists $reg_hash{TAP_IR}{capture_value}) {
      my $ir_capture_value = $reg_hash{TAP_IR}{capture_value};
      print $ofile ("${indent}  Attribute    intel_TapIrCaptureValue = $ir_capture_value;\n");
   }
      
   print $ofile ("${indent}  InputPort    si             = $tdi_name;\n");
   print $ofile ("${indent}  InputPort    rst            = fsm.tlr;\n");
   print $ofile ("${indent}}\n");
   print $ofile ("${indent}Alias IR[\$IR_SIZE-1:0] = IR.IR { RefEnum TAP_INSTRUCTIONS; }\n");

   print $ofile ("\n${indent}//TAP TDR selection & TDO muxing\n");
   print $ofile ("${indent}ScanMux ir_mux SelectedBy fsm.irsel {\n");
   print $ofile ("${indent}   1'b0:    dr_mux;\n");
   print $ofile ("${indent}   1'b1:    IR.so;\n");
   print $ofile ("${indent}}\n");

   #print $ofile ("\n${indent}ScanMux ir_mux_tl SelectedBy Taplink_ir_sel {\n");
   #print $ofile ("${indent}   1'b0:    dr_mux;\n");
   #print $ofile ("${indent}   1'b1:    IR.so;\n");
   #print $ofile ("${indent}}\n");

   #FIXME
   #print $ofile ("\n${indent}ScanMux tdo_mux SelectedBy \$TAPLINK_MODE {\n");
   print $ofile ("\n${indent}ScanMux tdo_mux SelectedBy 1'b0 {\n");
   print $ofile ("${indent}   1'b0:    ir_mux;\n");
   #print $ofile ("${indent}   1'b1:    ir_mux_tl;\n");
   print $ofile ("${indent}   1'b1:    1'b0;\n");
   print $ofile ("${indent}}\n");

   if ($security_exists) {
      print $ofile ("\n${indent}ScanMux dr_mux SelectedBy IR.tir_out, security.unlocked_red, security.unlocked_orange {\n");
      foreach my $reg (@sorted_reg_list) {
         print $ofile ("${indent}   \$${reg}_OPCODE, \$${reg}_SECURITY: ${reg}.so;\n");
      }
      print $ofile ("${indent}   'bx, \$GREEN: BYPASS_RSVD.so;\n");
   } else {
      print $ofile ("\n${indent}ScanMux dr_mux SelectedBy IR.tir_out {\n");
      foreach my $reg (@sorted_reg_list) {
         print $ofile ("${indent}   \$${reg}_OPCODE: ${reg}.so;\n");
      }
      print $ofile ("${indent}   'bx: BYPASS_RSVD.so;\n");
   }
   print $ofile ("${indent}}\n");

   print $ofile ("\n${indent}//--------------------------------------------------------------------------------\n");
   print $ofile ("${indent}// TaP TDRs\n");

   print $ofile ("\n${indent}// BYPASS for reserved opcodes\n");
   print $ofile ("${indent}Instance BYPASS_RSVD Of intel_bypass_rsvd_reg {\n");
   print $ofile ("${indent}  Attribute intel_TapOpcodeSecurityLevel = \"SECURE_GREEN\";\n");
   print $ofile ("${indent}  InputPort  si  = $tdi_name;\n");
   print $ofile ("${indent}}\n");

   foreach my $inst (@sorted_reg_list) {

      my $ipath = "$def_path.$inst";
      my $dpath = $inst_db{$ipath}{cpath};
      my $fpath = "$full_inst_path.$inst";

      my $def_name =$inst_db{$ipath}{comp};
      my $inst_def_name       = icl_uniquify_def_name($def_name,$inst,$base_name,\%mi_hash);
      my $final_inst_def_name = icl_add_prefix_suffix($inst_def_name);
      $inst_db{$ipath}{new_def_name} = $final_inst_def_name;

      my $comp_type = $comp_db{$dpath}{type};
      my $is_reg     = ($comp_type eq "reg");
      my $is_regfile = ($comp_type eq "regfile");
      
      if ($is_reg) {
         print $ofile ("\n${indent}//---------------------------\n");
         print $ofile ("${indent}Instance $inst Of $final_inst_def_name {\n");
         icl_print_attr($dpath, $fpath, $ofile,1,1,1,0);
         print $ofile ("${indent}   InputPort si = $tdi_name;\n");
         print $ofile ("${indent}   InputPort rstn = $pwrgood_name;\n"); # FIXME add reset type
         print $ofile ("${indent}}\n");
         if ($reg_hash{$inst}{size} ne "\"VARIABLE\"") {
            print $ofile ("${indent}Alias ${inst}[\$${inst}_DR_SIZE-1:0] = ${inst}.DR;\n");
         }
         if (! exists $included_defs{$final_inst_def_name}) {
            push @reg_defs_to_print, $inst;
            $included_defs{$final_inst_def_name} = 1;
         }
      } elsif ($is_regfile) {
         print $ofile ("\n${indent}//---------------------------\n");
         print $ofile ("${indent}Instance $inst Of $final_inst_def_name {\n");
         icl_print_attr($dpath, $fpath, $ofile,1,1,1,0);
         print $ofile ("${indent}   InputPort si = $tdi_name;\n");
         print $ofile ("${indent}   InputPort ijtag_reset_b = ~fsm.tlr;\n");
         print $ofile ("${indent}   InputPort rstn = $pwrgood_name;\n"); # FIXME add reset type
         print $ofile ("${indent}}\n");
         if (! exists $included_defs{$final_inst_def_name}) {
            push @regfile_defs_to_print, $inst;
            $included_defs{$final_inst_def_name} = 1;
         }
      } else {
         die "-E- Definition $def_path cannot instantiate component of type $comp_type (instance: $inst)\n";
      }
   } #foreach

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
      icl_print_reg($dpath,$fpath,$new_def_name,$ofile);
   }
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
   my @reg_defs_to_print = ();
   
   # populate global override db
   icl_populate_ovrd_hash($def_path,$full_inst_path);

   # populate MI db and mark instances/deifnitions which require uniquification
   icl_process_mi($def_path,$full_inst_path, \%mi_hash);

   print $ofile ("Module $new_def_name {\n\n");
   icl_print_attr($def_path, $full_inst_path, $ofile,0,1,0,0);
   
   my $so_driver;
   my @so_driver_l = grep {$inst_db{"$def_path.$_"}{addr} == 0} @{$comp_db{$def_path}{ilist}};
   if (scalar(@so_driver_l) == 1) {
      $so_driver = $so_driver_l[0];
      #print ("-I- IJTAG chian $def_path: found .so driver $so_driver\n");
   } else {
      die "-E- No or more than one .so driver exists in the regfile (ijtag cahin) $def_path\n";
   }

   print $ofile ("\n${indent}ScanInPort  si;\n");
   print $ofile ("${indent}ScanOutPort so   { Source $so_driver.so;}\n");
   print $ofile ("${indent}SelectPort  sel;\n");
   print $ofile ("${indent}ResetPort   ijtag_reset_b { ActivePolarity 0; }\n");
   print $ofile ("${indent}ResetPort   rstn { ActivePolarity 0;}\n\n");

   my @low_level_regs = grep {$comp_db{$def_path}{ovrd}{$_}{TapSibRef} ne ""} (keys %{$comp_db{$def_path}{ovrd}});
   my @top_level_sibs = ();
   foreach my $inst (@{$comp_db{$def_path}{ilist}}) {
      if (!grep {/^$inst$/} (@low_level_regs)) {
         push @top_level_sibs, $inst;
      }
   }

   # from max to 0 
   my @sorted_inst_list = sort { $inst_db{"$def_path.$b"}{addr} <=> $inst_db{"$def_path.$a"}{addr} } @{$comp_db{$def_path}{ilist}};
   my @level_inst_list = @top_level_sibs;
   my $level = 0;
   my %sib_inst_hash;
   my %inst_sib_hash;

   # print IJTAG/chain definiton
   while (@sorted_inst_list) {

      my @next_level_regs = ();
      my @processed_inst_list = ();
      my $prev_so_driver = "si";
      # from si to so
      my $comp_idx = 0;

      foreach my $inst (@sorted_inst_list) {

         if (grep {/^$inst$/} @level_inst_list) {

            if (($comp_idx == 0) && (exists $inst_sib_hash{$inst})) {
               $prev_so_driver = "$inst_sib_hash{$inst}.inst_si"
            }

            my @next_level_regs_tmp = grep {$comp_db{$def_path}{ovrd}{$_}{TapSibRef} eq $inst} (keys %{$comp_db{$def_path}{ovrd}});
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

            my $ipath = "$def_path.$inst";
            my $dpath = $inst_db{$ipath}{cpath};
            my $fpath = "$full_inst_path.$inst";

            my $comp_type = $comp_db{$dpath}{type};
            if($comp_type ne "reg") {
               die "-E- Incorrect component type $comp_type (instance $inst) in IJTAG regfile $def_path\n";
            }

            my $def_name =$inst_db{$ipath}{comp};
            my $inst_def_name       = icl_uniquify_def_name($def_name,$inst,$base_name,\%mi_hash);
            my $final_inst_def_name = icl_add_prefix_suffix($inst_def_name);
            $inst_db{$ipath}{new_def_name} = $final_inst_def_name;

            if (!$is_sib) {
               if (! exists $included_defs{$final_inst_def_name}) {
                  push @reg_defs_to_print, $inst;
                  $included_defs{$final_inst_def_name} = 1;
               }
            }
            
            print $ofile ("${text_indent}//---------------------------\n");

            if ($is_sib) {
               print $ofile ("${text_indent}Instance $inst Of intel_ijtag_sib {\n");
               icl_print_attr($dpath, $fpath, $ofile,1,1,1,0);# $extra_indent
               print $ofile ("${text_indent}   InputPort si = $prev_so_driver;\n");
               print $ofile ("${text_indent}   InputPort inst_so = $inst_so_driver;\n");
               print $ofile ("${text_indent}   InputPort rstn = ijtag_reset_b;\n");
               print $ofile ("${text_indent}}\n");
            } else { #reg
               print $ofile ("${text_indent}Instance $inst Of $final_inst_def_name {\n");
               icl_print_attr($dpath, $fpath, $ofile,1,1,1,0);# $extra_indent
               print $ofile ("${text_indent}   InputPort si = $inst_sib_hash{$inst}.inst_si;\n");
               print $ofile ("${text_indent}   InputPort rstn = rstn;\n");
               print $ofile ("${text_indent}}\n");
            }

            $prev_so_driver = "$inst.so";
            $comp_idx += 1;
   
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

   print $ofile ("} // end of $new_def_name\n\n");

   print $ofile ("\n// Register definitions of chain $new_def_name\n");
   foreach my $inst (@reg_defs_to_print) {
      my $ipath = "$def_path.$inst";
      my $dpath = $inst_db{$ipath}{cpath};
      my $fpath = "$full_inst_path.$inst";
      my $new_def_name = $inst_db{$ipath}{new_def_name};
      print $ofile ("//---------------------------\n");
      icl_print_reg($dpath,$fpath,$new_def_name,$ofile);
   }
}

# used to print reg definition
sub icl_print_reg
{
   my $def_path       = shift;
   my $full_inst_path = shift; # full relative path from the specified top instance
   my $final_def_name = shift;
   my $ofile          = shift;

   my $comp_type = $comp_db{$def_path}{type};
   if ($comp_type ne "reg") {
      die "-E- Instance $full_inst_path is not a reg (actual type: $comp_type)\n";
   }

   my $indent = $text_indent;

   # populate global override hash of the current component
   icl_populate_ovrd_hash($def_path,$full_inst_path);

   print $ofile ("Module $final_def_name {\n\n");
   icl_print_attr($def_path, $full_inst_path, $ofile,0,1,0,0);
   
   # get reset and capture values
   my $reset_bin_value;
   my $capture_source;
   get_reg_rc_values($def_path,$full_inst_path,$reset_bin_value,$capture_source);

   my $dr_width = $comp_db{$def_path}{attr}{TapShiftRegLength};
   my $dr_msb   = $dr_width - 1;

   # template
   #    Port definitions
   #    Register instance
   print $ofile ("\n${text_indent}ScanInPort  si;\n");
   print $ofile ("${text_indent}ScanOutPort so   { Source DR[0];}\n");
   print $ofile ("${text_indent}ResetPort   rstn { ActivePolarity 0;}\n");
   print $ofile ("${text_indent}SelectPort  sel;\n\n");
   print $ofile ("${text_indent}ScanRegister DR[${dr_msb}:0] {\n");
   print $ofile ("${text_indent}   ScanInSource   si;\n");
   print $ofile ("${text_indent}   ResetValue     ${dr_width}'b$reset_bin_value;\n");
   print $ofile ("${text_indent}   CaptureSource  $capture_source;\n");
   print $ofile ("${text_indent}}\n");

   foreach my $field (@{$comp_db{$def_path}{ilist}}) {
      my $ipath = "$def_path.$field";
      my $dpath = $inst_db{$ipath}{cpath};
      my $fpath = "$full_inst_path.$field";
      icl_print_field($dpath,$ipath,$fpath,$ofile);
   }
   print $ofile ("} // end of $final_def_name\n\n");
}


# used to print fields/aliases & field attributes inside register definition
sub icl_print_field
{
   my $def_path  = shift;
   my $inst_path = shift;
   my $full_inst_path = shift; # full relative path from the specified top instance
   my $ofile     = shift;

   my $comp_type = $comp_db{$def_path}{type};

   if ($comp_type ne "field") {
      die "-E- Instance $full_inst_path is not a field (actual type: $comp_type)\n";
   }

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
      $comment = " overriden";
   } elsif (exists $inst_db{$inst_path}{reset}) {
      $value = $inst_db{$inst_path}{reset};
   } elsif (exists $comp_db{$comp_path}{attr}{reset}) {
      $value = $comp_db{$comp_path}{attr}{reset};
   } elsif (exists $comp_db{$comp_path}{default}{reset}) {
      $value = $comp_db{$comp_path}{default}{reset}; # FIXME check hex format
   }
   my $alias_msb = $width - 1;
   # FIxME: original //$comment
   $suffix = "[$alias_msb:0] = DR[$msb:$lsb]";

   #$inst_name = "\\$inst_name" if (is_rdl_keyword($inst_name));
   if ($inst_name eq "DR") {
      warn "-W- Name of field $full_inst_path (defintion $def_path) conflicts with predefined name DR of full register - renaming it to 'dr'\n";
      $inst_name = "dr";
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
         $comment = " overriden";
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
            my $value = $ovrd_hash{$full_path}{$def_path}{$attr};
            warn "-W- Unuzed property override '$attr = $value' (target instance '$full_path', source definition '$def_path')\n";
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
   print "####### UDP HASH ##########\n";
   print Dumper (\%udp_hash);
   print "####### UDP PROPAGATE ##########\n";
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
   # property existance checking is already done
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
   # property existance checking is already done
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
   # property existance checking is already done
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
   # property existance checking is already done
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
   # to be overriden from addrmap level
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
      )
   );

   # icl definition level attributes (can include instance lefel properties)
   # If some attribue is instance level but exists in the definiton and definition is the top - keep it!
   # FIXME: revisit the list
   %icl_def_properties = map { $_ => 1 } ( qw(
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
         die "-E- duplicated property definition $1 in UDP fiel $file\n" if (exists $udp_hash{$name});
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

