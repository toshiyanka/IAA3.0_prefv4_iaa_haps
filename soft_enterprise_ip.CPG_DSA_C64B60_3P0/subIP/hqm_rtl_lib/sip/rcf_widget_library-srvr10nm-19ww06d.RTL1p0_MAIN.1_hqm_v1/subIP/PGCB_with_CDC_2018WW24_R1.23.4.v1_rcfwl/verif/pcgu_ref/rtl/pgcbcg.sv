// -- Intel Proprietary
// -- Copyright (C) 2013 Intel Corporation
// -- All Rights Reserved
//--------------------------------------------------------------------------------------//
//    FILENAME        : pgcbcg.sv
//    DESIGNER        : amshah2
//    PROJECT         : BXT IP
//    DATE            : 09/27/2013, 10/03/2013
//    PURPOSE         : Reference Design for PGCB Clock Gating for BXT
//    REVISION NUMBER : 0.5
//----------------------------- Revision History ---------------------------------------//
//
//      Date        Rev     Owner     Description
//      --------    ---     -----     ---------------------------------------------------
//      09/27/2013  0.02    amshah2   Revamped the Unit to provide BXT Reference Design.
//      10/03/2013  0.5     amshah2   Include the following:
//                                    -Added functionality for ASYNC WIDGET.
//                                    -Revamped NOT WELL BEHAVED WAKE handling. 
//                                    -Consolidated gclock_req's, fabric_wakes, clk_red's
//                                    to save Gates for idle and wake logic.
//                                    -Parameterized Gclock Reqs from IOSF and Non-IOSF
//                                    domains.
//      10/18/2013  0.51    amshah2   Included the following:
//                                    -Fixed Bug HSD: 5191686 for Reference Design.
//                                    -Pulse width Check disabled for Two DS's.
//                                    -Name change for cdc_pwrgate_disabled to 
//                                    async_pwrgate_disabled
//-------------------------------------------------------------------------------------//

module pgcbcg #(
        parameter DEF_PWRON        = 0,              //IP defaults to Powered On? If set clkreq is asserted and clocks ungated out of reset
        parameter ICDC             = 5,              //PARAM NO. IOSF CLOCK CDC
        parameter NCDC             = 4,              //PARAM NO. NON-IOSF CLOCK CDC
        parameter IGCLK_REQ_ASYNC  = 5,              //TOTAL NO. OF GCLOCK REQ's FOR IOSF CLOCK CDC
        parameter NGCLK_REQ_ASYNC  = 5               //TOTAL NO. OF GCLOCK REQ's for NON-IOSF CLOCK CDC
    )(
// CLOCKS and RESETS --------------------------------------------------------------------------------------------
        input  logic                             pgcb_clk,                     //PGCB CLOCK
        input  logic                             pgcb_clkack,                  //PGCB CLOCK CLKACK
        output logic                             pgcb_clkreq,                  //PGCB CLOCK CLKREQ
        input  logic                             pgcb_rst_b,                   //PGCB RESET RISE EDGE SYNC'ed TO PGCB CLK
//PGCB CLOCK GATE and WAKE EVALUATION----------------------------------------------------------------------------
//IOSF CDC DOMAIN INPUT/OUTPUTS
        input  logic [ICDC-1:0]                  iosf_cdc_clock,               //IOSF CLOCK FEEDING IOSF CDC's "clock" INPUT
        input  logic [ICDC-1:0]                  iosf_cdc_reset_b,             //IOSF RESET, RISE-EDGE SYNC TO IOSF CLK FROM CDC's "sync_reset_b" OUTPUT
        input  logic [ICDC-1:0][2:0]             iosf_cdc_ism_fabric,          //IOSF FABRIC ISM STATE FROM IOSF CDC's "ism_fabric" INPUT  
        input  logic [ICDC-1:0]                  iosf_cdc_clkreq,              //CLK REQ's FROM IOSF CDC's TO SoC 
        input  logic [ICDC-1:0]                  iosf_cdc_clkack,              //CLK ACK's TO IOSF CDC's FROM SoC 
        input  logic [IGCLK_REQ_ASYNC-1:0]       iosf_cdc_gclock_req_async,    //GCLOCK REQ's TO IOSF CDC's FROM IP
        input  logic [IGCLK_REQ_ASYNC-1:0]       iosf_cdc_gclock_ack_async,    //GCLOCK ACK's FROM IOSF CDC's TO IP

//NON-IOSF CDC DOMAIN INPUT/OUTPUTS     
        input  logic [NCDC-1:0]                  non_iosf_cdc_clkreq,          //CLK REQ's FROM NON-IOSF CDC's TO SoC  
        input  logic [NCDC-1:0]                  non_iosf_cdc_clkack,          //CLK ACK's TO NON-IOSF CDC's FROM SoC
        input  logic [NGCLK_REQ_ASYNC-1:0]       non_iosf_cdc_gclock_req_async,//GCLOCK REQ's TO NON-IOSF CDC's FROM IP
        input  logic [NGCLK_REQ_ASYNC-1:0]       non_iosf_cdc_gclock_ack_async,//GCLOCK ACK's FROM NON-IOSF CDC's TO IP
        
        input  logic                             async_pwrgate_disabled,       //ASYNC VERSION OF "pwrgate_disabled" INPUT TO CDC's
                                                                               //NOTE: "async_pwrgate_disabled" NEEDS TO BE ASYNC TO TRIGGER
                                                                               //      A WAKE WHEN THE PGCB CLOCK IS GATED
        input  logic                             pmc_pg_wake,                  //ASYNC WAKE FROM PMC
        input  logic                             pgcb_pok,                     //"pgcb_pok" OUTPUT FROM PGCB
        input  logic                             pgcb_idle,                    //"pgcb_idle" OUTPUT FROM PGCB
//CONFIGURATIONS-------------------------------------------------------------------------------------------------
//PGCB CLOCK GATING CONFIGURATION--------------------------------------------------------------------------------
        input  logic                             cfg_acc_clkgate_disabled,     // IP-Accessible CLOCK GATE DISABLED
//HYSTERISIS DELAY-----------------------------------------------------------------------------------------------
        input  logic [3:0]                       cfg_t_clkgate,                // PGCB CLOCK GATE HYSTERISIS TIMER
        input  logic [3:0]                       cfg_t_clkwake,                // PGCB CLOCK WAKE HYSTERISIS TIMER 
//DFx------------------------------------------------------------------------------------------------------------
        input  logic [7:0]                       fscan_byprst_b,               // SCAN BYPASS RESET
        input  logic [7:0]                       fscan_rstbypen,               // SCAN RESET BYPASS EN
        input  logic                             fscan_clkungate,              // SCAN Override for Clock Gate
        output logic [31:0]                      visa_bus,                     // VISA
//Gated PGCB Clock-----------------------------------------------------------------------------------------------
        output logic                             pgcb_gclk                     // Gated version of pgcb_clk to be consumed by the
                                                                               // PGCB, CDCs and PGCB glue logic
    );

    logic[IGCLK_REQ_ASYNC-1:0] syncd_aw_iosf_cdc_gclock_req_b, awex_iosf_cdc_gclock_req_b;
    logic[NGCLK_REQ_ASYNC-1:0] syncd_aw_non_iosf_cdc_gclock_req_b, awex_non_iosf_cdc_gclock_req_b;

    logic[ICDC-1:0]            syncd_aw_iosf_cdc_clkreq_b, syncd_aw_fabric_wake_b,awex_iosf_cdc_clkreq_b, awex_fabric_wake_b, iosf_cdc_ism_fabric_con, iosf_cdc_ism_fabric_f;
    logic[NCDC-1:0]            syncd_aw_non_iosf_cdc_clkreq_b, awex_non_iosf_cdc_clkreq_b; 
    
    logic                      syncd_aw_pwrgate_disabled_wake_b, syncd_aw_pgcb_idle_b, syncd_pmc_pg_wake, awex_pwrgate_disabled_wake_b, awex_pgcb_idle_b;
    
    logic[7:0]                 scratchpad; 
    logic[1:0]                 cdc_idle_event; 
    logic[1:0]                 cdc_idle_event_sync;
    
    logic                      fabric_wake_ex_b, gclock_async_wake_ex_b, clkreq_wake_ex_b, clkack_con, gclock_ack_async_con, cdc_idle_fabric, cdc_idle_gclock, cdc_idle_clkreq;
    logic                      cdc_acc_wake_b, pwrgate_disabled_wake, pwrgate_disabled_syn, sync_gate_acc, sync_gate, syncd_async_wake_b, async_wake_b;

    logic                      sync_clkvld;
   
    logic[15:0]                pcgu_visa, pgcbcg_visa;
 
    assign scratchpad      = '0;        // Tied to 0s per the recommendation from the PGCB Clock Gating MAS
    
//INSTANCE OF THE PCGU
    pcgu       #(
                 .DEF_PWRON(DEF_PWRON)
                ) i_pcgu
                (
                 .pgcb_clk(pgcb_clk),                             // PGCB CLOCK
                 .pgcb_clkreq(pgcb_clkreq),                       // PGCB CLOCK CLKREQ
                 .pgcb_clkack(pgcb_clkack),                       // PGCB CLOCK CLKACK
                 .pgcb_rst_b(pgcb_rst_b),                         // SYNC PGCB RESET
                 .t_clkgate(cfg_t_clkgate),                       // PGCB CLOCK GATING 
                 .t_clkwake(cfg_t_clkwake),                       // PGCB CLOCK WAKE 
                 .scratchpad(scratchpad),                         // SCRATCHPAD
                 .sync_gate(sync_gate),                           // GATE
                 .async_wake_b(async_wake_b),                     // WAKE   
                 .pgcb_pok(pgcb_pok),                             // PGCB POK
                 .async_pmc_ip_wake(pmc_pg_wake),                 // Raw Unsynchronized version of PMC_IP_WAKE
                 .sync_clkvld(sync_clkvld),                       // CLOCK VALID   
                 .fscan_byprst_b(fscan_byprst_b[0]),              // SCAN BYPASS RESET
                 .fscan_rstbypen(fscan_rstbypen[0]),              // SCAN RESET BYPASS ENABLE
                 .pcgu_visa(pcgu_visa),                           // VISA VECTOR
                 .*
                );

// CAPTURE THE "pwrgate_disabled" FLAG WHEN THE "pgcb_clk IS VALID"
        
        // This input may toggle frequently, PULSE_WIDTH_CHECK may be able to be disabled
        pgcb_ctech_doublesync
        i_pgcb_ctech_doublesync_pwrgate_disabled //#(.PULSE_WIDTH_CHECK(0))
                (
                 .clk(pgcb_gclk), // Note that the gated clock is used so that on a transition the
                                  // wake stays asserted until the clock is actually ungated
                 .clr_b(pgcb_rst_b),
                 .d(async_pwrgate_disabled),
                 .q(pwrgate_disabled_syn)
                );

//DIFF THE "pwrgate_disabled_wake"
    assign pwrgate_disabled_wake = async_pwrgate_disabled ^ pwrgate_disabled_syn;

//CONSOLIDATING THE "iosf_cdc_ism_fabric" 
    for (genvar j = 0; j < ICDC; j++) begin : ISM_FAB_CONSOL
        assign iosf_cdc_ism_fabric_con[j]   = (|iosf_cdc_ism_fabric[j][2:0]);
    end
    
    for (genvar i = 0; i < ICDC; i++) begin : FLOP_FABRIC_LOOP        
        always_ff @(posedge iosf_cdc_clock[i], negedge iosf_cdc_reset_b[i]) begin
            if (!iosf_cdc_reset_b[i]) begin
                iosf_cdc_ism_fabric_f[i]  <= '0;
            end
            else begin
                iosf_cdc_ism_fabric_f[i]    <= (iosf_cdc_ism_fabric_con[i] != '0);
            end
        end
    end

//INSTANTIATION FOR "iosf_cdc_ism_fabric" EXTENSION WIDGET
    for (genvar i = 0; i < ICDC; i++) begin : FABRIC_WAKE_LOOP
    pcgu_aww 
       i_pcgu_aww_fabricwake
                (
                 .pgcb_clk(pgcb_clk),
                 .pgcb_rst_b(pgcb_rst_b),
                 .sync_clkvld(sync_clkvld),
                 .async_wake_source_b(~iosf_cdc_ism_fabric_f[i]),
                 .fscan_rstbypen(fscan_rstbypen[1]),
                 .fscan_byprst_b(fscan_byprst_b[1]),
                 .async_wake_extended_b(awex_fabric_wake_b[i]),
                 .sync_wake_source_b(syncd_aw_fabric_wake_b[i])
                );
    end

//INSTANTIATION FOR "iosf_cdc_gclock_req_async" EXTENSION WIDGET
    for (genvar i = 0; i < IGCLK_REQ_ASYNC; i++) begin : IGCLK_REQ_LOOP
    pcgu_aww 
       i_pcgu_aww_igclkreq
                (
                 .pgcb_clk(pgcb_clk),
                 .pgcb_rst_b(pgcb_rst_b),
                 .sync_clkvld(sync_clkvld),
                 .async_wake_source_b(~iosf_cdc_gclock_req_async[i]),
                 .fscan_rstbypen(fscan_rstbypen[2]),
                 .fscan_byprst_b(fscan_byprst_b[2]),
                 .async_wake_extended_b(awex_iosf_cdc_gclock_req_b[i]),
                 .sync_wake_source_b(syncd_aw_iosf_cdc_gclock_req_b[i])
                );
    end

//INSTANTIATION FOR "non_iosf_cdc_gclock_req_async" EXTENSION WIDGET
    for (genvar i = 0; i < NGCLK_REQ_ASYNC; i++) begin : NGCLK_REQ_LOOP
    pcgu_aww 
       i_pcgu_aww_ngclkreq
                (
                 .pgcb_clk(pgcb_clk),
                 .pgcb_rst_b(pgcb_rst_b),
                 .sync_clkvld(sync_clkvld),
                 .async_wake_source_b(~non_iosf_cdc_gclock_req_async[i]),
                 .fscan_rstbypen(fscan_rstbypen[3]),
                 .fscan_byprst_b(fscan_byprst_b[3]),
                 .async_wake_extended_b(awex_non_iosf_cdc_gclock_req_b[i]),
                 .sync_wake_source_b(syncd_aw_non_iosf_cdc_gclock_req_b[i])
                );
    end

//INSTANTIATION FOR "iosf_cdc_clkreq" EXTENSION WIDGET
    for (genvar i = 0; i < ICDC; i++) begin : ICLKREQ_LOOP
    pcgu_aww 
       i_pcgu_aww_iclkreq
                (
                 .pgcb_clk(pgcb_clk),
                 .pgcb_rst_b(pgcb_rst_b),
                 .sync_clkvld(sync_clkvld),
                 .async_wake_source_b(~iosf_cdc_clkreq[i]),
                 .fscan_rstbypen(fscan_rstbypen[4]),
                 .fscan_byprst_b(fscan_byprst_b[4]),
                 .async_wake_extended_b(awex_iosf_cdc_clkreq_b[i]),
                 .sync_wake_source_b(syncd_aw_iosf_cdc_clkreq_b[i])
                );
    end

//INSTANTIATION FOR "non_iosf_cdc_clkreq" EXTENSION WIDGET
    for (genvar i = 0; i < NCDC; i++) begin : NCLKREQ_LOOP
    pcgu_aww 
       i_pcgu_aww_nclkreq
                (
                 .pgcb_clk(pgcb_clk),
                 .pgcb_rst_b(pgcb_rst_b),
                 .sync_clkvld(sync_clkvld),
                 .async_wake_source_b(~non_iosf_cdc_clkreq[i]),
                 .fscan_rstbypen(fscan_rstbypen[5]),
                 .fscan_byprst_b(fscan_byprst_b[5]),
                 .async_wake_extended_b(awex_non_iosf_cdc_clkreq_b[i]),
                 .sync_wake_source_b(syncd_aw_non_iosf_cdc_clkreq_b[i])
                );
    end

//INSTANTIATION FOR "pwrgate_disabled_wake" EXTENSION WIDGET
    pcgu_aww  
       i_pcgu_aww_pgdis_wake
                (
                 .pgcb_clk(pgcb_clk),
                 .pgcb_rst_b(pgcb_rst_b),
                 .sync_clkvld(sync_clkvld),
                 .async_wake_source_b(~pwrgate_disabled_wake),
                 .fscan_rstbypen(fscan_rstbypen[6]),
                 .fscan_byprst_b(fscan_byprst_b[6]),
                 .async_wake_extended_b(awex_pwrgate_disabled_wake_b),
                 .sync_wake_source_b(syncd_aw_pwrgate_disabled_wake_b)
                );

//INSTANTIATION FOR "~pgcb_idle" EXTENSION WIDGET
    pcgu_aww  
       i_pcgu_aww_pgcbidle
                (
                 .pgcb_clk(pgcb_clk),
                 .pgcb_rst_b(pgcb_rst_b),
                 .sync_clkvld(sync_clkvld),
                 .async_wake_source_b(pgcb_idle),
                 .fscan_rstbypen(fscan_rstbypen[7]),
                 .fscan_byprst_b(fscan_byprst_b[7]),
                 .async_wake_extended_b(awex_pgcb_idle_b),
                 .sync_wake_source_b(syncd_aw_pgcb_idle_b)
                );

//Synchronize pmc_pg_wake for use in gate term
    pgcb_ctech_doublesync 
       i_pgcb_ctech_doublesync_pmcpgwake
                (
                 .clk(pgcb_clk),
                 .clr_b(pgcb_rst_b),
                 .d(pmc_pg_wake),
                 .q(syncd_pmc_pg_wake)
                );

//CONCATINATING ALL THE EXTENDED WAKES
    assign fabric_wake_ex_b           = (&awex_fabric_wake_b[ICDC-1:0]);
    assign gclock_async_wake_ex_b     = ((&awex_iosf_cdc_gclock_req_b[IGCLK_REQ_ASYNC-1:0]) && (&awex_non_iosf_cdc_gclock_req_b[NGCLK_REQ_ASYNC-1:0]));
    assign clkreq_wake_ex_b           = ((&awex_iosf_cdc_clkreq_b[ICDC-1:0]) && (&awex_non_iosf_cdc_clkreq_b[NCDC-1:0]));

//CONSOLIDATING A STRUCTURE FOR IDLE GENERATION 
//CDC SCON WAIVER NEEDED HERE
    assign clkack_con           = (|iosf_cdc_clkack[ICDC-1:0]) || (|non_iosf_cdc_clkack[NCDC-1:0]);
    assign gclock_ack_async_con = (|iosf_cdc_gclock_ack_async[IGCLK_REQ_ASYNC-1:0]) || (|non_iosf_cdc_gclock_ack_async[NGCLK_REQ_ASYNC-1:0]);

    assign cdc_idle_fabric      = (&syncd_aw_fabric_wake_b[ICDC-1:0]);
    assign cdc_idle_gclock      = (&syncd_aw_iosf_cdc_gclock_req_b[IGCLK_REQ_ASYNC-1:0]) && (&syncd_aw_non_iosf_cdc_gclock_req_b[NGCLK_REQ_ASYNC-1:0]);
    assign cdc_idle_clkreq      = (&syncd_aw_iosf_cdc_clkreq_b[ICDC-1:0]) && (&syncd_aw_non_iosf_cdc_clkreq_b[NCDC-1:0]);

    assign cdc_idle_event       = {gclock_ack_async_con, clkack_con};
    
    for (genvar r = 0; r < 2; r++) begin : LOOP_PGCB_SYNC
//PULSE_WIDTH_CHECK disabled as the input is an AND of a bunch of signals, which may glitch
//frequently.  This is acceptable however as we only care what value we synchronize in the
//steady state, all events must be idle for the hysteresis window of the PCGU in order to
//actually gate the clock.
        pgcb_ctech_doublesync #(.PULSE_WIDTH_CHECK(0))
        i_pgcb_ctech_doublesync_idle_event 
                (
                 .clk(pgcb_clk),
                 .clr_b(pgcb_rst_b),
                 .d(cdc_idle_event[r]),
                 .q(cdc_idle_event_sync[r])
                );
    end

//FINAL GATE GENERATION
    assign sync_gate_acc        = cdc_idle_gclock & cdc_idle_fabric & syncd_aw_pwrgate_disabled_wake_b & ~cdc_idle_event_sync[1] & ~cfg_acc_clkgate_disabled;
    assign sync_gate            = (~pgcb_pok | sync_gate_acc) & cdc_idle_clkreq & (pgcb_idle & syncd_aw_pgcb_idle_b) & ~syncd_pmc_pg_wake & ~cdc_idle_event_sync[0] & syncd_async_wake_b ;

//WAKE GENERATION
    assign cdc_acc_wake_b       = gclock_async_wake_ex_b & fabric_wake_ex_b & awex_pwrgate_disabled_wake_b;  
    assign async_wake_b         = (cdc_acc_wake_b | ~pgcb_pok) & clkreq_wake_ex_b & awex_pgcb_idle_b;

//DOUBLE-SYNC THE "async_wake_b" AS A SAFE GATE CONDITION     
//PULSE_WIDTH_CHECK disabled as pulse width violations will be seen on an "inactive" pulse when
//a subsequent wake event comes in quickly.  The "active" pulse should be asserted for at least
//3-4 clocks by using the pcgu_aww.
    pgcb_ctech_doublesync #(.PULSE_WIDTH_CHECK(0)) 
        i_pgcb_ctech_doublesync_async_wake_b  
               (
                .clk(pgcb_clk),
                .clr_b(pgcb_rst_b),
                .d(async_wake_b),
                .q(syncd_async_wake_b)
               );

//Generated gated version of PGCB clock to be consumed by the PGCB, CDCs and PGCB Glue Logic
    pgcb_ctech_clock_gate 
        i_pgcb_ctech_clock_gate_pgcb_gclk
               (
                .en(sync_clkvld), 
                .te(fscan_clkungate), 
                .clk(pgcb_clk), 
                .enclk(pgcb_gclk)
               );


//PGCBCG VISA && CONSOLIDATING THE FINAL VISA
    assign pgcbcg_visa = {async_wake_b, cdc_acc_wake_b, sync_gate, sync_gate_acc, cdc_idle_event_sync, cdc_idle_clkreq, cdc_idle_gclock, cdc_idle_fabric, gclock_ack_async_con, clkack_con, clkreq_wake_ex_b, gclock_async_wake_ex_b, fabric_wake_ex_b, pgcb_pok, pgcb_idle};

    assign visa_bus    = {pgcbcg_visa, pcgu_visa};


endmodule  //END PGCB 
