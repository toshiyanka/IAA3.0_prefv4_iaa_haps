package FlowSpec;

use strict;
use warnings;

use Exporter;
use vars qw(@ISA @EXPORT);
@ISA    = qw(Exporter);
@EXPORT = qw(%FlowSpec);
use FindBin;
use lib "$FindBin::Bin";
use File::Basename;
use RTLUtils;
use Utils;
use lib "$ENV{RTL_PROJ_BIN}/perllib";
use ToolConfig;
use File::Temp qw/ tempfile tempdir /;
#use strict;
no strict "subs";
no warnings 'redefine';
use vars qw(%FlowSpec);

############################################################
# FlowSpec Hash
# Contains the flow specifications for all currently
# supported flows
############################################################
$ENV{FLOW_DIGEST_VERBOSE} = 1;

%FlowSpec = (

    # codegen flow
    #codegen => ordered_hash(
    #    OPT_SPEC => {
    #    },
    #    SETUP    => \&rtlbuild_setup,
    #    PRE_FLOW => \&rtlbuild_pre_flow,
    #
    #),

    ################################
    # rtlbuild flow
    ###############################

    rtlbuild => ordered_hash(

        OPT_SPEC => {
        },
        SETUP    => \&rtlbuild_setup,
        PRE_FLOW => \&rtlbuild_pre_flow,

        ace => {
            stage => ace,
            default_active => "off",
            opts => { runlog => 1},
            deps => [qw()],
        },

        rdl => {
            stage => ace_command,
            default_active => "off",
            opts => {
                    runlog => 1,
                    command => &rdl_cmd,
            },
            deps => [qw()],
        },

        raldiff => {
            stage => ace_command,
            default_active => "off",
            opts => {
                    runlog => 1,
                    command => "make -C tools/raldiff all",
            },
            deps => [qw()],
        },

        release => {
            stage => ace_command,
            default_active => "off",
            opts => {
                    runlog => 1,
                    command => "./scripts/do_release_stage",
            },
            deps => [qw()],
        },

        fal => {
            stage => ace_command,
            default_active => "off",
            opts => {
                    runlog => 1,
                    command => "./scripts/genDsaFalEnv.pl -genFal -proj ".&ToolConfig::get_facet(CUST)." -dut ".&ToolConfig::get_facet("dut"),
            },
            deps => [qw()],
        },

        compile_analytics  => {
            stage => ace_command,
            default_active => "off",
            opts => {
                    runlog => 1,
                    command => '$MODEL_ROOT/verif/tb/AnalyticsModel/ace/compile_AnalyticsModel.pl vcs $MODEL_ROOT/results/vcs_lib/analyticsmodel_lib verif/tb/AnalyticsModel',
            },
            deps => [qw()],
        },

        # Functional coverage: Functional coverage report
        report_func_cov => {
            stage => ace,
            default_active => "off",
            opts => {
                runlog => 1,
                command => '$MODEL_ROOT/scripts/reportFuncCov.pl ',
            },
        },
        
        visa_insert => {
            stage => ace_command,
            default_active => "on",
            opts => {
                runlog => 1,
                command => "ace -g -egc ".&tool_args("visa_gen_rtl"),
            },
            # post_run => \&stage_visa_insert_post,
            deps => [qw()],
        },

        visa_insert_iax2i64b60 => {
            stage => ace_command,
            default_active => "off",
            pre_run =>  \&visa_copy_sigs_top_iax,
            opts => {
                runlog => 1,
                command => "ace -g -egc -en__iax2i64b60_rtl_lib_VISA_INSERTION",
            },
            # post_run => \&stage_visa_insert_top_iax_post,
            deps => [qw()],
        },

        # this should be the default and what is used by 99% of design and validation
        # for now, the "vcs" stage does not include VISA. VISA will be added in the future
        vcs => {
            stage => ace_command,
            default_active => "off",
            opts => {
                runlog => 1,
                command => &ace_compile_cmd . " -noegc", # Check with Jimmy
            },
            deps => [qw()],
        },

        vcs_compile_visa => {
            stage => ace_command,
            default_active => "on",
            opts => {
               runlog => 1,
               command => &ace_compile_cmd . " -vlog_opts +define+RAM_IMPL=\"generic\" -noegc -epi ".&tool_args("visa_gen_rtl"),
            },
            deps => ["visa_insert",
                     "cama_pre_build",
                     ( &ToolConfig::get_facet("dut") eq "iax" ) ? "iax_cmodel_compile" : (),],
        },

        cama_pre_build => {
            stage => ace_command,
            default_active => "on",
            opts => {
               runlog => 1,
               command => "./scripts/cama.mk unregister",
            },
            deps => [],
        },

        cama_post_build => {
            stage => ace_command,
            default_active => "on",
            opts => {
               runlog => 1,
               command => "./scripts/cama.mk register",
            },
            deps => ["vcs_compile_visa"],
        },

        vcs_compile_novisa => {
            stage => ace_command,
            default_active => "off",
            opts => {
                runlog => 1,
                command => &ace_compile_cmd . " -vlog_opts +define+RAM_IMPL=\"generic\"  -noegc -epi",
            },
            deps => [( &ToolConfig::get_facet("dut") eq "iax" ) ? "iax_cmodel_compile" : (),],
        },

        vcs_compile_novisa_noupf => {
            stage => ace_command,
            default_active => "off",
            opts => {
                runlog => 1,
                command => &ace_compile_cmd . " -vlog_opts +define+RAM_IMPL=\"generic\"  -noegc",
            },
            deps => [( &ToolConfig::get_facet("dut") eq "iax" ) ? "iax_cmodel_compile" : (),],
        },

        verdi_compile => {
            stage => ace_command,
            default_active => "off",
            opts => {
                runlog => 1,
                command => "ace -ccod -noegc -epi ".&tool_args("visa_gen_rtl"),
            },
            deps => [qw(visa_insert)],
        },

        # Note: Assumes the facet has been supplied via onecfg
        collage => {
            stage => ace_command,
            default_active => "off",
            opts => {
                runlog => 1,
                command => &collage_run_cmd,
            },
            deps => [qw()],
        },

        inspect_upf => {
            stage => ace_command,
            default_active => "off",
            opts => {
                runlog => 1,
                command => "/p/com/flows/chassis/2014ww38a/tools/upf/inspect_upf/inspect.tcl -upf tools/upf/spr/".&wrapper_upf_file." -verbose |& tee tools/upf/inspect.log",
            },
            deps => [qw()],
        },

        visa_validate => {
            stage => ace_command,
            default_active => "off",
            opts => {
                runlog => 1,
                command => "make -C tools/visa validate",
            },
            deps => [qw()],
        },

        iax_cmodel_compile => {
            stage => ace_command,
            default_active =>  ( &ToolConfig::get_facet("dut") eq "iax" ) ? "on" : "off",
            opts => {
                runlog => 1,
                command => "scripts/cmodel_build.sh",
            },
            deps => [qw()],
        },

        ##SpyglassCDC##

        spyglasscdc_compile => {
            stage => "ace_command",
            default_active => "off",
            opts  => {
                command => 'ace -ccsg -vlog_opts +define+SVA_OFF+INTEL_EMULATION+INTEL_SVA_OFF+RAM_IMPL=sdg1274 -ASSIGN -mc='.&tool_args("spyglass").' -static_check_cfg_file=$SPYGLASS_METHODOLOGY_CDC/ace_static_check.cfg',
                runlog => 1,
            },
            deps => [qw(visa_insert)],
            #setup => \&spyglasscdc_setup,
        },

        sgcdc_verif_struct => {
            stage => "ace_command",
            default_active => "off",
            opts  => {
                command => 'ace -sc -t  -ASSIGN spyglasscdc/'.&ToolConfig::get_facet("CUST").'/'.&ToolConfig::get_facet("WRAPPER").' -static_check_cfg_file=$SPYGLASS_METHODOLOGY_CDC/ace_static_check.cfg',
                runlog => 1,
            },
            deps => [qw(spyglasscdc_compile sgcdc_gen_visa_const)],
            #setup => \&spyglasscdc_setup,
        },

        sgrdc_verif_struct => {
            stage => "ace_command",
            default_active => "off",
            opts  => {
                #command => ToolConfig::ToolConfig_get_tool_exec('spyglass_cdc_verif_struct'), ,
                command => 'ace -sc -t  -ASSIGN spyglasscdc/'.&ToolConfig::get_facet("CUST").'/'.&ToolConfig::get_facet("WRAPPER").'_rdc -static_check_cfg_file=$SPYGLASS_METHODOLOGY_CDC/ace_static_check.cfg',
                runlog => 1,
            },
            deps => [qw(spyglasscdc_compile sgcdc_gen_visa_const)],
            #setup => \&spyglasscdc_setup,
        },

        visa_dotf => {
            stage => "ace_command",
            default_active => "off",
            opts  => {
                command => 'ace -ccsg  -static_check_cfg_file=$MODEL_ROOT/tools/ace/eip/dsa/ace_static_check.sg.cfg -ASSIGN -mc='.&ToolConfig::get_facet("WRAPPER"),
                runlog => 1,
            },
            deps => [qw(visa_insert)],
        },

        visa_dotf_iax2i64b60 => {
            stage => "ace_command",
            default_active => "off",
            opts  => {
                command => 'ace -ccsg  -ASSIGN -mc=iax2i64b60_visa',
                runlog => 1,
            },
            deps => [qw(visa_insert_iax2i64b60)],
        },

        visa_test => {
            stage => "ace_command",
            default_active => "off",
            opts  => {
                command => 'source scripts/visa_test.tcsh '.&ToolConfig::get_facet("dut").' '.&ToolConfig::get_facet("WRAPPER"),
                runlog => 1,
            },
            deps => [qw(visa_dotf)],
        },
        sgcdc_gen_visa_const => {
            stage => "ace_command",
            default_active => "off",
            opts  => {
                command => 'source tools/spyglasscdc/'.&ToolConfig::get_facet("CUST").'/generate_visa_constraints.csh '.&ToolConfig::get_facet("dut").' '.&ToolConfig::get_facet("WRAPPER"),
                runlog => 1,
            },
            deps => [qw(visa_insert)],
        },
        sglint_build => {
            stage => "ace_command",
            default_active => "off",
            opts  => {
                command => 'ace -ccsg -vlog_opts +define+SVA_OFF+INTEL_SVA_OFF+RAM_IMPL=generic -ASSIGN -static_check_cfg_file=$SPYGLASS_METHODOLOGY_RTL_LINT/ace_static_check.cfg -mc '.&tool_args("lintra"),               
                runlog => 1,
            },
            deps => [qw(visa_insert)],
            setup    =>  \&sglint_setup,
            pre_run  =>  \&sglint_prerun,
            post_run =>  \&sglint_postrun,
        },

        sglint_test => {
            stage => "ace_command",
            default_active => "off",
            opts  => {
                command => 'ace -sc -t -ASSIGN spyglasslint/'.&ToolConfig::get_facet(CUST).'/'.&ToolConfig::get_facet("WRAPPER").' -noepi  -static_check_cfg_file=$SPYGLASS_METHODOLOGY_RTL_LINT/ace_static_check.cfg',
                runlog => 1,
            },
            deps => [qw(sglint_build)],
            setup    =>  \&sglint_setup,
            pre_run  =>  \&sglint_prerun,
            post_run =>  \&sglint_postrun,

        },

    ),

    static_checks => ordered_hash(

        lintra_compile => {
            stage => ace_command,
            default_active => "off",
            opts => {
                runlog => 1,
                command => "ace -ccolt -vlog_opts +define+RAM_IMPL=\"generic\" -mc ".&tool_args("lintra")." -noegc ".&tool_args("visa_gen_rtl"), 
                results => "results/lintralint",
            },
            deps => [qw(visa_insert)],
        },

        lintra_test => {
            stage => ace_command,
            default_active => "off",
            opts => {
                runlog => 1,
                command => "ace -sc -t lintra/".&ToolConfig::get_facet("CUST")."/".&ToolConfig::get_facet("WRAPPER"),
                results => "results/lintralint",  
            },
            deps => [qw(lintra_compile)],
        },

        lintra_openlatch => {
            stage => ace_command,
            default_active => "off",
            opts => {
                runlog => 1,
                command => "ace -sc -t openlatch/spr/".&ToolConfig::get_facet("WRAPPER") ,
            },
            deps => [qw(lintra_compile)],
        },

        cdc_compile => {
            stage => ace_command,
            default_active => "off",
            opts => {
                runlog => 1,
                command => "ace -ccoz -ASSIGN -mc=".&ToolConfig::get_facet("WRAPPER")."_cdc_model -en__".&ToolConfig::get_facet("WRAPPER")."_rtl_lib_VISA_INSERTION",
            },
            deps => [qw(visa_insert)],
        },

        cdc_test => {
            stage => ace_command,
            default_active => "off",
            opts => {
                runlog => 1,
                command => "ace -xz -t qcdc/spr/".&ToolConfig::get_facet("WRAPPER")."_cdc_test -nocleanup -nocpmf" ,
            },
            deps => [qw(cdc_compile)],
        },

        # added for effm 2019.30
        effm => {
            stage => ace_command,
            default_active => "off",
            opts => {
                #2016.15 EFFM Changes UPF Not Supported at the moment
                #command => "ace -emul -ASSIGN -hdl_compiler=emul -emul_top=".&ToolConfig::get_facet("WRAPPER")."_rtl_lib.".&top_design_model." -emul_model=".&ToolConfig::get_facet("WRAPPER")."_emul_model",
                #command => "ace -emul -compiler_tag=emu -emul_top=".&ToolConfig::get_facet("WRAPPER")."_rtl_lib.".&top_design_model." -emul_model=".&ToolConfig::get_facet("WRAPPER")."_emul_model",
                # To run ZSE ONly
                #command => "ace -emul -emul_cfg tools/ace/effm_flows/effmcheck.cfg -emul_top ".&ToolConfig::get_facet("WRAPPER")."_rtl_lib.".&top_design_model." -emul_model ".&ToolConfig::get_facet("WRAPPER")."_emul_model -emul_enable_filter 1 -emul_run_flow CHECK_VELOCE",
                command => "ace -emul -emul_cfg tools/ace/effm_flows/effmcheck.cfg -emul_top ".&ToolConfig::get_facet("WRAPPER")."_rtl_lib.".&top_design_model." -emul_model ".&ToolConfig::get_facet("WRAPPER")."_emul_model -emul_enable_filter 1",
                results => 'results',
            },
            deps => [qw()],
        },

        vclp_build => {
            stage => ace_command,
            opts => {
                runlog => 1,
                #command => ToolConfig::ToolConfig_get_tool_exec('vclp_build'),
                command => "ace -ccvclp -vlog_opts +define+SVA_OFF+INTEL_SVA_OFF -mc=".&ToolConfig::get_facet("WRAPPER")."_cdc_model",
            },
            deps => [qw()],
            #setup => \&vclp_setup,
         },

        vclp_test => {
            stage => ace_command,
            opts => {
                runlog => 1,
                #command => ToolConfig::ToolConfig_get_tool_exec('vclp_test'),
                command => "ace -t vclp/".&ToolConfig::get_facet("CUST")."/".&ToolConfig::get_facet("WRAPPER")."_top",
            },
            deps => [qw(vclp_build)],
            #setup => \&vclp_setup,
        },

        onesource => {
            stage => ace_command,
            opts => {
                runlog => 1,
                command => "source src/register/osxml/".&ToolConfig::get_facet("CUST")."/run_os.tcsh ".&ToolConfig::get_facet("dut")." ".&ToolConfig::get_facet("CUST")." ".&ToolConfig::get_facet("TOP_WRAPPER"),
            },
            deps => [qw(rdl)],
        },
    ),


    ################################
    # Simbuild flow
    ###############################

    simbuild => ordered_hash(

        OPT_SPEC => {
# top fub is an rtlbuild arg, not simbuild arg
#"top_fub" => {TYPE => "string", DEFAULT => "", HELP => "Force this top instead of the one in the dut.cfg", },
            "dut" => {
                       TYPE    => "string",
                       DEFAULT => undef,
                       HELP    => "design under test",
            },

            "default_config" => {
                TYPE    => "bool",
                DEFAULT => 0,
                HELP =>
                  " Force dut build in case when cfg/<dut>.cfg is missed",
            },
            "dc" => {
                TYPE    => "bool",
                DEFAULT => 0,
                HELP    => "Force dut build in case when cfg/<dut>.cfg is missed",
            },
            "mode" => {
                TYPE    => "string",
                DEFAULT => "",
                HELP    => "Choose 32-bit (32) or 64-bit build (64)"
            },
            "rtltarget" => {
                TYPE    => "string",
                DEFAULT => "",
                HELP    => "Override the RTl target dir name",
            },

        },

        SETUP    => \&simbuild_setup,
        PRE_FLOW => \&simbuild_pre_flow,

        #codegen => {
        #    subflow => 'codegen',
        #    deps => [qw()],
        #},

        static_checks => {
            subflow => 'static_checks',
            default_active => "off",
            deps => [qw()],
            #deps => [qw(codegen)],
        },

        rtl => {
            subflow => 'rtlbuild',
            deps => [qw()],
            #deps => [qw(codegen)],
        },
        dvt_build => {
            stage => ace_command,
            default_active => "off",
            opts => {
                runlog => 0,
                command => "ace -dvt",  # command to compile ace models DVT
            },
        },
        dvt => {
            stage => ace_command,
            default_active => "off",
            opts => {
                runlog => 0,
                command => "ace -run_dvt -model default",  # Command to launch DVT
                                                           # Ensure ace -dvt was run before launching DVT GUI
            },
        },
    )
);
###########################################################
# Setup functions for simbuild/SpyglassLint Flows
###########################################################


 sub sglint_setup
 {
    $ENV{SPYGLASS_LINT} = 1;
    return 0;
 }

my %ace_env_ptr_copy = ();

sub sglint_prerun
  {
    my %args = @_;
    my $self = $args{self};
    my $scoped_vars = $self->{scoped_vars};
    %ace_env_ptr_copy = %{$scoped_vars->{ace_env_ptr}};
    $scoped_vars->{ace_env_ptr} = undef;
    return 0;
  }

  sub sglint_postrun
  {
     my %args = @_;
     my $self = $args{self};
     my $scoped_vars = $self->{scoped_vars};
     %{$scoped_vars->{ace_env_ptr}} = %ace_env_ptr_copy;
    return 0;
 }

###########################################################
# Setup functions for simbuild/rtlbuild flows
###########################################################

sub dut_setup
{
    my $flowptr = shift;

    my $scoped_vars = $flowptr->{scoped_vars};

    my $dut = $flowptr->{scoped_vars}{dut};
    unless (defined($dut)) {
        $dut = $flowptr->{scoped_vars}{dut} =
          $flowptr->get_opt("dut");
    }

    unless (defined($dut)) {
        die("ctebuild flow requires a dut value to run.");
    }

    ####################
    # DutConfig Check
    ####################

    # Check if the dut.cfg exist in MODEL_ROOT/cfg/ directory
    if (&ToolConfig_get_tool_var('rtltools', 'enableDutCheck') &&
        !($flowptr->{scoped_vars}{default_config})) {
        if (RTL_dutCheck($scoped_vars->{dut})) {
            print <<DC_ERROR;

-E- Unsupported DUT.  Config file $scoped_vars->{dut}.cfg was not found at $ENV{MODEL_ROOT}/cfg/
To build $scoped_vars->{dut} using default.cfg, use "TopFlow.pl -dc ..."

DC_ERROR
            exit 1;
        } ## end if (RTL_dutCheck($scoped_vars...
    } ## end if (&ToolConfig_get_tool_var...

    # Set up the DUT config
    #use vars '%DutConfig';
    # This reads/updates the DutConfig and also sets rtlTarget
    my %DutConfig = %{ &FlowSpec::simbuild_setup_dut($flowptr) };
    $scoped_vars->{DutConfig} = \%DutConfig;

} ## end sub dut_setup

##########################################################
# Sub     : simbuild_setup
# Caller  : build_flow (Flow.pm)
# Desc    : This is called when the simbuild flow is being
#         : constructed (prior to stage run) and does some
#         : basic variable, etc setup that is required
#         : by the flow and its stages
# Inputs  : $flowptr : Pointer to flow
#         : %opts : Flow manager opts hash
# Output  : No output
#         : the success of the setup function can be
#         : checked using $flowptr->{setup_ok}
#         : The setup function must set this to true
#         : on succesful completion
##########################################################
sub simbuild_setup
{
    my $flowptr = shift;
    my $opts    = $flowptr->{scoped_vars}->{opts};

    $flowptr->add_scoped_vars(
        qw($dut $DutConfig $aceroot
          $TargetConfig  $rtlTarget
          $default_config
          $optRtlTarget
          $isSyn
          $ace_env_ptr
          )
    );

    my $scoped_vars = $flowptr->{scoped_vars};

    # DUT is a required argument for simbuild
    print_fatal("Dut is a required option for simbuild!")
        if ($flowptr->get_opt("dut") eq "");
    $scoped_vars->{dut} = $flowptr->get_opt("dut");

# move the config and log files to dut specific file names - update the prefix
# the move occurs once the flow is built and prior to any stages being run
    my $prefix = $scoped_vars->{logPrefix};
    $scoped_vars->{logPrefix} = $prefix . "$scoped_vars->{dut}.";
    if (ToolConfig::get_general_var("logPrefix")){
      $scoped_vars->{logPrefix} = $prefix . "$scoped_vars->{dut}.". ToolConfig::get_general_var("logPrefix").".";
    }

    $scoped_vars->{default_config} =
      $flowptr->get_opt("default_config") ||
      $flowptr->get_opt("dc");
# if we are running default with a -dc (default config) switch, it'll need to be passed to simbuild while running stages in legacy mode too
    $scoped_vars->{legacyRunOpts} .= " -dc"
      if ($scoped_vars->{default_config});


    ####################
    # DutConfig Check
    ####################

    # Check if the dut.cfg exist in MODEL_ROOT/cfg/ directory
    if (&ToolConfig_get_tool_var('rtltools', 'enableDutCheck') &&
        !($flowptr->{scoped_vars}{default_config})) {
        if (RTL_dutCheck($scoped_vars->{dut})) {
            print <<DC_ERROR;

-E- Unsupported DUT.  Config file $scoped_vars->{dut}.cfg was not found at $ENV{MODEL_ROOT}/cfg/
To build $scoped_vars->{dut} using default.cfg, use "TopFlow.pl -dc ..."

DC_ERROR
            exit 1;
        } ## end if (RTL_dutCheck($scoped_vars...
    } ## end if (&ToolConfig_get_tool_var...

    # Pass down the rtltarget option
    $scoped_vars->{optRtlTarget} = $flowptr->get_opt("rtltarget");

    # Set up the DUT config
    # This reads/updates the DutConfig and also sets rtlTarget
    my %DutConfig = %{ &FlowSpec::simbuild_setup_dut($flowptr) };
    $scoped_vars->{DutConfig} = \%DutConfig;

    $scoped_vars->{dut_resources} =
      $scoped_vars->{DutConfig}->{resources};

    $scoped_vars->{aceroot} = ToolConfig::get_general_var("aceroot_dpath");
    $scoped_vars->{stageLogDir} = &dirname(ToolConfig::get_general_var("aceroot_dpath")) . "/log";
    $scoped_vars->{stageLogPrefix} =
      $scoped_vars->{stageLogPrefix} . "$scoped_vars->{rtlTarget}.";
    if (ToolConfig::get_general_var("logPrefix")){
        $scoped_vars->{stageLogPrefix} =
          $scoped_vars->{stageLogPrefix} . ToolConfig::get_general_var("logPrefix") . ".";
    }

    ## Add simbuildargs from dut config
    my $simbuildArgs = $scoped_vars->{DutConfig}->{simBuildArgs};
    my $instOptsRef  = $flowptr->{scoped_vars}->{instOptsRef};
    my $simcmd       = $instOptsRef->{ $flowptr->{'flow_path'} };
    unshift(@{$simcmd}, split(/ /, $simbuildArgs)) if ($simbuildArgs);

    Flow::get_flow_opts($flowptr);

    my $mode = "";

    if ($flowptr->get_opt("mode") ne "") {
        $mode = $flowptr->get_opt("mode");
    } elsif (exists $scoped_vars->{DutConfig}->{mode}) {
        $mode = $scoped_vars->{DutConfig}->{mode};
    }

    if ($mode eq "64") {
        print_info("running in 64 bit mode\n");
        $ENV{SETUP_ON_64BITS} = 1;
    } elsif ($mode eq "32") {
        print_info("running in 32 bit mode\n");
        delete $ENV{SETUP_ON_64BITS};
    } elsif ($mode ne "") {
        print_error("invalid value for mode $mode");
    }

    $scoped_vars->{ARCHNAME} = ToolConfig_get_general_var("ARCHNAME");

    $instOptsRef = $scoped_vars->{instOptsRef};



    # Decide which stages to run based on dut.cfg
    # NOTE : These stages will be skipped even if they
    # are switched on via cmd line or SMAP
    # the only way to run these stages is to remove
    # them from skipStages in DutConfig
    if ($DutConfig{skipStages}) {
        foreach my $skipStage (@{ $DutConfig{skipStages} }) {
          #          push(@{$flowptr->{stage_control}},"-$skipStage");
            push(@{ $instOptsRef->{simbuild} }, "-s", $skipStage);
        }
    } ## end if ($DutConfig{skipStages...

    # Setup any scheduler specific info for this flow
    my $workArea =
      $ENV{MODEL_ROOT} . "/target/simbuild/" . $scoped_vars->{dut} .
      ".fcm";
    print_debug(
              "Updating the work area of the scheduler to $workArea");
    $scoped_vars->{scheduler}->set_workArea($workArea);
    my $date = `date "+%m_%d-%T"`;
    $date = main::mychomp($date);
    my $cloneName = &basename($ENV{MODEL_ROOT});
    my $buildName = "build_";
    $buildName .=
      $scoped_vars->{opt_logPrefix} ?
      "$scoped_vars->{opt_logPrefix}" :
      "${cloneName}_" . $scoped_vars->{dut};
    my $pid       = "_$$";
    my $pidlength = length($pid);

    if (length($buildName) + $pidlength > 100) {
        my $oldbuildName = $buildName;
        $buildName = $buildName . substr(0, 99 - $pidlength) . $pid;
        print_warning(
            "The buildName $oldbuildName$pid is too long. Will shorten it to 55 chars : $buildName"
        );
    } else {
        $buildName .= $pid;
    }

    $scoped_vars->{scheduler}->set_top_task_name($buildName);


    # read ace env and set %ace_env scoped var
    my %ace_env = source_ace_env($scoped_vars);
    $scoped_vars->{ace_env_ptr} = \%ace_env;
    $flowptr->{setup_ok} = 1;
} ## end sub simbuild_setup

#######################################################
# Sub     : simbuild_setup_dut
# Caller  : simbuild_setup
# Desc    : Reads the DutConfig file, updates
#         : %DutConfig based on simbuild scope variables
#         : and returns %DutConfig
# Inputs  : %opts : Flow manager opts hash
#         : $flowVars : Simbuild scope variables
# Outputs : \%DutConfig
########################################################
sub simbuild_setup_dut
{

    # flow pointer
    my $flowptr = shift;

    # flow variables
    my $scopedVars = $flowptr->{scoped_vars};

    #####################
    # Setup DutConfig
    ####################

    print_fatal(
               "Please specify the Device Under Test with '-dut'\n\n")
      if (!defined $scopedVars->{dut});

    # Check if configuration file exists, if not, skip CTE stage and use
    # basic RTLBuild switches
    my $rtlTarget;
    my $rtlDut;

    my @cfgDirs = @{ $scopedVars->{cfgDirs} };

    my $dut = $scopedVars->{dut};
    use vars '%DutConfig';

    if (defined &RTL_find("$dut.cfg", @cfgDirs, 'one', 'one') or
        defined &RTL_find("default.cfg", @cfgDirs, 'one', 'one')) {

        my $found_opt_dut_cfg =
          &RTL_find("$dut.cfg", @cfgDirs, 'one', 'one');
        if (defined $found_opt_dut_cfg) {
            (my $useCfg = $found_opt_dut_cfg) =~ s/$dut\.cfg\s*$//;

            require "$useCfg/$dut.cfg";
            DutConfig->import();

        } else {
            my $found_default_cfg =
              &RTL_find("default.cfg", @cfgDirs, 'one', 'one');
            (my $useCfg = $found_default_cfg) =~ s/default.cfg\s*$//;
            require "$useCfg/default.cfg";
            DutConfig->import();
            $DutConfig{topFub} = $scopedVars->{dut};
        } ## end else [ if (defined $found_opt_dut_cfg)

        $rtlTarget =
          defined $DutConfig{target} ? $DutConfig{target} :
                                       $DutConfig{topFub};
    } else {
        print_info("No " . $scopedVars->{dut} .
            " configuration found -- running without configuration settings"
        );
        $DutConfig{topFub} = $scopedVars->{dut};
        $rtlTarget = $scopedVars->{dut};
    } ## end else [ if (defined &RTL_find(...


    $scopedVars->{rtlTarget}  = $rtlTarget;

    return \%DutConfig;

} ## end sub simbuild_setup_dut


sub rtlbuild_setup
{
    my $flowptr = shift;
    my $opts    = $flowptr->{scoped_vars}->{opts};

    my $globalTargetRoot = $flowptr->{scoped_vars}->{targetRoot};
    my @var_decls =
      qw(
      $targetRoot
      $noWriteTargetConfig
    );

    $flowptr->add_scoped_vars(@var_decls);
    my $scoped_vars = $flowptr->{scoped_vars};

    # Writing to TargetConfig from the stages is locked.
    $scoped_vars->{noWriteTargetConfig} = 1;
    ##
    ## Add rtlbuildargs from dut config
    my $rtlbuildArgs = $scoped_vars->{DutConfig}->{rtlBuildArgs};
    my $instOptsRef  = $flowptr->{scoped_vars}->{instOptsRef};
    print_debug(
        sprintf(
            "Adding rtlbuild args %s to flow %s",
            $rtlbuildArgs, $flowptr->{'flow_path'}
        )
    );
    my $rtlcmd = $instOptsRef->{ $flowptr->{'flow_path'} };
    push(@{$rtlcmd}, @{ arrayize_args($rtlbuildArgs) });
    print_debug(
        sprintf(
            "Added rtlbuild args %s to flow %s",
            join(",", @$rtlcmd),
            $flowptr->{'flow_path'}
        )
    );

    ##
    ## Now, parse options for this flow again, after adding these additional args
    Flow::get_flow_opts($flowptr);

    my $flow_opts = $flowptr->{flow_opts};

    $scoped_vars->{targetRoot} =
        $globalTargetRoot . "/" . $scoped_vars->{rtlTarget} . "/" . &ToolConfig::get_facet(CUST);

    &RTL_mkDir([ $scoped_vars->{targetRoot} ]);
    &RTL_cd($scoped_vars->{targetRoot});

    # Set up the TargetConfig
    &FlowSpec::rtlbuild_read_tgtcfg($scoped_vars);


    $flowptr->{setup_ok} = 1;
} ## end sub rtlbuild_setup


# Uses ACE Utils to dump the ace environment and populate a hash for stages that need to be in the ACE env
sub source_ace_env {
    my ($scoped_vars) = @_;

    my %ace_env = ();

    my $targetRoot = $scoped_vars->{targetRoot};
    my $dut           = $scoped_vars->{dut};

    my $logDir = &dirname(ToolConfig::get_general_var("aceroot_dpath"));
    &RTL_mkDir(["$logDir/log"]);
    my $ace_env_log = "$scoped_vars->{dut}.ace_env.log";
    if (ToolConfig::get_general_var("logPrefix")){
        $ace_env_log = "$scoped_vars->{stageLogPrefix}ace_env.log";
    }
    my $ace = ACE_UTILS->new(ace_root_dir => ToolConfig::get_general_var("aceroot_dpath"), dut => $dut, ace_log_file => "$logDir/log/$ace_env_log");
    $ace->setup();

    my ($env_file_handle,$env_dump) = tempfile();;
    my $command = "/usr/bin/printenv > $env_dump";
    my $status = $ace->execute_cmd($command);

    if ($status != 0) {
        die "Could not dump environment to $env_dump!\n";
    }

    open my $fh, "$env_dump" or die "Cannot read env dump file $env_dump -- $!\n";
    while (my $line = <$fh>) {
        chomp($line);

        my ($env_var, $value) = split(/=/, $line, 2);
        $ace_env{$env_var} = $value;
    }
    close $fh;

    # clean up
    unlink($env_dump);

    return %ace_env;
} ## end of sub source_ace_env

# Sets up the RDL command
sub rdl_cmd {
    my $rdl_cmd = "make -C src/register/rdl";
    my $dut = &ToolConfig::get_facet("dut");
    my $cust = &ToolConfig::get_facet("CUST");

    if ( $cust eq "spr" ) {
        $rdl_cmd .= " all";
    } else {
        $rdl_cmd .= " ${cust}_all";
    }
    return "${rdl_cmd}";
}

# Sets up the collage command
sub collage_run_cmd {
    my $collage_cmd = "make -C tools/collage";
    my $dut = &ToolConfig::get_facet("dut");
    my $cust = &ToolConfig::get_facet("CUST");
    my $top_wrapper = &ToolConfig::get_facet("TOP_WRAPPER");


    my $cfg_hash = &ToolConfig::get_general_var("dsaiax_cfg_hash");

    if ( $top_wrapper ne "all" ) {
        $collage_cmd .= " ${top_wrapper}";
    } elsif ( $dut eq "soc" && $cust eq "spr" ) {
        $collage_cmd .= " top_${dut}"
    } elsif ( $dut eq "soc" ) { # Default to 'eip' for SoC
        $collage_cmd .= " ${dut}_${cust}"
    } else {
        $collage_cmd .= " ${cust}_${dut}_all";
    }
    return "${collage_cmd}";
}

# Sets up the ace command
sub ace_compile_cmd {
    my $compile = &ToolConfig::get_facet(COMPILE);
    my $ace_cmd = "ace";
    if ( $compile eq "clean" ) {
        $ace_cmd .= " -ccud";
    } else {
        $ace_cmd .= " -cud";
    }
    $ace_cmd .= " -partcomp";
    $ace_cmd .= " -enable_code_coverage" if ( &ToolConfig::get_facet("dut") ne "soc" );
    return $ace_cmd;
}

sub visa_copy_sigs_top_iax {

system ('cp $MODEL_ROOT/tools/visa/eip/iaxm2i64b60/iaxm2i64b60*.sig $MODEL_ROOT/tools/visa/eip/iax2i64b60/');
system ('cp $MODEL_ROOT/tools/visa/eip/iaxb2i64b60/iaxb2i64b60*.sig $MODEL_ROOT/tools/visa/eip/iax2i64b60/');
system ('cp $MODEL_ROOT/tools/visa/eip/iaxs2i64b60/iaxs2i64b60*.sig $MODEL_ROOT/tools/visa/eip/iax2i64b60/');
system ('cp -r $MODEL_ROOT/tools/visa/eip/iaxb2i64b60/sigfiles $MODEL_ROOT/tools/visa/eip/iax2i64b60/');

}
sub stage_visa_insert_post {
    my $dut = &ToolConfig::get_facet("dut");
    if ( $dut eq "dsa" ) {
       system('rm $MODEL_ROOT/tools/visa/spr/dsa/dsa_top.sig.1.id_cache');
    }
    elsif ($dut eq "iax") {
       system('rm $MODEL_ROOT/tools/visa/spr/iax_base/iax_base.sig.1.id_cache');
    }
}
sub stage_visa_insert_top_iax_post {
    my $dut = &ToolConfig::get_facet("dut");
    if ($dut eq "iax") {
       system('rm $MODEL_ROOT/tools/visa/spr/top_iax/iax_base.sig.1.id_cache');
    }
}
sub tool_args {
    my $tool             = shift @_;
    my $dut              = &ToolConfig::get_facet("dut");
    my $cust             = &ToolConfig::get_facet("CUST");
    my $topwrapper       = &ToolConfig::get_facet("TOP_WRAPPER");
    my $cfg_hash         = &ToolConfig::get_general_var("dsaiax_cfg_hash");
    my $tool_args        = "";

    # Add the relavent switches to the dut/facet combo
    foreach my $dut_name ( keys %{$cfg_hash} ) {
        next if ( $dut ne $dut_name );
        
        foreach my $cust_name ( keys %{$cfg_hash->{$dut_name}} ) {
            next if ( $cust ne $cust_name );
            
            foreach my $model ( keys %{$cfg_hash->{$dut_name}{$cust_name}{MODELS}} ) {
                if ( (exists $cfg_hash->{$dut_name}{$cust_name}{MODELS}{$model}{TOP_WRAPPER}) &&
                     (exists $cfg_hash->{$dut_name}{$cust_name}{MODELS}{$model}{WRAPPERS}) ) {
                    
                    # If the TOP_WRAPPER is default to 'all' then use all wrappers in the model, otherwise match the topwrapper exactly
                    if ( ($topwrapper eq "all") || ($cfg_hash->{$dut_name}{$cust_name}{MODELS}{$model}{TOP_WRAPPER} eq $topwrapper) ) {
                        
                        foreach my $wrapper ( keys %{$cfg_hash->{$dut_name}{$cust_name}{MODELS}{$model}{WRAPPERS}} ) {
                            if ( $tool eq "lintra" ) {
                                $tool_args .= $wrapper . ",";
                            } 
                            elsif($tool eq "spyglass") {
                                $tool_args   .= $wrapper."_cdc_model" . ",";
                            }
                            elsif($tool eq "visa_gen_rtl") {
                                $tool_args   .= " -en__${wrapper}_rtl_lib_VISA_INSERTION";
                            } 
                        }
                        # Remove trailing comma if applicable
                        #$tool_args =~ s/,$//;
                    }
                }
            }
            # Remove trailing comma if applicable
            $tool_args =~ s/,$//;
        }
    }

    return   $tool_args;
}

sub wrapper_upf_file {
    my $wrapper = &ToolConfig::get_facet("WRAPPER");
    my $upf_file = "";
    if ( $wrapper eq "dsa" ) {
       $upf_file = "dsa_top.upf";
    }
    else
    {
       $upf_file = $wrapper.".upf";
    }
    return $upf_file;
}

sub top_design_model {
    my $wrapper = &ToolConfig::get_facet("WRAPPER");
    my $top_model = "";
    if ( $wrapper eq "dsa" ) {
       $top_model .= "dsa_top";
    }
    else
    {
       $top_model .= $wrapper;
    }
    return $top_model;
}

#######################################################
# Sub     : rtlbuild_read_tgtcfg
# Caller  : rtlbuild_setup
# Desc    : Reads the TargetConfig file and updates the
#         : local TargetConfig scope var to point to it
# Inputs  : $flowVars : Simbuild scope variables
# Outputs :
########################################################

sub rtlbuild_read_tgtcfg
{

    my $flowVars   = shift;
    my $targetRoot = $flowVars->{targetRoot};

    # Read in the TaC.pm
    my %TargetConfig;

    RTL_readTargetConfig($targetRoot, \%TargetConfig)
      if ((-e "$targetRoot/perllib/TargetConfig.pm"));
    $flowVars->{TargetConfig} = \%TargetConfig;
} ## end sub rtlbuild_read_tgtcfg

#####################################
# Pre/Post flow code
# and other user code
#####################################

sub simbuild_pre_flow
{

    my %args     = @_;
    my $flowVars = $args{flowVars};
    my $opts     = $flowVars->{opts};

    ###############
    #pre flow setup
    ################
    my $targetRoot = $flowVars->{targetRoot};
    &RTL_mkDir([ $targetRoot . "/" . $opts->{flow}->[0] ]);
    &RTL_mkDir(["$targetRoot/log"]);
    &RTL_mkDir(["$targetRoot/data"]);
} ## end sub simbuild_pre_flow

sub rtlbuild_pre_flow
{
    my %args     = @_;
    my $flowVars = $args{flowVars};
    my $opts     = $flowVars->{opts};

    my $targetRoot = $flowVars->{targetRoot};
    &RTL_mkDir(["$targetRoot/log"]);


    ###############
    #Setup
    ###############

    use Sys::Hostname;
    $flowVars->{TargetConfig}{ $flowVars->{ARCHNAME} }{machine_name} =
      hostname();
    $flowVars->{TargetConfig}{general}{dut} = $flowVars->{dut};

    ######################
    # Write TargetConfig
    ######################
    RTL_mkDir(["$targetRoot/perllib"]);
    $RTLUtils::noWriteTargetConfig = 0;
    RTL_writeTargetConfig($targetRoot, $flowVars->{TargetConfig});
    &RTL_cd($targetRoot);

    return 0;

} ## end sub rtlbuild_pre_flow

###########################################################
# debug / helper functions
###########################################################
sub print_hash {
    my ($hashRef, $tabs) = @_;
    my $lines = '';
    if(!defined($hashRef)) {
        return "<undef>";
    }
    if(ref($hashRef) eq 'HASH') {
        $lines .= "{\n";
        foreach my $key (sort keys %$hashRef) {
            $lines .= "$tabs   '$key' => ".
                print_hash($hashRef->{$key}, "$tabs    ").
                ",\n";
        }
        $lines .= "$tabs}";
    } elsif(ref($hashRef) eq 'ARRAY') {
        if(scalar(@$hashRef) == 0) {
            $lines .= "[]";
        } else {
            $lines .= "[\n";
            foreach my $element (@$hashRef) {
                $lines .= "$tabs   ".print_hash($element, "$tabs    ")."\n";
            }
            $lines .= "$tabs]";
        }
    } elsif(ref($hashRef) eq 'SCALAR') {
        $lines .= "\"$$hashRef\" ",
    } elsif(ref($hashRef) eq '') {
        $lines .= "\"$hashRef\"",
    } else {
        $lines .= "(".ref($hashRef)." reference)\n",
    }
}

## force links to be relative whenever possible
sub cleanup_links {
    my ($dir) = @_;
    if(-e $dir) {
        opendir(DIR, $dir);
        my @files = readdir(DIR);
        closedir(DIR);
        foreach my $file (@files) {
            if(-l "$dir/$file") {
                my $linked_file = readlink("$dir/$file") ;
                print_info "cleanup_links: $dir/$file is a link to $linked_file\n";
                if($linked_file =~ s:$dir/:./:) {
                    print_info "Replacing link $dir/$file -> $dir/$linked_file with relative link $linked_file\n";
                    system("/bin/rm $dir/$file; /bin/ln -s $linked_file $dir/$file");
                }
            }
        }
    } else {
        print_info "cleanup_links: $dir not found\n";
    }
}

sub print_selected_env_cfgs {
    (local *SF, my @selected_vars) = @_;
    foreach my $selected_var (@selected_vars) {
        if(defined($ENV{$selected_var})) {
            print SF "\$ENV{$selected_var} = $ENV{$selected_var};\n";
        } else {
            print SF "\$ENV{$selected_var} = undef;\n";
        }
    }
}

sub print_selected_tool_cfgs {
    (local *SF, my @selected_tools) = @_;
    foreach my $selected_tool (@selected_tools) {
        print SF "\$ToolConfig_tools{$selected_tool} = ".
            Data::Dump::pp(ToolConfig::ToolConfig_get_tool($selected_tool)).";\n\n";
    }
}

sub print_setup_log {
    my ($self, $check_keys, $check_env_vars, $toolcfg_tool_entries, $setup_toolcfg_tools) = @_;
    $check_keys = ['dut', 'targetRoot' ] if(!defined($check_keys));
    $check_env_vars = [] if(!defined($check_env_vars));
    my $name = $self->get_name();
    my $instname = $self->get_instpath();
    my $logprefix = $self->{log_prefix};
    $logprefix = '' if(!defined($logprefix));
    my $dut = $self->{dut};
    if(!defined($dut)) {
        $dut = $self->{scoped_vars}->{dut};
        $dut = 'dut-independent' if(!defined($dut));
    }
    my $targetRoot = $self->{targetRoot};
    if(!defined($targetRoot)) {
        $targetRoot = $self->{scoped_vars}->{targetRoot};
    }
    #"log/$logprefix.stage_setup.log"
    if(-e "$dut/log") {
        $self->{my_setup_log} = "$dut/log/$logprefix.stage_setup.log";
    } else {
        $self->{my_setup_log} = "log/$logprefix.stage_setup.log";
    }
    $ENV{STAGE_SETUP_LOG} = $self->{my_setup_log};
    $ENV{STAGE_SETUP_OPTIONS} = "";
    #$self->register_logfile([$self->{my_setup_log}]);
    print_info "Creating setup log $self->{my_setup_log}\n";
    open(SF, ">$self->{my_setup_log}");
    print SF "Stage Name: $name\n";
    print SF "Stage Instance: $instname\n";
    print SF "Stage dut: $dut\n";
    print SF "Stage targetRoot: $targetRoot\n\n";

    foreach my $selected_key (@$check_keys) {
        print SF "\$self->{$selected_key} = ".Data::Dump::pp($self->{$selected_key}).";\n";
    }

    print SF "Before stage env setup:\n";
    print_selected_env_cfgs(*SF, @$check_env_vars);
    print SF "\n";

    print SF "Stage Options:\n";
    foreach my $opt (sort keys %{$self->{opts}}) {
        if(ref($self->{opts}->{$opt}) eq 'ARRAY') {
            print SF "\toption $opt: ['".join("', '",@{$self->{opts}->{$opt}})."']\n";
            $ENV{STAGE_SETUP_OPTIONS} .=
                "opt{$opt}=['".join("', '",@{$self->{opts}->{$opt}})."'], ";
        } else {
            print SF "\toption $opt: '$self->{opts}->{$opt}'\n";
            $ENV{STAGE_SETUP_OPTIONS} .=
                "opt{$opt}='$self->{opts}->{$opt}', ";
        }
    }
    print SF "\n";

    print_selected_tool_cfgs(*SF, (@$setup_toolcfg_tools, @$toolcfg_tool_entries));
    print SF "\n";
    select SF;  $| = 1;
    ToolConfig::ToolConfig_setup_tools($setup_toolcfg_tools, 1, undef);
    select STDOUT;  $| = 1;
    print SF "\n";

    close(SF);
    ## cleanup the setup log file
    my $replace_cmd = "/usr/intel/bin/replace";
    foreach my $var (('MODEL_ROOT', 'RTL_CAD_ROOT', 'RTL_PROJ_TOOLS', 'RTL_PROJ_BIN')) {
        $replace_cmd .= " '$ENV{$var}' '\$ENV{$var}'" if(defined($ENV{$var}));
    }
    my $status = RTL_execCmd("$replace_cmd  -- $self->{my_setup_log}");
}

sub stage_log_cleanup {
    my $self = shift;
    my $status = 0;
    print_info "stage_log_cleanup started at ".localtime()."\n";
    my $cmd = "/usr/intel/bin/replace";
    foreach my $var (('MODEL_ROOT', 'RTL_CAD_ROOT', 'RTL_PROJ_BIN', 'RTL_PROJ_TOOLS',
                      'USER', 'IP_RELEASES',
                      'REMOTEHOST', 'HOSTNAME', 'DISPLAY', 'HOST')) {
        $cmd .= " '$ENV{$var}' '\<SIMBUILD:$var\>'" if(defined($ENV{$var}));
    }
    my $logs = '';
    foreach my $log((@{$self->{logs}})) {
        next if($log eq "$self->{flow_vars}->{targetRoot}/log/$self->{log_prefix}.log");
        if (-e $log) {
            $logs .= "$log ";
        }
    }
    RTL_execCmd("$cmd -- $logs") if($cmd ne "/usr/intel/bin/replace" && $logs ne '');
    print_info "stage_log_cleanup done at ".localtime()."\n";
    return $status;
}


1;
