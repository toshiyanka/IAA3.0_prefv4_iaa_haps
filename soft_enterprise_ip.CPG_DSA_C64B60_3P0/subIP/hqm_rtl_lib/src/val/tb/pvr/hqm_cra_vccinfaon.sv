// Don't lint the instrumentation code
`ifndef LINT_ON
logic power_present_in_vccinfaon; // to be driven by the test bench
hqm_clk_reset_filter #( .reset_filter_width(16),
                           .active_reset_level(0),
                           .voltage_domain("vccinfaon")
                           )
                          hqm_cra_vccinfaon (
                            .rtl_reset_in(punit_ip_vinf_aon_pwrgood_rst_b),  // rtl reset
                            .tb_reset_in(1'b0),     // tb reset in - not filtered
                            .clk_in(aon_clk),     // rtl clock
                            .power_present_in(power_present_in_vccinfaon)
);
`endif // LINT_ON
