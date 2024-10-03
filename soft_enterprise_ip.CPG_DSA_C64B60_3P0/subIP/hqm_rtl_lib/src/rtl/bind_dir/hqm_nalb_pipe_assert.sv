`ifdef INTEL_INST_ON

`ifndef INTEL_SVA_OFF

module hqm_nalb_pipe_assert ();
logic         int_disable ;
always_comb begin
  int_disable = 1'b0 ;
  if ($test$plusargs("HQM_CHP_FLID_PARITY_ERROR_INJECTION_TEST") ) begin
    int_disable = 1'b1 ;
  end
end

////////////////////////////////////////////////////////////////////////////////////////////////////
//SDG_ASSERTS_FORBIDDEN(name, cond, clk, rst, MSG) 
`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_int_inf0
                      , ( hqm_nalb_pipe_core.int_inf_v[0] 
                        & ~( int_disable & ( hqm_nalb_pipe_core.hqm_nalb_target_cfg_syndrome_00_capture_data[30:28] == 3'd2 ) & hqm_nalb_pipe_core.hqm_nalb_target_cfg_syndrome_00_capture_data[6] )
                        & ~( int_disable & ( hqm_nalb_pipe_core.hqm_nalb_target_cfg_syndrome_00_capture_data[30:28] == 3'd2 ) & hqm_nalb_pipe_core.hqm_nalb_target_cfg_syndrome_00_capture_data[7] )
                        & ~( int_disable & ( hqm_nalb_pipe_core.hqm_nalb_target_cfg_syndrome_00_capture_data[30:28] == 3'd2 ) & hqm_nalb_pipe_core.hqm_nalb_target_cfg_syndrome_00_capture_data[8] )
                        & ~( int_disable & ( hqm_nalb_pipe_core.hqm_nalb_target_cfg_syndrome_00_capture_data[30:28] == 3'd2 ) & hqm_nalb_pipe_core.hqm_nalb_target_cfg_syndrome_00_capture_data[9] )
                        & ~( int_disable & ( hqm_nalb_pipe_core.hqm_nalb_target_cfg_syndrome_00_capture_data[30:28] == 3'd2 ) & hqm_nalb_pipe_core.hqm_nalb_target_cfg_syndrome_00_capture_data[10] )
                        & ~( int_disable & ( hqm_nalb_pipe_core.hqm_nalb_target_cfg_syndrome_00_capture_data[30:28] == 3'd2 ) & hqm_nalb_pipe_core.hqm_nalb_target_cfg_syndrome_00_capture_data[11] )
                        & ~( int_disable & ( hqm_nalb_pipe_core.hqm_nalb_target_cfg_syndrome_00_capture_data[30:28] == 3'd2 ) & hqm_nalb_pipe_core.hqm_nalb_target_cfg_syndrome_00_capture_data[12] )
                        & ~( int_disable & ( hqm_nalb_pipe_core.hqm_nalb_target_cfg_syndrome_00_capture_data[30:28] == 3'd2 ) & hqm_nalb_pipe_core.hqm_nalb_target_cfg_syndrome_00_capture_data[13] )
                        & ~( int_disable & ( hqm_nalb_pipe_core.hqm_nalb_target_cfg_syndrome_00_capture_data[30:28] == 3'd2 ) & hqm_nalb_pipe_core.hqm_nalb_target_cfg_syndrome_00_capture_data[14] )
                        & ~( int_disable & ( hqm_nalb_pipe_core.hqm_nalb_target_cfg_syndrome_00_capture_data[30:28] == 3'd2 ) & hqm_nalb_pipe_core.hqm_nalb_target_cfg_syndrome_00_capture_data[15] )
                        & ~( int_disable & ( hqm_nalb_pipe_core.hqm_nalb_target_cfg_syndrome_00_capture_data[30:28] == 3'd2 ) & hqm_nalb_pipe_core.hqm_nalb_target_cfg_syndrome_00_capture_data[16] )
                        & ~( int_disable & ( hqm_nalb_pipe_core.hqm_nalb_target_cfg_syndrome_00_capture_data[30:28] == 3'd2 ) & hqm_nalb_pipe_core.hqm_nalb_target_cfg_syndrome_00_capture_data[17] )
                        & ~( int_disable & ( hqm_nalb_pipe_core.hqm_nalb_target_cfg_syndrome_00_capture_data[30:28] == 3'd2 ) & hqm_nalb_pipe_core.hqm_nalb_target_cfg_syndrome_00_capture_data[18] )
                        & ~( int_disable & ( hqm_nalb_pipe_core.hqm_nalb_target_cfg_syndrome_00_capture_data[30:28] == 3'd2 ) & hqm_nalb_pipe_core.hqm_nalb_target_cfg_syndrome_00_capture_data[19] )
                        & ~( int_disable & ( hqm_nalb_pipe_core.hqm_nalb_target_cfg_syndrome_00_capture_data[30:28] == 3'd2 ) & hqm_nalb_pipe_core.hqm_nalb_target_cfg_syndrome_00_capture_data[20] )
                        & ~( int_disable & ( hqm_nalb_pipe_core.hqm_nalb_target_cfg_syndrome_00_capture_data[30:28] == 3'd2 ) & hqm_nalb_pipe_core.hqm_nalb_target_cfg_syndrome_00_capture_data[21] )
                        & ~( int_disable & ( hqm_nalb_pipe_core.hqm_nalb_target_cfg_syndrome_00_capture_data[30:28] == 3'd3 ) & hqm_nalb_pipe_core.hqm_nalb_target_cfg_syndrome_00_capture_data[20] )
                        & ~( int_disable & ( hqm_nalb_pipe_core.hqm_nalb_target_cfg_syndrome_00_capture_data[30:28] == 3'd3 ) & hqm_nalb_pipe_core.hqm_nalb_target_cfg_syndrome_00_capture_data[21] )
                        & ~( int_disable & ( hqm_nalb_pipe_core.hqm_nalb_target_cfg_syndrome_00_capture_data[30:28] == 3'd3 ) & hqm_nalb_pipe_core.hqm_nalb_target_cfg_syndrome_00_capture_data[22] )
                        )
                      , posedge hqm_nalb_pipe_core.hqm_gated_clk
                      , ~hqm_nalb_pipe_core.hqm_gated_rst_n
                      , `HQM_SVA_ERR_MSG( "Error: assert_forbidden_int_inf0: " )
                      , SDG_SVA_SOC_SIM
                      )

////////////////////////////////////////////////////////////////////////////////////////////////////
`HQM_SDG_ASSERTS_KNOWN_DRIVEN ( assert_knowndriven_lsp_nalb_sch_unoord_data
                      , ( hqm_nalb_pipe_core.lsp_nalb_sch_unoord_v ? hqm_nalb_pipe_core.lsp_nalb_sch_unoord_data : '0 )
                      , posedge hqm_nalb_pipe_core.hqm_gated_clk
                      , ~hqm_nalb_pipe_core.hqm_gated_rst_n
                      , `HQM_SVA_ERR_MSG( "Error: assert_knowndriven_lsp_nalb_sch_unoord_data: " )
                      , SDG_SVA_SOC_SIM
                      )

`HQM_SDG_ASSERTS_KNOWN_DRIVEN ( assert_knowndriven_lsp_nalb_sch_rorply_data
                      , ( hqm_nalb_pipe_core.lsp_nalb_sch_rorply_v ? hqm_nalb_pipe_core.lsp_nalb_sch_rorply_data : '0 )
                      , posedge hqm_nalb_pipe_core.hqm_gated_clk
                      , ~hqm_nalb_pipe_core.hqm_gated_rst_n
                      , `HQM_SVA_ERR_MSG( "Error: assert_knowndriven_lsp_nalb_sch_rorply_data: " )
                      , SDG_SVA_SOC_SIM
                      )

`HQM_SDG_ASSERTS_KNOWN_DRIVEN ( assert_knowndriven_lsp_nalb_sch_atq_data
                      , ( hqm_nalb_pipe_core.lsp_nalb_sch_atq_v ? hqm_nalb_pipe_core.lsp_nalb_sch_atq_data : '0 )
                      , posedge hqm_nalb_pipe_core.hqm_gated_clk
                      , ~hqm_nalb_pipe_core.hqm_gated_rst_n
                      , `HQM_SVA_ERR_MSG( "Error: assert_knowndriven_lsp_nalb_sch_atq_data: " )
                      , SDG_SVA_SOC_SIM
                      )


endmodule

bind hqm_nalb_pipe_core hqm_nalb_pipe_assert i_hqm_nalb_pipe_assert();

`endif

`endif

