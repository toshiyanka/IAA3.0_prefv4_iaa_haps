configure license queue on
# do /nfs/fm/disks/fm_cnp_00026/yjkim1/PGCB/REV_1_23/ip-pwrmisc/qcdc_da.tcl
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
# do /nfs/fm/disks/fm_cnp_00026/yjkim1/PGCB/REV_1_23/ip-pwrmisc/tools/cdc/pgcbunit/pgcbunit_cdc.tcl
cdc preference -detect_pure_latch_clock
netlist clock clk -group PGCB_CLK
netlist clock pgcb_tck -group PGCB_TCK
netlist port domain pgcb_pmc_pg_req_b -clock PGCB_CLK
netlist port domain pmc_pgcb_pg_ack_b -async
netlist port domain pmc_pgcb_restore_b -async
netlist port domain ip_pgcb_pg_rdy_req_b -clock PGCB_CLK
netlist port domain pgcb_ip_pg_rdy_ack_b -clock PGCB_CLK
netlist port domain ip_pgcb_pg_type -clock PGCB_CLK
netlist port domain pgcb_pok -clock PGCB_CLK
netlist port domain pgcb_restore -clock PGCB_CLK
netlist port domain pgcb_restore_force_reg_rw -clock PGCB_CLK
netlist port domain pgcb_sleep -clock PGCB_CLK
netlist port domain pgcb_sleep2 -clock PGCB_CLK
netlist port domain pgcb_isol_latchen -clock PGCB_CLK
netlist port domain pgcb_isol_en_b -clock PGCB_CLK
netlist port domain pgcb_force_rst_b -clock PGCB_CLK
netlist port domain ip_pgcb_all_pg_rst_up -clock PGCB_CLK
netlist port domain pgcb_idle -clock PGCB_CLK
netlist port domain pgcb_pwrgate_active -clock PGCB_CLK
netlist port domain ip_pgcb_frc_PGCB_CLK_srst_cc_en -clock clk
netlist port domain ip_pgcb_frc_PGCB_CLK_cp_en -clock clk
netlist port domain pgcb_ip_force_PGCB_CLKs_on -clock clk
netlist port domain ip_pgcb_force_PGCB_CLKs_on_ack -clock clk
netlist port domain cfg_tsleepinactiv -clock PGCB_CLK
netlist port domain cfg_tdeisolate -clock PGCB_CLK
netlist port domain cfg_tpokup -clock PGCB_CLK
netlist port domain cfg_tinaccrstup -clock PGCB_CLK
netlist port domain cfg_taccrstup -clock PGCB_CLK
netlist port domain cfg_tlatchen -clock PGCB_CLK
netlist port domain cfg_tpokdown -clock PGCB_CLK
netlist port domain cfg_tlatchdis -clock PGCB_CLK
netlist port domain cfg_tsleepact -clock PGCB_CLK
netlist port domain cfg_tisolate -clock PGCB_CLK
netlist port domain cfg_trstdown -clock PGCB_CLK
netlist port domain cfg_tPGCB_CLKsonack_srst -clock clk
netlist port domain cfg_tPGCB_CLKsoffack_srst -clock clk
netlist port domain cfg_tPGCB_CLKsonack_cp -clock clk
netlist port domain cfg_trstup2frcPGCB_CLKs -clock clk
netlist port domain cfg_trsvd0 -clock PGCB_CLK
netlist port domain cfg_trsvd1 -clock PGCB_CLK
netlist port domain cfg_trsvd2 -clock PGCB_CLK
netlist port domain cfg_trsvd3 -clock PGCB_CLK
netlist port domain cfg_trsvd4 -clock PGCB_CLK
netlist port domain pmc_pgcb_fet_en_b -async
netlist port domain pgcb_ip_fet_en_b -async
netlist port domain fdfx_pgcb_bypass -clock PGCB_TCK
netlist port domain fdfx_pgcb_ovr -clock PGCB_TCK
netlist port domain fscan_ret_ctrl -clock PGCB_TCK
netlist port domain fscan_mode -clock PGCB_TCK
# end do /nfs/fm/disks/fm_cnp_00026/yjkim1/PGCB/REV_1_23/ip-pwrmisc/tools/cdc/pgcbunit/pgcbunit_cdc.tcl
# do /nfs/fm/disks/fm_cnp_00026/yjkim1/PGCB/REV_1_23/ip-pwrmisc/tools/cdc/pgcbunit/pgcbunit_waivers.tcl
cdc report crossing -scheme no_sync -tx_clock PGCB_TCK -through *i_pgcbdfxovr1.pgcb_isol_en_b -severity waived -module pgcbunit
cdc report crossing -scheme no_sync -tx_clock PGCB_TCK -through *i_pgcbdfxovr1.pgcb_isol_latchen -severity waived -module pgcbunit
cdc report crossing -scheme no_sync -tx_clock PGCB_TCK -through *i_pgcbdfxovr1.dfxovr_force_rst_b -severity waived -module pgcbunit
cdc report crossing -scheme no_sync -tx_clock PGCB_TCK -through *i_pgcbdfxovr1.pgcb_sleep* -severity waived -module pgcbunit
cdc report crossing -scheme combo_logic -through *i_pgcbdfxovr1.dfxovr_pok -through pgcb_pok -severity waived -module pgcbunit
cdc report crossing -scheme no_sync -through *i_pgcbdfxovr1.dfxovr_fet_en_b -severity waived -module pgcbunit
cdc report crossing -rx_clock PGCB_CLK -through *fdfx_pgcb_bypass -severity waived -scheme partial_dmux -module pgcbunit
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *pmc_pgcb_restore_b* -to *cnt_val* -severity waived -scheme reconvergence -module pgcbunit
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *pmc_pgcb_pg_ack_b* -to *cnt_val* -severity waived -scheme reconvergence -module pgcbunit
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *pmc_pgcb_restore_b* -to *pgcb_force_rst_b -severity waived -scheme reconvergence -module pgcbunit
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *pmc_pgcb_pg_ack_b* -to *pgcb_force_rst_b -severity waived -scheme reconvergence -module pgcbunit
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *pmc_pgcb_restore_b* -to *pgcb_idle -severity waived -scheme reconvergence -module pgcbunit
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *pmc_pgcb_pg_ack_b* -to *pgcb_idle -severity waived -scheme reconvergence -module pgcbunit
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *pmc_pgcb_restore_b* -to *pgcb_ps -severity waived -scheme reconvergence -module pgcbunit
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *pmc_pgcb_pg_ack_b* -to *pgcb_ps -severity waived -scheme reconvergence -module pgcbunit
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *pmc_pgcb_restore_b* -to *int_restore_b -severity waived -scheme reconvergence -module pgcbunit
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *pmc_pgcb_pg_ack_b* -to *int_restore_b -severity waived -scheme reconvergence -module pgcbunit
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *pmc_pgcb_restore_b* -to *pgcb_restore -severity waived -scheme reconvergence -module pgcbunit
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *pmc_pgcb_pg_ack_b* -to *pgcb_restore -severity waived -scheme reconvergence -module pgcbunit
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *pmc_pgcb_restore_b* -to *pgcb_ip_force_clks_on -severity waived -scheme reconvergence -module pgcbunit
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *pmc_pgcb_pg_ack_b* -to *pgcb_ip_force_clks_on -severity waived -scheme reconvergence -module pgcbunit
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *pmc_pgcb_restore_b* -to *pgcb_ip_pg_rdy_ack_b -severity waived -scheme reconvergence -module pgcbunit
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *pmc_pgcb_pg_ack_b* -to *pgcb_ip_pg_rdy_ack_b -severity waived -scheme reconvergence -module pgcbunit
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *pmc_pgcb_restore_b* -to *pgcb_isol_en_b -severity waived -scheme reconvergence -module pgcbunit
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *pmc_pgcb_pg_ack_b* -to *pgcb_isol_en_b -severity waived -scheme reconvergence -module pgcbunit
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *pmc_pgcb_restore_b* -to *pgcb_isol_latchen -severity waived -scheme reconvergence -module pgcbunit
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *pmc_pgcb_pg_ack_b* -to *pgcb_isol_latchen -severity waived -scheme reconvergence -module pgcbunit
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *pmc_pgcb_restore_b* -to *pgcb_pmc_pg_req_b -severity waived -scheme reconvergence -module pgcbunit
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *pmc_pgcb_pg_ack_b* -to *pgcb_pmc_pg_req_b -severity waived -scheme reconvergence -module pgcbunit
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *pmc_pgcb_restore_b* -to *pgcb_pok -severity waived -scheme reconvergence -module pgcbunit
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *pmc_pgcb_pg_ack_b* -to *pgcb_pok -severity waived -scheme reconvergence -module pgcbunit
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *pmc_pgcb_restore_b* -to *pgcb_sleep* -severity waived -scheme reconvergence -module pgcbunit
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *pmc_pgcb_pg_ack_b* -to *pgcb_sleep* -severity waived -scheme reconvergence -module pgcbunit
# end do /nfs/fm/disks/fm_cnp_00026/yjkim1/PGCB/REV_1_23/ip-pwrmisc/tools/cdc/pgcbunit/pgcbunit_waivers.tcl
cdc run -work cdc_pgcbunit_lib -L work -L pgcb_collection_cdc_testlib -L cdc_tooltb_lib -L cdc_synccell_lib -L cdc_pgcbcg_lib -L cdc_ClockDomainController_lib -L cdc_pgcbunit_lib -d pgcbunit -hier
cdc generate crossings /nfs/fm/disks/fm_cnp_00026/yjkim1/PGCB/REV_1_23/ip-pwrmisc/tools/cdc/tests/cdc_pgcbunit/Violation_Details.rpt
cdc generate tree -reset /nfs/fm/disks/fm_cnp_00026/yjkim1/PGCB/REV_1_23/ip-pwrmisc/tools/cdc/tests/cdc_pgcbunit/Reset_Details.rpt
cdc generate tree -clock /nfs/fm/disks/fm_cnp_00026/yjkim1/PGCB/REV_1_23/ip-pwrmisc/tools/cdc/tests/cdc_pgcbunit/Clock_Details.rpt
# end do /nfs/fm/disks/fm_cnp_00026/yjkim1/PGCB/REV_1_23/ip-pwrmisc/qcdc_da.tcl
