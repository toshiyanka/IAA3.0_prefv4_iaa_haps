package glitchfree_clkmux_final_cfg;
use vars qw (@ISA @EXPORT_OK $dc_cfg $MODEL_ROOT);
@EXPORT_OK = qw($dc_cfg);

$dc_cfg = {-owner => ['prbhatt'],
    -opus_lib => 'mextop',
    -enable_sg_dft => 1,
        -enable_gkturnin => 1,
    -search => [
                
               ],
	-project_settings_override => "$ENV{MODEL_ROOT}/tools/febe/inputs/common/glitchfree_clkmux_dc_config.cfg",       
    -rm_search => [],
    -files_first => [],
    -files => [],
    -rm_files => [], 
                             
    -add_ctech_files => [#"/nfs/pdx/disks/srvr10nm_0041/brownmic/lib_work/CTECH_OVERRIDES/source/p1274/ec0/ln/ctech_lib_msff_async_rst_meta.v",
                        #"/nfs/pdx/disks/srvr10nm_0041/brownmic/lib_work/CTECH_OVERRIDES/source/p1274/ec0/ln/ctech_lib_or2.v",
                        #"/nfs/pdx/disks/srvr10nm_0041/brownmic/lib_work/CTECH_OVERRIDES/source/p1274/ec0/ln/ctech_lib_and2.v",
                       #" $ENV{MODEL_ROOT}/subIP/v15ww03e/source/p1274/ec0/ln/ctech_lib_latch_p.v",
                       #" $ENV{MODEL_ROOT}/subIP/v15ww03e/source/p1274/ec0/ln/ctech_lib_clk_and_en.v",
                       #"$ENV{MODEL_ROOT}/subIP/v15ww03e/source/p1274/ec0/ln/ctech_lib_clk_or.v",
                        # "$ENV{MODEL_ROOT}/subIP/v15ww03e/source/p1274/ec0/ln/ctech_lib_clk_and.v",
                        #&ToolConfig::ToolConfig_get_tool_path("ipconfig/ctech")."/source/p1274/ec0/ln/ctech_lib_doublesync_rstb.sv", 
                        ],
                    
 #   -rm_ctech_files => [
 #            "\/v\/ctech_lib*",
  #       ],
    -pre_script => [],
    -cp_tcl_files => [],
    -defines => [
                 "NO_PWR_PINS",
                 "DC_INCLUDES",
                 "SVA_OFF",
		# "SYNTHESIS",
                 ],
    -sig_files => [],
    
 -children => [],             
                 
                  },
1;
