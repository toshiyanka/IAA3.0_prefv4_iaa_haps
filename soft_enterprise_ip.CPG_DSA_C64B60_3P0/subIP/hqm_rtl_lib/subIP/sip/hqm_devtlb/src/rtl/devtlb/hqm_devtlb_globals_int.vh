//=====================================================================================================================
//
// iommu_globals_int.vh
//
// Contacts            : Camron Rust
// Original Author(s)  : Devin Claxton & Camron Rust
// Original Date       : 8/2012
//
// -- Intel Proprietary
// -- Copyright (C) 2016 Intel Corporation
// -- All Rights Reserved
//
// This file contains all parameters and types that are globally scoped.
// They are NOT expected to be used by the instantiating block...but only within the IOMMU
//
//=====================================================================================================================
//`ifndef IOMMU_GLOBALS_INT_VS
//`define IOMMU_GLOBALS_INT_VS


//=====================================================================================================================
// Parameters
//=====================================================================================================================

// For future 
localparam int DEVTLB_PRIV_DATA_WIDTH          = 1;                              // Width of the private data that customer wants to store
localparam logic DEVTLB_MEMTYPE_EN    = 0;

// Request Interface Definitions
//
// IOTLB_PS_MAX Definitions
// 0 = 4K array
// 1 = 4K array + 2M array
// 2 = 4K array + 2M array + 1G array
// 3 = 4K array + 2M array + 1G array + .5T array
// ....3 is NOT supported at this time
//

// Priority Values
//
localparam FETCH_ARB_FORCE_TO_PRIORITY_0   = 0;    // Force all fetches to priority 0 interface for now.
localparam DEVTLB_PRIORITY_LO              = 1'b0;
localparam DEVTLB_PRIORITY_HI              = 1'b1;

localparam IOTLB_CACHE                     = 0;


localparam PORT_0                           = 0;

localparam LPXREQ                           = 0;
localparam HPXREQ                           = 1;

//=====================================================================================================================
// Input CB Stall Deassertion Delay
//=====================================================================================================================
localparam DEVTLB_CB_STALL_DELAY     = 4;

//=====================================================================================================================
// TLB pipeline
//=====================================================================================================================

//localparam ZERO_CYCLE_TLB_ARB    = 1;

//=====================================================================================================================
// FSM parameters and types
//=====================================================================================================================

localparam CTX_LEG_T_UNTRANSLATED           = 2'b00;    // Untranslated requests are remapped.
localparam CTX_LEG_T_UNTRANSLATED_ATS       = 2'b01;    // Untranslated requests are remapped.
localparam CTX_LEG_T_PASSTHROUGH            = 2'b10;    // Pass-Through type. Untranslated requests are processed as passthrough.

localparam CTX_EXT_T_UNTRANSLATED           = 3'b000;   // Untranslated requests are remapped.
localparam CTX_EXT_T_UNTRANSLATED_ATS       = 3'b001;   // Untranslated requests are remapped, ATS enabled.
localparam CTX_EXT_T_PASSTHROUGH            = 3'b010;   // Pass-Through type.
localparam CTX_EXT_T_RESERVED_011           = 3'b011;   // Reserved
localparam CTX_EXT_T_PASSTHROUGH_SELECT     = 3'b100;   // Pass-Through type if PASID is enabled.
localparam CTX_EXT_T_PASSTHROUGH_SELECT_ATS = 3'b101;   // Pass-Through type if PASID is enabled, ATS enabled.
localparam CTX_EXT_T_RESERVED_110           = 3'b110;   // Reserved
localparam CTX_EXT_T_RESERVED_111           = 3'b111;   // Reserved

localparam QINV_ENTRY_LEG_LENGTH    = 4;  // 128 bits
localparam ROOTCTX_ENTRY_LEG_LENGTH = 4;  // 128 bits
localparam ROOT_ENTRY_EXT_LENGTH    = 2;  //  64 bits
localparam CTX_ENTRY_EXT_LENGTH     = 8;  // 256 bits
localparam PTE_ENTRY_LENGTH         = 2;  //  64 bits
localparam IRTE_ENTRY_LENGTH        = 4;  // 128 bits
localparam PI_ENTRY_LENGTH          = 4;  // 128 bits
localparam PRQ_ENTRY_LENGTH         = 4;  // 128 bits

// Convert number of sets to number of set address bits needed for each tlbid
//
`define HQM_DEVTLB_PS_4K   0
`define HQM_DEVTLB_PS_2M   1
`define HQM_DEVTLB_PS_1G   2
`define HQM_DEVTLB_PS_5T   3
`define HQM_DEVTLB_PS_QP   4

//typedef enum logic [2:0] {
//   SIZE_4K        = `DEVTLB_PS_4K,
//   SIZE_2M        = `DEVTLB_PS_2M,
//   SIZE_1G        = `DEVTLB_PS_1G,
//   SIZE_5T        = `DEVTLB_PS_5T,
//   SIZE_QP        = `DEVTLB_PS_QP    // Q = quarter, P = petabyte
//} t_devtlb_page_type;

//=====================================================================================================================
// Memory Type definitions
//=====================================================================================================================

// PAT, PCD, PWT bit positions in PTE
localparam DEVTLB_MT_PAT_4K_POS      = 7;
localparam DEVTLB_MT_PAT_1G_2M_POS   = 12;
localparam DEVTLB_MT_PCD_POS         = 4;
localparam DEVTLB_MT_PWT_POS         = 3;

//=====================================================================================================================
// Prs Rsp Code
//=====================================================================================================================
//xrsp_prs_code
//00 – if xrsp_result=1, it means prs success  (prs code = 0000 -> ats success), or ats success without prs.
//     If xrsp_result=0, it means ats fault, and no prs was requested. 
//01 – prs success->ats fault->prs success->ats fault… ats fault after looping for 8 times, xrsp_result must be 0
//10 – Invalid_request (prs code = 0001), xrsp_result must be 0
//11 – response failure (prs code = 1111) or other 

typedef enum logic [1:0] {
   DEVTLB_PRSRSP_SUC    = 2'b00,
   DEVTLB_PRSRSP_RET    = 2'b01,  //prs retired
   DEVTLB_PRSRSP_IR     = 2'b10,  //prs invalid request
   DEVTLB_PRSRSP_FAIL   = 2'b11   //prs rsp failure
} t_devtlb_prsrsp_sts;

//=====================================================================================================================
// Faults
//=====================================================================================================================

typedef enum logic [7:0] {

   DEVTLB_FAULT_RSN_RESERVED              = 8'h00,  // Reserved. Internally indicates no fault.

   // DMA remapping fault reason encodings
   //
   
   DEVTLB_FAULT_RSN_DMA_PAGE_W            = 8'h05,  // SL Page table entry used for write is not enabled for writes.
   DEVTLB_FAULT_RSN_DMA_PAGE_R            = 8'h06,  // SL Page table entry used for read is not enabled for reads.
   DEVTLB_FAULT_RSN_DMA_PASID_X           = 8'h18,  // Request w/ PASID w/ Execute Requested lacks execute permission.

   // Corrupt Request Error indication (currently not a real fault, just used for indicating an error downstream
   DEVTLB_FAULT_RSN_CORRUPT_REQUEST       = 8'hfe


} t_devtlb_fault_reason;

localparam ARRAY_LATCH                 = 0;
localparam ARRAY_FPGA                  = 1;
localparam ARRAY_RF                    = 2;
localparam ARRAY_MSFF                  = 3;
 

`ifndef HQM_IOMMU
   `define HQM_IOMMU iommu
`endif


//`endif // IOMMU_GLOBALS_INT_VS
