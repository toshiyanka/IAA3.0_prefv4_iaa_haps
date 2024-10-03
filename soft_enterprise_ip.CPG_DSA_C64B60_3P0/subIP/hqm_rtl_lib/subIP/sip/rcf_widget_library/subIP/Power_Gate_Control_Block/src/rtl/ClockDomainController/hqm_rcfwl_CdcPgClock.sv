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
 * CdcPgClock
 * @author Jeff Wilcox
 * 
 * 
\**********************************************************************************************************************/

module hqm_rcfwl_CdcPgClock #(
    DEF_PWRON = 1,                                  //Default to a powered-on state after reset
    AREQ = 1,                                       //Number of async gclock requests.  Min is one.
    DRIVE_POK = 1'b1,                               //Determines whether this domain must drive POK
    CLKACK_NEG_WAIT_DIS = 0,                        //HSD 1504110638
                                                    //If 0, in OFF_PENDING state, CDC will wait until clkack is negated.
                                                    //      Must be 0 if PGCB clk freq is faster than main
                                                    //If 1, will revert back to old behavior.
    GCLKREQ_ASYNC_OR_NS = 0,                        //HSD 1604083741
                                                    //If 0, will use flopped version for gclock_req_async* ORed output from PGCB domain.
                                                    //If 1, will use unfloopwd output of gclock_req_async* ORed output (old behavior) for performance.


    RSTR_B4_FORCE = 0                               //Determines if this CDC will require restore phase to complete
                                                    //in order to transition from IP-Accessible to IP-Inaccessible PG
)(
    //PGCB ClockDomain
    input   logic       pgcb_clk,                   //PGCB clock; always running
    input   logic       pgcb_reset_b,               //Reset with de-assert synchronized to pgcb_clk
    
    //Functional Clkreq
    input   logic       clkack,                     //Functional Clock Ack
    output  logic       clkreq,                     //Functional Clock Request
    
    //Interface to CdcMainClock
    input   logic       domain_locked,              //Domain is locked; main clock domain
    input   logic       force_ready,                //Domain is ready to be forced into power gating
    input   logic       clkreq_hold,                //Clock req is being held high; main clock domain
    input   logic       ism_wake,                   //Wake event due to fabric ISM leaving idle; main clock domain
    input   logic       domain_pok,                 //POK in the main clock domain
    input   logic       ism_locked_f,               //ism_locked from the main clock domain
    output  logic       unlock_domain_pg,           //Unlock all (boundary and ISM); pgcb_clk domain
    output  logic       assert_clkreq_pg,           //Assert CLKREQ; pgcb_clk domain
    output  logic       pwrgate_active_pg,          //Glitch-free pwrgate_active in PGCB clock domain
    output  logic       cdc_restore_pg,             //restore signal to the Main Clock Domain
    output  logic       force_pgate_req_pg,         //force_pgate_req to main clock domain
    output  logic       force_pgate_req_not_pg_active_pg, //HSD1207621082
    output  logic       ism_locked_pg,              //ism_locked_pg to the main clock domain to avoid meta-stability race issue
    input   logic       clkreq_start_hold,          //The main clock domain control is entering OFF_PENDING state, clkack negation is expected and clkreq req should not assert. //HSD1504110638
    output  logic       clkreq_start_hold_ack_pg,   //The pgcb domain indication that it has received clkreq_start_hold.  main S/M can now negate clkreq_hold. //HSD1504110638
    
    //Gated Clock Requests
    input   logic       gclock_req_sync,            //Synchronous gClock request.  gClock domain - NOT GLITCH FREE
    input   logic [AREQ-1:0] gclock_req_async,      //Async (glitch free) gclock requests
    output  logic       gclock_req_sync_pg,         //PGCB synched gclock_req_sync
    //output  logic       gclock_req_async_pg,	    //PGCB synched gclock_req_async bits ORed
    output  logic       gclock_req_async_or_pg,   //PGCB synched gclock_req_async bits ORed or flopped in PGCB domain
    
    //CDC Aggregation and Control (synchronous to pgcb_clk domain)
    input   logic       pwrgate_disabled,           //Don't allow idle-based clock gating; PGCB clock
    input   logic       pwrgate_force,              //Force the controller to gate clocks and lock up; PGCB clock   
    input   logic       pwrgate_pmc_wake,           //PMC wake signal (after sync); PGCB clock domain
    output  logic       pwrgate_ready,              //Allow power gating in the PGCB clock domain.  Can de-assert
                                                    //even if never power gated if new wake event occurs.
                                                    
    //PGCB Interface
    input   logic       pgcb_force_rst_b,           //Force for resets to assert; pgcb_clk domain
    input   logic       pgcb_pwrgate_active,        //Ackowledge that power gating has been done; PGCB clock domain
    input   logic       pgcb_pok,                   //Power OK signal in the PGCB clock domain
    input   logic       pgcb_restore,               //Restore indication from the PGCB

    //DFx Interface
    input   logic       fismdfx_force_clkreq,       //DFx force assert clkreq
    
    //CDC Main Clock VISA Signals
    output logic [5:0]  cdc_pg_visa                 // Set of internal signals for VISA visibility

);
    localparam logic INIT_PWRON = DEF_PWRON ? 1'b1 : 1'b0;

    logic gclock_req_async_pg, gclock_req_async_pg_f;	    //PGCB synched gclock_req_async bits ORed
    logic locked_pg, clkreq_hold_pg, ism_wake_pg, domain_pok_pg;
    logic force_ready_pg;
    logic fismdfx_force_clkreq_pg;
    logic unlock_domain_pg_next, assert_clkreq_next;
    logic pmc_wake_pg, restore_wake_pg;
    logic clkack_pg, clkreq_start_ok;
    logic cdc_restore_pg_next, force_pgate_req_pg_next, pmc_wake_pg_next, restore_wake_pg_next ;
    logic clkreq_start_hold_pg;

    always_comb begin
       if(GCLKREQ_ASYNC_OR_NS) begin
         gclock_req_async_or_pg = gclock_req_async_pg;
       end
       else begin
         gclock_req_async_or_pg = gclock_req_async_pg_f;
       end
    end

    //assign pwrgate_ready    = isPowerGateReady(locked_pg, unlock_domain_pg, gclock_req_sync_pg, gclock_req_async_pg, 
    //                                           ism_wake_pg, pwrgate_force, force_ready_pg, pgcb_pok, pmc_wake_pg,
    //                                           pwrgate_disabled, ism_locked_pg, pgcb_restore, cdc_restore_pg, restore_wake_pg,
    //                                           fismdfx_force_clkreq_pg);
                               
    //Pre-flop signals that will be crossed into the other clock domain. 
    // -pwrgate_active should be flopped before crossing to Main clock domain as it is a combi signal
    always_ff @(posedge pgcb_clk, negedge pgcb_reset_b) begin
        if (!pgcb_reset_b) begin
            assert_clkreq_pg    <= '0;
            unlock_domain_pg    <= '0;
            pwrgate_active_pg   <= '1;
            cdc_restore_pg      <= INIT_PWRON;
            force_pgate_req_pg  <= '0;
            pmc_wake_pg         <= '0;
            restore_wake_pg     <= INIT_PWRON;
            gclock_req_async_pg_f <= 1'b0;
            force_pgate_req_not_pg_active_pg <= '0;
        end
        else begin
            assert_clkreq_pg    <= assert_clkreq_next;
            unlock_domain_pg    <= unlock_domain_pg_next;
            pwrgate_active_pg   <= pgcb_pwrgate_active;
            cdc_restore_pg      <= cdc_restore_pg_next;
            force_pgate_req_pg  <= force_pgate_req_pg_next;
            pmc_wake_pg         <= pmc_wake_pg_next;
            restore_wake_pg     <= restore_wake_pg_next;
            gclock_req_async_pg_f <= gclock_req_async_pg;
            force_pgate_req_not_pg_active_pg <= force_pgate_req_pg_next & ~pgcb_pwrgate_active;  //HSD1207621082
        end
    end                                             
    
    /******************************************************************************************************************\
     *  
     *  isPowerGateReady
     *  
    \******************************************************************************************************************/
    
     always_comb begin
        //If PMC asserts wake, must wake up or stay awake
        if (pmc_wake_pg) 
                pwrgate_ready = '0; 
                    
        //Must be locked to power gate
        else if (!locked_pg || unlock_domain_pg || !ism_locked_pg ) 
                pwrgate_ready = '0;     

        //Force power gate only when domain is ready for it
        else if (pwrgate_force) 
                pwrgate_ready = force_ready_pg;      

        //Locked and not forced to wake up by PMC
        //Stay in power gating while pgcb's POK is low
        else if (!pgcb_pok) 
                pwrgate_ready =  '1;                    

        //Locked, POK is high and not being forced to wake or power down

        //Stay power gated unless there is a wake event
        else  
                pwrgate_ready =  !(gclock_req_sync_pg | gclock_req_async_pg | ism_wake_pg | pwrgate_disabled | pgcb_restore | cdc_restore_pg | restore_wake_pg | fismdfx_force_clkreq_pg);   
     end


    /******************************************************************************************************************\
    *  
    *  unlockDomainNext
    *  
    \******************************************************************************************************************/

    always_comb begin

        if (unlock_domain_pg & locked_pg) 
            unlock_domain_pg_next ='1;                      //If currently unlocking, keep unlocking if domain is still locked 
        else if (pgcb_pwrgate_active) unlock_domain_pg_next ='0;       //Never unlock while power gating is active
        else if (~pgcb_force_rst_b) unlock_domain_pg_next ='0;            //Never unlock while reset is forced
        else if (force_pgate_req_pg & ism_locked_pg) unlock_domain_pg_next ='0;      //Never unlock when forced to power gate if the ISM's are already locked (ie not in restore)
        else if (!pgcb_pok) unlock_domain_pg_next ='0;            //Never unlock unless the PGCB's POK is asserted 
        else if (!locked_pg) unlock_domain_pg_next ='0;       //Never unlock unless the domain is actually locked
        //If other conditions are OK, unlock on any wake event
        else 
           unlock_domain_pg_next = (gclock_req_sync_pg | gclock_req_async_pg | ism_wake_pg | pwrgate_disabled | restore_wake_pg | fismdfx_force_clkreq_pg);
    end


    /******************************************************************************************************************\
    *  
    * restoreWake 
    *
    * When restore is over, FSM must transition from RESTORE to ON/ON_PENDING. This function creates
    * a wake event that asserts when pgcb_restore asserts and deasserts when the domain is unlocked.
    *  
    \******************************************************************************************************************/
       
    always_comb begin
        if (!locked_pg)   	  restore_wake_pg_next = '0;  // Deassert if domain is unlocked
        else if (cdc_restore_pg)  restore_wake_pg_next = '1;  // Assert if pgcb_restore is happening
        else if (restore_wake_pg) restore_wake_pg_next = '1;  // Once asserted, stay asserted (until domain is unlocked)
        else			  restore_wake_pg_next = '0;
    end
 
    /******************************************************************************************************************\
     *  
     *  assertClkReqNext
     *  
    \******************************************************************************************************************/

    always_comb begin
            assert_clkreq_next    =  '0;

        if (!assert_clkreq_pg && clkreq_hold_pg) begin
            //Never assert a new once the sync control of the clkreq is being held
            assert_clkreq_next    = '0;
        end
        else if (assert_clkreq_pg) begin
            //If PMC is waking the domain, then hold this assertion until domain's POK is asserted if driving POK
            if (pmc_wake_pg && (DRIVE_POK==1) && !domain_pok_pg) 
                assert_clkreq_next    = '1;
                
            //If there is a wake event, hold until power gating has exited and we have unlocked the domain
            else if ((gclock_req_sync_pg || gclock_req_async_pg || ism_wake_pg || pwrgate_disabled) && locked_pg && !force_pgate_req_pg) //TODO (Future Enhancement): replace with unlockdomain_next
                assert_clkreq_next    = '1;

            //In other cases keep driving while waiting for the syncClkreqHold to assert            
            else
                assert_clkreq_next    = !clkreq_hold_pg;

        end
        else if (clkreq_start_ok) begin
            //** Below are the things that can start clkreq asserting ** 
            
            //When POK is de-asserted assert whenever the pmc wants to wake this IP up if we need to drive POK
            if (!pgcb_pok & !domain_pok_pg) 
                assert_clkreq_next    =  pmc_wake_pg && (DRIVE_POK==1);

            //Force clock to start to ensure lock and control POK
            else if (force_pgate_req_pg) 
                assert_clkreq_next    =  '1;

                
            //If there is a wake event, drive the clkreq
            else if (gclock_req_sync_pg || gclock_req_async_pg || ism_wake_pg || pgcb_restore || fismdfx_force_clkreq_pg) 
                assert_clkreq_next    =   '1;

                    
            //Since the sync clock req is off, the domain should be locked if power gating is allowed and not locked if pwr
            //gating is not allowed.  If either of those things are not true then the policy for power gating has changed
            //and we need to wake up the clock domain to reconcile this.  
            else if ((locked_pg && pwrgate_disabled) || (!locked_pg && !pwrgate_disabled))
                assert_clkreq_next    =   '1;

            else
                assert_clkreq_next    =  '0;

        end
    end
    
    /******************************************************************************************************************\
     *  
     *  clkreq
     *  
    \******************************************************************************************************************/
    always_ff @(posedge pgcb_clk, negedge pgcb_reset_b) begin
        if (!pgcb_reset_b) begin
            clkreq          <= INIT_PWRON;

            clkreq_start_ok <= !INIT_PWRON;
        end else begin
            clkreq          <= clkreq_hold_pg | assert_clkreq_next;

            //HSD1504110638: hold off asserting clkreq_start_ok until main S/M can detect clkack negation after clkreq_hold_pg negates.
            clkreq_start_ok <= clkreq_hold_pg ? 1'b0 : (clkreq_start_ok | (!clkack_pg & !clkreq_start_hold_pg) ); 
        end
    end

 
    always_comb begin
        if (CLKACK_NEG_WAIT_DIS) begin
           clkreq_start_hold_pg = 1'b0;
        end else begin
           clkreq_start_hold_pg = clkreq_start_hold_ack_pg;
        end
    end

    /******************************************************************************************************************\
    *  
    *  cdc_restore
    *  
    \******************************************************************************************************************/

    always_comb begin

        // If a force_pg entry is starting, cdc_restore should clear 
        // Terminate a restore if pwrgate_force asserts
        if (force_pgate_req_pg && (RSTR_B4_FORCE==0)) begin
            cdc_restore_pg_next = pgcb_restore & ism_locked_pg;
        end
        
        // Only allow restore to assert if the domain is actually locked
        else if (!cdc_restore_pg) begin
            cdc_restore_pg_next =  pgcb_restore & ism_locked_pg;
        end

        // If cdc_restore is currently asserted...
        else if (cdc_restore_pg) begin


            // If the ISM is still seen as locked in the PGCB domain, keep restore asserted
            if (ism_locked_pg)
                cdc_restore_pg_next =  '1;

// No longer necessary as the FSM will not go to PGATE based on force_pgate_req any longer
//            // If there is a wake pending and the domain is not yet being unlocked, keep restore
//            // asserted
//            else if ((gclock_req_sync_pg | gclock_req_async_pg | ism_wake_pg | pwrgate_disabled) && !unlock_domain_pg) 
//                cdc_restore_pg_next =  '1;

           
            // Otherwise allow it to follow pgcb_restore 
            else
                cdc_restore_pg_next =  pgcb_restore;
        end

        else
                cdc_restore_pg_next =  cdc_restore_pg;

    end

    
    /******************************************************************************************************************\
    *  
    *  force_pgate_req_pg
    *  
    \******************************************************************************************************************/
    //force_pgate_req is masked by pmc_wake being asserted 

    always_comb begin
        if (!force_pgate_req_pg) begin
            // force_pgate_req to the CDC domain should only assert if pwrgate_active is 0 if RSTR_B4_FORCE
            // is set, this ensures that restore will happen if needed, before proceeding to FORCE_READY
            // it also may only assert if the domain is not being unlocked
            if (RSTR_B4_FORCE==1)
                force_pgate_req_pg_next = pwrgate_force && !unlock_domain_pg_next && !pwrgate_pmc_wake && !pgcb_pwrgate_active && !cdc_restore_pg;
            
            // force_pgate_req to the CDC domain may only assert if the domain is not in the process of unlocking
           else
                force_pgate_req_pg_next =  pwrgate_force && !unlock_domain_pg_next && !pwrgate_pmc_wake;
        end

        else
                force_pgate_req_pg_next =  pwrgate_force;  
    end

    
    /******************************************************************************************************************\
    *  
    *  pwrgate_pmc_wake 
    *  
    \******************************************************************************************************************/
    // If pmc_wake asserts when pwrgate_force (flopped version) is asserted, pmc_wake will be masked until
    // pwrgate_force is deasserted.  If they both (pre-flop) assert at the same time, pmc_wake has priority
    // and will assert (force_pgate_req_pg is masked until pmc_wake is removed)

    always_comb begin
        if (!pmc_wake_pg) begin
            pmc_wake_pg_next = pwrgate_pmc_wake & !force_pgate_req_pg;

        end
        else begin
            pmc_wake_pg_next = pwrgate_pmc_wake;  
        end
    end
  
 
    /******************************************************************************************************************\
     *  
     *  Synchronizers from uClock Domain
     *  
    \******************************************************************************************************************/                                                                
    logic [AREQ-1:0] gclock_req_async_sync_bits;
    
    //Cross the locked indicators over to the PGCB clock domain where all wake decisions will be made
    //Boundary locked is used since it starts at the same time as ISM lock and unlocks atthe same time or later
    //Also cross the indication that clkreq is being held by the main clock domain
   
    //Note: PULSE_WIDTH_CHECK is disabled for ism_locked_pg, as it is guaranteed to be a full
    //handshake with cdc_restore_pg for the restore case, for the non-restore case, it is a don't
    //care in this clock domain
    hqm_rcfwl_pgcb_ctech_doublesync_lpst #(.PULSE_WIDTH_CHECK(0))
                          u_domainIsmLockedPG (.d(ism_locked_f), .pst_b(pgcb_reset_b), .clk(pgcb_clk),
                                                  .q(ism_locked_pg));
        
    hqm_rcfwl_pgcb_ctech_doublesync_lpst  u_lockedPG    ( .d(domain_locked), .pst_b(pgcb_reset_b), .clk(pgcb_clk), 
                                            .q(locked_pg));

    if (DEF_PWRON) begin : SyncForDefPwrOn
        hqm_rcfwl_pgcb_ctech_doublesync_lpst //  	#(.PULSE_WIDTH_CHECK(0), .METASTABILITY_EN(0))
                                u_clkreqHoldPG( .d(clkreq_hold), .pst_b(pgcb_reset_b), .clk(pgcb_clk), 
                                                .q(clkreq_hold_pg));
    end
    else begin : SyncForDefPwrOff
        hqm_rcfwl_pgcb_ctech_doublesync     //    #(.PULSE_WIDTH_CHECK(0), .METASTABILITY_EN(0))
                                u_clkreqHoldPG( .d(clkreq_hold), .clr_b(pgcb_reset_b), .clk(pgcb_clk), 
                                                .q(clkreq_hold_pg));    
   end
    
    hqm_rcfwl_pgcb_ctech_doublesync     //    #(.PULSE_WIDTH_CHECK(0), .METASTABILITY_EN(0))
                                u_clkackPG( .d(clkack), .clr_b(pgcb_reset_b), .clk(pgcb_clk), 
                                                .q(clkack_pg));    
    
//    rcfwl_pgcb_ctech_doublesync         //    #(.METASTABILITY_EN(0))
      hqm_rcfwl_pgcb_ctech_doublesync            #(.MINUS1_ONLY(1))  //kc hotfix for HSD 1405876123          
                                u_forceRdyPG  ( .d(force_ready), .clr_b(pgcb_reset_b), .clk(pgcb_clk), 
                                                .q(force_ready_pg));
    
                        
    //Detect any wake indication asynchronously and cross into the PGCB clock domain. (OK to allow pulses to be dropped)    
    hqm_rcfwl_pgcb_ctech_doublesync //#(.PULSE_WIDTH_CHECK(0), .METASTABILITY_EN(0))
                             u_gClockReqSyncPG  (.d(gclock_req_sync), .clr_b(pgcb_reset_b), .clk(pgcb_clk), 
                                                 .q(gclock_req_sync_pg));
    hqm_rcfwl_pgcb_ctech_doublesync #(.PULSE_WIDTH_CHECK(0))
                             u_ismWakePG        (.d(ism_wake), .clr_b(pgcb_reset_b), .clk(pgcb_clk),
                                                 .q(ism_wake_pg));
    hqm_rcfwl_pgcb_ctech_doublesync //#(.PULSE_WIDTH_CHECK(0), .METASTABILITY_EN(0))
                             u_dfxForceClkreq   (.d(fismdfx_force_clkreq), .clr_b(pgcb_reset_b), .clk(pgcb_clk),
                                                 .q(fismdfx_force_clkreq_pg));
    
    hqm_rcfwl_pgcb_ctech_doublesync //#(.PULSE_WIDTH_CHECK(0), .METASTABILITY_EN(0))
                             u_domainPokPG      (.d(domain_pok), .clr_b(pgcb_reset_b), .clk(pgcb_clk),
                                                 .q(domain_pok_pg));
    
    hqm_rcfwl_pgcb_ctech_doublesync //#(.PULSE_WIDTH_CHECK(0), .METASTABILITY_EN(0))   //HSD1504110638
                             u_clkreqStartHoldPG      (.d(clkreq_start_hold), .clr_b(pgcb_reset_b), .clk(pgcb_clk),
                                                       .q(clkreq_start_hold_ack_pg));
    
    for (genvar a = 0; a < AREQ; a++) begin : AsyncReqXC
        hqm_rcfwl_pgcb_ctech_doublesync //#(.PULSE_WIDTH_CHECK(0), .METASTABILITY_EN(0))
                             u_gClockReqAsyncPG (.d(gclock_req_async[a]), .clr_b(pgcb_reset_b), .clk(pgcb_clk),
                                                 .q(gclock_req_async_sync_bits[a]));
    end
    assign gclock_req_async_pg = |gclock_req_async_sync_bits;
    
    always_comb begin
        cdc_pg_visa = '0; //Tie unused bits to 0

        cdc_pg_visa[5]   = locked_pg;
        cdc_pg_visa[4]   = force_ready_pg;
        cdc_pg_visa[3]   = domain_pok_pg;
        cdc_pg_visa[2]   = assert_clkreq_pg;
        cdc_pg_visa[1]   = unlock_domain_pg;
        cdc_pg_visa[0]   = pwrgate_ready;
    end

    `ifndef INTEL_SVA_OFF
      `ifdef INTEL_SIMONLY
        `include "CdcPgClock.sva"
      `endif
    `endif
endmodule

/******************************************************************************************************************\
 *  
 * Synchronizer Notes 
 *  
\******************************************************************************************************************/
//------------------------------
// pwrgate_active:-- crossing over from pgcb_clk to functional clock domain. 
// --------------
// has a corner case issue where if the functional clock is really slow as
// compared to pgcb_clk (50X or so), the pwrgate_active assertion in force_ready state can be
// missed and the CDC will hang. W/A is for PMC to delay the wake after the PG entry till
// pwrgate_active is synced over to functional clock domain.
//
// NOTE: 
//    a. the CDC main clock logic does not care about pwrgate_deassertion for IP-Acc only PG entry
//       cases. It is only for IP-Acc to IP-Inacc that CDC main clock logic cares about the
//       de-assertion -- and in that case, through the force_ready, an implicit handshake is built to
//       keep pwrgate_ready de-asserted until pwrgate_active has been seen as de-asserted in the main
//       clock.
//
//    b. For pwrgate_active assertion case -- this is relavant again on ly for IP-Inacc and there is
//       a scenario where this can be missed (see first para) -- but PMc W/a can resolve this. 
//    
//    c. on the other hand, when a given CDC is in the OFF state with clkreq off, pwrgate_active
//       could assert and de-assert for IP-Acc entries/exits multiple times -- and this is known case
//       of false violations. 
//
// Summary: DISABLE the PW check for pwrgate_active. 
//------------------------------
//
//------------------------------
// ism_wake:-- crossing over from functional to pgcb clock domain. 
// --------------
// ism_wake comes from the cdc clock domain and is a flopped version of (ism_locked & (ism_fabric != 3'b000)).
// It is then synchronized to the pgcb clock domain, so it is technically a synchronizer on an internal signal.
// It is seen that ism_wake asserts exiting IP-Inacessible pg, but then it deasserts quickly because ism_locked deasserts.
//
// Analysis:
// ism_wake is used in:
// •   unlock_domain – The fabric would stay in a non-idle state until the IP is able to unlock to handle the transaction,
//     so we wouldn’t expect it to drop suddenly, unless pok went low or a reset, which would be okay.
// •   pwrgate_ready – Similar to unlock_domain, the fabric would stay non-idle until the transaction was handled.
//     If pwrgate_ready is asserted, that means the domain is locked and not unlocking, so the ip wouldn’t be able handle
//     the transaction until pwrgate_ready deasserted anways.
//
// Summary: DISABLE the PW check for ism_wake as it is almost guaranteed to fail and will not cause function issues
//          if a pulse is missed
//------------------------------
