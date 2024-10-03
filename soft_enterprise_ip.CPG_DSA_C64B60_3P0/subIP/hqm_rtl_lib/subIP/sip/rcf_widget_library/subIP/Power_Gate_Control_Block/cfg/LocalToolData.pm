use warnings FATAL => 'all';

package ToolData;

my %LocalToolData = (
    runtools =>{
        OTHER => {
            ENABLE_NBCLASS_FROM_DUTCONFIG => 1,
        },
    },

    zirconqa => {
        VERSION => '2.10.01',
    },

    zirconqarules => {
        VERSION => '2.10.01',
        PATH => "$RTL_PROJ_TOOLS/zirconqarules/master/&get_tool_version()",
    },

    ace =>{      
        OTHER => {
            results => "$MODEL_ROOT/target/$ENV{DUT}/$ENV{CUST}/aceroot/results",
        },
    },

    tsa_shell => {
        tsetup_add => ['dvt' ],
        tsetup_rem => ['vggnu' ],
        setenv => [
            'LM_PROJECT                 EIG_PMC',
            'CTECH_LIB_NAME             CTECH_v_rtl_lib',
            'SNPS_USE_NOVAS_HOME        1',
            'FSDB_ENV_MAX_GLITCH_NUM    0', # To enable viewing glitches in Debussy
            'NOVAS_FSDB_ALL             1', # To enable dumping all variable types - including structs
            'PLI_NonStdMem              1', # To enable proper 2D array dumping
            'ALT_VCS_HOME               ${VCS_HOME}', # for VCST
            'CDC_PREFERENCE_BIT_RECON   TRUE', # Not sure what this does but is required to be set to run CDC
            'EMUL_CFG_DIR               $REPO_ROOT/cfg/ace/effm_flows',
            'EMUL_IP_NAME               pgcbunit',
            'LD_LIBRARY_PATH            /usr/lib64:${LD_LIBRARY_PATH}'           
        ],
    },

    spyglass_cdc => {
        ENV => {
            SPYGLASS_METHODOLOGY_CDC => "$RTL_PROJ_TOOLS/spyglass_methodology_cdc/master/&get_tool_version()",
        }
    },
    
    tsa_dc_config => {
        spyglass_build => {
            -command => "ace -rrsc spyglass_comp -noegc",
        },
        lintra_build => {
            -command => "ace -ccolt -mc lintra_tooltb",
        },
        lintra_elab => {
            -command => "ace -sc -noenable_runsim_postsim_checks",
            -test_suffix => ":FLG",
            -test_dir => "lintra/",
        },
        #dc_sip => {
        DC => {
            -unsetenv => "SD_TARGET_MAX_LIB LIB_VARIANT",
        },
        #fv_sip =>{
        FV => {
            -setenv => {
                ENABLE_FEV_RUN => "1",
            },
            -switches  => '',
        },
    },    

    tsa_finalized => {
        finalized => {
            ClockDomainController => {
                -dut                => ['pgcb_collection'],
                -owner              => ["yjkim1"],
                -stdlib_type        => 'd04',
                -block_type         => "unit",
                ace_lib             => "lintra_tooltb_lib",
                project             => "SIP",
                -enable_gk_turnin   => 0,
                -enable_sg_dft      => 0,
                -lib_variant        => 'ln',
                -rm_ctech_files     => [".*\/ctech_lib_.*.v"],
                -defines            => ['MEM_CTECH', 'NO_PWR_PINS', 'INTEL_SVA_OFF', ],
                -rm_defines         => ['functional', 'VCSSIM', 'META_OFF', 'ASSERT_ON'],
                -files_first        => [],
            },

            pgcbunit => {
                -dut                => ['pgcb_collection'],
                -owner              => ["yjkim1"],
                -stdlib_type        => 'd04',
                -block_type         => "unit",
                ace_lib             => "lintra_tooltb_lib",
                project             => "SIP",
                -enable_gk_turnin   => 0,
                -enable_sg_dft      => 0,
                -lib_variant        => 'ln',
                -rm_ctech_files     => [".*\/ctech_lib_.*.v"],
                -defines            => ['MEM_CTECH', 'NO_PWR_PINS', 'INTEL_SVA_OFF', ],
                -rm_defines         => ['functional', 'VCSSIM', 'META_OFF', 'ASSERT_ON'],
                -files_first        => [],
            },
        },
    },
);

&hash_merge(
    -type => 'APPEND',
    -src  => \%LocalToolData,
    -dest => \%ToolConfig_tools,

);

1;

