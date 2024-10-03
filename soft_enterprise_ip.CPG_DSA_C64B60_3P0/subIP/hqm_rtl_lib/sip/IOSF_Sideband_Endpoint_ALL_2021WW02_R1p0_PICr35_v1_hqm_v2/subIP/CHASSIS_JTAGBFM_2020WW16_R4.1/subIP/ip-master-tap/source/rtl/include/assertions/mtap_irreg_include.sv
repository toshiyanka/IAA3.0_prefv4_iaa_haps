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
   // To check whether mtap_irreg_ireg is 0x0C during TLRS
   // ====================================================================
`ifndef SVA_OFF
   `ifdef DFX_ASSERTIONS
      // ====================================================================
      // Parallel output of shift IR changed when mtap_fsm_update_ir is
      // not HIGH or TLRS is not HIGH
      // ====================================================================
//      always @(mtap_irreg_ireg)
//      begin
//         #1;
//         if (mtap_fsm_tlrs == HIGH)
//         begin
//            chk_mtap_irreg_change_when_update_ir_0:
//            assert ((mtap_fsm_update_ir == HIGH) || (mtap_fsm_tlrs == HIGH))
//            else $error("Parallel output of shift IR changed when mtap_fsm_update_ir is not HIGH or TLRS is LOW");
//         end
//      end

      property mtap_irreg_change_when_update_ir_0;
         @(posedge atappris_tck)
            ($changed(mtap_irreg_ireg)) |-> ((mtap_fsm_update_ir == HIGH) || (mtap_fsm_tlrs == HIGH));
      endproperty : mtap_irreg_change_when_update_ir_0
      chk_mtap_irreg_change_when_update_ir_0:
      assert property (mtap_irreg_change_when_update_ir_0)
      else $error("Parallel output of shift IR changed when mtap_fsm_update_ir is not HIGH or TLRS is LOW");

      // ====================================================================
      // shift_reg is not equal to reset value (1)
      // ====================================================================
      property mtap_shift_ir_reg_equals_01_during_tlrs;
         @(posedge atappris_tck)
            (mtap_fsm_tlrs       == HIGH) ||  (powergoodrst_trst_b == LOW) ||
            (mtap_fsm_capture_ir == HIGH) |=> (shift_reg == 1);
      endproperty: mtap_shift_ir_reg_equals_01_during_tlrs
      chk_mtap_shift_ir_reg_equals_01_during_tlrs_0:
      assert property (mtap_shift_ir_reg_equals_01_during_tlrs)
         else $error("shift IR reg is not equal to 1 during reset");

      // ====================================================================
      // stap_irreg_ireg is not equal to reset value
      // ====================================================================
      property mtap_ir_equals_slvidcode;
         @(posedge atappris_tck)
            (mtap_fsm_tlrs   == HIGH) || (powergoodrst_trst_b == LOW) |=>
            (mtap_irreg_ireg == IRREG_MTAP_ADDRESS_OF_IDCODE);
      endproperty: mtap_ir_equals_slvidcode
      chk_mtap_ir_equals_idcode_01:
      assume property (mtap_ir_equals_slvidcode);
//         else $error("mtap_irreg_ireg is not equal to reset value (IRREG_MTAP_ADDRESS_OF_IDCODE)");
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
