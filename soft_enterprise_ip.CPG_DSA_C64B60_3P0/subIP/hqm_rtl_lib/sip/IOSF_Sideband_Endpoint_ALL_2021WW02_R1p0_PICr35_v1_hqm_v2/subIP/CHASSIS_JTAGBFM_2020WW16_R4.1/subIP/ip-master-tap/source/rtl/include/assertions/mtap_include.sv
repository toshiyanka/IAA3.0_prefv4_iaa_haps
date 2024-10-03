`ifdef DFX_FPV_ENABLE
   // ====================================================================
   //\\// synopsys translate_off
   // ====================================================================
`else
   // ====================================================================
   // synopsys translate_off
   // ====================================================================
`endif
   // *********************************************************************
   // Localparameters
   // *********************************************************************
   localparam TWO  = 2;

//kbbhagwa (powergoodrst_b to be replaced to powergood_rst_b
//reverting back from powergood_rst_b to powergoodrst_b for valleyview
//hsd2904751
   wire tlrs = mtap_fsm_tlrs;
   wire atappris_tms_delayed_by_1ps;
   wire atappris_tdi_delayed_by_1ps;
   wire atappris_tck_delayed_by_1ps;
   wire atappris_tms_raising_edge_pulse;
   wire atappris_tms_falling_edge_pulse;
   wire ftap_clk_raising_edge_pulse;
   wire or_shift_ir_dr;
   wire atappris_trst_b_delayed_by_1ps;
   wire atappris_trst_b_raising_edge_pulse;
   wire atappris_trst_b_falling_edge_pulse;
   wire atappris_tms_pulse;
   wire atappris_tdi_pulse;

   wire [MTAP_NUMBER_OF_WTAPS - 1 : 0] wtap_sel_priority_internal;
   wire linear_network_enable;

   assign #1 atappris_tms_delayed_by_1ps     =  atappris_tms;
   assign #1 atappris_tdi_delayed_by_1ps     =  atappris_tdi;
   assign #1 atappris_tck_delayed_by_1ps     =  atappris_tck;
   assign    atappris_tms_falling_edge_pulse =  atappris_tms_delayed_by_1ps & ~atappris_tms;
   assign    atappris_tms_raising_edge_pulse = ~atappris_tms_delayed_by_1ps &  atappris_tms;
   assign    ftap_clk_raising_edge_pulse     = ~atappris_tck_delayed_by_1ps &  atappris_tck;
   assign    atappris_tms_pulse              = atappris_tms ^ atappris_tms_delayed_by_1ps;
   assign    atappris_tdi_pulse              = atappris_tdi ^ atappris_tdi_delayed_by_1ps;

   assign #1 atappris_trst_b_delayed_by_1ps = atappris_trst_b;
   assign #1 or_shift_ir_dr                 = mtap_fsm_shift_ir | mtap_fsm_shift_dr;

   assign atappris_trst_b_raising_edge_pulse = ~atappris_trst_b_delayed_by_1ps &  atappris_trst_b;
   assign atappris_trst_b_falling_edge_pulse =  atappris_trst_b_delayed_by_1ps & ~atappris_trst_b;

   assign wtap_sel_priority_internal[MTAP_NUMBER_OF_WTAPS - 1] = cltapc_wtap_sel[MTAP_NUMBER_OF_WTAPS - 1];
   generate
      for(genvar b = MTAP_NUMBER_OF_WTAPS - 1 ; b > 0; b = b - 1)
      begin
         assign wtap_sel_priority_internal[b - 1] = ~(|(wtap_sel_priority_internal[MTAP_NUMBER_OF_WTAPS - 1 : b])) &  cltapc_wtap_sel[b - 1];
      end
   endgenerate

   // =======================================================================
   // COVER_POINT for reset edges happening on positive and negetive edge clk
   // =======================================================================
   // To cover the property of asserting the atappris_trst_b at the posedge of atappris_tck
   // =======================================================================
   always @(posedge atappris_tck_delayed_by_1ps)
   begin
      cov_mtap_assert_reset_during_posedge_clk:
      cover property (atappris_trst_b_falling_edge_pulse == HIGH);
   end

   // =======================================================================
   // To cover the property of deasserting the atappris_trst_b at the posedge of atappris_tck
   // =======================================================================
   always @(posedge atappris_tck_delayed_by_1ps)
   begin
      cov_mtap_deassert_reset_during_posedge_clk:
      cover property (atappris_trst_b_raising_edge_pulse == HIGH);
   end

   // =======================================================================
   // To cover the property of asserting the atappris_trst_b at the negedge of atappris_tck
   // =======================================================================
   always @(negedge atappris_tck_delayed_by_1ps)
   begin
      cov_mtap_assert_reset_during_negedge_clk:
      cover property (atappris_trst_b_falling_edge_pulse == HIGH);
   end

   // =======================================================================
   // To cover the property of deasserting the atappris_trst_b at the negedge of atappris_tck
   // =======================================================================
   always @(negedge atappris_tck_delayed_by_1ps)
   begin
      cov_mtap_deassert_reset_during_negedge_clk:
      cover property (atappris_trst_b_raising_edge_pulse == HIGH);
   end

   // ====================================================================
   // COVER_POINT for soft reset
   // ====================================================================
   property prop_mtap_soft_reset_01;
      @(posedge atappris_tck)
         atappris_tms ##1 (atappris_tms[*4]);
   endproperty: prop_mtap_soft_reset_01
   cov_mtap_soft_reset_01: cover property (prop_mtap_soft_reset_01);

   // ====================================================================
   // COVER_POINT for glitch on TMS
   // ====================================================================
   property prop_mtap_glitch_on_tms_01;
      @(posedge atappris_tck)
         atappris_tms ##1 (atappris_tms[*5]) ##1 (!atappris_tms) ##1 (atappris_tms[*3]);
   endproperty: prop_mtap_glitch_on_tms_01
   cov_mtap_glitch_on_tms_01: cover property (prop_mtap_glitch_on_tms_01);

`ifndef SVA_OFF
   `ifdef DFX_ASSERTIONS
      // ====================================================================
      // Check TMS changes only on the negedge of clock
      // To cover the assertion TMS STABLE ON POSEDGE
      // ====================================================================
//      property mtap_assert_tms_during_posedge_clk;
//         @(negedge atappris_tck)
//            disable iff (powergoodrst_b == LOW)
//            ($changed(atappris_tms)) |-> (atappris_tck == HIGH);
//      endproperty: mtap_assert_tms_during_posedge_clk
//      chk_mtap_assert_tms_during_posedge_clk_0:
//      assert property (mtap_assert_tms_during_posedge_clk)
//      else $error ("TMS is not asserted at negedge of tck, but asserted at posedge");


      property mtap_assert_tms_during_posedge_clk;
         @(posedge atappris_tck_delayed_by_1ps)
         (powergoodrst_b) |-> (atappris_tms_pulse == LOW);
      endproperty: mtap_assert_tms_during_posedge_clk
      chk_mtap_assert_tms_during_posedge_clk_0:
      assert property (mtap_assert_tms_during_posedge_clk)
      else $error ("TMS is not asserted at negedge of tck, but asserted at posedge");

      // ====================================================================
      // Check TDI changes only on a negedge 
      // ====================================================================
      //property mtap_assert_tdi_during_posedge_clk;
      //   @(atappris_tdi)
      //     disable iff (powergoodrst_b == LOW)
      //     (atappris_tck == HIGH);
      //endproperty: mtap_assert_tdi_during_posedge_clk
      //chk_mtap_assert_tdi_during_posedge_clk_0:
      //assert property (mtap_assert_tdi_during_posedge_clk)
      //else $error ("TDI is not asserted at negedge of tck, but asserted at posedge");

      logic mtap_fsm_shift;
      assign mtap_fsm_shift = mtap_fsm_shift_ir || mtap_fsm_shift_dr;

      property mtap_assert_tdi_during_posedge_clk;
         @(posedge atappris_tck_delayed_by_1ps)
          disable iff (!mtap_fsm_shift)
         (powergoodrst_b) |=> (atappris_tdi_pulse == LOW);
      endproperty: mtap_assert_tdi_during_posedge_clk
      chk_mtap_assert_tdi_during_posedge_clk_0:
      assert property (mtap_assert_tdi_during_posedge_clk)
      else $error ("TDI is not asserted at negedge of tck, but asserted at posedge");

      // ====================================================================
      // Check TDO changes only on a negedge 
      // ====================================================================
      property mtap_assert_tdo_during_posedge_clk;
         @(ftappris_tdo)
           //disable iff ((powergoodrst_b == LOW) || (mtap_fsm_tlrs == HIGH) || (ftap_trst_b == LOW))
           disable iff ((powergoodrst_b == LOW) || (atappris_trst_b == LOW))
           //disable iff  (mtap_fsm_tlrs == HIGH)
           //(atappris_tck == HIGH);
           ((mtap_fsm_shift_ir || mtap_fsm_shift_dr) && (atappris_tms == LOW)) |-> (atappris_tck == HIGH);
      endproperty: mtap_assert_tdo_during_posedge_clk
      chk_mtap_assert_tdo_during_posedge_clk_0:
      assert property (mtap_assert_tdo_during_posedge_clk)
      else $error ("TDO is not asserted at negedge of tck, but asserted at posedge");

      // ====================================================================
      // Check TDO enable is high otherthan states shift_ir and shift_dr states
      // ====================================================================
      property mtap_tdo_en_high_during_shift_ir_dr;
         @(negedge atappris_tck)
            disable iff (mtap_fsm_tlrs == HIGH)
               (mtap_fsm_shift_ir || mtap_fsm_shift_dr) |=> ftappris_tdoen;
      endproperty: mtap_tdo_en_high_during_shift_ir_dr
      chk_mtap_tdo_en_high_during_shift_ir_dr_0:
      assert property (mtap_tdo_en_high_during_shift_ir_dr) else
         $error ("TDO enable is not high during states shift_ir and shift_dr states");

      // ====================================================================
      // Check TLRS is not high when TRST is low
      // ====================================================================
//      always @(powergoodrst_trst_b)
//      begin
//         #1;
//         if (!powergoodrst_trst_b)
//         begin
//            chk_mtap_tlrs_high_when_trst_low_0: assert (tlrs == HIGH)
//            else $error("TLRS is not high when TRST is LOW");
//         end
//      end

      property mtap_tlrs_high_when_trst_low_0;
         @(powergoodrst_trst_b)
            !powergoodrst_trst_b |-> (tlrs == HIGH);
      endproperty : mtap_tlrs_high_when_trst_low_0

      chk_mtap_tlrs_high_when_trst_low_0: assert property (mtap_tlrs_high_when_trst_low_0)
      else $error("TLRS is not high when TRST is LOW");

      // ====================================================================
      // Check TMS is not high when TRST is LOW
      // ====================================================================
//      always @(atappris_trst_b)
//      begin
//         #1;
//         if (!atappris_trst_b)
//         begin
//            chk_mtap_tms_high_when_trst_is_low_0: assert (atappris_tms == HIGH)
//            else $error("TMS is not high when TRST is LOW");
//         end
//      end

      property mtap_tms_high_when_trst_is_low_0;
          @(negedge atappris_tck)
             disable iff (powergoodrst_b == LOW)
             (!atappris_trst_b) |-> (atappris_tms == HIGH);
      endproperty : mtap_tms_high_when_trst_is_low_0

      chk_mtap_tms_high_when_trst_is_low_0:
      assert property (mtap_tms_high_when_trst_is_low_0) else
         $error("Error: TMS is not high when TRST is LOW.");

      // ====================================================================
      // To Check for all the SELECT_WIR signals
      // ====================================================================
      generate
         if (MTAP_ENABLE_WTAP_NETWORK == 1)
         begin
            //for (genvar a = 0; a < MTAP_NUMBER_OF_WTAPS; a = a + 1)
            //begin
               always @(posedge atappris_tck)
               begin
                  if (mtap_fsm_tlrs == LOW)
                  begin
                     //chk_wtapnw_selectwir_equals_wtap_sel : assert property (cn_fwtap_selectwir[a] == mtap_selectwir)
                     chk_wtapnw_selectwir_equals_wtap_sel : assert property (cn_fwtap_selectwir == mtap_selectwir)
                     else $error("WTAP_SELECT_WIR Logic is not equal to select_wir or not_wtap_sel");
                  end
               end
            //end
         end
      endgenerate

      // ====================================================================
      // To Check for all the SELECT_WSI signals
      // ====================================================================
      generate
         if ((MTAP_ENABLE_WTAP_NETWORK == 1) & (MTAP_ENABLE_LINEAR_NETWORK == 0))
         begin
            for (genvar c = 0; c < MTAP_NUMBER_OF_WTAPS; c = c + 1)
            begin
               always @(posedge atappris_tck)
               begin
                  if (mtap_fsm_tlrs == LOW)
                  begin
                     if(wtap_sel_priority_internal[c] == 1'b0) begin
                        chk_wtapnw_wsi_high_when_not_sel : assert property (cn_fwtap_wsi[c] == 1'b1)
                        else $error("WTAP_SELECT_WSI is not High when not selected");
                     end
                     if(wtap_sel_priority_internal[c] == 1'b1 &  (~(|(cltapc_select | cltapc_select_ovr)))) begin
                        chk_wtapnw_wsi_muxtdo_when_sel : assert property (cn_fwtap_wsi[c] == mtap_mux_tdo)
                        else $error("WTAP_SELECT_WSI is not Mux tdo when selected");
                     end
                     if((|(cltapc_select | cltapc_select_ovr))) begin
                        chk_wtapnw_wsi_high_when_tapnw_sel : assert property (cn_fwtap_wsi[c] == 1'b1)
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
         if ((MTAP_ENABLE_WTAP_NETWORK == 1) & (MTAP_ENABLE_LINEAR_NETWORK == 0))
         begin
            for (genvar d = 0; d < MTAP_NUMBER_OF_WTAPS; d = d + 1)
            begin
               always @(posedge atappris_tck)
               begin
                  if (mtap_fsm_tlrs == LOW)
                  begin
                     if(wtap_sel_priority_internal[d] == 1'b1 &  (~(|(cltapc_select | cltapc_select_ovr))))
                     begin
                        chk_wtapnw_tdo_wsi_sel : assert property (mtap_wtapnw_tdo == cn_awtap_wso[d])
                        else $error("WTAP TDO is not equal to the WSO of the wtap selected");
                     end
                  end
               end
            end
         end
      endgenerate

      if  (MTAP_ENABLE_LINEAR_NETWORK == 1)
      begin
         assign linear_network_enable = HIGH;
      end
      else
      begin
         assign linear_network_enable = LOW;
      end

      always @(posedge atappris_tck)
      begin
         if (mtap_fsm_tlrs == LOW && cltapc_remove == LOW)
         begin
            if( ((i_mtap_bscan.select_bscan_internal == 1'b1) | (fbscan_runbist_en == 1'b1)) & (ftappris_tdoen == 1'b1)
                & (mtap_fsm_shift_dr == 1))
            begin
               chk_tdo_fbscan_tdo_bscanreg_sel: 
               assert property (ftappris_tdo === fbscan_tdo)
               else $error("TDO is not equal to the TAPNW TDO when tap nw is selected and Boundary Scan is not");
            end
            if((i_mtap_bscan.select_bscan_internal == 1'b0) & (fbscan_runbist_en == 1'b0) & ((|(cltapc_select | cltapc_select_ovr)) | (linear_network_enable == 1'b1) ) & (ftappris_tdoen == 1'b1))
            begin
               chk_tdo_tapnw_tdo_sel: 
               assert property (ftappris_tdo === cntapnw_atap_tdo)
               else $error("TDO is not equal to the TAPNW TDO when tap nw is selected and Boundary Scan is not");
            end
            if( (i_mtap_bscan.select_bscan_internal == 1'b0) & (fbscan_runbist_en == 1'b0) & ((~(|(cltapc_select | cltapc_select_ovr))) & (linear_network_enable  == 1'b0)) & (|(wtap_sel_priority_internal)) & (ftappris_tdoen == 1'b1))
            begin
               chk_tdo_WTAPnw_no_tap_sel:
               assert property (ftappris_tdo === mtap_wtapnw_tdo)
               //kbbhagwa assertion errors need to ensure if both are x, fine with
               else $error("TDO is not equal to the WTAPNW TDO when no TAP in 0.7 is selected and a wtap in network is selected");
            end
            //if((i_mtap_bscan.select_bscan_internal == 1'b0) & (fbscan_runbist_en == 1'b0) & (~(|(cltapc_select | cltapc_select_ovr))) & (~(|(wtap_sel_priority_internal))) & (MTAP_CONNECT_WTAP_DIRECTLY == 1) & (ftappris_tdoen == 1'b1))
            //begin
            //   chk_tdo_wtap_tdo_no_tapnw_no_wtapnw_sel : assert property (ftappris_tdo == mtap_wso)
            //   else $error("TDO is not equal to the WTAP TDO when no TAP in 0.7 is selected and No tap in a WTAP NW is selected and Single WTAP is connected");
            //end
            //if((i_mtap_bscan.select_bscan_internal == 1'b0) & (fbscan_runbist_en == 1'b0) & (~(|(cltapc_select | cltapc_select_ovr))) & (~(|(wtap_sel_priority_internal))) & (MTAP_CONNECT_WTAP_DIRECTLY == 0))
            if((i_mtap_bscan.select_bscan_internal == 1'b0) & (fbscan_runbist_en == 1'b0) & ((~(|(cltapc_select | cltapc_select_ovr) )) & (linear_network_enable  == 1'b0)) & (~(|(wtap_sel_priority_internal)))) 
            begin
               chk_tdo_int_tdo_no_tapnw_no_wtapnw_no_direct_wtap_sel: 
               assert property (ftappris_tdo === mtap_mux_tdo)
               //kbbhagwa assertion errors to account for x
               else $error("TDO is not equal to the MTAP internal TDO when no TAP in 0.7 is selected and No tap in a WTAP NW is selected and Single WTAP is also not connected");
            end
         end
      end

   // ====================================================================
   // 0.7 TAPNW: Checks if entap is high for Normal, Excluded, Shadow mode. cltapc_select_ovr
   // ====================================================================
   wire [(MTAP_NUMBER_OF_TAPS * 2) - 1:0] select;

   assign select = cltapc_select | cltapc_select_ovr;

   generate
      if (MTAP_ENABLE_TAP_NETWORK == 1)
      begin
         for (genvar p = 0; p < MTAP_NUMBER_OF_TAPS; p = p + 1)
         begin
            always @(posedge atappris_tck)
            begin
               if (powergoodrst_b == HIGH)
               begin
                  if ((select[(TWO * p) + 1] | select[(TWO * p)]) == HIGH)
                  begin
                     chk_tapnw_entap_equals_one_for_normal_excluded_shadow_modes : assert (cftapnw_ftap_enabletap[p] == HIGH)
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
      if (MTAP_ENABLE_TAP_NETWORK == 1)
      begin
         for (genvar q = 0; q < MTAP_NUMBER_OF_TAPS; q = q + 1)
         begin
            always @(posedge atappris_tck)
            begin
               if (powergoodrst_b == HIGH)
               begin
                  if  ((select[(TWO * q) + 1]  ^ select[(TWO * q)]) == LOW)
                  begin
                     chk_tapnw_entdo_equals_zero_for_isolated_shadow_modes : assert (cftapnw_ftap_enabletdo[q] == LOW)
                     else $error("Entdo is not supposed to be high for Isolated and Shadow modes");
                  end
               end
            end
         end
      end
   endgenerate

   // ====================================================================
   // Check TAPNW TDI is Equal to TDI when Remove Bit is asserted
   // ====================================================================
   property mtap_tapnw_tdi_equals_tdi_when_remove_asserted;
      @(negedge atappris_tck)
      cltapc_remove |-> (cntapnw_ftap_tdi == atappris_tdi);
   endproperty : mtap_tapnw_tdi_equals_tdi_when_remove_asserted
   chk_mtap_tapnw_tdi_equals_tdi_when_remove_asserted :
   assert property (mtap_tapnw_tdi_equals_tdi_when_remove_asserted) else
      $error("TAPNW TDI is not Equal to TDI when Remove bit is asserted");
   // ====================================================================
   // Check TDOEN is Equal to TAP NW TDOEN when Remove Bit is asserted
   // ====================================================================
   property mtap_tdoen_equals_tapnw_tdoen_when_remove_asserted;
      @(negedge atappris_tck)
      cltapc_remove |-> (ftappris_tdoen == | cntapnw_atap_tdo_en);
   endproperty : mtap_tdoen_equals_tapnw_tdoen_when_remove_asserted
   chk_mtap_tdoen_equals_tapnw_tdoen_when_remove_asserted :
   assert property (mtap_tdoen_equals_tapnw_tdoen_when_remove_asserted) else
      $error("TDOEN is Not Equal to TAP NW TDOEN when Remove Bit is asserted");   
   // ====================================================================
   // Check Remove Bit is de-asserted at Pwer Good Reset
   // ====================================================================
   property mtap_remove_bit_zero_at_powergood_reset;
      @(powergoodrst_b)
      (!powergoodrst_b) |-> (cltapc_remove == LOW);
   endproperty : mtap_remove_bit_zero_at_powergood_reset
   chk_mtap_remove_bit_zero_at_powergood_reset :
   assert property (mtap_remove_bit_zero_at_powergood_reset) else
      $error("Remove Bit is asserted at Power Good Reset");

   // ====================================================================
   // Check State is TLRS atleast after 5 Clocks of Remove Bit assertion
   // ====================================================================
   property present_state_tlrs_when_remove_asserted;
       @(negedge atappris_tck)
          disable iff (powergoodrst_b == LOW)
             $rose(cltapc_remove) ##0 cltapc_remove[*5] |->  i_mtap_fsm.state_ps == 16'h1;
   endproperty : present_state_tlrs_when_remove_asserted
   chk_present_state_tlrs_when_remove_asserted:
   assume property (present_state_tlrs_when_remove_asserted);
   //   else $error ("Present state is not equal to TLRS after 5 Clock Cycle of Remove getting asserted");

   // ====================================================================
   // The assertion of Remove Bit should happen while accessing Remove Register
   // and at UPDR state
   // ====================================================================
   property mtap_assertion_remove_bit_at_updr;
      @(atappris_tck)
          disable iff (powergoodrst_b == LOW)
          $rose(cltapc_remove) |-> (mtap_irreg_ireg == 'h14) && (i_mtap_fsm.state_ps == 16'h0100);
   endproperty : mtap_assertion_remove_bit_at_updr
   chk_mtap_assertion_remove_bit_at_updr:
   assume property (mtap_assertion_remove_bit_at_updr);
//      else $error ("The Remove Bit is not asserted at UPDR and While Remove register is Asserted");

   `endif
`endif

//-------------------------------------------------------------------------------------------
// To check for valid address positions in the Parameter MTAP_INSTRUCTION_FOR_DATA_REGISTERS
//-------------------------------------------------------------------------------------------
`ifndef SVA_OFF
   `ifdef DFX_PARAMETER_CHECKER
      `ifndef DFX_FPV_ENABLE

         logic [MTAP_SIZE_OF_EACH_INSTRUCTION-1:0] cltap_ir_opcode_position [MTAP_NUMBER_OF_TOTAL_REGISTERS-1:0];
         int index = 2;
         
         initial
         begin
            for (int i=0, k=0; i < MTAP_NUMBER_OF_TOTAL_REGISTERS; i++)
            begin
               for (int j=0; j < MTAP_SIZE_OF_EACH_INSTRUCTION; j++, k++)
                  cltap_ir_opcode_position[i][j] = MTAP_INSTRUCTION_FOR_DATA_REGISTERS[k];
               $display ("cltap_ir_opcode_position[%0d] = %0h", i, cltap_ir_opcode_position[i]);
            end
         
            // Mandatory Registers
            // Position 0, 1
            assert (cltap_ir_opcode_position[0] == {MTAP_SIZE_OF_EACH_INSTRUCTION{1'b1}})
            else $fatal ("Parameter MTAP_INSTRUCTION_FOR_DATA_REGISTERS is not correct at index:0");
            assert (cltap_ir_opcode_position[1] == {MTAP_SIZE_OF_EACH_INSTRUCTION{1'b0}})
            else $fatal ("Parameter MTAP_INSTRUCTION_FOR_DATA_REGISTERS is not correct at index:1");
         
            // Boundary Scan Mandatory Registers & IDCODE Register
            // Position 2, 3, 4, 5
            assert (cltap_ir_opcode_position[index] == 'h01)
            else $fatal ("Parameter MTAP_INSTRUCTION_FOR_DATA_REGISTERS is not correct at index:%0d", index);
            index++;
            assert (cltap_ir_opcode_position[index] == 'h02)
            else $fatal ("Parameter MTAP_INSTRUCTION_FOR_DATA_REGISTERS is not correct at index:%0d", index);
            index++;
            assert (cltap_ir_opcode_position[index] == 'h08)
            else $fatal ("Parameter MTAP_INSTRUCTION_FOR_DATA_REGISTERS is not correct at index:%0d", index);
            index++;
            assert (cltap_ir_opcode_position[index] == 'h09)
            else $fatal ("Parameter MTAP_INSTRUCTION_FOR_DATA_REGISTERS is not correct at index:%0d", index);
            index++;
         
            // Boundary Scan Mandatory Registers
            // Position 6, 7
            assert (cltap_ir_opcode_position[index] == 'h0E)
            else $fatal ("Parameter MTAP_INSTRUCTION_FOR_DATA_REGISTERS is not correct at index:%0d", index);
            index++;
            assert (cltap_ir_opcode_position[index] == 'h0F)
            else $fatal ("Parameter MTAP_INSTRUCTION_FOR_DATA_REGISTERS is not correct at index:%0d", index);
            index++;
         
            // Mandatory TAPC_SELECT Register
            // Position 8, 9
            assert (cltap_ir_opcode_position[index] == 'h11)
            else $fatal ("Parameter MTAP_INSTRUCTION_FOR_DATA_REGISTERS is not correct at index:%0d", index);
            index++;
            assert (cltap_ir_opcode_position[index] == 'h12)
            else $fatal ("Parameter MTAP_INSTRUCTION_FOR_DATA_REGISTERS is not correct at index:%0d", index);
            index++;
         
            // Boundary Scan Optional Registers
            // Position 10
            if (MTAP_ENABLE_PRELOAD == 1)
            begin
               assert (cltap_ir_opcode_position[index] == 'h03)
               else $fatal ("Parameter MTAP_INSTRUCTION_FOR_DATA_REGISTERS is not correct at index:%0d", index);
               index++;
            end
            if (MTAP_ENABLE_CLAMP == 1)
            // Position 10 or 11
            begin
               assert (cltap_ir_opcode_position[index] == 'h04)
               else $fatal ("Parameter MTAP_INSTRUCTION_FOR_DATA_REGISTERS is not correct at index:%0d", index);
               index++;
            end
            if (MTAP_ENABLE_USERCODE == 1)
            // Position 10 or 11 or 12
            begin
               assert (cltap_ir_opcode_position[index] == 'h05)
               else $fatal ("Parameter MTAP_INSTRUCTION_FOR_DATA_REGISTERS is not correct at index:%0d", index);
               index++;
            end
            if (MTAP_ENABLE_INTEST == 1)
            // Position 10 or 11 or 12 or 13
            begin
               assert (cltap_ir_opcode_position[index] == 'h06)
               else $fatal ("Parameter MTAP_INSTRUCTION_FOR_DATA_REGISTERS is not correct at index:%0d", index);
               index++;
            end
            if (MTAP_ENABLE_RUNBIST == 1)
            // Position 10 - 14
            begin
               assert (cltap_ir_opcode_position[index] == 'h07)
               else $fatal ("Parameter MTAP_INSTRUCTION_FOR_DATA_REGISTERS is not correct at index:%0d", index);
               index++;
            end
            if (MTAP_ENABLE_EXTEST_TOGGLE == 1)
            // Position 10 - 15
            begin
               assert (cltap_ir_opcode_position[index] == 'h0D)
               else $fatal ("Parameter MTAP_INSTRUCTION_FOR_DATA_REGISTERS is not correct at index:%0d", index);
               index++;
            end
         
            // Optional CLTAPC_SEC_SELECT Register
            if (MTAP_ENABLE_CLTAPC_SEC_SEL == 1)
            // Position 10 - 16
            begin
               assert (cltap_ir_opcode_position[index] == 'h10)
               else $fatal ("Parameter MTAP_INSTRUCTION_FOR_DATA_REGISTERS is not correct at index:%0d", index);
               index++;
            end
         
            // Optional CLTAPC_WTAP_SELECT Register
            if (MTAP_ENABLE_WTAP_NETWORK == 1)
            // Position 10 -17
            begin
               assert (cltap_ir_opcode_position[index] == 'h13) 
               else $fatal ("Parameter MTAP_INSTRUCTION_FOR_DATA_REGISTERS is not correct at index:%0d", index);
               index++;
            end
         
            // Optional CLTAPC_VISAOVR Register
            if (MTAP_ENABLE_CLTAPC_VISAOVR == 1)
            // Position 10 - 18
            begin
               assert (cltap_ir_opcode_position[index] == 'h15)
               else $fatal ("Parameter MTAP_INSTRUCTION_FOR_DATA_REGISTERS is not correct at index:%0d", index);
               index++;
            end
         
            // Optional Remove Register
            if (MTAP_ENABLE_CLTAPC_REMOVE == 1)
            // Position 10 - 19
            begin
               assert (cltap_ir_opcode_position[index] == 'h14)
               else $fatal ("Parameter MTAP_INSTRUCTION_FOR_DATA_REGISTERS is not correct at index:%0d", index);
               index++;
            end
         
            // TDR
            if ((MTAP_ENABLE_TEST_DATA_REGISTERS == 1) || (MTAP_ENABLE_REMOTE_TEST_DATA_REGISTERS == 1))
            // Position 10 or above
            begin
               while (index < MTAP_NUMBER_OF_TOTAL_REGISTERS)
               begin
                  assert ((cltap_ir_opcode_position[index] >= 'h20) && (cltap_ir_opcode_position[index] < {MTAP_SIZE_OF_EACH_INSTRUCTION{1'b1}}))
                  else $fatal ("Parameter MTAP_INSTRUCTION_FOR_DATA_REGISTERS is not correct at index:%0d", index);
                  index++;
               end
            end
         
            // To check IR register width
            assert (MTAP_SIZE_OF_EACH_INSTRUCTION >= 'h8)
            else $fatal ("Parameter MTAP_SIZE_OF_EACH_INSTRUCTION is less than 8");
         
            // To check WTAPNW is disabled when LIN=1
            if ((MTAP_ENABLE_TAP_NETWORK == HIGH) && (MTAP_ENABLE_LINEAR_NETWORK == HIGH))
            begin    
               assert (MTAP_ENABLE_WTAP_NETWORK == LOW)
               else $fatal ("You cannot enable a WTAP Network on a LINEAR Network Topology");
            end

            // To check Linear NW is enabled only when TAPNW is enabled
            if (MTAP_ENABLE_LINEAR_NETWORK == HIGH)
            begin    
               assert (MTAP_ENABLE_TAP_NETWORK == HIGH)
               else $fatal ("You cannot enable Linear Network topology with out enabling 0.7 Tap Network.");
            end

        end
      `endif // DFX_FPV_ENABLE
   `endif // DFX_PARAMETER_CHECKER
`endif // SVA_OFF

`ifdef DFX_FPV_ENABLE
   // ====================================================================
   //\\// synopsys translate_on
   // ====================================================================
`else
   // ====================================================================
   // synopsys translate_on
   // ====================================================================
`endif
