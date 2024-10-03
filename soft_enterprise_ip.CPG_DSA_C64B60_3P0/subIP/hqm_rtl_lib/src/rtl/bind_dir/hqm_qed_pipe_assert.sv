`ifdef INTEL_INST_ON

`ifndef INTEL_SVA_OFF

module hqm_qed_pipe_assert import hqm_AW_pkg::*, hqm_pkg::*, hqm_core_pkg::*; ();
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
                      , ( hqm_qed_pipe_core.int_inf_v[0]
                        & ~( int_disable & ( hqm_qed_pipe_core.hqm_qed_target_cfg_syndrome_00_capture_data[30:28] == 3'd1 ) & hqm_qed_pipe_core.hqm_qed_target_cfg_syndrome_00_capture_data[3] )
                        & ~( int_disable & ( hqm_qed_pipe_core.hqm_qed_target_cfg_syndrome_00_capture_data[30:28] == 3'd1 ) & hqm_qed_pipe_core.hqm_qed_target_cfg_syndrome_00_capture_data[4] )
                        & ~( int_disable & ( hqm_qed_pipe_core.hqm_qed_target_cfg_syndrome_00_capture_data[30:28] == 3'd1 ) & hqm_qed_pipe_core.hqm_qed_target_cfg_syndrome_00_capture_data[5] )
                        ) 

                      , posedge hqm_qed_pipe_core.hqm_gated_clk
                      , ~hqm_qed_pipe_core.hqm_gated_rst_n
                      , `HQM_SVA_ERR_MSG( "Error: assert_forbidden_int_inf0: " )
                      , SDG_SVA_SOC_SIM
                      )

////////////////////////////////////////////////////////////////////////////////////////////////////
//HQM_SDG_ASSERTS_KNOWN_DRIVEN(name, sig, clk, rst, MSG) 
`HQM_SDG_ASSERTS_KNOWN_DRIVEN ( assert_knowndriven_qed_alarm_up
                      , ( hqm_qed_pipe_core.qed_alarm_down_v ? hqm_qed_pipe_core.qed_alarm_down_data : '0 )
                      , posedge hqm_qed_pipe_core.hqm_gated_clk
                      , ~hqm_qed_pipe_core.hqm_gated_rst_n
                      , `HQM_SVA_ERR_MSG( "Error: assert_knowndriven_qed_alarm_up: " )
                      , SDG_SVA_SOC_SIM
                      )



endmodule

bind hqm_qed_pipe_core hqm_qed_pipe_assert i_hqm_qed_pipe_assert();

`endif

`endif

