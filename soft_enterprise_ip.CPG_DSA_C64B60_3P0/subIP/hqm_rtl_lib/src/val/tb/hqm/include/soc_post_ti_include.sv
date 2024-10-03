// Addition for PM coverage related HSD https://hsdes.intel.com/appstore/article/#/1406177148
//assign hqm.par_hqm_chassis.sapmas_wrapper.i_sapmas.sapmas_pgd.power_present_in_vinf  = pvr_hqm.volt_dom_vccinfhigh.vcc_out ;
// End of addition
// JTAG BFM DUT connections
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//assign hqm_tb_top.u_hqm.taplink_hqm_jtag_prev_tlink_FTAP_TRST_B = dft_clk_intf.jtag_bfm[0].TRST_N;
//assign hqm_tb_top.u_hqm.taplink_hqm_jtag_prev_tlink_FTAP_TCK    = dft_clk_intf.jtag_bfm[0].TCK;
//assign hqm_tb_top.u_hqm.taplink_hqm_jtag_prev_tlink_FTAP_TMS    = dft_clk_intf.jtag_bfm[0].TMS;
//assign hqm_tb_top.u_hqm.taplink_hqm_jtag_prev_tlink_FTAP_TDI    = dft_clk_intf.jtag_bfm[0].TDI;
//assign dft_clk_intf.jtag_bfm[0].TDO = hqm_tb_top.u_hqm.taplink_hqm_jtag_prev_tlink_ATAP_TDO;
assign dft_clk_intf.jtag_bfm[0].TDO = '0;

// STF BFM DUT connections
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//assign hqm_tb_top.u_hqm.stf_hub_stf_hub_input_intf_STF_RST_B = dft_clk_intf.stf_bfm[0].STF_RST_B;
//assign hqm_tb_top.u_hqm.stf_hub_stf_hub_input_intf_STF_CLK   = dft_clk_intf.stf_bfm[0].STF_CLK;
//assign hqm_tb_top.u_hqm.stf_hub_stf_hub_input_intf_STF_PKT   = dft_clk_intf.stf_bfm[0].STF_PKT_IN;
//assign dft_clk_intf.stf_bfm[0].STF_PKT_OUT = hqm_tb_top.u_hqm.stf_hub_stf_hub_output_intf_STF_PKT;
assign dft_clk_intf.stf_bfm[0].STF_PKT_OUT = '0;

//assign hqm_tb_top.u_hqm.inst_num                    = 8'h0;
//assign hqm_tb_top.u_hqm.dfx_address_decoder_ss_type = 8'h33;

//assign hqm_tb_top.u_hqm.taplink_hqm_tlink_next_jtag_0_ATAP_TDO = 1'h0;

/*
// Connect Secure Policy
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

logic dfxsecure_policy_override;
assign dfxsecure_policy_override = $test$plusargs("DFX_SECURE_UNLOCK") ? 1'b1 : 1'b0;
assign hqm_tb_top.u_hqm.dfxsecure_plugin_policy_override = dfxsecure_policy_override;

logic dfxsecure_plugin_DFX_SECURE_POLICY;
assign dfxsecure_plugin_DFX_SECURE_POLICY = $test$plusargs("DFX_SECURE_UNLOCK") ? 4'h2 : 4'h0;
assign hqm_tb_top.u_hqm.fdfx_secure_policy[3:0] = dfxsecure_plugin_DFX_SECURE_POLICY;

logic dfxsecure_plugin_EARLYBOOT_EXIT;
assign dfxsecure_plugin_EARLYBOOT_EXIT = $test$plusargs("DFX_SECURE_UNLOCK") ? 1'b1 : 1'b0;
assign hqm_tb_top.u_hqm.fdfx_earlyboot_exit = dfxsecure_plugin_EARLYBOOT_EXIT;

logic dfxsecure_plugin_POLICY_UPDATE;
assign dfxsecure_plugin_POLICY_UPDATE = $test$plusargs("DFX_SECURE_UNLOCK") ? 1'b1 : 1'b0;
assign hqm_tb_top.u_hqm.fdfx_policy_update = dfxsecure_plugin_POLICY_UPDATE;

logic [3:0] adl_trigger_intf_UPSTREAM_TRIGGER;
assign adl_trigger_intf_UPSTREAM_TRIGGER = 4'b0;
assign hqm_tb_top.u_hqm.trigger_fabric_in_port_UPSTREAM_TRIGGER = adl_trigger_intf_UPSTREAM_TRIGGER;

assign hqm_tb_top.u_hqm.trigger_fabric_out_port_DNSTREAM_TRIGGER = 1'h0;

*/
