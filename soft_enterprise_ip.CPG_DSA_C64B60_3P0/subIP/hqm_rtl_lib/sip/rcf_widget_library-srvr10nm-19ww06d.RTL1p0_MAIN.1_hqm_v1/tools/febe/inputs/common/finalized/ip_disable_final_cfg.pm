package ip_disable_final_cfg;
use vars qw (@ISA @EXPORT_OK $dc_cfg $MODEL_ROOT);
use ToolConfig;
@EXPORT_OK = qw($dc_cfg);

$dc_cfg = {
    -owner => ['kcorrell'],
    -opus_lib => 'mextop',
    -enable_sg_dft => 1,
    -enable_gkturnin => 1,
    -search => [ ],
    -project_settings_override => "$ENV{MODEL_ROOT}/tools/febe/inputs/common/ip_disable_dc_config.cfg",
    -rm_search => [ ],
    -files_first => [ ],
    -files => [ ],
    -rm_files => [ 
        ],
    -add_ctech_files => [
#         "$ENV{VALID_ROOT}/lib_work/CTECH_OVERRIDES/source/p1274/ec0/ln/ctech_lib_buf.v",
#         "$ENV{VALID_ROOT}/lib_work/CTECH_OVERRIDES/source/p1274/ec0/ln/ctech_lib_mux_2to1_hf.v",
#         "$ENV{VALID_ROOT}/lib_work/CTECH_OVERRIDES/source/p1274/ec0/ln/ctech_lib_msff_async_rst.v",
#         "$ENV{VALID_ROOT}/lib_work/CTECH_OVERRIDES/source/p1274/ec0/ln/ctech_lib_inv.v"
    ],
#    -rm_ctech_files => [
#       "\/v\/ctech_lib*",
#    ],
    -pre_script => [],
    -cp_tcl_files => [],
    -defines => [
                 "NO_PWR_PINS",
                 "DC_INCLUDES",
#                 "SVA_OFF",
#                 "INTEL_SVA_OFF",
#                 "SYNTHESIS",
                 ],
    -sig_files => [],
    -children => [],             
},

1;



