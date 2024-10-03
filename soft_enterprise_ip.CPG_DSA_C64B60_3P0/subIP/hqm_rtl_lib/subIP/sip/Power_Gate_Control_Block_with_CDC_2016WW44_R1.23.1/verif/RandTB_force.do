dump -add { RandTestbench } -depth 0 -scope "."

force {RandTestbench.u_PgdTbDefPowerOff.u_PowerDomainControl.u_pgcbunit.cfg_tsleepinactiv[1:0]} 0
force {RandTestbench.u_PgdTbDefPowerOff.u_PowerDomainControl.u_pgcbunit.cfg_tdeisolate[1:0]} 0
force {RandTestbench.u_PgdTbDefPowerOff.u_PowerDomainControl.u_pgcbunit.cfg_tpokup[1:0]} 0
force {RandTestbench.u_PgdTbDefPowerOff.u_PowerDomainControl.u_pgcbunit.cfg_tinaccrstup[1:0]} 0
force {RandTestbench.u_PgdTbDefPowerOff.u_PowerDomainControl.u_pgcbunit.cfg_taccrstup[1:0]} 0
force {RandTestbench.u_PgdTbDefPowerOff.u_PowerDomainControl.u_pgcbunit.cfg_tlatchen[1:0]} 0
force {RandTestbench.u_PgdTbDefPowerOff.u_PowerDomainControl.u_pgcbunit.cfg_tpokdown[1:0]} 0
force {RandTestbench.u_PgdTbDefPowerOff.u_PowerDomainControl.u_pgcbunit.cfg_tlatchdis[1:0]} 0
force {RandTestbench.u_PgdTbDefPowerOff.u_PowerDomainControl.u_pgcbunit.cfg_tsleepact[1:0]} 0
force {RandTestbench.u_PgdTbDefPowerOff.u_PowerDomainControl.u_pgcbunit.cfg_tisolate[1:0]} 0
force {RandTestbench.u_PgdTbDefPowerOff.u_PowerDomainControl.u_pgcbunit.cfg_trstdown[1:0]} 0
force {RandTestbench.u_PgdTbDefPowerOff.u_PowerDomainControl.u_pgcbunit.cfg_tclksonack_srst[1:0]} 0
force {RandTestbench.u_PgdTbDefPowerOff.u_PowerDomainControl.u_pgcbunit.cfg_tclksoffack_srst[1:0]} 0
force {RandTestbench.u_PgdTbDefPowerOff.u_PowerDomainControl.u_pgcbunit.cfg_tclksonack_cp[1:0]} 0
force {RandTestbench.u_PgdTbDefPowerOff.u_PowerDomainControl.u_pgcbunit.cfg_trstup2frcclks[1:0]} 0
force {RandTestbench.u_PgdTbDefPowerOff.u_PowerDomainControl.u_pgcbunit.cfg_trsvd0[1:0]} 0
force {RandTestbench.u_PgdTbDefPowerOff.u_PowerDomainControl.u_pgcbunit.cfg_trsvd1[1:0]} 0
force {RandTestbench.u_PgdTbDefPowerOff.u_PowerDomainControl.u_pgcbunit.cfg_trsvd2[1:0]} 0
force {RandTestbench.u_PgdTbDefPowerOff.u_PowerDomainControl.u_pgcbunit.cfg_trsvd3[1:0]} 0
force {RandTestbench.u_PgdTbDefPowerOff.u_PowerDomainControl.u_pgcbunit.cfg_trsvd4[1:0]} 0
force RandTestbench.u_PgdTbDefPowerOff.u_PowerDomainControl.u_pgcbunit.pmc_pgcb_fet_en_b 1
force RandTestbench.u_PgdTbDefPowerOff.u_PowerDomainControl.u_pgcbunit.fscan_mode 0

force RandTestbench.u_PgdTbDefPowerOff.u_PowerDomainControl.u_pgcbunit.pmc_pgcb_pg_ack_b 0
force RandTestbench.u_PgdTbDefPowerOff.u_PowerDomainControl.u_pgcbunit.pmc_pgcb_restore_b 1
force {RandTestbench.u_PgdTbDefPowerOff.u_PowerDomainControl.u_pgcbunit.ip_pgcb_pg_type[1:0]} 0
force RandTestbench.u_PgdTbDefPowerOff.u_PowerDomainControl.u_pgcbunit.ip_pgcb_pg_rdy_req_b 0
force RandTestbench.u_PgdTbDefPowerOff.u_PowerDomainControl.u_pgcbunit.ip_pgcb_all_pg_rst_up 0
force RandTestbench.u_PgdTbDefPowerOff.u_PowerDomainControl.u_pgcbunit.ip_pgcb_frc_clk_srst_en 0
force RandTestbench.u_PgdTbDefPowerOff.u_PowerDomainControl.u_pgcbunit.ip_pgcb_frc_clk_cp_en 0
force RandTestbench.u_PgdTbDefPowerOff.u_PowerDomainControl.u_pgcbunit.ip_pgcb_force_clks_on_ack 0
force RandTestbench.u_PgdTbDefPowerOff.u_PowerDomainControl.u_pgcbunit.ip_pgcb_sleep_en 0

force RandTestbench.u_PgdTbDefPowerOff.u_PowerDomainControl.u_pgcbunit.pgcb_rst_b 0 0, 1 100ns
force RandTestbench.u_PgdTbDefPowerOff.u_PowerDomainControl.u_pgcbunit.fdfx_powergood_rst_b 0 0, 1 400ns

force RandTestbench.u_PgdTbDefPowerOff.u_PowerDomainControl.u_pgcbunit.clk 0 0, 1 40ns -repeat 80ns
force RandTestbench.u_PgdTbDefPowerOff.u_PowerDomainControl.u_pgcbunit.pgcb_tck 0 0, 1 5ns -repeat 10ns

force RandTestbench.u_PgdTbDefPowerOff.u_PowerDomainControl.u_pgcbunit.fdfx_pgcb_bypass 0
force RandTestbench.u_PgdTbDefPowerOff.u_PowerDomainControl.u_pgcbunit.fdfx_pgcb_ovr 0
force {RandTestbench.u_PgdTbDefPowerOff.genblk1[0].u_ClockDomainDriver.gclock_req_async[0]} 0 

run 506ns
force RandTestbench.u_PgdTbDefPowerOff.u_PowerDomainControl.u_pgcbunit.fdfx_pgcb_bypass 1
force RandTestbench.u_PgdTbDefPowerOff.u_PowerDomainControl.u_pgcbunit.fdfx_pgcb_ovr 0

run 1000ns

force RandTestbench.u_PgdTbDefPowerOff.u_PowerDomainControl.u_pgcbunit.fdfx_pgcb_bypass 1
force RandTestbench.u_PgdTbDefPowerOff.u_PowerDomainControl.u_pgcbunit.fdfx_pgcb_ovr 1

run 200ns

force RandTestbench.u_PgdTbDefPowerOff.u_PowerDomainControl.u_pgcbunit.fdfx_pgcb_bypass 0
force RandTestbench.u_PgdTbDefPowerOff.u_PowerDomainControl.u_pgcbunit.fdfx_pgcb_ovr 0
force RandTestbench.u_PgdTbDefPowerOff.u_PowerDomainControl.u_pgcbunit.fdfx_powergood_rst_b 0
run 10ns
force RandTestbench.u_PgdTbDefPowerOff.u_PowerDomainControl.u_pgcbunit.fdfx_powergood_rst_b 1

force RandTestbench.u_PgdTbDefPowerOff.u_PowerDomainControl.u_pgcbunit.fdfx_pgcb_ovr 1
run 50ns
force RandTestbench.u_PgdTbDefPowerOff.u_PowerDomainControl.u_pgcbunit.fdfx_pgcb_bypass 1
run 200ns

force RandTestbench.u_PgdTbDefPowerOff.u_PowerDomainControl.u_pgcbunit.fdfx_pgcb_ovr 0
run 100ns

force {RandTestbench.u_PgdTbDefPowerOff.genblk1[0].u_ClockDomainDriver.gclock_req_async[0]} 1
run 10ns
force {RandTestbench.u_PgdTbDefPowerOff.genblk1[0].u_ClockDomainDriver.gclock_req_async[0]} 0 
run 100ns

