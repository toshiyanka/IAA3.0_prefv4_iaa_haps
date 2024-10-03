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

/**********************************************************************************************************************\
 * CdcMainClock
 * @author Jared Havican 
 * 
 * 
\**********************************************************************************************************************/

module hqm_rcfwl_CdcMainCg #(
    DEF_PWRON = 1,                                  //Default to a powered-on state after reset
    PRESCC = 0,                                     //If 1, The clock gate logic with have clkgenctrl muxes for scan to have control
                                                    //      of the clock branch in order to be used preSCC
                                                    //      NOTE: FLOP_CG_EN and DSYNC_CG_EN are a don’t care when PRESCC=1
    DSYNC_CG_EN = 0,                                //If 1, the clock-gate enable will be synchronized to the short clock-tree version
                                                    //      of clock to allow for STA convergence on fast clocks ( >120 MHz )
                                                    //      Note: FLOP_CG_EN is a don't care when DSYNC_CG_EN=1
    FLOP_CG_EN = 1                                  //If 1, the clock-gate enable will be driven solely by the output of a flop
                                                    //If 0, there will be a combi path into the cg enable to allow for faster ungating
)(
    //Master clock Domain
    input   logic       clock,                      //Master clock
    input   logic       prescc_clock,               //pre-SCC version of Master clock (tie to 0 if PRESCC parameter is '0')
    output  logic       gclock,                     //Gated verison of clock
    input   logic       pgcb_reset_b,               //Same Asynchronous reset that feeds the PGCB
    output  logic       pgcb_reset_sync_b,          //pgcb_reset_b synced to clock
        
    input   logic       ns_on_syncon_ism,           //Indication that next-state is ON or SYNCON_ISM 
    input   logic       gclock_enable,              //clock-gate enable from FSM
    output  logic       gclock_enable_final,        //Final gclock_enable to clock-gate
    output  logic       gclock_enable_ack,          //gclock_enable_final synced back to long-clock

    //Test Controls
    input   logic       fscan_clkungate,            //Test clock ungating control
    input   logic [1:0] fscan_clkgenctrlen,         //Scan clock bypass enable
    input   logic [1:0] fscan_clkgenctrl,           //Scan clock bypass value
    input   logic       fscan_byprst_b,             //Scan reset bypass value
    input   logic       fscan_rstbypen              //Scan reset bypass enable
);
 
    localparam logic INIT_PWRON = DEF_PWRON ? 1'b1 : 1'b0;
    logic short_clock;
    
    //-- clock Buffers --//
if (PRESCC) begin : prescc_short_clk
        hqm_rcfwl_pgcb_ctech_clock_buf cts_CDC_ctech_short_clock_buf (
            .ck(prescc_clock),
            .o(short_clock)
          );
end else begin : noprescc_short_clk
        hqm_rcfwl_pgcb_ctech_clock_buf cts_CDC_ctech_short_clock_buf (
            .ck(clock),
            .o(short_clock)
          );
end


    /******************************************************************************************************************\
     *  
     *  PRESCC=1 (NOTE: FLOP_CG_EN and DSYNC_CG_EN are a don’t care when PRESCC=1)
     *  
     *  This is the clock gating behavior when the CDC is used preSCC.
     *  
    \******************************************************************************************************************/
if (PRESCC) begin : prescc_cg
    logic clkgen_gclock_enable;
    logic clkgen_pgcb_reset_b, pgcb_reset_shortsync_b;
    logic nc_fscan_clkungate, nc_ns_on_syncon_ism;

    //-- Reset Synchronizers --//
        //-- Long clock reset synchronizer (for functional logic) with scan mux --//
        hqm_rcfwl_pgcb_ctech_doublesync_rstmux u_pgcbRstMux(
            .clk(clock), 
            .clr_b(pgcb_reset_b), 
            .rst_bypass_b(fscan_byprst_b),
            .rst_bypass_sel(fscan_rstbypen), 
            .q(pgcb_reset_sync_b)
          );

        //-- Short clock reset synchronizer (for clock-gate logic) with clkgen mux --//
        hqm_rcfwl_pgcb_ctech_mux_2to1_gen u_pgcbRstCGenMux (
            .d1(fscan_clkgenctrl[0]),
            .d2(pgcb_reset_b),
            .s(fscan_clkgenctrlen[0]),
            .o(clkgen_pgcb_reset_b)
          );

        hqm_rcfwl_pgcb_ctech_doublesync u_pgcbRstShortSync (
            .d(1'b1), 
            .clr_b(clkgen_pgcb_reset_b), 
            .clk(short_clock), 
            .q(pgcb_reset_shortsync_b)
          );

    //-- clock Gate Logic--//
        //-- clock Gen mux and doublesync on clock-gate enable --//
        hqm_rcfwl_pgcb_ctech_mux_2to1_gen u_gClockCGenMux (
            .d1(fscan_clkgenctrl[1]),
            .d2(gclock_enable),
            .s(fscan_clkgenctrlen[1]),
            .o(clkgen_gclock_enable)
          );
        
        if (DEF_PWRON) begin: defon_ds
            // Preset gclock_enable_final
            hqm_rcfwl_pgcb_ctech_doublesync_lpst u_gclockEnSync (
                .d(clkgen_gclock_enable), 
                .pst_b(pgcb_reset_shortsync_b), 
                .clk(short_clock), 
                .q(gclock_enable_final)
              );

            // Preset gclock_enable_ack
            hqm_rcfwl_pgcb_ctech_doublesync_lpst u_gclockEnAckSync (
                .d(gclock_enable_final), 
                .pst_b(pgcb_reset_sync_b), 
                .clk(clock), 
                .q(gclock_enable_ack)
              );
        end else begin: defoff_ds
            // Reset gclock_enable_final
            hqm_rcfwl_pgcb_ctech_doublesync u_gclockSync (
                .d(clkgen_gclock_enable), 
                .clr_b(pgcb_reset_shortsync_b), 
                .clk(short_clock), 
                .q(gclock_enable_final)
              );

            // Reset gclock_enable_ack
            hqm_rcfwl_pgcb_ctech_doublesync u_gclockEnAckSync (
                .d(gclock_enable_final), 
                .clr_b(pgcb_reset_sync_b), 
                .clk(clock), 
                .q(gclock_enable_ack)
              );
        end

        //-- Final clock Gate --//
        //Note: for preSCC version, te is tied to 0 as SCAN has direct control of en
        hqm_rcfwl_pgcb_ctech_clock_gate u_gClockGate (
            .en(gclock_enable_final), 
            .te(1'b0), 
            .clk(short_clock), 
            .enclk(gclock)
          );
    
        assign nc_fscan_clkungate = fscan_clkungate;
        assign nc_ns_on_syncon_ism = ns_on_syncon_ism;
end else begin : postscc //PRESCC
    
    logic [1:0] nc_fscan_clkgenctrlen, nc_fscan_clkgenctrl;
    logic nc_prescc_clock;
    assign nc_fscan_clkgenctrlen = fscan_clkgenctrlen;
    assign nc_fscan_clkgenctrl = fscan_clkgenctrl;
    assign nc_prescc_clock = prescc_clock;
    
    /******************************************************************************************************************\
     *  
     *  PRESCC=0 && DSYNC_CG_EN=1 (NOTE: FLOP_CG_EN is a don't care when DSYNC_CG_EN=1)
     *  
     *  This clock gating logic is intended for postSCC fast clocks ( >120MHz ), it includes a doublesync on the
     *  gclock_enable to allow the for the clock gate to be placed on the short clock-tree without
     *  having to meet timing with respect to the functional logic on the long clock-tree.
     *  
    \******************************************************************************************************************/
  if (DSYNC_CG_EN) begin: dsync_cg
    logic pgcb_reset_shortsync_b;
    logic nc_ns_on_syncon_ism;

    //-- Reset Synchronizers --//
        //-- Long clock reset synchronizer (for functional logic) with scan mux --//
        hqm_rcfwl_pgcb_ctech_doublesync_rstmux u_pgcbRstMux(
            .clk(clock), 
            .clr_b(pgcb_reset_b), 
            .rst_bypass_b(fscan_byprst_b),
            .rst_bypass_sel(fscan_rstbypen), 
            .q(pgcb_reset_sync_b)
          );

        //-- Short clock reset synchronizer (for clock-gate logic) with scan mux --//
        hqm_rcfwl_pgcb_ctech_doublesync_rstmux u_pgcbRstShortMux(
            .clk(short_clock), 
            .clr_b(pgcb_reset_b), 
            .rst_bypass_b(fscan_byprst_b),
            .rst_bypass_sel(fscan_rstbypen), 
            .q(pgcb_reset_shortsync_b)
          );

    //-- clock Gate Logic--//
        //-- doublesync on clock-gate enable --//
        if (DEF_PWRON) begin: defon_ds
            // Preset gclock_enable_final
            hqm_rcfwl_pgcb_ctech_doublesync_lpst u_gclockSync (
                .d(gclock_enable), 
                .pst_b(pgcb_reset_shortsync_b), 
                .clk(short_clock), 
                .q(gclock_enable_final)
              );
            
            // Preset gclock_enable_ack
            hqm_rcfwl_pgcb_ctech_doublesync_lpst u_gclockEnAckSync (
                .d(gclock_enable_final), 
                .pst_b(pgcb_reset_sync_b), 
                .clk(clock), 
                .q(gclock_enable_ack)
              );
        end else begin: defoff_ds
            // Reset gclock_enable_final
            hqm_rcfwl_pgcb_ctech_doublesync u_gclockSync (
                .d(gclock_enable), 
                .clr_b(pgcb_reset_shortsync_b), 
                .clk(short_clock), 
                .q(gclock_enable_final)
              );
            
            // Reset gclock_enable_ack
            hqm_rcfwl_pgcb_ctech_doublesync u_gclockEnAckSync (
                .d(gclock_enable_final), 
                .clr_b(pgcb_reset_sync_b), 
                .clk(clock), 
                .q(gclock_enable_ack)
              );
        end

        //-- Final clock Gate --//
        hqm_rcfwl_pgcb_ctech_clock_gate u_gClockGate (
            .en(gclock_enable_final), 
            .te(fscan_clkungate), 
            .clk(short_clock), 
            .enclk(gclock)
          ); 


        assign nc_ns_on_syncon_ism = ns_on_syncon_ism;
  end else begin : nodsync_cg //DSYNC_CG_EN

    /******************************************************************************************************************\
     *  
     *  PRESCC=0 && DSYNC_CG_EN=0
     *
     *  This clock gating logic is intended for postSCC slow clocks ( <=120MHz ) and has the option
     *  (FLOP_CG_EN=0) of having a combi ungate path to allow for 1 clock shorter latency when the
     *  incoming clock is known to be running.
     *  Note: there is no short clock branch for this version.
     *  
    \******************************************************************************************************************/
    //-- Reset Synchronizers --//
        //-- Long clock reset synchronizer (for functional logic) with scan mux --//
        hqm_rcfwl_pgcb_ctech_doublesync_rstmux u_pgcbRstMux(
            .clk(clock), 
            .clr_b(pgcb_reset_b), 
            .rst_bypass_b(fscan_byprst_b),
            .rst_bypass_sel(fscan_rstbypen), 
            .q(pgcb_reset_sync_b)
          );

    //-- clock Gate Logic--//
        //If the FLOP_CG_EN parameter is not set, allow Clocks to ungate if the FSM is transitioning into a state where they will be ungated
        if (FLOP_CG_EN) begin : cg_en_flop
            assign gclock_enable_final = gclock_enable;
        end else begin : cg_en_combi
            always_comb begin
               if (gclock_enable==1) 
                   gclock_enable_final = 1;
               else if (ns_on_syncon_ism) 
                   gclock_enable_final = 1;
               else
                   gclock_enable_final = 0;
            end
        end

        assign gclock_enable_ack = gclock_enable;

        hqm_rcfwl_pgcb_ctech_clock_gate u_gClockGate (
            .en(gclock_enable_final), 
            .te(fscan_clkungate), 
            .clk(short_clock), 
            .enclk(gclock)
          ); 

    if (FLOP_CG_EN) begin : nc_ns
        logic nc_ns_on_syncon_ism;
        assign nc_ns_on_syncon_ism = ns_on_syncon_ism;
    end

  end //DSYNC_CG_EN

end //PRESCC
                                                    
    
endmodule
