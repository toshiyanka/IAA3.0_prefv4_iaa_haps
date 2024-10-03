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
// HQM Receive interface
//-----------------------------------------------------------------------------------------------------
`include "hqm_system_def.vh"

module hqm_ri

     import hqm_AW_pkg::*, hqm_pkg::*, hqm_system_pkg::*, hqm_sif_csr_pkg::*, hqm_sif_pkg::*, hqm_system_type_pkg::*;
(
    //-------------------------------------------------------------------------------------------------
    // Clocks and resets

     input  logic                               prim_freerun_clk                // Ungated primary clock
    ,input  logic                               prim_gated_clk                  // Gated primary clock
    ,input  logic                               prim_nonflr_clk                 // FLR gated primary clock

    ,input  logic                               prim_gated_rst_b                // added for DCN 90006 - FLR to be tied to secondary bus reset

    ,input  logic                               side_gated_rst_prim_b           // asynchronous assertion, deassertion synced to prim_clk

    ,input  logic                               powergood_rst_b                 // PowerGood signal used to reset all registers
                                                                                //  including sticky registers
    ,output logic                               hqm_csr_pf0_rst_n

    //-------------------------------------------------------------------------------------------------
    // Straps

    ,input  logic                               strap_hqm_is_reg_ep             // HQM is regular EP instead of RCIEP
    ,input  logic                               strap_hqm_completertenbittagen  // 10b tags supported
    ,input  logic [63:0]                        strap_hqm_csr_cp
    ,input  logic [63:0]                        strap_hqm_csr_rac
    ,input  logic [63:0]                        strap_hqm_csr_wac
    ,input  logic [15:0]                        strap_hqm_device_id

    //-------------------------------------------------------------------------------------------------
    // Link Layer Interface

    ,input  logic                               lli_phdr_val
    ,input  tdl_phdr_t                          lli_phdr
    ,input  logic                               lli_nphdr_val
    ,input  tdl_nphdr_t                         lli_nphdr

    ,input  logic                               lli_pdata_push
    ,input  logic                               lli_npdata_push
    ,input  ri_bus_width_t                      lli_pkt_data
    ,input  ri_bus_par_t                        lli_pkt_data_par

    ,output hqm_iosf_tgt_crd_t                  ri_tgt_crd_inc                  // Target credit return

    ,input  new_TGT_INIT_HCREDITS_t             tgt_init_hcredits
    ,input  new_TGT_INIT_DCREDITS_t             tgt_init_dcredits
    ,input  new_TGT_REM_HCREDITS_t              tgt_rem_hcredits
    ,input  new_TGT_REM_DCREDITS_t              tgt_rem_dcredits
    ,input  new_TGT_RET_HCREDITS_t              tgt_ret_hcredits
    ,input  new_TGT_RET_DCREDITS_t              tgt_ret_dcredits

    ,input  logic                               cpl_usr                         // Completion UR
    ,input  logic                               cpl_abort                       // Completer abort
    ,input  logic                               cpl_poisoned                    // Completion poisoned
    ,input  logic                               cpl_unexpected                  // Unexpected completion
    ,input  tdl_cplhdr_t                        cpl_error_hdr                   // header of unexpected completion

    ,input  logic                               cpl_timeout                     // Completion timeout
    ,input  logic [8:0]                         cpl_timeout_synd                // Completion timeout syndrome

    ,input  logic                               iosf_ep_cpar_err                // Cmd Hdr parity error detected
    ,input  logic                               iosf_ep_tecrc_err
    ,input  errhdr_t                            iosf_ep_chdr_w_err

    ,input  logic                               np_trans_pending
    ,input  logic                               poisoned_wr_sent

    //-------------------------------------------------------------------------------------------------
    // HCW Enqueue Interface

    ,input  logic                               hcw_enq_in_ready                // ready to accept a HCW enqueue

    ,output logic                               hcw_enq_in_v                    // valid HCW enqueue request
    ,output hqm_system_enq_data_in_t            hcw_enq_in_data                 // HCW enqueue data

    //-------------------------------------------------------------------------------------------------
    // Outbound Completions

    ,input  logic                               obcpl_ready                     // MSTR taking outbound completion

    ,output logic                               obcpl_v                         // Outbound completion valid
    ,output RiObCplHdr_t                        obcpl_hdr                       // Outbound completion header
    ,output csr_data_t                          obcpl_data                      // Outbound completion data
    ,output logic                               obcpl_dpar                      // Outbound completion data parity
    ,output upd_enables_t                       obcpl_enables                   // Outbound completion flags

    ,output upd_enables_t                       gpsb_upd_enables

    //-------------------------------------------------------------------------------------------------
    // FLR

    ,input  logic                               gnt                             // added for DCN 90006 - FLR to be tied to secondary bus reset
    ,input  logic [1:0]                         gnt_rtype                       // added for DCN 90006 - FLR to be tied to secondary bus reset
    ,input  logic                               mrsvd1_7                        // added for DCN 90006 - FLR to be tied to secondary bus reset
    ,input  logic                               mrsvd1_3                        // added for DCN 90006 - FLR to be tied to secondary bus reset
    ,input  logic [7:0]                         mtag                            // added for DCN 90006 - FLR to be tied to secondary bus reset
    ,input  logic [15:0]                        mrqid                           // added for DCN 90006 - FLR to be tied to secondary bus reset

    ,output logic                               func_in_rst

    ,output logic                               flr_treatment
    ,output logic                               flr_treatment_vec
    ,output logic [6:2]                         flr_triggered_wl                // input for DCN 90006 - FLR for link clk to reset TLQs
    ,output logic                               flr_clk_enable
    ,output logic                               flr_clk_enable_system

    ,output logic                               flr_txn_sent
    ,output nphdr_tag_t                         flr_txn_tag
    ,output hdr_reqid_t                         flr_txn_reqid

    ,output logic                               ps_txn_sent
    ,output nphdr_tag_t                         ps_txn_tag
    ,output hdr_reqid_t                         ps_txn_reqid

    //-------------------------------------------------------------------------------------------------
    // CFG Interface

    ,input  hqm_sif_csr_hc_rvalid_t             hqm_sif_csr_hc_rvalid
    ,input  hqm_sif_csr_hc_wvalid_t             hqm_sif_csr_hc_wvalid
    ,input  hqm_sif_csr_hc_error_t              hqm_sif_csr_hc_error
    ,input  hqm_sif_csr_hc_reg_read_t           hqm_sif_csr_hc_reg_read

    ,output logic [47:0]                        hqm_sif_csr_hc_addr
    ,output hqm_sif_csr_handcoded_t             hqm_sif_csr_hc_we
    ,output hqm_sif_csr_hc_re_t                 hqm_sif_csr_hc_re
    ,output hqm_sif_csr_hc_reg_write_t          hqm_sif_csr_hc_reg_write

    ,output hqm_sif_csr_sai_export_t            hqm_sif_csr_sai_export

    ,output hqm_rtlgen_pkg_v12::cfg_req_32bit_t hqm_csr_ext_mmio_req
    ,output logic                               hqm_csr_ext_mmio_req_apar
    ,output logic                               hqm_csr_ext_mmio_req_dpar

    ,input  hqm_rtlgen_pkg_v12::cfg_ack_32bit_t hqm_csr_ext_mmio_ack
    ,input  logic [1:0]                         hqm_csr_ext_mmio_ack_err

    //-------------------------------------------------------------------------------------------------
    // Config

    ,output logic [63:0]                        hqm_csr_rac
    ,output logic [63:0]                        hqm_csr_wac

    ,output logic                               csr_ppdcntl_ero
    ,output logic                               csr_pasid_enable
    ,output logic                               csr_pmsixctl_msie_wxp           // Control output for MSIX enable
    ,output logic                               csr_pmsixctl_fm_wxp             // MSIX per function mask

    ,output logic [7:0]                         current_bus                     // Bus field of the requester ID for each function.

    ,output HQM_SIF_CNT_CTL_t                   hqm_sif_cnt_ctl

    ,output PRIM_CDC_CTL_t                      prim_cdc_ctl
    ,output SIDE_CDC_CTL_t                      side_cdc_ctl
    ,output IOSFP_CGCTL_t                       iosfp_cgctl
    ,output IOSFS_CGCTL_t                       iosfs_cgctl

    ,output CFG_MASTER_TIMEOUT_t                cfg_master_timeout
    ,output hqm_sif_csr_pkg::PARITY_CTL_t       parity_ctl
    ,output logic [63:0]                        cfg_ph_trigger_addr
    ,output logic [63:0]                        cfg_ph_trigger_mask

    ,output logic                               ats_enabled
    ,output SCRBD_CTL_t                         scrbd_ctl
    ,output MSTR_LL_CTL_t                       mstr_ll_ctl
    ,output DEVTLB_CTL_t                        devtlb_ctl
    ,output DEVTLB_SPARE_t                      devtlb_spare
    ,output DEVTLB_DEFEATURE0_t                 devtlb_defeature0
    ,output DEVTLB_DEFEATURE1_t                 devtlb_defeature1
    ,output DEVTLB_DEFEATURE2_t                 devtlb_defeature2

    ,output IBCPL_HDR_FIFO_CTL_t                ibcpl_hdr_fifo_ctl
    ,output IBCPL_DATA_FIFO_CTL_t               ibcpl_data_fifo_ctl

    ,output logic                               cfg_visa_sw_control_write
    ,output VISA_SW_CONTROL_t                   cfg_visa_sw_control_wdata

    ,input  logic                               cfg_visa_sw_control_write_done
    ,input  VISA_SW_CONTROL_t                   cfg_visa_sw_control

    ,output DIR_CQ2TC_MAP_t                     dir_cq2tc_map
    ,output LDB_CQ2TC_MAP_t                     ldb_cq2tc_map
    ,output INT2TC_MAP_t                        int2tc_map

    ,input  hqm_sif_fuses_t                     sb_ep_fuses                     // Contains all fuses

    ,output SIF_CTL_t                           cfg_sif_ctl
    ,output SIF_VC_RXMAP_t                      cfg_sif_vc_rxmap
    ,output SIF_VC_TXMAP_t                      cfg_sif_vc_txmap

    //-------------------------------------------------------------------------------------------------
    // Status

    ,input  new_IBCPL_HDR_FIFO_STATUS_t         ibcpl_hdr_fifo_status
    ,input  new_IBCPL_DATA_FIFO_STATUS_t        ibcpl_data_fifo_status
    ,input  new_P_RL_CQ_FIFO_STATUS_t           p_rl_cq_fifo_status

    ,input  new_SIF_DB_STATUS_t                 sif_db_status

    ,input  new_DEVTLB_STATUS_t                 devtlb_status
    ,input  new_SCRBD_STATUS_t                  scrbd_status
    ,input  new_MSTR_CRD_STATUS_t               mstr_crd_status
    ,input  new_MSTR_FL_STATUS_t                mstr_fl_status
    ,input  new_MSTR_LL_STATUS_t                mstr_ll_status

    ,input  new_LOCAL_BME_STATUS_t              local_bme_status
    ,input  new_LOCAL_MSIXE_STATUS_t            local_msixe_status

    ,input  new_CFGM_STATUS_t                   cfgm_status
    ,input  new_CFGM_STATUS2_t                  cfgm_status2

    ,input  new_SIF_MSTR_DEBUG_t                sif_mstr_debug

    ,input  logic [1:0] [31:0]                  mstr_cnts

    ,output logic [5:0]                         ri_fifo_afull
    ,output logic                               ri_idle
    ,output logic                               tlq_idle

    ,output logic [5:0]                         ri_db_status_in_stalled
    ,output logic [5:0]                         ri_db_status_in_taken
    ,output logic [5:0]                         ri_db_status_out_stalled

    ,input  new_SIF_IDLE_STATUS_t               sif_idle_status
    ,output SIF_IDLE_STATUS_t                   sif_idle_status_reg

    //-------------------------------------------------------------------------------------------------
    // Error Signals

    ,output logic                               ri_fifo_overflow
    ,output logic                               ri_fifo_underflow

    ,output SIF_ALARM_ERR_t                     sif_alarm_err
    ,output logic                               ri_parity_alarm

    ,input  load_DEVTLB_ATS_ERR_t               set_devtlb_ats_err
    ,input  load_SIF_ALARM_ERR_t                set_sif_alarm_err
    ,input  load_SIF_PARITY_ERR_t               set_sif_parity_err
    ,output load_RI_PARITY_ERR_t                set_ri_parity_err

    ,input  logic                               cfgm_timeout_error

    ,output logic                               timeout_error
    ,output logic [9:0]                         timeout_syndrome

    ,output logic                               cds_smon_event
    ,output logic [31:0]                        cds_smon_comp

    //-------------------------------------------------------------------------------------------------
    // Power Management

    ,input  logic                               force_pm_state_d3hot            // from sb

    ,input  logic                               pm_fsm_d0tod3_ok
    ,input  logic                               pm_fsm_d3tod0_ok

    ,output pm_fsm_t                            pm_state

    //-------------------------------------------------------------------------------------------------
    // Sideband

    ,input  logic                               ri_iosf_sb_idle
    ,input  logic                               sif_mstr_quiesce_req            // Tell Primary Channel to block Mastered logic

    ,input  logic                               quiesce_qualifier

    ,output logic                               hard_rst_np

    ,output hqm_cds_sb_tgt_cmsg_t               cds_sb_cmsg                     // Completion message back to the sb_tgt in the shim
    ,output logic                               cds_sb_wrack                    // from CDS - ack an incoming write request that has been sent
    ,output logic                               cds_sb_rdack                    // from CDS - ack an incoming read request that has been sent

    ,input  hqm_sb_ri_cds_msg_t                 sb_cds_msg                      // Tweaked version of sb_ep_msg for hqm_ri_cds.

    ,output logic                               err_gen_msg                     // Generate error message bakc to host
    ,output logic [7:0]                         err_gen_msg_data                // Message data to TI for error.
    ,output logic [15:0]                        err_gen_msg_func                // HSD 5313841 - Error function should be included in error message

    ,input  logic                               err_sb_msgack                   // tell CDS that an error message has been granted (eventually to ERR fub)

    //-------------------------------------------------------------------------------------------------
    // ATS Invalidate Requests

    ,output logic                               rx_msg_v
    ,output hqm_devtlb_rx_msg_t                 rx_msg

    //-------------------------------------------------------------------------------------------------
    // Visa

    ,output logic [13:0]                        flr_visa

    ,output logic [256:0]                       noa_ri                          // RI NOA debug interface on cpp clock

    //-------------------------------------------------------------------------------------------------
    // DFX

    ,input  logic                               fscan_rstbypen
    ,input  logic                               fscan_byprst_b

    //-------------------------------------------------------------------------------------------------
    // Memory Interface

    ,output hqm_sif_memi_fifo_npdata_t          memi_ri_tlq_fifo_npdata         // for i_fifo_npdata from ri/ri_tlq.sv
    ,input  hqm_sif_memo_fifo_npdata_t          memo_ri_tlq_fifo_npdata         // for i_fifo_npdata from ri/ri_tlq.sv
    ,output hqm_sif_memi_fifo_nphdr_t           memi_ri_tlq_fifo_nphdr          // for i_fifo_nphdr from ri/ri_tlq.sv
    ,input  hqm_sif_memo_fifo_nphdr_t           memo_ri_tlq_fifo_nphdr          // for i_fifo_nphdr from ri/ri_tlq.sv
    ,output hqm_sif_memi_fifo_pdata_t           memi_ri_tlq_fifo_pdata          // for i_fifo_pdata from ri/ri_tlq.sv
    ,input  hqm_sif_memo_fifo_pdata_t           memo_ri_tlq_fifo_pdata          // for i_fifo_pdata from ri/ri_tlq.sv
    ,output hqm_sif_memi_fifo_phdr_t            memi_ri_tlq_fifo_phdr           // for i_fifo_phdr   from ri/ri_tlq.sv
    ,input  hqm_sif_memo_fifo_phdr_t            memo_ri_tlq_fifo_phdr           // for i_fifo_phdr   from ri/ri_tlq.sv
);

//-------------------------------------------------------------------------------
// Local Support Signals
//-------------------------------------------------------------------------------

logic                                       ri_bme_rxl;                     // Bus Master Enable

// CSR Control

logic                                       csr_stall;                      // CSR command serialization
logic                                       ppmcsr_wr_stall;                // stall CSR accesses due to previous ppmcsr write

// NOA Debug Signals

logic [47:0]                                cds_noa;                        // Decode and schedule NOA debug signals
logic [111:0]                               csr_noa;                        // CSR NOA debug signals
logic [63:0]                                obc_noa;                        // outbound completion NOA debug signals
logic [31:0]                                tlq_noa;                        // TLQ noa signals

logic                                       tlq_phdrval_wp;                 // A posted header is valid
tdl_phdr_t                                  tlq_phdr_rxp;                   // The next valid posted header
logic                                       tlq_nphdrval_wp;                // A non posted header is valid
tdl_nphdr_t                                 tlq_nphdr_rxp;                  // The next valid non posted header
logic                                       tlq_pdataval_wp;                // Posted data is valid
tlq_pdata_t                                 tlq_pdata_rxp;                  // The next valid posted data
logic                                       tlq_npdataval_wp;               // Non posted data is valid
tlq_npdata_t                                tlq_npdata_rxp;                 // The next valid non posted data
logic                                       tlq_ioqval_wp;                  // IOQ data out valid
tlq_ioqdata_t                               tlq_ioq_data_rxp;               // IOQ data out

// Transaction Decode Logic

logic                                       lli_cpar_err_wp;                // Cmd Hdr parity error detected
logic                                       lli_tecrc_err_wp;               // tecrc error detected
errhdr_t                                    lli_chdr_w_err_wp;

// Command, Decode and Schedule

logic                                       cds_phdr_rd_wp;                 // Read signal for posted header
logic                                       cds_pd_rd_wp;                   // Read signal for posted data
logic                                       cds_nphdr_rd_wp;                // Read signal for non posted header
logic                                       cds_npd_rd_wp;                  // Read signal for non posted header
logic                                       cds_malform_pkt;                // posted malformed packet (MPS error)
logic                                       cds_npusr_err_wp;               // Non posted unsupported request in schedule
logic                                       cds_usr_in_cpl;                 // Unsupported request that generates a completion
logic                                       cds_pusr_err_wp;                // Posted unsupported request in schedule
logic                                       cds_cfg_usr_func;               // Unsupported function in config transaction
logic                                       cds_poison_err_wp;              // Config transaction poisoned
logic                                       cds_bar_decode_err_wp;          // No valid BAR was decoded

logic                                       obcpl_fifo_afull;
logic                                       obcpl_fifo_push;                // A valid outbound completion header is ready.
RiObCplHdr_t                                obcpl_fifo_push_hdr;            // Next outbound header to be queued.
csr_data_t                                  obcpl_fifo_push_data;           // Internally generaged outbound completion data.
logic                                       obcpl_fifo_push_dpar;           // Internally generaged outbound completion data parity.
upd_enables_t                               obcpl_fifo_push_enables;

// Issued to the private RI/TI interface.

logic                                       cds_err_msg_gnt;                // Error message scheduled
cbd_hdr_t                                   cds_err_hdr;                    // Header of transaction that generated

// CSRs

logic                                       csr_req_wr;                     // CSR write
logic                                       csr_req_rd;                     // CSR read
hqm_system_csr_req_t                        csr_req;                        // CSR write address offset
logic                                       csr_rd_data_val_wp;             // CSR read data valid
csr_data_t                                  csr_rd_data_wxp;                // CSR read data
logic                                       csr_rd_ur;                      // CSR read UR error
logic [1:0]                                 csr_rd_error;                   // CSR read target error (1:pslverr, 0:read data parity error)
logic                                       csr_rd_sai_error;               // CSR read SAI error
logic                                       csr_rd_timeout_error;           // CSR read timeout error
logic                                       mmio_wr_sai_error;              // MMIO write (NP) SAI error
logic                                       mmio_wr_sai_ok;                 // MMIO write (NP) SAI ok
logic                                       cfg_wr_ur;                      // CSR write UR error
logic                                       csr_wr_error;                   // CSR write target error
logic                                       cfg_wr_sai_error;               // CFG write (NP) SAI error
logic                                       cfg_wr_sai_ok;                  // CFG write (NP) SAI ok
hdr_addr_t                                  func_pf_bar;                    // ARAM BAR
hdr_addr_t                                  csr_pf_bar;                     // PF0 MISC BAR
logic                                       mmio_timeout_error;
logic [7:0]                                 mmio_timeout_syndrome;
logic                                       hcw_timeout_error;
logic [7:0]                                 hcw_timeout_syndrome;

// Power Management Control Signals

logic [1:0]                                 csr_pf0_ppmcsr_ps_c;            // PF0 power management state

// Function Level Reset

logic                                       csr_pdc_start_flr;              // Function level reset

// Error Control

ppaerucm_t                                  csr_ppaerucm_wp;                // Uncorrectable error mask registexr
ppaercm_t                                   csr_ppaercm_wp;                 // Correctable error mask registers
ppaerctlcap_t                               csr_ppaerctlcap_wp;             // AER Capability Registers
pcicmd_t                                    csr_pcicmd_wp;                  // Device command register
ppdcntl_t                                   csr_ppdcntl_wp;                 // Device command register
csr_data_t                                  csr_pcists_clr;                 // PCISTS clear vector.
csr_data_t                                  csr_ppaerucs_clr;               // PPAERUCS clear vector.
ppaerucm_t                                  csr_ppaerucs_c;                 // Uncorrectable error contorl
pcists_t                                    csr_pcists;                     // PCISTS CSRs error vector
csr_data_t                                  csr_ppaercs_clr;                // PPAERCS clear vector.
ppaerucm_t                                  csr_ppaerucsev;                 // AER Severity
ppaerucm_t                                  csr_ppaerucs;                   // Uncorrectable error status
ppaercm_t                                   csr_ppaercs;                    // Correctable error status
logic                                       err_urd_vec;                    // Unsupported request vector
logic                                       err_fed_vec;                    // Fatal error detect
logic                                       err_ned_vec;                    // Non-fatal error detect
logic                                       err_ced_vec;                    // Correctable error detect
csr_data_t                                  err_hdr_log0;                   // PPAER header log 0
csr_data_t                                  err_hdr_log1;                   // PPAER header log 1
csr_data_t                                  err_hdr_log2;                   // PPAER header log 2
csr_data_t                                  err_hdr_log3;                   // PPAER header log 3
hqm_pasidtlp_t                              err_tlp_prefix_log0;            // PPAER TLP prefix log 0
logic                                       csr_pcicmd_mem;                 // Memory enable in PCICMD CSR
logic                                       csr_pcicmd_io;                  // IO enable in PCICMD CSR

logic                                       pm_rst;
logic                                       pm_pf_rst_wxp;

OBCPL_AFULL_AGITATE_CONTROL_t               obcpl_afull_agitate_control;

// SB to EP Incoming - CSR Access Interface - handled by hqm_ri_cds
// to hqm_ri_iosf_sb block for sideband unsupported requests

// SER related signals, used to gate tlq signals if there are parity errors

logic                                       tlq_cds_phdr_par_err;
logic                                       tlq_cds_pdata_par_err;
logic                                       tlq_cds_nphdr_par_err;
logic                                       tlq_cds_npdata_par_err;

logic                                       set_cbd_hdr_parity_err;
logic                                       set_cbd_data_parity_err;
logic                                       set_hcw_data_parity_err;

// signals for DCN 90006 - FLR to be tied to secondary bus reset

logic                                       ri_pf_disabled_wxp;             // Physical functions in the D3 state.

// hqm_pf_cfg request signals

logic                                       hqm_csr_pf0_pwr_rst_n;
hqm_rtlgen_pkg_v12::cfg_req_32bit_t         hqm_csr_pf0_req;
hqm_rtlgen_pkg_v12::cfg_ack_32bit_t         hqm_csr_pf0_ack;

// internal memory mapped IO (hqm_core & hqm_system)

logic                                       hqm_csr_mmio_rst_n;
hqm_rtlgen_pkg_v12::cfg_req_32bit_t         hqm_csr_int_mmio_req;
hqm_rtlgen_pkg_v12::cfg_ack_32bit_t         hqm_csr_int_mmio_ack;

hqm_sif_csr_pkg::MMIO_TIMEOUT_t             cfg_mmio_timeout;               // MMIO timeout configuration
hqm_sif_csr_pkg::HCW_TIMEOUT_t              cfg_hcw_timeout;                // HCW timeout configuration

RI_PHDR_FIFO_CTL_t                          cfg_ri_phdr_fifo_ctl;
RI_PDATA_FIFO_CTL_t                         cfg_ri_pdata_fifo_ctl;
RI_NPHDR_FIFO_CTL_t                         cfg_ri_nphdr_fifo_ctl;
RI_NPDATA_FIFO_CTL_t                        cfg_ri_npdata_fifo_ctl;
RI_IOQ_FIFO_CTL_t                           cfg_ri_ioq_fifo_ctl;

new_RI_PHDR_FIFO_STATUS_t                   ri_phdr_fifo_status;
new_RI_PDATA_FIFO_STATUS_t                  ri_pdata_fifo_status;
new_RI_NPHDR_FIFO_STATUS_t                  ri_nphdr_fifo_status;
new_RI_NPDATA_FIFO_STATUS_t                 ri_npdata_fifo_status;
new_RI_IOQ_FIFO_STATUS_t                    ri_ioq_fifo_status;

new_OBCPL_FIFO_STATUS_t                     obcpl_fifo_status;

logic                                       cds_idle;
logic                                       obc_idle;

logic                                       flr_function0;
logic                                       flr_pending;
logic [6:1]                                 flr_triggered_wl_int;
logic                                       flr_triggered_wl0_nc;
logic                                       pm_idle;
logic                                       soft_rst_np;

logic                                       pm_deassert_intx;

logic [11:0] [31:0]                         hqm_sif_cnt;


logic                                       ps_d0_to_d3;

pm_fsm_t                                    pm_state_int;

logic [2:0]                                 ri_mps_rxp;     // Maximum Payload size. The
                                                            //  Transmit Interface will ensure that all Data
                                                            //  Payloads will satisfy this maximum payload
                                                            //  limit.
                                                            //   000b: 128 Bytes
                                                            //   001b: 256 Bytes
                                                            //   010b: 512 Bytes (not supported)
                                                            //   011b: 1024 Bytes (not supported)
                                                            //   100b: 2048 Bytes (not supported)
                                                            //   101b: 4096 Bytes (not supported)
                                                            //   110: Reserved
                                                            //   111: Reserved
                                                            //   Note: Upstream Devices on the PCIe fabric will
                                                            //  ensure that all Downstream Packets will satisfy
                                                            //  this maximum payload limit.

load_IBCPL_ERR_t                            set_ibcpl_err;
logic                                       set_ibcpl_err_hdr;
IBCPL_ERR_t                                 ibcpl_err;
logic [95:0]                                ibcpl_err_hdr;

logic [6:0]                                 ri_phdr_db_status;
logic [6:0]                                 ri_pdata_db_status;
logic [6:0]                                 ri_nphdr_db_status;
logic [6:0]                                 ri_npdata_db_status;
logic [6:0]                                 ri_ioq_db_status;
logic [6:0]                                 ri_hcw_db_status;

new_RI_DB_STATUS_t                          ri_db_status;

//------------------------------------------------------------------------------

assign flr_triggered_wl[6:2] = flr_triggered_wl_int[6:2];

//------------------------------------------------------------------------------
// The Transacation layer queue
//------------------------------------------------------------------------------

hqm_ri_tlq i_ri_tlq (

     .prim_nonflr_clk                   (prim_nonflr_clk)
    ,.prim_gated_rst_b                  (prim_gated_rst_b)

    ,.lli_phdr_val                      (lli_phdr_val)
    ,.lli_phdr                          (lli_phdr)
    ,.lli_nphdr_val                     (lli_nphdr_val)
    ,.lli_nphdr                         (lli_nphdr)

    ,.lli_cpar_err_rl                   (iosf_ep_cpar_err)                  // data parity error from shim
    ,.lli_tecrc_err_rl                  (iosf_ep_tecrc_err)                 // tecrc error from shim
    ,.lli_chdr_w_err_rl                 (iosf_ep_chdr_w_err)
    ,.lli_cpar_err_wp                   (lli_cpar_err_wp)                   // same as above but synced to prim_gated_clk domain
    ,.lli_tecrc_err_wp                  (lli_tecrc_err_wp)                  // same as above but synced to prim_gated_clk domain
    ,.lli_chdr_w_err_wp                 (lli_chdr_w_err_wp)

    ,.poisoned_wr_sent                  (poisoned_wr_sent)                  // HSD 5314547 - MDPE not getting set when HQM receives poison completion

    // SER related signals

    ,.tlq_cds_phdr_par_err              (tlq_cds_phdr_par_err)
    ,.tlq_cds_pdata_par_err             (tlq_cds_pdata_par_err)
    ,.tlq_cds_nphdr_par_err             (tlq_cds_nphdr_par_err)
    ,.tlq_cds_npdata_par_err            (tlq_cds_npdata_par_err)

    ,.cds_phdr_rd_wp                    (cds_phdr_rd_wp)
    ,.cds_pd_rd_wp                      (cds_pd_rd_wp)
    ,.cds_nphdr_rd_wp                   (cds_nphdr_rd_wp)
    ,.cds_npd_rd_wp                     (cds_npd_rd_wp)

    ,.ri_tgt_crd_inc                    (ri_tgt_crd_inc)

    ,.lli_pdata_push                    (lli_pdata_push)
    ,.lli_npdata_push                   (lli_npdata_push)
    ,.lli_pkt_data                      (lli_pkt_data)
    ,.lli_pkt_data_par                  (lli_pkt_data_par)

    ,.memi_ri_tlq_fifo_phdr             (memi_ri_tlq_fifo_phdr)
    ,.memo_ri_tlq_fifo_phdr             (memo_ri_tlq_fifo_phdr)
    ,.memi_ri_tlq_fifo_pdata            (memi_ri_tlq_fifo_pdata)
    ,.memo_ri_tlq_fifo_pdata            (memo_ri_tlq_fifo_pdata)
    ,.memi_ri_tlq_fifo_nphdr            (memi_ri_tlq_fifo_nphdr)
    ,.memo_ri_tlq_fifo_nphdr            (memo_ri_tlq_fifo_nphdr)
    ,.memi_ri_tlq_fifo_npdata           (memi_ri_tlq_fifo_npdata)
    ,.memo_ri_tlq_fifo_npdata           (memo_ri_tlq_fifo_npdata)

    ,.tlq_phdrval_wp                    (tlq_phdrval_wp)
    ,.tlq_phdr_rxp                      (tlq_phdr_rxp)
    ,.tlq_nphdrval_wp                   (tlq_nphdrval_wp)
    ,.tlq_nphdr_rxp                     (tlq_nphdr_rxp)
    ,.tlq_pdataval_wp                   (tlq_pdataval_wp)
    ,.tlq_pdata_rxp                     (tlq_pdata_rxp)
    ,.tlq_npdataval_wp                  (tlq_npdataval_wp)
    ,.tlq_npdata_rxp                    (tlq_npdata_rxp)
    ,.tlq_ioqval_wp                     (tlq_ioqval_wp)
    ,.tlq_ioq_data_rxp                  (tlq_ioq_data_rxp)

    ,.cfg_ri_phdr_fifo_high_wm          (cfg_ri_phdr_fifo_ctl.HIGH_WM)
    ,.cfg_ri_pdata_fifo_high_wm         (cfg_ri_pdata_fifo_ctl.HIGH_WM)
    ,.cfg_ri_nphdr_fifo_high_wm         (cfg_ri_nphdr_fifo_ctl.HIGH_WM)
    ,.cfg_ri_npdata_fifo_high_wm        (cfg_ri_npdata_fifo_ctl.HIGH_WM)
    ,.cfg_ri_ioq_fifo_high_wm           (cfg_ri_ioq_fifo_ctl.HIGH_WM)
    ,.cfg_ri_par_off                    (parity_ctl.RI_PAR_OFF)
    ,.cfg_cnt_clear                     (hqm_sif_cnt_ctl.CNT_CLR)
    ,.cfg_cnt_clearv                    (hqm_sif_cnt_ctl.CNT_CLRV)
    ,.cfg_tlq_cnts                      (hqm_sif_cnt[9:0])

    ,.ri_phdr_fifo_status               (ri_phdr_fifo_status)
    ,.ri_pdata_fifo_status              (ri_pdata_fifo_status)
    ,.ri_nphdr_fifo_status              (ri_nphdr_fifo_status)
    ,.ri_npdata_fifo_status             (ri_npdata_fifo_status)
    ,.ri_ioq_fifo_status                (ri_ioq_fifo_status)

    ,.ri_phdr_db_status                 (ri_phdr_db_status)
    ,.ri_pdata_db_status                (ri_pdata_db_status)
    ,.ri_nphdr_db_status                (ri_nphdr_db_status)
    ,.ri_npdata_db_status               (ri_npdata_db_status)
    ,.ri_ioq_db_status                  (ri_ioq_db_status)

    ,.set_cbd_hdr_parity_err            (set_cbd_hdr_parity_err)
    ,.set_cbd_data_parity_err           (set_cbd_data_parity_err)
    ,.set_hcw_data_parity_err           (set_hcw_data_parity_err)

    ,.set_ri_parity_err                 (set_ri_parity_err)
    ,.ri_parity_alarm                   (ri_parity_alarm)

    ,.tlq_idle                          (tlq_idle)

    ,.cpl_usr                           (cpl_usr)
    ,.cpl_abort                         (cpl_abort)
    ,.cpl_poisoned                      (cpl_poisoned)
    ,.cpl_unexpected                    (cpl_unexpected)
    ,.cpl_timeout                       (cpl_timeout)

    ,.tlq_noa                           (tlq_noa)
);

hqm_AW_unused_bits i_unused_high_wm (

     .a     (|{cfg_ri_phdr_fifo_ctl.reserved0
              ,cfg_ri_pdata_fifo_ctl.reserved0
              ,cfg_ri_nphdr_fifo_ctl.reserved0
              ,cfg_ri_npdata_fifo_ctl.reserved0
              ,cfg_ri_ioq_fifo_ctl.reserved0
            })
);

//------------------------------------------------------------------------------
// The CSR FUB.
// Within this FUB reside almost all the CSR's for the EP.
//------------------------------------------------------------------------------

hqm_ri_csr_ctl i_ri_csr_ctl(

     .prim_freerun_clk                  (prim_freerun_clk)
    ,.prim_gated_clk                    (prim_gated_clk)
    ,.prim_nonflr_clk                   (prim_nonflr_clk)

    ,.powergood_rst_b                   (powergood_rst_b)
    ,.prim_gated_rst_b                  (prim_gated_rst_b)

    ,.pm_rst                            (pm_rst)
    ,.pm_pf_rst_wxp                     (pm_pf_rst_wxp)

    ,.hard_rst_np                       (hard_rst_np)
    ,.soft_rst_np                       (soft_rst_np)
    ,.flr_treatment_vec                 (flr_treatment_vec)

    // HSD 4728428 - DFX scan control inputs to drive reset

    ,.fscan_rstbypen                    (fscan_rstbypen)
    ,.fscan_byprst_b                    (fscan_byprst_b)

    // MMIO timeout configuration and signal

    ,.cfg_mmio_timeout                  (cfg_mmio_timeout)
    ,.mmio_timeout_error                (mmio_timeout_error)
    ,.mmio_timeout_syndrome             (mmio_timeout_syndrome)

    // Interface with hqm_ri_cds

    ,.csr_req_wr                        (csr_req_wr)
    ,.csr_req_rd                        (csr_req_rd)
    ,.csr_req                           (csr_req)

    ,.csr_rd_data_val_wp                (csr_rd_data_val_wp)
    ,.csr_rd_data_wxp                   (csr_rd_data_wxp[`HQM_CSR_SIZE-1:0])
    ,.csr_stall                         (csr_stall)
    ,.csr_rd_ur                         (csr_rd_ur)
    ,.csr_rd_error                      (csr_rd_error)
    ,.csr_rd_sai_error                  (csr_rd_sai_error)
    ,.csr_rd_timeout_error              (csr_rd_timeout_error)
    ,.mmio_wr_sai_error                 (mmio_wr_sai_error)
    ,.mmio_wr_sai_ok                    (mmio_wr_sai_ok)
    ,.cfg_wr_ur                         (cfg_wr_ur)
    ,.csr_wr_error                      (csr_wr_error)
    ,.cfg_wr_sai_error                  (cfg_wr_sai_error)
    ,.cfg_wr_sai_ok                     (cfg_wr_sai_ok)
    ,.ppmcsr_wr_stall                   (ppmcsr_wr_stall)

    // hqm_pf_cfg request signals

    ,.hqm_csr_pf0_rst_n                 (hqm_csr_pf0_rst_n)
    ,.hqm_csr_pf0_pwr_rst_n             (hqm_csr_pf0_pwr_rst_n)
    ,.hqm_csr_pf0_req                   (hqm_csr_pf0_req)
    ,.hqm_csr_pf0_ack                   (hqm_csr_pf0_ack)

    ,.hqm_sif_csr_hc_addr               (hqm_sif_csr_hc_addr)

    ,.hqm_csr_mmio_rst_n                (hqm_csr_mmio_rst_n)
    ,.hqm_csr_int_mmio_req              (hqm_csr_int_mmio_req)
    ,.hqm_csr_int_mmio_ack              (hqm_csr_int_mmio_ack)

    ,.hqm_csr_ext_mmio_req              (hqm_csr_ext_mmio_req)
    ,.hqm_csr_ext_mmio_req_apar         (hqm_csr_ext_mmio_req_apar)
    ,.hqm_csr_ext_mmio_req_dpar         (hqm_csr_ext_mmio_req_dpar)
    ,.hqm_csr_ext_mmio_ack              (hqm_csr_ext_mmio_ack)
    ,.hqm_csr_ext_mmio_ack_err          (hqm_csr_ext_mmio_ack_err)
    ,.cfgm_timeout_error                (cfgm_timeout_error)

    ,.csr_noa                           (csr_noa)
);

//------------------------------------------------------------------------------
// The CSR FUB.
// Within this FUB reside almost all the CSR's for the EP.
//------------------------------------------------------------------------------

hqm_ri_pf_vf_cfg i_ri_pf_vf_cfg(

     .prim_nonflr_clk                   (prim_nonflr_clk)
    ,.prim_gated_rst_b                  (prim_gated_rst_b)

    ,.quiesce_qualifier                 (quiesce_qualifier)

    ,.strap_hqm_is_reg_ep               (strap_hqm_is_reg_ep)
    ,.strap_hqm_completertenbittagen    (strap_hqm_completertenbittagen)

    // hqm_pf_cfg request signals

    ,.hqm_csr_pf0_rst_n                 (hqm_csr_pf0_rst_n)
    ,.hqm_csr_pf0_pwr_rst_n             (hqm_csr_pf0_pwr_rst_n)
    ,.hqm_csr_pf0_req                   (hqm_csr_pf0_req)
    ,.hqm_csr_pf0_ack                   (hqm_csr_pf0_ack)

    ,.ppmcsr_wr_stall                   (ppmcsr_wr_stall)

    ,.flr_function0                     (flr_function0)

    ,.flr_treatment_vec                 (flr_treatment_vec)

    ,.ps_d0_to_d3                       (ps_d0_to_d3)
    ,.pm_state                          (pm_state_int)

    ,.pm_deassert_intx                  (pm_deassert_intx)

    ,.np_trans_pending                  (np_trans_pending)

    ,.csr_pcists                        (csr_pcists)
    ,.csr_ppaerucs                      (csr_ppaerucs)
    ,.csr_ppaercs                       (csr_ppaercs)
    ,.err_urd_vec                       (err_urd_vec)
    ,.err_fed_vec                       (err_fed_vec)
    ,.err_ned_vec                       (err_ned_vec)
    ,.err_ced_vec                       (err_ced_vec)

    ,.csr_pf0_ppaerhdrlog0_hdrlogdw0_s  (err_hdr_log0)
    ,.csr_pf0_ppaerhdrlog1_hdrlogdw1_s  (err_hdr_log1)
    ,.csr_pf0_ppaerhdrlog2_hdrlogdw2_s  (err_hdr_log2)
    ,.csr_pf0_ppaerhdrlog3_hdrlogdw3_s  (err_hdr_log3)
    ,.csr_pf0_ppaertlppflog0            (err_tlp_prefix_log0)

    ,.func_pf_bar                       (func_pf_bar)
    ,.csr_pf_bar                        (csr_pf_bar)

    ,.ri_bme_rxl                        (ri_bme_rxl)
    ,.csr_pmsixctl_msie_wxp             (csr_pmsixctl_msie_wxp)
    ,.csr_pmsixctl_fm_wxp               (csr_pmsixctl_fm_wxp)

    ,.csr_pf0_ppmcsr_ps_c               (csr_pf0_ppmcsr_ps_c[1:0])

    ,.csr_pdc_start_flr                 (csr_pdc_start_flr)

    ,.csr_pcicmd_mem                    (csr_pcicmd_mem)
    ,.csr_pcicmd_io                     (csr_pcicmd_io)

    ,.ri_mps_rxp                        (ri_mps_rxp)

    ,.csr_pcists_clr                    (csr_pcists_clr)
    ,.csr_ppaerucs_clr                  (csr_ppaerucs_clr)
    ,.csr_ppaerucs_c                    (csr_ppaerucs_c)
    ,.csr_ppaercs_clr                   (csr_ppaercs_clr)
    ,.csr_ppaerucm_wp                   (csr_ppaerucm_wp)
    ,.csr_ppaercm_wp                    (csr_ppaercm_wp)
    ,.csr_ppaerctlcap_wp                (csr_ppaerctlcap_wp)
    ,.csr_pcicmd_wp                     (csr_pcicmd_wp)
    ,.csr_ppdcntl_wp                    (csr_ppdcntl_wp)
    ,.csr_ppaerucsev                    (csr_ppaerucsev)
    ,.csr_ppdcntl_ero                   (csr_ppdcntl_ero)
    ,.csr_pasid_enable                  (csr_pasid_enable)

    ,.strap_hqm_device_id               (strap_hqm_device_id)
    ,.revision_id_fuses                 (sb_ep_fuses.revision_id)

    ,.ats_enabled                       (ats_enabled)
);

//------------------------------------------------------------------------------
// The CSR FUB.
// Within this FUB reside almost all the CSR's for the EP.
//------------------------------------------------------------------------------

hqm_sif_csr_wrap i_sif_csr_wrap (

     .prim_nonflr_clk                   (prim_nonflr_clk)
    ,.prim_gated_rst_b                  (prim_gated_rst_b)
    ,.side_gated_rst_prim_b             (side_gated_rst_prim_b)
    ,.hqm_csr_mmio_rst_n                (hqm_csr_mmio_rst_n)
    ,.hard_rst_np                       (hard_rst_np)

    ,.hqm_sif_csr_hc_rvalid             (hqm_sif_csr_hc_rvalid)
    ,.hqm_sif_csr_hc_wvalid             (hqm_sif_csr_hc_wvalid)
    ,.hqm_sif_csr_hc_error              (hqm_sif_csr_hc_error)
    ,.hqm_sif_csr_hc_reg_read           (hqm_sif_csr_hc_reg_read)
    ,.hqm_sif_csr_hc_we                 (hqm_sif_csr_hc_we)
    ,.hqm_sif_csr_hc_re                 (hqm_sif_csr_hc_re)
    ,.hqm_sif_csr_hc_reg_write          (hqm_sif_csr_hc_reg_write)

    ,.hqm_sif_csr_sai_export            (hqm_sif_csr_sai_export)

    ,.hqm_csr_int_mmio_req              (hqm_csr_int_mmio_req)
    ,.hqm_csr_int_mmio_ack              (hqm_csr_int_mmio_ack)

    ,.strap_hqm_csr_cp                  (strap_hqm_csr_cp)
    ,.strap_hqm_csr_rac                 (strap_hqm_csr_rac)
    ,.strap_hqm_csr_wac                 (strap_hqm_csr_wac)

    ,.set_sif_alarm_err                 (set_sif_alarm_err)
    ,.sif_alarm_err                     (sif_alarm_err)

    // Signals to and from IOSF sideband - inputs

    ,.sb_ep_fuses                       (sb_ep_fuses)

    ,.hqm_csr_rac                       (hqm_csr_rac)
    ,.hqm_csr_wac                       (hqm_csr_wac)

    ,.ri_phdr_fifo_status               (ri_phdr_fifo_status)
    ,.ri_pdata_fifo_status              (ri_pdata_fifo_status)
    ,.ri_nphdr_fifo_status              (ri_nphdr_fifo_status)
    ,.ri_npdata_fifo_status             (ri_npdata_fifo_status)
    ,.ri_ioq_fifo_status                (ri_ioq_fifo_status)
    ,.ibcpl_hdr_fifo_status             (ibcpl_hdr_fifo_status)
    ,.ibcpl_data_fifo_status            (ibcpl_data_fifo_status)
    ,.obcpl_fifo_status                 (obcpl_fifo_status)
    ,.p_rl_cq_fifo_status               (p_rl_cq_fifo_status)

    ,.sif_db_status                     (sif_db_status)
    ,.ri_db_status                      (ri_db_status)
    ,.devtlb_status                     (devtlb_status)
    ,.scrbd_status                      (scrbd_status)
    ,.mstr_crd_status                   (mstr_crd_status)
    ,.mstr_fl_status                    (mstr_fl_status)
    ,.mstr_ll_status                    (mstr_ll_status)

    ,.local_bme_status                  (local_bme_status)
    ,.local_msixe_status                (local_msixe_status)

    ,.cfgm_status                       (cfgm_status)
    ,.cfgm_status2                      (cfgm_status2)

    ,.prim_cdc_ctl                      (prim_cdc_ctl)
    ,.side_cdc_ctl                      (side_cdc_ctl)
    ,.iosfp_cgctl                       (iosfp_cgctl)
    ,.iosfs_cgctl                       (iosfs_cgctl)

    ,.dir_cq2tc_map                     (dir_cq2tc_map)
    ,.ldb_cq2tc_map                     (ldb_cq2tc_map)
    ,.int2tc_map                        (int2tc_map)

    ,.cfg_master_timeout                (cfg_master_timeout)
    ,.parity_ctl                        (parity_ctl)
    ,.cfg_mmio_timeout                  (cfg_mmio_timeout)
    ,.cfg_hcw_timeout                   (cfg_hcw_timeout)
    ,.cfg_visa_sw_control_write         (cfg_visa_sw_control_write)
    ,.cfg_visa_sw_control_wdata         (cfg_visa_sw_control_wdata)
    ,.cfg_visa_sw_control               (cfg_visa_sw_control)
    ,.cfg_visa_sw_control_write_done    (cfg_visa_sw_control_write_done)
    ,.cfg_ph_trigger_addr               (cfg_ph_trigger_addr)
    ,.cfg_ph_trigger_mask               (cfg_ph_trigger_mask)

    ,.ri_phdr_fifo_ctl                  (cfg_ri_phdr_fifo_ctl)
    ,.ri_pdata_fifo_ctl                 (cfg_ri_pdata_fifo_ctl)
    ,.ri_nphdr_fifo_ctl                 (cfg_ri_nphdr_fifo_ctl)
    ,.ri_npdata_fifo_ctl                (cfg_ri_npdata_fifo_ctl)
    ,.ri_ioq_fifo_ctl                   (cfg_ri_ioq_fifo_ctl)
    ,.ibcpl_hdr_fifo_ctl                (ibcpl_hdr_fifo_ctl)
    ,.ibcpl_data_fifo_ctl               (ibcpl_data_fifo_ctl)

    ,.obcpl_afull_agitate_control       (obcpl_afull_agitate_control)

    ,.tgt_init_hcredits                 (tgt_init_hcredits)
    ,.tgt_init_dcredits                 (tgt_init_dcredits)
    ,.tgt_rem_hcredits                  (tgt_rem_hcredits)
    ,.tgt_rem_dcredits                  (tgt_rem_dcredits)
    ,.tgt_ret_hcredits                  (tgt_ret_hcredits)
    ,.tgt_ret_dcredits                  (tgt_ret_dcredits)

    ,.sif_mstr_debug                    (sif_mstr_debug)

    ,.set_ri_parity_err                 (set_ri_parity_err)
    ,.set_sif_parity_err                (set_sif_parity_err)
    ,.set_devtlb_ats_err                (set_devtlb_ats_err)

    ,.hqm_sif_cnt_ctl                   (hqm_sif_cnt_ctl)
    ,.hqm_sif_cnt                       (hqm_sif_cnt)

    ,.sif_idle_status                   (sif_idle_status)
    ,.sif_idle_status_reg               (sif_idle_status_reg)

    ,.scrbd_ctl                         (scrbd_ctl)
    ,.mstr_ll_ctl                       (mstr_ll_ctl)
    ,.devtlb_ctl                        (devtlb_ctl)
    ,.devtlb_spare                      (devtlb_spare)
    ,.devtlb_defeature0                 (devtlb_defeature0)
    ,.devtlb_defeature1                 (devtlb_defeature1)
    ,.devtlb_defeature2                 (devtlb_defeature2)

    ,.set_ibcpl_err                     (set_ibcpl_err)
    ,.set_ibcpl_err_hdr                 (set_ibcpl_err_hdr)
    ,.ibcpl_err                         (ibcpl_err)
    ,.ibcpl_err_hdr                     (ibcpl_err_hdr)

    ,.cfg_sif_ctl                       (cfg_sif_ctl)
    ,.cfg_sif_vc_rxmap                  (cfg_sif_vc_rxmap)
    ,.cfg_sif_vc_txmap                  (cfg_sif_vc_txmap)
);

assign hqm_sif_cnt[11:10] = mstr_cnts;

assign set_ibcpl_err.IBCPL_UR    = cpl_usr;
assign set_ibcpl_err.IBCPL_ABORT = cpl_abort;

assign set_ibcpl_err_hdr = |{(set_ibcpl_err.IBCPL_UR    & ~ibcpl_err.IBCPL_UR   )
                            ,(set_ibcpl_err.IBCPL_ABORT & ~ibcpl_err.IBCPL_ABORT)
};

assign ibcpl_err_hdr = {

          cpl_error_hdr.rid[15:8],                                      // Header byte 8
          cpl_error_hdr.rid[7:0],                                       // Header byte 9
          cpl_error_hdr.tag[7:0],                                       // Header byte 10
          6'h0, cpl_error_hdr.addr[1:0],                                // Header byte 11
          cpl_error_hdr.cid[15:8],                                      // Header byte 4
          cpl_error_hdr.cid[7:0],                                       // Header byte 5
          cpl_error_hdr.status[2:0], 1'b0, cpl_error_hdr.bc[11:8],      // Header byte 6
          cpl_error_hdr.bc[7:0],                                        // Header byte 7
          1'b0, cpl_error_hdr.wdata, 1'b0, 5'b01010,                    // Header Byte 0, bits 7->0
          cpl_error_hdr.tag[9], cpl_error_hdr.tc,                       // Header byte 1
          cpl_error_hdr.tag[8], cpl_error_hdr.ido, 2'd0,
          1'b0, cpl_error_hdr.poison,2'h0,                              // Header byte 2
          cpl_error_hdr.ro, cpl_error_hdr.ns, cpl_error_hdr.length[9:8],
          cpl_error_hdr.length[7:0]                                     // Header byte 3
};

//------------------------------------------------------------------------------
// CBD Control BAR Decode. Logic for decoding the incoming address
// and signaling which BAR it hits.
//------------------------------------------------------------------------------

hqm_ri_cds i_ri_cds (

     .prim_nonflr_clk                   (prim_nonflr_clk)
    ,.prim_gated_rst_b                  (prim_gated_rst_b)

    ,.func_in_rst                       (func_in_rst)

    ,.err_sb_msgack                     (err_sb_msgack)         // to tell CDS that an error message has been granted
                                                                //  (eventually to ERR fub)

    ,.sif_mstr_quiesce_req              (sif_mstr_quiesce_req)

    // from ri_cds to ri_iosf_sb block for sideband unsupported requests

    ,.cds_sb_wrack                      (cds_sb_wrack)          // from CDS - ack an incoming wr request that has been sent
    ,.cds_sb_rdack                      (cds_sb_rdack)          // from CDS - ack an incoming rd request that has been sent
    ,.cds_sb_cmsg                       (cds_sb_cmsg)           // from CDS - completion message

    // SB Message info sent to CDS

    ,.sb_cds_msg                        (sb_cds_msg)

    // SER related signals, used to gate tlq signals if there are parity errors

    ,.tlq_cds_phdr_par_err              (tlq_cds_phdr_par_err)
    ,.tlq_cds_pdata_par_err             (tlq_cds_pdata_par_err)
    ,.tlq_cds_nphdr_par_err             (tlq_cds_nphdr_par_err)
    ,.tlq_cds_npdata_par_err            (tlq_cds_npdata_par_err)

    ,.set_cbd_hdr_parity_err            (set_cbd_hdr_parity_err)
    ,.set_cbd_data_parity_err           (set_cbd_data_parity_err)
    ,.set_hcw_data_parity_err           (set_hcw_data_parity_err)

    // signals for DCN 90006 - FLR to be tied to secondary bus reset

    ,.flr_txn_sent                      (flr_txn_sent)
    ,.flr_txn_tag                       (flr_txn_tag)
    ,.flr_txn_reqid                     (flr_txn_reqid)
    ,.flr_function0                     (flr_function0)
    ,.flr_pending                       (flr_pending)
    ,.flr_treatment                     (flr_treatment)
    ,.flr_triggered_wl                  (flr_triggered_wl_int[1])

    ,.ps_d0_to_d3                       (ps_d0_to_d3)
    ,.ps_txn_sent                       (ps_txn_sent)
    ,.ps_txn_tag                        (ps_txn_tag)
    ,.ps_txn_reqid                      (ps_txn_reqid)

    ,.tlq_phdrval_wp_2arb               (tlq_phdrval_wp)
    ,.tlq_phdr_rxp                      (tlq_phdr_rxp)
    ,.tlq_nphdrval_wp_2arb              (tlq_nphdrval_wp)
    ,.tlq_nphdr_rxp                     (tlq_nphdr_rxp)
    ,.tlq_pdataval_wp_2arb              (tlq_pdataval_wp)
    ,.tlq_pdata_rxp                     (tlq_pdata_rxp)
    ,.tlq_npdataval_wp_2arb             (tlq_npdataval_wp)
    ,.tlq_npdata_rxp                    (tlq_npdata_rxp)
    ,.tlq_ioqval_wp_2arb                (tlq_ioqval_wp)
    ,.tlq_ioq_data_rxp                  (tlq_ioq_data_rxp)

    ,.func_pf_bar                       (func_pf_bar)
    ,.csr_pf_bar                        (csr_pf_bar)

    ,.csr_rd_data_val_wp                (csr_rd_data_val_wp)
    ,.csr_rd_data_wxp                   (csr_rd_data_wxp)
    ,.csr_stall                         (csr_stall)
    ,.csr_rd_ur                         (csr_rd_ur)
    ,.csr_rd_error                      (csr_rd_error)
    ,.csr_rd_sai_error                  (csr_rd_sai_error)
    ,.csr_rd_timeout_error              (csr_rd_timeout_error)
    ,.csr_pcicmd_mem                    (csr_pcicmd_mem)
    ,.csr_pasid_enable                  (csr_pasid_enable)
    ,.cfg_ri_par_off                    (parity_ctl.RI_PAR_OFF)

    ,.ri_mps_rxp                        (ri_mps_rxp)

    ,.mmio_wr_sai_error                 (mmio_wr_sai_error)
    ,.mmio_wr_sai_ok                    (mmio_wr_sai_ok)

    ,.cfg_wr_ur                         (cfg_wr_ur)
    ,.csr_wr_error                      (csr_wr_error)
    ,.cfg_wr_sai_error                  (cfg_wr_sai_error)
    ,.cfg_wr_sai_ok                     (cfg_wr_sai_ok)

    ,.ri_pf_disabled_wxp                (ri_pf_disabled_wxp)
    ,.current_bus                       (current_bus)

    ,.cds_phdr_rd_wp                    (cds_phdr_rd_wp)
    ,.cds_nphdr_rd_wp                   (cds_nphdr_rd_wp)
    ,.cds_npd_rd_wp                     (cds_npd_rd_wp)
    ,.cds_pd_rd_wp                      (cds_pd_rd_wp)

    ,.obcpl_fifo_afull                  (obcpl_fifo_afull)

    ,.obcpl_fifo_push                   (obcpl_fifo_push)
    ,.obcpl_fifo_push_hdr               (obcpl_fifo_push_hdr)
    ,.obcpl_fifo_push_data              (obcpl_fifo_push_data)
    ,.obcpl_fifo_push_dpar              (obcpl_fifo_push_dpar)
    ,.obcpl_fifo_push_enables           (obcpl_fifo_push_enables)

    ,.gpsb_upd_enables                  (gpsb_upd_enables)

    ,.ri_bme_rxl                        (ri_bme_rxl)
    ,.csr_pmsixctl_msie_wxp             (csr_pmsixctl_msie_wxp)

    ,.csr_req_wr                        (csr_req_wr)
    ,.csr_req_rd                        (csr_req_rd)
    ,.csr_req                           (csr_req)

    ,.hcw_enq_in_ready                  (hcw_enq_in_ready)
    ,.hcw_enq_in_v                      (hcw_enq_in_v)
    ,.hcw_enq_in_data                   (hcw_enq_in_data)

    ,.rx_msg_v                          (rx_msg_v)
    ,.rx_msg                            (rx_msg)

    ,.cds_err_hdr                       (cds_err_hdr)
    ,.cds_err_msg_gnt                   (cds_err_msg_gnt)
    ,.cds_malform_pkt                   (cds_malform_pkt)
    ,.cds_npusr_err_wp                  (cds_npusr_err_wp)
    ,.cds_usr_in_cpl                    (cds_usr_in_cpl)
    ,.cds_pusr_err_wp                   (cds_pusr_err_wp)
    ,.cds_cfg_usr_func                  (cds_cfg_usr_func)
    ,.cds_poison_err_wp                 (cds_poison_err_wp)
    ,.cds_bar_decode_err_wp             (cds_bar_decode_err_wp)

    ,.cfg_hcw_timeout                   (cfg_hcw_timeout)
    ,.hcw_timeout_error                 (hcw_timeout_error)
    ,.hcw_timeout_syndrome              (hcw_timeout_syndrome)

    ,.ri_hcw_db_status                  (ri_hcw_db_status)
    ,.cds_idle                          (cds_idle)
    ,.cds_noa                           (cds_noa)

    ,.cds_smon_event                    (cds_smon_event)
    ,.cds_smon_comp                     (cds_smon_comp)
);

// The outbound completion FUB

hqm_ri_obc i_ri_obc (

     .prim_nonflr_clk                   (prim_nonflr_clk)
    ,.prim_gated_rst_b                  (prim_gated_rst_b)

    ,.obcpl_fifo_push                   (obcpl_fifo_push)
    ,.obcpl_fifo_push_hdr               (obcpl_fifo_push_hdr)
    ,.obcpl_fifo_push_data              (obcpl_fifo_push_data)
    ,.obcpl_fifo_push_dpar              (obcpl_fifo_push_dpar)
    ,.obcpl_fifo_push_enables           (obcpl_fifo_push_enables)
    ,.obcpl_fifo_afull                  (obcpl_fifo_afull)

    ,.obcpl_ready                       (obcpl_ready)

    ,.obcpl_v                           (obcpl_v)
    ,.obcpl_hdr                         (obcpl_hdr)
    ,.obcpl_data                        (obcpl_data)
    ,.obcpl_dpar                        (obcpl_dpar)
    ,.obcpl_enables                     (obcpl_enables)

    ,.obcpl_afull_agitate_control       (obcpl_afull_agitate_control)

    ,.obcpl_fifo_status                 (obcpl_fifo_status)

    ,.obc_idle                          (obc_idle)
    ,.obc_noa                           (obc_noa)
);

//---------------------------------------------------------------------------------
// Power Management
// Fix for ticket 3542151 gbe_pm_supported_ff should not gate the pm state machine
//---------------------------------------------------------------------------------

hqm_ri_pm i_ri_pm (

     .prim_freerun_clk                  (prim_freerun_clk)
    ,.prim_nonflr_clk                   (prim_nonflr_clk)
    ,.prim_gated_rst_b                  (prim_gated_rst_b)
    ,.side_gated_rst_prim_b             (side_gated_rst_prim_b)

    ,.flr_clk_enable                    (flr_clk_enable)
    ,.flr_clk_enable_system             (flr_clk_enable_system)
    ,.flr_triggered_wl                  ({flr_triggered_wl_int[6:1], flr_triggered_wl0_nc})
    ,.flr_txn_sent                      (flr_txn_sent)
    ,.flr_txn_tag                       (flr_txn_tag)
    ,.flr_txn_reqid                     (flr_txn_reqid)
    ,.flr_treatment                     (flr_treatment)
    ,.flr_visa                          (flr_visa[9:0])

    ,.ps_txn_sent                       (ps_txn_sent)
    ,.ps_txn_tag                        (ps_txn_tag)
    ,.ps_txn_reqid                      (ps_txn_reqid)

    ,.gnt                               (gnt)
    ,.gnt_rtype                         (gnt_rtype)
    ,.mrsvd1_7                          (mrsvd1_7)
    ,.mrsvd1_3                          (mrsvd1_3)
    ,.mtag                              (mtag)
    ,.mrqid                             (mrqid)

    ,.csr_pcicmd_mem                    (csr_pcicmd_mem)
    ,.csr_pcicmd_io                     (csr_pcicmd_io)
    ,.csr_pf0_ppmcsr_ps_c               (csr_pf0_ppmcsr_ps_c)
    ,.csr_pdc_start_flr                 (csr_pdc_start_flr)

    ,.pm_fsm_d0tod3_ok                  (pm_fsm_d0tod3_ok)
    ,.pm_fsm_d3tod0_ok                  (pm_fsm_d3tod0_ok)

    ,.ri_bme_rxl                        (ri_bme_rxl)
    ,.ri_pf_disabled_wxp                (ri_pf_disabled_wxp)

    ,.pm_idle                           (pm_idle)
    ,.pm_state                          (pm_state_int)
    ,.pm_rst                            (pm_rst)
    ,.pm_pf_rst_wxp                     (pm_pf_rst_wxp)
    ,.func_in_rst                       (func_in_rst)
    ,.pm_deassert_intx                  (pm_deassert_intx)
);

assign pm_state = (force_pm_state_d3hot) ? PM_FSM_D3HOT : pm_state_int;

//------------------------------------------------------------------------------
// Error Logic
//------------------------------------------------------------------------------

hqm_ri_err i_ri_err(

     .prim_nonflr_clk                   (prim_nonflr_clk)
    ,.prim_gated_rst_b                  (prim_gated_rst_b)

    ,.hard_rst_np                       (hard_rst_np)
    ,.soft_rst_np                       (soft_rst_np)

    ,.quiesce_qualifier                 (quiesce_qualifier)
    ,.flr_treatment_vec                 (flr_treatment_vec)

    ,.cds_err_msg_gnt                   (cds_err_msg_gnt)
    ,.cds_err_hdr                       (cds_err_hdr)
    ,.cds_npusr_err_wp                  (cds_npusr_err_wp)
    ,.cds_pusr_err_wp                   (cds_pusr_err_wp)
    ,.cds_usr_in_cpl                    (cds_usr_in_cpl)
    ,.cds_cfg_usr_func                  (cds_cfg_usr_func)
    ,.cds_bar_decode_err_wp             (cds_bar_decode_err_wp)

    ,.lli_cpar_err_wp                   (lli_cpar_err_wp)
    ,.lli_tecrc_err_wp                  (lli_tecrc_err_wp)
    ,.lli_chdr_w_err_wp                 (lli_chdr_w_err_wp)

    ,.poisoned_wr_sent                  (poisoned_wr_sent)               // HSD 5314547 - MDPE not getting set when HQM receives poison completion

    ,.cds_poison_err_wp                 (cds_poison_err_wp)
    ,.cds_malform_pkt                   (cds_malform_pkt)

    ,.cpl_poisoned                      (cpl_poisoned)
    ,.cpl_unexpected                    (cpl_unexpected)
    ,.cpl_error_hdr                     (cpl_error_hdr)

    ,.cpl_timeout                       (cpl_timeout)
    ,.cpl_timeout_synd                  (cpl_timeout_synd)

    ,.csr_ppaerucm_wp                   (csr_ppaerucm_wp)
    ,.csr_ppaerucsev                    (csr_ppaerucsev)
    ,.csr_ppaercm_wp                    (csr_ppaercm_wp)
    ,.csr_ppaerctlcap_wp                (csr_ppaerctlcap_wp)
    ,.csr_pcicmd_wp                     (csr_pcicmd_wp)
    ,.csr_ppdcntl_wp                    (csr_ppdcntl_wp)
    ,.csr_pcists_clr                    (csr_pcists_clr)
    ,.csr_ppaerucs_clr                  (csr_ppaerucs_clr)
    ,.csr_ppaercs_clr                   (csr_ppaercs_clr)
    ,.csr_ppaerucs_c                    (csr_ppaerucs_c)

    ,.err_urd_vec                       (err_urd_vec)
    ,.err_fed_vec                       (err_fed_vec)
    ,.err_ned_vec                       (err_ned_vec)
    ,.err_ced_vec                       (err_ced_vec)

    ,.csr_pcists                        (csr_pcists)
    ,.csr_ppaerucs                      (csr_ppaerucs)
    ,.csr_ppaercs                       (csr_ppaercs)

    ,.err_hdr_log0                      (err_hdr_log0)
    ,.err_hdr_log1                      (err_hdr_log1)
    ,.err_hdr_log2                      (err_hdr_log2)
    ,.err_hdr_log3                      (err_hdr_log3)
    ,.err_tlp_prefix_log0               (err_tlp_prefix_log0)

    ,.err_gen_msg                       (err_gen_msg)
    ,.err_gen_msg_data                  (err_gen_msg_data)
    ,.err_gen_msg_func                  (err_gen_msg_func) // HSD 5313841 - Error function should be included in error message
    ,.current_bus                       (current_bus)
);

assign timeout_error        = mmio_timeout_error | hcw_timeout_error;
assign timeout_syndrome     = mmio_timeout_error ? {2'b00,mmio_timeout_syndrome} :
                                                   hcw_timeout_error ? {2'b01,hcw_timeout_syndrome} :
                                                                       {2'b11,8'hff};

//------------------------------------------------------------------------------
// Idle indication

logic   ri_idle_next;
logic   ri_idle_q;

assign ri_idle_next = &{
     tlq_idle
    ,cds_idle
    ,obc_idle
    ,pm_idle
    ,ri_iosf_sb_idle
    ,(~err_gen_msg)
};

always_ff @(posedge prim_nonflr_clk or negedge prim_gated_rst_b) begin
 if (~prim_gated_rst_b) begin
  ri_idle_q <= '1;
 end else begin
  ri_idle_q <= ri_idle_next & ~flr_treatment_vec;
 end
end

assign ri_idle = ri_idle_q & ri_iosf_sb_idle;

//------------------------------------------------------------------------------

assign ri_fifo_afull      = {ri_phdr_fifo_status.AFULL          //  5 (18)
                            ,ri_pdata_fifo_status.AFULL         //  4 (17)
                            ,ri_nphdr_fifo_status.AFULL         //  3 (16)
                            ,ri_npdata_fifo_status.AFULL        //  2 (15)
                            ,ri_ioq_fifo_status.AFULL           //  1 (14)
                            ,obcpl_fifo_status.AFULL            //  0 (13)
};

assign ri_fifo_overflow  = |{ri_phdr_fifo_status.OVRFLOW
                            ,ri_pdata_fifo_status.OVRFLOW
                            ,ri_nphdr_fifo_status.OVRFLOW
                            ,ri_npdata_fifo_status.OVRFLOW
                            ,ri_ioq_fifo_status.OVRFLOW
                            ,obcpl_fifo_status.OVRFLOW
};

assign ri_fifo_underflow = |{ri_phdr_fifo_status.UNDFLOW
                            ,ri_pdata_fifo_status.UNDFLOW
                            ,ri_nphdr_fifo_status.UNDFLOW
                            ,ri_npdata_fifo_status.UNDFLOW
                            ,ri_ioq_fifo_status.UNDFLOW
                            ,obcpl_fifo_status.UNDFLOW
};

assign ri_db_status_in_stalled  = { ri_hcw_db_status[6]
                                   ,ri_ioq_db_status[6]
                                   ,ri_npdata_db_status[6]
                                   ,ri_nphdr_db_status[6]
                                   ,ri_pdata_db_status[6]
                                   ,ri_phdr_db_status[6]
};
assign ri_db_status_in_taken    = { ri_hcw_db_status[5]
                                   ,ri_ioq_db_status[5]
                                   ,ri_npdata_db_status[5]
                                   ,ri_nphdr_db_status[5]
                                   ,ri_pdata_db_status[5]
                                   ,ri_phdr_db_status[5]
};
assign ri_db_status_out_stalled = { ri_hcw_db_status[4]
                                   ,ri_ioq_db_status[4]
                                   ,ri_npdata_db_status[4]
                                   ,ri_nphdr_db_status[4]
                                   ,ri_pdata_db_status[4]
                                   ,ri_phdr_db_status[4]
};

assign ri_db_status.HCW_DB_READY   = ri_hcw_db_status[2];
assign ri_db_status.HCW_DB_DEPTH   = ri_hcw_db_status[1:0];
assign ri_db_status.IOQ_DB_READY   = ri_ioq_db_status[2];
assign ri_db_status.IOQ_DB_DEPTH   = ri_ioq_db_status[1:0];
assign ri_db_status.NPD_DB_READY   = ri_npdata_db_status[2];
assign ri_db_status.NPD_DB_DEPTH   = ri_npdata_db_status[1:0];
assign ri_db_status.NPH_DB_READY   = ri_nphdr_db_status[2];
assign ri_db_status.NPH_DB_DEPTH   = ri_nphdr_db_status[1:0];
assign ri_db_status.PD_DB_READY    = ri_pdata_db_status[2];
assign ri_db_status.PD_DB_DEPTH    = ri_pdata_db_status[1:0];
assign ri_db_status.PH_DB_READY    = ri_phdr_db_status[2];
assign ri_db_status.PH_DB_DEPTH    = ri_phdr_db_status[1:0];

hqm_AW_unused_bits i_unused_db (
     .a     (|{ri_hcw_db_status[3]
              ,ri_ioq_db_status[3]
              ,ri_npdata_db_status[3]
              ,ri_nphdr_db_status[3]
              ,ri_pdata_db_status[3]
              ,ri_phdr_db_status[3]
            })
);

//------------------------------------------------------------------------------
// NOA Debug Interface for RI
//------------------------------------------------------------------------------
assign noa_ri = {tlq_noa, obc_noa, csr_noa, cds_noa, ri_idle};

assign flr_visa[13] = ps_d0_to_d3;
assign flr_visa[12] = flr_function0;
assign flr_visa[11] = flr_treatment;
assign flr_visa[10] = flr_pending;


//------------------------------------------------------------------------------
// Assertions
//------------------------------------------------------------------------------
`ifndef INTEL_SVA_OFF
    //  - Assertions meant for the HSDs HSD 5314860/5314839/5185113 were not turned. Uncomment after turnin goes thru.
    `include "hqm_ri_sva.sv"

`endif

endmodule

// *** End File Body ***
//----------------------------------------------------------------------------------
