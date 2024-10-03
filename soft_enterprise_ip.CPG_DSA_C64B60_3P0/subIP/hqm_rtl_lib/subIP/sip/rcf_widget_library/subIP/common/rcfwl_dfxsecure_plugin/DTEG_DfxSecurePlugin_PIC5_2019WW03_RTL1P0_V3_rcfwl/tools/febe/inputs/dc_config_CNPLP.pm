package dc_config_CNPLP;

sub get_data() {
    my $data = {
        'SETUP' => {
#            -setup_milestone => 'si74a0p00 -pr 1274 -pr_rev 0x0r1',
	 -setup_project   => "siphdk",
	    -setup_milestone => "SI73A0P00_TS14WW41DTSL -pr 1273",
	    -setup_options   => "-d -block dfxsecure_plugin",
            
		-passthru_vars   => [ 'IP_ROOT', 'IP_RELEASE', 'ACE_ENG', 'ACE_PWA_DIR', 'MODEL_ROOT', 'REPO_ROOT' ],
           # block_opt        => "-b",
	   # -setup_options -d -w none -ot $ENV/tmp/sprusty/ip-gpio-cnllp-sip14-febe-14ww41.5/config/dc/ot/CNPLP.ot
	   # -extra_commands => ["cp --remove-destination $ENV{REPO_ROOT}/tools/syn/scripts/block_setup.tcl \$WARD/syn/scripts/"],
        },
        'dc_sip' => {
            -setenv => {
                'KIT_PATH'         => '/p/hdk/cad/kits_p1273/p1273_14.4.1',
                'RDT_COMMON_PATH'  => '/p/hdk/cad/rdt/rdt_14.4.1',
              #  'RDT_PROJECT_TYPE' => 'soc',
            },
            -unsetenv => "SD_TARGET_MAX_LIB LIB_VARIANT",
        },
        'fv_sip' => {
            -setenv    => {
                'KIT_PATH'         => '/p/hdk/cad/kits_p1273/p1273_14.4.1',
                'RDT_COMMON_PATH'  => '/p/hdk/cad/rdt/rdt_14.4.1',
                #'RDT_PROJECT_TYPE' => 'soc',
                'FEV_CONFORMAL'    => '/p/hdk/cad/cadence/conformal/14.10-s220',
            },
        },
        'lintra_build' => { 
				-command => 'ace -ccolt -ASSIGN -mc=dfxsecure_plugin_lint_model -lira_compile_opts "-mfcu" -pwa pwa_lint -lintra_exe_opts " -r 50514  -r 60088  -r 68094 -r 68099"',
		  },
        'lintra_elab'  => {
            -command     => 'ace -sc -t lintra/dfxsecure_plugin -pwa pwa_lint -lintra_exe_opts " -r 50514  -r 60088  -r 68094 -r 68099"',
        },
        'spyglass_build' => {
				-command => 'ace -ccsg -vlog_opts "+define+SVA_OFF"',
        },
        'spyglass_lp' => {
            #-args => '-ASSIGN -mc=spyglass_pncra,spyglass_pncrb -static_check_cfg_file=tools/isaf/LBG/pncra/scripts/ace_static_check.cfg -noenable_runsim_postsim_checks -spyglass_goals lp_fe/power_verif_noninstr',
				-ace_args => '-sc -vlog_opts +define+SVA_OFF',
        },
       'sgdft' => {
           drc => {
               -ace_args => '-noenable_runsim_postsim_checks',
           },
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

