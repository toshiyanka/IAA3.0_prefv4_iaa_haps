`ifdef DFX_FPV_ENABLE
   // ====================================================================
   //\\// synopsys translate_off
   // ====================================================================
`else
   // ====================================================================
   // synopsys translate_off
   // ====================================================================
`endif

`ifndef SVA_OFF
   `ifdef DFX_ASSERTIONS
   // ====================================================================
   // To check whether visa shift register changed only on the posedge of clk
   // ====================================================================
//   always @(visa_shift_register)
//   begin
//      if (powergoodrst_b & ((mtap_fsm_shift_dr & mtap_irdecoder_drselect) == HIGH))
//      begin
//         #1 chk_mtap_visa_shift_reg_changes_on_pos_edge_when_in_shift_dr:
//         assert (atappris_tck == 1'h1)
//         else $error("mtap_visa_shift_reg changed during negedge of clk in shift_dr state");
//      end
//   end

   property mtap_visa_shift_reg_changes_on_pos_edge_when_in_shift_dr;
      @(visa_shift_register)
        (powergoodrst_b & mtap_fsm_shift_dr & mtap_irdecoder_drselect) |-> (atappris_tck == LOW);
   endproperty : mtap_visa_shift_reg_changes_on_pos_edge_when_in_shift_dr
   chk_mtap_visa_shift_reg_changes_on_pos_edge_when_in_shift_dr:
   assert property (mtap_visa_shift_reg_changes_on_pos_edge_when_in_shift_dr)
   else $error("mtap_visa_shift_reg changed during negedge of clk in shift_dr state");

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
