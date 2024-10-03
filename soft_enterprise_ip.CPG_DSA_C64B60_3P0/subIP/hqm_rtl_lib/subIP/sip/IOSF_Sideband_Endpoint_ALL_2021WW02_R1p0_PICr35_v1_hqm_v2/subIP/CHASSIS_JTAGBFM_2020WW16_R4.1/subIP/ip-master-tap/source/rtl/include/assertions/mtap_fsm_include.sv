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
   // FSM States arc coverage points
   // ====================================================================
   wire Tlrs = tlrs_present_state;
   wire Ruti = ruti_present_state;
   wire Sdrs = sdrs_present_state;
   wire Cadr = cadr_present_state;
   wire Shdr = shdr_present_state;
   wire E1dr = e1dr_present_state;
   wire Padr = padr_present_state;
   wire E2dr = e2dr_present_state;
   wire Updr = updr_present_state;
   wire Sirs = sirs_present_state;
   wire Cair = cair_present_state;
   wire Shir = shir_present_state;
   wire E1ir = e1ir_present_state;
   wire Pair = pair_present_state;
   wire E2ir = e2ir_present_state;
   wire Upir = upir_present_state;

   // =======================================================================
   // Shift IR is not low during Pause IR state
   // =======================================================================
   property prop_stay_in_padr_for_more_than_one_clk_01;
      @(posedge atappris_tck)
         disable iff (mtap_fsm_tlrs == HIGH)
            Padr ##1 Padr;
   endproperty: prop_stay_in_padr_for_more_than_one_clk_01
   cov_prop_stay_in_padr_for_more_than_one_clk_01: cover property (prop_stay_in_padr_for_more_than_one_clk_01);
   // =======================================================================
   property prop_stay_in_pair_for_more_than_one_clk_01;
      @(posedge atappris_tck)
         disable iff (mtap_fsm_tlrs == HIGH)
            Pair ##1 Pair;
   endproperty: prop_stay_in_pair_for_more_than_one_clk_01
   cov_prop_stay_in_pair_for_more_than_one_clk_01: cover property (prop_stay_in_pair_for_more_than_one_clk_01);
   // =======================================================================
   property prop_stay_in_shdr_for_more_than_one_clk_01;
      @(posedge atappris_tck)
         disable iff (mtap_fsm_tlrs == HIGH)
            Shdr ##1 Shdr;
   endproperty: prop_stay_in_shdr_for_more_than_one_clk_01
   cov_prop_stay_in_shdr_for_more_than_one_clk_01: cover property (prop_stay_in_shdr_for_more_than_one_clk_01);
   // =======================================================================
   property prop_stay_in_shir_for_more_than_one_clk_01;
      @(posedge atappris_tck)
         disable iff (mtap_fsm_tlrs == HIGH)
            Shir ##1 Shir;
   endproperty: prop_stay_in_shir_for_more_than_one_clk_01
   cov_prop_stay_in_shir_for_more_than_one_clk_01: cover property (prop_stay_in_shir_for_more_than_one_clk_01);
   // =======================================================================
   property prop_transition_from_e2dr_to_shdr_01;
      @(posedge atappris_tck)
         disable iff (mtap_fsm_tlrs == HIGH)
            E2dr ##1 Shdr;
   endproperty: prop_transition_from_e2dr_to_shdr_01
   cov_prop_transition_from_e2dr_to_shdr_01: cover property (prop_transition_from_e2dr_to_shdr_01);
   // =======================================================================
   property prop_transition_from_e2dr_to_shir_01;
      @(posedge atappris_tck)
         disable iff (mtap_fsm_tlrs == HIGH)
            E2ir ##1 Shir;
   endproperty: prop_transition_from_e2dr_to_shir_01
   cov_prop_transition_from_e2dr_to_shir_01: cover property (prop_transition_from_e2dr_to_shir_01);
   // =======================================================================
   property prop_stay_in_ruti_for_more_than_one_clk_01;
      @(posedge atappris_tck)
         disable iff (mtap_fsm_tlrs == HIGH)
            Ruti ##1 Ruti;
   endproperty: prop_stay_in_ruti_for_more_than_one_clk_01
   cov_prop_stay_in_ruti_for_more_than_one_clk_01: cover property (prop_stay_in_ruti_for_more_than_one_clk_01);
   // =======================================================================
   property prop_stay_in_tlrs_for_more_than_one_clk_01;
      @(posedge atappris_tck)
         disable iff (mtap_fsm_tlrs == LOW)
            Tlrs ##1 Tlrs;
   endproperty: prop_stay_in_tlrs_for_more_than_one_clk_01
   cov_prop_stay_in_tlrs_for_more_than_one_clk_01: cover property (prop_stay_in_tlrs_for_more_than_one_clk_01);
   // =======================================================================
   property prop_transition_from_cadr_to_e1dr_01;
      @(posedge atappris_tck)
         disable iff (mtap_fsm_tlrs == HIGH)
            Cadr ##1 E1dr;
   endproperty: prop_transition_from_cadr_to_e1dr_01
   cov_prop_transition_from_cadr_to_e1dr_01: cover property (prop_transition_from_cadr_to_e1dr_01);
   // =======================================================================
   property prop_transition_from_cair_to_e1ir_01;
      @(posedge atappris_tck)
         disable iff (mtap_fsm_tlrs == HIGH)
            Cair ##1 E1ir;
   endproperty: prop_transition_from_cair_to_e1ir_01
   cov_prop_transition_from_cair_to_e1ir_01: cover property (prop_transition_from_cair_to_e1ir_01);
   // =======================================================================
   property prop_transition_from_e1dr_to_updr_01;
      @(posedge atappris_tck)
         disable iff (mtap_fsm_tlrs == HIGH)
            E1dr ##1 Updr;
   endproperty: prop_transition_from_e1dr_to_updr_01
   cov_prop_transition_from_e1dr_to_updr_01: cover property (prop_transition_from_e1dr_to_updr_01);
   // =======================================================================
   property prop_transition_from_e1ir_to_upir_01;
      @(posedge atappris_tck)
         disable iff (mtap_fsm_tlrs == HIGH)
            E1ir ##1 Upir;
   endproperty: prop_transition_from_e1ir_to_upir_01
   cov_prop_transition_from_e1ir_to_upir_01: cover property (prop_transition_from_e1ir_to_upir_01);
   // =======================================================================

`ifndef SVA_OFF
   `ifdef DFX_ASSERTIONS
      // ====================================================================
      // Shift IR is low during Pause IR state
      // ====================================================================
//      always @(Pair)
//      begin
//         #1;
//         if (mtap_fsm_tlrs == LOW)
//         begin
//            if (Pair)
//            begin
//               chk_mtap_shift_ir_low_when_pause_ir_0: assert (mtap_fsm_shift_ir == LOW)
//               else $error("Shift IR is not low during Pause IR state");
//            end
//         end
//      end

      property mtap_shift_ir_low_when_pause_ir_0;
          @(posedge atappris_tck)
             disable iff (mtap_fsm_tlrs == HIGH)
             (Pair) |-> (mtap_fsm_shift_ir == LOW);
      endproperty : mtap_shift_ir_low_when_pause_ir_0

      chk_mtap_shift_ir_low_when_pause_ir_0 : assert property (mtap_shift_ir_low_when_pause_ir_0)
      else $error("Shift IR is not low during Pause IR state");

      // ====================================================================
      // Shift DR is not low during Pause DR state
      // ====================================================================
//      always @(Padr)
//      begin
//         #1;
//         if (mtap_fsm_tlrs == LOW)
//         begin
//            if (Padr)
//            begin
//               chk_mtap_shift_dr_low_when_pause_dr_0: assert (mtap_fsm_shift_dr == LOW)
//               else $error("Shift DR is not low during Pause DR state");
//            end
//         end
//      end

      property mtap_shift_dr_low_when_pause_dr_0;
          @(posedge atappris_tck)
             disable iff (mtap_fsm_tlrs == HIGH)
             (Padr) |-> (mtap_fsm_shift_dr == LOW);
      endproperty : mtap_shift_dr_low_when_pause_dr_0

      chk_mtap_shift_dr_low_when_pause_dr_0 : assert property (mtap_shift_dr_low_when_pause_dr_0)
      else $error("Shift DR is not low during Pause DR state");

      // ====================================================================
      // Check Scan IR Glitch free Pulse
      // ====================================================================
      generate
         if ((FSM_MTAP_ENABLE_TAP_NETWORK == 1) || (FSM_MTAP_WTAP_COMMON_LOGIC == 1))
         begin
            property scanir_glitch_free_pulse;
               @(posedge atappris_tck)
                  (Sirs || Cair || Shir || E1ir || Pair || E2ir || Upir) && (mtap_fsm_tlrs == LOW) |-> mtap_selectwir;
            endproperty: scanir_glitch_free_pulse
            chk_scanir_glitch_free_pulse_0:
            assume property (scanir_glitch_free_pulse);
//               else $error ("Select WIR pulse is not high during scan IR");
         end
      endgenerate
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
