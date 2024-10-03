// -----------------------------------------------------------------------------
// Copyright(C) 2016 - 2019 Intel Corporation, Confidential Information
// -----------------------------------------------------------------------------
// Description: Common Enums used by HqmBusTxn - to support IOSF and iCXL
// -----------------------------------------------------------------------------

// -------------------------------------------------------------------------
// -- AY_05312022 Added
// -------------------------------------------------------------------------
   typedef struct packed {
    bit        pasid_en;
    bit        priv_mode_requested;
    bit        exe_requested;
    bit [19:0] pasid;
   } HqmPasid_t;

   typedef struct packed {
    logic [9:0]  tag;
    logic [15:0] req_id;
   } HqmTxnID_t; // Combination of Tag+ReqId




// -------------------------------------------------------------------------
// -------------------------------------------------------------------------
// Enums to define both primary and sideband bus protocols supported by HQM. 
typedef enum bit [3:0] {
    HQM_PRIM_BUS_IOSF,
    HQM_PRIM_BUS_ICXL,
    
    HQM_SIDE_BUS_IOSF
} HqmBusProtocol_t;

typedef struct packed {
    logic [7:0] bus;
    logic [4:0] dev;
    logic [2:0] func;
} HqmBDF_t; // Bus+Device+Function

typedef enum bit {
    HQM_IP_RX, // IP is receiving the transaction
    HQM_IP_TX  // IP is transmitting the transaction
} HqmTxnDir_t;

typedef enum bit [3:0] {
    HQM_REQ_PHASE,          // Request Phase (where request type may be known, but not the full command). Used for ordering
    HQM_CMD_PHASE,          // When all the command fields are available
    HQM_TXN_COMPLETE_PHASE, // When the transaction has completed
    HQM_TXN_UNSUPP_PHASE    // Unsupported Phase
} HqmTxnPhase_t;

typedef enum bit [1:0] {
    HQM_POSTED      = 2'b00,
    HQM_NONPOSTED   = 2'b01,
    HQM_COMPLETION  = 2'b10,
    HQM_REQTYPE_RSV = 2'b11
} HqmPcieReqType_t;

typedef enum bit [1:0] {
    HQM_GNT_TXN             = 2'b00,
    HQM_GNT_SHOW            = 2'b01,
    HQM_GNT_REQ_CREDIT_INIT = 2'b10,
    HQM_GNT_RSVD            = 2'b11
} HqmGntType_t;

typedef enum bit [2:0] {
    HQM_SC      = 3'b000,        // Successful Completion
    HQM_UR      = 3'b001,        // Unsupported Request
    HQM_CRS     = 3'b010,        // Configuration Request Retry Status
    HQM_CA      = 3'b100,        // Completer Abort
    HQM_RSV3    = 3'b011,
    HQM_RSV5    = 3'b101,
    HQM_RSV6    = 3'b110,
    HQM_RSV7    = 3'b111
} HqmPcieCplStatus_t;

// AT encoding
typedef enum bit [1:0] {
    HQM_AT_UNTRANSLATED    = 2'b00,
    HQM_AT_TRANSLATION_REQ = 2'b01,
    HQM_AT_TRANSLATED      = 2'b10, // Non-Msi
    HQM_AT_TRANSLATED_MSI  = 2'b11
} HqmATEnc_t;

// Page Response Code Field
typedef enum logic [3:0] {
    HQM_PRG_RC_SUCCESS          = 4'b0000, 
    HQM_PRG_RC_INVALID_REQUEST  = 4'b0001, 
    HQM_PRG_RC_RESPONSE_FAILURE = 4'b1111
} HqmPciePrgRspCode_t;

typedef enum bit [6:0] {
    HQM_MRd32    = 7'b00_00000,  // 32 bit memory read request
    HQM_MRd64    = 7'b01_00000,  // 64 bit memory read request
    HQM_LTMRd32  = 7'b00_00111,  // 32 bit LT memory read
    HQM_LTMRd64  = 7'b01_00111,  // 64 bit LT memory read
    HQM_MRdLk32  = 7'b00_00001,  // 32 bit locked memory read
    HQM_MRdLk64  = 7'b01_00001,  // 64 bit locked memory read
    HQM_MWr32    = 7'b10_00000,  // 32 bit memory write
    HQM_MWr64    = 7'b11_00000,  // 64 bit memory write
    HQM_LTMWr32  = 7'b10_00111,  // 32 bit LT memory write
    HQM_LTMWr64  = 7'b11_00111,  // 64 bit LT memory write
    HQM_NPMWr32  = 7'b10_11011,  // 32 bit non-posted memory write
    HQM_NPMWr64  = 7'b11_11011,  // 64 bit non-posted memory write
    HQM_IORd     = 7'b00_00010,  // IO read
    HQM_IOWr     = 7'b10_00010,  // IO write
    HQM_CfgRd0   = 7'b00_00100,  // Config0 read
    HQM_CfgWr0   = 7'b10_00100,  // Config0 write
    HQM_CfgRd1   = 7'b00_00101,  // Config1 read
    HQM_CfgWr1   = 7'b10_00101,  // Config1 write
    HQM_FAdd32   = 7'b10_01100,  // 32 bit fetch and add atomic request
    HQM_FAdd64   = 7'b11_01100,  // 64 bit fetch and add atomic request
    HQM_Swap32   = 7'b10_01101,  // 32 bit enconditional swap atomic request
    HQM_Swap64   = 7'b11_01101,  // 64 bit enconditional swap atomic request
    HQM_CAS32    = 7'b10_01110,  // 32 bit compare and swap atomic request
    HQM_CAS64    = 7'b11_01110,  // 64 bit compare and swap atomic request
    HQM_Msg0     = 7'b01_10000,  // Message [2:0] is the routing field
    HQM_Msg1     = 7'b01_10001,  // Message [2:0] is the routing field
    HQM_Msg2     = 7'b01_10010,  // Message [2:0] is the routing field
    HQM_Msg3     = 7'b01_10011,  // Message [2:0] is the routing field
    HQM_Msg4     = 7'b01_10100,  // Message [2:0] is the routing field
    HQM_Msg5     = 7'b01_10101,  // Message [2:0] is the routing field
    HQM_Msg6     = 7'b01_10110,  // Message [2:0] is the routing field
    HQM_Msg7     = 7'b01_10111,  // Message [2:0] is the routing field
    HQM_MsgD0    = 7'b11_10000,  // Message with data
    HQM_MsgD1    = 7'b11_10001,  // Message [2:0] is the routing field
    HQM_MsgD2    = 7'b11_10010,  // Message [2:0] is the routing field
    HQM_MsgD3    = 7'b11_10011,  // Message [2:0] is the routing field
    HQM_MsgD4    = 7'b11_10100,  // Message [2:0] is the routing field
    HQM_MsgD5    = 7'b11_10101,  // Message [2:0] is the routing field
    HQM_MsgD6    = 7'b11_10110,  // Message [2:0] is the routing field
    HQM_MsgD7    = 7'b11_10111,  // Message [2:0] is the routing field
    HQM_Cpl      = 7'b00_01010,  // Completion without data for IO,cfg
    HQM_CplD     = 7'b10_01010,  // Completion with data
    HQM_CplLk    = 7'b00_01011,  // Completion memory lock no data
    HQM_CplDLk   = 7'b10_01011   // Completion memory lock with data
} HqmCmdType_t; 

typedef struct packed {
    bit [1:0] fmt;    // Format
    bit [4:0] ttype;  // Transaction Type
} HqmFmtType_t;

typedef struct {
    time             start_time;   // Start time of the transaction
    HqmPcieReqType_t req_type;     // PCIE request type
    HqmFmtType_t     cmd;          // fmt[1:0] + type[1:0]
    HqmTxnID_t       txn_id;       // tag + reqid
    HqmPasid_t       pasidtlp;     // [22]=PasidEn, [21]=Priv Mode, [20]=Exe Mode, [19:0]=PASID
    logic [3:0]      chid;         // Channel ID, note: it is variable width so just creating a 'max' number
    logic [3:0]      tc;           // Traffic Class
    logic [9:0]      length;       // Length of the access
    logic [1:0]      at;           // Address Translation encoding
    logic            ro;           // Relaxed Ordering
    logic            ns;           // No Snoop
    logic            ep;           // Error Present
    logic            th;           // Transaction hint
    logic            ido;          // ID based ordering
    logic            rsvd_1_7;     // Tag[9] for 10-bit tag
    logic            rsvd_1_3;     // Tag[8] for 10-bit Tag
    logic            rsvd_1_1;
    logic            rsvd_0_7;
    logic [7:0]      sai;          // SAI
    logic [3:0]      fbe;          // First Byte Enable
    logic [3:0]      lbe;          // Last Byte enable
    logic [511:0]    data[$];      // Data Bus   
    logic [1:0]      dparity[$];   // Data Parity
    logic            parity_err[$];// Indicates where there is a parity error (dependent on 'phase' could be command or data)
} HqmIosfBus_t; 

typedef struct {
    HqmCmdType_t cmd;        // fmt[1:0] + mtype[1:0]
    time         start_time; // Start time of the transaction
    HqmPasid_t   pasidtlp;   // [22]=PasidEn, [21]=Priv Mode, [20]=Exe Mode, [19:0]=PASID
    logic [3:0]  chid;       // Channel ID, note: it is variable width so just creating a 'max' number
    logic [3:0]  tc;         // Traffic Class
    logic [9:0]  length;     // Length of the access
    logic [1:0]  at;         // Address Translation encoding
    logic        ro;         // Relaxed Ordering
    logic        ep;         // Error Present
    logic        ido;        // ID based ordering
    logic [3:0]  fbe;        // First Byte Enable
    logic [3:0]  lbe;        // Last Byte enable
} HqmICxlBus_t; 
