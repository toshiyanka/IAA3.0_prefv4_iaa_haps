#!/usr/intel/pkgs/perl/5.26.1/bin/perl

package H2bConstants;

use warnings;
use Exporter 'import';
use Const::Fast;
use lib "/p/dt/sde/tools/em64t_SLES11/perl_coverage/load_cover";
use load_cover;

our %EXPORT_TAGS = (
    'dcconst' => [
        qw (
          $DEFAULT_CONFIG
          $DC_RUN_DIRECT
          $DC_ELAB_CMD
          $ANALYZE_CMD
          $COMPILE_LOG
          $LINK_LOG
          $DC_COMPILE_DIRECT
          $DC_COMPILE_PASS_FILE
          $DC_COMPILE_MAP_FILE
          $DC_MODIFIED_FILE_DIR
          $DC_MODIFIED_FILE
          $DC_CHECK_TIMING_BEFORE_SYNTH_FILE
          $DC_CHECK_TIMING_AFTER_SYNTH_FILE
          $DC_DESIGN_CLOCK
          $DC_TIMING_RPT
          $DC_QOR_RPT
          $DC_ELAB_NET
          $DC_NETLIST
          $DC_LIC
          $DC_TIME_MEM
          $DEF_CFG
          )
    ],
);

our @EXPORT_OK = qw (
  $DEFAULT_CONFIG
  $DC_RUN_DIRECT
  $DC_ELAB_CMD
  $ANALYZE_CMD
  $COMPILE_LOG
  $LINK_LOG
  $DC_COMPILE_DIRECT
  $DC_COMPILE_PASS_FILE
  $DC_COMPILE_MAP_FILE
  $DC_MODIFIED_FILE_DIR
  $DC_MODIFIED_FILE
  $DC_CHECK_TIMING_BEFORE_SYNTH_FILE
  $DC_CHECK_TIMING_AFTER_SYNTH_FILE
  $DC_DESIGN_CLOCK
  $DC_TIMING_RPT
  $DC_QOR_RPT
  $DC_ELAB_NET
  $DC_NETLIST
  $DC_LIC
  $DC_TIME_MEM
  $DEF_CFG
);

const our $DEFAULT_CONFIG                    => "design_pkg.cfg";
const our $DC_RUN_DIRECT                     => "dc_run";
const our $DC_COMPILE_DIRECT                 => "dc_compile";
const our $DC_ELAB_CMD                       => "dc_elab_cmd";
const our $ANALYZE_CMD                       => "analyze_cmd";
const our $COMPILE_LOG                       => "compile.log";
const our $LINK_LOG                          => "link.log";
const our $DC_COMPILE_PASS_FILE              => "dc_compile.PASS";
const our $DC_COMPILE_MAP_FILE               => "compile.map";
const our $DC_MODIFIED_FILE_DIR              => "modified_file_dir";
const our $DC_MODIFIED_FILE                  => "modified.f";
const our $DC_CHECK_TIMING_BEFORE_SYNTH_FILE => "check_timing_before_synth.rpt";
const our $DC_CHECK_TIMING_AFTER_SYNTH_FILE  => "check_timing_after_synth.rpt";
const our $DC_DESIGN_CLOCK                   => "design.clock.rpt";
const our $DC_TIMING_RPT                     => "timing.rpt";
const our $DC_QOR_RPT                        => "qor.rpt";
const our $DC_ELAB_NET                       => "elab.v";
const our $DC_NETLIST                        => "_synth.v";
const our $DC_LIC                            => "synopsys/dc";
const our $DC_TIME_MEM                       => "timem.tcl";
const our $DEF_CFG                           => "def-cfg";
1;
