# DO NOT REMOVE!!!  Learn to code warning-free perl instead.
use warnings FATAL => 'all';
package ToolData;

my $gk_user = ($ENV{USER} eq "gksip")? 1:0;
$general_vars{NBPOOL} = ($gk_user)? 'iind_critical' : 'iind_normal';
$general_vars{NBCLASS} = q(SLES11&&4G);
$general_vars{NBQSLOT} = ($gk_user)? '/DTEG/IP' : '/DTEG/IP';

$ToolConfig_tools{zirconqa}{VERSION} = "2.10.07";
$ToolConfig_tools{zirconqarules} = {
 PATH    => "/p/hdk/rtl/proj_tools/zirconqarules/master/2.10.07",
 VERSION => "2.10.07",
};

my %LocalToolData = (
  
   tsa_shell => {
      setenv => [
	 "UVM_HOME         /p/com/eda/accellera/uvm/1.2", 
	 "XVM_HOME         /p/com/eda/intel/xvm/1.0.3", 
	 "SIP_PROJECT      dfx",
	  # ACE
	 'PROJECT_BASE     $IP_ROOT',
	 'CTECH_LIB_NAME   CTECH_v_rtl_lib',
	 'ACE_ENG_BASE     $PROJECT_BASE',
	 'LIB_AREA         $PROJECT_BASE/verif/lib',
	 'ACE_RTL_SIM      vcs',
	 'ACE_SINGLE_TOP_MODULE ACE_SINGLE_TOP_MODULE',
	 # Collage
	 'COLLAGE_WORK     $IP_ROOT/tools/collage',
	 'COLLAGE_BATCH_MODE  1',
	 # Debussy/Verdi variable to de-sensitize capitalization of VHDL instances in signal path
         'NOVAS_WAVE_CASE_INSENSITIVE',
         'FSDB_ENV_MAX_GLITCH_NUM   0',
         'DW_LICENSE_OVERRIDE       DESIGNWARE-REGRESSION',
         'BFM_BASE_DIR              /p/sip/sim-env/sip/',
	 # GCC
	 'GCC_LIB_VER      gcc-4.7.2',
	 # lintra
         'SIP_QA_MODULE    lintra',
         'LINTRA_REPORT    $IP_ROOT/tools/lint/lintra.rpt',
	 # EFFM
         'EMUL_CFG_DIR        $REPO_ROOT/ace/effm_flows',
         "EMUL_TOOLS_DIR      &get_tool_path(effm)/effm_tools",
         'EMUL_RESULTS_DIR    $REPO_ROOT/results/emul',
         #'PATH                $EMUL_TOOLS_DIR:$PATH',
      ],
	  #source => [
#	 '#$IP_ROOT/ace/emulation/emulation.env',
      #],
      tsetup => [
	 "synplifypro      &get_tool_version(synplifypro)"
      ],
      tsetup_rem => [
	   "vggnu"
      ],

   },

   tsa_dc_config => {
      'SETUP' => {
	 -passthru_vars   => [ 'IP_ROOT','PROCESS','CTECH_LIBRARY','CTECH_TYPE', 'IP_RELEASE', 'ACE_ENG', 'ACE_PWA_DIR', 'MODEL_ROOT', 'REPO_ROOT' ],
      '-be_tool_override' => {'fishtail' => '2017.07g','proj_ft' => '18.04.013',}
        },
      
       vclp_build => {
         -args => '-ASSIGN -mc=stap_vclp_model -vlog_opts +define+INTEL_SVA_OFF',
       },
       vclp_test => {
         -args => '-results $IP_ROOT/results/my_vclp_area',
       },
	  'FISHTAIL' => {
       -command => '$PROJ_FT/bin/soc_ft.pl -block $DBB -fe2be_area $WARD/.. -formal -sip_mode -use_behavioral',
       -extra_commands_post => ["\$REVIEW/bin/review.pl -b \$DBB -fe2be",
                                       "\$PROJ_FT/utils/gen_parsed_rpt.tcl"],},

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
	 "-switches" => "",
	 #"-switches" => "-lp", Uncomment this line if you are running FEV with UPF
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

   # please move all finalized/<unit>_final_cfg data to this hash 
   # (except -lib_variant & -stdlib_type as these are meant to be CUST specific information)

   tsa_finalized => {
       finalized => {
        stap  => {
    		-owner           => [ '' ],
    		project          => 'SIP',
    		ace_lib          => 'stap_rtl_lib',
    		-opus_lib        => '',
    		-dut             => ['stap'],
    		-enable_sg_dft   => 1,
    		-enable_gkturnin => 1,
			-rm_ctech_files  => [".*\/ctech_lib_.*.v"],
			#	-rm_ctech_files  => ['\/ctech_lib_*.v', '/p/hdk/cad/ctech/c2v16ww47e_hdk141/source/v/ctech_lib_clk_buf.sv', '/nfs/site/disks/hdk_cad_3/cad/ctech/c3v18ww10e_hdk150/source/v/ctech_lib_clk_buf.sv','/nfs/site/disks/hdk_cad_3/cad/ctech/c3v18ww10e_hdk150/source/v/ctech_lib_dq.sv','/nfs/site/disks/hdk_cad_3/cad/ctech/c3v18ww10e_hdk150/source/v/ctech_lib_mux_2to1.sv','/nfs/site/disks/hdk_cad_3/cad/ctech/c2v17ww14b_hdk144/source/v/ctech_lib_clk_buf.sv','/nfs/site/disks/hdk_cad_3/cad/ctech/c2v17ww14b_hdk144/source/v/ctech_lib_*.sv','/nfs/site/disks/hdk_cad_3/cad/ctech/c2v17ww14b_hdk144/source/v/ctech_lib_dq.sv','/nfs/site/disks/hdk_cad_3/cad/ctech/c2v17ww14b_hdk144/source/v/ctech_lib_mux_2to1.sv',
#],
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
