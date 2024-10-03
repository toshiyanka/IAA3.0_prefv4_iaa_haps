//----------------------------------------------------------------------------//
//
//    FILENAME  : pgcbunit.sv
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

//--------------------- Overview and Theory of Operation ---------------------//

//----------------------- Detailed Theory of Operation -----------------------//

//--------------------------- Gate Count Estimates ---------------------------//


module hqm_pgcbunit
   #(
      //-- PGCB Parameters --//
      parameter DEF_PWRON   = 0,          // If set, the PGCB will reset to a powered on state

      parameter ISOLLATCH_NOSR_EN = 0,    // If set, the PGCB will close isolation latches as part of
                                          // IP-Accessible power gating when state retention is
                                          // disabled

      //-- DFx Parameters --//
      parameter UNGATE_TIMER  = 2'b01,    // Value to use for PGCB

      parameter USE_DFX_SEQ   = 1,        // 1=DFx Sequencer is used to determine override values
                                          // 0=Latched PGCB FSM values will be used for override values
   
      parameter DELAY_ASSN_RST = 0        // If set, the reset used by the assertions will be delayed
                                          // by 1 clock, should only set to '1' if the clk input could be
                                          // gated when pgcb_rst_b is synchronized externally
   )
   (
      //-- Clocks/Resets --//
      input  logic clk,
      input  logic pgcb_rst_b,
      input  logic pgcb_tck,
      input  logic fdfx_powergood_rst_b,

      //-- PGCB<->PMC Interface --//
      output logic pgcb_pmc_pg_req_b,
      input  logic pmc_pgcb_pg_ack_b,
      input  logic pmc_pgcb_restore_b,

      //-- PGCB<->IP Interface (Functional) --//
      input  logic [1:0] ip_pgcb_pg_type,             // 2'b00 - IP-Accessible
                                                      // 2'b01 - Warm Reset
                                                      // 2'b10 - Reserved
                                                      // 2'b11 - IP-Inaccessible
      input  logic ip_pgcb_pg_rdy_req_b,
      output logic pgcb_ip_pg_rdy_ack_b,

      output logic pgcb_pok,
      output logic pgcb_restore,
      output logic pgcb_restore_force_reg_rw,

      output logic pgcb_sleep,
      output logic pgcb_sleep2,
      output logic pgcb_isol_latchen,
      output logic pgcb_isol_en_b,

      output logic pgcb_force_rst_b,
      input  logic ip_pgcb_all_pg_rst_up,

      output logic pgcb_idle,
      output logic pgcb_pwrgate_active,               // Indicates that a power-gate flow is in progress
                                                      // and that the fabric ISMs and boundary interfaces
                                                      // must remain locked, unless a restore is
                                                      // occurring
                                                      // Note: unlike other outputs, this signal is
                                                      // combinatorial rather than the output of a flop
      input  logic ip_pgcb_frc_clk_srst_cc_en,
      input  logic ip_pgcb_frc_clk_cp_en,
      output logic pgcb_ip_force_clks_on,
      input  logic ip_pgcb_force_clks_on_ack,

      //-- PGCB<->IP Interface (Configuration)--//
      input  logic ip_pgcb_sleep_en,
      input  logic [1:0] cfg_tsleepinactiv,
      input  logic [1:0] cfg_tdeisolate,
      input  logic [1:0] cfg_tpokup,
      input  logic [1:0] cfg_tinaccrstup,
      input  logic [1:0] cfg_taccrstup,
      input  logic [1:0] cfg_tlatchen,

      input  logic [1:0] cfg_tpokdown,
      input  logic [1:0] cfg_tlatchdis,
      input  logic [1:0] cfg_tsleepact,
      input  logic [1:0] cfg_tisolate,
      input  logic [1:0] cfg_trstdown,
      input  logic [1:0] cfg_tclksonack_srst,
      input  logic [1:0] cfg_tclksoffack_srst,
      input  logic [1:0] cfg_tclksonack_cp,
      input  logic [1:0] cfg_trstup2frcclks,

      input  logic [1:0] cfg_trsvd0,
      input  logic [1:0] cfg_trsvd1,
      input  logic [1:0] cfg_trsvd2,
      input  logic [1:0] cfg_trsvd3,
      input  logic [1:0] cfg_trsvd4,

      //-- PFET Controls --//
      input  logic pmc_pgcb_fet_en_b,                 // PFET Enable from PMC
      output logic pgcb_ip_fet_en_b,                  // PFET Enable with DFx Override, should be connected to IP FET block

      //-- External DFx Override Controls --//
      input  logic fdfx_pgcb_bypass,                  // PGCB DFx Bypass Enable
      input  logic fdfx_pgcb_ovr,                     // PGCB DFx Sequencer Control (1=Power Up, 2=Power Down)
      input  logic fscan_isol_ctrl,                   // DFx Override Value for isol_en_b (if fscan_mode==1)
      input  logic fscan_isol_lat_ctrl,               // DFx Override Value for isol_laten (if fscan_mode==1)
      input  logic fscan_ret_ctrl,                    // DFx Override Value for sleep (if fscan_mode==1)
      input  logic fscan_mode,                        // DFX Override Enabled for sleep

      //-- PGCB VISA Signals --//
      output logic [23:0] pgcb_visa                   // Set of internal signals for VISA visibility

   );

   logic pgcbfsm_sleep;
   logic pgcbfsm_sleep2;
   logic pgcbfsm_isol_latchen;
   logic pgcbfsm_isol_en_b;
   logic pgcbfsm_force_rst_b;
   logic pgcbfsm_pwrgate_active;
   logic pgcbfsm_pok;
   logic [2:0] pgcbdfx_visa;
   logic [11:0] pgcbfsm_visa;

   always_comb begin
      pgcb_visa = '0; //Tie unused bits to 0

      pgcb_visa[14:12]  = pgcbdfx_visa;
      pgcb_visa[11:0]   = pgcbfsm_visa;
   end

   hqm_pgcbfsm 
      #(
         .DEF_PWRON(DEF_PWRON),
         .ISOLLATCH_NOSR_EN(ISOLLATCH_NOSR_EN)
      ) i_pgcbfsm1 (
         .pgcb_sleep(pgcbfsm_sleep),
         .pgcb_sleep2(pgcbfsm_sleep2),
         .pgcb_isol_latchen(pgcbfsm_isol_latchen),
         .pgcb_isol_en_b(pgcbfsm_isol_en_b),
         .pgcb_force_rst_b(pgcbfsm_force_rst_b),
         .pgcb_pwrgate_active(pgcbfsm_pwrgate_active),
         .pgcb_pok(pgcbfsm_pok),
         .*
      );

   hqm_pgcbdfxovr 
      #(
         .UNGATE_TIMER(UNGATE_TIMER),
         .USE_DFX_SEQ(USE_DFX_SEQ)
      ) i_pgcbdfxovr1 (
         .pgcbfsm_sleep(pgcbfsm_sleep),
         .pgcbfsm_sleep2(pgcbfsm_sleep2),
         .pgcbfsm_isol_latchen(pgcbfsm_isol_latchen),
         .pgcbfsm_isol_en_b(pgcbfsm_isol_en_b),
         .pgcb_force_rst_b(pgcbfsm_force_rst_b),
         .pgcb_pwrgate_active(pgcbfsm_pwrgate_active),
         .pgcb_pok(pgcbfsm_pok),
         .pgcb_isol_en_b(pgcb_isol_en_b),
         .pgcb_isol_latchen(pgcb_isol_latchen),
         .dfxovr_force_rst_b(pgcb_force_rst_b),
         .pgcb_sleep(pgcb_sleep),
         .pgcb_sleep2(pgcb_sleep2),
         .dfxovr_fet_en_b(pgcb_ip_fet_en_b),
         .dfxovr_pwrgate_active(pgcb_pwrgate_active),
         .dfxovr_pok(pgcb_pok),
         .*
      );

   `ifndef SVA_OFF
      `include "hqm_pgcbunit.sva"
   `endif
endmodule
