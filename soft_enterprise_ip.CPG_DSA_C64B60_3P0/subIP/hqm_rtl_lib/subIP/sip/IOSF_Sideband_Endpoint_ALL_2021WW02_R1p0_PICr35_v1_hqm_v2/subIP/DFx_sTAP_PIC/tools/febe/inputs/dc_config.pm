package dc_config;

sub get_data() {
    my $data = {
        'SETUP' => {
            -setup_options => "-d -block stap",
            -passthru_vars   => [ 'IP_ROOT','PROCESS', 'CTECH_LIBRARY', 'GLOBAL_CTECH_VER' , 'IP_RELEASE', 'ACE_ENG', 'ACE_PWA_DIR', 'MODEL_ROOT', 'REPO_ROOT', 'PROCESS_NAME', ],
        },
		  'dc_sip' => {
                      -setenv => {
                       },
				-unsetenv => "SD_TARGET_MAX_LIB LIB_VARIANT",
		  },
        'fv_sip' => {
            -setenv    => {
                       },
        },
        'lintra_build' => { 
				-command => "ace -ccolt -mc stap_lint_model",
		  },
        'lintra_elab'  => {
            -command     => "ace -sc -noepi",
          #  -test_dir    => "lintra/",
          #  -test_suffix => "",
          #  -ace_args => '-noenable_runsim_postsim_checks',
        },
        'spyglass_build' => {
				-command => 'ace -ccsg -vlog_opts "+define+SVA_OFF"',
        },
        'spyglass_lp' => {
            #-args => '-ASSIGN -mc=spyglass_pncra,spyglass_pncrb -static_check_cfg_file=tools/isaf/LBG/pncra/scripts/ace_static_check.cfg -noenable_runsim_postsim_checks -spyglass_goals lp_fe/power_verif_noninstr',
				-args => '-sc -vlog_opts +define+SVA_OFF',
            #-test_dir    => "spyglasslp/",
            #-test_suffix => "",
        },
       'sgdft' => {
           drc => {
               -ace_args => '',
           },
       },
        'power_artist' => {
          -unsetenv => "",
		  -setenv => { LM_PROJECT => "EIG_INFRA-BA ", },
		  #-setenv => { LM_PROJECT => "MCD_CPDM_ICLLAKE-PCH-LP", },
          -ctech_type => "d04",
          -ctech_variant => "wn",
        },

        zirconqa => {
            -ip   => '',
            -vari => '',
            -proj => '',
            -ovf  => '',
            -app  => '',
            -ms   => '',
        },
    };

    return $data;
}

1;

