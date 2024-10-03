#!/usr/intel/pkgs/perl/5.8.7/bin/perl
use strict;
use FileHandle;
use Data::Dumper;

my $struct_file = "";
my $output_file = "output.list";
my $format = "synthesis";
my $curcmd = "";
my $print_only = 0;
my $run_ace = 0;
my $ace_filter = "";
my $quiet = 0;
my $toolname = "get_filelist.pl";
my $ace_model = "";
my $ace_network = "";
my $debug = 0;

foreach my $cmd (@ARGV) {
   if( $cmd =~ /-struct_file/ ) {
      $curcmd = "struct_file";
   } elsif( $cmd =~ /-output_file/ ) {
      $curcmd = "output_file";
   } elsif( $cmd =~ /-format/ ) {
      $curcmd = "format";
   } elsif( $cmd =~ /-print_only/ ) {
      $print_only = 1;
   } elsif( $cmd =~ /-run_ace/ ) {
      $run_ace = 1;
   } elsif( $cmd =~ /-ace_filter/ ) {
      $curcmd = "ace_filter";
   } elsif( $cmd =~ /-ace_model/ ) {
      $curcmd = "ace_model";
   } elsif( $cmd =~ /-ace_network/ ) {
      $curcmd = "ace_network";
   } elsif( $cmd =~ /-quiet/ ) {
      $quiet = 1;
   } elsif( $cmd =~ /-debug/ ) {
      $debug = 1;
   } else {
      if( $curcmd =~ /struct_file/ ) {
         $struct_file = $cmd;
         $curcmd = "";
      } elsif( $curcmd =~ /output_file/ ) {
         $output_file = $cmd;
         $curcmd = "";
      } elsif( $curcmd =~ /format/ ) {
         $format = $cmd;
         $curcmd = "";
      } elsif( $curcmd =~ /ace_filter/ ) {
         $ace_filter = "-filter $cmd";
         $curcmd = "";
      } elsif( $curcmd =~ /ace_model/ ) {
         $ace_model = $cmd;
         $curcmd = "";
      } elsif( $curcmd =~ /ace_network/ ) {
         $ace_network = "-m $cmd";
         $curcmd = "";
      } else {
         print( "$toolname -W- Current command unknown " . $cmd . "\n" ) if( !$quiet );
      }
   }
}

if( $format =~ /syn/ ) {
   print( "$toolname -I- Targeted format is for synthesis.\n" ) if( !$quiet );
   $format = "syn";
   if( $ace_filter eq "" ) {
      $ace_filter = "-filter Synthesis";
   }
} elsif( $format =~ /cdc/ ) {
   print( "$toolname -I- Targeted format is for CDC.\n" ) if( !$quiet );
   $format = "cdc";
} elsif( $format =~ /lint/ ||
         $format =~ /lintra/ ) {
   $format = "lint";
} elsif( $format =~ /lec/ ||
         $format =~ /fev/ ||
         $format =~ /fv/ ) {
   $format = "lec";
   if( $ace_filter eq "" ) {
      $ace_filter = "-filter FV";
   }
} elsif( $format =~ /spyglass/ ||
         $format =~ /spyglassdft/ ||
         $format =~ /spyglasslp/ ) {
   $format = "spyglass";
} else {
   print( "$toolname -E- -format is referencing an unknown format.\n" );
   exit( 1 );
}

if( $run_ace == 1 ) {
   if( $ace_model eq "" ) {
      print( "$toolname -E- -ace_model is a required field when using -run_ace\n" );
      exit( 1 );
   }
   my $prefix = "${format}_${ace_model}";
   my @capture_ace = `ace -dump_rtl -dump_rtl_entity ${ace_model} -nouse_timestamp -filelist_name_prefix ${prefix} ${ace_network} ${ace_filter}`;
   my $ace_okay = 0;

   foreach my $line (@capture_ace) {
      if( $line =~ /===> Dumping RTL file list for ${ace_model} at '(.*)'/ ) {
         $struct_file = $1;
         $ace_okay = 1;
      }
   }

   if( $ace_okay == 0 ) {
      print( "$toolname -E- Ace failed to run dump_rtl for:\n" );
      print( " model:   ${ace_model}\n" );
      print( " network: ${ace_network}\n" );
      print( " filter:  ${ace_filter}\n" );
      print( join "", @capture_ace );
      exit( 1 );
   }
}

my %dump;

my $fh = new FileHandle($struct_file);
if (defined $fh) {
   my @contents = <$fh>;
   my $lines = join "", @contents;
   eval $lines;
   $fh->close();
} else {
   die "$toolname -E- Could not open file '$struct_file': $!";
}

#print Dumper( %dump );
#exit( 1 );

my @master_vlog_files   = ();
my @master_vlog_incdirs = ();
my @master_vlog_libdirs = ();
my @top_libs;
if( defined( $dump{'-entities_order'} ) ) {
   @top_libs = @{$dump{'-entities_order'}};
}

foreach my $top_lib (@top_libs) {
   debug_print( "top_lib: $top_lib" );
   get_lib_info( $top_lib, $dump{$top_lib} );
}


if( $print_only ) {
   *OP = *STDOUT;
} else {
   open( OP, ">${output_file}" ) or die "$toolname -E- Can't open file: $!";
}

if( $format =~ /syn/ ) {
   print( OP                               "global env\n\n" );
   print_from_list( \@master_vlog_files,   "lappend VERILOG_SOURCE_FILES \"<INSERTHERE>\"\n" );
   print_from_list( \@master_vlog_incdirs, "lappend search_path \"<INSERTHERE>\"\n" );
   print( OP                               "\n" );
} elsif( $format =~ /lec/ ) {
   print_from_list( \@master_vlog_files,   "<INSERTHERE>\n" );
   print_from_list( \@master_vlog_incdirs, "+incdir+<INSERTHERE>\n" );
   print_from_list( \@master_vlog_libdirs, "+libdir+<INSERTHERE>\n" );
} elsif( $format =~ /lint/ ) {
   print_from_list( \@master_vlog_files,   "<INSERTHERE>\n" );
   print_from_list( \@master_vlog_incdirs, "+incdir+<INSERTHERE>\n" );
   print_from_list( \@master_vlog_libdirs, "+libdir+<INSERTHERE>\n" );
} elsif( $format =~ /cdc/ ) {
   print_from_list( \@master_vlog_files,   "<INSERTHERE>\n" );
   print_from_list( \@master_vlog_incdirs, "+incdir+<INSERTHERE>\n" );
   print_from_list( \@master_vlog_libdirs, "+libdir+<INSERTHERE>\n" );
} elsif( $format =~ /spyglass/ ) {
   print_from_list( \@master_vlog_files,   "<INSERTHERE>\n" );
   print_from_list( \@master_vlog_incdirs, "+incdir+<INSERTHERE>\n" );
   print_from_list( \@master_vlog_libdirs, "+libdir+<INSERTHERE>\n" );
} else {
   print( "$toolname -E- Unknown format type\n" );
   exit( 1 );
}

if( !$print_only ) {
   close( OP );
}

exit( 0 );

sub print_from_list {
   my $array_ref = shift;
   my $format = shift;

   foreach my $file (@{$array_ref}) {
      my $final = $format;
      if( $final =~ s/<INSERTHERE>/$file/ ) {
         print( OP "$final" );
      }
   }
}

sub debug_print {
   my $string = shift( @_ );

   print( "$toolname -D- $string\n" ) if( $debug );
}

sub get_lib_info {
   my $top_lib      = shift( @_ );
   my $top_hash_ref = shift( @_ );

# Get each VLOG file list from the sub library
   foreach my $vlog_type ( ('-vlog_files', '-sverilog_files') ) {
      my @vlog_files = @{ $top_hash_ref->{$vlog_type} } if( defined( $top_hash_ref->{$vlog_type} ) );
      foreach my $vlog_file (@vlog_files) {
         my $pass_file = 1;

         if ($format =~ /syn/) {
            $vlog_file =~ s/^\s*$ENV{IP_ROOT}/\$::env\(IP_ROOT\)/;
         } else {
            $vlog_file =~ s/^\s*$ENV{IP_ROOT}/\$\{IP_ROOT\}/;
         }

         # VCS is so sensitive it will not pull in the file if it sees the "//" that ace occasionally inserts
         $vlog_file =~ s/\/\//\//g;

         if ($vlog_file =~ m/\/ace\// ) { # Don't want anything from the ace directory
            $pass_file = 0;
         }

         # If some valid reason for ignoring files, this is the place to do it.
         if( $pass_file ) {
            debug_print( "vlog_file: $vlog_file" );
            push( @master_vlog_files, $vlog_file );
         }
      }
   }

# Get each VLOG dir list from the sub library
   foreach my $vlog_type ( ('-vlog_incdirs') ) {
      my @vlog_incdirs = @{ $top_hash_ref->{$vlog_type} } if( defined( $top_hash_ref->{$vlog_type} ) );
      foreach my $vlog_dir (@vlog_incdirs) {
         my $pass_dir = 1;

         if ($format =~ /syn/) {
            $vlog_dir =~ s/^\s*$ENV{IP_ROOT}/\$::env\(IP_ROOT\)/;
         } else {
            $vlog_dir =~ s/^\s*$ENV{IP_ROOT}/\$\{IP_ROOT\}/;
         }

         if ($vlog_dir =~ m/\/ace\// ) { # Don't want anything from the ace directory
            $pass_dir = 0;
         }

         # IF some valid reason for ignoring dirs, this is the place to do it.
         if( $pass_dir ) {
            debug_print( "vlog_incdir: $vlog_dir" );
            push( @master_vlog_incdirs, $vlog_dir );
         }
      }
   }

   foreach my $vlog_type ( ('-vlog_lib_dirs') ) {
      my @vlog_lib_dirs = @{ $top_hash_ref->{$vlog_type} } if( defined( $top_hash_ref->{$vlog_type} ) );
      foreach my $vlog_dir (@vlog_lib_dirs) {
         my $pass_dir = 1;

         if ($format =~ /syn/) {
            $vlog_dir =~ s/^\s*$ENV{IP_ROOT}/\$::env\(IP_ROOT\)/;
         } else {
            $vlog_dir =~ s/^\s*$ENV{IP_ROOT}/\$\{IP_ROOT\}/;
         }

         if ($vlog_dir =~ m/\/ace\// ) { # Don't want anything from the ace directory
            $pass_dir = 0;
         }

         # IF some valid reason for ignoring dirs, this is the place to do it.
         if( $pass_dir ) {
            debug_print( "vlog_libdir: $vlog_dir" );
            push( @master_vlog_libdirs, $vlog_dir );
         }
      }
   }

   foreach my $sub_type ( ('-sub_libs') ) {
      my @sublibs = @{ $top_hash_ref->{$sub_type} } if( defined( $top_hash_ref->{$sub_type} ) );
      foreach my $sublib (@sublibs) {
         debug_print( "sublib: $sublib" );
         get_lib_info( $top_lib, $dump{$top_lib}{'-sub_lib_hash'}{$sublib} );
      }
   }
}
