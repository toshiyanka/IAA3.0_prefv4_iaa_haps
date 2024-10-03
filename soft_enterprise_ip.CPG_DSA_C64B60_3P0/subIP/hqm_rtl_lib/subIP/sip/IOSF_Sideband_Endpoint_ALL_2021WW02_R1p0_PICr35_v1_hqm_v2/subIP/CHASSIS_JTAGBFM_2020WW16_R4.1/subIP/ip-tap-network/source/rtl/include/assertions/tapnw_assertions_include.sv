`ifdef DFX_FPV_ENABLE
   // ====================================================================
   //\\// synopsys translate_off
   // ====================================================================
`else
   // ====================================================================
   // synopsys translate_off
   // ====================================================================
`endif

    //-----------------------------------------------------------------------------------------------
`ifndef SVA_OFF
   `ifdef DFX_ASSERTIONS
   
      localparam HIGH    = 1'b1;
      localparam LOW     = 1'b0;

      // ====================================================================
      // Check TMS changes only on the negedge of clock
      // To cover the assertion TMS STABLE ON POSEDGE
      // ====================================================================
      property tapnw_assert_tms_during_posedge_clk;
         @(negedge ptapnw_ftap_tck)
            //($changed(ptapnw_ftap_tms) && (ptapnw_ftap_trst_b)) |-> (ptapnw_ftap_tck== 1'b1);
            ($changed(ptapnw_ftap_tms) && (ptapnw_ftap_trst_b)) |=> (ptapnw_ftap_tck== 1'b1);
      endproperty: tapnw_assert_tms_during_posedge_clk
      chk_tapnw_assert_tms_during_posedge_clk_0:
      assert property (tapnw_assert_tms_during_posedge_clk)
      else $error ("TMS is not asserted at negedge of ptapnw_ftap_tck, but asserted at posedge");

      // ====================================================================
      // Check TDO changes only on the negedge of clock
      // To cover the assertion TMS STABLE ON POSEDGE
      // ====================================================================
      property tapnw_assert_tdo_during_posedge_clk;
         @(negedge ptapnw_ftap_tck)
            ($changed(ntapnw_atap_tdo) && (ptapnw_ftap_trst_b)) |-> (ptapnw_ftap_tck== 1'b1);
      endproperty: tapnw_assert_tdo_during_posedge_clk
      chk_tapnw_assert_tdo_during_posedge_clk_0:
      assert property (tapnw_assert_tdo_during_posedge_clk)
      else $error ("TMS is not asserted at negedge of ptapnw_ftap_tck, but asserted at posedge");
      // ====================================================================
      genvar i;
      logic [(TAPNW_NO_OF_STAPS - 1):0] tdo_en_int_assert;
      generate
         for (i = 0; i < (TAPNW_NUMBER_OF_WTAPS + TAPNW_NUMBER_OF_STAPS); i++)
         begin
            assign tdo_en_int_assert[i] = (~tapc_secsel_reg[i] & atapnw_atap_tdo_en[i]);
         end
      endgenerate
      property tapnw_assert_tdoen_for_primary;
         @(negedge ptapnw_ftap_tck)
            ntapnw_atap_tdo_en  |-> ((|tdo_en_int_assert) == 1'b1);
      endproperty: tapnw_assert_tdoen_for_primary
      chk_tapnw_assert_tdoen_for_primary:
      assert property (tapnw_assert_tdoen_for_primary)
      else $error ("TDO Enable is is not asserted");

      // ====================================================================
      // Check if the parameter value of TAPNW_PARK_TCK_AT propogates to TCK during RUTI state.
      // There is a known limitation of the operation of this assertion.
      // This assertion fails to hold when powergoodrst_b is asserted when in TLRS state.
      // This assertion needs to be disabled when trst_b is inactive.
      // ====================================================================

      /* 07-Sep-2011. SHIVA commented this for JtagBfm 1.0 Release. This needs to be addressed for ip-tap-network.
      genvar k;
      logic [(TAPNW_NO_OF_STAPS- 1):0] parked_tck;
      logic [(TAPNW_NO_OF_STAPS- 1):0] parked_tck_compare;

      generate:q
         for (k = 0; k < TAPNW_NUMBER_OF_STAPS; k++)
         begin
            assign parked_tck[k] = TAPNW_PARK_TCK_AT[k] & ~ftapnw_ftap_enabletap[k];
            assign parked_tck_compare[k] = (parked_tck[k] == ftapnw_ftap_tck[k]) ? HIGH : LOW;
         end
      endgenerate

      property tapnw_parked_tck_during_inactive_state;
         @(negedge ptapnw_ftap_tck)
         // This assertion fails to hold when powergoodrst_b is asserted when in TLRS state.
         disable iff (powergoodrst_b == HIGH)
         (|ftapnw_ftap_enabletap == LOW) |-> ((&parked_tck_compare) == HIGH);
      endproperty: tapnw_parked_tck_during_inactive_state

      chk_tapnw_parked_tck_during_inactive_state:        
      assert property (tapnw_parked_tck_during_inactive_state)
      else $error ("Parameter TAPNW_PARK_TCK_AT value and TCK going to child sTAP's are not same during inactive state");
      */
      // ====================================================================
      // In a Hier Hybrid network, if a sTAP is on CLTAP's Secondary, 
      // his child cannot be on CLTAP's Primary.
      // Basic assumption is that in case of a Hier Hybrid network,
      // there will NOT be a Teritiary TAP port in SoC.
      // ====================================================================
 
      generate 
         if (TAPNW_HIER_HYBRID == HIGH)
         begin 
            property tapnw_if_staponsec_hischild_cannotbeonpri;
               @(negedge ptapnw_ftap_tck)
               disable iff ((TAPNW_HIER_HYBRID == LOW) && (powergoodrst_b == HIGH))
               (|ftapnw_ftap_secsel == HIGH) |-> (|ntapnw_ftap_secsel == LOW);
            endproperty: tapnw_if_staponsec_hischild_cannotbeonpri
   
            chk_tapnw_if_staponsec_hischild_cannotbeonpri:
            assert property (tapnw_if_staponsec_hischild_cannotbeonpri)
            else $error ("In a Hier Hybrid network, if a sTAP is on CLTAP's Secondary, his child cannot be on CLTAP's Primary.");
         end
      endgenerate 
      //-----------------------------------------------------------------------------------------------
   
      `endif
   `endif
   
   `ifdef DFX_FPV_ENABLE
      // ====================================================================
      //\\// synopsys translate_on
      // ====================================================================
   `else
      // ====================================================================
      // synopsys translate_on
      // ====================================================================
   `endif
