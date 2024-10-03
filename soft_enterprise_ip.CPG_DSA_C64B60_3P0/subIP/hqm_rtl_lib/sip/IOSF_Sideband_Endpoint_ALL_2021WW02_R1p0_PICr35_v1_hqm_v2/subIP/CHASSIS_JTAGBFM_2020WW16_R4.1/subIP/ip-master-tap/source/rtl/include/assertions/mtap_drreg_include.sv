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
      // Parallel data changed even when mtap_fsm_update_dr is not
      // asserted or TLRS is HIGH
      // ====================================================================
      property mtap_data_change_when_update_dr;
         @(negedge atappris_tck)
            disable iff (powergoodrst_b == LOW)
            (mtap_fsm_update_dr == LOW) |-> ##1 $stable(tdr_data_out);
      endproperty: mtap_data_change_when_update_dr
      chk_mtap_data_change_when_update_dr_0:
      assert property (mtap_data_change_when_update_dr)
         else $error ("data_reg_parallel_out changes only on the negedge of tck and on update_dr");

      generate
         if (DRREG_MTAP_ENABLE_CLTAPC_VISAOVR == 1)
         begin
            for (genvar j = 0; j < DRREG_MTAP_NUMBER_OF_CLTAPC_VISAOVR_REGISTERS; j++)
            begin
               // ====================================================================
               // To check whether cltapc_visaovr of drreg changed only on the negedge of clk
               // ====================================================================
               always @(cltapc_visaovr[j])
               begin
                  if (powergoodrst_b)
                  begin
                     #1 chk_mtap_drreg_visaovr_changes_on_neg_edge:
                     assert (atappris_tck == LOW)
                     else $error("cltapc_visaovr of drreg changed during posedge of clk");
                  end
               end

               // ====================================================================
               // cltapc_visaovr of drreg changed even when Update DR is not there or when TRST
               // is not asserted
               // ====================================================================
               always @(cltapc_visaovr[j])
               begin
                  #1 chk_mtap_drreg_visaovr_changed_when_update_dr_or_trst_asserted:
                  assert ((mtap_fsm_update_dr == HIGH) | (powergoodrst_b == LOW))
                  else $error("cltapc_visaovr of drreg changed even when there is no Update DR or when TRST is not asserted");
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
