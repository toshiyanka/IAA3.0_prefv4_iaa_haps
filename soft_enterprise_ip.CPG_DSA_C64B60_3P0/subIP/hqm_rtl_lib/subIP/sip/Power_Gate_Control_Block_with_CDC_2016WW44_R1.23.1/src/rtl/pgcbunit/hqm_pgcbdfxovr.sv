//----------------------------------------------------------------------------//
//
//    FILENAME  : pgcbdfxseq.sv 
//    DESIGNER  : jwhavica
//    DATE      : 02/28/2013
//
//----------------------------------------------------------------------------//
//    Intel Proprietary
//    Copyright (C) 2012 Intel Corporation
//    All Rights Reserved
//----------------------------- Revision History -----------------------------//
//      Date         Version   Owner       Description
//      ----------   -------   --------    -------------------------------------
//
//----------------------------------------------------------------------------//

//CLOSED: What reset to use? fdfx_powergood_rst_b
//CLOSED: Should this reset be synced to pgcb_tck? yes

//CLOSED: Does the reset need a scan bypass mux? no
//CLOSED: What happens if fdfx_pgcb_bypass deasserts in a transitional state? This is not supported
//CLOSED: What encoding should be used for the delay timer? See RTL
//CLOSED: UNGATE_TIMER should it be brought up to top level? Yes
//CLOSED: USE_DFX_SEQ should it be brought up to lop level? Yes

//--------------------- Overview and Theory of Operation ---------------------//

//----------------------- Detailed Theory of Operation -----------------------//

//--------------------------- Gate Count Estimates ---------------------------//


module hqm_pgcbdfxovr
   #(
      parameter UNGATE_TIMER  = 2'b01,       // Value to use for PGCB

      parameter USE_DFX_SEQ   = 1            // 1=DFx Sequencer is used to determine override values
                                             // 0=Latched PGCB FSM values will be used for override values
   )
   (
      //-- Clocks/Resets --//
      input  logic pgcb_tck,
      input  logic fdfx_powergood_rst_b,

      input  logic clk,                      // PGCB Functional Clock
      input  logic pgcb_rst_b,               // PGCB Functional Reset

      //-- External DFx Override Controls --//
      input  logic fdfx_pgcb_bypass,         // PGCB DFx Bypass Enable 
      input  logic fdfx_pgcb_ovr,            // PGCB DFx Sequencer Control (1=Power Up, 2=Power Down)
      //-- External Scan Override Controls --//
      input  logic fscan_isol_ctrl,          // Scan Override Value for islo_isol_en_b (if fscan_mode==1)
      input  logic fscan_isol_lat_ctrl,      // Scan Override Value for islo_latchen (if fscan_mode==1)
      input  logic fscan_ret_ctrl,           // Scan Override Value for sleep (if fscan_mode==1) 
      input  logic fscan_mode,               // Scan Override Enabled

      //-- PGCB FSM Outputs --//
      input  logic pgcbfsm_isol_en_b,        // isol_en_b output of PGCB FSM
      input  logic pgcbfsm_isol_latchen,     // latch_en output of PGCB FSM
      input  logic pgcb_force_rst_b,         // force_rst_b output of PGCB FSM
      input  logic pgcbfsm_sleep,            // sleep output of PGCB FSM
      input  logic pgcbfsm_sleep2,           // sleep output of PGCB FSM
      input  logic pmc_pgcb_fet_en_b,        // fet_en_b driven by PMC
      input  logic pgcb_pwrgate_active,      // pwrgate_active indication from PGCB FSM
      input  logic pgcb_pok,                 // pok value from PGCB FSM

      //-- PGCB Outputs --// 
      output logic pgcb_isol_en_b,           // Scan & DFx Overriden value for isol_en_b
      output logic pgcb_isol_latchen,        // Scan & DFx Overriden value for latch_en
      output logic pgcb_sleep,               // Scan & DFx Overridden value for sleep
      output logic pgcb_sleep2,              // Scan & DFx Overridden value for sleep2

      //-- Internal DFx Overrides --//
      output logic dfxovr_force_rst_b,       // DFx Overridden value for force_rst_b
      output logic dfxovr_fet_en_b,          // DFx Overridden value for fet_en_b
      output logic dfxovr_pwrgate_active,    // DFx Overridden value for pwrgate_active
      output logic dfxovr_pok,               // DFx Overridden value for pok

      output logic [2:0] pgcbdfx_visa
   );

   typedef enum logic [2:0] {   
      SQ_ON      = 3'h0,  
      SQ_DN2     = 3'h1,  
      SQ_DN1     = 3'h2,  
      SQ_OFF     = 3'h3,  
      SQ_UP1     = 3'h4,  
      SQ_UP2     = 3'h5,  
      SQ_UP3     = 3'h6,  

      STATEX     = 'x
   } dfxseq_fsm_typ;

   dfxseq_fsm_typ dfxseq_ps, dfxseq_ns;

   //-- Internal DFx Overrides --//
   logic dfxovr_isol_en_b;         // DFx Overridden value for isol_en_b
   logic dfxovr_isol_latchen;      // DFx Overridden value for isol_latchen
   logic dfxovr_sleep_prescan, dfxovr_sleep2_prescan;

   //*****************************************************************************
   // Scan Override Logic
   //*****************************************************************************

      hqm_pgcb_ctech_mux_2to1_gen ctech_mux_isol_en_scan (
         .d1(fscan_isol_ctrl),
         .d2(dfxovr_isol_en_b),
         .s(fscan_mode),
         .o(pgcb_isol_en_b)
      );

      hqm_pgcb_ctech_mux_2to1_gen ctech_mux_isol_latchen_scan (
         .d1(fscan_isol_lat_ctrl),
         .d2(dfxovr_isol_latchen),
         .s(fscan_mode),
         .o(pgcb_isol_latchen)
      );

      hqm_pgcb_ctech_mux_2to1_gen ctech_mux_sleep_scan (
         .d1(fscan_ret_ctrl),
         .d2(dfxovr_sleep_prescan),
         .s(fscan_mode),
         .o(pgcb_sleep)
      );

      hqm_pgcb_ctech_mux_2to1_gen ctech_mux_sleep2_scan (
         .d1(fscan_ret_ctrl),
         .d2(dfxovr_sleep2_prescan),
         .s(fscan_mode),
         .o(pgcb_sleep2)
      );

   //*****************************************************************************
   // USE_DFX_SEQ = 1
   //*****************************************************************************
   generate if (USE_DFX_SEQ==1) begin : SEQ_OVR 
      // If the USE_DFX_SEQ==1, the DFx sequencer will be used to generate the override values
      
      // Override values to drive on the outputs if fdfx_pgcb_bypass=1
      logic dfxval_isol_en_b;
      logic dfxval_isol_latchen;
      logic dfxval_force_rst_b;
      logic dfxval_sleep; 
      logic dfxval_fet_en_b;
      logic dfxval_pwron;
   
      // Rise-edge synchronize dfx_powergood_rst_b to pgcb_tck
      logic sync_fdfx_powergood_rst_b;
      hqm_pgcb_ctech_doublesync i_dfxrst_sync (
            .d(1'b1), 
            .clk(pgcb_tck), 
            .clr_b(fdfx_powergood_rst_b), 
            .q(sync_fdfx_powergood_rst_b)
         );

      //=============== DFx Timeout Counter ===============//
      // This counter will be loaded by the PGCB FSM and will decrement by 1 each clock cycle until it
      // reaches 0.  When it reaches 0, it will assert cnt_timeout, indicating to the FSM that the
      // counter has expired.
      
      // The number of bits used to implement the Timeout Timer
      localparam CNT_BITS = 8;
      // UNGATE_TIMER Decoded Values
      localparam LOAD_VAL0 = 8; 
      localparam LOAD_VAL1 = 16; 
      localparam LOAD_VAL2 = 32;
      localparam LOAD_VAL3 = 256;
      
      logic cnt_timeout, cnt_load;
      logic [CNT_BITS-1:0] cnt_val, cnt_nxt;

      always_ff @(posedge pgcb_tck, negedge sync_fdfx_powergood_rst_b) begin
         if (!sync_fdfx_powergood_rst_b)
            cnt_val <= '0;
         else
            cnt_val <= cnt_nxt;
      end

      // The counter asserts cnt_timeout when it reaches 0, it will remain asserted until the counter
      // is loaded again
      assign cnt_timeout = (cnt_val=='0);

      // When the FSM asserts cnt_load, the counter loads the value associated with UNGATE_TIMER
      // Otherwise, if the counter has not expired, it will decrement, if it has already expired, it will remain at 0
      always_comb begin
         if (cnt_load==1) begin
            case (UNGATE_TIMER)
               2'b00 : cnt_nxt = LOAD_VAL0-1;
               2'b01 : cnt_nxt = LOAD_VAL1-1;
               2'b10 : cnt_nxt = LOAD_VAL2-1;
               2'b11 : cnt_nxt = LOAD_VAL3-1;
            endcase
         end else begin
            if (cnt_timeout==0)
               cnt_nxt = cnt_val - 1;
            else
               cnt_nxt = '0;
         end
      end
      //=============== End DFx Timeout Counter ===============//

      
      //=============== DFx State Machine ===============//
                  
      logic nxt_dfxval_isol_en_b, nxt_dfxval_force_rst_b, nxt_dfxval_sleep, nxt_dfxval_fet_en_b, nxt_dfxval_pwron;
      
      // FSM state flops
      always_ff @(posedge pgcb_tck, negedge sync_fdfx_powergood_rst_b) begin
         if (!sync_fdfx_powergood_rst_b)
            dfxseq_ps <= SQ_ON;
         else
            dfxseq_ps <= dfxseq_ns;
      end
      
      //----- DFx Sequencer Next State Logic -----//
      //
      // -- SQ_UP1 --
      // TODO: Fill out this table
      always_comb begin
         dfxseq_ns = dfxseq_ps;

         case (dfxseq_ps)
            SQ_DN2 :
               begin
                  dfxseq_ns = SQ_DN1;
               end
            SQ_DN1 :
               begin
                  dfxseq_ns = SQ_OFF;
               end
            SQ_OFF :
               if (!fdfx_pgcb_ovr) begin
                  dfxseq_ns = SQ_UP1;
               end
            SQ_UP1 :
               if (cnt_timeout) begin
                  dfxseq_ns = SQ_UP2;
               end
            SQ_UP2 :
               begin
                  dfxseq_ns = SQ_UP3;
               end
            SQ_UP3 :
               begin
                  dfxseq_ns = SQ_ON;
               end
            SQ_ON :
               if (fdfx_pgcb_ovr) begin
                  dfxseq_ns = SQ_DN2;
               end
            
            default :
               begin
                  dfxseq_ns = STATEX;
               end
         endcase
      end

      //----- DFx State Machine Outputs -----//
      // Most of the outputs of the state machine that leave this block will need to be glitch free,
      // thus this case statement is based on the next-state and such outputs are then flopped.
      //
      // -- nxt_pgcb_ip_pg_ack_b --
      // TODO: Fill out this table
      //
      always_comb begin
         cnt_load = 0;

         unique case (dfxseq_ns)
            SQ_ON :
               begin
                  nxt_dfxval_isol_en_b    = 1;
                  nxt_dfxval_force_rst_b  = 1;
                  nxt_dfxval_sleep        = 0;
                  nxt_dfxval_fet_en_b     = 0;
                  nxt_dfxval_pwron        = 1;
               end
            SQ_DN2 :
               begin
                  nxt_dfxval_isol_en_b    = 0;
                  nxt_dfxval_force_rst_b  = 0;
                  nxt_dfxval_sleep        = 0;
                  nxt_dfxval_fet_en_b     = 0;
                  nxt_dfxval_pwron        = 0;
               end
            SQ_DN1 :
               begin
                  nxt_dfxval_isol_en_b    = 0;
                  nxt_dfxval_force_rst_b  = 0;
                  nxt_dfxval_sleep        = 1;
                  nxt_dfxval_fet_en_b     = 0;
                  nxt_dfxval_pwron        = 0;
               end
            SQ_OFF :
               begin
                  nxt_dfxval_isol_en_b    = 0;
                  nxt_dfxval_force_rst_b  = 0;
                  nxt_dfxval_sleep        = 1;
                  nxt_dfxval_fet_en_b     = 1;
                  nxt_dfxval_pwron        = 0;
               end
            SQ_UP1 :
               begin
                  nxt_dfxval_isol_en_b    = 0;
                  nxt_dfxval_force_rst_b  = 0;
                  nxt_dfxval_sleep        = 1;
                  nxt_dfxval_fet_en_b     = 0;
                  nxt_dfxval_pwron        = 0;

                  // Load the counter if we are transitioning into SQ_UP1
                  if (dfxseq_ps!=SQ_UP1) begin
                     cnt_load = 1'b1;
                  end
               end
            SQ_UP2 :
               begin
                  nxt_dfxval_isol_en_b    = 0;
                  nxt_dfxval_force_rst_b  = 0;
                  nxt_dfxval_sleep        = 0;
                  nxt_dfxval_fet_en_b     = 0;
                  nxt_dfxval_pwron        = 0;
               end
            SQ_UP3 :
               begin
                  nxt_dfxval_isol_en_b    = 1;
                  nxt_dfxval_force_rst_b  = 1;
                  nxt_dfxval_sleep        = 0;
                  nxt_dfxval_fet_en_b     = 0;
                  nxt_dfxval_pwron        = 0;
               end
         
            default :
               begin
               /* lintra -50002 */ //Lintra doesn't like explicit x assignments for some reason
                  nxt_dfxval_isol_en_b    = 'x;
                  nxt_dfxval_force_rst_b  = 'x;
                  nxt_dfxval_sleep        = 'x;
                  nxt_dfxval_fet_en_b     = 'x;
                  nxt_dfxval_pwron        = 'x;
               /* lintra +50002 */
               end
         endcase
      end
   
      // Deglitch flops on state machine outputs that leave the PGCB
      always_ff @(posedge pgcb_tck, negedge sync_fdfx_powergood_rst_b) begin
         if (!sync_fdfx_powergood_rst_b) begin
            dfxval_isol_en_b     <= 1;
            dfxval_force_rst_b   <= 1;
            dfxval_sleep         <= 0;
            dfxval_fet_en_b      <= 0;
            dfxval_pwron         <= 0; // Defaults to 0 as the assertion will affect functional signals
                                       // and needs to be qualified with pgcb_bypass which is unknown while in reset
         end else begin
            dfxval_isol_en_b     <= nxt_dfxval_isol_en_b;
            dfxval_force_rst_b   <= nxt_dfxval_force_rst_b;
            dfxval_sleep         <= nxt_dfxval_sleep;
            dfxval_fet_en_b      <= nxt_dfxval_fet_en_b;
            dfxval_pwron         <= nxt_dfxval_pwron & fdfx_pgcb_bypass;
         end
      end

      // Isolation Latch Enables will be overridden with the same value as isol_en_b
      // TODO: [OPEN] can we give SCAN more control on the isolation latch control?
      assign dfxval_isol_latchen = dfxval_isol_en_b;
      //=============== End DFx State Machine ===============//
  
  
      //=============== DFx Override Logic ===============//
      // ctech muxes (mx22 family) are used as they will not glitch 
      // if d1==d2 and d1 and d2 are stable when s changes
      hqm_pgcb_ctech_mux_2to1_gen ctech_mux_isol_en_b (
         .d1(dfxval_isol_en_b),
         .d2(pgcbfsm_isol_en_b),
         .s(fdfx_pgcb_bypass),
         .o(dfxovr_isol_en_b)
      );
      hqm_pgcb_ctech_mux_2to1_gen ctech_mux_isol_latchen (
         .d1(dfxval_isol_latchen),
         .d2(pgcbfsm_isol_latchen),
         .s(fdfx_pgcb_bypass),
         .o(dfxovr_isol_latchen)
      );
      hqm_pgcb_ctech_mux_2to1_gen ctech_mux_force_rst_b (
         .d1(dfxval_force_rst_b),
         .d2(pgcb_force_rst_b),
         .s(fdfx_pgcb_bypass),
         .o(dfxovr_force_rst_b)
      );
      hqm_pgcb_ctech_mux_2to1_gen ctech_mux_fet_en_b (
         .d1(dfxval_fet_en_b),
         .d2(pmc_pgcb_fet_en_b),
         .s(fdfx_pgcb_bypass),
         .o(dfxovr_fet_en_b)
      );
  

      // sleep is special as it has a discrete override during SCAN mode
      hqm_pgcb_ctech_mux_2to1_gen ctech_mux_sleep (
         .d1(dfxval_sleep),
         .d2(pgcbfsm_sleep),
         .s(fdfx_pgcb_bypass),
         .o(dfxovr_sleep_prescan)
      );
      
      hqm_pgcb_ctech_mux_2to1_gen ctech_mux_sleep2 (
         .d1(dfxval_sleep),
         .d2(pgcbfsm_sleep2),
         .s(fdfx_pgcb_bypass),
         .o(dfxovr_sleep2_prescan)
      );


      // If using the DFX Sequencer, pwrgate_active and pok can only safely be forced in one direction
      // as they are functional signals and need to be crossed to the pgcb clock domain
      logic dfxval_pwron_pgc, dfxval_pwron_pgc_b;

      // Synchronize pwron to pgcb clock domain
      hqm_pgcb_ctech_doublesync dfx_pwron_doublesync (
            .d(dfxval_pwron),
            .clr_b(pgcb_rst_b),
            .clk(clk),
            .q(dfxval_pwron_pgc)
         );
      assign dfxval_pwron_pgc_b = ~dfxval_pwron_pgc;

      //If pwron, force pwrgate_active low, note inverted pwron
      hqm_pgcb_ctech_and2_gen i_and2_pwrgate_active(.a(dfxval_pwron_pgc_b), .b(pgcb_pwrgate_active), .y(dfxovr_pwrgate_active));

      //If pwron, force pok high
      assign dfxovr_pok = dfxval_pwron_pgc | pgcb_pok;

      //=============== End DFx Override Logic ===============//
      
         
   end else begin : LAT_OVR
      // If USE_DFX_SEQ==0, then we latch the output values from the PGCB and hold them


      //=============== DFx Latching Logic ===============//
      // If fdfx_pgcb_bypass==1, then we hold the values from the PGCB
      always_latch begin
         if (!fdfx_pgcb_bypass) begin
            dfxovr_isol_en_b        <= pgcbfsm_isol_en_b;
            dfxovr_isol_latchen     <= pgcbfsm_isol_latchen;
            dfxovr_force_rst_b      <= pgcb_force_rst_b;
            dfxovr_fet_en_b         <= pmc_pgcb_fet_en_b;
            dfxovr_sleep_prescan    <= pgcbfsm_sleep;
            dfxovr_sleep2_prescan   <= pgcbfsm_sleep2;
            dfxovr_pwrgate_active   <= pgcb_pwrgate_active;
            dfxovr_pok              <= pgcb_pok;
         end
      end
      
   

      //=============== End DFx Latching Logic ===============//
      
      // If USE_DFX_SEQ==0 then fdfx_pgcb_ovr is not used
      logic nc_fdfx_pgcb_ovr;
      assign nc_fdfx_pgcb_ovr = fdfx_pgcb_ovr;

      logic nc_clk, nc_pgcb_rst_b, nc_pgcb_tck, nc_fdfx_powergood_rst_b;
      assign nc_clk           = clk;
      assign nc_pgcb_rst_b    = pgcb_rst_b;
      assign nc_pgcb_tck      = pgcb_tck;
      assign nc_fdfx_powergood_rst_b = fdfx_powergood_rst_b;
      
      dfxseq_fsm_typ nc_dfxseq_ns;
      assign dfxseq_ps = SQ_ON;
      assign dfxseq_ns = SQ_ON;
      assign nc_dfxseq_ns = dfxseq_ns;

   end endgenerate

   assign pgcbdfx_visa = dfxseq_ps;
   
   `ifndef SVA_OFF
      `include "hqm_pgcbdfxovr.sva"
   `endif

endmodule
