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
//
//    FILENAME  : pgcbfsm.sv 
//    DESIGNER  : jwhavica
//    DATE      : 5/24/2012
//
//----------------------------- Revision History -----------------------------//
//      Date         Version   Owner       Description
//      ----------   -------   --------    -------------------------------------
//      05/24/2012   0.01      jwhavica    Initial interface shell
//      06/12/2012   0.02      jwhavica    Initial Implementation
//      06/12/2012   0.05      jwhavica    Renamed Some Signals
//                                         Added pgcb_idle, pgcb_ip_pg_ack_b
//      06/12/2012   0.53      jwhavica    Updated latchen sequence for Isol Latch POR
//                                         Fixed duplicate PWRDWN state and removed
//                                         STATEX from next-state case statement
//                                         Added Delay between CLKGATEACK and next states
//                                         Added Delay between SAVEACK and next states
//      06/12/2012   0.53p1    jwhavica    Temp Workaround for SR simulation issue
//                                         with sleep deassertion before reset deassertion
//                                         temp fix is to not assert sleep during IP-Inacc
//      01/07/2013   0.61      jwhavica    Updates based on 0.61 Integration Guide
//                                         Adding option to disable the forcing of the resets
//                                         based on a tick define to allow for a stop-gap FPGA
//                                         emulation solution for verifying state-retention
//      02/28/2013             jwhavica    Renaming module from pgcbunit to pgcbfsm
//
//
//----------------------------------------------------------------------------//


//--------------------- Overview and Theory of Operation ---------------------//

//----------------------- Detailed Theory of Operation -----------------------//

//--------------------------- Gate Count Estimates ---------------------------//


module hqm_rcfwl_pgcbfsm 
   #(
      parameter DEF_PWRON   = 0,       // If set, the PGCB will reset to a powered on state

      parameter ISOLLATCH_NOSR_EN = 0, // If set, the PGCB will close isolation latches as part of
                                       // IP-Accessible power gating when state retention is
                                       // disabled
   
      parameter DELAY_ASSN_RST = 0     // If set, the reset used by the assertions will be delayed
                                       // by 1 clock, should only set to '1' if the clk input could be
                                       // gated when pgcb_rst_b is synchronized externally
   )
   (
      //-- Clocks/Resets --//
      input  logic clk,
      input  logic pgcb_rst_b,

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

      //-- PGCB VISA Signals --//
      output logic [11:0] pgcbfsm_visa                // Set of internal signals for VISA visibility
   );

   // The number of bits used to implement the Timeout Timer
   localparam CNT_BITS = 8;
   // The number of clocks to count if (cfg_t* == 2'b00)
   localparam LOAD_VAL0 = 1;     // Will be 1 clock
   // The number of clocks to count if (cfg_t* == 2'b01)
   localparam LOAD_VAL1 = 2;     // Will be 2 clocks
   // The number of clocks to count if (cfg_t* == 2'b10)
   localparam LOAD_VAL2 = 8;     // Will be 8 clocks
   // The number of clocks to count if (cfg_t* == 2'b11)
   localparam LOAD_VAL3 = 256;   // Will be 256 clocks

   // Define mapping for ip_pgcb_pg_type
   typedef enum logic [1:0] {
         IPACC     = 2'b00,
         WRST      = 2'b01,
         RSVD      = 2'b10,
         IPINACC   = 2'b11
      } pg_type_typ;
   
   typedef enum logic [4:0] {
         PWRDWN            = 5'h00,
         PWRUPREQ          = 5'h01,
         INACCSRETLOW      = 5'h02,

         CLKSON_SRST       = 5'h03,
         CLKSONACK_SRST    = 5'h04,
         CLKSOFF_SRST      = 5'h05,
         CLKSOFFACK_SRST   = 5'h06,

         INTISOLDIS        = 5'h07,

         POKHIGH1          = 5'h08,
         INACCRSTINACTIV   = 5'h09,
   
         ACCRSTINACTIV     = 5'h0A,
         CLKSON_CP         = 5'h0B,
         CLKSONACK_CP      = 5'h0C,
         CLKSOFF_CP        = 5'h0D,
         CLKSOFFACK_CP     = 5'h0E,
         ACCSRETLOW        = 5'h0F,
         ISOLLATCHEN       = 5'h10,
   
         RESTORE           = 5'h11,
         
         WARMRST           = 5'h12,
         
         PWRSTBLE          = 5'h13,
         POKLOW            = 5'h14,

         ISOLLATCHDIS      = 5'h15,
         ACCSRETHIGH       = 5'h16,
         INTISOLEN         = 5'h17,
         RSTACT            = 5'h18,
         INACCSRETHIGH     = 5'h19,
         PWRDNREQ          = 5'h1A,
         
         WRSTCLKSON        = 5'h1B,
         WRSTCLKSONACK     = 5'h1C,
         WRSTCLKSOFF       = 5'h1D,
         WRSTCLKSOFFACK    = 5'h1E,

         STATEX            = 'x
      } pgcb_fsm_typ;

   pgcb_fsm_typ pgcb_ps, pgcb_ns;
   
   //=============== PGCB Timeout Counter ===============//
   // This counter will be loaded by the PGCB FSM and will decrement by 1 each clock cycle until it
   // reaches 0.  When it reaches 0, it will assert cnt_timeout, indicating to the FSM that the
   // counter has expired.
   logic [1:0] cnt_load_val;
   logic cnt_timeout, cnt_load;
   logic [CNT_BITS-1:0] cnt_val, cnt_nxt;

   always_ff @(posedge clk, negedge pgcb_rst_b) begin
      if (!pgcb_rst_b)
         cnt_val <= '0;
      else
         cnt_val <= cnt_nxt;
   end

   // The counter asserts cnt_timeout when it reaches 0, it will remain asserted until the counter
   // is loaded again
   assign cnt_timeout = (cnt_val=='0);

   // When the FSM asserts cnt_load, the counter loads cnt_load_val
   // Otherwise, if the counter has not expired, it will decrement, if it has already expired, it will remain at 0
   always_comb begin
      if (cnt_load==1) begin
         case (cnt_load_val)
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
   //=============== End PGCB Timeout Counter ===============//


   //=============== Synchronizers ===============//
   logic sync_pmc_pgcb_pg_ack_b;
   logic sync_pmc_pgcb_restore_b;

   generate if (DEF_PWRON==1) begin : DS_GEN_PWRON
      // Synchronize pmc_pgcb_restore_b to the PGCB's clk
      // restore_b should default to 0 if DEF_PWRON==1, otherwise defaults to 1
      // this is to support restore out of reset for IPs that default to powered-on
      hqm_rcfwl_pgcb_ctech_doublesync i_pgcb_ctech_doublesync_lpst_pmc_pgcb_restore_b (
            .d(pmc_pgcb_restore_b),
            .clr_b(pgcb_rst_b),
            .clk(clk),
            .q(sync_pmc_pgcb_restore_b)
         );

      // Synchronize pmc_pgcb_pg_ack_b to the PGCB's clk
      // pg_ack_b should default to 1 if DEF_PWRON==1, otherwise defaults to 0
      hqm_rcfwl_pgcb_ctech_doublesync_lpst i_pgcb_ctech_doublesync_lpst_pmc_pgcb_pg_ack_b (
            .d(pmc_pgcb_pg_ack_b),
            .pst_b(pgcb_rst_b),
            .clk(clk),
            .q(sync_pmc_pgcb_pg_ack_b)
         );
   end else begin : DS_GEN_PWROFF
      hqm_rcfwl_pgcb_ctech_doublesync_lpst i_pgcb_ctech_doublesync_lpst_pmc_pgcb_restore_b (
            .d(pmc_pgcb_restore_b),
            .pst_b(pgcb_rst_b),
            .clk(clk),
            .q(sync_pmc_pgcb_restore_b)
         );

      hqm_rcfwl_pgcb_ctech_doublesync i_pgcb_ctech_doublesync_pmc_pgcb_pg_ack_b (
            .d(pmc_pgcb_pg_ack_b),
            .clr_b(pgcb_rst_b),
            .clk(clk),
            .q(sync_pmc_pgcb_pg_ack_b)
         );
   end endgenerate

   //=============== End Synchronizers ===============//



   //=============== PGCB State Machine ===============//
   

   // Latching logic for pg_type 
   logic last_pg_ack_b;
   pg_type_typ int_pg_type;
   logic int_sleep_en;
   logic int_sleep2_en;
   logic int_restore_b;

   // Removed storage for frc_clk_*_en as the default value may need to be variable
   logic int_frc_clk_srst_cc_en;
   logic int_frc_clk_cp_en;
   assign int_frc_clk_srst_cc_en = ip_pgcb_frc_clk_srst_cc_en;
   assign int_frc_clk_cp_en = ip_pgcb_frc_clk_cp_en;

   // Latch the following inputs when pg_rdy_req_b asserts in the PWRSTBLE state 
   //   - sleep_en
   //   - pg_type
   //
   // Latch restore_b on the rising edge of pg_ack_b
   //
   always_ff @(posedge clk, negedge pgcb_rst_b) begin
      if (!pgcb_rst_b) begin
         last_pg_ack_b        <= DEF_PWRON;
         int_pg_type          <= IPINACC;
         int_sleep_en         <= DEF_PWRON;
         int_sleep2_en        <= DEF_PWRON;
         int_restore_b        <= !DEF_PWRON;
      end else begin
         // Rise edge detect flop for pg_ack_b
         last_pg_ack_b        <= sync_pmc_pgcb_pg_ack_b;

         // Latch restore_b on the rising edge of pg_ack_b
         if (~last_pg_ack_b & sync_pmc_pgcb_pg_ack_b) begin
            int_restore_b     <= sync_pmc_pgcb_restore_b;
         end

         if ((pgcb_ps == PWRSTBLE) & ~ip_pgcb_pg_rdy_req_b) begin

            // Internal storage of pg_type
            int_pg_type       <= pg_type_typ'(ip_pgcb_pg_type);

            // State Retention will only be enabled if sleep_en==1 and the pg_type==IPACC when the
            // PG request is made
            int_sleep_en      <= ((pg_type_typ'(ip_pgcb_pg_type))==IPACC) && ip_pgcb_sleep_en;
            int_sleep2_en     <= ((pg_type_typ'(ip_pgcb_pg_type))==IPACC);
         end
      end
   end

   // Internal indication that isolatation latches should close at appropriate points in the flow
   // - The latches will only close if state-retention is supported (ie IP-Accessible with SR)
   // - or if the ISOLLATCH_NOSR_EN parameter is set, they will close for IP-Accessible with SR disabled
   logic int_isollatch_en;
   assign int_isollatch_en = int_sleep_en || ( (int_pg_type==IPACC) && ISOLLATCH_NOSR_EN); //lintra s-2046 "Potential multibit parameter"

   // State Machine Output Next State Signals
   logic nxt_pgcb_pmc_pg_req_b;
   logic nxt_pgcb_ip_pg_rdy_ack_b;
   logic nxt_pgcb_pok;
   logic nxt_pgcb_restore;
   logic nxt_pgcb_sleep;
   logic nxt_pgcb_sleep2;
   logic nxt_pgcb_isol_latchen;
   logic nxt_pgcb_isol_en_b;
   logic nxt_pgcb_force_rst_b;
   logic nxt_pgcb_idle;
   logic nxt_pgcb_ip_force_clks_on;

 
   // If DEF_PWRON==1, FSM will default to Powered Up otherwise defaults to Powered Down
   localparam pgcb_fsm_typ FSM_DEF = DEF_PWRON ? RESTORE : PWRDWN;
  
   // FSM state flops
   always_ff @(posedge clk, negedge pgcb_rst_b) begin
      if (!pgcb_rst_b)
         pgcb_ps <= FSM_DEF;
      else
         pgcb_ps <= pgcb_ns;
   end

   //----- PGCB Next State Logic -----//
   //
   // -- PWRDWN --
   // TODO: Fill out this table
   always_comb begin
      pgcb_ns = pgcb_ps;

      case (pgcb_ps)
         // Common Power Gate Exit Flow
         PWRDWN :
            /* lintra -60032 */
            if (ip_pgcb_pg_rdy_req_b) begin
               if (int_frc_clk_srst_cc_en)
                  pgcb_ns = CLKSON_SRST;
               else
                  pgcb_ns = PWRUPREQ;
            end
            /* lintra +60032 */
         CLKSON_SRST :
            if (ip_pgcb_force_clks_on_ack) begin
               pgcb_ns = CLKSONACK_SRST;
            end
         CLKSONACK_SRST :
            if (cnt_timeout) begin
               pgcb_ns = PWRUPREQ;
            end

         PWRUPREQ :
            if (sync_pmc_pgcb_pg_ack_b) begin
               pgcb_ns = INACCSRETLOW;
            end
         INACCSRETLOW :
            /* lintra -60032 */
            if (cnt_timeout || int_sleep_en) begin
               if (int_frc_clk_srst_cc_en)
                  pgcb_ns = CLKSOFF_SRST;
               else
                  pgcb_ns = INTISOLDIS;
            end
            /* lintra +60032 */
         
         CLKSOFF_SRST :
            if (!ip_pgcb_force_clks_on_ack) begin
               pgcb_ns = CLKSOFFACK_SRST;
            end
         CLKSOFFACK_SRST :
            if (cnt_timeout) begin
               pgcb_ns = INTISOLDIS;
            end

         INTISOLDIS :
            /* lintra -60032 */
            if (cnt_timeout) begin
               if (int_pg_type==IPACC) 
                  pgcb_ns = ACCRSTINACTIV;
               else
                  pgcb_ns = POKHIGH1;
            end
            /* lintra +60032 */


         // IP-Inaccessible Exit Branch
         POKHIGH1 :
            if (cnt_timeout) begin
               pgcb_ns = INACCRSTINACTIV;
            end
         INACCRSTINACTIV :
            if (cnt_timeout) begin
               pgcb_ns = RESTORE;
            end


         // IP-Accessible Exit Branch
         ACCRSTINACTIV :
            /* lintra -60032 */
            if (cnt_timeout && int_frc_clk_cp_en)
               pgcb_ns = CLKSON_CP;
            else if (cnt_timeout && ip_pgcb_all_pg_rst_up)
               pgcb_ns = ACCSRETLOW;
            /* lintra +60032 */
         
         CLKSON_CP :
            if (ip_pgcb_force_clks_on_ack) begin
               pgcb_ns = CLKSONACK_CP;
            end
         CLKSONACK_CP :
            if (cnt_timeout && ip_pgcb_all_pg_rst_up) begin
               pgcb_ns = CLKSOFF_CP;
            end
         CLKSOFF_CP :
            if (!ip_pgcb_force_clks_on_ack) begin
               pgcb_ns = CLKSOFFACK_CP;
            end
         CLKSOFFACK_CP :
            if (cnt_timeout) begin
               pgcb_ns = ACCSRETLOW;
            end
         
         ACCSRETLOW :
            if (cnt_timeout || !int_sleep2_en) begin 
               pgcb_ns = ISOLLATCHEN;
            end
         ISOLLATCHEN :
            if (cnt_timeout || !int_isollatch_en) begin
               pgcb_ns = RESTORE;
            end
         RESTORE :
            if (sync_pmc_pgcb_restore_b || int_restore_b) begin
               pgcb_ns = PWRSTBLE;
            end

         // Warm Reset Exit Branch
         WARMRST :
            if (ip_pgcb_pg_rdy_req_b && int_frc_clk_srst_cc_en) begin
                  pgcb_ns = WRSTCLKSON;
            end
            else if (ip_pgcb_pg_rdy_req_b && !int_frc_clk_srst_cc_en) begin
               pgcb_ns = PWRSTBLE;
            end
         WRSTCLKSON :
            if (ip_pgcb_force_clks_on_ack) begin
               pgcb_ns = WRSTCLKSONACK;
            end
         WRSTCLKSONACK :
            //if (ip_pgcb_pg_rdy_req_b && cnt_timeout) begin
            if (cnt_timeout) begin
               pgcb_ns = WRSTCLKSOFF;
            end
         WRSTCLKSOFF :
            if (!ip_pgcb_force_clks_on_ack) begin
               pgcb_ns = WRSTCLKSOFFACK;
            end
         WRSTCLKSOFFACK :
            if (cnt_timeout) begin
               pgcb_ns = PWRSTBLE;
            end


         // Common States
         PWRSTBLE :
            if (!ip_pgcb_pg_rdy_req_b) begin
               pgcb_ns = POKLOW;
            end
         POKLOW :
            if (cnt_timeout && (int_pg_type==WRST)) begin
               //if (int_frc_clk_srst_cc_en)
               //   pgcb_ns = WRSTCLKSON;
               //else
                  pgcb_ns = WARMRST;

            // The timeout here is only relevant if pok was deasserted
            // So, flow through if the type is IPACC
            end else if (cnt_timeout || (int_pg_type==IPACC)) begin
               pgcb_ns = ISOLLATCHDIS;
            end


         // Common Power Gate Entry
         ISOLLATCHDIS :
            if (cnt_timeout || !int_isollatch_en) begin
               pgcb_ns = ACCSRETHIGH;
            end
         ACCSRETHIGH :
            if (cnt_timeout || !int_sleep2_en) begin
               pgcb_ns = INTISOLEN;
            end
         INTISOLEN :
            if (cnt_timeout) begin
               pgcb_ns = RSTACT;
            end
         RSTACT :
            if (cnt_timeout) begin
               pgcb_ns = INACCSRETHIGH;
            end
         INACCSRETHIGH :
            if (cnt_timeout || int_sleep_en) begin 
               pgcb_ns = PWRDNREQ;
            end
         PWRDNREQ :
            if (!sync_pmc_pgcb_pg_ack_b) begin
               pgcb_ns = PWRDWN;
            end
         
         default :
            begin
               pgcb_ns = STATEX;
            end
      endcase
   end



   //----- PGCB State Machine Outputs -----//
   // Most of the outputs of the state machine that leave this block will need to be glitch free,
   // thus this case statement is based on the next-state and such outputs are then flopped.
   //
   // The other outputs (cnt_load_val, cnt_load, set_boot_flag, set_abort_flag, clr_abort_flag) are
   // based on state machine transitions and will also look at the present-state.
   //
   // -- nxt_pgcb_ip_pg_ack_b --
   // TODO: Fill out this table
   //
   always_comb begin
      cnt_load_val = '0;
      cnt_load = 0;

      unique case (pgcb_ns)
         PWRDWN :
            begin
               nxt_pgcb_pmc_pg_req_b            = 0;
               nxt_pgcb_ip_pg_rdy_ack_b         = 0;
               nxt_pgcb_pok                     = (int_pg_type==IPACC);
               nxt_pgcb_restore                 = 0;
               nxt_pgcb_sleep                   = 1;
               nxt_pgcb_sleep2                  = 1;
               nxt_pgcb_isol_latchen            = !int_isollatch_en;
               nxt_pgcb_isol_en_b               = 0;
               nxt_pgcb_force_rst_b             = 0;
               nxt_pgcb_idle                    = 1;
               nxt_pgcb_ip_force_clks_on        = 0;
            end
         
         CLKSON_SRST :
            begin
               nxt_pgcb_pmc_pg_req_b            = 0;
               nxt_pgcb_ip_pg_rdy_ack_b         = 0;
               nxt_pgcb_pok                     = (int_pg_type==IPACC);
               nxt_pgcb_restore                 = 0;
               nxt_pgcb_sleep                   = 1;
               nxt_pgcb_sleep2                  = 1;
               nxt_pgcb_isol_latchen            = !int_isollatch_en;
               nxt_pgcb_isol_en_b               = 0;
               nxt_pgcb_force_rst_b             = 0;
               nxt_pgcb_idle                    = 0;
               nxt_pgcb_ip_force_clks_on        = 1;
            end
         
         CLKSONACK_SRST :
            begin
               nxt_pgcb_pmc_pg_req_b            = 0;
               nxt_pgcb_ip_pg_rdy_ack_b         = 0;
               nxt_pgcb_pok                     = (int_pg_type==IPACC);
               nxt_pgcb_restore                 = 0;
               nxt_pgcb_sleep                   = 1;
               nxt_pgcb_sleep2                  = 1;
               nxt_pgcb_isol_latchen            = !int_isollatch_en;
               nxt_pgcb_isol_en_b               = 0;
               nxt_pgcb_force_rst_b             = 0;
               nxt_pgcb_idle                    = 0;
               nxt_pgcb_ip_force_clks_on        = 1;
               
               if (pgcb_ps!=CLKSONACK_SRST) begin
                  cnt_load_val = cfg_tclksonack_srst;
                  cnt_load = 1;
               end
            end

         PWRUPREQ :
            begin
               nxt_pgcb_pmc_pg_req_b            = 1;
               nxt_pgcb_ip_pg_rdy_ack_b         = 0;
               nxt_pgcb_pok                     = (int_pg_type==IPACC);
               nxt_pgcb_restore                 = 0;
               nxt_pgcb_sleep                   = 1;
               nxt_pgcb_sleep2                  = 1;
               nxt_pgcb_isol_latchen            = !int_isollatch_en;
               nxt_pgcb_isol_en_b               = 0;
               nxt_pgcb_force_rst_b             = 0;
               nxt_pgcb_idle                    = 0;
               nxt_pgcb_ip_force_clks_on        = int_frc_clk_srst_cc_en;
            end
         
         INACCSRETLOW :
            begin
               nxt_pgcb_pmc_pg_req_b            = 1;
               nxt_pgcb_ip_pg_rdy_ack_b         = 0;
               nxt_pgcb_pok                     = (int_pg_type==IPACC);
               nxt_pgcb_restore                 = 0;
               // Sleep will deassert here for ip-inaccessible exit;
               nxt_pgcb_sleep                   = int_sleep_en;
               nxt_pgcb_sleep2                  = int_sleep2_en;
               nxt_pgcb_isol_latchen            = !int_isollatch_en;
               nxt_pgcb_isol_en_b               = 0;
               nxt_pgcb_force_rst_b             = 0;
               nxt_pgcb_idle                    = 0;
               nxt_pgcb_ip_force_clks_on        = int_frc_clk_srst_cc_en;
               
               // Only load the counter if this is IP-Inaccessible or if sleep is disabled
               if ( (pgcb_ps!=INACCSRETLOW) && !int_sleep_en) begin
                  cnt_load_val = cfg_tsleepinactiv;
                  cnt_load = 1;
               end
            end
         
         CLKSOFF_SRST :
            begin
               nxt_pgcb_pmc_pg_req_b            = 1;
               nxt_pgcb_ip_pg_rdy_ack_b         = 0;
               nxt_pgcb_pok                     = (int_pg_type==IPACC);
               nxt_pgcb_restore                 = 0;
               nxt_pgcb_sleep                   = int_sleep_en;
               nxt_pgcb_sleep2                  = int_sleep2_en;
               nxt_pgcb_isol_latchen            = !int_isollatch_en;
               nxt_pgcb_isol_en_b               = 0;
               nxt_pgcb_force_rst_b             = 0;
               nxt_pgcb_idle                    = 0;
               nxt_pgcb_ip_force_clks_on        = 0;
            end
         
         CLKSOFFACK_SRST :
            begin
               nxt_pgcb_pmc_pg_req_b            = 1;
               nxt_pgcb_ip_pg_rdy_ack_b         = 0;
               nxt_pgcb_pok                     = (int_pg_type==IPACC);
               nxt_pgcb_restore                 = 0;
               nxt_pgcb_sleep                   = int_sleep_en;
               nxt_pgcb_sleep2                  = int_sleep2_en;
               nxt_pgcb_isol_latchen            = !int_isollatch_en;
               nxt_pgcb_isol_en_b               = 0;
               nxt_pgcb_force_rst_b             = 0;
               nxt_pgcb_idle                    = 0;
               nxt_pgcb_ip_force_clks_on        = 0;
               
               if (pgcb_ps!=CLKSOFFACK_SRST) begin
                  cnt_load_val = cfg_tclksoffack_srst;
                  cnt_load = 1;
               end
            end
         
         INTISOLDIS :
            begin
               nxt_pgcb_pmc_pg_req_b            = 1;
               nxt_pgcb_ip_pg_rdy_ack_b         = 0;
               nxt_pgcb_pok                     = (int_pg_type==IPACC);
               nxt_pgcb_restore                 = 0;
               nxt_pgcb_sleep                   = int_sleep_en;
               nxt_pgcb_sleep2                  = int_sleep2_en;
               nxt_pgcb_isol_latchen            = !int_isollatch_en;
               nxt_pgcb_isol_en_b               = 1;
               nxt_pgcb_force_rst_b             = 0;
               nxt_pgcb_idle                    = 0;
               nxt_pgcb_ip_force_clks_on        = 0;
               
               if (pgcb_ps != INTISOLDIS) begin
                  cnt_load_val = cfg_tdeisolate;
                  cnt_load = 1;
               end
            end
        
        
         POKHIGH1 :
            begin
               nxt_pgcb_pmc_pg_req_b            = 1;
               nxt_pgcb_ip_pg_rdy_ack_b         = 0;
               nxt_pgcb_pok                     = 1;
               nxt_pgcb_restore                 = 0;
               nxt_pgcb_sleep                   = 0;
               nxt_pgcb_sleep2                  = 0;
               nxt_pgcb_isol_latchen            = 1;
               nxt_pgcb_isol_en_b               = 1;
               nxt_pgcb_force_rst_b             = 0;
               nxt_pgcb_idle                    = 0;
               nxt_pgcb_ip_force_clks_on        = 0;
               
               if (pgcb_ps!=POKHIGH1) begin
                  cnt_load_val = cfg_tpokup;
                  cnt_load = 1;
               end
            end
        
         INACCRSTINACTIV :
            begin
               nxt_pgcb_pmc_pg_req_b            = 1;
               nxt_pgcb_ip_pg_rdy_ack_b         = 0;
               nxt_pgcb_pok                     = 1;
               nxt_pgcb_restore                 = 0;
               nxt_pgcb_sleep                   = 0;
               nxt_pgcb_sleep2                  = 0;
               nxt_pgcb_isol_latchen            = 1;
               nxt_pgcb_isol_en_b               = 1;
               nxt_pgcb_force_rst_b             = 1;
               nxt_pgcb_idle                    = 0;
               nxt_pgcb_ip_force_clks_on        = 0;
               
               if (pgcb_ps!=INACCRSTINACTIV) begin
                  cnt_load_val = cfg_tinaccrstup;
                  cnt_load = 1;
               end
            end


         ACCRSTINACTIV :
            begin
               nxt_pgcb_pmc_pg_req_b            = 1;
               nxt_pgcb_ip_pg_rdy_ack_b         = 0;
               nxt_pgcb_pok                     = 1;
               nxt_pgcb_restore                 = 0;
               nxt_pgcb_sleep                   = int_sleep_en;
               nxt_pgcb_sleep2                  = int_sleep2_en;
               nxt_pgcb_isol_latchen            = !int_isollatch_en;
               nxt_pgcb_isol_en_b               = 1;
               nxt_pgcb_force_rst_b             = 1;
               nxt_pgcb_idle                    = 0;
               nxt_pgcb_ip_force_clks_on        = 0;
               
               if (pgcb_ps!=ACCRSTINACTIV) begin
                  cnt_load = 1;
                  /* lintra -60032 */
                  if (!int_frc_clk_cp_en)
                     cnt_load_val = cfg_taccrstup;
                  else
                     cnt_load_val = cfg_trstup2frcclks;
                  /* lintra +60032 */
               end
            end
         
         CLKSON_CP :
            begin
               nxt_pgcb_pmc_pg_req_b            = 1;
               nxt_pgcb_ip_pg_rdy_ack_b         = 0;
               nxt_pgcb_pok                     = 1;
               nxt_pgcb_restore                 = 0;
               nxt_pgcb_sleep                   = int_sleep_en;
               nxt_pgcb_sleep2                  = int_sleep2_en;
               nxt_pgcb_isol_latchen            = !int_isollatch_en;
               nxt_pgcb_isol_en_b               = 1;
               nxt_pgcb_force_rst_b             = 1;
               nxt_pgcb_idle                    = 0;
               nxt_pgcb_ip_force_clks_on        = 1;
            end

         CLKSONACK_CP :
            begin
               nxt_pgcb_pmc_pg_req_b            = 1;
               nxt_pgcb_ip_pg_rdy_ack_b         = 0;
               nxt_pgcb_pok                     = 1;
               nxt_pgcb_restore                 = 0;
               nxt_pgcb_sleep                   = int_sleep_en;
               nxt_pgcb_sleep2                  = int_sleep2_en;
               nxt_pgcb_isol_latchen            = !int_isollatch_en;
               nxt_pgcb_isol_en_b               = 1;
               nxt_pgcb_force_rst_b             = 1;
               nxt_pgcb_idle                    = 0;
               nxt_pgcb_ip_force_clks_on        = 1;
               
               if (pgcb_ps!=CLKSONACK_CP) begin
                  cnt_load_val = cfg_tclksonack_cp;
                  cnt_load = 1;
               end
            end

         CLKSOFF_CP :
            begin
               nxt_pgcb_pmc_pg_req_b            = 1;
               nxt_pgcb_ip_pg_rdy_ack_b         = 0;
               nxt_pgcb_pok                     = 1;
               nxt_pgcb_restore                 = 0;
               nxt_pgcb_sleep                   = int_sleep_en;
               nxt_pgcb_sleep2                  = int_sleep2_en;
               nxt_pgcb_isol_latchen            = !int_isollatch_en;
               nxt_pgcb_isol_en_b               = 1;
               nxt_pgcb_force_rst_b             = 1;
               nxt_pgcb_idle                    = 0;
               nxt_pgcb_ip_force_clks_on        = 0;
            end

         CLKSOFFACK_CP :
            begin
               nxt_pgcb_pmc_pg_req_b            = 1;
               nxt_pgcb_ip_pg_rdy_ack_b         = 0;
               nxt_pgcb_pok                     = 1;
               nxt_pgcb_restore                 = 0;
               nxt_pgcb_sleep                   = int_sleep_en;
               nxt_pgcb_sleep2                  = int_sleep2_en;
               nxt_pgcb_isol_latchen            = !int_isollatch_en;
               nxt_pgcb_isol_en_b               = 1;
               nxt_pgcb_force_rst_b             = 1;
               nxt_pgcb_idle                    = 0;
               nxt_pgcb_ip_force_clks_on        = 0;
               
               if (pgcb_ps!=CLKSOFFACK_CP) begin
                  cnt_load_val = cfg_taccrstup;
                  cnt_load = 1;
               end
            end

         ACCSRETLOW :
            begin
               nxt_pgcb_pmc_pg_req_b            = 1;
               nxt_pgcb_ip_pg_rdy_ack_b         = 0;
               nxt_pgcb_pok                     = 1;
               nxt_pgcb_restore                 = 0;
               nxt_pgcb_sleep                   = 0;
               nxt_pgcb_sleep2                  = 0;
               nxt_pgcb_isol_latchen            = !int_isollatch_en;
               nxt_pgcb_isol_en_b               = 1;
               nxt_pgcb_force_rst_b             = 1;
               nxt_pgcb_idle                    = 0;
               nxt_pgcb_ip_force_clks_on        = 0;
               
               // Only load the counter if sleep is enabled
               if ( (pgcb_ps != ACCSRETLOW) && int_sleep2_en) begin
                  cnt_load_val = cfg_tsleepinactiv;
                  cnt_load = 1;
               end
            end
         
         ISOLLATCHEN :
            begin
               nxt_pgcb_pmc_pg_req_b            = 1;
               nxt_pgcb_ip_pg_rdy_ack_b         = 0;
               nxt_pgcb_pok                     = 1;
               nxt_pgcb_restore                 = 0;
               nxt_pgcb_sleep                   = 0;
               nxt_pgcb_sleep2                  = 0;
               nxt_pgcb_isol_latchen            = 1;
               nxt_pgcb_isol_en_b               = 1;
               nxt_pgcb_force_rst_b             = 1;
               nxt_pgcb_idle                    = 0;
               nxt_pgcb_ip_force_clks_on        = 0;
               
               // Only load the counter if sleep is enabled
               if ( (pgcb_ps != ISOLLATCHEN) && int_isollatch_en) begin
                  cnt_load_val = cfg_tlatchen;
                  cnt_load = 1;
               end
            end
         
         RESTORE :
            begin
               nxt_pgcb_pmc_pg_req_b            = 1;
               nxt_pgcb_ip_pg_rdy_ack_b         = 0;
               nxt_pgcb_pok                     = 1;
               nxt_pgcb_restore                 = !int_restore_b;
               nxt_pgcb_sleep                   = 0;
               nxt_pgcb_sleep2                  = 0;
               nxt_pgcb_isol_latchen            = 1;
               nxt_pgcb_isol_en_b               = 1;
               nxt_pgcb_force_rst_b             = 1;
               nxt_pgcb_idle                    = 0;
               nxt_pgcb_ip_force_clks_on        = 0;
            end
         
        
         WARMRST :
            begin
               nxt_pgcb_pmc_pg_req_b            = 1;
               nxt_pgcb_ip_pg_rdy_ack_b         = 0;
               nxt_pgcb_pok                     = 0;
               nxt_pgcb_restore                 = 0;
               nxt_pgcb_sleep                   = 0;
               nxt_pgcb_sleep2                  = 0;
               nxt_pgcb_isol_latchen            = 1;
               nxt_pgcb_isol_en_b               = 1;
               nxt_pgcb_force_rst_b             = 1;
               nxt_pgcb_idle                    = 0;
               nxt_pgcb_ip_force_clks_on        = 0;
            end
         
         WRSTCLKSON :
            begin
               nxt_pgcb_pmc_pg_req_b            = 1;
               nxt_pgcb_ip_pg_rdy_ack_b         = 0;
               nxt_pgcb_pok                     = 0;
               nxt_pgcb_restore                 = 0;
               nxt_pgcb_sleep                   = 0;
               nxt_pgcb_sleep2                  = 0;
               nxt_pgcb_isol_latchen            = 1;
               nxt_pgcb_isol_en_b               = 1;
               nxt_pgcb_force_rst_b             = 1;
               nxt_pgcb_idle                    = 0;
               nxt_pgcb_ip_force_clks_on        = 1;
            end
         
         WRSTCLKSONACK :
            begin
               nxt_pgcb_pmc_pg_req_b            = 1;
               nxt_pgcb_ip_pg_rdy_ack_b         = 0;
               nxt_pgcb_pok                     = 0;
               nxt_pgcb_restore                 = 0;
               nxt_pgcb_sleep                   = 0;
               nxt_pgcb_sleep2                  = 0;
               nxt_pgcb_isol_latchen            = 1;
               nxt_pgcb_isol_en_b               = 1;
               nxt_pgcb_force_rst_b             = 1;
               nxt_pgcb_idle                    = 0;
               nxt_pgcb_ip_force_clks_on        = 1;
               
               if (pgcb_ps!=WRSTCLKSONACK) begin
                  cnt_load_val = cfg_trsvd0;
                  cnt_load = 1;
               end
            end
         
         WRSTCLKSOFF :
            begin
               nxt_pgcb_pmc_pg_req_b            = 1;
               nxt_pgcb_ip_pg_rdy_ack_b         = 0;
               nxt_pgcb_pok                     = 0;
               nxt_pgcb_restore                 = 0;
               nxt_pgcb_sleep                   = 0;
               nxt_pgcb_sleep2                  = 0;
               nxt_pgcb_isol_latchen            = 1;
               nxt_pgcb_isol_en_b               = 1;
               nxt_pgcb_force_rst_b             = 1;
               nxt_pgcb_idle                    = 0;
               nxt_pgcb_ip_force_clks_on        = 0;
            end
         
         WRSTCLKSOFFACK :
            begin
               nxt_pgcb_pmc_pg_req_b            = 1;
               nxt_pgcb_ip_pg_rdy_ack_b         = 0;
               nxt_pgcb_pok                     = 0;
               nxt_pgcb_restore                 = 0;
               nxt_pgcb_sleep                   = 0;
               nxt_pgcb_sleep2                  = 0;
               nxt_pgcb_isol_latchen            = 1;
               nxt_pgcb_isol_en_b               = 1;
               nxt_pgcb_force_rst_b             = 1;
               nxt_pgcb_idle                    = 0;
               nxt_pgcb_ip_force_clks_on        = 0;
               
               if (pgcb_ps!=WRSTCLKSOFFACK) begin
                  cnt_load_val = cfg_trsvd1;
                  cnt_load = 1;
               end
            end

         
         PWRSTBLE :
            begin
               nxt_pgcb_pmc_pg_req_b            = 1;
               nxt_pgcb_ip_pg_rdy_ack_b         = 1;
               nxt_pgcb_pok                     = 1;
               nxt_pgcb_restore                 = 0;
               nxt_pgcb_sleep                   = 0;
               nxt_pgcb_sleep2                  = 0;
               nxt_pgcb_isol_latchen            = 1;
               nxt_pgcb_isol_en_b               = 1;
               nxt_pgcb_force_rst_b             = 1;
               nxt_pgcb_idle                    = 1;
               nxt_pgcb_ip_force_clks_on        = 0;
            end
         
         POKLOW :
            begin
               nxt_pgcb_pmc_pg_req_b            = 1;
               nxt_pgcb_ip_pg_rdy_ack_b         = 1;
               // Using value from IP instead of latched version if currently 
               // in the PWRSTABLE state as the latching flop
               // is being updated at the same time as the pgcb_pok output flop
               if (pgcb_ps==PWRSTBLE) begin
                   nxt_pgcb_pok                 = (ip_pgcb_pg_type==IPACC);
               end
               else begin
                   nxt_pgcb_pok                 = (int_pg_type==IPACC);
               end
               
               nxt_pgcb_restore                 = 0;
               nxt_pgcb_sleep                   = 0;
               nxt_pgcb_sleep2                  = 0;
               nxt_pgcb_isol_latchen            = 1;
               nxt_pgcb_isol_en_b               = 1;
               nxt_pgcb_force_rst_b             = 1;
               nxt_pgcb_idle                    = 0;
               nxt_pgcb_ip_force_clks_on        = 0;
               
               if ((pgcb_ps!=POKLOW) && (ip_pgcb_pg_type!=IPACC)) begin
                  cnt_load_val = cfg_tpokdown;
                  cnt_load = 1;
               end
            end

         
         ISOLLATCHDIS :
            begin
               nxt_pgcb_pmc_pg_req_b            = 1;
               nxt_pgcb_ip_pg_rdy_ack_b         = 1;
               nxt_pgcb_pok                     = (int_pg_type==IPACC);
               nxt_pgcb_restore                 = 0;
               nxt_pgcb_sleep                   = 0;
               nxt_pgcb_sleep2                  = 0;
               nxt_pgcb_isol_latchen            = !int_isollatch_en;
               nxt_pgcb_isol_en_b               = 1;
               nxt_pgcb_force_rst_b             = 1;
               nxt_pgcb_idle                    = 0;
               nxt_pgcb_ip_force_clks_on        = 0;
               
               // Only load the counter if this if isolation latches are enabled 
               if ( (pgcb_ps != ISOLLATCHDIS) && int_isollatch_en) begin
                  cnt_load_val = cfg_tlatchdis;
                  cnt_load = 1;
               end
            end
         
         ACCSRETHIGH :
            begin
               nxt_pgcb_pmc_pg_req_b            = 1;
               nxt_pgcb_ip_pg_rdy_ack_b         = 1;
               nxt_pgcb_pok                     = (int_pg_type==IPACC);
               nxt_pgcb_restore                 = 0;
               nxt_pgcb_sleep                   = int_sleep_en;
               nxt_pgcb_sleep2                  = int_sleep2_en;
               nxt_pgcb_isol_latchen            = !int_isollatch_en;
               nxt_pgcb_isol_en_b               = 1;
               nxt_pgcb_force_rst_b             = 1;
               nxt_pgcb_idle                    = 0;
               nxt_pgcb_ip_force_clks_on        = 0;
               
               // Only load the counter if this is IP-Accessible with State Retention
               if ( (pgcb_ps != ACCSRETHIGH) && int_sleep2_en) begin
                  cnt_load_val = cfg_tsleepact;
                  cnt_load = 1;
               end
            end
         
         INTISOLEN :
            begin
               nxt_pgcb_pmc_pg_req_b            = 1;
               nxt_pgcb_ip_pg_rdy_ack_b         = 1;
               nxt_pgcb_pok                     = (int_pg_type==IPACC);
               nxt_pgcb_restore                 = 0;
               nxt_pgcb_sleep                   = int_sleep_en;
               nxt_pgcb_sleep2                  = int_sleep2_en;
               nxt_pgcb_isol_latchen            = !int_isollatch_en;
               nxt_pgcb_isol_en_b               = 0;
               nxt_pgcb_force_rst_b             = 1;
               nxt_pgcb_idle                    = 0;
               nxt_pgcb_ip_force_clks_on        = 0;
               
               if (pgcb_ps != INTISOLEN) begin
                  cnt_load_val = cfg_tisolate;
                  cnt_load = 1;
               end
            end
         
         RSTACT :
            begin
               nxt_pgcb_pmc_pg_req_b            = 1;
               nxt_pgcb_ip_pg_rdy_ack_b         = 1;
               nxt_pgcb_pok                     = (int_pg_type==IPACC);
               nxt_pgcb_restore                 = 0;
               nxt_pgcb_sleep                   = int_sleep_en;
               nxt_pgcb_sleep2                  = int_sleep2_en;
               nxt_pgcb_isol_latchen            = !int_isollatch_en;
               nxt_pgcb_isol_en_b               = 0;
               nxt_pgcb_force_rst_b             = 0;
               nxt_pgcb_idle                    = 0;
               nxt_pgcb_ip_force_clks_on        = 0;
               
               if (pgcb_ps != RSTACT) begin
                  cnt_load_val = cfg_trstdown;
                  cnt_load = 1;
               end
            end
         
         INACCSRETHIGH :
            begin
               nxt_pgcb_pmc_pg_req_b            = 1;
               nxt_pgcb_ip_pg_rdy_ack_b         = 1;
               nxt_pgcb_pok                     = (int_pg_type==IPACC);
               nxt_pgcb_restore                 = 0;
               nxt_pgcb_sleep                   = 1;
               nxt_pgcb_sleep2                  = 1;
               nxt_pgcb_isol_latchen            = !int_isollatch_en;
               nxt_pgcb_isol_en_b               = 0;
               nxt_pgcb_force_rst_b             = 0;
               nxt_pgcb_idle                    = 0;
               nxt_pgcb_ip_force_clks_on        = 0;
               
               // Only load the counter if this is IP-Inaccessible or if sleep is disabled
               if ( (pgcb_ps!=INACCSRETHIGH) && !int_sleep_en) begin
                  cnt_load_val = cfg_tsleepact;
                  cnt_load = 1;
               end
            end
         
         PWRDNREQ :
            begin
               nxt_pgcb_pmc_pg_req_b            = 0;
               nxt_pgcb_ip_pg_rdy_ack_b         = 0;
               nxt_pgcb_pok                     = (int_pg_type==IPACC);
               nxt_pgcb_restore                 = 0;
               nxt_pgcb_sleep                   = 1;
               nxt_pgcb_sleep2                  = 1;
               nxt_pgcb_isol_latchen            = !int_isollatch_en;
               nxt_pgcb_isol_en_b               = 0;
               nxt_pgcb_force_rst_b             = 0;
               nxt_pgcb_idle                    = 0;
               nxt_pgcb_ip_force_clks_on        = 0;
            end
         
         default :
            begin
            /* lintra -50002 */ //Lintra doesn't like explicit x assignments for some reason
               nxt_pgcb_pmc_pg_req_b            = 'x;
               nxt_pgcb_ip_pg_rdy_ack_b         = 'x;
               nxt_pgcb_pok                     = 'x;
               nxt_pgcb_restore                 = 'x;
               nxt_pgcb_sleep                   = 'x;
               nxt_pgcb_sleep2                  = 'x;
               nxt_pgcb_isol_latchen            = 'x;
               nxt_pgcb_isol_en_b               = 'x;
               nxt_pgcb_force_rst_b             = 'x;
               nxt_pgcb_idle                    = 'x;
               nxt_pgcb_ip_force_clks_on        = 'x;
            /* lintra +50002 */
            end
      endcase
   end

   // Deglitch flops on state machine outputs that leave the PGCB
   always_ff @(posedge clk, negedge pgcb_rst_b) begin
      if (!pgcb_rst_b) begin
         pgcb_pmc_pg_req_b            <= DEF_PWRON;
         pgcb_ip_pg_rdy_ack_b         <= 1'b0;
         pgcb_pok                     <= DEF_PWRON;
         pgcb_restore                 <= DEF_PWRON;
         pgcb_sleep                   <= !DEF_PWRON;
         pgcb_sleep2                  <= !DEF_PWRON;
         pgcb_isol_latchen            <= 1'b1;
         pgcb_isol_en_b               <= DEF_PWRON;

`ifndef PGCB_FPGA_FORCERST_DIS
         pgcb_force_rst_b             <= DEF_PWRON;
`endif
         pgcb_idle                    <= !DEF_PWRON;
         pgcb_ip_force_clks_on        <= 1'b0;     
      end else begin
         pgcb_pmc_pg_req_b            <= nxt_pgcb_pmc_pg_req_b;
         pgcb_ip_pg_rdy_ack_b         <= nxt_pgcb_ip_pg_rdy_ack_b;
         pgcb_pok                     <= nxt_pgcb_pok;
         pgcb_restore                 <= nxt_pgcb_restore;
         pgcb_sleep                   <= nxt_pgcb_sleep;
         pgcb_sleep2                  <= nxt_pgcb_sleep2;

         pgcb_isol_latchen            <= nxt_pgcb_isol_latchen;
         pgcb_isol_en_b               <= nxt_pgcb_isol_en_b;

`ifndef PGCB_FPGA_FORCERST_DIS
         pgcb_force_rst_b             <= nxt_pgcb_force_rst_b      ;
`endif
         pgcb_idle                    <= nxt_pgcb_idle;     
         pgcb_ip_force_clks_on        <= nxt_pgcb_ip_force_clks_on;     
      end
   end

// Adding option to disable the forcing of the resets based on a tick define
// to allow for a stop-gap FPGA emulation solution for verifying state-retention
`ifdef PGCB_FPGA_FORCERST_DIS
   assign pgcb_force_rst_b       = 1'b1;
`endif
   
   // force_reg_rw will have the same behavior as pgcb_restore, but we provide a separate
   // signal to support changing the behavior more easily going forward
   assign pgcb_restore_force_reg_rw = pgcb_restore;

   // pwrgate_active should be asserted as soon as pg_rdy_req_b asserts in the PWRSTBLE state and should remain asserted
   // until the power-up flow has completed.
   always_comb begin
         pgcb_pwrgate_active = ~ip_pgcb_pg_rdy_req_b || ~pgcb_ip_pg_rdy_ack_b || ~pgcb_idle;
   end

   //=============== End PGCB State Machine ===============//


   //=============== Begin VISA ===============//
   always_comb begin
      pgcbfsm_visa = '0; //Tie unused bits to 0

      pgcbfsm_visa[4:0]  = pgcb_ps;
      pgcbfsm_visa[5]    = ip_pgcb_pg_rdy_req_b;
      pgcbfsm_visa[6]    = sync_pmc_pgcb_pg_ack_b;
      pgcbfsm_visa[7]    = sync_pmc_pgcb_restore_b;
      pgcbfsm_visa[9:8] = int_pg_type;
      pgcbfsm_visa[10]   = int_sleep_en;
      pgcbfsm_visa[11]   = int_isollatch_en;

   end
   //=============== End VISA ===============//


   //=============== Begin Reserved Tieoffs ===============//
   logic [1:0] nc_cfg_trsvd0, nc_cfg_trsvd1, nc_cfg_trsvd2, nc_cfg_trsvd3, nc_cfg_trsvd4;
   
   assign nc_cfg_trsvd0 = cfg_trsvd0;
   assign nc_cfg_trsvd1 = cfg_trsvd1;
   assign nc_cfg_trsvd2 = cfg_trsvd2;
   assign nc_cfg_trsvd3 = cfg_trsvd3;
   assign nc_cfg_trsvd4 = cfg_trsvd4;
   //=============== End Reserved Tieoffs ===============//


   `ifndef INTEL_SVA_OFF
      `include "pgcbfsm.sva"
   `endif
endmodule
