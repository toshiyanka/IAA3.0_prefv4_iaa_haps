// -- Intel Proprietary
// -- Copyright (C) 2013 Intel Corporation
// -- All Rights Reserved
//--------------------------------------------------------------------------------------//
//
//    FILENAME        : pcgu_aww.sv
//    UARCH           : kah.meng.yeem@intel.com; 
//                      jared.w.havican@intel.com;
//                      ankit.m.shah@intel.com.
//    DESIGNER        : amshah2
//    PROJECT         : BXT
//    DATE            : 09/27/2013
//    PURPOSE         : EXTEND ASYNC WAKE GENERATION 
//    REVISION NUMBER : 0.5
//
//---------------------------------- Revision History ----------------------------------//
//
//      Date        Rev     Owner     Description 
//      --------    ---     -----       --------------------------------
//      09/27/2013  0.02    amshah2   The Unit to provide BXT widget design.
//      10/04/2013  0.5     amshah2   Includes:
//                                    -Assumption: Wake source inputs are active low
//                                    -Added CTECH Components to support glitch-free
//                                    assumptions
//                                    -Module/Signal name, polarity, labeling corrections 
//--------------------------------------------------------------------------------------//

module pcgu_aww #(
    )(
        input  logic    pgcb_clk,             //PGCB_CLK
        input  logic    pgcb_rst_b,           //RISE-EDGE SYNCHRONIZED RESET TO PGCB_CLK
        input  logic    sync_clkvld,          //SYNCED CLOCK VALID FROM PCGU
        input  logic    async_wake_source_b,  //ASYNC WAKE 
        input  logic    fscan_rstbypen,       //SCAN 
        input  logic    fscan_byprst_b,       //SCAN BYPASS 
        output logic    async_wake_extended_b,//EXTENDED DEASSERT WAKE
        output logic    sync_wake_source_b    //SYNC PATH EXTENDED DEASSERT WAKE
    );
    
    logic               async_wake_dct_b;
    logic               async_wake_detect_b;
    logic               async_wake_rst_b;
    logic               async_wake_reset_b;
    logic               sync_wake_detect_b;
    logic               sync_wake_b;
   
//CTECH AND2
//ASSUMPTION: THE "async_wake_source_b" IS ACTIVE LOW AS PROVIDED TO THE WIDGET
    pgcb_ctech_and2_gen
        i_pgcb_ctech_and2_gen_async_wkrst_b (
                                       .a(pgcb_rst_b),
                                       .b(async_wake_source_b),
                                       .y(async_wake_rst_b)
                                      );
 
// Doublecheck that this is mx22
    pgcb_ctech_mux_2to1_gen
        i_pgcb_ctech_mux_2to1_gen_pgcb_rst_mux (
                                          .d2(async_wake_rst_b),
                                          .d1(fscan_byprst_b),
                                          .s(fscan_rstbypen),
                                          .o(async_wake_reset_b)
                                         );
           
    pgcb_ctech_doublesync
        i_pgcb_ctech_doublesync_async_wake_1 ( 
                                        .clk(pgcb_clk),
                                        .clr_b(async_wake_reset_b),
                                        .d(1'b1),
                                        .q(async_wake_dct_b)
                                       );

// METASTABILITY_EN is set to 0 as the d input changing (when the reset pin is stable) would be
// synchronous and so an extra clock cycle delay would never be introduced due to metastability
    pgcb_ctech_doublesync #(.METASTABILITY_EN(0))
        i_pgcb_ctech_doublesync_async_wake_2 
                                       (
                                        .clk(pgcb_clk),
                                        .clr_b(async_wake_reset_b),
                                        .d(async_wake_dct_b),
                                        .q(async_wake_detect_b)
                                       );

// PULSE_WIDTH_CHECK is set to 0 as the design guarantees we will never miss an "active" (low) pulse
// and missing an "inactive" pulse is okay as that would mean the design is just being conservative 
// and masking a small "gate" window that would be masked by the hysteresis period of the PCGU
// regardless
    pgcb_ctech_doublesync #(.PULSE_WIDTH_CHECK(0))
        i_pgcb_ctech_doublesync_sync_path 
                                    (
                                     .clk(pgcb_clk),
                                     .clr_b(pgcb_rst_b),
                                     .d(async_wake_detect_b),
                                     .q(sync_wake_b)
                                    );

    // sync_wake_source_b is used as input to sync_gate term on PCGU it makes most sense to stay
    // asserted until sync_clkvld asserts and it should assert as soon as it is doublesynced
    // to make the most conservative gate term
    assign sync_wake_source_b = sync_wake_b && sync_wake_detect_b;

        always_ff @(posedge pgcb_clk, negedge pgcb_rst_b)
            if (!pgcb_rst_b)
                sync_wake_detect_b  <= '0;
            else
                sync_wake_detect_b  <= (sync_clkvld || sync_wake_detect_b) && sync_wake_b;

//CTECH AND2 
    pgcb_ctech_and2_gen
        i_pgcb_ctech_and2_gen_final_wake_b (
                                      .a(async_wake_detect_b),
                                      .b(sync_wake_detect_b),
                                      .y(async_wake_extended_b)
                                      );

endmodule
