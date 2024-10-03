`ifdef DFX_FPV_ENABLE
   // ====================================================================
   //\\// synopsys translate_off
   // ====================================================================
`else
   // ====================================================================
   // synopsys translate_off
   // ====================================================================
`endif
   // ====================================================================
   // To check whether stap_irreg_ireg is 0x0C during TLRS
   // ====================================================================
`ifndef SVA_OFF
   `ifdef DFX_ASSERTIONS
      // ====================================================================
      // Parallel output of shift IR changed when stap_fsm_update_ir is
      // not HIGH or TLRS is not HIGH
      // ====================================================================
//      always @(stap_irreg_ireg)
//      begin
//         #1;
//         if (stap_fsm_tlrs == HIGH)
//         begin
//            chk_stap_irreg_change_when_update_ir_0:
//            assert ((stap_fsm_update_ir == HIGH) || (stap_fsm_tlrs == HIGH))
//            else $error("Parallel output of shift IR changed when stap_fsm_update_ir is not HIGH or TLRS is LOW");
//         end
//      end
//
      property stap_irreg_change_when_update_ir_0;
         @(posedge ftap_tck)
            ($changed(stap_irreg_ireg)) |-> ((stap_fsm_update_ir == HIGH) || (stap_fsm_tlrs == HIGH));
      endproperty : stap_irreg_change_when_update_ir_0
      chk_stap_irreg_change_when_update_ir_0:
      assert property (stap_irreg_change_when_update_ir_0)
      else $error("Parallel output of shift IR changed when stap_fsm_update_ir is not HIGH or TLRS is LOW");


      // ====================================================================
      // shift_reg is not equal to reset value (1)
      // ====================================================================
      property stap_shift_ir_reg_equals_01_during_tlrs;
         @(posedge ftap_tck)
            (stap_fsm_tlrs       == HIGH) ||  (powergoodrst_trst_b == LOW) ||
            (stap_fsm_capture_ir == HIGH) |=> (shift_reg == 1);
      endproperty: stap_shift_ir_reg_equals_01_during_tlrs
      chk_stap_shift_ir_reg_equals_01_during_tlrs_0:
      assert property (stap_shift_ir_reg_equals_01_during_tlrs)
         else $error("shift IR reg is not equal to 1 during reset");

      // ====================================================================
      // stap_irreg_ireg is not equal to reset value
      // ====================================================================
      property stap_ir_equals_slvidcode;
         @(posedge ftap_tck)
            (stap_fsm_tlrs   == HIGH) || (powergoodrst_trst_b == LOW) |=>
            (stap_irreg_ireg == IRREG_STAP_ADDRESS_OF_SLVIDCODE);
      endproperty: stap_ir_equals_slvidcode
      chk_stap_ir_equals_slvidcode_01:
      assume property (stap_ir_equals_slvidcode);
//         else $error("stap_irreg_ireg is not equal to reset value (IRREG_STAP_ADDRESS_OF_SLVIDCODE)");
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
