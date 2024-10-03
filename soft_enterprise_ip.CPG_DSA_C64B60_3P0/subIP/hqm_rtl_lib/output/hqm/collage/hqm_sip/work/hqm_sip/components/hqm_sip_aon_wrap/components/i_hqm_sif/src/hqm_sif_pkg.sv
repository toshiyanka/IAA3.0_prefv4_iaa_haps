//-----------------------------------------------------------------------------------------------------
//
// INTEL CONFIDENTIAL
//
// Copyright 2020 Intel Corporation All Rights Reserved.
//
// The source code contained or described herein and all documents related to the source code
// ("Material") are owned by Intel Corporation or its suppliers or licensors. Title to the Material
// remains with Intel Corporation or its suppliers and licensors. The Material contains trade
// secrets and proprietary and confidential information of Intel or its suppliers and licensors.
// The Material is protected by worldwide copyright and trade secret laws and treaty provisions.
// No part of the Material may be used, copied, reproduced, modified, published, uploaded, posted,
// transmitted, distributed, or disclosed in any way without Intel's prior express written permission.
//
// No license under any patent, copyright, trade secret or other intellectual property right is
// granted to or conferred upon you by disclosure or delivery of the Materials, either expressly, by
// implication, inducement, estoppel or otherwise. Any license under such intellectual property rights
// must be express and approved by Intel in writing.
//
//-----------------------------------------------------------------------------------------------------

`include "hqm_system_def.vh"

package hqm_sif_pkg;

    import hqm_AW_pkg::*, hqm_pkg::*;

    // IOSF Primary Parameters

    localparam MMAX_ADDR                        = 63;
    localparam TMAX_ADDR                        = 63;
    localparam MD_WIDTH                         = 255;
    localparam TD_WIDTH                         = 255;
    localparam MDP_WIDTH                        = (MD_WIDTH >= 511) ? 1 : 0;
    localparam TDP_WIDTH                        = (TD_WIDTH >= 511) ? 1 : 0;
    localparam AGENT_WIDTH                      = 0;
    localparam SRC_ID_WIDTH                     = 13;
    localparam DST_ID_WIDTH                     = 13;
    localparam MAX_DATA_LEN                     = 9;
    localparam SAI_WIDTH                        = 7;
    localparam RS_WIDTH                         = 0;
    localparam PARITY_REQUIRED                  = 1;
    localparam INACTIVE_ZERO_MODE_EN            = 1;
    localparam HQM_PASID_WIDTH                  = 20;
    localparam HQM_PASIDTLP_WIDTH               = HQM_PASID_WIDTH+3;    // FMT[2] + PM_REQ + EXE_REQ + PASID

    localparam MSTR_PCQ_SZ                      = 4;
    localparam MSTR_PDQ_SZ                      = 4;
    localparam MSTR_NPCQ_SZ                     = 4;
    localparam MSTR_NPDQ_SZ                     = 4;
    localparam MSTR_CPCQ_SZ                     = 4;
    localparam MSTR_CPDQ_SZ                     = 4;

    localparam RCDT_P                           = 4;
    localparam RCDT_NP                          = 4;
    localparam RCDT_CP                          = 4;

    localparam PARQDEPTH                        = 4;
    localparam NPARQDEPTH                       = 4;
    localparam CPARQDEPTH                       = 4;

    localparam MAX_CCDT                         = 5;
    localparam MAX_DCDT                         = 7;

    localparam TGT_PCQ_SZ                       = 4;
    localparam TGT_PDQ_SZ                       = 4;
    localparam TGT_NPCQ_SZ                      = 4;
    localparam TGT_NPDQ_SZ                      = 4;
    localparam TGT_CPCQ_SZ                      = 4;
    localparam TGT_CPDQ_SZ                      = 4;

    // IOSF Sideband Parameters

    localparam SBE_ASYNCIQDEPTH                 = 2;
    localparam SBE_ASYNCEQDEPTH                 = 2;
    localparam SBE_PIPEISMS                     = 0;
    localparam SBE_PIPEINPS                     = 0;
    localparam SBE_CLKREQ_HYST_CNT              = 15;
    localparam SBE_DO_SERR_MASTER               = 1;

    localparam HQMIOSF_TCRD_BYPASS              = 1;
    localparam HQMIOSF_TGT_TX_PRH               = 4; 
    localparam HQMIOSF_TGT_TX_NPRH              = 4; 
    localparam HQMIOSF_TGT_TX_CPLH              = 4; 
    localparam HQMIOSF_TGT_TX_PRD               = 16; 
    localparam HQMIOSF_TGT_TX_NPRD              = 4; 
    localparam HQMIOSF_TGT_TX_CPLD              = 16; 

    // iosf_mstr
    localparam HQMIOSF_MSTR_MAX_PAYLOAD         = 512;

    // iosf common
    localparam HQMIOSF_MMAX_ADDR                = MMAX_ADDR;
    localparam HQMIOSF_TMAX_ADDR                = TMAX_ADDR;
    localparam HQMIOSF_MD_WIDTH                 = MD_WIDTH; 
    localparam HQMIOSF_TD_WIDTH                 = TD_WIDTH; 
    localparam HQMIOSF_MDP_WIDTH                = MDP_WIDTH;
    localparam HQMIOSF_TDP_WIDTH                = TDP_WIDTH;
    localparam HQMIOSF_AGENT_WIDTH              = AGENT_WIDTH;    
    localparam HQMIOSF_DST_ID_WIDTH             = DST_ID_WIDTH; 
    localparam HQMIOSF_SRC_ID_WIDTH             = SRC_ID_WIDTH;
    localparam HQMIOSF_MAX_DATA_LEN             = MAX_DATA_LEN;
    localparam HQMIOSF_SAI_WIDTH                = SAI_WIDTH;
    localparam HQMIOSF_RS_WIDTH                 = RS_WIDTH;
    localparam HQMIOSF_PASIDTLP_WIDTH           = HQM_PASIDTLP_WIDTH;

    localparam HQMIOSF_PORTS                    = 1; 
    localparam HQMIOSF_VC                       = 1; 
    localparam HQMIOSF_RD_PO                    = 19;
    localparam HQMIOSF_RD_NP                    = 19;
    localparam HQMIOSF_RD_CP                    = 2; 
    localparam HQMIOSF_MNUMCHAN                 = 0;
    localparam HQMIOSF_MNUMCHANL2               = 0;
    localparam HQMIOSF_TNUMCHANL2               = 0;

    localparam HQMIOSF_NUMCHANL2                = (HQMIOSF_MNUMCHANL2 > HQMIOSF_TNUMCHANL2) ? 
                                                   HQMIOSF_MNUMCHANL2 : HQMIOSF_TNUMCHANL2; 


    // This is IOSF SB SAI Params
    localparam HQMIOSF_RX_EXT_HEADER_SUPPORT    = 1; 
    localparam HQMIOSF_TX_EXT_HEADER_SUPPORT    = 1; 
    localparam HQMIOSF_NUM_TX_EXT_HEADERS       = 0; 
    localparam HQMIOSF_NUM_RX_EXT_HEADERS       = 0; 

    // Exphdr1 id is always 7 bits though, if can chain (these become lists), though not on BEK
    // A little confusing this is the lower 8 bits of the SAI DW. Bit 7 indicates yet another EH.

    localparam HQMIOSF_RX_EXT_HEADER_IDS        = 8'h0; 
    localparam HQMIOSF_TX_EXT_HEADER_IDS        = 8'h0; 

    localparam HQM_POSTED                       = 0;
    localparam HQM_NONPOSTED                    = 1;
    localparam HQM_COMPLETION                   = 2;

    // Global Parameters - That are currently local to the Host Interface

    localparam HQMTI_DATA_WID                   = HQMIOSF_MD_WIDTH + 1;
    localparam HQMTI_CDATA_WID                  = HQMIOSF_TD_WIDTH + 1;

    localparam HQMTI_DATA_MSB                   = HQMTI_DATA_WID  - 1; // Master Data Width
    localparam HQMTI_CDATA_MSB                  = HQMTI_CDATA_WID - 1; // Target Completion Data Width

    // Some uniquified MPS based params

    localparam HQMTI_MAXMPS_BYTES               = HQMIOSF_MSTR_MAX_PAYLOAD;
    localparam HQMTI_MAXMPS_BCNT_MSB            = $clog2(HQMTI_MAXMPS_BYTES); // One bigger to handle MAX Values + 1

    // IOSF Credit Parameters

    // These IOSF target credits are what are advertised to the IOSF fabric on credit init.
    // They protect us from overflowing the RI TLQ FIFO storage as the fabric cannot send us
    // a transaction unless it has a header credit and enough data credits remaining to do so.
    // The fabric decrements its local credit count when it sends us a transaction and we
    // return credits to the fabric when we pop the header or data from the RI TLQ FIFOs.
    // A header credit is one credit per header and a data credit is for 4DW (16B) of data.
    //
    // We must support a maximum MPS of 512B, so the RI TLQ FIFOs must, at a minimum, be sized
    // to support 512B of data (32 data credits).  Otherwise we can deadlock, never having
    // enough data credits to allow a legal (from the fabric's point of view since it meets
    // MPS requirements, but not necessarily from the HQM's point of view as the max legal
    // transaction we support is one cache line or 64B) transaction to be sent to us from
    // the fabric.  In other words we need enough data storage to be able to consume a max
    // MPS transaction even if we're just going to throw it away as unsupported.
    //
    // Optimally, the RI TLQ FIFOs should be sized to cover the latency from when the fabric
    // gives us a transaction to our returning the credits for that transaction including any
    // pipelining between the fabric and the agent in both directions, otherwise there can be
    // wasted bus bandwidth where the bus will be idle due to lack of credits.  This is not
    // as important if our required rate of processing only requires one transaction every
    // N bus cycles and N is greater than 1.
    //
    // For Posted transactions, the RI TLQ Posted Data (PD) FIFO is 32B wide, or 2 data credits
    // per entry, and we would need a PD FIFO that is at least 16 deep to support the max MPS
    // of 512B (16 * 2 data credits/entry = 32 data credits or 512B).
    // If we also want enough PD FIFO storage to allow us to store a maximum sized legal HCW
    // transaction (4 HCWs or 64B) per Posted Header (PH) FIFO entry, then the PD FIFO needs
    // to be twice as deep as the PH FIFO.
    // A complication is that we support 3 HCW (48B) transactions which, although they only
    // require 3 data credits each, will each consume 2 PD FIFO entries or 4 data credits
    // worth of the PD FIFO entries even though the 2nd entry of each is only half populated.
    // This means we can only advertise a maximum of 3/4 of the data credits available in
    // the PD FIFO instead of the full amount.
    //
    // So, for a PH FIFO depth of 16, we advertise 16 header credits and size the PD FIFO to
    // 32 deep which supports the MPS (because it's >16) and allows us to store all the data
    // for legal maximal sized HCW transactions (64B or 4 data credits) for each of the 16
    // header entries (16 headers * 2 data entries/header = 32 data entries). But we can only
    // advertise a maximum of 48 data credits (64 data credits * 3/4 = 48 data credits) to
    // support the degenerate 3 HCW case even though the structure contains 64 data credits
    // (32 entries * 2 data credits/entry = 64) worth of storage.
    //
    // For Non-Posted transactions, the RI TLQ Non-Posted Data (NPD) FIFO is 4B wide because
    // the only Non-Posted transactions the HQM supports are CFGWR, which are limited to at
    // most 1 DW of data.  Since only 1 header credit and 1 data credit are required per
    // transaction, the Non-Posted Header (NPH) FIFO and NPD FIFO depths can be the same.
    // Note that due to not supporting Non-Posted MWr transactions, MPS does not apply.
    //
    // So, for a NPH FIFO depth of 8, the NPD FIFO depth can also be 8 deep, and we can
    // advertise the full 8 credits for each.
    //
    // Since we do not master any Non-Posted transactions ourselves, we do not expect any
    // Completions and any Completion we receive is an Unexpected Completion and will be
    // thrown away before needing to be stored in the RI TLQ.  So we just advertise
    // infinite Completion credits by setting the Completion credit counts to 0.

    localparam P_HDR_CREDITS                    = 8'h10                                 ;                                                  
    localparam P_DATA_CREDITS                   = 8'h30                                 ;
    localparam NP_HDR_CREDITS                   = 8'h08                                 ;                                                  
    localparam NP_DATA_CREDITS                  = 8'h08                                 ;                                                  
    localparam CPL_HDR_CREDITS                  = 8'h00                                 ;                                                  
    localparam CPL_DATA_CREDITS                 = 8'h00                                 ;                                                  


    // IOSF SB Opcodes

    localparam HQMEPSB_MRD                      = 8'h00                                 ; // Read Memory Mapped Register
    localparam HQMEPSB_MWR                      = 8'h01                                 ; // Write Memory Mapped Register
    localparam HQMEPSB_CFGRD                    = 8'h04                                 ; // Read PCI Config Register
    localparam HQMEPSB_CFGWR                    = 8'h05                                 ; // Write PCI Config Register
    localparam HQMEPSB_CRRD                     = 8'h06                                 ; // Read Private Control Register
    localparam HQMEPSB_CRWR                     = 8'h07                                 ; // Write Private Control Register

    localparam HQMEPSB_CPL                      = 8'h20                                 ; // Completion without Data
    localparam HQMEPSB_CPLD                     = 8'h21                                 ; // Completion with Data

    localparam HQMEPSB_ERR                      = 8'h49                                 ; // PCIe Error Message

    // Replacements
    localparam HQMEPSB_RSPREP                   = 8'h2A                                 ; // About to Reset, warning from the PMU
    localparam HQMEPSB_RSPREPACK                = 8'h2B                                 ; // Acknowledgement of the the RSPREP MSG

    localparam HQMEPSB_FORCEPWRGATEPOK          = 8'h2E                                 ; // Allows an external requester to force an IP to deassert 
                                                                                            // its POK or assert its pg_req signal.
    localparam HQMEPSB_FORCEPWRGATE_11          = 2'b11                                 ; // Type for force_ip_inaccessible
    localparam HQMEPSB_FORCEPWRGATE_01          = 2'b01                                 ; // Type for force_warm_reset

    localparam HQMEPSB_INTA_ASSERT              = 8'h80                                 ; // Legacy Interrupt A Assert 
    localparam HQMEPSB_INTA_DEASSERT            = 8'h84                                 ; // Legacy Interrupt A Deassert

    localparam HQMEPSB_OP_REGA_START            = 8'h00                                 ; // First Register Access Opcode inclusive
    localparam HQMEPSB_OP_REGA_END              = 8'h20                                 ; // Last  Register Access Opcode not inclusive
    localparam HQMEPSB_OP_COMU_START            = 8'h28                                 ; // First Common Usage Opcode inclusive
    localparam HQMEPSB_OP_COMU_END              = 8'h40                                 ; // Last  Common Usage Opcode not inclusive
    localparam HQMEPSB_OP_MSGD_START            = 8'h40                                 ; // First Message with Data Opcode inclusive
    localparam HQMEPSB_OP_MSGD_END              = 8'h80                                 ; // Last  Message with Data Opcode not inclusive
    localparam HQMEPSB_OP_SMSG_START            = 8'h80                                 ; // First Simple Message Opcode inclusive
    localparam HQMEPSB_OP_SMSG_END              = 8'hFF                                 ; // Last  Simple Message Opcode not inclusive

    localparam HQMEPSB_MAX_TGT_ADR              = 47                                    ; // Maximum address/data bits supported by the
    localparam HQMEPSB_MAX_TGT_DAT              = 63                                    ; // master register access interface
    localparam HQMEPSB_MAX_TGT_BE               =(HQMEPSB_MAX_TGT_DAT == 31 ? 3 : 7)    ; // Mximum iwdth of the BE needed. 7:0 or 3:0.

    // Define the number of cycles to wait after all completions have been received

    localparam HQM_WAIT_BEFORE_CLK_GATE         = 8;

    // Defines the width of the data bus for the TLP

    localparam LLC_PACKET_DWIDTH                = (HQMIOSF_TD_WIDTH + 1)                                    ;                    

    localparam RI_PDATA_WID                     = 256;
    localparam RI_NPDATA_WID                    = 32;

    // These exist to make collage happy...

//  VPP_WIDTH should match HQM_SYSTEM_VPP_WIDTH in system/hqm_system_pkg.sv
    localparam VPP_WIDTH			= 6;						// based upon the larger of the 2 NUM_DIR_PP or NUM_LDB_PP in hqm_pkg.sv. 6 for NUM_DIR_PP 64

    localparam BITS_HCW_ENQ_IN_DATA_T           = 16 + 5 + 4 + 2 + VPP_WIDTH + 128; // ecc + control bits + cl + cli + vpp width + hcw width

    typedef enum logic [1:0] {
         PW     = 'h0
        ,SCH    = 'h1
        ,MSIX   = 'h2
        ,AI     = 'h3
    } hqm_wbuf_src_t;

    typedef struct packed {
        logic                                   fmt2;           // fmt[2]
        logic                                   pm_req;         // Privileged mode requested
        logic                                   exe_req;        // Execute requested
        logic [HQM_PASID_WIDTH-1:0]             pasid;          // Process Address Space ID
    } hqm_pasidtlp_t;

    typedef struct packed {
        logic                                   par;            // parity on other fields
        logic [1:0]                             add_par;        // parity on add field
        logic                                   invalid;        // Indicates the transaction should not be put on the link
        logic [2:0]                             num_hcws;       // Number of hcws for CQ writes
        hqm_wbuf_src_t                          src;            // Posted write type
        logic                                   cq_v;           // CQ associated write
        logic                                   cq_ldb;         // CQ associated with the write is load balanced
        logic [5:0]                             cq;
        logic                                   ro;             // TLP relaxed ordering bit
        hqm_pasidtlp_t                          pasidtlp;       // PASID fields
        logic                                   len_par;        // parity on length field
        logic [4:0]                             length;         // Length, in DWs
        logic [`HQM_TI_ADDR:2]                  add;            // Address
        logic [1:0]                             tc_sel;         // Traffic Class select
    } hqm_ph_t;

    typedef struct packed {
        logic [7:0]                             dpar;
        logic [255:0]                           data;
    } hqm_pd_t;

    typedef struct packed {
        hqm_ph_t                                 hdr;
        hqm_pd_t                                 data_ms;
        hqm_pd_t                                 data_ls;
    } write_buffer_mstr_t;

    localparam BITS_WRITE_BUFFER_MSTR_T         = $bits(write_buffer_mstr_t);

    // Scoreboard and master LL parameters

    localparam HQM_MSTR_FL_DEPTH                = 256;
    localparam HQM_MSTR_FL_DEPTH_WIDTH          = $clog2(HQM_MSTR_FL_DEPTH);
    localparam HQM_MSTR_FL_CNT_WIDTH            = $clog2(HQM_MSTR_FL_DEPTH+1);

    localparam HQM_MSTR_DATA_WIDTH              = 128 + 1;                  // data, parity
    localparam HQM_MSTR_HDR_WIDTH               = 128 + 1 + 1 + 23;         // hdr, hdr_p, tlb, pasidtlp
    localparam HQM_MSTR_HPA_WIDTH               = 46 - 12 + 1;              // hpa, hpa_p

    localparam HQM_MSTR_NUM_CQS                 = NUM_DIR_CQ + NUM_LDB_CQ;
    localparam HQM_MSTR_NUM_CQS_WIDTH           = $clog2(HQM_MSTR_NUM_CQS);

    localparam HQM_MSTR_NUM_LLS                 = HQM_MSTR_NUM_CQS + 4;     // 1 per CQ + P + NP + Cpl + Int
    localparam HQM_MSTR_NUM_LLS_WIDTH           = $clog2(HQM_MSTR_NUM_LLS);

    localparam HQM_MSTR_NUM_HPAS                = HQM_MSTR_NUM_CQS + 2;     // 1 per CQ + P + NP
    localparam HQM_MSTR_NUM_HPAS_WIDTH          = $clog2(HQM_MSTR_NUM_HPAS);

    localparam HQM_SCRBD_DEPTH                  = 256;
    localparam HQM_SCRBD_DEPTH_WIDTH            = $clog2(HQM_SCRBD_DEPTH);
    localparam HQM_SCRBD_CNT_WIDTH              = $clog2(HQM_SCRBD_DEPTH+1);

    localparam HQM_IBCPL_DATA_WIDTH             = 64;                       // At most 2 DWs for ATS responses
    localparam HQM_IBCPL_PARITY_WIDTH           = HQM_IBCPL_DATA_WIDTH>>5;  // One parity bit per DW
    localparam HQM_IBCPL_DATA_FIFO_WIDTH        = HQM_IBCPL_DATA_WIDTH+HQM_IBCPL_PARITY_WIDTH;

    localparam HQM_IOSF_REQ_CREDIT_WIDTH        = 5;

    typedef struct packed {
        logic                                   parity;         // 19    parity bit
        logic                                   bad_len;        // 18    bad length indication
        logic                                   timeout;        // 17    timeout indication
        logic                                   poison;         // 16    poisoned indication
        logic [2:0]                             status;         // 15:13 completion status
        logic [4:0]                             length;         // 12: 8 completion length (max 16 DW)
        logic [7:0]                             tag;            //  7: 0 Tag (only 8b tag)
    } scrbd_cplhdr_t;

    typedef struct packed {
        logic                                   parity;
        logic [1:0]                             src;
        logic [HQM_MSTR_NUM_CQS_WIDTH-1:0]      id;
    } scrbd_data_t;

    typedef struct packed {
        logic                                   re;
        logic [HQM_SCRBD_DEPTH_WIDTH-1:0]       raddr;
        logic                                   we;
        logic [HQM_SCRBD_DEPTH_WIDTH-1:0]       waddr;
        scrbd_data_t                            wdata;
    } hqm_sif_memi_scrbd_mem_t;

    typedef struct packed {
        scrbd_data_t                            rdata;
    } hqm_sif_memo_scrbd_mem_t;

    typedef struct packed {
        logic                                   re;
        logic [HQM_SCRBD_DEPTH_WIDTH-1:0]       raddr;
        logic                                   we;
        logic [HQM_SCRBD_DEPTH_WIDTH-1:0]       waddr;
        scrbd_cplhdr_t                          wdata;
    } hqm_sif_memi_ibcpl_hdr_t;

    typedef struct packed {
        scrbd_cplhdr_t                          rdata;
    } hqm_sif_memo_ibcpl_hdr_t;

    typedef struct packed {
        logic                                   re;
        logic [HQM_SCRBD_DEPTH_WIDTH-1:0]       raddr;
        logic                                   we;
        logic [HQM_SCRBD_DEPTH_WIDTH-1:0]       waddr;
        logic [HQM_IBCPL_DATA_FIFO_WIDTH-1:0]   wdata;
    } hqm_sif_memi_ibcpl_data_t;

    typedef struct packed {
        logic [HQM_IBCPL_DATA_FIFO_WIDTH-1:0]   rdata;
    } hqm_sif_memo_ibcpl_data_t;


    typedef struct packed {
        logic                                   re;
        logic   [HQM_MSTR_NUM_CQS_WIDTH-1:0]    raddr;
        logic                                   we;
        logic   [HQM_MSTR_NUM_CQS_WIDTH-1:0]    waddr;
        logic   [HQM_MSTR_HPA_WIDTH-1:0]        wdata;
    } hqm_sif_memi_mstr_ll_hpa_t;

    typedef struct packed {
        logic   [HQM_MSTR_HPA_WIDTH-1:0]        rdata;
    } hqm_sif_memo_mstr_ll_hpa_t;

    typedef struct packed {
        logic                                   re;
        logic   [HQM_MSTR_FL_DEPTH_WIDTH-1:0]   raddr;
        logic                                   we;
        logic   [HQM_MSTR_FL_DEPTH_WIDTH-1:0]   waddr;
        logic   [HQM_MSTR_HDR_WIDTH-1:0]        wdata;
    } hqm_sif_memi_mstr_ll_hdr_t;

    typedef struct packed {
        logic   [HQM_MSTR_HDR_WIDTH-1:0]        rdata;
    } hqm_sif_memo_mstr_ll_hdr_t;

    typedef struct packed {
        logic                                   re;
        logic   [HQM_MSTR_FL_DEPTH_WIDTH-1:0]   raddr;
        logic                                   we;
        logic   [HQM_MSTR_FL_DEPTH_WIDTH-1:0]   waddr;
        logic   [HQM_MSTR_DATA_WIDTH-1:0]       wdata;
    } hqm_sif_memi_mstr_ll_data_t;

    typedef struct packed {
        logic   [HQM_MSTR_DATA_WIDTH-1:0]       rdata;
    } hqm_sif_memo_mstr_ll_data_t;

    // devtlb related - these should match the settings in the hqm_devtlb_params.vh file

    localparam HQM_TLB_MAX_LINEAR_AWIDTH        = 57;
    localparam HQM_TLB_MAX_HOST_AWIDTH          = 46;

    localparam HQM_TLB_NUM_WAYS                 = 8;
    localparam HQM_TLB_NUM_4K                   = 128;      // One per CQ
    localparam HQM_TLB_NUM_2M                   = 32;       // One per VAS
    localparam HQM_TLB_NUM_1G                   = 32;       // One per VAS

    localparam HQM_TLB_4K_DEPTH                 = HQM_TLB_NUM_4K/HQM_TLB_NUM_WAYS;
    localparam HQM_TLB_2M_DEPTH                 = HQM_TLB_NUM_2M/HQM_TLB_NUM_WAYS;
    localparam HQM_TLB_1G_DEPTH                 = HQM_TLB_NUM_1G/HQM_TLB_NUM_WAYS;

    localparam HQM_TLB_4K_ADDR_WIDTH            = $clog2(HQM_TLB_4K_DEPTH);
    localparam HQM_TLB_2M_ADDR_WIDTH            = $clog2(HQM_TLB_2M_DEPTH);
    localparam HQM_TLB_1G_ADDR_WIDTH            = $clog2(HQM_TLB_1G_DEPTH);

    localparam HQM_TLB_4K_DATA_WIDTH            = HQM_TLB_MAX_HOST_AWIDTH-7;
    localparam HQM_TLB_2M_DATA_WIDTH            = HQM_TLB_MAX_HOST_AWIDTH-16;
    localparam HQM_TLB_1G_DATA_WIDTH            = HQM_TLB_MAX_HOST_AWIDTH-25;

    localparam HQM_TLB_4K_TAG_WIDTH             = HQM_TLB_MAX_LINEAR_AWIDTH+28;
    localparam HQM_TLB_2M_TAG_WIDTH             = HQM_TLB_MAX_LINEAR_AWIDTH+19;
    localparam HQM_TLB_1G_TAG_WIDTH             = HQM_TLB_MAX_LINEAR_AWIDTH+10;

    localparam HQM_TLB_MISSTRK_DEPTH            = 64;
    localparam HQM_TLB_MISSTRK_DEPTH_WIDTH      = $clog2(HQM_TLB_MISSTRK_DEPTH);

    typedef struct packed {
        logic                                           re;
        logic [HQM_TLB_4K_ADDR_WIDTH-1:0]               raddr;
        logic                                           we;
        logic [HQM_TLB_4K_ADDR_WIDTH-1:0]               waddr;
        logic [HQM_TLB_4K_DATA_WIDTH-1:0]               wdata;
    } hqm_sif_memi_tlb_data_4k_t;                      
                                                        
    typedef struct packed {                             
        logic [HQM_TLB_4K_DATA_WIDTH-1:0]               rdata;
    } hqm_sif_memo_tlb_data_4k_t;                      
                                                        
    typedef struct packed {                             
        logic                                           re;
        logic [HQM_TLB_4K_ADDR_WIDTH-1:0]               raddr;
        logic                                           we;
        logic [HQM_TLB_4K_ADDR_WIDTH-1:0]               waddr;
        logic [HQM_TLB_4K_TAG_WIDTH-1:0]                wdata;
    } hqm_sif_memi_tlb_tag_4k_t;                       
                                                        
    typedef struct packed {                             
        logic [HQM_TLB_4K_TAG_WIDTH-1:0]                rdata;
    } hqm_sif_memo_tlb_tag_4k_t;                       
                                                        
    typedef struct packed {                             
        logic                                           re;
        logic [HQM_TLB_2M_ADDR_WIDTH-1:0]               raddr;
        logic                                           we;
        logic [HQM_TLB_2M_ADDR_WIDTH-1:0]               waddr;
        logic [HQM_TLB_2M_DATA_WIDTH-1:0]               wdata;
    } hqm_sif_memi_tlb_data_2m_t;                      
                                                        
    typedef struct packed {                             
        logic [HQM_TLB_2M_DATA_WIDTH-1:0]               rdata;
    } hqm_sif_memo_tlb_data_2m_t;                      
                                                        
    typedef struct packed {                             
        logic                                           re;
        logic [HQM_TLB_2M_ADDR_WIDTH-1:0]               raddr;
        logic                                           we;
        logic [HQM_TLB_2M_ADDR_WIDTH-1:0]               waddr;
        logic [HQM_TLB_2M_TAG_WIDTH-1:0]                wdata;
    } hqm_sif_memi_tlb_tag_2m_t;                       
                                                        
    typedef struct packed {                             
        logic [HQM_TLB_2M_TAG_WIDTH-1:0]                rdata;
    } hqm_sif_memo_tlb_tag_2m_t;                       
                                                        
    typedef struct packed {                             
        logic                                           re;
        logic [HQM_TLB_1G_ADDR_WIDTH-1:0]               raddr;
        logic                                           we;
        logic [HQM_TLB_1G_ADDR_WIDTH-1:0]               waddr;
        logic [HQM_TLB_1G_DATA_WIDTH-1:0]               wdata;
    } hqm_sif_memi_tlb_data_1g_t;                      
                                                        
    typedef struct packed {                             
        logic [HQM_TLB_1G_DATA_WIDTH-1:0]               rdata;
    } hqm_sif_memo_tlb_data_1g_t;                      
                                                        
    typedef struct packed {                             
        logic                                           re;
        logic [HQM_TLB_1G_ADDR_WIDTH-1:0]               raddr;
        logic                                           we;
        logic [HQM_TLB_1G_ADDR_WIDTH-1:0]               waddr;
        logic [HQM_TLB_1G_TAG_WIDTH-1:0]                wdata;
    } hqm_sif_memi_tlb_tag_1g_t;                       
                                                        
    typedef struct packed {                             
        logic [HQM_TLB_1G_TAG_WIDTH-1:0]                rdata;
    } hqm_sif_memo_tlb_tag_1g_t;

    typedef struct packed {
        logic [1:0]                                     pasid_valid;
        logic [1:0]                                     pasid_priv;
        logic [1:0][HQM_PASID_WIDTH-1:0]                pasid;
        logic [1:0][HQM_TLB_MISSTRK_DEPTH_WIDTH-1:0]    id;
        logic [1:0][2:0]                                tc;
        logic [1:0]                                     nw;
        logic [1:0][15:0]                               bdf;
        logic [1:0][HQM_TLB_MAX_LINEAR_AWIDTH-1:12]     address;
    } hqm_devtlb_ats_req_t;                            
                                                       
    typedef struct packed {                            
        logic [HQM_TLB_MISSTRK_DEPTH_WIDTH-1:0]         id;
        logic                                           dperror;
        logic                                           hdrerror;
        logic [63:0]                                    data;
    } hqm_devtlb_ats_rsp_t;                            
                                                       
    typedef struct packed {                            
        logic                                           pasid_valid;
        logic                                           pasid_priv;
        logic [HQM_PASID_WIDTH-1:0]                     pasid;
        logic                                           opcode;
        logic                                           dperror;
        logic [4:0]                                     invreq_itag;
        logic [15:0]                                    invreq_reqid;
        logic [31:0]                                    dw2;
        logic [63:0]                                    data;
    } hqm_devtlb_rx_msg_t;                             
                                                       
    typedef struct packed {                            
        logic                                           pasid_valid;
        logic                                           pasid_priv;
        logic [HQM_PASID_WIDTH-1:0]                     pasid;
        logic                                           opcode;
        logic [2:0]                                     tc;
        logic [15:0]                                    bdf;
        logic [31:0]                                    dw2;
        logic [31:0]                                    dw3;
    } hqm_devtlb_tx_msg_t;                             
                                                       
    typedef struct packed {                            
        logic                                           pasid_valid;
        logic                                           pasid_priv;
        logic [HQM_PASID_WIDTH-1:0]                     pasid;
        logic [HQM_MSTR_NUM_CQS_WIDTH-1:0]              id;           // Transaction ID = CQ
        logic [0:0]                                     tlbid;        // TLBid
        logic                                           ppriority;    // request priority
        logic                                           prs;
        logic [1:0]                                     opcode;       // Customer intended use for translated address
        logic [2:0]                                     tc;           // Transaction's Traffic class 
        logic [15:0]                                    bdf;
        logic [HQM_TLB_MAX_LINEAR_AWIDTH-1:12]          address;      // Address that needs to be translated.
    } hqm_devtlb_req_t;                                
                                                       
    typedef struct packed {                            
        logic                                           result;       // Response status: 1=success (translated); 0=failure.
        logic                                           dperror;      // data parity error was seen as part of translation request
        logic                                           hdrerror;     // a header error was seen as part of ATS request (e.g. UR, CA, CTO, etc).  
        logic                                           nonsnooped;   // 1 if the translated address should be accessed with non-snoop cycle.
        logic [1:0]                                     prs_code;
        logic [HQM_MSTR_NUM_CQS_WIDTH-1:0]              id;           // Transaction ID 
        logic [HQM_TLB_MAX_HOST_AWIDTH-1:12]            address;      // Translated Address
    } hqm_devtlb_rsp_t;                                
                                                       
    typedef struct packed {                            
        logic                                           pasid_valid;
        logic                                           pasid_priv;
        logic [HQM_PASID_WIDTH-1:0]                     pasid;
        logic                                           pasid_global;
        logic [15:0]                                    bdf;
    } hqm_devtlb_drain_req_t;                          
                                                       
    typedef struct packed {                            
        logic [7:0]                                     tc;           // Traffic Class (bitwise) used by the hosting unit for all transaction.
    } hqm_devtlb_drain_rsp_t;

    // Parameters for the Memory, iosf_pdata_rxq, originally located in hqm_iosf_rxq.sv
    localparam HQM_SIF_PDATA_RXQ_AMSB           = 5;
    localparam HQM_SIF_PDATA_RXQ_DMSB           = 263;
   
    // Parameters for the Memory, iosf_cpldata_rxq, originally located in hqm_iosf_rxq.sv
    localparam HQM_SIF_CPLDATA_RXQ_AMSB         = 2;
    localparam HQM_SIF_CPLDATA_RXQ_DMSB         = 32;

    // Parameters for the Memory, i_fifo_phdr,   originally located in ri/ri_tlq.sv
    localparam HQM_SIF_FIFO_PHDR_AMSB           = 3;
    localparam HQM_SIF_FIFO_PHDR_DMSB           = 152;
   
    // Parameters for the Memory, i_fifo_pdata, originally located in ri/ri_tlq.sv
    localparam HQM_SIF_FIFO_PDATA_AMSB          = 4;
    localparam HQM_SIF_FIFO_PDATA_DMSB          = 263;
   
    // Parameters for the Memory, i_fifo_nphdr, originally located in ri/ri_tlq.sv
    localparam HQM_SIF_FIFO_NPHDR_AMSB          = 2;
    localparam HQM_SIF_FIFO_NPHDR_DMSB          = 157;
   
    // Parameters for the Memory, i_fifo_npdata, originally located in ri/ri_tlq.sv
    localparam HQM_SIF_FIFO_NPDATA_AMSB         = 2;
    localparam HQM_SIF_FIFO_NPDATA_DMSB         = 32;
   
    // Parameters for the Memory, i_fifo_cplhdr, originally located in ri/ri_tlq.sv
    localparam HQM_SIF_FIFO_CPLHDR_AMSB         = 2;
    localparam HQM_SIF_FIFO_CPLHDR_DMSB         = 53;
   
    // Parameters for the Memory, i_fifo_cpldata, originally located in ri/ri_tlq.sv
    localparam HQM_SIF_FIFO_CPLDATA_AMSB        = 3;
    localparam HQM_SIF_FIFO_CPLDATA_DMSB        = 263;
   
    // Parameters for the Memory, i_ph_fifo, originally located in ti/ti_trn.sv
    localparam HQM_SIF_PH_FIFO_AMSB             = 5;
    localparam HQM_SIF_PH_FIFO_DMSB             = 109;
   
    // Parameters for the Memory, i_pd_fifo, originally located in ti/ti_trn.sv
    localparam HQM_SIF_PD_FIFO_AMSB             = 5;
    localparam HQM_SIF_PD_FIFO_DMSB             = 264;

    localparam HQM_SIF_PH_REQ_FIFO_AMSB         = 3;
    localparam HQM_SIF_PH_REQ_FIFO_DMSB         = 152;
   
    // Input structure for the Memory, iosf_pdata_rxq, originally located in hqm_iosf_rxq.sv
    typedef struct packed {
      logic [HQM_SIF_PDATA_RXQ_AMSB:0]          waddr;              
      logic                                     we;                
      logic [HQM_SIF_PDATA_RXQ_DMSB:0]          wdata;              
      logic [HQM_SIF_PDATA_RXQ_AMSB:0]          raddr;              
      logic                                     re;          
    } hqm_sif_memi_iosf_pdata_rxq_t;
   
    // Output structure for the Memory, iosf_pdata_rxq, originally located in hqm_iosf_rxq.sv
    typedef struct packed {
      logic [HQM_SIF_PDATA_RXQ_DMSB:0]          rdata;
    } hqm_sif_memo_iosf_pdata_rxq_t;
   
   
    // Input structure for the Memory, iosf_cpldata_rxq, originally located in hqm_iosf_rxq.sv
    typedef struct packed {
      logic [HQM_SIF_CPLDATA_RXQ_AMSB:0]        waddr;              
      logic                                     we;                
      logic [HQM_SIF_CPLDATA_RXQ_DMSB:0]        wdata;              
      logic [HQM_SIF_CPLDATA_RXQ_AMSB:0]        raddr;              
      logic                                     re;          
    } hqm_sif_memi_iosf_cpldata_rxq_t;
   
    // Output structure for the Memory, iosf_cpldata_rxq, originally located in hqm_iosf_rxq.sv
    typedef struct packed {
      logic [HQM_SIF_CPLDATA_RXQ_DMSB:0]        rdata;
    } hqm_sif_memo_iosf_cpldata_rxq_t;

    // Input structure for the Memory, i_fifo_phdr,   originally located in ri/ri_tlq.sv
    typedef struct packed {
      logic [HQM_SIF_FIFO_PHDR_AMSB:0]          waddr;              
      logic                                     we;                
      logic [HQM_SIF_FIFO_PHDR_DMSB:0]          wdata;              
      logic [HQM_SIF_FIFO_PHDR_AMSB:0]          raddr;              
      logic                                     re;                
    } hqm_sif_memi_fifo_phdr_t;  
   
    // Output structure for the Memory, i_fifo_phdr,   originally located in ri/ri_tlq.sv
    typedef struct packed {
      logic [HQM_SIF_FIFO_PHDR_DMSB:0]         rdata;
    } hqm_sif_memo_fifo_phdr_t;  
   
   
    // Input structure for the Memory, i_fifo_pdata, originally located in ri/ri_tlq.sv
    typedef struct packed {
      logic [HQM_SIF_FIFO_PDATA_AMSB:0]         waddr;              
      logic                                     we;                
      logic [HQM_SIF_FIFO_PDATA_DMSB:0]         wdata;              
      logic [HQM_SIF_FIFO_PDATA_AMSB:0]         raddr;              
      logic                                     re;                
    } hqm_sif_memi_fifo_pdata_t;
   
    // Output structure for the Memory, i_fifo_pdata, originally located in ri/ri_tlq.sv
    typedef struct packed {
      logic [HQM_SIF_FIFO_PDATA_DMSB:0]         rdata;
    } hqm_sif_memo_fifo_pdata_t;
   
   
    // Input structure for the Memory, i_fifo_nphdr, originally located in ri/ri_tlq.sv
    typedef struct packed {
      logic [HQM_SIF_FIFO_NPHDR_AMSB:0]         waddr;              
      logic                                     we;                
      logic [HQM_SIF_FIFO_NPHDR_DMSB:0]         wdata;              
      logic [HQM_SIF_FIFO_NPHDR_AMSB:0]         raddr;              
      logic                                     re;                
    } hqm_sif_memi_fifo_nphdr_t;
   
    // Output structure for the Memory, i_fifo_nphdr, originally located in ri/ri_tlq.sv
    typedef struct packed {
      logic [HQM_SIF_FIFO_NPHDR_DMSB:0]         rdata;
    } hqm_sif_memo_fifo_nphdr_t;
   
   
    // Input structure for the Memory, i_fifo_npdata, originally located in ri/ri_tlq.sv
    typedef struct packed {
      logic [HQM_SIF_FIFO_NPDATA_AMSB:0]        waddr;              
      logic                                     we;                
      logic [HQM_SIF_FIFO_NPDATA_DMSB:0]        wdata;              
      logic [HQM_SIF_FIFO_NPDATA_AMSB:0]        raddr;              
      logic                                     re;                
    } hqm_sif_memi_fifo_npdata_t;
   
    // Output structure for the Memory, i_fifo_npdata, originally located in ri/ri_tlq.sv
    typedef struct packed {
      logic [HQM_SIF_FIFO_NPDATA_DMSB:0]        rdata;
    } hqm_sif_memo_fifo_npdata_t;
   
    // Input structure for the Memory, i_ph_fifo, originally located in ti/ti_trn.sv
    typedef struct packed {
      logic [HQM_SIF_PH_FIFO_AMSB:0]            waddr;              
      logic                                     we;                
      logic [HQM_SIF_PH_FIFO_DMSB:0]            wdata;              
      logic [HQM_SIF_PH_FIFO_AMSB:0]            raddr;              
      logic                                     re;                
    } hqm_sif_memi_ph_fifo_t;
   
    // Output structure for the Memory, i_ph_fifo, originally located in ti/ti_trn.sv
    typedef struct packed {
      logic [HQM_SIF_PH_FIFO_DMSB:0]            rdata;
    } hqm_sif_memo_ph_fifo_t;
   
    // Input structure for the Memory, i_pd_fifo, originally located in ti/ti_trn.sv
    typedef struct packed {
      logic [HQM_SIF_PD_FIFO_AMSB:0]            waddr;              
      logic                                     we;                
      logic [HQM_SIF_PD_FIFO_DMSB:0]            wdata;              
      logic [HQM_SIF_PD_FIFO_AMSB:0]            raddr;              
      logic                                     re;                
    } hqm_sif_memi_pd_fifo_t;
   
    // Output structure for the Memory, i_pd_fifo, originally located in ti/ti_trn.sv
    typedef struct packed {
      logic [HQM_SIF_PD_FIFO_DMSB:0]            rdata;
    } hqm_sif_memo_pd_fifo_t;
   
    typedef struct packed {
      logic [HQM_SIF_PH_REQ_FIFO_AMSB:0]        waddr;              
      logic                                     we;                
      logic [HQM_SIF_PH_REQ_FIFO_DMSB:0]        wdata;              
      logic [HQM_SIF_PH_REQ_FIFO_AMSB:0]        raddr;              
      logic                                     re;                
    } hqm_sif_memi_ph_req_fifo_t;
   
    typedef struct packed {
      logic [HQM_SIF_PH_REQ_FIFO_DMSB:0]        rdata;
    } hqm_sif_memo_ph_req_fifo_t;
   
    typedef struct packed {
   
      logic           flr_cmp_sent;                                  // 679
      logic           flr_triggered_wl;                              // 678
      logic           flr_clk_enable;                                // 677
      logic           flr_clk_enable_system;                         // 676
      logic           prim_clk_enable_cdc;                           // 675
      logic           flr_triggered;                                 // 674
      logic           ps_d0_to_d3;                                   // 673
      logic           flr_function0;                                 // 672
   
      logic           flr_treatment;                                 // 671
      logic           flr_pending;                                   // 670
      logic           bme_or_mem_wr;                                 // 669
      logic           ps_txn_sent_q;                                 // 668
      logic           ps_cmp_sent_q;                                 // 667
      logic           ps_cmp_sent_ack;                               // 666
      logic           flr_txn_sent_q;                                // 665
      logic           flr_cmp_sent_q;                                // 664
      logic           flr;                                           // 663
      logic           pf0_fsm_rst;                                   // 662
      logic   [1:0]   ps;                                            // 661:660
   
      logic           sw_trigger;                                    // 659
      logic           prim_gated_rst_b_sync;                         // 658
      logic           prim_clk_enable;                               // 657
      logic           prim_clk_enable_sys;                           // 656
   
      logic           prim_clkreq_sync;                              // 655
      logic           prim_clkack_sync;                              // 654
      logic           hqm_idle_q;                                    // 653
      logic           sys_mstr_idle;                                 // 652
      logic           sys_tgt_idle;                                  // 651
      logic           sys_ri_idle;                                   // 650
      logic           sys_ti_idle;                                   // 649
      logic           sys_cfgm_idle;                                 // 648
   
      logic   [2:0]   iosf_tgt_dec_bits;                             // 647:645   //  31: 29    //  23: 21
      logic   [3:0]   iosf_tgt_dec_type;                             // 644:641   //  28: 25    //  20: 17
      logic           iosf_tgt_idle;                                 // 640       //  24        //  16
                                                                                          
      logic   [1:0]   iosf_tgt_cput_cmd_rtype;                       // 639:638   //  23: 22    //  15: 14
      logic           iosf_tgt_cput_cmd_put;                         // 637       //  21        //  13
      logic   [1:0]   iosf_tgt_cmd_tfmt;                             // 636:635   //  20: 19    //  12: 11
      logic           iosf_tgt_has_data;                             // 634       //  18        //  10
      logic   [9:0]   iosf_tgt_data_count_ff;                        // 633:624   //  17:  8    //   9:  0
                                                                                  
      logic           iosf_tgt_crdtinit_in_progress;                 // 623       //   7
      logic           iosf_tgt_rst_complete;                         // 622       //   6
      logic           iosf_tgt_credit_init;                          // 621       //   5
      logic           iosf_tgt_zero;                                 // 620       //   4
      logic   [3:0]   iosf_tgt_port_present;                         // 619:616   //   3:  0
   
      logic   [31:0]  mstr_iosf_cmd_caddress_31_0;                   // 615:584   // 135:104

      logic   [3:0]   mstr_iosf_cmd_clbe;                            // 583:580   // 103:100
      logic   [3:0]   mstr_iosf_cmd_cfbe;                            // 579:576   //  99: 96

      logic   [7:0]   mstr_iosf_cmd_ctag;                            // 575:568   //  95: 88

      logic   [15:0]  mstr_iosf_cmd_crqid;                           // 567:552   //  87: 72

      logic   [7:0]   mstr_iosf_cmd_clength_7_0;                     // 551:544   //  71: 64

      logic           mstr_iosf_cmd_cth;                             // 543       //  63
      logic           mstr_iosf_cmd_cep;                             // 542       //  62
      logic           mstr_iosf_cmd_cro;                             // 541       //  61
      logic           mstr_iosf_cmd_cns;                             // 540       //  60
      logic           mstr_iosf_cmd_cido;                            // 539       //  59
      logic   [1:0]   mstr_iosf_cmd_cat;                             // 538:537   //  58: 57
      logic           mstr_iosf_cmd_ctd;                             // 536       //  56

      logic           mstr_iosf_gnt_q_gnt2;                          // 535       //  55
      logic   [1:0]   mstr_iosf_cmd_cfmt;                            // 534:533   //  54: 53
      logic   [4:0]   mstr_iosf_cmd_ctype;                           // 532:528   //  52: 48

      logic   [2:0]   mstr_iosf_req_dlen_4_2;                        // 527:525   //  47: 45
      logic   [4:0]   mstr_iosf_req_credits_cpl;                     // 524:520   //  44: 40

      logic   [1:0]   mstr_iosf_req_dlen_1_0;                        // 519:518   //  39: 38
      logic           mstr_data_out_valid_q;                         // 517       //  37
      logic   [4:0]   mstr_iosf_req_credits_p;                       // 516:512   //  36: 32

      logic           mstr_idle;                                     // 511       //  31
      logic   [1:0]   mstr_hfifo_data_fmt;                           // 510:509   //  30: 29
      logic   [4:0]   mstr_hfifo_data_type;                          // 508:504   //  28: 24

      logic   [1:0]   mstr_rxq_hdr_avail;                            // 503:502   //  23: 22
      logic   [1:0]   mstr_iosf_gnt_q_dec;                           // 501:500   //  21: 20
      logic   [1:0]   mstr_req_fifo_empty;                           // 499:498   //  19: 18
      logic   [1:0]   mstr_req_fifo_fully;                           // 497:496   //  17: 16

      logic   [2:0]   mstr_prim_ism_agent;                           // 495:493   //  15: 13
      logic           mstr_dfifo_rd_gt4dw;                           // 492       //  12
      logic   [1:0]   mstr_dfifo_rd;                                 // 491:490   //  11: 10
      logic   [1:0]   mstr_hfifo_rd;                                 // 489:488   //   9:  8

      logic   [1:0]   mstr_iosf_gnt_q_gtype;                         // 487:486   //   7:  6
      logic   [1:0]   mstr_iosf_gnt_q_rtype;                         // 485:484   //   5:  4
      logic           mstr_iosf_gnt_q_gnt;                           // 483       //   3
      logic   [1:0]   mstr_iosf_req_rtype;                           // 482:481   //   2:  1
      logic           mstr_iosf_req_put;                             // 480       //   0

      logic           mstr_iosfp_ti_rxq_rdy;                         // 479       //  55
      logic           mstr_iosfp_ri_rxq_rsprepack_vote_ri;           // 478       //  54
      logic           mstr_iosf_ep_poison_wr_sent_rl;                // 477       //  53
      logic   [4:0]   mstr_iosf_ep_poison_wr_func_rxl;               // 476:472   //  52: 48

      logic           rxq_ti_rsprepack_vote_rp_q;                    // 471       //  47
      logic           rxq_ri_iosfp_quiesce_rp;                       // 470       //  46
      logic           cplhdr_rxq_fifo_perr_q;                        // 469       //  45
      logic           ioq_rxq_fifo_pop;                              // 468       //  44
      logic           phdr_rxq_fifo_pop;                             // 467       //  43
      logic           pdata_rxq_fifo_pop;                            // 466       //  42
      logic           cplhdr_rxq_fifo_pop;                           // 465       //  41
      logic           cpldata_rxq_fifo_pop;                          // 464       //  40

      logic           rxq_ti_iosfp_ifc_wxi_stp;                      // 463       //  39
      logic           rxq_ti_iosfp_ifc_wxi_endp;                     // 462       //  38
      logic           phdr_rxq_fifo_perr_q;                          // 461       //  37
      logic           ioq_rxq_fifo_push;                             // 460       //  36
      logic           phdr_rxq_fifo_push;                            // 459       //  35
      logic           pdata_rxq_fifo_push;                           // 458       //  34
      logic           cplhdr_rxq_fifo_push;                          // 457       //  33
      logic           cpldata_rxq_fifo_push;                         // 456       //  32

      logic   [7:0]   rxq_ti_pciemhdr_tag;                           // 455:448   //  31: 24

      logic   [7:0]   rxq_ti_pciemhdr_rid_7_0;                       // 447:440   //  23: 16

      logic   [7:0]   rxq_ti_pciemhdr_length_7_0;                    // 439:432   //  15:  8

      logic           rxq_ti_iosfp_push_wi;                          // 431       //   7
      logic   [6:0]   rxq_pcie_cmd;                                  // 430:424   //   6:  0
   
      logic           tlq_idle_q2;                                   // 423       //  31
      logic           tlq_lli_cpar_err_wp;                           // 422       //  30
      logic           tlq_lli_tecrc_err_wp;                          // 421       //  29
      logic           tlq_cds_pd_rd_wp2;                             // 420       //  28
      logic           tlq_ri_crdinc_wl_pd;                           // 419       //  27
      logic           tlq_iosf_ep_poison_wr_sent_rp;                 // 418       //  26
      logic           tlq_cto_ec_err_wxp_or;                         // 417       //  25
      logic           tlq_cto_ec_ud_fnc_wp;                          // 416       //  24
                                                                                          
      logic           tlq_phdr_val;                                  // 415       //  23
      logic           tlq_cds_phdr_rd_wp;                            // 414       //  22
      logic           tlq_phdrval_wp;                                // 413       //  21
      logic           tlq_phdr_fifo_full;                            // 412       //  20
      logic           tlq_pdata_push;                                // 411       //  19
      logic           tlq_cds_pd_rd_wp;                              // 410       //  18
      logic           tlq_tlq_pdataval_wp;                           // 409       //  17
      logic           tlq_pdata_fifo_full;                           // 408       //  16
                                                                                      
      logic           tlq_nphdr_val;                                 // 407       //  15
      logic           tlq_cds_nphdr_rd_wp;                           // 406       //  14
      logic           tlq_nphdrval_wp;                               // 405       //  13
      logic           tlq_nphdr_fifo_full;                           // 404       //  12
      logic           tlq_npdata_push;                               // 403       //  11
      logic           tlq_cds_npd_rd_wp;                             // 402       //  10
      logic           tlq_npdataval_wp;                              // 401       //   9
      logic           tlq_npdata_fifo_full;                          // 400       //   8
                                                                           
      logic           tlq_idle_q;                                    // 399       //   7
      logic           tlq_ioq_fifo_full;                             // 398       //   6
      logic           tlq_ioq_hdr_push_in;                           // 397       //   5
      logic           tlq_ioq_pop;                                   // 396       //   4
      logic           tlq_ioqval_wp;                                 // 395       //   3
      logic   [2:0]   tlq_ioq_data_rxp;                              // 394:392   //   2:  0
   
      logic   [1:0]   obc_zero;                                      // 391:390   //  63: 62
      logic           obc_ri_obcmpl_req_rl;                          // 389       //  61
      logic           obc_ri_obcmpl_hdr_rxl_ep;                      // 388       //  60
      logic   [2:0]   obc_ri_obcmpl_hdr_rxl_tc;                      // 387:385   //  59: 57
      logic           obc_ri_obcmpl_hdr_rxl_fmt;                     // 384       //  56
                                                                                     
      logic   [2:0]   obc_ri_obcmpl_hdr_rxl_cs;                      // 383:381   //  55: 53
      logic   [4:0]   obc_ri_obcmpl_hdr_rxl_addr_6_2;                // 380:376   //  52: 48
                                                                                     
      logic   [7:0]   obc_ri_obcmpl_hdr_rxl_length_7_0;              // 375:368   //  47: 40
                                                                                     
      logic   [15:0]  obc_ri_obcmpl_hdr_rxl_rid;                     // 367:352   //  39: 24
                                                                                     
      logic   [7:0]   obc_ri_obcmpl_hdr_rxl_tag;                     // 351:344   //  23: 16
                                                                                     
      logic           obc_hdr_full_wp;                               // 343       //  15
      logic           obc_cds_obchdr_rdy_wp3;                        // 342       //  14
      logic           obc_ti_obcmpl_ack_rl;                          // 341       //  13
      logic           obc_pend_sig_dval2;                            // 340       //  12
      logic           obc_cds_obchdr_rdy_wp2;                        // 339       //  11
      logic           obc_int_sig_gnt;                               // 338       //  10
      logic           obc_int_sig_dval;                              // 337       //   9
      logic           obc_int_sig_num_fifo_full;                     // 336       //   8
                                                                                      
      logic           obc_pend_sig_push;                             // 335       //   7
      logic           obc_pend_sig_fifo_pop;                         // 334       //   6
      logic           obc_pend_sig_dval;                             // 333       //   5
      logic           obc_pend_sig_fifo_full;                        // 332       //   4
      logic           obc_cds_obchdr_rdy_wp;                         // 331       //   3
      logic           obc_dequeue_csr_cpl;                           // 330       //   2
      logic           obc_cur_csr_data_val;                          // 329       //   1
      logic           obc_csr_data_fifo_full;                        // 328       //   0
   
      logic           csr_ext_mmio_ack_sai_successfull;              // 327       // 111
      logic           csr_ext_mmio_ack_read_miss;                    // 326       // 110
      logic           csr_ext_mmio_ack_write_miss;                   // 325       // 109
      logic           csr_ext_mmio_ack_read_valid;                   // 324       // 108
      logic           csr_ext_mmio_ack_write_valid;                  // 323       // 107
      logic           csr_ext_mmio_req_valid;                        // 322       // 106
      logic           csr_ext_mmio_req_opcode_0;                     // 321       // 105
      logic           csr_ext_mmio_req_data_0;                       // 320       // 104
                                                                                        
      logic           csr_int_mmio_ack_sai_successfull;              // 319       // 103
      logic           csr_int_mmio_ack_read_miss;                    // 318       // 102
      logic           csr_int_mmio_ack_write_miss;                   // 317       // 101
      logic           csr_int_mmio_ack_read_valid;                   // 316       // 100
      logic           csr_int_mmio_ack_write_valid;                  // 315       //  99 
      logic           csr_int_mmio_req_valid;                        // 314       //  98 
      logic           csr_int_mmio_req_opcode_0;                     // 313       //  97 
      logic           csr_int_mmio_req_data_0;                       // 312       //  96 
                                                                                     
      logic           csr_pf0_ack_sai_successfull;                   // 311       //  95
      logic           csr_pf0_ack_read_miss;                         // 310       //  94
      logic           csr_pf0_ack_write_miss;                        // 309       //  93
      logic           csr_pf0_ack_read_valid;                        // 308       //  92
      logic           csr_pf0_ack_write_valid;                       // 307       //  91
      logic           csr_pf0_req_valid;                             // 306       //  90
      logic           csr_pf0_req_opcode_0;                          // 305       //  89
      logic           csr_pf0_req_data_0;                            // 304       //  88
                                                                                     
      logic   [3:0]   csr_req_q_csr_wr_offset_11_8;                  // 303:300   //  87: 84
      logic   [3:0]   csr_req_q_csr_rd_offset_11_8;                  // 299:296   //  83: 80
                                                                                     
      logic   [7:0]   csr_req_q_csr_wr_offset_7_0;                   // 295:288   //  79: 72
                                                                                     
      logic   [7:0]   csr_req_q_csr_rd_offset_7_0;                   // 287:280   //  71: 64
                                                                                     
      logic   [31:0]  csr_req_q_csr_mem_mapped_offset;               // 279:248   //  63: 32
                                                                                     
      logic           csr_req_q_csr_mem_mapped;                      // 247       //  31
      logic           csr_req_q_csr_ext_mem_mapped;                  // 246       //  30
      logic           csr_req_q_csr_func_pf_mem_mapped;              // 245       //  29
      logic           csr_req_q_csr_func_vf_mem_mapped;              // 244       //  28
      logic   [3:0]   csr_req_q_csr_func_vf_num;                     // 243:240   //  27: 24
                                                                                     
      logic           csr_read_q;                                    // 239       //  23
      logic           csr_rd_stall;                                  // 238       //  22
      logic           csr_ppmcsr_wr_stall;                           // 237       //  21
      logic   [4:0]   csr_req_q_csr_rd_func;                         // 236:232   //  20: 16
                                                                                     
      logic           csr_wr_q;                                      // 231       //  15
      logic           csr_wr_stall;                                  // 230       //  14
      logic           csr_req_q_csr_byte_en_0;                       // 229       //  13
      logic   [4:0]   csr_req_q_csr_wr_func;                         // 228:224   //  12:  8
                                                                                     
      logic   [7:0]   csr_req_q_csr_sai;                             // 223:216   //   7:  0
   
      logic           cds_cbd_func_pf_bar_hit_0;                     // 215       //  47   
      logic           cds_cbd_func_vf_bar_hit_0;                     // 214       //  46   
      logic   [1:0]   cds_cbd_func_pf_rgn_hit;                       // 213:212   //  45: 44
      logic   [1:0]   cds_cbd_csr_pf_rgn_hit;                        // 211:210   //  43: 42
      logic   [1:0]   cds_cbd_func_vf_rgn_hit;                       // 209:208   //  41: 40
                                                                                          
      logic           cds_csr_rd_ur;                                 // 207       //  39   
      logic           cds_csr_rd_sai_error;                          // 206       //  38   
      logic           cds_csr_rd_timeout_error;                      // 205       //  37   
      logic           cds_mmio_wr_sai_error;                         // 204       //  36   
      logic           cds_mmio_wr_sai_ok;                            // 203       //  35   
      logic           cds_cfg_wr_ur;                                 // 202       //  34   
      logic           cds_cfg_wr_sai_error;                          // 201       //  33   
      logic           cds_cfg_wr_sai_ok;                             // 200       //  32   
                                                                                         
      logic           cds_cbd_csr_pf_bar_hit;                        // 199       //  31
      logic           cds_tlq_cds_phdr_par_err;                      // 198       //  30
      logic           cds_tlq_cds_pdata_par_err;                     // 197       //  29
      logic           cds_tlq_cds_nphdr_par_err;                     // 196       //  28
      logic           cds_tlq_cds_npdata_par_err;                    // 195       //  27
      logic           cds_err_msg_gnt;                               // 194       //  26
      logic           cds_malform_pkt;                               // 193       //  25
      logic           cds_npusr_err_wp;                              // 192       //  24
                                                                                             
      logic           cds_usr_in_cpl;                                // 191       //  23
      logic           cds_pusr_err_wp;                               // 190       //  22
      logic           cds_cfg_usr_func;                              // 189       //  21
      logic           cds_ca_err_wp;                                 // 188       //  20
      logic           cds_poison_err_wp;                             // 187       //  19
      logic           cds_bar_decode_err_wp;                         // 186       //  18
      logic           cds_tlq_phdrval_wp;                            // 185       //  17
      logic           cds_tlq_nphdrval_wp;                           // 184       //  16
                                                                                            
      logic           cds_tlq_pdataval_wp;                           // 183       //  15
      logic           cds_tlq_npdataval_wp;                          // 182       //  14
      logic           cds_tlq_ioqval_wp_1;                           // 181       //  13
      logic           cds_phdr_rd_wp;                                // 180       //  12
      logic           cds_nphdr_rd_wp;                               // 179       //  11
      logic           cds_npd_rd_wp;                                 // 178       //  10
      logic           cds_pd_rd_wp;                                  // 177       //   9
      logic           cds_addr_val;                                  // 176       //   8
                                                                                          
      logic   [6:2]   cds_addr_6_2;                                  // 175:171   //   7:  3  
      logic           cds_cbd_decode_val_0;                          // 170       //   2    
      logic           cds_mem_hit_csr_pf_rgn;                        // 169       //   1    
      logic           cds_cbd_rdy;                                   // 168       //   0    

      logic           ri_idle_q;                                     // 167 
      logic           csr_pasid_enable;                              // 166       // 166
      logic           reqsrv_send_msg;                               // 165       // 165
      logic           ri_iosfp_quiesce_rp;                           // 164       // 164
      logic           ti_rsprepack_vote_rp;                          // 163       // 163
      logic           ti_iosfp_push_wl;                              // 162       // 162
      logic           ti_idle_q;                                     // 161       // 161
      logic           ph_trigger;                                    // 160       // 160

      logic           phdr_rxl_pasidtlp_22;                          // 159       // 159
      logic   [5:0]   phdr_rxl_pasidtlp_5_0;                         // 158:153   // 158:153
      logic           pdata_fifo_pop_data_4;                         // 152       // 152

      logic   [3:0]   pdata_fifo_pop_data_3_0;                       // 151:148   // 151:148
      logic   [3:0]   trn_msi_vf;                                    // 147:144   // 147:144
   
      logic           trn_msi_write;                                 // 143       // 143
      logic           trn_ioq_p_rl;                                  // 142       // 142
      logic           trn_ioq_valid_rl;                              // 141       // 141
      logic           trn_p_req_wl;                                  // 140       // 140
      logic           trn_ioq_cmpl_rl;                               // 139       // 139
      logic           trn_cmpl_req_rl;                               // 138       // 138
      logic           trn_ri_obcmpl_req_rl2;                         // 137       // 137
      logic           trn_ti_obcmpl_ack_rl2;                         // 136       // 136
   
      logic           trn_p_tlp_avail_wl;                            // 135       // 135    
      logic   [1:0]   trn_trans_type_rxl;                            // 134:133   // 134:133
      logic   [4:0]   trn_nxtstate_wxl;                              // 132:128   // 132:128

      logic           trn_phdr_deq_wl2;                              // 127       // 127
      logic           trn_ph_valid_rl;                               // 126       // 126
      logic           trn_pdata_valid_rl;                            // 125       // 125
      logic           trn_pderr_rxl;                                 // 124       // 124
      logic           trn_phdr_rxl_ro;                               // 123       // 123
      logic           trn_req_avail_wl;                              // 122       // 122
      logic           trn_cmplh_deq_wl;                              // 121       // 121
      logic           trn_phdr_deq_wl;                               // 120       // 120

      logic   [1:0]   trn_fsm_out_tlp_cmpl_wxl;                      // 119:118   // 119:118
      logic           trn_update_consumed_cnt_wl;                    // 117       // 117    
      logic           trn_zero_byte_wr_wl;                           // 116       // 116    
      logic   [3:0]   trn_p_tlp_cnt_rxl;                             // 115:112   // 115:112

      logic   [3:0]   trn_num_p_tlps_wxl;                            // 111:108   // 111:108
      logic           trn_nxt_hdrsize_rl;                            // 107       // 107    
      logic           trn_nxt_hdrsize_wl;                            // 106       // 106    
      logic   [9:8]   trn_pbyte_length_wxp_9_8;                      // 105:104   // 105:104

      logic   [7:0]   trn_pbyte_length_wxp;                          // 103: 96   // 103: 96

      logic   [7:0]   trn_nxt_tlp_len_rxl;                           //  95: 88   //  95: 88

      logic           trn_cmpl_avail_wl;                             //  87       //  87
      logic           trn_pciemhdr_wxl_ep;                           //  86       //  86
      logic   [1:0]   trn_ri_obcmpl_hdr_rxl_length_1_0;              //  85: 84   //  85: 84
      logic           trn_ti_obcmpl_ack_rl;                          //  83       //  83
      logic           trn_ri_obcmpl_req_rl;                          //  82       //  82

      logic   [9:8]   trn_ri_obcmpl_hdr_rxl_tag_9_8;                 //  81: 80   //  81: 80

      logic   [7:0]   trn_ri_obcmpl_hdr_rxl_tag;                     //  79: 72   //  79: 72

      logic   [4:0]   trn_pciemhdr_wxl_rid;                          //  71: 67   //  71: 67
      logic   [2:0]   trn_pciemhdr_wxl_tag;                          //  66: 64   //  66: 64

      logic   [4:0]   trn_pciechdr_wxl_cid;                          //  63: 59   //  63: 59
      logic   [2:0]   trn_pciechdr_wxl_tag;                          //  58: 56   //  58: 56

      logic   [7:0]   trn_tlp_dwrem_wxl;                             //  55: 48   //  55: 48

      logic           trn_data_fifo_val_wl;                          //  47       //  47
      logic           trn_cpp_be_rl;                                 //  46       //  46
      logic           trn_iosf_rxq_full_rl_0;                        //  45       //  45
      logic           trn_final_data_in_fifo_wl;                     //  44       //  44
      logic           trn_pcie_data_val_rl;                          //  43       //  43
      logic           trn_pdata_fifo_deq_wl;                         //  42       //  42
      logic           trn_pdata_autodeq_wl;                          //  41       //  41
      logic           trn_ti_iosfp_push_wl2;                         //  40       //  40

      logic   [7:0]   trn_cdt_inc_wxl;                               //  39: 32   //  39: 32
   
      logic   [15:0]  trn_pdata_rxl;                                 //  31: 16   //  31: 16

      logic   [15:0]  trn_nxt_hdr_wxp_17_2;                          //  15:  0   //  15:  0
   
    } hqm_sif_visa_signals_t;

  typedef struct packed {
    logic [7:0]                             revision_id;            // [  15:   8] rst=0x00
    logic [5:0]                             hqm_spare;              // [   7:   2] rst=0x00
    logic                                   force_on;               // [   1:   1] rst=0x0
    logic                                   proc_disable;           // [   0:   0] rst=0x0
  } hqm_sif_fuses_t;

  localparam EARLY_FUSES_BITS_TOT                       = $bits(hqm_sif_fuses_t);
   
endpackage: hqm_sif_pkg

