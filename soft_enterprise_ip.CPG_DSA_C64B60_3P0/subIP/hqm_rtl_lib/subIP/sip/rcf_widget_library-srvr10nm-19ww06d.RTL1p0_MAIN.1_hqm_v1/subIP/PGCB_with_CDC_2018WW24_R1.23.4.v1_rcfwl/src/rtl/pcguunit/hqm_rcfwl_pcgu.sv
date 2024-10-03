//------------------------------------------------------------------------------
//
//  INTEL CONFIDENTIAL
//
//  Copyright 2013 Intel Corporation All Rights Reserved.
//
//  The source code contained or described herein and all documents related
//  to the source code ("Material") are owned by Intel Corporation or its
//  suppliers or licensors. Title to the Material remains with Intel
//  Corporation or its suppliers and licensors. The Material contains trade
//  secrets and proprietary and confidential information of Intel or its
//  suppliers and licensors. The Material is protected by worldwide copyright
//  and trade secret laws and treaty provisions. No part of the Material may
//  be used, copied, reproduced, modified, published, uploaded, posted,
//  transmitted, distributed, or disclosed in any way without Intel's prior
//  express written permission.
//
//  No license under any patent, copyright, trade secret or other intellectual
//  property right is granted to or conferred upon you by disclosure or
//  delivery of the Materials, either expressly, by implication, inducement,
//  estoppel or otherwise. Any license under such intellectual property rights
//  must be express and approved by Intel in writing.
//
//------------------------------------------------------------------------------
//    FILENAME        : pcgu.sv
//    DESIGNER        : kyeem
//    PROJECT         : BXT
//    DATE            : 07/17/2013
//    PURPOSE         : To manage the PGCB CLKREQ sequencing
//    REVISION NUMBER : 0.75
//----------------------------- Revision History --------------------------------------------//
//
//      Date        Rev     Owner     Description
//      --------    ---     -----   --------------------------------
//      07/17/2013  0.00    Kah Meng  Initial version of PCGU per PGCB Clock Gating MAS Rev0.2
//      10/29/2013  0.75    amshah2   Added more VISA signals for visibility
//-------------------------------------------------------------------------------------------//

//Assumptions
// 1. The async_wake_b must be asserted long enough to avoid any meta-stability issue on the pgcb_clkreq
// 3. async_pmc_ip_wake must be asserted long enough to by synchronized to pgcb_clk and set the
//    clkreq_sustain flop.

module hqm_rcfwl_pcgu 
    #(
        parameter DEF_PWRON   = 0               // If set, pgcb_clkreq will be asserted in reset
    )
    (
        // Clocks & Resets ----------
        input logic      pgcb_clk,              // PGCB clock
        input logic      pgcb_rst_b,            // Rise-edge Synced PGCB reset
        output logic     pgcb_clkreq,           // PGCB Clock CLKREQ
        input logic      pgcb_clkack,           // PGCB Clock CLKACK

        // Hysteresis Delay
        input logic [3:0] t_clkgate,            // PGCB Clock Gating 
        input logic [3:0] t_clkwake,            // PGCB Clock Wake 
        // ECO Bits
        input logic [7:0] scratchpad,           // Scratchpad
        
        // PGCB Clock Gate and Wake Interface ----------
        input logic      sync_gate,             // Gate
        input logic      async_wake_b,          // Wake   
        output logic     sync_clkvld,           // Clock Valid
        
        // PGCB Interface ----------
        input logic      pgcb_pok,              // pgcb_pok output of PGCB
        input logic      async_pmc_ip_wake,     // Unsynchronized version of pmc_ip_wake directly from PMC

        // DFx ----------
        input logic      fscan_byprst_b,        // Scan Bypass Reset
        input logic      fscan_rstbypen,        // Scan Reset Bypass Enable
        output logic [15:0]   pcgu_visa         // Visa Vector
);
    logic clkreq_sustain, acc_wake_assert, pmc_wake_assert, defon_flag;
    logic mask_acc_wake, clr_acc_wake, clr_clkreq_sustain, mask_pmc_wake, clr_defon_flag;
    logic acc_wake_assert_sync, pmc_wake_assert_sync;
    logic reload_t_clkwake, reload_t_clkgate, dec;      // Must be mutually-exclusive
    
    logic clkack_syn;
    logic timer_expired;
    logic [7:0] nc_scratchpad;


    typedef enum logic [2:0] {
        CLKREQ_PMCWAKE   = 3'h5,    // PGCB clock could be gated at the SOC level. The FSM will only wake if the pmc_ip_wake is asserted (default)
        CLKREQ_SELWAKE   = 3'h0,    // PGCB clock could be gated at the SOC level. The FSM is ready to service any PGCB wake event
        CLKREQ_NOSEL     = 3'h1,    // PGCB clock is ungated at the SOC level. The FSM will de-assert the set_req_b, and make sure that it will met the PV requirement by waiting for the Clock Wake hysterisis dely.
        CLKREQ_UNGATECLK = 3'h2,    // PGCB clock is available for all the PGCB clock consumer
        CLKREQ_GATEPEND  = 3'h3,    // The pgcb_clkreq will be de-asserted soon. The PGCB clock consumer should avoid using the PGCB clock. 
        CLKREQ_GATECLK   = 3'h4,    // The pgcb_clkreq has been de-asserted, but the FSM is unable to service any PGCB wake event until it completed the clkreq handshake with SOC.
        CLKREQ_ERROR     = 'X       // Error (Should not reach this state)
    } clkreqfsmState_t;
    
    clkreqfsmState_t clkreqseqsm_ns, clkreqseqsm_ps;

    // clkack synchronizer
    hqm_rcfwl_pgcb_ctech_doublesync i_pgcb_ctech_doublesync_clkack (
        .clk(pgcb_clk),
        .clr_b(pgcb_rst_b),
        .d(pgcb_clkack),
        .q(clkack_syn)
    );
    
    
    //-----------------------------
    // CLKREQ Sequencer FSM
    //-----------------------------

    always_ff @(posedge pgcb_clk, negedge pgcb_rst_b) begin
        if (!pgcb_rst_b)
            clkreqseqsm_ps <= CLKREQ_PMCWAKE;
        else
            clkreqseqsm_ps <= clkreqseqsm_ns;
    end

    always_comb begin
        clkreqseqsm_ns = clkreqseqsm_ps;
        
        case(clkreqseqsm_ps)
            
            CLKREQ_PMCWAKE: 
                           if (clkack_syn && clkreq_sustain)
                              clkreqseqsm_ns = CLKREQ_NOSEL;

            CLKREQ_SELWAKE: 
                           if (clkack_syn && clkreq_sustain)
                              clkreqseqsm_ns = CLKREQ_NOSEL;

            CLKREQ_NOSEL: 
                           if (timer_expired)
                              clkreqseqsm_ns = CLKREQ_UNGATECLK;

            CLKREQ_UNGATECLK: 
                           if (sync_gate)
                              clkreqseqsm_ns = CLKREQ_GATEPEND;

            CLKREQ_GATEPEND: 
                           if (!sync_gate)
                              clkreqseqsm_ns = CLKREQ_UNGATECLK;
                           else if (sync_gate & timer_expired)
                              clkreqseqsm_ns = CLKREQ_GATECLK;

            CLKREQ_GATECLK: 
                           if (!clkack_syn & pgcb_pok)
                              clkreqseqsm_ns = CLKREQ_SELWAKE;
                           else if (!clkack_syn & !pgcb_pok)
                              clkreqseqsm_ns = CLKREQ_PMCWAKE;

            default : clkreqseqsm_ns = CLKREQ_ERROR;
         endcase
    end
    
    // -- FSM Outputs -- //
    // Combi Outputs
    assign clr_clkreq_sustain    = ((clkreqseqsm_ps == CLKREQ_GATEPEND) & (clkreqseqsm_ns == CLKREQ_GATECLK));

    assign clr_acc_wake          = (clkreqseqsm_ps == CLKREQ_UNGATECLK);

    assign clr_defon_flag        = ((clkreqseqsm_ps == CLKREQ_NOSEL) & (clkreqseqsm_ns == CLKREQ_UNGATECLK));

    // Flopped Outputs
    always_ff @(posedge pgcb_clk, negedge pgcb_rst_b) begin
        if (!pgcb_rst_b) begin
            mask_pmc_wake        <= 0;
            mask_acc_wake        <= 1;
            sync_clkvld          <= DEF_PWRON; // If DEF_PWRON, clock should be ungated in reset
        end else begin
            mask_pmc_wake        <= (clkreqseqsm_ns != CLKREQ_PMCWAKE) && (clkreqseqsm_ns != CLKREQ_SELWAKE);
            mask_acc_wake        <= (clkreqseqsm_ns != CLKREQ_SELWAKE);
            sync_clkvld          <= (clkreqseqsm_ns == CLKREQ_UNGATECLK) || defon_flag; // If DEF_PWRON, clock should be ungated out of reset
        end
    end
    
    // Timer Controls - All the control output must be mutually exclusive
    assign reload_t_clkwake = ( (clkreqseqsm_ps == CLKREQ_SELWAKE) | (clkreqseqsm_ps == CLKREQ_PMCWAKE)) & (clkreqseqsm_ns == CLKREQ_NOSEL);
    assign reload_t_clkgate = (clkreqseqsm_ps == CLKREQ_UNGATECLK) & (clkreqseqsm_ns == CLKREQ_GATEPEND);
    assign dec = (clkreqseqsm_ps == CLKREQ_GATEPEND) | (clkreqseqsm_ps == CLKREQ_NOSEL);


    //-----------------------------
    // Timer Logic
    //-----------------------------
    logic [3:0] tmr, tmr_nxt;

    // Control Mux
    always_comb begin
        if (reload_t_clkwake)
            tmr_nxt = t_clkwake;
        else if (reload_t_clkgate)
            tmr_nxt = t_clkgate;
        else if (dec)
            tmr_nxt = tmr - 1;
        else
            tmr_nxt = tmr;
    end

    // Timer Flop
    always_ff @(posedge pgcb_clk, negedge pgcb_rst_b) begin
        if (!pgcb_rst_b)
            tmr <= '1;
        else
            tmr <= tmr_nxt;
    end
    
    assign timer_expired = (tmr == '0);


    //-----------------------------
    // acc_wake_assert generation
    //    acc_wake_assert is used to assert clkreq when the clock is gated and the IP is in an IP-Accessible state.
    //    It is captured in an asynchronously set flop which will combinatorially and asynchronously assert clkreq.
    //    It is then synchronized to the pgcb_clk domain when the clock becomes available, which will synchronously
    //    set the clkreq_sustain flop, after which the acc_wake_assert path is masked off.
    //-----------------------------
    logic acc_wake_flop, acc_wake_flop_set_scan_b, masked_acc_wake_b;

    // mask async_wake_b so that the flop can be cleared when it is not being used
    assign masked_acc_wake_b = async_wake_b | mask_acc_wake;
    
    // Scan Reset Bypass Mux
     hqm_rcfwl_pgcb_ctech_mux_2to1_gen i_pgcb_ctech_mux_2to1_gen_mux_setreq (
        .d1(fscan_byprst_b),
        .d2(masked_acc_wake_b),
        .s(fscan_rstbypen),
        .o(acc_wake_flop_set_scan_b)
    );
    
    // acc_wake_flop is set by masked async wake term 
    always_ff @(posedge pgcb_clk, negedge acc_wake_flop_set_scan_b) begin
        if (!acc_wake_flop_set_scan_b)
            acc_wake_flop <= '1;
        else
            acc_wake_flop <= acc_wake_flop & !clr_acc_wake;
    end

    // mask output of flop when clkreq_sustain has taken over driving pgcb_clkreq
    hqm_rcfwl_pgcb_ctech_and2_gen i_pgcb_ctech_and2_gen_acc_wake (
        .a(acc_wake_flop),
        .b(~mask_acc_wake),
        .y(acc_wake_assert)
    );
    
    
    //-----------------------------
    // pmc_wake_assert generation
    //    pmc_wake_assert is used to assert clkreq when the clock is gated and the IP is in an IP-Inaccessible state.
    //    It combinatorially and asynchronously asserts clkreq and is also synchronized into the pgcb_clk domain to
    //    synchronously set the clkreq_sustain flop, after which the pmc_wake_assert path is masked off.
    //
    //    pmc_ip_wake is not captured in a flop immediately, but relies on the requirement that PMC keep it asserted
    //    until the domain is un-powergated. This in turn means that it is be asserted long enough to propagate
    //    through the synchronizer and set the clkreq_sustain flop before it deasserts, as the clock is required
    //    to un-powergate the domain.
    //-----------------------------
    logic async_pmc_ip_wake_or_flag;

    // The defon_flag causes clkreq to be asserted while in reset and is only cleared once the domain is ungated.
    // This behavior only occurs if the DEF_PWRON parameter is set, intended for IP's that need to be awake
    // before PMC comes out of reset (ie early-boot IPs)
    //
    // If DEF_PWRON==0 then the flag is always '0 and clkreq only asserts when PMC asserts the pmc_ip_wake
    if (DEF_PWRON) begin : defon_flag_flop
        always_ff @(posedge pgcb_clk, negedge pgcb_rst_b) begin
            if (!pgcb_rst_b)
                defon_flag <= '1;
            else
                defon_flag <= defon_flag & !clr_defon_flag;
        end
    end else begin : no_defon_flag
        logic nc_clr_defon_flag;
        assign nc_clr_defon_flag = clr_defon_flag;
        assign defon_flag = '0;
    end
    
    assign async_pmc_ip_wake_or_flag = async_pmc_ip_wake | defon_flag;
    
    hqm_rcfwl_pgcb_ctech_and2_gen i_pgcb_ctech_and2_gen_pmc_wake (
        .a(async_pmc_ip_wake_or_flag),
        .b(~mask_pmc_wake),
        .y(pmc_wake_assert)
    );
    
    
    //-----------------------------
    // clkreq_sustain generation
    //    clkreq_sustain is set when acc_wake_assert or pmc_wake_assert propagate through the synchronizers.
    //    It then keeps the clkreq asserted until the clock can be gated and is cleared by the FSM's clr_clkreq
    //    indication.
    //-----------------------------
    
    hqm_rcfwl_pgcb_ctech_doublesync i_pgcb_ctech_doublesync_acc_wake(
        .d(acc_wake_assert),
        .clr_b(pgcb_rst_b),
        .clk(pgcb_clk),
        .q(acc_wake_assert_sync)
    );
    
    hqm_rcfwl_pgcb_ctech_doublesync i_pgcb_ctech_doublesync_pmc_wake(
        .d(pmc_wake_assert),
        .clr_b(pgcb_rst_b),
        .clk(pgcb_clk),
        .q(pmc_wake_assert_sync)
    );
    
    always_ff @(posedge pgcb_clk, negedge pgcb_rst_b) begin
        if (!pgcb_rst_b)
            clkreq_sustain <= '0;
        else
            clkreq_sustain <= (clkreq_sustain | acc_wake_assert_sync | pmc_wake_assert_sync) & !clr_clkreq_sustain;
    end

    
    //-----------------------------
    // clkreq generation
    //    clkreq asserts asynchronously by either acc_wake_assert or pmc_wake_assert and deasserts
    //    synchronously through clkreq_sustain.
    //-----------------------------
    assign pgcb_clkreq = acc_wake_assert | pmc_wake_assert | clkreq_sustain;
    

    // ECO Bit Tieoffs
    for (genvar r = 0; r < 8; r++) begin : scratchpad_1
        hqm_rcfwl_pgcb_ctech_and2_gen  
        i_pgcb_ctech_and2_gen_buf_scratchpad(
                                       .a(scratchpad[r]), 
                                       .b(scratchpad[r]), 
                                       .y(nc_scratchpad[r])
                                      );
    end

//DFx - VISA
    assign pcgu_visa = {acc_wake_flop,
                        defon_flag,
                        pmc_wake_assert,
                        acc_wake_assert,
                        clkreq_sustain,
                        clkack_syn,
                        async_wake_b,
                        sync_gate,
                        pgcb_clkreq,
                        tmr,
                        clkreqseqsm_ps};

`ifndef INTEL_SVA_OFF
   `include "pcgu.sva"
`endif

endmodule  //End PGCU
