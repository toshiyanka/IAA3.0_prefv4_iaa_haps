#-*-perl-*-
#--------------------------------------------------------------------------------

package common::VerificationManager;
use strict;
require "dumpvar.pl";

use Utilities::System qw(Exit);
use Data::Dumper;
use File::Basename;

use vars qw(@ISA);
use Ace::GenericScrag qw(add_cmd);
use common qw(get_ww);

require Exporter;
@ISA = qw(Exporter Ace::WorkModules::ProtoNI);

#--------------------------------------------------------------------------------
sub new {
  my ($class, %args) = @_;
  my $self = $class->SUPER::new(%args);
  return $self;
}
#-------------------------------------------------------------------------------


sub create_scrag {
  my ($self, %args) = @_;
  my ($cur_scope, $top_scope, $base_scope) = ($args{-cur_scope}, $args{-top_scope}, Ace::UDF::get_base_scope());
  my $seed = $args{-merged_test_opts}->{NON_SCOPED}{-seed};
  my $test_data     = $args{-test_data};
  my $log_file          = $test_data->{$base_scope}{logfile};
  my $workdir       = $test_data->{$base_scope}{workdir};
  my $testrun_path      = $test_data->{$base_scope}{top_testrun_dir};
  my $path_to_pcov      = $testrun_path;
  my $fragment;

  my $simple_testname = $self->get_option(-test);
  $simple_testname  = basename $simple_testname;

  my $pcov_name = $test_data->{$base_scope}{stid} . "_seed_" . $seed;
  my $ww = get_ww();
  my $model = $ENV{ACE_PWA_DIR};
  my $cfg = $self->get_option(-cfg);
  my $tid = $test_data->{$base_scope}{stid} . "_seed_" . $seed;

  my $home_site = $self->get_option(-home_site);
  my $testsrc_dir = $args{-merged_test_opts}->{$ENV{ACE_PROJECT}}{-test};

  # pcov generation

  my $env_name = $ENV{ACE_PROJECT};
  my $ace_model = $self->get_option('-model');

  my $model_compile_results_dir = $self->get_option(-model_compile_results_dir);
  my $tim_mode = $self->get_option(-test_in_model);

  my $elab_vdb_name = "${ace_model}.simv.vdb";
  my $elab_vdb = "$model_compile_results_dir/vcs_lib/$ENV{VCS_VER}/models/$ace_model/$elab_vdb_name";
  $elab_vdb = "" if (! $tim_mode);

  my $enable_svcov        = $self->get_option(-enable_svcov);
  my $vm_convert_coverage = $self->get_option(-vm_convert_coverage);
  my $verif_data_mgmt     = $self->get_option(-verif_data_mgmt);
  my $converter           = $self->get_option(-vm_sv2proto);


  if ($enable_svcov || $vm_convert_coverage || $verif_data_mgmt) {
    $fragment .= common::create_find_cdb_scrag(-cdb_ivar => $self->get_option(-coverage_database), -cmdline_switch => '', -extension => 'vdb');
    my $conv_opts = $self->get_array_option(-vm_cov_converter_opts, -convert2string=>1);
    $fragment .=<<EOF;


# --------------------------------
# Convert cov dbs into pcovs
# --------------------------------
if [ "\$cdb_switch" ] ; then
  echo "VerificationManager: Creating pcov file!"
  echo "$converter $conv_opts $pcov_name $elab_vdb \$cdb_switch"
  $converter $conv_opts $pcov_name $elab_vdb \$cdb_switch
  checkrc CONVERT_COVERAGE 0
  COV_CONV_STATUS='PASS'
else
  echo "VerificationManager: *** No coverage databases found!"
  COV_CONV_STATUS='NOT RUN'
fi

EOF

    # You may insert some checking code here that checks whether conversion passed or not (beyond whether
    # the converter returned successfully or not. E.g. is the pcov empty?)
    # The checking code must ultimately create a file, which contains a hash %updates. The %updates hash
    # will contain (key,value) pairs that will be written to postsim.log; any conflict with existing (key,value)
    # pair in postsim.log is resolved to the advantage of %updates.
    # Here is a sample shell code that creates such a file, called here sv_conversion_updates.log
    my $updates_log = 'sv_conversion_updates.log';
    $fragment .= "echo \"%updates = ('COVERAGE CONVERSION' => '\$COV_CONV_STATUS', 'STATUS SWITCH' => 'No')\" > $updates_log\n";
    # Call update_postsimlog with these parameters - note the name of the updates file is passed.
    $fragment .= $self->update_postsimlog(-cur_scope => $args{-cur_scope}, -log_updates_file => $updates_log, -process => 'coverage_conversion');
    # You may remove updates.log once done.
    $fragment .= "rm $updates_log\n";
  
    # end pcov generation
  
    $fragment .= "\nCWD=\$PWD\n";
    $fragment .= "cd $testrun_path\n";
  
  
    my $pmlog = $self->get_option(-postmortem_log);
    $pmlog =~ s/\.log$//;
    my $postsimlog        = $self->get_option(-postsim_log);
    $postsimlog =~ s#\.log$##;
  
    $fragment .=<<EOF;

# Getting test status

test_status=''
if [ -h ${pmlog}.pass ] ; then
  test_status=PASS
elif [ -h ${pmlog}.fail ] ; then
  test_status=FAIL
elif [ -h ${postsimlog}.pass ] ; then
  test_status=PASS
else
  test_status=FAIL
fi

EOF


#--------------------------------------------------------------------
# Processing to check if the MODEL_ROOT/IP_ROOT is from release model
#--------------------------------------------------------------------
    
    use Cwd 'abs_path';

    my $released_model;
    my $model_root;
    my $model_path;
    my $model_path2;
    my $model_abs_path;

    if(defined $ENV{IP_ROOT}) {
      $fragment .= "\necho \"IP_ROOT  = $ENV{IP_ROOT}\"\n";
      $model_root = dirname($ENV{IP_ROOT});
      $model_path = $ENV{IP_ROOT};
      $model_path2 = $ENV{IP_ROOT};
      $model_abs_path = abs_path($ENV{IP_ROOT});
    } else {
      $fragment .= "\necho \"MODEL_ROOT  = $ENV{MODEL_ROOT}\"\n";
      $model_root = dirname($ENV{MODEL_ROOT});
      $model_path = $ENV{MODEL_ROOT};
      $model_path2 = $ENV{MODEL_ROOT};
      $model_abs_path = abs_path($ENV{MODEL_ROOT});
    }

    $model_root = dirname($model_root);
    $model_path =~ s/$model_root//;
    $model_path2 =~ s/$model_root//;
    $model_path2 =~ s/^\///;    ## ylai4 - strip away trailing slashes if any
    $model_path2 =~ /^(\w+)-/;
    my $clt = $1;
    
    $fragment .= "\necho \"ACE_PROJECT = $ENV{ACE_PROJECT}\"\n";
    $fragment .= "\necho \"model_path  = $model_path\"\n";
    $fragment .= "\necho \"model_path2 = $model_path2\"\n";
    $fragment .= "\necho \"model_abs_path  = $model_abs_path\"\n";

    
    if (-d "/p/$ENV{PROJECT}/val/release/$model_path" or 
        -d "/p/$ENV{PROJECT}/val/release/$ENV{ACE_PROJECT}/${model_path2}" or 
        -d "/p/$ENV{PROJECT}/val/release/$clt/${model_path2}" or
        -d "/p/sip/proj/$ENV{ACE_PROJECT}/release/ip/$model_path" or
        -d "/p/sip/proj/$ENV{ACE_PROJECT}/release/ip/$model_path2") {
        if (($model_abs_path eq abs_path("/p/$ENV{PROJECT}/val/release/$model_path")) or
            ($model_abs_path eq abs_path("/p/$ENV{PROJECT}/val/release/$ENV{ACE_PROJECT}/${model_path2}")) or
            ($model_abs_path eq abs_path("/p/$ENV{PROJECT}/val/release/$clt/${model_path2}")) or		## ylai4 - to accommodate sub-clt e.g. sbi
            ($model_abs_path =~ /\/netbatch\/cama\//) or    ## new condition to accommodate to CaMa usage
            ($model_abs_path eq abs_path("/p/sip/proj/$ENV{ACE_PROJECT}/release/ip/$model_path")) or
            ($model_abs_path eq abs_path("/p/sip/proj/$ENV{ACE_PROJECT}/release/ip/$model_path2"))) 
        {
            $released_model = 1;
        }
        else {
            $released_model = 0;
        }
    }
    else {
        $released_model = 0;
    }
    

    $released_model = 1;   ## by passing the release model check



#-------------------------------------------------
# Checking for if the test ran in home site or not
#-------------------------------------------------  

    my $home_site = $self->get_option(-home_site);
    my $sync_server = "rsync.${home_site}.intel.com";
    if ($home_site eq "fm") {
        $sync_server = "fmyrrsync.fm.intel.com"; ## ylai4 - FM has different setup for high capacity rsync server
    }
    
    ## ylai4 - check if current machine matching with cluster home-site, if same then no need to go through rsync server, thus to reduce rsync server loads
    my $hostname = `/bin/hostname`; chomp($hostname);
    my $current_site = `/usr/intel/bin/sitecode`; chomp($current_site);
    ## end home_site checking
      
    $fragment .= "echo \"\nArchiving pcov file!\"\n";
    if ($current_site eq $home_site) {
        $fragment .= "\necho \"rsync server is not used as running on home_site ($hostname).\"\n";
    }
    else {
        $fragment .= "\necho \"rsync server set to $sync_server.\"\n";
    }

#------------------------------------
# Upload pcov file info into database    
#------------------------------------  

    if ($self->get_option(-vm_upload_test_data)) {
      if (!$released_model) {
          $fragment .= "\necho \"ERROR *** You are trying to collect coverage data running on non-released model.\n\tpcov file copy back is disabled!\n\"";
      }
      else {

        my $base_dir = $self->get_option(-vm_pcovdir);
        unless ($base_dir) {
          Exit 1, "-vm_pcovdir is not set properly\n";
        }

        my $tmp_dir = $testrun_path . "/$ww/$model/$cfg/$tid";
        my $dir = $base_dir . "/$ww/$model/$cfg/$tid";
        my $sync_path = $base_dir;

        $path_to_pcov = $dir;

        my $post_rsync_cmd = '';
        $post_rsync_cmd = "&& /bin/rm -f $testrun_path/$pcov_name.pcov.gz" if $self->get_option(-vm_pcov_cleanup);

        my $uploader = $self->find_executable($self->get_option(-vm_uploader_script), $cur_scope);
        unless (-x $uploader) {
          Exit 1, "You have requested -vm_upload_test_data, but did not provide a -vm_uploader_script.";
        }

        # the scrag creates a file, containing the test info
        # the uploading script reads that file, and uploads its contents to db, using the API

        my $sim_end_time;
        my $test_data_info_file = "tinfo_upload.txt";
        my $pcov_update = "${path_to_pcov}/${pcov_name}.pcov.gz";


        $fragment .=<<EOF;

# -------------------------------
# Copy pcov to permanent storage
# -------------------------------
if [ -f "$testrun_path/$pcov_name.pcov.gz" ] ; then
  if [ ! -d "$tmp_dir" ] ; then
    mkdir -p $tmp_dir
    chmod -Rf 770 $testrun_path/$ww
  fi
  /bin/cp $testrun_path/$pcov_name.pcov.gz $tmp_dir
  /usr/bin/touch $tmp_dir/\$test_status
EOF

## ylai4 - check if current machine matching with cluster home-site, if same then no need to go through rsync server, thus to reduce rsync server loads

        if ($current_site eq $home_site) {
          $fragment .= "echo \"cp -r $testrun_path/$ww $sync_path $post_rsync_cmd\"\n";
          $fragment .= "cp -r $testrun_path/$ww $sync_path $post_rsync_cmd\n";
        }
        else {
          $fragment .= "echo \"rsync -avutH --progress $testrun_path/$ww \$USER\@$sync_server:$sync_path $post_rsync_cmd\"\n";
          $fragment .= "rsync -avutH --progress $testrun_path/$ww \$USER\@$sync_server:$sync_path $post_rsync_cmd\n";

          ##dmeka to check if rsync is successful or not
          $fragment .= "\nstatus=\$?\n";
          $fragment .= "if [ \$status -eq 0 ];then\n";
          $fragment .= "  echo \"RSYNC Successful!\"\n";
          $fragment .= "else\n";
          $fragment .= "  echo \" *** ERROR: RSYNC not successful!\"\n";
          $fragment .= "exit 1\n";
          $fragment .= "fi\n";
          ## end of check


        }
## end home_site checking

        $fragment .=<<EOF;
  rm -rf $testrun_path/$ww

  # -----------------------------------------------------
  # Create file containing info for coverage upload to db
  # -----------------------------------------------------

  sim_end_time=`grep "^DATE" ${postsimlog}.log | sed 's/.*: //'`

  rm -f $test_data_info_file
  echo "test         = $testsrc_dir"    >> $test_data_info_file
  echo "ww           = $ww"             >> $test_data_info_file
  echo "model        = $model"          >> $test_data_info_file
  echo "cfg          = $cfg"            >> $test_data_info_file
  echo "path_to_pcov = $pcov_update"    >> $test_data_info_file
  echo "test_status  = \$test_status"   >> $test_data_info_file
  echo "sim_end_time = \$sim_end_time"  >> $test_data_info_file

  $uploader -test_data_file $test_data_info_file -home_site $home_site
  checkrc UPLOAD_TO_DB 0

else
  echo "No pcov file '$testrun_path/$pcov_name.pcov.gz' found! Unable to copy to coverage central area!\n "
fi

EOF
      }
    }
    $fragment .= "cd \$CWD\n";
  }
  return $fragment;
}

#-------------------------------------------------------------------------------
1;


