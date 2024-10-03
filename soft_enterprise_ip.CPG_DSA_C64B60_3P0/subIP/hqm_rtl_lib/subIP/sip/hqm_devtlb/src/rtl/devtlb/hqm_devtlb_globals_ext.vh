//=====================================================================================================================
//
// iommu_globals_ext.vh
//
// Contacts            : Camron Rust
// Original Author(s)  : Devin Claxton & Camron Rust
// Original Date       : 8/2012
//
// -- Intel Proprietary
// -- Copyright (C) 2016 Intel Corporation
// -- All Rights Reserved
//
// This file contains all localparams and types that are globally scoped
// They are expected to be used to define interfaces by the instantiating block
//
//=====================================================================================================================
//`ifndef IOMMU_GLOBALS_EXT_VS
//`define IOMMU_GLOBALS_EXT_VS

//=====================================================================================================================
// Parameters
//=====================================================================================================================
// Request Port Id width
localparam int DEVTLB_PORTS_IDW                = (DEVTLB_XREQ_PORTNUM==1)? 1: $clog2(DEVTLB_XREQ_PORTNUM);

// Request Interface bit positions
// LSB should not change, but MSB can based on width requirements
localparam int DEVTLB_MAX_GUEST_ADDRESS_WIDTH  = DEVTLB_MAX_LINEAR_ADDRESS_WIDTH;        // Maximum GPA Width that the IOMMU will advertise that it can support 
localparam int DEVTLB_REQ_PAYLOAD_MSB          = DEVTLB_MAX_GUEST_ADDRESS_WIDTH-1;
localparam int DEVTLB_REQ_PAYLOAD_LSB          = 12;
localparam int DEVTLB_REQ_PAYLOAD_WIDTH        = DEVTLB_REQ_PAYLOAD_MSB-DEVTLB_REQ_PAYLOAD_LSB+1;


// Response Interface bit positions
// LSB should not change, but MSB can based on width requirements
localparam int DEVTLB_RESP_PAYLOAD_MSB         = DEVTLB_MAX_HOST_ADDRESS_WIDTH-1;
localparam int DEVTLB_RESP_PAYLOAD_LSB         = DEVTLB_REQ_PAYLOAD_LSB;
//localparam int DEVTLB_RESP_PAYLOAD_WIDTH       = DEVTLB_RESP_PAYLOAD_MSB-DEVTLB_RESP_PAYLOAD_LSB+1;
localparam int DEVTLB_RESP_PGSIZE_WIDTH        = 3;

// Request Interface Definitions
//
localparam DEVTLB_ATSREQ_PORTNUM                        = 2; 

localparam DEVTLB_AT_WIDTH                           = 2;

localparam DEVTLB_REQ_OPCODE_WIDTH                   = 3;

localparam DEVTLB_IOOPCODE_WIDTH                    = 1;
localparam DEVTLB_IOHDR_WIDTH                       = 64;
localparam DEVTLB_IODATA_WIDTH                      = 64;
localparam DEVTLB_IOTAG_WIDTH                       = 8;
localparam DEVTLB_IOSTS_WIDTH                       = 1;
localparam DEVTLB_STU_WIDTH                          = 1;

// Response Interface Definitions
//
localparam DEVTLB_STATUS_WIDTH                       = 3;

localparam DEVTLB_MEMTYPE_WIDTH                      = 1;
localparam DEVTLB_MEM_DATA_WIDTH                     = 128;

// Parity Error vector bit position Definitions
//
localparam DEVTLB_IOTLB_250T_PARITY_POS              = 4;
localparam DEVTLB_IOTLB_500G_PARITY_POS              = 3;
localparam DEVTLB_IOTLB_1G_PARITY_POS                = 2;
localparam DEVTLB_IOTLB_2M_PARITY_POS                = 1;
localparam DEVTLB_IOTLB_4K_PARITY_POS                = 0;

localparam DEVTLB_PARITY_VEC_OFFSET                  = 5; // data occupies [4:0], tag occupies [9:5]
localparam DEVTLB_PARITY_ERR_WIDTH                   = (5*DEVTLB_PARITY_WIDTH);

// Defeature interface localparams
// 
localparam DEVTLB_DEFEATURE_REG_WIDTH                = 32; // TODO assert  ==32

localparam DEVTLB_PRIORITY_MAX                       = 1;

// Credit buffer localparams
//
// Add one to allow a FIFO_DEPTH that is a power of 2
// need to count 0....N, not just 0...N-1.
//
localparam int MAX_CB_DEPTH = (DEVTLB_LCB_DEPTH>=DEVTLB_HCB_DEPTH)? DEVTLB_LCB_DEPTH: DEVTLB_HCB_DEPTH;
localparam int DEVTLB_CB_COUNTER_WIDTH = `HQM_DEVTLB_LOG2(MAX_CB_DEPTH+1);

//Miss Fifo localparam for every port
localparam int DEVTLB_MISSFIFO_DEPTH = 8;

// Miss Tracker Paramter 
localparam int DEVTLB_MISSTRK_IDW = $clog2(DEVTLB_MISSTRK_DEPTH);

// PENDQ Paramter 
localparam int DEVTLB_PENDQ_IDW = $clog2(DEVTLB_PENDQ_DEPTH);

// INVQ Paramter 
localparam int DEVTLB_INVQ_IDW = $clog2(DEVTLB_INVQ_DEPTH);

// If PASID is supported then we need 9 bits to accommodate overloading PRGI for
// a page request
localparam int DEVTLB_TLBID_WIDTH      = `HQM_DEVTLB_LOG2(DEVTLB_TLB_NUM_ARRAYS);   
                                                // This should be large enough to index all of the TLBIDs specified above

// Only 4k, 2M, 1G, and 0.5T arrays supported for 2.0
localparam int IOTLB_PS_MAX                    = (DEVTLB_TLB_NUM_PS_SETS[3]!=0)? 3:
                                             (DEVTLB_TLB_NUM_PS_SETS[2]!=0)? 2:
                                             (DEVTLB_TLB_NUM_PS_SETS[1]!=0)? 1: 0;
                                             
localparam int IOTLB_PS_MIN                    = 0;


//=====================================================================================================================
// Opcode and AT definitions
//=====================================================================================================================

// indicates support for each opcode



localparam logic [(2**DEVTLB_REQ_OPCODE_WIDTH)-1:0] 
                        DEVTLB_OPCODE_DMA_SUPPORTED = { 1'b0, // [7] RSVD_0 
                                                   1'b1, // [6]  UARCH_INV 
                                                   1'b1, // [5]  DTLB_INV
                                                   1'b1, // [4]  FILL 
                                                   1'b1, // [3]  UTRN_ZLR
                                                   1'b1, // [2]  UTRN_RW
                                                   1'b1, // [1]  UTRN_R
                                                   1'b1  // [0]  UTRN_W
                                                };

// IOdtlb opcode encodings
typedef enum logic [2:0] {
   DEVTLB_OPCODE_UTRN_W       = 0,  
   DEVTLB_OPCODE_UTRN_R       = 1,
   DEVTLB_OPCODE_UTRN_RW      = 2,  
   DEVTLB_OPCODE_UTRN_ZLREAD  = 3,

   DEVTLB_OPCODE_FILL         = 4,
   DEVTLB_OPCODE_DTLB_INV     = 5,
   DEVTLB_OPCODE_UARCH_INV    = 6,
   DEVTLB_OPCODE_GLB_INV      = 7

} t_devtlb_opcode;

typedef enum logic [1:0] {
   DEVTLB_AT_UNTRANS        = 0,
   DEVTLB_AT_TRANS_REQ      = 1,
   DEVTLB_AT_TRANSLATED     = 2,
   DEVTLB_AT_RESERVED_3     = 3
} t_devtlb_at;

//=====================================================================================================================
// Memory Type definitions
//=====================================================================================================================

localparam DEVTLB_MEM_TYPE_UC   = 3'b000;
localparam DEVTLB_MEM_TYPE_USWC = 3'b001;
localparam DEVTLB_MEM_TYPE_WT   = 3'b100;
localparam DEVTLB_MEM_TYPE_WP   = 3'b101;
localparam DEVTLB_MEM_TYPE_WB   = 3'b110;

// Duplicate Mem-Type localparams for use in MTRR/PAT memtype-merge matrix
// (need to shorten names to fit 5 entries on each line of code
//
typedef enum logic [2:0] {
   MEMTYPE_UC   = DEVTLB_MEM_TYPE_UC,     // '000
   MEMTYPE_USWC = DEVTLB_MEM_TYPE_USWC,   // '001
   MEMTYPE__X   = 3'b011,                // Don't care value of memtype to match schematics...could be any value
   MEMTYPE_WT   = DEVTLB_MEM_TYPE_WT,     // '100
   MEMTYPE_WP   = DEVTLB_MEM_TYPE_WP,     // '101
   MEMTYPE_WB   = DEVTLB_MEM_TYPE_WB,     // '110
   MEMTYPE_UCW  = 3'b111                 // '111  Weak-UC memtype: only valid in PAT-memtype.
} t_devtlb_memtype;



typedef enum logic [DEVTLB_STATUS_WIDTH-1:0] {
//SUCCESS
 DEVTLB_RESP_HIT_VALID   = 3'b001, //XRSP
//FAIL
 DEVTLB_RESP_ACK         = 3'b000, //assert error if not DEVTLB_OPCODE_UARCH_INV
 DEVTLB_RESP_HIT_FAULT   = 3'b010, //fill? xrsp: missQ
 DEVTLB_RESP_FAILURE     = 3'b100, //XRSP
 DEVTLB_RESP_MISS        = 3'b110, //forcexrsp? xrsp? missQ

 DEVTLB_RESP_HIT_UTRN    = 3'b111, //unsupported for now
 DEVTLB_RESP_INV_HIT     = 3'b101, //end silently
 DEVTLB_RESP_INV_MISS    = 3'b011  //end silently
} t_devtlb_resp_status;

//`endif // IOMMU_GLOBALS_EXT_VS
