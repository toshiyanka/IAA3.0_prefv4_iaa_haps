push(@{$dInfo{dut_top}}, "ClockDomainController");

push(@{$dInfo{resets}}, "~pgcb_rst_b");

push(@{$dInfo{clocks}}, "clock");

push(@{$dInfo{clocks}}, "pgcb_clk");

push(@{$dInfo{inputs}}, 'cfg_clkgate_disabled');

push(@{$dInfo{inputs}}, 'cfg_clkgate_holdoff[3:0]');

push(@{$dInfo{inputs}}, 'cfg_clkreq_ctl_disabled');

push(@{$dInfo{inputs}}, 'cfg_clkreq_off_holdoff[3:0]');

push(@{$dInfo{inputs}}, 'cfg_clkreq_syncoff_holdoff[3:0]');

push(@{$dInfo{inputs}}, 'cfg_pwrgate_holdoff[3:0]');

push(@{$dInfo{inputs}}, 'clkack');

push(@{$dInfo{inputs}}, 'fismdfx_clkgate_ovrd');

push(@{$dInfo{inputs}}, 'fismdfx_force_clkreq');

push(@{$dInfo{inputs}}, 'fscan_byprst_b[2:0]');

push(@{$dInfo{inputs}}, 'fscan_clkgenctrl[1:0]');

push(@{$dInfo{inputs}}, 'fscan_clkgenctrlen[1:0]');

push(@{$dInfo{inputs}}, 'fscan_clkungate');

push(@{$dInfo{inputs}}, 'fscan_rstbypen[2:0]');

push(@{$dInfo{inputs}}, 'gclock_req_async[0:0]');

push(@{$dInfo{inputs}}, 'gclock_req_sync');

push(@{$dInfo{inputs}}, 'ism_agent[2:0]');

push(@{$dInfo{inputs}}, 'ism_fabric[2:0]');

push(@{$dInfo{inputs}}, 'pgcb_force_rst_b');

push(@{$dInfo{inputs}}, 'pgcb_pok');

push(@{$dInfo{inputs}}, 'pgcb_pwrgate_active');

push(@{$dInfo{inputs}}, 'pgcb_restore');

push(@{$dInfo{inputs}}, 'pok_reset_b');

push(@{$dInfo{inputs}}, 'prescc_clock');

push(@{$dInfo{inputs}}, 'pwrgate_disabled');

push(@{$dInfo{inputs}}, 'pwrgate_force');

push(@{$dInfo{inputs}}, 'pwrgate_pmc_wake');

push(@{$dInfo{inputs}}, 'reset_b[0:0]');

push(@{$dInfo{outputs}}, 'boundary_locked');

push(@{$dInfo{outputs}}, 'cdc_visa[23:0]');

push(@{$dInfo{outputs}}, 'clkreq');

push(@{$dInfo{outputs}}, 'gclock');

push(@{$dInfo{outputs}}, 'gclock_ack_async[0:0]');

push(@{$dInfo{outputs}}, 'gclock_active');

push(@{$dInfo{outputs}}, 'gclock_enable_final');

push(@{$dInfo{outputs}}, 'greset_b[0:0]');

push(@{$dInfo{outputs}}, 'ism_locked');

push(@{$dInfo{outputs}}, 'pok');

push(@{$dInfo{outputs}}, 'pwrgate_ready');

push(@{$dInfo{outputs}}, 'reset_sync_b[0:0]');

1;

