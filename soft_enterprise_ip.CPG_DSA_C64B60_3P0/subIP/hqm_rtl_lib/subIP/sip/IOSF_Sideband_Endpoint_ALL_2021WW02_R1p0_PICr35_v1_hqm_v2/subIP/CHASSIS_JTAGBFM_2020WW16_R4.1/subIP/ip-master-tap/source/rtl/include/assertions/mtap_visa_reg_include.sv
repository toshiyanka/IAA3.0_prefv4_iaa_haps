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
   // visa_reg_parallel_out is not equal to reset value during powergoodrst_b
   // ====================================================================
//   always @(posedge atappris_tck)
//   begin
//      if (powergoodrst_b == LOW)
//      begin
//         #1 chk_mtap_visa_reg_parallel_out_is_stable_during_trst:
//         assert (visa_reg_parallel_out == VISA_REG_MTAP_VISAOVR_RESET_VALUE)
//         else $error("visa_reg_parallel_out is not equal to 0 during powergoodrst_b");
//      end
//   end

   property mtap_visa_reg_parallel_out_is_stable_during_trst;
      @(posedge atappris_tck)
         (!powergoodrst_b) -> (visa_reg_parallel_out == VISA_REG_MTAP_VISAOVR_RESET_VALUE);
   endproperty : mtap_visa_reg_parallel_out_is_stable_during_trst
   chk_mtap_visa_reg_parallel_out_is_stable_during_trst:
   assert property (mtap_visa_reg_parallel_out_is_stable_during_trst)
   else $error("visa_reg_parallel_out is not equal to 0 during powergoodrst_b");


   // ====================================================================
   // To check whether visa register changes only on the negedge of clk
   // ====================================================================
//   always @(visa_reg_parallel_out)
//   begin
//      if (powergoodrst_b & ((mtap_fsm_update_dr & selected_visa_reg) == HIGH))
//      begin
//         #1 chk_mtap_visa_regs_parallel_out_changes_on_neg_edge_when_in_update_dr:
//         assert (atappris_tck == LOW)
//         else $error("visa_regs_parallel_out changed during posedge of clk in update dr state");
//      end
//   end

   property mtap_visa_regs_parallel_out_changes_on_neg_edge_when_in_update_dr;
      @(visa_reg_parallel_out)
         (powergoodrst_b & mtap_fsm_update_dr & selected_visa_reg) |-> (atappris_tck == HIGH);
   endproperty : mtap_visa_regs_parallel_out_changes_on_neg_edge_when_in_update_dr
   chk_mtap_visa_regs_parallel_out_changes_on_neg_edge_when_in_update_dr:
   assert property (mtap_visa_regs_parallel_out_changes_on_neg_edge_when_in_update_dr)
   else $error("visa_regs_parallel_out changed during posedge of clk in update dr state");

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
