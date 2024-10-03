#-----------------------------------------------------------------------
# Intel Proprietary -- Copyright 2012 Intel -- All rights reserved
#-----------------------------------------------------------------------
# Description: Unit CDC waivers file.
#-----------------------------------------------------------------------

#Example:
#cdc report crossing -scheme <scheme_name> -from {<tx_signal>} -to {<rx_signal>} -tx_clock <tx_clock_name> -rx_clock <rx_clock_name> -severity waived

# DFx overrides are asynchronous to the pgcb_clk but will be stable during functional mode
#cdc report crossing -scheme no_sync -tx_clock PGCB_TCK -through *i_pgcbdfxovr1.dfxovr_isol_en_b -severity waived -module pgcbunit
#cdc report crossing -scheme no_sync -tx_clock PGCB_TCK -through *i_pgcbdfxovr1.dfxovr_isol_latchen -severity waived -module pgcbunit
cdc report crossing -scheme no_sync -tx_clock PGCB_TCK -through *i_pgcbdfxovr1.pgcb_isol_en_b -severity waived -module pgcbunit
cdc report crossing -scheme no_sync -tx_clock PGCB_TCK -through *i_pgcbdfxovr1.pgcb_isol_latchen -severity waived -module pgcbunit
cdc report crossing -scheme no_sync -tx_clock PGCB_TCK -through *i_pgcbdfxovr1.dfxovr_force_rst_b -severity waived -module pgcbunit
cdc report crossing -scheme no_sync -tx_clock PGCB_TCK -through *i_pgcbdfxovr1.pgcb_sleep* -severity waived -module pgcbunit

# DFx combi logic on POK is stable in functional mode and will not introduce glitches
cdc report crossing -scheme combo_logic -through *i_pgcbdfxovr1.dfxovr_pok -through pgcb_pok -severity waived -module pgcbunit

# logic on fet_en_b but ctech_mux will be glitch free when switching if both inputs to mux are equal
cdc report crossing -scheme no_sync -through *i_pgcbdfxovr1.dfxovr_fet_en_b -severity waived -module pgcbunit

cdc report crossing -rx_clock PGCB_CLK -through *fdfx_pgcb_bypass          -severity waived -scheme partial_dmux -module pgcbunit

######################
# Reconveregence
######################

cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *pmc_pgcb_restore_b* -to *cnt_val* -severity waived -scheme reconvergence -module pgcbunit
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *pmc_pgcb_pg_ack_b*  -to *cnt_val* -severity waived -scheme reconvergence -module pgcbunit

cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *pmc_pgcb_restore_b* -to *pgcb_force_rst_b -severity waived -scheme reconvergence -module pgcbunit
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *pmc_pgcb_pg_ack_b*  -to *pgcb_force_rst_b -severity waived -scheme reconvergence -module pgcbunit

cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *pmc_pgcb_restore_b* -to *pgcb_idle -severity waived -scheme reconvergence -module pgcbunit
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *pmc_pgcb_pg_ack_b*  -to *pgcb_idle -severity waived -scheme reconvergence -module pgcbunit

#pgcb_ps
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *pmc_pgcb_restore_b* -to *pgcb_ps   -severity waived -scheme reconvergence -module pgcbunit
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *pmc_pgcb_pg_ack_b*  -to *pgcb_ps   -severity waived -scheme reconvergence -module pgcbunit

#int_restore_b
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *pmc_pgcb_restore_b* -to *int_restore_b -severity waived -scheme reconvergence -module pgcbunit
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *pmc_pgcb_pg_ack_b*  -to *int_restore_b -severity waived -scheme reconvergence -module pgcbunit

#pgcb_restore
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *pmc_pgcb_restore_b* -to *pgcb_restore -severity waived -scheme reconvergence -module pgcbunit
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *pmc_pgcb_pg_ack_b*  -to *pgcb_restore -severity waived -scheme reconvergence -module pgcbunit

#pgcb_ip_force_clks_on
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *pmc_pgcb_restore_b* -to *pgcb_ip_force_clks_on -severity waived -scheme reconvergence -module pgcbunit
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *pmc_pgcb_pg_ack_b*  -to *pgcb_ip_force_clks_on -severity waived -scheme reconvergence -module pgcbunit

#pgcb_ip_pg_rdy_ack_b
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *pmc_pgcb_restore_b* -to *pgcb_ip_pg_rdy_ack_b -severity waived -scheme reconvergence -module pgcbunit
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *pmc_pgcb_pg_ack_b*  -to *pgcb_ip_pg_rdy_ack_b -severity waived -scheme reconvergence -module pgcbunit

#pgcb_isol_en_b
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *pmc_pgcb_restore_b* -to *pgcb_isol_en_b -severity waived -scheme reconvergence -module pgcbunit
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *pmc_pgcb_pg_ack_b*  -to *pgcb_isol_en_b -severity waived -scheme reconvergence -module pgcbunit

#pgcb_isol_latchen
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *pmc_pgcb_restore_b* -to *pgcb_isol_latchen -severity waived -scheme reconvergence -module pgcbunit
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *pmc_pgcb_pg_ack_b*  -to *pgcb_isol_latchen -severity waived -scheme reconvergence -module pgcbunit

#pgcb_pmc_pg_req_b
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *pmc_pgcb_restore_b* -to *pgcb_pmc_pg_req_b -severity waived -scheme reconvergence -module pgcbunit
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *pmc_pgcb_pg_ack_b*  -to *pgcb_pmc_pg_req_b -severity waived -scheme reconvergence -module pgcbunit

#pgcb_pok
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *pmc_pgcb_restore_b* -to *pgcb_pok -severity waived -scheme reconvergence -module pgcbunit
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *pmc_pgcb_pg_ack_b*  -to *pgcb_pok -severity waived -scheme reconvergence -module pgcbunit


#pgcb_sleep*
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *pmc_pgcb_restore_b* -to *pgcb_sleep* -severity waived -scheme reconvergence -module pgcbunit
cdc report crossing -tx_clock PGCB_CLK -rx_clock PGCB_CLK -from *pmc_pgcb_pg_ack_b*  -to *pgcb_sleep* -severity waived -scheme reconvergence -module pgcbunit
