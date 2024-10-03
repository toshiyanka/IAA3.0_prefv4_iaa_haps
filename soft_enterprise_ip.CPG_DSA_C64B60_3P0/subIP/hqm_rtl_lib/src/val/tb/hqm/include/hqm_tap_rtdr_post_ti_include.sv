//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
assign pgcb_tck                      = hqm_tap_rtdr_clk_intf.jtag_bfm[0].TCK;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
assign hqm_rtdr_iosfsb_ism_tck       = hqm_tap_rtdr_clk_intf.jtag_bfm[0].TCK;
assign hqm_rtdr_iosfsb_ism_trst_b    = $test$plusargs("TAP_TRST_ISM_0") ? 1'b0 : hqm_tap_rtdr_clk_intf.jtag_bfm[0].TRST_N;
assign hqm_rtdr_iosfsb_ism_tdi       = hqm_tap_rtdr_clk_intf.jtag_bfm[0].TAP_RTDR_TDI[0];
assign hqm_rtdr_iosfsb_ism_irdec     = hqm_tap_rtdr_clk_intf.jtag_bfm[0].TAP_RTDR_IRDEC[0];
assign hqm_rtdr_iosfsb_ism_capturedr = hqm_tap_rtdr_clk_intf.jtag_bfm[0].TAP_RTDR_CAPTURE[0];
assign hqm_rtdr_iosfsb_ism_shiftdr   = hqm_tap_rtdr_clk_intf.jtag_bfm[0].TAP_RTDR_SHIFT[0];
assign hqm_rtdr_iosfsb_ism_updatedr  = hqm_tap_rtdr_clk_intf.jtag_bfm[0].TAP_RTDR_UPDATE[0];

assign hqm_tap_rtdr_clk_intf.jtag_bfm[0].TAP_RTDR_TDO[0]      = hqm_rtdr_iosfsb_ism_tdo;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
assign hqm_rtdr_tapconfig_tck       = hqm_tap_rtdr_clk_intf.jtag_bfm[0].TCK;
assign hqm_rtdr_tapconfig_trst_b    = $test$plusargs("TAP_TRST_CFG_0") ? 1'b0 : hqm_tap_rtdr_clk_intf.jtag_bfm[0].TRST_N;
assign hqm_rtdr_tapconfig_tdi       = hqm_tap_rtdr_clk_intf.jtag_bfm[0].TAP_RTDR_TDI[1];
assign hqm_rtdr_tapconfig_irdec     = hqm_tap_rtdr_clk_intf.jtag_bfm[0].TAP_RTDR_IRDEC[1];
assign hqm_rtdr_tapconfig_capturedr = hqm_tap_rtdr_clk_intf.jtag_bfm[0].TAP_RTDR_CAPTURE[1];
assign hqm_rtdr_tapconfig_shiftdr   = hqm_tap_rtdr_clk_intf.jtag_bfm[0].TAP_RTDR_SHIFT[1];
assign hqm_rtdr_tapconfig_updatedr  = hqm_tap_rtdr_clk_intf.jtag_bfm[0].TAP_RTDR_UPDATE[1];

assign hqm_tap_rtdr_clk_intf.jtag_bfm[0].TAP_RTDR_TDO[1]         = hqm_rtdr_tapconfig_tdo;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
assign hqm_rtdr_taptrigger_tck       = hqm_tap_rtdr_clk_intf.jtag_bfm[0].TCK;
assign hqm_rtdr_taptrigger_trst_b    = $test$plusargs("TAP_TRST_TRI_0") ? 1'b0 : hqm_tap_rtdr_clk_intf.jtag_bfm[0].TRST_N;
assign hqm_rtdr_taptrigger_tdi       = hqm_tap_rtdr_clk_intf.jtag_bfm[0].TAP_RTDR_TDI[2];
assign hqm_rtdr_taptrigger_irdec     = hqm_tap_rtdr_clk_intf.jtag_bfm[0].TAP_RTDR_IRDEC[2];
assign hqm_rtdr_taptrigger_capturedr = hqm_tap_rtdr_clk_intf.jtag_bfm[0].TAP_RTDR_CAPTURE[2];
assign hqm_rtdr_taptrigger_shiftdr   = hqm_tap_rtdr_clk_intf.jtag_bfm[0].TAP_RTDR_SHIFT[2];
assign hqm_rtdr_taptrigger_updatedr  = hqm_tap_rtdr_clk_intf.jtag_bfm[0].TAP_RTDR_UPDATE[2];

assign hqm_tap_rtdr_clk_intf.jtag_bfm[0].TAP_RTDR_TDO[2]         = hqm_rtdr_taptrigger_tdo;



//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Addition for PM coverage related HSD https://hsdes.intel.com/appstore/article/#/1406177148
//assign hqm.par_hqm_chassis.sapmas_wrapper.i_sapmas.sapmas_pgd.power_present_in_vinf  = pvr_hqm.volt_dom_vccinfhigh.vcc_out ;
// End of addition
// JTAG BFM DUT connections
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//assign hqm_tb_top.u_hqm.taplink_hqm_jtag_prev_tlink_FTAP_TRST_B = hqm_tap_rtdr_clk_intf.jtag_bfm[0].TRST_N;
//assign hqm_tb_top.u_hqm.taplink_hqm_jtag_prev_tlink_FTAP_TCK    = hqm_tap_rtdr_clk_intf.jtag_bfm[0].TCK;
//assign hqm_tb_top.u_hqm.taplink_hqm_jtag_prev_tlink_FTAP_TMS    = hqm_tap_rtdr_clk_intf.jtag_bfm[0].TMS;
//assign hqm_tb_top.u_hqm.taplink_hqm_jtag_prev_tlink_FTAP_TDI    = hqm_tap_rtdr_clk_intf.jtag_bfm[0].TDI;
//assign hqm_tap_rtdr_clk_intf.jtag_bfm[0].TDO = hqm_tb_top.u_hqm.taplink_hqm_jtag_prev_tlink_ATAP_TDO;

// STF BFM DUT connections
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//assign hqm_tb_top.u_hqm.stf_hub_stf_hub_input_intf_STF_RST_B = 0 ;//hqm_tap_rtdr_clk_intf.stf_bfm[0].STF_RST_B;
//assign hqm_tb_top.u_hqm.stf_hub_stf_hub_input_intf_STF_CLK   = 0 ;//hqm_tap_rtdr_clk_intf.stf_bfm[0].STF_CLK;
//assign hqm_tb_top.u_hqm.stf_hub_stf_hub_input_intf_STF_PKT   = 0 ;//hqm_tap_rtdr_clk_intf.stf_bfm[0].STF_PKT_IN;
////assign hqm_tap_rtdr_clk_intf.stf_bfm[0].STF_PKT_OUT = hqm_tb_top.u_hqm.stf_hub_stf_hub_output_intf_STF_PKT;

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
