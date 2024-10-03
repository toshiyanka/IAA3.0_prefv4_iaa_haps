`ifdef INTEL_INST_ON

`ifndef INTEL_SVA_OFF

module hqm_lsp_atm_pipe_assert ();

////////////////////////////////////////////////////////////////////////////////////////////////////
//HQM_SDG_ASSERTS_FORBIDDEN(name, cond, clk, rst, MSG) 
`HQM_SDG_ASSERTS_FORBIDDEN    ( assert_forbidden_int_inf0
                      , ( hqm_lsp_atm_pipe.int_inf_v[0] == 1'b1 )
                      , posedge hqm_lsp_atm_pipe.hqm_gated_clk
                      , ~hqm_lsp_atm_pipe.hqm_gated_rst_n
                      , `HQM_SVA_ERR_MSG( "Error: assert_forbidden_int_inf0: " )
                      , SDG_SVA_SOC_SIM
                      )

////////////////////////////////////////////////////////////////////////////////////////////////////
//HQM_SDG_ASSERTS_KNOWN_DRIVEN(name, sig, clk, rst, MSG) 
`HQM_SDG_ASSERTS_KNOWN_DRIVEN ( assert_knowndriven_aqed_ap_enq_data
                      , ( hqm_lsp_atm_pipe.aqed_ap_enq_v ? hqm_lsp_atm_pipe.aqed_ap_enq_data : '0 )
                      , posedge hqm_lsp_atm_pipe.hqm_gated_clk
                      , ~hqm_lsp_atm_pipe.hqm_gated_rst_n
                      , `HQM_SVA_ERR_MSG( "Error: assert_knowndriven_aqed_ap_enq_data: " )
                      , SDG_SVA_SOC_SIM
                      )

`HQM_SDG_ASSERTS_KNOWN_DRIVEN ( assert_knowndriven_lsp_ap_atm_data
                      , ( hqm_lsp_atm_pipe.lsp_ap_atm_v ? hqm_lsp_atm_pipe.lsp_ap_atm_data : '0 )
                      , posedge hqm_lsp_atm_pipe.hqm_gated_clk
                      , ~hqm_lsp_atm_pipe.hqm_gated_rst_n
                      , `HQM_SVA_ERR_MSG( "Error: assert_knowndriven_lsp_ap_atm_data: " )
                      , SDG_SVA_SOC_SIM
                      )


endmodule

bind hqm_lsp_atm_pipe hqm_lsp_atm_pipe_assert i_hqm_lsp_atm_pipe_assert();

`endif

`endif

