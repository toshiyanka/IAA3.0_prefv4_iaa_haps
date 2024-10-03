#!/usr/intel/bin/perl
#This script is to read the tcl files which have been produced by emubuild and to generata a metadata file with the content
use strict;
use warnings;
use lib "$ENV{'EMUL_TOOLS_DIR'}/fpga/";
use Getopt::Long;


use ef_lib;
use fpga_flow;
use synplicity;


our $log = "metadat_from_tcl.log"; 
open (LOG, ">$main::log") || die "Could not create log file $main::log. $!\n"; 
close LOG;

my $metadata_file = $ARGV[0];

my $args_OK=1;
if (defined($metadata_file)!=1){
   ef_lib::printl("LOG : No metadata_file provided\n",$main::log);
   $args_OK=0;
}

our %dump;



sub Populate_dummy_METADATA(){
  $dump{'-macros'}                                                = undef;
  $dump{'-top_language'}                                          = undef;
  $dump{'FILTER_CONFIG'}{'-tag_definitions'}{'emu'}{'default'}    = 'emu';
  $dump{'FILTER_CONFIG'}{'-tag_definitions'}{'emul'}{'default'}   = 'emul';
  $dump{'FILTER_CONFIG'}{'Emulation'}{'-dump_format'}             = 'pl';
  $dump{'FILTER_CONFIG'}{'Emulation'}{'-macros'}                  = undef;
  $dump{'FILTER_CONFIG'}{'Emulation'}{'-modules'}                 = 'Ace::Filters::Tag';
  $dump{'FILTER_CONFIG'}{'Emulation'}{'-tags'}                    = ['emul','emu'];
  $dump{'FLAGS_DUMP'}{'-enable_ignore_filter_flags'}               = 0;
  $dump{'FLAGS_DUMP'}{'-ignore_filter_blockit'}                    = [];
  $dump{'FLAGS_DUMP'}{'-ignore_filter_passit'}                     = [];
  $dump{'FLAGS_DUMP'}{'-use_legacy_tagfilter'}                     = 0;
}
sub Init_lib_hash($){
   my $hash = shift;

      $hash->{'-error'}                = undef;
      $hash->{'-has_sublibs'}          = 0;
      $hash->{'-hdl_spec_src_files'}   = ['dummy'];
      $hash->{'-is_test'}              = 0;
      $hash->{'-test_file'}            = [];
      $hash->{'-vcom_opts'}            = [];
      $hash->{'-vhdl_files'}           = [];
      $hash->{'-vlog_files'}           = [];
      $hash->{'-vlog_incdirs'}         = [];
      $hash->{'-vlog_lib_dirs'}        = [];
      $hash->{'-vlog_lib_files'}       = [];
      $hash->{'-vlog_opts'}            = [];
      $hash->{'__resolved__'}          = 1;
}

sub Load_vlog_tcl_file($){
   my $tcl_file_name = shift;
   my $lib_name;
#    $lib_name =~ s/(.*).vlog.tcl/$1/;
#    push(@{$dump{'-entities_order'}},$lib_name); 
   ef_lib::printl("LOG : \t $tcl_file_name.\n",$main::log);
   my $tmp_lib_hash= {};
   Init_lib_hash($tmp_lib_hash);
   $tmp_lib_hash->{'-top_language'}         = 'SystemVerilog';
   open (TCL_FILE, "<$tcl_file_name") || ef_lib::mydie ("ERR : Could not open .tcl file $tcl_file_name\n", $main::log);
   while (<TCL_FILE>){
      my $line = $_;
      chomp $line;
      if ($line=~ /^\s*(-\S+)\s+\\$/){
         $line =~ s/^\s*(-\S+)\s+\\$/$1/; #"       -sv"
         push(@{$tmp_lib_hash->{'-vlog_opts'}}, $line);
      }elsif  ($line=~ /^\s*\-incdir\s+(\S+)\s+\\$/){
         $line =~ s/^\s*\-incdir\s+(\S+)\s+\\$/$1/;     #"      -incdir /nfs/fm/disks/fm_sptlp_00078/rmeessen/project/eff_demo/eff_demo_20140415/2.01.17/project_2/release/ALL/Q20040609_0840/globalIncludes \"
         push(@{$tmp_lib_hash->{'-vlog_incdirs'}}, $line);
      }elsif  ($line=~ /^\s*\-libext\s(\S+)\s+\\$/){
         $line =~ s/^\s*\-libext\s(\S+)\s+\\$/$1/;#"      -libext .vs \"
         $line = "+libext+".$line;
         push(@{$tmp_lib_hash->{'-vlog_opts'}}, $line);
      }elsif  ($line=~ /^\s*\-work\s.*/){
         $line =~ s/^\s*\-work\s(\S+)\s+\\$/$1/;#"      -work fp_unit_lib \"
         $lib_name = $line;
      }elsif  ($line=~ /^\s*\-v\s+\S+\s+\\$/){
         $line =~ s/^\s*\-v\s+(\S+)\s+\\$/$1/;     #
         push(@{$tmp_lib_hash->{'-vlog_lib_files'}}, $line);
      }elsif  ($line=~ /^^\s*\-y\s+(\S+)\s+\\$/){
         $line =~ s/^\s*\-y\s+(\S+)\s+\\$/$1/;     #"      -y /nfs/fm/disks/fm_sptlp_00078/rmeessen/project/eff_demo/eff_demo_20140415/2.01.17/project_2/release/ALL/Q20040609_0840/units/mult_56/src/ \"
         push(@{$tmp_lib_hash->{'-vlog_lib_dirs'}}, $line);
      }elsif  ($line=~ /^\s*\-define\s+(\S+)\s+\\$/){
         $line =~ s/^\s*\-define\s+(\S+)\s+\\$/$1/;     #"      -define zerounitdelay \"
         $line = "+define+".$line;
         push(@{$tmp_lib_hash->{'-vlog_opts'}}, $line);
      }elsif ($line=~ /^\s*(\/\S+)\s+\\$/){
         $line =~ s/^\s*(\S+)\s+\\$/$1/; #"       /nfs/fm/disks/fm_sptlp_00078/rmeessen/project/eff_demo/eff_demo_20140415/2.01.17/project_2/release/ALL/Q20040609_0840/ip/memory32/src/verilog/memory32.v \"
         push(@{$tmp_lib_hash->{'-vlog_files'}}, $line);
      }
   }
   close(TCL_FILE);
   if (defined($lib_name)==1){
      push(@{$dump{'-entities_order'}},$lib_name); 
      $dump{$lib_name} = $tmp_lib_hash;
   }else{
      ef_lib::printl("LOG : \t No lib found.\n",$main::log);
   }
}


sub Load_vhdl_tcl_file($){
   my $tcl_file_name = shift;
   my $lib_name;
#    $lib_name =~ s/(.*).vlog.tcl/$1/;
#    push(@{$dump{'-entities_order'}},$lib_name); 
   ef_lib::printl("LOG : \t $tcl_file_name.\n",$main::log);
   my $tmp_lib_hash= {};
   Init_lib_hash($tmp_lib_hash);
   $tmp_lib_hash->{'-top_language'}         = 'SystemVerilog';
   open (TCL_FILE, "<$tcl_file_name") || ef_lib::mydie ("ERR : Could not open .tcl file $tcl_file_name\n", $main::log);
   while (<TCL_FILE>){
      my $line = $_;
      chomp $line;
      if ($line=~ /^\s*(-\S+)\s+\\$/){
         $line =~ s/^\s*(-\S+)\s+\\$/$1/; #"       -sv"
         push(@{$tmp_lib_hash->{'-vlog_opts'}}, $line);
      }elsif  ($line=~ /^\s*\-incdir\s+(\S+)\s+\\$/){
         $line =~ s/^\s*\-incdir\s+(\S+)\s+\\$/$1/;     #"      -incdir /nfs/fm/disks/fm_sptlp_00078/rmeessen/project/eff_demo/eff_demo_20140415/2.01.17/project_2/release/ALL/Q20040609_0840/globalIncludes \"
         push(@{$tmp_lib_hash->{'-vlog_incdirs'}}, $line);
      }elsif  ($line=~ /^\s*\-libext\s(\S+)\s+\\$/){
         $line =~ s/^\s*\-libext\s(\S+)\s+\\$/$1/;#"      -libext .vs \"
         $line = "+libext+".$line;
         push(@{$tmp_lib_hash->{'-vlog_opts'}}, $line);
      }elsif  ($line=~ /^\s*\-work\s.*/){
         $line =~ s/^\s*\-work\s(\S+)\s+\\$/$1/;#"      -work fp_unit_lib \"
         $lib_name = $line;
      }elsif  ($line=~ /^\s*\-v\s+\S+\s+\\$/){
         $line =~ s/^\s*\-v\s+(\S+)\s+\\$/$1/;     #
         push(@{$tmp_lib_hash->{'-vlog_lib_files'}}, $line);
      }elsif  ($line=~ /^^\s*\-y\s+(\S+)\s+\\$/){
         $line =~ s/^\s*\-y\s+(\S+)\s+\\$/$1/;     #"      -y /nfs/fm/disks/fm_sptlp_00078/rmeessen/project/eff_demo/eff_demo_20140415/2.01.17/project_2/release/ALL/Q20040609_0840/units/mult_56/src/ \"
         push(@{$tmp_lib_hash->{'-vlog_lib_dirs'}}, $line);
      }elsif  ($line=~ /^\s*\-define\s+(\S+)\s+\\$/){
         $line =~ s/^\s*\-define\s+(\S+)\s+\\$/$1/;     #"      -define zerounitdelay \"
         $line = "+define+".$line;
         push(@{$tmp_lib_hash->{'-vlog_opts'}}, $line);
      }elsif ($line=~ /^\s*(\/\S+)\s+\\$/){
         $line =~ s/^\s*(\S+)\s+\\$/$1/; #"       /nfs/fm/disks/fm_sptlp_00078/rmeessen/project/eff_demo/eff_demo_20140415/2.01.17/project_2/release/ALL/Q20040609_0840/ip/memory32/src/verilog/memory32.v \"
         push(@{$tmp_lib_hash->{'-vhdl_files'}}, $line);
      }
   }
   close(TCL_FILE);
   if (defined($lib_name)==1){
      push(@{$dump{'-entities_order'}},$lib_name); 
      $dump{$lib_name} = $tmp_lib_hash;
   }else{
      ef_lib::printl("LOG : \t No lib found.\n",$main::log);
   }
}

# sub Load_vlog_f_file($){
#    my $f_file_name = shift;
#    my $lib_name = $f_file_name;
#    $lib_name =~ s/(.*)_vlog.f/$1/;
#    push(@{$dump{'-entities_order'}},$lib_name); 
#    ef_lib::printl("LOG : \t $f_file_name.\n",$main::log);
#    my $tmp_lib_hash= {};
#    Init_lib_hash($tmp_lib_hash);
#    $tmp_lib_hash->{'-top_language'}         = 'SystemVerilog';
#    my $F_name = $analyzed_dir."/".$f_file_name;
#    open (F_FILE, "<$F_name") || ef_lib::mydie ("ERR : Could not open .f file $F_name\n", $main::log);
#    while (<F_FILE>){
#       my $line = $_;
#       chomp $line;
#       if ($line=~ /^\/.+/){
#          push(@{$tmp_lib_hash->{'-vlog_files'}}, $line);
#       }elsif  ($line=~ /^\+incdir.*/){
#          push(@{$tmp_lib_hash->{'-vlog_incdirs'}}, $line);
#       }elsif  ($line=~ /^\-v.*/){
#          push(@{$tmp_lib_hash->{'-vlog_lib_files'}}, $line);
#       }elsif  ($line=~ /^\-y.*/){
#          push(@{$tmp_lib_hash->{'-vlog_lib_dirs'}}, $line);
#       }elsif  ($line=~ /^\+define.*/){
#          push(@{$tmp_lib_hash->{'-vlog_opts'}}, $line);
#       }
#    }
#    close(F_FILE);
#    $dump{$lib_name} = $tmp_lib_hash;
# }

# sub Load_vhdl_f_file($){
#    my $f_file_name = shift;
#    my $lib_name = $f_file_name;
#    $lib_name =~ s/(.*)_vhdl.f/$1/;
#    push(@{$dump{'-entities_order'}},$lib_name); 
#    ef_lib::printl("LOG : \t $f_file_name.\n",$main::log);
#    my %tmp_lib_hash;
#    Init_lib_hash(\%tmp_lib_hash);
#    $tmp_lib_hash->{'-top_language'}         = 'vhdl';
#    my $F_name = $analyzed_dir."/".$f_file_name;
#    open (F_FILE, "<$F_name") || ef_lib::mydie ("ERR : Could not open .f file $F_name\n", $main::log);
#    close(F_FILE);
#    $dump{$lib_name} = \%tmp_lib_hash;
# }

Populate_dummy_METADATA();



my $src_filename = "rtl_source.tcl";
open (SRC_FILE, "< $src_filename") || ef_lib::mydie ("ERR : Could not open source file list  $src_filename\n", $main::log);
while (<SRC_FILE>){
   my $line = $_;
   chomp $line;
   $line =~ s/^source\s*(.*)/$1/;
   if (-e $line){
      if ($line=~ /.*.vlog.tcl/){
          Load_vlog_tcl_file($line);
      }elsif ($line=~ /.*.vhdl.tcl/){
          Load_vhdl_tcl_file($line);
      }else{
      ef_lib::printl("LOG : \tsource file non vhdl/vlog : $line.\n",$main::log);
      }
   }else{
      ef_lib::printl("ERR : \tsource file not found : $line.\n",$main::log);
   }


}
close(SRC_FILE);

&fpga_flow::dump_hash("dump", \%dump, $metadata_file);

ef_lib::printl("LOG : DONE\n",$main::log);