# DO NOT REMOVE!!!  Learn to code warning-free perl instead.
#
use warnings FATAL => 'all';
package ToolData;

#ISAF ENABLEMENT

#$ToolConfig_tools{tsa_dc_config}{spyglass_build}{-command}  = "unsetenv SB_STDCELLS_HDL && ace -ccsg -ASSIGN -mc=cdc_sbendpoint ";
#$ToolConfig_tools{tsa_dc_config}{sgdft}{drc}{-args}  = "-rtl_milestone 1.0";
#$ToolConfig_tools{tsa_dc_config}{sgdft}{package}{-args}  = "-rtl_milestone 1.0 -update_ip_info";
#$ToolConfig_tools{tsa_dc_config}{sgdft}{drc}{-ace_args}  = "-model cdc_sbendpoint -static_check_cfg_file=$ENV{MODEL_ROOT}/tools/spyglassdft/ace_static_check.cfg ";
#$ToolConfig_tools{isaf}{OTHER}{ip_info_dpath} = "$MODEL_ROOT/tools/spyglassdft/&get_facet(CUST)/";

#SAGE ENABLEMENT
#$ToolConfig_tools{sage}{VERSION} = "1.5.6";

#FE tool Overrides
#-------------------------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------------------------
# Custom Post local variables
#$general_vars{SIP_VARIATION} = 'p1273';
#$general_vars{SIP_TOOL_VARIATION} = 'p1273';
#$general_vars{RECON_SOURCE_FILE} = '/p/com/eda/intel/cdc/v20140708/prototype/recon_setup';
#$general_vars{ KIT_PATH } = '/p/kits/intel/p1273/p1273_1.8.0';
#foreach (@{ $ToolConfig_tools{tsa_shell}{setenv}}) { s/CTECH_v_rtl_lib/CTECH_p1273_d04_wn_rtl_lib/ }

#-------------------------------------------------------------------------------------------------------
my %LocalToolData = (
   tsa_shell => {
       setenv => [
                'KIT_HDL   s14nm_A9T_stdcells.hdl',
                'SIP_TOOL_VARIATION rtr_s14nm',
                'SIP_LIBRARY_TYPE    A9T',
                'SIP_LIBRARY_VOLTAGE 0.72',
                'SIP_LIBRARY_VTYPE   rvt',
                #'SIP_PROCESS_DIR     /p/kits/intel/p1273/p1273_1.8.0',
                'SIP_PROCESS_NAME    s14nm',
                ],
   },

    tsa_dc_config  => {
       DC => {
        #  -setenv   => {
        #     UPF_CONFIG => q(LOCAL),
        #  },
       },
       FV => {
       #   -setenv   => {
       #      UPF_CONFIG => q(LOCAL),
       #   },
       },
    },  #tsa_dc_config


   tsa_finalized => {
      finalized => {
         sbendpoint => {
            -dut             => ['sbe'],
            -lib_variant => 'rvt,lvt',
            -stdlib_type => 'A9T',      
            -enable_sg_dft => 1,
             ace_lib => "iosf_sbc_ep_rtl_lib",
             project => "SIP",
            -defines => ['NO_PWR_PINS', 'SVA_disable', 'INTEL_SVA_OFF', 'NOTBV', ],
            -rm_defines => ['L2_SC_ACTIVE', 'functional', 'VCSSIM', 'MEM_CTECH', 'META_OFF'],
            -rm_ctech_files  => ["\/ctech_lib_.*.v"],
            -project_settings_override => "$MODEL_ROOT/tools/febe/inputs/override_dc_config.pm",

         },  
       }, # end of finalized
     }, # end of tsa_finalized
);
#-------------------------------------------------------------------------------------------------------
&hash_merge(
    -type => 'APPEND',
    -src  => \%LocalToolData,
    -dest => \%ToolConfig_tools,
);
#-------------------------------------------------------------------------------------------------------
1;
