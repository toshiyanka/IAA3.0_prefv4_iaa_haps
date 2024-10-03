
//--AY_HQMV30_ATS--  

   // -------------------------------------------------------------------------
   // -- AY_05312022 Added
   // -------------------------------------------------------------------------
   typedef int        HqmNPID_t;  // Non-Posted ID (primarily to track nonposteds/completions and to uniquely identify them)
   typedef bit [15:0] HqmAtsID_t; // ATS/ATC ID
   typedef bit [15:0] HqmInvID_t; // Invalidation ID
   typedef bit [15:0] HqmPrsID_t; // PRS ID

   typedef enum int {
    IREQ_RANDOM,                // this tells send_invalidation() to randomly select one of the below addresses for invalidation
    IREQ_RANDOM_DESC_BUFFER,    // this tells send_invalidation() to randomly select a CPL, SRC, or DST address to invalidate
    IREQ_RANDOM_DESC_CPL,       // invalidate a CPL logical address
    IREQ_RANDOM_DESC_SRC,       // invalidate a SRC logical address
    IREQ_RANDOM_DESC_DST,       // invalidate a DST logical address
    IREQ_RANDOM_LA,             // randomly select either a 32b or 64b logical address
    IREQ_HIGH,                  // Invalidate High number of pages
    IREQ_SPECIFIC_ADDR,         // Invalidate a specific address provided with the pasid of the sequence invoking it
    IREQ_RANDOM_DESC_DST_SRC    // Invalidate a DST logical address , but if dest size is zero, use src logical address, IREQ_RANDOM_DESC_DST_SRC = enum_value
   } HqmAtsInvType_t;


    typedef enum bit [63:0] {
    RANGE_4K  = 64'h1000,
    RANGE_8K  = 64'h2000,
    RANGE_16K = 64'h4000,
    RANGE_32K = 64'h8000,
    RANGE_64K = 64'h1_0000,
    RANGE_128K= 64'h2_0000,
    RANGE_256K= 64'h4_0000,
    RANGE_512K= 64'h8_0000,
    RANGE_1M  = 64'h10_0000,
    RANGE_2M  = 64'h20_0000,
    RANGE_4M  = 64'h40_0000,
    RANGE_8M  = 64'h80_0000,
    RANGE_16M = 64'h100_0000,
    RANGE_32M = 64'h200_0000,
    RANGE_64M = 64'h400_0000,
    RANGE_128M= 64'h800_0000,
    RANGE_256M= 64'h1000_0000,
    RANGE_512M= 64'h2000_0000,
    RANGE_1G  = 64'h4000_0000,
    RANGE_2G  = 64'h8000_0000,
    RANGE_4G  = 64'h1_0000_0000,
    RANGE_ALL = -1
    } RangeSize_t;


   // ATS Invalidation Target data structure
   typedef struct {
    bit        pasid_valid;
    bit [19:0] pasid;
    bit [63:0] addr;
    RangeSize_t range=RANGE_4K;
    int        num_iter=1;  // number of INV REQs it will take to invalidate at the specified range
    bit [63:0] min_addr;
    bit [63:0] max_addr;
   } HqmAtsInvTgt_t;

   typedef struct packed {
    logic [8:0]       page_req_group_index;
    logic             last_req;
    logic             write;
    logic             read;
   } HqmPrsReqDataFields_t;

   typedef enum logic [3:0] {
    HQM_PRG_RSP_SUCCESS = 4'h0,
    HQM_PRG_RSP_INV_REQ = 4'h1,
    HQM_PRG_RSP_FAILURE = 4'hF
   } HqmPrgRspCode_e;

   typedef struct packed {
    logic [15:0]     dest_devid;
    HqmPrgRspCode_e  rsp_code;
    logic [2:0]      rsvd_11_9;
    logic [8:0]      page_req_group_index;
   } HqmPrgRspDataFields_t;

   typedef struct {
    time                  rsp_time;
    HqmPrgRspDataFields_t data_fields;
    HqmTxnID_t            txn_id;
    HqmPasid_t            pasidtlp;
    logic [3:0]           tc;
   } HqmPrgRsp_t;

   typedef struct {
    HqmPrsID_t            id;

    time                  req_time;
    logic [63:0]          address;
    HqmPrsReqDataFields_t data_fields;
    HqmPasid_t            pasidtlp;
    HqmTxnID_t            txn_id;
    logic [3:0]           tc;
   } HqmPrsReq_t;


// -------------------------------------------------------------------------
// -------------------------------------------------------------------------
typedef bit [63:0] bit64_t;
typedef bit [63:0] vector_t;

typedef class HqmIommu;

typedef class HqmIommuAPI;

parameter bit [63:0] INCR_SIZE_4K = 64'h1000;        // Logical Address Increment Size
parameter bit [63:0] MASK_4K      = -INCR_SIZE_4K;

typedef struct {
    int count;
    bit mustSee;
    string id_info_string[$];
} HqmAtsAddrList_t;

// ATS request types
typedef enum {
    ATS_TREQ,       // Memory Translation Request
    ATS_TCPL,       // Memory Translation Completion
    ATS_PREQ,       // PRS Message Request
    ATS_PRSP,       // PRG Message Response
    ATS_IREQ,       // ATS Invalidation Request
    ATS_IRSP        // ATS Invalidation Response
} HqmAtsCmdType_t;


typedef enum logic [1:0] {
    HQM_ATSCPL_NO_RW   = 2'b00,
    HQM_ATSCPL_WR_ONLY = 2'b10,
    HQM_ATSCPL_RD_ONLY = 2'b01,
    HQM_ATSCPL_RW      = 2'b11
} HqmAtsTCplRW_e;

typedef struct packed {
    bit            size_of_xlat;      // [11] Size of translation
    bit            non_snoop_acc;     // [10] Non-snooped accesses
    bit [3:0]      rsvd_9_6;          // [9:6] Rsvd
    bit            global_mapping;    // [5] Global Mapping
    bit            priv_mode_access;  // [4] Privileged Mode Access
    bit            execute_permitted; // [3] Execute permitted
    bit            unxlat_access;     // [2] Untranslated Access Only
    HqmAtsTCplRW_e read_write;        // [1] Write [0] Read
} HqmAtsTCplDataFields_t;

// Container holding data for the ATS request and associated response
typedef struct {
    HqmAtsID_t    id;    // Unique identifier (to differentiate between different requests
    // Request
    time          req_time = 0;
    bit [63:0]    l_address; // Logical address
    bit [63:0]    l_address_4k;
    bit           nw;
    HqmPasid_t    pasidtlp;
    HqmTxnID_t    txn_id;
    bit [2:0]     chid;
    bit [3:0]     tc;        // Traffic Class
    bit [9:0]     dw_length;
    // Completion
    time          cpl_time = 0;
    bit [63:0]    p_address;   // Physical address
    bit [63:0]    p_address_4k;
    HqmAtsTCplDataFields_t cpl_data_fields;
    // Completion Additional attributes
    HqmCmdType_t       cpl_cmd_type;
    HqmPcieCplStatus_t cpl_sts;
    bit           cpl_ep; // EP bit set
    bit [1:0]     cpl_dparity_err;
    
    // Custom flags
    time         invalid_req_time = 0; // Time at which the entry was marked invalid
    time         invalid_cpl_time = 0; // Time at which the invalidation completion was seen. If this is set, then it should not be added to ATC
    bit          invalid;              // This flag is used to mark outstanding ATS requests that may have seen an invalidation
    bit[4:0]     invalidation_itag;
} HqmAtsReqRsp_t;

// Container holding data for the PRS request and associated response
typedef struct {
    HqmPrsID_t    id;    // Unique identifier (to differentiate between different requests)
    // Request
    time          req_time = 0;
    bit [63:0]    l_address; // Logical address
    bit [63:0]    l_address_4k;
    bit           r;
    bit           w;
    bit           l;
    bit [8:0]     req_prgi;
    HqmPasid_t    pasidtlp;
    HqmTxnID_t    txn_id;
    bit [2:0]     chid;
    bit [3:0]     tc;        // Traffic Class
    // Completion
    time          cpl_time = 0;
    bit [8:0]     rsp_prgi;
    HqmPciePrgRspCode_t rsp_code;
    bit [15:0]    destination_device_id;
    
} HqmPrsReqRsp_t;

typedef struct {
    HqmInvID_t    id;    // Unique identifier (to differentiate between different requests)
    // Invalidation Request
    time          req_time = 0;
    bit [63:0]    address;
    bit           size;
    bit           rsvd_10_1;
    bit           global_invalidate;
    bit [4:0]     itag;
    HqmPasid_t    pasidtlp;
    HqmTxnID_t    txn_id;
    // Invalidation Response
    time          cpl_time = 0;
    bit [31:0]    itag_vector;
    bit [2:0]     cc;              // Completion count
    bit [3:0]     tc;              // Traffic Class
    // Custom flags
    bit [63:0]    aligned_address; // Base address of invalidation
    RangeSize_t   range;           // Range (size) of the invalidation
    bit [2:0]     cc_counter;
    bit           outstanding;     // Whether invalidation is outstanding
    bit           ats_ids[HqmAtsID_t]; // Hash of ATS IDs that could be affected by this invalidation
    bit           ep;           // EP bit set
    bit [1:0]     dparity_err;  // Data parity error
} HqmAtsInvReqRsp_t;

// Structure storing information for an ATC Entry
typedef struct {
    HqmAtsID_t             id;                   // Unique ID
    
    HqmPasid_t             pasidtlp;
    RangeSize_t            range;             // Range of translation
    bit [15:0]             reqid;
    bit [63:0]             l_address;            // Logical Address
    bit [63:0]             p_address;            // Physical address
    time                   ats_req_time = 0;     // ATS request time
    time                   ats_cpl_time = 0;     // ATS completion time
    time                   invalid_req_time = 0; // Time at which the entry was marked invalid 
    time                   atc_disable_time = 0; // Time at which the ATC should be disabled (due to various reasons)
    bit                    invalid;              // Set if this address entry is invalid (due to an invalidation or other reason)
    bit[4:0]               invalidation_itag;
    HqmAtsTCplDataFields_t cpl;
} HqmAtcEntry_t;

// Logical address lookup (used to help access ATC entries via the logical address
typedef struct {
    HqmPasid_t pasidtlp;
    bit [63:0] l_address;
} HqmAtcLAddrLookup_t;

// page sizes available to each kernel
typedef enum longint unsigned {
    PAGE_SIZE_4K   = 64'h1000,
    PAGE_SIZE_8K   = 64'h2000,
    PAGE_SIZE_16K  = 64'h4000,
    PAGE_SIZE_32K  = 64'h8000,
    PAGE_SIZE_64K  = 64'h1_0000,
    PAGE_SIZE_128K = 64'h2_0000,
    PAGE_SIZE_256K = 64'h4_0000,
    PAGE_SIZE_512K = 64'h8_0000,
    PAGE_SIZE_1M   = 64'h10_0000,
    PAGE_SIZE_2M   = 64'h20_0000,
    PAGE_SIZE_4M   = 64'h40_0000,
    PAGE_SIZE_8M   = 64'h80_0000,
    PAGE_SIZE_16M  = 64'h100_0000,
    PAGE_SIZE_32M  = 64'h200_0000,
    PAGE_SIZE_64M  = 64'h400_0000,
    PAGE_SIZE_128M = 64'h800_0000,
    PAGE_SIZE_256M = 64'h1000_0000,
    PAGE_SIZE_512M = 64'h2000_0000,
    PAGE_SIZE_1G   = 64'h4000_0000,
    PAGE_SIZE_2G   = 64'h8000_0000,
    PAGE_SIZE_4G   = 64'h1_0000_0000,
    PAGE_SIZE_8G   = 64'h2_0000_0000,
    PAGE_SIZE_16G  = 64'h4_0000_0000,
    PAGE_SIZE_32G  = 64'h8_0000_0000,
    PAGE_SIZE_64G  = 64'h10_0000_0000,
    PAGE_SIZE_128G = 64'h20_0000_0000,
    PAGE_SIZE_256G = 64'h40_0000_0000,
    PAGE_SIZE_512G = 64'h80_0000_0000,
    PAGE_SIZE_1T   = 64'h100_0000_0000,
    PAGE_SIZE_2T   = 64'h200_0000_0000,
    PAGE_SIZE_4T   = 64'h400_0000_0000,
    PAGE_SIZE_8T   = 64'h800_0000_0000
} PageSize_t;


// -----------------------------------------------------------------------------
// ATS PRS types, parameters, and helper methods
// -----------------------------------------------------------------------------


typedef struct packed {
    bit [8:0]                       prg_index;
    bit [15:0]                      bdf;
    HqmPasid_t                      pasidtlp;
    bit [63:0]                      logical_address;
    logic                           page_is_needed;
    bit                             resolved;
} page_request_t;

typedef page_request_t              page_request_q_t [$];


class PageResponseFields extends ovm_object;

    bit [ 7:0] tag;
    bit [15:0] destination_id;
    HqmPciePrgRspCode_t prg_response_code;
    bit [ 8:0] prg_index;
    HqmPasid_t           pasidtlp;

    function new ( string name = "PageResponseFields" );
        super.new(name);
    endfunction

endclass


typedef enum bit [2:0] {
    ATSCPL_SUCCESS              = 3'h0,
    ATSCPL_UNSUPPORTED_REQUEST  = 3'h1,
    ATSCPL_COMPLETER_ABORT      = 3'h4,
    ATSCPL_CTO                  = 3'h5
} AtsCplSts_t;

typedef enum bit [3:0] {
    PRSRSP_SUCCESS          = 4'h0,
    PRSRSP_INVALID_REQUEST  = 4'h1,
    PRSRSP_INVALID_PRGI     = 4'h2,
    PRSRSP_RESPONSE_FAILURE = 4'hF
} PrsRspSts_t;

typedef struct packed {
    bit [15:0]     reqid;
    HqmPasid_t     pasidtlp;
    bit [63:0]     address;
    bit            write;
} HqmAtsLegalTranslations_t;

typedef struct {
    HqmAtsLegalTranslations_t xlat;
    bit                       must_see;
    string                    id_info;
    string                    buf_name;
} HqmAtsLegalXlatArgs_t;

// -----------------------------------------------------------------------------
// ATS Invalidation types, parameters, and helper methods
// -----------------------------------------------------------------------------

parameter string    HQM_ATS_IRSP_E = "hqm_ats_irsp_e";

class AtsCmplInfo extends ovm_object;

    bit[63:0]  addr;
    bit[255:0] data;
    bit        from_msix;
    HqmBusTxn  txn;
    bit[4:0]   prs_rsp_code;
    bit[63:0]  l_address;
    
    function new(string name = "AtsCmplInfo", bit[63:0] addr = 0, bit[255:0] data = 0, bit from_msix = 0, HqmBusTxn txn = null);
        super.new(name);
        this.addr = addr;
        this.data = data;
        this.from_msix = from_msix;
        this.txn = txn;
        l_address   = {txn.address[31:0], txn.address[63:32]};
        this.prs_rsp_code = l_address[15:12];
    endfunction : new

    `ovm_object_utils_begin(AtsCmplInfo)
        `ovm_field_int(addr, OVM_DEFAULT)
        `ovm_field_int(data, OVM_DEFAULT)
        `ovm_field_int(from_msix, OVM_DEFAULT)
    `ovm_object_utils_end

endclass

class AtsReqInfo extends ovm_object;

    HqmAtsReqRsp_t treq;
    bit[1:0]       rw;
    
    function new(string name = "AtsReqInfo");
        super.new(name);
    endfunction : new

    // ---------------------------------------------------------------------------
    function void set_atsreq(HqmAtsReqRsp_t treq ,bit[1:0] rw=2'b11);
        this.treq = treq;
        this.rw = rw;
    endfunction
    
    function bit[19:0] getpasid();
        return treq.pasidtlp.pasid;    
    endfunction
    
    `ovm_object_utils(AtsReqInfo);

endclass
