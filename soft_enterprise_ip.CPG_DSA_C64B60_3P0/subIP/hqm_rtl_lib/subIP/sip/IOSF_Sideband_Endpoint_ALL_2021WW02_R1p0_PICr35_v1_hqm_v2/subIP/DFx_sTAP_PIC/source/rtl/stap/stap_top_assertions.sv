//  Collateral Description:
//  dteg-stap
//
//  Source organization:
//  DTEG Engineering Group (DTEG)
//
//  Support Information:
//  HSD: https://hsdes.intel.com/appstore/article/#/dft_services.bugeco/create
//
//  Revision:
//  DTEG_sTAP_2020WW05_RTL1P0_PIC6_V1
//
//  Module <sTAP> :  < put your functional description here in plain text >
//
//------------------------------------------------------------------------------

// *********************************************************************
// Localparameters
// *********************************************************************
module stap_top_assertions #(
parameter STAP_NUMBER_OF_WTAPS_IN_NETWORK_NZ = 1,
parameter STAP_NUMBER_OF_TAPS_MULTIPLY_BY_2  = 2,
parameter STAP_ENABLE_WTAP_NETWORK           = 1,
parameter STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK_NZ= 1,
parameter STAP_ENABLE_TAP_NETWORK= 1,
parameter STAP_ENABLE_TAPC_SEC_SEL= 1,
parameter STAP_ENABLE_TEST_DATA_REGISTERS= 1,
parameter STAP_ENABLE_REMOTE_TEST_DATA_REGISTERS= 1,

`include "stap_params_include.inc"
)
(
input logic stap_fsm_tlrs,
input logic sn_fwtap_capturewr,
input logic sn_fwtap_shiftwr,
input logic ftap_tms,
input logic ftap_tdi,
input logic ftap_tck,
input logic ftap_trst_b,
input logic [(STAP_NUMBER_OF_WTAPS_IN_NETWORK_NZ - 1):0] tapc_wtap_sel,
input logic        fdfx_powergood,
input logic                                              stap_fsm_shift_ir,
input logic                                              stap_fsm_shift_dr,
input logic        atap_tdo,
input logic        atap_tdoen,
input logic        tapc_remove,
input logic        powergood_rst_trst_b,
input  logic [(((STAP_ENABLE_TDO_POS_EDGE == 1) ? 1 : (STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK == 0) ? 1 : STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK) - 1):0] sntapnw_atap_tdo_en,
input logic        sn_fwtap_selectwir,
input logic        stap_selectwir,
input logic        stap_fbscan_runbist_en,
input logic [(((STAP_ENABLE_TDO_POS_EDGE == 1) ? 1 : (STAP_NUMBER_OF_WTAPS_IN_NETWORK == 0) ? 1 : (STAP_WTAP_NETWORK_ONE_FOR_SERIES_ZERO_FOR_PARALLEL == 1) ? 1 : STAP_NUMBER_OF_WTAPS_IN_NETWORK) - 1):0] sn_fwtap_wsi,
input logic        [(STAP_NUMBER_OF_TAPS_MULTIPLY_BY_2 - 1):0]  tapc_select,
input logic        stap_mux_tdo,
input logic       stap_wtapnw_tdo,
input logic       stap_abscan_tdo,
input logic       sntapnw_atap_tdo,
input  logic [(((STAP_ENABLE_TDO_POS_EDGE == 1) ? 1 : (STAP_NUMBER_OF_WTAPS_IN_NETWORK == 0) ? 1 : (STAP_WTAP_NETWORK_ONE_FOR_SERIES_ZERO_FOR_PARALLEL == 1) ? 1 : STAP_NUMBER_OF_WTAPS_IN_NETWORK)- 1):0] sn_awtap_wso,
input logic [(((STAP_ENABLE_TDO_POS_EDGE == 1) ? 1 : (STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK == 0) ? 1 : STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK) - 1):0] sftapnw_ftap_enabletap,
input logic [(((STAP_ENABLE_TDO_POS_EDGE == 1) ? 1 : (STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK == 0) ? 1 : STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK) - 1):0] sftapnw_ftap_enabletdo,
input logic [(STAP_SIZE_OF_EACH_INSTRUCTION - 1):0]      stap_irreg_ireg,
input logic [(((STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS == 0) ? 1 : STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS) - 1):0] tdr_data_out,
input  logic [(((STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS == 0) ? 1 : STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS) - 1):0] tdr_data_in,
input logic [(((STAP_ENABLE_TDO_POS_EDGE == 1) ? 1 : (STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK == 0) ? 1 : STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK) - 1):0] sftapnw_ftap_secsel,
input  logic [(((STAP_ENABLE_TDO_POS_EDGE == 1) ? 1 : (STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK == 0) ? 1 : STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK) - 1):0] sntapnw_atap_tdo2_en,
input  logic [(((STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS == 0) ? 1 :
                    STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS) - 1) : 0]  rtdr_tap_tdo,
input logic [(((STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS == 0) ? 1 :
              STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS) - 1) : 0]  tap_rtdr_irdec,
input logic [(((STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS == 0) ? 1 :
              STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS) - 1) : 0]  tap_rtdr_prog_rst_b,
input logic [(((STAP_RTDR_IS_BUSSED == 0) ? 1 :
            ((STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS == 0) ? 1 :
              STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS)) - 1) : 0] tap_rtdr_tdi,
input logic [(((STAP_RTDR_IS_BUSSED == 0) ? 1 :
            ((STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS == 0) ? 1 :
              STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS)) - 1) : 0] tap_rtdr_capture,
input logic [(((STAP_RTDR_IS_BUSSED == 0) ? 1 :
            ((STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS == 0) ? 1 :
              STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS)) - 1) : 0] tap_rtdr_shift,
input logic [(((STAP_RTDR_IS_BUSSED == 0) ? 1 :
                  ((STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS == 0) ? 1 :
                    STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS)) - 1) : 0] tap_rtdr_update,

input logic [15:0] stap_fsm_state_ps,
input logic        sntapnw_ftap_tdi,
input logic        stap_bscan_select_bscan_internal

);

localparam TWO  = 2;
localparam LOW                                    = 1'b0;
localparam HIGH= 1'b1;
   wire tlrs = stap_fsm_tlrs;
   wire ftap_tms_delayed_by_1ps;
   wire ftap_tdi_delayed_by_1ps;
   wire ftap_tck_delayed_by_1ps;
   wire ftap_trst_b_delayed_by_1ps;
   wire ftap_trst_b_raising_edge_pulse;
   wire ftap_trst_b_falling_edge_pulse;
   wire ftap_tms_pulse;
   wire ftap_tdi_pulse;
   wire capturewr_delayed_by_1ps;
   wire shiftwr_delayed_by_1ps;

   logic [STAP_NUMBER_OF_WTAPS_IN_NETWORK_NZ - 1 : 0] wtap_sel_priority_internal;

   assign #1ps capturewr_delayed_by_1ps    =  sn_fwtap_capturewr;
   assign #1ps shiftwr_delayed_by_1ps      =  sn_fwtap_shiftwr;
   assign #1ps ftap_tms_delayed_by_1ps     =  ftap_tms;
   assign #1ps ftap_tdi_delayed_by_1ps     =  ftap_tdi;
   assign #1ps ftap_tck_delayed_by_1ps     =  ftap_tck;

   assign #1ps ftap_trst_b_delayed_by_1ps  = ftap_trst_b;

   assign ftap_trst_b_raising_edge_pulse = ~ftap_trst_b_delayed_by_1ps &  ftap_trst_b;
   assign ftap_trst_b_falling_edge_pulse =  ftap_trst_b_delayed_by_1ps & ~ftap_trst_b;
   assign ftap_tms_pulse                 = ftap_tms ^ ftap_tms_delayed_by_1ps;
   assign ftap_tdi_pulse                 = ftap_tdi ^ ftap_tdi_delayed_by_1ps;

   assign wtap_sel_priority_internal[STAP_NUMBER_OF_WTAPS_IN_NETWORK_NZ - 1] = tapc_wtap_sel[STAP_NUMBER_OF_WTAPS_IN_NETWORK_NZ - 1];
   generate
      for (genvar a = (STAP_NUMBER_OF_WTAPS_IN_NETWORK_NZ - 1); a > 0; a = a - 1)
      begin:generate_wtap_sel_for_chk
         assign wtap_sel_priority_internal[a - 1] =
            ~(|(wtap_sel_priority_internal[(STAP_NUMBER_OF_WTAPS_IN_NETWORK_NZ - 1):a])) &  tapc_wtap_sel[a - 1];
      end
   endgenerate

`ifdef DFX_COVERAGE_ON
   // =======================================================================
   // COVER_POINT for reset edges happening on positive and negetive edge clk
   // =======================================================================
   // To cover the property of asserting the ftap_trst_b at the posedge of ftap_tck
   // =======================================================================
   always @(posedge ftap_tck_delayed_by_1ps)
   begin
      cov_stap_assert_reset_during_posedge_clk:
      cover property (ftap_trst_b_falling_edge_pulse === HIGH);
   end

   // =======================================================================
   // To cover the property of deasserting the ftap_trst_b at the posedge of ftap_tck
   // =======================================================================
   always @(posedge ftap_tck_delayed_by_1ps)
   begin
      cov_stap_deassert_reset_during_posedge_clk:
      cover property (ftap_trst_b_raising_edge_pulse === HIGH);
   end

   // =======================================================================
   // To cover the property of asserting the ftap_trst_b at the negedge of ftap_tck
   // =======================================================================
   always @(negedge ftap_tck_delayed_by_1ps)
   begin
      cov_stap_assert_reset_during_negedge_clk:
      cover property (ftap_trst_b_falling_edge_pulse === HIGH);
   end

   // =======================================================================
   // To cover the property of deasserting the ftap_trst_b at the negedge of ftap_tck
   // =======================================================================
   always @(negedge ftap_tck_delayed_by_1ps)
   begin
      cov_stap_deassert_reset_during_negedge_clk:
      cover property (ftap_trst_b_raising_edge_pulse === HIGH);
   end

   // ====================================================================
   // COVER_POINT for soft reset
   // ====================================================================
   property prop_stap_soft_reset_01;
      @(posedge ftap_tck)
         ftap_tms ##1 (ftap_tms[*4]);
   endproperty: prop_stap_soft_reset_01
   cov_stap_soft_reset_01: cover property (prop_stap_soft_reset_01);

   // ====================================================================
   // COVER_POINT for glitch on TMS
   // ====================================================================
   property prop_stap_glitch_on_tms_01;
      @(posedge ftap_tck)
         ftap_tms ##1 (ftap_tms[*5]) ##1 (!ftap_tms) ##1 (ftap_tms[*3]);
   endproperty: prop_stap_glitch_on_tms_01
   cov_stap_glitch_on_tms_01: cover property (prop_stap_glitch_on_tms_01);
`endif

`ifndef INTEL_SVA_OFF
`ifndef STAP_SVA_OFF
   `ifdef DFX_ASSERTIONS
      // ====================================================================
      // Check TMS changes only on the negedge of clock
      // To cover the assertion TMS STABLE ON POSEDGE
      // ====================================================================
      property stap_assert_tms_during_posedge_clk;
          @(posedge ftap_tck_delayed_by_1ps)
          disable iff ((fdfx_powergood !== HIGH) || (ftap_trst_b !== HIGH))
          (fdfx_powergood === HIGH) |-> (ftap_tms_pulse === LOW);
      endproperty: stap_assert_tms_during_posedge_clk
      chk_stap_assert_tms_during_posedge_clk_0:
      assert property (stap_assert_tms_during_posedge_clk)
      else $error ("TMS is not asserted at negedge of tck, but asserted at posedge");

      // ====================================================================
      // Check TDI changes only on the negedge of clock
      // To cover the assertion TMS STABLE ON POSEDGE
      // ====================================================================
      // Based on the below PCR the successive sTAP in the network after the 
      // sTAP which is sending the "tdo" on posedge the below assertion will
      // be fired, so commented. 
      // https://vthsd.intel.com/hsd/seg_softip/pcr/default.aspx?pcr_id=57296
      // ====================================================================
      //logic stap_fsm_shift;
      //assign stap_fsm_shift = stap_fsm_shift_ir || stap_fsm_shift_dr;

      //property stap_assert_tdi_during_posedge_clk;
      //    @(posedge ftap_tck_delayed_by_1ps)
      //    disable iff (!stap_fsm_shift)
      //    (fdfx_powergood) |=> (ftap_tdi_pulse === LOW);
      //endproperty: stap_assert_tdi_during_posedge_clk
      //chk_stap_assert_tdi_during_posedge_clk_0:
      //assert property (stap_assert_tdi_during_posedge_clk)
      //else $error ("TDI is not asserted at negedge of tck, but asserted at posedge");


      // ====================================================================
      // Check TDO changes only on a negedge when STAP_ENABLE_TDO_POS_EDGE = 0
      // and TDO changes only on posedge when STAP_ENABLE_TDO_POS_EDGE = 1
      // ====================================================================
      generate
         if (STAP_ENABLE_TDO_POS_EDGE === 0)
         begin:generate_tdo_during_posedge_clk
            property stap_assert_tdo_during_posedge_clk;
               @(ftap_tck) 
                 disable iff ((fdfx_powergood !== HIGH) || (ftap_trst_b !== HIGH))
                 ((stap_fsm_shift_ir || stap_fsm_shift_dr) && (ftap_tms === LOW) && (ftap_tck === HIGH)) |-> $stable(atap_tdo);
            endproperty: stap_assert_tdo_during_posedge_clk
            chk_stap_assert_tdo_during_posedge_clk_0:
            assert property (stap_assert_tdo_during_posedge_clk)
            else $error ("TDO is not asserted at negedge of tck, but asserted at posedge");
         end
         else
         begin:generate_tdo_during_negedge_clk
            property stap_assert_tdo_during_negedge_clk;
               @(ftap_tck) 
                 disable iff ((fdfx_powergood !== HIGH) || (ftap_trst_b !== HIGH))
                 ((stap_fsm_shift_ir || stap_fsm_shift_dr) && (ftap_tms === LOW) && (ftap_tck === LOW)) |-> $stable(atap_tdo);
            endproperty: stap_assert_tdo_during_negedge_clk
            chk_stap_assert_tdo_during_negedge_clk_0:
            assert property (stap_assert_tdo_during_negedge_clk)
            else $error ("TDO is not asserted at posedge of tck, but asserted at posedge");
         end
      endgenerate

      // ====================================================================
      // Check TDO enable is high otherthan states shift_ir and shift_dr states
      // ====================================================================
      generate
         if (STAP_ENABLE_TDO_POS_EDGE === 0)
           begin:generate_tdo_en_high_during_shift_ir_dr
             property stap_tdo_en_high_during_shift_ir_dr;
                @(negedge ftap_tck)
                   disable iff (stap_fsm_tlrs === HIGH)
                      (stap_fsm_shift_ir || stap_fsm_shift_dr) |=> atap_tdoen;
             endproperty: stap_tdo_en_high_during_shift_ir_dr
             chk_stap_tdo_en_high_during_shift_ir_dr_0:
             assert property (stap_tdo_en_high_during_shift_ir_dr) else
                $error ("TDO enable is not high during states shift_ir and shift_dr states");
           end
         else
           begin:generate_tdo_en_high_during_shift_ir_dr_with_tck_posedge
             property stap_tdo_en_high_during_shift_ir_dr_with_tck_posedge;
                @(posedge ftap_tck)
                   disable iff (stap_fsm_tlrs === HIGH)
                      (stap_fsm_shift_ir || stap_fsm_shift_dr) |-> atap_tdoen;
             endproperty: stap_tdo_en_high_during_shift_ir_dr_with_tck_posedge
             chk_stap_tdo_en_high_during_shift_ir_dr_with_tck_posedge_0:
             assert property (stap_tdo_en_high_during_shift_ir_dr_with_tck_posedge) else
                $error ("TDO enable is not high during states shift_ir and shift_dr states with respect to posedge of tck");
           end
      endgenerate

      // ====================================================================
      // Check TAPNW TDI is Equal to TDI when Remove Bit is asserted
      // ====================================================================
      property stap_tapnw_tdi_equals_tdi_when_remove_asserted;
         @(negedge ftap_tck)
         tapc_remove |-> (sntapnw_ftap_tdi === ftap_tdi);
      endproperty : stap_tapnw_tdi_equals_tdi_when_remove_asserted
      chk_stap_tapnw_tdi_equals_tdi_when_remove_asserted :
      assert property (stap_tapnw_tdi_equals_tdi_when_remove_asserted) else
         $error("TAPNW TDI is not Equal to TDI when Remove bit is asserted");

      // ====================================================================
      // Check TDO_EN is Equal to TAP NW TDO_EN when Remove Bit is asserted
      // ====================================================================
      property stap_tdoen_equals_tapnw_tdi_when_remove_asserted;
         @(negedge ftap_tck)
         tapc_remove |-> (atap_tdoen === |sntapnw_atap_tdo_en);
      endproperty : stap_tdoen_equals_tapnw_tdi_when_remove_asserted
      chk_stap_tdoen_equals_tapnw_tdi_when_remove_asserted :
      assert property (stap_tdoen_equals_tapnw_tdi_when_remove_asserted) else
         $error("TDO_EN is not Equal to TAP NW TDO_EN when Remove Bit is asserted");

      // ====================================================================
      // Check Remove Bit is de-asserted at Pwer Good Reset
      // ====================================================================
      property stap_remove_bit_zero_at_powergood_reset;
         @(fdfx_powergood)
         (fdfx_powergood === LOW) |-> (tapc_remove === LOW);
      endproperty : stap_remove_bit_zero_at_powergood_reset
      chk_stap_remove_bit_zero_at_powergood_reset :
      assert property (stap_remove_bit_zero_at_powergood_reset) else
         $error("Remove Bit is asserted at Power Good Reset");
      // ====================================================================
      // Check TLRS is not high when TRST is low
      // ====================================================================
      property stap_tlrs_high_when_trst_low_0;
         @(powergood_rst_trst_b)
            !powergood_rst_trst_b |-> (tlrs === HIGH);
      endproperty : stap_tlrs_high_when_trst_low_0

      chk_stap_tlrs_high_when_trst_low_0: assert property (stap_tlrs_high_when_trst_low_0)
      else $error("TLRS is not high when TRST is LOW");


      // ====================================================================
      // Check TMS is not high when TRST is LOW
      // ====================================================================
      //Commenting out the assertion for HSD: 1909222184
	  //property stap_tms_high_when_trst_is_low_0;
      //   @(negedge ftap_tck)
      //      disable iff (fdfx_powergood !== HIGH)
      //      (!ftap_trst_b) |-> (ftap_tms === HIGH);
      //endproperty : stap_tms_high_when_trst_is_low_0

      //chk_stap_tms_high_when_trst_is_low_0:
      //assert property (stap_tms_high_when_trst_is_low_0) else
      //   $error("Error: TMS is not high when TRST is LOW.");

      // ====================================================================
      // To Check for all the SELECT_WIR signals
      // ====================================================================
      generate
         if (STAP_ENABLE_WTAP_NETWORK === 1)
         begin:generate_chk_select_wir
               always @(posedge ftap_tck)
               begin
                  if (stap_fsm_tlrs === LOW)
                  begin
                     chk_wtapnw_selectwir_equals_wtap_sel:
                        assert property (sn_fwtap_selectwir === stap_selectwir)
                        else $error("WTAP_SELECT_WIR Logic is not equal to select_wir or not_wtap_sel");
                  end
               end
         end
      endgenerate

      // ====================================================================
      // To Check for all the SELECT_WSI signals
      // ====================================================================
      generate
         if (STAP_ENABLE_WTAP_NETWORK === 1)
         begin:generate_chk_wsi
            for (genvar b = 0; b < STAP_NUMBER_OF_WTAPS_IN_NETWORK_NZ; b = b + 1)
            begin
               always @(posedge ftap_tck)
               begin
                  if (stap_fsm_tlrs === LOW)
                  begin
                     if(wtap_sel_priority_internal[b] === 1'b0)
                     begin
                        chk_wtapnw_wsi_high_when_not_sel:
                        assert property (sn_fwtap_wsi[b] === 1'b1)
                        else $error("WTAP_SELECT_WSI is not High when not selected");
                     end
                     if(wtap_sel_priority_internal[b] === 1'b1 & (~(|(tapc_select))))
                     begin
                        chk_wtapnw_wsi_muxtdo_when_sel:
                        assert property (sn_fwtap_wsi[b] === stap_mux_tdo)
                        else $error("WTAP_SELECT_WSI is not Mux tdo when selected");
                     end
                     if(|(tapc_select)) begin
                        chk_wtapnw_wsi_high_when_tapnw_sel:
                           assert property (sn_fwtap_wsi[b] === 1'b1)
                        else $error("WTAP_SELECT_WSI is high when tapnw is selected");
                     end
                  end
               end
            end
         end
      endgenerate
      // ====================================================================
      // To Check for the TDO Control and TDO out signals
      // ====================================================================
      generate
         if (STAP_ENABLE_WTAP_NETWORK === 1)
         begin:generate_chk_wtap_tdo
            for (genvar c = 0; c < STAP_NUMBER_OF_WTAPS_IN_NETWORK_NZ; c = c + 1)
            begin
               always @(posedge ftap_tck)
               begin
                  if (stap_fsm_tlrs === LOW)
                  begin
                     if(wtap_sel_priority_internal[c] === 1'b1 & (~(|(tapc_select))))
                     begin
                        chk_wtapnw_tdo_wsi_sel:
                        assert property (stap_wtapnw_tdo === sn_awtap_wso[c])
                        else $error("WTAP TDO is not equal to the WSO of the wtap selected");
                     end
                  end
               end
            end
         end
      endgenerate

//********************************************************************************************************************
      // ====================================================================
      // Check WTAP controls sn_fwtap_capturewr changes only on a negedge 
      // of ftap_tck when parameter STAP_ENABLE_WTAP_CTRL_POS_EDGE = 0
      // ====================================================================
      property stap_assert_sn_fwtap_capturewr_during_negedge_clk;
         @(capturewr_delayed_by_1ps)
           disable iff ((fdfx_powergood !== HIGH) || (ftap_trst_b !== HIGH))
           (STAP_ENABLE_WTAP_CTRL_POS_EDGE === LOW) |-> (ftap_tck === LOW);
      endproperty: stap_assert_sn_fwtap_capturewr_during_negedge_clk
      chk_stap_assert_sn_fwtap_capturewr_during_negedge_clk:
      assert property (stap_assert_sn_fwtap_capturewr_during_negedge_clk)
      else $error ("sn_fwtap_capturewr is not asserted at negedge of tck when STAP_ENABLE_WTAP_CTRL_POS_EDGE = 0, but asserted at posedge");

      // ====================================================================
      // Check WTAP controls sn_fwtap_shiftwr changes only on a negedge 
      // of ftap_tck when parameter STAP_ENABLE_WTAP_CTRL_POS_EDGE = 0
      // ====================================================================
      property stap_assert_sn_fwtap_shiftwr_during_negedge_clk;
         @(shiftwr_delayed_by_1ps)
           disable iff ((fdfx_powergood !== HIGH) || (ftap_trst_b !== HIGH))
           (STAP_ENABLE_WTAP_CTRL_POS_EDGE === LOW) |-> (ftap_tck === LOW);
      endproperty: stap_assert_sn_fwtap_shiftwr_during_negedge_clk
      chk_stap_assert_sn_fwtap_shiftwr_during_negedge_clk:
      assert property (stap_assert_sn_fwtap_shiftwr_during_negedge_clk)
      else $error ("sn_fwtap_shiftwr is not asserted at negedge of tck when STAP_ENABLE_WTAP_CTRL_POS_EDGE = 0, but asserted at posedge");

      // ====================================================================
      // Check WTAP controls sn_fwtap_capturewr changes only on a posedge 
      // of ftap_tck when parameter STAP_ENABLE_WTAP_CTRL_POS_EDGE = 1
      // ====================================================================
      property stap_assert_sn_fwtap_capturewr_during_posedge_clk;
         @(capturewr_delayed_by_1ps)
           disable iff ((fdfx_powergood !== HIGH) || (ftap_trst_b !== HIGH))
           (STAP_ENABLE_WTAP_CTRL_POS_EDGE === HIGH) |-> (ftap_tck === HIGH);
      endproperty: stap_assert_sn_fwtap_capturewr_during_posedge_clk
      chk_stap_assert_sn_fwtap_capturewr_during_posedge_clk:
      assert property (stap_assert_sn_fwtap_capturewr_during_posedge_clk)
      else $error ("sn_fwtap_capturewr is not asserted at posedge of tck when STAP_ENABLE_WTAP_CTRL_POS_EDGE = 1, but asserted at negedge");

      // ====================================================================
      // Check WTAP controls sn_fwtap_shiftwr changes only on a posedge 
      // of ftap_tck when parameter STAP_ENABLE_WTAP_CTRL_POS_EDGE = 1
      // ====================================================================
      property stap_assert_sn_fwtap_shiftwr_during_posedge_clk;
         @(shiftwr_delayed_by_1ps)
           disable iff ((fdfx_powergood !== HIGH) || (ftap_trst_b !== HIGH))
           (STAP_ENABLE_WTAP_CTRL_POS_EDGE === HIGH) |-> (ftap_tck === HIGH);
      endproperty: stap_assert_sn_fwtap_shiftwr_during_posedge_clk
      chk_stap_assert_sn_fwtap_shiftwr_during_posedge_clk:
      assert property (stap_assert_sn_fwtap_shiftwr_during_posedge_clk)
      else $error ("sn_fwtap_shiftwr is not asserted at posedge of tck when STAP_ENABLE_WTAP_CTRL_POS_EDGE = 1, but asserted at negedge");

//********************************************************************************************************************
      // ======================================================================
      // To Check for the TDO Control and TDO out signals based on the priority
      // logic implmented in sTAP.
      // ======================================================================

      logic gen_select_bscan_internal;

     // generate:stap_bscan
     //    if (STAP_ENABLE_BSCAN === 1)
     //       begin:generate_chk_bscan_sel
     //          //assign gen_select_bscan_internal = generate_stap_bscan.i_stap_bscan.select_bscan_internal;
     //          assign gen_select_bscan_internal = stap_bscan_select_bscan_internal;
     //       end
     //    else
     //       begin
     //          assign gen_select_bscan_internal = LOW;
     //       end
     // endgenerate
assign gen_select_bscan_internal = stap_bscan_select_bscan_internal;

      always @(posedge ftap_tck)
      begin
         if (stap_fsm_tlrs === LOW && tapc_remove === LOW)
         begin
            //-----------------------------------------------------------------
            //if( ((select_bscan_internal === 1'b1) | (lcl_fbscan_runbist === 1'b1)) &
            if( ((gen_select_bscan_internal === 1'b1) | (stap_fbscan_runbist_en === 1'b1)) & (atap_tdoen === 1'b1) &
                (STAP_ENABLE_BSCAN === 1) &
                (stap_fsm_shift_dr === 1) )
            begin
               chk_tdo_fbscan_tdo_bscanreg_sel:
               assert property (atap_tdo === stap_abscan_tdo)
               else $error("TDO is not equal to the Bscan TDO when Bscan is selected and not TAPNW");
            end
            //-----------------------------------------------------------------
            if( (gen_select_bscan_internal === 1'b0)   &
                (stap_fbscan_runbist_en === 1'b0)      &
                (|tapc_select) & (atap_tdoen === 1'b1) &
                (STAP_ENABLE_BSCAN === 0) )
            begin
               chk_tdo_tapnw_tdo_sel:
               assert property (atap_tdo === sntapnw_atap_tdo)
               else $error("TDO is not equal to the TAPNW TDO when tap nw is selected and Boundary Scan is not");
            end
            //-----------------------------------------------------------------
            if( (gen_select_bscan_internal === 1'b0)     &
                (stap_fbscan_runbist_en === 1'b0)        &
                (~(|(tapc_select)))                 &
                (~(|(wtap_sel_priority_internal)))  &
                (STAP_ENABLE_BSCAN === 0) )
            begin
               chk_tdo_int_tdo_no_tapnw_no_wtapnw_no_direct_wtap_sel:
               assert property (atap_tdo === stap_mux_tdo)
               else $error("TDO is not equal to the STAP internal TDO when no TAP in 0.7 is selected and No tap in a WTAP NW is selected and Single WTAP is also not connected");
            end
            //-----------------------------------------------------------------
         end
      end

   // ====================================================================
   // 0.7 TAPNW: Checks if entap is high for Normal, Excluded, Shadow mode.
   // ====================================================================
   logic [(STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK_NZ * 2) - 1:0] select;

   assign select = tapc_select;

   generate
      if (STAP_ENABLE_TAP_NETWORK === 1)
      begin:generate_chk_tapnw_tap_mode
         for (genvar d = 0; d < STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK_NZ; d = d + 1)
         begin
            always @(posedge ftap_tck)
            begin
               if (fdfx_powergood === HIGH)
               begin
                  if ((select[(TWO * d) + 1] | select[(TWO * d)]) === HIGH)
                  begin
                     chk_tapnw_entap_equals_one_for_normal_excluded_shadow_modes:
                     assert (sftapnw_ftap_enabletap[d] === HIGH)
                     else $error("Entap is not supposed to be high for Isolated mode");
                  end
               end
            end
         end
      end
   endgenerate

   // ====================================================================
   // 0.7 TAPNW Checks if entdo is low for Isolated and Shadow mode.
   // ====================================================================
   generate
      if (STAP_ENABLE_TAP_NETWORK === 1)
      begin:generate_chk_tdo_in_isolated_and_shadow_mode
         for (genvar e = 0; e < STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK_NZ; e = e + 1)
         begin
            always @(posedge ftap_tck)
            begin
               if (fdfx_powergood === HIGH)
               begin
                  if ((select[(TWO * e) + 1]  ^ select[(TWO * e)]) === LOW)
                  begin
                     chk_tapnw_entdo_equals_zero_for_isolated_shadow_modes:
                     assert (sftapnw_ftap_enabletdo[e] === LOW)
                     else $error("Entdo is not supposed to be high for Isolated and Shadow modes");
                  end
               end
            end
         end
      end
   endgenerate

   // ====================================================================
   // Check State is TLRS atleast after 5 Clocks of Remove Bit assertion
   // ====================================================================
   property present_state_tlrs_when_remove_asserted;
       @(negedge ftap_tck)
          disable iff (fdfx_powergood !== HIGH)
             $rose(tapc_remove) ##0 tapc_remove[*5] |->  stap_fsm_state_ps === 16'h0001;
             //$rose(tapc_remove) ##0 tapc_remove[*5] |->  i_stap_fsm.state_ps === 16'h0001;
   endproperty : present_state_tlrs_when_remove_asserted
   chk_present_state_tlrs_when_remove_asserted:
   assume property (present_state_tlrs_when_remove_asserted);
   //   else $error ("Present state is not equal to TLRS after 5 Clock Cycle of Remove getting asserted");

   // ====================================================================
   // The assertion of Remove Bit should happen while accessing Remove Register
   // and at UPDR state
   // ====================================================================
   property stap_assertion_remove_bit_at_updr;
      @(ftap_tck)
          disable iff (fdfx_powergood !== HIGH)
          $rose(tapc_remove) |-> (stap_irreg_ireg === 'h14) && (stap_fsm_state_ps === 16'h0100);
          //$rose(tapc_remove) |-> (stap_irreg_ireg === 'h14) && (i_stap_fsm.state_ps === 16'h0100);
   endproperty : stap_assertion_remove_bit_at_updr
   chk_stap_assertion_remove_bit_at_updr:
   assume property (stap_assertion_remove_bit_at_updr);
   //   else $error ("The Remove Bit is not asserted at UPDR and While Remove register is Asserted");
   `endif
 `endif
`endif

//-------------------------------------------------------------------------------------------
// To check for valid address positions in the Parameter STAP_INSTRUCTION_FOR_DATA_REGISTERS
//-------------------------------------------------------------------------------------------
`ifndef INTEL_SVA_OFF
`ifndef STAP_SVA_OFF
   `ifdef DFX_PARAMETER_CHECKER
      `ifndef DFX_FPV_ENABLE

         logic [STAP_SIZE_OF_EACH_INSTRUCTION-1:0] stap_ir_opcode_position [STAP_NUMBER_OF_TOTAL_REGISTERS-1:0];
         int index = 1;

         initial
         begin
            //for (int i=0, k=0; i < STAP_NUMBER_OF_TOTAL_REGISTERS; i++)
            // Slicing enhancement after introducing Secure Opcode feature.
            // Hence ignore lower two bits of color info in each opcode when populating stap_ir_opcode_position array
            for (int i=0, k=2; i < STAP_NUMBER_OF_TOTAL_REGISTERS; i++, k=k+2)
            begin
               for (int j=0; j < STAP_SIZE_OF_EACH_INSTRUCTION; j++, k++)
                  stap_ir_opcode_position[i][j] = STAP_INSTRUCTION_FOR_DATA_REGISTERS[k];
               $display ("stap_ir_opcode_position[%0d] = %0h", i, stap_ir_opcode_position[i]);
            end

            // Mandatory Registers
            // Position 0, 1
            chk_opcode_00:
            assert (stap_ir_opcode_position[0] === {STAP_SIZE_OF_EACH_INSTRUCTION{1'b1}})
            else $fatal ("Parameter STAP_INSTRUCTION_FOR_DATA_REGISTERS is not correct at index: 0");

            // Boundary Scan Mandatory Registers
            if (STAP_ENABLE_BSCAN === 1)
            // Position 2, 3, 4
            begin
               chk_opcode_01:
               assert (stap_ir_opcode_position[index] === 'h01)
               else $fatal ("Parameter STAP_INSTRUCTION_FOR_DATA_REGISTERS is not correct at index:%0d", index);
               index++;
               chk_opcode_08:
               assert (stap_ir_opcode_position[index] === 'h08)
               else $fatal ("Parameter STAP_INSTRUCTION_FOR_DATA_REGISTERS is not correct at index:%0d", index);
               index++;
               chk_opcode_09:
               assert (stap_ir_opcode_position[index] === 'h09)
               else $fatal ("Parameter STAP_INSTRUCTION_FOR_DATA_REGISTERS is not correct at index:%0d", index);
               index++;
            end

            // SLVIDCODE
            // Position 2 or 5
            chk_opcode_0c:
            assert (stap_ir_opcode_position[index] === 'h0c)
            else $fatal ("Parameter STAP_INSTRUCTION_FOR_DATA_REGISTERS is not correct at index:%0d", index);
            index++;

            // Boundary Scan Mandatory Registers
            if (STAP_ENABLE_BSCAN === 1)
            // Position 6, 7
            begin
               chk_opcode_0E:
               assert (stap_ir_opcode_position[index] === 'h0E)
               else $fatal ("Parameter STAP_INSTRUCTION_FOR_DATA_REGISTERS is not correct at index:%0d", index);
               index++;
               chk_opcode_0F:
               assert (stap_ir_opcode_position[index] === 'h0F)
               else $fatal ("Parameter STAP_INSTRUCTION_FOR_DATA_REGISTERS is not correct at index:%0d", index);
               index++;
            end

            // Optional TAPC_SELECT Register
            if (STAP_ENABLE_TAP_NETWORK === 1)
            // Position 3 or 8
            begin
               chk_opcode_11:
               assert (stap_ir_opcode_position[index] === 'h11)
               else $fatal ("Parameter STAP_INSTRUCTION_FOR_DATA_REGISTERS is not correct at index:%0d", index);
               index++;
            end

            // Boundary Scan Optional Registers
            // Position 8 or 9
            if (STAP_ENABLE_BSCAN === 1)
            begin
               chk_opcode_03:
               assert (stap_ir_opcode_position[index] === 'h03)
               else $fatal ("Parameter STAP_INSTRUCTION_FOR_DATA_REGISTERS is not correct at index:%0d", index);
               index++;
            end
            if (STAP_ENABLE_BSCAN === 1)
            // Position 9 or 10
            begin
               chk_opcode_04:
               assert (stap_ir_opcode_position[index] === 'h04)
               else $fatal ("Parameter STAP_INSTRUCTION_FOR_DATA_REGISTERS is not correct at index:%0d", index);
               index++;
            end
            if (STAP_ENABLE_BSCAN === 1)
            // Position 10 or 11
            begin
               chk_opcode_06:
               assert (stap_ir_opcode_position[index] === 'h06)
               else $fatal ("Parameter STAP_INSTRUCTION_FOR_DATA_REGISTERS is not correct at index:%0d", index);
               index++;
            end
            if (STAP_ENABLE_BSCAN === 1)
            // Position 11 or 12
            begin
               chk_opcode_07:
               assert (stap_ir_opcode_position[index] === 'h07)
               else $fatal ("Parameter STAP_INSTRUCTION_FOR_DATA_REGISTERS is not correct at index:%0d", index);
               index++;
            end
            if (STAP_ENABLE_BSCAN === 1)
            // Position 12 or 13
            begin
               chk_opcode_0D:
               assert (stap_ir_opcode_position[index] === 'h0D)
               else $fatal ("Parameter STAP_INSTRUCTION_FOR_DATA_REGISTERS is not correct at index:%0d", index);
               index++;
            end

            // Optional TAPC_SEC_SELECT Register
            if (STAP_ENABLE_TAPC_SEC_SEL === 1)
            // Position 4 or 9
            begin
               chk_opcode_10:
               assert (stap_ir_opcode_position[index] === 'h10)
               else $fatal ("Parameter STAP_INSTRUCTION_FOR_DATA_REGISTERS is not correct at index:%0d", index);
               index++;
            end

            // Optional TAPC_WTAP_SELECT Register
            if (STAP_ENABLE_WTAP_NETWORK === 1)
            // Position 3 or above
            begin
               chk_opcode_13:
               assert (stap_ir_opcode_position[index] === 'h13)
               else $fatal ("Parameter STAP_INSTRUCTION_FOR_DATA_REGISTERS is not correct at index:%0d", index);
               index++;
            end

            // Optional Remove Register
            if (STAP_ENABLE_TAPC_REMOVE === 1)
            // Position 3 or above
            begin
               chk_opcode_14:
               assert (stap_ir_opcode_position[index] === 'h14)
               else $fatal ("Parameter STAP_INSTRUCTION_FOR_DATA_REGISTERS is not correct at index:%0d", index);
               index++;
            end

            // Optional TAPC_TDRRSTEN
            if ((STAP_ENABLE_RTDR_PROG_RST === 1) || (STAP_ENABLE_ITDR_PROG_RST === 1))
            // Position 3 or above
            begin
               chk_opcode_15:
               assert (stap_ir_opcode_position[index] === 'h15)
               else $fatal ("Parameter STAP_INSTRUCTION_FOR_DATA_REGISTERS is not correct at index:%0d", index);
               index++;
            end

            // Optional TAPC_ITDRRSTSEL
            if (STAP_ENABLE_ITDR_PROG_RST === 1)
            // Position 3 or above
            begin
               chk_opcode_16:
               assert (stap_ir_opcode_position[index] === 'h16)
               else $fatal ("Parameter STAP_INSTRUCTION_FOR_DATA_REGISTERS is not correct at index:%0d", index);
               index++;
            end

            // Optional TAPC_RTDRRSTSEL
            if (STAP_ENABLE_RTDR_PROG_RST === 1)
            // Position 3 or above
            begin
               chk_opcode_17:
               assert (stap_ir_opcode_position[index] === 'h17)
               else $fatal ("Parameter STAP_INSTRUCTION_FOR_DATA_REGISTERS is not correct at index:%0d", index);
               index++;
            end

            // TDR
            if ((STAP_ENABLE_TEST_DATA_REGISTERS === 1) || (STAP_ENABLE_REMOTE_TEST_DATA_REGISTERS === 1))
            // Position 3 or above
            begin
               while (index < STAP_NUMBER_OF_TOTAL_REGISTERS)
               begin
                  chk_opcode_lesser_than_h30_or_equals_20_or_21_or_22:
					  assert (((stap_ir_opcode_position[index] >= 'h30) || (stap_ir_opcode_position[index] === 'h22) || (stap_ir_opcode_position[index] === 'h20) || (stap_ir_opcode_position[index] === 'h21))&& 
				  (stap_ir_opcode_position[index] < {STAP_SIZE_OF_EACH_INSTRUCTION{1'b1}}))
                  else $fatal ("Parameter STAP_INSTRUCTION_FOR_DATA_REGISTERS is not correct at index:%0d", index);
                  index++;
               end
            end

            // To check IR register width
            chk_instruction_size_greater_than_8:
            assert (STAP_SIZE_OF_EACH_INSTRUCTION >= 'h8)
            else $fatal ("Parameter STAP_SIZE_OF_EACH_INSTRUCTION is less than 8");

            // To check that when STAP_ENABLE_TDO_POS_EDGE = 1, then other parameters are set to 0 for Bscan, TAPNW, WTAPNW.
            if (STAP_ENABLE_TDO_POS_EDGE === 1)
            begin
               chk_that_for_retimetap_feature_bscan_is_disabled:
               assert (STAP_ENABLE_BSCAN === 0)
               else $fatal ("When the current TAP is used for retime by setting parameter STAP_ENABLE_TDO_POS_EDGE to 1,\n",
                            "you cannot use this TAP for Boundary Scan operations.");

               chk_that_for_retimetap_feature_tapnw_is_disabled:
               assert (STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK === 0)
               else $fatal ("When the current TAP is used for retime by setting parameter STAP_ENABLE_TDO_POS_EDGE to 1,\n",
                            "you cannot use this TAP for Controlling a Sub Tap Network");

               chk_that_for_retimetap_feature_wtapnw_is_disabled:
               assert (STAP_NUMBER_OF_WTAPS_IN_NETWORK === 0)
               else $fatal ("When the current TAP is used for retime by setting parameter STAP_ENABLE_TDO_POS_EDGE to 1,\n",
                            "you cannot use this TAP for Controlling a WTAP Network");
            end

         end
      `endif // DFX_FPV_ENABLE
   `endif // DFX_PARAMETER_CHECKER
 `endif // STAP_SVA_OFF
`endif // INTEL_SVA_OFF

//********************************************************************************************************************
//-------------------------------------------------------------------------------------------
// To check width of the ports which are multiple bits based on the condition
//-------------------------------------------------------------------------------------------
`ifndef INTEL_SVA_OFF
`ifndef STAP_SVA_OFF
   `ifdef DFX_PARAMETER_CHECKER
      `ifndef DFX_FPV_ENABLE

         initial
         begin
            // -----------------------------------------------------------------
            // Check width of Parallel ports of optional data registers
            // -----------------------------------------------------------------
            if (STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS === 0)
            begin
               chk_width_of_port_tdr_data_out_1:
               assert ($size(tdr_data_out) === 1) 
               else $fatal ("The width of port tdr_data_out is not equal 1 when STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS = 0");
               $display ("tdr_data_out_width     = %0d ", $size(tdr_data_out));

               chk_width_of_port_tdr_data_in_1:
               assert ($size(tdr_data_in) === 1) 
               else $fatal ("The width of port tdr_data_in is not equal 1 when STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS = 0");
               $display ("tdr_data_in_width     = %0d ", $size(tdr_data_in));
            end
            else
            begin
               chk_width_of_port_tdr_data_out_2:
               assert ($size(tdr_data_out) === STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS) 
               else $fatal ("The width of port tdr_data_out is not equal to STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS");
               $display ("tdr_data_out_width     = %0d ", $size(tdr_data_out));

               chk_width_of_port_tdr_data_in_2:
               assert ($size(tdr_data_in) === STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS) 
               else $fatal ("The width of port tdr_data_in is not equal to STAP_TOTAL_WIDTH_OF_TEST_DATA_REGISTERS");
               $display ("tdr_data_in_width     = %0d ", $size(tdr_data_in));
            end   

            // -----------------------------------------------------------------
            // Check the width of Control ports to 0.7 TAPNetwork
            // -----------------------------------------------------------------
            if (STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK === 0)
            begin
               chk_width_of_port_sftapnw_ftap_secsel_1:
               assert ($size(sftapnw_ftap_secsel) === 1) 
               else $fatal ("The width of port sftapnw_ftap_secsel is not equal 1 when STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK = 0");
               $display ("sftapnw_ftap_secsel_width     = %0d ", $size(sftapnw_ftap_secsel));

               chk_width_of_port_sftapnw_ftap_enabletdo_1:
               assert ($size(sftapnw_ftap_enabletdo) === 1) 
               else $fatal ("The width of port sftapnw_ftap_enabletdo is not equal 1 when STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK = 0");
               $display ("sftapnw_ftap_enabletdo_width     = %0d ", $size(sftapnw_ftap_enabletdo));

               chk_width_of_port_sftapnw_ftap_enabletap_1:
               assert ($size(sftapnw_ftap_enabletap) === 1) 
               else $fatal ("The width of port sftapnw_ftap_enabletap is not equal 1 when STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK = 0");
               $display ("sftapnw_ftap_enabletap_width     = %0d ", $size(sftapnw_ftap_enabletap));

               chk_width_of_port_sntapnw_atap_tdo_en_1:
               assert ($size(sntapnw_atap_tdo_en) === 1) 
               else $fatal ("The width of port sntapnw_atap_tdo_en is not equal 1 when STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK = 0");
               $display ("sntapnw_atap_tdo_en_width     = %0d ", $size(sntapnw_atap_tdo_en));

               chk_width_of_port_sntapnw_atap_tdo2_en_1:
               assert ($size(sntapnw_atap_tdo2_en) === 1) 
               else $fatal ("The width of port sntapnw_atap_tdo2_en is not equal 1 when STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK = 0");
               $display ("sntapnw_atap_tdo2_en_width     = %0d ", $size(sntapnw_atap_tdo2_en));
            end
            else
            begin
               chk_width_of_port_sftapnw_ftap_secsel_2:
               assert ($size(sftapnw_ftap_secsel) === STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK) 
               else $fatal ("The width of port sftapnw_ftap_secsel is not equal to STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK");
               $display ("sftapnw_ftap_secsel_width     = %0d ", $size(sftapnw_ftap_secsel));

               chk_width_of_port_sftapnw_ftap_enabletdo_3:
               assert ($size(sftapnw_ftap_enabletdo) === STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK) 
               else $fatal ("The width of port sftapnw_ftap_enabletdo is not equal to STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK");
               $display ("sftapnw_ftap_enabletdo_width     = %0d ", $size(sftapnw_ftap_enabletdo));

               chk_width_of_port_sftapnw_ftap_enabletap_2:
               assert ($size(sftapnw_ftap_enabletap) === STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK) 
               else $fatal ("The width of port sftapnw_ftap_enabletap is not equal to STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK");
               $display ("sftapnw_ftap_enabletap_width     = %0d ", $size(sftapnw_ftap_enabletap));

               chk_width_of_port_sntapnw_atap_tdo_en_2:
               assert ($size(sntapnw_atap_tdo_en) === STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK) 
               else $fatal ("The width of port sntapnw_atap_tdo_en is not equal to STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK");
               $display ("sntapnw_atap_tdo_en_width     = %0d ", $size(sntapnw_atap_tdo_en));

               chk_width_of_port_sntapnw_atap_tdo2_en_2:
               assert ($size(sntapnw_atap_tdo2_en) === STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK) 
               else $fatal ("The width of port sntapnw_atap_tdo2_en is not equal to STAP_NUMBER_OF_TAPS_IN_TAP_NETWORK");
               $display ("sntapnw_atap_tdo2_en_width     = %0d ", $size(sntapnw_atap_tdo2_en));
            end   

            // -----------------------------------------------------------------
            // Check the width of Control prots only to WTAP Network
            // -----------------------------------------------------------------
            if ((STAP_NUMBER_OF_WTAPS_IN_NETWORK === 0) || (STAP_WTAP_NETWORK_ONE_FOR_SERIES_ZERO_FOR_PARALLEL === 1))
            begin
               chk_width_of_port_sn_awtap_wso_1:
               assert ($size(sn_awtap_wso) === 1) 
               else $fatal ("The width of port sn_awtap_wso is not equal 1 when STAP_NUMBER_OF_WTAPS_IN_NETWORK = 0");
               $display ("sn_awtap_wso_width     = %0d ", $size(sn_awtap_wso));

               chk_width_of_port_sn_fwtap_wsi_1:
               assert ($size(sn_fwtap_wsi) === 1) 
               else $fatal ("The width of port sn_fwtap_wsi is not equal 1 when STAP_NUMBER_OF_WTAPS_IN_NETWORK = 0");
               $display ("sn_fwtap_wsi_width     = %0d ", $size(sn_fwtap_wsi));
            end
            else
            begin  
               chk_width_of_port_sn_awtap_wso_2:
               assert ($size(sn_awtap_wso) === STAP_NUMBER_OF_WTAPS_IN_NETWORK) 
               else $fatal ("The width of port sn_awtap_wso is not equal to STAP_NUMBER_OF_WTAPS_IN_NETWORK");
               $display ("sn_awtap_wso_en_width     = %0d ", $size(sn_awtap_wso));

               chk_width_of_port_sn_fwtap_wsi_2:
               assert ($size(sn_fwtap_wsi) === STAP_NUMBER_OF_WTAPS_IN_NETWORK) 
               else $fatal ("The width of port sn_fwtap_wsi is not equal to STAP_NUMBER_OF_WTAPS_IN_NETWORK");
               $display ("sn_fwtap_wsi_width     = %0d ", $size(sn_fwtap_wsi));
            end   

            //------------------------------------------------------------------
            // To check the port widths of RTDR
            //------------------------------------------------------------------
            if (STAP_ENABLE_REMOTE_TEST_DATA_REGISTERS === 1)
            begin
               chk_width_of_port_rtdr_tap_tdo_1:
               assert ($size(rtdr_tap_tdo) === STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS) 
               else $fatal ("The width of port rtdr_tap_tdo is not equal to number RTDRs");
               $display ("rtdr_tap_tdo_width  = %0d ", $size(rtdr_tap_tdo));

               chk_width_of_port_tap_rtdr_irdec_1:
               assert ($size(tap_rtdr_irdec) === STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS) 
               else $fatal ("The width of port tap_rtdr_irdec is not equal to number RTDRs");
               $display ("tap_rtdr_irdec_width  = %0d ", $size(tap_rtdr_irdec));

               chk_width_of_port_tap_rtdr_prog_rst_b_1:
               assert ($size(tap_rtdr_prog_rst_b) === STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS) 
               else $fatal ("The width of port tap_rtdr_prog_rst_b is not equal to number RTDRs");
               $display ("tap_rtdr_prog_rst_b_width  = %0d ", $size(tap_rtdr_prog_rst_b));

               if (STAP_RTDR_IS_BUSSED === 1)
               begin  
                  chk_width_of_port_tap_rtdr_tdi_1:
                  assert ($size(tap_rtdr_tdi) === STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS) 
                  else $fatal ("The width of port tap_rtdr_tdi is not equal to number RTDRs when parameter STAP_RTDR_IS_BUSSED = 1");
                  $display ("tap_rtdr_tdi_width     = %0d ", $size(tap_rtdr_tdi));

                  chk_width_of_port_tap_rtdr_capture_1:
                  assert ($size(tap_rtdr_capture) === STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS) 
                  else $fatal ("The width of port tap_rtdr_capture is not equal to number RTDRs when parameter STAP_RTDR_IS_BUSSED = 1");
                  $display ("tap_rtdr_capture_width = %0d ", $size(tap_rtdr_capture));

                  chk_width_of_port_tap_rtdr_shift_1:
                  assert ($size(tap_rtdr_shift) === STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS) 
                  else $fatal ("The width of port tap_rtdr_shift is not equal to number RTDRs when parameter STAP_RTDR_IS_BUSSED = 1");
                  $display ("tap_rtdr_shift_width   = %0d ", $size(tap_rtdr_shift));

                  chk_width_of_port_tap_rtdr_update_1:
                  assert ($size(tap_rtdr_update) === STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS) 
                  else $fatal ("The width of port tap_rtdr_update is not equal to number RTDRs when parameter STAP_RTDR_IS_BUSSED = 1");
                  $display ("tap_rtdr_update_width  = %0d ", $size(tap_rtdr_update));
               end
               else
               begin
                  chk_width_of_port_tap_rtdr_tdi_2:
                  assert ($size(tap_rtdr_tdi) === 1) 
                  else $fatal ("The width of port tap_rtdr_tdi is not equal to 1 when parameter STAP_RTDR_IS_BUSSED = 0");
                  $display ("tap_rtdr_tdi_width     = %0d ", $size(tap_rtdr_tdi));

                  chk_width_of_port_tap_rtdr_capture_2:
                  assert ($size(tap_rtdr_capture) === 1) 
                  else $fatal ("The width of port tap_rtdr_capture is not equal to 1 when parameter STAP_RTDR_IS_BUSSED = 0");
                  $display ("tap_rtdr_capture_width = %0d ", $size(tap_rtdr_capture));

                  chk_width_of_port_tap_rtdr_shift_2:
                  assert ($size(tap_rtdr_shift) === 1) 
                  else $fatal ("The width of port tap_rtdr_shift is not equal to 1 when parameter STAP_RTDR_IS_BUSSED = 0");
                  $display ("tap_rtdr_shift_width   = %0d ", $size(tap_rtdr_shift));

                  chk_width_of_port_tap_rtdr_update_2:
                  assert ($size(tap_rtdr_update) === 1) 
                  else $fatal ("The width of port tap_rtdr_update is not equal to 1 when parameter STAP_RTDR_IS_BUSSED = 0");
                  $display ("tap_rtdr_update_width  = %0d ", $size(tap_rtdr_update));
               end   
            end
            else
            begin
               chk_width_of_port_rtdr_tap_tdo_3:
               assert ($size(rtdr_tap_tdo) === 1) 
               else $fatal ("The width of port rtdr_tap_tdo is not equal 1 when RTDR not selected");
               $display ("rtdr_tap_tdo_width  = %0d ", $size(rtdr_tap_tdo));

               chk_width_of_port_tap_rtdr_irdec_3:
               assert ($size(tap_rtdr_irdec) === 1) 
               else $fatal ("The width of port tap_rtdr_irdec is not equal 1 when RTDR not selected");
               $display ("tap_rtdr_irdec_width  = %0d ", $size(tap_rtdr_irdec));

               chk_width_of_port_tap_rtdr_prog_rst_b_3:
               assert ($size(tap_rtdr_prog_rst_b) === 1) 
               else $fatal ("The width of port tap_rtdr_prog_rst_b is not equal 1 when RTDR not selected");
               $display ("tap_rtdr_prog_rst_b_width  = %0d ", $size(tap_rtdr_prog_rst_b));

               chk_width_of_port_tap_rtdr_tdi_3:
               assert ($size(tap_rtdr_tdi) === 1) 
               else $fatal ("The width of port tap_rtdr_tdi is not equal 1 when RTDR not selected");
               $display ("tap_rtdr_tdi_width     = %0d ", $size(tap_rtdr_tdi));

               chk_width_of_port_tap_rtdr_capture_3:
               assert ($size(tap_rtdr_capture) === 1) 
               else $fatal ("The width of port tap_rtdr_capture is not equal 1 when RTDR not selected");
               $display ("tap_rtdr_capture_width = %0d ", $size(tap_rtdr_capture));

               chk_width_of_port_tap_rtdr_shift_3:
               assert ($size(tap_rtdr_shift) === 1) 
               else $fatal ("The width of port tap_rtdr_shift is not equal 1 when RTDR not selected");
               $display ("tap_rtdr_shift_width   = %0d ", $size(tap_rtdr_shift));

               chk_width_of_port_tap_rtdr_update_3:
               assert ($size(tap_rtdr_update) === 1) 
               else $fatal ("The width of port tap_rtdr_update is not equal 1 when RTDR not selected");
               $display ("tap_rtdr_update_width  = %0d ", $size(tap_rtdr_update));
            end   
         end

logic [4:0] stap_secure_policy_matrix_0  = STAP_DFX_SECURE_POLICY_MATRIX[4:0];
logic [4:0] stap_secure_policy_matrix_1  = STAP_DFX_SECURE_POLICY_MATRIX[9:5];
logic [4:0] stap_secure_policy_matrix_2  = STAP_DFX_SECURE_POLICY_MATRIX[14:10];
logic [4:0] stap_secure_policy_matrix_3  = STAP_DFX_SECURE_POLICY_MATRIX[19:15];
logic [4:0] stap_secure_policy_matrix_4  = STAP_DFX_SECURE_POLICY_MATRIX[24:20];
logic [4:0] stap_secure_policy_matrix_5  = STAP_DFX_SECURE_POLICY_MATRIX[29:25];
logic [4:0] stap_secure_policy_matrix_6  = STAP_DFX_SECURE_POLICY_MATRIX[34:30];
logic [4:0] stap_secure_policy_matrix_7  = STAP_DFX_SECURE_POLICY_MATRIX[39:35];
logic [4:0] stap_secure_policy_matrix_8  = STAP_DFX_SECURE_POLICY_MATRIX[44:40];
logic [4:0] stap_secure_policy_matrix_9  = STAP_DFX_SECURE_POLICY_MATRIX[49:45];
logic [4:0] stap_secure_policy_matrix_10 = STAP_DFX_SECURE_POLICY_MATRIX[54:50];
logic [4:0] stap_secure_policy_matrix_11 = STAP_DFX_SECURE_POLICY_MATRIX[59:55];
logic [4:0] stap_secure_policy_matrix_12 = STAP_DFX_SECURE_POLICY_MATRIX[64:60];
logic [4:0] stap_secure_policy_matrix_13 = STAP_DFX_SECURE_POLICY_MATRIX[69:65];
logic [4:0] stap_secure_policy_matrix_14 = STAP_DFX_SECURE_POLICY_MATRIX[74:70];
logic [4:0] stap_secure_policy_matrix_15 = STAP_DFX_SECURE_POLICY_MATRIX[79:75];

initial
begin
   dfx_stap_secure_policy_matrix_0_assrt: assert (stap_secure_policy_matrix_0 == 5'b00111)
   else $error("STAP_DFX_SECURE_POLICY_MATRIX[4:0] should not be override with 5'b%b",stap_secure_policy_matrix_0); 
   dfx_stap_secure_policy_matrix_1_assrt: assert (stap_secure_policy_matrix_1 == 5'b00111)
   else $error("STAP_DFX_SECURE_POLICY_MATRIX[9:5] should not be override with 5'b%b",stap_secure_policy_matrix_1); 
   dfx_stap_secure_policy_matrix_2_assrt: assert (stap_secure_policy_matrix_2 == 5'b10011)
   else $error("STAP_DFX_SECURE_POLICY_MATRIX[14:10] should not be override with 5'b%b",stap_secure_policy_matrix_2); 
   dfx_stap_secure_policy_matrix_3_assrt: assert (stap_secure_policy_matrix_3 == 5'b00111)
   else $error("STAP_DFX_SECURE_POLICY_MATRIX[19:15] should not be override with 5'b%b",stap_secure_policy_matrix_3); 
   dfx_stap_secure_policy_matrix_4_assrt: assert (stap_secure_policy_matrix_4 == 5'b10011)
   else $error("STAP_DFX_SECURE_POLICY_MATRIX[24:20] should not be override with 5'b%b",stap_secure_policy_matrix_4); 
   dfx_stap_secure_policy_matrix_5_assrt: assert (stap_secure_policy_matrix_5 == 5'b01011)
   else $error("STAP_DFX_SECURE_POLICY_MATRIX[29:25] should not be override with 5'b%b",stap_secure_policy_matrix_5); 
   dfx_stap_secure_policy_matrix_6_assrt: assert (stap_secure_policy_matrix_6[1:0] == 2'b11)
   else $error("STAP_DFX_SECURE_POLICY_MATRIX[31:30] should not be override with 2'b%b",stap_secure_policy_matrix_6[1:0]); 
   dfx_stap_secure_policy_matrix_7_assrt: assert (stap_secure_policy_matrix_7 == 5'b10011)
   else $error("STAP_DFX_SECURE_POLICY_MATRIX[39:35] should not be override with 5'b%b",stap_secure_policy_matrix_7); 
   dfx_stap_secure_policy_matrix_8_assrt: assert (stap_secure_policy_matrix_8 == 5'b01011 || stap_secure_policy_matrix_8 == 5'b00111)
   else $error("STAP_DFX_SECURE_POLICY_MATRIX[44:40] should not be override with 5'b%b",stap_secure_policy_matrix_8); 
   dfx_stap_secure_policy_matrix_9_assrt: assert (stap_secure_policy_matrix_9 == 5'b10011)
   else $error("STAP_DFX_SECURE_POLICY_MATRIX[46:45] should not be override with 5'b%b",stap_secure_policy_matrix_9); 
   dfx_stap_secure_policy_matrix_10_assrt: assert (stap_secure_policy_matrix_10[1:0] == 2'b11)
   else $error("STAP_DFX_SECURE_POLICY_MATRIX[51:50] should not be override with 2'b%b",stap_secure_policy_matrix_10[1:0]); 
   dfx_stap_secure_policy_matrix_11_assrt: assert (stap_secure_policy_matrix_11[1:0] == 2'b11)
   else $error("STAP_DFX_SECURE_POLICY_MATRIX[56:55] should not be override with 2'b%b",stap_secure_policy_matrix_11[1:0]); 
   dfx_stap_secure_policy_matrix_12_assrt: assert (stap_secure_policy_matrix_12[1:0] == 2'b11)
   else $error("STAP_DFX_SECURE_POLICY_MATRIX[61:60] should not be override with 2'b%b",stap_secure_policy_matrix_12[1:0]); 
   dfx_stap_secure_policy_matrix_13_assrt: assert (stap_secure_policy_matrix_13[1:0] == 2'b11)
   else $error("STAP_DFX_SECURE_POLICY_MATRIX[66:65] should not be override with 2'b%b",stap_secure_policy_matrix_13[1:0]); 
   dfx_stap_secure_policy_matrix_14_assrt: assert (stap_secure_policy_matrix_14[1:0] == 2'b11)
   else $error("STAP_DFX_SECURE_POLICY_MATRIX[71:70] should not be override with 2'b%b",stap_secure_policy_matrix_14[1:0]); 
   dfx_stap_secure_policy_matrix_15_assrt: assert (stap_secure_policy_matrix_15 == 5'b00111)
   else $error("STAP_DFX_SECURE_POLICY_MATRIX[79:75] should not be override with 5'b%b",stap_secure_policy_matrix_15); 
end    


      `endif // DFX_FPV_ENABLE
   `endif // DFX_PARAMETER_CHECKER
`endif // STAP_SVA_OFF
`endif // INTEL_SVA_OFF
endmodule
