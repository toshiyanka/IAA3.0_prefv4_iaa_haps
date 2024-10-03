configure license queue on
# do /nfs/fm/disks/fm_pmc_00089/ssing18/PGCB/ip-pwrmisc-tgl/qcdc_da.tcl
# do /p/com/eda/intel/cdc/v20140603/prototype/cdc_global.tcl
cdc preference hier -ctrl_file_models
cdc synchronizer dff -min 2 -max 5
netlist constant propagation -enable
cdc report scheme two_dff -severity violation
cdc report scheme bus_two_dff -severity violation
cdc report scheme pulse_sync -severity caution
cdc report scheme single_source_reconvergence -severity caution
configure license queue on
cdc preference -fifo_scheme
cdc preference -handshake_scheme
cdc preference -enable_internal_resets
cdc preference reconvergence -bit_recon
# end do /p/com/eda/intel/cdc/v20140603/prototype/cdc_global.tcl
# do /p/com/eda/intel/cdc/v20140603/custom_sync_cells/p1273/custom_sync_cells.tcl
cdc synchronizer custom d04hgy23xd0b0
netlist port domain -input d -async -clock clk -module d04hgy23xd0b0
netlist port domain -output o -clock clk -module d04hgy23xd0b0
netlist port domain rb -clock clk -module d04hgy23xd0b0
netlist port domain si -ignore -module d04hgy23xd0b0
netlist port domain ssb -ignore -module d04hgy23xd0b0
netlist port domain so -ignore -module d04hgy23xd0b0
netlist port domain vcc -ignore -module d04hgy23xd0b0
cdc synchronizer custom d04hiy23ld0b0
netlist port domain -input d -async -clock clk -module d04hiy23ld0b0
netlist port domain -output o -clock clk -module d04hiy23ld0b0
netlist port domain rb -clock clk -module d04hiy23ld0b0
netlist port domain si -ignore -module d04hiy23ld0b0
netlist port domain ss -ignore -module d04hiy23ld0b0
netlist port domain so -ignore -module d04hiy23ld0b0
netlist port domain vcc -ignore -module d04hiy23ld0b0
cdc synchronizer custom d04hiy2cld0b0
netlist port domain -input d -async -clock clk -module d04hiy2cld0b0
netlist port domain -output o -clock clk -module d04hiy2cld0b0
netlist port domain psb -clock clk -module d04hiy2cld0b0
netlist port domain si -ignore -module d04hiy2cld0b0
netlist port domain ss -ignore -module d04hiy2cld0b0
netlist port domain so -ignore -module d04hiy2cld0b0
netlist port domain vcc -ignore -module d04hiy2cld0b0
cdc synchronizer custom d04hgn23wd0b0
netlist port domain -input d -async -clock clk -module d04hgn23wd0b0
netlist port domain -output o -clock clk -module d04hgn23wd0b0
netlist port domain rb -clock clk -module d04hgn23wd0b0
netlist port domain vcc -ignore -module d04hgn23wd0b0
cdc synchronizer custom d04hgn23xd0b0
netlist port domain -input d -async -clock clk -module d04hgn23xd0b0
netlist port domain -output o -clock clk -module d04hgn23xd0b0
netlist port domain rb -clock clk -module d04hgn23xd0b0
netlist port domain vcc -ignore -module d04hgn23xd0b0
cdc synchronizer custom d04hgy2cxd0b0
netlist port domain -input d -async -clock clk -module d04hgy2cxd0b0
netlist port domain -output o -clock clk -module d04hgy2cxd0b0
netlist port domain psb -clock clk -module d04hgy2cxd0b0
netlist port domain si -ignore -module d04hgy2cxd0b0
netlist port domain ssb -ignore -module d04hgy2cxd0b0
netlist port domain so -ignore -module d04hgy2cxd0b0
netlist port domain vcc -ignore -module d04hgy2cxd0b0
cdc synchronizer custom d04hgn23ld0b0
netlist port domain -input d -async -clock clk -module d04hgn23ld0b0
netlist port domain -output o -clock clk -module d04hgn23ld0b0
netlist port domain rb -clock clk -module d04hgn23ld0b0
netlist port domain vcc -ignore -module d04hgn23ld0b0
cdc synchronizer custom d04hgy23wd0b0
netlist port domain -input d -async -clock clk -module d04hgy23wd0b0
netlist port domain -output o -clock clk -module d04hgy23wd0b0
netlist port domain rb -clock clk -module d04hgy23wd0b0
netlist port domain si -ignore -module d04hgy23wd0b0
netlist port domain ssb -ignore -module d04hgy23wd0b0
netlist port domain so -ignore -module d04hgy23wd0b0
netlist port domain vcc -ignore -module d04hgy23wd0b0
cdc synchronizer custom d04hgy23wd0c0
netlist port domain -input d -async -clock clk -module d04hgy23wd0c0
netlist port domain -output o -clock clk -module d04hgy23wd0c0
netlist port domain rb -clock clk -module d04hgy23wd0c0
netlist port domain si -ignore -module d04hgy23wd0c0
netlist port domain ssb -ignore -module d04hgy23wd0c0
netlist port domain so -ignore -module d04hgy23wd0c0
netlist port domain vcc -ignore -module d04hgy23wd0c0
cdc synchronizer custom d04hgy2cwd0b0
netlist port domain -input d -async -clock clk -module d04hgy2cwd0b0
netlist port domain -output o -clock clk -module d04hgy2cwd0b0
netlist port domain psb -clock clk -module d04hgy2cwd0b0
netlist port domain si -ignore -module d04hgy2cwd0b0
netlist port domain ssb -ignore -module d04hgy2cwd0b0
netlist port domain so -ignore -module d04hgy2cwd0b0
netlist port domain vcc -ignore -module d04hgy2cwd0b0
cdc synchronizer custom d04hgy2cwd0c0
netlist port domain -input d -async -clock clk -module d04hgy2cwd0c0
netlist port domain -output o -clock clk -module d04hgy2cwd0c0
netlist port domain psb -clock clk -module d04hgy2cwd0c0
netlist port domain si -ignore -module d04hgy2cwd0c0
netlist port domain ssb -ignore -module d04hgy2cwd0c0
netlist port domain so -ignore -module d04hgy2cwd0c0
netlist port domain vcc -ignore -module d04hgy2cwd0c0
cdc synchronizer custom d04hgy23ld0b0
netlist port domain -input d -async -clock clk -module d04hgy23ld0b0
netlist port domain -output o -clock clk -module d04hgy23ld0b0
netlist port domain rb -clock clk -module d04hgy23ld0b0
netlist port domain si -ignore -module d04hgy23ld0b0
netlist port domain ssb -ignore -module d04hgy23ld0b0
netlist port domain so -ignore -module d04hgy23ld0b0
netlist port domain vcc -ignore -module d04hgy23ld0b0
cdc synchronizer custom d04hgy23ld0c0
netlist port domain -input d -async -clock clk -module d04hgy23ld0c0
netlist port domain -output o -clock clk -module d04hgy23ld0c0
netlist port domain rb -clock clk -module d04hgy23ld0c0
netlist port domain si -ignore -module d04hgy23ld0c0
netlist port domain ssb -ignore -module d04hgy23ld0c0
netlist port domain so -ignore -module d04hgy23ld0c0
netlist port domain vcc -ignore -module d04hgy23ld0c0
cdc synchronizer custom d04hgy2cld0b0
netlist port domain -input d -async -clock clk -module d04hgy2cld0b0
netlist port domain -output o -clock clk -module d04hgy2cld0b0
netlist port domain psb -clock clk -module d04hgy2cld0b0
netlist port domain si -ignore -module d04hgy2cld0b0
netlist port domain ssb -ignore -module d04hgy2cld0b0
netlist port domain so -ignore -module d04hgy2cld0b0
netlist port domain vcc -ignore -module d04hgy2cld0b0
cdc synchronizer custom d04hgy2cld0c0
netlist port domain -input d -async -clock clk -module d04hgy2cld0c0
netlist port domain -output o -clock clk -module d04hgy2cld0c0
netlist port domain psb -clock clk -module d04hgy2cld0c0
netlist port domain si -ignore -module d04hgy2cld0c0
netlist port domain ssb -ignore -module d04hgy2cld0c0
netlist port domain so -ignore -module d04hgy2cld0c0
netlist port domain vcc -ignore -module d04hgy2cld0c0
cdc synchronizer custom d04hgy23nd0b0
netlist port domain -input d -async -clock clk -module d04hgy23nd0b0
netlist port domain -output o -clock clk -module d04hgy23nd0b0
netlist port domain rb -clock clk -module d04hgy23nd0b0
netlist port domain si -ignore -module d04hgy23nd0b0
netlist port domain ssb -ignore -module d04hgy23nd0b0
netlist port domain so -ignore -module d04hgy23nd0b0
netlist port domain vcc -ignore -module d04hgy23nd0b0
cdc synchronizer custom d04hgy23nd0c0
netlist port domain -input d -async -clock clk -module d04hgy23nd0c0
netlist port domain -output o -clock clk -module d04hgy23nd0c0
netlist port domain rb -clock clk -module d04hgy23nd0c0
netlist port domain si -ignore -module d04hgy23nd0c0
netlist port domain ssb -ignore -module d04hgy23nd0c0
netlist port domain so -ignore -module d04hgy23nd0c0
netlist port domain vcc -ignore -module d04hgy23nd0c0
cdc synchronizer custom d04hgy2cnd0b0
netlist port domain -input d -async -clock clk -module d04hgy2cnd0b0
netlist port domain -output o -clock clk -module d04hgy2cnd0b0
netlist port domain psb -clock clk -module d04hgy2cnd0b0
netlist port domain si -ignore -module d04hgy2cnd0b0
netlist port domain ssb -ignore -module d04hgy2cnd0b0
netlist port domain so -ignore -module d04hgy2cnd0b0
netlist port domain vcc -ignore -module d04hgy2cnd0b0
cdc synchronizer custom d04hgy2cnd0c0
netlist port domain -input d -async -clock clk -module d04hgy2cnd0c0
netlist port domain -output o -clock clk -module d04hgy2cnd0c0
netlist port domain psb -clock clk -module d04hgy2cnd0c0
netlist port domain si -ignore -module d04hgy2cnd0c0
netlist port domain ssb -ignore -module d04hgy2cnd0c0
netlist port domain so -ignore -module d04hgy2cnd0c0
netlist port domain vcc -ignore -module d04hgy2cnd0c0
# end do /p/com/eda/intel/cdc/v20140603/custom_sync_cells/p1273/custom_sync_cells.tcl
# do /nfs/fm/disks/fm_pmc_00089/ssing18/PGCB/ip-pwrmisc-tgl/tools/cdc/ClockDomainController/ClockDomainController_cdc.tcl
cdc preference -detect_pure_latch_clock
cdc preference -filtered_report
netlist clock pgcb_clk -group PGCB_CLK
netlist clock clock -group CDC_CLK
netlist clock prescc_clock -group PRESCC_CDC_CLK
netlist clock gclock -group CDC_CLK
netlist constant fscan_clkungate 1'b0
netlist constant fscan_rstbypen 0
netlist constant fscan_byprst_b 0
netlist constant fscan_clkgenctrlen 0
netlist port domain clkack -async
netlist port domain clkreq -clock PGCB_CLK
netlist port domain pok -clock CDC_CLK
netlist port domain gclock_enable_final -clock CDC_CLK
netlist port domain gclock_req_sync -clock CDC_CLK
netlist port domain gclock_req_async -async
netlist port domain gclock_ack_async -clock CDC_CLK
netlist port domain gclock_active -clock CDC_CLK
netlist port domain ism_fabric -clock CDC_CLK
netlist port domain ism_agent -clock CDC_CLK
netlist port domain ism_locked -clock CDC_CLK
netlist port domain boundary_locked -clock CDC_CLK
netlist port domain cfg_clkgate_disabled -async
netlist port domain cfg_clkreq_ctl_disabled -async
netlist port domain cfg_clkgate_holdoff -async
netlist port domain cfg_pwrgate_holdoff -async
netlist port domain cfg_clkreq_off_holdoff -async
netlist port domain cfg_clkreq_syncoff_holdoff -async
netlist port domain pwrgate_disabled -clock PGCB_CLK
netlist port domain pwrgate_force -clock PGCB_CLK
netlist port domain pwrgate_pmc_wake -clock PGCB_CLK
netlist port domain pwrgate_ready -clock PGCB_CLK
netlist port domain pgcb_force_rst_b -clock PGCB_CLK
netlist port domain pgcb_pok -clock PGCB_CLK
netlist port domain pgcb_restore -clock PGCB_CLK
netlist port domain pgcb_pwrgate_active -clock PGCB_CLK
netlist port domain fscan_clkungate -async
netlist port domain fismdfx_force_clkreq -async
netlist port domain fismdfx_clkgate_ovrd -async
netlist port domain fscan_byprst_b -async
netlist port domain fscan_rstbypen -async
netlist port domain fscan_clkgenctrlen -async
netlist port domain fscan_clkgenctrl -async
# end do /nfs/fm/disks/fm_pmc_00089/ssing18/PGCB/ip-pwrmisc-tgl/tools/cdc/ClockDomainController/ClockDomainController_cdc.tcl
# do /nfs/fm/disks/fm_pmc_00089/ssing18/PGCB/ip-pwrmisc-tgl/tools/cdc/ClockDomainController/ClockDomainController_waivers.tcl
cdc report crossing -scheme two_dff -through d -to o1 -severity waived -module d04hiy2cwd0b0 -comment This is an approved synchronizer cell
cdc report crossing -scheme two_dff -through d -to o1 -severity waived -module d04hiy23wd0b0 -comment This is an approved synchronizer cell
cdc report crossing -scheme two_dff -through d -to o1 -severity waived -module d04hgy2c*d0*0 -comment This is an approved synchronizer cell
cdc report crossing -scheme two_dff -through d -to o1 -severity waived -module d04hgy23*d0*0 -comment This is an approved synchronizer cell
cdc report crossing -scheme two_dff -through d -to o1 -severity waived -module d04hgn20*d0*0 -comment This is an approved synchronizer cell
cdc report crossing -scheme two_dff -through d -to o1 -severity waived -module d04hgn23*d0*0 -comment This is an approved synchronizer cell
cdc report crossing -rx_clock CDC_CLK -through cfg_clkgate_holdoff -severity waived -scheme multi_bits -module ClockDomainController
cdc report crossing -rx_clock CDC_CLK -through cfg_pwrgate_holdoff -severity waived -scheme multi_bits -module ClockDomainController
cdc report crossing -rx_clock CDC_CLK -through cfg_clkreq_off_holdoff -severity waived -scheme multi_bits -module ClockDomainController
cdc report crossing -rx_clock CDC_CLK -through cfg_clkreq_syncoff_holdoff -severity waived -scheme multi_bits -module ClockDomainController
cdc report crossing -rx_clock CDC_CLK -through *cfg_clkgate_holdoff -severity waived -scheme no_sync -module ClockDomainController
cdc report crossing -rx_clock CDC_CLK -through *cfg_pwrgate_holdoff -severity waived -scheme no_sync -module ClockDomainController
cdc report crossing -rx_clock CDC_CLK -through *cfg_clkreq_off_holdoff -severity waived -scheme no_sync -module ClockDomainController
cdc report crossing -rx_clock CDC_CLK -through *cfg_clkreq_syncoff_holdoff -severity waived -scheme no_sync -module ClockDomainController
cdc report crossing -rx_clock CDC_CLK -through *cfg_clkgate_holdoff -severity waived -scheme dmux -module ClockDomainController
cdc report crossing -rx_clock CDC_CLK -through *cfg_pwrgate_holdoff -severity waived -scheme dmux -module ClockDomainController
cdc report crossing -rx_clock CDC_CLK -through *cfg_clkreq_off_holdoff -severity waived -scheme dmux -module ClockDomainController
cdc report crossing -rx_clock CDC_CLK -through *cfg_clkreq_syncoff_holdoff -severity waived -scheme dmux -module ClockDomainController
cdc report crossing -rx_clock CDC_CLK -through *cfg_clkgate_holdoff -severity waived -scheme partial_dmux -module ClockDomainController
cdc report crossing -rx_clock CDC_CLK -through *cfg_pwrgate_holdoff -severity waived -scheme partial_dmux -module ClockDomainController
cdc report crossing -rx_clock CDC_CLK -through *cfg_clkreq_off_holdoff -severity waived -scheme partial_dmux -module ClockDomainController
cdc report crossing -rx_clock CDC_CLK -through *cfg_clkreq_syncoff_holdoff -severity waived -scheme partial_dmux -module ClockDomainController
cdc report crossing -rx_clock CDC_CLK -through *cfg_clkgate_holdoff -severity waived -scheme multi_sync_mux_select -module ClockDomainController
cdc report crossing -rx_clock CDC_CLK -through *cfg_pwrgate_holdoff -severity waived -scheme multi_sync_mux_select -module ClockDomainController
cdc report crossing -rx_clock CDC_CLK -through *cfg_clkreq_off_holdoff -severity waived -scheme multi_sync_mux_select -module ClockDomainController
cdc report crossing -rx_clock CDC_CLK -through *cfg_clkreq_syncoff_holdoff -severity waived -scheme multi_sync_mux_select -module ClockDomainController
cdc report crossing -rx_clock PGCB_CLK -through *pgcb_force_rst_b -severity waived -scheme partial_dmux -module ClockDomainController
cdc report crossing -rx_clock CDC_CLK -through *pgcb_force_rst_b -through *greset_b -severity waived -scheme no_sync -module ClockDomainController
cdc report crossing -from cfg_clkgate_holdoff -to boundary_locked -severity waived -scheme redundant -module ClockDomainController
cdc report crossing -from cfg_clkgate_holdoff -to ism_locked -severity waived -scheme redundant -module ClockDomainController
cdc report crossing -from cfg_clkreq_off_holdoff -to boundary_locked -severity waived -scheme redundant -module ClockDomainController
cdc report crossing -from cfg_clkreq_off_holdoff -to ism_locked -severity waived -scheme redundant -module ClockDomainController
cdc report crossing -from cfg_clkreq_syncoff_holdoff -to boundary_locked -severity waived -scheme redundant -module ClockDomainController
cdc report crossing -from cfg_clkreq_syncoff_holdoff -to ism_locked -severity waived -scheme redundant -module ClockDomainController
cdc report crossing -from cfg_pwrgate_holdoff -to boundary_locked -severity waived -scheme redundant -module ClockDomainController
cdc report crossing -from cfg_pwrgate_holdoff -to ism_locked -severity waived -scheme redundant -module ClockDomainController
cdc report crossing -to cdc_visa* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_clkgate_dis_sync* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_clkreq_dis_sync* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_powerGateDisable* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_force_clkreq_sync* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_clkgate_ovrd_sync* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_clkreq_start_hold_ack_ByPgcb* -to *clkreq_hold* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gClockReqAsyncSync* -to *u_CdcMainClock.clkreq_start_hold* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_unlockIsm* -to *u_CdcMainClock.clkreq_start_hold* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_clkackSync* -to *u_CdcMainClock.clkreq_start_hold* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_forcePowerGate* -to *u_CdcMainClock.clkreq_start_hold* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_forcePowerGateNoPGActive* -to *u_CdcMainClock.clkreq_start_hold* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gclock_req_async_ByPgcb* -to *u_CdcMainClock.clkreq_start_hold* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_ism_lockedByPgcb* -to *u_CdcMainClock.clkreq_start_hold* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gclock_req_async_ByPgcb* -to *u_CdcMainClock.clkreq_start_hold* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gclock_req_sync_ByPgcb* -to *u_CdcMainClock.clkreq_start_hold* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_pgcbPok* -to *u_CdcMainClock.clkreq_start_hold* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_pwrgate_active* -to *u_CdcMainClock.clkreq_start_hold* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_unlockAll* -to *u_CdcMainClock.clkreq_start_hold* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_clkreqStartHoldPG* -to *assert_clkreq_pg* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_clkreqStartHoldPG* -to *u_CdcPgcbClock.clkreq* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_clkreqStartHoldPG* -to *u_CdcPgcbClock.clkreq_start_ok* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_unlockIsm* -to *idle_timer* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_unlockIsm* -to *current_state* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_unlockIsm* -to *cfg_update* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_unlockIsm* -to *boundary_locked* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_unlockIsm* -to *ism_locked* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_unlockIsm* -to *clkreq_hold* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_unlockIsm* -to *domain_locked* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_unlockIsm* -to *force_ready* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_unlockIsm* -to *gclock_ack_async* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_unlockIsm* -to *gclock_active -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_unlockIsm* -to *gclock_enable -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_unlockIsm* -to *clkgate_disabled -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gClockReqAsyncSync* -to *idle_timer* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gClockReqAsyncSync* -to *current_state* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gClockReqAsyncSync* -to *cfg_update* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gClockReqAsyncSync* -to *boundary_locked* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gClockReqAsyncSync* -to *ism_locked* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gClockReqAsyncSync* -to *clkreq_hold* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gClockReqAsyncSync* -to *domain_locked* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gClockReqAsyncSync* -to *force_ready* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gClockReqAsyncSync* -to *gclock_ack_async* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gClockReqAsyncSync* -to *gclock_active -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gClockReqAsyncSync* -to *gclock_enable -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gClockReqAsyncSync* -to *clkgate_disabled -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_pgcbPok* -to *idle_timer* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_pgcbPok* -to *current_state* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_pgcbPok* -to *cfg_update* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_pgcbPok* -to *boundary_locked* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_pgcbPok* -to *ism_locked* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_pgcbPok* -to *clkreq_hold* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_pgcbPok* -to *domain_locked* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_pgcbPok* -to *force_read* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_pgcbPok* -to *gclock_ack_async* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_pgcbPok* -to *gclock_active -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_pgcbPok* -to *gclock_enable -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_pgcbPok* -to *clkgate_disabled -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_clkackSync* -to *idle_timer* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_clkackSync* -to *current_state* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_clkackSync* -to *cfg_update* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_clkackSync* -to *boundary_locked* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_clkackSync* -to *ism_locked* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_clkackSync* -to *clkreq_hold* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_clkackSync* -to *domain_locked* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_clkackSync* -to *force_ready* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_clkackSync* -to *gclock_ack_async* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_clkackSync* -to *gclock_active -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_clkackSync* -to *gclock_enable -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_clkackSync* -to *clkgate_disabled -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_pwrgate_active* -to *idle_timer* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_pwrgate_active* -to *current_state* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_pwrgate_active* -to *cfg_update* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_pwrgate_active* -to *boundary_locked* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_pwrgate_active* -to *ism_locked* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_pwrgate_active* -to *clkreq_hold* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_pwrgate_active* -to *domain_locked* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_pwrgate_active* -to *force_ready* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_pwrgate_active* -to *gclock_ack_async* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_pwrgate_active* -to *gclock_active -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_pwrgate_active* -to *gclock_enable -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_pwrgate_active* -to *clkgate_disabled -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_forcePowerGate* -to *idle_timer* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_forcePowerGate* -to *current_state* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_forcePowerGate* -to *cfg_update* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_forcePowerGate* -to *boundary_locked* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_forcePowerGate* -to *ism_locked* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_forcePowerGate* -to *clkreq_hold* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_forcePowerGate* -to *domain_locked* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_forcePowerGate* -to *force_ready* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_forcePowerGate* -to *gclock_ack_async* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_forcePowerGate* -to *gclock_active -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_forcePowerGate* -to *gclock_enable -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_forcePowerGate* -to *clkgate_disabled -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_unlockAll* -to *idle_timer* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_unlockAll* -to *current_state* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_unlockAll* -to *cfg_update* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_unlockAll* -to *boundary_locked* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_unlockAll* -to *ism_locked* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_unlockAll* -to *clkreq_hold* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_unlockAll* -to *domain_locked* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_unlockAll* -to *force_ready* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_unlockAll* -to *gclock_ack_async* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_unlockAll* -to *gclock_active -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_unlockAll* -to *gclock_enable -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_unlockAll* -to *clkgate_disabled -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_forcePowerGateNoPGActive* -to *idle_timer* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_forcePowerGateNoPGActive* -to *current_state* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_forcePowerGateNoPGActive* -to *cfg_update* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_forcePowerGateNoPGActive* -to *boundary_locked* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_forcePowerGateNoPGActive* -to *ism_locked* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_forcePowerGateNoPGActive* -to *clkreq_hold* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_forcePowerGateNoPGActive* -to *domain_locked* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_forcePowerGateNoPGActive* -to *force_ready* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_forcePowerGateNoPGActive* -to *gclock_ack_async* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_forcePowerGateNoPGActive* -to *gclock_active -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_forcePowerGateNoPGActive* -to *gclock_enable -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_forcePowerGateNoPGActive* -to *clkgate_disabled -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gclock_req_async_ByPgcb* -to *idle_timer* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gclock_req_sync_ByPgcb* -to *idle_timer* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_ism_lockedByPgcb* -to *idle_timer* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gclock_req_async_ByPgcb* -to *current_state* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gclock_req_sync_ByPgcb* -to *current_state* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_ism_lockedByPgcb* -to *current_state* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gclock_req_async_ByPgcb* -to *cfg_update* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gclock_req_sync_ByPgcb* -to *cfg_update* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_ism_lockedByPgcb* -to *cfg_update* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gclock_req_async_ByPgcb* -to *boundary_locked* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gclock_req_sync_ByPgcb* -to *boundary_locked* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_ism_lockedByPgcb* -to *boundary_locked* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gclock_req_async_ByPgcb* -to *ism_locked* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gclock_req_sync_ByPgcb* -to *ism_locked* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_ism_lockedByPgcb* -to *ism_locked* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gclock_req_async_ByPgcb* -to *clkreq_hold* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gclock_req_sync_ByPgcb* -to *clkreq_hold* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_ism_lockedByPgcb* -to *clkreq_hold* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gclock_req_async_ByPgcb* -to *domain_locked* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gclock_req_sync_ByPgcb* -to *domain_locked* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_ism_lockedByPgcb* -to *domain_locked* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gclock_req_async_ByPgcb* -to *force_ready* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gclock_req_sync_ByPgcb* -to *force_ready* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_ism_lockedByPgcb* -to *force_ready* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gclock_req_async_ByPgcb* -to *gclock_ack_async* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gclock_req_sync_ByPgcb* -to *gclock_ack_async* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_ism_lockedByPgcb* -to *gclock_ack_async* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gclock_req_async_ByPgcb* -to *gclock_active -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gclock_req_sync_ByPgcb* -to *gclock_active -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_ism_lockedByPgcb* -to *gclock_active -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gclock_req_async_ByPgcb* -to *gclock_enable -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gclock_req_sync_ByPgcb* -to *gclock_enable -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_ism_lockedByPgcb* -to *gclock_enable -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gclock_req_async_ByPgcb* -to *clkgate_disabled -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gclock_req_sync_ByPgcb* -to *clkgate_disabled -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_ism_lockedByPgcb* -to *clkgate_disabled -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_unlockIsm* -to *last_do_force_pgate* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_forcePowerGate* -to *last_do_force_pgate* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_pgcbPok* -to *last_do_force_pgate* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_pwrgate_active* -to *last_do_force_pgate* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_unlockAll* -to *last_do_force_pgate* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gclock_req_async_ByPgcb* -to *last_do_force_pgate* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gclock_req_sync_ByPgcb* -to *last_do_force_pgate* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_ism_lockedByPgcb* -to *last_do_force_pgate* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gClockReqAsyncSync* -to *last_gclock_req* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gclock_req_async_ByPgcb* -to *last_gclock_req* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gclock_req_sync_ByPgcb* -to *last_gclock_req* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_gClockReqAsyncSync* -to *pok_preout* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock CDC_CLK -rx_clock CDC_CLK -from *u_clkackSync* -to *pok_preout* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_dfxForceClkreq* -to *unlock_domain_pg* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_gClockReqSyncPG* -to *unlock_domain_pg* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_gClockReqAsyncPG* -to *unlock_domain_pg* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_lockedPG* -to *unlock_domain_pg* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_domainIsmLockedPG* -to *unlock_domain_pg* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_ismWakePG* -to *unlock_domain_pg* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_dfxForceClkreq* -to *force_pgate_req* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_gClockReqSyncPG* -to *force_pgate_req* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_gClockReqAsyncPG* -to *force_pgate_req* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_lockedPG* -to *force_pgate_req* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_domainIsmLockedPG* -to *force_pgate_req* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_ismWakePG* -to *force_pgate_req* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_dfxForceClkreq* -to *pwrgate_ready* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_gClockReqSyncPG* -to *pwrgate_ready* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_gClockReqAsyncPG* -to *pwrgate_ready* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_lockedPG* -to *pwrgate_ready* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_domainIsmLockedPG* -to *pwrgate_ready* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_ismWakePG* -to *pwrgate_ready* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_forceRdyPG* -to *pwrgate_ready* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_dfxForceClkreq* -to *assert_clkreq_pg* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *AsyncReqXC* -to *assert_clkreq_pg* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_gClockReqSyncPG* -to *assert_clkreq_pg* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_lockedPG* -to *assert_clkreq_pg* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_forceRdyPG* -to *assert_clkreq_pg* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *SyncForDefPwrOn* -to *assert_clkreq_pg* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_ismWakePG* -to *assert_clkreq_pg* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_domainPokPG* -to *assert_clkreq_pg* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_domainIsmLockedPG* -to *assert_clkreq_pg* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_gClockReqSyncPG* -to *cdc_restore_pg* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_domainIsmLockedPG* -to *cdc_restore_pg* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_ismWakePG* -to *cdc_restore_pg* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_lockedPG* -to *cdc_restore_pg* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_gClockReqAsyncPG* -to *clkreq* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_clkreqHoldPG* -to *clkreq* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_dfxForceClkreq* -to *clkreq* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_domainIsmLockedPG* -to *clkreq* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_domainPokPG* -to *clkreq* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_gClockReqSyncPG* -to *clkreq* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_ismWakePG* -to *clkreq* -severity waived -scheme reconvergence -module ClockDomainController
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *u_lockedPG* -to *clkreq* -severity waived -scheme reconvergence -module ClockDomainController
# end do /nfs/fm/disks/fm_pmc_00089/ssing18/PGCB/ip-pwrmisc-tgl/tools/cdc/ClockDomainController/ClockDomainController_waivers.tcl
cdc run -work cdc_ClockDomainController_lib -L work -L pgcb_collection_cdc_testlib -L cdc_tooltb_lib -L cdc_synccell_lib -L cdc_pgcbcg_lib -L cdc_ClockDomainController_lib -L cdc_pgcbunit_lib -d ClockDomainController -hier
cdc generate crossings /nfs/fm/disks/fm_pmc_00089/ssing18/PGCB/ip-pwrmisc-tgl/tools/cdc/tests/cdc_ClockDomainController/Violation_Details.rpt
cdc generate tree -reset /nfs/fm/disks/fm_pmc_00089/ssing18/PGCB/ip-pwrmisc-tgl/tools/cdc/tests/cdc_ClockDomainController/Reset_Details.rpt
cdc generate tree -clock /nfs/fm/disks/fm_pmc_00089/ssing18/PGCB/ip-pwrmisc-tgl/tools/cdc/tests/cdc_ClockDomainController/Clock_Details.rpt
# end do /nfs/fm/disks/fm_pmc_00089/ssing18/PGCB/ip-pwrmisc-tgl/qcdc_da.tcl
