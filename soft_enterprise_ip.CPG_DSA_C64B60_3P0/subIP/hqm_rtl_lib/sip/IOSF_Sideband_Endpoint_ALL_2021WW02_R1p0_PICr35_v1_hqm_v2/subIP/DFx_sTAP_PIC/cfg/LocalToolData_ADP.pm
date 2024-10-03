# DO NOT REMOVE!!!  Learn to code warning-free perl instead.
use warnings FATAL => 'all';
package ToolData;

#$ToolConfig_tools{ctech_library}{VERSION}        = "c3v18ww08d_hdk150";
#$general_vars{"PROCESS"}                              = 'p1273';
#$general_vars{"CTECH_TYPE"}                           = 'd04';
#$general_vars{"PROCESS_NAME"}                         = 'p1273';
#$ToolConfig_tools{coretools}{VERSION}        = "N-2017.12-SP1";
$ToolConfig_tools{collage}{VERSION}        = "3.7";


my %LocalToolData = (
	stage_collage_build => {
                PATH => "&get_tool_path('rtltools')/stages/collage_build.pm",
                OTHER => {
                     collage_build_enable => "on",
                },
         },
    collage  => {
        OTHER => {
            collage_build_ip => "stap",
            collage_build_script => "tools/collage/build/builder.stap.tcl",
        },
    },

# Adding below to remove the manual add of switch -lp for FEV licence 

 tsa_dc_config => {
      'SETUP' => {
	 -passthru_vars   => [ 'IP_ROOT','PROCESS','CTECH_LIBRARY','CTECH_TYPE', 'IP_RELEASE', 'ACE_ENG', 'ACE_PWA_DIR', 'MODEL_ROOT', 'REPO_ROOT' ],
      
       vclp_build => {
         -args => '-ASSIGN -mc=stap_vclp_model -vlog_opts +define+INTEL_SVA_OFF',
       },
       vclp_test => {
         -args => '-results $IP_ROOT/results/my_vclp_area',
      
       }
      },
      'DC' => {
#	 -unit_dc_binary   => "dc_shell-t -topo",
	 -setenv => {},
	 -unsetenv => "SD_TARGET_MAX_LIB LIB_VARIANT",
      },
      'FV' => {
	 "-fv_binary" => "\${FEV_FLOW_PATH}/bin/runFEV",
	 "-setenv" => {
	     FEV_BLOCKS_INFO => "unit"
	 },
	 "-unsetenv" => "ACE_RTL_SIM",
	 "-workdir"  => "fev",
	 "-switches" => "-lp",
      },
      lintra_build => {
	 -command => "ace -ccolt -mc stap_lint_model",
      },
      lintra_elab => {
		  -test_dir => 'lintra',
            -test_suffix => '',
	 -command => "ace -sc -noepi",
      },
      spyglass_build => {
	 -command => 'ace -ccsg -vlog_opts "+define+INTEL_SVA_OFF"',
      },
      spyglass_lp => {
         -args => '-sc -vlog_opts +define+INTEL_SVA_OFF',
      },
      sgdft => {
         drc => {
	    -ace_args => '-noenable_runsim_postsim_checks -noenable_onda_postchecker',
         },
      },
      'power_artist' => {
	 -unsetenv => "",
	 -setenv => { LM_PROJECT => "MCD_CPDM_CANNONLAKE-PCH-LP", },
      },
      'SYN_CALIBER' => {
#	 -extra_commands1 => [
#                 'setenv CIM_CFG /p/hdk/cad/stdcells/d04/15ww09.1_d04_prj_hdk73_SD1.7.10/cim/cim.cfg.tcl',
#                 'setenv CIM_DB /p/hdk/cad/stdcells/d04/15ww09.1_d04_prj_hdk73_SD1.7.10/cim/cim.db.tcl',
#         ],
      },
      zirconqa => {
      },
   },


tsa_finalized => {
       finalized => {
        stap => {
              -lib_variant => 'ln',
		-stdlib_type => 'd04',
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
