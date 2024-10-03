//=====================================================================================================================
//
// iommu_params.fpv.vh
//
// Contacts            : Camron Rust
// Original Author(s)  : Camron Rust
// Original Date       : 8/2012
//
// -- Intel Proprietary
// -- Copyright (C) 2015 Intel Corporation
// -- All Rights Reserved
//
//=====================================================================================================================
//
// This file contains FPV specific alternative values for several parameters
//
//=====================================================================================================================
parameter  logic DEVTLB_TLB_ZERO_CYCLE_ARB     = 1'b1;                   // TLB pipe arbiter is not staged if set
parameter  int DEVTLB_TLB_READ_LATENCY             = 1;                   // Number of cycles needed to read IOTLB/RCC/PWC -- should not be zero.
parameter  int DEVTLB_TLB_NUM_ARRAYS               = 78;                   // The number of TLBID's supported
parameter  int DEVTLB_TLB_NUM_WAYS                 = 16;                   // Applies to all IOTLB arrays
parameter  int DEVTLB_TLB_NUM_PS_SETS [5:0]        = '{ 0, 0, 0, 0, 0, 333};// Number of sets for each Size, Total
parameter  int DEVTLB_TLB_NUM_SETS [DEVTLB_TLB_NUM_ARRAYS:0][5:0]              // Number of sets for each TLBID and Size, max value for each element is 2^16-1
                                              = '{ // 256T,512G,1G,2M,4K
                                                     '{0, 0, 0, 0, 0, 0},    // TLBID = 3
                                                     '{0, 0, 0, 4, 2, 1},    // TLBID = 2
                                                     '{0, 0, 0, 1, 2, 4},    // TLBID = 1
                                                     '{0, 0, 0, 1, 2, 8}     // TLBID = 0
                                                   };


