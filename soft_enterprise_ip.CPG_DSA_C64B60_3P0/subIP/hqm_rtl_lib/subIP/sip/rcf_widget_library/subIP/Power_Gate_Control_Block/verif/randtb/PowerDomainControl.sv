/**********************************************************************************************************************\
|*                                                                                                                    *|
|*  Copyright (c) 2012 by Intel Corporation.  All rights reserved.                                                    *|
|*                                                                                                                    *|
|*  This material constitutes the confidential and proprietary information of Intel Corp and is not to be disclosed,  *|
|*  reproduced, copied, or used in any manner not permitted under license from Intel Corp.                            *|
|*                                                                                                                    *|
\**********************************************************************************************************************/

/**********************************************************************************************************************\
 * PowerDomainControl
 * @author Jeff Wilcox
 * 
 * 
\**********************************************************************************************************************/
`timescale 1ns/1ns

module PowerDomainControl #(
    DEF_PWRON = 1,                                  //Default to a powered-on state after reset
    ICDC=2,                                         //Number of CDCs that control IOSF domains
    NCDC=2                                         //Number of CDCs that control non-IOSF domains
)(
    //PGCB ClockDomain
    input   logic       pgcb_clk,                   //PGCB clock; always running
    input   logic       pgcb_raw_rst_b,             //Async reset for pgcb clock domain
    output  logic       pgcb_clkreq,                //PGCB Clock CLKREQ
    input   logic       pgcb_clkack,                //PGCB Clock CLKACK
 
    //POK Control
    input   logic       pok_reset_b,                //Asynchronous reset for POK
   
    //HYSTERESIS Delay
    input   logic [3:0] t_clkgate,                  // PGCB Clock Gating
    
    //IOSF CDC Clocks, Resets and Controls
    input   Rtb_pkg::CdcCtlIn_t[ICDC-1:0]   ictl_in,
    output  Rtb_pkg::CdcCtlOut_t[ICDC-1:0]  ictl_out,
    
    //Non-IOSF CDC Clocks, Resets and Controls
    input   Rtb_pkg::CdcCtlIn_t[NCDC-1:0]   nctl_in,
    output  Rtb_pkg::CdcCtlOut_t[NCDC-1:0]  nctl_out,
    
    //PGCB Config and Control
    input   Rtb_pkg::PgcbCfg_t              pcfg,
    input   Rtb_pkg::PgdCtlIn_t             pctl_in,
    output  Rtb_pkg::PgdCtlOut_t            pctl_out,

    //CDC Config Control
    input   Rtb_pkg::CdcCfg_t               cfg 
);
    import Rtb_pkg::*;
    
    logic pgcb_gclk, pgcb_reset_b, pgcb_pok, pgcb_force_rst_b, pgcb_restore, pgcb_pwrgate_active, ip_pgcb_pg_rdy_req_b;
    logic pwrgate_disabled, pwrgate_disabled_sync, pwrgate_pmc_wake, pwrgate_force, pgcb_sleep, pgcb_ip_force_clks_on;
    logic ip_pgcb_all_pg_rst_up, ip_pgcb_force_clks_on_ack, fscan_clkungate;
    logic [ICDC-1:0] ipwrgate_ready;
    logic [NCDC-1:0] npwrgate_ready;
    logic [31:0] visa_bus;
    enum logic [1:0] {SLP_INACC = 2'b11, SLP_WRST=2'b01, SLP_ACC=2'b00} ip_pgcb_pg_type; 
    
    
    /******************************************************************************************************************\
     *  
     *  Reset Controls
     *  
    \******************************************************************************************************************/
                                                 
    pgcb_ctech_doublesync_rstmux u_pgcbRstMux(.clk(pgcb_clk), .clr_b(pgcb_raw_rst_b), .rst_bypass_b(1'b1),
                                                 .rst_bypass_sel(1'b0), .q(pgcb_reset_b));
    
    /******************************************************************************************************************\
     *  
     *  Aggregation and Glue Logic
     *  
    \******************************************************************************************************************/
    logic   force_warm_reset, force_ip_inacc, force_warm_reset_pg, force_ip_inacc_pg;
    
    assign ip_pgcb_pg_rdy_req_b = ~((&ipwrgate_ready) & (&npwrgate_ready));
 
    always_ff @(posedge pgcb_clk, negedge pgcb_reset_b) begin
        if (!pgcb_reset_b) begin
	    //Aparna commented
            //pwrgate_disabled    <= '0;
            force_warm_reset_pg <= '0;
            force_ip_inacc_pg   <= '0;
        end
        else begin
	    //Aparna commneted
            //pwrgate_disabled    <= pctl_in.pg_disable;    //Effectively the aggregation of several conditions
            force_warm_reset_pg <= force_warm_reset | (force_warm_reset_pg & pgcb_pok);        //Normally would be a double flop sync
            force_ip_inacc_pg   <= force_ip_inacc | (force_ip_inacc_pg & pgcb_pok);          //Normally would be a double flop sync
        end
    end
   
//amshah2 - Double Syncing the pwrgate_pmc_wake to pgcb_clk and pgcb_reset_b
//The synced version is fed to the broadcast to CDC's.

    pgcb_ctech_doublesync
        i_pgcb_ctech_doublesync_pwrgate_pmc_wake (
                                            .clk(pgcb_clk),
                                            .clr_b(pgcb_reset_b),
                                            .d(pctl_in.pmc_ip_wake),
                                            .q(pwrgate_pmc_wake)
                                           );
 
    assign pwrgate_force    = force_ip_inacc_pg | force_warm_reset_pg;
    assign fscan_clkungate       = 1'b0;
    
    assign ip_pgcb_pg_type  = force_ip_inacc_pg     ?   SLP_INACC   : 
                              force_warm_reset_pg   ?   SLP_WRST    :
                                                        SLP_ACC     ;
    
    //Emulates the logic that would catch the IOSF message - Test bench must request this clock before this gets 
    //registered like we would have when a message comes in on IOSF-SB
    always_ff @(posedge ictl_in[0].clock, negedge ictl_in[0].reset_b) begin
        if (!ictl_in[0].reset_b) begin
            force_warm_reset    <= '0;
            force_ip_inacc      <= '0;
        end
        else begin
            force_warm_reset    <= pctl_in.force_warm_reset;
            force_ip_inacc      <= pctl_in.force_ip_inaccessible;
        end
    end
    
    always_comb begin
        ip_pgcb_all_pg_rst_up = '1;
        ip_pgcb_force_clks_on_ack = '1;
        pctl_out.all_isms_unlocked = '1;
        pctl_out.all_poks_deasserted = '1;
        for (int i = 0; i < ICDC; i++) begin
            ip_pgcb_all_pg_rst_up &= ictl_in[i].all_pg_rst_up;
            ip_pgcb_force_clks_on_ack &= ictl_in[i].force_clks_on_ack;
            pctl_out.all_isms_unlocked &= ~ictl_out[i].ism_locked;
            pctl_out.all_poks_deasserted &= ~ictl_out[i].pok;
        end
        for (int n = 0; n < NCDC; n++) begin
            ip_pgcb_all_pg_rst_up = ip_pgcb_all_pg_rst_up & nctl_in[n].all_pg_rst_up;
            ip_pgcb_force_clks_on_ack = ip_pgcb_force_clks_on_ack & nctl_in[n].force_clks_on_ack;
        end
    end
    
//amshah2 - Double Syncing the pwrgate_disabled to pgcb_clk and pgcb_reset_b
//The synced version is fed to the broadcast to CDC's.

    assign pwrgate_disabled = cfg.pwrgate_disabled;
    
    pgcb_ctech_doublesync
        i_pgcb_ctech_doublesync_pwrgate_disabled (
                                            .clk(pgcb_clk),
                                            .clr_b(pgcb_reset_b),
                                            .d(pwrgate_disabled),
                                            .q(pwrgate_disabled_sync)
                                           );

    /******************************************************************************************************************\
     *  
     *  IOSF Domain CDCs
     *  
    \******************************************************************************************************************/
    localparam [7:0][31:0] PRESCC         = {0,0,0,0,1,1,1,1};
    localparam [7:0][31:0] FLOP_CG_EN     = {0,1,0,1,0,1,0,1};
    localparam [7:0][31:0] DSYNC_CG_EN    = {1,1,0,0,0,0,1,1};
    localparam [7:0][31:0] RSTR_B4_FORCE  = {1,1,0,0,1,0,1,1};
    localparam [7:0][31:0] CG_LOCK_ISM    = {0,1,0,1,0,1,0,1};
    
    for(genvar i = 0; i < ICDC; i++) begin : IosfCdc

        ClockDomainController #(
          .DEF_PWRON(DEF_PWRON), 
          .ITBITS(Rtb_pkg::ITBITS), 
          .RST(1), 
          .AREQ(Rtb_pkg::AREQ), 
          .DRIVE_POK(1),
          .PRESCC(PRESCC[(i*(2))+0]),
          .DSYNC_CG_EN(DSYNC_CG_EN[(i*(2))+0]),
          .FLOP_CG_EN(FLOP_CG_EN[(i*(2))+0]),
          .RSTR_B4_FORCE(RSTR_B4_FORCE[(i*(2))+0]),
          .CG_LOCK_ISM(CG_LOCK_ISM[(i*(2))+0])
        ) u_IosfCdc(
          // Inputs
          .pgcb_clk(pgcb_clk),
          .pgcb_rst_b(pgcb_reset_b),
          .clock(ictl_in[i].clock),
          .prescc_clock(ictl_in[i].clock),
          .reset_b(ictl_in[i].reset_b),
          .clkack(ictl_in[i].clkack),
          .pok_reset_b(pok_reset_b),
          .gclock_req_sync(ictl_in[i].gclock_req_sync),
          .gclock_req_async(ictl_in[i].gclock_req_async),
          .ism_fabric(ictl_in[i].ism_fabric),
          .ism_agent(ictl_in[i].ism_agent),
          .cfg_clkgate_disabled(cfg.cfg_clkgate_disabled),
          .cfg_clkreq_ctl_disabled(cfg.cfg_clkreq_ctl_disabled),
          .cfg_clkgate_holdoff(cfg.cfg_clkgate_holdoff),
          .cfg_pwrgate_holdoff(cfg.cfg_pwrgate_holdoff),
          .cfg_clkreq_off_holdoff(cfg.cfg_clkreq_off_holdoff),
          .cfg_clkreq_syncoff_holdoff(cfg.cfg_clkreq_syncoff_holdoff),
          .pwrgate_disabled(pwrgate_disabled_sync), 
          .pwrgate_force(pwrgate_force), 
          .pwrgate_pmc_wake(pwrgate_pmc_wake),
          .pgcb_force_rst_b(pgcb_force_rst_b),
          .pgcb_pok(pgcb_pok),
          .pgcb_restore(pgcb_restore),
          .pgcb_pwrgate_active(pgcb_pwrgate_active),
          .fscan_clkungate(fscan_clkungate),
          .fscan_byprst_b('1),
          .fscan_rstbypen('0),
          .fscan_clkgenctrl('0),
          .fscan_clkgenctrlen('0),
          .fismdfx_force_clkreq('0),
          .fismdfx_clkgate_ovrd('0),
          // Outputs
          .reset_sync_b(ictl_out[i].reset_sync_b),
          .clkreq(ictl_out[i].clkreq),
          .pok(ictl_out[i].pok),
          .gclock(ictl_out[i].gclock),
          .greset_b(ictl_out[i].greset_b),
          .gclock_ack_async(ictl_out[i].gclock_ack_async),
          .gclock_active(ictl_out[i].gclock_active),
          .ism_locked(ictl_out[i].ism_locked),
          .boundary_locked(ictl_out[i].boundary_locked),
          .pwrgate_ready(ipwrgate_ready[i]),
          .gclock_enable_final(),
          .cdc_visa(),
          .*
        );
        
        assign ictl_out[i].pgcb_sleep = pgcb_sleep;
        assign ictl_out[i].force_clks_on = pgcb_ip_force_clks_on;
        assign ictl_out[i].frc_clk_srst_en = pcfg.ip_pgcb_frc_clk_srst_en;
        assign ictl_out[i].frc_clk_cp_en = pcfg.ip_pgcb_frc_clk_cp_en;
    end
    
    /******************************************************************************************************************\
     *  
     *  Non-IOSF Domain CDCs
     *  
    \******************************************************************************************************************/
    
    for(genvar n = 0; n < NCDC; n++) begin : NonIosfCdc

        ClockDomainController #(
          .DEF_PWRON(DEF_PWRON), 
          .ITBITS(Rtb_pkg::ITBITS), 
          .RST(1), 
          .AREQ(Rtb_pkg::AREQ), 
          .DRIVE_POK(0),
          .PRESCC(PRESCC[(n*(1))+ICDC]),
          .DSYNC_CG_EN(DSYNC_CG_EN[(n*(1))+ICDC]),
          .FLOP_CG_EN(FLOP_CG_EN[(n*(1))+ICDC]),
          .RSTR_B4_FORCE(RSTR_B4_FORCE[(n*(1))+ICDC]),
          .CG_LOCK_ISM(CG_LOCK_ISM[(n*(1))+ICDC])
        ) u_NonIosfCdc(
          // Inputs
          .pgcb_clk(pgcb_clk),
          .pgcb_rst_b(pgcb_reset_b),
          .clock(nctl_in[n].clock),
          .prescc_clock(nctl_in[n].clock),
          .reset_b(nctl_in[n].reset_b),
          .clkack(nctl_in[n].clkack),
          .pok_reset_b(1'b0),
          .gclock_req_sync(nctl_in[n].gclock_req_sync),
          .gclock_req_async(nctl_in[n].gclock_req_async),
          .ism_fabric(3'd0),
          .ism_agent(3'd0),
          .cfg_clkgate_disabled(cfg.cfg_clkgate_disabled),
          .cfg_clkreq_ctl_disabled(cfg.cfg_clkreq_ctl_disabled),
          .cfg_clkgate_holdoff(cfg.cfg_clkgate_holdoff),
          .cfg_pwrgate_holdoff(cfg.cfg_pwrgate_holdoff),
          .cfg_clkreq_off_holdoff(cfg.cfg_clkreq_off_holdoff),
          .cfg_clkreq_syncoff_holdoff(cfg.cfg_clkreq_syncoff_holdoff),
          .pwrgate_disabled(pwrgate_disabled_sync),
          .pwrgate_force(pwrgate_force),
          .pwrgate_pmc_wake(pwrgate_pmc_wake),
          .pgcb_force_rst_b(pgcb_force_rst_b),
          .pgcb_pok(pgcb_pok),
          .pgcb_restore(pgcb_restore),
          .pgcb_pwrgate_active(pgcb_pwrgate_active),
          .fscan_clkungate(fscan_clkungate),
          .fscan_byprst_b('1),
          .fscan_rstbypen('0),
          .fscan_clkgenctrl('0),
          .fscan_clkgenctrlen('0),
          .fismdfx_force_clkreq('0),
          .fismdfx_clkgate_ovrd('0),
          // Outputs
          .reset_sync_b(nctl_out[n].reset_sync_b),
          .clkreq(nctl_out[n].clkreq),
          .pok(nctl_out[n].pok),
          .gclock(nctl_out[n].gclock),
          .greset_b(nctl_out[n].greset_b),
          .gclock_ack_async(nctl_out[n].gclock_ack_async),
          .gclock_active(nctl_out[n].gclock_active),
          .ism_locked(nctl_out[n].ism_locked),
          .boundary_locked(nctl_out[n].boundary_locked),
          .pwrgate_ready(npwrgate_ready[n]),
          .gclock_enable_final(),
          .cdc_visa(),
          .*
        );
        
        assign nctl_out[n].pgcb_sleep = pgcb_sleep;
        assign nctl_out[n].force_clks_on = pgcb_ip_force_clks_on;
        assign nctl_out[n].frc_clk_srst_en = pcfg.ip_pgcb_frc_clk_srst_en;
        assign nctl_out[n].frc_clk_cp_en = pcfg.ip_pgcb_frc_clk_cp_en;
    end
    
    
    /******************************************************************************************************************\
     *  
     *  PGCB Instance
     *  
    \******************************************************************************************************************/
    
    pgcbunit #(
      .DEF_PWRON(DEF_PWRON), 
      .ISOLLATCH_NOSR_EN(1'b0)
    ) u_pgcbunit(
      // Inputs
      .clk(pgcb_gclk),
      .pgcb_rst_b(pgcb_reset_b),
      //.pgcb_tck('0),
      .pgcb_tck(pgcb_clk),
      //.fdfx_powergood_rst_b('0),
      .fdfx_powergood_rst_b(pctl_in.fdfx_powergood_rst_b),
      .pmc_pgcb_pg_ack_b(pctl_in.pmc_ip_pg_ack_b),
      .pmc_pgcb_restore_b(pctl_in.pmc_ip_restore_b),
      .ip_pgcb_pg_type(ip_pgcb_pg_type),
      .ip_pgcb_pg_rdy_req_b(ip_pgcb_pg_rdy_req_b),
      .ip_pgcb_all_pg_rst_up(ip_pgcb_all_pg_rst_up),        
      .ip_pgcb_frc_clk_srst_cc_en(pcfg.ip_pgcb_frc_clk_srst_en),
      .ip_pgcb_frc_clk_cp_en(pcfg.ip_pgcb_frc_clk_cp_en),
      .ip_pgcb_force_clks_on_ack(ip_pgcb_force_clks_on_ack),
      .ip_pgcb_sleep_en(1'b1),
      .cfg_tsleepinactiv(pcfg.cfg_tsleepinactiv),
      .cfg_tdeisolate(pcfg.cfg_tdeisolate),
      .cfg_tpokup(pcfg.cfg_tpokup),
      .cfg_tinaccrstup(pcfg.cfg_tinaccrstup),
      .cfg_taccrstup(pcfg.cfg_taccrstup),
      .cfg_tlatchen(pcfg.cfg_tlatchen),
      .cfg_tpokdown(pcfg.cfg_tpokdown),
      .cfg_tlatchdis(pcfg.cfg_tlatchdis),
      .cfg_tsleepact(pcfg.cfg_tsleepact),
      .cfg_tisolate(pcfg.cfg_tisolate),
      .cfg_trstdown(pcfg.cfg_trstdown),
      .cfg_tclksonack_srst(pcfg.cfg_tclksonack_srst),
      .cfg_tclksoffack_srst(pcfg.cfg_tclksoffack_srst),
      .cfg_tclksonack_cp(pcfg.cfg_tclksonack_cp),
      .cfg_trstup2frcclks(pcfg.cfg_trstup2frcclks),
      .cfg_trsvd0(pcfg.cfg_trsvd0),
      .cfg_trsvd1(pcfg.cfg_trsvd1),
      .cfg_trsvd2(2'dX),
      .cfg_trsvd3(2'dX),
      .cfg_trsvd4(2'dX),
      .pmc_pgcb_fet_en_b('0),
      //.fdfx_pgcb_bypass('0),
      //.fdfx_pgcb_ovr('0),
      //.fscan_isol_ctrl(),
      //.fscan_isol_lat_ctrl(),
      //.fscan_ret_ctrl('0),
      //.fscan_mode('0),
      .fdfx_pgcb_bypass(pctl_in.fdfx_pgcb_bypass),
      .fdfx_pgcb_ovr(pctl_in.fdfx_pgcb_ovr),
      .fscan_isol_ctrl(pctl_in.fscan_isol_ctrl),
      .fscan_isol_lat_ctrl(pctl_in.fscan_isol_lat_ctrl),
      .fscan_ret_ctrl(pctl_in.fscan_ret_ctrl),
      .fscan_mode(pctl_in.fscan_mode),
      // Outputs
      .pgcb_pmc_pg_req_b(pctl_out.pgcb_pmc_pg_req_b), 
      .pgcb_ip_pg_rdy_ack_b(),                 
      .pgcb_pok(pgcb_pok),
      .pgcb_restore(pgcb_restore),
      .pgcb_restore_force_reg_rw(), //Ignore for now
      .pgcb_sleep(pgcb_sleep),      
      .pgcb_isol_latchen(),         //Ignore for now
      .pgcb_isol_en_b(),            //Ignore for now
      .pgcb_force_rst_b(pgcb_force_rst_b),
      .pgcb_idle(pctl_out.pgcb_idle),                    
      .pgcb_pwrgate_active(pgcb_pwrgate_active),
      .pgcb_ip_force_clks_on(pgcb_ip_force_clks_on),  
      .pgcb_visa(),
      .pgcb_ip_fet_en_b(),
      .pgcb_sleep2(),
      .*
    );
    
    assign pctl_out.pgcb_pwrgate_active = pgcb_pwrgate_active;
    assign pctl_out.pgcb_restore = pgcb_restore;

    /******************************************************************************************************************\
     *  
     *  PGCBCG Instance
     *  
    \******************************************************************************************************************/
    localparam IGCLK_REQ_ASYNC = (ICDC * Rtb_pkg::AREQ);
    localparam NGCLK_REQ_ASYNC = (NCDC * Rtb_pkg::AREQ);
    
    logic  [ICDC-1:0]             iosf_cdc_clock, iosf_cdc_reset_b, iosf_cdc_clkack, iosf_cdc_clkreq; 
    logic  [ICDC-1:0][2:0]        iosf_cdc_ism_fabric;
    logic  [NCDC-1:0]             non_iosf_cdc_clkack, non_iosf_cdc_clkreq; 
    logic  [IGCLK_REQ_ASYNC-1:0]  iosf_cdc_gclock_req_async, iosf_cdc_gclock_ack_async; 
    logic  [NGCLK_REQ_ASYNC-1:0]  non_iosf_cdc_gclock_req_async, non_iosf_cdc_gclock_ack_async;


    for (genvar i = 0; i < ICDC; i++) begin : LOOP_A
        assign iosf_cdc_clock[i]                = ictl_in[i].clock;
        assign iosf_cdc_reset_b[i]              = ictl_in[i].reset_b;
        assign iosf_cdc_clkack[i]               = ictl_in[i].clkack;
        assign iosf_cdc_clkreq[i]               = ictl_out[i].clkreq;
        assign iosf_cdc_ism_fabric[i]           = ictl_in[i].ism_fabric;
    end
    for (genvar n = 0; n < NCDC; n++) begin : LOOP_B
        assign non_iosf_cdc_clkack[n]           = nctl_in[n].clkack;
        assign non_iosf_cdc_clkreq[n]           = nctl_out[n].clkreq;
    end        

    for (genvar i = 0; i < IGCLK_REQ_ASYNC; i=(i+5)) begin : LOOP_REQ_C
        for (genvar j = 0; j < ICDC; j++) begin : LOOP_ICDC_C
            for (genvar k = 0; k < Rtb_pkg::AREQ; k++) begin : LOOP_C 
                assign iosf_cdc_gclock_ack_async[i+k]     = ictl_out[j].gclock_ack_async[k]; 
                assign iosf_cdc_gclock_req_async[i+k]     = ictl_in[j].gclock_req_async[k];
            end
        end
    end       
    for (genvar i = 0; i < NGCLK_REQ_ASYNC; i=(i+5)) begin : LOOP_REQ_D
        for (genvar j = 0; j < ICDC; j++) begin : LOOP_NCDC_D
            for (genvar k = 0; k < Rtb_pkg::AREQ; k++) begin : LOOP_D
                assign non_iosf_cdc_gclock_req_async[i+k] = nctl_in[j].gclock_req_async[k];
                assign non_iosf_cdc_gclock_ack_async[i+k] = nctl_out[j].gclock_ack_async[k];
            end
        end
    end
    
    pgcbcg #(
        .DEF_PWRON        (DEF_PWRON),
        .ICDC             (ICDC),
        .NCDC             (NCDC),
        .IGCLK_REQ_ASYNC  (IGCLK_REQ_ASYNC),
        .NGCLK_REQ_ASYNC  (NGCLK_REQ_ASYNC)    
    )
    u_pgcbcg (
        .pgcb_clk(pgcb_clk),                     
        .pgcb_clkreq(pgcb_clkreq),
        .pgcb_clkack(pgcb_clkack),
        .pgcb_rst_b(pgcb_reset_b),
        .pgcb_gclk(pgcb_gclk),               
        .iosf_cdc_clock(iosf_cdc_clock[ICDC-1:0]),
        .iosf_cdc_reset_b(iosf_cdc_reset_b[ICDC-1:0]),
        .iosf_cdc_clkack(iosf_cdc_clkack[ICDC-1:0]),
        .non_iosf_cdc_clkack(non_iosf_cdc_clkack[NCDC-1:0]),
        .iosf_cdc_clkreq(iosf_cdc_clkreq[ICDC-1:0]),
        .non_iosf_cdc_clkreq(non_iosf_cdc_clkreq[NCDC-1:0]),
        .iosf_cdc_gclock_req_async(iosf_cdc_gclock_req_async[IGCLK_REQ_ASYNC-1:0]),
        .non_iosf_cdc_gclock_req_async(non_iosf_cdc_gclock_req_async[NGCLK_REQ_ASYNC-1:0]),
        .iosf_cdc_gclock_ack_async(iosf_cdc_gclock_ack_async[IGCLK_REQ_ASYNC-1:0]),
        .non_iosf_cdc_gclock_ack_async(non_iosf_cdc_gclock_ack_async[NGCLK_REQ_ASYNC-1:0]),
        .iosf_cdc_ism_fabric(iosf_cdc_ism_fabric[ICDC-1:0]), 
        .async_pwrgate_disabled(cfg.pwrgate_disabled),  
        .pmc_pg_wake(pctl_in.pmc_ip_wake),
        .pgcb_pok(pgcb_pok),
        .pgcb_idle(pctl_out.pgcb_idle),
        .cfg_acc_clkgate_disabled(1'b0),  
        .cfg_t_clkgate(4'h4),         
        .cfg_t_clkwake(4'h1),             
        .fscan_byprst_b('1),
        .fscan_rstbypen('0),
        .visa_bus(visa_bus),
        .*
    );

endmodule
