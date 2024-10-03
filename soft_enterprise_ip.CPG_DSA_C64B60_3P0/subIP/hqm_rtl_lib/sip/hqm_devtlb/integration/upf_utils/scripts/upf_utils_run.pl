#!/usr/intel/pkgs/perl/5.26.1/bin/perl

BEGIN {
	push( @INC, $ENV{RTL_UTIL_ROOT}, $ENV{RTL_UTIL_ROOT} . "/" . "lib" . "/perl", $ENV{FLOW_ROOT}, $ENV{FLOW_ROOT} . "/" . "lib" . "/perl" );
}

if ( defined $ENV{RUN_COVERAGE} ) {
    use lib "/p/dt/sde/tools/em64t_SLES11/perl_coverage/load_cover";
    use load_cover;
}


use strict;
use warnings;
use Data::Dumper;
use File::Path qw(make_path);

use CthRTLUtils;
use ConfigParser;
use Logger;

use UPFCommon;
use NetBatch qw(:nb);
use Constants qw(:genfile :common :parallel);


my $configHash  = {};

################################### PROCESS ####################################

if ( not defined $ENV{WORKAREA} ) {
	error("Please set WORKAREA in the terminal");
	exit( &getErrorCount() );
}

## run Target
&runTarget();

########################################################
sub runTarget {
    my $returnCount = "";

    if ( $ARGV[0] eq "LocalizeUPF"
       || $ARGV[0] eq "InspectUPF"
       || $ARGV[0] eq "MergeUPF"
       || $ARGV[0] eq "ResolveUPFCommands") {
	$configHash = UPFCommon::runConfigTarget( $ARGV[1] );
	getBanner();

    # HSD16012473185 - Integrate Diamond API
    my $loggingHash->{version} = "undef"; ## FLow version is kept undef, handled by RTLUtils.pm
    $loggingHash->{tool_version} = $configHash->{UPF_UTILS_VERSION}; ## Tool Version
    $loggingHash->{tool_name} = 'upf_utils'; ## Tool Name
    logRunData($loggingHash);

    # Placeholder for feature logging
    # $loggingHash->{feature} = 'test_feature';
    # logFeatureUsage($loggingHash);

    my $outdir = "";
	my $upf_utils_replay_file = "";
    my $flow = $ARGV[0];
    if ($configHash->{ENABLE_MULTIPLE_TOP} == 0) {
        $outdir = "$configHash->{OUTPUT_DIR}/$configHash->{PASS}";
	    if(!-d $outdir) {
		    make_path("$outdir");
    	}
	    $upf_utils_replay_file = $configHash->{OUTPUT_DIR}  . "/" . $configHash->{PASS} . "/". $ARGV[0] . "_replay.csh";
    } else {
	    $outdir = "$configHash->{OUTPUT_DIR}/$configHash->{PASS}/$configHash->{TOP_MODULE}";
	    if(!-d $outdir) {
		    make_path("$outdir");
	    }
	    $upf_utils_replay_file = $configHash->{OUTPUT_DIR}  . "/" . $configHash->{PASS} . "/" . $configHash->{TOP_MODULE} . "/". $ARGV[0] . "_replay.csh";
	}

    # HSD16012473501 - Remove stage specific output if flow, or all has been included in CLEAN_STAGE. Main reason is all flows in upf_utils are independent from each other.
    my @cleanStageArray = split(',', $configHash->{CLEAN_STAGE});
    if ( (grep {$flow eq $_} @cleanStageArray) or (grep {"all" eq $_} @cleanStageArray) or (grep {"ALL" eq $_} @cleanStageArray) ) {
        my $csa_return = system("/bin/rm -rf $outdir/${flow} $outdir/${flow}.PASS $outdir/${flow}.error_log $outdir/${flow}.log $outdir/${flow}.summary.rpt $outdir/${flow}_replay.csh");
    	if ( $csa_return != 0 ) {
    	    error("Could not clean output directory: $outdir/${flow}");
    	} else {
    	    info("Cleaned the output directory: $outdir/${flow}");
    	}
    }

	open( my $fh, ">$upf_utils_replay_file" );
	print $fh "#!/bin/csh\n";

	#Add Setup
	UPFCommon::addSetup( $fh, $configHash, $ARGV[0] );

	#Add RUN Commands
	UPFCommon::addRunCommands( $fh, $configHash, $ARGV[0] );
	close $fh;

	#Run
	UPFCommon::run( $upf_utils_replay_file, $configHash, $ARGV[0] );
    } elsif ( $ARGV[0] eq "clean" ||
              $ARGV[0] eq "clean_LocalizeUPF" ||
	      $ARGV[0] eq "clean_MergeUPF" ||
	      $ARGV[0] eq "clean_InspectUPF" ||
	      $ARGV[0] eq "clean_ResolveUPFCommands") {
	$configHash = UPFCommon::runConfigTarget( $ARGV[1] );

	### WORKAREA/output/$DUT/upf_utils/$PASS
        my $output_dir = "";
        my $flow = "";
        if ($configHash->{ENABLE_MULTIPLE_TOP} == 0) {
	    $output_dir = $configHash->{OUTPUT_DIR} . "/" . $configHash->{PASS};
	}
	else {
	    $output_dir = $configHash->{OUTPUT_DIR} . "/" . $configHash->{PASS} . "/" . $configHash->{TOP_MODULE};
	}

        if ( $ARGV[0] eq "clean_LocalizeUPF" ) {
	  $flow = "LocalizeUPF";
	} elsif ( $ARGV[0] eq "clean_MergeUPF" ) {
	  $flow = "MergeUPF";
	} elsif ( $ARGV[0] eq "clean_InspectUPF" ) {
	  $flow = "InspectUPF";
	} elsif ( $ARGV[0] eq "clean_ResolveUPFCommands" ) {
	  $flow = "ResolveUPFCommands";
	}

	my $return = 0;
	#clean up the output dir for provided PASS
	if ( $ARGV[0] eq "clean" ) {
    	    $return = system("/bin/rm -rf $output_dir");
    	    if ( $return != 0 ) {
    	        error("Could not clean output directory: $output_dir");
    	    } else {
    	        info("Cleaned the output directory: $output_dir");
    	    }
	} else {
	    $return = system("/bin/rm -rf $output_dir/${flow} $output_dir/${flow}.PASS $output_dir/${flow}.error_log $output_dir/${flow}.log $output_dir/${flow}.summary.rpt $output_dir/${flow}_replay.csh");
    	    if ( $return != 0 ) {
    	        error("Could not clean output directory: $output_dir/${flow}");
    	    } else {
    	        info("Cleaned the output directory: $output_dir/${flow}");
    	    }
	}

	if ( (-l "$ENV{WORKAREA}/integration/upf_utils/output") && ($ARGV[0] eq "clean") ) {
	    $return = system("/usr/bin/unlink $ENV{WORKAREA}/integration/upf_utils/output");
	    if ( $return != 0 ) {
		error("Could not clean link to output directory: $ENV{WORKAREA}/integration/upf_utils/output");
	    } else {
		info("Cleaned the link to output directory: $ENV{WORKAREA}/integration/upf_utils/output");
	    }
	}
    } elsif ( $ARGV[0] eq "clean_all" ) {
	$configHash = UPFCommon::runConfigTarget( $ARGV[1] );

	my $return = 0;
	#clean up the output dir completely
	$return = system("/bin/rm -rf $configHash->{OUTPUT_DIR}");
	if ( $return != 0 ) {
	    error("Could not clean output directory: $configHash->{OUTPUT_DIR}");
	} else {
	    info("Cleaned the output directory: $configHash->{OUTPUT_DIR}");
	}
	if ( -l "$ENV{WORKAREA}/integration/upf_utils/output" ) {
	    $return = system("/usr/bin/unlink $ENV{WORKAREA}/integration/upf_utils/output");
	    if ( $return != 0 ) {
		error("Could not clean link to output directory: $ENV{WORKAREA}/integration/upf_utils/output");
	    } else {
		info("Cleaned the link to output directory: $ENV{WORKAREA}/integration/upf_utils/output");
	    }
	}
    } elsif ( $ARGV[0] eq "config" ) {
	$configHash = UPFCommon::runConfigTarget( $ARGV[1] );

	`/bin/rm -rf output`;
	$returnCount = "$?";
	&error("The command to remove output dir is not working") if ( $returnCount > 0 );

	#create output dir link
	if ( defined $configHash->{CTH_GK_MODE} and ( $configHash->{CTH_GK_MODE} !~ /^\s*$/ ) and ( lc( $configHash->{CTH_GK_MODE} ) eq "false" ) ) {
	    `/bin/ln -s $configHash->{OUTPUT_DIR} output`;
	    $returnCount = "$?";
	    &error("The command to create link for output dir is not working") if ( $returnCount > 0 );
	}
    } else {
	&error("Error: Invalid target - $ARGV[0] called. Please use make help to see all the targets.");
    }
}

########################################################
