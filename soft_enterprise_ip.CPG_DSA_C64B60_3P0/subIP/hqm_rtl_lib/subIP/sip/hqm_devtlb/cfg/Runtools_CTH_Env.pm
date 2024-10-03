package Runtools_CTH_Env;
use strict;

# --------------------------------------------------------------------------------------------------
# Various variables used in calculations to build up the REAL list of environment variables
#
# THEY are not used in the environment - they are here simply to make the creation
# of the %CTH_ENV_VARS hash easier.
#
# --------------------------------------------------------------------------------------------------
my $_LITE_INFRA_VERSION = "1.5";
my $_LITE_INFRA_PATH    = "/p/hdk/pu_tu/prd/liteinfra/${_LITE_INFRA_VERSION}";
my $_LM_PROJECT         = "PDS";
my $_CTHPERL            = "/usr/intel/pkgs/perl/5.26.1/bin/perl";
my $_CTH_PERL5LIB       = "${_LITE_INFRA_PATH}/commonFlow/lib/perl";
my $_FE_BASELINE_TOOLS  = "baseline_tools";
my $_FE_REPO_CMD        = "git rev-parse --show-toplevel";

# NOTE: Using full path to activity_dir.map due to https://hsdes.intel.com/appstore/article/#/22010670476
my $_FE_ACTIVITY_MAPPING         = "$ENV{WORKAREA}/${_FE_BASELINE_TOOLS}/activity_dir.map";
my $_CENTRAL_TOOL_CONFIG_VERSION = "0.0.22";
my $_CENTRAL_TOOL_CONFIG         = "/p/hdk/pu_tu/prd/global_tools/pesg_fe/${_CENTRAL_TOOL_CONFIG_VERSION}";

# NOTE: Apparently CTH needs the env set AND contain -read_only - this is not really how
#       bootstrap setups up the env.
my $_CTH_SETUP_CMD = 'cth_psetup -p cae -cfg EIPFE.cth -read_only';

my $_CTH_SESSION_ID = $ENV{USER} . "_" . $$;

# --------------------------------------------------------------------------------------------------
# This is the key interface subroutine.  It take no argument, and returns a simple hash reference:
#    {
#        'environment var name' => 'value'
#    }
# --------------------------------------------------------------------------------------------------
sub get_cth_env_hash_ref {

    # ----------------------------------------------------------------------------------------------
    # These are the important env vars as per https://wiki.ith.intel.com/display/cheetah/FE+Environment
    #
    # Specifically, those that setup the minumum cth env are:
    #   - $PATH                 !! Currently, NOT doing this !!  Should we????
    #   - $CTH_PERL5LIB         set to point to the lite-infra API perl modules directory
    #   - $FE_REPO_CMD          set to a command string to tells lite-infra how to detect whether
    #                           the user is running from a design repo or not.
    #   - $FE_ACTIVITY_MAPPING  set to a file that tells lite-infra how to map flow-names to activity-names
    #                           !! currently setting to a full path !!
    #   - $FE_BASELINE_TOOLS    set to a repo-relative path where lite-infra will look for default repo tool configs.
    #   - $CENTRAL_TOOL_CONFIG  set to a directory where lite-infra will look for global tool configs.
    #
    # This hash will be used to do the following:
    #    - iterate thru the hash keys
    #    - SETS $ENV{ hash key } to specified value
    #       - note sets - note append, prepend, conditional set.  Just simply sets env var to specified value
    #
    # QUESTIONS:
    #   1. Should we add the infra-lite path $PATH?
    #
    #   2. Should we use a NON-perl version of Runtools_CTH_Env.pm - no real reason for perl.
    #
    #   3. Do we want to provide other operations in addition to set?
    #
    #       My suggestion:  We should keep is simple and and straight forward.
    #           The purpose is to bootstrap minimum env to allow use of CTH::Config
    #           So, unless #1 is required, only setenv.
    #
    #  4. Do we want to check and limit the listed ENV VARS to a set of valid ones?  I.E., don't
    #     allow any arbitrary env to be set, just the ones associated with allowing use of Lite Infra?
    #
    #       My suggestion:  Yes - again keep it simple, but restricted just to the bootstrap
    #                       minimum env to allow use of CTH::Config
    #
    # --------------------------------------------------------------------------------------------------
    my %env_hash = (
        CTH_PERL5LIB        => $_CTH_PERL5LIB,
        FE_REPO_CMD         => $_FE_REPO_CMD,
        FE_ACTIVITY_MAPPING => $_FE_ACTIVITY_MAPPING,
        FE_BASELINE_TOOLS   => $_FE_BASELINE_TOOLS,
        CENTRAL_TOOL_CONFIG => $_CENTRAL_TOOL_CONFIG,
        CTH_SETUP_CMD       => $_CTH_SETUP_CMD,
        CTH_SESSION_ID      => $_CTH_SESSION_ID,);

    return \%env_hash;
}

1;
