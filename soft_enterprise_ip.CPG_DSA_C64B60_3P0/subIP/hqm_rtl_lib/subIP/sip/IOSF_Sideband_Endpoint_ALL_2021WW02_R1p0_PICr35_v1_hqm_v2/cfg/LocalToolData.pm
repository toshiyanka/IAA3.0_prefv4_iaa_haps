# DO NOT REMOVE!!!  Learn to code warning-free perl instead.

use warnings FATAL => 'all';

package ToolData;

#--------------------------------------------------------------
# START :: VC CONTOUR SETUP
#--------------------------------------------------------------
use Cwd 'realpath';
##--------------------------------------------------------------
## END :: VC CONTOUR SETUP
##--------------------------------------------------------------
#
#--------------------------------------------------------------
# SVC Override
#--------------------------------------------------------------

$ToolConfig_tools{ipconfig}{SUB_TOOLS}{IOSF_SVC}{VERSION} = "Override(Un-released)";
$ToolConfig_tools{ipconfig}{SUB_TOOLS}{IOSF_SVC}{PATH} = "$ENV{MODEL_ROOT}/verif/bfm/sideband_vc";
IPToolDataExtras::do_with_warn("$ToolConfig_tools{ipconfig}{SUB_TOOLS}{IOSF_SVC}{PATH}/cfg/IOSF_SVC_IPToolData.pm");


#$ToolConfig_tools{ipconfig}{SUB_TOOLS}{ChassisPowerGatingVC}{VERSION} = "Override(Un-released)";
#$ToolConfig_tools{ipconfig}{SUB_TOOLS}{ChassisPowerGatingVC}{PATH} = "/nfs/fm/disks/fm_infrach_00009/vc_contour_ip/ChassisPowerGatingVC";

#uncomment below line when enablin puni on HDK
#$ToolConfig_tools{puni}{ENV}{PUNI_HOME} = "&get_tool_path(puni)";

$ToolConfig_tools{isogen}{VERSION} = q(2.00.00.20WW02);

$ToolConfig_tools{zirconqa}{VERSION} = "2.10.04";
$ToolConfig_tools{zirconqarules} = {
 PATH    => "/p/hdk/rtl/proj_tools/zirconqarules/master/2.10.04.P1",
 VERSION => "2.10.04",
};

$ToolConfig_tools{isaf}{OTHER}{ip_info_dpath} = "$MODEL_ROOT/tools/spyglassdft/&get_facet(CUST)/";

$ToolConfig_tools{tsa_dc_config}{OTHER}{sgdft}{drc}{-args}  .= " -rtl_milestone 1.0";
$ToolConfig_tools{tsa_dc_config}{OTHER}{sgdft}{package}{-args}  .= " -rtl_milestone 1.0 -update_ip_info";
$ToolConfig_tools{tsa_dc_config}{OTHER}{sgdft}{drc}{-ace_args}  = " -use_lint_mcrd -model cdc_sbendpoint -static_check_cfg_file=$ENV{MODEL_ROOT}/tools/spyglassdft/ace_static_check.cfg ";

#$ToolConfig_tools{scanaudit}{VERSION} = "2.2.7.6";
#$ToolConfig_tools{sd_build}{VERSION} = "18.1.1.1";


#$ToolConfig_tools{febe3}{VERSION} = "3.2.16";
#$ToolConfig_tools{febe3}{OTHER}{project_settings} = [
#    @{$ToolConfig_tools{febe3}{OTHER}{project_settings}},
#    "$MODEL_ROOT/tools/vclp/dc_config.pm", 
#];

#TSA 1.5.3 is still using older cdc (sp2-5). Retain this override until the versions update (by checking the prj file)
#$ToolConfig_tools{spyglass_cdc}{VERSION} = "2.00.03";
#$ToolConfig_tools{spyglass_cdc}{SUB_TOOLS}{spyglass}{VERSION} = "M2017.03-SP2-9";

#$ToolConfig_tools{spyglass_cdc}{VERSION} = "2.00.06";
#$ToolConfig_tools{spyglass_cdc}{SUB_TOOLS}{spyglass}{VERSION} = "M2017.03-SP2-15-B4";
$ToolConfig_tools{spyglass_cdc}{SUB_TOOLS}{spyglass}{VERSION} = q(P-2019.06-SP2-6);
#$ToolConfig_tools{spyglass_cdc}{SUB_TOOLS}{cdclint}{VERSION} = "1.00.08";

#$ToolConfig_tools{sage}{VERSION} = "1.10.4";
#$ToolConfig_tools{scanaudit}{VERSION} = "2.2.7.6";
#$ToolConfig_tools{spyglass_lint}{SUB_TOOLS}{spyglass}{VERSION} = "M2017.03-SP2-7";
#$ToolConfig_tools{tsa_dc_config}{OTHER}{SETUP}{-be_tool_override}{'(.domain=sip.)'}{sage} = '1.10.4';

$general_vars{NBPOOL}   = "fm_normal";
$general_vars{NBQSLOT}  = "/EIG/FABRIC/RTL/sb";
$general_vars{NBCLASS}  = "SLES11&&2G";

#uncomment below line when enablin puni on HDK and comment SLES11&&2G
#$general_vars{NBCLASS}  = "SLES11_EM64T_2G";

#$general_vars{RECON_SOURCE_FILE} = '/p/com/eda/intel/cdc/v20140708/prototype/recon_setup';
$general_vars{RECON_SOURCE_FILE} = '/p/hdk/rtl/cad/x86-64_linux30/intel/cdc/v20140708/prototype/recon_setup';

#push @{ $ToolConfig_tools{tsa_dc_config}{OTHER}{gen_collateral}{-extra_commands_post}},"setenv CONFIGULATE `get_path configulate`", "\$CONFIGULATE/bin/configulate_caliber.pl -block \$block -ward \$WARD -metaflop";

 my $ctech_path = q(/p/hdk/cad/ctech/n7/c4v19ww40d_hdk162_v1.0.6_pre.2_mtp_sip_sbx);
 my $ctech_exp_path = q(/p/hdk/cad/ctech/n7/ctech_exp_c4v19ww43b_hdk161_mtp_sip_sbx);
 my @add_replace_ctech_files = (
   glob(${ctech_path}."/source/h240/lvt8/*ctech_lib*.sv"),
   glob(${ctech_exp_path}."/source/n7/h240/lvt8/*ctech_lib*.sv"),
 );
 my @replace_files;
 foreach my $file (@add_replace_ctech_files) {
   my @source = split(/source/,$file);
   my @function = split(/ctech_lib_/,$source[1]);
   my $replace = {
       match => "source/v/ctech_lib_$function[1]",
       replace => "source$function[0]ctech_lib_$function[1]",
   };
   push(@replace_files,$replace);
 }

my %LocalToolData = (
#lira => {VERSION => "15.3p15_64"},
xvm => { VERSION => '1.0.4', ENV => { XVM_HOME => '&get_tool_path()' }, }, 
intelcdc => {VERSION => 'v20170925'},
effm => { ENV => { EMUL_CFG_DIR => "$ENV{MODEL_ROOT}/ace/effm_flows",
                   EMUL_IP_NAME => 'sbendpoint',
                   EMUL_TOOLS_DIR => '&get_tool_path()/effm_tools',
            },
          ENV_PREPEND => { PATH => "&get_tool_env_var(,EMUL_TOOLS_DIR)" },
},

# tsa_finalized => {
#     CTECH => {
#       -path => '',
#       -replace => [@replace_files,],                     
#     },
#     COMMON_CFG => {
#       -add_ctech_files => [],
#       -rm_ctech_files => ["\/ctech_lib_.*\.*"],
#     },
#     LIB_2STAGE_CFG => {
#       '-filter_hier' => [ 
#         #{ library => '<YOUR VCS LIB HERE>', module => '*' },
#         #{ instance => "*.*", library => "<YOUR VCS LIB HERE>", module => "*.*" },
#       ],
# 
#       '-filter_defines' => [
#         'INTEL_SIMONLY',
#       ],
# 
#       '-add_defines' => [
#         'IOSF_SB_EVENT_OFF',
#       ],
# 
#       'CTECH_rtl_lib' => {
#         -filter_defines => [
#           'INTEL_SIMONLY',
#         ],
#         -add_defines => [
#           'OVM',
#           'IOSF_SB_PH2',
#           'INSTANTIATE_NOVAS',
#           'INSTANTIATE_HIERDUMP',
#         ],
#       },
#       'iosf_sbc_ep_sim_lib' => {
#         -filter_defines => [
#           'INSTANTIATE_NOVAS',
#           'INSTANTIATE_HIERDUMP',
#         ],
#         -add_defines => [
#           'MEM_CTECH',
#           'CTECH_LIB_META_ON',
#           'VCS',
#           'VCSSIM',
#           'DC',
#           'OVM',
#           'IOSF_SB_PH2',
#           'IOSF_SB_EVENT_OFF',
#           'INTEL_SVA_OFF',
#         ],
#       },
#       'sbendpoint_cfg' => {
#         -add_defines => [
#           #'INTEL_SVA_OFF',
#         ],
#       },
#     },
#   },

tsa_shell => {
    tsetup_add => [ 'vipcat', 'uvm', 'xvm'],
    setenv => [ ($ToolConfig::general_vars{NO_ACEROOT_LINKS} ? 'IP_ROOT $MODEL_ROOT' : 'IP_ROOT $MODEL_ROOT/target/&get_general_var(unique_output_dir)/aceroot'),

#uncomment below line when enablin puni on HDK
   # tsetup_add => [ 'vipcat', 'uvm', 'xvm', 'puni'],
    #setenv => [ 'IP_ROOT $MODEL_ROOT/target/&get_general_var(unique_output_dir)/aceroot',
                'SIP_PROJECT sb',
                'SBR_ROOT $MODEL_ROOT',
                'FE2BE_ROOT $MODEL_ROOT',
                'SGLINT_MODEL_ROOT $MODEL_ROOT',
                'CUST &get_facet(CUST)',
                'SB_ACE_FLOW 0',
                'CTECH_SIM_LIB_NAME  CTECH_v_rtl_lib',
                'SB_STDCELLS_HDL     SB_STDCELLS_HDL',
                'SBC_SETUP_HAS_BEEN_CALLED 1',
                'RDT_COMMON_PATH     /p/com/flows/rdt/1.5.0',
                'RDT_PROJECT_TYPE    soc',
                'SIP_DOT_PROCESS     1',
                'SIP_TRACK_TAG       default',
                'EEFM_VERSION     2015.23',
                'LM_PROJECT       EIG_FABRIC',
                'EMUL_TOOLS_DIR /nfs/site/eda/group/SYSNAME/emu/intel/effm/2015.23/effm_tools',
                'LIC_SETUP I-2014.03-1',
                'EMUL_CFG_DIR ${MODEL_ROOT}/target/sbe/$CUST/aceroot/ace/effm_flows',
                'EMU_CFG_DIR ${MODEL_ROOT}/target/sbe/$CUST/aceroot/verif/results/effm_endpoint/emul',
                'EMUL_RESULTS_DIR ${MODEL_ROOT}/target/sbe/$CUST/aceroot/verif/results/effm_endpoint/emul',
                #'GCC_LIB_VER gcc-4.2.2_64',
                'ATPG_COMMON_TP ${MODEL_ROOT}/tools/sage/inputs/$CUST/sbendpoint/scripts/partition.common.tp',
                # these cdc overrides should be removed after hdk merge with version                
#                'CDC_VER V10.4f_5',
#                'CDCLINT_HOME /p/hdk/rtl/proj_tools/cdclint/master/17.31.7',
                #'INTELCDC_ROOT /p/hdk/rtl/proj_tools/cdc/master/v20170925',
                #'CDC_FLOW_RELEASE v20170925',
#                'HOME_0IN /p/hdk/rtl/cad/x86-64_linux30/mentor/questaCDC/V10.4f_5/linux_x86_64',
#                'CDC_RELEASE /p/hdk/rtl/proj_tools/cdc/master/v20170925',
#                'CDC_RULES /p/hdk/rtl/proj_tools/cdc/master/v20170925',
                # Added for VC
                #'XVM_HOME /p/hdk/rtl/cad/x86-64_linux30/intel/xvm/1.0.4',
                #'UVM_HOME /p/hdk/rtl/cad/x86-64_linux30/accellera/uvm/1.2',                   
                ## Added for SGCDC
#                'DEFAULT_STDCELL_LIBRARY /p/hdk/cad/stdcells/e05/17ww50.5_e05_h.0.p5_iclgt',
## mroha: Added for limiting simbuild log during nightly. Is this the correct place? will need to check if it worked for nightly
                'DISABLE_TSA_TRACK_OVRS 1',

    ],
    setenv_ace => {
        ACE_RC => "$ENV{MODEL_ROOT}/ace/iosf_sbc_ep.acerc",
        ACE_PROJECT => "&get_facet(scope)",
    },
},
tsa_dc_config => {

  #  'INPUTS' => {
  #     -use_vcs_xml => 1,
  #     -top_hier    => q(&get_general_var(aceroot_dpath)/results/top.hier),
  #     -chip_dump   => q(&get_general_var(aceroot_dpath)/results/DC/fev_v2k/fullchipdump.final.pl),
  #   },
  #   tophiergen => {
  #     -hier_dump_top => 'iosf_sbc_ep_tb.tb_top',
  #     -test_name     => 'dump_hier_test',
  #      -args          => '-noepi -no-tim -no-enable_hier_dump -no-hier_dump -no-fpp -simv_args -ucli -simv_args -i,&get_general_var(aceroot_dpath)/results/dump_hier.do',
   # },

   spyglass_lp => {
    -command => 'ace -static_check -ASSIGN -mc=cdc_sbendpoint',
    #-args => "-ASSIGN -mc=cdc_sbendpoint",
    -test_suffix => '',
    -test_dir    => 'spyglasslp',
   },

   spyglass_build => {
       -command => 'unsetenv SB_STDCELLS_HDL && '.$ToolData::ToolConfig_tools{tsa_dc_config}{OTHER}{spyglass_build}{-command}." -ASSIGN -mc=cdc_sbendpoint",
   },

   spyglass_build_lp => {
       -command => 'unsetenv SB_STDCELLS_HDL && '.$ToolData::ToolConfig_tools{tsa_dc_config}{OTHER}{spyglass_build_lp}{-command}." -ASSIGN -mc=cdc_sbendpoint",
   },

   lintra_build => {
      -command    => 'unsetenv SB_STDCELLS_HDL && '.$ToolData::ToolConfig_tools{tsa_dc_config}{OTHER}{lintra_build}{-command}." -nocleanup -noenable_prescripts -results results/lint -mcrd '<-eng>/<-pwa>/results/lint'",
   },
   
   lintra_elab => {
      -test_suffix => ":FLG",
      -test_dir    => "lintra/HDK/",
      #-command     => 'unsetenv SB_STDCELLS_HDL && ace -sc -nocleanup  -results $MODEL_ROOT/results',
      -command    => 'unsetenv SB_STDCELLS_HDL && '.$ToolData::ToolConfig_tools{tsa_dc_config}{OTHER}{lintra_elab}{-command}." -nocleanup -noenable_prescripts -results results/lint -mcrd '<-eng>/<-pwa>/results/lint'",
   },

   SETUP => {
        -be_tool_override => {
        # '(.domain=sip.)' => { sage => '&get_tool_version(sage)'},
        #lib_setting_data => q(dts_all/16.01.24),
        'caliber' => '19.02.04.p007',
        'metaflop_data' => 'p1274.0/18.02.21',
        'pv_quality_limits_data' => 'siphdk/p1274/19.02.05',
        'pv_quality_rulesets' => 'siphdk/central/19.02.03',
        }, 
      -passthru_vars => [
               'SIP_LIBRARY_TYPE',
               'SIP_LIBRARY_VTYPE',
               'SIP_PROCESS_NAME',
               'SIP_DOT_PROCESS',
               'SIP_TRACK_TAG',
               'SIP_LIBRARY_VOLTAGE',
               ],
   },

# V2K_PREP => {
#      -hier               => q(tb_top),   # Top hierarchy name here (usually a testbench)
 #     -vcs_xml            => q(&get_general_var(aceroot_dpath)/results/tests/dump_hier_test/config_diagnostics.xml),
  #    -elab_log           => q(&get_general_var(aceroot_dpath)/results/tests/dump_hier_test/dump_hier_test.log),
   #   -ace_command        => q(ace -rtl M:IosfSbEpTestbench),   # ace model specified here
   #   -ace_filter_command => q(ace -rtl M:IosfSbEpTestbench -filter Synthesis),
   #   -acefilelist        => q(&get_general_var(aceroot_dpath)/results/&get_facet(scope).MIosfSbEpTestbench.filelist.Synthesis.pl),
   #   -acefullfilelist    => q(&get_general_var(aceroot_dpath)/results/&get_facet(scope).MIosfSbEpTestbench.filelist.pl),
   # },
 
 # This section is required for v2k_prep and flg_v2k
# flg_v2k => {
#      -enable_ctech => 0,
#      -enable_ctech_replace =>1,
#      -enable_all_dependent_libs => 1,
 #     -golden_v2k_cfg => 1,
#      -v2k_cfg_lrm => 1,
 #     -disable_suffix_lib => 1,
 #     -vcsmakelogsdir => q(&get_general_var(aceroot_dpath)/results/makefiles/vcs/makeLogs),
#    },
 },

);

#-------------------------------------------------------------------------------------------------------
&hash_merge(
    -type => 'APPEND',
    -src  => \%LocalToolData,
    -dest => \%ToolConfig_tools,
);
#-------------------------------------------------------------------------------------------------------
1;

