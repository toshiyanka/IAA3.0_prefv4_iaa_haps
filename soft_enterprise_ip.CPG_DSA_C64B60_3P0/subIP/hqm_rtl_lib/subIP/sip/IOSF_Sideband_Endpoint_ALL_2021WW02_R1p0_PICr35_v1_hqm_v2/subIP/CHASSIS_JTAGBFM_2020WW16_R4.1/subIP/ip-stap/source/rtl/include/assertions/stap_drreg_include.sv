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
      // Parallel data changed even when stap_fsm_update_dr is not
      // asserted or TLRS is HIGH
      // ====================================================================
      property stap_data_change_when_update_dr;
         @(negedge ftap_tck)
            disable iff (powergoodrst_b == LOW)
            (stap_fsm_update_dr == LOW) |-> ##1 $stable(tdr_data_out);
      endproperty: stap_data_change_when_update_dr
      chk_stap_data_change_when_update_dr:
      assert property (stap_data_change_when_update_dr)
         else $error ("data_reg_parallel_out changes only on the negedge of tck and on update_dr");

      generate
         if (DRREG_STAP_ENABLE_TAPC_VISAOVR == 1)
         begin
            for (genvar j = 0; j < DRREG_STAP_NUMBER_OF_TAPC_VISAOVR_REGISTERS; j++)
            begin
               // ====================================================================
               // To check whether tapc_visaovr of drreg changed only on the negedge of clk
               // ====================================================================
               always @(tapc_visaovr[j])
               begin
                  if (powergoodrst_b)
                  begin
                     #1 chk_stap_drreg_visaovr_changes_on_neg_edge:
                     assert (ftap_tck == LOW)
                     else $error("tapc_visaovr of drreg changed during posedge of clk");
                  end
               end

               // ====================================================================
               // tapc_visaovr of drreg changed even when Update DR is not there or when TRST
               // is not asserted
               // ====================================================================
               always @(tapc_visaovr[j])
               begin
                  #1 chk_stap_drreg_visaovr_changed_when_update_dr_or_trst_asserted:
                  assert ((stap_fsm_update_dr == HIGH) | (powergoodrst_b == LOW))
                  else $error("tapc_visaovr of drreg changed even when there is no Update DR or when TRST is not asserted");
               end
            end
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
