# DO NOT REMOVE!!!  Learn to code warning-free perl instead.
#
use warnings FATAL => 'all';
package ToolData;

#FLG test
$ToolConfig_tools{febe3}{VERSION} = q(20.02.01);

#ISAF ENABLEMENT
#$ToolConfig_tools{isaf}{ENV}{ISAF_SPYGLASS_METHODOLOGY} = "$RTL_CAD_ROOT/spyglass_methodology/spyglass_methodology/1.02.09.16ww18p3";

#$ToolConfig_tools{tsa_dc_config}{spyglass_build}{-command}  = "unsetenv SB_STDCELLS_HDL && ace -ccsg -ASSIGN -mc=cdc_sbendpoint ";
#$ToolConfig_tools{tsa_dc_config}{sgdft}{drc}{-args}  = "-rtl_milestone 1.0";
$ToolConfig_tools{tsa_dc_config}{sgdft}{package}{-args}  = "-cheetah_scan_config -rtl_milestone 1.0 -update_ip_info";
#$ToolConfig_tools{tsa_dc_config}{sgdft}{drc}{-ace_args}  = "-model cdc_sbendpoint -static_check_cfg_file=$ENV{MODEL_ROOT}/tools/spyglassdft/ace_static_check.cfg ";
#$ToolConfig_tools{isaf}{OTHER}{ip_info_dpath} = "$MODEL_ROOT/tools/spyglassdft/&get_facet(CUST)/";

$ToolConfig_tools{isaf}{VERSION} = "2.4.11";    # no longer needed when on mat1.6.p3


#SAGE ENABLEMENT
#$ToolConfig_tools{sage}{VERSION} = "1.10.4"; 
#$ToolConfig_tools{sage}{PATH} = "/p/hdk/pu_tu/prd/sage/&get_tool_version()";

#FE tool Overrides
#-------------------------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------------------------
# Custom Post local variables
$general_vars{SIP_VARIATION} = 'p1274';
$general_vars{SIP_TOOL_VARIATION} = 'p1274';
#$general_vars{RECON_SOURCE_FILE} = '/p/com/eda/intel/cdc/v20140708/prototype/recon_setup';
#$general_vars{KIT_PATH} = '/p/kits/intel/10nm/10nm_14.2.1';
#foreach (@{ $ToolConfig_tools{tsa_shell}{setenv}}) { s/CTECH_v_rtl_lib/CTECH_p1274_e05_ln_rtl_lib/ }  

#-------------------------------------------------------------------------------------------------------
my %LocalToolData = (
#   xvm => { VERSION => '1.0.4', ENV => { XVM_HOME => '&get_tool_path()' }, }, 
   tsa_shell => {
      tsetup_add => [ 'vipcat', 'uvm', 'xvm'],
      setenv => [
                'KIT_HDL   n6_h240_stdcells.hdl',
                'SIP_TOOL_VARIATION p1274',
                'SIP_LIBRARY_TYPE    h240',
                'SIP_LIBRARY_VOLTAGE 0.75',
                'SIP_LIBRARY_VTYPE   lvt8',
                'SIP_PROCESS_DIR     /p/hdk/cad/kits_10nm/10nm_14.4.1',
                'SIP_PROCESS_NAME    p1274',
                'SIP_TRACK_TAG       default',
                ],
   },

#  tsa_finalized => {
#     finalized => {
#         sbendpoint => {
#            -dut             => ['sbe'],
#            -lib_variant => 'lvt8',
#            -stdlib_type => 'h240',
#            -enable_sg_dft => 1,
#             ace_lib => "iosf_sbc_ep_rtl_lib",
#             project => "SIP",
#            -defines => ['NO_PWR_PINS', 'SVA_disable', 'INTEL_SVA_OFF', 'NOTBV', ],
#            -rm_defines => ['L2_SC_ACTIVE', 'functional', 'VCSSIM', 'MEM_CTECH', 'META_OFF'],
#            -rm_ctech_files  => ["\/ctech_lib_.*.v"],
#            #-project_settings_override => "$MODEL_ROOT/tools/febe/inputs/override_dc_config.pm",
#         },
#       }, # end of finalized
#          LIB_2STAGE_CFG => {
#         #-filter_hier => [
#         #  { library => 'iosf_sbc_ep_sim_lib', module => '*tcbn07_bwph240l*.v' },
#         #],
#         iosf_sbc_ep_sim_lib => {
#           -filter_files => [
#             # also tried wildcard like on the wiki
#             ".*tcbn07_bwph240l.*.v",
#             #"/p/tech/n7/tech-prerelease/v1.0.6_pre.2/tcbn07_bwph240l8p57pd_base_lvt_c181015_lib/verilog/tcbn07_bwph240l8p57pd_base_lvt_c181015_120a/tcbn07_bwph240l8p57pd_base_lvt_c181015.v",
#           ],
#         },
#       },
#     CTECH => {
#       -path => '',
#       -replace => [@replace_files,],                     
#     },
#     COMMON_CFG => {
#       -add_ctech_files => [],
#       -rm_ctech_files => ["\/ctech_lib_.*\.*"],
#     },
#    # LIB_2STAGE_CFG => {
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
#          'INTEL_SVA_OFF',
#       ],
# 
#       'CTECH_rtl_lib' => {
#         -filter_defines => [
#           'INTEL_SIMONLY',
#           'INTEL_SVA_OFF',
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
#          ],
#       },
#       #'sbendpoint_cfg' => {
#        # -add_defines => [
#           #'INTEL_SVA_OFF',
#         #],
#       #},
#     #},
#   },
#

   tsa_finalized => {
       LIB_2STAGE_CFG => {
           CTECH => {
       -path => '',
       -replace => [@replace_files,],                     
     },
         COMMON_CFG => {
       -add_ctech_files => [],
       -rm_ctech_files => ["\/ctech_lib_.*\.*"],
     },

           '-filter_defines' => [
           'INTEL_SIMONLY',
       ],
       '-add_defines' => [
            'IOSF_SB_EVENT_OFF',
            'INTEL_SVA_OFF',
        ],

        'CTECH_rtl_lib' => {
            -filter_defines => [
            'INTEL_SIMONLY',
            'INTEL_SVA_OFF',
           ],
           -add_defines => [
               'OVM',
               'IOSF_SB_PH2',
              # 'INSTATIATE_NOVAS',
              # 'INSTATIATE_HIERDUMP',
            ],
        },

        'iosf_sbc_ep_sim_lib' => {
         -filter_defines => [
           'INSTANTIATE_NOVAS',
           'INSTANTIATE_HIERDUMP',
           ],
         -filter_files => [  
            ".*tcbn07_bwph240l.*.v",
            ".*tcbn06_bwph240l.*.v",
           ],
         -add_defines => [
           'MEM_CTECH',
           'CTECH_LIB_META_ON',
           'VCS',
           'VCSSIM',
           'DC',
           'OVM',
           'IOSF_SB_PH2',
           'IOSF_SB_EVENT_OFF',
          ],
       },
      # iosf_sbc_ep_sim_lib => {
         #  -filter_files => [
             # also tried wildcard like on the wiki
           #  ".*tcbn07_bwph240l.*.v",
             #"/p/tech/n7/tech-prerelease/v1.0.6_pre.2/tcbn07_bwph240l8p57pd_base_lvt_c181015_lib/verilog/tcbn07_bwph240l8p57pd_base_lvt_c181015_120a/tcbn07_bwph240l8p57pd_base_lvt_c181015.v",
         #  ],
        # },
       }, #2stage
        finalized => {
         sbendpoint => {
            -dut             => ['sbe'],
            -lib_variant => 'svt8',
            -stdlib_type => 'h240',
            -enable_sg_dft => 1,
             ace_lib => "iosf_sbc_ep_rtl_lib",
             project => "SIP",
            -defines => ['NO_PWR_PINS', 'SVA_disable', 'INTEL_SVA_OFF', 'NOTBV', ],
            -rm_defines => ['L2_SC_ACTIVE', 'functional', 'VCSSIM', 'MEM_CTECH', 'META_OFF'],
            -rm_ctech_files  => ["\/ctech_lib_.*.v"],
            #-project_settings_override => "$MODEL_ROOT/tools/febe/inputs/override_dc_config.pm",
         },
       }, # end of finalized
   }, #tsa_finalized

   tsa_dc_config  => {
      SETUP => {
        -be_tool_override => {
          #lib_ver_data => 'siphdk/p1274.7/18.41.00',
          #lib_attribute_data => 'siphdk/p1274.7/18.40.01',
          proj_ft => q(20.01.03),
        },
      },
       'INPUTS' => {
       -use_vcs_xml => 1,
       -top_hier    => q(&get_general_var(aceroot_dpath)/results/top.hier),
       -chip_dump   => q(&get_general_var(aceroot_dpath)/results/DC/fev_v2k/fullchipdump.final.pl),
     },
     tophiergen => {
       -hier_dump_top => 'iosf_sbc_ep_tb.tb_top',
       -test_name     => 'dump_hier_test',
       -args          => '-noepi -no-tim -no-enable_hier_dump -no-hier_dump -no-fpp -simv_args -ucli -simv_args -i,&get_general_var(aceroot_dpath)/results/dump_hier.do',
    },

    V2K_PREP => {
      -hier               => q(tb_top),   # Top hierarchy name here (usually a testbench)
      -vcs_xml            => q(&get_general_var(aceroot_dpath)/results/tests/dump_hier_test/config_diagnostics.xml),
      -elab_log           => q(&get_general_var(aceroot_dpath)/results/tests/dump_hier_test/dump_hier_test.log),
      -ace_command        => q(ace -rtl M:IosfSbEpTestbench),   # ace model specified here
      -ace_filter_command => q(ace -rtl M:IosfSbEpTestbench -filter Synthesis),
      -acefilelist        => q(&get_general_var(aceroot_dpath)/results/&get_facet(scope).MIosfSbEpTestbench.filelist.Synthesis.pl),
      -acefullfilelist    => q(&get_general_var(aceroot_dpath)/results/&get_facet(scope).MIosfSbEpTestbench.filelist.pl),
    },
 
 # This section is required for v2k_prep and flg_v2k
 flg_v2k => {
      -enable_ctech => 0,
      -enable_ctech_replace =>1,
      -enable_all_dependent_libs => 1,
      -golden_v2k_cfg => 1,
      -v2k_cfg_lrm => 1,
      -disable_suffix_lib => 1,
      -vcsmakelogsdir => q(&get_general_var(aceroot_dpath)/results/makefiles/vcs/makeLogs),
    },
 'FISHTAIL' => {
        -no_setproj => 1,
        -no_setup => 1,
     },   

'gen_collateral' => {         
   # Cheetah Modifications
    -no_setproj          => 1,          
    -no_setup            => 1,                         
    -extra_commands_post_populate  => [],  #optional
    -extra_commands_post  => [], #optional
    -configulate_command => ' ', #optional
    },
       
      DC => {
         -setenv   => {
            UPF_CONFIG => q(LOCAL),
          },
      },
      FV => {
         -setenv   => {
            UPF_CONFIG => q(LOCAL),
          },
      },
   },  #tsa_dc_config

);
#-------------------------------------------------------------------------------------------------------
&hash_merge(
    -type => 'APPEND',
    -src  => \%LocalToolData,
    -dest => \%ToolConfig_tools,
);
#-------------------------------------------------------------------------------------------------------
1;
