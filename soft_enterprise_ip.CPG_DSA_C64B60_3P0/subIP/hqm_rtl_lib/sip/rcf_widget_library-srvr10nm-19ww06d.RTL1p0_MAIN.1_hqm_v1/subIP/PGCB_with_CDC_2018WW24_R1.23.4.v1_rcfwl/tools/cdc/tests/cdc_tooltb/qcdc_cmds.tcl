configure license queue on
# do /nfs/fm/disks/fm_cnp_00026/yjkim1/PGCB/CDC_Fixes/pgcbrepo_1.21_pre_release/qcdc_da.tcl
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
# do /nfs/fm/disks/fm_cnp_00026/yjkim1/PGCB/CDC_Fixes/pgcbrepo_1.21_pre_release/tools/cdc/tooltb/tooltb_cdc.tcl
netlist clock pgcb_clk -group PGCB_CLK
netlist clock clock -group CDC_CLK
netlist clock prescc_clock -group CDC_CLK
netlist clock pgcb_tck -group PGCB_TCK
netlist constant fscan_clkungate 0
netlist constant fscan_rstbypen 0
netlist constant fscan_byprst_b 0
netlist constant fscan_clkgenctrlen 0
netlist constant fscan_clkgenctrl 0
netlist port domain gclock_req_async -async
netlist port domain cfg_clkgate_disabled -async
netlist port domain cfg_clkreq_ctl_disabled -async
netlist port domain cfg_clkgate_holdoff -async
netlist port domain cfg_pwrgate_holdoff -async
netlist port domain cfg_clkreq_off_holdoff -async
netlist port domain cfg_clkreq_syncoff_holdoff -async
netlist port domain pmc_ip_wake -async
netlist port domain pwrgate_disabled -async
netlist port domain pmc_pgcb_pg_ack_b -async
netlist port domain pmc_pgcb_restore_b -async
netlist port domain pmc_pgcb_fet_en_b -async
netlist port domain pgcb_clkack -async
netlist port domain pgcb_ip_fet_en_b -async
netlist port domain pgcb_clkreq -async
netlist port domain clkack -async
netlist port domain gclock_req_sync -clock CDC_CLK
netlist port domain ism_fabric -clock CDC_CLK
netlist port domain ism_agent -clock CDC_CLK
netlist port domain pok -clock CDC_CLK
netlist port domain gclock_enable_final -clock CDC_CLK
netlist port domain gclock -clock CDC_CLK
netlist port domain greset_b -clock CDC_CLK
netlist port domain gclock_active -clock CDC_CLK
netlist port domain ism_locked -clock CDC_CLK
netlist port domain boundary_locked -clock CDC_CLK
netlist port domain gclock_ack_async -clock CDC_CLK
netlist port domain clkreq -clock PGCB_CLK
netlist port domain pwrgate_force -clock PGCB_CLK
netlist port domain ip_pgcb_pg_type -clock PGCB_CLK
netlist port domain ip_pgcb_all_pg_rst_up -clock PGCB_CLK
netlist port domain ip_pgcb_frc_clk_srst_cc_en -clock PGCB_CLK
netlist port domain ip_pgcb_frc_clk_cp_en -clock PGCB_CLK
netlist port domain ip_pgcb_force_clks_on_ack -clock PGCB_CLK
netlist port domain ip_pgcb_sleep_en -clock PGCB_CLK
netlist port domain cfg_acc_clkgate_disabled -clock PGCB_CLK
netlist port domain cfg_t_clkgate -clock PGCB_CLK
netlist port domain cfg_t_clkwake -clock PGCB_CLK
netlist port domain pgcb_ip_force_clks_on -clock PGCB_CLK
netlist port domain pgcb_pmc_pg_req_b -clock PGCB_CLK
netlist port domain pgcb_ip_pg_rdy_ack_b -clock PGCB_CLK
netlist port domain pgcb_restore_force_reg_rw -clock PGCB_CLK
netlist port domain pgcb_sleep -clock PGCB_CLK
netlist port domain pgcb_sleep2 -clock PGCB_CLK
netlist port domain pgcb_isol_latchen -clock PGCB_CLK
netlist port domain pgcb_isol_en_b -clock PGCB_CLK
netlist port domain fismdfx_force_clkreq -async
netlist port domain fismdfx_clkgate_ovrd -async
netlist port domain fdfx_pgcb_bypass -clock PGCB_TCK
netlist port domain fdfx_pgcb_ovr -clock PGCB_TCK
netlist port domain fscan_ret_ctrl -clock PGCB_TCK
netlist port domain fscan_mode -clock PGCB_TCK
# end do /nfs/fm/disks/fm_cnp_00026/yjkim1/PGCB/CDC_Fixes/pgcbrepo_1.21_pre_release/tools/cdc/tooltb/tooltb_cdc.tcl
# do /nfs/fm/disks/fm_cnp_00026/yjkim1/PGCB/CDC_Fixes/pgcbrepo_1.21_pre_release/verif/pcgu_ref/waivers/pgcbcg_cdc_waivers.tcl
cdc report crossing -scheme combo_logic -through *iosf_cdc_clkack -through *i_pgcb_ctech_doublesync_idle_event.d -rx_clock PGCB_CLK -severity waived -module pgcbcg
cdc report crossing -scheme combo_logic -through *iosf_cdc_gclock_ack_async* -through *i_pgcb_ctech_doublesync_idle_event.d -severity waived -module pgcbcg
cdc report crossing -scheme no_sync -through visa_bus -severity waived -module pgcbcg
# end do /nfs/fm/disks/fm_cnp_00026/yjkim1/PGCB/CDC_Fixes/pgcbrepo_1.21_pre_release/verif/pcgu_ref/waivers/pgcbcg_cdc_waivers.tcl
# do /nfs/fm/disks/fm_cnp_00026/yjkim1/PGCB/CDC_Fixes/pgcbrepo_1.21_pre_release/tools/cdc/pgcbcg/pgcbcg_waivers.tcl
cdc report crossing -scheme no_sync -through async_pmc_ip_wake -through pgcb_clkreq -severity waived -module pcgu
cdc report crossing -scheme no_sync -tx_clock PGCB_CLK -from defon_flag -through pgcb_clkreq -severity waived -module pcgu
cdc report crossing -scheme no_sync -tx_clock PGCB_CLK -from mask_pmc_wake -through pgcb_clkreq -severity waived -module pcgu
cdc report crossing -scheme no_sync -tx_clock PGCB_CLK -from mask_acc_wake -through pgcb_clkreq -severity waived -module pcgu
cdc report crossing -scheme no_sync -tx_clock PGCB_CLK -from clkreq_sustain -through pgcb_clkreq -severity waived -module pcgu
cdc report crossing -scheme no_sync -tx_clock PGCB_CLK -from acc_wake_flop -through pgcb_clkreq -severity waived -module pcgu
cdc report crossing -scheme combo_logic -through async_pmc_ip_wake -through i_pgcb_ctech_doublesync_pmc_wake.d -severity waived -module pcgu
cdc report crossing -through async_wake_source_b -through i_pgcb_ctech_doublesync_async_wake_*.clr_b -rx_clock PGCB_CLK -module pcgu_aww -severity waived
# end do /nfs/fm/disks/fm_cnp_00026/yjkim1/PGCB/CDC_Fixes/pgcbrepo_1.21_pre_release/tools/cdc/pgcbcg/pgcbcg_waivers.tcl
# do /nfs/fm/disks/fm_cnp_00026/yjkim1/PGCB/CDC_Fixes/pgcbrepo_1.21_pre_release/tools/cdc/ClockDomainController/ClockDomainController_waivers.tcl
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
cdc report crossing -through *pgcb_reset_b -through *ctech_lib_doublesync_rstb1.rstb -severity waived -scheme custom_sync_mismatch -module ClockDomainController
# end do /nfs/fm/disks/fm_cnp_00026/yjkim1/PGCB/CDC_Fixes/pgcbrepo_1.21_pre_release/tools/cdc/ClockDomainController/ClockDomainController_waivers.tcl
# do /nfs/fm/disks/fm_cnp_00026/yjkim1/PGCB/CDC_Fixes/pgcbrepo_1.21_pre_release/tools/cdc/pgcbunit/pgcbunit_waivers.tcl
cdc report crossing -scheme no_sync -tx_clock PGCB_TCK -through *i_pgcbdfxovr1.dfxovr_isol_en_b -severity waived -module pgcbunit
cdc report crossing -scheme no_sync -tx_clock PGCB_TCK -through *i_pgcbdfxovr1.dfxovr_isol_latchen -severity waived -module pgcbunit
cdc report crossing -scheme no_sync -tx_clock PGCB_TCK -through *i_pgcbdfxovr1.dfxovr_force_rst_b -severity waived -module pgcbunit
cdc report crossing -scheme no_sync -tx_clock PGCB_TCK -through *i_pgcbdfxovr1.dfxovr_sleep* -severity waived -module pgcbunit
cdc report crossing -scheme combo_logic -through *i_pgcbdfxovr1.dfxovr_pok -through pgcb_pok -severity waived -module pgcbunit
cdc report crossing -scheme no_sync -through *i_pgcbdfxovr1.dfxovr_fet_en_b -severity waived -module pgcbunit
cdc report crossing -rx_clock PGCB_CLK -through *fdfx_pgcb_bypass -severity waived -scheme partial_dmux -module pgcbunit
# end do /nfs/fm/disks/fm_cnp_00026/yjkim1/PGCB/CDC_Fixes/pgcbrepo_1.21_pre_release/tools/cdc/pgcbunit/pgcbunit_waivers.tcl
cdc run -work cdc_tooltb_lib -L work -L pgcb_collection_cdc_testlib -L cdc_tooltb_lib -L cdc_synccell_lib -L cdc_pgcbcg_lib -L cdc_ClockDomainController_lib -L cdc_pgcbunit_lib -d tooltb -hier
cdc generate crossings /nfs/fm/disks/fm_cnp_00026/yjkim1/PGCB/CDC_Fixes/pgcbrepo_1.21_pre_release/tools/cdc/tests/cdc_tooltb/Violation_Details.rpt
cdc generate tree -reset /nfs/fm/disks/fm_cnp_00026/yjkim1/PGCB/CDC_Fixes/pgcbrepo_1.21_pre_release/tools/cdc/tests/cdc_tooltb/Reset_Details.rpt
cdc generate tree -clock /nfs/fm/disks/fm_cnp_00026/yjkim1/PGCB/CDC_Fixes/pgcbrepo_1.21_pre_release/tools/cdc/tests/cdc_tooltb/Clock_Details.rpt
# end do /nfs/fm/disks/fm_cnp_00026/yjkim1/PGCB/CDC_Fixes/pgcbrepo_1.21_pre_release/qcdc_da.tcl
