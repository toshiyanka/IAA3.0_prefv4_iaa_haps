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
//kbbhagwa changing powergoodrst_b to powergood_rst_b
//hsd2904571 , reverting back from powergood_rst_b to powergoodrst_b
//to avoid valleyview and avoton clash


   wire tlrs = stap_fsm_tlrs;
   wire ftap_tms_delayed_by_1ps;
   wire ftap_tdi_delayed_by_1ps;
   wire ftap_tck_delayed_by_1ps;
   wire ftap_trst_b_delayed_by_1ps;
   wire ftap_trst_b_raising_edge_pulse;
   wire ftap_trst_b_falling_edge_pulse;
   wire ftap_tms_pulse;
   wire ftap_tdi_pulse;
   logic stap_linear_network_enable;

   logic [STAP_NUMBER_OF_WTAPS - 1 : 0] wtap_sel_priority_internal;

   assign #1 ftap_tms_delayed_by_1ps     =  ftap_tms;
   assign #1 ftap_tdi_delayed_by_1ps     =  ftap_tdi;
   assign #1 ftap_tck_delayed_by_1ps     =  ftap_tck;

   assign #1 ftap_trst_b_delayed_by_1ps  = ftap_trst_b;

   assign ftap_trst_b_raising_edge_pulse = ~ftap_trst_b_delayed_by_1ps &  ftap_trst_b;
   assign ftap_trst_b_falling_edge_pulse =  ftap_trst_b_delayed_by_1ps & ~ftap_trst_b;
   assign ftap_tms_pulse                 = ftap_tms ^ ftap_tms_delayed_by_1ps;
   assign ftap_tdi_pulse                 = ftap_tdi ^ ftap_tdi_delayed_by_1ps;

   assign wtap_sel_priority_internal[STAP_NUMBER_OF_WTAPS - 1] = tapc_wtap_sel[STAP_NUMBER_OF_WTAPS - 1];
   generate
      for(genvar b = STAP_NUMBER_OF_WTAPS - 1 ; b > 0; b = b - 1)
      begin
         assign wtap_sel_priority_internal[b - 1] =
            ~(|(wtap_sel_priority_internal[STAP_NUMBER_OF_WTAPS - 1 : b])) &  tapc_wtap_sel[b - 1];
      end
   endgenerate

   // =======================================================================
   // COVER_POINT for reset edges happening on positive and negetive edge clk
   // =======================================================================
   // To cover the property of asserting the ftap_trst_b at the posedge of ftap_tck
   // =======================================================================
   always @(posedge ftap_tck_delayed_by_1ps)
   begin
      cov_stap_assert_reset_during_posedge_clk:
      cover property (ftap_trst_b_falling_edge_pulse == HIGH);
   end

   // =======================================================================
   // To cover the property of deasserting the ftap_trst_b at the posedge of ftap_tck
   // =======================================================================
   always @(posedge ftap_tck_delayed_by_1ps)
   begin
      cov_stap_deassert_reset_during_posedge_clk:
      cover property (ftap_trst_b_raising_edge_pulse == HIGH);
   end

   // =======================================================================
   // To cover the property of asserting the ftap_trst_b at the negedge of ftap_tck
   // =======================================================================
   always @(negedge ftap_tck_delayed_by_1ps)
   begin
      cov_stap_assert_reset_during_negedge_clk:
      cover property (ftap_trst_b_falling_edge_pulse == HIGH);
   end

   // =======================================================================
   // To cover the property of deasserting the ftap_trst_b at the negedge of ftap_tck
   // =======================================================================
   always @(negedge ftap_tck_delayed_by_1ps)
   begin
      cov_stap_deassert_reset_during_negedge_clk:
      cover property (ftap_trst_b_raising_edge_pulse == HIGH);
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


`ifndef SVA_OFF
   `ifdef DFX_ASSERTIONS
      // ====================================================================
      // Check TMS changes only on the negedge of clock
      // To cover the assertion TMS STABLE ON POSEDGE
      // ====================================================================
//      property stap_assert_tms_during_posedge_clk;
//         //@(negedge ftap_tck)
//         //   ($changed(ftap_tms) && (powergoodrst_b)) |-> (ftap_tck== HIGH); //Original
//         //   ($changed(ftap_tms) && (powergoodrst_b)) |=> (ftap_tck== HIGH); //Modifed_for_Tapnw_1.4.09
//         @(negedge ftap_tck)
//            disable iff (powergoodrst_b == LOW)
//            ($changed(ftap_tms)) |-> (ftap_tck == HIGH);
//      endproperty: stap_assert_tms_during_posedge_clk
//      chk_stap_assert_tms_during_posedge_clk_0:
//      assert property (stap_assert_tms_during_posedge_clk)
//      else $error ("TMS is not asserted at negedge of tck, but asserted at posedge");

//      property stap_assert_tms_during_posedge_clk;
//         @(ftap_tms)
//            (powergoodrst_b) |-> (ftap_tck == HIGH);
//      endproperty: stap_assert_tms_during_posedge_clk
//      chk_stap_assert_tms_during_posedge_clk_0:
//      assert property (stap_assert_tms_during_posedge_clk)
//      else $error ("TMS is not asserted at negedge of tck, but asserted at posedge");

      property stap_assert_tms_during_posedge_clk;
          @(posedge ftap_tck_delayed_by_1ps)
          (powergoodrst_b) |-> (ftap_tms_pulse == LOW);
      endproperty: stap_assert_tms_during_posedge_clk
      chk_stap_assert_tms_during_posedge_clk_0:
      assert property (stap_assert_tms_during_posedge_clk)
      else $error ("TMS is not asserted at negedge of tck, but asserted at posedge");

      // ====================================================================
      // Check TDI changes only on the negedge of clock
      // To cover the assertion TMS STABLE ON POSEDGE
      // ====================================================================

      //--property stap_assert_tdi_during_posedge_clk;
      //--   @(ftap_tdi)
      //--     disable iff ((powergoodrst_b == LOW) || (stap_fsm_tlrs == HIGH))
      //--     (ftap_tck == HIGH);
      //--endproperty: stap_assert_tdi_during_posedge_clk
      //--chk_stap_assert_tdi_during_posedge_clk_0:
      //--assert property (stap_assert_tdi_during_posedge_clk)
      //--else $error ("TDI is not asserted at negedge of tck, but asserted at posedge");

      logic stap_fsm_shift;
      assign stap_fsm_shift = stap_fsm_shift_ir || stap_fsm_shift_dr;

      property stap_assert_tdi_during_posedge_clk;
          @(posedge ftap_tck_delayed_by_1ps)
          disable iff (!stap_fsm_shift)
          (powergoodrst_b) |=> (ftap_tdi_pulse == LOW);
      endproperty: stap_assert_tdi_during_posedge_clk
      chk_stap_assert_tdi_during_posedge_clk_0:
      assert property (stap_assert_tdi_during_posedge_clk)
      else $error ("TDI is not asserted at negedge of tck, but asserted at posedge");


      // ====================================================================
      // Check TDO changes only on a negedge
      // ====================================================================
      property stap_assert_tdo_during_posedge_clk;
         @(atap_tdo)
           //disable iff ((powergoodrst_b == LOW) || (stap_fsm_tlrs == HIGH) || (ftap_trst_b == LOW))
           disable iff ((powergoodrst_b == LOW) || (ftap_trst_b == LOW))
           //disable iff  (stap_fsm_tlrs == HIGH)
           //(ftap_tck == HIGH);
           ((stap_fsm_shift_ir || stap_fsm_shift_dr) && (ftap_tms == LOW)) |-> (ftap_tck == HIGH);
      endproperty: stap_assert_tdo_during_posedge_clk
      chk_stap_assert_tdo_during_posedge_clk_0:
      assert property (stap_assert_tdo_during_posedge_clk)
      else $error ("TDO is not asserted at negedge of tck, but asserted at posedge");

      // ====================================================================
      // Check TDO enable is high otherthan states shift_ir and shift_dr states
      // ====================================================================
      property stap_tdo_en_high_during_shift_ir_dr;
         @(negedge ftap_tck)
            disable iff (stap_fsm_tlrs == HIGH)
               (stap_fsm_shift_ir || stap_fsm_shift_dr) |=> atap_tdoen;
      endproperty: stap_tdo_en_high_during_shift_ir_dr
      chk_stap_tdo_en_high_during_shift_ir_dr_0:
      assert property (stap_tdo_en_high_during_shift_ir_dr) else
         $error ("TDO enable is not high during states shift_ir and shift_dr states");

      // ====================================================================
      // Check TAPNW TDI is Equal to TDI when Remove Bit is asserted
      // ====================================================================
      property stap_tapnw_tdi_equals_tdi_when_remove_asserted;
         @(negedge ftap_tck)
         tapc_remove |-> (sntapnw_ftap_tdi == ftap_tdi);
      endproperty : stap_tapnw_tdi_equals_tdi_when_remove_asserted
      chk_stap_tapnw_tdi_equals_tdi_when_remove_asserted :
      assert property (stap_tapnw_tdi_equals_tdi_when_remove_asserted) else
         $error("TAPNW TDI is not Equal to TDI when Remove bit is asserted");

      // ====================================================================
      // Check TDO_EN is Equal to TAP NW TDO_EN when Remove Bit is asserted
      // ====================================================================
      property stap_tdoen_equals_tapnw_tdi_when_remove_asserted;
         @(negedge ftap_tck)
         tapc_remove |-> (atap_tdoen == |sntapnw_atap_tdo_en);
      endproperty : stap_tdoen_equals_tapnw_tdi_when_remove_asserted
      chk_stap_tdoen_equals_tapnw_tdi_when_remove_asserted :
      assert property (stap_tdoen_equals_tapnw_tdi_when_remove_asserted) else
         $error("TDO_EN is not Equal to TAP NW TDO_EN when Remove Bit is asserted");

      // ====================================================================
      // Check Remove Bit is de-asserted at Pwer Good Reset
      // ====================================================================
      property stap_remove_bit_zero_at_powergood_reset;
         @(powergoodrst_b)
         (!powergoodrst_b) |-> (tapc_remove == LOW);
      endproperty : stap_remove_bit_zero_at_powergood_reset
      chk_stap_remove_bit_zero_at_powergood_reset :
      assert property (stap_remove_bit_zero_at_powergood_reset) else
         $error("Remove Bit is asserted at Power Good Reset");
      // ====================================================================
      // Check TLRS is not high when TRST is low
      // ====================================================================
//      always @(powergoodrst_trst_b)
//      begin
//         #1;
//         if (!powergoodrst_trst_b)
//         begin
//            chk_stap_tlrs_high_when_trst_low_0: assert (tlrs == HIGH)
//            else $error("TLRS is not high when TRST is low");
//         end
//      end

      property stap_tlrs_high_when_trst_low_0;
         @(powergoodrst_trst_b)
            !powergoodrst_trst_b |-> (tlrs == HIGH);
      endproperty : stap_tlrs_high_when_trst_low_0

      chk_stap_tlrs_high_when_trst_low_0: assert property (stap_tlrs_high_when_trst_low_0)
      else $error("TLRS is not high when TRST is LOW");


      // ====================================================================
      // Check TMS is not high when TRST is LOW
      // ====================================================================
//      always @(ftap_trst_b)
//      begin
//         #1;
//         if (!ftap_trst_b)
//         begin
//            chk_stap_tms_high_when_trst_is_low_0: assert (ftap_tms == HIGH)
//            else $error("TMS is not high when TRST is LOW");
//         end
//      end

      property stap_tms_high_when_trst_is_low_0;
         @(negedge ftap_tck)
            disable iff (powergoodrst_b == LOW)
            (!ftap_trst_b) |-> (ftap_tms == HIGH);
      endproperty : stap_tms_high_when_trst_is_low_0

      chk_stap_tms_high_when_trst_is_low_0:
      assert property (stap_tms_high_when_trst_is_low_0) else
         $error("Error: TMS is not high when TRST is LOW.");

      // ====================================================================
      // To Check for all the SELECT_WIR signals
      // ====================================================================
      generate
         if (STAP_ENABLE_WTAP_NETWORK == 1)
         begin
            //for (genvar a = 0; a < STAP_NUMBER_OF_WTAPS; a = a + 1)
            //begin
               always @(posedge ftap_tck)
               begin
                  if (stap_fsm_tlrs == LOW)
                  begin
                     chk_wtapnw_selectwir_equals_wtap_sel:
                        //assert property (sn_fwtap_selectwir[a] == stap_selectwir)
                        assert property (sn_fwtap_selectwir      == stap_selectwir)
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
         if ((STAP_ENABLE_WTAP_NETWORK == 1) & (STAP_ENABLE_LINEAR_NETWORK == 0))
         begin
            for (genvar c = 0; c < STAP_NUMBER_OF_WTAPS; c = c + 1)
            begin
               always @(posedge ftap_tck)
               begin
                  if (stap_fsm_tlrs == LOW)
                  begin
                     if(wtap_sel_priority_internal[c] == 1'b0)
                     begin
                        chk_wtapnw_wsi_high_when_not_sel:
                        assert property (sn_fwtap_wsi[c] == 1'b1)
                        else $error("WTAP_SELECT_WSI is not High when not selected");
                     end
                     if(wtap_sel_priority_internal[c] == 1'b1 & (~(|(tapc_select))))
                     begin
                        chk_wtapnw_wsi_muxtdo_when_sel:
                        assert property (sn_fwtap_wsi[c] === stap_mux_tdo)
                        else $error("WTAP_SELECT_WSI is not Mux tdo when selected");
                     end
                     if(|(tapc_select)) begin
                        chk_wtapnw_wsi_high_when_tapnw_sel:
                           assert property (sn_fwtap_wsi[c] == 1'b1)
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
         if ((STAP_ENABLE_WTAP_NETWORK == 1) & (STAP_ENABLE_LINEAR_NETWORK == 0))
         begin
            for (genvar d = 0; d < STAP_NUMBER_OF_WTAPS; d = d + 1)
            begin
               always @(posedge ftap_tck)
               begin
                  if (stap_fsm_tlrs == LOW)
                  begin
                     if(wtap_sel_priority_internal[d] == 1'b1 & (~(|(tapc_select))))
                     begin
                        chk_wtapnw_tdo_wsi_sel:
                        assert property (stap_wtapnw_tdo === sn_awtap_wso[d])
                        else $error("WTAP TDO is not equal to the WSO of the wtap selected");
                     end
                  end
               end
            end
         end
      endgenerate

      // ======================================================================
      // To Check for the TDO Control and TDO out signals based on the priority
      // logic implmented in sTAP.
      // ======================================================================

      initial
      begin
         if  (STAP_ENABLE_LINEAR_NETWORK == 1)
         begin
            stap_linear_network_enable = HIGH;
         end
         else
         begin
            stap_linear_network_enable = LOW;
         end
      end

      logic gen_select_bscan_internal;

      generate
         if (STAP_ENABLE_BSCAN == 1)
            begin
               assign gen_select_bscan_internal = generate_stap_bscan.i_stap_bscan.select_bscan_internal;
            end
         else
            begin
               assign gen_select_bscan_internal = LOW;
            end
      endgenerate


      always @(posedge ftap_tck)
      begin
         if (stap_fsm_tlrs == LOW && tapc_remove == LOW)
         begin
            //-----------------------------------------------------------------
            //if( ((select_bscan_internal == 1'b1) | (lcl_fbscan_runbist == 1'b1)) &
            if( ((gen_select_bscan_internal == 1'b1) | (stap_fbscan_runbist_en == 1'b1)) & (atap_tdoen == 1'b1) &
                (STAP_ENABLE_BSCAN == 1) &
                (stap_fsm_shift_dr == 1) )
            begin
               chk_tdo_fbscan_tdo_bscanreg_sel:
               assert property (atap_tdo === stap_fbscan_tdo)
               //kbbhagwa https://vthsd.intel.com/hsd/seg_softip/bug/default.aspx?bug_id=2904932
               //replaced == by === to account for x match in case of uninits
               // and valid asserted
               else $error("TDO is not equal to the Bscan TDO when Bscan is selected and not TAPNW");
            end
            //-----------------------------------------------------------------
            if( (gen_select_bscan_internal == 1'b0)   &
                (stap_fbscan_runbist_en == 1'b0)      &
                ((|(tapc_select)) | (stap_linear_network_enable == 1'b1))   & (atap_tdoen == 1'b1) &
                (STAP_ENABLE_BSCAN == 0) )
            begin
               chk_tdo_tapnw_tdo_sel:
               assert property (atap_tdo === linr_hier_tapnw_tdo)
               //kbbhagwa https://vthsd.intel.com/hsd/seg_softip/bug/default.aspx?bug_id=2904932
               //replaced == by === to account for x match in case of uninits
               // and valid asserted
               else $error("TDO is not equal to the TAPNW TDO when tap nw is selected and Boundary Scan is not");
            end
            //-----------------------------------------------------------------
            //--  if( (gen_select_bscan_internal == 1'b0) &
            //--      (stap_fbscan_runbist_en == 1'b0)    &
            //--      (~(|(tapc_select)))             &
            //--      (|(wtap_sel_priority_internal)) &
            //--      (STAP_ENABLE_BSCAN == 0) )
            //--  begin
            //--  // No support for WTAPs in 0.7 network
            //--     chk_tdo_WTAPnw_no_tap_sel:
            //--     assert property (atap_tdo == stap_wtapnw_tdo)
            //--     else $error("TDO is not equal to the WTAPNW TDO when no TAP in 0.7 is selected and a wtap in network is selected");
            //--  end
            //--  //-----------------------------------------------------------------
            //--  if( (gen_select_bscan_internal == 1'b0)     &
            //--      (stap_fbscan_runbist_en == 1'b0)        &
            //--      (~(|(tapc_select)))                 &
            //--      (~(|(wtap_sel_priority_internal)))  &
            //--      //(STAP_CONNECT_WTAP_DIRECTLY == 1)   &
            //--      (STAP_ENABLE_BSCAN == 0) )
            //--  begin
            //--     //No support for WTAPs in 0.7 network
            //--     chk_tdo_wtap_tdo_no_tapnw_no_wtapnw_sel:
            //--     assert property (atap_tdo == stap_wso)
            //--     else $error("TDO is not equal to the WTAP TDO when no TAP in 0.7 is selected and No tap in a WTAP NW is selected and Single WTAP is connected");
            //--  end
            //-----------------------------------------------------------------
            if( (gen_select_bscan_internal == 1'b0)     &
                (stap_fbscan_runbist_en == 1'b0)        &
                (~(|(tapc_select)))                 &
                (~(|(wtap_sel_priority_internal)))  &
                (STAP_ENABLE_LINEAR_NETWORK == 0)   &
                (STAP_ENABLE_BSCAN == 0) )
            begin
               chk_tdo_int_tdo_no_tapnw_no_wtapnw_no_direct_wtap_sel:
               assert property (atap_tdo === stap_mux_tdo)
               //kbbhagwa https://vthsd.intel.com/hsd/seg_softip/bug/default.aspx?bug_id=2904932
               //replaced == by === to account for x match in case of uninits
               // and valid asserted
               else $error("TDO is not equal to the STAP internal TDO when no TAP in 0.7 is selected and No tap in a WTAP NW is selected and Single WTAP is also not connected");
            end
            //-----------------------------------------------------------------
         end
      end

   // ====================================================================
   // 0.7 TAPNW: Checks if entap is high for Normal, Excluded, Shadow mode.
   // ====================================================================
   logic [(STAP_NUMBER_OF_TAPS * 2) - 1:0] select;

   assign select = tapc_select;

   generate
      if (STAP_ENABLE_TAP_NETWORK == 1)
      begin
         for (genvar p = 0; p < STAP_NUMBER_OF_TAPS; p = p + 1)
         begin
            always @(posedge ftap_tck)
            begin
               if (powergoodrst_b == HIGH)
               begin
                  if ((select[(TWO * p) + 1] | select[(TWO * p)]) == HIGH)
                  begin
                     chk_tapnw_entap_equals_one_for_normal_excluded_shadow_modes:
                     assert (sftapnw_ftap_enabletap[p] == HIGH)
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
      if (STAP_ENABLE_TAP_NETWORK == 1)
      begin
         for (genvar q = 0; q < STAP_NUMBER_OF_TAPS; q = q + 1)
         begin
            always @(posedge ftap_tck)
            begin
               if (powergoodrst_b == HIGH)
               begin
                  if  ((select[(TWO * q) + 1]  ^ select[(TWO * q)]) == LOW)
                  begin
                     chk_tapnw_entdo_equals_zero_for_isolated_shadow_modes:
                     assert (sftapnw_ftap_enabletdo[q] == LOW)
                     else $error("Entdo is not supposed to be high for Isolated and Shadow modes");
                  end
               end
            end
         end
      end
   endgenerate

   // ====================================================================
   // Sub TAP Active.
   // Case-1: Agent sTAP's children are enabled. Then he should indicate
   // to his father that he is active.
   // Case-2: Agent sTAP's children are disabled. Then he should pass
   // the active signal from below to his father.
   // ====================================================================
   property subtapactv_children_active;
       @(negedge ftap_tck)
          //disable iff ((powergoodrst_b == LOW) || (STAP_ENABLE_LINEAR_NETWORK == LOW))
          disable iff (powergoodrst_b == LOW)
          ((|tapc_wtap_sel) || (|tapc_select)) |-> atap_subtapactv;
   endproperty : subtapactv_children_active

   chk_subtapactv_children_active:
   assert property (subtapactv_children_active) else
       $error("Error: Status of the Controlling TAP's not getting passsed to Controlling TAP's father.");

   property subtapactv_children_disabled;
       @(negedge ftap_tck)
          //disable iff ((powergoodrst_b == LOW) || (STAP_ENABLE_LINEAR_NETWORK == LOW))
          disable iff (powergoodrst_b == LOW)
          (~(|tapc_wtap_sel) && ~(|tapc_select)) |-> (atap_subtapactv == |stapnw_atap_subtapactvi);
   endproperty : subtapactv_children_disabled

   chk_subtapactv_children_disabled:
   assert property (subtapactv_children_disabled) else
       $error("Error: Status of the Controlling TAP's children not getting passsed to Controlling TAP's father.");

   // ====================================================================
   // Check State is TLRS atleast after 5 Clocks of Remove Bit assertion
   // ====================================================================
   property present_state_tlrs_when_remove_asserted;
       @(negedge ftap_tck)
          disable iff (powergoodrst_b == LOW)
             $rose(tapc_remove) ##0 tapc_remove[*5] |->  i_stap_fsm.state_ps == 16'h0001;
   endproperty : present_state_tlrs_when_remove_asserted
   chk_present_state_tlrs_when_remove_asserted:
   assume property (present_state_tlrs_when_remove_asserted);
//      else $error ("Present state is not equal to TLRS after 5 Clock Cycle of Remove getting asserted");

   // ====================================================================
   // The assertion of Remove Bit should happen while accessing Remove Register
   // and at UPDR state
   // ====================================================================
   property stap_assertion_remove_bit_at_updr;
      @(ftap_tck)
          disable iff (powergoodrst_b == LOW)
          $rose(tapc_remove) |-> (stap_irreg_ireg == 'h14) && (i_stap_fsm.state_ps == 16'h0100);
   endproperty : stap_assertion_remove_bit_at_updr
   chk_stap_assertion_remove_bit_at_updr:
   assume property (stap_assertion_remove_bit_at_updr);
//      else $error ("The Remove Bit is not asserted at UPDR and While Remove register is Asserted");
   `endif
`endif

//-------------------------------------------------------------------------------------------
// To check for valid address positions in the Parameter STAP_INSTRUCTION_FOR_DATA_REGISTERS
//-------------------------------------------------------------------------------------------
`ifndef SVA_OFF
   `ifdef DFX_PARAMETER_CHECKER
      `ifndef DFX_FPV_ENABLE

         logic [STAP_SIZE_OF_EACH_INSTRUCTION-1:0] stap_ir_opcode_position [STAP_NUMBER_OF_TOTAL_REGISTERS-1:0];
         int index = 2;

         initial
         begin
            for (int i=0, k=0; i < STAP_NUMBER_OF_TOTAL_REGISTERS; i++)
            begin
               for (int j=0; j < STAP_SIZE_OF_EACH_INSTRUCTION; j++, k++)
                  stap_ir_opcode_position[i][j] = STAP_INSTRUCTION_FOR_DATA_REGISTERS[k];
               $display ("stap_ir_opcode_position[%0d] = %0h", i, stap_ir_opcode_position[i]);
            end

            // Mandatory Registers
            // Position 0, 1
            assert (stap_ir_opcode_position[0] == {STAP_SIZE_OF_EACH_INSTRUCTION{1'b1}})
            else $fatal ("Parameter STAP_INSTRUCTION_FOR_DATA_REGISTERS is not correct at index: 0");
            assert (stap_ir_opcode_position[1] == {STAP_SIZE_OF_EACH_INSTRUCTION{1'b0}})
            else $fatal ("Parameter STAP_INSTRUCTION_FOR_DATA_REGISTERS is not correct at index: 1");

            // Boundary Scan Mandatory Registers
            if (STAP_ENABLE_BSCAN == 1)
            // Position 2, 3, 4
            begin
               assert (stap_ir_opcode_position[index] == 'h01)
               else $fatal ("Parameter STAP_INSTRUCTION_FOR_DATA_REGISTERS is not correct at index:%0d", index);
               index++;
               assert (stap_ir_opcode_position[index] == 'h08)
               else $fatal ("Parameter STAP_INSTRUCTION_FOR_DATA_REGISTERS is not correct at index:%0d", index);
               index++;
               assert (stap_ir_opcode_position[index] == 'h09)
               else $fatal ("Parameter STAP_INSTRUCTION_FOR_DATA_REGISTERS is not correct at index:%0d", index);
               index++;
            end

            // SLVIDCODE
            // Position 2 or 5
            assert (stap_ir_opcode_position[index] == 'h0c)
            else $fatal ("Parameter STAP_INSTRUCTION_FOR_DATA_REGISTERS is not correct at index:%0d", index);
            index++;

            // Boundary Scan Mandatory Registers
            if (STAP_ENABLE_BSCAN == 1)
            // Position 6, 7
            begin
               assert (stap_ir_opcode_position[index] == 'h0E)
               else $fatal ("Parameter STAP_INSTRUCTION_FOR_DATA_REGISTERS is not correct at index:%0d", index);
               index++;
               assert (stap_ir_opcode_position[index] == 'h0F)
               else $fatal ("Parameter STAP_INSTRUCTION_FOR_DATA_REGISTERS is not correct at index:%0d", index);
               index++;
            end

            // Optional TAPC_SELECT Register
            if (STAP_ENABLE_TAP_NETWORK == 1)
            // Position 3 or 8
            begin
               assert (stap_ir_opcode_position[index] == 'h11)
               else $fatal ("Parameter STAP_INSTRUCTION_FOR_DATA_REGISTERS is not correct at index:%0d", index);
               index++;
            end

            // Boundary Scan Optional Registers
            // Position 8 or 9
            if ((STAP_ENABLE_BSCAN == 1) && (STAP_ENABLE_PRELOAD == 1))
            begin
               assert (stap_ir_opcode_position[index] == 'h03)
               else $fatal ("Parameter STAP_INSTRUCTION_FOR_DATA_REGISTERS is not correct at index:%0d", index);
               index++;
            end
            if ((STAP_ENABLE_BSCAN == 1) && (STAP_ENABLE_CLAMP == 1))
            // Position 9 or 10
            begin
               assert (stap_ir_opcode_position[index] == 'h04)
               else $fatal ("Parameter STAP_INSTRUCTION_FOR_DATA_REGISTERS is not correct at index:%0d", index);
               index++;
            end
            if ((STAP_ENABLE_BSCAN == 1) && (STAP_ENABLE_INTEST == 1))
            // Position 10 or 11
            begin
               assert (stap_ir_opcode_position[index] == 'h06)
               else $fatal ("Parameter STAP_INSTRUCTION_FOR_DATA_REGISTERS is not correct at index:%0d", index);
               index++;
            end
            if ((STAP_ENABLE_BSCAN == 1) && (STAP_ENABLE_RUNBIST == 1))
            // Position 11 or 12
            begin
               assert (stap_ir_opcode_position[index] == 'h07)
               else $fatal ("Parameter STAP_INSTRUCTION_FOR_DATA_REGISTERS is not correct at index:%0d", index);
               index++;
            end
            if ((STAP_ENABLE_BSCAN == 1) && (STAP_ENABLE_EXTEST_TOGGLE == 1))
            // Position 12 or 13
            begin
               assert (stap_ir_opcode_position[index] == 'h0D)
               else $fatal ("Parameter STAP_INSTRUCTION_FOR_DATA_REGISTERS is not correct at index:%0d", index);
               index++;
            end

            // Optional TAPC_SEC_SELECT Register
            if (STAP_ENABLE_TAPC_SEC_SEL == 1)
            // Position 4 or 9
            begin
               assert (stap_ir_opcode_position[index] == 'h10)
               else $fatal ("Parameter STAP_INSTRUCTION_FOR_DATA_REGISTERS is not correct at index:%0d", index);
               index++;
            end

            // Optional TAPC_WTAP_SELECT Register
            if (STAP_ENABLE_WTAP_NETWORK == 1)
            // Position 3 or above
            begin
               assert (stap_ir_opcode_position[index] == 'h13)
               else $fatal ("Parameter STAP_INSTRUCTION_FOR_DATA_REGISTERS is not correct at index:%0d", index);
               index++;
            end

            // Optional TAPC_VISAOVR Register
            if (STAP_ENABLE_TAPC_VISAOVR == 1)
            // Position 3 or above
            begin
               assert (stap_ir_opcode_position[index] == 'h15)
               else $fatal ("Parameter STAP_INSTRUCTION_FOR_DATA_REGISTERS is not correct at index:%0d", index);
               index++;
            end

            // Optional Remove Register
            if (STAP_ENABLE_TAPC_REMOVE == 1)
            // Position 3 or above
            begin
               assert (stap_ir_opcode_position[index] == 'h14)
               else $fatal ("Parameter STAP_INSTRUCTION_FOR_DATA_REGISTERS is not correct at index:%0d", index);
               index++;
            end

            // TDR
            if ((STAP_ENABLE_TEST_DATA_REGISTERS == 1) || (STAP_ENABLE_REMOTE_TEST_DATA_REGISTERS == 1))
            // Position 3 or above
            begin
               while (index < STAP_NUMBER_OF_TOTAL_REGISTERS)
               begin
                  assert (((stap_ir_opcode_position[index] >= 'h20) && (stap_ir_opcode_position[index] < {STAP_SIZE_OF_EACH_INSTRUCTION{1'b1}})) ||
                          ((stap_ir_opcode_position[index] >= 'h16) && (stap_ir_opcode_position[index] <= 'h19)))
                  else $fatal ("Parameter STAP_INSTRUCTION_FOR_DATA_REGISTERS is not correct at index:%0d", index);
                  index++;
               end
            end

            // To check IR register width
            assert (STAP_SIZE_OF_EACH_INSTRUCTION >= 'h8)
            else $fatal ("Parameter STAP_SIZE_OF_EACH_INSTRUCTION is less than 8");

            // To check WTAPNW is disabled when LIN=1
            if ((STAP_ENABLE_TAP_NETWORK == HIGH) && (STAP_ENABLE_LINEAR_NETWORK == HIGH))
            begin
               assert (STAP_ENABLE_WTAP_NETWORK == LOW)
               else $fatal ("You cannot enable a WTAP Network on a LINEAR Network Topology");
            end

            // To check Linear NW is enabled only when TAPNW is enabled
            if (STAP_ENABLE_LINEAR_NETWORK == HIGH)
            assert (STAP_ENABLE_TAP_NETWORK == HIGH)
            else $fatal ("You cannot enable Linear Network topology with out enabling 0.7 Tap Network.");

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
