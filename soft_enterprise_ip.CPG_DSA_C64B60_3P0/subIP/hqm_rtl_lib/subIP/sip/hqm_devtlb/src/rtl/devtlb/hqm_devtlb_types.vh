//=====================================================================================================================
//
// iommu_types.vh
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


//=====================================================================================================================
//=====================================================================================================================
//
// DO NOT ifndef this file...it should get included in all interface declarations that expect to use instance specific parameters
//
//=====================================================================================================================
//=====================================================================================================================
//`ifndef IOMMU_TYPES_VH
//`define IOMMU_TYPES_VH


//=====================================================================================================================
// Constants
//=====================================================================================================================

parameter int DEVTLB_DID_WIDTH                  = 16;

// ace doesn't like when this parameter is dependant on IOMMU_MAX_REQ_CNT for some reason. Hard coded with an assertion
// in iommu.sv to ensure that it is always large enough to represent the maximum number of possible requests.
//
parameter int DEVTLB_INTERNAL_REQ_ID_WIDTH      = 10; // `DEVTLB_LOG2(IOMMU_MAX_REQ_CNT+1);
                                               
// Internal Storage Widths which may store GPA/HPA, or GPA/LA
//
//parameter  int DEVTLB_LAW_HAW_MAX        = (DEVTLB_MAX_LINEAR_ADDRESS_WIDTH > DEVTLB_MAX_HOST_ADDRESS_WIDTH) 
//                                        ?  DEVTLB_MAX_LINEAR_ADDRESS_WIDTH : DEVTLB_MAX_HOST_ADDRESS_WIDTH;
//parameter  int DEVTLB_GAW_HAW_MAX        = (DEVTLB_MAX_GUEST_ADDRESS_WIDTH > DEVTLB_MAX_HOST_ADDRESS_WIDTH) 
//                                        ?  DEVTLB_MAX_GUEST_ADDRESS_WIDTH : DEVTLB_MAX_HOST_ADDRESS_WIDTH;
parameter  int DEVTLB_GAW_LAW_MAX        = (DEVTLB_MAX_GUEST_ADDRESS_WIDTH > DEVTLB_MAX_LINEAR_ADDRESS_WIDTH) 
                                        ?  DEVTLB_MAX_GUEST_ADDRESS_WIDTH : DEVTLB_MAX_LINEAR_ADDRESS_WIDTH;
                                               
parameter int PS_MAX              = 2;    // Page size tlbs supported 0=4K, 1=2M, 2=1G, 3=0.5T
parameter int PS_MIN              = 0;    // Page size tlbs supported 0=4K, 1=2M, 2=1G, 3=0.5T




//=====================================================================================================================
// Major Interface TypeDefs
//=====================================================================================================================

typedef enum logic [2:0] {
   SIZE_4K        = `HQM_DEVTLB_PS_4K,
   SIZE_2M        = `HQM_DEVTLB_PS_2M,
   SIZE_1G        = `HQM_DEVTLB_PS_1G,
   SIZE_5T        = `HQM_DEVTLB_PS_5T,
   SIZE_QP        = `HQM_DEVTLB_PS_QP    // Q = quarter, P = petabyte
} t_devtlb_page_type;

// Primary request info...all as received from parent and passed around IOMMU
//
typedef struct packed {

`ifdef HQM_DEVTLB_SIMONLY 
   logic [DEVTLB_INTERNAL_REQ_ID_WIDTH-1:0] i_ID;       // INSTRUMENTATION LOGIC: unique IOMMU ID
`endif

   // parity is not technically part of the request but it is placed in this structure for convenience 
   //
   logic [DEVTLB_PARITY_WIDTH-1:0]        Parity;           // Final Resolved Parity...assume dual in pipeline

   ////////////////////////////////////////////////////////////////////////////////////////////////////

   logic                                  Overflow;         // Address Overflow

   logic [DEVTLB_PORTS_IDW-1:0]        PortId;          // Port # where the req is submitted to
   logic [2:0]                            tc;             // Traffic class

   logic                                  Prs;              // PRS is requested if ats fault.
   
   logic [DEVTLB_REQ_ID_WIDTH-1:0]        ID;               // ID as assigned by requesting agent
   logic [$clog2(DEVTLB_MISSTRK_DEPTH)-1:0] MsTrkIdx;         // MsTrk Entry where the FillReq comes from

   // The following five fields MUST remain in this order because they are used in a CAM port in the msproc
   t_devtlb_opcode                        Opcode;           // Read, write, atomic
   logic                                  Priority;         // Request Priority (1 = High Priority)
   logic                                  MPrior;            // Request Priority (1 = High Priority)
                                                             // Mask-abled by defeature bit.
   logic [DEVTLB_TLBID_WIDTH-1:0]         TlbId;            // The TLB in which to cache the translation
   logic                                  PasidV;           // Valid PASID input
   logic [DEVTLB_PASID_WIDTH-1:0]         PASID;            // PCIE Function ID for ATS
//   logic                                  ER;               // Execute Request
   logic                                  PR;               // Privileged Mode Request
   logic [DEVTLB_BDF_WIDTH-1:0]           BDF;              // PCIE BDF ID
   logic [DEVTLB_REQ_PAYLOAD_MSB:DEVTLB_REQ_PAYLOAD_LSB]
                                          Address;          // Input payload (DMA address or interrupt address/data)
} t_devtlb_request;

typedef struct packed {
    logic                                  HitMsTrkVld;
    logic [$clog2(DEVTLB_MISSTRK_DEPTH)-1:0]         HitMsTrkIdx;
    logic ForceXRsp;
    logic [1:0] PrsCode;
    logic DPErr;
    logic HdrErr;
    t_devtlb_request                       Req;
} t_devtlb_procreq;

typedef struct packed {
   // The following five fields MUST remain in this order because they are used in a CAM port in the mstrk table
   //
//   t_devtlb_opcode                        Opcode;           // Read, write, atomic
   logic                                  MPrior;            // Request Priority (1 = High Priority)
                                                             // Mask-abled by defeature bit.
   logic [DEVTLB_TLBID_WIDTH-1:0]         TlbId;            // The TLB in which to cache the translation
   logic                                  PasidV;           // Valid PASID input
   logic [DEVTLB_PASID_WIDTH-1:0]         PASID;            // PCIE Function ID for ATS
   //logic                                  ER;               // Execute Request
   logic                                  PR;               // Privileged Mode Request
   logic [DEVTLB_BDF_WIDTH-1:0]           BDF;              // PCIE BDF ID
   logic [DEVTLB_REQ_PAYLOAD_MSB:DEVTLB_REQ_PAYLOAD_LSB]
                                          Address;          // Input payload (DMA address or interrupt address/data)
} t_devtlb_camreq;

//=====================================================================================================================
// Internal Structure TypeDefs - TLB Pipeline
//=====================================================================================================================

typedef logic [15:0]                                     t_devtlb_tlb_setaddr;

// Invalidation related controls
// ATC Inv-Q Structure
typedef struct packed {
  logic [DEVTLB_PARITY_WIDTH-1:0]  Parity;
  logic                          InvQPErr;
  logic                          IODPErr;  // parity error at the inv-Q ingress, i.e ipi interface.
  logic                          InvAOR;  // InvAddress out of range.
  logic                    [4:0] ITag;
  logic                          BdfV;
  logic [DEVTLB_BDF_WIDTH-1:0]   BDF;
  logic                          PasidV;
  logic [DEVTLB_PASID_WIDTH-1:0] PASID;
  logic                          PR;
  logic                          Glob;
  logic                          Size;
  logic [DEVTLB_REQ_PAYLOAD_MSB:DEVTLB_REQ_PAYLOAD_LSB] Address;
} t_devtlb_invreq;

typedef struct {
   logic                                  Start;
   logic                                  End;
   logic                                  Reset;
   logic                                  InProgress;
} t_devtlb_inval_status;

// Control related structure primary request....holds signals that control
// what type of lookup is expected and what to do as a result

typedef union packed {
  logic    FillLast; // last among fills on xreq_ports's pipeline
  logic    InvAOR;   // InvReq AOR, this is only used to invalidate all FL entrries when PASID_SUPP_EN && invreq without pasid tlp
} ctrl_flg_t;
   
typedef struct packed {
   logic                                  ForceXRsp; // Set only if this is a req from PendQ and wake by atsrsp with RW=00
   logic                                  PendQXReq; // Set only if this is a req from Pendq
   logic                                  Fill;
   logic [0:0]                            FillReqOp; // 1 if If Fill is due to DMA_R
   ctrl_flg_t                             CtrlFlg; 
   logic                                  GL;               // Global Hint for page-selective-within-PASID invalidation
   logic [PS_MAX:PS_MIN]                  DisRdEn;
   logic                                  InvalGlb;            // Caches potentially affected: CC, IOTLB, PASID, FLPWC, SLPWC, IEC
   logic                                  InvalDTLB;           // Caches potentially affected: CC, IOTLB, PASID, FLPWC, SLPWC
   logic [5:0]                            InvalMaskBits;       // How many bits of the address to mask on the invalidation match
   logic                                  InvalBdfMask;        // If 1, all BDF is masked on invalidation match
//   logic                                  InvalPasidMask;      // If 1, all PASID is masked on invalidation match
   logic [15:0]                           InvalSetAddr;        // Input payload (DMA address or interrupt address/data)
} t_devtlb_request_ctrl;

typedef struct packed {
   logic                                  Hit;              // Final Hit
   
   logic [DEVTLB_PARITY_WIDTH-1:0]        Parity;           // Final Resolved Parity...assume dual in pipeline
   logic                                  ParityError;      // ParityError Observed, fill? atsrsp_dperr : data rf parity error
                                                            // at Pipe output, it is the final resolved ParityError
   logic                                  HeaderError;      // CTO/CA/UA on ATSRsp

   logic                                  Fault;
   logic [1:0]                            PrsCode;          // Prs Response status
   //t_devtlb_fault_reason                  FaultReason;
   t_devtlb_page_type                     Size;             // Page size provided by the page walker
   t_devtlb_page_type                     EffSize;          // Page size to be filled after fracturing
   t_devtlb_page_type                     PSSel;            // Which Pagesize Array Was Selected
   logic [5:0]                            am;               // Address mask used for invalidation

   logic                                  Global;           // Global Page                           (IOTLB)
   logic                                  N;                // Snoop                                 (IOTLB)
   logic [DEVTLB_MEMTYPE_WIDTH-1:0]       Memtype;          // Memory type of final HPA              (IOTLB)
   logic                                  U;                // transient Mapping                     (SLPWC)
   logic                                  X;                // Execute Request
   logic                                  R;                // Readable                              (IOTLB/SLPWC/FLPWC) 
   logic                                  W;                // Writable                              (SLPWC/FLPWC)  
   //logic [DEVTLB_DID_WIDTH-1:0]           DID;              // Domain ID                             (ALL)

   t_devtlb_resp_status                   Status;           // Result status                          (IOTLB)
   logic [DEVTLB_PRIV_DATA_WIDTH-1:0]     Priv_Data;
   logic [DEVTLB_MAX_HOST_ADDRESS_WIDTH-1:12]   
                                          Address;    // HPA
} t_devtlb_request_info;

typedef struct packed {
   logic                                        Fill;
   logic                                        InvalDTLB;
//   logic                                        WrEn;
   logic [DEVTLB_TLBID_WIDTH-1:0]               TlbId;
   logic [PS_MAX:PS_MIN]                        DisRdEn;
} t_devtlb_arbtlbinfo;

typedef struct packed {
   logic [DEVTLB_MAX_HOST_ADDRESS_WIDTH-1:12]   fill_address;  
   logic                                        fill_inv_size;
   logic                                        fill_no_snoop;
   logic                                        fill_untrans;
   logic                                        fill_r;
   logic                                        fill_w;
   logic                                        fill_x;
   logic                                        fill_inv_g;
   logic [DEVTLB_PRIV_DATA_WIDTH-1:0]           fill_priv_data; 
   logic [DEVTLB_MEMTYPE_WIDTH-1:0]             fill_memtype;
} t_devtlb_fillreq;

typedef struct {
   logic                                  LRUWrEn;          // Computed Write Enable for each array
   logic                                  RdEn;             // Computed Read Enable for each array
   logic                                  WrEn;             // Computed Write Enable for each array
   logic                                  ArrWrEn;          // Final Write Enable for each array
   t_devtlb_tlb_setaddr                   SetAddr;          // Computed Set Address for each array
} t_ctrl_perarray;

typedef logic [DEVTLB_TLB_NUM_WAYS-1:0]        t_tlb_bitperway;

typedef struct {
   logic                                  Hit;              // The TLB Lookup hit a TLB Entry
   logic [DEVTLB_PARITY_WIDTH-1:0]        TagParity;        // Expected Parity
   logic [DEVTLB_PARITY_WIDTH-1:0]        DatParity;        // Expected Parity
   t_tlb_bitperway                        HitVec;           // The TLB The way that hit
   t_tlb_bitperway                        ValVec;           // The TLB The ways that have valid entries
   t_tlb_bitperway                        RepVec;           // The way that should be replaced...one hot vector
   t_tlb_bitperway                        TagParErr;        // The TLB
} t_info_perarray;

typedef struct {
      t_devtlb_request         Req;
      t_devtlb_request_ctrl    Ctrl;
      t_devtlb_request_info    Info;
      t_info_perarray         ArrInfo     [IOTLB_PS_MAX:IOTLB_PS_MIN]; // Info about the cache lookups for each array
      t_ctrl_perarray         ArrCtrl     [IOTLB_PS_MAX:IOTLB_PS_MIN]; // Control for cache lookups for each array
} t_request_complete;

//Miss Trk FSM
typedef enum logic [3:0] {
    MSTRKIDLE,
    AREQHOLD,  // inv move state to here to block AREQI
    AREQARB,
    AREQINIT,
    AREQEND,
    PREQARB,
    //PREQINIT,
    PREQEND,
    AINVARB,
    AINVINIT,
    AREQREP,
    FREQARB,
    FREQINIT,
    FREQDLY,
    FREQEND,
    FINVARB,
    FINVINIT
} t_mstrk_state;

//Miss Trk FSM
typedef enum logic [1:0] {
    PENDQIDLE,
    PENDQARSP,
    PENDQXREQI,
    PENDQXREQE
} t_pendq_state;

typedef struct packed {
    //logic Priority;
    logic ForceXRsp;
    logic [1:0] PrsCode;
    logic DPErr;
    logic HdrErr;
} t_wakeinfo;

typedef struct packed {
    //logic Priority;
    logic W;
    logic R;
    logic [1:0] PrsCode;
    //logic ForceXRsp;
    logic DPErr;
    logic HdrErr;
    logic FillLast;
} t_fillinfo;

//Miss Trk ATs Rsp
typedef struct packed {
    logic [DEVTLB_PARITY_WIDTH-1:0]  Parity; //MsTrk Rsp Array Parity
    logic                            DPErr;  // DPErr on ATSRsp
    logic                            HdrErr; // CTO/CA/UA on ATSRsp
    logic [DEVTLB_MAX_HOST_ADDRESS_WIDTH-1:DEVTLB_REQ_PAYLOAD_LSB]       Address;
    logic                            Size;
    logic                            Glob;
    logic                            N;
    logic                            Priv;
    logic                            X;
    logic                            U;
    logic                            W;
    logic                            R;
} t_mstrk_atsrsp;

// In the tag entry, not all fields are used for each tlb type. We depend
// on logic synthesis' constant propagation to eliminate the unused fields
//
typedef struct packed {
   logic [DEVTLB_PARITY_WIDTH-1:0]                             Parity;
   logic                                                       ValidSL;   //entry requested without PASID
   logic                                                       ValidFL;   //entry requested with PASID
   logic [DEVTLB_PASID_WIDTH-1:0]                              PASID;
   logic                                                       Global;
   logic                                                       PR;               
   logic [DEVTLB_BDF_WIDTH-1:0]                                BDF;        // PCIe Bus/Device/Function, or just Function
   logic [DEVTLB_GAW_LAW_MAX-1:12]                             Address;    // Input Address        
                                                                           // Address should always be LSB field
} t_devtlb_iotlb_4k_tag_entry;

// In the tag entry, not all fields are used for each tlb type. We depend
// on logic synthesis' constant propagation to eliminate the unused fields
//
typedef struct packed {
   logic [DEVTLB_PARITY_WIDTH-1:0]                             Parity;
   logic                                                       ValidSL;
   logic                                                       ValidFL;
   logic [DEVTLB_PASID_WIDTH-1:0]                              PASID;
   logic                                                       Global;
   logic                                                       PR;               
   logic [DEVTLB_BDF_WIDTH-1:0]                                BDF;        // PCIe Bus/Device/Function, or just Function
   logic [DEVTLB_GAW_LAW_MAX-1:21]                             Address;    // Input Address        RCC=na
} t_devtlb_iotlb_2m_tag_entry;

// In the tag entry, not all fields are used for each tlb type. We depend
// on logic synthesis' constant propagation to eliminate the unused fields
//
typedef struct packed {
   logic [DEVTLB_PARITY_WIDTH-1:0]                             Parity;
   logic                                                       ValidSL;
   logic                                                       ValidFL;
   logic [DEVTLB_PASID_WIDTH-1:0]                              PASID;
   logic                                                       Global;
   logic                                                       PR;               
   logic [DEVTLB_BDF_WIDTH-1:0]                                BDF;        // PCIe Bus/Device/Function, or just Function
   logic [DEVTLB_GAW_LAW_MAX-1:30]                             Address;    // Input Address        RCC=na
} t_devtlb_iotlb_1g_tag_entry;

// In the tag entry, not all fields are used for each tlb type. We depend
// on logic synthesis' constant propagation to eliminate the unused fields
//
typedef struct packed {
   logic [DEVTLB_PARITY_WIDTH-1:0]                             Parity;
   logic                                                       ValidSL;
   logic                                                       ValidFL;
   logic [DEVTLB_PASID_WIDTH-1:0]                              PASID;
   logic                                                       Global;
   logic                                                       PR;               
   logic [DEVTLB_BDF_WIDTH-1:0]                                BDF;        // PCIe Bus/Device/Function, or just Function
   logic [DEVTLB_GAW_LAW_MAX-1:39]                             Address;    // Input Address        RCC=na
} t_devtlb_iotlb_5t_tag_entry;

typedef struct packed {
   logic [DEVTLB_PARITY_WIDTH-1:0]                             Parity;
   logic                                                       ValidSL;
   logic                                                       ValidFL;
   logic [DEVTLB_PASID_WIDTH-1:0]                              PASID;
   logic                                                       Global;
   logic                                                       PR;               
   logic [DEVTLB_BDF_WIDTH-1:0]                                BDF;        // PCIe Bus/Device/Function, or just Function
   logic [63:48]                                               Address;    // Input Address        RCC=na
} t_devtlb_iotlb_Qp_tag_entry;

//following io_tag struct should be removed once tag struc above is optimized.

typedef struct packed {
   logic [DEVTLB_PARITY_WIDTH-1:0]                             Parity;
   logic                                                       ValidSL;
   logic                                                       ValidFL;
   logic [DEVTLB_PASID_WIDTH-1:0]                              PASID;
   // logic                                                       Global;
   logic                                                       PR;
   logic [DEVTLB_BDF_WIDTH-1:0]                                BDF;        // PCIe Bus/Device/Function, or just Function
   logic [DEVTLB_MAX_LINEAR_ADDRESS_WIDTH-1:12]                Address;    // Input Address        
                                                                           // Address should always be LSB field
} t_devtlb_io_4k_tag_entry;

// In the tag entry, not all fields are used for each tlb type. We depend
// on logic synthesis' constant propagation to eliminate the unused fields
//
typedef struct packed {
   logic [DEVTLB_PARITY_WIDTH-1:0]                             Parity;
   logic                                                       ValidSL;
   logic                                                       ValidFL;
   logic [DEVTLB_PASID_WIDTH-1:0]                              PASID;
   // logic                                                       Global;
   logic                                                       PR;
   logic [DEVTLB_BDF_WIDTH-1:0]                                BDF;        // PCIe Bus/Device/Function, or just Function
   logic [DEVTLB_MAX_LINEAR_ADDRESS_WIDTH-1:21]                Address;    // Input Address        RCC=na
} t_devtlb_io_2m_tag_entry;

// In the tag entry, not all fields are used for each tlb type. We depend
// on logic synthesis' constant propagation to eliminate the unused fields
//
typedef struct packed {
   logic [DEVTLB_PARITY_WIDTH-1:0]                             Parity;
   logic                                                       ValidSL;
   logic                                                       ValidFL;
   logic [DEVTLB_PASID_WIDTH-1:0]                              PASID;
   // logic                                                       Global;
   logic                                                       PR;
   logic [DEVTLB_BDF_WIDTH-1:0]                                BDF;        // PCIe Bus/Device/Function, or just Function
   logic [DEVTLB_MAX_LINEAR_ADDRESS_WIDTH-1:30]                Address;    // Input Address        RCC=na
} t_devtlb_io_1g_tag_entry;

// In the tag entry, not all fields are used for each tlb type. We depend
// on logic synthesis' constant propagation to eliminate the unused fields
//
typedef struct packed {
   logic [DEVTLB_PARITY_WIDTH-1:0]                             Parity;
   logic                                                       ValidSL;
   logic                                                       ValidFL;
   logic [DEVTLB_PASID_WIDTH-1:0]                              PASID;
   // logic                                                       Global;
   logic                                                       PR;
   logic [DEVTLB_BDF_WIDTH-1:0]                                BDF;        // PCIe Bus/Device/Function, or just Function
   logic [DEVTLB_MAX_LINEAR_ADDRESS_WIDTH-1:39]                Address;    // Input Address        RCC=na
} t_devtlb_io_5t_tag_entry;

typedef struct packed {
   logic [DEVTLB_PARITY_WIDTH-1:0]                             Parity;
   logic                                                       ValidSL;
   logic                                                       ValidFL;
   logic [DEVTLB_PASID_WIDTH-1:0]                              PASID;
   // logic                                                       Global;
   logic                                                       PR;
   logic [DEVTLB_BDF_WIDTH-1:0]                                BDF;        // PCIe Bus/Device/Function, or just Function
   logic [63:48]                                               Address;    // TODO width Input Address        RCC=na
} t_devtlb_io_Qp_tag_entry;

// In the data entry, not all fields are used for each tlb type. We depend
// on logic synthesis' constant propagation to eliminate the unused fields
//
typedef struct packed {
   logic [DEVTLB_PARITY_WIDTH-1:0]                             Parity;
   logic                                                       U;
   logic                                                       N;
   logic                                                       X;     
   logic                                                       R;                
   logic                                                       W;                
   logic [DEVTLB_MEMTYPE_WIDTH-1:0]                            Memtype;
   logic [DEVTLB_PRIV_DATA_WIDTH-1:0]                          Priv_Data;
   logic [DEVTLB_MAX_HOST_ADDRESS_WIDTH-1:12]                  Address;    // Address should always be LSB field
} t_devtlb_iotlb_4k_data_entry;

typedef struct packed {
   logic [DEVTLB_PARITY_WIDTH-1:0]                             Parity;
   logic                                                       U;
   logic                                                       N; 
   logic                                                       X;     
   logic                                                       R;                
   logic                                                       W;                
   logic [DEVTLB_MEMTYPE_WIDTH-1:0]                            Memtype;          
   logic [DEVTLB_PRIV_DATA_WIDTH-1:0]                          Priv_Data;
   logic [DEVTLB_MAX_HOST_ADDRESS_WIDTH-1:21]                  Address;    // Address should always be LSB field
} t_devtlb_iotlb_2m_data_entry;

typedef struct packed {
   logic [DEVTLB_PARITY_WIDTH-1:0]                             Parity;
   logic                                                       U;
   logic                                                       N;
   logic                                                       X;     
   logic                                                       R;                
   logic                                                       W;                
   logic [DEVTLB_MEMTYPE_WIDTH-1:0]                            Memtype;          
   logic [DEVTLB_PRIV_DATA_WIDTH-1:0]                          Priv_Data;
   logic [DEVTLB_MAX_HOST_ADDRESS_WIDTH-1:30]                  Address;    // Address should always be LSB field
} t_devtlb_iotlb_1g_data_entry;

typedef struct packed {
   logic [DEVTLB_PARITY_WIDTH-1:0]                             Parity;
   logic                                                       U;
   logic                                                       N;
   logic                                                       X;     
   logic                                                       R;                
   logic                                                       W;                
   logic [DEVTLB_MEMTYPE_WIDTH-1:0]                            Memtype;          
   logic [DEVTLB_PRIV_DATA_WIDTH-1:0]                          Priv_Data;
   logic [47:39]                                               Address;    // Address should always be LSB field
   //logic [DEVTLB_LAW_HAW_MAX-1:39]                             Address;    // Address should always be LSB field
} t_devtlb_iotlb_5t_data_entry;

typedef struct packed {
   logic [DEVTLB_PARITY_WIDTH-1:0]                             Parity;
   logic                                                       U;
   logic                                                       N;
   logic                                                       X;     
   logic                                                       R;                
   logic                                                       W;                
   logic [DEVTLB_MEMTYPE_WIDTH-1:0]                            Memtype;          
   logic [DEVTLB_PRIV_DATA_WIDTH-1:0]                          Priv_Data;
   logic [56:48]                                               Address;    // Address should always be LSB field
   //logic [DEVTLB_LAW_HAW_MAX-1:48]                             Address;    // Address should always be LSB field
} t_devtlb_iotlb_Qp_data_entry;

//following io_tag struct should be removed once tag struc above is optimized.
typedef struct packed {
   logic [DEVTLB_PARITY_WIDTH-1:0]                             Parity;
   logic                                                       RSVD; //U;
   logic                                                       N;
//   logic                                                       X;     
   logic                                                       R;                
   logic                                                       W;                
//   logic [DEVTLB_MEMTYPE_WIDTH-1:0]                            Memtype;
//   logic [DEVTLB_PRIV_DATA_WIDTH-1:0]                          Priv_Data;
   logic [DEVTLB_MAX_HOST_ADDRESS_WIDTH-1:12]                  Address;    // Address should always be LSB field
} t_devtlb_io_4k_data_entry;

typedef struct packed {
   logic [DEVTLB_PARITY_WIDTH-1:0]                             Parity;
   logic                                                       RSVD; //U;
   logic                                                       N; 
//   logic                                                       X;     
   logic                                                       R;                
   logic                                                       W;                
//   logic [DEVTLB_MEMTYPE_WIDTH-1:0]                            Memtype;          
//   logic [DEVTLB_PRIV_DATA_WIDTH-1:0]                          Priv_Data;
   logic [DEVTLB_MAX_HOST_ADDRESS_WIDTH-1:21]                  Address;    // Address should always be LSB field
} t_devtlb_io_2m_data_entry;

typedef struct packed {
   logic [DEVTLB_PARITY_WIDTH-1:0]                             Parity;
   logic                                                       RSVD; //U;
   logic                                                       N;
//   logic                                                       X;     
   logic                                                       R;                
   logic                                                       W;                
//   logic [DEVTLB_MEMTYPE_WIDTH-1:0]                            Memtype;          
//   logic [DEVTLB_PRIV_DATA_WIDTH-1:0]                          Priv_Data;
   logic [DEVTLB_MAX_HOST_ADDRESS_WIDTH-1:30]                  Address;    // Address should always be LSB field
} t_devtlb_io_1g_data_entry;

typedef struct packed {
   logic [DEVTLB_PARITY_WIDTH-1:0]                             Parity;
   logic                                                       RSVD; //U;
   logic                                                       N;
//   logic                                                       X;     
   logic                                                       R;                
   logic                                                       W;                
//   logic [DEVTLB_MEMTYPE_WIDTH-1:0]                            Memtype;          
//   logic [DEVTLB_PRIV_DATA_WIDTH-1:0]                          Priv_Data;
   logic [47:39]                                               Address;    // Address should always be LSB field
   //logic [DEVTLB_LAW_HAW_MAX-1:39]                             Address;    // Address should always be LSB field
} t_devtlb_io_5t_data_entry;

typedef struct packed {
   logic [DEVTLB_PARITY_WIDTH-1:0]                             Parity;
   logic                                                       RSVD; //U;
   logic                                                       N;
//   logic                                                       X;     
   logic                                                       R;                
   logic                                                       W;                
//   logic [DEVTLB_MEMTYPE_WIDTH-1:0]                            Memtype;          
//   logic [DEVTLB_PRIV_DATA_WIDTH-1:0]                          Priv_Data;
   logic [56:48]                                               Address;    // Address should always be LSB field
   //logic [DEVTLB_LAW_HAW_MAX-1:48]                             Address;    // Address should always be LSB field
} t_devtlb_io_Qp_data_entry;

//=====================================================================================================================
// Defeature CR signal typedefs
//=====================================================================================================================

// MISC defeature signal
typedef struct packed {
   logic [19:0]   iotlbdis;                 // reg[12:31]  Disabling some or all ways of a TLB. Only supporting first 10 TLBs, 2 bits Per TLBID. 11:all disabled, 10:1/2, 01: 1/4, 00:none
   logic          dfx_array_scan_mode_en;   // reg[11]  Force all iommu latch based arrays into loopback scanmode
   logic [7:0]    dfx_array_scan_mode_way;  // reg[10:3]    Force latch based TLB Tag & Data arrays into loopback scanmode. Only applicable if DEVTLB_TLB_ARRAY_STYLE=ARRAY_LATCH.
                                            //             This is currently defined to be 8 bits, covering 256 "ways".
                                            //             That size is needed to cover fully associative arrays that are coded
                                            //             as 1-set x N-ways (where N is up to 256).
   logic          stallhcbfifo;             // reg[2]      Stall hi prior credit buffer fifo
   logic          stalllcbfifo;             // reg[1]      Stall lo prior credit buffer fifo
   logic          dispartinv;               // reg[0]      force TLB invalidation requests to global
} t_devtlb_cr_misc_dis_defeature;

typedef struct packed {
   logic [31:0]   spare;             // reg[31:0]   spare
} t_devtlb_cr_spare_defeature;

// Powerdown Override defeature signal
typedef struct packed {
   logic [22:0]   spare;            // reg[31:9]    Currently unneeded
   logic          pdo_pendq;          // reg[8]       Powerdown Override Defeature for specified DEVTLB subcomponent 
   logic          pdo_mstrk;          // reg[7]       Powerdown Override Defeature for specified DEVTLB subcomponent 
   logic          pdo_msproc;          // reg[6]       Powerdown Override Defeature for specified DEVTLB subcomponent 
   logic          pdo_inv;          // reg[5]       Powerdown Override Defeature for specified DEVTLB subcomponent 
   logic          pdo_tlb_lru;      // reg[4]       Powerdown Override Defeature for specified DEVTLB subcomponent 
   logic          pdo_tlb_array;    // reg[3]       Powerdown Override Defeature for specified DEVTLB subcomponent 
   logic          pdo_tlb;          // reg[2]       Powerdown Override Defeature for specified DEVTLB subcomponent 
   logic          pdo_tlbarb;       // reg[1]       Powerdown Override Defeature for specified DEVTLB subcomponent 
   logic          pdo_cb;           // reg[0]       Powerdown Override Defeature for specified DEVTLB subcomponent 
} t_devtlb_cr_pwrdwn_ovrd_dis_defeature;

typedef struct packed {
   logic [19:0]   spare;            // reg[12:31]
   logic          disable_iotlb_parityerror;    // [11]
   logic          one_shot_mode;    // reg[10]      Forces parity error injection on current cycle only
   logic          iotlb_250t_tag;   // reg[9]
   logic          iotlb_500g_tag;   // reg[8]
   logic          iotlb_1g_tag;     // reg[7]
   logic          iotlb_2m_tag;     // reg[6]
   logic          iotlb_4k_tag;     // reg[5]
   logic          iotlb_250t_data;  // reg[4]
   logic          iotlb_500g_data;  // reg[3]
   logic          iotlb_1g_data;    // reg[2]
   logic          iotlb_2m_data;    // reg[1]
   logic          iotlb_4k_data;    // reg[0]
} t_devtlb_cr_parity_err;

//=====================================================================================================================
// PCIe CR signal typedefs
//=====================================================================================================================

typedef struct packed {
    logic [11:0] nxtcap; // RO-V
    logic  [3:0] capver; // RO
    logic [15:0] extcapid; // RO
} t_devtlb_atsextcap;

typedef struct packed {
    logic  [8:0] reserved0; // RV
    logic        gis; // RO
    logic        par; // RO
    logic  [4:0] iqd; // RO
} t_devtlb_atscap;

typedef struct packed {
    logic        en; // RW
    logic  [9:0] reserved0; // RV
    logic  [4:0] stu; // RW
} t_devtlb_atsctl;

typedef struct packed {
    logic [11:0] nxtcap; // RO-V
    logic  [3:0] capver; // RO
    logic [15:0] extcapid; // RO
} t_devtlb_pasidextcap;

typedef struct packed {
    logic  [2:0] reserved2; // RV
    logic  [4:0] maxwid; // RO
    logic  [4:0] reserved1; // RV
    logic        pms; // RO
    logic        eps; // RO
    logic        reserved0; // RV
} t_devtlb_pasidcap;

typedef struct packed {
    logic [12:0] reserved0; // RV
    logic        pme; // RW
    logic        epe; // RO
    logic        pe; // RW
} t_devtlb_pasidctl;

typedef struct packed {
    logic [11:0] nxtcap; // RO-V
    logic  [3:0] capver; // RO
    logic [15:0] extcapid; // RO
} t_devtlb_prsextcap;

typedef struct packed {
    logic [13:0] reserved0; // RV
    logic        rst; // RW-V
    logic        en; // RW
} t_devtlb_prsctl;

typedef struct packed {
    logic        prpr; // RO
    logic  [5:0] reserved1; // RV
    logic        stop; // RW1C
    logic  [5:0] reserved0; // RV
    logic        uprgi; // RW1C
    logic        rf; // RW1C
} t_devtlb_prssts;

typedef struct packed {
    logic [31:0] cap; // RO
} t_devtlb_prsreqcap;

typedef struct packed {
    logic [31:0] alloc; // RW
} t_devtlb_prsreqalloc;
