#!/usr/intel/pkgs/perl/5.26.1/bin/perl

if ( defined $ENV{RUN_COVERAGE} ) {
    use lib "/p/dt/sde/tools/em64t_SLES11/perl_coverage/load_cover";
    use load_cover;
}


package UPFCommon;

use strict;
use warnings;
use Logger;
use CthRTLUtils;
use Constants qw(:config);
use File::Basename;

sub runConfigTarget {
    my $user_cfg = shift;
    my $configHash = ConfigParser::parseConfigFile($ENV{FLOW_ROOT} . "/defaults/" . $ENV{FLOW} . ".cfg", $user_cfg);
    if ( ( defined $configHash->{UPF_UTILS_HOME_PATH} ) and
	 ( ( $configHash->{optionSource}->{UPF_UTILS_HOME_PATH} eq $DEF_CFG ) ) ) {
        my $upf_utils_path = &getInfraToolPath("UPF_UTILS_HOME_PATH");
        if (defined $upf_utils_path and $upf_utils_path !~ /^\s*$/) {
            $configHash->{UPF_UTILS_HOME_PATH} = $upf_utils_path;
            &info("UPF_UTILS_HOME_PATH $upf_utils_path picked from cheetah env.")
	}
    }
    if ( ( defined $configHash->{UPF_UTILS_VERSION} ) and
	 ( ( $configHash->{optionSource}->{UPF_UTILS_VERSION} eq $DEF_CFG ) ) ) {
        my $upf_utils_version = &getInfraToolVersion("UPF_UTILS_VERSION");
        if (defined $upf_utils_version and $upf_utils_version !~ /^\s*$/) {
            $configHash->{UPF_UTILS_VERSION} = $upf_utils_version;
            &info("UPF_UTILS_VERSION $upf_utils_version picked from cheetah env.")
	}
    }
    &validateUserConfigOptions($configHash);
    return $configHash;
}

sub validateUserConfigOptions {
    my $configHash = shift;
    foreach my $option (keys %{$configHash}) {
        if ($option eq "TOP") {
            if ( !defined $configHash->{$option} || $configHash->{$option} =~ /^\s*$/ ) {
		&error("The \'$option\' option must be defined.\n");
		exit(&getErrorCount());
            }
        }
        if ($option eq "PASS") {
            if ( !defined $configHash->{$option} || $configHash->{$option} =~ /^\s*$/ ) {
		&error("The \'$option\' option must be defined.\n");
		exit(&getErrorCount());
            }
        }
	if ($option eq "RUN_NETBATCH") {
            if ( defined $configHash->{$option} && !($configHash->{$option} eq "true" || $configHash->{$option} eq "false")) {
		&error("The \'$option\' option must be either true or false. Ignoring this value \'$configHash->{$option}\' and setting it to default false.\n");
		$configHash->{$option} = "false";
	    }
	}
	if ($option eq "CTH_QUIET_MODE") {
            if ( defined $configHash->{$option} && !($configHash->{$option} eq "true" || $configHash->{$option} eq "false")) {
		&error("The \'$option\' option must be either true or false. Ignoring this value \'$configHash->{$option}\' and setting it to default false.\n");
		$configHash->{$option} = "false";
	    }
	}
        if ($option eq "CTH_GK_MODE") {
            if ( defined $configHash->{$option} && !($configHash->{$option} eq "true" || $configHash->{$option} eq "false")) {
		&error("The \'$option\' option must be either true or false. Ignoring this value \'$configHash->{$option}\' and setting it to default false.\n");
		$configHash->{$option} = "false";
	    }
	}
	if ($option eq "COPY_CODEGEN_FILES") {
            if ( defined $configHash->{$option} && !($configHash->{$option} eq "true" || $configHash->{$option} eq "false")) {
		&error("The \'$option\' option must be either true or false. Ignoring this value \'$configHash->{$option}\' and setting it to default false.\n");
		$configHash->{$option} = "false";
	    }
	}
        if ($option eq "ENABLE_MULTIPLE_TOP") {
            if ( defined $configHash->{$option} && !($configHash->{$option} == 1 || $configHash->{$option} == 0)) {
               &error("The \'$option\' option must be either 1 or 0. Ignoring this value \'$configHash->{$option}\' and setting it to default 0.\n");
               $configHash->{$option} = "0";
           }
       }
    if ( ($option eq "UPF_UTILS_HOME_PATH") or ($option eq "UPF_UTILS_VERSION") ) {
        my $curToolPath = $configHash->{UPF_UTILS_HOME_PATH} . "/" . $configHash->{UPF_UTILS_VERSION};
        if ( !(-d $curToolPath ) ) {
		&error("Tool Path \'$curToolPath\'defined does not exist. Please check variable UPF_UTILS_HOME_PATH and UPF_UTILS_VERSION\n");
		exit(&getErrorCount());
        }
    }

    }
}

sub addSetup {
    my $fh = shift;
    my $configHash = shift;
    my $flow = shift;
    print $fh "setenv WORKAREA $ENV{WORKAREA} \n";
    my $output_dir = "";

    if ($configHash->{ENABLE_MULTIPLE_TOP} == 0) {
        $output_dir = $configHash->{OUTPUT_DIR} . "/" . $configHash->{PASS} . "/" . "$flow";
    }
    else {
        $output_dir = $configHash->{OUTPUT_DIR} . "/" . $configHash->{PASS} . "/" . $configHash->{TOP_MODULE} . "/" . "$flow";
    }
    print $fh "setenv OUTPUT_DIR ${output_dir}\n";
    print $fh "setenv PASS $configHash->{PASS}\n";
    print $fh "setenv TOP $configHash->{TOP}\n";
    print $fh "setenv TOP_MODULE $configHash->{TOP_MODULE}\n";
    print $fh "setenv DUT $configHash->{DUT}\n";
    print $fh "setenv UPF_UTILS_ROOT $configHash->{UPF_UTILS_HOME_PATH}/$configHash->{UPF_UTILS_VERSION}/\n";

    print $fh "setenv CTH_QUIET_MODE $configHash->{CTH_QUIET_MODE}\n";
    print $fh "setenv CTH_GK_MODE $configHash->{CTH_GK_MODE}\n";
    print $fh "/bin/mkdir -p \$OUTPUT_DIR\n";
}

sub addRunCommands {
    my $fh = shift;
    my $configHash = shift;
    my $flow = shift;
    my $output_dir = "";
    my $handoff_dir = "";
    my $UPFName = "";
    if ($configHash->{ENABLE_MULTIPLE_TOP} == 0) {
        $output_dir = $configHash->{OUTPUT_DIR} . "/" . $configHash->{PASS} . "/" . "$flow";
    }
    else {
        $output_dir = $configHash->{OUTPUT_DIR} . "/" . $configHash->{PASS} . "/" . $configHash->{TOP_MODULE} . "/" . "$flow";
    }

    ## LocalizeUPF
    my $user_args = "";
    if ($flow eq "LocalizeUPF") {
	my $localize_upf = "";
        my $localize_upf_cfg = "";

	if ( ( !defined($configHash->{UPF}) ) || ($configHash->{UPF} =~ /^\s*$/) ) {
            &error("UPF - $configHash->{UPF} is empty!! Please fix it and re-run.");
            exit(&getErrorCount());
	}
	$UPFName = (split '/', $configHash->{UPF})[-1];
	$UPFName = (split '\.', $UPFName)[0];
	if ( ( !defined($configHash->{LOCALIZE_UPF_CFG}) ) || ($configHash->{LOCALIZE_UPF_CFG} =~ /^\s*$/) ) {
            &error("LOCALIZE_UPF_CFG - $configHash->{LOCALIZE_UPF_CFG} is empty!! Please fix it and re-run.");
            exit(&getErrorCount());
	}
	if(lc($configHash->{DISABLE_PST_COMPARE}) eq "true") {
	    $user_args .= "-disable_pst_consistency ";
	}
	if(lc($configHash->{DISABLE_UNIQUIFICATION}) eq "true") {
	    $user_args .= "-disable_uniquification ";
	}
	if(lc($configHash->{INSPECT_LOCALIZED_UPF}) eq "true") {
	    $user_args .= "-inspect_localized_upf ";
	}
	if(lc($configHash->{DEBUG_LOCALIZE_UPF}) eq "true") {
	    $user_args .= "-debug ";
	}
	if(defined($configHash->{USE_GLOBAL_CONFIG}) and $configHash->{USE_GLOBAL_CONFIG} ne "") {
	    my $global_configs = $configHash->{USE_GLOBAL_CONFIG}; $global_configs =~ s/\,/ /g; $global_configs =~ s/\s+/ /g; $global_configs =~ s/^\s//; $global_configs =~ s/\s$//;
	    $user_args .= "-use_global_config \"$global_configs\" ";
	}
	$user_args =~ s/\s+$//;

	print $fh "\$UPF_UTILS_ROOT\/LocalizeUPF/localize_upf.pl -upf $configHash->{UPF} $user_args -localize_upf_config \$WORKAREA/integration/upf_utils/config/$configHash->{LOCALIZE_UPF_CFG} -destination \$OUTPUT_DIR\n";
	print $fh "echo \"Script Exit Status - \$status\"\n";
	print $fh "cat \$OUTPUT_DIR/localize_upf.log >> \$OUTPUT_DIR/${flow}.log\n";
	print $fh "cat \$OUTPUT_DIR/localize_upf.error_log >> \$OUTPUT_DIR/${flow}.log\n";
	print $fh "if \(-f \$OUTPUT_DIR/inspect_upf/${UPFName}_inspect_upf.log\) then\n  cat \$OUTPUT_DIR/inspect_upf/${UPFName}_inspect_upf.log >> \$OUTPUT_DIR/${flow}.log\nendif\n";
    } 
    elsif ($flow eq "InspectUPF") {
        if ( ( !defined($configHash->{UPF}) ) || ($configHash->{UPF} =~ /^\s*$/) ) {
            &error("UPF - $configHash->{UPF} is empty!! Please fix it and re-run.");
            exit(&getErrorCount());
	}
	$UPFName = (split '/', $configHash->{UPF})[-1];
	$UPFName = (split '\.', $UPFName)[0];
    	if ( ( !defined($configHash->{INSPECT_UPF_CFG}) ) || ($configHash->{INSPECT_UPF_CFG} =~ /^\s*$/) ) {
            &error("INSPECT_UPF_CFG - $configHash->{INSPECT_UPF_CFG} is empty!! Please fix it and re-run.");
            exit(&getErrorCount());
	}
	if(lc($configHash->{DISABLE_PST_COMPARE}) eq "true") {
	    $user_args .= "-disable_pst_consistency ";
	}
	if(lc($configHash->{DISABLE_FLAT_UPF}) eq "true") {
	    $user_args .= "-disable_flat ";
	}
	if(lc($configHash->{DISABLE_HTML}) eq "true") {
	    $user_args .= "-disable_html ";
	}
	if(lc($configHash->{DISABLE_NORMALIZE}) eq "true") {
	    $user_args .= "-disable_normalize ";
	}
	if(lc($configHash->{INSPECT_LOGFILE}) eq "true") {
	    $user_args .= "-logfile ";
	}
	$user_args =~ s/\s+$//;
	print $fh "mkdir -p \$OUTPUT_DIR/work/report\n";
	print $fh "mkdir -p \$OUTPUT_DIR/work/log\n";
	print $fh "cd \$OUTPUT_DIR/work/report\n";
	if(lc($configHash->{DEBUG_UPF}) eq "false") {
	    print $fh "unsetenv CHASSIS_UPF_DEBUG_MODE\n";
	} elsif (lc($configHash->{DEBUG_UPF}) eq "true") {
	    print $fh "setenv CHASSIS_UPF_DEBUG_MODE 1\n"
	}
	print $fh "\$UPF_UTILS_ROOT\/InspectUPF\/inspect.tcl -upf $configHash->{UPF} $user_args -verbose -config \$WORKAREA/integration/upf_utils/config/$configHash->{INSPECT_UPF_CFG}\n";
        print $fh "mv \$OUTPUT_DIR/work/report/${UPFName}_inspect_upf.log \$OUTPUT_DIR/work/log\n";
	print $fh "mv \$OUTPUT_DIR/work/report/${UPFName}_inspect_upf_error.log \$OUTPUT_DIR/work/log\n";
	print $fh "echo \"Script Exit Status - \$status\"\n";
    }
    elsif ($flow eq "MergeUPF") {
        my $merge_script = "";
    	if ( ( !defined($configHash->{MERGE_INPUT_DIR}) ) or ($configHash->{MERGE_INPUT_DIR} eq "") ) {
            &error("MERGE_INPUT_DIR - $configHash->{MERGE_INPUT_DIR} is empty!! Please provide the directories containing top_upf and rerun.");
            exit(&getErrorCount());
	} else {
            print $fh "setenv MERGE_INPUT_DIR $configHash->{MERGE_INPUT_DIR}\n";
	}
	if(lc($configHash->{DEBUG_UPF}) eq "false") {
	    print $fh "unsetenv CHASSIS_UPF_DEBUG_MODE\n";
	} elsif (lc($configHash->{DEBUG_UPF}) eq "true") {
	    print $fh "setenv CHASSIS_UPF_DEBUG_MODE 1\n"
	}
	if ( ( !defined($configHash->{MERGE_SCRIPT_NAME}) ) or ($configHash->{MERGE_SCRIPT_NAME} eq "") ) {
            &error("MERGE_SCRIPT_NAME - $configHash->{MERGE_SCRIPT_NAME} is empty!! Please point to valid merge_script_location, default is run_merge_upf.csh.");
            $merge_script = "run_merge_upf.csh";
	} else {
	    $merge_script = $configHash->{MERGE_SCRIPT_NAME};
	}
	print $fh "mkdir -p \$OUTPUT_DIR/work/log\n";
	print $fh "mkdir -p \$OUTPUT_DIR/work/report\n";
	print $fh "mkdir -p \$OUTPUT_DIR/gen/upf\n";
        print $fh "setenv CTH_MERGE_UPF_CENTRAL_LOG \$OUTPUT_DIR/MergeUPF.log\n";
	print $fh "cd \$OUTPUT_DIR/gen/upf\n";
	print $fh "\$WORKAREA/integration/upf_utils/scripts/$merge_script\n";
	print $fh "echo \"Script Exit Status - \$status\"\n";
    }
    elsif ($flow eq "ResolveUPFCommands") {
        my $rupc_dir = "";
	my $rupc_upf = "";
	my $vclp_user_args = "";
	if ( ( !defined($configHash->{UPF}) ) || ($configHash->{UPF} =~ /^\s*$/) ) {
            &error("UPF - $configHash->{UPF} is empty!! Please fix it and re-run.");
            exit(&getErrorCount());
	}

        ## Definition of arguments for localize and/or vclp
        if(defined($configHash->{TOP_MODULE}) and $configHash->{TOP_MODULE} ne "") {
          $user_args .= "TOP=$configHash->{TOP}:$configHash->{TOP_MODULE}";
	} else {
          $user_args .= "TOP=$configHash->{TOP}";
	}
	$user_args .= " DUT=$configHash->{DUT}";
        if(defined($configHash->{ENABLE_MULTIPLE_TOP}) and $configHash->{ENABLE_MULTIPLE_TOP} eq "1") {
	  $user_args .= " ENABLE_MULTIPLE_TOP=1";
	}
        $user_args .= " CTH_QUIET_MODE=$configHash->{CTH_QUIET_MODE}";
	$user_args .= " CTH_GK_MODE=$configHash->{CTH_GK_MODE}";

        ## Creation of directories on fly
	print $fh "mkdir -p \$OUTPUT_DIR/logs/RUPF_LocalizeUPF\n";
	print $fh "mkdir -p \$OUTPUT_DIR/logs/RUPF_vclp_run\n";
#	print $fh "mkdir -p \$OUTPUT_DIR/logs/RUPF_ResolveUPFCommands\n";
	print $fh "mkdir -p \$OUTPUT_DIR/Backup\n";
	print $fh "mkdir -p \$OUTPUT_DIR/Resolved_outputs\n";

        $rupc_upf = $configHash->{UPF};
	## Skip LocalizeUPF, ResolveUPFCommands consumes UPF and its directory
        if ( (lc($configHash->{RUPF_SKIP_LOCALIZE}) eq "true") ) {
          $rupc_dir = dirname($rupc_upf);
 	} else {
	  ## Perform LocalizeUPF with PASS target as RUPFC
	  print $fh "make LocalizeUPF PASS=RUPFC UPF=$rupc_upf $user_args COPY_CODEGEN_FILES=false \n";
	  print $fh "if \(\$status\) then\n  echo \"LocalizeUPF has failed! Please check output at \$WORKAREA/integration/upf_utils/output/RUPFC/LocalizeUPF\"\n  exit 1\nendif\n";
	  ## Points ResolveUPFCommands Input to LocalizedArea
          print $fh "/bin/cp -rf \$WORKAREA/integration/upf_utils/output/RUPFC/LocalizeUPF/* \$OUTPUT_DIR/Resolved_outputs/\n";
	  print $fh "find \$WORKAREA/integration/upf_utils/output/RUPFC/LocalizeUPF/ -type f -name \"*log\" | xargs cp -ft \$OUTPUT_DIR/logs/RUPF_LocalizeUPF/\n";
	  ## ZS WW40: Need to copy logfile from localizeUPF runs to here
          $rupc_dir = "\$OUTPUT_DIR/Resolved_outputs";
          $rupc_upf = basename($rupc_upf);
          $rupc_upf = "$rupc_dir/$rupc_upf";
	}

        ## Backup a set of UPF files for reference
        print $fh "setenv RUPFC_INPUT_DIR $rupc_dir\n";
	print $fh "/bin/cp -rf \$RUPFC_INPUT_DIR/* \$OUTPUT_DIR/Backup/ # BackUp copies of input UPFs\n";

        ## Start preprocessing run
        print $fh "echo \"ResolveUPFCommands: BEFORE find_objects count in output directory \$RUPFC_INPUT_DIR , including commented is `grep -ro find_objects \$RUPFC_INPUT_DIR | grep -iv \'log\' | wc -l`\"\n";
        ## ZS WW42 Added new config RESOLVE_UPF_ONLY, as workaround to limitation of shared config find_objects commands
        if ( (lc($configHash->{RESOLVE_UPF_ONLY}) eq "true") ) {
	  print $fh "foreach upf_file \(`find \$RUPFC_INPUT_DIR -type f -name \"*.upf\"`\)\n";
        } else {
          print $fh "foreach upf_file \(`find \$RUPFC_INPUT_DIR -type f`\)\n";
        }
	## ZS WW40: Will need a way to skip certain files
	print $fh "  echo \"-I-: ResolveUPFCommands, pre-processing \$upf_file\"\n";
	print $fh "  \$UPF_UTILS_ROOT/ResolveUPFCommands/ResolveUPF_preprocess.tcl \"\$upf_file\"\n";
	print $fh "  if \(\$status\) then\n    echo \"-F-: Fatal Error with Preprocessing. Exiting Run\"\n    \$UPF_UTILS_ROOT/ResolveUPFCommands/ResolveUPF_cleanup.tcl \$RUPFC_INPUT_DIR\n    exit 1\n  endif\nend\n";

	## Start VCLP run
	## Translation of ResolveUPFCommands to make vclp_run level commands
	$vclp_user_args = $user_args;
        if(defined($configHash->{VCLP_BLOCK}) and $configHash->{VCLP_BLOCK} ne "") {
	  $vclp_user_args .= " BLOCK=$configHash->{VCLP_BLOCK}";
	}
        if(defined($configHash->{TOP_MODULE}) and $configHash->{TOP_MODULE} ne "") {
          $vclp_user_args .= " TOP_MODULE_NAME=$configHash->{TOP_MODULE}";
        }
        print $fh "\n## Please ensure VCLP environment has been set up properly in \$WORKAREA/static/vclp\n";
        print $fh "cd \$WORKAREA/static/vclp\n";
	print $fh "echo \"Running VCLP now, please check VCLP_run log in \$WORKAREA/output/$configHash->{DUT}/vclp/RUPFC/vclp_run/vcst_session.log\"\n";
	print $fh "make vclp_run PASS=RUPFC STOP_FLOW_AT_STAGE=upf $vclp_user_args UPF_FILE=\"$rupc_upf\" >/dev/null\n";
	print $fh "set vclp_run_status=\$status\n";
        print $fh "echo \"VCLP_run Exit Status - \$vclp_run_status\"\n";
	print $fh "if \(\$vclp_run_status\) then\n  echo \"It is acceptable for vclp_run to have non-fatal errors during ResolveUPFCommands run. However, please cross check resolved_outputs with backup for assurance.\"\nendif\n";

	## After VCLP RUN, start postprocessing run
        print $fh "/bin/cp -rf \$WORKAREA/output/$configHash->{DUT}/vclp/RUPFC/vclp_run/* \$OUTPUT_DIR/logs/RUPF_vclp_run/\n";
	print $fh "cd \$WORKAREA/static/vclp && rm -rf \$WORKAREA/output/$configHash->{DUT}/vclp/RUPFC/vclp_run\n";
	if ( (lc($configHash->{RUPF_SKIP_LOCALIZE}) eq "false") ) {
          print $fh "cd \$WORKAREA/integration/upf_utils && make clean_LocalizeUPF PASS=RUPFC $user_args\n";
	}
	print $fh "\nif \(-f \$OUTPUT_DIR/logs/RUPF_vclp_run/vcst_session.log\) then\n";
	print $fh "  \$UPF_UTILS_ROOT/ResolveUPFCommands/ResolveUPF_postprocess.tcl \"\$OUTPUT_DIR/logs/RUPF_vclp_run/vcst_session.log\"\n";
	print $fh "  if \(\$status\) then\n    echo \"-F-: Fatal Error with Postprocessing. Exiting Run\"\n    \$UPF_UTILS_ROOT/ResolveUPFCommands/ResolveUPF_cleanup.tcl \$RUPFC_INPUT_DIR\n    exit 1\n  endif\n";
	print $fh "else\n  echo \"-F-: VCLP_run log is not found!\"\n  \$UPF_UTILS_ROOT/ResolveUPFCommands/ResolveUPF_cleanup.tcl \$RUPFC_INPUT_DIR\n  exit 1\nendif\n";
	print $fh "\$UPF_UTILS_ROOT/ResolveUPFCommands/ResolveUPF_cleanup.tcl \$RUPFC_INPUT_DIR\n";
        if ( (lc($configHash->{RUPF_SKIP_LOCALIZE}) eq "true") ) {
          print $fh "/bin/cp -rf \$RUPFC_INPUT_DIR/* \$OUTPUT_DIR/Resolved_outputs/\n";
        }
	print $fh "echo \"Script Exit Status - \$status\"\n";
        print $fh "echo \"ResolveUPFCommands: AFTER find_objects count in output directory \$OUTPUT_DIR/Resolved_outputs , including commented is `grep -ro find_objects \$OUTPUT_DIR/Resolved_outputs | grep -iv \'log\' | wc -l`\"\n";
    }

    if (defined $configHash->{CTH_GK_MODE} and ($configHash->{CTH_GK_MODE} !~ /^\s*$/) and (lc($configHash->{CTH_GK_MODE}) eq "false")) {
        print $fh "if \(!\(-l \$WORKAREA/integration/upf_utils/output\)\) then\n  /bin/ln -s $configHash->{OUTPUT_DIR} \$WORKAREA/integration/upf_utils/output\nendif\n"
    }
    if (lc($configHash->{COPY_CODEGEN_FILES}) eq "true") {
    ## InspectUPF does not require Handoff
        if ( ($flow eq "LocalizeUPF") || ($flow eq "MergeUPF") || ($flow eq "ResolveUPFCommands") ) {
            if ($configHash->{ENABLE_MULTIPLE_TOP} == 0) {
               $handoff_dir = "\$WORKAREA/src/codegen/$configHash->{DUT}/IntgMstr";
            } else {
               $handoff_dir = "\$WORKAREA/src/codegen/$configHash->{DUT}/IntgMstr/$configHash->{TOP_MODULE}";
            }
            print $fh "/bin/mkdir -p ${handoff_dir}\/upf\/$flow\n";
            print $fh "setenv HANDOFF_DIR $handoff_dir\/upf\/$flow\n";
	    if ($flow eq "LocalizeUPF") {
	      print $fh "/bin/cp -rf \$OUTPUT_DIR/* \$HANDOFF_DIR/\n";
	    } elsif ($flow eq "MergeUPF") {
	      print $fh "/bin/cp -rf \$OUTPUT_DIR/gen/upf/* \$HANDOFF_DIR/\n";
	    } elsif ($flow eq "ResolveUPFCommands") {
              print $fh "/bin/cp -rf \$OUTPUT_DIR/Resolved_outputs/* \$HANDOFF_DIR/\n"
	    }
        }
    }
}

## Main routine
sub run {
    my $replayFile = shift;
    my $configHash = shift;
    my $flow = shift;
    my $type = shift;

    if (!defined $type)  {
        $type = "file";
    }

    my $logDir = "";
    if ($configHash->{ENABLE_MULTIPLE_TOP} == 0) {
        $logDir = $configHash->{OUTPUT_DIR} . "/" . $configHash->{PASS};
    } else {
        $logDir = $configHash->{OUTPUT_DIR} . "/" . $configHash->{PASS} . "/" . $configHash->{TOP_MODULE};
    }
    my $logFile = "$logDir/${flow}.log";
    my $nbTaskFile = "$logDir/${flow}_nbflow_file";
    my $ErrorlogFile = "$logDir/${flow}.error_log";

    # HSD16012473501 - Remove .PASS at start of every run
    my $stageDotPASSFile = "$logDir/${flow}.PASS";
    if (-e $stageDotPASSFile) {
      my $rm_return = system("/bin/rm $stageDotPASSFile");
      if ($rm_return != 0) {
	    &error("Failed to remove $stageDotPASSFile");
	  }
    }


    my $returnCount = "";
    if ($type eq "file") {
        `chmod 777 $replayFile`;
        $returnCount= "$?";
        &error ("The chmod command to give permissions for $replayFile is not working") if ($returnCount > 0 );
    }
    my $cmd = "$replayFile 2>&1 | tee $logFile";
    if (defined $configHash->{CTH_QUIET_MODE} and ($configHash->{CTH_QUIET_MODE} !~ /^\s*$/) and (lc($configHash->{CTH_QUIET_MODE}) eq "true")) {
	    $cmd = "$replayFile >&$logFile";
    }
    my $return = 0;

    if ( lc($configHash->{RUN_NETBATCH}) eq "false" ) {
        $return = system($cmd);
	    if ($return != 0) {
	        error ("Failed to run $cmd");
	    }
    } else {
        $logFile = $logDir . "/" . "${flow}_netbatch.log";
        NetBatch::submitNbfeederJob($replayFile, $logFile, "${flow}_$configHash->{DUT}_$configHash->{TOP_MODULE}","$logDir/${flow}_nbflow_file",$configHash);
    }
    if ($type eq "file") {
        &reportExtract($logDir,$logFile,$ErrorlogFile,$flow);
    }
}

####################################################################################
sub reportExtract {
    my $returnCount= "";
    my ($dir,$logFile,$ErrorlogFile,$stage) = @_;
    my $summaryHash;
    my $egrepCommand;
    $summaryHash->{TOOL_ERROR} = "0";
    $summaryHash->{TOOL_WARN} = "0";
    $summaryHash->{EXIT_CODE} = "0";

    $summaryHash->{FLOW_ERROR} = &getErrorCount();
    $summaryHash->{FLOW_WARN} = &getWarningCount();

    if ( -z $logFile) {
        &error("$stage failed, empty log file is generated");
        $summaryHash->{STATUS} = "FAIL";
    }
    elsif (-e $logFile) {
        $summaryHash->{TOOL_FATAL} = `/usr/bin/egrep -r "^(Error|-F-)" $logFile | wc -l`;
	$returnCount= "$?";
	&error ("The egrep command for tool fatal is not working in report extraction") if ($returnCount > 0 );
        $summaryHash->{TOOL_FATAL} =&trim($summaryHash->{TOOL_FATAL});
        $summaryHash->{TOOL_ERROR} = `/usr/bin/egrep -r "^-E-" $logFile | wc -l`;
	$returnCount= "$?";
	&error ("The egrep command for tool errors is not working in report extraction") if ($returnCount > 0 );
        $summaryHash->{TOOL_ERROR} =&trim($summaryHash->{TOOL_ERROR});
        $summaryHash->{TOOL_WARN} = `/usr/bin/egrep -r "^(Warning:|-W-)" $logFile | wc -l`;
	$returnCount= "$?";
	&error ("The egrep command for tool warnings is not working in report extraction") if ($returnCount > 0 );
        $summaryHash->{TOOL_WARN} =&trim($summaryHash->{TOOL_WARN});

        my $exit_string = `/usr/bin/grep -irh "Script Exit Status" $logFile`;
	$returnCount= "$?";
	&error ("The grep command for script exit status is not working in report extraction") if ($returnCount > 0 );
        if (defined $exit_string) {
            if ($exit_string =~ /Script Exit Status\s+-\s+(\d+)/) {
                $summaryHash->{EXIT_CODE} = $1;
            }
	    if ($summaryHash->{EXIT_CODE} != 0) {
		++$summaryHash->{TOOL_FATAL};
	    }
	}

	# Grep error messages from ${flow}.log to ${flow}.error_log
    	$egrepCommand = '/usr/bin/egrep -r "(Error|-F-|-E-)" ';
	$egrepCommand .= " $logFile | /usr/bin/egrep -v 'vclp_run' >> $ErrorlogFile";
	my $egrepReturn = 0;
        $egrepReturn = system($egrepCommand);
	if ( (-f $ErrorlogFile) && !(-z $ErrorlogFile) ) {
	    &info("$stage failed. Please check the error_log : $ErrorlogFile");
	    $summaryHash->{STATUS} = "FAIL";
	}

        $summaryHash->{FLOW_ERROR} = &getErrorCount();
        if ($summaryHash->{TOOL_ERROR} == 0 and $summaryHash->{TOOL_FATAL} == 0 and $summaryHash->{FLOW_ERROR} == 0  and $summaryHash->{EXIT_CODE} == 0){
            $summaryHash->{STATUS} = "PASS";
        }
    }
    else  {
        &error("$stage failed, no log file is generated");
        $summaryHash->{STATUS} = "FAIL";
    }

    ## touch the pass file
    my $return = 0;
    if (defined $summaryHash->{STATUS} and $summaryHash->{STATUS} eq "PASS") {
        &info("$stage passed successfully..");
        $return = system("\\/usr/bin/touch $dir/$stage.PASS");
	if ($return != 0) {
	    &error("Failed to create $dir/$stage.PASS file");
	}
	else {
	    &info("PASS file generated at $dir/$stage.PASS");
	}
    }
    else {
        &info("$stage failed. Please check the log : $logFile");
    }
    &summaryRpt("$dir", $summaryHash->{FLOW_ERROR}, $summaryHash->{TOOL_ERROR}, $summaryHash->{TOOL_FATAL}, $summaryHash->{FLOW_WARN}, $summaryHash->{TOOL_WARN}, $stage);
    my $total_error = $summaryHash->{FLOW_ERROR} + $summaryHash->{TOOL_ERROR} + $summaryHash->{TOOL_FATAL};
    exit($total_error);

}
#######################

1;
