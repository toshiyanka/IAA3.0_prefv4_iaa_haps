# DO NOT REMOVE!!!  Learn to code warning-free perl instead.
use warnings FATAL => 'all';
package ToolData;

$ToolConfig_tools{zirconqa}{VERSION} = "2.10.07";
$ToolConfig_tools{zirconqarules} = {
 PATH    => "/p/hdk/rtl/proj_tools/zirconqarules/master/2.10.07",
 VERSION => "2.10.04.P2",
};

my %LocalToolData = (

   tsa_shell => {
      setenv => [
	 "UVM_HOME         /p/com/eda/accellera/uvm/1.2", 
	 "SIP_PROJECT      dfx",
	  # ACE
	 'PROJECT_BASE     $IP_ROOT',
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
	 'GCC_LIB_VER      gcc-64',
     # sglint
	 'SGLINT_MODEL_ROOT $IP_ROOT',
     # lintra
         'SIP_QA_MODULE    lintra',
         'LINTRA_REPORT    $IP_ROOT/tools/lint/lintra.rpt',
	 # EFFM
         'EMUL_CFG_DIR        $REPO_ROOT/ace/effm_flows',
         "EMUL_TOOLS_DIR      &get_tool_path(effm)/effm_tools",
         'EMUL_RESULTS_DIR    $REPO_ROOT/results/emul',
         'XVM_HOME /p/com/eda/intel/xvm/1.0.3',
         'OVM_HOME /p/hdk/rtl/cad/x86-64_linux30/ovm/ovm/2.1.2_2a_ml',
	 'UVM_HOME /p/com/eda/accellera/uvm/1.2',
         #'PATH                $EMUL_TOOLS_DIR:$PATH',
      ],
	  #  source => [
	  # #'$IP_ROOT/ace/emulation/emulation.env',
      #  ],
      tsetup => [
	 "synplifypro      &get_tool_version(synplifypro)"
      ],
   },

   tsa_dc_config => {
      'SETUP' => {
	 -passthru_vars   => [ 'IP_ROOT','PROCESS','CTECH_LIBRARY','CTECH_TYPE', 'IP_RELEASE', 'ACE_ENG', 'ACE_PWA_DIR', 'MODEL_ROOT', 'REPO_ROOT' ],
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
	 "-switches" => "",
      },
      lintra_build => {
	 -command => "ace -ccolt -mc dfxsecure_plugin_lint_model",
      },
      lintra_elab => {
	   -command => "ace -sc -noepi",
	   -test_dir => 'lintra',
       -test_suffix => '',
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
        dfxsecure_plugin  => {
    		-owner           => [ '' ],
    		project          => 'ANY',
    		ace_lib          => 'dfxsecure_plugin_rtl_lib',
    		-opus_lib        => '',
    		-dut             => ['dfxsecure_plugin'],
    		-enable_sg_dft   => 1,
    		-enable_gkturnin => 1,
    		-rm_ctech_files  => ['\/ctech_lib*.v',],
        },
     },
  },
);

&hash_merge(
    -type => 'APPEND',
    -src  => \%LocalToolData,
    -dest => \%ToolConfig_tools,
);

## #################################################
##  Added for TSA prime allignment
## #################################################

my $gk_user = ($ENV{USER} eq "gksip") ? 1 : 0;
$general_vars{NBPOOL} = ($gk_user)? 'iind_critical'        : 'iind_normal';
$general_vars{NBQSLOT} = ($gk_user)? '/DTEG/IP' : "/DTEG/IP";
$general_vars{NBCLASS} = "SLES11&&4G",

## #################################################

#$ToolConfig_tools{vcsmx}{VERSION}                     = "N-2017.12-1";
#$ToolConfig_tools{verdi3}{VERSION}		      = "N-2017.12-1";
#$ToolConfig_tools{verdi3}{PATH} 		      = '/p/hdk/rtl/cad/x86-64_linux30/synopsys/verdi3/&get_tool_version()';
1;
