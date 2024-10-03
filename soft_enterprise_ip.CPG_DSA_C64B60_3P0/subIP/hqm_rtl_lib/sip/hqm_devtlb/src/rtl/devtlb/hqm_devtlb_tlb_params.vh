//=====================================================================================================================
//
// iommu_tlb_params.vh
//
// Contacts            : Chintan Panirwala & Camron Rust
// Original Author(s)  : Chintan Panirwala & Camron Rust
// Original Date       : 3/2014
//
// -- Intel Proprietary
// -- Copyright (C) 2016 Intel Corporation
// -- All Rights Reserved
//
// This file contains all parameters related to TLB pipeline.
// They are NOT expected to be used by the instantiating block...but only within the IOMMU
//
//=====================================================================================================================

//=====================================================================================================================
// TLB pipeline
//=====================================================================================================================

//localparam ZERO_CYCLE_TLB_ARB    = 1;

//localparam TLB_READ_LATENCY      = 2;  // Number of cycles needed to read IOTLB/RCC/PWC -- should not be zero.
localparam TLB_TAG_DATA_OFFSET   = 1;
localparam TLB_RD_WR_OFFSET      = 2;

// Cycles as if the above parameters are 1, 1, 2

//    CYCLE 101 :    Request Input
//                   Address to BDF+GPA-> HPA TAG
         localparam  TLB_PIPE_START     = 101;
         localparam  TLB_TAG_RD_CTRL    = TLB_PIPE_START;
         localparam  TLB_LRU_RD_CTRL    = TLB_TAG_RD_CTRL   + READ_LATENCY-1;

//    CYCLE 102 :    Address to BDF+GPA-> HPA TAG Read/CAM
//                   HIT VEC to BDF+GPA-> HPA DATA
         localparam  TLB_TAG_RD         = TLB_TAG_RD_CTRL   + READ_LATENCY;
         localparam  TLB_DATA_RD_CTRL   = TLB_TAG_RD_CTRL   + 1;

//    CYCLE 103 :    BDF+GPA-> HPA DATA Read + Way Selection (If Hit)
         localparam  TLB_TO_PW          = TLB_TAG_RD        + 1;                 // Send as soon as miss is known
                                                                                 //...may need to be later if data
                                                                                 // parity needs to affect response
         localparam  TLB_LRU_WR_CTRL    = TLB_TAG_RD        + 1;                 // Control Generation...write occurs on next phase
         localparam  TLB_DATA_RD        = TLB_DATA_RD_CTRL  + READ_LATENCY;       //TODO assert TLB_LRU_WR_CTRL==TLB_DATA_RD

//    CYCLE 104 :    Tag Write control
         localparam  TLB_TAG_WR_CTRL    = TLB_DATA_RD        + 1;                 // Control Generation...write occurs on next phase
         localparam  TLB_HIT_TO_OUTPUT  = TLB_DATA_RD       + 1;                 // Drive TLB results to output

//    CYCLE 105 :    Tag Write, Data Write Control, Primary Output
         localparam  TLB_TAG_WR         = TLB_TAG_WR_CTRL   + 1;                 // Control Generation...write occurs on next phase
         localparam  TLB_DATA_WR_CTRL   = TLB_TAG_WR_CTRL   + 1;                 // Control Generation...write occurs on next phase

//    CYCLE 106 :    Drive Output, Data Write
         localparam  TLB_DATA_WR        = TLB_DATA_WR_CTRL  + 1;                 // Control Generation...write occurs on next phase

         localparam  TLB_PIPE_END       = TLB_DATA_WR_CTRL  + 1;                 // End of data pipeline...used only for writing

// Color Stall Offset due to delay from TLB Pipeline
// Additional +1 Offset for Timing 
//
//localparam TLB_COLOR_OFFSET      = TLB_TO_PW - (100 + `DEVTLB_ZX(ZERO_CYCLE_TLB_ARB,$bits(int))) + 1;

//drainreq needs inv tail to include TLB_HIT_TO_OUTPUT
//inv_tlb needs inv tail to include last TLB_TAG_WR_CTRL
localparam int TLB_INV_TAIL = (TLB_TAG_WR_CTRL>TLB_HIT_TO_OUTPUT)? TLB_TAG_WR_CTRL: TLB_HIT_TO_OUTPUT;
