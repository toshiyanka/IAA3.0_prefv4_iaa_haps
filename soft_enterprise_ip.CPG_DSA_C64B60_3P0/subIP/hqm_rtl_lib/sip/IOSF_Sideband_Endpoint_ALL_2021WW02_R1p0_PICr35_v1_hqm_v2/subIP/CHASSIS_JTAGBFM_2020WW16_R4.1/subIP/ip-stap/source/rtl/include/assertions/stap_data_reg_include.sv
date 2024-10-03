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
      // data_reg_parallel_out is not equal to reset value during reset_b
      // ====================================================================
//      always @(posedge ftap_tck)
//      begin
//         if (!reset_b == HIGH)
//         begin
//            @(posedge ftap_tck)
//            chk_stap_dr_stable_during_trst: assert (tdr_data_out == DATA_REG_STAP_RESET_VALUES_OF_TEST_DATA_REGISTERS)
//            else $error("data_reg_parallel_out is not equal to reset value during reset_b");
//         end
//      end

   property stap_dr_stable_during_trst;
      @(posedge ftap_tck)
      (!reset_b) |=> (tdr_data_out == DATA_REG_STAP_RESET_VALUES_OF_TEST_DATA_REGISTERS);
   endproperty : stap_dr_stable_during_trst

   chk_stap_dr_stable_during_trst : 
   assert property (stap_dr_stable_during_trst) else
      $error("data_reg_parallel_out is not equal to reset value during reset_b");

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
