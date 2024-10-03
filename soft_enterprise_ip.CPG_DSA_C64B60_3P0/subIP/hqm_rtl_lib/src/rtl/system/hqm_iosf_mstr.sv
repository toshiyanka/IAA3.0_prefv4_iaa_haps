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
//----------------------------------------------------------------------------------------------------

module hqm_iosf_mstr

     import hqm_AW_pkg::*, hqm_pkg::*, hqm_sif_pkg::*, hqm_system_pkg::*, hqm_system_type_pkg::*, hqm_system_func_pkg::*, hqm_sif_csr_pkg::*;
(
     input  logic                               prim_nonflr_clk
    ,input  logic                               prim_gated_rst_b
    ,input  logic                               prim_gated_wflr_rst_b

    ,input  logic                               hqm_csr_pf0_rst_n               // PF reset

    ,input  logic                               flr_treatment_vec

    // Configuration

    ,input  logic [SAI_WIDTH:0]                 strap_hqm_tx_sai                // SAI used for P/NP transactions
    ,input  logic [SAI_WIDTH:0]                 strap_hqm_cmpl_sai              // SAI used for Cpl  transactions
    ,input  logic                               strap_hqm_completertenbittagen  // 10b tags enabled

    ,input  logic [7:0]                         current_bus                     // Captured bus number

    ,input  logic                               cfg_ats_enabled                 // ATS capability enabled
    ,input  logic                               cfg_mstr_par_off                // No parity checking
    ,input  SCRBD_CTL_t                         cfg_scrbd_ctl                   // Scoreboard control
    ,input  MSTR_LL_CTL_t                       cfg_mstr_ll_ctl                 // Linked list control

    ,input  DEVTLB_CTL_t                        cfg_devtlb_ctl                  // Devtlb control
    ,input  DEVTLB_SPARE_t                      cfg_devtlb_spare                // Devtlb spares
    ,input  DEVTLB_DEFEATURE0_t                 cfg_devtlb_defeature0           // Devtlb defeature bits
    ,input  DEVTLB_DEFEATURE1_t                 cfg_devtlb_defeature1
    ,input  DEVTLB_DEFEATURE2_t                 cfg_devtlb_defeature2

    ,input  logic                               cfg_ph_trigger_enable           // Address match trigger controls
    ,input  logic [63:0]                        cfg_ph_trigger_addr
    ,input  logic [63:0]                        cfg_ph_trigger_mask

    ,input  HQM_SIF_CNT_CTL_t                   hqm_sif_cnt_ctl

    ,input  DIR_CQ2TC_MAP_t                     dir_cq2tc_map                   // Traffic class mapping control
    ,input  LDB_CQ2TC_MAP_t                     ldb_cq2tc_map
    ,input  INT2TC_MAP_t                        int2tc_map

    ,input  logic                               csr_ppdcntl_ero                 // Enable relaxed ordering

    ,input  logic [HQM_SCRBD_DEPTH_WIDTH:0]     cfg_ibcpl_hdr_fifo_high_wm      // FIFO high watermarks
    ,input  logic [HQM_SCRBD_DEPTH_WIDTH:0]     cfg_ibcpl_data_fifo_high_wm

    ,output logic [31:0]                        cfg_ibcpl_hdr_fifo_status       // FIFO status
    ,output logic [31:0]                        cfg_ibcpl_data_fifo_status
    ,output logic [31:0]                        cfg_p_rl_cq_fifo_status

    ,output logic [6:0]                         p_req_db_status                 // DB status
    ,output logic [6:0]                         np_req_db_status
    ,output logic [6:0]                         cpl_req_db_status

    ,output new_DEVTLB_STATUS_t                 devtlb_status                   // Devtlb status
    ,output new_SCRBD_STATUS_t                  scrbd_status                    // Scoreboard status
    ,output new_MSTR_CRD_STATUS_t               mstr_crd_status                 // MSTR credit status
    ,output new_MSTR_FL_STATUS_t                mstr_fl_status                  // Freelist status
    ,output new_MSTR_LL_STATUS_t                mstr_ll_status                  // Linked list status

    ,output new_LOCAL_BME_STATUS_t              local_bme_status                // Local BME/MSIXE
    ,output new_LOCAL_MSIXE_STATUS_t            local_msixe_status

    // Write Buffer interface

    ,output logic                               write_buffer_mstr_ready

    ,input  logic                               write_buffer_mstr_v
    ,input  write_buffer_mstr_t                 write_buffer_mstr

    // Outbound completions

    ,output logic                               obcpl_ready                     // Outbound completion ready

    ,input  logic                               obcpl_v                         // Outbound completion valid
    ,input  RiObCplHdr_t                        obcpl_hdr                       // Outbound completion header
    ,input  csr_data_t                          obcpl_data                      // Outbound completion data
    ,input  logic                               obcpl_dpar                      // Outbound completion data parity
    ,input  upd_enables_t                       obcpl_enables                   // Outbound completion enable updates

    ,input  upd_enables_t                       gpsb_upd_enables

    // Inbound completions

    ,input  logic                               ibcpl_hdr_push                  // Inbound completion header push
    ,input  tdl_cplhdr_t                        ibcpl_hdr

    ,input  logic                               ibcpl_data_push                 // Inbound completion data push
    ,input  logic [HQM_IBCPL_DATA_WIDTH-1:0]    ibcpl_data
    ,input  logic [HQM_IBCPL_PARITY_WIDTH-1:0]  ibcpl_data_par                  // Parity per DW

    // RI to devtlb invalidate request

    ,input  logic                               rx_msg_v                        // Invalidate request valid
    ,input  hqm_devtlb_rx_msg_t                 rx_msg                          // Invalidate request

    // IOSF interface

    ,input  logic [2:0]                         prim_ism_agent                  // IOSF agent state machine

    ,output hqm_iosf_req_t                      iosf_req                        // IOSF Request

    ,input  hqm_iosf_gnt_t                      iosf_gnt                        // IOSF Grant

    ,output hqm_iosf_cmd_t                      iosf_cmd                        // IOSF Command

    ,output logic [MD_WIDTH:0]                  iosf_data                       // IOSF Data
    ,output logic [MDP_WIDTH:0]                 iosf_parity                     // IOSF Data Parity

    // FLR and PS change

    ,input  logic                               func_in_rst                     // Function being reset

    ,input  logic                               flr_txn_sent                    // FLR write received
    ,input  nphdr_tag_t                         flr_txn_tag
    ,input  hdr_reqid_t                         flr_txn_reqid

    ,output logic                               flr_cpl_sent                    // FLR write Cpl sent

    ,input  logic                               ps_txn_sent                     // PS write received
    ,input  nphdr_tag_t                         ps_txn_tag
    ,input  hdr_reqid_t                         ps_txn_reqid

    // Reset Prep Handling Interface

    ,input  logic                               sif_mstr_quiesce_req            // Quiesce master request
    ,output logic                               sif_mstr_quiesce_ack            // Master is quiesced

    // Status and errors

    ,output logic                               mstr_idle                       // Master is IDLE for clkreq
    ,output logic                               mstr_intf_idle                  // Master is IDLE for ISM

    ,output logic                               np_trans_pending                // For PCIe Device Status reg

    ,output logic                               poisoned_wr_sent                // For PCIe MDPE

    ,output logic                               cpl_usr                         // Completion UR
    ,output logic                               cpl_abort                       // Completer abort error
    ,output logic                               cpl_poisoned                    // Completion poisoned error
    ,output logic                               cpl_unexpected                  // Completion unexpected error
    ,output tdl_cplhdr_t                        cpl_error_hdr                   // Completion error header

    ,output logic                               cpl_timeout                     // Completion timeout error
    ,output logic [8:0]                         cpl_timeout_synd                // Completion timeout syndrome

    ,output logic                               sif_parity_alarm                // Parity error -> alarm
    ,output logic [8:0]                         set_sif_parity_err              // Parity error -> syndrome

    ,output logic                               devtlb_ats_alarm                // devtlb error -> alarm
    ,output load_DEVTLB_ATS_ERR_t               set_devtlb_ats_err              // devtlb error -> syndrome

    ,output logic [1:0] [31:0]                  mstr_cnts                       // Drop counter

    ,output logic                               ph_trigger                      // Address compare trigger output

    // Debug

    ,output new_SIF_MSTR_DEBUG_t                sif_mstr_debug
    ,output logic [191:0]                       noa_mstr

    // Scan

    ,input  logic                               fscan_byprst_b
    ,input  logic                               fscan_clkungate
    ,input  logic                               fscan_clkungate_syn
    ,input  logic                               fscan_latchclosed_b
    ,input  logic                               fscan_latchopen
    ,input  logic                               fscan_mode
    ,input  logic                               fscan_rstbypen
    ,input  logic                               fscan_shiften

    // Memory interface

    ,output hqm_sif_memi_scrbd_mem_t            memi_scrbd_mem
    ,input  hqm_sif_memo_scrbd_mem_t            memo_scrbd_mem

    ,output hqm_sif_memi_ibcpl_hdr_t            memi_ibcpl_hdr_fifo
    ,input  hqm_sif_memo_ibcpl_hdr_t            memo_ibcpl_hdr_fifo

    ,output hqm_sif_memi_ibcpl_data_t           memi_ibcpl_data_fifo
    ,input  hqm_sif_memo_ibcpl_data_t           memo_ibcpl_data_fifo

    ,output hqm_sif_memi_mstr_ll_hpa_t          memi_mstr_ll_hpa
    ,input  hqm_sif_memo_mstr_ll_hpa_t          memo_mstr_ll_hpa

    ,output hqm_sif_memi_mstr_ll_hdr_t          memi_mstr_ll_hdr
    ,input  hqm_sif_memo_mstr_ll_hdr_t          memo_mstr_ll_hdr

    ,output hqm_sif_memi_mstr_ll_data_t         memi_mstr_ll_data0
    ,input  hqm_sif_memo_mstr_ll_data_t         memo_mstr_ll_data0

    ,output hqm_sif_memi_mstr_ll_data_t         memi_mstr_ll_data1
    ,input  hqm_sif_memo_mstr_ll_data_t         memo_mstr_ll_data1

    ,output hqm_sif_memi_mstr_ll_data_t         memi_mstr_ll_data2
    ,input  hqm_sif_memo_mstr_ll_data_t         memo_mstr_ll_data2

    ,output hqm_sif_memi_mstr_ll_data_t         memi_mstr_ll_data3
    ,input  hqm_sif_memo_mstr_ll_data_t         memo_mstr_ll_data3

    ,output hqm_sif_memi_tlb_tag_4k_t           memi_tlb_tag0_4k
    ,input  hqm_sif_memo_tlb_tag_4k_t           memo_tlb_tag0_4k
    ,output hqm_sif_memi_tlb_tag_4k_t           memi_tlb_tag1_4k
    ,input  hqm_sif_memo_tlb_tag_4k_t           memo_tlb_tag1_4k
    ,output hqm_sif_memi_tlb_tag_4k_t           memi_tlb_tag2_4k
    ,input  hqm_sif_memo_tlb_tag_4k_t           memo_tlb_tag2_4k
    ,output hqm_sif_memi_tlb_tag_4k_t           memi_tlb_tag3_4k
    ,input  hqm_sif_memo_tlb_tag_4k_t           memo_tlb_tag3_4k
    ,output hqm_sif_memi_tlb_tag_4k_t           memi_tlb_tag4_4k
    ,input  hqm_sif_memo_tlb_tag_4k_t           memo_tlb_tag4_4k
    ,output hqm_sif_memi_tlb_tag_4k_t           memi_tlb_tag5_4k
    ,input  hqm_sif_memo_tlb_tag_4k_t           memo_tlb_tag5_4k
    ,output hqm_sif_memi_tlb_tag_4k_t           memi_tlb_tag6_4k
    ,input  hqm_sif_memo_tlb_tag_4k_t           memo_tlb_tag6_4k
    ,output hqm_sif_memi_tlb_tag_4k_t           memi_tlb_tag7_4k
    ,input  hqm_sif_memo_tlb_tag_4k_t           memo_tlb_tag7_4k

    ,output hqm_sif_memi_tlb_data_4k_t          memi_tlb_data0_4k
    ,input  hqm_sif_memo_tlb_data_4k_t          memo_tlb_data0_4k
    ,output hqm_sif_memi_tlb_data_4k_t          memi_tlb_data1_4k
    ,input  hqm_sif_memo_tlb_data_4k_t          memo_tlb_data1_4k
    ,output hqm_sif_memi_tlb_data_4k_t          memi_tlb_data2_4k
    ,input  hqm_sif_memo_tlb_data_4k_t          memo_tlb_data2_4k
    ,output hqm_sif_memi_tlb_data_4k_t          memi_tlb_data3_4k
    ,input  hqm_sif_memo_tlb_data_4k_t          memo_tlb_data3_4k
    ,output hqm_sif_memi_tlb_data_4k_t          memi_tlb_data4_4k
    ,input  hqm_sif_memo_tlb_data_4k_t          memo_tlb_data4_4k
    ,output hqm_sif_memi_tlb_data_4k_t          memi_tlb_data5_4k
    ,input  hqm_sif_memo_tlb_data_4k_t          memo_tlb_data5_4k
    ,output hqm_sif_memi_tlb_data_4k_t          memi_tlb_data6_4k
    ,input  hqm_sif_memo_tlb_data_4k_t          memo_tlb_data6_4k
    ,output hqm_sif_memi_tlb_data_4k_t          memi_tlb_data7_4k
    ,input  hqm_sif_memo_tlb_data_4k_t          memo_tlb_data7_4k
);

//----------------------------------------------------------------------------------------------------
// devtlb includes

`include "hqm_devtlb_globals_int.vh"        // Common Parameters that are not used by parent hierarchies
`include "hqm_devtlb_params.vh"
`include "hqm_devtlb_globals_ext.vh"        // Common Parameters that may be used by parent hierarchies
`include "hqm_devtlb_types.vh"              // Structure, Enum, Union Definitions

//----------------------------------------------------------------------------------------------------

localparam HQM_MSTR_P_LL          = HQM_MSTR_NUM_CQS;                       // P   LL #
localparam HQM_MSTR_NP_LL         = HQM_MSTR_NUM_CQS + 1;                   // NP  LL #
localparam HQM_MSTR_CPL_LL        = HQM_MSTR_NUM_CQS + 2;                   // Cpl LL #
localparam HQM_MSTR_INT_LL        = HQM_MSTR_NUM_CQS + 3;                   // Int LL #
localparam DEVTLB_HCB_DEPTH_WIDTH = AW_logb2(DEVTLB_HCB_DEPTH)+1;
localparam DEVTLB_LCB_DEPTH_WIDTH = AW_logb2(DEVTLB_LCB_DEPTH)+1;

//----------------------------------------------------------------------------------------------------
// devtlb interface signals

logic                                                   devtlb_reset;
logic [9:0]                                             devtlb_reset_q;
logic                                                   devtlb_flr;
logic [9:0]                                             devtlb_flr_q;

logic                                                   cfg_ats_enabled_q;
logic                                                   cfg_ats_enabled_redge;

logic                                                   xreqs_active;               // O: IOMMU is currently not performing any translation requests or sequencer flows
logic                                                   tlb_reset_active;           // O: high is tlb inv due to reset or implicit inval is in progress.
logic                                                   invreqs_active;             // O: high is any inv req in invq.

logic                                                   imp_invalidation_v;         // I: Triggers an invalidation of all IOMMU TLBs/PWCs.
logic                                                   imp_invalidation_bdf_v;     // I:
logic [DEVTLB_BDF_WIDTH-1:0]                            imp_invalidation_bdf;       // I:

logic [DEVTLB_TLB_ARBGCNT_WIDTH-1:0]                    scr_loxreq_gcnt;            // I: TLB Arbiter Grant count, one based.
logic [DEVTLB_TLB_ARBGCNT_WIDTH-1:0]                    scr_hixreq_gcnt;            // I:
logic [DEVTLB_TLB_ARBGCNT_WIDTH-1:0]                    scr_pendq_gcnt;             // I:
logic [DEVTLB_TLB_ARBGCNT_WIDTH-1:0]                    scr_fill_gcnt;              // I:
logic                                                   scr_prs_continuous_retry;   // I:
logic                                                   scr_disable_prs;            // I:
logic                                                   scr_disable_2m;             // I:
logic                                                   scr_disable_1g;             // I:
logic [31:0]                                            scr_spare;                  // I:

logic                                                   PRSSTS_stopped_nc;          // O:
logic                                                   PRSSTS_uprgi_nc;            // O:
logic                                                   PRSSTS_rf_nc;               // O:
logic [31:0]                                            PRSREQALLOC_alloc;          // I:

logic [1:0]                                             ats_req_v;                  // O:
hqm_devtlb_ats_req_t                                    ats_req;                    // O:
logic [1:0]                                             ats_req_ack;                // I:

logic                                                   ats_rsp_v;                  // I:
hqm_devtlb_ats_rsp_t                                    ats_rsp;                    // I:

logic                                                   tx_msg_v;                   // O:
hqm_devtlb_tx_msg_t                                     tx_msg;                     // O:
logic                                                   tx_msg_ack;                 // I:

logic                                                   devtlb_req_v;               // I:
hqm_devtlb_req_t                                        devtlb_req;                 // I:
logic                                                   devtlb_lcrd_inc;            // O: Credit return for Low priority request
logic                                                   devtlb_hcrd_inc;            // O: Credite return for high priority request

logic                                                   devtlb_rsp_v;               // O:
hqm_devtlb_rsp_t                                        devtlb_rsp;                 // O:

logic                                                   drain_req_v;                // O:
hqm_devtlb_drain_req_t                                  drain_req;                  // O:
logic                                                   drain_req_ack;              // I:

logic                                                   drain_rsp_v;                // I:
hqm_devtlb_drain_rsp_t                                  drain_rsp;                  // I:

logic [(5*DEVTLB_PARITY_WIDTH)-1:0]                     tlb_tag_parity_err;         // O: Vector reporting TLB tag parity errors;
                                                                                    // 4-3:RSVD 2:IOTLB 1G TAG;  1:IOTLB 2M TAG;  0:IOTLB 4K TAG
logic [(5*DEVTLB_PARITY_WIDTH)-1:0]                     tlb_data_parity_err;        // O: Vector reporting TLB tag parity errors;
                                                                                    // 4-3:RSVD 2:IOTLB 1G DATA; 1:IOTLB 2M DATA; 0:IOTLB 4K DATA

//----------------------------------------------------------------------------------------------------

logic [HQM_MSTR_NUM_LLS_WIDTH-1:0]                      wb_cq;
logic [HQM_MSTR_NUM_LLS_WIDTH-1:0]                      wb_cq_scaled;
logic                                                   wb_msix;
logic                                                   wb_ims;
logic                                                   wb_alarm;
logic                                                   wb_pw;
logic                                                   wb_pcq;
logic                                                   wb_tlb_reqd;
logic [HQM_MSTR_NUM_LLS_WIDTH-1:0]                      wb_ll;
logic                                                   wb_drop_msixe;
logic                                                   wb_drop_invalid;
logic                                                   wb_drop_cq;

hqm_pcie_hdr_t                                          phdr;
logic                                                   phdr_par;
hqm_pasidtlp_t                                          phdr_pasidtlp;
logic [3:0]                                             phdr_tc;

logic                                                   atshdr_ready;
logic                                                   atshdr_v;
hqm_pcie_hdr_t                                          atshdr;
logic                                                   atshdr_par;
hqm_pasidtlp_t                                          atshdr_pasidtlp;

hqm_pcie_hdr_t                                          invrsphdr;
logic                                                   invrsphdr_par;
hqm_pasidtlp_t                                          invrsphdr_pasidtlp;
logic                                                   invrsp_pend_next;
logic                                                   invrsp_pend_q;

hqm_pciecpl_hdr_t                                       cplhdr;
logic                                                   cplhdr_par;

logic                                                   devtlb_hcrd_dec;
logic [DEVTLB_HCB_DEPTH_WIDTH-1:0]                      devtlb_hcrd_next;
logic [DEVTLB_HCB_DEPTH_WIDTH-1:0]                      devtlb_hcrd_q;
logic                                                   devtlb_lcrd_dec;
logic [DEVTLB_LCB_DEPTH_WIDTH-1:0]                      devtlb_lcrd_next;
logic [DEVTLB_LCB_DEPTH_WIDTH-1:0]                      devtlb_lcrd_q;

logic                                                   fl2ll_v;
logic [HQM_MSTR_NUM_LLS_WIDTH-1:0]                      fl2ll_ll;

logic                                                   ll2rl_v;
logic [HQM_MSTR_NUM_LLS_WIDTH-1:0]                      ll2rl_ll;
logic [1:0]                                             ll2rl_rl;
logic [3:0]                                             ll2rl_rl_decode;

logic                                                   ll2db_v;
logic                                                   ll2db_v_nd;
logic [HQM_MSTR_NUM_LLS_WIDTH-1:0]                      ll2db_ll;
logic [1:0]                                             ll2db_rl;
logic [3:0]                                             ll2db_rl_decode;

logic                                                   rl2db_v;
logic [1:0]                                             rl2db_rl;

logic                                                   fl_push;
logic [HQM_MSTR_FL_DEPTH_WIDTH-1:0]                     fl_push_ptr;

logic                                                   fl_empty;
logic                                                   fl_aempty;
logic                                                   fl_full;
logic [HQM_MSTR_FL_DEPTH_WIDTH-1:0]                     fl_hptr;

logic [HQM_MSTR_NUM_LLS-1:0]                            ll_v;
logic [(HQM_MSTR_NUM_LLS*HQM_MSTR_FL_DEPTH_WIDTH)-1:0]  ll_hptr;
logic [HQM_MSTR_FL_DEPTH_WIDTH-1:0]                     ll_hptr_mda[(1<<HQM_MSTR_NUM_LLS_WIDTH)-1:0];

logic [2:0]                                             rl_v;
logic [(3*HQM_MSTR_FL_DEPTH_WIDTH)-1:0]                 rl_hptr;
logic [HQM_MSTR_FL_DEPTH_WIDTH-1:0]                     rl_hptr_mda[3:0];

logic                                                   scrbd_tag_v;
logic [HQM_SCRBD_DEPTH_WIDTH-1:0]                       scrbd_tag;
logic [9:0]                                             scrbd_tag_10b;

logic                                                   scrbd_alloc;
scrbd_data_t                                            scrbd_alloc_data;

logic                                                   scrbd_free;

logic                                                   hdr_rdata_par;
hqm_pasidtlp_t                                          hdr_rdata_pasidtlp;
hqm_pcie_hdr_t                                          hdr_rdata_hdr;
logic                                                   hdr_rdata_tlb_reqd;
hqm_pcie_type_e_t                                       hdr_rdata_pcie_cmd;
logic [63:12]                                           hdr_rdata_addr;
logic                                                   hdr_rdata_fmt0;
logic                                                   hdr_rdata_padj;

logic                                                   hpa_rdata_p;
logic [DEVTLB_MAX_HOST_ADDRESS_WIDTH-1:12]              hpa_rdata_hpa;
logic [(1<<HQM_MSTR_NUM_LLS_WIDTH)-1:0]                 hpa_v_next;
logic [HQM_MSTR_NUM_CQS-1:0]                            hpa_v_q;
logic [HQM_MSTR_NUM_CQS-1:0]                            hpa_v;
logic [(1<<HQM_MSTR_NUM_LLS_WIDTH)-1:0]                 hpa_v_scaled;
logic [(1<<HQM_MSTR_NUM_LLS_WIDTH)-1:0]                 hpa_err_next;
logic [HQM_MSTR_NUM_CQS-1:0]                            hpa_err_q;
logic [(1<<HQM_MSTR_NUM_LLS_WIDTH)-1:0]                 hpa_err_scaled;
logic [(1<<HQM_MSTR_NUM_LLS_WIDTH)-1:0]                 hpa_pnd_next;
logic [HQM_MSTR_NUM_CQS-1:0]                            hpa_pnd_q;
logic [(1<<HQM_MSTR_NUM_LLS_WIDTH)-1:0]                 hpa_pnd_scaled;

logic                                                   clr_hpa_v;
logic                                                   clr_hpa_err;
logic [HQM_MSTR_NUM_CQS_WIDTH-1:0]                      clr_hpa_err_cq;

logic [HQM_MSTR_FL_DEPTH-1:0]                           msix_v_next;
logic [HQM_MSTR_FL_DEPTH-1:0]                           msix_v_q;

logic [HQM_MSTR_FL_DEPTH-1:0]                           blk_v_next;
logic [HQM_MSTR_FL_DEPTH-1:0]                           blk_v_q;
logic [HQM_MSTR_NUM_LLS-1:0]                            blk_v;

logic [2:0]                                             iosf_db_fill_req;
logic                                                   iosf_db_fill_bp;
logic                                                   iosf_db_fill_any;
logic                                                   iosf_db_fill_v_next;
logic                                                   iosf_db_fill_v_q;
logic [1:0]                                             iosf_db_fill_rl_next;
logic [1:0]                                             iosf_db_fill_rl_q;
logic [1:0]                                             iosf_db_fill_cnt_next[2:0];
logic [1:0]                                             iosf_db_fill_cnt_q[2:0];
logic [2:0]                                             iosf_db_fill_cnt_inc;
logic [2:0]                                             iosf_db_fill_cnt_dec;

logic [6:0]                                             iosf_db_status[2:0];
logic [2:0]                                             iosf_db_in_ready;
logic [3:0]                                             iosf_db_in_valid;
hqm_iosf_cmd_t                                          iosf_db_in_hdr;
logic [MDP_WIDTH:0]                                     iosf_db_in_parity0;
logic [MDP_WIDTH:0]                                     iosf_db_in_parity1;
logic [MD_WIDTH:0]                                      iosf_db_in_data0;
logic [MD_WIDTH:0]                                      iosf_db_in_data1;
logic [2:0]                                             iosf_db_out_ready;
logic [2:0]                                             iosf_db_out_valid;
hqm_iosf_cmd_t                                          iosf_db_out_hdr[3:0];
logic [MDP_WIDTH:0]                                     iosf_db_out_parity0[3:0];
logic [MDP_WIDTH:0]                                     iosf_db_out_parity1[3:0];
logic [MD_WIDTH:0]                                      iosf_db_out_data0[3:0];
logic [MD_WIDTH:0]                                      iosf_db_out_data1[3:0];

logic [HQM_IOSF_REQ_CREDIT_WIDTH-1:0]                   iosf_req_credits_next[2:0];
logic [HQM_IOSF_REQ_CREDIT_WIDTH-1:0]                   iosf_req_credits_q[2:0];
logic [HQM_IOSF_REQ_CREDIT_WIDTH-1:0]                   iosf_req_credits_m1[2:0];

logic [HQM_IOSF_REQ_CREDIT_WIDTH-1:0]                   req_put_cnt_next[2:0];
logic [HQM_IOSF_REQ_CREDIT_WIDTH-1:0]                   req_put_cnt_q[2:0];
logic [2:0]                                             req_put_afull_next;
logic [2:0]                                             req_put_afull_q;

logic [HQM_MSTR_NUM_LLS-1:0]                            ll_arb_reqs_next;
logic [HQM_MSTR_NUM_LLS-1:0]                            ll_arb_reqs_q;
logic [HQM_MSTR_NUM_LLS-1:0]                            ll_arb_reqs;
logic                                                   ll_arb_update;
logic                                                   ll_arb_fill_hold;
logic                                                   ll_arb_fabric_hold;
logic                                                   ll_arb_hold;
logic                                                   ll_arb_winner_v_next;
logic                                                   ll_arb_winner_v_q;
logic                                                   ll_arb_winner_v;
logic [HQM_MSTR_NUM_LLS_WIDTH-1:0]                      ll_arb_winner_next;
logic [HQM_MSTR_NUM_LLS_WIDTH-1:0]                      ll_arb_winner_q;
logic [(1<<HQM_MSTR_NUM_LLS_WIDTH)-1:0]                 ll_arb_winner_mask;
logic [1:0]                                             ll_arb_winner_rl;
logic                                                   ll_arb_winner_is_p;
logic                                                   ll_arb_winner_is_np;
logic                                                   ll_arb_winner_is_cpl;
logic                                                   ll_arb_winner_is_inv;
logic                                                   ll_arb_winner_drain;

logic                                                   iosf_req_v_next;
logic                                                   iosf_req_v_q;
logic [1:0]                                             iosf_req_rtype_next;
logic [1:0]                                             iosf_req_rtype_q;

hqm_pcie_type_e_t                                       ttype;

hqm_iosf_req_t                                          iosf_req_next;
hqm_iosf_req_t                                          iosf_req_q;

hqm_iosf_cmd_t                                          iosf_cmd_out;
hqm_iosf_gnt_t                                          iosf_gnt_q;

logic                                                   gnt_next;
logic [11:0]                                            gnt_q;
logic [3:0]                                             gnt_rl_decode;

logic                                                   iosf_data0_v_next;
logic                                                   iosf_data0_v_q;
logic [MD_WIDTH:0]                                      iosf_data0_next;
logic [MD_WIDTH:0]                                      iosf_data0_q;
logic [MDP_WIDTH:0]                                     iosf_parity0_next;
logic [MDP_WIDTH:0]                                     iosf_parity0_q;

logic                                                   iosf_data1_v_next;
logic                                                   iosf_data1_v_q;
logic [MD_WIDTH:0]                                      iosf_data1_next;
logic [MD_WIDTH:0]                                      iosf_data1_q;
logic [MDP_WIDTH:0]                                     iosf_parity1_next;
logic [MDP_WIDTH:0]                                     iosf_parity1_q;

logic                                                   poisoned_wr_sent_next;
logic                                                   poisoned_wr_sent_q;

logic                                                   sif_mstr_quiesce_req_q;
logic                                                   sif_mstr_quiesce_ack_next;
logic                                                   sif_mstr_quiesce_ack_q;

scrbd_data_t                                            ats_alloc_data;

logic [5:0]                                             ats_req_cnt_next;
logic [5:0]                                             ats_req_cnt_q;              // Max 32 pending ATS requests
logic                                                   ats_req_cnt_inc;
logic                                                   ats_req_cnt_dec;
logic                                                   ats_req_cnt_lt_limit;

logic [6:0]                                             xreq_cnt_next;
logic [6:0]                                             xreq_cnt_q;                 // Pending queue has 64 entries
logic                                                   xreq_cnt_inc;
logic                                                   xreq_cnt_dec;
logic                                                   xreq_cnt_lt_limit;

logic                                                   scrbd_perr;
logic                                                   ibcpl_hdr_fifo_perr;
logic                                                   ibcpl_data_fifo_perr;

logic [8:0]                                             parity_error_next;
logic [8:0]                                             parity_error_q;
logic [8:0]                                             parity_error_last_q;

logic                                                   drain_pend_next;
logic                                                   drain_pend_q;
hqm_devtlb_drain_req_t                                  drain_req_next;
hqm_devtlb_drain_req_t                                  drain_req_q;

logic                                                   flr_txn_sent_q;
nphdr_tag_t                                             flr_txn_tag_q;
hdr_reqid_t                                             flr_txn_reqid_q;
logic                                                   flr_cpl_sent_next;
logic                                                   flr_cpl_sent_q;

logic                                                   block_cq_p_np_lls;
logic                                                   drain_cq_p_np_lls;
                                                       
logic                                                   ps_txn_sent_q;
nphdr_tag_t                                             ps_txn_tag_q;
hdr_reqid_t                                             ps_txn_reqid_q;
logic                                                   ps_cpl_sent_next;
logic                                                   ps_cpl_sent_q;
logic                                                   ps_d0;

logic                                                   local_bme_next;
logic                                                   local_bme_q;
logic                                                   local_bme;
logic                                                   local_msixe_next;
logic                                                   local_msixe_q;
logic                                                   local_msixe;

logic                                                   allow_bme_update;
logic                                                   sent_bme_cpl_next;
logic                                                   sent_bme_cpl_q;

logic                                                   allow_msixe_update;
logic                                                   sent_msixe_cpl_next;
logic                                                   sent_msixe_cpl_q;

logic                                                   cnt_inc;

logic                                                   ph_trigger_next;

hqm_sif_memi_mstr_ll_hpa_t                              memi_mstr_ll_hpa_next;
hqm_sif_memi_mstr_ll_hpa_t                              memi_mstr_ll_hpa_q;
hqm_sif_memi_mstr_ll_hdr_t                              memi_mstr_ll_hdr_next;
hqm_sif_memi_mstr_ll_hdr_t                              memi_mstr_ll_hdr_q;
hqm_sif_memi_mstr_ll_data_t                             memi_mstr_ll_data0_next;
hqm_sif_memi_mstr_ll_data_t                             memi_mstr_ll_data0_q;
hqm_sif_memi_mstr_ll_data_t                             memi_mstr_ll_data1_next;
hqm_sif_memi_mstr_ll_data_t                             memi_mstr_ll_data1_q;
hqm_sif_memi_mstr_ll_data_t                             memi_mstr_ll_data2_next;
hqm_sif_memi_mstr_ll_data_t                             memi_mstr_ll_data2_q;
hqm_sif_memi_mstr_ll_data_t                             memi_mstr_ll_data3_next;
hqm_sif_memi_mstr_ll_data_t                             memi_mstr_ll_data3_q;

logic                                                   p_rl_cq_fifo_push;
logic [HQM_MSTR_NUM_CQS_WIDTH-1:0]                      p_rl_cq_fifo_push_data;
logic                                                   p_rl_cq_fifo_pop;
logic [HQM_MSTR_NUM_CQS_WIDTH-1:0]                      p_rl_cq_fifo_pop_data;
                                                       
logic                                                   p_rl_cq_fifo_we;
logic [4:0]                                             p_rl_cq_fifo_waddr;
logic [HQM_MSTR_NUM_CQS_WIDTH-1:0]                      p_rl_cq_fifo_wdata;
logic                                                   p_rl_cq_fifo_re;
logic [4:0]                                             p_rl_cq_fifo_raddr;
logic [HQM_MSTR_NUM_CQS_WIDTH-1:0]                      p_rl_cq_fifo_rdata;
logic [HQM_MSTR_NUM_CQS_WIDTH-1:0]                      p_rl_cq_fifo_mem[31:0];
logic                                                   p_rl_cq_fifo_pop_data_v_nc;
logic                                                   p_rl_cq_fifo_full_nc;
logic                                                   p_rl_cq_fifo_afull_nc;

logic                                                   mstr_req_idle;

logic [8:0]                                             cq_np_cnt_next[HQM_MSTR_NUM_CQS-1:0];
logic [8:0]                                             cq_np_cnt_q[HQM_MSTR_NUM_CQS-1:0];
logic [(1<<HQM_MSTR_NUM_LLS_WIDTH)-1:0]                 cq_np_cnt_inc;
logic [(1<<HQM_MSTR_NUM_LLS_WIDTH)-1:0]                 cq_np_cnt_dec;

//----------------------------------------------------------------------------------------------------
// devtlb memory interfaces
// Single read enable reads all ways at single read address in parallel
// Per way write enable selects which way gets written

logic                                                   EXT_RF_IOTLB_4k_Tag_RdEn;
logic [HQM_TLB_4K_ADDR_WIDTH-1:0]                       EXT_RF_IOTLB_4k_Tag_RdAddr;
logic [HQM_TLB_NUM_WAYS-1:0][HQM_TLB_4K_TAG_WIDTH-1:0]  EXT_RF_IOTLB_4k_Tag_RdData;
logic [HQM_TLB_NUM_WAYS-1:0]                            EXT_RF_IOTLB_4k_Tag_WrEn;
logic [HQM_TLB_4K_ADDR_WIDTH-1:0]                       EXT_RF_IOTLB_4k_Tag_WrAddr;
logic [HQM_TLB_4K_TAG_WIDTH-1:0]                        EXT_RF_IOTLB_4k_Tag_WrData;

logic                                                   EXT_RF_IOTLB_4k_Data_RdEn;
logic [HQM_TLB_4K_ADDR_WIDTH-1:0]                       EXT_RF_IOTLB_4k_Data_RdAddr;
logic [HQM_TLB_NUM_WAYS-1:0][HQM_TLB_4K_DATA_WIDTH-1:0] EXT_RF_IOTLB_4k_Data_RdData;
logic [HQM_TLB_NUM_WAYS-1:0]                            EXT_RF_IOTLB_4k_Data_WrEn;
logic [HQM_TLB_4K_ADDR_WIDTH-1:0]                       EXT_RF_IOTLB_4k_Data_WrAddr;
logic [HQM_TLB_4K_DATA_WIDTH-1:0]                       EXT_RF_IOTLB_4k_Data_WrData;

logic                                                   EXT_RF_IOTLB_2m_Tag_RdEn;
logic [HQM_TLB_2M_ADDR_WIDTH-1:0]                       EXT_RF_IOTLB_2m_Tag_RdAddr;
logic [HQM_TLB_NUM_WAYS-1:0][HQM_TLB_2M_TAG_WIDTH-1:0]  EXT_RF_IOTLB_2m_Tag_RdData;
logic [HQM_TLB_NUM_WAYS-1:0]                            EXT_RF_IOTLB_2m_Tag_WrEn;
logic [HQM_TLB_2M_ADDR_WIDTH-1:0]                       EXT_RF_IOTLB_2m_Tag_WrAddr;
logic [HQM_TLB_2M_TAG_WIDTH-1:0]                        EXT_RF_IOTLB_2m_Tag_WrData;

logic                                                   EXT_RF_IOTLB_2m_Data_RdEn;
logic [HQM_TLB_2M_ADDR_WIDTH-1:0]                       EXT_RF_IOTLB_2m_Data_RdAddr;
logic [HQM_TLB_NUM_WAYS-1:0][HQM_TLB_2M_DATA_WIDTH-1:0] EXT_RF_IOTLB_2m_Data_RdData;
logic [HQM_TLB_NUM_WAYS-1:0]                            EXT_RF_IOTLB_2m_Data_WrEn;
logic [HQM_TLB_2M_ADDR_WIDTH-1:0]                       EXT_RF_IOTLB_2m_Data_WrAddr;
logic [HQM_TLB_2M_DATA_WIDTH-1:0]                       EXT_RF_IOTLB_2m_Data_WrData;

logic                                                   EXT_RF_IOTLB_1g_Tag_RdEn;
logic [HQM_TLB_1G_ADDR_WIDTH-1:0]                       EXT_RF_IOTLB_1g_Tag_RdAddr;
logic [HQM_TLB_NUM_WAYS-1:0][HQM_TLB_1G_TAG_WIDTH-1:0]  EXT_RF_IOTLB_1g_Tag_RdData;
logic [HQM_TLB_NUM_WAYS-1:0]                            EXT_RF_IOTLB_1g_Tag_WrEn;
logic [HQM_TLB_1G_ADDR_WIDTH-1:0]                       EXT_RF_IOTLB_1g_Tag_WrAddr;
logic [HQM_TLB_1G_TAG_WIDTH-1:0]                        EXT_RF_IOTLB_1g_Tag_WrData;

logic                                                   EXT_RF_IOTLB_1g_Data_RdEn;
logic [HQM_TLB_1G_ADDR_WIDTH-1:0]                       EXT_RF_IOTLB_1g_Data_RdAddr;
logic [HQM_TLB_NUM_WAYS-1:0][HQM_TLB_1G_DATA_WIDTH-1:0] EXT_RF_IOTLB_1g_Data_RdData;
logic [HQM_TLB_NUM_WAYS-1:0]                            EXT_RF_IOTLB_1g_Data_WrEn;
logic [HQM_TLB_1G_ADDR_WIDTH-1:0]                       EXT_RF_IOTLB_1g_Data_WrAddr;
logic [HQM_TLB_1G_DATA_WIDTH-1:0]                       EXT_RF_IOTLB_1g_Data_WrData;

// Standard RF devtlb interfaces for each way

hqm_sif_memi_tlb_tag_4k_t                               memi_tlb_tag_4k[HQM_TLB_NUM_WAYS-1:0];
hqm_sif_memi_tlb_tag_2m_t                               memi_tlb_tag_2m[HQM_TLB_NUM_WAYS-1:0];
hqm_sif_memi_tlb_tag_1g_t                               memi_tlb_tag_1g[HQM_TLB_NUM_WAYS-1:0];

hqm_sif_memo_tlb_tag_4k_t                               memo_tlb_tag_4k[HQM_TLB_NUM_WAYS-1:0];
hqm_sif_memo_tlb_tag_2m_t                               memo_tlb_tag_2m[HQM_TLB_NUM_WAYS-1:0];
hqm_sif_memo_tlb_tag_1g_t                               memo_tlb_tag_1g[HQM_TLB_NUM_WAYS-1:0];

hqm_sif_memi_tlb_data_4k_t                              memi_tlb_data_4k[HQM_TLB_NUM_WAYS-1:0];
hqm_sif_memi_tlb_data_2m_t                              memi_tlb_data_2m[HQM_TLB_NUM_WAYS-1:0];
hqm_sif_memi_tlb_data_1g_t                              memi_tlb_data_1g[HQM_TLB_NUM_WAYS-1:0];

hqm_sif_memo_tlb_data_4k_t                              memo_tlb_data_4k[HQM_TLB_NUM_WAYS-1:0];
hqm_sif_memo_tlb_data_2m_t                              memo_tlb_data_2m[HQM_TLB_NUM_WAYS-1:0];
hqm_sif_memo_tlb_data_1g_t                              memo_tlb_data_1g[HQM_TLB_NUM_WAYS-1:0];

// Flop memories

logic [HQM_TLB_2M_TAG_WIDTH-1:0]                        tlb_tag_2m_mem[ HQM_TLB_NUM_WAYS-1:0][HQM_TLB_2M_DEPTH-1:0];
logic [HQM_TLB_2M_DATA_WIDTH-1:0]                       tlb_data_2m_mem[HQM_TLB_NUM_WAYS-1:0][HQM_TLB_2M_DEPTH-1:0];
logic [HQM_TLB_1G_TAG_WIDTH-1:0]                        tlb_tag_1g_mem[ HQM_TLB_NUM_WAYS-1:0][HQM_TLB_1G_DEPTH-1:0];
logic [HQM_TLB_1G_DATA_WIDTH-1:0]                       tlb_data_1g_mem[HQM_TLB_NUM_WAYS-1:0][HQM_TLB_1G_DEPTH-1:0];

generate
 for (genvar g=0; g<HQM_TLB_NUM_WAYS; g=g+1) begin

  // Convert devtlb memory interfaces to separate per RF interfaces
  // Broadcast re, raddr, waddr, and wdata.  Separate rdata[way] and we[way].

  assign memi_tlb_tag_4k[g].re          = EXT_RF_IOTLB_4k_Tag_RdEn;
  assign memi_tlb_tag_4k[g].raddr       = EXT_RF_IOTLB_4k_Tag_RdAddr;
  assign memi_tlb_tag_4k[g].we          = EXT_RF_IOTLB_4k_Tag_WrEn[g];
  assign memi_tlb_tag_4k[g].waddr       = EXT_RF_IOTLB_4k_Tag_WrAddr;
  assign memi_tlb_tag_4k[g].wdata       = EXT_RF_IOTLB_4k_Tag_WrData;

  assign EXT_RF_IOTLB_4k_Tag_RdData[g]  = memo_tlb_tag_4k[g].rdata;

  assign memi_tlb_data_4k[g].re         = EXT_RF_IOTLB_4k_Data_RdEn;
  assign memi_tlb_data_4k[g].raddr      = EXT_RF_IOTLB_4k_Data_RdAddr;
  assign memi_tlb_data_4k[g].we         = EXT_RF_IOTLB_4k_Data_WrEn[g];
  assign memi_tlb_data_4k[g].waddr      = EXT_RF_IOTLB_4k_Data_WrAddr;
  assign memi_tlb_data_4k[g].wdata      = EXT_RF_IOTLB_4k_Data_WrData;

  assign EXT_RF_IOTLB_4k_Data_RdData[g] = memo_tlb_data_4k[g].rdata;

  assign memi_tlb_tag_2m[g].re          = EXT_RF_IOTLB_2m_Tag_RdEn;
  assign memi_tlb_tag_2m[g].raddr       = EXT_RF_IOTLB_2m_Tag_RdAddr;
  assign memi_tlb_tag_2m[g].we          = EXT_RF_IOTLB_2m_Tag_WrEn[g];
  assign memi_tlb_tag_2m[g].waddr       = EXT_RF_IOTLB_2m_Tag_WrAddr;
  assign memi_tlb_tag_2m[g].wdata       = EXT_RF_IOTLB_2m_Tag_WrData;

  assign EXT_RF_IOTLB_2m_Tag_RdData[g]  = memo_tlb_tag_2m[g].rdata;

  assign memi_tlb_data_2m[g].re         = EXT_RF_IOTLB_2m_Data_RdEn;
  assign memi_tlb_data_2m[g].raddr      = EXT_RF_IOTLB_2m_Data_RdAddr;
  assign memi_tlb_data_2m[g].we         = EXT_RF_IOTLB_2m_Data_WrEn[g];
  assign memi_tlb_data_2m[g].waddr      = EXT_RF_IOTLB_2m_Data_WrAddr;
  assign memi_tlb_data_2m[g].wdata      = EXT_RF_IOTLB_2m_Data_WrData;

  assign EXT_RF_IOTLB_2m_Data_RdData[g] = memo_tlb_data_2m[g].rdata;

  assign memi_tlb_tag_1g[g].re          = EXT_RF_IOTLB_1g_Tag_RdEn;
  assign memi_tlb_tag_1g[g].raddr       = EXT_RF_IOTLB_1g_Tag_RdAddr;
  assign memi_tlb_tag_1g[g].we          = EXT_RF_IOTLB_1g_Tag_WrEn[g];
  assign memi_tlb_tag_1g[g].waddr       = EXT_RF_IOTLB_1g_Tag_WrAddr;
  assign memi_tlb_tag_1g[g].wdata       = EXT_RF_IOTLB_1g_Tag_WrData;

  assign EXT_RF_IOTLB_1g_Tag_RdData[g]  = memo_tlb_tag_1g[g].rdata;

  assign memi_tlb_data_1g[g].re         = EXT_RF_IOTLB_1g_Data_RdEn;
  assign memi_tlb_data_1g[g].raddr      = EXT_RF_IOTLB_1g_Data_RdAddr;
  assign memi_tlb_data_1g[g].we         = EXT_RF_IOTLB_1g_Data_WrEn[g];
  assign memi_tlb_data_1g[g].waddr      = EXT_RF_IOTLB_1g_Data_WrAddr;
  assign memi_tlb_data_1g[g].wdata      = EXT_RF_IOTLB_1g_Data_WrData;

  assign EXT_RF_IOTLB_1g_Data_RdData[g] = memo_tlb_data_1g[g].rdata;

  // Build these 4 (per way) smaller memories out of flops

  always_ff @(posedge prim_nonflr_clk) begin
   if (memi_tlb_tag_2m[ g].re) memo_tlb_tag_2m[ g].rdata <= tlb_tag_2m_mem[ g][memi_tlb_tag_2m[ g].raddr];
   if (memi_tlb_data_2m[g].re) memo_tlb_data_2m[g].rdata <= tlb_data_2m_mem[g][memi_tlb_data_2m[g].raddr];
   if (memi_tlb_tag_1g[ g].re) memo_tlb_tag_1g[ g].rdata <= tlb_tag_1g_mem[ g][memi_tlb_tag_1g[ g].raddr];
   if (memi_tlb_data_1g[g].re) memo_tlb_data_1g[g].rdata <= tlb_data_1g_mem[g][memi_tlb_data_1g[g].raddr];

   if (memi_tlb_tag_2m[ g].we) tlb_tag_2m_mem[ g][memi_tlb_tag_2m[ g].waddr] <= memi_tlb_tag_2m[ g].wdata;
   if (memi_tlb_data_2m[g].we) tlb_data_2m_mem[g][memi_tlb_data_2m[g].waddr] <= memi_tlb_data_2m[g].wdata;
   if (memi_tlb_tag_1g[ g].we) tlb_tag_1g_mem[ g][memi_tlb_tag_1g[ g].waddr] <= memi_tlb_tag_1g[ g].wdata;
   if (memi_tlb_data_1g[g].we) tlb_data_1g_mem[g][memi_tlb_data_1g[g].waddr] <= memi_tlb_data_1g[g].wdata;
  end

 end
endgenerate

// Hardcoding these memory solution ports for 8 ways.  Need to change if number of ways is changed.

assign memi_tlb_tag0_4k    = memi_tlb_tag_4k[0];
assign memi_tlb_tag1_4k    = memi_tlb_tag_4k[1];
assign memi_tlb_tag2_4k    = memi_tlb_tag_4k[2];
assign memi_tlb_tag3_4k    = memi_tlb_tag_4k[3];
assign memi_tlb_tag4_4k    = memi_tlb_tag_4k[4];
assign memi_tlb_tag5_4k    = memi_tlb_tag_4k[5];
assign memi_tlb_tag6_4k    = memi_tlb_tag_4k[6];
assign memi_tlb_tag7_4k    = memi_tlb_tag_4k[7];

assign memi_tlb_data0_4k   = memi_tlb_data_4k[0];
assign memi_tlb_data1_4k   = memi_tlb_data_4k[1];
assign memi_tlb_data2_4k   = memi_tlb_data_4k[2];
assign memi_tlb_data3_4k   = memi_tlb_data_4k[3];
assign memi_tlb_data4_4k   = memi_tlb_data_4k[4];
assign memi_tlb_data5_4k   = memi_tlb_data_4k[5];
assign memi_tlb_data6_4k   = memi_tlb_data_4k[6];
assign memi_tlb_data7_4k   = memi_tlb_data_4k[7];

assign memo_tlb_tag_4k[0]  = memo_tlb_tag0_4k;
assign memo_tlb_tag_4k[1]  = memo_tlb_tag1_4k;
assign memo_tlb_tag_4k[2]  = memo_tlb_tag2_4k;
assign memo_tlb_tag_4k[3]  = memo_tlb_tag3_4k;
assign memo_tlb_tag_4k[4]  = memo_tlb_tag4_4k;
assign memo_tlb_tag_4k[5]  = memo_tlb_tag5_4k;
assign memo_tlb_tag_4k[6]  = memo_tlb_tag6_4k;
assign memo_tlb_tag_4k[7]  = memo_tlb_tag7_4k;

assign memo_tlb_data_4k[0] = memo_tlb_data0_4k;
assign memo_tlb_data_4k[1] = memo_tlb_data1_4k;
assign memo_tlb_data_4k[2] = memo_tlb_data2_4k;
assign memo_tlb_data_4k[3] = memo_tlb_data3_4k;
assign memo_tlb_data_4k[4] = memo_tlb_data4_4k;
assign memo_tlb_data_4k[5] = memo_tlb_data5_4k;
assign memo_tlb_data_4k[6] = memo_tlb_data6_4k;
assign memo_tlb_data_4k[7] = memo_tlb_data7_4k;

//----------------------------------------------------------------------------------------------------
// devtlb instantiation

// The devtlb requires at least 8 clocks of reset w/ clocks running, so stretching the resets here

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin
 if (~prim_gated_rst_b) begin
  devtlb_reset_q <= '1;
 end else begin
  devtlb_reset_q <= {1'b0, devtlb_reset_q[9:1]};
 end
end

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_wflr_rst_b) begin
 if (~prim_gated_wflr_rst_b) begin
  devtlb_flr_q   <= '1;
 end else begin
  devtlb_flr_q   <= {1'b0, devtlb_flr_q[9:1]};
 end
end

assign devtlb_reset = devtlb_reset_q[0];
assign devtlb_flr   = devtlb_reset_q[0] | devtlb_flr_q[0];

hqm_devtlb i_hqm_devtlb (

     .clk                               (prim_nonflr_clk)               // I: Unit Clock
    ,.flreset                           (devtlb_flr)                    // I: Reset the Unit
    ,.full_reset                        (devtlb_reset)                  // I: Non Func Level reset.

    ,.fscan_byprst_b                    (fscan_byprst_b)                // I:
    ,.fscan_clkungate                   (fscan_clkungate)               // I:
    ,.fscan_clkungate_syn               (fscan_clkungate_syn)           // I:
    ,.fscan_latchclosed_b               (fscan_latchclosed_b)           // I:
    ,.fscan_latchopen                   (fscan_latchopen)               // I:
    ,.fscan_mode                        (fscan_mode)                    // I:
    ,.fscan_rstbypen                    (fscan_rstbypen)                // I:
    ,.fscan_shiften                     (fscan_shiften)                 // I:

    ,.fscan_clkgenctrl                  ('0)                            // I: Not used in devtlb
    ,.fscan_clkgenctrlen                ('0)                            // I: Not used in devtlb
    ,.fscan_ram_wrdis_b                 ('1)                            // I: Not used in devtlb
    ,.fscan_ram_rddis_b                 ('1)                            // I: Not used in devtlb
    ,.fscan_ram_odis_b                  ('1)                            // I: Not used in devtlb
    ,.fsta_afd_en                       ('0)                            // I: Not used in devtlb
    ,.fsta_dfxact_afd                   ('0)                            // I: Not used in devtlb
    ,.fdfx_earlyboot_exit               ('0)                            // I: Not used in devtlb

    ,.xreqs_active                      (xreqs_active)                  // O: IOMMU is currently not performing any translation requests or sequencer flows
    ,.tlb_reset_active                  (tlb_reset_active)              // O: high is tlb inv due to reset or implicit inval is in progress.
    ,.invreqs_active                    (invreqs_active)                // O: high is any inv req in invq.

    ,.implicit_invalidation_valid       (imp_invalidation_v)            // I: Triggers an invalidation of all IOMMU TLBs/PWCs.
    ,.implicit_invalidation_bdf_valid   (imp_invalidation_bdf_v)        // I:
    ,.implicit_invalidation_bdf         (imp_invalidation_bdf)          // I:

    ,.scr_loxreq_gcnt                   (scr_loxreq_gcnt)               // I: TLB Arbiter Grant count, one based.
    ,.scr_hixreq_gcnt                   (scr_hixreq_gcnt)               // I:
    ,.scr_pendq_gcnt                    (scr_pendq_gcnt)                // I:
    ,.scr_fill_gcnt                     (scr_fill_gcnt)                 // I:
    ,.scr_prs_continuous_retry          (scr_prs_continuous_retry)      // I:
    ,.scr_disable_prs                   (scr_disable_prs)               // I:
    ,.scr_disable_2m                    (scr_disable_2m)                // I:
    ,.scr_disable_1g                    (scr_disable_1g)                // I:
    ,.scr_spare                         (scr_spare)                     // I:

    ,.PRSSTS_stopped                    (PRSSTS_stopped_nc)             // O:
    ,.PRSSTS_uprgi                      (PRSSTS_uprgi_nc)               // O:
    ,.PRSSTS_rf                         (PRSSTS_rf_nc)                  // O:
    ,.PRSREQALLOC_alloc                 (PRSREQALLOC_alloc)             // I:

    ,.atsreq_valid                      (ats_req_v)                     // O:
    ,.atsreq_pasid_valid                (ats_req.pasid_valid)           // O:
    ,.atsreq_pasid_priv                 (ats_req.pasid_priv)            // O:
    ,.atsreq_pasid                      (ats_req.pasid)                 // O:
    ,.atsreq_id                         (ats_req.id)                    // O:
    ,.atsreq_tc                         (ats_req.tc)                    // O:
    ,.atsreq_nw                         (ats_req.nw)                    // O:
    ,.atsreq_bdf                        (ats_req.bdf)                   // O:
    ,.atsreq_address                    (ats_req.address)               // O:
    ,.atsreq_ack                        (ats_req_ack)                   // I:

    ,.atsrsp_valid                      (ats_rsp_v)                     // I:
    ,.atsrsp_id                         (ats_rsp.id)                    // I:
    ,.atsrsp_dperror                    (ats_rsp.dperror)               // I:
    ,.atsrsp_hdrerror                   (ats_rsp.hdrerror)              // I:
    ,.atsrsp_data                       (ats_rsp.data)                  // I:

    ,.rx_msg_valid                      (rx_msg_v)                      // I:
    ,.rx_msg_pasid_valid                (rx_msg.pasid_valid)            // I:
    ,.rx_msg_pasid_priv                 (rx_msg.pasid_priv)             // I:
    ,.rx_msg_pasid                      (rx_msg.pasid)                  // I:
    ,.rx_msg_opcode                     (rx_msg.opcode)                 // I:
    ,.rx_msg_dperror                    (rx_msg.dperror)                // I:
    ,.rx_msg_invreq_itag                (rx_msg.invreq_itag)            // I:
    ,.rx_msg_invreq_reqid               (rx_msg.invreq_reqid)           // I:
    ,.rx_msg_dw2                        (rx_msg.dw2)                    // I:
    ,.rx_msg_data                       (rx_msg.data)                   // I:

    ,.tx_msg_valid                      (tx_msg_v)                      // O:
    ,.tx_msg_pasid_valid                (tx_msg.pasid_valid)            // O:
    ,.tx_msg_pasid_priv                 (tx_msg.pasid_priv)             // O:
    ,.tx_msg_pasid                      (tx_msg.pasid)                  // O:
    ,.tx_msg_opcode                     (tx_msg.opcode)                 // O:
    ,.tx_msg_tc                         (tx_msg.tc)                     // O:
    ,.tx_msg_bdf                        (tx_msg.bdf)                    // O:
    ,.tx_msg_dw2                        (tx_msg.dw2)                    // O:
    ,.tx_msg_dw3                        (tx_msg.dw3)                    // O:

    ,.tx_msg_ack                        (tx_msg_ack)                    // I:

    ,.xreq_valid                        (devtlb_req_v)                  // I: translation request is valid
    ,.xreq_pasid_valid                  (devtlb_req.pasid_valid)        // I:
    ,.xreq_pasid_priv                   (devtlb_req.pasid_priv)         // I:
    ,.xreq_pasid                        (devtlb_req.pasid)              // I:
    ,.xreq_id                           (devtlb_req.id)                 // I: Transaction ID width=log2(customer buffer size)
    ,.xreq_tlbid                        (devtlb_req.tlbid)              // I: TLBid
    ,.xreq_priority                     (devtlb_req.ppriority)          // I: request priority
    ,.xreq_prs                          (devtlb_req.prs)                // I:
    ,.xreq_opcode                       (devtlb_req.opcode)             // I: Customer intended use for translated address
    ,.xreq_tc                           (devtlb_req.tc)                 // I: Transaction's Traffic class
    ,.xreq_bdf                          (devtlb_req.bdf)                // I:
    ,.xreq_address                      (devtlb_req.address)            // I: Address that needs to be translated.

    ,.xreq_lcrd_inc                     (devtlb_lcrd_inc)               // O: Credit return for Low priority request
    ,.xreq_hcrd_inc                     (devtlb_hcrd_inc)               // O: Credite return for high priority request

    ,.xrsp_valid                        (devtlb_rsp_v)                  // O: Translation Response valid
    ,.xrsp_result                       (devtlb_rsp.result)             // O: Response status: 1=success (translated) 0=failure.
    ,.xrsp_dperror                      (devtlb_rsp.dperror)            // O: data parity error was seen as part of translation request
    ,.xrsp_hdrerror                     (devtlb_rsp.hdrerror)           // O: a header error was seen as part of ATS request (e.g. UR, CA, CTO, etc).
    ,.xrsp_nonsnooped                   (devtlb_rsp.nonsnooped)         // O: 1 if the translated address should be accessed with non-snoop cycle.
    ,.xrsp_prs_code                     (devtlb_rsp.prs_code)           // O:
    ,.xrsp_id                           (devtlb_rsp.id)                 // O: Transaction ID
    ,.xrsp_address                      (devtlb_rsp.address)            // O: Translated Address

    ,.drainreq_valid                    (drain_req_v)                   // O: request to drain ALL transaction in Q
    ,.drainreq_pasid                    (drain_req.pasid)               // O:
    ,.drainreq_pasid_priv               (drain_req.pasid_priv)          // O:
    ,.drainreq_pasid_valid              (drain_req.pasid_valid)         // O:
    ,.drainreq_pasid_global             (drain_req.pasid_global)        // O:
    ,.drainreq_bdf                      (drain_req.bdf)                 // O:
    ,.drainreq_ack                      (drain_req_ack)                 // I: set when a drainreq is accepted.

    ,.drainrsp_valid                    (drain_rsp_v)                   // I: set when a drain req is processed, i.e outstanding request are flushed or marked for translation retry.
    ,.drainrsp_tc                       (drain_rsp.tc)                  // I: Traffic Class (bitwise) used by the hosting unit for all transaction.

    ,.defeature_misc_dis                (cfg_devtlb_defeature0)         // I:
    ,.defeature_pwrdwn_ovrd_dis         (cfg_devtlb_defeature1)         // I:
    ,.defeature_parity_injection        (cfg_devtlb_defeature2)         // I:

    ,.tlb_tag_parity_err                (tlb_tag_parity_err)            // O:
    ,.tlb_data_parity_err               (tlb_data_parity_err)           // O:

    ,.debugbus                          ()                              // O: TBD: Wire up debugbus?

    ,.EXT_RF_IOTLB_4k_Tag_RdEn          (EXT_RF_IOTLB_4k_Tag_RdEn)      // O:
    ,.EXT_RF_IOTLB_4k_Tag_RdAddr        (EXT_RF_IOTLB_4k_Tag_RdAddr)    // O:
    ,.EXT_RF_IOTLB_4k_Tag_RdData        (EXT_RF_IOTLB_4k_Tag_RdData)    // I:
    ,.EXT_RF_IOTLB_4k_Tag_WrEn          (EXT_RF_IOTLB_4k_Tag_WrEn)      // O:
    ,.EXT_RF_IOTLB_4k_Tag_WrAddr        (EXT_RF_IOTLB_4k_Tag_WrAddr)    // O:
    ,.EXT_RF_IOTLB_4k_Tag_WrData        (EXT_RF_IOTLB_4k_Tag_WrData)    // O:

    ,.EXT_RF_IOTLB_4k_Data_RdEn         (EXT_RF_IOTLB_4k_Data_RdEn)     // O:
    ,.EXT_RF_IOTLB_4k_Data_RdAddr       (EXT_RF_IOTLB_4k_Data_RdAddr)   // O:
    ,.EXT_RF_IOTLB_4k_Data_RdData       (EXT_RF_IOTLB_4k_Data_RdData)   // I:
    ,.EXT_RF_IOTLB_4k_Data_WrEn         (EXT_RF_IOTLB_4k_Data_WrEn)     // O:
    ,.EXT_RF_IOTLB_4k_Data_WrAddr       (EXT_RF_IOTLB_4k_Data_WrAddr)   // O:
    ,.EXT_RF_IOTLB_4k_Data_WrData       (EXT_RF_IOTLB_4k_Data_WrData)   // O:

    ,.EXT_RF_IOTLB_2m_Tag_RdEn          (EXT_RF_IOTLB_2m_Tag_RdEn)      // O:
    ,.EXT_RF_IOTLB_2m_Tag_RdAddr        (EXT_RF_IOTLB_2m_Tag_RdAddr)    // O:
    ,.EXT_RF_IOTLB_2m_Tag_RdData        (EXT_RF_IOTLB_2m_Tag_RdData)    // I:
    ,.EXT_RF_IOTLB_2m_Tag_WrEn          (EXT_RF_IOTLB_2m_Tag_WrEn)      // O:
    ,.EXT_RF_IOTLB_2m_Tag_WrAddr        (EXT_RF_IOTLB_2m_Tag_WrAddr)    // O:
    ,.EXT_RF_IOTLB_2m_Tag_WrData        (EXT_RF_IOTLB_2m_Tag_WrData)    // O:

    ,.EXT_RF_IOTLB_2m_Data_RdEn         (EXT_RF_IOTLB_2m_Data_RdEn)     // O:
    ,.EXT_RF_IOTLB_2m_Data_RdAddr       (EXT_RF_IOTLB_2m_Data_RdAddr)   // O:
    ,.EXT_RF_IOTLB_2m_Data_RdData       (EXT_RF_IOTLB_2m_Data_RdData)   // I:
    ,.EXT_RF_IOTLB_2m_Data_WrEn         (EXT_RF_IOTLB_2m_Data_WrEn)     // O:
    ,.EXT_RF_IOTLB_2m_Data_WrAddr       (EXT_RF_IOTLB_2m_Data_WrAddr)   // O:
    ,.EXT_RF_IOTLB_2m_Data_WrData       (EXT_RF_IOTLB_2m_Data_WrData)   // O:

    ,.EXT_RF_IOTLB_1g_Tag_RdEn          (EXT_RF_IOTLB_1g_Tag_RdEn)      // O:
    ,.EXT_RF_IOTLB_1g_Tag_RdAddr        (EXT_RF_IOTLB_1g_Tag_RdAddr)    // O:
    ,.EXT_RF_IOTLB_1g_Tag_RdData        (EXT_RF_IOTLB_1g_Tag_RdData)    // I:
    ,.EXT_RF_IOTLB_1g_Tag_WrEn          (EXT_RF_IOTLB_1g_Tag_WrEn)      // O:
    ,.EXT_RF_IOTLB_1g_Tag_WrAddr        (EXT_RF_IOTLB_1g_Tag_WrAddr)    // O:
    ,.EXT_RF_IOTLB_1g_Tag_WrData        (EXT_RF_IOTLB_1g_Tag_WrData)    // O:

    ,.EXT_RF_IOTLB_1g_Data_RdEn         (EXT_RF_IOTLB_1g_Data_RdEn)     // O:
    ,.EXT_RF_IOTLB_1g_Data_RdAddr       (EXT_RF_IOTLB_1g_Data_RdAddr)   // O:
    ,.EXT_RF_IOTLB_1g_Data_RdData       (EXT_RF_IOTLB_1g_Data_RdData)   // I:
    ,.EXT_RF_IOTLB_1g_Data_WrEn         (EXT_RF_IOTLB_1g_Data_WrEn)     // O:
    ,.EXT_RF_IOTLB_1g_Data_WrAddr       (EXT_RF_IOTLB_1g_Data_WrAddr)   // O:
    ,.EXT_RF_IOTLB_1g_Data_WrData       (EXT_RF_IOTLB_1g_Data_WrData)   // O:
);

//----------------------------------------------------------------------------------------------------
// devtlb configuration

always_comb begin

 scr_loxreq_gcnt                = cfg_devtlb_ctl.LOXREQ_GCNT;
 scr_hixreq_gcnt                = cfg_devtlb_ctl.HIXREQ_GCNT;
 scr_pendq_gcnt                 = cfg_devtlb_ctl.PENDQ_GCNT;
 scr_fill_gcnt                  = cfg_devtlb_ctl.FILL_GCNT;
 scr_prs_continuous_retry       = cfg_devtlb_ctl.PRS_CRETRY;
 scr_disable_prs                = cfg_devtlb_ctl.DISABLE_PRS;
 scr_disable_2m                 = cfg_devtlb_ctl.DISABLE_2M;
 scr_disable_1g                 = cfg_devtlb_ctl.DISABLE_1G;
 scr_spare                      = cfg_devtlb_spare;

 // PRS unused

 PRSREQALLOC_alloc              = '0;

 // Status

 devtlb_status.XREQ_CNT         = xreq_cnt_q;
 devtlb_status.ATS_REQ_CNT      = ats_req_cnt_q;
 devtlb_status.DRAIN_REQ_V      = drain_req_v;
 devtlb_status.TX_MSG_V         = tx_msg_v;
 devtlb_status.ATS_HREQ_V       = ats_req_v[1];
 devtlb_status.ATS_LREQ_V       = ats_req_v[0];
 devtlb_status.HCRD_CNT         = devtlb_hcrd_q;
 devtlb_status.LCRD_CNT         = devtlb_lcrd_q;
 devtlb_status.ATS_ENABLED      = cfg_ats_enabled_q;
 devtlb_status.XREQS_ACTIVE     = xreqs_active;
 devtlb_status.INVREQS_ACTIVE   = invreqs_active;
 devtlb_status.RESET_ACTIVE     = tlb_reset_active;

end

hqm_AW_unused_bits i_unused_prs (

     .a     (|{
                 PRSSTS_stopped_nc
                ,PRSSTS_uprgi_nc
                ,PRSSTS_rf_nc
            })
);

//----------------------------------------------------------------------------------------------------
// Initiate an implicit devtlb invalidation whenever ATS is enabled

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin
 if (~prim_gated_rst_b) begin
  cfg_ats_enabled_q <= '0;
 end else begin
  cfg_ats_enabled_q <= cfg_ats_enabled;
 end
end

assign cfg_ats_enabled_redge = cfg_ats_enabled & ~cfg_ats_enabled_q;

always_comb begin

 imp_invalidation_v         = cfg_ats_enabled_redge;
 imp_invalidation_bdf_v     = '0;
 imp_invalidation_bdf       = '0;

end

//----------------------------------------------------------------------------------------------------
// devtlb HP and LP xreq credit counters

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin
 if (~prim_gated_rst_b) begin
  devtlb_hcrd_q <= DEVTLB_HCB_DEPTH[DEVTLB_HCB_DEPTH_WIDTH-1:0];
  devtlb_lcrd_q <= DEVTLB_LCB_DEPTH[DEVTLB_LCB_DEPTH_WIDTH-1:0];
 end else begin
  devtlb_hcrd_q <= devtlb_hcrd_next;
  devtlb_lcrd_q <= devtlb_lcrd_next;
 end
end

always_comb begin

 case ({(devtlb_hcrd_inc & ~devtlb_reset), devtlb_hcrd_dec})
  2'b10:   devtlb_hcrd_next = devtlb_hcrd_q + {{(DEVTLB_HCB_DEPTH_WIDTH-1){1'b0}}, 1'b1};
  2'b01:   devtlb_hcrd_next = devtlb_hcrd_q - {{(DEVTLB_HCB_DEPTH_WIDTH-1){1'b0}}, 1'b1};
  default: devtlb_hcrd_next = devtlb_hcrd_q;
 endcase

 case ({(devtlb_lcrd_inc & ~devtlb_reset), devtlb_lcrd_dec})
  2'b10:   devtlb_lcrd_next = devtlb_lcrd_q + {{(DEVTLB_LCB_DEPTH_WIDTH-1){1'b0}}, 1'b1};
  2'b01:   devtlb_lcrd_next = devtlb_lcrd_q - {{(DEVTLB_LCB_DEPTH_WIDTH-1){1'b0}}, 1'b1};
  default: devtlb_lcrd_next = devtlb_lcrd_q;
 endcase

end

//----------------------------------------------------------------------------------------------------
// LLs for CQ, P, NP, Cpl, and Alarm

hqm_iosf_mstr_ll i_hqm_iosf_mstr_ll (

     .prim_nonflr_clk               (prim_nonflr_clk)                   //I: LL
    ,.prim_gated_rst_b              (prim_gated_rst_b)                  //I: LL

    ,.cfg_mstr_ll_ctl               (cfg_mstr_ll_ctl)                   //I: LL

    ,.mstr_fl_status                (mstr_fl_status)                    //O: LL
    ,.mstr_ll_status                (mstr_ll_status)                    //O: LL

    ,.fl2ll_v                       (fl2ll_v)                           //I: LL
    ,.fl2ll_ll                      (fl2ll_ll)                          //I: LL

    ,.ll2rl_v                       (ll2rl_v)                           //I: LL
    ,.ll2rl_ll                      (ll2rl_ll)                          //I: LL
    ,.ll2rl_rl                      (ll2rl_rl)                          //I: LL

    ,.ll2db_v                       (ll2db_v)                           //I: LL
    ,.ll2db_ll                      (ll2db_ll)                          //I: LL

    ,.rl2db_v                       (rl2db_v)                           //I: LL
    ,.rl2db_rl                      (rl2db_rl)                          //I: LL

    ,.fl_push                       (fl_push)                           //I: LL
    ,.fl_push_ptr                   (fl_push_ptr)                       //I: LL

    ,.fl_empty                      (fl_empty)                          //O: LL
    ,.fl_aempty                     (fl_aempty)                         //O: LL
    ,.fl_full                       (fl_full)                           //O: LL
    ,.fl_hptr                       (fl_hptr)                           //O: LL

    ,.ll_v                          (ll_v)                              //O: LL
    ,.ll_hptr                       (ll_hptr)                           //O: LL

    ,.rl_v                          (rl_v)                              //O: LL
    ,.rl_hptr                       (rl_hptr)                           //O: LL

    ,.blk_v_q                       (blk_v_q)                           //I: LL
    ,.msix_v_q                      (msix_v_q)                          //I: LL

    ,.hpa_v_scaled                  (hpa_v_scaled)                      //I: LL
    ,.hpa_err_scaled                (hpa_err_scaled)                    //I: LL
    ,.hpa_pnd_scaled                (hpa_pnd_scaled)                    //I: LL

    ,.clr_hpa_err                   (clr_hpa_err)                       //O: LL
    ,.clr_hpa_err_cq                (clr_hpa_err_cq)                    //O: LL
);

//----------------------------------------------------------------------------------------------------
// Scoreboard for NP transactions and completions

hqm_iosf_mstr_scrbd i_hqm_iosf_mstr_scrbd (

     .prim_nonflr_clk               (prim_nonflr_clk)                   //I: SCRBD
    ,.prim_gated_rst_b              (prim_gated_rst_b)                  //I: SCRBD

    ,.current_bus                   (current_bus)                       //I: SCRBD

    ,.cfg_scrbd_ctl                 (cfg_scrbd_ctl)                     //I: SCRBD
    ,.cfg_mstr_par_off              (cfg_mstr_par_off)                  //I: SCRBD

    ,.cfg_ibcpl_hdr_fifo_high_wm    (cfg_ibcpl_hdr_fifo_high_wm)        //I: SCRBD
    ,.cfg_ibcpl_data_fifo_high_wm   (cfg_ibcpl_data_fifo_high_wm)       //I: SCRBD

    ,.cfg_ibcpl_hdr_fifo_status     (cfg_ibcpl_hdr_fifo_status)         //O: SCRBD
    ,.cfg_ibcpl_data_fifo_status    (cfg_ibcpl_data_fifo_status)        //O: SCRBD

    ,.scrbd_status                  (scrbd_status)                      //O: SCRBD

    ,.scrbd_tag_v                   (scrbd_tag_v)                       //O: SCRBD
    ,.scrbd_tag                     (scrbd_tag)                         //O: SCRBD

    ,.scrbd_alloc                   (scrbd_alloc)                       //I: SCRBD
    ,.scrbd_alloc_data              (scrbd_alloc_data)                  //I: SCRBD

    ,.scrbd_free                    (scrbd_free)                        //O: SCRBD

    ,.ibcpl_hdr_push                (ibcpl_hdr_push)                    //I: SCRBD
    ,.ibcpl_hdr                     (ibcpl_hdr)                         //I: SCRBD

    ,.ibcpl_data_push               (ibcpl_data_push)                   //I: SCRBD
    ,.ibcpl_data                    (ibcpl_data)                        //I: SCRBD
    ,.ibcpl_data_par                (ibcpl_data_par)                    //I: SCRBD

    ,.cq_np_cnt_dec                 (cq_np_cnt_dec)                     //O: SCRBD

    ,.ats_rsp_v                     (ats_rsp_v)                         //O: SCRBD
    ,.ats_rsp                       (ats_rsp)                           //O: SCRBD

    ,.np_trans_pending              (np_trans_pending)                  //O: SCRBD

    ,.cpl_usr                       (cpl_usr)                           //O: SCRBD
    ,.cpl_abort                     (cpl_abort)                         //O: SCRBD
    ,.cpl_poisoned                  (cpl_poisoned)                      //O: SCRBD
    ,.cpl_unexpected                (cpl_unexpected)                    //O: SCRBD
    ,.cpl_error_hdr                 (cpl_error_hdr)                     //O: SCRBD

    ,.cpl_timeout                   (cpl_timeout)                       //O: SCRBD
    ,.cpl_timeout_synd              (cpl_timeout_synd)                  //O: SCRBD

    ,.scrbd_perr                    (scrbd_perr)                        //O: SCRBD
    ,.ibcpl_hdr_fifo_perr           (ibcpl_hdr_fifo_perr)               //O: SCRBD
    ,.ibcpl_data_fifo_perr          (ibcpl_data_fifo_perr)              //O: SCRBD

    ,.memi_scrbd_mem                (memi_scrbd_mem)                    //I: SCRBD
    ,.memo_scrbd_mem                (memo_scrbd_mem)                    //O: SCRBD

    ,.memi_ibcpl_hdr_fifo           (memi_ibcpl_hdr_fifo)               //I: SCRBD
    ,.memo_ibcpl_hdr_fifo           (memo_ibcpl_hdr_fifo)               //O: SCRBD

    ,.memi_ibcpl_data_fifo          (memi_ibcpl_data_fifo)              //I: SCRBD
    ,.memo_ibcpl_data_fifo          (memo_ibcpl_data_fifo)              //O: SCRBD
);

hqm_AW_width_scale #(.A_WIDTH(HQM_SCRBD_DEPTH_WIDTH), .Z_WIDTH(10)) i_scrbd_tag_10b (

     .a     (scrbd_tag)
    ,.z     (scrbd_tag_10b)
);

//----------------------------------------------------------------------------------------------------
// Convert from obcpl_hdr format to PCIe Cpl/CplD header format

always_comb begin

 cplhdr         = '0;

 // Note that rsvd4(tc[3]), attr2(ido), rsvd0(rsvd1_1), oh(th), rsvd5(RSVD), td,
 // at, and rsvd6(addr[63:32]) are always 0

 // For UR completion, PCI expects length=0 and bc=0, but IOSF expects bc to match the original
 // request.  Therefore, ri_cds will set length to the orignal request length so it can be used
 // to re-calculate the bc here, and we'll zero out the length here.

 cplhdr.fmt     =  {obcpl_hdr.fmt, 1'b0};
 cplhdr.ttype   =  {4'b0101, obcpl_hdr.lok};
 cplhdr.rsvd3   =  (obcpl_hdr.tag[9] & strap_hqm_completertenbittagen);
 cplhdr.tc      =   obcpl_hdr.tc;
 cplhdr.rsvd2   =  (obcpl_hdr.tag[8] & strap_hqm_completertenbittagen);
 cplhdr.ep      =   obcpl_hdr.ep;
 cplhdr.attr[0] =   obcpl_hdr.attr[0];                                  // ns
 cplhdr.attr[1] =   obcpl_hdr.attr[1];                                  // ro
 cplhdr.len     =  (obcpl_hdr.cs == 3'b001) ? '0 : obcpl_hdr.length;
 cplhdr.cplid   =   obcpl_hdr.cid;
 cplhdr.cplstat =   obcpl_hdr.cs;
 cplhdr.bytecnt =  (obcpl_hdr.fmt | (obcpl_hdr.cs == 3'b001)) ?
                    f_hqm_pcie_bytecnt(obcpl_hdr.startbe,obcpl_hdr.endbe,obcpl_hdr.length) :
                    12'h004;
 cplhdr.rqid    =   obcpl_hdr.rid;
 cplhdr.tag     =   obcpl_hdr.tag[7:0];
 cplhdr.lowaddr =   obcpl_hdr.addr;

 cplhdr_par     = ^{obcpl_hdr.par
                   ,obcpl_hdr.pm
                   ,obcpl_hdr.endbe
                   ,obcpl_hdr.startbe
                   ,obcpl_hdr.length
                   ,cplhdr.len
                   ,cplhdr.bytecnt
                   ,(obcpl_hdr.tag[9] & ~strap_hqm_completertenbittagen)
                   ,(obcpl_hdr.tag[8] & ~strap_hqm_completertenbittagen)
                   };
end

//----------------------------------------------------------------------------------------------------
// Convert from write_buffer_mstr.hdr format to PCIe header format
//
// Write buffer is only sending posted writes which will be MWr32 (3DW) or MWr64 (4DW).

always_comb begin

 // Map traffic class for schedule writes based on their CQ.
 // The tc_sel field is the 2b hash select based on the associated CQ.
 // The ldb_cq field is the indication that the CQ was load balanced.
 // Use the above bits to select one of the 8 configured traffic class values.
 // IMS interrupt writes must use the same traffic class mapping function.
 // MSI-X interrupt writes use the configured interrupt traffic class.

 phdr_tc = '0;

 if (write_buffer_mstr.hdr.src == MSIX) begin

  // CQ occupancy MSIX interrupt or alarm MSIX writes

  phdr_tc = int2tc_map.INT_TC;

 end else if (write_buffer_mstr.hdr.cq_ldb) begin

  // LDB schedule or CQ occupancy IMS interrupt write
 
  case (write_buffer_mstr.hdr.tc_sel)
   2'd3:    phdr_tc = ldb_cq2tc_map.LDB3_TC;
   2'd2:    phdr_tc = ldb_cq2tc_map.LDB2_TC;
   2'd1:    phdr_tc = ldb_cq2tc_map.LDB1_TC;
   default: phdr_tc = ldb_cq2tc_map.LDB0_TC;
  endcase

 end else begin

  // DIR schedule or CQ occupancy IMS interrupt write

  case (write_buffer_mstr.hdr.tc_sel)
   2'd3:    phdr_tc = dir_cq2tc_map.DIR3_TC;
   2'd2:    phdr_tc = dir_cq2tc_map.DIR2_TC;
   2'd1:    phdr_tc = dir_cq2tc_map.DIR1_TC;
   default: phdr_tc = dir_cq2tc_map.DIR0_TC;
  endcase

 end

 phdr = '0;

 // Note that rsvd3(rsvd1_7/tag[9]), rsvd2(rsvd1_3/tag[8]), rsvd0(rsvd1_1), oh(th), rsvd5/rsvd6(addr[1:0]),
 // attr2(ido), attr[0](ns), td, ep, tag[7:0], and at[1:0] fields are always 0.
 // Since we always write full DWs, first byte enable is always 4'hf.
 // Last byte enable is also always 4'hf unless it's just a single DW where the spec says it must be 4'h0.

 if (|write_buffer_mstr.hdr.add[63:32]) begin // 4DW

   phdr.pcie64.rsvd4   = phdr_tc[3];
  {phdr.pcie64.fmt
  ,phdr.pcie64.ttype}  = HQM_MWR4;
   phdr.pcie64.tc      = phdr_tc[2:0];
   phdr.pcie64.attr[1] = write_buffer_mstr.hdr.ro & csr_ppdcntl_ero;
   phdr.pcie64.len     = {5'd0, write_buffer_mstr.hdr.length};
   phdr.pcie64.rqid    = {current_bus, 8'd0};
   phdr.pcie64.lbe     = (write_buffer_mstr.hdr.length == 5'd1) ? 4'h0 : 4'hf;
   phdr.pcie64.fbe     = 4'hf;
   phdr.pcie64.addr    = write_buffer_mstr.hdr.add[63:2];

 end else begin // 3DW

   phdr.pcie32.rsvd4   = phdr_tc[3];
  {phdr.pcie32.fmt
  ,phdr.pcie32.ttype}  = HQM_MWR3;
   phdr.pcie32.tc      = phdr_tc[2:0];
   phdr.pcie32.attr[1] = write_buffer_mstr.hdr.ro & csr_ppdcntl_ero;
   phdr.pcie32.len     = {5'd0, write_buffer_mstr.hdr.length};
   phdr.pcie32.rqid    = {current_bus, 8'd0};
   phdr.pcie32.lbe     = (write_buffer_mstr.hdr.length == 5'd1) ? 4'h0 : 4'hf;
   phdr.pcie32.fbe     = 4'hf;
   phdr.pcie32.addr    = write_buffer_mstr.hdr.add[31:2];

 end

 phdr_pasidtlp = write_buffer_mstr.hdr.pasidtlp;

 // Parity covers the following write_buffer_mstr.hdr fields:
 //
 // add_par : add[63:2]
 // len_par : length[4:0]
 // par:    : invalid, num_hcws, src, cq_v, cq_ldb, cq, ro, pasidtlp, tc_sel
 //
 // Only add, length, and pasidtlp are passed directly to the phdr, so need to adjust for the other fields.

 phdr_par = ^{ write_buffer_mstr.hdr.par
             , write_buffer_mstr.hdr.add_par
             , write_buffer_mstr.hdr.len_par
             , write_buffer_mstr.hdr.invalid
             , write_buffer_mstr.hdr.num_hcws
             , write_buffer_mstr.hdr.src
             , write_buffer_mstr.hdr.cq_v
             , write_buffer_mstr.hdr.cq_ldb
             , write_buffer_mstr.hdr.cq
             ,(write_buffer_mstr.hdr.ro & ~csr_ppdcntl_ero)
             , write_buffer_mstr.hdr.tc_sel
             , phdr.pcie32.rsvd4
             , phdr.pcie32.fmt
             , phdr.pcie32.ttype
             , phdr.pcie32.tc
             , current_bus
             };

end //always_comb

//----------------------------------------------------------------------------------------------------
// HAP Channel IDs
//
// 0: ordered   (ints)
// 1: unordered (main data path)
// 2: unordered (unused)
// 3: unordered (ATS requests)

//----------------------------------------------------------------------------------------------------
// For a write that turns off BME, we need to stop mastering any transactions except for completions
// AND ATS Invalidate Responses.  From a bus POV, we should not master any transactions (w/ the noted
// exceptions) after the completion for the BME reset has been sent out.
// The easiest way to do this would be to recognize the completion for the BME=0 write, hold it and
// prevent further IOSF requests, and wait until we have sent out any transactions for which we've
// already sent an IOSF request, and then send the completion.  We can set a piece of state that
// prevents further CQ or NP LLs from looking valid to the RL arbiter.  This would allow P (which are
// currently only ATS Invalidate responses) and completions to proceed after this completion has been
// sent.  I don't think we need to do any type of other draining and throwing away of requests; we
// can just pick up where we left off if BME is set to 1.

//----------------------------------------------------------------------------------------------------
// For a write that turns off MSIXE, we need to stop mastering MSIX writes.  From a bus POV, we should
// not master any MSIX writes after the completion for the MSIXE reset has been sent out.  In the past
// we've thrown these MSIX writes away, but I think it would be better to have a mechanism for draining
// these interrupt writes and setting the appropriate pending bit for them back in the system.  That
// seems complicated and problematic, though.

//----------------------------------------------------------------------------------------------------
// Input transaction processing to add transactions to the appropriate LL

hqm_AW_width_scale #(.A_WIDTH(HQM_SYSTEM_CQ_WIDTH), .Z_WIDTH(HQM_MSTR_NUM_LLS_WIDTH)) i_wb_cq_scaled (

     .a     (write_buffer_mstr.hdr.cq)
    ,.z     (wb_cq_scaled)
);

always_comb begin

 // Convert hptr vectors to MDAs

 for (int i=0; i<(1<<HQM_MSTR_NUM_LLS_WIDTH); i=i+1) begin
  ll_hptr_mda[i] = (i<HQM_MSTR_NUM_LLS) ? ll_hptr[i* HQM_MSTR_FL_DEPTH_WIDTH +:  HQM_MSTR_FL_DEPTH_WIDTH] : '0;
 end

 for (int i=0; i<4; i=i+1) begin
  rl_hptr_mda[i] = (i<3) ? rl_hptr[i* HQM_MSTR_FL_DEPTH_WIDTH +:  HQM_MSTR_FL_DEPTH_WIDTH] : '0;
 end

 // cq_ldb and cq are setup for CQ and interrupt writes.  cq_v and src distinguish the cases.
 // Putting interrupts on the tail of the LL for the CQ they are associated with.
 // Alarm interrupts go on their own LL.

 wb_cq = (write_buffer_mstr.hdr.cq_ldb) ? (wb_cq_scaled + NUM_DIR_CQ[HQM_MSTR_NUM_LLS_WIDTH-1:0])
                                        :  wb_cq_scaled;

 // src  cq_v
 // PW    x    Other posted write (no other P writes are POR right now)
 // SCH   x    CQ    posted write
 // MSIX  0    Alarm MSI-X interrupt write
 // MSIX  1    CQ    MSI-X interrupt write
 // AI    x    CQ    IMS   interrupt write

 wb_pw               = write_buffer_mstr_v & (write_buffer_mstr.hdr.src ==   PW);
 wb_pcq              = write_buffer_mstr_v & (write_buffer_mstr.hdr.src ==  SCH);
 wb_msix             = write_buffer_mstr_v & (write_buffer_mstr.hdr.src == MSIX);
 wb_ims              = write_buffer_mstr_v & (write_buffer_mstr.hdr.src ==   AI);
 wb_alarm            = wb_msix & ~write_buffer_mstr.hdr.cq_v;

 // Only POR transaction right now that needs ATS are the CQ writes.

 wb_tlb_reqd         = cfg_ats_enabled_q & wb_pcq;
                   
 wb_ll               = (wb_alarm) ? HQM_MSTR_INT_LL[HQM_MSTR_NUM_LLS_WIDTH-1:0] :
                      ((wb_pw)    ? HQM_MSTR_P_LL[  HQM_MSTR_NUM_LLS_WIDTH-1:0] : wb_cq);

 wb_drop_msixe       = '0;
 wb_drop_invalid     = '0;
 wb_drop_cq          = '0;
                   
 blk_v_next          = blk_v_q;
 msix_v_next         = msix_v_q;

 hpa_v_next          = '0;
 hpa_err_next        = '0;
 hpa_pnd_next        = '0;

 hpa_v_next[  HQM_MSTR_NUM_CQS-1:0] = hpa_v_q;
 hpa_err_next[HQM_MSTR_NUM_CQS-1:0] = hpa_err_q;
 hpa_pnd_next[HQM_MSTR_NUM_CQS-1:0] = hpa_pnd_q;

                   
 fl2ll_v             = '0;
 fl2ll_ll            = wb_ll;
                   
 devtlb_req_v        = '0;
 devtlb_req          = '0;
                   
 devtlb_hcrd_dec     = '0;
 devtlb_lcrd_dec     = '0;
                   
 tx_msg_ack          = '0;
                   
 scrbd_alloc         = '0;
 scrbd_alloc_data    = '0;
                     
 devtlb_ats_alarm    = '0;
 set_devtlb_ats_err  = '0;
                     
 atshdr_ready        = '0;
 obcpl_ready         = '0;
                     
 flr_cpl_sent_next   = '0;
 ps_cpl_sent_next    = '0;
 ps_d0               = '0;
 block_cq_p_np_lls   = '0;
 drain_cq_p_np_lls   = '0;
 allow_bme_update    = '0;
 allow_msixe_update  = '0;

 sent_bme_cpl_next   = sent_bme_cpl_q;
 sent_msixe_cpl_next = sent_msixe_cpl_q;

 xreq_cnt_dec        = '0;
 xreq_cnt_inc        = '0;

 xreq_cnt_lt_limit   = (xreq_cnt_q < cfg_scrbd_ctl.XREQ_LIMIT);

 invrsphdr_pasidtlp  = {
                        tx_msg.pasid_valid
                       ,tx_msg.pasid_priv
                       ,1'b0
                       ,tx_msg.pasid
                       };

 invrsphdr           = '0;

 // Note that rsvd4(tc[3]), rsvd3(rsvd1_7), rsvd2(rsvd1_3), attr2(ido), rsvd0(rsvd1_1), oh(th),
 // td, ep, attr, rsvd5(addr[1]), at[1:0], length, tag are always 0

 // tx_msg.opcode should always be 0 for invrsp since PRS is not supported

 invrsphdr.pciemsg.fmt      = 2'h1;
 invrsphdr.pciemsg.ttype    = 5'h12;
 invrsphdr.pciemsg.tc       = tx_msg.tc;
 invrsphdr.pciemsg.rqid     = tx_msg.bdf;
 invrsphdr.pciemsg.msgcode  = 8'h02;
 invrsphdr.pciemsg.rsvd5    = {tx_msg.dw3, tx_msg.dw2};

 invrsphdr_par              = ^{invrsphdr_pasidtlp, invrsphdr.pcie32};

 write_buffer_mstr_ready    = '0;

 memi_mstr_ll_hpa_next.we      = '0;
 memi_mstr_ll_hpa_next.waddr   = devtlb_rsp.id;
 memi_mstr_ll_hpa_next.wdata   = {(^devtlb_rsp.address), devtlb_rsp.address};

 memi_mstr_ll_hdr_next.we      = '0;
 memi_mstr_ll_hdr_next.waddr   = fl_hptr;
 memi_mstr_ll_hdr_next.wdata   = {atshdr_par, 1'b0, atshdr_pasidtlp, atshdr};

 memi_mstr_ll_data0_next.we    = '0;
 memi_mstr_ll_data0_next.waddr = fl_hptr;
 memi_mstr_ll_data0_next.wdata = {(^write_buffer_mstr.data_ls.dpar[3:0]), write_buffer_mstr.data_ls.data[127:0]};

 memi_mstr_ll_data1_next.we    = '0;
 memi_mstr_ll_data1_next.waddr = fl_hptr;
 memi_mstr_ll_data1_next.wdata = {(^write_buffer_mstr.data_ls.dpar[7:4]), write_buffer_mstr.data_ls.data[255:128]};

 memi_mstr_ll_data2_next.we    = '0;
 memi_mstr_ll_data2_next.waddr = fl_hptr;
 memi_mstr_ll_data2_next.wdata = {(^write_buffer_mstr.data_ms.dpar[3:0]), write_buffer_mstr.data_ms.data[127:0]};

 memi_mstr_ll_data3_next.we    = '0;
 memi_mstr_ll_data3_next.waddr = fl_hptr;
 memi_mstr_ll_data3_next.wdata = {(^write_buffer_mstr.data_ms.dpar[7:4]), write_buffer_mstr.data_ms.data[255:128]};

 //---------------------------------------------------------------------------------------------------
 // Outbound completions

 if (obcpl_v) begin // OBCPL valid

  //--------------------------------------------------------------------------------------------------
  // If this is the completion for a write that turned off BME, need to stop mastering new transactions
  // (except for completions and invalidate responses (which are posted messages)).  The spec rule is
  // that we should master no more transactions on the bus after the completion for the write that
  // turned off BME is seen on the bus.
  // We'll use the local BME bit to make any current CQ P or NP LLs look invalid to the LL arbiter so
  // there are no more IOSF requests generated.  Then wait until we've flushed out any existing P or NP
  // transactions for which we've already sent an IOSF request, and then we can send out this completion.

  if ((obcpl_hdr.cs == 3'd0) & ~obcpl_hdr.fmt &
      (obcpl_enables.enable == BME) & ~obcpl_enables.value & local_bme) begin // BME 1->0 Cpl

   if (~sif_mstr_quiesce_req_q) begin // Not quiescing

    // Block CQ P and NP LLs from LL arbiter
  
    block_cq_p_np_lls = '1;
  
    if (~fl_aempty & ~(|{rl_v[1:0], iosf_db_fill_cnt_q[1], iosf_db_fill_cnt_q[0]})) begin // Send Cpl
  
     allow_bme_update    = '1;
  
     obcpl_ready         = '1;
  
     fl2ll_v             = '1;
     fl2ll_ll            = HQM_MSTR_CPL_LL[HQM_MSTR_NUM_LLS_WIDTH-1:0];
  
     blk_v_next[fl_hptr] = '1;
  
     memi_mstr_ll_hdr_next.we    = '1;
     memi_mstr_ll_hdr_next.wdata = {cplhdr_par, 1'b0, {$bits(hqm_pasidtlp_t){1'b0}}, cplhdr};
  
     // BME write completion is Cpl and not CplD, so no data
      
    end // Send Cpl

   end // Not quiescing

  end // BME 1->0 Cpl

  //--------------------------------------------------------------------------------------------------
  // If this is the completion for a write that turned on BME, can start mastering new transactions.
  // The spec rule is that we can master a transaction on the bus after the completion for the write
  // that turned on BME is seen on the bus.
  // So, send out the BME=1 completion and wait for it to go out on the bus before updating the local
  // BME bit to allow the LL arbiter to see any other pending CQ P and NP LL transactions.

  else if ((obcpl_hdr.cs == 3'd0) & ~obcpl_hdr.fmt &
           (obcpl_enables.enable == BME) & obcpl_enables.value & ~local_bme) begin // BME 0->1 Cpl

   if (~sif_mstr_quiesce_req_q) begin // Not quiescing

    if (~sent_bme_cpl_q) begin // Cpl not yet sent
   
     if (~fl_aempty) begin // Send Cpl
   
      sent_bme_cpl_next   = '1;
   
      fl2ll_v             = '1;
      fl2ll_ll            = HQM_MSTR_CPL_LL[HQM_MSTR_NUM_LLS_WIDTH-1:0];
   
      blk_v_next[fl_hptr] = '1;
   
      memi_mstr_ll_hdr_next.we    = '1;
      memi_mstr_ll_hdr_next.wdata = {cplhdr_par, 1'b0, {$bits(hqm_pasidtlp_t){1'b0}}, cplhdr};
   
      // BME write completion is Cpl and not CplD, so no data
   
     end // Send Cpl
   
    end // Cpl not yet sent
   
    else if (~(|{ll_v[HQM_MSTR_CPL_LL], rl_v[2], iosf_db_fill_cnt_q[2]})) begin // Cpl sent
   
     // Allow the local BME update and pop the Cpl
   
     sent_bme_cpl_next = '0;
   
     allow_bme_update  = '1;
   
     obcpl_ready       = '1;
      
    end // Cpl sent

   end // Not quiescing

  end // BME=1 Cpl

  //--------------------------------------------------------------------------------------------------
  // If this is the completion for a write that turned off MSIXE, need to stop mastering new MSIX
  // interrupts.  The spec rule is that we should master no more MSIX writes on the bus after the
  // completion for the write that turned off MSIXE is seen on the bus.
  // Since MSIXE=0 will stop the write buffer from generating new MSIX writes, we can wait for any
  // existing MSIX writes to be issued before allowing the local MSIXE update.

  else if ((obcpl_hdr.cs == 3'd0) & ~obcpl_hdr.fmt &
      (obcpl_enables.enable == MSIXE) & ~obcpl_enables.value & local_msixe) begin // MSIXE 1->0 Cpl

   if (~sif_mstr_quiesce_req_q) begin // Not quiescing

    if (~sent_msixe_cpl_q) begin // Cpl not yet sent
   
     if (~(|msix_v_q) & ~fl_aempty) begin // Send Cpl
   
      // Send completion when we have no more outstanding interrupts queued
   
      sent_msixe_cpl_next = '1;
   
      fl2ll_v             = '1;
      fl2ll_ll            = HQM_MSTR_CPL_LL[HQM_MSTR_NUM_LLS_WIDTH-1:0];
   
      blk_v_next[fl_hptr] = '1;
   
      memi_mstr_ll_hdr_next.we    = '1;
      memi_mstr_ll_hdr_next.wdata = {cplhdr_par, 1'b0, {$bits(hqm_pasidtlp_t){1'b0}}, cplhdr};
   
      // MSIXE write completion is Cpl and not CplD, so no data
   
     end
   
    end // Cpl not yet sent
   
    else if (~(|{ll_v[HQM_MSTR_CPL_LL], rl_v[2], iosf_db_fill_cnt_q[2]})) begin // Cpl sent
   
     // Allow the local MSIXE update and pop the Cpl
   
     sent_msixe_cpl_next = '0;
   
     allow_msixe_update  = '1;
   
     obcpl_ready         = '1;
      
    end // Cpl sent

   end // Not quiescing

  end // MSIXE 1->0 Cpl

  //--------------------------------------------------------------------------------------------------
  // If this is the completion for a write that turned on MSIXE, can start mastering new MSIX
  // interrupts.  The spec rule is that we can master MSIX writes on the bus after the completion
  // for the write that turned on MSIXE is seen on the bus.
  // Since MSIXE=1 will allow the write buffer to generate new MSIX writes, we should wait until we
  // send out the completion before allowing new MSIX writes into the Cpl RL.

  else if ((obcpl_hdr.cs == 3'd0) & ~obcpl_hdr.fmt &
      (obcpl_enables.enable == MSIXE) & obcpl_enables.value & ~local_msixe) begin // MSIXE 0->1 Cpl

   if (~sif_mstr_quiesce_req_q) begin // Not quiescing

    if (~sent_msixe_cpl_q) begin // Cpl not yet sent
   
     if (~fl_aempty) begin // Send Cpl
   
      sent_msixe_cpl_next = '1;
   
      fl2ll_v             = '1;
      fl2ll_ll            = HQM_MSTR_CPL_LL[HQM_MSTR_NUM_LLS_WIDTH-1:0];
   
      blk_v_next[fl_hptr] = '1;
   
      memi_mstr_ll_hdr_next.we    = '1;
      memi_mstr_ll_hdr_next.wdata = {cplhdr_par, 1'b0, {$bits(hqm_pasidtlp_t){1'b0}}, cplhdr};
   
      // MSIXE write completion is Cpl and not CplD, so no data
   
     end // Send Cpl
   
    end // Cpl not yet sent
   
    else if (~(|{ll_v[HQM_MSTR_CPL_LL], rl_v[2], iosf_db_fill_cnt_q[2]})) begin // Cpl sent
   
     // Allow the local MSIXE update and pop the Cpl
   
     sent_msixe_cpl_next = '0;
   
     allow_msixe_update  = '1;
   
     obcpl_ready         = '1;
      
    end // Cpl Sent

   end // Not quiescing

  end // MSIXE 0->1 Cpl

  //--------------------------------------------------------------------------------------------------
  // If this is an FLR completion, let's keep it valid to block any further TI transactions and wait
  // for any pending transactions to drain before allowing it into the LL.
  // Should not get any more outbound completions after the FLR completion (CDS throwing them away).

  else if (flr_txn_sent_q & (flr_txn_tag_q   == obcpl_hdr.tag) &
                            (flr_txn_reqid_q == obcpl_hdr.rid)) begin // FLR Cpl

   if (~sif_mstr_quiesce_req_q) begin // Not quiescing

    if (|{ll_v, rl_v, iosf_db_out_valid}) begin // MSTR not empty
   
     // We can throw away any CQ P or NP LL blocks that are pending (haven't yet generated an IOSF
     // request and been moved to an RL).  Doing this by pushing one block at a time back to the FL
     // using the LL arbiter and forcing these LLs to look valid, to avoid needing per LL counters
     // (if we had them we could just push the whole list for each LL instead).
     // Should wait until all the pending RLs and DBs have been granted.
   
     drain_cq_p_np_lls = '1;
   
    end // MSTR not empty
   
    else if (~fl_empty) begin // MSTR empty
   
     // Accept FLR completion, pop FL to push hdr onto appropriate LL, and store header.
     // Set the flag to hold off any further input transactions (the FLR will clear them).
   
     flr_cpl_sent_next   = '1;
   
     obcpl_ready         = '1;
   
     fl2ll_v             = '1;
     fl2ll_ll            = HQM_MSTR_CPL_LL[HQM_MSTR_NUM_LLS_WIDTH-1:0];
   
     blk_v_next[fl_hptr] = '1;
   
     memi_mstr_ll_hdr_next.we    = '1;
     memi_mstr_ll_hdr_next.wdata = {cplhdr_par, 1'b0, {$bits(hqm_pasidtlp_t){1'b0}}, cplhdr};
   
     // FLR completion is Cpl and not CplD, so no data
   
    end // MSTR empty

   end // Not quiescing

  end // FLR Cpl

  //--------------------------------------------------------------------------------------------------

  else if (ps_txn_sent_q & (ps_txn_tag_q   == obcpl_hdr.tag) &
                           (ps_txn_reqid_q == obcpl_hdr.rid)) begin // PS Cpl

   if (~sif_mstr_quiesce_req_q) begin // Not quiescing

    if (|{ll_v, rl_v, iosf_db_out_valid}) begin // MSTR not empty
   
     // Need same treatment as FLR: allow Cpl to proceed but drain any pending CQ P or NP LL blocks
   
     drain_cq_p_np_lls = '1;
   
    end // MSTR not empty
   
    else if (~fl_empty) begin // MSTR empty
   
     // Accept PS completion, pop FL to push hdr onto appropriate LL, and store header.
   
     ps_cpl_sent_next    = '1;
     ps_d0               = ~(|obcpl_hdr.pm);
   
     obcpl_ready         = '1;
   
     fl2ll_v             = '1;
     fl2ll_ll            = HQM_MSTR_CPL_LL[HQM_MSTR_NUM_LLS_WIDTH-1:0];
   
     blk_v_next[fl_hptr] = '1;
   
     memi_mstr_ll_hdr_next.we    = '1;
     memi_mstr_ll_hdr_next.wdata = {cplhdr_par, 1'b0, {$bits(hqm_pasidtlp_t){1'b0}}, cplhdr};
   
     // PS completion is Cpl and not CplD, so no data
   
    end // MSTR empty

   end // Not quiescing

  end // PS Cpl

  //--------------------------------------------------------------------------------------------------

  else if (~fl_aempty) begin // Normal Cpl

   // Completions do not require ATS.  Allow completions even during quiesce.
   // Accept completion, pop FL to push hdr onto appropriate LL, and store header

   obcpl_ready         = '1;

   fl2ll_v             = '1;
   fl2ll_ll            = HQM_MSTR_CPL_LL[HQM_MSTR_NUM_LLS_WIDTH-1:0];

   blk_v_next[fl_hptr] = '1;

   memi_mstr_ll_hdr_next.we    = '1;
   memi_mstr_ll_hdr_next.wdata = {cplhdr_par, 1'b0, {$bits(hqm_pasidtlp_t){1'b0}}, cplhdr};

   if (cplhdr.fmt[1]) begin

    memi_mstr_ll_data0_next.we    = '1;
    memi_mstr_ll_data0_next.wdata = {obcpl_dpar, 96'd0, obcpl_data};

   end

  end // Normal Cpl

 end // OBCPL valid

 //---------------------------------------------------------------------------------------------------
 // Message valid (invalidate response) from devtlb
 //
 // These need to persist through an FLR?

 else if (tx_msg_v & ~devtlb_reset & ~fl_empty & ~sif_mstr_quiesce_req_q) begin // Invalidate Response

  // As long as we have a freelist block available, format the posted Msg header, pop the FL block
  // and push it onto the P LL, and write the Msg header.  No ATS required.

  tx_msg_ack = '1;

  fl2ll_v    = '1;
  fl2ll_ll   = HQM_MSTR_P_LL[HQM_MSTR_NUM_LLS_WIDTH-1:0];

  blk_v_next[fl_hptr] = '1;

  memi_mstr_ll_hdr_next.we    = '1;
  memi_mstr_ll_hdr_next.wdata = {invrsphdr_par, 1'b0, invrsphdr_pasidtlp, invrsphdr};

 end // Invalidate Response

 //---------------------------------------------------------------------------------------------------

 else if (flr_cpl_sent_q | ps_cpl_sent_q) begin // FLR/PS Cpl Sent

  // Just park here if waiting for FLR to occur or PS to return to D0 after sending the FLR/PS Cpl

  // Invalidate responses have priority because they have to go out

 end // FLR/PS Cpl Sent

 //---------------------------------------------------------------------------------------------------
 // Header valid from devtlb ATS request

 else if (atshdr_v & ~sif_mstr_quiesce_req_q) begin // ATS Header

  // Already checked freelist available before setting atshdr_v, so pop the FL block, push it onto
  // the NP LL, and write the header.
  // Never a data phase for ATS requests.

  atshdr_ready = '1;

  fl2ll_v      = '1;
  fl2ll_ll     = HQM_MSTR_NP_LL[HQM_MSTR_NUM_LLS_WIDTH-1:0];

  blk_v_next[fl_hptr] = '1;

  memi_mstr_ll_hdr_next.we    = '1;
  memi_mstr_ll_hdr_next.wdata = {atshdr_par, 1'b0, atshdr_pasidtlp, atshdr};

  // Allocate the scoreboard entry

  scrbd_alloc      = '1;
  scrbd_alloc_data = ats_alloc_data;

 end // ATS Header

 else if (write_buffer_mstr_v & ~sif_mstr_quiesce_req_q) begin // WB packet

  // Drop the packet if the invalid bit is set, if the local_msixe bit is off and this is an MSI-X,
  // or if this is a CQ write and the HPA error flag is set for the CQ. 

  wb_drop_msixe   = (write_buffer_mstr.hdr.src == MSIX) & ~local_msixe;
  wb_drop_invalid =  write_buffer_mstr.hdr.invalid;
  wb_drop_cq      =  write_buffer_mstr.hdr.cq_v & hpa_err_scaled[wb_cq];

  if (wb_drop_msixe | wb_drop_invalid  | wb_drop_cq) begin // Invalid

   write_buffer_mstr_ready = '1;

  end // Invalid

  // Can accept a new header if the FL is not empty, and we are not in the middle of an inalidate request,
  // and we either don't need to generate a TLB lookup or we have at least one HP TLB request credit and
  // the xreq count is below the limit to allow us to do a new devtlb request.
  // Won't get here if we have a pending FLR or PS state change.

  else if (~fl_aempty & ~invrsp_pend_q & (~wb_tlb_reqd | ((|devtlb_hcrd_q) & xreq_cnt_lt_limit))) begin // Accept WB

   write_buffer_mstr_ready = '1;

   //TBD: If we want to replace the write buffer storage it presents a problem of how we save partial CL
   // writes so earlier HCWs can be rewritten.
   // If the WB optimization indicates a full cache line is expected, then we can just not set the blk_v
   // until we get the last write.  But if we don't know we'll be getting any more blocks, we do have
   // to send the CL out.  Do we hang onto the block instead of putting it back onto the FL?
   //
   // addr[5:4]
   //    0       1st HCW in new CL: hcw -> d0, zeros w/ ~gen -> d1,d2,d3
   //    1       2nd HCW in new CL: hcw -> d1
   //    2       3rd HCW in new CL: hcw -> d2
   //    3       4th HCW in new CL: hcw -> d3
 
   // Pop FL to push hdr onto appropriate LL and store header
   
   fl2ll_v = '1;
   
   memi_mstr_ll_hdr_next.we    = '1;
   memi_mstr_ll_hdr_next.wdata = {(phdr_par ^ wb_tlb_reqd), wb_tlb_reqd, phdr_pasidtlp, phdr};
   
   // All current transactions have data, so store the data
   
   memi_mstr_ll_data0_next.we = '1;
   memi_mstr_ll_data1_next.we = (write_buffer_mstr.hdr.length > 5'd4);
   memi_mstr_ll_data2_next.we = (write_buffer_mstr.hdr.length > 5'd8);
   memi_mstr_ll_data3_next.we = (write_buffer_mstr.hdr.length > 5'd12);
   
   // Interrupts set the interrupt valid indication, but do not set the wb_tlb_reqd indication,
   // which ultimately is used to mux in the HPA when the other transactions that require it go out.
   
   msix_v_next[fl_hptr] = wb_msix;
   blk_v_next[ fl_hptr] = '1;
   
   // Generate devtlb request if the HPA is not yet valid for this CQ and we don't have one pending already.
   
   if (wb_tlb_reqd & ~hpa_v_scaled[wb_cq] & ~hpa_pnd_scaled[wb_cq]) begin // Need devtlb lookup
   
    // Increment the xreq counter, decrement the HP xreq credit counter, set the HPA pending flag, and
    // send the request to the devtlb.

    hpa_pnd_next[wb_cq]     = '1;

    xreq_cnt_inc            = '1;
   
    devtlb_hcrd_dec         = '1;
   
    devtlb_req_v            = '1;
    devtlb_req.pasid_valid  = phdr_pasidtlp.fmt2;
    devtlb_req.pasid_priv   = phdr_pasidtlp.pm_req;
    devtlb_req.pasid        = phdr_pasidtlp.pasid;
    devtlb_req.id           = wb_cq[HQM_MSTR_NUM_CQS_WIDTH-1:0];    // Use CQ as ID
    devtlb_req.tlbid        = '0;                                   // uTLB[0]
    devtlb_req.ppriority    = '1;                                   // High priority
    devtlb_req.prs          = '0;                                   // No PRS
    devtlb_req.opcode       = '0;                                   // UTRN_W: Write access required
    devtlb_req.tc           = 3'd0;
    devtlb_req.bdf          = '0;
    devtlb_req.address      = (phdr.pcie64.fmt[0]) ?
                               phdr.pcie64.addr[DEVTLB_MAX_LINEAR_ADDRESS_WIDTH-1:12] :
                               {{(DEVTLB_MAX_LINEAR_ADDRESS_WIDTH-32){1'b0}}, phdr.pcie32.addr[31:12]};
   
   end // Need devtlb lookup

  end // Accept WB

 end // WB packet

 //---------------------------------------------------------------------------------------------------
 // devtlb request response

 if (devtlb_rsp_v & ~devtlb_reset) begin // devtlb response

  // Decrement the xreq counter, mark the HPA valid and reset the HPA pending flag for this CQ in any
  // case.  The error case will also end up setting the HPA error flag.

  xreq_cnt_dec                = '1;

  hpa_v_next[  devtlb_rsp.id] = '1;
  hpa_pnd_next[devtlb_rsp.id] = '0;

  if (devtlb_rsp.result & ~devtlb_rsp.dperror & ~devtlb_rsp.hdrerror) begin // devtlb success

   // If no error, store the HPA

   memi_mstr_ll_hpa_next.we   = '1;

   //TBD: Do we care about nonsnooped?

   //devtlb_rsp.nonsnooped;
   //devtlb_rsp.prs_code;

  end // devtlb success

  else begin // devtlb failure

   // Error case sets the HPA error flag for this CQ and reports the alarm w/ syndrome

   devtlb_ats_alarm              = '1;

   hpa_err_next[devtlb_rsp.id]   = '1;

   set_devtlb_ats_err.BAD_RESULT = ~devtlb_rsp.result;
   set_devtlb_ats_err.HDRERROR   =  devtlb_rsp.hdrerror;
   set_devtlb_ats_err.DPERROR    =  devtlb_rsp.dperror;

  end // devtlb failure

 end // devtlb response

 // Reset HPA error flag for a particular CQ only on a SW clear

 if (clr_hpa_err) begin

  hpa_err_next[clr_hpa_err_cq] = '0;

 end

 // Reset all HPA valid flags on a drain request completion

 if (clr_hpa_v) begin

  hpa_v_next = '0;

 end

 // Reset all the per block flags when a block is pushed back onto the FL

 if (fl_push) begin

  blk_v_next[ fl_push_ptr] = '0;
  msix_v_next[fl_push_ptr] = '0;

 end

 // Vector of the blk_v and hpa_v status at the head of each LL

 //TBD: Use blk_v for source ordering?

 for (int i=0; i<HQM_MSTR_NUM_LLS; i=i+1) begin // LL flags

  if (i < HQM_MSTR_NUM_CQS) begin // CQ P

   // CQ LLs: CQ writes.  Need to be able to drain for FLR.
   //         Must hold if BME==0.

   blk_v[i] = ll_v[i] & (drain_cq_p_np_lls | ((blk_v_q[ll_hptr_mda[i]] | (cq_np_cnt_q[i] == 9'd0)) & local_bme & ~block_cq_p_np_lls));
   hpa_v[i] = ll_v[i] &  drain_cq_p_np_lls |  hpa_v_q[i] | ~cfg_ats_enabled_q;

  end // CQ P

  else if (i == HQM_MSTR_P_LL) begin // P

   // P LL: Invalidate responses.  Not affected by BME setting.
   //       Must also be allowed during an FLR?

   blk_v[i] = ll_v[i] & blk_v_q[ll_hptr_mda[i]];

  end // P

  else if (i == HQM_MSTR_NP_LL) begin // NP

   // NP LL: ATS requests.  Need to be able to drain for FLR.
   //        Must hold if BME=1->0.

   blk_v[i] = ll_v[i] & (drain_cq_p_np_lls | (blk_v_q[ll_hptr_mda[i]] & local_bme & ~block_cq_p_np_lls));

  end // NP

  else if (i == HQM_MSTR_CPL_LL) begin // CPL

   // CPL LL: No ATS or dependence on BME.

   blk_v[i] = ll_v[i] & blk_v_q[ll_hptr_mda[i]];

  end // CPL

  else if (i == HQM_MSTR_INT_LL) begin // Alarm Int (P)

   // INT LL: No ATS.  Need to be able to drain for FLR.
   //         Must hold if BME=1->0.

   blk_v[i] = ll_v[i] & (drain_cq_p_np_lls | (blk_v_q[ll_hptr_mda[i]] & local_bme & ~block_cq_p_np_lls));

  end // Alarm Int (P)

 end // LL Flags

end

//----------------------------------------------------------------------------------------------------
// Register memory write interfaces

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin
 if (~prim_gated_rst_b) begin
  memi_mstr_ll_hdr_q.we   <= '0;
  memi_mstr_ll_hpa_q.we   <= '0;
  memi_mstr_ll_data0_q.we <= '0;
  memi_mstr_ll_data1_q.we <= '0;
  memi_mstr_ll_data2_q.we <= '0;
  memi_mstr_ll_data3_q.we <= '0;
 end else begin
  memi_mstr_ll_hdr_q.we   <= memi_mstr_ll_hdr_next.we;
  memi_mstr_ll_hpa_q.we   <= memi_mstr_ll_hpa_next.we;
  memi_mstr_ll_data0_q.we <= memi_mstr_ll_data0_next.we;
  memi_mstr_ll_data1_q.we <= memi_mstr_ll_data1_next.we;
  memi_mstr_ll_data2_q.we <= memi_mstr_ll_data2_next.we;
  memi_mstr_ll_data3_q.we <= memi_mstr_ll_data3_next.we;
 end
end

always_ff @(posedge prim_nonflr_clk) begin
  if (memi_mstr_ll_hdr_next.we) begin
   memi_mstr_ll_hdr_q.waddr   <= memi_mstr_ll_hdr_next.waddr;
   memi_mstr_ll_hdr_q.wdata   <= memi_mstr_ll_hdr_next.wdata;
  end
  if (memi_mstr_ll_hpa_next.we) begin
   memi_mstr_ll_hpa_q.waddr   <= memi_mstr_ll_hpa_next.waddr;
   memi_mstr_ll_hpa_q.wdata   <= memi_mstr_ll_hpa_next.wdata;
  end
  if (memi_mstr_ll_data0_next.we) begin
   memi_mstr_ll_data0_q.waddr <= memi_mstr_ll_data0_next.waddr;
   memi_mstr_ll_data0_q.wdata <= memi_mstr_ll_data0_next.wdata;
  end
  if (memi_mstr_ll_data1_next.we) begin
   memi_mstr_ll_data1_q.waddr <= memi_mstr_ll_data1_next.waddr;
   memi_mstr_ll_data1_q.wdata <= memi_mstr_ll_data1_next.wdata;
  end
  if (memi_mstr_ll_data2_next.we) begin
   memi_mstr_ll_data2_q.waddr <= memi_mstr_ll_data2_next.waddr;
   memi_mstr_ll_data2_q.wdata <= memi_mstr_ll_data2_next.wdata;
  end
  if (memi_mstr_ll_data3_next.we) begin
   memi_mstr_ll_data3_q.waddr <= memi_mstr_ll_data3_next.waddr;
   memi_mstr_ll_data3_q.wdata <= memi_mstr_ll_data3_next.wdata;
  end
end

always_comb begin
 memi_mstr_ll_hdr.we      = memi_mstr_ll_hdr_q.we;
 memi_mstr_ll_hdr.waddr   = memi_mstr_ll_hdr_q.waddr;
 memi_mstr_ll_hdr.wdata   = memi_mstr_ll_hdr_q.wdata;
 memi_mstr_ll_hpa.we      = memi_mstr_ll_hpa_q.we;
 memi_mstr_ll_hpa.waddr   = memi_mstr_ll_hpa_q.waddr;
 memi_mstr_ll_hpa.wdata   = memi_mstr_ll_hpa_q.wdata;
 memi_mstr_ll_data0.we    = memi_mstr_ll_data0_q.we;
 memi_mstr_ll_data0.waddr = memi_mstr_ll_data0_q.waddr;
 memi_mstr_ll_data0.wdata = memi_mstr_ll_data0_q.wdata;
 memi_mstr_ll_data1.we    = memi_mstr_ll_data1_q.we;
 memi_mstr_ll_data1.waddr = memi_mstr_ll_data1_q.waddr;
 memi_mstr_ll_data1.wdata = memi_mstr_ll_data1_q.wdata;
 memi_mstr_ll_data2.we    = memi_mstr_ll_data2_q.we;
 memi_mstr_ll_data2.waddr = memi_mstr_ll_data2_q.waddr;
 memi_mstr_ll_data2.wdata = memi_mstr_ll_data2_q.wdata;
 memi_mstr_ll_data3.we    = memi_mstr_ll_data3_q.we;
 memi_mstr_ll_data3.waddr = memi_mstr_ll_data3_q.waddr;
 memi_mstr_ll_data3.wdata = memi_mstr_ll_data3_q.wdata;
end

//----------------------------------------------------------------------------------------------------
// Per LL block pointer flags and xreq counter

always_comb begin

 // XREQ counter inc/dec

 case ({xreq_cnt_inc, xreq_cnt_dec})
  2'b10:   xreq_cnt_next = xreq_cnt_q + 6'd1;
  2'b01:   xreq_cnt_next = xreq_cnt_q - 6'd1;
  default: xreq_cnt_next = xreq_cnt_q;
 endcase

end

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin
 if (~prim_gated_rst_b) begin
  blk_v_q    <= '0;
  msix_v_q   <= '0;
  hpa_v_q    <= '0;
  hpa_err_q  <= '0;
  hpa_pnd_q  <= '0;
  xreq_cnt_q <= '0;
 end else begin
  blk_v_q    <= blk_v_next;
  msix_v_q   <= msix_v_next;
  hpa_v_q    <= hpa_v_next[  HQM_MSTR_NUM_CQS-1:0];
  hpa_err_q  <= hpa_err_next[HQM_MSTR_NUM_CQS-1:0];
  hpa_pnd_q  <= hpa_pnd_next[HQM_MSTR_NUM_CQS-1:0];
  xreq_cnt_q <= xreq_cnt_next;
 end
end

hqm_AW_width_scale #(.A_WIDTH(HQM_MSTR_NUM_CQS), .Z_WIDTH(1<<HQM_MSTR_NUM_LLS_WIDTH)) i_hpa_v_scaled (

     .a     (hpa_v_q)
    ,.z     (hpa_v_scaled)
);

hqm_AW_width_scale #(.A_WIDTH(HQM_MSTR_NUM_CQS), .Z_WIDTH(1<<HQM_MSTR_NUM_LLS_WIDTH)) i_hpa_err_scaled (

     .a     (hpa_err_q)
    ,.z     (hpa_err_scaled)
);

hqm_AW_width_scale #(.A_WIDTH(HQM_MSTR_NUM_CQS), .Z_WIDTH(1<<HQM_MSTR_NUM_LLS_WIDTH)) i_hpa_pnd_scaled (

     .a     (hpa_pnd_q)
    ,.z     (hpa_pnd_scaled)
);

//----------------------------------------------------------------------------------------------------
// Local enable logic
//
// Need local copies of the BME and MSIXE bits to manage when we can master transactions.
// These local bits get updated when the completion for the write that changed them is processed
// (or immediately when they are updated through sideband).

always_comb begin

 local_bme_next   = local_bme_q;
 local_msixe_next = local_msixe_q;

 // Doesn't matter when we update these if they are changed by GPSB since primary and sideband
 // are asynchronous.  There can be no real expectations on ordering between the two.

 if (gpsb_upd_enables.enable == BME)   local_bme_next   = gpsb_upd_enables.value;
 if (gpsb_upd_enables.enable == MSIXE) local_msixe_next = gpsb_upd_enables.value;

 // Primary wins on a conflict (not a usage case)

 if (allow_bme_update) begin
  if (obcpl_enables.enable == BME)   local_bme_next   = obcpl_enables.value;
 end

 if (allow_msixe_update) begin
  if (obcpl_enables.enable == MSIXE) local_msixe_next = obcpl_enables.value;
 end

end

always_ff @(posedge prim_nonflr_clk or negedge hqm_csr_pf0_rst_n) begin
 if (~hqm_csr_pf0_rst_n) begin
  local_bme_q      <= '0;
  local_msixe_q    <= '0;
  sent_bme_cpl_q   <= '0;
  sent_msixe_cpl_q <= '0;
 end else begin
  local_bme_q      <= local_bme_next;
  local_msixe_q    <= local_msixe_next;
  sent_bme_cpl_q   <= sent_bme_cpl_next;
  sent_msixe_cpl_q <= sent_msixe_cpl_next;
 end
end

assign local_bme   = local_bme_q   & ~flr_treatment_vec;
assign local_msixe = local_msixe_q & ~flr_treatment_vec;

assign local_bme_status   = local_bme;
assign local_msixe_status = local_msixe;

//----------------------------------------------------------------------------------------------------
// Arbitrate among valid LLs

// An LL looks valid if the LL is not empty and any conditions are met.
// Using hpa_v to indicate when the HPA has been received for transactions that require ATS.
// Using blk_v to indicate when "other conditions" are met.
//
// Only CQ writes (LLs 0 thru HQM_MSTR_NUM_CQS-1) require the HPA valid.  Interrupt writes and completions
// do not require HPA and we currently have no other P or NP transactions that require HPA.
// NP also require an available scoreboard location.
//
// Registering LL arbiter inputs and outputs for timing.
//
// Make LLs that don't have an RL available (because they have no remaining transaction credits)
// look not valid, so one rtype isn't blocking the others.
//
// A quiesce request blocks any P or NP requests from looking valid to the arbiter.  Completions can
// continue during a quiesce.

//TBD: Don't allow one LL type to block all the others?  Can run okay w/o needing to reserve blocks
//     for the RLs because the LLs can bypass directly to the DBs.  But do we need a guard so an LL
//     doesn't consume all the FL blocks and starve the other LLs?

assign ll_arb_reqs_next = blk_v & {4'b1111, hpa_v} & ~ll_arb_winner_mask[HQM_MSTR_NUM_LLS-1:0];

assign ll_arb_reqs      = ll_arb_reqs_q & ~ll_arb_winner_mask[HQM_MSTR_NUM_LLS-1:0] &
                           ~{(req_put_afull_q[0] | sif_mstr_quiesce_req_q)                     // P Alarm
                            , req_put_afull_q[2]                                               // Cpl
                            ,(req_put_afull_q[1] | sif_mstr_quiesce_req_q)                     // NP
                            ,(req_put_afull_q[0] | sif_mstr_quiesce_req_q)                     // P
                            ,{HQM_MSTR_NUM_CQS{(req_put_afull_q[0] | sif_mstr_quiesce_req_q)}} // P CQ
                            };

hqm_AW_rr_arbiter #(.NUM_REQS(HQM_MSTR_NUM_LLS)) u_arb (

     .clk           (prim_nonflr_clk)
    ,.rst_n         (prim_gated_rst_b)

    ,.mode          (2'd2)
    ,.update        (ll_arb_update)

    ,.reqs          (ll_arb_reqs)

    ,.winner_v      (ll_arb_winner_v_next)
    ,.winner        (ll_arb_winner_next)
);

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin
 if (~prim_gated_rst_b) begin
  ll_arb_reqs_q      <= '0;
  ll_arb_winner_v_q  <= '0;
  ll_arb_winner_q    <= '0;
 end else begin
  ll_arb_reqs_q      <= ll_arb_reqs_next;
  if (~ll_arb_hold) begin
   ll_arb_winner_v_q <= ll_arb_winner_v_next;
   ll_arb_winner_q   <= ll_arb_winner_next;
  end
 end
end

hqm_AW_bindec #(.WIDTH(HQM_MSTR_NUM_LLS_WIDTH)) i_ll_arb_winner_mask (

     .a         (ll_arb_winner_q)
    ,.enable    (ll_arb_winner_v_q)

    ,.dec       (ll_arb_winner_mask)
);

always_comb begin

 // Cpl LL goes to Cpl RL
 // NP  LL goes to NP  RL
 // All other LLs (CQ P, P, Int) go to P RL

 ll_arb_winner_rl     = (ll_arb_winner_q == HQM_MSTR_CPL_LL[HQM_MSTR_NUM_LLS_WIDTH-1:0]) ? 2'd2 : // Cpl
                       ((ll_arb_winner_q == HQM_MSTR_NP_LL[ HQM_MSTR_NUM_LLS_WIDTH-1:0]) ? 2'd1 : // NP
                                                                                           2'd0); // P

 ll_arb_winner_is_inv = ll_arb_winner_v_q &
                        (ll_arb_winner_q == HQM_MSTR_P_LL[  HQM_MSTR_NUM_LLS_WIDTH-1:0]);

 // Draining the current arbitration winner if the FLR drain indication is on and it isn't a completion
 // or invalidate response.
 // Only the CQ P LL can have the hpa_err flag set.  If it does, we need to prevent further pushes to
 // that LL and to drain that LL.

 ll_arb_winner_drain  = ll_arb_winner_v_q & (hpa_err_scaled[ll_arb_winner_q] |
                        (drain_cq_p_np_lls & ~(ll_arb_winner_is_inv | (ll_arb_winner_rl == 2'd2))));

 // Can only generate the IOSF request if the agent ISM is in the ACTIVE state and we have a fabric
 // request credit for the rtype.  So make the arbiter look not valid if these conditions are not met.
 // Don't want to hold the arbiter for a fabric hold if we're draining.

 ll_arb_fabric_hold   = (prim_ism_agent != 3'd3);

 ll_arb_hold          = ll_arb_fill_hold  |  (ll_arb_fabric_hold & ~ll_arb_winner_drain);

 ll_arb_winner_v      = ll_arb_winner_v_q & ~(ll_arb_fabric_hold & ~ll_arb_winner_drain);

 // Gate off the np and CQ p indications during draining so they don't generate a DB fill request

 ll_arb_winner_is_cpl = ll_arb_winner_v & (ll_arb_winner_rl == 2'd2);
 ll_arb_winner_is_np  = ll_arb_winner_v & (ll_arb_winner_rl == 2'd1) & ~ll_arb_winner_drain;
 ll_arb_winner_is_p   = ll_arb_winner_v & (ll_arb_winner_rl == 2'd0) & ~ll_arb_winner_drain;

 // Only update if we are not holding

 ll_arb_update        = ll_arb_winner_v_next & ~ll_arb_hold;

end

//----------------------------------------------------------------------------------------------------
// LL reads

// A valid arbitration winner needs to generate an IOSF request which then needs to wait for the IOSF
// grant to be returned before the header and data can be put on the bus.
//
// Need to initiate the reads of the header and HPA storage, pull the block off the winning LL HP and
// push it onto the appropriate RL.  When the data is available the next clock, need to generate the
// IOSF request.
//
// Since the gnt to cmd timing is fixed at 1 cycle, and we must register the gnt before using it to
// select the appropriate rtype (RL) header to send out, we need to have the header available and
// we can't burn another cycle to reread it out of the header storage.  One way to manage this is
// to effectively have a double buffer to hold the headers/data at the head of each RL.  Then we can
// just mux the appropriate DB output onto the IOSF cmd bus based on the registered rtype.
//
// The DBs can just be loaded whenever their associated RL is not empty and the DB is not full.  To
// do that we need to read the header, HPA (if required), and data storages.  These reads need to take
// precedence over the request reads because we have to ensure we have the headers available when
// the grants come back which could be back to back for non-data transactions.
//
// Adding the ability for the LL to directly load the DB if there is space in the DB and the RL is
// currently empty.

hqm_AW_binenc #(.WIDTH(3)) i_iosf_db_fill_rl_next (

     .a         (iosf_db_fill_req)
    ,.any       (iosf_db_fill_any)
    ,.enc       (iosf_db_fill_rl_next)
);

always_comb begin

 ll_arb_fill_hold         = '0;

 fl_push                  = '0;
 fl_push_ptr              = ll_hptr_mda[ll_arb_winner_q];

 iosf_db_fill_req         = '0;
 iosf_db_fill_bp          = '0;
 iosf_db_fill_v_next      = '0;

 ll2rl_v                  = '0;
 ll2rl_ll                 = ll_arb_winner_q;
 ll2rl_rl                 = ll_arb_winner_rl;

 ll2db_v                  = '0;
 ll2db_ll                 = ll_arb_winner_q;
 ll2db_rl                 = ll_arb_winner_rl;

 rl2db_v                  = '0;
 rl2db_rl                 = iosf_db_fill_rl_next;

 iosf_req_v_next          = '0;
 iosf_req_rtype_next      = ll2rl_rl;

 cq_np_cnt_inc            = '0;

 p_rl_cq_fifo_pop         = '0;
 p_rl_cq_fifo_push        = '0;
 p_rl_cq_fifo_push_data   = ll_arb_winner_q[HQM_MSTR_NUM_CQS_WIDTH-1:0];

 memi_mstr_ll_hpa.re      = '0;
 memi_mstr_ll_hpa.raddr   = ll_arb_winner_q[HQM_MSTR_NUM_CQS_WIDTH-1:0];

 memi_mstr_ll_hdr.re      = '0;
 memi_mstr_ll_hdr.raddr   = fl_push_ptr;

 memi_mstr_ll_data0.re    = '0;
 memi_mstr_ll_data0.raddr = fl_push_ptr;

 memi_mstr_ll_data1.re    = '0;
 memi_mstr_ll_data1.raddr = fl_push_ptr;

 memi_mstr_ll_data2.re    = '0;
 memi_mstr_ll_data2.raddr = fl_push_ptr;

 memi_mstr_ll_data3.re    = '0;
 memi_mstr_ll_data3.raddr = fl_push_ptr;

 // If a DB is not full and the RL is currently empty, we can move an arbitration
 // winner to the associated RL DB directly bypassing the RL.
 // Otherwise, generate a DB fill request if the RL is not empty and the DB is not
 // full or the DB is being popped.  This needs to be a priority scheme because only
 // one fill request can be asserted at a time.  Give priority to the DB that was
 // just granted.

 if (gnt_rl_decode[2]) begin // Cpl Granted

  iosf_db_fill_req[2] =  rl_v[2] | ll_arb_winner_is_cpl;
  iosf_db_fill_bp     = ~rl_v[2] & ll_arb_winner_is_cpl;

 end // Cpl Granted

 else if (gnt_rl_decode[1]) begin // NP Granted

  iosf_db_fill_req[1] =  rl_v[1] | ll_arb_winner_is_np;
  iosf_db_fill_bp     = ~rl_v[1] & ll_arb_winner_is_np;

 end // NP Granted

 else if (gnt_rl_decode[0]) begin // P Granted

  iosf_db_fill_req[0] =  rl_v[0] | ll_arb_winner_is_p;
  iosf_db_fill_bp     = ~rl_v[0] & ll_arb_winner_is_p;

 end // P Granted

 // If no fill due to a current grant, try to fill any DB that's not full

 if (~|iosf_db_fill_req) begin // No Grant Fill

  if ((iosf_db_fill_cnt_q[2] < 2'd2) & (rl_v[2] | ll_arb_winner_is_cpl)) begin

   iosf_db_fill_req[2] = '1;
   iosf_db_fill_bp     = ~rl_v[2];

  end

  else if ((iosf_db_fill_cnt_q[1] < 2'd2) & (rl_v[1] | ll_arb_winner_is_np)) begin

   iosf_db_fill_req[1] = '1;
   iosf_db_fill_bp     = ~rl_v[1];

  end

  else if ((iosf_db_fill_cnt_q[0] < 2'd2) & (rl_v[0] | ll_arb_winner_is_p)) begin

   iosf_db_fill_req[0] = '1;
   iosf_db_fill_bp     = ~rl_v[0];

  end

 end // No Grant Fill

 if (iosf_db_fill_any) begin // DB Fill

  // A DB fill request takes priority and needs to hold off the arbiter path
  // if the fill is from the RL and not bypassing from the arbiter path.

  ll_arb_fill_hold          = ~iosf_db_fill_bp;

  // Pipe the fill request forward with the RL and the ptr

  iosf_db_fill_v_next       = '1;

  // Read the hdr and data storage for the RL with the DB fill request

  memi_mstr_ll_hpa.re       = '1;

  memi_mstr_ll_hdr.re       = '1;
  memi_mstr_ll_data0.re     = '1;
  memi_mstr_ll_data1.re     = '1;
  memi_mstr_ll_data2.re     = '1;
  memi_mstr_ll_data3.re     = '1;

  if (iosf_db_fill_bp) begin // Fill From Arb

   // Pop the LL (bypassing the RL) and push the LL ptr onto the FL TP
   // Generate the IOSF request when the read comes back next clock

   ll2db_v                  = '1;
   ll2db_ll                 = ll_arb_winner_q;
   ll2db_rl                 = ll_arb_winner_rl;

   fl_push                  = '1;
   fl_push_ptr              = ll_hptr_mda[ll_arb_winner_q];

   memi_mstr_ll_hpa.raddr   = ll_arb_winner_q[HQM_MSTR_NUM_CQS_WIDTH-1:0];

   memi_mstr_ll_hdr.raddr   = fl_push_ptr;
   memi_mstr_ll_data0.raddr = fl_push_ptr;
   memi_mstr_ll_data1.raddr = fl_push_ptr;
   memi_mstr_ll_data2.raddr = fl_push_ptr;
   memi_mstr_ll_data3.raddr = fl_push_ptr;

   iosf_req_v_next          = '1;
   iosf_req_rtype_next      = ll2db_rl;

//TBD: When we switch to NP UIO, need this for source ordering
// if (ll_arb_winner_q <= HQM_MSTR_NUM_CQS[HQM_MSTR_NUM_LLS_WIDTH-1:0]) begin
//
//  cq_np_cnt_inc[ll_arb_winner_q] = '1;
//
// end

  end // Fill From Arb

  else begin // Fill From RL

   // Pop the RL and push the RL ptr onto the FL TP

   rl2db_v                  = '1;
   rl2db_rl                 = iosf_db_fill_rl_next;

   fl_push                  = '1;
   fl_push_ptr              = rl_hptr_mda[rl2db_rl];

   // The problem is that for a CQ posted write we need to know the CQ number here.  That info
   // is available for the LL->DB case above because the ll_arb winner tells us the CQ, but we
   // lose the CQ info when we move an LL block to an RL.  So for the case where we're filling
   // the DB from the RL we need a small FIFO to hold the CQ number for each of the outstanding
   // P RL entries (maximum of 31 outstanding with the current iosf request counter width of 5).

   if (rl2db_rl == 2'd0) begin

    p_rl_cq_fifo_pop        = '1;

    memi_mstr_ll_hpa.raddr  = p_rl_cq_fifo_pop_data;    // Saved CQ

   end

   memi_mstr_ll_hdr.raddr   = fl_push_ptr;
   memi_mstr_ll_data0.raddr = fl_push_ptr;
   memi_mstr_ll_data1.raddr = fl_push_ptr;
   memi_mstr_ll_data2.raddr = fl_push_ptr;
   memi_mstr_ll_data3.raddr = fl_push_ptr;

  end // Fill From RL

 end // DB Fill

 else if (ll_arb_winner_v) begin // Arb valid

  if (ll_arb_winner_drain) begin // Drain

   // Push the block back onto the freelist as if we're doing an LL->DB move but don't do any
   // reads because we're just throwing the transaction away and won't actually load the DB.

   ll2db_v                  = '1;
   ll2db_ll                 = ll_arb_winner_q;
   ll2db_rl                 = ll_arb_winner_rl;

   fl_push                  = '1;
   fl_push_ptr              = ll_hptr_mda[ll_arb_winner_q];

  end // Drain

  else begin // Gen IOSF request

   // Don't need the HPA or data for the IOSF request so just read the hdr from the LL HP
  
   memi_mstr_ll_hdr.re      = '1;
   memi_mstr_ll_hdr.raddr   = ll_hptr_mda[ll_arb_winner_q];
  
   // Remove block from the CQ LL HP and update the HP to point to the next block by pushing the block
   // onto the appropriate RL.
  
   ll2rl_v                  = '1;
   ll2rl_ll                 = ll_arb_winner_q;
   ll2rl_rl                 = ll_arb_winner_rl;

   // Push the CQ information onto the P RL CQ FIFO (doing this for all P writes)

   p_rl_cq_fifo_push        = (ll_arb_winner_rl == 2'd0);
  
   // Generate the IOSF request when the read comes back next clock
  
   iosf_req_v_next          = '1;
   iosf_req_rtype_next      = ll2rl_rl;

//TBD: When we switch to NP UIO, need this for source ordering
// if (ll_arb_winner_q <= HQM_MSTR_NUM_CQS[HQM_MSTR_NUM_LLS_WIDTH-1:0]) begin
//
//  cq_np_cnt_inc[ll_arb_winner_q] = '1;
//
// end

  end // Gen IOSF request

 end //Arb valid

end // always_comb

//----------------------------------------------------------------------------------------------------
// Need to store the CQ number associated with any P RL entries to allow indexing of per CQ HPA storage.
// Can't overflow.  Building out of flops.

hqm_AW_fifo_control_wreg #(

     .DEPTH                 (32)
    ,.DWIDTH                (HQM_MSTR_NUM_CQS_WIDTH)
    ,.MEMRE_POWER_OPT       (0)

) i_p_rl_cq_fifo (

     .clk                   (prim_nonflr_clk)
    ,.rst_n                 (prim_gated_rst_b)

    ,.cfg_high_wm           ('0)

    ,.push                  (p_rl_cq_fifo_push)
    ,.push_data             (p_rl_cq_fifo_push_data)
    ,.pop                   (p_rl_cq_fifo_pop)
    ,.pop_data_v            (p_rl_cq_fifo_pop_data_v_nc)
    ,.pop_data              (p_rl_cq_fifo_pop_data)

    ,.mem_we                (p_rl_cq_fifo_we)
    ,.mem_waddr             (p_rl_cq_fifo_waddr)
    ,.mem_wdata             (p_rl_cq_fifo_wdata)
    ,.mem_re                (p_rl_cq_fifo_re)
    ,.mem_raddr             (p_rl_cq_fifo_raddr)
    ,.mem_rdata             (p_rl_cq_fifo_rdata)

    ,.fifo_status           (cfg_p_rl_cq_fifo_status)
    ,.fifo_full             (p_rl_cq_fifo_full_nc)
    ,.fifo_afull            (p_rl_cq_fifo_afull_nc)
);

always_ff @(posedge prim_nonflr_clk) begin
 if (p_rl_cq_fifo_re) p_rl_cq_fifo_rdata <= p_rl_cq_fifo_mem[p_rl_cq_fifo_raddr];
 if (p_rl_cq_fifo_we) p_rl_cq_fifo_mem[p_rl_cq_fifo_waddr] <= p_rl_cq_fifo_wdata;
end

hqm_AW_unused_bits i_fifo_unused (
     .a     (|{p_rl_cq_fifo_pop_data_v_nc, p_rl_cq_fifo_full_nc, p_rl_cq_fifo_afull_nc})
);

//----------------------------------------------------------------------------------------------------
// The memory read data is available the following cycle for the DB fill

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin
 if (~prim_gated_rst_b) begin
  iosf_db_fill_v_q   <= '0;
  iosf_db_fill_rl_q  <= '0;
 end else begin
  iosf_db_fill_v_q   <= iosf_db_fill_v_next;
  iosf_db_fill_rl_q  <= iosf_db_fill_rl_next;
 end
end

//----------------------------------------------------------------------------------------------------
// IOSF Request Bus

always_comb begin

 {hdr_rdata_par, hdr_rdata_tlb_reqd, hdr_rdata_pasidtlp, hdr_rdata_hdr} = memo_mstr_ll_hdr.rdata;

 ttype = hqm_pcie_type_e_t'({hdr_rdata_hdr.pcie64.fmt
                            ,hdr_rdata_hdr.pcie64.ttype});

 iosf_req_next         = '0;

 iosf_req_next.put     = iosf_req_v_q;

 if (iosf_req_v_q) begin

  iosf_req_next.rtype  =  iosf_req_rtype_q;
  iosf_req_next.locked =  f_hqm_ttype_is_memrdlk(ttype) | f_hqm_ttype_is_cpllk(ttype);
  iosf_req_next.cdata  =  hdr_rdata_hdr.pcie64.fmt[1];
  iosf_req_next.dlen   =  hdr_rdata_hdr.pcie64.len;
  iosf_req_next.tc     = {hdr_rdata_hdr.pcie64.rsvd4
                         ,hdr_rdata_hdr.pcie64.tc};
  iosf_req_next.ns     =  hdr_rdata_hdr.pcie64.attr[0];
  iosf_req_next.ro     =  hdr_rdata_hdr.pcie64.attr[1];
  iosf_req_next.ido    =  hdr_rdata_hdr.pcie64.attr2;
  iosf_req_next.id     =  hdr_rdata_hdr.pcie64.rqid[15:0];

 end

 iosf_req_next.chid    = '0;
 iosf_req_next.chain   = '0;
 iosf_req_next.opp     = '0;
 iosf_req_next.priorty = '0;
 iosf_req_next.rs      = '0;
 iosf_req_next.agent   = '0;

end

// Flop the IOSF request bus

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin
 if (~prim_gated_rst_b) begin
  iosf_req_v_q     <= '0;
  iosf_req_rtype_q <= '0;
  iosf_req_q       <= '0;
 end else begin
  iosf_req_v_q     <= iosf_req_v_next;
  iosf_req_rtype_q <= iosf_req_rtype_next;
  iosf_req_q       <= iosf_req_next;
 end
end

assign iosf_req = iosf_req_q;

//----------------------------------------------------------------------------------------------------
// Double buffers per rtype to hold head of the RLs

always_comb begin

 iosf_db_in_valid   = '0;

 if (iosf_db_fill_v_q) iosf_db_in_valid[iosf_db_fill_rl_q] = '1;

 // The output buses are 32B + 1b parity while the LL data storage is 16B + 1b parity

 iosf_db_in_parity0 = ^{((hdr_rdata_hdr.pciecpl.len > 10'd4 ) ? memo_mstr_ll_data1.rdata[128]   : 1'd0)
                                                               ,memo_mstr_ll_data0.rdata[128]};

 iosf_db_in_parity1 = ^{((hdr_rdata_hdr.pciecpl.len > 10'd12) ? memo_mstr_ll_data3.rdata[128]   : 1'd0)
                       ,((hdr_rdata_hdr.pciecpl.len > 10'd8 ) ? memo_mstr_ll_data2.rdata[128]   : 1'd0)};

 iosf_db_in_data0   =  {((hdr_rdata_hdr.pciecpl.len > 10'd4 ) ? memo_mstr_ll_data1.rdata[127:0] : 128'd0)
                                                               ,memo_mstr_ll_data0.rdata[127:0]};

 iosf_db_in_data1   =  {((hdr_rdata_hdr.pciecpl.len > 10'd12) ? memo_mstr_ll_data3.rdata[127:0] : 128'd0)
                       ,((hdr_rdata_hdr.pciecpl.len > 10'd8 ) ? memo_mstr_ll_data2.rdata[127:0] : 128'd0)};

 // Format the header for iosf_cmd

 // For transactions that required a TLB lookup, need to use the HPA result.
 // This can potentially change between 4DW<->3DW transactions depending on the resulting upper 32
 // address bits...  Note: Need to adjust the parity as well...

 {hpa_rdata_p, hpa_rdata_hpa} = memo_mstr_ll_hpa.rdata;

 if (hdr_rdata_tlb_reqd) begin // Need HPA

  hdr_rdata_addr = {{(64-DEVTLB_MAX_HOST_ADDRESS_WIDTH){1'b0}}, hpa_rdata_hpa};
  hdr_rdata_fmt0 = (|hpa_rdata_hpa[DEVTLB_MAX_HOST_ADDRESS_WIDTH-1:32]);

  // Since the tlb_reqd bit was included in the parity, need to invert here (hence 1'b1)

  if (hdr_rdata_hdr.pcie32.fmt[0]) begin

   hdr_rdata_padj = ^{1'b1, hpa_rdata_p, (~hdr_rdata_fmt0),
                      hdr_rdata_hdr.pcie64.addr[DEVTLB_MAX_LINEAR_ADDRESS_WIDTH-1:12]};

  end else begin

   hdr_rdata_padj = ^{1'b1, hpa_rdata_p, hdr_rdata_fmt0, hdr_rdata_hdr.pcie32.addr[31:12]};

  end

 end // Need HPA

 else begin // No HPA

  hdr_rdata_addr = (hdr_rdata_hdr.pcie32.fmt[0]) ?
                    hdr_rdata_hdr.pcie64.addr[63:12] :
                    {32'd0, hdr_rdata_hdr.pcie32.addr[31:12]};

  hdr_rdata_fmt0 = hdr_rdata_hdr.pcie32.fmt[0];
  hdr_rdata_padj = '0;

 end // No HPA

 iosf_db_in_hdr             = '0;

 iosf_db_in_hdr.csai        = (iosf_db_in_valid[2]) ? strap_hqm_cmpl_sai : strap_hqm_tx_sai;
 iosf_db_in_hdr.cparity     =  hdr_rdata_par ^ hdr_rdata_padj;
 iosf_db_in_hdr.cpasidtlp   =  hdr_rdata_pasidtlp;

 hdr_rdata_pcie_cmd = hqm_pcie_type_e_t'({hdr_rdata_hdr.pcie64.fmt
                                         ,hdr_rdata_hdr.pcie64.ttype});

 if ((hdr_rdata_pcie_cmd == HQM_CPL)  ||
     (hdr_rdata_pcie_cmd == HQM_CPLD) ||
     (hdr_rdata_pcie_cmd == HQM_CPLLK)) begin // Cpl formatting

  iosf_db_in_hdr.cfmt       =  hdr_rdata_hdr.pciecpl.fmt;
  iosf_db_in_hdr.ctype      =  hdr_rdata_hdr.pciecpl.ttype;
  iosf_db_in_hdr.crsvd1_7   =  hdr_rdata_hdr.pciecpl.rsvd3;
  iosf_db_in_hdr.ctc        = {hdr_rdata_hdr.pciecpl.rsvd4
                              ,hdr_rdata_hdr.pciecpl.tc};
  iosf_db_in_hdr.crsvd1_3   =  hdr_rdata_hdr.pciecpl.rsvd2;
  iosf_db_in_hdr.cido       =  hdr_rdata_hdr.pciecpl.attr2;
  iosf_db_in_hdr.crsvd1_1   =  hdr_rdata_hdr.pciecpl.rsvd0;
  iosf_db_in_hdr.cth        =  hdr_rdata_hdr.pciecpl.oh;
  iosf_db_in_hdr.ctd        =  hdr_rdata_hdr.pciecpl.td;
  iosf_db_in_hdr.cep        =  hdr_rdata_hdr.pciecpl.ep;
  iosf_db_in_hdr.cro        =  hdr_rdata_hdr.pciecpl.attr[1];
  iosf_db_in_hdr.cns        =  hdr_rdata_hdr.pciecpl.attr[0];
  iosf_db_in_hdr.cat        =  hdr_rdata_hdr.pciecpl.at;
  iosf_db_in_hdr.clength    =  hdr_rdata_hdr.pciecpl.len;
  iosf_db_in_hdr.crqid      =  hdr_rdata_hdr.pciecpl.rqid;
  iosf_db_in_hdr.ctag       =  hdr_rdata_hdr.pciecpl.tag;
  iosf_db_in_hdr.clbe       =  hdr_rdata_hdr.pciecpl.bytecnt[3:0];
  iosf_db_in_hdr.cfbe       = {hdr_rdata_hdr.pciecpl.bcm
                              ,hdr_rdata_hdr.pciecpl.cplstat};
  iosf_db_in_hdr.caddress   = {32'd0
                              ,hdr_rdata_hdr.pciecpl.cplid
                              ,hdr_rdata_hdr.pciecpl.bytecnt[11:4]
                              ,hdr_rdata_hdr.pciecpl.rsvd5
                              ,hdr_rdata_hdr.pciecpl.lowaddr};
 end else begin

  if (hdr_rdata_hdr.pcie32.fmt[0]) begin // 4DW R/W formatting

   iosf_db_in_hdr.cfmt      = {hdr_rdata_hdr.pcie64.fmt[1], hdr_rdata_fmt0};
   iosf_db_in_hdr.ctype     =  hdr_rdata_hdr.pcie64.ttype;
   iosf_db_in_hdr.crsvd1_7  =  hdr_rdata_hdr.pcie64.rsvd3;
   iosf_db_in_hdr.ctc       = {hdr_rdata_hdr.pcie64.rsvd4
                              ,hdr_rdata_hdr.pcie64.tc};
   iosf_db_in_hdr.crsvd1_3  =  hdr_rdata_hdr.pcie64.rsvd2;
   iosf_db_in_hdr.cido      =  hdr_rdata_hdr.pcie64.attr2;
   iosf_db_in_hdr.crsvd1_1  =  hdr_rdata_hdr.pcie64.rsvd0;
   iosf_db_in_hdr.cth       =  hdr_rdata_hdr.pcie64.oh;
   iosf_db_in_hdr.ctd       =  hdr_rdata_hdr.pcie64.td;
   iosf_db_in_hdr.cep       =  hdr_rdata_hdr.pcie64.ep;
   iosf_db_in_hdr.cro       =  hdr_rdata_hdr.pcie64.attr[1];
   iosf_db_in_hdr.cns       =  hdr_rdata_hdr.pcie64.attr[0];
   iosf_db_in_hdr.cat       =  hdr_rdata_hdr.pcie64.at;
   iosf_db_in_hdr.clength   =  hdr_rdata_hdr.pcie64.len;
   iosf_db_in_hdr.crqid     =  hdr_rdata_hdr.pcie64.rqid;
   iosf_db_in_hdr.ctag      =  hdr_rdata_hdr.pcie64.tag;
   iosf_db_in_hdr.clbe      =  hdr_rdata_hdr.pcie64.lbe;
   iosf_db_in_hdr.cfbe      =  hdr_rdata_hdr.pcie64.fbe;
   iosf_db_in_hdr.caddress  = {hdr_rdata_addr
                              ,hdr_rdata_hdr.pcie64.addr[11:2]
                              ,hdr_rdata_hdr.pcie64.rsvd5
                              ,hdr_rdata_hdr.pcie64.rsvd6};

  end else begin // 3DW R/W formatting

   iosf_db_in_hdr.cfmt      = {hdr_rdata_hdr.pcie32.fmt[1], hdr_rdata_fmt0};
   iosf_db_in_hdr.ctype     =  hdr_rdata_hdr.pcie32.ttype;
   iosf_db_in_hdr.crsvd1_7  =  hdr_rdata_hdr.pcie32.rsvd3;
   iosf_db_in_hdr.ctc       = {hdr_rdata_hdr.pcie32.rsvd4
                              ,hdr_rdata_hdr.pcie32.tc};
   iosf_db_in_hdr.crsvd1_3  =  hdr_rdata_hdr.pcie32.rsvd2;
   iosf_db_in_hdr.cido      =  hdr_rdata_hdr.pcie32.attr2;
   iosf_db_in_hdr.crsvd1_1  =  hdr_rdata_hdr.pcie32.rsvd0;
   iosf_db_in_hdr.cth       =  hdr_rdata_hdr.pcie32.oh;
   iosf_db_in_hdr.ctd       =  hdr_rdata_hdr.pcie32.td;
   iosf_db_in_hdr.cep       =  hdr_rdata_hdr.pcie32.ep;
   iosf_db_in_hdr.cro       =  hdr_rdata_hdr.pcie32.attr[1];
   iosf_db_in_hdr.cns       =  hdr_rdata_hdr.pcie32.attr[0];
   iosf_db_in_hdr.cat       =  hdr_rdata_hdr.pcie32.at;
   iosf_db_in_hdr.clength   =  hdr_rdata_hdr.pcie32.len;
   iosf_db_in_hdr.crqid     =  hdr_rdata_hdr.pcie32.rqid;
   iosf_db_in_hdr.ctag      =  hdr_rdata_hdr.pcie32.tag;
   iosf_db_in_hdr.clbe      =  hdr_rdata_hdr.pcie32.lbe;
   iosf_db_in_hdr.cfbe      =  hdr_rdata_hdr.pcie32.fbe;
   iosf_db_in_hdr.caddress  = {hdr_rdata_addr
                              ,hdr_rdata_hdr.pcie32.addr[11:2]
                              ,hdr_rdata_hdr.pcie32.rsvd5
                              ,hdr_rdata_hdr.pcie32.rsvd6};
  end

 end

end

generate
 for (genvar g=0; g<4; g=g+1) begin: g_dbs

  if (g < 3) begin: g_db

   hqm_AW_double_buffer #(

     .WIDTH             ((2*(MD_WIDTH+MDP_WIDTH+2))+$bits(hqm_iosf_cmd_t))

   ) i_iosf_db (

     .clk               (prim_nonflr_clk)
    ,.rst_n             (prim_gated_rst_b)

    ,.status            ( iosf_db_status[g])

    ,.in_ready          ( iosf_db_in_ready[g])

    ,.in_valid          ( iosf_db_in_valid[g])
    ,.in_data           ({iosf_db_in_parity1
                         ,iosf_db_in_parity0
                         ,iosf_db_in_data1
                         ,iosf_db_in_data0
                         ,iosf_db_in_hdr
                        })

    ,.out_ready         ( iosf_db_out_ready[g])

    ,.out_valid         ( iosf_db_out_valid[g])
    ,.out_data          ({iosf_db_out_parity1[g]
                         ,iosf_db_out_parity0[g]
                         ,iosf_db_out_data1[g]
                         ,iosf_db_out_data0[g]
                         ,iosf_db_out_hdr[g]
                        })
   );

   // Since it takes a cycle to read the storage before the DB is pushed, maintain an early
   // view of the DB depth to use to make decisions about fills.

   always_comb begin

    iosf_db_fill_cnt_inc[g] = iosf_db_fill_req[g];
    iosf_db_fill_cnt_dec[g] = iosf_db_out_valid[g] & iosf_db_out_ready[g];

    case ({iosf_db_fill_cnt_inc[g], iosf_db_fill_cnt_dec[g]})
     2'b10:   iosf_db_fill_cnt_next[g] = iosf_db_fill_cnt_q[g] + 2'd1;
     2'b01:   iosf_db_fill_cnt_next[g] = iosf_db_fill_cnt_q[g] - 2'd1;
     default: iosf_db_fill_cnt_next[g] = iosf_db_fill_cnt_q[g];
    endcase

   end

   always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin
    if (~prim_gated_rst_b) begin
     iosf_db_fill_cnt_q[g] <= '0;
    end else begin
     iosf_db_fill_cnt_q[g] <= iosf_db_fill_cnt_next[g];
    end
   end

  end else begin: g_nodb

   always_comb begin
    iosf_db_out_hdr[g]     = '0;
    iosf_db_out_parity1[g] = '0;
    iosf_db_out_parity0[g] = '0;
    iosf_db_out_data1[g]   = '0;
    iosf_db_out_data0[g]   = '0;
   end

  end

 end
endgenerate

assign p_req_db_status   = iosf_db_status[0];
assign np_req_db_status  = iosf_db_status[1];
assign cpl_req_db_status = iosf_db_status[2];

//----------------------------------------------------------------------------------------------------
// IOSF Command and Data Buses
//
//               ____      ____         ____      ____      ____      ____
// clk          |    |____|    | ~ ____|    |____|    |____|    |____|    |____|
//               ________
// iosf_req     <________>------ ~ ---------------------------------------------
//                                      _________
// iosf_gnt     ________________ ~ ____|         |______________________________
//                                                _________
// iosf_gnt_q   ________________ ~ ______________|         |____________________
//                                                _________
// iosf_cmd     ---------------- ~ --------------<___hdr___>--------------------
//                                                          _________ _________
// iosf_data    ---------------- ~ ------------------------<_data0/1_X_data2/3_>

// The iosf_req_credits counters hold the number of IOSF request credits pushed from the fabric during
// CREDIT_INIT for each rtype. This is the max # of reqs we can push into the fabric for that rtype.
// The req_put counters count the # of outstanding IOSF request transactions that we have pushed to
// the fabric for each rtype but have not yet been granted.  We can't exceed the number of fabric
// credits the fabric gave us during credit init for each rtype.

hqm_AW_bindec #(.WIDTH(2)) i_ll2rl_rl_decode (

     .a         (ll2rl_rl)
    ,.enable    (ll2rl_v)

    ,.dec       (ll2rl_rl_decode)
);

// Block LL to DB loads and counter updates when draining due to an FLR because we're throwing the
// transaction away.

assign ll2db_v_nd = ll2db_v & ~ll_arb_winner_drain;

hqm_AW_bindec #(.WIDTH(2)) i_ll2db_rl_decode (

     .a         (ll2db_rl)
    ,.enable    (ll2db_v_nd)

    ,.dec       (ll2db_rl_decode)
);

generate
 for (genvar g=0; g<3; g++) begin: g_rls

  always_comb begin

   iosf_req_credits_next[g] = iosf_req_credits_q[g];
   iosf_req_credits_m1[g]   = iosf_req_credits_q[g] - {{(HQM_IOSF_REQ_CREDIT_WIDTH-1){1'b0}}, 1'b1};

   // Increment the per rtype IOSF credit counters during credit init.  They then maintain the maximum
   // number of fabric credits (outstanding IOSF requests w/o a grant) until reset.

   if (iosf_gnt_q.gnt & iosf_gnt_q.gtype[1] & (iosf_gnt_q.chid == '0)) begin
    if ((iosf_gnt_q.rtype == g[1:0]) & ~(&iosf_req_credits_q[g])) begin
     iosf_req_credits_next[g] = iosf_req_credits_q[g] + {{(HQM_IOSF_REQ_CREDIT_WIDTH-1){1'b0}}, 1'b1};
    end
   end

   // The per rtype request put counters increment when we send out an IOSF request (from ll2rl or ll2db)
   // and decrement whenever we receive a grant for the rtype.

   case ({(ll2rl_rl_decode[g] | ll2db_rl_decode[g]), gnt_rl_decode[g]})
    2'b10:   req_put_cnt_next[g] = req_put_cnt_q[g] + {{(HQM_IOSF_REQ_CREDIT_WIDTH-1){1'b0}}, 1'b1};
    2'b01:   req_put_cnt_next[g] = req_put_cnt_q[g] - {{(HQM_IOSF_REQ_CREDIT_WIDTH-1){1'b0}}, 1'b1};
    default: req_put_cnt_next[g] = req_put_cnt_q[g];
   endcase

   // The per rtype fabric almost full indicates we've used all our fabric credits for this rtype.
   // The req_put_cnt should never exceed the iosf_req_credits count.
   // Infinite credits would be denoted by an iosf_req_credits count of 0.
   // The almost full should never assert for an infinite credits case.
   // The almost full is used to gate off the arbiter inputs.
   // Comparing to minus 1 of the number of credits to account for registering the arbiter output.

   req_put_afull_next[g] = (req_put_cnt_next[g] >= iosf_req_credits_m1[g]) & (|iosf_req_credits_q[g]);

  end

  always_ff @ (posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin
   if (~prim_gated_rst_b) begin
    iosf_req_credits_q[g] <= '0;
    req_put_cnt_q[g]      <= '0;
    req_put_afull_q[g]    <= '0;
   end else begin
    iosf_req_credits_q[g] <= iosf_req_credits_next[g];
    req_put_cnt_q[g]      <= req_put_cnt_next[g];
    req_put_afull_q[g]    <= req_put_afull_next[g];
   end
  end

 end
endgenerate

hqm_AW_unused_bits i_unused_rl_dec (.a(|{ll2rl_rl_decode[3], ll2db_rl_decode[3]}));

always_comb begin // Credit Debug

 sif_mstr_debug.FABRIC_P_CREDITS   = iosf_req_credits_q[0];
 sif_mstr_debug.FABRIC_NP_CREDITS  = iosf_req_credits_q[1];
 sif_mstr_debug.FABRIC_CPL_CREDITS = iosf_req_credits_q[2];

 mstr_crd_status.P_REQ_PUT_CNT      = req_put_cnt_q[0];
 mstr_crd_status.NP_REQ_PUT_CNT     = req_put_cnt_q[1];
 mstr_crd_status.CPL_REQ_PUT_CNT    = req_put_cnt_q[2];

end

//----------------------------------------------------------------------------------------------------
// Register the grant before looking at it.
//
// The gnt_q vector is an indication that a valid normal grant (as opposed to a credit init grant)
// was received.  It is multiple bits to spread out the loading.

assign gnt_next = iosf_gnt.gnt & (iosf_gnt.gtype == 2'b00) &
                                ((iosf_gnt.rtype == 2'b00)
                               | (iosf_gnt.rtype == 2'b01)
                               | (iosf_gnt.rtype == 2'b10));

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin
 if (~prim_gated_rst_b) begin
  iosf_gnt_q  <= '0;
  gnt_q       <= '0;
 end else if (|prim_ism_agent) begin
  iosf_gnt_q  <= iosf_gnt;
  gnt_q       <= {12{gnt_next}};
 end
end

hqm_AW_bindec #(.WIDTH(2)) i_gnt_rl_decode (

     .a         (iosf_gnt_q.rtype)
    ,.enable    (gnt_q[11])

    ,.dec       (gnt_rl_decode)
);

//----------------------------------------------------------------------------------------------------

always_comb begin

 iosf_db_out_ready = '0;

 iosf_data0_v_next = '0;
 iosf_data0_next   = '0;
 iosf_parity0_next = '0;

 iosf_data1_v_next = '0;
 iosf_data1_next   = iosf_data1_q;
 iosf_parity1_next = iosf_parity1_q;

 // Header/data are selected from the iosf DB outputs based on the grant rtype.

 iosf_cmd_out      = iosf_db_out_hdr[iosf_gnt_q.rtype];

 // Zero out the header when not actively driving it based on the registered grant.
 // Trying to keep these paths as short as possible...

 iosf_cmd = iosf_cmd_out & {
            {($bits(hqm_iosf_cmd_t)-160){gnt_q[10]}}
                                    ,{16{gnt_q[ 9]}}
                                    ,{16{gnt_q[ 8]}}
                                    ,{16{gnt_q[ 7]}}
                                    ,{16{gnt_q[ 6]}}
                                    ,{16{gnt_q[ 5]}}
                                    ,{16{gnt_q[ 4]}}
                                    ,{16{gnt_q[ 3]}}
                                    ,{16{gnt_q[ 2]}}
                                    ,{16{gnt_q[ 1]}}
                                    ,{16{gnt_q[ 0]}}
 };

 if (gnt_q[11]) begin // Granted

  // Pop the appropriate RL DB

  iosf_db_out_ready[iosf_gnt_q.rtype] = '1;

  if (|iosf_cmd_out.cfmt[1]) begin // Has data

   // If command requires data, set it up for the next cycle

   iosf_data0_v_next = '1;
   iosf_data0_next   = iosf_db_out_data0[  iosf_gnt_q.rtype];
   iosf_parity0_next = iosf_db_out_parity0[iosf_gnt_q.rtype];

   if (iosf_cmd_out.clength > 10'd8) begin // 2nd data cycle required

    iosf_data1_v_next = '1;
    iosf_data1_next   = iosf_db_out_data1[  iosf_gnt_q.rtype];
    iosf_parity1_next = iosf_db_out_parity1[iosf_gnt_q.rtype];

   end // 2nd data cycle required

  end // Has data

 end // Granted

 if (iosf_data1_v_q) begin // 2nd data cycle

  iosf_data0_v_next = '1;
  iosf_data0_next   = iosf_data1_q;
  iosf_parity0_next = iosf_parity1_q;

 end // 2nd data cycle

end // always_comb

//----------------------------------------------------------------------------------------------------
// Flop the IOSF data/parity bus

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin
 if (~prim_gated_rst_b) begin
  iosf_data0_v_q <= '0;
  iosf_data1_v_q <= '0;
  iosf_data0_q   <= '0;
  iosf_data1_q   <= '0;
  iosf_parity0_q <= '0;
  iosf_parity1_q <= '0;
 end else begin
  iosf_data0_v_q <= iosf_data0_v_next;
  iosf_data1_v_q <= iosf_data1_v_next;
  if (iosf_data0_v_next | iosf_data0_v_q) begin
   iosf_data0_q   <= iosf_data0_next;
   iosf_parity0_q <= iosf_parity0_next;
  end
  if (iosf_data1_v_next) begin
   iosf_data1_q   <= iosf_data1_next;
   iosf_parity1_q <= iosf_parity1_next;
  end
 end
end

assign iosf_data   = iosf_data0_q;
assign iosf_parity = iosf_parity0_q;

//----------------------------------------------------------------------------------------------------
// Set MDPE when we send a poisoned transaction
//TBD: Do we ever set the ep bit?

assign poisoned_wr_sent_next = write_buffer_mstr_v & write_buffer_mstr_ready & 1'b0;

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin
  if (~prim_gated_rst_b) begin
    poisoned_wr_sent_q <= '0;
  end else begin
    poisoned_wr_sent_q <= poisoned_wr_sent_next;
  end
end

assign poisoned_wr_sent = poisoned_wr_sent_q;

//----------------------------------------------------------------------------------------------------
// Idle and ResetPrep quiesce

always_comb begin

 // Not idle if the scoreboard has outstanding transactions, the FL isn't full, we have something in
 // the output stages (DBs and interface regs), or the devtlb has any pending invalidate requests.

 // Need 2 different IDLE outputs.  One is used for the ISM and needs to track just when we have
 // outstanding interface requests not granted or outstanding NP transactions.  The other needs to
 // be the indication that the entire MSTR is IDLE used for the clock request.

 mstr_req_idle  = ~(|{ll_arb_winner_v_next
                     ,ll_arb_winner_v_q
                     ,req_put_cnt_q[2]
                     ,req_put_cnt_q[1]
                     ,req_put_cnt_q[0]
                     ,iosf_data0_v_q
                     });

 mstr_intf_idle = mstr_req_idle & ~np_trans_pending;

 mstr_idle      = fl_full & mstr_intf_idle & ~(invreqs_active & ~devtlb_reset);

end

// ResetPrep Vote Handling Logic - Vote to send a ResetPrepAck when the master is idle.
// A quiesce request will prevent any new P or NP requests by blocking the arbiter inputs.
// Can be considered quiesced from a mastering point of view when any oustanding interface requests
// have been granted and sent out.

assign sif_mstr_quiesce_ack_next = sif_mstr_quiesce_ack_q |         // Remain set until reset
                                   (sif_mstr_quiesce_req_q &        // Only take a vote if quiesce is requested
                                    mstr_req_idle);                 // Master has no ungranted interface requests

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin
 if (~prim_gated_rst_b) begin
  sif_mstr_quiesce_req_q <= '0;
  sif_mstr_quiesce_ack_q <= '0;
 end else begin
  sif_mstr_quiesce_req_q <= sif_mstr_quiesce_req_q | sif_mstr_quiesce_req;
  sif_mstr_quiesce_ack_q <= sif_mstr_quiesce_ack_next;
 end
end

assign sif_mstr_quiesce_ack = sif_mstr_quiesce_ack_q;

//----------------------------------------------------------------------------------------------------
// Convert ATS requests to IOSF NP transactions
//
// Need to be able to limit the maximum number of HP and LP ATS requests outstanding (max is 32).
// Adding counters for the requests that are compared against configurable limits.
// Need an available freelist location and an available scoreboard location to store the ID so it can
// be looked up and returned with the ATS response.  The tag used is the scoreboard location.

always_comb begin

 ats_alloc_data       = '0;

 ats_req_ack          = '0;

 ats_req_cnt_dec      = '0;
 ats_req_cnt_inc      = '0;

 ats_req_cnt_lt_limit = (ats_req_cnt_q < cfg_scrbd_ctl.ATS_LIMIT);

 // Defaults here for the NP header are set up for a 3DW HP ATS request (modify only if LP or 4DW)

 atshdr_v             = '0;
 atshdr               = '0;
 atshdr_pasidtlp      = {
                         ats_req.pasid_valid[1]
                        ,ats_req.pasid_priv[1]
                        ,1'b0
                        ,ats_req.pasid[1]
                        };

 // Note that rsvd4(tc[3]), attr2(ido), rsvd0(rsvd1_1), oh(th), td, ep, attr[0](ns), rsvd5(addr[1:0]) are always 0

 atshdr.pcie32.fmt     = 2'h0;
 atshdr.pcie32.ttype   = 5'h00;
 atshdr.pcie32.tc      = ats_req.tc[1];
 atshdr.pcie32.at      = 2'h1;
 atshdr.pcie32.attr[1] = csr_ppdcntl_ero;           // Set to 1 (if allowed) to prevent deadlock of ATS Cpl stuck behind posted
 atshdr.pcie32.len     = 10'h002;
 atshdr.pcie32.rqid    = {current_bus, 8'd0};
 atshdr.pcie32.rsvd3   = scrbd_tag_10b[9];          // rsvd1_7
 atshdr.pcie32.rsvd2   = scrbd_tag_10b[8];          // rsvd1_3
 atshdr.pcie32.tag     = scrbd_tag_10b[7:0];
 atshdr.pcie32.lbe     = 4'hf;
 atshdr.pcie32.fbe     = 4'hf;
 atshdr.pcie32.rsvd6   = ats_req.nw[1];
 atshdr.pcie32.addr    = {ats_req.address[1][31:12], 10'd0};

 atshdr_par            = ^{atshdr_pasidtlp, atshdr.pcie32};

 // Don't allow an ATS request if an FLR is pending.  We're going to nuke the devtlb anyway.

 if (scrbd_tag_v & ~fl_empty & ~flr_txn_sent_q) begin // Tag and FL available

  if (ats_req_v[1] & ats_req_cnt_lt_limit & ~devtlb_reset) begin // HP ATS Request

   // If HP ATS request is available and the current count is less than the configured limit, form
   // the NP request, push it onto the NP LL, increment the counter, ack the ATS request, and
   // allocate the scoreboard entry.

   atshdr_v              = '1;

   if (|ats_req.address[1][DEVTLB_MAX_LINEAR_ADDRESS_WIDTH-1:32]) begin // 4DW

    atshdr.pcie64.fmt    = 2'h1;
    atshdr.pcie64.addr   = {
                            {(64-DEVTLB_MAX_LINEAR_ADDRESS_WIDTH){1'b0}}
                           ,ats_req.address[1][DEVTLB_MAX_LINEAR_ADDRESS_WIDTH-1:12]
                           ,10'd0
                           };
    atshdr_par           = ^{atshdr_pasidtlp, atshdr.pcie64};

   end

   ats_alloc_data        = '0;
   ats_alloc_data.src    = 2'd1;
   ats_alloc_data.id     = {{(HQM_MSTR_NUM_CQS_WIDTH-6){1'b0}}, ats_req.id[1]};
   ats_alloc_data.parity = ~(^ats_req.id[1]);

   if (atshdr_ready) begin

    ats_req_ack[1]       = '1;
    ats_req_cnt_inc      = '1;

   end

  end // HP ATS Request

  else if (ats_req_v[0] & ats_req_cnt_lt_limit & ~devtlb_reset) begin // LP ATS Request

   // If LP ATS request is available and the current count is less than the configured threshold,
   // form the NP request, push it onto the NP LL, increment the counter, ack the ATS request, and
   // allocate the scoreboard entry.

   atshdr_v              = '1;

   atshdr_pasidtlp       = {
                            ats_req.pasid_valid[0]
                           ,ats_req.pasid_priv[0]
                           ,1'b0
                           ,ats_req.pasid[0]
                           };

   atshdr.pcie32.tc      = ats_req.tc[0];
   atshdr.pcie32.rsvd6   = ats_req.nw[0];

   if (|ats_req.address[0][DEVTLB_MAX_LINEAR_ADDRESS_WIDTH-1:32]) begin // 4DW

    atshdr.pcie64.fmt    = 2'h1;
    atshdr.pcie64.addr   = {
                            {(64-DEVTLB_MAX_LINEAR_ADDRESS_WIDTH){1'b0}}
                           ,ats_req.address[0][DEVTLB_MAX_LINEAR_ADDRESS_WIDTH-1:12]
                           ,10'd0
                           };
    atshdr_par           = ^{atshdr_pasidtlp, atshdr.pcie64};

   end else begin // 3DW

    atshdr.pcie32.addr   = {ats_req.address[0][31:12], 10'd0};
    atshdr_par           = ^{atshdr_pasidtlp, atshdr.pcie32};

   end

   ats_alloc_data        = '0;
   ats_alloc_data.src    = 2'd1;
   ats_alloc_data.id     = {{(HQM_MSTR_NUM_CQS_WIDTH-6){1'b0}}, ats_req.id[0]};
   ats_alloc_data.parity = ~(^ats_req.id[0]);

   if (atshdr_ready) begin

    ats_req_ack[1]       = '1;
    ats_req_cnt_inc      = '1;

   end

  end // LP ATS Request

 end // Tag and FL available

 if (ats_rsp_v) begin

  // Decrement ATS request counter

  ats_req_cnt_dec        = '1;

 end

 // ATS request counter inc/dec

 case ({ats_req_cnt_inc, ats_req_cnt_dec})
  2'b10:   ats_req_cnt_next = ats_req_cnt_q + 6'd1;
  2'b01:   ats_req_cnt_next = ats_req_cnt_q - 6'd1;
  default: ats_req_cnt_next = ats_req_cnt_q;
 endcase

end

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin
 if (~prim_gated_rst_b) begin
  ats_req_cnt_q <= '0;
 end else begin
  ats_req_cnt_q <= ats_req_cnt_next;
 end
end

//------------------------------------------------------------------------------------------------
// Drain requests
//
// Need to stop sending any new devtlb requests and wait for any ATS enabled transactions to drain.

always_comb begin

 drain_req_ack    = '0;

 drain_rsp_v      = '0;
 drain_rsp        = '0;

 clr_hpa_v        = '0;

 drain_pend_next  = drain_pend_q;
 drain_req_next   = drain_req_q;;

 invrsp_pend_next = invrsp_pend_q;

 if (drain_req_v & ~devtlb_reset) begin // Drain request

  // Acknowledge the drain request, set the drain and invalidate response pending flags

  drain_req_ack    = '1;

  drain_pend_next  = '1;
  drain_req_next   = drain_req;

  invrsp_pend_next = '1;

 end // Drain request

 else if (drain_pend_q) begin // Drain pending

  // Sledge hammer for now: Wait until whole master is empty

  if (fl_full) begin

   // Reset the drain pending flag, send the drain response, and clear the local hpa_v flag

   drain_pend_next  = '0;

   drain_rsp_v      = '1;
   drain_rsp.tc     = '1;

   clr_hpa_v        = '1;

  end

 end // Drain pending

 // If we have reset the drain pending because we're empty and the devtlb has deasserted its
 // invalidate requests active flag, we can reset our invalidate response pending flag to
 // allow us to generate new ATS requests to the devtlb.

 else if (invrsp_pend_q & ~(invreqs_active & ~devtlb_reset)) begin

  invrsp_pend_next = '0;

 end

end

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin
 if (~prim_gated_rst_b) begin
  drain_pend_q  <= '0;
  invrsp_pend_q <= '0;
 end else begin
  drain_pend_q  <= drain_pend_next;
  invrsp_pend_q <= invrsp_pend_next;
 end
end

always_ff @(posedge prim_nonflr_clk) begin
 if (drain_req_v & ~drain_pend_q) begin
  drain_req_q <= drain_req;
 end
end

//------------------------------------------------------------------------------------------------
// Set flr_txn_sent_q when the flr_txn_sent pulse comes in and keep it set until the FLR occurs.
// Save the tag and reqid to compare to identify the completion for the startflr write.
// Set flr_cpl_sent_q when that completion is detected and keep it set until the FLR occurs.
// Use flr_cpl_sent_q to prevent processing any further transactions until after the FLR occurs.
// Replicated for fanout.
// So it needs to do what?

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_wflr_rst_b) begin
 if (~prim_gated_wflr_rst_b) begin
  flr_txn_sent_q   <= '0;
  flr_txn_reqid_q  <= '0;
  flr_txn_tag_q    <= '0;
  flr_cpl_sent_q   <= '0;
 end else begin
  flr_txn_sent_q   <= flr_txn_sent | flr_txn_sent_q;
  if (flr_txn_sent & ~flr_txn_sent_q) begin
   flr_txn_reqid_q <= flr_txn_reqid;
   flr_txn_tag_q   <= flr_txn_tag;
  end
  flr_cpl_sent_q   <= (flr_cpl_sent_q) ? func_in_rst : flr_cpl_sent_next;
 end
end

assign flr_cpl_sent = flr_cpl_sent_q;

//------------------------------------------------------------------------------------------------
// Set ps_txn_sent_q when the ps_txn_sent pulse comes in and keep it set until the completion occurs.
// Save the tag and reqid to compare to identify the completion for the ps write.
// Set ps_cpl_sent_q when that completion is detected and keep it set until we are back in D0 power
// state as indicated by a completion header received with the pm field all zeros.
// Use ps_cpl_sent_q to prevent further posted transactions from being processed.
// So it needs to do what?

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_wflr_rst_b) begin
 if (~prim_gated_wflr_rst_b) begin
  ps_txn_sent_q   <= '0;
  ps_txn_reqid_q  <= '0;
  ps_txn_tag_q    <= '0;
  ps_cpl_sent_q   <= '0;
 end else begin
  ps_txn_sent_q   <= (ps_txn_sent |  ps_txn_sent_q) & ~ps_cpl_sent_next;
  if (ps_txn_sent & ~ps_txn_sent_q) begin
   ps_txn_reqid_q <=  ps_txn_reqid;
   ps_txn_tag_q   <=  ps_txn_tag;
  end
  ps_cpl_sent_q  <= (ps_cpl_sent_q | ps_cpl_sent_next) & ~ps_d0;
 end
end

//------------------------------------------------------------------------------------------------
// Parity error reporting

assign parity_error_next = {
                             scrbd_perr
                            ,ibcpl_data_fifo_perr
                            ,ibcpl_hdr_fifo_perr
                            ,(tlb_data_parity_err[2:0] & ~{3{devtlb_reset}})
                            ,(tlb_tag_parity_err[ 2:0] & ~{3{devtlb_reset}})
};

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin
 if (~prim_gated_rst_b) begin
  parity_error_q      <= '0;
  parity_error_last_q <= '0;
 end else begin
  parity_error_q      <= parity_error_next;
  parity_error_last_q <= parity_error_q;
 end
end

assign sif_parity_alarm   = |(parity_error_q & ~parity_error_last_q);
assign set_sif_parity_err =   parity_error_q & ~parity_error_last_q;

//------------------------------------------------------------------------------------------------
// Dedicated system drop counter for MSI-X dropped due to MSIXE==0 or CQ dropped due to drain.

// Invalid drops are already counted by the write buffer.

assign cnt_inc = (wb_drop_msixe | wb_drop_cq) & ~flr_treatment_vec;    // 1:0 Posted drops

hqm_AW_inc_64b_val i_cnt (

     .clk       (prim_nonflr_clk)
    ,.rst_n     (prim_gated_rst_b)
    ,.clr       (hqm_sif_cnt_ctl.CNT_CLR)
    ,.clrv      (hqm_sif_cnt_ctl.CNT_CLRV)
    ,.inc       (cnt_inc)
    ,.count     ({mstr_cnts[1], mstr_cnts[0]})
);

//------------------------------------------------------------------------------------------------
// Register a trigger indication if the trigger is enabled and the address matches the configured
// address with mask when we write the posted header storage.
// Stretch the trigger for 5 prim_clk cycles in case the trigger clock ends up not being
// being faster than prim_clk.

assign ph_trigger_next = memi_mstr_ll_hdr_q.we & cfg_ph_trigger_enable &
    ((memi_mstr_ll_hdr_q[63:0] & cfg_ph_trigger_mask) == (cfg_ph_trigger_addr & cfg_ph_trigger_mask));

hqm_AW_pulse_stretch #(.PULSE_WIDTH(5)) i_ph_trigger (

     .clk       (prim_nonflr_clk)
    ,.rst_n     (prim_gated_wflr_rst_b)
    ,.din       (ph_trigger_next)

    ,.dout      (ph_trigger)
);

//------------------------------------------------------------------------------------------------

// TBD: Update visa.sig to reflect new set of signals

always_comb begin

 noa_mstr[  7:  0] = {write_buffer_mstr.hdr.invalid
                     ,write_buffer_mstr.hdr.cq_v
                     ,write_buffer_mstr.hdr.cq_ldb
                     ,write_buffer_mstr.hdr.src[1:0]
                     ,write_buffer_mstr_ready
                     ,write_buffer_mstr_v
                     };
 noa_mstr[ 15:  8] = {write_buffer_mstr_v
                     ,phdr.pcie64.fmt
                     ,phdr.pcie64.ttype
                     };
 noa_mstr[ 23: 16] = {poisoned_wr_sent
                     ,(wb_msix | wb_ims)
                     ,write_buffer_mstr.hdr.cq[5:0]
                     };
 noa_mstr[ 31: 24] = {sif_mstr_quiesce_req_q
                     ,sif_mstr_quiesce_ack
                     ,write_buffer_mstr.hdr.tc_sel[1:0]
                     ,phdr_tc[3:0]
                     };
 noa_mstr[ 39: 32] = {write_buffer_mstr.hdr.num_hcws[2:0]
                     ,write_buffer_mstr.hdr.length[4:0]
                     };
 noa_mstr[ 47: 40] = {fl2ll_v
                     ,fl_push
                     ,ll2rl_v
                     ,ll2rl_rl
                     ,rl2db_v
                     ,rl2db_rl
                     };
 noa_mstr[ 55: 48] =  fl2ll_ll;

 noa_mstr[ 63: 56] =  ll2rl_ll;
 noa_mstr[ 71: 64] =  fl_push_ptr;

 noa_mstr[ 79: 72] = {devtlb_req_v
                     ,devtlb_req.pasid_valid
                     ,devtlb_req.opcode[1:0]
                     ,(devtlb_rsp_v & ~devtlb_reset)
                     ,devtlb_rsp.result
                     ,devtlb_rsp.dperror
                     ,devtlb_rsp.hdrerror
                     };
 noa_mstr[ 87: 80] = {rx_msg_v
                     ,rx_msg.pasid_valid
                     ,rx_msg.opcode
                     ,rx_msg.dperror
                     ,(tx_msg_v & ~devtlb_reset)
                     ,tx_msg_ack
                     ,tx_msg.pasid_valid
                     ,tx_msg.opcode
                     };
 noa_mstr[ 95: 88] = {(ats_req_v[1:0] & ~{2{devtlb_reset}})
                     ,ats_req_ack[1:0]
                     ,ats_req.pasid_valid[1:0]
                     ,imp_invalidation_v
                     ,tlb_reset_active
                     };
 noa_mstr[103: 96] = {ats_rsp_v
                     ,ats_rsp.dperror
                     ,ats_rsp.hdrerror
                     ,ats_rsp.data[55:54]
                     ,(xreqs_active & ~devtlb_reset)
                     ,(invreqs_active & ~devtlb_reset)
                     ,mstr_idle
                     };
 noa_mstr[111:104] = {scrbd_alloc
                     ,scrbd_free
                     ,ibcpl_hdr_push
                     ,ibcpl_data_push
                     ,cpl_timeout
                     ,cpl_abort
                     ,cpl_unexpected
                     ,np_trans_pending
                     };
 noa_mstr[119:112] =  parity_error_q[7:0];
 noa_mstr[127:120] = {parity_error_q[8]
                     ,prim_ism_agent[2:0]
                     ,iosf_db_in_valid[2]
                     ,iosf_db_out_ready[2]
                     ,iosf_db_in_valid[1]
                     ,iosf_db_out_ready[1]
                     };
 noa_mstr[135:128] = {iosf_db_in_valid[0]
                     ,iosf_db_out_ready[0]
                     ,cpl_req_db_status[1:0]
                     ,np_req_db_status[1:0]
                     ,p_req_db_status[1:0]
                     };
 noa_mstr[143:136] = {iosf_gnt_q.gtype, iosf_gnt_q.rtype, iosf_gnt_q.gnt, iosf_req.rtype, iosf_req.put};
 noa_mstr[151:144] = {iosf_gnt_q.gnt, iosf_cmd.cfmt, iosf_cmd.ctype};
 noa_mstr[159:152] = {iosf_cmd.cat, iosf_data0_v_q, iosf_req.dlen[4:0]};
 noa_mstr[167:160] = {iosf_cmd.clength[7:0]};
 noa_mstr[175:168] = {iosf_cmd.crqid[15:8]};
 noa_mstr[183:176] = {iosf_cmd.ctag};
 noa_mstr[191:184] = {iosf_cmd.clbe, iosf_cmd.cfbe};

end

//------------------------------------------------------------------------------------------------
// Per CQ non-posted counters to support source ordering

always_comb begin

 for (int i=0; i<HQM_MSTR_NUM_CQS; i=i+1) begin

  case ({cq_np_cnt_inc[i], cq_np_cnt_dec[i]})
   2'b01:   cq_np_cnt_next[i] = cq_np_cnt_q[i] - 9'd1;
   2'b10:   cq_np_cnt_next[i] = cq_np_cnt_q[i] + 9'd1;
   default: cq_np_cnt_next[i] = cq_np_cnt_q[i];
  endcase

 end

end

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin
 if (~prim_gated_rst_b) begin
  for (int i=0; i<HQM_MSTR_NUM_CQS; i=i+1) begin
   cq_np_cnt_q[i] <= '0;
  end
 end else begin
  cq_np_cnt_q <= cq_np_cnt_next;
 end
end

endmodule // hqm_iosf_mstr

