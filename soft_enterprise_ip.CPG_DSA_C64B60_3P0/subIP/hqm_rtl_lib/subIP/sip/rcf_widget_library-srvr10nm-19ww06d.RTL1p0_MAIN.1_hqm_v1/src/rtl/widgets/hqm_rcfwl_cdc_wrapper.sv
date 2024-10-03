//

///
///  INTEL CONFIDENTIAL
///
///  Copyright 2015 Intel Corporation All Rights Reserved.
///
///  The source code contained or described herein and all documents related
///  to the source code ("Material") are owned by Intel Corporation or its
///  suppliers or licensors. Title to the Material remains with Intel
///  Corporation or its suppliers and licensors. The Material contains trade
///  secrets and proprietary and confidential information of Intel or its
///  suppliers and licensors. The Material is protected by worldwide copyright
///  and trade secret laws and treaty provisions. No part of the Material may
///  be used, copied, reproduced, modified, published, uploaded, posted,
///  transmitted, distributed, or disclosed in any way without Intel's prior
///  express written permission.
///
///  No license under any patent, copyright, trade secret or other intellectual
///  property right is granted to or conferred upon you by disclosure or
///  delivery of the Materials, either expressly, by implication, inducement,
///  estoppel or otherwise. Any license under such intellectual property rights
///  must be express and approved by Intel in writing.
///
// 
//  This is a wrapper around the CDC for use where no PGCB block exists
//  It is therefor assumed:
//     the state of the IP on deassertion or reset is in an "ON" state
//     


module hqm_rcfwl_cdc_wrapper 
#(
  parameter    DEF_PWRON = 0,                    //Default to a non-powered-on state after reset
  parameter    ITBITS = 4,                       //Idle Timer Bits.  Max is 16.  set to match hardcoded cfg_clkreq_off_holdoff
  parameter    AREQ = 1,                         //Number of async gclock requests.  Min is one.
  parameter    NUM_EP_ATTACHED = 1,               //Number of endpoints attached - used to size the bitwise OR of the ISM bits
  parameter    ISM_AGT_IS_NS = 0,                // not used
  // DFX secure plugin parameters
  parameter    DFX_NUM_OF_FEATURES_TO_SECURE = 1,
  parameter    DFX_SECURE_WIDTH              = 4,
  parameter    DFX_USE_SB_OVR                = 0,
  parameter    DFX_VISA_BLACK                = 2'b11,
  parameter    DFX_VISA_GREEN                = 2'b01,
  parameter    DFX_VISA_ORANGE               = 2'b10,
  parameter    DFX_VISA_RED                  = 2'b00,
  parameter    DFX_EARLYBOOT_FEATURE_ENABLE  = {1'b0,DFX_VISA_GREEN},
  parameter    [(((DFX_NUM_OF_FEATURES_TO_SECURE + 2) * (2 ** DFX_SECURE_WIDTH)) - 1):0] DFX_SECURE_POLICY_MATRIX =  
  {{1'b0,DFX_VISA_BLACK},   // Policy_15 (Part Disabled)
   {1'b0,DFX_VISA_ORANGE},  // Policy_14 (User8 Unlocked)
   {1'b0,DFX_VISA_ORANGE},  // Policy_13 (User7 Unlocked)
   {1'b0,DFX_VISA_ORANGE},  // Policy_12 (User6 Unlocked)
   {1'b0,DFX_VISA_ORANGE},  // Policy_11 (User5 Unlocked)
   {1'b0,DFX_VISA_ORANGE},  // Policy_10 (User4 Unlocked)
   {1'b0,DFX_VISA_ORANGE},  // Policy_9  (User3 Unlocked)
   {1'b0,DFX_VISA_ORANGE},  // Policy_8  (DRAM Debug Unlocked)
   {1'b1,DFX_VISA_RED},     // Policy_7  (InfraRed Unlocked)
   {1'b1,DFX_VISA_ORANGE},  // Policy_6  (enDebug Unlocked)
   {1'b0,DFX_VISA_ORANGE},  // Policy_5  (OEM Unlocked)
   {1'b1,DFX_VISA_RED},     // Policy_4  (Intel Unlocked)
   {1'b0,DFX_VISA_ORANGE},  // Policy_3  (Delayed Auth Locked)
   {1'b1,DFX_VISA_RED},     // Policy_2  (Security Unlocked)
   {1'b0,DFX_VISA_BLACK},   // Policy_1  (Functionality Locked)
   {1'b0,DFX_VISA_GREEN}}   // Policy_0  (Security Locked)
)
 (
  //PGCB ClockDomain
  input   logic       pgcb_clk,                   //PGCB clock; always running - as long as the PMA's clock is active
  input   logic       pgcb_rst_b,                 //Reset with de-assert synchronized to pgcb_clk - not used
                                                  // internally pok_reset_b is used for both domains
  //Master Clock Domain
  input   logic       clock,                      //Master clock: EP clock
  output  logic       clkreq,                     //Async (glitch free) clock request to disable
  input   logic       clkack,                     //Async (glitch free) clock request acknowledge
  input   logic       pok_reset_b,                //Asynchronous reset for POK
  output  logic       pok,                        //Power ok indication, synchronous
    
  //Gated Clock Domain
  input   logic [AREQ-1:0] gclock_req_async,      //Async (glitch free) gclock requests
  output  logic [AREQ-1:0] gclk_async_ack_synced, //Clock req ack for each gclock_req_async in this CDC's domain.

  input   logic [NUM_EP_ATTACHED-1:0][2:0] ism_fabric,//IOSF Fabric ISM.  Tie to zero for non-IOSF domains. 
  input   logic [NUM_EP_ATTACHED-1:0][2:0] ism_agent, //IOSF Agent ISM.  Tie to zero for non-IOSF domains. 
  output  logic       ism_lock_b,                     //Indicates that the ISMs for this domain should be locked  
    
  //Configuration - static 
  input   logic       cfg_clkgate_disabled,       //0: Don't allow idle-based clock gating
  input   logic       cfg_clkreq_ctl_disabled,    //0: Don't allow de-assertion of clkreq when idle
  input   logic [3:0] cfg_clkgate_holdoff,        //0: Min time from idle to clock gating; 2^value in clocks
  input   logic [3:0] cfg_pwrgate_holdoff,        //0: Min time from clock gate to power gate ready; 2^value in clocks
  input   logic [3:0] cfg_clkreq_off_holdoff,     //4: Min time from locking to !clkreq; 2^value in clocks
  input   logic [3:0] cfg_clkreq_syncoff_holdoff, //4: Min time from ck gate to !clkreq (powerGateDisabled)
    
  //CDC Aggregateion and Control (synchronous to pgcb_clk domain)
  input   logic       forcepgpok_pok,             // bit[0] of the type field in a ForcePwrGatePOK message from the local PMA
  input   logic       forcepgpok_pgreq,           // bit[1] of the type field in a ForcePwrGatePOK message from the local PMA
  input   logic       ip_pg_wake,                 //PMC wake signal - pre sync; after sync (PGCB clock domain) pwrgate_pmc_wake
                                                    //even if never power gated if new wake event occurs.    

  //Test Controls
  input   logic       fismdfx_force_clkreq,       //DFx force assert clkreq
  input   logic [1:0] fscan_byprst_b,             //Scan reset bypass value - pgsb, pok
  input   logic [1:0] fscan_rstbypen,             //Scan reset bypass enable
  input               fscan_shiften,
  input               fscan_latchopen,
  input               fscan_latchclosed_b,
  input               fscan_clkungate,
  input               fscan_clkungate_syn,
  input               fscan_mode,
  input               fscan_sdi,
  output logic        ascan_sdo,

  //Visa
  input   logic [8:0]  fglobal_visa_start_id_pgcb_clk,
  input   logic [8:0]  fglobal_visa_start_id_clk,
  input   logic        fvisa_serstrb,   // lintra s-0527, s-70036 "Used by VISA ULM when inserted"
  input   logic        fvisa_frame,     // lintra s-0527, s-70036 "Used by VISA ULM when inserted"
  input   logic        fvisa_serdata,   // lintra s-0527, s-70036 "Used by VISA ULM when inserted"

  output  logic [7:0]  avisa_debug_data_pgcb_clk, // lintra s-2058 "Used when ULM is inserted"
  output  logic        avisa_strb_clk_pgcb_clk,    // lintra s-2058 "Used when ULM is inserted"

  output  logic [15:0] avisa_debug_data_clk, // lintra s-2058 "Used when ULM is inserted"
                                            // gpsb side_clk to the adl comes from the ccdu
  output  logic [1:0]  avisa_strb_clk_clock,
  // DFs secure policy interface
  input                        fdfx_powergood,
  input [DFX_SECURE_WIDTH-1:0] fdfx_secure_policy,
  input                        fdfx_earlyboot_exit,
  input                        fdfx_policy_update,
  input [DFX_SECURE_WIDTH-1:0] oem_secure_policy
 
  
  );

   localparam          DRIVE_POK = 1;

   logic               clock_l;
   logic               clk_rcb_free;

   /////////////////////////////////
   // instantiate an rcb_lcb to terminate the clock distribution
   /////////////////////////////////


   // Free running RCB
   hqm_rcfwl_gclk_make_clk_and_rcb_free i_rcfwl_gclk_make_clk_and_rcb_free
   (
   .CkRcbX1N(clk_rcb_free),
   .CkGridX1N(clock),
   .Fd( 1'b0),
   .Rd(1'b1)
   );

 // Free running LCB
 hqm_rcfwl_gclk_make_lcb_loc_and i_rcfwl_gclk_make_lcb_loc_and_free
   (
   .CkLcbXPN(clock_l),
   .CkRcbXPN(clk_rcb_free),
   .FcEn(1'b1),
   .LPEn(1'b1),
   .LPOvrd(1'b0),
   .FscanClkUngate(1'b0)
   );

   //CDC VISA Signals
   logic [23:0]       cdc_visa;                      // lintra s-70036 "Used by VISA ULM when inserted"
   // dfx signals left deliberately unconnected
   logic       nc_dfxsecure_feature_en;
   logic       visa_all_dis;
   logic       visa_customer_dis;

   
   // replicate bitwise OR of ISM bits based on the parameter NUM_EP_ATTACHED
   logic [2:0] ored_ism_fabric, ored_ism_agent;
   logic [2:0] intermediate_fabric[NUM_EP_ATTACHED-1:0];
   logic [2:0] intermediate_agent[NUM_EP_ATTACHED-1:0];

   generate
      genvar   i;
      for (i = 0; i < NUM_EP_ATTACHED; i++)
        begin : num_ep
           if (i == 0)
             begin
                assign intermediate_fabric[i] = ism_fabric[0];
                assign intermediate_agent[i]  = ism_agent[0];
             end
           else
             begin
                assign intermediate_fabric[i] = intermediate_fabric[i-1] | ism_fabric[i]; 
                assign intermediate_agent[i]  = intermediate_agent[i-1]  | ism_agent[i];
             end
        end
   endgenerate
   
   assign ored_ism_fabric = intermediate_fabric[NUM_EP_ATTACHED-1];
   assign ored_ism_agent  = intermediate_agent[NUM_EP_ATTACHED-1];

   // or the ism_agent bits together to create the gclk_req_sync
   logic gclk_req_sync, gclk_req_sync_q;
   assign gclk_req_sync = ored_ism_fabric[2] | ored_ism_fabric[1] | ored_ism_fabric[0];

   always_ff @(posedge clock_l)
     begin
        gclk_req_sync_q <= gclk_req_sync;
     end
   
   logic pgcb_rst_pgcb_synced_b;
   hqm_rcfwl_dft_reset_sync #(.STRAP(2'd0)) cdcwrap_pgsb_dft_reset_sync (.clk_in(pgcb_clk),
                                                                       .rst_b(pok_reset_b),
                                                                       .fscan_rstbyp_sel(fscan_rstbypen[0]),
                                                                       .fscan_byprst_b(fscan_byprst_b[0]),
                                                                       .synced_rst_b(pgcb_rst_pgcb_synced_b));
   
   logic pgcb_rst_clock_synced_b;
   hqm_rcfwl_dft_reset_sync #(.STRAP(2'b0)) cdcwrap_clck_dft_reset_sync (.clk_in(clock_l),
                                                                     .rst_b(pok_reset_b),
                                                                     .fscan_rstbyp_sel(fscan_rstbypen[0]),
                                                                     .fscan_byprst_b(fscan_byprst_b[0]),
                                                                     .synced_rst_b(pgcb_rst_clock_synced_b));

/* -----\/----- EXCLUDED -----\/-----
   logic pok_reset_b_synced;
   rcfwl_dft_reset_sync #(.STRAP(2'd2)) cdcwrap_pok_reset_sync (.clk_in(clock_l),
                                                                .rst_b(pok_reset_b),
                                                                .fscan_rstbyp_sel(fscan_rstbypen[0]),
                                                                .fscan_byprst_b(fscan_byprst_b[0]),
                                                                .synced_rst_b(pok_reset_b_synced));
 -----/\----- EXCLUDED -----/\----- */
   

   // replicate the sync cells for the gclock_ack_async based on the parameter 
   logic [AREQ-1:0] gclk_ack_async;
   generate
      genvar j;
      for (j = 0; j < AREQ; j++)
        begin : acksync
           hqm_rcfwl_ctech_doublesync_rstb cdcwrap_doublesync_ack (.d(gclk_ack_async[j]),
                                                                   .o(gclk_async_ack_synced[j]),
                                                                   .clk(clock_l),
                                                                   .rstb(pgcb_rst_clock_synced_b));
        end
   endgenerate
      
   logic pwrgate_pmc_wake;
   // synchronize the wake coming from the PMA
   hqm_rcfwl_ctech_doublesync_rstb cdcwrap_doublesync_ipwake (.d(ip_pg_wake),
                                                          .o(pwrgate_pmc_wake),
                                                          .clk(pgcb_clk),
                                                          .rstb(pgcb_rst_pgcb_synced_b));

   // OR together the two types and then put the result through an edge detector
   // NOTE: changed to metacells due to implementation in rlink and oobmsm where the input clock is 
   // not the same as the clock generating the signals
   logic force_pwr_gate_pok, forcepgpok_pgreq_q, forcepgpok_pok_q;

   hqm_rcfwl_ctech_doublesync cdcwrap_doublesync_pgreq (.d(forcepgpok_pgreq),
                                                    .o(forcepgpok_pgreq_q),
                                                    .clk(pgcb_clk));
                                                    
   hqm_rcfwl_ctech_doublesync cdcwrap_doublesync_pok (.d(forcepgpok_pok),
                                                  .o(forcepgpok_pok_q),
                                                  .clk(pgcb_clk));
   
   assign force_pwr_gate_pok = ((({forcepgpok_pgreq_q, forcepgpok_pok_q}) == 2'b01) ||
                                (({forcepgpok_pgreq_q, forcepgpok_pok_q}) == 2'b11));
   
   // logic that takes the pwrgate_ready output and feeds it back into cdc
   logic pwrgate_ready;
   logic fpgpok_or, fpgpok_and;
   logic pwrgate_rdy_b;
   logic pgcb_pok, pgcb_pok_b;
   logic pwrgate_force, pgcb_pwrgate_active;
   
   always_ff @(posedge pgcb_clk or negedge pgcb_rst_pgcb_synced_b)
     begin
        if (!pgcb_rst_pgcb_synced_b)
          begin
             pgcb_pok <= 1'b0;
             pwrgate_force <= 1'b0;
          end
        else
          begin
             pgcb_pok <= pwrgate_rdy_b;
             pwrgate_force <= fpgpok_and;
          end
     end

   always_comb
     begin
        pwrgate_rdy_b = !pwrgate_ready;
        pgcb_pok_b = !pgcb_pok;
        pgcb_pwrgate_active = pgcb_pok_b | pwrgate_ready;
        fpgpok_or = force_pwr_gate_pok | pwrgate_force;
        fpgpok_and = fpgpok_or && pgcb_pok;
     end

   // HSD: 1406399473
   // add logic to flop ism_lock output before sending to the endpoint to help with timing
   // flop ~ism_locked out of the CDC and OR it with |ism_agent[2:0] before outputting to the endpoint again
   // also make sure ism_lock_b is low before forwarding the pok
   // deassertion of pok happens first and then the ism_lock, that sequence is preserved
   // also flow the pok output.
   // flop the ism agent/fabric bits before toing into the cdc

   logic ism_locked, ism_locked_b, ism_locked_bq, pok_int ;
   logic [2:0] ism_fabric_q, ism_agent_q;
   logic       pok_int2;
/* -----\/----- EXCLUDED -----\/-----
   always_ff @(posedge clock_l)
     begin
        pok           <= pok_int2;
     end
 -----/\----- EXCLUDED -----/\----- */
   // used as a metaflop with scan
   hqm_rcfwl_dft_reset_sync #(.STRAP(2'd2)) cdcwrap_pok_reset_sync (.clk_in(clock_l),
                                                                .rst_b(pok_int2), // input
                                                                .fscan_rstbyp_sel(fscan_rstbypen[0]),
                                                                .fscan_byprst_b(fscan_byprst_b[0]),
                                                                .synced_rst_b(pok)); // output

   
   always_ff @(posedge clock_l or negedge pgcb_rst_clock_synced_b)
     if (!pgcb_rst_clock_synced_b) begin
        ism_fabric_q  <= '0;
        ism_agent_q   <= '0;
        ism_locked_bq <= '0;
     end else begin
        ism_fabric_q  <= ored_ism_fabric;
        ism_agent_q   <= ored_ism_agent;
        ism_locked_bq <= ism_locked_b;
     end

   always_comb
     begin
        ism_locked_b = ~ism_locked;                   // invert output of CDC to active low
        ism_lock_b   = ism_locked_bq | ored_ism_agent[2] | ored_ism_agent[1] | ored_ism_agent[0];
        pok_int2     = ism_lock_b | pok_int;
     end
   // end of change

   // input [RST+DRIVE_POK:0]
   // bit [0] was meant to override the reset_b inputs - which are not used and which were parameterized with RST (min value = 1)
   // bit [1] is the override for the pok_reset_b
   // bit [2] set to [0] - overrides the pgcb_reset_b
   logic [2:0] cdc_fscan_byprst_b; 
   assign cdc_fscan_byprst_b = {fscan_byprst_b[1],fscan_byprst_b[1:0]};
   logic [2:0] cdc_fscan_rstbypen;
   assign cdc_fscan_rstbypen = {fscan_rstbypen[1],fscan_rstbypen[1:0]};  
   
hqm_rcfwl_ClockDomainController #(
    .DEF_PWRON(DEF_PWRON),
    .ITBITS(ITBITS),                                   // support up to 2^4 timer values
    .RST(1'b1),
    .AREQ(AREQ),
    .DRIVE_POK(DRIVE_POK),
    .ISM_AGT_IS_NS(1'b0),
    .RSTR_B4_FORCE(1'b0),
    .PRESCC(1'b0),
    .DSYNC_CG_EN(1'b0),
    .FLOP_CG_EN(1'b0),
    .CG_LOCK_ISM(1'b0)
) CDC (
    //PGCB ClockDomain
  .pgcb_clk(pgcb_clk),                            //PGCB clock; always running
  .pgcb_rst_b(pgcb_rst_pgcb_synced_b),            //Reset with de-assert synchronized to pgcb_clk
        
    //Master Clock Domain
  .clock(clock_l),                                  //Master clock
  .prescc_clock(1'b0),                            //pre-SCC version of Master clock (tie to 0 if PRESCC parameter is '0')
  .reset_b(1'b0),                              //Asynchronous ungated reset.  reset_b[0] must be deepest reset for the domain.
  .reset_sync_b(),                    // lintra s-60024b "purposefully NOT USED - Version of reset_b with de-assertion synchronized to clock"
  .clkreq(clkreq),                                //Async (glitch free) clock request to disable
  .clkack(clkack),                                //Async (glitch free) clock request acknowledge
  .pok_reset_b(pok_reset_b),                      //Asynchronous reset for POK
  .pok(pok_int),                                      //Power ok indication, synchronous
    
  .gclock_enable_final(),             // lintra s-60024b " purposefully NOT USED - Final enable signal to clock-gate
        
    //Gated Clock Domain
  .gclock(),                          // lintra s-60024b "purposefully NOT USED - Gated version of the clock"
  .greset_b(),                        // lintra s-60024b "purposefully NOT USED - Gated version of reset_sync_b
  .gclock_req_sync(gclk_req_sync_q),              //Synchronous gclock request.  // created for !idle for fabric ism
  .gclock_req_async(gclock_req_async),            //Async (glitch free) gclock requests
  .gclock_ack_async(gclk_ack_async),              //Clock req ack for each gclock_req_async in this CDC's domain.
  .gclock_active(),                   // lintra s-60024b "purposefully NOT USED - Indication that gclock is running."
  .ism_fabric(ism_fabric_q),                   //IOSF Fabric ISM.  Tie to zero for non-IOSF domains. 
  .ism_agent(ism_agent_q),                     //IOSF Agent ISM.  Tie to zero for non-IOSF domains. 
  .ism_locked(ism_locked),                        //Indicates that the ISMs for this domain should be locked  
  .boundary_locked(),                 // lintra s-60024b "purposefully NOT USED Indicates that all non IOSF accesses should be locked out"
    
    //Configuration - Quasi-static
  .cfg_clkgate_disabled(cfg_clkgate_disabled),    //Don't allow idle-based clock gating
  .cfg_clkreq_ctl_disabled(cfg_clkreq_ctl_disabled), //Don't allow de-assertion of clkreq when idle
  .cfg_clkgate_holdoff(cfg_clkgate_holdoff),      //Min time from idle to clock gating; 2^value in clocks
  .cfg_pwrgate_holdoff(cfg_pwrgate_holdoff),      //Min time from clock gate to power gate ready; 2^value in clocks
  .cfg_clkreq_off_holdoff(cfg_clkreq_off_holdoff), //Min time from locking to !clkreq; 2^value in clocks
  .cfg_clkreq_syncoff_holdoff(cfg_clkreq_syncoff_holdoff), //Min time from ck gate to !clkreq (powerGateDisabled)
    
    //CDC Aggregateion and Control (synchronous to pgcb_clk domain)
  .pwrgate_disabled(1'b1),                        //Don't allow idle-based clock gating; PGCB clock
  .pwrgate_force(pwrgate_force),                  //Force the controller to gate clocks and lock up 
  .pwrgate_pmc_wake(pwrgate_pmc_wake),            //PMC wake signal (after sync); PGCB clock domain
  .pwrgate_ready(pwrgate_ready),                  //Allow power gating in the PGCB clock domain.  Can de-assert
                                                  //even if never power gated if new wake event occurs.    
    
    //PGCB Controls (synchronous to pgcb_clk domain)
  .pgcb_force_rst_b(1'b1),                        //Force for resets to assert
  .pgcb_pok(pgcb_pok),                            //Power OK signal in the PGCB clock domain
  .pgcb_restore(1'b0),                            //A restore is in pregress so  ISMs should unlock
  .pgcb_pwrgate_active(pgcb_pwrgate_active),      //Pwr gating in progress, so keep boundary locked

    //Test Controls
  .fscan_clkungate(fscan_clkungate),              //Test clock ungating control
  .fismdfx_force_clkreq(fismdfx_force_clkreq),    //DFx force assert clkreq
  .fismdfx_clkgate_ovrd(1'b0),                    //DFx force GATE gclock
  .fscan_byprst_b(cdc_fscan_byprst_b),            //Scan reset bypass value - padded since I think the width is wrong
  .fscan_rstbypen(cdc_fscan_rstbypen),            //Scan reset bypass enable
  .fscan_clkgenctrlen(2'b0),                      //Scan clock bypass enable
  .fscan_clkgenctrl(2'b0),                        //Scan clock bypass value
      
    //CDC VISA Signals
  .cdc_visa(cdc_visa)                             // lintra s-70607 "Used by VISA ULM when inserted"
);    


hqm_rcfwl_dfxsecure_plugin 
  #(
    .DFX_NUM_OF_FEATURES_TO_SECURE ( DFX_NUM_OF_FEATURES_TO_SECURE ),
    .DFX_SECURE_WIDTH              ( DFX_SECURE_WIDTH ),
    .DFX_USE_SB_OVR                ( DFX_USE_SB_OVR ),
    .DFX_VISA_BLACK                ( DFX_VISA_BLACK ),
    .DFX_VISA_GREEN                ( DFX_VISA_GREEN ),
    .DFX_VISA_ORANGE               ( DFX_VISA_ORANGE ),
    .DFX_VISA_RED                  ( DFX_VISA_RED    ),
    .DFX_EARLYBOOT_FEATURE_ENABLE  ( DFX_EARLYBOOT_FEATURE_ENABLE ),
    .DFX_SECURE_POLICY_MATRIX      ( DFX_SECURE_POLICY_MATRIX )
    )
   rcfwl_dfxsecure_plugin
     (.fdfx_powergood(fdfx_powergood),
      .fdfx_secure_policy(fdfx_secure_policy),
      .fdfx_earlyboot_exit(fdfx_earlyboot_exit),
      .fdfx_policy_update(fdfx_policy_update),
      .sb_policy_ovr_value('0),
      .oem_secure_policy(oem_secure_policy),
      .dfxsecure_feature_en(nc_dfxsecure_feature_en),
      .visa_all_dis(visa_all_dis),
      .visa_customer_dis(visa_customer_dis));
      
   
endmodule // cdc_wrapper



