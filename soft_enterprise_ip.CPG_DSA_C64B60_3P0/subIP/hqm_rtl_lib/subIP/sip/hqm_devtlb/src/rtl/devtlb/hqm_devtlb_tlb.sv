//=====================================================================================================================
// devtlb_tlb.sv
//
// Contacts            : Camron Rust
// Original Author(s)  : Devin Claxton & Camron Rust
// Original Date       : 8/2012
//
// -- Intel Proprietary
// -- Copyright (C) 2016 Intel Corporation
// -- All Rights Reserved
//
//=====================================================================================================================

`ifndef HQM_DEVTLB_TLB_VS
`define HQM_DEVTLB_TLB_VS

`include "hqm_devtlb_pkg.vh"

// Sub-module includes
`include "hqm_devtlb_array_gen.sv"

module hqm_devtlb_tlb (
//lintra -68099
   `HQM_DEVTLB_COMMON_PORTLIST
   `HQM_DEVTLB_FSCAN_PORTLIST
   PwrDnOvrd_nnnH,
   addr_translation_en,
   DisPartInv_nnnH,

   TLBPipeV_101H,
   TLBReq_101H,
   TLBCtrl_101H,
   TLBInfo_101H,

   TLBOutPipeV_nnnH,
   TLBOutXRspV_nnnH,
   TLBOutMsProcV_nnnH,
   TLBOutReq_nnnH,
   TLBOutCtrl_nnnH,
   TLBOutInfo_nnnH,

   TLBBlockArbInfo,
   
   TLBOutInvTail_nnH,

   TLBParityErr_1nnH,

   RF_PS0_Tag_RdEn,
   RF_PS0_Tag_RdAddr,
   RF_PS0_Tag_RdData,
   RF_PS0_Tag_WrEn,
   RF_PS0_Tag_WrAddr,
   RF_PS0_Tag_WrData,

   RF_PS0_Data_RdEn,
   RF_PS0_Data_RdAddr,
   RF_PS0_Data_RdData,
   RF_PS0_Data_WrEn,
   RF_PS0_Data_WrAddr,
   RF_PS0_Data_WrData,

   RF_PS1_Tag_RdEn,
   RF_PS1_Tag_RdAddr,
   RF_PS1_Tag_RdData,
   RF_PS1_Tag_WrEn,
   RF_PS1_Tag_WrAddr,
   RF_PS1_Tag_WrData,

   RF_PS1_Data_RdEn,
   RF_PS1_Data_RdAddr,
   RF_PS1_Data_RdData,
   RF_PS1_Data_WrEn,
   RF_PS1_Data_WrAddr,
   RF_PS1_Data_WrData,

   RF_PS2_Tag_RdEn,
   RF_PS2_Tag_RdAddr,
   RF_PS2_Tag_RdData,
   RF_PS2_Tag_WrEn,
   RF_PS2_Tag_WrAddr,
   RF_PS2_Tag_WrData,

   RF_PS2_Data_RdEn,
   RF_PS2_Data_RdAddr,
   RF_PS2_Data_RdData,
   RF_PS2_Data_WrEn,
   RF_PS2_Data_WrAddr,
   RF_PS2_Data_WrData,

   RF_PS3_Tag_RdEn,
   RF_PS3_Tag_RdAddr,
   RF_PS3_Tag_RdData,
   RF_PS3_Tag_WrEn,
   RF_PS3_Tag_WrAddr,
   RF_PS3_Tag_WrData,

   RF_PS3_Data_RdEn,
   RF_PS3_Data_RdAddr,
   RF_PS3_Data_RdData,
   RF_PS3_Data_WrEn,
   RF_PS3_Data_WrAddr,
   RF_PS3_Data_WrData,

   RF_PS4_Tag_RdEn,
   RF_PS4_Tag_RdAddr,
   RF_PS4_Tag_RdData,
   RF_PS4_Tag_WrEn,
   RF_PS4_Tag_WrAddr,
   RF_PS4_Tag_WrData,

   RF_PS4_Data_RdEn,
   RF_PS4_Data_RdAddr,
   RF_PS4_Data_RdData,
   RF_PS4_Data_WrEn,
   RF_PS4_Data_WrAddr,
   RF_PS4_Data_WrData,
   
   DEVTLB_Tag_RdEn_Spec,   
   DEVTLB_Tag_RdEn,   
   DEVTLB_Tag_Rd_Addr,
   DEVTLB_Tag_Rd_Data,
   DEVTLB_Tag_WrEn,  
   DEVTLB_Tag_Wr_Addr,
   DEVTLB_Tag_Wr_Way,
   DEVTLB_Tag_Wr_Data,

   DEVTLB_Data_RdEn_Spec,   
   DEVTLB_Data_RdEn,   
   DEVTLB_Data_Rd_Addr,
   DEVTLB_Data_Rd_Data,
   DEVTLB_Data_WrEn,  
   DEVTLB_Data_Wr_Addr,
   DEVTLB_Data_Wr_Way,
   DEVTLB_Data_Wr_Data,

   DEVTLB_LRU_RdEn_Spec,
   DEVTLB_LRU_RdEn,
   DEVTLB_LRU_Rd_SetAddr,
   DEVTLB_LRU_Rd_Invert,
   DEVTLB_LRU_Rd_WayVec,
   DEVTLB_LRU_Rd_Way2ndVec,
   DEVTLB_LRU_WrEn,
   DEVTLB_LRU_Wr_SetAddr,
   DEVTLB_LRU_Wr_HitVec,
   DEVTLB_LRU_Wr_RepVec,
   LRUDisable_Ways,

   ObsIotlbLkpValid_nnnH,   
   ObsIotlbOrgReqID_nnnH,   
   ObsIotlbID_nnnH, 
   ObsIotlbOrgHitVec_nnnH,
   ObsIotlbInvValid_nnnH,
   ObsIotlbReqPageSize_nnnH,
   ObsIotlbFilledPageSize_nnnH,
   ObsIotlbMisc_nnnH,
   //ObsIOTLBSPHit_nnnH,               

   ParErrOneShot_nnnH,

   Disable_Ways,
   CrParErrInj_nnnH
//lintra +68099
);


import `HQM_DEVTLB_PACKAGE_NAME::*; // defines typedefs, functions, macros for the IOMMU
`include "hqm_devtlb_pkgparams.vh"

// TLB specific but generic parameters to be used to configure for each type of TLB
//
parameter logic DEVTLB_IN_FPV       = 1'b0;
parameter int DEVTLB_PORT_ID        = 0;
parameter logic ZERO_CYCLE_TLB_ARB  = 1;  // 1 - TLB ARB has zero latency
parameter logic ALLOW_TLBRWCONFLICT  = 0;  //1 if TLB array allow RW conflict
parameter int READ_LATENCY          = 1;    // Number of cycles needed to read IOTLB/RCC/PWC -- should not be zero.
parameter int NUM_RD_PORTS          = 1;
parameter int NUM_ARRAYS            = 1;    // Number of TLBID's that will be supported
parameter int TLBID_WIDTH           = 1;
parameter int NUM_WAYS              = 4;
parameter int PS_MAX                = 2;    // Page size tlbs supported 0=4K, 1=2M, 2=1G, 3=0.5T
parameter int PS_MIN                = 0;    // Page size tlbs supported 0=4K, 1=2M, 2=1G, 3=0.5T

parameter int NUM_PS_SETS  [5:0]          = '{ default:0 };   // Number of sets per TLBID per Size
parameter int NUM_SETS [NUM_ARRAYS:0][5:0]    = '{ default:0 };   // Number of sets per TLBID per Size
parameter logic TLB_SHARE_EN                   = 1'b0;
parameter int TLB_ALIASING [NUM_ARRAYS:0][5:0] = '{ default:0 };

parameter  int ARRAY_STYLE [5:0]       = '{default:ARRAY_LATCH};   // Type of array to use (0 = Latch Array, 1 = gram, 2 = RF), per size
parameter  logic LRU_STYLE             = 1'b0; //0=PLRU

parameter type T_TAG_ENTRY_0           = logic;
parameter type T_TAG_ENTRY_1           = logic;
parameter type T_TAG_ENTRY_2           = logic;
parameter type T_TAG_ENTRY_3           = logic;
parameter type T_TAG_ENTRY_4           = logic;
parameter type T_DATA_ENTRY_0          = logic;
parameter type T_DATA_ENTRY_1          = logic;
parameter type T_DATA_ENTRY_2          = logic;
parameter type T_DATA_ENTRY_3          = logic;
parameter type T_DATA_ENTRY_4          = logic;

parameter type T_TLBBLK_INFO           = logic; //t_devtlb_arbtlbinfo;
parameter type T_REQ                   = logic; //t_devtlb_request;
parameter type T_REQ_CTRL              = logic; //t_devtlb_request_ctrl;
parameter type T_REQ_INFO              = logic; //t_devtlb_request_info;
parameter type T_REQ_COMPLETE          = logic; //t_request_complete;
parameter type T_SETADDR               = logic; //t_devtlb_tlb_setaddr;
parameter type T_BITPERWAY             = logic; //t_tlb_bitperway;
parameter type T_OPCODE                = logic; //t_devtlb_opcode;
parameter type T_PGSIZE                = logic; //t_devtlb_page_type;
parameter type T_FAULTREASON           = logic; //t_devtlb_fault_reason;
parameter type T_STATUS                = logic; //t_devtlb_resp_status;

parameter int MAX_GUEST_ADDRESS_WIDTH = 64;
parameter int GAW_LAW_MAX = (MAX_GUEST_ADDRESS_WIDTH > DEVTLB_MAX_LINEAR_ADDRESS_WIDTH) 
                            ?  MAX_GUEST_ADDRESS_WIDTH : DEVTLB_MAX_LINEAR_ADDRESS_WIDTH;
//typedef logic [NUM_WAYS-1:0]        T_BITPERWAY;

parameter logic ARSP_X_SUPP = 1'b0;

`include "hqm_devtlb_tlb_params.vh"         // TLB pipeline parameters


// Supplementary info about packet....partial, non-data results


// All-in-one TLB pipeline structure



//======================================================================================================================
//                                           Interface signal declarations
//======================================================================================================================

   `HQM_DEVTLB_COMMON_PORTDEC
   `HQM_DEVTLB_FSCAN_PORTDEC

   input    logic                               PwrDnOvrd_nnnH;      // Powerdown override
   input    logic                               addr_translation_en; // Translation enabled
   input    logic                               DisPartInv_nnnH;

   // DMA Request
   //
   input    logic                               TLBPipeV_101H;       // Request from TLB Arbiter
   input    T_REQ                               TLBReq_101H;         // Request from TLB Arbiter
   input    T_REQ_CTRL                          TLBCtrl_101H;        // Request from TLB Arbiter
   input    T_REQ_INFO                          TLBInfo_101H;        // Request from TLB Arbiter

   // Output to PW, Complete
   output   logic                               TLBOutPipeV_nnnH;       // TLB Ouput to response interface and/or fault detection
   output   logic                               TLBOutXRspV_nnnH;       // TLB output to XRsp interface
   output   logic                               TLBOutMsProcV_nnnH;        // TLB output to MsProc
   output   T_REQ                               TLBOutReq_nnnH;         // TLB Ouput to response interface and/or fault detection
   output   T_REQ_CTRL                          TLBOutCtrl_nnnH;        // TLB Ouput to response interface and/or fault detection
   output   T_REQ_INFO                          TLBOutInfo_nnnH;        // TLB Ouput to response interface and/or fault detection

   output   T_TLBBLK_INFO                       TLBBlockArbInfo;        // Structure fedback to TLB Arb for preventing RF Rd-Wr conflict
   
   output   logic                               TLBOutInvTail_nnH;      //Glb or TLB Inv in end of pipe 

   // Output to Response interface, indicates parity error on either tag or data bits
   output   t_devtlb_cr_parity_err              TLBParityErr_1nnH;      // TLB Parity Error   

   // Interface to control registers
   //
   input    logic                               ParErrOneShot_nnnH;        // Misc defeature register

   //======================================================================================================================
   //  Register File Connectivity...used only when custom RFs are enabled

   // 4k/L1 (L1 never actually used)
   output   logic                                                    RF_PS0_Tag_RdEn;
   output   logic [`HQM_DEVTLB_LOG2(NUM_PS_SETS[0])-1:0]                 RF_PS0_Tag_RdAddr;
   input    T_TAG_ENTRY_0                           [NUM_WAYS-1:0]   RF_PS0_Tag_RdData;
   output   logic                                   [NUM_WAYS-1:0]   RF_PS0_Tag_WrEn;
   output   logic [`HQM_DEVTLB_LOG2(NUM_PS_SETS[0])-1:0]                 RF_PS0_Tag_WrAddr;
   output   T_TAG_ENTRY_0                                            RF_PS0_Tag_WrData;

   output   logic                                                    RF_PS0_Data_RdEn;
   output   logic [`HQM_DEVTLB_LOG2(NUM_PS_SETS[0])-1:0]                 RF_PS0_Data_RdAddr; 
   input    T_DATA_ENTRY_0                          [NUM_WAYS-1:0]   RF_PS0_Data_RdData;
   output   logic                                   [NUM_WAYS-1:0]   RF_PS0_Data_WrEn;
   output   logic [`HQM_DEVTLB_LOG2(NUM_PS_SETS[0])-1:0]                 RF_PS0_Data_WrAddr; 
   output   T_DATA_ENTRY_0                                           RF_PS0_Data_WrData; 

   // 2m/L2
   output   logic                                                    RF_PS1_Tag_RdEn;
   output   logic [`HQM_DEVTLB_LOG2(NUM_PS_SETS[1])-1:0]                 RF_PS1_Tag_RdAddr;
   input    T_TAG_ENTRY_1                           [NUM_WAYS-1:0]   RF_PS1_Tag_RdData;
   output   logic                                   [NUM_WAYS-1:0]   RF_PS1_Tag_WrEn;
   output   logic [`HQM_DEVTLB_LOG2(NUM_PS_SETS[1])-1:0]                 RF_PS1_Tag_WrAddr;
   output   T_TAG_ENTRY_1                                            RF_PS1_Tag_WrData;

   output   logic                                                    RF_PS1_Data_RdEn;
   output   logic [`HQM_DEVTLB_LOG2(NUM_PS_SETS[1])-1:0]                 RF_PS1_Data_RdAddr; 
   input    T_DATA_ENTRY_1                          [NUM_WAYS-1:0]   RF_PS1_Data_RdData;
   output   logic                                   [NUM_WAYS-1:0]   RF_PS1_Data_WrEn;
   output   logic [`HQM_DEVTLB_LOG2(NUM_PS_SETS[1])-1:0]                 RF_PS1_Data_WrAddr; 
   output   T_DATA_ENTRY_1                                           RF_PS1_Data_WrData; 

   // 1g/L3
   output   logic                                                    RF_PS2_Tag_RdEn;
   output   logic [`HQM_DEVTLB_LOG2(NUM_PS_SETS[2])-1:0]                 RF_PS2_Tag_RdAddr;
   input    T_TAG_ENTRY_2                           [NUM_WAYS-1:0]   RF_PS2_Tag_RdData;
   output   logic                                   [NUM_WAYS-1:0]   RF_PS2_Tag_WrEn;
   output   logic [`HQM_DEVTLB_LOG2(NUM_PS_SETS[2])-1:0]                 RF_PS2_Tag_WrAddr;
   output   T_TAG_ENTRY_2                                            RF_PS2_Tag_WrData;

   output   logic                                                    RF_PS2_Data_RdEn;
   output   logic [`HQM_DEVTLB_LOG2(NUM_PS_SETS[2])-1:0]                 RF_PS2_Data_RdAddr; 
   input    T_DATA_ENTRY_2                          [NUM_WAYS-1:0]   RF_PS2_Data_RdData;
   output   logic                                   [NUM_WAYS-1:0]   RF_PS2_Data_WrEn;
   output   logic [`HQM_DEVTLB_LOG2(NUM_PS_SETS[2])-1:0]                 RF_PS2_Data_WrAddr; 
   output   T_DATA_ENTRY_2                                           RF_PS2_Data_WrData; 

   // 1g/L3
   output   logic                                                    RF_PS3_Tag_RdEn;
   output   logic [`HQM_DEVTLB_LOG2(NUM_PS_SETS[3])-1:0]                 RF_PS3_Tag_RdAddr;
   input    T_TAG_ENTRY_3                           [NUM_WAYS-1:0]   RF_PS3_Tag_RdData;
   output   logic                                   [NUM_WAYS-1:0]   RF_PS3_Tag_WrEn;
   output   logic [`HQM_DEVTLB_LOG2(NUM_PS_SETS[3])-1:0]                 RF_PS3_Tag_WrAddr;
   output   T_TAG_ENTRY_3                                            RF_PS3_Tag_WrData;

   output   logic                                                    RF_PS3_Data_RdEn;
   output   logic [`HQM_DEVTLB_LOG2(NUM_PS_SETS[3])-1:0]                 RF_PS3_Data_RdAddr; 
   input    T_DATA_ENTRY_3                          [NUM_WAYS-1:0]   RF_PS3_Data_RdData;
   output   logic                                   [NUM_WAYS-1:0]   RF_PS3_Data_WrEn;
   output   logic [`HQM_DEVTLB_LOG2(NUM_PS_SETS[3])-1:0]                 RF_PS3_Data_WrAddr; 
   output   T_DATA_ENTRY_3                                           RF_PS3_Data_WrData; 

   // 0.25P/L4
   output   logic                                                    RF_PS4_Tag_RdEn;
   output   logic [`HQM_DEVTLB_LOG2(NUM_PS_SETS[4])-1:0]                 RF_PS4_Tag_RdAddr;
   input    T_TAG_ENTRY_4                           [NUM_WAYS-1:0]   RF_PS4_Tag_RdData;
   output   logic                                   [NUM_WAYS-1:0]   RF_PS4_Tag_WrEn;
   output   logic [`HQM_DEVTLB_LOG2(NUM_PS_SETS[4])-1:0]                 RF_PS4_Tag_WrAddr;
   output   T_TAG_ENTRY_4                                            RF_PS4_Tag_WrData;

   output   logic                                                    RF_PS4_Data_RdEn;
   output   logic [`HQM_DEVTLB_LOG2(NUM_PS_SETS[4])-1:0]                 RF_PS4_Data_RdAddr; 
   input    T_DATA_ENTRY_4                          [NUM_WAYS-1:0]   RF_PS4_Data_RdData;
   output   logic                                   [NUM_WAYS-1:0]   RF_PS4_Data_WrEn;
   output   logic [`HQM_DEVTLB_LOG2(NUM_PS_SETS[4])-1:0]                 RF_PS4_Data_WrAddr; 
   output   T_DATA_ENTRY_4                                           RF_PS4_Data_WrData; 

   //======================================================================================================================
   // VISA signals
   //
   output   logic                               ObsIotlbLkpValid_nnnH;        // IOTLB any lookup valid
   output   logic [7:0]                         ObsIotlbOrgReqID_nnnH;        // IOTLB original lookup id
   output   logic [7:0]                         ObsIotlbID_nnnH;              // IOTLB id
   output   logic [2:0]                         ObsIotlbOrgHitVec_nnnH;       // IOTLB original hit vector
   output   logic                               ObsIotlbInvValid_nnnH;        // IOTLB Inv valid
   output   logic [2:0]                         ObsIotlbReqPageSize_nnnH;     // IOTLB requested page size
   output   logic [2:0]                         ObsIotlbFilledPageSize_nnnH;  // IOTLB filled page size
   output   logic [1:0]                         ObsIotlbMisc_nnnH;
   
   //======================================================================================================================
   //TLB Access signals
   //
   output   logic                   [PS_MAX:PS_MIN]               DEVTLB_Tag_RdEn_Spec;
   output   logic                   [PS_MAX:PS_MIN]               DEVTLB_Tag_RdEn;
   output   T_SETADDR               [PS_MAX:PS_MIN]               DEVTLB_Tag_Rd_Addr;
   input    T_TAG_ENTRY_0           [PS_MAX:PS_MIN][NUM_WAYS-1:0] DEVTLB_Tag_Rd_Data;
   output   logic                   [PS_MAX:PS_MIN]               DEVTLB_Tag_WrEn;
   output   T_SETADDR               [PS_MAX:PS_MIN]               DEVTLB_Tag_Wr_Addr;
   output   T_BITPERWAY             [PS_MAX:PS_MIN]               DEVTLB_Tag_Wr_Way;
   output   T_TAG_ENTRY_0           [PS_MAX:PS_MIN]               DEVTLB_Tag_Wr_Data;

   output   logic                   [PS_MAX:PS_MIN]               DEVTLB_Data_RdEn_Spec;
   output   logic                   [PS_MAX:PS_MIN]               DEVTLB_Data_RdEn;
   output   T_SETADDR               [PS_MAX:PS_MIN]               DEVTLB_Data_Rd_Addr;
   input    T_DATA_ENTRY_0          [PS_MAX:PS_MIN][NUM_WAYS-1:0] DEVTLB_Data_Rd_Data;
   output   logic                   [PS_MAX:PS_MIN]               DEVTLB_Data_WrEn;
   output   T_SETADDR               [PS_MAX:PS_MIN]               DEVTLB_Data_Wr_Addr;
   output   T_BITPERWAY             [PS_MAX:PS_MIN]               DEVTLB_Data_Wr_Way;
   output   T_DATA_ENTRY_0          [PS_MAX:PS_MIN]               DEVTLB_Data_Wr_Data;

   //======================================================================================================================
   //LRU Access signals
   //
   output   logic                                                 DEVTLB_LRU_RdEn_Spec;
   output   logic                   [PS_MAX:PS_MIN]               DEVTLB_LRU_RdEn;
   output   T_SETADDR               [PS_MAX:PS_MIN]               DEVTLB_LRU_Rd_SetAddr;
   output   logic                   [PS_MAX:PS_MIN]               DEVTLB_LRU_Rd_Invert;
   input    logic                   [PS_MAX:PS_MIN][NUM_WAYS-1:0] DEVTLB_LRU_Rd_WayVec;
   input    logic                   [PS_MAX:PS_MIN][NUM_WAYS-1:0] DEVTLB_LRU_Rd_Way2ndVec;
   output   logic                   [PS_MAX:PS_MIN]               DEVTLB_LRU_WrEn;
   output   T_SETADDR               [PS_MAX:PS_MIN]               DEVTLB_LRU_Wr_SetAddr; 
   output   T_BITPERWAY             [PS_MAX:PS_MIN]               DEVTLB_LRU_Wr_HitVec;
   output   T_BITPERWAY             [PS_MAX:PS_MIN]               DEVTLB_LRU_Wr_RepVec;
   output   logic                   [PS_MAX:PS_MIN] [1:0]         LRUDisable_Ways;

   // Defeature signals
   //
   input    logic [NUM_ARRAYS-1:0] [PS_MAX:PS_MIN] [1:0]  Disable_Ways;
   input    t_devtlb_cr_parity_err                        CrParErrInj_nnnH;
 

//======================================================================================================================
//                                            Internal signal declarations
//======================================================================================================================

   // Create pipe stage specific clocks for each array action. Index indicates the pipestage that the clock is for

   logic             pEn_ClkTLBPipeV_H     [TLB_PIPE_END  :TLB_PIPE_START  ];
   logic             ClkTLBPipeV_H         [TLB_PIPE_END+1:TLB_PIPE_START+1];
   logic             TLBPipeV_H            [TLB_PIPE_END+1:TLB_PIPE_START  ];

   logic             pEn_ClkTLBPipe_H      [TLB_PIPE_END-1:TLB_PIPE_START  ];
   logic             ClkTLBPipe_H          [TLB_PIPE_END  :TLB_PIPE_START+1];
   T_REQ_COMPLETE    TLBPipe_H             [TLB_PIPE_END  :TLB_PIPE_START  ];  // Full pipeline packet
   T_REQ_COMPLETE    ff_TLBPipe_H          [TLB_PIPE_END  :TLB_PIPE_START+1];  // Full pipeline packet, staged

   // Address Cache array output declarations
   //
   T_TAG_ENTRY_0          ArrRdTag_H       [PS_MAX:PS_MIN] [NUM_WAYS-1:0];
   T_DATA_ENTRY_0         ArrRdData_H      [PS_MAX:PS_MIN] [NUM_WAYS-1:0];

   // Alternate array outputs used for parity calculations
   T_TAG_ENTRY_0          ArrRdTagP_H      [PS_MAX:PS_MIN] [NUM_WAYS-1:0];
   T_DATA_ENTRY_0         ArrRdDataP_H;

   T_TAG_ENTRY_0      [NUM_WAYS-1:0]     ArrRdTagInt_H    [PS_MAX:PS_MIN];
   T_DATA_ENTRY_0     [NUM_WAYS-1:0]     ArrRdDataInt_H   [PS_MAX:PS_MIN];

   logic                  LRU_Lookup_En_H;
   logic  [NUM_WAYS-1:0]  ArrRdLRUWayVec_H [PS_MAX:PS_MIN];
   logic  [NUM_WAYS-1:0]  ArrRdLRUWay2ndVec_H [PS_MAX:PS_MIN];

   T_TAG_ENTRY_0          ArrWrTagNxt_H    [PS_MAX:PS_MIN];
   T_DATA_ENTRY_0         ArrWrDataNxt_H   [PS_MAX:PS_MIN];
   T_TAG_ENTRY_0          ArrWrTag_H       [PS_MAX:PS_MIN];
   T_DATA_ENTRY_0         ArrWrData_H      [PS_MAX:PS_MIN];

   // Set Address Calculation intermediate signals
   //
   T_SETADDR    [PS_MAX:PS_MIN]    SetAddr_H;    // TLB Specific Set Address 

   // Parity Calculation intermediate signals
   //
   //logic                  [PS_MAX:PS_MIN]  [DEVTLB_PARITY_WIDTH-1:0] TagParity_H;  // TLB Specific Tag Parity

   // Fault detection intermediate signals
   //
   logic TLBReadReqVal_H;     // Valid read request in fault detection pipestage
   logic TLBWriteReqVal_H;    // Valid write request in fault detection pipestage
   logic TLBZlrReqVal_H;      // Valid zero-length read request in fault detection pipestage
   logic TLBExeReqVal_H;      // Valid execute request in fault detection pipestage
   logic TLBReadFault_H;      // Read fault detected
   logic TLBWriteFault_H;     // Write fault detected
   logic TLBExecuteFault_H;   // Execute fault detected

   logic preTLBOutPipeV_nnnH;
   logic preTLBOutXRspV_nnnH;
   logic preTLBOutMsProcV_nnnH;
   logic TLBHitPipeV_nnnH;  
   logic TLBMissPipeV_nnnH;
   logic TLBFillPipeV_nnnH;
   logic TLBInvPipeV_nnnH;
   logic TLBFaultPipeV_nnnH;
   logic TLBFillFaultPipeV_nnnH;
   logic TLBDPErrPipeV_nnnH;
   logic ReqAtsRspErrPipeV_nnnH;
//   logic SetInvHit_nnnH;
//   logic RstInvHit_nnnH;
//   logic InvHit_nnnH;
//   logic [PS_MAX:PS_MIN] SetInvHitPS_nnnH;
//   logic TLBOutInv_nnnH;
//   logic SetTLBOutInv_nnnH;
//   logic RstTLBOutInv_nnnH;

   T_BITPERWAY   [PS_MAX:PS_MIN]      BDFMatch;         // The TLB BDF matches
   T_BITPERWAY   [PS_MAX:PS_MIN]      PASIDMatch;       // The TLB PASID matches
   T_BITPERWAY   [PS_MAX:PS_MIN]      PRMatch;          // The TLB PR matches
   T_BITPERWAY   [PS_MAX:PS_MIN]      SLSetMatch;       // The TLB matches the right set range, used for InvalPage Set match
   T_BITPERWAY   [PS_MAX:PS_MIN]      AddrMatch;        // The TLB matches the right address range
   
   //T_BITPERWAY   [PS_MAX:PS_MIN]      InvalAddrMatch;      // The TLB matches the right address range
   T_BITPERWAY   [PS_MAX:PS_MIN]      FullMatch;        // The TLB matches overall

   T_TAG_ENTRY_0 [NUM_ARRAYS-1:0][PS_MAX:PS_MIN]                              TagMaskBase_H;
   T_TAG_ENTRY_0 [TLB_TAG_RD:TLB_PIPE_START][NUM_ARRAYS-1:0][PS_MAX:PS_MIN]   TagMask_H;

   logic [PS_MAX:PS_MIN]                           TLBDataParityError_nnnH; // Resolved data parity error per page size, not including atsrsp_dperr
   logic                                           ReqAtsRspError_nnnH;  // HdrErr or DPERR from Fill or PendQ Req
   t_devtlb_cr_parity_err                          TLBParityErr_nnnH;       // Final TLB Parity Error

   logic [PS_MAX:PS_MIN]                           TLBTagParityErrLog_nnnH;  // Resolved tag parity error per page size
   logic [PS_MAX:PS_MIN]                           TLBDataParityErrLog_nnnH;  // Resolved tag parity error per page size
   logic                                           ParErrInjected_nnnH;         // parity error injected (for injection logic)
   logic                                           SetParErrInjected_nnnH;      // set signal for SRFF
   logic                                           ResetParErrInjected_nnnH;    // reset signal for SRFF
   logic                                           ParErrOneShot_1nnH;     // flopped signal of parity error injection
                                                                           // one-shot mode
   logic [PS_MAX:PS_MIN]                           InjectTagParErr_nnnH;   // inject a parity error from defeature reg
   logic [PS_MAX:PS_MIN]                           InjectDataParErr_nnnH;      

   logic [PS_MAX:PS_MIN]                           TagParPoison_nnnH;   // inject a parity error from defeature reg
   logic [PS_MAX:PS_MIN]                           DataParPoison_nnnH;      

   logic [PS_MAX:PS_MIN]                           DisRdEn;

   logic [PS_MAX:PS_MIN] [NUM_WAYS-1:0]            ArrayEntryValid;   
   logic [PS_MAX:PS_MIN] [NUM_WAYS-1:0]            TempArrayValidBit;   

   T_BITPERWAY [TLB_TAG_RD:TLB_TAG_RD][PS_MAX:PS_MIN] TempRepVec;
   logic [TLB_TAG_RD:TLB_TAG_RD][PS_MAX:PS_MIN]       FillRdStaleLRU;

   logic             [36:0]                        SLSetInvalMask;   //Calculate Mask to be applied on account of InvalMaskBits
   logic             [PS_MAX:PS_MIN]  [15:0]       SLSetAddr;        //Calculate effective set address being accessed for SL only invalidation

   logic             [5:0]                         InvalMasKBits_PS [PS_MAX:PS_MIN];


//======================================================================================================================

   genvar g_id;
   genvar g_ps;
   genvar g_ps2;
   genvar g_set;
   genvar g_way;
   genvar x;
   genvar g_pipestage;

//=====================================================================================================================
// CLOCK CONTROL,  CLOCK GENERATION, AND MAIN PIPELINE STATE
//=====================================================================================================================

   logic ClkRcb_nnnH;
   logic RcbEn_nnnH;
   logic pEn_ClkParErr_H;  // Clock for parity error capturing

   always_comb begin
      RcbEn_nnnH = ResetParErrInjected_nnnH | reset | pEn_ClkParErr_H;

      for (int g_pipestage = TLB_PIPE_START; g_pipestage <= TLB_PIPE_END+1; g_pipestage++) begin  : PipeV_StateRCB
         RcbEn_nnnH |= TLBPipeV_H[g_pipestage];
      end
   end

   `HQM_DEVTLB_MAKE_RCB_PH1(ClkRcb_nnnH, clk, RcbEn_nnnH, PwrDnOvrd_nnnH)


   generate
      for (g_pipestage = TLB_PIPE_START+1; g_pipestage <= TLB_PIPE_END+1; g_pipestage++) begin  : PipeV_State

         assign pEn_ClkTLBPipeV_H [g_pipestage-1]  = reset
                                                   | TLBPipeV_H[g_pipestage-1]
                                                   | TLBPipeV_H[g_pipestage];    // Clock Enables for valid
                                                                                 // must fire twice to clear valid bit
                                                                                 // after it passes

         `HQM_DEVTLB_MAKE_LCB_PWR(ClkTLBPipeV_H[g_pipestage], ClkRcb_nnnH, pEn_ClkTLBPipeV_H[g_pipestage-1], PwrDnOvrd_nnnH)
         `HQM_DEVTLB_RST_MSFF(TLBPipeV_H[g_pipestage],      TLBPipeV_H[g_pipestage-1],    ClkTLBPipeV_H[g_pipestage], reset)

      end

      for (g_pipestage = TLB_PIPE_START+1; g_pipestage <= TLB_PIPE_END; g_pipestage++) begin  : Pipe_State

         assign pEn_ClkTLBPipe_H  [g_pipestage-1]  = reset
                                                   | TLBPipeV_H[g_pipestage-1];  // Clock Enables for all except valid

         `HQM_DEVTLB_MAKE_LCB_PWR(ClkTLBPipe_H[g_pipestage],  ClkRcb_nnnH, pEn_ClkTLBPipe_H[g_pipestage-1],  PwrDnOvrd_nnnH)
         `HQM_DEVTLB_MSFF(ff_TLBPipe_H[g_pipestage],    TLBPipe_H[g_pipestage-1],     ClkTLBPipe_H[g_pipestage])

      end

   endgenerate

//=====================================================================================================================
// INPUT COLLECTION
//
// BDF+GPA-> HPA TAG Read Control Logic (Stage 101)
//=====================================================================================================================

always_comb begin
   TLBPipeV_H[TLB_PIPE_START]          = TLBPipeV_101H;
   TLBPipe_H[TLB_PIPE_START].Req       = TLBReq_101H;

   // Force zero on PASID-only fields when PASID is disabled to ensure synthesis can eliminate unnecessary logic
   //
   if (DEVTLB_PASID_SUPP_EN == 0) begin
      TLBPipe_H[TLB_PIPE_START].Req.PASID    = '0;
      TLBPipe_H[TLB_PIPE_START].Req.PasidV   = '0;
      //TLBPipe_H[TLB_PIPE_START].Req.ER       = '0;
      TLBPipe_H[TLB_PIPE_START].Req.PR       = '0;
   end

   TLBPipe_H[TLB_PIPE_START].Ctrl      = TLBCtrl_101H;
   TLBPipe_H[TLB_PIPE_START].Info      = TLBInfo_101H;

   // Mask fill bit when translation enable is off to prevent latent prefetch requests from writing into a cache after TE is off
   TLBPipe_H[TLB_PIPE_START].Ctrl.Fill &= addr_translation_en;

   // Unpack the rhs & Populated within the TLB pipeline
   //
   {>>{TLBPipe_H[TLB_PIPE_START].ArrInfo}}   = {$bits(TLBPipe_H[TLB_PIPE_START].ArrInfo){1'b0}};
   {>>{TLBPipe_H[TLB_PIPE_START].ArrCtrl}}   = {$bits(TLBPipe_H[TLB_PIPE_START].ArrCtrl){1'b0}};

   DisRdEn  =  '0;

   // Tag read control generation
   //
   for (int tlb_ps = PS_MIN; tlb_ps <= PS_MAX; tlb_ps++) begin  : Tag_RD_Ctrl_PS_Lp
      
      DisRdEn[tlb_ps] = TLBPipe_H[TLB_TAG_RD_CTRL].Ctrl.DisRdEn[tlb_ps]; 
      TLBPipe_H[TLB_TAG_RD_CTRL].ArrCtrl[tlb_ps].RdEn  =  f_tlb_lookup_en(
                                                            TLBPipe_H[TLB_TAG_RD_CTRL].Req.Opcode,
                                                            TLBPipe_H[TLB_TAG_RD_CTRL].Req.Overflow)
                                                         &  TLBPipeV_H[TLB_TAG_RD_CTRL]
                                                         & ~TLBPipe_H[TLB_TAG_RD_CTRL].Ctrl.InvalGlb
                                                         & (NUM_SETS[`HQM_DEVTLB_PIPE_TLBID(TLB_TAG_RD_CTRL, tlb_ps)][tlb_ps] > 0)
                                                         & ~DisRdEn[tlb_ps];

      // Suppress the read enable for the lower caches for the L3_BASE_FETCH opcode. It is explicitly looking for the
      // base address of the L3 table so any SLPWC hit at the L3 or below would be wrong. For the L4 table, the contents
      // may contain the right information, however, there is no path from the SLPWC to the fill FSM, so we can't make
      // use of its contents. The L3 Base fetch can only be allowed to hit in an L5 cache, it one exists.
      // SetAddr is calculated separately as it depends on TLB MODE
      TLBPipe_H[TLB_TAG_RD_CTRL].ArrCtrl[tlb_ps].SetAddr = SetAddr_H[tlb_ps];

   end

   // FRACTURING for only the IOTLB and only for DMA requests
   //
   // Find largest PageSize TLB array that is equal to or smaller than the calculated pagesize.
   // This fractures large pages down to the first available TLB that can represent the page.
   //
   // hkhor1: Figuring EffSize in nxt state to reduce Req.TlbId's load - better timing
   //   for (int tlb_ps = PS_MIN; tlb_ps <= PS_MAX; tlb_ps++) begin : Fill_Eff_PS_Lp
   //      if ((tlb_ps <= TLBPipe_H[TLB_TAG_RD_CTRL].Info.Size) && (NUM_SETS[`DEVTLB_PIPE_TLBID(TLB_TAG_RD_CTRL, tlb_ps)][tlb_ps] > 0))
    //        TLBPipe_H[TLB_TAG_RD_CTRL].Info.EffSize = T_PGSIZE'(f_IOMMU_Int_2_PS(tlb_ps));
   //end
end

T_SETADDR [NUM_ARRAYS-1:0][PS_MAX:PS_MIN] TlbSetAddrBase;

always_comb begin
    TlbSetAddrBase = '0;
    for (int tlb_ps = PS_MIN; tlb_ps <= PS_MAX; tlb_ps++) begin  : TlbBase_PS_Lp
        for (int i = 0; i < NUM_ARRAYS; i++) begin : TlbBase_id_Lp1
            for (int j = 0; j < NUM_ARRAYS; j++) begin : TlbBase_id_Lp2
                if(j<i) TlbSetAddrBase[i][tlb_ps] = TlbSetAddrBase[i][tlb_ps] + T_SETADDR'(NUM_SETS[j][tlb_ps]);
            end
        end
    end
end

// Set Address calculations differ depending on the TLB/Cache
//
generate

   always_comb begin
      //SetAddr_H = '0;
      for (int tlb_ps = PS_MIN; tlb_ps <= PS_MAX; tlb_ps++) begin  : Tag_RD_Ctrl_PS_Lp

         // Calculate effective set address from TLBID offsets
         //
         // For all TLBIDs less than the target TLBID add an offset equal to the number of sets
         // to find the starting point for the TLBID being referenced
         //
        SetAddr_H[tlb_ps] = TlbSetAddrBase[`HQM_DEVTLB_PIPE_TLBID(TLB_TAG_RD_CTRL, tlb_ps)][tlb_ps];

            if (TLBPipe_H[TLB_TAG_RD_CTRL].Ctrl.InvalDTLB | TLBPipe_H[TLB_TAG_RD_CTRL].Ctrl.InvalGlb) begin
                // When targeting specific page addresses, use request address as a starting point
                if ((TLBPipe_H[TLB_TAG_RD_CTRL].Ctrl.InvalDTLB & TLBPipe_H[TLB_TAG_RD_CTRL].Req.PasidV)
                    | (!DEVTLB_PASID_SUPP_EN & TLBPipe_H[TLB_TAG_RD_CTRL].Ctrl.InvalDTLB)   //In case of InvReq & PASID_SUPP_EN & pasidV=0, SetAddr_H start at TlbSetAddrBase.
                    | (TLBPipe_H[TLB_TAG_RD_CTRL].Req.Opcode == T_OPCODE'(DEVTLB_OPCODE_UARCH_INV))) //In case of uarch inv, always lookup set pointed by the xreq addr
               begin
                    //start of sub-inv
                    SetAddr_H[tlb_ps] += T_SETADDR'((TLBPipe_H[TLB_TAG_RD_CTRL].Req.Address[GAW_LAW_MAX-1:12]
                            & ~TagMask_H[TLB_TAG_RD_CTRL][`HQM_DEVTLB_PIPE_TLBID(TLB_TAG_RD_CTRL, tlb_ps)][tlb_ps].Address[GAW_LAW_MAX-1:12]           // Mask away the non-set bits
                            &    ('1 <<  TLBPipe_H[TLB_TAG_RD_CTRL].Ctrl.InvalMaskBits ))                                         // Mask lower order bits according to mask to start in correct set
                        >> (tlb_ps*9));                                                                                    // Shift away the lower bits
                end

                SetAddr_H[tlb_ps] += TLBPipe_H[TLB_TAG_RD_CTRL].Ctrl.InvalSetAddr;  //index within sub-inv
            end else begin
         // For the target TLBIDs extract the appropriate set address bit for the specified PS
         //if (NUM_SETS[`DEVTLB_PIPE_TLBID(TLB_TAG_RD_CTRL, tlb_ps)][tlb_ps] > 1) begin                        // if there will be a valid set value
            SetAddr_H[tlb_ps] += T_SETADDR'((TLBPipe_H[TLB_TAG_RD_CTRL].Req.Address[GAW_LAW_MAX-1:12]
                            & ~TagMaskBase_H[`HQM_DEVTLB_PIPE_TLBID(TLB_TAG_RD_CTRL, tlb_ps)][tlb_ps].Address[GAW_LAW_MAX-1:12])             // Mask away the non-set bits
                           >> (tlb_ps*9));                                                         // Shift away the lower bits
          //end
   end
        end
    end

endgenerate

//=====================================================================================================================
// BDF+GPA-> HPA TAG Array Access (Stage TLB_TAG_RD_CTRL, TLB_TAG_WR_CTRL)
//=====================================================================================================================
//T_TAG_ENTRY_0 [TLB_TAG_WR_CTRL:TLB_TAG_WR_CTRL-1][NUM_ARRAYS-1:0][PS_MAX:PS_MIN]    ArrTagParityMask_H;
logic [TLB_TAG_WR_CTRL:TLB_TAG_WR_CTRL-1][PS_MAX:PS_MIN]                            ArrWrTagParity;

//Pre-calculate parity of portion of the bus to improve WrData->RF timing.
generate
for (g_ps = PS_MIN; g_ps <= PS_MAX; g_ps++) begin  : TagParity_PS_Lp 
    always_comb begin
        /*for (int tlb_id = 0; tlb_id < NUM_ARRAYS; tlb_id++) begin  : TagParity_TlbId_Lp
            ArrTagParityMask_H[TLB_TAG_WR_CTRL-1][tlb_id][g_ps]         = TagMaskBase_H[tlb_id][g_ps];
            ArrTagParityMask_H[TLB_TAG_WR_CTRL-1][tlb_id][g_ps].Parity  = '0;
            ArrTagParityMask_H[TLB_TAG_WR_CTRL-1][tlb_id][g_ps].ValidFL = '0;
            ArrTagParityMask_H[TLB_TAG_WR_CTRL-1][tlb_id][g_ps].ValidSL = '0;

            ArrTagParityMask_H[TLB_TAG_WR_CTRL][tlb_id][g_ps]           = ~ArrTagParityMask_H[TLB_TAG_WR_CTRL-1][tlb_id][g_ps];
            ArrTagParityMask_H[TLB_TAG_WR_CTRL][tlb_id][g_ps].Parity    = '0;
        end*/

        ArrWrTagNxt_H[g_ps]                = '0;             // Default all fields to 0, including ValidFL & ValidSL
        ArrWrTagNxt_H[g_ps].PASID          =  TLBPipe_H[TLB_TAG_WR_CTRL-1].Req.PASID;
        ArrWrTagNxt_H[g_ps].PR             =  TLBPipe_H[TLB_TAG_WR_CTRL-1].Req.PR;
        ArrWrTagNxt_H[g_ps].BDF            =  TLBPipe_H[TLB_TAG_WR_CTRL-1].Req.BDF;
        ArrWrTagNxt_H[g_ps].Address        =  TLBPipe_H[TLB_TAG_WR_CTRL-1].Req.Address[GAW_LAW_MAX-1:12] & ('1 << (g_ps*9));  // Mask non-releveant bits for the current page size
        ArrWrTagParity[TLB_TAG_WR_CTRL-1][g_ps] = `HQM_DEVTLB_CALC_PARITY((ArrWrTagNxt_H[g_ps] & TagMaskBase_H[`HQM_DEVTLB_PIPE_TLBID((TLB_TAG_WR_CTRL-1), g_ps)][g_ps]), ~CrParErrInj_nnnH.disable_iotlb_parityerror);
    end
end
endgenerate
`HQM_DEVTLB_RST_MSFF(ArrWrTagParity[TLB_TAG_WR_CTRL],    ArrWrTagParity[TLB_TAG_WR_CTRL-1],     ClkTLBPipe_H[TLB_TAG_WR_CTRL], reset)

logic [TLB_TAG_WR_CTRL:TLB_DATA_RD] InvDPErrEntry;
// Create one array for each combination of page size
//
generate
   // Assemble Write Data...extra bits may be written in RTL in the address fields
   // below the relevant range of bits but those bits get eliminated by synthesis in
   // the array sub-module, and again by the address match logic.

   for (g_ps = PS_MIN; g_ps <= PS_MAX; g_ps++) begin  : Tag_PS_Lp
         always_comb begin
            localparam         int SET_ADDR_WIDTH      = `HQM_DEVTLB_LOG2(NUM_PS_SETS[g_ps]);
            
            ArrWrTag_H[g_ps]              = '0;             // Default all fields to 0
            
            if (DEVTLB_PASID_SUPP_EN & TLBPipe_H[TLB_TAG_WR_CTRL].Req.PasidV)   begin
                ArrWrTag_H[g_ps].ValidFL    =  TLBPipeV_H[TLB_TAG_WR_CTRL]
                                            &  TLBPipe_H[TLB_TAG_WR_CTRL].Ctrl.Fill
                                            & ~InvDPErrEntry[TLB_TAG_WR_CTRL]
                                            & ~TLBPipe_H[TLB_TAG_WR_CTRL].Ctrl.InvalGlb              // Suppress valid bit on resets
                                            & ~TLBPipe_H[TLB_TAG_WR_CTRL].Ctrl.InvalDTLB;            // Suppress valid bit on invals
                ArrWrTag_H[g_ps].ValidSL    =  '0;
                //ArrWrTag_H[g_ps].Global     =  TLBPipe_H[TLB_TAG_WR_CTRL].Info.Global;
            end

            else  begin
                ArrWrTag_H[g_ps].ValidSL    =  TLBPipeV_H[TLB_TAG_WR_CTRL]
                                            &  TLBPipe_H[TLB_TAG_WR_CTRL].Ctrl.Fill
                                            & ~InvDPErrEntry[TLB_TAG_WR_CTRL]
                                            & ~TLBPipe_H[TLB_TAG_WR_CTRL].Ctrl.InvalGlb  // Suppress valid bit on resets
                                            & ~TLBPipe_H[TLB_TAG_WR_CTRL].Ctrl.InvalDTLB;// Suppress valid bit on invals
                ArrWrTag_H[g_ps].ValidFL    =  '0;
                //ArrWrTag_H[g_ps].Global     =  '0;
            end

            ArrWrTag_H[g_ps].PASID          =  TLBPipe_H[TLB_TAG_WR_CTRL].Req.PASID;
            ArrWrTag_H[g_ps].PR             =  TLBPipe_H[TLB_TAG_WR_CTRL].Req.PR;
            ArrWrTag_H[g_ps].BDF            =  TLBPipe_H[TLB_TAG_WR_CTRL].Req.BDF;
            ArrWrTag_H[g_ps].Address        =  TLBPipe_H[TLB_TAG_WR_CTRL].Req.Address[GAW_LAW_MAX-1:12] & ('1 << (g_ps*9));  // Mask non-releveant bits for the current page size
            
            ArrWrTag_H[g_ps].Parity       = '0;
            ArrWrTag_H[g_ps].Parity       =  `HQM_DEVTLB_CALC_PARITY({ArrWrTagParity[TLB_TAG_WR_CTRL][g_ps], ArrWrTag_H[g_ps].ValidSL, ArrWrTag_H[g_ps].ValidFL}, ~CrParErrInj_nnnH.disable_iotlb_parityerror)
                                              ^ TagParPoison_nnnH[g_ps];

            DEVTLB_Tag_RdEn_Spec[g_ps]      = TLBPipeV_H[TLB_TAG_RD_CTRL];   
            DEVTLB_Tag_RdEn[g_ps]           = TLBPipe_H[TLB_TAG_RD_CTRL].ArrCtrl[g_ps].RdEn;   
            DEVTLB_Tag_Rd_Addr[g_ps]        = `HQM_DEVTLB_ZX(TLBPipe_H[TLB_TAG_RD_CTRL].ArrCtrl[g_ps].SetAddr[SET_ADDR_WIDTH-1:0],$bits(DEVTLB_Tag_Rd_Addr[g_ps]));
            ArrRdTagInt_H[g_ps]             = DEVTLB_Tag_Rd_Data[g_ps];
            DEVTLB_Tag_WrEn[g_ps]           = TLBPipe_H[TLB_TAG_WR_CTRL].ArrCtrl[g_ps].WrEn;   
            DEVTLB_Tag_Wr_Addr[g_ps]        = `HQM_DEVTLB_ZX(TLBPipe_H[TLB_TAG_WR_CTRL].ArrCtrl[g_ps].SetAddr[SET_ADDR_WIDTH-1:0],$bits(DEVTLB_Tag_Wr_Addr[g_ps]));
            DEVTLB_Tag_Wr_Way[g_ps]         = TLBPipe_H[TLB_TAG_WR_CTRL].ArrInfo[g_ps].RepVec;
            DEVTLB_Tag_Wr_Data[g_ps]        = ArrWrTag_H[g_ps];

         end

      if (NUM_PS_SETS[g_ps] > 0) begin : Array // Instantiate array only if the arrays has entries
         localparam         int SET_ADDR_WIDTH      = `HQM_DEVTLB_LOG2(NUM_PS_SETS[g_ps]);

         // Use RF based tag read contents if RF array_style is specified
         //
         // Left shift RF value for larger PS arrays to align bits to pipeline since larger
         // page tag address fields are always smaller
         // For RCC/TTC/PASIDC, only g_ps = 0 is used so the other values are irrelevant.
         //
         // Ensure that RF-based values are the same as the internal latch array
         //
         for(g_way=0; g_way<NUM_WAYS; g_way++) begin: way0
            if (ARRAY_STYLE[g_ps] == ARRAY_RF) begin: rf_mux
               if (g_ps == 0) begin : RF_Read_0 //spyglass disable AlwaysFalseTrueCond-ML
                  assign ArrRdTag_H[g_ps][g_way] = RF_PS0_Tag_RdData[g_way];
               end
               if (g_ps == 1) begin : RF_Read_1
                  assign ArrRdTag_H[g_ps][g_way] = `HQM_DEVTLB_ZX(RF_PS1_Tag_RdData[g_way],$bits(ArrRdTag_H[g_ps][g_way])) << 9;
               end
               if (g_ps == 2) begin : RF_Read_2
                  assign ArrRdTag_H[g_ps][g_way] = `HQM_DEVTLB_ZX(RF_PS2_Tag_RdData[g_way],$bits(ArrRdTag_H[g_ps][g_way])) << 18;
               end
               if (g_ps == 3) begin : RF_Read_3
                  assign ArrRdTag_H[g_ps][g_way] = `HQM_DEVTLB_ZX(RF_PS3_Tag_RdData[g_way],$bits(ArrRdTag_H[g_ps][g_way])) << 27;
               end
               if (g_ps == 4) begin : RF_Read_4
                  assign ArrRdTag_H[g_ps][g_way] = `HQM_DEVTLB_ZX(RF_PS4_Tag_RdData[g_way],$bits(ArrRdTag_H[g_ps][g_way])) << 36;
               end
            end else begin: non_rf_mux
                  assign ArrRdTag_H[g_ps][g_way] = ArrRdTagInt_H[g_ps][g_way];
            end
         end
   
      end else begin : NO_Array
         for(g_way=0; g_way<NUM_WAYS; g_way++) begin: way1
            assign ArrRdTag_H[g_ps][g_way] = '0;
         end
      end
   end

   // Transfer internal latch array controls to RF controls
   //
   if ((PS_MIN <= 0) && (PS_MAX >= 0)) begin : RF_Tag_Drive_0 // Legal PS value
      assign RF_PS0_Tag_RdEn        = TLBPipe_H[TLB_TAG_RD_CTRL].ArrCtrl[0].RdEn;
      assign RF_PS0_Tag_RdAddr      = TLBPipe_H[TLB_TAG_RD_CTRL].ArrCtrl[0].SetAddr[`HQM_DEVTLB_LOG2(NUM_PS_SETS[0])-1:0];
      for(g_way=0; g_way<NUM_WAYS; g_way++) begin: way2
      assign RF_PS0_Tag_WrEn[g_way]  = TLBPipe_H[TLB_TAG_WR_CTRL].ArrCtrl[0].WrEn ? TLBPipe_H[TLB_TAG_WR_CTRL].ArrInfo[0].RepVec[g_way] : '0;
      end
      assign RF_PS0_Tag_WrAddr      = TLBPipe_H[TLB_TAG_WR_CTRL].ArrCtrl[0].SetAddr[`HQM_DEVTLB_LOG2(NUM_PS_SETS[0])-1:0];
      assign RF_PS0_Tag_WrData      = ArrWrTag_H[0];
   end else begin : RF_Tag_TieOff_0
      assign RF_PS0_Tag_RdEn        = '0;
      assign RF_PS0_Tag_RdAddr      = '0;
      assign RF_PS0_Tag_WrEn        = '0;
      assign RF_PS0_Tag_WrAddr      = '0;
      assign RF_PS0_Tag_WrData      = '0;
   end

   if ((PS_MIN <= 1) && (PS_MAX >= 1)) begin : RF_Tag_Drive_1 // Legal PS value
      assign RF_PS1_Tag_RdEn        = TLBPipe_H[TLB_TAG_RD_CTRL].ArrCtrl[1].RdEn;
      assign RF_PS1_Tag_RdAddr      = TLBPipe_H[TLB_TAG_RD_CTRL].ArrCtrl[1].SetAddr[`HQM_DEVTLB_LOG2(NUM_PS_SETS[1])-1:0];
      for(g_way=0; g_way<NUM_WAYS; g_way++) begin: way3
      assign RF_PS1_Tag_WrEn[g_way]  = TLBPipe_H[TLB_TAG_WR_CTRL].ArrCtrl[1].WrEn ? TLBPipe_H[TLB_TAG_WR_CTRL].ArrInfo[1].RepVec[g_way] : '0;
      end
      assign RF_PS1_Tag_WrAddr      = TLBPipe_H[TLB_TAG_WR_CTRL].ArrCtrl[1].SetAddr[`HQM_DEVTLB_LOG2(NUM_PS_SETS[1])-1:0];
      assign RF_PS1_Tag_WrData      = ArrWrTag_H[1] >> 9;
   end else begin : RF_Tag_TieOff_1
      assign RF_PS1_Tag_RdEn        = '0;
      assign RF_PS1_Tag_RdAddr      = '0;
      assign RF_PS1_Tag_WrEn        = '0;
      assign RF_PS1_Tag_WrAddr      = '0;
      assign RF_PS1_Tag_WrData      = '0;
   end

   if ((PS_MIN <= 2) && (PS_MAX >= 2)) begin : RF_Tag_Drive_2 // Legal PS value
      assign RF_PS2_Tag_RdEn        = TLBPipe_H[TLB_TAG_RD_CTRL].ArrCtrl[2].RdEn;
      assign RF_PS2_Tag_RdAddr      = TLBPipe_H[TLB_TAG_RD_CTRL].ArrCtrl[2].SetAddr[`HQM_DEVTLB_LOG2(NUM_PS_SETS[2])-1:0];
      for(g_way=0; g_way<NUM_WAYS; g_way++) begin: way4
      assign RF_PS2_Tag_WrEn[g_way]  = TLBPipe_H[TLB_TAG_WR_CTRL].ArrCtrl[2].WrEn ? TLBPipe_H[TLB_TAG_WR_CTRL].ArrInfo[2].RepVec[g_way] : '0;
      end
      assign RF_PS2_Tag_WrAddr      = TLBPipe_H[TLB_TAG_WR_CTRL].ArrCtrl[2].SetAddr[`HQM_DEVTLB_LOG2(NUM_PS_SETS[2])-1:0];
      assign RF_PS2_Tag_WrData      = ArrWrTag_H[2] >> 18;
   end else begin : RF_Tag_TieOff_2
      assign RF_PS2_Tag_RdEn        = '0;
      assign RF_PS2_Tag_RdAddr      = '0;
      assign RF_PS2_Tag_WrEn        = '0;
      assign RF_PS2_Tag_WrAddr      = '0;
      assign RF_PS2_Tag_WrData      = '0;
   end

   if ((PS_MIN <= 3) && (PS_MAX >= 3)) begin : RF_Tag_Drive_3 // Legal PS value
      assign RF_PS3_Tag_RdEn        = TLBPipe_H[TLB_TAG_RD_CTRL].ArrCtrl[3].RdEn;
      assign RF_PS3_Tag_RdAddr      = TLBPipe_H[TLB_TAG_RD_CTRL].ArrCtrl[3].SetAddr[`HQM_DEVTLB_LOG2(NUM_PS_SETS[3])-1:0];
      for(g_way=0; g_way<NUM_WAYS; g_way++) begin: way5
      assign RF_PS3_Tag_WrEn[g_way]  = TLBPipe_H[TLB_TAG_WR_CTRL].ArrCtrl[3].WrEn ? TLBPipe_H[TLB_TAG_WR_CTRL].ArrInfo[3].RepVec[g_way] : '0;
   end
      assign RF_PS3_Tag_WrAddr      = TLBPipe_H[TLB_TAG_WR_CTRL].ArrCtrl[3].SetAddr[`HQM_DEVTLB_LOG2(NUM_PS_SETS[3])-1:0];
      assign RF_PS3_Tag_WrData      = ArrWrTag_H[3] >> 27;
   end else begin : RF_Tag_TieOff_3
      assign RF_PS3_Tag_RdEn        = '0;
      assign RF_PS3_Tag_RdAddr      = '0;
      assign RF_PS3_Tag_WrEn        = '0;
      assign RF_PS3_Tag_WrAddr      = '0;
      assign RF_PS3_Tag_WrData      = '0;
   end

   if ((PS_MIN <= 4) && (PS_MAX >= 4)) begin : RF_Tag_Drive_4 // Legal PS value
      assign RF_PS4_Tag_RdEn        = TLBPipe_H[TLB_TAG_RD_CTRL].ArrCtrl[4].RdEn;
      assign RF_PS4_Tag_RdAddr      = TLBPipe_H[TLB_TAG_RD_CTRL].ArrCtrl[4].SetAddr[`HQM_DEVTLB_LOG2(NUM_PS_SETS[4])-1:0];
      for(g_way=0; g_way<NUM_WAYS; g_way++) begin: way6
      assign RF_PS4_Tag_WrEn[g_way]  = TLBPipe_H[TLB_TAG_WR_CTRL].ArrCtrl[4].WrEn ? TLBPipe_H[TLB_TAG_WR_CTRL].ArrInfo[4].RepVec[g_way] : '0;
      end
      assign RF_PS4_Tag_WrAddr      = TLBPipe_H[TLB_TAG_WR_CTRL].ArrCtrl[4].SetAddr[`HQM_DEVTLB_LOG2(NUM_PS_SETS[4])-1:0];
      assign RF_PS4_Tag_WrData      = ArrWrTag_H[4] >> 36;
   end else begin : RF_Tag_TieOff_4
      assign RF_PS4_Tag_RdEn        = '0;
      assign RF_PS4_Tag_RdAddr      = '0;
      assign RF_PS4_Tag_WrEn        = '0;
      assign RF_PS4_Tag_WrAddr      = '0;
      assign RF_PS4_Tag_WrData      = '0;
   end

endgenerate

//=====================================================================================================================
// BDF+GPA-> HPA TAG Hit/Miss Logic (Stage 102)
//=====================================================================================================================

// Create a mask to ignore bits of the tag that shouldn't be compared for invalidations
//   IOTLB and PWC share the same masking (IOTLB has a Function Mask set by TagMaskBase_H)
//
generate
   always_comb begin

      TagMaskBase_H  = '1;

      // For normal lookups...
      //
      // Calculate mask for each id/ps where id only matters for the set address masking in the tag
      for (int tlb_id = 0; tlb_id < NUM_ARRAYS; tlb_id++) begin  : Mask_id
         for (int tlb_ps = PS_MIN; tlb_ps <= PS_MAX; tlb_ps++) begin  : Mask_ps
            TagMaskBase_H[tlb_id][tlb_ps].Parity = '0;   // Mask parity field only for convenience for use in assertions

            // PageSize Masking
            //
            // All bits are used for the 4k TLB (tlb_ps = 0)
            // All bits except the lower 9 are used for the 2m TLB (tlb_ps = 1)
            // All bits except the lower 18 are used for the 1g TLB (tlb_ps = 2)
            // All bits except the lower 27 are used for the .5t TLB (tlb_ps = 3)
            //
            TagMaskBase_H[tlb_id][tlb_ps].Address  = '1 << (tlb_ps*9);

            // Do not compare bits implied by the set address. This is only needed where there are 2 or
            // more sets where the address bits are used to index the array.
            //
            // This should make synthesis drop those bits from the arrays...saving area, power, and improving timing
            //
            if (NUM_SETS[tlb_id][tlb_ps] > 1) begin    // if there bits implied by the set address
               TagMaskBase_H[tlb_id][tlb_ps].Address &= '1 << (`HQM_DEVTLB_TLB_SET_MSB(NUM_SETS,tlb_id,tlb_ps) - 12 + 1);
            end
         end
      end
   end
   
   always_comb begin
      for (int pipe_stage = TLB_PIPE_START; pipe_stage <= TLB_TAG_RD; pipe_stage++) begin : Pipe_stage
         for (int tlb_id = 0; tlb_id < NUM_ARRAYS; tlb_id++) begin  : Mask_id
            for (int tlb_ps = PS_MIN; tlb_ps <= PS_MAX; tlb_ps++) begin  : Mask_ps
               // Save a copy to use in writing the array to prevent the DFX mux from causing synthesis to keep unnecessary bits
               TagMask_H[pipe_stage][tlb_id][tlb_ps] = TagMaskBase_H[tlb_id][tlb_ps];
   
               // Invalidation AddressMask generation for the IOTLB and PWC Page Selective Invalidations
               //
               // For page invalidations, mask the number of bits specified by the invalidation.
               // This may lead to a large page entry also being invalidated when the
               // reqeust address bits below the normal tag range are all 0's (this
               // will match the 0's always output by the array for those page size tlbs.
               //
               if (TLBPipe_H[pipe_stage].Ctrl.InvalDTLB) //this includes uarch inv
                  TagMask_H[pipe_stage][tlb_id][tlb_ps].Address = TagMaskBase_H[tlb_id][tlb_ps].Address & ('1 << TLBPipe_H[pipe_stage].Ctrl.InvalMaskBits);
                  TagMask_H[pipe_stage][tlb_id][tlb_ps].BDF = TLBPipe_H[pipe_stage].Ctrl.InvalBdfMask? '0: '1;
            end
         end
      end
   end


   always_comb begin
      for (int tlb_ps = PS_MIN; tlb_ps <= PS_MAX; tlb_ps++) begin  : Tag_Hit_Lp
         for (int way = 0; way < NUM_WAYS; way++) begin
            
            if (TLBPipe_H[TLB_TAG_RD].Ctrl.InvalGlb
                  | TLBPipe_H[TLB_TAG_RD].Ctrl.InvalDTLB)  begin

               ArrayEntryValid[tlb_ps][way]   = DEVTLB_PASID_SUPP_EN
                                                ? (ArrRdTag_H[tlb_ps][way].ValidSL |  ArrRdTag_H[tlb_ps][way].ValidFL)
                                                : (ArrRdTag_H[tlb_ps][way].ValidSL);

            end

            else  begin
               ArrayEntryValid[tlb_ps][way]   = DEVTLB_PASID_SUPP_EN
                                    ? (TLBPipe_H[TLB_TAG_RD].Req.PasidV
                                          ?  ArrRdTag_H[tlb_ps][way].ValidFL 
                                          : (ArrRdTag_H[tlb_ps][way].ValidSL &  ~ArrRdTag_H[tlb_ps][way].ValidFL))
                                    : ArrRdTag_H[tlb_ps][way].ValidSL;
            end
               
            // The IOTLB is tagged with BDF while the non-leaf caches are tagged with DID
            //
            BDFMatch[tlb_ps][way]
                  =  ArrayEntryValid[tlb_ps][way] 
                     & ((ArrRdTag_H[tlb_ps][way].BDF & TagMask_H[TLB_TAG_RD][`HQM_DEVTLB_PIPE_TLBID(TLB_TAG_RD, tlb_ps)][tlb_ps].BDF)
                         == (TLBPipe_H[TLB_TAG_RD].Req.BDF & TagMask_H[TLB_TAG_RD][`HQM_DEVTLB_PIPE_TLBID(TLB_TAG_RD, tlb_ps)][tlb_ps].BDF));
                         // TagMask_H....Function is all 1's except for device delective invalidations for the RCC

            // Address Match for TLB lookups for normal reads or replacements or for page selective invalidations
            // (mask the bits that need not be matched for the current page size or specified invalidation range
            //
            AddrMatch[tlb_ps][way]
                  =  ArrayEntryValid[tlb_ps][way] 
                  &  ((ArrRdTag_H[tlb_ps][way].Address[GAW_LAW_MAX-1:12]     & TagMask_H[TLB_TAG_RD][`HQM_DEVTLB_PIPE_TLBID(TLB_TAG_RD, tlb_ps)][tlb_ps].Address)
                     == (TLBPipe_H[TLB_TAG_RD].Req.Address[GAW_LAW_MAX-1:12] & TagMask_H[TLB_TAG_RD][`HQM_DEVTLB_PIPE_TLBID(TLB_TAG_RD, tlb_ps)][tlb_ps].Address));

            // We need to compare all bits for SL entries including the set since invalidation engine accesses every set for InvalPage.
            // It needs to clear all FL entries across all sets but should only affect an SL entry in the specific set(s)
            // as determined by the invalidation request address and address mask bits.
            
            // Extract Set Address Bits from Req.Address
            SLSetAddr[tlb_ps]      =  16'((TLBPipe_H[TLB_TAG_RD].Req.Address[MAX_GUEST_ADDRESS_WIDTH-1:12] & ~TagMaskBase_H[`HQM_DEVTLB_PIPE_TLBID(TLB_TAG_RD, tlb_ps)][tlb_ps].Address) >> (tlb_ps*9));
            // Mask additional bits if needed based on Inval Mask
            // Adjust for page size. ps=1 (2M) should match only if am bit/Inval Mask bit is greater than 9 and so on
            InvalMasKBits_PS[tlb_ps] = (TLBPipe_H[TLB_TAG_RD].Ctrl.InvalMaskBits < 6'(tlb_ps[2:0]*4'd9)) ? 6'(tlb_ps[2:0]*4'd9) : TLBPipe_H[TLB_TAG_RD].Ctrl.InvalMaskBits;  //lintra s-2049
            
            SLSetInvalMask         =  ('1 <<  (InvalMasKBits_PS[tlb_ps]-6'(tlb_ps[2:0]*4'd9) ));  //lintra s-2049
            SLSetMatch[tlb_ps][way]
                  =   (     (SLSetAddr[tlb_ps]                       & 16'(SLSetInvalMask))
                        ==  (TLBPipe_H[TLB_TAG_RD].Ctrl.InvalSetAddr & 16'(SLSetInvalMask))); 




             // PASID match for
            // PASID match for TLB lookups with PASID enabled
            //
            if (DEVTLB_PASID_SUPP_EN & TLBPipe_H[TLB_TAG_RD].Req.PasidV) begin
               PRMatch[tlb_ps][way] 
                  = (ArrayEntryValid[tlb_ps][way] 
                        &  (
                              (ArrRdTag_H[tlb_ps][way].ValidFL    &  TLBPipe_H[TLB_TAG_RD].Req.PasidV)   ?
                              (ArrRdTag_H[tlb_ps][way].PR         == TLBPipe_H[TLB_TAG_RD].Req.PR)    :
                              (~ArrRdTag_H[tlb_ps][way].ValidFL   &  ~TLBPipe_H[TLB_TAG_RD].Req.PasidV)
                           ));
               
               PASIDMatch[tlb_ps][way] 
                  = (ArrayEntryValid[tlb_ps][way] 
                        &  (
                              (ArrRdTag_H[tlb_ps][way].ValidFL    &  TLBPipe_H[TLB_TAG_RD].Req.PasidV)   ?
                              (ArrRdTag_H[tlb_ps][way].PASID      == TLBPipe_H[TLB_TAG_RD].Req.PASID)    :
                              (~ArrRdTag_H[tlb_ps][way].ValidFL   &  ~TLBPipe_H[TLB_TAG_RD].Req.PasidV)
                           )); // Glob bit is not here, as we are not supporting caching of Global Pasid entry 
            end else begin
               PASIDMatch[tlb_ps][way]  = '1;
               PRMatch[tlb_ps][way]     = '1;
            end
         end
      end
   end

endgenerate

generate
   for (g_ps = PS_MIN; g_ps <= PS_MAX; g_ps++) begin  : Tag_Hit_Lp
      for (g_way = 0; g_way < NUM_WAYS; g_way++) begin : Tag_Hit_Lp1
            assign   TempArrayValidBit[g_ps][g_way]   =  ArrRdTag_H[g_ps][g_way].ValidSL     |  (DEVTLB_PASID_SUPP_EN & ArrRdTag_H[g_ps][g_way].ValidFL);
      end
   end
endgenerate

generate
for (g_ps = PS_MIN; g_ps <= PS_MAX; g_ps++) begin  : Match_PS
   for(g_way=0; g_way<NUM_WAYS; g_way++) begin: Match_Way
         assign FullMatch[g_ps][g_way]
               = TLBPipeV_H[TLB_TAG_RD]                                    // request is valid
               & TLBPipe_H[TLB_TAG_RD].ArrCtrl[g_ps].RdEn                  // Match only if Read
               & (
                  // Normal Tag Matches
         //
                  (    ~TLBPipe_H[TLB_TAG_RD].Ctrl.InvalDTLB               // Page-Selective invalidation...suppress normal hits on invalidation operations
                     & BDFMatch[g_ps][g_way]                               // entry matches BDF
                     & AddrMatch[g_ps][g_way]                              // entry matches Address
                     & PASIDMatch[g_ps][g_way]                             // entry matches pasid
                     & PRMatch[g_ps][g_way]                                // entry matches pr
                  )

                  // Invalidation Tag Matches
                 |(    TLBPipe_H[TLB_TAG_RD].Ctrl.InvalDTLB                // Page-Selective invalidation
                     & TLBPipe_H[TLB_TAG_RD].Req.PasidV
                     & ArrRdTag_H[g_ps][g_way].ValidFL                     // All FL entries are to be invalidated on a SL page invalidation
                     & DEVTLB_PASID_SUPP_EN                                // Aids synthesis in eliminating use of ValidFL
                     & (~TLBPipe_H[TLB_TAG_RD].Ctrl.CtrlFlg.InvAOR)        // InvReq Address is good
                     & AddrMatch[g_ps][g_way]                              // entry matches Address
                     & BDFMatch[g_ps][g_way]                               // entry matches BDF
                     & (PASIDMatch[g_ps][g_way] | TLBPipe_H[TLB_TAG_RD].Ctrl.GL)                             // entry matches pasid
                  )
                 |(    TLBPipe_H[TLB_TAG_RD].Ctrl.InvalDTLB                // Page-Selective invalidation
                     & (~(TLBPipe_H[TLB_TAG_RD].Req.Opcode == T_OPCODE'(DEVTLB_OPCODE_UARCH_INV))) // no XEvict
                     & ~TLBPipe_H[TLB_TAG_RD].Req.PasidV
                     & ArrRdTag_H[g_ps][g_way].ValidFL                     // Invalidate SL entries on InvalDTLB
                     & BDFMatch[g_ps][g_way]                               // entry matches BDF
                     & DEVTLB_PASID_SUPP_EN                                // Aids synthesis in eliminating use of ValidFL
                  )
                 |(    TLBPipe_H[TLB_TAG_RD].Ctrl.InvalDTLB                // Page-Selective invalidation
                     & ~TLBPipe_H[TLB_TAG_RD].Req.PasidV
                     & ArrRdTag_H[g_ps][g_way].ValidSL                     // Invalidate SL entries on InvalDTLB
                     & BDFMatch[g_ps][g_way]                               // entry matches BDF
                     & (~TLBPipe_H[TLB_TAG_RD].Ctrl.CtrlFlg.InvAOR)        // InvReq Address is good
                     & AddrMatch[g_ps][g_way]                              // Use Address Match
                     & (SLSetMatch[g_ps][g_way] |                          // all set are scanned in case of Invreq wihtout pasid TLP
                        (!DEVTLB_PASID_SUPP_EN) |
                        (TLBPipe_H[TLB_TAG_RD].Req.Opcode == T_OPCODE'(DEVTLB_OPCODE_UARCH_INV))) // no scanning for xevict
                  )
               );
      end
      end
endgenerate

logic [PS_MAX:PS_MIN] LRURdWrConflict;
always_comb begin
   
   for (int rd_stage = 1; rd_stage <= READ_LATENCY; rd_stage++)   begin : Rd_Latency
      TLBPipe_H[TLB_TAG_RD-(READ_LATENCY - rd_stage)]   =  ff_TLBPipe_H[TLB_TAG_RD-(READ_LATENCY - rd_stage)];
   end
   
   // FRACTURING for only the IOTLB and only for DMA requests
   //
   // Find largest PageSize TLB array that is equal to or smaller than the calculated pagesize.
   // This fractures large pages down to the first available TLB that can represent the page.
   // This is done in devtlb_mstrk, commented out here.
   //for (int tlb_ps = PS_MIN; tlb_ps <= PS_MAX; tlb_ps++) begin : Fill_Eff_PS_Lp
   //     if ((tlb_ps <= TLBPipe_H[TLB_TAG_RD].Info.Size) && (NUM_SETS[`DEVTLB_PIPE_TLBID(TLB_TAG_RD, tlb_ps)][tlb_ps] > 0))
   //        TLBPipe_H[TLB_TAG_RD].Info.EffSize = T_PGSIZE'(f_IOMMU_Int_2_PS(tlb_ps));
   //end

   // Tag Read Processing
   //
   for (int tlb_ps = PS_MIN; tlb_ps <= PS_MAX; tlb_ps++) begin  : Tag_Hit_Lp

      // NOTE: Might want to push the following lines to 103 for timing????
      //
      // Do the Tags Match?
      //
      for (int way = 0; way < NUM_WAYS; way++) begin

         // Copy read data into temporary structure and substitute request elements that are always used in all tag matches.
         // This works since Fullmatch will ensure they are the same and it will always yield the same parity info in a potential hit.
         // This only works if it is a DMA lookup, not Inval, where address mask is different
         // This allows for better circuit timing since most of the parity calculation can be done before the array is even read.
         ArrRdTagP_H[tlb_ps][way]            = ArrRdTag_H[tlb_ps][way];
         ArrRdTagP_H[tlb_ps][way].BDF        = TLBPipe_H[TLB_TAG_RD].Req.BDF;
         ArrRdTagP_H[tlb_ps][way].Address[GAW_LAW_MAX-1:12]    = TLBPipe_H[TLB_TAG_RD].Req.Address[GAW_LAW_MAX-1:12] & TagMask_H[TLB_TAG_RD][`HQM_DEVTLB_PIPE_TLBID(TLB_TAG_RD, tlb_ps)][tlb_ps].Address[GAW_LAW_MAX-1:12];
         ArrRdTagP_H[tlb_ps][way].Parity     = '0;

         // The request matches all elements of a valid entry
         //
         // If tag matches and expected parity matches stored parity, then parity of tag is clean
         //
         TLBPipe_H[TLB_TAG_RD].ArrInfo[tlb_ps].HitVec[way]
                                 =  FullMatch[tlb_ps][way]
                                 & (`HQM_DEVTLB_PARITY_CHECK(ArrRdTag_H[tlb_ps][way].Parity, ArrRdTagP_H[tlb_ps][way], ~CrParErrInj_nnnH.disable_iotlb_parityerror)   // Parity calculated equals stored parity
                                    | TLBPipe_H[TLB_TAG_RD].Ctrl.InvalDTLB       // Force parity match on invalidations
                                    | TLBPipe_H[TLB_TAG_RD].Ctrl.Fill       // Force parity match on Fill
                                    ); // hkhor: inval & fill:if not fullmatch & tag perr, leave that entry, next lookup will miss, the entry stay there until LRU eviction.
                                    //hkhor: inval & fill: if tagperr, replace the match way.

         TLBPipe_H[TLB_TAG_RD].ArrInfo[tlb_ps].TagParErr[way]
                                 =  FullMatch[tlb_ps][way]
                                 & ~(`HQM_DEVTLB_PARITY_CHECK(ArrRdTag_H[tlb_ps][way].Parity, ArrRdTagP_H[tlb_ps][way], ~CrParErrInj_nnnH.disable_iotlb_parityerror)   // Parity calculated equals stored parity
                                    );     

         TLBPipe_H[TLB_TAG_RD].ArrInfo[tlb_ps].ValVec[way]  =  TLBPipeV_H[TLB_TAG_RD]  &  TempArrayValidBit[tlb_ps][way];
      end
      // Accumulate Final Hit, Per Page Size
      //
      TLBPipe_H[TLB_TAG_RD].ArrInfo[tlb_ps].Hit    = |TLBPipe_H[TLB_TAG_RD].ArrInfo[tlb_ps].HitVec;

      // Put LRU result into pipeline to be used if needed in the Tag-Write stage later
      //
      // If ways are defeatured, force the ValVec to artificially indicate that the upper ways are already valid for the
      // purposes of way replacment selection.
      //
      if (`HQM_DEVTLB_PIPE_TLBID(TLB_TAG_RD, tlb_ps) < NUM_ARRAYS) begin  //spyglass disable W362a //lintra s-W362a
         for (int way = 0; way < NUM_WAYS; way++) begin  // Way 0 is unchanged...only disabled with 'b11 value which
                                                         // is handled by suppressing the WrEn signal directly
            if ((Disable_Ways[`HQM_DEVTLB_PIPE_TLBID(TLB_TAG_RD, tlb_ps)][tlb_ps] == 2'b01) & ((way * 4) >= (NUM_WAYS * 3)))
                     TLBPipe_H[TLB_TAG_RD].ArrInfo[tlb_ps].ValVec[way] = 1'b1;
            if ((Disable_Ways[`HQM_DEVTLB_PIPE_TLBID(TLB_TAG_RD, tlb_ps)][tlb_ps] == 2'b10) & ((way * 2) >= (NUM_WAYS    )))
                     TLBPipe_H[TLB_TAG_RD].ArrInfo[tlb_ps].ValVec[way] = 1'b1;
         end
      end

      priority casez (1'b1)
         ~&(TLBPipe_H[TLB_TAG_RD].ArrInfo[tlb_ps].ValVec)   : TempRepVec[TLB_TAG_RD][tlb_ps] = f_FindFirstWay(~(TLBPipe_H[TLB_TAG_RD].ArrInfo[tlb_ps].ValVec));
         default                                            : TempRepVec[TLB_TAG_RD][tlb_ps] = ArrRdLRUWayVec_H[tlb_ps];
      endcase

   // Way Replacement Selection
   //
   // If reset, write all ways, else find first invalid way, else use lru
   //
      /*FillRdStaleLRU[TLB_TAG_RD][tlb_ps] = TLBPipeV_H[TLB_TAG_RD] && TLBPipe_H[TLB_TAG_RD].Ctrl.Fill &&
                                            ~TLBPipe_H[TLB_TAG_RD].ArrInfo[tlb_ps].Hit &&
                                            (|ArrRdLRUWayVec_H[tlb_ps][NUM_WAYS/2-1:0] == 
                                             |TLBPipe_H[TLB_TAG_RD+1].ArrInfo[tlb_ps].RepVec[NUM_WAYS/2-1:0]) && 
                                            TLBPipe_H[TLB_TAG_RD+1].ArrCtrl[tlb_ps].LRUWrEn &&
                                            (TLBPipe_H[TLB_TAG_RD].ArrCtrl[tlb_ps].SetAddr[`HQM_DEVTLB_LOG2(NUM_PS_SETS[tlb_ps])-1:0] == TLBPipe_H[TLB_TAG_RD+1].ArrCtrl[tlb_ps].SetAddr[`HQM_DEVTLB_LOG2(NUM_PS_SETS[tlb_ps])-1:0]);*/
        LRURdWrConflict[tlb_ps] = LRU_STYLE? 
                         (ArrRdLRUWayVec_H[tlb_ps][NUM_WAYS-1:0] == 
                          TLBPipe_H[TLB_TAG_RD+1].ArrInfo[tlb_ps].HitVec[NUM_WAYS-1:0]):
                         (|ArrRdLRUWayVec_H[tlb_ps][NUM_WAYS/2-1:0] == 
                          |TLBPipe_H[TLB_TAG_RD+1].ArrInfo[tlb_ps].HitVec[NUM_WAYS/2-1:0]);

        FillRdStaleLRU[TLB_TAG_RD][tlb_ps] = TLBPipeV_H[TLB_TAG_RD] && TLBPipe_H[TLB_TAG_RD].Ctrl.Fill &&
                                            (~TLBPipe_H[TLB_TAG_RD].ArrInfo[tlb_ps].Hit) &&
                                            (&TLBPipe_H[TLB_TAG_RD].ArrInfo[tlb_ps].ValVec) &&
                                            LRURdWrConflict[tlb_ps] &&
                                            TLBPipe_H[TLB_TAG_RD+1].ArrCtrl[tlb_ps].LRUWrEn &&  //TODO assert TLB_LRU_WR_CTRL<=TLB_TAG_RD+1
                                            (TLBPipe_H[TLB_TAG_RD].ArrCtrl[tlb_ps].SetAddr[15:0] == TLBPipe_H[TLB_TAG_RD+1].ArrCtrl[tlb_ps].SetAddr[15:0]);
      priority casez (1'b1)

         ~TLBPipeV_H[TLB_TAG_RD]                         : TLBPipe_H[TLB_TAG_RD].ArrInfo[tlb_ps].RepVec = '1;

         TLBPipe_H[TLB_TAG_RD].Ctrl.InvalGlb,
         (TLBPipe_H[TLB_TAG_RD].Ctrl.InvalDTLB & DisPartInv_nnnH),
         (TLBPipe_H[TLB_TAG_RD].Ctrl.InvalDTLB & (TLBPipe_H[TLB_TAG_RD].Info.am == 6'b111111) & (&(TLBPipe_H[TLB_TAG_RD].Req.Address))):               // Global Invalidate / Reset
                              TLBPipe_H[TLB_TAG_RD].ArrInfo[tlb_ps].RepVec
                                                = {NUM_WAYS{1'b1}};

         TLBPipe_H[TLB_TAG_RD].Ctrl.InvalDTLB            :               // Page Selective Invalidate
                              TLBPipe_H[TLB_TAG_RD].ArrInfo[tlb_ps].RepVec
                                                = TLBPipe_H[TLB_TAG_RD].ArrInfo[tlb_ps].HitVec;

         TLBPipe_H[TLB_TAG_RD].ArrInfo[tlb_ps].Hit
         & TLBPipe_H[TLB_TAG_RD].Ctrl.Fill               :               // Update existing TLB contents with newly provided values
                              TLBPipe_H[TLB_TAG_RD].ArrInfo[tlb_ps].RepVec
                                                = TLBPipe_H[TLB_TAG_RD].ArrInfo[tlb_ps].HitVec;

         FillRdStaleLRU[TLB_TAG_RD][tlb_ps]            : 
                              TLBPipe_H[TLB_TAG_RD].ArrInfo[tlb_ps].RepVec = ArrRdLRUWay2ndVec_H[tlb_ps];
         default: 
            TLBPipe_H[TLB_TAG_RD].ArrInfo[tlb_ps].RepVec = TempRepVec[TLB_TAG_RD][tlb_ps];// ValVec based replacements come from an earlier point in the pipeline
      endcase
      
   end

   // Data Read Control
   //
   for (int tlb_ps = PS_MIN; tlb_ps <= PS_MAX; tlb_ps++) begin  : Data_Rd_Ctrl_PS_Lp
      if (NUM_PS_SETS[tlb_ps] > 0) begin    // read only if the arrays has entries

         TLBPipe_H[TLB_DATA_RD_CTRL].ArrCtrl[tlb_ps].RdEn &=    TLBPipeV_H[TLB_DATA_RD_CTRL] // Forwarded from tag read and still valid
                                                             & ~TLBPipe_H[TLB_DATA_RD_CTRL].Ctrl.InvalGlb;

      end
   end
end


//=====================================================================================================================
// Address Cache (DID/GPA -> HPA) DATA Array Access (Stage 102-103)
//=====================================================================================================================

      // Assemble Write Data
generate

   for (g_ps = PS_MIN; g_ps <= PS_MAX; g_ps++) begin  : Data_PS_Lp
         // The IOTLB data entries point to the base of a page that page size aligned. 2M entries only need down to bit 21. 1G, 30.
         //
         always_comb begin
             
            localparam         int SET_ADDR_WIDTH      = `HQM_DEVTLB_LOG2(NUM_PS_SETS[g_ps]);

            ArrWrData_H[g_ps]                = '0;
            ArrWrData_H[g_ps].U              = TLBPipe_H[TLB_DATA_WR_CTRL].Info.U;  
            ArrWrData_H[g_ps].N              = TLBPipe_H[TLB_DATA_WR_CTRL].Info.N;              
            ArrWrData_H[g_ps].R              = TLBPipe_H[TLB_DATA_WR_CTRL].Info.R;
            ArrWrData_H[g_ps].W              = TLBPipe_H[TLB_DATA_WR_CTRL].Info.W;
            ArrWrData_H[g_ps].Priv_Data      = TLBPipe_H[TLB_DATA_WR_CTRL].Info.Priv_Data;
            ArrWrData_H[g_ps].Address        = TLBPipe_H[TLB_DATA_WR_CTRL].Info.Address & ('1 << (g_ps*9));
                                                     // Mask non-releveant bits for the current page size

            if (DEVTLB_PASID_SUPP_EN) begin
               if (ARSP_X_SUPP) ArrWrData_H[g_ps].X              = TLBPipe_H[TLB_DATA_WR_CTRL].Info.X;                 
               
               if (DEVTLB_MEMTYPE_EN) begin : Memtype 
                  ArrWrData_H[g_ps].Memtype        = TLBPipe_H[TLB_DATA_WR_CTRL].Info.Memtype;
               end
            end

            // Calculate parity on all previously assigned bits
            // Assigning parity last with entire stucture will pick up all other bits
            ArrWrData_H[g_ps].Parity         = '0;
            ArrWrData_H[g_ps].Parity         = (TLBPipe_H[TLB_DATA_WR_CTRL].Info.ParityError || DataParPoison_nnnH[g_ps]) ^
                                               `HQM_DEVTLB_CALC_PARITY(ArrWrData_H[g_ps], ~CrParErrInj_nnnH.disable_iotlb_parityerror);
            
            DEVTLB_Data_RdEn_Spec[g_ps]      = TLBPipeV_H[TLB_DATA_RD_CTRL];   
            DEVTLB_Data_RdEn[g_ps]           = TLBPipe_H[TLB_DATA_RD_CTRL].ArrCtrl[g_ps].RdEn;   
            DEVTLB_Data_Rd_Addr[g_ps]        = `HQM_DEVTLB_ZX(TLBPipe_H[TLB_DATA_RD_CTRL].ArrCtrl[g_ps].SetAddr[SET_ADDR_WIDTH-1:0],$bits(DEVTLB_Data_Rd_Addr[g_ps]));
            ArrRdDataInt_H[g_ps]             = DEVTLB_Data_Rd_Data[g_ps];
            DEVTLB_Data_WrEn[g_ps]           = TLBPipe_H[TLB_DATA_WR_CTRL].ArrCtrl[g_ps].ArrWrEn;   
            DEVTLB_Data_Wr_Addr[g_ps]        = `HQM_DEVTLB_ZX(TLBPipe_H[TLB_DATA_WR_CTRL].ArrCtrl[g_ps].SetAddr[SET_ADDR_WIDTH-1:0],$bits(DEVTLB_Data_Wr_Addr[g_ps]));
            DEVTLB_Data_Wr_Way[g_ps]         = TLBPipe_H[TLB_DATA_WR_CTRL].ArrInfo[g_ps].RepVec;
            DEVTLB_Data_Wr_Data[g_ps]        = ArrWrData_H[g_ps];
            
         end


      if (NUM_PS_SETS[g_ps] > 0) begin : Array    // Instantiate array only if the arrays has entries

         localparam         int SET_ADDR_WIDTH      = `HQM_DEVTLB_LOG2(NUM_PS_SETS[g_ps]);

         // Use RF based tag read contents if RF array_style is specified
         //
         // Left shift RF value for larger PS arrays, but only for IOTLB instances, to align bits to pipeline since larger
         // page data fields are always smaller for the IOTLB.
         // For the PWC, the higher level data entries are still full width (page table base pointers).
         // For RCC/TTC/PASIDC, only g_ps = 0 is used so the other values are irrelevant.
         //
         for(g_way=0; g_way<NUM_WAYS; g_way++) begin: way5
            if (ARRAY_STYLE[g_ps] == ARRAY_RF) begin: rf_mux
               if (g_ps == 0) begin : RF_PS_0 //spyglass disable AlwaysFalseTrueCond-ML
                  assign ArrRdData_H[g_ps][g_way] = RF_PS0_Data_RdData[g_way];
               end
               if (g_ps == 1) begin : RF_PS_1
                  assign ArrRdData_H[g_ps][g_way] = `HQM_DEVTLB_ZX(RF_PS1_Data_RdData[g_way],$bits(ArrRdData_H[g_ps][g_way])) << (9);
               end
               if (g_ps == 2) begin : RF_PS_2
                  assign ArrRdData_H[g_ps][g_way] = `HQM_DEVTLB_ZX(RF_PS2_Data_RdData[g_way],$bits(ArrRdData_H[g_ps][g_way])) << (18);
               end
               if (g_ps == 3) begin : RF_PS_3
                  assign ArrRdData_H[g_ps][g_way] = `HQM_DEVTLB_ZX(RF_PS3_Data_RdData[g_way],$bits(ArrRdData_H[g_ps][g_way])) << (27);
               end
               if (g_ps == 4) begin : RF_PS_4
                  assign ArrRdData_H[g_ps][g_way] = `HQM_DEVTLB_ZX(RF_PS4_Data_RdData[g_way],$bits(ArrRdData_H[g_ps][g_way])) << (36);
               end
            end 
            else begin : NON_RF
                  assign ArrRdData_H[g_ps][g_way] = ArrRdDataInt_H[g_ps][g_way];
            end
         end

      end else begin: non_rf_mux
         for(g_way=0; g_way<NUM_WAYS; g_way++) begin: way6
            assign ArrRdData_H[g_ps][g_way] = '0;
         end
      end

   end

   // Transfer internal latch array controls to RF controls
   //
   if ((PS_MIN <= 0) && (PS_MAX >= 0)) begin : RF_Data_Drive_0 // Legal PS value
      assign RF_PS0_Data_RdEn        = TLBPipe_H[TLB_DATA_RD_CTRL].ArrCtrl[0].RdEn;
      assign RF_PS0_Data_RdAddr      = TLBPipe_H[TLB_DATA_RD_CTRL].ArrCtrl[0].SetAddr[`HQM_DEVTLB_LOG2(NUM_PS_SETS[0])-1:0];
      for(g_way=0; g_way<NUM_WAYS; g_way++) begin: way7
      assign RF_PS0_Data_WrEn[g_way]  = TLBPipe_H[TLB_DATA_WR_CTRL].ArrCtrl[0].ArrWrEn ? TLBPipe_H[TLB_DATA_WR_CTRL].ArrInfo[0].RepVec[g_way] : '0;
      end
      assign RF_PS0_Data_WrAddr      = TLBPipe_H[TLB_DATA_WR_CTRL].ArrCtrl[0].SetAddr[`HQM_DEVTLB_LOG2(NUM_PS_SETS[0])-1:0];
      assign RF_PS0_Data_WrData      = ArrWrData_H[0];
   end else begin : RF_Data_TieOff_0
      assign RF_PS0_Data_RdEn        = '0;
      assign RF_PS0_Data_RdAddr      = '0;
      assign RF_PS0_Data_WrEn        = '0;
      assign RF_PS0_Data_WrAddr      = '0;
      assign RF_PS0_Data_WrData      = '0;
   end

   if ((PS_MIN <= 1) && (PS_MAX >= 1)) begin : RF_Data_Drive_1 // Legal PS value
      assign RF_PS1_Data_RdEn        = TLBPipe_H[TLB_DATA_RD_CTRL].ArrCtrl[1].RdEn;
      assign RF_PS1_Data_RdAddr      = TLBPipe_H[TLB_DATA_RD_CTRL].ArrCtrl[1].SetAddr[`HQM_DEVTLB_LOG2(NUM_PS_SETS[1])-1:0];
      for(g_way=0; g_way<NUM_WAYS; g_way++) begin: way8
      assign RF_PS1_Data_WrEn[g_way]  = TLBPipe_H[TLB_DATA_WR_CTRL].ArrCtrl[1].ArrWrEn ? TLBPipe_H[TLB_DATA_WR_CTRL].ArrInfo[1].RepVec[g_way] : '0;
      end
      assign RF_PS1_Data_WrAddr      = TLBPipe_H[TLB_DATA_WR_CTRL].ArrCtrl[1].SetAddr[`HQM_DEVTLB_LOG2(NUM_PS_SETS[1])-1:0];
      assign RF_PS1_Data_WrData      = ArrWrData_H[1] >> (9); // Non-leaf PWC data is a 4k aligned page table base
   end else begin : RF_Data_TieOff_1
      assign RF_PS1_Data_RdEn        = '0;
      assign RF_PS1_Data_RdAddr      = '0;
      assign RF_PS1_Data_WrEn        = '0;
      assign RF_PS1_Data_WrAddr      = '0;
      assign RF_PS1_Data_WrData      = '0;
   end

   if ((PS_MIN <= 2) && (PS_MAX >= 2)) begin : RF_Data_Drive_2 // Legal PS value
      assign RF_PS2_Data_RdEn        = TLBPipe_H[TLB_DATA_RD_CTRL].ArrCtrl[2].RdEn;
      assign RF_PS2_Data_RdAddr      = TLBPipe_H[TLB_DATA_RD_CTRL].ArrCtrl[2].SetAddr[`HQM_DEVTLB_LOG2(NUM_PS_SETS[2])-1:0];
      for(g_way=0; g_way<NUM_WAYS; g_way++) begin: way9
      assign RF_PS2_Data_WrEn[g_way]  = TLBPipe_H[TLB_DATA_WR_CTRL].ArrCtrl[2].ArrWrEn ? TLBPipe_H[TLB_DATA_WR_CTRL].ArrInfo[2].RepVec[g_way] : '0;
      end
      assign RF_PS2_Data_WrAddr      = TLBPipe_H[TLB_DATA_WR_CTRL].ArrCtrl[2].SetAddr[`HQM_DEVTLB_LOG2(NUM_PS_SETS[2])-1:0];
      assign RF_PS2_Data_WrData      = ArrWrData_H[2] >> (18); // Non-leaf PWC data is a 4k aligned page table base
   end else begin : RF_Data_TieOff_2
      assign RF_PS2_Data_RdEn        = '0;
      assign RF_PS2_Data_RdAddr      = '0;
      assign RF_PS2_Data_WrEn        = '0;
      assign RF_PS2_Data_WrAddr      = '0;
      assign RF_PS2_Data_WrData      = '0;
   end

   if ((PS_MIN <= 3) && (PS_MAX >= 3)) begin : RF_Data_Drive_3 // Legal PS value
      assign RF_PS3_Data_RdEn        = TLBPipe_H[TLB_DATA_RD_CTRL].ArrCtrl[3].RdEn;
      assign RF_PS3_Data_RdAddr      = TLBPipe_H[TLB_DATA_RD_CTRL].ArrCtrl[3].SetAddr[`HQM_DEVTLB_LOG2(NUM_PS_SETS[3])-1:0];
      for(g_way=0; g_way<NUM_WAYS; g_way++) begin: way9b
      assign RF_PS3_Data_WrEn[g_way]  = TLBPipe_H[TLB_DATA_WR_CTRL].ArrCtrl[3].ArrWrEn ? TLBPipe_H[TLB_DATA_WR_CTRL].ArrInfo[3].RepVec[g_way] : '0;
      end
      assign RF_PS3_Data_WrAddr      = TLBPipe_H[TLB_DATA_WR_CTRL].ArrCtrl[3].SetAddr[`HQM_DEVTLB_LOG2(NUM_PS_SETS[3])-1:0];
      assign RF_PS3_Data_WrData      = ArrWrData_H[3] >> (27); // Non-leaf PWC data is a 4k aligned page table base
   end else begin : RF_Data_TieOff_3
      assign RF_PS3_Data_RdEn        = '0;
      assign RF_PS3_Data_RdAddr      = '0;
      assign RF_PS3_Data_WrEn        = '0;
      assign RF_PS3_Data_WrAddr      = '0;
      assign RF_PS3_Data_WrData      = '0;
   end

   if ((PS_MIN <= 4) && (PS_MAX >= 4)) begin : RF_Data_Drive_4 // Legal PS value
      assign RF_PS4_Data_RdEn        = TLBPipe_H[TLB_DATA_RD_CTRL].ArrCtrl[4].RdEn;
      assign RF_PS4_Data_RdAddr      = TLBPipe_H[TLB_DATA_RD_CTRL].ArrCtrl[4].SetAddr[`HQM_DEVTLB_LOG2(NUM_PS_SETS[4])-1:0];
      for(g_way=0; g_way<NUM_WAYS; g_way++) begin: way9b
      assign RF_PS4_Data_WrEn[g_way] = TLBPipe_H[TLB_DATA_WR_CTRL].ArrCtrl[4].ArrWrEn ? TLBPipe_H[TLB_DATA_WR_CTRL].ArrInfo[4].RepVec[g_way] : '0;
      end
      assign RF_PS4_Data_WrAddr      = TLBPipe_H[TLB_DATA_WR_CTRL].ArrCtrl[4].SetAddr[`HQM_DEVTLB_LOG2(NUM_PS_SETS[4])-1:0];
      assign RF_PS4_Data_WrData      = ArrWrData_H[4] >> (36); // Non-leaf PWC data is a 4k aligned page table base
   end else begin : RF_Data_TieOff_4
      assign RF_PS4_Data_RdEn        = '0;
      assign RF_PS4_Data_RdAddr      = '0;
      assign RF_PS4_Data_WrEn        = '0;
      assign RF_PS4_Data_WrAddr      = '0;
      assign RF_PS4_Data_WrData      = '0;
   end

endgenerate

//=====================================================================================================================
// Address Cache (DID/GPA -> HPA) Way Selection (Stage 103)
// Address Cache (DID/GPA -> HPA) TAG Write Control Selection (Stage 103)
//=====================================================================================================================

// Split of data array output manipulation depending on the array type since they have
// different structure elements that need to be muxed.
//
logic [TLB_TAG_WR_CTRL:TLB_DATA_RD] AtsRspDPErr;
logic [TLB_DATA_RD+1:TLB_DATA_RD]   TLBRFDPErr;

generate
   always_comb begin
      TLBPipe_H[TLB_DATA_RD].Req           =  ff_TLBPipe_H[TLB_DATA_RD].Req;
      TLBPipe_H[TLB_DATA_RD].Ctrl          =  ff_TLBPipe_H[TLB_DATA_RD].Ctrl;
      TLBPipe_H[TLB_DATA_RD].Info          =  ff_TLBPipe_H[TLB_DATA_RD].Info;

      AtsRspDPErr[TLB_DATA_RD]             =  ff_TLBPipe_H[TLB_DATA_RD].Info.ParityError; //atsrsp from mstrk

      if (~TLBPipe_H[TLB_DATA_RD].Ctrl.InvalDTLB) begin
         // Find the LARGEST page-size TLB array that hit and use it to select the output
         // It is possible, in the event of page size promotion, to get double hits across two different page size tlbs
         // Also need to limit references to ArrInfo to max legal index values that can be smaller for FPV
         //
         for (int tlb_ps = PS_MIN; tlb_ps <= PS_MAX; tlb_ps++) begin  : Tag_PSSel_Priority_Lp1
//hkhor1: TODO MULTI PS support //TODO changes below changes HitFault to Miss. Check what things that HitFault does
/*            for (int way = 0; way < NUM_WAYS; way++) begin
                TLBHitW[tlb_ps] |= TLBPipe_H[TLB_DATA_RD].ArrInfo[tlb_ps].HitVec[way] && ArrRdData_H[tlb_ps][way].W;
            end
            TLBPipe_H[TLB_DATA_RD].Info.Hit                     |= TLBPipe_H[TLB_DATA_RD].ArrInfo[tlb_ps].Hit && 
            (f_dma_write_req(TLBPipe_H[TLB_DATA_RD].Req.Opcode)? TLBHitW[tlb_ps]: 1'b1); // in case 1 page with R, another page with W, choose Largest size page with W.
*/            
            TLBPipe_H[TLB_DATA_RD].Info.Hit                     |= TLBPipe_H[TLB_DATA_RD].ArrInfo[tlb_ps].Hit;
            
            if (TLBPipe_H[TLB_DATA_RD].ArrInfo[tlb_ps].Hit)  TLBPipe_H[TLB_DATA_RD].Info.PSSel = T_PGSIZE'(f_IOMMU_Int_2_PS(tlb_ps));
            if (TLBPipe_H[TLB_DATA_RD].ArrInfo[tlb_ps].Hit)  TLBPipe_H[TLB_DATA_RD].Info.Size  = T_PGSIZE'(f_IOMMU_Int_2_PS(tlb_ps));
         end
      end

      // Accumulate Final Hit, Overall (Same as TLB_TAG_RD + 1)
      //
      //for (int tlb_ps = PS_MIN; tlb_ps <= PS_MAX; tlb_ps++) begin  : Tag_PSSel_Priority_Lp0
      //end

         // Mux between each way according to the hit vector. Default to 0. HitVec will be mutex allowing AND-OR muxing.
         //

         // IOTLB HitVec Muxing
      // For the IOTLB, the data parity error needs to be calculated in the DATA_RD
      // stage to avoid negatively impacting the primary output timing.
      
      // Calculated from array read data..grab data back from pipeline, post way selection mux, 
      // into convenient structure to calculate parity
      ArrRdDataP_H                = '0;
      for (int way = 0; way < NUM_WAYS; way++) begin : gen_parity_Way_Select
        for (int tlb_ps = PS_MIN; tlb_ps <= PS_MAX; tlb_ps++) begin : gen_parity_TLB_PS_Select_Lp2
           if (TLBPipe_H[TLB_DATA_RD].Info.PSSel == tlb_ps) begin
              if (TLBPipe_H[TLB_DATA_RD].ArrInfo[tlb_ps].HitVec[way] &&
                  ~TLBPipe_H[TLB_DATA_RD].ArrInfo[tlb_ps].TagParErr[way]) begin // qual with tagparity for fill.
                 TLBPipe_H[TLB_DATA_RD].Info.Parity |= ArrRdData_H[tlb_ps][way].Parity;
                 ArrRdDataP_H.U                |= ArrRdData_H[tlb_ps][way].U;     
                 ArrRdDataP_H.N                |= ArrRdData_H[tlb_ps][way].N;  
                 ArrRdDataP_H.R                |= ArrRdData_H[tlb_ps][way].R;
                 ArrRdDataP_H.W                |= ArrRdData_H[tlb_ps][way].W;
                 ArrRdDataP_H.Priv_Data        |= ArrRdData_H[tlb_ps][way].Priv_Data;
                 ArrRdDataP_H.Address          |= ArrRdData_H[tlb_ps][way].Address & ('1 << (TLBPipe_H[TLB_DATA_RD].Info.PSSel*9));

                 if (DEVTLB_PASID_SUPP_EN) begin
                    if (ARSP_X_SUPP) ArrRdDataP_H.X                |= ArrRdData_H[tlb_ps][way].X; 

                    if (DEVTLB_MEMTYPE_EN) begin : Memtype2 
                       ArrRdDataP_H.Memtype          |= ArrRdData_H[tlb_ps][way].Memtype;
                    end
                 end
              end
           end
        end
      end

      // If not bypassing as part of a fill, pick the data form the way that hit
      //
      if (~TLBPipe_H[TLB_DATA_RD].Ctrl.InvalDTLB) begin : Iotlb_split
        if (~TLBPipe_H[TLB_DATA_RD].Ctrl.Fill) begin
          TLBPipe_H[TLB_DATA_RD].Info.U                = ArrRdDataP_H.U;     
          TLBPipe_H[TLB_DATA_RD].Info.N                = ArrRdDataP_H.N;  
          TLBPipe_H[TLB_DATA_RD].Info.R                = ArrRdDataP_H.R;
          TLBPipe_H[TLB_DATA_RD].Info.W                = ArrRdDataP_H.W;
          TLBPipe_H[TLB_DATA_RD].Info.Priv_Data        = ArrRdDataP_H.Priv_Data;
          TLBPipe_H[TLB_DATA_RD].Info.Address          = ArrRdDataP_H.Address;

          if (DEVTLB_PASID_SUPP_EN) begin
            if (ARSP_X_SUPP) TLBPipe_H[TLB_DATA_RD].Info.X                = ArrRdDataP_H.X; 

            if (DEVTLB_MEMTYPE_EN) begin : Memtype3
               TLBPipe_H[TLB_DATA_RD].Info.Memtype       = ArrRdDataP_H.Memtype;
            end
          end
        end
      end : Iotlb_split
      
         // Get Untranslated bits from Request Address
         // All bits recieved are translated for 4K pages...no need to fill in bits form Req
         //
         // Would be nice to simply use TLBPipe_H[TLB_DATA_RD].Info.PSSel as the argument to the
         // UNTRAN_RANGE macro but VCS considers that an illegal  left slicing operation
         //
         // Force 0 for PageWalk Cache Instance so that the full 4k address from the array is left intact
         //
         unique casez (TLBPipe_H[TLB_DATA_RD].Info.Size)
             // QP page size may not be compatibile with certain GPA/HPA combinations
             /*SIZE_QP : begin
                 if (MAX_GUEST_ADDRESS_WIDTH > 48) begin
                     TLBPipe_H[TLB_DATA_RD].Info.Address[`HQM_DEVTLB_TLB_UNTRAN_RANGE(`HQM_DEVTLB_PS_QP)]
                         = TLBPipe_H[TLB_DATA_RD].Req.Address[`HQM_DEVTLB_TLB_UNTRAN_RANGE(`HQM_DEVTLB_PS_QP)];
                 end else begin
                     TLBPipe_H[TLB_DATA_RD].Info.Address = '0;
                 end
             end*/
            SIZE_5T : TLBPipe_H[TLB_DATA_RD].Info.Address[`HQM_DEVTLB_TLB_UNTRAN_RANGE(`HQM_DEVTLB_PS_5T)]
                              = TLBPipe_H[TLB_DATA_RD].Req.Address[`HQM_DEVTLB_TLB_UNTRAN_RANGE(`HQM_DEVTLB_PS_5T)];

            SIZE_1G : TLBPipe_H[TLB_DATA_RD].Info.Address[`HQM_DEVTLB_TLB_UNTRAN_RANGE(`HQM_DEVTLB_PS_1G)]
                              = TLBPipe_H[TLB_DATA_RD].Req.Address[`HQM_DEVTLB_TLB_UNTRAN_RANGE(`HQM_DEVTLB_PS_1G)];

            SIZE_2M : TLBPipe_H[TLB_DATA_RD].Info.Address[`HQM_DEVTLB_TLB_UNTRAN_RANGE(`HQM_DEVTLB_PS_2M)]
                              = TLBPipe_H[TLB_DATA_RD].Req.Address[`HQM_DEVTLB_TLB_UNTRAN_RANGE(`HQM_DEVTLB_PS_2M)];

            default: ;   // This is to make Jasper not complain about an incomplete case
         endcase

      // Detect if a read or write fault has occurred
      // Fault detection for Lookup replay due to Fill is done in MsTrk.
      //
      TLBReadReqVal_H   = TLBPipeV_H[TLB_DATA_RD] 
                           & f_dma_read_req(TLBPipe_H[TLB_DATA_RD].Req.Opcode);
      
      TLBWriteReqVal_H  = TLBPipeV_H[TLB_DATA_RD] 
                           & f_dma_write_req(TLBPipe_H[TLB_DATA_RD].Req.Opcode);
      
      TLBZlrReqVal_H    = TLBPipeV_H[TLB_DATA_RD] 
                           & f_dma_zlr_req(TLBPipe_H[TLB_DATA_RD].Req.Opcode);
      
      TLBExeReqVal_H    = ARSP_X_SUPP && TLBPipeV_H[TLB_DATA_RD] 
                           & f_IOMMU_Opcode_is_DMA(TLBPipe_H[TLB_DATA_RD].Req.Opcode)
                           & TLBPipe_H[TLB_DATA_RD].Req.PasidV 
                           /*& TLBPipe_H[TLB_DATA_RD].Req.ER*/;
      
      TLBExecuteFault_H = ARSP_X_SUPP && TLBExeReqVal_H     & ~TLBPipe_H[TLB_DATA_RD].Info.X;  

      priority casez (1'b1)
         TLBZlrReqVal_H                   : begin
                        TLBReadFault_H  = ~TLBPipe_H[TLB_DATA_RD].Info.R & ~TLBPipe_H[TLB_DATA_RD].Info.W;
                        TLBWriteFault_H = 1'b0;
                  end
         default                          : begin
                        TLBReadFault_H  = TLBReadReqVal_H  & ~TLBPipe_H[TLB_DATA_RD].Info.R;
                        TLBWriteFault_H = TLBWriteReqVal_H & ~TLBPipe_H[TLB_DATA_RD].Info.W;
                  end
      endcase

      if (TLBPipe_H[TLB_DATA_RD].Info.Hit) begin // Fault not indicted from PW

         priority casez (1'b1)
            TLBWriteFault_H   : begin
                     //TLBPipe_H[TLB_DATA_RD].Info.FaultReason = T_FAULTREASON'(DEVTLB_FAULT_RSN_DMA_PAGE_W);
                     TLBPipe_H[TLB_DATA_RD].Info.Fault       = 1'b1;
                     TLBPipe_H[TLB_DATA_RD].Info.Status      = T_STATUS'(DEVTLB_RESP_HIT_FAULT);
                  end
            TLBReadFault_H    : begin
                     //TLBPipe_H[TLB_DATA_RD].Info.FaultReason = T_FAULTREASON'(DEVTLB_FAULT_RSN_DMA_PAGE_R);
                     TLBPipe_H[TLB_DATA_RD].Info.Fault       = 1'b1;
                     TLBPipe_H[TLB_DATA_RD].Info.Status      = T_STATUS'(DEVTLB_RESP_HIT_FAULT);
                  end
            ARSP_X_SUPP && TLBExecuteFault_H : begin
                     //TLBPipe_H[TLB_DATA_RD].Info.FaultReason = T_FAULTREASON'(DEVTLB_FAULT_RSN_DMA_PASID_X);
                     TLBPipe_H[TLB_DATA_RD].Info.Fault       = 1'b1;
                     TLBPipe_H[TLB_DATA_RD].Info.Status      = T_STATUS'(DEVTLB_RESP_HIT_FAULT);
                  end
            default           : ;   // This is to make Jasper not complain about an incomplete case
         endcase

      end

      // Finalize data results to be ready for output
      //
      TLBRFDPErr[TLB_DATA_RD]  = (~`HQM_DEVTLB_PARITY_CHECK(TLBPipe_H[TLB_DATA_RD].Info.Parity, ArrRdDataP_H, ~CrParErrInj_nnnH.disable_iotlb_parityerror)); //TODO qual with HitVec??
      TLBPipe_H[TLB_DATA_RD].Info.ParityError |= TLBRFDPErr[TLB_DATA_RD] && ~(TLBPipe_H[TLB_DATA_RD].Ctrl.Fill || TLBPipe_H[TLB_DATA_RD].Ctrl.InvalDTLB); //Fill? (atsrsp dperr only): (atsrsp dperr or tlb rf dperr)
      
      TLBDataParityError_nnnH =  '0;
      TLBDataParityError_nnnH[TLBPipe_H[TLB_DATA_RD].Info.PSSel]   //pendq/xreq
                                    = TLBPipeV_H[TLB_DATA_RD]
                                    & ~TLBPipe_H[TLB_DATA_RD].Ctrl.Fill
                                    & TLBPipe_H[TLB_DATA_RD].ArrInfo[TLBPipe_H[TLB_DATA_RD].Info.PSSel].Hit
                                    & TLBRFDPErr[TLB_DATA_RD];

      ReqAtsRspError_nnnH      = TLBPipeV_H[TLB_DATA_RD]
                                    & (TLBPipe_H[TLB_DATA_RD].Info.HeaderError || AtsRspDPErr[TLB_DATA_RD]);

      if (|{TLBDataParityError_nnnH, ReqAtsRspError_nnnH}) begin
            //TLBPipe_H[TLB_DATA_RD].Info.FaultReason = T_FAULTREASON'(DEVTLB_FAULT_RSN_CORRUPT_REQUEST);
            TLBPipe_H[TLB_DATA_RD].Info.Fault       = '0;
            TLBPipe_H[TLB_DATA_RD].Info.Status      = T_STATUS'(DEVTLB_RESP_FAILURE);
      end

      // Drive Final Output...suppress if early miss conditions are true
      //
      // Suppress output on misses...should have been sent to early miss output
      // Suppress output on invalidation requests...should only be sent to early miss output (to pwt)
      //
      // Generate valid 1 clock early to avoid unnecessary delay on output interface

//      SetInvHitPS_nnnH              = '0; 
//      for (int tlb_ps = PS_MIN; tlb_ps <= PS_MAX; tlb_ps++) begin  : INV_STATUS
//         SetInvHitPS_nnnH[tlb_ps] = TLBPipeV_H[TLB_DATA_RD-1]
//                                    & f_IOMMU_Opcode_is_Invalidation(TLBPipe_H[TLB_DATA_RD-1].Req.Opcode)
//                                    & (|TLBPipe_H[TLB_DATA_RD-1].ArrInfo[tlb_ps].HitVec)
//                                    & TLBPipe_H[TLB_DATA_RD-1].Ctrl.InvalDTLB;
//      end

//      SetInvHit_nnnH = |SetInvHitPS_nnnH;
//      RstInvHit_nnnH = TLBPipeV_H[TLB_DATA_RD] 
//                       & TLBPipe_H[TLB_DATA_RD].Ctrl.InvalDTLB 
//                       & ~TLBPipe_H[TLB_DATA_RD-1].Ctrl.InvalDTLB;
      
//      SetTLBOutInv_nnnH             = (TLBPipeV_H[TLB_DATA_RD-1] & TLBPipe_H[TLB_DATA_RD-1].Ctrl.InvalDTLB)
//                                       & ~(TLBPipeV_H[TLB_DATA_RD] & TLBPipe_H[TLB_DATA_RD].Ctrl.InvalDTLB);
//      RstTLBOutInv_nnnH             = TLBOutInv_nnnH;

//      preTLBOutPipeV_nnnH           = (TLBPipeV_H[TLB_DATA_RD] & TLBPipe_H[TLB_DATA_RD].Ctrl.InvalDTLB)
//                                       ? TLBOutInv_nnnH/*RstInvHit_nnnH*/
//                                       : (TLBPipeV_H[TLB_DATA_RD] & ~TLBPipe_H[TLB_DATA_RD].Ctrl.InvalGlb);
                                       
      preTLBOutPipeV_nnnH           =  TLBPipeV_H[TLB_DATA_RD] &
                                       (TLBPipe_H[TLB_DATA_RD].Req.PortId==DEVTLB_PORT_ID) &
                                      ~(TLBPipe_H[TLB_DATA_RD].Ctrl.InvalGlb || 
                                        (TLBPipe_H[TLB_DATA_RD].Ctrl.InvalDTLB && 
                                         (TLBPipe_H[TLB_DATA_RD].Req.Opcode == T_OPCODE'(DEVTLB_OPCODE_DTLB_INV))));
                                     
      TLBMissPipeV_nnnH             = TLBPipeV_H[TLB_DATA_RD]                            // Qualify with PipeV because other elements linger
                                    & ~TLBPipe_H[TLB_DATA_RD].Info.Hit
                                    & ~TLBPipe_H[TLB_DATA_RD].Ctrl.Fill
                                    & ~TLBPipe_H[TLB_DATA_RD].Ctrl.InvalGlb
                                    & ~TLBPipe_H[TLB_DATA_RD].Ctrl.InvalDTLB
                                    & ~(|{TLBDataParityError_nnnH, ReqAtsRspError_nnnH});

      TLBHitPipeV_nnnH              = TLBPipeV_H[TLB_DATA_RD]                            // Qualify with PipeV because other elements linger
                                    &  TLBPipe_H[TLB_DATA_RD].Info.Hit
                                    & ~TLBPipe_H[TLB_DATA_RD].Info.Fault
                                    //& ~(|TLBPipe_H[TLB_DATA_RD].Info.FaultReason)
                                    & ~TLBPipe_H[TLB_DATA_RD].Ctrl.Fill
                                    & ~TLBPipe_H[TLB_DATA_RD].Ctrl.InvalGlb
                                    & ~TLBPipe_H[TLB_DATA_RD].Ctrl.InvalDTLB
                                    & ~(|{TLBDataParityError_nnnH, ReqAtsRspError_nnnH});
       
      TLBFillPipeV_nnnH             = TLBPipeV_H[TLB_DATA_RD]                            // Qualify with PipeV because other elements linger
                                    & ~TLBPipe_H[TLB_DATA_RD].Info.Fault
                                    & TLBPipe_H[TLB_DATA_RD].Ctrl.Fill
                                    & ~TLBPipe_H[TLB_DATA_RD].Ctrl.InvalGlb
                                    & ~TLBPipe_H[TLB_DATA_RD].Ctrl.InvalDTLB
                                    & ~(|{TLBDataParityError_nnnH, ReqAtsRspError_nnnH});
      
      TLBInvPipeV_nnnH              = TLBPipeV_H[TLB_DATA_RD]
                                    & (TLBPipe_H[TLB_DATA_RD].Req.Opcode == T_OPCODE'(DEVTLB_OPCODE_UARCH_INV))
                                    & TLBPipe_H[TLB_DATA_RD].Ctrl.InvalDTLB;
      
      TLBFaultPipeV_nnnH            = TLBPipeV_H[TLB_DATA_RD]
                                    & TLBPipe_H[TLB_DATA_RD].Info.Fault
                                    & TLBPipe_H[TLB_DATA_RD].Info.Hit
                                    & ~TLBPipe_H[TLB_DATA_RD].Ctrl.Fill
                                    & ~TLBPipe_H[TLB_DATA_RD].Ctrl.InvalGlb
                                    & ~TLBPipe_H[TLB_DATA_RD].Ctrl.InvalDTLB
                                    & ~(|{TLBDataParityError_nnnH, ReqAtsRspError_nnnH});
      
      TLBFillFaultPipeV_nnnH        = TLBPipeV_H[TLB_DATA_RD]
                                    & TLBPipe_H[TLB_DATA_RD].Info.Fault
                                    & TLBPipe_H[TLB_DATA_RD].Ctrl.Fill
                                    & ~TLBPipe_H[TLB_DATA_RD].Ctrl.InvalGlb
                                    & ~TLBPipe_H[TLB_DATA_RD].Ctrl.InvalDTLB
                                    & ~(|{TLBDataParityError_nnnH, ReqAtsRspError_nnnH});

      //TLBDPErrPipeV_nnnH & ReqAtsRspErrPipeV_nnnH not ANDed with Inval. As they are after TLBInvPipeV_nnnH in casez.
      TLBDPErrPipeV_nnnH           = TLBPipeV_H[TLB_DATA_RD]
                                     & ~TLBPipe_H[TLB_DATA_RD].Ctrl.Fill
                                     & ~TLBPipe_H[TLB_DATA_RD].Ctrl.InvalGlb
                                     & ~TLBPipe_H[TLB_DATA_RD].Ctrl.InvalDTLB
                                     & (|TLBDataParityError_nnnH) & ~ReqAtsRspError_nnnH; //atsrsp err higher prio
      
      ReqAtsRspErrPipeV_nnnH       = TLBPipeV_H[TLB_DATA_RD]
                                     & ~TLBPipe_H[TLB_DATA_RD].Ctrl.InvalGlb
                                     & ~TLBPipe_H[TLB_DATA_RD].Ctrl.InvalDTLB
                                     & ReqAtsRspError_nnnH;

//      TLBPipe_H[TLB_DATA_RD].Info.Status = T_STATUS'((InvHit_nnnH & f_IOMMU_Opcode_is_Invalidation(TLBPipe_H[TLB_DATA_RD].Req.Opcode))
//                                             ? DEVTLB_RESP_INV_HIT
//                                             : DEVTLB_RESP_INV_MISS);

      preTLBOutXRspV_nnnH = '0;
      preTLBOutMsProcV_nnnH  = '0;
      unique casez (1'b1)
         TLBHitPipeV_nnnH & ~TLBPipe_H[TLB_DATA_RD].Info.U: begin
            TLBPipe_H[TLB_DATA_RD].Info.Status  = T_STATUS'(DEVTLB_RESP_HIT_VALID);
            TLBPipe_H[TLB_DATA_RD].Info.PrsCode = '0;
            preTLBOutXRspV_nnnH = '1;
         end
         TLBHitPipeV_nnnH & TLBPipe_H[TLB_DATA_RD].Info.U: begin
            TLBPipe_H[TLB_DATA_RD].Info.Status  = T_STATUS'(DEVTLB_RESP_HIT_VALID);
            //TLBPipe_H[TLB_DATA_RD].Info.Status  = T_STATUS'(DEVTLB_RESP_HIT_UTRN);
            //preTLBOutMsProcV_nnnH = ~TLBPipe_H[TLB_DATA_RD].Ctrl.PendQXReq;//ATSReq
            //preTLBOutXRspV_nnnH = TLBPipe_H[TLB_DATA_RD].Ctrl.PendQXReq;
            TLBPipe_H[TLB_DATA_RD].Info.PrsCode = '0;
            preTLBOutXRspV_nnnH = '1;
         end
         TLBFaultPipeV_nnnH: begin //Hit Fault
            TLBPipe_H[TLB_DATA_RD].Info.Status  = T_STATUS'(DEVTLB_RESP_HIT_FAULT);
            preTLBOutMsProcV_nnnH = ~TLBPipe_H[TLB_DATA_RD].Ctrl.PendQXReq;//ATSReq
            preTLBOutXRspV_nnnH = TLBPipe_H[TLB_DATA_RD].Ctrl.PendQXReq;
         end
         TLBMissPipeV_nnnH: begin// PendQ miss due to eviction or invalidation will comes here 
            TLBPipe_H[TLB_DATA_RD].Info.Status  = T_STATUS'(DEVTLB_RESP_MISS);
            //preTLBOutMsProcV_nnnH = 1'b1;//ATSReq
            preTLBOutMsProcV_nnnH = ~TLBPipe_H[TLB_DATA_RD].Ctrl.ForceXRsp;//ATSReq
            preTLBOutXRspV_nnnH = TLBPipe_H[TLB_DATA_RD].Ctrl.ForceXRsp;
         end
         TLBFillPipeV_nnnH & ~TLBPipe_H[TLB_DATA_RD].Info.U: begin
            TLBPipe_H[TLB_DATA_RD].Info.Status  = T_STATUS'(DEVTLB_RESP_HIT_VALID);
            preTLBOutXRspV_nnnH = '1;
            preTLBOutMsProcV_nnnH = '0; //FillFlush
         end
         TLBFillPipeV_nnnH & TLBPipe_H[TLB_DATA_RD].Info.U: begin
            //TLBPipe_H[TLB_DATA_RD].Info.Status  = T_STATUS'(DEVTLB_RESP_HIT_UTRN);
            TLBPipe_H[TLB_DATA_RD].Info.Status  = T_STATUS'(DEVTLB_RESP_HIT_VALID);
            preTLBOutXRspV_nnnH = '1;
            preTLBOutMsProcV_nnnH = '0; //FillFlush
         end
         TLBFillFaultPipeV_nnnH: begin
            TLBPipe_H[TLB_DATA_RD].Info.Status  = T_STATUS'(DEVTLB_RESP_HIT_FAULT);
            preTLBOutXRspV_nnnH = '1;
            preTLBOutMsProcV_nnnH = '0; //FillFlush
            //TLBPipe_H[TLB_DATA_RD].Info.N = '0; //TODO do we need this??
         end
         //TLBFillPipeV_nnnH:
         //   TLBPipe_H[TLB_DATA_RD].Info.Status  = T_STATUS'(DEVTLB_RESP_ACK);
         TLBInvPipeV_nnnH: begin
            TLBPipe_H[TLB_DATA_RD].Info.Status  = TLBPipe_H[TLB_DATA_RD].Info.Hit?
                                                 T_STATUS'(DEVTLB_RESP_INV_HIT):
                                                 T_STATUS'(DEVTLB_RESP_INV_MISS);
            preTLBOutXRspV_nnnH = '1;
            preTLBOutMsProcV_nnnH = '0;
         end
         ReqAtsRspErrPipeV_nnnH: begin //atsrsp hdrerr, or atsrsp dperr for fill or pendq, not possile for xreq
            TLBPipe_H[TLB_DATA_RD].Info.Status  = T_STATUS'(DEVTLB_RESP_FAILURE);
            preTLBOutXRspV_nnnH = '1;
            preTLBOutMsProcV_nnnH = '0;
         end
         TLBDPErrPipeV_nnnH: begin //pendq/xreq with hit gets Data RF perr
            TLBPipe_H[TLB_DATA_RD].Info.Status  = T_STATUS'(DEVTLB_RESP_FAILURE);
            preTLBOutXRspV_nnnH   =  (TLBPipe_H[TLB_DATA_RD].Ctrl.PendQXReq);
            preTLBOutMsProcV_nnnH = ~(TLBPipe_H[TLB_DATA_RD].Ctrl.PendQXReq);
         end
         default:
            TLBPipe_H[TLB_DATA_RD].Info.Status  = T_STATUS'(DEVTLB_RESP_ACK);
      endcase 

      TLBPipe_H[TLB_DATA_RD].Info = reset?'0: TLBPipe_H[TLB_DATA_RD].Info;

    end
endgenerate

logic ClkHit_H,pEn_ClkHit_H;
assign pEn_ClkHit_H = TLBPipeV_H[TLB_DATA_RD]
                        | TLBPipeV_H[TLB_DATA_RD+1]
                        | TLBPipeV_H[TLB_DATA_RD-1]
                        | reset;
`HQM_DEVTLB_MAKE_LCB_PWR(ClkHit_H,  ClkRcb_nnnH, pEn_ClkHit_H,  1'b0)

//`DEVTLB_SET_RST_MSFF(InvHit_nnnH, InvHit_nnnH, ClkHit_H, SetInvHit_nnnH, RstInvHit_nnnH | reset)
//`DEVTLB_SET_RST_MSFF(TLBOutInv_nnnH, TLBOutInv_nnnH, ClkHit_H, SetTLBOutInv_nnnH, RstTLBOutInv_nnnH| reset)

logic [TLB_DATA_RD:TLB_DATA_RD]     TLBCached_W, TLBCached_R;
logic [TLB_DATA_WR_CTRL:TLB_DATA_RD] ReUseTLB;
logic [TLB_DATA_RD:TLB_DATA_RD][PS_MAX:PS_MIN] FillArrCtrlWrEn;
always_comb begin

   TLBPipe_H[TLB_DATA_RD].ArrInfo       =  ff_TLBPipe_H[TLB_DATA_RD].ArrInfo;
   TLBPipe_H[TLB_DATA_RD].ArrCtrl       =  ff_TLBPipe_H[TLB_DATA_RD].ArrCtrl;

    // IOTLB HitVec Muxing
    TLBCached_R[TLB_DATA_RD] = '0;
    TLBCached_W[TLB_DATA_RD] = '0;
    InvDPErrEntry[TLB_DATA_RD] = '0;
    for (int way = 0; way < NUM_WAYS; way++) begin : TLB_Way_Select_Lp2
        for (int tlb_ps = PS_MIN; tlb_ps <= PS_MAX; tlb_ps++) begin : TLB_PS_Select_Lp2
           if (TLBPipe_H[TLB_DATA_RD].Info.PSSel == tlb_ps) begin
              if (TLBPipe_H[TLB_DATA_RD].ArrInfo[tlb_ps].HitVec[way] &&
                  ~TLBPipe_H[TLB_DATA_RD].ArrInfo[tlb_ps].TagParErr[way] ) begin // qual with tag parity for fill
                 TLBCached_R[TLB_DATA_RD]                |= ArrRdData_H[tlb_ps][way].R;
                 TLBCached_W[TLB_DATA_RD]                |= ArrRdData_H[tlb_ps][way].W;
              end
            end
        end
    end
    for (int way = 0; way < NUM_WAYS; way++) begin : TLB_Way_Select_Lp3
        for (int tlb_ps = PS_MIN; tlb_ps <= PS_MAX; tlb_ps++) begin : TLB_PS_Select_Lp3
           if (TLBPipe_H[TLB_DATA_RD].Info.PSSel == tlb_ps) begin
              if (TLBPipe_H[TLB_DATA_RD].ArrInfo[tlb_ps].HitVec[way]) begin // qual with tag parity for fill
                 InvDPErrEntry[TLB_DATA_RD] = TLBPipe_H[TLB_DATA_RD].Ctrl.Fill && 
                                        (TLBRFDPErr[TLB_DATA_RD] || TLBPipe_H[TLB_DATA_RD].ArrInfo[tlb_ps].TagParErr[way])&&
                                        ~(ff_TLBPipe_H[TLB_DATA_RD].Info.R || ff_TLBPipe_H[TLB_DATA_RD].Info.W);
              end
            end
        end
    end
    ReUseTLB[TLB_DATA_RD] = TLBPipe_H[TLB_DATA_RD].Ctrl.Fill && (~TLBRFDPErr[TLB_DATA_RD]) &&
                            (ff_TLBPipe_H[TLB_DATA_RD].Info.R ^ ff_TLBPipe_H[TLB_DATA_RD].Info.W) &&
                            (TLBCached_R[TLB_DATA_RD] && TLBCached_W[TLB_DATA_RD]);

   // Create Write Enables
   FillArrCtrlWrEn[TLB_DATA_RD] = '0;
   for (int tlb_ps = PS_MIN; tlb_ps <= PS_MAX; tlb_ps++) begin  : Tag_WR_Cdtrl_PS_Lp

      if (NUM_PS_SETS[tlb_ps] > 0) begin    // write only if the arrays has entries

         // Generate a write enable when on a valid fill that isn't already in the array
         //
         TLBPipe_H[TLB_DATA_RD].ArrCtrl[tlb_ps].WrEn    = f_tlb_fill_en(TLBPipe_H[TLB_DATA_RD].Req.Opcode,
                                                                   TLBPipe_H[TLB_DATA_RD].Req.Overflow)
                                                               &  TLBPipe_H[TLB_DATA_RD].Ctrl.Fill
                                                               & ~(TLBPipe_H[TLB_DATA_RD].Info.HeaderError || AtsRspDPErr[TLB_DATA_RD])
                                                               & (TLBPipe_H[TLB_DATA_RD].Info.EffSize == T_PGSIZE'(f_IOMMU_Int_2_PS(tlb_ps)))
                                                               & ~((`HQM_DEVTLB_PIPE_TLBID(TLB_DATA_RD, tlb_ps) < NUM_ARRAYS)   //spyglass disable W362a //lintra s-W362a
                                                                  & (Disable_Ways[`HQM_DEVTLB_PIPE_TLBID(TLB_DATA_RD, tlb_ps)][tlb_ps] == 2'b11)); // Disable fill write when disabled

        FillArrCtrlWrEn[TLB_DATA_RD][tlb_ps]  = TLBPipe_H[TLB_DATA_RD].ArrCtrl[tlb_ps].WrEn 
                                                && (ff_TLBPipe_H[TLB_DATA_RD].Info.R | ff_TLBPipe_H[TLB_DATA_RD].Info.W) //i.e not InvDPErrEntry 
                                                && (NUM_SETS[`HQM_DEVTLB_PIPE_TLBID(TLB_DATA_RD, tlb_ps)][tlb_ps] > 0);

// final goal is to store even fault due to R/W, except RW=00
// & store if U
         TLBPipe_H[TLB_DATA_RD].ArrCtrl[tlb_ps].WrEn    &= (ff_TLBPipe_H[TLB_DATA_RD].Info.R | ff_TLBPipe_H[TLB_DATA_RD].Info.W) || InvDPErrEntry[TLB_DATA_RD]; 
//commented out line below : so that it store even fault.
         //TLBPipe_H[TLB_DATA_RD].ArrCtrl[tlb_ps].WrEn    &= ~ff_TLBPipe_H[TLB_DATA_RD].Info.Fault;
         // On global invalidate, always enable write
         //
         
         TLBPipe_H[TLB_DATA_RD].ArrCtrl[tlb_ps].WrEn    |= TLBPipe_H[TLB_DATA_RD].Ctrl.InvalGlb  
                                                            & (TLBPipe_H[TLB_DATA_RD].Ctrl.InvalSetAddr < 16'(NUM_SETS[`HQM_DEVTLB_PIPE_TLBID(TLB_DATA_RD, tlb_ps)][tlb_ps]) ); //lintra s-0393

//         TLBPipe_H[TLB_DATA_RD].ArrCtrl[tlb_ps].WrEn    |= (TLBPipe_H[TLB_DATA_RD].Ctrl.InvalDTLB & DisPartInv_nnnH)  //is now handled as .Ctrl.InvalGlb
//                                                            & (TLBPipe_H[TLB_DATA_RD].Ctrl.InvalSetAddr < 16'(NUM_SETS[`DEVTLB_PIPE_TLBID(TLB_DATA_RD, tlb_ps)][tlb_ps]) ); //lintra s-0393

         TLBPipe_H[TLB_DATA_RD].ArrCtrl[tlb_ps].WrEn    |= TLBPipe_H[TLB_DATA_RD].Ctrl.InvalDTLB & (TLBPipe_H[TLB_DATA_RD].Info.am == 6'b111111) & (&(TLBPipe_H[TLB_DATA_RD].Req.Address))
                                                            & (TLBPipe_H[TLB_DATA_RD].Ctrl.InvalSetAddr < 16'(NUM_SETS[`HQM_DEVTLB_PIPE_TLBID(TLB_DATA_RD, tlb_ps)][tlb_ps]) ); //lintra s-0393

         // On a Page Selective invalidation, write enable if any way matches
         //
         TLBPipe_H[TLB_DATA_RD].ArrCtrl[tlb_ps].WrEn    |= TLBPipe_H[TLB_DATA_RD].Ctrl.InvalDTLB
                                                            &  TLBPipe_H[TLB_DATA_RD].ArrInfo[tlb_ps].Hit;

         // Selected tlbid has entries
         //
         TLBPipe_H[TLB_DATA_RD].ArrCtrl[tlb_ps].WrEn    &= (NUM_SETS[`HQM_DEVTLB_PIPE_TLBID(TLB_DATA_RD, tlb_ps)][tlb_ps] > 0);

         // And only for a valid request
         //
         TLBPipe_H[TLB_DATA_RD].ArrCtrl[tlb_ps].WrEn    &= TLBPipeV_H[TLB_DATA_RD];


      end else begin // NUM_PS_SETS[tlb_ps] > 0
      TLBPipe_H[TLB_DATA_RD].ArrCtrl[tlb_ps].WrEn = '0;
      end
   end

   // LRU Update Controls
   //
   // Partial Invalidation should not drive LRUWrEn. It is not needed, as age of valid Way is not changed due to invalidation.
   // If partial invalidation does LRUWrEn, LRU might not able to handle non-mutex HitVec, only harm is LRU Tree corrupts.
   LRU_Lookup_En_H = f_tlb_LRUupdate_en(TLBPipe_H[TLB_LRU_WR_CTRL].Req.Opcode, TLBPipe_H[TLB_LRU_WR_CTRL].Req.Overflow);

    if (TLBPipeV_H[TLB_LRU_WR_CTRL]) begin
        // Initialize LRU's during reset sequence
        //
        priority casez (1'b1)
        TLBPipe_H[TLB_LRU_WR_CTRL].Ctrl.InvalGlb: begin
            for (int tlb_ps = PS_MIN; tlb_ps <= PS_MAX; tlb_ps++) begin
                TLBPipe_H[TLB_LRU_WR_CTRL].ArrCtrl[tlb_ps].LRUWrEn = 1'b1;
            end
        end
        // Lookup hit...update LRU based on hit information
        //
        (LRU_Lookup_En_H & TLBPipe_H[TLB_LRU_WR_CTRL].Info.Hit & ~TLBPipe_H[TLB_LRU_WR_CTRL].Ctrl.Fill): begin
            for (int tlb_ps = PS_MIN; tlb_ps <= PS_MAX; tlb_ps++) begin
                if (TLBPipe_H[TLB_LRU_WR_CTRL].Info.PSSel == tlb_ps) TLBPipe_H[TLB_LRU_WR_CTRL].ArrCtrl[tlb_ps].LRUWrEn =
                                                                     TLBPipe_H[TLB_LRU_WR_CTRL].ArrCtrl[tlb_ps].RdEn;
                else TLBPipe_H[TLB_LRU_WR_CTRL].ArrCtrl[tlb_ps].LRUWrEn = 1'b0;
            end
        end
        // Lookup missed and is being filled....update LRU based on fill information
        //
        (LRU_Lookup_En_H & (FillArrCtrlWrEn[TLB_LRU_WR_CTRL][TLBPipe_H[TLB_LRU_WR_CTRL].Info.EffSize])): begin
            for (int tlb_ps = PS_MIN; tlb_ps <= PS_MAX; tlb_ps++) begin
                if (TLBPipe_H[TLB_LRU_WR_CTRL].Info.EffSize == tlb_ps) TLBPipe_H[TLB_LRU_WR_CTRL].ArrCtrl[tlb_ps].LRUWrEn =
                                                                       TLBPipe_H[TLB_LRU_WR_CTRL].ArrCtrl[tlb_ps].RdEn;
                else TLBPipe_H[TLB_LRU_WR_CTRL].ArrCtrl[tlb_ps].LRUWrEn = 1'b0;
            end
        end
        default: begin
            for (int tlb_ps = PS_MIN; tlb_ps <= PS_MAX; tlb_ps++) begin
                TLBPipe_H[TLB_LRU_WR_CTRL].ArrCtrl[tlb_ps].LRUWrEn = 1'b0;
            end
        end
        endcase
    end else begin
        for (int tlb_ps = PS_MIN; tlb_ps <= PS_MAX; tlb_ps++) begin
            TLBPipe_H[TLB_LRU_WR_CTRL].ArrCtrl[tlb_ps].LRUWrEn = 1'b0;
        end
    end
end

generate
for (g_pipestage = TLB_DATA_RD+1; g_pipestage <= TLB_TAG_WR_CTRL; g_pipestage++) begin  : gen_AtsRspDPErr
  `HQM_DEVTLB_MSFF(AtsRspDPErr[g_pipestage],    AtsRspDPErr[g_pipestage-1],     ClkTLBPipe_H[g_pipestage])
  `HQM_DEVTLB_MSFF(InvDPErrEntry[g_pipestage],  InvDPErrEntry[g_pipestage-1],   ClkTLBPipe_H[g_pipestage])
end
for (g_pipestage = TLB_DATA_RD+1; g_pipestage <= TLB_DATA_WR_CTRL; g_pipestage++) begin  : gen_ReUseTLB
  `HQM_DEVTLB_MSFF(ReUseTLB[g_pipestage],       ReUseTLB[g_pipestage-1],        ClkTLBPipe_H[g_pipestage])
end
for (g_pipestage = TLB_DATA_RD+1; g_pipestage <= TLB_DATA_RD+1; g_pipestage++) begin  : gen_TLBRFDPErr
  `HQM_DEVTLB_MSFF(TLBRFDPErr[g_pipestage],    TLBRFDPErr[g_pipestage-1],     ClkTLBPipe_H[g_pipestage])
end
endgenerate

localparam logic [PS_MAX:PS_MIN] EVICT_SUPP_PS = 3'b001; //evict apply to 4k tlb only
logic [TLB_TAG_WR_CTRL:TLB_TAG_WR_CTRL][PS_MAX:PS_MIN]     InvReUseTLB;

generate
for (g_ps=PS_MIN; g_ps<=PS_MAX; g_ps++) begin : gen_InvReUseTLB
  always_comb begin
     InvReUseTLB[TLB_TAG_WR_CTRL][g_ps] = '0;
     for (int i=1; i<=2; i++) begin
        InvReUseTLB[TLB_TAG_WR_CTRL][g_ps]  |= TLBPipeV_H[TLB_TAG_WR_CTRL+i] &&
                                             (~TLBPipe_H[TLB_TAG_WR_CTRL].Ctrl.DisRdEn[g_ps]) && //the fill itself
                                             TLBPipe_H[TLB_TAG_WR_CTRL+i].Ctrl.InvalDTLB &&  EVICT_SUPP_PS[g_ps] && //evict
                                             (~TLBPipe_H[TLB_TAG_WR_CTRL+i].Ctrl.DisRdEn[g_ps]) &&
                                             (|(TLBPipe_H[TLB_TAG_WR_CTRL].ArrInfo[g_ps].RepVec & TLBPipe_H[TLB_TAG_WR_CTRL+i].ArrInfo[g_ps].RepVec)) &&  //if fill's RepVec (onehot) match with any bit in Evict (evict may have >1 way hit)
                                             (TLBPipe_H[TLB_TAG_WR_CTRL].ArrCtrl[g_ps].SetAddr[`HQM_DEVTLB_LOG2(NUM_PS_SETS[g_ps])-1:0]==TLBPipe_H[TLB_TAG_WR_CTRL+i].ArrCtrl[g_ps].SetAddr[`HQM_DEVTLB_LOG2(NUM_PS_SETS[g_ps])-1:0]);
      end
  end
end
endgenerate


always_comb begin
   TLBPipe_H[TLB_TAG_WR_CTRL]          =  ff_TLBPipe_H[TLB_TAG_WR_CTRL];

   for (int tlb_ps = PS_MIN; tlb_ps <= PS_MAX; tlb_ps++) begin  : Tag_ArrWREn_PS_Lp1
      // Generate a write enable when on a valid fill that isn't already in the array
      //
      TLBPipe_H[TLB_TAG_WR_CTRL].ArrCtrl[tlb_ps].WrEn    &= TLBPipeV_H[TLB_TAG_WR_CTRL];
   end

   for (int tlb_ps = PS_MIN; tlb_ps <= PS_MAX; tlb_ps++) begin  : Tag_ArrWREn_PS_Lp2
      if (NUM_PS_SETS[tlb_ps] > 0) begin    // write only if the arrays has entries
            TLBPipe_H[TLB_TAG_WR_CTRL].ArrCtrl[tlb_ps].ArrWrEn = TLBPipe_H[TLB_TAG_WR_CTRL].ArrCtrl[tlb_ps].WrEn && ~(ReUseTLB[TLB_TAG_WR_CTRL] && ~InvReUseTLB[TLB_TAG_WR_CTRL][tlb_ps]);
      end else begin // NUM_PS_SETS[tlb_ps] > 0
        TLBPipe_H[TLB_TAG_WR_CTRL].ArrCtrl[tlb_ps].ArrWrEn = '0;
      end
    end
end

//=====================================================================================================================
// TLB Data Write (Stage 104)
// Address Cache (DID/GPA -> HPA) DATA Write Control Selection (Stage 104)
//=====================================================================================================================

always_comb begin
   TLBPipe_H[TLB_DATA_WR_CTRL]          =  ff_TLBPipe_H[TLB_DATA_WR_CTRL];

   // Data write controls
   //
   // Should be same as Read controls....with a couple of opportunistic expcetions to save power (reset, inval)
   //
   for (int tlb_ps = PS_MIN; tlb_ps <= PS_MAX; tlb_ps++) begin  : Data_WR_Ctrl_PS_Lp

      // Generate a write enable when on a valid fill that isn't already in the array
      //
      TLBPipe_H[TLB_DATA_WR_CTRL].ArrCtrl[tlb_ps].WrEn    &= TLBPipeV_H[TLB_DATA_WR_CTRL];
      TLBPipe_H[TLB_DATA_WR_CTRL].ArrCtrl[tlb_ps].ArrWrEn &= TLBPipeV_H[TLB_DATA_WR_CTRL];

   end

end


//=====================================================================================================================
// Pipe End...may not be used
//=====================================================================================================================

always_comb begin
   TLBPipe_H[TLB_PIPE_END]          =  ff_TLBPipe_H[TLB_PIPE_END];
end

//=====================================================================================================================
// TLB Output
//=====================================================================================================================


always_comb begin: Iommu_TLB_OUT_Hit_or_Bypass_Steering

   TLBOutReq_nnnH                = TLBPipe_H[TLB_HIT_TO_OUTPUT].Req; // Original Request from TLB to Pw
                                                                                    // Only needed for IOTLB...drive to 0 for the rest
                                                                                    // to ensure synthesis can prune away logic
   TLBOutCtrl_nnnH               = TLBPipe_H[TLB_HIT_TO_OUTPUT].Ctrl;
   TLBOutInfo_nnnH               = TLBPipe_H[TLB_HIT_TO_OUTPUT].Info;

end

`HQM_DEVTLB_MSFF(TLBOutPipeV_nnnH, preTLBOutPipeV_nnnH,    ClkTLBPipeV_H[TLB_HIT_TO_OUTPUT])
`HQM_DEVTLB_MSFF(TLBOutXRspV_nnnH, preTLBOutXRspV_nnnH,    ClkTLBPipeV_H[TLB_HIT_TO_OUTPUT])
`HQM_DEVTLB_MSFF(TLBOutMsProcV_nnnH, preTLBOutMsProcV_nnnH,      ClkTLBPipeV_H[TLB_HIT_TO_OUTPUT])

// Parity output computation
always_comb begin
   for (int tlb_ps = PS_MIN ; tlb_ps <= PS_MAX ; tlb_ps++) begin
      // compute parity error vectors
      // For Parity Detection during all lookup including invalidations (not global) & Fill
      // 
      TLBTagParityErrLog_nnnH[tlb_ps] =  TLBPipeV_H[TLB_TAG_RD+1] 
                                        &  TLBPipe_H[TLB_TAG_RD+1].ArrCtrl[tlb_ps].RdEn 
                                        & (|TLBPipe_H[TLB_TAG_RD+1].ArrInfo[tlb_ps].TagParErr);
      TLBDataParityErrLog_nnnH[tlb_ps] = TLBPipeV_H[TLB_DATA_RD+1]
                                         & TLBPipe_H[TLB_DATA_RD+1].ArrInfo[tlb_ps].Hit
                                         & TLBRFDPErr[TLB_DATA_RD+1];

      // Par poison  (PS_MIN/MAX : 0=4K, 1=2M, 2=1G, 3=0.5T)
      TagParPoison_nnnH[tlb_ps]      =   CrParErrInj_nnnH[tlb_ps+DEVTLB_PARITY_VEC_OFFSET] && 
                                         ((~ParErrOneShot_nnnH) | (~ParErrInjected_nnnH & ParErrOneShot_1nnH));
      DataParPoison_nnnH[tlb_ps]     =   CrParErrInj_nnnH[tlb_ps] && 
                                         ((~ParErrOneShot_nnnH) | (~ParErrInjected_nnnH & ParErrOneShot_1nnH));

      // compute whether an parity error is injected
      // No injection if we don't lookup, or if request is an invalidation
      if (NUM_PS_SETS[tlb_ps] != 0) begin      
         InjectTagParErr_nnnH[tlb_ps]     =   TLBPipe_H[TLB_TAG_WR_CTRL].ArrCtrl[tlb_ps].WrEn 
                                              & ~TLBPipe_H[TLB_TAG_WR_CTRL].Ctrl.InvalDTLB
                                              & ~TLBPipe_H[TLB_TAG_WR_CTRL].Ctrl.InvalGlb
                                              & TagParPoison_nnnH[tlb_ps];

         InjectDataParErr_nnnH[tlb_ps]    =  TLBPipe_H[TLB_DATA_WR_CTRL].ArrCtrl[tlb_ps].ArrWrEn
                                              & ~TLBPipe_H[TLB_DATA_WR_CTRL].Ctrl.InvalDTLB
                                              & ~TLBPipe_H[TLB_DATA_WR_CTRL].Ctrl.InvalGlb
                                              & DataParPoison_nnnH[tlb_ps];
      end
      else begin
         InjectTagParErr_nnnH[tlb_ps]     = '0;
         InjectDataParErr_nnnH[tlb_ps]    = '0;
      end

   end
end

   
always_comb begin
   
   {>>{TLBParityErr_nnnH}}    = {$bits(t_devtlb_cr_parity_err){1'b0}};

   TLBParityErr_nnnH[DEVTLB_IOTLB_250T_PARITY_POS+DEVTLB_PARITY_VEC_OFFSET -:5]   = `HQM_DEVTLB_ZX(TLBTagParityErrLog_nnnH, 5);

   TLBParityErr_nnnH[DEVTLB_IOTLB_250T_PARITY_POS:DEVTLB_IOTLB_4K_PARITY_POS]    = `HQM_DEVTLB_ZX(TLBDataParityErrLog_nnnH, 5);
end   


logic ClkParErr_H;      // Clock for parity error capturing

assign pEn_ClkParErr_H  = (ParErrOneShot_1nnH !=  ParErrOneShot_nnnH)
                          | ResetParErrInjected_nnnH | SetParErrInjected_nnnH | reset;

`HQM_DEVTLB_MAKE_LCB_PWR(ClkParErr_H,  ClkRcb_nnnH, pEn_ClkParErr_H,  1'b0)

// TLB Parity logic can be selectively elaborated
// output for data parity is driven in cycle 104
// output for tag parity is driven in cycle 104

// Parity error injection logic
`HQM_DEVTLB_RST_MSFF(ParErrOneShot_1nnH,  ParErrOneShot_nnnH,  ClkParErr_H, reset)

assign SetParErrInjected_nnnH           =  |{InjectTagParErr_nnnH, InjectDataParErr_nnnH}; //highier priority
assign ResetParErrInjected_nnnH         =  (ParErrOneShot_nnnH & ~ParErrOneShot_1nnH);

`HQM_DEVTLB_RST_MSFF(ParErrInjected_nnnH, (SetParErrInjected_nnnH || (ParErrInjected_nnnH && ~ResetParErrInjected_nnnH)), ClkParErr_H,  reset)

assign TLBParityErr_1nnH          = TLBParityErr_nnnH;

//=====================================================================================================================
// TLB LRU Arrays
//=====================================================================================================================

// Create one array for each combination of page size and tlbid
//
// The LRU is read along with the tag lookup when an fill is specified. The
// results are then staged to the point of the actual fill. Reading it at
// the time of the fill creates a timing path. Reading it early does create
// a window where a new hit might not be reflected in the LRU value but
// that is a reasonable trade-off as fills are infrequent and the liklihood
// of a relevant hit to the same set occurring in the 1-2 cycle window is
// equally low.
//
logic [PS_MAX:PS_MIN] LRURdEn_H;
logic [PS_MAX:PS_MIN] LRURdInvert_H;

assign   DEVTLB_LRU_RdEn_Spec    = TLBPipeV_H[TLB_LRU_RD_CTRL];  
generate
   for (g_ps = PS_MIN; g_ps <= PS_MAX; g_ps++) begin  : LRU_PS_Lp

      assign LRUDisable_Ways[g_ps] = ((`HQM_DEVTLB_PIPE_TLBID(TLB_LRU_RD_CTRL+1, g_ps) < NUM_ARRAYS) & (DEVTLB_PORT_ID == '0))  //spyglass disable W362a //lintra s-W362a
                                       ? Disable_Ways[TLBPipe_H[TLB_LRU_RD_CTRL+1].Req.TlbId][g_ps] : '0;
      //assign LRUDisable_Ways[g_ps] = 2'b01;

      if (NUM_PS_SETS[g_ps] > 0) begin : Array   // Instantiate array only if the arrays has entries
         if (NUM_WAYS > 1) begin : Lru  // Instantiate lru array only if the arrays has multiple ways

            localparam         int SET_ADDR_WIDTH      = `HQM_DEVTLB_LOG2(NUM_PS_SETS[g_ps]);

            assign   LRURdEn_H[g_ps]         =  TLBPipe_H[TLB_LRU_RD_CTRL].ArrCtrl[g_ps].RdEn
                                             &  TLBPipe_H[TLB_LRU_RD_CTRL].Ctrl.Fill
                                             &  (DEVTLB_PORT_ID == '0);   // Qualified by FillEn to save power
            assign   LRURdInvert_H[g_ps]     =  '0; /*TLBPipeV_H[TLB_LRU_RD_CTRL+1]
                                             &  (TLBPipe_H[TLB_LRU_RD_CTRL+1].ArrCtrl[g_ps].WrEn | (|TLBPipe_H[TLB_LRU_RD_CTRL+1].ArrInfo[g_ps].HitVec)) 
                                             &  (TLBPipe_H[TLB_LRU_RD_CTRL].ArrCtrl[g_ps].SetAddr[SET_ADDR_WIDTH-1:0] == TLBPipe_H[TLB_LRU_RD_CTRL+1].ArrCtrl[g_ps].SetAddr[SET_ADDR_WIDTH-1:0])
                                             &  (DEVTLB_PORT_ID == '0); */
            assign   DEVTLB_LRU_RdEn[g_ps]         = LRURdEn_H[g_ps];
            assign   DEVTLB_LRU_Rd_Invert[g_ps]    = LRURdInvert_H[g_ps];
            assign   DEVTLB_LRU_Rd_SetAddr[g_ps]   = (DEVTLB_PORT_ID == '0) 
                                                      ? `HQM_DEVTLB_ZX(TLBPipe_H[TLB_LRU_RD_CTRL].ArrCtrl[g_ps].SetAddr[SET_ADDR_WIDTH-1:0],$bits(T_SETADDR))
                                                      : `HQM_DEVTLB_ZX(1'b0, $bits(T_SETADDR));
            assign   ArrRdLRUWayVec_H[g_ps]        = (DEVTLB_PORT_ID == '0) ? DEVTLB_LRU_Rd_WayVec[g_ps] : '0;
            assign   ArrRdLRUWay2ndVec_H[g_ps]     = (DEVTLB_PORT_ID == '0) ? DEVTLB_LRU_Rd_Way2ndVec[g_ps] : '0;
            assign   DEVTLB_LRU_WrEn[g_ps]         = TLBPipe_H[TLB_LRU_WR_CTRL].ArrCtrl[g_ps].LRUWrEn;
            assign   DEVTLB_LRU_Wr_SetAddr[g_ps]   = `HQM_DEVTLB_ZX(TLBPipe_H[TLB_LRU_WR_CTRL].ArrCtrl[g_ps].SetAddr[SET_ADDR_WIDTH-1:0],$bits(T_SETADDR));
            assign   DEVTLB_LRU_Wr_HitVec[g_ps]    = TLBPipe_H[TLB_LRU_WR_CTRL].ArrInfo[g_ps].HitVec;
            assign   DEVTLB_LRU_Wr_RepVec[g_ps]    = TLBPipe_H[TLB_LRU_WR_CTRL].ArrInfo[g_ps].RepVec;

         end else begin : DIS_LRU
            assign   ArrRdLRUWayVec_H[g_ps]        = 1'b1;
            assign   ArrRdLRUWay2ndVec_H[g_ps]     = 1'b1;
            assign   LRURdEn_H[g_ps]               = '0;
            assign   LRURdInvert_H[g_ps]           = '0;
         end
      end else begin : DIS_ARRAY
         assign   LRURdEn_H[g_ps]               = '0;
         assign   LRURdInvert_H[g_ps]           = '0;
         assign   ArrRdLRUWayVec_H[g_ps]        = '0;
         assign   ArrRdLRUWay2ndVec_H[g_ps]     = '0;
         assign   DEVTLB_LRU_RdEn[g_ps]         = '0;  
         assign   DEVTLB_LRU_Rd_Invert[g_ps]    = '0;
         assign   DEVTLB_LRU_Rd_SetAddr[g_ps]   = '0;
         assign   DEVTLB_LRU_WrEn[g_ps]         = '0;
         assign   DEVTLB_LRU_Wr_SetAddr[g_ps]   = '0;
         assign   DEVTLB_LRU_Wr_HitVec[g_ps]    = '0;
         assign   DEVTLB_LRU_Wr_RepVec[g_ps]    = '0;

      end
   end
endgenerate


//=====================================================================================================================
// FUNCTIONS specific to this TLB context
//=====================================================================================================================

// Function to find the first 1 in a way-vector, starting from the LSB
//
function automatic logic [NUM_WAYS-1:0] f_FindFirstWay (logic [NUM_WAYS-1:0] A);
   // Converted to three-stage and explicit bit-by-bit reversal to satisfy emulation & xprop tools

   logic [NUM_WAYS-1:0] B;
   logic [NUM_WAYS-1:0] C;

   for (int i=0;i<=NUM_WAYS-1;i++) begin
      B[i] = A[NUM_WAYS - 1 - i];
   end

   C = f_FindLastWay(B);

   for (int i=0;i<=NUM_WAYS-1;i++) begin
   B[i] = A[NUM_WAYS - 1 - i];
      f_FindFirstWay[i] = C[NUM_WAYS - 1 - i];
   end

endfunction

// Function to find the Last 1 in a way-vector, starting from the MSB
//The return_port_name compiler directive identifies a return port (z), 
//because functions in Verilog do not have output ports. 
//A return port name must be identified to instantiate the function as a component. 

function automatic logic [NUM_WAYS-1:0] f_FindLastWay (logic [NUM_WAYS-1:0] A);

   //TODO_commented_temporarysynopsys_map_to_operator_LZD_DEC_UNS_OP
   //TODO_commented_temporarysynopsys_return_port_name_Z

   f_FindLastWay = '0;
   for (int i=0;i<=NUM_WAYS-1;i++) begin
      if (A[i]) begin
         f_FindLastWay    = '0;
         f_FindLastWay[i] = 1'b1;
      end
   end

endfunction

//--------------------
//Invalidation at TLB tail
//
always_comb begin
    TLBOutInvTail_nnH = TLBPipeV_H[TLB_INV_TAIL] && (TLBPipe_H[TLB_INV_TAIL].Ctrl.InvalGlb || (TLBPipe_H[TLB_INV_TAIL].Ctrl.InvalDTLB && (TLBPipe_H[TLB_INV_TAIL].Req.Opcode == T_OPCODE'(DEVTLB_OPCODE_DTLB_INV))));
end

//--------------------
// Feedback to TLB Arb
//
localparam int TLB_BLOCK_INFO_STAGE = ZERO_CYCLE_TLB_ARB? TLB_TAG_WR_CTRL: (TLB_TAG_WR_CTRL-1);
always_comb begin
    TLBBlockArbInfo.Fill      = TLBPipeV_H[TLB_BLOCK_INFO_STAGE] && TLBPipe_H[TLB_BLOCK_INFO_STAGE].Ctrl.Fill;
    TLBBlockArbInfo.InvalDTLB = TLBPipeV_H[TLB_BLOCK_INFO_STAGE] && TLBPipe_H[TLB_BLOCK_INFO_STAGE].Ctrl.InvalDTLB; //meant for UARCH_INV
//    TLBBlockArbInfo.WrEn      = '0;
//    for (int tlb_ps=PS_MIN; tlb_ps<=PS_MAX; tlb_ps++) begin
//        TLBBlockArbInfo.WrEn    |= TLBPipe_H[TLB_BLOCK_INFO_STAGE].ArrCtrl[tlb_ps].WrEn;
//    end
//    TLBBlockArbInfo.WrEn      &= TLBPipeV_H[TLB_BLOCK_INFO_STAGE];
//    TLBBlockArbInfo.WrEn      = TLBPipeV_H[TLB_BLOCK_INFO_STAGE] && 
//                                (TLBPipe_H[TLB_BLOCK_INFO_STAGE].Ctrl.Fill || TLBPipe_H[TLB_BLOCK_INFO_STAGE].Ctrl.InvalDTLB);

    TLBBlockArbInfo.TlbId     = TLBID_WIDTH'(`HQM_DEVTLB_PIPE_TLBID(TLB_BLOCK_INFO_STAGE, TLBPipe_H[TLB_BLOCK_INFO_STAGE].Info.EffSize));
    TLBBlockArbInfo.DisRdEn   = TLBPipe_H[TLB_BLOCK_INFO_STAGE].Ctrl.DisRdEn;
end

//=====================================================================================================================
// VISA Signals
//=====================================================================================================================

// "Original" qualifications differ between IOTLB and PWCs/RCC. ColorV is always set in RCC and PWC requests. 
// However, requests can only lookup the RCC/PWCs once (so qualifying Orginal with ~Fill should be adequate)
//
// Note - Due to the Page Fetch Timeout/Redo mechanism of the FSM - it is possible to have multiple "original" RCC/PWC
// lookups. This is a rare event, and the VISA outputs will not be qualified against this scenario.

generate
      // IOTLB any lookup valid
      //
      assign ObsIotlbLkpValid_nnnH       =  f_tlb_lookup_en(TLBPipe_H[TLB_HIT_TO_OUTPUT].Req.Opcode,
                                                            TLBPipe_H[TLB_HIT_TO_OUTPUT].Req.Overflow)  
                                             &  TLBPipeV_H[TLB_HIT_TO_OUTPUT]      
                                             & ~TLBPipe_H[TLB_HIT_TO_OUTPUT].Ctrl.InvalGlb      
                                             & ~TLBPipe_H[TLB_HIT_TO_OUTPUT].Ctrl.InvalDTLB;  

      // IOTLB Original Lookup ID
      if ($bits(ObsIotlbOrgReqID_nnnH) > DEVTLB_REQ_ID_WIDTH) begin : ZERO_PAD
         assign ObsIotlbOrgReqID_nnnH    = `HQM_DEVTLB_ZX(TLBPipe_H[TLB_HIT_TO_OUTPUT].Req.ID,$bits(ObsIotlbOrgReqID_nnnH));
      end else begin : ZERO_PAD_DIS
         assign ObsIotlbOrgReqID_nnnH    = TLBPipe_H[TLB_HIT_TO_OUTPUT].Req.ID[$bits(ObsIotlbOrgReqID_nnnH)-1:0];
      end

      // IOTLB ID
      //
      if ($bits(ObsIotlbID_nnnH) > TLBID_WIDTH) begin : ZERO_PADTLBID
        assign ObsIotlbID_nnnH             =  `HQM_DEVTLB_ZX(TLBPipe_H[TLB_HIT_TO_OUTPUT].Req.TlbId,$bits(ObsIotlbID_nnnH));
      end else begin : ZERO_PADTLBID_DIS
         assign ObsIotlbID_nnnH    = TLBPipe_H[TLB_HIT_TO_OUTPUT].Req.TlbId[$bits(ObsIotlbID_nnnH)-1:0];
      end

      // IOTLB original hit vector
      //
      always_comb begin
         ObsIotlbOrgHitVec_nnnH          = '0;
         for (int tlb_ps = PS_MIN; (tlb_ps <= PS_MAX) && (tlb_ps <= 2); tlb_ps++) begin  : Tag_RD_Ctrl_PS_Lp
            ObsIotlbOrgHitVec_nnnH[tlb_ps] = TLBPipe_H[TLB_HIT_TO_OUTPUT].ArrInfo[tlb_ps].Hit; // valid at ObsIotlbLkpValid_nnnH
         end
      end

      // IOTLB inv valid
      //
      assign ObsIotlbInvValid_nnnH       =  (TLBPipe_H[TLB_HIT_TO_OUTPUT].Ctrl.InvalDTLB || TLBPipe_H[TLB_HIT_TO_OUTPUT].Ctrl.InvalGlb)
                                            &  TLBPipeV_H[TLB_HIT_TO_OUTPUT];

      // IOTLB requested page size
      //
      assign ObsIotlbReqPageSize_nnnH    =  TLBPipe_H[TLB_HIT_TO_OUTPUT].Info.Size;

      // IOTLB filled page size
      //
      assign ObsIotlbFilledPageSize_nnnH =  TLBPipe_H[TLB_HIT_TO_OUTPUT].Info.EffSize;

      //Misc
      //
      assign ObsIotlbMisc_nnnH = {(|TLBPipe_H[TLB_HIT_TO_OUTPUT].ArrInfo[0].TagParErr), ReUseTLB[TLB_HIT_TO_OUTPUT+1]};

endgenerate


//=====================================================================================================================
// ASSERTIONS
//=====================================================================================================================

`ifndef HQM_DEVTLB_SVA_OFF

`HQM_DEVTLB_ASSERTS_RANGE(IOMMU_Param_PS_Illegal, PS_MAX, 0, 4, posedge clk, reset_INST, `HQM_DEVTLB_ERR_MSG("Illegal TLB_PS_MAX value."));

`HQM_DEVTLB_ASSERTS_MUST(IOMMU_Tlb_Param_WrCtrl_after_DataRd, (TLB_LRU_WR_CTRL == TLB_TAG_RD+1), posedge clk, reset_INST, `HQM_DEVTLB_ERR_MSG("static param config"));

generate
   if (DEVTLB_PORT_ID == PORT_0) begin : PORT0
      
      //`DEVTLB_ASSERTS_TRIGGER(DEVTLB_TLB_Fill_Reqs_Always_Receive_WrEn, 
      //   TLBPipeV_H[TLB_TAG_WR_CTRL]
      //   & f_IOMMU_Opcode_is_FILL(TLBPipe_H[TLB_TAG_WR_CTRL].Req.Opcode)
      //   & `DEVTLB_PIPE_TLBID(TLB_TAG_WR_CTRL, TLBPipe_H[TLB_TAG_WR_CTRL].Info.EffSize) < NUM_ARRAYS, 
      //   TLBPipe_H[TLB_TAG_WR_CTRL].ArrCtrl[TLBPipe_H[TLB_TAG_WR_CTRL].Info.EffSize].WrEn, 
      //   posedge clk, reset_INST, 
      //`DEVTLB_ERR_MSG("Fill request did not receive a WrEn."));

      `HQM_DEVTLB_ASSERTS_TRIGGER(DEVTLB_TLB_Fill_Reqs_Receive_Proper_WrEn, 
         TLBPipeV_H[TLB_TAG_WR_CTRL]
         & f_IOMMU_Opcode_is_FILL(TLBPipe_H[TLB_TAG_WR_CTRL].Req.Opcode)
         & (`HQM_DEVTLB_PIPE_TLBID(TLB_TAG_WR_CTRL, TLBPipe_H[TLB_TAG_WR_CTRL].Info.EffSize) < NUM_ARRAYS)
         & ~TLBPipe_H[TLB_TAG_WR_CTRL].Info.R
         & ~TLBPipe_H[TLB_TAG_WR_CTRL].Info.W
         & (ff_TLBPipe_H[TLB_TAG_WR_CTRL].Info.ParityError || // AtsRspDPErr
           ff_TLBPipe_H[TLB_TAG_WR_CTRL].Info.HeaderError), 
         ~TLBPipe_H[TLB_TAG_WR_CTRL].ArrCtrl[TLBPipe_H[TLB_TAG_WR_CTRL].Info.EffSize].WrEn, 
         posedge clk, reset_INST, 
      `HQM_DEVTLB_ERR_MSG("Fill request did not receive a WrEn."));
      
    for (g_ps = PS_MIN; g_ps <= PS_MAX; g_ps++) begin : gen_as_inv_dma_wren_ps 
      `HQM_DEVTLB_ASSERTS_TRIGGER(DEVTLB_TLB_Inv_Reqs_Always_Receive_WrEn, 
         TLBPipeV_H[TLB_TAG_WR_CTRL]
         & f_IOMMU_Opcode_is_Invalidation(TLBPipe_H[TLB_TAG_WR_CTRL].Req.Opcode)
         & TLBPipe_H[TLB_TAG_WR_CTRL].ArrInfo[g_ps].Hit
         & `HQM_DEVTLB_PIPE_TLBID(TLB_TAG_WR_CTRL, g_ps) < NUM_ARRAYS
         & ~(&(TLBPipe_H[TLB_TAG_WR_CTRL].Req.Address[MAX_GUEST_ADDRESS_WIDTH-1:12])) //Invalid Request Address
         , 
         TLBPipe_H[TLB_TAG_WR_CTRL].ArrCtrl[g_ps].WrEn, 
         posedge clk, reset_INST, 
      `HQM_DEVTLB_ERR_MSG("Inv request did not receive a WrEn."));
      `HQM_DEVTLB_ASSERTS_TRIGGER(DEVTLB_TLB_Lookup_Reqs_Never_Receive_WrEn, 
         TLBPipeV_H[TLB_TAG_WR_CTRL]
         & f_IOMMU_Opcode_is_DMA(TLBPipe_H[TLB_TAG_WR_CTRL].Req.Opcode)
         & `HQM_DEVTLB_PIPE_TLBID(TLB_TAG_WR_CTRL, g_ps) < NUM_ARRAYS, 
         ~TLBPipe_H[TLB_TAG_WR_CTRL].ArrCtrl[g_ps].WrEn, 
         posedge clk, reset_INST, 
      `HQM_DEVTLB_ERR_MSG("Inv request did not receive a WrEn."));      
    end

/*hkhor1 inval don't end up as xrsp      
   `HQM_DEVTLB_ASSERTS_TRIGGER(DEVTLB_RESULTS_Inval_Status_Hit, 
      devtlb.xrsp_valid[PORT_0] 
      & f_IOMMU_Opcode_is_Invalidation(devtlb.RESP_NUM_PORTS[PORT_0].devtlb_result.resp_opcode)
      & $past(InvHit_nnnH,TLB_HIT_TO_OUTPUT - TLB_DATA_RD),
      devtlb.RESP_NUM_PORTS[PORT_0].devtlb_result.resp_status == T_STATUS'(DEVTLB_RESP_INV_HIT), 
      posedge clk, reset_INST, 
   `HQM_DEVTLB_ERR_MSG("Entry was invalidated, but response status was incorrect."));

   `HQM_DEVTLB_ASSERTS_TRIGGER(DEVTLB_RESULTS_Inval_Status_Miss, 

      devtlb.xrsp_valid[PORT_0] 
      & f_IOMMU_Opcode_is_Invalidation(devtlb.RESP_NUM_PORTS[PORT_0].devtlb_result.resp_opcode)
      & ~$past(InvHit_nnnH,TLB_HIT_TO_OUTPUT - TLB_DATA_RD),
      devtlb.RESP_NUM_PORTS[PORT_0].devtlb_result.resp_status == T_STATUS'(DEVTLB_RESP_INV_MISS), 
      posedge clk, reset_INST, 
   `HQM_DEVTLB_ERR_MSG("Entry was invalidated, but response status was incorrect."));       */
   end
   
   for (g_ps = PS_MIN; g_ps <= PS_MAX; g_ps++) begin : Assert_PS
      if (NUM_PS_SETS[g_ps] > 0) begin : Assert_Sets
         if (DEVTLB_PORT_ID == PORT_0) begin : PORT0
   
            if(NUM_WAYS >= 1) begin : Assert_Ways
               `HQM_DEVTLB_ASSERTS_TRIGGER( IOMMU_TLB_write_replace_tag_valid_implies_all_ways_valid_or_refresh_of_match, 
                  TLBPipeV_H[TLB_TAG_WR_CTRL]
                  &  TLBPipe_H[TLB_TAG_WR_CTRL].ArrCtrl[g_ps].WrEn
                  & ~&TLBPipe_H[TLB_TAG_WR_CTRL].ArrInfo[g_ps].ValVec    // Vacant way exists
                  & ~TLBPipe_H[TLB_TAG_WR_CTRL].Ctrl.InvalGlb
                  & ~TLBPipe_H[TLB_TAG_WR_CTRL].Ctrl.InvalDTLB,
                  TLBPipe_H[TLB_TAG_WR_CTRL].ArrInfo[g_ps].Hit
                     ? |(TLBPipe_H[TLB_TAG_WR_CTRL].ArrInfo[g_ps].RepVec &  TLBPipe_H[TLB_TAG_WR_CTRL].ArrInfo[g_ps].HitVec)   // Repvec going to matching entry
                     : |(TLBPipe_H[TLB_TAG_WR_CTRL].ArrInfo[g_ps].RepVec & ~TLBPipe_H[TLB_TAG_WR_CTRL].ArrInfo[g_ps].ValVec)   // Repvec going to invalid entry
                  ,
                  posedge clk, reset,
               `HQM_DEVTLB_ERR_MSG("RCCs check: valid way replace while invalid ways still exist"));
   
            end

            // WrEn implies RepVec is onehot unless it is a reset/invalidation.
            `HQM_DEVTLB_ASSERTS_TRIGGER(IOMMU_write_repvec_onehot,
                                 TLBPipeV_H[TLB_TAG_WR_CTRL]
                                 & TLBPipe_H[TLB_TAG_WR_CTRL].ArrCtrl[g_ps].WrEn
                                 & ~TLBPipe_H[TLB_TAG_WR_CTRL].Ctrl.InvalGlb
                                 & ~TLBPipe_H[TLB_TAG_WR_CTRL].Ctrl.InvalDTLB,
                                 $countones(TLBPipe_H[TLB_TAG_WR_CTRL].ArrInfo[g_ps].RepVec) == 1,
               posedge clk, reset_INST, 
            `HQM_DEVTLB_ERR_MSG("TLB tag replacement vector is onehot"));
   
            // WrEn for Tag write and Data Write matches
            `HQM_DEVTLB_ASSERTS_DELAYED_TRIGGER(IOMMU_write_same_tag_and_data_target,
                              TLBPipe_H[TLB_TAG_WR_CTRL].ArrCtrl[g_ps].WrEn & TLBPipeV_H[TLB_TAG_WR_CTRL], 1,
                              TLBPipe_H[TLB_DATA_WR_CTRL].ArrCtrl[g_ps].WrEn & TLBPipeV_H[TLB_DATA_WR_CTRL]
                              & (TLBPipe_H[TLB_DATA_WR_CTRL].ArrInfo[g_ps].RepVec == $past(TLBPipe_H[TLB_TAG_WR_CTRL].ArrInfo[g_ps].RepVec,1)),
               posedge clk, reset_INST, 
            `HQM_DEVTLB_ERR_MSG("Write to tag array must have matching match to data array"));
   
            // WrEn for Data Array must have WrEn for Tag Array
            `HQM_DEVTLB_ASSERTS_TRIGGER(IOMMU_write_data_array_implies_write_tag_array,
                              TLBPipe_H[TLB_DATA_WR_CTRL].ArrCtrl[g_ps].WrEn & TLBPipeV_H[TLB_DATA_WR_CTRL],
                              $past(TLBPipe_H[TLB_TAG_WR_CTRL].ArrCtrl[g_ps].WrEn,1) & $past(TLBPipeV_H[TLB_TAG_WR_CTRL],1),
               posedge clk, reset_INST, 
            `HQM_DEVTLB_ERR_MSG("Write to data array must have been preceded by write to tag array"));
   
            // Writes to the same TLB should be at least 3 cycles apart unless it is a reset/invalidation.
            //    This is only true if requests came from same bank
            //
            // This is implemented as two NEVERS, one for 1 clock apart, another for 2 clocks apart
//hkhor1: TODO to replace with assert (b2b fill |=> duplicated way in a set)
// Camron comfirmed that this assertion is applicable IOMMU, not devtlb. it is to flag unexpected behavior in IOMMU's fill fsm.
/*            `HQM_DEVTLB_ASSERTS_NEVER(IOMMU_no_b2b_tlb_writes1,
               TLBPipe_H[TLB_TAG_WR_CTRL+1].ArrCtrl[g_ps].WrEn & TLBPipeV_H[TLB_TAG_WR_CTRL+1]
               & TLBPipe_H[TLB_TAG_WR_CTRL].ArrCtrl[g_ps].WrEn & TLBPipeV_H[TLB_TAG_WR_CTRL]
               & (TLBPipe_H[TLB_TAG_WR_CTRL].Req.TlbId == TLBPipe_H[TLB_TAG_WR_CTRL+1].Req.TlbId)
               & ~TLBPipe_H[TLB_TAG_WR_CTRL].Ctrl.InvalGlb
               & ~TLBPipe_H[TLB_TAG_WR_CTRL].Ctrl.InvalDTLB,
               posedge clk, reset_INST, 
            `HQM_DEVTLB_ERR_MSG("Due to Fill FSM, should not see b2b writes to the same tlb"));
*/   
            // Should not set WrEn if same lvl cache hits
            `HQM_DEVTLB_ASSERTS_TRIGGER(IOMMU_TLB_WrEn_implies_no_same_lvl_hit,
               TLBPipeV_H[TLB_TAG_WR_CTRL] 
               & TLBPipe_H[TLB_TAG_WR_CTRL].ArrCtrl[g_ps].WrEn 
               & ~TLBPipe_H[TLB_TAG_WR_CTRL].Ctrl.InvalGlb
               & ~TLBPipe_H[TLB_TAG_WR_CTRL].Ctrl.InvalDTLB,
               ~TLBPipe_H[TLB_TAG_WR_CTRL].ArrInfo[g_ps].Hit
               | (TLBPipe_H[TLB_TAG_WR_CTRL].ArrInfo[g_ps].RepVec == TLBPipe_H[TLB_TAG_WR_CTRL].ArrInfo[g_ps].HitVec),
               posedge clk, reset_INST, 
            `HQM_DEVTLB_ERR_MSG("same lvl cache hits should not also have WrEn unless the replacement is to the same way that hit"));
   
            // Writes to the TLB must retain the information from the original fill request
            //
            if (DEVTLB_PASID_SUPP_EN) begin : PASIDInfo_En
               `HQM_DEVTLB_ASSERTS_TRIGGER(IOMMU_tag_write_uses_original_fill_info_with_pasid,
                  TLBPipe_H[TLB_TAG_WR_CTRL].ArrCtrl[g_ps].WrEn & TLBPipeV_H[TLB_TAG_WR_CTRL]
                  & ~TLBPipe_H[TLB_TAG_WR_CTRL].Ctrl.InvalGlb
                  & ~TLBPipe_H[TLB_TAG_WR_CTRL].Ctrl.InvalDTLB
                  &  TLBPipe_H[TLB_TAG_WR_CTRL].Req.PasidV,
                  ((ArrWrTag_H[g_ps].ValidSL |   ArrWrTag_H[g_ps].ValidFL) || InvDPErrEntry[TLB_TAG_WR_CTRL])
                  & (ArrWrTag_H[g_ps].PASID    == $past(TLBPipe_H[TLB_PIPE_START].Req.PASID ,TLB_TAG_WR_CTRL-TLB_PIPE_START))
                  & (ArrWrTag_H[g_ps].BDF      == $past(TLBPipe_H[TLB_PIPE_START].Req.BDF ,TLB_TAG_WR_CTRL-TLB_PIPE_START))
                  & (ArrWrTag_H[g_ps].Address  == $past(TLBPipe_H[TLB_PIPE_START].Req.Address[GAW_LAW_MAX-1:12] & ('1 << (g_ps*9))
                                                                   ,TLB_TAG_WR_CTRL-TLB_PIPE_START))
                  ,posedge clk, reset_INST, 
               `HQM_DEVTLB_ERR_MSG("TLB lookup/fill pipeline should not modify written info"));
            end
            `HQM_DEVTLB_ASSERTS_TRIGGER(IOMMU_TLB_PASID_zero_chk,
               TLBPipeV_H[TLB_TAG_WR_CTRL] && TLBPipe_H[TLB_TAG_WR_CTRL].Ctrl.Fill
               &&  |{TLBPipe_H[TLB_TAG_WR_CTRL].Req.PASID, TLBPipe_H[TLB_TAG_WR_CTRL].Req.PR},
               (TLBPipe_H[TLB_TAG_WR_CTRL].Req.PasidV && DEVTLB_PASID_SUPP_EN),
               posedge clk, reset_INST, 
            `HQM_DEVTLB_ERR_MSG("PASID & PR field should be zero when pasidV=0"));
   
            `HQM_DEVTLB_ASSERTS_TRIGGER(IOMMU_tag_write_uses_original_fill_info,
                     TLBPipeV_H[TLB_TAG_WR_CTRL]
                  &  TLBPipe_H[TLB_TAG_WR_CTRL].ArrCtrl[g_ps].WrEn
                  & ~TLBPipe_H[TLB_TAG_WR_CTRL].Ctrl.InvalGlb
                  & ~TLBPipe_H[TLB_TAG_WR_CTRL].Ctrl.InvalDTLB
                  & ~TLBPipe_H[TLB_TAG_WR_CTRL].Req.PasidV,
                  ((ArrWrTag_H[g_ps].ValidSL | ArrWrTag_H[g_ps].ValidFL) || InvDPErrEntry[TLB_TAG_WR_CTRL])
                  & (ArrWrTag_H[g_ps].BDF      == $past(TLBPipe_H[TLB_PIPE_START].Req.BDF, TLB_TAG_WR_CTRL-TLB_PIPE_START))
                  & (ArrWrTag_H[g_ps].Address  == $past(TLBPipe_H[TLB_PIPE_START].Req.Address[GAW_LAW_MAX-1:12] & ('1 << (g_ps*9))
                                                                   ,TLB_TAG_WR_CTRL-TLB_PIPE_START))
                  ,posedge clk, reset_INST, 
            `HQM_DEVTLB_ERR_MSG("TLB lookup/fill pipeline should not modify written info"));
  
            // FIXME: cdpanirw (17ww35): Update SVA to handle Hit scenario
            `HQM_DEVTLB_ASSERTS_TRIGGER(IOMMU_data_write_uses_original_fill_info,
               TLBPipeV_H[TLB_DATA_WR_CTRL]
               & TLBPipe_H[TLB_DATA_WR_CTRL].ArrCtrl[g_ps].WrEn 
               & ~TLBPipe_H[TLB_DATA_WR_CTRL].Info.Hit 
               & ~TLBPipe_H[TLB_DATA_WR_CTRL].Ctrl.InvalGlb
               & ~TLBPipe_H[TLB_DATA_WR_CTRL].Ctrl.InvalDTLB,
               1'b1 // (ArrWrData_H[g_ps].Parity  == 1'b0)                                                                                          
               & (ArrWrData_H[g_ps].U       == $past(TLBPipe_H[TLB_PIPE_START].Info.U   ,TLB_DATA_WR_CTRL-TLB_PIPE_START))
               & (ArrWrData_H[g_ps].N       == $past(TLBPipe_H[TLB_PIPE_START].Info.N   ,TLB_DATA_WR_CTRL-TLB_PIPE_START))
               & ((ArrWrData_H[g_ps].X       == $past(TLBPipe_H[TLB_PIPE_START].Info.X   ,TLB_DATA_WR_CTRL-TLB_PIPE_START)) | ~ARSP_X_SUPP) 
               & (ArrWrData_H[g_ps].R       == $past(TLBPipe_H[TLB_PIPE_START].Info.R   ,TLB_DATA_WR_CTRL-TLB_PIPE_START))
               & (ArrWrData_H[g_ps].W       == $past(TLBPipe_H[TLB_PIPE_START].Info.W   ,TLB_DATA_WR_CTRL-TLB_PIPE_START))
               & (ArrWrData_H[g_ps].Address == $past(TLBPipe_H[TLB_PIPE_START].Info.Address & ('1 << (g_ps*9)) ,TLB_DATA_WR_CTRL-TLB_PIPE_START))
               & ((ArrWrData_H[g_ps].Memtype == $past(TLBPipe_H[TLB_PIPE_START].Info.Memtype  ,TLB_DATA_WR_CTRL-TLB_PIPE_START)) | ~DEVTLB_PASID_SUPP_EN)
                           ,
               posedge clk, reset_INST, 
            `HQM_DEVTLB_ERR_MSG("TLB lookup/fill pipeline should not modify written info"));
   
            `HQM_DEVTLB_ASSERTS_TRIGGER (IOMMU_tlb_iotlb_inval_occurs,
               TLBPipeV_H[TLB_TAG_WR_CTRL] & TLBPipe_H[TLB_TAG_WR_CTRL].ArrCtrl[g_ps].WrEn 
               & ( TLBPipe_H[TLB_TAG_WR_CTRL].Ctrl.InvalGlb
                   | TLBPipe_H[TLB_TAG_WR_CTRL].Ctrl.InvalDTLB
                 ),
               ~ArrWrTag_H[g_ps].ValidFL,
               posedge clk,
               reset_INST,
            `HQM_DEVTLB_ERR_MSG("IOTLB Invalidation not completed."));
                                                    
/*            `HQM_DEVTLB_ASSERTS_TRIGGER(DEVTLB_tlb_Inval_Has_Proper_Status, 
              TLBPipeV_H[TLB_DATA_RD]
              & f_IOMMU_Opcode_is_Invalidation(TLBPipe_H[TLB_DATA_RD].Req.Opcode),
              ((TLBPipe_H[TLB_DATA_RD].Info.Status == T_STATUS'(DEVTLB_RESP_INV_HIT)) ||
               (TLBPipe_H[TLB_DATA_RD].Info.Status == T_STATUS'(DEVTLB_RESP_INV_MISS))),
              posedge clk, reset_INST,
           `HQM_DEVTLB_ERR_MSG("Inval did not have the proper status."));*/

            `HQM_DEVTLB_ASSERTS_TRIGGER(IOMMU_tlb_write_with_improper_opcode,
                  TLBPipeV_H[TLB_TAG_WR_CTRL] & TLBPipe_H[TLB_TAG_WR_CTRL].ArrCtrl[g_ps].WrEn
                  & ~TLBPipe_H[TLB_TAG_WR_CTRL].Ctrl.InvalGlb
                  & ~TLBPipe_H[TLB_TAG_WR_CTRL].Ctrl.InvalDTLB
                  ,
                  TLBPipe_H[TLB_TAG_WR_CTRL].Req.Opcode == T_OPCODE'(DEVTLB_OPCODE_FILL),
                  posedge clk, reset_INST,
            `HQM_DEVTLB_ERR_MSG("Writes should not occur for bad opcodes"));
         
         end : PORT0
         

         `HQM_DEVTLB_ASSERTS_TRIGGER(IOMMU_tlb_read_with_improper_opcode,
               TLBPipeV_H[TLB_DATA_RD_CTRL]
               &  TLBPipe_H[TLB_DATA_RD_CTRL].ArrCtrl[g_ps].RdEn
               & ~TLBPipe_H[TLB_DATA_RD_CTRL].Ctrl.InvalGlb
               & ~TLBPipe_H[TLB_DATA_RD_CTRL].Ctrl.InvalDTLB
                        ,
               f_IOMMU_Opcode_is_Untranslated(TLBPipe_H[TLB_DATA_RD_CTRL].Req.Opcode)
               |  f_IOMMU_Opcode_is_FILL(TLBPipe_H[TLB_DATA_RD_CTRL].Req.Opcode),
               posedge clk, reset_INST,
         `HQM_DEVTLB_ERR_MSG("Read Hit should not occur for bad opcodes"));
         

         `HQM_DEVTLB_ASSERTS_TRIGGER(IOMMU_Tlb_Corrupt_Request_Can_Not_Fill,
               TLBPipeV_H[TLB_TAG_WR_CTRL]
               & (TLBPipe_H[TLB_TAG_WR_CTRL].Info.Status      == T_STATUS'(DEVTLB_RESP_FAILURE))
               & TLBPipe_H[TLB_TAG_WR_CTRL].Ctrl.Fill && (TLBPipe_H[TLB_TAG_WR_CTRL].Info.EffSize==g_ps) && ~InvDPErrEntry[TLB_TAG_WR_CTRL],
                ~TLBPipe_H[TLB_TAG_WR_CTRL].ArrCtrl[g_ps].WrEn,
            posedge clk, reset_INST, 
         `HQM_DEVTLB_ERR_MSG("IOMMU: Do not Fill a corrupt request"));
         
          `HQM_DEVTLB_ASSERTS_TRIGGER(IOMMU_Tlb_Fill_RW00_Inv_RFDPErr,
                TLBPipeV_H[TLB_TAG_WR_CTRL]
                & TLBPipe_H[TLB_TAG_WR_CTRL].Ctrl.Fill & (TLBPipe_H[TLB_TAG_WR_CTRL].Info.EffSize==g_ps) && InvDPErrEntry[TLB_TAG_WR_CTRL]
                & ~(TLBPipe_H[TLB_TAG_WR_CTRL].Info.HeaderError || AtsRspDPErr[TLB_TAG_WR_CTRL]),
                TLBOutXRspV_nnnH && (TLBOutInfo_nnnH.Status==T_STATUS'(DEVTLB_RESP_HIT_FAULT))
                && TLBPipe_H[TLB_TAG_WR_CTRL].ArrCtrl[g_ps].WrEn
                && ~TLBOutInfo_nnnH.ParityError && ~TLBOutInfo_nnnH.HeaderError,
            posedge clk, reset_INST, 
         `HQM_DEVTLB_ERR_MSG("Entry with Par Err in Data is not replaced correctly"));

          `HQM_DEVTLB_ASSERTS_TRIGGER(IOMMU_Tlb_Fill_notRW00_Replace_RFDPErr,
                TLBPipeV_H[TLB_TAG_WR_CTRL]
                & TLBPipe_H[TLB_TAG_WR_CTRL].Ctrl.Fill & (TLBPipe_H[TLB_TAG_WR_CTRL].Info.EffSize==g_ps) && TLBRFDPErr[TLB_TAG_WR_CTRL]
                & ~TLBPipe_H[TLB_TAG_WR_CTRL].Info.Fault
                & ~(TLBPipe_H[TLB_TAG_WR_CTRL].Info.HeaderError || AtsRspDPErr[TLB_TAG_WR_CTRL]),
                TLBOutXRspV_nnnH && (TLBOutInfo_nnnH.Status==T_STATUS'(DEVTLB_RESP_HIT_VALID))
                && TLBPipe_H[TLB_TAG_WR_CTRL].ArrCtrl[g_ps].WrEn
                && ~TLBOutInfo_nnnH.ParityError && ~TLBOutInfo_nnnH.HeaderError,
            posedge clk, reset_INST, 
         `HQM_DEVTLB_ERR_MSG("Entry with Par Err in Data is not replaced correctly"));

         for (g_id = 0; g_id < NUM_ARRAYS; g_id++) begin : id
            if (NUM_SETS[g_id][g_ps] > 0) begin: ps_ps2
               `HQM_DEVTLB_ASSERTS_MUST(IOMMU_Tlb_NumSets_PowerOf2,
                      ($countones(NUM_SETS[g_id][g_ps]) == 1),
                     posedge clk, reset_INST, `HQM_DEVTLB_ERR_MSG("IOMMU: TLB sizes must be a power of 2"));
                  
            end
         end

         `HQM_DEVTLB_ASSERTS_NEVER(IOMMU_Tlb_HitVec_Mutex,
                              TLBPipeV_H[TLB_TAG_RD]
                              & ($countones(TLBPipe_H[TLB_TAG_RD].ArrInfo[g_ps].HitVec) > 1)
                              & ~TLBPipe_H[TLB_TAG_RD].Ctrl.InvalDTLB,
            posedge clk, reset_INST, 
         `HQM_DEVTLB_ERR_MSG("IOMMU: TLB HitVec must be mutex"));         

      end else begin : Assert_No_Sets
         // no writes or reads to nonexistent TLBs
         `HQM_DEVTLB_ASSERTS_NEVER(IOMMU_write_tag_to_non_existent_tlb_forbidden,
                              TLBPipeV_H[TLB_TAG_WR_CTRL]
                           &  TLBPipe_H[TLB_TAG_WR_CTRL].ArrCtrl[g_ps].WrEn
                           & ~TLBPipe_H[TLB_TAG_WR_CTRL].Ctrl.InvalGlb
                           & ~TLBPipe_H[TLB_TAG_WR_CTRL].Ctrl.InvalDTLB,
                  posedge clk, reset_INST, 
         `HQM_DEVTLB_ERR_MSG("Cannot write to an empty tlb"));

         `HQM_DEVTLB_ASSERTS_NEVER(IOMMU_write_data_to_non_existent_tlb_forbidden,
                              TLBPipeV_H[TLB_DATA_WR_CTRL]
                           &  TLBPipe_H[TLB_DATA_WR_CTRL].ArrCtrl[g_ps].WrEn
                           & ~TLBPipe_H[TLB_DATA_WR_CTRL].Ctrl.InvalGlb
                           & ~TLBPipe_H[TLB_DATA_WR_CTRL].Ctrl.InvalDTLB,
                  posedge clk, reset_INST, 
         `HQM_DEVTLB_ERR_MSG("Cannot write to an empty tlb"));

         // no hits on nonexistent TLBs
         `HQM_DEVTLB_ASSERTS_TRIGGER(IOMMU_hitvect_noneHot_on_non_existent_tlb,
                     f_tlb_lookup_en(TLBPipe_H[TLB_TAG_RD].Req.Opcode, TLBPipe_H[TLB_TAG_RD].Req.Overflow)
                           &  TLBPipeV_H[TLB_TAG_RD]
                           & ~TLBPipe_H[TLB_TAG_RD].Ctrl.InvalGlb
                           & ~TLBPipe_H[TLB_TAG_RD].Ctrl.InvalDTLB,
                        $countones(TLBPipe_H[TLB_TAG_RD].ArrInfo[g_ps].HitVec) == 0,
                  posedge clk, reset_INST, 
         `HQM_DEVTLB_ERR_MSG("RdEn for empty tlb implies hitVec is '0"));

      end
   end
   
   `HQM_DEVTLB_ASSERTS_TRIGGER(IOMMU_TLBRFDPErr_implies_Hit,
        TLBRFDPErr[TLB_DATA_RD] && ~TLBPipe_H[TLB_DATA_RD].Ctrl.InvalDTLB,
        TLBPipe_H[TLB_DATA_RD].Info.Hit,
    posedge clk, reset_INST,
   `HQM_DEVTLB_ERR_MSG("Data parity error cannot occur on TLB miss"));

   `HQM_DEVTLB_ASSERTS_NEVER(IOMMU_Data_Parity_Error_not_valid_on_miss,
      ( (~TLBPipe_H[TLB_DATA_RD].Info.Hit) & (~TLBPipe_H[TLB_DATA_RD].Ctrl.InvalDTLB) &
        (|TLBDataParityError_nnnH)),
   posedge clk, reset_INST,
   `HQM_DEVTLB_ERR_MSG("Data parity error cannot occur on TLB miss"));

   for (g_ps = PS_MIN ; g_ps <= PS_MAX ; g_ps++) begin : No_Array
      for (g_id = 0; g_id < NUM_ARRAYS; g_id++) begin : id
         if (NUM_SETS[g_id][g_ps] == 0) begin: no_hit
            `HQM_DEVTLB_ASSERTS_NEVER( IOMMU_TLB_Should_not_Hit_when_array_does_not_exist,
                         TLBPipeV_H[TLB_HIT_TO_OUTPUT]
                     &   (`HQM_DEVTLB_PIPE_TLBID(TLB_HIT_TO_OUTPUT, g_ps) == g_id)
                     &    TLBPipe_H[TLB_HIT_TO_OUTPUT].ArrInfo[g_ps].Hit
                     &    TLBPipe_H[TLB_HIT_TO_OUTPUT].Info.Hit
                     &   ~TLBPipe_H[TLB_HIT_TO_OUTPUT].Ctrl.Fill
                     &   (TLBPipe_H[TLB_HIT_TO_OUTPUT].Info.PSSel == g_ps),
                     posedge clk, reset_INST,
                     `HQM_DEVTLB_ERR_MSG("TLBPipe Hit non-existant array"));
         end
      end
   end
endgenerate

// Parity related assertions
//

`HQM_DEVTLB_ASSERTS_NEVER(IOMMU_Parity_Error_not_valid,
   ( (~TLBPipeV_H[TLB_TAG_RD+1] & |TLBTagParityErrLog_nnnH)
   | (~TLBPipeV_H[TLB_DATA_RD+1] 
     &  (|TLBDataParityErrLog_nnnH) 
   )),
   posedge clk, reset_INST,
   `HQM_DEVTLB_ERR_MSG("Parity error occurred in an invalid pipe transaction"));

//`DEVTLB_ASSERTS_TRIGGER(IOMMU_ParErrObs_reset_correctly,
//                        ParErrInjected_nnnH & ParErrOneShot_nnnH & ~ParErrOneShot_1nnH,
//                        ResetParErrInjected_nnnH ##2 ~ParErrInjected_nnnH,
//                        posedge clk,
//                        reset_INST,
//                        `DEVTLB_ERR_MSG("ParErrObs is not reset correctly")
//);

// FIXME: Uncomment when support for parity error injection added
//
generate
//if (DEVTLB_PASID_SUPP_EN) begin : PASID_EN
if (  (NUM_PS_SETS[3] > 0) 
   || (NUM_PS_SETS[2] > 0) 
   || (NUM_PS_SETS[1] > 0) 
   || (NUM_PS_SETS[0] > 0)) begin : Array_Exists // Can only encounter a parity error if a cache exists

`HQM_DEVTLB_ASSERTS_TRIGGER(IOMMU_At_most_one_parity_error_in_one_shot_mode,
                       (ParErrOneShot_nnnH & ParErrOneShot_1nnH & ParErrInjected_nnnH) , 
                       {InjectTagParErr_nnnH , InjectDataParErr_nnnH} == 0,
                       posedge clk,
                       reset_INST,
                       `HQM_DEVTLB_ERR_MSG("More than one parity error is injected in one-shot mode"));

if (DEVTLB_PARITY_EN) begin : gen_PARITY_EN
`HQM_DEVTLB_COVERS(IOMMU_ParErrInjected_oneshot,
                       ParErrInjected_nnnH && ParErrOneShot_1nnH,
                       posedge clk,
                       reset_INST,
                       `HQM_DEVTLB_COVER_MSG("Par Err Injected"));

`HQM_DEVTLB_COVERS(IOMMU_InjectTagParErr_oneshot,
                       InjectTagParErr_nnnH && ParErrOneShot_1nnH,
                       posedge clk,
                       reset_INST,
                       `HQM_DEVTLB_COVER_MSG("Injecting Tag Par Err"));

`HQM_DEVTLB_COVERS(IOMMU_InjectDataParErr_oneshot,
                       InjectDataParErr_nnnH && ParErrOneShot_1nnH,
                       posedge clk,
                       reset_INST,
                       `HQM_DEVTLB_COVER_MSG("Injecting Data Par Err"));
end //  : gen_PARITY_EN
end
//end

// Parity error injection assertions
// NOTE: the indexes below reflect currently supported page sizes -- these
// will need to change as more page sizes are supported.
 
for (g_ps = PS_MIN ; g_ps <= PS_MAX ; g_ps++) begin : ASSERT_TLB_PARITY
if (NUM_PS_SETS[g_ps] != 0) begin : PS_ENTRY

`HQM_DEVTLB_ASSERTS_TRIGGER(IOMMU_One_shot_data_parity_error_injection,
                        TLBPipeV_H[TLB_DATA_WR_CTRL] 
                        & TLBPipe_H[TLB_DATA_WR_CTRL].ArrCtrl[g_ps].ArrWrEn
                        & CrParErrInj_nnnH[g_ps]
                        & (~ParErrInjected_nnnH & ParErrOneShot_1nnH)
                        & ~TLBPipe_H[TLB_DATA_WR_CTRL].Ctrl.InvalDTLB
                        & ~TLBPipe_H[TLB_DATA_WR_CTRL].Ctrl.InvalGlb,
                        |InjectDataParErr_nnnH,
                        posedge clk,
                        reset_INST,
                        `HQM_DEVTLB_ERR_MSG("One-shot data parity error injection is broken")
);

`HQM_DEVTLB_ASSERTS_TRIGGER(IOMMU_One_shot_tag_parity_error_injection,
                        TLBPipeV_H[TLB_TAG_WR_CTRL] 
                        & TLBPipe_H[TLB_TAG_WR_CTRL].ArrCtrl[g_ps].WrEn 
                        & CrParErrInj_nnnH[g_ps+DEVTLB_PARITY_VEC_OFFSET]
                        & (~ParErrInjected_nnnH & ParErrOneShot_1nnH)
                        & ~TLBPipe_H[TLB_TAG_WR_CTRL].Ctrl.InvalDTLB
                        & ~TLBPipe_H[TLB_TAG_WR_CTRL].Ctrl.InvalGlb,
                        |InjectTagParErr_nnnH,
                        posedge clk,
                        reset_INST,
                        `HQM_DEVTLB_ERR_MSG("One-shot tag parity error injection is broken")
);

    `HQM_DEVTLB_ASSERTS_TRIGGER(IOMMU_Iotlb_inject_tag_parity_err_continuous_mode,
                          TLBPipeV_H[TLB_TAG_WR_CTRL]
                          && TLBPipe_H[TLB_TAG_WR_CTRL].ArrCtrl[g_ps].WrEn 
                          && ~ParErrOneShot_nnnH 
                          && CrParErrInj_nnnH[DEVTLB_IOTLB_4K_PARITY_POS+DEVTLB_PARITY_VEC_OFFSET+g_ps] 
                          && ~TLBPipe_H[TLB_TAG_WR_CTRL].Ctrl.InvalDTLB
                          && ~TLBPipe_H[TLB_TAG_WR_CTRL].Ctrl.InvalGlb,
                          |InjectTagParErr_nnnH
                          ,
                          posedge clk,
                          reset_INST,
                          `HQM_DEVTLB_ERR_MSG("Inject Iotlb tag parity error in continous mode")
    );

    `HQM_DEVTLB_ASSERTS_TRIGGER(IOMMU_Iotlb_inject_data_parity_err_continuous_mode,
                          ~ParErrOneShot_nnnH 
                          && TLBPipeV_H[TLB_DATA_WR_CTRL] 
                          && TLBPipe_H[TLB_DATA_WR_CTRL].ArrCtrl[g_ps].ArrWrEn
                          && CrParErrInj_nnnH[DEVTLB_IOTLB_4K_PARITY_POS+g_ps] 
                          && ~TLBPipe_H[TLB_DATA_WR_CTRL].Ctrl.InvalDTLB
                          && ~TLBPipe_H[TLB_DATA_WR_CTRL].Ctrl.InvalGlb,
                          |InjectDataParErr_nnnH,
                          posedge clk,
                          reset_INST,
                          `HQM_DEVTLB_ERR_MSG("Inject Iotlb data parity error in continous mode")
    );

      end
end : ASSERT_TLB_PARITY



// Verify that the outputs of the RF blackbox match the reference latch array when RF mode is enabled

for(g_way=0; g_way<NUM_WAYS; g_way++) begin: rf_way

   if (ARRAY_STYLE[0] == ARRAY_RF) begin: rf_sva_ps0
      if (NUM_PS_SETS[0] > 0) begin : PS_0_ENTRY
            `HQM_DEVTLB_ASSERTS_DELAYED_TRIGGER(IOMMU_RF_Tag_Read_Matches_Internal_Reference,
                  TLBPipe_H[TLB_TAG_RD_CTRL].ArrCtrl[0].RdEn &&
                  !(TLBPipe_H[TLB_TAG_WR_CTRL].ArrCtrl[0].WrEn &&
                  (DEVTLB_Tag_Rd_Addr[0] == DEVTLB_Tag_Wr_Addr[0])),
                  READ_LATENCY,
                  (RF_PS0_Tag_RdData[g_way] >> (`HQM_DEVTLB_TLB_SET_MSB(NUM_SETS,`HQM_DEVTLB_PIPE_TLBID(TLB_TAG_RD, 0),0)-12+1)) ==
                  (ArrRdTagInt_H[0][g_way] >> (0*9) + (`HQM_DEVTLB_TLB_SET_MSB(NUM_SETS,`HQM_DEVTLB_PIPE_TLBID(TLB_TAG_RD, 0),0)-12+1)),
                  posedge clk, reset_INST, `HQM_DEVTLB_ERR_MSG("Value from Tag RF does not match internal reference array output"));

            `HQM_DEVTLB_ASSERTS_DELAYED_TRIGGER(IOMMU_RF_Data_Read_Matches_Internal_Reference,
                  TLBPipe_H[TLB_DATA_RD_CTRL].ArrCtrl[0].RdEn &&
                  !(TLBPipe_H[TLB_DATA_WR_CTRL].ArrCtrl[0].WrEn &&
                  (DEVTLB_Data_Rd_Addr[0] == DEVTLB_Data_Wr_Addr[0])),
                  READ_LATENCY,
                  RF_PS0_Data_RdData[g_way] == ArrRdDataInt_H[0][g_way],
                  posedge clk, reset_INST, `HQM_DEVTLB_ERR_MSG("Value from Data RF does not match internal reference array output"));
      end
   end

   if (ARRAY_STYLE[1] == ARRAY_RF) begin: rf_sva_ps1
      if (NUM_PS_SETS[1] > 0) begin : PS_1_ENTRY 
            //Exclude unused Tag field from this checking
           `HQM_DEVTLB_ASSERTS_DELAYED_TRIGGER(IOMMU_RF_Tag_Read_Matches_Internal_Reference,
                  TLBPipe_H[TLB_TAG_RD_CTRL].ArrCtrl[1].RdEn &&
                  !(TLBPipe_H[TLB_TAG_WR_CTRL].ArrCtrl[1].WrEn &&
                  (DEVTLB_Tag_Rd_Addr[1] == DEVTLB_Tag_Wr_Addr[1])),
                  READ_LATENCY,
                  (RF_PS1_Tag_RdData[g_way] >> (`HQM_DEVTLB_TLB_SET_MSB(NUM_SETS,`HQM_DEVTLB_PIPE_TLBID(TLB_TAG_RD, 1),1)-12+1)) ==
                  (ArrRdTagInt_H[1][g_way] >> (1*9) + (`HQM_DEVTLB_TLB_SET_MSB(NUM_SETS,`HQM_DEVTLB_PIPE_TLBID(TLB_TAG_RD, 1),1)-12+1)),
                  posedge clk, reset_INST, `HQM_DEVTLB_ERR_MSG("Value from Tag RF does not match internal reference array output"));

            `HQM_DEVTLB_ASSERTS_DELAYED_TRIGGER(IOMMU_RF_Data_Read_Matches_Internal_Reference,
                  TLBPipe_H[TLB_DATA_RD_CTRL].ArrCtrl[1].RdEn &&
                  !(TLBPipe_H[TLB_DATA_WR_CTRL].ArrCtrl[1].WrEn &&
                  (DEVTLB_Data_Rd_Addr[1] == DEVTLB_Data_Wr_Addr[1])),
                  READ_LATENCY,
                  `HQM_DEVTLB_ZX(RF_PS1_Data_RdData[g_way],$bits(ArrRdData_H[1][g_way])) << 9 == ArrRdDataInt_H[1][g_way],
                  posedge clk, reset_INST, `HQM_DEVTLB_ERR_MSG("Value from Data RF does not match internal reference array output"));
      end
   end

   if (ARRAY_STYLE[2] == ARRAY_RF) begin: rf_sva_ps2
      if (NUM_PS_SETS[2] > 0) begin : PS_2_ENTRY    
            `HQM_DEVTLB_ASSERTS_DELAYED_TRIGGER(IOMMU_RF_Tag_Read_Matches_Internal_Reference,
                  TLBPipe_H[TLB_TAG_RD_CTRL].ArrCtrl[2].RdEn &&
                  !(TLBPipe_H[TLB_TAG_WR_CTRL].ArrCtrl[2].WrEn &&
                  (DEVTLB_Tag_Rd_Addr[2] == DEVTLB_Tag_Wr_Addr[2])),
                  READ_LATENCY,
                  (RF_PS2_Tag_RdData[g_way] >> (`HQM_DEVTLB_TLB_SET_MSB(NUM_SETS,`HQM_DEVTLB_PIPE_TLBID(TLB_TAG_RD, 2),2)-12+1)) == 
                  (ArrRdTagInt_H[2][g_way] >> (2*9) + (`HQM_DEVTLB_TLB_SET_MSB(NUM_SETS,`HQM_DEVTLB_PIPE_TLBID(TLB_TAG_RD, 2),2)-12+1)),
                  posedge clk, reset_INST, `HQM_DEVTLB_ERR_MSG("Value from Tag RF does not match internal reference array output"));

            `HQM_DEVTLB_ASSERTS_DELAYED_TRIGGER(IOMMU_RF_Data_Read_Matches_Internal_Reference,
                  TLBPipe_H[TLB_DATA_RD_CTRL].ArrCtrl[2].RdEn &&
                  !(TLBPipe_H[TLB_DATA_WR_CTRL].ArrCtrl[2].WrEn &&
                  (DEVTLB_Data_Rd_Addr[2] == DEVTLB_Data_Wr_Addr[2])),
                  READ_LATENCY,
                  `HQM_DEVTLB_ZX(RF_PS2_Data_RdData[g_way],$bits(ArrRdData_H[2][g_way])) << 18 == ArrRdDataInt_H[2][g_way],
                  posedge clk, reset_INST, `HQM_DEVTLB_ERR_MSG("Value from Data RF does not match internal reference array output"));
      end
   end

   if (ARRAY_STYLE[3] == ARRAY_RF) begin: rf_sva_ps3
      if (NUM_PS_SETS[3] > 0) begin : PS_3_ENTRY   
            `HQM_DEVTLB_ASSERTS_DELAYED_TRIGGER(IOMMU_RF_Tag_Read_Matches_Internal_Reference,
                  TLBPipe_H[TLB_TAG_RD_CTRL].ArrCtrl[3].RdEn &&
                  !(TLBPipe_H[TLB_TAG_WR_CTRL].ArrCtrl[3].WrEn &&
                  (DEVTLB_Tag_Rd_Addr[3] == DEVTLB_Tag_Wr_Addr[3])),
                  READ_LATENCY,
                  (RF_PS3_Tag_RdData[g_way] >> (`HQM_DEVTLB_TLB_SET_MSB(NUM_SETS,`HQM_DEVTLB_PIPE_TLBID(TLB_TAG_RD, 3),3)-12+1)) == 
                  (ArrRdTagInt_H[3][g_way] >> (3*9) + (`HQM_DEVTLB_TLB_SET_MSB(NUM_SETS,`HQM_DEVTLB_PIPE_TLBID(TLB_TAG_RD, 3),3)-12+1)),
                  posedge clk, reset_INST, `HQM_DEVTLB_ERR_MSG("Value from Tag RF does not match internal reference array output"));

            `HQM_DEVTLB_ASSERTS_DELAYED_TRIGGER(IOMMU_RF_Data_Read_Matches_Internal_Reference,
                  TLBPipe_H[TLB_DATA_RD_CTRL].ArrCtrl[3].RdEn &&
                  !(TLBPipe_H[TLB_DATA_WR_CTRL].ArrCtrl[3].WrEn &&
                  (DEVTLB_Data_Rd_Addr[3] == DEVTLB_Data_Wr_Addr[3])),
                  READ_LATENCY,
                  `HQM_DEVTLB_ZX(RF_PS3_Data_RdData[g_way],$bits(ArrRdData_H[3][g_way])) << 27 == ArrRdDataInt_H[3][g_way],
                  posedge clk, reset_INST, `HQM_DEVTLB_ERR_MSG("Value from Data RF does not match internal reference array output"));
end
   end

   if (ARRAY_STYLE[4] == ARRAY_RF) begin: rf_sva_ps4
      if (NUM_PS_SETS[4] > 0) begin : PS_4_ENTRY 
            `HQM_DEVTLB_ASSERTS_DELAYED_TRIGGER(IOMMU_RF_Tag_Read_Matches_Internal_Reference,
                  TLBPipe_H[TLB_TAG_RD_CTRL].ArrCtrl[4].RdEn &&
                  !(TLBPipe_H[TLB_TAG_WR_CTRL].ArrCtrl[4].WrEn &&
                  (DEVTLB_Tag_Rd_Addr[4] == DEVTLB_Tag_Wr_Addr[4])),
                  READ_LATENCY,
                  (RF_PS4_Tag_RdData[g_way] >> `HQM_DEVTLB_TLB_SET_MSB(NUM_SETS,`HQM_DEVTLB_PIPE_TLBID(TLB_TAG_RD, 4),4)-12+1) == 
                  (ArrRdTagInt_H[4][g_way] >> (4*9) + (`HQM_DEVTLB_TLB_SET_MSB(NUM_SETS,`HQM_DEVTLB_PIPE_TLBID(TLB_TAG_RD, 4),4)-12+1)),
                  posedge clk, reset_INST, `HQM_DEVTLB_ERR_MSG("Value from Tag RF does not match internal reference array output"));

            `HQM_DEVTLB_ASSERTS_DELAYED_TRIGGER(IOMMU_RF_Data_Read_Matches_Internal_Reference,
                  TLBPipe_H[TLB_DATA_RD_CTRL].ArrCtrl[4].RdEn &&
                  !(TLBPipe_H[TLB_DATA_WR_CTRL].ArrCtrl[4].WrEn &&
                  (DEVTLB_Data_Rd_Addr[4] == DEVTLB_Data_Wr_Addr[4])),
                  READ_LATENCY,
                  `HQM_DEVTLB_ZX(RF_PS4_Data_RdData[g_way],$bits(ArrRdData_H[4][g_way])) << 36 == ArrRdDataInt_H[4][g_way],
                  posedge clk, reset_INST, `HQM_DEVTLB_ERR_MSG("Value from Data RF does not match internal reference array output"));
end
   end
end

endgenerate
      
//setaddr checks
generate
for (g_ps = PS_MIN; g_ps <= PS_MAX; g_ps++) begin : gen_as_setaddr_checks
   `HQM_DEVTLB_ASSERTS_TRIGGER( DEVTLB_IOTLB_RdSetAddr_checks,
        TLBPipe_H[TLB_TAG_RD_CTRL].ArrCtrl[g_ps].RdEn,
        ((SetAddr_H[g_ps]-TlbSetAddrBase[`HQM_DEVTLB_PIPE_TLBID(TLB_TAG_RD_CTRL, g_ps)][g_ps]) <
          NUM_SETS[`HQM_DEVTLB_PIPE_TLBID(TLB_TAG_RD_CTRL, g_ps)][g_ps]),
        posedge clk, reset,
    `HQM_DEVTLB_ERR_MSG("wrong SetAddr"));
end
endgenerate

// IOTLB Data Tag Parity assertions
generate
   for (g_ps = PS_MIN; g_ps <= PS_MAX; g_ps++) begin : Assert_PS_dataparity
         if (NUM_PS_SETS[g_ps] > 0) begin : Assert_Sets
            for(g_way=0; g_way<NUM_WAYS; g_way++) begin : Assert_Ways
               `HQM_DEVTLB_ASSERTS_TRIGGER( DEVTLB_IOTLB_calculates_proper_dataparity,
                  TLBPipeV_H[TLB_DATA_RD] 
                  & $past(FullMatch[g_ps][g_way],1)
                  & (TLBPipe_H[TLB_DATA_RD].Info.PSSel == g_ps)
                  & TLBPipe_H[TLB_DATA_RD].ArrInfo[g_ps].HitVec[g_way]
                  & (TLBDataParityError_nnnH[g_ps] && ~AtsRspDPErr[TLB_DATA_RD])
                  & ~TLBPipe_H[TLB_DATA_RD].Ctrl.InvalGlb
                  & ~TLBPipe_H[TLB_DATA_RD].Ctrl.InvalDTLB,
              `HQM_DEVTLB_PARITY_CHECK(ArrRdData_H[g_ps][g_way].Parity, {                    ArrRdData_H[g_ps][g_way].U, 
                                                                                         ArrRdData_H[g_ps][g_way].N,
                                           ARSP_X_SUPP                                ?  ArrRdData_H[g_ps][g_way].X      : 1'b0,
                                                                                         ArrRdData_H[g_ps][g_way].R,
                                                                                         ArrRdData_H[g_ps][g_way].W,
                                           (DEVTLB_PASID_SUPP_EN & DEVTLB_MEMTYPE_EN) ?  ArrRdData_H[g_ps][g_way].Memtype: {(DEVTLB_MEMTYPE_WIDTH){1'b0}},
                                                                                         ArrRdData_H[g_ps][g_way].Priv_Data,
                                           (                                             ArrRdData_H[g_ps][g_way].Address & ('1 << (g_ps*9))) }, ~CrParErrInj_nnnH.disable_iotlb_parityerror)
                  == ~TLBDataParityError_nnnH[g_ps],
                  posedge clk, reset,
                  `HQM_DEVTLB_ERR_MSG("IOTLB Data Parity Calculation Mismatch"));

               `HQM_DEVTLB_ASSERTS_TRIGGER( DEVTLB_IOTLB_calculates_proper_tagparity,
                  TLBPipeV_H[TLB_TAG_RD+1] 
                      &   TLBPipe_H[TLB_TAG_RD+1].ArrInfo[g_ps].TagParErr[g_way]
                      &  ~TLBPipe_H[TLB_TAG_RD+1].Ctrl.InvalGlb
                      &  $past(FullMatch[g_ps][g_way],1),
              ~`HQM_DEVTLB_PARITY_CHECK($past(ArrRdTag_H[g_ps][g_way].Parity), $past(ArrRdTagP_H[g_ps][g_way]), ~CrParErrInj_nnnH.disable_iotlb_parityerror) & TLBTagParityErrLog_nnnH[g_ps],
                      posedge clk, reset,
                      `HQM_DEVTLB_ERR_MSG("IOTLB Tag Parity Calculation Mismatch"));

               `HQM_DEVTLB_ASSERTS_DELAYED_TRIGGER( DEVTLB_IOTLB_tagparity_repvec,
                  TLBPipeV_H[TLB_TAG_RD] 
                      &  TLBPipe_H[TLB_TAG_RD].ArrInfo[g_ps].TagParErr[g_way]
                      &  ((TLBPipe_H[TLB_TAG_RD].Ctrl.Fill &  (TLBPipe_H[TLB_TAG_RD].Info.EffSize==g_ps)) || 
                          (TLBPipe_H[TLB_TAG_RD].Ctrl.InvalDTLB & ~TLBPipe_H[TLB_TAG_RD_CTRL].Ctrl.DisRdEn[g_ps]))
                      &  FullMatch[g_ps][g_way],
                      TLB_TAG_WR_CTRL-TLB_TAG_RD,
                      DEVTLB_Tag_WrEn[g_ps]? DEVTLB_Tag_Wr_Way[g_ps][g_way] :1'b1,
                      posedge clk, reset,
                      `HQM_DEVTLB_ERR_MSG("Matching way with Tag Parity is not replaced."));

            end // end Assert_Ways
         end // end Assert_Sets
   end  // end Assert_PS_dataparity
endgenerate


//IOTLB Unique Tag assertions
// IOTLB Array Assertions
generate
         for(g_ps=PS_MIN; g_ps<=PS_MAX; g_ps++) begin : PS
            // TLBs with no sets should be ignored
            if (NUM_PS_SETS[g_ps] > 0) begin : IF_SETS  
                  for(g_way=0; g_way<NUM_WAYS; g_way++) begin : WAYS
   
                     // Comparing 2 ways in a IOTLB set, the {BDF,Address} combination must be different, with parity considerations
                     for (genvar g_way2 = g_way+1; g_way2<=NUM_WAYS-1; g_way2++) begin : WAYS_2
                        `HQM_DEVTLB_ASSERTS_TRIGGER( IOMMU_TLB_IOTLB_Tag_Addr_unique_validSL,
                           ArrRdTag_H[g_ps][g_way].ValidSL && ~ArrRdTag_H[g_ps][g_way].ValidFL   
                           && ArrRdTag_H[g_ps][g_way2].ValidSL && ~ArrRdTag_H[g_ps][g_way2].ValidFL              
                              && ~TLBPipe_H[TLB_TAG_RD].Ctrl.InvalGlb
                              && ~TLBPipe_H[TLB_TAG_RD].Ctrl.InvalDTLB
                              && TLBPipe_H[TLB_TAG_RD].ArrCtrl[g_ps].RdEn
                              && TLBPipeV_H[TLB_TAG_RD]
                           // Check parity only on actual array read data instead of normal pipeline data that mixes array read and input request content
                           && `HQM_DEVTLB_PARITY_CHECK(ArrRdTag_H[g_ps][g_way].Parity, (ArrRdTag_H[g_ps][g_way]  & TagMask_H[TLB_TAG_RD][`HQM_DEVTLB_PIPE_TLBID(TLB_TAG_RD, g_ps)][g_ps]), ~CrParErrInj_nnnH.disable_iotlb_parityerror )
                           && `HQM_DEVTLB_PARITY_CHECK(ArrRdTag_H[g_ps][g_way2].Parity,(ArrRdTag_H[g_ps][g_way2] & TagMask_H[TLB_TAG_RD][`HQM_DEVTLB_PIPE_TLBID(TLB_TAG_RD, g_ps)][g_ps]), ~CrParErrInj_nnnH.disable_iotlb_parityerror )
                           ,
                           {ArrRdTag_H[g_ps][g_way].BDF,
                           ArrRdTag_H[g_ps][g_way].Address & TagMask_H[TLB_TAG_RD][`HQM_DEVTLB_PIPE_TLBID(TLB_TAG_RD, g_ps)][g_ps].Address} 
                              !=  
                           {ArrRdTag_H[g_ps][g_way2].BDF,
                           ArrRdTag_H[g_ps][g_way2].Address & TagMask_H[TLB_TAG_RD][`HQM_DEVTLB_PIPE_TLBID(TLB_TAG_RD, g_ps)][g_ps].Address},
                           posedge clk, reset,
                        `HQM_DEVTLB_ERR_MSG("Tag is unique"));
   
                        if (DEVTLB_PASID_SUPP_EN) begin : PASID_EN2
                        `HQM_DEVTLB_ASSERTS_TRIGGER( IOMMU_TLB_IOTLB_Tag_Addr_unique_validFL,
                           ArrRdTag_H[g_ps][g_way].ValidFL  
                          && ~TLBPipe_H[TLB_TAG_RD].Ctrl.InvalGlb
                          && ~TLBPipe_H[TLB_TAG_RD].Ctrl.InvalDTLB
                              && TLBPipe_H[TLB_TAG_RD].ArrCtrl[g_ps].RdEn  //To check only on read 
                              && TLBPipeV_H[TLB_TAG_RD] 
                           && ArrRdTag_H[g_ps][g_way2].ValidFL               
                           // Check parity only on actual array read data instead of normal pipeline data that mixes array read and input request content
                           && `HQM_DEVTLB_PARITY_CHECK(ArrRdTag_H[g_ps][g_way].Parity, (ArrRdTag_H[g_ps][g_way]  & TagMask_H[TLB_TAG_RD][`HQM_DEVTLB_PIPE_TLBID(TLB_TAG_RD, g_ps)][g_ps]), ~CrParErrInj_nnnH.disable_iotlb_parityerror )
                           && `HQM_DEVTLB_PARITY_CHECK(ArrRdTag_H[g_ps][g_way2].Parity,(ArrRdTag_H[g_ps][g_way2] & TagMask_H[TLB_TAG_RD][`HQM_DEVTLB_PIPE_TLBID(TLB_TAG_RD, g_ps)][g_ps]), ~CrParErrInj_nnnH.disable_iotlb_parityerror )
                           ,
                           {ArrRdTag_H[g_ps][g_way].BDF, 
                           ArrRdTag_H[g_ps][g_way].PASID, 
                           ArrRdTag_H[g_ps][g_way].PR, 
                           ArrRdTag_H[g_ps][g_way].Address} 
                              !=  
                           {ArrRdTag_H[g_ps][g_way2].BDF, 
                           ArrRdTag_H[g_ps][g_way2].PASID, 
                           ArrRdTag_H[g_ps][g_way2].PR, 
                           ArrRdTag_H[g_ps][g_way2].Address},
                           posedge clk, reset,
                        `HQM_DEVTLB_ERR_MSG("Tag is unique"));
                        end
                     end //end WAYS2
   
                      `HQM_DEVTLB_ASSERTS_TRIGGER( IOMMU_TLB_IOTLB_Tag_FL_cleared_suppress_PASID, 
                          TLBPipe_H[TLB_TAG_RD].ArrCtrl[g_ps].RdEn //To check only on read 
                          && TLBPipeV_H[TLB_TAG_RD] 
                          && ~TLBPipe_H[TLB_TAG_RD].Ctrl.InvalGlb
                          && ~TLBPipe_H[TLB_TAG_RD].Ctrl.InvalDTLB
                        && ArrRdTag_H[g_ps][g_way].ValidSL
                        & ~ArrRdTag_H[g_ps][g_way].ValidFL,
                        ArrRdTag_H[g_ps][g_way].PASID == '0,
                        posedge clk, reset,
                     `HQM_DEVTLB_ERR_MSG("regular VTD cached entry should not use PASID"));
   
                     `HQM_DEVTLB_ASSERTS_NEVER( IOMMU_TLB_IOTLB_Tag_Valid_SL_FL_mutex, 
                         TLBPipe_H[TLB_TAG_RD].ArrCtrl[g_ps].RdEn //To check only on read 
                      && ~TLBPipe_H[TLB_TAG_RD].Ctrl.InvalGlb
                         && TLBPipeV_H[TLB_TAG_RD] 
                       && ArrRdTag_H[g_ps][g_way].ValidSL & ArrRdTag_H[g_ps][g_way].ValidFL,
                       posedge clk, reset,
                     `HQM_DEVTLB_ERR_MSG("IOTLB Tag Array ValidSL ValidFL mutex"));
   
                     if (MAX_GUEST_ADDRESS_WIDTH < DEVTLB_MAX_LINEAR_ADDRESS_WIDTH) begin : GAW_LT_LAW
                        `HQM_DEVTLB_ASSERTS_TRIGGER( IOMMU_TLB_IOTLB_Tag_GPA_Addr_Proper, 
                             TLBPipeV_H[TLB_TAG_RD] 
                             && TLBPipe_H[TLB_TAG_RD].ArrCtrl[g_ps].RdEn  //To check only on read 
                            && ~TLBPipe_H[TLB_TAG_RD].Ctrl.InvalGlb
                            && ~TLBPipe_H[TLB_TAG_RD].Ctrl.InvalDTLB
                           && ArrRdTag_H[g_ps][g_way].ValidSL
                           ,
                           ArrRdTag_H[g_ps][g_way].Address[GAW_LAW_MAX-1:MAX_GUEST_ADDRESS_WIDTH] == '0,
                           posedge clk, reset,
                        `HQM_DEVTLB_ERR_MSG("IOTLB Tag Address Proper"));
                     end
   
                     if (DEVTLB_PASID_SUPP_EN)  begin : PASID_EN3
                        if (MAX_GUEST_ADDRESS_WIDTH > DEVTLB_MAX_LINEAR_ADDRESS_WIDTH) begin : GAW_GT_LAW
                           `HQM_DEVTLB_ASSERTS_TRIGGER( IOMMU_TLB_IOTLB_Tag_LA_Addr_Proper, 
                                TLBPipeV_H[TLB_TAG_RD] 
                              && ~TLBPipe_H[TLB_TAG_RD].Ctrl.InvalGlb
                              && ~TLBPipe_H[TLB_TAG_RD].Ctrl.InvalDTLB
                                && TLBPipe_H[TLB_TAG_RD].ArrCtrl[g_ps].RdEn //To check only on read 
                              && ArrRdTag_H[g_ps][g_way].ValidFL
                              ,
                              ArrRdTag_H[g_ps][g_way].Address[GAW_LAW_MAX-1:DEVTLB_MAX_LINEAR_ADDRESS_WIDTH] == '0,
                              posedge clk, reset,
                           `HQM_DEVTLB_ERR_MSG("IOTLB Tag Address Proper"));
                        end
                     end
   
                     // For 2M, 1G, and 0.5T IOTLBs, the nonTag bits in the Address must be '0
                     if (g_ps>0) begin : PS_EXISTS
                        `HQM_DEVTLB_ASSERTS_TRIGGER( IOMMU_TLB_IOTLB_Tag_Addr_nontag_bits_zero,
                             TLBPipeV_H[TLB_TAG_RD] 
                             && TLBPipe_H[TLB_TAG_RD].ArrCtrl[g_ps].RdEn //To check only on read 
                            && ~TLBPipe_H[TLB_TAG_RD].Ctrl.InvalGlb
                            && ~TLBPipe_H[TLB_TAG_RD].Ctrl.InvalDTLB
                           && ArrRdTag_H[g_ps][g_way].ValidSL | ArrRdTag_H[g_ps][g_way].ValidFL,                     
                           ArrRdTag_H[g_ps][g_way].Address[`HQM_DEVTLB_TLB_UNTRAN_RANGE(g_ps)] == '0,
                           posedge clk, reset,
                        `HQM_DEVTLB_ERR_MSG("Non Tag bits of 2M, 1G Tlbs are hardwired to 0"));
                     end
   
   
                  end // FOR WAYS
            end       // IF_SETS
         end          // FOR PS
                   // IF iotlb_tlb_mode
endgenerate 

`HQM_DEVTLB_ASSERTS_TRIGGER( IOMMU_TLB_IOTLB_CtrlInval_Opcode,
                           (TLBPipeV_H[TLB_PIPE_END] && (TLBPipe_H[TLB_PIPE_END].Ctrl.InvalGlb || TLBPipe_H[TLB_PIPE_END].Ctrl.InvalDTLB)),                     
                           ((TLBPipe_H[TLB_PIPE_END].Req.Opcode == T_OPCODE'(DEVTLB_OPCODE_DTLB_INV))||
                            (TLBPipe_H[TLB_PIPE_END].Req.Opcode == T_OPCODE'(DEVTLB_OPCODE_GLB_INV)) ||
                            (TLBPipe_H[TLB_PIPE_END].Req.Opcode == T_OPCODE'(DEVTLB_OPCODE_UARCH_INV))),
                           posedge clk, reset,
                        `HQM_DEVTLB_ERR_MSG("TLBPipe_H.Ctrl.InvalGlb/DTLB set in non Inval Opcode"));  
`endif

////////////////////////////////////////////////////////////////////////////////
// IOTLB Covers
////////////////////////////////////////////////////////////////////////////////


`ifdef HQM_DEVTLB_COVER_EN // Do not use covers in VCS...flood the log files with too many messages

//`DEVTLB_COVERS(IOMMU_TLB_Miss,             TLBMissPipeV_nnnH,      posedge clk, reset_INST, `DEVTLB_COVER_MSG("TLB had a miss"));
//`DEVTLB_COVERS(IOMMU_TLB_TLBOutPipeV_nnnH, TLBOutPipeV_nnnH,       posedge clk, reset_INST, `DEVTLB_COVER_MSG("TLB had a hit"));

// For a single lookup request Hit in all available PS IOTLBs for that TLBId
T_TAG_ENTRY_0          sva_ArrRdTagP_H      [PS_MAX:PS_MIN] [NUM_WAYS-1:0];
always_comb begin
   for(int ips=PS_MIN; ips<=PS_MAX; ips++) begin
      for(int iway=0; iway<NUM_WAYS; iway++) begin
        sva_ArrRdTagP_H[ips][iway] = ArrRdTag_H[ips][iway];
        sva_ArrRdTagP_H[ips][iway].Address = ArrRdTag_H[ips][iway].Address & 
                                               TagMaskBase_H[`HQM_DEVTLB_PIPE_TLBID(TLB_TAG_RD, ips)][ips].Address;
        sva_ArrRdTagP_H[ips][iway].Parity = '0;
      end
    end
end

generate
for(g_ps=PS_MIN; g_ps<=PS_MAX; g_ps++) begin: ps1
   for(g_ps2=PS_MIN; g_ps2<=PS_MAX; g_ps2++) begin: ps2
      for (g_id = 0; g_id < NUM_ARRAYS; g_id++) begin : id
         if ((g_ps < g_ps2) & (NUM_SETS[g_id][g_ps] > 0) & (NUM_SETS[g_id][g_ps2] > 0)) begin: ps_ps2

            `HQM_DEVTLB_COVERS( IOMMU_TLB_lookup_hit_multiple_ps,
                  TLBPipeV_H[TLB_TAG_RD]
               & (|TLBPipe_H[TLB_TAG_RD].ArrInfo[g_ps].HitVec)
               & (|TLBPipe_H[TLB_TAG_RD].ArrInfo[g_ps2].HitVec),
               posedge clk, reset_INST,
            `HQM_DEVTLB_COVER_MSG("IOTLB single lookup request hit multiple ps IOTLBs"));
         end
      end
   end

   for(g_set=0; g_set<NUM_PS_SETS[g_ps]; g_set++) begin: set
    if ((g_set==(NUM_PS_SETS[g_ps]-1)) || DEVTLB_IN_FPV) begin : gen_fpv_set
      for(g_way=0; g_way<NUM_WAYS; g_way++) begin: way11
   
         if (NUM_PS_SETS[g_ps] > 0) begin: PS
            
            if (DEVTLB_PORT_ID == 0) begin : gen_sva0_portid
               // able to replace all ways in all sets
               `HQM_DEVTLB_COVERS( IOMMU_TLB_replace_set_and_way,
                        TLBPipeV_H[TLB_TAG_WR_CTRL]
                  &     TLBPipe_H[TLB_TAG_WR_CTRL].ArrCtrl[g_ps].WrEn
                  &     ~TLBPipe_H[TLB_TO_PW].Ctrl.InvalGlb
                  &    (TLBPipe_H[TLB_TAG_WR_CTRL].ArrCtrl[g_ps].SetAddr == g_set)
                  &     TLBPipe_H[TLB_TAG_WR_CTRL].ArrInfo[g_ps].RepVec[g_way],
                  posedge clk, reset_INST,
               `HQM_DEVTLB_COVER_MSG("Write to an IOTLB set and way"));
   
               // This should catch some LRU issues....if the LRU never picks certain ways
               `HQM_DEVTLB_COVERS( IOMMU_TLB_replace_set_and_way_all_valid,
                       TLBPipeV_H[TLB_TAG_WR_CTRL]
                  &     TLBPipe_H[TLB_TAG_WR_CTRL].ArrCtrl[g_ps].WrEn
                  &    (TLBPipe_H[TLB_TAG_WR_CTRL].ArrCtrl[g_ps].SetAddr == g_set)
                  &     TLBPipe_H[TLB_TAG_WR_CTRL].ArrInfo[g_ps].RepVec[g_way]
                  &   (&TLBPipe_H[TLB_TAG_WR_CTRL].ArrInfo[g_ps].ValVec)
                  &    ~TLBPipe_H[TLB_TAG_WR_CTRL].Ctrl.InvalGlb
                  &    ~TLBPipe_H[TLB_TAG_WR_CTRL].Ctrl.InvalDTLB,
                  posedge clk, reset_INST,
               `HQM_DEVTLB_COVER_MSG("Write to an IOTLB set and way with all ways valid"));
            end
            
            // Hit in every entry
            //
            for(x=0; x<=(1*DEVTLB_PASID_SUPP_EN); x++) begin: PasidV               
               // PASID and FL FSM can never see Requests without PASID
              
               `HQM_DEVTLB_COVERS( IOMMU_TLB_Hit_Each_Entry,
                      TLBPipeV_H[TLB_HIT_TO_OUTPUT]
                  &   (TLBPipe_H[TLB_HIT_TO_OUTPUT].ArrCtrl[g_ps].SetAddr == g_set)
                  &    TLBPipe_H[TLB_HIT_TO_OUTPUT].ArrInfo[g_ps].Hit
                  &    TLBPipe_H[TLB_HIT_TO_OUTPUT].ArrInfo[g_ps].HitVec[g_way]
                  &    TLBPipe_H[TLB_HIT_TO_OUTPUT].Info.Hit
                  &   (TLBPipe_H[TLB_HIT_TO_OUTPUT].Req.PasidV == x)
                  &   ~TLBPipe_H[TLB_HIT_TO_OUTPUT].Ctrl.Fill
                  &   (TLBPipe_H[TLB_HIT_TO_OUTPUT].Info.PSSel == g_ps),
                  posedge clk, reset_INST,
               `HQM_DEVTLB_COVER_MSG("TLBPipe Hit All Possible TLB entries"));
   
               // Miss from each entry
               //
               `HQM_DEVTLB_COVERS( IOMMU_TLB_Miss_Each_Entry,
                      TLBPipeV_H[TLB_TO_PW]
                  &   (TLBPipe_H[TLB_TO_PW].ArrCtrl[g_ps].SetAddr == g_set)
                  &   ~TLBPipe_H[TLB_TO_PW].Ctrl.Fill
                  &   ~TLBPipe_H[TLB_TO_PW].Ctrl.InvalGlb
                  &   ~TLBPipe_H[TLB_TO_PW].ArrInfo[g_ps].Hit
                        &   (TLBPipe_H[TLB_TO_PW].Req.PasidV == x)
                  &   ~TLBPipe_H[TLB_TO_PW].ArrInfo[g_ps].HitVec[g_way]
                  &   ~TLBPipe_H[TLB_TO_PW].Info.Hit,
                  posedge clk, reset_INST,
               `HQM_DEVTLB_COVER_MSG("TLBPipe Miss All Possible TLB entries"));
              
            end

            // Tag parity error in every entry
            // 
            if(DEVTLB_PARITY_EN) begin : gen_ps_PARITY_EN
            `HQM_DEVTLB_COVERS(IOMMU_TLB_Tag_ParErr_Each_Entry,
                  TLBPipeV_H[TLB_TAG_RD]
               & ~TLBPipe_H[TLB_TAG_RD].Ctrl.Fill
               &  (TLBPipe_H[TLB_TAG_RD].ArrCtrl[g_ps].SetAddr == g_set)
               &  FullMatch[g_ps][g_way]
               &  ~`HQM_DEVTLB_PARITY_CHECK(ArrRdTag_H[g_ps][g_way].Parity, sva_ArrRdTagP_H[g_ps][g_way], ~CrParErrInj_nnnH.disable_iotlb_parityerror),
               posedge clk, reset_INST,
            `HQM_DEVTLB_COVER_MSG("Tag parity_err possible in each PS array")); 

            // Data parity error in every entry
            //
            `HQM_DEVTLB_COVERS(IOMMU_TLB_Data_ParErr_Each_Entry,
                  TLBPipeV_H[TLB_DATA_RD]
               & ~TLBPipe_H[TLB_DATA_RD].Ctrl.Fill
               &  (TLBPipe_H[TLB_DATA_RD].ArrCtrl[g_ps].SetAddr == g_set)
               &  TLBPipe_H[TLB_DATA_RD].Info.Hit
               &  TLBPipe_H[TLB_DATA_RD].ArrInfo[g_ps].HitVec[g_way]
               & ~`HQM_DEVTLB_PARITY_CHECK(TLBPipe_H[TLB_DATA_RD].Info.Parity, ArrRdDataP_H, ~CrParErrInj_nnnH.disable_iotlb_parityerror),
               posedge clk, reset_INST,
               `HQM_DEVTLB_COVER_MSG("Data parity_err possible in each PS array"));

            /* TODO: hkhor1 - turn on this if Fill need to reuse anything from mathing TLB rf content.
            `HQM_DEVTLB_COVERS(IOMMU_TLB_Data_FillParErr_Each_Entry,
                  TLBPipeV_H[TLB_DATA_RD]
               &  TLBPipe_H[TLB_DATA_RD].Ctrl.Fill
               &  (TLBPipe_H[TLB_DATA_RD].ArrCtrl[g_ps].SetAddr == g_set)
               &  TLBPipe_H[TLB_DATA_RD].Info.Hit
               &  TLBPipe_H[TLB_DATA_RD].ArrInfo[g_ps].HitVec[g_way]
               & ~`HQM_DEVTLB_PARITY_CHECK(ArrRdData_H[g_ps][g_way].Parity, ArrRdDataP_H, ~CrParErrInj_nnnH.disable_iotlb_parityerror),
               posedge clk, reset_INST,
               `HQM_DEVTLB_COVER_MSG("Data parity_err possible in each PS array"));*/
            end //gen_ps_PARITY_EN
         end // PS_SETS > 0
      end // way
    end // gen_fpv_set
   end // set

   if (NUM_PS_SETS[g_ps] > 0) begin : PS_EXISTS_2
      localparam         int SET_ADDR_WIDTH      = `HQM_DEVTLB_LOG2(NUM_PS_SETS[g_ps]);

      `HQM_DEVTLB_COVERS( IOMMU_TLB_Hit_Each_Way_B2B,
              TLBPipeV_H[TLB_HIT_TO_OUTPUT]
         &    TLBPipeV_H[TLB_HIT_TO_OUTPUT-1]
         &   (`HQM_DEVTLB_PIPE_TLBID(TLB_HIT_TO_OUTPUT, g_ps)
           == `HQM_DEVTLB_PIPE_TLBID(TLB_HIT_TO_OUTPUT-1, g_ps))
         &   (TLBPipe_H[TLB_HIT_TO_OUTPUT].ArrCtrl[g_ps].SetAddr[SET_ADDR_WIDTH-1:0]
           == TLBPipe_H[TLB_HIT_TO_OUTPUT-1].ArrCtrl[g_ps].SetAddr[SET_ADDR_WIDTH-1:0])
         &    TLBPipe_H[TLB_HIT_TO_OUTPUT].ArrInfo[g_ps].HitVec[0]
         &    TLBPipe_H[TLB_HIT_TO_OUTPUT-1].ArrInfo[g_ps].HitVec[1]
         , posedge clk, reset_INST,
      `HQM_DEVTLB_COVER_MSG("TLBPipe Hit Back-to-back"));

//hkhor1  TODO lintra error on countones
/*
devtlb_rtl_lib  2744 Error 68803 Illegal usage of a counting assertion system functions '$countones' within the module 'devtlb_tlb', is not supported by Design Compiler (TM) (KEY : "$countones,devtlb_tlb" , CONFIG HIERARCHY : "devtlb")
devtlb_rtl_lib  2750 Error 68803 Illegal usage of a counting assertion system functions '$countones' within the module 'devtlb_tlb', is not supported by Design Compiler (TM) (KEY : "$countones,devtlb_tlb" , CONFIG HIERARCHY : "devtlb")

      `HQM_DEVTLB_COVERS( IOMMU_TLB_lookup_hitvec_nonhot,
            TLBPipeV_H[TLB_TAG_RD]
         & ($countones(TLBPipe_H[TLB_TAG_RD].ArrInfo[g_ps].HitVec)==0),
         posedge clk, reset_INST, 
      `HQM_DEVTLB_COVER_MSG("IOTLB HitVec for a Pagesize is onehot or no hot"));

      `HQM_DEVTLB_COVERS( IOMMU_TLB_lookup_hitvec_onehot,
            TLBPipeV_H[TLB_TAG_RD]
         & ($countones(TLBPipe_H[TLB_TAG_RD].ArrInfo[g_ps].HitVec)==1),
         posedge clk, reset_INST, 
      `HQM_DEVTLB_COVER_MSG("IOTLB HitVec for a Pagesize is onehot or no hot"));
*/
   end


   for(x=0; x<=(1*DEVTLB_PASID_SUPP_EN); x++) begin: PasidV               

      if (NUM_PS_SETS[g_ps] > 0) begin : PS_EXISTS_3
         
         if (DEVTLB_PORT_ID == 0) begin : gen_sva1_portid
            `HQM_DEVTLB_COVERS( IOMMU_TLB_Fill_Attempt,
                   TLBPipeV_H[TLB_TAG_WR]
               //&   f_IOMMU_Opcode_is_Untranslated(TLBPipe_H[TLB_TAG_WR].Req.Opcode)
               &    TLBPipe_H[TLB_TAG_WR].Ctrl.Fill
               &   (TLBPipe_H[TLB_TAG_WR].Req.PasidV == x)
               &   (TLBPipe_H[TLB_TAG_WR].Info.Size == g_ps)
               , posedge clk, reset_INST,
            `HQM_DEVTLB_COVER_MSG("TLBPipe Attempt to Fill"));
   
            `HQM_DEVTLB_COVERS( IOMMU_TLB_Tag_Write,
                   TLBPipeV_H[TLB_TAG_WR]
               //&   f_IOMMU_Opcode_is_Untranslated(TLBPipe_H[TLB_TAG_WR].Req.Opcode)
               &    TLBPipe_H[TLB_TAG_WR].Ctrl.Fill
               &   (TLBPipe_H[TLB_TAG_WR].Req.PasidV == x)
               &   (TLBPipe_H[TLB_TAG_WR].Info.Size == g_ps)
               &    TLBPipe_H[TLB_TAG_WR].ArrCtrl[g_ps].WrEn
               , posedge clk, reset_INST,
            `HQM_DEVTLB_COVER_MSG("TLBPipe Attempt to Fill"));
   
            `HQM_DEVTLB_COVERS( IOMMU_TLB_Data_Write,
                   TLBPipeV_H[TLB_DATA_WR]
               //&   f_IOMMU_Opcode_is_Untranslated(TLBPipe_H[TLB_TAG_WR].Req.Opcode)
               &    TLBPipe_H[TLB_DATA_WR].Ctrl.Fill
               &   (TLBPipe_H[TLB_DATA_WR].Req.PasidV == x)
               &   (TLBPipe_H[TLB_DATA_WR].Info.Size == g_ps)
               &    TLBPipe_H[TLB_DATA_WR].ArrCtrl[g_ps].WrEn
               , posedge clk, reset_INST,
            `HQM_DEVTLB_COVER_MSG("TLBPipe Attempt to Fill"));
   
            `HQM_DEVTLB_COVERS( IOMMU_TLB_Fill_Attempt_with_R,
                   TLBPipeV_H[TLB_TAG_WR]
               &   (TLBPipe_H[TLB_TAG_WR].Info.Size == g_ps)
               &    TLBPipe_H[TLB_TAG_WR].Ctrl.Fill
               &   (TLBPipe_H[TLB_TAG_WR].Req.PasidV == x)
               &    TLBPipe_H[TLB_TAG_WR].Info.R
               , posedge clk, reset_INST,
            `HQM_DEVTLB_COVER_MSG("TLBPipe Attempt to Fill"));
   
            `HQM_DEVTLB_COVERS( IOMMU_TLB_Fill_Attempt_with_W,
                   TLBPipeV_H[TLB_TAG_WR]
               &   (TLBPipe_H[TLB_TAG_WR].Info.Size == g_ps)
               &    TLBPipe_H[TLB_TAG_WR].Ctrl.Fill
               &   (TLBPipe_H[TLB_TAG_WR].Req.PasidV == x)
               &    TLBPipe_H[TLB_TAG_WR].Info.W
               , posedge clk, reset_INST,
            `HQM_DEVTLB_COVER_MSG("TLBPipe Attempt to Fill"));
   
            `HQM_DEVTLB_COVERS( IOMMU_TLB_Fill_Attempt_without_R,
                   TLBPipeV_H[TLB_TAG_WR]
               &   (TLBPipe_H[TLB_TAG_WR].Info.Size == g_ps)
               &    TLBPipe_H[TLB_TAG_WR].Ctrl.Fill
               &   (TLBPipe_H[TLB_TAG_WR].Req.PasidV == x)
               &   ~TLBPipe_H[TLB_TAG_WR].Info.R
               , posedge clk, reset_INST,
            `HQM_DEVTLB_COVER_MSG("TLBPipe Attempt to Fill"));
   
            `HQM_DEVTLB_COVERS( IOMMU_TLB_Fill_Attempt_without_W,
                   TLBPipeV_H[TLB_TAG_WR]
               &   (TLBPipe_H[TLB_TAG_WR].Info.Size == g_ps)
               &    TLBPipe_H[TLB_TAG_WR].Ctrl.Fill
               &   (TLBPipe_H[TLB_TAG_WR].Req.PasidV == x)
               &   ~TLBPipe_H[TLB_TAG_WR].Info.W
               , posedge clk, reset_INST,
            `HQM_DEVTLB_COVER_MSG("TLBPipe Attempt to Fill"));
            
         end //PORT ID == 0

         `HQM_DEVTLB_COVERS( IOMMU_TLB_Hit_with_R,
                TLBPipeV_H[TLB_HIT_TO_OUTPUT]
            &   (TLBPipe_H[TLB_HIT_TO_OUTPUT].Info.PSSel == g_ps)
            &    TLBPipe_H[TLB_HIT_TO_OUTPUT].ArrInfo[g_ps].Hit
            &    TLBPipe_H[TLB_HIT_TO_OUTPUT].Info.Hit
            &   (TLBPipe_H[TLB_HIT_TO_OUTPUT].Req.PasidV == x)
            &    TLBPipe_H[TLB_HIT_TO_OUTPUT].Info.R
            , posedge clk, reset_INST,
         `HQM_DEVTLB_COVER_MSG("TLBPipe Hit with Attribute R"));

         `HQM_DEVTLB_COVERS( IOMMU_TLB_Hit_without_R,
                TLBPipeV_H[TLB_HIT_TO_OUTPUT]
            &    TLBPipe_H[TLB_HIT_TO_OUTPUT].ArrInfo[g_ps].Hit
            &    TLBPipe_H[TLB_HIT_TO_OUTPUT].Info.Hit
            &   (TLBPipe_H[TLB_HIT_TO_OUTPUT].Req.PasidV == x)
            &   (TLBPipe_H[TLB_HIT_TO_OUTPUT].Info.PSSel == g_ps)
            &   ~TLBPipe_H[TLB_HIT_TO_OUTPUT].Info.R
            , posedge clk, reset_INST,
         `HQM_DEVTLB_COVER_MSG("TLBPipe Hit with Attribute R"));

         `HQM_DEVTLB_COVERS( IOMMU_TLB_Hit_with_W,
                TLBPipeV_H[TLB_HIT_TO_OUTPUT]
            &    TLBPipe_H[TLB_HIT_TO_OUTPUT].ArrInfo[g_ps].Hit
            &    TLBPipe_H[TLB_HIT_TO_OUTPUT].Info.Hit
            &   (TLBPipe_H[TLB_HIT_TO_OUTPUT].Req.PasidV == x)
            &   (TLBPipe_H[TLB_HIT_TO_OUTPUT].Info.PSSel == g_ps)
            &    TLBPipe_H[TLB_HIT_TO_OUTPUT].Info.W
            , posedge clk, reset_INST,
         `HQM_DEVTLB_COVER_MSG("TLBPipe Hit with Attribute W"));

         `HQM_DEVTLB_COVERS( IOMMU_TLB_Hit_without_W,
                TLBPipeV_H[TLB_HIT_TO_OUTPUT]
            &    TLBPipe_H[TLB_HIT_TO_OUTPUT].ArrInfo[g_ps].Hit
            &    TLBPipe_H[TLB_HIT_TO_OUTPUT].Info.Hit
            &   (TLBPipe_H[TLB_HIT_TO_OUTPUT].Req.PasidV == x)
            &   (TLBPipe_H[TLB_HIT_TO_OUTPUT].Info.PSSel == g_ps)
            &   ~TLBPipe_H[TLB_HIT_TO_OUTPUT].Info.W
            , posedge clk, reset_INST,
         `HQM_DEVTLB_COVER_MSG("TLBPipe Hit with Attribute W"));

      end // NUM SETS > 0
   end 

    //PendQ Hit Fault
    `HQM_DEVTLB_COVERS( IOMMU_TLB_PendQ_HitFault,
                  (TLBFaultPipeV_nnnH && TLBPipe_H[TLB_DATA_RD].Ctrl.PendQXReq),
                  posedge clk, reset_INST,
                  `HQM_DEVTLB_COVER_MSG("PendQ hit Fault."));  

    //CP for PendQ Miss due to LRU Eviction or invalidation
   `HQM_DEVTLB_COVERS( IOMMU_TLB_LRUEvict_PendQMISS,
            (TLBMissPipeV_nnnH & TLBPipe_H[TLB_DATA_RD].Ctrl.PendQXReq
            & ~TLBPipe_H[TLB_DATA_RD].Ctrl.ForceXRsp
            & (&TLBPipe_H[TLB_DATA_RD].ArrInfo[0].ValVec)),
      posedge clk, reset_INST,
   `HQM_DEVTLB_COVER_MSG("PendQ Miss due to LRU Eviction"));

   `HQM_DEVTLB_COVERS( IOMMU_TLB_Other_PendQMISS,
            (TLBMissPipeV_nnnH & TLBPipe_H[TLB_DATA_RD].Ctrl.PendQXReq
            & ~TLBPipe_H[TLB_DATA_RD].Ctrl.ForceXRsp
            & (~&TLBPipe_H[TLB_DATA_RD].ArrInfo[0].ValVec)),
      posedge clk, reset_INST,
   `HQM_DEVTLB_COVER_MSG("PendQ Miss"));

//  `DEVTLB_COVERS( IOMMU_TLB_Inval_PendQMISS,
//            (TLBMissPipeV_nnnH && TLBPipe_H[TLB_DATA_RD].Ctrl.PendQXReq
//            && ~TLBPipe_H[TLB_DATA_RD].Ctrl.ForceXRsp
//            /*& (~&TLBPipe_H[TLB_DATA_RD].ArrInfo[0].ValVec)*/)// &&
//            $past($fell(TLBOutInvTail_nnH),6), 
//      posedge clk, reset_INST,
//   `DEVTLB_COVER_MSG("PendQ Request Miss due to Inval"));

    //when this CP hit, IOTLB1.0 does a LRU_Rd_invert, devtlb2.0 no longer use LRU_Rd_Insert.
    //this CP is equivalent to 
   `HQM_DEVTLB_COVERS( IOMMU_TLB_WASLRURDINVERT,
            (TLBPipeV_H[TLB_TAG_WR_CTRL]
            &  (TLBPipe_H[TLB_TAG_WR_CTRL].ArrCtrl[g_ps].WrEn | (|TLBPipe_H[TLB_TAG_WR_CTRL].ArrInfo[g_ps].HitVec)) 
            &  (TLBPipe_H[TLB_TAG_WR_CTRL-1].ArrCtrl[g_ps].SetAddr == TLBPipe_H[TLB_TAG_WR_CTRL].ArrCtrl[g_ps].SetAddr)
            &  (DEVTLB_PORT_ID == '0)),
      posedge clk, reset_INST,
   `HQM_DEVTLB_COVER_MSG("LRU write to same Set 2 clk earlier than current LRU Read"));

    for (genvar g_stage=1; g_stage<=3; g_stage++ ) begin : gen_lrub2b_cov_point
       `HQM_DEVTLB_COVERS( IOMMU_TLB_LRU_WRTHENRD,
                (TLBPipeV_H[TLB_TAG_RD] & TLBPipe_H[TLB_TAG_RD].Ctrl.Fill && (TLBPipe_H[TLB_TAG_RD].Info.EffSize==g_ps)
                & (~|TLBPipe_H[TLB_TAG_RD].ArrInfo[g_ps].HitVec) & (&TLBPipe_H[TLB_TAG_RD].ArrInfo[g_ps].ValVec)
                & TLBPipeV_H[TLB_TAG_RD+g_stage] & TLBPipe_H[TLB_TAG_RD+g_stage].ArrCtrl[g_ps].LRUWrEn
                & (TLBPipe_H[TLB_TAG_RD].ArrCtrl[g_ps].SetAddr == TLBPipe_H[TLB_TAG_RD+g_stage].ArrCtrl[g_ps].SetAddr)),
          posedge clk, reset_INST,
       `HQM_DEVTLB_COVER_MSG("LRU Wr followed by LRU Rd, possible stale LRU content returned to the Rd"));
    end
end // PS
endgenerate

`HQM_DEVTLB_COVERS(IOMMU_TLB_Obs_tlb_lookup_valid, 
   ObsIotlbLkpValid_nnnH,
   posedge clk, reset_INST, 
`HQM_DEVTLB_COVER_MSG("Valid tlb lookup detected on VISA."));

if (DEVTLB_PORT_ID == 0) begin : gen_sva_fill_valid
   `HQM_DEVTLB_COVERS(IOMMU_TLB_Obs_tlb_fill_valid, 
      (TLBPipe_H[TLB_HIT_TO_OUTPUT].Ctrl.Fill  &  TLBPipeV_H[TLB_HIT_TO_OUTPUT]),
      posedge clk, reset_INST, 
   `HQM_DEVTLB_COVER_MSG("Valid tlb fill detected on VISA."));
end

if (DEVTLB_PORT_ID == 0) begin : gen_sva_inv_valid
   `HQM_DEVTLB_COVERS(IOMMU_TLB_Obs_tlb_inv_valid, 
      ObsIotlbInvValid_nnnH,
      posedge clk, reset_INST, 
   `HQM_DEVTLB_COVER_MSG("Valid tlb fill detected on VISA."));
end

`HQM_DEVTLB_COVERS_TRIGGER(CP_DEVTLB_TLB_XEvict_PASIDEN_PasidV0_NonZeroSetAddr, //hsd22013476356
      (TLBPipeV_H[TLB_TAG_RD_CTRL] && TLBPipe_H[TLB_TAG_RD_CTRL].Ctrl.InvalDTLB),
      (TLBPipe_H[TLB_TAG_RD_CTRL].Req.Opcode == T_OPCODE'(DEVTLB_OPCODE_UARCH_INV)) && (DEVTLB_PASID_SUPP_EN? ~TLBPipe_H[TLB_TAG_RD_CTRL].Req.PasidV: '1) &&
      ~|(T_SETADDR'(TLBPipe_H[TLB_TAG_RD_CTRL].Req.Address[GAW_LAW_MAX-1:12] & ~TagMask_H[TLB_TAG_RD_CTRL][`HQM_DEVTLB_PIPE_TLBID(TLB_TAG_RD_CTRL, 0)][0].Address[GAW_LAW_MAX-1:12])), //not first set of uTLB
      posedge clk, reset_INST, 
   `HQM_DEVTLB_COVER_MSG("%0t %m HIT", $time));

generate
for (genvar g_stage=1; g_stage<4; g_stage++ ) begin : gen_b2breq_cov_point
  for (genvar g_ps=PS_MIN; g_ps<=PS_MAX; g_ps++ ) begin : gen_b2breq_cov_point_ps
   `HQM_DEVTLB_COVERS_TRIGGER(CP_DEVTLB_TLB_FILLXREQ, 
      (TLBPipeV_H[TLB_PIPE_START+g_stage] && TLBPipe_H[TLB_PIPE_START+g_stage].Ctrl.Fill && 
         TLBPipeV_H[TLB_PIPE_START] && f_IOMMU_Opcode_is_DMA(TLBPipe_H[TLB_PIPE_START].Req.Opcode)),
      (TLB_PIPE_START+g_stage == TLB_TAG_WR_CTRL)? 
         (1'b1): 
         (((TLBPipe_H[TLB_PIPE_START+g_stage].Req.Address == TLBPipe_H[TLB_PIPE_START].Req.Address) && 
           (`HQM_DEVTLB_PIPE_TLBID(TLB_PIPE_START+g_stage, TLBPipe_H[TLB_PIPE_START+g_stage].Info.EffSize) == 
            `HQM_DEVTLB_PIPE_TLBID(TLB_PIPE_START, g_ps)))),
      posedge clk, reset_INST, 
   `HQM_DEVTLB_COVER_MSG("%0t %m HIT", $time));

   `HQM_DEVTLB_COVERS_TRIGGER(CP_DEVTLB_TLB_XREQFILL, 
      (TLBPipeV_H[TLB_PIPE_START] && TLBPipe_H[TLB_PIPE_START].Ctrl.Fill && 
         TLBPipeV_H[TLB_PIPE_START+g_stage] && f_IOMMU_Opcode_is_DMA(TLBPipe_H[TLB_PIPE_START+g_stage].Req.Opcode)),
      ((TLBPipe_H[TLB_PIPE_START+g_stage].Req.Address == TLBPipe_H[TLB_PIPE_START].Req.Address) && 
       (`HQM_DEVTLB_PIPE_TLBID(TLB_PIPE_START+g_stage, g_ps) == 
        `HQM_DEVTLB_PIPE_TLBID(TLB_PIPE_START, TLBPipe_H[TLB_PIPE_START].Info.EffSize))),
      posedge clk, reset_INST, 
   `HQM_DEVTLB_COVER_MSG("%0t %m HIT", $time));
  end
end
endgenerate

generate
for (g_ps=PS_MIN; g_ps<=PS_MAX; g_ps++) begin: gen_cov_ReUseTLB
   `HQM_DEVTLB_COVERS_TRIGGER(CP_DEVTLB_TLB_SKIPFILL_IFTLBRW, 
      (TLBPipe_H[TLB_TAG_WR_CTRL].ArrCtrl[g_ps].WrEn),
      ReUseTLB[TLB_TAG_WR_CTRL] && ~InvReUseTLB[TLB_TAG_WR_CTRL][g_ps],
      posedge clk, reset_INST, 
   `HQM_DEVTLB_COVER_MSG("%0t %m HIT", $time));

  if (EVICT_SUPP_PS[g_ps]) begin: gen_cov_ReUseTLB_Evict
  `HQM_DEVTLB_COVERS_TRIGGER(CP_DEVTLB_TLB_EVICTCANCEL_SKIPFILL_IFTLBRW, 
      (TLBPipe_H[TLB_TAG_WR_CTRL].ArrCtrl[g_ps].WrEn),
      ReUseTLB[TLB_TAG_WR_CTRL] && InvReUseTLB[TLB_TAG_WR_CTRL][g_ps],
      posedge clk, reset_INST, 
   `HQM_DEVTLB_COVER_MSG("%0t %m HIT", $time));

   `HQM_DEVTLB_COVERS_TRIGGER( CP_DEVTLB_TLB_InvReUseTLB_Inval_GT1Way_1,
      (TLBPipeV_H[TLB_TAG_WR_CTRL] && TLBPipe_H[TLB_LRU_WR_CTRL].Ctrl.Fill &&
       (~TLBPipe_H[TLB_TAG_WR_CTRL].Ctrl.DisRdEn[g_ps]) && //fill itself
       TLBPipe_H[TLB_TAG_WR_CTRL+1].Ctrl.InvalDTLB && //evict
       (~TLBPipe_H[TLB_TAG_WR_CTRL+1].Ctrl.DisRdEn[g_ps]) &&
       (TLBPipe_H[TLB_TAG_WR_CTRL].ArrCtrl[g_ps].SetAddr[`HQM_DEVTLB_LOG2(NUM_PS_SETS[g_ps])-1:0]==TLBPipe_H[TLB_TAG_WR_CTRL+1].ArrCtrl[g_ps].SetAddr[`HQM_DEVTLB_LOG2(NUM_PS_SETS[g_ps])-1:0]))
      , ((|(TLBPipe_H[TLB_TAG_WR_CTRL].ArrInfo[g_ps].RepVec & TLBPipe_H[TLB_TAG_WR_CTRL+1].ArrInfo[g_ps].RepVec)) &&  //if fill's RepVec (onehot) match with any bit in Evict (evict may have >1 way hit)
         ~$onehot(TLBPipe_H[TLB_TAG_WR_CTRL+1].ArrInfo[g_ps].RepVec)),
      posedge clk, reset_INST,
   `HQM_DEVTLB_COVER_MSG("%0t %m HIT", $time));

   `HQM_DEVTLB_COVERS_TRIGGER( CP_DEVTLB_TLB_InvReUseTLB_Inval_GT1Way_2,
      (TLBPipeV_H[TLB_TAG_WR_CTRL] && TLBPipe_H[TLB_LRU_WR_CTRL].Ctrl.Fill &&
       (~TLBPipe_H[TLB_TAG_WR_CTRL].Ctrl.DisRdEn[g_ps]) && //fill itself
       TLBPipe_H[TLB_TAG_WR_CTRL+2].Ctrl.InvalDTLB && //evict
       (~TLBPipe_H[TLB_TAG_WR_CTRL+2].Ctrl.DisRdEn[g_ps]) &&
       (TLBPipe_H[TLB_TAG_WR_CTRL].ArrCtrl[g_ps].SetAddr[`HQM_DEVTLB_LOG2(NUM_PS_SETS[g_ps])-1:0]==TLBPipe_H[TLB_TAG_WR_CTRL+2].ArrCtrl[g_ps].SetAddr[`HQM_DEVTLB_LOG2(NUM_PS_SETS[g_ps])-1:0]))
      , ((|(TLBPipe_H[TLB_TAG_WR_CTRL].ArrInfo[g_ps].RepVec & TLBPipe_H[TLB_TAG_WR_CTRL+2].ArrInfo[g_ps].RepVec)) &&  //if fill's RepVec (onehot) match with any bit in Evict (evict may have >1 way hit)
         ~$onehot(TLBPipe_H[TLB_TAG_WR_CTRL+2].ArrInfo[g_ps].RepVec)),
      posedge clk, reset_INST,
   `HQM_DEVTLB_COVER_MSG("%0t %m HIT", $time));
  end
end
endgenerate

generate
if(DEVTLB_PARITY_EN) begin: gen_cp_invrfdperr
   `HQM_DEVTLB_COVERS_TRIGGER(CP_DEVTLB_TLB_FILL_INVRFDataPERR, 
      (TLBPipe_H[TLB_TAG_WR_CTRL].ArrCtrl[PS_MIN].WrEn && ~|TLBPipe_H[TLB_TAG_WR_CTRL].ArrInfo[PS_MIN].TagParErr),
      InvDPErrEntry[TLB_TAG_WR_CTRL],
      posedge clk, reset_INST, 
   `HQM_DEVTLB_COVER_MSG("%0t %m HIT", $time));

   `HQM_DEVTLB_COVERS_TRIGGER(CP_DEVTLB_TLB_FILL_INVRFTagPERR, 
      (TLBPipe_H[TLB_TAG_WR_CTRL].ArrCtrl[PS_MIN].WrEn && |TLBPipe_H[TLB_TAG_WR_CTRL].ArrInfo[PS_MIN].TagParErr),
      InvDPErrEntry[TLB_TAG_WR_CTRL],
      posedge clk, reset_INST, 
   `HQM_DEVTLB_COVER_MSG("%0t %m HIT", $time));
end // DEVTLB_PARITY_EN
endgenerate

   `HQM_DEVTLB_COVERS_DELAYED_TRIGGER(CP_DEVTLB_TLB_OVWRFILL_TLBROWO, 
      (TLBPipe_H[TLB_DATA_RD].Ctrl.Fill &&
       ((ff_TLBPipe_H[TLB_DATA_RD].Info.R ^ TLBCached_R[TLB_DATA_RD]) &&
        (ff_TLBPipe_H[TLB_DATA_RD].Info.W ^ TLBCached_W[TLB_DATA_RD]) &&
        (ff_TLBPipe_H[TLB_DATA_RD].Info.R ^ ff_TLBPipe_H[TLB_DATA_RD].Info.W) &&
        (TLBCached_R[TLB_DATA_RD] ^ TLBCached_W[TLB_DATA_RD]))),
      1, (TLBPipe_H[TLB_TAG_WR_CTRL].ArrCtrl[PS_MIN].WrEn),
      posedge clk, reset_INST, 
   `HQM_DEVTLB_COVER_MSG("%0t %m HIT", $time));

generate
for (genvar g_stage=(TLB_TAG_WR_CTRL-TLB_TAG_RD_CTRL)+1; g_stage<5; g_stage++ ) begin : gen_b2bfill_cov_point
   `HQM_DEVTLB_COVERS_TRIGGER(CP_DEVTLB_TLB_FILLFILL, 
      (TLBPipeV_H[TLB_PIPE_START+g_stage] && TLBPipe_H[TLB_PIPE_START+g_stage].Ctrl.Fill && 
         TLBPipeV_H[TLB_PIPE_START] && TLBPipe_H[TLB_PIPE_START].Ctrl.Fill),
      ((TLBPipe_H[TLB_PIPE_START+g_stage].Info.EffSize == TLBPipe_H[TLB_PIPE_START].Info.EffSize) &&
       (TLBPipe_H[TLB_PIPE_START+g_stage].Req.Address == TLBPipe_H[TLB_PIPE_START].Req.Address) && 
         (`HQM_DEVTLB_PIPE_TLBID(TLB_PIPE_START+g_stage, TLBPipe_H[TLB_PIPE_START+g_stage].Info.EffSize) == 
          `HQM_DEVTLB_PIPE_TLBID(TLB_PIPE_START, TLBPipe_H[TLB_PIPE_START].Info.EffSize))),
      posedge clk, reset_INST, 
   `HQM_DEVTLB_COVER_MSG("%0t %m HIT", $time));
end
endgenerate

//TODO CP Fresh fill without dperror and with any permissions would overwrite if dperror is seen in stored matching entry.

`endif // DEVTLB_COVER_EN

`ifdef XPROP

`HQM_DEVTLB_ASSERTS_TRIGGER( FPV_IOMMU_XPROP_internal_TLBPipeV_101H,
   1, ~$isunknown(TLBPipeV_101H), 
   posedge clk, reset, 
`HQM_DEVTLB_ERR_MSG("X Propagation Failure: TLBPipeV_101H")); 

`HQM_DEVTLB_ASSERTS_TRIGGER( FPV_IOMMU__XPROP_internal_TLBReq_101H,
   TLBPipeV_101H, ~$isunknown(TLBReq_101H), 
   posedge clk, reset, 
`HQM_DEVTLB_ERR_MSG("X Propagation Failure: TLBReq_101H")); 

`HQM_DEVTLB_ASSERTS_TRIGGER( FPV_IOMMU_XPROP_internal_TLBCtrl_101H,
   TLBPipeV_101H, ~$isunknown(TLBCtrl_101H), 
   posedge clk, reset, 
`HQM_DEVTLB_ERR_MSG("X Propagation Failure: TLBCtrl_101H")); 

`HQM_DEVTLB_ASSERTS_TRIGGER( FPV_IOMMU_XPROP_internal_TLBInfo_101H,
   TLBPipeV_101H, ~$isunknown(TLBInfo_101H), 
   posedge clk, reset, 
`HQM_DEVTLB_ERR_MSG("X Propagation Failure: TLBInfo_101H")); 

`endif //XPROP

//hkhor1: checking rw conflict due to fill & flll.
// rw confict due to xreq & fill is checked in devtlb_array_gen.
// in case of ALLOW_TLBRWCONFLICT=1, xreq may miss the fill (i.e the wr at same clk). The xreq should then goes to pendq for replay
//   See HSD22010096174 & CP_DEVTLB_TLB_XREQFILL.

generate
for (genvar g_stage=1; g_stage<=(TLB_TAG_WR_CTRL-TLB_TAG_RD_CTRL); g_stage++ ) begin : gen_b2bfill_as
    for(g_ps=PS_MIN; g_ps<=PS_MAX; g_ps++) begin: gen_b2bfill_as_ps
        if (NUM_PS_SETS[g_ps] > 1) begin: gen_b2fill_NUM_SET_2
            `HQM_DEVTLB_ASSERTS_NEVER(AS_DEVTLB_TLB_FILLFILL,
                (TLBPipeV_H[TLB_TAG_RD_CTRL+g_stage] && TLBPipe_H[TLB_TAG_RD_CTRL+g_stage].Ctrl.Fill && (TLBPipe_H[TLB_TAG_RD_CTRL+g_stage].Info.EffSize == g_ps) &&
                 TLBPipeV_H[TLB_TAG_RD_CTRL] && TLBPipe_H[TLB_TAG_RD_CTRL].Ctrl.Fill && (TLBPipe_H[TLB_TAG_RD_CTRL].Info.EffSize == g_ps)) &&
                (TLBPipe_H[TLB_TAG_RD_CTRL+g_stage].ArrCtrl[g_ps].SetAddr == 
                 TLBPipe_H[TLB_TAG_RD_CTRL].ArrCtrl[g_ps].SetAddr),
                posedge clk, reset_INST, `HQM_DEVTLB_ERR_MSG("DEVTLB: Array Same Cycle Read/Write Conflict"));
        end else begin: gen_b2bfill_NUM_SET_1
            `HQM_DEVTLB_ASSERTS_NEVER(AS_DEVTLB_TLB_FILLFILL,
                (TLBPipeV_H[TLB_TAG_RD_CTRL+g_stage] && TLBPipe_H[TLB_TAG_RD_CTRL+g_stage].Ctrl.Fill && (TLBPipe_H[TLB_TAG_RD_CTRL+g_stage].Info.EffSize == g_ps) && 
                 TLBPipeV_H[TLB_TAG_RD_CTRL] && TLBPipe_H[TLB_TAG_RD_CTRL].Ctrl.Fill && (TLBPipe_H[TLB_TAG_RD_CTRL].Info.EffSize == g_ps)),
                posedge clk, reset_INST, `HQM_DEVTLB_ERR_MSG("DEVTLB: Array Same Cycle Read/Write Conflict"));
        end
    end
end
endgenerate

generate
for(g_ps=PS_MIN; g_ps<=PS_MAX; g_ps++) begin: ps_lruaccess
        //LRU due to fill should only happens if there is a tag write
       `HQM_DEVTLB_ASSERTS_DELAYED_TRIGGER( AS_DEVTLB_TLB_LRU_WRFILL,
          DEVTLB_LRU_WrEn[g_ps] && TLBPipe_H[TLB_LRU_WR_CTRL].Ctrl.Fill, 1,
          DEVTLB_Tag_WrEn[g_ps],
          posedge clk, reset_INST,
       `HQM_DEVTLB_ERR_MSG("LRU due to fill should only happens if there is a tag write"));

        //Ensure LRU is not selecting the recently Hit Way for Fill
       `HQM_DEVTLB_ASSERTS_NEVER( AS_DEVTLB_TLB_LRU_WRTHENRD1CKLATER,
                (TLBPipeV_H[TLB_TAG_RD] & TLBPipe_H[TLB_TAG_RD].Ctrl.Fill && (TLBPipe_H[TLB_TAG_RD].Info.EffSize == g_ps)
                & (~|TLBPipe_H[TLB_TAG_RD].ArrInfo[g_ps].HitVec) & (&TLBPipe_H[TLB_TAG_RD].ArrInfo[g_ps].ValVec)
                & TLBPipeV_H[TLB_TAG_RD+1] & TLBPipe_H[TLB_TAG_RD+1].ArrCtrl[g_ps].LRUWrEn
                & (TLBPipe_H[TLB_TAG_RD].ArrCtrl[g_ps].SetAddr == TLBPipe_H[TLB_TAG_RD+1].ArrCtrl[g_ps].SetAddr)
                & (  (f_IOMMU_Opcode_is_DMA(TLBPipe_H[TLB_TAG_RD+1].Req.Opcode)
                      & (TLBPipe_H[TLB_TAG_RD].ArrInfo[g_ps].RepVec == TLBPipe_H[TLB_TAG_RD+1].ArrInfo[g_ps].HitVec) )
                  || (f_IOMMU_Opcode_is_FILL(TLBPipe_H[TLB_TAG_RD+1].Req.Opcode)
                      & (TLBPipe_H[TLB_TAG_RD].ArrInfo[g_ps].RepVec == TLBPipe_H[TLB_TAG_RD+1].ArrInfo[g_ps].RepVec) ))),
          posedge clk, reset_INST,
       `HQM_DEVTLB_ERR_MSG("LRU selected the recently Hit Way for Fill"));

       `HQM_DEVTLB_ASSERTS_NEVER( AS_DEVTLB_TLB_LRU_WRTHENRD2CKLATER,
                (TLBPipeV_H[TLB_TAG_RD] & TLBPipe_H[TLB_TAG_RD].Ctrl.Fill && (TLBPipe_H[TLB_TAG_RD].Info.EffSize == g_ps)
                & (~|TLBPipe_H[TLB_TAG_RD].ArrInfo[g_ps].HitVec) & (&TLBPipe_H[TLB_TAG_RD].ArrInfo[g_ps].ValVec)
                & TLBPipeV_H[TLB_TAG_RD+2] & TLBPipe_H[TLB_TAG_RD+2].ArrCtrl[g_ps].LRUWrEn
                & (TLBPipe_H[TLB_TAG_RD].ArrCtrl[g_ps].SetAddr == TLBPipe_H[TLB_TAG_RD+2].ArrCtrl[g_ps].SetAddr)
                & (  (f_IOMMU_Opcode_is_DMA(TLBPipe_H[TLB_TAG_RD+2].Req.Opcode)
                      & (TLBPipe_H[TLB_TAG_RD].ArrInfo[g_ps].RepVec == TLBPipe_H[TLB_TAG_RD+2].ArrInfo[g_ps].HitVec) )
                  || (f_IOMMU_Opcode_is_FILL(TLBPipe_H[TLB_TAG_RD+2].Req.Opcode)
                      & (TLBPipe_H[TLB_TAG_RD].ArrInfo[g_ps].RepVec == TLBPipe_H[TLB_TAG_RD+2].ArrInfo[g_ps].RepVec) ))
                & ~(TLBPipe_H[TLB_TAG_RD+1].ArrCtrl[g_ps].LRUWrEn &
                   (TLBPipe_H[TLB_TAG_RD].ArrCtrl[g_ps].SetAddr == TLBPipe_H[TLB_TAG_RD+1].ArrCtrl[g_ps].SetAddr))),
          posedge clk, reset_INST,
       `HQM_DEVTLB_ERR_MSG("LRU selected the recently Hit Way for Fill"));

       `HQM_DEVTLB_ASSERTS_NEVER( AS_DEVTLB_TLB_LRU_WRTHENRD3CKLATER,
                (TLBPipeV_H[TLB_TAG_RD] & TLBPipe_H[TLB_TAG_RD].Ctrl.Fill && (TLBPipe_H[TLB_TAG_RD].Info.EffSize == g_ps)
                & (~|TLBPipe_H[TLB_TAG_RD].ArrInfo[g_ps].HitVec) & (&TLBPipe_H[TLB_TAG_RD].ArrInfo[g_ps].ValVec)
                & TLBPipeV_H[TLB_TAG_RD+3] & TLBPipe_H[TLB_TAG_RD+3].ArrCtrl[g_ps].LRUWrEn
                & (TLBPipe_H[TLB_TAG_RD].ArrCtrl[g_ps].SetAddr == TLBPipe_H[TLB_TAG_RD+3].ArrCtrl[g_ps].SetAddr)
                & (  (f_IOMMU_Opcode_is_DMA(TLBPipe_H[TLB_TAG_RD+3].Req.Opcode)
                      & (TLBPipe_H[TLB_TAG_RD].ArrInfo[g_ps].RepVec == TLBPipe_H[TLB_TAG_RD+3].ArrInfo[g_ps].HitVec) )
                  || (f_IOMMU_Opcode_is_FILL(TLBPipe_H[TLB_TAG_RD+3].Req.Opcode)
                      & (TLBPipe_H[TLB_TAG_RD].ArrInfo[g_ps].RepVec == TLBPipe_H[TLB_TAG_RD+3].ArrInfo[g_ps].RepVec) ))
                & ~(TLBPipe_H[TLB_TAG_RD+1].ArrCtrl[g_ps].LRUWrEn &
                   (TLBPipe_H[TLB_TAG_RD].ArrCtrl[g_ps].SetAddr == TLBPipe_H[TLB_TAG_RD+1].ArrCtrl[g_ps].SetAddr))
                & ~(TLBPipe_H[TLB_TAG_RD+2].ArrCtrl[g_ps].LRUWrEn &
                   (TLBPipe_H[TLB_TAG_RD].ArrCtrl[g_ps].SetAddr == TLBPipe_H[TLB_TAG_RD+2].ArrCtrl[g_ps].SetAddr))),
          posedge clk, reset_INST,
       `HQM_DEVTLB_ERR_MSG("LRU selected the recently Hit Way for Fill"));
end
endgenerate

generate
for(g_ps=PS_MIN; g_ps<=PS_MAX; g_ps++) begin: ps_rfaccess
    if (NUM_PS_SETS[g_ps] > 1) begin: NUM_SET_2
        `HQM_DEVTLB_ASSERTS_NEVER(DEVTLB_TagArrayGen_Rd_Wr_Conflict,
               (DEVTLB_Tag_RdEn[g_ps] & DEVTLB_Tag_WrEn[g_ps]) &
               (f_IOMMU_Opcode_is_AnyInvalidation(TLBPipe_H[TLB_TAG_WR_CTRL].Req.Opcode) || 
                !f_IOMMU_Opcode_is_DMA(TLBPipe_H[TLB_TAG_RD_CTRL].Req.Opcode)) &
               (DEVTLB_Tag_Rd_Addr[g_ps] == DEVTLB_Tag_Wr_Addr[g_ps]),
            posedge clk, reset_INST, `HQM_DEVTLB_ERR_MSG("DEVTLB: Array Same Cycle Read/Write Conflict"));

        `HQM_DEVTLB_ASSERTS_NEVER(DEVTLB_DataArrayGen_Rd_Wr_Conflict,
               (DEVTLB_Data_RdEn[g_ps] & DEVTLB_Data_WrEn[g_ps]) &
               (f_IOMMU_Opcode_is_AnyInvalidation(TLBPipe_H[TLB_DATA_WR_CTRL].Req.Opcode) || 
                !f_IOMMU_Opcode_is_DMA(TLBPipe_H[TLB_DATA_RD_CTRL].Req.Opcode)) &
               (DEVTLB_Data_Rd_Addr[g_ps] == DEVTLB_Data_Wr_Addr[g_ps]),
            posedge clk, reset_INST, `HQM_DEVTLB_ERR_MSG("DEVTLB: Array Same Cycle Read/Write Conflict"));
    end  else begin: NUM_SET_1
        `HQM_DEVTLB_ASSERTS_NEVER(DEVTLB_Tag_Rd_Wr_Conflict_Next_Cycle,
               (DEVTLB_Tag_RdEn[g_ps] & DEVTLB_Tag_WrEn[g_ps] &
                (f_IOMMU_Opcode_is_AnyInvalidation(TLBPipe_H[TLB_TAG_WR_CTRL].Req.Opcode) || 
                !f_IOMMU_Opcode_is_DMA(TLBPipe_H[TLB_DATA_RD_CTRL].Req.Opcode))),
            posedge clk, reset_INST, `HQM_DEVTLB_ERR_MSG("DEVTLB Array Following Cycle Read/Write Conflict"));

        `HQM_DEVTLB_ASSERTS_NEVER(DEVTLB_Data_Rd_Wr_Conflict_Next_Cycle,
               (DEVTLB_Data_RdEn[g_ps] & DEVTLB_Data_WrEn[g_ps] &
               (f_IOMMU_Opcode_is_AnyInvalidation(TLBPipe_H[TLB_DATA_WR_CTRL].Req.Opcode) || 
                !f_IOMMU_Opcode_is_DMA(TLBPipe_H[TLB_DATA_RD_CTRL].Req.Opcode))),
            posedge clk, reset_INST, `HQM_DEVTLB_ERR_MSG("DEVTLB Array Following Cycle Read/Write Conflict"));
    end
end
endgenerate

`HQM_DEVTLB_ASSERTS_TRIGGER(AS_DEVTLB_TLBInfoSize,
   TLBPipeV_H[TLB_DATA_RD], ~(TLBPipe_H[TLB_DATA_RD].Info.Size==T_PGSIZE'(SIZE_QP)),
   posedge clk, reset, 
`HQM_DEVTLB_ERR_MSG("SIZE_QP is not supported")); 

/*
generate
for(g_ps=PS_MIN; g_ps<=PS_MAX; g_ps++) begin: ps_as_lru
        `HQM_DEVTLB_ASSERTS_NEVER(DEVTLB_LRU_Never_RdInvert,
               (DEVTLB_LRU_Rd_Invert[g_ps] & DEVTLB_LRU_RdEn[g_ps]),
            posedge clk, reset_INST, `HQM_DEVTLB_ERR_MSG("DEVTLB_LRU_Rd_Invert is not expected"));
end
endgenerate
*/
endmodule

`endif // IOMMU_TLB_VS

