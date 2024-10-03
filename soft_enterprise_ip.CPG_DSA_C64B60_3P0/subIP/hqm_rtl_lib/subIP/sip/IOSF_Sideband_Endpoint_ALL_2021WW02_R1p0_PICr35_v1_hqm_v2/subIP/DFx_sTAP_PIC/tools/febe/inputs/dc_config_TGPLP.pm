package dc_config_TGPLP;

sub get_data {
    my $data = {
        'SETUP' => {
			-passthru_vars   => [ 'IP_ROOT','PROCESS', 'CTECH_TYPE', 'CTECH_LIBRARY', 'GLOBAL_CTECH_VER' , 'IP_RELEASE', 'ACE_ENG', 'ACE_PWA_DIR', 'MODEL_ROOT', 'REPO_ROOT', 'PROCESS_NAME', ],
            -setup_source    => '/p/hdk/bin/setproj',
            -setup_milestone => 'HDK1.4.3_73P1',
	    -extra_commands => [
                    'if ($DBB != "") then',
                    '    /p/hdk/pu_tu/prd/configulate/`getTv configulate`/bin/configulate_all.pl',
                    #"    cp $ENV{MODEL_ROOT}/tools/syn/TGL/stap/inputs/stap.lib_path.xml \$WARD/collateral/cfg",
                    'endif',
            ], 
            -populate_input_fpath => [
                "$ENV{MODEL_ROOT}/tools/febe/inputs/populate/febe_filelist.yaml",
            ],

			#    -be_tool_override => {
        	#          'stdcells/e05' => '16ww19.1_e05_h.0_cnlgt',
        	#          'pv_conditions_data' => 'chdk74/TGL/16.03.13',
        	#          'lib_ver_data' => 'chdk74/TGL/16.03.35',
        	#          'lib_attribute_data' => 'chdk74/TGL/16.03.08',
        	#          'lib_setting_data' => 'chdk74/TGL/16.01.16',
        	#          'lib_derate_data' => 'chdk74/TGL/16.03.11',
        	#          'flow_settings_data' => 'chdk74/TGL/16.04.10',
			#},
        },
        'SYN_CALIBER' => {
			-extra_commands1 => [
				#	   'setenv CIM_CFG /p/hdk/cad/stdcells/e05/16ww19.1_e05_h.0_cnlgt_icl_16ww23.4/cim/e05_cim.cfg.tcl',
				#'setenv CIM_DB /p/hdk/cad/stdcells/e05/16ww19.1_e05_h.0_cnlgt_icl_16ww23.4/cim/e05_cim.db.tcl',
            ],
        },
    };
    return $data;
}

1;
