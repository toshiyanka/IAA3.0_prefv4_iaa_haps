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

`include "hqm_devtlb_pkgparams.fpv.vh"

`else

parameter  logic DEVTLB_TLB_ZERO_CYCLE_ARB     = 1'b1;                   // TLB pipe arbiter is not staged if set
parameter  int DEVTLB_TLB_READ_LATENCY             = 1;                   // Number of cycles needed to read IOTLB/RCC/PWC -- should not be zero.
parameter  int DEVTLB_TLB_NUM_ARRAYS               = 4;                   // The number of TLBID's supported
parameter  int DEVTLB_TLB_NUM_WAYS                 = 8;                   // Applies to all IOTLB arrays
parameter  int DEVTLB_TLB_NUM_PS_SETS [5:0]        = '{0, 0, 0, 10, 32, 240};// Number of sets for each Size, Total
parameter  int DEVTLB_TLB_NUM_SETS [DEVTLB_TLB_NUM_ARRAYS:0][5:0]              // Number of sets for each TLBID and Size, max value for each element is 2^16-1 
                                              = '{ //  256T, 512G,   1G,   2M,  4K
                                                  '{0,    0,    0,    0,    0,   0},
                                                  '{0,    0,    0,    2,    0,  64}, // TLB 3
                                                  '{0,    0,    0,    4,    0, 128}, // TLB 2
                                                  '{0,    0,    0,    0,    0,  32}, // TLB 1
                                                  '{0,    0,    0,    4,   32,  16}  // TLB 0
                                                };
parameter  logic DEVTLB_TLB_SHARE_EN          = 1'b0; 
parameter  int DEVTLB_TLB_ALIASING [DEVTLB_TLB_NUM_ARRAYS:0][5:0] = '{ default:0 };
`endif

// Number of DevTLB access ports
parameter int DEVTLB_XREQ_PORTNUM                = 2;

parameter int DEVTLB_TLB_ARBGCNT_WIDTH           = 3;  //width for TLB Arbiter grant count configuration signal

//parameter int DEVTLB_TLB_ARRAY_STYLE [5:0]         = '{ARRAY_RF, ARRAY_RF, ARRAY_RF, ARRAY_RF, ARRAY_RF, ARRAY_RF};
parameter int DEVTLB_TLB_ARRAY_STYLE [5:0]         = '{ARRAY_LATCH, ARRAY_LATCH, ARRAY_LATCH, ARRAY_LATCH, ARRAY_LATCH, ARRAY_LATCH};
parameter logic DEVTLB_LRU_STYLE = 1'b0; //0-PLRU, 1=SLRU

parameter int DEVTLB_MAX_LINEAR_ADDRESS_WIDTH = 64;        // Maximum LA Width that the IOMMU will support in its datapaths
parameter int DEVTLB_MAX_HOST_ADDRESS_WIDTH   = 64;       // Maximum HPA Width that the IOMMU will support in its datapaths


// Credit buffer parameters
//
parameter int DEVTLB_HCB_DEPTH = 64; //to allow hi & low req, devtlb2.0 only support >=1, 
parameter int DEVTLB_LCB_DEPTH = 64; //to allow hi & low req, devtlb2.0 only support >=1, 

parameter DEVTLB_REQ_ID_WIDTH     = 8;      // Width of ID for external buffer.

parameter int DEVTLB_PASID_WIDTH = 20;
parameter int DEVTLB_BDF_WIDTH = 16;

parameter logic DEVTLB_PRS_SUPP_EN = 0;   // Include PRS logic in the design, set 0 to optimize away PRS specific logic
parameter logic DEVTLB_PASID_SUPP_EN = 0; // Include PASID logic in the design, set 0 to optimize away PASID specific logic
parameter logic DEVTLB_BDF_SUPP_EN = 0;   // Include BDF logic in the design, set 0 to optimize away BDF specific logic

//Miss Tracker paramter
parameter int DEVTLB_MISSTRK_DEPTH = 128; //Number of Miss Tracker entries. Minimum 2.
parameter int DEVTLB_MISSTRK_ARRAY_STYLE = ARRAY_RF; //Miss Tracker memory implementation. Valid value {ARRAY_RF, ARRAY_LATCH, ARRAY_MSFF)
parameter int DEVTLB_HPMSTRK_CRDT = 2;
parameter int DEVTLB_LPMSTRK_CRDT = 2;

//Pending Q support
parameter logic DEVTLB_PENDQ_SUPP_EN    = 1; // Set 1 to enable Pending Queue support.
parameter int DEVTLB_PENDQ_DEPTH = 64; //Number of Pending Queue entries. Minimum 2.
parameter int DEVTLB_PENDQ_ARRAY_STYLE = ARRAY_MSFF; //Miss Tracker memory implementation. Valid value {ARRAY_RF, ARRAY_LATCH, ARRAY_MSFF)

//Inv Q support
parameter int DEVTLB_INVQ_DEPTH = 64; //Number of Invalidation Request Queue entries. Valid vale {2 to 32}.
parameter int DEVTLB_INVQ_ARRAY_STYLE = ARRAY_RF; //Miss Tracker memory implementation. Valid value {ARRAY_RF, ARRAY_LATCH, ARRAY_MSFF)

// Disable all RCB/LCB power gating, retain only functional clock gating
parameter logic NO_POWER_GATING    = 1'b1;

parameter int DEVTLB_PARITY_WIDTH    = 1;
parameter logic DEVTLB_PARITY_EN     = 1'b1;

parameter int DEVTLB_NUM_DBGPORTS    = 16;

//`endif // IOMMU_PARAMS_VH
