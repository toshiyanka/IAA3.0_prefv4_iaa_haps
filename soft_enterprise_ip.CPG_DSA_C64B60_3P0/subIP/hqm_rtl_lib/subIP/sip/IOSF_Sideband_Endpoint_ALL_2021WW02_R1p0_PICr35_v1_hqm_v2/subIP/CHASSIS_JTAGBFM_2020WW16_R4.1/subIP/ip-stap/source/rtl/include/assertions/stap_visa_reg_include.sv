`ifdef DFX_FPV_ENABLE
   // ====================================================================
   //\\// synopsys translate_off
   // ====================================================================
`else
   // ====================================================================
   // synopsys translate_off
   // ====================================================================
`endif

  wire ftap_tck_delayed_by_1ps;
  assign #1 ftap_tck_delayed_by_1ps  = ftap_tck;

  wire visa_reg_changed;
  assign visa_reg_changed = ^visa_reg_parallel_out;

  wire visa_reg_changed_delayed_by_1ps;
  assign #1 visa_reg_changed_delayed_by_1ps  = visa_reg_changed;

  wire visa_reg_changed_pulse;
  assign visa_reg_changed_pulse              = visa_reg_changed ^ visa_reg_changed_delayed_by_1ps;

`ifndef SVA_OFF
`ifdef DFX_ASSERTIONS
   // ====================================================================
   // visa_reg_parallel_out is not equal to reset value during powergoodrst_b
   // ====================================================================
//   always @(posedge ftap_tck)
//   begin
//      if (powergoodrst_b == LOW)
//      begin
//         #1 chk_stap_visa_reg_parallel_out_is_stable_during_trst:
//         assert (visa_reg_parallel_out == VISA_REG_STAP_VISAOVR_RESET_VALUE)
//         else $error("visa_reg_parallel_out is not equal to 0 during powergoodrst_b");
//      end
//   end

   property stap_visa_reg_parallel_out_is_stable_during_trst;
      @(posedge ftap_tck)
         (!powergoodrst_b) |-> (visa_reg_parallel_out == VISA_REG_STAP_VISAOVR_RESET_VALUE);
   endproperty : stap_visa_reg_parallel_out_is_stable_during_trst
   chk_stap_visa_reg_parallel_out_is_stable_during_trst:
   assert property (stap_visa_reg_parallel_out_is_stable_during_trst)
   else $error("visa_reg_parallel_out is not equal to 0 during powergoodrst_b");

   // ====================================================================
   // To check whether visa register changes only on the negedge of clk
   // ====================================================================
//   always @(visa_reg_parallel_out)
//   begin
//      if (powergoodrst_b & ((stap_fsm_update_dr & selected_visa_reg) == HIGH))
//      begin
//         #1 chk_stap_visa_regs_parallel_out_changes_on_neg_edge_when_in_update_dr:
//         assert (ftap_tck == LOW)
//         else $error("visa_regs_parallel_out changed during posedge of clk in update dr state");
//      end
//   end

   //property stap_visa_regs_parallel_out_changes_on_neg_edge_when_in_update_dr;
   //   @(visa_reg_parallel_out)
   //      (powergoodrst_b & stap_fsm_update_dr & selected_visa_reg) |-> (ftap_tck == HIGH);
   //endproperty : stap_visa_regs_parallel_out_changes_on_neg_edge_when_in_update_dr
   //chk_stap_visa_regs_parallel_out_changes_on_neg_edge_when_in_update_dr:
   //assert property (stap_visa_regs_parallel_out_changes_on_neg_edge_when_in_update_dr)
   //else $error("visa_regs_parallel_out changed during posedge of clk in update dr state");

   property stap_visa_regs_parallel_out_changes_on_neg_edge_when_in_update_dr;
      @(posedge ftap_tck_delayed_by_1ps)
         (powergoodrst_b & stap_fsm_update_dr & selected_visa_reg) |-> (visa_reg_changed_pulse == LOW);
   endproperty : stap_visa_regs_parallel_out_changes_on_neg_edge_when_in_update_dr
   chk_stap_visa_regs_parallel_out_changes_on_neg_edge_when_in_update_dr:
   assert property (stap_visa_regs_parallel_out_changes_on_neg_edge_when_in_update_dr)
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
