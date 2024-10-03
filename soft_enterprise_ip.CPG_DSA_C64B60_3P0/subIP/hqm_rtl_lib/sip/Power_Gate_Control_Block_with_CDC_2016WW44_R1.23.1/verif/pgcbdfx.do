dump -add { RandTestbench } -depth 0 -scope "."

force {pgcbunit.cfg_tsleepinactiv[1:0]} 0
force {pgcbunit.cfg_tdeisolate[1:0]} 0
force {pgcbunit.cfg_tpokup[1:0]} 0
force {pgcbunit.cfg_tinaccrstup[1:0]} 0
force {pgcbunit.cfg_taccrstup[1:0]} 0
force {pgcbunit.cfg_tlatchen[1:0]} 0
force {pgcbunit.cfg_tpokdown[1:0]} 0
force {pgcbunit.cfg_tlatchdis[1:0]} 0
force {pgcbunit.cfg_tsleepact[1:0]} 0
force {pgcbunit.cfg_tisolate[1:0]} 0
force {pgcbunit.cfg_trstdown[1:0]} 0
force {pgcbunit.cfg_tclksonack_srst[1:0]} 0
force {pgcbunit.cfg_tclksoffack_srst[1:0]} 0
force {pgcbunit.cfg_tclksonack_cp[1:0]} 0
force {pgcbunit.cfg_trstup2frcclks[1:0]} 0
force {pgcbunit.cfg_trsvd0[1:0]} 0
force {pgcbunit.cfg_trsvd1[1:0]} 0
force {pgcbunit.cfg_trsvd2[1:0]} 0
force {pgcbunit.cfg_trsvd3[1:0]} 0
force {pgcbunit.cfg_trsvd4[1:0]} 0
force pgcbunit.pmc_pgcb_fet_en_b 1
force pgcbunit.fscan_mode 0
force pgcbunit.fscan_ret_ctrl 1

force pgcbunit.pmc_pgcb_pg_ack_b 0
force pgcbunit.pmc_pgcb_restore_b 1
force {pgcbunit.ip_pgcb_pg_type[1:0]} 0
force pgcbunit.ip_pgcb_pg_rdy_req_b 0
force pgcbunit.ip_pgcb_all_pg_rst_up 0
force pgcbunit.ip_pgcb_frc_clk_srst_en 0
force pgcbunit.ip_pgcb_frc_clk_cp_en 0
force pgcbunit.ip_pgcb_force_clks_on_ack 0
force pgcbunit.ip_pgcb_sleep_en 0

force pgcbcg.async_wake_b 1

force pgcb_rst_b 0 0, 1 100ns
force fdfx_powergood_rst_b 0 0, 1 400ns

force clk 0 0, 1 40ns -repeat 80ns
force pgcb_tck 0 0, 1 5ns -repeat 10ns

force pgcbunit.fdfx_pgcb_bypass 0
force pgcbunit.fdfx_pgcb_ovr 0

run 506ns
force pgcbunit.fdfx_pgcb_bypass 1
force pgcbunit.fdfx_pgcb_ovr 0

run 1000ns

force pgcbunit.fdfx_pgcb_bypass 1
force pgcbunit.fdfx_pgcb_ovr 1

run 200ns

force pgcbunit.fdfx_pgcb_bypass 0
force pgcbunit.fdfx_pgcb_ovr 0
force fdfx_powergood_rst_b 0
run 10ns
force fdfx_powergood_rst_b 1

force pgcbunit.fdfx_pgcb_ovr 1
run 50ns
force pgcbunit.fdfx_pgcb_bypass 1
run 200ns

force pgcbunit.fdfx_pgcb_ovr 0
run 100ns
