//-- abbiswal--//
//-- This was used in HQM v1 for switching off assertions in iosf VC. This is not used in HQM v2. 
//-- This is in the database for reference purpose only.


module hqm_tb_assert_off();


  //-----------------------------------------------
   // Testbench level assert-off initial blocks.
   // Demonstrate how to disable specific assertions
   // for all tests that run on this testbench.
   //-----------------------------------------------
//`ifndef SVA_IOSF_ON
      
      initial begin: FABRIC_ASSERTOFF_INITIAL
            // HSD 2901790
            //$assertoff (0, iosf_fabric_VC.genblk1.primary_compmon.iosf_prim_signal_checks.PRI_157_tdec_ValidFromReset.PRI_157_tdec_ValidFromReset_ASSERT);
             $assertoff (0, hqm_tb_top.hqm_test_island.iosf_fabric_VC.genblk1.primary_compmon.iosf_prim_master_completion_compliance_checks.PRI_141_AtomicCompletionByteCountMustBeOperandSize.PRI_141_AtomicCompletionByteCountMustBeOperandSize_ASSERT);
             $assertoff (0, hqm_tb_top.hqm_test_island.iosf_fabric_VC.genblk1.primary_compmon.iosf_prim_master_completion_compliance_checks.PRI_141_CASCompletionByteCountMustBeOperandSize.PRI_141_CASCompletionByteCountMustBeOperandSize_ASSERT);

                if($test$plusargs("CONFIG_LENGTH_CHECK"))begin
             $assertoff(0,hqm_tb_top.hqm_test_island.iosf_fabric_VC.genblk1.primary_compmon.iosf_prim_transaction_credit_checks.TargetCreditCountersPerChannel[0].TargetCreditCountersPerClass[1].PRI_020_DATACREDIT_COUNTER_EXCEEDS_INITIALIZED_VALUE.PRI_020_DATACREDIT_COUNTER_EXCEEDS_INITIALIZED_VALUE_ASSERT);
             $assertoff(0,hqm_tb_top.hqm_test_island.iosf_fabric_VC.genblk1.primary_compmon.iosf_prim_transaction_credit_checks.TargetCreditCountersPerChannel[0].TargetCreditCountersPerClass[1].PRI_NOT_ALL_TRANSACTION_CREDITS_RETURNED_ERR.PRI_NOT_ALL_TRANSACTION_CREDITS_RETURNED_ERR_ASSERT);
              end

              
              if($test$plusargs("MRdLk32"))begin
             $assertoff (0,hqm_tb_top.hqm_test_island.iosf_fabric_VC.genblk1.primary_compmon.iosf_prim_master_completion_compliance_checks.PRI_156_044_054_LowerAddressInCompletionMustBeFor1stByte.PRI_156_044_054_LowerAddressInCompletionMustBeFor1stByte_ASSERT);
           end

           if($test$plusargs("MISALIGN"))begin
             $assertoff (0,hqm_tb_top.hqm_test_island.iosf_fabric_VC.genblk1.primary_compmon.iosf_prim_target_request_compliance_checks.PRI_027_037_174_MemoryAndIOOperationDriveDWAlignedAddresses.PRI_027_037_174_MemoryAndIOOperationDriveDWAlignedAddresses_ASSERT);
           end

           if($test$plusargs("cpl_Illegal"))begin
             $assertoff (0,hqm_tb_top.hqm_test_island.iosf_fabric_VC.genblk1.primary_compmon.iosf_prim_target_completion_compliance_checks.PRI_169_CompletionStatusMustBeLegal.PRI_169_CompletionStatusMustBeLegal_ASSERT);
           end

           if($test$plusargs("BAD_REQTYPE"))begin
             $assertoff (0,hqm_tb_top.hqm_test_island.iosf_fabric_VC.genblk1.primary_compmon.iosf_prim_target_request_compliance_checks.PRI_025_ConfigTransactionMustDrive1DWLength.PRI_025_ConfigTransactionMustDrive1DWLength_ASSERT);
             $assertoff (0,hqm_tb_top.hqm_test_island.iosf_fabric_VC.genblk1.primary_compmon.iosf_prim_transaction_credit_checks.TargetCreditCountersPerChannel[0].TargetCreditCountersPerClass[1].PRI_020_DATACREDIT_COUNTER_EXCEEDS_INITIALIZED_VALUE.PRI_020_DATACREDIT_COUNTER_EXCEEDS_INITIALIZED_VALUE_ASSERT);
             $assertoff(0,hqm_tb_top.hqm_test_island.iosf_fabric_VC.genblk1.primary_compmon.iosf_prim_transaction_credit_checks.TargetCreditCountersPerChannel[0].TargetCreditCountersPerClass[1].PRI_NOT_ALL_TRANSACTION_CREDITS_RETURNED_ERR.PRI_NOT_ALL_TRANSACTION_CREDITS_RETURNED_ERR_ASSERT);


           end

            if($test$plusargs("LTMRd"))begin
             $assertoff (0, hqm_tb_top.hqm_test_island.iosf_fabric_VC.genblk1.primary_compmon.iosf_prim_master_completion_compliance_checks.PRI_156_044_054_LowerAddressInCompletionMustBeFor1stByte.PRI_156_044_054_LowerAddressInCompletionMustBeFor1stByte_ASSERT);
           end

           if($test$plusargs("NPMwr"))begin
             $assertoff (0, hqm_tb_top.hqm_test_island.iosf_fabric_VC.genblk1.primary_compmon.iosf_prim_transaction_credit_checks.TargetCreditCountersPerChannel[0].TargetCreditCountersPerClass[1].PRI_NOT_ALL_TRANSACTION_CREDITS_RETURNED_ERR.PRI_NOT_ALL_TRANSACTION_CREDITS_RETURNED_ERR_ASSERT);
              $assertoff (0, hqm_tb_top.hqm_test_island.iosf_fabric_VC.genblk1.primary_compmon.iosf_prim_target_request_compliance_checks.PRI_SomeNum_NPMWr_Support.PRI_SomeNum_NPMWr_Support_ASSERT);
           end

           if($test$plusargs("OVERFLOW_CRD_check"))begin
             $assertoff (0, hqm_tb_top.hqm_test_island.iosf_fabric_VC.genblk1.primary_compmon.iosf_prim_req_grnt_flow_compliance_checks.request_fifo_chan[0].request_fifo[2].PRI_085_AllRequestsMustBeGrantedByEndOfSimulation.PRI_085_AllRequestsMustBeGrantedByEndOfSimulation_ASSERT);
             $assertoff (0, hqm_tb_top.hqm_test_island.iosf_fabric_VC.genblk1.primary_compmon.iosf_prim_master_completion_compliance_checks.PRI_198_AllNonPostedsMustEventuallyBeCompleted.PRI_198_AllNonPostedsMustEventuallyBeCompleted_ASSERT);             
           end


           if($test$plusargs("HQM_COMMAND_PARITY_CHECK"))begin
             $assertoff (0, hqm_tb_top.hqm_test_island.iosf_fabric_VC.genblk1.primary_compmon.iosf_prim_transaction_credit_checks.TargetCreditCountersPerChannel[0].TargetCreditCountersPerClass[1].PRI_NOT_ALL_TRANSACTION_CREDITS_RETURNED_ERR.PRI_NOT_ALL_TRANSACTION_CREDITS_RETURNED_ERR_ASSERT);
             $assertoff (0, hqm_tb_top.hqm_test_island.iosf_fabric_VC.genblk1.primary_compmon.iosf_prim_transaction_credit_checks.TargetCreditCountersPerChannel[0].TargetCreditCountersPerClass[0].PRI_NOT_ALL_TRANSACTION_CREDITS_RETURNED_ERR.PRI_NOT_ALL_TRANSACTION_CREDITS_RETURNED_ERR_ASSERT);


           end

         end: FABRIC_ASSERTOFF_INITIAL


endmodule
