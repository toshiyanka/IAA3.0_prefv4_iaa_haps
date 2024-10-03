//------------------------------------------------------------------------------
//  INTEL CONFIDENTIAL
//
//  Copyright 2020 Intel Corporation All Rights Reserved.
//
//  The source code contained or described herein and all documents related
//  to the source code (Material) are owned by Intel Corporation or its
//  suppliers or licensors. Title to the Material remains with Intel
//  Corporation or its suppliers and licensors. The Material contains trade
//  secrets and proprietary and confidential information of Intel or its
//  suppliers and licensors. The Material is protected by worldwide copyright
//  and trade secret laws and treaty provisions. No part of the Material may
//  be used, copied, reproduced, modified, published, uploaded, posted,
//  transmitted, distributed, or disclosed in any way without Intel's prior
//  express written permission.
//
//  No license under any patent, copyright, trade secret or other intellectual
//  property right is granted to or conferred upon you by disclosure or
//  delivery of the Materials, either expressly, by implication, inducement,
//  estoppel or otherwise. Any license under such intellectual property rights
//  must be express and approved by Intel in writing.
//
//  Collateral Description:
//  dteg-stap
//
//  Source organization:
//  DTEG Engineering Group (DTEG)
//
//  Support Information:
//  HSD: https://hsdes.intel.com/appstore/article/#/dft_services.bugeco/create
//
//  Revision:
//  DTEG_sTAP_2020WW05_RTL1P0_PIC6_V1
//
//  Module <sTAP> :  < put your functional description here in plain text >
//
//------------------------------------------------------------------------------

`ifndef INTEL_SVA_OFF
   `ifdef DFX_ASSERTIONS
      // ====================================================================
      // Parallel data changed even when stap_fsm_update_dr is not
      // asserted or TLRS is HIGH
      // ====================================================================
      property stap_data_change_when_update_dr;
         @(negedge ftap_tck)
            disable iff ((fdfx_powergood !== HIGH) || (stap_fsm_tlrs === HIGH))
            (stap_fsm_update_dr === LOW) |-> ##1 $stable(tdr_data_out);
      endproperty: stap_data_change_when_update_dr
      chk_stap_data_change_when_update_dr:
      assert property (stap_data_change_when_update_dr)
         else $error ("data_reg_parallel_out changes only on the negedge of tck and on update_dr");

     // =============================================================
     // If both the bits of 'h15 are low or powergood is low then
     // the tdr_data_out should be the reset value.
     // =============================================================
      generate
         if ((DRREG_STAP_ENABLE_TEST_DATA_REGISTERS === HIGH) || (DRREG_STAP_ENABLE_ITDR_PROG_RST === HIGH))
         begin
            property check_itdr_powergood_reset_option;
               @(posedge ftap_tck)
                  ((tapc_tdrrsten_reg === 2'b00) &&
                   (fdfx_powergood === LOW)) |-> (tdr_data_out === DRREG_STAP_RESET_VALUES_OF_TEST_DATA_REGISTERS);
            endproperty: check_itdr_powergood_reset_option
            chk_check_itdr_powergood_reset_option:
            assert property (check_itdr_powergood_reset_option)
               else $error ("tdr_data_out is not equal to Reset value when powergood is enabled");


            for (genvar t = 0; t < DRREG_STAP_NUMBER_OF_TEST_DATA_REGISTERS_NZ; t = t + 1)
            begin
               // =============================================================
               // Check tdr_data_out is equal to reset value when that particular
               // bit in h'16 is HIGH and h'15 is set to ftap_trst_b(2'b01 or 2'b11)
               // option of prog reset and ftap_trst_b is LOW.
               // =============================================================
               property check_itdr_trst_b_option_enabled_for_this_itdr;
                  @(posedge ftap_tck)
                     ( ((tapc_tdrrsten_reg === 2'b01) || (tapc_tdrrsten_reg === 2'b11)) &&
                       (tapc_itdrrstsel_reg[t] === HIGH) &&
                       ((ftap_trst_b === LOW) || (stap_fsm_tlrs === HIGH))
                     ) |->
                     ((tdr_data_out[(DRREG_STAP_MSB_VALUES_OF_TEST_DATA_REGISTERS[
                                       (((t * DRREG_STAP_NUMBER_OF_BITS_FOR_SLICE) +
                                              DRREG_STAP_NUMBER_OF_BITS_FOR_SLICE) - 1):
                                          (t * DRREG_STAP_NUMBER_OF_BITS_FOR_SLICE)]):
                                    (DRREG_STAP_LSB_VALUES_OF_TEST_DATA_REGISTERS[
                                        (((t * DRREG_STAP_NUMBER_OF_BITS_FOR_SLICE) +
                                           DRREG_STAP_NUMBER_OF_BITS_FOR_SLICE) - 1):
                                        (t * DRREG_STAP_NUMBER_OF_BITS_FOR_SLICE)])])
                       === (DRREG_STAP_RESET_VALUES_OF_TEST_DATA_REGISTERS[
                               (DRREG_STAP_MSB_VALUES_OF_TEST_DATA_REGISTERS[
                                  (((t * DRREG_STAP_NUMBER_OF_BITS_FOR_SLICE) +
                                     DRREG_STAP_NUMBER_OF_BITS_FOR_SLICE) - 1):
                                  (t * DRREG_STAP_NUMBER_OF_BITS_FOR_SLICE)]):
                               (DRREG_STAP_LSB_VALUES_OF_TEST_DATA_REGISTERS[
                                  (((t * DRREG_STAP_NUMBER_OF_BITS_FOR_SLICE) +
                                     DRREG_STAP_NUMBER_OF_BITS_FOR_SLICE) - 1):
                                  (t * DRREG_STAP_NUMBER_OF_BITS_FOR_SLICE)])]));
               endproperty: check_itdr_trst_b_option_enabled_for_this_itdr
               chk_check_itdr_trst_b_option_enabled_for_this_itdr:
               assert property (check_itdr_trst_b_option_enabled_for_this_itdr)
                  else $error ("tdr_data_out is not equal to Reset value when ftap_trst_b is enabled");

               // =============================================================
               // Check tdr_data_out is equal to reset value when that particular
               // bit in h'16 is HIGH and h'15 is set to soft reset(2'b10)
               // option of prog reset.
               // =============================================================
               property check_itdr_softrst_option_enabled_for_this_itdr;
                  @(posedge ftap_tck)
                     ((tapc_tdrrsten_reg === 2'b10) &&
                      (tapc_itdrrstsel_reg[t] === HIGH)) |->
                     ((tdr_data_out[(DRREG_STAP_MSB_VALUES_OF_TEST_DATA_REGISTERS[
                                       (((t * DRREG_STAP_NUMBER_OF_BITS_FOR_SLICE) +
                                              DRREG_STAP_NUMBER_OF_BITS_FOR_SLICE) - 1):
                                          (t * DRREG_STAP_NUMBER_OF_BITS_FOR_SLICE)]):
                                    (DRREG_STAP_LSB_VALUES_OF_TEST_DATA_REGISTERS[
                                        (((t * DRREG_STAP_NUMBER_OF_BITS_FOR_SLICE) +
                                           DRREG_STAP_NUMBER_OF_BITS_FOR_SLICE) - 1):
                                        (t * DRREG_STAP_NUMBER_OF_BITS_FOR_SLICE)])])
                       === (DRREG_STAP_RESET_VALUES_OF_TEST_DATA_REGISTERS[
                               (DRREG_STAP_MSB_VALUES_OF_TEST_DATA_REGISTERS[
                                  (((t * DRREG_STAP_NUMBER_OF_BITS_FOR_SLICE) +
                                     DRREG_STAP_NUMBER_OF_BITS_FOR_SLICE) - 1):
                                  (t * DRREG_STAP_NUMBER_OF_BITS_FOR_SLICE)]):
                               (DRREG_STAP_LSB_VALUES_OF_TEST_DATA_REGISTERS[
                                  (((t * DRREG_STAP_NUMBER_OF_BITS_FOR_SLICE) +
                                     DRREG_STAP_NUMBER_OF_BITS_FOR_SLICE) - 1):
                                  (t * DRREG_STAP_NUMBER_OF_BITS_FOR_SLICE)])]));
               endproperty: check_itdr_softrst_option_enabled_for_this_itdr
               chk_check_itdr_softrst_option_enabled_for_this_itdr:
               assert property (check_itdr_softrst_option_enabled_for_this_itdr)
                  else $error ("tdr_data_out is not equal to Reset value when soft reset is enabled");
            end
         end
         else
         begin
            property chk_tdr_data_out_when_tdr_not_enabled;
            @(posedge ftap_tck)
               disable iff (fdfx_powergood !== HIGH)
               (DRREG_STAP_ENABLE_TEST_DATA_REGISTERS === LOW) |-> (tdr_data_out[0] === LOW);
            endproperty: chk_tdr_data_out_when_tdr_not_enabled
            chk_chk_tdr_data_out_when_tdr_not_enabled:
            assert property (chk_tdr_data_out_when_tdr_not_enabled)
            else $error("The tdr_data_out is not low when the ITDRs are disabled");
         end
      endgenerate

      // ====================================================================
      // Check the programable reset mechanism for RTDRs
      // Based on the programmable reset option value programmed in 'h15.
      // ====================================================================
      generate
         if ((DRREG_STAP_ENABLE_REMOTE_TEST_DATA_REGISTERS === HIGH) || (DRREG_STAP_ENABLE_RTDR_PROG_RST === HIGH))
         begin: gen_sk
            for (genvar x = 0; x < DRREG_STAP_NUMBER_OF_REMOTE_TEST_DATA_REGISTERS_NZ; x = x + 1)
            begin: gen_sk_for
               always @(posedge ftap_tck)
               begin
                  // =============================================================
                  // If both the bits of 'h15 are low or powergood is low then
                  // the every bit of tap_rtdr_prog_rst_b should follow powergood.
                  // =============================================================
                  if ((tapc_tdrrsten_reg === 2'b00) && (fdfx_powergood === LOW))
                  begin
                     chk_prog_rst_pwrgud:
                     assert property (tap_rtdr_prog_rst_b[x] === fdfx_powergood)
                     else $error("There is no reset for RTDR on fdfx_powergood when the programmable reset option is powergood");
                  end

                  // =============================================================
                  // If the bits of 'h15 are 2'b01 or 2'b11 and the respective bit
                  // in the register 'h17 is high then that particular bit of
                  // tap_rtdr_prog_rst_b should follow ftap_trst_b.
                  // =============================================================
                  if (((tapc_tdrrsten_reg === 2'b01) || (tapc_tdrrsten_reg === 2'b11)) &&
                       (tapc_rtdrrstsel_reg[x] === HIGH))
                  begin
                     // If any of bits of 'h17 are high and '15 is programmed to trst_b ..
                     chk_prog_rtdr_rst_trst_b:
                     assert property (tap_rtdr_prog_rst_b[x] === (ftap_trst_b & !(stap_fsm_tlrs === HIGH)))
                     else $error("There is no reset for RTDR on ftap_trst_b when the programmable reset option is ftap_trst_b");
                  end

                  // =============================================================
                  // If the bits of 'h15 are 2'b10 the respective bit
                  // in the register 'h17 is high then that particular bit of
                  // tap_rtdr_prog_rst_b should be Zero.
                  // =============================================================
                  if ((tapc_tdrrsten_reg === 2'b10) && (tapc_rtdrrstsel_reg[x] === HIGH))
                  begin
                     chk_prog_rtdr_rst_soft_when_17_is_high:
                     assert property (tap_rtdr_prog_rst_b[x] === LOW)
                     else $error("There is no reset for RTDR on soft reset when the programmable reset option is enabled for soft reset");
                  end

                  if ((tapc_tdrrsten_reg === 2'b10) && (tapc_rtdrrstsel_reg[x] === LOW))
                  begin
                     chk_prog_rtdr_rst_soft_when_17_is_low:
                     assert property (tap_rtdr_prog_rst_b[x] === HIGH)
                     else $error("There is reset for RTDR on soft reset when the programmable reset option is disable for soft reset");
                  end

               end
            end
         end
         else
         begin
            always @(posedge ftap_tck)
            begin
               if (fdfx_powergood === HIGH)
               begin
                  chk_rtdr_prog_rst_when_rtdr_disabled:
                  assert property (tap_rtdr_prog_rst_b[0] === HIGH)
                  else $error("The tap_rtdr_prog_rst_b is not HIGH when the RTDRs are disabled");
               end
            end
         end
      endgenerate

       // ====================================================================
       // Check at any given point of time only one bit of stap_irdecoder_drselect
       // should be high
       // ====================================================================
       check_irdec_only_one_bit_is_high:assert property ( @(posedge ftap_tck) $onehot0(stap_irdecoder_drselect) ) 
       else $error("Only one bit of stap_irdecoder_drselect is not one at a time"); 

   `endif
`endif


//-------------------------------------------------------------------------------------------
`ifndef INTEL_SVA_OFF
   `ifdef DFX_PARAMETER_CHECKER
      `ifndef DFX_FPV_ENABLE
          initial
          begin
             // ====================================================================
             // To check the width of stap_irdecoder_drselect is equal to
             // DRREG_STAP_NUMBER_OF_TOTAL_REGISTERS
             // ====================================================================
             assert ($size(stap_irdecoder_drselect) === DRREG_STAP_NUMBER_OF_TOTAL_REGISTERS)
             else $fatal ("The width of the stap_irdecoder_drselect is not equal to DRREG_STAP_NUMBER_OF_TOTAL_REGISTERS");
             $display ("stap_irdecoder_drselect_width     = %0d ", $size(stap_irdecoder_drselect));
          end
      `endif // DFX_FPV_ENABLE
   `endif // DFX_PARAMETER_CHECKER
`endif // INTEL_SVA_OFF
