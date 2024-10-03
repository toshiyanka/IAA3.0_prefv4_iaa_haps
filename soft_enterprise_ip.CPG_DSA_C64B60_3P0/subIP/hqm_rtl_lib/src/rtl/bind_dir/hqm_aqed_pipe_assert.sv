`ifdef INTEL_INST_ON

`ifndef INTEL_SVA_OFF

module hqm_aqed_pipe_assert import hqm_AW_pkg::*, hqm_pkg::*, hqm_core_pkg::*; ();

////////////////////////////////////////////////////////////////////////////////////////////////////
//HQM_SDG_ASSERTS_FORBIDDEN(name, cond, clk, rst, MSG) 
logic [7:0] assert_int_inf_v ;
always_comb begin
  assert_int_inf_v = hqm_aqed_pipe_core.int_inf_v ;
  if ($test$plusargs("HQM_INGRESS_ERROR_TEST")) begin
    assert_int_inf_v[0] = 1'b0 ;
  end
  if ($test$plusargs("HQM_AQED_FLID_PARITY_ERROR_INJECTION_TEST")) begin
    assert_int_inf_v[0] = 1'b0 ;
  end
end
`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_int_inf0
                      , ( assert_int_inf_v[0] == 1'b1 )
                      , posedge hqm_aqed_pipe_core.hqm_gated_clk
                      , ~hqm_aqed_pipe_core.hqm_gated_rst_n
                      , `HQM_SVA_ERR_MSG( "Error: assert_forbidden_int_inf0: " )
                      , SDG_SVA_SOC_SIM
                      )

////////////////////////////////////////////////////////////////////////////////////////////////////
//HQM_SDG_ASSERTS_KNOWN_DRIVEN(name, sig, clk, rst, MSG) 
`HQM_SDG_ASSERTS_KNOWN_DRIVEN ( assert_knowndriven_ap_aqed_data
                      , ( hqm_aqed_pipe_core.ap_aqed_v ? hqm_aqed_pipe_core.ap_aqed_data : '0 )
                      , posedge hqm_aqed_pipe_core.hqm_gated_clk
                      , ~hqm_aqed_pipe_core.hqm_gated_rst_n
                      , `HQM_SVA_ERR_MSG( "Error: assert_knowndriven_ap_aqed_data: " )
                      , SDG_SVA_SOC_SIM
                      )

`HQM_SDG_ASSERTS_KNOWN_DRIVEN ( assert_knowndriven_qed_aqed_enq_data
                      , ( hqm_aqed_pipe_core.qed_aqed_enq_v ? hqm_aqed_pipe_core.qed_aqed_enq_data : '0 )
                      , posedge hqm_aqed_pipe_core.hqm_gated_clk
                      , ~hqm_aqed_pipe_core.hqm_gated_rst_n
                      , `HQM_SVA_ERR_MSG( "Error: assert_knowndriven_qed_aqed_enq_data: " )
                      , SDG_SVA_SOC_SIM
                      )


endmodule

bind hqm_aqed_pipe_core hqm_aqed_pipe_assert i_hqm_aqed_pipe_assert();

`endif

`endif

