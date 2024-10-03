#-*-perl-*-
#--------------------------------------------------------------------------------

package common::AssertionManager;
use strict;
use FileHandle;
require "dumpvar.pl";
use Utilities::System qw(Exit);
use File::Basename;

use lib "$ENV{IP_ROOT}/cfg/ace/lib/common";
use vars qw(@ISA @EXPORT_OK);
use Ace::GenericScrag qw($CWD add_cmd);
use common qw(get_ww);
use Data::Dumper;

require Exporter;
@ISA = qw(Exporter Ace::WorkModules::ProtoNI);

use vars qw(%params);

#-------------------------------------------------------------------------------
# MEMBER Functions
#
#
#--------------------------------------------------------------------------------
sub new {
  my ($class, %args) = @_;

  my $self = $class->SUPER::new(%args);


  return $self;
}
#-------------------------------------------------------------------------------
sub create_scrag {
  my ($self, %args) = @_;
 $_ = $args{-name};
 SWITCH: {
    /^exec_test/ && do { return $self->_run_assertion_flow(%args); };
    $self->_unknown_ace_command_error($_);
  }
}

#-------------------------------------------------------------------------------
sub _run_assertion_flow {

    my ($self, %args) = @_;
    my $test_data   = $args{-test_data};
    my ($cur_scope, $top_scope, $base_scope) = ($args{-cur_scope}, $args{-top_scope}, Ace::UDF::get_base_scope());

    my $testrun_path      = $test_data->{$base_scope}{top_testrun_dir};
    my $simple_testname = $self->get_option(-test);
    $simple_testname    = basename $simple_testname;
    my $seed = $args{-merged_test_opts}->{NON_SCOPED}{-seed};
    my $ww = get_ww();
    my $model = $ENV{ACE_PWA_DIR};
    my $cfg = $self->get_option(-cfg);
    my $tid = $test_data->{$base_scope}{tid} . "_seed_" . $seed;

    my $fragment;

    ## Processing to check if the IP_ROOT is from release model.

    my $released_model;

    my $model_root = dirname($ENV{IP_ROOT});
    my $model_path = $ENV{IP_ROOT};
    my $model_path2 = $ENV{IP_ROOT};
    $model_path2 =~ s/$model_root//;
    $model_root = dirname($model_root);
    $model_path =~ s/$model_root//;

    use Cwd 'abs_path';

    # TODO: Requires adjusting for our CSME SIP directory structure.
    if (-d "/p/$ENV{PROJECT}/val/release/$model_path" or -d "/p/$ENV{PROJECT}/val/release/$ENV{ACE_PROJECT}/${model_path2}") {
        if ((abs_path($ENV{IP_ROOT}) eq abs_path("/p/$ENV{PROJECT}/val/release/$model_path")) or
            (abs_path($ENV{IP_ROOT}) eq abs_path("/p/$ENV{PROJECT}/val/release/${ENV{ACE_PROJECT}}/${model_path2}")) or
            (abs_path($ENV{IP_ROOT}) =~ /\/netbatch\/cama\//)    ## new condition to accommodate to CaMa usage
        ) {
            $released_model = 1;
        }
        else {
            $released_model = 0;
        }
    }
    else {
        $released_model = 0;
    }

    my $home_site = $self->get_option(-home_site);
    my $sync_server = "rsync.${home_site}.intel.com";
    if ($home_site eq "fm") {
        $sync_server = "fmyrrsync.fm.intel.com"; ## ylai4 - FM has different setup for high capacity rsync server
    }

    # special handling for HD site rsync server, available server : hdyrsync01.hd.intel.com  or hdyrsync02.hd.intel.com
    # this special handling is disabled as rsync.hd.intel.com is brought back
    #if ($home_site eq "hd") {
    #    $sync_server = "hdyrsync01.hd.intel.com";
    #}

    $fragment .= "\necho \"rsync server set to $sync_server.\"\n";

    my $env_name = $ENV{ACE_PROJECT};
    my $ace_model = $self->get_option('-model');
    my $tim_mode = $self->get_option(-test_in_model);
    my $elab_vdb_name = "${ace_model}.simv.vdb";
    my $elab_vdb = "$ENV{IP_ROOT}/target/${env_name}/vcs_lib/$ENV{VCS_VER}/models/${ace_model}/$elab_vdb_name";
    $elab_vdb = "" if (! $tim_mode);

    # The following three lines of comments were here previously, left untouched for further research.
    #if ($self->get_option(-generate_assertion_reports)) {
    # This checking is removed, it is expected the assertion report always being generated.
    # The duplication scripts in runsim_postsim_checks.pl is removed. This will be the only code to maintain.
    if ($self->get_option(-verif_data_mgmt) || $self->get_option(-generate_assertion_reports)) {
        $fragment .= common::create_find_cdb_scrag(-cdb_ivar => $self->get_option(-coverage_database), -cmdline_switch => '-dir', -extension => 'vdb');
        my $call_to_format = "&FormatAssnReport(-rpt_dir => \"urgReport\", -rpt => \"asserts.txt\", -outdir => \"$testrun_path/sv_asn\", -outfile => \"$simple_testname.asnrpt\", -zipout => 1, -rmindir => 1, -testname  => \"$simple_testname\" )";
        $fragment .=<<EOF;

# --------------------------------
# Format assertions report from VM
# --------------------------------
if [ "\$cdb_switch" ] ; then
  echo "AssertionManager: Invoking 'urg' to gather coverage data (functional and code-coverage):"
  echo urg -format both -metric line+cond+fsm+branch+tgl+assert -dir $elab_vdb \$cdb_switch
  urg -format both -metric line+cond+fsm+branch+tgl+assert -dir $elab_vdb \$cdb_switch
  checkrc ASRT_URG 0
  perl -I\$IP_ROOT/ace/lib/common -e 'use common; $call_to_format'
  checkrc ASRT_RPT 0
else
  echo "No coverage databases found"
fi

EOF


        # 53577 is result returned for lptgk
        if ($self->get_option(-assertion_copy_back) and $released_model) {
            my $tmp_dir = $testrun_path . "/assertion/$ww/$model/$cfg/$tid";
            my $sync_path = $self->get_option(-assertion_dir);

            $fragment .=<<EOF;

# ------------------------------------------
# Copy assertion report to permanent storage
# ------------------------------------------
if [ -d "$testrun_path/sv_asn" ] ; then
    if [ ! -d "$tmp_dir" ] ; then
        mkdir -p $tmp_dir
        chmod -Rf 770 $testrun_path/assertion/$ww
    fi
    /bin/cp $testrun_path/sv_asn/* $tmp_dir
    rsync -avutH --progress $testrun_path/assertion/$ww \$USER\@$sync_server:$sync_path
    rm -rf $testrun_path/assertion
else
    echo "No sv_asn directory detected. Copy back disabled. "
fi

EOF
        }
    }


    return $fragment;
}

#-------------------------------------------------------------------------------

1;

