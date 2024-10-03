/**********************************************************************************************************************\
|*                                                                                                                    *|
|*  Copyright (c) 2012 by Intel Corporation.  All rights reserved.                                                    *|
|*                                                                                                                    *|
|*  This material constitutes the confidential and proprietary information of Intel Corp and is not to be disclosed,  *|
|*  reproduced, copied, or used in any manner not permitted under license from Intel Corp.                            *|
|*                                                                                                                    *|
\**********************************************************************************************************************/

/**********************************************************************************************************************\
 * Rtb_pkg
 * @author Jeff Wilcox
 * 
 * 
\**********************************************************************************************************************/
`timescale 1ns/1ns

package Rtb_pkg;

    parameter AREQ = 5;
    parameter ITBITS = 16;
    

    typedef struct packed {
        logic                        clock;
        logic                        reset_b;
        logic                        clkack;
        logic                        gclock_req_sync;
        logic[AREQ-1:0]              gclock_req_async;
        logic[2:0]                   ism_fabric;
        logic[2:0]                   ism_agent;
        logic                        force_clks_on_ack;
        logic                        all_pg_rst_up;
    } CdcCtlIn_t;
    
    typedef struct packed {
        logic                        reset_sync_b;
        logic                        clkreq;
        logic                        pok;
        logic                        gclock;
        logic                        greset_b;
        logic[AREQ-1:0]              gclock_ack_async;
        logic                        gclock_active;
        logic                        ism_locked;
        logic                        boundary_locked;
        logic                        pgcb_sleep;
        logic                        force_clks_on;
        logic                        frc_clk_srst_en;
        logic                        frc_clk_cp_en;
    } CdcCtlOut_t;
    
    typedef struct packed {
        logic                        cfg_clkgate_disabled;       //Don't allow idle-based clock gating
        logic                        cfg_clkreq_ctl_disabled;    //Don't allow de-assertion of clkreq when idle
	//Added
	logic 	                     pwrgate_disabled;
        logic [3:0]                  cfg_clkgate_holdoff;        //Min time from idle to clock gating; 2^value in clocks
        logic [3:0]                  cfg_pwrgate_holdoff;        //Min time from clock gate to power gate ready; 2^value in clocks
        logic [3:0]                  cfg_clkreq_off_holdoff;     //Min time from locking to !clkreq; 2^value in clocks
        logic [3:0]                  cfg_clkreq_syncoff_holdoff; //Min time from ck gate to !clkreq (powerGateDisabled)
    } CdcCfg_t;
    
    typedef struct packed {
        logic [1:0]                  cfg_tsleepinactiv;
        logic [1:0]                  cfg_tdeisolate;
        logic [1:0]                  cfg_tpokup;
        logic [1:0]                  cfg_tinaccrstup;
        logic [1:0]                  cfg_taccrstup;
        logic [1:0]                  cfg_tlatchen;
        logic [1:0]                  cfg_tpokdown;
        logic [1:0]                  cfg_tlatchdis;
        logic [1:0]                  cfg_tsleepact;
        logic [1:0]                  cfg_tisolate;
        logic [1:0]                  cfg_trstdown;
        logic [1:0]                  cfg_tclksonack_srst;
        logic [1:0]                  cfg_tclksoffack_srst;
        logic [1:0]                  cfg_tclksonack_cp;
        logic [1:0]                  cfg_trstup2frcclks;
        logic [1:0]                  cfg_trsvd0;
        logic [1:0]                  cfg_trsvd1;
        logic                        ip_pgcb_frc_clk_srst_en;
        logic                        ip_pgcb_frc_clk_cp_en;
    } PgcbCfg_t;
    
    typedef struct packed {
        logic                        pgcb_pmc_pg_req_b;
        logic                        pgcb_idle;
        logic                        pgcb_pwrgate_active;
        logic                        all_isms_unlocked;
        logic                        all_poks_deasserted;
        logic                        pgcb_restore;
    } PgdCtlOut_t;
    
    typedef struct packed {
        logic                        pmc_ip_pg_ack_b;
        logic                        pmc_ip_restore_b;
        logic                        pmc_ip_wake;
        logic                        pg_disable;
        logic                        force_warm_reset;
        logic                        force_ip_inaccessible;
        //DFX signals
        logic                        fdfx_powergood_rst_b;
        logic                        fdfx_pgcb_bypass;
        logic                        fdfx_pgcb_ovr;
        logic                        fscan_isol_ctrl;
        logic                        fscan_isol_lat_ctrl;
        logic                        fscan_ret_ctrl;
        logic                        fscan_mode;
    } PgdCtlIn_t;
    
endpackage

