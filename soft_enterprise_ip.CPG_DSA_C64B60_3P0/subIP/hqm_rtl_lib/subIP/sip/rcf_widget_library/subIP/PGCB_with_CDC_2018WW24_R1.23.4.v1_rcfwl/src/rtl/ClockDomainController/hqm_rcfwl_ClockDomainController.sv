//------------------------------------------------------------------------------
//
//  INTEL CONFIDENTIAL
//
//  Copyright 2012 Intel Corporation All Rights Reserved.
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
 * ClockDomainController
 * @author Jeff Wilcox
 * 
 * 
 *  Assumptions:
 *  - Once an clock is requested, the request will not go away until the domain is re-enabled
\**********************************************************************************************************************/

module hqm_rcfwl_ClockDomainController #(
    DEF_PWRON = 1,                                  //Default to a powered-on state after reset
    ITBITS = 16,                                    //Idle Timer Bits.  Max is 16
    RST = 1,                                        //Number of resets.  Min is one.
    AREQ = 1,                                       //Number of async gclock requests.  Min is one.
    DRIVE_POK = 1,                                  //Determines whether this domain must drive POK
    ISM_AGT_IS_NS = 0,                              //If 1, *_locked signals will be driven as the output of a flop
                                                    //If 0, *_locked signals will assert combinatorially
    RSTR_B4_FORCE = 0,                              //Determines if this CDC will require restore phase to complete
                                                    //in order to transition from IP-Accessible to IP-Inaccessible PG
    PRESCC = 0,                                     //If 1, The master_clock gate logic with have clkgenctrl muxes for scan to have control
                                                    //      of the master_clock branch in order to be used preSCC
                                                    //      NOTE: FLOP_CG_EN and DSYNC_CG_EN are a don’t care when PRESCC=1
    DSYNC_CG_EN = 0,                                //If 1, the master_clock-gate enable will be synchronized to the short master_clock-tree version
                                                    //      of master_clock to allow for STA convergence on fast clocks ( >120 MHz )
                                                    //      Note: FLOP_CG_EN is a don't care when DSYNC_CG_EN=1
    FLOP_CG_EN = 1,                                  //If 1, the clock-gate enable will be driven solely by the output of a flop
                                                    //If 0, there will be a combi path into the cg enable to allow for faster ungating
    CG_LOCK_ISM =0                                  //if set to 1, ism_locked
                                                    //signal is asserted
                                                    //whenever gclock_active is
                                                    //low
                                                     
)(
    //PGCB ClockDomain
    input   logic       pgcb_clk,                   //PGCB clock; always running
    input   logic       pgcb_rst_b,                 //Reset with de-assert synchronized to pgcb_clk
        
    //Master Clock Domain
    input   logic       clock,                      //Master clock
    input   logic       prescc_clock,               //pre-SCC version of Master clock (tie to 0 if PRESCC parameter is '0')
    input   logic [RST-1:0] reset_b,                //Asynchronous ungated reset.  reset_b[0] must be deepest reset for 
                                                    //the domain.
    output  logic [RST-1:0] reset_sync_b,           //Version of reset_b with de-assertion synchronized to clock
    output  logic       clkreq,                     //Async (glitch free) clock request to disable
    input   logic       clkack,                     //Async (glitch free) clock request acknowledge
    input   logic       pok_reset_b,                //Asynchronous reset for POK
    output  logic       pok,                        //Power ok indication, synchronous
    
    output  logic       gclock_enable_final,        //Final enable signal to clock-gate
        
    //Gated Clock Domain
    output  logic       gclock,                     //Gated version of the clock
    output  logic [RST-1:0] greset_b,               //Gated version of reset_sync_b
    input   logic       gclock_req_sync,            //Synchronous gclock request.  
    input   logic [AREQ-1:0] gclock_req_async,      //Async (glitch free) gclock requests
    output  logic [AREQ-1:0] gclock_ack_async,      //Clock req ack for each gclock_req_async in this CDC's domain.
    output  logic       gclock_active,              //Indication that gclock is running.
    input   logic [2:0] ism_fabric,                 //IOSF Fabric ISM.  Tie to zero for non-IOSF domains. 
    input   logic [2:0] ism_agent,                  //IOSF Agent ISM.  Tie to zero for non-IOSF domains. 
    output  logic       ism_locked,                 //Indicates that the ISMs for this domain should be locked  
    output  logic       boundary_locked,            //Indicates that all non IOSF accesses should be locked out 
    
    //Configuration - Quasi-static
    input   logic       cfg_clkgate_disabled,       //Don't allow idle-based clock gating
    input   logic       cfg_clkreq_ctl_disabled,    //Don't allow de-assertion of clkreq when idle
    input   logic [3:0] cfg_clkgate_holdoff,        //Min time from idle to clock gating; 2^value in clocks
    input   logic [3:0] cfg_pwrgate_holdoff,        //Min time from clock gate to power gate ready; 2^value in clocks
    input   logic [3:0] cfg_clkreq_off_holdoff,     //Min time from locking to !clkreq; 2^value in clocks
    input   logic [3:0] cfg_clkreq_syncoff_holdoff, //Min time from ck gate to !clkreq (powerGateDisabled)
    
    //CDC Aggregateion and Control (synchronous to pgcb_clk domain)
    input   logic       pwrgate_disabled,           //Don't allow idle-based clock gating; PGCB clock
    input   logic       pwrgate_force,              //Force the controller to gate clocks and lock up 
    input   logic       pwrgate_pmc_wake,           //PMC wake signal (after sync); PGCB clock domain
    output  logic       pwrgate_ready,              //Allow power gating in the PGCB clock domain.  Can de-assert
                                                    //even if never power gated if new wake event occurs.    
    
    //PGCB Controls (synchronous to pgcb_clk domain)
    input   logic       pgcb_force_rst_b,           //Force for resets to assert
    input   logic       pgcb_pok,                   //Power OK signal in the PGCB clock domain
    input   logic       pgcb_restore,               //A restore is in pregress so  ISMs should unlock
    input   logic       pgcb_pwrgate_active,        //Pwr gating in progress, so keep boundary locked

    //Test Controls
    input   logic       fscan_clkungate,            //Test clock ungating control
    input   logic       fismdfx_force_clkreq,       //DFx force assert clkreq
    input   logic       fismdfx_clkgate_ovrd,       //DFx force GATE gclock
    input   logic [RST+DRIVE_POK:0] fscan_byprst_b, //Scan reset bypass value
    input   logic [RST+DRIVE_POK:0] fscan_rstbypen, //Scan reset bypass enable
    input   logic [1:0] fscan_clkgenctrlen,         //Scan clock bypass enable
    input   logic [1:0] fscan_clkgenctrl,           //Scan clock bypass value
      
    //CDC VISA Signals
    output  logic [23:0] cdc_visa                   // Set of internal signals for VISA visibility
);    
        
    localparam CLKACK_NEG_WAIT_DIS = 0;              //HSD 1504110638
                                                    //If 0, in OFF_PENDING state, CDC will wait until clkack is negated.  
                                                    //      Must be 0 if PGCB clk freq is faster than main 
                                                    //If 1, will revert back to old behavior.
    localparam GCLKREQ_ASYNC_OR_NS = 0;              //HSD 1604083741
                                                    //If 0, will use flopped version for gclock_req_async* ORed output from PGCB domain.
                                                    //If 1, will use unfloopwd output of gclock_req_async* ORed output (old behavior) for performance.
    logic   unlock_all_pg, ism_wake, assert_clkreq_pg, clkreq_hold, domain_locked, force_ready, ism_locked_f;
    logic [13:0] cdc_main_visa;
    logic [5:0]  cdc_pg_visa;
    logic pwrgate_active_pg, cdc_restore_pg, force_pgate_req_pg;
    logic force_pgate_req_not_pg_active_pg;  // HSD1207621082

     
    logic   gclock_req_sync_pg;         //PGCB synched gclock_req_sync
    //logic   gclock_req_async_pg;        //PGCB synched gclock_req_async bits ORed
    logic   gclock_req_async_or_pg;     //PGCB synched gclock_req_async bits ORed (and Flopped if not disabled with param) in PGCB domain
    logic   ism_locked_pg;              //ism_locked_pg to the main clock domain to avoid meta-stability race issue

    logic   clkreq_start_hold;          //The main clock domain control is entering OFF_PENDING state, clkack negation is expected and clkreq req should not assert. //HSD1504110638
    logic   clkreq_start_hold_ack_pg;   //The pgcb domain indication that it has received clkreq_start_hold.  main S/M can now negate clkreq_hold. //HSD1504110638
     


    hqm_rcfwl_CdcMainClock #(
      .DEF_PWRON(DEF_PWRON),
      .ITBITS(ITBITS), 
      .RST(RST),
      .DRIVE_POK(DRIVE_POK),
      .AREQ(AREQ),
      .ISM_AGT_IS_NS(ISM_AGT_IS_NS),
      .PRESCC(PRESCC),
      .DSYNC_CG_EN(DSYNC_CG_EN),
      .FLOP_CG_EN(FLOP_CG_EN),
      .CG_LOCK_ISM(CG_LOCK_ISM),
      .CLKACK_NEG_WAIT_DIS(CLKACK_NEG_WAIT_DIS)
    ) u_CdcMainClock (
      // Inputs
      .cfg_clkgate_disabled(cfg_clkgate_disabled),
      .cfg_clkreq_ctl_disabled(cfg_clkreq_ctl_disabled),
      .cfg_clkgate_holdoff(cfg_clkgate_holdoff),
      .cfg_pwrgate_holdoff(cfg_pwrgate_holdoff),
      .cfg_clkreq_off_holdoff(cfg_clkreq_off_holdoff),
      .cfg_clkreq_syncoff_holdoff(cfg_clkreq_syncoff_holdoff),
      .clock(clock),
      .prescc_clock(prescc_clock),
      .reset_b(reset_b),
      .pgcb_reset_b(pgcb_rst_b),
      .clkack(clkack),
      .pok_reset_b(pok_reset_b),
      .gclock_req_sync(gclock_req_sync),
      .gclock_req_async(gclock_req_async),
      .ism_fabric(ism_fabric),
      .ism_agent(ism_agent),
      .unlock_domain_pg(unlock_all_pg),
      .assert_clkreq_pg(assert_clkreq_pg),
      .pgcb_force_rst_b(pgcb_force_rst_b),
      .pwrgate_disabled(pwrgate_disabled),
      .pgcb_pok(pgcb_pok),
      .fscan_clkungate(fscan_clkungate),
      .fscan_byprst_b(fscan_byprst_b),
      .fscan_rstbypen(fscan_rstbypen),
      // Outputs
      .reset_sync_b(reset_sync_b),
      .pok(pok),
      .gclock(gclock),
      .greset_b(greset_b),
      .gclock_ack_async(gclock_ack_async),
      .gclock_active(gclock_active),
      .domain_locked(domain_locked),
      .force_ready(force_ready),
      .ism_locked(ism_locked),
      .boundary_locked(boundary_locked),
      .clkreq_hold(clkreq_hold),
      .ism_wake(ism_wake),
      .*
    );
    

    hqm_rcfwl_CdcPgClock #(
      .AREQ(AREQ),
      .DEF_PWRON(DEF_PWRON),
      .DRIVE_POK(DRIVE_POK),
      .RSTR_B4_FORCE(RSTR_B4_FORCE),
      .CLKACK_NEG_WAIT_DIS(CLKACK_NEG_WAIT_DIS),
      .GCLKREQ_ASYNC_OR_NS(GCLKREQ_ASYNC_OR_NS)
    ) u_CdcPgcbClock(
      // Inputs
      .pgcb_clk(pgcb_clk),
      .pgcb_reset_b(pgcb_rst_b),
      .domain_locked(domain_locked),
      .force_ready(force_ready),
      .clkreq_hold(clkreq_hold),
      .ism_wake(ism_wake),
      .domain_pok(pok),
      .gclock_req_sync(gclock_req_sync),
      .gclock_req_async(gclock_req_async),
      .pwrgate_disabled(pwrgate_disabled),
      .pwrgate_force(pwrgate_force),
      .pwrgate_pmc_wake(pwrgate_pmc_wake),
      .pgcb_force_rst_b(pgcb_force_rst_b),
      .pgcb_pwrgate_active(pgcb_pwrgate_active),
      .pgcb_pok(pgcb_pok),
      .fismdfx_force_clkreq(fismdfx_force_clkreq),
      // Outputs
      .clkreq(clkreq),
      .unlock_domain_pg(unlock_all_pg),
      .assert_clkreq_pg(assert_clkreq_pg),
      .pwrgate_ready(pwrgate_ready),
      .*
    );
                    
    always_comb begin
        cdc_visa = '0; //Tie unused bits to 0

        cdc_visa[19:14]   = cdc_pg_visa;
        cdc_visa[13:0]    = cdc_main_visa;
    end
                     
`ifndef INTEL_SVA_OFF
 `ifdef INTEL_SIMONLY
        `include "ClockDomainController.sva"
    `endif
`endif
endmodule
