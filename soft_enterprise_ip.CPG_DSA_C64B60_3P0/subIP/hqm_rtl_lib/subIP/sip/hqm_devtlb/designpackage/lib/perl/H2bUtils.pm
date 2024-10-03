package H2bUtils;

BEGIN {
    push( @INC,
        $ENV{RTL_UTIL_ROOT}, $ENV{RTL_UTIL_ROOT} . "/" . "lib" . "/" . "perl",
        $ENV{FLOW_ROOT},     $ENV{FLOW_ROOT} . "/" . "lib" . "/" . "perl" );
}

use Exporter 'import';
use Cwd 'abs_path';
use Data::Dumper;

#use JSON::Parse 'parse_json';
use File::Slurp qw(read_file);
use File::Spec;
use lib "/p/dt/sde/tools/em64t_SLES11/perl_coverage/load_cover";
use load_cover;
use JSON qw(decode_json);
use JSON::Parse 'json_file_to_perl';
use Config::IniFiles;
use Logger;
use File::Spec::Functions qw(catfile);
use Compress::Zlib;
use H2bConstants qw(:dcconst);
use Constants qw(:genfile :common);
use File::Path qw(make_path);
use File::Basename;
use File::Basename qw(basename dirname);
use CthRTLUtils;
use ConfigParser;
use FilelistReader;
use Verilog::Language qw(strip_comments);
use File::Slurper qw(read_text);

use strict;
use warnings;
use H2bConstants qw(:dcconst);

our @EXPORT_OK =
  qw(create_symlink clean_symlinks createH2BLog );

##############################################################################
# Sub:        create Log
# Info:       converts json file into perl hash
##############################################################################

sub createH2BLog {
    my $logname = shift;
    my $defaultConfigFile =
      $ENV{FLOW_ROOT} . "/defaults/" . "design_pkg.cfg";
    my $configHash = parseConfigFile( $defaultConfigFile, $ARGV[1] );
    ConfigParser::validateUserConfigOptions();
    if ( $configHash->{OUTPUT_DIR_OVERRIDE} ) {
        $configHash->{OUTPUT_DIR} =
          "$configHash->{OUTPUT_DIR_OVERRIDE}/designpackage";

    }

    if ( $configHash->{VCS_CONFIG_XML} ) {
        $configHash->{XML_FILE} = "$configHash->{VCS_CONFIG_XML}";
    }

    my $pass    = $configHash->{PASS};
    my $logName = shift;
    my $logDir;
    my $block;
    $block  = "$configHash->{TOP_MODULE}";
    $logDir = "$configHash->{OUTPUT_DIR}/$pass/log";

    make_path $logDir;
    $logDir = abs_path($logDir);
    my $log = "$logDir/$block.$logname.log";
    openLogFile($log);
    return $log;
} 

##############################################################################
# Sub:        create_symlink
# Info:       Creates symlink of the out output directory to the current working directory
##############################################################################
sub create_symlink {
    my $output_dir = shift;
    my $override   = shift;
    my $cwd        = `pwd`;
    chomp($cwd);
    if ( abs_path($override) ne abs_path($cwd) ) {
        if ( -e "$cwd/output" ) {
            `rm -rf $cwd/output`;

        }

        my $cwd_op_dir = "$cwd/output";
        my $status     = system("ln -s $output_dir $cwd_op_dir");
        if ($status) {
            error "Error creating in softlink of $output_dir";
        }
        else {
            info "Softlink of $output_dir created successfully";
        }
    }
}

sub clean_symlinks {
    my $cwd = `pwd`;
    chomp($cwd);
    if ( -e "$cwd/output" ) {
        `rm -rf $cwd/output`;

    }
}

