//=====================================================================================================================
// iommu_params_cpm.vh
//
// Contacts            : Camron Rust
// Original Author(s)  : Camron Rust
// Original Date       : 11/2013
//
// -- Intel Proprietary
// -- Copyright (C) 2017 Intel Corporation
// -- All Rights Reserved
//
//=====================================================================================================================

//=====================================================================================================================
//
// DO NOT ifndef this file...it should get included in all interface declarations that expect to use instance specific parameters
//`ifndef IOMMU_PARAMS_VH 
//`define IOMMU_PARAMS_VH

//=====================================================================================================================
// Parameters/Defines
//=====================================================================================================================

// Primary TLB Structure Sizes
//
// Definition of DEVTLB_TLB_NUM_SETS 
// Fill in the matrix for the number of sets
// that should exist for each TLBID and Size
//
// Restrictions: 
//  * 0 implies that the array will not exist
//  * If a TLBID is to be valid, then the 4k TKB must exist (for IOTLB)
//  * 0.5T TLB not supported in this version
//
//  * NUM_WAYS restricted to 2, 4, 8, 16, or 32.

`ifdef FPV_REDUCED

`include "hqm_devtlb_params.fpv.vh"

`else

parameter  logic DEVTLB_TLB_ZERO_CYCLE_ARB         = 1'b0;                      // TLB pipe arbiter is not staged if set
parameter  int DEVTLB_TLB_READ_LATENCY             = 1;                         // Number of cycles needed to read IOTLB/RCC/PWC -- should not be zero.
parameter  int DEVTLB_TLB_NUM_ARRAYS               = 1;                         // The number of TLBID's supported
parameter  int DEVTLB_TLB_NUM_WAYS                 = 8;                         // Applies to all IOTLB arrays
parameter  int DEVTLB_TLB_NUM_PS_SETS [5:0]        = '{0, 0, 0, 4,  4,  16};    // Number of sets for each Size, Total
parameter  int DEVTLB_TLB_NUM_SETS [DEVTLB_TLB_NUM_ARRAYS:0][5:0] = '{          // Number of sets for each TLBID and Size, max value for each element is 2^16-1 
                                                   //  256T, 512G,   1G,   2M,  4K
                                                  '{0,    0,    0,    0,    0,   0},
                                                  '{0,    0,    0,    4,    4,  16}     // TLB 0
};
parameter  logic DEVTLB_TLB_SHARE_EN          = 1'b0; 
parameter  int DEVTLB_TLB_ALIASING [DEVTLB_TLB_NUM_ARRAYS:0][5:0] = '{
                                                   //  256T, 512G,   1G,   2M,  4K
                                                  '{0,    0,    0,    0,    0,   0},
                                                  '{0,    0,    0,    0,    0,   0}
};

`endif

// Number of DevTLB access ports
parameter int DEVTLB_XREQ_PORTNUM                = 1;

parameter int DEVTLB_TLB_ARBGCNT_WIDTH           = 3;  //width for TLB Arbiter grant count configuration signal

parameter int DEVTLB_TLB_ARRAY_STYLE [5:0]         = '{ARRAY_RF, ARRAY_RF, ARRAY_RF, ARRAY_RF, ARRAY_RF, ARRAY_RF};
//parameter int DEVTLB_TLB_ARRAY_STYLE [5:0]         = '{ARRAY_LATCH, ARRAY_LATCH, ARRAY_LATCH, ARRAY_LATCH, ARRAY_LATCH, ARRAY_LATCH};
parameter logic DEVTLB_LRU_STYLE = 1'b0; //0-PLRU, 1=SLRU

parameter int DEVTLB_MAX_LINEAR_ADDRESS_WIDTH = 57;        // Maximum LA Width that the IOMMU will support in its datapaths
parameter int DEVTLB_MAX_HOST_ADDRESS_WIDTH   = 46;       // Maximum HPA Width that the IOMMU will support in its datapaths


// Credit buffer parameters
//
parameter int DEVTLB_HCB_DEPTH = 4; //to allow hi & low req, devtlb2.0 only support >=1, 
parameter int DEVTLB_LCB_DEPTH = 4; //to allow hi & low req, devtlb2.0 only support >=1, 

parameter DEVTLB_REQ_ID_WIDTH     = 7;      // Width of ID for external buffer.

parameter int DEVTLB_PASID_WIDTH = 20;
parameter int DEVTLB_BDF_WIDTH = 16;

parameter logic DEVTLB_PRS_SUPP_EN = 1'b0;   // Include PRS logic in the design, set 0 to optimize away PRS specific logic
parameter logic DEVTLB_PASID_SUPP_EN = 1'b1; // Include PASID logic in the design, set 0 to optimize away PASID specific logic
parameter logic DEVTLB_BDF_SUPP_EN = 1'b0;   // Include BDF logic in the design, set 0 to optimize away BDF specific logic

//Miss Tracker paramter
parameter int DEVTLB_MISSTRK_DEPTH = 64; //Number of Miss Tracker entries. Minimum 2.
parameter int DEVTLB_MISSTRK_ARRAY_STYLE = ARRAY_LATCH; //Miss Tracker memory implementation. Valid value {ARRAY_RF, ARRAY_LATCH, ARRAY_MSFF)
parameter int DEVTLB_HPMSTRK_CRDT = 2;
parameter int DEVTLB_LPMSTRK_CRDT = 2;

//Pending Q support
parameter logic DEVTLB_PENDQ_SUPP_EN    = 1; // Set 1 to enable Pending Queue support.
parameter int DEVTLB_PENDQ_DEPTH = 64; //Number of Pending Queue entries. Minimum 2.
parameter int DEVTLB_PENDQ_ARRAY_STYLE = ARRAY_LATCH; //Miss Tracker memory implementation. Valid value {ARRAY_RF, ARRAY_LATCH, ARRAY_MSFF)

//Inv Q support
parameter int DEVTLB_INVQ_DEPTH = 32; //Number of Invalidation Request Queue entries. Valid vale {2 to 32}.
parameter int DEVTLB_INVQ_ARRAY_STYLE = ARRAY_LATCH; //Miss Tracker memory implementation. Valid value {ARRAY_RF, ARRAY_LATCH, ARRAY_MSFF)

// Disable all RCB/LCB power gating, retain only functional clock gating
parameter logic NO_POWER_GATING    = 1'b0;

parameter logic DEVTLB_PARITY_EN     = 1'b1;
parameter int DEVTLB_PARITY_WIDTH    = 1;  // minimun 1, leave default if DEVTLB_PARITY_EN==0

parameter int DEVTLB_NUM_DBGPORTS    = 12;

//=====================================================================================================================
// Local parameter: Following are localparam that are derived from Parameters above. 
// They shouldn't need to be overriden
//=====================================================================================================================
//TLB RF
localparam int DEVTLB_TAG_ENTRY_4K_RF_WIDTH = 1+2+DEVTLB_PASID_WIDTH+DEVTLB_BDF_WIDTH+DEVTLB_PARITY_WIDTH+DEVTLB_MAX_LINEAR_ADDRESS_WIDTH-12; 
localparam int DEVTLB_DATA_ENTRY_4K_RF_WIDTH = 4+DEVTLB_PARITY_WIDTH+DEVTLB_MAX_HOST_ADDRESS_WIDTH-12;
localparam int DEVTLB_TAG_ENTRY_2M_RF_WIDTH = 1+2+DEVTLB_PASID_WIDTH+DEVTLB_BDF_WIDTH+DEVTLB_PARITY_WIDTH+DEVTLB_MAX_LINEAR_ADDRESS_WIDTH-21; 
localparam int DEVTLB_DATA_ENTRY_2M_RF_WIDTH = 4+DEVTLB_PARITY_WIDTH+DEVTLB_MAX_HOST_ADDRESS_WIDTH-21;
localparam int DEVTLB_TAG_ENTRY_1G_RF_WIDTH = 1+2+DEVTLB_PASID_WIDTH+DEVTLB_BDF_WIDTH+DEVTLB_PARITY_WIDTH+DEVTLB_MAX_LINEAR_ADDRESS_WIDTH-30; 
localparam int DEVTLB_DATA_ENTRY_1G_RF_WIDTH = 4+DEVTLB_PARITY_WIDTH+DEVTLB_MAX_HOST_ADDRESS_WIDTH-30;

//INVQ RF
localparam int DEVTLB_INVQ_RF_WIDTH = 9+DEVTLB_MAX_LINEAR_ADDRESS_WIDTH-12; 
//PENDQ RF
localparam int DEVTLB_PENDQ_RF_WIDTH = 99999999+9+DEVTLB_MAX_LINEAR_ADDRESS_WIDTH-12; //RF is currently not supported
//MSTRK REQ RF
localparam int DEVTLB_MSTRKREQ_RF_WIDTH = 99999999+9+DEVTLB_MAX_LINEAR_ADDRESS_WIDTH-12; //RF is currently not supported
//MSTRK RSP RF
localparam int DEVTLB_MSTRKRSP_RF_WIDTH = 99999999+9+DEVTLB_MAX_HOST_ADDRESS_WIDTH-12; //RF is currently not supported

//`endif // IOMMU_PARAMS_VH
