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
   // check dfxsecure_all_en is equal to 1 when ftap_dfxsecure is all 1's
   // ====================================================================
   property dfxsecure_all_en_is_1_when_ftap_dfxsecure_is_all_1;
      @(ftap_dfxsecure)
      dfxsecure_all_en |-> (ftap_dfxsecure == {DFXSECURE_MTAP_DFX_SECURE_WIDTH{HIGH}});
   endproperty : dfxsecure_all_en_is_1_when_ftap_dfxsecure_is_all_1
   chk_dfxsecure_all_en_is_1_when_ftap_dfxsecure_is_all_1:
   assert property (dfxsecure_all_en_is_1_when_ftap_dfxsecure_is_all_1) else
      $error("dfxsecure_all_en is 1 when ftap_dfxsecure is not all 1's");

   // ====================================================================
   // check dfxsecure_all_dis is equal to 1 when ftap_dfxsecure is all 0's
   // ====================================================================
   property dfxsecure_all_dis_is_1_when_ftap_dfxsecure_is_all_0;
      @(ftap_dfxsecure)
      dfxsecure_all_dis |-> (ftap_dfxsecure == {DFXSECURE_MTAP_DFX_SECURE_WIDTH{LOW}});
   endproperty : dfxsecure_all_dis_is_1_when_ftap_dfxsecure_is_all_0
   chk_dfxsecure_all_dis_is_1_when_ftap_dfxsecure_is_all_0:
   assert property (dfxsecure_all_dis_is_1_when_ftap_dfxsecure_is_all_0) else
      $error("dfxsecure_all_dis is 1 when ftap_dfxsecure is not all 0's");

   // ====================================================================
   // check dfxsecure_feature_en is equal to 1 when dfxsecurestrap_feature
   // is equal to ftap_dfxsecure or when dfxsecure_all_en is 1
   // ====================================================================
   generate
      for (genvar j = 2; j < DFXSECURE_MTAP_NUMBER_OF_DFX_FEATURES_TO_SECURE; j++)
      begin
         property dfxsecure_feature_en_is_1_when_matches_strap;
            @(ftap_dfxsecure)
            dfxsecure_feature_en[j] |-> ((~dfxsecure_all_dis & dfxsecure_feature_en_int[j]) | dfxsecure_all_en);
         endproperty : dfxsecure_feature_en_is_1_when_matches_strap
         chk_dfxsecure_feature_en_is_1_when_matches_strap:
         assert property (dfxsecure_feature_en_is_1_when_matches_strap) else
            $error("dfxsecure_feature_en[j] is 1 when dfxsecurestrap_feature[j] is not equal to ftap_dfxsecure or when dfxsecure_all_en is 0");
      end
   endgenerate

   // ====================================================================
   // check that the output vodfv_all_dis is equal to All_dis
   // ====================================================================
   property vodfv_all_dis_is_equal_to_All_dis;
      @(dfxsecure_all_dis)
         (dfxsecure_all_dis | ((~dfxsecure_all_en) & (~dfxsecure_feature_en[0]))) |-> vodfv_all_dis;
   endproperty : vodfv_all_dis_is_equal_to_All_dis
   chk_vodfv_all_dis_is_equal_to_All_dis:
   assert property (vodfv_all_dis_is_equal_to_All_dis) else
      $error("vodfv_all_dis is not equal to All_dis");


   // ================================================================================================
   // check if the output vodfv_customer_dis is equal to All_dis + !(All_en).dfxsecure_feature_en[0]
   // ================================================================================================
   property vodfv_customer_dis_function_of_All_dis_All_en_dfxsecure_feature_en;
      @(ftap_dfxsecure | dfxsecurestrap_feature)
         (dfxsecure_all_dis | (~dfxsecure_all_en) | (~dfxsecure_feature_en[0])) |-> vodfv_customer_dis;
   endproperty : vodfv_customer_dis_function_of_All_dis_All_en_dfxsecure_feature_en
   chk_vodfv_customer_dis_function_of_All_dis_All_en_dfxsecure_feature_en:
   assert property (vodfv_customer_dis_function_of_All_dis_All_en_dfxsecure_feature_en) else
      $error("vodfv_customer_dis is not equal to the Logic shown in diagram 3.48");
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
