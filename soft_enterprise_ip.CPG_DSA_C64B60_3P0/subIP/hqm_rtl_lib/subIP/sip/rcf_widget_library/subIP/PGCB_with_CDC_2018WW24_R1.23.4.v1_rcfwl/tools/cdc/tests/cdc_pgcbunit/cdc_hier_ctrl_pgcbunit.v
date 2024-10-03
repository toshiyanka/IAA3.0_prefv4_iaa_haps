
//- Questa CDC Version 10.3c_2 linux_x86_64 23 Sep 2014

//-----------------------------------------------------------------
// CDC Hierarchical Control File
// Created Mon Oct 17 21:18:43 2016
//-----------------------------------------------------------------

module pgcbunit_ctrl; // Hierarchical CDC warning: Do not change the module name

// INPUT PORTS

// 0in set_cdc_clock clk -group PGCB_CLK -module pgcbunit
// 0in set_cdc_clock pgcb_tck -group PGCB_TCK -module pgcbunit
// Reason for -async: User specified
// 0in set_cdc_port_domain pmc_pgcb_pg_ack_b -async -module pgcbunit 
// Reason for -async: User specified
// 0in set_cdc_port_domain pmc_pgcb_restore_b -async -module pgcbunit 
// Reason for -clock: User specified
// 0in set_cdc_port_domain ip_pgcb_pg_type -clock clk -module pgcbunit
// Reason for -clock: User specified
// 0in set_cdc_port_domain ip_pgcb_pg_rdy_req_b -clock clk -module pgcbunit
// Reason for -clock: User specified
// 0in set_cdc_port_domain ip_pgcb_all_pg_rst_up -clock clk -module pgcbunit
// Reason for -clock: User specified
// 0in set_cdc_port_domain cfg_tsleepinactiv -clock clk -module pgcbunit
// Reason for -clock: User specified
// 0in set_cdc_port_domain cfg_tdeisolate -clock clk -module pgcbunit
// Reason for -clock: User specified
// 0in set_cdc_port_domain cfg_tpokup -clock clk -module pgcbunit
// Reason for -clock: User specified
// 0in set_cdc_port_domain cfg_tinaccrstup -clock clk -module pgcbunit
// Reason for -clock: User specified
// 0in set_cdc_port_domain cfg_taccrstup -clock clk -module pgcbunit
// Reason for -clock: User specified
// 0in set_cdc_port_domain cfg_tlatchen -clock clk -module pgcbunit
// Reason for -clock: User specified
// 0in set_cdc_port_domain cfg_tpokdown -clock clk -module pgcbunit
// Reason for -clock: User specified
// 0in set_cdc_port_domain cfg_tlatchdis -clock clk -module pgcbunit
// Reason for -clock: User specified
// 0in set_cdc_port_domain cfg_tsleepact -clock clk -module pgcbunit
// Reason for -clock: User specified
// 0in set_cdc_port_domain cfg_tisolate -clock clk -module pgcbunit
// Reason for -clock: User specified
// 0in set_cdc_port_domain cfg_trstdown -clock clk -module pgcbunit
// Reason for -clock: User specified
// 0in set_cdc_port_domain cfg_trsvd0 -clock clk -module pgcbunit
// Reason for -clock: User specified
// 0in set_cdc_port_domain cfg_trsvd1 -clock clk -module pgcbunit
// Reason for -clock: User specified
// 0in set_cdc_port_domain cfg_trsvd2 -clock clk -module pgcbunit
// Reason for -clock: User specified
// 0in set_cdc_port_domain cfg_trsvd3 -clock clk -module pgcbunit
// Reason for -clock: User specified
// 0in set_cdc_port_domain cfg_trsvd4 -clock clk -module pgcbunit
// Reason for -async: User specified
// 0in set_cdc_port_domain pmc_pgcb_fet_en_b -async -module pgcbunit 
// Reason for -clock: User specified
// 0in set_cdc_port_domain fdfx_pgcb_bypass -clock pgcb_tck -module pgcbunit
// Reason for -clock: User specified
// 0in set_cdc_port_domain fdfx_pgcb_ovr -clock pgcb_tck -module pgcbunit
// Reason for -clock: User specified
// 0in set_cdc_port_domain fscan_ret_ctrl -clock pgcb_tck -module pgcbunit
// Reason for -clock: User specified
// 0in set_cdc_port_domain fscan_mode -clock pgcb_tck -module pgcbunit
// Reason for -clock: Port pgcb_rst_b has multiple fanouts in single clock domain without synchronizers
// 0in set_cdc_port_domain pgcb_rst_b -clock clk -module pgcbunit 
// Reason for -clock: Port fdfx_powergood_rst_b has single fanout in single clock domain
// 0in set_cdc_port_domain fdfx_powergood_rst_b -clock pgcb_tck -module pgcbunit 
// Reason for -clock: Port ip_pgcb_frc_clk_srst_cc_en has multiple fanouts in single clock domain without synchronizers
// 0in set_cdc_port_domain ip_pgcb_frc_clk_srst_cc_en -clock clk -module pgcbunit -combo_logic 
// Reason for -clock: Port ip_pgcb_frc_clk_cp_en has multiple fanouts in single clock domain without synchronizers
// 0in set_cdc_port_domain ip_pgcb_frc_clk_cp_en -clock clk -module pgcbunit -combo_logic 
// Reason for -clock: Port ip_pgcb_force_clks_on_ack has multiple fanouts in single clock domain without synchronizers
// 0in set_cdc_port_domain ip_pgcb_force_clks_on_ack -clock clk -module pgcbunit -combo_logic 
// Reason for -clock: Port ip_pgcb_sleep_en has single fanout in single clock domain
// 0in set_cdc_port_domain ip_pgcb_sleep_en -clock clk -module pgcbunit -combo_logic 
// Reason for -clock: Port cfg_tclksonack_srst has single fanout in single clock domain
// 0in set_cdc_port_domain cfg_tclksonack_srst -clock clk -module pgcbunit -combo_logic 
// Reason for -clock: Port cfg_tclksoffack_srst has single fanout in single clock domain
// 0in set_cdc_port_domain cfg_tclksoffack_srst -clock clk -module pgcbunit -combo_logic 
// Reason for -clock: Port cfg_tclksonack_cp has single fanout in single clock domain
// 0in set_cdc_port_domain cfg_tclksonack_cp -clock clk -module pgcbunit -combo_logic 
// Reason for -clock: Port cfg_trstup2frcclks has single fanout in single clock domain
// 0in set_cdc_port_domain cfg_trstup2frcclks -clock clk -module pgcbunit -combo_logic 


// OUTPUT PORTS

// Reason for -clock: User specified
// 0in set_cdc_port_domain pgcb_pmc_pg_req_b -clock clk -module pgcbunit
// Reason for -clock: User specified
// 0in set_cdc_port_domain pgcb_ip_pg_rdy_ack_b -clock clk -module pgcbunit
// Reason for -clock: User specified
// 0in set_cdc_port_domain pgcb_pok -clock clk -module pgcbunit
// Reason for -clock: User specified
// 0in set_cdc_port_domain pgcb_restore -clock clk -module pgcbunit
// Reason for -clock: User specified
// 0in set_cdc_port_domain pgcb_restore_force_reg_rw -clock clk -module pgcbunit
// Reason for -clock: User specified
// 0in set_cdc_port_domain pgcb_sleep -clock clk -module pgcbunit
// Reason for -clock: User specified
// 0in set_cdc_port_domain pgcb_sleep2 -clock clk -module pgcbunit
// Reason for -clock: User specified
// 0in set_cdc_port_domain pgcb_isol_latchen -clock clk -module pgcbunit
// Reason for -clock: User specified
// 0in set_cdc_port_domain pgcb_isol_en_b -clock clk -module pgcbunit
// Reason for -clock: User specified
// 0in set_cdc_port_domain pgcb_force_rst_b -clock clk -module pgcbunit
// Reason for -clock: User specified
// 0in set_cdc_port_domain pgcb_idle -clock clk -module pgcbunit
// Reason for -clock: User specified
// 0in set_cdc_port_domain pgcb_pwrgate_active -clock clk -module pgcbunit
// 0in set_cdc_port_domain pgcb_ip_force_clks_on -clock clk -module pgcbunit 
// Reason for -async: User specified
// 0in set_cdc_port_domain pgcb_ip_fet_en_b -async -module pgcbunit 
// 0in set_constant pgcb_visa[23:15] -module pgcbunit 9'b0
// 0in set_cdc_port_domain pgcb_visa[14:12] -clock pgcb_tck -module pgcbunit 
// 0in set_cdc_port_domain pgcb_visa[11:10] -clock clk -module pgcbunit 
// 0in set_cdc_port_domain pgcb_visa[9:8] -clock clk -module pgcbunit 
// 0in set_cdc_port_domain pgcb_visa[7] -clock clk -module pgcbunit 
// 0in set_cdc_port_domain pgcb_visa[6] -clock clk -module pgcbunit 
// 0in set_cdc_port_domain pgcb_visa[5]  -combo_path  ip_pgcb_pg_rdy_req_b -module pgcbunit 
// 0in set_cdc_port_domain pgcb_visa[4:0] -clock clk -module pgcbunit 
endmodule
