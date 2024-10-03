//=====================================================================================================================
//
// iommu_custom_rf.sv
//
// Contacts            : Camron Rust
// Original Author(s)  : Camron Rust
// Original Date       : 10/2014
//
// -- Intel Proprietary
// -- Copyright (C) 2016 Intel Corporation
// -- All Rights Reserved
//
//=====================================================================================================================

//------------------------------------------------------------------------------------------------------------------
// This file can be completely replaced by the customer using any array style desired.
//
// If it is replaced, it should contain the arrays designated to be RFs.
//
// For those arrays not designated as RF's, the IOMMU will continue to use latch arrays implemented elsewhere
// in the hierarchy. Such arrays can be left out of this file.
//
// The IOMMU will maintain the latch arrays in simulation and will verify that the values provided by the
// custom RF match the latch array values. In synthesis, the arrays that are designated to be RFs should have
// their associated latch array minimized away since there will be no path out of the array.
//------------------------------------------------------------------------------------------------------------------

genvar g_way;
genvar g_bank;
genvar g_port;

T_TAG_ENTRY_4K   [DEVTLB_TLB_NUM_WAYS-1:0][DEVTLB_XREQ_PORTNUM-1:0]    tmp_RF_IOTLB_4k_Tag_RdData; // lintra s-0531
T_DATA_ENTRY_4K  [DEVTLB_TLB_NUM_WAYS-1:0][DEVTLB_XREQ_PORTNUM-1:0]    tmp_RF_IOTLB_4k_Data_RdData; // lintra s-0531
T_TAG_ENTRY_2M   [DEVTLB_TLB_NUM_WAYS-1:0][DEVTLB_XREQ_PORTNUM-1:0]    tmp_RF_IOTLB_2m_Tag_RdData; // lintra s-0531
T_DATA_ENTRY_2M  [DEVTLB_TLB_NUM_WAYS-1:0][DEVTLB_XREQ_PORTNUM-1:0]    tmp_RF_IOTLB_2m_Data_RdData; // lintra s-0531
T_TAG_ENTRY_1G   [DEVTLB_TLB_NUM_WAYS-1:0][DEVTLB_XREQ_PORTNUM-1:0]    tmp_RF_IOTLB_1g_Tag_RdData; // lintra s-0531
T_DATA_ENTRY_1G  [DEVTLB_TLB_NUM_WAYS-1:0][DEVTLB_XREQ_PORTNUM-1:0]    tmp_RF_IOTLB_1g_Data_RdData; // lintra s-0531
T_TAG_ENTRY_5T   [DEVTLB_TLB_NUM_WAYS-1:0][DEVTLB_XREQ_PORTNUM-1:0]    tmp_RF_IOTLB_5t_Tag_RdData; // lintra s-0531
T_DATA_ENTRY_5T  [DEVTLB_TLB_NUM_WAYS-1:0][DEVTLB_XREQ_PORTNUM-1:0]    tmp_RF_IOTLB_5t_Data_RdData; // lintra s-0531

generate

   // IOTLB caches....4k, 2m, 1g, etc.
   //
   for(g_way=0; g_way<DEVTLB_TLB_NUM_WAYS; g_way++) begin: IOTLB

      if ((DEVTLB_TLB_NUM_PS_SETS[SIZE_4K] > 0) && (DEVTLB_TLB_ARRAY_STYLE[SIZE_4K] == ARRAY_RF)) begin: IOTLB_4K_RF
            // Array Placeholder....replace with RF
            hqm_devtlb_array_gen #(
               .NO_POWER_GATING(NO_POWER_GATING),
               .ALLOW_TLBRWCONFLICT(ALLOW_TLBRWCONFLICT),
               .NUM_RD_PORTS(DEVTLB_XREQ_PORTNUM),
               .NUM_PIPE_STAGE(DEVTLB_TLB_READ_LATENCY),
               .NUM_SETS(DEVTLB_TLB_NUM_PS_SETS[SIZE_4K]),
               .NUM_WAYS(1),
               .RD_PRE_DECODE(1),
               .T_ENTRY(T_TAG_ENTRY_4K)
            ) devtlb_tlb_4k_tag (
               `HQM_DEVTLB_COMMON_PORTCON
               `HQM_DEVTLB_FSCAN_PORTCON
               .PwrDnOvrd_nnnH         ('0),

               // Read Interface
               //
               .RdEnSpec_nnnH          (RF_IOTLB_4k_Tag_RdEn),
               .RdEn_nnnH              (RF_IOTLB_4k_Tag_RdEn),
               .RdSetAddr_nnnH         (RF_IOTLB_4k_Tag_RdAddr),
               .RdData_nn1H            (tmp_RF_IOTLB_4k_Tag_RdData[g_way]),
                                        
               // Write Interface       
               //                       
               .WrEn_nnnH              (RF_IOTLB_4k_Tag_WrEn[0][g_way]),
               .WrSetAddr_nnnH         (RF_IOTLB_4k_Tag_WrAddr[0]),
               .WrWayVec_nnnH          (RF_IOTLB_4k_Tag_WrEn[0][g_way]),
               .WrData_nnnH            (RF_IOTLB_4k_Tag_WrData[0])
            );
         
            // Array Placeholder....replace with RF
            hqm_devtlb_array_gen #(
               .NO_POWER_GATING(NO_POWER_GATING),
               .ALLOW_TLBRWCONFLICT(ALLOW_TLBRWCONFLICT),
               .NUM_RD_PORTS(DEVTLB_XREQ_PORTNUM),
               .NUM_PIPE_STAGE(DEVTLB_TLB_READ_LATENCY),
               .NUM_SETS(DEVTLB_TLB_NUM_PS_SETS[SIZE_4K]),
               .NUM_WAYS(1),
               .MASK_BITS(SIZE_4K*9),
               .RD_PRE_DECODE(1),
               .T_ENTRY(T_DATA_ENTRY_4K)
            ) devtlb_tlb_4k_data (
               `HQM_DEVTLB_COMMON_PORTCON
               `HQM_DEVTLB_FSCAN_PORTCON
               .PwrDnOvrd_nnnH         ('0),

               // Read Interface
               //
               .RdEnSpec_nnnH          (RF_IOTLB_4k_Data_RdEn),
               .RdEn_nnnH              (RF_IOTLB_4k_Data_RdEn),
               .RdSetAddr_nnnH         (RF_IOTLB_4k_Data_RdAddr),
               .RdData_nn1H            (tmp_RF_IOTLB_4k_Data_RdData[g_way]),
                                        
               // Write Interface       
               //                       
               .WrEn_nnnH              (RF_IOTLB_4k_Data_WrEn[0][g_way]),
               .WrSetAddr_nnnH         (RF_IOTLB_4k_Data_WrAddr[0]),
               .WrWayVec_nnnH          (RF_IOTLB_4k_Data_WrEn[0][g_way]),
               .WrData_nnnH            (RF_IOTLB_4k_Data_WrData[0])
            );
         for(g_port=0; g_port<DEVTLB_XREQ_PORTNUM; g_port++) begin: PORT_4K
            assign RF_IOTLB_4k_Tag_RdData[g_port][g_way]    = tmp_RF_IOTLB_4k_Tag_RdData[g_way][g_port];
            assign RF_IOTLB_4k_Data_RdData[g_port][g_way]   = tmp_RF_IOTLB_4k_Data_RdData[g_way][g_port];
         end
      end
      else begin: NO_IOTLB_4K_RF
         for(g_port=0; g_port<DEVTLB_XREQ_PORTNUM; g_port++) begin: PORT_4K_DEF
            assign RF_IOTLB_4k_Tag_RdData[g_port][g_way]   = '0;
            assign RF_IOTLB_4k_Data_RdData[g_port][g_way]  = '0;
         end
      end

      if ((DEVTLB_TLB_NUM_PS_SETS[SIZE_2M] > 0) && (DEVTLB_TLB_ARRAY_STYLE[SIZE_2M] == ARRAY_RF)) begin: IOTLB_2M_RF
            // Array Placeholder....replace with RF
            hqm_devtlb_array_gen #(
               .NO_POWER_GATING(NO_POWER_GATING),
               .ALLOW_TLBRWCONFLICT(ALLOW_TLBRWCONFLICT),
               .NUM_RD_PORTS(DEVTLB_XREQ_PORTNUM),
               .NUM_PIPE_STAGE(DEVTLB_TLB_READ_LATENCY),
               .NUM_SETS(DEVTLB_TLB_NUM_PS_SETS[SIZE_2M]),
               .NUM_WAYS(1),
               .RD_PRE_DECODE(1),
               .T_ENTRY(T_TAG_ENTRY_2M)
            ) devtlb_tlb_2m_tag (
               `HQM_DEVTLB_COMMON_PORTCON
               `HQM_DEVTLB_FSCAN_PORTCON
               .PwrDnOvrd_nnnH         ('0),

               // Read Interface
               //
               .RdEnSpec_nnnH          (RF_IOTLB_2m_Tag_RdEn),
               .RdEn_nnnH              (RF_IOTLB_2m_Tag_RdEn),
               .RdSetAddr_nnnH         (RF_IOTLB_2m_Tag_RdAddr),
               .RdData_nn1H            (tmp_RF_IOTLB_2m_Tag_RdData[g_way]),
                                        
               // Write Interface       
               //                       
               .WrEn_nnnH              (RF_IOTLB_2m_Tag_WrEn[0][g_way]),
               .WrSetAddr_nnnH         (RF_IOTLB_2m_Tag_WrAddr[0]),
               .WrWayVec_nnnH          (RF_IOTLB_2m_Tag_WrEn[0][g_way]),
               .WrData_nnnH            (RF_IOTLB_2m_Tag_WrData[0])
            );


            // Array Placeholder....replace with RF
            hqm_devtlb_array_gen #(
               .NO_POWER_GATING(NO_POWER_GATING),
               .ALLOW_TLBRWCONFLICT(ALLOW_TLBRWCONFLICT),
               .NUM_RD_PORTS(DEVTLB_XREQ_PORTNUM),
               .NUM_PIPE_STAGE(DEVTLB_TLB_READ_LATENCY),
               .NUM_SETS(DEVTLB_TLB_NUM_PS_SETS[SIZE_2M]),
               .NUM_WAYS(1),
               .RD_PRE_DECODE(1),
               .T_ENTRY(T_DATA_ENTRY_2M)
            ) devtlb_tlb_2m_data (
               `HQM_DEVTLB_COMMON_PORTCON
               `HQM_DEVTLB_FSCAN_PORTCON
               .PwrDnOvrd_nnnH         ('0),

               // Read Interface
               //
               .RdEnSpec_nnnH          (RF_IOTLB_2m_Data_RdEn),
               .RdEn_nnnH              (RF_IOTLB_2m_Data_RdEn),
               .RdSetAddr_nnnH         (RF_IOTLB_2m_Data_RdAddr),
               .RdData_nn1H            (tmp_RF_IOTLB_2m_Data_RdData[g_way]),
                                        
               // Write Interface       
               //                       
               .WrEn_nnnH              (RF_IOTLB_2m_Data_WrEn[0][g_way]),
               .WrSetAddr_nnnH         (RF_IOTLB_2m_Data_WrAddr[0]),
               .WrWayVec_nnnH          (RF_IOTLB_2m_Data_WrEn[0][g_way]),
               .WrData_nnnH            (RF_IOTLB_2m_Data_WrData[0])
            );
         for(g_port=0; g_port<DEVTLB_XREQ_PORTNUM; g_port++) begin: PORT_2M
            assign RF_IOTLB_2m_Tag_RdData[g_port][g_way]    = tmp_RF_IOTLB_2m_Tag_RdData[g_way][g_port];
            assign RF_IOTLB_2m_Data_RdData[g_port][g_way]   = tmp_RF_IOTLB_2m_Data_RdData[g_way][g_port];
         end
      end
      else begin: NO_IOTLB_2M_RF
         for(g_port=0; g_port<DEVTLB_XREQ_PORTNUM; g_port++) begin: PORT_2M_DEF
            assign RF_IOTLB_2m_Tag_RdData[g_port][g_way]   = '0;
            assign RF_IOTLB_2m_Data_RdData[g_port][g_way]  = '0;
         end
      end


      if ((DEVTLB_TLB_NUM_PS_SETS[SIZE_1G] > 0) && (DEVTLB_TLB_ARRAY_STYLE[SIZE_1G] == ARRAY_RF)) begin: IOTLB_1G_RF
            // Array Placeholder....replace with RF
            hqm_devtlb_array_gen #(
               .NO_POWER_GATING(NO_POWER_GATING),
               .ALLOW_TLBRWCONFLICT(ALLOW_TLBRWCONFLICT),
               .NUM_RD_PORTS(DEVTLB_XREQ_PORTNUM),
               .NUM_PIPE_STAGE(DEVTLB_TLB_READ_LATENCY),
               .NUM_SETS(DEVTLB_TLB_NUM_PS_SETS[SIZE_1G]),
               .NUM_WAYS(1),
               .RD_PRE_DECODE(1),
               .T_ENTRY(T_TAG_ENTRY_1G)
            ) devtlb_tlb_1g_tag (
               `HQM_DEVTLB_COMMON_PORTCON
               `HQM_DEVTLB_FSCAN_PORTCON
               .PwrDnOvrd_nnnH         ('0),

               // Read Interface
               //
               .RdEnSpec_nnnH          (RF_IOTLB_1g_Tag_RdEn),
               .RdEn_nnnH              (RF_IOTLB_1g_Tag_RdEn),
               .RdSetAddr_nnnH         (RF_IOTLB_1g_Tag_RdAddr),
               .RdData_nn1H            (tmp_RF_IOTLB_1g_Tag_RdData[g_way]),
                                        
               // Write Interface       
               //                       
               .WrEn_nnnH              (RF_IOTLB_1g_Tag_WrEn[0][g_way]),
               .WrSetAddr_nnnH         (RF_IOTLB_1g_Tag_WrAddr[0]),
               .WrWayVec_nnnH          (RF_IOTLB_1g_Tag_WrEn[0][g_way]),
               .WrData_nnnH            (RF_IOTLB_1g_Tag_WrData[0])
            );


            // Array Placeholder....replace with RF
            hqm_devtlb_array_gen #(
               .NO_POWER_GATING(NO_POWER_GATING),
               .ALLOW_TLBRWCONFLICT(ALLOW_TLBRWCONFLICT),
               .NUM_RD_PORTS(DEVTLB_XREQ_PORTNUM),
               .NUM_PIPE_STAGE(DEVTLB_TLB_READ_LATENCY),
               .NUM_SETS(DEVTLB_TLB_NUM_PS_SETS[SIZE_1G]),
               .NUM_WAYS(1),
               .RD_PRE_DECODE(1),
               .T_ENTRY(T_DATA_ENTRY_1G)
            ) devtlb_tlb_1g_data (
               `HQM_DEVTLB_COMMON_PORTCON
               `HQM_DEVTLB_FSCAN_PORTCON
               .PwrDnOvrd_nnnH         ('0),

               // Read Interface
               //
               .RdEnSpec_nnnH          (RF_IOTLB_1g_Data_RdEn),
               .RdEn_nnnH              (RF_IOTLB_1g_Data_RdEn),
               .RdSetAddr_nnnH         (RF_IOTLB_1g_Data_RdAddr),
               .RdData_nn1H            (tmp_RF_IOTLB_1g_Data_RdData[g_way]),
                                        
               // Write Interface       
               //                       
               .WrEn_nnnH              (RF_IOTLB_1g_Data_WrEn[0][g_way]),
               .WrSetAddr_nnnH         (RF_IOTLB_1g_Data_WrAddr[0]),
               .WrWayVec_nnnH          (RF_IOTLB_1g_Data_WrEn[0][g_way]),
               .WrData_nnnH            (RF_IOTLB_1g_Data_WrData[0])
            );
         for(g_port=0; g_port<DEVTLB_XREQ_PORTNUM; g_port++) begin: PORT_1G
            assign RF_IOTLB_1g_Tag_RdData[g_port][g_way]    = tmp_RF_IOTLB_1g_Tag_RdData[g_way][g_port];
            assign RF_IOTLB_1g_Data_RdData[g_port][g_way]   = tmp_RF_IOTLB_1g_Data_RdData[g_way][g_port];
         end
      end
      else begin: NO_IOTLB_1G_RF
         for(g_port=0; g_port<DEVTLB_XREQ_PORTNUM; g_port++) begin: PORT_1G_DEF
            assign RF_IOTLB_1g_Tag_RdData[g_port][g_way]   = '0;
            assign RF_IOTLB_1g_Data_RdData[g_port][g_way]  = '0;
         end
      end

      if ((DEVTLB_TLB_NUM_PS_SETS[SIZE_5T] > 0) && (DEVTLB_TLB_ARRAY_STYLE[SIZE_5T] == ARRAY_RF)) begin: IOTLB_5T_RF
            // Array Placeholder....replace with RF
            hqm_devtlb_array_gen #(
               .NO_POWER_GATING(NO_POWER_GATING),
               .ALLOW_TLBRWCONFLICT(ALLOW_TLBRWCONFLICT),
               .NUM_RD_PORTS(DEVTLB_XREQ_PORTNUM),
               .NUM_PIPE_STAGE(DEVTLB_TLB_READ_LATENCY),
               .NUM_SETS(DEVTLB_TLB_NUM_PS_SETS[SIZE_5T]),
               .NUM_WAYS(1),
               .RD_PRE_DECODE(1),
               .T_ENTRY(T_TAG_ENTRY_5T)
            ) devtlb_tlb_5t_tag (
               `HQM_DEVTLB_COMMON_PORTCON
               `HQM_DEVTLB_FSCAN_PORTCON
               .PwrDnOvrd_nnnH         ('0),

               // Read Interface
               //
               .RdEnSpec_nnnH          (RF_IOTLB_5t_Tag_RdEn),
               .RdEn_nnnH              (RF_IOTLB_5t_Tag_RdEn),
               .RdSetAddr_nnnH         (RF_IOTLB_5t_Tag_RdAddr),
               .RdData_nn1H            (tmp_RF_IOTLB_5t_Tag_RdData[g_way]),
                                        
               // Write Interface       
               //                       
               .WrEn_nnnH              (RF_IOTLB_5t_Tag_WrEn[0][g_way]),
               .WrSetAddr_nnnH         (RF_IOTLB_5t_Tag_WrAddr[0]),
               .WrWayVec_nnnH          (RF_IOTLB_5t_Tag_WrEn[0][g_way]),
               .WrData_nnnH            (RF_IOTLB_5t_Tag_WrData[0])
            );


            // Array Placeholder....replace with RF
            hqm_devtlb_array_gen #(
               .NO_POWER_GATING(NO_POWER_GATING),
               .ALLOW_TLBRWCONFLICT(ALLOW_TLBRWCONFLICT),
               .NUM_RD_PORTS(DEVTLB_XREQ_PORTNUM),
               .NUM_PIPE_STAGE(DEVTLB_TLB_READ_LATENCY),
               .NUM_SETS(DEVTLB_TLB_NUM_PS_SETS[SIZE_5T]),
               .NUM_WAYS(1),
               .RD_PRE_DECODE(1),
               .T_ENTRY(T_DATA_ENTRY_5T)
            ) devtlb_tlb_5t_data (
               `HQM_DEVTLB_COMMON_PORTCON
               `HQM_DEVTLB_FSCAN_PORTCON
               .PwrDnOvrd_nnnH         ('0),

               // Read Interface
               //
               .RdEnSpec_nnnH          (RF_IOTLB_5t_Data_RdEn),
               .RdEn_nnnH              (RF_IOTLB_5t_Data_RdEn),
               .RdSetAddr_nnnH         (RF_IOTLB_5t_Data_RdAddr),
               .RdData_nn1H            (tmp_RF_IOTLB_5t_Data_RdData[g_way]),
                                        
               // Write Interface       
               //                       
               .WrEn_nnnH              (RF_IOTLB_5t_Data_WrEn[0][g_way]),
               .WrSetAddr_nnnH         (RF_IOTLB_5t_Data_WrAddr[0]),
               .WrWayVec_nnnH          (RF_IOTLB_5t_Data_WrEn[0][g_way]),
               .WrData_nnnH            (RF_IOTLB_5t_Data_WrData[0])
            );
         for(g_port=0; g_port<DEVTLB_XREQ_PORTNUM; g_port++) begin: PORT_5T
            assign RF_IOTLB_5t_Tag_RdData[g_port][g_way]    = tmp_RF_IOTLB_5t_Tag_RdData[g_way][g_port];
            assign RF_IOTLB_5t_Data_RdData[g_port][g_way]   = tmp_RF_IOTLB_5t_Data_RdData[g_way][g_port];
         end
      end
      else begin: NO_IOTLB_5T_RF
         for(g_port=0; g_port<DEVTLB_XREQ_PORTNUM; g_port++) begin: PORT_5T_DEF
            assign RF_IOTLB_5t_Tag_RdData[g_port][g_way]   = '0;
            assign RF_IOTLB_5t_Data_RdData[g_port][g_way]  = '0;
         end
      end

   end



endgenerate

//------------------------------------------------------------------------------------------------------------------
// Default assignments to X to expose any issues for signals not otherwise driven
//------------------------------------------------------------------------------------------------------------------


