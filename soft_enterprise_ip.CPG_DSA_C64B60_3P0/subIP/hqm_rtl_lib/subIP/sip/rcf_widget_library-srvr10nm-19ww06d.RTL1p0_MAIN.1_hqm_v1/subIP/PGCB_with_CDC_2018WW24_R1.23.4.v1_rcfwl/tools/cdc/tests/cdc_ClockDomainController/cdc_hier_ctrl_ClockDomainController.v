
//- Questa CDC Version 10.3c_2 linux_x86_64 23 Sep 2014

//-----------------------------------------------------------------
// CDC Hierarchical Control File
// Created Mon Oct 17 21:20:23 2016
//-----------------------------------------------------------------

module ClockDomainController_ctrl; // Hierarchical CDC warning: Do not change the module name

// INPUT PORTS

// 0in set_cdc_clock pgcb_clk -group PGCB_CLK -module ClockDomainController
// 0in set_cdc_clock clock -group CDC_CLK -module ClockDomainController
// 0in set_cdc_clock prescc_clock -group PRESCC_CDC_CLK -module ClockDomainController
// Reason for -async: User specified
// 0in set_cdc_port_domain clkack -async -module ClockDomainController 
// Reason for -clock: User specified
// 0in set_cdc_port_domain gclock_req_sync -clock clock -module ClockDomainController
// Reason for -async: User specified
// 0in set_cdc_port_domain gclock_req_async -async -module ClockDomainController 
// Reason for -clock: User specified
// 0in set_cdc_port_domain ism_fabric -clock clock -module ClockDomainController
// Reason for -clock: User specified
// 0in set_cdc_port_domain ism_agent -clock clock -module ClockDomainController
// Reason for -async: User specified
// 0in set_cdc_port_domain cfg_clkgate_disabled -async -module ClockDomainController 
// Reason for -async: User specified
// 0in set_cdc_port_domain cfg_clkreq_ctl_disabled -async -module ClockDomainController 
// Reason for -async: User specified
// 0in set_cdc_port_domain cfg_clkgate_holdoff -async -module ClockDomainController 
// Reason for -async: User specified
// 0in set_cdc_port_domain cfg_pwrgate_holdoff -async -module ClockDomainController 
// Reason for -async: User specified
// 0in set_cdc_port_domain cfg_clkreq_off_holdoff -async -module ClockDomainController 
// Reason for -async: User specified
// 0in set_cdc_port_domain cfg_clkreq_syncoff_holdoff -async -module ClockDomainController 
// Reason for -clock: User specified
// 0in set_cdc_port_domain pwrgate_disabled -clock pgcb_clk -module ClockDomainController
// Reason for -clock: User specified
// 0in set_cdc_port_domain pwrgate_force -clock pgcb_clk -module ClockDomainController
// Reason for -clock: User specified
// 0in set_cdc_port_domain pwrgate_pmc_wake -clock pgcb_clk -module ClockDomainController
// Reason for -clock: User specified
// 0in set_cdc_port_domain pgcb_force_rst_b -clock pgcb_clk -module ClockDomainController
// Reason for -clock: User specified
// 0in set_cdc_port_domain pgcb_pok -clock pgcb_clk -module ClockDomainController
// Reason for -clock: User specified
// 0in set_cdc_port_domain pgcb_restore -clock pgcb_clk -module ClockDomainController
// Reason for -clock: User specified
// 0in set_cdc_port_domain pgcb_pwrgate_active -clock pgcb_clk -module ClockDomainController
// 0in set_constant fscan_clkungate -module ClockDomainController 1'b0
// Reason for -async: User specified
// 0in set_cdc_port_domain fismdfx_force_clkreq -async -module ClockDomainController 
// Reason for -async: User specified
// 0in set_cdc_port_domain fismdfx_clkgate_ovrd -async -module ClockDomainController 
// 0in set_constant fscan_byprst_b -module ClockDomainController 32'b0
// 0in set_constant fscan_rstbypen -module ClockDomainController 32'b0
// 0in set_constant fscan_clkgenctrlen -module ClockDomainController 32'b0
// Reason for -async: User specified
// 0in set_cdc_port_domain fscan_clkgenctrl -async -module ClockDomainController 
// Reason for -multiple_clocks: Port pgcb_rst_b has multiple fanouts sampled by conflicting clock domains:
// Clocks: clock
//         pgcb_clk
// 0in set_cdc_port_domain pgcb_rst_b -multiple_clocks -module ClockDomainController 
// Reason for -clock: Port reset_b has single fanout in single clock domain
// 0in set_cdc_port_domain reset_b -clock clock -module ClockDomainController 
// Reason for -clock: Port pok_reset_b has single fanout in single clock domain
// 0in set_cdc_port_domain pok_reset_b -clock clock -module ClockDomainController 


// OUTPUT PORTS

// 0in set_cdc_port_domain reset_sync_b -clock clock -module ClockDomainController 
// Reason for -clock: User specified
// 0in set_cdc_port_domain clkreq -clock pgcb_clk -module ClockDomainController
// Reason for -clock: User specified
// 0in set_cdc_port_domain pok -clock clock -module ClockDomainController
// Reason for -clock: User specified
// 0in set_cdc_port_domain gclock_enable_final -clock clock -module ClockDomainController
// 0in set_cdc_clock gclock -group CDC_CLK -module ClockDomainController
// 0in set_cdc_port_domain greset_b -clock clock  -combo_path  pgcb_force_rst_b -module ClockDomainController -combo_logic 
// Reason for -clock: User specified
// 0in set_cdc_port_domain gclock_ack_async -clock clock -module ClockDomainController
// Reason for -clock: User specified
// 0in set_cdc_port_domain gclock_active -clock clock -module ClockDomainController
// Reason for -clock: User specified
// 0in set_cdc_port_domain ism_locked -clock clock -module ClockDomainController
// Reason for -clock: User specified
// 0in set_cdc_port_domain boundary_locked -clock clock -module ClockDomainController
// Reason for -clock: User specified
// 0in set_cdc_port_domain pwrgate_ready -clock pgcb_clk -module ClockDomainController
// 0in set_constant cdc_visa[13] -module ClockDomainController 1'b0
// 0in set_constant cdc_visa[23:20] -module ClockDomainController 4'b0
// 0in set_cdc_port_domain cdc_visa[14] -clock pgcb_clk  -combo_path  pwrgate_force  pgcb_pok  pwrgate_disabled  pgcb_restore -module ClockDomainController -combo_logic 
// 0in set_cdc_port_domain cdc_visa[19] -clock pgcb_clk -module ClockDomainController -combo_logic 
// 0in set_cdc_port_domain cdc_visa[18] -clock pgcb_clk -module ClockDomainController -combo_logic 
// 0in set_cdc_port_domain cdc_visa[17] -clock pgcb_clk -module ClockDomainController 
// 0in set_cdc_port_domain cdc_visa[16] -clock pgcb_clk -module ClockDomainController 
// 0in set_cdc_port_domain cdc_visa[15] -clock pgcb_clk -module ClockDomainController -combo_logic 
// 0in set_cdc_port_domain cdc_visa[12] -clock clock -module ClockDomainController 
// 0in set_cdc_port_domain cdc_visa[11] -clock clock -module ClockDomainController 
// 0in set_cdc_port_domain cdc_visa[10] -clock clock -module ClockDomainController 
// 0in set_cdc_port_domain cdc_visa[7] -clock clock  -combo_path  gclock_req_sync  ism_fabric  ism_agent  cfg_clkgate_holdoff  cfg_clkreq_syncoff_holdoff  cfg_pwrgate_holdoff  cfg_clkreq_off_holdoff -module ClockDomainController -combo_logic 
// 0in set_cdc_port_domain cdc_visa[8] -clock clock  -combo_path  ism_agent -module ClockDomainController -combo_logic 
// 0in set_cdc_port_domain cdc_visa[9] -clock clock  -combo_path  gclock_req_sync  ism_fabric  ism_agent -module ClockDomainController -combo_logic 
// 0in set_cdc_port_domain cdc_visa[1] -clock clock -module ClockDomainController -combo_logic 
// 0in set_cdc_port_domain cdc_visa[6:3] -clock clock -module ClockDomainController -combo_logic 
// 0in set_cdc_port_domain cdc_visa[0] -clock clock -module ClockDomainController -combo_logic 
// 0in set_cdc_port_domain cdc_visa[2] -clock clock -module ClockDomainController 
endmodule
