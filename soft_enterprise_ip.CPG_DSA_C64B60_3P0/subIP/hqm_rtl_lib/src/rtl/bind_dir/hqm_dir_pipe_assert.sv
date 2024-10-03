`ifdef INTEL_INST_ON

`ifndef INTEL_SVA_OFF

module hqm_dir_pipe_assert ();
logic         int_disable ;
always_comb begin
  int_disable = 1'b0 ;
  if ($test$plusargs("HQM_CHP_FLID_PARITY_ERROR_INJECTION_TEST") ) begin
    int_disable = 1'b1 ;
  end
end

////////////////////////////////////////////////////////////////////////////////////////////////////
//HQM_SDG_ASSERTS_FORBIDDEN(name, cond, clk, rst, MSG) 
`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_int_inf0
                      , ( hqm_dir_pipe_core.int_inf_v 
                        & ~( int_disable & ( hqm_dir_pipe_core.hqm_dp_target_cfg_syndrome_00_capture_data[30:28] == 3'd1 ) & hqm_dir_pipe_core.hqm_dp_target_cfg_syndrome_00_capture_data[24] )
                        & ~( int_disable & ( hqm_dir_pipe_core.hqm_dp_target_cfg_syndrome_00_capture_data[30:28] == 3'd1 ) & hqm_dir_pipe_core.hqm_dp_target_cfg_syndrome_00_capture_data[25] )
                        & ~( int_disable & ( hqm_dir_pipe_core.hqm_dp_target_cfg_syndrome_00_capture_data[30:28] == 3'd1 ) & hqm_dir_pipe_core.hqm_dp_target_cfg_syndrome_00_capture_data[26] )
                        & ~( int_disable & ( hqm_dir_pipe_core.hqm_dp_target_cfg_syndrome_00_capture_data[30:28] == 3'd2 ) & hqm_dir_pipe_core.hqm_dp_target_cfg_syndrome_00_capture_data[0] )
                        & ~( int_disable & ( hqm_dir_pipe_core.hqm_dp_target_cfg_syndrome_00_capture_data[30:28] == 3'd2 ) & hqm_dir_pipe_core.hqm_dp_target_cfg_syndrome_00_capture_data[1] )
                        & ~( int_disable & ( hqm_dir_pipe_core.hqm_dp_target_cfg_syndrome_00_capture_data[30:28] == 3'd2 ) & hqm_dir_pipe_core.hqm_dp_target_cfg_syndrome_00_capture_data[2] )
                        & ~( int_disable & ( hqm_dir_pipe_core.hqm_dp_target_cfg_syndrome_00_capture_data[30:28] == 3'd2 ) & hqm_dir_pipe_core.hqm_dp_target_cfg_syndrome_00_capture_data[3] )
                        & ~( int_disable & ( hqm_dir_pipe_core.hqm_dp_target_cfg_syndrome_00_capture_data[30:28] == 3'd2 ) & hqm_dir_pipe_core.hqm_dp_target_cfg_syndrome_00_capture_data[4] )
                        & ~( int_disable & ( hqm_dir_pipe_core.hqm_dp_target_cfg_syndrome_00_capture_data[30:28] == 3'd2 ) & hqm_dir_pipe_core.hqm_dp_target_cfg_syndrome_00_capture_data[5] )
                        & ~( int_disable & ( hqm_dir_pipe_core.hqm_dp_target_cfg_syndrome_00_capture_data[30:28] == 3'd2 ) & hqm_dir_pipe_core.hqm_dp_target_cfg_syndrome_00_capture_data[6] )
                        & ~( int_disable & ( hqm_dir_pipe_core.hqm_dp_target_cfg_syndrome_00_capture_data[30:28] == 3'd2 ) & hqm_dir_pipe_core.hqm_dp_target_cfg_syndrome_00_capture_data[7] )
                        & ~( int_disable & ( hqm_dir_pipe_core.hqm_dp_target_cfg_syndrome_00_capture_data[30:28] == 3'd2 ) & hqm_dir_pipe_core.hqm_dp_target_cfg_syndrome_00_capture_data[8] )
                        & ~( int_disable & ( hqm_dir_pipe_core.hqm_dp_target_cfg_syndrome_00_capture_data[30:28] == 3'd2 ) & hqm_dir_pipe_core.hqm_dp_target_cfg_syndrome_00_capture_data[9] )
                        & ~( int_disable & ( hqm_dir_pipe_core.hqm_dp_target_cfg_syndrome_00_capture_data[30:28] == 3'd2 ) & hqm_dir_pipe_core.hqm_dp_target_cfg_syndrome_00_capture_data[10] )
                        & ~( int_disable & ( hqm_dir_pipe_core.hqm_dp_target_cfg_syndrome_00_capture_data[30:28] == 3'd3 ) & hqm_dir_pipe_core.hqm_dp_target_cfg_syndrome_00_capture_data[5] )
                        & ~( int_disable & ( hqm_dir_pipe_core.hqm_dp_target_cfg_syndrome_00_capture_data[30:28] == 3'd3 ) & hqm_dir_pipe_core.hqm_dp_target_cfg_syndrome_00_capture_data[6] )
                        )
                      , posedge hqm_dir_pipe_core.hqm_gated_clk
                      , ~hqm_dir_pipe_core.hqm_gated_rst_n
                      , `HQM_SVA_ERR_MSG( "Error: assert_forbidden_int_inf0: " )
                      , SDG_SVA_SOC_SIM
                      )

////////////////////////////////////////////////////////////////////////////////////////////////////
//HQM_SDG_ASSERTS_KNOWN_DRIVEN(name, sig, clk, rst, MSG) 
`HQM_SDG_ASSERTS_KNOWN_DRIVEN ( assert_knowndriven_lsp_dp_sch_dir_data
                      , ( hqm_dir_pipe_core.lsp_dp_sch_dir_v ? hqm_dir_pipe_core.lsp_dp_sch_dir_data : '0 )
                      , posedge hqm_dir_pipe_core.hqm_gated_clk
                      , ~hqm_dir_pipe_core.hqm_gated_rst_n
                      , `HQM_SVA_ERR_MSG( "Error: assert_knowndriven_lsp_dp_sch_dir_data: " )
                      , SDG_SVA_SOC_SIM
                      )

`HQM_SDG_ASSERTS_KNOWN_DRIVEN ( assert_knowndriven_lsp_dp_sch_rorply_data
                      , ( hqm_dir_pipe_core.lsp_dp_sch_rorply_v ? hqm_dir_pipe_core.lsp_dp_sch_rorply_data : '0 )
                      , posedge hqm_dir_pipe_core.hqm_gated_clk
                      , ~hqm_dir_pipe_core.hqm_gated_rst_n
                      , `HQM_SVA_ERR_MSG( "Error: assert_knowndriven_lsp_dp_sch_rorply_data: " )
                      , SDG_SVA_SOC_SIM
                      )


endmodule

bind hqm_dir_pipe_core hqm_dir_pipe_assert i_hqm_dir_pipe_assert();

`endif

`endif

