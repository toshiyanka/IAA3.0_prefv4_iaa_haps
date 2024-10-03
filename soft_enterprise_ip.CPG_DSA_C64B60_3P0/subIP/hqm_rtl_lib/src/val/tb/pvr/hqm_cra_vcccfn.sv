// Don't lint the instrumentation code
`ifndef LINT_ON
logic power_present_in_vcccfn; // to be driven by the test bench
hqm_clk_reset_filter #( .reset_filter_width(16),
                           .active_reset_level(0),
                           .voltage_domain("vcccfn")
                           )
                          hqm_cra_vcccfn (
                            .rtl_reset_in(powergood_rst_b),             // rtl reset
                            .tb_reset_in(1'b0),                         // tb reset in - not filtered
                            .clk_in(i_hqm_sip.hqm_sip_aon_wrap.i_hqm_sif.side_clk),  // rtl clock
                            .power_present_in(power_present_in_vcccfn),
                            .qual_reset_out(),
                            .unqual_reset_out(),
                            .qual_clk_out(),
                            .unqual_clk_out(),
                            .reset_start(),
                            .qualified_time(),
                            .reset_end()
);
`endif // LINT_ON
