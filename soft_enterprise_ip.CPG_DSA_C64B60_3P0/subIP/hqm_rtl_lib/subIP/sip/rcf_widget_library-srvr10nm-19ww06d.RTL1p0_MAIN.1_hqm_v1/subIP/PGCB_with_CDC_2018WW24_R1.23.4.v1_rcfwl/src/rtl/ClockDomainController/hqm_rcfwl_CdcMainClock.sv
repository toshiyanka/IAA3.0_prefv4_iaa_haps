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
 * @author Jeff Wilcox
 * 
 * 
\**********************************************************************************************************************/

module hqm_rcfwl_CdcMainClock #(
    DEF_PWRON = 1,                                  //Default to a powered-on state after reset
    ITBITS = 16,                                    //Idle Timer Bits.  Max is 16
    RST = 1,                                        //Number of resets.  Min is one.
    AREQ = 1,                                       //Number of async gclock requests.  Min is one.
    DRIVE_POK = 1,                                  //Determines whether this domain must drive POK
    CLKACK_NEG_WAIT_DIS = 0,                        //HSD 1504110638
                                                    //If 0, in OFF_PENDING state, CDC will wait until clkack is negated.
                                                    //      Must be 0 if PGCB clk freq is faster than main
                                                    //If 1, will revert back to old behavior.
    ISM_AGT_IS_NS = 0,                              //If 1, *_locked signals will be driven as the output of a flop
                                                    //If 0, *_locked signals will assert combinatorially
    PRESCC = 0,                                     //If 1, The clock gate logic with have clkgenctrl muxes for scan to have control
                                                    //      of the clock branch in order to be used preSCC
                                                    //      NOTE: FLOP_CG_EN and DSYNC_CG_EN are a don’t care when PRESCC=1
    DSYNC_CG_EN = 0,                                //If 1, the clock-gate enable will be synchronized to the short clock-tree version
                                                    //      of clock to allow for STA convergence on fast clocks ( >120 MHz )
                                                    //      Note: FLOP_CG_EN is a don't care when DSYNC_CG_EN=1
    FLOP_CG_EN = 1,                                  //If 1, the clock-gate enable will be driven solely by the output of a flop
                                                     //If 0, there will be a combi path into the cg enable to allow for faster ungating
    CG_LOCK_ISM =0                                  //if set to 1, ism_locked
                                                    //signal is asserted
                                                    //whenever gclock_active is
                                                    //low

)(
    //Configuration - Quasi static
    input   logic       cfg_clkgate_disabled,       //Don't allow idle-based clock gating
    input   logic       cfg_clkreq_ctl_disabled,    //Don't allow de-assertion of clkreq when idle
    input   logic [3:0] cfg_clkgate_holdoff,        //Min time from idle to clock gating; 2^value in clocks
    input   logic [3:0] cfg_pwrgate_holdoff,        //Min time from clock gate to power gate; 2^value in clocks
    input   logic [3:0] cfg_clkreq_off_holdoff,     //Min time from locking to !clkreq; 2^value in clocks
    input   logic [3:0] cfg_clkreq_syncoff_holdoff, //Min time from ck gate to !clkreq (powerGateDisabled)
    
    //Master Clock Domain
    input   logic       clock,                      //clock
    input   logic       prescc_clock,               //pre-SCC version of Master clock (tie to 0 if PRESCC parameter is '0')
    input   logic [RST-1:0] reset_b,                //Asynchronous ungated reset.  reset_b[0] must be deepest reset for 
                                                    //the domain.
    input   logic       pgcb_reset_b,               //Same Asynchronous reset that feeds the PGCB
    output  logic [RST-1:0] reset_sync_b,           //Version of reset_b with de-assertion synchronized to clock
    input   logic       clkack,                     //Async (glitch free) clock request acknowledge
    input   logic       pok_reset_b,                //Asynchronous reset for POK
    output  logic       pok,                        //Power ok indication, synchronous

    output  logic       gclock_enable_final,        //Final enable signal to clock-gate
    
    //Gated gClock Domain
    output  logic       gclock,                     //Gated version of the clock
    output  logic [RST-1:0] greset_b,               //Gated version of reset_sync_b
    input   logic       gclock_req_sync,            //Synchronous gclock request.
    input   logic [AREQ-1:0]gclock_req_async,       //Async (glitch free) gclock requests
    output  logic [AREQ-1:0]gclock_ack_async,       //Clock req ack for each gclock_req_async in this CDC's domain.
    output  logic       gclock_active,              //Indication that gclock is running.
    input   logic [2:0] ism_fabric,                 //IOSF Fabric ISM.  Tie to zero for non-IOSF domains. 
    input   logic [2:0] ism_agent,                  //IOSF Agent ISM.  Tie to zero for non-IOSF domains. 
    input   logic       ism_locked_pg,              //PGCB domain captured ism_locked_f
    output  logic       ism_locked,                 //Indicates that the ISMs for this domain should be locked  
    output  logic       ism_locked_f,               //Indicates that the ISMs for this domain should be locked (flop version)
    output  logic       boundary_locked,            //Indicates that all non IOSF accesses should be locked out 

    //CdcPgClock Domain Control Interface
    output  logic       clkreq_start_hold,          //The main clock domain control is entering OFF_PENDING state, clkack negation is expected and clkreq req should not assert. //HSD1504110638
    input   logic       clkreq_start_hold_ack_pg,   //The pgcb domain indication that it has received clkreq_start_hold.  main S/M can now negate clkreq_hold. //HSD1504110638
    output  logic       domain_locked,              //This domain is locked; this clock domain
    output  logic       force_ready,                //Domain is ready to be forced into power gating
    input   logic       unlock_domain_pg,           //Unlock all (boundary and ISM); pgcb_clk domain
    input   logic       assert_clkreq_pg,           //Assert CLKREQ; pgcb_clk domain
    output  logic       clkreq_hold,                //Clock req is being held high; main clock domain
    output  logic       ism_wake,                   //Wake event due to fabric ISM leaving idle; this clock domain
    input   logic       pwrgate_active_pg,          //Glitch-free pwrgate_active in PGCB clock domain
    input   logic       gclock_req_sync_pg,         //PGCB synched gclock_req_sync              #HSD1504001217 
    input   logic       gclock_req_async_or_pg,     //PGCB synched gclock_req_async bits ORed   #HSD1504001217

    
    //PGCB Interface          
    input   logic       pgcb_force_rst_b,           //Force for resets to assert; pgcb_clk domain
    input   logic       force_pgate_req_pg,         //Force the controller to gate clocks and lock up; pgcb_clk domain   
    input   logic       force_pgate_req_not_pg_active_pg,//HSD1207621082: Force the controller to gate clocks and lock up; pgcb_clk domain  
    input   logic       pwrgate_disabled,           //Don't allow idle-based clock gating; pgcb_clk domain
    input   logic       cdc_restore_pg,             //A restore is in pregress so ISMs should unlock; pgcb_clk
    input   logic       pgcb_pok,                   //Power OK signal in the pgcb_clk domain
    
    //Test Controls
    input   logic       fscan_clkungate,            //Test clock ungating control
    input   logic       fismdfx_clkgate_ovrd,       //DFx force GATE gclock
    input   logic       fismdfx_force_clkreq,       //DFx force assert clkreq
    input   logic [RST+DRIVE_POK:0] fscan_byprst_b, //Scan reset bypass value
    input   logic [RST+DRIVE_POK:0] fscan_rstbypen, //Scan reset bypass enable
    input   logic [1:0] fscan_clkgenctrlen,         //Scan clock bypass enable
    input   logic [1:0] fscan_clkgenctrl,           //Scan clock bypass value
    
    //CDC Main Clock VISA Signals
    output logic [13:0] cdc_main_visa               // Set of internal signals for VISA visibility
);
    logic unlock_all, unlock_ism, pg_disabled, timer_expired, force_pgate_req, do_force_pgate;
    logic force_pgate_req_not_pg_active;   //HSD1207621082
    logic pgcb_reset_sync_b, gclock_req, do_syncoff, do_pgate_lock, do_clkreq_off, cdcpg_driving_clkreq, clkack_sync;
    logic cfg_update, cfg_update_q, cfg_update_toggle;
    logic gclock_req_async_sync, gclock_req_ism;
    logic unlock_all_pok, unlock_ism_pok; 
    logic ism_locked_c;
    logic boundary_locked_f, boundary_locked_c;
    logic clkreq_disabled, clkgate_disabled, clkgate_disabled_sync;
    logic last_pg_disabled;
    logic fismdfx_clkgate_ovrd_sync, fismdfx_force_clkreq_sync;
    logic pwrgate_active;
    logic pok_preout;
    logic clkreqack_equal1;
    logic ns_on_syncon_ism;
    logic gclock_enable_next, gclock_enable, gclock_enable_ack;
    logic gclock_enable_block;
    logic gclock_active_next;
    logic ism_locked_cg;  
    logic ism_locked_pg_main; 
    logic [AREQ-1:0] gclock_req_async_sync_bits;
    logic syncon_ism;
    logic gclock_req_sync_pg_main;
    logic gclock_req_async_pg_main;
    logic syncon_ism_next;
    logic clkreq_start_hold_ack_syncmain;
    logic clkreq_start_hold_ack_main_dis;

    // Logic for locking ISM when clock is gated
    if (CG_LOCK_ISM) begin: ism_lock_cg
      //HSD 1404136840 - when ISM_AGT_IS_NS  
      if (ISM_AGT_IS_NS==1) begin: cg_lock_sim_agt_is_ns
       assign ism_locked_cg = (!gclock_active) & !syncon_ism;
      end else begin: no_cg_lock_sim_agt_is_ns
       assign ism_locked_cg = (!gclock_active_next) & !syncon_ism_next;
      end
    end else begin: no_ism_lock_cg
       assign ism_locked_cg = 1'b0;
       
       logic nc_syncon_ism;
       assign nc_syncon_ism = syncon_ism;
    end

    // The ISMs should only unlock if pok is high
    assign unlock_all_pok = unlock_all && (pok_preout);
    assign unlock_ism_pok = unlock_ism && (pok_preout);

    localparam logic INIT_PWRON = DEF_PWRON ? 1'b1 : 1'b0;
    
    /******************************************************************************************************************\
     *  
     *  CDC State Machine
     *  
    \******************************************************************************************************************/
    
    typedef enum logic [3:0] { 
        CDC_OFF             = 4'h0,     //Locked, Clkreq deasserted, gClock gated
        CDC_OFF_PENDING     = 4'h1,     //Locked, Clkreq deasserted, gClock gated; clkack still asserted,
        //CDC_ON_PENDING      = 4'h2,     //Unlocked, Clkreq asserted, gClock gated; clkack still de-asserted,
        CDC_ON              = 4'h3,     //Unlocked, Clkreq asserted, gClock ungated
        CDC_CGATE_PENDING   = 4'h4,     //Unlocked, Clkreq asserted, gClock ungated, gclock active and acks de-assert
        CDC_CGATE           = 4'h5,     //Unlocked, Clkreq asserted, gClock gated
        CDC_PGATE_PENDING   = 4'h6,     //Unlocked, Clkreq asserted, gClock gated; wait for last unlock to clear
        CDC_PGATE           = 4'h7,     //Locked, Clkreq asserted, gClock gated; power gate is allowed
        CDC_RESTORE         = 4'h8,     //ISM unlocked, Boundary locked, Clkreq asserted, gClock ungated
        CDC_SYNCOFF_PENDING = 4'h9,     //Unlocked, Clkreq deasserted, gClock gated; clkack still asserted
        CDC_SYNCOFF         = 4'hA,     //Unlocked, Clkreq deasserted, gClock gated; sync wake event detection
        CDC_SYNCON_ISM      = 4'hB,     //Unlocked, Clkreq asserted, gClock ungated; gclock_active=0
        CDC_FORCE_PENDING   = 4'hC,     //Locked, Clkreq asserted, gClock gated; clkack still de-asserted,
        CDC_FORCE_READY     = 4'hD,     //Locked, Clkreq asserted, gClock gated;
        CDC_ERROR           = 'X        //Bad state
    } CdcState_t;
    
    CdcState_t current_state, next_state;
    
    always_comb begin
        next_state = current_state;
        case(current_state)
            CDC_OFF             :   if (clkreqack_equal1) begin
                                        if (unlock_all_pok)                            next_state = CDC_ON;
                                        else if (unlock_ism_pok)                       next_state = CDC_RESTORE;
                                        //else if (force_pgate_req)                      next_state = CDC_FORCE_PENDING;
                                        else if (force_pgate_req_not_pg_active)       next_state = CDC_FORCE_PENDING;  //HSD1207621082
                                    end

            //CDC_ON_PENDING      :   if (clkack_sync)                                   next_state = CDC_ON;

            CDC_ON              :   if (do_force_pgate)                                next_state = CDC_CGATE_PENDING;
                                    else if (timer_expired & ~cfg_update)              next_state = CDC_CGATE_PENDING;

            CDC_CGATE_PENDING   :   if ((gclock_req | cfg_update) && !do_force_pgate)  next_state = CDC_ON;     
                                    else if (timer_expired & !gclock_enable_block)     next_state = CDC_CGATE;

            CDC_CGATE           :   if (do_force_pgate & !unlock_ism_pok)              next_state = CDC_PGATE_PENDING; //HSD1207621082
                                    else if (gclock_req | cfg_update) begin
                                       if (!gclock_enable_block)                       next_state = CDC_ON;
                                    end
                                    else if (do_syncoff)                               next_state = CDC_SYNCOFF_PENDING;
                                    else if (do_pgate_lock & !unlock_ism_pok)          next_state = CDC_PGATE_PENDING; //HSD1207621082

            CDC_SYNCOFF_PENDING :   if (!clkack_sync & !gclock_enable_block)           next_state = CDC_SYNCOFF;

            CDC_SYNCOFF         :   if (do_force_pgate) begin
                                       if (clkreqack_equal1)                           next_state = CDC_ON;
                                    end 
                                    else if (gclock_req_ism)                           next_state = CDC_SYNCON_ISM;
                                    else if (gclock_req & clkreqack_equal1)            next_state = CDC_ON;
                                    else if (~pg_disabled & clkreqack_equal1)          next_state = CDC_ON;

            CDC_SYNCON_ISM      :   if (clkreqack_equal1 & !gclock_enable_block)       next_state = CDC_ON;

            CDC_PGATE_PENDING   :   if ((!unlock_all_pok & !unlock_ism_pok) &
                                        ism_locked_pg_main &			       //Wait for ism_locked_f is captured in PGCB domain logic //HSD1504001217
                                        !gclock_enable_block)                          next_state = CDC_PGATE;

            CDC_PGATE           :   if (do_force_pgate & !pwrgate_active)              next_state = CDC_FORCE_READY;
                                    else if (unlock_all_pok)                           next_state = CDC_ON;
                                    else if (unlock_ism_pok)                           next_state = CDC_RESTORE;
                                    else if (do_clkreq_off & !force_pgate_req)         next_state = CDC_OFF_PENDING;

            CDC_RESTORE         :   if (!unlock_ism & unlock_all & clkreqack_equal1)   next_state = CDC_ON;

            CDC_OFF_PENDING     :   if (!clkack_sync & !gclock_enable_block)           next_state = CDC_OFF;

            CDC_FORCE_PENDING   :   if (clkack_sync & !pwrgate_active)                 next_state = CDC_FORCE_READY;

            CDC_FORCE_READY     :   if (!force_pgate_req & !pok & pwrgate_active &
                                        !gclock_enable_block)                          next_state = CDC_OFF_PENDING;
                                    else if (unlock_all_pok)                           next_state = CDC_ON;
                                    else if (unlock_ism_pok)                           next_state = CDC_RESTORE;

            default                                                                    next_state = CDC_ERROR;
        endcase
    end
    
    localparam CdcState_t CDC_INITIAL = DEF_PWRON ? CDC_RESTORE : CDC_OFF;
    
    always_ff @(posedge clock, negedge pgcb_reset_sync_b) begin
        if (!pgcb_reset_sync_b) begin
            current_state   <= CDC_INITIAL;
            syncon_ism      <= '0;
        end
        else begin
            current_state   <= next_state;
            syncon_ism      <= syncon_ism_next;
        end
    end
    
    assign syncon_ism_next  = next_state==CDC_SYNCON_ISM;

    //Force power gate can proceed as long as the ISMs are idle
    assign do_force_pgate   = force_pgate_req & ( (ism_agent == 3'b000) || ism_locked_f );
    assign do_syncoff       = (current_state == CDC_CGATE) & timer_expired &  pg_disabled & ~clkreq_disabled & ~cfg_update;     
    assign do_pgate_lock    = (current_state == CDC_CGATE) & timer_expired & ~pg_disabled & ~cfg_update;   
    assign do_clkreq_off    = (current_state == CDC_PGATE) & timer_expired & ~clkreq_disabled;
    assign clkreqack_equal1 = clkreq_hold && clkack_sync;

    //If any of the *disables toggle, trigger a return to ON from CGATE_PENDING or CGATE
    //This would reset hysteresis timers to new values, allowing updated latencies to take effect
    logic clkgate_disabled_q, clkreq_disabled_q;

    always_ff @(posedge clock, negedge pgcb_reset_sync_b) begin
        if (!pgcb_reset_sync_b) begin
            clkgate_disabled_q  <= '1;
            clkreq_disabled_q   <= '1;
            cfg_update_q        <= '0;
        end else begin
            clkgate_disabled_q  <= clkgate_disabled_sync;
            clkreq_disabled_q   <= clkreq_disabled;
            cfg_update_q        <= cfg_update;
        end
    end  

    assign cfg_update_toggle = (clkgate_disabled_q ^ clkgate_disabled_sync) | 
                               (clkreq_disabled_q ^ clkreq_disabled) |
                               (last_pg_disabled ^ pg_disabled);
                        
    // Need to extend cfg_update in order to not miss the pulse if waiting for gclock_enable_ack to
    // toggle before switching states.
    // Flag will be SET on cfg_update assertion in CGATE_PENDING or CGATE
    // Flag will be cleared upon entering ON state
    always_comb begin
        cfg_update = cfg_update_q;
        
        if (current_state==CDC_ON)
            cfg_update = 1'b0;
        else if (cfg_update_toggle && ((current_state==CDC_CGATE_PENDING) || (current_state==CDC_CGATE)) )
            cfg_update = 1'b1;
    end

    /******************************************************************************************************************\
     *  
     *  Gated Clock Domain Requests & Controls
     *  
    \******************************************************************************************************************/
   
    assign gclock_req           = (gclock_req_sync | gclock_req_async_sync | gclock_req_ism | (ism_agent!='0) | fismdfx_force_clkreq_sync |
                                   gclock_req_sync_pg_main | gclock_req_async_pg_main); //HSD:1503996414 

    assign gclock_req_ism       = (ism_fabric != 3'b000);

    // gclock_enable_block will be set whenever there is a change in gclock_enable, and will be
    // cleared only when gclock_enable_ack has changed to the same value.  This flag is then used
    // to prevent gclock_enable from changing again such that a value would be be missed, and to
    // block certain arcs in the FSM that will lead to a change in gclock_enable
    assign gclock_enable_block = gclock_enable ^ gclock_enable_ack;

    // change to gclock_enable_next (HSD 1275328??) 
    //        --- added qualifier relevant to powered-ON state 
    //        --- if gclock_enable is asserted in reset (only possible case of gclock_enable 
    //            being asserted while not in ON, SYNCON_ISM, RESTORE, CGATE_* states below),
    //        --- then keep it asserted out of reset even in ON_PENDING state. 
    // similar change to gclock_active_next 
    //        --- CDC_ON_PENDING state added in equation

    // If clkgate_ovrd is asserted, the clock is UNGATED
    // For IP-Inaccessible entry, run clocks until pwrgate_active asserts
    // If gclock_enable has toggled, do not let it change until the gclock_enable_ack
    // has also changed
    assign gclock_enable_next   = fismdfx_clkgate_ovrd_sync ||
                                  (
                                    gclock_enable_block ? gclock_enable : 
                                      (
                                        (next_state == CDC_ON) |
                                        (next_state == CDC_SYNCON_ISM) |
                                        ((next_state == CDC_RESTORE) & (clkreqack_equal1 | gclock_enable)) |
                                        (next_state == CDC_CGATE_PENDING) |
                                        ((next_state == CDC_CGATE) & (clkgate_disabled | do_force_pgate)) |
                                        ((next_state == CDC_SYNCOFF_PENDING) & clkgate_disabled) |
                                        ((next_state == CDC_SYNCOFF) & clkgate_disabled) |
                                        (force_pgate_req & ~pwrgate_active &
                                            (
                                                (next_state == CDC_PGATE_PENDING) |
                                                (next_state == CDC_PGATE)
                                            )
                                        ) |
                                        (clkreqack_equal1 &
                                            (
                                                (next_state == CDC_FORCE_PENDING) |
                                                (next_state == CDC_FORCE_READY)
                                            )
                                        )
                                      )
                                  );

    // Because gclock_enable can only change when gclock_enable_ack is equal to the current value of
    // gclock_enable, looking at enable and enable_ack together should be sufficient for all cases
    //
    // drops in CGATE_PENDING state (for IP-Accessible) such that clocks continue to run for at
    // least 8 more clocks
    //
    // Is asserted only in RESTORE and ON for IP-Accessible
    //
    // Is asserted in any PG-entry state that the clock is valid for IP-Inaccessible
    //
    assign gclock_active_next   = (gclock_enable && gclock_enable_next && gclock_enable_ack) &&
                                  (clkreqack_equal1) &&
                                  // gclock_active should drop in CGATE_PENDING
                                  (
                                    (next_state == CDC_RESTORE) ||
                                    (next_state == CDC_ON) ||
                                    (force_pgate_req &&
                                      (
                                        (next_state == CDC_CGATE_PENDING) || 
                                        (next_state == CDC_CGATE) || 
                                        (next_state == CDC_PGATE_PENDING) || 
                                        (next_state == CDC_PGATE) || 
                                        (next_state == CDC_FORCE_READY) || 
                                        (next_state == CDC_FORCE_PENDING) 
                                      )
                                    )
                                  );
                             
    always_ff @(posedge clock, negedge pgcb_reset_sync_b) begin
        if (!pgcb_reset_sync_b) begin
            gclock_enable   <= INIT_PWRON;
            gclock_active   <= '0;
            gclock_ack_async<= '0;
        end
        else begin
            gclock_enable   <=  gclock_enable_next;
            gclock_active   <=  gclock_active_next;
            gclock_ack_async<=  gclock_active_next ? gclock_req_async_sync_bits : '0;
        end
    end
  
    assign ns_on_syncon_ism = (next_state == CDC_ON) || (next_state == CDC_SYNCON_ISM);
 
    hqm_rcfwl_CdcMainCg #(
        .DEF_PWRON(DEF_PWRON),
        .PRESCC(PRESCC),
        .DSYNC_CG_EN(DSYNC_CG_EN),
        .FLOP_CG_EN(FLOP_CG_EN)
      ) u_CdcMainCg (
        .clock(clock),
        .prescc_clock(prescc_clock),
        .gclock(gclock),
        .pgcb_reset_b(pgcb_reset_b),
        .pgcb_reset_sync_b(pgcb_reset_sync_b),
        .ns_on_syncon_ism(ns_on_syncon_ism),
        .gclock_enable(gclock_enable),
        .gclock_enable_final(gclock_enable_final),
        .fscan_clkungate(fscan_clkungate),
        .fscan_clkgenctrlen(fscan_clkgenctrlen),
        .fscan_clkgenctrl(fscan_clkgenctrl),
        .fscan_byprst_b(fscan_byprst_b[RST+DRIVE_POK]),
        .fscan_rstbypen(fscan_rstbypen[RST+DRIVE_POK]),
        .*
      );
                                                    
    for (genvar a = 0; a < AREQ; a++) begin : AsyncReqXC
        hqm_rcfwl_pgcb_ctech_doublesync #(.PULSE_WIDTH_CHECK(0))
                                 u_gClockReqAsyncSync(.d(gclock_req_async[a]), .clr_b(pgcb_reset_sync_b), .clk(clock),
                                                      .q(gclock_req_async_sync_bits[a]));
    end
    
    assign gclock_req_async_sync = |gclock_req_async_sync_bits;

    // HSD#2245023 - Fix to avoid boundary condition of clkgate_disabled from changing during flows
    // Retain the value of clkgate_disabled that was programmed in the CDC_ON state
    always_ff @(posedge clock, negedge pgcb_reset_sync_b) begin
      if (!pgcb_reset_sync_b) begin
        clkgate_disabled <= 0;
      end else begin
        clkgate_disabled <= (next_state==CDC_ON) ? clkgate_disabled_sync : clkgate_disabled;
      end
    end
                                                   
    /******************************************************************************************************************\
     *  
     *  Main CLKREQ/CLKACK Controls
     *  
    \******************************************************************************************************************/
    
    //clkreq_hold is only allowed to assert when the clkreq from the pgcb side has been sampled asserted.  It can only
    //de-assert when the assert condition from the pgcb side has de-asserted.  
    always_ff @(posedge clock, negedge pgcb_reset_sync_b) begin
        if (~pgcb_reset_sync_b) begin
            clkreq_hold     <= INIT_PWRON;
        end
        else begin
            //If pgcb_clk side is asserting, this side should assert and hold            
            if (cdcpg_driving_clkreq) begin
                clkreq_hold     <= '1;
            end
            //CdcPg side has dropped its clkreq so no we hold as long as necessary for both clkreq/ack protocol and
            //functional requirements
            else if (clkreq_hold && clkack_sync) begin
                //If held and clkack is asserted, then the hold can drop when heading into OFF or SYNCOFF states
              //if(CLKACK_NEG_WAIT_DIS) begin
              //  if ( (next_state == CDC_OFF) || (next_state == CDC_OFF_PENDING)|| 
              //       (next_state == CDC_SYNCOFF) || (next_state == CDC_SYNCOFF_PENDING)) begin
              //      clkreq_hold     <= '0;
              //  end
              //end
              //else begin //HSD1504110638 
                if ( (next_state == CDC_OFF) || 
                     ((current_state == CDC_OFF_PENDING)     & (clkreq_start_hold_ack_syncmain | clkreq_start_hold_ack_main_dis) ) ||  
                     (next_state == CDC_SYNCOFF) || 
                     ((current_state == CDC_SYNCOFF_PENDING) & (clkreq_start_hold_ack_syncmain | clkreq_start_hold_ack_main_dis) ) ) begin 
                    clkreq_hold     <= '0;
                end
              //end
            end
        end
    end

    always_comb begin
        if(CLKACK_NEG_WAIT_DIS) begin
           clkreq_start_hold_ack_main_dis = 1'b1;
        end
        else begin
           clkreq_start_hold_ack_main_dis = 1'b0;
        end
    end
	    

    //Pulse width check disabled here since it flags a violation when the clock driving clkack is a single pulse long
    //We never drop clkreq until clkack asserts, so this won't actually get lost (unless it is a glitch which is 
    //an error outside of this block).
    hqm_rcfwl_pgcb_ctech_doublesync #(.PULSE_WIDTH_CHECK(0))
    u_clkackSync   (.d(clkack), .clr_b(pgcb_reset_sync_b), .clk(clock), 
                    .q(clkack_sync));

    
    
    /******************************************************************************************************************\
     *  
     *  POK Generation - Optional
     *  
     *  If driving then the reset for this requires a synchronized version of the pgcb_rst_b into the master clock.
     *  POK will always default to 0 and will go high based on pok_reset_b/pgcb_reset_b
    \******************************************************************************************************************/                   
    
    logic pok_reset_sync_b, pgcb_pok_sync;
    
                                        
    //Synchronize the PGCB's POK indicator into the ungated clock domain
    hqm_rcfwl_pgcb_ctech_doublesync        u_pgcbPok   (.d(pgcb_pok), .clr_b(pok_reset_sync_b), .clk(clock), 
                                        .q(pgcb_pok_sync));

    always_ff @(posedge clock, negedge pok_reset_sync_b) begin
        if (!pok_reset_sync_b) begin
            pok_preout <= '0;
        end else begin
            pok_preout <= clkreqack_equal1 ? pgcb_pok_sync : pok_preout;
        end
    end

    // Create a version of the POK reset synchronized to the ungated clock domain
    // Only drive the POK output if this is an IOSF CDC, otherwise drive 0
    if (DRIVE_POK) begin : doPok
        // For IOSF CDC's the pok_reset_b input will be used for the pok reset
        logic pok_reset_postscan_b;
        
        hqm_rcfwl_pgcb_ctech_mux_2to1_gen u_preSyncPokRstScanMux (
                .d1(fscan_byprst_b[RST]),
                .d2(pok_reset_b),
                .s(fscan_rstbypen[RST]),
                .o(pok_reset_postscan_b)
            );
        
        hqm_rcfwl_pgcb_ctech_doublesync_rstmux u_resetSync (.clk(clock), .clr_b(pok_reset_postscan_b), .rst_bypass_b(fscan_byprst_b[RST]),
                                            .rst_bypass_sel(fscan_rstbypen[RST]), .q(pok_reset_sync_b));
        assign pok = pok_preout;
    end
    else begin : noPok
        // For Non IOSF CDC's pgcb_reset_b will be used for the pok
        logic nc_pok_reset_b;
        assign nc_pok_reset_b = pok_reset_b;
        assign pok_reset_sync_b = pgcb_reset_sync_b;

        assign pok = '0; 
    end
    
    /******************************************************************************************************************\
     *  
     *  Locking Controls
     *
     *  ism_locked      : Asserted when ready for power gating or clkreq off, but not in the restore state
     *  boundary_locked : Asserted when ready for power gating or clkreq off
     *  domain_locked   : Asserts only once we have checked that the unlock requests have cleared from the PGCB domain,
     *                    so it doesn't assert in PGATE_PENDING.  Otherwise it is like boundary_locked.
     *  
    \******************************************************************************************************************/           
    
    //Note there is a race on the exit from restore where either unlockIsm de-assertion or unlockAll can cross the
    //clock domain first.  For this reason we will move from CDC_RESTORE to CDC_ON when either of these things 
    //happen.  We'll always check that both are de-asserted before we lock again.   
    
    assign ism_locked_c =  !pok_preout ? 1'b1 : (
                              (next_state == CDC_PGATE_PENDING)   | (next_state == CDC_PGATE)       | 
                              (next_state == CDC_OFF_PENDING)     | (next_state == CDC_OFF)         |
                              (next_state == CDC_FORCE_PENDING)   | (next_state == CDC_FORCE_READY) |
                              ( do_force_pgate && ((next_state == CDC_CGATE_PENDING) || (next_state == CDC_CGATE)) )
                           );

    assign boundary_locked_c =  !pok_preout ? 1'b1 : (
                                   (next_state == CDC_PGATE_PENDING)   | (next_state == CDC_PGATE)       |
                                   (next_state == CDC_OFF_PENDING)     | (next_state == CDC_OFF)         |
                                   (next_state == CDC_FORCE_PENDING)   | (next_state == CDC_FORCE_READY) |
                                   ( do_force_pgate && ((next_state == CDC_CGATE_PENDING) || (next_state == CDC_CGATE)) ) |
                                   (next_state == CDC_RESTORE)
                                );

  
    // If ISM_AGT_IS_NS is set, ism/boundary_locked are stricly the output of the flop
    // Otherwise, ism/boundary_locked assert 1 cycle earlier than flop and deassert at
    // the same time as the flopped version 
    //
    // HSD#2279699 - boundary_locked should assert at the same time as ism_locked if ISM_AGT_IS_NS==1
    if (ISM_AGT_IS_NS==1) begin: gen_flop_locked
        assign ism_locked = ism_locked_f | ism_locked_cg;
        assign boundary_locked = boundary_locked_f | ism_locked_cg;
    end else begin: gen_locked
        assign ism_locked = ism_locked_c | ism_locked_f | ism_locked_cg;
        assign boundary_locked = boundary_locked_c | boundary_locked_f | ism_locked_cg;
    end

    //localparam logic INIT_LOCKED = DEF_PWRON ? 1'b0 : 1'b1;

    always_ff @(posedge clock, negedge pgcb_reset_sync_b) begin
        if (!pgcb_reset_sync_b) begin
            domain_locked     <= '1;
            force_ready       <= '0;
            ism_locked_f      <= '1;
            boundary_locked_f <= '1;
            ism_wake          <= '0;
            clkreq_start_hold <= '0; //HSD1504110638
        end
        else begin
            domain_locked     <=  (next_state == CDC_PGATE)           | (next_state == CDC_RESTORE)    |
                                  (next_state == CDC_OFF_PENDING)     | (next_state == CDC_OFF)        |
                                  (next_state == CDC_FORCE_PENDING)   | (next_state == CDC_FORCE_READY);
            force_ready       <=  (next_state == CDC_FORCE_READY);
            ism_locked_f      <=  ism_locked_c;
            boundary_locked_f <=  boundary_locked_c;
            ism_wake          <=  /*ism_locked & */gclock_req_ism;
            clkreq_start_hold <=  (next_state == CDC_OFF_PENDING)     | (next_state == CDC_SYNCOFF_PENDING); //HSD1504110638
        end
    end
                                                    
    /******************************************************************************************************************\
     *  
     *  Idle Timer Controls
     *  
    \******************************************************************************************************************/
    CdcState_t last_current_state; 
    logic last_gclock_req, last_cdcpg_driving_clkreq, last_do_force_pgate;
    
    // Save the last value of the following inputs to the nextIdleTimer function in order split the path to meet timing
    // Note that these flops may update if clkreq!=1 || clkack!=1 but the outputs will never be used in the *OFF states
    always_ff @(posedge clock, negedge pgcb_reset_sync_b) begin
        if (!pgcb_reset_sync_b) begin
            last_current_state          <= CDC_INITIAL;
            last_gclock_req             <= '0;
            last_cdcpg_driving_clkreq   <= '0;
            last_do_force_pgate         <= '0;
            last_pg_disabled            <= '1;
        end
        else begin
            last_current_state          <= current_state;
            last_gclock_req             <= gclock_req;
            last_cdcpg_driving_clkreq   <= cdcpg_driving_clkreq;
            last_do_force_pgate         <= do_force_pgate;
            last_pg_disabled            <= pg_disabled;
        end
    end
    logic [ITBITS-1:0]  idle_timer, next_idle_timer;
    logic               not_idle;    
    
    //Be sure the async clock req from PGCB clears before we allow ourselves to go idle
    //If this is a forced PG entry, we want the timer to count and expire regardless of
    //the value of gclock_req
    
    //If any of the *disabled signals toggle, we will reset the timer for IP-Accessible
    assign not_idle         = (last_gclock_req | last_cdcpg_driving_clkreq | cfg_update) & !last_do_force_pgate;   
    assign timer_expired    = (next_idle_timer==0) & (~gclock_req || do_force_pgate);
    
    always_ff @(posedge clock, negedge pgcb_reset_sync_b) begin
        if (!pgcb_reset_sync_b) begin
            idle_timer      <= '0;
        end
        else begin
            idle_timer      <= next_idle_timer;
        end
    end
    
    /******************************************************************************************************************\
     *  
     *  nextIdleTimer
     *  
    \******************************************************************************************************************/
    // Value of 8 clocks will be used if *_disabled bits are 1, it will only take effect for ON->CGATE_PENDING
    localparam logic [3:0] DEF_DELAY = 4'd3;
    localparam logic [ITBITS-1:0] SHIFT_BIT   = 1;

        logic[3:0] initial_delay;
        logic timer_on;
       
    always_comb begin
 
        timer_on = '0;
        initial_delay = '0;

        if (current_state == CDC_ON) begin
            timer_on = '1;
            initial_delay = clkgate_disabled ? DEF_DELAY : cfg_clkgate_holdoff;
        end
        else if (current_state == CDC_CGATE_PENDING) begin
            timer_on = '1;
            initial_delay = 4'd3;   //Run 8 cycles after dropping clkacks
        end
        else if (current_state == CDC_CGATE) begin
            timer_on = '1;
            initial_delay = (last_pg_disabled & ~last_do_force_pgate)
                              ? (clkreq_disabled 
                                 ? DEF_DELAY 
                                 : cfg_clkreq_syncoff_holdoff)
                              : (last_pg_disabled 
                                 ? DEF_DELAY 
                                 : cfg_pwrgate_holdoff);

        end
        else if (current_state == CDC_PGATE) begin
            timer_on = '1;
            initial_delay = clkreq_disabled ? DEF_DELAY : cfg_clkreq_off_holdoff;

        end
        
    end

    always_comb begin

        if (timer_on) begin
            next_idle_timer = (not_idle | (last_current_state != current_state)) ? SHIFT_BIT << initial_delay : idle_timer;
            //Decrement if not already zero.  If zero we'll just hold there until the next reload
            if (|next_idle_timer) next_idle_timer = next_idle_timer - 1;
        end
        else begin
            next_idle_timer = '0;
        end 
    
    end

    /******************************************************************************************************************\
     *  
     *  Reset Controls
     *  
    \******************************************************************************************************************/
    logic [RST-1:0] greset_b_prescan, reset_postscan_b;
    
    
    for (genvar r = 0; r < RST; r++) begin : ResetSync
        //SCAN Bypass Mux needed prior to doublesync to allow doublesync to be scanned 
        hqm_rcfwl_pgcb_ctech_mux_2to1_gen u_preSyncRstScanMux (
                .d1(fscan_byprst_b[r]),
                .d2(reset_b[r]),
                .s(fscan_rstbypen[r]),
                .o(reset_postscan_b[r])
            );

        //Reset synchronization for the ungated domain
        hqm_rcfwl_pgcb_ctech_doublesync_rstmux u_rstMux(.clk(clock), .clr_b(reset_postscan_b[r]), .rst_bypass_b(fscan_byprst_b[r]),
                                                 .rst_bypass_sel(fscan_rstbypen[r]), .q(reset_sync_b[r]));
       
        //Reset synchronization for the gated domain - can be forced by the PGCB or test mode
        //Apply the override for forced reset
        hqm_rcfwl_pgcb_ctech_and2_gen u_frcRstAND(
                .a(reset_sync_b[r]),
                .b(pgcb_force_rst_b),
                .y(greset_b_prescan[r])
            );
        //Apply the override for DFx/SCAN
        hqm_rcfwl_pgcb_ctech_mux_2to1_gen u_frcRstMux (
                .d1(fscan_byprst_b[r]),
                .d2(greset_b_prescan[r]),
                .s(fscan_rstbypen[r]),
                .o(greset_b[r])
            );
    end
        
    /******************************************************************************************************************\
     *  
     *  Synchronizers from pgClock Domain
     *  
    \******************************************************************************************************************/
    
    hqm_rcfwl_pgcb_ctech_doublesync u_clkreq_start_hold_ack_ByPgcb (.d(clkreq_start_hold_ack_pg), .clr_b(pgcb_reset_sync_b), .clk(clock), .q(clkreq_start_hold_ack_syncmain));//HSD1504110638

    hqm_rcfwl_pgcb_ctech_doublesync u_gclock_req_sync_ByPgcb (.d(gclock_req_sync_pg), .clr_b(pgcb_reset_sync_b), .clk(clock), .q(gclock_req_sync_pg_main));    //HSD:1503996414
    hqm_rcfwl_pgcb_ctech_doublesync u_gclock_req_async_ByPgcb (.d(gclock_req_async_or_pg), .clr_b(pgcb_reset_sync_b), .clk(clock), .q(gclock_req_async_pg_main)); //HSD:1503996414

    hqm_rcfwl_pgcb_ctech_doublesync u_ism_lockedByPgcb (.d(ism_locked_pg), .clr_b(pgcb_reset_sync_b), .clk(clock), .q(ism_locked_pg_main)); //HSD1504001217
    hqm_rcfwl_pgcb_ctech_doublesync u_unlockAll        (.d(unlock_domain_pg), .clr_b(pgcb_reset_sync_b), .clk(clock), .q(unlock_all));

    hqm_rcfwl_pgcb_ctech_doublesync u_forcePowerGate   (.d(force_pgate_req_pg), .clr_b(pgcb_reset_sync_b), .clk(clock), .q(force_pgate_req));
    //HSD1207621082
    hqm_rcfwl_pgcb_ctech_doublesync u_forcePowerGateNoPGActive   (.d(force_pgate_req_not_pg_active_pg), .clr_b(pgcb_reset_sync_b), .clk(clock), .q(force_pgate_req_not_pg_active));

    hqm_rcfwl_pgcb_ctech_doublesync u_clkreqHeldByPgcb (.d(assert_clkreq_pg), .clr_b(pgcb_reset_sync_b), .clk(clock), .q(cdcpg_driving_clkreq)); 

    hqm_rcfwl_pgcb_ctech_doublesync_lpst u_powerGateDisabled(.d(pwrgate_disabled), .pst_b(pgcb_reset_sync_b), .clk(clock), .q(pg_disabled));

    hqm_rcfwl_pgcb_ctech_doublesync_lpst u_clkreq_dis_sync  (.d(cfg_clkreq_ctl_disabled), .pst_b(pgcb_reset_sync_b), .clk(clock), .q(clkreq_disabled));
    hqm_rcfwl_pgcb_ctech_doublesync_lpst u_clkgate_dis_sync  (.d(cfg_clkgate_disabled), .pst_b(pgcb_reset_sync_b), .clk(clock), .q(clkgate_disabled_sync));

    hqm_rcfwl_pgcb_ctech_doublesync     u_clkgate_ovrd_sync   (.d(fismdfx_clkgate_ovrd), .clr_b(pgcb_reset_sync_b), .clk(clock), .q(fismdfx_clkgate_ovrd_sync));
    hqm_rcfwl_pgcb_ctech_doublesync     u_force_clkreq_sync   (.d(fismdfx_force_clkreq), .clr_b(pgcb_reset_sync_b), .clk(clock), .q(fismdfx_force_clkreq_sync));


    // Note: PULSE_WIDTH_CHECK is disabled on pwrgate_active doublesync because pwrgate_active can
    // toggle when the clock input is gated externally (clkreq/clkack=0) which flags false failures
     hqm_rcfwl_pgcb_ctech_doublesync_lpst #(.PULSE_WIDTH_CHECK(0))
                     u_pwrgate_active   (.d(pwrgate_active_pg), .pst_b(pgcb_reset_sync_b), .clk(clock), .q(pwrgate_active));
    
    if (DEF_PWRON) begin: pg_active_ds_lpst
        hqm_rcfwl_pgcb_ctech_doublesync_lpst u_unlockIsm   (.d(cdc_restore_pg), .pst_b(pgcb_reset_sync_b), .clk(clock), .q(unlock_ism));
    end else begin: pg_active_ds
        hqm_rcfwl_pgcb_ctech_doublesync u_unlockIsm        (.d(cdc_restore_pg), .clr_b(pgcb_reset_sync_b), .clk(clock), .q(unlock_ism));
    end

    always_comb begin
        cdc_main_visa = '0; //Tie unused bits to 0

        cdc_main_visa[12]  = gclock_active;
        cdc_main_visa[11]  = clkreq_hold;
        cdc_main_visa[10]  = gclock_enable;
        cdc_main_visa[9]   = gclock_req;
        cdc_main_visa[8]   = do_force_pgate;
        cdc_main_visa[7]   = timer_expired;
        cdc_main_visa[6:3] = current_state;
        cdc_main_visa[2]   = ism_wake;
        cdc_main_visa[1]   = not_idle;
        cdc_main_visa[0]   = pg_disabled;
    end

    `ifndef INTEL_SVA_OFF
      `ifdef INTEL_SIMONLY
        `include "CdcMainClock.sva"
      `endif
    `endif
endmodule

/******************************************************************************************************************\
 *  
 * Synchronizer Notes 
 *  
\******************************************************************************************************************/
//------------------------------
// ism_locked:-- crossing over from functional clock to Pgcb_clk. 
// ----------
//
// Only two usages -- one in pwrgate_Ready function and other for restore signal control logic. 
// Pwrgate_Ready usage is relevant only for restore case (where there is small possible window that restore signal
// is de-asserted [while ism is still unlocked] so no wake -- and pg_ready could be asserted unless it was making
// sure that ism is also locked.)  
//
// For non-restore case (usage in pg_Ready function), it is possible for ism_locked de-assertion (Case 1) to be
// missed (H, L, H) but it is not possible for assertion (Case 2) to be missed (L, H, L). Case 1 is determined to
// be okay because domain_locked and unlock_all have a full handshake - and for non-restore, pg_ready does not
// care about ism_locked signal. Hence waivable. 
//  
// for restore case, there is a case (case 3) where force_pwrgate is asserted and parameter is cleared -- so
// restore signal is de-asserted independent of ism_locked value. This is intentional and therefore case of
// H, L, H on ism_locked being missed is waivable (Case of L, H, L is not possible here)
//
// Other case (case 4) is without any force_pgate assertion. There is a full handshake between restore signal
// and ism_locked -- so no cases of missed pulses are possible. 
//  
// Summary:-- 
// all possible missed pulse cases are waivable -- so PW check is to be waived on ism_locked. 
//------------------------------

