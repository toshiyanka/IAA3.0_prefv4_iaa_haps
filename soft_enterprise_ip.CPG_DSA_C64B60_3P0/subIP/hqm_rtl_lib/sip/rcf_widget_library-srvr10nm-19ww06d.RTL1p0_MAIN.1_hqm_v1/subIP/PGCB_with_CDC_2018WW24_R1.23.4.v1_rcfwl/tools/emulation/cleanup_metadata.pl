#!/usr/intel/bin/perl
#This script is to parse the metadata file and to create the projects required for each of the entities mentioned in the metadata file
#The current switches handled/used are:
#   -entities_order #This script uses the entities_order to find out the number of projects to create i.e. one for each entity



use strict;
use File::Spec;
use Data::Dump qw(dump);
use Data::Dumper;
use UNIVERSAL;
use Env;

my $StartTimeStamp = localtime();  # Program start

# Verbosity level definitions :
my $VERBOSE = 0;
my $ERROR = 1;
my $WARNING = 2;
my $INFO = 3;


my $debug = $WARNING; # Determines the DEBUG message level to display. printl with debug_level<= debug will be printed.


# Log file initialisation output file : /tmp/clean_metadata.log
my $log = "/tmp/$ENV{'USER'}_clean_metadata.log";
open (LOG, ">$log") || die "Could not create log file $log. $!\n";      # Exsisting log file will be overwriten
close LOG;
&printl("Start time : $StartTimeStamp\n",$log, $VERBOSE);

# Commandline argument parsing.
my $metadata_file = $ARGV[0];                # METADATA input file name
my $metadata_out_file = $ARGV[1];            # METADATA output file name
my $reconfig_file = $ARGV[2];                # RECONFIG input file name

if (defined($metadata_file)){
   &printl("Metadata input file $metadata_file\n",$log, $VERBOSE);
   require $metadata_file;
}else{
   &printl("No metadata input file provided\n",$log, $ERROR);
}

if (defined($metadata_out_file)){
   &printl("Metadata output file $metadata_out_file\n",$log, $VERBOSE);
}else{
   &printl("No metadata input file provided\n",$log, $ERROR);
   exit -1;
}

if (defined($reconfig_file)){
   &printl("Reconfig input file $reconfig_file\n",$log, $VERBOSE);
   require $reconfig_file;
}else{
   &printl("no recongif file provided.\n",$log, $ERROR);
}


our %dump;              # METADATA input database variable
our %reconfig;          # RECONFIG database variable
my $clean_db;          # cleaned METADATA output database reference variable


#if (defined($reconfig{'-debug'})==1){
#   debug = $reconfig{'-debug'};
#   &printl("reconfig debug override $debug.\n",$log, $WARNING);
#}

my $NumberOfHierarchicalLevels = 0;    # Incremented each time the parser decends into another hash
my @Hierarchy;                         # Store ID for each level of in array. $hierarchy[0] is the current lowest level.
my $Indent_str;                        # String with number of spaces reflecting NumberOfHierarchicalLevels



#
#  Process_files : 
#
sub Process_files($$$$){
      my $file_lst               = shift;
      my $reconfig               = shift;  
      my $key                    = shift;  
      my $log                    = shift;

      my $mod_file_lst;
      my $prj_lib_name;

      my $cmd_str;
      my $reconfig_add_vlog_files_index= 0;                                # Points to current -add entry in reconfig list
      my $lib_vlog_files_index= 0;                                         # Points to current entry in source list
      foreach my $file_name (@{$file_lst}) {
         $cmd_str = sprintf($Indent_str." Reconfig : Process_files %s %s %s \n", $prj_lib_name,  $key,  $file_name);
         &printl($cmd_str,$log, $INFO);                # printf(PRJ "$cmd_str");
         my $skip_current_vfile = 0;                                       # Controll add current vfile for remove and replace commands.
         # if defined add file section is defined in reconfig module 
         if ((defined($reconfig->{$key}{'-add'})==1)&&(scalar(@{$reconfig->{$key}{'-add'}})>0)){
            #add vlog file at vlog file index indicated by reconfig file.
            while ($reconfig->{$key}{'-add'}->[$reconfig_add_vlog_files_index][0]==$lib_vlog_files_index) {       
               my @add_entry = @{$reconfig->{$key}{'-add'}}[$reconfig_add_vlog_files_index];
               push(@{$mod_file_lst},$add_entry[0][1]);
               $cmd_str = sprintf($Indent_str." Reconfig : add %s %s #%d %s \n", $prj_lib_name,  $key,  $add_entry[0][0], $add_entry[0][1]);
               &printl($cmd_str,$log, $WARNING);                # print PRJ $cmd_str;
               $reconfig_add_vlog_files_index++;                               # Increment pointer to vlog_files add list after each match with vlog_files index
            }
         }
         # if defined removefile section is defined in reconfig module 
         if (defined($reconfig->{$key}{'-remove'})==1){
            foreach my $item  (@{$reconfig->{$key}{'-remove'}}) {
#               $cmd_str = sprintf($Indent_str." Reconfig : remove search  %s \n", $item );
#               &printl($cmd_str,$log, $WARNING);              # printf(PRJ "$cmd_str");
               if (($file_name=~/$item/)==1){
                  $skip_current_vfile = 1;
                  $cmd_str = sprintf($Indent_str." Reconfig : remove match %s \n", $item);
                  &printl($cmd_str,$log, $WARNING);                # printf(PRJ "$cmd_str");
               }
            }

         }
         # if defined replacefile section is defined in reconfig module 
         if (defined($reconfig->{$key}{'-replace'})==1){
            my $match_str;
            my $replace_str;
            foreach (@{$reconfig->{$key}{'-replace'}}) {
               $match_str = @{$_}[0];
               $replace_str = @{$_}[1];
               if (($file_name=~/$match_str/)==1){ 

                  $skip_current_vfile = 1;
                  $cmd_str = sprintf($Indent_str." Reconfig : -replace matching \"%s\" %s\n", $match_str, $file_name);
                  &printl($cmd_str,$log, $WARNING);                # print PRJ $cmd_str;
                  push(@{$mod_file_lst},$replace_str); 
               }
            }
         }
         if ($skip_current_vfile == 0){
            push(@{$mod_file_lst},$file_name); 
         }
         $lib_vlog_files_index++;
      }
      return $mod_file_lst;
}


sub RemoveDuplicates($$) {
   my $input_lst      = shift;
   my $output_lst     = shift;
   my %defined_lst = {};
   foreach my $item (@$input_lst) {
      if (defined($defined_lst{$item})==1){
         &printl($Indent_str." Reconfig : duplicate $item. \n",$log, $WARNING);
      }else{
         $defined_lst{$item} =1;
         push (@$output_lst, $item);
      }
   }
   return $output_lst;
}

sub Cleanup_FileList($$){
   my $ref = shift;
   my $key = shift;

   my $new_lst;   
   &printl(sprintf( "%s%-20s %-20s", $Indent_str, "Cleanup_FileList", $key),$log, $VERBOSE);
   &printl(sprintf( " -> @Hierarchy\n"),$log, $VERBOSE);
   my $no_duplicates = [];
   RemoveDuplicates($ref->{$key}, $no_duplicates);
   $new_lst = Process_files($no_duplicates, $reconfig{$Hierarchy[0]}, $key, $log);
   RemoveDuplicates($ref->{$key}, $no_duplicates);
   return $new_lst;
}
#b 178 ($opt eq '+define+FAST_DFEMODE+FAST_SIMMODE')
sub split_vlog_opts($) {
   my $vlog_opts     = shift;
   my @vlog_opts_copy = @$vlog_opts;
   my $split_vlog_opts =[];
   foreach my $opt (@vlog_opts_copy) {
      my $tmp_split;
      while (defined($opt)){
         my $tmp_opts;
         # Split $opt string into sepperate strings 
         ($tmp_opts, $opt) = split(' +', $opt, 2);
         my $leading_char = substr($opt, 0, 1);
         while (($leading_char ne '-') & ($leading_char ne '+') & ($leading_char ne '')){
            my $add_opts;
            ($add_opts, $opt) = split(' ', $opt, 2);
            $tmp_opts = $tmp_opts." ".$add_opts;
            $leading_char = substr($opt, 0, 1);
         }
         # Store opt into correct array
#           if($tmp_opts =~ m/^\+define\+\w+\s*=\s*.*$/) { #handling +define+<macro>
#             if (defined($tmp_opts)){
#                push(@$split_vlog_opts, $tmp_opts);
#             }
        if($tmp_opts =~ m/^\+define\+\w+.*$/) { #handling +define+<macro>
            $tmp_opts =~ s/^\+define\+(.*)$/$1/;
            while ($tmp_opts ne ""){
                my $define_item;
                ($define_item, $tmp_opts) = split('\+', $tmp_opts, 2);
                $define_item = "+define+".$define_item;
                push(@$split_vlog_opts, $define_item);
            }
         } elsif($tmp_opts =~ m/^\+libext\+.*$/) { #For handling the libext option
            if (defined($tmp_opts)){
               push(@$split_vlog_opts, $tmp_opts);
            }
         } elsif($tmp_opts =~ /^\+incdir\+.*$/) { #For handling the libext option
            if (defined($tmp_opts)){
               push(@$split_vlog_opts, $tmp_opts);
            }
         } else {#if (($tmp_opts =~ /^-sv$/) | ($tmp_opts =~ /^-sverilog$/)) {
               #We need not explicitly handle this as the default option for Synplify is system verilog
            if (defined($tmp_opts)){
               push(@$split_vlog_opts, $tmp_opts);
            }
         }
      }
   }
   return($split_vlog_opts);
}

sub Process_vlog_opts($){
   my $vlog_opts     = shift;
   my @vlog_opts_copy = @$vlog_opts;

   my $cmd_str;   
   my $mod_opts_lst           = [];
   my $lib_vlog_opts_define_index= 0;                                         # Points to current vlog file in source list
   foreach my $opt_name (@vlog_opts_copy) {
$cmd_str = sprintf($Indent_str." Reconfig : Process_vlog_opts #%d %s\n", $lib_vlog_opts_define_index, $opt_name);
&printl($cmd_str,$log, $INFO);                # printf(PRJ "$cmd_str");
      my $skip_opt_name = 0;                                       # Controll add current vfile for remove and replace commands.
      # if defined removefile section is defined in reconfig module 
      if (defined($reconfig{$Hierarchy[0]}{'-vlog_opts'}{'-remove'})==1){
         foreach (@{$reconfig{$Hierarchy[0]}{'-vlog_opts'}{'-remove'}}) {
#            if (($opt_name=~/$_/)==1){
            if ($opt_name eq $_){
               $skip_opt_name = 1;
$cmd_str = sprintf($Indent_str." Reconfig : remove %s\n", $opt_name);
&printl($cmd_str,$log, $WARNING);                # printf(PRJ "$cmd_str");
            }
         }

      }
      if ($skip_opt_name == 0){
         push(@{$mod_opts_lst},$opt_name); 
      }
      $lib_vlog_opts_define_index++;
   }

   foreach my $opt_name (@{$reconfig{$Hierarchy[0]}{'-vlog_opts'}{'-add'}}) {
$cmd_str = sprintf($Indent_str." Reconfig : add %s\n", $opt_name);
&printl($cmd_str,$log, $WARNING);                # printf(PRJ "$cmd_str");
      push(@{$mod_opts_lst},$opt_name); 
   }
   return $mod_opts_lst;
}

sub Cleanup_Opts($$){
   my $ref = shift;
   my $key = shift;

   my $new_lst;
   my $no_duplicates=[];
   
   &printl(sprintf( "%s%-20s %-20s", $Indent_str, "Cleanup_Opts", $key),$log, $VERBOSE);
   &printl(sprintf( " -> @Hierarchy\n"),$log, $VERBOSE);
   my $new_lst = split_vlog_opts($ref->{$key});
   my $proccessed_lst = Process_vlog_opts($new_lst);
   RemoveDuplicates($proccessed_lst,  $no_duplicates);
   
   return $no_duplicates;
}

sub Main($){
   my $ref = shift;
   
   my $new_hash;
   foreach my $key (keys %$ref){
      if (ref( $ref->{$key}) eq "HASH" ) {
         $NumberOfHierarchicalLevels++;
         $Indent_str = "";
         for(my $i=0; $i<$NumberOfHierarchicalLevels; $i++){ $Indent_str = $Indent_str."  ";}
#         printf(STDOUT ">%3d\t%s%s\n", $NumberOfHierarchicalLevels, $Indent_str, $key);
         if ($key ne "-sub_lib_hash"){  unshift @Hierarchy, $key;}
         &printl(sprintf( "%s%-20s %-20s\n", $Indent_str, "Hash", $key),$log, $VERBOSE);
         $new_hash->{$key} = Main($ref->{$key});
         if ($Hierarchy[0] ne "-sub_lib_hash"){ shift @Hierarchy;}
#         printf(STDOUT "<%3d\t%s%s\n", $NumberOfHierarchicalLevels, $Indent_str, $key);
         $NumberOfHierarchicalLevels--;
      }elsif(ref( $ref->{$key}), "ARRAY" ) {
         my $is_list = 0;   
         my $is_opts = 0;   
         if ($key eq '-vhdl_files'){ $is_list=1;}
         if ($key eq '-vlog_files'){$is_list=1;}
         if ($key eq '-vlog_incdirs'){$is_list=1;}
         if ($key eq '-vlog_lib_dirs'){$is_list=1;}
         if ($key eq '-vlog_lib_files'){$is_list=1;}
         if ($key eq '-sverilog_files'){$is_list=1;}

         if ($key eq '-vlog_opts'){ $is_opts=1;}
         if ($key eq '-vcom_opts'){$is_opts=1;}

         if ($is_list){
            my $new_lst = $new_hash->{$key} = Cleanup_FileList($ref, $key);
            if (defined($new_lst)){
               $new_hash->{$key} = $new_lst;
            }else{
               $new_hash->{$key} = [];
            }
         }elsif ($is_opts){
             my $new_lst = $new_hash->{$key} = Cleanup_Opts($ref, $key);
             if (defined($new_lst)){
                $new_hash->{$key} = $new_lst;
             }else{
                $new_hash->{$key} = [];
             }
         }else{
            $new_hash->{$key} = $ref->{$key};
         }
      }else{
         $new_hash->{$key} = $ref->{$key};
      }
   }
   return $new_hash;
}

sub dump_hash($$){
  my $ref = shift;
  my $filename = shift;

   my $h;
   open($h, ">", $filename) or die "cannot open < $filename : $!";
   my $Str = Dumper($ref);
   my @Lines = split(/\n/, $Str);
   print $h  "# Post cleanup : $StartTimeStamp\n";
   print $h  "%dump = (\n";
   for(my $i=1; $i<$#Lines; $i++){ 
      print $h  "$Lines[$i]\n";
   }
   print $h  ");\n";
   close($h);

}

$clean_db = &Main(\%dump);
$Data::Dumper::Terse = 1;
$Data::Dumper::Quotekeys  = 1;
$Data::Dumper::Indent = 1;
$Data::Dumper::Purity = 1;
$Data::Dumper::Sortkeys = 1;


dump_hash(\%dump, "/tmp/$ENV{'USER'}_clean_metadata_input.txt");
dump_hash($clean_db, $metadata_out_file);
#print "END of dump : \n";

#
#  printl :  print to log, opens/closes the log file for each access.
#
sub printl($$$) {
   my $msg = shift;
   my $log = shift;
   my $debug_level = shift;
   
   if ($debug_level<=$debug){
      open (LOG, ">>$log") || die "Could not open log file $log $msg. $!\n";
      print LOG "$msg";
      close LOG;
   }
   return;
}
# b 73 (($Hierarchy[0] eq 'psf_rtl_lib')&&($key eq '-vlog_incdirs'))
