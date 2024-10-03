
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
//----------------------------------------------------------------------------
//
//  INTEL CONFIDENTIAL
//
//  Copyright 2020 Intel Corporation All Rights Reserved.
//
//  The source code contained or described herein and all documents related
//  to the source code (Material) are owned by Intel Corporation or its
//  suppliers or licensors. Title to the Material remains with Intel
//  Corporation or its suppliers and licensors. The Material contains trade
//  secrets and proprietary and confidential information of Intel or its
//  suppliers and licensors. The Material is protected by worldwide copyright
//  and trade secret laws and treaty provisions. No part of the Material may
//  be used, copied, reproduced, modified, published, uploaded, posted,
//  transmitted, distributed, or disclosed in any way without Intels prior
//  express written permission.
//
//  No license under any patent, copyright, trade secret or other intellectual
//  property right is granted to or conferred upon you by disclosure or
//  delivery of the Materials, either expressly, by implication, inducement,
//  estoppel or otherwise. Any license under such intellectual property rights
//  must be express and approved by Intel in writing.
//
//----------------------------------------------------------------------------
// If this is not defined, also need to set HQM_SFI to 0 in the tool.cth file
// Log2 Function
//-----------------------------------------------------------------------------------
//Log2 function with log(1)=1. (Ceiling) FIX:define a case for log(1) used in [index-1:0]
//----------------------------------------------------------------------------------------
//Log2 +1 function 
//-----------------
//CPP command and ID field widths
//number of TI scoreboard ENTRIES-1
//this is also the maximum number of
//outstanding reads supported by the EP
//Amount of credits supported by the Endpoint
//i.e. RI buffer size.
//Counter sizes for above credits
// maximum number of credits supported on the link
// Defines for the link layer interface 
// Defines the posted data queue pointer size(16 entries). The MSB is for wrap. 
// Defines the posted data queue pointer size(8 entries). The MSB is for wrap. 
// The maximum number of bits for the header
// Header field defines
//PWR managment
// Count for the number of clocks the reset is held low
// Power management CSR write delay
// ---------------------------------------------------------------------------
// IOSF Sideband related defines
// ---------------------------------------------------------------------------
// create defines for SB bar regions
// ---------------------------------------------------------------------------
//==============================
// Flowclass
//==============================
//==============================
// fmt 
//==============================
//==============================
// {fmt.type} 
//==============================
//==============================
// Completion Status
//==============================
//=============================
// VC and PORTS bits
//============================
//======================================
// Address bits ranges from IOSF CMD bus
//======================================
//======================================
//=====================================
// Address decode type
//=====================================
//=====================================
// Address decode ranges
//=====================================
//=========================================
// Address decode additional info for ERROR
//========================================== 
//==========================================
// ISM States
//==========================================
//==========================================   
// `ifndef HQM_SYSTEM_DEF__
package hqm_sif_pkg ;
    import hqm_AW_pkg:: *, hqm_pkg:: * ;
    // IOSF Primary Parameters
    localparam MMAX_ADDR = 63 ; 
    localparam TMAX_ADDR = 63 ; 
    localparam MD_WIDTH = 255 ; 
    localparam TD_WIDTH = 255 ; 
    localparam MDP_WIDTH = ((MD_WIDTH >= 511) ? 1 :
	0) ; 
    localparam TDP_WIDTH = ((TD_WIDTH >= 511) ? 1 :
	0) ; 
    localparam AGENT_WIDTH = 0 ; 
    localparam SRC_ID_WIDTH = 13 ; 
    localparam DST_ID_WIDTH = 13 ; 
    localparam MAX_DATA_LEN = 9 ; 
    localparam SAI_WIDTH = 7 ; 
    localparam RS_WIDTH = 0 ; 
    localparam PARITY_REQUIRED = 1 ; 
    localparam INACTIVE_ZERO_MODE_EN = 1 ; 
    localparam HQM_PASID_WIDTH = 20 ; 
    localparam HQM_PASIDTLP_WIDTH = (HQM_PASID_WIDTH + 3) ; // FMT[2] + PM_REQ + EXE_REQ + PASID
    localparam MSTR_PCQ_SZ = 4 ; 
    localparam MSTR_PDQ_SZ = 4 ; 
    localparam MSTR_NPCQ_SZ = 4 ; 
    localparam MSTR_NPDQ_SZ = 4 ; 
    localparam MSTR_CPCQ_SZ = 4 ; 
    localparam MSTR_CPDQ_SZ = 4 ; 
    localparam RCDT_P = 4 ; 
    localparam RCDT_NP = 4 ; 
    localparam RCDT_CP = 4 ; 
    localparam PARQDEPTH = 4 ; 
    localparam NPARQDEPTH = 4 ; 
    localparam CPARQDEPTH = 4 ; 
    localparam MAX_CCDT = 5 ; 
    localparam MAX_DCDT = 7 ; 
    localparam TGT_PCQ_SZ = 4 ; 
    localparam TGT_PDQ_SZ = 4 ; 
    localparam TGT_NPCQ_SZ = 4 ; 
    localparam TGT_NPDQ_SZ = 4 ; 
    localparam TGT_CPCQ_SZ = 4 ; 
    localparam TGT_CPDQ_SZ = 4 ; 
    // IOSF Sideband Parameters
    localparam SBE_ASYNCIQDEPTH = 2 ; 
    localparam SBE_ASYNCEQDEPTH = 2 ; 
    localparam SBE_PIPEISMS = 0 ; 
    localparam SBE_PIPEINPS = 0 ; 
    localparam SBE_CLKREQ_HYST_CNT = 15 ; 
    localparam SBE_DO_SERR_MASTER = 1 ; 
    localparam HQMIOSF_TCRD_BYPASS = 1 ; 
    localparam HQMIOSF_TGT_TX_PRH = 4 ; 
    localparam HQMIOSF_TGT_TX_NPRH = 4 ; 
    localparam HQMIOSF_TGT_TX_CPLH = 4 ; 
    localparam HQMIOSF_TGT_TX_PRD = 16 ; 
    localparam HQMIOSF_TGT_TX_NPRD = 4 ; 
    localparam HQMIOSF_TGT_TX_CPLD = 16 ; 
    // iosf_mstr
    localparam HQMIOSF_MSTR_MAX_PAYLOAD = 512 ; 
    // iosf common
    localparam HQMIOSF_MMAX_ADDR = MMAX_ADDR ; 
    localparam HQMIOSF_TMAX_ADDR = TMAX_ADDR ; 
    localparam HQMIOSF_MD_WIDTH = MD_WIDTH ; 
    localparam HQMIOSF_TD_WIDTH = TD_WIDTH ; 
    localparam HQMIOSF_MDP_WIDTH = MDP_WIDTH ; 
    localparam HQMIOSF_TDP_WIDTH = TDP_WIDTH ; 
    localparam HQMIOSF_AGENT_WIDTH = AGENT_WIDTH ; 
    localparam HQMIOSF_DST_ID_WIDTH = DST_ID_WIDTH ; 
    localparam HQMIOSF_SRC_ID_WIDTH = SRC_ID_WIDTH ; 
    localparam HQMIOSF_MAX_DATA_LEN = MAX_DATA_LEN ; 
    localparam HQMIOSF_SAI_WIDTH = SAI_WIDTH ; 
    localparam HQMIOSF_RS_WIDTH = RS_WIDTH ; 
    localparam HQMIOSF_PASIDTLP_WIDTH = HQM_PASIDTLP_WIDTH ; 
    localparam HQMIOSF_PORTS = 1 ; 
    localparam HQMIOSF_VC = 1 ; 
    localparam HQMIOSF_RD_PO = 19 ; 
    localparam HQMIOSF_RD_NP = 19 ; 
    localparam HQMIOSF_RD_CP = 2 ; 
    localparam HQMIOSF_MNUMCHAN = 0 ; 
    localparam HQMIOSF_MNUMCHANL2 = 0 ; 
    localparam HQMIOSF_TNUMCHANL2 = 0 ; 
    localparam HQMIOSF_NUMCHANL2 = ((HQMIOSF_MNUMCHANL2 > HQMIOSF_TNUMCHANL2) ? HQMIOSF_MNUMCHANL2 :
	HQMIOSF_TNUMCHANL2) ; 
    // This is IOSF SB SAI Params
    localparam HQMIOSF_RX_EXT_HEADER_SUPPORT = 1 ; 
    localparam HQMIOSF_TX_EXT_HEADER_SUPPORT = 1 ; 
    localparam HQMIOSF_NUM_TX_EXT_HEADERS = 0 ; 
    localparam HQMIOSF_NUM_RX_EXT_HEADERS = 0 ; 
    // Exphdr1 id is always 7 bits though, if can chain (these become lists), though not on BEK
    // A little confusing this is the lower 8 bits of the SAI DW. Bit 7 indicates yet another EH.
    localparam HQMIOSF_RX_EXT_HEADER_IDS = 8'h0 ; 
    localparam HQMIOSF_TX_EXT_HEADER_IDS = 8'h0 ; 
    localparam HQM_POSTED = 0 ; 
    localparam HQM_NONPOSTED = 1 ; 
    localparam HQM_COMPLETION = 2 ; 
    // Global Parameters - That are currently local to the Host Interface
    localparam HQMTI_DATA_WID = (HQMIOSF_MD_WIDTH + 1) ; 
    localparam HQMTI_CDATA_WID = (HQMIOSF_TD_WIDTH + 1) ; 
    localparam HQMTI_DATA_MSB = (HQMTI_DATA_WID - 1) ; // Master Data Width
    localparam HQMTI_CDATA_MSB = (HQMTI_CDATA_WID - 1) ; // Target Completion Data Width
    // Some uniquified MPS based params
    localparam HQMTI_MAXMPS_BYTES = HQMIOSF_MSTR_MAX_PAYLOAD ; 
    localparam HQMTI_MAXMPS_BCNT_MSB = $clog2(HQMTI_MAXMPS_BYTES) ; // One bigger to handle MAX Values + 1
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
    localparam P_HDR_CREDITS = 8'h10 ; 
    localparam P_DATA_CREDITS = 8'h30 ; 
    localparam NP_HDR_CREDITS = 8'h08 ; 
    localparam NP_DATA_CREDITS = 8'h08 ; 
    localparam CPL_HDR_CREDITS = 8'h00 ; 
    localparam CPL_DATA_CREDITS = 8'h00 ; 
    // IOSF SB Opcodes
    localparam HQMEPSB_MRD = 8'h00 ; // Read Memory Mapped Register
    localparam HQMEPSB_MWR = 8'h01 ; // Write Memory Mapped Register
    localparam HQMEPSB_CFGRD = 8'h04 ; // Read PCI Config Register
    localparam HQMEPSB_CFGWR = 8'h05 ; // Write PCI Config Register
    localparam HQMEPSB_CRRD = 8'h06 ; // Read Private Control Register
    localparam HQMEPSB_CRWR = 8'h07 ; // Write Private Control Register
    localparam HQMEPSB_CPL = 8'h20 ; // Completion without Data
    localparam HQMEPSB_CPLD = 8'h21 ; // Completion with Data
    localparam HQMEPSB_ERR = 8'h49 ; // PCIe Error Message
    // Replacements
    localparam HQMEPSB_RSPREP = 8'h2A ; // About to Reset, warning from the PMU
    localparam HQMEPSB_RSPREPACK = 8'h2B ; // Acknowledgement of the the RSPREP MSG
    localparam HQMEPSB_FORCEPWRGATEPOK = 8'h2E ; // Allows an external requester to force an IP to deassert 
    // its POK or assert its pg_req signal.
    localparam HQMEPSB_FORCEPWRGATE_11 = 2'b11 ; // Type for force_ip_inaccessible
    localparam HQMEPSB_FORCEPWRGATE_01 = 2'b01 ; // Type for force_warm_reset
    localparam HQMEPSB_INTA_ASSERT = 8'h80 ; // Legacy Interrupt A Assert 
    localparam HQMEPSB_INTA_DEASSERT = 8'h84 ; // Legacy Interrupt A Deassert
    localparam HQMEPSB_OP_REGA_START = 8'h00 ; // First Register Access Opcode inclusive
    localparam HQMEPSB_OP_REGA_END = 8'h20 ; // Last  Register Access Opcode not inclusive
    localparam HQMEPSB_OP_COMU_START = 8'h28 ; // First Common Usage Opcode inclusive
    localparam HQMEPSB_OP_COMU_END = 8'h40 ; // Last  Common Usage Opcode not inclusive
    localparam HQMEPSB_OP_MSGD_START = 8'h40 ; // First Message with Data Opcode inclusive
    localparam HQMEPSB_OP_MSGD_END = 8'h80 ; // Last  Message with Data Opcode not inclusive
    localparam HQMEPSB_OP_SMSG_START = 8'h80 ; // First Simple Message Opcode inclusive
    localparam HQMEPSB_OP_SMSG_END = 8'hFF ; // Last  Simple Message Opcode not inclusive
    localparam HQMEPSB_MAX_TGT_ADR = 47 ; // Maximum address/data bits supported by the
    localparam HQMEPSB_MAX_TGT_DAT = 63 ; // master register access interface
    localparam HQMEPSB_MAX_TGT_BE = ((HQMEPSB_MAX_TGT_DAT == 31) ? 3 :
	7) ; // Mximum iwdth of the BE needed. 7:0 or 3:0.
    // Define the number of cycles to wait after all completions have been received
    localparam HQM_WAIT_BEFORE_CLK_GATE = 8 ; 
    // Defines the width of the data bus for the TLP
    localparam LLC_PACKET_DWIDTH = (HQMIOSF_TD_WIDTH + 1) ; 
    localparam RI_PDATA_WID = 256 ; 
    localparam RI_NPDATA_WID = 32 ; 
    // These exist to make collage happy...
    //  VPP_WIDTH should match HQM_SYSTEM_VPP_WIDTH in system/hqm_system_pkg.sv
    localparam VPP_WIDTH = 6 ; // based upon the larger of the 2 NUM_DIR_PP or NUM_LDB_PP in hqm_pkg.sv. 6 for NUM_DIR_PP 64
    localparam BITS_HCW_ENQ_IN_DATA_T = (((((16 + 5) + 4) + 2) + VPP_WIDTH) + 128) ; // ecc + control bits + cl + cli + vpp width + hcw width
    typedef enum logic [1:0] { PW = 'h0, SCH = 'h1, MSIX = 'h2, AI = 'h3} hqm_wbuf_src_t ; 
    // Process Address Space ID
    typedef struct packed {
        logic fmt2 ; 
        logic // fmt[2]
            pm_req ; 
        logic // Privileged mode requested
            exe_req ; 
        logic [(HQM_PASID_WIDTH - 1):0] // Execute requested
            pasid ; 
    } hqm_pasidtlp_t ; 
    // Traffic Class select
    typedef struct packed {
        logic par ; 
        logic [1:0] // parity on other fields
            add_par ; 
        logic // parity on add field
            invalid ; 
        logic [2:0] // Indicates the transaction should not be put on the link
            num_hcws ; 
        hqm_wbuf_src_t // Number of hcws for CQ writes
            src ; 
        logic // Posted write type
            cq_v ; 
        logic // CQ associated write
            cq_ldb ; 
        logic [5:0] // CQ associated with the write is load balanced
            cq ; 
        logic ro ; 
        hqm_pasidtlp_t // TLP relaxed ordering bit
            pasidtlp ; 
        logic // PASID fields
            len_par ; 
        logic [4:0] // parity on length field
            length ; 
        logic [63:2] // Length, in DWs
            add ; 
        logic [1:0] // Address
            tc_sel ; 
    } hqm_ph_t ; 
    typedef struct packed {
        logic [7:0] dpar ; 
        logic [255:0] data ; 
    } hqm_pd_t ; 
    typedef struct packed {
        hqm_ph_t hdr ; 
        hqm_pd_t data_ms ; 
        hqm_pd_t data_ls ; 
    } write_buffer_mstr_t ; 
    localparam BITS_WRITE_BUFFER_MSTR_T = $bits(write_buffer_mstr_t) ; 
    // Scoreboard and master LL parameters
    localparam HQM_MSTR_FL_DEPTH = 256 ; 
    localparam HQM_MSTR_FL_DEPTH_WIDTH = $clog2(HQM_MSTR_FL_DEPTH) ; 
    localparam HQM_MSTR_FL_CNT_WIDTH = $clog2((HQM_MSTR_FL_DEPTH + 1)) ; 
    localparam HQM_MSTR_DATA_WIDTH = (128 + 1) ; // data, parity
    localparam HQM_MSTR_HDR_WIDTH = (((128 + 1) + 1) + 23) ; // hdr, hdr_p, tlb, pasidtlp
    localparam HQM_MSTR_HPA_WIDTH = ((46 - 12) + 1) ; // hpa, hpa_p
    localparam HQM_MSTR_NUM_CQS = (NUM_DIR_CQ + NUM_LDB_CQ) ; 
    localparam HQM_MSTR_NUM_CQS_WIDTH = $clog2(HQM_MSTR_NUM_CQS) ; 
    localparam HQM_MSTR_NUM_LLS = (HQM_MSTR_NUM_CQS + 4) ; // 1 per CQ + P + NP + Cpl + Int
    localparam HQM_MSTR_NUM_LLS_WIDTH = $clog2(HQM_MSTR_NUM_LLS) ; 
    localparam HQM_MSTR_NUM_HPAS = (HQM_MSTR_NUM_CQS + 2) ; // 1 per CQ + P + NP
    localparam HQM_MSTR_NUM_HPAS_WIDTH = $clog2(HQM_MSTR_NUM_HPAS) ; 
    localparam HQM_SCRBD_DEPTH = 256 ; 
    localparam HQM_SCRBD_DEPTH_WIDTH = $clog2(HQM_SCRBD_DEPTH) ; 
    localparam HQM_SCRBD_CNT_WIDTH = $clog2((HQM_SCRBD_DEPTH + 1)) ; 
    localparam HQM_IBCPL_DATA_WIDTH = 64 ; // At most 2 DWs for ATS responses
    localparam HQM_IBCPL_PARITY_WIDTH = (HQM_IBCPL_DATA_WIDTH >> 5) ; // One parity bit per DW
    localparam HQM_IBCPL_DATA_FIFO_WIDTH = (HQM_IBCPL_DATA_WIDTH + HQM_IBCPL_PARITY_WIDTH) ; 
    localparam HQM_IOSF_REQ_CREDIT_WIDTH = 5 ; 
    //  7: 0 Tag (only 8b tag)
    typedef struct packed {
        logic parity ; 
        logic // 19    parity bit
            bad_len ; 
        logic // 18    bad length indication
            timeout ; 
        logic // 17    timeout indication
            poison ; 
        logic [2:0] // 16    poisoned indication
            status ; 
        logic [4:0] // 15:13 completion status
            length ; 
        logic [7:0] // 12: 8 completion length (max 16 DW)
            tag ; 
    } scrbd_cplhdr_t ; 
    typedef struct packed {
        logic parity ; 
        logic [1:0] src ; 
        logic [(HQM_MSTR_NUM_CQS_WIDTH - 1):0] id ; 
    } scrbd_data_t ; 
    typedef struct packed {
        logic re ; 
        logic [(HQM_SCRBD_DEPTH_WIDTH - 1):0] raddr ; 
        logic we ; 
        logic [(HQM_SCRBD_DEPTH_WIDTH - 1):0] waddr ; 
        scrbd_data_t wdata ; 
    } hqm_sif_memi_scrbd_mem_t ; 
    typedef struct packed {
        scrbd_data_t rdata ; 
    } hqm_sif_memo_scrbd_mem_t ; 
    typedef struct packed {
        logic re ; 
        logic [(HQM_SCRBD_DEPTH_WIDTH - 1):0] raddr ; 
        logic we ; 
        logic [(HQM_SCRBD_DEPTH_WIDTH - 1):0] waddr ; 
        scrbd_cplhdr_t wdata ; 
    } hqm_sif_memi_ibcpl_hdr_t ; 
    typedef struct packed {
        scrbd_cplhdr_t rdata ; 
    } hqm_sif_memo_ibcpl_hdr_t ; 
    typedef struct packed {
        logic re ; 
        logic [(HQM_SCRBD_DEPTH_WIDTH - 1):0] raddr ; 
        logic we ; 
        logic [(HQM_SCRBD_DEPTH_WIDTH - 1):0] waddr ; 
        logic [(HQM_IBCPL_DATA_FIFO_WIDTH - 1):0] wdata ; 
    } hqm_sif_memi_ibcpl_data_t ; 
    typedef struct packed {
        logic [(HQM_IBCPL_DATA_FIFO_WIDTH - 1):0] rdata ; 
    } hqm_sif_memo_ibcpl_data_t ; 
    typedef struct packed {
        logic re ; 
        logic [(HQM_MSTR_NUM_CQS_WIDTH - 1):0] raddr ; 
        logic we ; 
        logic [(HQM_MSTR_NUM_CQS_WIDTH - 1):0] waddr ; 
        logic [(HQM_MSTR_HPA_WIDTH - 1):0] wdata ; 
    } hqm_sif_memi_mstr_ll_hpa_t ; 
    typedef struct packed {
        logic [(HQM_MSTR_HPA_WIDTH - 1):0] rdata ; 
    } hqm_sif_memo_mstr_ll_hpa_t ; 
    typedef struct packed {
        logic re ; 
        logic [(HQM_MSTR_FL_DEPTH_WIDTH - 1):0] raddr ; 
        logic we ; 
        logic [(HQM_MSTR_FL_DEPTH_WIDTH - 1):0] waddr ; 
        logic [(HQM_MSTR_HDR_WIDTH - 1):0] wdata ; 
    } hqm_sif_memi_mstr_ll_hdr_t ; 
    typedef struct packed {
        logic [(HQM_MSTR_HDR_WIDTH - 1):0] rdata ; 
    } hqm_sif_memo_mstr_ll_hdr_t ; 
    typedef struct packed {
        logic re ; 
        logic [(HQM_MSTR_FL_DEPTH_WIDTH - 1):0] raddr ; 
        logic we ; 
        logic [(HQM_MSTR_FL_DEPTH_WIDTH - 1):0] waddr ; 
        logic [(HQM_MSTR_DATA_WIDTH - 1):0] wdata ; 
    } hqm_sif_memi_mstr_ll_data_t ; 
    typedef struct packed {
        logic [(HQM_MSTR_DATA_WIDTH - 1):0] rdata ; 
    } hqm_sif_memo_mstr_ll_data_t ; 
    // devtlb related - these should match the settings in the hqm_devtlb_params.vh file
    localparam HQM_TLB_MAX_LINEAR_AWIDTH = 57 ; 
    localparam HQM_TLB_MAX_HOST_AWIDTH = 46 ; 
    localparam HQM_TLB_NUM_WAYS = 8 ; 
    localparam HQM_TLB_NUM_4K = 128 ; // One per CQ
    localparam HQM_TLB_NUM_2M = 32 ; // One per VAS
    localparam HQM_TLB_NUM_1G = 32 ; // One per VAS
    localparam HQM_TLB_4K_DEPTH = (HQM_TLB_NUM_4K / HQM_TLB_NUM_WAYS) ; 
    localparam HQM_TLB_2M_DEPTH = (HQM_TLB_NUM_2M / HQM_TLB_NUM_WAYS) ; 
    localparam HQM_TLB_1G_DEPTH = (HQM_TLB_NUM_1G / HQM_TLB_NUM_WAYS) ; 
    localparam HQM_TLB_4K_ADDR_WIDTH = $clog2(HQM_TLB_4K_DEPTH) ; 
    localparam HQM_TLB_2M_ADDR_WIDTH = $clog2(HQM_TLB_2M_DEPTH) ; 
    localparam HQM_TLB_1G_ADDR_WIDTH = $clog2(HQM_TLB_1G_DEPTH) ; 
    localparam HQM_TLB_4K_DATA_WIDTH = (HQM_TLB_MAX_HOST_AWIDTH - 7) ; 
    localparam HQM_TLB_2M_DATA_WIDTH = (HQM_TLB_MAX_HOST_AWIDTH - 16) ; 
    localparam HQM_TLB_1G_DATA_WIDTH = (HQM_TLB_MAX_HOST_AWIDTH - 25) ; 
    localparam HQM_TLB_4K_TAG_WIDTH = (HQM_TLB_MAX_LINEAR_AWIDTH + 28) ; 
    localparam HQM_TLB_2M_TAG_WIDTH = (HQM_TLB_MAX_LINEAR_AWIDTH + 19) ; 
    localparam HQM_TLB_1G_TAG_WIDTH = (HQM_TLB_MAX_LINEAR_AWIDTH + 10) ; 
    localparam HQM_TLB_MISSTRK_DEPTH = 64 ; 
    localparam HQM_TLB_MISSTRK_DEPTH_WIDTH = $clog2(HQM_TLB_MISSTRK_DEPTH) ; 
    typedef struct packed {
        logic re ; 
        logic [(HQM_TLB_4K_ADDR_WIDTH - 1):0] raddr ; 
        logic we ; 
        logic [(HQM_TLB_4K_ADDR_WIDTH - 1):0] waddr ; 
        logic [(HQM_TLB_4K_DATA_WIDTH - 1):0] wdata ; 
    } hqm_sif_memi_tlb_data_4k_t ; 
    typedef struct packed {
        logic [(HQM_TLB_4K_DATA_WIDTH - 1):0] rdata ; 
    } hqm_sif_memo_tlb_data_4k_t ; 
    typedef struct packed {
        logic re ; 
        logic [(HQM_TLB_4K_ADDR_WIDTH - 1):0] raddr ; 
        logic we ; 
        logic [(HQM_TLB_4K_ADDR_WIDTH - 1):0] waddr ; 
        logic [(HQM_TLB_4K_TAG_WIDTH - 1):0] wdata ; 
    } hqm_sif_memi_tlb_tag_4k_t ; 
    typedef struct packed {
        logic [(HQM_TLB_4K_TAG_WIDTH - 1):0] rdata ; 
    } hqm_sif_memo_tlb_tag_4k_t ; 
    typedef struct packed {
        logic re ; 
        logic [(HQM_TLB_2M_ADDR_WIDTH - 1):0] raddr ; 
        logic we ; 
        logic [(HQM_TLB_2M_ADDR_WIDTH - 1):0] waddr ; 
        logic [(HQM_TLB_2M_DATA_WIDTH - 1):0] wdata ; 
    } hqm_sif_memi_tlb_data_2m_t ; 
    typedef struct packed {
        logic [(HQM_TLB_2M_DATA_WIDTH - 1):0] rdata ; 
    } hqm_sif_memo_tlb_data_2m_t ; 
    typedef struct packed {
        logic re ; 
        logic [(HQM_TLB_2M_ADDR_WIDTH - 1):0] raddr ; 
        logic we ; 
        logic [(HQM_TLB_2M_ADDR_WIDTH - 1):0] waddr ; 
        logic [(HQM_TLB_2M_TAG_WIDTH - 1):0] wdata ; 
    } hqm_sif_memi_tlb_tag_2m_t ; 
    typedef struct packed {
        logic [(HQM_TLB_2M_TAG_WIDTH - 1):0] rdata ; 
    } hqm_sif_memo_tlb_tag_2m_t ; 
    typedef struct packed {
        logic re ; 
        logic [(HQM_TLB_1G_ADDR_WIDTH - 1):0] raddr ; 
        logic we ; 
        logic [(HQM_TLB_1G_ADDR_WIDTH - 1):0] waddr ; 
        logic [(HQM_TLB_1G_DATA_WIDTH - 1):0] wdata ; 
    } hqm_sif_memi_tlb_data_1g_t ; 
    typedef struct packed {
        logic [(HQM_TLB_1G_DATA_WIDTH - 1):0] rdata ; 
    } hqm_sif_memo_tlb_data_1g_t ; 
    typedef struct packed {
        logic re ; 
        logic [(HQM_TLB_1G_ADDR_WIDTH - 1):0] raddr ; 
        logic we ; 
        logic [(HQM_TLB_1G_ADDR_WIDTH - 1):0] waddr ; 
        logic [(HQM_TLB_1G_TAG_WIDTH - 1):0] wdata ; 
    } hqm_sif_memi_tlb_tag_1g_t ; 
    typedef struct packed {
        logic [(HQM_TLB_1G_TAG_WIDTH - 1):0] rdata ; 
    } hqm_sif_memo_tlb_tag_1g_t ; 
    typedef struct packed {
        logic [1:0] pasid_valid ; 
        logic [1:0] pasid_priv ; 
        logic [1:0][(HQM_PASID_WIDTH - 1):0] pasid ; 
        logic [1:0][(HQM_TLB_MISSTRK_DEPTH_WIDTH - 1):0] id ; 
        logic [1:0][2:0] tc ; 
        logic [1:0] nw ; 
        logic [1:0][15:0] bdf ; 
        logic [1:0][(HQM_TLB_MAX_LINEAR_AWIDTH - 1):12] address ; 
    } hqm_devtlb_ats_req_t ; 
    typedef struct packed {
        logic [(HQM_TLB_MISSTRK_DEPTH_WIDTH - 1):0] id ; 
        logic dperror ; 
        logic hdrerror ; 
        logic [63:0] data ; 
    } hqm_devtlb_ats_rsp_t ; 
    typedef struct packed {
        logic pasid_valid ; 
        logic pasid_priv ; 
        logic [(HQM_PASID_WIDTH - 1):0] pasid ; 
        logic opcode ; 
        logic dperror ; 
        logic [4:0] invreq_itag ; 
        logic [15:0] invreq_reqid ; 
        logic [31:0] dw2 ; 
        logic [63:0] data ; 
    } hqm_devtlb_rx_msg_t ; 
    typedef struct packed {
        logic pasid_valid ; 
        logic pasid_priv ; 
        logic [(HQM_PASID_WIDTH - 1):0] pasid ; 
        logic opcode ; 
        logic [2:0] tc ; 
        logic [15:0] bdf ; 
        logic [31:0] dw2 ; 
        logic [31:0] dw3 ; 
    } hqm_devtlb_tx_msg_t ; 
    // Address that needs to be translated.
    typedef struct packed {
        logic pasid_valid ; 
        logic pasid_priv ; 
        logic [(HQM_PASID_WIDTH - 1):0] pasid ; 
        logic [(HQM_MSTR_NUM_CQS_WIDTH - 1):0] id ; 
        logic [0:0] // Transaction ID = CQ
            tlbid ; 
        logic // TLBid
            ppriority ; 
        logic // request priority
            prs ; 
        logic [1:0] opcode ; 
        logic [2:0] // Customer intended use for translated address
            tc ; 
        logic [15:0] // Transaction's Traffic class 
            bdf ; 
        logic [(HQM_TLB_MAX_LINEAR_AWIDTH - 1):12] address ; 
    } hqm_devtlb_req_t ; 
    // Translated Address
    typedef struct packed {
        logic result ; 
        logic // Response status: 1=success (translated); 0=failure.
            dperror ; 
        logic // data parity error was seen as part of translation request
            hdrerror ; 
        logic // a header error was seen as part of ATS request (e.g. UR, CA, CTO, etc).  
            nonsnooped ; 
        logic [1:0] // 1 if the translated address should be accessed with non-snoop cycle.
            prs_code ; 
        logic [(HQM_MSTR_NUM_CQS_WIDTH - 1):0] id ; 
        logic [(HQM_TLB_MAX_HOST_AWIDTH - 1):12] // Transaction ID 
            address ; 
    } hqm_devtlb_rsp_t ; 
    typedef struct packed {
        logic pasid_valid ; 
        logic pasid_priv ; 
        logic [(HQM_PASID_WIDTH - 1):0] pasid ; 
        logic pasid_global ; 
        logic [15:0] bdf ; 
    } hqm_devtlb_drain_req_t ; 
    // Traffic Class (bitwise) used by the hosting unit for all transaction.
    typedef struct packed {
        logic [7:0] tc ; 
    } hqm_devtlb_drain_rsp_t ; 
    // Parameters for the Memory, iosf_pdata_rxq, originally located in hqm_iosf_rxq.sv
    localparam HQM_SIF_PDATA_RXQ_AMSB = 5 ; 
    localparam HQM_SIF_PDATA_RXQ_DMSB = 263 ; 
    // Parameters for the Memory, iosf_cpldata_rxq, originally located in hqm_iosf_rxq.sv
    localparam HQM_SIF_CPLDATA_RXQ_AMSB = 2 ; 
    localparam HQM_SIF_CPLDATA_RXQ_DMSB = 32 ; 
    // Parameters for the Memory, i_fifo_phdr,   originally located in ri/ri_tlq.sv
    localparam HQM_SIF_FIFO_PHDR_AMSB = 3 ; 
    localparam HQM_SIF_FIFO_PHDR_DMSB = 152 ; 
    // Parameters for the Memory, i_fifo_pdata, originally located in ri/ri_tlq.sv
    localparam HQM_SIF_FIFO_PDATA_AMSB = 4 ; 
    localparam HQM_SIF_FIFO_PDATA_DMSB = 263 ; 
    // Parameters for the Memory, i_fifo_nphdr, originally located in ri/ri_tlq.sv
    localparam HQM_SIF_FIFO_NPHDR_AMSB = 2 ; 
    localparam HQM_SIF_FIFO_NPHDR_DMSB = 157 ; 
    // Parameters for the Memory, i_fifo_npdata, originally located in ri/ri_tlq.sv
    localparam HQM_SIF_FIFO_NPDATA_AMSB = 2 ; 
    localparam HQM_SIF_FIFO_NPDATA_DMSB = 32 ; 
    // Parameters for the Memory, i_fifo_cplhdr, originally located in ri/ri_tlq.sv
    localparam HQM_SIF_FIFO_CPLHDR_AMSB = 2 ; 
    localparam HQM_SIF_FIFO_CPLHDR_DMSB = 53 ; 
    // Parameters for the Memory, i_fifo_cpldata, originally located in ri/ri_tlq.sv
    localparam HQM_SIF_FIFO_CPLDATA_AMSB = 3 ; 
    localparam HQM_SIF_FIFO_CPLDATA_DMSB = 263 ; 
    // Parameters for the Memory, i_ph_fifo, originally located in ti/ti_trn.sv
    localparam HQM_SIF_PH_FIFO_AMSB = 5 ; 
    localparam HQM_SIF_PH_FIFO_DMSB = 109 ; 
    // Parameters for the Memory, i_pd_fifo, originally located in ti/ti_trn.sv
    localparam HQM_SIF_PD_FIFO_AMSB = 5 ; 
    localparam HQM_SIF_PD_FIFO_DMSB = 264 ; 
    localparam HQM_SIF_PH_REQ_FIFO_AMSB = 3 ; 
    localparam HQM_SIF_PH_REQ_FIFO_DMSB = 152 ; 
    // Input structure for the Memory, iosf_pdata_rxq, originally located in hqm_iosf_rxq.sv
    typedef struct packed {
        logic [HQM_SIF_PDATA_RXQ_AMSB:0] waddr ; 
        logic we ; 
        logic [HQM_SIF_PDATA_RXQ_DMSB:0] wdata ; 
        logic [HQM_SIF_PDATA_RXQ_AMSB:0] raddr ; 
        logic re ; 
    } hqm_sif_memi_iosf_pdata_rxq_t ; 
    // Output structure for the Memory, iosf_pdata_rxq, originally located in hqm_iosf_rxq.sv
    typedef struct packed {
        logic [HQM_SIF_PDATA_RXQ_DMSB:0] rdata ; 
    } hqm_sif_memo_iosf_pdata_rxq_t ; 
    // Input structure for the Memory, iosf_cpldata_rxq, originally located in hqm_iosf_rxq.sv
    typedef struct packed {
        logic [HQM_SIF_CPLDATA_RXQ_AMSB:0] waddr ; 
        logic we ; 
        logic [HQM_SIF_CPLDATA_RXQ_DMSB:0] wdata ; 
        logic [HQM_SIF_CPLDATA_RXQ_AMSB:0] raddr ; 
        logic re ; 
    } hqm_sif_memi_iosf_cpldata_rxq_t ; 
    // Output structure for the Memory, iosf_cpldata_rxq, originally located in hqm_iosf_rxq.sv
    typedef struct packed {
        logic [HQM_SIF_CPLDATA_RXQ_DMSB:0] rdata ; 
    } hqm_sif_memo_iosf_cpldata_rxq_t ; 
    // Input structure for the Memory, i_fifo_phdr,   originally located in ri/ri_tlq.sv
    typedef struct packed {
        logic [HQM_SIF_FIFO_PHDR_AMSB:0] waddr ; 
        logic we ; 
        logic [HQM_SIF_FIFO_PHDR_DMSB:0] wdata ; 
        logic [HQM_SIF_FIFO_PHDR_AMSB:0] raddr ; 
        logic re ; 
    } hqm_sif_memi_fifo_phdr_t ; 
    // Output structure for the Memory, i_fifo_phdr,   originally located in ri/ri_tlq.sv
    typedef struct packed {
        logic [HQM_SIF_FIFO_PHDR_DMSB:0] rdata ; 
    } hqm_sif_memo_fifo_phdr_t ; 
    // Input structure for the Memory, i_fifo_pdata, originally located in ri/ri_tlq.sv
    typedef struct packed {
        logic [HQM_SIF_FIFO_PDATA_AMSB:0] waddr ; 
        logic we ; 
        logic [HQM_SIF_FIFO_PDATA_DMSB:0] wdata ; 
        logic [HQM_SIF_FIFO_PDATA_AMSB:0] raddr ; 
        logic re ; 
    } hqm_sif_memi_fifo_pdata_t ; 
    // Output structure for the Memory, i_fifo_pdata, originally located in ri/ri_tlq.sv
    typedef struct packed {
        logic [HQM_SIF_FIFO_PDATA_DMSB:0] rdata ; 
    } hqm_sif_memo_fifo_pdata_t ; 
    // Input structure for the Memory, i_fifo_nphdr, originally located in ri/ri_tlq.sv
    typedef struct packed {
        logic [HQM_SIF_FIFO_NPHDR_AMSB:0] waddr ; 
        logic we ; 
        logic [HQM_SIF_FIFO_NPHDR_DMSB:0] wdata ; 
        logic [HQM_SIF_FIFO_NPHDR_AMSB:0] raddr ; 
        logic re ; 
    } hqm_sif_memi_fifo_nphdr_t ; 
    // Output structure for the Memory, i_fifo_nphdr, originally located in ri/ri_tlq.sv
    typedef struct packed {
        logic [HQM_SIF_FIFO_NPHDR_DMSB:0] rdata ; 
    } hqm_sif_memo_fifo_nphdr_t ; 
    // Input structure for the Memory, i_fifo_npdata, originally located in ri/ri_tlq.sv
    typedef struct packed {
        logic [HQM_SIF_FIFO_NPDATA_AMSB:0] waddr ; 
        logic we ; 
        logic [HQM_SIF_FIFO_NPDATA_DMSB:0] wdata ; 
        logic [HQM_SIF_FIFO_NPDATA_AMSB:0] raddr ; 
        logic re ; 
    } hqm_sif_memi_fifo_npdata_t ; 
    // Output structure for the Memory, i_fifo_npdata, originally located in ri/ri_tlq.sv
    typedef struct packed {
        logic [HQM_SIF_FIFO_NPDATA_DMSB:0] rdata ; 
    } hqm_sif_memo_fifo_npdata_t ; 
    // Input structure for the Memory, i_ph_fifo, originally located in ti/ti_trn.sv
    typedef struct packed {
        logic [HQM_SIF_PH_FIFO_AMSB:0] waddr ; 
        logic we ; 
        logic [HQM_SIF_PH_FIFO_DMSB:0] wdata ; 
        logic [HQM_SIF_PH_FIFO_AMSB:0] raddr ; 
        logic re ; 
    } hqm_sif_memi_ph_fifo_t ; 
    // Output structure for the Memory, i_ph_fifo, originally located in ti/ti_trn.sv
    typedef struct packed {
        logic [HQM_SIF_PH_FIFO_DMSB:0] rdata ; 
    } hqm_sif_memo_ph_fifo_t ; 
    // Input structure for the Memory, i_pd_fifo, originally located in ti/ti_trn.sv
    typedef struct packed {
        logic [HQM_SIF_PD_FIFO_AMSB:0] waddr ; 
        logic we ; 
        logic [HQM_SIF_PD_FIFO_DMSB:0] wdata ; 
        logic [HQM_SIF_PD_FIFO_AMSB:0] raddr ; 
        logic re ; 
    } hqm_sif_memi_pd_fifo_t ; 
    // Output structure for the Memory, i_pd_fifo, originally located in ti/ti_trn.sv
    typedef struct packed {
        logic [HQM_SIF_PD_FIFO_DMSB:0] rdata ; 
    } hqm_sif_memo_pd_fifo_t ; 
    typedef struct packed {
        logic [HQM_SIF_PH_REQ_FIFO_AMSB:0] waddr ; 
        logic we ; 
        logic [HQM_SIF_PH_REQ_FIFO_DMSB:0] wdata ; 
        logic [HQM_SIF_PH_REQ_FIFO_AMSB:0] raddr ; 
        logic re ; 
    } hqm_sif_memi_ph_req_fifo_t ; 
    typedef struct packed {
        logic [HQM_SIF_PH_REQ_FIFO_DMSB:0] rdata ; 
    } hqm_sif_memo_ph_req_fifo_t ; 
    //  15:  0   //  15:  0
    typedef struct packed {
        logic flr_cmp_sent ; 
        logic // 679
            flr_triggered_wl ; 
        logic // 678
            flr_clk_enable ; 
        logic // 677
            flr_clk_enable_system ; 
        logic // 676
            prim_clk_enable_cdc ; 
        logic // 675
            flr_triggered ; 
        logic // 674
            ps_d0_to_d3 ; 
        logic // 673
            flr_function0 ; 
        logic // 672
            flr_treatment ; 
        logic // 671
            flr_pending ; 
        logic // 670
            bme_or_mem_wr ; 
        logic // 669
            ps_txn_sent_q ; 
        logic // 668
            ps_cmp_sent_q ; 
        logic // 667
            ps_cmp_sent_ack ; 
        logic // 666
            flr_txn_sent_q ; 
        logic // 665
            flr_cmp_sent_q ; 
        logic // 664
            flr ; 
        logic // 663
            pf0_fsm_rst ; 
        logic [1:0] // 662
            ps ; 
        logic // 661:660
            sw_trigger ; 
        logic // 659
            prim_gated_rst_b_sync ; 
        logic // 658
            prim_clk_enable ; 
        logic // 657
            prim_clk_enable_sys ; 
        logic // 656
            prim_clkreq_sync ; 
        logic // 655
            prim_clkack_sync ; 
        logic // 654
            hqm_idle_q ; 
        logic // 653
            sys_mstr_idle ; 
        logic // 652
            sys_tgt_idle ; 
        logic // 651
            sys_ri_idle ; 
        logic // 650
            sys_ti_idle ; 
        logic // 649
            sys_cfgm_idle ; 
        logic [2:0] // 648
            iosf_tgt_dec_bits ; 
        logic [3:0] // 647:645   //  31: 29    //  23: 21
            iosf_tgt_dec_type ; 
        logic // 644:641   //  28: 25    //  20: 17
            iosf_tgt_idle ; 
        logic [1:0] // 640       //  24        //  16
            iosf_tgt_cput_cmd_rtype ; 
        logic // 639:638   //  23: 22    //  15: 14
            iosf_tgt_cput_cmd_put ; 
        logic [1:0] // 637       //  21        //  13
            iosf_tgt_cmd_tfmt ; 
        logic // 636:635   //  20: 19    //  12: 11
            iosf_tgt_has_data ; 
        logic [9:0] // 634       //  18        //  10
            iosf_tgt_data_count_ff ; 
        logic // 633:624   //  17:  8    //   9:  0
            iosf_tgt_crdtinit_in_progress ; 
        logic // 623       //   7
            iosf_tgt_rst_complete ; 
        logic // 622       //   6
            iosf_tgt_credit_init ; 
        logic // 621       //   5
            iosf_tgt_zero ; 
        logic [3:0] // 620       //   4
            iosf_tgt_port_present ; 
        logic [31:0] // 619:616   //   3:  0
            mstr_iosf_cmd_caddress_31_0 ; 
        logic [3:0] // 615:584   // 135:104
            mstr_iosf_cmd_clbe ; 
        logic [3:0] // 583:580   // 103:100
            mstr_iosf_cmd_cfbe ; 
        logic [7:0] // 579:576   //  99: 96
            mstr_iosf_cmd_ctag ; 
        logic [15:0] // 575:568   //  95: 88
            mstr_iosf_cmd_crqid ; 
        logic [7:0] // 567:552   //  87: 72
            mstr_iosf_cmd_clength_7_0 ; 
        logic // 551:544   //  71: 64
            mstr_iosf_cmd_cth ; 
        logic // 543       //  63
            mstr_iosf_cmd_cep ; 
        logic // 542       //  62
            mstr_iosf_cmd_cro ; 
        logic // 541       //  61
            mstr_iosf_cmd_cns ; 
        logic // 540       //  60
            mstr_iosf_cmd_cido ; 
        logic [1:0] // 539       //  59
            mstr_iosf_cmd_cat ; 
        logic // 538:537   //  58: 57
            mstr_iosf_cmd_ctd ; 
        logic // 536       //  56
            mstr_iosf_gnt_q_gnt2 ; 
        logic [1:0] // 535       //  55
            mstr_iosf_cmd_cfmt ; 
        logic [4:0] // 534:533   //  54: 53
            mstr_iosf_cmd_ctype ; 
        logic [2:0] // 532:528   //  52: 48
            mstr_iosf_req_dlen_4_2 ; 
        logic [4:0] // 527:525   //  47: 45
            mstr_iosf_req_credits_cpl ; 
        logic [1:0] // 524:520   //  44: 40
            mstr_iosf_req_dlen_1_0 ; 
        logic // 519:518   //  39: 38
            mstr_data_out_valid_q ; 
        logic [4:0] // 517       //  37
            mstr_iosf_req_credits_p ; 
        logic // 516:512   //  36: 32
            mstr_idle ; 
        logic [1:0] // 511       //  31
            mstr_hfifo_data_fmt ; 
        logic [4:0] // 510:509   //  30: 29
            mstr_hfifo_data_type ; 
        logic [1:0] // 508:504   //  28: 24
            mstr_rxq_hdr_avail ; 
        logic [1:0] // 503:502   //  23: 22
            mstr_iosf_gnt_q_dec ; 
        logic [1:0] // 501:500   //  21: 20
            mstr_req_fifo_empty ; 
        logic [1:0] // 499:498   //  19: 18
            mstr_req_fifo_fully ; 
        logic [2:0] // 497:496   //  17: 16
            mstr_prim_ism_agent ; 
        logic // 495:493   //  15: 13
            mstr_dfifo_rd_gt4dw ; 
        logic [1:0] // 492       //  12
            mstr_dfifo_rd ; 
        logic [1:0] // 491:490   //  11: 10
            mstr_hfifo_rd ; 
        logic [1:0] // 489:488   //   9:  8
            mstr_iosf_gnt_q_gtype ; 
        logic [1:0] // 487:486   //   7:  6
            mstr_iosf_gnt_q_rtype ; 
        logic // 485:484   //   5:  4
            mstr_iosf_gnt_q_gnt ; 
        logic [1:0] // 483       //   3
            mstr_iosf_req_rtype ; 
        logic // 482:481   //   2:  1
            mstr_iosf_req_put ; 
        logic // 480       //   0
            mstr_iosfp_ti_rxq_rdy ; 
        logic // 479       //  55
            mstr_iosfp_ri_rxq_rsprepack_vote_ri ; 
        logic // 478       //  54
            mstr_iosf_ep_poison_wr_sent_rl ; 
        logic [4:0] // 477       //  53
            mstr_iosf_ep_poison_wr_func_rxl ; 
        logic // 476:472   //  52: 48
            rxq_ti_rsprepack_vote_rp_q ; 
        logic // 471       //  47
            rxq_ri_iosfp_quiesce_rp ; 
        logic // 470       //  46
            cplhdr_rxq_fifo_perr_q ; 
        logic // 469       //  45
            ioq_rxq_fifo_pop ; 
        logic // 468       //  44
            phdr_rxq_fifo_pop ; 
        logic // 467       //  43
            pdata_rxq_fifo_pop ; 
        logic // 466       //  42
            cplhdr_rxq_fifo_pop ; 
        logic // 465       //  41
            cpldata_rxq_fifo_pop ; 
        logic // 464       //  40
            rxq_ti_iosfp_ifc_wxi_stp ; 
        logic // 463       //  39
            rxq_ti_iosfp_ifc_wxi_endp ; 
        logic // 462       //  38
            phdr_rxq_fifo_perr_q ; 
        logic // 461       //  37
            ioq_rxq_fifo_push ; 
        logic // 460       //  36
            phdr_rxq_fifo_push ; 
        logic // 459       //  35
            pdata_rxq_fifo_push ; 
        logic // 458       //  34
            cplhdr_rxq_fifo_push ; 
        logic // 457       //  33
            cpldata_rxq_fifo_push ; 
        logic [7:0] // 456       //  32
            rxq_ti_pciemhdr_tag ; 
        logic [7:0] // 455:448   //  31: 24
            rxq_ti_pciemhdr_rid_7_0 ; 
        logic [7:0] // 447:440   //  23: 16
            rxq_ti_pciemhdr_length_7_0 ; 
        logic // 439:432   //  15:  8
            rxq_ti_iosfp_push_wi ; 
        logic [6:0] // 431       //   7
            rxq_pcie_cmd ; 
        logic // 430:424   //   6:  0
            tlq_idle_q2 ; 
        logic // 423       //  31
            tlq_lli_cpar_err_wp ; 
        logic // 422       //  30
            tlq_lli_tecrc_err_wp ; 
        logic // 421       //  29
            tlq_cds_pd_rd_wp2 ; 
        logic // 420       //  28
            tlq_ri_crdinc_wl_pd ; 
        logic // 419       //  27
            tlq_iosf_ep_poison_wr_sent_rp ; 
        logic // 418       //  26
            tlq_cto_ec_err_wxp_or ; 
        logic // 417       //  25
            tlq_cto_ec_ud_fnc_wp ; 
        logic // 416       //  24
            tlq_phdr_val ; 
        logic // 415       //  23
            tlq_cds_phdr_rd_wp ; 
        logic // 414       //  22
            tlq_phdrval_wp ; 
        logic // 413       //  21
            tlq_phdr_fifo_full ; 
        logic // 412       //  20
            tlq_pdata_push ; 
        logic // 411       //  19
            tlq_cds_pd_rd_wp ; 
        logic // 410       //  18
            tlq_tlq_pdataval_wp ; 
        logic // 409       //  17
            tlq_pdata_fifo_full ; 
        logic // 408       //  16
            tlq_nphdr_val ; 
        logic // 407       //  15
            tlq_cds_nphdr_rd_wp ; 
        logic // 406       //  14
            tlq_nphdrval_wp ; 
        logic // 405       //  13
            tlq_nphdr_fifo_full ; 
        logic // 404       //  12
            tlq_npdata_push ; 
        logic // 403       //  11
            tlq_cds_npd_rd_wp ; 
        logic // 402       //  10
            tlq_npdataval_wp ; 
        logic // 401       //   9
            tlq_npdata_fifo_full ; 
        logic // 400       //   8
            tlq_idle_q ; 
        logic // 399       //   7
            tlq_ioq_fifo_full ; 
        logic // 398       //   6
            tlq_ioq_hdr_push_in ; 
        logic // 397       //   5
            tlq_ioq_pop ; 
        logic // 396       //   4
            tlq_ioqval_wp ; 
        logic [2:0] // 395       //   3
            tlq_ioq_data_rxp ; 
        logic [1:0] // 394:392   //   2:  0
            obc_zero ; 
        logic // 391:390   //  63: 62
            obc_ri_obcmpl_req_rl ; 
        logic // 389       //  61
            obc_ri_obcmpl_hdr_rxl_ep ; 
        logic [2:0] // 388       //  60
            obc_ri_obcmpl_hdr_rxl_tc ; 
        logic // 387:385   //  59: 57
            obc_ri_obcmpl_hdr_rxl_fmt ; 
        logic [2:0] // 384       //  56
            obc_ri_obcmpl_hdr_rxl_cs ; 
        logic [4:0] // 383:381   //  55: 53
            obc_ri_obcmpl_hdr_rxl_addr_6_2 ; 
        logic [7:0] // 380:376   //  52: 48
            obc_ri_obcmpl_hdr_rxl_length_7_0 ; 
        logic [15:0] // 375:368   //  47: 40
            obc_ri_obcmpl_hdr_rxl_rid ; 
        logic [7:0] // 367:352   //  39: 24
            obc_ri_obcmpl_hdr_rxl_tag ; 
        logic // 351:344   //  23: 16
            obc_hdr_full_wp ; 
        logic // 343       //  15
            obc_cds_obchdr_rdy_wp3 ; 
        logic // 342       //  14
            obc_ti_obcmpl_ack_rl ; 
        logic // 341       //  13
            obc_pend_sig_dval2 ; 
        logic // 340       //  12
            obc_cds_obchdr_rdy_wp2 ; 
        logic // 339       //  11
            obc_int_sig_gnt ; 
        logic // 338       //  10
            obc_int_sig_dval ; 
        logic // 337       //   9
            obc_int_sig_num_fifo_full ; 
        logic // 336       //   8
            obc_pend_sig_push ; 
        logic // 335       //   7
            obc_pend_sig_fifo_pop ; 
        logic // 334       //   6
            obc_pend_sig_dval ; 
        logic // 333       //   5
            obc_pend_sig_fifo_full ; 
        logic // 332       //   4
            obc_cds_obchdr_rdy_wp ; 
        logic // 331       //   3
            obc_dequeue_csr_cpl ; 
        logic // 330       //   2
            obc_cur_csr_data_val ; 
        logic // 329       //   1
            obc_csr_data_fifo_full ; 
        logic // 328       //   0
            csr_ext_mmio_ack_sai_successfull ; 
        logic // 327       // 111
            csr_ext_mmio_ack_read_miss ; 
        logic // 326       // 110
            csr_ext_mmio_ack_write_miss ; 
        logic // 325       // 109
            csr_ext_mmio_ack_read_valid ; 
        logic // 324       // 108
            csr_ext_mmio_ack_write_valid ; 
        logic // 323       // 107
            csr_ext_mmio_req_valid ; 
        logic // 322       // 106
            csr_ext_mmio_req_opcode_0 ; 
        logic // 321       // 105
            csr_ext_mmio_req_data_0 ; 
        logic // 320       // 104
            csr_int_mmio_ack_sai_successfull ; 
        logic // 319       // 103
            csr_int_mmio_ack_read_miss ; 
        logic // 318       // 102
            csr_int_mmio_ack_write_miss ; 
        logic // 317       // 101
            csr_int_mmio_ack_read_valid ; 
        logic // 316       // 100
            csr_int_mmio_ack_write_valid ; 
        logic // 315       //  99 
            csr_int_mmio_req_valid ; 
        logic // 314       //  98 
            csr_int_mmio_req_opcode_0 ; 
        logic // 313       //  97 
            csr_int_mmio_req_data_0 ; 
        logic // 312       //  96 
            csr_pf0_ack_sai_successfull ; 
        logic // 311       //  95
            csr_pf0_ack_read_miss ; 
        logic // 310       //  94
            csr_pf0_ack_write_miss ; 
        logic // 309       //  93
            csr_pf0_ack_read_valid ; 
        logic // 308       //  92
            csr_pf0_ack_write_valid ; 
        logic // 307       //  91
            csr_pf0_req_valid ; 
        logic // 306       //  90
            csr_pf0_req_opcode_0 ; 
        logic // 305       //  89
            csr_pf0_req_data_0 ; 
        logic [3:0] // 304       //  88
            csr_req_q_csr_wr_offset_11_8 ; 
        logic [3:0] // 303:300   //  87: 84
            csr_req_q_csr_rd_offset_11_8 ; 
        logic [7:0] // 299:296   //  83: 80
            csr_req_q_csr_wr_offset_7_0 ; 
        logic [7:0] // 295:288   //  79: 72
            csr_req_q_csr_rd_offset_7_0 ; 
        logic [31:0] // 287:280   //  71: 64
            csr_req_q_csr_mem_mapped_offset ; 
        logic // 279:248   //  63: 32
            csr_req_q_csr_mem_mapped ; 
        logic // 247       //  31
            csr_req_q_csr_ext_mem_mapped ; 
        logic // 246       //  30
            csr_req_q_csr_func_pf_mem_mapped ; 
        logic // 245       //  29
            csr_req_q_csr_func_vf_mem_mapped ; 
        logic [3:0] // 244       //  28
            csr_req_q_csr_func_vf_num ; 
        logic // 243:240   //  27: 24
            csr_read_q ; 
        logic // 239       //  23
            csr_rd_stall ; 
        logic // 238       //  22
            csr_ppmcsr_wr_stall ; 
        logic [4:0] // 237       //  21
            csr_req_q_csr_rd_func ; 
        logic // 236:232   //  20: 16
            csr_wr_q ; 
        logic // 231       //  15
            csr_wr_stall ; 
        logic // 230       //  14
            csr_req_q_csr_byte_en_0 ; 
        logic [4:0] // 229       //  13
            csr_req_q_csr_wr_func ; 
        logic [7:0] // 228:224   //  12:  8
            csr_req_q_csr_sai ; 
        logic // 223:216   //   7:  0
            cds_cbd_func_pf_bar_hit_0 ; 
        logic // 215       //  47   
            cds_cbd_func_vf_bar_hit_0 ; 
        logic [1:0] // 214       //  46   
            cds_cbd_func_pf_rgn_hit ; 
        logic [1:0] // 213:212   //  45: 44
            cds_cbd_csr_pf_rgn_hit ; 
        logic [1:0] // 211:210   //  43: 42
            cds_cbd_func_vf_rgn_hit ; 
        logic // 209:208   //  41: 40
            cds_csr_rd_ur ; 
        logic // 207       //  39   
            cds_csr_rd_sai_error ; 
        logic // 206       //  38   
            cds_csr_rd_timeout_error ; 
        logic // 205       //  37   
            cds_mmio_wr_sai_error ; 
        logic // 204       //  36   
            cds_mmio_wr_sai_ok ; 
        logic // 203       //  35   
            cds_cfg_wr_ur ; 
        logic // 202       //  34   
            cds_cfg_wr_sai_error ; 
        logic // 201       //  33   
            cds_cfg_wr_sai_ok ; 
        logic // 200       //  32   
            cds_cbd_csr_pf_bar_hit ; 
        logic // 199       //  31
            cds_tlq_cds_phdr_par_err ; 
        logic // 198       //  30
            cds_tlq_cds_pdata_par_err ; 
        logic // 197       //  29
            cds_tlq_cds_nphdr_par_err ; 
        logic // 196       //  28
            cds_tlq_cds_npdata_par_err ; 
        logic // 195       //  27
            cds_err_msg_gnt ; 
        logic // 194       //  26
            cds_malform_pkt ; 
        logic // 193       //  25
            cds_npusr_err_wp ; 
        logic // 192       //  24
            cds_usr_in_cpl ; 
        logic // 191       //  23
            cds_pusr_err_wp ; 
        logic // 190       //  22
            cds_cfg_usr_func ; 
        logic // 189       //  21
            cds_ca_err_wp ; 
        logic // 188       //  20
            cds_poison_err_wp ; 
        logic // 187       //  19
            cds_bar_decode_err_wp ; 
        logic // 186       //  18
            cds_tlq_phdrval_wp ; 
        logic // 185       //  17
            cds_tlq_nphdrval_wp ; 
        logic // 184       //  16
            cds_tlq_pdataval_wp ; 
        logic // 183       //  15
            cds_tlq_npdataval_wp ; 
        logic // 182       //  14
            cds_tlq_ioqval_wp_1 ; 
        logic // 181       //  13
            cds_phdr_rd_wp ; 
        logic // 180       //  12
            cds_nphdr_rd_wp ; 
        logic // 179       //  11
            cds_npd_rd_wp ; 
        logic // 178       //  10
            cds_pd_rd_wp ; 
        logic // 177       //   9
            cds_addr_val ; 
        logic [6:2] // 176       //   8
            cds_addr_6_2 ; 
        logic // 175:171   //   7:  3  
            cds_cbd_decode_val_0 ; 
        logic // 170       //   2    
            cds_mem_hit_csr_pf_rgn ; 
        logic // 169       //   1    
            cds_cbd_rdy ; 
        logic // 168       //   0    
            ri_idle_q ; 
        logic // 167 
            csr_pasid_enable ; 
        logic // 166       // 166
            reqsrv_send_msg ; 
        logic // 165       // 165
            ri_iosfp_quiesce_rp ; 
        logic // 164       // 164
            ti_rsprepack_vote_rp ; 
        logic // 163       // 163
            ti_iosfp_push_wl ; 
        logic // 162       // 162
            ti_idle_q ; 
        logic // 161       // 161
            ph_trigger ; 
        logic // 160       // 160
            phdr_rxl_pasidtlp_22 ; 
        logic [5:0] // 159       // 159
            phdr_rxl_pasidtlp_5_0 ; 
        logic // 158:153   // 158:153
            pdata_fifo_pop_data_4 ; 
        logic [3:0] // 152       // 152
            pdata_fifo_pop_data_3_0 ; 
        logic [3:0] // 151:148   // 151:148
            trn_msi_vf ; 
        logic // 147:144   // 147:144
            trn_msi_write ; 
        logic // 143       // 143
            trn_ioq_p_rl ; 
        logic // 142       // 142
            trn_ioq_valid_rl ; 
        logic // 141       // 141
            trn_p_req_wl ; 
        logic // 140       // 140
            trn_ioq_cmpl_rl ; 
        logic // 139       // 139
            trn_cmpl_req_rl ; 
        logic // 138       // 138
            trn_ri_obcmpl_req_rl2 ; 
        logic // 137       // 137
            trn_ti_obcmpl_ack_rl2 ; 
        logic // 136       // 136
            trn_p_tlp_avail_wl ; 
        logic [1:0] // 135       // 135    
            trn_trans_type_rxl ; 
        logic [4:0] // 134:133   // 134:133
            trn_nxtstate_wxl ; 
        logic // 132:128   // 132:128
            trn_phdr_deq_wl2 ; 
        logic // 127       // 127
            trn_ph_valid_rl ; 
        logic // 126       // 126
            trn_pdata_valid_rl ; 
        logic // 125       // 125
            trn_pderr_rxl ; 
        logic // 124       // 124
            trn_phdr_rxl_ro ; 
        logic // 123       // 123
            trn_req_avail_wl ; 
        logic // 122       // 122
            trn_cmplh_deq_wl ; 
        logic // 121       // 121
            trn_phdr_deq_wl ; 
        logic [1:0] // 120       // 120
            trn_fsm_out_tlp_cmpl_wxl ; 
        logic // 119:118   // 119:118
            trn_update_consumed_cnt_wl ; 
        logic // 117       // 117    
            trn_zero_byte_wr_wl ; 
        logic [3:0] // 116       // 116    
            trn_p_tlp_cnt_rxl ; 
        logic [3:0] // 115:112   // 115:112
            trn_num_p_tlps_wxl ; 
        logic // 111:108   // 111:108
            trn_nxt_hdrsize_rl ; 
        logic // 107       // 107    
            trn_nxt_hdrsize_wl ; 
        logic [9:8] // 106       // 106    
            trn_pbyte_length_wxp_9_8 ; 
        logic [7:0] // 105:104   // 105:104
            trn_pbyte_length_wxp ; 
        logic [7:0] // 103: 96   // 103: 96
            trn_nxt_tlp_len_rxl ; 
        logic //  95: 88   //  95: 88
            trn_cmpl_avail_wl ; 
        logic //  87       //  87
            trn_pciemhdr_wxl_ep ; 
        logic [1:0] //  86       //  86
            trn_ri_obcmpl_hdr_rxl_length_1_0 ; 
        logic //  85: 84   //  85: 84
            trn_ti_obcmpl_ack_rl ; 
        logic //  83       //  83
            trn_ri_obcmpl_req_rl ; 
        logic [9:8] //  82       //  82
            trn_ri_obcmpl_hdr_rxl_tag_9_8 ; 
        logic [7:0] //  81: 80   //  81: 80
            trn_ri_obcmpl_hdr_rxl_tag ; 
        logic [4:0] //  79: 72   //  79: 72
            trn_pciemhdr_wxl_rid ; 
        logic [2:0] //  71: 67   //  71: 67
            trn_pciemhdr_wxl_tag ; 
        logic [4:0] //  66: 64   //  66: 64
            trn_pciechdr_wxl_cid ; 
        logic [2:0] //  63: 59   //  63: 59
            trn_pciechdr_wxl_tag ; 
        logic [7:0] //  58: 56   //  58: 56
            trn_tlp_dwrem_wxl ; 
        logic //  55: 48   //  55: 48
            trn_data_fifo_val_wl ; 
        logic //  47       //  47
            trn_cpp_be_rl ; 
        logic //  46       //  46
            trn_iosf_rxq_full_rl_0 ; 
        logic //  45       //  45
            trn_final_data_in_fifo_wl ; 
        logic //  44       //  44
            trn_pcie_data_val_rl ; 
        logic //  43       //  43
            trn_pdata_fifo_deq_wl ; 
        logic //  42       //  42
            trn_pdata_autodeq_wl ; 
        logic //  41       //  41
            trn_ti_iosfp_push_wl2 ; 
        logic [7:0] //  40       //  40
            trn_cdt_inc_wxl ; 
        logic [15:0] //  39: 32   //  39: 32
            trn_pdata_rxl ; 
        logic [15:0] //  31: 16   //  31: 16
            trn_nxt_hdr_wxp_17_2 ; 
    } hqm_sif_visa_signals_t ; 
    // [   0:   0] rst=0x0
    typedef struct packed {
        logic [7:0] revision_id ; 
        logic [5:0] // [  15:   8] rst=0x00
            hqm_spare ; 
        logic // [   7:   2] rst=0x00
            force_on ; 
        logic // [   1:   1] rst=0x0
            proc_disable ; 
    } hqm_sif_fuses_t ; 
    localparam EARLY_FUSES_BITS_TOT = $bits(hqm_sif_fuses_t) ; 
endpackage


