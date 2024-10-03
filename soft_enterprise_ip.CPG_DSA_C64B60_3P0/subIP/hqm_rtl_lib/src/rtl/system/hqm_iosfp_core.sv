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
// HQM IOSF primary interface
//-----------------------------------------------------------------------------------------------------

`include "hqm_system_def.vh"

module hqm_iosfp_core

     import  hqm_AW_pkg::*, hqm_pkg::*, hqm_sif_pkg::*, hqm_system_pkg::*, hqm_sif_csr_pkg::*,
                hqm_system_type_pkg::*, hqm_system_func_pkg::*;
#(
     parameter TCRD_BYPASS      = HQMIOSF_TCRD_BYPASS       // Target Credit Bypass

    // iosf_tgt

    ,parameter TGT_TX_PRH       = HQMIOSF_TGT_TX_PRH
    ,parameter TGT_TX_NPRH      = HQMIOSF_TGT_TX_NPRH
    ,parameter TGT_TX_CPLH      = HQMIOSF_TGT_TX_CPLH
    ,parameter TGT_TX_PRD       = HQMIOSF_TGT_TX_PRD
    ,parameter TGT_TX_NPRD      = HQMIOSF_TGT_TX_NPRD
    ,parameter TGT_TX_CPLD      = HQMIOSF_TGT_TX_CPLD

    // iosf common

    ,parameter PORTS            = HQMIOSF_PORTS
    ,parameter VC               = HQMIOSF_VC
    ,parameter MNUMCHANL2       = HQMIOSF_MNUMCHANL2
    ,parameter TNUMCHANL2       = HQMIOSF_TNUMCHANL2
    ,parameter MAX_PAYLOAD      = HQMIOSF_MSTR_MAX_PAYLOAD

  ) (

    //---------------------------------------------------------------------------------------------
    // clocks and reset

     input  logic                                       pgcb_clk

    // Primary

    ,output logic                                       prim_pok
    ,output logic                                       prim_clkreq
    ,input  logic                                       prim_clkack

    ,output logic                                       prim_clk_enable
    ,output logic                                       prim_clk_enable_cdc
    ,output logic                                       prim_clk_enable_sys
    ,output logic                                       prim_clk_ungate


    ,input  logic [2:0]                                 prim_ism_fabric
    ,output logic [2:0]                                 prim_ism_agent
    ,input  logic                                       prim_pwrgate_pmc_wake

    ,input  logic                                       prim_freerun_clk    // IOSF clock
    ,input  logic                                       prim_gated_clk      // IOSF gated clock
    ,input  logic                                       prim_nonflr_clk     // IOSF FLR gated clock
    ,input  logic                                       prim_rst_b          // Active low reset input
    ,output logic                                       prim_gated_rst_b    // Active low reset matching gated clock
    ,input  logic                                       prim_gated_wflr_rst_b_primary

    ,input  logic                                       hqm_csr_pf0_rst_n

    // Sideband Clocks

    ,input  logic                                       side_rst_b

    ,output logic                                       side_gated_rst_prim_b // asynchronous assertion, deassertion synced to pclk

    //---------------------------------------------------------------------------------------------
    // ISM and Clock Gating Signals

    ,input  logic                                       pma_safemode

    ,input  logic                                       force_warm_reset
    ,input  logic                                       force_ip_inaccessible

    ,input  logic                                       func_in_rst

    ,input  logic                                       agent_clkreq
    ,input  logic                                       agent_clkreq_async

    ,input  logic                                       prim_clkreq_async_sbe
    ,output logic                                       prim_clkack_async_sbe

    ,input  logic                                       agent_idle
    ,input  logic                                       hqm_idle

    ,output logic                                       mstr_idle
    ,output logic                                       mstr_intf_idle
    ,output logic                                       tgt_idle

    //---------------------------------------------------------------------------------------------
    // Straps

    ,input  logic [SAI_WIDTH:0]                         strap_hqm_tx_sai    // SAI for outgoing requests

    ,input  logic [SAI_WIDTH:0]                         strap_hqm_cmpl_sai  // SAI for completions

    ,input  logic                                       strap_hqm_completertenbittagen

    //---------------------------------------------------------------------------------------------
    // Reset Prep Handling Interface

    ,input  logic                                       sif_mstr_quiesce_req    // Tell MSTR to block Mastered logic
    ,output logic                                       sif_mstr_quiesce_ack    // Tell RI_IOSF_SB that the IOSF MSTR is empty

    //---------------------------------------------------------------------------------------------
    // IOSF Interface -- this is to the PPF

    // Master Request Control Interface

    ,output logic                                       req_put         // Request Put
    ,output logic [1:0]                                 req_rtype       // Request Type
    ,output logic                                       req_cdata       // Request Contains Data
    ,output logic [MAX_DATA_LEN:0]                      req_dlen        // Request Data Length
    ,output logic [3:0]                                 req_tc          // Request Traffic Class
    ,output logic                                       req_ns          // Request Non-Snoop
    ,output logic                                       req_ro          // Request Relaxed Order
    ,output logic [RS_WIDTH:0]                          req_rs          // Request Root space ID
    ,output logic                                       req_ido         // Request ID Based Order
    ,output logic [15:0]                                req_id          // Request ID Based Order
    ,output logic                                       req_opp         // Request Opportunitstic
    ,output logic                                       req_locked      // Request Locked
    ,output logic                                       req_chain       // Request Chain
    ,output logic [AGENT_WIDTH:0]                       req_agent       // Request IP Specific
    ,output logic [DST_ID_WIDTH:0]                      req_dest_id     // opt: Destination ID (src dec)
    ,input  logic                                       gnt             // Grant
    ,input  logic [1:0]                                 gnt_rtype       // Grant Request Type
    ,input  logic [1:0]                                 gnt_type        // Grant Request Type

    // Master Command Interface

    ,output logic [1:0]                                 mfmt            // Fmt
    ,output logic [4:0]                                 mtype           // Type
    ,output logic [3:0]                                 mtc             // Traffic Class
    ,output logic                                       mep             // Error Present
    ,output logic                                       mro             // Relaxed Ordering
    ,output logic                                       mns             // Non-Snoop
    ,output logic [1:0]                                 mat             // Address Translation Services
    ,output logic [MAX_DATA_LEN:0]                      mlength         // Length
    ,output logic [15:0]                                mrqid           // Requester ID
    ,output logic [7:0]                                 mtag            // Tag
    ,output logic [3:0]                                 mlbe            // Last DW Byte Enable
    ,output logic [3:0]                                 mfbe            // First DW Byte Enable
    ,output logic [MMAX_ADDR:0]                         maddress        // Transaction Address
    ,output logic                                       mtd             // TLP Digest
    ,output logic [31:0]                                mecrc           // opt: End to End CRC
    ,output logic [RS_WIDTH:0]                          mrs             // Request Root space ID
                                                                        //  PPAERCTLCAP.ECRCGE needs to go to IOSF shim
    ,output logic                                       mrsvd1_7        // PCI Express Reserved
    ,output logic                                       mrsvd1_3        // PCI Express Reserved
    ,output logic                                       mth             // TPH
    ,output logic                                       mido            // ido
    ,output logic                                       mcparity        // Even Command Parity
    ,output logic [SRC_ID_WIDTH:0]                      msrc_id         // opt: Source ID (peer-to-peer)
    ,output logic [DST_ID_WIDTH:0]                      mdest_id        // opt: Destination ID (src dec)
    ,output logic [SAI_WIDTH:0]                         msai
    ,output logic [HQM_PASIDTLP_WIDTH-1:0]              mpasidtlp       // Proccess Address Space ID TLP

    // Master Data Interface

    ,output logic [MD_WIDTH:0]                          mdata           // Data
    ,output logic [MDP_WIDTH:0]                         mdparity        // Even Data Parity should use DP_WIDTH

    //---------------------------------------------------------------------------------------------
    // Target interface -- this is to iosf tgt

    // IOSF Target Interface Cmd/Credit

    ,input  logic                                       cmd_put
    ,input  logic [1:0]                                 cmd_rtype
    ,input  logic                                       cmd_nfs_err
    ,output logic                                       credit_put
    ,output logic [1:0]                                 credit_rtype
    ,output logic                                       credit_cmd
    ,output logic [2:0]                                 credit_data

    // IOSF Target Command Interface

    ,input  logic [1:0]                                 tfmt
    ,input  logic [4:0]                                 ttype
    ,input  logic [3:0]                                 ttc
    ,input  logic                                       tep
    ,input  logic                                       tro
    ,input  logic                                       tns
    ,input  logic [1:0]                                 tat
    ,input  logic [MAX_DATA_LEN:0]                      tlength
    ,input  logic [15:0]                                trqid
    ,input  logic [7:0]                                 ttag
    ,input  logic [3:0]                                 tlbe
    ,input  logic [3:0]                                 tfbe
    ,input  logic [TMAX_ADDR:0]                         taddress
    ,input  logic                                       ttd
    ,input  logic [31:0]                                tecrc
    ,input  logic                                       trsvd1_3
    ,input  logic                                       trsvd1_7
    ,input  logic                                       tth
    ,input  logic                                       tido
    ,input  logic                                       tchain
    ,input  logic                                       tcparity
    ,input  logic [SRC_ID_WIDTH:0]                      tsrc_id         // opt: Source ID (peer-to-peer)
    ,input  logic [DST_ID_WIDTH:0]                      tdest_id        // opt: Destination ID (src dec)
    ,input  logic [SAI_WIDTH:0]                         tsai
    ,input  logic [RS_WIDTH:0]                          trs
    ,input  logic [HQM_PASIDTLP_WIDTH-1:0]              tpasidtlp       // Proccess Address Space ID TLP

    // IOSF Target Data Interface

    ,input  logic [TD_WIDTH:0]                          tdata
    ,input  logic [TDP_WIDTH:0]                         tdparity        // 2 bits for 512, 1 bit for 256

    ,output logic [(VC*PORTS)-1:0]                      hit
    ,input  logic                                       tdec
    ,output logic [0:0]                                 sub_hit         // opt: Subtractive Hit

    //---------------------------------------------------------------------------------------------
    // Link Layer Interface to RI

    ,output logic                                       lli_phdr_val
    ,output tdl_phdr_t                                  lli_phdr

    ,output logic                                       lli_nphdr_val
    ,output tdl_nphdr_t                                 lli_nphdr

    ,output logic                                       lli_pdata_push
    ,output logic                                       lli_npdata_push
    ,output ri_bus_width_t                              lli_pkt_data
    ,output ri_bus_par_t                                lli_pkt_data_par

    ,output logic                                       iosf_ep_cpar_err   // Cmd Hdr parity error detected
    ,output logic                                       iosf_ep_tecrc_err
    ,output errhdr_t                                    iosf_ep_chdr_w_err

    ,input  hqm_iosf_tgt_crd_t                          ri_tgt_crd_inc

    ,output new_TGT_INIT_HCREDITS_t                     tgt_init_hcredits
    ,output new_TGT_INIT_DCREDITS_t                     tgt_init_dcredits
    ,output new_TGT_REM_HCREDITS_t                      tgt_rem_hcredits
    ,output new_TGT_REM_DCREDITS_t                      tgt_rem_dcredits
    ,output new_TGT_RET_HCREDITS_t                      tgt_ret_hcredits
    ,output new_TGT_RET_DCREDITS_t                      tgt_ret_dcredits

    ,output logic                                       cpl_usr
    ,output logic                                       cpl_abort
    ,output logic                                       cpl_poisoned
    ,output logic                                       cpl_unexpected

    ,output logic                                       cpl_error
    ,output tdl_cplhdr_t                                cpl_error_hdr

    ,output logic                                       cpl_timeout
    ,output logic [8:0]                                 cpl_timeout_synd

    ,output logic                                       np_trans_pending
    ,output logic                                       poisoned_wr_sent

    //---------------------------------------------------------------------------------------------
    // Outbound completions

    ,output logic                                       obcpl_ready

    ,input  logic                                       obcpl_v
    ,input  RiObCplHdr_t                                obcpl_hdr
    ,input  csr_data_t                                  obcpl_data
    ,input  logic                                       obcpl_dpar
    ,input  upd_enables_t                               obcpl_enables

    ,input  upd_enables_t                               gpsb_upd_enables

    //---------------------------------------------------------------------------------------------
    // ATS Invalidates

    ,input  logic                                       rx_msg_v
    ,input  hqm_devtlb_rx_msg_t                         rx_msg

    //---------------------------------------------------------------------------------------------
    // Config

    ,input  logic                                       csr_ppdcntl_ero

    ,input  logic [7:0]                                 current_bus

    ,input  logic                                       fuse_proc_disable

    ,input  HQM_SIF_CNT_CTL_t                           hqm_sif_cnt_ctl

    ,output logic [1:0] [31:0]                          mstr_cnts

    ,input  logic [63:0]                                cfg_ph_trigger_addr
    ,input  logic [63:0]                                cfg_ph_trigger_mask

    ,input  logic                                       cfg_ats_enabled
    ,input  SCRBD_CTL_t                                 cfg_scrbd_ctl
    ,input  MSTR_LL_CTL_t                               cfg_mstr_ll_ctl
    ,input  DEVTLB_CTL_t                                cfg_devtlb_ctl
    ,input  DEVTLB_SPARE_t                              cfg_devtlb_spare
    ,input  DEVTLB_DEFEATURE0_t                         cfg_devtlb_defeature0
    ,input  DEVTLB_DEFEATURE1_t                         cfg_devtlb_defeature1
    ,input  DEVTLB_DEFEATURE2_t                         cfg_devtlb_defeature2

    ,input  DIR_CQ2TC_MAP_t                             dir_cq2tc_map
    ,input  LDB_CQ2TC_MAP_t                             ldb_cq2tc_map
    ,input  INT2TC_MAP_t                                int2tc_map

    ,output new_LOCAL_BME_STATUS_t                      local_bme_status
    ,output new_LOCAL_MSIXE_STATUS_t                    local_msixe_status

    ,input  IBCPL_HDR_FIFO_CTL_t                        cfg_ibcpl_hdr_fifo_ctl
    ,input  IBCPL_DATA_FIFO_CTL_t                       cfg_ibcpl_data_fifo_ctl

    ,output new_SIF_MSTR_DEBUG_t                        sif_mstr_debug

    ,input  hqm_sif_csr_pkg::PARITY_CTL_t               cfg_parity_ctl

    ,input  SIF_IDLE_STATUS_t                           sif_idle_status_reg

    //---------------------------------------------------------------------------------------------
    // DFX interface

    ,input  logic                                       fscan_byprst_b
    ,input  logic                                       fscan_clkungate
    ,input  logic                                       fscan_clkungate_syn
    ,input  logic                                       fscan_latchclosed_b
    ,input  logic                                       fscan_latchopen
    ,input  logic                                       fscan_mode
    ,input  logic                                       fscan_rstbypen
    ,input  logic                                       fscan_shiften

    ,input  logic                                       prim_jta_force_clkreq
    ,input  logic                                       prim_jta_force_creditreq
    ,input  logic                                       prim_jta_force_idle
    ,input  logic                                       prim_jta_force_notidle

    ,input  logic                                       cdc_prim_jta_force_clkreq   // DFx force assert clkreq
    ,input  logic                                       cdc_prim_jta_clkgate_ovrd   // DFx force GATE gclock

    //---------------------------------------------------------------------------------------------
    // To/From Alarms

    ,output new_IBCPL_HDR_FIFO_STATUS_t                 cfg_ibcpl_hdr_fifo_status
    ,output new_IBCPL_DATA_FIFO_STATUS_t                cfg_ibcpl_data_fifo_status
    ,output new_P_RL_CQ_FIFO_STATUS_t                   cfg_p_rl_cq_fifo_status

    ,output new_SIF_DB_STATUS_t                         sif_db_status

    ,output logic                                       mstr_fifo_overflow
    ,output logic                                       mstr_fifo_underflow
    ,output logic [2:0]                                 mstr_fifo_afull

    ,input  logic [31:0]                                int_serial_status

    ,output logic                                       sif_parity_alarm
    ,output logic [8:0]                                 set_sif_parity_err_mstr

    ,output load_DEVTLB_ATS_ERR_t                       set_devtlb_ats_err
    ,output logic                                       devtlb_ats_alarm

    ,output new_DEVTLB_STATUS_t                         devtlb_status
    ,output new_SCRBD_STATUS_t                          scrbd_status
    ,output new_MSTR_CRD_STATUS_t                       mstr_crd_status
    ,output new_MSTR_FL_STATUS_t                        mstr_fl_status
    ,output new_MSTR_LL_STATUS_t                        mstr_ll_status

    //---------------------------------------------------------------------------------------------
    // To smon

    ,output logic [2:0]                                 mstr_db_status_in_stalled
    ,output logic [2:0]                                 mstr_db_status_in_taken
    ,output logic [2:0]                                 mstr_db_status_out_stalled

    //---------------------------------------------------------------------------------------------
    // System Posted Request interface

    ,output logic                                       write_buffer_mstr_ready
    ,input  logic                                       write_buffer_mstr_v
    ,input  write_buffer_mstr_t                         write_buffer_mstr

    ,input  logic                                       mask_posted

    //---------------------------------------------------------------------------------------------
    // csr

    ,input  PRIM_CDC_CTL_t                              cfg_prim_cdc_ctl

    ,input  IOSFP_CGCTL_t                               iosfp_cgctl

    //---------------------------------------------------------------------------------------------
    // pm

    ,input  logic                                       force_pm_state_d3hot
    ,input  logic                                       pm_fsm_d0tod3_ok
    ,input  logic                                       pm_fsm_d3tod0_ok

    //---------------------------------------------------------------------------------------------
    // flr

    ,input  logic                                       hqm_flr_prep

    ,input  logic                                       flr_clk_enable
    ,input  logic                                       flr_clk_enable_system
    ,input  logic                                       flr_treatment
    ,input  logic                                       flr_treatment_vec
    ,input  logic                                       flr_triggered_wl
    ,output logic                                       flr_triggered

    ,input  logic                                       flr_txn_sent
    ,input  nphdr_tag_t                                 flr_txn_tag
    ,input  hdr_reqid_t                                 flr_txn_reqid

    ,input  logic                                       ps_txn_sent
    ,input  nphdr_tag_t                                 ps_txn_tag
    ,input  hdr_reqid_t                                 ps_txn_reqid

    ,input  logic [13:0]                                flr_visa_ri

    //---------------------------------------------------------------------------------------------
    // visa

    ,input  logic [256:0]                               noa_ri

    ,output logic [9:0]                                 hqm_triggers

    ,output logic [679:0]                               hqm_sif_visa

    ,input  VISA_SW_CONTROL_t                           cfg_visa_sw_control

    //---------------------------------------------------------------------------------------------
    // Memory interfaces

    ,output hqm_sif_memi_scrbd_mem_t                    memi_scrbd_mem
    ,input  hqm_sif_memo_scrbd_mem_t                    memo_scrbd_mem
    ,output hqm_sif_memi_ibcpl_hdr_t                    memi_ibcpl_hdr_fifo
    ,input  hqm_sif_memo_ibcpl_hdr_t                    memo_ibcpl_hdr_fifo
    ,output hqm_sif_memi_ibcpl_data_t                   memi_ibcpl_data_fifo
    ,input  hqm_sif_memo_ibcpl_data_t                   memo_ibcpl_data_fifo
    ,output hqm_sif_memi_mstr_ll_hpa_t                  memi_mstr_ll_hpa
    ,input  hqm_sif_memo_mstr_ll_hpa_t                  memo_mstr_ll_hpa
    ,output hqm_sif_memi_mstr_ll_hdr_t                  memi_mstr_ll_hdr
    ,input  hqm_sif_memo_mstr_ll_hdr_t                  memo_mstr_ll_hdr
    ,output hqm_sif_memi_mstr_ll_data_t                 memi_mstr_ll_data0
    ,input  hqm_sif_memo_mstr_ll_data_t                 memo_mstr_ll_data0
    ,output hqm_sif_memi_mstr_ll_data_t                 memi_mstr_ll_data1
    ,input  hqm_sif_memo_mstr_ll_data_t                 memo_mstr_ll_data1
    ,output hqm_sif_memi_mstr_ll_data_t                 memi_mstr_ll_data2
    ,input  hqm_sif_memo_mstr_ll_data_t                 memo_mstr_ll_data2
    ,output hqm_sif_memi_mstr_ll_data_t                 memi_mstr_ll_data3
    ,input  hqm_sif_memo_mstr_ll_data_t                 memo_mstr_ll_data3

    ,output hqm_sif_memi_tlb_tag_4k_t                   memi_tlb_tag0_4k
    ,input  hqm_sif_memo_tlb_tag_4k_t                   memo_tlb_tag0_4k
    ,output hqm_sif_memi_tlb_tag_4k_t                   memi_tlb_tag1_4k
    ,input  hqm_sif_memo_tlb_tag_4k_t                   memo_tlb_tag1_4k
    ,output hqm_sif_memi_tlb_tag_4k_t                   memi_tlb_tag2_4k
    ,input  hqm_sif_memo_tlb_tag_4k_t                   memo_tlb_tag2_4k
    ,output hqm_sif_memi_tlb_tag_4k_t                   memi_tlb_tag3_4k
    ,input  hqm_sif_memo_tlb_tag_4k_t                   memo_tlb_tag3_4k
    ,output hqm_sif_memi_tlb_tag_4k_t                   memi_tlb_tag4_4k
    ,input  hqm_sif_memo_tlb_tag_4k_t                   memo_tlb_tag4_4k
    ,output hqm_sif_memi_tlb_tag_4k_t                   memi_tlb_tag5_4k
    ,input  hqm_sif_memo_tlb_tag_4k_t                   memo_tlb_tag5_4k
    ,output hqm_sif_memi_tlb_tag_4k_t                   memi_tlb_tag6_4k
    ,input  hqm_sif_memo_tlb_tag_4k_t                   memo_tlb_tag6_4k
    ,output hqm_sif_memi_tlb_tag_4k_t                   memi_tlb_tag7_4k
    ,input  hqm_sif_memo_tlb_tag_4k_t                   memo_tlb_tag7_4k

    ,output hqm_sif_memi_tlb_data_4k_t                  memi_tlb_data0_4k
    ,input  hqm_sif_memo_tlb_data_4k_t                  memo_tlb_data0_4k
    ,output hqm_sif_memi_tlb_data_4k_t                  memi_tlb_data1_4k
    ,input  hqm_sif_memo_tlb_data_4k_t                  memo_tlb_data1_4k
    ,output hqm_sif_memi_tlb_data_4k_t                  memi_tlb_data2_4k
    ,input  hqm_sif_memo_tlb_data_4k_t                  memo_tlb_data2_4k
    ,output hqm_sif_memi_tlb_data_4k_t                  memi_tlb_data3_4k
    ,input  hqm_sif_memo_tlb_data_4k_t                  memo_tlb_data3_4k
    ,output hqm_sif_memi_tlb_data_4k_t                  memi_tlb_data4_4k
    ,input  hqm_sif_memo_tlb_data_4k_t                  memo_tlb_data4_4k
    ,output hqm_sif_memi_tlb_data_4k_t                  memi_tlb_data5_4k
    ,input  hqm_sif_memo_tlb_data_4k_t                  memo_tlb_data5_4k
    ,output hqm_sif_memi_tlb_data_4k_t                  memi_tlb_data6_4k
    ,input  hqm_sif_memo_tlb_data_4k_t                  memo_tlb_data6_4k
    ,output hqm_sif_memi_tlb_data_4k_t                  memi_tlb_data7_4k
    ,input  hqm_sif_memo_tlb_data_4k_t                  memo_tlb_data7_4k
);

//--------------------------------------------------------------------------
// Local Parameters
//--------------------------------------------------------------------------
// bllem - making these non-configurable to the user

localparam      RC_WIDTH            = 5; // HSD 4186887 Request credit register width

// TX queue info - used for pre-allocation

localparam int  TGT_CMDPARCHK_DIS   = 0;
localparam int  TGT_DATPARCHK_DIS   = 0;
localparam int  GEN_ECRC            = 0;
localparam int  DROP_ECRC           = 1;

localparam      DEF_PWRON           = 0;

//--------------------------------------------------------------------------
// Internal Signal Definitions
//--------------------------------------------------------------------------

// IOSF Target inputs/outputs

hqm_iosf_tgt_credit_t                       iosf_tgt_credit;
hqm_iosf_tgt_cput_t                         iosf_tgt_cput;
hqm_iosf_tgt_cmd_t                          iosf_tgt_cmd;
hqm_iosf_tgt_data_t                         iosf_tgt_data;

// IOSF Master Inputs/Outputs

hqm_iosf_req_t                              iosf_req; // request put
hqm_iosf_cmd_t                              iosf_cmd;
hqm_iosf_gnt_t                              iosf_gnt; // grant

//---------------------------------------------------------------------------
// Command Handler for IOSF to RI translate

hqm_iosf_tgt_crd_t                          iosf_tgt_crd_dec;

hqm_iosf_tgtq_cmddata_t                     iosf_tgtq_cmddata;

//---------------------------------------------------------------------------
// Added for quicksyn

hqm_iosf_tgtq_hdrbits_t                     iosf_tgtq_hdrbits_pre_ncpl_nc; // added by aamehta1 for quicksyn

logic [MDP_WIDTH:0]                         mdparity_out;

// IOSF Instantiation Support Signals

logic [MAX_DATA_LEN:0]                      int_req_dlen;

logic [TMAX_ADDR:0]                         int_taddress;
logic [MMAX_ADDR:0]                         int_maddress;

//---------------------------------------------------------------------------
// Unused IOSF Primary Signals

logic                                       req_chid;
logic                                       credit_chid;

logic                                       mrsvd1_1;
logic                                       mrsvd0_7;

logic   [0:0]                               req_priority;

//---------------------------------------------------------------------------

logic [8:0]                                 cfg_ibcpl_hdr_fifo_high_wm;
logic [8:0]                                 cfg_ibcpl_data_fifo_high_wm;

logic [6:0]                                 p_req_db_status;
logic [6:0]                                 np_req_db_status;
logic [6:0]                                 cpl_req_db_status;

//---------------------------------------------------------------------------
// Transaction Decode Logic To RI

logic                                       lli_cplhdr_val;
tdl_cplhdr_t                                lli_cplhdr;

logic                                       lli_cpldata_push;

logic                                       ph_trigger;
logic                                       cfg_ph_trigger_enable;

logic                                       write_buffer_mstr_v_qual;

logic [TNUMCHANL2:0]                        cmd_chid;
logic [MNUMCHANL2:0]                        gnt_chid;

logic                                       tecrc_generate;
logic                                       tecrc_error;

logic                                       trsvd0_7;
logic                                       trsvd1_1;

logic                                       prim_rst_aon_b;

logic                                       prim_rst_sync_b_nc;
logic                                       prim_gclock_nc;
logic                                       prim_pwrgate_ready;

logic                                       side_rst_sync_prim_b_nc;
logic                                       prim_clk_active_nc;
logic                                       prim_boundary_locked_nc;

logic [23:0]                                cdc_visa_nc;

logic                                       prim_clkreq_sync;
logic [1:0]                                 prim_clkreq_async;
logic [1:0]                                 prim_clkack_async;

logic                                       prim_ism_locked;

logic                                       force_pwr_gate_pok_next;
logic                                       force_pwr_gate_pok_q;
logic                                       force_pwr_gate_pok_clr;
logic                                       force_pwr_gate_pok_sync;
logic                                       force_pwr_gate_pok_sync_q;
logic                                       force_pwr_gate_pok_sync_edge;

logic                                       allow_force_pwrgate_next;
logic                                       allow_force_pwrgate_q;

logic                                       prim_pgcb_pok;
logic                                       prim_pwrgate_force;
logic                                       prim_pwrgate_force_in;
logic                                       prim_pgcb_pwrgate_active;
logic                                       prim_pwrgate_pmc_wake_sync;
logic                                       prim_allow_force_pwrgate_sync;

logic                                       pma_safemode_sync;

logic                                       credit_init_done;
logic                                       credit_init;
logic                                       tgt_has_unret_credits;

logic                                       prim_ism_lock_b;

logic [191:0]                               noa_mstr;
logic [31:0]                                noa_tgt;

logic [19:0]                                flr_visa;

logic                                       hqm_idle_q;

logic [2:0]                                 prim_ism_fabric_pgmask;

logic                                       flr_cpl_sent;
logic                                       flr_cpl_sent_q;

logic                                       prim_rst_b_synced;
logic                                       prim_gated_rst_b_synced;
logic                                       prim_clkreq_synced;
logic                                       prim_clkack_synced;

logic [7:0]                                 ep_nprdcredits_sw_rxl;
logic [7:0]                                 ep_nprhcredits_sw_rxl;
logic [7:0]                                 ep_prdcredits_sw_rxl;
logic [7:0]                                 ep_prhcredits_sw_rxl;
logic [7:0]                                 ep_cpldcredits_sw_rxl;
logic [7:0]                                 ep_cplhcredits_sw_rxl;

//--------------------------------------------------------------------------
// Instance of the IOSF Target Top
//--------------------------------------------------------------------------

// These are limited to 255 max

assign ep_prhcredits_sw_rxl  = P_HDR_CREDITS[7:0];
assign ep_prdcredits_sw_rxl  = P_DATA_CREDITS[7:0];
assign ep_nprhcredits_sw_rxl = NP_HDR_CREDITS[7:0];
assign ep_nprdcredits_sw_rxl = NP_DATA_CREDITS[7:0];
assign ep_cplhcredits_sw_rxl = CPL_HDR_CREDITS[7:0];
assign ep_cpldcredits_sw_rxl = CPL_DATA_CREDITS[7:0];

hqm_iosf_tgt_top #(

     .TCRD_BYPASS                           (TCRD_BYPASS)
    ,.VC                                    (VC)
    ,.TX_PRH                                (TGT_TX_PRH)
    ,.TX_NPRH                               (TGT_TX_NPRH)
    ,.TX_CPLH                               (TGT_TX_CPLH)
    ,.TX_PRD                                (TGT_TX_PRD)
    ,.TX_NPRD                               (TGT_TX_NPRD)
    ,.TX_CPLD                               (TGT_TX_CPLD)
    ,.IOSF_TGT_STAGE2                       (1)             // Enable flopping of IOSF ifc sigs before wr into the RFs.
    ,.D_WIDTH                               (TD_WIDTH)
    ,.PORTS                                 (PORTS)
    ,.MAX_LEN                               (MAX_DATA_LEN)
    ,.TGT_CMDPARCHK_DIS                     (TGT_CMDPARCHK_DIS)
    ,.TGT_DATPARCHK_DIS                     (TGT_DATPARCHK_DIS)
    ,.GEN_ECRC                              (GEN_ECRC)
    ,.DROP_ECRC                             (DROP_ECRC)

) i_hqm_iosf_tgt_top (

    // Outputs

     .iosf_tgt_credit                       (iosf_tgt_credit)
    ,.hit                                   (hit)
    ,.iosf_tgtq_cmddata                     (iosf_tgtq_cmddata)
    ,.iosf_tgtq_hdrbits                     (iosf_tgtq_hdrbits_pre_ncpl_nc)
    ,.credit_init_done                      (credit_init_done)
    ,.tgt_idle                              (tgt_idle)
    ,.tgt_init_hcredits                     (tgt_init_hcredits)
    ,.tgt_init_dcredits                     (tgt_init_dcredits)
    ,.tgt_rem_hcredits                      (tgt_rem_hcredits)
    ,.tgt_rem_dcredits                      (tgt_rem_dcredits)
    ,.tgt_ret_hcredits                      (tgt_ret_hcredits)
    ,.tgt_ret_dcredits                      (tgt_ret_dcredits)

    // Inputs

    ,.prim_nonflr_clk                       (prim_nonflr_clk)       // use PGCB clock gated for nCPM
    ,.prim_gated_rst_b                      (prim_gated_rst_b)      // jbdiethe changed to local_. Check cct inst code.
    ,.prim_ism_agent                        (prim_ism_agent[2:0])
    ,.credit_init                           (credit_init)

    // Added to support credit handshake with EP

    ,.ep_nprdcredits_sw_rxl                 (ep_nprdcredits_sw_rxl)
    ,.ep_nprhcredits_sw_rxl                 (ep_nprhcredits_sw_rxl)
    ,.ep_prdcredits_sw_rxl                  (ep_prdcredits_sw_rxl)
    ,.ep_prhcredits_sw_rxl                  (ep_prhcredits_sw_rxl)
    ,.ep_cpldcredits_sw_rxl                 (ep_cpldcredits_sw_rxl)
    ,.ep_cplhcredits_sw_rxl                 (ep_cplhcredits_sw_rxl)
    ,.iosf_tgt_cput                         (iosf_tgt_cput)
    ,.tdec                                  (tdec)
    ,.iosf_tgt_cmd                          (iosf_tgt_cmd)
    ,.iosf_tgt_data                         (iosf_tgt_data)
    ,.iosf_tgt_crd_dec                      (iosf_tgt_crd_dec)
    ,.ri_tgt_crd_inc                        (ri_tgt_crd_inc)
    ,.mstr_iosf_gnt                         (iosf_gnt)
    ,.noa_tgt                               (noa_tgt)
    ,.tgt_has_unret_credits                 (tgt_has_unret_credits)
);

// Drive IOSF Master signals always_comb begin

//I: IOSF: Grant Channel ID:
//   Specifies the agent encoded Channel ID of the granted request.
//   This signal is not present if the IOSF agent supports only one channel.

assign gnt_chid = 1'd0;

always_comb begin
 req_put            = iosf_req.put;
 req_chid           = iosf_req.chid;
 req_rtype          = iosf_req.rtype;
 req_cdata          = iosf_req.cdata;
 int_req_dlen       = iosf_req.dlen;
 req_tc             = iosf_req.tc;
 req_ns             = iosf_req.ns;
 req_ro             = iosf_req.ro;
 req_rs             = iosf_req.rs;
 req_ido            = iosf_req.ido;
 req_id             = iosf_req.id;
 req_priority       = iosf_req.priorty;
 req_opp            = iosf_req.opp;
 req_locked         = iosf_req.locked;
 req_chain          = iosf_req.chain;
 req_agent          = iosf_req.agent;
end

always_comb begin
 iosf_gnt.gnt       = gnt;
 iosf_gnt.chid      = gnt_chid;
 iosf_gnt.rtype     = gnt_rtype;
 iosf_gnt.gtype     = gnt_type;
end

logic [1:0] inj_perr_q;
logic [1:0] inj_perr_last_q;
logic [1:0] inj_perr;
logic [1:0] gnt_q;

always_ff @(posedge prim_nonflr_clk, negedge prim_gated_rst_b) begin
 if(~prim_gated_rst_b) begin
  gnt_q           <= '0;
  inj_perr_q      <= '0;
  inj_perr_last_q <= '0;
 end else begin
  gnt_q           <= {(gnt_q[0] & iosf_cmd.cfmt[1]), gnt};
  inj_perr_q      <= {cfg_parity_ctl.INJ_SIF_MDPERR,
                      cfg_parity_ctl.INJ_SIF_MCPERR};
  inj_perr_last_q <= inj_perr_q & (inj_perr_last_q | gnt_q);
 end
end

assign inj_perr = gnt_q & inj_perr_q & ~inj_perr_last_q;

always_comb begin
 mfmt               = iosf_cmd.cfmt;
 mtype              = iosf_cmd.ctype;
 mtc                = iosf_cmd.ctc;
 mep                = iosf_cmd.cep;
 mro                = iosf_cmd.cro;
 mns                = iosf_cmd.cns;
 mat                = iosf_cmd.cat;
 mlength            = iosf_cmd.clength;
 mrqid              = iosf_cmd.crqid;
 mtag               = iosf_cmd.ctag;
 mlbe               = iosf_cmd.clbe;
 mfbe               = iosf_cmd.cfbe;
 int_maddress       = iosf_cmd.caddress[MMAX_ADDR:0];
 mtd                = iosf_cmd.ctd;
 mrsvd1_1           = iosf_cmd.crsvd1_1;
 mrsvd1_3           = iosf_cmd.crsvd1_3;
 mrsvd1_7           = iosf_cmd.crsvd1_7;
 mrsvd0_7           = iosf_cmd.crsvd0_7;
 mth                = iosf_cmd.cth;
 mido               = iosf_cmd.cido;
 mcparity           = iosf_cmd.cparity ^ inj_perr[0];
 msai               = iosf_cmd.csai;
 mrs                = iosf_cmd.crs;
 mpasidtlp          = iosf_cmd.cpasidtlp;

 mdparity           = mdparity_out;
 mdparity[0]        = mdparity_out[0]  ^ inj_perr[1];
end

assign req_dlen     = int_req_dlen[MAX_DATA_LEN:0];
assign int_taddress = taddress[TMAX_ADDR:0];
assign sub_hit      = '0;
assign msrc_id      = '0;
assign mdest_id     = '0;
assign mecrc        = '0;
assign req_dest_id  = '0;

always_comb begin
  maddress              = '0;
  maddress[MMAX_ADDR:0] = int_maddress[MMAX_ADDR:0];
end

//I: IOSF: Command Channel ID:
//   Asserted by the fabric with the command put to identify the targeted
//   channel of the command within the agent. The targeted channel can obtain
//   the request type from the command format and type fields. This signal is
//   not present if the IOSF agent supports only one channel.

assign cmd_chid         = 1'd0;

assign tecrc_generate   = '0;
assign tecrc_error      = '0;  // signal is NOT driven for nCPM as nCPM-VRP connection

//I: IOSF: PCI Express Reserved:
//   Corresponds to the PCI Express reserved header field byte bits[7,1] PCI Express
//   switches are required to forward the reserved bits unmodified.
//   For all other IOSF agents, these signals are optional.

assign trsvd0_7         = 1'b0;
assign trsvd1_1         = 1'b0;

// Get IOSF Target signals
always_comb begin
 credit_put                               = iosf_tgt_credit.credit_put;
 credit_chid                              = iosf_tgt_credit.credit_chid;
 credit_rtype                             = iosf_tgt_credit.credit_rtype;
 credit_cmd                               = iosf_tgt_credit.credit_cmd;
 credit_data                              = iosf_tgt_credit.credit_data;
end

always_comb begin
 iosf_tgt_cput.cmd_put                    = cmd_put;
 iosf_tgt_cput.cmd_chid                   = cmd_chid;
 iosf_tgt_cput.cmd_rtype                  = cmd_rtype;
 iosf_tgt_cput.cmd_nfs_err                = cmd_nfs_err;
end

always_comb begin
 iosf_tgt_cmd                             = '0;

 iosf_tgt_cmd.tfmt                        = tfmt;
 iosf_tgt_cmd.ttype                       = ttype;
 {iosf_tgt_cmd.ttc3,iosf_tgt_cmd.ttc}     = ttc;
 iosf_tgt_cmd.tep                         = tep;
 iosf_tgt_cmd.tro                         = tro;
 iosf_tgt_cmd.tns                         = tns;
 iosf_tgt_cmd.tat                         = tat;
 iosf_tgt_cmd.tlength                     = tlength[MAX_DATA_LEN:0];
 iosf_tgt_cmd.trqid                       = trqid;
 iosf_tgt_cmd.ttag                        = ttag;
 iosf_tgt_cmd.tlbe                        = tlbe;
 iosf_tgt_cmd.tfbe                        = tfbe;
 iosf_tgt_cmd.taddress                    = {{(64-(TMAX_ADDR+1)){1'b0}},
                                             int_taddress[TMAX_ADDR:0]};
 iosf_tgt_cmd.ttd                         = ttd;
 iosf_tgt_cmd.tecrc                       = tecrc;
 iosf_tgt_cmd.tecrc_generate              = tecrc_generate;
 iosf_tgt_cmd.tecrc_error                 = tecrc_error;
 iosf_tgt_cmd.trsvd1_1                    = trsvd1_1;
 iosf_tgt_cmd.trsvd1_3                    = trsvd1_3;
 iosf_tgt_cmd.trsvd1_7                    = trsvd1_7;
 iosf_tgt_cmd.trsvd0_7                    = trsvd0_7;
 iosf_tgt_cmd.tth                         = tth;
 iosf_tgt_cmd.tido                        = tido;
 iosf_tgt_cmd.tchain                      = tchain;
 iosf_tgt_cmd.tcparity                    = tcparity;
 iosf_tgt_cmd.tsai                        = tsai;
 iosf_tgt_cmd.trs                         = trs;
 iosf_tgt_cmd.tpasidtlp                   = tpasidtlp;
end

always_comb begin
 iosf_tgt_data.data                       = tdata;
 iosf_tgt_data.dparity                    = tdparity;
end

hqm_AW_unused_bits i_unused_iosf (

     .a     (|{req_chid
              ,req_priority
              ,credit_chid
              ,tsrc_id
              ,tdest_id
              ,mrsvd1_1
              ,mrsvd0_7
            })
);

//--------------------------------------------------------------------------
// IOSF <-> RI Translation
//--------------------------------------------------------------------------

hqm_iosf_tgt_xlate i_hqm_iosf_tgt_xlate (

     .prim_nonflr_clk                       (prim_nonflr_clk)               //I: TGT_XLATE
    ,.prim_gated_rst_b                      (prim_gated_rst_b)              //I: TGT_XLATE

    ,.strap_hqm_completertenbittagen        (strap_hqm_completertenbittagen)//I: TGT_XLATE

    ,.ep_iosfp_parchk_en_rl                 (~cfg_parity_ctl.SIFP_PAR_OFF)  //I: TGT_XLATE
    ,.fuse_proc_disable                     (fuse_proc_disable)             //I: TGT_XLATE

    ,.iosf_tgtq_cmddata                     (iosf_tgtq_cmddata)             //I: TGT_XLATE

    ,.lli_phdr_val                          (lli_phdr_val)                  //O: TGT_XLATE
    ,.lli_phdr                              (lli_phdr)                      //O: TGT_XLATE
    ,.lli_nphdr_val                         (lli_nphdr_val)                 //O: TGT_XLATE
    ,.lli_nphdr                             (lli_nphdr)                     //O: TGT_XLATE
    ,.lli_cplhdr_val                        (lli_cplhdr_val)                //O: TGT_XLATE
    ,.lli_cplhdr                            (lli_cplhdr)                    //O: TGT_XLATE

    ,.lli_pdata_push                        (lli_pdata_push)                //O: TGT_XLATE
    ,.lli_npdata_push                       (lli_npdata_push)               //O: TGT_XLATE
    ,.lli_cpldata_push                      (lli_cpldata_push)              //O: TGT_XLATE
    ,.lli_pkt_data                          (lli_pkt_data)                  //O: TGT_XLATE
    ,.lli_pkt_data_par                      (lli_pkt_data_par)              //O: TGT_XLATE

    ,.iosf_ep_cpar_err                      (iosf_ep_cpar_err)              //O: TGT_XLATE
    ,.iosf_ep_tecrc_err                     (iosf_ep_tecrc_err)             //O: TGT_XLATE
    ,.iosf_ep_chdr_w_err                    (iosf_ep_chdr_w_err)            //O: TGT_XLATE

    ,.iosf_tgt_crd_dec                      (iosf_tgt_crd_dec)              //O: TGT_XLATE
);

//-----------------------------------------------------------------------------------------------------

hqm_AW_unused_bits i_unused_ri (

     .a     (|{cfg_ibcpl_hdr_fifo_ctl.reserved0
              ,cfg_ibcpl_data_fifo_ctl.reserved0
            })
);

//-----------------------------------------------------------------------------------------------------
// The force_pwr_gate_pok_q must set when either of the force_ip_inaccessible or force_warm_reset
// inputs are asserted.  It must remain set until it can be captured by the sync in the pgcb_clk domain,
// so we hold it once it sets and sync the pgcb_clk domain synced version back into the prim_clk domain
// and use that as the clear.

hqm_AW_reset_sync_scan i_prim_rst_aon_b (

     .clk               (pgcb_clk)
    ,.rst_n             (prim_rst_b)
    ,.fscan_rstbypen    (fscan_rstbypen)
    ,.fscan_byprst_b    (fscan_byprst_b)
    ,.rst_n_sync        (prim_rst_aon_b)
);

assign force_pwr_gate_pok_next = (force_ip_inaccessible | force_warm_reset | force_pwr_gate_pok_q) &
                                    ~force_pwr_gate_pok_clr;

assign allow_force_pwrgate_next = force_pm_state_d3hot & pm_fsm_d3tod0_ok;

always_ff @(posedge prim_freerun_clk or negedge prim_gated_rst_b) begin
 if (~prim_gated_rst_b) begin
  force_pwr_gate_pok_q  <= '0;
  allow_force_pwrgate_q <= '0;
 end else begin
  force_pwr_gate_pok_q  <= force_pwr_gate_pok_next;
  allow_force_pwrgate_q <= allow_force_pwrgate_next;
 end
end

hqm_AW_sync_rst0 #(.WIDTH(1)) i_force_pwr_gate_pok_sync (

     .clk           (pgcb_clk)
    ,.rst_n         (prim_rst_aon_b)
    ,.data          (force_pwr_gate_pok_q)
    ,.data_sync     (force_pwr_gate_pok_sync)
);

hqm_AW_sync_rst0 #(.WIDTH(1)) i_force_pwr_gate_pok_clr (

     .clk           (prim_freerun_clk)
    ,.rst_n         (prim_gated_rst_b)
    ,.data          (force_pwr_gate_pok_sync)
    ,.data_sync     (force_pwr_gate_pok_clr)
);

// logic that takes the pwrgate_ready output and feeds it back into cdc

assign force_pwr_gate_pok_sync_edge = force_pwr_gate_pok_sync & ~force_pwr_gate_pok_sync_q;

always_ff @(posedge pgcb_clk or negedge prim_rst_aon_b) begin
 if (~prim_rst_aon_b) begin
  force_pwr_gate_pok_sync_q <= '0;
  prim_pgcb_pok             <= '0;
  prim_pwrgate_force        <= '0;
 end else begin
  force_pwr_gate_pok_sync_q <= force_pwr_gate_pok_sync;
  prim_pgcb_pok             <= ~prim_pwrgate_ready;
  prim_pwrgate_force        <= (force_pwr_gate_pok_sync_edge | prim_pwrgate_force) & prim_pgcb_pok;
 end
end

hqm_AW_sync_rst0 #(.WIDTH(1)) i_prim_allow_force_pwrgate_sync (

     .clk           (pgcb_clk)
    ,.rst_n         (prim_rst_aon_b)
    ,.data          (allow_force_pwrgate_q)
    ,.data_sync     (prim_allow_force_pwrgate_sync)
);

assign prim_pwrgate_force_in    = prim_pwrgate_force & prim_allow_force_pwrgate_sync;

assign prim_pgcb_pwrgate_active = ~prim_pgcb_pok | prim_pwrgate_ready;

// Only allow the synchronized wake signals to be seen by the CDCs once the resets have been deasserted

hqm_AW_sync_rst0 #(.WIDTH(1)) i_prim_pwrgate_pmc_wake_sync (

     .clk           (pgcb_clk)
    ,.rst_n         (prim_rst_aon_b)
    ,.data          (prim_pwrgate_pmc_wake)
    ,.data_sync     (prim_pwrgate_pmc_wake_sync)
);

//-----------------------------------------------------------------------------------------------------
// IOSF Primary Clock CDC

assign prim_clkreq_sync = '0;

hqm_ClockDomainController #(

     .DEF_PWRON         (DEF_PWRON)     // Default to a powered-on state after reset
    ,.ITBITS            (16)            // Idle Timer Bits.  Max is 16
    ,.RST               (2)             // Number of resets.  Min is one.
    ,.AREQ              (2)             // Number of async gclock requests.  Min is one.
    ,.DRIVE_POK         (1)             // Determines whether this domain must drive POK
    ,.ISM_AGT_IS_NS     (0)             // If 1, *_locked signals will be driven as the output of a flop
                                        // If 0, *_locked signals will assert combinatorially
    ,.RSTR_B4_FORCE     (0)             // Determines if this CDC will require restore phase to complete
                                        // in order to transition from IP-Accessible to IP-Inaccessible PG
    ,.PRESCC            (0)             // If 1, The master_clock gate logic with have clkgenctrl muxes for scan to have control
                                        //       of the master_clock branch in order to be used preSCC
                                        //       NOTE: FLOP_CG_EN and DSYNC_CG_EN are a dont care when PRESCC=1
    ,.DSYNC_CG_EN       (0)             // If 1, the master_clock-gate enable will be synchronized to the short master_clock-tree version
                                        //       of master_clock to allow for STA convergence on fast clocks ( >120 MHz )
                                        //       Note: FLOP_CG_EN is a don't care when DSYNC_CG_EN=1
    ,.FLOP_CG_EN        (1)             // If 1, the clock-gate enable will be driven solely by the output of a flop
                                        // If 0, there will be a combi path into the cg enable to allow for faster ungating
    ,.CG_LOCK_ISM       (0)             // if set to 1, ism_locked signal is asserted whenever gclock_active is low

) i_prim_cdc (

     // PGCB ClockDomain

     .pgcb_clk                      (pgcb_clk)                                  //I: PRIM_CDC: PGCB clock; always running
    ,.pgcb_rst_b                    (prim_rst_aon_b)                            //I: PRIM_CDC: Reset with de-assert synchronized to pgcb_clk

    // Master Clock Domain

    ,.clock                         (prim_freerun_clk)                          //I: PRIM_CDC: Master clock
    ,.prescc_clock                  (1'b0)                                      //I: PRIM_CDC: Tie to 0 if PRESCC param is 0
    ,.reset_b                       ({side_rst_b                                //I: PRIM_CDC: Asynchronous ungated reset.  reset_b[0] must be deepest
                                     ,prim_rst_b                                //   reset for the domain.
                                    })
    ,.reset_sync_b                  ({side_rst_sync_prim_b_nc                   //O: PRIM_CDC: Version of reset_b with de-assertion synchronized to clock
                                     ,prim_rst_sync_b_nc
                                    })
    ,.clkreq                        (prim_clkreq)                               //O: PRIM_CDC: Async (glitch free) clock request to disable
    ,.clkack                        (prim_clkack)                               //I: PRIM_CDC: Async (glitch free) clock request acknowledge
    ,.pok_reset_b                   (prim_rst_b)                                //I: PRIM_CDC: Asynchronous reset for POK
    ,.pok                           (prim_pok)                                  //O: PRIM_CDC: Power ok indication, synchronous

    ,.gclock_enable_final           (prim_clk_enable_cdc)                       //O: PRIM_CDC: Final enable signal to clock-gate

    // Gated Clock Domain

    ,.gclock                        (prim_gclock_nc)                            //O: PRIM_CDC: Gated version of the clock
    ,.greset_b                      ({side_gated_rst_prim_b                     //O: PRIM_CDC: Gated version of reset_sync_b
                                     ,prim_gated_rst_b
                                    })
    ,.gclock_req_sync               (prim_clkreq_sync)                          //I: PRIM_CDC: Synchronous gclock request.
    ,.gclock_req_async              (prim_clkreq_async[1:0])                    //I: PRIM_CDC: Async (glitch free) gclock requests
    ,.gclock_ack_async              (prim_clkack_async[1:0])                    //O: PRIM_CDC: Clock req ack for each gclock_req_async in this CDC's domain.
    ,.gclock_active                 (prim_clk_active_nc)                        //O: PRIM_CDC: Indication that gclock is running.
    ,.ism_fabric                    (prim_ism_fabric[2:0])                      //I: PRIM_CDC: IOSF Fabric ISM.  Tie to zero for non-IOSF domains.
    ,.ism_agent                     (prim_ism_agent[2:0])                       //I: PRIM_CDC: IOSF Agent ISM.  Tie to zero for non-IOSF domains.
    ,.ism_locked                    (prim_ism_locked)                           //O: PRIM_CDC: Indicates that the ISMs for this domain should be locked
    ,.boundary_locked               (prim_boundary_locked_nc)                   //O: PRIM_CDC: Indicates that all non IOSF accesses should be locked out

    // Configuration - Quasi-static

    ,.cfg_clkgate_disabled          (cfg_prim_cdc_ctl.CLKGATE_DISABLED)         //I: PRIM_CDC: Don't allow idle-based clock gating
    ,.cfg_clkreq_ctl_disabled       (cfg_prim_cdc_ctl.CLKREQ_CTL_DISABLED)      //I: PRIM_CDC: Don't allow de-assertion of clkreq when idle
    ,.cfg_clkgate_holdoff           (cfg_prim_cdc_ctl.CLKGATE_HOLDOFF)          //I: PRIM_CDC: Min time from idle to clock gating; 2^value in clocks
    ,.cfg_pwrgate_holdoff           (cfg_prim_cdc_ctl.PWRGATE_HOLDOFF)          //I: PRIM_CDC: Min time from clock gate to power gate ready; 2^value in clocks
    ,.cfg_clkreq_off_holdoff        (cfg_prim_cdc_ctl.CLKREQ_OFF_HOLDOFF)       //I: PRIM_CDC: Min time from locking to !clkreq; 2^value in clocks
    ,.cfg_clkreq_syncoff_holdoff    (cfg_prim_cdc_ctl.CLKREQ_SYNCOFF_HOLDOFF)   //I: PRIM_CDC: Min time from ck gate to !clkreq (powerGateDisabled)

    // CDC Aggregateion and Control (synchronous to pgcb_clk domain)

    ,.pwrgate_disabled              (1'd1)                                      //I: PRIM_CDC: Don't allow idle-based clock gating; PGCB clock
    ,.pwrgate_force                 (prim_pwrgate_force_in)                     //I: PRIM_CDC: Force the controller to gate clocks and lock up
    ,.pwrgate_pmc_wake              (prim_pwrgate_pmc_wake_sync)                //I: PRIM_CDC: PMC wake signal (after sync); PGCB clock domain
    ,.pwrgate_ready                 (prim_pwrgate_ready)                        //O: PRIM_CDC: Allow power gating in the PGCB clock domain.  Can de-assert
                                                                                //   even if never power gated if new wake event occurs.

    // PGCB Controls (synchronous to pgcb_clk domain)

    ,.pgcb_force_rst_b              (1'd1)                                      //I: PRIM_CDC: Force for resets to assert
    ,.pgcb_pok                      (prim_pgcb_pok)                             //I: PRIM_CDC: Power OK signal in the PGCB clock domain
    ,.pgcb_restore                  (1'd0)                                      //I: PRIM_CDC: A restore is in pregress so  ISMs should unlock
    ,.pgcb_pwrgate_active           (prim_pgcb_pwrgate_active)                  //I: PRIM_CDC: Pwr gating in progress, so keep boundary locked

    // Test Controls

    ,.fscan_clkungate               (fscan_clkungate)                           //I: PRIM_CDC: Test clock ungating control
    ,.fscan_byprst_b                ({4{fscan_byprst_b}})                       //I: PRIM_CDC: Scan reset bypass value
    ,.fscan_rstbypen                ({4{fscan_rstbypen}})                       //I: PRIM_CDC: Scan reset bypass enable
    ,.fscan_clkgenctrlen            ('0)                                        //I: PRIM_CDC: Scan clock bypass enable (unused)
    ,.fscan_clkgenctrl              ('0)                                        //I: PRIM_CDC: Scan clock bypass value  (unused)

    ,.fismdfx_force_clkreq          (cdc_prim_jta_force_clkreq)                 //I: PRIM_CDC: DFx force assert clkreq
    ,.fismdfx_clkgate_ovrd          (cdc_prim_jta_clkgate_ovrd)                 //I: PRIM_CDC: DFx force GATE gclock

    // CDC VISA Signals

    ,.cdc_visa                      (cdc_visa_nc)                               //O: PRIM_CDC: Set of internal signals for VISA visibility
);

assign prim_ism_lock_b = ~prim_ism_locked;

// Sync the safemode signal from the PMA and use it to disable all clock gating
// Purposely not reset

hqm_AW_sync i_pma_safemode_sync (

     .clk           (prim_freerun_clk)
    ,.data          (pma_safemode)
    ,.data_sync     (pma_safemode_sync)
);

assign prim_clk_enable     = prim_clk_enable_cdc & flr_clk_enable;
assign prim_clk_enable_sys = prim_clk_enable_cdc & flr_clk_enable_system;
assign prim_clk_ungate     = (cfg_prim_cdc_ctl.CLKGATE_DISABLED | pma_safemode_sync) & flr_clk_enable;

hqm_AW_unused_bits i_unused_prim_cdc (

     .a     (|{side_rst_sync_prim_b_nc
              ,prim_rst_sync_b_nc
              ,prim_boundary_locked_nc
              ,prim_clk_active_nc
              ,prim_gclock_nc
              ,cdc_visa_nc
            })
);

//-----------------------------------------------------------------------------------------------------
// PG logic needs the fabric ism signal to be masked by the lock

assign prim_ism_fabric_pgmask = (prim_ism_lock_b) ? prim_ism_fabric : '0;

hqm_iosf_gcgu i_hqm_iosf_gcgu (

    // Inputs

     .prim_freerun_clk                        (prim_freerun_clk)
    ,.prim_gated_rst_b                        (prim_gated_rst_b)
    ,.prim_nonflr_clk                         (prim_nonflr_clk)

    ,.prim_pok                                (prim_pok)
    ,.prim_ism_lock_b                         (prim_ism_lock_b)

    ,.flr_treatment                           (flr_treatment)

    ,.csr_clkgaten                            (iosfp_cgctl.CLKGATE_ENABLE)
    ,.csr_idlecnt                             (iosfp_cgctl.IDLE_COUNT)

    ,.ism_fabric                              (prim_ism_fabric_pgmask[2:0])
    ,.prim_clkack                             (prim_clkack_async[0])
    ,.agent_idle                              (agent_idle)

    ,.agent_clkreq                            (agent_clkreq)
    ,.agent_clkreq_async                      (agent_clkreq_async)

    ,.credit_init_done                        (credit_init_done)
    ,.tgt_has_unret_credits                   (tgt_has_unret_credits)

    ,.force_notidle                           (prim_jta_force_notidle)
    ,.force_idle                              (prim_jta_force_idle)
    ,.force_clkreq                            (prim_jta_force_clkreq)
    ,.force_creditreq                         (prim_jta_force_creditreq)

    ,.dfx_scanrstbypen                        (fscan_rstbypen)
    ,.dfx_scanrst_b                           (fscan_byprst_b)

    // Outputs

    ,.ism_agent                               (prim_ism_agent[2:0])
    ,.prim_clkreq                             (prim_clkreq_async[0])
    ,.credit_init                             (credit_init)
);

assign prim_clkreq_async[1]  = prim_clkreq_async_sbe;

assign prim_clkack_async_sbe = prim_clkack_async[1];

//-----------------------------------------------------------------------------------------------------

// This goes to the hqm_master and will send a pulse on a rising edge of flr_cpl_sent

always_ff @(posedge prim_freerun_clk or negedge prim_gated_rst_b) begin
 if (~prim_gated_rst_b) begin
  flr_cpl_sent_q <= '0;
 end else begin
  flr_cpl_sent_q <= flr_cpl_sent;
 end
end

assign flr_triggered = flr_cpl_sent & ~flr_cpl_sent_q;

//-----------------------------------------------------------------------------------------------------
// These are purposely not reset

hqm_AW_sync i_prim_rst_b_synced (

     .clk           (prim_freerun_clk)
    ,.data          (prim_rst_b)
    ,.data_sync     (prim_rst_b_synced)
);

hqm_AW_sync i_prim_gated_rst_b_synced (

     .clk           (prim_freerun_clk)
    ,.data          (prim_gated_rst_b)
    ,.data_sync     (prim_gated_rst_b_synced)
);

hqm_AW_sync i_prim_clkreq_synced (

     .clk           (prim_freerun_clk)
    ,.data          (prim_clkreq)
    ,.data_sync     (prim_clkreq_synced)
);

hqm_AW_sync i_prim_clkack_synced (

     .clk           (prim_freerun_clk)
    ,.data          (prim_clkack)
    ,.data_sync     (prim_clkack_synced)
);

always_ff @(posedge prim_gated_clk or negedge prim_gated_wflr_rst_b_primary) begin
 if (~prim_gated_wflr_rst_b_primary) begin
  hqm_idle_q <= '0;
 end else begin
  hqm_idle_q <= hqm_idle;
 end
end

assign flr_visa[19] = flr_cpl_sent;
assign flr_visa[18] = flr_triggered_wl;
assign flr_visa[17] = flr_clk_enable;
assign flr_visa[16] = flr_clk_enable_system;
assign flr_visa[15] = prim_clk_enable_cdc;
assign flr_visa[14] = flr_triggered;
assign flr_visa[13:0] = flr_visa_ri;

//TBD: Adjust visa signals

hqm_sif_probes i_hqm_sif_probes (

     .clk                   (prim_freerun_clk)                                      //I: VISA
    ,.hqm_sif_visa_in       ({flr_visa[19:0]                                        //I: VISA 679:660

                             ,cfg_visa_sw_control.SW_TRIGGER                        //I: VISA 659
                             ,prim_gated_rst_b_synced                               //I: VISA 658
                             ,prim_clk_enable                                       //I: VISA 657
                             ,prim_clk_enable_sys                                   //I: VISA 656

                             ,prim_clkreq_synced                                    //I: VISA 655
                             ,prim_clkack_synced                                    //I: VISA 654
                             ,hqm_idle_q                                            //I: VISA 653
                             ,sif_idle_status_reg.MSTR_IDLE                         //I: VISA 652
                             ,sif_idle_status_reg.MSTR_INTF_IDLE                    //I: VISA 651
                             ,sif_idle_status_reg.TGT_IDLE                          //I: VISA 650
                             ,sif_idle_status_reg.RI_IDLE                           //I: VISA 649
                             ,sif_idle_status_reg.CFGM_IDLE                         //I: VISA 648

                             ,noa_tgt                                               //I: VISA 647:616
                             ,noa_mstr                                              //I: VISA 615:424
                             ,noa_ri                                                //I: VISA 423:167
                             ,167'd0                                                //I: VISA 166:0
                            })
    ,.hqm_sif_visa_out      (hqm_sif_visa)                                          //O: VISA
);

assign hqm_triggers = {cfg_visa_sw_control.SW_TRIGGER               // 9
                      ,ph_trigger                                   // 8
                      ,hqm_idle_q                                   // 7
                      ,prim_gated_rst_b_synced                      // 6
                      ,prim_rst_b_synced                            // 5
                      ,prim_clk_enable                              // 4
                      ,( prim_clkreq_synced &  prim_clkack_synced)  // 3
                      ,(~prim_clkreq_synced & ~prim_clkack_synced)  // 2
                      ,prim_clkack_synced                           // 1
                      ,prim_clkreq_synced                           // 0
} & ~{10{cfg_visa_sw_control.TRIGGER_MASK}};

assign cfg_ph_trigger_enable = cfg_visa_sw_control.PH_TRIGGER_ENABLE;

assign sif_db_status.CPL_REQ_DB_READY  = cpl_req_db_status[2];
assign sif_db_status.CPL_REQ_DB_DEPTH  = cpl_req_db_status[1:0];
assign sif_db_status.NP_REQ_DB_READY   = np_req_db_status[2];
assign sif_db_status.NP_REQ_DB_DEPTH   = np_req_db_status[1:0];
assign sif_db_status.P_REQ_DB_READY    = p_req_db_status[2];
assign sif_db_status.P_REQ_DB_DEPTH    = p_req_db_status[1:0];
assign sif_db_status.ALARM_DB_READY    = int_serial_status[9];
assign sif_db_status.ALARM_DB_DEPTH    = int_serial_status[8:7];

hqm_AW_unused_bits i_unused_alarm (

     .a     (|{int_serial_status[31:14]
              ,int_serial_status[12]
              ,int_serial_status[6:0]
              ,p_req_db_status[3]
              ,np_req_db_status[3]
              ,cpl_req_db_status[3]
            })
);

//-----------------------------------------------------------------------------------------------------
// IOSF Master

assign cfg_ibcpl_hdr_fifo_high_wm  = cfg_ibcpl_hdr_fifo_ctl.HIGH_WM;
assign cfg_ibcpl_data_fifo_high_wm = cfg_ibcpl_data_fifo_ctl.HIGH_WM;

assign write_buffer_mstr_v_qual    = write_buffer_mstr_v & ~mask_posted;

hqm_iosf_mstr i_hqm_iosf_mstr (

     .prim_nonflr_clk                           (prim_nonflr_clk)               //I: IOSF_MSTR
    ,.prim_gated_rst_b                          (prim_gated_rst_b)              //I: IOSF_MSTR
    ,.prim_gated_wflr_rst_b                     (prim_gated_wflr_rst_b_primary) //I: IOSF_MSTR

    ,.hqm_csr_pf0_rst_n                         (hqm_csr_pf0_rst_n)             //I: IOSF_MSTR

    ,.strap_hqm_tx_sai                          (strap_hqm_tx_sai)              //I: IOSF_MSTR
    ,.strap_hqm_cmpl_sai                        (strap_hqm_cmpl_sai)            //I: IOSF_MSTR
    ,.strap_hqm_completertenbittagen            (strap_hqm_completertenbittagen)//I: IOSF_MSTR

    ,.current_bus                               (current_bus)                   //I: IOSF_MSTR

    ,.cfg_ats_enabled                           (cfg_ats_enabled)               //I: IOSF_MSTR
    ,.cfg_mstr_par_off                          (cfg_parity_ctl.MSTR_PAR_OFF)   //I: IOSF_MSTR
    ,.cfg_scrbd_ctl                             (cfg_scrbd_ctl)                 //I: IOSF_MSTR
    ,.cfg_mstr_ll_ctl                           (cfg_mstr_ll_ctl)               //I: IOSF_MSTR
    ,.cfg_devtlb_ctl                            (cfg_devtlb_ctl)                //I: IOSF_MSTR
    ,.cfg_devtlb_spare                          (cfg_devtlb_spare)              //I: IOSF_MSTR
    ,.cfg_devtlb_defeature0                     (cfg_devtlb_defeature0)         //I: IOSF_MSTR
    ,.cfg_devtlb_defeature1                     (cfg_devtlb_defeature1)         //I: IOSF_MSTR
    ,.cfg_devtlb_defeature2                     (cfg_devtlb_defeature2)         //I: IOSF_MSTR

    ,.cfg_ph_trigger_enable                     (cfg_ph_trigger_enable)         //I: IOSF_MSTR
    ,.cfg_ph_trigger_addr                       (cfg_ph_trigger_addr)           //I: IOSF_MSTR
    ,.cfg_ph_trigger_mask                       (cfg_ph_trigger_mask)           //I: IOSF_MSTR

    ,.hqm_sif_cnt_ctl                           (hqm_sif_cnt_ctl)               //I: IOSF_MSTR

    ,.dir_cq2tc_map                             (dir_cq2tc_map)                 //I: IOSF_MSTR
    ,.ldb_cq2tc_map                             (ldb_cq2tc_map)                 //I: IOSF_MSTR
    ,.int2tc_map                                (int2tc_map)                    //I: IOSF_MSTR

    ,.csr_ppdcntl_ero                           (csr_ppdcntl_ero)               //I: IOSF_MSTR

    ,.cfg_ibcpl_hdr_fifo_high_wm                (cfg_ibcpl_hdr_fifo_high_wm)    //I: IOSF_MSTR
    ,.cfg_ibcpl_data_fifo_high_wm               (cfg_ibcpl_data_fifo_high_wm)   //I: IOSF_MSTR

    ,.cfg_ibcpl_hdr_fifo_status                 (cfg_ibcpl_hdr_fifo_status)     //O: IOSF_MSTR
    ,.cfg_ibcpl_data_fifo_status                (cfg_ibcpl_data_fifo_status)    //O: IOSF_MSTR
    ,.cfg_p_rl_cq_fifo_status                   (cfg_p_rl_cq_fifo_status)       //O: IOSF_MSTR

    ,.p_req_db_status                           (p_req_db_status)               //O: IOSF_MSTR
    ,.np_req_db_status                          (np_req_db_status)              //O: IOSF_MSTR
    ,.cpl_req_db_status                         (cpl_req_db_status)             //O: IOSF_MSTR

    ,.devtlb_status                             (devtlb_status)                 //O: IOSF_MSTR
    ,.scrbd_status                              (scrbd_status)                  //O: IOSF_MSTR
    ,.mstr_crd_status                           (mstr_crd_status)               //O: IOSF_MSTR
    ,.mstr_fl_status                            (mstr_fl_status)                //O: IOSF_MSTR
    ,.mstr_ll_status                            (mstr_ll_status)                //O: IOSF_MSTR

    ,.local_bme_status                          (local_bme_status)              //O: IOSF_MSTR
    ,.local_msixe_status                        (local_msixe_status)            //O: IOSF_MSTR

    ,.write_buffer_mstr_ready                   (write_buffer_mstr_ready)       //O: IOSF_MSTR

    ,.write_buffer_mstr_v                       (write_buffer_mstr_v_qual)      //I: IOSF_MSTR
    ,.write_buffer_mstr                         (write_buffer_mstr)             //I: IOSF_MSTR

    ,.obcpl_ready                               (obcpl_ready)                   //O: IOSF_MSTR

    ,.obcpl_v                                   (obcpl_v)                       //I: IOSF_MSTR
    ,.obcpl_hdr                                 (obcpl_hdr)                     //I: IOSF_MSTR
    ,.obcpl_data                                (obcpl_data)                    //I: IOSF_MSTR
    ,.obcpl_dpar                                (obcpl_dpar)                    //I: IOSF_MSTR
    ,.obcpl_enables                             (obcpl_enables)                 //I: IOSF_MSTR

    ,.gpsb_upd_enables                          (gpsb_upd_enables)              //I: IOSF_MSTR

    ,.ibcpl_hdr_push                            (lli_cplhdr_val)                //I: IOSF_MSTR
    ,.ibcpl_hdr                                 (lli_cplhdr)                    //I: IOSF_MSTR

    ,.ibcpl_data_push                           (lli_cpldata_push)              //I: IOSF_MSTR
    ,.ibcpl_data                                (lli_pkt_data[63:0])            //I: IOSF_MSTR
    ,.ibcpl_data_par                            (lli_pkt_data_par[1:0])         //I: IOSF_MSTR

    ,.rx_msg_v                                  (rx_msg_v)                      //I: IOSF_MSTR
    ,.rx_msg                                    (rx_msg)                        //I: IOSF_MSTR

    ,.prim_ism_agent                            (prim_ism_agent[2:0])           //I: IOSF_MSTR

    ,.iosf_req                                  (iosf_req)                      //O: IOSF_MSTR
    ,.iosf_gnt                                  (iosf_gnt)                      //I: IOSF_MSTR
    ,.iosf_cmd                                  (iosf_cmd)                      //O: IOSF_MSTR
    ,.iosf_data                                 (mdata[MD_WIDTH:0])             //O: IOSF_MSTR
    ,.iosf_parity                               (mdparity_out)                  //O: IOSF_MSTR

    ,.func_in_rst                               (func_in_rst)                   //I: IOSF_MSTR

    ,.flr_treatment_vec                         (flr_treatment_vec)             //I: IOSF_MSTR
    ,.flr_txn_sent                              (flr_txn_sent)                  //I: IOSF_MSTR
    ,.flr_txn_tag                               (flr_txn_tag)                   //I: IOSF_MSTR
    ,.flr_txn_reqid                             (flr_txn_reqid)                 //I: IOSF_MSTR

    ,.flr_cpl_sent                              (flr_cpl_sent)                  //O: IOSF_MSTR

    ,.ps_txn_sent                               (ps_txn_sent)                   //I: IOSF_MSTR
    ,.ps_txn_tag                                (ps_txn_tag)                    //I: IOSF_MSTR
    ,.ps_txn_reqid                              (ps_txn_reqid)                  //I: IOSF_MSTR

    ,.sif_mstr_quiesce_req                      (sif_mstr_quiesce_req)          //I: IOSF_MSTR

    ,.sif_mstr_quiesce_ack                      (sif_mstr_quiesce_ack)          //O: IOSF_MSTR

    ,.mstr_idle                                 (mstr_idle)                     //O: IOSF_MSTR
    ,.mstr_intf_idle                            (mstr_intf_idle)                //O: IOSF_MSTR

    ,.np_trans_pending                          (np_trans_pending)              //O: IOSF_MSTR

    ,.poisoned_wr_sent                          (poisoned_wr_sent)              //O: IOSF_MSTR

    ,.cpl_usr                                   (cpl_usr)                       //O: IOSF_MSTR
    ,.cpl_abort                                 (cpl_abort)                     //O: IOSF_MSTR
    ,.cpl_poisoned                              (cpl_poisoned)                  //O: IOSF_MSTR
    ,.cpl_unexpected                            (cpl_unexpected)                //O: IOSF_MSTR
    ,.cpl_error_hdr                             (cpl_error_hdr)                 //O: IOSF_MSTR

    ,.cpl_timeout                               (cpl_timeout)                   //O: IOSF_MSTR
    ,.cpl_timeout_synd                          (cpl_timeout_synd)              //O: IOSF_MSTR

    ,.sif_parity_alarm                          (sif_parity_alarm)              //O: IOSF_MSTR
    ,.set_sif_parity_err                        (set_sif_parity_err_mstr)       //O: IOSF_MSTR

    ,.devtlb_ats_alarm                          (devtlb_ats_alarm)              //O: IOSF_MSTR
    ,.set_devtlb_ats_err                        (set_devtlb_ats_err)            //O: IOSF_MSTR

    ,.mstr_cnts                                 (mstr_cnts)                     //O: IOSF_MSTR

    ,.ph_trigger                                (ph_trigger)                    //O: IOSF_MSTR

    ,.sif_mstr_debug                            (sif_mstr_debug)                //O: IOSF_MSTR
    ,.noa_mstr                                  (noa_mstr)                      //O: IOSF_MSTR

    ,.fscan_byprst_b                            (fscan_byprst_b)                //I: IOSF_MSTR
    ,.fscan_clkungate                           (fscan_clkungate)               //I: IOSF_MSTR
    ,.fscan_clkungate_syn                       (fscan_clkungate_syn)           //I: IOSF_MSTR
    ,.fscan_latchclosed_b                       (fscan_latchclosed_b)           //I: IOSF_MSTR
    ,.fscan_latchopen                           (fscan_latchopen)               //I: IOSF_MSTR
    ,.fscan_mode                                (fscan_mode)                    //I: IOSF_MSTR
    ,.fscan_rstbypen                            (fscan_rstbypen)                //I: IOSF_MSTR
    ,.fscan_shiften                             (fscan_shiften)                 //I: IOSF_MSTR

    ,.memi_scrbd_mem                            (memi_scrbd_mem)                //I: IOSF_MSTR
    ,.memo_scrbd_mem                            (memo_scrbd_mem)                //O: IOSF_MSTR

    ,.memi_ibcpl_hdr_fifo                       (memi_ibcpl_hdr_fifo)           //I: IOSF_MSTR
    ,.memo_ibcpl_hdr_fifo                       (memo_ibcpl_hdr_fifo)           //O: IOSF_MSTR

    ,.memi_ibcpl_data_fifo                      (memi_ibcpl_data_fifo)          //I: IOSF_MSTR
    ,.memo_ibcpl_data_fifo                      (memo_ibcpl_data_fifo)          //O: IOSF_MSTR

    ,.memi_mstr_ll_hpa                          (memi_mstr_ll_hpa)              //I: IOSF_MSTR
    ,.memo_mstr_ll_hpa                          (memo_mstr_ll_hpa)              //O: IOSF_MSTR

    ,.memi_mstr_ll_hdr                          (memi_mstr_ll_hdr)              //I: IOSF_MSTR
    ,.memo_mstr_ll_hdr                          (memo_mstr_ll_hdr)              //O: IOSF_MSTR

    ,.memi_mstr_ll_data0                        (memi_mstr_ll_data0)            //I: IOSF_MSTR
    ,.memo_mstr_ll_data0                        (memo_mstr_ll_data0)            //O: IOSF_MSTR

    ,.memi_mstr_ll_data1                        (memi_mstr_ll_data1)            //I: IOSF_MSTR
    ,.memo_mstr_ll_data1                        (memo_mstr_ll_data1)            //O: IOSF_MSTR

    ,.memi_mstr_ll_data2                        (memi_mstr_ll_data2)            //I: IOSF_MSTR
    ,.memo_mstr_ll_data2                        (memo_mstr_ll_data2)            //O: IOSF_MSTR

    ,.memi_mstr_ll_data3                        (memi_mstr_ll_data3)            //I: IOSF_MSTR
    ,.memo_mstr_ll_data3                        (memo_mstr_ll_data3)            //O: IOSF_MSTR

    ,.memi_tlb_tag0_4k                          (memi_tlb_tag0_4k)              //I: IOSF_MSTR
    ,.memo_tlb_tag0_4k                          (memo_tlb_tag0_4k)              //O: IOSF_MSTR
    ,.memi_tlb_tag1_4k                          (memi_tlb_tag1_4k)              //I: IOSF_MSTR
    ,.memo_tlb_tag1_4k                          (memo_tlb_tag1_4k)              //O: IOSF_MSTR
    ,.memi_tlb_tag2_4k                          (memi_tlb_tag2_4k)              //I: IOSF_MSTR
    ,.memo_tlb_tag2_4k                          (memo_tlb_tag2_4k)              //O: IOSF_MSTR
    ,.memi_tlb_tag3_4k                          (memi_tlb_tag3_4k)              //I: IOSF_MSTR
    ,.memo_tlb_tag3_4k                          (memo_tlb_tag3_4k)              //O: IOSF_MSTR
    ,.memi_tlb_tag4_4k                          (memi_tlb_tag4_4k)              //I: IOSF_MSTR
    ,.memo_tlb_tag4_4k                          (memo_tlb_tag4_4k)              //O: IOSF_MSTR
    ,.memi_tlb_tag5_4k                          (memi_tlb_tag5_4k)              //I: IOSF_MSTR
    ,.memo_tlb_tag5_4k                          (memo_tlb_tag5_4k)              //O: IOSF_MSTR
    ,.memi_tlb_tag6_4k                          (memi_tlb_tag6_4k)              //I: IOSF_MSTR
    ,.memo_tlb_tag6_4k                          (memo_tlb_tag6_4k)              //O: IOSF_MSTR
    ,.memi_tlb_tag7_4k                          (memi_tlb_tag7_4k)              //I: IOSF_MSTR
    ,.memo_tlb_tag7_4k                          (memo_tlb_tag7_4k)              //O: IOSF_MSTR

    ,.memi_tlb_data0_4k                         (memi_tlb_data0_4k)             //I: IOSF_MSTR
    ,.memo_tlb_data0_4k                         (memo_tlb_data0_4k)             //O: IOSF_MSTR
    ,.memi_tlb_data1_4k                         (memi_tlb_data1_4k)             //I: IOSF_MSTR
    ,.memo_tlb_data1_4k                         (memo_tlb_data1_4k)             //O: IOSF_MSTR
    ,.memi_tlb_data2_4k                         (memi_tlb_data2_4k)             //I: IOSF_MSTR
    ,.memo_tlb_data2_4k                         (memo_tlb_data2_4k)             //O: IOSF_MSTR
    ,.memi_tlb_data3_4k                         (memi_tlb_data3_4k)             //I: IOSF_MSTR
    ,.memo_tlb_data3_4k                         (memo_tlb_data3_4k)             //O: IOSF_MSTR
    ,.memi_tlb_data4_4k                         (memi_tlb_data4_4k)             //I: IOSF_MSTR
    ,.memo_tlb_data4_4k                         (memo_tlb_data4_4k)             //O: IOSF_MSTR
    ,.memi_tlb_data5_4k                         (memi_tlb_data5_4k)             //I: IOSF_MSTR
    ,.memo_tlb_data5_4k                         (memo_tlb_data5_4k)             //O: IOSF_MSTR
    ,.memi_tlb_data6_4k                         (memi_tlb_data6_4k)             //I: IOSF_MSTR
    ,.memo_tlb_data6_4k                         (memo_tlb_data6_4k)             //O: IOSF_MSTR
    ,.memi_tlb_data7_4k                         (memi_tlb_data7_4k)             //I: IOSF_MSTR
    ,.memo_tlb_data7_4k                         (memo_tlb_data7_4k)             //O: IOSF_MSTR
);

assign cpl_error = cpl_usr | cpl_abort;

assign mstr_fifo_overflow  = |{
                                cfg_p_rl_cq_fifo_status.OVRFLOW
                               ,cfg_ibcpl_data_fifo_status.OVRFLOW
                               ,cfg_ibcpl_hdr_fifo_status.OVRFLOW
};

assign mstr_fifo_underflow = |{
                                cfg_p_rl_cq_fifo_status.UNDFLOW
                               ,cfg_ibcpl_data_fifo_status.UNDFLOW
                               ,cfg_ibcpl_hdr_fifo_status.UNDFLOW
};

assign mstr_fifo_afull     = {
                                cfg_p_rl_cq_fifo_status.AFULL
                               ,cfg_ibcpl_data_fifo_status.AFULL
                               ,cfg_ibcpl_hdr_fifo_status.AFULL
};

assign mstr_db_status_in_stalled  = {
                                     cpl_req_db_status[6]
                                    ,np_req_db_status[6]
                                    ,p_req_db_status[6]
};

assign mstr_db_status_in_taken    = {
                                     cpl_req_db_status[5]
                                    ,np_req_db_status[5]
                                    ,p_req_db_status[5]
};

assign mstr_db_status_out_stalled = {
                                     cpl_req_db_status[4]
                                    ,np_req_db_status[4]
                                    ,p_req_db_status[4]
};

///////////////////////////////////////////////////////////////////////////
// Assertions
///////////////////////////////////////////////////////////////////////////

`ifndef INTEL_SVA_OFF

logic  cmd_parity_off;

initial begin
 cmd_parity_off=1'b0;
 if ($test$plusargs("HQM_COMMAND_PARITY_CHECK")) cmd_parity_off=1'b1;
end

TGT_CMD_PARITY_WRONG: assert property (@(posedge prim_freerun_clk) disable iff (~prim_gated_rst_b | cmd_parity_off)
  (cfg_parity_ctl.SIFP_PAR_OFF | (tcparity == ^({tfmt,
                                                 ttype,
                                                 ttc,
                                                 //ttc3, ttc has this bit in it see code above
                                                 tep,
                                                 tro,
                                                 tns,
                                                 tat,
                                                 tlength,
                                                 trqid,
                                                 ttag,
                                                 tlbe,
                                                 tfbe,
                                                 taddress,
                                                 ttd,
                                                 tth,
                                                 tecrc_generate,
                                                 tecrc_error,
                                                 trsvd1_1,
                                                 trsvd1_3,
                                                 trsvd1_7,
                                                 trsvd0_7,
                                                 tido,
                                                 tpasidtlp,
                                                 trs
                                                 })))) else
  $error ("Error: Tgt cmd parity is not correct. See IOSF spec 1.1 page 103 rule 7")                  ;

MSTR_CMD_PARITY_WRONG: assert property (@(posedge prim_freerun_clk) disable iff (~prim_gated_rst_b | cmd_parity_off)
  (cfg_parity_ctl.SIFP_PAR_OFF | (mcparity == ^({mfmt,
                                                 mtype,
                                                 mtc,
                                                 //mtc3, mtc has this bit in it see code above
                                                 mep,
                                                 mro,
                                                 mns,
                                                 mat,
                                                 mlength,
                                                 mrqid,
                                                 mtag,
                                                 mlbe,
                                                 mfbe,
                                                 maddress,
                                                 mtd,
                                                 mth,
                                                 mrsvd1_1,
                                                 mrsvd1_3,
                                                 mrsvd1_7,
                                                 mrsvd0_7,
                                                 mido,
                                                 mpasidtlp,
                                                 mrs
                                                 })))) else
  $error ("Error: Mstr cmd parity is not correct. See IOSF spec 1.1 page 103 rule 7")                 ;

///////////////////////////////////////////////////////////////////////////
// Coverage
///////////////////////////////////////////////////////////////////////////

// MPS 512 Completions with payload greater than 256B, 64DW must be seen
MPS_CPL_LEN_IS_GREATER_THEN_256B:
  cover property (@(posedge prim_freerun_clk) disable iff (~prim_gated_rst_b)
    (i_hqm_iosf_tgt_xlate.lli_cplhdr.length > 'd64))                                                  ;

// Error condition send a Posted Write with length greater than 8 bytes, ideally greater then 256B
MPS_MWR_LEN_IS_GREATER_THEN_256B:
  cover property (@(posedge prim_freerun_clk) disable iff (~prim_gated_rst_b)
    (i_hqm_iosf_tgt_xlate.lli_phdr.length > 'd64) & lli_phdr_val)                                     ;


`endif

endmodule : hqm_iosfp_core

