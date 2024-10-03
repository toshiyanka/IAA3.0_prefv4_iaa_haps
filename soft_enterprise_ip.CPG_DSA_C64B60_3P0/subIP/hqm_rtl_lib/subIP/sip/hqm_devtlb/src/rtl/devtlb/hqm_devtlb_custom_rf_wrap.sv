//=====================================================================================================================
//
// iommu_custom_rf_wrap.sv
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

`ifndef HQM_DEVTLB_CUSTOM_RF_WRAP_VS
`define HQM_DEVTLB_CUSTOM_RF_WRAP_VS

`include "hqm_devtlb_pkg.vh"

`include "hqm_devtlb_array_gen.sv"

module hqm_devtlb_custom_rf_wrap (
//lintra -68099
   `HQM_DEVTLB_COMMON_PORTLIST
   `HQM_DEVTLB_FSCAN_PORTLIST
   `HQM_DEVTLB_CUSTOM_RF_PORTLIST

   RF_IOTLB_4k_Tag_RdEn,
   RF_IOTLB_4k_Tag_RdAddr,
   RF_IOTLB_4k_Tag_RdData,
   RF_IOTLB_4k_Tag_WrEn,
   RF_IOTLB_4k_Tag_WrAddr,
   RF_IOTLB_4k_Tag_WrData,

   RF_IOTLB_4k_Data_RdEn,
   RF_IOTLB_4k_Data_RdAddr,
   RF_IOTLB_4k_Data_RdData,
   RF_IOTLB_4k_Data_WrEn,
   RF_IOTLB_4k_Data_WrAddr,
   RF_IOTLB_4k_Data_WrData,

   RF_IOTLB_2m_Tag_RdEn,
   RF_IOTLB_2m_Tag_RdAddr,
   RF_IOTLB_2m_Tag_RdData,
   RF_IOTLB_2m_Tag_WrEn,
   RF_IOTLB_2m_Tag_WrAddr,
   RF_IOTLB_2m_Tag_WrData,

   RF_IOTLB_2m_Data_RdEn,
   RF_IOTLB_2m_Data_RdAddr,
   RF_IOTLB_2m_Data_RdData,
   RF_IOTLB_2m_Data_WrEn,
   RF_IOTLB_2m_Data_WrAddr,
   RF_IOTLB_2m_Data_WrData,

   RF_IOTLB_1g_Tag_RdEn,
   RF_IOTLB_1g_Tag_RdAddr,
   RF_IOTLB_1g_Tag_RdData,
   RF_IOTLB_1g_Tag_WrEn,
   RF_IOTLB_1g_Tag_WrAddr,
   RF_IOTLB_1g_Tag_WrData,

   RF_IOTLB_1g_Data_RdEn,
   RF_IOTLB_1g_Data_RdAddr,
   RF_IOTLB_1g_Data_RdData,
   RF_IOTLB_1g_Data_WrEn,
   RF_IOTLB_1g_Data_WrAddr,
   RF_IOTLB_1g_Data_WrData,

   RF_IOTLB_5t_Tag_RdEn,
   RF_IOTLB_5t_Tag_RdAddr,
   RF_IOTLB_5t_Tag_RdData,
   RF_IOTLB_5t_Tag_WrEn,
   RF_IOTLB_5t_Tag_WrAddr,
   RF_IOTLB_5t_Tag_WrData,

   RF_IOTLB_5t_Data_RdEn,
   RF_IOTLB_5t_Data_RdAddr,
   RF_IOTLB_5t_Data_RdData,
   RF_IOTLB_5t_Data_WrEn,
   RF_IOTLB_5t_Data_WrAddr,
   RF_IOTLB_5t_Data_WrData,

   RF_IOTLB_Qp_Tag_RdEn,
   RF_IOTLB_Qp_Tag_RdAddr,
   RF_IOTLB_Qp_Tag_RdData,
   RF_IOTLB_Qp_Tag_WrEn,
   RF_IOTLB_Qp_Tag_WrAddr,
   RF_IOTLB_Qp_Tag_WrData,

   RF_IOTLB_Qp_Data_RdEn,
   RF_IOTLB_Qp_Data_RdAddr,
   RF_IOTLB_Qp_Data_RdData,
   RF_IOTLB_Qp_Data_WrEn,
   RF_IOTLB_Qp_Data_WrAddr,
   RF_IOTLB_Qp_Data_WrData
//lintra +68099
);

import `HQM_DEVTLB_PACKAGE_NAME::*; // defines typedefs, functions, macros for the IOMMU
`include "hqm_devtlb_pkgparams.vh"
parameter logic ALLOW_TLBRWCONFLICT  = 0;  //1 if TLB array allow RW conflict
parameter type T_TAG_ENTRY_4K = logic; //t_devtlb_iotlb_4k_tag_entry;
parameter type T_DATA_ENTRY_4K = logic; //t_devtlb_iotlb_4k_data_entry;
parameter type T_TAG_ENTRY_2M = logic; //t_devtlb_iotlb_2m_tag_entry;
parameter type T_DATA_ENTRY_2M = logic; //t_devtlb_iotlb_2m_data_entry;
parameter type T_TAG_ENTRY_1G = logic; //t_devtlb_iotlb_1g_tag_entry;
parameter type T_DATA_ENTRY_1G = logic; //t_devtlb_iotlb_1g_data_entry;
parameter type T_TAG_ENTRY_5T = logic; //t_devtlb_iotlb_5t_tag_entry;
parameter type T_DATA_ENTRY_5T = logic; //t_devtlb_iotlb_5t_data_entry;
parameter type T_TAG_ENTRY_QP = logic; //t_devtlb_iotlb_Qp_tag_entry;
parameter type T_DATA_ENTRY_QP = logic; //t_devtlb_iotlb_Qp_data_entry;

parameter type T_IO_TAG_ENTRY_4K = logic; //t_devtlb_io_4k_tag_entry;
parameter type T_IO_TAG_ENTRY_2M = logic; //t_devtlb_io_2m_tag_entry;
parameter type T_IO_TAG_ENTRY_1G = logic; //t_devtlb_io_1g_tag_entry;
parameter type T_IO_TAG_ENTRY_5T = logic; //t_devtlb_io_5t_tag_entry;
parameter type T_IO_TAG_ENTRY_QP = logic; //t_devtlb_io_Qp_tag_entry;
parameter type T_IO_DATA_ENTRY_4K = logic; //t_devtlb_io_4k_data_entry;
parameter type T_IO_DATA_ENTRY_2M = logic; //t_devtlb_io_2m_data_entry;
parameter type T_IO_DATA_ENTRY_1G = logic; //t_devtlb_io_1g_data_entry;
parameter type T_IO_DATA_ENTRY_5T = logic; //t_devtlb_io_5t_data_entry;
parameter type T_IO_DATA_ENTRY_QP = logic; //t_devtlb_io_Qp_data_entry;

parameter int DEVTLB_TAG_ENTRY_4K_RF_WIDTH = 2+3+DEVTLB_PASID_WIDTH+DEVTLB_BDF_WIDTH+DEVTLB_PARITY_WIDTH+DEVTLB_MAX_LINEAR_ADDRESS_WIDTH-12; 
parameter int DEVTLB_DATA_ENTRY_4K_RF_WIDTH = 4+5+DEVTLB_PARITY_WIDTH+DEVTLB_MAX_HOST_ADDRESS_WIDTH-12;
parameter int DEVTLB_TAG_ENTRY_2M_RF_WIDTH = 2+3+DEVTLB_PASID_WIDTH+DEVTLB_BDF_WIDTH+DEVTLB_PARITY_WIDTH+DEVTLB_MAX_LINEAR_ADDRESS_WIDTH-21; 
parameter int DEVTLB_DATA_ENTRY_2M_RF_WIDTH = 4+5+DEVTLB_PARITY_WIDTH+DEVTLB_MAX_HOST_ADDRESS_WIDTH-21;
parameter int DEVTLB_TAG_ENTRY_1G_RF_WIDTH = 2+3+DEVTLB_PASID_WIDTH+DEVTLB_BDF_WIDTH+DEVTLB_PARITY_WIDTH+DEVTLB_MAX_LINEAR_ADDRESS_WIDTH-30; 
parameter int DEVTLB_DATA_ENTRY_1G_RF_WIDTH = 4+5+DEVTLB_PARITY_WIDTH+DEVTLB_MAX_HOST_ADDRESS_WIDTH-30;

//======================================================================================================================
//                                           Interface signal declarations
//======================================================================================================================

   `HQM_DEVTLB_COMMON_PORTDEC
   `HQM_DEVTLB_FSCAN_PORTDEC
   `HQM_DEVTLB_CUSTOM_RF_PORTDEC

   // Each IOTLB Array is organized in multiple ways. As such, some inputs are shared.
   // All ways of the same level IOTLB (4k, 2m, or 1g) share the same read enable, read address, write address, and write data.
   // Each way of the same level IOTLB (4k, 2m, or 1g) will have its own write enable and read data.
   // The write data for each level's tag  is largely the same except each succesive higher order array drops 9 bits from the lower end.
   // The write data for each level's data is largely the same except each succesive higher order array drops 9 bits from the lower end.
   //
   // IOTLB 4k
   input    logic [DEVTLB_XREQ_PORTNUM-1:0]                                                 RF_IOTLB_4k_Tag_RdEn;
   input    logic [DEVTLB_XREQ_PORTNUM-1:0] [`HQM_DEVTLB_LOG2(DEVTLB_TLB_NUM_PS_SETS[0])-1:0]   RF_IOTLB_4k_Tag_RdAddr;
   output   T_TAG_ENTRY_4K  [DEVTLB_XREQ_PORTNUM-1:0][DEVTLB_TLB_NUM_WAYS-1:0]              RF_IOTLB_4k_Tag_RdData;
   input    logic [DEVTLB_XREQ_PORTNUM-1:0] [DEVTLB_TLB_NUM_WAYS-1:0]                       RF_IOTLB_4k_Tag_WrEn;
   input    logic [DEVTLB_XREQ_PORTNUM-1:0] [`HQM_DEVTLB_LOG2(DEVTLB_TLB_NUM_PS_SETS[0])-1:0]   RF_IOTLB_4k_Tag_WrAddr;
   input    T_TAG_ENTRY_4K  [DEVTLB_XREQ_PORTNUM-1:0]                                       RF_IOTLB_4k_Tag_WrData;
                                        
   input    logic [DEVTLB_XREQ_PORTNUM-1:0]                                                 RF_IOTLB_4k_Data_RdEn;
   input    logic [DEVTLB_XREQ_PORTNUM-1:0] [`HQM_DEVTLB_LOG2(DEVTLB_TLB_NUM_PS_SETS[0])-1:0]   RF_IOTLB_4k_Data_RdAddr;
   output   T_DATA_ENTRY_4K [DEVTLB_XREQ_PORTNUM-1:0][DEVTLB_TLB_NUM_WAYS-1:0]              RF_IOTLB_4k_Data_RdData;
   input    logic [DEVTLB_XREQ_PORTNUM-1:0] [DEVTLB_TLB_NUM_WAYS-1:0]                       RF_IOTLB_4k_Data_WrEn;
   input    logic [DEVTLB_XREQ_PORTNUM-1:0] [`HQM_DEVTLB_LOG2(DEVTLB_TLB_NUM_PS_SETS[0])-1:0]   RF_IOTLB_4k_Data_WrAddr;
   input    T_DATA_ENTRY_4K [DEVTLB_XREQ_PORTNUM-1:0]                                       RF_IOTLB_4k_Data_WrData;
                                         
   // IOTLB 2m
   input    logic [DEVTLB_XREQ_PORTNUM-1:0]                                                 RF_IOTLB_2m_Tag_RdEn;
   input    logic [DEVTLB_XREQ_PORTNUM-1:0] [`HQM_DEVTLB_LOG2(DEVTLB_TLB_NUM_PS_SETS[1])-1:0]   RF_IOTLB_2m_Tag_RdAddr;
   output   T_TAG_ENTRY_2M  [DEVTLB_XREQ_PORTNUM-1:0][DEVTLB_TLB_NUM_WAYS-1:0]              RF_IOTLB_2m_Tag_RdData;
   input    logic [DEVTLB_XREQ_PORTNUM-1:0] [DEVTLB_TLB_NUM_WAYS-1:0]                       RF_IOTLB_2m_Tag_WrEn;
   input    logic [DEVTLB_XREQ_PORTNUM-1:0] [`HQM_DEVTLB_LOG2(DEVTLB_TLB_NUM_PS_SETS[1])-1:0]   RF_IOTLB_2m_Tag_WrAddr;
   input    T_TAG_ENTRY_2M  [DEVTLB_XREQ_PORTNUM-1:0]                                       RF_IOTLB_2m_Tag_WrData; 
                                         
   input    logic [DEVTLB_XREQ_PORTNUM-1:0]                                                 RF_IOTLB_2m_Data_RdEn;
   input    logic [DEVTLB_XREQ_PORTNUM-1:0] [`HQM_DEVTLB_LOG2(DEVTLB_TLB_NUM_PS_SETS[1])-1:0]   RF_IOTLB_2m_Data_RdAddr;
   output   T_DATA_ENTRY_2M [DEVTLB_XREQ_PORTNUM-1:0][DEVTLB_TLB_NUM_WAYS-1:0]              RF_IOTLB_2m_Data_RdData;
   input    logic [DEVTLB_XREQ_PORTNUM-1:0] [DEVTLB_TLB_NUM_WAYS-1:0]                       RF_IOTLB_2m_Data_WrEn; 
   input    logic [DEVTLB_XREQ_PORTNUM-1:0] [`HQM_DEVTLB_LOG2(DEVTLB_TLB_NUM_PS_SETS[1])-1:0]   RF_IOTLB_2m_Data_WrAddr;
   input    T_DATA_ENTRY_2M [DEVTLB_XREQ_PORTNUM-1:0]                                       RF_IOTLB_2m_Data_WrData;
                                         
   // IOTLB 1g
   input    logic [DEVTLB_XREQ_PORTNUM-1:0]                                                 RF_IOTLB_1g_Tag_RdEn;
   input    logic [DEVTLB_XREQ_PORTNUM-1:0] [`HQM_DEVTLB_LOG2(DEVTLB_TLB_NUM_PS_SETS[2])-1:0]   RF_IOTLB_1g_Tag_RdAddr;
   output   T_TAG_ENTRY_1G  [DEVTLB_XREQ_PORTNUM-1:0][DEVTLB_TLB_NUM_WAYS-1:0]              RF_IOTLB_1g_Tag_RdData;
   input    logic [DEVTLB_XREQ_PORTNUM-1:0] [DEVTLB_TLB_NUM_WAYS-1:0]                       RF_IOTLB_1g_Tag_WrEn;
   input    logic [DEVTLB_XREQ_PORTNUM-1:0] [`HQM_DEVTLB_LOG2(DEVTLB_TLB_NUM_PS_SETS[2])-1:0]   RF_IOTLB_1g_Tag_WrAddr;
   input    T_TAG_ENTRY_1G  [DEVTLB_XREQ_PORTNUM-1:0]                                       RF_IOTLB_1g_Tag_WrData; 
                                         
   input    logic [DEVTLB_XREQ_PORTNUM-1:0]                                                 RF_IOTLB_1g_Data_RdEn;
   input    logic [DEVTLB_XREQ_PORTNUM-1:0] [`HQM_DEVTLB_LOG2(DEVTLB_TLB_NUM_PS_SETS[2])-1:0]   RF_IOTLB_1g_Data_RdAddr;
   output   T_DATA_ENTRY_1G [DEVTLB_XREQ_PORTNUM-1:0][DEVTLB_TLB_NUM_WAYS-1:0]              RF_IOTLB_1g_Data_RdData;
   input    logic [DEVTLB_XREQ_PORTNUM-1:0] [DEVTLB_TLB_NUM_WAYS-1:0]                       RF_IOTLB_1g_Data_WrEn; 
   input    logic [DEVTLB_XREQ_PORTNUM-1:0] [`HQM_DEVTLB_LOG2(DEVTLB_TLB_NUM_PS_SETS[2])-1:0]   RF_IOTLB_1g_Data_WrAddr;
   input    T_DATA_ENTRY_1G [DEVTLB_XREQ_PORTNUM-1:0]                                       RF_IOTLB_1g_Data_WrData;
                                         
   // IOTLB 5t
   input    logic [DEVTLB_XREQ_PORTNUM-1:0]                                                 RF_IOTLB_5t_Tag_RdEn;
   input    logic [DEVTLB_XREQ_PORTNUM-1:0] [`HQM_DEVTLB_LOG2(DEVTLB_TLB_NUM_PS_SETS[3])-1:0]   RF_IOTLB_5t_Tag_RdAddr;
   output   T_TAG_ENTRY_5T  [DEVTLB_XREQ_PORTNUM-1:0][DEVTLB_TLB_NUM_WAYS-1:0]              RF_IOTLB_5t_Tag_RdData;
   input    logic [DEVTLB_XREQ_PORTNUM-1:0] [DEVTLB_TLB_NUM_WAYS-1:0]                       RF_IOTLB_5t_Tag_WrEn;
   input    logic [DEVTLB_XREQ_PORTNUM-1:0] [`HQM_DEVTLB_LOG2(DEVTLB_TLB_NUM_PS_SETS[3])-1:0]   RF_IOTLB_5t_Tag_WrAddr;
   input    T_TAG_ENTRY_5T  [DEVTLB_XREQ_PORTNUM-1:0]                                       RF_IOTLB_5t_Tag_WrData; 
                                         
   input    logic [DEVTLB_XREQ_PORTNUM-1:0]                                                 RF_IOTLB_5t_Data_RdEn;
   input    logic [DEVTLB_XREQ_PORTNUM-1:0] [`HQM_DEVTLB_LOG2(DEVTLB_TLB_NUM_PS_SETS[3])-1:0]   RF_IOTLB_5t_Data_RdAddr;
   output   T_DATA_ENTRY_5T [DEVTLB_XREQ_PORTNUM-1:0][DEVTLB_TLB_NUM_WAYS-1:0]              RF_IOTLB_5t_Data_RdData;
   input    logic [DEVTLB_XREQ_PORTNUM-1:0] [DEVTLB_TLB_NUM_WAYS-1:0]                       RF_IOTLB_5t_Data_WrEn; 
   input    logic [DEVTLB_XREQ_PORTNUM-1:0] [`HQM_DEVTLB_LOG2(DEVTLB_TLB_NUM_PS_SETS[3])-1:0]   RF_IOTLB_5t_Data_WrAddr;
   input    T_DATA_ENTRY_5T [DEVTLB_XREQ_PORTNUM-1:0]                                       RF_IOTLB_5t_Data_WrData;
                                         
   // IOTLB Qp
   input    logic [DEVTLB_XREQ_PORTNUM-1:0]                                                 RF_IOTLB_Qp_Tag_RdEn;
   input    logic [DEVTLB_XREQ_PORTNUM-1:0] [`HQM_DEVTLB_LOG2(DEVTLB_TLB_NUM_PS_SETS[4])-1:0]   RF_IOTLB_Qp_Tag_RdAddr;
   output   T_TAG_ENTRY_QP  [DEVTLB_XREQ_PORTNUM-1:0][DEVTLB_TLB_NUM_WAYS-1:0]              RF_IOTLB_Qp_Tag_RdData;
   input    logic [DEVTLB_XREQ_PORTNUM-1:0] [DEVTLB_TLB_NUM_WAYS-1:0]                       RF_IOTLB_Qp_Tag_WrEn;
   input    logic [DEVTLB_XREQ_PORTNUM-1:0] [`HQM_DEVTLB_LOG2(DEVTLB_TLB_NUM_PS_SETS[4])-1:0]   RF_IOTLB_Qp_Tag_WrAddr;
   input    T_TAG_ENTRY_QP  [DEVTLB_XREQ_PORTNUM-1:0]                                       RF_IOTLB_Qp_Tag_WrData; 
                                         
   input    logic [DEVTLB_XREQ_PORTNUM-1:0]                                                 RF_IOTLB_Qp_Data_RdEn;
   input    logic [DEVTLB_XREQ_PORTNUM-1:0] [`HQM_DEVTLB_LOG2(DEVTLB_TLB_NUM_PS_SETS[4])-1:0]   RF_IOTLB_Qp_Data_RdAddr;
   output   T_DATA_ENTRY_QP [DEVTLB_XREQ_PORTNUM-1:0][DEVTLB_TLB_NUM_WAYS-1:0]              RF_IOTLB_Qp_Data_RdData;
   input    logic [DEVTLB_XREQ_PORTNUM-1:0] [DEVTLB_TLB_NUM_WAYS-1:0]                       RF_IOTLB_Qp_Data_WrEn; 
   input    logic [DEVTLB_XREQ_PORTNUM-1:0] [`HQM_DEVTLB_LOG2(DEVTLB_TLB_NUM_PS_SETS[4])-1:0]   RF_IOTLB_Qp_Data_WrAddr;
   input    T_DATA_ENTRY_QP [DEVTLB_XREQ_PORTNUM-1:0]                                       RF_IOTLB_Qp_Data_WrData;

//------------------------------------------------------------------------------------------------------------------
// include cutomer specific rf file
//------------------------------------------------------------------------------------------------------------------

`ifdef HQM_DEVTLB_EXT_RF_EN 
   `include "hqm_devtlb_custom_rf_external.sv"
`else
   `include "hqm_devtlb_custom_rf.sv"
`endif

//=====================================================================================================================
// COVERS
//=====================================================================================================================

`ifdef HQM_DEVTLB_COVER_EN // Do not use covers in VCS...flood the log files with too many messages

`endif // DEVTLB_COVER_EN

//=====================================================================================================================
// ASSERTIONS
//=====================================================================================================================

`ifndef HQM_DEVTLB_SVA_OFF

`endif // DEVTLB_SVA_OFF


endmodule

`endif // DEVTLB_CUSTOM_RF_WRAP_VS



