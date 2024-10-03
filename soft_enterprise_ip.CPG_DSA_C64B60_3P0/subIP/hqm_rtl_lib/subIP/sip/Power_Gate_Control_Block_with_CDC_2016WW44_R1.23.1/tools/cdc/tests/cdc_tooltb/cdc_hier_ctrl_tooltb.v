
//- Questa CDC Version 10.3c_2 linux_x86_64 23 Sep 2014

//-----------------------------------------------------------------
// CDC Hierarchical Control File
// Created Sat Dec 26 14:18:47 2015
//-----------------------------------------------------------------

module tooltb_ctrl; // Hierarchical CDC warning: Do not change the module name

// INPUT PORTS

// 0in set_cdc_clock pgcb_clk -group PGCB_CLK -module tooltb
// 0in set_cdc_clock clock -group CDC_CLK -module tooltb
// 0in set_cdc_clock prescc_clock -group CDC_CLK -module tooltb
// 0in set_cdc_clock pgcb_tck -group PGCB_TCK -module tooltb
// Reason for -async: User specified
// 0in set_cdc_port_domain gclock_req_async -async -module tooltb 
// Reason for -async: User specified
// 0in set_cdc_port_domain cfg_clkgate_disabled -async -module tooltb 
// Reason for -async: User specified
// 0in set_cdc_port_domain cfg_clkreq_ctl_disabled -async -module tooltb 
// Reason for -async: User specified
// 0in set_cdc_port_domain cfg_clkgate_holdoff -async -module tooltb 
// Reason for -async: User specified
// 0in set_cdc_port_domain cfg_pwrgate_holdoff -async -module tooltb 
// Reason for -async: User specified
// 0in set_cdc_port_domain cfg_clkreq_off_holdoff -async -module tooltb 
// Reason for -async: User specified
// 0in set_cdc_port_domain cfg_clkreq_syncoff_holdoff -async -module tooltb 
// Reason for -async: User specified
// 0in set_cdc_port_domain pmc_ip_wake -async -module tooltb 
// Reason for -async: User specified
// 0in set_cdc_port_domain pwrgate_disabled -async -module tooltb 
// Reason for -async: User specified
// 0in set_cdc_port_domain pmc_pgcb_pg_ack_b -async -module tooltb 
// Reason for -async: User specified
// 0in set_cdc_port_domain pmc_pgcb_restore_b -async -module tooltb 
// Reason for -async: User specified
// 0in set_cdc_port_domain pmc_pgcb_fet_en_b -async -module tooltb 
// Reason for -async: User specified
// 0in set_cdc_port_domain pgcb_clkack -async -module tooltb 
// Reason for -clock: User specified
// 0in set_cdc_port_domain gclock_req_sync -clock clock -module tooltb
// Reason for -clock: User specified
// 0in set_cdc_port_domain ism_fabric -clock clock -module tooltb
// Reason for -clock: User specified
// 0in set_cdc_port_domain ism_agent -clock clock -module tooltb
// Reason for -async: User specified
// 0in set_cdc_port_domain clkack -async -module tooltb 
// Reason for -clock: User specified
// 0in set_cdc_port_domain pwrgate_force -clock pgcb_clk -module tooltb
// Reason for -clock: User specified
// 0in set_cdc_port_domain ip_pgcb_pg_type -clock pgcb_clk -module tooltb
// Reason for -clock: User specified
// 0in set_cdc_port_domain ip_pgcb_all_pg_rst_up -clock pgcb_clk -module tooltb
// Reason for -clock: User specified
// 0in set_cdc_port_domain ip_pgcb_frc_clk_srst_cc_en -clock pgcb_clk -module tooltb
// Reason for -clock: User specified
// 0in set_cdc_port_domain ip_pgcb_frc_clk_cp_en -clock pgcb_clk -module tooltb
// Reason for -clock: User specified
// 0in set_cdc_port_domain ip_pgcb_force_clks_on_ack -clock pgcb_clk -module tooltb
// Reason for -clock: User specified
// 0in set_cdc_port_domain ip_pgcb_sleep_en -clock pgcb_clk -module tooltb
// Reason for -clock: User specified
// 0in set_cdc_port_domain cfg_acc_clkgate_disabled -clock pgcb_clk -module tooltb
// Reason for -clock: User specified
// 0in set_cdc_port_domain cfg_t_clkgate -clock pgcb_clk -module tooltb
// Reason for -clock: User specified
// 0in set_cdc_port_domain cfg_t_clkwake -clock pgcb_clk -module tooltb
// 0in set_constant fscan_clkungate -module tooltb 32'b0
// Reason for -async: User specified
// 0in set_cdc_port_domain fismdfx_force_clkreq -async -module tooltb 
// Reason for -async: User specified
// 0in set_cdc_port_domain fismdfx_clkgate_ovrd -async -module tooltb 
// 0in set_constant fscan_byprst_b -module tooltb 32'b0
// 0in set_constant fscan_rstbypen -module tooltb 32'b0
// 0in set_constant fscan_clkgenctrlen -module tooltb 32'b0
// 0in set_constant fscan_clkgenctrl -module tooltb 32'b0
// Reason for -clock: User specified
// 0in set_cdc_port_domain fdfx_pgcb_bypass -clock pgcb_tck -module tooltb
// Reason for -clock: User specified
// 0in set_cdc_port_domain fdfx_pgcb_ovr -clock pgcb_tck -module tooltb
// Reason for -clock: User specified
// 0in set_cdc_port_domain fscan_ret_ctrl -clock pgcb_tck -module tooltb
// Reason for -clock: User specified
// 0in set_cdc_port_domain fscan_mode -clock pgcb_tck -module tooltb
// Reason for -clock: Port pgcb_rst_b has multiple fanouts in single clock domain without synchronizers
// 0in set_cdc_port_domain pgcb_rst_b -clock pgcb_clk -module tooltb 
// Reason for -clock: Port reset_b has multiple fanouts in single clock domain without synchronizers
// 0in set_cdc_port_domain reset_b -clock clock -module tooltb 
// Reason for -clock: Port pok_reset_b has multiple fanouts in single clock domain without synchronizers
// 0in set_cdc_port_domain pok_reset_b -clock clock -module tooltb 
// Reason for -clock: Port fdfx_powergood_rst_b has multiple fanouts in single clock domain without synchronizers
// 0in set_cdc_port_domain fdfx_powergood_rst_b -clock pgcb_tck -module tooltb 


// OUTPUT PORTS

// 0in set_cdc_port_domain reset_sync_b[15] -clock clock -module tooltb -combo_logic 
// 0in set_cdc_port_domain reset_sync_b[14] -clock clock -module tooltb -combo_logic 
// 0in set_cdc_port_domain reset_sync_b[13] -clock clock -module tooltb -combo_logic 
// 0in set_cdc_port_domain reset_sync_b[12] -clock clock -module tooltb -combo_logic 
// 0in set_cdc_port_domain reset_sync_b[11] -clock clock -module tooltb -combo_logic 
// 0in set_cdc_port_domain reset_sync_b[10] -clock clock -module tooltb -combo_logic 
// 0in set_cdc_port_domain reset_sync_b[9] -clock clock -module tooltb -combo_logic 
// 0in set_cdc_port_domain reset_sync_b[8] -clock clock -module tooltb -combo_logic 
// 0in set_cdc_port_domain reset_sync_b[7] -clock clock -module tooltb -combo_logic 
// 0in set_cdc_port_domain reset_sync_b[6] -clock clock -module tooltb -combo_logic 
// 0in set_cdc_port_domain reset_sync_b[5] -clock clock -module tooltb -combo_logic 
// 0in set_cdc_port_domain reset_sync_b[4] -clock clock -module tooltb -combo_logic 
// 0in set_cdc_port_domain reset_sync_b[3] -clock clock -module tooltb -combo_logic 
// 0in set_cdc_port_domain reset_sync_b[2] -clock clock -module tooltb -combo_logic 
// 0in set_cdc_port_domain reset_sync_b[1] -clock clock -module tooltb -combo_logic 
// 0in set_cdc_port_domain reset_sync_b[0] -clock clock -module tooltb -combo_logic 
// Reason for -async: User specified
// 0in set_cdc_port_domain pgcb_ip_fet_en_b -async -module tooltb 
// Reason for -async: User specified
// 0in set_cdc_port_domain pgcb_clkreq -async -module tooltb 
// Reason for -clock: User specified
// 0in set_cdc_port_domain clkreq -clock pgcb_clk -module tooltb
// 0in set_constant pok[1:0] -module tooltb 2'b0
// 0in set_constant pok[3] -module tooltb 1'b0
// 0in set_constant pok[5] -module tooltb 1'b0
// 0in set_constant pok[9:8] -module tooltb 2'b0
// 0in set_constant pok[11] -module tooltb 1'b0
// 0in set_constant pok[13] -module tooltb 1'b0
// Reason for -clock: User specified
// 0in set_cdc_port_domain pok -clock clock -module tooltb
// Reason for -clock: User specified
// 0in set_cdc_port_domain gclock_enable_final -clock clock -module tooltb
// 0in set_cdc_clock gclock[0] -group CDC_CLK -module tooltb
// 0in set_cdc_clock gclock[1] -group CDC_CLK -module tooltb
// 0in set_cdc_clock gclock[2] -group CDC_CLK -module tooltb
// 0in set_cdc_clock gclock[3] -group CDC_CLK -module tooltb
// 0in set_cdc_clock gclock[4] -group CDC_CLK -module tooltb
// 0in set_cdc_clock gclock[5] -group CDC_CLK -module tooltb
// 0in set_cdc_clock gclock[6] -group CDC_CLK -module tooltb
// 0in set_cdc_clock gclock[7] -group CDC_CLK -module tooltb
// 0in set_cdc_clock gclock[8] -group CDC_CLK -module tooltb
// 0in set_cdc_clock gclock[9] -group CDC_CLK -module tooltb
// 0in set_cdc_clock gclock[10] -group CDC_CLK -module tooltb
// 0in set_cdc_clock gclock[11] -group CDC_CLK -module tooltb
// 0in set_cdc_clock gclock[12] -group CDC_CLK -module tooltb
// 0in set_cdc_clock gclock[13] -group CDC_CLK -module tooltb
// 0in set_cdc_clock gclock[14] -group CDC_CLK -module tooltb
// 0in set_cdc_clock gclock[15] -group CDC_CLK -module tooltb
// Reason for -clock: User specified
// 0in set_cdc_port_domain greset_b -clock clock -module tooltb
// Reason for -clock: User specified
// 0in set_cdc_port_domain gclock_active -clock clock -module tooltb
// Reason for -clock: User specified
// 0in set_cdc_port_domain ism_locked -clock clock -module tooltb
// Reason for -clock: User specified
// 0in set_cdc_port_domain boundary_locked -clock clock -module tooltb
// Reason for -clock: User specified
// 0in set_cdc_port_domain gclock_ack_async -clock clock -module tooltb
// Reason for -clock: User specified
// 0in set_cdc_port_domain pgcb_ip_force_clks_on -clock pgcb_clk -module tooltb
// Reason for -clock: User specified
// 0in set_cdc_port_domain pgcb_pmc_pg_req_b -clock pgcb_clk -module tooltb
// Reason for -clock: User specified
// 0in set_cdc_port_domain pgcb_ip_pg_rdy_ack_b -clock pgcb_clk -module tooltb
// Reason for -clock: User specified
// 0in set_cdc_port_domain pgcb_restore_force_reg_rw -clock pgcb_clk -module tooltb
// Reason for -clock: User specified
// 0in set_cdc_port_domain pgcb_sleep -clock pgcb_clk -module tooltb
// Reason for -clock: User specified
// 0in set_cdc_port_domain pgcb_sleep2 -clock pgcb_clk -module tooltb
// Reason for -clock: User specified
// 0in set_cdc_port_domain pgcb_isol_latchen -clock pgcb_clk -module tooltb
// Reason for -clock: User specified
// 0in set_cdc_port_domain pgcb_isol_en_b -clock pgcb_clk -module tooltb
// 0in set_constant cdc_visa[0][13] -module tooltb 1'b0
// 0in set_constant cdc_visa[0][17] -module tooltb 1'b0
// 0in set_constant cdc_visa[0][23:20] -module tooltb 4'b0
// 0in set_constant cdc_visa[1][13] -module tooltb 1'b0
// 0in set_constant cdc_visa[1][17] -module tooltb 1'b0
// 0in set_constant cdc_visa[1][23:20] -module tooltb 4'b0
// 0in set_constant cdc_visa[2][13] -module tooltb 1'b0
// 0in set_constant cdc_visa[2][23:20] -module tooltb 4'b0
// 0in set_constant cdc_visa[3][13] -module tooltb 1'b0
// 0in set_constant cdc_visa[3][17] -module tooltb 1'b0
// 0in set_constant cdc_visa[3][23:20] -module tooltb 4'b0
// 0in set_constant cdc_visa[4][13] -module tooltb 1'b0
// 0in set_constant cdc_visa[4][23:20] -module tooltb 4'b0
// 0in set_constant cdc_visa[5][13] -module tooltb 1'b0
// 0in set_constant cdc_visa[5][17] -module tooltb 1'b0
// 0in set_constant cdc_visa[5][23:20] -module tooltb 4'b0
// 0in set_constant cdc_visa[6][13] -module tooltb 1'b0
// 0in set_constant cdc_visa[6][23:20] -module tooltb 4'b0
// 0in set_constant cdc_visa[7][13] -module tooltb 1'b0
// 0in set_constant cdc_visa[7][23:20] -module tooltb 4'b0
// 0in set_constant cdc_visa[8][13] -module tooltb 1'b0
// 0in set_constant cdc_visa[8][17] -module tooltb 1'b0
// 0in set_constant cdc_visa[8][23:20] -module tooltb 4'b0
// 0in set_constant cdc_visa[9][13] -module tooltb 1'b0
// 0in set_constant cdc_visa[9][17] -module tooltb 1'b0
// 0in set_constant cdc_visa[9][23:20] -module tooltb 4'b0
// 0in set_constant cdc_visa[10][13] -module tooltb 1'b0
// 0in set_constant cdc_visa[10][23:20] -module tooltb 4'b0
// 0in set_constant cdc_visa[11][13] -module tooltb 1'b0
// 0in set_constant cdc_visa[11][17] -module tooltb 1'b0
// 0in set_constant cdc_visa[11][23:20] -module tooltb 4'b0
// 0in set_constant cdc_visa[12][13] -module tooltb 1'b0
// 0in set_constant cdc_visa[12][23:20] -module tooltb 4'b0
// 0in set_constant cdc_visa[13][13] -module tooltb 1'b0
// 0in set_constant cdc_visa[13][17] -module tooltb 1'b0
// 0in set_constant cdc_visa[13][23:20] -module tooltb 4'b0
// 0in set_constant cdc_visa[14][13] -module tooltb 1'b0
// 0in set_constant cdc_visa[14][23:20] -module tooltb 4'b0
// 0in set_constant cdc_visa[15][13] -module tooltb 1'b0
// 0in set_constant cdc_visa[15][23:20] -module tooltb 4'b0
// 0in set_cdc_port_domain cdc_visa[15][14] -clock pgcb_clk  -combo_path  pwrgate_force -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[15][19] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[15][18] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[15][17] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[15][16] -clock pgcb_clk -module tooltb 
// 0in set_cdc_port_domain cdc_visa[15][15] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[14][14] -clock pgcb_clk  -combo_path  pwrgate_force -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[7][14] -clock pgcb_clk  -combo_path  pwrgate_force -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[15][12] -clock clock -module tooltb 
// 0in set_cdc_port_domain cdc_visa[15][11] -clock clock -module tooltb 
// 0in set_cdc_port_domain cdc_visa[15][10] -clock clock -module tooltb 
// 0in set_cdc_port_domain cdc_visa[15][7] -clock clock  -combo_path  gclock_req_sync  ism_fabric  ism_agent  cfg_clkgate_holdoff  cfg_clkreq_syncoff_holdoff  cfg_pwrgate_holdoff  cfg_clkreq_off_holdoff -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[14][7] -clock clock  -combo_path  gclock_req_sync  ism_fabric  ism_agent  cfg_clkgate_holdoff  cfg_clkreq_syncoff_holdoff  cfg_pwrgate_holdoff  cfg_clkreq_off_holdoff -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[15][8] -clock clock  -combo_path  ism_agent -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[15][9] -clock clock  -combo_path  gclock_req_sync  ism_fabric  ism_agent -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[14][8] -clock clock  -combo_path  ism_agent -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[15][1] -clock clock -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[15][6:3] -clock clock -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[15][0] -clock clock -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[14][9] -clock clock  -combo_path  gclock_req_sync  ism_fabric  ism_agent -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[15][2] -clock clock -module tooltb 
// 0in set_cdc_port_domain cdc_visa[13][14] -clock pgcb_clk  -combo_path  pwrgate_force -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[14][19] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[14][18] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[14][17] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[14][16] -clock pgcb_clk -module tooltb 
// 0in set_cdc_port_domain cdc_visa[14][15] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[14][12] -clock clock -module tooltb 
// 0in set_cdc_port_domain cdc_visa[14][11] -clock clock -module tooltb 
// 0in set_cdc_port_domain cdc_visa[14][10] -clock clock -module tooltb 
// 0in set_cdc_port_domain cdc_visa[13][7] -clock clock  -combo_path  gclock_req_sync  ism_fabric  ism_agent  cfg_clkgate_holdoff  cfg_clkreq_syncoff_holdoff  cfg_pwrgate_holdoff  cfg_clkreq_off_holdoff -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[13][9] -clock clock  -combo_path  gclock_req_sync  ism_fabric  ism_agent -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[13][8] -clock clock  -combo_path  ism_agent -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[14][1] -clock clock -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[14][6:3] -clock clock -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[14][0] -clock clock -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[14][2] -clock clock -module tooltb 
// 0in set_cdc_port_domain cdc_visa[12][14] -clock pgcb_clk  -combo_path  pwrgate_force -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[13][19] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[13][18] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[13][16] -clock pgcb_clk -module tooltb 
// 0in set_cdc_port_domain cdc_visa[13][15] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[13][12] -clock clock -module tooltb 
// 0in set_cdc_port_domain cdc_visa[13][11] -clock clock -module tooltb 
// 0in set_cdc_port_domain cdc_visa[13][10] -clock clock -module tooltb 
// 0in set_cdc_port_domain cdc_visa[12][7] -clock clock  -combo_path  gclock_req_sync  ism_fabric  ism_agent  cfg_clkgate_holdoff  cfg_clkreq_syncoff_holdoff  cfg_pwrgate_holdoff  cfg_clkreq_off_holdoff -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[12][9] -clock clock  -combo_path  gclock_req_sync  ism_fabric  ism_agent -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[12][8] -clock clock  -combo_path  ism_agent -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[13][1] -clock clock -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[13][6:3] -clock clock -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[13][0] -clock clock -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[13][2] -clock clock -module tooltb 
// 0in set_cdc_port_domain cdc_visa[11][14] -clock pgcb_clk  -combo_path  pwrgate_force -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[12][19] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[12][18] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[12][17] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[12][16] -clock pgcb_clk -module tooltb 
// 0in set_cdc_port_domain cdc_visa[12][15] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[12][12] -clock clock -module tooltb 
// 0in set_cdc_port_domain cdc_visa[12][11] -clock clock -module tooltb 
// 0in set_cdc_port_domain cdc_visa[12][10] -clock clock -module tooltb 
// 0in set_cdc_port_domain cdc_visa[11][7] -clock clock  -combo_path  gclock_req_sync  ism_fabric  ism_agent  cfg_clkgate_holdoff  cfg_clkreq_syncoff_holdoff  cfg_pwrgate_holdoff  cfg_clkreq_off_holdoff -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[11][9] -clock clock  -combo_path  gclock_req_sync  ism_fabric  ism_agent -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[11][8] -clock clock  -combo_path  ism_agent -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[12][1] -clock clock -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[12][6:3] -clock clock -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[12][0] -clock clock -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[12][2] -clock clock -module tooltb 
// 0in set_cdc_port_domain cdc_visa[10][14] -clock pgcb_clk  -combo_path  pwrgate_force -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[11][19] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[11][18] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[11][16] -clock pgcb_clk -module tooltb 
// 0in set_cdc_port_domain cdc_visa[11][15] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[11][12] -clock clock -module tooltb 
// 0in set_cdc_port_domain cdc_visa[11][11] -clock clock -module tooltb 
// 0in set_cdc_port_domain cdc_visa[11][10] -clock clock -module tooltb 
// 0in set_cdc_port_domain cdc_visa[10][7] -clock clock  -combo_path  gclock_req_sync  ism_fabric  ism_agent  cfg_clkgate_holdoff  cfg_clkreq_syncoff_holdoff  cfg_pwrgate_holdoff  cfg_clkreq_off_holdoff -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[10][9] -clock clock  -combo_path  gclock_req_sync  ism_fabric  ism_agent -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[10][8] -clock clock  -combo_path  ism_agent -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[11][1] -clock clock -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[11][6:3] -clock clock -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[11][0] -clock clock -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[11][2] -clock clock -module tooltb 
// 0in set_cdc_port_domain cdc_visa[9][14] -clock pgcb_clk  -combo_path  pwrgate_force -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[10][19] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[10][18] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[10][17] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[10][16] -clock pgcb_clk -module tooltb 
// 0in set_cdc_port_domain cdc_visa[10][15] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[10][12] -clock clock -module tooltb 
// 0in set_cdc_port_domain cdc_visa[10][11] -clock clock -module tooltb 
// 0in set_cdc_port_domain cdc_visa[10][10] -clock clock -module tooltb 
// 0in set_cdc_port_domain cdc_visa[9][7] -clock clock  -combo_path  gclock_req_sync  ism_fabric  ism_agent  cfg_clkgate_holdoff  cfg_clkreq_syncoff_holdoff  cfg_pwrgate_holdoff  cfg_clkreq_off_holdoff -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[9][9] -clock clock  -combo_path  gclock_req_sync  ism_fabric  ism_agent -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[9][8] -clock clock  -combo_path  ism_agent -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[10][1] -clock clock -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[10][6:3] -clock clock -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[10][0] -clock clock -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[10][2] -clock clock -module tooltb 
// 0in set_cdc_port_domain cdc_visa[8][14] -clock pgcb_clk  -combo_path  pwrgate_force -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[9][19] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[9][18] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[9][16] -clock pgcb_clk -module tooltb 
// 0in set_cdc_port_domain cdc_visa[9][15] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[9][12] -clock clock -module tooltb 
// 0in set_cdc_port_domain cdc_visa[9][11] -clock clock -module tooltb 
// 0in set_cdc_port_domain cdc_visa[9][10] -clock clock -module tooltb 
// 0in set_cdc_port_domain cdc_visa[8][7] -clock clock  -combo_path  gclock_req_sync  ism_fabric  ism_agent  cfg_clkgate_holdoff  cfg_clkreq_syncoff_holdoff  cfg_pwrgate_holdoff  cfg_clkreq_off_holdoff -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[8][9] -clock clock  -combo_path  gclock_req_sync  ism_fabric  ism_agent -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[8][8] -clock clock  -combo_path  ism_agent -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[9][1] -clock clock -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[9][6:3] -clock clock -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[9][0] -clock clock -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[9][2] -clock clock -module tooltb 
// 0in set_cdc_port_domain cdc_visa[8][19] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[8][18] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[8][16] -clock pgcb_clk -module tooltb 
// 0in set_cdc_port_domain cdc_visa[8][15] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[8][12] -clock clock -module tooltb 
// 0in set_cdc_port_domain cdc_visa[8][11] -clock clock -module tooltb 
// 0in set_cdc_port_domain cdc_visa[8][10] -clock clock -module tooltb 
// 0in set_cdc_port_domain cdc_visa[7][7] -clock clock  -combo_path  gclock_req_sync  ism_fabric  ism_agent  cfg_clkgate_holdoff  cfg_clkreq_syncoff_holdoff  cfg_pwrgate_holdoff  cfg_clkreq_off_holdoff -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[7][9] -clock clock  -combo_path  gclock_req_sync  ism_fabric  ism_agent -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[7][8] -clock clock  -combo_path  ism_agent -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[8][1] -clock clock -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[8][6:3] -clock clock -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[8][0] -clock clock -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[8][2] -clock clock -module tooltb 
// 0in set_cdc_port_domain cdc_visa[6][14] -clock pgcb_clk  -combo_path  pwrgate_force -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[7][19] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[7][18] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[7][17] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[7][16] -clock pgcb_clk -module tooltb 
// 0in set_cdc_port_domain cdc_visa[7][15] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[7][12] -clock clock -module tooltb 
// 0in set_cdc_port_domain cdc_visa[7][11] -clock clock -module tooltb 
// 0in set_cdc_port_domain cdc_visa[7][10] -clock clock -module tooltb 
// 0in set_cdc_port_domain cdc_visa[6][7] -clock clock  -combo_path  gclock_req_sync  ism_fabric  ism_agent  cfg_clkgate_holdoff  cfg_clkreq_syncoff_holdoff  cfg_pwrgate_holdoff  cfg_clkreq_off_holdoff -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[6][9] -clock clock  -combo_path  gclock_req_sync  ism_fabric  ism_agent -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[6][8] -clock clock  -combo_path  ism_agent -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[7][1] -clock clock -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[7][6:3] -clock clock -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[7][0] -clock clock -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[7][2] -clock clock -module tooltb 
// 0in set_cdc_port_domain cdc_visa[5][14] -clock pgcb_clk  -combo_path  pwrgate_force -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[6][19] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[6][18] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[6][17] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[6][16] -clock pgcb_clk -module tooltb 
// 0in set_cdc_port_domain cdc_visa[6][15] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[6][12] -clock clock -module tooltb 
// 0in set_cdc_port_domain cdc_visa[6][11] -clock clock -module tooltb 
// 0in set_cdc_port_domain cdc_visa[6][10] -clock clock -module tooltb 
// 0in set_cdc_port_domain cdc_visa[5][7] -clock clock  -combo_path  gclock_req_sync  ism_fabric  ism_agent  cfg_clkgate_holdoff  cfg_clkreq_syncoff_holdoff  cfg_pwrgate_holdoff  cfg_clkreq_off_holdoff -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[5][9] -clock clock  -combo_path  gclock_req_sync  ism_fabric  ism_agent -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[5][8] -clock clock  -combo_path  ism_agent -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[6][1] -clock clock -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[6][6:3] -clock clock -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[6][0] -clock clock -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[6][2] -clock clock -module tooltb 
// 0in set_cdc_port_domain cdc_visa[4][14] -clock pgcb_clk  -combo_path  pwrgate_force -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[5][19] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[5][18] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[5][16] -clock pgcb_clk -module tooltb 
// 0in set_cdc_port_domain cdc_visa[5][15] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[5][12] -clock clock -module tooltb 
// 0in set_cdc_port_domain cdc_visa[5][11] -clock clock -module tooltb 
// 0in set_cdc_port_domain cdc_visa[5][10] -clock clock -module tooltb 
// 0in set_cdc_port_domain cdc_visa[4][7] -clock clock  -combo_path  gclock_req_sync  ism_fabric  ism_agent  cfg_clkgate_holdoff  cfg_clkreq_syncoff_holdoff  cfg_pwrgate_holdoff  cfg_clkreq_off_holdoff -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[4][9] -clock clock  -combo_path  gclock_req_sync  ism_fabric  ism_agent -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[4][8] -clock clock  -combo_path  ism_agent -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[5][1] -clock clock -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[5][6:3] -clock clock -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[5][0] -clock clock -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[5][2] -clock clock -module tooltb 
// 0in set_cdc_port_domain cdc_visa[3][14] -clock pgcb_clk  -combo_path  pwrgate_force -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[4][19] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[4][18] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[4][17] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[4][16] -clock pgcb_clk -module tooltb 
// 0in set_cdc_port_domain cdc_visa[4][15] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[4][12] -clock clock -module tooltb 
// 0in set_cdc_port_domain cdc_visa[4][11] -clock clock -module tooltb 
// 0in set_cdc_port_domain cdc_visa[4][10] -clock clock -module tooltb 
// 0in set_cdc_port_domain cdc_visa[3][7] -clock clock  -combo_path  gclock_req_sync  ism_fabric  ism_agent  cfg_clkgate_holdoff  cfg_clkreq_syncoff_holdoff  cfg_pwrgate_holdoff  cfg_clkreq_off_holdoff -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[3][9] -clock clock  -combo_path  gclock_req_sync  ism_fabric  ism_agent -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[3][8] -clock clock  -combo_path  ism_agent -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[4][1] -clock clock -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[4][6:3] -clock clock -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[4][0] -clock clock -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[4][2] -clock clock -module tooltb 
// 0in set_cdc_port_domain cdc_visa[2][14] -clock pgcb_clk  -combo_path  pwrgate_force -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[3][19] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[3][18] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[3][16] -clock pgcb_clk -module tooltb 
// 0in set_cdc_port_domain cdc_visa[3][15] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[3][12] -clock clock -module tooltb 
// 0in set_cdc_port_domain cdc_visa[3][11] -clock clock -module tooltb 
// 0in set_cdc_port_domain cdc_visa[3][10] -clock clock -module tooltb 
// 0in set_cdc_port_domain cdc_visa[2][7] -clock clock  -combo_path  gclock_req_sync  ism_fabric  ism_agent  cfg_clkgate_holdoff  cfg_clkreq_syncoff_holdoff  cfg_pwrgate_holdoff  cfg_clkreq_off_holdoff -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[2][9] -clock clock  -combo_path  gclock_req_sync  ism_fabric  ism_agent -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[2][8] -clock clock  -combo_path  ism_agent -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[3][1] -clock clock -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[3][6:3] -clock clock -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[3][0] -clock clock -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[3][2] -clock clock -module tooltb 
// 0in set_cdc_port_domain cdc_visa[1][14] -clock pgcb_clk  -combo_path  pwrgate_force -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[2][19] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[2][18] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[2][17] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[2][16] -clock pgcb_clk -module tooltb 
// 0in set_cdc_port_domain cdc_visa[2][15] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[2][12] -clock clock -module tooltb 
// 0in set_cdc_port_domain cdc_visa[2][11] -clock clock -module tooltb 
// 0in set_cdc_port_domain cdc_visa[2][10] -clock clock -module tooltb 
// 0in set_cdc_port_domain cdc_visa[1][7] -clock clock  -combo_path  gclock_req_sync  ism_fabric  ism_agent  cfg_clkgate_holdoff  cfg_clkreq_syncoff_holdoff  cfg_pwrgate_holdoff  cfg_clkreq_off_holdoff -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[1][9] -clock clock  -combo_path  gclock_req_sync  ism_fabric  ism_agent -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[1][8] -clock clock  -combo_path  ism_agent -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[2][1] -clock clock -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[2][6:3] -clock clock -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[2][0] -clock clock -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[2][2] -clock clock -module tooltb 
// 0in set_cdc_port_domain cdc_visa[0][14] -clock pgcb_clk  -combo_path  pwrgate_force -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[1][19] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[1][18] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[1][16] -clock pgcb_clk -module tooltb 
// 0in set_cdc_port_domain cdc_visa[1][15] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[1][12] -clock clock -module tooltb 
// 0in set_cdc_port_domain cdc_visa[1][11] -clock clock -module tooltb 
// 0in set_cdc_port_domain cdc_visa[1][10] -clock clock -module tooltb 
// 0in set_cdc_port_domain cdc_visa[0][7] -clock clock  -combo_path  gclock_req_sync  ism_fabric  ism_agent  cfg_clkgate_holdoff  cfg_clkreq_syncoff_holdoff  cfg_pwrgate_holdoff  cfg_clkreq_off_holdoff -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[0][9] -clock clock  -combo_path  gclock_req_sync  ism_fabric  ism_agent -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[0][8] -clock clock  -combo_path  ism_agent -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[1][1] -clock clock -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[1][6:3] -clock clock -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[1][0] -clock clock -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[1][2] -clock clock -module tooltb 
// 0in set_cdc_port_domain cdc_visa[0][19] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[0][18] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[0][16] -clock pgcb_clk -module tooltb 
// 0in set_cdc_port_domain cdc_visa[0][15] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[0][12] -clock clock -module tooltb 
// 0in set_cdc_port_domain cdc_visa[0][11] -clock clock -module tooltb 
// 0in set_cdc_port_domain cdc_visa[0][10] -clock clock -module tooltb 
// 0in set_cdc_port_domain cdc_visa[0][1] -clock clock -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[0][6:3] -clock clock -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[0][0] -clock clock -module tooltb -combo_logic 
// 0in set_cdc_port_domain cdc_visa[0][2] -clock clock -module tooltb 
// 0in set_constant pgcb_visa[0][23:12] -module tooltb 12'b0
// 0in set_constant pgcb_visa[1][23:15] -module tooltb 9'b0
// 0in set_cdc_port_domain pgcb_visa[1][14:12] -clock pgcb_tck -module tooltb 
// 0in set_cdc_port_domain pgcb_visa[1][11] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain pgcb_visa[1][10] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain pgcb_visa[1][9:8] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain pgcb_visa[1][7] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain pgcb_visa[1][6] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain pgcb_visa[1][5] -clock pgcb_clk  -combo_path  pwrgate_force -module tooltb -combo_logic 
// 0in set_cdc_port_domain pgcb_visa[0][5] -clock pgcb_clk  -combo_path  pwrgate_force -module tooltb -combo_logic 
// 0in set_cdc_port_domain pgcb_visa[1][4:0] -clock pgcb_clk -module tooltb 
// 0in set_cdc_port_domain pgcb_visa[0][11:10] -clock pgcb_clk -module tooltb 
// 0in set_cdc_port_domain pgcb_visa[0][9:8] -clock pgcb_clk -module tooltb 
// 0in set_cdc_port_domain pgcb_visa[0][7] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain pgcb_visa[0][6] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain pgcb_visa[0][4:0] -clock pgcb_clk -module tooltb 
// 0in set_constant pgcbcg_visa[0][14] -module tooltb 1'b0
// 0in set_cdc_port_domain pgcbcg_visa[1][9] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain pgcbcg_visa[1][31] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain pgcbcg_visa[1][8] -clock pgcb_clk  -combo_path  cfg_acc_clkgate_disabled -module tooltb -combo_logic 
// 0in set_cdc_port_domain pgcbcg_visa[1][29] -clock pgcb_clk  -combo_path  cfg_acc_clkgate_disabled -module tooltb -combo_logic 
// 0in set_cdc_port_domain pgcbcg_visa[1][19] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain pgcbcg_visa[1][18] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain pgcbcg_visa[1][24] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain pgcbcg_visa[1][23] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain pgcbcg_visa[1][30] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain pgcbcg_visa[1][28] -clock pgcb_clk  -combo_path  cfg_acc_clkgate_disabled -module tooltb -combo_logic 
// 0in set_cdc_port_domain pgcbcg_visa[1][17] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain pgcbcg_visa[1][20] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain pgcbcg_visa[1][25] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain pgcbcg_visa[1][27] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain pgcbcg_visa[0][8] -clock pgcb_clk  -combo_path  cfg_acc_clkgate_disabled -module tooltb -combo_logic 
// 0in set_cdc_port_domain pgcbcg_visa[0][29] -clock pgcb_clk  -combo_path  cfg_acc_clkgate_disabled -module tooltb -combo_logic 
// 0in set_cdc_port_domain pgcbcg_visa[1][16] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain pgcbcg_visa[1][26] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain pgcbcg_visa[1][22] -clock clock -module tooltb -combo_logic 
// 0in set_cdc_port_domain pgcbcg_visa[0][21]  -combo_path  clkack -module tooltb 
// 0in set_cdc_port_domain pgcbcg_visa[1][21]  -combo_path  clkack -module tooltb 
// 0in set_cdc_port_domain pgcbcg_visa[1][7] -clock pgcb_clk  -combo_path  pmc_ip_wake -module tooltb -combo_logic 
// 0in set_cdc_port_domain pgcbcg_visa[1][12] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain pgcbcg_visa[1][13] -clock pgcb_clk  -combo_path  pmc_ip_wake -module tooltb -combo_logic 
// 0in set_cdc_port_domain pgcbcg_visa[1][14] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain pgcbcg_visa[0][7] -clock pgcb_clk  -combo_path  pmc_ip_wake -module tooltb -combo_logic 
// 0in set_cdc_port_domain pgcbcg_visa[1][15] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain pgcbcg_visa[1][11] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain pgcbcg_visa[1][10] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain pgcbcg_visa[1][6:3] -clock pgcb_clk -module tooltb 
// 0in set_cdc_port_domain pgcbcg_visa[1][2:0] -clock pgcb_clk -module tooltb 
// 0in set_cdc_port_domain pgcbcg_visa[0][9] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain pgcbcg_visa[0][31] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain pgcbcg_visa[0][24] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain pgcbcg_visa[0][19] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain pgcbcg_visa[0][18] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain pgcbcg_visa[0][23] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain pgcbcg_visa[0][28] -clock pgcb_clk  -combo_path  cfg_acc_clkgate_disabled -module tooltb -combo_logic 
// 0in set_cdc_port_domain pgcbcg_visa[0][30] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain pgcbcg_visa[0][20] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain pgcbcg_visa[0][25] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain pgcbcg_visa[0][27] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain pgcbcg_visa[0][16] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain pgcbcg_visa[0][26] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain pgcbcg_visa[0][22] -clock clock -module tooltb -combo_logic 
// 0in set_cdc_port_domain pgcbcg_visa[0][13] -clock pgcb_clk  -combo_path  pmc_ip_wake -module tooltb -combo_logic 
// 0in set_cdc_port_domain pgcbcg_visa[0][12] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain pgcbcg_visa[0][15] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain pgcbcg_visa[0][11] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain pgcbcg_visa[0][10] -clock pgcb_clk -module tooltb -combo_logic 
// 0in set_cdc_port_domain pgcbcg_visa[0][6:3] -clock pgcb_clk -module tooltb 
// 0in set_cdc_port_domain pgcbcg_visa[0][2:0] -clock pgcb_clk -module tooltb 
endmodule
